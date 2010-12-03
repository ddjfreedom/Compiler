//
//  SingleTypeField.h
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  type-field: id : type-id

#import "Syntax.h"
#import "Symbol.h"

@interface SingleTypeField : Syntax
{
	Symbol *identifier;
  Symbol *typeIdentifier;
}
@property (readonly) Symbol *identifier, *typeIdentifier;
- (id)initWithIdentifier:(Symbol *)anId 
          typeIdentifier:(Symbol *)aTypeId 
           andLineNumber:(int)lineno;
@end
