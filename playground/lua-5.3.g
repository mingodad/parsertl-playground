//From: https://github.com/Robert-van-Engelen/lua-to-lisp/blob/b04a56642e07f52bc963fd9e51302156445bcd17/lua.y
// Lua 5.3 Bison parser and transpiler by Robert van Engelen
// Eliminated reduce/reduce conflict by expanding the prefixexp nonterminal
// Expanded the repetition nonterminal
// Renamed long nonterminal names functiondef->function, functioncall->funccall, tableconstructor->table
// Requires lua.l, lua.y, lua.hpp

/*Tokens*/
%token AND
%token BREAK
%token CAT
%token COLS
%token DIV
%token DO
%token DOTS
%token ELSE
%token ELSEIF
%token END
%token EQU
%token FALSE
%token FLOAT
%token FOR
%token FUNCTION
%token GOTO
%token GTE
%token IF
%token IN
%token INTEGER
%token LOCAL
%token LTE
%token NAME
%token NEQ
%token NIL
%token NOT
%token OR
%token REPEAT
%token RETURN
%token SHL
%token SHR
%token STRING
%token THEN
%token TRUE
%token UNTIL
%token WHILE

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
	| FOR NAME '=' explist_2_or_3 DO block END
	| FOR namelist IN exprlist DO block END
	| FUNCTION funcname funcbody
	| GOTO NAME
	| label
	| setlist '=' exprlist
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
	| RETURN exprlist
	;

label :
	COLS NAME COLS
	;

binding :
	LOCAL namelist
	| LOCAL namelist '=' exprlist
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

exprlist :
	exp
	| exprlist ',' exp
	;

explist_2_or_3 :
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
	| '(' exprlist ')'
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
"--"{longbracket}<LONGCOMMENT>
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

{longbracket}<LONGSTRING>
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
