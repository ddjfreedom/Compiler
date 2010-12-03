//
//  SemanticVarEntry.m
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticVarEntry.h"


@implementation SemanticVarEntry
@synthesize type;
- (id)initWithSemanticType:(SemanticType *)aType
{
  if (self = [super init]) {
    type = [aType retain];
  }
  return self;
}
- (void)dealloc
{
  [type release];
  [super dealloc];
}
@end
