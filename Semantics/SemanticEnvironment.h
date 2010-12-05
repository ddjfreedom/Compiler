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
- (void)setSemanticType:(SemanticType *)aType forSymbol:(Symbol *)aSymbol;
- (void)setSemanticEntry:(SemanticEntry *)anEntry forSymbol:(Symbol *)aSymbol;
- (SemanticType *)semanticTypeForSymbol:(Symbol *)aSymbol;
- (SemanticEntry *)semanticEntryForSymbol:(Symbol *)aSymbol;
- (void)removeSemanticTypeForSymbol:(Symbol *)aSymbol;
- (void)removeSemanticEntryForSymbol:(Symbol *)aSymbol;
- (void)addSemanticElementsFromEnvironment:(SemanticEnvironment *)otherEnvironment;
+ (SemanticEnvironment *)environment;
@end
