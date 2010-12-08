//
//  TreeExprList.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeExprList.h"


@implementation TreeExprList
@synthesize head;
@synthesize tail;
- (id)initWithExpr:(TreeExpr *)anExpr
{
  return [self initWithExpr:anExpr exprList:nil];
}
- (id)initWithExpr:(TreeExpr *)anExpr exprList:(TreeExprList *)anExprList
{
  if (self = [super init]) {
    head = [anExpr retain];
    tail = [anExprList retain];
  }
  return self;
}
- (void)dealloc
{
  [head release];
  [tail release];
  [super dealloc];
}
+ (id)exprListWithExpr:(TreeExpr *)aExpr
{
  return [[[TreeExprList alloc] initWithExpr:aExpr] autorelease];
}
+ (id)exprListWithExpr:(TreeExpr *)aExpr exprList:(TreeExprList *)aExprList
{
  return [[[TreeExprList alloc] initWithExpr:aExpr exprList:aExprList] autorelease];
}
@end
