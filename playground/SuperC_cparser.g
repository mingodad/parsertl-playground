//From: https://github.com/KIT-TVA/superc/blob/961120cdf4715b48d253d95e605494ae5ccea035/src/superc/cparser/parser.y
 /* Copyright (C) 1989,1990 James A. Roskind, All rights reserved.
     This grammar was developed  and  written  by  James  A.  Roskind.
     Copying  of  this  grammar  description, as a whole, is permitted
     providing this notice is intact and applicable  in  all  complete
     copies.   Translations as a whole to other parser generator input
     languages  (or  grammar  description  languages)   is   permitted
     provided  that  this  notice is intact and applicable in all such
     copies,  along  with  a  disclaimer  that  the  contents  are   a
     translation.   The reproduction of derived text, such as modified
     versions of this grammar, or the output of parser generators,  is
     permitted,  provided  the  resulting  work includes the copyright
     notice "Portions Copyright (c)  1989,  1990  James  A.  Roskind".
     Derived products, such as compilers, translators, browsers, etc.,
     that  use  this  grammar,  must also provide the notice "Portions
     Copyright  (c)  1989,  1990  James  A.  Roskind"  in   a   manner
     appropriate  to  the  utility,  and in keeping with copyright law
     (e.g.: EITHER displayed when first invoked/executed; OR displayed
     continuously on display terminal; OR via placement in the  object
     code  in  form  readable in a printout, with or near the title of
     the work, or at the end of the file).  No royalties, licenses  or
     commissions  of  any  kind are required to copy this grammar, its
     translations, or derivative products, when the copies are made in
     compliance with this notice. Persons or corporations that do make
     copies in compliance with this notice may charge  whatever  price
     is  agreeable  to  a  buyer, for such copies or derivative works.
     THIS GRAMMAR IS PROVIDED ``AS IS'' AND  WITHOUT  ANY  EXPRESS  OR
     IMPLIED  WARRANTIES,  INCLUDING,  WITHOUT LIMITATION, THE IMPLIED
     WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS  FOR  A  PARTICULAR
     PURPOSE.

     James A. Roskind
     Independent Consultant
     516 Latania Palm Drive
     Indialantic FL, 32903
     (407)729-4348
     jar@ileaf.com

     Modifications for GCC Extensions Copyright (C) 2009-2012 New York
     University
 */

/**
 * Definition of C's complete syntactic unit syntax.
 *
 * @version $Revision: 1.12 $
 */

/*Tokens*/
%token __ALIGNOF
%token __ALIGNOF__
%token AND
%token ANDAND
%token ANDassign
%token ARROW
%token ASM
%token __ASM
%token __ASM__
%token ASMSYM
%token ASSIGN
//%token AT
%token __ATTRIBUTE
%token __ATTRIBUTE__
%token AUTO
//%token BACKSLASH
%token _BOOL
%token BREAK
%token __BUILTIN_OFFSETOF
%token __BUILTIN_TYPES_COMPATIBLE_P
%token __BUILTIN_VA_ARG
%token __BUILTIN_VA_LIST
%token CASE
%token CHAR
%token CHARACTERconstant
%token COLON
%token COMMA
%token _COMPLEX
%token __COMPLEX__
%token CONST
%token __CONST
%token __CONST__
%token CONTINUE
%token DECR
%token DEFAULT
//%token DHASH
%token DIV
%token DIVassign
%token DO
%token DOT
%token DOUBLE
%token ELLIPSIS
%token ELSE
%token ENUM
%token EQ
%token ERassign
%token __EXTENSION__
%token EXTERN
%token FLOAT
%token FLOATINGconstant
%token FOR
%token GE
%token GOTO
%token GT
//%token HASH
%token HEXconstant
%token ICR
%token IDENTIFIER
%token IF
%token INLINE
%token __INLINE
%token __INLINE__
%token INT
%token __INT128
%token INTEGERconstant
%token __LABEL__
%token LBRACE
%token LBRACK
%token LE
%token LONG
%token LPAREN
%token LS
%token LSassign
%token LT
%token MINUS
%token MINUSassign
%token MOD
%token MODassign
%token MULTassign
%token NE
%token NEGATE
%token NOT
%token OCTALconstant
%token ORassign
%token OROR
%token PIPE
%token PLUS
%token PLUSassign
//%token PPNUM
%token QUESTION
%token RBRACE
%token RBRACK
%token REGISTER
%token RESTRICT
%token __RESTRICT
%token __RESTRICT__
%token RETURN
%token RPAREN
%token RS
%token RSassign
%token SEMICOLON
%token SHORT
%token SIGNED
%token __SIGNED
%token __SIGNED__
%token SIZEOF
%token STAR
%token STATIC
%token STRINGliteral
%token STRUCT
%token SWITCH
%token __THREAD
%token TYPEDEF
%token TYPEDEFname
%token TYPEOF
%token __TYPEOF
%token __TYPEOF__
%token UNION
%token UNSIGNED
//%token USD
%token VOID
%token VOLATILE
%token __VOLATILE
%token __VOLATILE__
%token WHILE
%token XOR


%start TranslationUnit

%%

TranslationUnit :
	ExternalDeclarationList
	;

ExternalDeclarationList :
	/*empty*/
	| ExternalDeclarationList ExternalDeclaration
	;

ExternalDeclaration :
	FunctionDefinitionExtension
	| DeclarationExtension
	| AssemblyDefinition
	| EmptyDefinition
	;

EmptyDefinition :
	SEMICOLON
	;

FunctionDefinitionExtension :
	FunctionDefinition
	| __EXTENSION__ FunctionDefinition
	;

FunctionDefinition :
	FunctionPrototype LBRACE FunctionCompoundStatement RBRACE
	| FunctionOldPrototype DeclarationList LBRACE FunctionCompoundStatement RBRACE
	;

FunctionCompoundStatement :
	LocalLabelDeclarationListOpt DeclarationOrStatementList
	;

FunctionPrototype :
	IdentifierDeclarator
	| DeclarationSpecifier IdentifierDeclarator
	| TypeSpecifier IdentifierDeclarator
	| DeclarationQualifierList IdentifierDeclarator
	| TypeQualifierList IdentifierDeclarator
	| OldFunctionDeclarator
	| DeclarationSpecifier OldFunctionDeclarator
	| TypeSpecifier OldFunctionDeclarator
	| DeclarationQualifierList OldFunctionDeclarator
	| TypeQualifierList OldFunctionDeclarator
	;

FunctionOldPrototype :
	OldFunctionDeclarator
	| DeclarationSpecifier OldFunctionDeclarator
	| TypeSpecifier OldFunctionDeclarator
	| DeclarationQualifierList OldFunctionDeclarator
	| TypeQualifierList OldFunctionDeclarator
	;

NestedFunctionDefinition :
	NestedFunctionPrototype LBRACE LocalLabelDeclarationListOpt DeclarationOrStatementList RBRACE
	| NestedFunctionOldPrototype DeclarationList LBRACE LocalLabelDeclarationListOpt DeclarationOrStatementList RBRACE
	;

NestedFunctionPrototype :
	DeclarationSpecifier IdentifierDeclarator
	| TypeSpecifier IdentifierDeclarator
	| DeclarationQualifierList IdentifierDeclarator
	| TypeQualifierList IdentifierDeclarator
	| DeclarationSpecifier OldFunctionDeclarator
	| TypeSpecifier OldFunctionDeclarator
	| DeclarationQualifierList OldFunctionDeclarator
	| TypeQualifierList OldFunctionDeclarator
	;

NestedFunctionOldPrototype :
	DeclarationSpecifier OldFunctionDeclarator
	| TypeSpecifier OldFunctionDeclarator
	| DeclarationQualifierList OldFunctionDeclarator
	| TypeQualifierList OldFunctionDeclarator
	;

DeclarationExtension :
	Declaration
	| __EXTENSION__ Declaration
	;

Declaration :
	SUEDeclarationSpecifier SEMICOLON
	| SUETypeSpecifier SEMICOLON
	| DeclaringList SEMICOLON
	| DefaultDeclaringList SEMICOLON
	;

DefaultDeclaringList :
	DeclarationQualifierList IdentifierDeclarator AssemblyExpressionOpt AttributeSpecifierListOpt InitializerOpt
	| TypeQualifierList IdentifierDeclarator AssemblyExpressionOpt AttributeSpecifierListOpt InitializerOpt
	| DefaultDeclaringList COMMA AttributeSpecifierListOpt IdentifierDeclarator AssemblyExpressionOpt AttributeSpecifierListOpt InitializerOpt
	;

DeclaringList :
	DeclarationSpecifier Declarator AssemblyExpressionOpt AttributeSpecifierListOpt InitializerOpt
	| TypeSpecifier Declarator AssemblyExpressionOpt AttributeSpecifierListOpt InitializerOpt
	| DeclaringList COMMA AttributeSpecifierListOpt Declarator AssemblyExpressionOpt AttributeSpecifierListOpt InitializerOpt
	;

DeclarationSpecifier :
	BasicDeclarationSpecifier
	| SUEDeclarationSpecifier
	| TypedefDeclarationSpecifier
	| VarArgDeclarationSpecifier
	| TypeofDeclarationSpecifier
	;

TypeSpecifier :
	BasicTypeSpecifier
	| SUETypeSpecifier
	| TypedefTypeSpecifier
	| VarArgTypeSpecifier
	| TypeofTypeSpecifier
	;

DeclarationQualifierList :
	StorageClass
	| TypeQualifierList StorageClass
	| DeclarationQualifierList DeclarationQualifier
	;

TypeQualifierList :
	TypeQualifier
	| TypeQualifierList TypeQualifier
	;

DeclarationQualifier :
	TypeQualifier
	| StorageClass
	;

TypeQualifier :
	ConstQualifier
	| VolatileQualifier
	| RestrictQualifier
	| AttributeSpecifier
	| FunctionSpecifier
	;

ConstQualifier :
	CONST
	| __CONST
	| __CONST__
	;

VolatileQualifier :
	VOLATILE
	| __VOLATILE
	| __VOLATILE__
	;

RestrictQualifier :
	RESTRICT
	| __RESTRICT
	| __RESTRICT__
	;

FunctionSpecifier :
	INLINE
	| __INLINE
	| __INLINE__
	;

BasicDeclarationSpecifier :
	BasicTypeSpecifier StorageClass
	| DeclarationQualifierList BasicTypeName
	| BasicDeclarationSpecifier DeclarationQualifier
	| BasicDeclarationSpecifier BasicTypeName
	;

BasicTypeSpecifier :
	BasicTypeName
	| TypeQualifierList BasicTypeName
	| BasicTypeSpecifier TypeQualifier
	| BasicTypeSpecifier BasicTypeName
	;

SUEDeclarationSpecifier :
	SUETypeSpecifier StorageClass
	| DeclarationQualifierList ElaboratedTypeName
	| SUEDeclarationSpecifier DeclarationQualifier
	;

SUETypeSpecifier :
	ElaboratedTypeName
	| TypeQualifierList ElaboratedTypeName
	| SUETypeSpecifier TypeQualifier
	;

TypedefDeclarationSpecifier :
	TypedefTypeSpecifier StorageClass
	| DeclarationQualifierList TYPEDEFname
	| TypedefDeclarationSpecifier DeclarationQualifier
	;

TypedefTypeSpecifier :
	TYPEDEFname
	| TypeQualifierList TYPEDEFname
	| TypedefTypeSpecifier TypeQualifier
	;

TypeofDeclarationSpecifier :
	TypeofTypeSpecifier StorageClass
	| DeclarationQualifierList Typeofspecifier
	| TypeofDeclarationSpecifier DeclarationQualifier
	| TypeofDeclarationSpecifier Typeofspecifier
	;

TypeofTypeSpecifier :
	Typeofspecifier
	| TypeQualifierList Typeofspecifier
	| TypeofTypeSpecifier TypeQualifier
	| TypeofTypeSpecifier Typeofspecifier
	;

Typeofspecifier :
	Typeofkeyword LPAREN TypeName RPAREN
	| Typeofkeyword LPAREN Expression RPAREN
	;

Typeofkeyword :
	TYPEOF
	| __TYPEOF
	| __TYPEOF__
	;

VarArgDeclarationSpecifier :
	VarArgTypeSpecifier StorageClass
	| DeclarationQualifierList VarArgTypeName
	| VarArgDeclarationSpecifier DeclarationQualifier
	| VarArgDeclarationSpecifier VarArgTypeName
	;

VarArgTypeSpecifier :
	VarArgTypeName
	| TypeQualifierList VarArgTypeName
	| VarArgTypeSpecifier TypeQualifier
	| VarArgTypeSpecifier VarArgTypeName
	;

VarArgTypeName :
	__BUILTIN_VA_LIST
	;

StorageClass :
	TYPEDEF
	| EXTERN
	| STATIC
	| AUTO
	| REGISTER
	;

BasicTypeName :
	VOID
	| CHAR
	| SHORT
	| INT
	| __INT128
	| LONG
	| FLOAT
	| DOUBLE
	| SignedKeyword
	| UNSIGNED
	| _BOOL
	| ComplexKeyword
	;

SignedKeyword :
	SIGNED
	| __SIGNED
	| __SIGNED__
	;

ComplexKeyword :
	_COMPLEX
	| __COMPLEX__
	;

ElaboratedTypeName :
	StructSpecifier
	| UnionSpecifier
	| EnumSpecifier
	;

StructSpecifier :
	STRUCT LBRACE StructDeclarationList RBRACE
	| STRUCT IdentifierOrTypedefName LBRACE StructDeclarationList RBRACE
	| STRUCT IdentifierOrTypedefName
	| STRUCT AttributeSpecifierList LBRACE StructDeclarationList RBRACE
	| STRUCT AttributeSpecifierList IdentifierOrTypedefName LBRACE StructDeclarationList RBRACE
	| STRUCT AttributeSpecifierList IdentifierOrTypedefName
	;

UnionSpecifier :
	UNION LBRACE StructDeclarationList RBRACE
	| UNION IdentifierOrTypedefName LBRACE StructDeclarationList RBRACE
	| UNION IdentifierOrTypedefName
	| UNION AttributeSpecifierList LBRACE StructDeclarationList RBRACE
	| UNION AttributeSpecifierList IdentifierOrTypedefName LBRACE StructDeclarationList RBRACE
	| UNION AttributeSpecifierList IdentifierOrTypedefName
	;

StructDeclarationList :
	/*empty*/
	| StructDeclarationList StructDeclarationExtension
	;

StructDeclarationExtension :
	StructDeclaration
	| __EXTENSION__ StructDeclaration
	;

StructDeclaration :
	StructDeclaringList SEMICOLON
	| StructDefaultDeclaringList SEMICOLON
	| TypeQualifierList SEMICOLON
	| TypeSpecifier SEMICOLON
	| SEMICOLON
	;

StructDefaultDeclaringList :
	TypeQualifierList StructIdentifierDeclarator AttributeSpecifierListOpt
	| StructDefaultDeclaringList COMMA StructIdentifierDeclarator AttributeSpecifierListOpt
	;

StructDeclaringList :
	TypeSpecifier StructDeclarator AttributeSpecifierListOpt
	| StructDeclaringList COMMA StructDeclarator AttributeSpecifierListOpt
	;

StructDeclarator :
	Declarator BitFieldSizeOpt
	| BitFieldSize
	;

StructIdentifierDeclarator :
	IdentifierDeclarator BitFieldSizeOpt
	| BitFieldSize
	;

BitFieldSizeOpt :
	/*empty*/
	| BitFieldSize
	;

BitFieldSize :
	COLON ConstantExpression
	;

EnumSpecifier :
	ENUM LBRACE EnumeratorList RBRACE
	| ENUM IdentifierOrTypedefName LBRACE EnumeratorList RBRACE
	| ENUM IdentifierOrTypedefName
	| ENUM LBRACE EnumeratorList COMMA RBRACE
	| ENUM IdentifierOrTypedefName LBRACE EnumeratorList COMMA RBRACE
	| ENUM AttributeSpecifierList LBRACE EnumeratorList RBRACE
	| ENUM AttributeSpecifierList IdentifierOrTypedefName LBRACE EnumeratorList RBRACE
	| ENUM AttributeSpecifierList IdentifierOrTypedefName
	| ENUM AttributeSpecifierList LBRACE EnumeratorList COMMA RBRACE
	| ENUM AttributeSpecifierList IdentifierOrTypedefName LBRACE EnumeratorList COMMA RBRACE
	;

EnumeratorList :
	Enumerator
	| EnumeratorList COMMA Enumerator
	;

Enumerator :
	IDENTIFIER EnumeratorValueOpt
	| TYPEDEFname EnumeratorValueOpt
	;

EnumeratorValueOpt :
	/*empty*/
	| ASSIGN ConstantExpression
	;

ParameterTypeList :
	ParameterList
	| ParameterList COMMA ELLIPSIS
	;

ParameterList :
	ParameterDeclaration
	| ParameterList COMMA ParameterDeclaration
	;

ParameterDeclaration :
	ParameterIdentifierDeclaration
	| ParameterAbstractDeclaration
	;

ParameterAbstractDeclaration :
	DeclarationSpecifier
	| DeclarationSpecifier AbstractDeclarator
	| DeclarationQualifierList
	| DeclarationQualifierList AbstractDeclarator
	| TypeSpecifier
	| TypeSpecifier AbstractDeclarator
	| TypeQualifierList
	| TypeQualifierList AbstractDeclarator
	;

ParameterIdentifierDeclaration :
	DeclarationSpecifier IdentifierDeclarator AttributeSpecifierListOpt
	| DeclarationSpecifier ParameterTypedefDeclarator AttributeSpecifierListOpt
	| DeclarationQualifierList IdentifierDeclarator AttributeSpecifierListOpt
	| TypeSpecifier IdentifierDeclarator AttributeSpecifierListOpt
	| TypeSpecifier ParameterTypedefDeclarator AttributeSpecifierListOpt
	| TypeQualifierList IdentifierDeclarator AttributeSpecifierListOpt
	;

IdentifierList :
	Identifier
	| IdentifierList COMMA Identifier
	;

Identifier :
	IDENTIFIER
	;

IdentifierOrTypedefName :
	IDENTIFIER
	| TYPEDEFname
	;

TypeName :
	TypeSpecifier
	| TypeSpecifier AbstractDeclarator
	| TypeQualifierList
	| TypeQualifierList AbstractDeclarator
	;

InitializerOpt :
	/*empty*/
	| ASSIGN Initializer
	;

Initializer :
	LBRACE MatchedInitializerList RBRACE
	| LBRACE MatchedInitializerList DesignatedInitializer RBRACE
	| AssignmentExpression
	;

InitializerList :
	MatchedInitializerList
	| MatchedInitializerList DesignatedInitializer
	;

MatchedInitializerList :
	/*empty*/
	| MatchedInitializerList DesignatedInitializer COMMA
	;

DesignatedInitializer :
	Initializer
	| Designation Initializer
	;

Designation :
	DesignatorList ASSIGN
	| ObsoleteArrayDesignation
	| ObsoleteFieldDesignation
	;

DesignatorList :
	Designator
	| DesignatorList Designator
	;

Designator :
	LBRACK ConstantExpression RBRACK
	| LBRACK ConstantExpression ELLIPSIS ConstantExpression RBRACK
	| DOT IDENTIFIER
	| DOT TYPEDEFname
	;

ObsoleteArrayDesignation :
	LBRACK ConstantExpression RBRACK
	| LBRACK ConstantExpression ELLIPSIS ConstantExpression RBRACK
	;

ObsoleteFieldDesignation :
	IDENTIFIER COLON
	;

Declarator :
	TypedefDeclarator
	| IdentifierDeclarator
	;

TypedefDeclarator :
	TypedefDeclaratorMain
	;

TypedefDeclaratorMain :
	ParenTypedefDeclarator
	| ParameterTypedefDeclarator
	;

ParameterTypedefDeclarator :
	TYPEDEFname
	| TYPEDEFname PostfixingAbstractDeclarator
	| CleanTypedefDeclarator
	;

CleanTypedefDeclarator :
	CleanPostfixTypedefDeclarator
	| STAR ParameterTypedefDeclarator
	| STAR TypeQualifierList ParameterTypedefDeclarator
	;

CleanPostfixTypedefDeclarator :
	LPAREN CleanTypedefDeclarator RPAREN
	| LPAREN CleanTypedefDeclarator RPAREN PostfixingAbstractDeclarator
	;

ParenTypedefDeclarator :
	ParenPostfixTypedefDeclarator
	| STAR LPAREN SimpleParenTypedefDeclarator RPAREN
	| STAR TypeQualifierList LPAREN SimpleParenTypedefDeclarator RPAREN
	| STAR ParenTypedefDeclarator
	| STAR TypeQualifierList ParenTypedefDeclarator
	;

ParenPostfixTypedefDeclarator :
	LPAREN ParenTypedefDeclarator RPAREN
	| LPAREN SimpleParenTypedefDeclarator PostfixingAbstractDeclarator RPAREN
	| LPAREN ParenTypedefDeclarator RPAREN PostfixingAbstractDeclarator
	;

SimpleParenTypedefDeclarator :
	TYPEDEFname
	| LPAREN SimpleParenTypedefDeclarator RPAREN
	;

IdentifierDeclarator :
	IdentifierDeclaratorMain
	;

IdentifierDeclaratorMain :
	UnaryIdentifierDeclarator
	| ParenIdentifierDeclarator
	;

UnaryIdentifierDeclarator :
	PostfixIdentifierDeclarator
	| STAR IdentifierDeclarator
	| STAR TypeQualifierList IdentifierDeclarator
	;

PostfixIdentifierDeclarator :
	FunctionDeclarator
	| ArrayDeclarator
	| AttributedDeclarator
	| LPAREN UnaryIdentifierDeclarator RPAREN PostfixingAbstractDeclarator
	;

AttributedDeclarator :
	LPAREN UnaryIdentifierDeclarator RPAREN
	;

FunctionDeclarator :
	ParenIdentifierDeclarator PostfixingFunctionDeclarator
	;

PostfixingFunctionDeclarator :
	LPAREN ParameterTypeListOpt RPAREN
	;

ArrayDeclarator :
	ParenIdentifierDeclarator ArrayAbstractDeclarator
	;

ParenIdentifierDeclarator :
	SimpleDeclarator
	| LPAREN ParenIdentifierDeclarator RPAREN
	;

SimpleDeclarator :
	IDENTIFIER
	;

OldFunctionDeclarator :
	PostfixOldFunctionDeclarator
	| STAR OldFunctionDeclarator
	| STAR TypeQualifierList OldFunctionDeclarator
	;

PostfixOldFunctionDeclarator :
	ParenIdentifierDeclarator LPAREN IdentifierList RPAREN
	| LPAREN OldFunctionDeclarator RPAREN
	| LPAREN OldFunctionDeclarator RPAREN PostfixingAbstractDeclarator
	;

AbstractDeclarator :
	UnaryAbstractDeclarator
	| PostfixAbstractDeclarator
	| PostfixingAbstractDeclarator
	;

PostfixingAbstractDeclarator :
	ArrayAbstractDeclarator
	| PostfixingFunctionDeclarator
	;

ParameterTypeListOpt :
	/*empty*/
	| ParameterTypeList
	;

ArrayAbstractDeclarator :
	LBRACK RBRACK
	| LBRACK ConstantExpression RBRACK
	| ArrayAbstractDeclarator LBRACK ConstantExpression RBRACK
	;

UnaryAbstractDeclarator :
	STAR
	| STAR TypeQualifierList
	| STAR AbstractDeclarator
	| STAR TypeQualifierList AbstractDeclarator
	;

PostfixAbstractDeclarator :
	LPAREN UnaryAbstractDeclarator RPAREN
	| LPAREN PostfixAbstractDeclarator RPAREN
	| LPAREN PostfixingAbstractDeclarator RPAREN
	| LPAREN UnaryAbstractDeclarator RPAREN PostfixingAbstractDeclarator
	;

Statement :
	LabeledStatement
	| CompoundStatement
	| ExpressionStatement
	| SelectionStatement
	| IterationStatement
	| JumpStatement
	| AssemblyStatement
	;

LabeledStatement :
	IdentifierOrTypedefName COLON AttributeSpecifierListOpt Statement
	| CASE ConstantExpression COLON Statement
	| CASE ConstantExpression ELLIPSIS ConstantExpression COLON Statement
	| DEFAULT COLON Statement
	;

CompoundStatement :
	LBRACE LocalLabelDeclarationListOpt DeclarationOrStatementList RBRACE
	;

LocalLabelDeclarationListOpt :
	/*empty*/
	| LocalLabelDeclarationList
	;

LocalLabelDeclarationList :
	LocalLabelDeclaration
	| LocalLabelDeclarationList LocalLabelDeclaration
	;

LocalLabelDeclaration :
	__LABEL__ LocalLabelList SEMICOLON
	;

LocalLabelList :
	IDENTIFIER
	| LocalLabelList COMMA IDENTIFIER
	;

DeclarationOrStatementList :
	/*empty*/
	| DeclarationOrStatementList DeclarationOrStatement
	;

DeclarationOrStatement :
	DeclarationExtension
	| Statement
	| NestedFunctionDefinition
	;

DeclarationList :
	DeclarationExtension
	| DeclarationList DeclarationExtension
	;

ExpressionStatement :
	ExpressionOpt SEMICOLON
	;

SelectionStatement :
	IF LPAREN Expression RPAREN Statement
	| IF LPAREN Expression RPAREN Statement ELSE Statement
	| SWITCH LPAREN Expression RPAREN Statement
	;

IterationStatement :
	WHILE LPAREN Expression RPAREN Statement
	| DO Statement WHILE LPAREN Expression RPAREN SEMICOLON
	| FOR LPAREN ExpressionOpt SEMICOLON ExpressionOpt SEMICOLON ExpressionOpt RPAREN Statement
	| FOR LPAREN Declaration ExpressionOpt SEMICOLON ExpressionOpt RPAREN Statement
	;

JumpStatement :
	GotoStatement
	| ContinueStatement
	| BreakStatement
	| ReturnStatement
	;

GotoStatement :
	GOTO IdentifierOrTypedefName SEMICOLON
	| GOTO STAR Expression SEMICOLON
	;

ContinueStatement :
	CONTINUE SEMICOLON
	;

BreakStatement :
	BREAK SEMICOLON
	;

ReturnStatement :
	RETURN ExpressionOpt SEMICOLON
	;

Constant :
	FLOATINGconstant
	| INTEGERconstant
	| OCTALconstant
	| HEXconstant
	| CHARACTERconstant
	;

StringLiteralList :
	STRINGliteral
	| StringLiteralList STRINGliteral
	;

PrimaryExpression :
	PrimaryIdentifier
	| Constant
	| StringLiteralList
	| LPAREN Expression RPAREN
	| StatementAsExpression
	| VariableArgumentAccess
	;

PrimaryIdentifier :
	IDENTIFIER
	;

VariableArgumentAccess :
	__BUILTIN_VA_ARG LPAREN AssignmentExpression COMMA TypeName RPAREN
	;

StatementAsExpression :
	LPAREN CompoundStatement RPAREN
	;

PostfixExpression :
	PrimaryExpression
	| Subscript
	| FunctionCall
	| DirectSelection
	| IndirectSelection
	| Increment
	| Decrement
	| CompoundLiteral
	;

Subscript :
	PostfixExpression LBRACK Expression RBRACK
	;

FunctionCall :
	PostfixExpression LPAREN RPAREN
	| PostfixExpression LPAREN ExpressionList RPAREN
	;

DirectSelection :
	PostfixExpression DOT IdentifierOrTypedefName
	;

IndirectSelection :
	PostfixExpression ARROW IdentifierOrTypedefName
	;

Increment :
	PostfixExpression ICR
	;

Decrement :
	PostfixExpression DECR
	;

CompoundLiteral :
	LPAREN TypeName RPAREN LBRACE InitializerList RBRACE
	;

ExpressionList :
	AssignmentExpression
	| ExpressionList COMMA AssignmentExpression
	;

UnaryExpression :
	PostfixExpression
	| ICR UnaryExpression
	| DECR UnaryExpression
	| Unaryoperator CastExpression
	| SIZEOF UnaryExpression
	| SIZEOF LPAREN TypeName RPAREN
	| LabelAddressExpression
	| AlignofExpression
	| ExtensionExpression
	| OffsetofExpression
	| TypeCompatibilityExpression
	;

TypeCompatibilityExpression :
	__BUILTIN_TYPES_COMPATIBLE_P LPAREN TypeName COMMA TypeName RPAREN
	;

OffsetofExpression :
	__BUILTIN_OFFSETOF LPAREN TypeName COMMA PostfixExpression RPAREN
	;

ExtensionExpression :
	__EXTENSION__ CastExpression
	;

AlignofExpression :
	Alignofkeyword LPAREN TypeName RPAREN
	| Alignofkeyword UnaryExpression
	;

Alignofkeyword :
	__ALIGNOF__
	| __ALIGNOF
	;

LabelAddressExpression :
	ANDAND IDENTIFIER
	;

Unaryoperator :
	AND
	| STAR
	| PLUS
	| MINUS
	| NEGATE
	| NOT
	;

CastExpression :
	UnaryExpression
	| LPAREN TypeName RPAREN CastExpression
	;

MultiplicativeExpression :
	CastExpression
	| MultiplicativeExpression STAR CastExpression
	| MultiplicativeExpression DIV CastExpression
	| MultiplicativeExpression MOD CastExpression
	;

AdditiveExpression :
	MultiplicativeExpression
	| AdditiveExpression PLUS MultiplicativeExpression
	| AdditiveExpression MINUS MultiplicativeExpression
	;

ShiftExpression :
	AdditiveExpression
	| ShiftExpression LS AdditiveExpression
	| ShiftExpression RS AdditiveExpression
	;

RelationalExpression :
	ShiftExpression
	| RelationalExpression LT ShiftExpression
	| RelationalExpression GT ShiftExpression
	| RelationalExpression LE ShiftExpression
	| RelationalExpression GE ShiftExpression
	;

EqualityExpression :
	RelationalExpression
	| EqualityExpression EQ RelationalExpression
	| EqualityExpression NE RelationalExpression
	;

AndExpression :
	EqualityExpression
	| AndExpression AND EqualityExpression
	;

ExclusiveOrExpression :
	AndExpression
	| ExclusiveOrExpression XOR AndExpression
	;

InclusiveOrExpression :
	ExclusiveOrExpression
	| InclusiveOrExpression PIPE ExclusiveOrExpression
	;

LogicalAndExpression :
	InclusiveOrExpression
	| LogicalAndExpression ANDAND InclusiveOrExpression
	;

LogicalORExpression :
	LogicalAndExpression
	| LogicalORExpression OROR LogicalAndExpression
	;

ConditionalExpression :
	LogicalORExpression
	| LogicalORExpression QUESTION Expression COLON ConditionalExpression
	| LogicalORExpression QUESTION COLON ConditionalExpression
	;

AssignmentExpression :
	ConditionalExpression
	| UnaryExpression AssignmentOperator AssignmentExpression
	;

AssignmentOperator :
	ASSIGN
	| MULTassign
	| DIVassign
	| MODassign
	| PLUSassign
	| MINUSassign
	| LSassign
	| RSassign
	| ANDassign
	| ERassign
	| ORassign
	;

ExpressionOpt :
	/*empty*/
	| Expression
	;

Expression :
	AssignmentExpression
	| Expression COMMA AssignmentExpression
	;

ConstantExpression :
	ConditionalExpression
	;

AttributeSpecifierListOpt :
	/*empty*/
	| AttributeSpecifierList
	;

AttributeSpecifierList :
	AttributeSpecifier
	| AttributeSpecifierList AttributeSpecifier
	;

AttributeSpecifier :
	AttributeKeyword LPAREN LPAREN AttributeListOpt RPAREN RPAREN
	;

AttributeKeyword :
	__ATTRIBUTE
	| __ATTRIBUTE__
	;

AttributeListOpt :
	/*empty*/
	| AttributeList
	;

AttributeList :
	Word AttributeExpressionOpt
	| AttributeList COMMA Word AttributeExpressionOpt
	;

AttributeExpressionOpt :
	/*empty*/
	| LPAREN RPAREN
	| LPAREN ExpressionList RPAREN
	;

Word :
	IDENTIFIER
	| AUTO
	| DOUBLE
	| INT
	| STRUCT
	| BREAK
	| ELSE
	| LONG
	| SWITCH
	| CASE
	| ENUM
	| REGISTER
	| TYPEDEF
	| CHAR
	| EXTERN
	| RETURN
	| UNION
	| CONST
	| FLOAT
	| SHORT
	| UNSIGNED
	| CONTINUE
	| FOR
	| SIGNED
	| VOID
	| DEFAULT
	| GOTO
	| SIZEOF
	| VOLATILE
	| DO
	| IF
	| STATIC
	| WHILE
	| ASMSYM
	| _BOOL
	| _COMPLEX
	| RESTRICT
	| __ALIGNOF
	| __ALIGNOF__
	| ASM
	| __ASM
	| __ASM__
	| __ATTRIBUTE
	| __ATTRIBUTE__
	| __BUILTIN_OFFSETOF
	| __BUILTIN_TYPES_COMPATIBLE_P
	| __BUILTIN_VA_ARG
	| __BUILTIN_VA_LIST
	| __COMPLEX__
	| __CONST
	| __CONST__
	| __EXTENSION__
	| INLINE
	| __INLINE
	| __INLINE__
	| __LABEL__
	| __RESTRICT
	| __RESTRICT__
	| __SIGNED
	| __SIGNED__
	| __THREAD
	| TYPEOF
	| __TYPEOF
	| __TYPEOF__
	| __VOLATILE
	| __VOLATILE__
	;

AssemblyDefinition :
	AssemblyExpression SEMICOLON
	;

AssemblyExpression :
	AsmKeyword LPAREN StringLiteralList RPAREN
	;

AssemblyExpressionOpt :
	/*empty*/
	| AssemblyExpression
	;

AssemblyStatement :
	AsmKeyword LPAREN Assemblyargument RPAREN SEMICOLON
	| AsmKeyword GOTO LPAREN AssemblyGotoargument RPAREN SEMICOLON
	| AsmKeyword TypeQualifier LPAREN Assemblyargument RPAREN SEMICOLON
	;

Assemblyargument :
	StringLiteralList COLON AssemblyoperandsOpt COLON AssemblyoperandsOpt COLON Assemblyclobbers
	| StringLiteralList COLON AssemblyoperandsOpt COLON AssemblyoperandsOpt
	| StringLiteralList COLON AssemblyoperandsOpt
	| StringLiteralList
	;

AssemblyoperandsOpt :
	/*empty*/
	| Assemblyoperands
	;

Assemblyoperands :
	Assemblyoperand
	| Assemblyoperands COMMA Assemblyoperand
	;

Assemblyoperand :
	StringLiteralList LPAREN Expression RPAREN
	| LBRACK Word RBRACK StringLiteralList LPAREN Expression RPAREN
	;

AssemblyclobbersOpt :
	/*empty*/
	| Assemblyclobbers
	;

Assemblyclobbers :
	StringLiteralList
	| Assemblyclobbers COMMA StringLiteralList
	;

AssemblyGotoargument :
	StringLiteralList COLON AssemblyoperandsOpt COLON AssemblyoperandsOpt COLON AssemblyclobbersOpt COLON AssemblyJumpLabels
	;

AssemblyJumpLabels :
	Identifier
	| AssemblyJumpLabels COMMA Identifier
	;

AsmKeyword :
	ASM
	| __ASM
	| __ASM__
	;

%%

identifier [a-zA-Z_][0-9a-zA-Z_]*

/* Define floating point number constants. */
exponent_part ([eE]|[pP])[-+]?[0-9]+
fractional_constant ([0-9]*"."[0-9]+)|([0-9]+".")
floating_constant (({fractional_constant}{exponent_part}?)|([0-9]+{exponent_part}))[FfLl]?

/* Define a catch-all for preprocessor numbers.  These may not
necessarily be valid C numeric constants, but they are valid
preprocessor numbers. */
preprocessing_number "."?[0-9]+([0-9a-zA-Z._]|{exponent_part})*

/* Define numeric constants. */
integer_suffix_opt ([uU]?[lL]?)|([lL][uU])|([uU]("ll"|"LL"))|(("ll"|"LL")[uU]|"LL"|"ll"|"UU"|"uu")
integer_constant [1-9][0-9]*{integer_suffix_opt}
octal_constant "0"[0-7]*{integer_suffix_opt}
hex_constant "0"[xX][0-9a-fA-F]+{integer_suffix_opt}

/* Define escape sequences. */
simple_escape [abefnrtv\'\"?\\@]
octal_escape [0-7]{1,3}
hex_escape "x"[0-9a-fA-F]+
escape_sequence [\\]({simple_escape}|{octal_escape}|{hex_escape})

/* Define character and string literals.  A single character in
literals is a normal character (without newlines or quotes), an escape
sequence, or a line continuation.  The continuation is preserved to
preserve layout.  */
c_char [^\'\\\n]|{escape_sequence}|\\\n
s_char [^\"\\\n]|{escape_sequence}|\\\n


// Define whitespace characters.
h_tab [\011]
form_feed [\014]
v_tab [\013]
c_return [\015]
horizontal_white [ ]|{h_tab}
newline \r|\n|\r\n
//comment [/][*]([^*/]|[^*][/]|[*][^/])*[*][/]
linecomment "//"[^\r\n]*{newline}
continuation "\\\n"
whitespace ({horizontal_white})+|({v_tab}|{c_return})+|{continuation}

//whitespace ({horizontal_white})+|({v_tab}|{c_return}|{form_feed})+|{continuation}
//whitespace ({horizontal_white})+|({v_tab}|{c_return}|{form_feed})+|{continuation}|{comment}
//whitespace ({horizontal_white})+|({v_tab}|{c_return}|{form_feed})+|({horizontal_white}|{v_tab}|{c_return}|{form_feed})*"\n"|{continuation}|{comment}

%%

{whitespace}	skip()
{newline}   skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"auto"	AUTO
"break"	BREAK
"case"	CASE
"char"	CHAR
"const"	CONST
"continue"	CONTINUE
"default"	DEFAULT
"do"	DO
"double"	DOUBLE
"else"	ELSE
"enum"	ENUM
"extern"	EXTERN
"float"	FLOAT
"for"	FOR
"goto"	GOTO
"if"	IF
"int"	INT
"long"	LONG
"register"	REGISTER
"return"	RETURN
"short"	SHORT
"signed"	SIGNED
"sizeof"	SIZEOF
"static"	STATIC
"struct"	STRUCT
"switch"	SWITCH
"typedef"	TYPEDEF
"union"	UNION
"unsigned"	UNSIGNED
"void"	VOID
"volatile"	VOLATILE
"while"	WHILE

//C99 keywords used by the default gnu89 dialect
"_Bool"	_BOOL
"_Complex"	_COMPLEX
"inline"	INLINE

// "restrict"	RESTRICT // A C99 keyword not used in gnu89.

//GCC
"__alignof"	__ALIGNOF
"__alignof__"	__ALIGNOF__
"asm"	ASM
"__asm"	__ASM
"__asm__"	__ASM__
ASMSYM	ASMSYM
"__attribute"	__ATTRIBUTE
"__attribute__"	__ATTRIBUTE__
"__builtin_offsetof"	__BUILTIN_OFFSETOF
"__builtin_types_compatible_p"	__BUILTIN_TYPES_COMPATIBLE_P
"__builtin_va_arg"	__BUILTIN_VA_ARG
"__builtin_va_list"	__BUILTIN_VA_LIST
"__complex__"	__COMPLEX__
"__const"	__CONST
"__const__"	__CONST__
"__extension__"	__EXTENSION__
"__inline"	__INLINE
"__inline__"	__INLINE__
"__label__"	__LABEL__
RESTRICT	RESTRICT
"__restrict"	__RESTRICT
"__restrict__"	__RESTRICT__
"__signed"	__SIGNED
"__signed__"	__SIGNED__
"__thread"	__THREAD
"typeof"	TYPEOF
"__typeof"	__TYPEOF
"__typeof__"	__TYPEOF__
"__volatile"	__VOLATILE
"__volatile__"	__VOLATILE__
"__int128"	__INT128

TYPEDEFname	TYPEDEFname
{identifier}	IDENTIFIER
{integer_constant}	INTEGERconstant
{octal_constant}	OCTALconstant
{hex_constant}	HEXconstant
{floating_constant}	FLOATINGconstant
//{preprocessing_number}	PPNUM

/* The \' doesn't mesh with the function-like invocation.  Returns an
error that there is an unmatched ' in the parameter-list.  Circumvent
the issue by putting the offending regular expression in a macro.  */

"L"?\'{c_char}+\'	CHARACTERconstant
"L"?\"{s_char}*\"	STRINGliteral

"->"	ARROW
"++"	ICR
"--"	DECR
"<<"	LS
">>"	RS
"<="	LE
">="	GE
"=="	EQ
"!="	NE
"&&"	ANDAND
"||"	OROR
"+="	PLUSassign
"-="	MINUSassign
"*="	MULTassign
"/="	DIVassign
"%="	MODassign
"<<="	LSassign
">>="	RSassign
"&="	ANDassign
"^="	ERassign
"|="	ORassign

"("	LPAREN
")"	RPAREN
","	COMMA
//"#"	HASH
//"##"	DHASH
"..."	ELLIPSIS

"{"	LBRACE
"}"	RBRACE
"["	LBRACK
"]"	RBRACK
"."	DOT
"&"	AND
"*"	STAR
"+"	PLUS
"-"	MINUS
"~"	NEGATE
"!"	NOT
"/"	DIV
"%"	MOD
"<"	LT
">"	GT
"^"	XOR
"|"	PIPE
"?"	QUESTION
":"	COLON
";"	SEMICOLON
"="	ASSIGN

//"@"	AT
//"$"	USD
//BACKSLASH, "\\"

// For c++
//".*"	DOTSTAR
//"::"	DCOLON
//"->*"	ARROWSTAR

%%
