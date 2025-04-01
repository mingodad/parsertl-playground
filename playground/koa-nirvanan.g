//From: https://github.com/nirvanan/koa/blob/68f5bb1f112b6169218c63a8e69982733e32a2e8/doc/grammar.txt

%token constant
%token identifier
%token string-literal

%%

//command-line:
//	external-declaration
//	| statement
//	;

translation-unit:
	external-declaration
	| translation-unit external-declaration
	;

external-declaration:
	function-definition
	| declaration
	| struct-specifier
	| union-specifier
	;

function-definition:
	type-specifier identifier '(' parameter-list_opt ')' compound-statement
	;

type-specifier:
	"bool"
	| "char"
	| "int"
	| "int8"
	| "uint8"
	| "int16"
	| "uint16"
	| "int32"
	| "uint32"
	| "int64"
	| "uint64"
	| "long"
	| "float"
	| "double"
	| "str"
	| "vec"
	| "dict"
	| "func"
	| "struct" identifier
	| "union" identifier
	| "void"
	;

struct-specifier:
	"struct" identifier '{' struct-declaration-list_opt '}' ';'
	;

struct-declaration-list_opt:
	%empty
	| struct-declaration-list
	;

struct-declaration-list:
	struct-declaration
	| struct-declaration-list struct-declaration
	;

struct-declaration:
	type-specifier identifier ';'
	;

union-specifier:
	"union" identifier '{' union-declaration-list_opt '}' ';'
	;

union-declaration-list_opt:
	%empty
	| union-declaration-list
	;

union-declaration-list:
	union-declaration
	| union-declaration-list union-declaration
	;

union-declaration:
	type-specifier identifier ';'
	;

parameter-list_opt:
	%empty
	| parameter-list
	;

parameter-list:
	parameter-declaration
	| parameter-list ',' parameter-declaration
	;

parameter-declaration:
	type-specifier identifier
	;

compound-statement:
	'{' block-item-list_opt '}'
	;

block-item-list_opt:
	%empty
	| block-item-list
	;

block-item-list:
	block-item
	| block-item-list block-item
	;

block-item:
	declaration
	| statement
	;

declaration:
	type-specifier init-declarator-list ';'
	;

init-declarator-list:
	init-declarator
	| init-declarator-list ',' init-declarator
	;

init-declarator:
	identifier
	| identifier '=' assignment-expression
	;

assignment-expression:
	conditional-expression
	| unary-expression assignment-operator assignment-expression
	;

conditional-expression:
	logical-OR-expression
	| logical-OR-expression '?' expression ':' conditional-expression
	;

logical-OR-expression:
	logical-AND-expression
	| logical-OR-expression "||" logical-AND-expression
	;

logical-AND-expression:
	inclusive-OR-expression
	| logical-AND-expression "&&" inclusive-OR-expression
	;

inclusive-OR-expression:
	exclusive-OR-expression
	| inclusive-OR-expression '|'  exclusive-OR-expression
	;

exclusive-OR-expression:
	AND-expression
	| exclusive-OR-expression '^' AND-expression
	;

AND-expression:
	equality-expression
	| AND-expression '&' equality-expression
	;

equality-expression:
	relational-expression
	| equality-expression "==" relational-expression
	| equality-expression "!="  relational-expression
	;

relational-expression:
	shift-expression
	| relational-expression '<'  shift-expression
	| relational-expression '>'  shift-expression
	| relational-expression "<=" shift-expression
	| relational-expression ">="  shift-expression
	;

shift-expression:
	additive-expression
	| shift-expression "<<" additive-expression
	| shift-expression ">>" additive-expression
	;

additive-expression:
	multiplicative-expression
	| additive-expression '+' multiplicative-expression
	| additive-expression '-' multiplicative-expression
	;

multiplicative-expression:
	cast-expression
	| multiplicative-expression '*' cast-expression
	| multiplicative-expression '/'  cast-expression
	| multiplicative-expression '%'  cast-expression
	;

cast-expression:
	unary-expression
	| '(' type-specifier ')' cast-expression
	;

unary-expression:
	postfix-expression
	| "++" unary-expression
	| "--" unary-expression
	| unary-operator cast-expression
	;

unary-operator: //one of
	'+'
	| '-'
	| '~'
	| '!'
	;

postfix-expression:
	primary-expression
	| primary-expression expression-postfix-list
	;

primary-expression:
	identifier
	| constant
	| string-literal
	| '(' expression ')'
	;

expression_opt:
	%empty
	| expression
	;

expression:
	assignment-expression
	| assignment-expression ',' expression
	;

expression-postfix-list:
	expression-postfix
	| expression-postfix-list expression-postfix
	;

expression-postfix:
	'.' identifier
	| '[' expression ']'
	| '(' argument-expression-list_opt ')'
	| "++"
	| "--"
	;

argument-expression-list_opt:
	%empty
	| argument-expression-list
	;

argument-expression-list:
	assignment-expression
	| argument-expression-list ',' assignment-expression
	;

assignment-operator:
	'='
	| "*="
	| "/="
	| "%="
	| "+="
	| "-="
	| "<<="
	| ">>="
	| "&="
	| "^="
	| "|="
	;

statement:
	labeled-statement
	| compound-statement
	| expression-statement
	| selection-statement
	| iteration-statement
	| jump-statement
	| try-statement
	;

labeled-statement:
	"case" conditional-expression ':' statement
	| "default" ':' statement
	;

expression-statement:
	expression_opt ';'
	;

selection-statement:
	if-statement
	| switch-statement
	;

iteration-statement:
	while-statement
	| do-while-statement
	| for-statement
	;

jump-statement:
	"continue" ';'
	| "break" ';'
	| "return" expression_opt ';'
	;

if-statement:
	"if" '(' expression ')' statement
	| "if" '(' expression ')' statement "else" statement
	;

switch-statement:
	"switch" '(' expression ')' statement
	;

while-statement:
	"while" '(' expression ')' statement
	;

do-while-statement:
	"do" statement "while" '(' expression ')' ';'
	;

for-statement:
	"for" '(' expression_opt ';' expression_opt ';' expression_opt ')' statement
	| "for" '(' declaration expression_opt ';' expression_opt ')' statement
	;

try-statement:
	"try" compound-statement
	| "try" compound-statement "catch" '(' "exception" identifier ')' compound-statement
	;

%%

%%

[ \t\r\n\f\v]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"!"	'!'
"!="	"!="
"%"	'%'
"%="	"%="
"&"	'&'
"&&"	"&&"
"&="	"&="
"("	'('
")"	')'
"*"	'*'
"*="	"*="
"+"	'+'
"++"	"++"
"+="	"+="
","	','
"-"	'-'
"--"	"--"
"-="	"-="
"."	'.'
"/"	'/'
"/="	"/="
":"	':'
";"	';'
"<"	'<'
"<<"	"<<"
"<<="	"<<="
"<="	"<="
"="	'='
"=="	"=="
">"	'>'
">="	">="
">>"	">>"
">>="	">>="
"?"	'?'
"["	'['
"]"	']'
"^"	'^'
"break"	"break"
"case"	"case"
"catch"	"catch"
"continue"	"continue"
"default"	"default"
"do"	"do"
"else"	"else"
"for"	"for"
"if"	"if"
"return"	"return"
"switch"	"switch"
"try"	"try"
"while"	"while"
"{"	'{'
"|"	'|'
"|="	"|="
"||"	"||"
"}"	'}'
"~"	'~'
"^="	"^="
"bool"	"bool"
"char"	"char"
"dict"	"dict"
"double"	"double"
"exception"	"exception"
"float"	"float"
"func"	"func"
"int"	"int"
"int8"	"int8"
"uint8"	"uint8"
"int16"	"int16"
"uint16"	"uint16"
"int32"	"int32"
"uint32"	"uint32"
"int64"	"int64"
"uint64"	"uint64"
"long"	"long"
"str"	"str"
"struct"	"struct"
"union"	"union"
"vec"	"vec"
"void"	"void"

[0-9]+	constant
[0-9]+"."[0-9]+	constant

'(\\.|[^'\r\n\\])'	constant

\"(\\.|[^"\r\n\\])*\"	string-literal

[A-Za-z_][A-Za-z0-9_]*	identifier

%%
