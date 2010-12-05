//
//  SemanticType.h
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//



@interface SemanticType : NSObject
{
}
@property (readonly) SemanticType *actualType;
- (BOOL)isSameType:(SemanticType *)aType;
+ (SemanticType *)type;
@end
