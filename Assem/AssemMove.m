//
//  AssemMove.m
//  Compiler
//
//  Created by Duan Dajun on 12/19/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "AssemMove.h"


@implementation AssemMove
@synthesize dst, src;
- (id)initWithString:(NSString *)aString
     destinationTemp:(TmpTemp *)d
          sourceTemp:(TmpTemp *)s
{
  if (self = [super init]) {
    assem = [aString retain];
    dst = [d retain];
    src = [s retain];
  }
  return self;
}
- (TmpTempList *)use
{
  return [TmpTempList tempListWithTemp:src];
}
- (TmpTempList *)def
{
  return [TmpTempList tempListWithTemp:dst];
}
- (void)dealloc
{
  [assem release];
  [dst release];
  [src release];
  [super dealloc];
}
+ (id)assemMoveWithString:(NSString *)aString
          destinationTemp:(TmpTemp *)d
               sourceTemp:(TmpTemp *)s
{
  return [[[AssemMove alloc] initWithString:aString
                            destinationTemp:d
                                 sourceTemp:s] autorelease];
}
@end
