//
//  TRRelCx.h
//  Compiler
//
//  Created by Duan Dajun on 12/9/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TRCx.h"
#import "TreeExpr.h"
#import "TreeStmt.h"
#import "TreeCJump.h"

@interface TRRelCx : TRCx
{
	TreeExpr *left, *right;
  TreeRelationOperator op;
}
- (id)initWithLeftOperand:(TreeExpr *)lExpr op:(TreeRelationOperator)anOp rightOperand:(TreeExpr *)rExpr;
- (TreeStmt *)unCxWithTrueLabel:(TmpLabel *)tLabel falseLabel:(TmpLabel *)fLabel;
+ (id)relcxWithLeftOperand:(TreeExpr *)lExpr op:(TreeRelationOperator)anOp rightOperand:(TreeExpr *)rExpr;
@end
