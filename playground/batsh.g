//From: https://github.com/batsh-dev-team/Batsh/blob/bfd467bc0d2469c2c2d4f40b5d142e6a191edbee/lib/parser_yacc.mly

%token AEQ
%token ANE
%token COMMA
%token COMMENT
%token CONCAT
%token DIVIDE
%token ELSE
//%token EOF
%token EQUAL
%token FALSE
%token FLOAT
%token FUNCTION
%token GE
%token GLOBAL
%token GT
%token IDENTIFIER
%token IF
%token INT
%token LE
%token LEFT_BRACE
%token LEFT_BRACK
%token LEFT_PAREN
%token LT
%token MINUS
%token MODULO
%token MULTIPLY
%token NOT
%token PLUS
%token RETURN
%token RIGHT_BRACE
%token RIGHT_BRACK
%token RIGHT_PAREN
%token SEMICOLON
%token SEQ
%token SNE
%token STRING
%token TRUE
%token WHILE

%nonassoc AEQ ANE SEQ SNE
%nonassoc GE GT LE LT
%left CONCAT
%nonassoc NOT
%left MINUS PLUS
%left DIVIDE MODULO MULTIPLY
%nonassoc IF
%nonassoc ELSE

%%

program :
	toplevel_list
	;

toplevel :
	statement
	| FUNCTION IDENTIFIER LEFT_PAREN identifier_list RIGHT_PAREN LEFT_BRACE statement_list RIGHT_BRACE
	;

toplevel_list :
	/*empty*/
	| toplevel_list toplevel
	;

statement :
	SEMICOLON
	| COMMENT
	| expression SEMICOLON
	| LEFT_BRACE statement_list RIGHT_BRACE
	| leftvalue EQUAL expression SEMICOLON
	| if_statement
	| loop_statement
	| GLOBAL IDENTIFIER SEMICOLON
	| RETURN expression SEMICOLON
	| RETURN SEMICOLON
	;

statement_list :
	/*empty*/
	| statement_list statement
	;

if_statement :
	IF LEFT_PAREN expression RIGHT_PAREN statement %prec IF
	| IF LEFT_PAREN expression RIGHT_PAREN statement ELSE statement
	;

loop_statement :
	WHILE LEFT_PAREN expression RIGHT_PAREN statement
	;

expression :
	leftvalue
	| STRING
	| INT
	| FLOAT
	| TRUE
	| FALSE
	| LEFT_BRACK expression_list RIGHT_BRACK
	| unary_expression
	| binary_expression
	| LEFT_PAREN expression RIGHT_PAREN
	| IDENTIFIER LEFT_PAREN expression_list RIGHT_PAREN
	;

expression_list :
	/*empty*/
	| expression
	| expression_list COMMA expression
	;

identifier_list :
	/*empty*/
	| IDENTIFIER
	| identifier_list COMMA IDENTIFIER
	;

leftvalue :
	IDENTIFIER
	| leftvalue LEFT_BRACK expression RIGHT_BRACK
	;

unary_expression :
	NOT expression
	;

binary_expression :
	expression PLUS expression
	| expression MINUS expression
	| expression MULTIPLY expression
	| expression DIVIDE expression
	| expression MODULO expression
	| expression AEQ expression
	| expression ANE expression
	| expression GT expression
	| expression LT expression
	| expression GE expression
	| expression LE expression
	| expression CONCAT expression
	| expression SEQ expression
	| expression SNE expression
	;

%%

digit  [0-9]
int  "-"?{digit}{digit}*

frac  "."{digit}*
exp  [eE][-+]?{digit}+
float  {digit}*{frac}?{exp}?

white  [ \t]+
newline  "\r"|"\n"|"\r\n"
ident  [a-zA-Z_][a-zA-Z0-9_]*

%%

{white}    skip()
{newline}  skip()

"//".*	COMMENT

"true"   TRUE
"false"  FALSE
"if"     IF
"else"   ELSE
"while"  WHILE
"function" FUNCTION
"global" GLOBAL
"return" RETURN
"="      EQUAL
"("      LEFT_PAREN
")"      RIGHT_PAREN
"{"      LEFT_BRACE
"}"      RIGHT_BRACE
"["      LEFT_BRACK
"]"      RIGHT_BRACK
";"      SEMICOLON
","      COMMA
"+"      PLUS
"-"      MINUS
"*"      MULTIPLY
"/"      DIVIDE
"%"      MODULO
"++"     CONCAT
"!"      NOT
"=="     SEQ
"!="     SNE
"==="    AEQ
"!=="    ANE
">"      GT
"<"      LT
">="     GE
"<="     LE
//eof      EOF

{int}      INT
{digit}{exp}    FLOAT
{digit}*{frac}{exp}?    FLOAT
\"(\\.|[^"\r\n\\])*\"	STRING

{ident}    IDENTIFIER

%%
