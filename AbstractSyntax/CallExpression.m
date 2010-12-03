//
//  CallExpression.m
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "CallExpression.h"


@implementation CallExpression
@synthesize functionName, actualParas;
- (id)initWithFunctionName:(Symbol *)aName 
          actualParameters:(SyntaxList *)parameters 
             andLineNumber:(int)lineno
{
  if (self = [super init]) {
    functionName = [aName retain];
    actualParas = [parameters retain];
    lineNumber = lineno;
  }
  return self;
}
- (void)dealloc
{
  [functionName release];
  [actualParas release];
  [super dealloc];
}
@end
