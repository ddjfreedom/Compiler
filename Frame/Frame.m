//
//  Frame.m
//  Compiler
//
//  Created by Duan Dajun on 12/6/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "Frame.h"
#import "Codegen.h"

@implementation Frame
@synthesize name;
@synthesize wordSize;
- (TmpTemp *)fp
{
  return nil;
}
- (TmpTemp *)rv
{
  return nil;
}
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
- (TreeExpr *)externalCallWithName:(NSString *)aName arguments:(TreeExprList *)args
{
  return nil;
}
- (TreeStmt *)procEntryExit1WithStmt:(TreeStmt *)body
{
  return nil;
}
- (NSArray *)codegenUsingStmt:(TreeStmt *)aStmt
{
  return nil;
}
@end
