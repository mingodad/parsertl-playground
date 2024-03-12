//From: https://github.com/goccmack/gocc/blob/2292f9e40198d1d43db1e951089d4edd34079619/spec/gocc2.ebnf
//Copyright 2013 Vastech SA (PTY) LTD
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

%token char_lit
%token g_sdt_lit
%token ignoredTokId
%token prodId
%token regDefId
%token string_lit
%token tokId

%%

/*** Syntactic items ***/

Grammar :
	LexicalPart SyntaxPart
	| LexicalPart
	| SyntaxPart
	;

LexicalPart :
	LexProductions
	;

LexProductions :
	LexProduction
	| LexProductions LexProduction
	;

LexProduction :
	tokId ':' LexPattern ';'
	| regDefId ':' LexPattern ';'
	| ignoredTokId ':' LexPattern ';'
	;

LexPattern :
	LexAlt
	| LexPattern '|' LexAlt
	;

LexAlt :
	LexTerm
	| LexAlt LexTerm
	;

LexTerm :
	'.'
	| char_lit
	| char_lit '-' char_lit
	| regDefId
	| '[' LexPattern ']'
	| '{' LexPattern '}'
	| '(' LexPattern ')'
	;

SyntaxPart :
	FileHeader SyntaxProdList
	| SyntaxProdList
	;

FileHeader :
	g_sdt_lit
	;

SyntaxProdList :
	SyntaxProduction
	| SyntaxProdList SyntaxProduction
	;

SyntaxProduction :
	prodId ':' Alternatives ';'
	;

Alternatives :
	SyntaxBody
	|	Alternatives '|' SyntaxBody
	;

SyntaxBody :
	Symbols
	| Symbols g_sdt_lit
	| "error"
	| "error" Symbols
	| "error" Symbols g_sdt_lit
	| "empty"
	| "empty" g_sdt_lit
	;

Symbols :
	Symbol
	| Symbols Symbol
	;

Symbol :
	prodId
	| tokId
	| string_lit
	;

%%

%%

/********
Lexical items
The basic unit of input to the lexical analyser is a UTF-8 encoded Unicode code point, defined as:

_unicode_char : < any Unicode code point > .

_letter : 'A' ... 'Z' | 'a' ... 'z' | '_' ;

_digit : '0' ... '9' ;

char : "'" ( _unicode_value | _byte_value ) "'" ;

_unicode_value    : _unicode_char | _little_u_value | _big_u_value | _escaped_char ;
_byte_value       : _octal_byte_value | _hex_byte_value ;
_octal_byte_value : `\` _octal_digit _octal_digit _octal_digit ;
_hex_byte_value   : `\` "x" _hex_digit _hex_digit ;
_little_u_value   : `\` "u" _hex_digit _hex_digit _hex_digit _hex_digit ;
_big_u_value      : `\` "U" _hex_digit _hex_digit _hex_digit _hex_digit
                            _hex_digit _hex_digit _hex_digit _hex_digit ;
_escaped_char     : `\` ( "a" | "b" | "f" | "n" | "r" | "t" | "v" | `\` | `'` | `"` ) ;

id : _letter (_letter | _digit)* ;

string : _raw_string | _interpreted_string ;
_raw_string : "`" _unicode_char* "`" ;
_interpreted_string : `"` ( _unicode_value | byte_value )* `"` ;

g_sdt_lit	: '<' '<' _unicode_char+ '>' '>'
**********/

/*** TODO: ***
1. Handle reserved words correctly so that user cannot write reserved words in his grammar. E.g.: string_lit, prodId, etc.
***/

[ \t\r\n]+  skip()
"//".*  skip()
"/*"(?s:.)*?"*/"    skip()

"|"	'|'
"-"	'-'
";"	';'
":"	':'
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'

"empty"	"empty"
"error"	"error"

'(\\.|[^'\r\n\\])+'	char_lit
"<<"(?s:.)*?">>"	g_sdt_lit
\"(\\.|[^"\r\n\\])+\"	string_lit
"`"(\\.|[^`\r\n\\])+"`"	string_lit
[A-Z][0-9A-Za-z_]*	prodId
[a-z][0-9A-Za-z_]*	tokId
[_][0-9A-Za-z_]*	regDefId
"!"[0-9A-Za-z_]*	ignoredTokId

%%
