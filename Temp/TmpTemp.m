//
//  TmpTemp.m
//  Compiler
//
//  Created by Duan Dajun on 12/6/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TmpTemp.h"

static int count = 0;

@implementation TmpTemp
@synthesize name;
- (id)init
{
  if (self = [super init])
    name = [[NSString alloc] initWithFormat:@"t%d", count++];
  return self;
}
- (NSString *)description
{
  return [NSString stringWithFormat:@"temp: %@", name];
}
- (void)dealloc
{
  [name release];
  [super dealloc];
}
+ (id)temp
{
  return [[[TmpTemp alloc] init] autorelease];
}
@end
