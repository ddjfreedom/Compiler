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
- (void)setSemanticType:(SemanticType *)type forField:(Symbol *)name;
- (SemanticType *)semanticTypeForField:(Symbol *)name;
@end
