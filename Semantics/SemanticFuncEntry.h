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
#import "TRLevel.h"
#import "TmpLabel.h"

@interface SemanticFuncEntry : SemanticEntry
{
  TRLevel *level;
  TmpLabel *label;
	SemanticType *returnType;
  SemanticRecordType *formalParas;
}
@property (readonly) SemanticType *returnType;
@property (readonly) SemanticRecordType *formalParas;
@property (readonly) TmpLabel *label;
@property (readonly) TRLevel *level;
- (id)initWithFormalParameters:(SemanticRecordType *)aRecordType
                  	returnType:(SemanticType *)aReturnType 
                         level:(TRLevel *)aLevel 
                         label:(TmpLabel *)aLabel;
+ (id)funcEntryWithFormalParameters:(SemanticRecordType *)aRecordType 
                         returnType:(SemanticType *)aReturnType 
                              level:(TRLevel *)aLevel 
                              label:(TmpLabel *)aLabel;
@end
