//
//  SubscriptVar.h
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  lvalue: lvalue [ expr ]

#import "Var.h"
#import "Expression.h"

@interface SubscriptVar : Var
{
	Var *variable;
  Expression *subscript;
}
@property (readonly) Var *variable;
@property (readonly) Expression *subscript;
- (id)initWithVariable:(Var *)var subscript:(Expression *)sub andLineNumber:(int)lineno;
@end
