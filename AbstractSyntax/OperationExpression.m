//
//  OperationExpression.m
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "OperationExpression.h"

@implementation OperationExpression
@synthesize operation;
@synthesize leftOperand, rightOperand;
- (id)initWithLeftOperand:(Expression *)left
								operation:(AbstractSyntaxOperation)op
             rightOperand:(Expression *)right
						andLineNumber:(int)lineno
{
  if (self = [super init]) {
    leftOperand = [left retain];
    operation = op;
    rightOperand = [right retain];
    lineNumber = lineno;
  }
  return self;
}
- (void)dealloc
{
  [leftOperand release];
  [rightOperand release];
  [super dealloc];
}
@end
