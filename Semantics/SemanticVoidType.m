//
//  SemanticVoidType.m
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticVoidType.h"

static SemanticVoidType *voidSingleton = nil;

@implementation SemanticVoidType
- (BOOL)isSameType:(SemanticType *)aType
{
  return voidSingleton == aType;
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
  if (self == [SemanticVoidType class]) {
    voidSingleton = [[super allocWithZone:NULL] init];
  }
}
+ (id)sharedVoidType
{
  return voidSingleton;
}
+ (id)allocWithZone:(NSZone *)zone
{
  return [[self sharedVoidType] retain]; 
}

@end
