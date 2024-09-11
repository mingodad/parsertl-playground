//From: https://github.com/jplevyak/dparser/blob/c74f863a1872f31772b015a384ec5189897d4844/grammar.g
/*
  Copyright 2002-2004 John Plevyak, All Rights Reserved
*/

%token regex
%token identifier
%token string
%token unicode_char
%token integer
%token symbols

%%

grammar:
	  %empty
	| grammar top_level_statement
	;

top_level_statement:
	  global_code
	| production
	| include_statement
	;

include_statement:
	  "include" regex
	;

global_code:
	  "%<" balanced_code_zom "%>"
	| curly_code
	| "${scanner" balanced_code_oom '}'
	| "${declare" declarationtype identifier_zom '}'
	| "${token" token_identifier_oom '}'
	| "${pass" identifier pass_types '}'
	;

token_identifier_oom:
	  token_identifier
	| token_identifier_oom token_identifier
	;

identifier_zom:
	  %empty
	| identifier_zom identifier
	;

balanced_code_zom:
	  %empty
	| balanced_code_zom balanced_code
	;

pass_types:
	  %empty
	| pass_type pass_types
	;

pass_type:
	  "preorder"
	| "postorder"
	| "manual"
	| "for_all"
	| "for_undefined"
	;

declarationtype:
	  "tokenize"
	| "longest_match"
	| "whitespace"
	| "all_matches"
	| "set_op_priority_from_rule"
	| "all_subparsers"
	| "subparser"
	| "save_parse_tree"
	;

token_identifier:
	  identifier
	;

production:
	  production_name ':' rules ';'
	| production_name regex_production rules ';'
	| ';'
	;

regex_production:
	  "::="
	;

production_name:
	  identifier
	| '_'
	;

rules:
	  rule
	| rules '|' rule
	;

rule:
	  element_zom rule_modifier_zom rule_code
	;

rule_modifier_zom:
	  %empty
	| rule_modifier_zom rule_modifier
	;

element_zom:
	  %empty
	| element_zom element element_modifier_zom
	;

element_modifier_zom:
	  %empty
	| element_modifier_zom element_modifier
	;

balanced_code_oom:
	  balanced_code
	| balanced_code_oom balanced_code
	;

element:
	  string
	| regex
	| unicode_char
	| identifier
	| "${scan" balanced_code_oom '}'
	| '(' /*new_subrule*/ rules ')'
	| bracket_code
	| curly_code
	;

element_modifier:
	  "$term" integer
	| "$name" string
	| "$name" regex
	| "/i"
	| '?'
	| '*'
	| '+'
	| '@' integer
	| '@' integer ':' integer
	;

rule_modifier:
	  rule_assoc rule_priority
	| external_action
	;

rule_assoc:
	  "$unary_op_right"
	| "$unary_op_left"
	| "$binary_op_right"
	| "$binary_op_left"
	| "$unary_right"
	| "$unary_left"
	| "$binary_right"
	| "$binary_left"
	| "$right"
	| "$left"
	;

rule_priority:
	  integer
	;

external_action:
	  "${action}"
	| "${action" integer '}'
	;

rule_code:
	  speculative_code_opt final_code_opt pass_code_zom
	;

pass_code_zom:
	  %empty
	| pass_code_zom pass_code
	;

final_code_opt:
	  %empty
	| final_code
	;

speculative_code_opt:
	  %empty
	| speculative_code
	;

speculative_code:
	  bracket_code
	;

final_code:
	  curly_code
	;

pass_code:
	  identifier ':' curly_code
	;

curly_code:
	  '{' balanced_code_zom '}'
	;

bracket_code:
	  '[' balanced_code_zom ']'
	;

balanced_code:
	  '(' balanced_code_zom ')'
	| bracket_code
	| curly_code
	| string
	| identifier
	| regex
	| integer
	| symbols
	;

%%

symbols  [!~`@#$%^&*\-_+=|:;\\<,>.?/]
string '([^'\r\n\\]|\\.)+'
regex \"([^"\r\n\\]|\\.)+\"
unicode_char [uU]\+[0-9a-fA-F]+
identifier [a-zA-Z_][a-zA-Z_0-9]* // $term -1;
decimalint "-"?[1-9][0-9]*[uUlL]?
hexint "-"?(0x|0X)[0-9a-fA-F]+[uUlL]?
octalint "-"?0[0-7]*[uUlL]?
integer {decimalint}|{hexint}|{octalint}

%%

[ \t\r\n]+	skip()
"//".*  skip()
"/*"(?s:.)*?"*/"    skip()

"|"	'|'
"_"	'_'
";"	';'
"::="	"::="
":"	':'
"?"	'?'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"@"	'@'
"*"	'*'
"%<"	"%<"
"%>"	"%>"
"+"	'+'
"${action"	"${action"
"${action}"	"${action}"
"all_matches"	"all_matches"
"all_subparsers"	"all_subparsers"
"$binary_left"	"$binary_left"
"$binary_op_left"	"$binary_op_left"
"$binary_op_right"	"$binary_op_right"
"$binary_right"	"$binary_right"
"${declare"	"${declare"
"for_all"	"for_all"
"for_undefined"	"for_undefined"
"/i"	"/i"
"include"	"include"
"$left"	"$left"
"longest_match"	"longest_match"
"manual"	"manual"
"$name"	"$name"
"${pass"	"${pass"
"postorder"	"postorder"
"preorder"	"preorder"
"$right"	"$right"
"save_parse_tree"	"save_parse_tree"
"${scanner"	"${scanner"
"${scan"	"${scan"
"set_op_priority_from_rule"	"set_op_priority_from_rule"
"subparser"	"subparser"
"$term"	"$term"
"tokenize"	"tokenize"
"${token"	"${token"
"$unary_left"	"$unary_left"
"$unary_op_left"	"$unary_op_left"
"$unary_op_right"	"$unary_op_right"
"$unary_right"	"$unary_right"
"whitespace"	"whitespace"

{regex} regex
{unicode_char} unicode_char
{string} string
{integer} integer
{symbols} symbols
{identifier} identifier

%%
