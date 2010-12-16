//
//  Canon.h
//  Compiler
//
//  Created by Duan Dajun on 12/16/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "Tree.h"

@interface Canon : NSObject
{

}
+ (BOOL)doesStmt:(TreeStmt *)aStmt commuteWithExpr:(TreeExpr *)anExpr;
+ (BOOL)isNop:(TreeStmt *)aStmt;
+ (TreeStmt *)seqWithFirstStmt:(TreeStmt *)stmt1 secondStmt:(TreeStmt *)stmt2;
+ (TreeStmt *)seqWithFirstStmt:(TreeStmt *)stmt1, ... NS_REQUIRES_NIL_TERMINATION;
+ (TreeStmt *)doStmtWithStmt:(TreeStmt *)aStmt;
+ (TreeStmt *)reorderStmt:(TreeStmt *)aStmt;
+ (TreeESeq *)reorderExpr:(TreeExpr *)anExpr;
+ (TreeStmtList *)linearizeStmt:(TreeStmt *)aStmt;
@end
