//
//  StringExpression.m
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "StringExpression.h"

@implementation StringExpression
- (id)initWithString:(NSString *)str andLineNumber:(int)lineno
{
  if (self = [super init]) {
    string = [[Symbol symbolWithName:str] retain];
    lineNumber = lineno;
  }
  return self;
}
- (NSString *)string
{
  return string.string;
}
- (void)dealloc
{
  [string release];
  [super dealloc];
}
@end
