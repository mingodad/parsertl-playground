//From: https://github.com/coreyp1/CTang/blob/09998fe1e4dd9517f0e0827a022f6b7dc9ef7bae/bison/tangParser.y
/*Tokens*/
%token AND
%token AS
%token ASSIGN
%token BOOLEAN
%token BREAK
//%token CASTBOOLEAN
//%token CASTFLOAT
//%token CASTINT
//%token CASTSTRING
%token COLON
%token COMMA
%token CONTINUE
%token DIVIDE
%token DO
%token ELSE
%token EQUALCOMPARE
%token EXCLAMATIONPOINT
%token FLOAT
%token FOR
%token FUNCTION
%token GLOBAL
%token GREATERTHAN
%token GREATERTHANEQUAL
%token IDENTIFIER
%token IF
%token INTEGER
%token LBRACE
%token LBRACKET
%token LESSTHAN
%token LESSTHANEQUAL
%token LPAREN
//%token MEMORYERROR
%token MINUS
%token MODULO
%token MULTIPLY
%token NOTEQUAL
%token NULL_
//%token OCTAL_OUT_OF_BOUNDS
%token OR
%token PERIOD
%token PLUS
%token PRINT
%token QUESTIONMARK
%token QUICKPRINTBEGIN
%token QUICKPRINTBEGINANDSTRING
%token QUICKPRINTEND
%token RBRACE
%token RBRACKET
%token RETURN
%token RPAREN
%token SEMICOLON
%token STRING
//%token STRINGERROR
%token TEMPLATESTRING
//%token UNEXPECTEDSCRIPTEND
%token USE
%token WHILE

%right /*1*/ ASSIGN QUESTIONMARK COLON
%left /*2*/ OR
%left /*3*/ AND
%left /*4*/ EQUALCOMPARE NOTEQUAL
%left /*5*/ LESSTHAN LESSTHANEQUAL GREATERTHAN GREATERTHANEQUAL
%left /*6*/ PLUS MINUS
%left /*7*/ MULTIPLY DIVIDE MODULO
%right /*8*/ EXCLAMATIONPOINT AS UMINUS
%left /*9*/ LPAREN RPAREN LBRACKET RBRACKET PERIOD

%start program

%%

program :
	expression
	| statements
	;

functionDeclarationArguments :
	/*empty*/
	| IDENTIFIER
	| functionDeclarationArguments COMMA IDENTIFIER
	;

expressionList :
	/*empty*/
	| expression
	| expressionList COMMA expression
	;

mapList :
	IDENTIFIER COLON /*1R*/ expression
	| mapList COMMA IDENTIFIER COLON /*1R*/ expression
	| mapList COMMA
	;

statements :
	statement
	| statements statement
	;

statement :
	closedStatement
	| openStatement
	;

closedStatement :
	IF LPAREN /*9L*/ expression RPAREN /*9L*/ closedStatement ELSE closedStatement
	| WHILE LPAREN /*9L*/ expression RPAREN /*9L*/ closedStatement
	| DO statement WHILE LPAREN /*9L*/ expression RPAREN /*9L*/ SEMICOLON
	| FOR LPAREN /*9L*/ optionalExpression SEMICOLON optionalExpression SEMICOLON optionalExpression RPAREN /*9L*/ closedStatement
	| FOR LPAREN /*9L*/ IDENTIFIER COLON /*1R*/ expression RPAREN /*9L*/ closedStatement
	| FUNCTION IDENTIFIER LPAREN /*9L*/ functionDeclarationArguments RPAREN /*9L*/ codeBlock
	| codeBlock
	| RETURN SEMICOLON
	| RETURN expression SEMICOLON
	| BREAK SEMICOLON
	| CONTINUE SEMICOLON
	| expression SEMICOLON
	| TEMPLATESTRING
	| QUICKPRINTBEGINANDSTRING expression QUICKPRINTEND
	| QUICKPRINTBEGIN expression QUICKPRINTEND
	| USE IDENTIFIER SEMICOLON
	| USE libraryExpression AS /*8R*/ IDENTIFIER SEMICOLON
	| GLOBAL IDENTIFIER SEMICOLON
	| GLOBAL IDENTIFIER ASSIGN /*1R*/ expression SEMICOLON
	;

libraryExpression :
	IDENTIFIER
	| libraryExpression PERIOD /*9L*/ IDENTIFIER
	;

openStatement :
	IF LPAREN /*9L*/ expression RPAREN /*9L*/ statement
	| IF LPAREN /*9L*/ expression RPAREN /*9L*/ closedStatement ELSE openStatement
	| WHILE LPAREN /*9L*/ expression RPAREN /*9L*/ openStatement
	| FOR LPAREN /*9L*/ optionalExpression SEMICOLON optionalExpression SEMICOLON optionalExpression RPAREN /*9L*/ openStatement
	| FOR LPAREN /*9L*/ IDENTIFIER COLON /*1R*/ expression RPAREN /*9L*/ openStatement
	;

optionalExpression :
	/*empty*/
	| expression
	;

slice :
	expression LBRACKET /*9L*/ optionalExpression COLON /*1R*/ optionalExpression COLON /*1R*/ optionalExpression RBRACKET /*9L*/
	| expression LBRACKET /*9L*/ optionalExpression COLON /*1R*/ optionalExpression RBRACKET /*9L*/
	;

codeBlock :
	LBRACE RBRACE
	| LBRACE statements RBRACE
	;

expression :
	NULL_
	| IDENTIFIER
	| INTEGER
	| FLOAT
	| BOOLEAN
	| STRING
	| expression ASSIGN /*1R*/ expression
	| expression PLUS /*6L*/ expression
	| expression MINUS /*6L*/ expression
	| expression MULTIPLY /*7L*/ expression
	| expression DIVIDE /*7L*/ expression
	| expression MODULO /*7L*/ expression
	| MINUS /*6L*/ expression %prec UMINUS /*8R*/
	| EXCLAMATIONPOINT /*8R*/ expression
	| expression LESSTHAN /*5L*/ expression
	| expression LESSTHANEQUAL /*5L*/ expression
	| expression GREATERTHAN /*5L*/ expression
	| expression GREATERTHANEQUAL /*5L*/ expression
	| expression EQUALCOMPARE /*4L*/ expression
	| expression NOTEQUAL /*4L*/ expression
	| expression AND /*3L*/ expression
	| expression OR /*2L*/ expression
	| slice
	| LPAREN /*9L*/ expression RPAREN /*9L*/
	| expression AS /*8R*/ INTEGER
	| expression AS /*8R*/ FLOAT
	| expression AS /*8R*/ BOOLEAN
	| expression AS /*8R*/ STRING
	| PRINT LPAREN /*9L*/ expression RPAREN /*9L*/
	| expression PERIOD /*9L*/ IDENTIFIER
	| LBRACKET /*9L*/ expressionList RBRACKET /*9L*/
	| LBRACE COLON /*1R*/ RBRACE
	| LBRACE mapList RBRACE
	| expression LBRACKET /*9L*/ expression RBRACKET /*9L*/
	| expression LPAREN /*9L*/ expressionList RPAREN /*9L*/
	| expression QUESTIONMARK /*1R*/ expression COLON /*1R*/ expression
	;

%%

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"&&"	AND
"as"	AS
"="	ASSIGN
"true"|"false"	BOOLEAN
"break"	BREAK
//CASTBOOLEAN	CASTBOOLEAN
//CASTFLOAT	CASTFLOAT
//CASTINT	CASTINT
//CASTSTRING	CASTSTRING
":"	COLON
","	COMMA
"continue"	CONTINUE
"/"	DIVIDE
"do"	DO
"else"	ELSE
"=="	EQUALCOMPARE
"!"	EXCLAMATIONPOINT
"for"	FOR
"function"	FUNCTION
"global"	GLOBAL
">"	GREATERTHAN
">="	GREATERTHANEQUAL
"if"	IF
"{"	LBRACE
"["	LBRACKET
"<"	LESSTHAN
"<="	LESSTHANEQUAL
"("	LPAREN
//MEMORYERROR	MEMORYERROR
"-"	MINUS
"%"	MODULO
"*"	MULTIPLY
"!="	NOTEQUAL
"null"	NULL_
//OCTAL_OUT_OF_BOUNDS	OCTAL_OUT_OF_BOUNDS
"||"	OR
"."	PERIOD
"+"	PLUS
"print"	PRINT
"?"	QUESTIONMARK
QUICKPRINTBEGIN	QUICKPRINTBEGIN
QUICKPRINTBEGINANDSTRING	QUICKPRINTBEGINANDSTRING
QUICKPRINTEND	QUICKPRINTEND
"}"	RBRACE
"]"	RBRACKET
"return"	RETURN
")"	RPAREN
";"	SEMICOLON
//STRINGERROR	STRINGERROR
TEMPLATESTRING	TEMPLATESTRING
xxx_UMINUS	UMINUS
//UNEXPECTEDSCRIPTEND	UNEXPECTEDSCRIPTEND
"use"	USE
"while"	WHILE

[0-9]+	INTEGER
[0-9]+"."[0-9]+	FLOAT
\"(\\.|[^"\r\n\\])*\"	STRING
[a-zA-Z_][a-zA-Z0-9_]*	IDENTIFIER

%%
