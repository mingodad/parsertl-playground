//From: https://www.codeproject.com/articles/1089463/convert-ebnf-to-bnf-using-parsertl-lexertl
//adapted to parse GGML for https://github.com/ggerganov/llama.cpp/tree/master/grammars

%token NON_TERMINAL LHS TERMINAL CHARSET NEG_CHARSET RUSEP

%%

start :
	grammar
	;

grammar :
	rule
	| grammar rule
	;

rule :
	lhs RUSEP rhs_or
	;

lhs :
	LHS
	;

rhs_or :
	opt_list
	| rhs_or '|' opt_list
	;

opt_list :
	%empty #empty
	| rhs_list
	;

rhs_list :
	rhs
	| rhs_list rhs
	;

rhs :
	NON_TERMINAL
	| TERMINAL
	| CHARSET
	| NEG_CHARSET
	| rhs '?' #rhs_ooz
	| rhs '*' #rhs_zom
	| rhs '+' #rhs_oom
	| '(' rhs_or ')'
	;

%%

%x ruleHead

NAME [A-Za-z][_0-9A-Za-z-]*
RUSEP "::="

INNER_CHRSET    (\\.|[^\]\n\r\\])+

%%

\s+	skip()
"#".*	skip()

[?]	'?'
[*]	'*'
[(]	'('
[)]	')'
[|]	'|'
[+]	'+'

"[^"{INNER_CHRSET}"]"    NEG_CHARSET
//order in simportant NEG_CHARSET comes before CHARSET
"["{INNER_CHRSET}"]"    CHARSET

{NAME}\s*{RUSEP}<ruleHead>    reject()
<ruleHead> {
    {NAME}	LHS
    \s+ skip()
    {RUSEP}<INITIAL> RUSEP
}

["](\\.|[^"\n\r\\])+["]	TERMINAL

{NAME}	NON_TERMINAL

%%
