//From: https://github.com/codinuum/cca/blob/9004ea1c0ed1e2f66d8984cbc47e637d8838cfc0/src/ast/analyzing/langs/java/parsing/src/parser.mly
/*
   Copyright 2012-2024 Codinuum Software Lab <https://codinuum.com>

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
/*
 * A parser for the Java Language (based on the JLS 3rd ed.)
 *
 * parser.mly
 *
 */

 /* Literals */
%token IDENTIFIER
%token INTEGER_LITERAL
%token FLOATING_POINT_LITERAL
%token CHARACTER_LITERAL
%token STRING_LITERAL
%token TEXT_BLOCK
%token TRUE FALSE NULL

/* Separators */
%token AT AT__INTERFACE LPAREN RPAREN LPAREN__LAMBDA
%token LBRACE RBRACE LBRACKET RBRACKET SEMICOLON COMMA DOT
%token ELLIPSIS COLON_COLON

/* Operators */
%token LT
%token EQ GT EXCLAM TILDE QUESTION COLON
%token EQ_EQ LT_EQ GT_EQ EXCLAM_EQ AND_AND OR_OR PLUS_PLUS MINUS_MINUS
%token PLUS MINUS STAR SLASH AND OR HAT PERCENT LT_LT GT_GT GT_GT_GT
%token PLUS_EQ MINUS_EQ STAR_EQ SLASH_EQ AND_EQ OR_EQ HAT_EQ PERCENT_EQ
%token LT_LT_EQ GT_GT_EQ GT_GT_GT_EQ MINUS_GT MINUS_GT__CASE

/* Keywords */
%token ABSTRACT ASSERT BOOLEAN BREAK BYTE
%token CASE CATCH CHAR CLASS CONTINUE //CONST
%token DEFAULT DEFAULT__COLON DO DOUBLE ELSE ENUM EXTENDS
%token FINAL FINALLY FLOAT FOR //GOTO
%token IF IMPLEMENTS IMPORT INSTANCEOF INT INTERFACE LONG
%token NATIVE NEW PACKAGE PRIVATE PROTECTED PUBLIC RETURN
%token SHORT STATIC STRICTFP SUPER SWITCH SYNCHRONIZED
%token THIS THROW THROWS TRANSIENT TRY VOLATILE VOID WHILE

/* Contextual Keywords */
%token EXPORTS MODULE NON_SEALED OPEN OPENS PERMITS PROVIDES RECORD REQUIRES
%token SEALED TO TRANSITIVE USES WITH_ YIELD //VAR

/* AspectJ */
%token ASPECT POINTCUT WITHIN DECLARE
%token DOT_DOT

/* */
%token STMT
%token BLOCK_STMT
%token MARKER ERROR ERROR_STMT ERROR_MOD
//%token GT_7
//%token EOP

/*
%entry% :
	'\001' main
	| '\002' partial_assert_statement
	| '\003' partial_block_statement
	| '\004' reserved
*/

%start main

%%

block_statements_opt :
	/*empty*/
	| block_statement_oom
	;

list_element_value_comma_zom :
	/*empty*/
	| list_element_value_comma_zom annotation_type_member_declaration
	;

list_class_body_declaration_zom :
	/*empty*/
	| list_class_body_declaration_zom class_body_declaration
	;

list_interface_member_declaration_zom :
	/*empty*/
	| list_interface_member_declaration_zom interface_member_declaration
	;

list_module_directive_zom :
	/*empty*/
	| list_module_directive_zom module_directive
	;

list_record_body_declaration_zom :
	/*empty*/
	| list_record_body_declaration_zom record_body_declaration
	;

list_requires_modifier_zom :
	/*empty*/
	| list_requires_modifier_zom requires_modifier
	;

additional_bound_oom :
	additional_bound
	| additional_bound_oom additional_bound
	;

ann_dim_oom :
	ann_dim
	| ann_dim_oom ann_dim
	;

annotation_oom :
	annotation
	| annotation annotation_oom
	;

annotation_or_modifier_oom :
	annotation
	| adhoc_modifier
	| ERROR_MOD
	| annotation annotation_or_modifier_oom
	| adhoc_modifier annotation_or_modifier_oom
	| ERROR_MOD annotation_or_modifier_oom
	;

block_statement_oom :
	block_statement
	| block_statement_oom block_statement
	;

catch_clause_oom :
	catch_clause
	| catch_clause_oom catch_clause
	;

list_element_value_comma_oom :
	element_value COMMA
	| element_value COMMA list_element_value_comma_oom
	;

import_declaration_oom :
	import_declaration
	| import_declaration_oom import_declaration
	;

switch_label_oom :
	switch_label
	| switch_label_oom switch_label
	;

type_declaration_oom :
	type_declaration
	| type_declaration_oom type_declaration
	;

variable_modifier_oom :
	variable_modifier
	| variable_modifier_oom variable_modifier
	;

list_COMMA_class_type_oom :
	unann_class_or_interface_type
	| annotations unann_class_or_interface_type
	| list_COMMA_class_type_oom COMMA unann_class_or_interface_type
	| list_COMMA_class_type_oom COMMA annotations unann_class_or_interface_type
	;

list_COMMA_constant_expression_oom :
	expression
	| list_COMMA_constant_expression_oom COMMA expression
	;

list_COMMA_element_value_oom :
	element_value
	| element_value COMMA list_COMMA_element_value_oom
	;

list_COMMA_element_value_pair_oom :
	element_value_pair
	| list_COMMA_element_value_pair_oom COMMA element_value_pair
	;

list_COMMA_expr_or_err_oom :
	expression
	| ERROR
	| list_COMMA_expr_or_err_oom COMMA expression
	| list_COMMA_expr_or_err_oom COMMA ERROR
	;

list_COMMA_formal_parameter_oom :
	formal_parameter
	| list_COMMA_formal_parameter_oom COMMA formal_parameter
	;

list_COMMA_identifier_oom :
	identifier
	| list_COMMA_identifier_oom COMMA identifier
	;

list_COMMA_interface_type_oom :
	unann_class_or_interface_type
	| annotations unann_class_or_interface_type
	| list_COMMA_interface_type_oom COMMA unann_class_or_interface_type
	| list_COMMA_interface_type_oom annotations COMMA unann_class_or_interface_type
	;

list_COMMA_module_name_oom :
	module_name
	| list_COMMA_module_name_oom COMMA module_name
	;

list_COMMA_name_oom :
	name
	| list_COMMA_name_oom COMMA name
	;

list_COMMA_statement_expression_oom :
	statement_expression
	| list_COMMA_statement_expression_oom COMMA statement_expression
	;

list_COMMA_variable_declarator_oom :
	variable_declarator
	| list_COMMA_variable_declarator_oom COMMA variable_declarator
	;

//reserved :
//	GOTO
//	| CONST
//	| GT_7
//	| VAR
//	;

//partial_block_statement :
//	block_statement EOP
//	;

//partial_assert_statement :
//	assert_statement EOP
//	;

main :
	compilation_unit //EOF
	;

literal :
	INTEGER_LITERAL
	| FLOATING_POINT_LITERAL
	| TRUE
	| FALSE
	| CHARACTER_LITERAL
	| STRING_LITERAL
	| TEXT_BLOCK
	| NULL
	;

unann_type :
	unann_primitive_type
	| unann_reference_type
	;

unann_primitive_type :
	numeric_type
	| BOOLEAN
	;

numeric_type :
	integral_type
	| floating_point_type
	;

integral_type :
	BYTE
	| SHORT
	| INT
	| LONG
	| CHAR
	;

floating_point_type :
	FLOAT
	| DOUBLE
	;

unann_reference_type :
	unann_class_or_interface_type
	| unann_array_type
	;

unann_class_or_interface_type_spec :
	name
	| unann_class_or_interface_type_spec type_arguments DOT name
	| unann_class_or_interface_type_spec type_arguments DOT annotations name
	;

unann_class_or_interface_type :
	unann_class_or_interface_type_spec
	| unann_class_or_interface_type_spec type_arguments
	;

unann_array_type :
	name ann_dims
	| unann_primitive_type ann_dims
	| unann_class_or_interface_type_spec type_arguments DOT name ann_dims
	| unann_class_or_interface_type_spec type_arguments DOT annotations name ann_dims
	| unann_class_or_interface_type_spec type_arguments ann_dims
	;

type_arguments :
	LT GT
	| LT type_argument_list_1
	;

wildcard :
	QUESTION
	| annotations QUESTION
	| QUESTION EXTENDS unann_reference_type
	| QUESTION EXTENDS annotations unann_reference_type
	| annotations QUESTION EXTENDS unann_reference_type
	| annotations QUESTION EXTENDS annotations unann_reference_type
	| QUESTION SUPER unann_reference_type
	| QUESTION SUPER annotations unann_reference_type
	| annotations QUESTION SUPER unann_reference_type
	| annotations QUESTION SUPER annotations unann_reference_type
	;

wildcard_1 :
	QUESTION GT
	| annotations QUESTION GT
	| QUESTION EXTENDS reference_type_1
	| annotations QUESTION EXTENDS reference_type_1
	| QUESTION SUPER reference_type_1
	| annotations QUESTION SUPER reference_type_1
	;

wildcard_2 :
	QUESTION GT_GT
	| annotations QUESTION GT_GT
	| QUESTION EXTENDS reference_type_2
	| annotations QUESTION EXTENDS reference_type_2
	| QUESTION SUPER reference_type_2
	| annotations QUESTION SUPER reference_type_2
	;

wildcard_3 :
	QUESTION GT_GT_GT
	| annotations QUESTION GT_GT_GT
	| QUESTION EXTENDS reference_type_3
	| annotations QUESTION EXTENDS reference_type_3
	| QUESTION SUPER reference_type_3
	| annotations QUESTION SUPER reference_type_3
	;

reference_type_1 :
	unann_reference_type GT
	| annotations unann_reference_type GT
	| unann_class_or_interface_type_spec LT type_argument_list_2
	| annotations unann_class_or_interface_type_spec LT type_argument_list_2
	;

reference_type_2 :
	unann_reference_type GT_GT
	| annotations unann_reference_type GT_GT
	| unann_class_or_interface_type_spec LT type_argument_list_3
	| annotations unann_class_or_interface_type_spec LT type_argument_list_3
	;

reference_type_3 :
	unann_reference_type GT_GT_GT
	| annotations unann_reference_type GT_GT_GT
	;

type_argument_list :
	type_argument
	| type_argument_list COMMA type_argument
	;

type_argument_list_1 :
	type_argument_1
	| type_argument_list COMMA type_argument_1
	;

type_argument_list_2 :
	type_argument_2
	| type_argument_list COMMA type_argument_2
	;

type_argument_list_3 :
	type_argument_3
	| type_argument_list COMMA type_argument_3
	;

type_argument :
	unann_reference_type
	| annotations unann_reference_type
	| wildcard
	;

type_argument_1 :
	reference_type_1
	| wildcard_1
	;

type_argument_2 :
	reference_type_2
	| wildcard_2
	;

type_argument_3 :
	reference_type_3
	| wildcard_3
	;

name :
	simple_name
	| name DOT identifier
	| name DOT annotations identifier
	;

simple_name :
	identifier
	;

identifier :
	IDENTIFIER
	;

compilation_unit :
	/*empty*/
	| type_declaration_oom
	| import_declaration_oom
	| import_declaration_oom type_declaration_oom
	| package_declaration
	| package_declaration type_declaration_oom
	| package_declaration import_declaration_oom
	| package_declaration import_declaration_oom type_declaration_oom
	| package_declaration type_declaration_oom import_declaration_oom
	| package_declaration type_declaration_oom import_declaration_oom type_declaration_oom
	| package_declaration import_declaration_oom type_declaration_oom import_declaration_oom
	| package_declaration import_declaration_oom type_declaration_oom import_declaration_oom type_declaration_oom
	| module_declaration
	| import_declaration_oom module_declaration
	;

module_declaration :
	module_declaration_head module_body
	;

module_declaration_head :
	MODULE name
	| annotations MODULE name
	| OPEN MODULE name
	| annotations OPEN MODULE name
	;

module_body :
	LBRACE list_module_directive_zom RBRACE
	;

module_name :
	name
	;

module_directive :
	REQUIRES list_requires_modifier_zom name SEMICOLON
	| EXPORTS name SEMICOLON
	| EXPORTS name TO list_COMMA_module_name_oom SEMICOLON
	| OPENS name SEMICOLON
	| OPENS name TO list_COMMA_module_name_oom SEMICOLON
	| USES name SEMICOLON
	| PROVIDES name WITH_ list_COMMA_module_name_oom SEMICOLON
	;

requires_modifier :
	TRANSITIVE
	| STATIC
	;

package_declaration :
	PACKAGE name SEMICOLON
	| annotations PACKAGE name SEMICOLON
	| name PACKAGE name SEMICOLON
	| name annotations PACKAGE name SEMICOLON
	;

import_declaration :
	single_type_import_declaration
	| type_import_on_demand_declaration
	| static_single_type_import_declaration
	| static_type_import_on_demand_declaration
	| MARKER
	;

single_type_import_declaration :
	IMPORT name SEMICOLON
	;

static_single_type_import_declaration :
	IMPORT STATIC name DOT identifier SEMICOLON
	;

type_import_on_demand_declaration :
	IMPORT name DOT STAR SEMICOLON
	;

static_type_import_on_demand_declaration :
	IMPORT STATIC name DOT STAR SEMICOLON
	;

type_declaration :
	class_declaration
	| enum_declaration
	| record_declaration
	| interface_declaration
	| SEMICOLON
	| aspect_declaration
	| method_declaration
	| ERROR
	;

modifiers :
	annotation_or_modifier_oom
	;

adhoc_modifier :
	PUBLIC
	| PROTECTED
	| PRIVATE
	| STATIC
	| ABSTRACT
	| FINAL
	| NATIVE
	| SYNCHRONIZED
	| TRANSIENT
	| VOLATILE
	| STRICTFP
	| DEFAULT
	| SEALED
	| NON_SEALED
	;

annotations :
	annotation_oom
	;

annotation :
	AT annotation_body
	;

annotation_body :
	normal_annotation_body
	| marker_annotation_body
	| single_element_annotation_body
	;

normal_annotation_body :
	name LPAREN RPAREN
	| name LPAREN list_COMMA_element_value_pair_oom RPAREN
	;

marker_annotation_body :
	name
	;

single_element_annotation_body :
	name LPAREN element_value RPAREN
	;

element_value_pair :
	identifier EQ element_value
	;

element_value :
	annotation
	| element_value_array_initializer
	| conditional_expression
	;

element_value_array_initializer :
	LBRACE COMMA RBRACE
	| LBRACE RBRACE
	| LBRACE list_COMMA_element_value_oom RBRACE
	| LBRACE list_element_value_comma_oom RBRACE
	;

record_declaration_head0 :
	RECORD identifier
	| modifiers RECORD identifier
	;

record_declaration_head1 :
	record_declaration_head0
	| record_declaration_head0 type_parameters
	;

record_header :
	LPAREN RPAREN
	| LPAREN list_COMMA_formal_parameter_oom RPAREN
	;

record_declaration_head :
	record_declaration_head1 record_header
	| record_declaration_head1 record_header interfaces
	;

record_declaration :
	record_declaration_head record_body
	;

record_body :
	LBRACE list_record_body_declaration_zom RBRACE
	;

record_body_declaration :
	class_body_declaration
	| compact_constructor_declaration
	;

compact_constructor_declaration :
	identifier constructor_body
	| modifiers identifier constructor_body
	;

class_declaration_head0 :
	CLASS identifier
	| modifiers CLASS identifier
	;

class_declaration_head1 :
	class_declaration_head0
	| class_declaration_head0 type_parameters
	;

class_declaration_head :
	class_declaration_head1
	| class_declaration_head1 permits
	| class_declaration_head1 interfaces
	| class_declaration_head1 interfaces permits
	| class_declaration_head1 super_ext
	| class_declaration_head1 super_ext permits
	| class_declaration_head1 super_ext interfaces
	| class_declaration_head1 super_ext interfaces permits
	;

class_declaration :
	class_declaration_head class_body
	;

super_ext :
	EXTENDS unann_class_or_interface_type
	| EXTENDS annotations unann_class_or_interface_type
	;

interfaces :
	IMPLEMENTS list_COMMA_interface_type_oom
	| IMPLEMENTS list_COMMA_interface_type_oom IMPLEMENTS list_COMMA_interface_type_oom
	;

permits :
	PERMITS list_COMMA_name_oom
	;

class_body :
	LBRACE list_class_body_declaration_zom RBRACE
	;

class_body_declaration :
	class_member_declaration
	| static_initializer
	| instance_initializer
	| constructor_declaration
	| ERROR
	;

class_member_declaration :
	field_declaration
	| method_declaration
	| class_declaration
	| enum_declaration
	| record_declaration
	| interface_declaration
	| SEMICOLON
	| MARKER
	| aspect_declaration
	;

enum_declaration_head0 :
	ENUM IDENTIFIER
	| modifiers ENUM IDENTIFIER
	;

enum_declaration_head :
	enum_declaration_head0
	| enum_declaration_head0 interfaces
	;

enum_declaration :
	enum_declaration_head enum_body
	;

enum_body :
	LBRACE enum_body_declarations0 RBRACE
	| LBRACE COMMA enum_body_declarations0 RBRACE
	| LBRACE enum_constants enum_body_declarations0 RBRACE
	| LBRACE enum_constants COMMA enum_body_declarations0 RBRACE
	;

enum_constants :
	enum_constant
	| enum_constants COMMA enum_constant
	;

enum_constant_head :
	identifier
	| identifier LPAREN RPAREN
	| identifier LPAREN list_COMMA_expr_or_err_oom RPAREN
	| annotations identifier
	| annotations identifier LPAREN RPAREN
	| annotations identifier LPAREN list_COMMA_expr_or_err_oom RPAREN
	;

enum_constant :
	enum_constant_head
	| enum_constant_head class_body
	;

enum_body_declarations0 :
	/*empty*/
	| SEMICOLON list_class_body_declaration_zom
	;

field_declaration :
	unann_type list_COMMA_variable_declarator_oom SEMICOLON
	| modifiers unann_type list_COMMA_variable_declarator_oom SEMICOLON
	;

aspect_declaration_head0 :
	ASPECT identifier
	| modifiers ASPECT identifier
	;

aspect_declaration_head :
	aspect_declaration_head0
	| aspect_declaration_head0 interfaces
	| aspect_declaration_head0 super_ext
	| aspect_declaration_head0 super_ext interfaces
	;

aspect_declaration :
	aspect_declaration_head aspect_body
	;

aspect_body :
	LBRACE RBRACE
	| LBRACE aspect_body_declarations RBRACE
	;

aspect_body_declarations :
	aspect_body_declaration
	| aspect_body_declarations aspect_body_declaration
	;

aspect_body_declaration :
	class_body_declaration
	| pointcut_declaration
	| declare_declaration
	;

declare_declaration :
	DECLARE identifier COLON classname_pattern_expr super_ext SEMICOLON
	| DECLARE identifier COLON classname_pattern_expr interfaces SEMICOLON
	| DECLARE identifier COLON pointcut_expr COLON primary SEMICOLON
	| DECLARE identifier COLON pointcut_expr SEMICOLON
	| DECLARE identifier COLON classname_pattern_expr_list SEMICOLON
	;

classname_pattern_expr_list :
	classname_pattern_expr
	| classname_pattern_expr_list COMMA classname_pattern_expr
	;

pointcut_declaration :
	POINTCUT identifier LPAREN RPAREN SEMICOLON
	| POINTCUT identifier LPAREN list_COMMA_formal_parameter_oom RPAREN SEMICOLON
	| modifiers POINTCUT identifier LPAREN RPAREN SEMICOLON
	| modifiers POINTCUT identifier LPAREN list_COMMA_formal_parameter_oom RPAREN SEMICOLON
	| POINTCUT identifier LPAREN RPAREN COLON pointcut_expr SEMICOLON
	| POINTCUT identifier LPAREN list_COMMA_formal_parameter_oom RPAREN COLON pointcut_expr SEMICOLON
	| modifiers POINTCUT identifier LPAREN RPAREN COLON pointcut_expr SEMICOLON
	| modifiers POINTCUT identifier LPAREN list_COMMA_formal_parameter_oom RPAREN COLON pointcut_expr SEMICOLON
	;

pointcut_expr :
	or_pointcut_expr
	| pointcut_expr AND_AND or_pointcut_expr
	;

or_pointcut_expr :
	unary_pointcut_expr
	| or_pointcut_expr OR_OR unary_pointcut_expr
	;

unary_pointcut_expr :
	basic_pointcut_expr
	| EXCLAM unary_pointcut_expr
	;

basic_pointcut_expr :
	LPAREN pointcut_expr RPAREN
	| WITHIN LPAREN classname_pattern_expr RPAREN
	;

classname_pattern_expr :
	and_classname_pattern_expr
	| classname_pattern_expr OR_OR and_classname_pattern_expr
	;

and_classname_pattern_expr :
	unary_classname_pattern_expr
	| and_classname_pattern_expr AND_AND unary_classname_pattern_expr
	;

unary_classname_pattern_expr :
	basic_classname_pattern_expr
	| EXCLAM unary_classname_pattern_expr
	;

basic_classname_pattern_expr :
	name_pattern
	| name_pattern PLUS
	| LPAREN classname_pattern_expr RPAREN
	;

name_pattern :
	simple_name_pattern
	| name_pattern DOT simple_name_pattern
	| name_pattern DOT_DOT simple_name_pattern
	;

simple_name_pattern :
	STAR
	| identifier
	;

variable_declarator :
	variable_declarator_id
	| variable_declarator_id EQ variable_initializer
	;

variable_declarator_id :
	identifier
	| variable_declarator_id LBRACKET RBRACKET
	| variable_declarator_id annotations LBRACKET RBRACKET
	;

variable_initializer :
	expression
	| ERROR
	| array_initializer
	;

method_declaration :
	method_header method_body
	;

void :
	VOID
	;

method_header :
	unann_type method_declarator
	| unann_type method_declarator throws
	| void method_declarator
	| void method_declarator throws
	| modifiers unann_type method_declarator
	| modifiers unann_type method_declarator throws
	| modifiers void method_declarator
	| modifiers void method_declarator throws
	| type_parameters unann_type method_declarator
	| type_parameters unann_type method_declarator throws
	| type_parameters void method_declarator
	| type_parameters void method_declarator throws
	| type_parameters annotations unann_type method_declarator
	| type_parameters annotations unann_type method_declarator throws
	| type_parameters annotations void method_declarator
	| type_parameters annotations void method_declarator throws
	| modifiers type_parameters unann_type method_declarator
	| modifiers type_parameters unann_type method_declarator throws
	| modifiers type_parameters void method_declarator
	| modifiers type_parameters void method_declarator throws
	| modifiers type_parameters annotations unann_type method_declarator
	| modifiers type_parameters annotations unann_type method_declarator throws
	| modifiers type_parameters annotations void method_declarator
	| modifiers type_parameters annotations void method_declarator throws
	;

method_declarator_head :
	identifier LPAREN
	;

method_declarator :
	method_declarator_head RPAREN
	| method_declarator_head list_COMMA_formal_parameter_oom RPAREN
	| method_declarator_head identifier RPAREN
	| method_declarator LBRACKET RBRACKET
	| method_declarator annotations LBRACKET RBRACKET
	;

formal_parameter :
	unann_type variable_declarator_id
	| variable_modifier_oom unann_type variable_declarator_id
	| unann_type THIS
	| variable_modifier_oom unann_type THIS
	| unann_type identifier DOT THIS
	| variable_modifier_oom unann_type identifier DOT THIS
	;

variable_modifier :
	FINAL
	| annotation
	;

throws :
	THROWS list_COMMA_class_type_oom
	| THROWS list_COMMA_class_type_oom THROWS list_COMMA_class_type_oom
	;

method_body :
	block
	| SEMICOLON
	;

static_initializer :
	STATIC block
	;

instance_initializer :
	block
	;

constructor_declaration :
	constructor_declarator constructor_body
	| constructor_declarator throws constructor_body
	| type_parameters constructor_declarator constructor_body
	| type_parameters constructor_declarator throws constructor_body
	| modifiers constructor_declarator constructor_body
	| modifiers constructor_declarator throws constructor_body
	| modifiers type_parameters constructor_declarator constructor_body
	| modifiers type_parameters constructor_declarator throws constructor_body
	;

constructor_declarator_head :
	simple_name LPAREN
	;

constructor_declarator :
	constructor_declarator_head RPAREN
	| constructor_declarator_head list_COMMA_formal_parameter_oom RPAREN
	;

constructor_body :
	LBRACE block_statements_opt RBRACE
	| LBRACE explicit_constructor_invocation block_statements_opt RBRACE
	;

this :
	THIS
	;

super :
	SUPER
	;

explicit_constructor_invocation :
	this LPAREN RPAREN SEMICOLON
	| this LPAREN list_COMMA_expr_or_err_oom RPAREN SEMICOLON
	| type_arguments this LPAREN RPAREN SEMICOLON
	| type_arguments this LPAREN list_COMMA_expr_or_err_oom RPAREN SEMICOLON
	| super LPAREN RPAREN SEMICOLON
	| super LPAREN list_COMMA_expr_or_err_oom RPAREN SEMICOLON
	| type_arguments super LPAREN RPAREN SEMICOLON
	| type_arguments super LPAREN list_COMMA_expr_or_err_oom RPAREN SEMICOLON
	| primary DOT super LPAREN RPAREN SEMICOLON
	| primary DOT super LPAREN list_COMMA_expr_or_err_oom RPAREN SEMICOLON
	| primary DOT type_arguments super LPAREN RPAREN SEMICOLON
	| primary DOT type_arguments super LPAREN list_COMMA_expr_or_err_oom RPAREN SEMICOLON
	| name DOT super LPAREN RPAREN SEMICOLON
	| name DOT super LPAREN list_COMMA_expr_or_err_oom RPAREN SEMICOLON
	| name DOT type_arguments super LPAREN RPAREN SEMICOLON
	| name DOT type_arguments super LPAREN list_COMMA_expr_or_err_oom RPAREN SEMICOLON
	;

interface_declaration :
	normal_interface_declaration
	| annotation_type_declaration
	;

normal_interface_declaration_head0 :
	INTERFACE identifier
	| modifiers INTERFACE identifier
	;

normal_interface_declaration_head1 :
	normal_interface_declaration_head0
	| normal_interface_declaration_head0 type_parameters
	;

normal_interface_declaration_head :
	normal_interface_declaration_head1 extends_interfaces_opt
	| normal_interface_declaration_head1 extends_interfaces_opt permits
	;

normal_interface_declaration :
	normal_interface_declaration_head interface_body
	;

annotation_type_declaration_head :
	AT__INTERFACE INTERFACE identifier
	| modifiers AT__INTERFACE INTERFACE identifier
	;

annotation_type_declaration :
	annotation_type_declaration_head annotation_type_body
	;

annotation_type_body :
	LBRACE list_element_value_comma_zom RBRACE
	;

annotation_type_member_declaration :
	field_declaration
	| unann_type identifier LPAREN RPAREN default_value_opt SEMICOLON
	| unann_type identifier LPAREN RPAREN ann_dims default_value_opt SEMICOLON
	| modifiers unann_type identifier LPAREN RPAREN default_value_opt SEMICOLON
	| modifiers unann_type identifier LPAREN RPAREN ann_dims default_value_opt SEMICOLON
	| class_declaration
	| enum_declaration
	| interface_declaration
	| SEMICOLON
	;

default_value_opt :
	/*empty*/
	| default_value
	;

default_value :
	DEFAULT element_value
	;

ann_dims :
	ann_dim_oom
	;

ann_dim :
	LBRACKET RBRACKET
	| annotations LBRACKET RBRACKET
	| ELLIPSIS
	| annotations ELLIPSIS
	;

extends_interfaces_opt :
	/*empty*/
	| EXTENDS list_COMMA_interface_type_oom
	;

interface_body :
	LBRACE list_interface_member_declaration_zom RBRACE
	;

interface_member_declaration :
	field_declaration
	| interface_method_declaration
	| class_declaration
	| enum_declaration
	| interface_declaration
	| SEMICOLON
	;

interface_method_declaration :
	method_header method_body
	;

array_initializer :
	LBRACE RBRACE
	| LBRACE COMMA RBRACE
	| LBRACE variable_initializers RBRACE
	| LBRACE variable_initializers COMMA RBRACE
	;

variable_initializers :
	variable_initializer
	| variable_initializers COMMA variable_initializer
	;

block :
	LBRACE RBRACE
	| LBRACE block_statement_oom RBRACE
	;

block_statement :
	local_variable_declaration_statement
	| class_declaration
	| statement
	| enum_declaration
	| ERROR
	| MARKER
	| BLOCK_STMT
	;

local_variable_declaration_statement :
	local_variable_declaration SEMICOLON
	;

local_variable_declaration :
	unann_type list_COMMA_variable_declarator_oom
	| modifiers unann_type list_COMMA_variable_declarator_oom
	;

statement :
	statement_without_trailing_substatement
	| labeled_statement
	| if_then_statement
	| if_then_else_statement
	| while_statement
	| for_statement
	| enhanced_for_statement
	;

statement_no_short_if :
	statement_without_trailing_substatement
	| labeled_statement_no_short_if
	| if_then_else_statement_no_short_if
	| while_statement_no_short_if
	| for_statement_no_short_if
	| enhanced_for_statement_no_short_if
	;

statement_without_trailing_substatement :
	block
	| empty_statement
	| expression_statement
	| switch_statement
	| do_statement
	| break_statement
	| continue_statement
	| return_statement
	| synchronized_statement
	| throw_statement
	| try_statement
	| yield_statement
	| assert_statement
	| STMT
	| ERROR_STMT
	;

empty_statement :
	SEMICOLON
	;

labeled_statement_head :
	identifier COLON
	;

labeled_statement :
	labeled_statement_head statement
	;

labeled_statement_no_short_if :
	labeled_statement_head statement_no_short_if
	;

expression_statement :
	statement_expression SEMICOLON
	;

statement_expression :
	assignment
	| pre_increment_expression
	| pre_decrement_expression
	| post_increment_expression
	| post_decrement_expression
	| method_invocation
	| class_instance_creation_expression
	;

if_then_statement :
	IF LPAREN expression RPAREN statement
	| IF LPAREN ERROR RPAREN statement
	;

if_then_else_statement :
	IF LPAREN expression RPAREN statement_no_short_if ELSE statement
	| IF LPAREN ERROR RPAREN statement_no_short_if ELSE statement
	;

if_then_else_statement_no_short_if :
	IF LPAREN expression RPAREN statement_no_short_if ELSE statement_no_short_if
	| IF LPAREN ERROR RPAREN statement_no_short_if ELSE statement_no_short_if
	;

switch_statement :
	SWITCH LPAREN expression RPAREN switch_block
	| SWITCH LPAREN ERROR RPAREN switch_block
	;

switch_block :
	LBRACE RBRACE
	| LBRACE switch_label_oom RBRACE
	| LBRACE switch_block_statement_groups RBRACE
	| LBRACE switch_block_statement_groups switch_label_oom RBRACE
	| LBRACE switch_rules RBRACE
	;

switch_rules :
	switch_rule
	| switch_rules switch_rule
	;

switch_rule_label :
	CASE list_COMMA_constant_expression_oom MINUS_GT__CASE
	| DEFAULT MINUS_GT
	;

switch_rule :
	switch_rule_label expression SEMICOLON
	| switch_rule_label block
	| switch_rule_label throw_statement
	;

switch_block_statement_groups :
	switch_block_statement_group
	| switch_block_statement_groups switch_block_statement_group
	;

switch_block_statement_group :
	switch_label_oom block_statement_oom
	;

switch_label :
	CASE list_COMMA_constant_expression_oom COLON
	| DEFAULT__COLON COLON
	;

while_statement :
	WHILE LPAREN expression RPAREN statement
	| WHILE LPAREN ERROR RPAREN statement
	;

while_statement_no_short_if :
	WHILE LPAREN expression RPAREN statement_no_short_if
	| WHILE LPAREN ERROR RPAREN statement_no_short_if
	;

do_statement :
	DO statement WHILE LPAREN expression RPAREN SEMICOLON
	;

for_statement_head :
	FOR LPAREN
	;

javatype_vdid :
	unann_type variable_declarator_id
	;

enhanced_for_statement :
	for_statement_head javatype_vdid COLON expression RPAREN statement
	| for_statement_head javatype_vdid COLON ERROR RPAREN statement
	| for_statement_head modifiers javatype_vdid COLON expression RPAREN statement
	| for_statement_head modifiers javatype_vdid COLON ERROR RPAREN statement
	;

enhanced_for_statement_no_short_if :
	for_statement_head javatype_vdid COLON expression RPAREN statement_no_short_if
	| for_statement_head javatype_vdid COLON ERROR RPAREN statement_no_short_if
	| for_statement_head modifiers javatype_vdid COLON expression RPAREN statement_no_short_if
	| for_statement_head modifiers javatype_vdid COLON ERROR RPAREN statement_no_short_if
	;

for_statement :
	for_statement_head for_init_opt SEMICOLON expression_opt SEMICOLON for_update0 RPAREN statement
	;

for_statement_no_short_if :
	for_statement_head for_init_opt SEMICOLON expression_opt SEMICOLON for_update0 RPAREN statement_no_short_if
	;

for_init_opt :
	/*empty*/
	| for_init
	;

for_init :
	list_COMMA_statement_expression_oom
	| local_variable_declaration
	;

for_update0 :
	/*empty*/
	| for_update
	;

for_update :
	list_COMMA_statement_expression_oom
	;

break_statement :
	BREAK SEMICOLON
	| BREAK identifier SEMICOLON
	;

continue_statement :
	CONTINUE SEMICOLON
	| CONTINUE identifier SEMICOLON
	;

return_statement :
	RETURN expression_opt SEMICOLON
	;

throw_statement :
	THROW expression SEMICOLON
	| THROW ERROR SEMICOLON
	;

synchronized_statement :
	SYNCHRONIZED LPAREN expression RPAREN block
	| SYNCHRONIZED LPAREN ERROR RPAREN block
	;

try_head :
	TRY
	;

try_block :
	try_head block
	| try_head resource_spec block
	;

try_statement :
	try_block catch_clause_oom
	| try_block finally
	| try_block catch_clause_oom finally
	| try_block
	;

yield_statement :
	YIELD expression SEMICOLON
	;

resource_spec :
	LPAREN resource_list RPAREN
	| LPAREN resource_list SEMICOLON RPAREN
	;

resource_list :
	resource
	| resource_list SEMICOLON resource
	;

resource :
	local_variable_declaration
	| field_access
	| name
	;

catch_clause_header :
	CATCH
	;

catch_formal_parameter :
	catch_type variable_declarator_id
	| variable_modifier_oom catch_type variable_declarator_id
	;

catch_type :
	unann_class_or_interface_type
	| catch_type OR unann_class_or_interface_type
	| catch_type OR annotations unann_class_or_interface_type
	;

catch_clause :
	catch_clause_header LPAREN catch_formal_parameter RPAREN block
	;

finally :
	FINALLY block
	;

assert_statement :
	ASSERT expression SEMICOLON
	| ASSERT expression COLON expression SEMICOLON
	| ASSERT expression COLON ERROR SEMICOLON
	;

primary :
	primary_no_new_array
	| array_creation_init
	| array_creation_noinit
	;

primary_no_new_array :
	literal
	| this
	| LPAREN name RPAREN
	| LPAREN expression_nn RPAREN
	| class_instance_creation_expression
	| field_access
	| method_invocation
	| array_access
	| name DOT this
	| name DOT CLASS
	| name ann_dims DOT CLASS
	| unann_primitive_type DOT CLASS
	| unann_primitive_type ann_dims DOT CLASS
	| void DOT CLASS
	| method_reference
	;

method_reference :
	name COLON_COLON identifier
	| name COLON_COLON type_arguments identifier
	| primary COLON_COLON identifier
	| primary COLON_COLON type_arguments identifier
	| SUPER COLON_COLON identifier
	| SUPER COLON_COLON type_arguments identifier
	| name DOT SUPER COLON_COLON identifier
	| name DOT SUPER COLON_COLON type_arguments identifier
	| unann_primitive_type COLON_COLON NEW
	| unann_primitive_type COLON_COLON type_arguments NEW
	| unann_primitive_type ann_dims COLON_COLON NEW
	| unann_primitive_type ann_dims COLON_COLON type_arguments NEW
	| name COLON_COLON NEW
	| name COLON_COLON type_arguments NEW
	| name ann_dims COLON_COLON NEW
	| name ann_dims COLON_COLON type_arguments NEW
	;

class_instance_creation_head :
	NEW unann_class_or_interface_type
	| NEW annotations unann_class_or_interface_type
	| NEW type_arguments unann_class_or_interface_type
	| NEW type_arguments annotations unann_class_or_interface_type
	;

class_instance_creation_head_qualified :
	primary DOT NEW
	| primary DOT NEW type_arguments
	| name DOT NEW
	| name DOT NEW type_arguments
	;

class_instance_creation_expression :
	class_instance_creation_head LPAREN RPAREN
	| class_instance_creation_head LPAREN RPAREN class_body
	| class_instance_creation_head LPAREN list_COMMA_expr_or_err_oom RPAREN
	| class_instance_creation_head LPAREN list_COMMA_expr_or_err_oom RPAREN class_body
	| class_instance_creation_head_qualified identifier LPAREN RPAREN
	| class_instance_creation_head_qualified identifier LPAREN RPAREN class_body
	| class_instance_creation_head_qualified identifier LPAREN list_COMMA_expr_or_err_oom RPAREN
	| class_instance_creation_head_qualified identifier LPAREN list_COMMA_expr_or_err_oom RPAREN class_body
	| class_instance_creation_head_qualified identifier type_arguments LPAREN RPAREN
	| class_instance_creation_head_qualified identifier type_arguments LPAREN RPAREN class_body
	| class_instance_creation_head_qualified identifier type_arguments LPAREN list_COMMA_expr_or_err_oom RPAREN
	| class_instance_creation_head_qualified identifier type_arguments LPAREN list_COMMA_expr_or_err_oom RPAREN class_body
	;

array_creation_noinit :
	NEW unann_primitive_type dim_exprs
	| NEW annotations unann_primitive_type dim_exprs
	| NEW unann_class_or_interface_type dim_exprs
	| NEW annotations unann_class_or_interface_type dim_exprs
	| NEW unann_primitive_type dim_exprs ann_dims
	| NEW annotations unann_primitive_type dim_exprs ann_dims
	| NEW unann_class_or_interface_type dim_exprs ann_dims
	| NEW annotations unann_class_or_interface_type dim_exprs ann_dims
	;

array_creation_init :
	NEW unann_primitive_type ann_dims array_initializer
	| NEW annotations unann_primitive_type ann_dims array_initializer
	| NEW unann_class_or_interface_type ann_dims array_initializer
	| NEW annotations unann_class_or_interface_type ann_dims array_initializer
	;

dim_exprs :
	dim_expr
	| dim_exprs dim_expr
	;

dim_expr :
	LBRACKET expression RBRACKET
	;

field_access :
	primary DOT identifier
	| super DOT identifier
	| name DOT super DOT identifier
	;

method_invocation :
	name LPAREN RPAREN
	| name LPAREN list_COMMA_expr_or_err_oom RPAREN
	| primary DOT identifier LPAREN RPAREN
	| primary DOT identifier LPAREN list_COMMA_expr_or_err_oom RPAREN
	| primary DOT type_arguments identifier LPAREN RPAREN
	| primary DOT type_arguments identifier LPAREN list_COMMA_expr_or_err_oom RPAREN
	| name DOT type_arguments identifier LPAREN RPAREN
	| name DOT type_arguments identifier LPAREN list_COMMA_expr_or_err_oom RPAREN
	| super DOT identifier LPAREN RPAREN
	| super DOT identifier LPAREN list_COMMA_expr_or_err_oom RPAREN
	| super DOT type_arguments identifier LPAREN RPAREN
	| super DOT type_arguments identifier LPAREN list_COMMA_expr_or_err_oom RPAREN
	| name DOT super DOT identifier LPAREN RPAREN
	| name DOT super DOT identifier LPAREN list_COMMA_expr_or_err_oom RPAREN
	| name DOT super DOT type_arguments identifier LPAREN RPAREN
	| name DOT super DOT type_arguments identifier LPAREN list_COMMA_expr_or_err_oom RPAREN
	;

array_access :
	name LBRACKET expression RBRACKET
	| primary_no_new_array LBRACKET expression RBRACKET
	;

postfix_expression :
	primary
	| name
	| post_increment_expression
	| post_decrement_expression
	;

post_increment_expression :
	postfix_expression PLUS_PLUS
	;

post_decrement_expression :
	postfix_expression MINUS_MINUS
	;

unary_expression :
	pre_increment_expression
	| pre_decrement_expression
	| PLUS unary_expression
	| MINUS unary_expression
	| unary_expression_not_plus_minus
	;

pre_increment_expression :
	PLUS_PLUS unary_expression
	;

pre_decrement_expression :
	MINUS_MINUS unary_expression
	;

unary_expression_not_plus_minus :
	postfix_expression
	| TILDE unary_expression
	| EXCLAM unary_expression
	| cast_expression
	| switch_expression
	;

switch_expression :
	SWITCH LPAREN expression RPAREN switch_block
	| SWITCH LPAREN ERROR RPAREN switch_block
	;

unary_expression_not_plus_minus_or_lambda_expression :
	unary_expression_not_plus_minus
	| lambda_e
	;

lambda_e :
	lambda_parameters MINUS_GT lambda_b
	;

lambda_b :
	unary_expression_not_plus_minus
	| block
	;

cast_expression :
	LPAREN unann_primitive_type RPAREN unary_expression
	| LPAREN unann_primitive_type ann_dims RPAREN unary_expression
	| LPAREN annotations unann_primitive_type RPAREN unary_expression
	| LPAREN annotations unann_primitive_type ann_dims RPAREN unary_expression
	| LPAREN name RPAREN unary_expression_not_plus_minus_or_lambda_expression
	| LPAREN annotations name RPAREN unary_expression_not_plus_minus_or_lambda_expression
	| LPAREN name ann_dims RPAREN unary_expression_not_plus_minus_or_lambda_expression
	| LPAREN annotations name ann_dims RPAREN unary_expression_not_plus_minus_or_lambda_expression
	| LPAREN name type_arguments RPAREN unary_expression_not_plus_minus_or_lambda_expression
	| LPAREN name type_arguments ann_dims RPAREN unary_expression_not_plus_minus_or_lambda_expression
	| LPAREN annotations name type_arguments RPAREN unary_expression_not_plus_minus_or_lambda_expression
	| LPAREN annotations name type_arguments ann_dims RPAREN unary_expression_not_plus_minus_or_lambda_expression
	| LPAREN name type_arguments DOT unann_class_or_interface_type RPAREN unary_expression_not_plus_minus_or_lambda_expression
	| LPAREN name type_arguments DOT unann_class_or_interface_type ann_dims RPAREN unary_expression_not_plus_minus_or_lambda_expression
	| LPAREN name type_arguments DOT annotations unann_class_or_interface_type RPAREN unary_expression_not_plus_minus_or_lambda_expression
	| LPAREN name type_arguments DOT annotations unann_class_or_interface_type ann_dims RPAREN unary_expression_not_plus_minus_or_lambda_expression
	| LPAREN annotations name type_arguments DOT unann_class_or_interface_type RPAREN unary_expression_not_plus_minus_or_lambda_expression
	| LPAREN annotations name type_arguments DOT unann_class_or_interface_type ann_dims RPAREN unary_expression_not_plus_minus_or_lambda_expression
	| LPAREN annotations name type_arguments DOT annotations unann_class_or_interface_type RPAREN unary_expression_not_plus_minus_or_lambda_expression
	| LPAREN annotations name type_arguments DOT annotations unann_class_or_interface_type ann_dims RPAREN unary_expression_not_plus_minus_or_lambda_expression
	;

multiplicative_expression :
	unary_expression
	| multiplicative_expression STAR unary_expression
	| multiplicative_expression SLASH unary_expression
	| multiplicative_expression PERCENT unary_expression
	;

additive_expression :
	multiplicative_expression
	| additive_expression PLUS multiplicative_expression
	| additive_expression MINUS multiplicative_expression
	;

shift_expression :
	additive_expression
	| shift_expression LT_LT additive_expression
	| shift_expression GT_GT additive_expression
	| shift_expression GT_GT_GT additive_expression
	;

relational_expression :
	shift_expression
	| relational_expression LT shift_expression
	| relational_expression GT shift_expression
	| relational_expression LT_EQ shift_expression
	| relational_expression GT_EQ shift_expression
	;

instanceof_expression :
	relational_expression
	| instanceof_expression INSTANCEOF unann_reference_type
	| instanceof_expression INSTANCEOF annotations unann_reference_type
	| ERROR INSTANCEOF unann_reference_type
	| ERROR INSTANCEOF annotations unann_reference_type
	| instanceof_expression INSTANCEOF pattern
	| ERROR INSTANCEOF pattern
	;

pattern :
	unann_reference_type variable_declarator_id
	| annotations unann_reference_type variable_declarator_id
	| FINAL unann_reference_type variable_declarator_id
	| FINAL annotations unann_reference_type variable_declarator_id
	;

equality_expression :
	instanceof_expression
	| equality_expression EQ_EQ instanceof_expression
	| equality_expression EXCLAM_EQ instanceof_expression
	;

and_expression :
	equality_expression
	| and_expression AND equality_expression
	;

exclusive_or_expression :
	and_expression
	| exclusive_or_expression HAT and_expression
	;

inclusive_or_expression :
	exclusive_or_expression
	| inclusive_or_expression OR exclusive_or_expression
	;

conditional_and_expression :
	inclusive_or_expression
	| conditional_and_expression AND_AND inclusive_or_expression
	;

conditional_or_expression :
	conditional_and_expression
	| conditional_or_expression OR_OR conditional_and_expression
	;

conditional_expression :
	conditional_or_expression
	| conditional_or_expression QUESTION expression COLON conditional_expression
	| conditional_or_expression QUESTION expression COLON lambda_expression
	;

assignment_expression :
	conditional_expression
	| assignment
	;

assignment :
	postfix_expression EQ expression
	| postfix_expression EQ ERROR
	| postfix_expression STAR_EQ expression
	| postfix_expression STAR_EQ ERROR
	| postfix_expression SLASH_EQ expression
	| postfix_expression SLASH_EQ ERROR
	| postfix_expression PERCENT_EQ expression
	| postfix_expression PERCENT_EQ ERROR
	| postfix_expression PLUS_EQ expression
	| postfix_expression PLUS_EQ ERROR
	| postfix_expression MINUS_EQ expression
	| postfix_expression MINUS_EQ ERROR
	| postfix_expression LT_LT_EQ expression
	| postfix_expression LT_LT_EQ ERROR
	| postfix_expression GT_GT_EQ expression
	| postfix_expression GT_GT_EQ ERROR
	| postfix_expression GT_GT_GT_EQ expression
	| postfix_expression GT_GT_GT_EQ ERROR
	| postfix_expression AND_EQ expression
	| postfix_expression AND_EQ ERROR
	| postfix_expression HAT_EQ expression
	| postfix_expression HAT_EQ ERROR
	| postfix_expression OR_EQ expression
	| postfix_expression OR_EQ ERROR
	;

expression_opt :
	/*empty*/
	| expression
	;

expression :
	assignment_expression
	| lambda_expression
	;

lambda_expression :
	lambda_parameters MINUS_GT lambda_body
	;

lambda_parameters :
	identifier
	| LPAREN__LAMBDA RPAREN
	| LPAREN__LAMBDA list_COMMA_formal_parameter_oom RPAREN
	| LPAREN__LAMBDA list_COMMA_identifier_oom RPAREN
	;

lambda_body :
	expression
	| block
	;

type_parameters :
	LT type_parameter_list_1
	;

type_parameter_list :
	type_parameter
	| type_parameter_list COMMA type_parameter
	;

type_parameter_list_1 :
	type_parameter_1
	| type_parameter_list COMMA type_parameter_1
	;

type_variable :
	identifier
	| annotations identifier
	;

type_parameter :
	type_variable
	| type_variable type_bound
	;

type_parameter_1 :
	type_variable GT
	| type_variable type_bound_1
	;

type_bound :
	EXTENDS unann_reference_type
	| EXTENDS unann_reference_type additional_bound_list
	| EXTENDS annotations unann_reference_type
	| EXTENDS annotations unann_reference_type additional_bound_list
	;

type_bound_1 :
	EXTENDS reference_type_1
	| EXTENDS unann_reference_type additional_bound_list_1
	| EXTENDS annotations unann_reference_type additional_bound_list_1
	;

additional_bound_list :
	additional_bound_oom
	;

additional_bound_list_1 :
	additional_bound_1
	| additional_bound_list_1 additional_bound
	;

additional_bound :
	AND unann_class_or_interface_type
	| AND annotations unann_class_or_interface_type
	;

additional_bound_1 :
	AND reference_type_1
	;

postfix_expression_nn :
	primary
	| post_increment_expression
	| post_decrement_expression
	;

unary_expression_nn :
	pre_increment_expression
	| pre_decrement_expression
	| PLUS unary_expression
	| MINUS unary_expression
	| unary_expression_not_plus_minus_nn
	;

unary_expression_not_plus_minus_nn :
	postfix_expression_nn
	| TILDE unary_expression
	| EXCLAM unary_expression
	| cast_expression
	| switch_expression
	;

multiplicative_expression_nn :
	unary_expression_nn
	| multiplicative_expression_nn STAR unary_expression
	| multiplicative_expression_nn SLASH unary_expression
	| multiplicative_expression_nn PERCENT unary_expression
	| name STAR unary_expression
	| name SLASH unary_expression
	| name PERCENT unary_expression
	;

additive_expression_nn :
	multiplicative_expression_nn
	| additive_expression_nn PLUS multiplicative_expression
	| additive_expression_nn MINUS multiplicative_expression
	| name PLUS multiplicative_expression
	| name MINUS multiplicative_expression
	;

shift_expression_nn :
	additive_expression_nn
	| shift_expression_nn LT_LT additive_expression
	| shift_expression_nn GT_GT additive_expression
	| shift_expression_nn GT_GT_GT additive_expression
	| name LT_LT additive_expression
	| name GT_GT additive_expression
	| name GT_GT_GT additive_expression
	;

relational_expression_nn :
	shift_expression_nn
	| shift_expression_nn LT shift_expression
	| shift_expression_nn GT shift_expression
	| relational_expression_nn LT_EQ shift_expression
	| relational_expression_nn GT_EQ shift_expression
	| name LT shift_expression
	| name GT shift_expression
	| name LT_EQ shift_expression
	| name GT_EQ shift_expression
	;

instanceof_expression_nn :
	relational_expression_nn
	| name INSTANCEOF unann_reference_type
	| name INSTANCEOF annotations unann_reference_type
	| name INSTANCEOF pattern
	| instanceof_expression_nn INSTANCEOF unann_reference_type
	| instanceof_expression_nn INSTANCEOF annotations unann_reference_type
	| instanceof_expression_nn INSTANCEOF pattern
	;

equality_expression_nn :
	instanceof_expression_nn
	| equality_expression_nn EQ_EQ instanceof_expression
	| equality_expression_nn EXCLAM_EQ instanceof_expression
	| name EQ_EQ instanceof_expression
	| name EXCLAM_EQ instanceof_expression
	;

and_expression_nn :
	equality_expression_nn
	| and_expression_nn AND equality_expression
	| name AND equality_expression
	;

exclusive_or_expression_nn :
	and_expression_nn
	| exclusive_or_expression_nn HAT and_expression
	| name HAT and_expression
	;

inclusive_or_expression_nn :
	exclusive_or_expression_nn
	| inclusive_or_expression_nn OR exclusive_or_expression
	| name OR exclusive_or_expression
	;

conditional_and_expression_nn :
	inclusive_or_expression_nn
	| conditional_and_expression_nn AND_AND inclusive_or_expression
	| name AND_AND inclusive_or_expression
	;

conditional_or_expression_nn :
	conditional_and_expression_nn
	| conditional_or_expression_nn OR_OR conditional_and_expression
	| name OR_OR conditional_and_expression
	;

conditional_expression_nn :
	conditional_or_expression_nn
	| conditional_or_expression_nn QUESTION expression COLON conditional_expression
	| conditional_or_expression_nn QUESTION expression COLON lambda_expression
	| name QUESTION expression COLON conditional_expression
	| name QUESTION expression COLON lambda_expression
	;

assignment_expression_nn :
	conditional_expression_nn
	| assignment
	;

expression_nn :
	assignment_expression_nn
	| lambda_expression
	;

%%

hex_digit   [0-9a-fA-F]
unicode_escape   "\\u"{hex_digit}{4}

line_terminator   [\r\n]|"\r\n"

input_character   {unicode_escape}|[^\r\n]

white_space   [ \t\f]

not_star_not_slash   [^*/]|{unicode_escape}|"\r\n"
not_star   [^*]|{unicode_escape}|"\r\n"

/* 880-1023:Greek 2304-2431:Devanagari 4352-4607,43360-43391,44032-55215,55216-55295:Hangul */
java_letter   [A-Za-z_$] // 880-1023 1024-1279 2304-2431 4352-4607 43360-43391 44032-55215 55216-55295]
java_letter_or_digit   {java_letter}|[0-9]
identifier_chars   {java_letter}{java_letter_or_digit}*
identifier_or_keyword   {identifier_chars}

underscores   "_"+
non_zero_digit   [1-9]
digit   "0"|{non_zero_digit}
digits   {digit}|{digit}({digit}|"_")*{digit}
decimal_numeral   "0"|{non_zero_digit}{digits}?|{non_zero_digit}{underscores}{digits}

hex_digits   {hex_digit}|{hex_digit}({hex_digit}|"_")*{hex_digit}
hex_numeral   ("0x"|"0X"){hex_digits}

octal_digit   [0-7]
octal_digits   {octal_digit}|{octal_digit}({octal_digit}|"_")*{octal_digit}
octal_numeral   "0"{underscores}?{octal_digits}

binary_digit   [01]
binary_digits   {binary_digit}|{binary_digit}({binary_digit}|"_")*{binary_digit}
binary_numeral   ("0b"|"0B"){binary_digits}

integer_type_suffix   [lL]

decimal_integer_literal   {decimal_numeral}{integer_type_suffix}?
hex_integer_literal   {hex_numeral}{integer_type_suffix}?
octal_integer_literal   {octal_numeral}{integer_type_suffix}?
binary_integer_literal   {binary_numeral}{integer_type_suffix}?

integer_literal     {decimal_integer_literal}|{hex_integer_literal}|{octal_integer_literal}|{binary_integer_literal}

float_type_suffix   [fFdD]
signed_integer   [+-]?{digits}
exponent_part   [eE]{signed_integer}

decimal_floating_point_literal     {digits}"."{digits}?{exponent_part}?{float_type_suffix}?|"."{digits}{exponent_part}?{float_type_suffix}?|{digits}{exponent_part}|{digits}{float_type_suffix}|{digits}{exponent_part}{float_type_suffix}

hex_significand     {hex_numeral}"."?|("0x"|"0X"){hex_digits}?"."{hex_digits}

binary_exponent   [pP]{signed_integer}

hexadecimal_floating_point_literal     {hex_significand}{binary_exponent}{float_type_suffix}?

floating_point_literal     {decimal_floating_point_literal}|{hexadecimal_floating_point_literal}

boolean_literal   "true"|"false"

octal_escape     "\\"([0-7]|[0-7][0-7]|[0-3][0-7][0-7])
escape_sequence     ("\\"['"\\bfnrt])|{octal_escape}

single_character   {unicode_escape}|[^\r\n'\\]
character_literal     ("'"{single_character}"'")|("'"{escape_sequence}"'")

string_character     {unicode_escape}|[^\r\n"\\]|{escape_sequence}
string_literal   \"{string_character}*\"

text_block_quote   "\"\"\""
text_block_item   [^\\]

null_literal   "null"

literal   {integer_literal}|{floating_point_literal}|{boolean_literal}|{character_literal}|{string_literal}|{null_literal}

%%

[ \t\r\n\f\v]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"=="  EQ_EQ
"<="  LT_EQ
">="  GT_EQ
"!="  EXCLAM_EQ
"&&"  AND_AND
"||"  OR_OR
"++"  PLUS_PLUS
"--"  MINUS_MINUS
"-="  MINUS_EQ
"->"  MINUS_GT
"<<"  LT_LT
">>"  GT_GT
">>>"  GT_GT_GT
"+="  PLUS_EQ
"*="  STAR_EQ
"/="  SLASH_EQ
"&="  AND_EQ
"|="  OR_EQ
"^="  HAT_EQ
"%="  PERCENT_EQ
"<<="  LT_LT_EQ
">>="  GT_GT_EQ
">>>="  GT_GT_GT_EQ
"..."  ELLIPSIS
"::"  COLON_COLON
".."  DOT_DOT

"("  LPAREN
")"  RPAREN
"{"  LBRACE
"}"  RBRACE
"["  LBRACKET
"]"  RBRACKET
";"  SEMICOLON
","  COMMA
"."  DOT

"@"  AT

"="  EQ
">"  GT
"<"  LT
"!"  EXCLAM
"~"  TILDE
"?"  QUESTION
":"  COLON
"+"  PLUS
"-"  MINUS
"*"  STAR
"/"  SLASH
"&"  AND
"|"  OR
"^"  HAT
"%"  PERCENT

"abstract"      ABSTRACT
"assert"        ASSERT
"boolean"       BOOLEAN
"break"         BREAK
"byte"          BYTE
"case"          CASE
"catch"         CATCH
"char"          CHAR
"class"         CLASS
//"const"         CONST
"continue"      CONTINUE
"default"       DEFAULT
"do"            DO
"double"        DOUBLE
"else"          ELSE
"enum"          ENUM
"extends"       EXTENDS
"final"         FINAL
"finally"       FINALLY
"float"         FLOAT
"for"           FOR
//"goto"          GOTO
"if"            IF
"implements"    IMPLEMENTS
"import"        IMPORT
"instanceof"    INSTANCEOF
"int"           INT
"interface"     INTERFACE
"long"          LONG
"native"        NATIVE
"new"           NEW
"package"       PACKAGE
"private"       PRIVATE
"protected"     PROTECTED
"public"        PUBLIC
"return"        RETURN
"short"         SHORT
"static"        STATIC
"strictfp"      STRICTFP
"super"         SUPER
"switch"        SWITCH
"synchronized"  SYNCHRONIZED
"this"          THIS
"throw"         THROW
"throws"        THROWS
"transient"     TRANSIENT
"try"           TRY
"void"          VOID
"volatile"      VOLATILE
"while"         WHILE

"exports"  EXPORTS /* 9 */
"module"  MODULE /* 9 */
"open"  OPEN /* 9 */
"opens"  OPENS /* 9 */
"provides"  PROVIDES /* 9 */
"requires"  REQUIRES /* 9 */
"to"  TO /* 9 */
"transitive"  TRANSITIVE /* 9 */
"uses"  USES /* 9 */
"with"  WITH_ /* 9 */

//"var"  VAR /* 9 */

"yield"  YIELD /* 14 */

"record"  RECORD /* 16 */

"sealed"  SEALED /* 17 */
"non-sealed"  NON_SEALED /* 17 */
"permits"  PERMITS /* 17 */

"aspect"        ASPECT
"pointcut"      POINTCUT
"within"        WITHIN
"declare"       DECLARE

"true"   TRUE
"false"  FALSE

AT__INTERFACE	AT__INTERFACE
BLOCK_STMT	BLOCK_STMT
DEFAULT__COLON	DEFAULT__COLON
ERROR	ERROR
ERROR_MOD	ERROR_MOD
ERROR_STMT	ERROR_STMT
LPAREN__LAMBDA	LPAREN__LAMBDA
MARKER	MARKER
MINUS_GT__CASE	MINUS_GT__CASE
STMT	STMT
TEXT_BLOCK	TEXT_BLOCK

{integer_literal}         INTEGER_LITERAL
{floating_point_literal}  FLOATING_POINT_LITERAL
{character_literal}       CHARACTER_LITERAL
{string_literal}          STRING_LITERAL
{null_literal}            NULL

{identifier_or_keyword}	IDENTIFIER

%%
