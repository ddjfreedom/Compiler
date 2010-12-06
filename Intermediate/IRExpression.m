//
//  IMExpression.m
//  Compiler
//
//  Created by Duan Dajun on 12/3/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "IRExpression.h"


@implementation IRExpression
@synthesize type;
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
+ (id)IMExpressionWithTranslatedExpression:(id)anExpr andSemanticType:(SemanticType *)aType
{
  return [[[IRExpression alloc] initWithTranslatedExpression:anExpr 
                                             andSemanticType:aType] autorelease];
}
@end
