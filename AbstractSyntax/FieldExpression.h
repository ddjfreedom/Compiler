//
//  FieldExpression.h
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//
// represent "id = expr"

#import "Syntax.h"
#import "Expression.h"
#import "Symbol.h"

@interface FieldExpression : Syntax
{
	Symbol *identifier;
  Expression *expr;
}
@property (readonly) Symbol *identifier;
@property (readonly) Expression *expr;
- (id)initWithIdentifier:(Symbol *)anId 
              expression:(Expression *)anExpression 
           andLineNumber:(int)lineno;
@end
