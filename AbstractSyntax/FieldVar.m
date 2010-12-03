//
//  FieldVar.m
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "FieldVar.h"


@implementation FieldVar
@synthesize variable;
@synthesize field;
- (id)initWithVariable:(Var *)var field:(Symbol *)f andLineNumber:(int)lineno
{
  if (self = [super init]) {
    variable = [var retain];
    field = [f retain];
    lineNumber = lineno;
  }
  return self;
}
- (void)dealloc
{
  [variable release];
  [field release];
  [super dealloc];
}
@end
