//
//  Node.m
//  Compiler
//
//  Created by Duan Dajun on 12/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "Node.h"
#import "Graph.h"

@implementation Node
@synthesize key;
@synthesize graph;
@synthesize succs, preds;
- (NSArray *)adj
{
  return [succs arrayByAddingObjectsFromArray:preds];
}
- (int)inDegree
{
  return preds.count;
}
- (int)outDegree
{
  return succs.count;
}
- (int)degree
{
  return preds.count + succs.count;
}
- (id)initWithGraph:(Graph *)aGraph
{
  if (self = [super init]) {
  	graph = aGraph;
    succs = [[NSMutableArray alloc] init];
    preds = [[NSMutableArray alloc] init];
    key = graph.nodeCount++;
  }
  return self;
}
- (BOOL)canGoToNode:(Node *)aNode
{
  return [succs indexOfObject:aNode] != NSNotFound;
}
- (BOOL)isComingFromNode:(Node *)aNode
{
  return [preds indexOfObject:aNode] != NSNotFound;
}
- (BOOL)isEqual:(id)object
{
  if ([object isMemberOfClass:[Node class]]) {
  	if (graph == ((Node *)object).graph && key == ((Node *)object).key)
      return YES;
  }
  return NO;
}
- (id)copyWithZone:(NSZone *)zone
{
  Node *newNode = [[Node allocWithZone:zone] init];
  newNode->graph = graph;
  newNode->succs = [succs retain];
  newNode->preds = [preds retain];
  newNode->key = key;
  return newNode;
}
- (void)dealloc
{
  [succs release];
  [preds release];
  [super dealloc];
}
+ (id)nodeWithGraph:(Graph *)aGraph
{
  return [[[Node alloc] initWithGraph:aGraph] autorelease];
}
@end
