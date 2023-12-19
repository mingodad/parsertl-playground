//From : https://github.com/krisds/koopa

/*
  Using #__skip to hide/skip protions of the parser tree
*/

%token IDENTIFIER STRING DOT PROCEDURE_DIVISION

%%

source :
	water1_skip
	PROCEDURE_DIVISION water2_skip DOT
	sentence_zom
	;

sentence_zom :
    %empty
    | sentence_zom sentence
    ;

sentence :
	statement_zom DOT
	;

statement_zom :
    %empty
    | statement_zom statement
    ;

statement :
	call | verb water2_skip
	;

call :
	"CALL" (STRING | IDENTIFIER)
	;

verb :
	"OPEN"
	| "SET"
	| "MOVE"
	| "WRITE"
	| "GOBACK"
	//| "CALL"
	;

water1_skip :
    water1_zom #__skip
    ;

water1_zom :
    %empty
    | water1_zom water1
    ;

water1 :
	DOT
	| STRING
	| IDENTIFIER
	;

water2_skip :
    water2_zom #__skip
    ;

water2_zom :
    %empty
    | water2_zom water2
    ;

water2 :
	STRING
	| IDENTIFIER
	;

%%

%%

[\n\r\t ]+	skip()

"PROCEDURE DIVISION"	PROCEDURE_DIVISION
"CALL"	"CALL"
"OPEN"	"OPEN"
"SET" 	"SET"
"MOVE"	"MOVE"
"WRITE" 	"WRITE"
"GOBACK"	"GOBACK"
"."	DOT

\"(\\.|[^"\n\r\\])*\"	STRING
[A-Za-z_][A-Za-z0-9_-]* IDENTIFIER
. skip()

%%
