//
//  TRCx.m
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TRCx.h"
#import "TmpTemp.h"
#import "TreeSeq.h"
#import "TreeLabel.h"
#import "TreeESeq.h"
#import "TreeTemp.h"
#import "TreeMove.h"
#import "TreeConst.h"

@implementation TRCx
- (TreeExpr *)unEx
{
  TmpTemp *r = [TmpTemp temp];
  TmpLabel *tLabel = [TmpLabel label];
  TmpLabel *fLabel = [TmpLabel label];
  TreeSeq *seq = [TreeSeq seqWithFirstStmt:[TreeMove moveWithDestination:[TreeTemp treeTempWithTemp:r]
                                                                  source:[TreeConst constWithInt:0]]
                                secondStmt:[TreeLabel treeLabelWithLabel:tLabel]];
  seq = [TreeSeq seqWithFirstStmt:[TreeLabel treeLabelWithLabel:fLabel]
                       secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[self unCxWithTrueLabel:tLabel falseLabel:fLabel]
                       secondStmt:seq];
  seq = [TreeSeq seqWithFirstStmt:[TreeMove moveWithDestination:[TreeTemp treeTempWithTemp:r]
                                                         source:[TreeConst constWithInt:0]]
                       secondStmt:seq];
  return [TreeESeq eseqWithStmt:seq expr:[TreeTemp treeTempWithTemp:r]];
}
- (TreeStmt *)unNx
{
  TmpLabel *tLabel = [TmpLabel label];
  TmpLabel *fLabel = [TmpLabel label];
  return [self unCxWithTrueLabel:tLabel falseLabel:fLabel];
}
@end
