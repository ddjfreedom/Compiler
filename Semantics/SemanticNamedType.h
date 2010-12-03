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
}
@property (readonly) Symbol *name;
@property (retain) SemanticType *type;
- (id)initWithTypeName:(Symbol *)aName;
@end
