//
//  TRAccess.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "Access.h"

@class TRLevel;
@interface TRAccess : NSObject 
{
	TRLevel *level;
  Access *acc;
}
@property (readonly) TRLevel *level;
@property (readonly) Access *acc;
- (id)initWithLevel:(TRLevel *)aLevel access:(Access *)anAccess;
+ (id)accessWithLevel:(TRLevel *)aLevel access:(Access *)anAccess;
@end
