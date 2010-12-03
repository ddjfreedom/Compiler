//
//  WhileExpression.h
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  expr: while expr do expr

#import "Expression.h"

@interface WhileExpression : Expression 
{
	Expression *test;
  Expression *body;
}
@property (readonly) Expression *test, *body;
- (id)initWithTest:(Expression *)t body:(Expression *)b andLineNumber:(int)lineno;
@end
