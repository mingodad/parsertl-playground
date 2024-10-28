/*
=====================================================================

			       XMC 1.0

	       A Logic-Programming-Based Model Checker

	      Copyright (c) 2000,  SUNY at Stony Brook.

		      Contact: lmc@cs.sunysb.edu

=====================================================================


XMC is a model checker implemented using the XSB tabled logic
programming system. XMC is an explicit-state, local model checker for
processes specified in XL, a sugared version of value-passing CCS, and
the alternation-free fragment of the modal mu-calculus. The XMC system
is a result of the LMC (Logic-Programming-Based Model Checking)
project at Stony Brook.

The LMC project is funded by a four-year grant from NSF's Experimental
Software Systems (ESS) program.  The project aims to combine the
latest developments in concurrency research and in logic programming
to advance the state-of-the art of system specification and
verification.  For more information on the LMC project, see
http://www.cs.sunysb.edu/~lmc.

This Readme.txt file contains:
	1. Terms of Use
	2. Installation Notes
	3. Usage Notes


1. Terms of Use:
----------------
This is the first public release of XMC, dated April 2000.  You may
freely copy and distribute verbatim copies of the XMC system, provided
this Readme.txt file is prominently placed in every copy. You may also
modify any of the sources of the XMC system, and redistribute the
modifications. However, (1) the modified sources must be freely
available, under the same terms as the original XMC system; (2) the
modified system should prominently state the complete revision history.

The software is provided "AS-IS" with NO WARRANTIES of any kind,
express or implied including, but not limited to, the implied
warranties of merchantability and fitness for a particular purpose.
The entire risk as to the quality and performance of the program is
with you.  Should the XMC system prove defective, you assume the cost
of all necessary servicing, repair or correction.

In no event unless required by applicable law will SUNY at Stony Brook
and/or any other party who may modify and redistribute XMC as
permitted above, be liable to you for damages, including any lost
profits, lost monies, or other special, incidental or consequential
damages arising out of the use or inability to use (including but not
limited to loss of data or data being rendered inaccurate or losses
sustained by third parties or a failure of the program to operate with
any other program) the program, even if you have been advised of the
possibility of such damages, or for any claim by any other party.
*/

/*Tokens*/
%token AND
%token ASSIGN
%token CHANNEL
//%token COL_HY
%token DEFINE
%token DIAM_ALL
//%token DIAM_MIMUS
%token DIAM_MINUS
%token DIV
%token ELSE
%token EQ_EQ
%token FALSE
%token FROM
%token GREATER_EQ
%token ID
%token IF
%token INT_CONST
%token IS
%token LESSER_EQ
%token MINUS_EQ
%token MOD
%token NOT_EQ
%token NOT_EQ_EQ
//%token OP
%token OR
%token PLUS_EQ
%token PREDICATE
%token PREF
//%token SYNTAX_ERROR
%token THEN
%token TRUE
%token VAR

%nonassoc /*1*/ ASSIGN IS
%left /*2*/ OR
%left /*3*/ AND
%nonassoc /*4*/ '~'
%nonassoc /*5*/ '[' ']' DIAM_ALL //DIAM_MIMUS
%right /*6*/ '#'
%right /*7*/ '|'
%right /*8*/ PREF ';'
%nonassoc /*9*/ THEN
%nonassoc /*10*/ ELSE
%nonassoc /*11*/ EQ_EQ NOT_EQ '=' NOT_EQ_EQ '>' '<' GREATER_EQ LESSER_EQ
%left /*12*/ '+' '-'
%left /*13*/ '*' MOD '/' DIV
%nonassoc /*14*/ '?' '!'
%left /*15*/ ',' ':'

%start prog

%%

prog :
	speclist
	;

speclist :
	spec
	| speclist spec
	;

spec :
	pdefn
	| preddecl
	| cdecl
	| fdefn
	//| error '.'
	;

preddecl :
	PREDICATE predlist FROM ID '.'
	| PREDICATE predlist '.'
	;

predlist :
	predtype
	| predlist ',' /*15L*/ predtype
	;

predtype :
	ID
	| ID '(' predtypelist ')'
	;

predtypelist :
	type
	| predtypelist ',' /*15L*/ type
	;

cdecl :
	CHANNEL ID '.'
	| CHANNEL ID '(' vardecllist ')' '.'
	;

vardecllist :
	vardecl
	| vardecllist ',' /*15L*/ vardecl
	;

vardecl :
	VAR
	| VAR ':' /*15L*/ type
	;

type :
	ID
	| VAR
	| ID '(' typelist ')'
	;

typelist :
	type
	| typelist ',' /*15L*/ type
	;

pdefn :
	pname DEFINE pexp '.'
	;

pname :
	ID '(' vardecllist ')'
	| ID
	;

pexp :
	exp
	| cname '?' /*14N*/ term
	| cname '?' /*14N*/ '*' /*13L*/
	| cname '!' /*14N*/ term
	| cname '!' /*14N*/ '*' /*13L*/
	| IF exp THEN /*9N*/ pexp ELSE /*10N*/ pexp
	| IF exp THEN /*9N*/ pexp
	| pexp PREF /*8R*/ pexp
	| pexp ';' /*8R*/ pexp
	| pexp '#' /*6R*/ pexp
	| pexp '|' /*7R*/ pexp
	| '{' pexp '}'
	;

cname :
	vardecl
	| ID
	;

term :
	ID '(' explist ')'
	| ID
	| vardecl
	| INT_CONST
	| '[' /*5N*/ ']' /*5N*/
	| '[' /*5N*/ termlist ']' /*5N*/
	| '[' /*5N*/ termlist '|' /*7R*/ term ']' /*5N*/
	| '(' term ',' /*15L*/ termlist ')'
	;

termlist :
	term
	| termlist ',' /*15L*/ term
	;

explist :
	exp
	| explist ',' /*15L*/ exp
	;

exp :
	term
	| '+' /*12L*/ exp
	| '-' /*12L*/ exp
	| '~' /*4N*/ exp
	| exp '+' /*12L*/ exp
	| exp '-' /*12L*/ exp
	| exp '*' /*13L*/ exp
	| exp MOD /*13L*/ exp
	| exp DIV /*13L*/ exp
	| exp '/' /*13L*/ exp
	| exp '<' /*11N*/ exp
	| exp '>' /*11N*/ exp
	| exp GREATER_EQ /*11N*/ exp
	| exp LESSER_EQ /*11N*/ exp
	| exp '=' /*11N*/ exp
	| exp EQ_EQ /*11N*/ exp
	| exp NOT_EQ /*11N*/ exp
	| exp NOT_EQ_EQ /*11N*/ exp
	| exp AND /*3L*/ exp
	| exp OR /*2L*/ exp
	| exp ASSIGN /*1N*/ exp
	| exp IS /*1N*/ exp
	| '(' exp ')'
	;

fdefn :
	fterm PLUS_EQ fexp '.'
	| fterm MINUS_EQ fexp_ng '.'
	;

fterm :
	ID '(' vardecllist ')'
	| ID
	;

fexp :
	fexp AND /*3L*/ fexp
	| fexp OR /*2L*/ fexp
	| '<' /*11N*/ modality '>' /*11N*/ fexp
	| DIAM_ALL /*5N*/ fexp
	| DIAM_MINUS modality '>' /*11N*/ fexp
	| '[' /*5N*/ modality ']' /*5N*/ fexp
	| TRUE
	| FALSE
	| fterm
	| '(' fexp ')'
	;

fterm_ng :
	ID '(' vardecllist ')'
	| ID
	;

fexp_ng :
	fexp_ng AND /*3L*/ fexp_ng
	| fexp_ng OR /*2L*/ fexp_ng
	| '<' /*11N*/ modality '>' /*11N*/ fexp_ng
	| DIAM_ALL /*5N*/ fexp_ng
	| DIAM_MINUS modality '>' /*11N*/ fexp_ng
	| '[' /*5N*/ modality ']' /*5N*/ fexp_ng
	| TRUE
	| FALSE
	| fterm_ng
	| '(' fexp_ng ')'
	;

modality :
	'-' /*12L*/ posmodal
	| '-' /*12L*/
	| posmodal
	;

posmodal :
	unit
	| '{' unitlist '}'
	;

unit :
	ID '(' unitlist ')'
	| ID
	| VAR
	| INT_CONST
	;

unitlist :
	unit
	| unitlist ',' /*15L*/ unit
	;

%%

digit	[0-9]
lcase	[a-z]
ucase	[A-Z]
alnum	[a-zA-Z0-9_]
ucaseus	[A-Z_]
oprtr	[+\-*/?!@#\\\^&=<>:]

%%

[ \t\r\n]+	skip()
"%".*	skip()
"/*"(?s:.)*?"*/"	skip()
"{*"(?s:.)*?"*}"	skip()

//static mapping operators[]
":=" 	ASSIGN
"::=" 	DEFINE
//":-" 	COL_HY
"+=" 	PLUS_EQ
"-=" 	MINUS_EQ
"==" 	EQ_EQ
"\\=" 	NOT_EQ
"\\==" 	NOT_EQ_EQ
">=" 	GREATER_EQ
"<=" 	LESSER_EQ
"=<" 	LESSER_EQ
"//" 	DIV
"/\\" 	AND
"\\/" 	OR
"<->" 	DIAM_ALL
"<-" 	DIAM_MINUS

//static mapping keywords[]
"o" 	PREF
"is" 	IS
"channel" CHANNEL
"predicate"  PREDICATE
"from" 	FROM
"mod" 	MOD
"if" 	IF
"then" 	THEN
"else" 	ELSE
"tt" 	TRUE
"ff" 	FALSE

"!"	'!'
"#"	'#'
"("	'('
")"	')'
"*"	'*'
"+"	'+'
","	','
"-"	'-'
"."	'.'
"/"	'/'
":"	':'
";"	';'
"<"	'<'
"="	'='
">"	'>'
"?"	'?'
"["	'['
"]"	']'
"{"	'{'
"|"	'|'
"}"	'}'
"~"	'~'

{digit}+	INT_CONST
\'[^\']*\'	ID
{lcase}{alnum}*	ID
{ucaseus}{alnum}*	VAR

%%
