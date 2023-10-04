%token ANY ident string char
%token COMPILER IGNORECASE TERMINALS CHARACTERS
%token TOKENS PRAGMAS COMMENTS FROM TO NESTED
%token IGNORE PRODUCTIONS END
%token semtext attrdecl

%%

coco :
	//ANY*
	COMPILER ident
	//ANY*
	IGNORECASE?
	(TERMINALS ident*)?
	(CHARACTERS SetDecl*)?
	(TOKENS TokenDecl*)?
	(PRAGMAS TokenDecl*)?
	(COMMENTS FROM TokenExpr TO TokenExpr NESTED?)*
	(IGNORE Set)*
	PRODUCTIONS (ident AttrDecl? SemText? '=' Expression '.')*
	END ident '.'
	;

SetDecl :
	ident '=' Set '.'
	;

Set :
	SimSet ('+' SimSet | '-' SimSet)*
	;

SimSet :
	ident
	| string
	| Char (".." Char)?
	| "ANY"
	;

Char :
	char
	;

TokenDecl :
	Sym (':' Sym)? ( '=' TokenExpr '.')? SemText?
	;

AttrDecl :
	attrdecl
	;

Expression :
	Term ('|' Term)*
	;

Term :
	Resolver? Factor+
	;

Factor :
	"WEAK"? Sym Attribs?
	| '(' Expression ')'
	| '[' Expression ']'
	| '{' Expression '}'
	| SemText
	| "ANY"
	| "SYNC"
	;

Resolver :
	"IF" '(' Condition
	;

Condition :
	('(' Condition | ANY )* ')'
	;

TokenExpr :
	TokenTerm ('|' TokenTerm)*
	;

TokenTerm :
	TokenFactor+ ("CONTEXT" '(' TokenExpr ')')?
	;

TokenFactor :
	Sym
	|  '(' TokenExpr ')'
	| '[' TokenExpr ']'
	| '{' TokenExpr '}'
	;

Sym :
	ident
	| string
	| char
	;

Attribs :
	attrdecl
	;

SemText :
	semtext
	;

%%

line_comment	"//"[^\n\r]*
block_comment		"/*"(?s:.)*?"*/"
space	[ \t\n\r]

ignore	{space}|{line_comment}|{block_comment}

letter	[A-Za-z_]
digit		[0-9]
cr	\r
lf	\n
tab	\t
hex	[a-f0-9]

ident		{letter}({letter}|{digit})*
number	{digit}{digit}*
printable	[\x20-\x7e]
stringCh	[^\"\r\n\\]
charCh	[^'\r\n\\]
string	\"({stringCh}|"\\"{printable})*\"
badString	\"({stringCh}|"\\"{printable})(cr|lf)
char		'({charCh}|"\\"{printable}|"\\"(u|x){hex}+)'

semtext		"(."(?s:.)*?".)"
attrdecl1	"<"(?s:.)*?">"
attrdecl2	"<."(?s:.)*?".>"
attrdecl	{attrdecl1}|{attrdecl2}

%%

{ignore}+		skip()

{semtext}   semtext
{attrdecl}  attrdecl

"ANY"	"ANY"
CHARACTERS	CHARACTERS
COMMENTS	COMMENTS
COMPILER	COMPILER
"CONTEXT"	"CONTEXT"
END	END
FROM	FROM
IGNORE	IGNORE
IGNORECASE	IGNORECASE
NESTED	NESTED
PRAGMAS	PRAGMAS
PRODUCTIONS	PRODUCTIONS
"SYNC"	"SYNC"
TERMINALS	TERMINALS
TO	TO
TOKENS	TOKENS
"WEAK"	"WEAK"
"IF"	"IF"

"."	'.'
"="	'='
"+"	'+'
"-"	'-'
".."	".."
":"	':'
"|"	'|'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'

.	ANY
{char}	char
{string}	string
{ident}	ident

%%
