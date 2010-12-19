//
//  AssemInstr.m
//  Compiler
//
//  Created by Duan Dajun on 12/19/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "AssemInstr.h"


@implementation AssemInstr
@synthesize assem;
- (TmpTempList *)use
{
  return nil;
}
- (TmpTempList *)def
{
  return nil;
}
- (TmpLabelList *)targets
{
  return nil;
}
- (NSString *)formatWithObject:(id <TmpTempMap>)anObject
{
  TmpTempList *src = self.use;
  TmpTempList *dst = self.def;
  TmpLabelList *j = self.targets;
  NSMutableString *s = [NSMutableString string];
  int len = assem.length;
  int i, n;
  for (i = 0; i < len; ++i) {
  	if ([assem characterAtIndex:i] == '`')
      switch ([assem characterAtIndex:++i]) {
      	case 's':
          n = [assem characterAtIndex:++i] - '0';
          [s appendString:[anObject tempMapWithTemp:[src tempAtIndex:n]]];
          break;
        case 'd':
          n = [assem characterAtIndex:++i] - '0';
          [s appendString:[anObject tempMapWithTemp:[dst tempAtIndex:n]]];
          break;
        case 'j':
          n = [assem characterAtIndex:++i] - '0';
          [s appendString:[j labelAtIndex:n].name];
          break;
        case '`': [s appendFormat:@"`"]; break;
        default: NSAssert(NO, @"Bad Assem Format");
      }
    else
      [s appendFormat:@"%c", [assem characterAtIndex:i]];
  }
  return s;
}
@end
