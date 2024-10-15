//From: https://github.com/daniel-thompson/pdc/blob/85273bd3d95be1e2fee516571ca4ccbaf9d64046/pdc.y

/*Tokens*/
%token AND
%token DEC
%token DIV
%token EQ
%token FUNCTION
%token GE
%token INC
%token INTEGER
%token LE
%token LEFT
%token LEFT_SHIFT
%token LOGICAL_AND
%token LOGICAL_OR
%token MOD
%token MUL
%token NE
%token NEG
%token OR
%token RIGHT
%token RIGHT_SHIFT
%token VARIABLE
%token XOR

%token '^'
%token '~'
%token '<'
%token '='
%token '>'
%token '|'
%token '-'
%token ','
%token ':'
%token '!'
%token '?'
%token '/'
%token '('
%token ')'
%token '*'
%token '&'
%token '%'
%token '+'
%token '\n'

%right /*1*/ '=' INC DEC MUL DIV MOD AND XOR OR LEFT RIGHT
%right /*2*/ '?' ':'
%left /*3*/ LOGICAL_OR
%left /*4*/ LOGICAL_AND
%left /*5*/ '|'
%left /*6*/ '^'
%left /*7*/ '&'
%left /*8*/ EQ NE
%left /*9*/ '<' LE '>' GE
%left /*10*/ LEFT_SHIFT RIGHT_SHIFT
%left /*11*/ '+' '-'
%left /*12*/ '*' '/' '%'
%left /*13*/ '!' '~' NEG

%start input

%%

input :
	/*empty*/
	| input line
	;

line :
	expression '\n'
	| expression ','
	| '\n'
	//| error '\n'
	;

expression :
	INTEGER
	| VARIABLE
	| FUNCTION '(' expression ')'
	| FUNCTION '(' ')'
	//| FUNCTION expression
	//| FUNCTION
	| VARIABLE '=' /*1R*/ expression
	| VARIABLE INC /*1R*/ expression
	| VARIABLE DEC /*1R*/ expression
	| VARIABLE MUL /*1R*/ expression
	| VARIABLE DIV /*1R*/ expression
	| VARIABLE MOD /*1R*/ expression
	| VARIABLE AND /*1R*/ expression
	| VARIABLE XOR /*1R*/ expression
	| VARIABLE OR /*1R*/ expression
	| VARIABLE LEFT /*1R*/ expression
	| VARIABLE RIGHT /*1R*/ expression
	| expression '?' /*2R*/ expression ':' /*2R*/ expression
	| expression '+' /*11L*/ expression
	| expression '-' /*11L*/ expression
	| expression '|' /*5L*/ expression
	| expression '^' /*6L*/ expression
	| expression '*' /*12L*/ expression
	| expression '/' /*12L*/ expression
	| expression '%' /*12L*/ expression
	| expression '&' /*7L*/ expression
	| expression '<' /*9L*/ expression
	| expression '>' /*9L*/ expression
	| expression EQ /*8L*/ expression
	| expression LE /*9L*/ expression
	| expression GE /*9L*/ expression
	| expression NE /*8L*/ expression
	| '~' /*13L*/ expression
	| '-' /*11L*/ expression %prec NEG /*13L*/
	| expression LEFT_SHIFT /*10L*/ expression
	| expression RIGHT_SHIFT /*10L*/ expression
	| expression LOGICAL_AND /*4L*/ expression
	| expression LOGICAL_OR /*3L*/ expression
	| '!' /*13L*/ expression
	| '(' expression ')'
	;

%%

num_suffix	[KMGbB_]

%%

[ \t]+  skip()

"^"	'^'
"~"	'~'
"<"	'<'
"="	'='
">"	'>'
"|"	'|'
"-"	'-'
","	','
":"	':'
"!"	'!'
"?"	'?'
"/"	'/'
"("	'('
")"	')'
"*"	'*'
"&"	'&'
"%"	'%'
"+"	'+'
"\n"	'\n'

"&="	AND
"-="	DEC
"/="	DIV
"=="	EQ
FUNCTION	FUNCTION
">="	GE
"+="	INC
"<="	LE
"<<="	LEFT
"<<"	LEFT_SHIFT
"&&"	LOGICAL_AND
"||"	LOGICAL_OR
"%="	MOD
"*="	MUL
"!="	NE
"|="	OR
">>="	RIGHT
">>"	RIGHT_SHIFT
"^="	XOR

//Predefined variables
"ans"	VARIABLE	//"the result of the previous calculation"
"ibase"	VARIABLE	//"the default input base (to force decimal use 0d10)"
"obase"	VARIABLE	//"the output base (set to zero or one for combined bases)"
"pad"	VARIABLE	//"the amount of zero padding used when displaying numbers"
"N"	VARIABLE	//"global variable used by the bitfield function"
"K"	VARIABLE	//"Defaults to KiB (1024 bytes)"
"M"	VARIABLE	//"Defaults to MiB (1048576 bytes)"
"G"	VARIABLE	//"Defaults to GiB (1073741824 bytes)"

//Predefined functions
"abs"	FUNCTION	//"get the absolute value of x"
"ascii"	FUNCTION	//"convert x into a character constant"
"bin"	FUNCTION	//"change output base to binary"
"bitcnt"	FUNCTION	//"get the population count of x"
"bitfield"	FUNCTION	//"extract the bottom x bits of N and shift N"
"bits"	FUNCTION	//"alias for decompose"
"dec"	FUNCTION	//"set the output base to decimal"
"decompose"	FUNCTION	//"decompose x into a list of bits set"
"default"	FUNCTION	//"set the default output base (decimal and hex)"
"dxb"	FUNCTION	//"output in decimal, hex and binary"
"help"	FUNCTION	//"display this help message"
"hex"	FUNCTION	//"change output base to hex"
"lssb"	FUNCTION	//"get the least significant set bit in x"
"mssb"	FUNCTION	//"get the most significant set bit in x"
"oct"	FUNCTION	//"change output base to octal"
"print"	FUNCTION	//"print an expression (useful for command line work)"
"quit"	FUNCTION	//"leave pdc"
"swap32"	FUNCTION	//"perform a 32-bit byte swap"
"version"	FUNCTION	//"display version information"
"warranty"	FUNCTION	//"display warranty and licencing information"

[1-9][0-9]*{num_suffix}?	INTEGER
"0"[dD][0-9]+	INTEGER
"0"[xX][0-9A-Fa-f]+	INTEGER
"0"[bB][0-1]+	INTEGER
"0"[0-8]+	INTEGER

'(\\.|[^'\r\n\\])'	INTEGER

[A-Za-z_][A-Za-z0-9_]*	VARIABLE

%%
