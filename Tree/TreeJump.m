//
//  TreeJump.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeJump.h"
#import "TreeName.h"

@implementation TreeJump
@synthesize expr, list;
- (id)initWithExpr:(TreeExpr *)anExpr lableList:(TmpLabelList *)aLabelList
{
  if (self = [super init]) {
    expr = [anExpr retain];
    list = [aLabelList retain];
  }
  return self;
}
- (id)initWithLabel:(TmpLabel *)aLabel
{
  return [self initWithExpr:[TreeName nameWithLabel:aLabel]
                  lableList:[TmpLabelList labelListWithLabel:aLabel]];
}
- (void)dealloc
{
  [expr release];
  [list release];
  [super dealloc];
}
- (id)jumpWithExpr:(TreeExpr *)anExpr lableList:(TmpLabelList *)aLabelList
{
  return [[[TreeJump alloc] initWithExpr:anExpr lableList:aLabelList] autorelease];
}
- (id)jumpWithLabel:(TmpLabel *)aLabel
{
  return [[[TreeJump alloc] initWithLabel:aLabel] autorelease];
}
@end
