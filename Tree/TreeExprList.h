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
+ (id)exprListWithExpr:(TreeExpr *)aExpr;
+ (id)exprListWithExpr:(TreeExpr *)aExpr exprList:(TreeExprList *)aExprList;
@end
