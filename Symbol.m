//
//  Symbol.m
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Symbol.h"

static NSMutableDictionary *dict;

@implementation Symbol
@synthesize string;
- (NSString *)description
{
  return string;
}
- (const char *)cString
{
  return [string cStringUsingEncoding:NSASCIIStringEncoding];
}
- (NSUInteger)hash
{
  return [string hash];
}
- (BOOL)isEqual:(id)object
{
  if ([object class] == [self class] && string == [object string]) {
    return YES;
  }
  return NO;
}
- (id)copyWithZone:(NSZone *)zone
{
  Symbol *symbol = [[Symbol allocWithZone:zone] init];
  symbol->string = [self.string retain];
  return symbol;
}
- (void)dealloc
{
  [string release];
  [super dealloc];
}
+ (id)symbolWithName:(NSString *)aName
{
  if (!dict) {
    dict = [[NSMutableDictionary dictionary] retain];
  }
  Symbol *sym = [dict objectForKey:aName];
  if (!sym) {
    sym = [[Symbol alloc] init];
    sym->string = [aName retain];
    [dict setObject:sym forKey:aName];
    [sym release];
  }
  return sym;
}
@end
