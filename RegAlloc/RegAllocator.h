//
//  RegAllocator.h
//  Compiler
//
//  Created by Duan Dajun on 1/1/11.
//  Copyright 2011 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MipsFrame.h"
#import "Liveness.h"
#import "TmpTempMap.h"

@interface RegAllocator : NSObject <TmpTempMap>
{
	int regNumber;
	MipsFrame *frame;
	Liveness *liveness;
	NSMutableArray *instructions;
	NSMutableSet **moveList;
	NSMutableSet *worksetMoves;
	NSSet *precolored, *availColors;
	NSMutableSet *simplifyWorkSet;
	//NSMutableSet *freezeWorkSet;
	//NSMutableSet *spillWorkSet;
	NSMutableArray *selectedStack;
	NSMutableDictionary *nodecolorMap;
	NSMutableDictionary *colortempMap;
}
@property (readwrite, assign) NSMutableSet **moveList;
@property (readonly) NSMutableSet *worksetMoves;
@property (readonly) NSSet *precolored;
- (id)initWithFrame:(MipsFrame *)aFrame instructions:(NSArray *)instrs;
- (void)allocateRegisters;
- (void)buildPrecoloredList;
+ (id)regAllocatorWithFrame:(MipsFrame *)aFrame instructions:(NSArray *)instrs;
@end
