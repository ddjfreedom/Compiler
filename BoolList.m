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
- (id)initWithNumberOfBools:(int)number bools:(BOOL)firstBool, ...
{
  va_list args;
  va_start(args, firstBool);
  return [self initWithNumberOfBools:number andBool:firstBool arguments:args];
}
- (id)initWithNumberOfBools:(int)number andBool:(BOOL)firstBool arguments:(va_list)args
{
  [super init];
  int i;
  BOOL arg;
  BoolList *last;
  head = firstBool;
  number--;
  for (i = 0, last = self; i < number; ++i) {
    arg = va_arg(args, int);
    last.tail = [BoolList boolListWithBool:arg];
    last = last.tail;
  }
  va_end(args);
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
+ (id)boolListWithNumberOfBools:(int)number bools:(BOOL)firstBool, ...
{
  va_list args;
  va_start(args, firstBool);
  return [[[BoolList alloc] initWithNumberOfBools:number andBool:firstBool arguments:args] autorelease];
}
@end
