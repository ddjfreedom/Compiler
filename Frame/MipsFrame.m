//
//  MipsFrame.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "MipsFrame.h"
#import "MipsInReg.h"
#import "MipsInFrame.h"
#import "MipsCodegen.h"
#import "Tree.h"
#import "TmpTempList.h"
#import "Assem.h"

#define WORDLENGTH 4
#define CALC_OFFSET(X) (-(WORDLENGTH * (++X)))
static NSArray *argregs = nil;
static NSArray *specialregs = nil;
static NSArray *calleesave = nil;
static NSArray *callersave = nil;
static TmpTempList *returnsink = nil;

@implementation MipsFrame
@synthesize frameCount;
//@synthesize zero;
- (NSArray *)specialregs
{
  return specialregs;
}
- (NSArray *)argregs
{
  return argregs;
}
- (NSArray *)calleesave
{
  return calleesave;
}
- (NSArray *)callersave
{
  return callersave;
}
- (TmpTemp *)fp
{
  return [specialregs objectAtIndex:0];
}
- (TmpTemp *)rv
{
  return [specialregs objectAtIndex:2];
}
- (id)init
{
  return [self initWithLabel:[TmpLabel labelWithString:@"main"] boolList:nil];
}
- (id)initWithLabel:(TmpLabel *)aLabel boolList:(BoolList *)aBoolList
{
  if (self = [super init]) {
    name = [aLabel retain];
    frameCount = 0;
    wordSize = WORDLENGTH;
    //zero = [[TmpTemp alloc] init];
    if (aBoolList) {
    	formals = [[NSMutableArray alloc] init];
    	for (; aBoolList; aBoolList = aBoolList.tail) {
    	  if (aBoolList.head)
    	    [formals addObject:[MipsInFrame inFrameWithOffset:CALC_OFFSET(frameCount)]];
    	  else
    	    [formals addObject:[MipsInReg inRegWithTemp:[TmpTemp temp]]];
    	}
    } else
      formals = nil;
  }
  return self;
}
- (Access *)generateLocal:(BOOL)isEscaped
{
  if (isEscaped)
    return [MipsInFrame inFrameWithOffset:CALC_OFFSET(frameCount)];
  else
    return [MipsInReg inRegWithTemp:[TmpTemp temp]];
}
- (Frame *)newFrameWith:(TmpLabel *)aLabel boolList:(BoolList *)aBoolList
{
  return [[MipsFrame alloc] initWithLabel:aLabel boolList:aBoolList];
}
- (NSString *)description
{
  return [NSString stringWithFormat:@"MipsFrame: %@\n %@\n %d\n", name, formals, frameCount];
}
- (TreeExpr *)externalCallWithName:(NSString *)aName arguments:(TreeExprList *)args
{
  return [TreeCall callWithExpr:[TreeName nameWithLabel:[TmpLabel labelWithString:aName]]
                       exprList:args];
}
- (NSString *)tempMapWithTemp:(TmpTemp *)temp
{
  NSUInteger i = 0;
  if ((i = [specialregs indexOfObject:temp]) != NSNotFound) {
    switch (i) {
    	case 0: return @"fp";
      case 1: return @"sp";
      case 2: return @"v0";
      case 3: return @"v1";
      case 4: return @"ra";
    }
  } else if ((i = [argregs indexOfObject:temp]) != NSNotFound)
  	return [NSString stringWithFormat:@"a%d", i];
  else if ((i = [callersave indexOfObject:temp]) != NSNotFound)
    return [NSString stringWithFormat:@"t%d", i];
  else if ((i = [calleesave indexOfObject:temp]) != NSNotFound)
    return [NSString stringWithFormat:@"s%d", i];
  return temp.name;
}
- (TreeExpr *)storeAccess:(MipsInFrame *)access
{
	return [TreeMem memWithExpr:[TreeBinop binopWithLeftExpr:[TreeTemp treeTempWithTemp:self.fp]
																									binaryOp:TreePlus
																								 rightExpr:[TreeConst constWithInt:((MipsInFrame *)access).offset]]];
}
- (TreeStmt *)procEntryExit1WithStmt:(TreeStmt *)body
{
	int i;
	Access *access;
	NSMutableArray *callee = [NSMutableArray array];
	TreeTemp *sp = [TreeTemp treeTempWithTemp:[specialregs objectAtIndex:1]];
	TreeTemp *framep = [TreeTemp treeTempWithTemp:self.fp];
	for (i = MIN(3, formals.count-1); i >= 0; --i) {
		access = [formals objectAtIndex:i];
		if ([access isMemberOfClass:[MipsInFrame class]]) {
			body = [TreeSeq seqWithFirstStmt:[TreeMove 
																				moveWithDestination:[self storeAccess:(MipsInFrame *)access]
																				source:[TreeTemp treeTempWithTemp:
																								[argregs objectAtIndex:i]]]
														secondStmt:body];
		}
	}
	for (TmpTemp *ttemp in calleesave)
		[callee addObject:[self generateLocal:YES]];
	body = [TreeSeq seqWithFirstStmt:[TreeMove
																		moveWithDestination:sp
																		source:[TreeBinop binopWithLeftExpr:sp
																															 binaryOp:TreeMinus
																															rightExpr:[TreeConst constWithInt:(wordSize*frameCount)]]]
												secondStmt:body];
	i = 0;
	for (TmpTemp *ttemp in calleesave) {
		body = [TreeSeq seqWithFirstStmt:[TreeMove
																			moveWithDestination:[self storeAccess:[callee objectAtIndex:i++]]
																			source:[TreeTemp treeTempWithTemp:ttemp]]
													secondStmt:body];
	}
	// move $fp, $sp
	body = [TreeSeq seqWithFirstStmt:[TreeMove moveWithDestination:framep
																													source:sp]
												secondStmt:body];
	i = 0;
	for (TmpTemp *ttemp in calleesave) {
		body = [TreeSeq seqWithFirstStmt:body
													secondStmt:[TreeMove
																			moveWithDestination:[TreeTemp treeTempWithTemp:ttemp]
																			source:[self storeAccess:[callee objectAtIndex:i++]]]];
	}
	body = [TreeSeq seqWithFirstStmt:body
												secondStmt:[TreeMove moveWithDestination:sp
																													source:framep]];
	body = [TreeSeq seqWithFirstStmt:body
												secondStmt:[TreeMove moveWithDestination:framep
																													source:[self storeAccess:[formals objectAtIndex:0]]]];
  return body;
}
- (NSMutableArray *)procEntryExit2WithInstructions:(NSMutableArray *)body
{
  if (![name.name isEqualToString:@"main"])
  	[body addObject:[AssemOper operWithString:@""
    	                    destinationTempList:nil
      	                       sourceTempList:returnsink]];
  return body;
}
- (Proc *)procEntryExit3WithInstructions:(NSMutableArray *)body
{
  if ([name.name isEqualToString:@"main"]) {
    [body insertObject:[AssemLabel assemLabelWithString:[NSString stringWithFormat:@"tigermain:\n",
                                                         name.name]
                                               tmpLabel:name]
               atIndex:0];    
		[body insertObject:[AssemMove assemMoveWithString:@"move $`d0, $`s0\n"
																			destinationTemp:self.fp
																					 sourceTemp:[self.specialregs objectAtIndex:1]]
							 atIndex:1];
    [body addObject:[AssemOper operWithString:@"li $`d0, 10\n"
                          destinationTempList:[TmpTempList tempListWithTemp:[specialregs objectAtIndex:2]]
                               sourceTempList:nil]];
    [body addObject:[AssemOper operWithString:@"syscall\n"
                          destinationTempList:nil
                               sourceTempList:nil]];
  } else {
    [body insertObject:[AssemLabel assemLabelWithString:[NSString stringWithFormat:@".globl %@\n.ent %@\n%@:\n",
                                                         name.name, name.name, name.name]
                                               tmpLabel:name]
               atIndex:0];    
    [body addObject:[AssemOper operWithString:@"jr $`s0\n"
    	                    destinationTempList:nil
      	                       sourceTempList:[TmpTempList tempListWithTemp:[specialregs objectAtIndex:4]]]];
    [body addObject:[AssemLabel assemLabelWithString:[NSString stringWithFormat:@".end %@\n", name.name]
                                            tmpLabel:name]];
  }
  return [Proc procWithArray:body];
}
- (NSArray *)codegenUsingStmts:(TreeStmtList *)aStmtList
{
  NSMutableArray *instrs = [NSMutableArray array];
  MipsCodegen *codegen = [MipsCodegen codegenWithFrame:self];
  for (; aStmtList; aStmtList = aStmtList.tail)
    [instrs addObjectsFromArray:[codegen codegenUsingStmt:aStmtList.head]];
  [self procEntryExit2WithInstructions:instrs];
  [self procEntryExit3WithInstructions:instrs];
  return instrs;
}
- (NSString *)transString:(TRDataFrag *)strlit
{
	return [NSString stringWithFormat:@".data\n%@: .asciiz \"%@\"\n.text\n", strlit.label.name, strlit.string];
}
- (void)dealloc
{
  [formals release];
  [name release];
  //[zero release];
  [super dealloc];
}
+ (void)initialize
{
  if (self == [MipsFrame class]) {
    // $fp, $sp, $v0, $v1, $ra
    specialregs = [[NSArray alloc] initWithObjects:
                   [TmpTemp temp], [TmpTemp temp], [TmpTemp temp], [TmpTemp temp], [TmpTemp temp], nil];
    // $a0~$a3
    argregs = [[NSArray alloc] initWithObjects:
               [TmpTemp temp], [TmpTemp temp], [TmpTemp temp], [TmpTemp temp], nil];
    // $s0~$s7
    calleesave = [[NSArray alloc] initWithObjects:
                  [TmpTemp temp], [TmpTemp temp], [TmpTemp temp], [TmpTemp temp],
                  [TmpTemp temp], [TmpTemp temp], [TmpTemp temp], [TmpTemp temp], nil];
    // $t0~$t9
    callersave = [[NSArray alloc] initWithObjects:
                  [TmpTemp temp], [TmpTemp temp], [TmpTemp temp], [TmpTemp temp],
                  [TmpTemp temp], [TmpTemp temp], [TmpTemp temp], [TmpTemp temp],
                  [TmpTemp temp], [TmpTemp temp], nil];
    returnsink = [[TmpTempList alloc] init];
    for (TmpTemp *tmp in specialregs)
      [returnsink addTemp:tmp];
    for (TmpTemp *tmp in calleesave)
      [returnsink addTemp:tmp];
  }
}
@end
