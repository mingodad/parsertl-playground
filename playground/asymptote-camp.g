//From: https://github.com/vectorgraphics/asymptote/blob/e369a22fd851e63c2f1e75b098a572778f932d86/camp.y
/*****
 * camp.y
 * Andy Hammerlindl 08/12/2002
 *
 * The grammar of the camp language.
 *****/

/*Tokens*/
%token ID
%token SELFOP
%token DOTS
%token COLONS
%token DASHES
%token INCR
%token LONGDASH
%token CONTROLS
%token TENSION
%token ATLEAST
%token CURL
%token COR
%token CAND
%token BAR
%token AMPERSAND
%token EQ
%token NEQ
%token LT
%token LE
%token GT
%token GE
%token CARETS
%token '+'
%token '-'
%token '*'
%token '/'
%token '%'
%token '#'
%token '^'
%token OPERATOR
//%token LOOSE
%token ASSIGN
%token '?'
%token ':'
%token AND
%token '{'
%token '}'
%token '('
%token ')'
%token '.'
%token ','
%token '['
%token ']'
%token ';'
%token ELLIPSIS
%token ACCESS
%token UNRAVEL
%token IMPORT
%token INCLUDE
%token FROM
%token QUOTE
%token STRUCT
%token TYPEDEF
%token NEW
%token IF
%token ELSE
%token WHILE
%token DO
%token FOR
%token BREAK
%token CONTINUE
%token RETURN_
%token THIS
%token EXPLICIT
//%token GARBAGE
%token LIT
%token STRING
%token PERM
%token MODIFIER

%right /*1*/ SELFOP ASSIGN
%right /*2*/ '?' ':'
%left /*3*/ COR
%left /*4*/ CAND
%left /*5*/ BAR
%left /*6*/ AMPERSAND
%left /*7*/ EQ NEQ
%left /*8*/ LT LE GT GE
%left /*9*/ OPERATOR
%left /*10*/ CARETS
%left /*11*/ DOTS COLONS DASHES INCR LONGDASH JOIN_PREC
%left /*12*/ CONTROLS TENSION ATLEAST DIRTAG AND
%left /*13*/ CURL '{' '}'
%left /*14*/ '+' '-'
%left /*15*/ '*' '/' '%' '#' LIT
%left /*16*/ UNARY
%right /*17*/ '^'
%left /*18*/ EXP_IN_PARENS_RULE
%left /*19*/ '(' ')'

%start file

%%

file :
	fileblock
	;

fileblock :
	/*empty*/
	| fileblock runnable
	;

bareblock :
	/*empty*/
	| bareblock runnable
	;

name :
	ID
	| name '.' ID
	| '%' /*15L*/
	;

runnable :
	dec
	| stm
	| modifiers dec
	| modifiers stm
	;

modifiers :
	MODIFIER
	| PERM
	| modifiers MODIFIER
	| modifiers PERM
	;

dec :
	vardec
	| fundec
	| typedec
	| ACCESS stridpairlist ';'
	| FROM name UNRAVEL idpairlist ';'
	| FROM name UNRAVEL '*' /*15L*/ ';'
	| UNRAVEL name ';'
	| FROM strid ACCESS idpairlist ';'
	| FROM strid ACCESS '*' /*15L*/ ';'
	| IMPORT stridpair ';'
	| INCLUDE ID ';'
	| INCLUDE STRING ';'
	| TYPEDEF IMPORT '(' /*19L*/ typeparamlist ')' /*19L*/ ';'
	| IMPORT TYPEDEF '(' /*19L*/ typeparamlist ')' /*19L*/ ';'
	| ACCESS strid '(' /*19L*/ decdeclist ')' /*19L*/ ID ID ';'
	| ACCESS strid '(' /*19L*/ decdeclist ')' /*19L*/ ';'
	| IMPORT strid '(' /*19L*/ decdeclist ')' /*19L*/ ';'
	| FROM strid '(' /*19L*/ decdeclist ')' /*19L*/ ACCESS idpairlist ';'
	;

decdec :
	ID ASSIGN /*1R*/ type
	| type
	;

decdeclist :
	decdec
	| decdeclist ',' decdec
	;

typeparam :
	ID
	;

typeparamlist :
	typeparam
	| typeparamlist ',' typeparam
	;

idpair :
	ID
	| ID ID ID
	;

idpairlist :
	idpair
	| idpairlist ',' idpair
	;

strid :
	ID
	| STRING
	;

stridpair :
	ID
	| strid ID ID
	;

stridpairlist :
	stridpair
	| stridpairlist ',' stridpair
	;

vardec :
	barevardec ';'
	;

barevardec :
	type decidlist
	;

type :
	celltype
	| name dims
	;

celltype :
	name
	;

dims :
	'[' ']'
	| dims '[' ']'
	;

dimexps :
	'[' exp ']'
	| dimexps '[' exp ']'
	;

decidlist :
	decid
	| decidlist ',' decid
	;

decid :
	decidstart
	| decidstart ASSIGN /*1R*/ varinit
	;

decidstart :
	ID
	| ID dims
	| ID '(' /*19L*/ ')' /*19L*/
	| ID '(' /*19L*/ formals ')' /*19L*/
	;

varinit :
	exp
	| arrayinit
	;

block :
	'{' /*13L*/ bareblock '}' /*13L*/
	;

arrayinit :
	'{' /*13L*/ '}' /*13L*/
	| '{' /*13L*/ ELLIPSIS varinit '}' /*13L*/
	| '{' /*13L*/ basearrayinit '}' /*13L*/
	| '{' /*13L*/ basearrayinit ELLIPSIS varinit '}' /*13L*/
	;

basearrayinit :
	','
	| varinits
	| varinits ','
	;

varinits :
	varinit
	| varinits ',' varinit
	;

formals :
	formal
	| ELLIPSIS formal
	| formals ',' formal
	| formals ELLIPSIS formal
	;

explicitornot :
	EXPLICIT
	| /*empty*/
	;

formal :
	explicitornot type
	| explicitornot type decidstart
	| explicitornot type decidstart ASSIGN /*1R*/ varinit
	| explicitornot type ID decidstart
	| explicitornot type ID decidstart ASSIGN /*1R*/ varinit
	;

fundec :
	type ID '(' /*19L*/ ')' /*19L*/ blockstm
	| type ID '(' /*19L*/ formals ')' /*19L*/ blockstm
	;

typedec :
	STRUCT ID block
	| TYPEDEF vardec
	;

slice :
	':' /*2R*/
	| exp ':' /*2R*/
	| ':' /*2R*/ exp
	| exp ':' /*2R*/ exp
	;

value :
	value '.' ID
	| name '[' exp ']'
	| value '[' exp ']'
	| name '[' slice ']'
	| value '[' slice ']'
	| name '(' /*19L*/ ')' /*19L*/
	| name '(' /*19L*/ arglist ')' /*19L*/
	| value '(' /*19L*/ ')' /*19L*/
	| value '(' /*19L*/ arglist ')' /*19L*/
	| '(' /*19L*/ exp ')' /*19L*/ %prec EXP_IN_PARENS_RULE /*18L*/
	| '(' /*19L*/ name ')' /*19L*/ %prec EXP_IN_PARENS_RULE /*18L*/
	| THIS
	;

argument :
	exp
	| ID ASSIGN /*1R*/ exp
	;

arglist :
	argument
	| ELLIPSIS argument
	| arglist ',' argument
	| arglist ELLIPSIS argument
	;

tuple :
	exp ',' exp
	| tuple ',' exp
	;

exp :
	name
	| value
	| LIT /*15L*/
	| STRING
	| LIT /*15L*/ exp
	| '(' /*19L*/ name ')' /*19L*/ exp
	| '(' /*19L*/ name dims ')' /*19L*/ exp
	| '+' /*14L*/ exp %prec UNARY /*16L*/
	| '-' /*14L*/ exp %prec UNARY /*16L*/
	| OPERATOR /*9L*/ exp
	| exp '+' /*14L*/ exp
	| exp '-' /*14L*/ exp
	| exp '*' /*15L*/ exp
	| exp '/' /*15L*/ exp
	| exp '%' /*15L*/ exp
	| exp '#' /*15L*/ exp
	| exp '^' /*17R*/ exp
	| exp LT /*8L*/ exp
	| exp LE /*8L*/ exp
	| exp GT /*8L*/ exp
	| exp GE /*8L*/ exp
	| exp EQ /*7L*/ exp
	| exp NEQ /*7L*/ exp
	| exp CAND /*4L*/ exp
	| exp COR /*3L*/ exp
	| exp CARETS /*10L*/ exp
	| exp AMPERSAND /*6L*/ exp
	| exp BAR /*5L*/ exp
	| exp OPERATOR /*9L*/ exp
	| exp INCR /*11L*/ exp
	| NEW celltype
	| NEW celltype dimexps
	| NEW celltype dimexps dims
	| NEW celltype dims
	| NEW celltype dims arrayinit
	| NEW celltype '(' /*19L*/ ')' /*19L*/ blockstm
	| NEW celltype dims '(' /*19L*/ ')' /*19L*/ blockstm
	| NEW celltype '(' /*19L*/ formals ')' /*19L*/ blockstm
	| NEW celltype dims '(' /*19L*/ formals ')' /*19L*/ blockstm
	| exp '?' /*2R*/ exp ':' /*2R*/ exp
	| exp ASSIGN /*1R*/ exp
	| '(' /*19L*/ tuple ')' /*19L*/
	| exp join exp %prec JOIN_PREC /*11L*/
	| exp dir %prec DIRTAG /*12L*/
	| INCR /*11L*/ exp %prec UNARY /*16L*/
	| DASHES /*11L*/ exp %prec UNARY /*16L*/
	| exp INCR /*11L*/ %prec UNARY /*16L*/
	| exp SELFOP /*1R*/ exp
	| QUOTE '{' /*13L*/ fileblock '}' /*13L*/
	;

join :
	DASHES /*11L*/
	| basicjoin %prec JOIN_PREC /*11L*/
	| dir basicjoin %prec JOIN_PREC /*11L*/
	| basicjoin dir %prec JOIN_PREC /*11L*/
	| dir basicjoin dir %prec JOIN_PREC /*11L*/
	;

dir :
	'{' /*13L*/ CURL /*13L*/ exp '}' /*13L*/
	| '{' /*13L*/ exp '}' /*13L*/
	| '{' /*13L*/ exp ',' exp '}' /*13L*/
	| '{' /*13L*/ exp ',' exp ',' exp '}' /*13L*/
	;

basicjoin :
	DOTS /*11L*/
	| DOTS /*11L*/ tension DOTS /*11L*/
	| DOTS /*11L*/ controls DOTS /*11L*/
	| COLONS /*11L*/
	| LONGDASH /*11L*/
	;

tension :
	TENSION /*12L*/ exp
	| TENSION /*12L*/ exp AND /*12L*/ exp
	| TENSION /*12L*/ ATLEAST /*12L*/ exp
	| TENSION /*12L*/ ATLEAST /*12L*/ exp AND /*12L*/ exp
	;

controls :
	CONTROLS /*12L*/ exp
	| CONTROLS /*12L*/ exp AND /*12L*/ exp
	;

stm :
	';'
	| blockstm
	| stmexp ';'
	| IF '(' /*19L*/ exp ')' /*19L*/ stm
	| IF '(' /*19L*/ exp ')' /*19L*/ stm ELSE stm
	| WHILE '(' /*19L*/ exp ')' /*19L*/ stm
	| DO stm WHILE '(' /*19L*/ exp ')' /*19L*/ ';'
	| FOR '(' /*19L*/ forinit ';' fortest ';' forupdate ')' /*19L*/ stm
	| FOR '(' /*19L*/ type ID ':' /*2R*/ exp ')' /*19L*/ stm
	| BREAK ';'
	| CONTINUE ';'
	| RETURN_ ';'
	| RETURN_ exp ';'
	;

stmexp :
	exp
	;

blockstm :
	block
	;

forinit :
	/*empty*/
	| stmexplist
	| barevardec
	;

fortest :
	/*empty*/
	| exp
	;

forupdate :
	/*empty*/
	| stmexplist
	;

stmexplist :
	stmexp
	| stmexplist ',' stmexp
	;

%%

%x lexcomment
//%x texstring
//%x cstring
//%x lexformat
%x opname

LETTER [_A-Za-z]
ESC \\
ENDL \\?(\r\n|\n|\r)
EXTRAOPS <<|>>|"$"|"$$"|@|@@|~|<>

%%

<lexcomment>{
\/\*<>lexcomment>
\*\/<<>	skip()
\r\n|\n|\r<.>
//<<EOF>>            "comment not terminated"
.<.>
}

[ \t]+              skip()
{ENDL}             skip()
\/\/.*         skip()
","                ','
":"                ':'
";"                ';'
"("                '('
")"                ')'
"["                '['
"]"                ']'
"{"                '{'
"}"                '}'
"."                '.'
"..."              ELLIPSIS

"+"                '+'
"-"                '-'
"*"                '*'
"/"                '/'
"#"                '#'
"%"                '%'
"^"                '^'
"**"               '^'
"?"                '?'
"="                ASSIGN
"=="               EQ
"!="               NEQ
"<"                LT
"<="               LE
">"                GT
">="               GE
"&&"               CAND
"||"               COR
"!"                OPERATOR
"^^"               CARETS
"::"               COLONS
"++"               INCR
".."               DOTS
"--"               DASHES
"---"              LONGDASH
"&"                AMPERSAND
"|"                BAR
{EXTRAOPS}         OPERATOR

"+="               SELFOP
"-="               SELFOP
"*="               SELFOP
"/="               SELFOP
"#="               SELFOP
"%="               SELFOP
"^="               SELFOP

and                AND
controls           CONTROLS
tension            TENSION
atleast            ATLEAST
curl               CURL

if                 IF
else               ELSE
while              WHILE
for                FOR
do                 DO
return             RETURN_
break              BREAK
continue           CONTINUE
struct             STRUCT
typedef            TYPEDEF
new                NEW
access             ACCESS
import             IMPORT
unravel            UNRAVEL
from               FROM
include            INCLUDE
quote              QUOTE
static             MODIFIER
public             PERM
private            PERM
restricted         PERM
this               THIS
explicit           EXPLICIT


[0-9]+             LIT
([0-9]*\.[0-9]+)|([0-9]+\.[0-9]*)|([0-9]*\.*[0-9]+e[-+]*[0-9]+)|([0-9]+\.[0-9]*e[-+]*[0-9]+)  LIT
true               LIT
false              LIT
null               LIT
cycle              LIT
newframe        LIT

operator<opname>
<opname>{
[ \t\r]+            skip()
{ENDL}             skip()
//<<EOF>>            "missing operator name"
"**"<INITIAL>               ID
[-+*/#%^!<>]|==|!=|<=|>=|&|\||\^\^|\.\.|::|--|---|\+\+|{EXTRAOPS}<INITIAL> ID
{LETTER}({LETTER}|[0-9])*<INITIAL> ID
.     skip()
}

{LETTER}({LETTER}|[0-9])* ID

\/\*<>lexcomment>
\"(\\.|[^"\\])*\"	STRING
'(\\.|[^'\r\n\\])*'	STRING

//<<EOF>>            { setEOF("unexpected end of input"); yyterminate(); }

//.                   "invalid token";

%%
