//From: https://github.com/kach/nearley/blob/6e24450f2b19b5b71557adf72ccd580f4e452b09/lib/nearley-language-bootstrapped.ne

/*
Changed '[' wordlist ']' to '<' wordlist '>' and '[' expressionlist ']' to '<' expressionlist '>'
due to ambiguity with CHARCLASS .
*/

%token RULE_NAME
%token ARROW
%token WORD
%token STRING
%token BTSTRING
%token CHARCLASS
%token JS


%%

final :
	prog
	;

prog : prod
	| prog prod
	;

prod :
	rule_head expression_plus
	| '@' js
	| '@' word word
	| "@include" string
	| "@builtin" string
	;

rule_head :
	RULE_NAME ARROW
	| word '<' wordlist '>' ARROW
    ;

expression_plus :
	completeexpression
	| expression_plus '|' completeexpression
	;

expressionlist :
	completeexpression
	| expressionlist ',' completeexpression
	;

wordlist :
	word
	| wordlist ',' word
	;

completeexpression :
	expr
	| expr js
	;

expr_member :
	word
	| '$' word
	| word '<' expressionlist '>'
	| string
	| string 'i'
	| '%' word
	| charclass
	| '(' expression_plus ')'
	| expr_member ebnf_modifier
	;

ebnf_modifier :
	":+"
	| ":*"
	| ":?"
	;

expr :
	expr_member
	| expr expr_member
	;

word :
	WORD
	;

string :
	STRING
	| BTSTRING
	;

charclass :
	CHARCLASS
	;

js :
	JS
	;

%%

%x rule_name

ARROW   "->"
WORD    [A-Za-z_][A-Za-z0-9_]*\+?

%%

[\n\r\t ]+	skip()
"#".*	skip()

"|"	'|'
","	','
"("	'('
")"	')'
"<"	'<'
">"	'>'
"@"	'@'
"$"	'$'
"%"	'%'
"i"	'i'

":?"	":?"
":*"	":*"
":+"	":+"

"@builtin"	"@builtin"
"@include"	"@include"

{ARROW} ARROW
{WORD}\s*{ARROW}<rule_name>  reject()
<rule_name> {
    {WORD}  RULE_NAME
    \s+ skip()
    {ARROW}<INITIAL>    ARROW
}
{WORD}	WORD
\"(\\.|[^"\n\r\\])+\"	STRING
\`(\\.|[^`\n\r\\])+\`	BTSTRING
\.|\[(?:\\.|[^\\\n])+?\]	CHARCLASS
"{%"(?s:.)*?"%}"	JS

%%
