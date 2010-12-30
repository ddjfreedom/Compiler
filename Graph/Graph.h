//
//  Graph.h
//  Compiler
//
//  Created by Duan Dajun on 12/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"

@interface Graph : NSObject
{
	int nodeCount;
  NSMutableArray *nodes;
}
@property (readwrite, assign) int nodeCount;
@property (readonly) NSMutableArray *nodes;
- (id)addNode;
- (void)addEdgeFromNode:(Node *)src toNode:(Node *)dst;
- (void)removeEdgeFromNode:(Node *)src toNode:(Node *)dst;
- (void)print;
@end
