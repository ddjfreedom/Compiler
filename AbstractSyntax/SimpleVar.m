//
//  SimpleVar.m
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SimpleVar.h"


@implementation SimpleVar
@synthesize name;
- (id)initWithIdentifier:(Symbol *)identifier andLineNumber:(int)lineno
{
  if (self = [super init]) {
    name = [identifier retain];
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
