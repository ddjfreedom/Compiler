//
//  FieldVar.h
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  lvalue: lvalue . id

#import "Var.h"
#import "Symbol.h"

@interface FieldVar : Var
{
	Var *variable;
  Symbol *field;
}
@property (readonly) Var *variable;
@property (readonly) Symbol *field;
- (id)initWithVariable:(Var *)var field:(Symbol *)f andLineNumber:(int)lineno;
@end
