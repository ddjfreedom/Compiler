//
//  SemanticArrayType.h
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticType.h"

@interface SemanticArrayType : SemanticType
{
	SemanticType *type;
}
@property (readonly) SemanticType *type;
- (id)initWithSemanticType:(SemanticType *)aType;
@end
