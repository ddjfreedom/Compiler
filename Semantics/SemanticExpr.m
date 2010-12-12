//
//  IRExpression.m
//  Compiler
//
//  Created by Duan Dajun on 12/3/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticExpr.h"


@implementation SemanticExpr
@synthesize type;
@synthesize expr;
- (id)initWithTRExpr:(TRExpr *)anExpr andType:(SemanticType *)aType
{
  if (self = [super init]) {
    type = [aType retain];
    expr = [anExpr retain];
  }
  return self;
}
- (void)dealloc
{
  [type release];
  [expr release];
  [super dealloc];
}
+ (id)exprWithTRExpr:(TRExpr *)anExpr andType:(SemanticType *)aType
{
  return [[[SemanticExpr alloc] initWithTRExpr:anExpr andType:aType] autorelease];
}
@end
