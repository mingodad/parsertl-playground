//From: https://github.com/swftools/swftools/blob/c6a18ab0658286f98d6ed2b3d0419058e86a14a0/lib/as3/parser.y
/* parser.y

   Routines for compiling Flash2 AVM2 ABC Actionscript

   Extension module for the rfxswf library.
   Part of the swftools package.

   Copyright (c) 2008 Matthias Kramm <kramm@quiss.org>

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA */

/*Tokens*/
%token KW_ARGUMENTS
%token KW_AS
//%token KW_BOOLEAN
%token KW_BREAK
%token KW_CASE
%token KW_CATCH
%token KW_CLASS
%token KW_CONST
%token KW_CONTINUE
%token KW_DEFAULT
%token KW_DEFAULT_XML
%token KW_DELETE
%token KW_DYNAMIC
%token KW_EACH
%token KW_ELSE
%token KW_EXTENDS
%token KW_FALSE
%token KW_FINAL
%token KW_FINALLY
%token KW_FUNCTION
%token KW_GET
%token KW_IF
%token KW_IMPLEMENTS
%token KW_IMPORT
%token KW_IN
%token KW_INSTANCEOF
//%token KW_INT
%token KW_INTERFACE
%token KW_INTERNAL
%token KW_IS
%token KW_NAMESPACE
%token KW_NAN
%token KW_NATIVE
%token KW_NEW
%token KW_NULL
//%token KW_NUMBER
%token KW_OVERRIDE
%token KW_PACKAGE
%token KW_PRIVATE
%token KW_PROTECTED
%token KW_PUBLIC
%token KW_RETURN
%token KW_SET
%token KW_STATIC
//%token KW_STRING
%token KW_SUPER
%token KW_THROW
%token KW_TRUE
%token KW_TRY
%token KW_TYPEOF
//%token KW_UINT
%token KW_UNDEFINED
%token KW_USE
%token KW_VAR
%token KW_VOID
%token KW_WITH
%token new2
%token T_ANDAND
%token T_ANDBY
%token T_COLONCOLON
//%token T_DICTSTART
%token T_DIVBY
%token T_DO
%token T_DOTDOT
%token T_DOTDOTDOT
//%token T_EMPTY
%token T_EQEQ
%token T_EQEQEQ
%token T_FLOAT
%token T_FOR
%token T_GE
%token T_IDENTIFIER
%token T_INT
%token T_LE
%token T_MINUSBY
%token T_MINUSMINUS
%token T_MODBY
%token T_MULBY
%token T_NE
%token T_NEE
%token T_ORBY
%token T_OROR
%token T_PLUSBY
%token T_PLUSPLUS
%token T_REGEXP
%token T_SHL
%token T_SHLBY
%token T_SHR
%token T_SHRBY
%token T_STRING
%token T_SWITCH
%token T_UINT
%token T_USHR
%token T_USHRBY
%token T_WHILE
%token T_XORBY

%left /*1*/ prec_none
//%left /*2*/ prec_var_read
%left /*3*/ below_semicolon
%left /*4*/ ';'
%left /*5*/ ','
%nonassoc /*6*/ below_assignment
%right /*7*/ T_ORBY T_DIVBY T_MODBY T_MULBY T_ANDBY T_PLUSBY T_MINUSBY T_XORBY T_SHRBY T_SHLBY T_USHRBY '='
%right /*8*/ '?' ':'
%left /*9*/ T_OROR
%left /*10*/ T_ANDAND
%left /*11*/ '|'
%left /*12*/ '^'
%nonassoc /*13*/ '&'
%nonassoc /*14*/ T_EQEQ T_EQEQEQ T_NE T_NEE
%nonassoc /*15*/ KW_IS KW_IN KW_AS
%left /*16*/ below_lt
%nonassoc /*17*/ KW_INSTANCEOF T_LE T_GE '<' '>'
%left /*18*/ T_SHL T_USHR T_SHR
%left /*19*/ below_minus
%left /*20*/ '-' '+'
%left /*21*/ '/' '*' '%'
%left /*22*/ KW_VOID KW_TYPEOF KW_DELETE plusplus_prefix minusminus_prefix '~' '!'
%left /*23*/ T_MINUSMINUS T_PLUSPLUS
//%nonassoc /*24*/ below_curly
%left /*25*/ '('
%left /*26*/ new2
%left /*27*/ KW_NEW T_DOTDOT T_COLONCOLON '[' ']' '{' '.' '@' //T_DICTSTART
//%left /*28*/ below_identifier
%left /*29*/ T_IDENTIFIER KW_ARGUMENTS
//%left /*30*/ above_identifier
%left /*31*/ below_else
%nonassoc /*32*/ KW_ELSE
%nonassoc /*33*/ T_STRING T_REGEXP
%nonassoc /*34*/ T_INT T_UINT T_FLOAT KW_NAN
%nonassoc /*35*/ KW_FUNCTION KW_UNDEFINED KW_NULL KW_SUPER KW_FALSE KW_TRUE
%left /*36*/ above_function

%start PROGRAM

%%

PROGRAM :
	MAYBE_PROGRAM_CODE_LIST
	;

MAYBE_PROGRAM_CODE_LIST :
	/*empty*/
	| PROGRAM_CODE_LIST
	;

PROGRAM_CODE_LIST :
	PROGRAM_CODE
	| PROGRAM_CODE_LIST PROGRAM_CODE
	;

PROGRAM_CODE :
	PACKAGE_DECLARATION
	| INTERFACE_DECLARATION
	| CLASS_DECLARATION
	| FUNCTION_DECLARATION
	| SLOT_DECLARATION
	| PACKAGE_INITCODE
	| ';' /*4L*/
	;

MAYBE_INPACKAGE_CODE_LIST :
	/*empty*/
	| INPACKAGE_CODE_LIST
	;

INPACKAGE_CODE_LIST :
	INPACKAGE_CODE
	| INPACKAGE_CODE_LIST INPACKAGE_CODE
	;

INPACKAGE_CODE :
	INTERFACE_DECLARATION
	| CLASS_DECLARATION
	| FUNCTION_DECLARATION
	| SLOT_DECLARATION
	| PACKAGE_INITCODE
	| '[' /*27L*/ EMBED_START E ']' /*27L*/
	| ';' /*4L*/
	;

MAYBECODE :
	CODE
	| /*empty*/
	;

CODE :
	CODE CODEPIECE
	| CODEPIECE
	;

CODE_STATEMENT :
	DEFAULT_NAMESPACE
	| IMPORT
	| FOR
	| FOR_IN
	| WHILE
	| DO_WHILE
	| SWITCH
	| IF
	| WITH
	| TRY
	| VOIDEXPRESSION
	| USE_NAMESPACE
	| NAMESPACE_DECLARATION
	| '{' /*27L*/ CODE '}'
	| '{' /*27L*/ '}'
	;

CODEPIECE :
	';' /*4L*/
	| CODE_STATEMENT
	| VARIABLE_DECLARATION
	| BREAK
	| CONTINUE
	| RETURN
	| THROW
	;

CODEBLOCK :
	CODEPIECE ';' /*4L*/
	| CODEPIECE %prec below_semicolon /*3L*/
	;

PACKAGE_INITCODE :
	CODE_STATEMENT
	;

EMBED_START :
	%prec above_function /*36L*/ /*empty*/
	;

MAYBEEXPRESSION :
	'=' /*7R*/ E
	| /*empty*/
	;

VARIABLE_DECLARATION :
	KW_VAR VARIABLE_LIST
	| KW_CONST VARIABLE_LIST
	;

VARIABLE_LIST :
	ONE_VARIABLE
	| VARIABLE_LIST ',' /*5L*/ ONE_VARIABLE
	;

ONE_VARIABLE :
	T_IDENTIFIER /*29L*/ MAYBETYPE MAYBEEXPRESSION
	;

IF_CODEBLOCK :
	CODEBLOCK
	;

MAYBEELSE :
	%prec below_else /*31L*/ /*empty*/
	| KW_ELSE /*32N*/ IF_CODEBLOCK
	;

IF :
	KW_IF '(' /*25L*/ EXPRESSION ')' IF_CODEBLOCK MAYBEELSE
	;

FOR_INIT :
	/*empty*/
	| VARIABLE_DECLARATION
	| VOIDEXPRESSION
	;

FOR_IN_INIT :
	KW_VAR T_IDENTIFIER /*29L*/ MAYBETYPE
	| T_IDENTIFIER /*29L*/
	;

FOR_START :
	T_FOR '(' /*25L*/
	| T_FOR KW_EACH '(' /*25L*/
	;

FOR :
	FOR_START FOR_INIT ';' /*4L*/ EXPRESSION ';' /*4L*/ VOIDEXPRESSION ')' IF_CODEBLOCK
	;

FOR_IN :
	FOR_START FOR_IN_INIT KW_IN /*15N*/ EXPRESSION ')' IF_CODEBLOCK
	;

WHILE :
	T_WHILE '(' /*25L*/ EXPRESSION ')' IF_CODEBLOCK
	;

DO_WHILE :
	T_DO IF_CODEBLOCK T_WHILE '(' /*25L*/ EXPRESSION ')'
	;

BREAK :
	KW_BREAK %prec prec_none /*1L*/
	| KW_BREAK T_IDENTIFIER /*29L*/
	;

CONTINUE :
	KW_CONTINUE %prec prec_none /*1L*/
	| KW_CONTINUE T_IDENTIFIER /*29L*/
	;

MAYBE_CASE_LIST :
	/*empty*/
	| CASE_LIST
	| DEFAULT
	| CASE_LIST DEFAULT
	;

CASE_LIST :
	CASE
	| CASE_LIST CASE
	;

CASE :
	KW_CASE E ':' /*8R*/ MAYBECODE
	;

DEFAULT :
	KW_DEFAULT ':' /*8R*/ MAYBECODE
	;

SWITCH :
	T_SWITCH '(' /*25L*/ E ')' '{' /*27L*/ MAYBE_CASE_LIST '}'
	;

CATCH :
	KW_CATCH '(' /*25L*/ T_IDENTIFIER /*29L*/ MAYBETYPE ')' '{' /*27L*/ MAYBECODE '}'
	;

FINALLY :
	KW_FINALLY '{' /*27L*/ MAYBECODE '}'
	;

CATCH_LIST :
	CATCH
	| CATCH_LIST CATCH
	;

CATCH_FINALLY_LIST :
	CATCH_LIST
	| CATCH_LIST FINALLY
	| FINALLY
	;

TRY :
	KW_TRY '{' /*27L*/ MAYBECODE '}' CATCH_FINALLY_LIST
	;

THROW :
	KW_THROW EXPRESSION
	| KW_THROW
	;

WITH_HEAD :
	KW_WITH '(' /*25L*/ EXPRESSION ')'
	;

WITH :
	WITH_HEAD CODEBLOCK
	;

X_IDENTIFIER :
	T_IDENTIFIER /*29L*/
	| KW_PACKAGE
	| KW_NAMESPACE
	| KW_NAN /*34N*/
	;

PACKAGE :
	PACKAGE '.' /*27L*/ X_IDENTIFIER
	| X_IDENTIFIER
	;

PACKAGE_DECLARATION :
	KW_PACKAGE PACKAGE '{' /*27L*/ MAYBE_INPACKAGE_CODE_LIST '}'
	| KW_PACKAGE '{' /*27L*/ MAYBE_INPACKAGE_CODE_LIST '}'
	;

IMPORT :
	KW_IMPORT T_IDENTIFIER /*29L*/
	| KW_IMPORT PACKAGEANDCLASS
	| KW_IMPORT PACKAGE '.' /*27L*/ '*' /*21L*/
	;

MAYBE_MODIFIERS :
	%prec above_function /*36L*/ /*empty*/
	| MODIFIER_LIST
	;

MODIFIER_LIST :
	MODIFIER
	| MODIFIER_LIST MODIFIER
	;

MODIFIER :
	KW_PUBLIC
	| KW_PRIVATE
	| KW_PROTECTED
	| KW_STATIC
	| KW_DYNAMIC
	| KW_FINAL
	| KW_OVERRIDE
	| KW_NATIVE
	| KW_INTERNAL
	;

EXTENDS :
	/*empty*/
	| KW_EXTENDS CLASS_SPEC
	;

EXTENDS_LIST :
	/*empty*/
	| KW_EXTENDS CLASS_SPEC_LIST
	;

IMPLEMENTS_LIST :
	/*empty*/
	| KW_IMPLEMENTS CLASS_SPEC_LIST
	;

CLASS_DECLARATION :
	MAYBE_MODIFIERS KW_CLASS T_IDENTIFIER /*29L*/ EXTENDS IMPLEMENTS_LIST '{' /*27L*/ MAYBE_CLASS_BODY '}'
	;

INTERFACE_DECLARATION :
	MAYBE_MODIFIERS KW_INTERFACE T_IDENTIFIER /*29L*/ EXTENDS_LIST '{' /*27L*/ MAYBE_INTERFACE_BODY '}'
	;

MAYBE_CLASS_BODY :
	/*empty*/
	| CLASS_BODY
	;

CLASS_BODY :
	CLASS_BODY_ITEM
	| CLASS_BODY CLASS_BODY_ITEM
	;

CLASS_BODY_ITEM :
	';' /*4L*/
	| SLOT_DECLARATION
	| FUNCTION_DECLARATION
	| '[' /*27L*/ EMBED_START E ']' /*27L*/
	| CODE_STATEMENT
	;

MAYBE_INTERFACE_BODY :
	/*empty*/
	| INTERFACE_BODY
	;

INTERFACE_BODY :
	IDECLARATION
	| INTERFACE_BODY IDECLARATION
	;

IDECLARATION :
	';' /*4L*/
	| KW_VAR T_IDENTIFIER /*29L*/
	| MAYBE_MODIFIERS KW_FUNCTION /*35N*/ GETSET T_IDENTIFIER /*29L*/ '(' /*25L*/ MAYBE_PARAM_LIST ')' MAYBETYPE
	;

VARCONST :
	KW_VAR
	| KW_CONST
	;

SLOT_DECLARATION :
	MAYBE_MODIFIERS VARCONST SLOT_LIST
	;

SLOT_LIST :
	ONE_SLOT
	| SLOT_LIST ',' /*5L*/ ONE_SLOT
	;

ONE_SLOT :
	T_IDENTIFIER /*29L*/ MAYBETYPE MAYBEEXPRESSION
	;

MAYBECONSTANT :
	/*empty*/
	| '=' /*7R*/ E
	;

CONSTANT :
	T_INT /*34N*/
	| T_UINT /*34N*/
	| T_FLOAT /*34N*/
	| T_STRING /*33N*/
	| KW_TRUE /*35N*/
	| KW_FALSE /*35N*/
	| KW_NULL /*35N*/
	| KW_UNDEFINED /*35N*/
	| KW_NAN /*34N*/
	;

XML :
	XMLNODE
	;

OPEN :
	'<' /*17N*/
	;

CLOSE :
	'>' /*17N*/
	;

CLOSE2 :
	/*empty*/
	;

XMLEXPR1 :
	'{' /*27L*/ E '}'
	;

XMLEXPR2 :
	'{' /*27L*/ E '}'
	;

XMLTEXT :
	/*empty*/
	| XMLTEXT XMLEXPR1
	| XMLTEXT T_STRING /*33N*/
	| XMLTEXT '>' /*17N*/
	;

XML2 :
	XMLNODE XMLTEXT
	| XML2 XMLNODE XMLTEXT
	;

XML_ID_OR_EXPR :
	T_IDENTIFIER /*29L*/
	| XMLEXPR2
	;

MAYBE_XMLATTRIBUTES :
	/*empty*/
	| XMLATTRIBUTES
	;

XMLNODE :
	OPEN XML_ID_OR_EXPR MAYBE_XMLATTRIBUTES '/' /*21L*/ CLOSE2 '>' /*17N*/
	| OPEN XML_ID_OR_EXPR MAYBE_XMLATTRIBUTES CLOSE XMLTEXT '<' /*17N*/ '/' /*21L*/ XML_ID_OR_EXPR CLOSE2 '>' /*17N*/
	| OPEN XML_ID_OR_EXPR MAYBE_XMLATTRIBUTES CLOSE XMLTEXT XML2 '<' /*17N*/ '/' /*21L*/ XML_ID_OR_EXPR CLOSE2 '>' /*17N*/
	;

XMLATTRIBUTES :
	XMLATTRIBUTE
	| XMLATTRIBUTES XMLATTRIBUTE
	;

XMLATTRIBUTE :
	XMLEXPR2
	| XMLEXPR2 '=' /*7R*/ T_STRING /*33N*/
	| XMLEXPR2 '=' /*7R*/ XMLEXPR2
	| T_IDENTIFIER /*29L*/ '=' /*7R*/ XMLEXPR2
	| T_IDENTIFIER /*29L*/ '=' /*7R*/ T_STRING /*33N*/
	;

MAYBE_PARAM_LIST :
	/*empty*/
	| PARAM_LIST
	| T_DOTDOTDOT PARAM
	| PARAM_LIST ',' /*5L*/ T_DOTDOTDOT PARAM
	;

PARAM_LIST :
	PARAM_LIST ',' /*5L*/ PARAM
	| PARAM
	;

PARAM :
	T_IDENTIFIER /*29L*/ ':' /*8R*/ TYPE MAYBECONSTANT
	| T_IDENTIFIER /*29L*/ MAYBECONSTANT
	;

GETSET :
	KW_GET
	| KW_SET
	| /*empty*/
	;

FUNCTION_DECLARATION :
	MAYBE_MODIFIERS KW_FUNCTION /*35N*/ GETSET T_IDENTIFIER /*29L*/ '(' /*25L*/ MAYBE_PARAM_LIST ')' MAYBETYPE '{' /*27L*/ MAYBECODE '}'
	;

MAYBE_IDENTIFIER :
	T_IDENTIFIER /*29L*/
	| /*empty*/
	;

INNERFUNCTION :
	KW_FUNCTION /*35N*/ MAYBE_IDENTIFIER '(' /*25L*/ MAYBE_PARAM_LIST ')' MAYBETYPE '{' /*27L*/ MAYBECODE '}'
	;

CLASS :
	X_IDENTIFIER
	;

PACKAGEANDCLASS :
	PACKAGE '.' /*27L*/ X_IDENTIFIER
	;

CLASS_SPEC :
	PACKAGEANDCLASS
	| CLASS
	;

CLASS_SPEC_LIST :
	CLASS_SPEC
	| CLASS_SPEC_LIST ',' /*5L*/ CLASS_SPEC
	;

TYPE :
	CLASS_SPEC
	| '*' /*21L*/
	| KW_VOID /*22L*/
	;

MAYBETYPE :
	':' /*8R*/ TYPE
	| /*empty*/
	;

MAYBE_PARAM_VALUES :
	%prec prec_none /*1L*/ /*empty*/
	| '(' /*25L*/ MAYBE_EXPRESSION_LIST ')'
	;

MAYBE_EXPRESSION_LIST :
	/*empty*/
	| EXPRESSION_LIST
	| EXPRESSION_LIST_AND_COMMA
	;

EXPRESSION_LIST :
	NONCOMMAEXPRESSION
	;

EXPRESSION_LIST_AND_COMMA :
	EXPRESSION_LIST ',' /*5L*/
	;

EXPRESSION_LIST :
	EXPRESSION_LIST_AND_COMMA NONCOMMAEXPRESSION
	;

XX :
	%prec new2 /*26L*/ /*empty*/
	;

NEW :
	KW_NEW /*27L*/ E XX MAYBE_PARAM_VALUES
	;

FUNCTIONCALL :
	E '(' /*25L*/ MAYBE_EXPRESSION_LIST ')'
	| KW_SUPER /*35N*/ '(' /*25L*/ MAYBE_EXPRESSION_LIST ')'
	;

DELETE :
	KW_DELETE /*22L*/ E
	;

RETURN :
	KW_RETURN %prec prec_none /*1L*/
	| KW_RETURN EXPRESSION
	;

NONCOMMAEXPRESSION :
	E %prec below_lt /*16L*/
	;

EXPRESSION :
	COMMA_EXPRESSION
	;

COMMA_EXPRESSION :
	E %prec below_lt /*16L*/
	| COMMA_EXPRESSION ',' /*5L*/ E %prec below_lt /*16L*/
	;

VOIDEXPRESSION :
	E %prec below_minus /*19L*/
	| VOIDEXPRESSION ',' /*5L*/ E %prec below_lt /*16L*/
	;

MAYBE_DICT_EXPRPAIR_LIST :
	/*empty*/
	| DICT_EXPRPAIR_LIST
	;

DICTLH :
	T_IDENTIFIER /*29L*/
	| T_STRING /*33N*/
	| T_INT /*34N*/
	| T_UINT /*34N*/
	| T_FLOAT /*34N*/
	;

DICT_EXPRPAIR_LIST :
	DICTLH ':' /*8R*/ NONCOMMAEXPRESSION
	| DICT_EXPRPAIR_LIST ',' /*5L*/ DICTLH ':' /*8R*/ NONCOMMAEXPRESSION
	;

E :
	INNERFUNCTION %prec prec_none /*1L*/
	| MEMBER %prec '.' /*27L*/
	| NEW
	| DELETE
	| FUNCTIONCALL
	| VAR_READ %prec T_IDENTIFIER /*29L*/
	| CONSTANT
	| XML
	| T_REGEXP /*33N*/
	| KW_ARGUMENTS /*29L*/
	| '[' /*27L*/ MAYBE_EXPRESSION_LIST ']' /*27L*/
	| "{ (dictionary)" /*27L*/ MAYBE_DICT_EXPRPAIR_LIST '}'
	| E '<' /*17N*/ E
	| E '>' /*17N*/ E
	| E T_LE /*17N*/ E
	| E T_GE /*17N*/ E
	| E T_EQEQ /*14N*/ E
	| E T_EQEQEQ /*14N*/ E
	| E T_NEE /*14N*/ E
	| E T_NE /*14N*/ E
	| E T_OROR /*9L*/ E
	| E T_ANDAND /*10L*/ E
	| '!' /*22L*/ E
	| '~' /*22L*/ E
	| E '&' /*13N*/ E
	| E '^' /*12L*/ E
	| E '|' /*11L*/ E
	| E T_SHR /*18L*/ E
	| E T_USHR /*18L*/ E
	| E T_SHL /*18L*/ E
	| E '/' /*21L*/ E
	| E '%' /*21L*/ E
	| E '+' /*20L*/ E
	| E '-' /*20L*/ E
	| E '*' /*21L*/ E
	| E KW_IN /*15N*/ E
	| E KW_AS /*15N*/ E
	| E KW_INSTANCEOF /*17N*/ E
	| E KW_IS /*15N*/ E
	| KW_TYPEOF /*22L*/ E
	| KW_VOID /*22L*/ E
	| KW_VOID /*22L*/
	| '(' /*25L*/ COMMA_EXPRESSION ')'
	| '-' /*20L*/ E
	| E '[' /*27L*/ E ']' /*27L*/
	| E T_MULBY /*7R*/ E
	| E T_MODBY /*7R*/ E
	| E T_SHLBY /*7R*/ E
	| E T_SHRBY /*7R*/ E
	| E T_USHRBY /*7R*/ E
	| E T_DIVBY /*7R*/ E
	| E T_ORBY /*7R*/ E
	| E T_XORBY /*7R*/ E
	| E T_ANDBY /*7R*/ E
	| E T_PLUSBY /*7R*/ E
	| E T_MINUSBY /*7R*/ E
	| E '=' /*7R*/ E
	| E '?' /*8R*/ E ':' /*8R*/ E %prec below_assignment /*6N*/
	| E T_PLUSPLUS /*23L*/
	| E T_MINUSMINUS /*23L*/
	| T_PLUSPLUS /*23L*/ E %prec plusplus_prefix /*22L*/
	| T_MINUSMINUS /*23L*/ E %prec minusminus_prefix /*22L*/
	| KW_SUPER /*35N*/ '.' /*27L*/ T_IDENTIFIER /*29L*/
	| '@' /*27L*/ T_IDENTIFIER /*29L*/
	| E '.' /*27L*/ '(' /*25L*/ E ')'
	;

ID_OR_NS :
	'*' /*21L*/
	;

SUBNODE :
	X_IDENTIFIER
	| '*' /*21L*/
	;

E :
	E T_COLONCOLON /*27L*/ E
	| E '.' /*27L*/ ID_OR_NS T_COLONCOLON /*27L*/ SUBNODE
	| E T_DOTDOT /*27L*/ SUBNODE
	| E T_DOTDOT /*27L*/ ID_OR_NS T_COLONCOLON /*27L*/ SUBNODE
	| E '.' /*27L*/ '[' /*27L*/ E ']' /*27L*/
	| E '.' /*27L*/ '@' /*27L*/ SUBNODE
	| E '.' /*27L*/ '@' /*27L*/ ID_OR_NS T_COLONCOLON /*27L*/ SUBNODE
	| E T_DOTDOT /*27L*/ '@' /*27L*/ SUBNODE
	| E T_DOTDOT /*27L*/ '@' /*27L*/ ID_OR_NS T_COLONCOLON /*27L*/ SUBNODE
	| E '.' /*27L*/ '@' /*27L*/ '[' /*27L*/ E ']' /*27L*/
	| E T_DOTDOT /*27L*/ '@' /*27L*/ '[' /*27L*/ E ']' /*27L*/
	;

MEMBER :
	E '.' /*27L*/ SUBNODE
	;

VAR_READ :
	T_IDENTIFIER /*29L*/
	;

NAMESPACE_ID :
	KW_NAMESPACE T_IDENTIFIER /*29L*/
	| KW_NAMESPACE T_IDENTIFIER /*29L*/ '=' /*7R*/ T_IDENTIFIER /*29L*/
	| KW_NAMESPACE T_IDENTIFIER /*29L*/ '=' /*7R*/ T_STRING /*33N*/
	;

NAMESPACE_DECLARATION :
	MAYBE_MODIFIERS NAMESPACE_ID
	;

DEFAULT_NAMESPACE :
	KW_DEFAULT_XML KW_NAMESPACE '=' /*7R*/ E
	;

USE_NAMESPACE :
	KW_USE KW_NAMESPACE CLASS_SPEC
	;

%%

NAME_NOC2EF  [a-zA-Z_\x80-\xc1\xc3-\xee\xf0-\xff]
NAME_EF      [\xef][a-zA-Z0-9_\\\x80-\xba\xbc-\xff]
NAME_C2      [\xc2][a-zA-Z0-9_\\\x80-\x9f\xa1-\xff]
NAME_EFBB    [\xef][\xbb][a-zA-Z0-9_\\\x80-\xbe\xc0-\xff]
NAME_TAIL    [a-zA-Z_0-9\\\x80-\xff]*
NAME_HEAD    (({NAME_NOC2EF})|({NAME_EF})|({NAME_C2})|({NAME_EFBB}))
NAME	     {NAME_HEAD}{NAME_TAIL}

_            [^a-zA-Z0-9_\\\x80-\xff]

HEXINT    0x[a-zA-Z0-9]+
HEXFLOAT  0x[a-zA-Z0-9]*\.[a-zA-Z0-9]*
INT       [0-9]+
FLOAT     ([0-9]+(\.[0-9]*)?|\.[0-9]+)(e[0-9]+)?

HEXWITHSIGN [+-]?({HEXINT})
HEXFLOATWITHSIGN [+-]?({HEXFLOAT})
INTWITHSIGN [+-]?({INT})
FLOATWITHSIGN [+-]?({FLOAT})

S 	 ([ \n\r\t\xa0]|[\xc2][\xa0])

CDATA       <!\[CDATA\[([^]]|\][^]]|\]\][^>])*\]*\]\]\>
XMLCOMMENT  <!--([^->]|[-]+[^>-]|>)*-*-->
XML         <[^>]+{S}>
XMLID       [A-Za-z0-9_\x80-\xff]+([:][A-Za-z0-9_\x80-\xff]+)?
XMLSTRING   ["][^"]*["]

STRING   ["](\\[\x00-\xff]|[^\\"\n])*["]|['](\\[\x00-\xff]|[^\\'\n])*[']
MULTILINE_COMMENT [/][*]+([*][^/]|[^/*]|[^*]?[/]|[\x00-\x1f])*[*]+[/]
SINGLELINE_COMMENT \/\/[^\n\r]*[\n\r]
REGEXP   [/]([^/\n]|\\[/])*[/][a-zA-Z]*

%%

"!"	'!'
"!="	T_NE
"!=="	T_NEE
"%"	'%'
"%="	T_MODBY
"&"	'&'
"&&"	T_ANDAND
"&="	T_ANDBY
"("	'('
")"	')'
"*"	'*'
"*="	T_MULBY
"+"	'+'
"++"	T_PLUSPLUS
"+="	T_PLUSBY
","	','
"-"	'-'
"--"	T_MINUSMINUS
"-="	T_MINUSBY
\.                           '.'
:                            ':'
".."	T_DOTDOT
"..."	T_DOTDOTDOT
"/"	'/'
"/="	T_DIVBY
"::"	T_COLONCOLON
";"	';'
"<"	'<'
"<<"	T_SHL
"<<="	T_SHLBY
"<="	T_LE
"="	'='
"=="	T_EQEQ
"==="	T_EQEQEQ
">"	'>'
">="	T_GE
">>"	T_SHR
">>="	T_SHRBY
">>>"	T_USHR
">>>="	T_USHRBY
"?"	'?'
"@"	'@'
"["	'['
"]"	']'
"^"	'^'
"^="	T_XORBY
"{ (dictionary)"	"{ (dictionary)"
"{"	'{'
"|"	'|'
"|="	T_ORBY
"||"	T_OROR
"}"	'}'
"~"	'~'

arguments                    KW_ARGUMENTS
as                           KW_AS
break                        KW_BREAK
case                         KW_CASE
catch                        KW_CATCH
class                        KW_CLASS
const                        KW_CONST
continue                     KW_CONTINUE
default                      KW_DEFAULT
default{S}xml                KW_DEFAULT_XML
delete                       KW_DELETE
do                           T_DO
dynamic                      KW_DYNAMIC
each                         KW_EACH
else                         KW_ELSE
extends                      KW_EXTENDS
false                        KW_FALSE
final                        KW_FINAL
finally                      KW_FINALLY
for                          T_FOR
function                     KW_FUNCTION
get                          KW_GET
if                           KW_IF
implements                   KW_IMPLEMENTS
import                       KW_IMPORT
in                           KW_IN
instanceof                   KW_INSTANCEOF
interface                    KW_INTERFACE
internal                     KW_INTERNAL
is                           KW_IS
NaN	KW_NAN
namespace                    KW_NAMESPACE
native                       KW_NATIVE
new2	new2
new                          KW_NEW
null                         KW_NULL
override                     KW_OVERRIDE
package                      KW_PACKAGE
private                      KW_PRIVATE
protected                    KW_PROTECTED
public                       KW_PUBLIC
return                       KW_RETURN
set                          KW_SET
static                       KW_STATIC
super                        KW_SUPER
switch                       T_SWITCH
throw                        KW_THROW
true                         KW_TRUE
try                          KW_TRY
typeof                       KW_TYPEOF
undefined                    KW_UNDEFINED
use                          KW_USE
var                          KW_VAR
void                         KW_VOID
while                        T_WHILE
"with"	KW_WITH

//KW_INT	KW_INT
//KW_NUMBER	KW_NUMBER
//KW_STRING	KW_STRING
//KW_UINT	KW_UINT
//T_DICTSTART	T_DICTSTART
//T_EMPTY	T_EMPTY

{INT}|{HEXINT}	T_INT //need be before float
{FLOAT}|{HEXFLOAT}	T_FLOAT
{REGEXP}	T_REGEXP
{STRING}	T_STRING
T_UINT	T_UINT

"$"?{NAME}	T_IDENTIFIER

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

%%
