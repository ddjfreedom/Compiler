//
//  BasicBlocks.h
//  Compiler
//
//  Created by Duan Dajun on 12/16/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tree.h"
#import "TmpLabel.h"

@interface BasicBlocks : NSObject
{
	NSMutableArray *blocks;
  TmpLabel *done;
  TreeStmtList *last;
}
@property (readonly) NSArray *blocks;
@property (readonly) TmpLabel *done;
- (id)initWithStmtList:(TreeStmtList *)list;
+ (id)basicBlocksWithStmtList:(TreeStmtList *)list;
@end
