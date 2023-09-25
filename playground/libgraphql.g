//From: https://github.com/graphql/libgraphqlparser/blob/7e6c35c7b9e919d0c40b28020fb9358c3cf2679c/parser.ypp
/**
 * Copyright 2019-present, GraphQL Foundation
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

%x STRING_STATE
%x BLOCK_STRING_STATE
%x LINE_COMMENT_STATE

%token UNRECOGNIZED_CHARACTER INVALID_CHARACTER UNTERMINATED_STRING
%token BAD_UNICODE_ESCAPE_SEQUENCE BAD_ESCAPE_SEQUENCE

/*Tokens*/
%token DIRECTIVE
%token ENUM
%token EXTEND
%token FALSE
%token FRAGMENT
%token IMPLEMENTS
%token INPUT
%token INTERFACE
%token MUTATION
%token NULL
%token QUERY
%token ON
%token SCALAR
%token SCHEMA
%token SUBSCRIPTION
%token TRUE
%token TYPE
%token UNION
//%token BANG
//%token LPAREN
//%token RPAREN
//%token ELLIPSIS
//%token COLON
//%token EQUAL
//%token AT
//%token LBRACKET
//%token RBRACKET
//%token LBRACE
//%token PIPE
//%token RBRACE
%token VARIABLE
%token INTEGER
%token FLOAT
%token STRING
%token IDENTIFIER


%start start

%%

start :
	document
	/* bellow rules are only to silence warnings on the playground */
	| UNRECOGNIZED_CHARACTER
	| INVALID_CHARACTER
	| UNTERMINATED_STRING
	| BAD_UNICODE_ESCAPE_SEQUENCE
	| BAD_ESCAPE_SEQUENCE
	;

fragment_name :
	DIRECTIVE
	| ENUM
	| EXTEND
	| FALSE
	| FRAGMENT
	| IDENTIFIER
	| IMPLEMENTS
	| INPUT
	| INTERFACE
	| MUTATION
	| NULL
	| QUERY
	| SCALAR
	| SCHEMA
	| SUBSCRIPTION
	| TRUE
	| TYPE
	| UNION
	;

name :
	fragment_name
	| ON
	;

name_opt :
	/*empty*/
	| name
	;

document :
	definition_list
	;

definition_list :
	definition
	| definition_list definition
	;

definition :
	operation_definition
	| fragment_definition
	| schema_gate
	;

schema_gate :
	schema_definition
	| scalar_type_definition
	| object_type_definition
	| interface_type_definition
	| union_type_definition
	| enum_type_definition
	| input_object_type_definition
	| type_extension_definition
	| directive_definition
	;

operation_definition :
	selection_set
	| operation_type name_opt selection_set
	| operation_type name_opt variable_definitions selection_set
	| operation_type name_opt directives selection_set
	| operation_type name_opt variable_definitions directives selection_set
	;

operation_type :
	QUERY
	| MUTATION
	| SUBSCRIPTION
	;

variable_definitions :
	"(" variable_definition_list ")"
	;

variable_definition_list :
	variable_definition
	| variable_definition_list variable_definition
	;

variable :
	VARIABLE
	;

variable_definition :
	variable ":" type default_value_opt
	;

default_value_opt :
	/*empty*/
	| default_value
	;

default_value :
	"=" value_const
	;

selection_set :
	"{" selection_list "}"
	;

selection_set_opt :
	/*empty*/
	| selection_set
	;

selection_list :
	selection
	| selection_list selection
	;

selection :
	field
	| fragment_spread
	| inline_fragment
	;

field :
	name arguments_opt directives_opt selection_set_opt
	| name ":" name arguments_opt directives_opt selection_set_opt
	;

arguments :
	"(" argument_list ")"
	;

arguments_opt :
	/*empty*/
	| arguments
	;

argument_list :
	argument
	| argument_list argument
	;

argument :
	name ":" value
	;

fragment_spread :
	"..." fragment_name directives_opt
	;

inline_fragment :
	"..." ON type_condition directives_opt selection_set
	| "..." directives_opt selection_set
	;

fragment_definition :
	FRAGMENT fragment_name ON type_condition directives_opt selection_set
	;

type_condition :
	type_name
	;

value :
	variable
	| int_value
	| float_value
	| string_value
	| boolean_value
	| null_value
	| enum_value
	| list_value
	| object_value
	;

int_value :
	INTEGER
	;

float_value :
	FLOAT
	;

string_value :
	STRING
	;

value_const :
	int_value
	| float_value
	| string_value
	| boolean_value
	| null_value
	| enum_value
	| list_value_const
	| object_value_const
	;

boolean_value :
	TRUE
	| FALSE
	;

null_value :
	NULL
	;

enum_value :
	DIRECTIVE
	| ENUM
	| EXTEND
	| FRAGMENT
	| IDENTIFIER
	| IMPLEMENTS
	| INPUT
	| INTERFACE
	| MUTATION
	| ON
	| QUERY
	| SCALAR
	| SCHEMA
	| SUBSCRIPTION
	| TYPE
	| UNION
	;

list_value :
	"[" "]"
	| "[" value_list "]"
	;

value_list :
	value
	| value_list value
	;

list_value_const :
	"[" "]"
	| "[" value_const_list "]"
	;

value_const_list :
	value_const
	| value_const_list value_const
	;

object_value :
	"{" "}"
	| "{" object_field_list "}"
	;

object_field_list :
	object_field
	| object_field_list object_field
	;

object_field :
	name ":" value
	;

object_value_const :
	"{" "}"
	| "{" object_field_const_list "}"
	;

object_field_const_list :
	object_field_const
	| object_field_const_list object_field_const
	;

object_field_const :
	name ":" value_const
	;

directives :
	directive_list
	;

directives_opt :
	/*empty*/
	| directives
	;

directive_list :
	directive
	| directive_list directive
	;

directive :
	"@" name arguments_opt
	;

type :
	type_name
	| list_type
	| non_null_type
	;

type_name :
	name
	;

list_type :
	"[" type "]"
	;

non_null_type :
	type_name "!"
	| list_type "!"
	;

schema_definition :
	SCHEMA directives_opt "{" operation_type_definition_list "}"
	;

operation_type_definition_list :
	operation_type_definition
	| operation_type_definition_list operation_type_definition
	;

operation_type_definition :
	operation_type ":" type_name
	;

scalar_type_definition :
	SCALAR name directives_opt
	;

object_type_definition :
	TYPE name implements_interfaces_opt directives_opt "{" field_definition_list "}"
	;

implements_interfaces_opt :
	/*empty*/
	| IMPLEMENTS type_name_list
	;

type_name_list :
	type_name
	| type_name_list type_name
	;

field_definition :
	name arguments_definition_opt ":" type directives_opt
	;

field_definition_list :
	field_definition
	| field_definition_list field_definition
	;

arguments_definition_opt :
	/*empty*/
	| arguments_definition
	;

arguments_definition :
	"(" input_value_definition_list ")"
	;

input_value_definition_list :
	input_value_definition
	| input_value_definition_list input_value_definition
	;

input_value_definition :
	name ":" type default_value_opt directives_opt
	;

interface_type_definition :
	INTERFACE name directives_opt "{" field_definition_list "}"
	;

union_type_definition :
	UNION name directives_opt "=" union_members
	;

union_members :
	type_name
	| union_members "|" type_name
	;

enum_type_definition :
	ENUM name directives_opt "{" enum_value_definition_list "}"
	;

enum_value_definition :
	name directives_opt
	;

enum_value_definition_list :
	enum_value_definition
	| enum_value_definition_list enum_value_definition
	;

input_object_type_definition :
	INPUT name directives_opt "{" input_value_definition_list "}"
	;

type_extension_definition :
	EXTEND object_type_definition
	;

directive_definition :
	DIRECTIVE "@" name arguments_definition_opt ON directive_locations
	;

directive_locations :
	name
	| directive_locations "|" name
	;

%%

FLOAT -?(0|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)?
INTEGER -?(0|[1-9][0-9]*)
IDENTIFIER [_A-Za-z][_0-9A-Za-z]*
VARIABLE \$[_0-9A-Za-z]+
BOM \xef\xbb\xbf
CRLF \r\n
BADCHAR [\x00-\x08\x0b\x0c\x0e-\x1f]
GOODCHAR [^\x00-\x08\x0b\x0c\x0e-\x1f]
STRINGCHAR [^\x00-\x1f\\\x22]

blank [ \t,]
newline [\n\r]
notnewline [^\n\r]

%%

<STRING_STATE>{
  \"<INITIAL>    STRING
  {newline} UNTERMINATED_STRING

  //<<EOF>> "Unterminated string at EOF"

  {STRINGCHAR}+<.>

  \\\"<.>
  \\\\<.>
  \\\/<.>
  \\n<.>
  \\t<.>
  \\r<.>
  \\b<.>
  \\f<.>

  \\u[0-9A-Fa-f]{4}<.>

  \\u BAD_UNICODE_ESCAPE_SEQUENCE
  \\. BAD_ESCAPE_SEQUENCE

}

<BLOCK_STRING_STATE>{
  //<<EOF>> "Unterminated block string at EOF"

  {BADCHAR} INVALID_CHARACTER

  {GOODCHAR}<.>
    /* Can't use {GOODCHAR}+ because that would be a better match for
       """ than the explicit rule! */

  \\\"\"\"<.>

  \"\"\"<INITIAL> STRING
}

<LINE_COMMENT_STATE>{
  {CRLF}<INITIAL>	skip()
  {newline}<INITIAL>	skip()
  /* eat comment character */
  {notnewline}+<.>	skip()
}

<INITIAL>{
  {blank}+ skip()
  {BOM}+ skip()
  {CRLF}+ skip()
  {newline}+ skip()

  "#"<LINE_COMMENT_STATE>

  directive   DIRECTIVE
  enum   ENUM
  extend   EXTEND
  false   FALSE
  fragment FRAGMENT
  implements IMPLEMENTS
  input INPUT
  interface INTERFACE
  mutation MUTATION
  null NULL
  on	ON
  query QUERY
  scalar SCALAR
  schema SCHEMA
  subscription SUBSCRIPTION
  true TRUE
  type TYPE
  union UNION

  {INTEGER} INTEGER
  {FLOAT} FLOAT
  {IDENTIFIER} IDENTIFIER
  {VARIABLE} VARIABLE

  "!"	"!" //BANG
  "("	"(" //LPAREN
  ")"	")" //RPAREN
  "..."	"..." //ELLIPSIS
  ":"	":" //COLON
  "="	"=" //EQUAL
  "@"	"@" //AT
  "["	"[" //LBRACKET
  "]"	"]" //RBRACKET
  "{"	"{" //LBRACE
  "|"	"|" //PIPE
  "}"	"}" //RBRACE


  //<<EOF>> EOF

  \"\"\"<BLOCK_STRING_STATE>

  \"<STRING_STATE>
}

<INITIAL,STRING_STATE,LINE_COMMENT_STATE>. UNRECOGNIZED_CHARACTER


%%
