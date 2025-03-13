//From: https://github.com/golang/go/blob/a68bf75d3402412a1946fe1df67f57ca923f1507/src/go/token/token.go

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
%token CHAN
%token CHAR
%token COLON
%token COMMA
%token CONST
%token CONTINUE
%token DEC
%token DEFAULT
%token DEFER
%token DEFINE
%token ELLIPSIS
%token ELSE
%token EQL
%token FALLTHROUGH
%token FLOAT
%token FOR
%token FUNC
%token GEQ
%token GO
%token GOTO
%token GTR
%token IDENT
%token IF
%token IMAG
%token IMPORT
%token INC
%token INT
%token INTERFACE
%token LAND
%token LBRACE
%token LBRACK
%token LEQ
%token LOR
%token LPAREN
%token LSS
%token MAP
%token MUL
%token MUL_ASSIGN
%token NEQ
%token NOT
%token OR
%token OR_ASSIGN
%token PACKAGE
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
%token STRUCT
%token SUB
%token SUB_ASSIGN
%token SWITCH
%token TILDE
%token TYPE
%token VAR
%token XOR
%token XOR_ASSIGN

%%

input :
	%empty
	| tokens
	;

tokens :
	token
	| tokens token
	;

token :
	ADD
	| ADD_ASSIGN
	| AND
	| AND_ASSIGN
	| AND_NOT
	| AND_NOT_ASSIGN
	| ARROW
	| ASSIGN
	| BREAK
	| CASE
	| CHAN
	| CHAR
	| COLON
	| COMMA
	| CONST
	| CONTINUE
	| DEC
	| DEFAULT
	| DEFER
	| DEFINE
	| ELLIPSIS
	| ELSE
	| EQL
	| FALLTHROUGH
	| FLOAT
	| FOR
	| FUNC
	| GEQ
	| GO
	| GOTO
	| GTR
	| IDENT
	| IF
	| IMAG
	| IMPORT
	| INC
	| INT
	| INTERFACE
	| LAND
	| LBRACE
	| LBRACK
	| LEQ
	| LOR
	| LPAREN
	| LSS
	| MAP
	| MUL
	| MUL_ASSIGN
	| NEQ
	| NOT
	| OR
	| OR_ASSIGN
	| PACKAGE
	| PERIOD
	| QUO
	| QUO_ASSIGN
	| RANGE
	| RBRACE
	| RBRACK
	| REM
	| REM_ASSIGN
	| RETURN
	| RPAREN
	| SELECT
	| SEMICOLON
	| SHL
	| SHL_ASSIGN
	| SHR
	| SHR_ASSIGN
	| STRING
	| STRUCT
	| SUB
	| SUB_ASSIGN
	| SWITCH
	| TILDE
	| TYPE
	| VAR
	| XOR
	| XOR_ASSIGN
	;

%%

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

//"EOF"	EOF
//"COMMENT"	COMMENT

"+"	ADD
"-"	SUB
"*"	MUL
"/"	QUO
"%"	REM

"&"	AND
"|"	OR
"^"	XOR
"<<"	SHL
">>"	SHR
"&^"	AND_NOT

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

"&&"	LAND
"||"	LOR
"<-"	ARROW
"++"	INC
"--"	DEC

"=="	EQL
"<"	LSS
">"	GTR
"="	ASSIGN
"!"	NOT

"!="	NEQ
"<="	LEQ
">="	GEQ
":="	DEFINE
"..."	ELLIPSIS

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

"break"	BREAK
"case"	CASE
"chan"	CHAN
"const"	CONST
"continue"	CONTINUE

"default"	DEFAULT
"defer"	DEFER
"else"	ELSE
"fallthrough"	FALLTHROUGH
"for"	FOR

"func"	FUNC
"go"	GO
"goto"	GOTO
"if"	IF
"import"	IMPORT

"interface"	INTERFACE
"map"	MAP
"package"	PACKAGE
"range"	RANGE
"return"	RETURN

"select"	SELECT
"struct"	STRUCT
"switch"	SWITCH
"type"	TYPE
"var"	VAR

"~"	TILDE

[0-9]+	INT
[0-9]+"."[0-9]+	FLOAT
"IMAG"	IMAG
'(\\.|[^'\r\n\\])+'	CHAR
\"(\\.|[^"\r\n\\])*\"	STRING
"`"(\\.|[^`\\])*"`"	STRING
[A-Za-z_][A.Za-z0-9_]*	IDENT

%%
