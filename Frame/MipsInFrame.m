//
//  MipsInFrame.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "MipsInFrame.h"
#import "TreeConst.h"
#import "TreeMem.h"
#import "TreeBinop.h"

@implementation MipsInFrame
@synthesize offset;
- (id)initWithOffset:(int)anOffset
{
  if (self = [super init])
    offset = anOffset;
  return self;
}
- (NSString *)description
{
  return [NSString stringWithFormat:@"InFrame: %d", offset];
}
- (TreeExpr *)exprWithFramePointer:(TreeExpr *)framePtr
{
  return [TreeMem memWithExpr:[TreeBinop binopWithLeftExpr:framePtr
                                                  binaryOp:TreePlus
                                                 rightExpr:[TreeConst constWithInt:offset]]];
}
+ (id)inFrameWithOffset:(int)anOffset
{
  return [[[MipsInFrame	alloc] initWithOffset:anOffset] autorelease];
}
@end
