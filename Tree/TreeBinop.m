//
//  TreeBinop.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeBinop.h"


@implementation TreeBinop
@synthesize left, right;
@synthesize op;
- (id)initWithLeftExpr:(TreeExpr *)lExpr binaryOp:(TreeBinaryOperator)anOp rightExpr:(TreeExpr *)rExpr
{
  if (self = [super init]) {
    left = [lExpr retain];
    right = [rExpr retain];
    op = anOp;
  }
  return self;
}
- (void)dealloc
{
  [left release];
  [right release];
  [super dealloc];
}
+ (id)binopWithLeftExpr:(TreeExpr *)lExpr binaryOp:(TreeBinaryOperator)anOp rightExpr:(TreeExpr *)rExpr
{
  return [[[TreeBinop alloc] initWithLeftExpr:lExpr binaryOp:anOp rightExpr:rExpr] autorelease];
}
@end
