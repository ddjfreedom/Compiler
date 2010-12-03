//
//  IfExpression.m
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "IfExpression.h"


@implementation IfExpression
@synthesize test, thenClause, elseClause;
- (id)initWithTest:(Expression *)t 
        thenClause:(Expression *)then 
        elseClause:(Expression *)el 
     andLineNumber:(int)lineno
{
  if (self = [super init]) {
    test = [t retain];
    thenClause = [then retain];
    elseClause = [el retain];
    lineNumber = lineno;
  }
  return self;
}
- (id)initWithTest:(Expression *)t 
        thenClause:(Expression *)then 
     andLineNumber:(int)lineno
{
  return [self initWithTest:t thenClause:then elseClause:nil andLineNumber:lineno];
}
- (void)dealloc
{
  [test release];
  [thenClause release];
  [elseClause release];
  [super dealloc];
}
@end
