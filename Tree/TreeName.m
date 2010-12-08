//
//  TreeName.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeName.h"


@implementation TreeName
@synthesize label;
- (id)initWithLabel:(TmpLabel *)aLabel
{
  if (self = [super init])
    label = [aLabel retain];
  return self;
}
- (void)dealloc
{
  [label release];
  [super dealloc];
}
+ (id)nameWithLabel:(TmpLabel *)aLabel
{
  return [[[TreeName alloc] initWithLabel:aLabel] autorelease];
}
@end
