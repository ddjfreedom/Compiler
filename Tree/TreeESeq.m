//
//  TreeESeq.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeESeq.h"


@implementation TreeESeq
@synthesize stmt, expr;
- (id)initWithStmt:(TreeStmt *)aStmt expr:(TreeExpr *)anExpr
{
  if (self = [super init]) {
    stmt = [aStmt retain];
    expr = [anExpr retain];
  }
  return self;
}
- (void)dealloc
{
  [stmt release];
  [expr release];
  [super dealloc];
}
+ (id)eseqWithStmt:(TreeStmt *)aStmt expr:(TreeExpr *)anExpr
{
  return [[[TreeESeq alloc] initWithStmt:aStmt expr:anExpr] autorelease];
}
@end
