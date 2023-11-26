//From: https://github.com/lambduli/minilog/blob/ccde1395471bbc33813d1cc588755a1d5c4df759/src/Parser.y
/*
Replaced right recursion by left recursion
*/

%token VAR ATOM

%%

Base :
	Predicates
	;

Predicates :
	Predicate
	|   Predicates Predicate
	;

Predicate :
	Struct '.'
	|   Struct ":-" Body
	;

Body :
	Goals '.'
	;

Struct :
	ATOM '(' Terms ')'
	;


Terms :
	Term
	|   Terms ',' Term
	;

Term :
	VAR
	|   ATOM
	|   Struct
	|   '_'
	;

Goals :
	Goal
	|   Goals ',' Goal
	;

Goal :
	Struct
	|   Term '=' Term
	;

%%

upper	[A-Z]
lower	[a-z]

variableident	{upper}+
atomident	{lower}+

space	[\ \t\f\v\n]

%%

{space}+	skip()
"%".*	skip()

","  	','     // Token.Comma
"."  	'.'     // Token.Period
":-"	":-"    // Token.If
"="	'='     // Token.Equal
"(" 	'('     // Token.ParenOpen
")" 	')'     // Token.ParenClose
"_" 	'_'     // Token.Underscore

{variableident}	VAR
{atomident}	ATOM

%%
