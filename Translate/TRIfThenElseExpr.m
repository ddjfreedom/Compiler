//
//  TRIfThenElseExpr.m
//  Compiler
//
//  Created by Duan Dajun on 12/9/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TRIfThenElseExpr.h"
#import "TRNx.h"
#import "TmpTemp.h"
#import "TreeLabel.h"
#import "TreeSeq.h"
#import "TreeMove.h"
#import "TreeJump.h"
#import "TreeCJump.h"
#import "TreeConst.h"
#import "TreeESeq.h"
#import "TreeTemp.h"

@implementation TRIfThenElseExpr
- (id)initWithTest:(TRExpr *)aTest thenClause:(TRExpr *)tClause elseClause:(TRExpr *)eClause
{
  if (self = [super init]) {
    test = [aTest retain];
    thenClause = [tClause retain];
    elseClause = [eClause retain];
    tL = [[TmpLabel alloc] init];
    eL = [[TmpLabel alloc] init];
    joinL = [[TmpLabel alloc] init];
  }
  return self;
}
- (TreeExpr *)unEx
{
  TreeTemp *r = [TreeTemp treeTempWithTemp:[TmpTemp temp]];
  TreeLabel *t = [TreeLabel treeLabelWithLabel:tL];
  TreeLabel *e = [TreeLabel treeLabelWithLabel:eL];
  TreeLabel *join = [TreeLabel treeLabelWithLabel:joinL];
  
  TreeSeq *seq = [TreeSeq seqWithFirstStmt:[TreeJump jumpWithLabel:joinL] secondStmt:join];
  seq = [TreeSeq seqWithFirstStmt:[TreeMove moveWithDestination:r
                                                         source:[elseClause unEx]]
                       secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:e secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[TreeJump jumpWithLabel:joinL] secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[TreeMove moveWithDestination:r
                                                         source:[thenClause unEx]]
                       secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:t secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[test unCxWithTrueLabel:tL falseLabel:eL]
                       secondStmt:seq];
  return [TreeESeq eseqWithStmt:seq expr:r];
}
- (TreeStmt *)unNx
{
  TreeLabel *t = [TreeLabel treeLabelWithLabel:tL];
  TreeLabel *e = [TreeLabel treeLabelWithLabel:eL];
  TreeLabel *join = [TreeLabel treeLabelWithLabel:joinL];
  
  TreeSeq *seq = [TreeSeq seqWithFirstStmt:[TreeJump jumpWithLabel:joinL] secondStmt:join];
  if (elseClause) seq = [TreeSeq seqWithFirstStmt:[elseClause unNx] secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:e secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[TreeJump jumpWithLabel:joinL] secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[thenClause unNx] secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:t secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[test unCxWithTrueLabel:tL falseLabel:eL]
                       secondStmt:seq];
  return seq;
}
- (TreeStmt *)unCxWithTrueLabel:(TmpLabel *)tLabel falseLabel:(TmpLabel *)fLabel
{
  TreeLabel *t = [TreeLabel treeLabelWithLabel:tL];
  TreeLabel *e = [TreeLabel treeLabelWithLabel:eL];
  TreeLabel *join = [TreeLabel treeLabelWithLabel:joinL];
  
  TreeSeq *seq = [TreeSeq seqWithFirstStmt:[TreeJump jumpWithLabel:joinL] secondStmt:join];
  seq = [TreeSeq seqWithFirstStmt:[elseClause unCxWithTrueLabel:tLabel falseLabel:fLabel]
                       secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:e secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[TreeJump jumpWithLabel:joinL] secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[thenClause unCxWithTrueLabel:tLabel falseLabel:fLabel]
                       secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:t secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[test unCxWithTrueLabel:tL falseLabel:eL]
                       secondStmt:seq];
  return seq;
}
- (BOOL)isVoidType
{
  return !elseClause || [thenClause isMemberOfClass:[TRNx class]];
}
- (void)dealloc
{
  [test release];
  [thenClause release];
  [elseClause release];
  [tL release];
  [eL release];
  [joinL release];
  [super dealloc];
}
+ (id)exprWithTest:(TRExpr *)aTest thenClause:(TRExpr *)tClause elseClause:(TRExpr *)eClause
{
  return [[[TRIfThenElseExpr alloc] initWithTest:aTest thenClause:tClause elseClause:eClause] autorelease];
}
@end
