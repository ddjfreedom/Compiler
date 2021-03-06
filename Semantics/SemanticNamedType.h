//
//  SemanticNamedType.h
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticType.h"
#import "Symbol.h"

@interface SemanticNamedType : SemanticType
{
	Symbol *name;
  SemanticType *type;
  BOOL inCycle;
}
@property (readonly) Symbol *name;
@property (retain) SemanticType *type;
@property (readonly) BOOL inCycle;
- (id)initWithTypeName:(Symbol *)aName;
- (BOOL)isCycle;
+ (id)namedTypeWithTypeName:(Symbol *)aName;
@end
