//
//  SemanticVarEntry.h
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticEntry.h"
#import "SemanticType.h"
#import "TRAccess.h"

@interface SemanticVarEntry : SemanticEntry
{
  TRAccess *access;
	SemanticType *type;
}
@property (readonly) SemanticType *type;
@property (readonly) TRAccess *access;
- (id)initWithType:(SemanticType *)aType access:(TRAccess *)anAccess;
+ (id)varEntryWithType:(SemanticType *)aType access:(TRAccess *)anAccess;
+ (id)varEntry; // Used as a placeholder
@end
