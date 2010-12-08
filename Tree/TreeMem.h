//
//  TreeMem.h
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeExpr.h"

@interface TreeMem : TreeExpr
{
	TreeExpr *expr;
}
@property (readonly) TreeExpr *expr;
- (id)initWithExpr:(TreeExpr *)anExpr;
+ (id)memWithExpr:(TreeExpr *)anExpr;
@end
