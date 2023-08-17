// Lark grammar of Lark's syntax

%token _NL RULE TOKEN NUMBER _VBAR OP STRING REGEXP

%%

start: (_item? _NL)* _item? ;

_item: rule
     | token
     | statement ;

rule: RULE rule_params priority? ':' expansions ;
token: TOKEN token_params priority? ':' expansions ;

rule_params: ('{' RULE (',' RULE)* '}')? ;
token_params: ('{' TOKEN (',' TOKEN)* '}')? ;

priority: '.' NUMBER ;

statement: "%ignore" expansions                    // ignore
         | "%import" import_path ["->" name]       // import
         | "%import" import_path name_list         // multi_import
         | "%override" rule                        // override_rule
         | "%declare" name+  ;                        // declare

import_path: '.'? name ('.' name)* ;
name_list: '(' name (',' name)* ')' ;

expansions: alias (_VBAR alias)* ;

alias: expansion ("->" RULE)? ;

expansion: expr* ;

expr: atom (OP | '~' NUMBER (".." NUMBER)?)? ;

atom: '(' expansions ')'
     | '[' expansions ']' // maybe
     | value ;

value: STRING ".." STRING  // literal_range
      | name
      | (REGEXP | STRING) // literal
      | name '{' value (',' value)* '}' ; // template_usage

name: RULE
    | TOKEN ;

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
