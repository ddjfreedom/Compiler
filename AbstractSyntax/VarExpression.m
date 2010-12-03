//
//  VarExpression.m
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "VarExpression.h"


@implementation VarExpression
@synthesize variable;
- (id)initWithVariable:(Var *)var andLineNumber:(int)lineno
{
  if (self = [super init]) {
    variable = [var retain];
    lineNumber = lineno;
  }
  return self;
}
- (void)dealloc
{
  [variable release];
  [super dealloc];
}
@end
