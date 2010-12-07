//
//  MipsInFrame.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "Access.h"

@interface MipsInFrame : Access
{
	int offset;
}
@property (assign) int offset;
- (id)initWithOffset:(int)anOffset;
+ (id)inFrameWithOffset:(int)anOffset;
@end
