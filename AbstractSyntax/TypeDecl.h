//
//  TypeDecl.h
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  type-declaration: type type-id = type

#import "Decl.h"
#import "Type.h"
#import "Symbol.h"

@interface TypeDecl : Decl
{
	Symbol *typeIdentifier;
  Type *type;
}
@property (readonly) Symbol *typeIdentifier;
@property (readonly) Type *type;
- (id)initWithTypeIdentifier:(Symbol *)aTypeId 
                        type:(Type *)aType 
               andLineNumber:(int)lineno;
@end
