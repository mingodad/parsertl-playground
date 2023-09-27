//From: https://github.com/markrileybot/thrift-nano/blob/7cd68a310f7346d45becf2c79f1b0555990e8422/compiler/cpp/src/thrifty.yy
/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements. See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership. The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

/**
 * Thrift parser.
 *
 * This parser is used on a thrift definition file.
 *
 */

/*Tokens*/
%token tok_identifier
%token tok_literal
//%token tok_doctext
%token tok_st_identifier
%token tok_int_constant
%token tok_dub_constant
%token tok_include
%token tok_namespace
%token tok_cpp_namespace
%token tok_cpp_include
%token tok_cpp_type
%token tok_php_namespace
%token tok_py_module
%token tok_perl_package
%token tok_java_package
%token tok_xsd_all
%token tok_xsd_optional
%token tok_xsd_nillable
%token tok_xsd_namespace
%token tok_xsd_attrs
%token tok_ruby_namespace
%token tok_smalltalk_category
%token tok_smalltalk_prefix
%token tok_cocoa_prefix
%token tok_csharp_namespace
%token tok_delphi_namespace
%token tok_void
%token tok_bool
%token tok_byte
%token tok_string
%token tok_binary
%token tok_slist
%token tok_senum
%token tok_i16
%token tok_i32
%token tok_i64
%token tok_double
%token tok_map
%token tok_list
%token tok_set
%token tok_oneway
%token tok_typedef
%token tok_struct
%token tok_xception
%token tok_throws
%token tok_extends
%token tok_service
%token tok_enum
%token tok_const
%token tok_required
%token tok_optional
%token tok_union
%token tok_reference
%token '*'
%token ','
%token ';'
%token '{'
%token '}'
%token '='
%token '['
%token ']'
%token ':'
%token '('
%token ')'
%token '<'
%token '>'


%start Program

%%

Program :
	HeaderList DefinitionList
	;

CaptureDocText :
	/*empty*/
	;

DestroyDocText :
	/*empty*/
	;

HeaderList :
	HeaderList DestroyDocText Header
	| /*empty*/
	;

Header :
	Include
	| tok_namespace tok_identifier tok_identifier
	| tok_namespace '*' tok_identifier
	| tok_cpp_namespace tok_identifier
	| tok_cpp_include tok_literal
	| tok_php_namespace tok_identifier
	| tok_py_module tok_identifier
	| tok_perl_package tok_identifier
	| tok_ruby_namespace tok_identifier
	| tok_smalltalk_category tok_st_identifier
	| tok_smalltalk_prefix tok_identifier
	| tok_java_package tok_identifier
	| tok_cocoa_prefix tok_identifier
	| tok_xsd_namespace tok_literal
	| tok_csharp_namespace tok_identifier
	| tok_delphi_namespace tok_identifier
	;

Include :
	tok_include tok_literal
	;

DefinitionList :
	DefinitionList CaptureDocText Definition
	| /*empty*/
	;

Definition :
	Const
	| TypeDefinition
	| Service
	;

TypeDefinition :
	Typedef
	| Enum
	| Senum
	| Struct
	| Xception
	;

Typedef :
	tok_typedef FieldType tok_identifier TypeAnnotations
	;

CommaOrSemicolonOptional :
	','
	| ';'
	| /*empty*/
	;

Enum :
	tok_enum tok_identifier '{' EnumDefList '}' TypeAnnotations
	;

EnumDefList :
	EnumDefList EnumDef
	| /*empty*/
	;

EnumDef :
	CaptureDocText tok_identifier '=' tok_int_constant TypeAnnotations CommaOrSemicolonOptional
	| CaptureDocText tok_identifier TypeAnnotations CommaOrSemicolonOptional
	;

Senum :
	tok_senum tok_identifier '{' SenumDefList '}' TypeAnnotations
	;

SenumDefList :
	SenumDefList SenumDef
	| /*empty*/
	;

SenumDef :
	tok_literal CommaOrSemicolonOptional
	;

Const :
	tok_const FieldType tok_identifier '=' ConstValue CommaOrSemicolonOptional
	;

ConstValue :
	tok_int_constant
	| tok_dub_constant
	| tok_literal
	| tok_identifier
	| ConstList
	| ConstMap
	;

ConstList :
	'[' ConstListContents ']'
	;

ConstListContents :
	ConstListContents ConstValue CommaOrSemicolonOptional
	| /*empty*/
	;

ConstMap :
	'{' ConstMapContents '}'
	;

ConstMapContents :
	ConstMapContents ConstValue ':' ConstValue CommaOrSemicolonOptional
	| /*empty*/
	;

StructHead :
	tok_struct
	| tok_union
	;

Struct :
	StructHead tok_identifier XsdAll '{' FieldList '}' TypeAnnotations
	;

XsdAll :
	tok_xsd_all
	| /*empty*/
	;

XsdOptional :
	tok_xsd_optional
	| /*empty*/
	;

XsdNillable :
	tok_xsd_nillable
	| /*empty*/
	;

XsdAttributes :
	tok_xsd_attrs '{' FieldList '}'
	| /*empty*/
	;

Xception :
	tok_xception tok_identifier '{' FieldList '}' TypeAnnotations
	;

Service :
	tok_service tok_identifier Extends '{' FlagArgs FunctionList UnflagArgs '}' TypeAnnotations
	;

FlagArgs :
	/*empty*/
	;

UnflagArgs :
	/*empty*/
	;

Extends :
	tok_extends tok_identifier
	| /*empty*/
	;

FunctionList :
	FunctionList Function
	| /*empty*/
	;

Function :
	CaptureDocText Oneway FunctionType tok_identifier '(' FieldList ')' Throws TypeAnnotations CommaOrSemicolonOptional
	;

Oneway :
	tok_oneway
	| /*empty*/
	;

Throws :
	tok_throws '(' FieldList ')'
	| /*empty*/
	;

FieldList :
	FieldList Field
	| /*empty*/
	;

Field :
	CaptureDocText FieldIdentifier FieldRequiredness FieldType FieldReference tok_identifier FieldValue XsdOptional XsdNillable XsdAttributes TypeAnnotations CommaOrSemicolonOptional
	;

FieldIdentifier :
	tok_int_constant ':'
	| /*empty*/
	;

FieldReference :
	tok_reference
	| /*empty*/
	;

FieldRequiredness :
	tok_required
	| tok_optional
	| /*empty*/
	;

FieldValue :
	'=' ConstValue
	| /*empty*/
	;

FunctionType :
	FieldType
	| tok_void
	;

FieldType :
	tok_identifier
	| BaseType
	| ContainerType
	;

BaseType :
	SimpleBaseType TypeAnnotations
	;

SimpleBaseType :
	tok_string
	| tok_binary
	| tok_slist
	| tok_bool
	| tok_byte
	| tok_i16
	| tok_i32
	| tok_i64
	| tok_double
	;

ContainerType :
	SimpleContainerType TypeAnnotations
	;

SimpleContainerType :
	MapType
	| SetType
	| ListType
	;

MapType :
	tok_map CppType '<' FieldType ',' FieldType '>'
	;

SetType :
	tok_set CppType '<' FieldType '>'
	;

ListType :
	tok_list '<' FieldType '>' CppType
	;

CppType :
	tok_cpp_type tok_literal
	| /*empty*/
	;

TypeAnnotations :
	'(' TypeAnnotationList ')'
	| /*empty*/
	;

TypeAnnotationList :
	TypeAnnotationList TypeAnnotation
	| /*empty*/
	;

TypeAnnotation :
	tok_identifier TypeAnnotationValue CommaOrSemicolonOptional
	;

TypeAnnotationValue :
	'=' tok_literal
	| /*empty*/
	;

%%

/**
 * Helper definitions, comments, constants, and whatnot
 */

intconstant   ([+-]?[0-9]+)
hexconstant   ("0x"[0-9A-Fa-f]+)
dubc1   ([+-]?[0-9]+([eE][+-]?[0-9]+))
dubc2   ((\.[0-9]+)([eE][+-]?[0-9]+)?)
dubconstant   {dubc1}|{dubc2}
identifier    ([a-zA-Z_](\.[a-zA-Z_0-9]|[a-zA-Z_0-9])*)
whitespace    ([ \t\r\n]+)
sillycomm     ("/*""*"*"*/")
multicomm     ("/*"[^*]"/"*([^*/]|[^*]"/"|"*"[^/])*"*"*"*/")
doctext       ("/**"([^*/]|[^*]"/"|"*"[^/])*"*"*"*/")
comment       ("//"[^\n]*)
unixcomment   ("#"[^\n]*)
symbol        ([:;\,\{\}\(\)\=<>\[\]])
st_identifier ([a-zA-Z-](\.[a-zA-Z_0-9-]|[a-zA-Z_0-9-])*)
literal_begin (['\"])

%%

{whitespace}         skip()
{sillycomm}          skip()
{multicomm}          skip()
{comment}            skip()
{unixcomment}        skip()

//{symbol}             yytext[0]
//"*"                  yytext[0]

"false"              skip()tok_int_constant
"true"               tok_int_constant

"namespace"          tok_namespace
"cpp_namespace"      tok_cpp_namespace
"cpp_include"        tok_cpp_include
"cpp_type"           tok_cpp_type
"java_package"       tok_java_package
"cocoa_prefix"       tok_cocoa_prefix
"csharp_namespace"   tok_csharp_namespace
"delphi_namespace"   tok_delphi_namespace
"php_namespace"      tok_php_namespace
"py_module"          tok_py_module
"perl_package"       tok_perl_package
"ruby_namespace"     tok_ruby_namespace
"smalltalk_category" tok_smalltalk_category
"smalltalk_prefix"   tok_smalltalk_prefix
"xsd_all"            tok_xsd_all
"xsd_optional"       tok_xsd_optional
"xsd_nillable"       tok_xsd_nillable
"xsd_namespace"      tok_xsd_namespace
"xsd_attrs"          tok_xsd_attrs
"include"            tok_include
"void"               tok_void
"bool"               tok_bool
"byte"               tok_byte
"i16"                tok_i16
"i32"                tok_i32
"i64"                tok_i64
"double"             tok_double
"string"             tok_string
"binary"             tok_binary
"slist" tok_slist
"senum" tok_senum
"map"                tok_map
"list"               tok_list
"set"                tok_set
"oneway"             tok_oneway
"typedef"            tok_typedef
"struct"             tok_struct
"union"              tok_union
"exception"          tok_xception
"extends"            tok_extends
"throws"             tok_throws
"service"            tok_service
"enum"               tok_enum
"const"              tok_const
"required"           tok_required
"optional"           tok_optional
"async"  tok_oneway

"&"                  tok_reference

/*
"BEGIN"
"END"
"__CLASS__"
"__DIR__"
"__FILE__"
"__FUNCTION__"
"__LINE__"
"__METHOD__"
"__NAMESPACE__"
"abstract"
"alias"
"and"
"args"
"as"
"assert"
"begin"
"break"
"case"
"catch"
"class"
"clone"
"continue"
"declare"
"def"
"default"
"del"
"delete"
"do"
"dynamic"
"elif"
"else"
"elseif"
"elsif"
"end"
"enddeclare"
"endfor"
"endforeach"
"endif"
"endswitch"
"endwhile"
"ensure"
"except"
"exec"
"finally"
"float"
"for"
"foreach"
"function"
"global"
"goto"
"if"
"implements"
"import"
"in"
"inline"
"instanceof"
"interface"
"is"
"lambda"
"module"
"native"
"new"
"next"
"nil"
"not"
"or"
"pass"
"public"
"print"
"private"
"protected"
"public"
"raise"
"redo"
"rescue"
"retry"
"register"
"return"
"self"
"sizeof"
"static"
"super"
"switch"
"synchronized"
"then"
"this"
"throw"
"transient"
"try"
"undef"
"union"
"unless"
"unsigned"
"until"
"use"
"var"
"virtual"
"volatile"
"when"
"while"
"with"
"xor"
"yield"
*/

"*"	'*'
","	','
";"	';'
"{"	'{'
"}"	'}'
"="	'='
"["	'['
"]"	']'
":"	':'
"("	'('
")"	')'
"<"	'<'
">"	'>'

{intconstant}  tok_int_constant

{hexconstant}  tok_int_constant

{dubconstant}  tok_dub_constant

{identifier}  tok_identifier

{st_identifier}  tok_st_identifier

\"(\\.|[^"\n\r\\])*\" tok_literal


 /* This does not show up in the parse tree. */
 /* Rather, the parser will grab it out of the global. */
{doctext} skip()

//.   /* Catch-all to let us catch "*" in the parser. */

%%
