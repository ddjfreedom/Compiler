//
//  FlowGraph.m
//  Compiler
//
//  Created by Duan Dajun on 12/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "FlowGraph.h"


@implementation FlowGraph
- (TmpTempList *)defOfNode:(Node *)aNode
{
  NSAssert(NO, @"defOfNode:, should not call this directly");
  return nil;
}
- (TmpTempList *)useOfNode:(Node *)aNode
{
  NSAssert(NO, @"useOfNode:, should not call this directly");
  return nil;
}
- (BOOL)iSMove:(Node *)aNode
{
  NSAssert(NO, @"isMove:, should not call this directly");
  return NO;
}
@end
