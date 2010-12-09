//
//  MipsFrame.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "MipsFrame.h"
#import "MipsInReg.h"
#import "MipsInFrame.h"
#import "TreeName.h"
#import "TreeCall.h"

#define WORDLENGTH 4
#define CALC_OFFSET(X) (-(WORDLENGTH * (++X)))

@implementation MipsFrame
@synthesize frameCount;

- (id)init
{
  return [self initWithLabel:nil boolList:nil];
}
- (id)initWithLabel:(TmpLabel *)aLabel boolList:(BoolList *)aBoolList
{
  if (self = [super init]) {
    name = [aLabel retain];
    frameCount = 0;
    wordSize = WORDLENGTH;
    fp = [TmpTemp temp];
    if (aBoolList) {
    	formals = [[NSMutableArray alloc] init];
    	for (; aBoolList; aBoolList = aBoolList.tail) {
    	  if (aBoolList.head)
    	    [formals addObject:[MipsInFrame inFrameWithOffset:CALC_OFFSET(frameCount)]];
    	  else
    	    [formals addObject:[MipsInReg inRegWithTemp:[TmpTemp temp]]];
    	}
    } else
      formals = nil;
  }
  return self;
}
- (Access *)generateLocal:(BOOL)isEscaped
{
  if (isEscaped)
    return [MipsInFrame inFrameWithOffset:CALC_OFFSET(frameCount)];
  else
    return [MipsInReg inRegWithTemp:[TmpTemp temp]];
}
- (Frame *)newFrameWith:(TmpLabel *)aLabel boolList:(BoolList *)aBoolList
{
  return [[MipsFrame alloc] initWithLabel:aLabel boolList:aBoolList];
}
- (NSString *)description
{
  return [NSString stringWithFormat:@"MipsFrame: %@\n %@\n %d\n", name, formals, frameCount];
}
- (TreeExpr *)externalCallWithName:(NSString *)aName arguments:(TreeExprList *)args
{
  return [TreeCall callWithExpr:[TreeName nameWithLabel:[TmpLabel labelWithString:aName]]
                       exprList:args];
}
- (void)dealloc
{
  [formals release];
  [name release];
  [super dealloc];
}
@end
