//
//  InterferenceGraph.h
//  Compiler
//
//  Created by Duan Dajun on 12/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "Graph.h"
#import "Node.h"
#import "TmpTemp.h"

@interface InterferenceGraph : Graph
{

}
- (TmpTemp *)tempWithNode:(Node *)aNode;
- (Node *)nodeWithTemp:(TmpTemp *)aTemp;
- (int)spillCostForNode:(Node *)aNode;
@end
