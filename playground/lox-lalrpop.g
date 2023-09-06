//From: https://github.com/ajeetdsouza/loxcraft/blob/main/res/grammar.lalrpop
// This grammar has been adapted from
// https://craftinginterpreters.com/appendix-i.html#syntax-grammar.

%token string number identifier

%%

Program :
	DeclS*
	;

// Declarations
DeclS :
	Decl
	;

Decl :
	DeclClass
	| DeclFun
	| DeclVar
	| Stmt
	;

DeclClass :
	"class" identifier ("<" ExprVar)? "{" Function* "}"
	;

DeclFun :
	"fun" Function
	;

DeclVar :
	"var" identifier ("=" ExprS)? ";"
	;

// Statements
// https://en.wikipedia.org/wiki/Dangling_else#Avoiding_the_conflict_in_LR_parsers
Stmt :
	StmtOpen
	| StmtClosed
	//| error
	;

StmtOpen :
	"if" "(" ExprS ")" Stmt
	| "if" "(" ExprS ")" StmtClosed "else" StmtOpen
	| "while" "(" ExprS ")" StmtOpen
	| "for" "(" ForInit ForCond ForIncr ")" StmtOpen
	;

StmtClosed :
	"if" "(" ExprS ")" StmtClosed "else" StmtClosed
	| "while" "(" ExprS ")" StmtClosed
	| "for" "(" ForInit ForCond ForIncr ")" StmtClosed
	| StmtSimple
	;

ForInit :
	DeclVar
	| StmtExpr
	| ";"
	;

ForCond :
	ExprS? ";"
	;

ForIncr :
	ExprS?
	;

StmtSimple :
	StmtBlock
	| StmtExpr
	| StmtPrint
	| StmtReturn
	;

StmtBlock :
	StmtBlockInternal
	;

StmtBlockInternal :
	"{" DeclS* "}"
	;

StmtExpr :
	ExprS ";"
	;

StmtPrint :
	"print" ExprS ";"
	;

StmtReturn :
	"return" ExprS? ";"
	;

// Expressions
ExprS :
	Expr
	;

Expr :
	ExprAssign
	;

ExprAssign :
	identifier "=" ExprS
	| ExprCall "." identifier "=" ExprS
	| ExprLogicOr
	;

ExprLogicOr :
	ExprLogicOr OpLogicOr ExprLogicAnd
	| ExprLogicAnd
	;

OpLogicOr :
	"or"
	;

ExprLogicAnd :
	ExprLogicAnd OpLogicAnd ExprEquality
	| ExprEquality
	;

OpLogicAnd :
	"and"
	;

ExprEquality :
	ExprEquality OpEquality ExprComparison
	| ExprComparison
	;

OpEquality :
	"=="
	| "!="
	;

ExprComparison :
	ExprComparison OpComparison ExprTerm
	| ExprTerm
	;

OpComparison :
	">"
	| ">="
	| "<"
	| "<="
	;

ExprTerm :
	ExprTerm OpTerm ExprFactor
	| ExprFactor
	;

OpTerm :
	"+"
	| "-"
	;

ExprFactor :
	ExprFactor OpFactor ExprPrefix
	| ExprPrefix
	;

OpFactor :
	"*"
	| "/"
	;

ExprPrefix :
	OpPrefix ExprPrefix
	| ExprCall
	;

OpPrefix :
	"-"
	| "!"
	;

ExprCall :
	ExprCall "(" Args ")"
	| ExprCall "." identifier
	| "super" "." identifier
	| ExprPrimary
	;

ExprPrimary :
	// Literals
	"nil"
	| "false"
	| "true"
	| string
	| number
	// Variables
	| ExprVar
	| ExprThis
	// Grouping
	| "(" Expr ")"
	;

ExprVar :
	identifier
	;

ExprThis :
	"this"
	;

// Utilities

Function :
	identifier "(" Params ")" StmtBlockInternal
	;

Params :
	identifier ("," identifier)*
	| %empty
	;

Args :
	ExprS ("," ExprS)*
	| %empty
	;

%%

%%

[ \t\n\r]	skip()
"//".*	skip() //comment

// Single-character tokens.
"("	"("
")"	")"
"{"	"{"
"}"	"}"
","	","
"."	"."
"-"	"-"
"+"	"+"
";"	";"
"/"	"/"
"*"	"*"

// One or two character tokens.
"!"	"!"
"!="	"!="
"="	"="
"=="	"=="
">"	">"
">="	">="
"<"	"<"
"<="	"<="

// Keywords.
"and"	"and"
"class"	"class"
"else"	"else"
"false"	"false"
"for"	"for"
"fun"	"fun"
"if"	"if"
"nil"	"nil"
"or"	"or"
"print"	"print"
"return"	"return"
"super"	"super"
"this"	"this"
"true"	"true"
"var"	"var"
"while"	"while"

// Literals.
\"("\\".|[^"\n\r\\])*\"	string
[0-9]+('.'[0-9]+)?	number
[a-zA-Z_][a-zA-Z0-9_]*	identifier


%%
