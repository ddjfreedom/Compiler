//
//  TypeDecl.m
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TypeDecl.h"


@implementation TypeDecl
@synthesize typeIdentifier, type;
- (id)initWithTypeIdentifier:(Symbol *)aTypeId type:(Type *)aType andLineNumber:(int)lineno
{
  if (self = [super init]) {
    typeIdentifier = [aTypeId retain];
    type = [aType retain];
    lineNumber = lineno;
  }
  return self;
}
- (void)dealloc
{
  [typeIdentifier release];
  [type release];
  [super dealloc];
}
@end
