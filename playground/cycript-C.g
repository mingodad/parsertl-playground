//From: https://git.saurik.com/cycript.git/blob/HEAD:/Parser.ypp.in
//bash Filter.sh Parser.ypp.in C
//bash Filter.sh Scanner.lpp.in C
/* Cycript - The Truly Universal Scripting Language
 * Copyright (C) 2009-2016  Jay Freeman (saurik)
*/

/* GNU Affero General Public License, Version 3 {{{ */
/*
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.

 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
**/
/*Tokens*/
%token Ampersand
%token AmpersandAmpersand
%token AmpersandEqual
%token At_encode_
//%token At_error_
%token AutoComplete
%token Carrot
%token CarrotEqual
%token CloseBrace
%token CloseBracket
%token CloseParen
%token Colon
%token ColonColon
%token Comma
//%token Comment
%token Equal
%token EqualEqual
%token EqualEqualEqual
%token EqualRight
%token Exclamation
%token ExclamationEqual
%token ExclamationEqualEqual
%token Hyphen
%token HyphenEqual
%token HyphenHyphen
%token HyphenRight
%token Identifier_
%token Left
%token LeftEqual
%token LeftLeft
%token LeftLeftEqual
%token MarkExpression
%token MarkModule
%token MarkScript
//%token NewLine
%token NoSubstitutionTemplate
%token NumericLiteral
%token OpenBrace
%token OpenBracket
%token OpenParen
%token Percent
%token PercentEqual
%token Period
%token PeriodPeriodPeriod
%token Pipe
%token PipeEqual
%token PipePipe
%token Plus
%token PlusEqual
%token PlusPlus
//%token Pound
%token Question
%token QuestionPeriod
%token RegularExpressionLiteral_
%token Right
%token RightEqual
%token RightRight
%token RightRightEqual
%token RightRightRight
%token RightRightRightEqual
%token SemiColon
%token Slash
%token SlashEqual
%token Star
%token StarEqual
%token StringLiteral
%token TemplateHead
%token TemplateMiddle
%token TemplateTail
%token Tilde
%token YieldStar

%nonassoc /*1*/ "if"
%nonassoc /*2*/ "else"
%nonassoc /*3*/ Colon
%nonassoc /*4*/ "yield"

%start Program

%%

Program :
	Script
	| MarkScript Script
	| MarkModule Module
	| MarkExpression Expression
	;

LexPushInOn :
	/*empty*/
	;

LexPushInOff :
	/*empty*/
	;

LexPopIn :
	/*empty*/
	;

LexPushReturnOn :
	/*empty*/
	;

LexPopReturn :
	/*empty*/
	;

Return :
	"return"
	;

LexPushSuperOn :
	/*empty*/
	;

LexPushSuperOff :
	/*empty*/
	;

LexPopSuper :
	/*empty*/
	;

Super :
	"super"
	;

LexPushYieldOn :
	/*empty*/
	;

LexPushYieldOff :
	/*empty*/
	;

LexPopYield :
	/*empty*/
	;

LexNewLineOrOpt :
	/*empty*/
	;

LexNewLineOrNot :
	/*empty*/
	;

LexNoStar :
	/*empty*/
	;

LexNoBrace :
	/*empty*/
	;

LexNoClass :
	/*empty*/
	;

LexNoFunction :
	/*empty*/
	;

LexSetStatement :
	LexNoBrace LexNoClass LexNoFunction
	;

Var_ :
	"var"
	;

IdentifierName :
	Word
	| "for"
	| "in"
	| "instanceof"
	;

WordNoUnary :
	IdentifierNoOf
	| "break"
	| "case"
	| "catch"
	| "class" LexOf
	| ";class"
	| "const"
	| "continue"
	| "debugger"
	| "default"
	| "do"
	| "else" /*2N*/
	| "enum"
	| "export"
	| "extends"
	| "false"
	| "finally"
	| "function" LexOf
	| "if" /*1N*/
	| "import"
	| "!in"
	| "!of"
	| "null"
	| "return"
	| "super"
	| "switch"
	| "this"
	| "throw"
	| "true"
	| "try"
	| "var"
	| "while"
	| "with"
	;

Word :
	WordNoUnary
	| "delete"
	| "typeof"
	| "void"
	| "yield"
	;

NullLiteral :
	"null"
	;

BooleanLiteral :
	"true"
	| "false"
	;

RegularExpressionSlash :
	Slash
	| SlashEqual
	;

RegularExpressionLiteral :
	RegularExpressionSlash RegularExpressionLiteral_
	;

StrictSemi :
	/*empty*/
	;

NewLineNot
    : LexNewLineOrNot
    ;

NewLineOpt :
	LexNewLineOrNot "\n"
	| NewLineNot
	;

TerminatorSoft :
	LexNewLineOrNot "\n" StrictSemi
	| NewLineNot LexOf Terminator
	;

TerminatorHard :
	SemiColon
	//| error StrictSemi
	;

Terminator :
	SemiColon
	//| error StrictSemi
	;

TerminatorOpt :
	SemiColon
	//| error StrictSemi
	;

IdentifierReference :
	Identifier
	| "yield"
	;

BindingIdentifier :
	LexOf IdentifierNoOf
	| LexOf "!of"
	| LexOf "yield"
	;

BindingIdentifierOpt :
	BindingIdentifier
	| LexOf
	;

LabelIdentifier :
	Identifier
	| "yield"
	;

IdentifierTypeNoOf :
	Identifier_
	| "abstract"
	| "as"
	| "await"
	| "boolean"
	| "byte"
	| "constructor"
	| "each"
	| "eval"
	| "final"
	| "from"
	| "get"
	| "goto"
	| "implements"
	| "Infinity"
	| "interface"
	| "let"
	| "!let" LexBind LexOf
	| "native"
	| "package"
	| "private"
	| "protected"
	| "__proto__"
	| "prototype"
	| "public"
	| "set"
	| "synchronized"
	| "target"
	| "throws"
	| "transient"
	| "typeid"
	| "undefined"
	;

IdentifierType :
	IdentifierTypeNoOf
	| "of"
	;

IdentifierTypeOpt :
	IdentifierType
	| /*empty*/
	;

IdentifierNoOf :
	IdentifierTypeNoOf
	| "char"
	| "double"
	| "float"
	| "int"
	| "__int128"
	| "long"
	| "short"
	| "static"
	| "volatile"
	| "signed"
	| "unsigned"
	;

Identifier :
	IdentifierNoOf
	| "of"
	| "!of"
	;

PrimaryExpression :
	"this"
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
	| AutoComplete
	;

CoverParenthesizedExpressionAndArrowParameterList :
	OpenParen Expression CloseParen
	| OpenParen LexOf CloseParen
	| OpenParen LexOf PeriodPeriodPeriod BindingIdentifier CloseParen
	| OpenParen Expression Comma LexOf PeriodPeriodPeriod BindingIdentifier CloseParen
	;

Literal :
	NullLiteral
	| BooleanLiteral
	| NumericLiteral
	| StringLiteral
	;

ArrayLiteral :
	OpenBracket ElementListOpt CloseBracket
	;

ArrayElement :
	AssignmentExpression
	| LexOf PeriodPeriodPeriod AssignmentExpression
	;

ElementList_ :
	Comma ElementListOpt
	| /*empty*/
	;

ElementList :
	ArrayElement ElementList_
	| LexOf Comma ElementListOpt
	;

ElementListOpt :
	ElementList
	| LexOf
	;

ObjectLiteral :
	OpenBrace PropertyDefinitionListOpt CloseBrace
	;

PropertyDefinitionList_ :
	Comma PropertyDefinitionListOpt
	| /*empty*/
	;

PropertyDefinitionList :
	PropertyDefinition PropertyDefinitionList_
	;

PropertyDefinitionListOpt :
	PropertyDefinitionList
	| /*empty*/
	;

PropertyDefinition :
	IdentifierReference
	| CoverInitializedName
	| PropertyName Colon /*3N*/ AssignmentExpression
	| MethodDefinition
	;

PropertyName :
	LiteralPropertyName
	| ComputedPropertyName
	;

LiteralPropertyName :
	IdentifierName
	| StringLiteral
	| NumericLiteral
	;

ComputedPropertyName :
	OpenBracket AssignmentExpression CloseBracket
	;

CoverInitializedName :
	IdentifierReference Initializer
	;

Initializer :
	Equal AssignmentExpression
	;

InitializerOpt :
	Initializer
	| /*empty*/
	;

TemplateLiteral :
	NoSubstitutionTemplate
	| TemplateHead LexPushInOff TemplateSpans
	;

TemplateSpans :
	Expression TemplateMiddle TemplateSpans
	| Expression TemplateTail LexPopIn
	;

MemberAccess :
	OpenBracket Expression CloseBracket
	| Period IdentifierName
	| Period AutoComplete
	| TemplateLiteral
	;

MemberExpression :
	PrimaryExpression
	| MemberExpression MemberAccess
	| SuperProperty
	| MetaProperty
	| "new" MemberExpression Arguments
	;

SuperProperty :
	Super OpenBracket Expression CloseBracket
	| Super Period IdentifierName
	;

MetaProperty :
	NewTarget
	;

NewTarget :
	"new" Period "target"
	;

NewExpression :
	MemberExpression
	| "new" NewExpression
	;

CallExpression_ :
	MemberExpression
	| CallExpression
	;

CallExpression :
	CallExpression_ Arguments
	| SuperCall
	| CallExpression MemberAccess
	;

SuperCall :
	Super Arguments
	;

Arguments :
	OpenParen ArgumentListOpt CloseParen
	;

ArgumentList_ :
	Comma ArgumentList
	| /*empty*/
	;

ArgumentList :
	AssignmentExpression ArgumentList_
	| LexOf PeriodPeriodPeriod AssignmentExpression
	;

ArgumentListOpt :
	ArgumentList
	| LexOf
	;

AccessExpression :
	NewExpression
	| CallExpression
	;

LeftHandSideExpression :
	BracedExpression
	| IndirectExpression
	;

PostfixExpression :
	BracedExpression
	| AccessExpression LexNewLineOrOpt PlusPlus
	| AccessExpression LexNewLineOrOpt HyphenHyphen
	;

UnaryExpression_ :
	"delete" UnaryExpression
	| "void" UnaryExpression
	| "typeof" UnaryExpression
	| PlusPlus UnaryExpression
	| HyphenHyphen UnaryExpression
	| Plus UnaryExpression
	| Hyphen UnaryExpression
	| Tilde UnaryExpression
	| Exclamation UnaryExpression
	;

UnaryExpression :
	PostfixExpression
	| UnaryExpression_
	;

MultiplicativeExpression :
	UnaryExpression
	| MultiplicativeExpression Star UnaryExpression
	| MultiplicativeExpression Slash UnaryExpression
	| MultiplicativeExpression Percent UnaryExpression
	;

AdditiveExpression :
	MultiplicativeExpression
	| AdditiveExpression Plus MultiplicativeExpression
	| AdditiveExpression Hyphen MultiplicativeExpression
	;

ShiftExpression :
	AdditiveExpression
	| ShiftExpression LeftLeft AdditiveExpression
	| ShiftExpression RightRight AdditiveExpression
	| ShiftExpression RightRightRight AdditiveExpression
	;

RelationalExpression :
	ShiftExpression
	| RelationalExpression Left ShiftExpression
	| RelationalExpression Right ShiftExpression
	| RelationalExpression LeftEqual ShiftExpression
	| RelationalExpression RightEqual ShiftExpression
	| RelationalExpression "instanceof" ShiftExpression
	| RelationalExpression "in" ShiftExpression
	;

EqualityExpression :
	RelationalExpression
	| EqualityExpression EqualEqual RelationalExpression
	| EqualityExpression ExclamationEqual RelationalExpression
	| EqualityExpression EqualEqualEqual RelationalExpression
	| EqualityExpression ExclamationEqualEqual RelationalExpression
	;

BitwiseANDExpression :
	EqualityExpression
	| BitwiseANDExpression Ampersand EqualityExpression
	;

BitwiseXORExpression :
	BitwiseANDExpression
	| BitwiseXORExpression Carrot BitwiseANDExpression
	;

BitwiseORExpression :
	BitwiseXORExpression
	| BitwiseORExpression Pipe BitwiseXORExpression
	;

LogicalANDExpression :
	BitwiseORExpression
	| LogicalANDExpression AmpersandAmpersand BitwiseORExpression
	;

LogicalORExpression :
	LogicalANDExpression
	| LogicalORExpression PipePipe LogicalANDExpression
	;

ConditionalExpression :
	LogicalORExpression
	| LogicalORExpression Question LexPushInOff AssignmentExpression Colon /*3N*/ LexPopIn AssignmentExpression
	;

LeftHandSideAssignment :
	LeftHandSideExpression Equal
	| LeftHandSideExpression StarEqual
	| LeftHandSideExpression SlashEqual
	| LeftHandSideExpression PercentEqual
	| LeftHandSideExpression PlusEqual
	| LeftHandSideExpression HyphenEqual
	| LeftHandSideExpression LeftLeftEqual
	| LeftHandSideExpression RightRightEqual
	| LeftHandSideExpression RightRightRightEqual
	| LeftHandSideExpression AmpersandEqual
	| LeftHandSideExpression CarrotEqual
	| LeftHandSideExpression PipeEqual
	;

AssignmentExpression :
	LexOf ConditionalExpression
	| LexOf YieldExpression
	| ArrowFunction
	| LexOf LeftHandSideAssignment AssignmentExpression
	;

Expression :
	AssignmentExpression
	| Expression Comma AssignmentExpression
	;

ExpressionOpt :
	Expression
	| LexOf
	;

Statement__ :
	BlockStatement
	| VariableStatement
	| EmptyStatement
	| IfStatement
	| BreakableStatement
	| ContinueStatement
	| BreakStatement
	| ReturnStatement
	| WithStatement
	| LabelledStatement
	| ThrowStatement
	| TryStatement
	| DebuggerStatement
	;

Statement_ :
	LexOf Statement__
	| ExpressionStatement
	;

Statement :
	LexSetStatement LexLet Statement_
	;

Declaration_ :
	HoistableDeclaration
	| ClassDeclaration
	;

Declaration :
	LexSetStatement LexLet LexOf Declaration_
	| LexSetStatement LexicalDeclaration
	;

HoistableDeclaration :
	FunctionDeclaration
	| GeneratorDeclaration
	;

BreakableStatement :
	IterationStatement
	| SwitchStatement
	;

BlockStatement :
	";{" StatementListOpt CloseBrace
	;

Block :
	OpenBrace StatementListOpt CloseBrace
	;

StatementList :
	StatementListItem StatementListOpt
	;

StatementListOpt :
	StatementList
	| LexSetStatement LexLet LexOf
	;

StatementListItem :
	Statement
	| Declaration
	;

LexicalDeclaration_ :
	LetOrConst BindingList
	;

LexicalDeclaration :
	LexicalDeclaration_ Terminator
	;

LexLet :
	/*empty*/
	;

LexOf :
	/*empty*/
	;

LexBind :
	/*empty*/
	;

LetOrConst :
	LexLet LexOf "!let" LexBind LexOf
	| LexLet LexOf "const"
	;

BindingList_ :
	Comma LexBind BindingList
	| /*empty*/
	;

BindingList :
	LexicalBinding BindingList_
	;

LexicalBinding :
	BindingIdentifier InitializerOpt
	| LexOf BindingPattern Initializer
	;

VariableStatement_ :
	Var_ VariableDeclarationList
	;

VariableStatement :
	VariableStatement_ Terminator
	;

VariableDeclarationList_ :
	Comma VariableDeclarationList
	| /*empty*/
	;

VariableDeclarationList :
	LexBind VariableDeclaration VariableDeclarationList_
	;

VariableDeclaration :
	BindingIdentifier InitializerOpt
	| LexOf BindingPattern Initializer
	;

BindingPattern :
	ObjectBindingPattern
	| ArrayBindingPattern
	;

ObjectBindingPattern :
	"let {" BindingPropertyListOpt CloseBrace
	;

ArrayBindingPattern :
	"let [" BindingElementListOpt CloseBracket
	;

BindingPropertyList_ :
	Comma BindingPropertyListOpt
	| /*empty*/
	;

BindingPropertyList :
	BindingProperty BindingPropertyList_
	;

BindingPropertyListOpt :
	BindingPropertyList
	| LexOf
	;

BindingElementList :
	BindingElementOpt Comma BindingElementListOpt
	| BindingRestElement
	| BindingElement
	;

BindingElementListOpt :
	BindingElementList
	| LexBind LexOf
	;

BindingProperty :
	SingleNameBinding
	| LexOf PropertyName Colon /*3N*/ BindingElement
	;

BindingElement :
	LexBind SingleNameBinding
	| LexBind LexOf BindingPattern InitializerOpt
	;

BindingElementOpt :
	BindingElement
	| LexBind LexOf
	;

SingleNameBinding :
	BindingIdentifier InitializerOpt
	;

BindingRestElement :
	LexBind LexOf PeriodPeriodPeriod BindingIdentifier
	;

EmptyStatement :
	SemiColon
	;

ExpressionStatement_ :
	Expression
	;

ExpressionStatement :
	ExpressionStatement_ Terminator
	;

ElseStatementOpt :
	"else" /*2N*/ Statement
	| %prec "if" /*1N*/ /*empty*/
	;

IfStatement :
	"if" /*1N*/ OpenParen Expression CloseParen Statement ElseStatementOpt
	;

IterationStatement :
	"do" Statement "while" OpenParen Expression CloseParen TerminatorOpt
	| "while" OpenParen Expression CloseParen Statement
	| "for" OpenParen LexPushInOn ForStatementInitializer LexPopIn ExpressionOpt SemiColon ExpressionOpt CloseParen Statement
	| "for" OpenParen LexPushInOn LexLet LexOf Var_ LexBind BindingIdentifier Initializer "!in" LexPopIn Expression CloseParen Statement
	| "for" OpenParen LexPushInOn ForInStatementInitializer "!in" LexPopIn Expression CloseParen Statement
	| "for" OpenParen LexPushInOn ForInStatementInitializer "of" LexPopIn AssignmentExpression CloseParen Statement
	;

ForStatementInitializer :
	LexLet LexOf EmptyStatement
	| LexLet ExpressionStatement_ SemiColon
	| LexLet LexOf VariableStatement_ SemiColon
	| LexicalDeclaration_ SemiColon
	;

ForInStatementInitializer :
	LexLet LexOf BracedExpression
	| LexLet LexOf IndirectExpression
	| LexLet LexOf Var_ LexBind ForBinding
	| ForDeclaration
	;

ForDeclaration :
	LetOrConst ForBinding
	;

ForBinding :
	BindingIdentifier
	| LexOf BindingPattern
	;

ContinueStatement :
	"continue" TerminatorSoft
	| "continue" NewLineNot LexOf Identifier Terminator
	;

BreakStatement :
	"break" TerminatorSoft
	| "break" NewLineNot LexOf Identifier Terminator
	;

ReturnStatement :
	Return TerminatorSoft
	| Return NewLineNot Expression Terminator
	;

WithStatement :
	"with" OpenParen Expression CloseParen Statement
	;

SwitchStatement :
	"switch" OpenParen Expression CloseParen CaseBlock
	;

CaseBlock :
	OpenBrace CaseClausesOpt CloseBrace
	;

CaseClause :
	"case" Expression Colon /*3N*/ StatementListOpt
	;

CaseClausesOpt :
	CaseClause CaseClausesOpt
	| DefaultClause CaseClausesOpt
	| /*empty*/
	;

DefaultClause :
	"default" Colon /*3N*/ StatementListOpt
	;

LabelledStatement :
	LabelIdentifier Colon /*3N*/ LabelledItem
	;

LabelledItem :
	Statement
	| LexSetStatement LexLet LexOf FunctionDeclaration
	;

ThrowStatement :
	"throw" TerminatorSoft
	| "throw" NewLineNot Expression Terminator
	;

TryStatement :
	"try" Block Catch
	| "try" Block Finally
	| "try" Block Catch Finally
	;

Catch :
	"catch" OpenParen LexBind CatchParameter CloseParen Block
	;

Finally :
	"finally" Block
	;

CatchParameter :
	BindingIdentifier
	| LexOf BindingPattern
	;

DebuggerStatement :
	"debugger" Terminator
	;

FunctionDeclaration :
	";function" BindingIdentifier OpenParen FormalParameters CloseParen OpenBrace LexPushSuperOff FunctionBody CloseBrace LexPopSuper
	;

FunctionExpression :
	"function" BindingIdentifierOpt OpenParen FormalParameters CloseParen OpenBrace LexPushSuperOff FunctionBody CloseBrace LexPopSuper
	;

StrictFormalParameters :
	FormalParameters
	;

FormalParameters :
	LexBind LexOf
	| FormalParameterList
	;

FormalParameterList_ :
	Comma FormalParameterList
	| FormalParameter
	;

FormalParameterList :
	FunctionRestParameter
	| FormalParameterList_
	;

FunctionRestParameter :
	BindingRestElement
	;

FormalParameter :
	BindingElement
	;

FunctionBody :
	LexPushYieldOff FunctionStatementList LexPopYield
	;

FunctionStatementList :
	LexPushReturnOn StatementListOpt LexPopReturn
	;

ArrowFunction :
	ArrowParameters LexNewLineOrOpt EqualRight LexNoBrace ConciseBody
	;

ArrowParameters :
	BindingIdentifier
	| LexOf CoverParenthesizedExpressionAndArrowParameterList
	;

ConciseBody :
	AssignmentExpression
	| LexOf ";{" FunctionBody CloseBrace
	;

MethodDefinition :
	PropertyName OpenParen StrictFormalParameters CloseParen OpenBrace FunctionBody CloseBrace
	| GeneratorMethod
	| "get" PropertyName OpenParen CloseParen OpenBrace FunctionBody CloseBrace
	| "set" PropertyName OpenParen PropertySetParameterList CloseParen OpenBrace FunctionBody CloseBrace
	;

PropertySetParameterList :
	FormalParameter
	;

GeneratorMethod :
	Star PropertyName OpenParen StrictFormalParameters CloseParen OpenBrace GeneratorBody CloseBrace
	;

GeneratorDeclaration :
	";function" LexOf Star BindingIdentifier OpenParen FormalParameters CloseParen OpenBrace GeneratorBody CloseBrace
	;

GeneratorExpression :
	"function" LexOf Star BindingIdentifierOpt OpenParen FormalParameters CloseParen OpenBrace GeneratorBody CloseBrace
	;

GeneratorBody :
	LexPushYieldOn FunctionStatementList LexPopYield
	;

YieldExpression :
	"!yield" /*4N*/ LexNewLineOrNot "\n" LexOf
	| "!yield" /*4N*/ LexNewLineOrNot LexNoStar LexOf %prec "!yield" /*4N*/
	| "!yield" /*4N*/ LexNewLineOrNot LexNoStar AssignmentExpression
	| "!yield" /*4N*/ LexNewLineOrNot LexNoStar LexOf "yield *" AssignmentExpression
	;

ClassDeclaration :
	";class" BindingIdentifier ClassTail
	;

ClassExpression :
	"class" BindingIdentifierOpt ClassTail
	;

ClassTail :
	ClassHeritageOpt OpenBrace LexPushSuperOn ClassBodyOpt CloseBrace LexPopSuper
	;

ClassHeritage :
	"extends" AccessExpression
	;

ClassHeritageOpt :
	ClassHeritage
	| /*empty*/
	;

ClassBody :
	ClassElementList
	;

ClassBodyOpt :
	ClassBody
	| /*empty*/
	;

ClassElementList :
	ClassElementListOpt ClassElement
	;

ClassElementListOpt :
	ClassElementList ClassElement
	| /*empty*/
	;

ClassElement :
	MethodDefinition
	| "static" MethodDefinition
	| SemiColon
	;

Script :
	ScriptBodyOpt
	;

ScriptBody :
	StatementList
	;

ScriptBodyOpt :
	ScriptBody
	| LexSetStatement LexLet LexOf
	;

Module :
	ModuleBodyOpt
	;

ModuleBody :
	ModuleItemList
	;

ModuleBodyOpt :
	ModuleBody
	| LexSetStatement LexLet LexOf
	;

ModuleItemList :
	ModuleItem ModuleItemListOpt
	;

ModuleItemListOpt :
	ModuleItemList
	| LexSetStatement LexLet LexOf
	;

ModuleItem :
	LexSetStatement LexLet LexOf ImportDeclaration
	| LexSetStatement LexLet LexOf ExportDeclaration
	| StatementListItem
	;

ImportDeclaration :
	"import" ImportClause FromClause Terminator
	| "import" LexOf ModuleSpecifier Terminator
	;

ImportClause :
	ImportedDefaultBinding
	| LexOf NameSpaceImport
	| LexOf NamedImports
	| ImportedDefaultBinding Comma NameSpaceImport
	| ImportedDefaultBinding Comma NamedImports
	;

ImportedDefaultBinding :
	ImportedBinding
	;

NameSpaceImport :
	Star "as" ImportedBinding
	;

NamedImports :
	OpenBrace ImportsListOpt CloseBrace
	;

FromClause :
	"from" ModuleSpecifier
	;

ImportsList_ :
	Comma ImportsListOpt
	| /*empty*/
	;

ImportsList :
	ImportSpecifier ImportsList_
	;

ImportsListOpt :
	ImportsList
	| LexOf
	;

ImportSpecifier :
	ImportedBinding
	| LexOf IdentifierName "as" ImportedBinding
	;

ModuleSpecifier :
	StringLiteral
	;

ImportedBinding :
	BindingIdentifier
	;

ExportDeclaration_ :
	Star FromClause Terminator
	| ExportClause FromClause Terminator
	| ExportClause Terminator
	| VariableStatement
	| "default" LexSetStatement LexOf HoistableDeclaration
	| "default" LexSetStatement LexOf ClassDeclaration
	| "default" LexSetStatement AssignmentExpression Terminator
	;

ExportDeclaration :
	"export" LexSetStatement LexLet LexOf ExportDeclaration_
	| "export" Declaration
	;

ExportClause :
	";{" ExportsListOpt CloseBrace
	;

ExportsList_ :
	Comma ExportsListOpt
	| /*empty*/
	;

ExportsList :
	ExportSpecifier ExportsList_
	;

ExportsListOpt :
	ExportsList
	| /*empty*/
	;

ExportSpecifier :
	IdentifierName
	| IdentifierName "as" IdentifierName
	;

TypeSignifier :
	IdentifierType
	| StringLiteral
	| NumericLiteral
	| OpenParen Star TypeQualifierRightOpt CloseParen
	;

TypeSignifierNone :
	/*empty*/
	;

TypeSignifierOpt :
	TypeSignifier
	| TypeSignifierNone
	;

ParameterTail :
	TypedParameterListOpt CloseParen
	;

SuffixedType :
	SuffixedTypeOpt OpenBracket AssignmentExpression CloseBracket
	| OpenParen Carrot TypeQualifierRightOpt CloseParen OpenParen TypedParameters CloseParen
	| TypeSignifier OpenParen ParameterTail
	| OpenParen ParameterTail
	;

SuffixedTypeOpt :
	SuffixedType
	| TypeSignifierOpt
	;

PrefixedType :
	Star TypeQualifierRightOpt
	;

TypeQualifierLeft :
	"const" TypeQualifierLeftOpt
	| "volatile" TypeQualifierLeftOpt
	;

TypeQualifierLeftOpt :
	TypeQualifierLeft
	| /*empty*/
	;

TypeQualifierRight :
	SuffixedType
	| PrefixedType
	| "const" TypeQualifierRightOpt
	| "volatile" TypeQualifierRightOpt
	;

TypeQualifierRightOpt :
	TypeQualifierRight
	| TypeSignifierOpt
	;

IntegerType :
	"int"
	| "unsigned" IntegerTypeOpt
	| "signed" IntegerTypeOpt
	| "long" IntegerTypeOpt
	| "short" IntegerTypeOpt
	;

IntegerTypeOpt :
	IntegerType
	| /*empty*/
	;

StructFieldListOpt :
	TypedIdentifierField SemiColon StructFieldListOpt
	| /*empty*/
	;

IntegerNumber :
	NumericLiteral
	| Hyphen NumericLiteral
	;

EnumConstantListOpt_ :
	Comma EnumConstantListOpt
	| /*empty*/
	;

EnumConstantListOpt :
	IdentifierType Equal IntegerNumber EnumConstantListOpt_
	| /*empty*/
	;

TypeSigning :
	/*empty*/
	| "signed"
	| "unsigned"
	;

PrimitiveType :
	IdentifierType
	| IntegerType
	| TypeSigning "char"
	| TypeSigning "__int128"
	| "float"
	| "double"
	| "long" "double"
	| "void"
	;

PrimitiveReference :
	PrimitiveType
	| "struct" IdentifierType
	| "enum" IdentifierType
	| "struct" AutoComplete
	| "enum" AutoComplete
	;

TypedIdentifierMaybe :
	TypeQualifierLeftOpt PrimitiveReference TypeQualifierRightOpt
	;

TypedIdentifierYes :
	TypedIdentifierMaybe
	;

TypedIdentifierNo :
	TypedIdentifierMaybe
	;

TypedIdentifierTagged :
	TypeQualifierLeftOpt "struct" OpenBrace StructFieldListOpt CloseBrace TypeQualifierRightOpt
	| TypeQualifierLeftOpt "enum" Colon /*3N*/ PrimitiveType OpenBrace EnumConstantListOpt CloseBrace TypeQualifierRightOpt
	;

TypedIdentifierField :
	TypedIdentifierYes
	| TypedIdentifierTagged
	;

TypedIdentifierEncoding :
	TypedIdentifierNo
	| TypedIdentifierTagged
	;

TypedIdentifierDefinition :
	TypedIdentifierYes
	| TypeQualifierLeftOpt "struct" IdentifierTypeOpt OpenBrace StructFieldListOpt CloseBrace TypeQualifierRightOpt
	;

PrimaryExpression :
	At_encode_ OpenParen TypedIdentifierEncoding CloseParen
	;

ModulePath :
	ModulePath Period Word
	| Word
	;

Declaration_ :
	"@import" ModulePath
	;

UnaryExpression_ :
	IndirectExpression
	;

IndirectExpression :
	Star UnaryExpression
	;

UnaryExpression_ :
	Ampersand UnaryExpression
	;

MemberAccess :
	HyphenRight OpenBracket Expression CloseBracket
	| HyphenRight IdentifierName
	| HyphenRight AutoComplete
	;

TypedParameterList_ :
	Comma TypedParameterList
	| /*empty*/
	;

TypedParameterList :
	TypedIdentifierMaybe TypedParameterList_
	| PeriodPeriodPeriod
	;

TypedParameterListOpt :
	TypedParameterList
	| /*empty*/
	;

TypedParameters :
	TypedParameterListOpt
	;

PrimaryExpression :
	OpenBracket LexOf Ampersand CloseBracket OpenParen TypedParameters CloseParen HyphenRight TypedIdentifierNo OpenBrace FunctionBody CloseBrace
	;

IdentifierNoOf :
	"struct" NewLineOpt
	;

Statement__ :
	"struct" NewLineNot IdentifierType OpenBrace StructFieldListOpt CloseBrace
	;

PrimaryExpression :
	OpenParen LexOf "struct" NewLineOpt IdentifierType TypeQualifierRightOpt CloseParen
	| OpenParen LexOf "struct" NewLineOpt AutoComplete
	;

IdentifierNoOf :
	"typedef" NewLineOpt
	;

TypeDefinition :
	"typedef" NewLineNot TypedIdentifierDefinition TerminatorHard
	;

Statement__ :
	TypeDefinition
	;

PrimaryExpression :
	OpenParen LexOf "typedef" NewLineOpt TypedIdentifierEncoding CloseParen
	;

IdentifierNoOf :
	"extern" NewLineOpt
	;

ExternCStatement :
	TypedIdentifierField TerminatorHard
	| TypeDefinition
	;

ExternCStatementListOpt :
	ExternCStatementListOpt ExternCStatement
	| /*empty*/
	;

ExternC :
	OpenBrace ExternCStatementListOpt CloseBrace
	| ExternCStatement
	;

ABI :
	StringLiteral
	;

Statement__ :
	"extern" NewLineNot ABI ExternC
	;

PrimaryExpression :
	OpenParen LexOf "extern" NewLineOpt ABI TypedIdentifierField CloseParen
	;

Comprehension :
	AssignmentExpression ComprehensionFor ComprehensionTail
	;

ComprehensionFor :
	"for" "each" OpenParen LexPushInOn LexBind ForBinding "!in" LexPopIn Expression CloseParen
	;

IterationStatement :
	"for" "each" OpenParen LexPushInOn ForInStatementInitializer "!in" LexPopIn Expression CloseParen Statement
	;

PrimaryExpression :
	ArrayComprehension
	;

ArrayComprehension :
	OpenBracket Comprehension CloseBracket
	;

Comprehension :
	LexOf ComprehensionFor ComprehensionTail AssignmentExpression
	;

ComprehensionTail :
	/*empty*/
	| ComprehensionTail ComprehensionFor
	| ComprehensionTail ComprehensionIf
	;

ComprehensionFor :
	"for" OpenParen LexPushInOn LexBind ForBinding "!in" LexPopIn Expression CloseParen
	| "for" OpenParen LexPushInOn LexBind ForBinding "of" LexPopIn Expression CloseParen
	;

ComprehensionIf :
	"if" /*1N*/ OpenParen AssignmentExpression CloseParen
	;

ArgumentList :
	LexOf WordNoUnary Colon /*3N*/ AssignmentExpression ArgumentList_
	;

MemberAccess :
	Period OpenBracket AssignmentExpression CloseBracket
	| QuestionPeriod IdentifierName
	| QuestionPeriod AutoComplete
	;

BracedParameter :
	OpenBrace PropertyDefinitionListOpt CloseBrace
	;

RubyProcParameterList_ :
	Comma RubyProcParameterList
	| /*empty*/
	;

RubyProcParameterList :
	BindingIdentifier RubyProcParameterList_
	| LexOf
	;

RubyProcParameters :
	Pipe RubyProcParameterList Pipe
	| PipePipe
	;

RubyProcParametersOpt :
	RubyProcParameters
	| /*empty*/
	;

BracedParameter :
	";{" RubyProcParametersOpt StatementListOpt CloseBrace
	;

PrimaryExpression :
	OpenBrace RubyProcParameters StatementListOpt CloseBrace
	;

BracedExpression_ :
	AccessExpression LexNewLineOrOpt
	| BracedExpression_ BracedParameter LexNewLineOrOpt
	;

BracedExpression :
	BracedExpression_ "\n"
	| BracedExpression_
	;

MemberAccess :
	ColonColon OpenBracket Expression CloseBracket
	| ColonColon IdentifierName
	| ColonColon AutoComplete
	;

PrimaryExpression :
	Colon /*3N*/ Word
	;

%%

U1 [\x00-\x7f]
U0 [\x80-\xbf]
U2 [\xc2-\xdf]
U3 [\xe0-\xef]
U4 [\xf0-\xf4]
UN [\xc0-\xc1\xf5-\xff]
UE {U1}|{U2}|{U3}|{U4}|{UN}

HexDigit [0-9a-fA-F]
LineTerminatorSequence \r?\n|\r|\xe2\x80[\xa8\xa9]
WhiteSpace [\x09\x0b\x0c\x20]|\xc2\xa0|\xef\xbb\xbf
UnicodeEscape \\u({HexDigit}{4}|\{{HexDigit}+\})

NotLineTerminator [\xc2-\xdf][\x80-\xbf]|\xe0[\xa0-\xbf][\x80-\xbf]|\xe2\x80[\x80-\xa7\xaa-\xbf]|\xe2[\x81-\xbf][\x80-\xbf]|[\xe1\xe3-\xef][\x80-\xbf]{2}|\xf0[\x90-\xbf][\x80-\xbf]{2}|\xf4[\x80-\x8f][\x80-\xbf]{2}|[\xf1-\xf3][\x80-\xbf]{3}
NoneTerminatorCharacter [^\r\n\x80-\xff]|{NotLineTerminator}
RegExCharacter [^/[\\]{-}[\r\n\x80-\xff]|{NotLineTerminator}
RegClsCharacter [^]\\]{-}[\r\n\x80-\xff]|{NotLineTerminator}
CommentCharacter [^*/]{-}[\r\n\x80-\xff]|{NotLineTerminator}
SingleCharacter [^'\\]{-}[\r\n\x80-\xff]|{NotLineTerminator}
DoubleCharacter [^"\\]{-}[\r\n\x80-\xff]|{NotLineTerminator}
PlateCharacter [^$`\\]{-}[\r\n\x80-\xff]|{NotLineTerminator}

UnicodeIDStart_0 [\x41-\x5a\x61-\x7a]|\xc2[\xaa\xb5\xba]|\xc3[\x80-\x96\x98-\xb6\xb8-\xbf]|\xcb[\x80\x81\x86-\x91\xa0-\xa4\xac\xae]|\xcd[\xb0-\xb4\xb6\xb7\xba-\xbd\xbf]|\xce[\x86\x88-\x8a\x8c\x8e-\xa1\xa3-\xbf]|\xcf[\x80-\xb5\xb7-\xbf]|\xd2[\x80\x81\x8a-\xbf]|\xd4[\x80-\xaf\xb1-\xbf]|\xd5[\x80-\x96\x99\xa1-\xbf]|\xd6[\x80-\x87]|\xd7[\x90-\xaa\xb0-\xb2]|\xd8[\xa0-\xbf]|\xd9[\x80-\x8a\xae\xaf\xb1-\xbf]|\xdb[\x80-\x93\x95\xa5\xa6\xae\xaf\xba-\xbc\xbf]|\xdc[\x90\x92-\xaf]|\xdd[\x8d-\xbf]|\xde[\x80-\xa5\xb1]|\xdf[\x8a-\xaa\xb4\xb5\xba]|[\xc4-\xca\xd0\xd1\xd3\xda][\x80-\xbf]|\xe0\xa0[\x80-\x95\x9a\xa4\xa8]|\xe0\xa1[\x80-\x98]|\xe0\xa2[\xa0-\xb4]|\xe0\xa4[\x84-\xb9\xbd]|\xe0\xa5[\x90\x98-\xa1\xb1-\xbf]|\xe0\xa6[\x80\x85-\x8c\x8f\x90\x93-\xa8\xaa-\xb0\xb2\xb6-\xb9\xbd]|\xe0\xa7[\x8e\x9c\x9d\x9f-\xa1\xb0\xb1]|\xe0\xa8[\x85-\x8a\x8f\x90\x93-\xa8\xaa-\xb0\xb2\xb3\xb5\xb6\xb8\xb9]|\xe0\xa9[\x99-\x9c\x9e\xb2-\xb4]|\xe0\xaa[\x85-\x8d\x8f-\x91\x93-\xa8\xaa-\xb0\xb2\xb3\xb5-\xb9\xbd]|\xe0\xab[\x90\xa0\xa1\xb9]|\xe0\xac[\x85-\x8c\x8f\x90\x93-\xa8\xaa-\xb0\xb2\xb3\xb5-\xb9\xbd]
UnicodeIDStart_1 \xe0\xad[\x9c\x9d\x9f-\xa1\xb1]|\xe0\xae[\x83\x85-\x8a\x8e-\x90\x92-\x95\x99\x9a\x9c\x9e\x9f\xa3\xa4\xa8-\xaa\xae-\xb9]|\xe0\xaf[\x90]|\xe0\xb0[\x85-\x8c\x8e-\x90\x92-\xa8\xaa-\xb9\xbd]|\xe0\xb1[\x98-\x9a\xa0\xa1]|\xe0\xb2[\x85-\x8c\x8e-\x90\x92-\xa8\xaa-\xb3\xb5-\xb9\xbd]|\xe0\xb3[\x9e\xa0\xa1\xb1\xb2]|\xe0\xb4[\x85-\x8c\x8e-\x90\x92-\xba\xbd]|\xe0\xb5[\x8e\x9f-\xa1\xba-\xbf]|\xe0\xb6[\x85-\x96\x9a-\xb1\xb3-\xbb\xbd]|\xe0\xb7[\x80-\x86]|\xe0\xb8[\x81-\xb0\xb2\xb3]|\xe0\xb9[\x80-\x86]|\xe0\xba[\x81\x82\x84\x87\x88\x8a\x8d\x94-\x97\x99-\x9f\xa1-\xa3\xa5\xa7\xaa\xab\xad-\xb0\xb2\xb3\xbd]|\xe0\xbb[\x80-\x84\x86\x9c-\x9f]|\xe0\xbc[\x80]|\xe0\xbd[\x80-\x87\x89-\xac]|\xe0\xbe[\x88-\x8c]|\xe1\x80[\x80-\xaa\xbf]|\xe1\x81[\x90-\x95\x9a-\x9d\xa1\xa5\xa6\xae-\xb0\xb5-\xbf]|\xe1\x82[\x80\x81\x8e\xa0-\xbf]|\xe1\x83[\x80-\x85\x87\x8d\x90-\xba\xbc-\xbf]|\xe1\x89[\x80-\x88\x8a-\x8d\x90-\x96\x98\x9a-\x9d\xa0-\xbf]|\xe1\x8a[\x80-\x88\x8a-\x8d\x90-\xb0\xb2-\xb5\xb8-\xbe]|\xe1\x8b[\x80\x82-\x85\x88-\x96\x98-\xbf]
UnicodeIDStart_2 \xe1\x8c[\x80-\x90\x92-\x95\x98-\xbf]|\xe1\x8d[\x80-\x9a]|\xe1\x8e[\x80-\x8f\xa0-\xbf]|\xe1\x8f[\x80-\xb5\xb8-\xbd]|\xe1\x90[\x81-\xbf]|\xe1\x99[\x80-\xac\xaf-\xbf]|\xe1\x9a[\x81-\x9a\xa0-\xbf]|\xe1\x9b[\x80-\xaa\xae-\xb8]|\xe1\x9c[\x80-\x8c\x8e-\x91\xa0-\xb1]|\xe1\x9d[\x80-\x91\xa0-\xac\xae-\xb0]|\xe1\x9e[\x80-\xb3]|\xe1\x9f[\x97\x9c]|\xe1\xa0[\xa0-\xbf]|\xe1\xa1[\x80-\xb7]|\xe1\xa2[\x80-\xa8\xaa\xb0-\xbf]|\xe1\xa3[\x80-\xb5]|\xe1\xa4[\x80-\x9e]|\xe1\xa5[\x90-\xad\xb0-\xb4]|\xe1\xa6[\x80-\xab\xb0-\xbf]|\xe1\xa7[\x80-\x89]|\xe1\xa8[\x80-\x96\xa0-\xbf]|\xe1\xa9[\x80-\x94]|\xe1\xaa[\xa7]|\xe1\xac[\x85-\xb3]|\xe1\xad[\x85-\x8b]|\xe1\xae[\x83-\xa0\xae\xaf\xba-\xbf]|\xe1\xaf[\x80-\xa5]|\xe1\xb0[\x80-\xa3]|\xe1\xb1[\x8d-\x8f\x9a-\xbd]|\xe1\xb3[\xa9-\xac\xae-\xb1\xb5\xb6]|\xe1\xbc[\x80-\x95\x98-\x9d\xa0-\xbf]|\xe1\xbd[\x80-\x85\x88-\x8d\x90-\x97\x99\x9b\x9d\x9f-\xbd]|\xe1\xbe[\x80-\xb4\xb6-\xbc\xbe]|\xe1\xbf[\x82-\x84\x86-\x8c\x90-\x93\x96-\x9b\xa0-\xac\xb2-\xb4\xb6-\xbc]|\xe1[\x84-\x88\x91-\x98\xb4-\xb6\xb8-\xbb][\x80-\xbf]
UnicodeIDStart_3 \xe2\x81[\xb1\xbf]|\xe2\x82[\x90-\x9c]|\xe2\x84[\x82\x87\x8a-\x93\x95\x98-\x9d\xa4\xa6\xa8\xaa-\xb9\xbc-\xbf]|\xe2\x85[\x85-\x89\x8e\xa0-\xbf]|\xe2\x86[\x80-\x88]|\xe2\xb0[\x80-\xae\xb0-\xbf]|\xe2\xb1[\x80-\x9e\xa0-\xbf]|\xe2\xb3[\x80-\xa4\xab-\xae\xb2\xb3]|\xe2\xb4[\x80-\xa5\xa7\xad\xb0-\xbf]|\xe2\xb5[\x80-\xa7\xaf]|\xe2\xb6[\x80-\x96\xa0-\xa6\xa8-\xae\xb0-\xb6\xb8-\xbe]|\xe2\xb7[\x80-\x86\x88-\x8e\x90-\x96\x98-\x9e]|\xe2[\xb2][\x80-\xbf]|\xe3\x80[\x85-\x87\xa1-\xa9\xb1-\xb5\xb8-\xbc]|\xe3\x81[\x81-\xbf]|\xe3\x82[\x80-\x96\x9b-\x9f\xa1-\xbf]|\xe3\x83[\x80-\xba\xbc-\xbf]|\xe3\x84[\x85-\xad\xb1-\xbf]|\xe3\x86[\x80-\x8e\xa0-\xba]|\xe3\x87[\xb0-\xbf]|\xe3[\x85\x90-\xbf][\x80-\xbf]|\xe4\xb6[\x80-\xb5]|\xe4[\x80-\xb5\xb8-\xbf][\x80-\xbf]|\xe9\xbf[\x80-\x95]|\xe9[\x80-\xbe][\x80-\xbf]|\xea\x92[\x80-\x8c]|\xea\x93[\x90-\xbd]|\xea\x98[\x80-\x8c\x90-\x9f\xaa\xab]|\xea\x99[\x80-\xae\xbf]|\xea\x9a[\x80-\x9d\xa0-\xbf]|\xea\x9b[\x80-\xaf]|\xea\x9c[\x97-\x9f\xa2-\xbf]|\xea\x9e[\x80-\x88\x8b-\xad\xb0-\xb7]
UnicodeIDStart_4 \xea\x9f[\xb7-\xbf]|\xea\xa0[\x80\x81\x83-\x85\x87-\x8a\x8c-\xa2]|\xea\xa1[\x80-\xb3]|\xea\xa2[\x82-\xb3]|\xea\xa3[\xb2-\xb7\xbb\xbd]|\xea\xa4[\x8a-\xa5\xb0-\xbf]|\xea\xa5[\x80-\x86\xa0-\xbc]|\xea\xa6[\x84-\xb2]|\xea\xa7[\x8f\xa0-\xa4\xa6-\xaf\xba-\xbe]|\xea\xa8[\x80-\xa8]|\xea\xa9[\x80-\x82\x84-\x8b\xa0-\xb6\xba\xbe\xbf]|\xea\xaa[\x80-\xaf\xb1\xb5\xb6\xb9-\xbd]|\xea\xab[\x80\x82\x9b-\x9d\xa0-\xaa\xb2-\xb4]|\xea\xac[\x81-\x86\x89-\x8e\x91-\x96\xa0-\xa6\xa8-\xae\xb0-\xbf]|\xea\xad[\x80-\x9a\x9c-\xa5\xb0-\xbf]|\xea\xaf[\x80-\xa2]|\xea[\x80-\x91\x94-\x97\x9d\xae\xb0-\xbf][\x80-\xbf]|\xed\x9e[\x80-\xa3\xb0-\xbf]|\xed\x9f[\x80-\x86\x8b-\xbb]|\xed[\x80-\x9d][\x80-\xbf]|\xef\xa9[\x80-\xad\xb0-\xbf]|\xef\xab[\x80-\x99]|\xef\xac[\x80-\x86\x93-\x97\x9d\x9f-\xa8\xaa-\xb6\xb8-\xbc\xbe]|\xef\xad[\x80\x81\x83\x84\x86-\xbf]|\xef\xae[\x80-\xb1]|\xef\xaf[\x93-\xbf]|\xef\xb4[\x80-\xbd]|\xef\xb5[\x90-\xbf]|\xef\xb6[\x80-\x8f\x92-\xbf]|\xef\xb7[\x80-\x87\xb0-\xbb]|\xef\xb9[\xb0-\xb4\xb6-\xbf]|\xef\xbb[\x80-\xbc]
UnicodeIDStart_5 \xef\xbc[\xa1-\xba]|\xef\xbd[\x81-\x9a\xa6-\xbf]|\xef\xbe[\x80-\xbe]|\xef\xbf[\x82-\x87\x8a-\x8f\x92-\x97\x9a-\x9c]|\xef[\xa4-\xa8\xaa\xb0-\xb3\xba][\x80-\xbf]|[\xe5-\xe8\xeb\xec][\x80-\xbf]{2}|\xf0\x90\x80[\x80-\x8b\x8d-\xa6\xa8-\xba\xbc\xbd\xbf]|\xf0\x90\x81[\x80-\x8d\x90-\x9d]|\xf0\x90\x83[\x80-\xba]|\xf0\x90\x85[\x80-\xb4]|\xf0\x90\x8a[\x80-\x9c\xa0-\xbf]|\xf0\x90\x8b[\x80-\x90]|\xf0\x90\x8c[\x80-\x9f\xb0-\xbf]|\xf0\x90\x8d[\x80-\x8a\x90-\xb5]|\xf0\x90\x8e[\x80-\x9d\xa0-\xbf]|\xf0\x90\x8f[\x80-\x83\x88-\x8f\x91-\x95]|\xf0\x90\x92[\x80-\x9d]|\xf0\x90\x94[\x80-\xa7\xb0-\xbf]|\xf0\x90\x95[\x80-\xa3]|\xf0\x90\x9c[\x80-\xb6]|\xf0\x90\x9d[\x80-\x95\xa0-\xa7]|\xf0\x90\xa0[\x80-\x85\x88\x8a-\xb5\xb7\xb8\xbc\xbf]|\xf0\x90\xa1[\x80-\x95\xa0-\xb6]|\xf0\x90\xa2[\x80-\x9e]|\xf0\x90\xa3[\xa0-\xb2\xb4\xb5]|\xf0\x90\xa4[\x80-\x95\xa0-\xb9]|\xf0\x90\xa6[\x80-\xb7\xbe\xbf]|\xf0\x90\xa8[\x80\x90-\x93\x95-\x97\x99-\xb3]|\xf0\x90\xa9[\xa0-\xbc]|\xf0\x90\xaa[\x80-\x9c]|\xf0\x90\xab[\x80-\x87\x89-\xa4]|\xf0\x90\xac[\x80-\xb5]
UnicodeIDStart_6 \xf0\x90\xad[\x80-\x95\xa0-\xb2]|\xf0\x90\xae[\x80-\x91]|\xf0\x90\xb1[\x80-\x88]|\xf0\x90\xb2[\x80-\xb2]|\xf0\x90\xb3[\x80-\xb2]|\xf0\x90[\x82\x90\x91\x98-\x9b\xb0][\x80-\xbf]|\xf0\x91\x80[\x83-\xb7]|\xf0\x91\x82[\x83-\xaf]|\xf0\x91\x83[\x90-\xa8]|\xf0\x91\x84[\x83-\xa6]|\xf0\x91\x85[\x90-\xb2\xb6]|\xf0\x91\x86[\x83-\xb2]|\xf0\x91\x87[\x81-\x84\x9a\x9c]|\xf0\x91\x88[\x80-\x91\x93-\xab]|\xf0\x91\x8a[\x80-\x86\x88\x8a-\x8d\x8f-\x9d\x9f-\xa8\xb0-\xbf]|\xf0\x91\x8b[\x80-\x9e]|\xf0\x91\x8c[\x85-\x8c\x8f\x90\x93-\xa8\xaa-\xb0\xb2\xb3\xb5-\xb9\xbd]|\xf0\x91\x8d[\x90\x9d-\xa1]|\xf0\x91\x92[\x80-\xaf]|\xf0\x91\x93[\x84\x85\x87]|\xf0\x91\x96[\x80-\xae]|\xf0\x91\x97[\x98-\x9b]|\xf0\x91\x98[\x80-\xaf]|\xf0\x91\x99[\x84]|\xf0\x91\x9a[\x80-\xaa]|\xf0\x91\x9c[\x80-\x99]|\xf0\x91\xa2[\xa0-\xbf]|\xf0\x91\xa3[\x80-\x9f\xbf]|\xf0\x91\xab[\x80-\xb8]|\xf0\x92\x8e[\x80-\x99]|\xf0\x92\x91[\x80-\xae]|\xf0\x92\x95[\x80-\x83]|\xf0\x92[\x80-\x8d\x90\x92-\x94][\x80-\xbf]|\xf0\x93\x90[\x80-\xae]|\xf0\x93[\x80-\x8f][\x80-\xbf]
UnicodeIDStart_7 \xf0\x94\x99[\x80-\x86]|\xf0\x94[\x90-\x98][\x80-\xbf]|\xf0\x96\xa8[\x80-\xb8]|\xf0\x96\xa9[\x80-\x9e]|\xf0\x96\xab[\x90-\xad]|\xf0\x96\xac[\x80-\xaf]|\xf0\x96\xad[\x80-\x83\xa3-\xb7\xbd-\xbf]|\xf0\x96\xae[\x80-\x8f]|\xf0\x96\xbd[\x80-\x84\x90]|\xf0\x96\xbe[\x93-\x9f]|\xf0\x96[\xa0-\xa7\xbc][\x80-\xbf]|\xf0\x9b\x80[\x80\x81]|\xf0\x9b\xb1[\x80-\xaa\xb0-\xbc]|\xf0\x9b\xb2[\x80-\x88\x90-\x99]|\xf0\x9b[\xb0][\x80-\xbf]|\xf0\x9d\x91[\x80-\x94\x96-\xbf]|\xf0\x9d\x92[\x80-\x9c\x9e\x9f\xa2\xa5\xa6\xa9-\xac\xae-\xb9\xbb\xbd-\xbf]|\xf0\x9d\x93[\x80-\x83\x85-\xbf]|\xf0\x9d\x94[\x80-\x85\x87-\x8a\x8d-\x94\x96-\x9c\x9e-\xb9\xbb-\xbe]|\xf0\x9d\x95[\x80-\x84\x86\x8a-\x90\x92-\xbf]|\xf0\x9d\x9a[\x80-\xa5\xa8-\xbf]|\xf0\x9d\x9b[\x80\x82-\x9a\x9c-\xba\xbc-\xbf]|\xf0\x9d\x9c[\x80-\x94\x96-\xb4\xb6-\xbf]|\xf0\x9d\x9d[\x80-\x8e\x90-\xae\xb0-\xbf]|\xf0\x9d\x9e[\x80-\x88\x8a-\xa8\xaa-\xbf]|\xf0\x9d\x9f[\x80-\x82\x84-\x8b]|\xf0\x9d[\x90\x96-\x99][\x80-\xbf]|\xf0\x9e\xa3[\x80-\x84]|\xf0\x9e\xb8[\x80-\x83\x85-\x9f\xa1\xa2\xa4\xa7\xa9-\xb2\xb4-\xb7\xb9\xbb]
UnicodeIDStart {UnicodeIDStart_0}|{UnicodeIDStart_1}|{UnicodeIDStart_2}|{UnicodeIDStart_3}|{UnicodeIDStart_4}|{UnicodeIDStart_5}|{UnicodeIDStart_6}|{UnicodeIDStart_7}|\xf0\x9e\xb9[\x82\x87\x89\x8b\x8d-\x8f\x91\x92\x94\x97\x99\x9b\x9d\x9f\xa1\xa2\xa4\xa7-\xaa\xac-\xb2\xb4-\xb7\xb9-\xbc\xbe]|\xf0\x9e\xba[\x80-\x89\x8b-\x9b\xa1-\xa3\xa5-\xa9\xab-\xbb]|\xf0\x9e[\xa0-\xa2][\x80-\xbf]|\xf0\xaa\x9b[\x80-\x96]|\xf0\xaa[\x80-\x9a\x9c-\xbf][\x80-\xbf]|\xf0\xab\x9c[\x80-\xb4]|\xf0\xab\xa0[\x80-\x9d\xa0-\xbf]|\xf0\xab[\x80-\x9b\x9d-\x9f\xa1-\xbf][\x80-\xbf]|\xf0\xac\xba[\x80-\xa1]|\xf0\xac[\x80-\xb9][\x80-\xbf]|\xf0\xaf\xa8[\x80-\x9d]|\xf0\xaf[\xa0-\xa7][\x80-\xbf]|\xf0[\xa0-\xa9][\x80-\xbf]{2}
UnicodeIDContinue_0 [\x30-\x39\x41-\x5a\x5f\x61-\x7a]|\xc2[\xaa\xb5\xb7\xba]|\xc3[\x80-\x96\x98-\xb6\xb8-\xbf]|\xcb[\x80\x81\x86-\x91\xa0-\xa4\xac\xae]|\xcd[\x80-\xb4\xb6\xb7\xba-\xbd\xbf]|\xce[\x86-\x8a\x8c\x8e-\xa1\xa3-\xbf]|\xcf[\x80-\xb5\xb7-\xbf]|\xd2[\x80\x81\x83-\x87\x8a-\xbf]|\xd4[\x80-\xaf\xb1-\xbf]|\xd5[\x80-\x96\x99\xa1-\xbf]|\xd6[\x80-\x87\x91-\xbd\xbf]|\xd7[\x81\x82\x84\x85\x87\x90-\xaa\xb0-\xb2]|\xd8[\x90-\x9a\xa0-\xbf]|\xd9[\x80-\xa9\xae-\xbf]|\xdb[\x80-\x93\x95-\x9c\x9f-\xa8\xaa-\xbc\xbf]|\xdc[\x90-\xbf]|\xdd[\x80-\x8a\x8d-\xbf]|\xde[\x80-\xb1]|\xdf[\x80-\xb5\xba]|[\xc4-\xca\xcc\xd0\xd1\xd3\xda][\x80-\xbf]|\xe0\xa0[\x80-\xad]|\xe0\xa1[\x80-\x9b]|\xe0\xa2[\xa0-\xb4]|\xe0\xa3[\xa3-\xbf]|\xe0\xa5[\x80-\xa3\xa6-\xaf\xb1-\xbf]|\xe0\xa6[\x80-\x83\x85-\x8c\x8f\x90\x93-\xa8\xaa-\xb0\xb2\xb6-\xb9\xbc-\xbf]|\xe0\xa7[\x80-\x84\x87\x88\x8b-\x8e\x97\x9c\x9d\x9f-\xa3\xa6-\xb1]|\xe0\xa8[\x81-\x83\x85-\x8a\x8f\x90\x93-\xa8\xaa-\xb0\xb2\xb3\xb5\xb6\xb8\xb9\xbc\xbe\xbf]|\xe0\xa9[\x80-\x82\x87\x88\x8b-\x8d\x91\x99-\x9c\x9e\xa6-\xb5]
UnicodeIDContinue_1 \xe0\xaa[\x81-\x83\x85-\x8d\x8f-\x91\x93-\xa8\xaa-\xb0\xb2\xb3\xb5-\xb9\xbc-\xbf]|\xe0\xab[\x80-\x85\x87-\x89\x8b-\x8d\x90\xa0-\xa3\xa6-\xaf\xb9]|\xe0\xac[\x81-\x83\x85-\x8c\x8f\x90\x93-\xa8\xaa-\xb0\xb2\xb3\xb5-\xb9\xbc-\xbf]|\xe0\xad[\x80-\x84\x87\x88\x8b-\x8d\x96\x97\x9c\x9d\x9f-\xa3\xa6-\xaf\xb1]|\xe0\xae[\x82\x83\x85-\x8a\x8e-\x90\x92-\x95\x99\x9a\x9c\x9e\x9f\xa3\xa4\xa8-\xaa\xae-\xb9\xbe\xbf]|\xe0\xaf[\x80-\x82\x86-\x88\x8a-\x8d\x90\x97\xa6-\xaf]|\xe0\xb0[\x80-\x83\x85-\x8c\x8e-\x90\x92-\xa8\xaa-\xb9\xbd-\xbf]|\xe0\xb1[\x80-\x84\x86-\x88\x8a-\x8d\x95\x96\x98-\x9a\xa0-\xa3\xa6-\xaf]|\xe0\xb2[\x81-\x83\x85-\x8c\x8e-\x90\x92-\xa8\xaa-\xb3\xb5-\xb9\xbc-\xbf]|\xe0\xb3[\x80-\x84\x86-\x88\x8a-\x8d\x95\x96\x9e\xa0-\xa3\xa6-\xaf\xb1\xb2]|\xe0\xb4[\x81-\x83\x85-\x8c\x8e-\x90\x92-\xba\xbd-\xbf]|\xe0\xb5[\x80-\x84\x86-\x88\x8a-\x8e\x97\x9f-\xa3\xa6-\xaf\xba-\xbf]|\xe0\xb6[\x82\x83\x85-\x96\x9a-\xb1\xb3-\xbb\xbd]|\xe0\xb7[\x80-\x86\x8a\x8f-\x94\x96\x98-\x9f\xa6-\xaf\xb2\xb3]|\xe0\xb8[\x81-\xba]
UnicodeIDContinue_2 \xe0\xb9[\x80-\x8e\x90-\x99]|\xe0\xba[\x81\x82\x84\x87\x88\x8a\x8d\x94-\x97\x99-\x9f\xa1-\xa3\xa5\xa7\xaa\xab\xad-\xb9\xbb-\xbd]|\xe0\xbb[\x80-\x84\x86\x88-\x8d\x90-\x99\x9c-\x9f]|\xe0\xbc[\x80\x98\x99\xa0-\xa9\xb5\xb7\xb9\xbe\xbf]|\xe0\xbd[\x80-\x87\x89-\xac\xb1-\xbf]|\xe0\xbe[\x80-\x84\x86-\x97\x99-\xbc]|\xe0\xbf[\x86]|\xe0[\xa4][\x80-\xbf]|\xe1\x81[\x80-\x89\x90-\xbf]|\xe1\x82[\x80-\x9d\xa0-\xbf]|\xe1\x83[\x80-\x85\x87\x8d\x90-\xba\xbc-\xbf]|\xe1\x89[\x80-\x88\x8a-\x8d\x90-\x96\x98\x9a-\x9d\xa0-\xbf]|\xe1\x8a[\x80-\x88\x8a-\x8d\x90-\xb0\xb2-\xb5\xb8-\xbe]|\xe1\x8b[\x80\x82-\x85\x88-\x96\x98-\xbf]|\xe1\x8c[\x80-\x90\x92-\x95\x98-\xbf]|\xe1\x8d[\x80-\x9a\x9d-\x9f\xa9-\xb1]|\xe1\x8e[\x80-\x8f\xa0-\xbf]|\xe1\x8f[\x80-\xb5\xb8-\xbd]|\xe1\x90[\x81-\xbf]|\xe1\x99[\x80-\xac\xaf-\xbf]|\xe1\x9a[\x81-\x9a\xa0-\xbf]|\xe1\x9b[\x80-\xaa\xae-\xb8]|\xe1\x9c[\x80-\x8c\x8e-\x94\xa0-\xb4]|\xe1\x9d[\x80-\x93\xa0-\xac\xae-\xb0\xb2\xb3]|\xe1\x9f[\x80-\x93\x97\x9c\x9d\xa0-\xa9]|\xe1\xa0[\x8b-\x8d\x90-\x99\xa0-\xbf]
UnicodeIDContinue_3 \xe1\xa1[\x80-\xb7]|\xe1\xa2[\x80-\xaa\xb0-\xbf]|\xe1\xa3[\x80-\xb5]|\xe1\xa4[\x80-\x9e\xa0-\xab\xb0-\xbb]|\xe1\xa5[\x86-\xad\xb0-\xb4]|\xe1\xa6[\x80-\xab\xb0-\xbf]|\xe1\xa7[\x80-\x89\x90-\x9a]|\xe1\xa8[\x80-\x9b\xa0-\xbf]|\xe1\xa9[\x80-\x9e\xa0-\xbc\xbf]|\xe1\xaa[\x80-\x89\x90-\x99\xa7\xb0-\xbd]|\xe1\xad[\x80-\x8b\x90-\x99\xab-\xb3]|\xe1\xaf[\x80-\xb3]|\xe1\xb0[\x80-\xb7]|\xe1\xb1[\x80-\x89\x8d-\xbd]|\xe1\xb3[\x90-\x92\x94-\xb6\xb8\xb9]|\xe1\xb7[\x80-\xb5\xbc-\xbf]|\xe1\xbc[\x80-\x95\x98-\x9d\xa0-\xbf]|\xe1\xbd[\x80-\x85\x88-\x8d\x90-\x97\x99\x9b\x9d\x9f-\xbd]|\xe1\xbe[\x80-\xb4\xb6-\xbc\xbe]|\xe1\xbf[\x82-\x84\x86-\x8c\x90-\x93\x96-\x9b\xa0-\xac\xb2-\xb4\xb6-\xbc]|\xe1[\x80\x84-\x88\x91-\x98\x9e\xac\xae\xb4-\xb6\xb8-\xbb][\x80-\xbf]|\xe2\x80[\xbf]|\xe2\x81[\x80\x94\xb1\xbf]|\xe2\x82[\x90-\x9c]|\xe2\x83[\x90-\x9c\xa1\xa5-\xb0]|\xe2\x84[\x82\x87\x8a-\x93\x95\x98-\x9d\xa4\xa6\xa8\xaa-\xb9\xbc-\xbf]|\xe2\x85[\x85-\x89\x8e\xa0-\xbf]|\xe2\x86[\x80-\x88]|\xe2\xb0[\x80-\xae\xb0-\xbf]|\xe2\xb1[\x80-\x9e\xa0-\xbf]
UnicodeIDContinue_4 \xe2\xb3[\x80-\xa4\xab-\xb3]|\xe2\xb4[\x80-\xa5\xa7\xad\xb0-\xbf]|\xe2\xb5[\x80-\xa7\xaf\xbf]|\xe2\xb6[\x80-\x96\xa0-\xa6\xa8-\xae\xb0-\xb6\xb8-\xbe]|\xe2\xb7[\x80-\x86\x88-\x8e\x90-\x96\x98-\x9e\xa0-\xbf]|\xe2[\xb2][\x80-\xbf]|\xe3\x80[\x85-\x87\xa1-\xaf\xb1-\xb5\xb8-\xbc]|\xe3\x81[\x81-\xbf]|\xe3\x82[\x80-\x96\x99-\x9f\xa1-\xbf]|\xe3\x83[\x80-\xba\xbc-\xbf]|\xe3\x84[\x85-\xad\xb1-\xbf]|\xe3\x86[\x80-\x8e\xa0-\xba]|\xe3\x87[\xb0-\xbf]|\xe3[\x85\x90-\xbf][\x80-\xbf]|\xe4\xb6[\x80-\xb5]|\xe4[\x80-\xb5\xb8-\xbf][\x80-\xbf]|\xe9\xbf[\x80-\x95]|\xe9[\x80-\xbe][\x80-\xbf]|\xea\x92[\x80-\x8c]|\xea\x93[\x90-\xbd]|\xea\x98[\x80-\x8c\x90-\xab]|\xea\x99[\x80-\xaf\xb4-\xbd\xbf]|\xea\x9b[\x80-\xb1]|\xea\x9c[\x97-\x9f\xa2-\xbf]|\xea\x9e[\x80-\x88\x8b-\xad\xb0-\xb7]|\xea\x9f[\xb7-\xbf]|\xea\xa0[\x80-\xa7]|\xea\xa1[\x80-\xb3]|\xea\xa3[\x80-\x84\x90-\x99\xa0-\xb7\xbb\xbd]|\xea\xa4[\x80-\xad\xb0-\xbf]|\xea\xa5[\x80-\x93\xa0-\xbc]|\xea\xa7[\x80\x8f-\x99\xa0-\xbe]|\xea\xa8[\x80-\xb6]|\xea\xa9[\x80-\x8d\x90-\x99\xa0-\xb6\xba-\xbf]
UnicodeIDContinue_5 \xea\xab[\x80-\x82\x9b-\x9d\xa0-\xaf\xb2-\xb6]|\xea\xac[\x81-\x86\x89-\x8e\x91-\x96\xa0-\xa6\xa8-\xae\xb0-\xbf]|\xea\xad[\x80-\x9a\x9c-\xa5\xb0-\xbf]|\xea\xaf[\x80-\xaa\xac\xad\xb0-\xb9]|\xea[\x80-\x91\x94-\x97\x9a\x9d\xa2\xa6\xaa\xae\xb0-\xbf][\x80-\xbf]|\xed\x9e[\x80-\xa3\xb0-\xbf]|\xed\x9f[\x80-\x86\x8b-\xbb]|\xed[\x80-\x9d][\x80-\xbf]|\xef\xa9[\x80-\xad\xb0-\xbf]|\xef\xab[\x80-\x99]|\xef\xac[\x80-\x86\x93-\x97\x9d-\xa8\xaa-\xb6\xb8-\xbc\xbe]|\xef\xad[\x80\x81\x83\x84\x86-\xbf]|\xef\xae[\x80-\xb1]|\xef\xaf[\x93-\xbf]|\xef\xb4[\x80-\xbd]|\xef\xb5[\x90-\xbf]|\xef\xb6[\x80-\x8f\x92-\xbf]|\xef\xb7[\x80-\x87\xb0-\xbb]|\xef\xb8[\x80-\x8f\xa0-\xaf\xb3\xb4]|\xef\xb9[\x8d-\x8f\xb0-\xb4\xb6-\xbf]|\xef\xbb[\x80-\xbc]|\xef\xbc[\x90-\x99\xa1-\xba\xbf]|\xef\xbd[\x81-\x9a\xa6-\xbf]|\xef\xbe[\x80-\xbe]|\xef\xbf[\x82-\x87\x8a-\x8f\x92-\x97\x9a-\x9c]|\xef[\xa4-\xa8\xaa\xb0-\xb3\xba][\x80-\xbf]|[\xe5-\xe8\xeb\xec][\x80-\xbf]{2}|\xf0\x90\x80[\x80-\x8b\x8d-\xa6\xa8-\xba\xbc\xbd\xbf]|\xf0\x90\x81[\x80-\x8d\x90-\x9d]
UnicodeIDContinue_6 \xf0\x90\x83[\x80-\xba]|\xf0\x90\x85[\x80-\xb4]|\xf0\x90\x87[\xbd]|\xf0\x90\x8a[\x80-\x9c\xa0-\xbf]|\xf0\x90\x8b[\x80-\x90\xa0]|\xf0\x90\x8c[\x80-\x9f\xb0-\xbf]|\xf0\x90\x8d[\x80-\x8a\x90-\xba]|\xf0\x90\x8e[\x80-\x9d\xa0-\xbf]|\xf0\x90\x8f[\x80-\x83\x88-\x8f\x91-\x95]|\xf0\x90\x92[\x80-\x9d\xa0-\xa9]|\xf0\x90\x94[\x80-\xa7\xb0-\xbf]|\xf0\x90\x95[\x80-\xa3]|\xf0\x90\x9c[\x80-\xb6]|\xf0\x90\x9d[\x80-\x95\xa0-\xa7]|\xf0\x90\xa0[\x80-\x85\x88\x8a-\xb5\xb7\xb8\xbc\xbf]|\xf0\x90\xa1[\x80-\x95\xa0-\xb6]|\xf0\x90\xa2[\x80-\x9e]|\xf0\x90\xa3[\xa0-\xb2\xb4\xb5]|\xf0\x90\xa4[\x80-\x95\xa0-\xb9]|\xf0\x90\xa6[\x80-\xb7\xbe\xbf]|\xf0\x90\xa8[\x80-\x83\x85\x86\x8c-\x93\x95-\x97\x99-\xb3\xb8-\xba\xbf]|\xf0\x90\xa9[\xa0-\xbc]|\xf0\x90\xaa[\x80-\x9c]|\xf0\x90\xab[\x80-\x87\x89-\xa6]|\xf0\x90\xac[\x80-\xb5]|\xf0\x90\xad[\x80-\x95\xa0-\xb2]|\xf0\x90\xae[\x80-\x91]|\xf0\x90\xb1[\x80-\x88]|\xf0\x90\xb2[\x80-\xb2]|\xf0\x90\xb3[\x80-\xb2]|\xf0\x90[\x82\x90\x91\x98-\x9b\xb0][\x80-\xbf]|\xf0\x91\x81[\x80-\x86\xa6-\xaf\xbf]
UnicodeIDContinue_7 \xf0\x91\x82[\x80-\xba]|\xf0\x91\x83[\x90-\xa8\xb0-\xb9]|\xf0\x91\x84[\x80-\xb4\xb6-\xbf]|\xf0\x91\x85[\x90-\xb3\xb6]|\xf0\x91\x87[\x80-\x84\x8a-\x8c\x90-\x9a\x9c]|\xf0\x91\x88[\x80-\x91\x93-\xb7]|\xf0\x91\x8a[\x80-\x86\x88\x8a-\x8d\x8f-\x9d\x9f-\xa8\xb0-\xbf]|\xf0\x91\x8b[\x80-\xaa\xb0-\xb9]|\xf0\x91\x8c[\x80-\x83\x85-\x8c\x8f\x90\x93-\xa8\xaa-\xb0\xb2\xb3\xb5-\xb9\xbc-\xbf]|\xf0\x91\x8d[\x80-\x84\x87\x88\x8b-\x8d\x90\x97\x9d-\xa3\xa6-\xac\xb0-\xb4]|\xf0\x91\x93[\x80-\x85\x87\x90-\x99]|\xf0\x91\x96[\x80-\xb5\xb8-\xbf]|\xf0\x91\x97[\x80\x98-\x9d]|\xf0\x91\x99[\x80\x84\x90-\x99]|\xf0\x91\x9a[\x80-\xb7]|\xf0\x91\x9b[\x80-\x89]|\xf0\x91\x9c[\x80-\x99\x9d-\xab\xb0-\xb9]|\xf0\x91\xa2[\xa0-\xbf]|\xf0\x91\xa3[\x80-\xa9\xbf]|\xf0\x91\xab[\x80-\xb8]|\xf0\x91[\x80\x86\x92\x98][\x80-\xbf]|\xf0\x92\x8e[\x80-\x99]|\xf0\x92\x91[\x80-\xae]|\xf0\x92\x95[\x80-\x83]|\xf0\x92[\x80-\x8d\x90\x92-\x94][\x80-\xbf]|\xf0\x93\x90[\x80-\xae]|\xf0\x93[\x80-\x8f][\x80-\xbf]|\xf0\x94\x99[\x80-\x86]|\xf0\x94[\x90-\x98][\x80-\xbf]
UnicodeIDContinue_8 \xf0\x96\xa8[\x80-\xb8]|\xf0\x96\xa9[\x80-\x9e\xa0-\xa9]|\xf0\x96\xab[\x90-\xad\xb0-\xb4]|\xf0\x96\xac[\x80-\xb6]|\xf0\x96\xad[\x80-\x83\x90-\x99\xa3-\xb7\xbd-\xbf]|\xf0\x96\xae[\x80-\x8f]|\xf0\x96\xbd[\x80-\x84\x90-\xbe]|\xf0\x96\xbe[\x8f-\x9f]|\xf0\x96[\xa0-\xa7\xbc][\x80-\xbf]|\xf0\x9b\x80[\x80\x81]|\xf0\x9b\xb1[\x80-\xaa\xb0-\xbc]|\xf0\x9b\xb2[\x80-\x88\x90-\x99\x9d\x9e]|\xf0\x9b[\xb0][\x80-\xbf]|\xf0\x9d\x85[\xa5-\xa9\xad-\xb2\xbb-\xbf]|\xf0\x9d\x86[\x80-\x82\x85-\x8b\xaa-\xad]|\xf0\x9d\x89[\x82-\x84]|\xf0\x9d\x91[\x80-\x94\x96-\xbf]|\xf0\x9d\x92[\x80-\x9c\x9e\x9f\xa2\xa5\xa6\xa9-\xac\xae-\xb9\xbb\xbd-\xbf]|\xf0\x9d\x93[\x80-\x83\x85-\xbf]|\xf0\x9d\x94[\x80-\x85\x87-\x8a\x8d-\x94\x96-\x9c\x9e-\xb9\xbb-\xbe]|\xf0\x9d\x95[\x80-\x84\x86\x8a-\x90\x92-\xbf]|\xf0\x9d\x9a[\x80-\xa5\xa8-\xbf]|\xf0\x9d\x9b[\x80\x82-\x9a\x9c-\xba\xbc-\xbf]|\xf0\x9d\x9c[\x80-\x94\x96-\xb4\xb6-\xbf]|\xf0\x9d\x9d[\x80-\x8e\x90-\xae\xb0-\xbf]|\xf0\x9d\x9e[\x80-\x88\x8a-\xa8\xaa-\xbf]|\xf0\x9d\x9f[\x80-\x82\x84-\x8b\x8e-\xbf]
UnicodeIDContinue {UnicodeIDContinue_0}|{UnicodeIDContinue_1}|{UnicodeIDContinue_2}|{UnicodeIDContinue_3}|{UnicodeIDContinue_4}|{UnicodeIDContinue_5}|{UnicodeIDContinue_6}|{UnicodeIDContinue_7}|{UnicodeIDContinue_8}|\xf0\x9d\xa8[\x80-\xb6\xbb-\xbf]|\xf0\x9d\xa9[\x80-\xac\xb5]|\xf0\x9d\xaa[\x84\x9b-\x9f\xa1-\xaf]|\xf0\x9d[\x90\x96-\x99][\x80-\xbf]|\xf0\x9e\xa3[\x80-\x84\x90-\x96]|\xf0\x9e\xb8[\x80-\x83\x85-\x9f\xa1\xa2\xa4\xa7\xa9-\xb2\xb4-\xb7\xb9\xbb]|\xf0\x9e\xb9[\x82\x87\x89\x8b\x8d-\x8f\x91\x92\x94\x97\x99\x9b\x9d\x9f\xa1\xa2\xa4\xa7-\xaa\xac-\xb2\xb4-\xb7\xb9-\xbc\xbe]|\xf0\x9e\xba[\x80-\x89\x8b-\x9b\xa1-\xa3\xa5-\xa9\xab-\xbb]|\xf0\x9e[\xa0-\xa2][\x80-\xbf]|\xf0\xaa\x9b[\x80-\x96]|\xf0\xaa[\x80-\x9a\x9c-\xbf][\x80-\xbf]|\xf0\xab\x9c[\x80-\xb4]|\xf0\xab\xa0[\x80-\x9d\xa0-\xbf]|\xf0\xab[\x80-\x9b\x9d-\x9f\xa1-\xbf][\x80-\xbf]|\xf0\xac\xba[\x80-\xa1]|\xf0\xac[\x80-\xb9][\x80-\xbf]|\xf0\xaf\xa8[\x80-\x9d]|\xf0\xaf[\xa0-\xa7][\x80-\xbf]|\xf0[\xa0-\xa9][\x80-\xbf]{2}|\xf3\xa0\x87[\x80-\xaf]|\xf3\xa0[\x84-\x86][\x80-\xbf]
IdentifierMore [$_]

UnicodeStart {IdentifierMore}|{UnicodeIDStart}
UnicodePart {IdentifierMore}|\xe2\x80[\x8c\x8d]|{UnicodeIDContinue}
UnicodeScrap {U2}|{U3}{U0}{0,1}|{U4}{U0}{0,2}|{UN}|{U0}
UnicodeError ({U2}|{U3}{U0}{0,1}|{U4}{U0}{0,2}){UE}|{UN}|{U0}

IdentifierStart {UnicodeStart}|{UnicodeEscape}
IdentifierPart {UnicodePart}|{UnicodeEscape}
IdentifierFail {UnicodeError}|\\(u({HexDigit}{0,3}|\{{HexDigit}*))?
IdentifierScrap {IdentifierPart}*{IdentifierFail}?

RegularExpressionBackslashSequence \\{NoneTerminatorCharacter}
RegularExpressionClassChars ({RegClsCharacter}|{RegularExpressionBackslashSequence})*

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

    /* Operator {{{ */
"..."  PeriodPeriodPeriod
//".."   L E("invalid operator")



"&"    Ampersand
"&&"   AmpersandAmpersand
"&="   AmpersandEqual
"^"    Carrot
"^="   CarrotEqual
"="    Equal
"=="   EqualEqual
"==="  EqualEqualEqual
"=>"   EqualRight
"!"    Exclamation
"!="   ExclamationEqual
"!=="  ExclamationEqualEqual
"-"    Hyphen
"-="   HyphenEqual
"--"   HyphenHyphen
"->"   HyphenRight
"<"    Left
"<="   LeftEqual
"<<"   LeftLeft
"<<="  LeftLeftEqual
"%"    Percent
"%="   PercentEqual
"."    Period
"?."   QuestionPeriod
"|"    Pipe
"|="   PipeEqual
"||"   PipePipe
"+"    Plus
"+="   PlusEqual
"++"   PlusPlus
">"    Right
">="   RightEqual
">>"   RightRight
">>="  RightRightEqual
">>>"  RightRightRight
">>>=" RightRightRightEqual
"*"    Star
"*="   StarEqual
"~"    Tilde

"/"  Slash
"/=" SlashEqual

":"    Colon
"::"   ColonColon
","    Comma
"?"    Question
";"    SemiColon
//"#"    Pound

"("    OpenParen
")"    CloseParen

"{"    OpenBrace
"}" CloseBrace

"["    OpenBracket
"]"    CloseBracket
    /* }}} */

    /* Keyword {{{ */
//"@error"          At_error_
"@encode"         At_encode_
"@import"	"@import"

"undefined"       "undefined"

    /* Reserved {{{ */
"abstract"        "abstract"
"as"              "as"
"await"           "await"
"boolean"         "boolean"
"break"           "break"
"byte"            "byte"
"case"            "case"
"catch"           "catch"
"char"            "char"
"class"           "class"
"const"           "const"
"constructor"     "constructor"
"continue"        "continue"
"debugger"        "debugger"
"default"         "default"
"delete"          "delete"
"do"              "do"
"double"          "double"
"else"            "else"
"enum"            "enum"
"export"          "export"
"extends"         "extends"
"eval"            "eval"
"false"           "false"
"final"           "final"
"finally"         "finally"
"float"           "float"
"for"             "for"
"from"            "from"
"function"        "function"
"goto"            "goto"
"get"             "get"
"if"              "if"
"implements"      "implements"
"import"          "import"
"in"              "in"
"Infinity"        "Infinity"
"instanceof"      "instanceof"
"int"             "int"
"__int128"        "__int128"
"interface"       "interface"
"let"             "let"
"long"            "long"
"native"          "native"
"new"             "new"
"null"            "null"
"package"         "package"
"private"         "private"
"protected"       "protected"
"__proto__"       "__proto__"
"prototype"       "prototype"
"public"          "public"
"return"          "return"
"set"             "set"
"short"           "short"
"static"          "static"
"super"           "super"
"switch"          "switch"
"synchronized"    "synchronized"
"target"          "target"
"this"            "this"
"throw"           "throw"
"throws"          "throws"
"transient"       "transient"
"true"            "true"
"try"             "try"
"typeid"          "typeid"
"typeof"          "typeof"
"var"             "var"
"void"            "void"
"volatile"        "volatile"
"while"           "while"
"with"            "with"
"yield"           "yield"

"each"            "each"
"of"              "of"

"extern"          "extern"
"signed"          "signed"
"struct"          "struct"
"typedef"         "typedef"
"unsigned"        "unsigned"

";class"	";class"
"!in"	"!in"
"!of"	"!of"
"!let"	"!let"
";{"	";{"
"let {"	"let {"
"let ["	"let ["
";function"	";function"
"!yield"	"!yield"
"yield *"	"yield *"

AutoComplete	AutoComplete
MarkExpression	MarkExpression
MarkModule	MarkModule
MarkScript	MarkScript

    /* Number {{{ */
0[0-7]+ NumericLiteral
0[0-9]+ NumericLiteral

0[xX][0-9a-fA-F]+ NumericLiteral
0[oO][0-7]+ NumericLiteral
0[bB][0-1]+ NumericLiteral

(\.[0-9]+|(0|[1-9][0-9]*)(\.[0-9]*)?)([eE][+-]?[0-9]+)? NumericLiteral

'(\\.|[^'\r\n\\])*'	StringLiteral
\"(\\.|[^"\r\n\\])*\"	StringLiteral
"`"([^`])+"`"	NoSubstitutionTemplate

    /* Identifier {{{ */
{UnicodeStart}{UnicodePart}* Identifier_
{IdentifierStart}{IdentifierPart}*	Identifier_

%%
