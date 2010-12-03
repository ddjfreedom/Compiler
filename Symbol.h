//
//  Symbol.h
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Symbol : NSObject
{
	NSString *string;
}
@property (readonly) NSString *string;
- (const char *)cString;
+ (id)symbolWithName:(NSString *)aName;
@end
