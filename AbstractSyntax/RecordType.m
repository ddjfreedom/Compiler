//
//  RecordType.m
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "RecordType.h"


@implementation RecordType
@synthesize typefields;
- (id)initWithTypeFields:(SyntaxList *)fields andLineNumber:(int)lineno
{
  if (self = [super init]) {
    typefields = [fields retain];
    lineNumber = lineno;
  }
  return self;
}
- (void)dealloc
{
  [typefields release];
  [super dealloc];
}
@end
