//From: https://github.com/ocharles/EpiVM/blob/2814ecb7faac22be0bb9178f20c9ded6e4324331/Epic/Parser.y#L1

%token anytype
%token arrow
%token bigfloat
%token bigfloattype
%token bigint
%token biginttype
%token bool
%token booltype
%token case
%token char
%token chartype
%token cinclude
%token con
%token ctype
%token datatype
%token default
%token effect
%token else
%token errorcode
%token export
%token extern
%token fixed
%token float
%token floattype
%token foreign
%token funtype
%token growable
%token if
%token impossible
%token in
%token include
%token inline
%token int
%token inttype
%token let
%token memory
%token name
%token of
%token ptrtype
%token strict
%token string
%token stringtype
%token then
%token tyctype
%token tyeval
%token tylinear
%token unit
%token unittype
%token unused
%token while

%nonassoc NONE
%nonassoc lazy
%nonassoc par
%left LET
%left IF
%left eq feq
%left ';'
%left '<' '>' le ge flt fgt fle fge
%left shl shr
%left '+' '-' fplus fminus
%left '*' '/' ftimes fdiv '%'
%left NEG
%left '!'
%nonassoc '('


%%

Program :
	/*Declaration*/
	| Program Declaration
	| Program include string  //File
	;

Type :
	inttype
	| biginttype
	| chartype
	| booltype
	| floattype
	| bigfloattype
	| stringtype
	| ptrtype
	| unittype
	| anytype
	| datatype
	| tyctype string
	| tylinear '(' Type ')'
	| tyeval '(' Type ')'
	| funtype
	;

Declaration :
	Export Flags name '(' TypeList ')' arrow Type '=' Expr
	| extern name '(' TypeList ')' arrow Type
	| cinclude string
	| ctype string
	;

Flags :
	%empty
	| Flags Flag
	;

Flag
	: inline
	| strict
	;

Export :
	%empty
	| export string
	;

TypeList :
	%empty
	| name ':' Type
	| TypeList ',' name ':' Type
	;

Expr :
	name
	| '(' Expr ')'
	| Expr '(' ExprList ')'
	| '[' ExprList ']'
	| lazy '(' Expr ')'
	| par '(' Expr ')'
	| effect '(' Expr ')'
	| con int '(' ExprList ')'
	| Const
	| Expr '!' int
	| let name ':' Type '=' Expr in Expr %prec LET
	| let '!' name '=' Expr in Expr %prec LET
	| "\\" name ':' Type '.' Expr %prec LET
	| Expr ';' Expr
	| if Expr then Expr else Expr %prec IF
	| while '(' Expr ',' Expr ')'
	| while '(' Expr ',' Expr ',' Expr ')'
	| memory '(' Allocator ',' Expr ',' Expr ')'
	| CaseExpr
	| MathExpr
	| errorcode string
	| impossible
	| foreign Type string '(' ExprTypeList ')'
	| lazy foreign Type string '(' ExprTypeList ')'
        ;

Allocator :
	fixed
	| growable
	;

CaseExpr :
	case Expr of '{' Alts '}'
	;

Alts :
	%empty
	| Alt
	| Alts '|' Alt
	;

Alt :
	con int '(' TypeList ')' arrow Expr
	| int arrow Expr
	| default arrow Expr
	;

MathExpr :
	Expr '+' Expr
	| Expr '-' Expr
	| '-' Expr %prec NEG
	| Expr '*' Expr
	| Expr '/' Expr
	| Expr '%' Expr
	| Expr fplus Expr
	| Expr fminus Expr
	| fminus Expr %prec NEG
	| Expr ftimes Expr
	| Expr fdiv Expr
	| Expr shl Expr
	| Expr shr Expr
	| Expr '<' Expr
	| Expr '>' Expr
	| Expr le Expr
	| Expr ge Expr
	| Expr eq Expr
	| Expr flt Expr
	| Expr fgt Expr
	| Expr fle Expr
	| Expr fge Expr
	| Expr feq Expr
	;

ExprList :
	%empty
	| Expr
	| ExprList ',' Expr
	;

ExprTypeList :
	%empty
	| Expr ':' Type
	| ExprTypeList ',' Expr ':' Type
	;

Const :
	int
	| bigint
	| char
	| bool
	| float
	| bigfloat
	| string
	| unit
	| unused
	;

//Line :
//	/*empty*/
//	;

//File :
//	/*empty*/  %prec NONE
//	;

%%

%x LCOMMENT

%%

[ \t\r\n]+	skip()
"--".*  skip()
"{-"<>LCOMMENT>
<LCOMMENT>{
    "{-"<>LCOMMENT>
    "-}"<<> skip()
    .|\n<.>
}

"!"	'!'
"%"	'%'
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
"\\"	"\\"
"]"	']'
"{"	'{'
"|"	'|'
"}"	'}'

"Any"	anytype
"->"	arrow
"BigFloat"	bigfloattype
"BigInt"	biginttype
"Bool"	booltype
"true"|"false"	bool
case	case
"Char"	chartype
"%include"	cinclude
"Con"	con
ctype	ctype
"Data"	datatype
default	default
"%effect"	effect
else	else
"=="	eq
errorcode	errorcode
export	export
extern	extern
"/."	fdiv
"==."	feq
">=."	fge
">."	fgt
"%fixed"	fixed
fle	fle
"Float"	floattype
flt	flt
"-."	fminus
foreign	foreign
"+."	fplus
"*."	ftimes
"Fun"	funtype
">="	ge
"%growable"	growable
if	if
impossible	impossible
in	in
include	include
"%inline"	inline
"Int"	inttype
lazy	lazy
"<="	le
let	let
"%memory"	memory
of	of
par	par
"Ptr"	ptrtype
"<<"	shl
">>"	shr
"%strict"	strict
"String"	stringtype
then	then
"CType"	tyctype
"Eval"	tyeval
"Linear"	tylinear
"Unit"	unittype
"unit"	unit
"%unused"	unused
"%while"	while

bigfloat	bigfloat
[0-9]+"."[0-9]+	float
bigint	bigint
[0-9]+	int

\"(\\.|[^"\r\n\\])*\"	string
'(\\.[^'\r\n\\])'	char

[A-Za-z_][A-Za-z0-9_]*	name

%%