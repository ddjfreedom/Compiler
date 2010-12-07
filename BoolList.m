//
//  BoolList.m
//  Compiler
//
//  Created by Duan Dajun on 12/6/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "BoolList.h"


@implementation BoolList
@synthesize head;
@synthesize tail;
- (id)initWithBool:(BOOL)aBool
{
  return [self initWithBool:aBool boolList:nil];
}
- (id)initWithBool:(BOOL)aBool boolList:(BoolList *)aBoolList
{
  if (self = [super init]) {
    head = aBool;
    tail = [aBoolList retain];
  }
  return self;
}
- (void)dealloc
{
  [tail release];
  [super dealloc];
}
+ (id)boolListWithBool:(BOOL)aBool
{
  return [[[BoolList alloc] initWithBool:aBool] autorelease];
}
+ (id)boolListWithBool:(BOOL)aBool boolList:(BoolList *)aBoolList
{
  return [[[BoolList alloc] initWithBool:aBool boolList:aBoolList] autorelease];
}
@end
