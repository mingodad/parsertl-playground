/*
 *  R : A Computer Language for Statistical Data Analysis
 *  Copyright (C) 1997--2023  The R Core Team
 *  Copyright (C) 2009--2011  Romain Francois
 *  Copyright (C) 1995--1997  Robert Gentleman and Ross Ihaka
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, a copy is available at
 *  https://www.R-project.org/Licenses/
 */

/*Tokens*/
//%token END_OF_INPUT
//%token ERROR
%token STR_CONST
%token NUM_CONST
%token NULL_CONST
%token SYMBOL
%token FUNCTION
//%token INCOMPLETE_STRING
%token LEFT_ASSIGN
%token EQ_ASSIGN
%token RIGHT_ASSIGN
%token LBB
%token FOR
%token IN
%token IF
%token ELSE
%token WHILE
%token NEXT
%token BREAK
%token REPEAT
%token GT
%token GE
%token LT
%token LE
%token EQ
%token NE
%token AND
%token OR
%token AND2
%token OR2
%token NS_GET
%token NS_GET_INT
//%token COMMENT
//%token LINE_DIRECTIVE
//%token SYMBOL_FORMALS
//%token EQ_FORMALS
//%token EQ_SUB
//%token SYMBOL_SUB
//%token SYMBOL_FUNCTION_CALL
//%token SYMBOL_PACKAGE
//%token SLOT
%token PIPE
%token PLACEHOLDER
%token PIPEBIND
%token '?'
%token '~'
%token '+'
%token '-'
%token '*'
%token '/'
%token SPECIAL
%token ':'
%token UMINUS
%token UPLUS
%token '^'
%token '$'
%token '@'
%token '('
%token '['
%token NL
%token ';'
%token '{'
%token '}'
%token ')'
%token '!'
%token '\\'
%token ']'
%token ','

%left /*1*/ '?'
%left /*2*/ FOR WHILE REPEAT LOW
%right /*3*/ IF
%left /*4*/ ELSE
%right /*5*/ LEFT_ASSIGN
%right /*6*/ EQ_ASSIGN
%left /*7*/ RIGHT_ASSIGN
%left /*8*/ '~' TILDE
%left /*9*/ OR OR2
%left /*10*/ AND AND2
%left /*11*/ UNOT NOT
%nonassoc /*12*/ GT GE LT LE EQ NE
%left /*13*/ '+' '-'
%left /*14*/ '*' '/'
%left /*15*/ PIPE SPECIAL
%left /*16*/ PIPEBIND
%left /*17*/ ':'
%left /*18*/ UMINUS UPLUS
%right /*19*/ '^'
%left /*20*/ '$' '@'
%left /*21*/ NS_GET NS_GET_INT
%nonassoc /*22*/ LBB '(' '['

%start prog

%%

prog :
	command
	| prog command
	;

command :
	NL
	| expr_or_assign_or_help NL
	| expr_or_assign_or_help ';'
	//| error
    ;

expr_or_assign_or_help :
	expr
	| expr_or_assign_or_help EQ_ASSIGN /*6R*/ expr_or_assign_or_help
	| expr_or_assign_or_help '?' /*1L*/ expr_or_assign_or_help
	;

expr_or_help :
	expr
	| expr_or_help '?' /*1L*/ expr_or_help
	;

expr :
	NUM_CONST
	| STR_CONST
	| NULL_CONST
	| PLACEHOLDER
	| SYMBOL
	| '{' exprlist '}'
	| '(' /*22N*/ expr_or_assign_or_help ')'
	| '-' /*13L*/ expr %prec UMINUS /*18L*/
	| '+' /*13L*/ expr %prec UMINUS /*18L*/
	| '!' expr %prec UNOT /*11L*/
	| '~' /*8L*/ expr %prec TILDE /*8L*/
	| '?' /*1L*/ expr_or_assign_or_help
	| expr ':' /*17L*/ expr
	| expr '+' /*13L*/ expr
	| expr '-' /*13L*/ expr
	| expr '*' /*14L*/ expr
	| expr '/' /*14L*/ expr
	| expr '^' /*19R*/ expr
	| expr SPECIAL /*15L*/ expr
	| expr '~' /*8L*/ expr
	| expr LT /*12N*/ expr
	| expr LE /*12N*/ expr
	| expr EQ /*12N*/ expr
	| expr NE /*12N*/ expr
	| expr GE /*12N*/ expr
	| expr GT /*12N*/ expr
	| expr AND /*10L*/ expr
	| expr OR /*9L*/ expr
	| expr AND2 /*10L*/ expr
	| expr OR2 /*9L*/ expr
	| expr PIPE /*15L*/ expr
	| expr PIPEBIND /*16L*/ expr
	| expr LEFT_ASSIGN /*5R*/ expr
	| expr RIGHT_ASSIGN /*7L*/ expr
	| FUNCTION '(' /*22N*/ formlist ')' cr expr_or_assign_or_help %prec LOW /*2L*/
	| '\\' '(' /*22N*/ formlist ')' cr expr_or_assign_or_help %prec LOW /*2L*/
	| expr '(' /*22N*/ sublist ')'
	| IF /*3R*/ ifcond expr_or_assign_or_help
	| IF /*3R*/ ifcond expr_or_assign_or_help ELSE /*4L*/ expr_or_assign_or_help
	| FOR /*2L*/ forcond expr_or_assign_or_help %prec FOR /*2L*/
	| WHILE /*2L*/ cond expr_or_assign_or_help
	| REPEAT /*2L*/ expr_or_assign_or_help
	| expr LBB /*22N*/ sublist ']' ']'
	| expr '[' /*22N*/ sublist ']'
	| SYMBOL NS_GET /*21L*/ SYMBOL
	| SYMBOL NS_GET /*21L*/ STR_CONST
	| STR_CONST NS_GET /*21L*/ SYMBOL
	| STR_CONST NS_GET /*21L*/ STR_CONST
	| SYMBOL NS_GET_INT /*21L*/ SYMBOL
	| SYMBOL NS_GET_INT /*21L*/ STR_CONST
	| STR_CONST NS_GET_INT /*21L*/ SYMBOL
	| STR_CONST NS_GET_INT /*21L*/ STR_CONST
	| expr '$' /*20L*/ SYMBOL
	| expr '$' /*20L*/ STR_CONST
	| expr '@' /*20L*/ SYMBOL
	| expr '@' /*20L*/ STR_CONST
	| NEXT
	| BREAK
	;

cond :
	'(' /*22N*/ expr_or_help ')'
	;

ifcond :
	'(' /*22N*/ expr_or_help ')'
	;

forcond :
	'(' /*22N*/ SYMBOL IN expr_or_help ')'
	;

exprlist :
	/*empty*/
	| expr_or_assign_or_help
	| exprlist ';' expr_or_assign_or_help
	| exprlist ';'
	| exprlist NL expr_or_assign_or_help
	| exprlist NL
	;

sublist :
	sub
	| sublist cr ',' sub
	;

sub :
	/*empty*/
	| expr_or_help
	| SYMBOL EQ_ASSIGN /*6R*/
	| SYMBOL EQ_ASSIGN /*6R*/ expr_or_help
	| STR_CONST EQ_ASSIGN /*6R*/
	| STR_CONST EQ_ASSIGN /*6R*/ expr_or_help
	| NULL_CONST EQ_ASSIGN /*6R*/
	| NULL_CONST EQ_ASSIGN /*6R*/ expr_or_help
	;

formlist :
	/*empty*/
	| SYMBOL
	| SYMBOL EQ_ASSIGN /*6R*/ expr_or_help
	| formlist ',' SYMBOL
	| formlist ',' SYMBOL EQ_ASSIGN /*6R*/ expr_or_help
	;

cr :
	/*empty*/
	;

%%

ident [A-Za-z_.][A-Za-z0-9_.]*

%%

[ \t\r]	skip()
"#".*	skip()
\n	NL

"NULL"	    NULL_CONST
"NA"	    NUM_CONST
"TRUE"	    NUM_CONST
"FALSE"	    NUM_CONST
"Inf"	    NUM_CONST
"NaN"	    NUM_CONST
"NA_integer_" NUM_CONST
"NA_real_"    NUM_CONST
"NA_character_" NUM_CONST
"NA_complex_" NUM_CONST
"function"   FUNCTION
"while"	    WHILE
"repeat"	    REPEAT
"for"	    FOR
"if"	    IF
"in"	    IN
"else"	    ELSE
"next"	    NEXT
"break"	    BREAK
"..."	    SYMBOL
"="	EQ_ASSIGN
"->"	RIGHT_ASSIGN
"[["	LBB
"for"	FOR
"in"	IN
"if"	IF
">"	GT
">="	GE
"<"	LT
"<="	LE
"=="	EQ
"!="	NE
"&"	AND
"|"	OR
"&&"	AND2
"||"	OR2
"::"	NS_GET
":::"	NS_GET_INT
"|>"	PIPE
"=>"	PIPEBIND
"_"	PLACEHOLDER


"?"	'?'
"~"	'~'
"+"	'+'
"-"	'-'
"*"	'*'
"/"	'/'
":"	':'
"^"	'^'
"$"	'$'
"@"	'@'
"("	'('
"["	'['
";"	';'
"{"	'{'
"}"	'}'
")"	')'
"!"	'!'
"\\"	'\\'
"]"	']'
","	','

"<-"	LEFT_ASSIGN


\"("\\".|[^"\n\r\\])*\"	STR_CONST
[0-9]+("."[0-9]+)?[L]?	NUM_CONST
{ident}	SYMBOL
"%"{ident}	SPECIAL

%%
