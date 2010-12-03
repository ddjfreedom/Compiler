//
//  TypeChecker.m
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//


#import "TypeChecker.h"
#import "AbstractSyntax.h"
#import "Semantics.h"
#import "Symbol.h"

@implementation TypeChecker
+ (IntermediateExpression *)typeCheckProgram:(Expression *)expr
{
  TypeChecker *checker = [[[TypeChecker alloc] init] autorelease];
  return [checker typeCheckProgram:expr];
}
- (id)init
{
  if (self = [super init]) {
    envs = [[NSMutableArray alloc] init];
  }
  return self;
}
- (SemanticEntry *)semanticEntryForSymbol:(Symbol *)aSymbol
{
  int total = envs.count - 1;
  SemanticEntry *entry = nil;
  while (total >= 0) {
  	entry = [[envs objectAtIndex:total--] semanticEntryForSymbol:aSymbol];
    if (entry)
      return entry;
  }
  return nil;
}
- (IntermediateExpression *)typeCheckVar:(Var *)var
{
  if ([var isMemberOfClass:[SimpleVar class]]) {
  	
  }
  return nil;
}
- (void)dispatch:(Syntax *)syntax
{
  if ([syntax isKindOfClass:[Var class]])
    [self typeCheckVar:(Var *)syntax];
}
- (IntermediateExpression *)typeCheckProgram:(Expression *)expr
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  [self symbolInitialization];
  [pool drain];
  return nil;
}
- (void)symbolInitialization
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  SemanticEnvironment *env = [[SemanticEnvironment alloc] init];
  [env setSemanticType:[SemanticIntType sharedIntType] 
           forSymbol:[Symbol symbolWithName:@"int"]];
  [env setSemanticType:[SemanticStringType sharedStringType] 
           forSymbol:[Symbol symbolWithName:@"string"]];
  
  SemanticRecordType *intRecord = [[SemanticIntType alloc] init];
  // i : int
  [intRecord setSemanticType:[SemanticIntType sharedIntType] 
                    forField:[Symbol symbolWithName:@"i"]];
  SemanticRecordType *stringRecord = [[SemanticIntType alloc] init];
  // s : string
  [stringRecord setSemanticType:[SemanticStringType sharedStringType]
                       forField:[Symbol symbolWithName:@"s"]];
  [env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:stringRecord 
                                                     andReturnType:nil] 
           forSymbol:[Symbol symbolWithName:@"print"]];
  [env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:intRecord
                                                     andReturnType:nil]
           forSymbol:[Symbol symbolWithName:@"printi"]];
  [env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:nil
                                                     andReturnType:nil]
           forSymbol:[Symbol symbolWithName:@"flush"]];
  [env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:nil
                                                     andReturnType:[SemanticStringType sharedStringType]]
           forSymbol:[Symbol symbolWithName:@"getchar"]];
  [env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:stringRecord
                                                     andReturnType:[SemanticIntType sharedIntType]]
           forSymbol:[Symbol symbolWithName:@"ord"]];
  [env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:intRecord
                                                     andReturnType:[SemanticStringType sharedStringType]]
           forSymbol:[Symbol symbolWithName:@"chr"]];
  [env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:intRecord
                                                     andReturnType:[SemanticIntType sharedIntType]]
           forSymbol:[Symbol symbolWithName:@"not"]];
  [env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:intRecord
                                                     andReturnType:nil]
           forSymbol:[Symbol symbolWithName:@"exit"]];
  // s : string, f : int, n : int
  [stringRecord setSemanticType:[SemanticIntType sharedIntType] forField:[Symbol symbolWithName:@"f"]];
  [stringRecord setSemanticType:[SemanticIntType sharedIntType] forField:[Symbol symbolWithName:@"n"]];
  [env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:stringRecord
                                                     andReturnType:[SemanticStringType sharedStringType]]
           forSymbol:[Symbol symbolWithName:@"substring"]];
  [stringRecord release];
  stringRecord = [[SemanticRecordType alloc] init];
  // s1 : string, s2 : string
  [stringRecord setSemanticType:[SemanticStringType sharedStringType] forField:[Symbol symbolWithName:@"s1"]];
  [stringRecord setSemanticType:[SemanticStringType sharedStringType] forField:[Symbol symbolWithName:@"s2"]];
	[env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:stringRecord
                                                     andReturnType:[SemanticStringType sharedStringType]]
           forSymbol:[Symbol symbolWithName:@"concat"]];
  [intRecord release];
  [stringRecord release];
  [envs addObject:env];
  [env release];
  [pool drain];
}
- (void)dealloc
{
  [envs release];
  [super dealloc];
}
@end
