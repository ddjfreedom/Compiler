//
//  Frame.h
//  Compiler
//
//  Created by Duan Dajun on 12/6/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TmpLabel.h"
#import "TmpTemp.h"
#import "Access.h"
#import "BoolList.h"

@class Frame;
@protocol Frame

- (Frame *)newFrameWith:(TmpLabel *)aLabel boolList:(BoolList *)aBoolList;
- (Access *)allocLocal:(BOOL)isEscaped;

@end

@interface Frame : NSObject 
{
	TmpLabel *name;
  NSMutableArray *formals;
}
@property (readonly) TmpLabel *name;
@property (readonly) NSArray *formals;
@end
