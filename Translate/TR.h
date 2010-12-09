//
//  TR.h
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Semantics.h"
#import "Symbol.h"
#import "TRExpr.h"
#import "TRAccess.h"
#import "TRLevel.h"

@interface TR : NSObject 
{

}
+ (void)setWordSize:(int)size;
+ (TRExpr *)simpleVarWithAccess:(TRAccess *)anAcc level:(TRLevel *)aLevel;
+ (TRExpr *)arrayVarWithBase:(TRExpr *)base subscript:(TRExpr *)sub level:(TRLevel *)aLevel;
+ (TRExpr *)fieldVarWithVar:(TRExpr *)var 
                       type:(SemanticRecordType *)type 
                      field:(Symbol *)field 
                      level:(TRLevel *)aLevel;
+ (TRExpr *)nilExpr;
+ (TRExpr *)intConstWithInt:(int)value;
+ (TRExpr *)breakExprWithDoneLabel:(NSArray *)labels;
+ (TRExpr *)seqExprWithExprs:(NSArray *)exprs;
+ (TRExpr *)arrayExprWithSize:(TRExpr *)size initialValue:(TRExpr *)inititalValue level:(TRLevel *)level;
+ (TRExpr *)recordExprWithType:(SemanticRecordType *)type initialValues:(NSDictionary *)values level:(TRLevel *)level;
+ (TRExpr *)assignExprWithLValue:(TRExpr *)left rValue:(TRExpr *)right;
+ (TRExpr *)binopExprWithLeftOperand:(SemanticExpr *)left 
                                  op:(AbstractSyntaxOperation)op 
                        rightOperand:(SemanticExpr *)right;
+ (TRExpr *)ifExprWithTest:(TRExpr *)test thenClause:(TRExpr *)thenClause elseClause:(TRExpr *)elseClause;
+ (TRExpr *)whileExprWithTest:(TRExpr *)test body:(TRExpr *)body doneLabels:(NSMutableArray *)labels;
+ (TRExpr *)callExprWithFunc:(SemanticFuncEntry *)func Arguments:(NSArray *)args level:(TRLevel *)level;

+ (TRExpr *)varDeclWithVar:(SemanticVarEntry *)var initialValue:(TRExpr *)initialValue;
@end
