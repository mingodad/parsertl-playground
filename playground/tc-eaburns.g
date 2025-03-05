//From: https://github.com/eaburns/eaburns/blob/c072bc6203ff5ae9b90e16951d5c44fbbf44e076/tc/parse.y

/*
 * parse.y defines a yacc parser for the T programming language.
 * Ethan Burns -- Created <unknown date>
 * Ethan Burns -- Added better line number support.
 *                Wed Feb 22 17:14:30 EST 2006
 */

/*Tokens*/
%token CLASS
%token DELETE
%token ELSE
%token EQ_OP
%token EXTENDS
%token IDENTIFIER
%token IF
%token INT
%token INTEGER_LITERAL
%token MAIN
%token NEW
%token NULL_LITERAL
%token OUT
%token RETURN
%token SUPER
%token THIS
%token WHILE


%start CompilationUnit

%%

CompilationUnit :
	/*empty*/
	| MainFunctionDeclaration
	| MainFunctionDeclaration ClassDeclarations
	| ClassDeclarations MainFunctionDeclaration
	| ClassDeclarations MainFunctionDeclaration ClassDeclarations
	;

MainFunctionDeclaration :
	INT MAIN '(' ')' MainFunctionBody
	;

MainFunctionBody :
	MainBlock
	;

ClassDeclarations :
	ClassDeclarations ClassDeclaration
	| ClassDeclaration
	;

ClassDeclaration :
	CLASS Identifier ClassBody
	| CLASS Identifier EXTENDS ClassType ClassBody
	;

ClassBody :
	'{' ClassBodyDeclarations '}'
	| '{' '}'
	;

ClassBodyDeclarations :
	ClassBodyDeclarations ClassBodyDeclaration
	| ClassBodyDeclaration
	;

ClassBodyDeclaration :
	ClassMemberDeclaration
	| ConstructorDeclaration
	| DestructorDeclaration
	| ';'
	;

ClassMemberDeclaration :
	FieldDeclaration
	| MethodDeclaration
	;

FieldDeclaration :
	Type VariableDeclarators ';'
	;

VariableDeclarators :
	VariableDeclarators ',' VariableDeclarator
	| VariableDeclarator
	;

VariableDeclarator :
	VariableDeclarator Dimension
	| Identifier
	;

MethodDeclaration :
	Type MethodDeclarator MethodBody
	;

MethodDeclarator :
	Identifier FormalParameters
	| MethodDeclarator Dimension
	;

MethodBody :
	Block
	;

ConstructorDeclaration :
	ConstructorDeclarator ConstructorBody
	;

ConstructorDeclarator :
	Identifier FormalParameters
	;

ConstructorBody :
	'{' ConstructorInvocation BlockStatements '}'
	| '{' ConstructorInvocation '}'
	| Block
	;

ConstructorInvocation :
	THIS Arguments ';'
	| SUPER Arguments ';'
	;

DestructorDeclaration :
	DestructorDeclarator DestructorBody
	;

DestructorDeclarator :
	'~' Identifier '(' ')'
	;

DestructorBody :
	Block
	;

FormalParameters :
	'(' FormalParameterList ')'
	| '(' ')'
	;

FormalParameterList :
	FormalParameterList ',' FormalParameter
	| FormalParameter
	;

FormalParameter :
	Type VariableDeclaratorID
	;

VariableDeclaratorID :
	VariableDeclaratorID Dimension
	| Identifier
	;

Block :
	'{' BlockStatements '}'
	| '{' '}'
	;

BlockStatements :
	BlockStatements BlockStatement
	| BlockStatement
	;

BlockStatement :
	Statement
	;

MainBlock :
	'{' MainBlockStatements '}'
	| '{' '}'
	;

MainBlockStatements :
	MainBlockStatements MainBlockStatement
	| MainBlockStatement
	;

MainBlockStatement :
	MainVariableDeclarationStatement
	| BlockStatement
	;

MainVariableDeclarationStatement :
	MainVariableDeclaration ';'
	;

MainVariableDeclaration :
	Type VariableDeclarators
	;

Statement :
	Block
	| EmptyStatement
	| ExpressionStatement
	| IfThenElseStatement
	| WhileStatement
	| ReturnStatement
	| DeleteStatement
	| OutputStatement
	;

IfThenElseStatement :
	IF ParenExpression Statement ELSE Statement
	;

WhileStatement :
	WHILE ParenExpression Statement
	;

ReturnStatement :
	RETURN ';'
	| RETURN Expression ';'
	;

DeleteStatement :
	DELETE Expression ';'
	;

OutputStatement :
	OUT Expression ';'
	;

EmptyStatement :
	';'
	;

ParenExpression :
	'(' Expression ')'
	;

ExpressionStatement :
	StatementExpression ';'
	;

StatementExpression :
	Assignment
	| MethodInvocation
	;

Expression :
	AssignmentExpression
	;

AssignmentExpression :
	Assignment
	| EqualityExpression
	;

Assignment :
	LeftHandSide AssignmentOperator AssignmentExpression
	;

LeftHandSide :
	Identifier
	| FieldAccess
	| ArrayAccess
	;

EqualityExpression :
	EqualityExpression EQ_OP RelationalExpression
	| RelationalExpression
	;

RelationalExpression :
	RelationalExpression '<' AdditiveExpression
	| RelationalExpression '>' AdditiveExpression
	| AdditiveExpression
	;

AdditiveExpression :
	AdditiveExpression '+' MultiplicativeExpression
	| AdditiveExpression '-' MultiplicativeExpression
	| MultiplicativeExpression
	;

MultiplicativeExpression :
	MultiplicativeExpression '*' UnaryExpression
	| MultiplicativeExpression '/' UnaryExpression
	| UnaryExpression
	;

UnaryExpression :
	'-' UnaryExpression
	| '!' UnaryExpression
	| CastExpression
	;

CastExpression :
	ParenExpression CastExpression
	| '(' ArrayType ')' CastExpression
	| Primary
	;

Primary :
	ArrayCreationExpression
	| Identifier
	| PrimaryNoNewArray
	;

PrimaryNoNewArray :
	ParenExpression
	| THIS
	| FieldAccess
	| MethodInvocation
	| ArrayAccess
	| ClassInstanceCreationExpression
	| Literal
	;

ClassInstanceCreationExpression :
	NEW ClassType Arguments
	;

ArrayCreationExpression :
	NEW ClassType DimensionExpressions Dimensions
	| NEW ClassType DimensionExpressions
	| NEW PrimitiveType DimensionExpressions Dimensions
	| NEW PrimitiveType DimensionExpressions
	;

DimensionExpressions :
	DimensionExpressions DimensionExpression
	| DimensionExpression
	;

DimensionExpression :
	'[' Expression ']'
	;

Dimensions :
	Dimensions Dimension
	| Dimension
	;

Dimension :
	'[' ']'
	;

FieldAccess :
	Primary '.' Identifier
	| SUPER '.' Identifier
	;

MethodInvocation :
	Identifier Arguments
	| Primary '.' Identifier Arguments
	| SUPER '.' Identifier Arguments
	;

ArrayAccess :
	Identifier DimensionExpression
	| PrimaryNoNewArray DimensionExpression
	;

Arguments :
	'(' ArgumentList ')'
	| '(' ')'
	;

ArgumentList :
	ArgumentList ',' Expression
	| Expression
	;

AssignmentOperator :
	'='
	;

Type :
	ReferenceType
	| PrimitiveType
	;

PrimitiveType :
	NumericType
	;

NumericType :
	IntegralType
	;

IntegralType :
	INT
	;

ReferenceType :
	ClassType
	| ArrayType
	;

ClassType :
	Identifier
	;

ArrayType :
	PrimitiveType Dimension
	| Identifier Dimension
	| ArrayType Dimension
	;

Identifier :
	IDENTIFIER
	;

Literal :
	INTEGER_LITERAL
	| NULL_LITERAL
	;

%%

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"!"	'!'
"("	'('
")"	')'
"*"	'*'
"+"	'+'
","	','
"-"	'-'
"."	'.'
"/"	'/'
";"	';'
"<"	'<'
"="	'='
">"	'>'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"~"	'~'

"class"	CLASS
"delete"	DELETE
"else"	ELSE
"=="	EQ_OP
"extends"	EXTENDS
"if"	IF
"int"	INT
"main"	MAIN
"new"	NEW
"null"	NULL_LITERAL
"out"	OUT
"return"	RETURN
"super"	SUPER
"this"	THIS
"while"	WHILE

[0-9]+	INTEGER_LITERAL

[A-Za-z_][A-Za-z0-9_]*	IDENTIFIER

%%
