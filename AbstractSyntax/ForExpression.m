//
//  ForExpression.m
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "ForExpression.h"


@implementation ForExpression
@synthesize varDecl, end, body;
- (id)initWithVarDeclaration:(VarDecl *)aVarDecl 
                  upperBound:(Expression *)upperbound 
                        body:(Expression *)aLoopBody 
               andLineNumber:(int)lineno
{
  if (self = [super init]) {
    varDecl = [aVarDecl retain];
  	end = [upperbound retain];
    body = [aLoopBody retain];
    lineNumber = lineno;
  }
  return self;
}
- (void)dealloc
{
  [varDecl release];
  [end release];
  [body release];
  [super dealloc];
}
@end
