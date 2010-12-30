//
//  InterferenceGraph.m
//  Compiler
//
//  Created by Duan Dajun on 12/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "InterferenceGraph.h"


@implementation InterferenceGraph
- (TmpTemp *)tempWithNode:(Node *)aNode
{
  NSAssert(NO, @"tempWithNode: should not call this directly");
  return nil;
}
- (Node *)nodeWithTemp:(TmpTemp *)aTemp
{
  NSAssert(NO, @"nodeWithTemp: should not call this directly");
  return nil;
}
- (int)spillCostForNode:(Node *)aNode
{
  return 1;
}
@end
