//
//  TmpLabel.h
//  Compiler
//
//  Created by Duan Dajun on 12/6/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Symbol.h"

@interface TmpLabel : NSObject 
{
	NSString *name;
}
@property (readonly) NSString *name;
@property (readonly) const char *cString;
- (id)init;
- (id)initWithString:(NSString *)aString;
- (id)initWithSymbol:(Symbol *)aSymbol;
+ (id)label;
+ (id)labelWithString:(NSString *)aString;
+ (id)labelWithSymbol:(Symbol *)aSymbol;
@end
