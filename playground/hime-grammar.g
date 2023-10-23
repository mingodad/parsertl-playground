//From: https://github.com/cenotelie/hime/blob/2ad5efa246a3446e7fe82f2e01d8ff862b09c0b3/sdk-rust/src/loaders/HimeGrammar.gram
/*******************************************************************************
 * Copyright (c) 2017 Association Cénotélie (cenotelie.fr)
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General
 * Public License along with this program.
 * If not, see <http://www.gnu.org/licenses/>.
 ******************************************************************************/

%token BLOCK_CONTEXT
%token BLOCK_RULES
%token BLOCK_TERMINALS
%token BLOCK_OPTIONS
%token TREE_ACTION_DROP
%token TREE_ACTION_PROMOTE
%token OPERATOR_DIFFERENCE
%token OPERATOR_UNION
%token OPERATOR_ONEMORE
%token OPERATOR_ZEROMORE
%token OPERATOR_OPTIONAL
%token LITERAL_ANY
%token UNICODE_SPAN_MARKER
%token UNICODE_CODEPOINT
%token UNICODE_CATEGORY
%token UNICODE_BLOCK
%token LITERAL_CLASS
%token LITERAL_TEXT
%token LITERAL_STRING
%token INTEGER
%token NAME

%start file

%%

/* Options section definition */
option :
	NAME '=' LITERAL_STRING ';'
	;

/* Terminals section definition for text grammars */
terminal_def_atom :
	LITERAL_ANY
	|  UNICODE_CODEPOINT
	|  LITERAL_TEXT
	|  LITERAL_CLASS
	|  UNICODE_CODEPOINT UNICODE_SPAN_MARKER UNICODE_CODEPOINT
	|  UNICODE_BLOCK
	|  UNICODE_CATEGORY
	|  NAME
	;

terminal_def_element :
	terminal_def_atom
	| '(' terminal_definition ')'
	;

terminal_def_cardinalilty :
	OPERATOR_OPTIONAL
	|  OPERATOR_ZEROMORE
	|  OPERATOR_ONEMORE
	|  /*"range"?^*/ '{' INTEGER (',' INTEGER)? '}'
	;

terminal_def_repetition :
	terminal_def_element terminal_def_cardinalilty?
	;

terminal_def_fragment :
	terminal_def_repetition (/*"concat"^*/ terminal_def_repetition)*
	;

terminal_def_restrict :
	terminal_def_fragment (OPERATOR_DIFFERENCE terminal_def_fragment)*
	;

terminal_definition :
	terminal_def_restrict (OPERATOR_UNION terminal_def_restrict)*
	;

terminal_rule :
	NAME "->" terminal_definition ';'
	;

terminal_fragment :
	"fragment" NAME "->" terminal_definition ';'
	;

terminal_context :
	BLOCK_CONTEXT NAME '{' terminal_rule* '}'
	;

terminal_item :
	terminal_rule
	| terminal_fragment
	| terminal_context
	;

/* Define symbols for grammar rules */
rule_sym_action :
	'@' NAME
	;

rule_sym_virtual :
	LITERAL_STRING
	;

rule_sym_ref_params :
	'<' rule_def_atom (',' rule_def_atom)* '>'
	;

rule_sym_ref_template :
	NAME rule_sym_ref_params
	;

rule_sym_ref_simple :
	NAME
	;

/* Define the rule definition */
rule_def_atom :
	rule_sym_action
	|  rule_sym_virtual
	|  rule_sym_ref_simple
	|  rule_sym_ref_template
	|  LITERAL_TEXT
	;

rule_def_context :
	'#' NAME '{' rule_definition '}'
	;

rule_def_sub :
	'{' rule_definition '}'
	;

rule_def_element :
	rule_def_atom
	| rule_def_context
	| rule_def_sub
	| '(' rule_definition ')'
	;

rule_def_tree_action :
	rule_def_element (TREE_ACTION_PROMOTE | TREE_ACTION_DROP)?
	;

rule_def_repetition :
	rule_def_tree_action (OPERATOR_OPTIONAL | OPERATOR_ONEMORE | OPERATOR_ZEROMORE)?
	;

rule_def_fragment :
	rule_def_repetition (/*"concat"^*/ rule_def_repetition)*
	;

rule_def_choice :
	rule_def_fragment
	| /*"emptypart"^*/
	;

rule_definition :
	rule_def_choice (OPERATOR_UNION rule_def_choice)*
	;

/* Define rules */
rule_template_params :
	'<' NAME (',' NAME)* '>'
	;

cf_rule_template :
	NAME rule_template_params "->" rule_definition ';'
	;

cf_rule_simple :
	NAME "->" rule_definition ';'
	;

cf_rule :
	cf_rule_simple
	| cf_rule_template
	;

/* Define the grammars */
grammar_options :
	BLOCK_OPTIONS '{' option* '}'
	;

grammar_terminals :
	BLOCK_TERMINALS '{' terminal_item* '}'
	;

grammar_cf_rules :
	BLOCK_RULES '{' cf_rule* '}'
	;

grammar_parency :
	(':' NAME (',' NAME)*)?
	;

cf_grammar :
	"grammar" NAME grammar_parency
		'{'
			grammar_options
			grammar_terminals?
			grammar_cf_rules
		'}'
	;

file :
	cf_grammar+
	;

%%

NEW_LINE       \r|\n|\r\n
WHITE_SPACE     [\v\f\t ]
COMMENT_LINE    "//".*
COMMENT_BLOCK   "/*"(?s:.)*?"*/"
SEPARATOR           ({NEW_LINE}|{WHITE_SPACE}|{COMMENT_LINE}|{COMMENT_BLOCK})+

NAME_FIRST     [_a-zA-Z]
NAME                {NAME_FIRST}({NAME_FIRST}|[0-9])*

ESCAPEES      "\\\\"|"\\0"|"\\a"|"\\b"|"\\f"|"\\n"|"\\r"|"\\t"|"\\v"

%%

{SEPARATOR}	skip()

"<"	'<'
"="	'='
">"	'>'
","	','
";"	';'
":"	':'
"("	'('
")"	')'
"{"	'{'
"}"	'}'
"@"	'@'
"#"	'#'
"->"	"->"
//"concat"	"concat"
//"emptypart"	"emptypart"
"fragment"	"fragment"
"grammar"	"grammar"
//"range"	"range"

"context"	BLOCK_CONTEXT
"rules"	BLOCK_RULES
"terminals"	BLOCK_TERMINALS
"options"	BLOCK_OPTIONS
"!"	TREE_ACTION_DROP
"^"	TREE_ACTION_PROMOTE
"-"	OPERATOR_DIFFERENCE
"|"	OPERATOR_UNION
"+"	OPERATOR_ONEMORE
"*"	OPERATOR_ZEROMORE
"?"	OPERATOR_OPTIONAL
"."	LITERAL_ANY
".."	UNICODE_SPAN_MARKER

"U+"[a-fA-F0-9]+	UNICODE_CODEPOINT
"uc{"([_a-zA-Z0-9]|"-")+"}"	UNICODE_CATEGORY
"ub{"([_a-zA-Z0-9]|"-")+"}"	UNICODE_BLOCK
"["([^\\\[\]]|"\\["|"\\]"|"\\-"|"\\^"|{ESCAPEES})+"]"	LITERAL_CLASS
"~"?'([^\\']|"\\\'"|{ESCAPEES})+'	LITERAL_TEXT
\"(\\.|[^"\n\r\\])*\"	LITERAL_STRING
[1-9][0-9]*|0	INTEGER
{NAME}	NAME

%%

