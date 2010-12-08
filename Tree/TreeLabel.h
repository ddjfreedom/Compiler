//
//  TreeLabel.h
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeStmt.h"
#import "TmpLabel.h"

@interface TreeLabel : TreeStmt
{
	TmpLabel *label;
}
@property (readonly) TmpLabel *label;
- (id)initWithLabel:(TmpLabel *)aLabel;
+ (id)treeLabelWithLabel:(TmpLabel *)aLabel;
@end
