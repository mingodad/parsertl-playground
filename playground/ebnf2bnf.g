//From: https://www.codeproject.com/articles/1089463/convert-ebnf-to-bnf-using-parsertl-lexertl

%token IDENTIFIER LHS TERMINAL

%%

start :
	grammar
	;

grammar :
	rule
	| grammar rule
	;

rule :
	lhs rhs_or opt_semi
	;

opt_semi :
	%empty
	| ';'
	;

lhs :
	LHS
	;

rhs_or :
	opt_list
	| rhs_or '|' opt_list
	;

opt_list :
	%empty
	| rhs_list
	;

rhs_list :
	rhs
	| rhs_list opt_comma rhs
	;

opt_comma :
	%empty
	| ','
	;

rhs :
	IDENTIFIER
	| TERMINAL
	| '[' rhs_or ']'
	| rhs '?'
	| '{' rhs_or '}'
	| rhs '*'
	| '{' rhs_or '}' '-'
	| rhs '+'
	| '(' rhs_or ')'
	;

%%

NAME [A-Za-z][_0-9A-Za-z]*

ESCAPED	\\([^0-9cx]|[0-9]{1,3}|c[@a-zA-Z]|x\d+)

%%

{NAME}	IDENTIFIER
{NAME}\s*[:=]	LHS
","	','
";"	';'
\[	'['
\]	']'
[?]	'?'
[{]	'{'
[}]	'}'
[*]	'*'
[(]	'('
[)]	')'
[|]	'|'
[+]	'+'
"-"	'-'
'({ESCAPED}|[^'])+'	TERMINAL
[\"]({ESCAPED}|[^\"])+[\"]	TERMINAL
"#"[^\r\n]*|\s+|[(][*](.{+}[\r\n])*?[*][)]	skip()

%%
