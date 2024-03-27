/*Tokens*/
%token UNSIGNED_INTEGER
%token SIGNED_INTEGER
%token REAL
%token STRING
%token IDENTIFIER
%token HEX_STRING
%token KEYWORD
%token KW_DCLASS
%token KW_STRUCT
%token KW_FROM
%token KW_IMPORT
%token KW_TYPEDEF
%token KW_KEYWORD
%token KW_SWITCH
%token KW_CASE
%token KW_DEFAULT
%token KW_BREAK
%token KW_INT8
%token KW_INT16
%token KW_INT32
%token KW_INT64
%token KW_UINT8
%token KW_UINT16
%token KW_UINT32
%token KW_UINT64
%token KW_FLOAT64
%token KW_STRING
%token KW_BLOB
%token KW_BLOB32
%token KW_INT8ARRAY
%token KW_INT16ARRAY
%token KW_INT32ARRAY
%token KW_UINT8ARRAY
%token KW_UINT16ARRAY
%token KW_UINT32ARRAY
%token KW_UINT32UINT8ARRAY
%token KW_CHAR
%token START_DC
%token START_PARAMETER_VALUE
%token START_PARAMETER_DESCRIPTION
%token ';'
%token '/'
%token '.'
%token '*'
%token ','
%token '{'
%token '}'
%token ':'
%token '('
%token ')'
%token '='
%token '%'
%token '-'
%token '['
%token ']'


%start grammar

%%

grammar :
    dc
	| START_DC dc
	| START_PARAMETER_VALUE parameter_value
	| START_PARAMETER_DESCRIPTION parameter_description
	;

dc :
	empty
	| dc ';'
	| dc dclass_or_struct
	| dc switch
	| dc import
	| dc typedef_decl
	| dc keyword_decl
	;

slash_identifier :
	IDENTIFIER
	| slash_identifier '/' IDENTIFIER
	;

import_identifier :
	slash_identifier
	| import_identifier '.' slash_identifier
	;

import :
	KW_IMPORT import_identifier
	| KW_FROM import_identifier KW_IMPORT import_symbol_list_or_star
	;

import_symbol_list_or_star :
	import_symbol_list
	| '*'
	;

import_symbol_list :
	slash_identifier
	| import_symbol_list ',' slash_identifier
	;

typedef_decl :
	KW_TYPEDEF parameter_with_default
	;

keyword_decl :
	KW_KEYWORD keyword_decl_list
	;

keyword_decl_list :
	empty
	| keyword_decl_list IDENTIFIER
	| keyword_decl_list KEYWORD
	;

dclass_or_struct :
	dclass
	| struct
	;

dclass :
	KW_DCLASS optional_name dclass_derivation '{' dclass_fields '}'
	;

dclass_name :
	IDENTIFIER
	;

dclass_derivation :
	empty
	| ':' dclass_base_list
	;

dclass_base_list :
	dclass_name
	| dclass_base_list ',' dclass_name
	;

dclass_fields :
	empty
	| dclass_fields ';'
	| dclass_fields dclass_field ';'
	;

dclass_field :
	atomic_field keyword_list
	| molecular_field no_keyword_list
	| unnamed_parameter_with_default keyword_list
	| named_parameter_with_default keyword_list
	;

struct :
	KW_STRUCT optional_name struct_derivation '{' struct_fields '}'
	;

struct_name :
	IDENTIFIER
	;

struct_derivation :
	empty
	| ':' struct_base_list
	;

struct_base_list :
	struct_name
	| struct_base_list ',' struct_name
	;

struct_fields :
	empty
	| struct_fields ';'
	| struct_fields struct_field ';'
	;

struct_field :
	atomic_field no_keyword_list
	| molecular_field no_keyword_list
	| unnamed_parameter_with_default no_keyword_list
	| named_parameter_with_default no_keyword_list
	;

atomic_field :
	optional_name '(' parameter_list ')'
	;

parameter_list :
	empty
	| nonempty_parameter_list
	;

nonempty_parameter_list :
	atomic_element
	| nonempty_parameter_list ',' atomic_element
	;

atomic_element :
	parameter_with_default
	;

named_parameter :
	type_definition parameter_definition
	;

unnamed_parameter :
	type_definition
	;

named_parameter_with_default :
	named_parameter
	| named_parameter '=' parameter_value
	;

unnamed_parameter_with_default :
	unnamed_parameter
	| unnamed_parameter '=' parameter_value
	;

parameter :
	named_parameter
	| unnamed_parameter
	;

parameter_with_default :
	named_parameter_with_default
	| unnamed_parameter_with_default
	;

parameter_or_atomic :
	parameter
	| atomic_field
	;

parameter_description :
	atomic_field no_keyword_list
	| unnamed_parameter_with_default no_keyword_list
	| named_parameter_with_default no_keyword_list
	;

simple_type_name :
	type_token
	| simple_type_name '(' double_range ')'
	| simple_type_name '/' small_unsigned_integer
	| simple_type_name '%' number
	;

type_name :
	simple_type_name
	| IDENTIFIER
	| struct
	| switch
	;

double_range :
	empty
	| char_or_number
	| char_or_number '-' char_or_number
	| char_or_number number
	| double_range ',' char_or_number
	| double_range ',' char_or_number '-' char_or_number
	| double_range ',' char_or_number number
	;

uint_range :
	empty
	| char_or_uint
	| char_or_uint '-' char_or_uint
	| char_or_uint small_negative_integer
	| uint_range ',' char_or_uint
	| uint_range ',' char_or_uint '-' char_or_uint
	| uint_range ',' char_or_uint small_negative_integer
	;

type_definition :
	type_name
	| type_definition '[' uint_range ']'
	;

parameter_definition :
	IDENTIFIER
	| parameter_definition '/' small_unsigned_integer
	| parameter_definition '%' number
	| parameter_definition '[' uint_range ']'
	;

char_or_uint :
	STRING
	| small_unsigned_integer
	;

small_unsigned_integer :
	UNSIGNED_INTEGER
	;

small_negative_integer :
	SIGNED_INTEGER
	;

signed_integer :
	SIGNED_INTEGER
	;

unsigned_integer :
	UNSIGNED_INTEGER
	;

number :
	unsigned_integer
	| signed_integer
	| REAL
	;

char_or_number :
	STRING
	| number
	;

parameter_value :
	parameter_actual_value
	| IDENTIFIER '=' parameter_actual_value
	;

parameter_actual_value :
	signed_integer
	| unsigned_integer
	| REAL
	| STRING
	| HEX_STRING
	| '{' array '}'
	| '[' array ']'
	| '(' array ')'
	| signed_integer '*' small_unsigned_integer
	| unsigned_integer '*' small_unsigned_integer
	| REAL '*' small_unsigned_integer
	| HEX_STRING '*' small_unsigned_integer
	;

array :
	maybe_comma
	| array_def maybe_comma
	;

maybe_comma :
	empty
	| ','
	;

array_def :
	parameter_value
	| array_def ',' parameter_value
	;

type_token :
	KW_INT8
	| KW_INT16
	| KW_INT32
	| KW_INT64
	| KW_UINT8
	| KW_UINT16
	| KW_UINT32
	| KW_UINT64
	| KW_FLOAT64
	| KW_STRING
	| KW_BLOB
	| KW_BLOB32
	| KW_INT8ARRAY
	| KW_INT16ARRAY
	| KW_INT32ARRAY
	| KW_UINT8ARRAY
	| KW_UINT16ARRAY
	| KW_UINT32ARRAY
	| KW_UINT32UINT8ARRAY
	| KW_CHAR
	;

keyword_list :
	empty
	| keyword_list KEYWORD
	;

no_keyword_list :
	keyword_list
	;

molecular_field :
	IDENTIFIER ':' molecular_atom_list
	;

atomic_name :
	IDENTIFIER
	;

molecular_atom_list :
	atomic_name
	| molecular_atom_list ',' atomic_name
	;

optional_name :
	empty
	| IDENTIFIER
	;

switch :
	KW_SWITCH optional_name '(' parameter_or_atomic ')' '{' switch_fields '}'
	;

switch_fields :
	empty
	| switch_fields ';'
	| switch_fields switch_case
	| switch_fields switch_default
	| switch_fields switch_break ';'
	| switch_fields switch_field ';'
	;

switch_case :
	KW_CASE parameter_value ':'
	;

switch_default :
	KW_DEFAULT ':'
	;

switch_break :
	KW_BREAK
	;

switch_field :
	unnamed_parameter_with_default
	| named_parameter_with_default
	;

empty :
	/*empty*/
	;

%%

UNSIGNED_INTEGERNUM  ([0-9]+)
SIGNED_INTEGERNUM    ([+-]([0-9]+))
UNSIGNED_HEXNUM      (0x[0-9a-fA-F]*)
REALNUM              ([+-]?(([0-9]+[.])|([0-9]*[.][0-9]+))([eE][+-]?[0-9]+)?)

%%

[ \t\r\n]+	skip()

"//".* skip()
"/*"(?:s.)*?"*/"	skip()


"dclass"  KW_DCLASS
"struct"  KW_STRUCT
"from"  KW_FROM
"import"  KW_IMPORT
"keyword"  KW_KEYWORD
"typedef"  KW_TYPEDEF
"switch"  KW_SWITCH
"case"  KW_CASE
"default"  KW_DEFAULT
"break"  KW_BREAK
"int8"  KW_INT8
"int16"  KW_INT16
"int32"  KW_INT32
"int64"  KW_INT64
"uint8"  KW_UINT8
"uint16"  KW_UINT16
"uint32"  KW_UINT32
"uint64"  KW_UINT64
"float64"  KW_FLOAT64
"string"  KW_STRING
"blob"  KW_BLOB
"blob32"  KW_BLOB32
"int8array"  KW_INT8ARRAY
"int16array"  KW_INT16ARRAY
"int32array"  KW_INT32ARRAY
"uint8array"  KW_UINT8ARRAY
"uint16array"  KW_UINT16ARRAY
"uint32array"  KW_UINT32ARRAY
"uint32uint8array"  KW_UINT32UINT8ARRAY
"char"  KW_CHAR

"required"|"broadcast"|"ownrecv"|"ram"|"db"|"clsend"|"clrecv"|"ownsend"|"airecv"	KEYWORD
START_DC	START_DC
START_PARAMETER_VALUE	START_PARAMETER_VALUE
START_PARAMETER_DESCRIPTION	START_PARAMETER_DESCRIPTION

{UNSIGNED_INTEGERNUM}  UNSIGNED_INTEGER
{SIGNED_INTEGERNUM}  SIGNED_INTEGER
{UNSIGNED_HEXNUM}  UNSIGNED_INTEGER

{REALNUM}  REAL

["](\\.|[^"\r\n\\])*["] STRING
['](\\.|[^'\r\n\\])*['] STRING


[<]([^>]+)">"  HEX_STRING

[A-Za-z_][A-Za-z_0-9]*  IDENTIFIER


"="	'='
"-"	'-'
","	','
";"	';'
":"	':'
"/"	'/'
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"*"	'*'
"%"	'%'

%%
