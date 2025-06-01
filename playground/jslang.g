//From: https://github.com/eddid/jslang/blob/1af6280198785304f487bc406543c3f8d4643562/lib/Parse/ecmascript.y
/*
 *  Copyright (C) 1999-2000 Harri Porten (porten@kde.org)
 *  Copyright (C) 2006, 2007, 2008, 2009 Apple Inc. All rights reserved.
 *  Copyright (C) 2007 Eric Seidel <eric@webkit.org>
 *  Copyright (C) 2014 Eddid Zhang <zhangheng607@163.com>
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */

/*Tokens*/
%token AND
%token ANDEQUAL
//%token AUTOMINUSMINUS
//%token AUTOPLUSPLUS
%token BITAND
%token BITINV
%token BITOR
%token BITXOR
%token BREAK
%token CASE
%token CATCH
%token CLOSEBRACE
%token COLON
%token COMMA
%token CONSTTOKEN
%token CONTINUE
%token DEBUGGER
%token DEFAULT
%token DELETETOKEN
%token DIV
%token DIVEQUAL
%token DO
%token DOT
%token ELSE
%token EQEQ
%token EQUAL
%token FALSETOKEN
%token FINALLY
%token FOR
%token FUNCTION
%token GE
%token GT
%token IDENT
%token IF
%token IF_WITHOUT_ELSE
%token INSTANCEOF
%token INTOKEN
%token LBRACKET
%token LE
%token LPAREN
%token LSHIFT
%token LSHIFTEQUAL
%token LT
%token MINUS
%token MINUSEQUAL
%token MINUSMINUS
%token MOD
%token MODEQUAL
%token MUL
%token MULTEQUAL
%token NE
%token NEW
%token NOT
%token NULLTOKEN
%token NUMBER
%token OPENBRACE
%token OR
%token OREQUAL
%token PLUS
%token PLUSEQUAL
%token PLUSPLUS
%token QUESTIONMARK
%token RBRACKET
%token REGEXP
//%token RESERVED
%token RETURN
%token RPAREN
%token RSHIFT
%token RSHIFTEQUAL
%token SEMICOLON
%token STREQ
%token STRING
%token STRNEQ
%token SWITCH
%token THISTOKEN
%token THROW
%token TRUETOKEN
%token TRY
%token TYPEOF
%token URSHIFT
%token URSHIFTEQUAL
%token VAR
%token VOIDTOKEN
%token WHILE
%token WITH
%token XOREQUAL

%nonassoc /*1*/ IF_WITHOUT_ELSE
%nonassoc /*2*/ ELSE

%start Program

%%

Literal :
	NULLTOKEN
	| TRUETOKEN
	| FALSETOKEN
	| NUMBER
	| STRING
	| REGEXP
	;

Property :
	IDENT COLON AssignmentExpr
	| STRING COLON AssignmentExpr
	| NUMBER COLON AssignmentExpr
	| IDENT IDENT LPAREN RPAREN OPENBRACE FunctionBody CLOSEBRACE
	| IDENT IDENT LPAREN FormalParameterList RPAREN OPENBRACE FunctionBody CLOSEBRACE
	;

PropertyList :
	Property
	| PropertyList COMMA Property
	;

PrimaryExpr :
	PrimaryExprNoBrace
	| OPENBRACE CLOSEBRACE
	| OPENBRACE PropertyList CLOSEBRACE
	| OPENBRACE PropertyList COMMA CLOSEBRACE
	;

PrimaryExprNoBrace :
	THISTOKEN
	| Literal
	| ArrayLiteral
	| IDENT
	| LPAREN Expr RPAREN
	;

ArrayLiteral :
	LBRACKET ElisionOpt RBRACKET
	| LBRACKET ElementList RBRACKET
	| LBRACKET ElementList COMMA ElisionOpt RBRACKET
	;

ElementList :
	ElisionOpt AssignmentExpr
	| ElementList COMMA ElisionOpt AssignmentExpr
	;

ElisionOpt :
	/*empty*/
	| Elision
	;

Elision :
	COMMA
	| Elision COMMA
	;

MemberExpr :
	PrimaryExpr
	| FunctionExpr
	| MemberExpr LBRACKET Expr RBRACKET
	| MemberExpr DOT IDENT
	| NEW MemberExpr Arguments
	;

MemberExprNoBF :
	PrimaryExprNoBrace
	| MemberExprNoBF LBRACKET Expr RBRACKET
	| MemberExprNoBF DOT IDENT
	| NEW MemberExpr Arguments
	;

NewExpr :
	MemberExpr
	| NEW NewExpr
	;

NewExprNoBF :
	MemberExprNoBF
	| NEW NewExpr
	;

CallExpr :
	MemberExpr Arguments
	| CallExpr Arguments
	| CallExpr LBRACKET Expr RBRACKET
	| CallExpr DOT IDENT
	;

CallExprNoBF :
	MemberExprNoBF Arguments
	| CallExprNoBF Arguments
	| CallExprNoBF LBRACKET Expr RBRACKET
	| CallExprNoBF DOT IDENT
	;

Arguments :
	LPAREN RPAREN
	| LPAREN ArgumentList RPAREN
	;

ArgumentList :
	AssignmentExpr
	| ArgumentList COMMA AssignmentExpr
	;

LeftHandSideExpr :
	NewExpr
	| CallExpr
	;

LeftHandSideExprNoBF :
	NewExprNoBF
	| CallExprNoBF
	;

PostfixExpr :
	LeftHandSideExpr
	| LeftHandSideExpr PLUSPLUS
	| LeftHandSideExpr MINUSMINUS
	;

PostfixExprNoBF :
	LeftHandSideExprNoBF
	| LeftHandSideExprNoBF PLUSPLUS
	| LeftHandSideExprNoBF MINUSMINUS
	;

UnaryExprCommon :
	DELETETOKEN UnaryExpr
	| VOIDTOKEN UnaryExpr
	| TYPEOF UnaryExpr
	| PLUSPLUS UnaryExpr
	//| AUTOPLUSPLUS UnaryExpr
	| MINUSMINUS UnaryExpr
	//| AUTOMINUSMINUS UnaryExpr
	| PLUS UnaryExpr
	| MINUS UnaryExpr
	| BITINV UnaryExpr
	| NOT UnaryExpr
	;

UnaryExpr :
	PostfixExpr
	| UnaryExprCommon
	;

UnaryExprNoBF :
	PostfixExprNoBF
	| UnaryExprCommon
	;

MultiplicativeExpr :
	UnaryExpr
	| MultiplicativeExpr MUL UnaryExpr
	| MultiplicativeExpr DIV UnaryExpr
	| MultiplicativeExpr MOD UnaryExpr
	;

MultiplicativeExprNoBF :
	UnaryExprNoBF
	| MultiplicativeExprNoBF MUL UnaryExpr
	| MultiplicativeExprNoBF DIV UnaryExpr
	| MultiplicativeExprNoBF MOD UnaryExpr
	;

AdditiveExpr :
	MultiplicativeExpr
	| AdditiveExpr PLUS MultiplicativeExpr
	| AdditiveExpr MINUS MultiplicativeExpr
	;

AdditiveExprNoBF :
	MultiplicativeExprNoBF
	| AdditiveExprNoBF PLUS MultiplicativeExpr
	| AdditiveExprNoBF MINUS MultiplicativeExpr
	;

ShiftExpr :
	AdditiveExpr
	| ShiftExpr LSHIFT AdditiveExpr
	| ShiftExpr RSHIFT AdditiveExpr
	| ShiftExpr URSHIFT AdditiveExpr
	;

ShiftExprNoBF :
	AdditiveExprNoBF
	| ShiftExprNoBF LSHIFT AdditiveExpr
	| ShiftExprNoBF RSHIFT AdditiveExpr
	| ShiftExprNoBF URSHIFT AdditiveExpr
	;

RelationalExpr :
	ShiftExpr
	| RelationalExpr LT ShiftExpr
	| RelationalExpr GT ShiftExpr
	| RelationalExpr LE ShiftExpr
	| RelationalExpr GE ShiftExpr
	| RelationalExpr INSTANCEOF ShiftExpr
	| RelationalExpr INTOKEN ShiftExpr
	;

RelationalExprNoIn :
	ShiftExpr
	| RelationalExprNoIn LT ShiftExpr
	| RelationalExprNoIn GT ShiftExpr
	| RelationalExprNoIn LE ShiftExpr
	| RelationalExprNoIn GE ShiftExpr
	| RelationalExprNoIn INSTANCEOF ShiftExpr
	;

RelationalExprNoBF :
	ShiftExprNoBF
	| RelationalExprNoBF LT ShiftExpr
	| RelationalExprNoBF GT ShiftExpr
	| RelationalExprNoBF LE ShiftExpr
	| RelationalExprNoBF GE ShiftExpr
	| RelationalExprNoBF INSTANCEOF ShiftExpr
	| RelationalExprNoBF INTOKEN ShiftExpr
	;

EqualityExpr :
	RelationalExpr
	| EqualityExpr EQEQ RelationalExpr
	| EqualityExpr NE RelationalExpr
	| EqualityExpr STREQ RelationalExpr
	| EqualityExpr STRNEQ RelationalExpr
	;

EqualityExprNoIn :
	RelationalExprNoIn
	| EqualityExprNoIn EQEQ RelationalExprNoIn
	| EqualityExprNoIn NE RelationalExprNoIn
	| EqualityExprNoIn STREQ RelationalExprNoIn
	| EqualityExprNoIn STRNEQ RelationalExprNoIn
	;

EqualityExprNoBF :
	RelationalExprNoBF
	| EqualityExprNoBF EQEQ RelationalExpr
	| EqualityExprNoBF NE RelationalExpr
	| EqualityExprNoBF STREQ RelationalExpr
	| EqualityExprNoBF STRNEQ RelationalExpr
	;

BitwiseANDExpr :
	EqualityExpr
	| BitwiseANDExpr BITAND EqualityExpr
	;

BitwiseANDExprNoIn :
	EqualityExprNoIn
	| BitwiseANDExprNoIn BITAND EqualityExprNoIn
	;

BitwiseANDExprNoBF :
	EqualityExprNoBF
	| BitwiseANDExprNoBF BITAND EqualityExpr
	;

BitwiseXORExpr :
	BitwiseANDExpr
	| BitwiseXORExpr BITXOR BitwiseANDExpr
	;

BitwiseXORExprNoIn :
	BitwiseANDExprNoIn
	| BitwiseXORExprNoIn BITXOR BitwiseANDExprNoIn
	;

BitwiseXORExprNoBF :
	BitwiseANDExprNoBF
	| BitwiseXORExprNoBF BITXOR BitwiseANDExpr
	;

BitwiseORExpr :
	BitwiseXORExpr
	| BitwiseORExpr BITOR BitwiseXORExpr
	;

BitwiseORExprNoIn :
	BitwiseXORExprNoIn
	| BitwiseORExprNoIn BITOR BitwiseXORExprNoIn
	;

BitwiseORExprNoBF :
	BitwiseXORExprNoBF
	| BitwiseORExprNoBF BITOR BitwiseXORExpr
	;

LogicalANDExpr :
	BitwiseORExpr
	| LogicalANDExpr AND BitwiseORExpr
	;

LogicalANDExprNoIn :
	BitwiseORExprNoIn
	| LogicalANDExprNoIn AND BitwiseORExprNoIn
	;

LogicalANDExprNoBF :
	BitwiseORExprNoBF
	| LogicalANDExprNoBF AND BitwiseORExpr
	;

LogicalORExpr :
	LogicalANDExpr
	| LogicalORExpr OR LogicalANDExpr
	;

LogicalORExprNoIn :
	LogicalANDExprNoIn
	| LogicalORExprNoIn OR LogicalANDExprNoIn
	;

LogicalORExprNoBF :
	LogicalANDExprNoBF
	| LogicalORExprNoBF OR LogicalANDExpr
	;

ConditionalExpr :
	LogicalORExpr
	| LogicalORExpr QUESTIONMARK AssignmentExpr COLON AssignmentExpr
	;

ConditionalExprNoIn :
	LogicalORExprNoIn
	| LogicalORExprNoIn QUESTIONMARK AssignmentExprNoIn COLON AssignmentExprNoIn
	;

ConditionalExprNoBF :
	LogicalORExprNoBF
	| LogicalORExprNoBF QUESTIONMARK AssignmentExpr COLON AssignmentExpr
	;

AssignmentExpr :
	ConditionalExpr
	| LeftHandSideExpr AssignmentOperator AssignmentExpr
	;

AssignmentExprNoIn :
	ConditionalExprNoIn
	| LeftHandSideExpr AssignmentOperator AssignmentExprNoIn
	;

AssignmentExprNoBF :
	ConditionalExprNoBF
	| LeftHandSideExprNoBF AssignmentOperator AssignmentExpr
	;

AssignmentOperator :
	EQUAL
	| PLUSEQUAL
	| MINUSEQUAL
	| MULTEQUAL
	| DIVEQUAL
	| LSHIFTEQUAL
	| RSHIFTEQUAL
	| URSHIFTEQUAL
	| ANDEQUAL
	| XOREQUAL
	| OREQUAL
	| MODEQUAL
	;

Expr :
	AssignmentExpr
	| Expr COMMA AssignmentExpr
	;

ExprNoIn :
	AssignmentExprNoIn
	| ExprNoIn COMMA AssignmentExprNoIn
	;

ExprNoBF :
	AssignmentExprNoBF
	| ExprNoBF COMMA AssignmentExpr
	;

Statement :
	Block
	| VariableStatement
	| ConstStatement
	| FunctionDeclaration
	| EmptyStatement
	| ExprStatement
	| IfStatement
	| IterationStatement
	| ContinueStatement
	| BreakStatement
	| ReturnStatement
	| WithStatement
	| SwitchStatement
	| LabelledStatement
	| ThrowStatement
	| TryStatement
	| DebuggerStatement
	;

Block :
	OPENBRACE CLOSEBRACE
	| OPENBRACE SourceElements CLOSEBRACE
	;

VariableStatement :
	VAR VariableDeclarationList SEMICOLON
	//| VAR VariableDeclarationList error
	;

VariableDeclarationList :
	IDENT
	| IDENT Initializer
	| VariableDeclarationList COMMA IDENT
	| VariableDeclarationList COMMA IDENT Initializer
	;

VariableDeclarationListNoIn :
	IDENT
	| IDENT InitializerNoIn
	| VariableDeclarationListNoIn COMMA IDENT
	| VariableDeclarationListNoIn COMMA IDENT InitializerNoIn
	;

ConstStatement :
	CONSTTOKEN ConstDeclarationList SEMICOLON
	//| CONSTTOKEN ConstDeclarationList error
	;

ConstDeclarationList :
	ConstDeclaration
	| ConstDeclarationList COMMA ConstDeclaration
	;

ConstDeclaration :
	IDENT
	| IDENT Initializer
	;

Initializer :
	EQUAL AssignmentExpr
	;

InitializerNoIn :
	EQUAL AssignmentExprNoIn
	;

EmptyStatement :
	SEMICOLON
	;

ExprStatement :
	ExprNoBF SEMICOLON
	//| ExprNoBF error
	;

IfStatement :
	IF LPAREN Expr RPAREN Statement %prec IF_WITHOUT_ELSE /*1N*/
	| IF LPAREN Expr RPAREN Statement ELSE /*2N*/ Statement
	;

IterationStatement :
	DO Statement WHILE LPAREN Expr RPAREN SEMICOLON
	//| DO Statement WHILE LPAREN Expr RPAREN error
	| WHILE LPAREN Expr RPAREN Statement
	| FOR LPAREN ExprNoInOpt SEMICOLON ExprOpt SEMICOLON ExprOpt RPAREN Statement
	| FOR LPAREN VAR VariableDeclarationListNoIn SEMICOLON ExprOpt SEMICOLON ExprOpt RPAREN Statement
	| FOR LPAREN LeftHandSideExpr INTOKEN Expr RPAREN Statement
	| FOR LPAREN VAR IDENT INTOKEN Expr RPAREN Statement
	| FOR LPAREN VAR IDENT InitializerNoIn INTOKEN Expr RPAREN Statement
	;

ExprOpt :
	/*empty*/
	| Expr
	;

ExprNoInOpt :
	/*empty*/
	| ExprNoIn
	;

ContinueStatement :
	CONTINUE SEMICOLON
	//| CONTINUE error
	| CONTINUE IDENT SEMICOLON
	//| CONTINUE IDENT error
	;

BreakStatement :
	BREAK SEMICOLON
	//| BREAK error
	| BREAK IDENT SEMICOLON
	//| BREAK IDENT error
	;

ReturnStatement :
	RETURN SEMICOLON
	//| RETURN error
	| RETURN Expr SEMICOLON
	//| RETURN Expr error
	;

WithStatement :
	WITH LPAREN Expr RPAREN Statement
	;

SwitchStatement :
	SWITCH LPAREN Expr RPAREN CaseBlock
	;

CaseBlock :
	OPENBRACE CaseClausesOpt CLOSEBRACE
	| OPENBRACE CaseClausesOpt DefaultClause CaseClausesOpt CLOSEBRACE
	;

CaseClausesOpt :
	/*empty*/
	| CaseClauses
	;

CaseClauses :
	CaseClause
	| CaseClauses CaseClause
	;

CaseClause :
	CASE Expr COLON
	| CASE Expr COLON SourceElements
	;

DefaultClause :
	DEFAULT COLON
	| DEFAULT COLON SourceElements
	;

LabelledStatement :
	IDENT COLON Statement
	;

ThrowStatement :
	THROW Expr SEMICOLON
	//| THROW Expr error
	;

TryStatement :
	TRY Block FINALLY Block
	| TRY Block CATCH LPAREN IDENT RPAREN Block
	| TRY Block CATCH LPAREN IDENT RPAREN Block FINALLY Block
	;

DebuggerStatement :
	DEBUGGER SEMICOLON
	//| DEBUGGER error
	;

FunctionDeclaration :
	FUNCTION IDENT LPAREN RPAREN OPENBRACE FunctionBody CLOSEBRACE
	| FUNCTION IDENT LPAREN FormalParameterList RPAREN OPENBRACE FunctionBody CLOSEBRACE
	;

FunctionExpr :
	FUNCTION LPAREN RPAREN OPENBRACE FunctionBody CLOSEBRACE
	| FUNCTION LPAREN FormalParameterList RPAREN OPENBRACE FunctionBody CLOSEBRACE
	| FUNCTION IDENT LPAREN RPAREN OPENBRACE FunctionBody CLOSEBRACE
	| FUNCTION IDENT LPAREN FormalParameterList RPAREN OPENBRACE FunctionBody CLOSEBRACE
	;

FormalParameterList :
	IDENT
	| FormalParameterList COMMA IDENT
	;

FunctionBody :
	/*empty*/
	| SourceElements
	;

Program :
	/*empty*/
	| SourceElements
	;

SourceElements :
	Statement
	| SourceElements Statement
	;

%%

digit			[0-9]
letter			[a-zA-Z]
number			[0-9]+|[0-9]+\.[0-9]*
identifier		[a-zA-Z$_][a-zA-Z0-9$_]*
string			\"[^\n\"]+\"|\'[^\n\']+\'
line_comment	"//"[^\n]*
block_comment	"/*"([^\*]|(\*)*[^\*/])*(\*)*"*/"
regexp          "/"[^ \t\r\n\*/][^ \t\r\n/]+"/"[gimy]*

%%

[ \t\r\n]+		skip()
{line_comment}	skip()
{block_comment}	skip()
"null"			NULLTOKEN
"true"			TRUETOKEN
"false"			FALSETOKEN
"break"			BREAK
"case"			CASE
"default"		DEFAULT
"for"			FOR
"new"			NEW
"var"			VAR
"const"			CONSTTOKEN
"continue"		CONTINUE
"function"		FUNCTION
"return"		RETURN
"void"			VOIDTOKEN
"delete"		DELETETOKEN
"if"			IF
"else"			ELSE
"this"			THISTOKEN
"do"			DO
"while"			WHILE
"in"			INTOKEN
"instanceof"	INSTANCEOF
"typeof"		TYPEOF
"switch"		SWITCH
"with"			WITH
//"reserved"		RESERVED
"throw"			THROW
"try"			TRY
"catch"			CATCH
"finally"		FINALLY
"debugger"		DEBUGGER
"=="			EQEQ
"!="			NE
"==="			STREQ
"!=="			STRNEQ
"<="			LE
">="			GE
"||"			OR
"&&"			AND
"++"			PLUSPLUS
"--"			MINUSMINUS
"<<"			LSHIFT
">>"			RSHIFT
">>>"			URSHIFT
"+="			PLUSEQUAL
"-="			MINUSEQUAL
"*="			MULTEQUAL
"/="			DIVEQUAL
"<<="			LSHIFTEQUAL
">>="			RSHIFTEQUAL
">>>="			URSHIFTEQUAL
"&="			ANDEQUAL
"%="			MODEQUAL
"^="			XOREQUAL
"|="			OREQUAL
"{"				OPENBRACE
"}"				CLOSEBRACE
{number}		NUMBER
{identifier}	IDENT
{string}		STRING
{regexp}        REGEXP
"<"				LT
">"				GT
"="				EQUAL
"!"				NOT
"|"				BITOR
"&"				BITAND
"^"				BITXOR
"~"				BITINV
"("				LPAREN
")"				RPAREN
"["				LBRACKET
"]"				RBRACKET
"?"				QUESTIONMARK
"."				DOT
":"				COLON
";"				SEMICOLON
","				COMMA
"+"				PLUS
"-"				MINUS
"*"				MUL
"/"				DIV
"%"				MOD

%%
