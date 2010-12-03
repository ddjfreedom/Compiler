//
//  StringExpression.h
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  expr: string-constant

#import <Foundation/Foundation.h>
#import "Expression.h"
#import "Symbol.h"

@interface StringExpression : Expression
{
	Symbol *string;
}
@property (readonly) NSString *string;
- (id)initWithString:(NSString *)str andLineNumber:(int)lineno;
@end
