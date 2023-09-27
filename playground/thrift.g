//From: https://github.com/apache/thrift/blob/bc9c04d8049d7d5f5cf4e63a25226c1fb8c930bf/compiler/cpp/src/thrift/thrifty.yy
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
%token tok_int_constant
%token tok_dub_constant
%token tok_include
%token tok_namespace
%token tok_cpp_include
%token tok_cpp_type
%token tok_xsd_all
%token tok_xsd_optional
%token tok_xsd_nillable
%token tok_xsd_attrs
%token tok_void
%token tok_bool
%token tok_string
%token tok_binary
%token tok_uuid
%token tok_byte
%token tok_i8
%token tok_i16
%token tok_i32
%token tok_i64
%token tok_double
%token tok_map
%token tok_list
%token tok_set
%token tok_oneway
%token tok_async
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
	| tok_namespace tok_identifier tok_identifier TypeAnnotations
	| tok_namespace '*' tok_identifier
	| tok_cpp_include tok_literal
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
	| Struct
	| Xception
	;

CommaOrSemicolonOptional :
	','
	| ';'
	| /*empty*/
	;

Typedef :
	tok_typedef FieldType tok_identifier TypeAnnotations CommaOrSemicolonOptional
	;

Enum :
	tok_enum tok_identifier '{' EnumDefList '}' TypeAnnotations
	;

EnumDefList :
	EnumDefList EnumDef
	| /*empty*/
	;

EnumDef :
	CaptureDocText EnumValue TypeAnnotations CommaOrSemicolonOptional
	;

EnumValue :
	tok_identifier '=' tok_int_constant
	| tok_identifier
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
	| tok_async
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
	CaptureDocText FieldIdentifier FieldRequiredness FieldType FieldReference FieldName FieldValue XsdOptional XsdNillable XsdAttributes TypeAnnotations CommaOrSemicolonOptional
	;

FieldName :
	tok_identifier
	| tok_namespace
	| tok_cpp_include
	| tok_include
	| tok_void
	| tok_bool
	| tok_byte
	| tok_i8
	| tok_i16
	| tok_i32
	| tok_i64
	| tok_double
	| tok_string
	| tok_binary
	| tok_uuid
	| tok_map
	| tok_list
	| tok_set
	| tok_oneway
	| tok_async
	| tok_typedef
	| tok_struct
	| tok_union
	| tok_xception
	| tok_extends
	| tok_throws
	| tok_service
	| tok_enum
	| tok_const
	| tok_required
	| tok_optional
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
	| tok_uuid
	| tok_bool
	| tok_byte
	| tok_i8
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
	tok_list CppType '<' FieldType '>' CppType
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
hexconstant   ([+-]?"0x"[0-9A-Fa-f]+)
dexp	([eE][+-]?[0-9]+)
dubc1   ([+-]?[0-9]+(\.[0-9]+)?{dexp}?)
dubc2   ((\.[0-9]+){dexp}?)
dubconstant   {dubc1}|{dubc2}|{dexp}
identifier    ([a-zA-Z_](\.[a-zA-Z_0-9]|[a-zA-Z_0-9])*)
whitespace    ([ \t\r\n]+)
sillycomm     ("/*""*"*"*/")
multicm_begin ("/*")
doctext_begin ("/**")
comment       ("//"[^\n]*)
unixcomment   ("#"[^\n]*)
symbol        ([:;\,\{\}\(\)\=<>\[\]])
literal_begin (['\"])

%%

{whitespace}         skip()
{sillycomm}          skip()

//{doctext_begin} skip()

"/*"(?s:.)*?"*/"  skip()

{comment}            skip()
{unixcomment}        skip()

"false"              tok_int_constant
"true"               tok_int_constant

"namespace"          tok_namespace
"cpp_include"        tok_cpp_include
"cpp_type"           tok_cpp_type
"xsd_all"            tok_xsd_all
"xsd_optional"       tok_xsd_optional
"xsd_nillable"       tok_xsd_nillable
"xsd_attrs"          tok_xsd_attrs
"include"            tok_include
"void"               tok_void
"bool"               tok_bool
"byte"               tok_byte
"i8"                 tok_i8
"i16"                tok_i16
"i32"                tok_i32
"i64"                tok_i64
"double"             tok_double
"string"             tok_string
"binary"             tok_binary
"uuid"               tok_uuid
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
"async"  tok_async

"&"                  tok_reference

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

{identifier}  tok_identifier

/* Deliberately placed after identifier, since "e10" is NOT a double literal (THRIFT-3477) */
{dubconstant}  tok_dub_constant

\"(\\.|[^"\n\r\\])*\"	tok_literal

//.   unexpected_token(yytext);


%%
