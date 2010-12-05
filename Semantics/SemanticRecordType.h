//
//  SemanticRecordType.h
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SemanticType.h"
#import "Symbol.h"

@interface SemanticRecordType : SemanticType
{
	NSMutableArray *fields;
  NSMutableArray *types;
}
@property (readonly) NSUInteger count;
- (void)addSemanticType:(SemanticType *)type forField:(Symbol *)name;
- (BOOL)hasField:(Symbol *)field;
- (SemanticType *)semanticTypeForField:(Symbol *)name;
- (SemanticType *)semanticTypeAtIndex:(NSUInteger)index;
- (Symbol *)fieldAtIndex:(NSUInteger)index;
@end
