//
//  BreakExpression.h
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  expr: break

#import "Expression.h"

@interface BreakExpression : Expression
{
}
- (id)initWithLineNumber:(int)lineno;
@end
