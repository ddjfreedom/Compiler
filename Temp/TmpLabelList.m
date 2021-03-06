//
//  TmpLabelList.m
//  Compiler
//
//  Created by Duan Dajun on 12/6/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TmpLabelList.h"


@implementation TmpLabelList
- (TmpLabel *)head
{
  if (list.count > 0)
    return [list objectAtIndex:0];
  return nil;
}
- (int)count
{
  return list.count;
}
- (id)init
{
  if (self = [super init])
    list = [[NSMutableArray alloc] init];
  return self;
}
- (id)initWithLabel:(TmpLabel *)aLabel
{
  if ([self init])
  	[list addObject:aLabel];
  return self;
}
- (void)addLabel:(TmpLabel *)aLabel
{
  if (aLabel)
  	[list addObject:aLabel];
}
- (void)insertLabel:(TmpLabel *)aLabel atIndex:(NSUInteger)index
{
  if (aLabel)
    [list insertObject:aLabel atIndex:(index > list.count ? list.count : index)];
}
- (TmpLabel *)lastLabel
{
  return [list lastObject];
}
- (TmpLabel *)labelAtIndex:(NSUInteger)index
{
  if (index < list.count)
    return [list objectAtIndex:index];
  return nil;
}
- (NSArray *)labels
{
  return list;
}
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len
{
  return [list countByEnumeratingWithState:state objects:stackbuf count:len];
}
- (void)dealloc
{
  [list release];
  [super dealloc];
}
+ (id)labelList
{
  return [[[TmpLabelList alloc] init] autorelease];
}
+ (id)labelListWithLabel:(TmpLabel *)aLabel
{
  return [[[TmpLabelList alloc] initWithLabel:aLabel] autorelease];
}
+ (id)labelListWithLabels:(TmpLabel *)firstLabel, ...
{
  va_list args;
  va_start(args, firstLabel);
  TmpLabel *arg;
  TmpLabelList *ans = [TmpLabelList labelList];
  for (arg = firstLabel; arg; arg = va_arg(args, TmpLabel *))
    [ans addLabel:arg];
  va_end(args);
  return ans;  
}
@end
