//
//  TypeChecker.m
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TypeChecker.h"
#import "AbstractSyntax.h"
#import "Semantics.h"
#import "Symbol.h"
#import "ErrorMessage.h"
#import "TmpLabel.h"
#import "TRLevel.h"
#import "BoolList.h"
#import "MipsFrame.h"
#import "TRExpr.h"

@interface TypeChecker()
- (void)symbolInitialization;
- (SemanticEntry *)entryForSymbol:(Symbol *)aSymbol;
- (SemanticType *)typeForSymbol:(Symbol *)aSymbol;
// The following two methods operate on the current environment (last in envs)
- (void)setEntry:(SemanticEntry *)anEntry forSymbol:(Symbol *)aSymbol;
- (void)setType:(SemanticType *)aType forSymbol:(Symbol *)aSymbol;
- (BOOL)isIntType:(SemanticExpr *)expr lineNumber:(int)lineno;
- (BOOL)isStringType:(SemanticExpr *)expr lineNumber:(int)lineno;
- (BOOL)isVoidType:(SemanticExpr *)expr lineNumber:(int)lineno expressionName:(const char *)name;
- (SemanticExpr *)typeCheckExpression:(Expression *)expr;
- (SemanticExpr *)typeCheckOperationExpression:(OperationExpression *)expr;
- (SemanticExpr *)typeCheckAssignExpression:(AssignExpression *)expr;
- (SemanticExpr *)typeCheckIfExpression:(IfExpression *)expr;
- (SemanticExpr *)typeCheckCallExpression:(CallExpression *)expr;
- (SemanticExpr *)typeCheckRecordExpression:(RecordExpression *)expr;
- (SemanticExpr *)typeCheckLetExpression:(LetExpression *)expr;
- (SemanticExpr *)typeCheckForExpression:(ForExpression *)expr;
- (SemanticExpr *)typeCheckVar:(Var *)var;
- (TRExpr *)typeCheckVarDecl:(VarDecl *)varDecl;
- (void)typeCheckTypeDecl:(SyntaxList *)typesList;
- (void)typeCheckFuncDecl:(SyntaxList *)funcsList;
- (SemanticType *)typeCheckType:(Type *)type;
- (SemanticRecordType *)typeCheckTypeFields:(SyntaxList *)typefields;
@end

@implementation TypeChecker
+ (NSArray *)typeCheckProgram:(Expression *)expr withTranslator:(TR* )tr inFrame:(Frame *)frame
{
  TypeChecker *checker = [[[TypeChecker alloc] init] autorelease];
  return [checker typeCheckProgram:expr withTranslator:tr inFrame:frame];
}
- (id)init
{
  if (self = [super init]) {
    envs = [[NSMutableArray alloc] init];
    loopVars = [[NSMutableArray alloc] init];
    doneLabels = [[NSMutableArray alloc] init];
    levels = [[NSMutableArray alloc] init];
    trans = nil;
    hasError = NO;
  }
  return self;
}
- (NSArray *)typeCheckProgram:(Expression *)expr withTranslator:(TR* )tr inFrame:(Frame *)frame
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  trans = [tr retain];
  [levels addObject:[TRLevel levelWithFrame:frame]];
  [self symbolInitialization];
  [trans addMainExpr:[self typeCheckExpression:expr].expr level:[levels objectAtIndex:0]];
  [pool drain];
  return hasError ? nil : trans.frags;
}
- (SemanticEntry *)entryForSymbol:(Symbol *)aSymbol
{
  int total = envs.count - 1;
  SemanticEntry *entry = nil;
  while (total >= 0) {
  	entry = [[envs objectAtIndex:total--] entryForSymbol:aSymbol];
    if (entry)
      return entry;
  }
  return nil;
}
- (SemanticType *)typeForSymbol:(Symbol *)aSymbol
{
  int total = envs.count - 1;
  SemanticType *type = nil;
  while (total >= 0) {
  	type = [[envs objectAtIndex:total--] typeForSymbol:aSymbol];
    if (type)
      return type;
  }
  return nil;
}
- (void)setEntry:(SemanticEntry *)anEntry forSymbol:(Symbol *)aSymbol
{
  [[envs lastObject] setEntry:anEntry forSymbol:aSymbol];
}
- (void)setType:(SemanticType *)aType forSymbol:(Symbol *)aSymbol
{
  [[envs lastObject] setType:aType forSymbol:aSymbol];
}
- (BOOL)isIntType:(SemanticExpr *)expr lineNumber:(int)lineno
{
  if (expr.type.actualType == [SemanticIntType sharedIntType])
    return YES;
  [ErrorMessage printLineNumber:lineno
                     withFormat:"Error: Type mismatch. Expected int"];
  hasError = YES;
  return NO;
}
- (BOOL)isStringType:(SemanticExpr *)expr lineNumber:(int)lineno
{
  if (expr.type.actualType == [SemanticStringType sharedStringType])
    return YES;
  [ErrorMessage printLineNumber:lineno
                     withFormat:"Error: Type mismatch. Expected string"];
  hasError = YES;
  return NO;
}
- (BOOL)isVoidType:(SemanticExpr *)expr lineNumber:(int)lineno expressionName:(const char *)name
{
  if (expr.type.actualType == [SemanticVoidType sharedVoidType])
    return YES;
  [ErrorMessage printLineNumber:lineno
                     withFormat:"Error: %s return a value", name];
  hasError = YES;
  return NO;
}
- (SemanticExpr *)typeCheckExpression:(Expression *)expr
{
  if ([expr isMemberOfClass:[IntExpression class]])
    return [SemanticExpr exprWithTRExpr:[trans intConstWithInt:((IntExpression *)expr).value]
                                andType:[SemanticIntType sharedIntType]];
  else if ([expr isMemberOfClass:[StringExpression class]])
    return [SemanticExpr exprWithTRExpr:[trans stringLitWithString:((StringExpression *)expr).string]
                                andType:[SemanticStringType sharedStringType]];
  else if ([expr isMemberOfClass:[NilExpression class]])
    return [SemanticExpr exprWithTRExpr:[trans nilExpr]
                                andType:[SemanticNilType sharedNilType]];
  else if ([expr isMemberOfClass:[OperationExpression class]])
  	return [self typeCheckOperationExpression:(OperationExpression *)expr];  
  else if ([expr isMemberOfClass:[VarExpression class]])
    return [self typeCheckVar:[(VarExpression *)expr variable]];
  else if ([expr isMemberOfClass:[AssignExpression class]])
    return [self typeCheckAssignExpression:(AssignExpression *)expr];
  else if ([expr isMemberOfClass:[IfExpression class]])
  	return [self typeCheckIfExpression:(IfExpression *)expr];
  else if ([expr isMemberOfClass:[WhileExpression class]]) {
    SemanticExpr *test = [self typeCheckExpression:[(WhileExpression *)expr test]];
    SemanticExpr *body;
    TmpLabel *done = [trans generateDoneLabel];
    [self isIntType:test lineNumber:[(WhileExpression *)expr test].lineNumber];
    [doneLabels addObject:done];
    body = [self typeCheckExpression:[(WhileExpression *)expr body]];
  	[self isVoidType:body
          lineNumber:[(WhileExpression *)expr body].lineNumber 
      expressionName:"Body of while expression"];
    [doneLabels removeLastObject];
    return [SemanticExpr exprWithTRExpr:[trans whileExprWithTest:test.expr
                                                            body:body.expr
                                                       doneLabel:done]
                                andType:[SemanticVoidType sharedVoidType]];
  } else if ([expr isMemberOfClass:[BreakExpression class]]) {
    if (!doneLabels.count) {
      [ErrorMessage printLineNumber:expr.lineNumber
                         withFormat:"Error: break not in a loop"];
      hasError = YES;
      return [SemanticExpr exprWithTRExpr:nil andType:[SemanticVoidType sharedVoidType]];
    } else
      return [SemanticExpr exprWithTRExpr:[trans breakExprWithDoneLabel:[doneLabels lastObject]]
      	                          andType:[SemanticVoidType sharedVoidType]];
  } else if ([expr isMemberOfClass:[CallExpression class]])
  	return [self typeCheckCallExpression:(CallExpression *)expr];
  else if ([expr isMemberOfClass:[RecordExpression class]])
    return [self typeCheckRecordExpression:(RecordExpression *)expr];
  else if ([expr isMemberOfClass:[SequenceExpression class]]) {
  	int i, count = [(SequenceExpression *)expr expressions].count;
    NSMutableArray *seq = [NSMutableArray array];
    SemanticExpr *last = nil;
    for (i = 0; i < count; ++i) {
      last = [self typeCheckExpression:[[(SequenceExpression *)expr expressions] objectAtIndex:i]];
      if (last.expr) [seq addObject:last.expr];
    }
    if (last.expr) {
    	return [SemanticExpr exprWithTRExpr:[trans seqExprWithExprs:seq] andType:last.type.actualType];
    } else
      return [SemanticExpr exprWithTRExpr:[trans seqExprWithExprs:seq] andType:[SemanticVoidType sharedVoidType]];
  } else if ([expr isMemberOfClass:[ForExpression class]])
    return [self typeCheckForExpression:(ForExpression *)expr];
  else if ([expr isMemberOfClass:[LetExpression class]])
		return [self typeCheckLetExpression:(LetExpression *)expr];
  else if ([expr isMemberOfClass:[ArrayExpression class]]) {
    SemanticType *type = [self typeForSymbol:[(ArrayExpression *)expr typeIdentifier]];
    if ([type.actualType isMemberOfClass:[SemanticArrayType class]]) {
      // test whether size is an int
      SemanticExpr *size = [self typeCheckExpression:[(ArrayExpression *)expr size]];
      SemanticExpr *initialValue = [self typeCheckExpression:[(ArrayExpression *)expr initialValue]];
      [self isIntType:size lineNumber:expr.lineNumber];
      // test whether the type of initial value and the type of array element are the same
      if (![initialValue.type.actualType isSameType:[(SemanticArrayType *)type.actualType type].actualType]) {
        [ErrorMessage printLineNumber:expr.lineNumber
                           withFormat:"Error: Initial value type and array element type mismatch."];
        hasError = YES;
      }
      return [SemanticExpr exprWithTRExpr:[trans arrayExprWithSize:size.expr
                                                      initialValue:initialValue.expr
                                                             level:[levels lastObject]]
                                  andType:type.actualType];
    } else 
      [ErrorMessage printLineNumber:expr.lineNumber
                         withFormat:"Error: Undefined array type"];
  }
  hasError = YES;
  return [SemanticExpr exprWithTRExpr:nil
                              andType:[SemanticVoidType sharedVoidType]];
}
- (SemanticExpr *)typeCheckOperationExpression:(OperationExpression *)expr
{
  SemanticExpr *left = [self typeCheckExpression:[expr leftOperand]];
  SemanticExpr *right = [self typeCheckExpression:[expr rightOperand]];
  BOOL error = NO;
  switch ([expr operation]) {
    case plus: case minus: case multiply: case divide:
      error = ![self isIntType:left lineNumber:expr.leftOperand.lineNumber];
      error |= ![self isIntType:right lineNumber:expr.rightOperand.lineNumber];
      break;
    case lt: case le: case gt: case ge:
      if (([left.type.actualType isSameType:[SemanticIntType sharedIntType]] &&
           ![right.type.actualType isSameType:[SemanticIntType sharedIntType]]) ||
          ([left.type.actualType isSameType:[SemanticStringType sharedStringType]] &&
           ![right.type.actualType isSameType:[SemanticStringType sharedStringType]])) {
            [ErrorMessage printLineNumber:expr.lineNumber
                               withFormat:"Error: Comparison of incompatible types"];
            error = YES;
          }
      break;
    case eq: case ne:
      if (![left.type.actualType isSameType:right.type.actualType]) {
        [ErrorMessage printLineNumber:expr.lineNumber
                           withFormat:"Error: Type mismatch. Two operands type differ"];
        error = YES;
      }
      break;
    default:
      [ErrorMessage printLineNumber:expr.lineNumber
                         withFormat:"Error: Unknown operator"];
      error = YES;
  }
  hasError |= error;
  if (error)
    return [SemanticExpr exprWithTRExpr:nil andType:[SemanticIntType sharedIntType]];
  return [SemanticExpr exprWithTRExpr:[trans binopExprWithLeftOperand:left
                                                                   op:[expr operation]
                                                         rightOperand:right
                                                                level:[levels lastObject]]
                              andType:[SemanticIntType sharedIntType]];
}
- (SemanticExpr *)typeCheckAssignExpression:(AssignExpression *)expr
{
  SemanticExpr *left = [self typeCheckVar:[expr variable]];
  SemanticExpr *right = [self typeCheckExpression:[expr expression]];
  BOOL error = NO;
  if ([expr.variable isMemberOfClass:[SimpleVar class]] &&
      [loopVars indexOfObject:((SimpleVar *)expr.variable).name] != NSNotFound) {
    [ErrorMessage printLineNumber:expr.variable.lineNumber
                       withFormat:"Warning: Loop variable %s being assigned to",
     [((SimpleVar *)expr.variable).name cString]];
    error = YES;
  }
  if ([right.type.actualType isSameType:[SemanticNilType sharedNilType]] && 
      ![left.type.actualType isMemberOfClass:[SemanticRecordType class]]) {
    [ErrorMessage printLineNumber:expr.lineNumber
                       withFormat:"Error: Attempt to assign nil to a non-record type."];
    error = YES;
  }
  else if (![left.type.actualType isSameType:right.type.actualType]) {
    [ErrorMessage printLineNumber:expr.lineNumber
                       withFormat:"Error: Lvalue and rvalue type mismatch"];
    error = YES;
  }
  hasError |= error;
  if (error)
    return [SemanticExpr exprWithTRExpr:nil andType:[SemanticVoidType sharedVoidType]];
  return [SemanticExpr exprWithTRExpr:[trans assignExprWithLValue:left.expr rValue:right.expr]
                              andType:[SemanticVoidType sharedVoidType]];
}
- (SemanticExpr *)typeCheckIfExpression:(IfExpression *)expr
{
  SemanticExpr *test = [self typeCheckExpression:expr.test];
  BOOL error = ![self isIntType:test lineNumber:expr.test.lineNumber];
  SemanticExpr *thenClause = [self typeCheckExpression:[expr thenClause]];
  if ([expr elseClause]) {
    SemanticExpr *elseClause = [self typeCheckExpression:expr.elseClause];
    if (![thenClause.type.actualType isSameType:elseClause.type.actualType]) {
      [ErrorMessage printLineNumber:expr.lineNumber
                         withFormat:"Error: Type mismatch. Types of then-else differ"];
      error = YES;
    }
    else 
      return [SemanticExpr exprWithTRExpr:[trans ifExprWithTest:test.expr
                                                     thenClause:thenClause.expr
                                                     elseClause:elseClause.expr]
                                  andType:thenClause.type];
  } else
    error |= ![self isVoidType:thenClause
                    lineNumber:expr.thenClause.lineNumber
                expressionName:"If-then"];
  hasError |= error;
  if (error) return [SemanticExpr exprWithTRExpr:nil andType:[SemanticVoidType sharedVoidType]];
  return [SemanticExpr exprWithTRExpr:[trans ifExprWithTest:test.expr
                                                 thenClause:thenClause.expr
                                                 elseClause:nil]
                              andType:[SemanticVoidType sharedVoidType]];  
}
- (SemanticExpr *)typeCheckCallExpression:(CallExpression *)expr
{
  SemanticEntry *entry = [self entryForSymbol:expr.functionName];
  NSMutableArray *args = [NSMutableArray array];
  BOOL error = NO;
  if ([entry isMemberOfClass:[SemanticFuncEntry class]]) {
    int i, count = expr.actualParas.count;
    int formalcount = [(SemanticFuncEntry *)entry formalParas].count;
    if (count != formalcount) {
      [ErrorMessage printLineNumber:expr.lineNumber
                         withFormat:"Error: Number of parameters mismatch"];
      error = YES;
    }
    else {
      SemanticExpr *arg;
    	for (i = 0; i < count; ++i) {
    	  arg = [self typeCheckExpression:(Expression *)[expr.actualParas objectAtIndex:i]];
    	  if (![arg.type.actualType
              isSameType:[[(SemanticFuncEntry *)entry formalParas] semanticTypeAtIndex:i].actualType]) {
    	    [ErrorMessage printLineNumber:expr.lineNumber
                             withFormat:"Error: Formal parameters and actual parameters type mismatch"];
    	    error = YES;
          break;
    	  }
        if (arg.expr) [args addObject:arg.expr];
    	}
    }
    hasError |= error;
    if (!error) return [SemanticExpr exprWithTRExpr:[trans callExprWithFunc:(SemanticFuncEntry *)entry
                                                                  Arguments:args
                                                                      level:[levels lastObject]]
                                            andType:[(SemanticFuncEntry *)entry returnType].actualType];
  } else
    [ErrorMessage printLineNumber:expr.lineNumber
                       withFormat:"Error: Undefined function %s", [expr.functionName cString]];
  hasError = YES;
  return [SemanticExpr exprWithTRExpr:nil
                              andType:[SemanticVoidType sharedVoidType]];
}
- (SemanticExpr *)typeCheckRecordExpression:(RecordExpression *)expr
{
  SemanticType *type = [self typeForSymbol:expr.typeIdentifier];
  NSMutableDictionary *values = [NSMutableDictionary dictionary];
  BOOL error = NO;
  if ([type.actualType isMemberOfClass:[SemanticRecordType class]]) {
    int i, count = expr.fields.count;
    FieldExpression *tmp;
    SemanticExpr *tmpexpr;
    for (i = 0; i < count; ++i) {
      tmp = [expr.fields objectAtIndex:i];
      tmpexpr = [self typeCheckExpression:tmp.expr];
      if (tmp.identifier.string != [(SemanticRecordType *)(type.actualType) fieldAtIndex:i].string) {
        [ErrorMessage printLineNumber:expr.lineNumber
                           withFormat:"Error: Field name mismatch. Expected %s",
         [[(SemanticRecordType *)type.actualType fieldAtIndex:i] cString]];
        error = YES;
        break;
      } else if (![tmpexpr.type.actualType
                   isSameType:[(SemanticRecordType *)type.actualType semanticTypeAtIndex:i].actualType]) {
        [ErrorMessage printLineNumber:expr.lineNumber
                           withFormat:"Error: Field %s type mismatch", [tmp.identifier cString]];
        error = YES;
        break;
      }
      [values setObject:tmpexpr.expr forKey:tmp.identifier];
    }
    hasError |= error;
    if (error) 
      return [SemanticExpr exprWithTRExpr:nil andType:type.actualType];
    return [SemanticExpr exprWithTRExpr:[trans recordExprWithType:(SemanticRecordType *)type.actualType
                                                    initialValues:values
                                                            level:[levels lastObject]]
                                andType:type.actualType];
  } else
    [ErrorMessage printLineNumber:expr.lineNumber
                       withFormat:"Error: Undefined record type %s", [expr.typeIdentifier cString]];
  hasError = YES;
  return [SemanticExpr exprWithTRExpr:nil andType:[SemanticVoidType sharedVoidType]];
}
- (SemanticExpr *)typeCheckForExpression:(ForExpression *)expr
{
  SemanticExpr *lower, *upper;
  VarDecl *vardecl = expr.varDecl;
  SemanticExpr *result;
  lower = [self typeCheckExpression:vardecl.expr];
  upper = [self typeCheckExpression:expr.end];
  if ([self isIntType:lower lineNumber:vardecl.expr.lineNumber] &&
      [self isIntType:upper lineNumber:expr.end.lineNumber]) {
    TmpLabel *done = [trans generateDoneLabel];
    SemanticVarEntry *index = [SemanticVarEntry varEntryWithType:lower.type.actualType
                                                          access:[(TRLevel *)[levels lastObject] generateLocal:YES]];
    [envs addObject:[SemanticEnvironment environment]];
    [self setEntry:index forSymbol:vardecl.identifier];
    [loopVars addObject:expr.varDecl.identifier];
    [doneLabels addObject:done];
    result = [self typeCheckExpression:expr.body];
    [loopVars removeLastObject];
    [doneLabels removeLastObject];
    [envs removeLastObject];
    return [SemanticExpr exprWithTRExpr:[trans forExprWithIndex:index
                                                     lowerBound:lower.expr
                                                     upperBound:upper.expr
                                                           body:result.expr
                                                      doneLabel:done]
                                andType:result.type.actualType];
  } else 
    [ErrorMessage printLineNumber:expr.lineNumber
                       withFormat:"Error: lower bound type and upper bound type mismatch"];
  hasError = YES;
  return [SemanticExpr exprWithTRExpr:nil
                              andType:[SemanticVoidType sharedVoidType]];  
}
- (SemanticExpr *)typeCheckLetExpression:(LetExpression *)expr
{
  int i, count = expr.exprList.count;
  NSMutableArray *exprs = [NSMutableArray array];
  SemanticExpr *result = nil;
  TRExpr *tmp;
  [envs addObject:[SemanticEnvironment environment]];
  for (id obj in expr.declList)
    if ([obj isMemberOfClass:[VarDecl class]]) {
      tmp = [self typeCheckVarDecl:obj];
      if (tmp) [exprs addObject:tmp];
    }
  	else {
      if ([[obj lastObject] isMemberOfClass:[TypeDecl class]])
        [self typeCheckTypeDecl:obj];
      else
        [self typeCheckFuncDecl:obj];
    }
  for (i = 0; i < count; ++i) {
    result = [self typeCheckExpression:[expr.exprList objectAtIndex:i]];
	  if (result.expr) [exprs addObject:result.expr];
  }
  [envs removeLastObject];
  if (exprs.count)
    return [SemanticExpr exprWithTRExpr:[trans seqExprWithExprs:exprs]
    	                          andType:result.type.actualType];
  else
    return [SemanticExpr exprWithTRExpr:nil andType:[SemanticVoidType sharedVoidType]];
}
- (SemanticExpr *)typeCheckVar:(Var *)var
{
  SemanticEntry *entry = nil;
  Symbol *symbol = nil;
  if ([var isMemberOfClass:[SimpleVar class]]) {
    symbol = [(SimpleVar *)var name];
    entry = [self entryForSymbol:symbol];
    if ([entry isMemberOfClass:[SemanticVarEntry class]])
      return [SemanticExpr exprWithTRExpr:[trans simpleVarWithAccess:((SemanticVarEntry *)entry).access 
                                                               level:[levels lastObject]]
                                  andType:[(SemanticVarEntry *)entry type].actualType];
    else 
      [ErrorMessage printLineNumber:var.lineNumber
                         withFormat:"Error: Undefined variable: %s", [symbol cString]];
  } else if ([var isMemberOfClass:[FieldVar class]]) {
    symbol = [(FieldVar *)var field];
  	SemanticExpr *expr = [self typeCheckVar:[(FieldVar *)var variable]];
    if ([expr.type.actualType isMemberOfClass:[SemanticRecordType class]]) {
    	if ([(SemanticRecordType *)expr.type.actualType hasField:symbol]) {
      	return [SemanticExpr exprWithTRExpr:[trans fieldVarWithVar:expr.expr
                                                              type:(SemanticRecordType *)expr.type.actualType
                                                             field:symbol
                                                             level:[levels lastObject]]
                                    andType:[(SemanticRecordType *)expr.type.actualType semanticTypeForField:symbol].actualType];
      } else 
        [ErrorMessage printLineNumber:var.lineNumber
                           withFormat:"Error: Variable doesn't have field %s", [symbol cString]];
    }
    else 
      [ErrorMessage printLineNumber:var.lineNumber
                         withFormat:"Error: Variable is not a record"];
  } else if ([var isMemberOfClass:[SubscriptVar class]]) {
    SemanticExpr *expr = [self typeCheckVar:[(SubscriptVar *)var variable]];
    if ([expr.type.actualType isMemberOfClass:[SemanticArrayType class]]) {
      SemanticExpr *subscript = [self typeCheckExpression:[(SubscriptVar *)var subscript]];
      if ([self isIntType:subscript lineNumber:var.lineNumber])
      	return [SemanticExpr exprWithTRExpr:[trans arrayVarWithBase:expr.expr
                                                          subscript:subscript.expr
                                                              level:[levels lastObject]]
                                    andType:[(SemanticArrayType *)expr.type.actualType type].actualType];
    }else 
      [ErrorMessage printLineNumber:var.lineNumber
                         withFormat:"Error: Variable is not an array."];
  } else
    [ErrorMessage printLineNumber:var.lineNumber
                       withFormat:"Error: Unknown variable"];
  hasError = YES;
  return [SemanticExpr exprWithTRExpr:nil andType:[SemanticVoidType sharedVoidType]];
}
- (TRExpr *)typeCheckVarDecl:(VarDecl *)varDecl
{
  SemanticExpr *expr = [self typeCheckExpression:varDecl.expr];
  SemanticType *decltype = [self typeCheckType:varDecl.typeIdentifier].actualType;
  SemanticVarEntry *var;
  if (expr.type.actualType == [SemanticVoidType sharedVoidType]) {
    [ErrorMessage printLineNumber:varDecl.lineNumber
                       withFormat:"Error: Attempt to declare a variable of no type"];
    hasError = YES;
    return nil;
  } else if (!decltype) {
    if (expr.type.actualType == [SemanticNilType sharedNilType]) {
      [ErrorMessage printLineNumber:varDecl.lineNumber
                         withFormat:"Error: Need type constraint"];
      [self setEntry:[SemanticVarEntry varEntry] forSymbol:varDecl.identifier];
      hasError = YES;
      return nil;
    } else {
      var = [SemanticVarEntry varEntryWithType:expr.type.actualType                               
                                        access:[(TRLevel *)[levels lastObject] generateLocal:YES]];
      [self setEntry:var forSymbol:varDecl.identifier];
    }
  } else {
    if (![expr.type.actualType isSameType:decltype.actualType]) {
      [ErrorMessage printLineNumber:varDecl.expr.lineNumber
                         withFormat:"Error: Type constraint and initial value differ. Expected %s",
       [varDecl.typeIdentifier.name cString]];
      hasError = YES;
    }
    var = [SemanticVarEntry varEntryWithType:decltype.actualType
                                      access:[(TRLevel *)[levels lastObject] generateLocal:YES]];
    [self setEntry:var forSymbol:varDecl.identifier];
  }
  return [trans varDeclWithVar:var initialValue:expr.expr];
}
- (void)typeCheckTypeDecl:(SyntaxList *)typesList
{
  SemanticEnvironment *tmpenv = [[SemanticEnvironment alloc] init];
  SemanticType *type;
  for (TypeDecl *typedecl in typesList)
    if ([tmpenv typeForSymbol:typedecl.typeIdentifier]) {
      [ErrorMessage printLineNumber:typedecl.lineNumber
                         withFormat:"Error: Type %s has been defined in the batch of mutually recursive types",
       [typedecl.typeIdentifier cString]];
      hasError = YES;
    }
  	else 
    	[tmpenv setType:[SemanticNamedType namedTypeWithTypeName:typedecl.typeIdentifier]
      	            forSymbol:typedecl.typeIdentifier];
  [envs addObject:tmpenv];
  for (TypeDecl *typedecl in typesList) {
  	type = [self typeCheckType:typedecl.type];
    [(SemanticNamedType *)[tmpenv typeForSymbol:typedecl.typeIdentifier] setType:type];
  }
  for (TypeDecl *typedecl in typesList) {
    type = [tmpenv typeForSymbol:typedecl.typeIdentifier];
    if (!((SemanticNamedType *)type).inCycle && [(SemanticNamedType *)type isCycle]) {
      [ErrorMessage printLineNumber:typedecl.lineNumber
                         withFormat:"Error: Type definition cycle detected",
       [typedecl.typeIdentifier cString]];
      hasError = YES;
    }
  }
  [envs removeLastObject];
  [[envs lastObject] addElementsFromEnvironment:tmpenv];
  [tmpenv release];
}
- (void)typeCheckFuncDecl:(SyntaxList *)funcsList
{
  SemanticEnvironment *tmpenv = [[SemanticEnvironment alloc] init];
  SemanticEnvironment *funcenv;
  SemanticType *type = nil;
  SemanticRecordType *pararecord;
  NSMutableArray *array = [[NSMutableArray alloc] init]; // Function return types
	int i, parameterCount;
  BoolList *boolList;
  BoolList *last;
  TRLevel *tmplevel;

  for (FunctionDecl *fundecl in funcsList) {
    pararecord = [self typeCheckTypeFields:fundecl.parameters];
    if (fundecl.returnType)
    	type = [self typeCheckType:fundecl.returnType].actualType;
    else
    	type = [SemanticVoidType sharedVoidType];
    [array addObject:type];
    if ([tmpenv entryForSymbol:fundecl.name]) {
      [ErrorMessage printLineNumber:fundecl.lineNumber
                         withFormat:"Error: Function %s has been defined in the batch of mutually recursive functions",
       [fundecl.name cString]];
      hasError = YES;
    }
    else {
      parameterCount = fundecl.parameters.count;
      boolList = [BoolList boolListWithBool:NO];
      last = boolList;
      // Create a new level
      for (i = 0; i < parameterCount; ++i) {
        // MARK: every parameter escaped
        last.tail = [BoolList boolListWithBool:YES];
        last = last.tail;
      }
      tmplevel = [TRLevel levelWithLevel:[levels lastObject]
                                   label:[TmpLabel label]
                                boolList:boolList.tail];
    	[tmpenv setEntry:[SemanticFuncEntry funcEntryWithFormalParameters:pararecord
                                                             returnType:type 
                                                                  level:tmplevel
                                                                  label:tmplevel.frame.name]
             forSymbol:fundecl.name];
    }
  }
  [envs addObject:tmpenv];
  
  int funcnum = 0;
  SemanticExpr *imexpr;
  SingleTypeField *para;
  for (FunctionDecl *fundecl in funcsList) {
    funcenv = [[SemanticEnvironment alloc] init];
    parameterCount = fundecl.parameters.count;
    tmplevel = ((SemanticFuncEntry *)[tmpenv entryForSymbol:fundecl.name]).level;
    [levels addObject:tmplevel];
    // Add parameters into environment
    for (i = 0; i < parameterCount; ++i) {
      para = [fundecl.parameters objectAtIndex:i];
    	type = [self typeForSymbol:para.typeIdentifier].actualType;
    	if (!type) type = [SemanticType type];
    	[funcenv setEntry:[SemanticVarEntry varEntryWithType:type
                                                    access:[tmplevel.formals objectAtIndex:i+1]]
              forSymbol:para.identifier];
    }
    [envs addObject:funcenv];
    // Type check function body
    imexpr = [self typeCheckExpression:fundecl.body];
    [trans funcDeclWithBody:imexpr.expr level:[levels lastObject]];
    if (fundecl.returnType) {
      if (![imexpr.type.actualType isSameType:[[array objectAtIndex:funcnum++] actualType]]) {
        [ErrorMessage printLineNumber:fundecl.lineNumber
                           withFormat:"Error: In function %s, actual return type is different from declared", 
         [fundecl.name cString]];
        hasError = YES;
      }
    } else if (![imexpr.type.actualType isSameType:[SemanticVoidType sharedVoidType]]) {
      [ErrorMessage printLineNumber:fundecl.lineNumber
                         withFormat:"Error: Procedure %s returns a value", [fundecl.name cString]];
      hasError = YES;
    }
    [envs removeLastObject];
    [levels removeLastObject];
    [funcenv release];
  }
  [envs removeLastObject];
  [[envs	lastObject] addElementsFromEnvironment:tmpenv];
  [array release];
  [tmpenv release];
}
- (SemanticType *)typeCheckType:(Type *)type
{
  Symbol *name;
  if ([type isMemberOfClass:[NameType class]]) {
    name = [(NameType *)type name];
  	SemanticType *result = [self typeForSymbol:name];
    if (!result) {
      [ErrorMessage printLineNumber:type.lineNumber
                         withFormat:"Error: Undefined type %s", [name cString]];
      hasError = YES;
    }
  	return result;
  } else if ([type isMemberOfClass:[ArrayType class]]) {
    name = [(ArrayType *)type typeName];
    SemanticType *result = [self typeForSymbol:name];
    if (result)
      return [SemanticArrayType arrayTypeWithSemanticType:result];
    [ErrorMessage printLineNumber:type.lineNumber
                       withFormat:"Error: Undefined type %s", [name cString]];
    hasError = YES;
  } else if ([type isMemberOfClass:[RecordType class]]) {
    SemanticRecordType *result = [self typeCheckTypeFields:[(RecordType *)type typefields]];
    return result;
  }
  return nil;
}
// If the type of a field is undefined, make it a SemanticType
- (SemanticRecordType *)typeCheckTypeFields:(SyntaxList *)typefields
{
  SemanticRecordType *result = [[SemanticRecordType alloc] init];
  SemanticType *tmptype;
  for (SingleTypeField *obj in typefields) {
    tmptype = [self typeForSymbol:obj.typeIdentifier];
    if (!tmptype) {
      [ErrorMessage printLineNumber:obj.lineNumber
                         withFormat:"Error: Undefined type %s", [obj.typeIdentifier cString]];
      tmptype = [SemanticType type];
    	hasError = YES;
    }
    [result addSemanticType:tmptype forField:obj.identifier];
  }
  return [result autorelease];
}
- (void)symbolInitialization
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  SemanticEnvironment *env = [[SemanticEnvironment alloc] init];
  TRLevel *tmplevel = [levels lastObject];
  trans.wordSize = tmplevel.frame.wordSize;
  [env setType:[SemanticIntType sharedIntType]
     forSymbol:[Symbol symbolWithName:@"int"]];
  [env setType:[SemanticStringType sharedStringType]
     forSymbol:[Symbol symbolWithName:@"string"]];
  
  SemanticRecordType *intRecord = [[SemanticRecordType alloc] init];
  // i : int
  [intRecord addSemanticType:[SemanticIntType sharedIntType] 
                    forField:[Symbol symbolWithName:@"i"]];
  SemanticRecordType *stringRecord = [[SemanticRecordType alloc] init];
  // s : string
  [stringRecord addSemanticType:[SemanticStringType sharedStringType]
                       forField:[Symbol symbolWithName:@"s"]];
  [env setEntry:[SemanticFuncEntry funcEntryWithFormalParameters:stringRecord
                                                      returnType:[SemanticVoidType sharedVoidType]
                                                           level:tmplevel 
                                                           label:[TmpLabel labelWithString:@"print"]]
      forSymbol:[Symbol symbolWithName:@"print"]];
  [env setEntry:[SemanticFuncEntry funcEntryWithFormalParameters:intRecord
                                                      returnType:[SemanticVoidType sharedVoidType]
                                                           level:tmplevel
                                                           label:[TmpLabel labelWithString:@"printi"]]
      forSymbol:[Symbol symbolWithName:@"printi"]];
  [env setEntry:[SemanticFuncEntry funcEntryWithFormalParameters:nil
                                                      returnType:[SemanticVoidType sharedVoidType]
                                                           level:tmplevel
                                                           label:[TmpLabel labelWithString:@"flush"]]
      forSymbol:[Symbol symbolWithName:@"flush"]];
  [env setEntry:[SemanticFuncEntry funcEntryWithFormalParameters:nil
                                                      returnType:[SemanticStringType sharedStringType]
                                                           level:tmplevel
                                                           label:[TmpLabel labelWithString:@"getchar"]]
      forSymbol:[Symbol symbolWithName:@"getchar"]];
  [env setEntry:[SemanticFuncEntry funcEntryWithFormalParameters:stringRecord
                                                      returnType:[SemanticIntType sharedIntType]
                                                           level:tmplevel
                                                           label:[TmpLabel labelWithString:@"ord"]]
      forSymbol:[Symbol symbolWithName:@"ord"]];
  [env setEntry:[SemanticFuncEntry funcEntryWithFormalParameters:intRecord
                                                      returnType:[SemanticStringType sharedStringType]
                                                           level:tmplevel
                                                           label:[TmpLabel labelWithString:@"chr"]]
      forSymbol:[Symbol symbolWithName:@"chr"]];
  [env setEntry:[SemanticFuncEntry funcEntryWithFormalParameters:intRecord
                                                      returnType:[SemanticIntType sharedIntType]
                                                           level:tmplevel
                                                           label:[TmpLabel labelWithString:@"not"]]
      forSymbol:[Symbol symbolWithName:@"not"]];
  [env setEntry:[SemanticFuncEntry funcEntryWithFormalParameters:intRecord
                                                      returnType:[SemanticVoidType sharedVoidType]
                                                           level:tmplevel
                                                           label:[TmpLabel labelWithString:@"exit"]]
      forSymbol:[Symbol symbolWithName:@"exit"]];
  [stringRecord release];
  stringRecord = [[SemanticRecordType alloc] init];
  // s : string, f : int, n : int
  [stringRecord addSemanticType:[SemanticStringType sharedStringType] forField:[Symbol symbolWithName:@"s"]];
  [stringRecord addSemanticType:[SemanticIntType sharedIntType] forField:[Symbol symbolWithName:@"f"]];
  [stringRecord addSemanticType:[SemanticIntType sharedIntType] forField:[Symbol symbolWithName:@"n"]];
  [env setEntry:[SemanticFuncEntry funcEntryWithFormalParameters:stringRecord
                                                      returnType:[SemanticStringType sharedStringType]
                                                           level:tmplevel
                                                           label:[TmpLabel labelWithString:@"substring"]]
      forSymbol:[Symbol symbolWithName:@"substring"]];
  [stringRecord release];
  stringRecord = [[SemanticRecordType alloc] init];
  // s1 : string, s2 : string
  [stringRecord addSemanticType:[SemanticStringType sharedStringType] forField:[Symbol symbolWithName:@"s1"]];
  [stringRecord addSemanticType:[SemanticStringType sharedStringType] forField:[Symbol symbolWithName:@"s2"]];
	[env setEntry:[SemanticFuncEntry funcEntryWithFormalParameters:stringRecord
                                                      returnType:[SemanticStringType sharedStringType]
                                                           level:tmplevel
                                                           label:[TmpLabel labelWithString:@"concat"]]
      forSymbol:[Symbol symbolWithName:@"concat"]];
  [intRecord release];
  [stringRecord release];
  [envs addObject:env];
  [env release];
  [pool drain];
}
- (void)dealloc
{
  [levels release];
  [envs release];
  [loopVars release];
  [doneLabels release];
  [trans release];
  [super dealloc];
}
@end
