//
//  SemanticVarEntry.h
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticEntry.h"
#import "SemanticType.h"

@interface SemanticVarEntry : SemanticEntry
{
	SemanticType *type;
}
@property (readonly) SemanticType *type;
- (id)initWithSemanticType:(SemanticType *)aType;
+ (id)varEntryWithSemanticType:(SemanticType *)aType;
@end
