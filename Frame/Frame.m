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
- (NSMutableArray *)procEntryExit2WithInstructions:(NSMutableArray *)body
{
  return nil;
}
- (Proc *)procEntryExit3WithInstructions:(NSMutableArray *)body
{
  return nil;
}
- (NSString *)tempMapWithTemp:(TmpTemp *)temp
{
  return nil;
}
- (NSArray *)codegenUsingStmts:(TreeStmtList *)aStmtList
{
  return nil;
}
@end
