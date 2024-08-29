//From: https://github.com/facebookarchive/pfff/blob/ec21095ab7d445559576513a63314e794378c367/lang_js/parsing/parser_js.mly
/* Yoann Padioleau
 *
 * Copyright (C) 2010-2014 Facebook
 * Copyright (C) 2019-2020 r2c
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation, with the
 * special exception on linking described in file license.txt.
 *
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file
 * license.txt for more details.
 */

/*************************************************************************/
/* Tokens */
/*************************************************************************/

%token TUnknown  /* unrecognized token */
//%token EOF

/*-----------------------------------------*/
/* The space/comment tokens */
/*-----------------------------------------*/
/* coupling: Token_helpers.is_comment */
//%token TCommentSpace TCommentNewline
%token TComment

/*-----------------------------------------*/
/* The normal tokens */
/*-----------------------------------------*/

/* tokens with a value */
%token T_NUMBER
%token T_ID

%token T_STRING
%token T_ENCAPSED_STRING
%token T_REGEX

/*-----------------------------------------*/
/* Keyword tokens */
/*-----------------------------------------*/
/* coupling: if you add an element here, expand also ident_keyword_bis
 * and also maybe the special hack for regexp in lexer_js.mll */

%token T_FUNCTION T_CONST T_VAR T_LET
%token T_IF T_ELSE
%token T_WHILE T_FOR T_DO T_CONTINUE T_BREAK
%token T_SWITCH T_CASE T_DEFAULT
%token T_RETURN
%token T_THROW T_TRY T_CATCH T_FINALLY
%token T_YIELD T_ASYNC T_AWAIT
%token T_NEW T_IN T_OF T_THIS T_SUPER T_WITH
%token T_NULL T_FALSE T_TRUE
%token T_CLASS T_INTERFACE T_EXTENDS T_IMPLEMENTS T_STATIC T_GET T_SET T_CONSTRUCTOR
%token T_IMPORT T_EXPORT T_FROM T_AS
%token T_INSTANCEOF T_TYPEOF
%token T_DELETE  T_VOID
%token T_TYPE  T_ANY_TYPE T_NUMBER_TYPE T_BOOLEAN_TYPE T_STRING_TYPE  T_ENUM
%token T_DECLARE T_MODULE
%token T_PUBLIC T_PRIVATE T_PROTECTED  T_READONLY

/*-----------------------------------------*/
/* Punctuation tokens */
/*-----------------------------------------*/

/* syntax */
%token T_LCURLY T_RCURLY
%token T_LPAREN T_RPAREN
%token T_LBRACKET T_RBRACKET
%token T_SEMICOLON T_COMMA T_PERIOD T_COLON
%token T_PLING
%token T_ARROW
%token T_DOTS
%token T_BACKQUOTE
%token T_DOLLARCURLY
%token LDots RDots


/* operators */
%token T_OR T_AND
%token T_BIT_OR T_BIT_XOR T_BIT_AND
%token T_PLUS T_MINUS
%token T_DIV T_MULT T_MOD
%token T_NOT T_BIT_NOT
%token T_RSHIFT3_ASSIGN T_RSHIFT_ASSIGN T_LSHIFT_ASSIGN
%token T_BIT_XOR_ASSIGN T_BIT_OR_ASSIGN T_BIT_AND_ASSIGN T_MOD_ASSIGN T_DIV_ASSIGN
%token T_MULT_ASSIGN T_MINUS_ASSIGN T_PLUS_ASSIGN
%token T_ASSIGN
%token T_EQUAL T_NOT_EQUAL T_STRICT_EQUAL T_STRICT_NOT_EQUAL
%token T_LESS_THAN_EQUAL T_GREATER_THAN_EQUAL T_LESS_THAN T_GREATER_THAN
%token T_LSHIFT T_RSHIFT T_RSHIFT3
%token T_INCR T_DECR
%token T_EXPONENT

/*-----------------------------------------*/
/* XHP tokens */
/*-----------------------------------------*/
%token T_XHP_OPEN_TAG
/* The 'option' is for closing tags like </> */
%token T_XHP_CLOSE_TAG

/* ending part of the opening tag */
%token T_XHP_GT T_XHP_SLASH_GT

%token T_XHP_ATTR T_XHP_TEXT
/* '<>', see https://reactjs.org/docs/fragments.html#short-syntax */
%token T_XHP_SHORT_FRAGMENT

/*-----------------------------------------*/
/* Extra tokens: */
/*-----------------------------------------*/

/* Automatically Inserted Semicolon (ASI), see parse_js.ml */
%token T_VIRTUAL_SEMICOLON
/* fresh_token: the opening '(' of the parameters preceding an '->' */
%token T_LPAREN_ARROW
/* fresh_token: the first '{' in a semgrep pattern for objects */
//%token T_LCURLY_SEMGREP


/*************************************************************************/
/* Priorities */
/*************************************************************************/

/* must be at the top so that it has the lowest priority */
/* %nonassoc LOW_PRIORITY_RULE */

/* Special if / else associativity*/
%nonassoc p_IF
%nonassoc T_ELSE

/* %nonassoc p_POSTFIX */

/*
%right
 T_RSHIFT3_ASSIGN T_RSHIFT_ASSIGN T_LSHIFT_ASSIGN
 T_BIT_XOR_ASSIGN T_BIT_OR_ASSIGN T_BIT_AND_ASSIGN T_MOD_ASSIGN T_DIV_ASSIGN
 T_MULT_ASSIGN T_MINUS_ASSIGN T_PLUS_ASSIGN "="
*/

%left T_OR
%left T_AND
%left T_BIT_OR
%left T_BIT_XOR
%left T_BIT_AND
%left T_EQUAL T_NOT_EQUAL T_STRICT_EQUAL T_STRICT_NOT_EQUAL
%left T_LESS_THAN_EQUAL T_GREATER_THAN_EQUAL T_LESS_THAN T_GREATER_THAN T_IN T_INSTANCEOF
%left T_LSHIFT T_RSHIFT T_RSHIFT3
%left T_PLUS T_MINUS
%left T_MULT T_DIV T_MOD

%right T_EXPONENT
%right T_NOT T_BIT_NOT T_INCR T_DECR T_DELETE T_TYPEOF T_VOID T_AWAIT

%start main // module_item_or_eof sgrep_spatch_pattern

%%

option_T_COMMA_ :
	/*empty*/
	| T_COMMA
	;

option_T_CONST_ :
	/*empty*/
	| T_CONST
	;

option_annotation_ :
	/*empty*/
	| annotation
	;

option_binding_id_ :
	/*empty*/
	| binding_id
	;

option_class_heritage_ :
	/*empty*/
	| class_heritage
	;

option_expr_ :
	/*empty*/
	| expr
	;

option_expr_no_in_ :
	/*empty*/
	| expr_no_in
	;

option_generics_ :
	/*empty*/
	| generics
	;

option_id_ :
	/*empty*/
	| id
	;

option_initializeur_ :
	/*empty*/
	| initializeur
	;

option_interface_extends_ :
	/*empty*/
	| interface_extends
	;

option_sc_ :
	/*empty*/
	| sc
	;

list_xhp_attribute_ :
	/*empty*/
	| list_xhp_attribute_ xhp_attribute
	;

list_xhp_child_ :
	/*empty*/
	| list_xhp_child_ xhp_child
	;

nonempty_list_case_clause_ :
	case_clause
	| nonempty_list_case_clause_ case_clause
	;

nonempty_list_class_element_ :
	class_element
	| nonempty_list_class_element_ class_element
	;

nonempty_list_encaps_ :
	encaps
	| nonempty_list_encaps_ encaps
	;

nonempty_list_item_ :
	item
	| nonempty_list_item_ item
	;

nonempty_list_module_item_ :
	module_item
	| nonempty_list_module_item_ module_item
	;

nonempty_list_type_member_ :
	type_member
	| nonempty_list_type_member_ type_member
	;

listc_argument_ :
	argument
	| listc_argument_ T_COMMA argument
	;

listc_binding_property_ :
	binding_property
	| listc_binding_property_ T_COMMA binding_property
	;

listc_enum_member_ :
	enum_member
	| listc_enum_member_ T_COMMA enum_member
	;

listc_import_specifier_ :
	import_specifier
	| listc_import_specifier_ T_COMMA import_specifier
	;

listc_type__ :
	type_
	| listc_type__ T_COMMA type_
	;

listc_type_argument_ :
	type_argument
	| listc_type_argument_ T_COMMA type_argument
	;

listc_type_parameter_ :
	type_parameter
	| listc_type_parameter_ T_COMMA type_parameter
	;

listc_type_reference_ :
	type_reference
	| listc_type_reference_ T_COMMA type_reference
	;

listc_variable_decl_ :
	variable_decl
	| listc_variable_decl_ T_COMMA variable_decl
	;

listc_variable_decl_no_in_ :
	variable_decl_no_in
	| listc_variable_decl_no_in_ T_COMMA variable_decl_no_in
	;

listc2_property_name_and_value_ :
	property_name_and_value
	| listc2_property_name_and_value_ T_COMMA property_name_and_value
	;

optl_class_body_ :
	/*empty*/
	| class_body
	;

optl_elision_ :
	/*empty*/
	| elision
	;

optl_nonempty_list_case_clause__ :
	/*empty*/
	| nonempty_list_case_clause_
	;

optl_nonempty_list_encaps__ :
	/*empty*/
	| nonempty_list_encaps_
	;

optl_nonempty_list_module_item__ :
	/*empty*/
	| nonempty_list_module_item_
	;

optl_nonempty_list_type_member__ :
	/*empty*/
	| nonempty_list_type_member_
	;

optl_param_type_list_ :
	/*empty*/
	| param_type_list
	;

optl_stmt_list_ :
	/*empty*/
	| stmt_list
	;

main :
	program //EOF
	;

program :
	optl_nonempty_list_module_item__
	;

//module_item_or_eof :
//	module_item
//	| EOF
//	;

module_item :
	item
	| import_decl
	| export_decl
	;

item :
	stmt
	| decl
	;

decl :
	function_decl
	| generator_decl
	| async_decl
	| lexical_decl
	| class_decl
	| interface_decl
	| type_alias_decl
	| enum_decl
	;

//json :
//	expr EOF
//	;

//sgrep_spatch_pattern :
//	T_LCURLY_SEMGREP T_RCURLY
//	| T_LCURLY_SEMGREP listc2_property_name_and_value_ option_T_COMMA_ T_RCURLY
//	| assignment_expr_no_stmt EOF
//	| module_item EOF
//	| module_item nonempty_list_module_item_ EOF
//	;

import_decl :
	T_IMPORT import_clause from_clause sc
	| T_IMPORT module_specifier sc
	;

import_clause :
	import_default
	| import_default T_COMMA import_names
	| import_names
	;

import_default :
	binding_id
	;

import_names :
	T_MULT T_AS binding_id
	| named_imports
	| T_TYPE named_imports
	;

named_imports :
	T_LCURLY T_RCURLY
	| T_LCURLY listc_import_specifier_ T_RCURLY
	| T_LCURLY listc_import_specifier_ T_COMMA T_RCURLY
	;

from_clause :
	T_FROM module_specifier
	;

import_specifier :
	binding_id
	| id T_AS binding_id
	| T_DEFAULT T_AS binding_id
	| T_DEFAULT
	;

module_specifier :
	string_literal
	;

export_decl :
	T_EXPORT export_names
	| T_EXPORT variable_stmt
	| T_EXPORT decl
	| T_EXPORT T_DEFAULT decl
	| T_EXPORT T_DEFAULT assignment_expr_no_stmt sc
	| T_EXPORT T_DEFAULT object_literal sc
	;

export_names :
	T_MULT from_clause sc
	| export_clause from_clause sc
	| export_clause sc
	;

export_clause :
	T_LCURLY T_RCURLY
	| T_LCURLY listc_import_specifier_ T_RCURLY
	| T_LCURLY listc_import_specifier_ T_COMMA T_RCURLY
	;

variable_stmt :
	T_VAR listc_variable_decl_ sc
	;

lexical_decl :
	T_CONST listc_variable_decl_ sc
	| T_LET listc_variable_decl_ sc
	;

variable_decl :
	id option_annotation_ option_initializeur_
	| binding_pattern option_annotation_ initializeur
	;

initializeur :
	T_ASSIGN assignment_expr
	;

for_variable_decl :
	T_VAR listc_variable_decl_no_in_
	| T_CONST listc_variable_decl_no_in_
	| T_LET listc_variable_decl_no_in_
	;

variable_decl_no_in :
	id initializer_no_in
	| id
	| binding_pattern initializer_no_in
	;

for_single_variable_decl :
	T_VAR for_binding
	| T_CONST for_binding
	| T_LET for_binding
	;

for_binding :
	id option_annotation_
	| binding_pattern
	;

binding_pattern :
	object_binding_pattern
	| array_binding_pattern
	;

object_binding_pattern :
	T_LCURLY T_RCURLY
	| T_LCURLY listc_binding_property_ option_T_COMMA_ T_RCURLY
	;

binding_property :
	binding_id option_initializeur_
	| property_name T_COLON binding_element
	| T_DOTS binding_id
	| T_DOTS binding_pattern
	;

binding_element :
	binding_id option_initializeur_
	| binding_pattern option_initializeur_
	;

array_binding_pattern :
	T_LBRACKET T_RBRACKET
	| T_LBRACKET binding_element_list T_RBRACKET
	;

binding_start_element :
	T_COMMA
	| binding_element T_COMMA
	;

binding_start_list :
	binding_start_element
	| binding_start_list binding_start_element
	;

binding_element_list :
	binding_start_list
	| binding_elision_element
	| binding_start_list binding_elision_element
	;

binding_elision_element :
	binding_element
	| T_DOTS binding_id
	| T_DOTS binding_pattern
	;

function_decl :
	T_FUNCTION option_id_ call_signature T_LCURLY function_body T_RCURLY
	;

function_expr :
	T_FUNCTION option_id_ call_signature T_LCURLY function_body T_RCURLY
	;

call_signature :
	option_generics_ T_LPAREN formal_parameter_list_opt T_RPAREN option_annotation_
	;

function_body :
	optl_stmt_list_
	;

formal_parameter_list_opt :
	/*empty*/
	| formal_parameter_list option_T_COMMA_
	;

formal_parameter_list :
	formal_parameter_list T_COMMA formal_parameter
	| formal_parameter
	;

formal_parameter :
	id
	| id initializeur
	| binding_pattern option_annotation_ option_initializeur_
	| T_DOTS id
	| id annotation
	| id T_PLING
	| id T_PLING annotation
	| id annotation initializeur
	| T_DOTS id annotation
	| T_DOTS
	;

generator_decl :
	T_FUNCTION T_MULT id call_signature T_LCURLY function_body T_RCURLY
	;

generator_expr :
	T_FUNCTION T_MULT option_id_ call_signature T_LCURLY function_body T_RCURLY
	;

async_decl :
	T_ASYNC T_FUNCTION id call_signature T_LCURLY function_body T_RCURLY
	;

async_function_expr :
	T_ASYNC T_FUNCTION option_id_ call_signature T_LCURLY function_body T_RCURLY
	;

class_decl :
	T_CLASS option_binding_id_ option_generics_ class_tail
	;

class_tail :
	option_class_heritage_ T_LCURLY optl_class_body_ T_RCURLY
	;

class_heritage :
	T_EXTENDS type_or_expr
	;

class_body :
	nonempty_list_class_element_
	;

binding_id :
	id
	;

class_expr :
	T_CLASS option_binding_id_ option_generics_ class_tail
	;

class_element :
	method_definition
	| access_modifiers method_definition
	| property_name option_annotation_ option_initializeur_ sc
	| access_modifiers property_name option_annotation_ option_initializeur_ sc
	| sc
	| T_DOTS
	;

access_modifiers :
	access_modifiers access_modifier
	| access_modifier
	;

access_modifier :
	T_STATIC
	| T_PUBLIC
	| T_PRIVATE
	| T_PROTECTED
	| T_READONLY
	;

method_definition :
	property_name call_signature T_LCURLY function_body T_RCURLY
	| T_MULT property_name call_signature T_LCURLY function_body T_RCURLY
	| T_GET property_name option_generics_ T_LPAREN T_RPAREN option_annotation_ T_LCURLY function_body T_RCURLY
	| T_SET property_name option_generics_ T_LPAREN formal_parameter T_RPAREN option_annotation_ T_LCURLY function_body T_RCURLY
	| T_ASYNC property_name call_signature T_LCURLY function_body T_RCURLY
	;

interface_decl :
	T_INTERFACE binding_id option_generics_ option_interface_extends_ object_type
	;

interface_extends :
	T_EXTENDS listc_type_reference_
	;

type_alias_decl :
	T_TYPE id T_ASSIGN type_ sc
	;

enum_decl :
	option_T_CONST_ T_ENUM id T_LCURLY listc_enum_member_ option_T_COMMA_ T_RCURLY
	;

enum_member :
	property_name
	| property_name T_ASSIGN assignment_expr_no_stmt
	;

annotation :
	T_COLON type_
	;

complex_annotation :
	annotation
	| option_generics_ T_LPAREN optl_param_type_list_ T_RPAREN T_COLON type_
	;

type_ :
	primary_or_union_type
	| T_PLING type_
	| T_LPAREN_ARROW optl_param_type_list_ T_RPAREN T_ARROW type_
	;

primary_or_union_type :
	primary_or_intersect_type
	| union_type
	;

primary_or_intersect_type :
	primary_type
	| intersect_type
	;

primary_type :
	primary_type2
	| primary_type T_LBRACKET T_RBRACKET
	;

primary_type2 :
	predefined_type
	| type_reference
	| object_type
	| T_LBRACKET listc_type__ T_RBRACKET
	| T_STRING
	;

predefined_type :
	T_ANY_TYPE
	| T_NUMBER_TYPE
	| T_BOOLEAN_TYPE
	| T_STRING_TYPE
	| T_VOID
	| T_NULL
	;

type_reference :
	type_name
	| type_name type_arguments
	;

type_name :
	T_ID
	| module_name T_PERIOD T_ID
	;

module_name :
	T_ID
	| module_name T_PERIOD T_ID
	;

union_type :
	primary_or_union_type T_BIT_OR primary_type
	;

intersect_type :
	primary_or_intersect_type T_BIT_AND primary_type
	;

object_type :
	T_LCURLY optl_nonempty_list_type_member__ T_RCURLY
	;

type_member :
	property_name_typescript complex_annotation sc_or_comma
	| property_name_typescript T_PLING complex_annotation sc_or_comma
	| T_LBRACKET T_ID T_COLON T_STRING_TYPE T_RBRACKET complex_annotation sc_or_comma
	| T_LBRACKET T_ID T_COLON T_NUMBER_TYPE T_RBRACKET complex_annotation sc_or_comma
	;

property_name_typescript :
	id
	| string_literal
	| numeric_literal
	| ident_keyword
	;

param_type_list :
	param_type T_COMMA param_type_list
	| param_type
	| optional_param_type_list
	;

param_type :
	id complex_annotation
	;

optional_param_type :
	id T_PLING complex_annotation
	;

optional_param_type_list :
	optional_param_type T_COMMA optional_param_type_list
	| optional_param_type
	| rest_param_type
	;

rest_param_type :
	T_DOTS id complex_annotation
	;

generics :
	T_LESS_THAN listc_type_parameter_ T_GREATER_THAN
	;

type_parameter :
	T_ID
	;

type_arguments :
	T_LESS_THAN listc_type_argument_ T_GREATER_THAN
	| mismatched_type_arguments
	;

type_argument :
	type_
	;

mismatched_type_arguments :
	T_LESS_THAN type_argument_list1 T_RSHIFT
	| T_LESS_THAN type_argument_list2 T_RSHIFT3
	;

type_argument_list1 :
	nominal_type1
	| listc_type_argument_ T_COMMA nominal_type1
	;

nominal_type1 :
	type_name type_arguments1
	;

type_arguments1 :
	T_LESS_THAN listc_type_argument_
	;

type_argument_list2 :
	nominal_type2
	| listc_type_argument_ T_COMMA nominal_type2
	;

nominal_type2 :
	type_name type_arguments2
	;

type_arguments2 :
	T_LESS_THAN type_argument_list1
	;

type_or_expr :
	type_reference
	;

stmt :
	block
	| variable_stmt
	| empty_stmt
	| expr_stmt
	| if_stmt
	| iteration_stmt
	| continue_stmt
	| break_stmt
	| return_stmt
	| with_stmt
	| labelled_stmt
	| switch_stmt
	| throw_stmt
	| try_stmt
	| T_DOTS
	;

block :
	T_LCURLY optl_stmt_list_ T_RCURLY
	;

stmt_list :
	nonempty_list_item_
	;

empty_stmt :
	sc
	;

expr_stmt :
	expr_no_stmt sc
	;

if_stmt :
	T_IF T_LPAREN expr T_RPAREN stmt T_ELSE stmt
	| T_IF T_LPAREN expr T_RPAREN stmt %prec p_IF
	;

iteration_stmt :
	T_DO stmt T_WHILE T_LPAREN expr T_RPAREN sc
	| T_WHILE T_LPAREN expr T_RPAREN stmt
	| T_FOR T_LPAREN option_expr_no_in_ T_SEMICOLON option_expr_ T_SEMICOLON option_expr_ T_RPAREN stmt
	| T_FOR T_LPAREN for_variable_decl T_SEMICOLON option_expr_ T_SEMICOLON option_expr_ T_RPAREN stmt
	| T_FOR T_LPAREN left_hand_side_expr T_IN expr T_RPAREN stmt
	| T_FOR T_LPAREN for_single_variable_decl T_IN expr T_RPAREN stmt
	| T_FOR T_LPAREN left_hand_side_expr T_OF assignment_expr T_RPAREN stmt
	| T_FOR T_LPAREN for_single_variable_decl T_OF assignment_expr T_RPAREN stmt
	| T_FOR T_LPAREN T_DOTS T_RPAREN stmt
	;

initializer_no_in :
	T_ASSIGN assignment_expr_no_in
	;

continue_stmt :
	T_CONTINUE option_id_ sc
	;

break_stmt :
	T_BREAK option_id_ sc
	;

return_stmt :
	T_RETURN option_expr_ sc
	;

with_stmt :
	T_WITH T_LPAREN expr T_RPAREN stmt
	;

switch_stmt :
	T_SWITCH T_LPAREN expr T_RPAREN case_block
	;

labelled_stmt :
	id T_COLON stmt
	;

throw_stmt :
	T_THROW expr sc
	;

try_stmt :
	T_TRY block catch
	| T_TRY block finally
	| T_TRY block catch finally
	;

catch :
	T_CATCH T_LPAREN id T_RPAREN block
	| T_CATCH block
	| T_CATCH T_LPAREN binding_pattern T_RPAREN block
	;

finally :
	T_FINALLY block
	;

case_block :
	T_LCURLY optl_nonempty_list_case_clause__ T_RCURLY
	| T_LCURLY optl_nonempty_list_case_clause__ default_clause optl_nonempty_list_case_clause__ T_RCURLY
	;

case_clause :
	T_CASE expr T_COLON optl_stmt_list_
	;

default_clause :
	T_DEFAULT T_COLON optl_stmt_list_
	;

expr :
	assignment_expr
	| expr T_COMMA assignment_expr
	;

assignment_expr :
	conditional_expr_d1_
	| left_hand_side_expr__d1_ assignment_operator assignment_expr
	| arrow_function
	| T_YIELD
	| T_YIELD assignment_expr
	| T_YIELD T_MULT assignment_expr
	| left_hand_side_expr__d1_ T_AS type_
	| T_DOTS
	| LDots expr RDots
	;

left_hand_side_expr :
	left_hand_side_expr__d1_
	;

conditional_expr_d1_ :
	post_in_expr_d1_
	| post_in_expr_d1_ T_PLING assignment_expr T_COLON assignment_expr
	;

conditional_expr_primary_no_stmt_ :
	post_in_expr_primary_no_stmt_
	| post_in_expr_primary_no_stmt_ T_PLING assignment_expr T_COLON assignment_expr
	;

left_hand_side_expr__d1_ :
	new_expr_d1_
	| call_expr_d1_
	;

left_hand_side_expr__primary_no_stmt_ :
	new_expr_primary_no_stmt_
	| call_expr_primary_no_stmt_
	;

post_in_expr_d1_ :
	pre_in_expr_d1_
	| post_in_expr_d1_ T_LESS_THAN post_in_expr_d1_
	| post_in_expr_d1_ T_GREATER_THAN post_in_expr_d1_
	| post_in_expr_d1_ T_LESS_THAN_EQUAL post_in_expr_d1_
	| post_in_expr_d1_ T_GREATER_THAN_EQUAL post_in_expr_d1_
	| post_in_expr_d1_ T_INSTANCEOF post_in_expr_d1_
	| post_in_expr_d1_ T_IN post_in_expr_d1_
	| post_in_expr_d1_ T_EQUAL post_in_expr_d1_
	| post_in_expr_d1_ T_NOT_EQUAL post_in_expr_d1_
	| post_in_expr_d1_ T_STRICT_EQUAL post_in_expr_d1_
	| post_in_expr_d1_ T_STRICT_NOT_EQUAL post_in_expr_d1_
	| post_in_expr_d1_ T_BIT_AND post_in_expr_d1_
	| post_in_expr_d1_ T_BIT_XOR post_in_expr_d1_
	| post_in_expr_d1_ T_BIT_OR post_in_expr_d1_
	| post_in_expr_d1_ T_AND post_in_expr_d1_
	| post_in_expr_d1_ T_OR post_in_expr_d1_
	;

post_in_expr_primary_no_stmt_ :
	pre_in_expr_primary_no_stmt_
	| post_in_expr_primary_no_stmt_ T_LESS_THAN post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_GREATER_THAN post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_LESS_THAN_EQUAL post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_GREATER_THAN_EQUAL post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_INSTANCEOF post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_IN post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_EQUAL post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_NOT_EQUAL post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_STRICT_EQUAL post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_STRICT_NOT_EQUAL post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_BIT_AND post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_BIT_XOR post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_BIT_OR post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_AND post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_OR post_in_expr_d1_
	;

pre_in_expr_d1_ :
	left_hand_side_expr__d1_
	| pre_in_expr_d1_ T_INCR /* %prec p_POSTFIX*/
	| pre_in_expr_d1_ T_DECR /* %prec p_POSTFIX*/
	| T_INCR pre_in_expr_d1_
	| T_DECR pre_in_expr_d1_
	| T_DELETE pre_in_expr_d1_
	| T_VOID pre_in_expr_d1_
	| T_TYPEOF pre_in_expr_d1_
	| T_PLUS pre_in_expr_d1_
	| T_MINUS pre_in_expr_d1_
	| T_BIT_NOT pre_in_expr_d1_
	| T_NOT pre_in_expr_d1_
	| T_AWAIT pre_in_expr_d1_
	| pre_in_expr_d1_ T_MULT pre_in_expr_d1_
	| pre_in_expr_d1_ T_DIV pre_in_expr_d1_
	| pre_in_expr_d1_ T_MOD pre_in_expr_d1_
	| pre_in_expr_d1_ T_PLUS pre_in_expr_d1_
	| pre_in_expr_d1_ T_MINUS pre_in_expr_d1_
	| pre_in_expr_d1_ T_LSHIFT pre_in_expr_d1_
	| pre_in_expr_d1_ T_RSHIFT pre_in_expr_d1_
	| pre_in_expr_d1_ T_RSHIFT3 pre_in_expr_d1_
	| pre_in_expr_d1_ T_EXPONENT pre_in_expr_d1_
	;

pre_in_expr_primary_no_stmt_ :
	left_hand_side_expr__primary_no_stmt_
	| pre_in_expr_primary_no_stmt_ T_INCR
	| pre_in_expr_primary_no_stmt_ T_DECR
	| T_INCR pre_in_expr_d1_
	| T_DECR pre_in_expr_d1_
	| T_DELETE pre_in_expr_d1_
	| T_VOID pre_in_expr_d1_
	| T_TYPEOF pre_in_expr_d1_
	| T_PLUS pre_in_expr_d1_
	| T_MINUS pre_in_expr_d1_
	| T_BIT_NOT pre_in_expr_d1_
	| T_NOT pre_in_expr_d1_
	| T_AWAIT pre_in_expr_d1_
	| pre_in_expr_primary_no_stmt_ T_MULT pre_in_expr_d1_
	| pre_in_expr_primary_no_stmt_ T_DIV pre_in_expr_d1_
	| pre_in_expr_primary_no_stmt_ T_MOD pre_in_expr_d1_
	| pre_in_expr_primary_no_stmt_ T_PLUS pre_in_expr_d1_
	| pre_in_expr_primary_no_stmt_ T_MINUS pre_in_expr_d1_
	| pre_in_expr_primary_no_stmt_ T_LSHIFT pre_in_expr_d1_
	| pre_in_expr_primary_no_stmt_ T_RSHIFT pre_in_expr_d1_
	| pre_in_expr_primary_no_stmt_ T_RSHIFT3 pre_in_expr_d1_
	| pre_in_expr_primary_no_stmt_ T_EXPONENT pre_in_expr_d1_
	;

call_expr_d1_ :
	member_expr_d1_ arguments
	| call_expr_d1_ arguments
	| call_expr_d1_ T_LBRACKET expr T_RBRACKET
	| call_expr_d1_ T_PERIOD method_name
	| call_expr_d1_ template_literal
	| T_SUPER arguments
	;

call_expr_primary_no_stmt_ :
	member_expr_primary_no_stmt_ arguments
	| call_expr_primary_no_stmt_ arguments
	| call_expr_primary_no_stmt_ T_LBRACKET expr T_RBRACKET
	| call_expr_primary_no_stmt_ T_PERIOD method_name
	| call_expr_primary_no_stmt_ template_literal
	| T_SUPER arguments
	;

new_expr_d1_ :
	member_expr_d1_
	| T_NEW new_expr_d1_
	;

new_expr_primary_no_stmt_ :
	member_expr_primary_no_stmt_
	| T_NEW new_expr_d1_
	;

member_expr_d1_ :
	primary_expr_d1_
	| member_expr_d1_ T_LBRACKET expr T_RBRACKET
	| member_expr_d1_ T_PERIOD field_name
	| T_NEW member_expr_d1_ arguments
	| member_expr_d1_ template_literal
	| T_SUPER T_LBRACKET expr T_RBRACKET
	| T_SUPER T_PERIOD field_name
	| T_NEW T_PERIOD id
	;

member_expr_primary_no_stmt_ :
	primary_expr_primary_no_stmt_
	| member_expr_primary_no_stmt_ T_LBRACKET expr T_RBRACKET
	| member_expr_primary_no_stmt_ T_PERIOD field_name
	| T_NEW member_expr_d1_ arguments
	| member_expr_primary_no_stmt_ template_literal
	| T_SUPER T_LBRACKET expr T_RBRACKET
	| T_SUPER T_PERIOD field_name
	| T_NEW T_PERIOD id
	;

primary_expr_d1_ :
	primary_expr_no_braces
	| d1
	;

primary_expr_primary_no_stmt_ :
	primary_expr_no_braces
	| primary_no_stmt
	;

d1 :
	primary_with_stmt
	;

primary_with_stmt :
	object_literal
	| function_expr
	| class_expr
	| generator_expr
	| async_function_expr
	;

primary_expr_no_braces :
	T_THIS
	| id
	| null_literal
	| boolean_literal
	| numeric_literal
	| string_literal
	| regex_literal
	| array_literal
	| T_LPAREN expr T_RPAREN
	| xhp_html
	| template_literal
	;

boolean_literal :
	T_TRUE
	| T_FALSE
	;

null_literal :
	T_NULL
	;

numeric_literal :
	T_NUMBER
	;

regex_literal :
	T_REGEX
	;

string_literal :
	T_STRING
	;

assignment_operator :
	T_ASSIGN
	| T_MULT_ASSIGN
	| T_DIV_ASSIGN
	| T_MOD_ASSIGN
	| T_PLUS_ASSIGN
	| T_MINUS_ASSIGN
	| T_LSHIFT_ASSIGN
	| T_RSHIFT_ASSIGN
	| T_RSHIFT3_ASSIGN
	| T_BIT_AND_ASSIGN
	| T_BIT_XOR_ASSIGN
	| T_BIT_OR_ASSIGN
	;

array_literal :
	T_LBRACKET optl_elision_ T_RBRACKET
	| T_LBRACKET element_list_rev optl_elision_ T_RBRACKET
	;

element_list_rev :
	optl_elision_ element
	| element_list_rev T_COMMA element
	| element_list_rev T_COMMA elision element
	;

element :
	assignment_expr
	| T_DOTS assignment_expr
	;

object_literal :
	T_LCURLY T_RCURLY
	| T_LCURLY listc2_property_name_and_value_ option_T_COMMA_ T_RCURLY
	;

property_name_and_value :
	property_name T_COLON assignment_expr
	| method_definition
	| id
	| T_DOTS assignment_expr
	;

arguments :
	T_LPAREN argument_list_opt T_RPAREN
	;

argument_list_opt :
	/*empty*/
	| listc_argument_ option_T_COMMA_
	;

argument :
	assignment_expr
	| T_DOTS assignment_expr
	;

xhp_html :
	T_XHP_OPEN_TAG list_xhp_attribute_ T_XHP_GT list_xhp_child_ T_XHP_CLOSE_TAG
	| T_XHP_OPEN_TAG list_xhp_attribute_ T_XHP_SLASH_GT
	| T_XHP_SHORT_FRAGMENT list_xhp_child_ T_XHP_CLOSE_TAG
	;

xhp_child :
	T_XHP_TEXT
	| xhp_html
	| T_LCURLY expr option_sc_ T_RCURLY
	| T_LCURLY T_RCURLY
	;

xhp_attribute :
	T_XHP_ATTR T_ASSIGN xhp_attribute_value
	| T_LCURLY T_DOTS assignment_expr T_RCURLY
	| T_XHP_ATTR
	;

xhp_attribute_value :
	T_STRING
	| T_LCURLY expr option_sc_ T_RCURLY
	| T_DOTS
	;

template_literal :
	T_BACKQUOTE optl_nonempty_list_encaps__ T_BACKQUOTE
	;

encaps :
	T_ENCAPSED_STRING
	| T_DOLLARCURLY expr T_RCURLY
	;

arrow_function :
	T_ASYNC id T_ARROW arrow_body
	| id T_ARROW arrow_body
	| T_ASYNC T_LPAREN_ARROW formal_parameter_list_opt T_RPAREN option_annotation_ T_ARROW arrow_body
	| T_LPAREN_ARROW formal_parameter_list_opt T_RPAREN option_annotation_ T_ARROW arrow_body
	;

/* was called consise body in spec */
arrow_body :
	block
	/* see conflicts.txt for why the %prec */
	| assignment_expr_no_stmt /* %prec LOW_PRIORITY_RULE */
	/*ugly*/
	| function_expr
	;

expr_no_in :
	assignment_expr_no_in
	| expr_no_in T_COMMA assignment_expr_no_in
	;

assignment_expr_no_in :
	conditional_expr_no_in
	| left_hand_side_expr__d1_ assignment_operator assignment_expr_no_in
	;

conditional_expr_no_in :
	post_in_expr_no_in
	| post_in_expr_no_in T_PLING assignment_expr_no_in T_COLON assignment_expr_no_in
	;

post_in_expr_no_in :
	pre_in_expr_d1_
	| post_in_expr_no_in T_LESS_THAN post_in_expr_d1_
	| post_in_expr_no_in T_GREATER_THAN post_in_expr_d1_
	| post_in_expr_no_in T_LESS_THAN_EQUAL post_in_expr_d1_
	| post_in_expr_no_in T_GREATER_THAN_EQUAL post_in_expr_d1_
	| post_in_expr_no_in T_INSTANCEOF post_in_expr_d1_
	| post_in_expr_no_in T_EQUAL post_in_expr_d1_
	| post_in_expr_no_in T_NOT_EQUAL post_in_expr_d1_
	| post_in_expr_no_in T_STRICT_EQUAL post_in_expr_d1_
	| post_in_expr_no_in T_STRICT_NOT_EQUAL post_in_expr_d1_
	| post_in_expr_no_in T_BIT_AND post_in_expr_d1_
	| post_in_expr_no_in T_BIT_XOR post_in_expr_d1_
	| post_in_expr_no_in T_BIT_OR post_in_expr_d1_
	| post_in_expr_no_in T_AND post_in_expr_d1_
	| post_in_expr_no_in T_OR post_in_expr_d1_
	;

expr_no_stmt :
	assignment_expr_no_stmt
	| expr_no_stmt T_COMMA assignment_expr
	;

assignment_expr_no_stmt :
	conditional_expr_primary_no_stmt_
	| left_hand_side_expr__primary_no_stmt_ assignment_operator assignment_expr
	| arrow_function
	| T_YIELD
	| T_YIELD assignment_expr
	| T_YIELD T_MULT assignment_expr
	;

primary_no_stmt :
	TUnknown TComment
	;

id :
	T_ID
	| ident_semi_keyword
	;

ident_semi_keyword :
	T_FROM
	| T_OF
	| T_GET
	| T_SET
	| T_IMPLEMENTS
	| T_CONSTRUCTOR
	| T_TYPE
	| T_ANY_TYPE
	| T_NUMBER_TYPE
	| T_BOOLEAN_TYPE
	| T_STRING_TYPE
	| T_DECLARE
	| T_MODULE
	| T_PUBLIC
	| T_PRIVATE
	| T_PROTECTED
	| T_READONLY
	| T_AS
	| T_ASYNC
	;

ident_keyword :
	ident_keyword_bis
	;

ident_keyword_bis :
	T_FUNCTION
	| T_CONST
	| T_VAR
	| T_LET
	| T_IF
	| T_ELSE
	| T_WHILE
	| T_FOR
	| T_DO
	| T_CONTINUE
	| T_BREAK
	| T_SWITCH
	| T_CASE
	| T_DEFAULT
	| T_RETURN
	| T_THROW
	| T_TRY
	| T_CATCH
	| T_FINALLY
	| T_YIELD
	| T_AWAIT
	| T_NEW
	| T_IN
	| T_INSTANCEOF
	| T_DELETE
	| T_THIS
	| T_SUPER
	| T_WITH
	| T_NULL
	| T_FALSE
	| T_TRUE
	| T_CLASS
	| T_INTERFACE
	| T_EXTENDS
	| T_STATIC
	| T_IMPORT
	| T_EXPORT
	| T_ENUM
	| T_TYPEOF
	| T_VOID
	;

field_name :
	id
	| ident_keyword
	;

method_name :
	id
	| ident_keyword
	;

property_name :
	id
	| string_literal
	| numeric_literal
	| ident_keyword
	| T_LBRACKET assignment_expr T_RBRACKET
	;

sc :
	T_SEMICOLON
	| T_VIRTUAL_SEMICOLON
	;

sc_or_comma :
	sc
	| T_COMMA
	;

elision :
	T_COMMA
	| elision T_COMMA
	;

%%

/*Macros*/

SPACES	[ \t\r\n]+
COMMENT	"//"[^\r\n]*
C_STYLE_COMMENT [/][*](?s:.)*?[*][/]

%%
/*Lexer*/

{SPACES} skip()
{COMMENT}	skip()
{C_STYLE_COMMENT}	skip()

"<..."	LDots
"...>"	RDots
"&&"	T_AND
"any"	T_ANY_TYPE
"=>"	T_ARROW
"as"	T_AS
"="	T_ASSIGN
"async"	T_ASYNC
"await"	T_AWAIT
"`"	T_BACKQUOTE
"&"	T_BIT_AND
"&="	T_BIT_AND_ASSIGN
"~"	T_BIT_NOT
"|"	T_BIT_OR
"|="	T_BIT_OR_ASSIGN
"^"	T_BIT_XOR
"^="	T_BIT_XOR_ASSIGN
"boolean"	T_BOOLEAN_TYPE
"break"	T_BREAK
"case"	T_CASE
"catch"	T_CATCH
"class"	T_CLASS
":"	T_COLON
","	T_COMMA
TComment	TComment
"const"	T_CONST
"constructor"	T_CONSTRUCTOR
"continue"	T_CONTINUE
"declare"	T_DECLARE
"--"	T_DECR
"default"	T_DEFAULT
"delete"	T_DELETE
"/"	T_DIV
"/="	T_DIV_ASSIGN
"do"	T_DO
"${"	T_DOLLARCURLY
"..."	T_DOTS
"else"	T_ELSE
"enum"	T_ENUM
"=="	T_EQUAL
"**"	T_EXPONENT
"export"	T_EXPORT
"extends"	T_EXTENDS
"false"	T_FALSE
"finally"	T_FINALLY
"for"	T_FOR
"from"	T_FROM
"function"	T_FUNCTION
"get"	T_GET
">"	T_GREATER_THAN
">="	T_GREATER_THAN_EQUAL
"if"	T_IF
"implements"	T_IMPLEMENTS
"import"	T_IMPORT
"in"	T_IN
"++"	T_INCR
"instanceof"	T_INSTANCEOF
"interface"	T_INTERFACE
"["	T_LBRACKET
"{"	T_LCURLY
"<"	T_LESS_THAN
"<="	T_LESS_THAN_EQUAL
"let"	T_LET
"("	T_LPAREN
"(->"	T_LPAREN_ARROW
"<<"	T_LSHIFT
"<<="	T_LSHIFT_ASSIGN
"-"	T_MINUS
"-="	T_MINUS_ASSIGN
"%"	T_MOD
"%="	T_MOD_ASSIGN
"module"	T_MODULE
"*"	T_MULT
"*="	T_MULT_ASSIGN
"new"	T_NEW
"!"	T_NOT
"!="	T_NOT_EQUAL
"null"	T_NULL
"number"	T_NUMBER_TYPE
"of"	T_OF
"||"	T_OR
"."	T_PERIOD
T_PLING	T_PLING
"+"	T_PLUS
"+="	T_PLUS_ASSIGN
"private"	T_PRIVATE
"protected"	T_PROTECTED
"public"	T_PUBLIC
"]"	T_RBRACKET
"}"	T_RCURLY
"readonly"	T_READONLY
"return"	T_RETURN
")"	T_RPAREN
">>"	T_RSHIFT
">>>"	T_RSHIFT3
">>>="	T_RSHIFT3_ASSIGN
">>="	T_RSHIFT_ASSIGN
";"	T_SEMICOLON
"set"	T_SET
"static"	T_STATIC
"==="	T_STRICT_EQUAL
"!=="	T_STRICT_NOT_EQUAL
"string"	T_STRING_TYPE
"super"	T_SUPER
"switch"	T_SWITCH
"this"	T_THIS
"throw"	T_THROW
"true"	T_TRUE
"try"	T_TRY
"type"	T_TYPE
"typeof"	T_TYPEOF
"var"	T_VAR
T_VIRTUAL_SEMICOLON	T_VIRTUAL_SEMICOLON
"void"	T_VOID
"while"	T_WHILE
"with"	T_WITH
T_XHP_ATTR	T_XHP_ATTR
T_XHP_CLOSE_TAG	T_XHP_CLOSE_TAG
T_XHP_GT	T_XHP_GT
T_XHP_OPEN_TAG	T_XHP_OPEN_TAG
T_XHP_SHORT_FRAGMENT	T_XHP_SHORT_FRAGMENT
T_XHP_SLASH_GT	T_XHP_SLASH_GT
T_XHP_TEXT	T_XHP_TEXT
"yeld"	T_YIELD

TUnknown	TUnknown

"/"(\\.|[^/\n\r\\])+"/"	T_REGEX
0[xX][a-fA-F0-9]+|[0-9]+([Ee][+-]?[0-9]+)?|[0-9]*\.[0-9]+([Ee][+-]?[0-9]+)?	T_NUMBER
\"(\\.|[^\"\n\r\\])*\"|'(\\.|[^'\n\r\\])*'	T_STRING
"`"(\\.|[^`\n\r\\])*"`"	T_ENCAPSED_STRING

/* Order matter if identifier comes before keywords they are classified as identifier */
[a-zA-Z_$][a-zA-Z_0-9$]*	T_ID

%%

/*
# -*- org -*-

* short lambdas
#(this is similar to lang_php/parsing/conflicts.txt#short_lambdas)

** short body

When we parse 'x => x + 1', it could potentially be parsed as
'( x => x + 1)' or '(x => x) + 1' but we don't
want the second one, so we prefer to shift rather than reduce,
hence the %prec (just like for the dangling else) attached
to 'expr' below:

arrow_body:
 | block { }
 | expr  %prec LOW_PRIORITY_RULE { }

An additional complexity in Javascript compared to PHP is that
'{' is also used for object literal, so one has to use
an 'expr' which does not allow object literal, that is
'assignment_expression_no_statement'
(but do not forget to extend those mostly-copy-pasted rules
with extensions such as arrows, or async, otherwise you can not
even curry and write code like 'x => y => x + y').

** short parameters

The other conflict is that when we see '(x)' in '(x) => ...'
there is no way to know whether this is an expression (reduce) or
the parameter specification of a lambda (shift).

*** technique 1

To solve the conflict one can be more general and do:

 | TOPAR expr TCPAR T_ARROW arrow_body
     { ... }

but you then need to make sure that expr can only be an identifier.


A shift-reduce conflict then exists when we see '(x,' and we prefer to
shift per the following rule, expecting something like '(x,y) => ...'

arrow_function:
  | T_LPAREN identifier T_COMMA formal_parameter_list T_RPAREN
    annotation_opt T_ARROW arrow_body

rather than reduce per the following rule, expecting something like '(x,y) + ...'

expression:
 | expression T_COMMA assignment_expression

This means that something like '(x,y) + ...' does not currently parse;
fortunately, it is uncommon.

*** technique 2

A better technique is to use a parsing hack and retag the '(' T_LPAREN
in a T_LPAREN_ARROW when you see '( <xxx> ) =>' while matching
a fuzzy AST of the JS tokens. Then there is no ambiguity
and you can simply use formal_parameter_list_opt after this
special T_LPAREN_ARROW.

The ECMA grammar uses the CoverParenthesizedExpressionAndArrowParameterList
conflating rule which is ugly. The retag-token technique is far cleaner.

* trailing commas

Introducing trailing commas can introduce some shift/reduce conflicts
on rules using lists written in a non-left recursive way. Indeed on this:

formal_parameter_list_opt:
 | / *(*empty*)* /   { }
 | formal_parameter_list trailing_comma  { }

formal_parameter_list:
 | formal_parameter T_COMMA formal_parameter_list { }
 | formal_parameter  { }

Yacc generates this conflict:

238: shift/reduce conflict (shift 517, reduce 139) on T_COMMA
state 238
	formal_parameter_list : formal_parameter . T_COMMA formal_parameter_list  (138)
	formal_parameter_list : formal_parameter .  (139)

	T_COMMA  shift 517

because after one parameter and seeing a comma, it can not decide if this
comma is introducing a new parameter (shift) or if it's part of the
trailing comma after the formal_paramater_list (in which case it needs
to reduce).

You need to rewrite the rule left-recursive like this:

formal_parameter_list:
 | formal_parameter_list T_COMMA formal_parameter { }
 | formal_parameter  { }

Then after a comma it must always just reduce.

* ASI and continue, break, ++, --, etc.

The fact that the parser allows ASI (Automatic Semicolon Insertion)
introduces some ambiguities with the grammar. Indeed, given

 if(true) continue
 x;

can be parsed either as a 'if (true) continue x;' or
'if (true) continue; x;' with ASI. To avoid this ambiguity
the standard allows newline just after a continue but in that
case it always do an ASI. This means we need to have a fix_tokens
phase that inserts those semicolons.

* TODO Types and JSX

Flow does not allow '<T>(x:T):T => ...' since the leading '<T>' looks like
a JSX tag.

But Typescript has some files like that.

* TODO Import

When we start to process 'import *' and we allow
import as an identifier, then there is an ambiguity
and we don't know yet if we need to reduce import to an identifier
which starts a multiplication or to shift to allow an
import namespace declaration.

How to solve the ambiguity?
You could use a parsing hack and looking if you are in the
first column, but this does not always work.

TODO: parsing hack on import() ? retag import
as an identifier?
*/
