//
//  FieldExpression.m
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "FieldExpression.h"


@implementation FieldExpression
@synthesize identifier, expr;
- (id)initWithIdentifier:(Symbol *)anId 
              expression:(Expression *)anExpression 
           andLineNumber:(int)lineno
{
  if (self = [super init]) {
    identifier = [anId retain];
    expr = [anExpression retain];
    lineNumber = lineno;
  }
  return self;
}
- (void)dealloc
{
  [identifier release];
  [expr release];
  [super dealloc];
}
@end
