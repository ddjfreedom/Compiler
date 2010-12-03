//
//  IntExpression.m
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "IntExpression.h"


@implementation IntExpression
@synthesize value;
- (id)initWithInt:(int)number andLineNumber:(int)lineno
{
  if (self = [super init]) {
		value = number;
    lineNumber = lineno;
  }
  return self;
}
@end
