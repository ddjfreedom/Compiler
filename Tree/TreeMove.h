//
//  TreeMove.h
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeStmt.h"
#import "TreeExpr.h"

@interface TreeMove : TreeStmt
{
	TreeExpr *dst, *src;
}
@property (readonly) TreeExpr *dst, *src;
- (id)initWithDestination:(TreeExpr *)expr1 source:(TreeExpr *)expr2;
+ (id)moveWithDestination:(TreeExpr	*)expr1 source:(TreeExpr *)expr2;
@end
