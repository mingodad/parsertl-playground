//From: https://github.com/austral/austral/blob/master/lib/Parser.mly
/*
   Part of the Austral project, under the Apache License v2.0 with LLVM Exceptions.
   See LICENSE file for details.

   SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
*/

/*
Changes:
- Replaced right recursion by left recursion
- Created a start rule to detect module interface/body and parse both for use in the playground
*/

/* Brackets */
%token LPAREN
%token RPAREN
%token LBRACKET
%token RBRACKET
%token LCURLY
%token RCURLY
/* Arithmetic operators */
%token PLUS
%token MINUS
%token MUL
%token DIV
/* Comparison operators */
%token EQ
%token NEQ
%token LT
%token LTE
%token GT
%token GTE
/* Logical operators */
%token AND
%token OR
%token NOT
/* Borrowing */
%token BORROW_WRITE
%token BORROW_READ
%token SPAN_READ
%token SPAN_WRITE
%token REBORROW
%token REF_TRANSFORM
/* Keywords */
%token MODULE
%token IS
%token BODY
%token IMPORT
%token AS
%token END
%token CONSTANT
%token TYPE
%token FUNCTION
%token GENERIC
%token RECORD
%token UNION
%token CASE
%token OF
%token WHEN
%token TYPECLASS
%token INSTANCE
%token METHOD
%token IF
%token THEN
%token ELSE
%token ELSE_IF
%token LET
%token VAR
%token WHILE
%token FOR
%token DO
%token FROM
%token TO
%token BORROW
%token RETURN
%token SKIP
%token UNIVERSE_FREE
%token UNIVERSE_LINEAR
%token UNIVERSE_TYPE
%token UNIVERSE_REGION
%token PRAGMA
%token SIZEOF
/* Symbols */
%token SEMI
%token COMMA
%token PERIOD
%token COLON
%token HYPHEN_RIGHT
%token RIGHT_ARROW
%token ASSIGN
%token DEREF
/* Strings and docstrings */
%token  STRING_CONSTANT
%token  TRIPLE_STRING_CONSTANT
/* Identifiers and constants */
%token NIL
%token TRUE
%token FALSE
%token  DEC_CONSTANT
%token  HEX_CONSTANT
%token  BIN_CONSTANT
%token  OCT_CONSTANT
%token  CHAR_CONSTANT
%token  FLOAT_CONSTANT
%token  IDENTIFIER
/* Specials */
%token EMBED
/* etc. */
//%token EOF

%start austral
//%start module_int
//%start module_body
//%start standalone_interface_decl
//%start standalone_statement
//%start standalone_expression
//%start standalone_identifier


%%

austral :
	docstringopt list_import_stmt_ MODULE module_name IS module_int_decl
	| docstringopt list_import_stmt_ MODULE BODY module_name IS module_body_decl
	| docstringopt module_list_pragma_ list_import_stmt_ MODULE BODY module_name IS module_body_decl
	;

module_int_decl :
	list_interface_decl_ END MODULE PERIOD //EOF
	;

module_body_decl :
	list_body_decl_ END MODULE BODY PERIOD //EOF
	;

module_list_pragma_ :
	pragma
	| module_list_pragma_ pragma
	;

option_block_ :
	/*empty*/
	| block
	;

option_docstring_ :
	/*empty*/
	| docstring
	;

option_generic_segment_inner_ :
	/*empty*/
	| generic_segment_inner
	;

option_type_parameter_list_inner_ :
	/*empty*/
	| type_parameter_list_inner
	;

loption_separated_nonempty_list_COMMA_binding__ :
	/*empty*/
	| separated_nonempty_list_COMMA_binding_
	;

loption_separated_nonempty_list_COMMA_expression__ :
	/*empty*/
	| separated_nonempty_list_COMMA_expression_
	;

loption_separated_nonempty_list_COMMA_identifier__ :
	/*empty*/
	| separated_nonempty_list_COMMA_identifier_
	;

loption_separated_nonempty_list_COMMA_imported_symbol__ :
	/*empty*/
	| separated_nonempty_list_COMMA_imported_symbol_
	;

loption_separated_nonempty_list_COMMA_parameter__ :
	/*empty*/
	| separated_nonempty_list_COMMA_parameter_
	;

loption_separated_nonempty_list_COMMA_type_parameter__ :
	/*empty*/
	| separated_nonempty_list_COMMA_type_parameter_
	;

loption_separated_nonempty_list_COMMA_typespec__ :
	/*empty*/
	| separated_nonempty_list_COMMA_typespec_
	;

list_body_decl_ :
	/*empty*/
	| list_body_decl_ body_decl
	;

list_case_ :
	/*empty*/
	| list_case_ case
	;

list_import_stmt_ :
	/*empty*/
	| list_import_stmt_ import_stmt
	;

list_interface_decl_ :
	/*empty*/
	| list_interface_decl_ interface_decl
	;

list_method_decl_ :
	/*empty*/
	| list_method_decl_ method_decl
	;

list_method_def_ :
	/*empty*/
	| list_method_def_ method_def
	;

list_path_rest_ :
	/*empty*/
	| list_path_rest_ path_rest
	;

list_pragma_ :
	/*empty*/
	| list_pragma_ pragma
	;

list_slot_ :
	/*empty*/
	| list_slot_ slot
	;

list_when_stmt_ :
	/*empty*/
	| list_when_stmt_ when_stmt
	;

nonempty_list_path_rest_ :
	path_rest
	| nonempty_list_path_rest_ path_rest
	;

separated_nonempty_list_COMMA_binding_ :
	binding
	| separated_nonempty_list_COMMA_binding_ COMMA binding
	;

separated_nonempty_list_COMMA_expression_ :
	expression
	| separated_nonempty_list_COMMA_expression_ COMMA expression
	;

separated_nonempty_list_COMMA_identifier_ :
	identifier
	| separated_nonempty_list_COMMA_identifier_ COMMA identifier
	;

separated_nonempty_list_COMMA_imported_symbol_ :
	imported_symbol
	| separated_nonempty_list_COMMA_imported_symbol_ COMMA imported_symbol
	;

separated_nonempty_list_COMMA_named_arg_ :
	named_arg
	| separated_nonempty_list_COMMA_named_arg_ COMMA named_arg
	;

separated_nonempty_list_COMMA_parameter_ :
	parameter
	| separated_nonempty_list_COMMA_parameter_ COMMA parameter
	;

separated_nonempty_list_COMMA_type_parameter_ :
	type_parameter
	| separated_nonempty_list_COMMA_type_parameter_ COMMA type_parameter
	;

separated_nonempty_list_COMMA_typespec_ :
	typespec
	| separated_nonempty_list_COMMA_typespec_ COMMA typespec
	;

//standalone_interface_decl :
//	interface_decl EOF
//	;

//standalone_statement :
//	statement EOF
//	;

//standalone_expression :
//	expression EOF
//	;

//standalone_identifier :
//	identifier EOF
//	;

//module_int :
//	docstringopt list_import_stmt_ MODULE module_name IS list_interface_decl_ END MODULE PERIOD //EOF
//	;

//module_body :
//	docstringopt list_pragma_ list_import_stmt_ MODULE BODY module_name IS list_body_decl_ END MODULE BODY PERIOD //EOF
//	;

import_stmt :
	IMPORT module_name LPAREN loption_separated_nonempty_list_COMMA_imported_symbol__ RPAREN SEMI
	;

imported_symbol :
	identifier
	| identifier AS identifier
	;

interface_decl :
	docstringopt list_pragma_ interface_decl_inner
	;

interface_decl_inner :
	constant_decl
	| type_decl
	| record
	| union
	| function_decl
	| typeclass
	| instance_decl
	;

constant_decl :
	CONSTANT identifier COLON typespec SEMI
	;

type_decl :
	TYPE identifier type_parameter_list COLON universe SEMI
	;

record :
	RECORD identifier type_parameter_list COLON universe IS list_slot_ END SEMI
	;

slot :
	docstringopt identifier COLON typespec SEMI
	;

union :
	UNION identifier type_parameter_list COLON universe IS list_case_ END SEMI
	;

case :
	docstringopt CASE identifier SEMI
	| docstringopt CASE identifier IS list_slot_
	;

function_decl :
	generic_segment FUNCTION identifier LPAREN parameter_list RPAREN COLON typespec SEMI
	;

generic_segment :
	option_generic_segment_inner_
	;

generic_segment_inner :
	GENERIC type_parameter_list
	;

typeclass :
	TYPECLASS identifier LPAREN type_parameter RPAREN IS list_method_decl_ END SEMI
	;

method_decl :
	docstringopt generic_segment METHOD identifier LPAREN parameter_list RPAREN COLON typespec SEMI
	;

instance_decl :
	generic_segment INSTANCE identifier LPAREN typespec RPAREN SEMI
	;

body_decl :
	docstringopt list_pragma_ body_decl_inner
	;

body_decl_inner :
	constant_def
	| record
	| union
	| function_def
	| typeclass
	| instance_def
	;

constant_def :
	CONSTANT identifier COLON typespec ASSIGN expression SEMI
	;

function_def :
	generic_segment FUNCTION identifier LPAREN parameter_list RPAREN COLON typespec IS option_block_ END SEMI
	;

pragma :
	PRAGMA identifier SEMI
	| PRAGMA identifier argument_list SEMI
	;

instance_def :
	generic_segment INSTANCE identifier LPAREN typespec RPAREN IS list_method_def_ END SEMI
	;

method_def :
	docstringopt generic_segment METHOD identifier LPAREN parameter_list RPAREN COLON typespec IS block END SEMI
	;

statement :
	if_statement
	| let_stmt
	| lvalue ASSIGN expression SEMI
	| expression SEMI
	| CASE expression OF list_when_stmt_ END CASE SEMI
	| WHILE expression DO block END WHILE SEMI
	| FOR identifier FROM expression TO expression DO block END FOR SEMI
	| borrow_stmt
	| RETURN expression SEMI
	| SKIP SEMI
	;

if_statement :
	IF expression THEN block else_clause
	;

else_clause :
	ELSE_IF expression THEN block else_clause
	| ELSE block END IF SEMI
	| END IF SEMI
	;

let_stmt :
	let_destructure
	| let_simple
	;

let_simple :
	var_mutability identifier COLON typespec ASSIGN expression SEMI
	;

let_destructure :
	var_mutability LCURLY binding_list RCURLY ASSIGN expression SEMI
	;

binding_list :
	loption_separated_nonempty_list_COMMA_binding__
	;

binding :
	identifier COLON typespec
	| identifier AS identifier COLON typespec
	;

var_mutability :
	LET
	| VAR
	;

lvalue :
	identifier list_path_rest_
	;

when_stmt :
	WHEN identifier LPAREN binding_list RPAREN DO block
	| WHEN identifier DO block
	;

borrow_stmt :
	BORROW identifier COLON borrow_stmt_read_or_write LBRACKET typespec COMMA identifier RBRACKET ASSIGN borrow_stmt_mode identifier DO block END BORROW SEMI
	;

borrow_stmt_read_or_write :
	BORROW_READ
	| BORROW_WRITE
	;

borrow_stmt_mode :
	BORROW_READ
	| BORROW_WRITE
	| REBORROW
	;

block :
	blocklist
	;

blocklist :
	blocklist statement
	| statement
	;

expression :
	atomic_expression
	| compound_expression
	;

atomic_expression :
	NIL
	| TRUE
	| FALSE
	| int_constant
	| float_constant
	| string_constant
	| path
	| ref_path
	| variable
	| funcall
	| parenthesized_expr
	| intrinsic
	| SIZEOF LPAREN typespec RPAREN
	| BORROW_READ identifier
	| BORROW_WRITE identifier
	| REBORROW identifier
	| DEREF atomic_expression
	;

int_constant :
	DEC_CONSTANT
	| HEX_CONSTANT
	| BIN_CONSTANT
	| OCT_CONSTANT
	| CHAR_CONSTANT
	;

float_constant :
	FLOAT_CONSTANT
	;

string_constant :
	STRING_CONSTANT
	| TRIPLE_STRING_CONSTANT
	;

variable :
	identifier
	;

funcall :
	identifier argument_list
	;

parenthesized_expr :
	LPAREN expression RPAREN
	;

argument_list :
	LPAREN positional_arglist RPAREN
	| LPAREN named_arglist RPAREN
	| LPAREN RPAREN
	;

positional_arglist :
	separated_nonempty_list_COMMA_expression_
	;

named_arglist :
	separated_nonempty_list_COMMA_named_arg_
	;

named_arg :
	identifier RIGHT_ARROW expression
	;

intrinsic :
	EMBED LPAREN typespec COMMA STRING_CONSTANT COMMA loption_separated_nonempty_list_COMMA_expression__ RPAREN
	| EMBED LPAREN typespec COMMA STRING_CONSTANT RPAREN
	;

compound_expression :
	atomic_expression comp_op atomic_expression
	| atomic_expression AND atomic_expression
	| atomic_expression OR atomic_expression
	| NOT atomic_expression
	| arith_expr
	| IF expression THEN expression ELSE expression
	| atomic_expression COLON typespec
	;

path :
	identifier nonempty_list_path_rest_
	;

path_rest :
	slot_accessor
	| pointer_slot_accessor
	| array_index
	;

slot_accessor :
	PERIOD identifier
	;

pointer_slot_accessor :
	HYPHEN_RIGHT identifier
	;

array_index :
	LBRACKET expression RBRACKET
	;

ref_path :
	REF_TRANSFORM identifier nonempty_list_path_rest_ RPAREN
	;

comp_op :
	EQ
	| NEQ
	| LT
	| LTE
	| GT
	| GTE
	;

arith_expr :
	atomic_expression PLUS atomic_expression
	| atomic_expression MINUS atomic_expression
	| atomic_expression MUL atomic_expression
	| atomic_expression DIV atomic_expression
	| MINUS atomic_expression
	;

identifier :
	IDENTIFIER
	;

module_name :
	module_name_inner
	;

module_name_inner :
	IDENTIFIER PERIOD module_name_inner
	| IDENTIFIER
	;

typespec :
	identifier LBRACKET loption_separated_nonempty_list_COMMA_typespec__ RBRACKET
	| identifier
	| BORROW_READ LBRACKET typespec COMMA typespec RBRACKET
	| BORROW_WRITE LBRACKET typespec COMMA typespec RBRACKET
	| SPAN_READ LBRACKET typespec COMMA typespec RBRACKET
	| SPAN_WRITE LBRACKET typespec COMMA typespec RBRACKET
	;

universe :
	UNIVERSE_FREE
	| UNIVERSE_LINEAR
	| UNIVERSE_TYPE
	| UNIVERSE_REGION
	;

parameter_list :
	loption_separated_nonempty_list_COMMA_parameter__
	;

parameter :
	identifier COLON typespec
	;

type_parameter_list :
	option_type_parameter_list_inner_
	;

type_parameter_list_inner :
	LBRACKET loption_separated_nonempty_list_COMMA_type_parameter__ RBRACKET
	;

type_parameter :
	identifier COLON universe
	| identifier COLON universe LPAREN loption_separated_nonempty_list_COMMA_identifier__ RPAREN
	;

docstring :
	TRIPLE_STRING_CONSTANT
	;

docstringopt :
	option_docstring_
	;

%%

%x TQSTR

/* Helper regexes */

digit   [0-9]
alpha   [a-zA-Z]
alphanum   ({alpha}|{digit})
whitespace   [ \t]+
hex_digit   [0-9a-fA-F]
bin_digit   [0-1]
oct_digit   [0-7]

ascii_char   [a-zA-Z0-9!"' #$%&)(*+,\-./:;<=>?@`~][^_{|}]

newline   \n\r?|\r\n?

exponent   [eE]
sign   [+-]
period   "."

comment   "--"[^\r\n]*{newline}?

/* Token regexes */

identifier   ({alpha})("_"|{alphanum})*
dec_constant   {sign}?{digit}({digit}|"'")*
hex_constant   "#x"{hex_digit}({hex_digit}|"'")*
bin_constant   "#b"{bin_digit}({bin_digit}|"'")*
oct_constant   "#o"{oct_digit}({oct_digit}|"'")*
float_constant   {sign}?{dec_constant}{period}{dec_constant}?({exponent}{sign}?{dec_constant})?
char_constant   '({ascii_char}|"\\"[nrt\\])'

%%

/* Comments */
{comment}	skip()
/* Brackets */
"("   LPAREN
")"   RPAREN
"["   LBRACKET
"]"   RBRACKET
"{"   LCURLY
"}"   RCURLY
/* Arithmetic operators */
"+"   PLUS
"-"   MINUS
"*"   MUL
"/"   DIV
/* Comparison operators */
"="   EQ
"/="   NEQ
"<="   LTE
"<"   LT
">="   GTE
">"   GT
/* Logical operators */
"and"   AND
"or"   OR
"not"   NOT
/* Borrowing */
"&!"   BORROW_WRITE
"&("   REF_TRANSFORM
"&"   BORROW_READ
"Span"   SPAN_READ
"Span!"   SPAN_WRITE
"&~"   REBORROW
/* Keywords */
"module"   MODULE
"is"   IS
"body"   BODY
"import"   IMPORT
"as"   AS
"end"   END
"constant"   CONSTANT
"type"   TYPE
"function"   FUNCTION
"generic"   GENERIC
"record"   RECORD
"union"   UNION
"case"   CASE
"of"   OF
"when"   WHEN
"typeclass"   TYPECLASS
"instance"   INSTANCE
"method"   METHOD
"if"   IF
"else"{whitespace}+"if"   ELSE_IF
"then"   THEN
"else"   ELSE
"let"   LET
"var"   VAR
"while"   WHILE
"for"   FOR
"do"   DO
"from"   FROM
"to"   TO
"borrow"   BORROW
"return"   RETURN
"skip"   SKIP
"Free"   UNIVERSE_FREE
"Linear"   UNIVERSE_LINEAR
"Type"   UNIVERSE_TYPE
"Region"   UNIVERSE_REGION
"pragma"   PRAGMA
"sizeof"   SIZEOF
/* Symbols */
";"   SEMI
","   COMMA
"."   PERIOD
":"   COLON
"->"   HYPHEN_RIGHT
"=>"   RIGHT_ARROW
":="   ASSIGN
"!"   DEREF
/* Strings and docstrings */
\"\"\"<TQSTR>
<TQSTR> {
	\"\"\"<INITIAL> 	TRIPLE_STRING_CONSTANT
	(?s:.)<.>
}
\"("\\".|[^"\n\r\\])*\"	STRING_CONSTANT
/* Identifiers and constants */
"nil"   NIL
"true"   TRUE
"false"   FALSE
{float_constant}   FLOAT_CONSTANT
{dec_constant}   DEC_CONSTANT
{hex_constant}   HEX_CONSTANT
{bin_constant}   BIN_CONSTANT
{oct_constant}   OCT_CONSTANT
{char_constant}   CHAR_CONSTANT
{identifier}   IDENTIFIER
/* Specials */
"@embed"   EMBED
/* etc. */
{whitespace}+	skip()
{newline}	skip()

%%
