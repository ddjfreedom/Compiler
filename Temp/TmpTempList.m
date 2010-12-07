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
@end
