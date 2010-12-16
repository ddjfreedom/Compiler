//
//  TreeStmt.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeExprList.h"

@interface TreeStmt : NSObject
{
}
- (TreeExprList *)kids;
- (TreeStmt *)buildWithExprList:(TreeExprList *)kids;
@end
