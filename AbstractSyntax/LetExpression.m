//
//  LetExpression.m
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "LetExpression.h"


@implementation LetExpression
@synthesize declList, exprList;
- (id)initWithDeclarationList:(SyntaxList *)aDeclList
               expressionList:(SyntaxList *)anExprList
                andLineNumber:(int)lineno
{
	if (self = [super init]) {
    declList = [aDeclList retain];
    exprList = [anExprList retain];
    lineNumber = lineno;
  }
  return self;
}
- (void)dealloc
{
  [declList release];
  [exprList release];
  [super dealloc];
}
@end
