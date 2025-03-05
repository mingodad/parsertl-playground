//From: https://github.com/esrrhs/fakego/blob/c8ea2e7d5c492cd88f3a1bcfd696e4d953c77e58/yacc.y

/*Tokens*/
%token AND
%token ARG_SPLITTER
%token ASSIGN
%token BREAK
%token CASE
%token CLOSE_BIG_BRACKET
%token CLOSE_BRACKET
%token CLOSE_SQUARE_BRACKET
%token COLON
%token CONTINUE
%token DEFAULT
%token DIVIDE
%token DIVIDE_ASSIGN
%token DIVIDE_MOD
%token DIVIDE_MOD_ASSIGN
%token ELSE
%token ELSEIF
%token END
%token EQUAL
%token FAKE
%token FCONST
%token FFALSE
%token FKFLOAT
%token FKUUID
%token FNULL
%token FOR
%token FTRUE
%token FUNC
%token IDENTIFIER
%token IDENTIFIER_DOT
%token IDENTIFIER_POINTER
%token IF
%token INC
%token INCLUDE
%token IS
%token LESS
%token LESS_OR_EQUAL
%token MINUS
%token MINUS_ASSIGN
%token MORE
%token MORE_OR_EQUAL
%token MULTIPLY
%token MULTIPLY_ASSIGN
%token NEW_ASSIGN
%token NOT
%token NOT_EQUAL
%token NUMBER
%token OPEN_BIG_BRACKET
%token OPEN_BRACKET
%token OPEN_SQUARE_BRACKET
%token OR
%token PACKAGE
%token PLUS
%token PLUS_ASSIGN
%token RETURN
%token RIGHT_POINTER
//%token SINGLE_LINE_COMMENT
//%token SLEEP
%token STRING_CAT
%token STRING_DEFINITION
%token STRUCT
%token SWITCH
%token THEN
%token VAR_BEGIN
%token WHILE
//%token YIELD

%left /*1*/ PLUS MINUS
%left /*2*/ DIVIDE_MOD DIVIDE MULTIPLY
%left /*3*/ STRING_CAT

%start program

%%

program :
	package_head include_head struct_head const_head body
	;

package_head :
	/*empty*/
	| PACKAGE IDENTIFIER
	| PACKAGE IDENTIFIER_DOT
	;

include_head :
	/*empty*/
	| include_define
	| include_head include_define
	;

include_define :
	INCLUDE STRING_DEFINITION
	;

struct_head :
	/*empty*/
	| struct_define
	| struct_head struct_define
	;

struct_define :
	STRUCT IDENTIFIER struct_mem_declaration END
	;

struct_mem_declaration :
	/*empty*/
	| struct_mem_declaration IDENTIFIER
	| IDENTIFIER
	;

const_head :
	/*empty*/
	| const_define
	| const_head const_define
	;

const_define :
	FCONST IDENTIFIER ASSIGN explicit_value
	;

body :
	/*empty*/
	| function_declaration
	| body function_declaration
	;

function_declaration :
	FUNC IDENTIFIER OPEN_BRACKET function_declaration_arguments CLOSE_BRACKET block END
	| FUNC IDENTIFIER OPEN_BRACKET function_declaration_arguments CLOSE_BRACKET END
	;

function_declaration_arguments :
	/*empty*/
	| function_declaration_arguments ARG_SPLITTER arg
	| arg
	;

arg :
	IDENTIFIER
	;

function_call :
	IDENTIFIER OPEN_BRACKET function_call_arguments CLOSE_BRACKET
	| IDENTIFIER_DOT OPEN_BRACKET function_call_arguments CLOSE_BRACKET
	| function_call OPEN_BRACKET function_call_arguments CLOSE_BRACKET
	| function_call COLON IDENTIFIER OPEN_BRACKET function_call_arguments CLOSE_BRACKET
	| variable COLON IDENTIFIER OPEN_BRACKET function_call_arguments CLOSE_BRACKET
	;

function_call_arguments :
	/*empty*/
	| function_call_arguments ARG_SPLITTER arg_expr
	| arg_expr
	;

arg_expr :
	expr_value
	;

block :
	block stmt
	| stmt
	;

stmt :
	while_stmt
	| if_stmt
	| return_stmt
	| assign_stmt
	| multi_assign_stmt
	| break
	| continue
	| expr
	| math_assign_stmt
	| for_stmt
	| for_loop_stmt
	| fake_call_stmt
	| switch_stmt
	;

fake_call_stmt :
	FAKE function_call
	;

for_stmt :
	FOR block ARG_SPLITTER cmp ARG_SPLITTER block THEN block END
	| FOR block ARG_SPLITTER cmp ARG_SPLITTER block THEN END
	;

for_loop_value :
	explicit_value
	| variable
	;

for_loop_stmt :
	FOR var ASSIGN for_loop_value RIGHT_POINTER for_loop_value ARG_SPLITTER for_loop_value THEN block END
	| FOR var ASSIGN for_loop_value RIGHT_POINTER for_loop_value ARG_SPLITTER for_loop_value THEN END
	;

while_stmt :
	WHILE cmp THEN block END
	| WHILE cmp THEN END
	;

if_stmt :
	IF cmp THEN block elseif_stmt_list else_stmt END
	| IF cmp THEN elseif_stmt_list else_stmt END
	;

elseif_stmt_list :
	/*empty*/
	| elseif_stmt_list elseif_stmt
	| elseif_stmt
	;

elseif_stmt :
	ELSEIF cmp THEN block
	| ELSEIF cmp THEN
	;

else_stmt :
	/*empty*/
	| ELSE block
	| ELSE
	;

cmp :
	OPEN_BRACKET cmp CLOSE_BRACKET
	| cmp AND cmp
	| cmp OR cmp
	| cmp_value LESS cmp_value
	| cmp_value MORE cmp_value
	| cmp_value EQUAL cmp_value
	| cmp_value MORE_OR_EQUAL cmp_value
	| cmp_value LESS_OR_EQUAL cmp_value
	| cmp_value NOT_EQUAL cmp_value
	| FTRUE
	| FFALSE
	| IS cmp_value
	| NOT cmp_value
	;

cmp_value :
	explicit_value
	| variable
	| expr
	;

return_stmt :
	RETURN return_value_list
	| RETURN
	;

return_value_list :
	return_value_list ARG_SPLITTER return_value
	| return_value
	;

return_value :
	explicit_value
	| variable
	| expr
	;

assign_stmt :
	var ASSIGN assign_value
	| var NEW_ASSIGN assign_value
	;

multi_assign_stmt :
	var_list ASSIGN function_call
	| var_list NEW_ASSIGN function_call
	;

var_list :
	var_list ARG_SPLITTER var
	| var
	;

assign_value :
	explicit_value
	| variable
	| expr
	;

math_assign_stmt :
	variable PLUS_ASSIGN assign_value
	| variable MINUS_ASSIGN assign_value
	| variable DIVIDE_ASSIGN assign_value
	| variable MULTIPLY_ASSIGN assign_value
	| variable DIVIDE_MOD_ASSIGN assign_value
	| variable INC
	;

var :
	VAR_BEGIN IDENTIFIER
	| variable
	;

variable :
	IDENTIFIER
	| IDENTIFIER OPEN_SQUARE_BRACKET expr_value CLOSE_SQUARE_BRACKET
	| IDENTIFIER_POINTER
	| IDENTIFIER_DOT
	;

expr :
	OPEN_BRACKET expr CLOSE_BRACKET
	| function_call
	| math_expr
	;

math_expr :
	OPEN_BRACKET math_expr CLOSE_BRACKET
	| expr_value PLUS /*1L*/ expr_value
	| expr_value MINUS /*1L*/ expr_value
	| expr_value MULTIPLY /*2L*/ expr_value
	| expr_value DIVIDE /*2L*/ expr_value
	| expr_value DIVIDE_MOD /*2L*/ expr_value
	| expr_value STRING_CAT /*3L*/ expr_value
	;

expr_value :
	math_expr
	| explicit_value
	| function_call
	| variable
	;

explicit_value :
	FTRUE
	| FFALSE
	| NUMBER
	| FKUUID
	| STRING_DEFINITION
	| FKFLOAT
	| FNULL
	| OPEN_BIG_BRACKET const_map_list_value CLOSE_BIG_BRACKET
	| OPEN_SQUARE_BRACKET const_array_list_value CLOSE_SQUARE_BRACKET
	;

const_map_list_value :
	/*empty*/
	| const_map_value
	| const_map_list_value const_map_value
	;

const_map_value :
	explicit_value COLON explicit_value
	;

const_array_list_value :
	/*empty*/
	| explicit_value
	| const_array_list_value explicit_value
	;

break :
	BREAK
	;

continue :
	CONTINUE
	;

switch_stmt :
	SWITCH cmp_value switch_case_list DEFAULT block END
	| SWITCH cmp_value switch_case_list DEFAULT END
	;

switch_case_list :
	switch_case_define
	| switch_case_list switch_case_define
	;

switch_case_define :
	CASE cmp_value THEN block
	| CASE cmp_value THEN
	;

%%

%%

[ \t\r\n]+	skip()
"--".*	skip()

"var" VAR_BEGIN
"return" RETURN
"break" BREAK
"func" FUNC
"fake" FAKE
"while" WHILE
"for" FOR
"true" FTRUE
"false" FFALSE
"if" IF
"then" THEN
"else" ELSE
"elseif" ELSEIF
"end" END
"const" FCONST
"package" PACKAGE
"null" FNULL
"include" INCLUDE
"struct" STRUCT
"and" AND
"or" OR
"is" IS
"not" NOT
"continue" CONTINUE
"switch" SWITCH
"case" CASE
"default" DEFAULT
"%" DIVIDE_MOD
"," ARG_SPLITTER
"->" RIGHT_POINTER
"++" INC
"+" PLUS
"-" MINUS
"/" DIVIDE
"*" MULTIPLY
":=" NEW_ASSIGN
"+=" PLUS_ASSIGN
"-=" MINUS_ASSIGN
"/=" DIVIDE_ASSIGN
"*=" MULTIPLY_ASSIGN
"%=" DIVIDE_MOD_ASSIGN
"=" ASSIGN
">" MORE
"<" LESS
">=" MORE_OR_EQUAL
"<=" LESS_OR_EQUAL
"==" EQUAL
"!=" NOT_EQUAL
"(" OPEN_BRACKET
")" CLOSE_BRACKET
":" COLON
"[" OPEN_SQUARE_BRACKET
"]" CLOSE_SQUARE_BRACKET
"{" OPEN_BIG_BRACKET
"}" CLOSE_BIG_BRACKET
".." STRING_CAT

\"(\\.|[^"\r\n\\])*\" STRING_DEFINITION
[0-9]+u FKUUID
"-"?[0-9]+ NUMBER
"-"?[0-9]+\.[0-9]+([Ee]-?[0-9]+)? FKFLOAT

[a-zA-Z_][a-zA-Z0-9_]* IDENTIFIER
[a-zA-Z_][a-zA-Z0-9_]*(\.[a-zA-Z_][a-zA-Z0-9_]*)+ IDENTIFIER_DOT
[a-zA-Z_][a-zA-Z0-9_]*(\-\>[a-zA-Z_][a-zA-Z0-9_]*)+ IDENTIFIER_POINTER

%%
