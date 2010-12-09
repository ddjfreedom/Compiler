//
//  TreeExprList.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

@class TreeExpr;
@interface TreeExprList : NSObject
{
	TreeExpr *head;
  TreeExprList *tail;
}
@property (readonly) TreeExpr *head;
@property (readonly) TreeExprList *tail;
- (id)initWithExpr:(TreeExpr *)anExpr;
- (id)initWithExpr:(TreeExpr *)anExpr exprList:(TreeExprList *)anExprList;
- (id)initWithExprs:(TreeExpr *)firstExpr, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithExprs:(TreeExpr *)firstExpr arguments:(va_list)args;
+ (id)exprListWithExpr:(TreeExpr *)aExpr;
+ (id)exprListWithExpr:(TreeExpr *)aExpr exprList:(TreeExprList *)aExprList;
+ (id)exprListWithExprs:(TreeExpr *)firstExpr, ... NS_REQUIRES_NIL_TERMINATION;
@end
