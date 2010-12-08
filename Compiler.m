#include <stdio.h>
#include "helper.h"

#import <Foundation/Foundation.h>
#import "AbstractSyntax.h"
#import "parse.tab.m"
#import "ErrorMessage.h"
#import "TypeChecker.h"
#import "MipsFrame.h"

void print(id expr);
int parse(FILE *fin, id *exprptr);
int main(int argc, const char * argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  id expr = nil;
  FILE *fin = fopen(argv[1], "r");
  printf("%s\n", argv[1]);
  [ErrorMessage setOutputFile:stdout];
  parse(fin, &expr);
  //print(expr);
  Frame *frame = [[MipsFrame alloc] init];
  NSLog(@"%@", [frame generateLocal:YES]);
  [TypeChecker typeCheckProgram:expr];
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