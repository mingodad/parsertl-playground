//From: https://github.com/SunkSchematic0006/jeffery_423_2024_spring/blob/7dd3ae162b85085831776b5e12fadf64836a6954/target/423/go.y
// Copyright 2009 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file
// (a copy is at www2.cs.uidaho.edu/~jeffery/courses/445/go/LICENSE).

/*
 * Go language grammar adapted from Go 1.2.2.
 *
 * The Go semicolon rules are:
 *
 *  1. all statements and declarations are terminated by semicolons.
 *  2. semicolons can be omitted before a closing ) or }.
 *  3. semicolons are inserted by the lexer before a newline
 *      following a specific list of tokens.
 *
 * Rules #1 and #2 are accomplished by writing the lists as
 * semicolon-separated lists with an optional trailing semicolon.
 * Rule #3 is implemented in yylex.
 */

/*Tokens*/
%token LANDAND
%token LANDNOT
%token LASOP
%token LBREAK
%token LCASE
%token LCHAN
%token LCOLAS
%token LCOMM
%token LCONST
%token LCONTINUE
%token LDDD
%token LDEC
%token LDEFAULT
%token LDEFER
%token LELSE
%token LEQ
%token LFALL
%token LFOR
%token LFUNC
%token LGE
%token LGO
%token LGOTO
%token LGT
%token LIF
//%token LIGNORE
%token LIMPORT
%token LINC
%token LINTERFACE
%token LLE
%token LLITERAL
%token LLSH
%token LLT
%token LMAP
%token LNAME
%token LNE
%token LOROR
%token LPACKAGE
%token LRANGE
%token LRETURN
%token LRSH
%token LSELECT
%token LSTRUCT
%token LSWITCH
%token LTYPE
%token LVAR

%left /*1*/ LCOMM
%left /*2*/ LOROR
%left /*3*/ LANDAND
%left /*4*/ LEQ LGE LGT LLE LLT LNE
%left /*5*/ '^' '-' '+' '|'
%left /*6*/ LANDNOT LLSH LRSH '*' '&' '/' '%'
%left /*7*/ NotPackage
%left /*8*/ LPACKAGE
%left /*9*/ NotParen
%left /*10*/ '('
%left /*11*/ ')'
%left /*12*/ PreferToRightParen

%start file

%%

file :
	package imports xdcl_list
	;

package :
	%prec NotPackage /*7L*/ /*empty*/
	| LPACKAGE /*8L*/ sym ';'
	;

imports :
	/*empty*/
	| imports import ';'
	;

import :
	LIMPORT import_stmt
	| LIMPORT '(' /*10L*/ import_stmt_list osemi ')' /*11L*/
	| LIMPORT '(' /*10L*/ ')' /*11L*/
	;

import_stmt :
	import_here import_package
	| import_here
	;

import_stmt_list :
	import_stmt
	| import_stmt_list ';' import_stmt
	;

import_here :
	LLITERAL
	| sym LLITERAL
	| '.' LLITERAL
	;

import_package :
	LPACKAGE /*8L*/ LNAME import_safety ';'
	;

import_safety :
	/*empty*/
	| LNAME
	;

xdcl :
	/*empty*/
	| common_dcl
	| xfndcl
	| non_dcl_stmt
	//| error
	;

common_dcl :
	LVAR vardcl
	| LVAR '(' /*10L*/ vardcl_list osemi ')' /*11L*/
	| LVAR '(' /*10L*/ ')' /*11L*/
	| lconst constdcl
	| lconst '(' /*10L*/ constdcl osemi ')' /*11L*/
	| lconst '(' /*10L*/ constdcl ';' constdcl_list osemi ')' /*11L*/
	| lconst '(' /*10L*/ ')' /*11L*/
	| LTYPE typedcl
	| LTYPE '(' /*10L*/ typedcl_list osemi ')' /*11L*/
	| LTYPE '(' /*10L*/ ')' /*11L*/
	;

lconst :
	LCONST
	;

vardcl :
	dcl_name_list ntype
	| dcl_name_list ntype LASOP expr_list
	| dcl_name_list LASOP expr_list
	;

constdcl :
	dcl_name_list ntype LASOP expr_list
	| dcl_name_list LASOP expr_list
	;

constdcl1 :
	constdcl
	| dcl_name_list ntype
	| dcl_name_list
	;

typedclname :
	sym
	;

typedcl :
	typedclname ntype
	;

simple_stmt :
	expr
	| expr LASOP expr
	| expr_list LASOP expr_list
	| expr_list LCOLAS expr_list
	| expr LINC
	| expr LDEC
	;

case :
	LCASE expr_or_type_list ':'
	| LCASE expr_or_type_list LASOP expr ':'
	| LCASE expr_or_type_list LCOLAS expr ':'
	| LDEFAULT ':'
	;

compound_stmt :
	'{' stmt_list '}'
	;

caseblock :
	case stmt_list
	;

caseblock_list :
	/*empty*/
	| caseblock_list caseblock
	;

loop_body :
	'{' stmt_list '}'
	;

range_stmt :
	expr_list LASOP LRANGE expr
	| expr_list LCOLAS LRANGE expr
	;

for_header :
	osimple_stmt ';' osimple_stmt ';' osimple_stmt
	| osimple_stmt
	| range_stmt
	;

for_body :
	for_header loop_body
	;

for_stmt :
	LFOR for_body
	;

if_header :
	osimple_stmt
	| osimple_stmt ';' osimple_stmt
	;

if_stmt :
	LIF if_header loop_body elseif_list else
	;

elseif :
	LELSE LIF if_header loop_body
	;

elseif_list :
	/*empty*/
	| elseif_list elseif
	;

else :
	/*empty*/
	| LELSE compound_stmt
	;

switch_stmt :
	LSWITCH if_header '{' caseblock_list '}'
	;

select_stmt :
	LSELECT '{' caseblock_list '}'
	;

expr :
	uexpr
	| expr LOROR /*2L*/ expr
	| expr LANDAND /*3L*/ expr
	| expr LEQ /*4L*/ expr
	| expr LNE /*4L*/ expr
	| expr LLT /*4L*/ expr
	| expr LLE /*4L*/ expr
	| expr LGE /*4L*/ expr
	| expr LGT /*4L*/ expr
	| expr '+' /*5L*/ expr
	| expr '-' /*5L*/ expr
	| expr '|' /*5L*/ expr
	| expr '^' /*5L*/ expr
	| expr '*' /*6L*/ expr
	| expr '/' /*6L*/ expr
	| expr '%' /*6L*/ expr
	| expr '&' /*6L*/ expr
	| expr LANDNOT /*6L*/ expr
	| expr LLSH /*6L*/ expr
	| expr LRSH /*6L*/ expr
	| expr LCOMM /*1L*/ expr
	;

uexpr :
	pexpr
	| '*' /*6L*/ uexpr
	| '&' /*6L*/ uexpr
	| '+' /*5L*/ uexpr
	| '-' /*5L*/ uexpr
	| '!' uexpr
	| '~' uexpr
	| '^' /*5L*/ uexpr
	| LCOMM /*1L*/ uexpr
	;

pseudocall :
	pexpr '(' /*10L*/ ')' /*11L*/
	| pexpr '(' /*10L*/ expr_or_type_list ocomma ')' /*11L*/
	| pexpr '(' /*10L*/ expr_or_type_list LDDD ocomma ')' /*11L*/
	;

pexpr_no_paren :
	LLITERAL
	| name
	| pexpr '.' sym
	| pexpr '.' '(' /*10L*/ expr_or_type ')' /*11L*/
	| pexpr '.' '(' /*10L*/ LTYPE ')' /*11L*/
	| pexpr '[' expr ']'
	| pexpr '[' oexpr ':' oexpr ']'
	| pexpr '[' oexpr ':' oexpr ':' oexpr ']'
	| pseudocall
	| convtype '(' /*10L*/ expr ocomma ')' /*11L*/
	| comptype '{' braced_keyval_list '}'
	| fnliteral
	;

keyval :
	expr ':' complitexpr
	;

bare_complitexpr :
	expr
	| '{' braced_keyval_list '}'
	;

complitexpr :
	expr
	| '{' braced_keyval_list '}'
	;

pexpr :
	pexpr_no_paren
	| '(' /*10L*/ expr_or_type ')' /*11L*/
	;

expr_or_type :
	expr
	| non_expr_type %prec PreferToRightParen /*12L*/
	;

name_or_type :
	ntype
	;

new_name :
	sym
	;

dcl_name :
	sym
	;

onew_name :
	/*empty*/
	| new_name
	;

sym :
	LNAME
	| hidden_importsym
	| '?'
	;

hidden_importsym :
	'@' LLITERAL '.' LNAME
	| '@' LLITERAL '.' '?'
	;

name :
	sym %prec NotParen /*9L*/
	;

labelname :
	new_name
	;

dotdotdot :
	LDDD
	| LDDD ntype
	;

ntype :
	recvchantype
	| fntype
	| othertype
	| ptrtype
	| dotname
	| '(' /*10L*/ ntype ')' /*11L*/
	;

non_expr_type :
	recvchantype
	| fntype
	| othertype
	| '*' /*6L*/ non_expr_type
	;

non_recvchantype :
	fntype
	| othertype
	| ptrtype
	| dotname
	| '(' /*10L*/ ntype ')' /*11L*/
	;

convtype :
	fntype
	| othertype
	;

comptype :
	othertype
	;

fnret_type :
	recvchantype
	| fntype
	| othertype
	| ptrtype
	| dotname
	;

dotname :
	name
	| name '.' sym
	;

othertype :
	'[' oexpr ']' ntype
	| '[' LDDD ']' ntype
	| LCHAN non_recvchantype
	| LCHAN LCOMM /*1L*/ ntype
	| LMAP '[' ntype ']' ntype
	| structtype
	| interfacetype
	;

ptrtype :
	'*' /*6L*/ ntype
	;

recvchantype :
	LCOMM /*1L*/ LCHAN ntype
	;

structtype :
	LSTRUCT '{' structdcl_list osemi '}'
	| LSTRUCT '{' '}'
	;

interfacetype :
	LINTERFACE '{' interfacedcl_list osemi '}'
	| LINTERFACE '{' '}'
	;

xfndcl :
	LFUNC fndcl fnbody
	;

fndcl :
	sym '(' /*10L*/ oarg_type_list_ocomma ')' /*11L*/ fnres
	| '(' /*10L*/ oarg_type_list_ocomma ')' /*11L*/ sym '(' /*10L*/ oarg_type_list_ocomma ')' /*11L*/ fnres
	;

fntype :
	LFUNC '(' /*10L*/ oarg_type_list_ocomma ')' /*11L*/ fnres
	;

fnbody :
	/*empty*/
	| '{' stmt_list '}'
	;

fnres :
	%prec NotParen /*9L*/ /*empty*/
	| fnret_type
	| '(' /*10L*/ oarg_type_list_ocomma ')' /*11L*/
	;

fnlitdcl :
	fntype
	;

fnliteral :
	fnlitdcl '{' stmt_list '}'
	//| fnlitdcl error
	;

xdcl_list :
	/*empty*/
	| xdcl_list xdcl ';'
	;

vardcl_list :
	vardcl
	| vardcl_list ';' vardcl
	;

constdcl_list :
	constdcl1
	| constdcl_list ';' constdcl1
	;

typedcl_list :
	typedcl
	| typedcl_list ';' typedcl
	;

structdcl_list :
	structdcl
	| structdcl_list ';' structdcl
	;

interfacedcl_list :
	interfacedcl
	| interfacedcl_list ';' interfacedcl
	;

structdcl :
	new_name_list ntype oliteral
	| embed oliteral
	| '(' /*10L*/ embed ')' /*11L*/ oliteral
	| '*' /*6L*/ embed oliteral
	| '(' /*10L*/ '*' /*6L*/ embed ')' /*11L*/ oliteral
	| '*' /*6L*/ '(' /*10L*/ embed ')' /*11L*/ oliteral
	;

packname :
	LNAME
	| LNAME '.' sym
	;

embed :
	packname
	;

interfacedcl :
	new_name indcl
	| packname
	| '(' /*10L*/ packname ')' /*11L*/
	;

indcl :
	'(' /*10L*/ oarg_type_list_ocomma ')' /*11L*/ fnres
	;

arg_type :
	name_or_type
	| sym name_or_type
	| sym dotdotdot
	| dotdotdot
	;

arg_type_list :
	arg_type
	| arg_type_list ',' arg_type
	;

oarg_type_list_ocomma :
	/*empty*/
	| arg_type_list ocomma
	;

stmt :
	/*empty*/
	| compound_stmt
	| common_dcl
	| non_dcl_stmt
	//| error
	;

non_dcl_stmt :
	simple_stmt
	| for_stmt
	| switch_stmt
	| select_stmt
	| if_stmt
	| labelname ':' stmt
	| LFALL
	| LBREAK onew_name
	| LCONTINUE onew_name
	| LGO pseudocall
	| LDEFER pseudocall
	| LGOTO new_name
	| LRETURN oexpr_list
	;

stmt_list :
	stmt
	| stmt_list ';' stmt
	;

new_name_list :
	new_name
	| new_name_list ',' new_name
	;

dcl_name_list :
	dcl_name
	| dcl_name_list ',' dcl_name
	;

expr_list :
	expr
	| expr_list ',' expr
	;

expr_or_type_list :
	expr_or_type
	| expr_or_type_list ',' expr_or_type
	;

keyval_list :
	keyval
	| bare_complitexpr
	| keyval_list ',' keyval
	| keyval_list ',' bare_complitexpr
	;

braced_keyval_list :
	/*empty*/
	| keyval_list ocomma
	;

osemi :
	/*empty*/
	| ';'
	;

ocomma :
	/*empty*/
	| ','
	;

oexpr :
	/*empty*/
	| expr
	;

oexpr_list :
	/*empty*/
	| expr_list
	;

osimple_stmt :
	/*empty*/
	| simple_stmt
	;

oliteral :
	/*empty*/
	| LLITERAL
	;

%%

%x	INSERT_SEMI

float				([0-9]*\.[0-9]+)|([0-9]+\.)
exponent			[eE][-+]?[0-9]+

id	[a-zA-Z_][a-zA-Z_0-9]*

hex_int	"0"[xX][0-9a-fA-F]+
octal_int	"0"[0-7]+
dec_int	[0-9]+

sstring	"'"(\\.|[^\\"])"'"
dstring	"\""(\\.|[^\\"])*"\""

lname	"bool"|"float64"|"int"|{id}

lliteral	{hex_int}|{octal_int}|{dec_int}|{float}{exponent}?|[0-9]+{exponent}|{sstring}|{dstring}

%%

//case LNAME: case LLITERAL: case ')': case '}': case ']':
({lname}|{lliteral}|")"|"}"|"]")\n<INSERT_SEMI>	reject()
<INSERT_SEMI>{
	{lname}	LNAME
	{lliteral}	LLITERAL
	")"	')'
	"}"	'}'
	"]"	']'
	\n<INITIAL>	';'
}

"\n"					skip() //{ lineno++; if (isender(lasttoken)) return tok(';'); }
[ \t\f\v\r]+				skip() /* Ignore whitespace. */

"/*"([^*]|"*"+[^*/])*"*"+"/"		skip() /* C comment */
"//".*					skip() /* C++ comment */

"{"					'{'
"}"					'}'
"["					'['
"]"					']'
"("					'('
")"					')'
";"					';'
":"					':'
"?"					'?'
"."					'.'
"..."					LDDD
"+"					'+'
"-"					'-'
"*"					'*'
"/"					'/'
"%"					'%'
"^"					'^'
"&"					'&'
"|"					'|'
"~"					'~'
"!"					'!'
"="					LASOP
":="					LCOLAS
"<"					LLT
">"					LGT
"+="					LASOP
"-="					LASOP
"*="					LASOP
"/="					LASOP
"%="					LASOP
"^="					LASOP
"&="					LASOP
"|="					LASOP
"<<"					LLSH
">>"					LRSH
"=="					LEQ
"!="					LNE
"<="					LLE
">="					LGE
"&&"					LANDAND
"&^"					LANDNOT
"||"					LOROR
"++"					LINC
"--"					LDEC
","					','
"<-"					LCOMM
"@"					'@'

"break"					LBREAK
"case"					LCASE
"chan"					LCHAN
"const"					LCONST
"continue"				LCONTINUE
"default"				LDEFAULT
"defer"					LDEFER
"else"					LELSE
"fallthrough"				LFALL
"for"					LFOR
"func"					LFUNC
"go"					LGO
"goto"					LGOTO
"if"					LIF
"import"				LIMPORT
"interface"				LINTERFACE
"map"					LMAP
"package"				LPACKAGE
"range"					LRANGE
"return"				LRETURN
"select"				LSELECT
"struct"				LSTRUCT
"switch"				LSWITCH
"type"					LTYPE
"var"					LVAR

{lliteral}			LLITERAL
{lname}					LNAME

%%
