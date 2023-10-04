//From: https://github.com/videolan/vlc/blob/f7bb59d9f51cc10b25ff86d34a3eff744e60c46e/modules/codec/webvtt/CSSGrammar.y
/*****************************************************************************
 * CSSGrammar.y: bison production rules for simplified css parsing
 *****************************************************************************
 *  Copyright ©   2017 VideoLabs, VideoLAN and VLC Authors
 *
 *  Adapted from webkit's CSSGrammar.y:
 *
 *  Copyright (C) 2002-2003 Lars Knoll (knoll@kde.org)
 *  Copyright (C) 2004, 2005, 2006, 2007, 2008, 2009, 2010 Apple Inc. All rights reserved.
 *  Copyright (C) 2006 Alexey Proskuryakov (ap@nypop.com)
 *  Copyright (C) 2008 Eric Seidel <eric@webkit.org>
 *  Copyright (C) 2012 Intel Corporation. All rights reserved.
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */


/*Tokens*/
%token UNIMPORTANT_TOK
%token WHITESPACE
%token SGML_CD
%token INCLUDES
%token DASHMATCH
%token BEGINSWITH
%token ENDSWITH
%token CONTAINS
%token STRING
%token IDENT
%token IDSEL
%token HASH
%token ':'
%token '.'
%token '['
%token '*'
//%token '|'
%token FONT_FACE_SYM
%token CHARSET_SYM
%token IMPORTANT_SYM
//%token CDO
//%token CDC
%token LENGTH
%token ANGLE
%token TIME
%token FREQ
%token DIMEN
%token PERCENTAGE
%token NUMBER
%token URI
%token FUNCTION
%token UNICODERANGE
%token '}'
%token ';'
%token '{'
%token '+'
%token '~'
%token '>'
%token '-'
%token ','
%token ']'
%token '='
%token ')'
%token '/'
%token '#'
%token '%'

//%nonassoc /*1*/ LOWEST_PREC
%left /*2*/ UNIMPORTANT_TOK
%right /*3*/ IDENT
%nonassoc /*4*/ IDSEL
%nonassoc /*5*/ HASH
%nonassoc /*6*/ ':'
%nonassoc /*7*/ '.'
%nonassoc /*8*/ '['
%nonassoc /*9*/ '*'
//%left /*11*/ '|'

%start stylesheet

%%

stylesheet :
	maybe_space maybe_charset maybe_sgml rule_list
	;

maybe_space :
	/*empty*/ %prec UNIMPORTANT_TOK /*2L*/
	| maybe_space WHITESPACE
	;

maybe_sgml :
	/*empty*/
	| maybe_sgml SGML_CD
	| maybe_sgml WHITESPACE
	;

maybe_charset :
	/*empty*/
	| charset
	;

closing_brace :
	'}'
	//| TOKEN_EOF %prec LOWEST_PREC /*1N*/
	;

charset :
	CHARSET_SYM maybe_space STRING maybe_space ';'
	//| CHARSET_SYM error /*10N*/ invalid_block
	//| CHARSET_SYM error /*10N*/ ';'
	;

ignored_charset :
	CHARSET_SYM maybe_space STRING maybe_space ';'
	| CHARSET_SYM maybe_space ';'
	;

rule_list :
	/*empty*/
	| rule_list rule maybe_sgml
	;

valid_rule :
	ruleset
	| font_face
	;

rule :
	valid_rule
	| ignored_charset
	//| invalid_rule
	;

font_face :
	FONT_FACE_SYM maybe_space '{' maybe_space declaration_list closing_brace
	//| FONT_FACE_SYM error /*10N*/ invalid_block
	//| FONT_FACE_SYM error /*10N*/ ';'
	;

combinator :
	'+' maybe_space
	| '~' maybe_space
	| '>' maybe_space
	;

maybe_unary_operator :
	unary_operator
	| /*empty*/
	;

unary_operator :
	'-'
	| '+'
	;

ruleset :
	selector_list '{' maybe_space declaration_list closing_brace
	;

selector_list :
	selector %prec UNIMPORTANT_TOK /*2L*/
	| selector_list ',' maybe_space selector %prec UNIMPORTANT_TOK /*2L*/
	//| selector_list error /*10N*/
	;

selector_with_trailing_whitespace :
	selector WHITESPACE
	;

selector :
	simple_selector
	| selector_with_trailing_whitespace
	| selector_with_trailing_whitespace simple_selector
	| selector combinator simple_selector
	//| selector error /*10N*/
	;

simple_selector :
	element_name
	| element_name specifier_list
	| specifier_list
	;

element_name :
	IDENT /*3R*/
	| '*' /*9N*/
	;

specifier_list :
	specifier
	| specifier_list specifier
	//| specifier_list error /*10N*/
	;

specifier :
	IDSEL /*4N*/
	| HASH /*5N*/
	| class
	| attrib
	| pseudo
	;

class :
	'.' /*7N*/ IDENT /*3R*/
	;

attr_name :
	IDENT /*3R*/ maybe_space
	;

attrib :
	'[' /*8N*/ maybe_space attr_name ']'
	| '[' /*8N*/ maybe_space attr_name match maybe_space ident_or_string maybe_space ']'
	;

match :
	'='
	| INCLUDES
	| DASHMATCH
	| BEGINSWITH
	| ENDSWITH
	| CONTAINS
	;

ident_or_string :
	IDENT /*3R*/
	| STRING
	;

pseudo :
	':' /*6N*/ IDENT /*3R*/
	| ':' /*6N*/ ':' /*6N*/ IDENT /*3R*/
	| ':' /*6N*/ FUNCTION maybe_space maybe_unary_operator NUMBER maybe_space ')'
	| ':' /*6N*/ ':' /*6N*/ FUNCTION maybe_space selector maybe_space ')'
	| ':' /*6N*/ FUNCTION maybe_space IDENT /*3R*/ maybe_space ')'
	;

declaration_list :
	declaration
	| decl_list declaration
	| decl_list
	//| error /*10N*/ invalid_block_list error /*10N*/
	//| error /*10N*/
	//| decl_list error /*10N*/
	//| decl_list invalid_block_list
	;

decl_list :
	declaration ';' maybe_space
	//| declaration invalid_block_list maybe_space
	//| declaration invalid_block_list ';' maybe_space
	//| error /*10N*/ ';' maybe_space
	//| error /*10N*/ invalid_block_list error /*10N*/ ';' maybe_space
	| decl_list declaration ';' maybe_space
	//| decl_list error /*10N*/ ';' maybe_space
	//| decl_list error /*10N*/ invalid_block_list error /*10N*/ ';' maybe_space
	;

declaration :
	property ':' /*6N*/ maybe_space expr prio
	//| property error /*10N*/
	//| property ':' /*6N*/ maybe_space error /*10N*/ expr prio
	//| property ':' /*6N*/ maybe_space expr prio error /*10N*/
	| IMPORTANT_SYM maybe_space
	| property ':' /*6N*/ maybe_space
	//| property ':' /*6N*/ maybe_space error /*10N*/
	//| property invalid_block
	;

property :
	IDENT /*3R*/ maybe_space
	;

prio :
	IMPORTANT_SYM maybe_space
	| /*empty*/
	;

expr :
	term
	| expr operator term
	//| expr invalid_block_list
	//| expr invalid_block_list error /*10N*/
	//| expr error /*10N*/
	;

operator :
	'/' maybe_space
	| ',' maybe_space
	| /*empty*/
	;

term :
	unary_term
	| unary_operator unary_term
	| STRING maybe_space
	| IDENT /*3R*/ maybe_space
	| DIMEN maybe_space
	| unary_operator DIMEN maybe_space
	| URI maybe_space
	| UNICODERANGE maybe_space
	| IDSEL /*4N*/ maybe_space
	| HASH /*5N*/ maybe_space
	| '#' maybe_space
	| function
	| '%' maybe_space
	;

unary_term :
	NUMBER maybe_space
	| PERCENTAGE maybe_space
	| LENGTH maybe_space
	| ANGLE maybe_space
	| TIME maybe_space
	| FREQ maybe_space
	;

function :
	FUNCTION maybe_space expr ')' maybe_space
	| FUNCTION maybe_space expr //TOKEN_EOF
	| FUNCTION maybe_space ')' maybe_space
	//| FUNCTION maybe_space error /*10N*/
	;

//invalid_rule :
//	error /*10N*/ invalid_block
//	;

//invalid_block :
//	'{' error /*10N*/ invalid_block_list error /*10N*/ closing_brace
//	| '{' error /*10N*/ closing_brace
//	;

//invalid_block_list :
//	invalid_block
//	| invalid_block_list error /*10N*/ invalid_block
//	;

%%

w		[ \t\r\n\f]*
nl		\n|\r\n|\r|\f
h		[0-9a-fA-F]
nonascii	(?-i:[\200-\377])
unicode		\\{h}{1,6}[ \t\r\n\f]?
escape		(?-i:{unicode}|\\[ -~\200-\377])
nmstart		[a-z]|{nonascii}|{escape}
nmchar		[a-z0-9-]|{nonascii}|{escape}
string1		\"([\t !#$%&(-~]|\\{nl}|\'|{nonascii}|{escape})*\"
string2		\'([\t !#$%&(-~]|\\{nl}|\"|{nonascii}|{escape})*\'

ident		[-]?{nmstart}{nmchar}*
name		{nmchar}+
num		[0-9]+|[0-9]*"."[0-9]+
string		{string1}|{string2}
url		([!#$%&*-~]|{nonascii}|{escape})*
range		\?{1,6}|{h}(\?{0,5}|{h}(\?{0,4}|{h}(\?{0,3}|{h}(\?{0,2}|{h}(\??|{h})))))

%%

[ \t\r\n\f]+		 WHITESPACE

\/\*[^*]*\*+([^/][^*]*\*+)*\/	skip() /* ignore comments */

//"<!--"			 CDO
//"-->"			 CDC
"~="			 INCLUDES
"|="			 DASHMATCH
"^="			 BEGINSWITH
"$="			 ENDSWITH
"*="			 CONTAINS

{string}		 STRING

"@font-face"		 FONT_FACE_SYM

"!{w}important"		 IMPORTANT_SYM

{num}em			 LENGTH
{num}ex			 LENGTH
{num}px			 LENGTH
{num}cm			 LENGTH
{num}mm			 LENGTH
{num}in			 LENGTH
{num}pt			 LENGTH
{num}pc			 LENGTH
{num}deg		ANGLE
{num}rad		 ANGLE
{num}grad		 ANGLE
{num}ms			 TIME
{num}s			 TIME
{num}Hz			 FREQ
{num}kHz		 FREQ
{num}{ident}	 DIMEN
{num}%			 PERCENTAGE
{num}			 NUMBER

"~"	'~'
"="	'='
">"	'>'
"-"	'-'
","	','
";"	';'
":"	':'
"/"	'/'
"."	'.'
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"*"	'*'
"#"	'#'
"%"	'%'
"+"	'+'

"@charset"	CHARSET_SYM
SGML_CD	SGML_CD

"url("{w}{string}{w}")"	 URI
"url("{w}{url}{w}")"	 URI
{ident}"("		 FUNCTION
"#"{ident}       IDSEL
"#"{name}        HASH

U\+{range}		 UNICODERANGE
U\+{h}{1,6}-{h}{1,6}	 UNICODERANGE

{ident}			 IDENT

//.			 *yytext

%%
