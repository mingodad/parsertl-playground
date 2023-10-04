// Lua 5.3 Bison parser and transpiler by Robert van Engelen
// Eliminated reduce/reduce conflict by expanding the prefixexp nonterminal
// Expanded the repetition nonterminal
// Renamed long nonterminal names functiondef->function, functioncall->funccall, tableconstructor->table
// Requires lua.l, lua.y, lua.hpp

/*Tokens*/
%token NAME
%token INTEGER
%token FLOAT
%token STRING
%token AND
%token BREAK
%token DO
%token ELSE
%token ELSEIF
%token END
%token FALSE
%token FOR
%token FUNCTION
%token GOTO
%token IF
%token IN
%token LOCAL
%token NIL
%token NOT
%token OR
%token REPEAT
%token RETURN
%token THEN
%token TRUE
%token UNTIL
%token WHILE
%token EQU
%token NEQ
%token LTE
%token GTE
%token CAT
%token SHL
%token SHR
%token DIV
%token DOTS
%token COLS
%token '#'
%token '%'
%token '&'
%token '('
%token ')'
%token '*'
%token '+'
%token ','
%token '-'
%token '.'
%token '/'
%token ':'
%token ';'
%token '<'
%token '='
%token '>'
%token '['
%token ']'
%token '^'
%token '{'
%token '|'
%token '}'
%token '~'

%left /*1*/ OR
%left /*2*/ AND
%left /*3*/ EQU NEQ LTE GTE '<' '>'
%left /*4*/ '|'
%left /*5*/ '~'
%left /*6*/ '&'
%left /*7*/ SHL SHR
%right /*8*/ CAT
%left /*9*/ '+' '-'
%left /*10*/ DIV '%' '*' '/'
%right /*11*/ NOT '#'
%right /*12*/ '^'

%start chunk

%%

chunk :
	block
	;

semi :
	';'
	| /*empty*/
	;

block :
	scope statlist
	| scope statlist laststat semi
	;

scope :
	/*empty*/
	| scope statlist binding semi
	;

statlist :
	/*empty*/
	| statlist stat semi
	;

stat :
	DO block END
	| IF conds END
	| WHILE exp DO block END
	| REPEAT block UNTIL exp
	| FOR NAME '=' explist23 DO block END
	| FOR namelist IN explist1 DO block END
	| FUNCTION funcname funcbody
	| GOTO NAME
	| label
	| setlist '=' explist1
	| funccall
	//| error DO
	//| error IF
	//| error WHILE
	//| error FOR
	//| error REPEAT
	//| error FUNCTION
	//| error GOTO
	//| error COLS
	//| error LOCAL
	//| error BREAK
	//| error RETURN
	//| error END
	//| error ';'
	;

conds :
	condlist
	| condlist ELSE block
	;

condlist :
	cond
	| condlist ELSEIF cond
	;

cond :
	exp THEN block
	;

laststat :
	BREAK
	| RETURN
	| RETURN explist1
	;

label :
	COLS NAME COLS
	;

binding :
	LOCAL namelist
	| LOCAL namelist '=' explist1
	| LOCAL FUNCTION NAME funcbody
	;

funcname :
	dottedname
	| dottedname ':' NAME
	;

dottedname :
	NAME
	| dottedname '.' NAME
	;

namelist :
	NAME
	| namelist ',' NAME
	;

explist1 :
	exp
	| explist1 ',' exp
	;

explist23 :
	exp ',' exp
	| exp ',' exp ',' exp
	;

exp :
	NIL
	| TRUE
	| FALSE
	| INTEGER
	| FLOAT
	| STRING
	| DOTS
	| function
	| table
	| var
	| funccall
	| NOT /*11R*/ exp
	| '#' /*11R*/ exp
	| '-' /*9L*/ exp %prec NOT /*11R*/
	| '~' /*5L*/ exp %prec NOT /*11R*/
	| exp OR /*1L*/ exp
	| exp AND /*2L*/ exp
	| exp '<' /*3L*/ exp
	| exp LTE /*3L*/ exp
	| exp '>' /*3L*/ exp
	| exp GTE /*3L*/ exp
	| exp EQU /*3L*/ exp
	| exp NEQ /*3L*/ exp
	| exp '|' /*4L*/ exp
	| exp '~' /*5L*/ exp
	| exp '&' /*6L*/ exp
	| exp SHL /*7L*/ exp
	| exp SHR /*7L*/ exp
	| exp CAT /*8R*/ exp
	| exp '+' /*9L*/ exp
	| exp '-' /*9L*/ exp
	| exp '*' /*10L*/ exp
	| exp '/' /*10L*/ exp
	| exp DIV /*10L*/ exp
	| exp '%' /*10L*/ exp
	| exp '^' /*12R*/ exp
	| '(' exp ')'
	;

setlist :
	var
	| setlist ',' var
	;

var :
	NAME
	| var '[' exp ']'
	| var '.' NAME
	| funccall '[' exp ']'
	| funccall '.' NAME
	| '(' exp ')' '[' exp ']'
	| '(' exp ')' '.' NAME
	;

funccall :
	var args
	| var ':' NAME args
	| funccall args
	| funccall ':' NAME args
	| '(' exp ')' args
	| '(' exp ')' ':' NAME args
	;

args :
	'(' ')'
	| '(' explist1 ')'
	| table
	| STRING
	;

function :
	FUNCTION funcbody
	;

funcbody :
	params block END
	;

params :
	'(' parlist ')'
	;

parlist :
	/*empty*/
	| namelist
	| DOTS
	| namelist ',' DOTS
	;

table :
	'{' '}'
	| '{' fieldlist '}'
	| '{' fieldlist ',' '}'
	| '{' fieldlist ';' '}'
	;

fieldlist :
	field
	| fieldlist ',' field
	| fieldlist ';' field
	;

field :
	exp
	| NAME '=' exp
	| '[' exp ']' '=' exp
	;

%%

%x LONGCOMMENT LONGSTRING

digit                           [0-9]
alpha                           [a-zA-Z_]
name                            {alpha}({alpha}|{digit})*
integer                         {digit}+|0[xX][0-9a-fA-F]+
exp                             [eE][-+]?{digit}+
float                           {digit}+\.{digit}*{exp}?
string                          \"(\\.|[^\\"\n])*\"|'(\\.|[^\\'\n])*'
longbracket                     \[=*\[

%%

[[:space:]]+                    skip() /* skip white space */
<INITIAL>"--"{longbracket}<LONGCOMMENT>
"--".*                          skip() /* ignore inline comment */

"and"	AND
"break"	BREAK
"do"	DO
"else"	ELSE
"elseif"	ELSEIF
"end"	END
"false"	FALSE
"for"	FOR
"function"	FUNCTION
"goto"	GOTO
"if"	IF
"in"	IN
"local"	LOCAL
"nil"	NIL
"not"	NOT
"or"	OR
"repeat"	REPEAT
"return"	RETURN
"then"	THEN
"true"	TRUE
"until"	UNTIL
"while"	WHILE

<INITIAL>{longbracket}<LONGSTRING>
"=="                            EQU
"~="                            NEQ
"<="                            LTE
">="                            GTE
"<<"                            SHL
">>"                            SHR
"//"                            DIV
".."                            CAT
"..."                           DOTS
"::"                            COLS

/*[#%&()*+,\-./:;<=>\[\]^{|}~]    LuaParser::symbol_type(chr()*/

"#"	'#'
"%"	'%'
"&"	'&'
"("	'('
")"	')'
"*"	'*'
"+"	'+'
","	','
"-"	'-'
"."	'.'
"/"	'/'
":"	':'
";"	';'
"<"	'<'
"="	'='
">"	'>'
"["	'['
"]"	']'
"^"	'^'
"{"	'{'
"|"	'|'
"}"	'}'
"~"	'~'


/*<<EOF>>                         LuaParser::make_EOF(location()); }*/

<LONGCOMMENT>\]=*\]<INITIAL>	skip()
<LONGCOMMENT>.|\n<.>                          /* ignore long comment */
/*<<EOF>>                         { yy::Parser::syntax_error(location(), "long comment not closed"); }*/


<LONGSTRING>\]=*\]<INITIAL>	STRING
<LONGSTRING>.|\n<.>
/*<<EOF>>                         { yy::Parser::syntax_error(location(), "long string not closed"); }*/

/* Order matter if identifier comes before keywords they are classified as identifier */
{name}                          NAME
{integer}                       INTEGER
{float}                         FLOAT
{string}                        STRING

%%
