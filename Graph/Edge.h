//
//  Edge.h
//  Compiler
//
//  Created by Duan Dajun on 1/1/11.
//  Copyright 2011 SJTU. All rights reserved.
//

#import "Node.h"

@interface Edge : NSObject
{
	Node *node1, *node2;
}
@property (readonly) Node *node1, *node2;
+ (id)edgeWithNode1:(Node *)n1 node2:(Node *)n2;
@end
