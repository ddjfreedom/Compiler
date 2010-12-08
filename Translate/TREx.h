//
//  TREx.h
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TRExpr.h"

@interface TREx : TRExpr
{
	TreeExpr *expr;
}
- (id)initWithTreeExpr:(TreeExpr *)anExpr;
- (TreeExpr *)unEx;
- (TreeStmt *)unNx;
- (TreeStmt *)unCxWithTrueLabel:(TmpLabel *)tLabel falseLabel:(TmpLabel *)fLabel;
+ (id)exWithTreeExpr:(TreeExpr *)anExpr;
@end
