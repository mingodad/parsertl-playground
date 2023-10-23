/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * This file is part of Beaver Parser Generator.                       *
 * Copyright (C) 2003,2005 Alexander Demenchuk <alder@softanvil.com>.  *
 * All rights reserved.                                                *
 * See the file "LICENSE" for the terms and conditions for copying,    *
 * distribution and modification of Beaver.                            *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

%token HEADER PACKAGE IMPORT CLASS EMBED INIT IMPLEMENTS
%token GOAL TERMINALS TYPEOF IS COMMA LEFT RIGHT NONASSOC
%token SEMI QUESTION PLUS STAR AT BAR DOT
%token TEXT CODE IDENT

%start grammar

%%

grammar :
	declaration* rule+
	;

declaration :
	header
	| package
	| import
	| class_name
	| class_code
	| class_init
	| class_implements
	| grammar_goal
	| typeof
	| terminals
	| left_assoc
	| right_assoc
	| nonassoc
	//| error.e SEMI
 	;

header :
	HEADER CODE SEMI
	;

package :
	PACKAGE TEXT SEMI
	;

import :
	IMPORT txt_list SEMI
	;

class_name :
	CLASS TEXT SEMI
	;

class_code :
	EMBED CODE SEMI
	;

class_init :
	INIT CODE  SEMI
	;

class_implements :
	IMPLEMENTS txt_list SEMI
	;

grammar_goal :
	GOAL IDENT SEMI
	;

terminals :
	TERMINALS sym_list SEMI
	;

left_assoc :
	LEFT sym_list SEMI
	;

right_assoc :
	RIGHT sym_list SEMI
	;

nonassoc :
	NONASSOC sym_list SEMI
	;

typeof :
	TYPEOF sym_list IS TEXT SEMI
	;

txt_list :
	TEXT
	| txt_list COMMA TEXT
	;

sym_list :
	IDENT
	| sym_list COMMA IDENT
	;

rule :
	IDENT IS def_list SEMI
	//| error.e SEMI
	;

def_list :
	definition
	| def_list BAR definition
	;

definition :
	def_element* rule_precedence? CODE?
	//| error.e
	;

def_element :
	IDENT alias? ebnf_symbol?
	;

alias :
	DOT IDENT
	;

ebnf_symbol :
	QUESTION
	| PLUS
	| STAR
	;

rule_precedence :
	AT IDENT
	;

%%

%x TEXT

LineTerminator  \r|\n|\r\n
WhiteSpace      {LineTerminator}|[ \t\f]
Identifier      [A-Za-z][A-Za-z0-9_]*

TxtChar         [^\r\n\"]
AnyChar         .|\n

%%

{WhiteSpace}+        skip()

<INITIAL> {
	"%header"       HEADER
	"%package"      PACKAGE
	"%import"       IMPORT
	"%class"        CLASS
	"%implements"   IMPLEMENTS
	"%embed"        EMBED
	"%init"         INIT
	"%goal"         GOAL

	"%terminals"    TERMINALS
	"%typeof"       TYPEOF
	"%left"         LEFT
	"%right"        RIGHT
	"%nonassoc"     NONASSOC

	","             COMMA
	"="             IS
	";"             SEMI

	"@"             AT
	"."             DOT
	"|"             BAR

	"?"             QUESTION
	"+"             PLUS
	"*"             STAR

	"{:"(?s:.)+?":}"	CODE
	"/*"(?s:.)*?"*/"	skip()
	"//".*		skip()
	\"<TEXT>

	{Identifier}    IDENT
}


<TEXT> {
	{TxtChar}+<.>
	\"<INITIAL>              TEXT
	//{AnyChar}?      { yybegin(YYINITIAL); matched_text = null; throw new Scanner.Exception(token_line + 1, token_column + 1, "unterminated string"
}

//{AnyChar}           { throw new Scanner.Exception(yyline + 1, yycolumn + 1, "unrecognized character '" + yytext() + "'"

%%
