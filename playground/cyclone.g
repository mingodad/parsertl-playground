//From: https://github.com/mingodad/cyclone/blob/master/src/parse.y
/* Parser.
   Copyright (C) 2001 Greg Morrisett, AT&T
   This file is part of the Cyclone compiler.

   The Cyclone compiler is free software; you can redistribute it
   and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation; either version 2 of
   the License, or (at your option) any later version.

   The Cyclone compiler is distributed in the hope that it will be
   useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with the Cyclone compiler; see the file COPYING. If not,
   write to the Free Software Foundation, Inc., 59 Temple Place -
   Suite 330, Boston, MA 02111-1307, USA. */

/*
An adaptation of the ISO C grammar for Cyclone.  This grammar
is adapted from the proposed C9X standard, but the productions are
arranged as in Kernighan and Ritchie's "The C Programming
Language (ANSI C)", Second Edition, pages 234-239.

The grammar has 19 shift-reduce conflicts, and 4 reduce-reduce conflicts:

There is 1 shift-reduce conflict due to the "dangling else"
problem, which (the Cyclone port of) Bison properly resolves.

There are 10 shift-reduce conflicts due to ambiguities in attribute parsing.

There is 1 shift-reduce conflict due to the treatment of && in patterns.

There are 6 shift-reduce conflicts and 4 reduce-reduce conflicts
due to specifier-qualifier-lists and the desire to allow
typedef names to be redeclared as identifiers.

There are 2 shift-reduce conflicts having to do with
@requires and @ensures clauses on function prototypes.
*/

/*Tokens*/
%token AUTO
%token REGISTER
%token STATIC
%token EXTERN
%token TYPEDEF
%token VOID
%token CHAR
%token SHORT
%token INT
%token LONG
%token ISIZE_T
%token USIZE_T
%token FLOAT
%token FLOAT128
%token DOUBLE
%token SIGNED
%token UNSIGNED
%token CONST
%token VOLATILE
%token RESTRICT
%token STRUCT
%token UNION
%token CASE
%token DEFAULT
%token INLINE
%token SIZEOF
%token OFFSETOF
%token IF
%token ELSE
%token SWITCH
%token WHILE
%token DO
%token FOR
%token GOTO
%token CONTINUE
%token BREAK
%token RETURN
%token ENUM
%token TYPEOF
%token BUILTIN_VA_LIST
%token EXTENSION
%token COMPLEX
%token NULL_kw
%token LET
%token THROW
%token TRY
%token CATCH
%token EXPORT
%token OVERRIDE
%token HIDE
%token NEW
%token QNEW
%token ABSTRACT
%token FALLTHRU
%token USING
%token NAMESPACE
%token NOINFERENCE
%token DATATYPE
%token MALLOC
%token RMALLOC
%token RVMALLOC
%token RMALLOC_INLINE
%token QMALLOC
%token CALLOC
%token QCALLOC
%token RCALLOC
%token SWAP
%token ASSERT
%token REGION_T
%token TAG_T
%token REGION
%token RNEW
%token REGIONS
%token PORTON
%token PORTOFF
%token PRAGMA
%token TEMPESTON
%token TEMPESTOFF
%token AQ_ALIASABLE
%token AQ_REFCNT
%token AQ_RESTRICTED
%token AQ_UNIQUE
%token AQUAL_T
%token NUMELTS
%token TAGOF
%token VALUEOF
%token VALUEOF_T
%token TAGCHECK
%token NUMELTS_QUAL
%token THIN_QUAL
%token FAT_QUAL
%token NOTNULL_QUAL
%token NULLABLE_QUAL
%token REQUIRES_QUAL
%token ENSURES_QUAL
%token EFFECT_QUAL
%token THROWS_QUAL
%token SUBSET_QUAL
%token REGION_QUAL
%token NOZEROTERM_QUAL
%token ZEROTERM_QUAL
%token TAGGED_QUAL
%token ASSERT_QUAL
%token ASSERT_FALSE_QUAL
%token ALIAS_QUAL
%token AQUALS
%token CHECKS_QUAL
%token EXTENSIBLE_QUAL
%token AUTORELEASED_QUAL
%token PTR_OP
%token INC_OP
%token DEC_OP
%token LEFT_OP
%token RIGHT_OP
%token LE_OP
%token GE_OP
%token EQ_OP
%token NE_OP
%token AND_OP
%token OR_OP
%token MUL_ASSIGN
%token DIV_ASSIGN
%token MOD_ASSIGN
%token ADD_ASSIGN
%token SUB_ASSIGN
%token LEFT_ASSIGN
%token RIGHT_ASSIGN
%token AND_ASSIGN
%token XOR_ASSIGN
%token OR_ASSIGN
%token ELLIPSIS
%token LEFT_RIGHT
%token COLON_COLON
%token IDENTIFIER
%token INTEGER_CONSTANT
%token STRING
%token WSTRING
%token CHARACTER_CONSTANT
%token WCHARACTER_CONSTANT
%token FLOATING_CONSTANT
%token TYPE_VAR
%token TYPEDEF_NAME
%token QUAL_IDENTIFIER
%token QUAL_TYPEDEF_NAME
%token AQUAL_SHORT_CONST
%token ATTRIBUTE
%token ASM_TOK
%token ';'
%token '{'
%token '}'
%token ','
%token '*'
%token '='
%token '<'
%token '>'
%token '('
%token ')'
%token '_'
%token '$'
%token '|'
%token ':'
%token '.'
%token '['
%token ']'
%token '@'
%token '?'
%token '+'
%token '^'
%token '&'
%token '-'
%token '/'
%token '%'
%token '~'
%token '!'
%token 'A'
%token 'V'


%start prog_or_constraints

%%

prog_or_constraints :
	prog
	| all_constraints
	;

prog :
	translation_unit
	;

translation_unit :
	external_declaration translation_unit
	| using_action ';' translation_unit
	| using_action '{' translation_unit unusing_action translation_unit
	| namespace_action ';' translation_unit
	| namespace_action '{' translation_unit unnamespace_action translation_unit
	| noinference_action '{' translation_unit unnoinference_action translation_unit
	| extern_c_action '{' translation_unit end_extern_c override_opt export_list_opt hide_list_opt translation_unit
	| PORTON ';' translation_unit
	| PORTOFF ';' translation_unit
	| tempest_on_action ';' translation_unit
	| tempest_off_action ';' translation_unit
	| /*empty*/
	;

tempest_on_action :
	TEMPESTON
	;

tempest_off_action :
	TEMPESTOFF
	;

extern_c_action :
	EXTERN STRING
	;

end_extern_c :
	'}'
	;

hide_list_opt :
	/*empty*/
	| HIDE '{' hide_list_values '}'
	;

hide_list_values :
	struct_union_name
	| struct_union_name ';'
	| struct_union_name ',' hide_list_values
	;

export_list_opt :
	/*empty*/
	| export_list
	;

export_list :
	EXPORT '{' export_list_values '}'
	| EXPORT '{' '}'
	| EXPORT '{' '*' '}'
	;

export_list_values :
	struct_union_name optional_semi
	| struct_union_name ',' export_list_values
	;

override_opt :
	/*empty*/
	| OVERRIDE '{' translation_unit '}'
	;

external_declaration :
	function_definition
	| declaration
	//| error
	;

optional_semi :
	';'
	| /*empty*/
	;

function_definition :
	declarator fndef_compound_statement optional_semi
	| declaration_specifiers declarator fndef_compound_statement optional_semi
	| declarator declaration_list fndef_compound_statement optional_semi
	| declaration_specifiers declarator declaration_list fndef_compound_statement optional_semi
	;

function_definition2 :
	declaration_specifiers declarator compound_statement
	| declaration_specifiers declarator declaration_list compound_statement
	;

using_action :
	USING qual_opt_identifier
	;

unusing_action :
	'}'
	;

namespace_action :
	NAMESPACE IDENTIFIER
	;

unnamespace_action :
	'}'
	;

noinference_action :
	NOINFERENCE
	;

unnoinference_action :
	'}'
	;

declaration :
	declaration_specifiers ';'
	| declaration_specifiers init_declarator_list_rev ';'
	| LET pattern '=' expression ';'
	| LET identifier_list ';'
	| REGION '<' TYPE_VAR '>' IDENTIFIER ';'
	| REGION IDENTIFIER open_opt ';'
	;

open_opt :
	/*empty*/
	| '=' IDENTIFIER '(' expression ')'
	;

declaration_list :
	declaration
	| declaration_list declaration
	;

declaration_specifiers :
	storage_class_specifier
	| storage_class_specifier declaration_specifiers
	| EXTENSION declaration_specifiers
	| type_specifier
	| type_specifier declaration_specifiers
	| type_qualifier
	| type_qualifier declaration_specifiers
	| INLINE
	| INLINE declaration_specifiers
	| attributes
	| attributes declaration_specifiers
	;

storage_class_specifier :
	AUTO
	| REGISTER
	| STATIC
	| EXTERN
	| EXTERN STRING
	| TYPEDEF
	| ABSTRACT
	;

attributes_opt :
	/*empty*/
	| attributes
	;

attributes :
	ATTRIBUTE '(' '(' attribute_list ')' ')'
	;

attribute_list :
	attribute
	| attribute ',' attribute_list
	;

attribute :
	IDENTIFIER
	| CONST
	| IDENTIFIER '(' assignment_expression ')'
	| IDENTIFIER '(' IDENTIFIER ',' INTEGER_CONSTANT ',' INTEGER_CONSTANT ')'
	;

type_specifier :
	type_specifier_notypedef
	| qual_opt_typedef type_params_opt
	;

type_specifier_notypedef :
	VOID
	| CHAR
	| SHORT
	| INT
	| ISIZE_T
	| USIZE_T
	| LONG
	| FLOAT
	| FLOAT128
	| DOUBLE
	| SIGNED
	| UNSIGNED
	| COMPLEX
	| enum_specifier
	| struct_or_union_specifier
	| TYPEOF '(' expression ')'
	| BUILTIN_VA_LIST
	| datatype_specifier
	| type_var
	| '_'
	| '_' COLON_COLON kind
	| '$' '(' parameter_list ')'
	| REGION_T '<' any_type_name right_angle
	| REGION_T
	| AQUAL_T '<' aqual_specifier right_angle
	| TAG_T '<' any_type_name right_angle
	| TAG_T
	| VALUEOF_T '(' expression ')'
	| SUBSET_QUAL '(' specifier_qualifier_list declarator_withtypedef '|' constant_expression ')'
	;

kind :
	field_name
	;

type_qualifier :
	CONST
	| VOLATILE
	| RESTRICT
	;

enum_specifier :
	ENUM qual_opt_identifier '{' enum_declaration_list '}'
	| ENUM qual_opt_identifier
	| ENUM '{' enum_declaration_list '}'
	;

enum_field :
	qual_opt_identifier
	| qual_opt_identifier '=' constant_expression
	;

enum_declaration_list :
	enum_field
	| enum_field ','
	| enum_field ',' enum_declaration_list
	;

struct_or_union_specifier :
	struct_or_union '{' struct_declaration_list '}'
	| maybe_tagged_struct_union struct_union_name type_params_opt '{' type_params_opt optional_effconstr_qualbnd struct_declaration_list '}'
	| maybe_tagged_struct_union struct_union_name type_params_opt
	;

maybe_tagged_struct_union :
	TAGGED_QUAL struct_or_union
	| struct_or_union
	;

struct_or_union :
	STRUCT
	| UNION
	;

type_params_opt :
	/*empty*/
	| '<' type_name_list right_angle
	;

struct_declaration_list :
	/*empty*/
	| struct_declaration_list0
	;

struct_declaration_list0 :
	struct_declaration
	| struct_declaration_list0 struct_declaration
	;

init_declarator_list_rev :
	init_declarator
	| init_declarator_list_rev ',' init_declarator
	;

init_declarator :
	declarator
	| declarator ASM_TOK asm_expr
	| declarator '=' initializer
	| declarator ASM_TOK asm_expr '=' initializer
	;

struct_declaration :
	specifier_qualifier_list struct_declarator_list_rev ';'
	;

specifier_qualifier_list :
	type_specifier
	| type_specifier notypedef_specifier_qualifier_list
	| type_qualifier
	| type_qualifier specifier_qualifier_list
	| attributes
	| attributes specifier_qualifier_list
	;

notypedef_specifier_qualifier_list :
	type_specifier_notypedef
	| type_specifier_notypedef notypedef_specifier_qualifier_list
	| type_qualifier
	| type_qualifier notypedef_specifier_qualifier_list
	| attributes
	| attributes notypedef_specifier_qualifier_list
	;

struct_declarator_list_rev :
	struct_declarator
	| struct_declarator_list_rev ',' struct_declarator
	;

struct_declarator :
	declarator_withtypedef requires_clause_opt
	| ':' constant_expression
	| /*empty*/
	| declarator_withtypedef ':' constant_expression
	;

requires_clause_opt :
	REQUIRES_QUAL '(' constant_expression ')'
	| /*empty*/
	;

datatype_specifier :
	qual_datatype qual_opt_identifier type_params_opt '{' datatypefield_list '}'
	| qual_datatype qual_opt_identifier type_params_opt
	| qual_datatype qual_opt_identifier '.' qual_opt_identifier type_params_opt
	;

qual_datatype :
	DATATYPE
	| EXTENSIBLE_QUAL DATATYPE
	;

datatypefield_list :
	datatypefield
	| datatypefield ';'
	| datatypefield ',' datatypefield_list
	| datatypefield ';' datatypefield_list
	;

datatypefield_scope :
	/*empty*/
	| EXTERN
	| STATIC
	;

datatypefield :
	datatypefield_scope qual_opt_identifier
	| datatypefield_scope qual_opt_identifier '(' parameter_list ')'
	;

declarator :
	direct_declarator
	| pointer direct_declarator
	;

declarator_withtypedef :
	direct_declarator_withtypedef
	| pointer direct_declarator_withtypedef
	;

direct_declarator :
	qual_opt_identifier
	| '(' declarator ')'
	| '(' attributes declarator ')'
	| direct_declarator '[' ']' zeroterm_qual_opt
	| direct_declarator '[' assignment_expression ']' zeroterm_qual_opt
	| direct_declarator '(' parameter_type_list ')' chk_req_ens_thr_opt
	| direct_declarator '(' identifier_list ')'
	| direct_declarator '<' type_name_list right_angle
	| direct_declarator attributes
	;

direct_declarator_withtypedef :
	qual_opt_identifier
	| qual_opt_typedef
	| '(' declarator_withtypedef ')'
	| '(' attributes declarator_withtypedef ')'
	| direct_declarator_withtypedef '[' ']' zeroterm_qual_opt
	| direct_declarator_withtypedef '[' assignment_expression ']' zeroterm_qual_opt
	| direct_declarator_withtypedef '(' parameter_type_list ')' chk_req_ens_thr_opt
	| direct_declarator_withtypedef '(' identifier_list ')'
	| direct_declarator_withtypedef '<' type_name_list right_angle
	| direct_declarator_withtypedef attributes
	;

pointer :
	one_pointer
	| one_pointer pointer
	;

one_pointer :
	pointer_null_and_bound pointer_quals eff_opt attributes_opt tqual_list
	;

pointer_quals :
	/*empty*/
	| pointer_qual pointer_quals
	;

pointer_qual :
	NUMELTS_QUAL '(' assignment_expression ')'
	| REGION_QUAL '(' any_type_name ')'
	| EFFECT_QUAL '(' eff_set ')'
	| THIN_QUAL
	| FAT_QUAL
	| AUTORELEASED_QUAL
	| ZEROTERM_QUAL
	| NOZEROTERM_QUAL
	| NOTNULL_QUAL
	| NULLABLE_QUAL
	| ALIAS_QUAL '(' aqual_specifier ')'
	| AQUAL_SHORT_CONST
	;

aqual_specifier :
	aqual_const
	| type_var
	| AQUALS '(' any_type_name ')'
	;

//aqual_opt :
//	/*empty*/
//	| AQUAL_SHORT_CONST
//	;

pointer_null_and_bound :
	'*' pointer_bound
	| '@' pointer_bound
	| '?'
	;

pointer_bound :
	/*empty*/
	| '{' assignment_expression '}'
	| '{' TYPE_VAR '}'
	;

zeroterm_qual_opt :
	/*empty*/
	| ZEROTERM_QUAL
	| NOZEROTERM_QUAL
	;

eff_set :
	type_var
	| type_var '+' eff_set
	;

eff_opt :
	/*empty*/
	| eff_set
	| '_'
	;

tqual_list :
	/*empty*/
	| type_qualifier tqual_list
	;

parameter_type_list :
	optional_effect optional_effconstr_qualbnd
	| parameter_list optional_effect optional_effconstr_qualbnd
	| parameter_list ',' ELLIPSIS optional_effect optional_effconstr_qualbnd
	| ELLIPSIS optional_inject parameter_declaration optional_effect optional_effconstr_qualbnd
	| parameter_list ',' ELLIPSIS optional_inject parameter_declaration optional_effect optional_effconstr_qualbnd
	;

opt_aqual_bnd :
	/*empty*/
	| AQUAL_SHORT_CONST
	;

type_var :
	TYPE_VAR opt_aqual_bnd
	| TYPE_VAR COLON_COLON kind opt_aqual_bnd
	;

optional_effect :
	/*empty*/
	| ';' effect_set
	;

optional_effconstr_qualbnd :
	/*empty*/
	| ':' effconstr_qualbnd
	;

effconstr_qualbnd :
	effconstr_elt
	| qual_bnd_elt
	| effconstr_elt ',' effconstr_qualbnd
	| qual_bnd_elt ',' effconstr_qualbnd
	;

effconstr_elt :
	atomic_effect LE_OP TYPE_VAR
	| atomic_effect '|' atomic_effect
	| IDENTIFIER '(' atomic_effect ')'
	;

qual_bnd_elt :
	qual_bnd_const GE_OP qual_bnd_term
	;

aqual_const :
	AQ_ALIASABLE
	| AQ_UNIQUE
	| AQ_REFCNT
	| AQ_RESTRICTED
	| AQUAL_SHORT_CONST
	;

qual_bnd_const :
	aqual_const
	| AQUALS '(' any_type_name ')'
	;

qual_bnd_term :
	TYPE_VAR
	| AQUALS '(' any_type_name ')'
	;

optional_inject :
	/*empty*/
	| IDENTIFIER
	;

effect_set :
	atomic_effect
	| atomic_effect '+' effect_set
	;

atomic_effect :
	'{' '}'
	| '{' region_set '}'
	| REGIONS '(' any_type_name ')'
	| type_var
	;

region_set :
	type_name
	| type_name ',' region_set
	;

parameter_list :
	parameter_declaration
	| parameter_list ',' parameter_declaration
	;

parameter_declaration :
	specifier_qualifier_list declarator_withtypedef
	| specifier_qualifier_list
	| specifier_qualifier_list abstract_declarator
	;

identifier_list :
	identifier_list0
	;

identifier_list0 :
	IDENTIFIER
	| identifier_list0 ',' IDENTIFIER
	;

initializer :
	assignment_expression
	| array_initializer
	;

array_initializer :
	'{' '}'
	| '{' initializer_list '}'
	| '{' initializer_list ',' '}'
	| '{' FOR IDENTIFIER '<' expression ':' expression '}'
	| '{' FOR IDENTIFIER '<' expression ':' type_name '}'
	;

initializer_list :
	initializer
	| designation initializer
	| initializer_list ',' initializer
	| initializer_list ',' designation initializer
	;

designation :
	designator_list '='
	| field_name ':'
	;

designator_list :
	designator
	| designator_list designator
	;

designator :
	'[' constant_expression ']'
	| '.' field_name
	;

type_name :
	specifier_qualifier_list
	| specifier_qualifier_list abstract_declarator
	;

any_type_name :
	type_name
	| '{' '}'
	| '{' region_set '}'
	| REGIONS '(' any_type_name ')'
	| any_type_name '+' atomic_effect
	| qual_bnd_const
	;

type_name_list :
	any_type_name
	| type_name_list ',' any_type_name
	;

abstract_declarator :
	pointer
	| direct_abstract_declarator
	| pointer direct_abstract_declarator
	;

direct_abstract_declarator :
	'(' abstract_declarator ')'
	| '[' ']' zeroterm_qual_opt
	| direct_abstract_declarator '[' ']' zeroterm_qual_opt
	| '[' assignment_expression ']' zeroterm_qual_opt
	| direct_abstract_declarator '[' assignment_expression ']' zeroterm_qual_opt
	| '(' parameter_type_list ')' chk_req_ens_thr_opt
	| direct_abstract_declarator '(' parameter_type_list ')' chk_req_ens_thr_opt
	| direct_abstract_declarator '<' type_name_list right_angle
	| direct_abstract_declarator attributes
	;

chk_req_ens_thr :
	CHECKS_QUAL '(' constant_expression ')'
	| REQUIRES_QUAL '(' constant_expression ')'
	| ENSURES_QUAL '(' constant_expression ')'
	| THROWS_QUAL '(' constant_expression ')'
	| CHECKS_QUAL '(' constant_expression ')' chk_req_ens_thr
	| REQUIRES_QUAL '(' constant_expression ')' chk_req_ens_thr
	| ENSURES_QUAL '(' constant_expression ')' chk_req_ens_thr
	| THROWS_QUAL '(' constant_expression ')' chk_req_ens_thr
	;

chk_req_ens_thr_opt :
	/*empty*/
	| chk_req_ens_thr
	;

statement :
	labeled_statement
	| expression_statement
	| compound_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	;

labeled_statement :
	IDENTIFIER ':' statement
	;

expression_statement :
	';'
	| expression ';'
	;

start_fndef_block :
	'{'
	;

end_fndef_block :
	'}'
	;

fndef_compound_statement :
	start_fndef_block end_fndef_block
	| start_fndef_block block_item_list end_fndef_block
	;

compound_statement :
	'{' '}'
	| '{' block_item_list '}'
	;

block_item_list :
	declaration
	| declaration block_item_list
	| IDENTIFIER ':' declaration
	| IDENTIFIER ':' declaration block_item_list
	| statement
	| statement block_item_list
	| function_definition2
	| function_definition2 block_item_list
	;

selection_statement :
	IF '(' expression ')' statement
	| IF '(' expression ')' statement ELSE statement
	| SWITCH '(' expression ')' '{' switch_clauses '}'
	| SWITCH qual_opt_identifier '{' switch_clauses '}'
	| SWITCH '$' '(' argument_expression_list ')' '{' switch_clauses '}'
	| TRY statement CATCH '{' switch_clauses '}'
	;

switch_clauses :
	/*empty*/
	| DEFAULT ':' block_item_list switch_clauses
	| CASE exp_pattern ':' switch_clauses
	| CASE exp_pattern ':' block_item_list switch_clauses
	| CASE pattern AND_OP expression ':' switch_clauses
	| CASE pattern AND_OP expression ':' block_item_list switch_clauses
	;

iteration_statement :
	WHILE '(' expression ')' statement
	| DO statement WHILE '(' expression ')' ';'
	| FOR '(' for_exp_opt ';' for_exp_opt ';' for_exp_opt ')' statement
	| FOR '(' declaration for_exp_opt ';' for_exp_opt ')' statement
	;

for_exp_opt :
	/*empty*/
	| expression
	;

jump_statement :
	GOTO IDENTIFIER ';'
	| CONTINUE ';'
	| BREAK ';'
	| RETURN ';'
	| RETURN expression ';'
	| FALLTHRU ';'
	| FALLTHRU '(' ')' ';'
	| FALLTHRU '(' argument_expression_list ')' ';'
	;

exp_pattern :
	conditional_pattern
	;

conditional_pattern :
	logical_or_pattern
	| logical_or_pattern '?' expression ':' conditional_expression
	;

logical_or_pattern :
	logical_and_pattern
	| logical_or_pattern OR_OP logical_and_expression
	;

logical_and_pattern :
	inclusive_or_pattern
	| inclusive_or_pattern AND_OP inclusive_or_expression
	;

inclusive_or_pattern :
	exclusive_or_pattern
	| exclusive_or_pattern '|' exclusive_or_expression
	;

exclusive_or_pattern :
	and_pattern
	| and_pattern '^' exclusive_or_expression
	;

and_pattern :
	equality_pattern
	| and_pattern '&' equality_expression
	;

equality_pattern :
	relational_pattern
	| equality_pattern equality_op relational_expression
	;

relational_pattern :
	shift_pattern
	| relational_pattern relational_op shift_expression
	;

shift_pattern :
	additive_pattern
	| shift_pattern LEFT_OP additive_expression
	| shift_pattern RIGHT_OP additive_expression
	;

additive_pattern :
	multiplicative_pattern
	| additive_pattern additive_op multiplicative_expression
	;

multiplicative_pattern :
	cast_pattern
	| multiplicative_pattern multiplicative_op cast_expression
	;

cast_pattern :
	unary_pattern
	| '(' type_name ')' cast_expression
	;

unary_pattern :
	postfix_pattern
	| unary_operator cast_expression
	| SIZEOF '(' type_name ')'
	| SIZEOF unary_expression
	| OFFSETOF '(' type_name ',' field_expression ')'
	;

postfix_pattern :
	primary_pattern
	;

primary_pattern :
	pattern
	;

pattern :
	'_'
	| '(' expression ')'
	| qual_opt_identifier
	| '&' pattern
	| constant
	| IDENTIFIER IDENTIFIER pattern
	| IDENTIFIER '<' TYPE_VAR '>' type_name IDENTIFIER
	| TYPEDEF_NAME '<' TYPE_VAR '>' type_name IDENTIFIER
	| '$' '(' field_pattern_list ')'
	| qual_opt_identifier '(' tuple_pattern_list ')'
	| qual_opt_identifier '{' type_params_opt field_pattern_list '}'
	| '{' type_params_opt field_pattern_list '}'
	| AND_OP pattern
	| '*' IDENTIFIER
	| '*' IDENTIFIER IDENTIFIER pattern
	| IDENTIFIER '<' TYPE_VAR '>'
	| IDENTIFIER '<' '_' '>'
	;

tuple_pattern_list :
	tuple_pattern_list0
	| tuple_pattern_list0 ',' ELLIPSIS
	| ELLIPSIS
	;

tuple_pattern_list0 :
	pattern
	| tuple_pattern_list0 ',' pattern
	;

field_pattern :
	pattern
	| designation pattern
	;

field_pattern_list :
	field_pattern_list0
	| field_pattern_list0 ',' ELLIPSIS
	| ELLIPSIS
	;

field_pattern_list0 :
	field_pattern
	| field_pattern_list0 ',' field_pattern
	;

expression :
	assignment_expression
	| expression ',' assignment_expression
	;

assignment_expression :
	conditional_expression
	| unary_expression assignment_operator assignment_expression
	| unary_expression SWAP assignment_expression
	;

assignment_operator :
	'='
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
	| LEFT_ASSIGN
	| RIGHT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

conditional_expression :
	logical_or_expression
	| logical_or_expression '?' expression ':' conditional_expression
	| THROW conditional_expression
	| NEW array_initializer
	| NEW logical_or_expression
	| QNEW '(' expression ')' array_initializer
	| QNEW '(' expression ')' logical_or_expression
	| RNEW '(' expression ')' array_initializer
	| RNEW '(' expression ')' logical_or_expression
	;

constant_expression :
	conditional_expression
	;

logical_or_expression :
	logical_and_expression
	| logical_or_expression OR_OP logical_and_expression
	;

logical_and_expression :
	inclusive_or_expression
	| logical_and_expression AND_OP inclusive_or_expression
	;

inclusive_or_expression :
	exclusive_or_expression
	| inclusive_or_expression '|' exclusive_or_expression
	;

exclusive_or_expression :
	and_expression
	| exclusive_or_expression '^' and_expression
	;

and_expression :
	equality_expression
	| and_expression '&' equality_expression
	;

equality_expression :
	relational_expression
	| equality_expression equality_op relational_expression
	;

relational_expression :
	shift_expression
	| relational_expression relational_op shift_expression
	;

shift_expression :
	additive_expression
	| shift_expression LEFT_OP additive_expression
	| shift_expression RIGHT_OP additive_expression
	;

additive_expression :
	multiplicative_expression
	| additive_expression additive_op multiplicative_expression
	;

multiplicative_expression :
	cast_expression
	| multiplicative_expression multiplicative_op cast_expression
	;

equality_op :
	EQ_OP
	| NE_OP
	;

relational_op :
	'<'
	| '>'
	| LE_OP
	| GE_OP
	;

additive_op :
	'+'
	| '-'
	;

multiplicative_op :
	'*'
	| '/'
	| '%'
	;

cast_expression :
	unary_expression
	| '(' type_name ')' cast_expression
	;

unary_expression :
	postfix_expression
	| INC_OP unary_expression
	| DEC_OP unary_expression
	| '&' cast_expression
	| '*' cast_expression
	| unary_operator cast_expression
	| SIZEOF '(' type_name ')'
	| SIZEOF unary_expression
	| OFFSETOF '(' type_name ',' field_expression ')'
	| MALLOC '(' assignment_expression ')'
	| QMALLOC '(' assignment_expression ',' assignment_expression ',' assignment_expression ')'
	| RMALLOC '(' expression ',' assignment_expression ')'
	| RVMALLOC '(' expression ',' assignment_expression ')'
	| RMALLOC_INLINE '(' expression ',' assignment_expression ')'
	| CALLOC '(' assignment_expression ',' SIZEOF '(' type_name ')' ')'
	| QCALLOC '(' assignment_expression ',' assignment_expression ',' assignment_expression ',' SIZEOF '(' type_name ')' ')'
	| RCALLOC '(' assignment_expression ',' assignment_expression ',' SIZEOF '(' type_name ')' ')'
	| NUMELTS '(' assignment_expression ')'
	| TAGOF '(' assignment_expression ')'
	| TAGCHECK '(' postfix_expression '.' field_name ')'
	| TAGCHECK '(' postfix_expression PTR_OP field_name ')'
	| VALUEOF '(' type_name ')'
	| ASM_TOK asm_expr
	| EXTENSION unary_expression
	| ASSERT '(' assignment_expression ')'
	| ASSERT_QUAL '(' assignment_expression ')'
	| ASSERT_FALSE_QUAL '(' assignment_expression ')'
	;

unary_operator :
	'~'
	| '!'
	| '-'
	| '+'
	;

asm_expr :
	volatile_opt '(' STRING asm_out_opt ')'
	;

volatile_opt :
	/*empty*/
	| VOLATILE
	;

asm_out_opt :
	/*empty*/
	| ':' asm_in_opt
	| ':' asm_outlist asm_in_opt
	;

asm_outlist :
	asm_io_elt
	| asm_outlist ',' asm_io_elt
	;

asm_in_opt :
	/*empty*/
	| ':' asm_clobber_opt
	| ':' asm_inlist asm_clobber_opt
	;

asm_inlist :
	asm_io_elt
	| asm_inlist ',' asm_io_elt
	;

asm_io_elt :
	STRING '(' expression ')'
	;

asm_clobber_opt :
	/*empty*/
	| ':'
	| ':' asm_clobber_list
	;

asm_clobber_list :
	STRING
	| asm_clobber_list ',' STRING
	;

postfix_expression :
	primary_expression
	| postfix_expression '[' expression ']'
	| postfix_expression '(' ')'
	| postfix_expression '(' argument_expression_list ')'
	| postfix_expression '.' field_name
	| postfix_expression PTR_OP field_name
	| postfix_expression INC_OP
	| postfix_expression DEC_OP
	| '(' type_name ')' '{' '}'
	| '(' type_name ')' '{' initializer_list '}'
	| '(' type_name ')' '{' initializer_list ',' '}'
	;

field_expression :
	field_name
	| INTEGER_CONSTANT
	| field_expression '.' field_name
	| field_expression '.' INTEGER_CONSTANT
	;

primary_expression :
	qual_opt_identifier
	| PRAGMA '(' IDENTIFIER ')'
	| constant
	| STRING
	| WSTRING
	| '(' expression ')'
	| primary_expression LEFT_RIGHT
	| primary_expression '@' '<' type_name_list right_angle
	| qual_opt_identifier '{' type_params_opt initializer_list '}'
	| '$' '(' argument_expression_list ')'
	| '(' '{' block_item_list '}' ')'
	;

argument_expression_list :
	argument_expression_list0
	;

argument_expression_list0 :
	assignment_expression
	| argument_expression_list0 ',' assignment_expression
	;

constant :
	INTEGER_CONSTANT
	| CHARACTER_CONSTANT
	| WCHARACTER_CONSTANT
	| NULL_kw
	| FLOATING_CONSTANT
	;

qual_opt_identifier :
	IDENTIFIER
	| QUAL_IDENTIFIER
	;

qual_opt_typedef :
	TYPEDEF_NAME
	| QUAL_TYPEDEF_NAME
	;

struct_union_name :
	qual_opt_identifier
	| qual_opt_typedef
	;

field_name :
	IDENTIFIER
	| TYPEDEF_NAME
	;

right_angle :
	'>'
	| RIGHT_OP
	;

all_constraints :
	/*empty*/
	| TYPE_VAR STRING ',' STRING '(' constraint_list_opt ')' all_constraints
	;

constraint_list_opt :
	/*empty*/
	| constraint_list
	;

constraint_list :
	constraint
	| constraint ';' constraint_list
	;

tvar_or_string :
	TYPE_VAR
	| STRING
	;

constraint :
	STRING '!' '(' constraint ')'
	| STRING '^' '(' c_op ',' tvar_or_string ',' tvar_or_string ')'
	| STRING '?' '(' tvar_or_string ',' tvar_or_string ')'
	| STRING '=' '(' tvar_or_string ',' tvar_or_string ')'
	| STRING '<' '(' tvar_or_string ',' tvar_or_string ')'
	| STRING '>' '(' constraint ',' constraint ')'
	| STRING '+' '(' c_op ',' constraint ',' constraint ')'
	;

c_op :
	'A'
	| 'V'
	| '!'
	| '='
	| '<'
	;

%%

%x  QUAL_BT

newline     \r\n?|\r\n?
notnewline  [^\n\r]
idchar      [A-Za-z0-9_]
firstidchar [A-Za-z]
cnstsuffix  (((['u''U'])?(['l''L'])?(['l''L'])?)|((['l''L'])?(['l''L'])?(['u''U'])?))

charc	'(\\.|[^'\n\r\\])+'
string	\"(\\.|[^"\n\r\\])*\"
ident	("_"|{firstidchar}){idchar}*

%%

/* comments, directives, whitespace, etc. */
[ \t\v\f\n\r]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"#".*	skip()

"ALIASABLE"	AQ_ALIASABLE
"aqual_t"	AQUAL_T
"aquals"	AQUALS
"__attribute__"	ATTRIBUTE
"__attribute"	ATTRIBUTE
"__asm__"	ASM_TOK
"__asm"	ASM_TOK
"assert"	ASSERT
"asm"	ASM_TOK
"abstract"	ABSTRACT
"auto"	AUTO
"break"	BREAK
"__builtin_va_list"	BUILTIN_VA_LIST
"calloc"	CALLOC
"case"	CASE
"catch"	CATCH
"char"	CHAR
"_Complex"	COMPLEX
"__complex__"	COMPLEX
"const"	CONST
"__const__"	CONST
"continue"	CONTINUE
"cyclone_override"	OVERRIDE
"datatype"	DATATYPE
"default"	DEFAULT
"do"	DO
"double"	DOUBLE
"else"	ELSE
"enum"	ENUM
"export"	EXPORT
"cyclone_hide"	HIDE
"__extension__"	EXTENSION
"extern"	EXTERN
"fallthru"	FALLTHRU
"float"	FLOAT
"_Float128"	FLOAT128
"for"	FOR
"goto"	GOTO
"if"	IF
"inline"	INLINE
"__inline__"	INLINE
"__inline"	INLINE
"int"	INT
"isize_t"	ISIZE_T
"let"	LET
"long"	LONG
"malloc"	MALLOC
"namespace"	NAMESPACE
"new"	NEW
"NULL"	NULL_kw
"numelts"	NUMELTS
"__noinference__"	NOINFERENCE
"offsetof"	OFFSETOF
"__cyclone_port_on__"	PORTON
"__cyclone_port_off__"	PORTOFF
"__cyclone_pragma__"	PRAGMA
"qcalloc"	QCALLOC
"qmalloc"	QMALLOC
"qnew"	QNEW
"rcalloc"	RCALLOC
"REFCNT"	AQ_REFCNT
"region_t"	REGION_T
"region"	REGION
"regions"	REGIONS
"register"	REGISTER
"restrict"	RESTRICT
"__restrict"	RESTRICT
"RESTRICTED"	AQ_RESTRICTED
"return"	RETURN
"rmalloc"	RMALLOC
"rmalloc_inline"	RMALLOC_INLINE
"rvmalloc"	RVMALLOC
"rnew"	RNEW
"short"	SHORT
"signed"	SIGNED
"__signed__"	SIGNED
"sizeof"	SIZEOF
"static"	STATIC
"struct"	STRUCT
"switch"	SWITCH
"tagcheck"	TAGCHECK
"tagof"	TAGOF
"tag_t"	TAG_T
"__tempest_on__"	TEMPESTON
"__tempest_off__"	TEMPESTOFF
"throw"	THROW
"try"	TRY
"typedef"	TYPEDEF
"typeof"	TYPEOF
"__typeof__"	TYPEOF
"UNIQUE"	AQ_UNIQUE
"union"	UNION
"unsigned"	UNSIGNED
"__unsigned__"	UNSIGNED
"using"	USING
"usize_t"	USIZE_T
"valueof"	VALUEOF
"valueof_t"	VALUEOF_T
"void"	VOID
"volatile"	VOLATILE
"__volatile__"	VOLATILE
"while"	WHILE

////  Qualifiers (with lexbuf hack) /////////////
/* HACK: If we see @taggedfoo then this should be lexed as '@' 'taggedfoo', not
 * '@tagged' 'foo' -- so we back up the lexer */
"@"[A-Za-z]<QUAL_BT> reject()
<QUAL_BT> {
    "@" '@'
    "aqual"<INITIAL>	ALIAS_QUAL
    "assert"("__")?<INITIAL>	ASSERT_QUAL
    "assert_false"<INITIAL>	ASSERT_FALSE_QUAL
    "autoreleased"<INITIAL>	AUTORELEASED_QUAL
    "checks"<INITIAL>	CHECKS_QUAL
    "effect"<INITIAL>	EFFECT_QUAL
    "ensures"<INITIAL>	ENSURES_QUAL
    "extensible"<INITIAL>	EXTENSIBLE_QUAL
    "fat"<INITIAL>	FAT_QUAL
    "notnull"<INITIAL>	NOTNULL_QUAL
    "nozeroterm"<INITIAL>	NOZEROTERM_QUAL
    "zeroterm"<INITIAL> ZEROTERM_QUAL
    "nullable"<INITIAL>	NULLABLE_QUAL
    "numelts"<INITIAL>	NUMELTS_QUAL
    "region"<INITIAL>	REGION_QUAL
    "requires"<INITIAL>	REQUIRES_QUAL
    "subset"<INITIAL>	SUBSET_QUAL
    "tagged"<INITIAL>	TAGGED_QUAL
    "thin"<INITIAL>	THIN_QUAL
    "throws"<INITIAL>	THROWS_QUAL
    .<INITIAL> reject()
}

/* Operators */
"=="   EQ_OP
"!="   NE_OP
"<="   LE_OP
">="   GE_OP
"++"   INC_OP
"--"   DEC_OP
"+="   ADD_ASSIGN
"-="   SUB_ASSIGN
"*="   MUL_ASSIGN
"/="   DIV_ASSIGN
"%="     MOD_ASSIGN
"|="     OR_ASSIGN
"^="     XOR_ASSIGN
"&="     AND_ASSIGN
"<<="    LEFT_ASSIGN
">>="    RIGHT_ASSIGN
"&&"   AND_OP
"||"   OR_OP
"<<"   LEFT_OP
/* JGM: see shift_expr and relational_expr -- we pull a nasty hack there...*/
">>"   RIGHT_OP
"<>"   LEFT_RIGHT
"->"  PTR_OP
"..."  ELLIPSIS
"::"  COLON_COLON
":=:"  SWAP

";"	';'
"{"	'{'
"}"	'}'
","	','
"*"	'*'
"="	'='
"<"	'<'
">"	'>'
"("	'('
")"	')'
"_"	'_'
"$"	'$'
"|"	'|'
":"	':'
"."	'.'
"["	'['
"]"	']'
"@"	'@'
"?"	'?'
"+"	'+'
"^"	'^'
"&"	'&'
"-"	'-'
"/"	'/'
"%"	'%'
"~"	'~'
"!"	'!'
"A"	'A'
"V"	'V'

TYPEDEF_NAME	TYPEDEF_NAME
QUAL_TYPEDEF_NAME	QUAL_TYPEDEF_NAME

/* Identifiers, type names, and keywords */
{ident}	IDENTIFIER

/* Qualified identifiers and type names (e.g., Foo::bar) */
({firstidchar}{idchar}*"::")+({firstidchar}|"_"){idchar}*	QUAL_IDENTIFIER

/* Type variables */
"`"({firstidchar}|"_"){idchar}*	TYPE_VAR
"\\"{firstidchar}{idchar}*	AQUAL_SHORT_CONST

/* Integer constants */
0[xX][0-9a-fA-F]+{cnstsuffix}	INTEGER_CONSTANT
0[0-7]*{cnstsuffix}	INTEGER_CONSTANT
      /* This is really an error case according to OSI C --
         the leading 0 indicates this should be in octal. */
      /* FIX: print a warning message? */
0[0-9]+{cnstsuffix}	INTEGER_CONSTANT
[1-9][0-9]*{cnstsuffix}	INTEGER_CONSTANT

/* Floating-point constants -- must come after int constants */
(([0-9]+("."?))|([0-9]+"."[0-9]+)|("."[0-9]+))([eE][+-]?[0-9]+)?[fFlL]?	FLOATING_CONSTANT

{string}	STRING
L{string}	WSTRING
{charc}	CHARACTER_CONSTANT
L{charc}	WCHARACTER_CONSTANT


%%
