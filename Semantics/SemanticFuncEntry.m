//
//  SemanticFuncEntry.m
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticFuncEntry.h"


@implementation SemanticFuncEntry
@synthesize returnType;
@synthesize formalParas;
- (id)initWithFormalParameters:(SemanticRecordType *)aRecordType 
                 andReturnType:(SemanticType *)aReturnType
{
  if (self = [super init]) {
    formalParas = [aRecordType retain];
    returnType = [aReturnType retain];
  }
  return self;
}
- (void)dealloc
{
  [formalParas release];
  [returnType release];
  [super dealloc];
}
+ (id)funcEntryWithFormalParameters:(SemanticRecordType *)aRecordType 
                      andReturnType:(SemanticType *)aReturnType
{
  return [[[SemanticFuncEntry alloc] initWithFormalParameters:aRecordType
                                                andReturnType:aReturnType] autorelease];
}
@end
