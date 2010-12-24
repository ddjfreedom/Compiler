//
//  TRDataFrag.h
//  Compiler
//
//  Created by Duan Dajun on 12/11/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRFragment.h"
#import "TmpLabel.h"

@interface TRDataFrag : TRFragment
{
	NSString *string;
  TmpLabel *label;
}
@property (readonly) NSString *string;
@property (readonly) TmpLabel *label;
+ (id)dataFragWithString:(NSString *)aString label:(TmpLabel *)aLabel;
@end
