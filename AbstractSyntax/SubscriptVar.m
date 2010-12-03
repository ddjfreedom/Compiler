//
//  SubscriptVar.m
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SubscriptVar.h"


@implementation SubscriptVar
@synthesize variable;
@synthesize subscript;
- (id)initWithVariable:(Var *)var subscript:(Expression *)sub andLineNumber:(int)lineno
{
  if (self = [super init]) {
    variable = [var retain];
    subscript = [sub retain];
    lineNumber = lineno;
  }
  return self;
}
- (void)dealloc
{
  [variable release];
  [subscript release];
  [super dealloc];
}
@end
