//
//  TreeCJump.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeCJump.h"


@implementation TreeCJump
@synthesize relationOp;
@synthesize left, right;
@synthesize iftrue, iffalse;
- (id)initWithLeftExpr:(TreeExpr *)lExpr
           reloperator:(TreeRelationOperator)anOp
             rightExpr:(TreeExpr *)rExpr
             trueLabel:(TmpLabel *)aTrueLabel
            falseLabel:(TmpLabel *)aFalseLabel
{
  if (self = [super init]) {
    left = [lExpr retain];
    relationOp = anOp;
    right = [rExpr retain];
    iftrue = [aTrueLabel retain];
    iffalse = [aFalseLabel retain];
  }
  return self;
}
- (TreeExprList *)kids
{
  return [TreeExprList exprListWithExprs:left, right, nil];
}
- (TreeStmt *)buildWithExprList:(TreeExprList *)kids
{
  return [TreeCJump cJumpWithLeftExpr:kids.head
                          reloperator:self.relationOp
                            rightExpr:kids.tail.head
                            trueLabel:self.iftrue
                           falseLabel:self.iffalse];
}
- (void)dealloc
{
  [left release];
  [right release];
  [iftrue release];
  [iffalse release];
  [super dealloc];
}
+ (id)cJumpWithLeftExpr:(TreeExpr *)lExpr
           	reloperator:(TreeRelationOperator)anOp
              rightExpr:(TreeExpr *)rExpr
             	trueLabel:(TmpLabel *)aTrueLabel
             falseLabel:(TmpLabel *)aFalseLabel
{
  return [[[TreeCJump alloc] initWithLeftExpr:lExpr
                                  reloperator:anOp
                                    rightExpr:rExpr
                                    trueLabel:aTrueLabel
                                   falseLabel:aFalseLabel] autorelease];
}
+ (TreeRelationOperator)notRelation:(TreeRelationOperator)anOp
{
  switch (anOp) {
  	case TreeEQ: return TreeNE;
    case TreeNE: return TreeEQ;
    case TreeLT: return TreeGE;
    case TreeGT: return TreeLE;
    case TreeLE: return TreeGT;
    case TreeGE: return TreeLT;
    case TreeULT: return TreeUGE;
    case TreeUGT: return TreeULE;
    case TreeULE: return TreeUGT;
    case TreeUGE: return TreeULT;
  }
  return TreeInvalidOp;
}
@end
