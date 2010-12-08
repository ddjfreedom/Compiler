//
//  TreeSeq.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeSeq.h"


@implementation TreeSeq
@synthesize first, second;
- (id)initWithFirstStmt:(TreeStmt *)stmt1 secondStmt:(TreeStmt *)stmt2
{
  if (self = [super init]) {
    first = [stmt1 retain];
    second = [stmt2 retain];
  }
  return self;
}
- (void)dealloc
{
  [first release];
  [second release];
  [super dealloc];
}
+ (id)seqWithFirstStmt:(TreeStmt *)stmt1 secondStmt:(TreeStmt *)stmt2
{
	return [[[TreeSeq alloc] initWithFirstStmt:stmt1 secondStmt:stmt2] autorelease];
}
@end
