//
//  SimpleVar.h
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  lvalue: id

#import "Var.h"
#import "Symbol.h"

@interface SimpleVar : Var
{
	Symbol *name;
}
@property (readonly) Symbol *name;
- (id)initWithIdentifier:(Symbol *)identifier andLineNumber:(int)lineno;
@end
