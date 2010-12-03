//
//  ForExpression.h
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  expr: for id := expr to expr do expr

#import "Expression.h"
#import "VarDecl.h"

@interface ForExpression : Expression
{
  VarDecl *varDecl;
	Expression *end, *body;
}
@property (readonly) VarDecl *varDecl;
@property (readonly) Expression *end, *body;
- (id)initWithVarDeclaration:(VarDecl *)aVarDecl 
                  upperBound:(Expression *)upperbound 
                        body:(Expression *)aLoopBody 
               andLineNumber:(int)lineno;
@end
