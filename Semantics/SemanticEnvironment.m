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
- (void)setSemanticType:(SemanticType *)aType forSymbol:(Symbol *)aSymbol
{
  [typeEnv setObject:aType forKey:aSymbol];
}
- (void)setSemanticEntry:(SemanticEntry *)anEntry forSymbol:(Symbol *)aSymbol
{
  [varEnv setObject:anEntry forKey:aSymbol];
}
- (SemanticType *)semanticTypeForSymbol:(Symbol *)aSymbol
{
	return [typeEnv objectForKey:aSymbol];
}
- (SemanticEntry *)semanticEntryForSymbol:(Symbol *)aSymbol
{
  return [varEnv objectForKey:aSymbol];
}
- (void)addSemanticElementsFromEnvironment:(SemanticEnvironment *)otherEnvironment
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
@end
