//
//  ErrorMessage.h
//  Compiler
//
//  Created by Duan Dajun on 12/3/10.
//  Copyright 2010 SJTU. All rights reserved.
//
#include <stdio.h>
#import <Foundation/Foundation.h>

@interface ErrorMessage : NSObject
{

}
+ (void)printErrorMessageToFile:(FILE *)file 
                     lineNumber:(int)lineno
                     withFormat:(const char *)format, ...;
+ (void)printErrorMessageToFile:(FILE *)file 
         lineNumber:(int)lineno 
         withFormat:(const char *)format 
          arguments:(va_list)ap;
@end
