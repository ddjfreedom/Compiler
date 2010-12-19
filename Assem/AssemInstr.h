//
//  AssemInstr.h
//  Compiler
//
//  Created by Duan Dajun on 12/19/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  Abstract class. Should be subclassed.

#import <Foundation/Foundation.h>
#import "TmpTemp.h"
#import "TmpTempMap.h"
#import "TmpTempList.h"
#import "TmpLabelList.h"

@interface AssemInstr : NSObject
{
	NSString *assem;
}
@property (readonly) NSString *assem;
@property (readonly) TmpTempList *use;
@property (readonly) TmpTempList *def;
@property (readonly) TmpLabelList *targets;
- (NSString *)formatWithObject:(id <TmpTempMap>)anObject;
@end
