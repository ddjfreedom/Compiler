//
//  ArrayExpression.h
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  expr: type-id [ expr ] of expr

#import "Expression.h"
#import "Symbol.h"

@interface ArrayExpression : Expression
{
	Symbol *typeIdentifier;
  Expression *size, *initialValue;
}
@property (readonly) Symbol *typeIdentifier;
@property (readonly) Expression *size, *initialValue;
- (id)initWithTypeId:(Symbol *)aTypeId 
                size:(Expression *)aSize 
        initialValue:(Expression *)anInitialValue 
       andLineNumber:(int)lineno;
@end
