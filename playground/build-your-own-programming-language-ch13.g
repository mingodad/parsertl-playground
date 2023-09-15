//From: https://github.com/PacktPublishing/Build-Your-Own-Programming-Language/blob/master/ch13/j0gram.y

/*Tokens*/
%token BREAK
%token DOUBLE
%token ELSE
%token FOR
%token IF
%token INT
%token RETURN
%token VOID
%token WHILE
%token IDENTIFIER
//%token CLASSNAME
%token CLASS
%token STRING
//%token BOOL
%token INTLIT
%token DOUBLELIT
%token STRINGLIT
%token BOOLLIT
%token NULLVAL
%token LESSTHANOREQUAL
%token GREATERTHANOREQUAL
%token ISEQUALTO
%token NOTEQUALTO
%token LOGICALAND
%token LOGICALOR
%token INCREMENT
%token DECREMENT
%token PUBLIC
%token STATIC
%token NEW
%token BOOLEAN
%token '{'
%token '}'
%token ';'
%token '.'
%token ','
%token '['
%token ']'
%token '('
%token ')'
%token '-'
%token '!'
%token '*'
%token '/'
%token '%'
%token '+'
%token '<'
%token '>'
%token '='


%start ClassDecl

%%

ClassDecl :
	PUBLIC CLASS IDENTIFIER ClassBody
	;

ClassBody :
	'{' ClassBodyDecls '}'
	| '{' '}'
	;

ClassBodyDecls :
	ClassBodyDecl
	| ClassBodyDecls ClassBodyDecl
	;

ClassBodyDecl :
	FieldDecl
	| MethodDecl
	| ConstructorDecl
	;

FieldDecl :
	Type VarDecls ';'
	;

Type :
	INT
	| DOUBLE
	| BOOLEAN
	| STRING
	| Name
	;

Name :
	IDENTIFIER
	| QualifiedName
	;

QualifiedName :
	Name '.' IDENTIFIER
	;

VarDecls :
	VarDeclarator
	| VarDecls ',' VarDeclarator
	;

VarDeclarator :
	IDENTIFIER
	| VarDeclarator '[' ']'
	;

MethodReturnVal :
	Type
	| VOID
	;

MethodDecl :
	MethodHeader Block
	;

MethodHeader :
	PUBLIC STATIC MethodReturnVal MethodDeclarator
	;

MethodDeclarator :
	IDENTIFIER '(' FormalParmListOpt ')'
	;

FormalParmListOpt :
	FormalParmList
	| /*empty*/
	;

FormalParmList :
	FormalParm
	| FormalParmList ',' FormalParm
	;

FormalParm :
	Type VarDeclarator
	;

ConstructorDecl :
	MethodDeclarator Block
	;

Block :
	'{' BlockStmtsOpt '}'
	;

BlockStmtsOpt :
	BlockStmts
	| /*empty*/
	;

BlockStmts :
	BlockStmt
	| BlockStmts BlockStmt
	;

BlockStmt :
	LocalVarDeclStmt
	| Stmt
	;

LocalVarDeclStmt :
	LocalVarDecl ';'
	;

LocalVarDecl :
	Type VarDecls
	;

Stmt :
	Block
	| ';'
	| ExprStmt
	| BreakStmt
	| ReturnStmt
	| IfThenStmt
	| IfThenElseStmt
	| IfThenElseIfStmt
	| WhileStmt
	| ForStmt
	;

ExprStmt :
	StmtExpr ';'
	;

StmtExpr :
	Assignment
	| MethodCall
	;

IfThenStmt :
	IF '(' Expr ')' Block
	;

IfThenElseStmt :
	IF '(' Expr ')' Block ELSE Block
	;

IfThenElseIfStmt :
	IF '(' Expr ')' Block ElseIfSequence
	| IF '(' Expr ')' Block ElseIfSequence ELSE Block
	;

ElseIfSequence :
	ElseIfStmt
	| ElseIfSequence ElseIfStmt
	;

ElseIfStmt :
	ELSE IfThenStmt
	;

WhileStmt :
	WHILE '(' Expr ')' Stmt
	;

ForStmt :
	FOR '(' ForInit ';' ExprOpt ';' ForUpdate ')' Block
	;

ForInit :
	StmtExprList
	| LocalVarDecl
	| /*empty*/
	;

ExprOpt :
	Expr
	| /*empty*/
	;

ForUpdate :
	StmtExprList
	| /*empty*/
	;

StmtExprList :
	StmtExpr
	| StmtExprList ',' StmtExpr
	;

BreakStmt :
	BREAK ';'
	| BREAK IDENTIFIER ';'
	;

ReturnStmt :
	RETURN ExprOpt ';'
	;

Literal :
	INTLIT
	| DOUBLELIT
	| BOOLLIT
	| STRINGLIT
	| NULLVAL
	;

Primary :
	Literal
	| FieldAccess
	| MethodCall
	| ArrayAccess
	| '(' Expr ')'
	| ArrayCreation
	| InstanceCreation
	;

InstanceCreation :
	NEW Name '(' ArgListOpt ')'
	;

ArrayCreation :
	NEW Type '[' Expr ']'
	;

ArgList :
	Expr
	| ArgList ',' Expr
	;

FieldAccess :
	Primary '.' IDENTIFIER
	;

ArgListOpt :
	ArgList
	| /*empty*/
	;

MethodCall :
	Name '(' ArgListOpt ')'
	| Primary '.' IDENTIFIER '(' ArgListOpt ')'
	;

PostFixExpr :
	Primary
	| Name
	;

UnaryExpr :
	'-' UnaryExpr
	| '!' UnaryExpr
	| PostFixExpr
	;

MulExpr :
	UnaryExpr
	| MulExpr '*' UnaryExpr
	| MulExpr '/' UnaryExpr
	| MulExpr '%' UnaryExpr
	;

AddExpr :
	MulExpr
	| AddExpr '+' MulExpr
	| AddExpr '-' MulExpr
	;

RelOp :
	LESSTHANOREQUAL
	| GREATERTHANOREQUAL
	| '<'
	| '>'
	;

RelExpr :
	AddExpr
	| RelExpr RelOp AddExpr
	;

EqExpr :
	RelExpr
	| EqExpr ISEQUALTO RelExpr
	| EqExpr NOTEQUALTO RelExpr
	;

CondAndExpr :
	EqExpr
	| CondAndExpr LOGICALAND EqExpr
	;

CondOrExpr :
	CondAndExpr
	| CondOrExpr LOGICALOR CondAndExpr
	;

ArrayAccess :
	Name '[' Expr ']'
	;

Expr :
	CondOrExpr
	| Assignment
	;

Assignment :
	LeftHandSide AssignOp Expr
	;

LeftHandSide :
	Name
	| FieldAccess
	| ArrayAccess
	;

AssignOp :
	'='
	| INCREMENT
	| DECREMENT
	;

%%

id	([a-zA-Z_][a-zA-Z0-9_]*)

%%

"/*"(?s:.)*?"*/" skip()
"//".*                  skip()
[ \t\r\f]+                   skip()
\n                           skip()

"break"                BREAK
"double"               DOUBLE
"else"                 ELSE
"false"                BOOLLIT
"for"                  FOR
"if"                   IF
"int"                  INT
"new"                  NEW
"null"                 NULLVAL
"public"               PUBLIC
"return"               RETURN
"static"               STATIC
"string"               STRING
"true"                 BOOLLIT
"boolean"              BOOLEAN
"void"                 VOID
"while"                WHILE
"class"                CLASS
"("                    '('
")"                    ')'
"["                    '['
"]"                    ']'
"{"                    '{'
"}"                    '}'
";"                    ';'
//":"                    ':'
"!"                    '!'
"*"                    '*'
"/"                    '/'
"%"                    '%'
"+"                    '+'
"-"                    '-'
"<"                    '<'
"<="                   LESSTHANOREQUAL
">"                    '>'
">="                   GREATERTHANOREQUAL
"=="                   ISEQUALTO
"!="                   NOTEQUALTO
"&&"                   LOGICALAND
"||"                   LOGICALOR
"="                    '='
"+="                   INCREMENT
"-="                   DECREMENT
","                    ','
"."                    '.'
{id}                   IDENTIFIER
[0-9]+                 INTLIT
[0-9]*"."[0-9]*([eE][+-]?[0-9]+)? DOUBLELIT
([0-9]+)([eE][+-]?([0-9]+))  DOUBLELIT
\"([^"\\\n\r]|"\\".)*\"     STRINGLIT

%%
