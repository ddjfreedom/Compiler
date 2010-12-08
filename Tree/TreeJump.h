//
//  TreeJump.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeStmt.h"
#import "TreeExpr.h"
#import "TmpLabelList.h"
#import "TmpLabel.h"

@interface TreeJump : TreeStmt
{
	TreeExpr *expr;
  TmpLabelList *list;
}
@property (readonly) TreeExpr *expr;
@property (readonly) TmpLabelList *list;
- (id)initWithExpr:(TreeExpr *)anExpr lableList:(TmpLabelList *)aLabelList;
- (id)initWithLabel:(TmpLabel *)aLabel;
- (id)jumpWithExpr:(TreeExpr *)anExpr lableList:(TmpLabelList *)aLabelList;
- (id)jumpWithLabel:(TmpLabel *)aLabel;
@end
