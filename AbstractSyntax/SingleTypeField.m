//
//  SingleTypeField.m
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SingleTypeField.h"


@implementation SingleTypeField
@synthesize identifier, typeIdentifier;
- (id)initWithIdentifier:(Symbol *)anId
          typeIdentifier:(Symbol *)aTypeId
           andLineNumber:(int)lineno
{
  if (self = [super init]) {
    identifier = [anId retain];
    typeIdentifier = [aTypeId retain];
    lineNumber = lineno;
  }
  return self;
}
- (void)dealloc
{
  [identifier release];
  [typeIdentifier release];
  [super dealloc];
}
@end
