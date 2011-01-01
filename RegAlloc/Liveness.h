//
//  Liveness.h
//  Compiler
//
//  Created by Duan Dajun on 12/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TmpTempMap.h"
#import "InterferenceGraph.h"
#import "FlowGraph.h"
@class RegAllocator;

@interface Liveness : InterferenceGraph
{
	RegAllocator *allocator;
  NSMutableArray *sortedNodes;
	NSMutableDictionary *livemap;
  NSMutableDictionary *nodetempMap;
  NSMutableDictionary *tempnodeMap;
	NSMutableSet *edges;
}
- (id)initWithRegAllocator:(RegAllocator *)anAllocator;
- (void)buildInterferenceGraphUsingFlowGraph:(FlowGraph *)flowGraph;
- (TmpTemp *)tempWithNode:(Node *)aNode;
- (Node *)nodeWithTemp:(TmpTemp *)aTemp;
- (void)printUsingTempMap:(id <TmpTempMap>)anObject;
+ (id)livenessWithRegAllocator:(RegAllocator *)anAllocator;
@end
