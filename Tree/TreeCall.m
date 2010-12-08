//
//  TreeCall.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeCall.h"


@implementation TreeCall
@synthesize func, args;
- (id)initWithExpr:(TreeExpr *)anExpr exprList:(TreeExprList *)anExprList
{
  if (self = [super init]) {
    func = [anExpr retain];
    args = [anExprList retain];
  }
  return self;
}
- (void)dealloc
{
  [func release];
  [args release];
  [super dealloc];
}
+ (id)callWithExpr:(TreeExpr *)anExpr exprList:(TreeExprList *)anExprList
{
  return [[[TreeCall alloc] initWithExpr:anExpr exprList:anExprList] autorelease];
}
@end
