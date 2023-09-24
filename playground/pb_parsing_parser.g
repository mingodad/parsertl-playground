/*
From: https://github.com/mransan/ocaml-protoc/blob/master/src/compilerlib/pb_parsing_parser.mly

* Converted right recursion to left recursion.

*/
/*
  The MIT License (MIT)

  Copyright (c) 2016 Maxime Ransan <maxime.ransan@gmail.com>

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED T_to THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, T_toRT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
  */

/*Tokens*/

%token T_required
%token T_optional
%token T_repeated
%token T_one_of
%token T_message
%token T_enum
%token T_package
%token T_import
%token T_public
%token T_option
%token T_extensions
%token T_extend
%token T_reserved
%token T_returns
%token T_rpc
%token T_service
%token T_stream
%token T_syntax
%token T_to
%token T_max
%token T_map
%token T_rbrace
%token T_lbrace
%token T_rbracket
%token T_lbracket
%token T_rparen
%token T_lparen
%token T_greater
%token T_less
%token T_equal
%token T_semi
%token T_colon
%token T_comma
%token T_string
%token T_int
%token T_float
%token T_ident
//%token T_eof

/*
%precedence T_message T_enum T_package T_import T_option T_service T_extend
%precedence GO_SHIFT
*/

%start proto

%%

proto :
	syntax proto_content_oom
	;
/*
proto_content_zom :
    %empty %prec GO_SHIFT
    | proto_content
    | proto_content_zom proto_content
    ;
*/

proto_content_oom :
    proto_content
    | proto_content_oom proto_content
    ;

proto_content :
	import
	| option
	| package_declaration
	| message
	| service
	| enum
	| extend
	;

syntax :
	T_syntax T_equal T_string semicolon
	;

import :
	T_import T_string semicolon
	| T_import T_public T_string semicolon
	| T_import T_ident T_string semicolon
	;

package_declaration :
	T_package T_ident semicolon
	;

message :
	T_message T_ident T_lbrace message_body_content_list rbrace
	| T_message T_ident T_lbrace rbrace
	;

message_body_content_list :
	message_body_content
	| message_body_content_list message_body_content
	;

message_body_content :
	normal_field
	| map
	| oneof
	| message
	| enum
	| extension
	| reserved
	| option
	;

extend :
	T_extend T_ident T_lbrace normal_field_list rbrace
	| T_extend T_ident T_lbrace rbrace
	;

normal_field_list :
	normal_field
	| normal_field_list normal_field
	;

extension :
	T_extensions extension_range_list semicolon
	;

reserved :
	T_reserved extension_range_list semicolon
	;

service :
	T_service T_ident T_lbrace service_body_content_list rbrace
	| T_service T_ident T_lbrace rbrace
	;

service_body_content_list :
	service_body_content
	| service_body_content_list service_body_content
	;

service_body_content :
	rpc
	| option
	;

message_type :
	T_stream T_ident
	| T_ident
	;

rpc :
	T_rpc T_ident T_lparen message_type T_rparen T_returns T_lparen message_type T_rparen semicolon
	| T_rpc T_ident T_lparen message_type T_rparen T_returns T_lparen message_type T_rparen rpc_options
	;

rpc_options :
	T_lbrace rpc_options_list T_rbrace
	| T_lbrace rpc_options_list T_rbrace semicolon
	| T_lbrace T_rbrace
	| T_lbrace T_rbrace semicolon
	;

rpc_options_list :
	rpc_option
	| rpc_options_list rpc_option
	;

rpc_option :
	T_option option_identifier T_equal option_value semicolon
	;

option_value :
	constant
	| T_lbrace T_rbrace
	| T_lbrace option_content_map T_rbrace
	| T_lbracket T_rbracket
	| T_lbracket option_content_list T_rbracket
	;

option_content_map :
	option_content_map_item
	//| option_content_map_item T_comma
	| option_content_map T_comma option_content_map_item
	;

option_content_map_item :
	T_ident T_colon option_value
	;

option_content_list :
	option_value
	//| option_value T_comma
	| option_content_list T_comma option_value
	;

extension_range_list :
	extension_range
	| extension_range_list T_comma extension_range
	;

extension_range :
	T_int
	| T_int T_to T_int
	| T_int T_to T_max
	;

oneof :
	T_one_of field_name T_lbrace oneof_field_list rbrace
	| T_one_of T_lbrace oneof_field_list rbrace
	;

oneof_field_list :
	/*empty*/
	| oneof_field_list oneof_field
	;

oneof_field :
	T_ident field_name T_equal T_int field_options semicolon
	| T_ident field_name T_equal T_int semicolon
	| option
	;

map :
	T_map T_less T_ident T_comma T_ident T_greater field_name T_equal T_int semicolon
	| T_map T_less T_ident T_comma T_ident T_greater field_name T_equal T_int field_options semicolon
	;

normal_field :
	label T_ident field_name T_equal T_int field_options semicolon
	| label T_ident field_name T_equal T_int semicolon
	| T_ident field_name T_equal T_int field_options semicolon
	| T_ident field_name T_equal T_int semicolon
	;

field_name :
	T_ident
	| T_required
	| T_optional
	| T_repeated
	| T_one_of
	| T_enum
	| T_package
	| T_import
	| T_public
	| T_option
	| T_extensions
	| T_extend
	| T_reserved
	| T_syntax
	| T_message
	| T_service
	| T_stream
	| T_rpc
	| T_to
	| T_max
	| T_map
	;

label :
	T_required
	| T_repeated
	| T_optional
	;

field_options :
	T_lbracket field_option_list T_rbracket
	| T_lbracket T_rbracket
	;

field_option_list :
	field_option
	| field_option_list T_comma field_option
	;

field_option :
	T_ident T_equal option_value
	| T_lparen T_ident T_rparen T_equal option_value
	| T_lparen T_ident T_rparen T_ident T_equal option_value
	;

option_identifier_item :
	T_ident
	| T_lparen T_ident T_rparen
	;

option_identifier :
	option_identifier_item
	| option_identifier T_ident
	;

option :
	T_option option_identifier T_equal option_value semicolon
	;

constant :
	T_int
	| T_float
	| T_ident
	| T_string
	;

enum :
	T_enum T_ident T_lbrace enum_values rbrace
	;

enum_values :
	/*empty*/
	| enum_values enum_body_content
	;

enum_body_content :
	option
	| enum_value
	| reserved
	;

enum_value :
	T_ident T_equal T_int semicolon
	| T_ident T_equal T_int field_options semicolon
	| T_ident T_equal T_int
	| T_ident T_equal T_int T_comma
	| T_ident T_comma
	| T_ident T_semi
	| T_ident
	;

semicolon :
	T_semi
	| semicolon T_semi
	;

rbrace :
	T_rbrace
	| rbrace T_semi
	;

%%

start_letter	[a-zA-Z_]
identchar   	[A-Za-z_0-9]
ident       	{start_letter}{identchar}*
full_ident  	"."?{ident}("."*{ident})*
/* message_type	"."?({ident}"."){ident} */
digit	[0-9]
int_litteral	[+-]?{digit}+
hex_litteral	[+-]?"0x"[0-9a-fA-F]+
inf_litteral	[+-]?"inf"

/* TODO fix: somehow E1 for field identified get lexed into a float. */
float_literal	[+-]?{digit}+("."{digit}+)?([eE][+-]?{digit}+)?

newline	\n\r?|\r\n?
blank  	[ \t\f\v]

%%

"message"	T_message
"required"	T_required
"optional"	T_optional
"repeated"	T_repeated
"oneof"	T_one_of
"enum"   	T_enum
"package"	T_package
"import"	T_import
"option" 	T_option
"extensions"	T_extensions
"extend" 	T_extend
"returns"	T_returns
"rpc"    	T_rpc
"service"	T_service
"stream" 	T_stream
"syntax" 	T_syntax
"public" 	T_public
"to"     	T_to
"max"    	T_max
"map"    	T_map
"reserved"	T_reserved

"{"	T_lbrace
"}"	T_rbrace
"["	T_lbracket
"]"	T_rbracket
")"	T_rparen
"("	T_lparen
"<"	T_less
">"	T_greater
"="	T_equal
";"	T_semi
":"	T_colon
","	T_comma

"//".*	skip()
"/*"(?s:.)*?"*/"	skip()
\"("\\".|[^"\n\r\\])*\" 	T_string

{int_litteral}	T_int
{hex_litteral}	T_int
{float_literal}	T_float
{inf_litteral}	T_float
{newline}+	skip()
{blank}+	skip()
{full_ident}	T_ident

%%
