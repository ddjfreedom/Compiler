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
#import "TRExpr.h"
#import "Canon.h"
#import "BasicBlocks.h"
#import "Trace.h"
#import "MipsFrame.h"

void print(id expr);
int parse(FILE *fin, id *exprptr);
int main(int argc, const char * argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  id expr = nil;
  FILE *fin = fopen(argv[1], "r");
  TR *translator = [[TR alloc] init];
  MipsFrame *frame = [[MipsFrame alloc] init];
  printf("%s\n", argv[1]);
  [ErrorMessage setOutputFile:stdout];
  if (!parse(fin, &expr)) {
  	//print(expr);
  	NSArray *procs = [TypeChecker typeCheckProgram:expr withTranslator:translator inFrame:frame];
  	if (procs) {
    	for (TRFragment *frag in procs) {
      	//treeprint(frag);
        if ([frag isMemberOfClass:[TRProcFrag class]]) {
      		BasicBlocks *blocks = [BasicBlocks basicBlocksWithStmtList:[Canon linearizeStmt:((TRProcFrag *)frag).stmt]];
        	TreeStmtList *list;
//          for (list in blocks.blocks)
//            while (list) {
//              treeprint(list.head);
//              list = list.tail;
//            }
      		Trace *trace = [Trace traceWithBasicBlocks:blocks];
      		for (list = trace.stmts; list; list = list.tail)
        		treeprint(list.head);
        }
      }
    }
  }
  putchar('\n');
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