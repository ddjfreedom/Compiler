//
//  TREx.m
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TREx.h"
#import "TreeConst.h"
#import "TreeCJump.h"
#import "TreeJump.h"
#import "TreeExprStmt.h"

@implementation TREx
- (id)initWithTreeExpr:(TreeExpr *)anExpr
{
  if (self = [super init])
    expr = [anExpr retain];
  return self;
}
- (TreeExpr *)unEx
{
  return expr;
}
- (TreeStmt *)unNx
{
  return [TreeExprStmt exprStmtWithExpr:expr];
}
- (TreeStmt *)unCxWithTrueLabel:(TmpLabel *)tLabel falseLabel:(TmpLabel *)fLabel
{
  if ([expr isMemberOfClass:[TreeConst class]])
    return ((TreeConst *)expr).value ? [TreeJump jumpWithLabel:tLabel] : [TreeJump jumpWithLabel:fLabel];
  return [TreeCJump cJumpWithLeftExpr:expr
                          reloperator:TreeEQ
                            rightExpr:[TreeConst constWithInt:0]
                            trueLabel:fLabel
                           falseLabel:tLabel];
}
- (void)dealloc
{
  [expr release];
  [super dealloc];
}
+ (id)exWithTreeExpr:(TreeExpr *)anExpr
{
  return [[[TREx alloc] initWithTreeExpr:anExpr] autorelease];
}
@end
