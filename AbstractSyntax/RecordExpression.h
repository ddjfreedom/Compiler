//
//  RecordExpression.h
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  expr: type-id { field-list }

#import "Expression.h"
#import "SyntaxList.h"
#import "Symbol.h"

@interface RecordExpression : Expression
{
	Symbol *typeIdentifier;
  SyntaxList *fields;
}
@property (readonly) Symbol *typeIdentifier;
@property (readonly) SyntaxList *fields;
- (id)initWithTypeId:(Symbol *)aType
           fieldList:(SyntaxList *)aList 
       andLineNumber:(int)lineno;
@end
