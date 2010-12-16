//
//  TreeStmtList.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

@class TreeStmt;
@interface TreeStmtList : NSObject 
{
	TreeStmt *head;
  TreeStmtList *tail;
}
@property (retain) TreeStmt *head;
@property (retain) TreeStmtList *tail;
- (id)initWithStmt:(TreeStmt *)aStmt;
- (id)initWithStmt:(TreeStmt *)aStmt stmtList:(TreeStmtList *)aStmtList;
- (id)initWithStmts:(TreeStmt *)firstStmt, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithStmts:(TreeStmt *)firstStmt arguments:(va_list)args;
+ (id)stmtListWithStmt:(TreeStmt *)aStmt;
+ (id)stmtListWithStmt:(TreeStmt *)aStmt stmtList:(TreeStmtList *)aStmtList;
+ (id)stmtListWithStmts:(TreeStmt *)firstStmt, ... NS_REQUIRES_NIL_TERMINATION;
@end
