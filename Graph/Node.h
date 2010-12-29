//
//  Node.h
//  Compiler
//
//  Created by Duan Dajun on 12/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Graph;

@interface Node : NSObject <NSCopying>
{
	Graph *graph;
  int key;
  NSMutableArray *succs, *preds;
}
@property (readonly) Graph* graph;
@property (readonly) NSMutableArray *succs, *preds;
@property (readonly) NSArray *adj;
@property (readonly) int inDegree, outDegree, degree;
- (id)initWithGraph:(Graph *)aGraph;
- (BOOL)canGoToNode:(Node *)aNode;
- (BOOL)isComingFromNode:(Node *)aNode;
+ (id)nodeWithGraph:(Graph *)aGraph;
@end