//
//  SemanticNilType.m
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticNilType.h"

static SemanticNilType *nilSingleton = nil;

@implementation SemanticNilType
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
  if (self == [SemanticNilType class]) {
  	nilSingleton = [[SemanticNilType alloc] init];
  }
}
+ (id)sharedNilType
{
  return nilSingleton;
}
+ (id)allocWithZone:(NSZone *)zone
{
  return [[self sharedNilType] retain]; 
}

@end
