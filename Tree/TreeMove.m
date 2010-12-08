//
//  TreeMove.m
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeMove.h"


@implementation TreeMove
@synthesize dst, src;
- (id)initWithDestination:(TreeExpr *)expr1 source:(TreeExpr *)expr2
{
  if (self = [super init]) {
    dst = [expr1 retain];
    src = [expr2 retain];
  }
  return self;
}
- (void)dealloc
{
  [dst release];
  [src release];
  [super dealloc];
}
+ (id)moveWithDestination:(TreeExpr *)expr1 source:(TreeExpr *)expr2
{
  return [[[TreeMove alloc] initWithDestination:expr1 source:expr2] autorelease];
}
@end
