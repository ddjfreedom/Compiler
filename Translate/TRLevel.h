//
//  TRLevel.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Frame.h"
#import "TRAccess.h"
#import "BoolList.h"
#import "TmpLabel.h"
#import "Symbol.h"

@interface TRLevel : NSObject 
{
	Frame *frame;
  NSMutableArray *formals;
}
@property (readonly) NSArray *formals;
- (id)initWithLevel:(TRLevel *)aLevel name:(Symbol *)aName boolList:(BoolList *)aBoolList;
- (id)initWithLevel:(TRLevel *)aLevel label:(TmpLabel *)aLabel boolList:(BoolList *)aBoolList;
- (id)initWithFrame:(Frame *)aFrame;
- (TRAccess *)generateLocal:(BOOL)isEscaped;
+ (id)levelWithLevel:(TRLevel *)aLevel name:(Symbol *)aName boolList:(BoolList *)aBoolList;
+ (id)levelWithLevel:(TRLevel *)aLevel label:(TmpLabel *)aLabel boolList:(BoolList *)aBoolList;
@end
