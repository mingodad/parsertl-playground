//From: https://github.com/never-lang/never/blob/cdf50433af096ea26cc964dbfe0c903084833548/front/parser.y
/**
 * Copyright 2018-2021 Slawomir Maludzinski
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/*Tokens*/
%token ARR_DIM_BEG
%token ARR_DIM_END
%token TOK_AND
%token TOK_BIN_AND
%token TOK_BIN_NOT
%token TOK_BIN_OR
%token TOK_BIN_SHL
%token TOK_BIN_SHR
%token TOK_BIN_XOR
%token TOK_BOOL
%token TOK_CATCH
%token TOK_CHAR
%token TOK_C_NULL
//%token TOK_CONST
%token TOK_C_PTR
%token TOK_DDOT
%token TOK_DO
%token TOK_DOT
%token TOK_DOUBLE
%token TOK_ELSE
%token TOK_ENUM
%token TOK_EQ
%token TOK_EXTERN
%token TOK_FALSE
%token TOK_FLOAT
%token TOK_FOR
%token TOK_FUNC
%token TOK_GTE
%token TOK_ID
%token TOK_IF
%token TOK_IN
%token TOK_INT
%token TOK_LET
%token TOK_LONG
%token TOK_LTE
%token TOK_MATCH
%token TOK_MODULE
%token TOK_MODULE_REF
%token TOK_NEQ
%token TOK_NIL
%token TOK_NOT
%token TOK_NUM_CHAR
%token TOK_NUM_DOUBLE
%token TOK_NUM_FLOAT
%token TOK_NUM_INT
%token TOK_NUM_LONG
%token TOK_NUM_STRING
%token TOK_OR
%token TOK_PIPEL
%token TOK_RANGE
%token TOK_RECORD
%token TOK_RET
%token TOK_STRING
%token TOK_TODOTS
%token TOK_TRUE
%token TOK_USE
%token TOK_VAR
%token TOK_VOID
%token TOK_WHILE

%right /*1*/ TOK_IF TOK_ELSE TOK_FOR
%right /*2*/ TOK_RET
%right /*3*/ '='
%right /*4*/ '?' ':'
%left /*5*/ TOK_OR
%left /*6*/ TOK_AND
%left /*7*/ TOK_BIN_OR
%left /*8*/ TOK_BIN_XOR
%left /*9*/ TOK_BIN_AND
%left /*10*/ TOK_EQ TOK_NEQ
%left /*11*/ '<' '>' TOK_LTE TOK_GTE
%left /*12*/ TOK_BIN_SHL TOK_BIN_SHR
%left /*13*/ '+' '-'
%left /*14*/ '*' '/' '%'
%right /*15*/ TOK_NOT TOK_BIN_NOT
%left /*16*/ TOK_PIPEL
%left /*17*/ '(' ')' '[' ']' ARR_DIM_BEG ARR_DIM_END TOK_DOT TOK_DDOT

%start start

%%

expr :
	TOK_TRUE
	| TOK_FALSE
	| TOK_ID
	| TOK_NUM_INT
	| TOK_NUM_LONG
	| TOK_NUM_FLOAT
	| TOK_NUM_DOUBLE
	| TOK_NUM_CHAR
	| TOK_NUM_STRING
	| expr TOK_DDOT /*17L*/ TOK_ID
	| TOK_NIL
	| TOK_C_NULL
	| '-' /*13L*/ expr %prec TOK_NOT /*15R*/
	| expr '+' /*13L*/ expr
	| expr '-' /*13L*/ expr
	| expr '*' /*14L*/ expr
	| expr '/' /*14L*/ expr
	| expr '%' /*14L*/ expr
	| expr '<' /*11L*/ expr
	| expr TOK_LTE /*11L*/ expr
	| expr '>' /*11L*/ expr
	| expr TOK_GTE /*11L*/ expr
	| expr TOK_EQ /*10L*/ expr
	| expr TOK_NEQ /*10L*/ expr
	| expr TOK_AND /*6L*/ expr
	| expr TOK_OR /*5L*/ expr
	| expr TOK_PIPEL /*16L*/ expr
	| TOK_NOT /*15R*/ expr
	| TOK_BIN_NOT /*15R*/ expr
	| expr TOK_BIN_AND /*9L*/ expr
	| expr TOK_BIN_OR /*7L*/ expr
	| expr TOK_BIN_XOR /*8L*/ expr
	| expr TOK_BIN_SHL /*12L*/ expr
	| expr TOK_BIN_SHR /*12L*/ expr
	| '(' /*17L*/ expr ')' /*17L*/
	| expr '?' /*4R*/ expr ':' /*4R*/ expr
	| TOK_IF /*1R*/ '(' /*17L*/ expr ')' /*17L*/ expr %prec TOK_IF /*1R*/
	| TOK_IF /*1R*/ '(' /*17L*/ expr ')' /*17L*/ expr TOK_ELSE /*1R*/ expr %prec TOK_ELSE /*1R*/
	| array
	| expr '[' /*17L*/ expr_list ']' /*17L*/
	| expr '[' /*17L*/ expr_range_dim_list ']' /*17L*/
	;

array :
	ARR_DIM_BEG /*17L*/ expr_list ARR_DIM_END /*17L*/ ':' /*4R*/ param
	| '[' /*17L*/ ']' /*17L*/ ':' /*4R*/ param
	| '[' /*17L*/ expr_list ']' /*17L*/ ':' /*4R*/ param
	| '[' /*17L*/ array_sub_list ']' /*17L*/ ':' /*4R*/ param
	;

array_sub :
	'[' /*17L*/ ']' /*17L*/
	| '[' /*17L*/ expr_list ']' /*17L*/
	| '[' /*17L*/ array_sub_list ']' /*17L*/
	;

array_sub_list :
	array_sub
	| array_sub_list ',' array_sub
	;

expr :
	listcomp
	;

generator :
	TOK_ID TOK_IN expr
	| expr
	;

qualifier :
	generator
	;

qualifier_list :
	qualifier
	| qualifier_list ';' qualifier
	;

listcomp :
	'[' /*17L*/ expr '|' qualifier_list ']' /*17L*/ ':' /*4R*/ param
	;

expr :
	TOK_LET func
	| expr '(' /*17L*/ ')' /*17L*/
	| expr '(' /*17L*/ expr_list ')' /*17L*/
	| expr '=' /*3R*/ expr
	| seq
	| TOK_WHILE '(' /*17L*/ expr ')' /*17L*/ expr
	| TOK_DO expr TOK_WHILE '(' /*17L*/ expr ')' /*17L*/
	| TOK_FOR /*1R*/ '(' /*17L*/ expr ';' expr ';' expr ')' /*17L*/ expr %prec TOK_FOR /*1R*/
	| TOK_FOR /*1R*/ '(' /*17L*/ TOK_ID TOK_IN expr ')' /*17L*/ expr %prec TOK_FOR /*1R*/
	;

iflet :
	TOK_IF /*1R*/ TOK_LET '(' /*17L*/ match_guard_item '=' /*3R*/ expr ')' /*17L*/ expr %prec TOK_IF /*1R*/
	| TOK_IF /*1R*/ TOK_LET '(' /*17L*/ match_guard_record '=' /*3R*/ expr ')' /*17L*/ expr %prec TOK_IF /*1R*/
	| TOK_IF /*1R*/ TOK_LET '(' /*17L*/ match_guard_item '=' /*3R*/ expr ')' /*17L*/ expr TOK_ELSE /*1R*/ expr %prec TOK_ELSE /*1R*/
	| TOK_IF /*1R*/ TOK_LET '(' /*17L*/ match_guard_record '=' /*3R*/ expr ')' /*17L*/ expr TOK_ELSE /*1R*/ expr %prec TOK_ELSE /*1R*/
	;

expr :
	iflet
	;

matchbind :
	TOK_ID
	;

matchbind_list :
	matchbind
	| matchbind_list ',' matchbind
	;

match_guard_item :
	TOK_ID TOK_DDOT /*17L*/ TOK_ID
	| TOK_ID TOK_DOT /*17L*/ TOK_ID TOK_DDOT /*17L*/ TOK_ID
	;

match_guard_record :
	TOK_ID TOK_DDOT /*17L*/ TOK_ID '(' /*17L*/ ')' /*17L*/
	| TOK_ID TOK_DDOT /*17L*/ TOK_ID '(' /*17L*/ matchbind_list ')' /*17L*/
	| TOK_ID TOK_DOT /*17L*/ TOK_ID TOK_DDOT /*17L*/ TOK_ID '(' /*17L*/ ')' /*17L*/
	| TOK_ID TOK_DOT /*17L*/ TOK_ID TOK_DDOT /*17L*/ TOK_ID '(' /*17L*/ matchbind_list ')' /*17L*/
	;

match_guard :
	match_guard_item TOK_RET /*2R*/ expr
	| match_guard_record TOK_RET /*2R*/ expr
	| TOK_ELSE /*1R*/ TOK_RET /*2R*/ expr
	;

match_guard_list :
	match_guard ';'
	| match_guard_list match_guard ';'
	;

expr :
	TOK_MATCH expr '{' '}'
	| TOK_MATCH expr '{' match_guard_list '}'
	| expr TOK_DOT /*17L*/ TOK_ID
	;

touple :
	'(' /*17L*/ expr ',' ')' /*17L*/ ':' /*4R*/ '(' /*17L*/ param_list ')' /*17L*/
	| '(' /*17L*/ expr ',' expr_list ')' /*17L*/ ':' /*4R*/ '(' /*17L*/ param_list ')' /*17L*/
	;

expr :
	touple
	;

expr_list :
	expr
	| expr_list ',' expr
	;

let :
	TOK_LET TOK_ID '=' /*3R*/ expr
	;

var :
	TOK_VAR TOK_ID '=' /*3R*/ expr
	;

seq_list :
	let
	| var
	| func
	| expr
	| seq_list ';' let
	| seq_list ';' var
	| seq_list func
	| seq_list ';' func
	| seq_list ';' expr
	;

seq :
	'{' seq_list '}'
	;

expr_range_dim :
	expr TOK_TODOTS expr
	;

expr_range_dim_list :
	expr_range_dim
	| expr_range_dim_list ',' expr_range_dim
	;

expr :
	'[' /*17L*/ expr_range_dim_list ']' /*17L*/
	;

dim :
	TOK_ID
	;

dim_list :
	dim
	| dim_list ',' dim
	;

range_dim :
	TOK_TODOTS
	| TOK_ID TOK_TODOTS TOK_ID
	;

range_dim_list :
	range_dim
	| range_dim_list ',' range_dim
	;

param_decl :
	TOK_BOOL
	| TOK_ID ':' /*4R*/ TOK_BOOL
	| TOK_INT
	| TOK_ID ':' /*4R*/ TOK_INT
	| TOK_LONG
	| TOK_ID ':' /*4R*/ TOK_LONG
	| TOK_FLOAT
	| TOK_ID ':' /*4R*/ TOK_FLOAT
	| TOK_DOUBLE
	| TOK_ID ':' /*4R*/ TOK_DOUBLE
	| TOK_CHAR
	| TOK_ID ':' /*4R*/ TOK_CHAR
	| TOK_STRING
	| TOK_ID ':' /*4R*/ TOK_STRING
	| TOK_VOID
	| TOK_C_PTR
	| TOK_ID ':' /*4R*/ TOK_C_PTR
	| TOK_ID %prec TOK_RET /*2R*/
	| TOK_ID TOK_DOT /*17L*/ TOK_ID %prec TOK_RET /*2R*/
	| TOK_ID ':' /*4R*/ TOK_ID %prec TOK_RET /*2R*/
	| TOK_ID ':' /*4R*/ TOK_ID TOK_DOT /*17L*/ TOK_ID %prec TOK_RET /*2R*/
	| '[' /*17L*/ dim_list ']' /*17L*/ ':' /*4R*/ param
	| TOK_ID '[' /*17L*/ dim_list ']' /*17L*/ ':' /*4R*/ param
	| '[' /*17L*/ range_dim_list ']' /*17L*/ ':' /*4R*/ TOK_RANGE
	| TOK_ID '[' /*17L*/ range_dim_list ']' /*17L*/ ':' /*4R*/ TOK_RANGE
	| '[' /*17L*/ range_dim_list ']' /*17L*/ ':' /*4R*/ param
	| TOK_ID '[' /*17L*/ range_dim_list ']' /*17L*/ ':' /*4R*/ param
	| '(' /*17L*/ ')' /*17L*/ TOK_RET /*2R*/ param
	| '(' /*17L*/ param_list ')' /*17L*/ TOK_RET /*2R*/ param
	| TOK_ID '(' /*17L*/ ')' /*17L*/ TOK_RET /*2R*/ param
	| TOK_ID '(' /*17L*/ param_list ')' /*17L*/ TOK_RET /*2R*/ param
	| '(' /*17L*/ param_list ')' /*17L*/
	| TOK_ID ':' /*4R*/ '(' /*17L*/ param_list ')' /*17L*/
	;

param :
	param_decl
	| TOK_LET param_decl
	| TOK_VAR param_decl
	;

param_list :
	param
	| param_list ',' param
	;

param_seq :
	param ';'
	| param_seq param ';'
	;

func_decl :
	'(' /*17L*/ ')' /*17L*/ TOK_RET /*2R*/ param
	| '(' /*17L*/ param_list ')' /*17L*/ TOK_RET /*2R*/ param
	| TOK_ID '(' /*17L*/ ')' /*17L*/ TOK_RET /*2R*/ param
	| TOK_ID '(' /*17L*/ param_list ')' /*17L*/ TOK_RET /*2R*/ param
	;

func_body :
	seq
	| '{' '}'
	;

except_all :
	TOK_CATCH seq
	;

except :
	TOK_CATCH '(' /*17L*/ TOK_ID ')' /*17L*/ seq
	;

except_list :
	except
	| except_list except
	;

func_except :
	except_all
	| except_list
	| except_list except_all
	;

func :
	TOK_FUNC func_decl func_body
	| TOK_FUNC func_decl func_body func_except
	| TOK_EXTERN TOK_NUM_STRING TOK_FUNC func_decl
	//| TOK_FUNC TOK_ID error
	;

enum_item :
	TOK_ID '{' param_seq '}'
	| TOK_ID
	| TOK_ID '=' /*3R*/ expr
	;

enum_list :
	enum_item
	| enum_list ',' enum_item
	;

enumtype :
	TOK_ENUM TOK_ID '{' enum_list '}'
	;

record :
	TOK_RECORD TOK_ID '{' param_seq '}'
	;

decl :
	enumtype
	| record
	;

decl_list :
	decl
	| decl_list decl
	;

use :
	TOK_USE TOK_NUM_STRING module_decl
	;

use_list :
	use
	| use_list use
	;

never :
	seq_list
	| decl_list seq_list
	| use_list seq_list
	| use_list decl_list seq_list
	| decl_list
	| use_list decl_list
	;

module_decl :
	TOK_MODULE_REF
	| TOK_MODULE TOK_ID '{' never '}'
	;

start :
	module_decl
	| never
	;

%%

%x USE MODULE_REF

DIGIT [0-9]
HEX_DIGIT[0-9a-fA-F]
ID [a-zA-Z_][a-zA-Z0-9_]*

%%

<*>[ \t\r\n]+	skip()
"#".*	skip()
"/*"(?s:.)*?"*/"	skip()

"%"	'%'
"("	'('
")"	')'
"*"	'*'
"+"	'+'
","	','
"-"	'-'
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

"{["	ARR_DIM_BEG
"]}"	ARR_DIM_END
"&&"	TOK_AND
"&&&"	TOK_BIN_AND
"~~~"	TOK_BIN_NOT
"|||"	TOK_BIN_OR
"<<<"	TOK_BIN_SHL
">>>"	TOK_BIN_SHR
"^^^"	TOK_BIN_XOR
"bool"	TOK_BOOL
"catch"	TOK_CATCH
"char"	TOK_CHAR
//"const"	TOK_CONST
"c_null"	TOK_C_NULL
"c_ptr"	TOK_C_PTR
"::"	TOK_DDOT
"do"	TOK_DO
"."	TOK_DOT
"double"	TOK_DOUBLE
"else"	TOK_ELSE
"enum"	TOK_ENUM
"=="	TOK_EQ
"extern"	TOK_EXTERN
"false"	TOK_FALSE
"float"	TOK_FLOAT
"for"	TOK_FOR
"func"	TOK_FUNC
">="	TOK_GTE
"if"	TOK_IF
"<-"	TOK_IN
"int"	TOK_INT
"let"	TOK_LET
"long"	TOK_LONG
"<="	TOK_LTE
"match"	TOK_MATCH
"module"	TOK_MODULE
TOK_MODULE_REF	TOK_MODULE_REF
"!="	TOK_NEQ
"nil"	TOK_NIL
"!"	TOK_NOT
"||"	TOK_OR
"|>"	TOK_PIPEL
"range"	TOK_RANGE
"record"	TOK_RECORD
"->"	TOK_RET
"string"	TOK_STRING
".."	TOK_TODOTS
"true"	TOK_TRUE
"use"<USE>	TOK_USE
"var"	TOK_VAR
"void"	TOK_VOID
"while"	TOK_WHILE

<USE>{
	[a-zA-Z_./]+<MODULE_REF>	TOK_NUM_STRING
}

<MODULE_REF>{
	[. \t\r\n]<INITIAL>	TOK_MODULE_REF
}

\'[[:print:]]\'	TOK_NUM_CHAR

{DIGIT}+"."{DIGIT}+[dD]	TOK_NUM_DOUBLE

{DIGIT}+"."{DIGIT}+[fF]*	TOK_NUM_FLOAT

{DIGIT}+	TOK_NUM_INT
0[xX]{HEX_DIGIT}+	TOK_NUM_INT

{DIGIT}+[lL]	TOK_NUM_LONG
0[xX]{HEX_DIGIT}+[lL]	TOK_NUM_LONG

\"(\\.|[^"\r\n\\])*\"	TOK_NUM_STRING

{ID}	TOK_ID

%%
