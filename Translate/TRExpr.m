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
- (TreeExpr *)unEx
{
  fprintf(stderr, "Should not call unEx");
  return nil;
}
- (TreeStmt *)unNx
{
  fprintf(stderr, "Should not call unNx");
  return nil;
}
- (TreeStmt *)unCxWithTrueLabel:(TmpLabel *)tLabel falseLabel:(TmpLabel *)fLabel
{
  fprintf(stderr, "Should not call unCx");
  return nil;
}
@end
