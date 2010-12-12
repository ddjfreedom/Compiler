//
//  TRDataFrag.m
//  Compiler
//
//  Created by Duan Dajun on 12/11/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TRDataFrag.h"


@implementation TRDataFrag
@synthesize string, label;
- (id)initWithString:(NSString *)aString label:(TmpLabel *)aLabel
{
  if (self = [super init]) {
    string = [aString retain];
    label = [aLabel retain];
  }
  return self;
}
- (void)dealloc
{
  [string release];
  [super dealloc];
}
+ (id)dataFragWithString:(NSString *)aString label:(TmpLabel *)aLabel
{
  return [[[TRDataFrag alloc] initWithString:aString label:aLabel] autorelease];
}
@end
