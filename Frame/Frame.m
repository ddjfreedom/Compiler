//
//  Frame.m
//  Compiler
//
//  Created by Duan Dajun on 12/6/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "Frame.h"


@implementation Frame
@synthesize name;
@synthesize wordSize;
@synthesize fp;
- (NSArray *)formals
{
  return formals;
}
- (id)newFrameWith:(TmpLabel *)aLabel boolList:(BoolList *)aBoolList
{
  return nil;
}
- (Access *)generateLocal:(BOOL)isEscaped
{
  return nil;
}
@end
