//
//  RecordExpression.m
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "RecordExpression.h"


@implementation RecordExpression
@synthesize typeIdentifier, fields;
- (id)initWithTypeId:(Symbol *)aType
           fieldList:(SyntaxList *)aList 
       andLineNumber:(int)lineno
{
  if (self = [super init]) {
    typeIdentifier = [aType retain];
    fields = [aList retain];
    lineNumber = lineno;
  }
  return self;
}
- (void)dealloc
{
  [typeIdentifier release];
  [fields release];
  [super dealloc];
}
@end
