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
    } else if (i < size - 1)
      [self addEdgeFromNode:node toNode:[nodes objectAtIndex:i+1]];
  }
  [pool drain];
}
- (id)initWithInstructions:(NSArray *)instrs
{
  if (self = [super init]) {
    map = [[NSMutableDictionary alloc] init];
    uses = [[NSMutableArray alloc] init];
    defs = [[NSMutableArray alloc] init];
    AssemInstr *instr;
    [self constructGraphFromInstructions:instrs];
    for (Node *node in nodes) {
      instr = [map objectForKey:node];
      [uses addObject:[NSSet setWithArray:[instr.use temps]]];
      [defs addObject:[NSSet setWithArray:[instr.def temps]]];
    }
  }
  return self;
}
- (NSSet *)defOfNode:(Node *)aNode
{
  return [defs objectAtIndex:aNode.key];
}
- (NSSet *)useOfNode:(Node *)aNode
{
  return [uses objectAtIndex:aNode.key];
}
- (BOOL)isMove:(Node *)aNode
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
