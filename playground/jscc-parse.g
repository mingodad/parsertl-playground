//From: https://github.com/abrobston/jscc/blob/3e3043a7519b00dc9aebfc8f5850cca9237b97ec/lib/jscc/parse.par
/*
/~ -PARSER----------------------------------------------------------------------
JS/CC LALR(1) Parser Generator
Copyright (C) 2007-2012 by Phorward Software Technologies, Jan Max Meyer
http://jscc.phorward-software.com ++ contact<<AT>>phorward-software<<DOT>>com

File:	parse.par
Author:	Jan Max Meyer
Usage:	A parser for parsing JS/CC parser definitions; The first versions of
		JS/CC until v0.14 (had never been released!) worked with a hand-written
		recursive descent parser.

You may use, modify and distribute this software under the terms and conditions
of the BSD license. Please see LICENSE for more information.
----------------------------------------------------------------------------- ~/
*/

%token CODE
%token STRING_SINGLE
%token STRING_DOUBLE
%token IDENT
%token ON_ERROR PREC_LEFT PREC_RIGHT PREC_NONASSOC WS_IGNORE

%%

def :
	header_code token_assocs "##" grammar_defs footer_code
	;

/* Token definition part */
header_code :
	code_opt
	;

footer_code :
	code_opt
	;

token_assocs :
	token_assocs token_assoc
	| token_assoc
	/* | error */
	;

token_assoc :
	PREC_LEFT token_defs	';'
	| PREC_RIGHT token_defs ';'
	| PREC_NONASSOC token_defs ';'
	| token_defs ';'
	| WS_IGNORE string opt_semicolon
	;

token_defs :
	token_defs token_def
	| token_def
	;

token_def :
	string identifier code_opt
	| string code_opt
	;

/* Grammar definition part */

grammar_defs :
	grammar_defs grammar_def
	| grammar_def
	;

grammar_def :
	identifier ':' productions ';'
	//| /*~*/ error ';'
	;

productions :
	productions '|' rhs
	| rhs
	;

rhs :
	sequence_opt rhs_prec code_opt
	;

rhs_prec :
	'&' identifier
	| '&' string
	| %empty
	;

sequence_opt :
	sequence
	| %empty
	;

sequence :
	sequence symbol
	| symbol
	;

symbol :
	identifier
	| string
	| ON_ERROR
	;

/* Universal elements */
code_opt :
	code
	| "=>" identifier
	| "=>" CODE
	| %empty
	;

code :
	code CODE
	| CODE
	;

string :
	STRING_SINGLE
	| STRING_DOUBLE
	;

identifier :
	IDENT
	;

opt_semicolon :
	';'
	| %empty
	;

%%

%%

/*
	Terminal symbol definitions
*/

/* Operators: */
"##"	"##"
"<"	PREC_LEFT
">"	PREC_RIGHT
"^"	PREC_NONASSOC
"!"	WS_IGNORE
";"	';'
":"	':'
"|"	'|'
"&"	'&'
"~"	ON_ERROR
"=>"	"=>"

/* Lexeme: */
"[*"([^\*]\]|\*[^\]]|[^\*\]])*\*\] CODE //[*	return %match.substr(2, %match.length - 4 ); *]
'([^']|\\')*' STRING_SINGLE
\"([^"]|\\\")*\" STRING_DOUBLE
[A-Za-z0-9_-]+ IDENT

/* Whitespace: */
\n skip()
"/~"([^~]"/"|"~"[^/]|[^~/])*"~/" skip()
[\t\r ]+ skip()

%%
