//
//  IRExpression.h
//  Compiler
//
//  Created by Duan Dajun on 12/3/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticType.h"
#import "TRExpr.h"

@interface SemanticExpr : NSObject 
{
  TRExpr *expr;
	SemanticType *type;
}
@property (readonly) SemanticType *type;
@property (readonly) TRExpr *expr;
- (id)initWithTRExpr:(TRExpr *)anExpr andType:(SemanticType *)aType;
+ (id)exprWithTRExpr:(TRExpr *)anExpr andType:(SemanticType *)aType;
@end
