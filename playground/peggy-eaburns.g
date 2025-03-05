//From: https://github.com/eaburns/peggy/blob/cfe5bfef6120f12085a7608e352ad71d3b8ea84c/grammar.y

// Copyright 2017 The Peggy Authors
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd.

/*Tokens*/
%token _ARROW
%token _CHARCLASS
%token _CODE
//%token _ERROR
%token _IDENT
%token _STRING


%start Top

%%

Top :
	Nl Grammar
	;

Grammar :
	Prelude NewLine Rules Nl
	| Rules Nl
	;

Prelude :
	_CODE
	;

Rules :
	Rules NewLine Rule
	| Rule
	| /*empty*/
	;

Rule :
	Name _ARROW Nl Expr
	| Name _STRING _ARROW Nl Expr
	;

Name :
	_IDENT '<' Args '>'
	| _IDENT
	;

Args :
	_IDENT
	| Args ',' _IDENT
	;

Expr :
	Expr '/' Nl ActExpr
	| ActExpr
	;

ActExpr :
	SeqExpr GoAction
	| SeqExpr
	;

SeqExpr :
	SeqExpr LabelExpr
	| LabelExpr
	;

LabelExpr :
	_IDENT ':' Nl PredExpr
	| PredExpr
	;

PredExpr :
	'&' Nl PredExpr
	| '!' Nl PredExpr
	| RepExpr
	;

RepExpr :
	RepExpr '*'
	| RepExpr '+'
	| RepExpr '?'
	| Operand
	;

Operand :
	'(' Nl Expr Nl ')'
	| '&' Nl GoPred
	| '!' Nl GoPred
	| '.'
	| Name
	| _STRING
	| _CHARCLASS
	//| '(' Nl Expr error
	;

GoPred :
	_CODE
	;

GoAction :
	_CODE
	;

NewLine :
	'\n' NewLine
	| '\n'
	;

Nl :
	NewLine
	| /*empty*/
	;

%%

%x BLKCODE

DQSTR \"(\\.|[^"\r\n\\])*\"
SQSTR \'(\\.|[^'\r\n\\])+\'

%%

[ \t\r]+	skip()
"#".*   skip()

"!"	'!'
"&"	'&'
"("	'('
")"	')'
"*"	'*'
"+"	'+'
","	','
"."	'.'
"/"	'/'
":"	':'
"<"	'<'
">"	'>'
"?"	'?'
"\n"	'\n'

"<-"	_ARROW
//_ERROR	_ERROR

"{"<>BLKCODE>
<BLKCODE>{
    "{"<>BLKCODE>
    "}"<<>  _CODE
    {DQSTR}<.>
    {SQSTR}<.>
    .|\n<.>
}

"["(\\.|[^\]\r\n\\])+"]"	_CHARCLASS
{DQSTR}	_STRING
[A-Za-z_][A-Za-z0-9_]*	_IDENT

%%
