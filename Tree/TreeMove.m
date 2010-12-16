//
//  TreeMove.m
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeMove.h"
#import "TreeMem.h"

@implementation TreeMove
@synthesize dst, src;
- (id)initWithDestination:(TreeExpr *)expr1 source:(TreeExpr *)expr2
{
  if (self = [super init]) {
    dst = [expr1 retain];
    src = [expr2 retain];
  }
  return self;
}
- (TreeExprList *)kids
{
  if ([dst isMemberOfClass:[TreeMem class]])
    return [TreeExprList exprListWithExprs:((TreeMem *)dst).expr, self.src, nil];
  else
    return [TreeExprList exprListWithExpr:self.src];
}
- (TreeStmt *)buildWithExprList:(TreeExprList *)kids
{
  if ([dst isMemberOfClass:[TreeMem class]])
    return [TreeMove moveWithDestination:[TreeMem memWithExpr:kids.head] source:kids.tail.head];
  else
    return [TreeMove moveWithDestination:self.dst source:kids.head];
}
- (void)dealloc
{
  [dst release];
  [src release];
  [super dealloc];
}
+ (id)moveWithDestination:(TreeExpr *)expr1 source:(TreeExpr *)expr2
{
  return [[[TreeMove alloc] initWithDestination:expr1 source:expr2] autorelease];
}
@end
