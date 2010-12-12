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
- (id)initWithExprs:(TreeExpr *)firstExpr, ...
{
  va_list args;
  va_start(args, firstExpr);
  [self initWithExprs:firstExpr arguments:args];
  va_end(args);
  return self;
}
- (id)initWithExprs:(TreeExpr *)firstExpr arguments:(va_list)args
{
  if (self = [super init]) {
    TreeExprList *last = self;
    TreeExpr *arg;
    head = [firstExpr retain];
    tail = nil;
    while (arg = va_arg(args, TreeExpr*)) {
      last->tail = [[TreeExprList exprListWithExpr:arg] retain];
      last = last.tail;
    }
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
+ (id)exprListWithExprs:(TreeExpr *)firstExpr, ...
{
  va_list args;
  va_start(args, firstExpr);
	TreeExprList *result = [[[TreeExprList alloc] initWithExprs:firstExpr arguments:args] autorelease];
  va_end(args);
  return result;
}
@end
