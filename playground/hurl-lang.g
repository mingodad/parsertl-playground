//From: https://git.sr.ht/~ntietz/hurl-lang/tree/main/item/grammar.bnf

%token member_access
%token identifier
%token number
%token string

%%

program :
	stmt_list
	;

stmt_list :
	stmt ';'
	| stmt_list stmt ';'
	;

stmt :
	declaration
	| exception_handling
	| exception
	| assignment
	| expr
	;

declaration :
	"let" assignment
	;

func_expr :
	"func" '(' params ')' stmt_block
	;

stmt_block :
	'{' stmt_list '}'
	;

params :
	params ',' identifier
	| identifier
	| %empty
	;

exception_handling :
	"try" stmt_block catch_list
	;

catch_list :
	catch_list catch
	| catch
	;

catch :
	"catch" "as" identifier stmt_block
	| "catch" '(' expr ')' stmt_block
	;

exception :
	"hurl" expr
	| "toss" expr
	;

expr :
	comparison_expr
	;

list_expr :
	'[' ']'
	| '[' expr_list ']'
	;

expr_list :
	expr_list ',' expr
	| expr
	;

comparison_expr :
	term comparison_operator term
	| term
	;

comparison_operator :
	"=="
	| "~="
	| '<'
	| '>'
	| "<="
	| '='
	;

term :
	operand
	| term '+' operand
	| term '-' operand
	;

operand :
	operand '*' factor
	| operand '/' factor
	| operand '%' factor
	| factor
	;

function_call :
	identifier '(' ')'
	| identifier '(' expr_list ')'
	;

assignment :
	identifier '=' expr
	;

factor :
	'(' expr ')'
	| '~' factor
	| member_access
	| func_expr
	| function_call
	| identifier
	| number
	| string
	| "true"
	| "false"
	| list_expr
	;

//optional_comment :
//	comment
//	| %empty
//	;

%%

ident   [a-zA-Z_][a-zA-Z_0-9]*

%%

[ \t\r\n]+ skip()

"~"	'~'
"<"	'<'
"="	'='
">"	'>'
","	','
";"	';'
"/"	'/'
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"*"	'*'
"%"	'%'
"+"	'+'
"-"	'-'
"~="	"~="
"<="	"<="
"=="	"=="
"as"	"as"
"catch"	"catch"
"false"	"false"
"func"	"func"
"hurl"	"hurl"
"let"	"let"
"toss"	"toss"
"true"	"true"
"try"	"try"

{ident}"."[0-9]+    member_access
{ident}	identifier

[0-9]+(\.[0-9]+)?	number

\"(\\.|[^\"\r\n\\])*\"	string

"#".*	skip() //comment

%%
