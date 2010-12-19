//
//  TmpTempList.h
//  Compiler
//
//  Created by Duan Dajun on 12/6/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TmpTemp.h"

@interface TmpTempList : NSObject
{
	NSMutableArray *list;
}
- (id)init;
- (id)initWithTemp:(TmpTemp *)aTemp;
- (void)addTemp:(TmpTemp *)aTemp;
- (void)insertTemp:(TmpTemp *)aTemp atIndex:(NSUInteger)index;
- (TmpTemp *)lastTemp;
- (TmpTemp *)tempAtIndex:(NSUInteger)index;
+ (id)tempList;
+ (id)tempListWithTemp:(TmpTemp *)aTemp;
+ (id)tempListWithTemps:(TmpTemp *)firstTemp, ... NS_REQUIRES_NIL_TERMINATION;
@end
