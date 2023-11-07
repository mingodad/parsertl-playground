//From: https://github.com/fsprojects/FsLexYacc/blob/70abefd5fc21e7897b60deff0b4212b652e82353/src/FsLex.Core/fslexpars.fsy
/* (c) Microsoft Corporation 2005-2008.  */
/*Tokens*/
%token STRING
%token IDENT
%token CODE
%token CHAR
%token UNICODE_CATEGORY
%token RULE
%token PARSE
%token LET
%token AND
%token LPAREN
%token RPAREN
%token COLON
%token EOF
%token BAR
//%token DOT
%token PLUS
%token STAR
%token QMARK
%token EQUALS
%token UNDERSCORE
%token LBRACK
%token RBRACK
%token HAT
%token DASH

%left /*1*/ BAR
%nonassoc /*3*/ regexp_seq
%nonassoc /*5*/ QMARK PLUS STAR
%nonassoc IDENT LBRACK UNDERSCORE UNICODE_CATEGORY STRING CHAR LPAREN EOF

%start spec

%%

spec :
	codeopt Macros RULE Rules codeopt
	;

codeopt :
	CODE
	| /*empty*/
	;

Macros :
	Macros macro
	| /*empty*/
	;

macro :
	LET IDENT EQUALS regexp
	;

Rules :
	rule
	| Rules AND rule
	;

rule :
	IDENT args EQUALS PARSE optbar clauses
	;

args :
	/*empty*/
	| args LPAREN IDENT COLON IDENT RPAREN
	| args IDENT
	;

optbar :
	/*empty*/
	| BAR /*1L*/
	;

clauses :
	clause
	| clauses BAR /*1L*/ clause
	;

clause :
	regexp CODE
	;

regexp :
	CHAR
	| UNICODE_CATEGORY
	| EOF
	| UNDERSCORE
	| STRING
	| IDENT
	| regexp regexp %prec regexp_seq /*3L*/
	| regexp PLUS
	| regexp STAR
	| regexp QMARK
	| regexp BAR /*1L*/ regexp
	| LPAREN regexp RPAREN
	| LBRACK charset RBRACK
	| LBRACK HAT charset RBRACK
	;

charset :
	charset_char
	| charset charset_char
	;

charset_char :
	CHAR
	| CHAR DASH CHAR
	;

%%

%x code

letter   [A-Za-z]
digit   [0-9]
whitespace   [ \t]
char   '([^\\]|(\\(\\|'|\"|n|t|b|r)))'
hex   [0-9A-Fa-f]
hexgraph   "\\x"{hex}{2}
trigraph   "\\"{digit}{3}
newline   (\n|\r\n)
ident_start_char   {letter}
ident_char   ({ident_start_char}|{digit}|['_])
ident   {ident_start_char}{ident_char}*

unicodegraph_short   "\\u"{hex}{4}
unicodegraph_long    "\\U"{hex}{8}

dq_string	\"(\\.|[^"\n\r\\])*\"
sq_string	'(\\.|[^'\n\r\\])*'

%%

"rule" RULE
"parse" PARSE
"eof" EOF
"let" LET
"and" AND
{char}  CHAR

'{trigraph}'  CHAR
'{hexgraph}'   CHAR
'{unicodegraph_short}'   CHAR
'{unicodegraph_long}'	CHAR
'\\[A-Za-z]'	UNICODE_CATEGORY

"{"<>code>
<code> {
	"{"<>code>
	"}"<<>	CODE
	{dq_string}<.>
	{sq_string}<.>
	[^{}]<.>
}

{dq_string}	STRING
{sq_string}	STRING

{whitespace}+  skip()
{newline}	skip()
{ident} IDENT
"|"   BAR
//"."   DOT
"+"   PLUS
"*"   STAR
"?"   QMARK
"="   EQUALS
"["   LBRACK
"]"   RBRACK
"("   LPAREN
")"   RPAREN
":"   COLON
"_"   UNDERSCORE
"^"   HAT
"-"   DASH
"(*"(?s:.)*?"*)"	skip()
"//".* skip()

%%
