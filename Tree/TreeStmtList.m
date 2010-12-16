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
- (id)initWithStmts:(TreeStmt *)firstStmt, ...
{
  va_list args;
  va_start(args, firstStmt);
  [self initWithStmts:firstStmt arguments:args];
  va_end(args);
  return self;
}
- (id)initWithStmts:(TreeStmt *)firstStmt arguments:(va_list)args
{
  if (self = [super init]) {
    TreeStmtList *last = self;
    TreeStmt *arg;
    head = [firstStmt retain];
    tail = nil;
    while (arg = va_arg(args, TreeStmt*))
      last = last->tail = [[TreeStmtList stmtListWithStmt:arg] retain];
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
+ (id)stmtListWithStmts:(TreeStmt *)firstStmt, ...
{
  va_list args;
  va_start(args, firstStmt);
	TreeStmtList *result = [[[TreeStmtList alloc] initWithStmts:firstStmt arguments:args] autorelease];
  va_end(args);
  return result;
}
@end
