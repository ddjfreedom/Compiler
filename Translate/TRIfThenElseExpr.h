//
//  TRIfThenElseExpr.h
//  Compiler
//
//  Created by Duan Dajun on 12/9/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TRExpr.h"
#import "TreeStmt.h"
#import "TmpLabel.h"

@interface TRIfThenElseExpr : TRExpr
{
	TRExpr *test, *thenClause, *elseClause;
  TmpLabel *tL, *eL, *joinL;
}
- (id)initWithTest:(TRExpr *)aTest thenClause:(TRExpr *)tClause elseClause:(TRExpr *)eClause;
- (TreeExpr *)unEx;
- (TreeStmt *)unNx;
- (TreeStmt *)unCxWithTrueLabel:(TmpLabel *)tLabel falseLabel:(TmpLabel *)fLabel;
+ (id)exprWithTest:(TRExpr *)aTest thenClause:(TRExpr *)tClause elseClause:(TRExpr *)eClause;
@end
