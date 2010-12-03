//
//  IntExpression.h
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  expr: integer-constant

#import "Expression.h"

@interface IntExpression : Expression
{
  int value;
}

@property (readonly) int value;
- (id)initWithInt:(int)number andLineNumber:(int)lineno;
@end
