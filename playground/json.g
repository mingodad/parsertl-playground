
/** Taken from "The Definitive ANTLR 4 Reference" by Terence Parr */

// Derived from http://json.org
//grammar JSON;

%token STRING NUMBER ILLEGAL_CHARACTHER

%%

json : value ;
obj : '{' pair (',' pair)* '}' | '{' '}' ;
pair : STRING ':' value ;
arr : '[' value (',' value)* ']' | '[' ']' ;
value : STRING | NUMBER | obj | arr | 'true' | 'false' | 'null' ;

%%

HEX	[0-9a-fA-F]
UNICODE	u{HEX}{HEX}{HEX}{HEX}
ESC	\\([\"\\/bfnrt]|{UNICODE})
SAFECODEPOINT	[^"\\\x0000-\x001F]

INT	0|[1-9][0-9]*
// no leading zeros
EXP	[Ee][+\-]?{INT}

WS	[ \t\n\r]+

%%

{WS}	skip()

\"({ESC}|{SAFECODEPOINT})*\"	STRING

-?{INT}(\.[0-9]+)?{EXP}?	NUMBER


\{	'{'
\}	'}'
,	','
:	':'
\[	'['
\]	']'
true	'true'
false	'false'
null	'null'

.	ILLEGAL_CHARACTHER

%%
