//
//  AssignExpression.h
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  expr: lvalue := expr

#import "Expression.h"
#import "Var.h"

@interface AssignExpression : Expression
{
	Var *variable;
  Expression *expression;
}
@property (readonly) Var *variable;
@property (readonly) Expression *expression;
- (id)initWithVariable:(Var *)var expression:(Expression *)expr andLineNumber:(int)lineno;
@end
