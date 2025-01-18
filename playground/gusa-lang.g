//From: https://dusa.rocks/docs/language/syntax/

%token variable wildcard identifier string_literal int_literal

%%

program :
	program declaration
	| %empty
	;

declaration :
	"#builtin" builtin identifier dot_opt
	| "#lazy" identifier dot_opt
	| "#demand" premises '.'
	| "#forbid" premises '.'
	| conclusion '.'
	| conclusion ":-" premises '.'
	;

dot_opt :
	%empty
	| '.'
	;

premises :
	premise
	| premises ',' premise
	;

premise :
	term oper term
	| attribute
	| attribute "is" term
	;

oper :
	"=="
	| "!="
	| ">="
	| '>'
	| "<="
	| '<'
	;

conclusion :
	attribute
	| attribute "is" term_or_choices
	| attribute "is?" term_or_choices
	;

term_or_choices :
	term
	| '{' choice_options '}'
	;

choice_options :
	term
	| choice_options ',' term
	;

attribute :
	identifier
	| identifier arguments
	;

arguments :
	atomic_term
	| arguments atomic_term
	;

atomic_term :
	wildcard
	| variable
	| string_literal
	| int_literal
	| identifier
	| builtin
	| '(' term ')'
	;

term :
	atomic_term
	| identifier arguments
	| builtin arguments
	;

builtin :
	"BOOLEAN_TRUE"
	| "BOOLEAN_FALSE"
	| "NAT_ZERO"
	| "NAT_SUCC"
	| "INT_PLUS"
	| "INT_MINUS"
	| "INT_TIMES"
	| "STRING_CONCAT"
	;

%%

%%

[ \t\r\n]+	skip()
"#"[ \t].*	skip()

"<="	"<="
"<"	'<'
"=="	"=="
">="	">="
">"	'>'
","	','
":-"	":-"
"!="	"!="
"."	'.'
"("	'('
")"	')'
"{"	'{'
"}"	'}'
"BOOLEAN_FALSE"	"BOOLEAN_FALSE"
"BOOLEAN_TRUE"	"BOOLEAN_TRUE"
"#builtin"	"#builtin"
"#demand"	"#demand"
"#forbid"	"#forbid"
"INT_MINUS"	"INT_MINUS"
"INT_PLUS"	"INT_PLUS"
"INT_TIMES"	"INT_TIMES"
"is?"	"is?"
"is"	"is"
"#lazy"	"#lazy"
"NAT_SUCC"	"NAT_SUCC"
"NAT_ZERO"	"NAT_ZERO"
"STRING_CONCAT"	"STRING_CONCAT"

[A-Z][a-zA-Z0-9_]*	variable
_[a-zA-Z0-9_]*	wildcard // and represents variable names that you wish to be ignored.
[a-z][a-zA-Z0-9_]*	identifier
\"[^"]+\"	string_literal //is a regular string constant with no escape characters: two double quotes " surrounding any ASCII character in the range 32-126 except for " and \.
0|-?[1-9][0-9]*	int_literal

%%
