//
//  VarDecl.h
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//
// variable-declaration: var id := expr
// variable-declaration: var id : type-id := expr

#import "Expression.h"
#import "Decl.h"
#import "NameType.h"
#import "Symbol.h"

@interface VarDecl : Decl
{
	Symbol *identifier;
  NameType *typeIdentifier;
  Expression *expr;
}
@property (readonly) Symbol *identifier;
@property (readonly) NameType *typeIdentifier;
@property (readonly) Expression *expr;
- (id)initWithIdentifier:(Symbol *)anId
          typeIdentifier:(NameType *)aTypeId
              expression:(Expression *)anExpr
           andLineNumber:(int)lineno;
- (id)initWithIdentifier:(Symbol *)anId 
              expression:(Expression *)anExpr 
           andLineNumber:(int)lineno;
@end
