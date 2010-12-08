//
//  TreeStmtList.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeStmtList.h"


@implementation TreeStmtList
@synthesize head;
@synthesize tail;
- (id)initWithStmt:(TreeStmt *)aStmt
{
  return [self initWithStmt:aStmt stmtList:nil];
}
- (id)initWithStmt:(TreeStmt *)aStmt stmtList:(TreeStmtList *)aStmtList
{
  if (self = [super init]) {
    head = [aStmt retain];
    tail = [aStmtList retain];
  }
  return self;
}
- (void)dealloc
{
  [head release];
  [tail release];
  [super dealloc];
}
+ (id)stmtListWithStmt:(TreeStmt *)aStmt
{
  return [[[TreeStmtList alloc] initWithStmt:aStmt] autorelease];
}
+ (id)stmtListWithStmt:(TreeStmt *)aStmt stmtList:(TreeStmtList *)aStmtList
{
  return [[[TreeStmtList alloc] initWithStmt:aStmt stmtList:aStmtList] autorelease];
}
@end
