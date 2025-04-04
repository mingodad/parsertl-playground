//From: https://github.com/GunterMueller/MaxDB_GPL_Releases/blob/15821507c20bd1cd251cf4e7c60610ac9cabc06d/7.6.00.37/TOOLSRC/sys/src/base/mf/concom.y

/*	concom.y

    ========== licence begin LGPL
    Copyright (C) 2002 SAP AG

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
    ========== licence end

*/

/*
 *  Conditional Compilation
 *  Parser and Lexical Analyzer
 */

/*Tokens*/
%token AND
%token DEFINE
%token DEFINED
%token ELIF
%token ELSE
%token ENDIF
%token EQ
%token IDENTIFIER
%token IF
%token IFDEF
%token IFNDEF
%token IN
%token NEQ
%token NOT
%token NUMBER
%token OR
%token TOKEN
%token UNDEF

%left /*1*/ OR
%left /*2*/ AND
%left /*3*/ EQ NEQ
%right /*4*/ NOT
%right /*5*/ IN

%start input //line

%%

input : //to allow parse multline for test
    line
    | input line
    ;

line :
	DEFINE ident expr
	| DEFINE ident
	| UNDEF ident
	| IFDEF ident
	| IFNDEF ident
	| IF expr
	| ELIF expr
	| ELSE comment
	| ENDIF comment
	;

expr :
	'(' expr ')'
	| NOT /*4R*/ expr
	| expr IN /*5R*/ '[' exprlst ']'
	| expr NOT /*4R*/ IN /*5R*/ '[' exprlst ']'
	| expr EQ /*3L*/ expr
	| expr NEQ /*3L*/ expr
	| expr AND /*2L*/ expr
	| expr OR /*1L*/ expr
	| DEFINED ident
	| '$' ident
	| token
	;

exprlst :
	expr
	| exprlst ',' expr
	;

comment :
	/*empty*/
	| comment token
	;

ident :
	IDENTIFIER
	;

token :
	IDENTIFIER
	| NUMBER
	| TOKEN
	;

%%

%%

[ \t\r\n\v\f]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"$"	'$'
"("	'('
")"	')'
","	','
"["	'['
"]"	']'
"&&"	AND
"#define"	DEFINE
"#defined"	DEFINED
"#elif"	ELIF
"#else"	ELSE
"#endif"	ENDIF
"=="	EQ
"#if"	IF
"#ifdef"	IFDEF
"#ifndef"	IFNDEF
"in"	IN
"!="	NEQ
"!"	NOT
"||"	OR
"#undef"	UNDEF

[^A-Za-z_]	TOKEN
[0-9]+	NUMBER
[A-Za-z_][A-Za-z0-9_]*	IDENTIFIER

%%
