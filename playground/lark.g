// Lark grammar of Lark's syntax

%token _NL RULE TOKEN NUMBER _VBAR OP STRING REGEXP

%%

start:
	  _item_opt_NL_zom _item_opt
	;

_item_opt_NL_zom:
	  %empty
	| _item_opt_NL_zom _item_opt _NL
	;

_item_opt:
	  %empty
	| _item
	;

_item:
	  rule
	| token
	| statement
	;

rule:
	  RULE rule_params priority_opt ':' expansions
	;

priority_opt:
	  %empty
	| priority
	;

token:
	  TOKEN token_params priority_opt ':' expansions
	;

rule_params:
	  %empty
	| '{' RULE_comma_oom '}'
	;

RULE_comma_oom:
	  RULE
	| RULE_comma_oom ',' RULE
	;

token_params:
	  %empty
	| '{' TOKEN_comma_oom '}'
	;

TOKEN_comma_oom:
	  TOKEN
	| TOKEN_comma_oom ',' TOKEN
	;

priority:
	  '.' NUMBER
	;

statement:
	  "%ignore" expansions
	| "%import" import_path arrow_name_opt
	| "%import" import_path name_list
	| "%override" rule
	| "%declare" name_oom
	;

name_oom:
	  name
	| name_oom name
	;

arrow_name_opt:
	  %empty
	| "->" name
	;

import_path:
	  dot_opt name dot_name_zom
	;

dot_name_zom:
	  %empty
	| dot_name_zom '.' name
	;

dot_opt:
	  %empty
	| '.'
	;

name_list:
	  '(' name_comma_oom ')'
	;

name_comma_oom:
	  name
	| name_comma_oom ',' name
	;

expansions:
	  alias _VBAR_alias_zom
	;

_VBAR_alias_zom:
	  %empty
	| _VBAR_alias_zom _VBAR alias
	;

alias:
	  expansion arrow_RULE_opt
	;

arrow_RULE_opt:
	  %empty
	| "->" RULE
	;

expansion:
	  %empty
	| expansion expr
	;

expr:
	  atom repetition__opt
	;

repetition__opt:
	  %empty
	| OP
	| '~' NUMBER
	| '~' NUMBER ".." NUMBER
	;

atom:
	  '(' expansions ')'
	| '[' expansions ']'
	| value
	;

value:
	  STRING ".." STRING
	| name
	| regex_or_string
	| name '{' value_oom '}'
	;

value_oom:
	  value
	| value_oom ',' value
	;

regex_or_string:
	  REGEXP
	| STRING
	;

name:
	  RULE
	| TOKEN
	;

%%

/* Basic terminals for common use */


/*
// Numbers
*/

DIGIT	 [0-9]
HEXDIGIT	[a-fA-F]|{DIGIT}

INT	{DIGIT}+
SIGNED_INT	[-+]?{INT}
DECIMAL	{INT}"."{INT}?|"."{INT}

/* float = /-?\d+(\.\d+)?([eE][+-]?\d+)?/ */
_EXP	[eE]{SIGNED_INT}
FLOAT	{INT}{_EXP}|{DECIMAL}{_EXP}?
SIGNED_FLOAT	[-+]{FLOAT}

NUMBER	{FLOAT}|{INT}
SIGNED_NUMBER	[-+]{NUMBER}

/*
// Strings
*/
/*
_STRING_INNER	.*?
_STRING_ESC_INNER	{_STRING_INNER} /(?<!\\)(\\\\)*?/

ESCAPED_STRING	\"{_STRING_ESC_INNER}\"
*/
ESCAPED_STRING	\"(\\.|[^\"\\])*\"

/*
// Names (Variables)
*/
LCASE_LETTER	[a-z]
UCASE_LETTER	[A-Z]

LETTER	{UCASE_LETTER}|{LCASE_LETTER}
WORD	{LETTER}+

CNAME	("_"|{LETTER})("_"|{LETTER}|{DIGIT})*


/*
// Whitespace
*/
WS_INLINE	[ \t]+
WS	[ \t\f\r\n]+

CR	\r
LF 	\n
NEWLINE	({CR}?{LF})+


/* Comments */
SH_COMMENT	"#"[^\n]*
CPP_COMMENT	"//"[^\n]*
C_COMMENT	"/*"(.|\n)*?"*/"
SQL_COMMENT	"--"[^\n]*



COMMENT	[[:space:]]*("//"|"#")[^\n]*
_NL	(\r?\n)+{WS_INLINE}*

%%

{WS_INLINE}	skip()
{COMMENT}		skip()

":"	':'
"{"	'{'
"}"	'}'
","	','
"."	'.'
"->"	"->"
"("	'('
")"	')'
"~"	'~'
".."	".."
"["	'['
"]"	']'
"%ignore"	"%ignore"
"%import"	"%import"
"%declare"	"%declare"
"%override"	"%override"

{_NL}	_NL
{_NL}?"|"	_VBAR
[+*?]	OP
[!?]?[_a-z][_a-z0-9]*	RULE
[_A-Z][_A-Z0-9]*	TOKEN
{ESCAPED_STRING}"i"?	STRING
/*\/(\\\/|\\\\|[^\/])*?\/[imslux]*	REGEXP*/
\/(\\.|[^\/\\])+\/    REGEXP
{SIGNED_INT}	NUMBER

%%
