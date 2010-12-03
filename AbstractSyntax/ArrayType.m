//
//  ArrayType.m
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "ArrayType.h"


@implementation ArrayType
@synthesize typeName;
- (id)initWithTypeName:(Symbol *)aName andLineNumber:(int)lineno
{
  if (self = [super init]) {
    typeName = [aName retain];
    lineNumber = lineno;
  }
  return self;
}
- (void)dealloc
{
  [typeName release];
  [super dealloc];
}
@end
