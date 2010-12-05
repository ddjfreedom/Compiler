//
//  OperationExpression.h
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  expr: expr binary-operator expr

#import "Expression.h"

typedef enum {
  plus = 0,
  minus,
  multiply,
  divide,
  eq,
  ne,
  lt,
  le,
  gt,
  ge
} AbstractSyntaxOperation;

@interface OperationExpression : Expression
{
  AbstractSyntaxOperation operation;
  Expression *leftOperand;
  Expression *rightOperand;
}
@property (readonly) Expression *leftOperand;
@property (readonly) Expression *rightOperand;
@property (readonly) AbstractSyntaxOperation operation;
- (id)initWithLeftOperand:(Expression *)left
								operation:(AbstractSyntaxOperation)op
             rightOperand:(Expression *)right
						andLineNumber:(int)lineno;

@end