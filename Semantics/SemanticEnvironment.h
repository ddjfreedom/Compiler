//
//  SemanticEnvironment.h
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Symbol.h"
#import "SemanticType.h"
#import "SemanticEntry.h"

@interface SemanticEnvironment : NSObject
{
	NSMutableDictionary *typeEnv;
  NSMutableDictionary *varEnv;
}
- (void)setType:(SemanticType *)aType forSymbol:(Symbol *)aSymbol;
- (void)setEntry:(SemanticEntry *)anEntry forSymbol:(Symbol *)aSymbol;
- (SemanticType *)typeForSymbol:(Symbol *)aSymbol;
- (SemanticEntry *)entryForSymbol:(Symbol *)aSymbol;
- (void)removeTypeForSymbol:(Symbol *)aSymbol;
- (void)removeEntryForSymbol:(Symbol *)aSymbol;
- (void)addElementsFromEnvironment:(SemanticEnvironment *)otherEnvironment;
+ (SemanticEnvironment *)environment;
@end
