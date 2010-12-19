//
//  AssemLabel.h
//  Compiler
//
//  Created by Duan Dajun on 12/19/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssemInstr.h"
#import "TmpLabel.h"

@interface AssemLabel : AssemInstr
{
	TmpLabel *label;
}
@property (readonly) TmpLabel *label;
- (id)initWithString:(NSString *)aString tmpLabel:(TmpLabel *)aLabel;
+ (id)assemLabelWithString:(NSString *)aString tmpLabel:(TmpLabel *)aLabel;
@end
