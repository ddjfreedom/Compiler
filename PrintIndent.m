//
//  PrintIndent.m
//  Compiler
//
//  Created by Duan Dajun on 12/12/10.
//  Copyright 2010 SJTU. All rights reserved.
//


void printIndent(NSMutableArray *indent)
{
  int i;
  int count = indent.count;
  int total = 0;
  int tmp = 0;
  for (i = 0; i < count; i++) {
    tmp = [[indent objectAtIndex:i] intValue];
    if (tmp > 0) {
    	printf("%*c", tmp + total, '|');
      total = 0;
    }
    else
      total += -tmp;
  }
  if (tmp < 0)
    printf("%*c", total, '|');
}
void replaceLast(NSMutableArray *indent, int newIndent)
{
  [indent removeLastObject];
  [indent addObject:[NSNumber numberWithInt:newIndent]];
}
