#include <stdio.h>
#include "helper.h"

#import <Foundation/Foundation.h>
#import "AbstractSyntax.h"
#import "parse.tab.m"
#import "ErrorMessage.h"
#import "TypeChecker.h"
#import "TR.h"
#import "TRFragment.h"
#import "TRExpr.h"

void print(id expr);
int parse(FILE *fin, id *exprptr);
int main(int argc, const char * argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  id expr = nil;
  FILE *fin = fopen(argv[1], "r");
  TR *translator = [[TR alloc] init];
  TRExpr *trexpr;
  printf("%s\n", argv[1]);
  [ErrorMessage setOutputFile:stdout];
  if (!parse(fin, &expr)) {
  	//print(expr);
  	trexpr = [TypeChecker typeCheckProgram:expr withTranslator:translator];
  	if (trexpr) {
      treeprint(trexpr);
    	for (TRFragment *frag in translator.frags)
      	treeprint(frag);
    }
  }
  putchar('\n');
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