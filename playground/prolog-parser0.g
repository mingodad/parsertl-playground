//From: https://github.com/nimble-byte/PrologParser/blob/77daf2739d96014d16352579e28207afe7f43fe2/src/prolog.y

%token DEF DOT COMMA POPEN PCLOSE LOPEN LCLOSE
%token PIPE PLUS MINUS ASTERISK DIV
%token SMALLER SEQUAL GREATER GEQUAL EQUAL UNEQUAL
//%token NOT
%token IS
%token NUMBER
%token CONST VAR

%left PLUS MINUS ASTERISK DIV
%left UNEQUAL SMALLER SEQUAL GREATER GEQUAL

%start clause

%%

clause :
	clause expression
        | expression
        ;

expression :
	rule DOT
	| fact DOT
	;

rule :
	fact DEF factList
	;

fact :
	CONST POPEN params PCLOSE
	;

subRule :
	CONST POPEN params PCLOSE
	| arithmeticExpr
	;

arithmeticExpr :
	VAR operator arithmeticRhs
	;

operator :
	PLUS
	| MINUS
	| EQUAL
	| SEQUAL
	| SMALLER
	| GEQUAL
	| GREATER
	| UNEQUAL
	| ASTERISK
	| DIV
	| IS
	;

arithmeticRhs :
	VAR
	| NUMBER
	| CONST
	| arithmeticExpr
	;

params :
	params COMMA param
        | param
        ;

factList :
	factList COMMA subRule
	| subRule
	;

list :
	LOPEN lelement restlist
	| LOPEN LCLOSE
	;

restlist :
	PIPE list LCLOSE
	| PIPE lelement LCLOSE
	| COMMA lelement restlist
	| LCLOSE
	;

lelement :
	VAR
	| NUMBER
	| list
	;

param :
	CONST
        | NUMBER
        | list
        | VAR
        ;

%%

%%

[ \t\r\n]+	skip()


"*"	ASTERISK
","	COMMA
":-"	DEF
"/"	DIV
"."	DOT
"==?"	EQUAL
">="	GEQUAL
">"	GREATER
"is"	IS
"]"	LCLOSE
"["	LOPEN
"-"	MINUS
//"not"	NOT
")"	PCLOSE
"|"	PIPE
"+"	PLUS
"("	POPEN
"<="	SEQUAL
"<"	SMALLER
"=//="	UNEQUAL

[0-9]+|[0-9]+\.[0-9]+	NUMBER
[a-z][a-zA-Z0-9]*	CONST
[A-Z][A-Za-z0-9]*	VAR

%%
