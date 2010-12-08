//
//  SemanticRecordType.m
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticRecordType.h"
#import "SemanticNilType.h"

@implementation SemanticRecordType
- (BOOL)isSameType:(SemanticType *)aType
{
  return self == aType || aType == [SemanticNilType sharedNilType];
}
- (id)init
{
  if (self = [super init]) {
    fields = [[NSMutableArray alloc] init];
    types = [[NSMutableArray alloc] init];
  }
  return self;
}
- (NSUInteger)count
{
  return fields.count;
}
- (void)addSemanticType:(SemanticType *)type forField:(Symbol *)name
{
  [fields addObject:name];
  [types addObject:type];
}
- (SemanticType *)semanticTypeForField:(Symbol *)name
{
  return [types objectAtIndex:[fields indexOfObject:name]];
}
- (SemanticType *)semanticTypeAtIndex:(NSUInteger)index
{
  return [types objectAtIndex:index];
}
- (Symbol *)fieldAtIndex:(NSUInteger)index
{
  return [fields objectAtIndex:index];
}
- (NSUInteger)indexOfField:(Symbol *)field
{
  return [fields indexOfObject:field];
}
- (BOOL)hasField:(Symbol *)field
{
  if ([fields indexOfObject:field] == NSNotFound)
    return NO;
  return YES;
}
- (void)dealloc
{
	[fields release];
  [types release];
  [super dealloc];
}
@end
