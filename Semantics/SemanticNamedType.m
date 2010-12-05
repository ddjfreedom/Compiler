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
@synthesize inCycle;
- (SemanticType *)actualType
{
  if (inCycle)
    return nil;
  return type.actualType;
}
- (id)initWithTypeName:(Symbol *)aName
{
  if (self = [super init]) {
    name = [aName retain];
    self.type = nil;
    inCycle = NO;
  }
  return self;
}
- (BOOL)isCycle
{
  BOOL ans;
  SemanticType *t = type;
  type = nil;
  if (!t) return YES;
  if ([t isMemberOfClass:[SemanticNamedType class]])
    ans = [(SemanticNamedType *)t isCycle];
  else 
    ans = NO;
  type = t;
  inCycle = ans;
  return ans;
}
- (void)dealloc
{
  [name release];
  [type release];
  [super dealloc];
}
+ (id)namedTypeWithTypeName:(Symbol *)aName
{
  return [[[SemanticNamedType alloc] initWithTypeName:aName] autorelease];
}
@end
