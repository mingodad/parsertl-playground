//From: https://github.com/j-mie6/ParsleyHaskell/blob/8a9e679fc148e7532ccb8100263a6c9f19f2f42a/parsley/benchmarks/NandlangBench/Bison/Nandlang.y
// See also https://github.com/Jellonator/Nandlang

/* A Parser for Nandlang */
%token IDENTIFIER
%token BIT
%token NAT
%token CHAR
%token FUNCTION
%token IF
%token WHILE
%token VAR
%token ELSE

%start nandlang

%%

nandlang :
	funcdef nandlang
	| %empty
	;

index :
	'[' natorbit ']'
	;

natorbit :
	NAT
	| BIT
	;

variable :
	IDENTIFIER
	| IDENTIFIER index
	;

literal :
	BIT
	| CHAR
	;

expr :
	expr '!' nandexpr
	| nandexpr
	;

nandexpr :
	literal
	| funccallOrVar
	;

funccallOrVar :
	IDENTIFIER '(' exprlist ')'
	| IDENTIFIER index
	| IDENTIFIER
	;

exprlist :
	expr_oom
	| %empty
	;

expr_oom :
	expr_oom ',' expr
	| expr
	;

varlist :
	variable_oom
	| %empty
	;

variable_oom :
	variable_oom ',' variable
	| variable
	;

funcparam :
	varlist ':' varlist
	| varlist
	;

varstmt :
	VAR variable_oom '=' expr_oom ';'
        | variable_oom '=' expr_oom ';'
	;

ifstmt :
	IF expr block elsestmt
	;

elsestmt :
	ELSE block
	| %empty
	;

whilestmt :
	WHILE expr block
	;

statement :
	ifstmt
	| whilestmt
	| varstmt
	| expr ';'
	;

block :
	'{' statements '}'
	;

statements :
	statements statement
	| %empty
	;

funcdef :
	FUNCTION IDENTIFIER '(' funcparam ')' block
	;

%%

DIGIT [0-9]
IDLETTER [a-z0-9_A-Z]

%%
[ \t\n]+              skip()
\/\/.*\n              skip()
(0|1)                 BIT
{DIGIT}+              NAT
function[^{IDLETTER}] FUNCTION
if[^{IDLETTER}]       IF
while[^{IDLETTER}]    WHILE
var[^{IDLETTER}]      VAR
else[^{IDLETTER}]     ELSE
[a-z_]{IDLETTER}*     IDENTIFIER
\(                    '('
\)                    ')'
\{                    '{'
\}                    '}'
\[                    '['
\]                    ']'
;                     ';'
:                     ':'
,                     ','
!                     '!'
=                     '='
'(\\[0tnvfr]|.)'      CHAR

%%
