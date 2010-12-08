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
@property (readonly) TreeStmt *head;
@property (readonly) TreeStmtList *tail;
- (id)initWithStmt:(TreeStmt *)aStmt;
- (id)initWithStmt:(TreeStmt *)aStmt stmtList:(TreeStmtList *)aStmtList;
+ (id)stmtListWithStmt:(TreeStmt *)aStmt;
+ (id)stmtListWithStmt:(TreeStmt *)aStmt stmtList:(TreeStmtList *)aStmtList;
@end
