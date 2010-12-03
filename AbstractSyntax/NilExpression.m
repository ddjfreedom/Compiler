//
//  NilExpression.m
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "NilExpression.h"

@implementation NilExpression
- (id)initWithLineNumber:(int)lineno
{
  if (self = [super init]) {
    lineNumber = lineno;
  }
  return self;
}
@end
