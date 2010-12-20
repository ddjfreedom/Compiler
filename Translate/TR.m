//
//  TR.m
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OperationExpression.h"
#import "TR.h"
#import "TREx.h"
#import "TRNx.h"
#import "TRRelCx.h"
#import "TRIfThenElseExpr.h"
#import "TRProcFrag.h"
#import "TRDataFrag.h"
#import "Tree.h"

static NSMutableDictionary *dict = nil;

@interface TR()
- (TreeStmt *)singleFieldInitWithBase:(TreeTemp *)base offset:(TreeExpr *)offset initValue:(TRExpr *)initValue;
- (TRExpr *)complementExpr:(TRExpr *)expr;
@end

@implementation TR
@synthesize wordSize;
- (NSArray *)frags
{
  return frags;
}
- (id)initWithFrame:(Frame *)aFrame
{
  if (self = [super init]) {
    frags = [[NSMutableArray alloc] init];
    frame = [aFrame retain];
    wordSize = 0;
  }
  return self;
}
- (TmpLabel *)generateDoneLabel
{
  return [TmpLabel label];
}
- (void)addMainExpr:(TRExpr *)anExpr level:(TRLevel *)level
{
  [frags insertObject:[TRProcFrag procFragWithStme:[anExpr unNx] frame:level.frame] atIndex:0];
}
- (TRExpr *)simpleVarWithAccess:(TRAccess *)anAcc level:(TRLevel *)aLevel
{
  TreeExpr *expr = [TreeTemp treeTempWithTemp:aLevel.frame.fp];
  TRLevel *tmplevel = aLevel;
  // follow static link
  while (anAcc.level != tmplevel) {
    expr = [((TRAccess *)[tmplevel.formals objectAtIndex:0]).acc exprWithFramePointer:expr];
    tmplevel = tmplevel.parent;
  }
  return [TREx exWithTreeExpr:[anAcc.acc exprWithFramePointer:expr]];
}
- (TRExpr *)arrayVarWithBase:(TRExpr *)base subscript:(TRExpr *)sub level:(TRLevel *)aLevel
{
  return [TREx exWithTreeExpr:[TreeMem memWithExpr:[TreeBinop
                                                    binopWithLeftExpr:[base unEx]
                                                    binaryOp:TreePlus
                                                    rightExpr:[TreeBinop
                                                               binopWithLeftExpr:[sub unEx]
                                                               binaryOp:TreeMultiply
                                                               rightExpr:[TreeConst constWithInt:wordSize]]]]];
}
- (TRExpr *)fieldVarWithVar:(TRExpr *)var 
                       type:(SemanticRecordType *)type 
                      field:(Symbol *)field 
                      level:(TRLevel *)aLevel
{
  NSUInteger offset = [type indexOfField:field];
  return [TREx exWithTreeExpr:[TreeMem memWithExpr:[TreeBinop
                                                    binopWithLeftExpr:[var unEx]
                                                    binaryOp:TreePlus
                                                    rightExpr:[TreeConst constWithInt:offset*wordSize]]]]; 
}
- (TRExpr *)nilExpr 
{
  // TODO: may need some modification
  return [TREx exWithTreeExpr:[TreeConst constWithInt:0]];
}
- (TRExpr *)intConstWithInt:(int)value
{
  return [TREx exWithTreeExpr:[TreeConst constWithInt:value]];
}
- (TRExpr *)stringLitWithString:(NSString *)string
{
  TmpLabel *label = [TmpLabel label];
  [frags addObject:[TRDataFrag dataFragWithString:string label:label]];
  return [TREx exWithTreeExpr:[TreeName nameWithLabel:label]];
}
- (TRExpr *)breakExprWithDoneLabel:(TmpLabel *)label
{
  return [TRNx nxWithStmt:[TreeJump jumpWithLabel:label]];
}
- (TRExpr *)seqExprWithExprs:(NSArray *)exprs
{
  int i = exprs.count;
  if (!i) return nil;
  if (i == 1)
    if ([[exprs lastObject] isVoidType])
      return [TRNx nxWithStmt:[(TRExpr *)[exprs lastObject] unNx]];
  	else
      return [TREx exWithTreeExpr:[(TRExpr *)[exprs lastObject] unEx]];
  TreeStmt *seq;
  if (i >= 3) {
    seq = [TreeSeq seqWithFirstStmt:[(TRExpr *)[exprs objectAtIndex:i-3] unNx]
                         secondStmt:[(TRExpr *)[exprs objectAtIndex:i-2] unNx]];
    i -= 4;
    for (; i >= 0; --i)
      seq = [TreeSeq seqWithFirstStmt:[(TRExpr *)[exprs objectAtIndex:i] unNx]
                           secondStmt:seq];
  } else
    seq = [(TRExpr *)[exprs objectAtIndex:0] unNx];
  if ([[exprs lastObject] isVoidType])
    return [TRNx nxWithStmt:[TreeSeq seqWithFirstStmt:seq secondStmt:[(TRExpr *)[exprs lastObject] unNx]]];
  else
    return [TREx exWithTreeExpr:[TreeESeq eseqWithStmt:seq expr:[(TRExpr *)[exprs lastObject] unEx]]];
}
// ???: type-id [expr] of type-id2 [expr2] of 0
- (TRExpr *)arrayExprWithSize:(TRExpr *)size initialValue:(TRExpr *)inititalValue level:(TRLevel *)level
{
  TreeTemp *r = [TreeTemp treeTempWithTemp:[TmpTemp temp]];
  TreeExpr *actualSize;
  if ([[size unEx] isMemberOfClass:[TreeConst class]])
    actualSize = [TreeConst constWithInt:((TreeConst *)[size unEx]).value * wordSize];
  else 
    actualSize = [TreeBinop binopWithLeftExpr:[size unEx]
    	                               binaryOp:TreeMultiply
      	                            rightExpr:[TreeConst constWithInt:wordSize]];
  TreeSeq *seq;
  seq = [TreeSeq 
         seqWithFirstStmt:[TreeMove 
                           moveWithDestination:r 
                           source:[level.frame externalCallWithName:@"malloc"
                                                          arguments:[TreeExprList exprListWithExpr:actualSize]]]
         secondStmt:[TreeExprStmt 
                     exprStmtWithExpr:[level.frame
                                       externalCallWithName:@"initArray"
                                       arguments:[TreeExprList 
                                                  exprListWithExprs:r, [size unEx], [inititalValue unEx], nil]]]];
  return [TREx exWithTreeExpr:[TreeESeq eseqWithStmt:seq expr:r]];
}
- (TRExpr *)recordExprWithType:(SemanticRecordType *)type initialValues:(NSDictionary *)values level:(TRLevel *)level
{
  TreeTemp *r = [TreeTemp treeTempWithTemp:[TmpTemp temp]];
  int i = type.count;
  TreeStmt *seq;
  if (i >= 2) {
  	seq = [TreeSeq seqWithFirstStmt:[self singleFieldInitWithBase:r
                                                           offset:[TreeConst constWithInt:(i-2)*wordSize]
                                                        initValue:[values objectForKey:[type fieldAtIndex:i-2]]]
                         secondStmt:[self singleFieldInitWithBase:r
                                                           offset:[TreeConst constWithInt:(i-1)*wordSize]
                                                        initValue:[values objectForKey:[type fieldAtIndex:i-1]]]];
    for (i -= 3; i >= 0; i--)
      seq = [TreeSeq seqWithFirstStmt:[self singleFieldInitWithBase:r
                                                             offset:[TreeConst constWithInt:i*wordSize]
                                                          initValue:[values objectForKey:[type fieldAtIndex:i]]]
                           secondStmt:seq];
  } else {
    seq = [self singleFieldInitWithBase:r 
                                 offset:[TreeConst constWithInt:0]
                              initValue:[values objectForKey:[type fieldAtIndex:0]]];
  }
  seq = [TreeSeq 
         seqWithFirstStmt:[TreeMove 
                           moveWithDestination:r
                           source:[level.frame
                                   externalCallWithName:@"malloc"
                                   arguments:[TreeExprList exprListWithExpr:[TreeConst constWithInt:(type.count*wordSize)]]]]
         secondStmt:seq];
  return [TREx exWithTreeExpr:[TreeESeq eseqWithStmt:seq expr:r]];
}
- (TRExpr *)assignExprWithLValue:(TRExpr *)left rValue:(TRExpr *)right
{
  return [TRNx nxWithStmt:[TreeMove moveWithDestination:[left unEx] source:[right unEx]]];
}
- (int)calculateLeftOperand:(int)left op:(AbstractSyntaxOperation)op rightOperand:(int)right
{
  switch (op) {
  	case plus: return left + right;
    case minus: return left - right;
    case multiply: return left * right;
    case divide: return left / right;
    default: NSAssert(NO, @"Invalid Binop");
  }
  return 0;
}
- (TRExpr *)binopExprWithLeftOperand:(SemanticExpr *)left 
                                  op:(AbstractSyntaxOperation)op 
                        rightOperand:(SemanticExpr *)right
                               level:(TRLevel *)level
{
  if (![left.type isMemberOfClass:[SemanticStringType class]]) {
  	switch (op) {
  		case plus: case minus: case multiply: case divide:
        if ([left.expr isMemberOfClass:[TreeConst class]] &&
            [right.expr isMemberOfClass:[TreeConst class]])
          return [TREx exWithTreeExpr:[TreeConst constWithInt:[self calculateLeftOperand:((TreeConst *)left.expr).value
                                                                                      op:op
                                                                            rightOperand:((TreeConst *)right.expr).value]]];
    	  return [TREx exWithTreeExpr:[TreeBinop
                                     binopWithLeftExpr:[left.expr unEx]
                                     binaryOp:[[dict objectForKey:[NSNumber numberWithInt:op]] intValue]
                                     rightExpr:[right.expr unEx]]];
    	case eq: case ne: case lt: case gt: case le: case ge:
    	  return [TRRelCx relcxWithLeftOperand:[left.expr unEx] 
    	                                    op:[[dict objectForKey:[NSNumber numberWithInt:op]] intValue] 
    	                          rightOperand:[right.expr unEx]];
  	}
  } else {
    return [TRRelCx relcxWithLeftOperand:[level.frame externalCallWithName:@"strcmp"
                                                                 arguments:[TreeExprList exprListWithExprs:
                                                                            [left.expr unEx], [right.expr unEx], nil]]
                                      op:[[dict objectForKey:[NSNumber numberWithInt:op]] intValue]
                            rightOperand:[TreeConst constWithInt:0]];
  }
  // TODO: need to handle string comparison
  NSAssert(NO, @"Unknown Operator in binopExprWithLeftOperand:op:rightOperand:");
  return nil;
}
- (TRExpr *)ifExprWithTest:(TRExpr *)test thenClause:(TRExpr *)thenClause elseClause:(TRExpr *)elseClause
{
  return [TRIfThenElseExpr exprWithTest:test thenClause:thenClause elseClause:elseClause];
}
- (TRExpr *)whileExprWithTest:(TRExpr *)test body:(TRExpr *)body doneLabel:(TmpLabel *)done
{
  TmpLabel *t = [TmpLabel label];
  TreeSeq *seq = [TreeSeq seqWithFirstStmt:[TreeJump jumpWithLabel:t]
                                secondStmt:[TreeLabel treeLabelWithLabel:done]];
  seq = [TreeSeq seqWithFirstStmt:[body unNx] secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[[self ifExprWithTest:[self complementExpr:test]
                                          thenClause:[TRNx nxWithStmt:[TreeJump jumpWithLabel:done]]
                                          elseClause:nil] unNx]
                       secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[TreeLabel treeLabelWithLabel:t] secondStmt:seq];
  return [TRNx nxWithStmt:seq];
}
- (TRExpr *)forExprWithIndex:(SemanticVarEntry *)index
                  lowerBound:(TRExpr *)lower
                  upperBound:(TRExpr *)upper
                        body:(TRExpr *)body
                   doneLabel:(TmpLabel *)done
{ 
  TmpLabel *loop = [TmpLabel label];
  TmpLabel *con = [TmpLabel label];
  TreeTemp *fp = [TreeTemp treeTempWithTemp:index.access.level.frame.fp];
  TreeSeq *seq;
  TreeExpr *low = [index.access.acc exprWithFramePointer:fp];
  TreeExpr *high = [[index.access.level generateLocal:YES].acc exprWithFramePointer:fp];
  TreeExpr *ans = nil;
  if (![body isVoidType])
  	ans = [[index.access.level generateLocal:YES].acc exprWithFramePointer:fp];
  seq = [TreeSeq seqWithFirstStmt:[TreeJump jumpWithLabel:loop] secondStmt:[TreeLabel treeLabelWithLabel:done]];
  seq = [TreeSeq seqWithFirstStmt:[TreeMove moveWithDestination:low
                                                         source:[TreeBinop binopWithLeftExpr:low
                                                                                    binaryOp:TreePlus
                                                                                   rightExpr:[TreeConst constWithInt:1]]]
                       secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[TreeLabel treeLabelWithLabel:con] secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[TreeCJump cJumpWithLeftExpr:low
                                                   reloperator:TreeGE
                                                     rightExpr:high
                                                     trueLabel:done
                                                    falseLabel:con]
                       secondStmt:seq];
  if (ans)
    seq = [TreeSeq seqWithFirstStmt:[TreeMove moveWithDestination:ans
                                                           source:[body unEx]]
                         secondStmt:seq];
  else
  	seq = [TreeSeq seqWithFirstStmt:[body unNx] secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[TreeLabel treeLabelWithLabel:loop] secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[TreeCJump cJumpWithLeftExpr:low
                                                   reloperator:TreeLE
                                                     rightExpr:high
                                                     trueLabel:loop
                                                    falseLabel:done]
                       secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[TreeMove moveWithDestination:high source:[upper unEx]] secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[TreeMove moveWithDestination:low source:[lower unEx]] secondStmt:seq];
  if (ans)
    return [TREx exWithTreeExpr:[TreeESeq eseqWithStmt:seq expr:ans]];
  else
    return [TRNx nxWithStmt:seq];
}
- (TRExpr *)callExprWithFunc:(SemanticFuncEntry *)func Arguments:(NSArray *)args level:(TRLevel *)level
{
  TreeExprList *paras = args.count ? [TreeExprList exprListWithExpr:[(TRExpr *)[args lastObject] unEx]] : nil;
  if (paras) {
    int i = args.count - 2;
    for (; i >= 0; i--)
      paras = [TreeExprList exprListWithExpr:[(TRExpr *)[args objectAtIndex:i] unEx] exprList:paras];
  }
  paras = [TreeExprList exprListWithExpr:[TreeTemp treeTempWithTemp:func.level.frame.fp] exprList:paras];
  if (func.returnType != [SemanticVoidType sharedVoidType])
  	return [TREx exWithTreeExpr:[TreeCall callWithExpr:[TreeName nameWithLabel:func.label]
    	                                        exprList:paras]];
  else
    return [TRNx nxWithStmt:[TreeExprStmt exprStmtWithExpr:[TreeCall callWithExpr:[TreeName nameWithLabel:func.label]
                                                                         exprList:paras]]];
}

- (TRExpr *)varDeclWithVar:(SemanticVarEntry *)var initialValue:(TRExpr *)initialValue
{
  return [TRNx nxWithStmt:[TreeMove 
                           moveWithDestination:[var.access.acc
                                                exprWithFramePointer:[TreeTemp treeTempWithTemp:var.access.level.frame.fp]]
                           source:[initialValue unEx]]];
}
- (void)funcDeclWithBody:(TRExpr *)body level:(TRLevel *)level
{
  TreeStmt *stmt;
  if ([body isVoidType])
    stmt = [body unNx];
  else
    stmt = [TreeMove moveWithDestination:[TreeTemp treeTempWithTemp:level.frame.rv] source:[body unEx]];
  stmt = [level.frame procEntryExit1WithStmt:stmt];
  [frags addObject:[TRProcFrag procFragWithStme:stmt frame:level.frame]];
}
// helper methods
- (TreeStmt *)singleFieldInitWithBase:(TreeTemp *)base offset:(TreeExpr *)offset initValue:(TRExpr *)initValue
{
  return [TreeMove
          moveWithDestination:[TreeMem memWithExpr:[TreeBinop binopWithLeftExpr:base
                                                                       binaryOp:TreePlus
                                                                      rightExpr:offset]]
          source:[initValue unEx]];
}
- (TRExpr *)complementExpr:(TRExpr *)expr
{
  return [TREx exWithTreeExpr:[TreeCall callWithExpr:[TreeName nameWithLabel:[TmpLabel labelWithString:@"not"]]
                                            exprList:[TreeExprList exprListWithExprs:
                                                      [TreeTemp treeTempWithTemp:frame.fp],
                                                      [expr unEx], nil]]];
}
- (void)dealloc
{
  [frags release];
  [frame release];
  [super dealloc];
}
+ (void)initialize
{
  if (self == [TR class]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    dict = [[NSMutableDictionary alloc] 
            initWithObjectsAndKeys:
            [NSNumber numberWithInt:TreePlus], [NSNumber numberWithInt:plus],
            [NSNumber numberWithInt:TreeMinus], [NSNumber numberWithInt:minus],
            [NSNumber numberWithInt:TreeMultiply], [NSNumber numberWithInt:multiply],
            [NSNumber numberWithInt:TreeDivide], [NSNumber numberWithInt:divide],
            [NSNumber numberWithInt:TreeEQ], [NSNumber numberWithInt:eq],
            [NSNumber numberWithInt:TreeNE], [NSNumber numberWithInt:ne],
            [NSNumber numberWithInt:TreeLT], [NSNumber numberWithInt:lt],
            [NSNumber numberWithInt:TreeGT], [NSNumber numberWithInt:gt],
            [NSNumber numberWithInt:TreeLE], [NSNumber numberWithInt:le],
            [NSNumber numberWithInt:TreeGE], [NSNumber numberWithInt:ge], nil];
    [pool drain];
  }
}
@end
