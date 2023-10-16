//From: https://github.com/pikelang/Pike/blob/210b89c3f74b314172d679978460c0dd509cbe64/src/language.yacc

/*Tokens*/
%token TOK_ARROW
%token TOK_CONSTANT
%token TOK_FLOAT
%token TOK_STRING
%token TOK_NUMBER
%token TOK_INC
%token TOK_DEC
%token TOK_RETURN
%token TOK_EQ
%token TOK_GE
%token TOK_LE
%token TOK_NE
%token TOK_NOT
%token TOK_LSH
%token TOK_RSH
%token TOK_LAND
%token TOK_LOR
%token TOK_SWITCH
%token TOK_SSCANF
%token TOK_CATCH
%token TOK_FOREACH
%token TOK_LEX_EOF
%token TOK_ADD_EQ
%token TOK_AND_EQ
%token TOK_ARRAY_ID
%token TOK_ATTRIBUTE_ID
%token TOK_BREAK
%token TOK_CASE
%token TOK_CLASS
%token TOK_COLON_COLON
%token TOK_CONTINUE
%token TOK_DEFAULT
%token TOK_DEPRECATED_ID
%token TOK_DIV_EQ
%token TOK_DO
%token TOK_DOT_DOT
%token TOK_DOT_DOT_DOT
%token TOK_ELSE
%token TOK_ENUM
%token TOK_EXTERN
%token TOK_FLOAT_ID
%token TOK_FOR
%token TOK_FUNCTION_ID
%token TOK_GAUGE
%token TOK_GLOBAL
%token TOK_IDENTIFIER
%token TOK_RESERVED
%token TOK_IF
%token TOK_IMPORT
%token TOK_INHERIT
%token TOK_INLINE
%token TOK_LOCAL_ID
%token TOK_FINAL_ID
%token TOK_FUNCTION_NAME
%token TOK_INT_ID
%token TOK_LAMBDA
%token TOK_MULTISET_ID
%token TOK_MULTISET_END
%token TOK_MULTISET_START
%token TOK_LSH_EQ
%token TOK_MAPPING_ID
%token TOK_MIXED_ID
%token TOK_MOD_EQ
%token TOK_MULT_EQ
%token TOK_OBJECT_ID
%token TOK_OR_EQ
%token TOK_POW
%token TOK_POW_EQ
%token TOK_PRIVATE
%token TOK_PROGRAM_ID
%token TOK_PROTECTED
%token TOK_PREDEF
%token TOK_PUBLIC
%token TOK_RSH_EQ
%token TOK_STATIC
%token TOK_STATIC_ASSERT
%token TOK_STRING_ID
%token TOK_SUB_EQ
%token TOK_TYPEDEF
%token TOK_TYPEOF
%token TOK_UNKNOWN
%token TOK_UNUSED
%token TOK_VARIANT
%token TOK_VERSION
%token TOK_VOID_ID
%token TOK_WEAK
%token TOK_WHILE
%token TOK_XOR_EQ
%token TOK_OPTIONAL
%token TOK_SAFE_INDEX
%token TOK_SAFE_START_INDEX
%token TOK_SAFE_APPLY
%token TOK_BITS
%token TOK_AUTO_ID
%token TOK_ATOMIC_GET_SET
%token '='
%token '?'
%token '|'
%token '^'
%token '&'
%token '>'
%token '<'
%token '+'
%token '-'
%token '*'
%token '%'
%token '/'
%token '~'
%token ';'
%token ':'
%token '}'
%token ','
%token '('
%token '['
%token ']'
%token ')'
%token '@'
%token '{'
%token '.'

%right /*1*/ '='
%right /*2*/ '?'
%left /*3*/ TOK_LOR
%left /*4*/ TOK_LAND
%left /*5*/ '|'
%left /*6*/ '^'
%left /*7*/ '&'
%left /*8*/ TOK_EQ TOK_NE
%left /*9*/ TOK_GE TOK_LE '>' '<'
%left /*10*/ TOK_LSH TOK_RSH
%left /*11*/ '+' '-'
%left /*12*/ '*' '%' '/'
%right /*13*/ TOK_NOT '~'
%right /*14*/ TOK_POW
%nonassoc /*15*/ TOK_INC TOK_DEC

%start all

%%

all :
	program
	| program TOK_LEX_EOF
	;

program :
	program def
	| program ';'
	| /*empty*/
	;

real_string_or_identifier :
	TOK_IDENTIFIER
	| real_string_constant
	;

optional_rename_inherit :
	':' real_string_or_identifier
	| ':' bad_identifier
	//| ':' error
	| /*empty*/
	;

low_program_ref :
	safe_assignment_expr
	;

inherit_ref :
	low_program_ref
	;

inheritance :
	modifiers TOK_INHERIT inherit_ref optional_rename_inherit ';'
	//| modifiers TOK_INHERIT inherit_ref error ';'
	//| modifiers TOK_INHERIT inherit_ref error TOK_LEX_EOF
	//| modifiers TOK_INHERIT inherit_ref error '}'
	;

import :
	TOK_IMPORT constant_expr ';'
	;

constant_name :
	TOK_IDENTIFIER '=' /*1R*/ safe_assignment_expr
	| bad_identifier '=' /*1R*/ safe_assignment_expr
	//| error '=' /*1R*/ safe_assignment_expr
	;

constant_list :
	constant_name
	| constant_list ',' constant_name
	;

constant :
	modifiers TOK_CONSTANT constant_list ';'
	//| modifiers TOK_CONSTANT error ';'
	//| modifiers TOK_CONSTANT error TOK_LEX_EOF
	//| modifiers TOK_CONSTANT error '}'
	;

block_or_semi :
	block
	| ';'
	| TOK_LEX_EOF
	//| error
	;

open_paren_with_line_info :
	'('
	;

safe_apply_with_line_info :
	TOK_SAFE_APPLY
	;

///open_paren_or_safe_apply_with_line_info :
///	open_paren_with_line_info
///	| safe_apply_with_line_info
///	;

close_brace_or_missing :
	'}'
	| /*empty*/
	;

close_brace_or_eof :
	'}'
	| TOK_LEX_EOF
	;

open_bracket_with_line_info :
	'['
	;

close_bracket_or_missing :
	']'
	| /*empty*/
	;

start_function :
	/*empty*/
	;

optional_constant :
	/*empty*/
	| TOK_CONSTANT
	;

def :
	modifiers optional_attributes simple_type optional_constant TOK_IDENTIFIER start_function '(' arguments ')' block_or_semi
	//| modifiers optional_attributes simple_type optional_constant TOK_IDENTIFIER start_function error
	| modifiers optional_attributes simple_type optional_constant bad_identifier '(' arguments ')' block_or_semi
	| modifiers optional_attributes simple_type optional_constant name_list ';'
	| inheritance
	| import
	| constant
	| modifiers named_class
	| modifiers enum
	| annotation ';'
	| '@' TOK_CONSTANT ';'
	| typedef
	| static_assertion expected_semicolon
	//| error TOK_LEX_EOF
	//| error ';'
	//| error '}'
	| modifiers '{' program close_brace_or_eof
	;

static_assertion :
	TOK_STATIC_ASSERT '(' assignment_expr ',' assignment_expr ')'
	;

optional_dot_dot_dot :
	TOK_DOT_DOT_DOT
	| TOK_DOT_DOT
	| /*empty*/
	;

optional_identifier :
	TOK_IDENTIFIER
	| bad_identifier
	| /*empty*/
	;

optional_default_value :
	'=' /*1R*/ assignment_expr
	| /*empty*/
	;

new_arg_name :
	full_type optional_dot_dot_dot optional_identifier optional_default_value
	| open_bracket_with_line_info low_lvalue_list ']' optional_default_value
	;

func_args :
	'(' arguments ')'
	;

arguments :
	optional_comma
	| arguments2 optional_comma
	;

arguments2 :
	new_arg_name
	| arguments2 ',' new_arg_name
	| arguments2 ':' new_arg_name
	;

modifier :
	TOK_FINAL_ID
	| TOK_STATIC
	| TOK_EXTERN
	| TOK_OPTIONAL
	| TOK_PRIVATE
	| TOK_LOCAL_ID
	| TOK_PUBLIC
	| TOK_PROTECTED
	| TOK_INLINE
	| TOK_VARIANT
	| TOK_WEAK
	| TOK_CONTINUE
	| TOK_UNUSED
	;

magic_identifiers1 :
	TOK_FINAL_ID
	| TOK_STATIC
	| TOK_EXTERN
	| TOK_PRIVATE
	| TOK_LOCAL_ID
	| TOK_PUBLIC
	| TOK_PROTECTED
	| TOK_INLINE
	| TOK_OPTIONAL
	| TOK_VARIANT
	| TOK_WEAK
	| TOK_UNUSED
	| TOK_STATIC_ASSERT
	;

magic_identifiers2 :
	TOK_VOID_ID
	| TOK_MIXED_ID
	| TOK_ARRAY_ID
	| TOK_ATTRIBUTE_ID
	| TOK_DEPRECATED_ID
	| TOK_MAPPING_ID
	| TOK_MULTISET_ID
	| TOK_OBJECT_ID
	| TOK_FUNCTION_ID
	| TOK_FUNCTION_NAME
	| TOK_PROGRAM_ID
	| TOK_STRING_ID
	| TOK_FLOAT_ID
	| TOK_INT_ID
	| TOK_ENUM
	| TOK_TYPEDEF
	| TOK_UNKNOWN
	;

magic_identifiers3 :
	TOK_IF
	| TOK_DO
	| TOK_FOR
	| TOK_WHILE
	| TOK_ELSE
	| TOK_FOREACH
	| TOK_CATCH
	| TOK_GAUGE
	| TOK_CLASS
	| TOK_BREAK
	| TOK_CASE
	| TOK_CONSTANT
	| TOK_CONTINUE
	| TOK_DEFAULT
	| TOK_IMPORT
	| TOK_INHERIT
	| TOK_LAMBDA
	| TOK_PREDEF
	| TOK_RETURN
	| TOK_SSCANF
	| TOK_SWITCH
	| TOK_TYPEOF
	| TOK_GLOBAL
	;

magic_identifiers :
	magic_identifiers1
	| magic_identifiers2
	| magic_identifiers3
	;

magic_identifier :
	TOK_IDENTIFIER
	| TOK_RESERVED
	| magic_identifiers
	;

annotation :
	'@' constant_expr
	;

annotation_list :
	/*empty*/
	| annotation ':' annotation_list
	;

modifiers :
	annotation_list modifier_list
	;

modifier_list :
	/*empty*/
	| modifier_list modifier
	;

attribute :
	TOK_ATTRIBUTE_ID '(' string_constant optional_comma ')'
	| TOK_DEPRECATED_ID '(' ')'
	| TOK_DEPRECATED_ID
	;

optional_attributes :
	/*empty*/
	| optional_attributes attribute
	;

cast :
	open_paren_with_line_info type ')'
	;

soft_cast :
	open_bracket_with_line_info type ']'
	;

type2 :
	type
	| identifier_type
	;

simple_type :
	full_type
	;

simple_type2 :
	type2
	;

full_type :
	full_type '|' /*5L*/ type3
	| type3
	;

type :
	type '|' /*5L*/ type3
	| basic_type
	;

type3 :
	basic_type
	| identifier_type
	;

basic_type :
	TOK_FLOAT_ID
	| TOK_VOID_ID
	| TOK_MIXED_ID
	| TOK_UNKNOWN
	| TOK_AUTO_ID
	| TOK_STRING_ID opt_string_width
	| TOK_INT_ID opt_int_range
	| TOK_MAPPING_ID opt_mapping_type
	| TOK_FUNCTION_ID opt_function_type
	| TOK_OBJECT_ID opt_program_type
	| TOK_PROGRAM_ID opt_program_type
	| TOK_ARRAY_ID opt_array_type
	| TOK_MULTISET_ID opt_multiset_type
	| TOK_ATTRIBUTE_ID '(' string_constant ',' full_type ')'
	//| TOK_ATTRIBUTE_ID '(' string_constant error ')'
	//| TOK_ATTRIBUTE_ID error
	| TOK_DEPRECATED_ID '(' full_type ')'
	//| TOK_DEPRECATED_ID '(' error ')'
	;

identifier_type :
	id_expr
	| typeof
	;

number :
	TOK_NUMBER
	| '-' /*11L*/ TOK_NUMBER
	;

number_or_maxint :
	/*empty*/
	| number
	;

number_or_minint :
	/*empty*/
	| number
	;

expected_dot_dot :
	TOK_DOT_DOT
	| TOK_DOT_DOT_DOT
	;

safe_int_range_type_low :
	TOK_BITS
	| number_or_minint expected_dot_dot number_or_maxint
	| number
	//| error
	;

safe_int_range_type :
	safe_int_range_type_low
	| safe_int_range_type '|' /*5L*/ safe_int_range_type_low
	;

opt_int_range :
	/*empty*/
	| '(' safe_int_range_type ')'
	;

opt_string_width :
	opt_int_range
	| '(' safe_int_range_type ':' safe_int_range_type ')'
	| '(' safe_int_range_type ':' ')'
	| '(' ':' safe_int_range_type ')'
	;

opt_program_type :
	/*empty*/
	| '(' full_type ')'
	| '(' string_constant ')'
	//| '(' error ')'
	;

opt_function_type :
	'(' function_type_list optional_dot_dot_dot ':' full_type ')'
	| /*empty*/
	;

function_type_list :
	optional_comma
	| function_type_list2 optional_comma
	;

function_type_list2 :
	full_type
	| function_type_list2 ',' full_type
	;

opt_multiset_type :
	'(' full_type ')'
	| /*empty*/
	;

opt_array_type :
	'(' full_type ')'
	| /*empty*/
	| '(' safe_int_range_type ':' full_type ')'
	| '(' ':' full_type ')'
	| '(' safe_int_range_type ':' ')'
	| '(' safe_int_range_type ')'
	;

opt_mapping_type :
	'(' full_type ':' full_type ')'
	| /*empty*/
	;

name_list :
	new_name
	| name_list ',' new_name
	;

new_name :
	TOK_IDENTIFIER
	| bad_identifier
	| TOK_IDENTIFIER '=' /*1R*/ assignment_expr
	//| TOK_IDENTIFIER '=' /*1R*/ error
	| TOK_IDENTIFIER '=' /*1R*/ TOK_LEX_EOF
	| bad_identifier '=' /*1R*/ assignment_expr
	;

new_local_name :
	TOK_IDENTIFIER
	| bad_identifier
	| TOK_IDENTIFIER '=' /*1R*/ assignment_expr
	| bad_identifier '=' /*1R*/ assignment_expr
	//| TOK_IDENTIFIER '=' /*1R*/ error
	| TOK_IDENTIFIER '=' /*1R*/ TOK_LEX_EOF
	;

line_number_info :
	/*empty*/
	;

block :
	'{' line_number_info statements end_block
	;

end_block :
	'}'
	| TOK_LEX_EOF
	;

failsafe_block :
	block
	//| error
	| TOK_LEX_EOF
	;

local_name_list :
	new_local_name
	| local_name_list ',' new_local_name
	;

constant_expr :
	safe_assignment_expr
	;

local_constant_name :
	TOK_IDENTIFIER '=' /*1R*/ safe_assignment_expr
	| bad_identifier '=' /*1R*/ safe_assignment_expr
	//| error '=' /*1R*/ safe_assignment_expr
	;

local_constant_list :
	local_constant_name
	| local_constant_list ',' local_constant_name
	;

local_constant :
	TOK_CONSTANT local_constant_list ';'
	//| TOK_CONSTANT error ';'
	//| TOK_CONSTANT error TOK_LEX_EOF
	//| TOK_CONSTANT error '}'
	;

statements :
	/*empty*/
	| statements statement
	;

statement_with_semicolon :
	void_expr expected_semicolon
	;

normal_label_statement :
	statement_with_semicolon
	| import
	| cond
	| return
	| local_constant
	| block
	| break expected_semicolon
	| continue expected_semicolon
	//| error ';'
	//| error TOK_LEX_EOF
	//| error '}'
	| ';'
	;

statement :
	normal_label_statement
	| while
	| do
	| for
	| foreach
	| switch
	| case
	| default
	| labeled_statement
	| simple_type2 local_function
	| TOK_CONTINUE simple_type2 local_generator
	| implicit_modifiers named_class
	;

labeled_statement :
	TOK_IDENTIFIER ':' statement
	;

optional_label :
	TOK_IDENTIFIER
	| /*empty*/
	;

break :
	TOK_BREAK optional_label
	;

default :
	TOK_DEFAULT ':'
	| TOK_DEFAULT
	;

continue :
	TOK_CONTINUE optional_label
	;

start_lambda :
	/*empty*/
	;

implicit_identifier :
	/*empty*/
	;

lambda :
	TOK_LAMBDA line_number_info implicit_identifier start_lambda func_args failsafe_block
	//| TOK_LAMBDA line_number_info implicit_identifier start_lambda error
	;

local_function :
	TOK_IDENTIFIER start_function func_args failsafe_block
	//| TOK_IDENTIFIER start_function error
	;

local_generator :
	TOK_IDENTIFIER start_function func_args failsafe_block
	//| TOK_IDENTIFIER start_function error
	;

create_arg :
	modifiers simple_type optional_dot_dot_dot TOK_IDENTIFIER optional_default_value
	| modifiers simple_type bad_identifier
	;

create_arguments2 :
	create_arg
	| create_arguments2 ',' create_arg
	| create_arguments2 ':' create_arg
	;

create_arguments :
	optional_comma
	| create_arguments2 optional_comma
	;

optional_create_arguments :
	/*empty*/
	| start_lambda '(' create_arguments ')'
	;

failsafe_program :
	'{' program end_block
	//| error
	| TOK_LEX_EOF
	;

anon_class :
	TOK_CLASS line_number_info optional_create_arguments failsafe_program
	;

named_class :
	TOK_CLASS line_number_info simple_identifier optional_create_arguments failsafe_program
	;

simple_identifier :
	TOK_IDENTIFIER
	| bad_identifier
	;

enum_value :
	/*empty*/
	| '=' /*1R*/ safe_assignment_expr
	;

enum_def :
	/*empty*/
	| simple_identifier enum_value
	;

propagated_enum_value :
	/*empty*/
	;

enum_list :
	enum_def
	| enum_list ',' propagated_enum_value enum_def
	//| error
	;

enum :
	TOK_ENUM optional_identifier '{' enum_list end_block
	;

typedef :
	modifiers TOK_TYPEDEF full_type simple_identifier ';'
	;

save_locals :
	/*empty*/
	;

save_block_level :
	/*empty*/
	;

cond :
	TOK_IF save_block_level save_locals line_number_info '(' safe_init_expr end_cond statement optional_else_part
	;

end_cond :
	')'
	| '}'
	| TOK_LEX_EOF
	;

optional_else_part :
	/*empty*/
	| TOK_ELSE statement
	;

safe_lvalue :
	lvalue
	//| error
	;

safe_assignment_expr :
	assignment_expr
	| TOK_LEX_EOF
	//| error
	;

foreach_optional_lvalue :
	/*empty*/
	| safe_lvalue
	;

foreach_lvalues :
	',' safe_lvalue
	| ';' foreach_optional_lvalue ';' foreach_optional_lvalue
	;

foreach :
	TOK_FOREACH save_block_level save_locals line_number_info '(' assignment_expr foreach_lvalues end_cond statement
	;

do :
	TOK_DO line_number_info statement TOK_WHILE '(' safe_init_expr end_cond expected_semicolon
	| TOK_DO line_number_info statement TOK_WHILE TOK_LEX_EOF
	| TOK_DO line_number_info statement TOK_LEX_EOF
	;

expected_semicolon :
	';'
	| TOK_LEX_EOF
	;

for :
	TOK_FOR save_block_level save_locals line_number_info '(' optional_void_expr expected_semicolon for_expr expected_semicolon optional_void_expr end_cond statement
	;

while :
	TOK_WHILE save_block_level save_locals line_number_info '(' safe_init_expr end_cond statement
	;

for_expr :
	/*empty*/
	| safe_init_expr
	;

switch :
	TOK_SWITCH save_block_level save_locals line_number_info '(' safe_init_expr end_cond statement
	;

case :
	TOK_CASE safe_init_expr expected_colon
	| TOK_CASE safe_init_expr expected_dot_dot optional_init_expr expected_colon
	| TOK_CASE expected_dot_dot safe_init_expr expected_colon
	;

expected_colon :
	':'
	| ';'
	| '}'
	| TOK_LEX_EOF
	;

optional_continue :
	/*empty*/
	| TOK_CONTINUE
	| TOK_BREAK
	;

return :
	optional_continue TOK_RETURN expected_semicolon
	| optional_continue TOK_RETURN safe_init_expr expected_semicolon
	;

splice_expr :
	assignment_expr
	| '@' assignment_expr
	;

optional_comma :
	/*empty*/
	| ','
	;

expr_list :
	/*empty*/
	| expr_list2 optional_comma
	;

expr_list2 :
	splice_expr
	| expr_list2 ',' splice_expr
	;

m_expr_list :
	/*empty*/
	| m_expr_list2 optional_comma
	;

m_expr_list2 :
	assoc_pair
	| m_expr_list2 ',' assoc_pair
	//| m_expr_list2 ',' error
	;

assoc_pair :
	assignment_expr expected_colon assignment_expr
	//| assignment_expr expected_colon error
	;

literal_expr :
	string
	| TOK_NUMBER
	| TOK_FLOAT
	| open_paren_with_line_info '{' expr_list close_brace_or_missing ')'
	| open_paren_with_line_info open_bracket_with_line_info m_expr_list close_bracket_or_missing ')'
	| TOK_MULTISET_START line_number_info expr_list TOK_MULTISET_END
	| TOK_MULTISET_START line_number_info expr_list ')'
	//| TOK_MULTISET_START line_number_info error TOK_MULTISET_END
	//| TOK_MULTISET_START line_number_info error ')'
	//| TOK_MULTISET_START line_number_info error TOK_LEX_EOF
	//| TOK_MULTISET_START line_number_info error ';'
	//| TOK_MULTISET_START line_number_info error '}'
	;

unqualified_id_expr :
	low_id_expr
	| unqualified_id_expr '.' TOK_IDENTIFIER
	| unqualified_id_expr '.' bad_identifier
	;

qualified_ident :
	TOK_PREDEF TOK_COLON_COLON TOK_IDENTIFIER
	| TOK_PREDEF TOK_COLON_COLON bad_identifier
	| TOK_VERSION TOK_COLON_COLON TOK_IDENTIFIER
	| TOK_VERSION TOK_COLON_COLON bad_identifier
	| inherit_specifier TOK_IDENTIFIER
	| inherit_specifier bad_identifier
	//| inherit_specifier error
	| TOK_COLON_COLON TOK_IDENTIFIER
	| TOK_COLON_COLON bad_identifier
	;

qualified_id_expr :
	qualified_ident
	| qualified_id_expr '.' TOK_IDENTIFIER
	| qualified_id_expr '.' bad_identifier
	;

id_expr :
	unqualified_id_expr
	| qualified_id_expr
	;

primary_expr :
	literal_expr
	| catch
	| gauge
	| typeof
	| sscanf
	| static_assertion
	| lambda
	| implicit_modifiers anon_class
	| implicit_modifiers enum
	| apply
	| primary_expr '.' line_number_info TOK_IDENTIFIER
	| postfix_expr open_bracket_with_line_info '*' /*12L*/ ']'
	| postfix_expr open_bracket_with_line_info assignment_expr ']'
	| postfix_expr open_bracket_with_line_info range_bound expected_dot_dot range_bound ']'
	| postfix_expr TOK_SAFE_START_INDEX line_number_info assignment_expr ']'
	| postfix_expr TOK_SAFE_START_INDEX line_number_info range_bound expected_dot_dot range_bound ']'
	//| postfix_expr open_bracket_with_line_info error ']'
	//| postfix_expr open_bracket_with_line_info error TOK_LEX_EOF
	//| postfix_expr open_bracket_with_line_info error ';'
	//| postfix_expr open_bracket_with_line_info error '}'
	//| postfix_expr open_bracket_with_line_info error ')'
	| open_paren_with_line_info comma_expr ')'
	//| open_paren_with_line_info error ')'
	//| open_paren_with_line_info error TOK_LEX_EOF
	//| open_paren_with_line_info error ';'
	//| open_paren_with_line_info error '}'
	| postfix_expr TOK_ARROW line_number_info magic_identifier
	| postfix_expr TOK_SAFE_INDEX line_number_info TOK_IDENTIFIER
	//| postfix_expr TOK_ARROW line_number_info error
	;

postfix_expr :
	id_expr
	| primary_expr
	| bad_expr_ident
	| postfix_expr TOK_INC /*15N*/
	| postfix_expr TOK_DEC /*15N*/
	;

pow_expr :
	postfix_expr
	| postfix_expr TOK_POW /*14R*/ pow_expr
	//| postfix_expr TOK_POW /*14R*/ error
	;

unary_expr :
	pow_expr
	| TOK_INC /*15N*/ unary_expr
	| TOK_DEC /*15N*/ unary_expr
	| TOK_NOT /*13R*/ cast_expr
	| '+' /*11L*/ cast_expr
	| '~' /*13R*/ cast_expr
	| '-' /*11L*/ cast_expr
	;

cast_expr :
	unary_expr
	| cast cast_expr
	| soft_cast cast_expr
	;

mul_expr :
	cast_expr
	| mul_expr '*' /*12L*/ cast_expr
	| mul_expr '%' /*12L*/ cast_expr
	| mul_expr '/' /*12L*/ cast_expr
	//| mul_expr '*' /*12L*/ error
	//| mul_expr '%' /*12L*/ error
	//| mul_expr '/' /*12L*/ error
	;

add_expr :
	mul_expr
	| add_expr '+' /*11L*/ mul_expr
	| add_expr '-' /*11L*/ mul_expr
	//| add_expr '+' /*11L*/ error
	//| add_expr '-' /*11L*/ error
	;

shift_expr :
	add_expr
	| shift_expr TOK_LSH /*10L*/ add_expr
	| shift_expr TOK_RSH /*10L*/ add_expr
	//| shift_expr TOK_LSH /*10L*/ error
	//| shift_expr TOK_RSH /*10L*/ error
	;

rel_expr :
	shift_expr
	| rel_expr '>' /*9L*/ shift_expr
	| rel_expr TOK_GE /*9L*/ shift_expr
	| rel_expr '<' /*9L*/ shift_expr
	| rel_expr TOK_LE /*9L*/ shift_expr
	//| rel_expr '>' /*9L*/ error
	//| rel_expr TOK_GE /*9L*/ error
	//| rel_expr '<' /*9L*/ error
	//| rel_expr TOK_LE /*9L*/ error
	;

eq_expr :
	rel_expr
	| eq_expr TOK_EQ /*8L*/ rel_expr
	| eq_expr TOK_NE /*8L*/ rel_expr
	//| eq_expr TOK_EQ /*8L*/ error
	//| eq_expr TOK_NE /*8L*/ error
	;

and_expr :
	eq_expr
	| and_expr '&' /*7L*/ eq_expr
	//| and_expr '&' /*7L*/ error
	;

xor_expr :
	and_expr
	| xor_expr '^' /*6L*/ and_expr
	//| xor_expr '^' /*6L*/ error
	;

or_expr :
	xor_expr
	| or_expr '|' /*5L*/ xor_expr
	//| or_expr '|' /*5L*/ error
	;

land_expr :
	or_expr
	| land_expr TOK_LAND /*4L*/ or_expr
	//| land_expr TOK_LAND /*4L*/ error
	;

lor_expr :
	land_expr
	| lor_expr TOK_LOR /*3L*/ land_expr
	//| lor_expr TOK_LOR /*3L*/ error
	;

cond_expr :
	lor_expr
	| lor_expr '?' /*2R*/ comma_expr ':' assignment_expr
	;

assignment_expr :
	cond_expr
	| lor_expr assign assignment_expr
	//| lor_expr assign error
	| open_bracket_with_line_info low_lvalue_list ']' low_assign assignment_expr
	//| open_bracket_with_line_info low_lvalue_list ']' error
	;

low_assign :
	'=' /*1R*/
	;

assign :
	low_assign
	| TOK_AND_EQ
	| TOK_OR_EQ
	| TOK_XOR_EQ
	| TOK_LSH_EQ
	| TOK_RSH_EQ
	| TOK_ADD_EQ
	| TOK_SUB_EQ
	| TOK_MULT_EQ
	| TOK_POW_EQ
	| TOK_MOD_EQ
	| TOK_DIV_EQ
	| TOK_ATOMIC_GET_SET
	;

comma_expr :
	assignment_expr
	| comma_expr ',' assignment_expr
	;

init_expr :
	comma_expr
	| simple_type2 local_name_list
	;

safe_init_expr :
	init_expr
	//| error
	;

optional_init_expr :
	/*empty*/
	| safe_init_expr
	;

void_expr :
	init_expr
	;

optional_void_expr :
	/*empty*/
	| void_expr
	//| error
	;

optional_block :
	/*empty*/
	| '{' line_number_info start_lambda statements end_block
	;

apply :
	postfix_expr open_paren_with_line_info expr_list ')' optional_block
	| postfix_expr safe_apply_with_line_info expr_list ')' optional_block
	//| postfix_expr open_paren_or_safe_apply_with_line_info error ')' optional_block
	//| postfix_expr open_paren_or_safe_apply_with_line_info error TOK_LEX_EOF
	//| postfix_expr open_paren_or_safe_apply_with_line_info error ';'
	//| postfix_expr open_paren_or_safe_apply_with_line_info error '}'
	;

implicit_modifiers :
	/*empty*/
	;

string_or_identifier :
	TOK_IDENTIFIER
	| string
	;

inherit_specifier :
	string_or_identifier TOK_COLON_COLON
	| TOK_LOCAL_ID TOK_COLON_COLON
	| TOK_GLOBAL TOK_COLON_COLON
	| inherit_specifier TOK_LOCAL_ID TOK_COLON_COLON
	| inherit_specifier TOK_IDENTIFIER TOK_COLON_COLON
	| inherit_specifier bad_inherit TOK_COLON_COLON
	;

low_id_expr :
	TOK_IDENTIFIER
	| '.' TOK_IDENTIFIER
	| TOK_GLOBAL '.' TOK_IDENTIFIER
	| TOK_RESERVED
	;

range_bound :
	/*empty*/
	| init_expr
	| '<' /*9L*/ init_expr
	| TOK_LEX_EOF
	| '<' /*9L*/ TOK_LEX_EOF
	;

gauge :
	TOK_GAUGE catch_arg
	;

typeof :
	TOK_TYPEOF '(' assignment_expr ')'
	//| TOK_TYPEOF '(' error ')'
	//| TOK_TYPEOF '(' error '}'
	//| TOK_TYPEOF '(' error TOK_LEX_EOF
	//| TOK_TYPEOF '(' error ';'
	;

catch_arg :
	'(' init_expr ')'
	//| '(' error ')'
	//| '(' error TOK_LEX_EOF
	//| '(' error '}'
	//| '(' error ';'
	| block
	//| error
	;

catch :
	TOK_CATCH catch_arg
	;

sscanf :
	TOK_SSCANF '(' assignment_expr ',' assignment_expr lvalue_list ')'
	//| TOK_SSCANF '(' assignment_expr ',' assignment_expr error ')'
	//| TOK_SSCANF '(' assignment_expr ',' assignment_expr error TOK_LEX_EOF
	//| TOK_SSCANF '(' assignment_expr ',' assignment_expr error '}'
	//| TOK_SSCANF '(' assignment_expr ',' assignment_expr error ';'
	//| TOK_SSCANF '(' assignment_expr error ')'
	//| TOK_SSCANF '(' assignment_expr error TOK_LEX_EOF
	//| TOK_SSCANF '(' assignment_expr error '}'
	//| TOK_SSCANF '(' assignment_expr error ';'
	//| TOK_SSCANF '(' error ')'
	//| TOK_SSCANF '(' error TOK_LEX_EOF
	//| TOK_SSCANF '(' error '}'
	//| TOK_SSCANF '(' error ';'
	;

lvalue :
	assignment_expr
	| open_bracket_with_line_info low_lvalue_list ']'
	| type2 TOK_IDENTIFIER optional_default_value
	;

low_lvalue_list :
	lvalue lvalue_list
	;

lvalue_list :
	/*empty*/
	| ',' lvalue lvalue_list
	;

string_segment :
	TOK_STRING
	| TOK_FUNCTION_NAME
	;

string :
	string_segment
	| string string_segment
	;

string_constant :
	string
	| string_constant '+' /*11L*/ string
	;

real_string_constant :
	TOK_STRING
	| real_string_constant TOK_STRING
	| real_string_constant '+' /*11L*/ TOK_STRING
	;

bad_identifier :
	bad_inherit
	| TOK_LOCAL_ID
	;

bad_inherit :
	bad_expr_ident
	| TOK_ARRAY_ID
	| TOK_ATTRIBUTE_ID
	| TOK_BREAK
	| TOK_CASE
	| TOK_CATCH
	| TOK_CLASS
	| TOK_CONTINUE
	| TOK_DEFAULT
	| TOK_DEPRECATED_ID
	| TOK_DO
	| TOK_ENUM
	| TOK_FLOAT_ID
	| TOK_FOR
	| TOK_FOREACH
	| TOK_FUNCTION_ID
	| TOK_FUNCTION_NAME
	| TOK_GAUGE
	| TOK_IF
	| TOK_IMPORT
	| TOK_INT_ID
	| TOK_LAMBDA
	| TOK_MAPPING_ID
	| TOK_MIXED_ID
	| TOK_MULTISET_ID
	| TOK_OBJECT_ID
	| TOK_PROGRAM_ID
	| TOK_RETURN
	| TOK_SSCANF
	| TOK_STRING_ID
	| TOK_SWITCH
	| TOK_TYPEDEF
	| TOK_TYPEOF
	| TOK_UNKNOWN
	| TOK_VOID_ID
	| TOK_RESERVED
	;

bad_expr_ident :
	TOK_INLINE
	| TOK_PREDEF
	| TOK_PRIVATE
	| TOK_PROTECTED
	| TOK_PUBLIC
	| TOK_OPTIONAL
	| TOK_VARIANT
	| TOK_WEAK
	| TOK_STATIC
	| TOK_EXTERN
	| TOK_FINAL_ID
	| TOK_ELSE
	| TOK_INHERIT
	;

%%

%%

[\n\r\t ]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()
"#!".*  skip()

"->"	TOK_ARROW

/*
 * Basic value pushing
 */
"constant"	TOK_CONSTANT
[0-9]+"."[0-9]+	TOK_FLOAT
\"(\\.|[^"\n\r\\])*\"	TOK_STRING
'(\\.|[^'\n\r\\])+'  TOK_NUMBER
[0-9]+	TOK_NUMBER

/*
 * These are the predefined functions that can be accessed from Pike.
 */

"++"	TOK_INC
"--"	TOK_DEC
"return"	TOK_RETURN

"=="	TOK_EQ
">="	TOK_GE
"<="	TOK_LE
"!="	TOK_NE
"!"	TOK_NOT
"<<"	TOK_LSH
">>"	TOK_RSH
"&&"	TOK_LAND
"||"	TOK_LOR

"switch"	TOK_SWITCH
"sscanf"	TOK_SSCANF
"catch"	TOK_CATCH
"foreach"	TOK_FOREACH

/* This is the end of file marker used by the lexer
 * to enable nicer EOF in error handling.
 */
"__end_of_file__"	TOK_LEX_EOF

"+="	TOK_ADD_EQ
"&="	TOK_AND_EQ
"array"	TOK_ARRAY_ID
"__attribute__"	TOK_ATTRIBUTE_ID
"break"	TOK_BREAK
"case"	TOK_CASE
"class"	TOK_CLASS
"::"	TOK_COLON_COLON
"continue"	TOK_CONTINUE
"default"	TOK_DEFAULT
"__deprecated__"	TOK_DEPRECATED_ID
"/="	TOK_DIV_EQ
"do"	TOK_DO
".."	TOK_DOT_DOT
"..."	TOK_DOT_DOT_DOT
"else"	TOK_ELSE
"enum"	TOK_ENUM
"extern"	TOK_EXTERN
"float"	TOK_FLOAT_ID
"for"	TOK_FOR
"function"	TOK_FUNCTION_ID
"gauge"	TOK_GAUGE
"global"	TOK_GLOBAL
"if"	TOK_IF
"import"	TOK_IMPORT
"inherit"	TOK_INHERIT
"inline"	TOK_INLINE
"local"	TOK_LOCAL_ID
"final"	TOK_FINAL_ID
"__func__"	TOK_FUNCTION_NAME
"int"	TOK_INT_ID
"lambda"	TOK_LAMBDA
"multiset"	TOK_MULTISET_ID
">)"	TOK_MULTISET_END
"(<"	TOK_MULTISET_START
"<<="	TOK_LSH_EQ
"mapping"	TOK_MAPPING_ID
"mixed"	TOK_MIXED_ID
"%="	TOK_MOD_EQ
"*="	TOK_MULT_EQ
"object"	TOK_OBJECT_ID
"|="	TOK_OR_EQ
"**"	TOK_POW
"**="	TOK_POW_EQ
"private"	TOK_PRIVATE
"program"	TOK_PROGRAM_ID
"protected"	TOK_PROTECTED
"predef"	TOK_PREDEF
"public"	TOK_PUBLIC
">>="	TOK_RSH_EQ
"static"	TOK_STATIC
"_Static_assert"	TOK_STATIC_ASSERT
"string"	TOK_STRING_ID
"-="	TOK_SUB_EQ
"typedef"	TOK_TYPEDEF
"typeof"	TOK_TYPEOF
"__unknown__"	TOK_UNKNOWN
"__unused__"	TOK_UNUSED
"variant"	TOK_VARIANT
"version prefix"	TOK_VERSION
"void"	TOK_VOID_ID
"__weak__"	TOK_WEAK
"while"	TOK_WHILE
"^="	TOK_XOR_EQ
"optional"	TOK_OPTIONAL
"->?"	TOK_SAFE_INDEX
"[?"	TOK_SAFE_START_INDEX
"(?"	TOK_SAFE_APPLY
"bits"	TOK_BITS
"auto"	TOK_AUTO_ID
"?="	TOK_ATOMIC_GET_SET

"="	'='
"?"	'?'
"|"	'|'
"^"	'^'
"&"	'&'
">"	'>'
"<"	'<'
"+"	'+'
"-"	'-'
"*"	'*'
"%"	'%'
"/"	'/'
"~"	'~'
";"	';'
":"	':'
"}"	'}'
","	','
"("	'('
"["	'['
"]"	']'
")"	')'
"@"	'@'
"{"	'{'
"."	'.'

[A-Za-z_][A-Za-z0-9_]*	TOK_IDENTIFIER
"reserved identifier"	TOK_RESERVED

%%
