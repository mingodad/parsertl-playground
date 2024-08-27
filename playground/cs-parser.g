//From: https://github.com/mono/mono/blob/89f1d3cc22fd3b0848ecedbd6215b0bdfeea9477/mcs/mcs/cs-parser.jay
//
// cs-parser.jay: The Parser for the C# compiler
//
// Authors: Miguel de Icaza (miguel@gnome.org)
//          Ravi Pratap     (ravi@ximian.com)
//          Marek Safar	    (marek.safar@gmail.com)
//
// Dual Licensed under the terms of the GNU GPL and the MIT X11 license
//
// (C) 2001 Ximian, Inc (http://www.ximian.com)
// (C) 2004-2011 Novell, Inc
// Copyright 2011-2012 Xamarin Inc.
//

/*Tokens*/
//%token EOF
//%token NONE
//%token ERROR
//%token FIRST_KEYWORD
%token ABSTRACT
%token AS
%token ADD
%token BASE
%token BOOL
%token BREAK
%token BYTE
%token CASE
%token CATCH
%token CHAR
%token CHECKED
%token CLASS
%token CONST
%token CONTINUE
%token DECIMAL
%token DEFAULT
%token DEFAULT_VALUE
%token DELEGATE
%token DO
%token DOUBLE
%token ELSE
%token ENUM
%token EVENT
%token EXPLICIT
%token EXTERN
%token FALSE
%token FINALLY
%token FIXED
%token FLOAT
%token FOR
%token FOREACH
%token GOTO
%token IF
%token IMPLICIT
%token IN
%token INT
%token INTERFACE
%token INTERNAL
%token IS
%token LOCK
%token LONG
%token NAMESPACE
%token NEW
%token NULL
%token OBJECT
%token OPERATOR
%token OUT
%token OVERRIDE
%token PARAMS
%token PRIVATE
%token PROTECTED
%token PUBLIC
%token READONLY
%token REF
%token RETURN
%token REMOVE
%token SBYTE
%token SEALED
%token SHORT
%token SIZEOF
%token STACKALLOC
%token STATIC
%token STRING
%token STRUCT
%token SWITCH
%token THIS
%token THROW
%token TRUE
%token TRY
%token TYPEOF
%token UINT
%token ULONG
%token UNCHECKED
%token UNSAFE
%token USHORT
%token USING
%token VIRTUAL
%token VOID
%token VOLATILE
%token WHERE
%token WHILE
%token ARGLIST
%token PARTIAL
%token ARROW
%token FROM
%token FROM_FIRST
%token JOIN
%token ON
%token EQUALS
%token SELECT
%token GROUP
%token BY
%token LET
%token ORDERBY
%token ASCENDING
%token DESCENDING
%token INTO
%token INTERR_NULLABLE
%token EXTERN_ALIAS
%token REFVALUE
%token REFTYPE
%token MAKEREF
%token ASYNC
%token AWAIT
%token INTERR_OPERATOR
%token WHEN
%token INTERPOLATED_STRING
%token INTERPOLATED_STRING_END
%token THROW_EXPR
%token GET
%token SET
//%token LAST_KEYWORD
%token OPEN_BRACE
%token CLOSE_BRACE
%token OPEN_BRACKET
%token CLOSE_BRACKET
%token OPEN_PARENS
%token CLOSE_PARENS
%token DOT
%token COMMA
%token COLON
%token SEMICOLON
%token TILDE
%token PLUS
%token MINUS
%token BANG
%token ASSIGN
%token OP_LT
%token OP_GT
%token BITWISE_AND
%token BITWISE_OR
%token STAR
%token PERCENT
%token DIV
%token CARRET
%token INTERR
%token DOUBLE_COLON
%token OP_INC
%token OP_DEC
%token OP_SHIFT_LEFT
%token OP_SHIFT_RIGHT
%token OP_LE
%token OP_GE
%token OP_EQ
%token OP_NE
%token OP_AND
%token OP_OR
%token OP_MULT_ASSIGN
%token OP_DIV_ASSIGN
%token OP_MOD_ASSIGN
%token OP_ADD_ASSIGN
%token OP_SUB_ASSIGN
%token OP_SHIFT_LEFT_ASSIGN
%token OP_SHIFT_RIGHT_ASSIGN
%token OP_AND_ASSIGN
%token OP_XOR_ASSIGN
%token OP_OR_ASSIGN
%token OP_PTR
%token OP_COALESCING
%token OP_GENERICS_LT
%token OP_GENERICS_LT_DECL
%token OP_GENERICS_GT
%token LITERAL
%token IDENTIFIER
%token OPEN_PARENS_LAMBDA
%token OPEN_PARENS_CAST
%token GENERIC_DIMENSION
%token DEFAULT_COLON
%token OPEN_BRACKET_EXPR
%token OPEN_PARENS_DECONSTRUCT
%token REF_STRUCT
%token REF_PARTIAL
%token EVAL_STATEMENT_PARSER
%token EVAL_COMPILATION_UNIT_PARSER
%token EVAL_USING_DECLARATIONS_UNIT_PARSER
%token DOC_SEE
%token GENERATE_COMPLETION
%token COMPLETE_COMPLETION
//%token UMINUS

//%left /*1*/ LAST_KEYWORD
%nonassoc /*2*/ IF
%nonassoc /*3*/ ELSE
%right /*4*/ ASSIGN
%right /*5*/ OP_COALESCING
%right /*6*/ INTERR
%left /*7*/ OP_OR
%left /*8*/ OP_AND
%left /*9*/ BITWISE_OR
%left /*10*/ BITWISE_AND
%left /*11*/ OP_SHIFT_LEFT OP_SHIFT_RIGHT
%left /*12*/ PLUS MINUS
%left /*13*/ STAR PERCENT DIV
%right /*14*/ BANG CARRET //UMINUS
%nonassoc /*15*/ OP_INC OP_DEC
%left /*16*/ OPEN_PARENS
%left /*17*/ OPEN_BRACE OPEN_BRACKET
%left /*18*/ DOT

%start compilation_unit

%%

compilation_unit :
	outer_declaration //opt_EOF
	| interactive_parsing //opt_EOF
	| documentation_parsing
	;

outer_declaration :
	opt_extern_alias_directives opt_using_directives
	| opt_extern_alias_directives opt_using_directives namespace_or_type_declarations opt_attributes
	| opt_extern_alias_directives opt_using_directives attribute_sections
	//| error
	;

//opt_EOF :
//	/*empty*/
//	| EOF
//	;

extern_alias_directives :
	extern_alias_directive
	| extern_alias_directives extern_alias_directive
	;

extern_alias_directive :
	EXTERN_ALIAS IDENTIFIER IDENTIFIER SEMICOLON
	//| EXTERN_ALIAS error
	;

using_directives :
	using_directive
	| using_directives using_directive
	;

using_directive :
	using_namespace
	;

using_namespace :
	USING opt_static namespace_or_type_expr SEMICOLON
	| USING opt_static IDENTIFIER ASSIGN /*4R*/ namespace_or_type_expr SEMICOLON
	//| USING error
	;

opt_static :
	/*empty*/
	| STATIC
	;

namespace_declaration :
	opt_attributes NAMESPACE namespace_name OPEN_BRACE /*17L*/ opt_extern_alias_directives opt_using_directives opt_namespace_or_type_declarations CLOSE_BRACE opt_semicolon_error
	| opt_attributes NAMESPACE namespace_name
	;

opt_semicolon_error :
	/*empty*/
	| SEMICOLON
	//| error
	;

namespace_name :
	IDENTIFIER
	| namespace_name DOT /*18L*/ IDENTIFIER
	//| error
	;

opt_semicolon :
	/*empty*/
	| SEMICOLON
	;

opt_comma :
	/*empty*/
	| COMMA
	;

opt_using_directives :
	/*empty*/
	| using_directives
	;

opt_extern_alias_directives :
	/*empty*/
	| extern_alias_directives
	;

opt_namespace_or_type_declarations :
	/*empty*/
	| namespace_or_type_declarations
	;

namespace_or_type_declarations :
	namespace_or_type_declaration
	| namespace_or_type_declarations namespace_or_type_declaration
	;

namespace_or_type_declaration :
	type_declaration
	| namespace_declaration
	| attribute_sections CLOSE_BRACE
	;

type_declaration :
	class_declaration
	| struct_declaration
	| interface_declaration
	| enum_declaration
	| delegate_declaration
	;

opt_attributes :
	/*empty*/
	| attribute_sections
	;

attribute_sections :
	attribute_section
	| attribute_sections attribute_section
	;

attribute_section :
	OPEN_BRACKET /*17L*/ attribute_section_cont
	;

attribute_section_cont :
	attribute_target COLON attribute_list opt_comma CLOSE_BRACKET
	| attribute_list opt_comma CLOSE_BRACKET
	//| IDENTIFIER error
	//| error
	;

attribute_target :
	IDENTIFIER
	| EVENT
	| RETURN
	;

attribute_list :
	attribute
	| attribute_list COMMA attribute
	;

attribute :
	attribute_name opt_attribute_arguments
	;

attribute_name :
	namespace_or_type_expr
	;

opt_attribute_arguments :
	/*empty*/
	| OPEN_PARENS /*16L*/ attribute_arguments CLOSE_PARENS
	;

attribute_arguments :
	/*empty*/
	| positional_or_named_argument
	| named_attribute_argument
	| attribute_arguments COMMA positional_or_named_argument
	| attribute_arguments COMMA named_attribute_argument
	;

positional_or_named_argument :
	expression
	| named_argument
	//| error
	;

named_attribute_argument :
	IDENTIFIER ASSIGN /*4R*/ expression
	;

named_argument :
	identifier_inside_body COLON opt_named_modifier named_argument_expr
	| identifier_inside_body COLON OUT named_argument_expr_or_out_variable_declaration
	;

named_argument_expr :
	expression_or_error
	;

named_argument_expr_or_out_variable_declaration :
	expression_or_error
	| out_variable_declaration
	;

opt_named_modifier :
	/*empty*/
	| REF
	;

opt_class_member_declarations :
	/*empty*/
	| class_member_declarations
	;

class_member_declarations :
	class_member_declaration
	| class_member_declarations class_member_declaration
	;

class_member_declaration :
	constant_declaration
	| field_declaration
	| method_declaration
	| property_declaration
	| event_declaration
	| indexer_declaration
	| operator_declaration
	| constructor_declaration
	| primary_constructor_body
	| destructor_declaration
	| type_declaration
	| attributes_without_members
	| incomplete_member
	//| error
	;

primary_constructor_body :
	OPEN_BRACE /*17L*/ opt_statement_list block_end
	;

struct_keyword :
	STRUCT
	| REF_STRUCT
	| REF_PARTIAL STRUCT
	;

struct_declaration :
	opt_attributes opt_modifiers opt_partial struct_keyword type_declaration_name opt_primary_parameters opt_class_base opt_type_parameter_constraints_clauses OPEN_BRACE /*17L*/ opt_class_member_declarations CLOSE_BRACE opt_semicolon
	//| opt_attributes opt_modifiers opt_partial struct_keyword error
	;

constant_declaration :
	opt_attributes opt_modifiers CONST type IDENTIFIER constant_initializer opt_constant_declarators SEMICOLON
	//| opt_attributes opt_modifiers CONST type error
	;

opt_constant_declarators :
	/*empty*/
	| constant_declarators
	;

constant_declarators :
	constant_declarator
	| constant_declarators constant_declarator
	;

constant_declarator :
	COMMA IDENTIFIER constant_initializer
	;

constant_initializer :
	ASSIGN /*4R*/ constant_initializer_expr
	//| error
	;

constant_initializer_expr :
	constant_expression
	| array_initializer
	;

field_declaration :
	opt_attributes opt_modifiers ref_member_type IDENTIFIER opt_field_initializer opt_field_declarators SEMICOLON
	| opt_attributes opt_modifiers FIXED simple_type IDENTIFIER fixed_field_size opt_fixed_field_declarators SEMICOLON
	//| opt_attributes opt_modifiers FIXED simple_type error SEMICOLON
	;

opt_field_initializer :
	/*empty*/
	| ASSIGN /*4R*/ variable_initializer
	;

opt_field_declarators :
	/*empty*/
	| field_declarators
	;

field_declarators :
	field_declarator
	| field_declarators field_declarator
	;

field_declarator :
	COMMA IDENTIFIER
	| COMMA IDENTIFIER ASSIGN /*4R*/ variable_initializer
	;

opt_fixed_field_declarators :
	/*empty*/
	| fixed_field_declarators
	;

fixed_field_declarators :
	fixed_field_declarator
	| fixed_field_declarators fixed_field_declarator
	;

fixed_field_declarator :
	COMMA IDENTIFIER fixed_field_size
	;

fixed_field_size :
	OPEN_BRACKET /*17L*/ expression CLOSE_BRACKET
	//| OPEN_BRACKET /*17L*/ error
	;

variable_initializer :
	expression
	| array_initializer
	//| error
	;

method_declaration :
	method_header method_body
	;

ref_member_type :
	member_type
	| REF type
	| REF READONLY type
	;

method_header :
	opt_attributes opt_modifiers ref_member_type method_declaration_name OPEN_PARENS /*16L*/ opt_formal_parameter_list CLOSE_PARENS opt_type_parameter_constraints_clauses
	| opt_attributes opt_modifiers PARTIAL VOID method_declaration_name OPEN_PARENS /*16L*/ opt_formal_parameter_list CLOSE_PARENS opt_type_parameter_constraints_clauses
	| opt_attributes opt_modifiers ref_member_type modifiers method_declaration_name OPEN_PARENS /*16L*/ opt_formal_parameter_list CLOSE_PARENS
	//| opt_attributes opt_modifiers ref_member_type method_declaration_name error
	;

method_body :
	block
	| expression_block
	| SEMICOLON
	;

destructor_body :
	method_body
	;

constructor_body :
	block_prepared
	| SEMICOLON
	| ARROW expression SEMICOLON
	;

expression_block :
	ARROW lambda_arrow_expression SEMICOLON
	;

opt_formal_parameter_list :
	/*empty*/
	| formal_parameter_list
	;

formal_parameter_list :
	fixed_parameters
	| fixed_parameters COMMA parameter_array
	| fixed_parameters COMMA arglist_modifier
	//| parameter_array COMMA error
	//| fixed_parameters COMMA parameter_array COMMA error
	//| arglist_modifier COMMA error
	//| fixed_parameters COMMA ARGLIST COMMA error
	| parameter_array
	| arglist_modifier
	//| error
	;

fixed_parameters :
	fixed_parameter
	| fixed_parameters COMMA fixed_parameter
	;

fixed_parameter :
	opt_attributes opt_parameter_modifier parameter_type identifier_inside_body
	| opt_attributes opt_parameter_modifier parameter_type identifier_inside_body OPEN_BRACKET /*17L*/ CLOSE_BRACKET
	//| attribute_sections error
	//| opt_attributes opt_parameter_modifier parameter_type error
	| opt_attributes opt_parameter_modifier parameter_type identifier_inside_body ASSIGN /*4R*/ constant_expression
	;

opt_parameter_modifier :
	/*empty*/
	| parameter_modifiers
	;

parameter_modifiers :
	parameter_modifier
	| parameter_modifiers parameter_modifier
	;

parameter_modifier :
	REF
	| OUT
	| THIS
	| IN
	;

parameter_array :
	opt_attributes params_modifier type IDENTIFIER
	| opt_attributes params_modifier type IDENTIFIER ASSIGN /*4R*/ constant_expression
	//| opt_attributes params_modifier type error
	;

params_modifier :
	PARAMS
	| PARAMS parameter_modifier
	| PARAMS params_modifier
	;

arglist_modifier :
	ARGLIST
	;

property_declaration :
	opt_attributes opt_modifiers ref_member_type member_declaration_name OPEN_BRACE /*17L*/ accessor_declarations CLOSE_BRACE opt_property_initializer
	| opt_attributes opt_modifiers ref_member_type member_declaration_name expression_block
	;

opt_property_initializer :
	/*empty*/
	| ASSIGN /*4R*/ property_initializer SEMICOLON
	;

property_initializer :
	expression
	| array_initializer
	;

indexer_declaration :
	opt_attributes opt_modifiers ref_member_type indexer_declaration_name OPEN_BRACKET /*17L*/ opt_formal_parameter_list CLOSE_BRACKET indexer_body
	;

indexer_body :
	OPEN_BRACE /*17L*/ accessor_declarations CLOSE_BRACE
	| expression_block
	;

accessor_declarations :
	get_accessor_declaration
	| get_accessor_declaration accessor_declarations
	| set_accessor_declaration
	| set_accessor_declaration accessor_declarations
	//| error
	;

get_accessor_declaration :
	opt_attributes opt_modifiers GET accessor_body
	;

set_accessor_declaration :
	opt_attributes opt_modifiers SET accessor_body
	;

accessor_body :
	block
	| expression_block
	| SEMICOLON
	//| error
	;

interface_declaration :
	opt_attributes opt_modifiers opt_partial INTERFACE type_declaration_name opt_class_base opt_type_parameter_constraints_clauses OPEN_BRACE /*17L*/ opt_interface_member_declarations CLOSE_BRACE opt_semicolon
	//| opt_attributes opt_modifiers opt_partial INTERFACE error
	;

opt_interface_member_declarations :
	/*empty*/
	| interface_member_declarations
	;

interface_member_declarations :
	interface_member_declaration
	| interface_member_declarations interface_member_declaration
	;

interface_member_declaration :
	constant_declaration
	| field_declaration
	| method_declaration
	| property_declaration
	| event_declaration
	| indexer_declaration
	| operator_declaration
	| constructor_declaration
	| type_declaration
	;

operator_declaration :
	opt_attributes opt_modifiers operator_declarator method_body
	;

operator_type :
	type_expression_or_array
	| VOID
	;

operator_declarator :
	operator_type OPERATOR overloadable_operator OPEN_PARENS /*16L*/ opt_formal_parameter_list CLOSE_PARENS
	| conversion_operator_declarator
	;

overloadable_operator :
	BANG /*14R*/
	| TILDE
	| OP_INC /*15N*/
	| OP_DEC /*15N*/
	| TRUE
	| FALSE
	| PLUS /*12L*/
	| MINUS /*12L*/
	| STAR /*13L*/
	| DIV /*13L*/
	| PERCENT /*13L*/
	| BITWISE_AND /*10L*/
	| BITWISE_OR /*9L*/
	| CARRET /*14R*/
	| OP_SHIFT_LEFT /*11L*/
	| OP_SHIFT_RIGHT /*11L*/
	| OP_EQ
	| OP_NE
	| OP_GT
	| OP_LT
	| OP_GE
	| OP_LE
	| IS
	;

conversion_operator_declarator :
	IMPLICIT OPERATOR type OPEN_PARENS /*16L*/ opt_formal_parameter_list CLOSE_PARENS
	| EXPLICIT OPERATOR type OPEN_PARENS /*16L*/ opt_formal_parameter_list CLOSE_PARENS
	//| IMPLICIT error
	//| EXPLICIT error
	;

constructor_declaration :
	constructor_declarator constructor_body
	;

constructor_declarator :
	opt_attributes opt_modifiers IDENTIFIER OPEN_PARENS /*16L*/ opt_formal_parameter_list CLOSE_PARENS opt_constructor_initializer
	;

opt_constructor_initializer :
	/*empty*/
	| constructor_initializer
	;

constructor_initializer :
	COLON BASE OPEN_PARENS /*16L*/ opt_argument_list CLOSE_PARENS
	| COLON THIS OPEN_PARENS /*16L*/ opt_argument_list CLOSE_PARENS
	//| COLON error
	//| error
	;

destructor_declaration :
	opt_attributes opt_modifiers TILDE IDENTIFIER OPEN_PARENS /*16L*/ CLOSE_PARENS destructor_body
	;

event_declaration :
	opt_attributes opt_modifiers EVENT type member_declaration_name opt_event_initializer opt_event_declarators SEMICOLON
	| opt_attributes opt_modifiers EVENT type member_declaration_name OPEN_BRACE /*17L*/ event_accessor_declarations CLOSE_BRACE
	//| opt_attributes opt_modifiers EVENT type error
	;

opt_event_initializer :
	/*empty*/
	| ASSIGN /*4R*/ event_variable_initializer
	;

opt_event_declarators :
	/*empty*/
	| event_declarators
	;

event_declarators :
	event_declarator
	| event_declarators event_declarator
	;

event_declarator :
	COMMA IDENTIFIER
	| COMMA IDENTIFIER ASSIGN /*4R*/ event_variable_initializer
	;

event_variable_initializer :
	variable_initializer
	;

event_accessor_declarations :
	add_accessor_declaration remove_accessor_declaration
	| remove_accessor_declaration add_accessor_declaration
	| add_accessor_declaration
	| remove_accessor_declaration
	//| error
	;

add_accessor_declaration :
	opt_attributes opt_modifiers ADD event_accessor_block
	;

remove_accessor_declaration :
	opt_attributes opt_modifiers REMOVE event_accessor_block
	;

event_accessor_block :
	opt_semicolon
	| block
	| expression_block
	;

attributes_without_members :
	attribute_sections CLOSE_BRACE
	;

incomplete_member :
	opt_attributes opt_modifiers member_type CLOSE_BRACE
	;

enum_declaration :
	opt_attributes opt_modifiers ENUM type_declaration_name opt_enum_base OPEN_BRACE /*17L*/ opt_enum_member_declarations CLOSE_BRACE opt_semicolon
	;

opt_enum_base :
	/*empty*/
	| COLON type
	//| COLON error
	;

opt_enum_member_declarations :
	/*empty*/
	| enum_member_declarations
	| enum_member_declarations COMMA
	;

enum_member_declarations :
	enum_member_declaration
	| enum_member_declarations COMMA enum_member_declaration
	;

enum_member_declaration :
	opt_attributes IDENTIFIER
	| opt_attributes IDENTIFIER ASSIGN /*4R*/ constant_expression
	//| opt_attributes IDENTIFIER error
	| attributes_without_members
	;

delegate_declaration :
	opt_attributes opt_modifiers DELEGATE ref_member_type type_declaration_name OPEN_PARENS /*16L*/ opt_formal_parameter_list CLOSE_PARENS opt_type_parameter_constraints_clauses SEMICOLON
	;

opt_nullable :
	/*empty*/
	| INTERR_NULLABLE
	;

namespace_or_type_expr :
	member_name
	| qualified_alias_member IDENTIFIER opt_type_argument_list
	| qualified_alias_member IDENTIFIER generic_dimension
	;

member_name :
	simple_name_expr
	| namespace_or_type_expr DOT /*18L*/ IDENTIFIER opt_type_argument_list
	| namespace_or_type_expr DOT /*18L*/ IDENTIFIER generic_dimension
	;

simple_name_expr :
	IDENTIFIER opt_type_argument_list
	| IDENTIFIER generic_dimension
	;

opt_type_argument_list :
	/*empty*/
	| OP_GENERICS_LT type_arguments OP_GENERICS_GT
	//| OP_GENERICS_LT error
	;

type_arguments :
	type
	| type_arguments COMMA type
	;

type_declaration_name :
	IDENTIFIER opt_type_parameter_list
	;

member_declaration_name :
	method_declaration_name
	;

method_declaration_name :
	type_declaration_name
	| explicit_interface IDENTIFIER opt_type_parameter_list
	;

indexer_declaration_name :
	THIS
	| explicit_interface THIS
	;

explicit_interface :
	IDENTIFIER opt_type_argument_list DOT /*18L*/
	| qualified_alias_member IDENTIFIER opt_type_argument_list DOT /*18L*/
	| explicit_interface IDENTIFIER opt_type_argument_list DOT /*18L*/
	;

opt_type_parameter_list :
	/*empty*/
	| OP_GENERICS_LT_DECL type_parameters OP_GENERICS_GT
	;

type_parameters :
	type_parameter
	| type_parameters COMMA type_parameter
	;

type_parameter :
	opt_attributes opt_type_parameter_variance IDENTIFIER
	//| error
	;

type_and_void :
	type_expression_or_array
	| VOID
	;

member_type :
	type_and_void
	;

type :
	type_expression_or_array
	| void_invalid
	;

simple_type :
	type_expression
	| void_invalid
	;

parameter_type :
	type_expression_or_array
	| VOID
	;

type_expression_or_array :
	type_expression
	| type_expression rank_specifiers
	;

type_expression :
	namespace_or_type_expr opt_nullable
	| namespace_or_type_expr pointer_stars
	| builtin_type_expression
	| OPEN_PARENS /*16L*/ tuple_elements CLOSE_PARENS opt_nullable
	;

tuple_elements :
	tuple_element tuple_element_name
	| tuple_elements COMMA tuple_element tuple_element_name
	;

tuple_element_name :
	/*empty*/
	| IDENTIFIER
	;

tuple_element :
	parameter_type
	;

void_invalid :
	VOID
	;

builtin_type_expression :
	builtin_types opt_nullable
	| builtin_types pointer_stars
	| VOID pointer_stars
	;

type_list :
	base_type_name
	| type_list COMMA base_type_name
	;

base_type_name :
	type
	;

builtin_types :
	OBJECT
	| STRING
	| BOOL
	| DECIMAL
	| FLOAT
	| DOUBLE
	| integral_type
	;

integral_type :
	SBYTE
	| BYTE
	| SHORT
	| USHORT
	| INT
	| UINT
	| LONG
	| ULONG
	| CHAR
	;

primary_expression :
	type_name_expression
	| literal
	| array_creation_expression
	| parenthesized_expression
	| default_value_expression
	| invocation_expression
	| element_access
	| this_access
	| base_access
	| post_increment_expression
	| post_decrement_expression
	| object_or_delegate_creation_expression
	| anonymous_type_expression
	| typeof_expression
	| sizeof_expression
	| checked_expression
	| unchecked_expression
	| pointer_member_access
	| anonymous_method_expression
	| undocumented_expressions
	| interpolated_string
	| default_literal
	;

type_name_expression :
	simple_name_expr
	| IDENTIFIER GENERATE_COMPLETION
	| member_access
	;

literal :
	boolean_literal
	| tuple_literal
	| LITERAL
	| NULL
	;

boolean_literal :
	TRUE
	| FALSE
	;

tuple_literal :
	OPEN_PARENS /*16L*/ tuple_literal_elements CLOSE_PARENS
	;

tuple_literal_elements :
	tuple_literal_element COMMA tuple_literal_element
	| tuple_literal_elements COMMA tuple_literal_element
	;

tuple_literal_element :
	expression
	| IDENTIFIER COLON expression
	;

interpolated_string :
	INTERPOLATED_STRING interpolations INTERPOLATED_STRING_END
	| INTERPOLATED_STRING_END
	;

interpolations :
	interpolation
	| interpolations INTERPOLATED_STRING interpolation
	;

interpolation :
	expression
	| expression COMMA expression
	| expression COLON LITERAL
	| expression COMMA expression COLON LITERAL
	;

open_parens_any :
	OPEN_PARENS /*16L*/
	| OPEN_PARENS_CAST
	;

close_parens :
	CLOSE_PARENS
	| COMPLETE_COMPLETION
	;

parenthesized_expression :
	OPEN_PARENS /*16L*/ expression CLOSE_PARENS
	| OPEN_PARENS /*16L*/ expression COMPLETE_COMPLETION
	;

member_access :
	primary_expression DOT /*18L*/ identifier_inside_body opt_type_argument_list
	| primary_expression DOT /*18L*/ identifier_inside_body generic_dimension
	| primary_expression INTERR_OPERATOR DOT /*18L*/ identifier_inside_body opt_type_argument_list
	| builtin_types DOT /*18L*/ identifier_inside_body opt_type_argument_list
	| BASE DOT /*18L*/ identifier_inside_body opt_type_argument_list
	| AWAIT DOT /*18L*/ identifier_inside_body opt_type_argument_list
	| qualified_alias_member identifier_inside_body opt_type_argument_list
	| qualified_alias_member identifier_inside_body generic_dimension
	| primary_expression DOT /*18L*/ GENERATE_COMPLETION
	| primary_expression DOT /*18L*/ IDENTIFIER GENERATE_COMPLETION
	| builtin_types DOT /*18L*/ GENERATE_COMPLETION
	| builtin_types DOT /*18L*/ IDENTIFIER GENERATE_COMPLETION
	;

invocation_expression :
	primary_expression open_parens_any opt_argument_list close_parens
	//| primary_expression open_parens_any argument_list error
	//| primary_expression open_parens_any error
	;

opt_object_or_collection_initializer :
	/*empty*/
	| object_or_collection_initializer
	;

object_or_collection_initializer :
	OPEN_BRACE /*17L*/ opt_member_initializer_list close_brace_or_complete_completion
	| OPEN_BRACE /*17L*/ member_initializer_list COMMA CLOSE_BRACE
	;

opt_member_initializer_list :
	/*empty*/
	| member_initializer_list
	;

member_initializer_list :
	member_initializer
	| member_initializer_list COMMA member_initializer
	//| member_initializer_list error
	;

member_initializer :
	IDENTIFIER ASSIGN /*4R*/ initializer_value
	| AWAIT ASSIGN /*4R*/ initializer_value
	| GENERATE_COMPLETION
	| non_assignment_expression opt_COMPLETE_COMPLETION
	| OPEN_BRACE /*17L*/ expression_list CLOSE_BRACE
	| OPEN_BRACKET_EXPR argument_list CLOSE_BRACKET ASSIGN /*4R*/ initializer_value
	| OPEN_BRACE /*17L*/ CLOSE_BRACE
	;

initializer_value :
	expression
	| object_or_collection_initializer
	;

opt_argument_list :
	/*empty*/
	| argument_list
	;

argument_list :
	argument_or_named_argument
	| argument_list COMMA argument
	| argument_list COMMA named_argument
	//| argument_list COMMA error
	//| COMMA error
	;

argument :
	expression
	| non_simple_argument
	;

argument_or_named_argument :
	argument
	| named_argument
	;

non_simple_argument :
	REF variable_reference
	| OUT variable_reference
	| OUT out_variable_declaration
	| ARGLIST OPEN_PARENS /*16L*/ argument_list CLOSE_PARENS
	| ARGLIST OPEN_PARENS /*16L*/ CLOSE_PARENS
	| IN variable_reference
	;

out_variable_declaration :
	variable_type identifier_inside_body
	;

variable_reference :
	expression
	;

element_access :
	primary_expression OPEN_BRACKET_EXPR expression_list_arguments CLOSE_BRACKET
	| primary_expression INTERR_OPERATOR OPEN_BRACKET_EXPR expression_list_arguments CLOSE_BRACKET
	//| primary_expression OPEN_BRACKET_EXPR expression_list_arguments error
	//| primary_expression OPEN_BRACKET_EXPR error
	;

expression_list :
	expression_or_error
	| expression_list COMMA expression_or_error
	;

expression_list_arguments :
	expression_list_argument
	| expression_list_arguments COMMA expression_list_argument
	;

expression_list_argument :
	expression
	| named_argument
	;

this_access :
	THIS
	;

base_access :
	BASE OPEN_BRACKET_EXPR expression_list_arguments CLOSE_BRACKET
	//| BASE OPEN_BRACKET /*17L*/ error
	;

post_increment_expression :
	primary_expression OP_INC /*15N*/
	;

post_decrement_expression :
	primary_expression OP_DEC /*15N*/
	;

object_or_delegate_creation_expression :
	NEW new_expr_type open_parens_any opt_argument_list CLOSE_PARENS opt_object_or_collection_initializer
	| NEW new_expr_type object_or_collection_initializer
	;

array_creation_expression :
	NEW new_expr_type OPEN_BRACKET_EXPR expression_list CLOSE_BRACKET opt_rank_specifier opt_array_initializer
	| NEW new_expr_type rank_specifiers opt_array_initializer
	| NEW rank_specifier array_initializer
	//| NEW new_expr_type OPEN_BRACKET /*17L*/ CLOSE_BRACKET OPEN_BRACKET_EXPR error CLOSE_BRACKET
	//| NEW new_expr_type error
	;

new_expr_type :
	simple_type
	;

anonymous_type_expression :
	NEW OPEN_BRACE /*17L*/ anonymous_type_parameters_opt_comma CLOSE_BRACE
	| NEW OPEN_BRACE /*17L*/ GENERATE_COMPLETION
	;

anonymous_type_parameters_opt_comma :
	anonymous_type_parameters_opt
	| anonymous_type_parameters COMMA
	;

anonymous_type_parameters_opt :
	/*empty*/
	| anonymous_type_parameters
	;

anonymous_type_parameters :
	anonymous_type_parameter
	| anonymous_type_parameters COMMA anonymous_type_parameter
	| COMPLETE_COMPLETION
	| anonymous_type_parameter COMPLETE_COMPLETION
	;

anonymous_type_parameter :
	identifier_inside_body ASSIGN /*4R*/ variable_initializer
	| identifier_inside_body
	| member_access
	//| error
	;

opt_rank_specifier :
	/*empty*/
	| rank_specifiers
	;

rank_specifiers :
	rank_specifier
	| rank_specifier rank_specifiers
	;

rank_specifier :
	OPEN_BRACKET /*17L*/ CLOSE_BRACKET
	| OPEN_BRACKET /*17L*/ dim_separators CLOSE_BRACKET
	;

dim_separators :
	COMMA
	| dim_separators COMMA
	;

opt_array_initializer :
	/*empty*/
	| array_initializer
	;

array_initializer :
	OPEN_BRACE /*17L*/ CLOSE_BRACE
	| OPEN_BRACE /*17L*/ variable_initializer_list opt_comma CLOSE_BRACE
	;

variable_initializer_list :
	variable_initializer
	| variable_initializer_list COMMA variable_initializer
	;

typeof_expression :
	TYPEOF open_parens_any typeof_type_expression CLOSE_PARENS
	;

typeof_type_expression :
	type_and_void
	//| error
	;

generic_dimension :
	GENERIC_DIMENSION
	;

qualified_alias_member :
	IDENTIFIER DOUBLE_COLON
	;

sizeof_expression :
	SIZEOF open_parens_any type CLOSE_PARENS
	//| SIZEOF open_parens_any type error
	;

checked_expression :
	CHECKED open_parens_any expression CLOSE_PARENS
	//| CHECKED error
	;

unchecked_expression :
	UNCHECKED open_parens_any expression CLOSE_PARENS
	//| UNCHECKED error
	;

pointer_member_access :
	primary_expression OP_PTR IDENTIFIER opt_type_argument_list
	;

anonymous_method_expression :
	DELEGATE opt_anonymous_method_signature block
	| ASYNC DELEGATE opt_anonymous_method_signature block
	;

opt_anonymous_method_signature :
	/*empty*/
	| anonymous_method_signature
	;

anonymous_method_signature :
	OPEN_PARENS /*16L*/ opt_formal_parameter_list CLOSE_PARENS
	;

default_value_expression :
	DEFAULT_VALUE open_parens_any type CLOSE_PARENS
	;

default_literal :
	DEFAULT
	;

unary_expression :
	primary_expression
	| BANG /*14R*/ prefixed_unary_expression
	| TILDE prefixed_unary_expression
	| OPEN_PARENS_CAST type CLOSE_PARENS prefixed_unary_expression
	| AWAIT prefixed_unary_expression
	| THROW_EXPR prefixed_unary_expression
	//| BANG /*14R*/ error
	//| TILDE error
	//| OPEN_PARENS_CAST type CLOSE_PARENS error
	//| AWAIT error
	;

prefixed_unary_expression :
	unary_expression
	| PLUS /*12L*/ prefixed_unary_expression
	| MINUS /*12L*/ prefixed_unary_expression
	| OP_INC /*15N*/ prefixed_unary_expression
	| OP_DEC /*15N*/ prefixed_unary_expression
	| STAR /*13L*/ prefixed_unary_expression
	| BITWISE_AND /*10L*/ prefixed_unary_expression
	//| PLUS /*12L*/ error
	//| MINUS /*12L*/ error
	//| OP_INC /*15N*/ error
	//| OP_DEC /*15N*/ error
	//| STAR /*13L*/ error
	//| BITWISE_AND /*10L*/ error
	;

multiplicative_expression :
	prefixed_unary_expression
	| multiplicative_expression STAR /*13L*/ prefixed_unary_expression
	| multiplicative_expression DIV /*13L*/ prefixed_unary_expression
	| multiplicative_expression PERCENT /*13L*/ prefixed_unary_expression
	//| multiplicative_expression STAR /*13L*/ error
	//| multiplicative_expression DIV /*13L*/ error
	//| multiplicative_expression PERCENT /*13L*/ error
	;

additive_expression :
	multiplicative_expression
	| additive_expression PLUS /*12L*/ multiplicative_expression
	| additive_expression MINUS /*12L*/ multiplicative_expression
	//| additive_expression PLUS /*12L*/ error
	//| additive_expression MINUS /*12L*/ error
	| additive_expression AS type
	| additive_expression IS pattern_type_expr opt_identifier
	| additive_expression IS pattern_expr
	//| additive_expression AS error
	//| additive_expression IS error
	| AWAIT IS type
	| AWAIT AS type
	;

pattern_type_expr :
	variable_type
	;

pattern_expr :
	literal
	| PLUS /*12L*/ prefixed_unary_expression
	| MINUS /*12L*/ prefixed_unary_expression
	| sizeof_expression
	| default_value_expression
	| OPEN_PARENS_CAST type CLOSE_PARENS prefixed_unary_expression
	| STAR /*13L*/
	| pattern_property
	;

pattern_property :
	type_name_expression OPEN_BRACE /*17L*/ pattern_property_list CLOSE_BRACE
	;

pattern_property_list :
	pattern_property_entry
	| pattern_property_list COMMA pattern_property_entry
	;

pattern_property_entry :
	identifier_inside_body IS pattern
	;

pattern :
	pattern_expr
	| pattern_type_expr opt_identifier
	;

shift_expression :
	additive_expression
	| shift_expression OP_SHIFT_LEFT /*11L*/ additive_expression
	| shift_expression OP_SHIFT_RIGHT /*11L*/ additive_expression
	//| shift_expression OP_SHIFT_LEFT /*11L*/ error
	//| shift_expression OP_SHIFT_RIGHT /*11L*/ error
	;

relational_expression :
	shift_expression
	| relational_expression OP_LT shift_expression
	| relational_expression OP_GT shift_expression
	| relational_expression OP_LE shift_expression
	| relational_expression OP_GE shift_expression
	//| relational_expression OP_LT error
	//| relational_expression OP_GT error
	//| relational_expression OP_LE error
	//| relational_expression OP_GE error
	;

equality_expression :
	relational_expression
	| equality_expression OP_EQ relational_expression
	| equality_expression OP_NE relational_expression
	//| equality_expression OP_EQ error
	//| equality_expression OP_NE error
	;

and_expression :
	equality_expression
	| and_expression BITWISE_AND /*10L*/ equality_expression
	//| and_expression BITWISE_AND /*10L*/ error
	;

exclusive_or_expression :
	and_expression
	| exclusive_or_expression CARRET /*14R*/ and_expression
	//| exclusive_or_expression CARRET /*14R*/ error
	;

inclusive_or_expression :
	exclusive_or_expression
	| inclusive_or_expression BITWISE_OR /*9L*/ exclusive_or_expression
	//| inclusive_or_expression BITWISE_OR /*9L*/ error
	;

conditional_and_expression :
	inclusive_or_expression
	| conditional_and_expression OP_AND /*8L*/ inclusive_or_expression
	//| conditional_and_expression OP_AND /*8L*/ error
	;

conditional_or_expression :
	conditional_and_expression
	| conditional_or_expression OP_OR /*7L*/ conditional_and_expression
	//| conditional_or_expression OP_OR /*7L*/ error
	;

null_coalescing_expression :
	conditional_or_expression
	| conditional_or_expression OP_COALESCING /*5R*/ null_coalescing_expression
	;

conditional_oper_expr :
	expression
	| stackalloc_expression
	;

conditional_expression :
	null_coalescing_expression
	| null_coalescing_expression INTERR /*6R*/ conditional_oper_expr COLON conditional_oper_expr
	| null_coalescing_expression INTERR /*6R*/ conditional_oper_expr COLON THROW prefixed_unary_expression
	| null_coalescing_expression INTERR /*6R*/ reference_expression COLON reference_expression
	//| null_coalescing_expression INTERR /*6R*/ conditional_oper_expr error
	//| null_coalescing_expression INTERR /*6R*/ conditional_oper_expr COLON error
	| null_coalescing_expression INTERR /*6R*/ conditional_oper_expr COLON CLOSE_BRACE
	;

assignment_expression :
	prefixed_unary_expression ASSIGN /*4R*/ expression
	| prefixed_unary_expression OP_MULT_ASSIGN expression
	| prefixed_unary_expression OP_DIV_ASSIGN expression
	| prefixed_unary_expression OP_MOD_ASSIGN expression
	| prefixed_unary_expression OP_ADD_ASSIGN expression
	| prefixed_unary_expression OP_SUB_ASSIGN expression
	| prefixed_unary_expression OP_SHIFT_LEFT_ASSIGN expression
	| prefixed_unary_expression OP_SHIFT_RIGHT_ASSIGN expression
	| prefixed_unary_expression OP_AND_ASSIGN expression
	| prefixed_unary_expression OP_OR_ASSIGN expression
	| prefixed_unary_expression OP_XOR_ASSIGN expression
	| OPEN_PARENS_DECONSTRUCT deconstruct_assignment CLOSE_PARENS ASSIGN /*4R*/ expression
	| OPEN_PARENS_DECONSTRUCT deconstruct_declaration CLOSE_PARENS ASSIGN /*4R*/ expression
	;

deconstruct_assignment :
	expression COMMA expression
	| deconstruct_assignment COMMA expression
	;

deconstruct_declaration :
	variable_type identifier_inside_body
	| deconstruct_declaration COMMA variable_type identifier_inside_body
	| deconstruct_declaration COMMA identifier_inside_body
	;

lambda_parameter_list :
	lambda_parameter
	| lambda_parameter_list COMMA lambda_parameter
	;

lambda_parameter :
	parameter_modifier parameter_type identifier_inside_body
	| parameter_type identifier_inside_body
	| IDENTIFIER
	| AWAIT
	;

opt_lambda_parameter_list :
	/*empty*/
	| lambda_parameter_list
	;

lambda_expression_body :
	lambda_arrow_expression
	| block
	//| error
	;

lambda_arrow_expression :
	expression
	| reference_expression
	;

expression_or_error :
	expression
	//| error
	;

lambda_expression :
	IDENTIFIER ARROW lambda_expression_body
	| AWAIT ARROW lambda_expression_body
	| ASYNC identifier_inside_body ARROW lambda_expression_body
	| OPEN_PARENS_LAMBDA opt_lambda_parameter_list CLOSE_PARENS ARROW lambda_expression_body
	| ASYNC OPEN_PARENS_LAMBDA opt_lambda_parameter_list CLOSE_PARENS ARROW lambda_expression_body
	;

expression :
	assignment_expression
	| non_assignment_expression
	;

non_assignment_expression :
	conditional_expression
	| lambda_expression
	| query_expression
	| ARGLIST
	;

undocumented_expressions :
	REFVALUE OPEN_PARENS /*16L*/ non_assignment_expression COMMA type CLOSE_PARENS
	| REFTYPE open_parens_any expression CLOSE_PARENS
	| MAKEREF open_parens_any expression CLOSE_PARENS
	;

constant_expression :
	expression
	;

boolean_expression :
	expression
	;

opt_primary_parameters :
	/*empty*/
	| primary_parameters
	;

primary_parameters :
	OPEN_PARENS /*16L*/ opt_formal_parameter_list CLOSE_PARENS
	;

opt_primary_parameters_with_class_base :
	/*empty*/
	| class_base
	| primary_parameters
	| primary_parameters class_base
	| primary_parameters class_base OPEN_PARENS /*16L*/ opt_argument_list CLOSE_PARENS
	;

class_declaration :
	opt_attributes opt_modifiers opt_partial CLASS type_declaration_name opt_primary_parameters_with_class_base opt_type_parameter_constraints_clauses OPEN_BRACE /*17L*/ opt_class_member_declarations CLOSE_BRACE opt_semicolon
	;

opt_partial :
	/*empty*/
	| PARTIAL
	;

opt_modifiers :
	/*empty*/
	| modifiers
	;

modifiers :
	modifier
	| modifiers modifier
	;

modifier :
	NEW
	| PUBLIC
	| PROTECTED
	| INTERNAL
	| PRIVATE
	| ABSTRACT
	| SEALED
	| STATIC
	| READONLY
	| VIRTUAL
	| OVERRIDE
	| EXTERN
	| VOLATILE
	| UNSAFE
	| ASYNC
	;

opt_class_base :
	/*empty*/
	| class_base
	;

class_base :
	COLON type_list
	//| COLON type_list error
	;

opt_type_parameter_constraints_clauses :
	/*empty*/
	| type_parameter_constraints_clauses
	;

type_parameter_constraints_clauses :
	type_parameter_constraints_clause
	| type_parameter_constraints_clauses type_parameter_constraints_clause
	;

type_parameter_constraints_clause :
	WHERE IDENTIFIER COLON type_parameter_constraints
	//| WHERE IDENTIFIER error
	;

type_parameter_constraints :
	type_parameter_constraint
	| type_parameter_constraints COMMA type_parameter_constraint
	;

type_parameter_constraint :
	type
	| NEW OPEN_PARENS /*16L*/ CLOSE_PARENS
	| CLASS
	| STRUCT
	;

opt_type_parameter_variance :
	/*empty*/
	| type_parameter_variance
	;

type_parameter_variance :
	OUT
	| IN
	;

block :
	OPEN_BRACE /*17L*/ opt_statement_list block_end
	;

block_end :
	CLOSE_BRACE
	| COMPLETE_COMPLETION
	;

block_prepared :
	OPEN_BRACE /*17L*/ opt_statement_list CLOSE_BRACE
	;

opt_statement_list :
	/*empty*/
	| statement_list
	;

statement_list :
	statement
	| statement_list statement
	;

statement :
	block_variable_declaration
	| valid_declaration_statement
	| labeled_statement
	//| error
	;

interactive_statement_list :
	interactive_statement
	| interactive_statement_list interactive_statement
	;

interactive_statement :
	block_variable_declaration
	| interactive_valid_declaration_statement
	| labeled_statement
	;

valid_declaration_statement :
	block
	| empty_statement
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	| try_statement
	| checked_statement
	| unchecked_statement
	| lock_statement
	| using_statement
	| unsafe_statement
	| fixed_statement
	;

interactive_valid_declaration_statement :
	block
	| empty_statement
	| interactive_expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	| try_statement
	| checked_statement
	| unchecked_statement
	| lock_statement
	| using_statement
	| unsafe_statement
	| fixed_statement
	;

embedded_statement :
	valid_declaration_statement
	| block_variable_declaration
	| labeled_statement
	//| error
	;

empty_statement :
	SEMICOLON
	;

labeled_statement :
	identifier_inside_body COLON statement
	;

variable_type :
	variable_type_simple
	| variable_type_simple rank_specifiers
	;

variable_type_simple :
	type_name_expression opt_nullable
	| type_name_expression pointer_stars
	| builtin_type_expression
	| tuple_type opt_nullable
	| void_invalid
	;

tuple_type :
	OPEN_PARENS /*16L*/ tuple_type_elements CLOSE_PARENS
	;

tuple_type_elements :
	variable_type IDENTIFIER COMMA variable_type IDENTIFIER
	| tuple_type_elements COMMA variable_type IDENTIFIER
	;

pointer_stars :
	pointer_star
	| pointer_star pointer_stars
	;

pointer_star :
	STAR /*13L*/
	;

identifier_inside_body :
	IDENTIFIER
	| AWAIT
	;

block_variable_declaration :
	variable_type identifier_inside_body opt_local_variable_initializer opt_variable_declarators SEMICOLON
	| CONST variable_type identifier_inside_body const_variable_initializer opt_const_declarators SEMICOLON
	| REF variable_type identifier_inside_body opt_local_variable_initializer opt_variable_declarators SEMICOLON
	| REF READONLY variable_type identifier_inside_body opt_local_variable_initializer opt_variable_declarators SEMICOLON
	;

opt_local_variable_initializer :
	/*empty*/
	| ASSIGN /*4R*/ block_variable_initializer
	//| error
	;

opt_variable_declarators :
	/*empty*/
	| variable_declarators
	;

opt_using_or_fixed_variable_declarators :
	/*empty*/
	| variable_declarators
	;

variable_declarators :
	variable_declarator
	| variable_declarators variable_declarator
	;

variable_declarator :
	COMMA identifier_inside_body
	| COMMA identifier_inside_body ASSIGN /*4R*/ block_variable_initializer
	;

const_variable_initializer :
	/*empty*/
	| ASSIGN /*4R*/ constant_initializer_expr
	;

opt_const_declarators :
	/*empty*/
	| const_declarators
	;

const_declarators :
	const_declarator
	| const_declarators const_declarator
	;

const_declarator :
	COMMA identifier_inside_body ASSIGN /*4R*/ constant_initializer_expr
	;

block_variable_initializer :
	variable_initializer
	| STACKALLOC simple_type OPEN_BRACKET_EXPR expression CLOSE_BRACKET
	| STACKALLOC simple_type
	| reference_expression
	;

stackalloc_expression :
	STACKALLOC simple_type OPEN_BRACKET_EXPR expression CLOSE_BRACKET
	| STACKALLOC simple_type
	;

reference_expression :
	REF expression
	;

expression_statement :
	statement_expression SEMICOLON
	| statement_expression COMPLETE_COMPLETION
	| statement_expression CLOSE_BRACE
	;

interactive_expression_statement :
	interactive_statement_expression SEMICOLON
	| interactive_statement_expression COMPLETE_COMPLETION
	;

statement_expression :
	expression
	;

interactive_statement_expression :
	expression
	//| error
	;

selection_statement :
	if_statement
	| switch_statement
	;

if_statement :
	IF /*2N*/ open_parens_any boolean_expression CLOSE_PARENS embedded_statement
	| IF /*2N*/ open_parens_any boolean_expression CLOSE_PARENS embedded_statement ELSE /*3N*/ embedded_statement
	//| IF /*2N*/ open_parens_any boolean_expression error
	;

switch_statement :
	SWITCH open_parens_any expression CLOSE_PARENS OPEN_BRACE /*17L*/ opt_switch_sections CLOSE_BRACE
	//| SWITCH open_parens_any expression error
	;

opt_switch_sections :
	/*empty*/
	| switch_sections
	;

switch_sections :
	switch_section
	| switch_sections switch_section
	//| error
	;

switch_section :
	switch_labels statement_list
	;

switch_labels :
	switch_label
	| switch_labels switch_label
	;

switch_label :
	CASE constant_expression COLON
	//| CASE constant_expression error
	| CASE pattern_type_expr IDENTIFIER COLON
	| DEFAULT_COLON
	;

iteration_statement :
	while_statement
	| do_statement
	| for_statement
	| foreach_statement
	;

while_statement :
	WHILE open_parens_any boolean_expression CLOSE_PARENS embedded_statement
	//| WHILE open_parens_any boolean_expression error
	;

do_statement :
	DO embedded_statement WHILE open_parens_any boolean_expression CLOSE_PARENS SEMICOLON
	//| DO embedded_statement error
	//| DO embedded_statement WHILE open_parens_any boolean_expression error
	;

for_statement :
	FOR open_parens_any for_statement_cont
	;

for_statement_cont :
	opt_for_initializer SEMICOLON for_condition_and_iterator_part embedded_statement
	//| error
	;

for_condition_and_iterator_part :
	opt_for_condition SEMICOLON for_iterator_part
	| opt_for_condition close_parens_close_brace
	;

for_iterator_part :
	opt_for_iterator CLOSE_PARENS
	| opt_for_iterator CLOSE_BRACE
	;

close_parens_close_brace :
	CLOSE_PARENS
	| CLOSE_BRACE
	;

opt_for_initializer :
	/*empty*/
	| for_initializer
	;

for_initializer :
	variable_type identifier_inside_body opt_local_variable_initializer opt_variable_declarators
	| statement_expression_list
	;

opt_for_condition :
	/*empty*/
	| boolean_expression
	;

opt_for_iterator :
	/*empty*/
	| for_iterator
	;

for_iterator :
	statement_expression_list
	;

statement_expression_list :
	statement_expression
	| statement_expression_list COMMA statement_expression
	;

foreach_statement :
	/*FOREACH open_parens_any type error
	| FOREACH open_parens_any type identifier_inside_body error
	|*/ FOREACH open_parens_any type identifier_inside_body IN expression CLOSE_PARENS embedded_statement
	;

jump_statement :
	break_statement
	| continue_statement
	| goto_statement
	| return_statement
	| throw_statement
	| yield_statement
	;

break_statement :
	BREAK SEMICOLON
	;

continue_statement :
	CONTINUE SEMICOLON
	//| CONTINUE error
	;

goto_statement :
	GOTO identifier_inside_body SEMICOLON
	| GOTO CASE constant_expression SEMICOLON
	| GOTO DEFAULT SEMICOLON
	;

return_statement :
	RETURN opt_expression SEMICOLON
	| RETURN reference_expression SEMICOLON
	//| RETURN expression error
	//| RETURN error
	;

throw_statement :
	THROW expression SEMICOLON
	| THROW SEMICOLON
	//| THROW expression error
	//| THROW error
	;

yield_statement :
	identifier_inside_body RETURN opt_expression SEMICOLON
	//| identifier_inside_body RETURN expression error
	| identifier_inside_body BREAK SEMICOLON
	;

opt_expression :
	/*empty*/
	| expression
	;

try_statement :
	TRY block catch_clauses
	| TRY block FINALLY block
	| TRY block catch_clauses FINALLY block
	//| TRY block error
	;

catch_clauses :
	catch_clause
	| catch_clauses catch_clause
	;

opt_identifier :
	/*empty*/
	| identifier_inside_body
	;

catch_clause :
	CATCH opt_catch_filter block
	| CATCH open_parens_any type opt_identifier CLOSE_PARENS opt_catch_filter_or_error
	//| CATCH open_parens_any error
	;

opt_catch_filter_or_error :
	opt_catch_filter block_prepared
	//| error
	;

opt_catch_filter :
	/*empty*/
	| WHEN open_parens_any expression CLOSE_PARENS
	;

checked_statement :
	CHECKED block
	;

unchecked_statement :
	UNCHECKED block
	;

unsafe_statement :
	UNSAFE block
	;

lock_statement :
	LOCK open_parens_any expression CLOSE_PARENS embedded_statement
	//| LOCK open_parens_any expression error
	;

fixed_statement :
	FIXED open_parens_any variable_type identifier_inside_body using_or_fixed_variable_initializer opt_using_or_fixed_variable_declarators CLOSE_PARENS embedded_statement
	;

using_statement :
	USING open_parens_any variable_type identifier_inside_body using_initialization CLOSE_PARENS embedded_statement
	| USING open_parens_any expression CLOSE_PARENS embedded_statement
	//| USING open_parens_any expression error
	;

using_initialization :
	using_or_fixed_variable_initializer opt_using_or_fixed_variable_declarators
	//| error
	;

using_or_fixed_variable_initializer :
	/*empty*/
	| ASSIGN /*4R*/ variable_initializer
	;

query_expression :
	first_from_clause query_body
	| nested_from_clause query_body
	| first_from_clause COMPLETE_COMPLETION
	| nested_from_clause COMPLETE_COMPLETION
	;

first_from_clause :
	FROM_FIRST identifier_inside_body IN expression
	| FROM_FIRST type identifier_inside_body IN expression
	;

nested_from_clause :
	FROM identifier_inside_body IN expression
	| FROM type identifier_inside_body IN expression
	;

from_clause :
	FROM identifier_inside_body IN expression_or_error
	| FROM type identifier_inside_body IN expression_or_error
	;

query_body :
	query_body_clauses select_or_group_clause opt_query_continuation
	| select_or_group_clause opt_query_continuation
	| query_body_clauses COMPLETE_COMPLETION
	//| query_body_clauses error
	//| error
	;

select_or_group_clause :
	SELECT expression_or_error
	| GROUP expression_or_error by_expression
	;

by_expression :
	BY expression_or_error
	//| error
	;

query_body_clauses :
	query_body_clause
	| query_body_clauses query_body_clause
	;

query_body_clause :
	from_clause
	| let_clause
	| where_clause
	| join_clause
	| orderby_clause
	;

let_clause :
	LET identifier_inside_body ASSIGN /*4R*/ expression_or_error
	;

where_clause :
	WHERE expression_or_error
	;

join_clause :
	JOIN identifier_inside_body IN expression_or_error ON expression_or_error EQUALS expression_or_error opt_join_into
	| JOIN type identifier_inside_body IN expression_or_error ON expression_or_error EQUALS expression_or_error opt_join_into
	;

opt_join_into :
	/*empty*/
	| INTO identifier_inside_body
	;

orderby_clause :
	ORDERBY orderings
	;

orderings :
	order_by
	| order_by COMMA orderings_then_by
	;

orderings_then_by :
	then_by
	| orderings_then_by COMMA then_by
	;

order_by :
	expression
	| expression ASCENDING
	| expression DESCENDING
	;

then_by :
	expression
	| expression ASCENDING
	| expression DESCENDING
	;

opt_query_continuation :
	/*empty*/
	| INTO identifier_inside_body query_body
	;

interactive_parsing :
	EVAL_STATEMENT_PARSER //EOF
	| EVAL_USING_DECLARATIONS_UNIT_PARSER using_directives opt_COMPLETE_COMPLETION
	| EVAL_STATEMENT_PARSER interactive_statement_list opt_COMPLETE_COMPLETION
	| EVAL_COMPILATION_UNIT_PARSER interactive_compilation_unit
	;

interactive_compilation_unit :
	opt_extern_alias_directives opt_using_directives
	| opt_extern_alias_directives opt_using_directives namespace_or_type_declarations
	;

opt_COMPLETE_COMPLETION :
	/*empty*/
	| COMPLETE_COMPLETION
	;

close_brace_or_complete_completion :
	CLOSE_BRACE
	| COMPLETE_COMPLETION
	;

documentation_parsing :
	DOC_SEE doc_cref
	;

doc_cref :
	doc_type_declaration_name opt_doc_method_sig
	| builtin_types opt_doc_method_sig
	| VOID opt_doc_method_sig
	| builtin_types DOT /*18L*/ IDENTIFIER opt_doc_method_sig
	| doc_type_declaration_name DOT /*18L*/ THIS
	| doc_type_declaration_name DOT /*18L*/ THIS OPEN_BRACKET /*17L*/ opt_doc_parameters CLOSE_BRACKET
	| EXPLICIT OPERATOR type opt_doc_method_sig
	| IMPLICIT OPERATOR type opt_doc_method_sig
	| OPERATOR overloadable_operator opt_doc_method_sig
	;

doc_type_declaration_name :
	type_declaration_name
	| doc_type_declaration_name DOT /*18L*/ type_declaration_name
	;

opt_doc_method_sig :
	/*empty*/
	| OPEN_PARENS /*16L*/ opt_doc_parameters CLOSE_PARENS
	;

opt_doc_parameters :
	/*empty*/
	| doc_parameters
	;

doc_parameters :
	doc_parameter
	| doc_parameters COMMA doc_parameter
	;

doc_parameter :
	opt_parameter_modifier parameter_type
	;

%%

%x ISTR OB OCB

%%

[\n\r\t ]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"bool"	BOOL
"byte"	BYTE
"char"	CHAR
"void"	VOID
"decimal"	DECIMAL
"double"	DOUBLE
"float"	FLOAT
"int"	INT
"long"	LONG
"sbyte"	SBYTE
"short"	SHORT
"string"	STRING
"uint"	UINT
"ulong"	ULONG
"ushort"	USHORT
"object"	OBJECT
"+"	PLUS
"-"	MINUS
"!"	BANG
"&"	BITWISE_AND
"|"	BITWISE_OR
"*"	STAR
"%"	PERCENT
"/"	DIV
"^"	CARRET
"++"	OP_INC
"--"	OP_DEC
"<<"	OP_SHIFT_LEFT
">>"	OP_SHIFT_RIGHT
"<"	OP_LT
">"	OP_GT
"<="	OP_LE
">="	OP_GE
"=="	OP_EQ
"!="	OP_NE
"&&"	OP_AND
"||"	OP_OR
"->"	OP_PTR
"??"	OP_COALESCING
"*="	OP_MULT_ASSIGN
"/="	OP_DIV_ASSIGN
"%="	OP_MOD_ASSIGN
"+="	OP_ADD_ASSIGN
"-="	OP_SUB_ASSIGN
"<<="	OP_SHIFT_LEFT_ASSIGN
">>="	OP_SHIFT_RIGHT_ASSIGN
"&="	OP_AND_ASSIGN
"^="	OP_XOR_ASSIGN
"|="	OP_OR_ASSIGN

"abstract"	ABSTRACT
"as"	AS
"add"	ADD
"async"	ASYNC
"base"	BASE
"break"	BREAK
"case"	CASE
"catch"	CATCH
"checked"	CHECKED
"class"	CLASS
"const"	CONST
"continue"	CONTINUE
"default"	DEFAULT
"delegate"	DELEGATE
"do"	DO
"else"	ELSE
"enum"	ENUM
"event"	EVENT
"explicit"	EXPLICIT
"extern"	EXTERN
"false"	FALSE
"finally"	FINALLY
"fixed"	FIXED
"for"	FOR
"foreach"	FOREACH
"goto"	GOTO
"if"	IF
"implicit"	IMPLICIT
"in"	IN
"interface"	INTERFACE
"internal"	INTERNAL
"is"	IS
"lock"	LOCK
"namespace"	NAMESPACE
"new"	NEW
"null"	NULL
"operator"	OPERATOR
"out"	OUT
"override"	OVERRIDE
"params"	PARAMS
"private"	PRIVATE
"protected"	PROTECTED
"public"	PUBLIC
"readonly"	READONLY
"ref"	REF
"return"	RETURN
"remove"	REMOVE
"sealed"	SEALED
"sizeof"	SIZEOF
"stackalloc"	STACKALLOC
"static"	STATIC
"struct"	STRUCT
"switch"	SWITCH
"this"	THIS
"throw"	THROW
"true"	TRUE
"try"	TRY
"typeof"	TYPEOF
"unchecked"	UNCHECKED
"unsafe"	UNSAFE
"using"	USING
"virtual"	VIRTUAL
"volatile"	VOLATILE
"where"	WHERE
"while"	WHILE
"__arglist"	ARGLIST
"__refvalue"	REFVALUE
"__reftype"	REFTYPE
"__makeref"	MAKEREF
"partial"	PARTIAL
"=>"	ARROW
"from"	FROM
"join"	JOIN
"on"	ON
"equals"	EQUALS
"select"	SELECT
"group"	GROUP
"by"	BY
"let"	LET
"orderby"	ORDERBY
"ascending"	ASCENDING
"descending"	DESCENDING
"into"	INTO
"get"	GET
"set"	SET
"{"	OPEN_BRACE
"}"	CLOSE_BRACE
"["<OB> reject()
"[""]"<OCB>    reject()
<OB>{
    "["<INITIAL>    OPEN_BRACKET_EXPR
}
<OCB>{
    "["<INITIAL>    OPEN_BRACKET
}
"]"	CLOSE_BRACKET
"("	OPEN_PARENS
")"	CLOSE_PARENS
"."	DOT
","	COMMA
"default:"	DEFAULT_COLON
":"	COLON
";"	SEMICOLON
"~"	TILDE
"when"	WHEN
"${"<ISTR>	INTERPOLATED_STRING
<ISTR>{
	"}"	INTERPOLATED_STRING_END
}

"="	ASSIGN
AWAIT	AWAIT
COMPLETE_COMPLETION	COMPLETE_COMPLETION
DEFAULT_VALUE	DEFAULT_VALUE
DOC_SEE	DOC_SEE
DOUBLE_COLON	DOUBLE_COLON
EVAL_COMPILATION_UNIT_PARSER	EVAL_COMPILATION_UNIT_PARSER
EVAL_STATEMENT_PARSER	EVAL_STATEMENT_PARSER
EVAL_USING_DECLARATIONS_UNIT_PARSER	EVAL_USING_DECLARATIONS_UNIT_PARSER
EXTERN_ALIAS	EXTERN_ALIAS
FROM_FIRST	FROM_FIRST
GENERATE_COMPLETION	GENERATE_COMPLETION
GENERIC_DIMENSION	GENERIC_DIMENSION
"?"	INTERR
INTERR_NULLABLE	INTERR_NULLABLE
INTERR_OPERATOR	INTERR_OPERATOR
OPEN_PARENS_CAST	OPEN_PARENS_CAST
OPEN_PARENS_DECONSTRUCT	OPEN_PARENS_DECONSTRUCT
OPEN_PARENS_LAMBDA	OPEN_PARENS_LAMBDA
OP_GENERICS_GT	OP_GENERICS_GT
OP_GENERICS_LT	OP_GENERICS_LT
OP_GENERICS_LT_DECL	OP_GENERICS_LT_DECL
REF_PARTIAL	REF_PARTIAL
REF_STRUCT	REF_STRUCT
THROW_EXPR	THROW_EXPR

\"(\\.|[^"\r\n\\])*\"	LITERAL
'(\\.|[^'\r\n\\])'	LITERAL
[0-9]+	LITERAL
[0-9]+"."[0-9]+	LITERAL

[A-Za-z_][A-Za-z0-9_]*	IDENTIFIER


%%
