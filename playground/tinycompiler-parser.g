//From: https://github.com/ssloy/tinycompiler/blob/217266255ff01cbddbb01d089829cc5bf518a17c/parser.py

%token AND
%token ASSIGN
%token BEGIN
%token BOOLEAN
%token COMMA
%token COMP
%token DIVIDE
%token ELSE
%token END
%token ID
%token IF
%token INTEGER
%token LPAREN
%token MINUS
%token MOD
%token NOT
%token OR
%token PLUS
%token PRINT
%token RETURN
%token RPAREN
%token SEMICOLON
%token STRING
%token TIMES
%token TYPE
%token WHILE

%%

fun :
	ID LPAREN RPAREN func_body
	| ID LPAREN param_list RPAREN func_body
	| TYPE ID LPAREN RPAREN func_body
	| TYPE ID LPAREN param_list RPAREN func_body
	;

func_body :
	BEGIN END
	| BEGIN var_list fun_list statement_list END
	| BEGIN var_list fun_list END
	| BEGIN var_list statement_list END
	| BEGIN fun_list statement_list END
	| BEGIN statement_list END
	| BEGIN var_list END
    ;

var :
	TYPE ID
	;

param_list :
	var
	| param_list COMMA var
	;

var_list :
	var SEMICOLON
	| var_list var SEMICOLON
	;

fun_list :
	fun
	| fun_list fun
	;

statement_list :
	statement
	| statement_list statement
	;

statement :
	ID LPAREN arg_list_opt RPAREN SEMICOLON
	| ID ASSIGN expr SEMICOLON
	| RETURN expr SEMICOLON
	| RETURN SEMICOLON
	| PRINT expr SEMICOLON
	| IF expr BEGIN statement_list END else_statement
	| WHILE expr BEGIN statement_list END
	;

else_statement :
	/*empty*/
	| ELSE BEGIN statement_list END
	;

arg_list_opt :
	/*empty*/
	| arg_list
	;

arg_list :
	expr
	| arg_list COMMA expr
	;

expr :
	conjunction
	| expr OR conjunction
	| STRING
	;

conjunction :
	literal
	| conjunction AND literal
	;

literal :
	comparand
	| NOT comparand
	;

comparand :
	addend
	| addend COMP addend
	;

addend :
	term
	| addend MINUS term
	| addend PLUS term
	;

term :
	factor
	| term MOD factor
	| term DIVIDE factor
	| term TIMES factor
	;

factor :
	atom
	| PLUS atom
	| MINUS atom
	;

atom :
	BOOLEAN
	| INTEGER
	| ID LPAREN arg_list_opt RPAREN
	| ID
	| LPAREN expr RPAREN
	;

%%

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"&&"	AND
"="	ASSIGN
"{"	BEGIN
"true"|"false"	BOOLEAN
","	COMMA
"=="|"<="|">="|"!="|">"|"<"	COMP
"/"	DIVIDE
"else"	ELSE
"}"	END
"if"	IF
"("	LPAREN
"-"	MINUS
"%"	MOD
"!"	NOT
"||"	OR
"+"	PLUS
"print"|"println"	PRINT
"return"	RETURN
")"	RPAREN
";"	SEMICOLON
"*"	TIMES
"int"|"bool"	TYPE
"while"	WHILE

[0-9]+	INTEGER
\"(\\.|[^"\r\n\\])*\"	STRING
[A-Za-z_][A-Za-z0-9_]*	ID

%%
