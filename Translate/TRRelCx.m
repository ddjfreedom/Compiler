//
//  TRRelCx.m
//  Compiler
//
//  Created by Duan Dajun on 12/9/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TRRelCx.h"


@implementation TRRelCx
- (id)initWithLeftOperand:(TreeExpr *)lExpr op:(TreeRelationOperator)anOp rightOperand:(TreeExpr *)rExpr
{
  if (self = [super init]) {
    left = [lExpr retain];
    right = [rExpr retain];
    op = anOp;
  }
  return self;
}
- (TreeStmt *)unCxWithTrueLabel:(TmpLabel *)tLabel falseLabel:(TmpLabel *)fLabel
{
  return [TreeCJump cJumpWithLeftExpr:left
                          reloperator:op
                            rightExpr:right
                            trueLabel:tLabel
                           falseLabel:fLabel];
}
- (void)dealloc
{
  [left release];
  [right release];
  [super dealloc];
}
+ (id)relcxWithLeftOperand:(TreeExpr *)lExpr op:(TreeRelationOperator)anOp rightOperand:(TreeExpr *)rExpr
{
  return [[[TRRelCx alloc] initWithLeftOperand:lExpr op:anOp rightOperand:rExpr] autorelease];
}
@end
