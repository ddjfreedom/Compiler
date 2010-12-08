//
//  TreeName.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeExpr.h"
#import "TmpLabel.h"

@interface TreeName : TreeExpr
{
	TmpLabel *label;
}
@property (readonly) TmpLabel *label;
- (id)initWithLabel:(TmpLabel *)aLabel;
+ (id)nameWithLabel:(TmpLabel *)aLabel;
@end
