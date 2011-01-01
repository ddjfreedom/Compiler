//
//  MipsCodegen.m
//  Compiler
//
//  Created by Duan Dajun on 12/19/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "MipsCodegen.h"
#import "Assem.h"
@interface MipsCodegen()
@property (readonly) TmpTempList *calldefs;
- (TmpTemp *)munchBinop:(TreeBinop *)aBinop;
- (TmpTemp *)munchConst:(TreeConst *)aConst;
- (TmpTemp *)munchMem:(TreeMem *)aMem;
- (TmpTemp *)munchCall:(TreeCall *)aCall;
- (TmpTemp *)munchName:(TreeName *)aName;
- (TmpTempList *)munchArgs:(TreeExprList *)args;
- (void)munchMove:(TreeMove *)aMove;
- (void)munchJump:(TreeJump *)aJump;
- (void)munchCJump:(TreeCJump *)aCJump;
@end

@implementation MipsCodegen
- (id)initWithFrame:(MipsFrame *)aFrame
{
  if (self = [super init]) {
    frame = [aFrame retain];
    instructions = [[NSMutableArray alloc] init];
  }
  return self;
}
- (TmpTemp *)munchExpr:(TreeExpr *)anExpr
{
  if ([anExpr isMemberOfClass:[TreeBinop class]])
    return [self munchBinop:(TreeBinop *)anExpr];
  else if ([anExpr isMemberOfClass:[TreeConst class]])
    return [self munchConst:(TreeConst *)anExpr];
  else if ([anExpr isMemberOfClass:[TreeMem class]])
    return [self munchMem:(TreeMem *)anExpr];
  else if ([anExpr isMemberOfClass:[TreeTemp class]])
    return ((TreeTemp *)anExpr).temp;
  else if ([anExpr isMemberOfClass:[TreeCall class]])
    return [self munchCall:(TreeCall *)anExpr];
  else if ([anExpr isMemberOfClass:[TreeName class]])
    return [self munchName:(TreeName *)anExpr];
  NSAssert(NO, @"Unknown Expr in munchExpr:");
  return nil;
}
- (TmpTemp *)munchMem:(TreeMem *)aMem
{
  TmpTemp *r = [TmpTemp temp];
  if ([aMem.expr isMemberOfClass:[TreeConst class]])
    [instructions addObject:[AssemOper operWithString:[NSString stringWithFormat:@"lw $`d0, %d($zero)\n",
                                                       ((TreeConst *)aMem.expr).value]
                                  destinationTempList:[TmpTempList tempListWithTemp:r]
                                       sourceTempList:nil]];
  else if ([aMem.expr isMemberOfClass:[TreeTemp class]])
    [instructions addObject:[AssemOper operWithString:@"lw $`d0, 0($`s0)\n"
                                  destinationTempList:[TmpTempList tempListWithTemp:r]
                                       sourceTempList:[TmpTempList tempListWithTemp:((TreeTemp *)aMem.expr).temp]]];
  else if ([aMem.expr isMemberOfClass:[TreeBinop class]]) {
    TreeBinop *binop = (TreeBinop *)aMem.expr;
    TreeConst *c = nil;
    TreeExpr *reg = nil;
    if (binop.op == TreePlus || binop.op == TreeMinus)
    	if ([binop.left isMemberOfClass:[TreeConst class]]) {
    	  c = (TreeConst *)binop.left;
    	  reg = binop.right;
    	} else if ([binop.right isMemberOfClass:[TreeConst class]]) {
    	  c = (TreeConst *)binop.right;
    	  reg = binop.left;
    	}
    if (c)
      [instructions addObject:[AssemOper operWithString:[NSString stringWithFormat:@"lw $`d0, %d($`s0)\n",
                                                         binop.op == TreePlus ? c.value : -(c.value)]
                                    destinationTempList:[TmpTempList tempListWithTemp:r]
                                         sourceTempList:[TmpTempList tempListWithTemp:[self munchExpr:reg]]]];
    else
      [instructions addObject:[AssemOper operWithString:@"lw $`d0, 0($`s0)\n"
                                    destinationTempList:[TmpTempList tempListWithTemp:r]
                                         sourceTempList:[TmpTempList tempListWithTemp:[self munchExpr:binop]]]];
  } else
    NSAssert(NO, @"Unknown Mem Expr");
  return r;
}
- (TmpTemp *)munchConst:(TreeConst *)aConst
{
  TmpTemp *r = [TmpTemp temp];
  [instructions addObject:[AssemOper operWithString:[NSString stringWithFormat:@"li $`d0, %d\n",
                                                     aConst.value]
                                destinationTempList:[TmpTempList tempListWithTemp:r]
                                     sourceTempList:nil]];
  return r;
}
- (TmpTemp *)munchBinop:(TreeBinop *)aBinop
{
  TmpTemp *r = [TmpTemp temp];
  switch (aBinop.op) {
  	case TreePlus:
      if ([aBinop.left isMemberOfClass:[TreeConst class]]) {
        [instructions addObject:[AssemOper operWithString:[NSString stringWithFormat:@"addiu $`d0, $`s0, %d\n",
                                                           ((TreeConst *)aBinop.left).value]
                                      destinationTempList:[TmpTempList tempListWithTemp:r]
                                           sourceTempList:[TmpTempList
                                                           tempListWithTemp:[self munchExpr:aBinop.right]]]];
        break;
      }
    case TreeMinus:
      if ([aBinop.right isMemberOfClass:[TreeConst class]]) {
        [instructions addObject:[AssemOper operWithString:[NSString stringWithFormat:@"addiu $`d0, $`s0, %s%d\n",
                                                           aBinop.op == TreePlus ? "" : "-",
                                                           ((TreeConst *)aBinop.right).value]
                                      destinationTempList:[TmpTempList tempListWithTemp:r]
                                           sourceTempList:[TmpTempList 
                                                           tempListWithTemp:[self munchExpr:aBinop.left]]]];
      } else
        [instructions addObject:[AssemOper operWithString:[NSString stringWithFormat:@"%s $`d0, $`s0, $`s1\n",
                                                           aBinop.op == TreePlus ? "addu" : "subu"]
                                      destinationTempList:[TmpTempList tempListWithTemp:r]
                                           sourceTempList:[TmpTempList tempListWithTemps:
                                                           [self munchExpr:aBinop.left],
                                                           [self munchExpr:aBinop.right], nil]]];
      break;
    case TreeMultiply: case TreeDivide:
      // mult $s1, $s2 OR div $s1, $s2
      [instructions addObject:[AssemOper operWithString:[NSString stringWithFormat:@"%s $`s0, $`s1\n",
                                                          aBinop.op == TreeDivide ? "div" : "mult"]
                                      destinationTempList:nil
                                           sourceTempList:[TmpTempList tempListWithTemps:
                                                           [self munchExpr:aBinop.left],
                                                           [self munchExpr:aBinop.right], nil]]];
      // mflo $d, move a value from LO to $d
      [instructions addObject:[AssemOper operWithString:@"mflo $`d0\n"
                                      destinationTempList:[TmpTempList tempListWithTemp:r]
                                           sourceTempList:nil]];
      break;
    // TODO: other binary op
    default: NSAssert(NO, @"Unknown Op");
  }
  return r;
}
- (TmpTemp *)munchCall:(TreeCall *)aCall
{
  NSAssert([aCall.func isMemberOfClass:[TreeName class]], @"Bad Call in munchCall:");
	TmpTemp *r = [TmpTemp temp];
	[instructions addObject:[AssemMove assemMoveWithString:@"move $`d0, $`s0\n"
																				 destinationTemp:r
																							sourceTemp:[frame.specialregs objectAtIndex:4]]];
  TmpTempList *args = [self munchArgs:aCall.args];
  [instructions addObject:[AssemOper operWithString:[NSString stringWithFormat:@"jal %@\n",
                                                     ((TreeName *)aCall.func).label.name]
                                destinationTempList:self.calldefs
                                     sourceTempList:args]];
	[instructions addObject:[AssemMove assemMoveWithString:@"move $`d0, $`s0\n"
																				 destinationTemp:[frame.specialregs objectAtIndex:4]
																							sourceTemp:r]];
	return frame.rv;
}
- (TmpTempList *)munchArgs:(TreeExprList *)args
{
  // MARK: Assume less than or equal to 4 arguments
  int i = 0;
  TmpTempList *list = [TmpTempList tempList];
	while (args) {
    if (![args.head isMemberOfClass:[TreeConst class]])
  		[instructions addObject:[AssemMove assemMoveWithString:@"move $`d0, $`s0\n"
                                             destinationTemp:[frame.argregs objectAtIndex:i]
                                                  sourceTemp:[self munchExpr:args.head]]];
    else
      [instructions addObject:[AssemOper operWithString:[NSString stringWithFormat:@"li $`d0, %d\n",
                                                         ((TreeConst *)args.head).value]
                                    destinationTempList:[TmpTempList tempListWithTemp:[frame.argregs objectAtIndex:i]]
                                         sourceTempList:nil]];
    [list addTemp:[frame.argregs objectAtIndex:i++]];
    args = args.tail;
  }
  return list;
}
- (TmpTempList *)calldefs
{
  int i, c = frame.specialregs.count;
  TmpTempList *list = [TmpTempList tempList];
	for (i = 2; i < c; ++i) // $v0, $v1, $ra
  	[list addTemp:[frame.specialregs objectAtIndex:i]];
  for (TmpTemp *tmp in frame.callersave) // $t0~$t9
    [list addTemp:tmp];
  for (TmpTemp *tmp in frame.argregs) // $a0~$a3
    [list addTemp:tmp];
  return list;
}
- (TmpTemp *)munchName:(TreeName *)aName
{
  TmpTemp *r = [TmpTemp temp];
  [instructions addObject:[AssemOper operWithString:[NSString stringWithFormat:@"la $`d0, %@\n",
                                                     aName.label.name]
                                destinationTempList:[TmpTempList tempListWithTemp:r]
                                     sourceTempList:nil]];
  return r;
}
- (void)munchStmt:(TreeStmt *)aStmt
{
  if ([aStmt isMemberOfClass:[TreeSeq class]]) {
    [self munchStmt:((TreeSeq *)aStmt).first];
    [self munchStmt:((TreeSeq *)aStmt).second];
  } else if ([aStmt isMemberOfClass:[TreeLabel class]])
    [instructions addObject:[AssemLabel assemLabelWithString:[NSString stringWithFormat:@"%@:\n",
                                                              ((TreeLabel *)aStmt).label.name]
                                                    tmpLabel:((TreeLabel *)aStmt).label]];
  else if ([aStmt isMemberOfClass:[TreeMove class]])
    [self munchMove:(TreeMove *)aStmt];
  else if ([aStmt isMemberOfClass:[TreeJump class]])
    [self munchJump:(TreeJump *)aStmt];
  else if ([aStmt isMemberOfClass:[TreeCJump class]])
    [self munchCJump:(TreeCJump *)aStmt];
  else if ([aStmt isMemberOfClass:[TreeExprStmt class]])
    [self munchExpr:((TreeExprStmt *)aStmt).expr];
}
- (void)munchMove:(TreeMove *)aMove
{
  TmpTemp *tmp = [self munchExpr:aMove.src];
  if ([aMove.dst isMemberOfClass:[TreeTemp class]])
    [instructions addObject:[AssemMove assemMoveWithString:@"move $`d0, $`s0\n"
                                           destinationTemp:((TreeTemp *)aMove.dst).temp
                                                sourceTemp:tmp]];
  else if ([aMove.dst isMemberOfClass:[TreeMem class]]) {
    TreeMem *dst = (TreeMem *)aMove.dst;
    if ([dst.expr isMemberOfClass:[TreeConst class]])
      [instructions addObject:[AssemOper operWithString:[NSString stringWithFormat:@"sw $`s0, %d($zero)\n",
                                                         ((TreeConst *)dst.expr).value]
                                    destinationTempList:nil
                                         sourceTempList:[TmpTempList tempListWithTemp:tmp]]];
    else if ([dst.expr isMemberOfClass:[TreeTemp class]])
      [instructions addObject:[AssemOper operWithString:@"sw $`s0, 0($`s1)\n"
                                    destinationTempList:nil
                                         sourceTempList:[TmpTempList tempListWithTemps:
                                                         tmp, ((TreeTemp *)dst.expr).temp, nil]]];
    else if ([dst.expr isMemberOfClass:[TreeBinop class]]) {
    	TreeBinop *binop = (TreeBinop *)dst.expr;
      TreeConst *c = nil;
      TreeExpr *reg = nil;
      if (binop.op == TreePlus || binop.op == TreeMinus)
        if ([binop.left isMemberOfClass:[TreeConst class]]) {
          c = (TreeConst *)binop.left;
          reg = binop.right;
        } else if ([binop.right isMemberOfClass:[TreeConst class]]) {
          c = (TreeConst *)binop.right;
          reg = binop.left;
        }
      if (c)
        [instructions addObject:[AssemOper operWithString:[NSString stringWithFormat:@"sw $`s0, %d($`s1)\n",
                                                           binop.op == TreePlus ? c.value : -(c.value)]
                                      destinationTempList:nil
                                           sourceTempList:[TmpTempList tempListWithTemps:
                                                           tmp, [self munchExpr:reg], nil]]];
      else
        [instructions addObject:[AssemOper operWithString:@"sw $`s0, 0($`s1)\n"
                                      destinationTempList:nil
                                           sourceTempList:[TmpTempList tempListWithTemps:
                                                           tmp, [self munchExpr:binop], nil]]];
    }
  }
}
- (void)munchJump:(TreeJump *)aJump
{
  if ([aJump.expr isMemberOfClass:[TreeName class]])
    [instructions addObject:[AssemOper operWithString:[NSString stringWithFormat:@"j %@\n",
                                                       ((TreeName *)aJump.expr).label.name]
                                  destinationTempList:nil
                                       sourceTempList:nil
                                            labelList:aJump.list]];
  else
    [instructions addObject:[AssemOper operWithString:@"jr $`s0\n"
                                  destinationTempList:nil
                                       sourceTempList:[TmpTempList tempListWithTemp:[self munchExpr:aJump.expr]]
                                            labelList:aJump.list]];
}
- (void)munchCJump:(TreeCJump *)aCJump
{
  char *cmd = "";
  switch (aCJump.relationOp) {
  	case TreeEQ: cmd = "beq"; break;
    case TreeNE: cmd = "bne"; break;
    case TreeLT: cmd = "blt"; break;
    case TreeGT: cmd = "bgt"; break;
    case TreeLE: cmd = "ble"; break;
    case TreeGE: cmd = "bge"; break;
  }
  if ([aCJump.right isMemberOfClass:[TreeConst class]] && !((TreeConst *)aCJump.right).value) {
  	switch (aCJump.relationOp) {
      case TreeEQ: case TreeNE:
        [instructions addObject:[AssemOper operWithString:[NSString stringWithFormat:@"%s $`s0, $zero, %@\n",
                                                           cmd, aCJump.iftrue.name]
                                      destinationTempList:nil
                                           sourceTempList:[TmpTempList tempListWithTemp:[self munchExpr:aCJump.left]]
                                                labelList:[TmpLabelList labelListWithLabels:
                                                           aCJump.iftrue, aCJump.iffalse, nil]]];
        break;
      case TreeLT: case TreeGT: case TreeLE: case TreeGE:
        [instructions addObject:[AssemOper operWithString:[NSString stringWithFormat:@"%sz $`s0, %@\n",
                                                           cmd, aCJump.iftrue.name]
                                      destinationTempList:nil
                                           sourceTempList:[TmpTempList tempListWithTemp:[self munchExpr:aCJump.left]]
                                                labelList:[TmpLabelList labelListWithLabels:
                                                           aCJump.iftrue, aCJump.iffalse, nil]]];
        break;
      default:
        NSAssert(NO, @"Unknown Relop in munchCJump:");
    }
  } else {
    [instructions addObject:[AssemOper operWithString:[NSString stringWithFormat:@"%s $`s0, $`s1, %@\n",
                                                       cmd, aCJump.iftrue.name]
                                  destinationTempList:nil
                                       sourceTempList:[TmpTempList tempListWithTemps:
                                                       [self munchExpr:aCJump.left], [self munchExpr:aCJump.right], nil]
                                            labelList:[TmpLabelList labelListWithLabels:
                                                       aCJump.iftrue, aCJump.iffalse, nil]]];
  }
    
}
- (NSArray *)codegenUsingStmt:(TreeStmt *)aStmt
{
  NSArray *ans = nil;
  [self munchStmt:aStmt];
  ans = [instructions autorelease];
  instructions = [[NSMutableArray alloc] init];
  return ans;
}
- (void)dealloc
{
  [frame release];
  [instructions release];
  [super dealloc];
}
+ (id)codegenWithFrame:(MipsFrame *)aFrame
{
  return [[[MipsCodegen alloc] initWithFrame:aFrame] autorelease];
}
@end
