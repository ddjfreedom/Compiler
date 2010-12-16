//
//  TreeStmt.m
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeStmt.h"

@implementation TreeStmt
- (TreeExprList *)kids
{
  NSAssert(NO, @"Should not call this method directly");
  return nil;
}
- (TreeStmt *)buildWithExprList:(TreeExprList *)kids
{
  NSAssert(NO, @"Should not call this method directly");
  return nil;
}
@end
