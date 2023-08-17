// Mini C parser by Robert van Engelen
// A simple one-pass, syntax-directed translation of mini C to JVM bytecode
// Requires minic.l, minic.y, minic.hpp
// See minicdemo.c for a description of the mini C features
//
// Ideas for compiler improvements (from easy to hard, roughly):
// - add more library functions that compile to JVM virtual and static method invocations
// - allow polymorphic functions instead of generating redeclaration errors
// - add constant folding, i.e. Expr class contains U4, F8, and std::string constants to combine
// - add variable declaration initializers, e.g. int a=1; and/or implicit initialization, requires init method to init statics
// - allow variable declarations anywhere in code blocks, not just at the start of a function body
// - add structs/classes (structs without methods or classes with methods)
// - add exceptions, e.g. 'try' and 'catch' blocks

/*Tokens*/
%token ID
%token U8
%token F8
%token CS
%token CH
%token BREAK
%token CASE
%token CONTINUE
%token DEFAULT
%token DO
%token ELSE
%token FALSE
%token FLOAT
%token FOR
%token IF
%token INT
%token MAIN
%token NEW
%token PRINT
%token PRINTLN
%token RETURN
%token STRING
%token SWITCH
%token TRUE
%token VOID
%token WHILE
%token PA
%token NA
%token TA
%token DA
%token MA
%token AA
%token XA
%token OA
%token LA
%token RA
%token OR
%token AN
%token EQ
%token NE
%token LE
%token GE
%token LS
%token RS
%token PP
%token NN
%token AR
%token '!'
%token '#'
%token '$'
%token '%'
%token '&'
%token '('
%token ')'
%token '*'
%token '+'
%token ','
%token '-'
%token '.'
%token '/'
%token ':'
%token ';'
%token '<'
%token '='
%token '>'
%token '?'
%token '['
%token ']'
%token '^'
%token '{'
%token '|'
%token '}'
%token '~'

%nonassoc IF_WITHOUT_ELSE
%nonassoc ELSE

%right /*1*/ PA NA TA DA MA AA XA OA LA RA '='
%right /*2*/ '?'
%right /*3*/ ':'
%left /*4*/ OR
%left /*5*/ AN
%left /*6*/ '|'
%left /*7*/ '^'
%left /*8*/ '&'
%left /*9*/ EQ NE LE GE '<' '>'
%left /*10*/ LS RS
%left /*11*/ '+' '-'
%left /*12*/ '%' '*' '/'
%right /*13*/ '!' ')' '~'
%nonassoc /*14*/ PP NN '#' '$'
%left /*15*/ AR '.' '['

%start program

%%

program :
	statics
	;

statics :
	statics func
	| statics decl
	| /*empty*/
	;

func :
	main '(' ')' /*13R*/ block
	| proto block
	| proto ';'
	;

proto :
	type ID '(' S optargs ')' /*13R*/
	;

main :
	type MAIN
	;

S :
	/*empty*/
	;

block :
	'{' decls stmts '}'
	;

decls :
	decls decl
	| /*empty*/
	;

decl :
	list ';'
	;

type :
	VOID
	| INT
	| FLOAT
	| STRING
	| type '[' /*15L*/ ']'
	;

list :
	list ',' ID
	| type ID
	;

args :
	args ',' type ID
	| type ID
	;

optargs :
	args
	| /*empty*/
	;

stmts :
	stmts stmt
	| /*empty*/
	;

stmt :
	IF '(' cond ')' /*13R*/ stmt %prec IF_WITHOUT_ELSE
	| IF '(' cond ')' /*13R*/ stmt ELSE G A stmt
	| switch G '{' cases '}' G
	| WHILE '(' C cond ')' /*13R*/ B stmt G
	| DO B stmt WHILE '(' C cond ')' /*13R*/ ';'
	| FOR '(' optexpr ';' C optcond ';' A optexpr G ')' /*13R*/ B stmt G
	| RETURN expr ';'
	| RETURN ';'
	| prints ';'
	| BREAK ';'
	| CONTINUE ';'
	| '{' stmts '}'
	| optexpr ';'
	//| error ';'
	;

switch :
	SWITCH '(' expr ')' /*13R*/
	;

cases :
	cases case ':' /*3R*/ stmts
	| /*empty*/
	;

case :
	CASE U8
	| CASE '-' /*11L*/ U8
	| DEFAULT
	;

prints :
	prints ',' D expr
	| print expr
	;

print :
	PRINT
	| PRINTLN
	;

exprs :
	exprs ',' expr
	| expr
	;

optexprs :
	exprs
	| /*empty*/
	;

expr :
	expr '=' /*1R*/ expr
	| expr PA /*1R*/ expr
	| expr NA /*1R*/ expr
	| expr TA /*1R*/ expr
	| expr DA /*1R*/ expr
	| expr MA /*1R*/ expr
	| expr AA /*1R*/ expr
	| expr XA /*1R*/ expr
	| expr OA /*1R*/ expr
	| expr LA /*1R*/ expr
	| expr RA /*1R*/ expr
	| expr '?' /*2R*/ expr ':' /*3R*/ expr
	| expr OR /*4L*/ expr
	| expr AN /*5L*/ expr
	| expr '|' /*6L*/ expr
	| expr '^' /*7L*/ expr
	| expr '&' /*8L*/ expr
	| expr EQ /*9L*/ expr
	| expr NE /*9L*/ expr
	| expr GE /*9L*/ expr
	| expr '<' /*9L*/ expr
	| expr LE /*9L*/ expr
	| expr '>' /*9L*/ expr
	| expr LS /*10L*/ expr
	| expr RS /*10L*/ expr
	| expr '+' /*11L*/ expr
	| expr '-' /*11L*/ expr
	| expr '*' /*12L*/ expr
	| expr '/' /*12L*/ expr
	| expr '%' /*12L*/ expr
	| '!' /*13R*/ expr
	| '~' /*13R*/ expr
	| '+' /*11L*/ expr %prec '!' /*13R*/
	| '-' /*11L*/ expr %prec '!' /*13R*/
	| '(' expr ')' /*13R*/
	| '#' /*14N*/ expr
	| '#' /*14N*/ '$' /*14N*/
	| '$' /*14N*/ expr
	| PP /*14N*/ expr
	| NN /*14N*/ expr
	| expr PP /*14N*/
	| expr NN /*14N*/
	| '(' type ')' /*13R*/ expr
	| expr '[' /*15L*/ expr ']'
	| expr '.' /*15L*/ ID
	| expr AR /*15L*/ ID
	| ID '(' optexprs ')' /*13R*/
	| NEW type '[' /*15L*/ expr ']'
	| ID
	| U8
	| F8
	| CS
	| CH
	| FALSE
	| TRUE
	;

optexpr :
	expr
	| /*empty*/
	;

cond :
	expr
	;

optcond :
	cond
	| /*empty*/
	;

A :
	/*empty*/
	;

B :
	/*empty*/
	;

C :
	/*empty*/
	;

D :
	/*empty*/
	;

G :
	/*empty*/
	;

%%

digit                           [0-9]
alpha                           [a-zA-Z_]
identifier                      {alpha}({alpha}|{digit})*
integer                         {digit}+|0[xX][0-9a-fA-F]+
exp     	                [eE][-+]?{digit}+
float                           {digit}+\.{digit}*{exp}?
character                       \'(\\.|[^\\'\n])*\'
string                          \"(\\.|[^\\"\n])*\"
inline_ws	[ \t]
include                         "#"{inline_ws}*"include"{inline_ws}*{string}

%%

[[:space:]]+                    skip() /* skip white space */
"//".*                          skip() /* ignore inline comment */
"/*"(.|\n)*?"*/"                skip() /* ignore multi-line comment using a lazy regex pattern */
^{inline_ws}*{include}                 skip()

"break"	BREAK
"case"     	CASE
"continue" 	CONTINUE
"default"  	DEFAULT
"do"       	DO
"else"     	ELSE
"false"	FALSE
"float"	FLOAT
"for"	FOR
"if"       	IF
"int"	INT
"main"     	MAIN
"new"	NEW
"print"	PRINT
"println"  	PRINTLN
"return"   	RETURN
"string"   	STRING
"switch"   	SWITCH
"true"     	TRUE
"void"     	VOID
"while"	WHILE

"+="                            PA
"-="                            NA
"*="                            TA
"/="                            DA
"%="                            MA
"&="                            AA
"^="                            XA
"|="                            OA
"<<="                           LA
">>="                           RA
"||"                            OR
"&&"                            AN
"=="                            EQ
"!="                            NE
"<="                            LE
">="                            GE
"<<"                            LS
">>"                            RS
"++"                            PP
"--"                            NN
"->"                            AR
"!"	'!'
"#"	'#'
"$"	'$'
"%"	'%'
"&"	'&'
"("	'('
")"	')'
"*"	'*'
"+"	'+'
","	','
"-"	'-'
"."	'.'
"/"	'/'
":"	':'
";"	';'
"<"	'<'
"="	'='
">"	'>'
"?"	'?'
"["	'['
"]"	']'
"^"	'^'
"{"	'{'
"|"	'|'
"}"	'}'
"~"	'~'

/* Order matter if identifier comes before keywords they are classified as identifier */
{identifier}                    ID
{integer}                       U8
{float}                         F8
{character}                     CH
{string}                        CS

/*<<EOF>>                         { if (end_of_file()) return Parser::make_EOF(location()); }*/

%%
