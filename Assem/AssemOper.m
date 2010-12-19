//
//  AssemOper.m
//  Compiler
//
//  Created by Duan Dajun on 12/19/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "AssemOper.h"


@implementation AssemOper
- (id)initWithString:(NSString *)aString
 destinationTempList:(TmpTempList *)d
      sourceTempList:(TmpTempList *)s
           labelList:(TmpLabelList *)j
{
  if (self = [super init]) {
    dst = [d retain];
    src = [s retain];
    targets = [j retain];
  }
  return self;
}
- (id)initWithString:(NSString *)aString
 destinationTempList:(TmpTempList *)d
      sourceTempList:(TmpTempList *)s
{
  return [self initWithString:aString
          destinationTempList:d
               sourceTempList:s
                    labelList:nil];
}
- (TmpTempList *)use
{
  return src;
}
- (TmpTempList *)def
{
  return dst;
}
- (TmpLabelList *)targets
{
  return targets;
}
- (void)dealloc
{
  [dst release];
  [src release];
  [targets release];
  [super dealloc];
}
+ (id)operWithString:(NSString *)aString
 destinationTempList:(TmpTempList *)d
      sourceTempList:(TmpTempList *)s
           labelList:(TmpLabelList *)j
{
  return [[[AssemOper alloc] initWithString:aString
                        destinationTempList:d
                             sourceTempList:s
                                  labelList:j] autorelease];
}
+ (id)operWithString:(NSString *)aString
 destinationTempList:(TmpTempList *)d
      sourceTempList:(TmpTempList *)s
{
  return [AssemOper operWithString:aString
               destinationTempList:d
                    sourceTempList:s
                         labelList:nil];
}
@end
