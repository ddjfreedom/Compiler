//
//  TRProcFrag.h
//  Compiler
//
//  Created by Duan Dajun on 12/11/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TRFragment.h"
#import "TreeStmt.h"
#import "Frame.h"

@interface TRProcFrag : TRFragment
{
	TreeStmt *stmt;
  Frame *frame;
}
@property (readonly) TreeStmt *stmt;
@property (readonly) Frame *frame;
- (id)initWithStmt:(TreeStmt *)aStmt frame:(Frame *)aFrame;
+ (id)procFragWithStme:(TreeStmt *)aStmt frame:(Frame *)aFrame;
@end
