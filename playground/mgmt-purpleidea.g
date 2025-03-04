//From: https://github.com/purpleidea/mgmt/blob/a64e3ee179282fceb85d1c0e89afd03cac785a67/lang/parser/parser.y
// Mgmt
// Copyright (C) James Shubin and the project contributors
// Written by James Shubin <james@shubin.ca> and the project contributors
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
// Additional permission under GNU GPL version 3 section 7
//
// If you modify this program, or any covered work, by linking or combining it
// with embedded mcl code and modules (and that the embedded mcl code and
// modules which link with this program, contain a copy of their source code in
// the authoritative form) containing parts covered by the terms of any other
// license, the licensors of this program grant you additional permission to
// convey the resulting work. Furthermore, the licensors of this program grant
// the original author, James Shubin, additional permission to update this
// additional permission if he deems it necessary to achieve the goals of this
// additional permission.

/*Tokens*/
%token OPEN_CURLY
%token CLOSE_CURLY
%token OPEN_PAREN
%token CLOSE_PAREN
%token OPEN_BRACK
%token CLOSE_BRACK
%token IF
%token ELSE
%token BOOL
%token STRING
%token INTEGER
%token FLOAT
%token EQUALS
%token DOLLAR
%token COMMA
%token COLON
%token SEMICOLON
%token ELVIS
%token DEFAULT
%token ROCKET
%token ARROW
%token DOT
%token BOOL_IDENTIFIER
%token STR_IDENTIFIER
%token INT_IDENTIFIER
%token FLOAT_IDENTIFIER
%token MAP_IDENTIFIER
%token STRUCT_IDENTIFIER
%token VARIANT_IDENTIFIER
%token IDENTIFIER
%token CAPITALIZED_IDENTIFIER
%token FUNC_IDENTIFIER
%token CLASS_IDENTIFIER
%token INCLUDE_IDENTIFIER
%token IMPORT_IDENTIFIER
%token AS_IDENTIFIER
//%token COMMENT
//%token ERROR
%token PANIC_IDENTIFIER
%token AND
%token OR
%token LT
%token GT
%token LTE
%token GTE
%token EQ
%token NEQ
%token PLUS
%token MINUS
%token MULTIPLY
%token DIVIDE
%token NOT
%token IN

%left /*1*/ AND OR
%nonassoc /*2*/ LT GT LTE GTE EQ NEQ
%left /*3*/ PLUS MINUS
%left /*4*/ MULTIPLY DIVIDE
%right /*5*/ NOT
%nonassoc /*6*/ ARROW
%nonassoc /*7*/ DEFAULT
%nonassoc /*8*/ OPEN_BRACK
%nonassoc /*9*/ IN


%%

prog :
	/*empty*/
	| prog stmt
	;

stmt :
	/*COMMENT
	|*/ bind
	| panic
	| resource
	| edge
	| IF expr OPEN_CURLY prog CLOSE_CURLY
	| IF expr OPEN_CURLY prog CLOSE_CURLY ELSE OPEN_CURLY prog CLOSE_CURLY
	| FUNC_IDENTIFIER IDENTIFIER OPEN_PAREN args CLOSE_PAREN OPEN_CURLY expr CLOSE_CURLY
	| FUNC_IDENTIFIER IDENTIFIER OPEN_PAREN args CLOSE_PAREN type OPEN_CURLY expr CLOSE_CURLY
	| CLASS_IDENTIFIER colon_identifier OPEN_CURLY prog CLOSE_CURLY
	| CLASS_IDENTIFIER colon_identifier OPEN_PAREN args CLOSE_PAREN OPEN_CURLY prog CLOSE_CURLY
	| INCLUDE_IDENTIFIER dotted_identifier
	| INCLUDE_IDENTIFIER dotted_identifier OPEN_PAREN call_args CLOSE_PAREN
	| INCLUDE_IDENTIFIER dotted_identifier AS_IDENTIFIER IDENTIFIER
	| INCLUDE_IDENTIFIER dotted_identifier OPEN_PAREN call_args CLOSE_PAREN AS_IDENTIFIER IDENTIFIER
	| IMPORT_IDENTIFIER STRING
	| IMPORT_IDENTIFIER STRING AS_IDENTIFIER IDENTIFIER
	| IMPORT_IDENTIFIER STRING AS_IDENTIFIER MULTIPLY /*4L*/
	;

expr :
	BOOL
	| STRING
	| INTEGER
	| FLOAT
	| list
	| map
	| struct
	| call
	| var
	| func
	| IF expr OPEN_CURLY expr CLOSE_CURLY ELSE OPEN_CURLY expr CLOSE_CURLY
	| OPEN_PAREN expr CLOSE_PAREN
	;

list :
	OPEN_BRACK /*8N*/ list_elements CLOSE_BRACK
	;

list_elements :
	/*empty*/
	| list_elements list_element
	;

list_element :
	expr COMMA
	;

map :
	OPEN_CURLY map_kvs CLOSE_CURLY
	;

map_kvs :
	/*empty*/
	| map_kvs map_kv
	;

map_kv :
	expr ROCKET expr COMMA
	;

struct :
	STRUCT_IDENTIFIER OPEN_CURLY struct_fields CLOSE_CURLY
	;

struct_fields :
	/*empty*/
	| struct_fields struct_field
	;

struct_field :
	IDENTIFIER ROCKET expr COMMA
	;

call :
	dotted_identifier OPEN_PAREN call_args CLOSE_PAREN
	| dotted_var_identifier OPEN_PAREN call_args CLOSE_PAREN
	| func OPEN_PAREN call_args CLOSE_PAREN
	| expr PLUS /*3L*/ expr
	| expr MINUS /*3L*/ expr
	| expr MULTIPLY /*4L*/ expr
	| expr DIVIDE /*4L*/ expr
	| expr EQ /*2N*/ expr
	| expr NEQ /*2N*/ expr
	| expr LT /*2N*/ expr
	| expr GT /*2N*/ expr
	| expr LTE /*2N*/ expr
	| expr GTE /*2N*/ expr
	| expr AND /*1L*/ expr
	| expr OR /*1L*/ expr
	| NOT /*5R*/ expr
	| expr OPEN_BRACK /*8N*/ expr CLOSE_BRACK
	| expr OPEN_BRACK /*8N*/ expr CLOSE_BRACK DEFAULT /*7N*/ expr
	| expr ARROW /*6N*/ IDENTIFIER
	| expr ARROW /*6N*/ IDENTIFIER DEFAULT /*7N*/ expr
	| expr IN /*9N*/ expr
	;

call_args :
	/*empty*/
	| call_args COMMA expr
	| expr
	;

var :
	dotted_var_identifier
	;

func :
	FUNC_IDENTIFIER OPEN_PAREN args CLOSE_PAREN OPEN_CURLY expr CLOSE_CURLY
	| FUNC_IDENTIFIER OPEN_PAREN args CLOSE_PAREN type OPEN_CURLY expr CLOSE_CURLY
	;

args :
	/*empty*/
	| args COMMA arg
	| arg
	;

arg :
	var_identifier
	| var_identifier type
	;

bind :
	var_identifier EQUALS expr
	| var_identifier type EQUALS expr
	;

panic :
	PANIC_IDENTIFIER OPEN_PAREN call_args CLOSE_PAREN
	;

resource :
	colon_identifier expr OPEN_CURLY resource_body CLOSE_CURLY
	;

resource_body :
	/*empty*/
	| resource_body resource_field
	| resource_body conditional_resource_field
	| resource_body resource_edge
	| resource_body conditional_resource_edge
	| resource_body resource_meta
	| resource_body conditional_resource_meta
	| resource_body resource_meta_struct
	| resource_body conditional_resource_meta_struct
	;

resource_field :
	IDENTIFIER ROCKET expr COMMA
	;

conditional_resource_field :
	IDENTIFIER ROCKET expr ELVIS expr COMMA
	;

resource_edge :
	CAPITALIZED_IDENTIFIER ROCKET edge_half COMMA
	;

conditional_resource_edge :
	CAPITALIZED_IDENTIFIER ROCKET expr ELVIS edge_half COMMA
	;

resource_meta :
	CAPITALIZED_IDENTIFIER COLON IDENTIFIER ROCKET expr COMMA
	;

conditional_resource_meta :
	CAPITALIZED_IDENTIFIER COLON IDENTIFIER ROCKET expr ELVIS expr COMMA
	;

resource_meta_struct :
	CAPITALIZED_IDENTIFIER ROCKET expr COMMA
	;

conditional_resource_meta_struct :
	CAPITALIZED_IDENTIFIER ROCKET expr ELVIS expr COMMA
	;

edge :
	edge_half_list
	| edge_half_sendrecv ARROW /*6N*/ edge_half_sendrecv
	;

edge_half_list :
	edge_half
	| edge_half_list ARROW /*6N*/ edge_half
	;

edge_half :
	capitalized_res_identifier OPEN_BRACK /*8N*/ expr CLOSE_BRACK
	;

edge_half_sendrecv :
	capitalized_res_identifier OPEN_BRACK /*8N*/ expr CLOSE_BRACK DOT IDENTIFIER
	;

type :
	BOOL_IDENTIFIER
	| STR_IDENTIFIER
	| INT_IDENTIFIER
	| FLOAT_IDENTIFIER
	| OPEN_BRACK /*8N*/ CLOSE_BRACK type
	| MAP_IDENTIFIER OPEN_CURLY type COLON type CLOSE_CURLY
	| STRUCT_IDENTIFIER OPEN_CURLY type_struct_fields CLOSE_CURLY
	| FUNC_IDENTIFIER OPEN_PAREN type_func_args CLOSE_PAREN type
	| VARIANT_IDENTIFIER
	;

type_struct_fields :
	/*empty*/
	| type_struct_fields SEMICOLON type_struct_field
	| type_struct_field
	;

type_struct_field :
	IDENTIFIER type
	;

type_func_args :
	/*empty*/
	| type_func_args COMMA type_func_arg
	| type_func_arg
	;

type_func_arg :
	type
	| var_identifier type
	;

undotted_identifier :
	IDENTIFIER
	| MAP_IDENTIFIER
	;

var_identifier :
	DOLLAR undotted_identifier
	;

colon_identifier :
	IDENTIFIER
	| colon_identifier COLON IDENTIFIER
	;

dotted_identifier :
	undotted_identifier
	| dotted_identifier DOT undotted_identifier
	;

dotted_var_identifier :
	DOLLAR dotted_identifier
	;

capitalized_res_identifier :
	CAPITALIZED_IDENTIFIER
	| capitalized_res_identifier COLON CAPITALIZED_IDENTIFIER
	;

%%

%%

[ \t\r\n]+	skip()
"#".*	skip() //COMMENT

"and"	AND
"->"	ARROW
"as"	AS_IDENTIFIER
"true"|"false"	BOOL
"bool"	BOOL_IDENTIFIER
"class"	CLASS_IDENTIFIER
"]"	CLOSE_BRACK
"}"	CLOSE_CURLY
")"	CLOSE_PAREN
":"	COLON
","	COMMA
"||"	DEFAULT
"/"	DIVIDE
"$"	DOLLAR
"."	DOT
"else"	ELSE
"?:"	ELVIS
"=="	EQ
"="	EQUALS
//ERROR	ERROR
"float"	FLOAT_IDENTIFIER
"func"	FUNC_IDENTIFIER
">"	GT
">="	GTE
"if"	IF
"import"	IMPORT_IDENTIFIER
"in"	IN
"include"	INCLUDE_IDENTIFIER
"int"	INT_IDENTIFIER
"<"	LT
"<="	LTE
"map"	MAP_IDENTIFIER
"-"	MINUS
"*"	MULTIPLY
"!="	NEQ
"not"	NOT
"["	OPEN_BRACK
"{"	OPEN_CURLY
"("	OPEN_PAREN
"or"	OR
"panic"	PANIC_IDENTIFIER
"+"	PLUS
"=>"	ROCKET
";"	SEMICOLON
"struct"	STRUCT_IDENTIFIER
"str"	STR_IDENTIFIER
"variant"	VARIANT_IDENTIFIER

\"(\\.|[^"\r\n\\])*\"	STRING

[0-9]+"."[0-9]+	FLOAT
[0-9]+	INTEGER

[A-Z][a-z0-9_]*	CAPITALIZED_IDENTIFIER
[a-z][A-Za-z0-9_]*	IDENTIFIER

%%
