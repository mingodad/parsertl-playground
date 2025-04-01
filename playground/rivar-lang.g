//Fom: https://github.com/andreamancuso/rivar-lang/raw/refs/heads/main/src/parser.mly

%start program
%token AND
%token ARROW
%token ASSIGN
%token CLASS
%token COLON
%token COMMA
%token DO
%token END
%token ENSURE
//%token EOF
%token EQ
%token FEATURE
%token GE
%token GT
%token IDENT
%token INT
%token LE
%token LPAREN
%token LT
%token MINUS
%token NEQ
%token OLD
%token OR
%token PLUS
%token PRINT
%token REQUIRE
%token RETURN
%token RPAREN
%token SLASH
%token STAR
%token STRINGLIT
%token THIS
%token TYPE_BOOLEAN
%token TYPE_INTEGER
%token TYPE_STRING

%left OR
%left AND
%nonassoc EQ NEQ
%nonassoc GE GT LE LT
%left MINUS PLUS
%left SLASH STAR

%%

program :
	class_decl_list //EOF
	;

class_decl_list :
	class_decl
	| class_decl_list class_decl
	;

class_decl :
	CLASS IDENT feature_block END
	;

feature_block :
	FEATURE feature_list
	;

feature_list :
	feature_decl
	| feature_list feature_decl
	;

feature_decl :
	IDENT COLON type_expr
	| IDENT LPAREN param_list RPAREN COLON type_expr routine_body
	| IDENT LPAREN param_list RPAREN routine_body
	;

param_list :
	| param
	| param_list COMMA param
	;

param :
	IDENT COLON type_expr
	;

routine_body :
	DO stmt_list END
	| REQUIRE expr_list DO stmt_list END
	| DO stmt_list ENSURE expr_list END
	| REQUIRE expr_list DO stmt_list ENSURE expr_list END
	;

expr_list :
	expr
	| expr_list expr
	;

stmt_list :
	stmt
	| stmt_list stmt
	;

stmt :
	IDENT MINUS ASSIGN expr
	| IDENT PLUS ASSIGN expr
	| IDENT STAR ASSIGN expr
	| IDENT SLASH ASSIGN expr
	| IDENT ASSIGN expr
	| THIS ARROW IDENT ASSIGN expr
	| PRINT LPAREN expr RPAREN
	| RETURN expr
	| RETURN
	;

expr :
	INT
	| IDENT
	| OLD THIS ARROW IDENT
	| STRINGLIT
	| expr PLUS expr
	| expr MINUS expr
	| expr STAR expr
	| expr SLASH expr
	| expr GT expr
	| expr LT expr
	| expr GE expr
	| expr LE expr
	| expr EQ expr
	| expr NEQ expr
	| expr AND expr
	| expr OR expr
	| THIS ARROW IDENT
	;

type_expr :
	TYPE_INTEGER
	| TYPE_BOOLEAN
	| TYPE_STRING
	;

%%

%%

[ \t\r\n]+	skip()

"class"      CLASS
"end"        END
"feature"    FEATURE
"require"    REQUIRE
"do"         DO
"ensure"     ENSURE
"INTEGER"    TYPE_INTEGER
"BOOLEAN"    TYPE_BOOLEAN
"STRING"     TYPE_STRING
"old"        OLD
"and"        AND
"or"         OR
"print"      PRINT
":"          COLON
"="          ASSIGN
"this"       THIS
"return"     RETURN
"->"         ARROW
"+"          PLUS
"-"          MINUS
"*"          STAR
"/"          SLASH
"=="         EQ
"!="         NEQ
">"          GT
"<"          LT
"<="         LE
">="         GE
"("          LPAREN
")"          RPAREN
","          COMMA
[0-9]+   INT
\"(\\.|[^"\r\n\\])*\"   STRINGLIT
[A-Za-z_][A-Za-z0-9_]*   IDENT

%%
