//
//  Graph.m
//  Compiler
//
//  Created by Duan Dajun on 12/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "Graph.h"


@implementation Graph
@synthesize nodeCount;
@synthesize nodes;
- (id)init
{
  if (self = [super init]) {
    nodeCount = 0;
    nodes = [[NSMutableArray alloc] init];
  }
  return self;
}
- (id)addNode
{
  Node *node = [Node nodeWithGraph:self];
  [nodes addObject:node];
  return node;
}
- (void)checkNode:(Node *)aNode
{
  NSAssert(aNode.graph == self, @"addEdgeFromNode:toNode:, node from another graph");
}
- (void)addEdgeFromNode:(Node *)src toNode:(Node *)dst
{
  [self checkNode:src];
  [self checkNode:dst];
  if ([src canGoToNode:dst]) return;
  [src.succs addObject:dst];
  [dst.preds addObject:src];
}
- (void)removeEdgeFromNode:(Node *)src toNode:(Node *)dst
{
  NSUInteger index = [src.succs indexOfObject:dst];
  NSAssert(index != NSNotFound, @"removeEdgeFromNode:toNode:, edge doesn't exist");
  [src.succs removeObjectAtIndex:index];
  [dst.preds removeObject:src];
}
- (void)dealloc
{
  [nodes release];
  [super dealloc];
}
@end
