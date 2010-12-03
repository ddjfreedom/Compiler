//
//  SyntaxList.h
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  a generalization of 
//  "expr-seq" "expr-list" "field-list" "declaration-list" "type-fields"
//  expr-seq: expr | expr-seq ; expr
//  expr-list: expr | expr-list , expr
//  field-list: id = expr | field-list , id = expr
//  declaration-list: declaration | declaration-list declaration
//  type-fields: type-field | type-fields , typefield

#import <Foundation/Foundation.h>
#import "Syntax.h"
typedef enum {
  ExpressionSequence = 0,
  FieldList,
  DeclarationList,
  TypeFields,
  UnknownType
} SyntaxListType;
@interface SyntaxList : Syntax <NSFastEnumeration>
{
	NSMutableArray *list;
}
@property (readonly) SyntaxListType type;
- (id)initWithObject:(id)anObject;
- (void)addObject:(id)anObject;
- (id)lastObject;
+ (id)syntaxListWithObject:(id)anObject;
@end
