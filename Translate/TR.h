//
//  TR.h
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Semantics.h"
#import "OperationExpression.h"
#import "Symbol.h"
#import "TmpLabel.h"
#import "TRExpr.h"
#import "TRAccess.h"
#import "TRLevel.h"
#import "TRFragment.h"
#import "Frame.h"

@interface TR : NSObject 
{
	NSMutableArray *frags;
  Frame *frame;
  int wordSize;
}
@property (readwrite, assign) int wordSize;
@property (readonly) NSArray *frags;
- (id)initWithFrame:(Frame *)aFrame;
- (TmpLabel *)generateDoneLabel;
- (void)addMainExpr:(TRExpr *)anExpr level:(TRLevel *)level;
// lValue translation
- (TRExpr *)simpleVarWithAccess:(TRAccess *)anAcc level:(TRLevel *)aLevel;
- (TRExpr *)arrayVarWithBase:(TRExpr *)base subscript:(TRExpr *)sub level:(TRLevel *)aLevel;
- (TRExpr *)fieldVarWithVar:(TRExpr *)var 
                       type:(SemanticRecordType *)type 
                      field:(Symbol *)field 
                      level:(TRLevel *)aLevel;
// expression translation
- (TRExpr *)nilExpr;
- (TRExpr *)intConstWithInt:(int)value;
- (TRExpr *)stringLitWithString:(NSString *)string;
- (TRExpr *)breakExprWithDoneLabel:(TmpLabel *)label;
- (TRExpr *)seqExprWithExprs:(NSArray *)exprs;
- (TRExpr *)arrayExprWithSize:(TRExpr *)size initialValue:(TRExpr *)inititalValue level:(TRLevel *)level;
- (TRExpr *)recordExprWithType:(SemanticRecordType *)type initialValues:(NSDictionary *)values level:(TRLevel *)level;
- (TRExpr *)assignExprWithLValue:(TRExpr *)left rValue:(TRExpr *)right;
- (TRExpr *)binopExprWithLeftOperand:(SemanticExpr *)left 
                                  op:(AbstractSyntaxOperation)op 
                        rightOperand:(SemanticExpr *)right
                               level:(TRLevel *)level;
- (TRExpr *)ifExprWithTest:(TRExpr *)test thenClause:(TRExpr *)thenClause elseClause:(TRExpr *)elseClause;
- (TRExpr *)whileExprWithTest:(TRExpr *)test body:(TRExpr *)body doneLabel:(TmpLabel *)done;
- (TRExpr *)forExprWithIndex:(SemanticVarEntry *)index
                  lowerBound:(TRExpr *)lower
                  upperBound:(TRExpr *)upper
                        body:(TRExpr *)body
                   doneLabel:(TmpLabel *)done;
- (TRExpr *)callExprWithFunc:(SemanticFuncEntry *)func Arguments:(NSArray *)args level:(TRLevel *)level;
// declaration translation
- (TRExpr *)varDeclWithVar:(SemanticVarEntry *)var initialValue:(TRExpr *)initialValue;
- (void)funcDeclWithBody:(TRExpr *)body level:(TRLevel *)level;
@end
