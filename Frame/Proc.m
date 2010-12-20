//
//  Proc.m
//  Compiler
//
//  Created by Duan Dajun on 12/20/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "Proc.h"


@implementation Proc
- (id)initWithArray:(NSArray *)anArray
{
  if (self = [super init])
    instrs = [anArray retain];
  return self;
}
- (void)dealloc
{
  [instrs release];
  [super dealloc];
}
+ (id)procWithArray:(NSArray *)anArray
{
  return [[[Proc alloc] initWithArray:anArray] autorelease];
}
@end
