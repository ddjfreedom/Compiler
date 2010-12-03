#include <stdio.h>
#include "helper.h"

#import <Foundation/Foundation.h>
#import "AbstractSyntax.h"
#import "parse.tab.m"

void print(id expr);
int parse(FILE *fin, id *exprptr);
int main(int argc, const char * argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  id expr = nil;
  FILE *fin = fopen(argv[1], "r");
  parse(fin, &expr);
  print(expr);
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