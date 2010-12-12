//
//  TmpTemp.h
//  Compiler
//
//  Created by Duan Dajun on 12/6/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TmpTemp : NSObject 
{
	NSString *name;
}
@property (readonly) NSString *name;
@property (readonly) const char *cString;
- (id)init;
+ (id)temp;
@end
