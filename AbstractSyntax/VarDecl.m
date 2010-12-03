//
//  VarDecl.m
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "VarDecl.h"


@implementation VarDecl
@synthesize identifier, typeIdentifier, expr;
- (id)initWithIdentifier:(Symbol *)anId
          typeIdentifier:(NameType *)aTypeId
              expression:(Expression *)anExpr
           andLineNumber:(int)lineno
{
  if (self = [super init]) {
    identifier = [anId retain];
    typeIdentifier = [aTypeId retain];
    expr = [anExpr retain];
    lineNumber = lineno;
  }
  return self;
}
- (id)initWithIdentifier:(Symbol *)anId
              expression:(Expression *)anExpr
           andLineNumber:(int)lineno
{
  return [self initWithIdentifier:anId
                   typeIdentifier:nil 
                       expression:anExpr 
                    andLineNumber:lineno];
}
- (void)dealloc
{
  [identifier release];
  [typeIdentifier release];
  [expr release];
  [super dealloc];
}
@end
