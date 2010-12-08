//
//  TR.m
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TR.h"
#import "TreeExpr.h"
#import "TreeConst.h"
#import "TreeTemp.h"
#import "TreeBinop.h"
#import "TreeMem.h"
#import "TREx.h"

static int wordSize = 0;
@implementation TR
+ (void)setWordSize:(int)size
{
  wordSize = size;
}
+ (TRExpr *)simpleVarWithAccess:(TRAccess *)anAcc level:(TRLevel *)aLevel
{
  TreeExpr * expr = [TreeTemp treeTempWithTemp:aLevel.frame.fp];
  TRLevel *tmplevel = aLevel;
  // follow static link
  while (anAcc.level != tmplevel) {
    expr = [((TRAccess *)[tmplevel.formals objectAtIndex:0]).acc exprWithFramePointer:expr];
    tmplevel = tmplevel.parent;
  }
  return [TREx exWithTreeExpr:[anAcc.acc exprWithFramePointer:expr]];
}
+ (TRExpr *)arrayVarWithBase:(TRExpr *)base subscript:(TRExpr *)sub level:(TRLevel *)aLevel
{
  return [TREx exWithTreeExpr:[TreeMem memWithExpr:[TreeBinop
                                                    binopWithLeftExpr:[base unEx]
                                                    binaryOp:TreePlus
                                                    rightExpr:[TreeBinop
                                                               binopWithLeftExpr:[sub unEx]
                                                               binaryOp:TreeMultiply
                                                               rightExpr:[TreeConst constWithInt:wordSize]]]]];
}
+ (TRExpr *)fieldVarWithVar:(TRExpr *)var 
                       type:(SemanticRecordType *)type 
                      field:(Symbol *)field 
                      level:(TRLevel *)aLevel
{
  NSUInteger offset = [type indexOfField:field];
  return [TREx exWithTreeExpr:[TreeMem memWithExpr:[TreeBinop binopWithLeftExpr:[TreeConst constWithInt:offset]
                                                                       binaryOp:TreeMultiply
                                                                      rightExpr:[TreeConst constWithInt:wordSize]]]]; 
}
@end
