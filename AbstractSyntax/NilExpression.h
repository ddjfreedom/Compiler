//
//  NilExpression.h
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  expr: nil

#import "Expression.h"

@interface NilExpression : Expression
{
}
- (id)initWithLineNumber:(int)lineno;
@end