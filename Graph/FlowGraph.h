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
- (TmpTempList *)defOfNode:(Node *)aNode;
- (TmpTempList *)useOfNode:(Node *)aNode;
- (BOOL)iSMove:(Node *)aNode;
@end
