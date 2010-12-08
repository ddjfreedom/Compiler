//
//  TreeCall.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeExpr.h"
#import "TreeExprList.h"

@interface TreeCall : TreeExpr
{
	TreeExpr *func;
  TreeExprList *args;
}
@property (readonly) TreeExpr *func;
@property (readonly) TreeExprList *args;
- (id)initWithExpr:(TreeExpr *)anExpr exprList:(TreeExprList *)anExprList;
+ (id)callWithExpr:(TreeExpr *)anExpr exprList:(TreeExprList *)anExprList;
@end
