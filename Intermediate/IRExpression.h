//
//  IRExpression.h
//  Compiler
//
//  Created by Duan Dajun on 12/3/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticType.h"

@interface IRExpression : NSObject 
{
	SemanticType *type;
}
@property (readonly) SemanticType *type;
- (id)initWithTranslatedExpr:(id)anExpr andType:(SemanticType *)aType;
+ (id)exprWithTranslatedExpr:(id)anExpr andType:(SemanticType *)aType;
@end
