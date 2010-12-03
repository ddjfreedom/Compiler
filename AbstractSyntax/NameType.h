//
//  NameType.h
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  type: type-id

#import "Type.h"
#import "Symbol.h"

@interface NameType : Type
{
	Symbol *name;
}
@property (readonly) Symbol *name;
- (id)initWithName:(Symbol *)aName andLineNumber:(int)lineno;
@end
