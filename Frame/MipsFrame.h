//
//  MipsFrame.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Frame.h"
#import "TmpTemp.h"

@interface MipsFrame : Frame
{
	int frameCount;
  //TmpTemp *zero;
}
@property (readonly) int frameCount;
@property (readonly) NSArray *argregs, *specialregs, *calleesave, *callersave;
//@property (readonly) TmpTemp *zero;
- (id)init;
- (id)initWithLabel:(TmpLabel *)aLabel boolList:(BoolList *)aBoolList;
@end
