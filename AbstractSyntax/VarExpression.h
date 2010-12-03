//
//  VarExpression.h
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  expr: lvalue

#import "Expression.h"
#import "Var.h"

@interface VarExpression : Expression
{
	Var *variable;
}
@property (readonly) Var *variable;
- (id)initWithVariable:(Var *)var andLineNumber:(int)lineno;
@end
