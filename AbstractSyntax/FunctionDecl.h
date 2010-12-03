//
//  FunctionDecl.h
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  function-declaration: function id ( type-fields ) = expr
//  function-declaration: function id ( type-fields ) : type-id = expr

#import "Decl.h"
#import "SyntaxList.h"
#import "NameType.h"
#import "Expression.h"
#import "Symbol.h"

@interface FunctionDecl : Decl
{
	Symbol *name;
  SyntaxList *parameters;
  NameType *returnType;
  Expression *body;
}
@property (readonly) Symbol *name;
@property (readonly) SyntaxList *parameters;
@property (readonly) NameType *returnType;
@property (readonly) Expression *body;
- (id)initWithName:(Symbol *)aName 
        parameters:(SyntaxList *)aParameterList 
        returnType:(NameType *)aType 
              body:(Expression *)aBody 
     andLineNumber:(int)lineno;
- (id)initWithName:(Symbol *)aName
        parameters:(SyntaxList *)aParameterList
              body:(Expression *)aBody
     andLineNumber:(int)lineno;
@end
