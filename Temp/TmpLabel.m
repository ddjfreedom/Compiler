//
//  TmpLabel.m
//  Compiler
//
//  Created by Duan Dajun on 12/6/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TmpLabel.h"

static int count = 0;

@implementation TmpLabel
@synthesize name;
- (id)init
{
  return [self initWithString:[NSString stringWithFormat:@"L%d", count++]];
}
- (id)initWithString:(NSString *)aString
{
  if (self = [super init])
    name = [aString retain];
  return self;
}
- (id)initWithSymbol:(Symbol *)aSymbol
{
  return [self initWithString:aSymbol.string];
}
- (NSString *)description
{
  return [NSString stringWithFormat:@"label: %@", name];
}
- (void)dealloc
{
  [name release];
  [super dealloc];
}
+ (id)label
{
  return [[[TmpLabel alloc] init] autorelease];
}
+ (id)labelWithString:(NSString *)aString
{
  return [[[TmpLabel alloc] initWithString:aString] autorelease];
}
+ (id)labelWithSymbol:(Symbol *)aSymbol
{
  return [[[TmpLabel alloc] initWithSymbol:aSymbol] autorelease];
}
@end
