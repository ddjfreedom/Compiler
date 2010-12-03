//
//  SemanticFuncEntry.h
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticEntry.h"
#import "SemanticType.h"
#import "SemanticRecordType.h"

@interface SemanticFuncEntry : SemanticEntry
{
	SemanticType *returnType;
  SemanticRecordType *formalParas;
}
@property (readonly) SemanticType *returnType;
@property (readonly) SemanticRecordType *formalParas;
- (id)initWithFormalParameters:(SemanticRecordType *)aRecordType 
                 andReturnType:(SemanticType *)aReturnType;
+ (id)funcEntryWithFormalParameters:(SemanticRecordType *)aRecordType 
                      andReturnType:(SemanticType *)aReturnType;
@end
