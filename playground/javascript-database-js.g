//From: https://github.com/malbrain/javascript-database/blob/69cf58f0c63cacc6fda0c8cc296f995bb9897e79/js.y

/*Tokens*/
%token STRING
%token NAME
%token NUM
//%token EOS
%token IF
%token ELSE
%token WHILE
%token DO
%token FOR
%token FCN
%token VAR
%token LET
%token RETURN
%token CONTINUE
%token BREAK
%token LPAR
%token RPAR
%token COLON
%token COMMA
%token LBRACE
%token RBRACE
%token LBRACK
%token RBRACK
%token SEMI
%token ENUM
%token INCR
%token DECR
%token DOT
%token NOT
%token BITNOT
%token BITAND
%token BITXOR
%token BITOR
%token TERN
%token FORIN
%token FOROF
%token TRY
%token CATCH
%token FINALLY
%token THROW
%token NEW
%token PIPE
%token PLUS_ASSIGN
%token MINUS_ASSIGN
%token LSHIFT_ASSIGN
%token RSHIFT_ASSIGN
%token ASSIGN
%token MPY_ASSIGN
%token DIV_ASSIGN
%token MOD_ASSIGN
%token AND_ASSIGN
%token XOR_ASSIGN
%token OR_ASSIGN
%token LOR
%token LAND
%token IDENTICAL
%token NOTIDENTICAL
%token LT
%token LE
%token EQ
%token NEQ
%token GT
%token GE
%token LSHIFT
%token RSHIFT
%token RUSHIFT
%token PLUS
%token MINUS
%token MPY
%token DIV
%token MOD
%token DEL
%token TYPEOF

%precedence /*1*/ NAME
%right /*2*/ ELSE RPAR
%right /*3*/ PLUS_ASSIGN MINUS_ASSIGN LSHIFT_ASSIGN RSHIFT_ASSIGN ASSIGN MPY_ASSIGN DIV_ASSIGN MOD_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN
%left /*4*/ COLON TERN
%left /*5*/ LOR
%left /*6*/ LAND
%left /*7*/ BITOR
%left /*8*/ BITXOR
%left /*9*/ BITAND
%left /*10*/ IDENTICAL NOTIDENTICAL LT LE EQ NEQ GT GE
%left /*11*/ LSHIFT RSHIFT RUSHIFT
%left /*12*/ PLUS MINUS
%left /*13*/ MPY DIV MOD
%precedence /*14*/ NEW DEL
%precedence /*15*/ TYPEOF
%precedence /*16*/ INCR DECR
%precedence /*17*/ NOT BITNOT
%precedence /*18*/ UMINUS
%precedence /*19*/ LBRACK DOT
%precedence /*20*/ LPAR

%start script

%%

script :
	/*EOS
	|*/ pgmlist
	;

pgmlist :
	/*empty*/
	| pgmlist stmt
	| pgmlist funcdef
	;

funcdef :
	FCN NAME /*1P*/ LPAR /*20P*/ paramlist_opt RPAR /*2R*/ LBRACE pgmlist RBRACE
	;

fname :
	/*empty*/
	| NAME /*1P*/
	;

pipeline :
	expr PIPE expr
	| pipeline PIPE expr
	;

stmt :
	IF LPAR /*20P*/ exprlist_opt RPAR /*2R*/ stmt
	| IF LPAR /*20P*/ exprlist_opt RPAR /*2R*/ stmt ELSE /*2R*/ stmt
	| THROW expr SEMI
	| RETURN exprlist_opt SEMI
	| BREAK SEMI
	| CONTINUE SEMI
	| WHILE LPAR /*20P*/ exprlist_opt RPAR /*2R*/ stmt
	| DO stmt WHILE LPAR /*20P*/ exprlist_opt RPAR /*2R*/ SEMI
	| FOR LPAR /*20P*/ LET scopedlist SEMI exprlist_opt SEMI exprlist_opt RPAR /*2R*/ stmt
	| FOR LPAR /*20P*/ VAR decllist SEMI exprlist_opt SEMI exprlist_opt RPAR /*2R*/ stmt
	| FOR LPAR /*20P*/ exprlist_opt SEMI exprlist_opt SEMI exprlist_opt RPAR /*2R*/ stmt
	| FOR LPAR /*20P*/ LET decl FORIN expr RPAR /*2R*/ stmt
	| FOR LPAR /*20P*/ VAR decl FORIN expr RPAR /*2R*/ stmt
	| FOR LPAR /*20P*/ expr FORIN expr RPAR /*2R*/ stmt
	| FOR LPAR /*20P*/ LET decl FOROF expr RPAR /*2R*/ stmt
	| FOR LPAR /*20P*/ VAR decl FOROF expr RPAR /*2R*/ stmt
	| FOR LPAR /*20P*/ expr FOROF expr RPAR /*2R*/ stmt
	| TRY LBRACE stmtlist RBRACE CATCH LPAR /*20P*/ NAME /*1P*/ RPAR /*2R*/ LBRACE stmtlist RBRACE
	| TRY LBRACE stmtlist RBRACE FINALLY LBRACE stmtlist RBRACE
	| TRY LBRACE stmtlist RBRACE CATCH LPAR /*20P*/ NAME /*1P*/ RPAR /*2R*/ LBRACE stmtlist RBRACE FINALLY LBRACE stmtlist RBRACE
	| LBRACE stmtlist RBRACE
	| LET scopedlist SEMI
	| VAR decllist SEMI
	| exprlist_opt SEMI
	| pipeline SEMI
	;

stmtlist :
	/*empty*/
	| stmt stmtlist
	;

symbol :
	NAME /*1P*/
	;

decl :
	symbol
	| symbol ASSIGN /*3R*/ expr
	;

scopeddecl :
	symbol
	| symbol ASSIGN /*3R*/ expr
	;

scopedlist :
	scopeddecl
	| scopedlist COMMA scopeddecl
	;

decllist :
	decl
	| decllist COMMA decl
	;

enum :
	NAME /*1P*/
	| NAME /*1P*/ ASSIGN /*3R*/ expr
	;

enumlist :
	enum
	| enumlist COMMA enum
	;

expr :
	expr TERN /*4L*/ expr COLON /*4L*/ expr
	| ENUM LBRACE enumlist RBRACE
	| FCN fname LPAR /*20P*/ paramlist_opt RPAR /*2R*/ LBRACE pgmlist RBRACE
	| TYPEOF /*15P*/ expr
	| INCR /*16P*/ expr %prec UMINUS /*18P*/
	| DECR /*16P*/ expr %prec UMINUS /*18P*/
	| expr INCR /*16P*/
	| expr DECR /*16P*/
	| expr RUSHIFT /*11L*/ expr
	| expr RSHIFT /*11L*/ expr
	| expr LSHIFT /*11L*/ expr
	| expr LOR /*5L*/ expr
	| expr LAND /*6L*/ expr
	| expr LT /*10L*/ expr
	| expr LE /*10L*/ expr
	| expr EQ /*10L*/ expr
	| expr NEQ /*10L*/ expr
	| expr IDENTICAL /*10L*/ expr
	| expr NOTIDENTICAL /*10L*/ expr
	| expr GE /*10L*/ expr
	| expr GT /*10L*/ expr
	| expr PLUS /*12L*/ expr
	| expr MINUS /*12L*/ expr
	| expr MPY /*13L*/ expr
	| expr MOD /*13L*/ expr
	| expr DIV /*13L*/ expr
	| expr BITAND /*9L*/ expr
	| expr BITXOR /*8L*/ expr
	| expr BITOR /*7L*/ expr
	| MINUS /*12L*/ expr %prec UMINUS /*18P*/
	| NOT /*17P*/ expr
	| BITNOT /*17P*/ expr
	| LPAR /*20P*/ exprlist_opt RPAR /*2R*/
	| expr ASSIGN /*3R*/ expr
	| expr LSHIFT_ASSIGN /*3R*/ expr
	| expr RSHIFT_ASSIGN /*3R*/ expr
	| expr PLUS_ASSIGN /*3R*/ expr
	| expr MINUS_ASSIGN /*3R*/ expr
	| expr MPY_ASSIGN /*3R*/ expr
	| expr MOD_ASSIGN /*3R*/ expr
	| expr DIV_ASSIGN /*3R*/ expr
	| expr AND_ASSIGN /*3R*/ expr
	| expr OR_ASSIGN /*3R*/ expr
	| expr XOR_ASSIGN /*3R*/ expr
	| NEW /*14P*/ expr
	| expr LPAR /*20P*/ arglist_opt RPAR /*2R*/
	| NUM
	| STRING
	| DEL /*14P*/ expr
	| objarraylit
	| expr DOT /*19P*/ NAME /*1P*/
	| expr LBRACK /*19P*/ expr RBRACK
	| BITAND /*9L*/ symbol
	| symbol
	;

exprlist_opt :
	/*empty*/
	| exprlist
	;

exprlist :
	expr
	| exprlist COMMA expr
	;

arglist_opt :
	/*empty*/
	| arglist
	;

arglist :
	expr
	| arglist COMMA expr
	;

objarraylit :
	LBRACE elemlist_opt RBRACE
	| LBRACK /*19P*/ arraylist_opt RBRACK
	;

elem :
	NAME /*1P*/ COLON /*4L*/ expr
	| STRING COLON /*4L*/ expr
	;

arraylist_opt :
	/*empty*/
	| arraylist
	;

arraylist :
	expr
	| arraylist COMMA expr
	;

elemlist_opt :
	/*empty*/
	| elemlist
	;

elemlist :
	elem
	| elemlist COMMA elem
	;

paramlist_opt :
	/*empty*/
	| paramlist
	;

paramlist :
	symbol
	| paramlist COMMA symbol
	;

%%

EXP		([Ee][-+]?[0-9]+)

%%

	/* single charater ops */
"+"			PLUS
"-"			MINUS
"*"			MPY
"/"			DIV
"%"			MOD
"="			ASSIGN
"+="		PLUS_ASSIGN
"-="		MINUS_ASSIGN
"*="		MPY_ASSIGN
"&="		AND_ASSIGN
"^="		XOR_ASSIGN
"|="		OR_ASSIGN
"/="		DIV_ASSIGN
"%="		MOD_ASSIGN
"<<="		LSHIFT_ASSIGN
">>="		RSHIFT_ASSIGN
","			COMMA
";"			SEMI
"("			LPAR
")"			RPAR
"{"			LBRACE
"}"			RBRACE
"["			LBRACK
"]"			RBRACK
":"			COLON
"."			DOT
"!"			NOT
"?"			TERN

"~"			BITNOT
"&"			BITAND
"^"			BITXOR
"|"			BITOR

"++"		INCR
"--"		DECR
"<"			LT
"<="		LE
"=="		EQ
"!="		NEQ
">="		GE
">"			GT
">>"		RSHIFT
">>>"		RUSHIFT
"<<"		LSHIFT
"||"		LOR
"&&"		LAND
"!=="		NOTIDENTICAL
"==="		IDENTICAL
"|>"        PIPE

	/* keywords */
"if"		IF
"else"		ELSE
"while"		WHILE
"do"		DO
"for"		FOR
"function"	FCN
"var"		VAR
"let"		LET
"new"		NEW
"return"	RETURN
"continue"	CONTINUE
"break"		BREAK
"enum"		ENUM
"typeof"	TYPEOF
"in"		FORIN
"of"		FOROF
"try"		TRY
"catch"		CATCH
"finally"	FINALLY
"throw"		THROW
"delete"	DEL


	/* names */
[a-zA-Z$_][a-zA-Z0-9_]* NAME

	/* strings */
'(\\.|[^'\n\r\\])*' STRING

\"(\\.|[^"\n\r\\])*\" STRING

	/* single and multi-line comments */
"//".*	skip()

"/*"([^*]|(\*+[^*/]))*\*+\/ skip()

	/* numbers */
0[bB][0-1]+ NUM

0[oO][0-7]+ NUM

0[xX][0-9a-fA-F]+ NUM

[0-9]+	NUM

[0-9]+{EXP} NUM
[0-9]+"."[0-9]* NUM
[0-9]+"."[0-9]*{EXP} NUM
"."[0-9]+ NUM
"."[0-9]+{EXP} NUM

	/* line numbers */
\n	skip()
	/* the rest */
[ \t\r]		skip()

//.				{ printf("script: %s line:%d Mystery character <%.2X>\n", pd->script, pd->lineNo, *yytext)
//<<EOF>>		EOS

%%
