//From: https://github.com/jxwr/doby/blob/561b2210c7e1ef23b6e7f68d55ddcf9fdad232bc/parser/grammar.y

/*Tokens*/
%token ADD
%token ADD_ASSIGN
%token AND
%token AND_ASSIGN
%token AND_NOT
%token AND_NOT_ASSIGN
%token ARROW
%token ASSIGN
%token BREAK
%token CASE
//%token CHAN
%token CHAR
%token COLON
%token COMMA
//%token COMMENT
//%token CONST
%token CONTINUE
%token DEC
%token DEFAULT
//%token DEFER
//%token DEFINE
//%token ELLIPSIS
%token ELSE
//%token EOF
%token EOL
%token EQL
//%token FALLTHROUGH
%token FLOAT
%token FOR
%token FUNC
%token GEQ
%token GO
//%token GOTO
%token GTR
%token IDENT
%token IF
%token IMPORT
%token INC
%token INT
//%token INTERFACE
%token LAND
%token LBRACE
%token LBRACK
%token LEQ
%token LOR
%token LPAREN
%token LSS
//%token MAP
%token MUL
%token MUL_ASSIGN
%token NEQ
%token NOT
%token OR
%token OR_ASSIGN
//%token PACKAGE
%token PERIOD
%token QUO
%token QUO_ASSIGN
%token RANGE
%token RBRACE
%token RBRACK
%token REM
%token REM_ASSIGN
%token RETURN
%token RPAREN
%token SELECT
%token SEMICOLON
%token SHL
%token SHL_ASSIGN
%token SHR
%token SHR_ASSIGN
%token STRING
//%token STRUCT
%token SUB
%token SUB_ASSIGN
%token SWITCH
//%token TYPE
%token UMINUS
//%token VAR
%token XOR
%token XOR_ASSIGN

%left /*1*/ LOR ARROW
%left /*2*/ LAND
%left /*3*/ NOT
%left /*4*/ SHL SHR AND_NOT
%left /*5*/ LSS GTR
%left /*6*/ EQL NEQ LEQ GEQ
%left /*7*/ OR
%left /*8*/ AND XOR
%left /*9*/ ADD SUB
%left /*10*/ MUL QUO REM
%left /*11*/ INC DEC
%left /*12*/ UMINUS
%left /*13*/ LPAREN
%left /*14*/ LBRACK
%left /*15*/ PERIOD
%right /*16*/ ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN QUO_ASSIGN REM_ASSIGN AND_ASSIGN OR_ASSIGN XOR_ASSIGN SHL_ASSIGN SHR_ASSIGN AND_NOT_ASSIGN  ASSIGN //DEFINE

%start prog

%%

ident :
	IDENT
	;

basiclit :
	INT
	| FLOAT
	| STRING
	| CHAR
	;

paren_expr :
	LPAREN /*13L*/ expr RPAREN
	;

selector_expr :
	expr PERIOD /*15L*/ ident
	;

slice_expr :
	expr LBRACK /*14L*/ expr COLON expr RBRACK
	| expr LBRACK /*14L*/ COLON expr RBRACK
	| expr LBRACK /*14L*/ expr COLON RBRACK
	;

index_expr :
	expr LBRACK /*14L*/ expr RBRACK
	;

expr_list :
	/*empty*/
	| expr
	| expr_list COMMA expr
	| expr_list COMMA EOL expr
	;

call_expr :
	expr LPAREN /*13L*/ expr_list RPAREN
	;

unary_expr :
	SUB /*9L*/ expr %prec UMINUS /*12L*/
	| NOT /*3L*/ expr
	;

binary_expr :
	expr ADD /*9L*/ expr
	| expr SUB /*9L*/ expr
	| expr MUL /*10L*/ expr
	| expr QUO /*10L*/ expr
	| expr REM /*10L*/ expr
	| expr AND /*8L*/ expr
	| expr OR /*7L*/ expr
	| expr XOR /*8L*/ expr
	| expr SHL /*4L*/ expr
	| expr SHR /*4L*/ expr
	| expr AND_NOT /*4L*/ expr
	| expr LSS /*5L*/ expr
	| expr GTR /*5L*/ expr
	| expr NEQ /*6L*/ expr
	| expr LEQ /*6L*/ expr
	| expr GEQ /*6L*/ expr
	| expr EQL /*6L*/ expr
	| expr LAND /*2L*/ expr
	| expr LOR /*1L*/ expr
	;

array_expr :
	LBRACK /*14L*/ expr_list RBRACK
	| LBRACK /*14L*/ EOL expr_list EOL RBRACK
	| LBRACK /*14L*/ EOL expr_list RBRACK
	;

set_expr :
	'#' LBRACK /*14L*/ expr_list RBRACK
	| '#' LBRACK /*14L*/ EOL expr_list EOL RBRACK
	| '#' LBRACK /*14L*/ EOL expr_list RBRACK
	;

field_pair :
	expr COLON expr
	;

field_list :
	/*empty*/
	| field_pair
	| field_list EOL field_pair
	| field_list COMMA field_pair
	| field_list COMMA EOL field_pair
	| field_list EOL
	| field_list COMMA EOL
	;

dict_expr :
	'#' LBRACE field_list RBRACE
	;

ident_list :
	/*empty*/
	| IDENT
	| ident_list COMMA IDENT
	;

func_decl_expr :
	FUNC LPAREN /*13L*/ ident_list RPAREN block_stmt
	| FUNC IDENT LPAREN /*13L*/ ident_list RPAREN block_stmt
	| FUNC LPAREN /*13L*/ IDENT IDENT RPAREN IDENT LPAREN /*13L*/ ident_list RPAREN block_stmt
	;

expr :
	ident
	| basiclit
	| paren_expr
	| selector_expr
	| index_expr
	| slice_expr
	| call_expr
	| unary_expr
	| binary_expr
	| array_expr
	| dict_expr
	| set_expr
	| func_decl_expr
	;

expr_stmt :
	expr
	;

send_stmt :
	expr ARROW /*1L*/ expr
	;

incdec_stmt :
	expr INC /*11L*/
	| expr DEC /*11L*/
	;

assign_stmt :
	expr_list ASSIGN /*16R*/ expr_list
	| expr_list ADD_ASSIGN /*16R*/ expr_list
	| expr_list SUB_ASSIGN /*16R*/ expr_list
	| expr_list MUL_ASSIGN /*16R*/ expr_list
	| expr_list QUO_ASSIGN /*16R*/ expr_list
	| expr_list REM_ASSIGN /*16R*/ expr_list
	| expr_list AND_ASSIGN /*16R*/ expr_list
	| expr_list OR_ASSIGN /*16R*/ expr_list
	| expr_list XOR_ASSIGN /*16R*/ expr_list
	| expr_list SHL_ASSIGN /*16R*/ expr_list
	| expr_list SHR_ASSIGN /*16R*/ expr_list
	| expr_list AND_NOT_ASSIGN /*16R*/ expr_list
	;

go_stmt :
	GO call_expr
	;

return_stmt :
	RETURN expr_list
	;

branch_stmt :
	BREAK
	| CONTINUE
	;

block_stmt :
	LBRACE stmt_list RBRACE
	;

if_stmt :
	IF expr block_stmt
	| IF expr block_stmt ELSE stmt
	;

case_clause :
	CASE expr_list COLON stmt_list
	| DEFAULT COLON stmt_list
	;

case_clause_list :
	EOL
	| case_clause
	| case_clause_list case_clause
	;

case_block :
	LBRACE case_clause_list RBRACE
	;

switch_stmt :
	SWITCH stmt case_block
	;

select_stmt :
	SELECT case_block
	;

for_stmt :
	FOR stmt SEMICOLON expr SEMICOLON stmt block_stmt
	| FOR SEMICOLON expr SEMICOLON stmt block_stmt
	| FOR expr block_stmt
	;

range_stmt :
	FOR expr_list ASSIGN /*16R*/ RANGE expr block_stmt
	;

import_stmt :
	IMPORT STRING
	;

stmt :
	expr_stmt
	| send_stmt
	| incdec_stmt
	| assign_stmt
	| go_stmt
	| return_stmt
	| branch_stmt
	| block_stmt
	| if_stmt
	| switch_stmt
	| select_stmt
	| for_stmt
	| range_stmt
	| import_stmt
	;

stmt_list :
	/*empty*/
	| stmt
	| stmt_list EOL stmt
	| stmt_list SEMICOLON stmt
	| stmt_list EOL
	;

prog :
	stmt_list EOL
	;

%%

floatRe       [0-9]+\.[0-9]+
intRe         [0-9]+
stringRe      \"(\\.|[^"\r\n\\])*\"
charRe        '(\\.|[^'\r\n\\])'
identRe       [a-zA-Z_][a-zA-Z0-9_]*
//escapeRe      "\\\\."
lineCommentRe "//".*

%%

[ \t\r]+	skip()
{lineCommentRe}	skip()

"#"	'#'

//OpTokens
"+="	ADD_ASSIGN
"-="	SUB_ASSIGN
"*="	MUL_ASSIGN
"/="	QUO_ASSIGN
"%="	REM_ASSIGN

"&="	AND_ASSIGN
"|="	OR_ASSIGN
"^="	XOR_ASSIGN
"<<="	SHL_ASSIGN
">>="	SHR_ASSIGN
"&^="	AND_NOT_ASSIGN

"<<"	SHL
">>"	SHR
"&^"	AND_NOT

"&&"	LAND
"||"	LOR
"<-"	ARROW
"++"	INC
"--"	DEC
"=="	EQL

"!="	NEQ
"<="	LEQ
">="	GEQ
//":="	DEFINE
//"..."	ELLIPSIS

"+"	ADD
"-"	SUB
"*"	MUL
"/"	QUO
"%"	REM

"&"	AND
"|"	OR
"^"	XOR

"<"	LSS
">"	GTR
"="	ASSIGN
"!"	NOT

"("	LPAREN
"["	LBRACK
"{"	LBRACE
","	COMMA
"."	PERIOD

")"	RPAREN
"]"	RBRACK
"}"	RBRACE
";"	SEMICOLON
":"	COLON

//KeywordToken
"break"	BREAK
"case"	CASE
//"chan"	CHAN
//"const"	CONST
"continue"	CONTINUE

"default"	DEFAULT
//"defer"	DEFER
"else"	ELSE
//"fallthrough"	FALLTHROUGH
"for"	FOR

"func"	FUNC
"go"	GO
//"goto"	GOTO
"if"	IF
"import"	IMPORT

//"interface"	INTERFACE
//"map"	MAP
//"package"	PACKAGE
"range"	RANGE
"return"	RETURN

"select"	SELECT
//"struct"	STRUCT
"switch"	SWITCH
//"type"	TYPE
//"var"	VAR

{charRe}	CHAR
"\n"	EOL
{floatRe}	FLOAT
{intRe}	INT
{stringRe}	STRING
{identRe}	IDENT

%%
