#include <stdio.h>
#include "helper.h"

#import <Foundation/Foundation.h>
#import "AbstractSyntax.h"
#import "parse.tab.m"
#import "ErrorMessage.h"
#import "TypeChecker.h"
#import "TreeStmtList.h"
#import "TR.h"
#import "TRFragment.h"
#import "TRProcFrag.h"
#import "TRDataFrag.h"
#import "TRExpr.h"
#import "Canon.h"
#import "BasicBlocks.h"
#import "Trace.h"
#import "MipsFrame.h"
#import "Assem.h"
#import "AssemFlowGraph.h"
#import "RegAllocator.h"

void print(id expr);
int parse(FILE *fin, id *exprptr);
int main(int argc, const char * argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  id expr = nil;
  FILE *fin = fopen(argv[1], "r");
  MipsFrame *frame = [[MipsFrame alloc] init];
  TR *translator = [[TR alloc] initWithFrame:frame];
  printf("%s\n", argv[1]);
  [ErrorMessage setOutputFile:stdout];
  if (!parse(fin, &expr)) {
  	//print(expr);
  	NSArray *procs = [TypeChecker typeCheckProgram:expr withTranslator:translator inFrame:frame];
  	if (procs) {
			for (TRFragment *frag in procs)
				if ([frag isMemberOfClass:[TRDataFrag class]])
					printf("%s", [[frame transString:(TRDataFrag *)frag] cStringUsingEncoding:NSASCIIStringEncoding]);
    	for (TRFragment *frag in procs) {
      	//treeprint(frag);
        if ([frag isMemberOfClass:[TRProcFrag class]]) {
      		BasicBlocks *blocks = [BasicBlocks 
                                 basicBlocksWithStmtList:[Canon linearizeStmt:((TRProcFrag *)frag).stmt]];
//          for (list in blocks.blocks)
//            while (list) {
//              treeprint(list.head);
//              list = list.tail;
//            }
      		Trace *trace = [Trace traceWithBasicBlocks:blocks];
//          TreeStmtList *list;
//      		for (list = trace.stmts; list; list = list.tail)
//        		treeprint(list.head);
          NSArray *instrs = [((TRProcFrag *)frag).frame codegenUsingStmts:trace.stmts];
          //for (AssemInstr *instr in instrs)
            //NSLog(@"%@", [instr formatWithObject:((TRProcFrag *)frag).frame]);
						//printf("%s", [[instr formatWithObject:((TRProcFrag *)frag).frame] cStringUsingEncoding:NSASCIIStringEncoding]);
          //AssemFlowGraph *flowgraph = [AssemFlowGraph assemFlowGraphWithInstructions:instrs];
          //[flowgraph print];
					RegAllocator *regalloc = [RegAllocator regAllocatorWithFrame:frame instructions:instrs];
          //Liveness *liveness = [Liveness livenessWithFlowGraph:flowgraph];
          //[liveness printUsingTempMap:frame];
					[regalloc allocateRegisters];
					[regalloc print];
        }
      }
    }
  }
	[frame release];
  [translator release];
  fclose(fin);
  [pool drain];
  return 0;
}
int parse(FILE *fin, id *exprptr)
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  int rt;
  yyin = fin;
  rt = yyparse(exprptr);
  [pool drain];
  return rt;
}
void print(id expr)
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSMutableArray *indent = [NSMutableArray array];
  prettyprint(indent, expr);
  [pool drain];
}