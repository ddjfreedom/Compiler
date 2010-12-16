//
//  TreeConst.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeConst.h"


@implementation TreeConst
@synthesize value;
- (id)initWithInt:(int)anInt
{
  if (self = [super init])
    value = anInt;
  return self;
}
- (TreeExprList *)kids
{
  return nil;
}
- (TreeExpr *)buildWithExprList:(TreeExprList *)kids
{
  return self;
}
+ (id)constWithInt:(int)anInt
{
  return [[[TreeConst alloc] initWithInt:anInt] autorelease];
}
@end
