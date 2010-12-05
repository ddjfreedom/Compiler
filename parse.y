%{
#define YYSTYPE id
#import <Foundation/Foundation.h>
#import "AbstractSyntax.h"
#import "Symbol.h"
#import "ErrorMessage.h"
#include "lex.yy.m"
%}
%locations
%error-verbose
%parse-param {id *expr}

%token IDENTIFIER
%token INTEGER
%token STRING
%token NE "<>"
%token LE "<="
%token GE ">="
%token ASSIGN ":="
%token ARRAY
%token BREAK
%token DO
%token ELSE
%token END
%token FOR
%token FUNCTION
%token IF
%token IN
%token LET
%token NIL
%token OF
%token THEN
%token TO
%token TYPE
%token VAR
%token WHILE

%nonassoc ASSIGN
%left '|'
%left '&'
%nonassoc '=' '>' '<' NE LE GE
%left '+' '-'
%left '*' '/'
%right NEG

%%
//MARK: prog
prog: /* Empty */ { *expr = nil; }
|expr { *expr = $1; $$ = $1; }
;

//MARK: expr
expr: 
STRING 
{ $$ = [[StringExpression alloc] initWithString:$1 andLineNumber:@1.first_line]; }

| INTEGER 
{ $$ = [[IntExpression alloc] initWithInt:[$1 intValue] andLineNumber:@1.first_line]; }

| NIL 
{ $$ = [[NilExpression alloc] initWithLineNumber:@1.first_line]; }

| lvalue 
{ $$ = [[VarExpression alloc] initWithVariable:$1 andLineNumber:[$1 lineNumber]];
	[$1 release];
}

| '-' expr %prec NEG 
{ IntExpression *zero = [[IntExpression alloc] initWithInt:0 andLineNumber:@1.first_line];
  $$ = [[OperationExpression alloc] initWithLeftOperand:zero
                                              operation:minus
                                           rightOperand:$2
                                          andLineNumber:@1.first_line];
  [zero release];
  [$2 release];
}

| expr '+' expr 
{ $$ = [[OperationExpression alloc] initWithLeftOperand:$1 
                                              operation:plus 
                                           rightOperand:$3 
                                          andLineNumber:[$1 lineNumber]];
  [$1 release];
  [$3 release];
}

| expr '-' expr
{ $$ = [[OperationExpression alloc] initWithLeftOperand:$1
                                              operation:minus
                                           rightOperand:$3
                                          andLineNumber:[$1 lineNumber]];
  [$1 release];
  [$3 release];
}

| expr '*' expr
{ $$ = [[OperationExpression alloc] initWithLeftOperand:$1
                                              operation:multiply 
                                           rightOperand:$3
                                          andLineNumber:[$1 lineNumber]];
  [$1 release];
  [$3 release];
}

| expr '/' expr
{ $$ = [[OperationExpression alloc] initWithLeftOperand:$1
                                              operation:divide 
                                           rightOperand:$3
                                          andLineNumber:[$1 lineNumber]];
  [$1 release];
  [$3 release];
}
 
| expr '=' expr
{ $$ = [[OperationExpression alloc] initWithLeftOperand:$1
                                              operation:eq 
                                           rightOperand:$3
                                          andLineNumber:[$1 lineNumber]];
  [$1 release];
  [$3 release];
}

| expr '<' expr
{ $$ = [[OperationExpression alloc] initWithLeftOperand:$1
                                              operation:lt 
                                           rightOperand:$3
                                          andLineNumber:[$1 lineNumber]];
  [$1 release];
  [$3 release];
}

| expr '>' expr
{ $$ = [[OperationExpression alloc] initWithLeftOperand:$1
                                              operation:gt 
                                           rightOperand:$3
                                          andLineNumber:[$1 lineNumber]];
  [$1 release];
  [$3 release];
}

| expr NE expr
{ $$ = [[OperationExpression alloc] initWithLeftOperand:$1
                                              operation:ne 
                                           rightOperand:$3
                                          andLineNumber:[$1 lineNumber]];
  [$1 release];
  [$3 release];
}

| expr LE expr
{ $$ = [[OperationExpression alloc] initWithLeftOperand:$1
                                              operation:le 
                                           rightOperand:$3
                                          andLineNumber:[$1 lineNumber]];
  [$1 release];
  [$3 release];
}

| expr GE expr
{ $$ = [[OperationExpression alloc] initWithLeftOperand:$1
                                              operation:ge 
                                           rightOperand:$3
                                          andLineNumber:[$1 lineNumber]];
  [$1 release];
  [$3 release];
}

| expr '&' expr
{ IntExpression *zero = [[IntExpression alloc] initWithInt:0 andLineNumber:0];
  $$ = [[IfExpression alloc] initWithTest:$1 
                               thenClause:$3 
                               elseClause:zero
                            andLineNumber:[$1 lineNumber]];
  [$1 release];
  [$3 release];
  [zero release];
}

| expr '|' expr
{ IntExpression *one = [[IntExpression alloc] initWithInt:1 andLineNumber:0];
  $$ = [[IfExpression alloc] initWithTest:$1
                               thenClause:one
                               elseClause:$3
                            andLineNumber:[$1 lineNumber]];
  [$1 release];
  [$3 release];
  [one release];
}

| lvalue ASSIGN expr
{ $$ = [[AssignExpression alloc] initWithVariable:$1
                                       expression:$3
                                    andLineNumber:[$1 lineNumber]];
  [$1 release];
  [$3 release];
}

| IDENTIFIER '(' exprlist ')'
{ $$ = [[CallExpression alloc] initWithFunctionName:$1 
                                   actualParameters:$3
                                      andLineNumber:@1.first_line];
  [$3 release];
}

| '(' exprseq ')'
{ $$ = [[SequenceExpression alloc] initWithExpressionSequence:$2
                                                andLineNumber:@1.first_line];
  [$2 release];
}

| IDENTIFIER '{' fieldlist '}'
{ $$ = [[RecordExpression alloc] initWithTypeId:$1
                                      fieldList:$3
                                  andLineNumber:@1.first_line];
  [$3 release];
}

| array OF expr
{ $$ = [[ArrayExpression alloc] initWithTypeId:[(SimpleVar *)[$1 variable] name]
                                          size:[$1 subscript]
                                  initialValue:$3
                                 andLineNumber:[$1 lineNumber]];
  [$1 release];
  [$3 release];
}

| IF expr THEN expr
{ $$ = [[IfExpression alloc] initWithTest:$2
                               thenClause:$4
                            andLineNumber:@1.first_line];
  [$2 release];
  [$4 release];
}

| IF expr THEN expr ELSE expr
{ $$ = [[IfExpression alloc] initWithTest:$2
                               thenClause:$4
                               elseClause:$6
                            andLineNumber:@1.first_line];
  [$2 release];
  [$4 release];
  [$6 release];
}

| WHILE expr DO expr
{ $$ = [[WhileExpression alloc] initWithTest:$2
                                        body:$4
                               andLineNumber:@1.first_line];
  [$2 release];
  [$4 release];
}

| FOR IDENTIFIER ASSIGN expr TO expr DO expr
{ $$ = [[ForExpression alloc] initWithVarDeclaration:[[VarDecl alloc] initWithIdentifier:$2
                                                                              expression:$4
                                                                           andLineNumber:0]
                                          upperBound:$6
                                                body:$8
                                       andLineNumber:@1.first_line];
  [$4 release];
  [$6 release];
  [$8 release];
}

| BREAK
{ $$ = [[BreakExpression alloc] initWithLineNumber:@1.first_line]; }

| LET decllist IN exprseq END
{ $$ = [[LetExpression alloc] initWithDeclarationList:$2
                                       expressionList:$4
                                        andLineNumber:@1.first_line];
  [$2 release];
  [$4 release];
}
;

//MARK: exprseq
exprseq: /* empty */ { $$ = nil; }
| expr 
{ $$ = [[SyntaxList alloc] initWithObject:$1]; [$1 release]; }
| exprseq ';' expr 
{ $$ = $1; [$$ addObject:$3]; [$3 release]; }
| exprseq error { $$ = $1; }
;

//MARK: expr-list
exprlist: /* empty */ { $$ = nil; }
| expr 
{ $$ = [[SyntaxList alloc] initWithObject:$1]; [$1 release]; }
| exprlist ',' expr
{ $$ = $1; [$$ addObject:$3]; [$3 release]; }
;

//MARK: field-list
fieldlist: /* empty */ { $$ = nil; }
| IDENTIFIER '=' expr
{ FieldExpression *tmp = [[FieldExpression alloc] initWithIdentifier:$1
                                                          expression:$3
                                                       andLineNumber:@1.first_line];
  $$ = [[SyntaxList alloc] initWithObject:tmp];
  [tmp release];
  [$3 release];
}
| fieldlist ',' IDENTIFIER '=' expr
{ FieldExpression *tmp = [[FieldExpression alloc] initWithIdentifier:$3
                                                          expression:$5
                                                       andLineNumber:@3.first_line];
  $$ = $1;
  [$$ addObject:tmp];
  [$5 release];
  [tmp release];
}
;

//MARK: array
	/* eliminate the confusion between "type-id [ expr ] of expr" and " lvalue [ expr ]" */
array: IDENTIFIER '[' expr ']'
{ SimpleVar *var = [[SimpleVar alloc] initWithIdentifier:$1 andLineNumber:@1.first_line];
  $$ = [[SubscriptVar alloc] initWithVariable:var
                                    subscript:$3
                                andLineNumber:@1.first_line];
  [$3 release];
  [var release];
}
;

//MARK: lvalue
lvalue: IDENTIFIER 
{ $$ = [[SimpleVar alloc] initWithIdentifier:$1 andLineNumber:@1.first_line]; }
| lvalue '.' IDENTIFIER
{ $$ = [[FieldVar alloc] initWithVariable:$1
                                    field:$3
                            andLineNumber:[$1 lineNumber]];
  [$1 release];
}
| array
{ $$ = $1; }
| lvalue '[' expr ']'
{ $$ = [[SubscriptVar alloc] initWithVariable:$1
                                    subscript:$3
                                andLineNumber:[$1 lineNumber]];
  [$1 release];
  [$3 release];
}
;

//MARK: decllist
decllist: decl 
{ if ([$1 isMemberOfClass:[VarDecl class]])
	  $$ = [[SyntaxList alloc] initWithObject:$1];
  else
    $$ = [[SyntaxList alloc] initWithObject:[SyntaxList syntaxListWithObject:$1]];
  [$1 release];
}
| decllist decl 
{ $$ = $1;
  if ([$2 isMemberOfClass:[VarDecl class]]) {
    [$$ addObject:$2];
  } else {
    id tmp = [$$ lastObject];
    if ([tmp isMemberOfClass:[VarDecl class]])
      [$$ addObject:[SyntaxList syntaxListWithObject:$2]];
    else if ([[tmp lastObject] class] == [$2 class])
      [tmp addObject:$2];
    else
      [$$ addObject:[SyntaxList syntaxListWithObject:$2]];
  }
  [$2 release]; 
}
;

//MARK: decl
decl: 
typedecl { $$ = $1; }
| vardecl { $$ = $1; }
| funcdecl { $$ = $1; }
;

//MARK: TypeDecl
typedecl: TYPE IDENTIFIER '=' type 
{ $$ = [[TypeDecl alloc] initWithTypeIdentifier:$2
                                           type:$4
                                  andLineNumber:@1.first_line];
  [$4 release];
}
;

//MARK: type
type: IDENTIFIER 
{ $$ = [[NameType alloc] initWithName:$1 
                        andLineNumber:@1.first_line];
}
| '{' typefields '}'
{ $$ = [[RecordType alloc] initWithTypeFields:$2 andLineNumber:@1.first_line];
  [$2 release];
}
| ARRAY OF IDENTIFIER
{ $$ = [[ArrayType alloc] initWithTypeName:$3 andLineNumber:@1.first_line]; }
;

//MARK: typefields
typefields: /* empty */ { $$ = nil; }
| typefield
{ $$ = [[SyntaxList alloc] initWithObject:$1]; [$1 release]; }
| typefields ',' typefield
{ $$ = $1; [$$ addObject:$3]; [$3 release]; }
;

//MARK: typefield
typefield: IDENTIFIER ':' IDENTIFIER
{ $$ = [[SingleTypeField alloc] initWithIdentifier:$1
                                    typeIdentifier:$3
                                     andLineNumber:@1.first_line];
}
;

//MARK: vardecl
vardecl: VAR IDENTIFIER ASSIGN expr
{ $$ = [[VarDecl alloc] initWithIdentifier:$2
                                expression:$4
                             andLineNumber:@1.first_line];
  [$4 release];
}
| VAR IDENTIFIER ':' IDENTIFIER ASSIGN expr
{ NameType *type = [[NameType alloc] initWithName:$4 andLineNumber:@4.first_line];
  $$ = [[VarDecl alloc] initWithIdentifier:$2
                            typeIdentifier:type
                                expression:$6
                             andLineNumber:@1.first_line];
  [$6 release];
	[type release];
}
;

//MARK: funcdecl
funcdecl: FUNCTION IDENTIFIER '(' typefields ')' '=' expr
{ $$ = [[FunctionDecl alloc] initWithName:$2
                               parameters:$4
                                     body:$7
                            andLineNumber:@1.first_line];
  [$4 release];
  [$7 release];
}
| FUNCTION IDENTIFIER '(' typefields ')' ':' IDENTIFIER '=' expr
{ NameType *type = [[NameType alloc] initWithName:$7 andLineNumber:@7.first_line];
  $$ = [[FunctionDecl alloc] initWithName:$2
                               parameters:$4
                               returnType:type
                                     body:$9
                            andLineNumber:@1.first_line];
  [$4 release];
  [$9 release];
  [type release];
}
;
%%
void yyerror(id *epxr, const char *s, ...)
{
  va_list ap;
  va_start(ap, s);
  [ErrorMessage printErrorMessageLineNumber:yylloc.first_line withFormat:s arguments:ap];
	va_end(ap);
}