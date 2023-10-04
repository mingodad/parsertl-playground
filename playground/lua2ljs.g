//From: https://github.com/mingodad/ljs/blob/master/lua2ljs/lua-parser.ly

%token  LPAREN SEMICOLON UNTIL DO END
%token  WHILE REPEAT IF FUNCTION ASSIGN GOTO
%token  LABEL FOR IN ELSE ELSEIF THEN
%token  BREAK RETURN LOCAL COLON DOT COMMA
%token  OR AND EQ NEQ LT LTEQ
%token  BT BTEQ CONCAT PLUS MINUS MUL
%token  DIV MOD NOT LEN POW NIL
%token  TRUE FALSE NUMBER ELLIPSIS IDIV SHL
%token  SHR BITAND BITOR BITNOT LBRACKET RBRACKET
%token  RPAREN LBRACE RBRACE NAME STRING LONGSTRING


%left /*1*/ OR
%left /*2*/ AND
%nonassoc /*3*/ EQ NEQ
%nonassoc /*4*/ LT LTEQ BT BTEQ
%right /*5*/ CONCAT
%left /*6*/ PLUS MINUS
%left /*7*/ MUL DIV MOD
%right /*8*/ NOT LEN
%right /*9*/ POW
%left /*10*/ IDIV SHL SHR
%left /*11*/ BITAND BITOR
%right /*12*/ BITNOT

%start chunk

%%

chunk : block ;

semi : /*empty*/ ;
semi : SEMICOLON ;

block : scope statlist ;
block : scope statlist laststat semi ;

ublock : block UNTIL exp ;

scope : /*empty*/ ;
scope : scope statlist binding semi ;

statlist : /*empty*/ ;
statlist : statlist stat semi ;

stat : DO block END ;
stat : WHILE exp DO block END ;
stat : repetition DO block END ;
stat : REPEAT ublock ;
stat : IF conds END ;
stat : FUNCTION funcname funcbody ;
stat : setlist ASSIGN explist1 ;
stat : functioncall ;
stat : GOTO ident ;
stat : LABEL ;

repetition : FOR ident ASSIGN explist23 ;
repetition : FOR namelist IN explist1 ;

conds : condlist ;
conds : condlist ELSE block ;

condlist : cond ;
condlist : condlist ELSEIF cond ;

cond : exp THEN block ;

laststat : BREAK ;
laststat : RETURN ;
laststat : RETURN explist1 ;

binding : LOCAL namelist ;
binding : LOCAL namelist ASSIGN explist1 ;
binding : LOCAL FUNCTION ident funcbody ;

funcname : dottedname ;
funcname : dottedname COLON ident ;

dottedname : ident ;
dottedname : dottedname DOT ident ;

namelist : ident ;
namelist : namelist COMMA ident ;

explist1 : exp ;
explist1 : explist1 COMMA exp ;

explist23 : exp COMMA exp ;
explist23 : exp COMMA exp COMMA exp ;

exp : NIL ;
exp : TRUE ;
exp : FALSE ;
exp : NUMBER ;
exp : string ;
exp : ELLIPSIS ;
exp : function ;
exp : prefixexp ;
exp : tableconstructor ;
exp : NOT /*8R*/ exp %prec NOT /*8R*/ ;
exp : LEN /*8R*/ exp %prec NOT /*8R*/ ;
exp : MINUS /*6L*/ exp %prec NOT /*8R*/ ;
exp : exp OR /*1L*/ exp ;
exp : exp AND /*2L*/ exp ;
exp : exp LT /*4N*/ exp ;
exp : exp LTEQ /*4N*/ exp ;
exp : exp BT /*4N*/ exp ;
exp : exp BTEQ /*4N*/ exp ;
exp : exp EQ /*3N*/ exp ;
exp : exp NEQ /*3N*/ exp ;
exp : exp CONCAT /*5R*/ exp ;
exp : exp PLUS /*6L*/ exp ;
exp : exp MINUS /*6L*/ exp ;
exp : exp MUL /*7L*/ exp ;
exp : exp DIV /*7L*/ exp ;
exp : exp MOD /*7L*/ exp ;
exp : exp POW /*9R*/ exp ;
exp : BITNOT /*12R*/ exp %prec NOT /*8R*/ ;
exp : exp IDIV /*10L*/ exp ;
exp : exp SHL /*10L*/ exp ;
exp : exp SHR /*10L*/ exp ;
exp : exp BITAND /*11L*/ exp ;
exp : exp BITOR /*11L*/ exp ;
exp : exp BITNOT /*12R*/ exp ;

setlist : var ;
setlist : setlist COMMA var ;

var : ident ;
var : prefixexp LBRACKET exp RBRACKET ;
var : prefixexp DOT ident ;

prefixexp : var ;
prefixexp : functioncall ;
prefixexp : LPAREN exp RPAREN ;

functioncall : prefixexp args ;
functioncall : prefixexp COLON ident args ;

args : LPAREN RPAREN ;
args : LPAREN explist1 RPAREN ;
args : tableconstructor ;
args : string ;

function : FUNCTION funcbody ;

funcbody : params block END ;

params : LPAREN parlist RPAREN ;

parlist : /*empty*/ ;
parlist : ELLIPSIS ;
parlist : namelist ;
parlist : namelist COMMA ELLIPSIS ;

tableconstructor : LBRACE RBRACE ;
tableconstructor : LBRACE fieldlist RBRACE ;
tableconstructor : LBRACE fieldlist fieldsep RBRACE ;

fieldsep : COMMA ;
fieldsep : SEMICOLON ;

fieldlist : field ;
fieldlist : fieldlist fieldsep field ;

field : exp ;
field : ident ASSIGN exp ;
field : LBRACKET exp RBRACKET ASSIGN exp ;

ident : NAME ;

string : STRING ;
string : LONGSTRING ;

%%

%x LongString

D        [0-9]
E        [Ee][+-]?{D}+
L        [a-zA-Z_]

INTSUFFIX   "LL"|"ULL"|"ll"|"ull"

HEX_P    [Pp][+-]?{D}+
HEX_PREFIX	0[xX]
HEX_DIGIT [0-9a-fA-F]

FLOATNUMBER   ({D}+|{HEX_PREFIX}{HEX_DIGIT}+){E}|({D}*"."{D}+|{D}+"."{D}*|{HEX_PREFIX}({HEX_DIGIT}*"."{HEX_DIGIT}+|{HEX_DIGIT}+"."{HEX_DIGIT}*)){E}?

CPLXNUMBER   ({D}+"."{D}+)"i"

INTNUMBER   {D}+{INTSUFFIX}?
HEXNUM	({HEX_PREFIX}{HEX_DIGIT}+)({HEX_P}|{INTSUFFIX})?

WS       [ \t\r\v\f]
LF       [\n]

STRINGSQ  '(\\.|[^'\n\r\\])*'
STRINGDQ  \"(\\.|[^\"\n\r\\])*\"

IDENTIFIER {L}({L}|{D})*

COMMENT	"--"[^\n\r]*
/*comment : LONGCOMMENT ;*/

%%

{WS}	skip()
{LF}		skip()
{COMMENT}	skip()

"and"	AND
"="	ASSIGN
"&"	BITAND
"~"	BITNOT
"|"	BITOR
"break"	BREAK
">"	BT
">="	BTEQ
":"	COLON
","	COMMA
".."	CONCAT
"/"	DIV
"do"	DO
"."	DOT
"..."	ELLIPSIS
"else"	ELSE
"elseif"	ELSEIF
"end"	END
"=="	EQ
"false"	FALSE
"for"	FOR
"function"	FUNCTION
"goto"	GOTO
"//"	IDIV
"if"	IF
"in"	IN
"::"{IDENTIFIER}"::"	LABEL
"{"	LBRACE
"["	LBRACKET
"#"	LEN
"local"	LOCAL
"("	LPAREN
"<="	LTEQ
"<"	LT
"-"	MINUS
"%"	MOD
"*"	MUL
"~="	NEQ
"nil"	NIL
"not"	NOT
"or"	OR
"+"	PLUS
"^"	POW
"}"	RBRACE
"]"	RBRACKET
"repeat"	REPEAT
"return"	RETURN
")"	RPAREN
;	SEMICOLON
"<<"	SHL
">>"	SHR
"then"	THEN
"true"	TRUE
"until"	UNTIL
"while"	WHILE

<INITIAL>"["=*"["<LongString>
<LongString>"]"=*"]"<INITIAL> 	LONGSTRING
<LongString>(?s:.)+<.>

{STRINGSQ}	STRING
{STRINGDQ}	STRING
{FLOATNUMBER} 	NUMBER
{INTNUMBER}    NUMBER
{HEXNUM}           NUMBER
{CPLXNUMBER}  NUMBER
{IDENTIFIER}	NAME

%%
