//
//  TRCx.h
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  Abstract class. Should be subclassed

#import "TRExpr.h"

@interface TRCx : TRExpr
{
}
- (TreeExpr *)unEx;
- (TreeStmt *)unNx;
@end
