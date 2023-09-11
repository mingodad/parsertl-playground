//From: https://github.com/mukul-rathi/bolt/blob/master/src/frontend/parsing/parser.mly

/* Token definitions */

%token  INT
%token  ID
%token  LPAREN
%token  RPAREN
%token  LBRACE
%token  RBRACE
%token  LANGLE
%token  RANGLE
%token  COMMA
%token  DOT
%token  COLON
%token  SEMICOLON
%token  EQUAL
%token  PLUS
%token  MINUS
%token  MULT
%token  DIV
%token  REM
%token  AND
%token  OR
%token  EXCLAMATION_MARK
%token COLONEQ
%token  LET
%token  NEW
%token  CONST
%token  VAR
%token  FUNCTION
%token  CONSUME
%token  FINISH
%token  ASYNC
%token  CLASS
%token  EXTENDS
%token  GENERIC_TYPE
%token  CAPABILITY
%token  LINEAR
%token  LOCAL
%token  READ
%token  SUBORDINATE
%token  LOCKED
%token  TYPE_INT
%token  TYPE_BOOL
%token  TYPE_VOID
%token  BORROWED
%token  TRUE
%token  FALSE
%token  IF
%token  ELSE
%token  FOR
%token  WHILE
%token  MAIN
%token PRINTF
%token STRING
//%token EOF

/*
 Menhir allows you to specify how to resolve shift-reduce conflicts when it sees a .
 There are three options:
  %left  we reduce
  %right we shift
  %nonassoc raise a syntax error
 We list the operators in order of precedence - from low to high.
 e.g. * has higher precedence than +  so 1 + 2 * 3  = 1 + (2 * 3)
*/

%right  COLONEQ   EQUAL
%left PLUS MINUS  LANGLE RANGLE
%left MULT DIV REM
%left AND OR
%nonassoc EXCLAMATION_MARK


/* Specify starting production */
%start program

%%

option_COMMA_ :
	/*empty*/
	| COMMA
	;

option_borrowed_ref_ :
	/*empty*/
	| borrowed_ref
	;

option_generic_type_ :
	/*empty*/
	| generic_type
	;

option_inherits_ :
	/*empty*/
	| inherits
	;

option_let_type_annot_ :
	/*empty*/
	| let_type_annot
	;

option_param_capability_annotations_ :
	/*empty*/
	| param_capability_annotations
	;

option_parameterised_type_ :
	/*empty*/
	| parameterised_type
	;

loption_separated_nonempty_list_COMMA_constructor_arg__ :
	/*empty*/
	| separated_nonempty_list_COMMA_constructor_arg_
	;

loption_separated_nonempty_list_COMMA_expr__ :
	/*empty*/
	| separated_nonempty_list_COMMA_expr_
	;

loption_separated_nonempty_list_COMMA_param__ :
	/*empty*/
	| separated_nonempty_list_COMMA_param_
	;

loption_separated_nonempty_list_SEMICOLON_expr__ :
	/*empty*/
	| separated_nonempty_list_SEMICOLON_expr_
	;

list_async_expr_ :
	/*empty*/
	| async_expr list_async_expr_
	;

list_class_defn_ :
	/*empty*/
	| class_defn list_class_defn_
	;

list_function_defn_ :
	/*empty*/
	| function_defn list_function_defn_
	;

list_method_defn_ :
	/*empty*/
	| method_defn list_method_defn_
	;

nonempty_list_field_defn_ :
	field_defn
	| field_defn nonempty_list_field_defn_
	;

separated_nonempty_list_COMMA_capability_ :
	capability
	| capability COMMA separated_nonempty_list_COMMA_capability_
	;

separated_nonempty_list_COMMA_capability_name_ :
	capability_name
	| capability_name COMMA separated_nonempty_list_COMMA_capability_name_
	;

separated_nonempty_list_COMMA_constructor_arg_ :
	constructor_arg
	| constructor_arg COMMA separated_nonempty_list_COMMA_constructor_arg_
	;

separated_nonempty_list_COMMA_expr_ :
	expr
	| expr COMMA separated_nonempty_list_COMMA_expr_
	;

separated_nonempty_list_COMMA_param_ :
	param
	| param COMMA separated_nonempty_list_COMMA_param_
	;

separated_nonempty_list_SEMICOLON_expr_ :
	expr
	| expr SEMICOLON separated_nonempty_list_SEMICOLON_expr_
	;

program :
	list_class_defn_ list_function_defn_ main_expr //EOF
	;

class_defn :
	CLASS ID option_generic_type_ option_inherits_ LBRACE capability_defn nonempty_list_field_defn_ list_method_defn_ RBRACE
	;

generic_type :
	LANGLE GENERIC_TYPE RANGLE
	;

inherits :
	EXTENDS ID
	;

mode :
	LINEAR
	| LOCAL
	| READ
	| SUBORDINATE
	| LOCKED
	;

capability_defn :
	CAPABILITY separated_nonempty_list_COMMA_capability_ SEMICOLON
	|
	;

capability :
	mode ID
	;

borrowed_ref :
	BORROWED
	;

modifier :
	CONST
	| VAR
	;

capability_name :
	ID
	;

class_capability_annotations :
	COLON separated_nonempty_list_COMMA_capability_name_
	;

field_defn :
	modifier type_expr ID class_capability_annotations SEMICOLON
	;

params :
	LPAREN loption_separated_nonempty_list_COMMA_param__ RPAREN
	;

param_capability_annotations :
	LBRACE separated_nonempty_list_COMMA_capability_name_ RBRACE
	;

param :
	option_borrowed_ref_ type_expr option_param_capability_annotations_ ID
	;

method_defn :
	option_borrowed_ref_ type_expr ID params class_capability_annotations block_expr
	;

function_defn :
	FUNCTION option_borrowed_ref_ type_expr ID params block_expr
	;

parameterised_type :
	LANGLE type_expr RANGLE
	;

type_expr :
	ID option_parameterised_type_
	| TYPE_INT
	| TYPE_BOOL
	| TYPE_VOID
	| GENERIC_TYPE
	;

let_type_annot :
	COLON type_expr
	;

main_expr :
	TYPE_VOID MAIN LPAREN RPAREN block_expr
	;

block_expr :
	LBRACE loption_separated_nonempty_list_SEMICOLON_expr__ RBRACE
	;

args :
	LPAREN loption_separated_nonempty_list_COMMA_expr__ RPAREN
	;

constructor_arg :
	ID COLON expr
	;

identifier :
	ID
	| ID DOT ID
	;

expr :
	LPAREN expr RPAREN
	| INT
	| TRUE
	| FALSE
	| identifier
	| EXCLAMATION_MARK expr
	| MINUS expr
	| expr PLUS expr
	| expr MINUS expr
	| expr MULT expr
	| expr DIV expr
	| expr REM expr
	| expr LANGLE expr
	| expr LANGLE EQUAL expr
	| expr RANGLE expr
	| expr RANGLE EQUAL expr
	| expr AND expr
	| expr OR expr
	| expr EQUAL EQUAL expr
	| expr EXCLAMATION_MARK EQUAL expr
	| NEW ID option_parameterised_type_ LPAREN loption_separated_nonempty_list_COMMA_constructor_arg__ RPAREN
	| LET ID option_let_type_annot_ EQUAL expr
	| identifier COLONEQ expr
	| CONSUME identifier
	| ID DOT ID args
	| ID args
	| PRINTF LPAREN STRING option_COMMA_ loption_separated_nonempty_list_COMMA_expr__ RPAREN
	| IF expr block_expr ELSE block_expr
	| WHILE expr block_expr
	| FOR LPAREN expr SEMICOLON expr SEMICOLON expr RPAREN block_expr
	| FINISH LBRACE list_async_expr_ loption_separated_nonempty_list_SEMICOLON_expr__ RBRACE
	;

async_expr :
	ASYNC block_expr
	;

%%

/* Helper regexes */
digit   [0-9]
alpha   [a-zA-Z]

/* Regexes for tokens */
int   "-"?{digit}+
id   {alpha}({alpha}|{digit}|"_")*
generic_type_param    [A-Z]

whitespace   [  \t]+
newline   \r|\n|\r\n

%%

/* Lexer Rules
 * To disambiguate prefixes, Ocamllex applies:
 *   1) Longest match
 *   2) Match first rule (hence id is listed after keywords)
 */
"("   LPAREN
")"   RPAREN
"{"   LBRACE
"}"   RBRACE
","   COMMA
"."   DOT
":"   COLON
";"   SEMICOLON
"="   EQUAL
"+"   PLUS
"-"   MINUS
"*"   MULT
"/"   DIV
"%"   REM
"<"   LANGLE
">"   RANGLE
"&&"   AND
"||"   OR
"!"   EXCLAMATION_MARK
":="   COLONEQ
"let"   LET
"new"   NEW
"const"   CONST
"var"   VAR
"function"   FUNCTION
"consume"   CONSUME
"finish"   FINISH
"async"   ASYNC
"class"   CLASS
"extends"   EXTENDS
{generic_type_param}   GENERIC_TYPE
"capability"   CAPABILITY
"linear"   LINEAR
"local"   LOCAL
"read"   READ
"subordinate"   SUBORDINATE
"locked"   LOCKED
"int"   TYPE_INT
"bool"   TYPE_BOOL
"void"   TYPE_VOID
"borrowed"   BORROWED
"true"   TRUE
"false"   FALSE
"while"   WHILE
"if"   IF
"else"   ELSE
"for"   FOR
"main"   MAIN
"printf"  PRINTF

{whitespace}	skip()
"//".*		skip()
"/*"(?s:.)*?"*/"	skip()
{int}   INT
{id}   ID
\"("\\".|[^"\n\r\\])*\"   STRING
{newline}	skip()

%%
