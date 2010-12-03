//
//  ErrorMessage.m
//  Compiler
//
//  Created by Duan Dajun on 12/3/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#include <string.h>
#import "ErrorMessage.h"


@implementation ErrorMessage
+ (void)printErrorMessageToFile:(FILE *)file 
         lineNumber:(int)lineno
         withFormat:(const char *)format, ...
{
  va_list ap;
  va_start(ap, format);
  [ErrorMessage printErrorMessageToFile:file lineNumber:lineno withFormat:format arguments:ap];
  va_end(ap);
}
+ (void)printErrorMessageToFile:(FILE *)file 
         lineNumber:(int)lineno 
         withFormat:(const char *)format 
          arguments:(va_list)ap
{
  fprintf(file, "Line %d: ", lineno);
  vfprintf(file, format, ap);
  if (format[strlen(format)-2] != '\n')
    fprintf(file, "\n");
}
@end
