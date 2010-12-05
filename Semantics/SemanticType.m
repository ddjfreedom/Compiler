//
//  SemanticType.m
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticType.h"


@implementation SemanticType
- (SemanticType *)actualType
{
  return self;
}
- (BOOL)isSameType:(SemanticType *)aType
{
  return NO;
}
+ (SemanticType *)type
{
  return [[[SemanticType alloc] init] autorelease];
}
@end
