//
//  LetExpression.h
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  expr: let declaration-list in expr-seq end
//  In declList, every batch of TypeDecls or FunctionDecls is a SyntaxList
//  The elements in declList are instances of either VarDecl or SyntaxList 

#import "Expression.h"
#import "SyntaxList.h"

@interface LetExpression : Expression
{
	SyntaxList *declList;
  SyntaxList *exprList;
}
@property (readonly) SyntaxList *declList, *exprList;
- (id)initWithDeclarationList:(SyntaxList *)aDeclList
               expressionList:(SyntaxList *)anExprList
                andLineNumber:(int)lineno;
@end
