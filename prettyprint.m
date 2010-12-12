#include <stdio.h>
#import <Foundation/Foundation.h>
#include "helper.h"
#import "AbstractSyntax.h"

void printVar(NSMutableArray *indent, Var *var);
void printType(NSMutableArray *indent, Type *type);
void printDeclaration(NSMutableArray *indent, Decl *decl);
void printExpression(NSMutableArray *indent, Expression *expr);

void prettyprint(NSMutableArray *indent, id syntax)
{
  printIndent(indent);
  if (!syntax)
    printf("Empty\n");
  else if ([syntax isMemberOfClass:[Symbol class]])
    printf("%s\n", [syntax cString]);
  else if ([syntax isKindOfClass:[Var class]])
    printVar(indent, syntax);
  else if ([syntax isKindOfClass:[Type class]])
    printType(indent, syntax);
  else if ([syntax isKindOfClass:[Decl class]])
    printDeclaration(indent, syntax);
  else if ([syntax isMemberOfClass:[SyntaxList class]]) {
    printf("SyntaxList\n");
    [indent addObject:[NSNumber numberWithInt:10]];
    for (id obj in syntax)
      if (obj != [syntax lastObject])
      	prettyprint(indent, obj);
		replaceLast(indent, -10);
		prettyprint(indent, [syntax lastObject]);
    [indent removeLastObject];
  } else if ([syntax isMemberOfClass:[SingleTypeField class]])
    printf("SingleTypeField: %s : %s\n", [[(SingleTypeField *)syntax identifier] cString], 
           [[(SingleTypeField *)syntax typeIdentifier] cString]);
  else if ([syntax isMemberOfClass:[FieldExpression class]]) {
    printf("FieldExpression\n");
    [indent addObject:[NSNumber numberWithInt:15]];
    prettyprint(indent, [(FieldExpression *)syntax identifier]);
		replaceLast(indent, -15);
    prettyprint(indent, [(FieldExpression *)syntax expr]);
    [indent removeLastObject];
  } else if ([syntax isKindOfClass:[Expression class]])
    printExpression(indent, syntax);
}
void printVar(NSMutableArray *indent, Var *var)
{
  if ([var isMemberOfClass:[SimpleVar class]]) {
    printf("SimpleVar: %s\n", [[(SimpleVar *)var name] cString]);
  } else if ([var isMemberOfClass:[FieldVar class]]) {
    printf("FieldVar\n");
    [indent addObject:[NSNumber numberWithInt:8]];
    prettyprint(indent, [(FieldVar *)var variable]);
    replaceLast(indent, -8);
    prettyprint(indent, [(FieldVar *)var field]);
    [indent removeLastObject];
  } else if ([var isMemberOfClass:[SubscriptVar class]]) {
    printf("SubscriptVar\n");
    [indent addObject:[NSNumber numberWithInt:12]];
		prettyprint(indent, [(SubscriptVar *)var variable]);
		replaceLast(indent, -12);
    prettyprint(indent, [(SubscriptVar *)var subscript]);
    [indent removeLastObject];
  } else
    printf("Error: Unknown Var\n");
}
void printType(NSMutableArray *indent, Type *type)
{
  if ([type isMemberOfClass:[NameType class]])
    printf("NameType: %s\n", [[(NameType *)type name] cString]);
  else if ([type isMemberOfClass:[RecordType class]]) {
    printf("RecordType\n");
    [indent addObject:[NSNumber numberWithInt:-10]];
    prettyprint(indent, [(RecordType *)type typefields]);
    [indent removeLastObject];
  } else if ([type isMemberOfClass:[ArrayType class]])
    printf("ArrayType: %s\n", [[(ArrayType *)type typeName] cString]);
  else
    printf("Error: Unknown Type\n");
}
void printDeclaration(NSMutableArray *indent, Decl *decl)
{
  if ([decl isMemberOfClass:[VarDecl class]]) {
    printf("VarDecl\n");
    [indent addObject:[NSNumber numberWithInt:7]];
    prettyprint(indent, [(VarDecl *)decl identifier]);
    if ([(VarDecl *)decl typeIdentifier])
    	prettyprint(indent, [(VarDecl *)decl typeIdentifier]);
    replaceLast(indent, -7);
    prettyprint(indent, [(VarDecl *)decl expr]);
    [indent removeLastObject];
  } else if ([decl isMemberOfClass:[TypeDecl class]]) {
    printf("TypeDecl\n");
    [indent addObject:[NSNumber numberWithInt:8]];
    prettyprint(indent, [(TypeDecl *)decl typeIdentifier]);
 		replaceLast(indent, -8);
    prettyprint(indent, [(TypeDecl *)decl type]);
    [indent removeLastObject];    
  } else if ([decl isMemberOfClass:[FunctionDecl class]]) {
    printf("FunctionDecl\n");
    [indent addObject:[NSNumber numberWithInt:12]];
    prettyprint(indent, [(FunctionDecl *)decl name]);
    prettyprint(indent, [(FunctionDecl *)decl parameters]);
    if ([(FunctionDecl *)decl returnType])
    	prettyprint(indent, [(FunctionDecl *)decl returnType]);
		replaceLast(indent, -12);
    prettyprint(indent, [(FunctionDecl *)decl body]);
    [indent removeLastObject];
  } else
    printf("Error: Unknown Decl\n");
}
void printExpression(NSMutableArray *indent, Expression *expr)
{
  if ([expr isMemberOfClass:[IntExpression class]])
    printf("Int: %d\n", [(IntExpression *)expr value]);
  else if ([expr isMemberOfClass:[StringExpression class]])
    printf("String: %s\n", 
           [[(StringExpression *)expr string] cStringUsingEncoding:NSASCIIStringEncoding]);
  else if ([expr isMemberOfClass:[NilExpression class]])
    printf("Nil\n");
  else if ([expr isMemberOfClass:[OperationExpression class]]) {
    printf("Operation\n");
    [indent	addObject:[NSNumber numberWithInt:9]];
    prettyprint(indent, [(OperationExpression *)expr leftOperand]);
    printIndent(indent);
    switch ([(OperationExpression *)expr operation]) {
      case plus: printf("+\n");break;
      case minus: printf("-\n");break;
      case multiply: printf("*\n");break;
      case divide: printf("/\n");break;
      case eq: printf("=\n");break;
      case ne: printf("<>\n");break;
      case lt: printf("<\n");break;
      case le: printf("<=\n");break;
      case gt: printf(">\n");break;
      case ge: printf(">=\n");break;
      default: printf("Error: Unknown Operator\n");break;
    }
		replaceLast(indent, -9);
    prettyprint(indent, [(OperationExpression *)expr rightOperand]);
    [indent removeLastObject];
  } else if ([expr isMemberOfClass:[VarExpression class]]) {
  	printf("Var\n");
    [indent addObject:[NSNumber numberWithInt:-3]];
    prettyprint(indent, [(VarExpression *)expr variable]);
    [indent removeLastObject];
  } else if ([expr isMemberOfClass:[AssignExpression class]]) {
    printf("Assign\n");
    [indent addObject:[NSNumber numberWithInt:6]];
    prettyprint(indent, [(AssignExpression *)expr variable]);
		replaceLast(indent, -6);
    prettyprint(indent, [(AssignExpression *)expr expression]);
    [indent removeLastObject]; 
  } else if ([expr isMemberOfClass:[IfExpression class]]) {
    printf("If\n");
    [indent addObject:[NSNumber numberWithInt:2]];
    prettyprint(indent, [(IfExpression *)expr test]);
    if (![(IfExpression *)expr elseClause]) {
      replaceLast(indent, -2);
    }
    prettyprint(indent, [(IfExpression *)expr thenClause]);
    if ([(IfExpression *)expr elseClause]) {
      replaceLast(indent, -2);
      prettyprint(indent, [(IfExpression *)expr elseClause]);
    }
    [indent removeLastObject]; 
  } else if ([expr isMemberOfClass:[WhileExpression class]]) {
    printf("While\n");
    [indent addObject:[NSNumber numberWithInt:5]];
    prettyprint(indent, [(WhileExpression *)expr test]);
		replaceLast(indent, -5);
    prettyprint(indent, [(WhileExpression *)expr body]);
    [indent removeLastObject];
  } else if ([expr isMemberOfClass:[BreakExpression class]])
    printf("Break\n");
  else if ([expr isMemberOfClass:[CallExpression class]]) {
    printf("Call\n");
    [indent addObject:[NSNumber numberWithInt:4]];
    prettyprint(indent, [(CallExpression *)expr functionName]);
		replaceLast(indent, -4);
    prettyprint(indent, [(CallExpression *)expr actualParas]);
    [indent removeLastObject];
  } else if ([expr isMemberOfClass:[RecordExpression class]]) {
    printf("Record\n");
    [indent addObject:[NSNumber numberWithInt:6]];
    prettyprint(indent, [(RecordExpression *)expr typeIdentifier]);
		replaceLast(indent, -6);
    prettyprint(indent, [(RecordExpression *)expr fields]);
    [indent removeLastObject];
  } else if ([expr isMemberOfClass:[SequenceExpression class]]) {
    printf("Sequence\n");
    [indent addObject:[NSNumber numberWithInt:-8]];
    prettyprint(indent, [(SequenceExpression *)expr expressions]);
    [indent removeLastObject];
  } else if ([expr isMemberOfClass:[ForExpression class]]) {
    printf("For\n");
    [indent addObject:[NSNumber numberWithInt:3]];
    prettyprint(indent, [(ForExpression *)expr varDecl]);
    prettyprint(indent, [(ForExpression *)expr end]);
		replaceLast(indent, -3);
    prettyprint(indent, [(ForExpression *)expr body]);
    [indent removeLastObject];
  } else if ([expr isMemberOfClass:[LetExpression class]]) {
    printf("Let\n");
    [indent addObject:[NSNumber numberWithInt:3]];
    prettyprint(indent, [(LetExpression *)expr declList]);
		replaceLast(indent, -3);
    prettyprint(indent, [(LetExpression *)expr exprList]);
    [indent removeLastObject];
  } else if ([expr isMemberOfClass:[ArrayExpression class]]) {
    printf("Array\n");
    [indent addObject:[NSNumber numberWithInt:5]];
    prettyprint(indent, [(ArrayExpression *)expr typeIdentifier]);
    prettyprint(indent, [(ArrayExpression *)expr size]);
		replaceLast(indent, -5);
    prettyprint(indent, [(ArrayExpression *)expr initialValue]);
    [indent removeLastObject];
  } else 
    printf("Error: Unknown Expression\n");
}