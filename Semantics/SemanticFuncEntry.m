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
@synthesize label;
- (id)initWithFormalParameters:(SemanticRecordType *)aRecordType
                  	returnType:(SemanticType *)aReturnType 
                         level:(TRLevel *)aLevel 
                         label:(TmpLabel *)aLabel
{
  if (self = [super init]) {
    formalParas = [aRecordType retain];
    returnType = [aReturnType retain];
    level = [aLevel retain];
    label = [aLabel retain];
  }
  return self;
}
- (void)dealloc
{
  [formalParas release];
  [returnType release];
  [level release];
  [label release];
  [super dealloc];
}
+ (id)funcEntryWithFormalParameters:(SemanticRecordType *)aRecordType 
                         returnType:(SemanticType *)aReturnType 
                              level:(TRLevel *)aLevel 
                              label:(TmpLabel *)aLabel
{
  return [[[SemanticFuncEntry alloc] initWithFormalParameters:(SemanticRecordType *)aRecordType
                                                   returnType:(SemanticType *)aReturnType 
                                                        level:(TRLevel *)aLevel 
                                                        label:(TmpLabel *)aLabel] autorelease];
}
@end
