/*
 * vb_grammar.y - Input file for yacc that defines the syntax of VB.
 *
 * Copyright (C) 2003  Southern Storm Software, Pty Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

 %token ILLEGAL_CHARACTER

/*Tokens*/
%token IDENTIFIER
%token TYPED_IDENTIFIER
%token INTEGER_CONSTANT
%token FLOAT_CONSTANT
%token DECIMAL_CONSTANT
%token CHAR_LITERAL
%token STRING_LITERAL
%token END_LINE
%token CONCAT_ASSIGN_OP
%token MUL_ASSIGN_OP
%token DIV_ASSIGN_OP
%token IDIV_ASSIGN_OP
%token POW_ASSIGN_OP
%token ADD_ASSIGN_OP
%token SUB_ASSIGN_OP
%token NE_OP
%token LE_OP
%token GE_OP
%token EQ_OP
%token LEFT_OP
%token RIGHT_OP
%token K_ADDHANDLER
%token K_ADDRESSOF
%token K_ALIAS
%token K_AND
%token K_ANDALSO
%token K_ANSI
%token K_AS
%token K_ASSEMBLY
%token K_AUTO
%token K_BOOLEAN
%token K_BYREF
%token K_BYTE
%token K_BYVAL
%token K_CALL
%token K_CASE
%token K_CATCH
%token K_CBOOL
%token K_CBYTE
%token K_CCHAR
%token K_CDATE
%token K_CDEC
%token K_CDBL
%token K_CHAR
%token K_CINT
%token K_CLASS
%token K_CLNG
%token K_COBJ
%token K_CONST
%token K_CSHORT
%token K_CSNG
%token K_CSTR
%token K_CTYPE
%token K_DATE
%token K_DECIMAL
%token K_DECLARE
%token K_DEFAULT
%token K_DELEGATE
%token K_DIM
%token K_DIRECTCAST
%token K_DO
%token K_DOUBLE
%token K_EACH
%token K_ELSE
%token K_ELSEIF
%token K_END
%token K_ENUM
%token K_ERASE
%token K_ERROR
%token K_EVENT
%token K_EXIT
%token K_FALSE
%token K_FINALLY
%token K_FOR
%token K_FRIEND
%token K_FUNCTION
%token K_GET
%token K_GETTYPE
%token K_GOSUB
%token K_GOTO
%token K_HANDLES
%token K_IF
%token K_IMPLEMENTS
%token K_IMPORTS
%token K_IN
%token K_INHERITS
%token K_INTEGER
%token K_INTERFACE
%token K_IS
%token K_LET
%token K_LIB
%token K_LIKE
%token K_LONG
%token K_LOOP
%token K_ME
%token K_MOD
%token K_MODULE
%token K_MUSTINHERIT
%token K_MUSTOVERRIDE
%token K_MYBASE
%token K_MYCLASS
%token K_NAMESPACE
%token K_NEW
%token K_NEXT
%token K_NOT
%token K_NOTHING
%token K_NOTINHERITABLE
%token K_NOTOVERRIDABLE
%token K_OBJECT
%token K_ON
%token K_OPTION
%token K_OPTIONAL
%token K_OR
%token K_ORELSE
%token K_OVERLOADS
%token K_OVERRIDABLE
%token K_OVERRIDES
%token K_PARAMARRAY
%token K_PRESERVE
%token K_PRIVATE
%token K_PROPERTY
%token K_PROTECTED
%token K_PUBLIC
%token K_RAISEEVENT
%token K_READONLY
%token K_REDIM
%token K_REMOVEHANDLER
%token K_RESUME
%token K_RETURN
%token K_SELECT
%token K_SET
%token K_SHADOWS
%token K_SHARED
%token K_SHORT
%token K_SINGLE
%token K_STATIC
%token K_STEP
%token K_STOP
%token K_STRING
%token K_STRUCTURE
%token K_SUB
%token K_SYNCLOCK
%token K_THEN
%token K_THROW
%token K_TO
%token K_TRUE
%token K_TRY
%token K_TYPEOF
%token K_UNICODE
%token K_UNTIL
%token K_VARIANT
%token K_WHEN
%token K_WHILE
%token K_WITH
%token K_WITHEVENTS
%token K_WRITEONLY
%token K_XOR
%token ','
%token '='
%token '.'
%token '<'
%token '>'
%token ':'
%token '('
%token ')'
%token '{'
%token '}'
%token '-'
%token '!'
%token '#'
%token '/'
%token '^'
%token '+'
%token '*'
%token '\\'
%token '&'


%start File

%%

File :
	Options Imports NamespaceBody
	;

Options :
	/*empty*/
	| OptionList
	;

OptionList :
	OptionList Option
	| Option
	;

Option :
	K_OPTION Identifier OptionValue END_LINE
	;

OptionValue :
	/*empty*/
	| Identifier
	| K_ON
	;

Imports :
	/*empty*/
	| ImportList
	;

ImportList :
	ImportList Import
	| Import
	;

Import :
	K_IMPORTS ImportClauses END_LINE
	;

ImportClauses :
	ImportClauses ',' ImportClause
	| ImportClause
	;

ImportClause :
	QualifiedIdentifier
	| Identifier '=' QualifiedIdentifier
	;

Identifier :
	IDENTIFIER
	| TYPED_IDENTIFIER
	;

IdentifierOrKeyword :
	Identifier
	;

QualifiedIdentifier :
	QualifiedIdentifier '.' IdentifierOrKeyword
	| Identifier
	;

QualifiedIdentifier2 :
	QualifiedIdentifier2 '.' IDENTIFIER
	| Identifier
	;

OptAttributes :
	/*empty*/
	| '<' AttributeList '>'
	;

AttributeList :
	AttributeList Attribute
	| Attribute
	;

Attribute :
	AttributeModifier TypeName AttributeArgsWithBrackets
	;

AttributeModifier :
	/*empty*/
	| K_ASSEMBLY ':'
	| K_MODULE ':'
	;

AttributeArgsWithBrackets :
	/*empty*/
	| '(' ')'
	| '(' AttributeArguments ')'
	;

AttributeArguments :
	AttributePositionalArguments
	| AttributePositionalArguments ',' AttributeNamedArguments
	| AttributeNamedArguments
	;

AttributePositionalArguments :
	AttributePositionalArguments ',' ConstantExpression
	| ConstantExpression
	;

AttributeNamedArguments :
	AttributeNamedArguments ',' AttributeNamedArgument
	| AttributeNamedArgument
	;

AttributeNamedArgument :
	Identifier ':' '=' ConstantExpression
	;

TypeName :
	QualifiedIdentifier
	| PredefinedType
	| TypeName '(' ArrayRank ')'
	;

PredefinedType :
	K_OBJECT
	| K_VARIANT
	| K_STRING
	| K_BOOLEAN
	| K_DATE
	| K_CHAR
	| K_DECIMAL
	| K_BYTE
	| K_SHORT
	| K_INTEGER
	| K_LONG
	| K_SINGLE
	| K_DOUBLE
	;

ArrayRank :
	/*empty*/
	| RankList
	;

RankList :
	RankList ','
	| ','
	;

ArrayNameModifier :
	'(' ArrayRank ')'
	| '(' InitializationRankList ')'
	;

InitializationRankList :
	InitializationRankList ',' Expression
	| Expression
	;

NamespaceDeclaration :
	K_NAMESPACE QualifiedIdentifier END_LINE NamespaceBody K_END K_NAMESPACE END_LINE
	;

NamespaceBody :
	/*empty*/
	| NamespaceMemberList
	;

NamespaceMemberList :
	NamespaceMemberList NamespaceMember
	| NamespaceMember
	;

NamespaceMember :
	NamespaceDeclaration
	| TypeDeclaration
	;

TypeDeclaration :
	ModuleDeclaration
	| NonModuleDeclaration
	;

NonModuleDeclaration :
	EnumDeclaration
	| StructureDeclaration
	| InterfaceDeclaration
	| ClassDeclaration
	| DelegateDeclaration
	;

OptModifiers :
	/*empty*/
	| ModifierList
	;

ModifierList :
	ModifierList Modifier
	| Modifier
	;

Modifier :
	K_PUBLIC
	| K_PROTECTED
	| K_FRIEND
	| K_PRIVATE
	| K_SHADOWS
	| K_MUSTINHERIT
	| K_NOTINHERITABLE
	| K_SHARED
	| K_STATIC
	| K_OVERRIDABLE
	| K_NOTOVERRIDABLE
	| K_MUSTOVERRIDE
	| K_OVERRIDES
	| K_OVERLOADS
	| K_READONLY
	| K_WRITEONLY
	| K_WITHEVENTS
	| K_DEFAULT
	;

EnumDeclaration :
	OptAttributes OptModifiers K_ENUM Identifier EnumBase END_LINE EnumBody K_END K_ENUM END_LINE
	;

EnumBase :
	/*empty*/
	| K_AS EnumBaseType
	;

EnumBaseType :
	K_BYTE
	| K_SHORT
	| K_INTEGER
	| K_LONG
	;

EnumBody :
	/*empty*/
	| EnumMemberList
	;

EnumMemberList :
	EnumMemberList EnumMember
	| EnumMember
	;

EnumMember :
	OptAttributes Identifier '=' ConstantExpression END_LINE
	| OptAttributes Identifier END_LINE
	;

StructureDeclaration :
	OptAttributes OptModifiers K_STRUCTURE Identifier END_LINE ImplementsClause StructBody K_END K_STRUCTURE END_LINE
	;

ImplementsClause :
	/*empty*/
	| K_IMPLEMENTS Implements END_LINE
	;

Implements :
	Implements ',' TypeName
	| TypeName
	;

StructBody :
	/*empty*/
	| StructMemberList
	;

StructMemberList :
	StructMember
	| StructMemberList StructMember
	;

StructMember :
	NonModuleDeclaration
	| VariableMemberDeclaration
	| ConstantMemberDeclaration
	| EventMemberDeclaration
	| MethodMemberDeclaration
	| PropertyMemberDeclaration
	| ConstructorMemberDeclaration
	;

ClassDeclaration :
	OptAttributes OptModifiers K_CLASS Identifier END_LINE ClassBase ImplementsClause StructBody K_END K_CLASS END_LINE
	;

ClassBase :
	/*empty*/
	| K_INHERITS TypeName END_LINE
	;

ModuleDeclaration :
	OptAttributes OptModifiers K_MODULE Identifier END_LINE StructBody K_END K_MODULE END_LINE
	;

InterfaceDeclaration :
	OptAttributes OptModifiers K_INTERFACE Identifier END_LINE InterfaceBases InterfaceBody K_END K_INTERFACE END_LINE
	;

InterfaceBases :
	/*empty*/
	| K_INHERITS Implements END_LINE
	;

InterfaceBody :
	/*empty*/
	| InterfaceMemberList
	;

InterfaceMemberList :
	InterfaceMember
	| InterfaceMemberList InterfaceMember
	;

InterfaceMember :
	NonModuleDeclaration
	| EventMemberDeclaration
	| MethodMemberDeclaration
	| PropertyMemberDeclaration
	;

DelegateDeclaration :
	OptAttributes OptModifiers K_DELEGATE MethodDeclaration
	;

MethodMemberDeclaration :
	MethodDeclaration
	| ExternalMethodDeclaration
	;

MethodDeclaration :
	SubDeclaration
	| FunctionDeclaration
	;

ExternalMethodDeclaration :
	ExternalSubDeclaration
	| ExternalFunctionDeclaration
	;

SubDeclaration :
	OptAttributes OptModifiers K_SUB Identifier FormalParameters HandlesOrImplements END_LINE SubBody
	;

SubBody :
	/*empty*/
	| Block K_END K_SUB END_LINE
	| K_END K_SUB END_LINE
	;

FunctionDeclaration :
	OptAttributes OptModifiers K_FUNCTION Identifier FormalParameters ReturnType HandlesOrImplements END_LINE FunctionBody
	;

FunctionBody :
	/*empty*/
	| Block K_END K_FUNCTION END_LINE
	| K_END K_FUNCTION END_LINE
	;

ExternalSubDeclaration :
	OptAttributes OptModifiers K_DECLARE CharsetModifier K_SUB Identifier LibraryClause AliasClause FormalParameters END_LINE
	;

ExternalFunctionDeclaration :
	OptAttributes OptModifiers K_DECLARE CharsetModifier K_FUNCTION Identifier LibraryClause AliasClause FormalParameters ReturnType END_LINE
	;

ReturnType :
	/*empty*/
	| K_AS OptAttributes TypeName
	;

FormalParameters :
	/*empty*/
	| '(' ')'
	| '(' FormalParameterList ')'
	;

FormalParameterList :
	FormalParameterList ',' FormalParameter
	| FormalParameter
	;

FormalParameter :
	OptAttributes OptParameterModifiers Identifier ParameterType ParameterDefaultValue
	;

OptParameterModifiers :
	/*empty*/
	| ParameterModifierList
	;

ParameterModifierList :
	ParameterModifierList ParameterModifier
	| ParameterModifier
	;

ParameterModifier :
	K_BYREF
	| K_BYVAL
	| K_OPTIONAL
	| K_PARAMARRAY
	;

ParameterType :
	/*empty*/
	| K_AS TypeName
	;

ParameterDefaultValue :
	/*empty*/
	| '=' ConstantExpression
	;

HandlesOrImplements :
	/*empty*/
	| K_HANDLES EventHandlerList
	| MethodImplementsClause
	;

OptMethodImplementsClause :
	/*empty*/
	| MethodImplementsClause
	;

MethodImplementsClause :
	K_IMPLEMENTS MethodImplementsList
	;

EventHandlerList :
	EventHandlerList EventMemberSpecifier
	| EventMemberSpecifier
	;

EventMemberSpecifier :
	Identifier '.' QualifiedIdentifier2
	| K_MYBASE '.' QualifiedIdentifier2
	;

MethodImplementsList :
	MethodImplementsList MethodImplements
	| MethodImplements
	;

MethodImplements :
	TypeName '.' Identifier
	;

CharsetModifier :
	/*empty*/
	| K_ANSI
	| K_UNICODE
	| K_AUTO
	;

LibraryClause :
	K_LIB STRING_LITERAL
	;

AliasClause :
	/*empty*/
	| K_ALIAS STRING_LITERAL
	;

ConstructorMemberDeclaration :
	OptAttributes OptModifiers K_SUB K_NEW FormalParameters END_LINE SubBody
	;

EventMemberDeclaration :
	OptAttributes OptModifiers K_EVENT Identifier ParametersOrType EventImplements END_LINE
	;

ParametersOrType :
	FormalParameters
	| K_AS TypeName
	;

EventImplements :
	/*empty*/
	| K_IMPLEMENTS MethodImplementsList
	;

ConstantMemberDeclaration :
	OptAttributes OptModifiers K_CONST Identifier ParameterType '=' ConstantExpression END_LINE
	;

VariableMemberDeclaration :
	OptAttributes OptModifiers OptDim VariableDeclarators END_LINE
	;

OptDim :
	/*empty*/
	| K_DIM
	;

VariableDeclarators :
	VariableDeclarators ',' VariableDeclarator
	| VariableDeclarator
	;

VariableDeclarator :
	VariableIdentifier VarType
	| VariableIdentifier VarType '=' VariableInitializer
	;

VariableIdentifier :
	Identifier
	| Identifier ArrayNameModifier
	;

VarType :
	/*empty*/
	| K_AS TypeName '(' ArgumentList ')'
	| K_AS TypeName
	| K_AS K_NEW TypeName '(' ArgumentList ')'
	| K_AS K_NEW TypeName
	;

VariableInitializer :
	Expression
	| '{' '}'
	| '{' VariableInitializerList '}'
	;

VariableInitializerList :
	VariableInitializerList ',' VariableInitializer
	| VariableInitializer
	;

PropertyMemberDeclaration :
	OptAttributes OptModifiers K_PROPERTY Identifier FormalParameters ReturnType OptMethodImplementsClause END_LINE PropertyBody
	;

PropertyBody :
	/*empty*/
	| PropertyAccessors K_END K_PROPERTY END_LINE
	| K_END K_PROPERTY END_LINE
	;

PropertyAccessors :
	Getter
	| Setter
	| Getter Setter
	| Setter Getter
	;

Getter :
	OptAttributes K_GET END_LINE GetBody
	;

GetBody :
	/*empty*/
	| Block K_END K_GET END_LINE
	| K_END K_GET END_LINE
	;

Setter :
	OptAttributes K_SET END_LINE SetBody
	;

SetBody :
	/*empty*/
	| Block K_END K_SET END_LINE
	| K_END K_SET END_LINE
	;

OptBlock :
	/*empty*/
	| Block
	;

Block :
	Block Statement END_LINE
	| Statement END_LINE
	;

OptLineBlock :
	/*empty*/
	| LineBlock
	;

LineBlock :
	LineBlock ':' LineStatement
	| LineStatement
	;

Statement :
	InnerStatement
	;

LineStatement :
	InnerLineStatement
	;

InnerStatement :
	LabeledStatement
	| LocalDeclarationStatement
	| WithStatement
	| SyncLockStatement
	| RaiseEventStatement
	| AddHandlerStatement
	| RemoveHandlerStatement
	| AssignmentStatement
	| LetStatement
	| InvocationStatement
	| IfStatement
	| SelectStatement
	| LoopStatement
	| ExceptionHandlingStatement
	| TryStatement
	| ControlFlowStatement
	| ArrayHandlingStatement
	;

InnerLineStatement :
	LocalDeclarationStatement
	| RaiseEventStatement
	| AddHandlerStatement
	| RemoveHandlerStatement
	| AssignmentStatement
	| LetStatement
	| InvocationStatement
	| ExceptionHandlingStatement
	| ControlFlowStatement
	| ArrayHandlingStatement
	;

LabeledStatement :
	LabelName ':' Statement
	| LabelName ':'
	;

LabelName :
	Identifier
	| INTEGER_CONSTANT
	;

LocalDeclarationStatement :
	K_DIM VariableDeclarator
	| K_CONST VariableDeclarator
	;

WithStatement :
	K_WITH Expression END_LINE OptBlock K_END K_WITH
	;

SyncLockStatement :
	K_SYNCLOCK Expression END_LINE OptBlock K_END K_SYNCLOCK
	;

RaiseEventStatement :
	K_RAISEEVENT PrimaryExpression
	;

AddHandlerStatement :
	K_ADDHANDLER HandlerArguments
	;

RemoveHandlerStatement :
	K_REMOVEHANDLER HandlerArguments
	;

HandlerArguments :
	ArgumentExpression ',' ArgumentExpression
	;

AssignmentStatement :
	PrimaryExpression '=' Expression
	| PrimaryExpression '=' K_ADDRESSOF PrimaryExpression
	| PrimaryExpression POW_ASSIGN_OP Expression
	| PrimaryExpression MUL_ASSIGN_OP Expression
	| PrimaryExpression DIV_ASSIGN_OP Expression
	| PrimaryExpression IDIV_ASSIGN_OP Expression
	| PrimaryExpression ADD_ASSIGN_OP Expression
	| PrimaryExpression SUB_ASSIGN_OP Expression
	| PrimaryExpression CONCAT_ASSIGN_OP Expression
	;

LetStatement :
	K_LET AssignmentStatement
	;

VariableExpression :
	Expression
	;

InvocationStatement :
	PrimaryExpression
	| K_CALL PrimaryExpression
	| K_GOSUB PrimaryExpression
	;

IfStatement :
	K_IF BooleanExpression END_LINE IfRest
	| K_IF BooleanExpression K_THEN END_LINE IfRest
	| K_IF BooleanExpression K_THEN LineBlock
	| K_IF BooleanExpression K_THEN LineBlock K_ELSE OptLineBlock
	;

IfRest :
	OptBlock ElseIfStatements ElseStatement K_END K_IF
	;

ElseIfStatements :
	/*empty*/
	| ElseIfStatementList
	;

ElseIfStatementList :
	ElseIfStatementList ElseIfStatement
	| ElseIfStatement
	;

ElseIfStatement :
	K_ELSEIF BooleanExpression END_LINE OptBlock
	| K_ELSEIF BooleanExpression K_THEN END_LINE OptBlock
	;

ElseStatement :
	/*empty*/
	| K_ELSE END_LINE OptBlock
	;

BooleanExpression :
	Expression
	;

SelectStatement :
	K_SELECT Expression END_LINE SelectRest
	| K_SELECT K_CASE Expression END_LINE SelectRest
	;

SelectRest :
	CaseStatements CaseElseStatement K_END K_SELECT END_LINE
	;

CaseStatements :
	/*empty*/
	| CaseStatementList
	;

CaseStatementList :
	CaseStatementList CaseStatement
	| CaseStatement
	;

CaseStatement :
	K_CASE CaseClauses END_LINE OptBlock
	;

CaseClauses :
	CaseClauses ',' CaseClause
	| CaseClause
	;

CaseClause :
	ComparisonOperator Expression
	| K_IS ComparisonOperator Expression
	| Expression
	| Expression K_TO Expression
	;

ComparisonOperator :
	'='
	| '<'
	| '>'
	| LE_OP
	| GE_OP
	| NE_OP
	;

CaseElseStatement :
	/*empty*/
	| K_CASE K_ELSE OptBlock
	;

LoopStatement :
	K_WHILE BooleanExpression END_LINE OptBlock K_END K_WHILE
	| K_DO K_WHILE BooleanExpression END_LINE OptBlock K_LOOP
	| K_DO K_UNTIL BooleanExpression END_LINE OptBlock K_LOOP
	| K_DO END_LINE OptBlock K_LOOP K_WHILE BooleanExpression
	| K_DO END_LINE OptBlock K_LOOP K_UNTIL BooleanExpression
	| K_FOR LoopControlVariable '=' Expression K_TO Expression StepExpression END_LINE OptBlock K_NEXT NextExpression
	| K_FOR K_EACH LoopControlVariable K_IN Expression END_LINE K_NEXT NextExpression
	;

LoopControlVariable :
	Identifier K_AS TypeName
	| PrimaryExpression
	;

StepExpression :
	/*empty*/
	| K_STEP Expression
	;

NextExpression :
	/*empty*/
	| Identifier
	;

ExceptionHandlingStatement :
	K_THROW
	| K_THROW Expression
	| K_ERROR Expression
	| K_ON K_ERROR K_RESUME K_NEXT
	| K_ON K_ERROR K_GOTO '-' INTEGER_CONSTANT
	| K_ON K_ERROR K_GOTO LabelName
	| K_RESUME
	| K_RESUME K_NEXT
	| K_RESUME LabelName
	;

TryStatement :
	K_TRY OptBlock CatchStatements FinallyStatement K_END K_TRY
	;

CatchStatements :
	/*empty*/
	| CatchStatementList
	;

CatchStatementList :
	CatchStatementList CatchStatement
	| CatchStatement
	;

CatchStatement :
	K_CATCH CatchName CatchWhen END_LINE OptBlock
	;

CatchName :
	/*empty*/
	| Identifier K_AS TypeName
	;

CatchWhen :
	/*empty*/
	| K_WHEN BooleanExpression
	;

FinallyStatement :
	/*empty*/
	| K_FINALLY END_LINE OptBlock
	;

ControlFlowStatement :
	K_GOTO LabelName
	| K_EXIT K_DO
	| K_EXIT K_FOR
	| K_EXIT K_WHILE
	| K_EXIT K_SELECT
	| K_EXIT K_SUB
	| K_EXIT K_FUNCTION
	| K_EXIT K_TRY
	| K_STOP
	| K_END
	| K_RETURN
	| K_RETURN Expression
	;

ArrayHandlingStatement :
	K_REDIM RedimClauses
	| K_REDIM K_PRESERVE RedimClauses
	| K_ERASE VariableExpressions
	;

RedimClauses :
	RedimClauses ',' RedimClause
	| RedimClause
	;

RedimClause :
	VariableExpression '(' InitializationRankList ')'
	;

VariableExpressions :
	VariableExpressions ',' VariableExpression
	| VariableExpression
	;

PrimaryExpression :
	INTEGER_CONSTANT
	| FLOAT_CONSTANT
	| DECIMAL_CONSTANT
	| CHAR_LITERAL
	| STRING_LITERAL
	| DateLiteral
	| K_TRUE
	| K_FALSE
	| K_NOTHING
	| Identifier
	| '(' Expression ')'
	| K_ME
	| K_MYCLASS
	| K_MYBASE
	| K_GETTYPE '(' Expression ')'
	| PrimaryExpression '(' ')'
	| PrimaryExpression '(' ArgumentList ')'
	| PrimaryExpression '.' IdentifierOrKeyword
	| '.' IdentifierOrKeyword
	| ObjectCreationExpression
	| '!' IdentifierOrKeyword
	| PrimaryExpression '!' IdentifierOrKeyword
	| K_CTYPE '(' Expression ',' TypeName ')'
	| K_DIRECTCAST '(' Expression ',' TypeName ')'
	| CastTarget '(' Expression ')'
	;

DateLiteral :
	'#' DateValue TimeValue '#'
	;

DateValue :
	/*empty*/
	| INTEGER_CONSTANT DateSeparator INTEGER_CONSTANT DateSeparator INTEGER_CONSTANT
	;

DateSeparator :
	'-'
	| '/'
	;

TimeValue :
	/*empty*/
	| INTEGER_CONSTANT AmPm
	| INTEGER_CONSTANT ':' INTEGER_CONSTANT AmPm
	| INTEGER_CONSTANT ':' INTEGER_CONSTANT ':' INTEGER_CONSTANT AmPm
	;

AmPm :
	/*empty*/
	| IDENTIFIER
	;

ArgumentList :
	PositionalArgumentList ',' NamedArgumentList
	| PositionalArgumentList
	| NamedArgumentList
	;

PositionalArgumentList :
	PositionalArgumentList ',' ArgumentExpression
	| ArgumentExpression
	;

NamedArgumentList :
	NamedArgumentList ',' Identifier ':' '=' ArgumentExpression
	| Identifier ':' '=' ArgumentExpression
	;

ArgumentExpression :
	Expression
	| K_ADDRESSOF PrimaryExpression
	;

ObjectCreationExpression :
	K_NEW TypeName ArrayElementInitializer
	| K_NEW TypeName '(' ')' ArrayElementInitializer
	| K_NEW TypeName '(' ArgumentList ')' ArrayElementInitializer
	;

ArrayElementInitializer :
	/*empty*/
	| '{' '}'
	| '{' VariableInitializerList '}'
	;

CastTarget :
	K_CBOOL
	| K_CBYTE
	| K_CCHAR
	| K_CDATE
	| K_CDEC
	| K_CDBL
	| K_CINT
	| K_CLNG
	| K_COBJ
	| K_CSHORT
	| K_CSNG
	| K_CSTR
	;

PowerExpression :
	PrimaryExpression
	| PowerExpression '^' UnaryExpression
	;

UnaryExpression :
	PowerExpression
	| '-' UnaryExpression
	| '+' UnaryExpression
	;

MultiplicativeExpression :
	UnaryExpression
	| MultiplicativeExpression '*' UnaryExpression
	| MultiplicativeExpression '/' UnaryExpression
	;

IntegerDivisionExpression :
	MultiplicativeExpression
	| IntegerDivisionExpression '\\' MultiplicativeExpression
	;

ModExpression :
	IntegerDivisionExpression
	| MultiplicativeExpression K_MOD IntegerDivisionExpression
	;

AdditiveExpression :
	ModExpression
	| AdditiveExpression '+' ModExpression
	| AdditiveExpression '-' ModExpression
	;

ConcatenationExpression :
	AdditiveExpression
	| ConcatenationExpression '&' AdditiveExpression
	;

ShiftExpression :
	ConcatenationExpression
	| ShiftExpression LEFT_OP ConcatenationExpression
	| ShiftExpression RIGHT_OP ConcatenationExpression
	;

RelationalExpression :
	ShiftExpression
	| RelationalExpression '=' ShiftExpression
	| RelationalExpression EQ_OP ShiftExpression
	| RelationalExpression NE_OP ShiftExpression
	| RelationalExpression '<' ShiftExpression
	| RelationalExpression '>' ShiftExpression
	| RelationalExpression LE_OP ShiftExpression
	| RelationalExpression GE_OP ShiftExpression
	| RelationalExpression K_IS ShiftExpression
	| RelationalExpression K_LIKE ShiftExpression
	| K_TYPEOF Expression K_IS TypeName
	;

NotExpression :
	RelationalExpression
	| K_NOT NotExpression
	;

AndExpression :
	NotExpression
	| AndExpression K_AND NotExpression
	| AndExpression K_ANDALSO NotExpression
	;

OrExpression :
	AndExpression
	| OrExpression K_OR AndExpression
	| OrExpression K_ORELSE AndExpression
	| OrExpression K_XOR AndExpression
	;

Expression :
	OrExpression
	;

ConstantExpression :
	Expression
	;

%%

DIGIT			[0-9]
IDALPHA			[a-zA-Z_]
HEX				[a-fA-F0-9]
OCTAL			[0-7]
EXPONENT		[Ee][+-]?{DIGIT}+
FTYPE			(f|F|r|R|d|D)
ITYPE			(s|S|i|I|l|L)*
WHITE			[ \t\v\r\f]
TYPECHAR		[%&@!#$]

%%

"&="					CONCAT_ASSIGN_OP
"*="					MUL_ASSIGN_OP
"/="					DIV_ASSIGN_OP
"\\="					IDIV_ASSIGN_OP
"^="					POW_ASSIGN_OP
"+="					ADD_ASSIGN_OP
"-="					SUB_ASSIGN_OP
"<>"					NE_OP
"<="					LE_OP
"=<"					LE_OP
">="					GE_OP
"=="					EQ_OP
"<<"					LEFT_OP
">>"					RIGHT_OP

"AddHandler"			K_ADDHANDLER
"AddressOf"				K_ADDRESSOF
"Alias"					K_ALIAS
"And"					K_AND
"AndAlso"				K_ANDALSO
"Ansi"					K_ANSI
"As"					K_AS
"Assembly"				K_ASSEMBLY
"Auto"					K_AUTO
"Boolean"				K_BOOLEAN
"ByRef"					K_BYREF
"Byte"					K_BYTE
"ByVal"					K_BYVAL
"Call"					K_CALL
"Case"					K_CASE
"Catch"					K_CATCH
"CBool"					K_CBOOL
"CByte"					K_CBYTE
"CChar"					K_CCHAR
"CDate"					K_CDATE
"CDec"					K_CDEC
"CDbl"					K_CDBL
"Char"					K_CHAR
"CInt"					K_CINT
"Class"					K_CLASS
"CLng"					K_CLNG
"CObj"					K_COBJ
"Const"					K_CONST
"CShort"				K_CSHORT
"CSng"					K_CSNG
"CStr"					K_CSTR
"CType"					K_CTYPE
"Date"					K_DATE
"Decimal"				K_DECIMAL
"Declare"				K_DECLARE
"Default"				K_DEFAULT
"Delegate"				K_DELEGATE
"Dim"					K_DIM
"DirectCast"			K_DIRECTCAST
"Do"					K_DO
"Double"				K_DOUBLE
"Each"					K_EACH
"Else"					K_ELSE
"ElseIf"				K_ELSEIF
"End"					K_END
"Enum"					K_ENUM
"Erase"					K_ERASE
"Error"					K_ERROR
"Event"					K_EVENT
"Exit"					K_EXIT
"False"					K_FALSE
"Finally"				K_FINALLY
"For"					K_FOR
"Friend"				K_FRIEND
"Function"				K_FUNCTION
"Get"					K_GET
"GetType"				K_GETTYPE
"GoSub"					K_GOSUB
"GoTo"					K_GOTO
"Handles"				K_HANDLES
"If"					K_IF
"Implements"			K_IMPLEMENTS
"Imports"				K_IMPORTS
"In"					K_IN
"Inherits"				K_INHERITS
"Integer"				K_INTEGER
"Interface"				K_INTERFACE
"Is"					K_IS
"Let"					K_LET
"Lib"					K_LIB
"Like"					K_LIKE
"Long"					K_LONG
"Loop"					K_LOOP
"Me"					K_ME
"Mod"					K_MOD
"Module"				K_MODULE
"MustInherit"			K_MUSTINHERIT
"MustOverride"			K_MUSTOVERRIDE
"MyBase"				K_MYBASE
"MyClass"				K_MYCLASS
"Namespace"				K_NAMESPACE
"New"					K_NEW
"Next"					K_NEXT
"Not"					K_NOT
"Nothing"				K_NOTHING
"NotInheritable"		K_NOTINHERITABLE
"NotOverridable"		K_NOTOVERRIDABLE
"Object"				K_OBJECT
"On"					K_ON
"Option"				K_OPTION
"Optional"				K_OPTIONAL
"Or"					K_OR
"OrElse"				K_ORELSE
"Overloads"				K_OVERLOADS
"Overridable"			K_OVERRIDABLE
"Overrides"				K_OVERRIDES
"ParamArray"			K_PARAMARRAY
"Preserve"				K_PRESERVE
"Private"				K_PRIVATE
"Property"				K_PROPERTY
"Protected"				K_PROTECTED
"Public"				K_PUBLIC
"RaiseEvent"			K_RAISEEVENT
"ReadOnly"				K_READONLY
"ReDim"					K_REDIM
"RemoveHandler"			K_REMOVEHANDLER
"Resume"				K_RESUME
"Return"				K_RETURN
"Select"				K_SELECT
"Set"					K_SET
"Shadows"				K_SHADOWS
"Shared"				K_SHARED
"Short"					K_SHORT
"Single"				K_SINGLE
"Static"				K_STATIC
"Step"					K_STEP
"Stop"					K_STOP
"String"				K_STRING
"Structure"				K_STRUCTURE
"Sub"					K_SUB
"SyncLock"				K_SYNCLOCK
"Then"					K_THEN
"Throw"					K_THROW
"To"					K_TO
"True"					K_TRUE
"Try"					K_TRY
"TypeOf"				K_TYPEOF
"Unicode"				K_UNICODE
"Until"					K_UNTIL
"Variant"				K_VARIANT
"When"					K_WHEN
"While"					K_WHILE
"With"					K_WITH
"WithEvents"			K_WITHEVENTS
"WriteOnly"				K_WRITEONLY
"Xor"					K_XOR

","	','
"="	'='
"."	'.'
"<"	'<'
">"	'>'
":"	':'
"("	'('
")"	')'
"{"	'{'
"}"	'}'
"-"	'-'
"!"	'!'
"#"	'#'
"/"	'/'
"^"	'^'
"+"	'+'
"*"	'*'
"\\"	'\\'
"&"	'&'

DECIMAL_CONSTANT	DECIMAL_CONSTANT

{IDALPHA}({DIGIT}|{IDALPHA})*	IDENTIFIER

{IDALPHA}({DIGIT}|{IDALPHA})*{TYPECHAR}	TYPED_IDENTIFIER

"["{IDALPHA}({DIGIT}|{IDALPHA})*"]"	IDENTIFIER /* Escaped identifier */

{DIGIT}+{EXPONENT}{FTYPE}?				 FLOAT_CONSTANT
{DIGIT}*"."{DIGIT}+({EXPONENT})?{FTYPE}? FLOAT_CONSTANT
{DIGIT}+"."{DIGIT}*({EXPONENT})?{FTYPE}? FLOAT_CONSTANT

"&H"{HEX}+{ITYPE}?				INTEGER_CONSTANT
"&O"{OCTAL}+{ITYPE}?			INTEGER_CONSTANT
{DIGIT}+{ITYPE}?				INTEGER_CONSTANT

\"([^"\n]|\"\")*\"C				CHAR_LITERAL

\"([^"\n]|\"\")*\"				STRING_LITERAL

("Rem"|"'")					skip() /* Skip the comment line */

"_"{WHITE}*\n					skip() /* Line continuation */

{WHITE}+						skip()

\n\n*								END_LINE

'.*\n? skip()
#.*\n?  skip()

.								ILLEGAL_CHARACTER

%%
