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
@synthesize key, degree;
@synthesize graph;
@synthesize succs, preds;
- (NSSet *)adj
{
  return [succs setByAddingObjectsFromSet:preds];
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
	if (degree == -1)
		degree = preds.count + succs.count;
	return degree;
}
- (NSString *)description
{
  return [NSString stringWithFormat:@"%d <%x>", key, graph];
}
- (id)initWithGraph:(Graph *)aGraph
{
  if (self = [super init]) {
  	graph = aGraph;
    succs = [[NSMutableSet alloc] init];
    preds = [[NSMutableSet alloc] init];
    key = graph.nodeCount++;
		degree = -1;
  }
  return self;
}
- (BOOL)canGoToNode:(Node *)aNode
{
  return [succs containsObject:aNode];
}
- (BOOL)isComingFromNode:(Node *)aNode
{
  return [preds containsObject:aNode];
}
- (BOOL)isEqual:(id)object
{
	return self == object;
}
- (id)copyWithZone:(NSZone *)zone
{
  return [self retain];
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
