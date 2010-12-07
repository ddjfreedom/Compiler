//
//  MipsInFrame.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "MipsInFrame.h"


@implementation MipsInFrame
@synthesize offset;
- (id)initWithOffset:(int)anOffset
{
  if (self = [super init])
    offset = anOffset;
  return self;
}
- (NSString *)description
{
  return [NSString stringWithFormat:@"InFrame: %d", offset];
}
+ (id)inFrameWithOffset:(int)anOffset
{
  return [[[MipsInFrame	alloc] initWithOffset:anOffset] autorelease];
}
@end
