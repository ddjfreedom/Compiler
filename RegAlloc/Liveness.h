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

@interface Liveness : InterferenceGraph
{
  NSMutableArray *sortedNodes;
	NSMutableDictionary *livemap;
  NSMutableDictionary *nodetempMap;
  NSMutableDictionary *tempnodeMap;
}
- (id)initWithFlowGraph:(FlowGraph *)aFlowGraph;
- (void)printUsingTempMap:(id <TmpTempMap>)anObject;
+ (id)livenessWithFlowGraph:(FlowGraph *)aFlowGraph;
@end
