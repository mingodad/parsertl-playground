/*
 * dpas-parser.y - Bison grammar for the Dynamic Pascal language.
 *
 * Copyright (C) 2004  Southern Storm Software, Pty Ltd.
 *
 * This file is part of the libjit library.
 *
 * The libjit library is free software: you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation, either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * The libjit library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with the libjit library.  If not, see
 * <http://www.gnu.org/licenses/>.
 */

%token ILLEGAL_CHARACTER

/*Tokens*/
%token IDENTIFIER
%token INTEGER_CONSTANT
%token STRING_CONSTANT
%token REAL_CONSTANT
%token K_AND
%token K_ARRAY
%token K_BEGIN
%token K_CASE
%token K_CATCH
%token K_CONST
%token K_DIV
%token K_DO
%token K_DOWNTO
%token K_ELSE
%token K_END
%token K_EXIT
%token K_FASTCALL
%token K_FINALLY
%token K_FOR
%token K_FORWARD
%token K_FUNCTION
%token K_GOTO
%token K_IF
%token K_IN
%token K_LABEL
%token K_IMPORT
%token K_MOD
%token K_MODULE
%token K_NIL
%token K_NOT
%token K_OF
%token K_OR
%token K_PACKED
%token K_POW
%token K_PROCEDURE
%token K_PROGRAM
%token K_RECORD
%token K_REPEAT
%token K_SET
%token K_SHL
%token K_SHR
%token K_SIZEOF
%token K_STDCALL
%token K_THEN
%token K_THROW
%token K_TO
%token K_TRY
%token K_TYPE
%token K_UNTIL
%token K_VAR
%token K_VA_ARG
%token K_WITH
%token K_WHILE
%token K_XOR
%token K_NE
%token K_LE
%token K_GE
%token K_ASSIGN
%token K_DOT_DOT
%token '.'
%token '('
%token ')'
%token ';'
%token ','
%token '='
%token ':'
%token '['
%token ']'
%token '<'
%token '>'
%token '+'
%token '-'
%token '*'
%token '/'
%token '&'
%token '@'
%token '^'

%nonassoc /*1*/ IF_WITHOUT_ELSE
%nonassoc /*2*/ K_ELSE

%start Program

%%

Program :
	ProgramHeading ImportDeclarationPart ProgramBlock '.'
	;

ProgramHeading :
	K_PROGRAM Identifier '(' IdentifierList ')' ';'
	| K_PROGRAM Identifier ';'
	| K_MODULE Identifier '(' IdentifierList ')' ';'
	| K_MODULE Identifier ';'
	;

ImportDeclarationPart :
	/*empty*/
	| K_IMPORT ImportDeclarations ';'
	;

ImportDeclarations :
	Identifier
	| ImportDeclarations ',' Identifier
	;

ProgramBlock :
	Block
	;

Identifier :
	IDENTIFIER
	;

IdentifierList :
	Identifier
	| IdentifierList ',' Identifier
	;

Block :
	DeclarationPart StatementPart
	;

DeclarationPart :
	LabelDeclarationPart ConstantDefinitionPart TypeDefinitionPart VariableDeclarationPart ProcedureAndFunctionDeclarationPart
	;

LabelDeclarationPart :
	/*empty*/
	| K_LABEL LabelList ';'
	;

LabelList :
	Label
	| LabelList ',' Label
	;

Label :
	INTEGER_CONSTANT
	;

ConstantDefinitionPart :
	/*empty*/
	| K_CONST ConstantDefinitionList
	;

ConstantDefinitionList :
	ConstantDefinition
	| ConstantDefinitionList ConstantDefinition
	;

ConstantDefinition :
	Identifier '=' Constant ';'
	;

TypeDefinitionPart :
	/*empty*/
	| K_TYPE TypeDefinitionList
	;

TypeDefinitionList :
	TypeDefinition
	| TypeDefinitionList TypeDefinition
	;

TypeDefinition :
	Identifier '=' Type ';'
	;

VariableDeclarationPart :
	/*empty*/
	| K_VAR VariableDeclarationList
	;

VariableDeclarationList :
	VariableDeclaration
	| VariableDeclarationList VariableDeclaration
	;

VariableDeclaration :
	IdentifierList ':' Type ';'
	;

ProcedureAndFunctionDeclarationPart :
	/*empty*/
	| ProcedureOrFunctionList
	;

ProcedureOrFunctionList :
	ProcedureOrFunctionDeclaration ';'
	| ProcedureOrFunctionList ProcedureOrFunctionDeclaration ';'
	;

StatementPart :
	K_BEGIN StatementSequence OptSemi K_END
	| K_BEGIN OptSemi K_END
	| K_END
	//| K_BEGIN error K_END
	;

OptSemi :
	/*empty*/
	| ';'
	;

ProcedureOrFunctionDeclaration :
	ProcedureOrFunctionHeading ';' Body
	;

ProcedureOrFunctionHeading :
	ProcedureHeading
	| FunctionHeading
	;

Body :
	Block
	| Directive
	;

Directive :
	K_FORWARD
	| K_IMPORT '(' STRING_CONSTANT ')'
	;

ProcedureHeading :
	K_PROCEDURE Identifier FormalParameterList
	;

FunctionHeading :
	K_FUNCTION Identifier FormalParameterList ':' TypeIdentifier
	;

FormalParameterList :
	/*empty*/
	| '(' FormalParameterSections ')' OptAbi
	| '(' FormalParameterSections ';' K_DOT_DOT ')'
	;

OptAbi :
	/*empty*/
	| K_FASTCALL
	| K_STDCALL
	;

FormalParameterSections :
	FormalParameterSection
	| FormalParameterSections ';' FormalParameterSection
	;

FormalParameterSection :
	IdentifierList ':' ParameterType
	| K_VAR IdentifierList ':' ParameterType
	| ProcedureHeading
	| FunctionHeading
	;

ParameterType :
	TypeIdentifier
	| ConformantArray
	;

ConformantArray :
	K_PACKED K_ARRAY '[' BoundSpecification ']' K_OF TypeIdentifier
	| K_ARRAY '[' BoundSpecificationList ']' K_OF ParameterType
	;

BoundSpecificationList :
	BoundSpecification
	| BoundSpecificationList ';' BoundSpecification
	;

BoundSpecification :
	Identifier K_DOT_DOT Identifier ':' TypeIdentifier
	;

StatementSequence :
	Statement
	| StatementSequence ';' Statement
	;

Statement :
	Label ':' InnerStatement
	| InnerStatement
	;

InnerStatement :
	AssignmentStatement
	| Variable ActualParameters
	| K_GOTO Label
	| CompoundStatement
	| IfStatement
	| WhileStatement
	| RepeatStatement
	| ForStatement
	| CaseStatement
	| K_WITH VariableList K_DO Statement
	| K_THROW Expression
	| K_THROW
	| TryStatement
	| K_EXIT
	;

ActualParameters :
	/*empty*/
	| '(' ExpressionList ')'
	;

CompoundStatement :
	K_BEGIN StatementSequence OptSemi K_END
	//| K_BEGIN error K_END
	;

AssignmentStatement :
	Variable K_ASSIGN Expression
	;

IfStatement :
	K_IF BooleanExpression K_THEN IfTail
	;

IfTail :
	Statement %prec IF_WITHOUT_ELSE
	| Statement K_ELSE Statement
	;

WhileStatement :
	K_WHILE BooleanExpression K_DO Statement
	;

RepeatStatement :
	K_REPEAT StatementSequence OptSemi K_UNTIL BooleanExpression
	;

ForStatement :
	K_FOR AssignmentStatement Direction Expression K_DO Statement
	;

BooleanExpression :
	Expression
	;

Direction :
	K_TO
	| K_DOWNTO
	;

CaseStatement :
	K_CASE Expression K_OF CaseLimbList
	;

CaseLimbList :
	CaseLimb
	| CaseLimbList ';' CaseLimb
	;

CaseLimb :
	CaseLabelList ':' Statement
	;

CaseLabelList :
	Constant
	| CaseLabelList ',' Constant
	;

VariableList :
	Variable
	| VariableList ',' Variable
	;

TryStatement :
	K_TRY StatementSequence OptSemi CatchClause FinallyClause K_END
	;

CatchClause :
	/*empty*/
	| K_CATCH Identifier ':' Type StatementSequence OptSemi
	;

FinallyClause :
	/*empty*/
	| K_FINALLY StatementSequence OptSemi
	;

Expression :
	SimpleExpression
	| SimpleExpression '=' SimpleExpression
	| SimpleExpression K_NE SimpleExpression
	| SimpleExpression '<' SimpleExpression
	| SimpleExpression '>' SimpleExpression
	| SimpleExpression K_LE SimpleExpression
	| SimpleExpression K_GE SimpleExpression
	| SimpleExpression K_IN SimpleExpression
	;

ExpressionList :
	Expression
	| ExpressionList ',' Expression
	;

SimpleExpression :
	AdditionExpression
	| '+' AdditionExpression
	| '-' AdditionExpression
	;

AdditionExpression :
	Term
	| AdditionExpression '+' Term
	| AdditionExpression '-' Term
	| AdditionExpression K_OR Term
	;

Term :
	Power
	| Term '*' Power
	| Term '/' Power
	| Term K_DIV Power
	| Term K_MOD Power
	| Term K_AND Power
	| Term K_XOR Power
	| Term K_SHL Power
	| Term K_SHR Power
	;

Power :
	Factor
	| Power K_POW Factor
	;

Factor :
	Variable
	| BasicConstant
	| '[' ExpressionList ']'
	| '[' ']'
	| K_NOT Factor
	| '&' Factor
	| '@' Factor
	| '(' Expression ')'
	| Variable '(' ExpressionList ')'
	| K_VA_ARG '(' TypeIdentifier ')'
	| K_SIZEOF '(' Variable ')'
	| '(' K_IF Expression K_THEN Expression K_ELSE Expression ')'
	;

Variable :
	Identifier
	| Variable '[' ExpressionList ']'
	| Variable '.' Identifier
	| Variable '^'
	;

TypeIdentifier :
	Identifier
	;

Type :
	SimpleType
	| StructuredType
	| K_PACKED StructuredType
	;

SimpleType :
	TypeIdentifier
	| '(' IdentifierList ')'
	| Constant K_DOT_DOT Constant
	;

StructuredType :
	K_ARRAY '[' ArrayBoundsList ']' K_OF Type
	| K_RECORD FieldList K_END
	| K_SET K_OF Type
	| '^' Identifier
	;

ArrayBoundsList :
	BoundType
	| ArrayBoundsList ',' BoundType
	;

BoundType :
	SimpleType
	;

FieldList :
	/*empty*/
	| FixedPart
	| FixedPart ';'
	| FixedPart ';' VariantPart
	| FixedPart ';' VariantPart ';'
	| VariantPart
	| VariantPart ';'
	;

FixedPart :
	RecordSection
	| FixedPart ';' RecordSection
	;

RecordSection :
	IdentifierList ':' Type
	| ProcedureOrFunctionHeading
	;

VariantPart :
	K_CASE Identifier ':' TypeIdentifier K_OF VariantList
	| K_CASE ':' TypeIdentifier K_OF VariantList
	;

VariantList :
	VariantCaseList
	;

VariantCaseList :
	Variant
	| VariantCaseList ';' Variant
	;

Variant :
	VariantCaseLabelList ':' '(' FieldList ')'
	;

VariantCaseLabelList :
	Constant
	| VariantCaseLabelList ',' Constant
	;

Constant :
	ConstantValue
	| '+' ConstantValue
	| '-' ConstantValue
	;

ConstantValue :
	BasicConstant
	| Identifier
	;

BasicConstant :
	INTEGER_CONSTANT
	| REAL_CONSTANT
	| STRING_CONSTANT
	| K_NIL
	;

%%

DIGIT					[0-9]
HEX						[0-9A-Fa-f]
IDALPHA					[a-zA-Z_]
EXPONENT				[Ee][+-]?{DIGIT}+
WHITE					[ \t\v\r\f]

%%

"<>"					K_NE
"<="					K_LE
">="					K_GE
":="					K_ASSIGN
".."					K_DOT_DOT
"**"					K_POW

"and"					K_AND
"array"					K_ARRAY
"begin"					K_BEGIN
"case"					K_CASE
"catch"					K_CATCH
"const"					K_CONST
"div"					K_DIV
"do"					K_DO
"downto"				K_DOWNTO
"else"					K_ELSE
"end"					K_END
"exit"					K_EXIT
"fastcall"				K_FASTCALL
"finally"				K_FINALLY
"for"					K_FOR
"forward"				K_FORWARD
"function"				K_FUNCTION
"goto"					K_GOTO
"if"					K_IF
"in"					K_IN
"label"					K_LABEL
"import"				K_IMPORT
"mod"					K_MOD
"module"				K_MODULE
"nil"					K_NIL
"not"					K_NOT
"of"					K_OF
"or"					K_OR
"packed"				K_PACKED
"pow"					K_POW
"procedure"				K_PROCEDURE
"program"				K_PROGRAM
"record"				K_RECORD
"repeat"				K_REPEAT
"set"					K_SET
"shl"					K_SHL
"shr"					K_SHR
"sizeof"				K_SIZEOF
"stdcall"				K_STDCALL
"then"					K_THEN
"throw"					K_THROW
"to"					K_TO
"try"					K_TRY
"type"					K_TYPE
"until"					K_UNTIL
"var"					K_VAR
"va_arg"				K_VA_ARG
"with"					K_WITH
"while"					K_WHILE
"xor"					K_XOR

"."	'.'
"("	'('
")"	')'
";"	';'
","	','
"="	'='
":"	':'
"["	'['
"]"	']'
"<"	'<'
">"	'>'
"+"	'+'
"-"	'-'
"*"	'*'
"/"	'/'
"&"	'&'
"@"	'@'
"^"	'^'

'(''|[^'])*'			STRING_CONSTANT

\"(\"\"|[^"])*\"		STRING_CONSTANT

{IDALPHA}({DIGIT}|{IDALPHA})*	IDENTIFIER

{DIGIT}+{EXPONENT}				REAL_CONSTANT
{DIGIT}+"."{DIGIT}*{EXPONENT}	REAL_CONSTANT
{DIGIT}+"."{DIGIT}+				REAL_CONSTANT
{DIGIT}+"."[^.]					REAL_CONSTANT

{DIGIT}{HEX}*[hH]				INTEGER_CONSTANT

{DIGIT}+						INTEGER_CONSTANT

{WHITE}+						skip()

\n								skip()

"{".*?"}"								skip()
"(*"(?s:.)*?"*)"							skip()

.								ILLEGAL_CHARACTER

%%
