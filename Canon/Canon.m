//
//  Canon.m
//  Compiler
//
//  Created by Duan Dajun on 12/16/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "Canon.h"
#import "TmpTemp.h"

@interface TreeCallStmt : TreeStmt
{
  TreeCall *call;
}
@property (readonly) TreeCall *call;
- (id)initWithCall:(TreeCall *)aCall;
+ (id)callStmtWithCall:(TreeCall *)aCall;
@end

@implementation TreeCallStmt
@synthesize call;
- (id)initWithCall:(TreeCall *)aCall
{
  if (self = [super init])
    call = [aCall retain];
  return self;
}
- (TreeExprList *)kids
{
  return [call kids];
}
- (TreeStmt *)buildWithExprList:(TreeExprList *)kids
{
  return [TreeExprStmt exprStmtWithExpr:[call buildWithExprList:kids]];
}
- (void)dealloc
{
  [call release];
  [super dealloc];
}
+ (id)callStmtWithCall:(TreeCall *)aCall
{
  return [[[TreeCallStmt alloc] initWithCall:aCall] autorelease];
}
@end

@interface TreeMoveCall : TreeStmt
{
	TreeTemp *dst;
  TreeCall *src;
}
@property (readonly) TreeTemp *dst;
@property (readonly) TreeCall *src;
- (id)initWithTemp:(TreeTemp *)aTemp call:(TreeCall *)aCall;
+ (id)moveCallWithTemp:(TreeTemp *)aTemp withCall:(TreeCall *)aCall;
@end

@implementation TreeMoveCall
@synthesize src, dst;
- (id)initWithTemp:(TreeTemp *)aTemp call:(TreeCall *)aCall
{
  if (self = [super init]) {
    dst = [aTemp retain];
    src = [aCall retain];
  }
  return self;
}
- (TreeExprList *)kids
{
  return [src kids];
}
- (TreeStmt *)buildWithExprList:(TreeExprList *)kids
{
  return [TreeMove moveWithDestination:self.dst source:[self.src buildWithExprList:kids]];
}
- (void)dealloc
{
  [dst release];
  [src release];
  [super dealloc];
}
+ (id)moveCallWithTemp:(TreeTemp *)aTemp withCall:(TreeCall *)aCall
{
  return [[[TreeMoveCall alloc] initWithTemp:aTemp call:aCall] autorelease];
}
@end

@interface TreeStmtExprList : NSObject
{
  TreeStmt *stmt;
  TreeExprList *exprlist;
}
@property (readonly) TreeStmt *stmt;
@property (readonly) TreeExprList *exprlist;
- (id)initWithStmt:(TreeStmt *)aStmt exprList:(TreeExprList *)aList;
+ (id)stmtExprListWithStmt:(TreeStmt *)aStmt exprList:(TreeExprList *)aList;
@end

@implementation TreeStmtExprList
@synthesize stmt, exprlist;
- (id)initWithStmt:(TreeStmt *)aStmt exprList:(TreeExprList *)aList
{
  if (self = [super init]) {
    stmt = [aStmt retain];
    exprlist = [aList retain];
  }
  return self;
}
- (void)dealloc
{
  [stmt release];
  [exprlist release];
  [super dealloc];
}
+ (id)stmtExprListWithStmt:(TreeStmt *)aStmt exprList:(TreeExprList *)aList
{
  return [[[TreeStmtExprList alloc] initWithStmt:aStmt exprList:aList] autorelease];
}
@end

static TreeStmtExprList *nopnil = nil;


@implementation Canon
+ (void)initialize
{
  if (self == [Canon class])
    nopnil = [TreeStmtExprList 
              stmtExprListWithStmt:[TreeExprStmt exprStmtWithExpr:[TreeConst constWithInt:0]]
              exprList:nil];
  
}
+ (BOOL)doesStmt:(TreeStmt *)aStmt commuteWithExpr:(TreeExpr *)anExpr
{
  return [Canon isNop:aStmt] ||
         [anExpr isMemberOfClass:[TreeName class]] ||
         [anExpr isMemberOfClass:[TreeConst class]];
}
+ (BOOL)isNop:(TreeStmt *)aStmt
{
  return [aStmt isMemberOfClass:[TreeExprStmt class]] && 
  			 [((TreeExprStmt *)aStmt).expr isMemberOfClass:[TreeConst class]];
}
+ (TreeStmt *)seqWithFirstStmt:(TreeStmt *)stmt1 secondStmt:(TreeStmt *)stmt2
{
  if ([Canon isNop:stmt1])
    return stmt2;
  else if ([Canon isNop:stmt2])
    return stmt1;
  else
    return [TreeSeq	 seqWithFirstStmt:stmt1 secondStmt:stmt2];
}
+ (TreeStmt *)seqWithFirstStmt:(TreeStmt *)stmt1, ...
{
  va_list args;
  va_start(args, stmt1);
  TreeStmt *s;
  TreeStmt *ans = stmt1;
  for (;s = va_arg(args, TreeStmt *), s != nil;)
    ans = [Canon seqWithFirstStmt:ans secondStmt:s];
  return ans;
}
+ (TreeStmt *)doStmtWithMove:(TreeMove *)aStmt
{
  if ([aStmt.dst isMemberOfClass:[TreeTemp class]] &&
      [aStmt.src isMemberOfClass:[TreeCall class]])
    return [Canon reorderStmt:[TreeMoveCall moveCallWithTemp:(TreeTemp *)aStmt.dst
                                                    withCall:(TreeCall *)aStmt.src]];
  else if ([aStmt.dst isMemberOfClass:[TreeESeq class]])
    return [Canon doStmtWithStmt:[TreeSeq	seqWithFirstStmt:((TreeESeq *)aStmt.dst).stmt
                                                secondStmt:[TreeMove moveWithDestination:((TreeESeq *)aStmt.dst).expr
                                                                                  source:aStmt.src]]];
  return [Canon reorderStmt:aStmt];
}
+	(TreeStmt *)doStmtWithStmt:(TreeStmt *)aStmt
{
  if ([aStmt isMemberOfClass:[TreeSeq class]])
    return [Canon seqWithFirstStmt:[Canon doStmtWithStmt:((TreeSeq *)aStmt).first]
                        secondStmt:[Canon doStmtWithStmt:((TreeSeq *)aStmt).second]];
  else if ([aStmt isMemberOfClass:[TreeMove class]])
    return [Canon doStmtWithMove:(TreeMove *)aStmt];
  else if ([aStmt isMemberOfClass:[TreeExprStmt class]]) {
  	if ([((TreeExprStmt *)aStmt).expr isMemberOfClass:[TreeCall class]])
      return [Canon reorderStmt:[TreeCallStmt callStmtWithCall:(TreeCall *)((TreeExprStmt *)aStmt).expr]];
    else
      return [Canon reorderStmt:aStmt];
  }
  return [Canon reorderStmt:aStmt];
}
+ (TreeESeq *)doExprWithExpr:(TreeExpr *)anExpr
{
  if ([anExpr isMemberOfClass:[TreeESeq class]]) {
    TreeStmt *stmts = [Canon doStmtWithStmt:((TreeESeq *)anExpr).stmt];
    TreeESeq *eseq = [Canon doExprWithExpr:((TreeESeq *)anExpr).expr];
    return [TreeESeq eseqWithStmt:[Canon seqWithFirstStmt:stmts secondStmt:eseq.stmt]
                             expr:eseq.expr];
  }
  return [Canon reorderExpr:anExpr];
}
+ (TreeStmtExprList *)reorderWithExprList:(TreeExprList *)aList
{
  if (!aList) {
    return nopnil;
  } else {
    TreeExpr *e = aList.head;
    if ([e isMemberOfClass:[TreeCall class]]) {
      TreeTemp *t = [TreeTemp treeTempWithTemp:[TmpTemp temp]];
      TreeExpr *e1 = [TreeESeq eseqWithStmt:[TreeMove moveWithDestination:t
                                                                   source:e]
                                       expr:t];
      return [Canon reorderWithExprList:[TreeExprList exprListWithExpr:e1 exprList:aList.tail]];
    } else {
      TreeESeq *e1 = [Canon doExprWithExpr:e];
      TreeStmtExprList *l = [Canon reorderWithExprList:aList.tail];
      if ([Canon doesStmt:l.stmt commuteWithExpr:e1.expr])
        return [TreeStmtExprList stmtExprListWithStmt:[Canon seqWithFirstStmt:e1.stmt
                                                                   secondStmt:l.stmt]
                                             exprList:[TreeExprList exprListWithExpr:e1.expr
                                                                            exprList:l.exprlist]];
      else {
        TreeTemp *t = [TreeTemp treeTempWithTemp:[TmpTemp temp]];
        return [TreeStmtExprList stmtExprListWithStmt:[Canon seqWithFirstStmt:
                                                       e1.stmt,
                                                       [TreeMove moveWithDestination:t
                                                                              source:e1.expr],
                                                       l.stmt, nil]
                                             exprList:[TreeExprList exprListWithExpr:t
                                                                            exprList:l.exprlist]];
      }

    }
  }
}
+ (TreeStmt *)reorderStmt:(TreeStmt *)aStmt
{
  TreeStmtExprList *l = [Canon reorderWithExprList:[aStmt kids]];
  return [Canon seqWithFirstStmt:l.stmt secondStmt:[aStmt buildWithExprList:l.exprlist]];
}
+ (TreeESeq *)reorderExpr:(TreeExpr *)anExpr
{
  TreeStmtExprList *l = [Canon reorderWithExprList:[anExpr kids]];
	return [TreeESeq eseqWithStmt:l.stmt expr:[anExpr buildWithExprList:l.exprlist]];
}
+ (TreeStmtList *)linearStmt:(TreeStmt *)aStmt stmtList:(TreeStmtList *)alist
{
  if ([aStmt isMemberOfClass:[TreeSeq class]])
    return [Canon linearStmt:((TreeSeq *)aStmt).first
                    stmtList:[Canon linearStmt:((TreeSeq *)aStmt).second stmtList:alist]];
  else
    return [TreeStmtList stmtListWithStmt:aStmt stmtList:alist];
}
+ (TreeStmtList *)linearizeStmt:(TreeStmt *)aStmt
{
  return [Canon linearStmt:[self doStmtWithStmt:aStmt] stmtList:nil];
}
@end
