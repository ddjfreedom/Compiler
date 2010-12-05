//
//  SemanticStringType.m
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticStringType.h"

static SemanticStringType *stringSingleton = nil;
@implementation SemanticStringType
- (BOOL)isSameType:(SemanticType *)aType
{
  return stringSingleton == aType;
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
  if (self == [SemanticStringType class]) {
    stringSingleton = [[super allocWithZone:NULL] init];
  }
}
+ (id)allocWithZone:(NSZone *)zone
{
  return [[self sharedStringType] retain]; 
}
- (id)copyWithZone:(NSZone *)zone
{
  return self;
}
+ (id)sharedStringType
{
  return stringSingleton;
}
@end
