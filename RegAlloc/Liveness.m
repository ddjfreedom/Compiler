//
//  Liveness.m
//  Compiler
//
//  Created by Duan Dajun on 12/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "Liveness.h"

static BOOL *marked = NULL;

@implementation Liveness
- (void)livenessAnalysisOnFlowGraph:(FlowGraph *)flowGraph
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  int i, size = flowGraph.nodeCount;
  NSMutableArray *liveIns = [NSMutableArray array];
  NSMutableArray *liveOuts = [NSMutableArray array];
  NSMutableSet *tmpset;
  BOOL modified = YES;
  for (i = 0; i < size; ++i) {
    [liveIns addObject:[NSMutableSet set]];
    [liveOuts addObject:[NSMutableSet set]];
  }
  while (modified) {
    modified = NO;
  	for (Node *node in sortedNodes) {
      tmpset = [NSMutableSet setWithSet:[liveOuts objectAtIndex:node.key]];
      [tmpset minusSet:[flowGraph defOfNode:node]];
      [tmpset unionSet:[flowGraph useOfNode:node]];
      if (![tmpset isEqualToSet:[liveIns objectAtIndex:node.key]]) {
        modified = YES;
        [liveIns replaceObjectAtIndex:node.key withObject:tmpset];
      }
      tmpset = [NSMutableSet set];
      for (Node *succ in node.succs)
        [tmpset unionSet:[liveIns objectAtIndex:succ.key]];
      if (![tmpset isEqualToSet:[liveOuts objectAtIndex:node.key]]) {
        modified = YES;
        [liveOuts replaceObjectAtIndex:node.key withObject:tmpset];
      }
    }
  }
  for (Node *node in sortedNodes) {
    tmpset = [liveOuts objectAtIndex:node.key];
    if ([flowGraph isMove:node])
      [tmpset minusSet:[flowGraph useOfNode:node]];
    [livemap setObject:tmpset forKey:node];
  }
  [pool drain];
}
- (void)dfsWithNode:(Node *)node
{
  if (!marked[node.key]) {
    marked[node.key] = YES;
    for (Node *pre in node.preds)
      [self dfsWithNode:pre];
    [sortedNodes insertObject:node atIndex:0];
  }
}
- (void)constructInterferenceGraphUsingFlowGraph:(FlowGraph *)flowGraph
{
  int n = flowGraph.nodeCount;
  Node *newnode;
  marked = malloc(n * sizeof(BOOL));
  memset(marked, 0, n * sizeof(BOOL));
  [self dfsWithNode:[flowGraph.nodes lastObject]];
  free(marked);
  [self livenessAnalysisOnFlowGraph:flowGraph];
  for (Node *node in flowGraph.nodes) {
    for (TmpTemp *temp in [flowGraph defOfNode:node]) {
      if (![tempnodeMap objectForKey:temp.name]) {
        newnode = [self addNode];
        [tempnodeMap setObject:newnode forKey:temp.name];
        [nodetempMap setObject:temp forKey:newnode];
      }
    }
  }
  // add edges
	for (Node *node in flowGraph.nodes) {
  	for (TmpTemp *src in [flowGraph defOfNode:node]) {
    	for (TmpTemp *dst in [livemap objectForKey:node]) {
      	[self addEdgeFromNode:[tempnodeMap objectForKey:src.name]
                       toNode:[tempnodeMap objectForKey:dst.name]];
      }
    }
  }
}
- (id)initWithFlowGraph:(FlowGraph *)aFlowGraph
{
  if (self = [super init]) {
    nodes = [[NSMutableArray alloc] init];
    sortedNodes = [[NSMutableArray alloc] init];
    livemap = [[NSMutableDictionary alloc] init];
    nodetempMap = [[NSMutableDictionary alloc] init];
    tempnodeMap = [[NSMutableDictionary alloc] init];
    [self constructInterferenceGraphUsingFlowGraph:aFlowGraph];
  }
  return self;
}
- (TmpTemp *)tempWithNode:(Node *)aNode
{
  return [nodetempMap objectForKey:aNode];
}
- (Node *)nodeWithTemp:(TmpTemp *)aTemp
{
  return [tempnodeMap objectForKey:aTemp.name];
}
- (void)dealloc
{
  [nodes release];
  [sortedNodes release];
  [livemap release];
  [nodetempMap release];
  [tempnodeMap release];
  [super dealloc];
}
+ (id)livenessWithFlowGraph:(FlowGraph *)aFlowGraph
{
  return [[[Liveness alloc] initWithFlowGraph:aFlowGraph] autorelease];
}
@end
