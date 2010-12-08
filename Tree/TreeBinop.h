//
//  TreeBinop.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeExpr.h"

typedef enum {
  TreePlus = 0,
  TreeMinus,
  TreeMultiply,
  TreeDivide,
  TreeAnd,
  TreeOr,
  TreeLShift,
  TreeRShift,
  TreeARShift,
  TreeXor
} TreeBinaryOperator;

@interface TreeBinop : TreeExpr
{
	TreeBinaryOperator op;
  TreeExpr *left, *right;
}
@property (readonly) TreeExpr *left, *right;
@property (readonly) TreeBinaryOperator op;
- (id)initWithLeftExpr:(TreeExpr *)lExpr binaryOp:(TreeBinaryOperator)anOp rightExpr:(TreeExpr *)rExpr;
+ (id)binopWithLeftExpr:(TreeExpr *)lExpr binaryOp:(TreeBinaryOperator)anOp rightExpr:(TreeExpr *)rExpr;
@end
