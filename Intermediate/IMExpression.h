//
//  IMExpression.h
//  Compiler
//
//  Created by Duan Dajun on 12/3/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticType.h"

@interface IMExpression : NSObject 
{
	SemanticType *type;
}
@property (readonly) SemanticType *type;
- (id)initWithTranslatedExpression:(id)anExpr andSemanticType:(SemanticType *)aType;
+ (id)IMExpressionWithTranslatedExpression:(id)anExpr andSemanticType:(SemanticType *)aType;
@end
