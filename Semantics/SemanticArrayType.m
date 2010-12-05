//
//  SemanticArrayType.m
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticArrayType.h"


@implementation SemanticArrayType
@synthesize type;
- (BOOL)isSameType:(SemanticType *)aType
{
  return self == aType;
}
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
+ (id)arrayTypeWithSemanticType:(SemanticType *)aType
{
  return [[[SemanticArrayType alloc] initWithSemanticType:aType] autorelease];
}
@end
