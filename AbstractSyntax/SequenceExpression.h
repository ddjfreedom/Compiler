//
//  SequenceExpression.h
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  expr: ( expr-seq )

#import "Expression.h"
#import "SyntaxList.h"

@interface SequenceExpression : Expression
{
	SyntaxList *expressions;
}
@property (readonly) SyntaxList *expressions;
- (id)initWithExpressionSequence:(SyntaxList *)aList andLineNumber:(int)lineno;
@end
