//
//  Trace.h
//  Compiler
//
//  Created by Duan Dajun on 12/16/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tree.h"
#import "BasicBlocks.h"

@interface Trace : NSObject
{
	BasicBlocks *blocks;
  TreeStmtList *stmts;
  NSMutableDictionary *dict;
}
@property (readonly) TreeStmtList *stmts;
- (id)initWithBasicBlocks:(BasicBlocks *)basicblocks;
+ (id)traceWithBasicBlocks:(BasicBlocks *)basicblocks;
@end
