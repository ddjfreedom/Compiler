//
//  MipsInReg.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "MipsInReg.h"


@implementation MipsInReg
@synthesize temp;
- (id)initWithTemp:(TmpTemp *)aTemp
{
  if (self = [super init])
    self.temp = [aTemp retain];
  return self;
}
- (NSString *)description
{
  return [NSString stringWithFormat:@"InReg: %@", temp];
}
- (void)dealloc
{
  [temp release];
  [super dealloc];
}
+ (id)inRegWithTemp:(TmpTemp *)aTemp
{
  return [[[MipsInReg alloc] initWithTemp:aTemp] autorelease];
}
@end
