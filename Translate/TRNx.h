//
//  TRNx.h
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TRExpr.h"

@interface TRNx : TRExpr
{
	TreeStmt *stmt;
}
- (id)initWithStmt:(TreeStmt *)aStmt;
- (TreeStmt *)unNx;
+ (id)nxWithStmt:(TreeStmt *)aStmt;
@end
