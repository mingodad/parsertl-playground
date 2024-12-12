//From: https://github.com/pwil3058/dunnart/blob/ad088772b1719ea1ce17356d5e5b279dd33d9838/dunnart.ddgs
// dunnart.ddgs
//
// Copyright Peter Williams 2013 <pwil3058@bigpond.net.au>.
//
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

// dunnart specification for dunnart grammar specification language

%token  REGEX
%token  LITERAL
%token  IDENT
%token  FIELDNAME
%token  PREDICATE
%token  ACTION
%token  DCODE

%right INJECT

%%

specification :
	preamble definitions "%%" production_rules coda
	;

oinjection :
	%empty
	| injection
	;

injection_head :
	INJECT LITERAL
	;

// NB This (including the split) is needed to allow for "look ahead" mechanism.
// It ensures injection occurs before any meaningful tokens are read
injection :
	injection_head "."
	;

// Preamble
preamble :
	%empty
	| oinjection DCODE oinjection
	| oinjection DCODE oinjection DCODE oinjection
	;

// Coda
coda :
        %empty
	| oinjection DCODE
        ;

definitions :
	field_definitions token_definitions skip_definitions precedence_definitions
	;

// Field definitions
field_definitions : // empty production
        %empty
	| field_definitions oinjection field_definition oinjection
	;

field_definition :
	"%field" field_type field_name
	| "%field" field_type field_name field_conversion_function
	;

field_type :
	/*IDENT ?( !is_allowable_name($1.dd_matched_text) ?)
	|*/ IDENT
	;

field_name :
	/*IDENT ?( !is_allowable_name($1.dd_matched_text) ?)
	|*/ IDENT
	;

field_conversion_function :
	/*IDENT ?( !is_allowable_name($1.dd_matched_text) ?)
	|*/ IDENT
	;

// Token definitions
token_definitions :
	oinjection token_definition
	| token_definitions oinjection token_definition oinjection
	;

token_definition :
	"%token" new_token_name pattern
	| "%token" FIELDNAME new_token_name pattern
	;

new_token_name :
	/*IDENT ?( !is_allowable_name($1.dd_matched_text) ?)
	|*/ IDENT
	;

pattern :
	REGEX
	| LITERAL
	;

// Skip definitions
skip_definitions : // empty production
	%empty
	| skip_definitions oinjection skip_definition oinjection
	;

skip_definition :
	"%skip" REGEX
	;

// Precedence definitions
precedence_definitions : // empty production
        %empty
	| precedence_definitions oinjection precedence_definition oinjection
	;

precedence_definition :
	"%left" tag_list
	| "%right" tag_list
	| "%nonassoc" tag_list
	;

tag_list :
	tag
	| tag_list tag
	;

tag :
	LITERAL
	/*| IDENT ?( grammar_specification.symbol_table.is_known_token($1.dd_matched_text) ?)
	| IDENT ?( grammar_specification.symbol_table.is_known_non_terminal($1.dd_matched_text) ?)*/
	| IDENT
	;

// Production rules
production_rules :
	oinjection production_group oinjection
	| production_rules production_group oinjection
	;

production_group :
	production_group_head production_tail_list "."
	;

production_group_head :
	/*IDENT ":" ?( grammar_specification.symbol_table.is_known_token($1.dd_matched_text) ?)
	| IDENT ":" ?( grammar_specification.symbol_table.is_known_tag($1.dd_matched_text) ?)
	|*/ IDENT ":"
	;

production_tail_list :
	production_tail
	| production_tail_list "|" production_tail
	;

production_tail :
	%empty
	| action
	| predicate action
	| predicate
	| symbol_list predicate tagged_precedence action
	| symbol_list predicate tagged_precedence
	| symbol_list predicate action
	| symbol_list predicate
	| symbol_list tagged_precedence action
	| symbol_list tagged_precedence
	| symbol_list action
	| symbol_list
	;

action :
	ACTION
	;

predicate :
	PREDICATE
	;

tagged_precedence :
	"%prec" IDENT
	| "%prec" LITERAL
	;

symbol_list :
	symbol
	| symbol_list symbol
	;

symbol :
	IDENT
	| LITERAL
	| "%error"
	;

%%

id	[a-zA-Z]+[a-zA-Z0-9_]*

%%

"%%"	"%%"
"%error"	"%error"
"%field"	"%field"
"%inject"	INJECT
"%left"	"%left"
"%nonassoc"	"%nonassoc"
"%prec"	"%prec"
"%right"	"%right"
"%skip"	"%skip"
"%token"	"%token"
"."	"."
":"	":"
"|"	"|"

"!{"(.|[\n\r])*?"!}"	ACTION
"%{"(.|[\n\r])*?"%}"	DCODE
\"(\\.|[^"\r\n\\])*\"	LITERAL
"?("(.|[\n\r])*?"?)"	PREDICATE
"(".+")"	REGEX

/*
"%token"	TOKEN
"%field"	FIELD
"%left"	LEFT
"%right"	RIGHT
"%nonassoc"	NONASSOC
"%prec"	PRECEDENCE
"%skip"	SKIP
"%error"	ERROR
"%inject"	INJECT
"%%"	NEWSECTION
":"	COLON
"|"	VBAR
"."	DOT

REGEX           (\(.+\)(?=\s))
LITERAL         ("(\\"|[^"\t\r\n\v\f])*")
PREDICATE       (\?\((.|[\n\r])*?\?\))
ACTION          (!\{(.|[\n\r])*?!\})
DCODE           (%\{(.|[\n\r])*?%\})
*/

"/*"(?s:.)*?"*/"	skip()
"//".*	skip()
[ \t\r\n]	skip()

{id}	IDENT
"<"{id}">"	FIELDNAME

%%
