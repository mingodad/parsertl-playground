%token string_constant integer_constant float_constant boolean_constant ident

%%

schema :
	include
	| decl
	| schema include
	| schema decl
	;

decl :
	namespace_decl
	| type_decl
	| enum_decl
	| union_decl
	| root_decl
	| file_extension_decl
	| file_identifier_decl
	| attribute_decl
	| rpc_decl
	| object
	;

include :
	"include" string_constant ';'
	| "native_include" string_constant ';'
	;

namespace_decl :
	"namespace" qualident ';'
	;

qualident :
	ident
	| qualident '.' ident
	;

attribute_decl :
	"attribute" ident ';'
	| "attribute" string_constant ';'
	;

type_decl :
	table_or_struct ident metadata_opt '{' field_decl_zom '}'
	;

table_or_struct :
	"table"
	| "struct"
	;

enum_decl :
	"enum" ident ':' type metadata_opt enum_decl_body
	;

enum_decl_body :
    '{' '}'
    | '{' enumval_decl_list '}'
    | '{' enumval_decl_list ',' '}'
    ;

union_decl :
	"union" ident metadata_opt union_decl_body
	;

union_decl_body :
    '{' '}'
    | '{' unionval_decl_list '}'
    | '{' unionval_decl_list ',' '}'
    ;

root_decl :
	"root_type" ident ';'
	;

field_decl_zom :
	%empty
	| field_decl_zom field_decl
	;

field_decl :
	ident ':' type type_assign_opt metadata_opt ';'
	;

type_assign_opt :
	%empty
	| '=' value
	;

rpc_decl :
	"rpc_service" ident '{' rpc_method_oom '}'
	;

rpc_method_oom :
	rpc_method
	| rpc_method_oom rpc_method
	;

rpc_method :
	ident '(' ident ')' ':' ident metadata ';'
	;

type :
	"bool"
	| "byte"
	| "ubyte"
	| "short"
	| "ushort"
	| "int"
	| "uint"
	| "float"
	| "long"
	| "ulong"
	| "double"
	| "int8"
	| "uint8"
	| "int16"
	| "uint16"
	| "int32"
	| "uint32"
	| "int64"
	| "uint64"
	| "float32"
	| "float64"
	| "string"
	| '[' type ']'
	| qualident
	;

enumval_decl_list :
	enumval_decl
	| enumval_decl_list ',' enumval_decl
	;

enumval_decl :
	qualident ident_assign_opt
	;

ident_assign_opt :
	%empty
	| '=' integer_constant
	;

unionval_decl_list :
	unionval_decl
	| unionval_decl_list ',' unionval_decl
	;

unionval_decl :
	qualident type_opt metadata_opt
	;

type_opt :
	%empty
	| ':' type
	;

metadata_opt :
    %empty
    | metadata
    ;

metadata :
	'(' key_val_opt_list ')'
	;

key_val_opt_list :
	key_val_opt
	| key_val_opt_list ',' key_val_opt
	;

key_val_opt :
	ident
	| ident ':' single_value
	;

scalar :
	boolean_constant
	| integer_constant
	| float_constant
	| "null"
	;

object :
	'{' object_kv_list '}'
	;

object_kv_list :
	key_val
	| object_kv_list ',' key_val
	;

key_val :
	ident ':' value
	;

single_value :
	scalar
	| string_constant
	;

value :
	single_value
	| object
	| '[' ']'
	| '[' value_list ']'
	| ident
	;

value_list :
	value
	| value_list ',' value
	;

file_extension_decl :
	"file_extension" string_constant ';'
	;

file_identifier_decl :
	"file_identifier" string_constant ';'
	;

%%

digit [0-9]
xdigit [0-9a-fA-F]

dec_integer_constant [-+]?{digit}+
hex_integer_constant [-+]?0[xX]{xdigit}+

dec_float_constant [-+]?(([.]{digit}+)|({digit}+[.]{digit}*)|({digit}+))([eE][-+]?{digit}+)?

hex_float_constant  [-+]?0[xX](([.]{xdigit}+)|({xdigit}+[.]{xdigit}*)|({xdigit}+))([pP][-+]?{digit}+)

special_float_constant  [-+]?("nan"|"inf"|"infinity")

%%

[\n\r\t ]+ skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

","	','
";"	';'
":"	':'
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"=" '='

"attribute"	"attribute"
"bool"	"bool"
"byte"	"byte"
"double"	"double"
"enum"	"enum"
"file_extension"	"file_extension"
"file_identifier"	"file_identifier"
"float"	"float"
"float32"	"float32"
"float64"	"float64"
"include"	"include"
"native_include"    "native_include"
"int"	"int"
"int16"	"int16"
"int32"	"int32"
"int64"	"int64"
"int8"	"int8"
"long"	"long"
"namespace"	"namespace"
"root_type"	"root_type"
"rpc_service"	"rpc_service"
"short"	"short"
"string"	"string"
"struct"	"struct"
"table"	"table"
"ubyte"	"ubyte"
"uint"	"uint"
"uint16"	"uint16"
"uint32"	"uint32"
"uint64"	"uint64"
"uint8"	"uint8"
"ulong"	"ulong"
"union"	"union"
"ushort"	"ushort"
"null"  "null"

\"(\\.|[^"\n\r\\])*\"	string_constant

{dec_integer_constant}|{hex_integer_constant}	integer_constant

{dec_float_constant}|{hex_float_constant}|{special_float_constant}	float_constant

"true"|"false"	boolean_constant

[a-zA-Z_][a-zA-Z0-9_]*	ident

%%
