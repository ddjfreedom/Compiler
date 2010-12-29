//
//  AssemFlowGraph.h
//  Compiler
//
//  Created by Duan Dajun on 12/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlowGraph.h"

@interface AssemFlowGraph : FlowGraph
{
	NSMutableDictionary *map;
}
- (id)initWithInstructions:(NSArray *)instrs;
+ (id)assemFlowGraphWithInstructions:(NSArray *)instrs;
@end
