/*
 * cs_grammar.y - Input file for yacc that defines the syntax of C#.
 *
 * Copyright (C) 2001, 2002, 2003, 2008  Southern Storm Software, Pty Ltd.
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
%token IDENTIFIER_OP
%token '='
%token '|'
%token '&'
%token '<'
%token '>'
%token GT_OP
%token RIGHT_OP
%token '+'
%token '-'
%token '*'
%token '/'
%token '%'
%token UN_PLUS
%token UN_MINUS
%token '!'
%token '~'
//%token UN_PRE_INC
//%token UN_PRE_DEC
//%token CAST
%token ADDRESS_OF
%token '.'
//%token UN_POST_INC
//%token UN_POST_DEC
%token INTEGER_CONSTANT
%token CHAR_CONSTANT
%token IDENTIFIER_LEXICAL
%token STRING_LITERAL
%token FLOAT_CONSTANT
%token DECIMAL_CONSTANT
%token DOC_COMMENT
%token DEFAULT_LABEL
%token ABSTRACT
%token ADD
%token ARGLIST
%token AS
%token BASE
%token BOOL
%token BREAK
%token BUILTIN_CONSTANT
%token BYTE
%token CASE
%token CATCH
%token CHAR
%token CHECKED
%token CLASS
%token CONST
%token CONTINUE
%token DECIMAL
%token DEFAULT
%token DELEGATE
%token DO
%token DOUBLE
%token ELSE
%token ENUM
%token EVENT
%token EXPLICIT
%token EXTERN
%token FALSE
%token FINALLY
%token FIXED
%token FLOAT
%token FOR
%token FOREACH
%token GET
%token GOTO
%token IF
%token IMPLICIT
%token IN
%token INT
%token INTERFACE
%token INTERNAL
%token IS
%token LOCK
%token LONG
%token LONG_DOUBLE
%token MAKEREF
%token MODULE
%token NAMESPACE
%token NEW
%token NULL_TOK
%token OBJECT
%token OPERATOR
%token OUT
%token OVERRIDE
%token PARAMS
%token PARTIAL
%token PRIVATE
%token PROTECTED
%token PUBLIC
%token READONLY
%token REMOVE
%token REF
%token REFTYPE
%token REFVALUE
%token RETURN
%token SBYTE
%token SEALED
%token SET
%token SHORT
%token SIZEOF
%token STACKALLOC
%token STATIC
%token STRING
%token STRUCT
%token SWITCH
%token THIS
%token THROW
%token TRUE
%token TRY
%token TYPEOF
%token UINT
%token ULONG
%token UNCHECKED
%token UNSAFE
%token USHORT
%token USING
%token VIRTUAL
%token VOID
%token VOLATILE
%token WHERE
%token WHILE
%token YIELD
%token INC_OP
%token DEC_OP
%token LEFT_OP
%token LE_OP
%token GE_OP
%token EQ_OP
%token NE_OP
%token AND_OP
%token OR_OP
%token MUL_ASSIGN_OP
%token DIV_ASSIGN_OP
%token MOD_ASSIGN_OP
%token ADD_ASSIGN_OP
%token SUB_ASSIGN_OP
%token LEFT_ASSIGN_OP
%token RIGHT_ASSIGN_OP
%token AND_ASSIGN_OP
%token XOR_ASSIGN_OP
%token OR_ASSIGN_OP
%token PTR_OP
%token NULL_COALESCING_OP
%token QUALIFIED_ALIAS_OP
%token '}'
%token ';'
%token '{'
%token '['
%token ']'
%token ','
%token '('
%token ')'
%token '^'
%token '?'
%token ':'

%nonassoc /*1*/ IDENTIFIER_OP
%right /*2*/ '=' MUL_ASSIGN_OP DIV_ASSIGN_OP MOD_ASSIGN_OP ADD_ASSIGN_OP SUB_ASSIGN_OP LEFT_ASSIGN_OP RIGHT_ASSIGN_OP AND_ASSIGN_OP XOR_ASSIGN_OP OR_ASSIGN_OP
%left /*3*/ OR_OP
%left /*4*/ AND_OP
%left /*5*/ '|'
%left /*6*/ '&'
%left /*7*/ EQ_OP NE_OP
%left /*8*/ '<' '>' GT_OP AS IS LE_OP GE_OP
%left /*9*/ RIGHT_OP LEFT_OP
%left /*10*/ '+' '-'
%left /*11*/ '*' '/' '%'
%left /*12*/ UN_PLUS UN_MINUS '!' '~' UN_PRE_INC UN_PRE_DEC CAST ADDRESS_OF
%left /*13*/ '.' UN_POST_INC UN_POST_DEC CHECKED NEW TYPEOF UNCHECKED PTR_OP

%start CompilationUnit

%%

CompilationUnit :
	/*empty*/
	| OuterDeclarationsRecoverable
	| OuterDeclarationsRecoverable NonOptAttributes
	| NonOptAttributes
	;

OuterDeclarations :
	OuterDeclaration
	| OuterDeclarations OuterDeclaration
	;

OuterDeclaration :
	UsingDirective
	| NamespaceMemberDeclaration
	//| error
	;

OuterDeclarationsRecoverable :
	OuterDeclarationRecoverable
	| OuterDeclarationsRecoverable OuterDeclarationRecoverable
	;

OuterDeclarationRecoverable :
	OuterDeclaration
	| '}'
	;

Identifier :
	IDENTIFIER
	;

GenericIdentifierStart :
	Identifier '<' /*8L*/
	;

IDENTIFIER :
	IDENTIFIER_LEXICAL
	| GET
	| SET
	| ADD
	| REMOVE
	| PARTIAL
	| WHERE
	| YIELD
	;

QualifiedIdentifier :
	NonGenericQualifiedIdentifier
	| GenericQualifiedIdentifier
	;

SimpleQualifiedIdentifier :
	QualifiedIdentifierMemberAccessStart IDENTIFIER
	;

GenericQualifiedIdentifier :
	GenericQualifiedIdentifierStart TypeActuals '>' /*8L*/
	;

GenericQualifiedIdentifierStart :
	GenericIdentifierStart
	| SimpleQualifiedIdentifier '<' /*8L*/
	;

NonGenericQualifiedIdentifier :
	Identifier %prec IDENTIFIER_OP /*1N*/
	| SimpleQualifiedIdentifier %prec IDENTIFIER_OP /*1N*/
	;

QualifiedIdentifierMemberAccessStart :
	NonGenericQualifiedIdentifier '.' /*13L*/
	| GenericQualifiedIdentifier '.' /*13L*/
	;

NamespaceDeclaration :
	OptAttributes NAMESPACE NamespaceIdentifier NamespaceBody OptSemiColon
	;

NamespaceIdentifier :
	IDENTIFIER
	| NamespaceIdentifier '.' /*13L*/ IDENTIFIER
	;

OptSemiColon :
	/*empty*/
	| ';'
	;

NamespaceBody :
	'{' OptNamespaceMemberDeclarations '}'
	;

UsingDirective :
	USING IDENTIFIER '=' /*2R*/ QualifiedIdentifier ';'
	| USING NamespaceIdentifier ';'
	;

OptNamespaceMemberDeclarations :
	/*empty*/
	| OuterDeclarations
	;

NamespaceMemberDeclaration :
	NamespaceDeclaration
	| TypeDeclaration
	;

TypeDeclaration :
	ClassDeclaration
	| ModuleDeclaration
	| StructDeclaration
	| InterfaceDeclaration
	| EnumDeclaration
	| DelegateDeclaration
	;

NonArrayType :
	BuiltinType
	| QualifiedIdentifier
	| PointerType
	;

ArrayTypeStart :
	NonArrayType '['
	;

ArrayTypeContinue :
	ArrayTypeStart ']'
	| ArrayTypeStart DimensionSeparatorList ']'
	| ArrayTypeContinue RankSpecifier
	;

ArrayType :
	ArrayTypeContinue
	;

PointerType :
	Type '*' /*11L*/
	;

Type :
	NonArrayType %prec IDENTIFIER_OP /*1N*/
	| ArrayType %prec IDENTIFIER_OP /*1N*/
	;

RankSpecifiers :
	RankSpecifier
	| RankSpecifiers RankSpecifier
	;

RankSpecifier :
	'[' DimensionSeparators ']'
	;

TypeActuals :
	Type
	| TypeActuals ',' Type
	;

PrimaryTypeExpression :
	PrimaryTypeExpressionPart
	| PrimaryMemberAccessExpression
	;

PrimaryMemberAccessStart :
	BuiltinType '.' /*13L*/
	| PrimaryTypeExpressionPart '.' /*13L*/
	| PrimaryMemberAccessExpression '.' /*13L*/
	;

PrimaryTypeExpressionPart :
	Identifier
	;

PrimaryMemberAccessExpression :
	PrimaryMemberAccessStart PrimaryTypeExpressionPart
	;

LocalVariableType :
	LocalVariableNonArrayType
	| LocalVariableArrayType
	;

LocalVariableNonArrayType :
	BuiltinType
	| PrimaryTypeExpression
	| LocalVariablePointerType
	;

LocalVariableArrayTypeStart :
	PrimaryTypeExpression '['
	;

LocalVariableArrayTypeContinue :
	BuiltinType RankSpecifier
	| LocalVariablePointerType RankSpecifier
	| LocalVariableArrayTypeStart ']'
	| LocalVariableArrayTypeStart DimensionSeparatorList ']'
	| LocalVariableArrayTypeContinue RankSpecifier
	;

LocalVariableArrayType :
	LocalVariableArrayTypeContinue
	;

LocalVariablePointerType :
	BuiltinType '*' /*11L*/
	| PrimaryTypeExpression '*' /*11L*/
	| LocalVariableArrayType '*' /*11L*/
	| LocalVariablePointerType '*' /*11L*/
	;

DimensionSeparators :
	/*empty*/
	| DimensionSeparatorList
	;

DimensionSeparatorList :
	','
	| DimensionSeparatorList ','
	;

BuiltinType :
	VOID
	| BOOL
	| SBYTE
	| BYTE
	| SHORT
	| USHORT
	| INT
	| UINT
	| LONG
	| ULONG
	| CHAR
	| FLOAT
	| DOUBLE
	| LONG_DOUBLE
	| DECIMAL
	| OBJECT
	| STRING
	;

PrimaryArrayCreationExpression :
	NEW /*13L*/ ArrayTypeStart ExpressionList ']' OptArrayInitializer
	| NEW /*13L*/ ArrayTypeStart ExpressionList ']' RankSpecifiers OptArrayInitializer
	| NEW /*13L*/ ArrayType ArrayInitializer
	;

ElementAccess :
	BASE '[' ExpressionList ']'
	| LocalVariableArrayTypeStart ExpressionList ']'
	| PrimaryNonTypeExpression '[' ExpressionList ']'
	;

PrimaryNonTypeExpression :
	PrimarySimpleExpression
	| PrimaryArrayCreationExpression
	;

PrimarySimpleExpression :
	LiteralExpression
	| PrimaryNonTypeExpression '.' /*13L*/ PrimaryTypeExpressionPart
	| '(' Expression ')'
	| SimpleCastExpression
	| InvocationExpression
	| ElementAccess
	| ARGLIST
	| THIS
	| BASE '.' /*13L*/ Identifier
	| PostIncrementExpression
	| PostDecrementExpression
	| ObjectCreationExpression
	| TYPEOF /*13L*/ '(' Type ')'
	| SIZEOF '(' Type ')'
	| CHECKED /*13L*/ '(' Expression ')'
	| UNCHECKED /*13L*/ '(' Expression ')'
	| PrimaryExpression PTR_OP /*13L*/ Identifier
	| STACKALLOC ArrayTypeStart Expression ']'
	| BUILTIN_CONSTANT '(' STRING_LITERAL ')'
	| MAKEREF '(' Expression ')'
	| REFTYPE '(' Expression ')'
	| REFVALUE '(' Expression ',' Type ')'
	| MODULE
	| DELEGATE AnonymousMethod
	| PrimaryMemberAccessStart DEFAULT
	| DefaultValueExpression
	;

PrimaryExpression :
	PrimaryNonTypeExpression
	| PrimaryTypeExpression
	;

LiteralExpression :
	TRUE
	| FALSE
	| NULL_TOK
	| INTEGER_CONSTANT
	| FLOAT_CONSTANT
	| DECIMAL_CONSTANT
	| CHAR_CONSTANT
	| STRING_LITERAL
	;

DefaultValueExpression :
	DEFAULT '(' Type ')'
	;

InvocationExpression :
	PrimaryExpression '(' OptArgumentList ')'
	;

ObjectCreationExpression :
	NEW /*13L*/ Type '(' OptArgumentList ')'
	;

PreIncrementExpression :
	INC_OP PrefixedUnaryExpression
	;

PreDecrementExpression :
	DEC_OP PrefixedUnaryExpression
	;

PostIncrementExpression :
	PrimaryExpression INC_OP
	;

PostDecrementExpression :
	PrimaryExpression DEC_OP
	;

OptArgumentList :
	/*empty*/
	| ArgumentList
	;

ArgumentList :
	Argument
	| ArgumentList ',' Argument
	;

Argument :
	Expression
	| OUT Expression
	| REF Expression
	;

ExpressionList :
	Expression
	| ExpressionList ',' Expression
	;

SimpleCastExpression :
	'(' PrimaryTypeExpression ')'
	;

CastExpression :
	'(' BuiltinType ')' PrefixedUnaryExpression
	| '(' LocalVariablePointerType ')' PrefixedUnaryExpression
	| '(' LocalVariableArrayType ')' PrefixedUnaryExpression
	| SimpleCastExpression UnaryExpression
	;

UnaryExpression :
	UnaryNonTypeExpression
	| PrimaryTypeExpression
	;

UnaryNonTypeExpression :
	PrimaryNonTypeExpression
	| '!' /*12L*/ PrefixedUnaryExpression
	| '~' /*12L*/ PrefixedUnaryExpression
	| CastExpression
	;

PrefixedUnaryExpression :
	PrefixedUnaryNonTypeExpression
	| PrimaryTypeExpression
	;

PrefixedUnaryNonTypeExpression :
	UnaryNonTypeExpression
	| '+' /*10L*/ PrefixedUnaryExpression %prec UN_PLUS /*12L*/
	| '-' /*10L*/ PrefixedUnaryExpression %prec UN_MINUS /*12L*/
	| PreIncrementExpression
	| PreDecrementExpression
	| '*' /*11L*/ PrefixedUnaryExpression
	| '&' /*6L*/ PrefixedUnaryExpression %prec ADDRESS_OF /*12L*/
	;

MultiplicativeExpression :
	MultiplicativeNonTypeExpression
	| PrimaryTypeExpression
	;

MultiplicativeNonTypeExpression :
	PrefixedUnaryNonTypeExpression
	| MultiplicativeNonTypeExpression '*' /*11L*/ PrefixedUnaryExpression
	| PrimaryTypeExpression '*' /*11L*/ PrefixedUnaryExpression
	| MultiplicativeExpression '/' /*11L*/ PrefixedUnaryExpression
	| MultiplicativeExpression '%' /*11L*/ PrefixedUnaryExpression
	;

AdditiveExpression :
	AdditiveNonTypeExpression
	| PrimaryTypeExpression
	;

AdditiveNonTypeExpression :
	MultiplicativeNonTypeExpression
	| AdditiveExpression '+' /*10L*/ MultiplicativeExpression
	| AdditiveExpression '-' /*10L*/ MultiplicativeExpression
	;

ShiftExpression :
	ShiftNonTypeExpression
	| PrimaryTypeExpression
	;

ShiftNonTypeExpression :
	AdditiveNonTypeExpression
	| LeftShiftExpression
	| RightShiftExpression
	;

LeftShiftExpression :
	ShiftExpression LEFT_OP /*9L*/ AdditiveExpression
	;

RightShiftExpression :
	RightShiftExpressionStart '>' /*8L*/ AdditiveExpression %prec RIGHT_OP /*9L*/
	;

RightShiftExpressionStart :
	PrimaryTypeExpression '>' /*8L*/
	| AdditiveNonTypeExpression '>' /*8L*/
	| LeftShiftExpression '>' /*8L*/
	| RightShiftExpression '>' /*8L*/
	;

RightShift :
	'>' /*8L*/ '>' /*8L*/
	;

RelationalExpression :
	RelationalNonTypeExpression
	| PrimaryTypeExpression
	;

RelationalNonTypeExpression :
	ShiftNonTypeExpression
	| RelationalNonGTExpression
	| RelationalGTExpression
	;

RelationalNonGTExpression :
	RelationalExpression '<' /*8L*/ ShiftExpression
	| RelationalExpression LE_OP /*8L*/ ShiftExpression
	| RelationalExpression GE_OP /*8L*/ ShiftExpression
	| RelationalExpression IS /*8L*/ Type
	| RelationalExpression AS /*8L*/ Type
	;

RelationalGTExpression :
	RightShiftExpressionStart ShiftExpression %prec GT_OP /*8L*/
	| RelationalGTExpression '>' /*8L*/ ShiftExpression %prec GT_OP /*8L*/
	| RelationalNonGTExpression '>' /*8L*/ ShiftExpression %prec GT_OP /*8L*/
	;

EqualityExpression :
	EqualityNonTypeExpression
	| PrimaryTypeExpression
	;

EqualityNonTypeExpression :
	RelationalNonTypeExpression
	| EqualityExpression EQ_OP /*7L*/ RelationalExpression
	| EqualityExpression NE_OP /*7L*/ RelationalExpression
	;

AndExpression :
	EqualityExpression
	| AndExpression '&' /*6L*/ EqualityExpression
	;

XorExpression :
	AndExpression
	| XorExpression '^' AndExpression
	;

OrExpression :
	XorExpression
	| OrExpression '|' /*5L*/ XorExpression
	;

LogicalAndExpression :
	OrExpression
	| LogicalAndExpression AND_OP /*4L*/ OrExpression
	;

LogicalOrExpression :
	LogicalAndExpression
	| LogicalOrExpression OR_OP /*3L*/ LogicalAndExpression
	;

ConditionalExpression :
	LogicalOrExpression
	| LogicalOrExpression '?' Expression ':' Expression
	;

AssignmentExpression :
	PrefixedUnaryExpression '=' /*2R*/ Expression
	| PrefixedUnaryExpression ADD_ASSIGN_OP /*2R*/ Expression
	| PrefixedUnaryExpression SUB_ASSIGN_OP /*2R*/ Expression
	| PrefixedUnaryExpression MUL_ASSIGN_OP /*2R*/ Expression
	| PrefixedUnaryExpression DIV_ASSIGN_OP /*2R*/ Expression
	| PrefixedUnaryExpression MOD_ASSIGN_OP /*2R*/ Expression
	| PrefixedUnaryExpression AND_ASSIGN_OP /*2R*/ Expression
	| PrefixedUnaryExpression OR_ASSIGN_OP /*2R*/ Expression
	| PrefixedUnaryExpression XOR_ASSIGN_OP /*2R*/ Expression
	| PrefixedUnaryExpression LEFT_ASSIGN_OP /*2R*/ Expression
	| PrefixedUnaryExpression RIGHT_ASSIGN_OP /*2R*/ Expression
	;

Expression :
	ConditionalExpression
	| AssignmentExpression
	;

ParenExpression :
	'(' Expression ')'
	//| '(' error ')'
	;

ConstantExpression :
	Expression
	;

BooleanExpression :
	Expression
	;

ParenBooleanExpression :
	'(' BooleanExpression ')'
	//| '(' error ')'
	;

OptArrayInitializer :
	/*empty*/
	| ArrayInitializer
	;

ArrayInitializer :
	'{' OptVariableInitializerList '}'
	| '{' VariableInitializerList ',' '}'
	;

OptVariableInitializerList :
	/*empty*/
	| VariableInitializerList
	;

VariableInitializerList :
	VariableInitializer
	| VariableInitializerList ',' VariableInitializer
	;

VariableInitializer :
	Expression
	| ArrayInitializer
	;

OptComma :
	/*empty*/
	| ','
	;

Statement :
	Identifier ':' LineStatement
	| LocalVariableDeclaration ';'
	| LocalConstantDeclaration ';'
	| InnerEmbeddedStatement
	;

EmbeddedStatement :
	InnerEmbeddedStatement
	;

InnerEmbeddedStatement :
	Block
	| ';'
	| InnerExpressionStatement ';'
	| SelectionStatement
	| IterationStatement
	| JumpStatement
	| TryStatement
	| CHECKED /*13L*/ Block
	| UNCHECKED /*13L*/ Block
	| LockStatement
	| UsingStatement
	| FixedStatement
	| UNSAFE Block
	| YieldStatement
	//| error ';'
	;

LocalVariableDeclaration :
	LocalVariableType VariableDeclarators
	;

VariableDeclarators :
	VariableDeclarator
	| VariableDeclarators ',' VariableDeclarator
	;

VariableDeclarator :
	Identifier
	| Identifier '=' /*2R*/ VariableInitializer
	;

LocalConstantDeclaration :
	CONST Type ConstantDeclarators
	;

Block :
	'{' OptStatementList '}'
	//| '{' error '}'
	;

OptStatementList :
	/*empty*/
	| StatementList
	;

StatementList :
	LineStatement
	| StatementList LineStatement
	;

LineStatement :
	Statement
	;

ExpressionStatement :
	InnerExpressionStatement
	;

InnerExpressionStatement :
	InvocationExpression
	| ObjectCreationExpression
	| AssignmentExpression
	| PostIncrementExpression
	| PostDecrementExpression
	| PreIncrementExpression
	| PreDecrementExpression
	;

SelectionStatement :
	IF ParenBooleanExpression EmbeddedStatement
	| IF ParenBooleanExpression EmbeddedStatement ELSE EmbeddedStatement
	| SWITCH ParenExpression SwitchBlock
	;

SwitchBlock :
	'{' OptSwitchSections '}'
	//| '{' error '}'
	;

OptSwitchSections :
	/*empty*/
	| SwitchSections
	;

SwitchSections :
	SwitchSection
	| SwitchSections SwitchSection
	;

SwitchSection :
	SwitchLabels StatementList
	;

SwitchLabels :
	SwitchLabel
	| SwitchLabels SwitchLabel
	;

SwitchLabel :
	CASE ConstantExpression ':'
	| DEFAULT_LABEL
	;

IterationStatement :
	WHILE ParenBooleanExpression EmbeddedStatement
	| DO EmbeddedStatement WHILE ParenBooleanExpression ';'
	| FOR '(' ForInitializer ForCondition ForIterator EmbeddedStatement
	| FOREACH '(' Type Identifier IN ForeachExpression EmbeddedStatement
	;

ForInitializer :
	ForInitializerInner ';'
	| ';'
	//| error ';'
	;

ForInitializerInner :
	LocalVariableDeclaration
	| ExpressionStatementList
	;

ForCondition :
	BooleanExpression ';'
	| ';'
	//| error ';'
	;

ForIterator :
	ExpressionStatementList ')'
	| ')'
	//| error ')'
	;

ForeachExpression :
	Expression ')'
	//| error ')'
	;

ExpressionStatementList :
	ExpressionStatement
	| ExpressionStatementList ',' ExpressionStatement
	;

JumpStatement :
	BREAK ';'
	| CONTINUE ';'
	| GOTO Identifier ';'
	| GOTO CASE ConstantExpression ';'
	| GOTO DEFAULT ';'
	| RETURN ';'
	| RETURN Expression ';'
	| THROW ';'
	| THROW Expression ';'
	;

TryStatement :
	TRY Block CatchClauses
	| TRY Block FinallyClause
	| TRY Block CatchClauses FinallyClause
	;

CatchClauses :
	SpecificCatchClauses OptGeneralCatchClause
	| GeneralCatchClause
	;

SpecificCatchClauses :
	SpecificCatchClause
	| SpecificCatchClauses SpecificCatchClause
	;

SpecificCatchClause :
	CATCH CatchNameInfo Block
	;

CatchNameInfo :
	'(' Type Identifier ')'
	| '(' Type ')'
	//| '(' error ')'
	;

OptGeneralCatchClause :
	/*empty*/
	| GeneralCatchClause
	;

GeneralCatchClause :
	CATCH Block
	;

FinallyClause :
	FINALLY Block
	;

LockStatement :
	LOCK ParenExpression EmbeddedStatement
	;

UsingStatement :
	USING ResourceAcquisition EmbeddedStatement
	;

ResourceAcquisition :
	'(' LocalVariableType VariableDeclarators ')'
	| '(' Expression ')'
	//| '(' error ')'
	;

FixedStatement :
	FIXED '(' Type FixedPointerDeclarators ')' EmbeddedStatement
	;

FixedPointerDeclarators :
	FixedPointerDeclarator
	| FixedPointerDeclarators ',' FixedPointerDeclarator
	;

FixedPointerDeclarator :
	Identifier '=' /*2R*/ Expression
	;

YieldStatement :
	YIELD RETURN Expression ';'
	| YIELD BREAK ';'
	;

OptAttributes :
	/*empty*/
	| AttributeSections
	;

NonOptAttributes :
	AttributeSections
	;

AttributeSections :
	AttributeSection
	| AttributeSections AttributeSection
	;

AttributeSection :
	'[' AttributeList OptComma ']'
	| '[' AttributeTarget AttributeList OptComma ']'
	| DOC_COMMENT
	//| '[' error ']'
	;

AttributeTarget :
	QualifiedIdentifier ':'
	| EVENT ':'
	| RETURN ':'
	;

AttributeList :
	Attribute
	| AttributeList ',' Attribute
	;

Attribute :
	QualifiedIdentifier
	| QualifiedIdentifier AttributeArguments
	;

AttributeArguments :
	'(' ')'
	| '(' PositionalArgumentList ')'
	| '(' PositionalArgumentList ',' NamedArgumentList ')'
	| '(' NamedArgumentList ')'
	;

PositionalArgumentList :
	PositionalArgument
	| PositionalArgumentList ',' PositionalArgument
	;

PositionalArgument :
	AttributeArgumentExpression
	;

NamedArgumentList :
	NamedArgument
	| NamedArgumentList ',' NamedArgument
	;

NamedArgument :
	Identifier '=' /*2R*/ AttributeArgumentExpression
	;

AttributeArgumentExpression :
	Expression
	;

Modifiers :
	Modifier
	| Modifiers Modifier
	;

Modifier :
	NEW /*13L*/
	| PUBLIC
	| PROTECTED
	| INTERNAL
	| PRIVATE
	| ABSTRACT
	| SEALED
	| STATIC
	| READONLY
	| VIRTUAL
	| OVERRIDE
	| EXTERN
	| UNSAFE
	| VOLATILE
	;

OptAttributesAndModifiers :
	/*empty*/
	| AttributesAndModifiers
	;

AttributesAndModifiers :
	NonOptAttributes
	| Modifiers
	| NonOptAttributes Modifiers
	;

OptTypeDeclarationHeader :
	OptAttributesAndModifiers OptPartial
	;

ClassHeader :
	OptTypeDeclarationHeader CLASS Identifier ClassBase
	| OptTypeDeclarationHeader CLASS GenericIdentifierStart TypeFormals ClassBase OptTypeParameterConstraintsClauses
	;

ClassDeclaration :
	ClassHeader ClassBody OptSemiColon
	;

TypeFormals :
	TypeFormalList '>' /*8L*/
	//| error '>' /*8L*/
	;

TypeFormalList :
	OptAttributes IDENTIFIER
	| TypeFormalList ',' OptAttributes IDENTIFIER
	;

OptTypeParameterConstraintsClauses :
	/*empty*/
	| TypeParameterConstraintsClauses
	;

TypeParameterConstraintsClauses :
	TypeParameterConstraintsClause
	| TypeParameterConstraintsClauses TypeParameterConstraintsClause
	;

TypeParameterConstraintsClause :
	WHERE Identifier ':' TypeParameterConstraints
	;

TypeParameterConstraints :
	PrimaryConstraint
	| SecondaryConstraints
	| ConstructorConstraint
	| PrimaryConstraint ',' SecondaryConstraints
	| PrimaryConstraint ',' ConstructorConstraint
	| SecondaryConstraints ',' ConstructorConstraint
	| PrimaryConstraint ',' SecondaryConstraints ',' ConstructorConstraint
	;

SecondaryConstraints :
	Type
	| SecondaryConstraints ',' Type
	;

PrimaryConstraint :
	CLASS
	| STRUCT
	;

ConstructorConstraint :
	NEW /*13L*/ '(' ')'
	;

ModuleDeclaration :
	MODULE ClassBody OptSemiColon
	;

ClassBase :
	/*empty*/
	| ':' TypeList
	;

TypeList :
	Type
	| TypeList ',' Type
	;

ClassBody :
	'{' OptClassMemberDeclarations '}'
	//| '{' error '}'
	;

OptClassMemberDeclarations :
	/*empty*/
	| ClassMemberDeclarations
	;

ClassMemberDeclarations :
	ClassMemberDeclaration
	| ClassMemberDeclarations ClassMemberDeclaration
	;

ClassMemberDeclaration :
	ConstantDeclaration
	| FieldDeclaration
	| MethodDeclaration
	| PropertyDeclaration
	| EventDeclaration
	| IndexerDeclaration
	| OperatorDeclaration
	| ConstructorDeclaration
	| DestructorDeclaration
	| TypeDeclaration
	;

OptPartial :
	/*empty*/
	| PARTIAL
	;

MemberHeaderStart :
	OptAttributesAndModifiers Type
	;

NonGenericMethodAndPropertyHeaderStart :
	MemberHeaderStart NonGenericQualifiedIdentifier
	;

GenericMethodHeaderStart :
	MemberHeaderStart GenericQualifiedIdentifier
	;

ConstantDeclaration :
	OptAttributesAndModifiers CONST Type ConstantDeclarators ';'
	;

ConstantDeclarators :
	ConstantDeclarator
	| ConstantDeclarators ',' ConstantDeclarator
	;

ConstantDeclarator :
	Identifier '=' /*2R*/ ConstantExpression
	;

FieldDeclaration :
	MemberHeaderStart FieldDeclarators ';'
	;

FieldDeclarators :
	FieldDeclarator
	| FieldDeclarators ',' FieldDeclarator
	;

FieldDeclarator :
	Identifier
	| Identifier '=' /*2R*/ VariableInitializer
	;

MethodHeader :
	NonGenericMethodAndPropertyHeaderStart '(' OptFormalParameterList ')'
	| GenericMethodHeaderStart '(' OptFormalParameterList ')' OptTypeParameterConstraintsClauses
	;

MethodDeclaration :
	MethodHeader MethodBody
	;

MethodBody :
	Block
	| ';'
	;

OptFormalParameterList :
	/*empty*/
	| FormalParameterList
	;

FormalParameterList :
	FormalParameter
	| FormalParameterList ',' FormalParameter
	;

FormalParameter :
	OptAttributes ParameterModifier Type Identifier
	| ARGLIST
	;

ParameterModifier :
	/*empty*/
	| REF
	| OUT
	| PARAMS
	;

PropertyDeclaration :
	NonGenericMethodAndPropertyHeaderStart StartAccessorBlock AccessorBlock
	;

StartAccessorBlock :
	'{'
	;

AccessorBlock :
	AccessorDeclarations '}'
	//| error '}'
	;

AccessorDeclarations :
	GetAccessorDeclaration OptSetAccessorDeclaration
	| SetAccessorDeclaration OptGetAccessorDeclaration
	;

OptGetAccessorDeclaration :
	/*empty*/
	| GetAccessorDeclaration
	;

GetAccessorDeclaration :
	OptAttributesAndModifiers GET AccessorBody
	;

OptSetAccessorDeclaration :
	/*empty*/
	| SetAccessorDeclaration
	;

SetAccessorDeclaration :
	OptAttributesAndModifiers SET AccessorBody
	;

AccessorBody :
	Block
	| ';'
	;

EventDeclaration :
	EventFieldDeclaration
	| EventPropertyDeclaration
	;

EventFieldDeclaration :
	OptAttributesAndModifiers EVENT Type EventDeclarators ';'
	;

EventDeclarators :
	EventDeclarator
	| EventDeclarators ',' EventDeclarator
	;

EventDeclarator :
	Identifier
	| Identifier '=' /*2R*/ VariableInitializer
	;

EventPropertyDeclaration :
	OptAttributesAndModifiers EVENT Type QualifiedIdentifier StartAccessorBlock EventAccessorBlock
	;

EventAccessorBlock :
	EventAccessorDeclarations '}'
	//| error '}'
	;

EventAccessorDeclarations :
	AddAccessorDeclaration RemoveAccessorDeclaration
	| RemoveAccessorDeclaration AddAccessorDeclaration
	;

AddAccessorDeclaration :
	OptAttributes ADD AccessorBody
	;

RemoveAccessorDeclaration :
	OptAttributes REMOVE AccessorBody
	;

IndexerDeclaration :
	MemberHeaderStart IndexerDeclarator StartAccessorBlock AccessorBlock
	;

IndexerDeclarator :
	THIS FormalIndexParameters
	| QualifiedIdentifierMemberAccessStart THIS FormalIndexParameters
	;

FormalIndexParameters :
	'[' FormalIndexParameterList ']'
	//| '[' error ']'
	;

FormalIndexParameterList :
	FormalIndexParameter
	| FormalIndexParameterList ',' FormalIndexParameter
	;

FormalIndexParameter :
	OptAttributes ParameterModifier Type Identifier
	| ARGLIST
	;

OperatorDeclaration :
	NormalOperatorDeclaration
	| ConversionOperatorDeclaration
	;

NormalOperatorDeclaration :
	MemberHeaderStart OPERATOR OverloadableOperator '(' Type Identifier ')' Block
	| MemberHeaderStart OPERATOR OverloadableOperator '(' Type Identifier ',' Type Identifier ')' Block
	;

OverloadableOperator :
	'+' /*10L*/
	| '-' /*10L*/
	| '!' /*12L*/
	| '~' /*12L*/
	| INC_OP
	| DEC_OP
	| TRUE
	| FALSE
	| '*' /*11L*/
	| '/' /*11L*/
	| '%' /*11L*/
	| '&' /*6L*/
	| '|' /*5L*/
	| '^'
	| LEFT_OP /*9L*/
	| RightShift
	| EQ_OP /*7L*/
	| NE_OP /*7L*/
	| '>' /*8L*/
	| '<' /*8L*/
	| GE_OP /*8L*/
	| LE_OP /*8L*/
	;

ConversionOperatorDeclaration :
	OptAttributesAndModifiers IMPLICIT OPERATOR Type '(' Type Identifier ')' Block
	| OptAttributesAndModifiers EXPLICIT OPERATOR Type '(' Type Identifier ')' Block
	;

ConstructorDeclaration :
	OptAttributesAndModifiers Identifier '(' OptFormalParameterList ')' ConstructorInitializer MethodBody
	;

ConstructorInitializer :
	/*empty*/
	| ':' BASE '(' OptArgumentList ')'
	| ':' THIS '(' OptArgumentList ')'
	;

DestructorDeclaration :
	OptAttributesAndModifiers '~' /*12L*/ Identifier '(' ')' Block
	;

StructHeader :
	OptTypeDeclarationHeader STRUCT Identifier StructInterfaces
	| OptTypeDeclarationHeader STRUCT GenericIdentifierStart TypeFormals StructInterfaces OptTypeParameterConstraintsClauses
	;

StructDeclaration :
	StructHeader StructBody OptSemiColon
	;

StructInterfaces :
	/*empty*/
	| ':' TypeList
	;

StructBody :
	'{' OptClassMemberDeclarations '}'
	//| '{' error '}'
	;

InterfaceHeader :
	OptTypeDeclarationHeader INTERFACE Identifier InterfaceBase
	| OptTypeDeclarationHeader INTERFACE GenericIdentifierStart TypeFormals InterfaceBase OptTypeParameterConstraintsClauses
	;

InterfaceDeclaration :
	InterfaceHeader InterfaceBody OptSemiColon
	;

InterfaceBase :
	/*empty*/
	| ':' TypeList
	;

InterfaceBody :
	'{' OptInterfaceMemberDeclarations '}'
	//| '{' error '}'
	;

OptInterfaceMemberDeclarations :
	/*empty*/
	| InterfaceMemberDeclarations
	;

InterfaceMemberDeclarations :
	InterfaceMemberDeclaration
	| InterfaceMemberDeclarations InterfaceMemberDeclaration
	;

InterfaceMemberDeclaration :
	InterfaceMethodDeclaration
	| InterfacePropertyDeclaration
	| InterfaceEventDeclaration
	| InterfaceIndexerDeclaration
	;

InterfaceMethodHeader :
	OptAttributes OptNew Type Identifier '(' OptFormalParameterList ')'
	| OptAttributes OptNew Type GenericIdentifierStart TypeFormals '(' OptFormalParameterList ')' OptTypeParameterConstraintsClauses
	;

InterfaceMethodDeclaration :
	InterfaceMethodHeader ';'
	;

OptNew :
	/*empty*/
	| NEW /*13L*/
	;

InterfacePropertyDeclaration :
	OptAttributes OptNew Type Identifier StartInterfaceAccessorBody InterfaceAccessorBody
	;

StartInterfaceAccessorBody :
	'{'
	;

InterfaceAccessorBody :
	InterfaceAccessors '}'
	//| error '}'
	;

InterfaceAccessors :
	OptAttributes GET ';'
	| OptAttributes SET ';'
	| OptAttributes GET ';' OptAttributes SET ';'
	| OptAttributes SET ';' OptAttributes GET ';'
	;

InterfaceEventDeclaration :
	OptAttributes OptNew EVENT Type Identifier ';'
	;

InterfaceIndexerDeclaration :
	OptAttributes OptNew Type THIS FormalIndexParameters StartInterfaceAccessorBody InterfaceAccessorBody
	;

EnumDeclaration :
	OptAttributesAndModifiers ENUM Identifier EnumBase EnumBody OptSemiColon
	;

EnumBase :
	/*empty*/
	| ':' EnumBaseType
	;

EnumBaseType :
	BYTE
	| SBYTE
	| SHORT
	| USHORT
	| INT
	| UINT
	| LONG
	| ULONG
	;

EnumBody :
	'{' OptEnumMemberDeclarations '}'
	| '{' EnumMemberDeclarations ',' '}'
	//| '{' error '}'
	;

OptEnumMemberDeclarations :
	/*empty*/
	| EnumMemberDeclarations
	;

EnumMemberDeclarations :
	EnumMemberDeclaration
	| EnumMemberDeclarations ',' EnumMemberDeclaration
	;

EnumMemberDeclaration :
	OptAttributes Identifier
	| OptAttributes Identifier '=' /*2R*/ ConstantExpression
	;

DelegateHeader :
	OptAttributesAndModifiers DELEGATE Type Identifier '(' OptFormalParameterList ')'
	| OptAttributesAndModifiers DELEGATE Type GenericIdentifierStart TypeFormals '(' OptFormalParameterList ')' OptTypeParameterConstraintsClauses
	;

DelegateDeclaration :
	DelegateHeader ';'
	;

AnonymousMethod :
	Block
	| '(' OptFormalParameterList ')' Block
	;

%%

DIGIT			[0-9]
HEX				[a-fA-F0-9]
IDALPHA			([a-zA-Z_]|\\u{HEX}{HEX}{HEX}{HEX}|\\U{HEX}{HEX}{HEX}{HEX}{HEX}{HEX}{HEX}{HEX})
EXPONENT		[Ee][+-]?{DIGIT}+
FTYPE			(f|F|d|D|m|M)
ITYPE			(U|u|L|l|UL|Ul|uL|ul|LU|Lu|lU|lu)
WHITE			[ \t\r\f\v\032]

/* The following mess tries to determine if the characters that follow a
   "<" look like they may be part of a generic type reference.  This is
   to disambiguate "<" used as an operator or as a generic parameter start.
   Do not change this unless you know what you are doing */
GIDENT			{IDALPHA}({IDALPHA}|{DIGIT})*
GQUALIDENT		{GIDENT}({WHITE}*"."{WHITE}*{GIDENT})*
GTYPESUFFIX		({WHITE}*"["(",")*"]"|{WHITE}*"*")
GTYPE			{GQUALIDENT}{GTYPESUFFIX}*
GTYPELIST		{GTYPE}(","{WHITE}*{GTYPE})*
GENERICPREFIX	{WHITE}*{GTYPELIST}{WHITE}*("<"|">")

%%

"++"					INC_OP
"--"					DEC_OP
"<<"					LEFT_OP
"<="					LE_OP
">="					GE_OP
"=="					EQ_OP
"!="					NE_OP
"&&"					AND_OP
"||"					OR_OP
"*="					MUL_ASSIGN_OP
"/="					DIV_ASSIGN_OP
"%="					MOD_ASSIGN_OP
"+="					ADD_ASSIGN_OP
"-="					SUB_ASSIGN_OP
"<<="					LEFT_ASSIGN_OP
">>="					RIGHT_ASSIGN_OP
"&="					AND_ASSIGN_OP
"^="					XOR_ASSIGN_OP
"|="					OR_ASSIGN_OP
"->"					PTR_OP
"??"					NULL_COALESCING_OP
"::"					QUALIFIED_ALIAS_OP

"default"{WHITE}*":"	DEFAULT_LABEL

"abstract"				ABSTRACT
"add"					ADD
"__arglist"				ARGLIST
"as"					AS
"base"					BASE
"bool"					BOOL
"break"					BREAK
"__builtin_constant"	BUILTIN_CONSTANT
"byte"					BYTE
"case"					CASE
"catch"					CATCH
"char"					CHAR
"checked"				CHECKED
"class"					CLASS
"const"					CONST
"continue"				CONTINUE
"decimal"				DECIMAL
"default"				DEFAULT
"delegate"				DELEGATE
"do"					DO
"double"				DOUBLE
"else"					ELSE
"enum"					ENUM
"event"					EVENT
"explicit"				EXPLICIT
"extern"				EXTERN
"false"					FALSE
"finally"				FINALLY
"fixed"					FIXED
"float"					FLOAT
"for"					FOR
"foreach"				FOREACH
"get"					GET
"goto"					GOTO
"if"					IF
"implicit"				IMPLICIT
"in"					IN
"int"					INT
"interface"				INTERFACE
"internal"				INTERNAL
"is"					IS
"lock"					LOCK
"long"					LONG
"__long_double"			LONG_DOUBLE
"__makeref"				MAKEREF
"__module"				MODULE
"namespace"				NAMESPACE
"new"					NEW
"null"					NULL_TOK
"object"				OBJECT
"operator"				OPERATOR
"out"					OUT
"override"				OVERRIDE
"params"				PARAMS
"partial"				PARTIAL
"private"				PRIVATE
"protected"				PROTECTED
"public"				PUBLIC
"readonly"				READONLY
"ref"					REF
"__reftype"				REFTYPE
"__refvalue"			REFVALUE
"remove"				REMOVE
"return"				RETURN
"sbyte"					SBYTE
"sealed"				SEALED
"set"					SET
"short"					SHORT
"sizeof"				SIZEOF
"stackalloc"			STACKALLOC
"static"				STATIC
"string"				STRING
"struct"				STRUCT
"switch"				SWITCH
"this"					THIS
"throw"					THROW
"true"					TRUE
"try"					TRY
"typeof"				TYPEOF
"uint"					UINT
"ulong"					ULONG
"unchecked"				UNCHECKED
"unsafe"				UNSAFE
"ushort"				USHORT
"using"					USING
"virtual"				VIRTUAL
"void"					VOID
"volatile"				VOLATILE
"where"					WHERE
"while"					WHILE
"yield"					YIELD

"="	'='
"|"	'|'
"&"	'&'
"<"	'<'
">"	'>'
"+"	'+'
"-"	'-'
"*"	'*'
"/"	'/'
"%"	'%'
"!"	'!'
"~"	'~'
"."	'.'
"}"	'}'
";"	';'
"{"	'{'
"["	'['
"]"	']'
","	','
"("	'('
")"	')'
"^"	'^'
"?"	'?'
":"	':'
GT_OP	GT_OP
RIGHT_OP	RIGHT_OP
UN_PLUS	UN_PLUS
UN_MINUS	UN_MINUS
ADDRESS_OF	ADDRESS_OF
DECIMAL_CONSTANT	DECIMAL_CONSTANT
IDENTIFIER_OP	IDENTIFIER_OP

{IDALPHA}({DIGIT}|{IDALPHA})*		IDENTIFIER_LEXICAL
"@"{IDALPHA}({DIGIT}|{IDALPHA})*	IDENTIFIER_LEXICAL

{DIGIT}+{EXPONENT}{FTYPE}?					FLOAT_CONSTANT
{DIGIT}*"."{DIGIT}+({EXPONENT})?{FTYPE}?	FLOAT_CONSTANT
{DIGIT}+{FTYPE}								FLOAT_CONSTANT

0[xX]{HEX}+{ITYPE}?			INTEGER_CONSTANT
{DIGIT}+{ITYPE}?			INTEGER_CONSTANT

'(\\.|[^\\'])+'	CHAR_CONSTANT

\"(\\.|[^\\"])*\"			STRING_LITERAL
"@"\"(\"\"|[^"])*\"			STRING_LITERAL

{WHITE}+			skip()

\n					skip()

"///"[^\n]*\n		DOC_COMMENT

"//".*  skip()
"/*"(?s:.)*?"*/"    skip()

.					ILLEGAL_CHARACTER

%%
