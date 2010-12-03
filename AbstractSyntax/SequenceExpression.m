//
//  SequenceExpression.m
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SequenceExpression.h"


@implementation SequenceExpression
@synthesize expressions;
- (id)initWithExpressionSequence:(SyntaxList *)aList andLineNumber:(int)lineno
{
  if (self = [super init]) {
    expressions = [aList retain];
    lineNumber = lineno;
  }
  return self;
}
- (void)dealloc
{
  [expressions release];
  [super dealloc];
}
@end
