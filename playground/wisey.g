//From: https://github.com/vladfridman/wisey/blob/9d0efcee32e05c7b8dc3dfd22293737324294fea/src/Parser.ypp
/*Tokens*/
%token TANDOP
%token TBIND
%token TBITWISEANDBY
%token TBITWISEORBY
%token TBITWISEXORBY
%token TBREAK
%token TBUILD
%token TBYTE
%token TCASE
%token TCATCH
%token TCEQ
%token TCGE
%token TCHAR
%token TCLE
%token TCNE
%token TCONSTANT
%token TCONSTANTIDENTIFIER
%token TCONTINUE
%token TCONTROLLER
%token TCONTROLLERIDENTIFIER
%token TDECBYOP
%token TDECOP
%token TDEFAULT
%token TDIVIDEBY
%token TDO
%token TDOUBLE
%token TDOUBLECOLON
%token TELIPSIS
%token TELSE
%token TEXTENDS
%token TEXTERNAL
%token TFALLTHROUGH
%token TFALSE
%token TFIELDIDENTIFIER
%token TFLOAT
%token TFOR
%token THEXADECIMAL
%token TIDENTIFIER
%token TIF
%token TIMMEDIATE
%token TIMMUTABLE
%token TIMPLEMENTS
%token TIMPORT
%token TINCBYOP
%token TINCOP
%token TINJECT
%token TINSCOPE
%token TINSTANCEOF
%token TINTEGER
%token TINTERFACE
%token TINTERFACEIDENTIFIER
%token TLLVM
%token TLLVMARRAY
%token TLLVMDEREFERENCE
%token TLLVMFUNCTION
%token TLLVMGLOBAL
%token TLLVMI1
%token TLLVMI16
%token TLLVMI32
%token TLLVMI64
%token TLLVMI8
%token TLLVMPOINTER
%token TLLVMREFERENCE
%token TLLVMSTORE
%token TLLVMSTRUCT
%token TLLVMVOID
%token TLONG
%token TMODEL
%token TMODELIDENTIFIER
%token TMULTIPLYBY
%token TNEW
%token TNODE
%token TNODEIDENTIFIER
%token TNULL
%token TONHEAP
%token TONPOOL
%token TOROP
%token TOVERRIDE
%token TPACKAGE
%token TPRINT
%token TPRINTERR
%token TPRINTOUT
%token TPRIVATE
%token TPUBLIC
%token TRECEIVE
%token TREMINDERBY
%token TRETURN
%token TSHIFTLEFT
%token TSHIFTLEFTBY
%token TSHIFTRIGHT
%token TSHIFTRIGHTBY
%token TSTATE
%token TSTATIC
%token TSTRING_LITERAL
%token TSWITCH
%token TTHROW
%token TTHROWS
%token TTRUE
%token TTRY
%token TTYPEBOOLEAN
%token TTYPEBYTE
%token TTYPECHAR
%token TTYPEDOUBLE
%token TTYPEFLOAT
%token TTYPEINT
%token TTYPELONG
%token TTYPESTRING
%token TTYPEVOID
%token TWHILE
%token TWISEY
%token TWISEYMODEL
%token TWISEYOBJECT

%left /*1*/ '+' '-'
%left /*2*/ '*' '/' '%'

%start program

%%

program :
	package_optional global_statement_list
	;

package_optional :
	/*empty*/
	| TPACKAGE package_name ';'
	;

package_name :
	TIDENTIFIER
	| package_name '.' TIDENTIFIER
	;

global_statement_list :
	global_statement
	| global_statement_list global_statement
	;

global_statement :
	object_definition
	| external_object_definition
	| bind_action_statement
	| import_statement
	| llvm_statement
	;

llvm_statement :
	llvm_struct_definition
	| llvm_function_declaration
	| llvm_global_declaration
	| llvm_external_struct_definition
	;

llvm_global_declaration :
	llvm_type_specifier TIDENTIFIER ';'
	| TEXTERNAL llvm_type_specifier TIDENTIFIER ';'
	;

llvm_function_declaration :
	TLLVM TLLVMFUNCTION type_specifier llvm_function_name '(' llvm_function_argument_type_specifier_list ')' ';'
	| TLLVM TLLVMFUNCTION type_specifier llvm_function_name '(' ')' ';'
	| TLLVM TLLVMFUNCTION type_specifier llvm_function_name '(' llvm_function_argument_type_specifier_list ',' TELIPSIS ')' ';'
	| TLLVM TLLVMFUNCTION type_specifier llvm_function_name '(' TELIPSIS ')' ';'
	| TEXTERNAL TLLVM TLLVMFUNCTION type_specifier llvm_function_name '(' llvm_function_argument_type_specifier_list ')' ';'
	| TEXTERNAL TLLVM TLLVMFUNCTION type_specifier llvm_function_name '(' ')' ';'
	| TEXTERNAL TLLVM TLLVMFUNCTION type_specifier llvm_function_name '(' llvm_function_argument_type_specifier_list ',' TELIPSIS ')' ';'
	| TEXTERNAL TLLVM TLLVMFUNCTION type_specifier llvm_function_name '(' TELIPSIS ')' ';'
	;

llvm_struct_definition :
	TLLVM TLLVMSTRUCT TIDENTIFIER '{' native_type_specifier_list '}'
	| TLLVM TLLVMSTRUCT TIDENTIFIER '{' '}'
	;

llvm_external_struct_definition :
	TEXTERNAL TLLVM TLLVMSTRUCT TIDENTIFIER '{' native_type_specifier_list '}'
	| TEXTERNAL TLLVM TLLVMSTRUCT TIDENTIFIER '{' '}'
	;

native_type_specifier_list :
	native_type_specifier
	| native_type_specifier_list ',' native_type_specifier
	| native_type_specifier_list ','
	;

native_type_specifier :
	llvm_type_specifier
	| wisey_type_specifier
	;

llvm_type_specifier :
	llvm_non_array_type_specifier
	| llvm_array_specifier
	| llvm_pointer_type_specifier
	| llvm_pointer_owner_type_specifier
	;

wisey_type_specifier :
	wisey_object_type_specifier
	| wisey_object_owner_type_specifier
	| wisey_model_type_specifier
	| wisey_model_owner_type_specifier
	;

wisey_object_type_specifier :
	TWISEY TWISEYOBJECT
	;

wisey_object_owner_type_specifier :
	wisey_object_type_specifier '*' /*2L*/
	;

wisey_model_type_specifier :
	TWISEY TWISEYMODEL
	;

wisey_model_owner_type_specifier :
	wisey_model_type_specifier '*' /*2L*/
	;

llvm_non_array_type_specifier :
	llvm_i_type_specifier
	| llvm_struct_specifier
	| llvm_function_type_specifier
	| llvm_void_type_specifier
	;

llvm_pointer_owner_type_specifier :
	llvm_pointer_type_specifier '*' /*2L*/
	;

llvm_pointer_type_specifier :
	llvm_pointer_base_type_specifier TLLVMPOINTER
	| llvm_pointer_type_specifier TLLVMPOINTER
	;

llvm_pointer_base_type_specifier :
	llvm_i_type_specifier
	| llvm_struct_specifier
	| llvm_function_type_specifier
	| llvm_array_specifier
	;

llvm_i_type_specifier :
	TLLVM TLLVMI1
	| TLLVM TLLVMI8
	| TLLVM TLLVMI16
	| TLLVM TLLVMI32
	| TLLVM TLLVMI64
	;

llvm_void_type_specifier :
	TLLVM TLLVMVOID
	;

llvm_struct_specifier :
	TLLVM TLLVMSTRUCT TDOUBLECOLON TIDENTIFIER
	;

llvm_array_specifier :
	TLLVM TLLVMARRAY '(' llvm_non_array_type_specifier ',' llvm_array_dimensions ')'
	;

llvm_array_dimensions :
	TINTEGER
	| llvm_array_dimensions ',' TINTEGER
	;

llvm_function_type_specifier :
	native_type_specifier '(' llvm_function_argument_type_specifier_list ')'
	;

llvm_function_argument_type_specifier_list :
	type_specifier
	| llvm_function_argument_type_specifier_list ',' type_specifier
	;

llvm_function_definition :
	access_specifier TLLVM TLLVMFUNCTION native_type_specifier TIDENTIFIER '(' llvm_function_definition_arguments ')' compound_statement
	;

llvm_function_definition_arguments :
	/*empty*/
	| llvm_function_argument_declaration
	| llvm_function_definition_arguments ',' llvm_function_argument_declaration
	;

llvm_function_argument_declaration :
	type_specifier identifier
	;

llvm_function_call :
	TLLVM TLLVMFUNCTION TDOUBLECOLON llvm_function_name '(' call_arguments ')'
	;

llvm_function_name :
	string_identifier
	| llvm_function_name '.' string_identifier
	| TSTRING_LITERAL
	;

llvm_reference :
	TLLVM TLLVMREFERENCE '(' TIDENTIFIER ')'
	| TLLVM TLLVMREFERENCE '(' TFIELDIDENTIFIER ')'
	;

llvm_dereference :
	TLLVM TLLVMDEREFERENCE '(' expression ')'
	;

llvm_store :
	TLLVM TLLVMSTORE '(' expression ',' expression ')' ';'
	;

string_identifier :
	TIDENTIFIER
	| TMODELIDENTIFIER
	| TINTERFACEIDENTIFIER
	| TCONTROLLERIDENTIFIER
	| TNODEIDENTIFIER
	| TFIELDIDENTIFIER
	;

inner_object_definition :
	inner_controller_definition
	| inner_interface_definition
	| inner_model_definition
	| inner_node_definition
	;

object_definition :
	controller_definition
	| interface_definition
	| model_definition
	| node_definition
	;

external_object_definition :
	external_controller_definition
	| external_interface_definition
	| external_model_definition
	| external_node_definition
	;

import_statement :
	TIMPORT interface_type_specifier_full ';'
	| TIMPORT model_type_specifier_full ';'
	| TIMPORT controller_type_specifier_full ';'
	| TIMPORT node_type_specifier_full ';'
	;

bind_action_statement :
	bind_action ';'
	;

bind_action :
	TBIND '(' interface_type_specifier ',' controller_type_specifier ')'
	| TBIND '(' interface_type_specifier ',' controller_type_specifier ')' injection_argument_list
	;

interface_definition :
	TINTERFACE interface_type_specifier_top_level extends_interfaces '{' interface_element_delcaration_list '}'
	;

inner_interface_definition :
	access_specifier TINTERFACE interface_type_specifier_short extends_interfaces '{' interface_element_delcaration_list '}'
	;

external_interface_definition :
	TEXTERNAL TINTERFACE interface_type_specifier_full extends_interfaces '{' external_interface_element_delcaration_list '}'
	;

external_interface_element_delcaration_list :
	/*empty*/
	| external_interface_element_delcaration_list external_interface_element_declaration
	| external_interface_element_delcaration_list external_object_definition
	;

external_interface_element_declaration :
	method_signature
	| external_constant_definition
	| external_static_method_definition
	;

interface_element_delcaration_list :
	/*empty*/
	| interface_element_delcaration_list interface_element_declaration
	| interface_element_delcaration_list inner_object_definition
	;

interface_element_declaration :
	method_signature
	| constant_definition
	| interface_static_method_definition
	| llvm_function_definition
	;

method_signature :
	type_specifier TIDENTIFIER '(' method_definition_arguments ')' method_exceptions method_qualifiers ';'
	;

controller_definition :
	TCONTROLLER controller_type_specifier_top_level object_scope implmeneted_interfaces '{' object_element_declaration_list '}'
	;

inner_controller_definition :
	access_specifier TCONTROLLER controller_type_specifier_short object_scope implmeneted_interfaces '{' object_element_declaration_list '}'
	;

external_controller_definition :
	TEXTERNAL TCONTROLLER controller_type_specifier_full object_scope implmeneted_interfaces '{' external_object_element_declaration_list '}'
	;

object_scope :
	/*empty*/
	| TINSCOPE object_type_specifier
	;

node_definition :
	TNODE node_type_specifier_top_level implmeneted_interfaces '{' object_element_declaration_list '}'
	;

inner_node_definition :
	access_specifier TNODE node_type_specifier_short implmeneted_interfaces '{' object_element_declaration_list '}'
	;

external_node_definition :
	TEXTERNAL TNODE node_type_specifier_full implmeneted_interfaces '{' external_object_element_declaration_list '}'
	;

model_definition :
	TMODEL model_type_specifier_top_level implmeneted_interfaces '{' object_element_declaration_list '}'
	;

inner_model_definition :
	access_specifier TMODEL model_type_specifier_short implmeneted_interfaces '{' object_element_declaration_list '}'
	;

external_model_definition :
	TEXTERNAL TMODEL model_type_specifier_full implmeneted_interfaces '{' external_object_element_declaration_list '}'
	;

external_method_definition :
	type_specifier TIDENTIFIER '(' method_definition_arguments ')' method_exceptions method_qualifiers ';'
	;

external_static_method_definition :
	TSTATIC type_specifier TIDENTIFIER '(' method_definition_arguments ')' method_exceptions ';'
	;

implmeneted_interfaces :
	/*empty*/
	| TIMPLEMENTS interface_list
	;

extends_interfaces :
	/*empty*/
	| TEXTENDS interface_list
	;

interface_list :
	interface_type_specifier_top_level
	| interface_type_specifier_inner
	| interface_list ',' interface_type_specifier_top_level
	| interface_list ',' interface_type_specifier_inner
	;

object_element_declaration_list :
	/*empty*/
	| object_element_declaration_list object_element_declaration
	| object_element_declaration_list inner_object_definition
	;

object_element_declaration :
	constant_definition
	| field_definition
	| method_definition
	| static_method_definition
	| llvm_function_definition
	;

external_object_element_declaration_list :
	/*empty*/
	| external_object_element_declaration_list external_object_element_declaration
	| external_object_element_declaration_list external_object_definition
	;

external_object_element_declaration :
	external_constant_definition
	| field_definition
	| external_method_definition
	| external_static_method_definition
	;

constant_definition :
	access_specifier TCONSTANT type_specifier TCONSTANTIDENTIFIER '=' expression ';'
	;

external_constant_definition :
	TCONSTANT type_specifier TCONSTANTIDENTIFIER '=' expression ';'
	;

field_definition :
	type_specifier TFIELDIDENTIFIER ';'
	| TRECEIVE type_specifier TFIELDIDENTIFIER ';'
	| TINJECT injectable_type_specifier TFIELDIDENTIFIER ';'
	| TINJECT injectable_type_specifier TFIELDIDENTIFIER injection_argument_list ';'
	| TINJECT TIMMEDIATE injectable_type_specifier TFIELDIDENTIFIER ';'
	| TINJECT TIMMEDIATE injectable_type_specifier TFIELDIDENTIFIER injection_argument_list ';'
	| TSTATE type_specifier TFIELDIDENTIFIER ';'
	;

compound_statement :
	'{' '}'
	| '{' block_item_list '}'
	;

block_item_list :
	block_item
	| block_item_list block_item
	;

block_item :
	declaration
	| statement
	;

declaration :
	variable_declaration
	;

statement :
	compound_statement
	| expression_statement
	| selection_statement
	| iteration_statement
	| print_statement
	| jump_statement
	| throw_statement
	| try_catch_statement
	| llvm_store
	;

print_statement :
	TPRINTOUT '(' expression ')' ';'
	| TPRINTERR '(' expression ')' ';'
	| TPRINT '(' expression ',' expression ')' ';'
	;

case_statement_list_with_default :
	case_statement_list
	| case_statement_list default_case_statement
	;

case_statement_list :
	case_statement
	| case_statement_list case_statement
	;

case_statement :
	TCASE expression ':' block_item_list
	| TCASE expression ':' block_item_list TFALLTHROUGH ';'
	;

default_case_statement :
	TDEFAULT ':' block_item_list
	;

expression_statement :
	';'
	| expression ';'
	;

selection_statement :
	TIF '(' expression ')' compound_statement TELSE statement
	| TIF '(' expression ')' compound_statement
	| TSWITCH '(' expression ')' '{' case_statement_list_with_default '}'
	;

iteration_statement :
	TWHILE '(' expression ')' statement
	| TDO statement TWHILE '(' expression ')' ';'
	| TFOR '(' expression_statement expression ';' ')' statement
	| TFOR '(' expression_statement expression ';' expression ')' statement
	| TFOR '(' declaration expression ';' ')' statement
	| TFOR '(' declaration expression ';' expression ')' statement
	;

jump_statement :
	TCONTINUE ';'
	| TBREAK ';'
	| TRETURN ';'
	| TRETURN expression ';'
	;

throw_statement :
	TTHROW expression ';'
	;

try_catch_statement :
	TTRY compound_statement catch_block
	;

catch_block :
	catch_clause
	| catch_block catch_clause
	;

catch_clause :
	TCATCH '(' exception_type_specifier '*' /*2L*/ TIDENTIFIER ')' compound_statement
	;

variable_declaration :
	type_specifier identifier ';'
	| type_specifier identifier '=' expression ';'
	;

method_definition :
	access_specifier type_specifier TIDENTIFIER '(' method_definition_arguments ')' method_exceptions method_qualifiers compound_statement
	;

static_method_definition :
	access_specifier TSTATIC type_specifier TIDENTIFIER '(' method_definition_arguments ')' method_exceptions method_qualifiers compound_statement
	;

interface_static_method_definition :
	access_specifier TSTATIC type_specifier TIDENTIFIER '(' method_definition_arguments ')' method_exceptions method_qualifiers compound_statement
	;

method_qualifiers :
	/*empty*/
	| method_qualifier_set
	;

method_qualifier_set :
	method_qualifier
	| method_qualifier_set method_qualifier
	;

method_qualifier :
	TOVERRIDE
	;

method_exceptions :
	/*empty*/
	| TTHROWS exception_type_specifier_list
	;

exception_type_specifier_list :
	exception_type_specifier
	| exception_type_specifier_list ',' exception_type_specifier
	;

method_argument_declaration :
	type_specifier identifier
	;

method_definition_arguments :
	/*empty*/
	| method_argument_declaration
	| method_definition_arguments ',' method_argument_declaration
	;

access_specifier :
	TPUBLIC
	| TPRIVATE
	;

unsigned_constant_number :
	TINTEGER
	| TLONG
	| TBYTE
	| TFLOAT
	| TDOUBLE
	;

constant_value :
	TCHAR
	| THEXADECIMAL
	| TTRUE
	| TFALSE
	;

string_literal :
	TSTRING_LITERAL
	;

constant_reference :
	object_type_specifier_dot TCONSTANTIDENTIFIER
	| TCONSTANTIDENTIFIER
	;

static_method_call :
	object_type_specifier_dot TIDENTIFIER '(' call_arguments ')'
	;

identifier :
	TIDENTIFIER
	;

llvm_global_identifier :
	TLLVM TLLVMGLOBAL TDOUBLECOLON TIDENTIFIER
	;

field_identifier :
	TFIELDIDENTIFIER
	;

primary_expression :
	identifier
	| llvm_global_identifier
	| field_identifier
	| unsigned_constant_expression
	| heap_builder
	| pool_builder
	| injection
	| static_method_call
	| llvm_function_call
	| llvm_reference
	| llvm_dereference
	| '(' expression ')'
	| TNULL
	;

unsigned_constant_expression :
	constant_value
	| unsigned_constant_number
	| string_literal
	| constant_reference
	| static_array_allocation
	;

signed_constant_expression :
	constant_value
	| unsigned_constant_number
	| '-' /*1L*/ unsigned_constant_number
	| string_literal
	| constant_reference
	| static_array_allocation
	;

postfix_expression :
	primary_expression
	| postfix_expression '.' TIDENTIFIER
	| postfix_expression '[' expression ']'
	| postfix_expression '(' call_arguments ')'
	| postfix_expression TINCOP
	| postfix_expression TDECOP
	;

unary_expression :
	postfix_expression
	| '-' /*1L*/ cast_expression
	| '!' cast_expression
	| TINCOP unary_expression
	| TDECOP unary_expression
	;

cast_expression :
	unary_expression
	| '(' type_specifier ')' cast_expression
	;

multiply_divide_expression :
	cast_expression
	| multiply_divide_expression '*' /*2L*/ cast_expression
	| multiply_divide_expression '/' /*2L*/ cast_expression
	| multiply_divide_expression '%' /*2L*/ cast_expression
	;

multiply_by_expression :
	multiply_divide_expression
	| postfix_expression TMULTIPLYBY multiply_divide_expression
	;

divide_by_expression :
	multiply_by_expression
	| postfix_expression TDIVIDEBY multiply_by_expression
	| postfix_expression TREMINDERBY multiply_by_expression
	;

add_subtract_expression :
	divide_by_expression
	| add_subtract_expression '+' /*1L*/ divide_by_expression
	| add_subtract_expression '-' /*1L*/ divide_by_expression
	;

increment_by_expression :
	add_subtract_expression
	| postfix_expression TINCBYOP add_subtract_expression
	| postfix_expression TDECBYOP add_subtract_expression
	;

shift_expression :
	increment_by_expression
	| shift_expression TSHIFTLEFT add_subtract_expression
	| shift_expression TSHIFTRIGHT add_subtract_expression
	;

shift_by_expression :
	shift_expression
	| postfix_expression TSHIFTLEFTBY shift_expression
	| postfix_expression TSHIFTRIGHTBY shift_expression
	;

relational_expression :
	shift_by_expression
	| relational_expression '<' shift_by_expression
	| relational_expression '>' shift_by_expression
	| relational_expression TCLE shift_by_expression
	| relational_expression TCGE shift_by_expression
	;

type_comparision_expression :
	relational_expression
	| type_comparision_expression TINSTANCEOF type_specifier
	;

equality_expression :
	type_comparision_expression
	| equality_expression TCEQ relational_expression
	| equality_expression TCNE relational_expression
	;

bitwise_and_expression :
	equality_expression
	| bitwise_and_expression '&' equality_expression
	;

bitwise_and_by_expression :
	bitwise_and_expression
	| postfix_expression TBITWISEANDBY bitwise_and_expression
	;

bitwise_xor_expression :
	bitwise_and_by_expression
	| bitwise_xor_expression '^' bitwise_and_by_expression
	;

bitwise_xor_by_expression :
	bitwise_xor_expression
	| postfix_expression TBITWISEXORBY bitwise_xor_expression
	;

bitwise_or_expression :
	bitwise_xor_by_expression
	| bitwise_or_expression '|' bitwise_xor_by_expression
	;

bitwise_or_by_expression :
	bitwise_or_expression
	| postfix_expression TBITWISEORBY bitwise_or_expression
	;

logical_and_expression :
	bitwise_or_by_expression
	| logical_and_expression TANDOP bitwise_or_by_expression
	;

logical_or_expression :
	logical_and_expression
	| logical_or_expression TOROP logical_and_expression
	;

conditional_expression :
	logical_or_expression
	| logical_or_expression '?' expression ':' conditional_expression
	;

expression :
	conditional_expression
	| assignment
	| array_allocation
	;

assignment :
	postfix_expression '=' expression
	;

array_allocation :
	TNEW array_specific_type_specifier
	;

static_array_allocation :
	'{' static_array_elements '}'
	;

static_array_elements :
	signed_constant_expression
	| static_array_elements ',' signed_constant_expression
	| static_array_elements ','
	;

injection :
	TINJECT '(' object_type_specifier_injectable ')' injection_argument_list '.' TONHEAP '(' ')'
	| TINJECT '(' object_type_specifier_injectable ')' '.' TONHEAP '(' ')'
	;

injection_argument_list :
	injection_argument
	| injection_argument_list injection_argument
	;

injection_argument :
	'.' TIDENTIFIER '(' expression ')'
	;

heap_builder :
	TBUILD '(' object_type_specifier_buildable ')' builder_argument_list '.' TONHEAP '(' ')'
	| TBUILD '(' object_type_specifier_buildable ')' '.' TONHEAP '(' ')'
	;

pool_builder :
	TBUILD '(' object_type_specifier_buildable ')' builder_argument_list '.' TONPOOL '(' expression ')'
	| TBUILD '(' object_type_specifier_buildable ')' '.' TONPOOL '(' expression ')'
	;

builder_argument_list :
	builder_argument
	| builder_argument_list builder_argument
	;

builder_argument :
	'.' TIDENTIFIER '(' expression ')'
	;

call_arguments :
	/*empty*/
	| call_argument
	| call_arguments ',' call_argument
	;

call_argument :
	expression
	| object_type_specifier_dot TIDENTIFIER
	;

type_specifier :
	non_array_type_specifier
	| array_type_specifier
	| array_owner_type_specifier
	| immutable_array_type_specifier
	| immutable_array_owner_type_specifier
	;

injectable_type_specifier :
	non_array_type_specifier
	| array_specific_owner_type_specifier
	;

non_array_type_specifier :
	primitive_type_specifier
	| object_type_specifier
	| object_owner_type_specifier
	| native_type_specifier
	;

primitive_type_specifier :
	TTYPEBOOLEAN
	| TTYPECHAR
	| TTYPEBYTE
	| TTYPEDOUBLE
	| TTYPEFLOAT
	| TTYPEINT
	| TTYPELONG
	| TTYPESTRING
	| TTYPEVOID
	;

immutable_array_type_specifier :
	TIMMUTABLE array_type_specifier
	;

immutable_array_owner_type_specifier :
	immutable_array_type_specifier '*' /*2L*/
	;

array_owner_type_specifier :
	array_type_specifier '*' /*2L*/
	;

array_type_specifier :
	non_array_type_specifier array_undefined_dimensions_list
	;

array_specific_owner_type_specifier :
	array_specific_type_specifier '*' /*2L*/
	;

array_specific_type_specifier :
	non_array_type_specifier array_dimensions
	;

array_dimensions :
	'[' expression ']'
	| array_dimensions '[' expression ']'
	;

array_undefined_dimensions_list :
	'[' ']'
	| array_undefined_dimensions_list '[' ']'
	;

object_owner_type_specifier :
	object_type_specifier '*' /*2L*/
	;

object_type_specifier_dot :
	object_type_specifier_short '.'
	| object_type_specifier_top_level_full '.'
	| object_type_specifier_inner_short '.'
	| object_type_specifier_inner_full '.'
	;

object_type_specifier :
	object_type_specifier_short
	| object_type_specifier_top_level_full
	| object_type_specifier_inner_short
	| object_type_specifier_inner_full
	;

object_type_specifier_inner_short :
	model_type_specifier_inner_short
	| controller_type_specifier_inner_short
	| interface_type_specifier_inner_short
	| node_type_specifier_inner_short
	;

object_type_specifier_inner_full :
	model_type_specifier_inner_full
	| controller_type_specifier_inner_full
	| interface_type_specifier_inner_full
	| node_type_specifier_inner_full
	;

object_type_specifier_short :
	model_type_specifier_short
	| controller_type_specifier_short
	| interface_type_specifier_short
	| node_type_specifier_short
	;

object_type_specifier_top_level_full :
	model_type_specifier_top_level_full
	| controller_type_specifier_top_level_full
	| interface_type_specifier_top_level_full
	| node_type_specifier_top_level_full
	;

model_type_specifier :
	model_type_specifier_top_level
	| model_type_specifier_inner
	;

model_type_specifier_full :
	model_type_specifier_top_level_full
	| model_type_specifier_inner_full
	;

model_type_specifier_top_level :
	model_type_specifier_short
	| model_type_specifier_top_level_full
	;

model_type_specifier_short :
	TMODELIDENTIFIER
	;

model_type_specifier_top_level_full :
	postfix_expression '.' TMODELIDENTIFIER
	;

model_type_specifier_inner :
	model_type_specifier_inner_short
	| model_type_specifier_inner_full
	;

model_type_specifier_inner_short :
	object_type_specifier_short '.' TMODELIDENTIFIER
	;

model_type_specifier_inner_full :
	object_type_specifier_top_level_full '.' TMODELIDENTIFIER
	;

controller_type_specifier :
	controller_type_specifier_top_level
	| controller_type_specifier_inner
	;

controller_type_specifier_full :
	controller_type_specifier_top_level_full
	| controller_type_specifier_inner_full
	;

controller_type_specifier_top_level :
	controller_type_specifier_short
	| controller_type_specifier_top_level_full
	;

controller_type_specifier_short :
	TCONTROLLERIDENTIFIER
	;

controller_type_specifier_top_level_full :
	postfix_expression '.' TCONTROLLERIDENTIFIER
	;

controller_type_specifier_inner :
	controller_type_specifier_inner_short
	| controller_type_specifier_inner_full
	;

controller_type_specifier_inner_short :
	object_type_specifier_short '.' TCONTROLLERIDENTIFIER
	;

controller_type_specifier_inner_full :
	object_type_specifier_top_level_full '.' TCONTROLLERIDENTIFIER
	;

interface_type_specifier :
	interface_type_specifier_top_level
	| interface_type_specifier_inner
	;

interface_type_specifier_full :
	interface_type_specifier_top_level_full
	| interface_type_specifier_inner_full
	;

interface_type_specifier_top_level :
	interface_type_specifier_short
	| interface_type_specifier_top_level_full
	;

interface_type_specifier_short :
	TINTERFACEIDENTIFIER
	;

interface_type_specifier_top_level_full :
	postfix_expression '.' TINTERFACEIDENTIFIER
	;

interface_type_specifier_inner :
	interface_type_specifier_inner_short
	| interface_type_specifier_inner_full
	;

interface_type_specifier_inner_short :
	object_type_specifier_short '.' TINTERFACEIDENTIFIER
	;

interface_type_specifier_inner_full :
	object_type_specifier_top_level_full '.' TINTERFACEIDENTIFIER
	;

node_type_specifier :
	node_type_specifier_top_level
	| node_type_specifier_inner
	;

node_type_specifier_full :
	node_type_specifier_top_level_full
	| node_type_specifier_inner_full
	;

node_type_specifier_top_level :
	node_type_specifier_short
	| node_type_specifier_top_level_full
	;

node_type_specifier_short :
	TNODEIDENTIFIER
	;

node_type_specifier_top_level_full :
	postfix_expression '.' TNODEIDENTIFIER
	;

node_type_specifier_inner :
	node_type_specifier_inner_short
	| node_type_specifier_inner_full
	;

node_type_specifier_inner_short :
	object_type_specifier_short '.' TNODEIDENTIFIER
	;

node_type_specifier_inner_full :
	object_type_specifier_top_level_full '.' TNODEIDENTIFIER
	;

exception_type_specifier :
	model_type_specifier
	;

object_type_specifier_buildable :
	model_type_specifier
	| node_type_specifier
	;

object_type_specifier_injectable :
	interface_type_specifier
	| controller_type_specifier
	;

%%

D   [0-9]
NZ  [1-9]
BT  (b|B)
IS  (l|L)
DS  (d|D)
H   [a-fA-F0-9]
HP  (0[xX])
E   ([Ee][+-]?{D}+)
ES  (\\(['"\?\\abfnrtv]|[0-7]{1,3}|x[a-fA-F0-9]+))
WS  [ \t\v\n\f]

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

[ \t\r\n]+	skip()
"/*"(?s:.)*?"*/"	skip()
"//".*                        skip()

"::array"                     TLLVMARRAY
"::dereference"               TLLVMDEREFERENCE
"::function"                  TLLVMFUNCTION
"::i1"                        TLLVMI1
"::i8"                        TLLVMI8
"::i16"                       TLLVMI16
"::i32"                       TLLVMI32
"::i64"                       TLLVMI64
"::model"                     TWISEYMODEL
"::llvm"                      TLLVM
"::global"                    TLLVMGLOBAL
"::object"                    TWISEYOBJECT
"::pointer"                   TLLVMPOINTER
"::reference"                 TLLVMREFERENCE
"::store"                     TLLVMSTORE
"::struct"                    TLLVMSTRUCT
"::void"                      TLLVMVOID
"::wisey"                     TWISEY
"bind"                        TBIND
"boolean"                     TTYPEBOOLEAN
"break"                       TBREAK
"build"                       TBUILD
"byte"                        TTYPEBYTE
"case"                        TCASE
"catch"                       TCATCH
"char"                        TTYPECHAR
"constant"                    TCONSTANT
"continue"                    TCONTINUE
"controller"                  TCONTROLLER
"do"                          TDO
"double"                      TTYPEDOUBLE
"else"                        TELSE
"extends"                     TEXTENDS
"external"                    TEXTERNAL
"default"                     TDEFAULT
"fallthrough"                 TFALLTHROUGH
"false"                       TFALSE
"float"                       TTYPEFLOAT
"for"                         TFOR
"if"                          TIF
"immediate"                   TIMMEDIATE
"immutable"                   TIMMUTABLE
"implements"                  TIMPLEMENTS
"import"                      TIMPORT
"inject"                      TINJECT
"inScope"                     TINSCOPE
"instanceof"                  TINSTANCEOF
"int"                         TTYPEINT
"interface"                   TINTERFACE
"long"                        TTYPELONG
"model"                       TMODEL
"new"                         TNEW
"node"                        TNODE
"null"                        TNULL
"onHeap"                      TONHEAP
"onPool"                      TONPOOL
"override"                    TOVERRIDE
"package"                     TPACKAGE
"print"                       TPRINT
"printerr"                    TPRINTERR
"printout"                    TPRINTOUT
"private"                     TPRIVATE
"public"                      TPUBLIC
"receive"                     TRECEIVE
"return"                      TRETURN
"state"                       TSTATE
"static"                      TSTATIC
"string"                      TTYPESTRING
"switch"                      TSWITCH
"throw"                       TTHROW
"throws"                      TTHROWS
"try"                         TTRY
"true"                        TTRUE
"void"                        TTYPEVOID
"while"                       TWHILE
"..."                         TELIPSIS
"<<="                         TSHIFTLEFTBY
">>="                         TSHIFTRIGHTBY
"<<"                          TSHIFTLEFT
">>"                          TSHIFTRIGHT
"="                           '='
"=="                          TCEQ
"!="                          TCNE
"<"                           '<'
"<="                          TCLE
">"                           '>'
">="                          TCGE
"++"                          TINCOP
"--"                          TDECOP
"+="                          TINCBYOP
"-="                          TDECBYOP
"::"                          TDOUBLECOLON
"("                           '('
")"                           ')'
"["                           '['
"]"                           ']'
"{"                           '{'
"}"                           '}'
"."                           '.'
","                           ','
"+"                           '+'
"-"                           '-'
"*="                          TMULTIPLYBY
"*"                           '*'
"/="                          TDIVIDEBY
"/"                           '/'
"%="                          TREMINDERBY
"%"                           '%'
":"                           ':'
"?"                           '?'
";"                           ';'
"!"                           '!'
"&="                          TBITWISEANDBY
"&"                           '&'
"^="                          TBITWISEXORBY
"^"                           '^'
"|="                          TBITWISEORBY
"|"                           '|'
"&&"                          TANDOP
"||"                          TOROP
[A-Z][A-Z0-9_]*               TCONSTANTIDENTIFIER
M[A-Z][a-zA-Z0-9_]*           TMODELIDENTIFIER
I[A-Z][a-zA-Z0-9_]*           TINTERFACEIDENTIFIER
C[A-Z][a-zA-Z0-9_]*           TCONTROLLERIDENTIFIER
N[A-Z][a-zA-Z0-9_]*           TNODEIDENTIFIER
m[A-Z][a-zA-Z0-9_]*           TFIELDIDENTIFIER
{HP}{H}+{IS}?                 THEXADECIMAL
[a-zA-Z_][a-zA-Z0-9_]*        TIDENTIFIER
{D}*"."{D}+{E}?{DS}           TDOUBLE
{D}+"."{E}?{DS}               TDOUBLE
{D}*"."{D}+{E}?               TFLOAT
{D}+"."{E}?                   TFLOAT
{D}+{BT}                      TBYTE
{D}+{IS}                      TLONG
{D}+                          TINTEGER
"'"([^'\\\n]|{ES})+"'"        TCHAR
(\"([^"\\\n]|{ES})*\")+       TSTRING_LITERAL

%%
