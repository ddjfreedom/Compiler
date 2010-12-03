//
//  SemanticNamedType.m
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticNamedType.h"


@implementation SemanticNamedType
@synthesize name;
@synthesize type;
- (id)initWithTypeName:(Symbol *)aName
{
  if (self = [super init]) {
    name = [aName retain];
    self.type = nil;
  }
  return self;
}
- (void)dealloc
{
  [name release];
  [type release];
  [super dealloc];
}
@end
