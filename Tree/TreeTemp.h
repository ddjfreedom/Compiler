//
//  TreeTemp.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeExpr.h"
#import "TmpTemp.h"

@interface TreeTemp : TreeExpr
{
	TmpTemp *temp;
}
@property (readonly) TmpTemp *temp;
- (id)initWithTemp:(TmpTemp *)aTemp;
+ (id)treeTempWithTemp:(TmpTemp *)aTemp;
@end
