//
//  Liveness.m
//  Compiler
//
//  Created by Duan Dajun on 12/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "Liveness.h"
#import "RegAllocator.h"
#import "Edge.h"

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
- (void)buildInterferenceGraphUsingFlowGraph:(FlowGraph *)flowGraph
{
  int n = flowGraph.nodeCount;
  Node *newnode;
  marked = malloc(n * sizeof(BOOL));
  memset(marked, 0, n * sizeof(BOOL));
  [self dfsWithNode:[flowGraph.nodes lastObject]];
  free(marked);
  [self livenessAnalysisOnFlowGraph:flowGraph];
  // add nodes
  for (Node *node in flowGraph.nodes) {
    for (TmpTemp *temp in [[flowGraph defOfNode:node]
                           setByAddingObjectsFromSet:[flowGraph useOfNode:node]]) {
      if (![tempnodeMap objectForKey:temp.name]) {
        newnode = [self addNode];
        [tempnodeMap setObject:newnode forKey:temp.name];
        [nodetempMap setObject:temp forKey:newnode];
      }
    }
  }
	[allocator buildPrecoloredList];
	// Add move to moveList
	allocator.moveList = malloc(nodes.count * sizeof(NSMutableSet *));
	memset(allocator.moveList, 0, nodes.count * sizeof(NSMutableSet *));
	for (Node *node in flowGraph.nodes) {
		if ([flowGraph isMove:node]) {
			Node *dst = [tempnodeMap objectForKey:[[flowGraph defOfNode:node] anyObject]];
			Node *src = [tempnodeMap objectForKey:[[flowGraph useOfNode:node] anyObject]];
			Edge *moveedge = [Edge edgeWithNode1:dst node2:src];
			if (!(allocator.moveList)[node.key])
				(allocator.moveList)[node.key] = [[NSMutableSet alloc] init];
			[(allocator.moveList)[node.key] addObject:moveedge];
			[allocator.worksetMoves addObject:moveedge];
		}
	}
	// add edges
	for (Node *node in flowGraph.nodes) {
  	for (TmpTemp *src in [flowGraph defOfNode:node]) {
    	for (TmpTemp *dst in [livemap objectForKey:node]) {
        if (![src isEqual:dst])
      		[self addEdgeFromNode:[tempnodeMap objectForKey:src.name]
        	               toNode:[tempnodeMap objectForKey:dst.name]];
      }
    }
  }
}
- (id)initWithRegAllocator:(RegAllocator *)anAllocator
{
  if (self = [super init]) {
    nodes = [[NSMutableArray alloc] init];
		allocator = anAllocator;
    sortedNodes = [[NSMutableArray alloc] init];
    livemap = [[NSMutableDictionary alloc] init];
    nodetempMap = [[NSMutableDictionary alloc] init];
    tempnodeMap = [[NSMutableDictionary alloc] init];
		edges = [[NSMutableSet alloc] init];
  }
  return self;
}
- (void)addEdgeFromNode:(Node *)src toNode:(Node *)dst
{
	Edge *edge = [Edge edgeWithNode1:src node2:dst];
	if (![edges containsObject:edge]) {
		[edges addObject:edge];
		if (![allocator.precolored containsObject:src])
			[src.succs addObject:dst];
		if (![allocator.precolored containsObject:dst])
			[dst.succs addObject:src];
	}
}
- (TmpTemp *)tempWithNode:(Node *)aNode
{
  return [nodetempMap objectForKey:aNode];
}
- (Node *)nodeWithTemp:(TmpTemp *)aTemp
{
  return [tempnodeMap objectForKey:aTemp.name];
}
- (void)printUsingTempMap:(id <TmpTempMap>)anObject;
{
  for (Node *src in nodes)
  	if ([[anObject tempMapWithTemp:[nodetempMap objectForKey:src]] rangeOfString:@"reg"].location != NSNotFound) {
    	printf("%s:", [[anObject tempMapWithTemp:[nodetempMap objectForKey:src]] cStringUsingEncoding:NSASCIIStringEncoding]);
  		for (Node *dst in src.adj) {
      	printf(" %s", [[anObject tempMapWithTemp:[nodetempMap objectForKey:dst]] cStringUsingEncoding:NSASCIIStringEncoding]);
    	}
    	putchar('\n');
  	}
  putchar('\n');
}
- (void)dealloc
{
  [sortedNodes release];
  [livemap release];
  [nodetempMap release];
  [tempnodeMap release];
	[edges release];
  [super dealloc];
}
+ (id)livenessWithRegAllocator:(RegAllocator *)anAllocator
{
  return [[[Liveness alloc] initWithRegAllocator:anAllocator] autorelease];
}
@end
