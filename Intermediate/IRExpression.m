//
//  IRExpression.m
//  Compiler
//
//  Created by Duan Dajun on 12/3/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "IRExpression.h"


@implementation IRExpression
@synthesize type;
- (id)initWithTranslatedExpr:(id)anExpr andType:(SemanticType *)aType
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
+ (id)exprWithTranslatedExpr:(id)anExpr andType:(SemanticType *)aType
{
  return [[[IRExpression alloc] initWithTranslatedExpr:anExpr
                                               andType:aType] autorelease];
}
@end
