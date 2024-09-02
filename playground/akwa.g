//From: https://github.com/noyesno/awka/blob/master/awka/parse.y

//%token UNEXPECTED
//%token BAD_DECIMAL
%token NL
%token SEMI_COLON
%token LBRACE
%token RBRACE
%token LBOX
%token RBOX
%token COMMA
%token IO_OUT
%token COPROCESS_OUT
%token ASSIGN
%token ADD_ASG
%token SUB_ASG
%token MUL_ASG
%token DIV_ASG
%token MOD_ASG
%token POW_ASG
%token QMARK
%token COLON
%token OR
%token AND
%token IN
%token MATCH
%token EQ
%token NEQ
%token LT
%token LTE
%token GT
%token GTE
%token CAT
%token GETLINE
%token PLUS
%token MINUS
%token MUL
%token DIV
%token MOD
%token NOT
%token UMINUS
%token IO_IN
%token PIPE
%token COPROCESS
%token POW
%token INC_or_DEC
%token DOLLAR
%token FIELD
%token LPAREN
%token RPAREN
%token DOUBLE
%token STRING_
%token RE
%token ID
%token D_ID
%token FUNCT_ID
%token BUILTIN
%token LENGTH
%token LENGTH0
%token PRINT
%token PRINTF
%token SPLIT
%token MATCH_FUNC
%token SUB
%token GSUB
%token GENSUB
%token ALENGTH_FUNC
%token ASORT_FUNC
%token DO
%token WHILE
%token FOR
%token BREAK
%token CONTINUE
%token IF
%token ELSE
%token DELETE
%token a_BEGIN
%token a_END
%token EXIT
%token ABORT
%token NEXT
%token NEXTFILE
%token RETURN
%token FUNCTION

%right /*1*/ ASSIGN ADD_ASG SUB_ASG MUL_ASG DIV_ASG MOD_ASG POW_ASG
%right /*2*/ QMARK COLON
%left /*3*/ OR
%left /*4*/ AND
%left /*5*/ IN
%left /*6*/ MATCH
%left /*7*/ EQ NEQ LT LTE GT GTE
%left /*8*/ CAT
%left /*9*/ GETLINE
%left /*10*/ PLUS MINUS
%left /*11*/ MUL DIV MOD
%left /*12*/ NOT UMINUS
%nonassoc /*13*/ IO_IN PIPE COPROCESS
%right /*14*/ POW
%left /*15*/ INC_or_DEC
%left /*16*/ DOLLAR FIELD
%right /*17*/ LPAREN RPAREN

%start program

%%

program :
	 program_block
	| program program_block
	;
program_block :
	 PA_block
	| function_def
	| NL
	//| outside_error block
	;
PA_block :
	 block
	;
PA_block :
	 a_BEGIN block
	;
PA_block :
	 a_END block
	;
PA_block :
	 expr block_or_separator
	;
PA_block :
	 expr COMMA expr block_or_separator
	;
block :
	 LBRACE statement_list RBRACE
	//| LBRACE error RBRACE
	;
block_or_separator :
	 block
	| separator
	;
statement_list :
	 statement
	| statement_list statement
	;
statement :
	 block
	| expr separator
	| separator
	//| error separator
	| BREAK separator
	| CONTINUE separator
	| return_statement
	| NEXT separator
	| NEXTFILE separator
	;
separator :
	 NL
	| SEMI_COLON
	;
expr :
	 cat_expr
	| lvalue ASSIGN /*1R*/ expr
	| lvalue ADD_ASG /*1R*/ expr
	| lvalue SUB_ASG /*1R*/ expr
	| lvalue MUL_ASG /*1R*/ expr
	| lvalue DIV_ASG /*1R*/ expr
	| lvalue MOD_ASG /*1R*/ expr
	| lvalue POW_ASG /*1R*/ expr
	| expr EQ /*7L*/ expr
	| expr NEQ /*7L*/ expr
	| expr LT /*7L*/ expr
	| expr LTE /*7L*/ expr
	| expr GT /*7L*/ expr
	| expr GTE /*7L*/ expr
	| expr MATCH /*6L*/ expr
	;
expr :
	 expr OR /*3L*/ expr
	;
expr :
	 expr AND /*4L*/ expr
	;
expr :
	 expr QMARK /*2R*/ expr COLON /*2R*/ expr
	;
cat_expr :
	 p_expr %prec CAT /*8L*/
	| cat_expr p_expr %prec CAT /*8L*/
	;
p_expr :
	 DOUBLE
	| STRING_
	| ID %prec AND /*4L*/
	| LPAREN /*17R*/ expr RPAREN /*17R*/
	| RE
	| p_expr PLUS /*10L*/ p_expr
	| p_expr MINUS /*10L*/ p_expr
	| p_expr MUL /*11L*/ p_expr
	| p_expr DIV /*11L*/ p_expr
	| p_expr MOD /*11L*/ p_expr
	| p_expr POW /*14R*/ p_expr
	| NOT /*12L*/ p_expr
	| PLUS /*10L*/ p_expr %prec UMINUS /*12L*/
	| MINUS /*10L*/ p_expr %prec UMINUS /*12L*/
	| builtin
	| ID INC_or_DEC /*15L*/
	| INC_or_DEC /*15L*/ lvalue
	| field INC_or_DEC /*15L*/
	| INC_or_DEC /*15L*/ field
	;
lvalue :
	 ID
	| BUILTIN mark LPAREN /*17R*/ arglist RPAREN /*17R*/
	;
arglist :
	 /*empty*/
	| args
	;
args :
	 expr %prec LPAREN /*17R*/
	| args COMMA expr
	;
len_arg :
	 expr %prec LPAREN /*17R*/
	;
builtin :
	 BUILTIN mark LPAREN /*17R*/ arglist RPAREN /*17R*/
	| LENGTH mark LPAREN /*17R*/ len_arg RPAREN /*17R*/
	| LENGTH0
	;
mark :
	 /*empty*/
	;
statement :
	 print mark pr_args pr_direction separator
	;
print :
	 PRINT
	| PRINTF
	;
pr_args :
	 arglist
	| LPAREN /*17R*/ arg2 RPAREN /*17R*/
	| LPAREN /*17R*/ RPAREN /*17R*/
	;
arg2 :
	 expr COMMA expr
	| arg2 COMMA expr
	;
pr_direction :
	 /*empty*/
	| IO_OUT expr
	| COPROCESS_OUT expr
	;
if_front :
	 IF LPAREN /*17R*/ expr RPAREN /*17R*/
	;
statement :
	 if_front statement
	;
else :
	 ELSE
	;
statement :
	 if_front statement else statement
	;
do :
	 DO
	;
statement :
	 do statement WHILE LPAREN /*17R*/ expr RPAREN /*17R*/ separator
	;
while_front :
	 WHILE LPAREN /*17R*/ expr RPAREN /*17R*/
	;
statement :
	 while_front statement
	| for1 for2 for3 statement
	;
for1 :
	 FOR LPAREN /*17R*/ SEMI_COLON
	| FOR LPAREN /*17R*/ expr SEMI_COLON
	;
for2 :
	 SEMI_COLON
	| expr SEMI_COLON
	;
for3 :
	 RPAREN /*17R*/
	| expr RPAREN /*17R*/
	;
expr :
	 expr IN /*5L*/ ID
	| LPAREN /*17R*/ arg2 RPAREN /*17R*/ IN /*5L*/ ID
	;
lvalue :
	 ID mark LBOX args RBOX
	;
p_expr :
	 ID mark LBOX args RBOX %prec AND /*4L*/
	| ID mark LBOX args RBOX INC_or_DEC /*15L*/
	;
statement :
	 DELETE ID mark LBOX args RBOX separator
	| DELETE ID separator
	;
array_loop_front :
	 FOR LPAREN /*17R*/ ID IN /*5L*/ ID RPAREN /*17R*/
	;
statement :
	 array_loop_front statement
	;
field :
	 FIELD /*16L*/
	| DOLLAR /*16L*/ D_ID
	| DOLLAR /*16L*/ D_ID mark LBOX args RBOX
	| DOLLAR /*16L*/ p_expr
	| LPAREN /*17R*/ field RPAREN /*17R*/
	;
p_expr :
	 field %prec CAT /*8L*/
	;
expr :
	 field ASSIGN /*1R*/ expr
	| field ADD_ASG /*1R*/ expr
	| field SUB_ASG /*1R*/ expr
	| field MUL_ASG /*1R*/ expr
	| field DIV_ASG /*1R*/ expr
	| field MOD_ASG /*1R*/ expr
	| field POW_ASG /*1R*/ expr
	;
p_expr :
	 split_front split_back
	;
split_front :
	 SPLIT LPAREN /*17R*/ expr COMMA ID
	;
split_back :
	 RPAREN /*17R*/
	| COMMA expr RPAREN /*17R*/
	;
p_expr :
	 ALENGTH_FUNC LPAREN /*17R*/ ID RPAREN /*17R*/
	| ASORT_FUNC mark LPAREN /*17R*/ ID RPAREN /*17R*/
	| ASORT_FUNC mark LPAREN /*17R*/ ID COMMA ID RPAREN /*17R*/
	| MATCH_FUNC LPAREN /*17R*/ expr COMMA re_arg COMMA ID RPAREN /*17R*/
	| MATCH_FUNC LPAREN /*17R*/ expr COMMA re_arg RPAREN /*17R*/
	;
re_arg :
	 expr
	;
statement :
	 EXIT separator
	| EXIT expr separator
	| ABORT separator
	| ABORT expr separator
	;
return_statement :
	 RETURN separator
	| RETURN expr separator
	;
p_expr :
	 getline %prec GETLINE /*9L*/
	| getline fvalue %prec GETLINE /*9L*/
	| getline_file p_expr %prec IO_IN /*13N*/
	| p_expr COPROCESS /*13N*/ GETLINE /*9L*/
	| p_expr COPROCESS /*13N*/ GETLINE /*9L*/ fvalue
	| p_expr PIPE /*13N*/ GETLINE /*9L*/
	| p_expr PIPE /*13N*/ GETLINE /*9L*/ fvalue
	;
getline :
	 GETLINE /*9L*/
	;
fvalue :
	 lvalue
	| field
	;
getline_file :
	 getline IO_IN /*13N*/
	| getline fvalue IO_IN /*13N*/
	;
p_expr :
	 gensub LPAREN /*17R*/ re_arg COMMA expr COMMA expr gensub_back
	;
gensub :
	 GENSUB
	;
p_expr :
	 sub_or_gsub LPAREN /*17R*/ re_arg COMMA expr sub_back
	;
sub_or_gsub :
	 SUB
	| GSUB
	;
sub_back :
	 RPAREN /*17R*/
	| COMMA fvalue RPAREN /*17R*/
	;
gensub_back :
	 RPAREN /*17R*/
	| COMMA p_expr RPAREN /*17R*/
	;
function_def :
	 funct_start block
	;
funct_start :
	 funct_head LPAREN /*17R*/ f_arglist RPAREN /*17R*/
	;
funct_head :
	 FUNCTION ID
	| FUNCTION FUNCT_ID
	;
f_arglist :
	 /*empty*/
	| f_args
	;
f_args :
	 ID
	| f_args COMMA ID
	;
//outside_error :
//	 error
//	;
p_expr :
	 FUNCT_ID mark call_args
	;
call_args :
	 LPAREN /*17R*/ RPAREN /*17R*/
	| ca_front ca_back
	;
ca_front :
	 LPAREN /*17R*/
	| ca_front expr COMMA
	| ca_front ID COMMA
	;
ca_back :
	 expr RPAREN /*17R*/
	| ID RPAREN /*17R*/
	;

%%

ident		[a-zA-Z_][a-zA-Z_0-9]*

%%

#.*   skip()
[ \t]   skip()

"BEGIN"  a_BEGIN
"END"  a_END
"print"  PRINT
"printf"  PRINTF
"do"  DO
"while"  WHILE
"for"  FOR
"break"  BREAK
"continue"  CONTINUE
"if"  IF
"else"  ELSE
"in"  IN
"delete"  DELETE
"split"  SPLIT
"match"  MATCH_FUNC
"exit"  EXIT
"abort"  ABORT
"next"  NEXT
"nextfile"  NEXTFILE
"return"  RETURN
"getline"  GETLINE
"sub"  SUB
"gsub"  GSUB
"gensub"  GENSUB
"func"  FUNCTION
"function"  FUNCTION
"alength"  ALENGTH_FUNC
"asort"  ASORT_FUNC

"xxyyzz"|"length"|"index"|"substr"|"sprintf" BUILTIN
"sin"|"cos"|"atan2"|"exp"|"log"|"int"|"sqrt" BUILTIN
"rand"|"srand"|"close"|"system"|"toupper" BUILTIN
"tolower"|"fflush"|"gensub" BUILTIN

\n 	NL
";" 	SEMI_COLON
"{" 	LBRACE
"}" 	RBRACE
"[" 	LBOX
"]" 	RBOX
"," 	COMMA
">>" 	IO_OUT
"=" 	ASSIGN
"+=" 	ADD_ASG
"-=" 	SUB_ASG
"*=" 	MUL_ASG
"/=" 	DIV_ASG
"%=" 	MOD_ASG
"**=" 	POW_ASG
"?" 	QMARK
":" 	COLON
"||" 	OR
"&&" 	AND
"!~"|"~" 	MATCH
"==" 	EQ
"!=" 	NEQ
"<" 	LT
"<=" 	LTE
">" 	GT
">=" 	GTE
"CAT" 	CAT
"+" 	PLUS
"-" 	MINUS
"*" 	MUL
"/" 	DIV
"%" 	MOD
"!" 	NOT
"IO_IN" 	IO_IN
"|" 	PIPE
"|&" 	COPROCESS
"**" 	POW
"++"|"--" 	INC_or_DEC
"$" 	DOLLAR
"$"[0-9] 	FIELD
"(" 	LPAREN
")" 	RPAREN

"FUNCT_ID" 	FUNCT_ID
"LENGTH" 	LENGTH
"LENGTH0" 	LENGTH0
"<<"	COPROCESS_OUT

[0-9]+(\.[0-9]+)? 	DOUBLE
\"(\\.|[^\r\n\"\\])*\" 	STRING_
\/(\\.|[^\r\n\/])+\/ 	RE
{ident} 	ID
"$"{ident} 	D_ID

%%
