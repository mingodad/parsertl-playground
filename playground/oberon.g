//From: https://github.com/rsdoiel/obnc/blob/main/src/Oberon.y
/*Copyright (C) 2017, 2018, 2019 Karl Landstrom <karl@miasap.se>

This file is part of OBNC.

OBNC is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

OBNC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with OBNC.  If not, see <http://www.gnu.org/licenses/>.*/

//%option caseless
%x	RANGE_BT

/*Tokens*/
//%token TOKEN_START
%token ARRAY
%token BEGIN_
%token BY
%token CASE
%token CONST
%token DIV
%token DO
%token ELSE
%token ELSIF
%token END
%token FALSE
%token FOR
%token IF
%token IMPORT
%token IN
%token IS
%token MOD
%token MODULE
%token NIL
%token OF
%token OR
%token POINTER
%token PROCEDURE
%token RECORD
%token REPEAT
%token RETURN
%token THEN
%token TO
%token TRUE
%token TYPE
%token UNTIL
%token VAR
%token WHILE
%token BECOMES
%token DOTDOT
%token GE
%token LE
%token IDENT
%token INTEGER
%token REAL
%token STRING
//%token TOKEN_END
%token '.'
%token '*'
%token '='
%token ','
%token '('
%token ')'
%token ';'
%token ':'
%token '#'
%token '<'
%token '>'
%token '+'
%token '-'
%token '/'
%token '&'
%token '~'
%token '['
%token ']'
%token '^'
%token '{'
%token '}'
%token '|'


%start module

%%

qualident :
	IDENT
	| IDENT '.' IDENT
	;

identdef :
	IDENT ExportMarkOpt
	;

ExportMarkOpt :
	'*'
	| /*empty*/
	;

number :
	INTEGER
	| REAL
	;

ConstDeclaration :
	identdef '=' ConstExpression
	;

ConstExpression :
	expression
	;

TypeDeclaration :
	TypeIdentDef type
	;

TypeIdentDef :
	identdef '='
	;

type :
	qualident
	| ArrayType
	| RecordType
	| PointerType
	| ProcedureType
	;

ArrayType :
	ArrayLengthOf type
	;

ArrayLengthOf :
	ARRAY LengthRep OF
	;

LengthRep :
	length
	| LengthRep ',' length
	;

length :
	ConstExpression
	;

RecordType :
	RecordHeading FieldListSequenceOpt END
	;

RecordHeading :
	RECORD BaseTypeOpt
	;

BaseTypeOpt :
	'(' BaseType ')'
	| /*empty*/
	;

BaseType :
	qualident
	;

FieldListSequenceOpt :
	FieldListSequence
	| /*empty*/
	;

FieldListSequence :
	FieldList
	| FieldListSequence ';' FieldList
	;

FieldList :
	IdentList ':' type
	;

IdentList :
	identdef
	| IdentList ',' identdef
	;

PointerType :
	PointerTo type
	;

PointerTo :
	POINTER TO
	;

ProcedureType :
	ProcedureTypeSansParam FormalParametersOpt
	;

ProcedureTypeSansParam :
	PROCEDURE
	;

FormalParametersOpt :
	FormalParameters
	| /*empty*/
	;

VariableDeclaration :
	IdentList ':' type
	;

expression :
	SimpleExpression
	| SimpleExpression relation SimpleExpression
	;

relation :
	'='
	| '#'
	| '<'
	| LE
	| '>'
	| GE
	| IN
	| IS
	;

SimpleExpression :
	SignOpt term
	| SimpleExpression AddOperator term
	;

SignOpt :
	'+'
	| '-'
	| /*empty*/
	;

AddOperator :
	'+'
	| '-'
	| OR
	;

term :
	factor
	| term MulOperator factor
	;

MulOperator :
	'*'
	| '/'
	| DIV
	| MOD
	| '&'
	;

factor :
	number
	| STRING
	| NIL
	| TRUE
	| FALSE
	| set
	| designator
	| '(' expression ')'
	| '~' factor
	;

designator :
	IDENT SelectorOptRep
	;

SelectorOptRep :
	SelectorOptRep selector
	| /*empty*/
	;

selector :
	'.' IDENT
	| '[' ExpList ']'
	| '^'
	| '(' ExpList ')'
	| '(' ')'
	;

set :
	'{' '}'
	| '{' ElementRep '}'
	;

ElementRep :
	element
	| ElementRep ',' element
	;

element :
	expression
	| expression DOTDOT expression
	;

ExpList :
	expression
	| ExpList ',' expression
	;

statement :
	assignment
	| ProcedureCall
	| IfStatement
	| CaseStatement
	| WhileStatement
	| RepeatStatement
	| ForStatement
	| /*empty*/
	;

assignment :
	designator BECOMES expression
	;

ProcedureCall :
	designator
	;

StatementSequence :
	StatementSequenceReversed
	;

StatementSequenceReversed :
	statement
	| StatementSequenceReversed ';' statement
	;

IfStatement :
	IF guard THEN StatementSequence ElseIfThenOptRep ElseOpt END
	;

guard :
	expression
	;

ElseIfThenOptRep :
	ElseIfThenOptRep ELSIF guard THEN StatementSequence
	| /*empty*/
	;

ElseOpt :
	ELSE StatementSequence
	| /*empty*/
	;

CaseStatement :
	CASE CaseExpression OF CaseRep END
	;

CaseExpression :
	expression
	;

CaseRep :
	case
	| CaseRep '|' case
	;

case :
	CaseLabelList ':' StatementSequence
	| /*empty*/
	;

CaseLabelList :
	LabelRange
	| CaseLabelList ',' LabelRange
	;

LabelRange :
	label
	| label DOTDOT label
	;

label :
	INTEGER
	| STRING
	| qualident
	;

WhileStatement :
	WHILE guard DO StatementSequence ElseIfDoOptRep END
	;

ElseIfDoOptRep :
	ElseIfDoOptRep ELSIF guard DO StatementSequence
	| /*empty*/
	;

RepeatStatement :
	REPEAT StatementSequence UNTIL expression
	;

ForStatement :
	FOR ForInit TO ForLimit ByOpt DO StatementSequence END
	;

ForInit :
	IDENT BECOMES expression
	;

ForLimit :
	expression
	;

ByOpt :
	BY ConstExpression
	| /*empty*/
	;

ProcedureDeclaration :
	ProcedureHeading ';' DeclarationSequence StatementSequenceOpt ReturnExpressionOpt END IDENT
	;

ProcedureHeading :
	ProcedureHeadingSansParam FormalParametersOpt
	;

ProcedureHeadingSansParam :
	PROCEDURE identdef
	;

StatementSequenceOpt :
	BEGIN_ StatementSequence
	| /*empty*/
	;

ReturnExpressionOpt :
	RETURN expression
	| /*empty*/
	;

DeclarationSequence :
	ConstSectionOpt TypeSectionOpt VariableSectionOpt ProcedureDeclarationOptRep
	;

ConstSectionOpt :
	CONST ConstDeclarationOptRep
	| /*empty*/
	;

ConstDeclarationOptRep :
	ConstDeclarationOptRep ConstDeclaration ';'
	| /*empty*/
	;

TypeSectionOpt :
	TypeKeyword TypeDeclarationOptRep
	| /*empty*/
	;

TypeKeyword :
	TYPE
	;

TypeDeclarationOptRep :
	TypeDeclarationOptRep TypeDeclaration ';'
	| /*empty*/
	;

VariableSectionOpt :
	VAR VariableDeclarationOptRep
	| /*empty*/
	;

VariableDeclarationOptRep :
	VariableDeclarationOptRep VariableDeclaration ';'
	| /*empty*/
	;

ProcedureDeclarationOptRep :
	ProcedureDeclarationOptRep ProcedureDeclaration ';'
	| /*empty*/
	;

FormalParameters :
	'(' FPSectionsOpt ')' ResultTypeOpt
	;

FPSectionsOpt :
	FPSectionRep
	| /*empty*/
	;

FPSectionRep :
	FPSection
	| FPSectionRep ';' FPSection
	;

ResultTypeOpt :
	':' qualident
	| /*empty*/
	;

FPSection :
	ParameterKindOpt IdentRep ':' FormalType
	;

ParameterKindOpt :
	VAR
	| /*empty*/
	;

IdentRep :
	IDENT
	| IdentRep ',' IDENT
	;

FormalType :
	OpenArrayOptRep qualident
	;

OpenArrayOptRep :
	OpenArrayOptRep ARRAY OF
	| /*empty*/
	;

module :
	ModuleHeading ';' ImportListOpt DeclarationSequence ModuleStatements END IDENT '.'
	;

ModuleHeading :
	MODULE IDENT
	;

ImportListOpt :
	ImportList
	| /*empty*/
	;

ImportList :
	IMPORT ImportRep ';'
	;

ImportRep :
	import
	| ImportRep ',' import
	;

import :
	IDENT BecomesIdentOpt
	;

BecomesIdentOpt :
	BECOMES IDENT
	| /*empty*/
	;

ModuleStatements :
	StatementSequenceOpt
	;

%%

WORD [A-Za-z](_?[A-Za-z0-9])*

INTEGER [0-9]+|[0-9][0-9A-F]*H

REAL [0-9]+"."[0-9]*(E[+-]?[0-9]+)?

QUOTED_STRING \"[^"\n]*\"

ORDINAL_STRING [0-9][0-9A-F]*X

%%

[ \t\r]+	skip()

\n	skip()

"(*"(?s:.)*?"*)"	skip()

":="  BECOMES

".."  DOTDOT

"<="  LE

">="  GE

"["	'['
"]"	']'
"*"	'*'
"+"	'+'
"/"	'/'
"&"	'&'
"~"	'~'
"."	'.'
","	','
";"	';'
"|"	'|'
"("	'('
"{"	'{'
"^"	'^'
":"	':'
")"	')'
"}"	'}'
"="	'='
"#"	'#'
"<"	'<'
">"	'>'
"-"	'-'

ARRAY	ARRAY
BEGIN	BEGIN_
BY	BY
CASE	CASE
CONST	CONST
DIV	DIV
DO	DO
ELSE	ELSE
ELSIF	ELSIF
END	END
FALSE	FALSE
FOR	FOR
IF	IF
IMPORT	IMPORT
IN	IN
IS	IS
MOD	MOD
MODULE	MODULE
NIL	NIL
OF	OF
OR	OR
POINTER	POINTER
PROCEDURE	PROCEDURE
RECORD	RECORD
REPEAT	REPEAT
RETURN	RETURN
THEN	THEN
TO	TO
TRUE	TRUE
TYPE	TYPE
UNTIL	UNTIL
VAR	VAR
WHILE	WHILE

{WORD} IDENT

{INTEGER}	INTEGER
{INTEGER}".."<RANGE_BT>
<RANGE_BT> {
	{INTEGER}<INITIAL>	INTEGER
	.<INITIAL>	reject()
}

{REAL}  REAL

{QUOTED_STRING}	STRING

{ORDINAL_STRING}	STRING


%%
