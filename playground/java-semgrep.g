//From: https://github.com/semgrep/semgrep/blob/757814c7a2a811388d8616f65e7c4d9d9db1a53a/languages/java/menhir/parser_java.mly
/* Joust: a Java lexer, parser, and pretty-printer written in OCaml
 * Copyright (C) 2001  Eric C. Cooper <ecc@cmu.edu>
 * Copyright (C) 2022  Eric C. Cooper <ecc@cmu.edu>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation.
 *
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file
 * license.txt for more details.
 *
 * LALR(1) (ocamlyacc) grammar for Java
 *
 * Attempts to conform to:
 * The Java Language Specification, Second Edition
 * - James Gosling, Bill Joy, Guy Steele, Gilad Bracha
 *
 * Many modifications by Yoann Padioleau. Attempts to conform to:
 * The Java Language Specification, Third Edition, with some fixes from
 * http://www.cmis.brighton.ac.uk/staff/rnb/bosware/javaSyntax/syntaxV2.html
 * (broken link)
 *
 * Official (but incomplete) specification as of Java 14:
 * https://docs.oracle.com/javase/specs/jls/se14/html/jls-19.html
 *
 * More modifications by Yoann Padioleau to support more recent versions.
 * Copyright (C) 2011 Facebook
 * Copyright (C) 2020-2022 r2c
 *
 * Support for:
 *  - generics (partial)
 *  - enums, foreach, ...
 *  - annotations (partial)
 *  - lambdas
 */

%token ABSTRACT
%token AND
%token AND_AND
%token ARROW
%token ASSERT
%token AT
%token BREAK
%token CASE
%token CATCH
%token CLASS
%token CM
%token COLON
%token COLONCOLON
%token COMPL
%token COND
//%token CONST
%token CONTINUE
%token DECR
%token DEFAULT
%token DEFAULT_COLON
%token DIV
%token DO
%token DOT
%token DOTS
%token ELSE
%token ENUM
//%token EOF
%token EQ
%token EQ_EQ
%token EXTENDS
%token FALSE
%token FINAL
%token FINALLY
%token FOR
%token GE
//%token GOTO
%token GT
%token IDENTIFIER
%token IF
%token IMPLEMENTS
%token IMPORT
%token INCR
%token INSTANCEOF
%token INTERFACE
%token LB
%token LB_RB
%token LC
%token LDots
%token LE
%token LP
%token LP_LAMBDA
//%token LP_PARAM
%token LS
%token LT
%token LT_GENERIC
%token METAVAR_ELLIPSIS
%token MINUS
%token MOD
%token NATIVE
%token NEW
%token NOT
%token NOT_EQ
%token NULL
%token OPERATOR_EQ
%token OR
%token OR_OR
%token PACKAGE
%token TInt
%token PLUS
%token PRIMITIVE_TYPE
%token PRIVATE
%token PROTECTED
%token PUBLIC
%token RB
%token RC
%token RDots
//%token RECORD
%token RETURN
%token RP
%token SM
%token SRS
%token STATIC
%token STRICTFP
%token SUPER
%token SWITCH
%token SYNCHRONIZED
%token TChar
//%token TComment
//%token TCommentNewline
//%token TCommentSpace
%token TFloat
%token THIS
%token THROW
%token THROWS
%token TIMES
%token TRANSIENT
%token TRUE
%token TRY
%token TString
//%token TUnknown
%token URS
%token VAR
%token VOID
%token VOLATILE
%token WHILE
%token XOR

%start goal

%%

option_CM_ :
	/*empty*/
	| CM
	;

option_SM_ :
	/*empty*/
	| SM
	;

option_STATIC_ :
	/*empty*/
	| STATIC
	;

option_class_body_ :
	/*empty*/
	| class_body
	;

option_expression_ :
	/*empty*/
	| expression
	;

option_finally_ :
	/*empty*/
	| finally
	;

option_identifier_ :
	/*empty*/
	| identifier
	;

option_super_ :
	/*empty*/
	| super
	;

list_annotation_type_element_declaration_ :
	/*empty*/
	| list_annotation_type_element_declaration_ annotation_type_element_declaration
	;

list_block_statement_ :
	/*empty*/
	| list_block_statement_oom
	;

list_block_statement_oom :
	block_statement
	| list_block_statement_oom block_statement
	;

list_catch_clause_ :
	/*empty*/
	| catch_clause list_catch_clause_
	;

list_class_body_declaration_ :
	/*empty*/
	| list_class_body_declaration_ class_body_declaration
	;

list_interface_member_declaration_ :
	/*empty*/
	| list_interface_member_declaration_ interface_member_declaration
	;

list_method_declaration_ :
	/*empty*/
	| list_method_declaration_ method_declaration
	;

list_type_declaration_ :
	/*empty*/
	| type_declaration list_type_declaration_
	;

list_variable_modifier_ :
	/*empty*/
	| list_variable_modifier_ variable_modifier
	;

nonempty_list_block_statement_ :
	block_statement
	| nonempty_list_block_statement_ block_statement
	;

nonempty_list_catch_clause_ :
	catch_clause
	| catch_clause nonempty_list_catch_clause_
	;

nonempty_list_dim_expr_ :
	dim_expr
	| nonempty_list_dim_expr_ dim_expr
	;

nonempty_list_import_declaration_ :
	import_declaration
	| nonempty_list_import_declaration_ import_declaration
	;

//nonempty_list_item_ :
//	item
//	| item nonempty_list_item_
//	;

nonempty_list_switch_label_ :
	switch_label
	| switch_label nonempty_list_switch_label_
	;

nonempty_list_variable_modifier_ :
	variable_modifier
	| variable_modifier nonempty_list_variable_modifier_
	;

optl_enum_body_declarations_ :
	/*empty*/
	| enum_body_declarations
	;

optl_extends_interfaces_ :
	/*empty*/
	| extends_interfaces
	;

optl_for_update_ :
	/*empty*/
	| for_update
	;

optl_interfaces_ :
	/*empty*/
	| interfaces
	;

optl_listc_argument__ :
	/*empty*/
	| listc_argument_
	;

optl_listc_formal_parameter__ :
	/*empty*/
	| listc_formal_parameter_
	;

optl_listc_type_argument__ :
	/*empty*/
	| listc_type_argument_
	;

optl_throws_ :
	/*empty*/
	| throws
	;

optl_type_parameters_ :
	/*empty*/
	| type_parameters
	;

listc_argument_ :
	argument
	| listc_argument_ CM argument
	;

listc_element_value_or_dots_ :
	element_value_or_dots
	| listc_element_value_or_dots_ CM element_value_or_dots
	;

listc_element_value_pair_ :
	element_value_pair
	| listc_element_value_pair_ CM element_value_pair
	;

listc_enum_constant_ :
	enum_constant
	| listc_enum_constant_ CM enum_constant
	;

listc_formal_parameter_ :
	formal_parameter
	| listc_formal_parameter_ CM formal_parameter
	;

listc_identifier_ :
	identifier
	| listc_identifier_ CM identifier
	;

listc_lambda_param_ :
	lambda_param
	| listc_lambda_param_ CM lambda_param
	;

listc_name_ :
	name
	| listc_name_ CM name
	;

listc_reference_type_ :
	reference_type
	| listc_reference_type_ CM reference_type
	;

listc_statement_expression_ :
	statement_expression
	| listc_statement_expression_ CM statement_expression
	;

listc_type_argument_ :
	type_argument
	| listc_type_argument_ CM type_argument
	;

listc_type_parameter_ :
	type_parameter
	| listc_type_parameter_ CM type_parameter
	;

listc_variable_declarator_ :
	variable_declarator
	| listc_variable_declarator_ CM variable_declarator
	;

listc_variable_initializer_ :
	variable_initializer
	| listc_variable_initializer_ CM variable_initializer
	;

listc0_argument_ :
	optl_listc_argument__
	;

listc0_formal_parameter_ :
	optl_listc_formal_parameter__
	;

listc0_type_argument_ :
	optl_listc_type_argument__
	;

list_sep_reference_type_AND_ :
	reference_type
	| list_sep_reference_type_AND_ AND reference_type
	;

list_sep_resource_SM_ :
	resource
	| list_sep_resource_SM_ SM resource
	;

list_sep_type__OR_ :
	type_
	| list_sep_type__OR_ OR type_
	;

goal :
	compilation_unit //EOF
	;

compilation_unit :
	package_declaration nonempty_list_import_declaration_ list_type_declaration_
	| package_declaration list_type_declaration_
	| nonempty_list_import_declaration_ list_type_declaration_
	| list_type_declaration_
	;

type_declaration :
	class_and_co_declaration
	| SM
	;

class_and_co_declaration :
	class_declaration
	| interface_declaration
	| enum_declaration
	| annotation_type_declaration
	;

//semgrep_pattern :
//	expression EOF
//	| item_no_dots EOF
//	| item_no_dots nonempty_list_item_ EOF
//	| annotation EOF
//	| explicit_constructor_invocation_stmt EOF
//	| explicit_constructor_invocation EOF
//	| static_initializer EOF
//	| class_header EOF
//	| method_header EOF
//	| IF LP expression RP EOF
//	| TRY block EOF
//	| catch_clause EOF
//	| finally EOF
//	;

//item_no_dots :
//	statement_no_dots
//	| item_other
//	;

//item :
//	statement
//	| item_other
//	;

//item_other :
//	item_declaration
//	| import_declaration
//	| package_declaration
//	| local_variable_declaration_statement
//	;

//item_declaration :
//	class_and_co_declaration
//	| method_declaration
//	| constructor_declaration_top
//	;

//statement_no_dots :
//	statement_without_trailing_substatement
//	| labeled_statement
//	| if_then_statement
//	| if_then_else_statement
//	| while_statement
//	| for_statement
//	;

//constructor_declaration_top :
//	constructor_declarator_top optl_throws_ constructor_body
//	| modifiers constructor_declarator_top optl_throws_ constructor_body
//	;

//constructor_declarator_top :
//	identifier LP_PARAM listc0_formal_parameter_ RP
//	;

package_declaration :
	PACKAGE qualified_ident SM
	| modifiers PACKAGE qualified_ident SM
	;

import_declaration :
	IMPORT option_STATIC_ name SM
	| IMPORT option_STATIC_ name DOT TIMES SM
	;

identifier :
	IDENTIFIER
	;

qualified_ident :
	IDENTIFIER
	| qualified_ident DOT IDENTIFIER
	;

name :
	identifier_
	| name DOT identifier_
	| name DOT LT_GENERIC listc_type_argument_ GT identifier_
	;

identifier_ :
	identifier
	| identifier LT_GENERIC listc0_type_argument_ GT
	;

type_ :
	primitive_type
	| reference_type
	;

primitive_type :
	PRIMITIVE_TYPE
	;

class_or_interface_type :
	name
	;

reference_type :
	class_or_interface_type
	| array_type
	;

array_type :
	primitive_type LB_RB
	| class_or_interface_type LB_RB
	| array_type LB_RB
	;

type_argument :
	reference_type
	| COND
	| COND EXTENDS reference_type
	| COND SUPER reference_type
	;

type_parameters :
	LT listc_type_parameter_ GT
	| LDots GT
	| LDots CM listc_type_parameter_ GT
	| LDots CM listc_type_parameter_ CM RDots
	| LT listc_type_parameter_ CM RDots
	;

type_parameter :
	identifier
	| identifier EXTENDS bound
	| DOTS
	;

bound :
	list_sep_reference_type_AND_
	;

typed_metavar :
	LP type_ IDENTIFIER RP
	| METAVAR_ELLIPSIS
	;

primary :
	primary_no_new_array
	| array_creation_expression
	;

primary_no_new_array :
	literal
	| THIS
	| LP expression RP
	| class_instance_creation_expression
	| field_access
	| method_invocation
	| array_access
	| typed_metavar
	| name DOT THIS
	| class_literal
	| method_reference
	| array_creation_expression_with_initializer
	;

literal :
	TRUE
	| FALSE
	| TInt
	| TFloat
	| TChar
	| TString
	| NULL
	;

class_literal :
	primitive_type DOT CLASS
	| name DOT CLASS
	| array_type DOT CLASS
	| VOID DOT CLASS
	;

class_instance_creation_expression :
	NEW name LP listc0_argument_ RP option_class_body_
	| primary DOT NEW identifier LP listc0_argument_ RP option_class_body_
	| name DOT NEW identifier LP listc0_argument_ RP option_class_body_
	;

array_creation_expression :
	NEW primitive_type nonempty_list_dim_expr_ dims_opt
	| NEW name nonempty_list_dim_expr_ dims_opt
	;

array_creation_expression_with_initializer :
	NEW primitive_type dims array_initializer
	| NEW name dims array_initializer
	;

dim_expr :
	LB expression RB
	;

dims :
	LB_RB
	| dims LB_RB
	;

field_access :
	primary DOT identifier
	| SUPER DOT identifier
	| name DOT SUPER DOT identifier
	;

array_access :
	name LB expression RB
	| primary_no_new_array LB expression RB
	;

method_invocation :
	name LP listc0_argument_ RP
	| primary DOT identifier LP listc0_argument_ RP
	| SUPER DOT identifier LP listc0_argument_ RP
	| name DOT SUPER DOT identifier LP listc0_argument_ RP
	| primary DOT DOTS
	| name DOT DOTS
	;

argument :
	expression
	;

postfix_expression :
	primary
	| name
	| post_increment_expression
	| post_decrement_expression
	;

post_increment_expression :
	postfix_expression INCR
	;

post_decrement_expression :
	postfix_expression DECR
	;

unary_expression :
	pre_increment_expression
	| pre_decrement_expression
	| PLUS unary_expression
	| MINUS unary_expression
	| unary_expression_not_plus_minus
	;

pre_increment_expression :
	INCR unary_expression
	;

pre_decrement_expression :
	DECR unary_expression
	;

unary_expression_not_plus_minus :
	postfix_expression
	| COMPL unary_expression
	| NOT unary_expression
	| cast_expression
	;

cast_expression :
	LP primitive_type RP unary_expression
	| LP array_type RP unary_expression_not_plus_minus
	| LP expression RP unary_expression_not_plus_minus
	;

cast_lambda_expression :
	LP expression RP lambda_expression
	;

multiplicative_expression :
	unary_expression
	| multiplicative_expression TIMES unary_expression
	| multiplicative_expression DIV unary_expression
	| multiplicative_expression MOD unary_expression
	;

additive_expression :
	multiplicative_expression
	| additive_expression PLUS multiplicative_expression
	| additive_expression MINUS multiplicative_expression
	| DOTS PLUS multiplicative_expression
	| DOTS MINUS multiplicative_expression
	| additive_expression PLUS DOTS
	| additive_expression MINUS DOTS
	;

shift_expression :
	additive_expression
	| shift_expression LS additive_expression
	| shift_expression SRS additive_expression
	| shift_expression URS additive_expression
	;

relational_expression :
	shift_expression
	| relational_expression LT shift_expression
	| relational_expression GT shift_expression
	| relational_expression LE shift_expression
	| relational_expression GE shift_expression
	| relational_expression INSTANCEOF reference_type
	;

equality_expression :
	relational_expression
	| equality_expression EQ_EQ relational_expression
	| equality_expression NOT_EQ relational_expression
	;

and_expression :
	equality_expression
	| and_expression AND equality_expression
	;

exclusive_or_expression :
	and_expression
	| exclusive_or_expression XOR and_expression
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
	| conditional_or_expression COND expression COLON conditional_expression
	| conditional_or_expression COND expression COLON lambda_expression
	;

assignment_expression :
	conditional_expression
	| assignment
	| DOTS
	| LDots expression RDots
	;

assignment :
	left_hand_side assignment_operator expression
	;

left_hand_side :
	name
	| field_access
	| array_access
	| typed_metavar
	;

assignment_operator :
	EQ
	| OPERATOR_EQ
	;

lambda_expression :
	lambda_parameters ARROW lambda_body
	;

lambda_parameters :
	IDENTIFIER
	| LP_LAMBDA lambda_parameter_list RP
	| LP_LAMBDA RP
	;

lambda_parameter_list :
	listc_identifier_
	| listc_lambda_param_
	;

lambda_param :
	nonempty_list_variable_modifier_ lambda_parameter_type variable_declarator_id
	| lambda_parameter_type variable_declarator_id
	| variable_arity_parameter
	;

lambda_parameter_type :
	unann_type
	| VAR
	;

unann_type :
	type_
	;

variable_arity_parameter :
	nonempty_list_variable_modifier_ unann_type DOTS identifier
	| unann_type DOTS identifier
	;

lambda_body :
	expression
	| block
	;

method_reference :
	name COLONCOLON identifier
	| primary COLONCOLON identifier
	| array_type COLONCOLON identifier
	| name COLONCOLON NEW
	| array_type COLONCOLON NEW
	| SUPER COLONCOLON identifier
	| name DOT SUPER COLONCOLON identifier
	;

expression :
	assignment_expression
	| lambda_expression
	| cast_lambda_expression
	;

constant_expression :
	expression
	;

statement :
	statement_without_trailing_substatement
	| labeled_statement
	| if_then_statement
	| if_then_else_statement
	| while_statement
	| for_statement
	| DOTS
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
	| ASSERT expression SM
	| ASSERT expression COLON expression SM
	;

block :
	LC list_block_statement_ RC
	;

block_statement :
	local_variable_declaration_statement
	| statement
	| class_declaration
	;

local_variable_declaration_statement :
	local_variable_declaration SM
	;

local_variable_declaration :
	type_ listc_variable_declarator_
	| modifiers type_ listc_variable_declarator_
	;

empty_statement :
	SM
	;

labeled_statement :
	identifier COLON statement
	;

expression_statement :
	statement_expression SM
	;

statement_expression :
	assignment
	| pre_increment_expression
	| pre_decrement_expression
	| post_increment_expression
	| post_decrement_expression
	| method_invocation
	| class_instance_creation_expression
	| IDENTIFIER
	| typed_metavar
	;

if_then_statement :
	IF LP expression RP statement
	;

if_then_else_statement :
	IF LP expression RP statement_no_short_if ELSE statement
	;

switch_statement :
	SWITCH LP expression RP switch_block
	;

switch_block :
	LC RC
	| LC nonempty_list_switch_label_ RC
	| LC switch_block_statement_groups RC
	| LC switch_block_statement_groups nonempty_list_switch_label_ RC
	;

switch_block_statement_group :
	nonempty_list_switch_label_ nonempty_list_block_statement_
	;

switch_label :
	CASE constant_expression COLON
	| DEFAULT_COLON COLON
	;

while_statement :
	WHILE LP expression RP statement
	;

do_statement :
	DO statement WHILE LP expression RP SM
	;

for_statement :
	FOR LP for_control RP statement
	;

for_control :
	for_init_opt SM option_expression_ SM optl_for_update_
	| for_var_control
	| DOTS
	;

for_init_opt :
	/*empty*/
	| for_init
	;

for_init :
	listc_statement_expression_
	| local_variable_declaration
	;

for_update :
	listc_statement_expression_
	;

for_var_control :
	type_ variable_declarator_id for_var_control_rest
	| modifiers type_ variable_declarator_id for_var_control_rest
	;

for_var_control_rest :
	COLON expression
	;

break_statement :
	BREAK option_identifier_ SM
	;

continue_statement :
	CONTINUE option_identifier_ SM
	;

return_statement :
	RETURN option_expression_ SM
	;

synchronized_statement :
	SYNCHRONIZED LP expression RP block
	;

throw_statement :
	THROW expression SM
	;

try_statement :
	TRY block nonempty_list_catch_clause_
	| TRY block list_catch_clause_ finally
	| TRY resource_specification block list_catch_clause_ option_finally_
	;

finally :
	FINALLY block
	;

catch_clause :
	CATCH LP catch_formal_parameter RP block
	| CATCH LP catch_formal_parameter RP empty_statement
	;

catch_formal_parameter :
	nonempty_list_variable_modifier_ catch_type variable_declarator_id
	| catch_type variable_declarator_id
	| DOTS
	;

catch_type :
	list_sep_type__OR_
	;

resource_specification :
	LP list_sep_resource_SM_ option_SM_ RP
	;

resource :
	nonempty_list_variable_modifier_ local_variable_type identifier EQ expression
	| local_variable_type identifier EQ expression
	| variable_access
	;

local_variable_type :
	unann_type
	;

variable_access :
	field_access
	| name
	;

statement_no_short_if :
	statement_without_trailing_substatement
	| labeled_statement_no_short_if
	| if_then_else_statement_no_short_if
	| while_statement_no_short_if
	| for_statement_no_short_if
	;

labeled_statement_no_short_if :
	identifier COLON statement_no_short_if
	;

if_then_else_statement_no_short_if :
	IF LP expression RP statement_no_short_if ELSE statement_no_short_if
	;

while_statement_no_short_if :
	WHILE LP expression RP statement_no_short_if
	;

for_statement_no_short_if :
	FOR LP for_control RP statement_no_short_if
	;

modifier :
	PUBLIC
	| PROTECTED
	| PRIVATE
	| ABSTRACT
	| STATIC
	| FINAL
	| STRICTFP
	| TRANSIENT
	| VOLATILE
	| SYNCHRONIZED
	| NATIVE
	| DEFAULT
	| annotation
	;

annotation :
	AT qualified_ident
	| AT qualified_ident LP annotation_element RP
	;

annotation_element :
	/*empty*/
	| element_value
	| listc_element_value_pair_
	;

element_value :
	expr1
	| annotation
	| element_value_array_initializer
	;

element_value_or_dots :
	element_value
	| DOTS
	;

element_value_pair :
	identifier EQ element_value
	| DOTS
	;

element_value_array_initializer :
	LC RC
	| LC listc_element_value_or_dots_ option_CM_ RC
	;

expr1 :
	conditional_expression
	;

class_declaration :
	class_header class_body
	;

class_header :
	CLASS identifier optl_type_parameters_ option_super_ optl_interfaces_
	| modifiers CLASS identifier optl_type_parameters_ option_super_ optl_interfaces_
	;

super :
	EXTENDS type_
	;

interfaces :
	IMPLEMENTS listc_reference_type_
	;

class_body :
	LC list_class_body_declaration_ RC
	;

class_body_declaration :
	class_member_declaration
	| constructor_declaration
	| static_initializer
	| instance_initializer
	;

class_member_declaration :
	field_declaration
	| method_declaration
	| generic_method_or_constructor_decl
	| class_and_co_declaration
	| SM
	| DOTS
	;

static_initializer :
	STATIC block
	;

instance_initializer :
	block
	;

field_declaration :
	type_ listc_variable_declarator_ SM
	| modifiers type_ listc_variable_declarator_ SM
	;

variable_declarator :
	variable_declarator_id
	| variable_declarator_id EQ variable_initializer
	;

variable_declarator_id :
	identifier
	| variable_declarator_id LB_RB
	;

variable_initializer :
	expression
	| array_initializer
	;

array_initializer :
	LC option_CM_ RC
	| LC listc_variable_initializer_ option_CM_ RC
	;

method_declaration :
	method_header method_body
	;

method_header :
	type_ method_declarator optl_throws_
	| modifiers type_ method_declarator optl_throws_
	| VOID method_declarator optl_throws_
	| modifiers VOID method_declarator optl_throws_
	;

method_declarator :
	identifier LP listc0_formal_parameter_ RP
	| method_declarator LB_RB
	;

method_body :
	block
	| SM
	;

throws :
	THROWS listc_name_
	;

generic_method_or_constructor_decl :
	type_parameters type_ identifier formal_parameters optl_throws_ method_body
	| modifiers type_parameters type_ identifier formal_parameters optl_throws_ method_body
	| type_parameters VOID identifier formal_parameters optl_throws_ method_body
	| modifiers type_parameters VOID identifier formal_parameters optl_throws_ method_body
	;

constructor_declaration :
	constructor_declarator optl_throws_ constructor_body
	| modifiers constructor_declarator optl_throws_ constructor_body
	;

constructor_declarator :
	identifier LP listc0_formal_parameter_ RP
	;

constructor_body :
	LC list_block_statement_ RC
	| LC explicit_constructor_invocation_stmt list_block_statement_ RC
	;

explicit_constructor_invocation_stmt :
	explicit_constructor_invocation SM
	;

explicit_constructor_invocation :
	THIS LP listc0_argument_ RP
	| SUPER LP listc0_argument_ RP
	| primary DOT SUPER LP listc0_argument_ RP
	| name DOT SUPER LP listc0_argument_ RP
	;

formal_parameters :
	LP listc0_formal_parameter_ RP
	;

formal_parameter :
	type_ variable_declarator_id
	| variable_modifier list_variable_modifier_ type_ variable_declarator_id
	| type_ DOTS variable_declarator_id
	| variable_modifier list_variable_modifier_ type_ DOTS variable_declarator_id
	| DOTS
	| IDENTIFIER
	| METAVAR_ELLIPSIS
	;

variable_modifier :
	FINAL
	| annotation
	;

interface_declaration :
	INTERFACE identifier optl_type_parameters_ optl_extends_interfaces_ interface_body
	| modifiers INTERFACE identifier optl_type_parameters_ optl_extends_interfaces_ interface_body
	;

extends_interfaces :
	EXTENDS reference_type
	| extends_interfaces CM reference_type
	;

interface_body :
	LC list_interface_member_declaration_ RC
	;

interface_member_declaration :
	constant_declaration
	| interface_method_declaration
	| interface_generic_method_decl
	| class_and_co_declaration
	| SM
	| DOTS
	;

constant_declaration :
	type_ listc_variable_declarator_ SM
	| modifiers type_ listc_variable_declarator_ SM
	;

interface_method_declaration :
	method_declaration
	;

interface_generic_method_decl :
	type_parameters type_ identifier formal_parameters optl_throws_ SM
	| modifiers type_parameters type_ identifier formal_parameters optl_throws_ SM
	| type_parameters VOID identifier formal_parameters optl_throws_ SM
	| modifiers type_parameters VOID identifier formal_parameters optl_throws_ SM
	;

enum_declaration :
	ENUM identifier optl_interfaces_ enum_body
	| modifiers ENUM identifier optl_interfaces_ enum_body
	;

enum_body :
	LC optl_enum_body_declarations_ RC
	| LC listc_enum_constant_ optl_enum_body_declarations_ RC
	| LC listc_enum_constant_ CM optl_enum_body_declarations_ RC
	;

enum_constant :
	enum_constant_bis
	| modifiers enum_constant_bis
	;

enum_constant_bis :
	identifier
	| identifier LP listc0_argument_ RP
	| identifier LC list_method_declaration_ RC
	;

enum_body_declarations :
	SM list_class_body_declaration_
	| DOTS
	;

annotation_type_declaration :
	AT INTERFACE identifier annotation_type_body
	| modifiers AT INTERFACE identifier annotation_type_body
	;

annotation_type_body :
	LC list_annotation_type_element_declaration_ RC
	;

annotation_type_element_declaration :
	annotation_type_element_rest
	;

annotation_type_element_rest :
	type_ identifier annotation_method_or_constant_rest SM
	| modifiers type_ identifier annotation_method_or_constant_rest SM
	| class_and_co_declaration
	| DOTS
	;

annotation_method_or_constant_rest :
	LP RP
	| LP RP DEFAULT element_value
	;

modifiers :
	modifier
	| modifiers modifier
	;

switch_block_statement_groups :
	switch_block_statement_group
	| switch_block_statement_groups switch_block_statement_group
	;

dims_opt :
	/*empty*/
	| dims
	;

%%

/*****************************************************************************/
/* Regexps aliases */
/*****************************************************************************/
LF   '\n'  /* newline */
CR   '\r'  /* return */

LineTerminator   {LF}|{CR}|{CR}{LF}
InputCharacter   [^\r\n]

SUB   \x1A //'\026' /* control-Z */ /* decimal */

SP   " "     /* space */
HT   "\t"    /* horizontal tab */
FF   \x0C //'\012'  /* form feed */ /* decimal */

_WhiteSpace   {SP}|{HT}|{FF} /* | LineTerminator -- handled separately */

// TraditionalComment   "/*" ([^ '*'] | '*' [^ '/'])* "*/"
EndOfLineComment   "//"{InputCharacter}* //LineTerminator
/* Comment   TraditionalComment | EndOfLineComment */

/* sgrep-ext: $ is actually a valid letter in Java */
Letter   [A-Za-z_$]
Digit   [0-9]

Identifier   {Letter}({Letter}|{Digit})*

NonZeroDigit   [1-9]
HexDigit   [0-9a-fA-F]
OctalDigit   [0-7]
BinaryDigit   [0-1]

/* javaext: underscore in numbers */
IntegerTypeSuffix   [lL]
Underscores   "_"+

DigitOrUnderscore   {Digit}|"_"
DigitsAndUnderscores   {DigitOrUnderscore}+
Digits   {Digit}|{Digit}{DigitsAndUnderscores}?{Digit}

DecimalNumeral   "0"|{NonZeroDigit}{Digits}?|{NonZeroDigit}{Underscores}{Digits}

DecimalIntegerLiteral   {DecimalNumeral}{IntegerTypeSuffix}?

HexDigitOrUndercore   {HexDigit}|"_"
HexDigitsAndUnderscores   {HexDigitOrUndercore}{HexDigitOrUndercore}*
HexDigits   {HexDigit}|{HexDigit}{HexDigitsAndUnderscores}?{HexDigit}
HexNumeral   ("0x"|"0X"){HexDigits}
HexIntegerLiteral   {HexNumeral}{IntegerTypeSuffix}?

OctalDigitOrUnderscore   {OctalDigit}|"_"
OctalDigitsAndUnderscores   {OctalDigitOrUnderscore}{OctalDigitOrUnderscore}*
OctalDigits   {OctalDigit}|{OctalDigit}{OctalDigitsAndUnderscores}?{OctalDigit}
OctalNumeral   "0"({OctalDigits}|{Underscores}{OctalDigits})
OctalIntegerLiteral   {OctalNumeral}{IntegerTypeSuffix}?

BinaryDigitOrUnderscore   {BinaryDigit}|"_"
BinaryDigitsAndUnderscores   {BinaryDigitOrUnderscore}{BinaryDigitOrUnderscore}*
BinaryDigits   {BinaryDigit}|{BinaryDigit}{BinaryDigitsAndUnderscores}?{BinaryDigit}
BinaryNumeral   ("0b"|"0B"){BinaryDigits}
BinaryIntegerLiteral   {BinaryNumeral}{IntegerTypeSuffix}?

IntegerLiteral   {DecimalIntegerLiteral}|{HexIntegerLiteral}|{OctalIntegerLiteral}|{BinaryIntegerLiteral} /* javaext: ? */

ExponentPart   [eE][+-]?{Digit}+

FloatTypeSuffix   [fFdD]

FloatingPointLiteral   ({Digit}+"."{Digit}*|"."{Digit}+){ExponentPart}?{FloatTypeSuffix}?|{Digit}+({ExponentPart}{FloatTypeSuffix}?|{ExponentPart}?{FloatTypeSuffix})

BooleanLiteral   "true"|"false"

OctalEscape   \\[0-3]?{OctalDigit}{1,2}

/* Not in spec -- added because we don't handle Unicode elsewhere. */

UnicodeEscape   "\\u"{HexDigit}{4}

EscapeSequence   \\[btnfr"'\\]|{OctalEscape}|{UnicodeEscape}

/* semgrep: we can use regexp in semgrep in strings and we want to
 * support any escape characters there, e.g. eval("=~/.*dev\.corp/")
 */
EscapeSequence_semgrep   "\\_"

/*****************************************************************************/
/* UTF-8 boilerplate */
/*****************************************************************************/
/*
   Generic UTF-8 boilerplate.

   See https://erratique.ch/software/uucp/doc/unicode.html
   for a good explanation of how this works.

   We don't convert UTF-8-encoded data to code points. We only do the minimum
   to ensure the correct identification of the boundaries between scalar
   code points.
*/

/* 0xxxxxxx */
ascii   [\x00-\x7F] //[\000-\127]

/* 110xxxxx */
utf8_head_byte2   [\xC0-\xDF] //[\192-\223]

/* 1110xxxx */
utf8_head_byte3   [\xE0-\xEF] //[\224-\239]

/* 11110xxx */
utf8_head_byte4   [\xF0-\xF7] //[\240-\247]

/* 10xxxxxx */
utf8_tail_byte   [\x80-\xBF] //[\128-\191]

/* 7 bits of payload */
utf8_1   {ascii}

/* 11 bits of payload */
utf8_2   {utf8_head_byte2}{utf8_tail_byte}

/* 16 bits of payload */
utf8_3   {utf8_head_byte3}{utf8_tail_byte}{utf8_tail_byte}

/* 21 bits of payload */
utf8_4   {utf8_head_byte4}{utf8_tail_byte}{utf8_tail_byte}{utf8_tail_byte}

/* Any UTF-8-encoded code point. This set includes more than it should
   for simplicity.

   - This includes encodings of the so-called surrogate code points
     used by UTF-16 and not permitted by UTF-8.
   - This includes the range 0x110000 to 0x1FFFFF which are beyond the
     range of valid Unicode code points.
*/
utf8   {utf8_1}|{utf8_2}|{utf8_3}|{utf8_4}
utf8_nonascii   {utf8_2}|{utf8_3}|{utf8_4}

/************************ end of UTF-8 boilerplate ************************/

SingleCharacter   [^'\\\n\r]
CharacterLiteral   '({SingleCharacter}|{EscapeSequence}|{utf8})'


StringCharacter   [^"\\\n\r]
/* used inline later */
StringLiteral   \"({StringCharacter}|{EscapeSequence})*\"

NullLiteral   "null"

_Literal   {IntegerLiteral}|{FloatingPointLiteral}|{CharacterLiteral}|{StringLiteral}|{BooleanLiteral}|{NullLiteral}

/* Assignment operators, except '=', from section 3.12 */

_AssignmentOperator   ("+"|"-"|"*"|"/"|"&"|"|"|"^"|"%"|"<<"|">>"|">>>")"="

newline   "\n"

%%

  /* ----------------------------------------------------------------------- */
  /* spacing/comments */
  /* ----------------------------------------------------------------------- */
[ \t\r\v\f]+  skip()

{newline}+	skip()

"/*"(?s:.)*?"*/"	skip()
  /* don't keep the trailing \n; it will be in another token */
"//"{InputCharacter}*	skip()


  /* ----------------------------------------------------------------------- */
  /* Constant */
  /* ----------------------------------------------------------------------- */

  /* this is also part of IntegerLiteral, but we specialize it here to use the
   * right int_of_string */
"0"({OctalDigits}|{Underscores}{OctalDigits})	TInt
{IntegerLiteral}  TInt
{FloatingPointLiteral}  TFloat
{CharacterLiteral}      TChar
\"({StringCharacter}|{EscapeSequence})*\"    TString
  /* bool and null literals are keywords, see below */

  /* ----------------------------------------------------------------------- */
  /* Keywords and ident (must be after "true"|"false" above) */
  /* ----------------------------------------------------------------------- */

"if"	IF
"else"	ELSE

"while"	WHILE
"do"	DO
"for"	FOR

"return"	RETURN
"break"	BREAK
"continue"	CONTINUE

"switch"	SWITCH
"case"	CASE
/* javaext: now also use for interface default implementation in 1.? */
"default"	DEFAULT

//"goto"	GOTO

"try"	TRY
"catch"	CATCH
"finally"	FINALLY
"throw"	THROW

"synchronized"	SYNCHRONIZED


"true"	TRUE
"false"	FALSE
"null"	NULL

"void"	VOID

"boolean"	PRIMITIVE_TYPE
"byte"	PRIMITIVE_TYPE
"char"	PRIMITIVE_TYPE
"short"	PRIMITIVE_TYPE
"int"	PRIMITIVE_TYPE
"long"	PRIMITIVE_TYPE
"float"	PRIMITIVE_TYPE
"double"	PRIMITIVE_TYPE

"class"	CLASS
"interface"	INTERFACE
"extends"	EXTENDS
"implements"	IMPLEMENTS

"this"	THIS
"super"	SUPER
"new"	NEW
"instanceof"	INSTANCEOF

"abstract"	ABSTRACT
"final"	FINAL

"private"	PRIVATE
"protected"	PROTECTED
"public"	PUBLIC

//"const"	CONST

"native"	NATIVE
"static"	STATIC
"strictfp"	STRICTFP
"transient"	TRANSIENT
"volatile"	VOLATILE

"throws"	THROWS

"package"	PACKAGE
"import"	IMPORT

/* javaext: 1.4 */
"assert"	ASSERT
/* javaext: 1.? */
"enum"	ENUM
/* javaext: 1.? */
/*  "var"	VAR REGRESSIONS */
/* javaext: 15 */
//"record"	RECORD

DEFAULT_COLON	DEFAULT_COLON
LDots	LDots
LP_LAMBDA	LP_LAMBDA
LT_GENERIC	LT_GENERIC
METAVAR_ELLIPSIS	METAVAR_ELLIPSIS
RDots	RDots
VAR	VAR

  /* semgrep: Note that Identifier accepts dollars in it. According to
   * https://docs.oracle.com/javase/specs/jls/se8/html/jls-3.html
   * identifiers can contain and start with a dollar (especially in
   * generated code)
   * old: if not !Flag_parsing.sgrep_mode
   * then error ("identifier with dollar: "  ^ s) lexbuf;
   */
{Identifier}	IDENTIFIER

  /* ----------------------------------------------------------------------- */
  /* Symbols */
  /* ----------------------------------------------------------------------- */

"("   LP
")"   RP
"{"   LC
"}"   RC
"["   LB
"]"   RB
";"   SM
","   CM
"."   DOT

  /* pad: to avoid some conflicts */
"[]"   LB_RB

"="   EQ
  /* relational operator also now used for generics, can be transformed in LT2 */
"<"   LT
">"   GT
"!"   NOT
"~"   COMPL
"?"   COND
":"   COLON
"=="   EQ_EQ
"<="   LE
">="   GE
"!="   NOT_EQ
"&&"   AND_AND
"||"   OR_OR
"++"   INCR
"--"   DECR
"+"   PLUS
"-"   MINUS
"*"   TIMES
"/"   DIV
"&"   AND
  /* javaext: also used inside catch for list of possible exn */
"|"   OR
"^"   XOR
"%"   MOD
"<<"   LS
  /* this may be split in two tokens in fix_tokens_java.ml */
">>"   SRS
">>>"   URS
  /* javaext: lambdas */
"->"  ARROW
  /* javaext: qualified method */
"::"  COLONCOLON

  /* ext: annotations */
"@"  AT
  /* regular feature of Java for params and sgrep-ext: */
"..."   DOTS

"+="   OPERATOR_EQ
"-="   OPERATOR_EQ
"*="   OPERATOR_EQ
"/="   OPERATOR_EQ
"%="   OPERATOR_EQ
"&="   OPERATOR_EQ
"|="   OPERATOR_EQ
"^="   OPERATOR_EQ
"<<="  OPERATOR_EQ
">>="  OPERATOR_EQ
">>>=" OPERATOR_EQ

//SUB? eof  EOF

%%
