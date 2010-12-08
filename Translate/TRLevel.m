//
//  TRLevel.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TRLevel.h"


@implementation TRLevel
@synthesize parent;
- (NSArray *)formals
{
  return formals;
}
- (id)initWithLevel:(TRLevel *)aLevel name:(Symbol *)aName boolList:(BoolList *)aBoolList
{
	Frame *tmpframe = [aLevel->frame newFrameWith:[TmpLabel labelWithSymbol:aName]
                                       boolList:[BoolList boolListWithBool:YES
                                                                  boolList:aBoolList]];
  [self initWithFrame:tmpframe];
  parent = [aLevel retain];
  [tmpframe release];
  return self;
}
- (id)initWithLevel:(TRLevel *)aLevel label:(TmpLabel *)aLabel boolList:(BoolList *)aBoolList
{
  Frame *tmpframe = [aLevel->frame newFrameWith:aLabel 
                                       boolList:[BoolList boolListWithBool:YES
                                                                  boolList:aBoolList]];
  [self initWithFrame:tmpframe];
  parent = [aLevel retain];
  [tmpframe release];
  return self;
}
- (id)initWithFrame:(Frame *)aFrame
{
  if (self = [super init]) {
    frame = [aFrame retain];
    parent = nil;
    if (frame.formals) {
    	formals = [[NSMutableArray alloc] init];
    	for (Access *obj in frame.formals)
    	  [formals addObject:[TRAccess accessWithLevel:self access:obj]];
    } else
      formals = nil;
  }
  return self;
}
- (TRAccess *)generateLocal:(BOOL)isEscaped
{
  return [TRAccess accessWithLevel:self
                            access:[frame generateLocal:isEscaped]];
}
- (void)dealloc
{
  [frame release];
  [formals release];
  [parent release];
  [super dealloc];
}
+ (id)levelWithLevel:(TRLevel *)aLevel name:(Symbol *)aName boolList:(BoolList *)aBoolList
{
  return [[[TRLevel alloc] initWithLevel:aLevel name:aName boolList:aBoolList] autorelease];
}
+ (id)levelWithLevel:(TRLevel *)aLevel label:(TmpLabel *)aLabel boolList:(BoolList *)aBoolList
{
  return [[[TRLevel alloc] initWithLevel:aLevel label:aLabel boolList:aBoolList] autorelease];
}
@end
