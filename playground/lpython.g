//From: https://github.com/lcompilers/lpython/blob/main/src/lpython/parser/parser.yy

//%token_indent TK_INDENT
//%token_dedent TK_DEDENT

/*Tokens*/
%token END_OF_FILE
%token TK_NEWLINE
%token TK_INDENT
%token TK_DEDENT
%token TK_NAME
%token TK_INTEGER
%token TK_REAL
%token TK_IMAG_NUM
%token TK_PLUS
%token TK_MINUS
//%token TK_STAR
%token TK_SLASH
//%token TK_COLON
%token TK_SEMICOLON
//%token TK_COMMA
%token TK_EQUAL
//%token TK_LPAREN
//%token TK_RPAREN
//%token TK_LBRACKET
//%token TK_RBRACKET
//%token TK_LBRACE
//%token TK_RBRACE
//%token TK_PERCENT
%token TK_VBAR
%token TK_AMPERSAND
//%token TK_DOT
%token TK_TILDE
%token TK_CARET
%token TK_AT
%token TK_STRING
%token TK_COMMENT
%token TK_EOLCOMMENT
%token TK_TYPE_COMMENT
%token TK_TYPE_IGNORE
%token TK_POW
%token TK_FLOOR_DIV
%token TK_RIGHTSHIFT
%token TK_LEFTSHIFT
%token TK_PLUS_EQUAL
%token TK_MIN_EQUAL
%token TK_STAR_EQUAL
%token TK_SLASH_EQUAL
%token TK_PERCENT_EQUAL
%token TK_AMPER_EQUAL
%token TK_VBAR_EQUAL
%token TK_CARET_EQUAL
%token TK_ATEQUAL
%token TK_RARROW
%token TK_COLONEQUAL
%token TK_ELLIPSIS
%token TK_LEFTSHIFT_EQUAL
%token TK_RIGHTSHIFT_EQUAL
%token TK_POW_EQUAL
%token TK_DOUBLESLASH_EQUAL
//%token TK_EQ
%token TK_NE
%token TK_LT
%token TK_LE
%token TK_GT
%token TK_GE
%token TK_NOT
%token TK_IS_NOT
%token TK_NOT_IN
%token TK_AND
%token TK_OR
%token TK_TRUE
%token TK_FALSE
%token KW_AS
%token KW_ASSERT
%token KW_ASYNC
%token KW_AWAIT
%token KW_BREAK
%token KW_CLASS
%token KW_CONTINUE
%token KW_DEF
%token KW_DEL
%token KW_ELIF
%token KW_ELSE
%token KW_EXCEPT
%token KW_FINALLY
%token KW_FOR
%token KW_FROM
%token KW_GLOBAL
%token KW_IF
%token KW_IMPORT
%token KW_IN
%token KW_IS
%token KW_LAMBDA
%token KW_NONE
%token KW_NONLOCAL
%token KW_PASS
%token KW_RAISE
%token KW_RETURN
%token KW_TRY
%token KW_WHILE
%token KW_WITH
%token KW_YIELD
%token KW_YIELD_FROM
%token KW_MATCH
%token KW_CASE
%token LAMBDA
%token FOR
%token UNARY
%token AWAIT

%precedence /*1*/ TK_COLONEQUAL
%precedence /*2*/ LAMBDA
%left /*3*/ KW_ELSE KW_IF
%left /*4*/ TK_OR
%left /*5*/ TK_AND
%precedence /*6*/ TK_NOT
%left /*7*/ "=" TK_NE TK_LT TK_LE TK_GT TK_GE TK_IS_NOT TK_NOT_IN KW_IN KW_IS
%precedence /*8*/ FOR
%left /*9*/ TK_VBAR
%left /*10*/ TK_CARET
%left /*11*/ TK_AMPERSAND
%left /*12*/ TK_RIGHTSHIFT TK_LEFTSHIFT
%left /*13*/ TK_PLUS TK_MINUS
%left /*14*/ "*" TK_SLASH "%" TK_AT TK_FLOOR_DIV
%precedence /*15*/ UNARY
%right /*16*/ TK_POW
%precedence /*17*/ AWAIT
%precedence /*18*/ "."

%start units

%%

units :
	END_OF_FILE
	| units script_unit
	| script_unit
	| sep
	;

script_unit :
	statement
	;

statements :
	TK_INDENT statements1 TK_DEDENT
	;

sep_statements :
	sep statements
	| type_ignore_sep statements
	;

func_body_stmts:
    TK_COMMENT TK_NEWLINE body_stmts
    | body_stmts
    ;

body_stmts :
	single_line_statements
	| sep_statements
	;

statements1 :
	statements1 statement
	| statement
	;

single_line_statements :
	single_line_multi_statements TK_NEWLINE
	| single_line_multi_statements TK_EOLCOMMENT
	| single_line_statement TK_NEWLINE
	| single_line_statement TK_SEMICOLON TK_NEWLINE
	| single_line_statement TK_SEMICOLON TK_EOLCOMMENT
	| single_line_statement TK_EOLCOMMENT
	;

single_line_multi_statements :
	single_line_multi_statements_opt single_line_statement
	| single_line_multi_statements_opt single_line_statement ";"
	;

single_line_multi_statements_opt :
	single_line_multi_statements_opt single_line_statement ";"
	| single_line_statement ";"
	;

type_ignore_sep :
	TK_TYPE_IGNORE sep
	| sep TK_TYPE_IGNORE sep
	;

statement :
	single_line_statement sep
	| single_line_statement type_ignore_sep
	| multi_line_statement
	| multi_line_statement sep
	| multi_line_statement type_ignore_sep
	;

single_line_statement :
	expression_statment
	| assert_statement
	| assignment_statement
	| augassign_statement
	| ann_assignment_statement
	| pass_statement
	| delete_statement
	| return_statement
	| raise_statement
	| break_statement
	| continue_statement
	| import_statement
	| global_statement
	| nonlocal_statement
	;

multi_line_statement :
	if_statement
	| for_statement
	| try_statement
	| with_statement
	| match_statement
	| function_def
	| class_def
	| async_func_def
	| async_for_stmt
	| async_with_stmt
	| while_statement
	;

yield_expr :
	KW_YIELD
	| KW_YIELD tuple_list
	| KW_YIELD_FROM tuple_list
	;

expression_statment :
	tuple_list
	| yield_expr
	;

pass_statement :
	KW_PASS
	;

break_statement :
	KW_BREAK
	;

continue_statement :
	KW_CONTINUE
	;

raise_statement :
	KW_RAISE
	| KW_RAISE expr
	| KW_RAISE expr KW_FROM expr
	;

assert_statement :
	KW_ASSERT expr
	| KW_ASSERT expr "," expr
	;

target_list :
	target_list tuple_list "="
	| tuple_list "="
	;

assignment_statement :
	target_list tuple_list
	| target_list yield_expr
	| target_list tuple_list TK_TYPE_COMMENT
	;

augassign_statement :
	expr augassign_op tuple_list
	;

augassign_op :
	"+="
	| "-="
	| "*="
	| "/="
	| "%="
	| "&="
	| "|="
	| "^="
	| "<<="
	| ">>="
	| "**="
	| "//="
	| "@="
	;

ann_assignment_statement :
	expr ":" expr
	| expr ":" expr "=" tuple_list
	;

delete_statement :
	KW_DEL expr_list
	| KW_DEL expr_list ","
	;

return_statement :
	KW_RETURN
	| KW_RETURN tuple_list
	| KW_RETURN yield_expr
	;

module :
	module "." /*18P*/ id
	| id
	;

module_as_id :
	module
	| module KW_AS id
	| "*" /*14L*/
	;

module_item_list :
	module_item_list "," module_as_id
	| module_item_list "," TK_TYPE_IGNORE module_as_id
	| module_as_id
	;

dot_list :
	dot_list "." /*18P*/
	| "." /*18P*/
	| dot_list "..."
	| "..."
	;

type_ignore_opt :
	TK_TYPE_IGNORE
	| "," TK_TYPE_IGNORE
	| comma_opt
	;

import_statement :
	KW_IMPORT module_item_list
	| KW_FROM module KW_IMPORT module_item_list
	| KW_FROM module KW_IMPORT "(" module_item_list type_ignore_opt ")"
	| KW_FROM dot_list KW_IMPORT module_item_list
	| KW_FROM dot_list module KW_IMPORT module_item_list
	| KW_FROM dot_list KW_IMPORT "(" module_item_list type_ignore_opt ")"
	| KW_FROM dot_list module KW_IMPORT "(" module_item_list type_ignore_opt ")"
	;

global_statement :
	KW_GLOBAL expr_list
	;

ternary_if_statement :
	expr KW_IF /*3L*/ expr KW_ELSE /*3L*/ expr
	;

nonlocal_statement :
	KW_NONLOCAL expr_list
	;

elif_statement :
	KW_ELIF expr ":" body_stmts
	| KW_ELIF expr ":" body_stmts KW_ELSE /*3L*/ ":" body_stmts
	| KW_ELIF expr ":" body_stmts elif_statement
	;

if_statement :
	KW_IF /*3L*/ expr ":" body_stmts
	| KW_IF /*3L*/ expr ":" body_stmts KW_ELSE /*3L*/ ":" body_stmts
	| KW_IF /*3L*/ expr ":" body_stmts elif_statement
	;

for_target_list :
	expr %prec FOR /*8P*/
	| expr_list "," expr %prec FOR /*8P*/
	| expr_list "," %prec FOR /*8P*/
	;

tuple_list :
	expr
	| expr_list "," expr
	| expr_list ","
	;

for_statement :
	KW_FOR for_target_list KW_IN /*7L*/ tuple_list ":" body_stmts
	| KW_FOR for_target_list KW_IN /*7L*/ tuple_list ":" body_stmts KW_ELSE /*3L*/ ":" body_stmts
	| KW_FOR for_target_list KW_IN /*7L*/ tuple_list ":" TK_TYPE_COMMENT sep statements
	| KW_FOR for_target_list KW_IN /*7L*/ tuple_list ":" TK_TYPE_COMMENT sep statements KW_ELSE /*3L*/ ":" body_stmts
	;

except_statement :
	KW_EXCEPT ":" body_stmts
	| KW_EXCEPT expr ":" body_stmts
	| KW_EXCEPT expr KW_AS id ":" body_stmts
	;

except_list :
	except_list except_statement
	| except_statement
	;

try_statement :
	KW_TRY ":" body_stmts except_list
	| KW_TRY ":" body_stmts except_list KW_ELSE /*3L*/ ":" body_stmts
	| KW_TRY ":" body_stmts except_list KW_FINALLY ":" body_stmts
	| KW_TRY ":" body_stmts except_list KW_ELSE /*3L*/ ":" body_stmts KW_FINALLY ":" body_stmts
	| KW_TRY ":" body_stmts KW_FINALLY ":" body_stmts
	;

with_item :
	expr KW_AS expr
	| expr
	;

with_as_items_list_1 :
	with_as_items_list_1 "," with_item
	| with_item
	;

with_as_items_list_2 :
	with_as_items_list_2 "," expr KW_AS expr
	| expr KW_AS expr
	;

with_as_items :
	with_as_items_list_1
	| "(" with_as_items_list_2 ")"
	| "(" with_as_items_list_2 "," ")"
	;

with_statement :
	KW_WITH with_as_items ":" body_stmts
	| KW_WITH with_as_items ":" TK_TYPE_COMMENT sep statements
	;

class_name :
	id
	| attr
	;

class_pattern :
	class_name "(" ")"
	| class_name "(" positional_patterns ")"
	| class_name "(" positional_patterns "," keyword_patterns ")"
	| class_name "(" keyword_patterns ")"
	;

positional_patterns :
	positional_patterns "," pattern_2
	| pattern_2
	;

keyword_patterns :
	keyword_patterns "," id "=" pattern_2
	| id "=" pattern_2
	;

mapping_pattern :
	"{" "}"
	| "{" items_pattern "}"
	| "{" items_pattern "," "**" /*16R*/ id "}"
	| "{" "**" /*16R*/ id "}"
	;

items_pattern :
	items_pattern "," key_value_pattern
	| key_value_pattern
	;

key_value_pattern :
	literal_pattern ":" pattern_2
	;

star_pattern :
	"*" /*14L*/ id
	| pattern_2
	;

open_sequence_pattern :
	open_sequence_pattern "," star_pattern
	| star_pattern
	;

sequence_pattern :
	"[" "]"
	| "(" ")"
	| "(" open_sequence_pattern "," ")"
	| "(" open_sequence_pattern "," star_pattern ")"
	| "[" open_sequence_pattern "]"
	| "[" open_sequence_pattern "," "]"
	;

attr :
	attr "." /*18P*/ id
	| id "." /*18P*/ id
	;

numbers :
	numbers "+" /*13L*/ numbers
	| numbers "-" /*13L*/ numbers
	| "-" /*13L*/ numbers
	| TK_INTEGER
	| TK_REAL
	| TK_IMAG_NUM
	;

literal_pattern :
	numbers
	| string
	| attr
	;

singleton_pattern :
	KW_NONE
	| TK_TRUE
	| TK_FALSE
	;

closed_pattern :
	literal_pattern
	| singleton_pattern
	| id
	| "(" pattern_2 ")"
	| sequence_pattern
	| mapping_pattern
	| class_pattern
	;

or_pattern :
	or_pattern "|" /*9L*/ closed_pattern
	| closed_pattern "|" /*9L*/ closed_pattern
	;

pattern_2 :
	closed_pattern
	| or_pattern
	| closed_pattern KW_AS id
	| or_pattern KW_AS id
	;

pattern_1 :
	open_sequence_pattern "," star_pattern
	| open_sequence_pattern ","
	;

case_block :
	KW_CASE pattern_1 ":" body_stmts
	| KW_CASE pattern_2 ":" body_stmts
	| KW_CASE pattern_1 KW_IF /*3L*/ expr ":" body_stmts
	| KW_CASE pattern_2 KW_IF /*3L*/ expr ":" body_stmts
	;

case_blocks :
	case_blocks case_block
	| case_block
	;

match_statement :
	KW_MATCH tuple_list ":" sep TK_INDENT case_blocks TK_DEDENT
	;

decorators_opt :
	decorators
	| /*empty*/
	;

decorators :
	decorators "@" /*14L*/ expr sep
	| "@" /*14L*/ expr sep
	| decorators "@" /*14L*/ expr TK_TYPE_IGNORE sep
	| "@" /*14L*/ expr TK_TYPE_IGNORE sep
	;

parameter :
	id
	| id ":" expr
	| id "=" expr
	| id ":" expr "=" expr
	;

defparameter_list :
	defparameter_list "," parameter
	| parameter
	| defparameter_list "," type_comment parameter
	| defparameter_list "," type_comment
	;

parameter_list :
	defparameter_list "," "/" /*14L*/ comma_opt
	| defparameter_list "," "/" /*14L*/ "," parameter_list_no_posonly
	| parameter_list_no_posonly
	;

parameter_list_no_posonly :
	defparameter_list comma_opt
	| defparameter_list "," parameter_list_starargs
	| parameter_list_starargs
	;

parameter_list_starargs :
	"*" /*14L*/ "," defparameter_list comma_opt
	| "*" /*14L*/ "," "**" /*16R*/ parameter comma_opt
	| "*" /*14L*/ "," defparameter_list "," "**" /*16R*/ parameter comma_opt
	| "*" /*14L*/ parameter comma_opt
	| "*" /*14L*/ parameter "," defparameter_list comma_opt
	| "*" /*14L*/ parameter "," "**" /*16R*/ parameter comma_opt
	| "*" /*14L*/ parameter "," defparameter_list "," "**" /*16R*/ parameter comma_opt
	| "**" /*16R*/ parameter comma_opt
	;

parameter_list_opt :
	parameter_list
	| /*empty*/
	;

comma_opt :
	","
	| /*empty*/
	;

function_def :
	decorators_opt KW_DEF id "(" parameter_list_opt ")" ":" func_body_stmts
	| decorators_opt KW_DEF id "(" parameter_list_opt ")" "->" expr ":" func_body_stmts
	| decorators_opt KW_DEF id "(" parameter_list_opt ")" ":" TK_TYPE_COMMENT sep statements
	| decorators_opt KW_DEF id "(" parameter_list_opt ")" "->" expr ":" TK_TYPE_COMMENT sep statements
	| decorators_opt KW_DEF id "(" parameter_list_opt ")" ":" sep TK_TYPE_COMMENT sep statements
	| decorators_opt KW_DEF id "(" parameter_list_opt ")" "->" expr ":" sep TK_TYPE_COMMENT sep statements
	;

class_def :
	decorators_opt KW_CLASS id ":" body_stmts
	| decorators_opt KW_CLASS id "(" call_arguement_list ")" ":" body_stmts
	;

async_func_def :
	decorators KW_ASYNC KW_DEF id "(" parameter_list_opt ")" ":" func_body_stmts
	| decorators KW_ASYNC KW_DEF id "(" parameter_list_opt ")" "->" expr ":" func_body_stmts
	| KW_ASYNC KW_DEF id "(" parameter_list_opt ")" ":" func_body_stmts
	| KW_ASYNC KW_DEF id "(" parameter_list_opt ")" "->" expr ":" func_body_stmts
	| decorators KW_ASYNC KW_DEF id "(" parameter_list_opt ")" ":" TK_TYPE_COMMENT sep statements
	| decorators KW_ASYNC KW_DEF id "(" parameter_list_opt ")" "->" expr ":" TK_TYPE_COMMENT sep statements
	| KW_ASYNC KW_DEF id "(" parameter_list_opt ")" ":" TK_TYPE_COMMENT sep statements
	| KW_ASYNC KW_DEF id "(" parameter_list_opt ")" "->" expr ":" TK_TYPE_COMMENT sep statements
	;

async_for_stmt :
	KW_ASYNC KW_FOR for_target_list KW_IN /*7L*/ tuple_list ":" body_stmts
	| KW_ASYNC KW_FOR for_target_list KW_IN /*7L*/ tuple_list ":" body_stmts KW_ELSE /*3L*/ ":" body_stmts
	| KW_ASYNC KW_FOR for_target_list KW_IN /*7L*/ tuple_list ":" TK_TYPE_COMMENT sep statements
	| KW_ASYNC KW_FOR for_target_list KW_IN /*7L*/ tuple_list ":" TK_TYPE_COMMENT sep statements KW_ELSE /*3L*/ ":" body_stmts
	;

async_with_stmt :
	KW_ASYNC KW_WITH with_as_items ":" body_stmts
	| KW_ASYNC KW_WITH with_as_items ":" TK_TYPE_COMMENT sep statements
	;

while_statement :
	KW_WHILE expr ":" body_stmts
	| KW_WHILE expr ":" body_stmts KW_ELSE /*3L*/ ":" body_stmts
	;

expr_list_opt :
	expr_list comma_opt
	| /*empty*/
	;

expr_list :
	expr_list "," expr %prec TK_NOT /*6P*/
	| expr %prec TK_NOT /*6P*/
	;

dict :
	expr ":" expr
	| expr ":" type_comment expr
	| "**" /*16R*/ expr
	;

dict_list :
	dict_list "," dict
	| dict
	;

id_list_opt :
	id_list
	| /*empty*/
	;

id_list :
	id_list "," id_item
	| id_item
	;

id_item :
	id
	| id "[" slice_item "]"
	| "*" /*14L*/ id
	| "(" id ")"
	| "(" id_list "," ")"
	| "(" id_list "," id_item ")"
	| "[" id_list_opt "]"
	| "[" id_list "," "]"
	;

comp_if_items :
	comp_if_items KW_IF /*3L*/ expr
	| KW_IF /*3L*/ expr
	;

comp_for :
	KW_FOR id_list KW_IN /*7L*/ expr
	| KW_FOR id_list "," KW_IN /*7L*/ expr
	| KW_FOR id_list KW_IN /*7L*/ expr comp_if_items
	| KW_FOR id_list "," KW_IN /*7L*/ expr comp_if_items
	| KW_ASYNC KW_FOR id_list KW_IN /*7L*/ expr
	| KW_ASYNC KW_FOR id_list "," KW_IN /*7L*/ expr
	| KW_ASYNC KW_FOR id_list KW_IN /*7L*/ expr comp_if_items
	| KW_ASYNC KW_FOR id_list "," KW_IN /*7L*/ expr comp_if_items
	;

comp_for_items :
	comp_for_items comp_for
	| comp_for
	;

keywords_arguments :
	keywords_arguments "," "**" /*16R*/ expr
	| keywords_arguments "," id "=" expr
	| "**" /*16R*/ expr
	;

starred_and_keyword :
	expr
	| id "=" expr
	;

positional_items :
	positional_items "," starred_and_keyword
	| positional_items "," TK_TYPE_IGNORE starred_and_keyword
	| starred_and_keyword
	;

call_arguement_list :
	/*empty*/
	| positional_items type_ignore_opt
	| keywords_arguments type_ignore_opt
	| positional_items "," keywords_arguments type_ignore_opt
	;

primary :
	id
	| string
	| expr "." /*18P*/ id
	;

function_call :
	primary "(" call_arguement_list ")"
	| primary "(" TK_TYPE_IGNORE call_arguement_list ")"
	| primary "(" expr comp_for_items ")"
	| function_call "(" call_arguement_list ")"
	| function_call "(" expr comp_for_items ")"
	| subscript "(" call_arguement_list ")"
	| subscript "(" expr comp_for_items ")"
	| "(" expr ")" "(" call_arguement_list ")"
	;

slice_item_list :
	slice_item_list "," slice_items
	| slice_items
	;

slice_items :
	":"
	| expr ":"
	| ":" expr
	| expr ":" expr
	| ":" ":"
	| ":" ":" expr
	| expr ":" ":"
	| ":" expr ":"
	| expr ":" ":" expr
	| ":" expr ":" expr
	| expr ":" expr ":"
	| expr ":" expr ":" expr
	| expr
	;

slice_item :
	slice_item_list
	| slice_item_list ","
	;

subscript :
	primary "[" slice_item "]"
	| function_call "[" slice_item "]"
	| "[" expr_list_opt "]" "[" slice_item "]"
	| "{" expr_list "}" "[" slice_item "]"
	| "(" expr ")" "[" slice_item "]"
	| "(" expr_list "," ")" "[" slice_item "]"
	| "(" expr_list "," expr ")" "[" slice_item "]"
	| "{" dict_list comma_opt "}" "[" slice_item "]"
	| "{" "}" "[" slice_item "]"
	| subscript "[" slice_item "]"
	| comprehension "[" slice_item "]"
	;

string :
	string TK_STRING
	| string id TK_STRING
	| TK_STRING
	| id TK_STRING
	;

lambda_parameter :
	id
	| id "=" expr
	;

lambda_defparameter_list :
	lambda_defparameter_list "," lambda_parameter
	| lambda_parameter
	;

lambda_parameter_list :
	lambda_defparameter_list "," "/" /*14L*/ comma_opt
	| lambda_defparameter_list "," "/" /*14L*/ "," lambda_parameter_list_no_posonly
	| lambda_parameter_list_no_posonly
	;

lambda_parameter_list_no_posonly :
	lambda_defparameter_list comma_opt
	| lambda_defparameter_list "," lambda_parameter_list_starargs
	| lambda_parameter_list_starargs
	;

lambda_parameter_list_starargs :
	"*" /*14L*/ "," lambda_defparameter_list comma_opt
	| "*" /*14L*/ "," "**" /*16R*/ lambda_parameter comma_opt
	| "*" /*14L*/ "," lambda_defparameter_list "," "**" /*16R*/ lambda_parameter comma_opt
	| "*" /*14L*/ lambda_parameter comma_opt
	| "*" /*14L*/ lambda_parameter "," lambda_defparameter_list comma_opt
	| "*" /*14L*/ lambda_parameter "," "**" /*16R*/ lambda_parameter comma_opt
	| "*" /*14L*/ lambda_parameter "," lambda_defparameter_list "," "**" /*16R*/ lambda_parameter comma_opt
	| "**" /*16R*/ lambda_parameter comma_opt
	;

lambda_parameter_list_opt :
	lambda_parameter_list
	| /*empty*/
	;

lambda_expression :
	KW_LAMBDA lambda_parameter_list_opt ":" expr %prec LAMBDA /*2P*/
	;

comprehension :
	"[" expr comp_for_items "]"
	| "{" expr comp_for_items "}"
	| "{" expr ":" expr comp_for_items "}"
	| "(" expr comp_for_items ")"
	;

expr :
	id
	| TK_INTEGER
	| string
	| TK_REAL
	| TK_IMAG_NUM
	| TK_TRUE
	| TK_FALSE
	| KW_NONE
	| TK_ELLIPSIS
	| "(" expr ")"
	| KW_AWAIT expr %prec AWAIT /*17P*/
	| "(" yield_expr ")"
	| "(" TK_TYPE_IGNORE expr ")"
	| "(" ")"
	| "(" expr_list "," ")"
	| "(" TK_TYPE_IGNORE expr_list "," ")"
	| "(" expr_list "," expr ")"
	| "(" TK_TYPE_IGNORE expr_list "," expr ")"
	| function_call
	| subscript
	| "[" expr_list_opt "]"
	| "{" expr_list "}"
	| "{" expr_list "," "}"
	| expr "." /*18P*/ id
	| "{" "}"
	| "{" dict_list comma_opt "}"
	| id ":=" /*1P*/ expr
	| "*" /*14L*/ expr
	| expr "+" /*13L*/ expr
	| expr "-" /*13L*/ expr
	| expr "*" /*14L*/ expr
	| expr "/" /*14L*/ expr
	| expr "%" /*14L*/ expr
	| "-" /*13L*/ expr %prec UNARY /*15P*/
	| "+" /*13L*/ expr %prec UNARY /*15P*/
	| "~" expr %prec UNARY /*15P*/
	| expr "**" /*16R*/ expr
	| expr "//" /*14L*/ expr
	| expr "@" /*14L*/ expr
	| expr "&" /*11L*/ expr
	| expr "|" /*9L*/ expr
	| expr "^" /*10L*/ expr
	| expr "<<" /*12L*/ expr
	| expr ">>" /*12L*/ expr
	| expr "==" /*7L*/ expr
	| expr "!=" /*7L*/ expr
	| expr "<" /*7L*/ expr
	| expr "<=" /*7L*/ expr
	| expr ">" /*7L*/ expr
	| expr ">=" /*7L*/ expr
	| expr "is" /*7L*/ expr
	| expr "is not" /*7L*/ expr
	| expr KW_IN /*7L*/ expr
	| expr "not in" /*7L*/ expr
	| expr TK_AND /*5L*/ expr
	| expr TK_OR /*4L*/ expr
	| TK_NOT /*6P*/ expr
	| comprehension
	| ternary_if_statement
	| lambda_expression
	;

id :
	TK_NAME
	;

type_comment :
	TK_TYPE_COMMENT
	| TK_TYPE_IGNORE
	;

sep :
	sep sep_one
	| sep_one
	;

sep_one :
	TK_NEWLINE
	| TK_COMMENT
	| TK_EOLCOMMENT
	| ";"
	;

%%

%x ST_INDENT ST_INDENT2

end  "\x00"
whitespace  [ \t\v]+
newline  \n|\r\n
digit  [0-9]
int_oct  0[oO]([0-7]|_[0-7])+
int_bin  0[bB]([01]|_[01])+
int_hex  0[xX]([0-9a-fA-F]|_[0-9a-fA-F])+
digits  {digit}+({digit}|_{digit})*
char   [^\x00-\x7F]|[a-zA-Z_]
name  {char}({char}|{digit})*
significand  ({digits}"."{digits}?)|("."{digits})
exp  [eE][-+]?{digits}
integer  {digits}|{int_oct}|{int_bin}|{int_hex}
real  ({significand}{exp}?)|({digits}{exp})
imag_number  ({real}|{digits})[jJ]
string1  \"(\\[^\x00]|[^\"\x00\n\\])*\"
string2  '(\\[^\x00]|[^'\x00\n\\])*'

string3_1	(\"|\"\\+\"|\"\\+)[^"\x00\\]
string3_2	(\"\"|\"\"\\+)[^"\x00\\]
string3  \"\"\"(\\[^\x00]|{string3_1}|{string3_2}|[^"\x00\\])*\"\"\"

string4_1	('|'\\+'|'\\+)[^'\x00\\]
string4_2	(''|''\\+)[^'\x00\\]
string4 = "'''"(\\[^\x00]|{string4_1}|{string4_2}|[^'\x00\\])*'''
type_ignore "#"{whitespace}?"type:"{whitespace}?"ignore"[^\n\x00]*
type_comment  "#"{whitespace}?"type:"{whitespace}?[^\n\x00]*
comment  "#"[^\n\x00]*
// docstring = newline whitespace? string1 | string2;
ws_comment  {whitespace}?{comment}?{newline}


%%

{whitespace} skip()
{newline}<ST_INDENT> TK_NEWLINE
<ST_INDENT> {
    {newline}{newline}<ST_INDENT2>  reject()
    {newline}  TK_NEWLINE
    [ ]+    indent_track()
    .<INITIAL> reject()
}
<ST_INDENT2> {
    {newline}<INITIAL>  indent_track()
}
{string3}   TK_COMMENT

// Keywords
"as"       KW_AS
"assert"   KW_ASSERT
"async"    KW_ASYNC
"await"    KW_AWAIT
"break"    KW_BREAK
"class"    KW_CLASS
"continue" KW_CONTINUE
"def"      KW_DEF
"del"      KW_DEL
"elif"     KW_ELIF
"else"     KW_ELSE
"except"   KW_EXCEPT
"finally"  KW_FINALLY
"for"      KW_FOR
"from"     KW_FROM
"global"   KW_GLOBAL
"if"       KW_IF
"import"   KW_IMPORT
"in"       KW_IN
"is"       KW_IS
"lambda"   KW_LAMBDA
"None"     KW_NONE
"nonlocal" KW_NONLOCAL
"pass"     KW_PASS
"raise"    KW_RAISE
"return"   KW_RETURN
"try"      KW_TRY
"while"    KW_WHILE
"with"     KW_WITH
"yield"    KW_YIELD
"yield"{whitespace}"from"{whitespace} KW_YIELD_FROM

\\{newline}	skip() /* line continuation */

// Single character symbols
"("	"("	/*TK_LPAREN*/
"["	"["	/*TK_LBRACKET*/
"{"	"{"	/*TK_LBRACE*/
")"	")"	/*TK_RPAREN*/
"]"	"]"	/*TK_RBRACKET*/
"}"	"}"	/*TK_RBRACE*/
"+"	"+"	/*TK_PLUS*/
"-"	"-"	/*TK_MINUS*/
"="	"="	/*TK_EQUAL*/

":"	":" //TK_COLON

";" TK_SEMICOLON
"/" TK_SLASH
"%" "%" //TK_PERCENT
"," "," //TK_COMMA
"*" "*" //TK_STAR
"|" TK_VBAR
"&" TK_AMPERSAND
"." "." //TK_DOT
"~" TK_TILDE
"^" TK_CARET
"@" TK_AT

// Multiple character symbols
">>" TK_RIGHTSHIFT
"<<" TK_LEFTSHIFT
"**" TK_POW
"//" TK_FLOOR_DIV
"+=" TK_PLUS_EQUAL
"-=" TK_MIN_EQUAL
"*=" TK_STAR_EQUAL
"/=" TK_SLASH_EQUAL
"%=" TK_PERCENT_EQUAL
"&=" TK_AMPER_EQUAL
"|=" TK_VBAR_EQUAL
"^=" TK_CARET_EQUAL
"@=" TK_ATEQUAL
"->" TK_RARROW
":=" TK_COLONEQUAL
"..." TK_ELLIPSIS
"<<=" TK_LEFTSHIFT_EQUAL
">>=" TK_RIGHTSHIFT_EQUAL
"**=" TK_POW_EQUAL
"//=" TK_DOUBLESLASH_EQUAL

// Relational operators
"=="   "==" //TK_EQ
"!="   TK_NE
"<"    TK_LT
"<="   TK_LE
">"    TK_GT
">="   TK_GE

// Logical operators
"not"  TK_NOT
"and"  TK_AND
"or"   TK_OR
"is"{whitespace}"not"{whitespace} TK_IS_NOT
"is"{whitespace}?"\\"{newline}{whitespace}?"not"{whitespace} TK_IS_NOT
"not"{whitespace}"in\\"{newline} TK_NOT_IN
"not"{whitespace}"in"{whitespace} TK_NOT_IN
"not"{whitespace}"in"{newline} TK_NOT_IN
"not"{whitespace}?"\\"{newline}{whitespace}?"in\\"{newline} TK_NOT_IN
"not"{whitespace}?"\\"{newline}{whitespace}?"in"{whitespace} TK_NOT_IN

// True/False

"True" TK_TRUE
"False" TK_FALSE

{real} TK_REAL
{integer} TK_INTEGER
{imag_number} TK_IMAG_NUM

{string1} TK_STRING
{string2} TK_STRING
{string3} TK_STRING
{string4} TK_STRING

/* Order matter if identifier comes before keywords they are classified as identifier */
{name} TK_NAME


%%
