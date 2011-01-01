//
//  Edge.m
//  Compiler
//
//  Created by Duan Dajun on 1/1/11.
//  Copyright 2011 SJTU. All rights reserved.
//

#import "Edge.h"


@implementation Edge
@synthesize node1, node2;
- (id)initWithNode1:(Node *)n1 node2:(Node *)n2
{
	if (self = [super init]) {
		node1 = n1;
		node2 = n2;
	}
	return self;
}
- (NSUInteger)hash
{
	return [node1 hash] * [node2 hash];
}
- (BOOL)isEqual:(id)object
{
	if ([object isKindOfClass:[Edge class]]) {
		return [node1 isEqual:((Edge *)object).node1] && [node2 isEqual:((Edge *)object).node2] ||
					 [node2 isEqual:((Edge *)object).node1] && [node1 isEqual:((Edge *)object).node1];
	}
	return NO;
}
+ (id)edgeWithNode1:(Node *)n1 node2:(Node *)n2
{
	return [[[Edge alloc] initWithNode1:n1 node2:n2] autorelease];
}
@end
