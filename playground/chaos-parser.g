//From: https://github.com/chaos-lang/chaos/blob/61a43370d99b3caeff233d4fef7542b127088fdc/parser/parser.y
/*
 * Description: Parser of the Chaos Programming Language's source
 *
 * Copyright (c) 2019-2021 Chaos Language Development Authority <info@chaos-lang.org>
 *
 * License: GNU General Public License v3.0
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>
 *
 * Authors: M. Mert Yildiran <me@mertyildiran.com>
 *          Melih Sahin <melihsahin24@gmail.com>
 */

/*Tokens*/
//%token START_PROGRAM
//%token START_PREPARSE
//%token START_JSON_PARSE
%token T_TRUE
%token T_FALSE
%token T_INT
//%token T_TIMES_DO_INT
%token T_FLOAT
%token T_STRING
%token T_VAR
//%token T_UNSIGNED_LONG_LONG_INT
%token T_ADD
%token T_SUB
%token T_MUL
%token T_QUO
%token T_REM
%token T_LPAREN
%token T_RPAREN
%token T_ASSIGN
%token T_LBRACK
%token T_RBRACK
%token T_LBRACE
%token T_RBRACE
%token T_COMMA
%token T_PERIOD
%token T_DOTDOT
%token T_COLON
%token T_ARROW
%token T_NEWLINE
%token T_EXIT
%token T_PRINT
%token T_ECHO
%token T_PRETTY
%token T_VAR_BOOL
%token T_VAR_NUMBER
%token T_VAR_STRING
%token T_VAR_LIST
%token T_VAR_DICT
%token T_VAR_ANY
//%token T_NULL
%token T_DEL
%token T_RETURN
%token T_VOID
%token T_DEFAULT
%token T_BREAK
//%token T_SYMBOL_TABLE
%token T_FUNCTION_TABLE
%token T_TIMES_DO
%token T_FOREACH
%token T_AS
%token T_END
%token T_DEF
%token T_IMPORT
%token T_FROM
%token T_BACKSLASH
//%token T_INFINITE
%token T_EQL
%token T_NEQ
%token T_GTR
%token T_LSS
%token T_GEQ
%token T_LEQ
%token T_LAND
%token T_LOR
%token T_NOT
%token T_AND
%token T_OR
%token T_XOR
%token T_TILDE
%token T_SHL
%token T_SHR
%token T_INC
%token T_DEC
%token T_U_ADD
%token T_U_SUB
%token T_U_NOT
%token T_U_TILDE

%left T_OR
%left T_AND
%left T_EQL T_NEQ
%left T_GTR T_LSS T_GEQ T_LEQ
%left T_LAND T_LOR
%left T_XOR T_SHL T_SHR
%left /*1*/ T_VAR T_ADD T_SUB T_NOT T_TILDE
%left /*2*/ T_MUL T_QUO T_REM
%left T_INC T_DEC T_LBRACK
%right /*3*/ T_U_ADD T_U_SUB T_U_NOT T_U_TILDE

//%start meta_start

%%

//meta_start :
//	/*empty*/
//	| START_PROGRAM parser
//	;

parser :
	/*empty*/
	| parser line
	;

line :
	T_NEWLINE
	| import
	| stmt
	;

expr :
	ident
	| basic_lit
	| binary_expr
	| unary_expr
	| paren_expr
	| incdec_expr
	| index_expr
	| composite_lit
	| call_expr
	;

ident :
	T_VAR /*1L*/
	;

basic_lit :
	T_TRUE
	| T_FALSE
	| T_INT
	| T_FLOAT
	| T_STRING
	;

binary_expr :
	expr T_ADD /*1L*/ expr
	| expr T_SUB /*1L*/ expr
	| expr T_MUL /*2L*/ expr
	| expr T_QUO /*2L*/ expr
	| expr T_REM expr
	| expr T_AND expr
	| expr T_OR expr
	| expr T_XOR expr
	| expr T_SHL expr
	| expr T_SHR expr
	| bool_expr
	;

bool_expr :
	expr T_EQL expr
	| expr T_NEQ expr
	| expr T_GTR expr
	| expr T_LSS expr
	| expr T_GEQ expr
	| expr T_LEQ expr
	| expr T_LAND expr
	| expr T_LOR expr
	;

unary_expr :
	T_ADD /*1L*/ expr %prec T_U_ADD /*3R*/
	| T_SUB /*1L*/ expr %prec T_U_SUB /*3R*/
	| T_NOT /*1L*/ expr %prec T_U_NOT /*3R*/
	| T_TILDE /*1L*/ expr %prec T_U_TILDE /*3R*/
	;

paren_expr :
	T_LPAREN expr T_RPAREN
	;

incdec_expr :
	T_INC expr
	| expr T_INC
	| T_DEC expr
	| expr T_DEC
	;

alias_expr :
	ident
	| ident T_AS ident
	;

alias_expr_list :
	alias_expr
	| alias_expr T_COMMA alias_expr_list
	;

index_expr :
	expr T_LBRACK expr T_RBRACK
	;

expr_list :
	expr
	| expr T_COMMA expr_list
	| expr T_COMMA T_NEWLINE expr_list
	;

key_value_expr :
	basic_lit T_COLON expr
	;

key_value_list :
	key_value_expr
	| key_value_expr T_COMMA key_value_list
	| key_value_expr T_COMMA T_NEWLINE key_value_list
	;

composite_lit :
	T_LBRACK T_RBRACK
	| T_LBRACK expr_list T_RBRACK
	| T_LBRACK T_NEWLINE expr_list T_RBRACK
	| T_LBRACK expr_list T_NEWLINE T_RBRACK
	| T_LBRACK T_NEWLINE expr_list T_NEWLINE T_RBRACK
	| T_LBRACE T_RBRACE
	| T_LBRACE key_value_list T_RBRACE
	| T_LBRACE T_NEWLINE key_value_list T_RBRACE
	| T_LBRACE key_value_list T_NEWLINE T_RBRACE
	| T_LBRACE T_NEWLINE key_value_list T_NEWLINE T_RBRACE
	;

selector_expr :
	ident T_PERIOD ident
	| selector_expr T_PERIOD ident
	;

call_expr :
	ident T_LPAREN T_RPAREN
	| ident T_LPAREN expr_list T_RPAREN
	| selector_expr T_LPAREN T_RPAREN
	| selector_expr T_LPAREN expr_list T_RPAREN
	;

decision_expr :
	bool_expr T_COLON call_expr
	| bool_expr T_COLON return_stmt
	| bool_expr T_COLON break_stmt
	;

default_expr :
	T_DEFAULT T_COLON call_expr
	| T_DEFAULT T_COLON return_stmt
	| T_DEFAULT T_COLON break_stmt
	;

decision_expr_list :
	decision_expr
	| default_expr
	| decision_expr T_COMMA decision_expr_list
	| decision_expr T_COMMA T_NEWLINE decision_expr_list
	;

stmt :
	assign_stmt T_NEWLINE
	| return_stmt T_NEWLINE
	| print_stmt T_NEWLINE
	| echo_stmt T_NEWLINE
	| expr_stmt T_NEWLINE
	| decl_stmt T_NEWLINE
	| del_stmt T_NEWLINE
	| exit_stmt T_NEWLINE
	| function_table_stmt T_NEWLINE
	;

stmt_list :
	stmt
	//| /*empty*/
	| stmt stmt_list
	| T_NEWLINE stmt_list
	;

assign_stmt :
	expr T_ASSIGN expr
	;

return_stmt :
	T_RETURN expr
	;

print_stmt :
	T_PRINT expr
	| pretty_spec T_PRINT expr
	;

echo_stmt :
	T_ECHO expr
	| pretty_spec T_ECHO expr
	;

expr_stmt :
	expr
	;

decl_stmt :
	var_decl
	| times_do_decl
	| foreach_as_list_decl
	| foreach_as_dict_decl
	| func_decl
	;

del_stmt :
	T_DEL ident
	| T_DEL index_expr
	;

exit_stmt :
	T_EXIT
	| T_EXIT expr
	;

function_table_stmt :
	T_FUNCTION_TABLE
	;

block_stmt :
	stmt_list T_END
	;

break_stmt :
	T_BREAK
	;

type_spec :
	T_VOID
	| T_VAR_BOOL
	| T_VAR_NUMBER
	| T_VAR_STRING
	| T_VAR_ANY
	| T_VAR_LIST
	| T_VAR_DICT
	| T_VOID sub_type_spec
	| T_VAR_BOOL sub_type_spec
	| T_VAR_NUMBER sub_type_spec
	| T_VAR_STRING sub_type_spec
	| T_VAR_ANY sub_type_spec
	;

sub_type_spec :
	T_VAR_LIST
	| T_VAR_DICT
	| T_VAR_LIST sub_type_spec
	| T_VAR_DICT sub_type_spec
	;

pretty_spec :
	T_PRETTY
	;

var_decl :
	type_spec ident T_ASSIGN expr
	;

func_decl :
	func_type block_stmt
	| func_type block_stmt decision_block
	;

times_do_decl :
	expr T_TIMES_DO T_ARROW call_expr
	| expr T_TIMES_DO ident T_ARROW call_expr
	| expr T_TIMES_DO T_AS ident T_ARROW call_expr
	;

foreach_as_list_decl :
	T_FOREACH expr T_AS ident T_ARROW call_expr
	| T_FOREACH expr T_AS ident T_COMMA ident T_ARROW call_expr
	;

foreach_as_dict_decl :
	T_FOREACH expr T_AS ident T_COLON ident T_ARROW call_expr
	| T_FOREACH expr T_AS ident T_COMMA ident T_COLON ident T_ARROW call_expr
	;

import :
	T_IMPORT module_selector
	| T_IMPORT module_selector T_AS ident
	| T_FROM module_selector T_IMPORT asterisk_spec
	| T_FROM module_selector T_IMPORT alias_expr_list
	;

module_selector :
	ident
	| ident T_PERIOD module_selector
	| ident T_QUO /*2L*/ module_selector
	| ident T_BACKSLASH module_selector
	| parent_dir_spec
	| parent_dir_spec T_PERIOD module_selector
	| parent_dir_spec T_QUO /*2L*/ module_selector
	| parent_dir_spec T_BACKSLASH module_selector
	| parent_dir_spec module_selector
	;

parent_dir_spec :
	T_DOTDOT
	;

asterisk_spec :
	T_MUL /*2L*/
	;

field_spec :
	type_spec ident
	;

optional_field_spec :
	type_spec ident T_ASSIGN expr
	;

field_list_spec :
	field_spec
	| field_spec T_COMMA field_list_spec
	| field_spec T_COMMA T_NEWLINE field_list_spec
	| field_spec T_COMMA optional_field_list_spec
	| field_spec T_COMMA T_NEWLINE optional_field_list_spec
	;

optional_field_list_spec :
	optional_field_spec
	| optional_field_spec T_COMMA optional_field_list_spec
	| optional_field_spec T_COMMA T_NEWLINE optional_field_list_spec
	;

func_type :
	type_spec T_DEF ident T_LPAREN T_RPAREN T_NEWLINE
	| type_spec T_DEF ident T_LPAREN field_list_spec T_RPAREN T_NEWLINE
	;

decision_block :
	T_LBRACE decision_expr_list T_RBRACE
	| T_LBRACE T_NEWLINE decision_expr_list T_RBRACE
	| T_LBRACE decision_expr_list T_NEWLINE T_RBRACE
	| T_LBRACE T_NEWLINE decision_expr_list T_NEWLINE T_RBRACE
	;

%%

%%

"//".*                      skip()
"#".*                      skip()
"/*"(?s:.)*?"*/"	skip()
[ \t]                           skip() // ignore all whitespace
\n                              T_NEWLINE
"="                             T_ASSIGN
"+"                             T_ADD
"-"                             T_SUB
"*"                             T_MUL
"/"                             T_QUO
"%"                             T_REM
"\\"                            T_BACKSLASH
"("                             T_LPAREN
")"                             T_RPAREN
"["                             T_LBRACK
"]"                             T_RBRACK
"{"                             T_LBRACE
"}"                             T_RBRACE
","                             T_COMMA
"."                             T_PERIOD
".."                            T_DOTDOT
"=="                            T_EQL
"!="                            T_NEQ
">"                             T_GTR
"<"                             T_LSS
">="                            T_GEQ
"<="                            T_LEQ
\&\&|and                        T_LAND
\|\||or                         T_LOR
\!|not                          T_NOT
"&"                             T_AND
"|"                             T_OR
"^"                             T_XOR
"~"                             T_TILDE
"<<"                            T_SHL
">>"                            T_SHR
"++"                            T_INC
"--"                            T_DEC
":"                             T_COLON
"->"                            T_ARROW
"exit"                          T_EXIT
"quit"                          T_EXIT
"print"                         T_PRINT
"echo"                          T_ECHO
"pretty"                        T_PRETTY
"true"                          T_TRUE
"false"                         T_FALSE
"function_table"                T_FUNCTION_TABLE
"del"                           T_DEL
"return"                        T_RETURN
"default"                       T_DEFAULT

"times"[ \t]+"do"               T_TIMES_DO
"end"                           T_END
"foreach"                       T_FOREACH
"as"                            T_AS
"from"                          T_FROM
//"INFINITE"                      T_INFINITE


\"(\$\{.*\}|\\.|[^\"\\])*\" T_STRING

\'(\$\{.*\}|\\.|[^\'\\])*\' T_STRING

"bool"                          T_VAR_BOOL
"num"                           T_VAR_NUMBER
"str"                           T_VAR_STRING
"list"                          T_VAR_LIST
"dict"                          T_VAR_DICT
"any"                           T_VAR_ANY
//"null"                          T_NULL
"void"                          T_VOID
"def"                           T_DEF
"import"                        T_IMPORT
"break"                         T_BREAK

[0-9]+\.[0-9]+                  T_FLOAT
[0-9]+                          T_INT

[a-zA-Z_][a-zA-Z0-9_]*          T_VAR


%%
