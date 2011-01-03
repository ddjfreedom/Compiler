//
//  RegAllocator.m
//  Compiler
//
//  Created by Duan Dajun on 1/1/11.
//  Copyright 2011 SJTU. All rights reserved.
//

#import "RegAllocator.h"
#import "Assem.h"
#import "AssemFlowGraph.h"
#import "TmpTemp.h"

@interface RegAllocator()
- (void)buildWorkList;
- (BOOL)isFinished;
- (void)simplify;
- (NSSet *)adjacentNodesOfNode:(Node *)aNode;
- (void)decrementDegreeOfNode:(Node *)aNode;
- (void)assignColors;
- (void)addNodesToSet:(NSMutableSet *)aSet usingArray:(NSArray *)anArray;
@end

static int counter = 0;
@implementation RegAllocator
@synthesize moveList, worksetMoves, precolored;
- (id)initWithFrame:(MipsFrame *)aFrame instructions:(NSArray *)instrs
{
	if (self = [super init]) {
		NSMutableSet *tmpset = [NSMutableSet set];
		int i;
		frame = [aFrame retain];
		regNumber = frame.specialregs.count + frame.argregs.count +
								frame.calleesave.count + frame.callersave.count - 2;
		for (i = 0; i < regNumber; ++i)
			[tmpset addObject:[NSNumber numberWithInt:i]];
    [tmpset removeObject:[NSNumber numberWithInt:1]]; // $sp
    [tmpset removeObject:[NSNumber numberWithInt:0]]; // $fp
		availColors = [[NSSet alloc] initWithSet:tmpset];
		instructions = [instrs mutableCopyWithZone:NULL];
		moveList = NULL;
		worksetMoves = [[NSMutableSet alloc] init];
		nodecolorMap = [[NSMutableDictionary alloc] init];
		colortempMap = [[NSMutableDictionary alloc] init];
		liveness = [[Liveness alloc] initWithRegAllocator:self];
		selectedStack = [[NSMutableArray alloc] init];
		simplifyWorkSet = [[NSMutableSet alloc] init];
	}
	return self;
}
- (void)allocateRegisters
{
	[liveness buildInterferenceGraphUsingFlowGraph:
	 [AssemFlowGraph assemFlowGraphWithInstructions:instructions]];
	//[liveness printUsingTempMap:frame];
	[self buildWorkList];
	while (![self isFinished]) {
		if ([simplifyWorkSet anyObject])
			[self simplify];
	}
	[self assignColors];
}
- (void)buildWorkList
{
	for (Node *node in liveness.nodes)
		if (![precolored containsObject:node]) {
			if (node.degree >= regNumber){// spill
			} else //if ([self isMoveRelated:node]) //freeze
				[simplifyWorkSet addObject:node];
		}
}
- (BOOL)isFinished
{
	return [simplifyWorkSet anyObject] == nil;
}
- (void)simplify
{
	Node *node = [simplifyWorkSet anyObject];
	[selectedStack addObject:node];
	[simplifyWorkSet removeObject:node];
	for (Node *m in [self adjacentNodesOfNode:node])
		[self decrementDegreeOfNode:m];
}
- (NSSet *)adjacentNodesOfNode:(Node *)aNode
{
	NSMutableSet *set = [NSMutableSet setWithSet:aNode.adj];
	[set minusSet:[NSSet setWithArray:selectedStack]];
	return set;
}
- (void)decrementDegreeOfNode:(Node *)aNode
{
	int d = aNode.degree--;
	if (d == regNumber) {
		// TODO: spill -> freeze
    [simplifyWorkSet addObject:aNode];
	}
}
- (void)assignColors
{
	Node *node;
	NSMutableSet *okColors;
	NSNumber *color;
	while (node = [selectedStack lastObject]) {
		okColors = [NSMutableSet setWithSet:availColors];
		for (Node *m in node.adj) {
			color = [nodecolorMap objectForKey:m];
			if (color)
				[okColors removeObject:color];
		}
		color = [okColors anyObject];
		if (color)
			[nodecolorMap setObject:color forKey:node];
		[selectedStack removeLastObject];
	}
}
- (void)buildPrecoloredList
{
  counter = 0;
	NSMutableSet *tmpset = [NSMutableSet set];
	[self addNodesToSet:tmpset usingArray:frame.specialregs];
	[self addNodesToSet:tmpset usingArray:frame.argregs];
	[self addNodesToSet:tmpset usingArray:frame.calleesave];
	[self addNodesToSet:tmpset usingArray:frame.callersave];
	precolored = [[NSSet alloc] initWithSet:tmpset];
}
- (void)addNodesToSet:(NSMutableSet *)aSet usingArray:(NSArray *)anArray
{
	id obj;
	NSNumber *color;
	for (TmpTemp *key in anArray) {
		obj = [liveness nodeWithTemp:key];
		color = [NSNumber numberWithInt:counter++];
		if (obj) {
			[aSet addObject:obj];
			[nodecolorMap setObject:color forKey:obj];
		}
		[colortempMap setObject:key forKey:color];
	}
}
- (NSString *)tempMapWithTemp:(TmpTemp *)temp
{
	Node *node = [liveness nodeWithTemp:temp];
	TmpTemp *reg = [colortempMap objectForKey:[nodecolorMap objectForKey:node]];
	if (reg)
		return [frame tempMapWithTemp:reg];
	else
		return [frame tempMapWithTemp:temp];
}
- (void)printToFile:(FILE *)outfile
{
	TmpTemp *def, *use;
	for (AssemInstr *instr in instructions) {
		if ([instr isMemberOfClass:[AssemMove class]]) {
			def = [instr.def lastTemp];
			use = [instr.use lastTemp];
			if ([[self tempMapWithTemp:def] isEqualToString:[self tempMapWithTemp:use]])
				continue;
		}
		fprintf(outfile, "%s", [[instr formatWithObject:self] cStringUsingEncoding:NSASCIIStringEncoding]);
	}
}
- (void)dealloc
{
	int i;
	for (i = 0; i < liveness.nodes.count; ++i)
		[moveList[i] release];
	free(moveList);
	[frame release];
	[liveness release];
	[worksetMoves release];
	[instructions release];
	[precolored release];
	[availColors release];
	[nodecolorMap release];
	[colortempMap release];
	[simplifyWorkSet release];
	[selectedStack release];
	[super dealloc];
}
+ (id)regAllocatorWithFrame:(MipsFrame *)aFrame instructions:(NSArray *)instrs
{
	return [[[RegAllocator alloc] initWithFrame:aFrame instructions:instrs] autorelease];
}
@end
