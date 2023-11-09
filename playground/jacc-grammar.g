/*
Jacc grammar
https://github.com/zipwith/jacc
https://web.cecs.pdx.edu/~mpj/jacc/jacc.pdf
*/

%token NONTERMINAL TERMINAL PREC ACTION

%%

rules :
	rules rule // a list of zero or more
	| /* empty */ // rules
	;

rule :
	NONTERMINAL ':' rhses ';' // one rule can represent
	; // several productions

rhses :
	rhses '|' rhs // one or more rhs’es
	| rhs // separated by "|"s
	;

rhs :
	symbols optPrec optAction // the right hand side of
	; // a production

symbols :
	symbols symbol // a list of zero or more
	| /* empty */ // symbols
	;

symbol :
	TERMINAL // the union of terminals
	| NONTERMINAL // and nonterminals
	;

optPrec :
	PREC TERMINAL // an optional precedence
	| /* empty */
	;

optAction :
	ACTION // and optional action
	| /* empty */
	;

%%

%x ACTION

line_comment	"//".*
block_comment	"/*"(?s:.)*?"*/"

dq_string	\"(\\.|[^"\n\r\\])+\"
sq_string	'(\\.|[^'\n\r\\])+\'

%%

[\n\r\t ]+	skip()
{line_comment}	skip()
{block_comment}	skip()

":" ':'
";" ';'
"|" '|'

"%prec"    PREC
"{"<>ACTION>
<ACTION> {
	"{"<>ACTION>
	"}"<<>	ACTION
	{dq_string}<.>
	{sq_string}<.>
	{line_comment}<.>
	{block_comment}<.>
	\n|.<.>
}

{dq_string}	TERMINAL
{sq_string}	TERMINAL
[A-Za-z_][A-Za-z0-9_]*	NONTERMINAL

%%
