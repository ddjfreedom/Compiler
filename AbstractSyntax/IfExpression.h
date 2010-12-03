//
//  IfExpression.h
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  expr: if expr then expr
//  expr: if expr then expr else expr

#import "Expression.h"

@interface IfExpression : Expression
{
	Expression *test;
  Expression *thenClause;
  Expression *elseClause;
}
@property (readonly) Expression *test, *thenClause, *elseClause;
- (id)initWithTest:(Expression *)t
        thenClause:(Expression *)then 
     andLineNumber:(int)lineno;
- (id)initWithTest:(Expression *)t
        thenClause:(Expression *)then 
        elseClause:(Expression *)el 
     andLineNumber:(int)lineno;
@end
