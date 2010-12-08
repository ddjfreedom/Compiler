//
//  TreeExprStmt.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeStmt.h"
#import "TreeExpr.h"

@interface TreeExprStmt : TreeStmt
{
	TreeExpr *expr;	
}
@property (readonly) TreeExpr *expr;
- (id)initWithExpr:(TreeExpr *)anExpr;
+ (id)exprStmtWithExpr:(TreeExpr *)anExpr;
@end
