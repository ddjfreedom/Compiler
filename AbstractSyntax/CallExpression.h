//
//  CallExpression.h
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  expr: id ( expr-list )

#import "Expression.h"
#import "SyntaxList.h"
#import "Symbol.h"

@interface CallExpression : Expression
{
	Symbol *functionName;
  SyntaxList *actualParas;
}
@property (readonly) Symbol *functionName;
@property (readonly) SyntaxList *actualParas;
- (id)initWithFunctionName:(Symbol *)aName 
          actualParameters:(SyntaxList *)parameters 
             andLineNumber:(int)lineno;
@end
