//From: 8cb27b20851d3df8eb48dbac32b1b0b938ecb6ca https://gitlab.com/cznic/parser/-/blob/master/yacc/parser.y
// Copyright 2015 The parser Authors. All rights reserved.  Use
// of this source code is governed by a BSD-style license that can be found in
// the LICENSE file.
//
// This is a derived work base on the original at
//
// http://pubs.opengroup.org/onlinepubs/009695399/utilities/yacc.html
//
// The original work is
//
// Copyright © 2001-2004 The IEEE and The Open Group, All Rights reserved.
//
// Grammar for the input to yacc.

//%token COMMENT
%token C_IDENTIFIER
%token ERROR_VERBOSE
%token IDENTIFIER
%token LCURL_RCURL
%token LEFT
%token MARK
%token NONASSOC
%token NUMBER
%token PREC
%token PRECEDENCE
%token RIGHT
%token START
%token STRING_LITERAL
%token TOKEN
%token TYPE
%token UNION
%token ACION

%start Specification

%%

Definition:
	START IDENTIFIER
	| UNION
	| LCURL_RCURL
	| ReservedWord Tag NameList
	| ReservedWord Tag
	| ERROR_VERBOSE
	;

DefinitionList:
	/* empty */
	| DefinitionList Definition
	;

LiteralStringOpt:
	/* empty */
	| STRING_LITERAL
	;

Name:
	IDENTIFIER LiteralStringOpt
	| IDENTIFIER NUMBER LiteralStringOpt
	;

NameList:
	Name
	| NameList Name
	| NameList ',' Name
	;

Precedence:
	/* empty */
	| PREC IDENTIFIER
	| PREC IDENTIFIER ACION
	| Precedence ';'
	;

ReservedWord:
	TOKEN
	| LEFT
	| RIGHT
	| NONASSOC
	| TYPE
	| PRECEDENCE
	;

Rule:
	C_IDENTIFIER RuleItemList Precedence
	| '|' RuleItemList Precedence
	;

RuleItemList:
	/* empty */
	| RuleItemList IDENTIFIER
	| RuleItemList ACION
	| RuleItemList STRING_LITERAL
	;

RuleList:
	C_IDENTIFIER RuleItemList Precedence
	| RuleList Rule
	;

Specification:
	DefinitionList MARK RuleList Tail
	;

Tag:
	/* empty */
	| '<' IDENTIFIER '>'
	;

Tail:
	MARK
	|	/* empty */
	;

%%

%x LHS LRCURLY LRUNION LRACION

eof			\x80

literal			'(\\[^\n\r\x80]|[^\\'\n\r\x80])*'
name-first		[_a-zA-Z]
name-next		{name-first}|[0-9.]
name			{name-first}{name-next}*
str-literal		\x22(\\[^\n\r\x80]|[^\\\x22\x80\n\r])*\x22
identifier		{name}|{literal}

%%

[ \n\r\t\f]+    skip()

"//"[^\x80\n\r]*	skip()
"/*"([^*\x80]|\*+[^*/\x80])*\*+\/ skip()

","	','
";"	';'
"<"	'<'
">"	'>'
"{"	'{'
"|"	'|'
"}"	'}'

"%error-verbose"	ERROR_VERBOSE
"%left"	LEFT
"%%"	MARK
"%nonassoc"	NONASSOC
"%prec"	PREC
"%precedence"	PRECEDENCE
"%right"	RIGHT
"%start"	START
"%token"	TOKEN
"%type"	TYPE

"{"<>LRACION>
<LRACION>{
    "}"<<>  ACION
    "{"<>LRACION>
    {str-literal}<.>
    .|\n<.>
}

"%union"\s*"{"<>LRUNION>
<LRUNION>{
    "}"<<>    UNION
    "{"<>LRUNION>
    .|\n<.>
}

"%{"<LRCURLY>
<LRCURLY>{
    "%}"<INITIAL>   LCURL_RCURL
    .|\n<.>
}

{str-literal}	STRING_LITERAL
[0-9]+	NUMBER
{identifier}	IDENTIFIER

{identifier}\s*":"<LHS>	reject()
<LHS>{
	{identifier}	C_IDENTIFIER
	\s+	skip()
	":"<INITIAL>	skip()
}

%%
