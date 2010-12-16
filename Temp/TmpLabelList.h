//
//  TmpLabelList.h
//  Compiler
//
//  Created by Duan Dajun on 12/6/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TmpLabel.h"

@interface TmpLabelList : NSObject <NSFastEnumeration>
{
	NSMutableArray *list;
}
@property (readonly) TmpLabel *head;
@property (readonly) int count;
- (id)init;
- (id)initWithLabel:(TmpLabel *)aLabel;
- (void)addLabel:(TmpLabel *)aLabel;
- (void)insertLabel:(TmpLabel *)aLabel atIndex:(NSUInteger)index;
- (TmpLabel *)lastLabel;
- (TmpLabel *)labelAtIndex:(NSUInteger)index;
+ (id)labelList;
+ (id)labelListWithLabel:(TmpLabel *)aLabel;
@end
