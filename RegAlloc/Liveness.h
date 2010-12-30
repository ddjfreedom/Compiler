//
//  Liveness.h
//  Compiler
//
//  Created by Duan Dajun on 12/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InterferenceGraph.h"
#import "FlowGraph.h"

@interface Liveness : InterferenceGraph
{
  NSMutableArray *sortedNodes;
	NSMutableDictionary *livemap;
  NSMutableDictionary *nodetempMap;
  NSMutableDictionary *tempnodeMap;
}
- (id)initWithFlowGraph:(FlowGraph *)aFlowGraph;
+ (id)livenessWithFlowGraph:(FlowGraph *)aFlowGraph;
@end
