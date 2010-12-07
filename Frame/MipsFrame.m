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

#define WORDLENGTH 4
#define CALC_OFFSET(X) (-(WORDLENGTH * (++X)))

@implementation MipsFrame
@synthesize frameCount;
- (id)initWithLabel:(TmpLabel *)aLabel boolList:(BoolList *)aBoolList
{
  if (self = [super init]) {
    name = [aLabel retain];
    formals = [[NSMutableArray alloc] init];
    frameCount = 0;
    for (; aBoolList; aBoolList = aBoolList.tail) {
      if (aBoolList.head)
        [formals addObject:[MipsInFrame inFrameWithOffset:CALC_OFFSET(frameCount)]];
      else
        [formals addObject:[MipsInReg inRegWithTemp:[TmpTemp temp]]];
    }
  }
  return self;
}
- (Access *)allocLocal:(BOOL)isEscaped
{
  if (isEscaped)
    return [[MipsInFrame alloc] initWithOffset:CALC_OFFSET(frameCount)];
  else
    return [[MipsInReg alloc] initWithTemp:[TmpTemp temp]];
}
- (Frame *)newFrameWith:(TmpLabel *)aLabel boolList:(BoolList *)aBoolList
{
  return [[MipsFrame alloc] initWithLabel:aLabel boolList:aBoolList];
}
- (NSString *)description
{
  return [NSString stringWithFormat:@"MipsFrame: %@\n %@\n %d\n", name, formals, frameCount];
}
- (void)dealloc
{
  [formals release];
  [name release];
  [super dealloc];
}
@end
