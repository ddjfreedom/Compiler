//
//  ArrayExpression.m
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "ArrayExpression.h"


@implementation ArrayExpression
@synthesize typeIdentifier, size, initialValue;
- (id)initWithTypeId:(Symbol *)aTypeId 
                size:(Expression *)aSize 
        initialValue:(Expression *)anInitialValue 
       andLineNumber:(int)lineno
{
  if (self = [super init]) {
    typeIdentifier = [aTypeId retain];
    size = [aSize retain];
    initialValue = [anInitialValue retain];
    lineNumber = lineno;
  }
  return self;
}
- (void)dealloc
{
  [typeIdentifier release];
  [size release];
  [initialValue release];
  [super dealloc];
}
@end
