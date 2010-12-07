//
//  MipsFrame.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "Frame.h"

@interface MipsFrame : Frame <Frame>
{
	int frameCount;
}
@property (readonly) int frameCount;
- (id)initWithLabel:(TmpLabel *)aLabel boolList:(BoolList *)aBoolList;
@end
