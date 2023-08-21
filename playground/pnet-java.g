/*
 * java_grammar.y - Input file for Yacc that defines Java syntax
 *
 * Copyright (C) 2001 Southern Storm Software, Pty Ltd.
 * Copyright (C) 2003 Gopal.V
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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

 %x COMMENT

 %token ILLEGAL_CHARACTHER

/*Tokens*/
%token INTEGER_LITERAL
%token FLOAT_LITERAL
%token CHAR_LITERAL
//%token BOOLEAN_LITERAL
%token STRING_LITERAL
%token NULL_LITERAL
%token FALSE
%token TRUE
%token IDENTIFIER
//%token DIMS
%token ABSTRACT
%token DEFAULT
%token IF
%token PRIVATE
%token THIS
%token BOOLEAN
%token DO
%token IMPLEMENTS
%token PROTECTED
%token THROW
%token BREAK
%token DOUBLE
%token IMPORT
%token PUBLIC
%token THROWS
%token BYTE
%token ELSE
%token INSTANCEOF
%token RETURN
%token TRANSIENT
%token CASE
%token EXTENDS
%token INT
%token SHORT
%token TRY
%token CATCH
%token FINAL
%token INTERFACE
%token STATIC
%token VOID
%token CHAR
%token FINALLY
%token LONG
%token STRICTFP
%token VOLATILE
%token CLASS
%token FLOAT
%token NATIVE
%token SUPER
%token WHILE
%token CONST
%token FOR
%token NEW
%token SWITCH
%token CONTINUE
%token GOTO
%token PACKAGE_KEY
%token SYNCHRONIZED
%token AND_OP
%token OR_OP
%token INC_OP
%token DEC_OP
%token SHL_OP
%token SHR_OP
%token USHR_OP
%token L_OP
%token G_OP
%token LE_OP
%token GE_OP
%token EQ_OP
%token NEQ_OP
%token ADD_ASSIGN_OP
%token SUB_ASSIGN_OP
%token MUL_ASSIGN_OP
%token DIV_ASSIGN_OP
%token AND_ASSIGN_OP
%token OR_ASSIGN_OP
%token XOR_ASSIGN_OP
%token MOD_ASSIGN_OP
%token SHR_ASSIGN_OP
%token SHL_ASSIGN_OP
%token USHR_ASSIGN_OP
%token ';'
%token '.'
%token '*'
%token ','
%token '['
%token ']'
%token '('
%token ')'
%token '{'
%token '}'
%token '='
%token ':'
%token '?'
%token '|'
%token '^'
%token '&'
%token '+'
%token '-'
%token '/'
%token '%'
%token '~'
%token '!'


%start CompilationUnit

%%

CompilationUnit :
	ImportDeclarationZeroOrMore TypeDeclarationZeroOrMore
	| PackageDeclaration ImportDeclarationZeroOrMore TypeDeclarationZeroOrMore
	;

PackageDeclaration :
	PACKAGE_KEY PackageOrImportIdentifier ';'
	//| PACKAGE_KEY error ';'
	//| PACKAGE_KEY PackageOrImportIdentifier error
	;

PackageOrImportIdentifier :
	IDENTIFIER
	| PackageOrImportIdentifier '.' IDENTIFIER
	;

ImportDeclarationZeroOrMore :
	/*empty*/
	| ImportDeclarationZeroOrMore ImportDeclaration
	;

ImportDeclaration :
	IMPORT PackageOrImportIdentifier '.' IDENTIFIER ';'
	| IMPORT PackageOrImportIdentifier '.' '*' ';'
	//| IMPORT error ';'
	//| IMPORT PackageOrImportIdentifier '.' '*' error
	//| IMPORT PackageOrImportIdentifier error
	;

PrimitiveType :
	BYTE
	| SHORT
	| CHAR
	| INT
	| LONG
	| FLOAT
	| DOUBLE
	| BOOLEAN
	| VOID
	;

Literal :
	INTEGER_LITERAL
	| FLOAT_LITERAL
	| CHAR_LITERAL
	| STRING_LITERAL
	| NULL_LITERAL
	| FALSE
	| TRUE
	;

Identifier :
	IDENTIFIER
	;

QualifiedIdentifier :
	Identifier
	| QualifiedIdentifier '.' IDENTIFIER
	;

QualifiedIdentifierList :
	QualifiedIdentifier
	| QualifiedIdentifierList ',' QualifiedIdentifier
	;

TypeList :
	Type
	| TypeList ',' Type
	;

Type :
	PrimitiveType
	| PrimitiveType Dims
	| QualifiedIdentifier
	| QualifiedIdentifier Dims
	;

LocalVariableType :
	PrimitiveType
	| PrimitiveType Dims
	| FieldAccess
	| FieldAccess Dims
	;

DimExprs :
	DimExpr
	| DimExprs DimExpr
	;

DimExpr :
	'[' Expression ']'
	;

Dims :
	'[' ']'
	| Dims '[' ']'
	;

ModifiersOpt :
	/*empty*/
	| Modifiers
	;

Modifiers :
	Modifier
	| Modifiers Modifier
	;

Modifier :
	PROTECTED
	| PUBLIC
	| PRIVATE
	| STATIC
	| ABSTRACT
	| FINAL
	| NATIVE
	| SYNCHRONIZED
	| TRANSIENT
	| VOLATILE
	| STRICTFP
	;

TypeDeclarationZeroOrMore :
	/*empty*/
	| TypeDeclarationZeroOrMore TypeDeclaration
	;

TypeDeclaration :
	ClassOrInterfaceDeclaration
	| ';'
	;

FormalParameters :
	'(' FormalParametersList ')'
	| '(' ')'
	//| '(' error ')'
	;

FormalParametersList :
	FormalParameter
	| FormalParametersList ',' FormalParameter
	;

FormalParameter :
	FINAL Type Identifier
	| Type Identifier
	| FINAL Type Identifier Dims
	| Type Identifier Dims
	;

ArrayInitializer :
	'{' '}'
	| '{' VariableInitializersList '}'
	| '{' VariableInitializersList ',' '}'
	//| '{' VariableInitializersList error
	;

VariableInitializersList :
	VariableInitializer
	| VariableInitializersList ',' VariableInitializer
	//| error ',' VariableInitializer
	;

VariableInitializer :
	Expression
	| ArrayInitializer
	;

ConstantDeclaratorsList :
	ConstantDeclarator
	| ConstantDeclaratorsList ',' ConstantDeclarator
	;

ConstantDeclarator :
	Identifier Dims '=' VariableInitializer
	| Identifier '=' VariableInitializer
	//| Identifier Dims error VariableInitializer
	//| Identifier error VariableInitializer
	;

VariableDeclarators :
	VariableDeclarator
	| VariableDeclarators ',' VariableDeclarator
	;

VariableDeclarator :
	Identifier
	| Identifier '=' VariableInitializer
	;

ClassOrInterfaceDeclaration :
	ClassDeclaration
	| InterfaceDeclaration
	;

ClassDeclaration :
	ModifiersOpt CLASS Identifier SuperOpt ClassBody
	;

SuperOpt :
	/*empty*/
	| EXTENDS Type
	| IMPLEMENTS TypeList
	| EXTENDS Type IMPLEMENTS TypeList
	;

ClassBodyOpt :
	/*empty*/
	| ClassBody
	;

ClassBody :
	'{' ClassBodyDeclarationOneOrMore '}'
	| '{' '}'
	;

ClassBodyDeclarationOneOrMore :
	ClassBodyDeclaration
	| ClassBodyDeclarationOneOrMore ClassBodyDeclaration
	;

ClassBodyDeclaration :
	';'
	| InstanceInitializer
	| STATIC InstanceInitializer
	| ConstructorDeclaration
	| FieldDeclaration
	| MethodDeclaration
	| ClassOrInterfaceDeclaration
	;

ThrowsOpt :
	/*empty*/
	| THROWS QualifiedIdentifierList
	;

InstanceInitializer :
	Block
	;

FieldDeclaration :
	ModifiersOpt Type FieldDeclarators ';'
	//| ModifiersOpt error FieldDeclarators ';'
	//| ModifiersOpt Type FieldDeclarators error
	;

FieldDeclarators :
	FieldDeclarator
	| FieldDeclarators ',' FieldDeclarator
	;

FieldDeclarator :
	Identifier
	| Identifier '=' VariableInitializer
	| Identifier Dims
	| Identifier Dims '=' VariableInitializer
	;

ConstructorDeclaration :
	ModifiersOpt Identifier FormalParameters ThrowsOpt MethodBody
	//| ModifiersOpt Identifier FormalParameters error QualifiedIdentifierList
	//| ModifiersOpt Identifier FormalParameters THROWS error
	;

MethodDeclaration :
	ModifiersOpt Type Identifier FormalParameters ThrowsOpt MethodBody
	//| ModifiersOpt error Identifier FormalParameters
	//| ModifiersOpt Type Identifier FormalParameters error QualifiedIdentifierList
	//| ModifiersOpt Type Identifier FormalParameters THROWS error
	;

InterfaceDeclaration :
	ModifiersOpt INTERFACE Identifier ExtendsOpt InterfaceBody
	;

ExtendsOpt :
	EXTENDS TypeList
	| /*empty*/
	//| error QualifiedIdentifierList
	;

InterfaceBody :
	'{' InterfaceBodyDeclarationOneOrMore '}'
	| '{' '}'
	;

InterfaceBodyDeclarationOneOrMore :
	InterfaceBodyDeclaration
	| InterfaceBodyDeclarationOneOrMore InterfaceBodyDeclaration
	;

InterfaceBodyDeclaration :
	';'
	| InterfaceFieldDeclarator
	| InterfaceMethodDeclarator
	| ClassOrInterfaceDeclaration
	;

InterfaceFieldDeclarator :
	ModifiersOpt Type ConstantDeclaratorsList ';'
	//| ModifiersOpt error ConstantDeclaratorsList ';'
	//| ModifiersOpt Type ConstantDeclaratorsList error
	;

InterfaceMethodDeclarator :
	ModifiersOpt Type Identifier FormalParameters ';'
	//| ModifiersOpt error Identifier FormalParameters ';'
	//| ModifiersOpt Type error FormalParameters
	//| ModifiersOpt Type Identifier FormalParameters error
	;

MethodBody :
	Block
	| ';'
	;

Block :
	'{' '}'
	| '{' BlockStatements '}'
	;

BlockStatements :
	BlockStatement
	| BlockStatements BlockStatement
	;

BlockStatement :
	LocalVariableDeclaration
	| Statement
	| ClassOrInterfaceDeclaration
	;

LocalVariableDeclaration :
	FINAL LocalVariableType VariableDeclarators ';'
	| LocalVariableType VariableDeclarators ';'
	//| FINAL LocalVariableType VariableDeclarators error
	//| LocalVariableType VariableDeclarators error
	//| FINAL error VariableDeclarators ';'
	//| error VariableDeclarators ';'
	;

Statement :
	LabeledStatement
	| ForStatement
	| IfThenStatement
	| WhileStatement
	| EmptyStatement
	| SwitchStatement
	| DoStatement
	| BreakStatement
	| ContinueStatement
	| ReturnStatement
	| SynchronizedStatement
	| ThrowStatement
	| TryStatement
	| ExpressionStatement
	| Block
	;

LabeledStatement :
	Identifier ':' Statement
	;

EmptyStatement :
	';'
	;

BreakStatement :
	BREAK ';'
	| BREAK Identifier ';'
	;

ContinueStatement :
	CONTINUE ';'
	| CONTINUE Identifier ';'
	;

ReturnStatement :
	RETURN ';'
	| RETURN Expression ';'
	;

ThrowStatement :
	THROW Expression ';'
	;

IfThenStatement :
	IF '(' Expression ')' Statement
	| IF '(' Expression ')' Statement ELSE Statement
	;

WhileStatement :
	WHILE '(' Expression ')' Statement
	;

ForStatement :
	FOR '(' ForInit ';' Expression ';' ForUpdate ')' Statement
	| FOR '(' ForInit ';' ';' ForUpdate ')' Statement
	;

ForInit :
	/*empty*/
	| StatementExpressionList
	| FINAL Type VariableDeclarators
	| LocalVariableType VariableDeclarators
	;

ForUpdate :
	/*empty*/
	| StatementExpressionList
	;

DoStatement :
	DO Statement WHILE '(' Expression ')' ';'
	;

TryStatement :
	TRY Block CatchClauses
	| TRY Block CatchClauses FinallyClause
	| TRY Block FinallyClause
	;

CatchClauses :
	CatchClause
	| CatchClauses CatchClause
	;

CatchClause :
	CATCH '(' FINAL QualifiedIdentifier Identifier Dims ')' Block
	| CATCH '(' QualifiedIdentifier Identifier Dims ')' Block
	| CATCH '(' FINAL QualifiedIdentifier Identifier ')' Block
	| CATCH '(' QualifiedIdentifier Identifier ')' Block
	;

FinallyClause :
	FINALLY Block
	;

SwitchStatement :
	SWITCH '(' Expression ')' '{' SwitchBlock '}'
	;

SwitchBlock :
	/*empty*/
	| SwitchBlockStatementGroups
	| SwitchBlockStatementGroups SwitchLabels
	| SwitchLabels
	;

SwitchBlockStatementGroups :
	SwitchBlockStatementGroup
	| SwitchBlockStatementGroups SwitchBlockStatementGroup
	;

SwitchBlockStatementGroup :
	SwitchLabels BlockStatements
	;

SwitchLabels :
	CASE ConstantExpression ':'
	| DEFAULT ':'
	| SwitchLabels CASE ConstantExpression ':'
	| SwitchLabels DEFAULT ':'
	;

SynchronizedStatement :
	SYNCHRONIZED '(' Expression ')' Block
	;

ExpressionStatement :
	StatementExpression ';'
	//| StatementExpression error
	;

StatementExpression :
	Assignment
	| PreIncrementExpression
	| PreDecrementExpression
	| PostIncrementExpression
	| PostDecrementExpression
	| MethodInvocation
	| ObjectCreationExpression
	;

StatementExpressionList :
	StatementExpression
	| StatementExpressionList ',' StatementExpression
	;

ConstantExpression :
	Expression
	;

Expression :
	ConditionalExpression
	| Assignment
	;

Assignment :
	Expression '=' ConditionalExpression
	| Expression ADD_ASSIGN_OP ConditionalExpression
	| Expression SUB_ASSIGN_OP ConditionalExpression
	| Expression MUL_ASSIGN_OP ConditionalExpression
	| Expression DIV_ASSIGN_OP ConditionalExpression
	| Expression AND_ASSIGN_OP ConditionalExpression
	| Expression OR_ASSIGN_OP ConditionalExpression
	| Expression XOR_ASSIGN_OP ConditionalExpression
	| Expression MOD_ASSIGN_OP ConditionalExpression
	| Expression SHR_ASSIGN_OP ConditionalExpression
	| Expression SHL_ASSIGN_OP ConditionalExpression
	| Expression USHR_ASSIGN_OP ConditionalExpression
	;

ConditionalExpression :
	ConditionalOrExpression
	| ConditionalOrExpression '?' Expression ':' ConditionalExpression
	;

ConditionalOrExpression :
	ConditionalAndExpression
	| ConditionalOrExpression OR_OP ConditionalAndExpression
	;

ConditionalAndExpression :
	InclusiveOrExpression
	| ConditionalAndExpression AND_OP InclusiveOrExpression
	;

InclusiveOrExpression :
	ExclusiveOrExpression
	| InclusiveOrExpression '|' ExclusiveOrExpression
	;

ExclusiveOrExpression :
	AndExpression
	| ExclusiveOrExpression '^' AndExpression
	;

AndExpression :
	EqualityExpression
	| AndExpression '&' EqualityExpression
	;

EqualityExpression :
	RelationalExpression
	| EqualityExpression EQ_OP RelationalExpression
	| EqualityExpression NEQ_OP RelationalExpression
	;

RelationalExpression :
	ShiftExpression
	| RelationalExpression L_OP ShiftExpression
	| RelationalExpression G_OP ShiftExpression
	| RelationalExpression LE_OP ShiftExpression
	| RelationalExpression GE_OP ShiftExpression
	| RelationalExpression INSTANCEOF Type
	;

ShiftExpression :
	AdditiveExpression
	| ShiftExpression SHL_OP AdditiveExpression
	| ShiftExpression SHR_OP AdditiveExpression
	| ShiftExpression USHR_OP AdditiveExpression
	;

AdditiveExpression :
	MultiplicativeExpression
	| AdditiveExpression '+' MultiplicativeExpression
	| AdditiveExpression '-' MultiplicativeExpression
	;

MultiplicativeExpression :
	UnaryExpression
	| MultiplicativeExpression '*' UnaryExpression
	| MultiplicativeExpression '/' UnaryExpression
	| MultiplicativeExpression '%' UnaryExpression
	;

UnaryExpression :
	PreIncrementExpression
	| PreDecrementExpression
	| '+' UnaryExpression
	| '-' UnaryExpression
	| CastExpression
	;

PreIncrementExpression :
	INC_OP UnaryExpression
	;

PreDecrementExpression :
	DEC_OP UnaryExpression
	;

CastExpression :
	UnaryExpressionNotPlusMinus
	| '(' PrimitiveType ')' UnaryExpression
	| '(' PrimitiveType Dims ')' UnaryExpression
	| '(' Expression ')' UnaryExpressionNotPlusMinus
	;

UnaryExpressionNotPlusMinus :
	PostfixExpression
	| '~' UnaryExpression
	| '!' UnaryExpression
	;

PostfixExpression :
	Primary
	| PostIncrementExpression
	| PostDecrementExpression
	;

PostIncrementExpression :
	PostfixExpression INC_OP
	;

PostDecrementExpression :
	PostfixExpression DEC_OP
	;

Primary :
	RealPrimary
	| ArrayCreationExpression
	| ObjectCreationExpression
	;

RealPrimary :
	Literal
	| PrimitiveType '.' CLASS
	| PrimitiveType Dims '.' CLASS
	| FieldAccess
	| FieldAccess '.' CLASS
	| FieldAccess Dims '.' CLASS
	| FieldAccess '.' THIS
	| THIS
	| MethodInvocation
	| ArrayAccess
	| '(' Expression ')'
	;

FieldAccess :
	RealPrimary '.' Identifier
	| ObjectCreationExpression '.' Identifier
	| FieldAccess '.' SUPER '.' Identifier
	| FieldAccess '.' Identifier
	| SUPER '.' Identifier
	| Identifier
	;

MethodInvocation :
	FieldAccess Arguments
	| RealPrimary '.' SUPER Arguments
	| SUPER Arguments
	| THIS Arguments
	;

ArrayAccess :
	FieldAccess '[' Expression ']'
	| MethodInvocation '[' Expression ']'
	| ArrayAccess '[' Expression ']'
	;

Arguments :
	'(' ')'
	| '(' ExpressionList ')'
	;

ExpressionList :
	Expression
	| ExpressionList ',' Expression
	;

ObjectCreationExpression :
	NEW QualifiedIdentifier Arguments ClassBodyOpt
	| RealPrimary '.' NEW Identifier Arguments ClassBodyOpt
	| FieldAccess '.' NEW Identifier Arguments ClassBodyOpt
	;

ArrayCreationExpression :
	NEW PrimitiveType DimExprs Dims
	| NEW PrimitiveType DimExprs
	| NEW PrimitiveType Dims ArrayInitializer
	| NEW QualifiedIdentifier DimExprs Dims
	| NEW QualifiedIdentifier DimExprs
	| NEW QualifiedIdentifier Dims ArrayInitializer
	;

%%

DIGIT			[0-9]
HEX				[a-fA-F0-9]
IDALPHA			([a-zA-Z_]|\\u{HEX}{HEX}{HEX}{HEX}|\\U{HEX}{HEX}{HEX}{HEX}{HEX}{HEX}{HEX}{HEX})
EXPONENT		[Ee][+-]?{DIGIT}+
FTYPE			(f|F|d|D)
ITYPE			(L|l)
WHITE			[ \t\r\f\v\032]

%%

"++"					INC_OP
"--"					DEC_OP
"<<"					SHL_OP
">>"					SHR_OP
">>>"					USHR_OP
"<"						L_OP
">"						G_OP
"<="					LE_OP
">="					GE_OP
"=="					EQ_OP
"!="					NEQ_OP
"&&"					AND_OP
"||"					OR_OP
"*="					MUL_ASSIGN_OP
"/="					DIV_ASSIGN_OP
"%="					MOD_ASSIGN_OP
"+="					ADD_ASSIGN_OP
"-="					SUB_ASSIGN_OP
"<<="					SHL_ASSIGN_OP
">>="					SHR_ASSIGN_OP
">>>="					USHR_ASSIGN_OP
"&="					AND_ASSIGN_OP
"|="					OR_ASSIGN_OP
"^="					XOR_ASSIGN_OP

"abstract"				ABSTRACT
"private"				PRIVATE
"public" 				PUBLIC
"transient" 			TRANSIENT
"protected" 			PROTECTED
"final" 				FINAL
"interface" 			INTERFACE
"static" 				STATIC
"synchronized" 			SYNCHRONIZED
"throws" 				THROWS

"implements" 			IMPLEMENTS
"extends" 				EXTENDS

"if"					IF
"else" 					ELSE
"do" 					DO
"while" 				WHILE
"for" 					FOR
"try" 					TRY
"catch" 				CATCH
"throw" 				THROW
"finally" 				FINALLY
"switch" 				SWITCH
"case" 					CASE
"default"				DEFAULT

"break" 				BREAK
"continue" 				CONTINUE
"return" 				RETURN
"goto" 					GOTO

"byte" 					BYTE
"boolean" 				BOOLEAN
"class" 				CLASS
"double" 				DOUBLE
"int" 					INT
"short" 				SHORT
"void" 					VOID
"char" 					CHAR
"long" 					LONG
"float" 				FLOAT

"import" 				IMPORT
"instanceof" 			INSTANCEOF
"strictfp" 				STRICTFP
"volatile" 				VOLATILE
"native" 				NATIVE
"super" 				SUPER
"const" 				CONST
"new" 					NEW
"package" 				PACKAGE_KEY
"this"					THIS

"true"					TRUE
"false"					FALSE
"null"					NULL_LITERAL

";"	';'
"."	'.'
"*"	'*'
","	','
"["	'['
"]"	']'
"("	'('
")"	')'
"{"	'{'
"}"	'}'
"="	'='
":"	':'
"?"	'?'
"|"	'|'
"^"	'^'
"&"	'&'
"+"	'+'
"-"	'-'
"/"	'/'
"%"	'%'
"~"	'~'
"!"	'!'

{IDALPHA}({DIGIT}|{IDALPHA})*		IDENTIFIER

{DIGIT}+{EXPONENT}{FTYPE}?					FLOAT_LITERAL
{DIGIT}*"."{DIGIT}+({EXPONENT})?{FTYPE}?	FLOAT_LITERAL
{DIGIT}+{FTYPE}								FLOAT_LITERAL

0[xX]{HEX}+{ITYPE}?			INTEGER_LITERAL
{DIGIT}+{ITYPE}?			INTEGER_LITERAL

'(\\.|[^\\'])+'	CHAR_LITERAL

\"(\\.|[^\\"])*\"			STRING_LITERAL
{WHITE}+			skip()

\/\*<COMMENT>
<COMMENT>\*\/<INITIAL>	skip()
"//".*		skip() /* comment - discard */
<COMMENT>.<.>	skip() /* comment - discard */
<COMMENT>\n<.>	skip() /* comment - discard */

\n					skip()

.					ILLEGAL_CHARACTHER

%%
