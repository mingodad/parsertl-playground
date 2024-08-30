/*
 *  Copyright (C) 2002-2003 Lars Knoll (knoll@kde.org)
 *  Copyright (C) 2004, 2005, 2006, 2007, 2008, 2009, 2010 Apple Inc. All rights reserved.
 *  Copyright (C) 2006 Alexey Proskuryakov (ap@nypop.com)
 *  Copyright (C) 2008 Eric Seidel <eric@webkit.org>
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
%token ANYFUNCTION
//%token ATKEYWORD
%token BEGINSWITH
%token BOTTOMCENTER_SYM
%token BOTTOMLEFTCORNER_SYM
%token BOTTOMLEFT_SYM
%token BOTTOMRIGHTCORNER_SYM
%token BOTTOMRIGHT_SYM
%token CALCFUNCTION
%token CHARSET_SYM
%token CMS
%token CONTAINS
%token DASHMATCH
%token DEGS
%token DIMEN
%token EMS
%token ENDSWITH
%token EXS
%token FLOATTOKEN
%token FONT_FACE_SYM
%token FUNCTION
%token GRADS
%token HERTZ
%token HEX
%token IDENT
%token IDSEL
%token IMPORTANT_SYM
%token IMPORT_SYM
%token INCLUDES
%token INS
%token INTEGER
//%token INVALIDDIMEN
%token KHERTZ
%token LEFTBOTTOM_SYM
%token LEFTMIDDLE_SYM
%token LEFTTOP_SYM
%token MAXFUNCTION
%token MEDIA_AND
%token MEDIA_NOT
%token MEDIA_ONLY
%token MEDIA_SYM
%token MINFUNCTION
%token MMS
%token MSECS
%token NAMESPACE_SYM
%token NOTFUNCTION
%token NTH
%token PAGE_SYM
%token PCS
%token PERCENTAGE
%token PTS
%token PXS
%token QEMS
%token RADS
%token REMS
%token RIGHTBOTTOM_SYM
%token RIGHTMIDDLE_SYM
%token RIGHTTOP_SYM
%token SECS
%token SGML_CD
%token STRING
//%token TOKEN_EOF
%token TOPCENTER_SYM
%token TOPLEFTCORNER_SYM
%token TOPLEFT_SYM
%token TOPRIGHTCORNER_SYM
%token TOPRIGHT_SYM
%token TURNS
%token UNICODERANGE
%token URI
%token WEBKIT_DECLS_SYM
%token WEBKIT_KEYFRAME_RULE_SYM
%token WEBKIT_KEYFRAMES_SYM
%token WEBKIT_MEDIAQUERY_SYM
%token WEBKIT_RULE_SYM
%token WEBKIT_SELECTOR_SYM
%token WEBKIT_VALUE_SYM
//%token WHITESPACE

//%nonassoc /*1*/ LOWEST_PREC
%right /*3*/ IDENT
%nonassoc /*4*/ HEX
%nonassoc /*5*/ IDSEL
%nonassoc /*6*/ ':'
%nonassoc /*7*/ '.'
%nonassoc /*8*/ '['
%nonassoc /*9*/ '*'
%left /*11*/ '|'

%start stylesheet

%%

stylesheet :
	 maybe_charset maybe_sgml rule_list
	| webkit_rule
	| webkit_decls
	| webkit_value
	| webkit_mediaquery
	| webkit_selector
	| webkit_keyframe_rule
	;

webkit_rule :
	WEBKIT_RULE_SYM '{'  valid_rule  '}'
	;

webkit_keyframe_rule :
	WEBKIT_KEYFRAME_RULE_SYM '{'  keyframe_rule  '}'
	;

webkit_decls :
	WEBKIT_DECLS_SYM '{'  declaration_list '}'
	;

webkit_value :
	WEBKIT_VALUE_SYM '{'  expr '}'
	;

webkit_mediaquery :
	WEBKIT_MEDIAQUERY_SYM   media_query '}'
	;

webkit_selector :
	WEBKIT_SELECTOR_SYM '{'  selector_list '}'
	;

maybe_sgml :
	/*empty*/
	| maybe_sgml SGML_CD
	;

maybe_charset :
	/*empty*/
	| charset
	;

charset :
	CHARSET_SYM  STRING  ';'
	//| CHARSET_SYM error /*10N*/ invalid_block
	//| CHARSET_SYM error /*10N*/ ';'
	;

ignored_charset :
	CHARSET_SYM  STRING  ';'
	;

rule_list :
	/*empty*/
	| rule_list rule maybe_sgml
	;

valid_rule :
	 ruleset
	| media
	| page
	| font_face
	| keyframes
	| namespace
	| import
	;

rule :
	valid_rule
	| ignored_charset
	//| invalid_rule
	//| invalid_at
	;

block_rule_list :
	/*empty*/
	| block_rule_list block_rule maybe_sgml
	;

block_valid_rule :
	ruleset
	| page
	| font_face
	| keyframes
	;

block_rule :
	block_valid_rule
	//| invalid_rule
	//| invalid_at
	| namespace
	| import
	| media
	;

import :
	IMPORT_SYM  string_or_uri  maybe_media_list ';'
	//| IMPORT_SYM  string_or_uri  maybe_media_list invalid_block
	//| IMPORT_SYM error /*10N*/ ';'
	//| IMPORT_SYM error /*10N*/ invalid_block
	;

namespace :
	NAMESPACE_SYM  maybe_ns_prefix string_or_uri  ';'
	//| NAMESPACE_SYM  maybe_ns_prefix string_or_uri  invalid_block
	//| NAMESPACE_SYM error /*10N*/ invalid_block
	//| NAMESPACE_SYM error /*10N*/ ';'
	;

maybe_ns_prefix :
	/*empty*/
	| IDENT /*3R*/
	;

string_or_uri :
	STRING
	| URI
	;

media_feature :
	IDENT /*3R*/
	;

maybe_media_value :
	/*empty*/
	| ':' /*6N*/  expr
	;

media_query_exp :
	'('  media_feature  maybe_media_value ')'
	;

media_query_exp_list :
	media_query_exp
	| media_query_exp_list  MEDIA_AND  media_query_exp
	;

maybe_and_media_query_exp_list :
	/*empty*/
	| MEDIA_AND  media_query_exp_list
	;

maybe_media_restrictor :
	/*empty*/
	| MEDIA_ONLY
	| MEDIA_NOT
	;

media_query :
	media_query_exp_list
	| maybe_media_restrictor  medium maybe_and_media_query_exp_list
	;

maybe_media_list :
	/*empty*/
	| media_list
	;

media_list :
	media_query
	| media_list ','  media_query
	//| media_list error /*10N*/
	;

media :
	MEDIA_SYM  media_list '{'  block_rule_list '}'
	| MEDIA_SYM  '{'  block_rule_list '}'
	;

medium :
	IDENT /*3R*/
	;

keyframes :
	WEBKIT_KEYFRAMES_SYM  keyframe_name  '{'  keyframes_rule '}'
	;

keyframe_name :
	IDENT /*3R*/
	| STRING
	;

keyframes_rule :
	/*empty*/
	| keyframes_rule keyframe_rule
	;

keyframe_rule :
	key_list  '{'  declaration_list '}'
	;

key_list :
	key
	| key_list  ','  key
	;

key :
	PERCENTAGE
	| IDENT /*3R*/
	;

page :
	PAGE_SYM  page_selector  '{'  declarations_and_margins '}'
	//| PAGE_SYM error /*10N*/ invalid_block
	//| PAGE_SYM error /*10N*/ ';'
	;

page_selector :
	IDENT /*3R*/
	| IDENT /*3R*/ pseudo_page
	| pseudo_page
	| /*empty*/
	;

declarations_and_margins :
	declaration_list
	| declarations_and_margins margin_box  declaration_list
	;

margin_box :
	margin_sym  '{'  declaration_list '}'
	;

margin_sym :
	TOPLEFTCORNER_SYM
	| TOPLEFT_SYM
	| TOPCENTER_SYM
	| TOPRIGHT_SYM
	| TOPRIGHTCORNER_SYM
	| BOTTOMLEFTCORNER_SYM
	| BOTTOMLEFT_SYM
	| BOTTOMCENTER_SYM
	| BOTTOMRIGHT_SYM
	| BOTTOMRIGHTCORNER_SYM
	| LEFTTOP_SYM
	| LEFTMIDDLE_SYM
	| LEFTBOTTOM_SYM
	| RIGHTTOP_SYM
	| RIGHTMIDDLE_SYM
	| RIGHTBOTTOM_SYM
	;

font_face :
	FONT_FACE_SYM  '{'  declaration_list '}'
	//| FONT_FACE_SYM error /*10N*/ invalid_block
	//| FONT_FACE_SYM error /*10N*/ ';'
	;

combinator :
	'+'
	| '~'
	| '>'
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
	selector_list '{'  '}'
	| selector_list '{'  declaration_list '}'
	;

selector_list :
	selector
	| selector_list ','  selector
	//| selector_list error /*10N*/
	;

selector :
	simple_selector
	| selector simple_selector
	| selector combinator simple_selector
	//| selector error /*10N*/
	;

namespace_selector :
	'|' /*11L*/
	| '*' /*9N*/ '|' /*11L*/
	| IDENT /*3R*/ '|' /*11L*/
	;

simple_selector :
	element_name
	| element_name specifier_list
	| specifier_list
	| namespace_selector element_name
	| namespace_selector element_name specifier_list
	| namespace_selector specifier_list
	;

simple_selector_list :
	simple_selector
	| simple_selector_list  ','  simple_selector
	//| simple_selector_list error /*10N*/
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
	IDSEL /*5N*/
	| HEX /*4N*/
	| class
	| attrib
	| pseudo
	;

class :
	'.' /*7N*/ IDENT /*3R*/
	;

attr_name :
	IDENT /*3R*/
	;

attrib :
	'[' /*8N*/  attr_name ']'
	| '[' /*8N*/  attr_name match  ident_or_string  ']'
	| '[' /*8N*/  namespace_selector attr_name ']'
	| '[' /*8N*/  namespace_selector attr_name match  ident_or_string  ']'
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

pseudo_page :
	':' /*6N*/ IDENT /*3R*/
	;

pseudo :
	':' /*6N*/ IDENT /*3R*/
	| "::" IDENT /*3R*/
	| ':' /*6N*/ ANYFUNCTION  simple_selector_list  ')'
	| ':' /*6N*/ FUNCTION  NTH  ')'
	| ':' /*6N*/ FUNCTION  maybe_unary_operator INTEGER  ')'
	| ':' /*6N*/ FUNCTION  IDENT /*3R*/  ')'
	| ':' /*6N*/ NOTFUNCTION  simple_selector  ')'
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
	declaration ';'
	//| declaration invalid_block_list
	//| declaration invalid_block_list ';'
	//| error /*10N*/ ';'
	//| error /*10N*/ invalid_block_list error /*10N*/ ';'
	| decl_list declaration ';'
	//| decl_list error /*10N*/ ';'
	//| decl_list error /*10N*/ invalid_block_list error /*10N*/ ';'
	;

declaration :
	property ':' /*6N*/  expr prio
	//| property error /*10N*/
	//| property ':' /*6N*/  error /*10N*/ expr prio
	//| property ':' /*6N*/  expr prio error /*10N*/
	| IMPORTANT_SYM
	| property ':' /*6N*/
	//| property ':' /*6N*/  error /*10N*/
	//| property invalid_block
	;

property :
	IDENT /*3R*/
	;

prio :
	IMPORTANT_SYM
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
	'/'
	| ','
	| '='
	| /*empty*/
	;

term :
	unary_term
	| unary_operator unary_term
	| STRING
	| IDENT /*3R*/
	| NTH
	| DIMEN
	| unary_operator DIMEN
	| URI
	| UNICODERANGE
	| HEX /*4N*/
	| '#'
	| function
	| calc_function
	| min_or_max_function
	| '%'
	;

unary_term :
	INTEGER
	| FLOATTOKEN
	| PERCENTAGE
	| PXS
	| CMS
	| MMS
	| INS
	| PTS
	| PCS
	| DEGS
	| RADS
	| GRADS
	| TURNS
	| MSECS
	| SECS
	| HERTZ
	| KHERTZ
	| EMS
	| QEMS
	| EXS
	| REMS
	;

function :
	FUNCTION  expr ')'
	//| FUNCTION  error /*10N*/
	;

calc_func_term :
	unary_term
	| unary_operator unary_term
	;

calc_func_operator :
	'+'
	| '-'
	| '*' /*9N*/
	| '/'
	| IDENT /*3R*/
	;

calc_func_paren_expr :
	'('  calc_func_expr  ')'
	;

calc_func_expr :
	calc_func_term
	| calc_func_expr calc_func_operator calc_func_term
	| calc_func_expr calc_func_operator calc_func_paren_expr
	| calc_func_paren_expr
	//| calc_func_expr error /*10N*/
	;

calc_func_expr_list :
	calc_func_expr
	| calc_func_expr_list ','  calc_func_expr
	;

calc_function :
	CALCFUNCTION  calc_func_expr ')'
	//| CALCFUNCTION  error /*10N*/
	;

min_or_max :
	MINFUNCTION
	| MAXFUNCTION
	;

min_or_max_function :
	min_or_max  calc_func_expr_list ')'
	//| min_or_max  error /*10N*/
	;

//invalid_at :
//	ATKEYWORD error /*10N*/ invalid_block
//	| ATKEYWORD error /*10N*/ ';'
//	;
//
//invalid_rule :
//	error /*10N*/ invalid_block
//	;
//
//invalid_block :
//	'{' error /*10N*/ invalid_block_list error /*10N*/ closing_brace
//	| '{' error /*10N*/ closing_brace
//	;
//
//invalid_block_list :
//	invalid_block
//	| invalid_block_list error /*10N*/ invalid_block
//	;

%%

%x mediaquery
//%x forkeyword

w               [ \t\r\n\f]
nl              \n|\r\n|\r|\f
h               [0-9a-fA-F]
nonascii        [\200-\377]
unicode         \\{h}{1,6}[ \t\r\n\f]?
escape          {unicode}|\\[ -~\200-\377]
nmstart         [_a-zA-Z]|{nonascii}|{escape}
nmchar          [_a-zA-Z0-9-]|{nonascii}|{escape}
string1         \"([\t !#$%&(-~]|\\{nl}|\'|{nonascii}|{escape})*\"
string2         \'([\t !#$%&(-~]|\\{nl}|\"|{nonascii}|{escape})*\'

ident           -*{nmstart}{nmchar}*
intnum          [0-9]+
num             {intnum}|[0-9]*"."{intnum}
string          {string1}|{string2}
url             ([!#$%&*-~]|{nonascii}|{escape})
range           \?{1,6}|{h}(\?{0,5}|{h}(\?{0,4}|{h}(\?{0,3}|{h}(\?{0,2}|{h}(\??|{h})))))
nth             [\+-]?{intnum}?n([\t\r\n ]*[\+-][\t\r\n ]*{intnum})?

%%

<*> {
"/*"(?s:.)*?"*/"	skip() /* ignore comments */

[ \t\r\n\f]+            skip() //WHITESPACE

":"	':'
"::"	"::"
"."	'.'
"["	'['
"*"	'*'
"|"	'|'
"}"	'}'
"("	'('
")"	')'
","	','
"+"	'+'
"~"	'~'
">"	'>'
"-"	'-'
"]"	']'
"="	'='
"/"	'/'
"#"	'#'
"%"	'%'

"<!--"                  SGML_CD
"-->"                   SGML_CD
"~="                    INCLUDES
"|="                    DASHMATCH
"^="                    BEGINSWITH
"$="                    ENDSWITH
"*="                    CONTAINS
}
<mediaquery>"not"       MEDIA_NOT
<mediaquery>"only"      MEDIA_ONLY
<mediaquery>"and"       MEDIA_AND
<*> {
"@import"<mediaquery>          IMPORT_SYM
"@page"                 PAGE_SYM
"@top-left-corner"      TOPLEFTCORNER_SYM
"@top-left"             TOPLEFT_SYM
"@top-center"           TOPCENTER_SYM
"@top-right"            TOPRIGHT_SYM
"@top-right-corner"     TOPRIGHTCORNER_SYM
"@bottom-left-corner"   BOTTOMLEFTCORNER_SYM
"@bottom-left"          BOTTOMLEFT_SYM
"@bottom-center"        BOTTOMCENTER_SYM
"@bottom-right"         BOTTOMRIGHT_SYM
"@bottom-right-corner"  BOTTOMRIGHTCORNER_SYM
"@left-top"             LEFTTOP_SYM
"@left-middle"          LEFTMIDDLE_SYM
"@left-bottom"          LEFTBOTTOM_SYM
"@right-top"            RIGHTTOP_SYM
"@right-middle"         RIGHTMIDDLE_SYM
"@right-bottom"         RIGHTBOTTOM_SYM
"@media"<mediaquery>    MEDIA_SYM
"@font-face"            FONT_FACE_SYM
"@charset"              CHARSET_SYM
"@namespace"            NAMESPACE_SYM
"@-webkit-rule"         WEBKIT_RULE_SYM
"@-webkit-decls"        WEBKIT_DECLS_SYM
"@-webkit-value"        WEBKIT_VALUE_SYM
"@-webkit-mediaquery"<mediaquery>   WEBKIT_MEDIAQUERY_SYM
"@-webkit-selector"     WEBKIT_SELECTOR_SYM
"@-webkit-keyframes"|"@keyframes"    WEBKIT_KEYFRAMES_SYM
"@-webkit-keyframe-rule" WEBKIT_KEYFRAME_RULE_SYM

//"@"{ident}              ATKEYWORD

"!"{w}*"important"       IMPORTANT_SYM

{num}em                 EMS
{num}rem                REMS
{num}__qem              QEMS /* quirky ems */
{num}ex                 EXS
{num}px                 PXS
{num}cm                 CMS
{num}mm                 MMS
{num}in                 INS
{num}pt                 PTS
{num}pc                 PCS
{num}deg                DEGS
{num}rad                RADS
{num}grad               GRADS
{num}turn               TURNS
{num}ms                 MSECS
{num}s                  SECS
{num}Hz                 HERTZ
{num}kHz                KHERTZ
{num}%+                 PERCENTAGE
{intnum}                INTEGER
{num}                   FLOATTOKEN

"-webkit-any("          ANYFUNCTION
"not("                  NOTFUNCTION
"url("{w}*{string}{w}*")" URI
"url("{w}*{url}+{w}*")"    URI
"-webkit-calc("         CALCFUNCTION
"-webkit-min("          MINFUNCTION
"-webkit-max("          MAXFUNCTION
{ident}"("              FUNCTION

U\+{range}              UNICODERANGE
U\+{h}{1,6}-{h}{1,6}    UNICODERANGE
}
<INITIAL,mediaquery>"{"<INITIAL>        '{'
<INITIAL,mediaquery>";"<INITIAL>	';'
<*> {
"#"{h}+                 HEX
"#"{ident}              IDSEL

{string}                STRING
{ident}                 IDENT
{nth}                   NTH
//{num}{ident}\+          INVALIDDIMEN
{num}{ident}            DIMEN
}

%%
