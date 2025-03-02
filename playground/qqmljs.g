//From: https://github.com/qt/qtdeclarative/blob/cf264057cc51e6d8415f8f3bb9d63b15348a2140/src/qml/parser/qqmljs.g
/*
// Copyright (C) 2016 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only

%parser         QQmlJSGrammar
%decl           qqmljsparser_p.h
%impl           qqmljsparser.cpp
%expect         1
*/

%token T_AND T_AND_AND T_AND_EQ T_BREAK T_CASE T_CATCH T_COMMA T_CONTINUE
%token T_DEFAULT T_DELETE T_DIVIDE_ T_DIVIDE_EQ T_DO T_DOT T_EQ T_EQ_EQ
%token T_EQ_EQ_EQ T_FINALLY T_FOR T_FUNCTION T_GE T_GT T_GT_GT T_GT_GT_EQ
%token T_GT_GT_GT T_GT_GT_GT_EQ T_IF T_IN T_INSTANCEOF T_LBRACE
%token T_LBRACKET T_LE T_LPAREN T_LT T_LT_LT T_LT_LT_EQ T_MINUS T_MINUS_EQ
%token T_MINUS_MINUS T_NEW T_NOT T_NOT_EQ T_NOT_EQ_EQ T_NUMERIC_LITERAL
%token T_OR T_VERSION_NUMBER T_OR_EQ T_OR_OR T_PLUS T_PLUS_EQ T_PLUS_PLUS
%token T_QUESTION T_RBRACE T_RBRACKET T_REMAINDER T_REMAINDER_EQ
%token T_RETURN T_RPAREN T_SEMICOLON T_AUTOMATIC_SEMICOLON T_STAR
%token T_STAR_STAR T_STAR_STAR_EQ T_STAR_EQ T_STRING_LITERAL T_SWITCH
%token T_THIS T_THROW T_TILDE T_TRY T_TYPEOF T_VAR T_VOID T_WHILE
%token T_WITH T_XOR T_XOR_EQ T_NULL T_TRUE T_FALSE T_CONST T_LET T_AT
%token T_DEBUGGER T_RESERVED_WORD T_MULTILINE_STRING_LITERAL
%token T_COMPATIBILITY_SEMICOLON T_ARROW T_QUESTION_QUESTION
%token T_QUESTION_DOT T_ENUM T_ELLIPSIS T_YIELD T_SUPER T_CLASS
%token T_EXTENDS T_EXPORT T_NO_SUBSTITUTION_TEMPLATE T_TEMPLATE_HEAD
%token T_TEMPLATE_MIDDLE T_TEMPLATE_TAIL T_IMPORT T_PRAGMA T_FEED_UI_PROGRAM
%token T_FEED_UI_OBJECT_MEMBER T_FEED_JS_STATEMENT T_FEED_JS_EXPRESSION
%token T_FEED_JS_SCRIPT T_FEED_JS_MODULE T_FORCE_DECLARATION
%token T_FORCE_BLOCK
%nonassoc T_COLON T_IDENTIFIER T_PROPERTY T_SIGNAL T_READONLY T_STATIC T_FROM T_REQUIRED T_COMPONENT T_OF T_GET T_SET T_ON
%nonassoc REDUCE_HERE
%right T_ELSE
%right T_AS T_WITHOUTAS

%start TopLevel

%%

TopLevel:
	  T_FEED_UI_PROGRAM UiProgram
	| T_FEED_JS_STATEMENT Statement
	| T_FEED_JS_EXPRESSION Expression
	| T_FEED_UI_OBJECT_MEMBER UiAnnotatedObjectMember
	| T_FEED_JS_SCRIPT Script
	| T_FEED_JS_MODULE Module
	| UiProgram
	;

UiProgram:
	  UiHeaderItemListOpt UiRootMember
	;

UiHeaderItemListOpt:
	  Empty
	| UiHeaderItemList
	;

UiHeaderItemList:
	  UiPragma
	| UiImport
	| UiHeaderItemList UiPragma
	| UiHeaderItemList UiImport
	;

PragmaId:
	  JsIdentifier
	;

PragmaValue:
	  JsIdentifier
	| T_STRING_LITERAL
	;

Semicolon:
	  T_AUTOMATIC_SEMICOLON
	| T_SEMICOLON
	;

UiPragmaValueList:
	  PragmaValue
	| UiPragmaValueList T_COMMA PragmaValue
	;

UiPragma:
	  T_PRAGMA PragmaId Semicolon
	| T_PRAGMA PragmaId T_COLON UiPragmaValueList Semicolon
	;

ImportId:
	  MemberExpression
	;

UiImport:
	  UiImportHead Semicolon
	| UiImportHead UiVersionSpecifier Semicolon
	| UiImportHead UiVersionSpecifier T_AS QmlIdentifier Semicolon
	| UiImportHead T_AS QmlIdentifier Semicolon
	;

UiVersionSpecifier:
	  T_VERSION_NUMBER T_DOT T_VERSION_NUMBER
	| T_VERSION_NUMBER
	;

UiImportHead:
	  T_IMPORT ImportId
	;

Empty:
	  %empty
	;

UiRootMember:
	  UiAnnotatedObject
	;

UiSimpleQualifiedId:
	  T_IDENTIFIER
	| UiSimpleQualifiedId T_DOT T_IDENTIFIER
	;

UiAnnotationObjectDefinition:
	  UiSimpleQualifiedId UiObjectInitializer
	;

UiAnnotation:
	  T_AT UiAnnotationObjectDefinition
	;

UiAnnotationList:
	  UiAnnotation
	| UiAnnotationList UiAnnotation
	;

UiAnnotatedObject:
	  UiAnnotationList UiObjectDefinition
	| UiObjectDefinition
	;

UiObjectMemberList:
	  UiAnnotatedObjectMember
	| UiObjectMemberList UiAnnotatedObjectMember
	;

UiArrayMemberList:
	  UiObjectDefinition
	| UiArrayMemberList T_COMMA UiObjectDefinition
	;

UiObjectInitializer:
	  T_LBRACE T_RBRACE
	| T_LBRACE UiObjectMemberList T_RBRACE
	;

UiObjectDefinition:
	  UiQualifiedId UiObjectInitializer
	;

UiAnnotatedObjectMember:
	  UiAnnotationList UiObjectMember
	| UiObjectMember
	;

UiObjectMember:
	  UiObjectDefinition
	| UiQualifiedId T_COLON ExpressionStatementLookahead T_LBRACKET UiArrayMemberList T_RBRACKET
	| UiQualifiedId T_COLON ExpressionStatementLookahead UiQualifiedId UiObjectInitializer
	| UiQualifiedId T_ON UiQualifiedId UiObjectInitializer
	| UiQualifiedId T_COLON UiScriptStatement
	| UiQualifiedId Semicolon
	| T_SIGNAL T_IDENTIFIER T_LPAREN UiParameterListOpt T_RPAREN Semicolon
	| T_SIGNAL T_IDENTIFIER Semicolon
	| UiObjectMemberListPropertyNoInitialiser
	| UiObjectMemberPropertyNoInitialiser
	| UiRequired
	| UiObjectMemberWithScriptStatement
	| UiObjectMemberWithArray
	| UiObjectMemberExpressionStatementLookahead
	| GeneratorDeclaration
	| FunctionDeclarationWithTypes
	| VariableStatement
	| T_ENUM T_IDENTIFIER T_LBRACE EnumMemberList T_RBRACE
	| T_COMPONENT T_IDENTIFIER T_COLON UiObjectDefinition
	;

UiObjectLiteral:
	  T_LBRACE ExpressionStatementLookahead UiPropertyDefinitionList T_RBRACE Semicolon
	| T_LBRACE ExpressionStatementLookahead UiPropertyDefinitionList T_COMMA T_RBRACE Semicolon
	;

UiScriptStatement:
	  ExpressionStatementLookahead T_FORCE_DECLARATION ExpressionStatement
	| ExpressionStatementLookahead T_FORCE_BLOCK Block
	| ExpressionStatementLookahead T_FORCE_BLOCK UiObjectLiteral
	| ExpressionStatementLookahead EmptyStatement
	| ExpressionStatementLookahead ExpressionStatement
	| ExpressionStatementLookahead IfStatement
	| ExpressionStatementLookahead WithStatement
	| ExpressionStatementLookahead SwitchStatement
	| ExpressionStatementLookahead TryStatement
	;

UiPropertyType:
	  T_VAR
	| T_RESERVED_WORD
	| T_IDENTIFIER
	| UiPropertyType T_DOT T_IDENTIFIER
	;

UiParameterListOpt:
	  %empty
	| UiParameterList
	;

UiParameterList:
	  QmlIdentifier T_COLON Type
	| Type QmlIdentifier
	| UiParameterList T_COMMA QmlIdentifier T_COLON Type
	| UiParameterList T_COMMA Type QmlIdentifier
	;

AttrRequired:
	  T_REQUIRED %prec REDUCE_HERE
	;

AttrReadonly:
	  T_READONLY %prec REDUCE_HERE
	;

AttrDefault:
	  T_DEFAULT %prec REDUCE_HERE
	;

UiPropertyAttributes:
	  AttrRequired UiPropertyAttributes
	| AttrDefault UiPropertyAttributes
	| AttrReadonly UiPropertyAttributes
	| T_PROPERTY
	;

UiObjectMemberListPropertyNoInitialiser:
	  UiPropertyAttributes T_IDENTIFIER T_LT UiPropertyType T_GT QmlIdentifier Semicolon
	;

UiObjectMemberPropertyNoInitialiser:
	  UiPropertyAttributes UiPropertyType QmlIdentifier Semicolon
	;

OptionalSemicolon:
	  %empty
	| Semicolon
	;

UiRequired:
	  T_REQUIRED QmlIdentifier Semicolon
	;

UiObjectMemberWithScriptStatement:
	  UiPropertyAttributes UiPropertyType QmlIdentifier T_COLON UiScriptStatement OptionalSemicolon
	| UiPropertyAttributes T_IDENTIFIER T_LT UiPropertyType T_GT QmlIdentifier T_COLON UiScriptStatement OptionalSemicolon
	;

UiObjectMemberWithArray:
	  UiPropertyAttributes T_IDENTIFIER T_LT UiPropertyType T_GT QmlIdentifier T_COLON ExpressionStatementLookahead T_LBRACKET UiArrayMemberList T_RBRACKET Semicolon
	;

UiObjectMemberExpressionStatementLookahead:
	  UiPropertyAttributes UiPropertyType QmlIdentifier T_COLON ExpressionStatementLookahead UiQualifiedId UiObjectInitializer Semicolon
	;

UiQualifiedId:
	  MemberExpression
	;

EnumMemberList:
	  T_IDENTIFIER
	| T_IDENTIFIER T_EQ T_NUMERIC_LITERAL
	| T_IDENTIFIER T_EQ T_MINUS T_NUMERIC_LITERAL
	| EnumMemberList T_COMMA T_IDENTIFIER
	| EnumMemberList T_COMMA T_IDENTIFIER T_EQ T_NUMERIC_LITERAL
	| EnumMemberList T_COMMA T_IDENTIFIER T_EQ T_MINUS T_NUMERIC_LITERAL
	;

QmlIdentifier:
	  T_IDENTIFIER
	| T_PROPERTY
	| T_SIGNAL
	| T_READONLY
	| T_ON
	| T_GET
	| T_SET
	| T_FROM
	| T_OF
	| T_REQUIRED
	| T_COMPONENT
	;

JsIdentifier:
	  T_IDENTIFIER
	| T_PROPERTY
	| T_SIGNAL
	| T_READONLY
	| T_ON
	| T_GET
	| T_SET
	| T_FROM
	| T_STATIC
	| T_OF
	| T_AS
	| T_REQUIRED
	| T_COMPONENT
	;

IdentifierReference:
	  JsIdentifier
	;

BindingIdentifier:
	  IdentifierReference
	;

Type:
	  UiQualifiedId T_LT SimpleType T_GT
	| SimpleType
	;

SimpleType:
	  T_RESERVED_WORD
	| UiQualifiedId
	| T_VAR
	| T_VOID
	;

TypeAnnotation:
	  T_COLON Type
	;

TypeAnnotationOpt:
	  TypeAnnotation
	| %empty
	;

PrimaryExpression:
	  T_THIS
	| IdentifierReference
	| Literal
	| ArrayLiteral
	| ObjectLiteral
	| FunctionExpression
	| ClassExpression
	| GeneratorExpression
	| RegularExpressionLiteral
	| TemplateLiteral
	| CoverParenthesizedExpressionAndArrowParameterList
	;

CoverParenthesizedExpressionAndArrowParameterList:
	  T_LPAREN Expression_In T_RPAREN
	| T_LPAREN T_RPAREN
	| T_LPAREN BindingRestElement T_RPAREN
	| T_LPAREN Expression_In T_COMMA BindingRestElementOpt T_RPAREN
	;

Literal:
	  T_NULL
	| T_TRUE
	| T_FALSE
	| T_NUMERIC_LITERAL
	| T_MULTILINE_STRING_LITERAL
	| T_STRING_LITERAL
	;

RegularExpressionLiteral:
	  T_DIVIDE_
	| T_DIVIDE_EQ
	;

ArrayLiteral:
	  T_LBRACKET ElisionOpt T_RBRACKET
	| T_LBRACKET ElementList T_RBRACKET
	| T_LBRACKET ElementList T_COMMA ElisionOpt T_RBRACKET
	;

ElementList:
	  AssignmentExpression_In
	| Elision AssignmentExpression_In
	| ElisionOpt SpreadElement
	| ElementList T_COMMA ElisionOpt AssignmentExpression_In
	| ElementList T_COMMA ElisionOpt SpreadElement
	;

Elision:
	  T_COMMA
	| Elision T_COMMA
	;

ElisionOpt:
	  %empty
	| Elision
	;

SpreadElement:
	  T_ELLIPSIS AssignmentExpression
	;

ObjectLiteral:
	  T_LBRACE T_RBRACE
	| T_LBRACE PropertyDefinitionList T_RBRACE
	| T_LBRACE PropertyDefinitionList T_COMMA T_RBRACE
	;

UiPropertyDefinitionList:
	  UiPropertyDefinition
	| UiPropertyDefinitionList T_COMMA UiPropertyDefinition
	;

PropertyDefinitionList:
	  PropertyDefinition
	| PropertyDefinitionList T_COMMA PropertyDefinition
	;

PropertyDefinition:
	  IdentifierReference
	| CoverInitializedName
	| PropertyName T_COLON AssignmentExpression_In
	| MethodDefinition
	;

CoverInitializedName:
	  IdentifierReference Initializer_In
	;

UiPropertyDefinition:
	  UiPropertyName T_COLON AssignmentExpression_In
	;

PropertyName:
	  LiteralPropertyName
	| ComputedPropertyName
	;

LiteralPropertyName:
	  IdentifierName
	| T_STRING_LITERAL
	| T_NUMERIC_LITERAL
	;

UiPropertyName:
	  T_STRING_LITERAL
	| T_NUMERIC_LITERAL
	;

IdentifierName:
	  IdentifierReference
	| ReservedIdentifier
	;

ReservedIdentifier:
	  T_BREAK
	| T_CASE
	| T_CATCH
	| T_CONTINUE
	| T_DEFAULT
	| T_DELETE
	| T_DO
	| T_ELSE
	| T_ENUM
	| T_FALSE
	| T_FINALLY
	| T_FOR
	| T_FUNCTION
	| T_IF
	| T_IN
	| T_INSTANCEOF
	| T_NEW
	| T_NULL
	| T_RETURN
	| T_SWITCH
	| T_THIS
	| T_THROW
	| T_TRUE
	| T_TRY
	| T_TYPEOF
	| T_VAR
	| T_VOID
	| T_WHILE
	| T_CONST
	| T_LET
	| T_DEBUGGER
	| T_RESERVED_WORD
	| T_SUPER
	| T_WITH
	| T_CLASS
	| T_EXTENDS
	| T_EXPORT
	| T_IMPORT
	;

ComputedPropertyName:
	  T_LBRACKET AssignmentExpression_In T_RBRACKET
	;

Initializer:
	  T_EQ AssignmentExpression
	;

Initializer_In:
	  T_EQ AssignmentExpression_In
	;

InitializerOpt:
	  %empty
	| Initializer
	;

InitializerOpt_In:
	  %empty
	| Initializer_In
	;

TemplateLiteral:
	  T_NO_SUBSTITUTION_TEMPLATE
	| T_TEMPLATE_HEAD Expression TemplateSpans
	;

TemplateSpans:
	  T_TEMPLATE_TAIL
	| T_TEMPLATE_MIDDLE Expression TemplateSpans
	;

MemberExpression:
	  PrimaryExpression
	| Super T_LBRACKET Expression_In T_RBRACKET
	| MemberExpression T_LBRACKET Expression_In T_RBRACKET
	| MemberExpression T_QUESTION_DOT T_LBRACKET Expression_In T_RBRACKET
	| Super T_DOT IdentifierName
	| MemberExpression T_DOT IdentifierName
	| MemberExpression T_QUESTION_DOT IdentifierName
	| MetaProperty
	| T_NEW MemberExpression T_LPAREN Arguments T_RPAREN
	| MemberExpression TemplateLiteral
	;

Super:
	  T_SUPER
	;

NewTarget:
	  T_NEW T_DOT T_IDENTIFIER
	;

MetaProperty:
	  NewTarget
	;

NewExpression:
	  MemberExpression
	| T_NEW NewExpression
	;

CallExpression:
	  CallExpression TemplateLiteral
	| MemberExpression T_LPAREN Arguments T_RPAREN
	| MemberExpression T_QUESTION_DOT T_LPAREN Arguments T_RPAREN
	| Super T_LPAREN Arguments T_RPAREN
	| CallExpression T_LPAREN Arguments T_RPAREN
	| CallExpression T_QUESTION_DOT T_LPAREN Arguments T_RPAREN
	| CallExpression T_LBRACKET Expression_In T_RBRACKET
	| CallExpression T_QUESTION_DOT T_LBRACKET Expression_In T_RBRACKET
	| CallExpression T_DOT IdentifierName
	| CallExpression T_QUESTION_DOT IdentifierName
	;

Arguments:
	  %empty
	| ArgumentList
	| ArgumentList T_COMMA
	;

ArgumentList:
	  AssignmentExpression_In
	| T_ELLIPSIS AssignmentExpression_In
	| ArgumentList T_COMMA AssignmentExpression_In
	| ArgumentList T_COMMA T_ELLIPSIS AssignmentExpression_In
	;

LeftHandSideExpression:
	  NewExpression
	| CallExpression
	;

UpdateExpression:
	  LeftHandSideExpression
	| LeftHandSideExpression T_PLUS_PLUS
	| LeftHandSideExpression T_MINUS_MINUS
	| T_PLUS_PLUS UnaryExpression
	| T_MINUS_MINUS UnaryExpression
	;

UnaryExpression:
	  UpdateExpression
	| T_DELETE UnaryExpression
	| T_VOID UnaryExpression
	| T_TYPEOF UnaryExpression
	| T_PLUS UnaryExpression
	| T_MINUS UnaryExpression
	| T_TILDE UnaryExpression
	| T_NOT UnaryExpression
	;

ExponentiationExpression:
	  UnaryExpression
	| UpdateExpression T_STAR_STAR ExponentiationExpression
	;

MultiplicativeExpression:
	  ExponentiationExpression
	| MultiplicativeExpression MultiplicativeOperator ExponentiationExpression
	;

MultiplicativeOperator:
	  T_STAR
	| T_DIVIDE_
	| T_REMAINDER
	;

AdditiveExpression:
	  MultiplicativeExpression
	| AdditiveExpression T_PLUS MultiplicativeExpression
	| AdditiveExpression T_MINUS MultiplicativeExpression
	;

ShiftExpression:
	  AdditiveExpression
	| ShiftExpression T_LT_LT AdditiveExpression
	| ShiftExpression T_GT_GT AdditiveExpression
	| ShiftExpression T_GT_GT_GT AdditiveExpression
	;

RelationalExpression_In:
	  ShiftExpression
	| RelationalExpression_In RelationalOperator ShiftExpression
	| RelationalExpression_In T_IN ShiftExpression
	;

RelationalExpression:
	  ShiftExpression
	| RelationalExpression RelationalOperator ShiftExpression
	;

RelationalOperator:
	  T_LT
	| T_GT
	| T_LE
	| T_GE
	| T_INSTANCEOF
	| T_AS
	;

EqualityExpression_In:
	  RelationalExpression_In
	| EqualityExpression_In EqualityOperator RelationalExpression_In
	;

EqualityExpression:
	  RelationalExpression
	| EqualityExpression EqualityOperator RelationalExpression
	;

EqualityOperator:
	  T_EQ_EQ
	| T_NOT_EQ
	| T_EQ_EQ_EQ
	| T_NOT_EQ_EQ
	;

BitwiseANDExpression:
	  EqualityExpression
	| BitwiseANDExpression T_AND EqualityExpression
	;

BitwiseANDExpression_In:
	  EqualityExpression_In
	| BitwiseANDExpression_In T_AND EqualityExpression_In
	;

BitwiseXORExpression:
	  BitwiseANDExpression
	| BitwiseXORExpression T_XOR BitwiseANDExpression
	;

BitwiseXORExpression_In:
	  BitwiseANDExpression_In
	| BitwiseXORExpression_In T_XOR BitwiseANDExpression_In
	;

BitwiseORExpression:
	  BitwiseXORExpression
	| BitwiseORExpression T_OR BitwiseXORExpression
	;

BitwiseORExpression_In:
	  BitwiseXORExpression_In
	| BitwiseORExpression_In T_OR BitwiseXORExpression_In
	;

LogicalANDExpression:
	  BitwiseORExpression
	| LogicalANDExpression T_AND_AND BitwiseORExpression
	;

LogicalANDExpression_In:
	  BitwiseORExpression_In
	| LogicalANDExpression_In T_AND_AND BitwiseORExpression_In
	;

LogicalORExpression:
	  LogicalANDExpression
	| LogicalORExpression T_OR_OR LogicalANDExpression
	;

LogicalORExpression_In:
	  LogicalANDExpression_In
	| LogicalORExpression_In T_OR_OR LogicalANDExpression_In
	;

CoalesceExpression:
	  LogicalORExpression
	| CoalesceExpression T_QUESTION_QUESTION LogicalORExpression
	;

CoalesceExpression_In:
	  LogicalORExpression_In
	| CoalesceExpression_In T_QUESTION_QUESTION LogicalORExpression_In
	;

ConditionalExpression:
	  CoalesceExpression
	| CoalesceExpression T_QUESTION AssignmentExpression_In T_COLON AssignmentExpression
	;

ConditionalExpression_In:
	  CoalesceExpression_In
	| CoalesceExpression_In T_QUESTION AssignmentExpression_In T_COLON AssignmentExpression_In
	;

AssignmentExpression:
	  ConditionalExpression
	| YieldExpression
	| ArrowFunction
	| LeftHandSideExpression T_EQ AssignmentExpression
	| LeftHandSideExpression AssignmentOperator AssignmentExpression
	;

AssignmentExpression_In:
	  ConditionalExpression_In
	| YieldExpression_In
	| ArrowFunction_In
	| LeftHandSideExpression T_EQ AssignmentExpression_In
	| LeftHandSideExpression AssignmentOperator AssignmentExpression_In
	;

AssignmentOperator:
	  T_STAR_EQ
	| T_STAR_STAR_EQ
	| T_DIVIDE_EQ
	| T_REMAINDER_EQ
	| T_PLUS_EQ
	| T_MINUS_EQ
	| T_LT_LT_EQ
	| T_GT_GT_EQ
	| T_GT_GT_GT_EQ
	| T_AND_EQ
	| T_XOR_EQ
	| T_OR_EQ
	;

Expression:
	  AssignmentExpression
	| Expression T_COMMA AssignmentExpression
	;

Expression_In:
	  AssignmentExpression_In
	| Expression_In T_COMMA AssignmentExpression_In
	;

ExpressionOpt:
	  %empty
	| Expression
	;

ExpressionOpt_In:
	  %empty
	| Expression_In
	;

Statement:
	  ExpressionStatementLookahead T_FORCE_BLOCK BlockStatement
	| ExpressionStatementLookahead VariableStatement
	| ExpressionStatementLookahead EmptyStatement
	| ExpressionStatementLookahead ExpressionStatement
	| ExpressionStatementLookahead IfStatement
	| ExpressionStatementLookahead BreakableStatement
	| ExpressionStatementLookahead ContinueStatement
	| ExpressionStatementLookahead BreakStatement
	| ExpressionStatementLookahead ReturnStatement
	| ExpressionStatementLookahead WithStatement
	| ExpressionStatementLookahead LabelledStatement
	| ExpressionStatementLookahead ThrowStatement
	| ExpressionStatementLookahead TryStatement
	| ExpressionStatementLookahead DebuggerStatement
	;

Declaration:
	  HoistableDeclaration
	| ClassDeclaration
	| LexicalDeclaration_In
	;

HoistableDeclaration:
	  FunctionDeclaration
	| GeneratorDeclaration
	;

HoistableDeclaration_Default:
	  FunctionDeclaration_Default
	| GeneratorDeclaration_Default
	;

BreakableStatement:
	  IterationStatement
	| SwitchStatement
	;

BlockStatement:
	  Block
	;

Block:
	  T_LBRACE StatementListOpt T_RBRACE
	;

StatementList:
	  StatementListItem
	| StatementList StatementListItem
	;

StatementListItem:
	  Statement
	| ExpressionStatementLookahead T_FORCE_DECLARATION Declaration Semicolon
	;

StatementListOpt:
	  ExpressionStatementLookahead
	| StatementList
	;

LetOrConst:
	  T_LET
	| T_CONST
	;

Var:
	  T_VAR
	;

LexicalDeclaration:
	  LetOrConst BindingList
	;

LexicalDeclaration_In:
	  LetOrConst BindingList_In
	;

VarDeclaration:
	  Var VariableDeclarationList
	;

VarDeclaration_In:
	  Var VariableDeclarationList_In
	;

VariableStatement:
	  VarDeclaration_In Semicolon
	;

BindingList:
	  LexicalBinding_In
	| BindingList T_COMMA LexicalBinding
	;

BindingList_In:
	  LexicalBinding_In
	| BindingList_In T_COMMA LexicalBinding_In
	;

VariableDeclarationList:
	  VariableDeclaration
	| VariableDeclarationList T_COMMA VariableDeclaration
	;

VariableDeclarationList_In:
	  VariableDeclaration_In
	| VariableDeclarationList_In T_COMMA VariableDeclaration_In
	;

LexicalBinding:
	  BindingIdentifier TypeAnnotationOpt InitializerOpt
	| BindingPattern Initializer
	;

LexicalBinding_In:
	  BindingIdentifier TypeAnnotationOpt InitializerOpt_In
	| BindingPattern Initializer_In
	;

VariableDeclaration:
	  BindingIdentifier TypeAnnotationOpt InitializerOpt
	| BindingPattern Initializer
	;

VariableDeclaration_In:
	  BindingIdentifier TypeAnnotationOpt InitializerOpt_In
	| BindingPattern Initializer_In
	;

BindingPattern:
	  T_LBRACE ObjectBindingPattern T_RBRACE
	| T_LBRACKET ArrayBindingPattern T_RBRACKET
	;

ObjectBindingPattern:
	  %empty
	| BindingPropertyList
	| BindingPropertyList T_COMMA
	;

ArrayBindingPattern:
	  ElisionOpt BindingRestElementOpt
	| BindingElementList
	| BindingElementList T_COMMA ElisionOpt BindingRestElementOpt
	;

BindingPropertyList:
	  BindingProperty
	| BindingPropertyList T_COMMA BindingProperty
	;

BindingElementList:
	  BindingElisionElement
	| BindingElementList T_COMMA BindingElisionElement
	;

BindingElisionElement:
	  ElisionOpt BindingElement
	;

BindingProperty:
	  BindingIdentifier InitializerOpt_In
	| PropertyName T_COLON BindingIdentifier InitializerOpt_In
	| PropertyName T_COLON BindingPattern InitializerOpt_In
	;

BindingElement:
	  BindingIdentifier TypeAnnotationOpt InitializerOpt_In
	| BindingPattern InitializerOpt_In
	;

BindingRestElement:
	  T_ELLIPSIS BindingIdentifier
	| T_ELLIPSIS BindingPattern
	;

BindingRestElementOpt:
	  %empty
	| BindingRestElement
	;

EmptyStatement:
	  T_SEMICOLON
	;

ExpressionStatementLookahead:
	  %empty
	;

ExpressionStatement:
	  Expression_In Semicolon
	;

IfStatement:
	  T_IF T_LPAREN Expression_In T_RPAREN Statement T_ELSE Statement
	| T_IF T_LPAREN Expression_In T_RPAREN Statement
	;

IterationStatement:
	  T_DO Statement T_WHILE T_LPAREN Expression_In T_RPAREN T_COMPATIBILITY_SEMICOLON
	| T_DO Statement T_WHILE T_LPAREN Expression_In T_RPAREN Semicolon
	| T_WHILE T_LPAREN Expression_In T_RPAREN Statement
	| T_FOR T_LPAREN ExpressionOpt T_SEMICOLON ExpressionOpt_In T_SEMICOLON ExpressionOpt_In T_RPAREN Statement
	| T_FOR T_LPAREN VarDeclaration T_SEMICOLON ExpressionOpt_In T_SEMICOLON ExpressionOpt_In T_RPAREN Statement
	| T_FOR T_LPAREN LexicalDeclaration T_SEMICOLON ExpressionOpt_In T_SEMICOLON ExpressionOpt_In T_RPAREN Statement
	| T_FOR T_LPAREN LeftHandSideExpression InOrOf Expression_In T_RPAREN Statement
	| T_FOR T_LPAREN ForDeclaration InOrOf Expression_In T_RPAREN Statement
	;

InOrOf:
	  T_IN
	| T_OF
	;

ForDeclaration:
	  LetOrConst BindingIdentifier TypeAnnotationOpt
	| Var BindingIdentifier TypeAnnotationOpt
	| LetOrConst BindingPattern
	| Var BindingPattern
	;

ContinueStatement:
	  T_CONTINUE Semicolon
	| T_CONTINUE IdentifierReference Semicolon
	;

BreakStatement:
	  T_BREAK Semicolon
	| T_BREAK IdentifierReference Semicolon
	;

ReturnStatement:
	  T_RETURN ExpressionOpt_In Semicolon
	;

WithStatement:
	  T_WITH T_LPAREN Expression_In T_RPAREN Statement
	;

SwitchStatement:
	  T_SWITCH T_LPAREN Expression_In T_RPAREN CaseBlock
	;

CaseBlock:
	  T_LBRACE CaseClausesOpt T_RBRACE
	| T_LBRACE CaseClausesOpt DefaultClause CaseClausesOpt T_RBRACE
	;

CaseClauses:
	  CaseClause
	| CaseClauses CaseClause
	;

CaseClausesOpt:
	  %empty
	| CaseClauses
	;

CaseClause:
	  T_CASE Expression_In T_COLON StatementListOpt
	;

DefaultClause:
	  T_DEFAULT T_COLON StatementListOpt
	;

LabelledStatement:
	  IdentifierReference T_COLON LabelledItem
	;

LabelledItem:
	  Statement
	| ExpressionStatementLookahead T_FORCE_DECLARATION FunctionDeclaration
	;

ThrowStatement:
	  T_THROW Expression_In Semicolon
	;

TryStatement:
	  T_TRY Block Catch
	| T_TRY Block Finally
	| T_TRY Block Catch Finally
	;

Catch:
	  T_CATCH T_LPAREN CatchParameter T_RPAREN Block
	;

Finally:
	  T_FINALLY Block
	;

CatchParameter:
	  BindingIdentifier
	| BindingPattern
	;

DebuggerStatement:
	  T_DEBUGGER Semicolon
	;

Function:
	  T_FUNCTION %prec REDUCE_HERE
	;

FunctionDeclaration:
	  Function BindingIdentifier T_LPAREN FormalParameters T_RPAREN TypeAnnotationOpt FunctionLBrace FunctionBody FunctionRBrace
	;

FunctionDeclarationWithTypes:
	  Function BindingIdentifier T_LPAREN FormalParameters T_RPAREN TypeAnnotationOpt FunctionLBrace FunctionBody FunctionRBrace
	;

FunctionDeclaration_Default:
	  FunctionDeclaration
	| Function T_LPAREN FormalParameters T_RPAREN TypeAnnotationOpt FunctionLBrace FunctionBody FunctionRBrace
	;

FunctionExpression:
	  T_FUNCTION BindingIdentifier T_LPAREN FormalParameters T_RPAREN TypeAnnotationOpt FunctionLBrace FunctionBody FunctionRBrace
	| T_FUNCTION T_LPAREN FormalParameters T_RPAREN TypeAnnotationOpt FunctionLBrace FunctionBody FunctionRBrace
	;

StrictFormalParameters:
	  FormalParameters
	;

FormalParameters:
	  %empty
	| BindingRestElement
	| FormalParameterList
	| FormalParameterList T_COMMA
	| FormalParameterList T_COMMA BindingRestElement
	;

FormalParameterList:
	  BindingElement
	| FormalParameterList T_COMMA BindingElement
	;

FormalParameter:
	  BindingElement
	;

FunctionLBrace:
	  T_LBRACE
	;

FunctionRBrace:
	  T_RBRACE
	;

FunctionBody:
	  StatementListOpt
	;

ArrowFunction:
	  ArrowParameters T_ARROW ConciseBodyLookahead AssignmentExpression
	| ArrowParameters T_ARROW ConciseBodyLookahead T_FORCE_BLOCK FunctionLBrace FunctionBody FunctionRBrace
	;

ArrowFunction_In:
	  ArrowParameters T_ARROW ConciseBodyLookahead AssignmentExpression_In
	| ArrowParameters T_ARROW ConciseBodyLookahead T_FORCE_BLOCK FunctionLBrace FunctionBody FunctionRBrace
	;

ArrowParameters:
	  BindingIdentifier
	| CoverParenthesizedExpressionAndArrowParameterList
	;

ConciseBodyLookahead:
	  %empty
	;

MethodDefinition:
	  PropertyName T_LPAREN StrictFormalParameters T_RPAREN TypeAnnotationOpt FunctionLBrace FunctionBody FunctionRBrace
	| T_STAR PropertyName GeneratorLParen StrictFormalParameters T_RPAREN TypeAnnotationOpt FunctionLBrace GeneratorBody GeneratorRBrace
	| T_GET PropertyName T_LPAREN T_RPAREN TypeAnnotationOpt FunctionLBrace FunctionBody FunctionRBrace
	| T_SET PropertyName T_LPAREN PropertySetParameterList T_RPAREN TypeAnnotationOpt FunctionLBrace FunctionBody FunctionRBrace
	;

PropertySetParameterList:
	  FormalParameter
	;

GeneratorLParen:
	  T_LPAREN
	;

GeneratorRBrace:
	  T_RBRACE
	;

FunctionStar:
	  T_FUNCTION T_STAR %prec REDUCE_HERE
	;

GeneratorDeclaration:
	  FunctionStar BindingIdentifier GeneratorLParen FormalParameters T_RPAREN FunctionLBrace GeneratorBody GeneratorRBrace
	;

GeneratorDeclaration_Default:
	  GeneratorDeclaration
	| FunctionStar GeneratorLParen FormalParameters T_RPAREN FunctionLBrace GeneratorBody GeneratorRBrace
	;

GeneratorExpression:
	  T_FUNCTION T_STAR BindingIdentifier GeneratorLParen FormalParameters T_RPAREN FunctionLBrace GeneratorBody GeneratorRBrace
	| T_FUNCTION T_STAR GeneratorLParen FormalParameters T_RPAREN FunctionLBrace GeneratorBody GeneratorRBrace
	;

GeneratorBody:
	  FunctionBody
	;

YieldExpression:
	  T_YIELD
	| T_YIELD T_STAR AssignmentExpression
	| T_YIELD AssignmentExpression
	;

YieldExpression_In:
	  T_YIELD
	| T_YIELD T_STAR AssignmentExpression_In
	| T_YIELD AssignmentExpression_In
	;

ClassDeclaration:
	  T_CLASS BindingIdentifier ClassHeritageOpt ClassLBrace ClassBodyOpt ClassRBrace
	;

ClassExpression:
	  T_CLASS BindingIdentifier ClassHeritageOpt ClassLBrace ClassBodyOpt ClassRBrace
	| T_CLASS ClassHeritageOpt ClassLBrace ClassBodyOpt ClassRBrace
	;

ClassDeclaration_Default:
	  T_CLASS ClassHeritageOpt ClassLBrace ClassBodyOpt ClassRBrace
	| ClassDeclaration
	;

ClassLBrace:
	  T_LBRACE
	;

ClassRBrace:
	  T_RBRACE
	;

ClassHeritageOpt:
	  %empty
	| T_EXTENDS LeftHandSideExpression
	;

ClassBodyOpt:
	  %empty
	| ClassElementList
	;

ClassElementList:
	  ClassElement
	| ClassElementList ClassElement
	;

ClassElement:
	  MethodDefinition
	| T_STATIC MethodDefinition
	| T_SEMICOLON
	;

Script:
	  %empty
	| ScriptBody
	;

ScriptBody:
	  StatementList
	;

Module:
	  ModuleBodyOpt
	;

ModuleBody:
	  ModuleItemList
	;

ModuleBodyOpt:
	  %empty
	| ModuleBody
	;

ModuleItemList:
	  ModuleItem
	| ModuleItemList ModuleItem
	;

ModuleItem:
	  ImportDeclaration Semicolon
	| ExportDeclaration Semicolon
	| StatementListItem
	;

ImportDeclaration:
	  T_IMPORT ImportClause FromClause
	| T_IMPORT ModuleSpecifier
	;

ImportClause:
	  ImportedDefaultBinding
	| NameSpaceImport
	| NamedImports
	| ImportedDefaultBinding T_COMMA NameSpaceImport
	| ImportedDefaultBinding T_COMMA NamedImports
	;

ImportedDefaultBinding:
	  ImportedBinding
	;

NameSpaceImport:
	  T_STAR T_AS ImportedBinding
	;

NamedImports:
	  T_LBRACE T_RBRACE
	| T_LBRACE ImportsList T_RBRACE
	| T_LBRACE ImportsList T_COMMA T_RBRACE
	;

FromClause:
	  T_FROM ModuleSpecifier
	;

ImportsList:
	  ImportSpecifier
	| ImportsList T_COMMA ImportSpecifier
	;

ImportSpecifier:
	  ImportedBinding %prec T_WITHOUTAS
	| IdentifierName T_AS ImportedBinding
	;

ModuleSpecifier:
	  T_STRING_LITERAL
	;

ImportedBinding:
	  BindingIdentifier
	;

ExportDeclarationLookahead:
	  %empty
	;

ExportDeclaration:
	  T_EXPORT T_STAR FromClause
	| T_EXPORT ExportClause FromClause
	| T_EXPORT ExportClause
	| T_EXPORT VariableStatement
	| T_EXPORT Declaration
	| T_EXPORT T_DEFAULT ExportDeclarationLookahead T_FORCE_DECLARATION HoistableDeclaration_Default
	| T_EXPORT T_DEFAULT ExportDeclarationLookahead T_FORCE_DECLARATION ClassDeclaration_Default
	| T_EXPORT T_DEFAULT ExportDeclarationLookahead AssignmentExpression_In
	;

ExportClause:
	  T_LBRACE T_RBRACE
	| T_LBRACE ExportsList T_RBRACE
	| T_LBRACE ExportsList T_COMMA T_RBRACE
	;

ExportsList:
	  ExportSpecifier
	| ExportsList T_COMMA ExportSpecifier
	;

ExportSpecifier:
	  IdentifierName
	| IdentifierName T_AS IdentifierName
	;

%%

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"&"	T_AND
"&&"	T_AND_AND
"&="	T_AND_EQ
"=>"	T_ARROW
"as"	T_AS
"@"	T_AT
T_AUTOMATIC_SEMICOLON	T_AUTOMATIC_SEMICOLON
"break"	T_BREAK
"case"	T_CASE
"catch"	T_CATCH
"class"	T_CLASS
":"	T_COLON
","	T_COMMA
T_COMPATIBILITY_SEMICOLON	T_COMPATIBILITY_SEMICOLON
T_COMPONENT	T_COMPONENT
"const"	T_CONST
"continue"	T_CONTINUE
T_DEBUGGER	T_DEBUGGER
"default"	T_DEFAULT
"delete"	T_DELETE
"/"	T_DIVIDE_
"/="	T_DIVIDE_EQ
"do"	T_DO
"."	T_DOT
"..."	T_ELLIPSIS
"else"	T_ELSE
"enum"	T_ENUM
"="	T_EQ
"=="	T_EQ_EQ
"==="	T_EQ_EQ_EQ
"export"	T_EXPORT
"extends"	T_EXTENDS
"false"	T_FALSE
T_FEED_JS_EXPRESSION	T_FEED_JS_EXPRESSION
T_FEED_JS_MODULE	T_FEED_JS_MODULE
T_FEED_JS_SCRIPT	T_FEED_JS_SCRIPT
T_FEED_JS_STATEMENT	T_FEED_JS_STATEMENT
T_FEED_UI_OBJECT_MEMBER	T_FEED_UI_OBJECT_MEMBER
T_FEED_UI_PROGRAM	T_FEED_UI_PROGRAM
"finally"	T_FINALLY
"for"	T_FOR
T_FORCE_BLOCK	T_FORCE_BLOCK
T_FORCE_DECLARATION	T_FORCE_DECLARATION
"from"	T_FROM
"function"	T_FUNCTION
">="	T_GE
"get"	T_GET
">"	T_GT
">>"	T_GT_GT
">>="	T_GT_GT_EQ
">>>"	T_GT_GT_GT
">>>="	T_GT_GT_GT_EQ
"if"	T_IF
"import"	T_IMPORT
"in"	T_IN
"instanceof"	T_INSTANCEOF
"{"	T_LBRACE
"["	T_LBRACKET
"<="	T_LE
"let"	T_LET
"("	T_LPAREN
"<"	T_LT
"<<"	T_LT_LT
"<<="	T_LT_LT_EQ
"-"	T_MINUS
"-="	T_MINUS_EQ
"--"	T_MINUS_MINUS
"new"	T_NEW
//T_NONE	T_NONE
"!"	T_NOT
"!="	T_NOT_EQ
"!=="	T_NOT_EQ_EQ
T_NO_SUBSTITUTION_TEMPLATE	T_NO_SUBSTITUTION_TEMPLATE
"null"	T_NULL
"of"	T_OF
"on"	T_ON
"|"	T_OR
"|="	T_OR_EQ
"||"	T_OR_OR
//T_PARTIAL_COMMENT	T_PARTIAL_COMMENT
//T_PARTIAL_DOUBLE_QUOTE_STRING_LITERAL	T_PARTIAL_DOUBLE_QUOTE_STRING_LITERAL
//T_PARTIAL_SINGLE_QUOTE_STRING_LITERAL	T_PARTIAL_SINGLE_QUOTE_STRING_LITERAL
//T_PARTIAL_TEMPLATE_HEAD	T_PARTIAL_TEMPLATE_HEAD
//T_PARTIAL_TEMPLATE_MIDDLE	T_PARTIAL_TEMPLATE_MIDDLE
"+"	T_PLUS
"+="	T_PLUS_EQ
"++"	T_PLUS_PLUS
T_PRAGMA	T_PRAGMA
"property"	T_PROPERTY
"?"	T_QUESTION
"?."	T_QUESTION_DOT
"??"	T_QUESTION_QUESTION
"}"	T_RBRACE
"]"	T_RBRACKET
"readonly"	T_READONLY
"%"	T_REMAINDER
"%="	T_REMAINDER_EQ
"required"	T_REQUIRED
"return"	T_RETURN
")"	T_RPAREN
";"	T_SEMICOLON
"set"	T_SET
"signal"	T_SIGNAL
"*"	T_STAR
"*="	T_STAR_EQ
"**"	T_STAR_STAR
"**="	T_STAR_STAR_EQ
"static"	T_STATIC
"super"	T_SUPER
"switch"	T_SWITCH
T_TEMPLATE_HEAD	T_TEMPLATE_HEAD
T_TEMPLATE_MIDDLE	T_TEMPLATE_MIDDLE
T_TEMPLATE_TAIL	T_TEMPLATE_TAIL
"this"	T_THIS
"throw"	T_THROW
"~"	T_TILDE
"true"	T_TRUE
"try"	T_TRY
"typeof"	T_TYPEOF
"var"	T_VAR
T_VERSION_NUMBER	T_VERSION_NUMBER
"void"	T_VOID
"while"	T_WHILE
"with"	T_WITH
T_WITHOUTAS	T_WITHOUTAS
"^"	T_XOR
"^="	T_XOR_EQ
"yeld"	T_YIELD

T_RESERVED_WORD	T_RESERVED_WORD

\"(\\.|[^"\r\n\\])*\"	T_STRING_LITERAL
'(\\.|[^'\r\n\\])*'	T_STRING_LITERAL
"`"(\\.|[^`\\])*"`"	T_MULTILINE_STRING_LITERAL

[0-9]+("."[0-9]+)?	T_NUMERIC_LITERAL

[A-Za-z_$][A-Za-z0-9_$]*	T_IDENTIFIER

%%
