//From: https://github.com/jarvinet/scheme/blob/master/src/scparse.y

/*Tokens*/
%token IDENTIFIER
%token NUMBER
%token CHARACTER
%token STRING
%token BEGINVECTOR
%token OPENPAR
%token CLOSEPAR
%token DOT
%token QUOTE
%token QUASIQUOTE
%token UNQUOTE
%token UNQUOTESPLICING
%token TOKEN_TRUE
%token TOKEN_FALSE


%start input

%%

input :
	%empty
	| input datum
	;

datum :
	simpledatum
	| compounddatum
	;

simpledatum :
	boolean
	| number
	| character
	| string
	| symbol
	;

boolean :
	TOKEN_TRUE
	| TOKEN_FALSE
	;

number :
	NUMBER
	;

character :
	CHARACTER
	;

string :
	STRING
	;

symbol :
	IDENTIFIER
	;

compounddatum :
	list
	| vector
	;

list :
	OPENPAR datumzero CLOSEPAR
	| OPENPAR datumone DOT datum CLOSEPAR
	| abbreviation
	;

vector :
	BEGINVECTOR datumzero CLOSEPAR
	;

datumzero :
	datumzero datum
	| /*empty*/
	;

datumone :
	datumzero datum
	;

abbreviation :
	abbrevprefix datum
	;

abbrevprefix :
	QUOTE
	| QUASIQUOTE
	| UNQUOTE
	| UNQUOTESPLICING
	;

%%

letter		   [A-Za-z]
digit		   [0-9]
specialinitial     [!$%&*/:<=>?^_~]
initial            {letter}|{specialinitial}
specialsubsequent  [-+.@]
peculiaridentifier "-"|"+"|"..."
subsequent         ({initial})|{digit}|{specialsubsequent}
identifier	   ({initial})({subsequent})*|{peculiaridentifier}
sign               [+-]
number		   ({sign})?({digit})+("."{digit}+)?

%%

\"(\\.|[^"\n\r\\])*\"        STRING

"#("                    BEGINVECTOR
"(" 			OPENPAR
")"                     CLOSEPAR
"."                     DOT
"'"                     QUOTE
"`"                     QUASIQUOTE
","                     UNQUOTE
",@"                    UNQUOTESPLICING
"#t"                    TOKEN_TRUE
"#f"                    TOKEN_FALSE
{number}		NUMBER
#\\space                CHARACTER
#\\SPACE                CHARACTER
#\\newline              CHARACTER
#\\NEWLINE              CHARACTER
#\\.                    CHARACTER
";".*                 skip()
\n\r?|\r\n?        skip()
[ \t]+               skip()   /* eat up whitespace */
{identifier}		IDENTIFIER

%%
