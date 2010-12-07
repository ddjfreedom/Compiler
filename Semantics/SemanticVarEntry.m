//
//  SemanticVarEntry.m
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticVarEntry.h"


@implementation SemanticVarEntry
@synthesize type;
@synthesize access;
- (id)initWithType:(SemanticType *)aType access:(TRAccess *)anAccess
{
  if (self = [super init]) {
    type = [aType retain];
    access = [anAccess retain];
  }
  return self;
}
- (void)dealloc
{
  [type release];
  [access release];
  [super dealloc];
}
+ (id)varEntryWithType:(SemanticType *)aType access:(TRAccess *)anAccess
{
  return [[[SemanticVarEntry alloc] initWithType:aType access:(TRAccess *)anAccess] autorelease];
}
+ (id)varEntry
{
  return [SemanticVarEntry varEntryWithType:nil access:nil];
}
@end
