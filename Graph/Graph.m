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
  NSAssert(![src.succs containsObject:dst], @"removeEdgeFromNode:toNode:, edge doesn't exist");
  [src.succs removeObject:dst];
  [dst.preds removeObject:src];
}
- (void)print
{
}
- (void)dealloc
{
  [nodes release];
  [super dealloc];
}
@end
