//
//  SemanticRecordType.m
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticRecordType.h"


@implementation SemanticRecordType
- (id)init
{
  if (self = [super init]) {
    fields = [[NSMutableArray alloc] init];
    types = [[NSMutableArray alloc] init];
  }
  return self;
}
- (void)setSemanticType:(SemanticType *)type forField:(Symbol *)name
{
  [fields addObject:name.string];
  [types addObject:type];
}
- (SemanticType *)semanticTypeForField:(Symbol *)name
{
  return [types objectAtIndex:[fields indexOfObject:name.string]];
}
- (void)dealloc
{
	[fields release];
  [types release];
  [super dealloc];
}
@end
