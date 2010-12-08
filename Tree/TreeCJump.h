//
//  TreeCJump.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeStmt.h"
#import "TreeExpr.h"
#import "TmpLabel.h"

typedef enum {
  TreeInvalidOp = -1,
  TreeEQ = 0,
  TreeNE,
  TreeLT,
  TreeGT,
  TreeLE,
  TreeGE,
  TreeULT,
  TreeUGT,
  TreeULE,
  TreeUGE
} TreeRelationOperator;

@interface TreeCJump : TreeStmt
{
	TreeRelationOperator relationOp;
  TreeExpr *left, *right;
  TmpLabel *iftrue, *iffalse;
}
@property (readonly) TreeRelationOperator relationOp;
@property (readonly) TreeExpr *left, *right;
@property (readonly) TmpLabel *iftrue, *iffalse;
- (id)initWithLeftExpr:(TreeExpr *)lExpr
           reloperator:(TreeRelationOperator)anOp
             rightExpr:(TreeExpr *)rExpr
             trueLabel:(TmpLabel *)aTrueLabel
            falseLabel:(TmpLabel *)aFalseLabel;
+ (id)cJumpWithLeftExpr:(TreeExpr *)lExpr
           	reloperator:(TreeRelationOperator)anOp
              rightExpr:(TreeExpr *)rExpr
             	trueLabel:(TmpLabel *)aTrueLabel
             falseLabel:(TmpLabel *)aFalseLabel;
+ (TreeRelationOperator)notRelation:(TreeRelationOperator)anOp;
@end
