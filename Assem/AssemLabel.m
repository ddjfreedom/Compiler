//
//  AssemLabel.m
//  Compiler
//
//  Created by Duan Dajun on 12/19/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "AssemLabel.h"


@implementation AssemLabel
@synthesize label;
- (id)initWithString:(NSString *)aString tmpLabel:(TmpLabel *)aLabel
{
  if (self = [super init]) {
    assem = [aString retain];
    label = [aLabel retain];
  }
  return self;
}
- (void)dealloc
{
  [assem release];
  [label release];
  [super dealloc];
}
+ (id)assemLabelWithString:(NSString *)aString tmpLabel:(TmpLabel *)aLabel
{
  return [[[AssemLabel alloc] initWithString:aString tmpLabel:aLabel] autorelease];
}
@end
