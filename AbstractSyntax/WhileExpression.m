//
//  WhileExpression.m
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "WhileExpression.h"


@implementation WhileExpression
@synthesize test, body;
- (id)initWithTest:(Expression *)t body:(Expression *)b andLineNumber:(int)lineno
{
  if (self = [super init]) {
    test = [t retain];
    body = [b retain];
    lineNumber = lineno;
  }
  return self;
}
- (void)dealloc
{
  [test release];
  [body release];
  [super dealloc];
}
@end
