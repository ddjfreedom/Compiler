//
//  TreeESeq.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeExpr.h"
#import "TreeStmt.h"

@interface TreeESeq : TreeExpr
{
	TreeStmt *stmt;
  TreeExpr *expr;
}
@property (readonly) TreeStmt *stmt;
@property (readonly) TreeExpr *expr;
- (id)initWithStmt:(TreeStmt *)aStmt expr:(TreeExpr *)anExpr;
+ (id)eseqWithStmt:(TreeStmt *)aStmt expr:(TreeExpr *)anExpr;
@end
