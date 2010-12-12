/*
 *  stringtest.c
 *  Compiler
 *
 *  Created by Duan Dajun on 12/1/10.
 *  Copyright 2010 SJTU. All rights reserved.
 *
 */
#include <stdio.h>

int main(int argc, const char * argv[])
{
  FILE *fout = fopen("testcases/stringtest.tig", "w");
  putc('(', fout); putc('\n', fout);
  fprintf(fout, "/*这是注释*/\n");
  fprintf(fout, "\"Closed string\";\n");
  fprintf(fout, "\"\";\n");
  fprintf(fout, "\"\\\\r \\r \\\\f \\f \\\\n \\n\";\n");
  fprintf(fout, "\"String spanning \\ \t\r\f\n \\  \tmultiple lines\";\n");
  fprintf(fout, "\"string with \\\\ddd \\065=A\";\n");
  fprintf(fout, "\"string with \\\\ddd too large \\565\";\n");
  fprintf(fout, "\"string with \\\\dd \\65\";\n");
  fprintf(fout, "\"string with escaped quote \\\"\";\n");
  fprintf(fout, "\"string with ctrl seq: ^] \\^]\";\n");
  fprintf(fout, "\"string with ctrl seq: ^A \\^A\";\n");
  fprintf(fout, "\"中文测试\";");
  fprintf(fout, "\"string with new line \\n\\tand tab\";\n");
  fprintf(fout, "\"Unclosed string\n");
  putc(')', fout); putc('\n', fout);
  fclose(fout);
  return 0;
}

