//From: https://openddl.org/openddl-spec.pdf
/*
Open Data Description Language
	Speciﬁcation
	Version 3.0
	Updated October 25, 2021

	by Eric Lengyel

	Terathon Software LLC
	Lincoln, California
*/

%token base64_data
%token bool_literal
%token float_literal
%token identifier
%token integer_literal
%token string_literal

%%

file :
	structure_zom
	;

structure_zom :
	%empty
	| structure_zom structure
	;

structure :
	data_type name_opt '{' data_list_opt '}'
	| data_type '[' integer_literal ']' star_opt name_opt '{' data_array_list_opt '}'
	| identifier name_opt param_opt '{'structure_zom '}'
	;

star_opt :
	%empty
	| '*'
	;

param_opt :
	%empty
	| '(' property_list_opt ')'
	;

data_type :
	"bool"
	| 'b'
	| "int8" | "i8"
	| "int16" | "i16"
	| "int32" | "i32"
	| "int64" | "i64"
	| "uint8" | "u8"
	| "uint16" | "u16"
	| "uint32" | "u32"
	| "uint64" | "u64"
	| "half" | 'h' | "float" | 'f'
	| "double" | 'd'
	| "float16" | "f16"
	| "float32" | "f32"
	| "float64" | "f64"
	| "string" | 's'
	| "ref" | 'r'
	| "type" | 't'
	| "base64" | 'z'
	;

property :
	identifier
	| identifier '=' propert_value
	;

propert_value :
	bool_literal
	| integer_literal
	| float_literal
	| string_literal
	| reference
	| data_type
	| base64_data
	;

data_array_list_opt :
	%empty
	| data_array_list
	;

data_array_list :
	data_array_bool_literal_list
	| data_array_integer_literal_list
	| data_array_float_literal_list
	| data_array_string_literal_list
	| data_array_reference_list
	| data_array_data_type_list
	| data_array_base64_data_list
	;

data_array_bool_literal_list :
	identifier_opt '{' bool_literal_list '}'
	| data_array_bool_literal_list ',' identifier_opt '{' bool_literal_list '}'
	;

data_array_integer_literal_list :
	identifier_opt '{' integer_literal_list '}'
	| data_array_integer_literal_list ',' identifier_opt '{' integer_literal_list '}'
	;

data_array_float_literal_list :
	identifier_opt '{' float_literal_list '}'
	| data_array_float_literal_list ',' identifier_opt '{' float_literal_list '}'
	;

data_array_string_literal_list :
	identifier_opt '{' string_literal_list '}'
	| data_array_string_literal_list ',' identifier_opt '{' string_literal_list '}'
	;

data_array_reference_list :
	identifier_opt '{' reference_list '}'
	| data_array_reference_list ',' identifier_opt '{' reference_list '}'
	;

data_array_data_type_list :
	identifier_opt '{' data_type_list '}'
	| data_array_data_type_list ',' identifier_opt '{' data_type_list '}'
	;

data_array_base64_data_list :
	identifier_opt '{' base64_data_list '}'
	| data_array_base64_data_list ',' identifier_opt '{' base64_data_list '}'
	;

identifier_opt :
	%empty
	| identifier
	;

data_list_opt :
	%empty
	| data_list
	;

data_list :
	bool_literal_list
	| integer_literal_list
	| float_literal_list
	| string_literal_list
	| reference_list
	| data_type_list
	| base64_data_list
	;

bool_literal_list :
	bool_literal
	| bool_literal_list ',' bool_literal
	;

integer_literal_list :
	integer_literal
	| integer_literal_list ',' integer_literal
	;

float_literal_list :
	float_literal
	| float_literal_list ',' float_literal
	;

string_literal_list :
	string_literal
	| string_literal_list ',' string_literal
	;

reference_list :
	reference
	| reference_list ',' reference
	;

data_type_list :
	data_type
	| data_type_list ',' data_type
	;

base64_data_list :
	base64_data
	| base64_data_list ',' base64_data
	;

property_list_opt :
	%empty
	| property_list
	;

property_list :
	property
	| property_list ',' property
	;

name_opt :
	%empty
	| name
	;

name :
	'$' identifier
	| '%' identifier
	;

reference :
	name reference_seq
	| "null"
	;

reference_seq :
	%empty
	| reference_seq '%' identifier
	;

%%

hex_digit	[0-9A-Fa-f]
escape_char	\\(["'?\\abfnrtv]|x{hex_digit}{hex_digit})
decimal_literal	[0-9]("_"?[0-9])*
hex_literal	"0"[Xx]{hex_digit}("_"?{hex_digit})*
octal_literal	"0"[Oo][0-7]("_"?[0-7])*
binary_literal	"0"[Bb][01]("_"?[01])*
char_literal	'([\x20-\x26\x28-\x5B\x5D-\x7E]|{escape_char})+'
sign	[+-]

%%

[ \t\r\n]+  skip()
"//".*  skip()
"/*"(?s:.)*?"*/"    skip()

"="	'='
","	','
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"$"	'$'
"*"	'*'
"%"	'%'
"b"	'b'
"base64"	"base64"
"bool"	"bool"
"d"	'd'
"double"	"double"
"f"	'f'
"f16"	"f16"
"f32"	"f32"
"f64"	"f64"
"float"	"float"
"float16"	"float16"
"float32"	"float32"
"float64"	"float64"
"h"	'h'
"half"	"half"
"i16"	"i16"
"i32"	"i32"
"i64"	"i64"
"i8"	"i8"
"int16"	"int16"
"int32"	"int32"
"int64"	"int64"
"int8"	"int8"
"null"	"null"
"r"	'r'
"ref"	"ref"
"s"	's'
"string"	"string"
"t"	't'
"type"	"type"
"u16"	"u16"
"u32"	"u32"
"u64"	"u64"
"u8"	"u8"
"uint16"	"uint16"
"uint32"	"uint32"
"uint64"	"uint64"
"uint8"	"uint8"
"z"	'z'

"false"|"true"	bool_literal

([A-Za-z0-9]|"+"|"/")+"=""="	base64_data

{sign}?({decimal_literal}|{hex_literal}|{octal_literal}|{binary_literal}|{char_literal})	integer_literal

{sign}?(([0-9]("_"?[0-9])*("."([0-9]("_"?[0-9])*)?)?|"."[0-9]("_"?[0-9])*)([Ee]{sign}?[0-9]("_"?[0-9])*)?|{hex_literal}|{octal_literal}|{binary_literal})	float_literal

//(\"([\x20-\x21\x23-\x5B\x5D-\x7E\xA0-\xD7FF\xE000-\xFFFD\x010000-\x10FFFF]|{escape_char}|"\\u"{hex_digit}{4}|"\\U"{hex_digit}{6})*\")+	string_literal
(\"([\x20-\x21\x23-\x5B\x5D-\x7E\xA0-\xFF]|{escape_char}|"\\u"{hex_digit}{4}|"\\U"{hex_digit}{6})*\")+	string_literal

[A-Za-z_][0-9A-Za-z_]*	identifier

%%
