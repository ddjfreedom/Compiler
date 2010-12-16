//
//  TreeMem.m
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeMem.h"


@implementation TreeMem
@synthesize expr;
- (id)initWithExpr:(TreeExpr *)anExpr
{
  if (self = [super init])
    expr = [anExpr retain];
  return self;
}
- (TreeExprList *)kids
{
  return [TreeExprList exprListWithExpr:self.expr];
}
- (TreeExpr *)buildWithExprList:(TreeExprList *)kids
{
  return [TreeMem memWithExpr:kids.head];
}
- (void)dealloc
{
  [expr release];
  [super dealloc];
}
+ (id)memWithExpr:(TreeExpr *)anExpr
{
  return [[[TreeMem alloc] initWithExpr:anExpr] autorelease];
}
@end
