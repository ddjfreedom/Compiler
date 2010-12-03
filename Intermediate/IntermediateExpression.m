//
//  IntermediateExpression.m
//  Compiler
//
//  Created by Duan Dajun on 12/3/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "IntermediateExpression.h"


@implementation IntermediateExpression
- (id)initWithTranslatedExpression:(id)anExpr andSemanticType:(SemanticType *)aType
{
  if (self = [super init]) {
    type = [aType retain];
  }
  return self;
}
- (void)dealloc
{
  [type release];
  [super dealloc];
}
@end
