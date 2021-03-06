//
//  SemanticIntType.m
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticIntType.h"

static SemanticIntType *intSingleton = nil;

@implementation SemanticIntType
- (BOOL)isSameType:(SemanticType *)aType
{
  return intSingleton == aType;
}
- (id)copyWithZone:(NSZone *)zone
{
  return self;
}
- (id)retain
{
  return self;
}
- (NSUInteger)retainCount
{
  return NSUIntegerMax;
}
- (void)release
{
  // Do nothing
}
- (id)autorelease
{
  return self;
}
+ (void)initialize
{
  if (self == [SemanticIntType class]) {
    intSingleton = [[super allocWithZone:NULL] init];
  }
}
+ (id)sharedIntType
{
  return intSingleton;
}
+ (id)allocWithZone:(NSZone *)zone
{
  return [[self sharedIntType] retain]; 
}
@end
