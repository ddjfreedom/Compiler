//
//  AssemFlowGraph.m
//  Compiler
//
//  Created by Duan Dajun on 12/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "AssemFlowGraph.h"
#import "Assem.h"
#import "TmpLabel.h"

@implementation AssemFlowGraph
- (void)constructGraphFromInstructions:(NSArray *)instrs
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSMutableDictionary *labels = [NSMutableDictionary dictionary];
  Node *node;
  AssemInstr *instr;
  int i, size = instrs.count;
  for (i = 0; i < size; ++i) {
    [self addNode];
    instr = [instrs objectAtIndex:i];
    if ([instr isMemberOfClass:[AssemLabel class]])
      [labels setObject:[NSNumber numberWithInt:i] forKey:((AssemLabel *)instr).label.name];
  }
  for (i = 0; i < size; ++i) {
    instr = [instrs objectAtIndex:i];
    node = [nodes objectAtIndex:i];
    [map setObject:instr forKey:node];
    if (instr.targets) {
      for (TmpLabel *label in instr.targets)
        [self addEdgeFromNode:node toNode:[nodes objectAtIndex:[[labels objectForKey:label.name] intValue]]];
    } else
      [self addEdgeFromNode:node toNode:[nodes objectAtIndex:i+1]];
  }
  [pool drain];
}
- (id)initWithInstructions:(NSArray *)instrs
{
  if (self = [super init]) {
    map = [[NSMutableDictionary alloc] init];
    [self constructGraphFromInstructions:instrs];
  }
  return self;
}
- (TmpTempList *)defOfNode:(Node *)aNode
{
  return ((AssemInstr *)[map objectForKey:aNode]).def;
}
- (TmpTempList *)useOfNode:(Node *)aNode
{
  return ((AssemInstr *)[map objectForKey:aNode]).use;
}
- (BOOL)iSMove:(Node *)aNode
{
	return [[map objectForKey:aNode] isMemberOfClass:[AssemMove class]];
}
- (void)dealloc
{
  [map release];
  [super dealloc];
}
+ (id)assemFlowGraphWithInstructions:(NSArray *)instrs
{
  return [[[AssemFlowGraph alloc] initWithInstructions:instrs] autorelease];
}
@end
