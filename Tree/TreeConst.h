//
//  TreeConst.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeExpr.h"

@interface TreeConst : TreeExpr
{
	int value;
}
@property (readonly) int value;
- (id)initWithInt:(int)anInt;
+ (id)constWithInt:(int)anInt;
@end
