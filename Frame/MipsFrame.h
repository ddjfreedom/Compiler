//
//  MipsFrame.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "Frame.h"
#import "TmpTemp.h"

@interface MipsFrame : Frame
{
	int frameCount;
  TmpTemp *fp;
  TmpTemp *rv;
}
@property (readonly) int frameCount;
- (id)init;
- (id)initWithLabel:(TmpLabel *)aLabel boolList:(BoolList *)aBoolList;
@end
