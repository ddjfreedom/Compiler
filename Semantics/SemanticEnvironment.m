//
//  SemanticEnvironment.m
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticEnvironment.h"
#import "SemanticIntType.h"
#import "SemanticStringType.h"
#import "SemanticFuncEntry.h"

@implementation SemanticEnvironment
- (id)init
{
  if (self = [super init]) {
    typeEnv = [[NSMutableDictionary alloc] init];
    varEnv = [[NSMutableDictionary alloc] init];
  }
  return self;
}
- (void)setType:(SemanticType *)aType forSymbol:(Symbol *)aSymbol
{
  [typeEnv setObject:aType forKey:aSymbol];
}
- (void)setEntry:(SemanticEntry *)anEntry forSymbol:(Symbol *)aSymbol
{
  [varEnv setObject:anEntry forKey:aSymbol];
}
- (SemanticType *)typeForSymbol:(Symbol *)aSymbol
{
	return [typeEnv objectForKey:aSymbol];
}
- (SemanticEntry *)entryForSymbol:(Symbol *)aSymbol
{
  return [varEnv objectForKey:aSymbol];
}
- (void)removeTypeForSymbol:(Symbol *)aSymbol
{
  [typeEnv removeObjectForKey:aSymbol];
}
- (void)removeEntryForSymbol:(Symbol *)aSymbol
{
  [typeEnv removeObjectForKey:aSymbol];
}
- (void)addElementsFromEnvironment:(SemanticEnvironment *)otherEnvironment
{
  [typeEnv addEntriesFromDictionary:otherEnvironment->typeEnv];
  [varEnv addEntriesFromDictionary:otherEnvironment->varEnv];
}
- (void)dealloc
{
  [typeEnv release];
  [varEnv release];
  [super dealloc];
}
+ (SemanticEnvironment *)environment
{
  return [[[SemanticEnvironment alloc] init] autorelease];
}
@end
