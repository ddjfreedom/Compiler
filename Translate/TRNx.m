//
//  TRNx.m
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TRNx.h"


@implementation TRNx
- (id)initWithStmt:(TreeStmt *)aStmt
{
  if (self = [super init])
    stmt = [aStmt retain];
  return self;
}
- (TreeStmt *)unNx
{
  return stmt;
}
- (void)dealloc
{
  [stmt release];
  [super dealloc];
}
+ (id)nxWithStmt:(TreeStmt *)aStmt
{
  return [[[TRNx alloc] initWithStmt:aStmt] autorelease];
}
@end
