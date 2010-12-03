//
//  AssignExpression.m
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "AssignExpression.h"


@implementation AssignExpression
@synthesize variable;
@synthesize expression;
- (id)initWithVariable:(Var *)var expression:(Expression *)expr andLineNumber:(int)lineno
{
  if (self = [super init]) {
    variable = [var retain];
    expression = [expr retain];
    lineNumber = lineno;
  }
  return self;
}
- (void)dealloc
{
  [variable release];
  [expression release];
  [super dealloc];
}
@end
