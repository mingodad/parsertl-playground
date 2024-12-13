//From: https://github.com/AplaProject/apla-lang/blob/23ce26c4392162ec67fa5ca27b6971369eeb9723/parser/parser.y

// Identifiers + literals
%token IDENT  // foobar
%token ENV   // $foobar
%token CALL  // foobar(
%token CALLCONTRACT  // @foobar(
%token INDEX  // foobar[
%token INT    // 314
%token FLOAT    // 3.14
%token STRING  // "string"
%token QSTRING  // `string`
%token TRUE   // true
%token FALSE  // false

// Delimiters
%token NEWLINE // \n
%token COMMA   // ,
%token COLON   // :
%token LPAREN  // (
%token RPAREN  // )
%token OBJ  // @{
%token LBRACE  // {
%token RBRACE  // }
%token LBRACKET // [
%token RBRACKET // ]
%token QUESTION // ?
%token DOUBLEDOT   // ..
%token DOT   // .

// Operators
%token ADD // +
%token SUB // -
%token MUL // *
%token DIV // /
%token MOD // %

%token ADD_ASSIGN // +=
%token SUB_ASSIGN // -=
%token MUL_ASSIGN // *=
%token DIV_ASSIGN // /=
%token MOD_ASSIGN // %=
%token ASSIGN // =

%token AND // &&
%token OR  // ||

%token EQ     // ==
%token NOT_EQ // !=
%token NOT    // !

%token LT     // <
%token GT     // >
%token LTE    // <=
%token GTE    // >=

// Keywords
%token BREAK      // break
%token CONTINUE   // continue
%token DATA       // data
%token CONTRACT   // contract
%token IF       // if
%token ELIF     // elif
%token ELSE     // else
%token RETURN   // return
%token WHILE   // while
%token FUNC    // func
%token FOR     // for
%token IN      // in
%token SWITCH  // switch
%token CASE    // case
%token READ    // read
%token DEFAULT // default

// Types
%token T_INT    // int
%token T_BOOL   // bool
%token T_STR  // str
%token T_ARR  // arr
%token T_MAP  // map
%token T_FLOAT  // float
%token T_MONEY  // money
%token T_OBJECT  // object
%token T_BYTES  // bytes
%token T_FILE  // file

%left AND
%left OR
%left LTE GTE LT GT EQ NOT_EQ
%left ADD SUB
%left MUL DIV MOD
%right UNARYMINUS UNARYNOT

//%start contract_declaration
%start contracts

%%

ordinaltype
    : T_BOOL
    | T_INT
    | T_STR
    | T_ARR
    | T_MAP
    | T_FLOAT
    | T_MONEY
    | T_OBJECT
    | T_BYTES
    | T_FILE
    ;

type
    : ordinaltype
    | type DOT ordinaltype
    ;

rettype
    : /*empty*/
    | type
    ;

statements
    : /*empty*/
    | statements NEWLINE
    | statements switch
    | statements statement NEWLINE
    ;

params
    : /*empty*/
    | expr
    | params COMMA expr
    ;

cntparams
    : /*empty*/
    | IDENT COLON expr
    | cntparams COMMA IDENT COLON expr
    ;

var
    : IDENT
    ;

index
    : INDEX expr RBRACKET
    | index LBRACKET expr RBRACKET
    ;

else
   : /*empty*/
   | ELSE LBRACE statements RBRACE
   ;

elif
   : /*empty*/
   | elif ELIF expr LBRACE statements RBRACE
   ;

case
   : /*empty*/
   | case CASE exprlist LBRACE statements RBRACE NEWLINE
   ;

default
   : /*empty*/
   | DEFAULT LBRACE statements RBRACE
   ;

switch
    : SWITCH expr NEWLINE case default
    ;

statement
    : var ASSIGN expr
    | var ADD_ASSIGN expr
    | var SUB_ASSIGN expr
    | var MUL_ASSIGN expr
    | var DIV_ASSIGN expr
    | var MOD_ASSIGN expr
    | index ASSIGN expr
    | type IDENT ASSIGN expr
    | type ident_list
    | IF expr LBRACE statements RBRACE elif else
    | BREAK
    | CONTINUE
    | RETURN
    | RETURN expr
    | WHILE expr LBRACE statements RBRACE
    | FUNC CALL par_declarations RPAREN rettype LBRACE statements RBRACE
    | CALL params RPAREN
    | CALLCONTRACT cntparams RPAREN
    | FOR IDENT IN expr LBRACE statements RBRACE
    | FOR IDENT COMMA IDENT IN expr LBRACE statements RBRACE
    | FOR IDENT IN expr DOUBLEDOT expr LBRACE statements RBRACE
    ;

exprlist
    : expr
    | exprlist COMMA expr
    ;

exprmaplist
    : STRING COLON expr
    | exprmaplist COMMA STRING COLON NEWLINE expr
    | exprmaplist COMMA STRING COLON expr
    ;

object
    : STRING COLON exprobj
    | IDENT COLON exprobj
    | object COMMA STRING COLON exprobj
    | object COMMA IDENT COLON exprobj
    ;

objlist
    : exprobj
    | objlist COMMA exprobj
    ;

exprobj
    : LPAREN expr RPAREN
    | INT
    | FLOAT
    | STRING
    | QSTRING
    | TRUE
    | FALSE
    | CALL params RPAREN
    | CALLCONTRACT cntparams RPAREN
    | index
    | ENV
    | IDENT
    | LBRACE object RBRACE
    | LBRACKET objlist RBRACKET
    | LBRACKET object RBRACKET
    ;

expr
    : LPAREN expr RPAREN
    | INT
    | FLOAT
    | STRING
    | QSTRING
    | TRUE
    | FALSE
    | CALL params RPAREN
    | CALLCONTRACT cntparams RPAREN
    | index
    | ENV
    | IDENT
    | OBJ object RBRACE
    | LBRACE exprlist RBRACE
    | LBRACE exprmaplist RBRACE
    | QUESTION LPAREN expr COMMA expr COMMA expr RPAREN
    | expr MUL expr
    | expr DIV expr
    | expr ADD expr
    | expr SUB expr
    | expr MOD expr
    | expr AND expr
    | expr OR expr
    | expr EQ expr
    | expr NOT_EQ expr
    | expr LTE expr
    | expr GTE expr
    | expr LT expr
    | expr GT expr
    | SUB expr %prec UNARYMINUS
    | NOT expr %prec UNARYNOT
    ;

ident_list
    : IDENT
    | ident_list IDENT
    ;

par_declaration
    : type ident_list
    ;

par_declarations
    : /*empty*/
    | par_declaration
    | par_declarations COMMA par_declaration
    ;

var_declaration
    : type ident_list
    | type IDENT ASSIGN expr
    ;

var_declarations
    : var_declaration
    | var_declarations NEWLINE var_declaration
    ;

contract_data
    : /*empty*/
    | DATA LBRACE NEWLINE var_declarations NEWLINE RBRACE NEWLINE
    ;

contract_body
    : contract_data statements
    ;

contract_read
    : /*empty*/
    | READ
    ;

contract_declaration
    : CONTRACT IDENT contract_read LBRACE NEWLINE contract_body RBRACE
    | contract_declaration NEWLINE
    ;

contracts :
    contract_declaration
    | contracts contract_declaration
    ;

%%

unicodeDigit	\x81
unicodeLetter	\x80
letter			[_a-zA-Z]|{unicodeLetter}
hexint	    	0[xX][0-9a-fA-F]+
digit			[0-9]|{unicodeDigit}
int				[0-9]+
float			{int}\.[0-9]+
identifier		{letter}({letter}|{digit})*
env             "$"{identifier}
callcontract    "@"{identifier}\(
call    		{identifier}\(
index           {identifier}\[
string 			\"([^\\"]|\\.)*\"
qstring 		`([^`])*`

%%

[ \t\r ]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

\+=				ADD_ASSIGN
-=				SUB_ASSIGN
\*=				MUL_ASSIGN
\/=				DIV_ASSIGN
%=				MOD_ASSIGN
=				ASSIGN

\n				NEWLINE
;				NEWLINE
,[ \t\r]*\n?		COMMA
:				COLON
\.\.			DOUBLEDOT
\.				DOT
\?         	    QUESTION
\([ \t]*\n?     LPAREN
\n[ \t]*\)		RPAREN
\)				RPAREN
@\{[ \t]*\n?  	OBJ
\{  	LBRACE
\}  	RBRACE
\[[ \t]*\n?		LBRACKET
\]				RBRACKET

&&				AND
\|\|			OR

\+[ \t\r]*\n?		ADD
-[ \t\r]*\n?		SUB
\*[ \t\r]*\n?		MUL
\/[ \t\r]*\n?		DIV
%[ \t\r]*\n?		MOD

==[ \t\r]*\n?		EQ
!=[ \t\r]*\n?		NOT_EQ
!				NOT

\<=[ \t\r]*\n?	LTE
>=[ \t\r]*\n?		GTE
\<[ \t\r]*\n?		LT
>[ \t\r]*\n?  	GT

break    		BREAK
continue  		CONTINUE
data    		DATA
contract		CONTRACT
while           WHILE
if				IF
elif			ELIF
else			ELSE
return			RETURN
true			TRUE
false			FALSE
func			FUNC
for				FOR
in				IN
switch  		SWITCH
case  	    	CASE
read    		READ
default  		DEFAULT

bool			T_BOOL
int				T_INT
hexint			T_INT
str			    T_STR
arr			    T_ARR
map			    T_MAP
float			T_FLOAT
money			T_MONEY
obj  			T_OBJECT
bytes  			T_BYTES
file  			T_FILE

{float}			FLOAT
{hexint}			INT
{int}			INT
{env}	ENV
{string}		STRING
{qstring}		QSTRING
{call}	CALL
{callcontract}	CALLCONTRACT
{index}	INDEX

{identifier}	IDENT

%%
