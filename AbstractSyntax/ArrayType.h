//
//  ArrayType.h
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  type: array of type-id

#import "Type.h"
#import "Symbol.h" 

@interface ArrayType : Type
{
	Symbol *typeName;
}
@property (readonly) Symbol *typeName;
- (id)initWithTypeName:(Symbol *)aName andLineNumber:(int)lineno;
@end
