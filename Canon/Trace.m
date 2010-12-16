//
//  Trace.m
//  Compiler
//
//  Created by Duan Dajun on 12/16/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "Trace.h"
@interface Trace()
- (TreeStmtList *)getNext;
- (TreeStmtList *)getPenultimateFromBlock:(TreeStmtList *)aBlock;
- (void)traceStmtList:(TreeStmtList *)aList;
@end

@implementation Trace
- (id)initWithBasicBlock:(BasicBlocks *)basicblocks
{
  if (self = [super init]) {
    blocks = [basicblocks retain];
    dict = [[NSMutableDictionary alloc] init];
    for (TreeStmtList *list in blocks.blocks)
      [dict setObject:list forKey:((TreeLabel *)list.head).label.name];
  }
  return self;
}
- (TreeStmtList *)getNext
{
  static int i = 0;
  int total = blocks.blocks.count;
  TreeStmtList *s;
  TreeLabel *label;
  while (i < total) {
    s = [blocks.blocks objectAtIndex:i];
    label = (TreeLabel *)s.head;
    if ([dict objectForKey:label.label.name]) {
      [self traceStmtList:s];
      return s;
    } else
      i++;
  }
  return [TreeStmtList stmtListWithStmt:[TreeLabel treeLabelWithLabel:blocks.done]];
}
- (void)traceStmtList:(TreeStmtList *)aList
{
  TreeLabel *label;
  TreeStmtList *last;
  TreeStmt *stmt;
  while (1) {
    label = (TreeLabel *)aList.head;
    last = [self getPenultimateFromBlock:aList];
    stmt = last.tail.head;
    [dict removeObjectForKey:label.label.name];
    if ([stmt isMemberOfClass:[TreeJump class]]) {
      TreeJump *jump = (TreeJump *)stmt;
      TreeStmtList *target = (TreeStmtList *)[dict objectForKey:jump.list.head.name];
      if (jump.list.count == 1 && target)
        aList = last.tail = target;
      else {
        last.tail.tail = [self getNext];
        return;
      }
    }
    else if ([stmt isMemberOfClass:[TreeCJump class]]) {
      TreeCJump *jump = (TreeCJump *)stmt;
      TreeStmtList *t = (TreeStmtList *)[dict objectForKey:jump.iftrue.name];
      TreeStmtList *f = (TreeStmtList *)[dict objectForKey:jump.iffalse.name];
      if (f)
        aList = last.tail.tail = f;
      else if (t) {
        last.tail.head = [TreeCJump cJumpWithLeftExpr:jump.left
                                          reloperator:[TreeCJump notRelation:jump.relationOp]
                                            rightExpr:jump.right
                                            trueLabel:jump.iffalse
                                           falseLabel:jump.iftrue];
        aList = last.tail.tail = t;
      } else {
        TmpLabel *ff = [TmpLabel label];
        last.tail.head = [TreeCJump cJumpWithLeftExpr:jump.left
                                          reloperator:jump.relationOp
                                            rightExpr:jump.right
                                            trueLabel:jump.iftrue
                                           falseLabel:ff];
        last.tail.tail = [TreeStmtList stmtListWithStmt:[TreeLabel treeLabelWithLabel:ff]
                                               stmtList:[TreeStmtList stmtListWithStmt:[TreeJump jumpWithLabel:jump.iffalse]
                                                                              stmtList:[self getNext]]];
        return;
      }
    }
    else
      NSAssert(NO, @"Bad Basic Block in Trace");
  }
}
- (TreeStmtList *)getPenultimateFromBlock:(TreeStmtList *)aBlock
{
  TreeStmtList *ans = aBlock;
  while (ans.tail.tail) ans = ans.tail;
  return ans;
}
- (void)dealloc
{
  [blocks release];
  [dict release];
  [super dealloc];
}
@end
