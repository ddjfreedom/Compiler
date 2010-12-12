//
//  TRExpr.m
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TRExpr.h"
#import "ErrorMessage.h"

@implementation TRExpr
- (BOOL)isVoidType
{
  return NO;
}
- (TreeExpr *)unEx
{
  NSAssert(NO, @"Should not call unEx");
  return nil;
}
- (TreeStmt *)unNx
{
  NSAssert(NO, @"Should not call unNx");
  return nil;
}
- (TreeStmt *)unCxWithTrueLabel:(TmpLabel *)tLabel falseLabel:(TmpLabel *)fLabel
{
  NSAssert(NO, @"Should not call unCx");
  return nil;
}
@end
