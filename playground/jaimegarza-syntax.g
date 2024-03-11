//From: https://github.com/jaimegarza/syntax/blob/da2c8e8ade84514b1c1d2ef0e826d2c8bfd4ded3/src/main/grammar/syntax.sy
/*
 Syntax is distributed under the Revised, or 3-clause BSD license
 ===============================================================================
 Copyright (c) 1985, 2012, 2016, Jaime Garza
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
     * Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
     * Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.
     * Neither the name of Jaime Garza nor the
       names of its contributors may be used to endorse or promote products
       derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 ===============================================================================
*/

%token MARK //: "'%%'"
%token START //: "'%start'"
%token TOKEN //: "token"
%token TYPE //: "'%type'"
%token UNION //: "'%union'"
%token TYPENAME //: "type definition"
%token TERM //: "'%token'"
%token LEFT //: "'%left'"
%token RIGHT //: "'%right'"
%token BINARY //: "'%binary'"
%token ERRDEF //: "'%error'"
%token NUM //: "number"
%token PREC //: "'%prec'"
%token NAME //: "'%name'"
//%token ERROR //: "error"
%token LEXER //: "%lexer"
%token DECLARE //: "%declare"
%token GROUP //: "%group"
%token PROGRAM_DECLARATIONS
%token RULE_ACTION
%token ADITIONAL_CODE

%token '*'
%token '+'
%token '?'
%token '.'
%token CHAR //: "character"
%token CHARACTER_CLASS //: "a valid character class"

%token LEXCODE //: "lexical code"

%token ';' //: "semicolon"
%token ':' //: "colon"
%token '=' //: "equals sign",
%token '[' //: "token mode marker",
%token ']' //: "closing token mode marker"
%token ',' //: "comma"
%token '|' //: "rule separator ('|')"
%token '(' //: "opening parenthesis"
%token ')' //: "closing parenthesis"
%token '/' //: "regular expression marker ('/')"

%right ':'
%right '=' '[' ']'

%start Descriptor

%%

Descriptor :
	Declarations SectionMarker Productions Actions
	| SectionMarker Productions Actions
	;

SectionMarker :
	MARK
	;

Actions :
	%empty
	| MARK ADITIONAL_CODE
	;

Declarations :
	Declarations Declaration
	| Declaration
	;

Declaration :
	';'
	| START TOKEN
	| LEXCODE TOKEN
	| TYPE TYPENAME NonTerminals
	| DECLARE TYPENAME
	| NAME TokenNames
	| UNION
	| Precedence Definition
	| LEXER Equals TOKEN
	| GROUP TOKEN ':' TOKEN GroupTokens
	| PROGRAM_DECLARATIONS
	;

Precedence :
	TERM
	| LEFT
	| RIGHT
	| BINARY
	| ERRDEF
	;

NonTerminals :
	NonTerminals ',' TOKEN
	| TOKEN
	;

TokenNames :
	TokenNames ',' Name
	| Name
	;

Name :
	TOKEN ':' TOKEN
	;

GroupTokens :
	GroupTokens ',' GroupToken
	| GroupToken
	;

GroupToken :
	TOKEN
	;

Definition :
	Type Tokens
	;

Type :
	TYPENAME
	| %empty
	;

Tokens :
	Tokens ',' Token
	| Token
	;

Token :
	TokenDef LexicAction
	;

TokenDef :
	TOKEN Number TokenName
	;

Number :
	NUM
	| %empty
	;

TokenName :
	':' TOKEN
	| %prec ':'
	;

LexicAction :
	Equals TOKEN
	| RStart RExp REnd %prec '='
	| RStart RExp REnd REquals TOKEN
	| %prec '='
	;

REquals :
	'='
	| '[' TOKEN ']' '='
	;

Equals :
	'='
	| '[' TOKEN ']' '='
	;

RStart :
	'/' TOKEN
	;

REnd :
	'/' TOKEN
	;

RExp :
	RegExp
	;

RegExp :
	RegExp '|' Concatenation
	| Concatenation
	;

Concatenation :
	Concatenation UnaryRegex
	| UnaryRegex
	;

UnaryRegex :
	BasicElement '*'
	| BasicElement '+'
	| BasicElement '?'
	| BasicElement
	;

BasicElement :
	'(' RegExp ')'
	| CHAR
	| '[' CHARACTER_CLASS ']'
	| '.'
	;

Productions :
	Productions TOKEN ':' Rules ';'
	| TOKEN ':' Rules ';'
	;

Rules :
	Rules '|' GrammarRule
	| GrammarRule
	;

GrammarRule :
	Rule
	| %empty
	;

Rule :
	Rule Symbol
	| Symbol
	;

Symbol :
	TOKEN
	| PREC TOKEN
	| RULE_ACTION
	;

%%

%x PROD ACT RULE_ACT_COMP COMPOUND

ident [A-Za-z_][0-9A-Za-z_]*

%%

<INITIAL,PROD> {
    [ \t\r\n]+	skip()
}

"%%"<PROD>	MARK
"%binary"	BINARY
"%nonassoc"	BINARY
"%declare"	DECLARE
"%error"	ERRDEF
"%group"	GROUP
"%left"	LEFT
"%lexer"	LEXER
"%name"	NAME
"%right"	RIGHT
"%start"	START
"%token"	TERM
"%term"	TERM
"%type"	TYPE
"%symbol"	TYPE
("%union"|"%stack"|"%class"|"%struct")\s*"{"<>COMPOUND>

<PROD> {
    "%%"<ACT>	MARK
    "%prec"	PREC
    "="[^;\n]+";" RULE_ACTION
    "="\s*"{"<>RULE_ACT_COMP>
    "|"	'|'
    ":"	':'
    ";"	';'
}

<RULE_ACT_COMP> {
    "}"<<> RULE_ACTION
    "{"<>RULE_ACT_COMP>
    [^{}]|\n<.>
}

<ACT> {
    (.|\n)+ ADITIONAL_CODE
}

"="	'='
","	','
";"	';'
":"	':'
"/"	'/'
"("	'('
")"	')'
"["	'['
"]"	']'
"*"	'*'
"+"	'+'
"?"	'?'
"."	'.'

<COMPOUND> {
    "{"<>COMPOUND>
    "}"<<>  UNION
    [^{}]|\n<.>

}

"lexical code"	LEXCODE
"character"	CHAR

"%{"(?s:.)*?"%}"    PROGRAM_DECLARATIONS

"["(\\.|[^]\r\n\\])+"]"	CHARACTER_CLASS

[0-9]+	NUM


"<"{ident}">"	TYPENAME

<INITIAL,PROD> {
    '(\\.|[^'\r\n\\])'	TOKEN
    \"(\\.|[^"\r\n\\])+\"	TOKEN
    {ident}	TOKEN
}

%%
