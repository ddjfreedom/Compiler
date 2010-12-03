%{
#include <stdio.h>
#include <stdlib.h>
#import <Foundation/Foundation.h>
#import "Symbol.h"
#include "parse.tab.h"
#define YY_USER_ACTION yylloc.first_line = yylloc.last_line; yylloc.last_line = yylineno;
  void yyerror(id *expr, const char *s, ...);
%}

%option noyywrap
%option yylineno
/*%option debug*/
%x COMMENT
%x STR
DIGIT [0-9]
ID [[:alpha:]][[:alnum:]_]*
PUNCTUATION [,:;()\[\]{}.+\-*/<>=&|]
WHITESPACE [ \t\n\r\f]
%%
	int commentNestLevel = 0;
	int commentStartLine = 0;
	NSMutableString *string = nil;
  /* integer constant */
{DIGIT}+ { /*printf("An integer %s (%d)\n", yytext, atoi(yytext));*/
           yylval = [NSNumber numberWithInt:atoi(yytext)];
           return INTEGER; }
  /* keyword */
array { return ARRAY; }
break { return BREAK; }
do { return DO; }
else { return ELSE; }
end { return END; }
for { return FOR; }
function { return FUNCTION; }
if { return IF; }
in { return IN; }
let { return LET; }
nil { return NIL; }
of { return OF; }
then { return THEN; }
to { return TO; }
type { return TYPE; }
var { return VAR; }
while { return WHILE; }

{ID} { yylval = [Symbol symbolWithName:[NSString stringWithCString:yytext 
                                                          encoding:NSASCIIStringEncoding]];
       return IDENTIFIER; }

  /* punctuation */
{PUNCTUATION} { return yytext[0]; }
"<>" { return NE; }
"<=" { return LE; }
">=" { return GE; }
":=" { return ASSIGN; }

  /* string constant */
\" string = [NSMutableString string]; BEGIN(STR);
<STR>{
	[^\\\n\f\r\"]+ [string appendFormat:@"%s", yytext];
	\\{WHITESPACE}+\\ /* eat up whitespace characters between '/'s */
	\" BEGIN(INITIAL); yylval = string; return STRING; /* closing quote */
	\n|\f|\r BEGIN(INITIAL); yyerror(NULL, "Warning: Unclosed String"); yylval = string; return STRING;
	\\[0-9]{3} { int ch = atoi(yytext+1);
               if (ch > 0xff)
                 yyerror(NULL, "Warning: %s Unrecognized escape sequence(%d larger than 0xff)", yytext, ch);
               else
							   [string appendFormat:@"%c", ch];
             }
	\\[0-9]+ yyerror(NULL, "Warning: %s Unrecognized escape sequence(should be exactly 3 digits)", yytext);
	\\n [string appendFormat:@"%c", '\n'];
	\\t [string appendFormat:@"%c", '\t'];
	\\\" [string appendFormat:@"%c", '"'];
	\\\\ [string appendFormat:@"%c", '\\'];
	
	/* ctrl sequence */
	\\^@ [string appendFormat:@"\000"];
	\\^[A-Z] [string appendFormat:@"%c", yytext[2]-'A'+1];
	\\^\[ [string appendFormat:@"\033"];
	\\^\\ [string appendFormat:@"\034"];
	\\^\] [string appendFormat:@"\035"];
	\\^^ [string appendFormat:@"\036"];
	\\^_ [string appendFormat:@"\037"];
	
	\\[[:print:]] yyerror(NULL, "Warning: %s Unrecognized escape sequence", yytext);
	<<EOF>> yyerror(NULL, "Warning: Unclosed String"); yylval = string; BEGIN(INITIAL); return STRING;
}
	/* comment */
"/*" commentNestLevel = 1; commentStartLine = yylineno; BEGIN(COMMENT);
<COMMENT>{
  [^*/]* /* eat up anything that's not '*' or '/' */
  \*+[^*/]* /* eat up '*'s not followed by '/'s */
	"/"+[^*/]* /* eat up '/'s not followed by '*'s */
	\/+\* commentNestLevel++; /* start nested comment */
	\*+\/ commentNestLevel--; if (!commentNestLevel) BEGIN(INITIAL); /* end comment */
	<<EOF>> yyerror(NULL, "Warning: Unclosed Comment"); yyterminate();
}
  /* ignore blanks */
{WHITESPACE}+
. { yyerror(NULL, "An unrecognized character (%s)\n", yytext); }
 /*<<EOF>> { if (commentNestLevel) yyerror(NULL, "Warning: Unclosed Comment"); 
  					 yyterminate(); }*/
%%
