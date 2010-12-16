//
//  TreeExprStmt.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeExprStmt.h"


@implementation TreeExprStmt
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
- (TreeStmt *)buildWithExprList:(TreeExprList *)kids
{
  return [TreeExprStmt exprStmtWithExpr:kids.head];
}
- (void)dealloc
{
  [expr release];
  [super dealloc];
}
+ (id)exprStmtWithExpr:(TreeExpr *)anExpr
{
  return [[[TreeExprStmt alloc] initWithExpr:anExpr] autorelease];
}
@end
