//
//  NameType.m
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "NameType.h"


@implementation NameType
@synthesize name;
- (id)initWithName:(Symbol *)aName andLineNumber:(int)lineno
{
  if (self = [super init]) {
    name = [aName retain];
    lineNumber = lineno;
  }
  return self;
}
- (void)dealloc
{
  [name release];
  [super dealloc];
}
@end
