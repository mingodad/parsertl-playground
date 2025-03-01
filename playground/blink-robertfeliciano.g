//Fom: https://github.com/robertfeliciano/blink/raw/refs/heads/master/src/parsing/parser.mly

%token AND
%token ARROW
%token AT
%token ATEQ
%token BREAK
%token BY
//%token CLASS
%token COLON
%token COMMA
%token CONST
%token CONT
%token DIV
%token DIVEQ
//%token DOT
%token ELSE
//%token ENABLE
//%token EOF
%token EQEQ
%token EQUAL
%token FALSE
%token FLOAT
%token FOR
%token FUN
//%token GLOBAL
%token GT
%token GTE
%token IDENT
%token IF
//%token IMPORT
%token IN
//%token INHERITS
%token INT
%token LBRACE
%token LBRACKET
%token LET
%token LPAREN
%token LT
%token LTE
%token MINEQ
%token MINUS
%token MOD
%token MULT
%token NEQ
//%token NEW
%token NOT
//%token NULL
%token OR
%token PLUEQ
%token PLUS
%token POW
%token POWEQ
//%token QMARK
%token RANGE
%token RANGE_INCL
%token RBRACE
%token RBRACKET
%token RETURN
%token RPAREN
%token SEMI
%token STRING
%token TBOOL
%token TIMEQ
%token TRUE
%token TSTRING
%token TVOID
%token Tf32
%token Tf64
%token Ti128
%token Ti16
%token Ti32
%token Ti64
%token Ti8
%token Tu128
%token Tu16
%token Tu32
%token Tu64
%token Tu8
//%token WHERE
%token WHILE

%right POW
%right ATEQ DIVEQ EQUAL MINEQ PLUEQ POWEQ TIMEQ
%left OR
%left AND
%left EQEQ NEQ
%left GT GTE LT LTE
%left MINUS PLUS
%left DIV MOD MULT
%left AT
//%left DOT
%left RANGE RANGE_INCL
//%nonassoc LOW
//%nonassoc QMARK
%nonassoc NOT
%nonassoc LBRACKET
%nonassoc LPAREN

//%start exp_top
%start prog
//%start stmt_top

%%

option_exp_ :
	| exp
	;

option_ty_spec_ :
	| COLON ty
	;

loption_separated_nonempty_list_COMMA_arg__ :
	| separated_nonempty_list_COMMA_arg_
	;

loption_separated_nonempty_list_COMMA_exp__ :
	| separated_nonempty_list_COMMA_exp_
	;

list_decl_ :
	| list_decl_ decl
	;

list_stmt_ :
	| list_stmt_ stmt
	;

separated_nonempty_list_COMMA_arg_ :
	IDENT COLON ty
	| separated_nonempty_list_COMMA_arg_ COMMA IDENT COLON ty
	;

separated_nonempty_list_COMMA_exp_ :
	exp
	| separated_nonempty_list_COMMA_exp_ COMMA exp
	;

//exp_top :
//	exp //EOF
//	;
//
//stmt_top :
//	stmt //EOF
//	;

prog :
	list_decl_ //EOF
	;

decl :
	FUN IDENT LPAREN loption_separated_nonempty_list_COMMA_arg__ RPAREN ARROW TVOID block
	| FUN IDENT LPAREN loption_separated_nonempty_list_COMMA_arg__ RPAREN ARROW ty block
	;

ty :
	Ti8
	| Ti16
	| Ti32
	| Ti64
	| Ti128
	| Tu8
	| Tu16
	| Tu32
	| Tu64
	| Tu128
	| TSTRING
	| LBRACKET ty RBRACKET
	| Tf32
	| Tf64
	| TBOOL
	| LPAREN ty RPAREN
	;

lhs :
	IDENT
	| exp LBRACKET exp RBRACKET
	;

exp :
	TRUE
	| FALSE
	| INT
	| FLOAT
	| STRING
	| IDENT
	| LBRACKET loption_separated_nonempty_list_COMMA_exp__ RBRACKET
	| exp LBRACKET exp RBRACKET
	| exp LPAREN loption_separated_nonempty_list_COMMA_exp__ RPAREN
	| exp PLUS exp
	| exp MINUS exp
	| exp MULT exp
	| exp DIV exp
	| exp AT exp
	| exp MOD exp
	| exp POW exp
	| exp LT exp
	| exp LTE exp
	| exp GT exp
	| exp GTE exp
	| exp NEQ exp
	| exp EQEQ exp
	| exp AND exp
	| exp OR exp
	| MINUS exp
	| NOT exp
	| exp RANGE exp
	| exp RANGE_INCL exp
	| LPAREN exp RPAREN
	;

vdecl :
	LET IDENT option_ty_spec_ EQUAL exp
	| CONST IDENT option_ty_spec_ EQUAL exp
	;

stmt :
	vdecl SEMI
	| lhs EQUAL exp SEMI
	| lhs PLUEQ exp SEMI
	| lhs MINEQ exp SEMI
	| lhs TIMEQ exp SEMI
	| lhs DIVEQ exp SEMI
	| lhs ATEQ exp SEMI
	| lhs POWEQ exp SEMI
	| exp LPAREN loption_separated_nonempty_list_COMMA_exp__ RPAREN SEMI
	| if_stmt
	| RETURN option_exp_ SEMI
	| WHILE exp block
	| FOR IDENT IN exp BY exp block
	| FOR IDENT IN exp block
	| CONT SEMI
	| BREAK SEMI
	;

block :
	LBRACE list_stmt_ RBRACE
	;

if_stmt :
	IF exp block else_stmt
	;

else_stmt :
	| ELSE block
	| ELSE if_stmt
	;

%%

digit   [0-9]
alpha   [a-zA-Z]

/* Regexes for tokens */
int   "-"?{digit}+
decimal   {digit}+"."{digit}+
scientific   {digit}+[Ee]"-"?{digit}+
id   {alpha}({alpha}|{digit}|"_")*
generic_type_param   [A-Z]

whitespace   [  \t]+
newline   "\r"|"\n"| "\r\n"
sint   "i"("8"|"16"|"32"|"64"|"128")
uint   "u"("8"|"16"|"32"|"64"|"128")

%%

{whitespace} skip()
{newline} skip()

"("   LPAREN
")"   RPAREN
"{"   LBRACE
"}"   RBRACE
"["   LBRACKET
"]"   RBRACKET
","   COMMA
//"."   DOT
".."   RANGE
"..="   RANGE_INCL
":"   COLON
";"   SEMI
"="   EQUAL
"=>"   ARROW
"+"   PLUS
"-"   MINUS
"*"   MULT
"/"   DIV
"@"   AT
"%"   MOD
"**"   POW
"+="   PLUEQ
"-="   MINEQ
"*="   TIMEQ
"/="   DIVEQ
"@="   ATEQ
"**="   POWEQ
"<"   LT
"<="   LTE
">"   GT
">="   GTE
"!="   NEQ
"=="   EQEQ
"and"   AND
"or"   OR
"not"   NOT
"let"   LET
//"new"   NEW
"const"   CONST
"void"   TVOID
"i8"     Ti8
"i16"    Ti16
"i32"    Ti32
"i64"    Ti64
"i128"   Ti128
"u8"     Tu8
"u16"    Tu16
"u32"    Tu32
"u64"    Tu64
"u128"   Tu128
"f32"   Tf32
"f64"   Tf64
"string"   TSTRING
"bool"   TBOOL
"fun"   FUN
"if"   IF
"in"   IN
"else"   ELSE
"for"   FOR
"by"   BY
"while"   WHILE
"break"   BREAK
"continue"   CONT
"return"   RETURN
"true"   TRUE
"false"   FALSE
//"where"   WHERE
//"import"   IMPORT
//"enable"   ENABLE
//"class"   CLASS
//"inherits"   INHERITS
//"global"   GLOBAL
//"?"   QMARK

"//".*	skip()
"/*"(?:s:)*?"*/"	skip()

/* extract_sint */
"i8"     Ti8
"i16"    Ti16
"i32"    Ti32
"i64"    Ti64
"i128"   Ti128

/* extract_uint */
"u8"     Tu8
"u16"    Tu16
"u32"    Tu32
"u64"    Tu64
"u128"   Tu128

{id}  IDENT
{int}  INT
{decimal}  FLOAT
{scientific}  FLOAT
\"(\\.|[^"\r\n\\])*\"	STRING
//eof  EOF

%%
