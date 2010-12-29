//
//  FlowGraph.m
//  Compiler
//
//  Created by Duan Dajun on 12/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "FlowGraph.h"


@implementation FlowGraph
- (NSSet *)defOfNode:(Node *)aNode
{
  NSAssert(NO, @"defOfNode:, should not call this directly");
  return nil;
}
- (NSSet *)useOfNode:(Node *)aNode
{
  NSAssert(NO, @"useOfNode:, should not call this directly");
  return nil;
}
- (BOOL)isMove:(Node *)aNode
{
  NSAssert(NO, @"isMove:, should not call this directly");
  return NO;
}
- (void)print
{
  for (Node *node in nodes) {
  	printf("%d ->", node.key);
    for (Node *succ in node.succs)
      printf(" %d", succ.key);
    putchar('\n');
  }
}
@end
