//
//  TRAccess.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TRAccess.h"


@implementation TRAccess
@synthesize level;
@synthesize acc;
- (id)initWithLevel:(TRLevel *)aLevel access:(Access *)anAccess
{
  if (self = [super init]) {
    level = [aLevel retain];
    acc = [anAccess retain];
  }
  return self;
}
- (void)dealloc
{
  [level release];
  [acc release];
  [super dealloc];
}
+ (id)accessWithLevel:(TRLevel *)aLevel access:(Access *)anAccess
{
  return [[[TRAccess alloc] initWithLevel:aLevel access:anAccess] autorelease];
}
@end
