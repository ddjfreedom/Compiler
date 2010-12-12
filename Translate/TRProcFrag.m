//
//  TRProcFrag.m
//  Compiler
//
//  Created by Duan Dajun on 12/11/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TRProcFrag.h"


@implementation TRProcFrag
@synthesize stmt, frame;
- (id)initWithStmt:(TreeStmt *)aStmt frame:(Frame *)aFrame
{
  if (self = [super init]) {
    stmt = [aStmt retain];
    frame = [aFrame retain];
  }
  return self;
}
- (void)dealloc
{
  [stmt	 release];
  [frame release];
  [super dealloc];
}
+ (id)procFragWithStme:(TreeStmt *)aStmt frame:(Frame *)aFrame
{
  return [[[TRProcFrag alloc] initWithStmt:aStmt frame:aFrame] autorelease];
}
@end
