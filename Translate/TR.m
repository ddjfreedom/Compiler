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
#import "TreeExpr.h"
#import "TreeConst.h"
#import "TreeName.h"
#import "TreeESeq.h"
#import "TreeTemp.h"
#import "TreeBinop.h"
#import "TreeCall.h"
#import "TreeMem.h"
#import "TreeLabel.h"
#import "TreeMove.h"
#import "TreeSeq.h"
#import "TreeExprStmt.h"
#import "TreeCJump.h"
#import "TreeJump.h"
#import "TREx.h"
#import "TRNx.h"
#import "TRRelCx.h"
#import "TRIfThenElseExpr.h"

static int wordSize = 0;
static NSMutableDictionary *dict = nil;

@interface TR()
+ (TreeStmt *)initSingleFieldWithBase:(TreeTemp *)base offset:(TreeExpr *)offset initValue:(TreeExpr *)initValue;
+ (TRExpr *)complementExpr:(TRExpr *)expr;
@end

@implementation TR
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
+ (void)setWordSize:(int)size
{
  wordSize = size;
}
+ (TreeStmt *)initSingleFieldWithBase:(TreeTemp *)base offset:(TreeExpr *)offset initValue:(TreeExpr *)initValue
{
  return [TreeMove
          moveWithDestination:[TreeMem memWithExpr:[TreeBinop binopWithLeftExpr:base
                                                                       binaryOp:TreePlus
                                                                      rightExpr:offset]]
          source:initValue];
}
+ (TRExpr *)simpleVarWithAccess:(TRAccess *)anAcc level:(TRLevel *)aLevel
{
  TreeExpr * expr = [TreeTemp treeTempWithTemp:aLevel.frame.fp];
  TRLevel *tmplevel = aLevel;
  // follow static link
  while (anAcc.level != tmplevel) {
    expr = [((TRAccess *)[tmplevel.formals objectAtIndex:0]).acc exprWithFramePointer:expr];
    tmplevel = tmplevel.parent;
  }
  return [TREx exWithTreeExpr:[anAcc.acc exprWithFramePointer:expr]];
}
+ (TRExpr *)arrayVarWithBase:(TRExpr *)base subscript:(TRExpr *)sub level:(TRLevel *)aLevel
{
  return [TREx exWithTreeExpr:[TreeMem memWithExpr:[TreeBinop
                                                    binopWithLeftExpr:[base unEx]
                                                    binaryOp:TreePlus
                                                    rightExpr:[TreeBinop
                                                               binopWithLeftExpr:[sub unEx]
                                                               binaryOp:TreeMultiply
                                                               rightExpr:[TreeConst constWithInt:wordSize]]]]];
}
+ (TRExpr *)fieldVarWithVar:(TRExpr *)var 
                       type:(SemanticRecordType *)type 
                      field:(Symbol *)field 
                      level:(TRLevel *)aLevel
{
  NSUInteger offset = [type indexOfField:field];
  return [TREx exWithTreeExpr:[TreeMem memWithExpr:[TreeBinop
                                                    binopWithLeftExpr:[var unEx]
                                                    binaryOp:TreePlus
                                                    rightExpr:[TreeBinop 
                                                               binopWithLeftExpr:[TreeConst constWithInt:offset]
                                                               binaryOp:TreeMultiply
                                                               rightExpr:[TreeConst constWithInt:wordSize]]]]]; 
}
+ (TRExpr *)nilExpr 
{
  // TODO: may need some modification
  return [TREx exWithTreeExpr:[TreeConst constWithInt:0]];
}
+ (TRExpr *)intConstWithInt:(int)value
{
  return [TREx exWithTreeExpr:[TreeConst constWithInt:value]];
}
+ (TRExpr *)breakExprWithDoneLabel:(NSArray *)labels
{
  return [TRNx nxWithStmt:[TreeJump jumpWithLabel:[labels lastObject]]];
}
+ (TRExpr *)seqExprWithExprs:(NSArray *)exprs
{
  int i = exprs.count;
  if (!i) return [TRNx nxWithStmt:nil];
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
  if ([[exprs lastObject] isMemberOfClass:[TRNx class]])
    return [TreeSeq seqWithFirstStmt:seq secondStmt:[(TRExpr *)[exprs lastObject] unNx]];
  else
    return [TreeESeq eseqWithStmt:seq expr:[(TRExpr *)[exprs lastObject] unEx]];
}
+ (TRExpr *)arrayExprWithSize:(TRExpr *)size initialValue:(TRExpr *)inititalValue level:(TRLevel *)level
{
  TreeTemp *r = [TreeTemp treeTempWithTemp:[TmpTemp temp]];
  TreeExpr *actualSize = [TreeBinop binopWithLeftExpr:[size unEx] 
                                             binaryOp:TreeMultiply
                                            rightExpr:[TreeConst constWithInt:level.frame.wordSize]];
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
+ (TRExpr *)recordExprWithType:(SemanticRecordType *)type initialValues:(NSDictionary *)values level:(TRLevel *)level
{
  TreeTemp *r = [TreeTemp treeTempWithTemp:[TmpTemp temp]];
  int i = type.count;
  TreeSeq *seq = [TreeSeq 
                  seqWithFirstStmt:[TR initSingleFieldWithBase:r
                                                        offset:[TreeConst constWithInt:(i-2)*wordSize]
                                                     initValue:[values objectForKey:[type fieldAtIndex:i-2]]]
                  secondStmt:[TR initSingleFieldWithBase:r
                                                  offset:[TreeConst constWithInt:(i-1)*wordSize]
                                               initValue:[values objectForKey:[type fieldAtIndex:i-1]]]];
  for (i -= 3; i >= 0; i--)
    seq = [TreeSeq seqWithFirstStmt:[TR initSingleFieldWithBase:r
                                                         offset:[TreeConst constWithInt:i*wordSize]
                                                      initValue:[values objectForKey:[type fieldAtIndex:i]]]
                         secondStmt:seq];
  seq = [TreeSeq 
         seqWithFirstStmt:[TreeMove 
                           moveWithDestination:r
                           source:[level.frame
                                   externalCallWithName:@"malloc"
                                   arguments:[TreeConst constWithInt:(type.count*wordSize)]]]
         secondStmt:seq];
  return [TREx exWithTreeExpr:[TreeESeq eseqWithStmt:seq expr:r]];
}
+ (TRExpr *)assignExprWithLValue:(TRExpr *)left rValue:(TRExpr *)right
{
  return [TRNx nxWithStmt:[TreeMove moveWithDestination:[left unEx] source:[right unEx]]];
}
+ (TRExpr *)binopExprWithLeftOperand:(SemanticExpr *)left 
                                  op:(AbstractSyntaxOperation)op 
                        rightOperand:(SemanticExpr *)right
{
  if ([left.type isMemberOfClass:[SemanticIntType class]]) {
  	switch (op) {
  		case plus: case minus: case multiply: case divide:
    	  return [TREx exWithTreeExpr:[TreeBinop
                                     binopWithLeftExpr:[left.expr unEx]
                                     binaryOp:[[dict objectForKey:[NSNumber numberWithInt:op]] intValue]
                                     rightExpr:[right.expr unEx]]];
    	case eq: case ne: case lt: case gt: case le: case ge:
    	  return [TRRelCx relcxWithLeftOperand:[left.expr unEx] 
    	                                    op:[[dict objectForKey:[NSNumber numberWithInt:op]] intValue] 
    	                          rightOperand:[right.expr unEx]];
  	}
  }
  // TODO: need to handle string comparison
  NSAssert(NO, @"Unknown Operator in binopExprWithLeftOperand:op:rightOperand:");
  return nil;
}
+ (TRExpr *)ifExprWithTest:(TRExpr *)test thenClause:(TRExpr *)thenClause elseClause:(TRExpr *)elseClause
{
  return [TRIfThenElseExpr exprWithTest:test thenClause:thenClause elseClause:elseClause];
}
+ (TRExpr *)whileExprWithTest:(TRExpr *)test body:(TRExpr *)body doneLabels:(NSMutableArray *)labels
{
  TmpLabel *t = [TmpLabel label];
  TmpLabel *done = [TmpLabel label];
  TreeSeq *seq = [TreeSeq seqWithFirstStmt:[TreeJump jumpWithLabel:t]
                                secondStmt:[TreeLabel treeLabelWithLabel:done]];
  seq = [TreeSeq seqWithFirstStmt:[body unNx] secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[[TR ifExprWithTest:[TR complementExpr:test]
                                          thenClause:[TreeJump jumpWithLabel:done]
                                          elseClause:nil] unNx]
                       secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[TreeLabel treeLabelWithLabel:t] secondStmt:seq];
  [labels addObject:done];
  return [TRNx nxWithStmt:seq];
}
+ (TRExpr *)callExprWithFunc:(SemanticFuncEntry *)func Arguments:(NSArray *)args level:(TRLevel *)level
{
  TreeExprList *paras = args.count ? [TreeExprList exprListWithExpr:[(TRExpr *)[args lastObject] unEx]] : nil;
  if (paras) {
    int i = args.count - 2;
    for (; i >= 0; i--)
      paras = [TreeExprList exprListWithExpr:[(TRExpr *)[args objectAtIndex:i] unEx] exprList:paras];
  }
  paras = [TreeExprList exprListWithExpr:[TreeTemp treeTempWithTemp:func.level.frame.fp] exprList:paras];
  return [TREx exWithTreeExpr:[TreeCall callWithExpr:[TreeName nameWithLabel:func.label]
                                            exprList:paras]];
}

+ (TRExpr *)varDeclWithVar:(SemanticVarEntry *)var initialValue:(TRExpr *)initialValue
{
  return [TRNx nxWithStmt:[TreeMove 
                           moveWithDestination:[var.access.acc
                                                exprWithFramePointer:[TreeTemp treeTempWithTemp:var.access.level.frame.fp]]
                           source:[initialValue unEx]]];
}
+ (TRExpr *)complementExpr:(TRExpr *)expr
{
  return [TREx exWithTreeExpr:[TreeBinop binopWithLeftExpr:[expr unEx]
                                                  binaryOp:TreeXor
                                                 rightExpr:[TreeConst constWithInt:~0]]];
}
@end
