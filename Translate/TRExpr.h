//
//  TRExpr.h
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  Abstract Class. Should be subclassed.

#import "TmpLabel.h"
#import "TreeExpr.h"
#import "TreeStmt.h"

@interface TRExpr : NSObject 
{

}
- (BOOL)isVoidType;
- (TreeExpr *)unEx;
- (TreeStmt *)unNx;
- (TreeStmt *)unCxWithTrueLabel:(TmpLabel *)tLabel falseLabel:(TmpLabel *)fLabel;
@end
