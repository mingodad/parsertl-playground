//From: https://github.com/greenbone/openvas-scanner/blob/be2b7024cb007945011881400552f835241a6264/nasl/nasl_grammar.y
/* SPDX-FileCopyrightText: 2023 Greenbone AG
 * SPDX-FileCopyrightText: 2002-2003 Michel Arboi
 * SPDX-FileCopyrightText: 2002-2003 Renaud Deraison
 *
 * SPDX-License-Identifier: GPL-2.0-only
 */

/*Tokens*/
%token IF
%token ELSE
%token EQ
%token NEQ
%token SUPEQ
%token INFEQ
%token OR
%token AND
%token MATCH
%token NOMATCH
%token REP
%token FOR
%token REPEAT
%token UNTIL
%token FOREACH
%token WHILE
%token BREAK
%token CONTINUE
%token FUNCTION
%token RETURN
%token INCLUDE
%token LOCAL
%token GLOBAL
%token PLUS_PLUS
%token MINUS_MINUS
%token L_SHIFT
%token R_SHIFT
%token R_USHIFT
%token EXPO
%token PLUS_EQ
%token MINUS_EQ
%token MULT_EQ
%token DIV_EQ
%token MODULO_EQ
%token L_SHIFT_EQ
%token R_SHIFT_EQ
%token R_USHIFT_EQ
%token RE_MATCH
%token RE_NOMATCH
%token ARROW
%token IDENT
%token STRING1
%token STRING2
%token INTEGER
%token '='
%token '<'
%token '>'
%token '|'
%token '^'
%token '&'
%token '+'
%token '-'
%token '*'
%token '/'
%token '%'
%token NOT
%token UMINUS
%token BIT_NOT
%token '('
%token ')'
%token ','
%token '{'
%token '}'
%token ';'
%token ':'
%token '['
%token ']'
%token '!'
%token '~'
%token '.'

%right /*1*/ PLUS_EQ MINUS_EQ MULT_EQ DIV_EQ MODULO_EQ L_SHIFT_EQ R_SHIFT_EQ R_USHIFT_EQ '='
%left /*2*/ OR
%left /*3*/ AND
%nonassoc /*4*/ EQ NEQ SUPEQ INFEQ MATCH NOMATCH RE_MATCH RE_NOMATCH '<' '>'
%left /*5*/ '|'
%left /*6*/ '^'
%left /*7*/ '&'
%nonassoc /*8*/ L_SHIFT R_SHIFT R_USHIFT
%left /*9*/ '+' '-'
%left /*10*/ '*' '/' '%'
%nonassoc /*11*/ NOT
%nonassoc /*12*/ UMINUS BIT_NOT
%right /*13*/ EXPO
%nonassoc /*14*/ PLUS_PLUS MINUS_MINUS
%nonassoc /*15*/ ARROW

%start tiptop

%%

tiptop :
	instr_decl_list
	;

instr_decl_list :
	instr_decl
	| instr_decl_list instr_decl
	;

instr_decl :
	instr
	| func_decl
	;

func_decl :
	FUNCTION identifier '(' arg_decl ')' block
	;

arg_decl :
	/*empty*/
	| arg_decl_1
	;

arg_decl_1 :
	identifier
	| arg_decl_1 ',' identifier
	;

block :
	'{' instr_list '}'
	| '{' '}'
	;

instr_list :
	instr
	| instr_list instr
	;

instr :
	simple_instr ';'
	| block
	| if_block
	| loop
	//| error ';'
	;

simple_instr :
	aff
	| post_pre_incr
	| rep
	| func_call
	| ret
	| inc
	| loc
	| glob
	| BREAK
	| CONTINUE
	| /*empty*/
	;

ret :
	RETURN expr
	| RETURN
	;

if_block :
	IF '(' expr ')' instr
	| IF '(' expr ')' instr ELSE instr
	;

loop :
	for_loop
	| while_loop
	| repeat_loop
	| foreach_loop
	;

for_loop :
	FOR '(' aff_func ';' expr ';' aff_func ')' instr
	;

while_loop :
	WHILE '(' expr ')' instr
	;

repeat_loop :
	REPEAT instr UNTIL expr ';'
	;

foreach_loop :
	FOREACH identifier '(' expr ')' instr
	;

aff_func :
	aff
	| post_pre_incr
	| func_call
	| /*empty*/
	;

rep :
	func_call REP expr
	;

string :
	STRING1
	| STRING2
	;

inc :
	INCLUDE '(' string ')'
	;

func_call :
	identifier '(' arg_list ')'
	;

arg_list :
	arg_list_1
	| /*empty*/
	;

arg_list_1 :
	arg
	| arg_list_1 ',' arg
	;

arg :
	expr
	| identifier ':' expr
	;

aff :
	lvalue '=' /*1R*/ expr
	| lvalue PLUS_EQ /*1R*/ expr
	| lvalue MINUS_EQ /*1R*/ expr
	| lvalue MULT_EQ /*1R*/ expr
	| lvalue DIV_EQ /*1R*/ expr
	| lvalue MODULO_EQ /*1R*/ expr
	| lvalue R_SHIFT_EQ /*1R*/ expr
	| lvalue R_USHIFT_EQ /*1R*/ expr
	| lvalue L_SHIFT_EQ /*1R*/ expr
	;

lvalue :
	identifier
	| array_elem
	;

identifier :
	IDENT
	| REP
	;

array_elem :
	identifier '[' array_index ']'
	;

array_index :
	expr
	;

post_pre_incr :
	PLUS_PLUS /*14N*/ lvalue
	| MINUS_MINUS /*14N*/ lvalue
	| lvalue PLUS_PLUS /*14N*/
	| lvalue MINUS_MINUS /*14N*/
	;

expr :
	'(' expr ')'
	| expr AND /*3L*/ expr
	| '!' expr %prec NOT /*11N*/
	| expr OR /*2L*/ expr
	| expr '+' /*9L*/ expr
	| expr '-' /*9L*/ expr
	| '-' /*9L*/ expr %prec UMINUS /*12N*/
	| '~' expr %prec BIT_NOT /*12N*/
	| expr '*' /*10L*/ expr
	| expr EXPO /*13R*/ expr
	| expr '/' /*10L*/ expr
	| expr '%' /*10L*/ expr
	| expr '&' /*7L*/ expr
	| expr '^' /*6L*/ expr
	| expr '|' /*5L*/ expr
	| expr R_SHIFT /*8N*/ expr
	| expr R_USHIFT /*8N*/ expr
	| expr L_SHIFT /*8N*/ expr
	| post_pre_incr
	| expr MATCH /*4N*/ expr
	| expr NOMATCH /*4N*/ expr
	| expr RE_MATCH /*4N*/ string
	| expr RE_NOMATCH /*4N*/ string
	| expr '<' /*4N*/ expr
	| expr '>' /*4N*/ expr
	| expr EQ /*4N*/ expr
	| expr NEQ /*4N*/ expr
	| expr SUPEQ /*4N*/ expr
	| expr INFEQ /*4N*/ expr
	| var
	| aff
	| ipaddr
	| atom
	| const_array
	;

const_array :
	'[' list_array_data ']'
	;

list_array_data :
	array_data
	| list_array_data ',' array_data
	;

array_data :
	simple_array_data
	| string ARROW /*15N*/ simple_array_data
	;

atom :
	INTEGER
	| STRING2
	| STRING1
	;

simple_array_data :
	atom
	;

var :
	var_name
	| array_elem
	| func_call
	;

var_name :
	identifier
	;

ipaddr :
	INTEGER '.' INTEGER '.' INTEGER '.' INTEGER
	;

loc :
	LOCAL arg_decl
	;

glob :
	GLOBAL arg_decl
	;

%%

%%

[ \n\r\t]+	skip()
"#".*	skip()

"^"	'^'
"~"	'~'
"<"	'<'
"="	'='
">"	'>'
"|"	'|'
"-"	'-'
","	','
";"	';'
":"	':'
"!"	'!'
"/"	'/'
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"*"	'*'
"&"	'&'
"%"	'%'
"+"	'+'

"&&"	AND
"=>"	ARROW
break	BREAK
continue	CONTINUE
"/="	DIV_EQ
else	ELSE
"=="	EQ
"**"	EXPO
for	FOR
foreach	FOREACH
function	FUNCTION
global	GLOBAL
if	IF
include	INCLUDE
"<="	INFEQ
local_var	LOCAL
"<<"	L_SHIFT
"<<="	L_SHIFT_EQ
"><"	MATCH
"-="	MINUS_EQ
"--"	MINUS_MINUS
"%="	MODULO_EQ
"*="	MULT_EQ
"!="	NEQ
"!<"	NOMATCH
"!"	NOT
"||"	OR
"+="	PLUS_EQ
"++"	PLUS_PLUS
"=~"	RE_MATCH
"!~"	RE_NOMATCH
"x"	REP
repeat	REPEAT
return	RETURN
">>"	R_SHIFT
">>="	R_SHIFT_EQ
">>>"	R_USHIFT
">>>="	R_USHIFT_EQ
">="	SUPEQ
until	UNTIL
while	WHILE

'(\\.|[^'\n\r\\])*'	STRING1
\"(\\.|[^"\n\r\\])*\"	STRING2
[0-9]+	INTEGER
0[Xx][0-9A-Fa-f]+	INTEGER
[A-Za-z_][A-Za-z0-9_]*	IDENT

%%
