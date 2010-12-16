//
//  TreeLabel.m
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeLabel.h"


@implementation TreeLabel
@synthesize label;
- (id)initWithLabel:(TmpLabel *)aLabel
{
  if (self = [super init])
    label = [aLabel retain];
  return self;
}
- (TreeExprList *)kids
{
  return nil;
}
- (TreeStmt *)buildWithExprList:(TreeExprList *)kids
{
  return self;
}
- (void)dealloc
{
  [label release];
  [super dealloc];
}
+ (id)treeLabelWithLabel:(TmpLabel *)aLabel
{
  return [[[TreeLabel alloc] initWithLabel:aLabel] autorelease];
}
@end
