//
//  FunctionDecl.m
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "FunctionDecl.h"


@implementation FunctionDecl
@synthesize name, parameters, returnType, body;
- (id)initWithName:(Symbol *)aName 
        parameters:(SyntaxList *)aParameterList 
        returnType:(NameType *)aType 
              body:(Expression *)aBody 
     andLineNumber:(int)lineno
{
  if (self = [super init]) {
    name = [aName retain];
    parameters = [aParameterList retain];
    returnType = [aType retain];
    body = [aBody retain];
    lineNumber = lineno;
  }
  return self;
}
- (id)initWithName:(Symbol *)aName 
        parameters:(SyntaxList *)aParameterList 
              body:(Expression *)aBody 
     andLineNumber:(int)lineno
{
  return [self initWithName:aName 
                 parameters:aParameterList 
                 returnType:nil 
                       body:aBody 
              andLineNumber:lineno];
}
- (void)dealloc
{
  [name release];
  [parameters release];
  [returnType release];
  [body release];
  [super dealloc];
}
@end
