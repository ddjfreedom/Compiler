//
//  TreeTemp.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeTemp.h"


@implementation TreeTemp
@synthesize temp;
- (id)initWithTemp:(TmpTemp *)aTemp
{
  if (self = [super init]) {
    temp = [aTemp retain];
  }
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
- (void)dealloc
{
  [temp release];
  [super dealloc];
}
+ (id)treeTempWithTemp:(TmpTemp *)aTemp
{
  return [[[TreeTemp alloc] initWithTemp:aTemp] autorelease];
}
@end
