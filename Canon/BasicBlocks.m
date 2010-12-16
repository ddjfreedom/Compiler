//
//  BasicBlocks.m
//  Compiler
//
//  Created by Duan Dajun on 12/16/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "BasicBlocks.h"

@interface BasicBlocks()
- (void)makeBasicBlocksWithStmtList:(TreeStmtList *)list;
- (void)fillBlockFromStmtList:(TreeStmtList *)list;
- (void)addStmt:(TreeStmt *)aStmt;
@end

@implementation BasicBlocks
@synthesize done;
- (NSArray *)blocks
{
  return blocks;
}
- (id)initWithStmtList:(TreeStmtList *)list
{
  if (self = [super init]) {
    done = [[TmpLabel label] retain];
    blocks = [[NSMutableArray alloc] init];
  }
  return self;
}
- (void)makeBasicBlocksWithStmtList:(TreeStmtList *)list
{
  if (!list) return;
  if ([list.head isMemberOfClass:[TreeLabel class]]) {
    last = [TreeStmtList stmtListWithStmt:list.head];
    [blocks addObject:last];
  }
}
- (void)fillBlockFromStmtList:(TreeStmtList *)list
{
  if (!list)
    [self fillBlockFromStmtList:[TreeStmtList stmtListWithStmt:[TreeJump jumpWithLabel:done]]];
  else if ([list.head isMemberOfClass:[TreeJump class]] ||
           [list.head isMemberOfClass:[TreeCJump class]]) {
    [self addStmt:list.head];
    [self makeBasicBlocksWithStmtList:list.tail];
  } else if ([list.head isMemberOfClass:[TreeLabel class]]) {
  	[self fillBlockFromStmtList:[TreeStmtList stmtListWithStmt:[TreeJump jumpWithLabel:((TreeLabel *)list.head).label]
                                                      stmtList:list]];
  } else {
    [self addStmt:list.head];
    [self fillBlockFromStmtList:list.tail];
  }
}
- (void)addStmt:(TreeStmt *)aStmt
{
  last = last.tail = [TreeStmtList stmtListWithStmt:aStmt];
}
- (void)dealloc
{
  [done release];
  [blocks release];
  [super dealloc];
}
+ (id)basicBlocksWithStmtList:(TreeStmtList *)list
{
  return [[[BasicBlocks alloc] initWithStmtList:list] autorelease];
}
@end
