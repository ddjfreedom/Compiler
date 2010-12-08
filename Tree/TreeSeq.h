//
//  TreeSeq.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TreeStmt.h"

@interface TreeSeq : TreeStmt
{
	TreeStmt *first, *second;
}
@property (readonly) TreeStmt *first, *second;
- (id)initWithFirstStmt:(TreeStmt *)stmt1 secondStmt:(TreeStmt *)stmt2;
+ (id)seqWithFirstStmt:(TreeStmt *)stmt1 secondStmt:(TreeStmt *)stmt2;
@end
