//
//  TmpTempList.m
//  Compiler
//
//  Created by Duan Dajun on 12/6/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TmpTempList.h"


@implementation TmpTempList
- (id)init
{
  if (self = [super init])
    list = [[NSMutableArray alloc] init];
  return self;
}
- (id)initWithTemp:(TmpTemp *)aTemp
{
  if ([self init])
  	[list addObject:aTemp];
  return self;
}
- (void)addTemp:(TmpTemp *)aTemp
{
  if (aTemp)
  	[list addObject:aTemp];
}
- (void)insertTemp:(TmpTemp *)aTemp atIndex:(NSUInteger)index
{
  if (aTemp)
    [list insertObject:aTemp atIndex:(index > list.count ? list.count : index)];
}
- (TmpTemp *)lastTemp
{
  return [list lastObject];
}
- (TmpTemp *)tempAtIndex:(NSUInteger)index
{
  if (index < list.count)
    return [list objectAtIndex:index];
  return nil;
}
- (void)dealloc
{
  [list release];
  [super dealloc];
}
+ (id)tempList
{
  return [[[TmpTempList alloc] init] autorelease];
}
+ (id)tempListWithTemp:(TmpTemp *)aTemp
{
  return [[[TmpTempList alloc] initWithTemp:aTemp] autorelease];
}
+ (id)tempListWithTemps:(TmpTemp *)firstTemp, ...
{
  va_list args;
  va_start(args, firstTemp);
  TmpTemp *arg;
  TmpTempList *ans = [TmpTempList tempList];
  for (arg = firstTemp; arg; arg = va_arg(args, TmpTemp *))
    [ans addTemp:arg];
  va_end(args);
  return ans;
}
@end
