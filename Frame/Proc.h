//
//  Proc.h
//  Compiler
//
//  Created by Duan Dajun on 12/20/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Assem.h"

@interface Proc : NSObject
{
	NSArray *instrs;
}
- (id)initWithArray:(NSArray *)anArray;
+ (id)procWithArray:(NSArray *)anArray;
@end
