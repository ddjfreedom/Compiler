//
//  FlowGraph.h
//  Compiler
//
//  Created by Duan Dajun on 12/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "Graph.h"
#import "Node.h"
#import "TmpTempList.h"

@interface FlowGraph : Graph
{

}
- (NSSet *)defOfNode:(Node *)aNode;
- (NSSet *)useOfNode:(Node *)aNode;
- (BOOL)isMove:(Node *)aNode;
@end
