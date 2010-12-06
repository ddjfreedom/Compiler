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

@interface TypeChecker()
- (void)symbolInitialization;
- (SemanticEntry *)semanticEntryForSymbol:(Symbol *)aSymbol;
- (SemanticType *)semanticTypeForSymbol:(Symbol *)aSymbol;
// The following two methods operate on the current environment (last in envs)
- (void)setSemanticEntry:(SemanticEntry *)anEntry forSymbol:(Symbol *)aSymbol;
- (void)setSemanticType:(SemanticType *)aType forSymbol:(Symbol *)aSymbol;
- (BOOL)isIntType:(IRExpression *)expr lineNumber:(int)lineno;
- (BOOL)isStringType:(IRExpression *)expr lineNumber:(int)lineno;
- (BOOL)isVoidType:(IRExpression *)expr lineNumber:(int)lineno expressionName:(const char *)name;
- (IRExpression *)typeCheckExpression:(Expression *)expr;
- (IRExpression *)typeCheckOperationExpression:(OperationExpression *)expr;
- (IRExpression *)typeCheckAssignExpression:(AssignExpression *)expr;
- (IRExpression *)typeCheckIfExpression:(IfExpression *)expr;
- (IRExpression *)typeCheckCallExpression:(CallExpression *)expr;
- (IRExpression *)typeCheckRecordExpression:(RecordExpression *)expr;
- (IRExpression *)typeCheckLetExpression:(LetExpression *)expr;
- (IRExpression *)typeCheckForExpression:(ForExpression *)expr;
- (IRExpression *)typeCheckVar:(Var *)var;
- (id)typeCheckVarDecl:(VarDecl *)varDecl;
- (id)typeCheckTypeDecl:(SyntaxList *)typesList;
- (id)typeCheckFuncDecl:(SyntaxList *)funcsList;
- (SemanticType *)typeCheckType:(Type *)type;
- (SemanticRecordType *)typeCheckTypeFields:(SyntaxList *)typefields;
@end

@implementation TypeChecker
+ (IRExpression *)typeCheckProgram:(Expression *)expr
{
  TypeChecker *checker = [[[TypeChecker alloc] init] autorelease];
  return [checker typeCheckProgram:expr];
}
- (id)init
{
  if (self = [super init]) {
    envs = [[NSMutableArray alloc] init];
    loopVars = [[NSMutableArray alloc] init];
    nestedLoopLevel = 0;
  }
  return self;
}
- (IRExpression *)typeCheckProgram:(Expression *)expr
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  [self symbolInitialization];
  [self typeCheckExpression:expr];
  [pool drain];
  return nil;
}
- (SemanticEntry *)semanticEntryForSymbol:(Symbol *)aSymbol
{
  int total = envs.count - 1;
  SemanticEntry *entry = nil;
  while (total >= 0) {
  	entry = [[envs objectAtIndex:total--] semanticEntryForSymbol:aSymbol];
    if (entry)
      return entry;
  }
  return nil;
}
- (SemanticType *)semanticTypeForSymbol:(Symbol *)aSymbol
{
  int total = envs.count - 1;
  SemanticType *type = nil;
  while (total >= 0) {
  	type = [[envs objectAtIndex:total--] semanticTypeForSymbol:aSymbol];
    if (type)
      return type;
  }
  return nil;
}
- (void)setSemanticEntry:(SemanticEntry *)anEntry forSymbol:(Symbol *)aSymbol
{
  [[envs lastObject] setSemanticEntry:anEntry forSymbol:aSymbol];
}
- (void)setSemanticType:(SemanticType *)aType forSymbol:(Symbol *)aSymbol
{
  [[envs lastObject] setSemanticType:aType forSymbol:aSymbol];
}
- (BOOL)isIntType:(IRExpression *)expr lineNumber:(int)lineno
{
  if (expr.type.actualType == [SemanticIntType sharedIntType])
    return YES;
  [ErrorMessage printErrorMessageLineNumber:lineno
                                 withFormat:"Error: Type mismatch. Expected int"];
  return NO;
}
- (BOOL)isStringType:(IRExpression *)expr lineNumber:(int)lineno
{
  if (expr.type.actualType == [SemanticStringType sharedStringType])
    return YES;
  [ErrorMessage printErrorMessageLineNumber:lineno
                                 withFormat:"Error: Type mismatch. Expected string"];
  return NO;
}
- (BOOL)isVoidType:(IRExpression *)expr lineNumber:(int)lineno expressionName:(const char *)name
{
  if (expr.type.actualType == [SemanticVoidType sharedVoidType])
    return YES;
  [ErrorMessage printErrorMessageLineNumber:lineno
                                 withFormat:"Error: %s return a value", name];
  return NO;
}
- (IRExpression *)typeCheckExpression:(Expression *)expr
{
  if ([expr isMemberOfClass:[IntExpression class]])
    return [IRExpression IMExpressionWithTranslatedExpression:nil
                                              andSemanticType:[SemanticIntType sharedIntType]];
  else if ([expr isMemberOfClass:[StringExpression class]])
    return [IRExpression IMExpressionWithTranslatedExpression:nil
                                              andSemanticType:[SemanticStringType sharedStringType]];
  else if ([expr isMemberOfClass:[NilExpression class]])
    return [IRExpression IMExpressionWithTranslatedExpression:nil
                                              andSemanticType:[SemanticNilType sharedNilType]];
  else if ([expr isMemberOfClass:[OperationExpression class]])
  	return [self typeCheckOperationExpression:(OperationExpression *)expr];  
  else if ([expr isMemberOfClass:[VarExpression class]])
    return [self typeCheckVar:[(VarExpression *)expr variable]];
  else if ([expr isMemberOfClass:[AssignExpression class]])
    return [self typeCheckAssignExpression:(AssignExpression *)expr];
  else if ([expr isMemberOfClass:[IfExpression class]])
  	return [self typeCheckIfExpression:(IfExpression *)expr];
  else if ([expr isMemberOfClass:[WhileExpression class]]) {
    [self isIntType:[self typeCheckExpression:[(WhileExpression *)expr test]]
         lineNumber:[(WhileExpression *)expr test].lineNumber];
    nestedLoopLevel++;
  	[self isVoidType:[self typeCheckExpression:[(WhileExpression *)expr body]]
          lineNumber:[(WhileExpression *)expr body].lineNumber 
      expressionName:"Body of while expression"];
    nestedLoopLevel--;
    return [IRExpression IMExpressionWithTranslatedExpression:nil
                                              andSemanticType:[SemanticVoidType sharedVoidType]];
  } else if ([expr isMemberOfClass:[BreakExpression class]]) {
    if (!nestedLoopLevel)
      [ErrorMessage printErrorMessageLineNumber:expr.lineNumber
                                     withFormat:"Error: break not in a loop"];
  	return [IRExpression IMExpressionWithTranslatedExpression:nil
                                              andSemanticType:[SemanticVoidType sharedVoidType]];
  } else if ([expr isMemberOfClass:[CallExpression class]])
  	return [self typeCheckCallExpression:(CallExpression *)expr];
  else if ([expr isMemberOfClass:[RecordExpression class]])
    return [self typeCheckRecordExpression:(RecordExpression *)expr];
  else if ([expr isMemberOfClass:[SequenceExpression class]]) {
  	int i, count = [(SequenceExpression *)expr expressions].count - 1;
    for (i = 0; i < count; ++i)
      [self typeCheckExpression:[[(SequenceExpression *)expr expressions] objectAtIndex:i]];
    return [self typeCheckExpression:[[(SequenceExpression *)expr expressions] lastObject]];
  } else if ([expr isMemberOfClass:[ForExpression class]])
    return [self typeCheckForExpression:(ForExpression *)expr];
  else if ([expr isMemberOfClass:[LetExpression class]])
		return [self typeCheckLetExpression:(LetExpression *)expr];
  else if ([expr isMemberOfClass:[ArrayExpression class]]) {
    SemanticType *type = [self semanticTypeForSymbol:[(ArrayExpression *)expr typeIdentifier]];
    if ([type.actualType isMemberOfClass:[SemanticArrayType class]]) {
      // test whether size is an int
      [self isIntType:[self typeCheckExpression:[(ArrayExpression *)expr size]] 
           lineNumber:expr.lineNumber];
      // test whether the type of initial value and the type of array element are the same
      if (![[self typeCheckExpression:[(ArrayExpression *)expr initialValue]].type.actualType isSameType:
          [(SemanticArrayType *)type.actualType type].actualType])
        [ErrorMessage printErrorMessageLineNumber:expr.lineNumber
                                       withFormat:"Error: Initial value type and array element type mismatch."];
      return [IRExpression IMExpressionWithTranslatedExpression:nil
                                                andSemanticType:type];
    } else 
      [ErrorMessage printErrorMessageLineNumber:expr.lineNumber
                                     withFormat:"Error: Undefined array type"];
  }
  return [IRExpression IMExpressionWithTranslatedExpression:nil
                                            andSemanticType:[SemanticVoidType sharedVoidType]];
}
- (IRExpression *)typeCheckOperationExpression:(OperationExpression *)expr
{
  IRExpression *left = [self typeCheckExpression:[expr leftOperand]];
  IRExpression *right = [self typeCheckExpression:[expr rightOperand]];
  switch ([expr operation]) {
    case plus: case minus: case multiply: case divide:
      [self isIntType:left lineNumber:expr.leftOperand.lineNumber];
      [self isIntType:right lineNumber:expr.rightOperand.lineNumber];
      break;
    case lt: case le: case gt: case ge:
      if (([left.type.actualType isSameType:[SemanticIntType sharedIntType]] &&
           ![right.type.actualType isSameType:[SemanticIntType sharedIntType]]) ||
          ([left.type.actualType isSameType:[SemanticStringType sharedStringType]] &&
           ![right.type.actualType isSameType:[SemanticStringType sharedStringType]]))
        [ErrorMessage printErrorMessageLineNumber:expr.lineNumber
                                       withFormat:"Error: Comparison of incompatible types"];
      break;
    case eq: case ne:
      if (![left.type.actualType isSameType:right.type.actualType])
        [ErrorMessage printErrorMessageLineNumber:expr.lineNumber
                                       withFormat:"Error: Type mismatch. Two operands type differ"];
      break;
    default:
      [ErrorMessage printErrorMessageLineNumber:expr.lineNumber
                                     withFormat:"Error: Unknown operator"];
  }
  return [IRExpression IMExpressionWithTranslatedExpression:nil
                                            andSemanticType:[SemanticIntType sharedIntType]];
}
- (IRExpression *)typeCheckAssignExpression:(AssignExpression *)expr
{
  IRExpression *left = [self typeCheckVar:[expr variable]];
  IRExpression *right = [self typeCheckExpression:[expr expression]];
  if ([expr.variable isMemberOfClass:[SimpleVar class]] &&
      [loopVars indexOfObject:((SimpleVar *)expr.variable).name] != NSNotFound)
    [ErrorMessage printErrorMessageLineNumber:expr.variable.lineNumber
                                   withFormat:"Warning: Loop variable %s being assigned to",
     [((SimpleVar *)expr.variable).name cString]];
  if ([right.type.actualType isSameType:[SemanticNilType sharedNilType]] && 
      ![left.type.actualType isMemberOfClass:[SemanticRecordType class]])
    [ErrorMessage printErrorMessageLineNumber:expr.lineNumber
                                   withFormat:"Error: Attempt to assign nil to a non-record type."];
  else if (![left.type.actualType isSameType:right.type.actualType])
    [ErrorMessage printErrorMessageLineNumber:expr.lineNumber
                                   withFormat:"Error: Lvalue and rvalue type mismatch"];
  return [IRExpression IMExpressionWithTranslatedExpression:nil
                                            andSemanticType:[SemanticVoidType sharedVoidType]];
}
- (IRExpression *)typeCheckIfExpression:(IfExpression *)expr
{
  [self isIntType:[self typeCheckExpression:expr.test] 
       lineNumber:expr.test.lineNumber];
  IRExpression *thenClause = [self typeCheckExpression:[expr thenClause]];
  if ([expr elseClause]) {
    IRExpression *elseClause = [self typeCheckExpression:expr.elseClause];
    if (![thenClause.type.actualType isSameType:elseClause.type.actualType])
      [ErrorMessage printErrorMessageLineNumber:expr.lineNumber
                                     withFormat:"Error: Type mismatch. Types of then-else differ"];
    else 
      return [IRExpression IMExpressionWithTranslatedExpression:nil
                                                andSemanticType:thenClause.type];
  } else
    [self isVoidType:thenClause 
          lineNumber:expr.thenClause.lineNumber 
      expressionName:"If-then"];
  return [IRExpression IMExpressionWithTranslatedExpression:nil
                                            andSemanticType:[SemanticVoidType sharedVoidType]];  
}
- (IRExpression *)typeCheckCallExpression:(CallExpression *)expr
{
  SemanticEntry *entry = [self semanticEntryForSymbol:expr.functionName];
  if ([entry isMemberOfClass:[SemanticFuncEntry class]]) {
    int i, count = expr.actualParas.count;
    int formalcount = [(SemanticFuncEntry *)entry formalParas].count;
    if (count != formalcount)
      [ErrorMessage printErrorMessageLineNumber:expr.lineNumber
                                     withFormat:"Error: Number of parameters mismatch"];
    else {
    	SemanticType *type;
    	for (i = 0; i < count; ++i) {
    	  type = [self typeCheckExpression:(Expression *)[expr.actualParas objectAtIndex:i]].type;
    	  if (![type.actualType isSameType:[[(SemanticFuncEntry *)entry formalParas] semanticTypeAtIndex:i].actualType]) {
    	    [ErrorMessage printErrorMessageLineNumber:expr.lineNumber
    	                                   withFormat:"Error: Formal parameters and actual parameters type mismatch"];
    	    break;
    	  }
    	}
    }
    return [IRExpression IMExpressionWithTranslatedExpression:nil
                                              andSemanticType:[(SemanticFuncEntry *)entry returnType].actualType];
  } else
    [ErrorMessage printErrorMessageLineNumber:expr.lineNumber
                                   withFormat:"Error: Undefined function %s", [expr.functionName cString]];
  return [IRExpression IMExpressionWithTranslatedExpression:nil
                                            andSemanticType:[SemanticVoidType sharedVoidType]];
}
- (IRExpression *)typeCheckRecordExpression:(RecordExpression *)expr
{
  SemanticType *type = [self semanticTypeForSymbol:expr.typeIdentifier];
  if ([type.actualType isMemberOfClass:[SemanticRecordType class]]) {
    int i, count = expr.fields.count;
    FieldExpression *tmp;
    SemanticType *tmptype;
    for (i = 0; i < count; ++i) {
      tmp = [expr.fields objectAtIndex:i];
      tmptype = [self typeCheckExpression:tmp.expr].type;
      if (tmp.identifier.string != [(SemanticRecordType *)(type.actualType) fieldAtIndex:i].string) {
        [ErrorMessage printErrorMessageLineNumber:expr.lineNumber 
                                       withFormat:"Error: Field name mismatch. Expected %s",
         [[(SemanticRecordType *)type.actualType fieldAtIndex:i] cString]];
        break;
      } else if (![tmptype.actualType isSameType:[(SemanticRecordType *)type.actualType semanticTypeAtIndex:i].actualType]) {
        [ErrorMessage printErrorMessageLineNumber:expr.lineNumber 
                                       withFormat:"Error: Field %s type mismatch",
         [tmp.identifier cString]];
        break;
      }
    }
    return [IRExpression IMExpressionWithTranslatedExpression:nil
                                              andSemanticType:type.actualType];
  } else
    [ErrorMessage printErrorMessageLineNumber:expr.lineNumber
                                   withFormat:"Error: Undefined record type %s", [expr.typeIdentifier cString]];
  return nil;
}
- (IRExpression *)typeCheckForExpression:(ForExpression *)expr
{
  SemanticType *lowertype, *uppertype;
  VarDecl *vardecl = expr.varDecl;
  IRExpression *result;
  lowertype = [self typeCheckExpression:vardecl.expr].type.actualType;
  uppertype = [self typeCheckExpression:expr.end].type.actualType;
  if ([lowertype isSameType:uppertype]) {
    [envs addObject:[SemanticEnvironment environment]];
    [self setSemanticEntry:[SemanticVarEntry varEntryWithSemanticType:lowertype]
                 forSymbol:vardecl.identifier];
    [loopVars addObject:expr.varDecl.identifier];
    nestedLoopLevel++;
    result = [self typeCheckExpression:expr.body];
    [loopVars removeLastObject];
    nestedLoopLevel--;
    [envs removeLastObject];
    return result;
  } else 
    [ErrorMessage printErrorMessageLineNumber:expr.lineNumber
                                   withFormat:"Error: lower bound type and upper bound type mismatch"];
  return [IRExpression IMExpressionWithTranslatedExpression:nil
                                            andSemanticType:[SemanticVoidType sharedVoidType]];  
}
- (IRExpression *)typeCheckLetExpression:(LetExpression *)expr
{
  int i, count = expr.exprList.count - 1;
  IRExpression *result;
  [envs addObject:[SemanticEnvironment environment]];
  for (id obj in expr.declList)
    if ([obj isMemberOfClass:[VarDecl class]])
      [self typeCheckVarDecl:obj];
  	else {
      if ([[obj lastObject] isMemberOfClass:[TypeDecl class]])
        [self typeCheckTypeDecl:obj];
      else
        [self typeCheckFuncDecl:obj];
    }
  for (i = 0; i < count; ++i)
	  [self typeCheckExpression:[expr.exprList objectAtIndex:i]];
  result = [self typeCheckExpression:[expr.exprList lastObject]];  
  [envs removeLastObject];
  return result;
}
- (IRExpression *)typeCheckVar:(Var *)var
{
  SemanticEntry *entry = nil;
  Symbol *symbol = nil;
  if ([var isMemberOfClass:[SimpleVar class]]) {
    symbol = [(SimpleVar *)var name];
    entry = [self semanticEntryForSymbol:symbol];
    if ([entry isMemberOfClass:[SemanticVarEntry class]])
      return [IRExpression IMExpressionWithTranslatedExpression:nil
                                                andSemanticType:[(SemanticVarEntry *)entry type].actualType];
    else 
      [ErrorMessage printErrorMessageLineNumber:var.lineNumber
                                     withFormat:"Error: Undefined variable: %s", [symbol cString]];
  } else if ([var isMemberOfClass:[FieldVar class]]) {
    symbol = [(FieldVar *)var field];
  	SemanticType *type = [[self typeCheckVar:[(FieldVar *)var variable]] type];
    if ([type.actualType isMemberOfClass:[SemanticRecordType class]]) {
    	if ([(SemanticRecordType *)type hasField:symbol]) {
      	symbol = [(FieldVar *)var field];
      	return [IRExpression IMExpressionWithTranslatedExpression:nil
        	                                        andSemanticType:[(SemanticRecordType *)type semanticTypeForField:symbol].actualType];
      } else 
        [ErrorMessage printErrorMessageLineNumber:var.lineNumber
                                       withFormat:"Error: Variable doesn't have field %s", [symbol cString]];
    }
    else 
      [ErrorMessage printErrorMessageLineNumber:var.lineNumber
                                     withFormat:"Error: Variable is not a record"];
  } else if ([var isMemberOfClass:[SubscriptVar class]]) {
    SemanticType *type = [[self typeCheckVar:[(SubscriptVar *)var variable]] type].actualType;
    if ([type isMemberOfClass:[SemanticArrayType class]]) {
      if ([self isIntType:[self typeCheckExpression:[(SubscriptVar *)var subscript]] lineNumber:var.lineNumber])
      	return [IRExpression IMExpressionWithTranslatedExpression:nil
                                                	andSemanticType:[(SemanticArrayType *)type type].actualType];
    }else 
      [ErrorMessage printErrorMessageLineNumber:var.lineNumber
                                     withFormat:"Error: Variable is not an array."];
  } else
    [ErrorMessage printErrorMessageLineNumber:var.lineNumber
                                   withFormat:"Error: Unknown variable"];
  return nil;
}
- (id)typeCheckVarDecl:(VarDecl *)varDecl
{
  SemanticType *type = [self typeCheckExpression:varDecl.expr].type.actualType;
  SemanticType *decltype = [self typeCheckType:varDecl.typeIdentifier].actualType;
  if (!decltype) {
    if (type == [SemanticNilType sharedNilType]) {
      [ErrorMessage printErrorMessageLineNumber:varDecl.lineNumber
                                     withFormat:"Error: Need type constraint"];
      [self setSemanticEntry:[SemanticVarEntry varEntry] forSymbol:varDecl.identifier];
    } else
      [self setSemanticEntry:[SemanticVarEntry varEntryWithSemanticType:type]
                   forSymbol:varDecl.identifier];
  } else {
    if (![type isSameType:decltype])
      [ErrorMessage printErrorMessageLineNumber:varDecl.expr.lineNumber
                                     withFormat:"Error: Type constraint and initial value differ. Expected %s",
       [varDecl.typeIdentifier.name cString]];
    [self setSemanticEntry:[SemanticVarEntry varEntryWithSemanticType:decltype]
                 forSymbol:varDecl.identifier];
  }
  return nil;
}
- (id)typeCheckTypeDecl:(SyntaxList *)typesList
{
  SemanticEnvironment *tmpenv = [[SemanticEnvironment alloc] init];
  SemanticType *type;
  for (TypeDecl *typedecl in typesList)
    if ([tmpenv semanticTypeForSymbol:typedecl.typeIdentifier])
      [ErrorMessage printErrorMessageLineNumber:typedecl.lineNumber
                                     withFormat:"Error: Type %s has been defined in the batch of mutually recursive types",
       [typedecl.typeIdentifier cString]];
  	else 
    	[tmpenv setSemanticType:[SemanticNamedType namedTypeWithTypeName:typedecl.typeIdentifier]
      	            forSymbol:typedecl.typeIdentifier];
  [envs addObject:tmpenv];
  for (TypeDecl *typedecl in typesList) {
  	type = [self typeCheckType:typedecl.type];
    [(SemanticNamedType *)[tmpenv semanticTypeForSymbol:typedecl.typeIdentifier] setType:type];
  }
  for (TypeDecl *typedecl in typesList) {
    type = [tmpenv semanticTypeForSymbol:typedecl.typeIdentifier];
    if (!((SemanticNamedType *)type).inCycle && [(SemanticNamedType *)type isCycle])
      [ErrorMessage printErrorMessageLineNumber:typedecl.lineNumber
                                     withFormat:"Error: Type definition cycle detected",
       [typedecl.typeIdentifier cString]];
  }
  [envs removeLastObject];
  [[envs lastObject] addSemanticElementsFromEnvironment:tmpenv];
  [tmpenv release];
  return nil;
}
- (id)typeCheckFuncDecl:(SyntaxList *)funcsList
{
  SemanticEnvironment *tmpenv = [[SemanticEnvironment alloc] init];
  SemanticEnvironment *funcenv;
  SemanticType *type = nil;
  SemanticRecordType *pararecord;
  IRExpression *imexpr;
  NSMutableArray *array = [[NSMutableArray alloc] init];
  int i = 0;
  for (FunctionDecl *fundecl in funcsList) {
    pararecord = [self typeCheckTypeFields:fundecl.parameters];
    if (fundecl.returnType)
    	type = [self typeCheckType:fundecl.returnType].actualType;
    else
    	type = [SemanticVoidType sharedVoidType];
    [array addObject:type];
    if ([tmpenv semanticEntryForSymbol:fundecl.name])
      [ErrorMessage printErrorMessageLineNumber:fundecl.lineNumber
                                     withFormat:"Error: Function %s has been defined in the batch of mutually recursive functions",
       [fundecl.name cString]];
    else
    	[tmpenv setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:pararecord
      	                                                          andReturnType:type]
        	           forSymbol:fundecl.name];
  }
  [envs addObject:tmpenv];
  for (FunctionDecl *fundecl in funcsList) {
    funcenv = [[SemanticEnvironment alloc] init];
    for (SingleTypeField *para in fundecl.parameters) {
      type = [self semanticTypeForSymbol:para.typeIdentifier].actualType;
      if (!type) type = [SemanticType type];
      [funcenv setSemanticEntry:[SemanticVarEntry varEntryWithSemanticType:type]
                      forSymbol:para.identifier];
    }
    [envs addObject:funcenv];
    imexpr = [self typeCheckExpression:fundecl.body];
    if (fundecl.returnType) {
      if (![imexpr.type.actualType isSameType:[[array objectAtIndex:i++] actualType]])
        [ErrorMessage printErrorMessageLineNumber:fundecl.lineNumber
                                       withFormat:"Error: In function %s, actual return type is different from declared", 
         [fundecl.name cString]];
    } else if (![imexpr.type.actualType isSameType:[SemanticVoidType sharedVoidType]])
      [ErrorMessage printErrorMessageLineNumber:fundecl.lineNumber
                                     withFormat:"Error: Procedure %s returns a value", [fundecl.name cString]];

    [envs removeLastObject];
    [funcenv release];
  }
  [envs removeLastObject];
  [[envs	lastObject] addSemanticElementsFromEnvironment:tmpenv];
  [array release];
  [tmpenv release];
  return nil;
}
- (SemanticType *)typeCheckType:(Type *)type
{
  Symbol *name;
  if ([type isMemberOfClass:[NameType class]]) {
    name = [(NameType *)type name];
  	SemanticType *result = [self semanticTypeForSymbol:name];
    if (!result)
      [ErrorMessage printErrorMessageLineNumber:type.lineNumber
                                     withFormat:"Error: Undefined type %s", [name cString]];
  	return result;
  } else if ([type isMemberOfClass:[ArrayType class]]) {
    name = [(ArrayType *)type typeName];
    SemanticType *result = [self semanticTypeForSymbol:name];
    if (result)
      return [SemanticArrayType arrayTypeWithSemanticType:result];
    [ErrorMessage printErrorMessageLineNumber:type.lineNumber
                                   withFormat:"Error: Undefined type %s", [name cString]];
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
    tmptype = [self semanticTypeForSymbol:obj.typeIdentifier];
    if (!tmptype) {
      [ErrorMessage printErrorMessageLineNumber:obj.lineNumber
                                     withFormat:"Error: Undefined type %s", [obj.typeIdentifier cString]];
      tmptype = [SemanticType type];
    }
    [result addSemanticType:tmptype forField:obj.identifier];
  }
  return [result autorelease];
}
- (void)symbolInitialization
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  SemanticEnvironment *env = [[SemanticEnvironment alloc] init];
  [env setSemanticType:[SemanticIntType sharedIntType] 
           forSymbol:[Symbol symbolWithName:@"int"]];
  [env setSemanticType:[SemanticStringType sharedStringType] 
           forSymbol:[Symbol symbolWithName:@"string"]];
  
  SemanticRecordType *intRecord = [[SemanticRecordType alloc] init];
  // i : int
  [intRecord addSemanticType:[SemanticIntType sharedIntType] 
                    forField:[Symbol symbolWithName:@"i"]];
  SemanticRecordType *stringRecord = [[SemanticRecordType alloc] init];
  // s : string
  [stringRecord addSemanticType:[SemanticStringType sharedStringType]
                       forField:[Symbol symbolWithName:@"s"]];
  [env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:stringRecord 
                                                     andReturnType:[SemanticVoidType sharedVoidType]] 
           forSymbol:[Symbol symbolWithName:@"print"]];
  [env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:intRecord
                                                     andReturnType:[SemanticVoidType sharedVoidType]]
           forSymbol:[Symbol symbolWithName:@"printi"]];
  [env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:nil
                                                     andReturnType:[SemanticVoidType sharedVoidType]]
           forSymbol:[Symbol symbolWithName:@"flush"]];
  [env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:nil
                                                     andReturnType:[SemanticStringType sharedStringType]]
           forSymbol:[Symbol symbolWithName:@"getchar"]];
  [env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:stringRecord
                                                     andReturnType:[SemanticIntType sharedIntType]]
           forSymbol:[Symbol symbolWithName:@"ord"]];
  [env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:intRecord
                                                     andReturnType:[SemanticStringType sharedStringType]]
           forSymbol:[Symbol symbolWithName:@"chr"]];
  [env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:intRecord
                                                     andReturnType:[SemanticIntType sharedIntType]]
           forSymbol:[Symbol symbolWithName:@"not"]];
  [env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:intRecord
                                                     andReturnType:[SemanticVoidType sharedVoidType]]
           forSymbol:[Symbol symbolWithName:@"exit"]];
  [stringRecord release];
  stringRecord = [[SemanticRecordType alloc] init];
  // s : string, f : int, n : int
  [stringRecord addSemanticType:[SemanticStringType sharedStringType] forField:[Symbol symbolWithName:@"s"]];
  [stringRecord addSemanticType:[SemanticIntType sharedIntType] forField:[Symbol symbolWithName:@"f"]];
  [stringRecord addSemanticType:[SemanticIntType sharedIntType] forField:[Symbol symbolWithName:@"n"]];
  [env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:stringRecord
                                                     andReturnType:[SemanticStringType sharedStringType]]
           forSymbol:[Symbol symbolWithName:@"substring"]];
  [stringRecord release];
  stringRecord = [[SemanticRecordType alloc] init];
  // s1 : string, s2 : string
  [stringRecord addSemanticType:[SemanticStringType sharedStringType] forField:[Symbol symbolWithName:@"s1"]];
  [stringRecord addSemanticType:[SemanticStringType sharedStringType] forField:[Symbol symbolWithName:@"s2"]];
	[env setSemanticEntry:[SemanticFuncEntry funcEntryWithFormalParameters:stringRecord
                                                     andReturnType:[SemanticStringType sharedStringType]]
           forSymbol:[Symbol symbolWithName:@"concat"]];
  [intRecord release];
  [stringRecord release];
  [envs addObject:env];
  [env release];
  [pool drain];
}
- (void)dealloc
{
  [envs release];
  [loopVars release];
  [super dealloc];
}
@end
