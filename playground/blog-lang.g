//From: https://github.com/lileicc/swift/blob/57c4a4cd065f1149f86f3d04402f8dbdce1ac5ff/src/parse/blog.yacc

/*Tokens*/
%token ELSE
%token IF
%token THEN
%token TYPE
%token RANDOM
%token FIXED
%token ORIGIN
%token DISTINCT
%token QUERY
%token OBS
%token PARAM
///%token LIST
///%token MAP
%token DISTRIBUTION
%token EXTERN
%token CASE
%token IN
%token EXISTS_
%token FORALL_
%token FOR
%token NULLITY
%token INT_LITERAL
%token DOUBLE_LITERAL
%token BOOLEAN_LITERAL
%token CHAR_LITERAL
%token STRING_LITERAL
%token ID
///%token PARFACTOR
///%token FACTOR
///%token ERROR
///%token ELSEIF
%token AT_
%token PLUS_
%token MULT_
%token DIV_
%token MOD_
%token POWER_
%token MINUS_
%token UMINUS
///%token LST
%token LT_
%token GT_
%token LEQ_
%token GEQ_
%token EQEQ_
%token NEQ_
%token EQ_
%token DISTRIB
%token NOT_
%token AND_
%token OR_
%token DOUBLERIGHTARROW
%token COMMA
%token SEMI
%token COLON
%token DOT
%token NUMSIGN
%token RIGHTARROW
%token LPAREN
%token RPAREN
%token LBRACE
%token RBRACE
%token LBRACKET
%token RBRACKET

%left /*1*/ THEN EXISTS_ FORALL_
%nonassoc /*2*/ EQ_ DISTRIB
%left /*3*/ SEMI
%left /*4*/ ELSE
%left /*5*/ DOUBLERIGHTARROW
%left /*6*/ AND_ OR_
%nonassoc /*7*/ LT_ GT_ LEQ_ GEQ_ EQEQ_ NEQ_
%left /*8*/ PLUS_ MINUS_
%left /*9*/ MULT_ DIV_ MOD_ POWER_
%left /*10*/ UMINUS
%left /*11*/ AT_ NOT_
%left /*12*/ LBRACKET

%start program

%%

program :
	opt_statement_lst
	;

opt_statement_lst :
	/*empty*/
	| statement_lst
	;

statement_lst :
	statement_lst statement SEMI /*3L*/
	| statement SEMI /*3L*/
	| statement_lst statement
	| statement
	;

statement :
	declaration_stmt
	| evidence_stmt
	| query_stmt
	//| error
	;

declaration_stmt :
	type_decl
	| fixed_func_decl
	| rand_func_decl
	| extern_func_decl
	| origin_func_decl
	| number_stmt
	| distinct_decl
	| parameter_decl
	| distribution_decl
	;

type_decl :
	TYPE ID
	//| TYPE error
	;

type :
	refer_name
	| array_type
	;

array_type_or_sub :
	refer_name LBRACKET /*12L*/
	;

array_type :
	array_type_or_sub RBRACKET
	| array_type LBRACKET /*12L*/ RBRACKET
	;

opt_parenthesized_type_var_lst :
	/*empty*/
	| LPAREN RPAREN
	| LPAREN type_var_lst RPAREN
	| type_var_lst
	;

var_decl :
	type ID
	;

extra_commas :
	COMMA COMMA
	| extra_commas COMMA
	;

extra_semis :
	SEMI /*3L*/ SEMI /*3L*/
	| extra_semis SEMI /*3L*/
	;

type_var_lst :
	type_var_lst COMMA var_decl
	| var_decl
	| type_var_lst extra_commas var_decl
	| type_var_lst var_decl
	//| type_var_lst COMMA error
	;

fixed_func_decl :
	FIXED type ID opt_parenthesized_type_var_lst EQ_ /*2N*/ expression
	//| FIXED error
	;

extern_func_decl :
	EXTERN type ID opt_parenthesized_type_var_lst
	//| EXTERN error
	;

rand_func_decl :
	RANDOM type ID opt_parenthesized_type_var_lst dependency_statement_body
	//| RANDOM error dependency_statement_body
	//| RANDOM error
	;

number_stmt :
	NUMSIGN refer_name opt_parenthesized_origin_var_list dependency_statement_body
	| NUMSIGN opt_parenthesized_origin_var_list dependency_statement_body
	//| NUMSIGN refer_name opt_parenthesized_origin_var_list DISTRIB /*2N*/ error
	//| NUMSIGN refer_name error
	//| NUMSIGN error
	;

opt_parenthesized_origin_var_list :
	LPAREN origin_var_list RPAREN
	| /*empty*/
	;

origin_var_list :
	origin_var_list COMMA ID EQ_ /*2N*/ ID
	| origin_var_list extra_commas ID EQ_ /*2N*/ ID
	//| origin_var_list COMMA ID EQ_ /*2N*/ error
	| origin_var_list ID EQ_ /*2N*/ ID
	| ID EQ_ /*2N*/ ID
	| ID ID
	;

origin_func_decl :
	ORIGIN type ID LPAREN type RPAREN
	//| ORIGIN type ID LPAREN error RPAREN
	| ORIGIN type LPAREN type RPAREN
	| ORIGIN type ID type RPAREN
	//| ORIGIN error
	;

distinct_decl :
	DISTINCT refer_name id_or_subid_list
	;

id_or_subid_list :
	id_or_subid
	| id_or_subid_list COMMA id_or_subid
	| id_or_subid_list id_or_subid
	| id_or_subid_list extra_commas id_or_subid
	;

id_or_subid :
	ID
	| ID LBRACKET /*12L*/ INT_LITERAL RBRACKET
	;

distribution_decl :
	DISTRIBUTION ID EQ_ /*2N*/ refer_name LPAREN opt_expression_list RPAREN
	;

refer_name :
	ID
	| ID DOT refer_name
	;

dependency_statement_body :
	DISTRIB /*2N*/ expression
	;

parameter_decl :
	PARAM type ID
	| PARAM type ID COLON expression
	;

expression :
	operation_expr
	| literal
	| function_call
	| list_expr
	| map_construct_expression
	| quantified_formula
	| set_expr
	| number_expr
	| if_expr
	| case_expr
	;

literal :
	STRING_LITERAL
	| CHAR_LITERAL
	| INT_LITERAL
	| DOUBLE_LITERAL
	| BOOLEAN_LITERAL
	| NULLITY
	;

operation_expr :
	expression PLUS_ /*8L*/ expression
	| expression MINUS_ /*8L*/ expression
	| expression MULT_ /*9L*/ expression
	| expression DIV_ /*9L*/ expression
	| expression MOD_ /*9L*/ expression
	| expression POWER_ /*9L*/ expression
	| expression LT_ /*7N*/ expression
	| expression GT_ /*7N*/ expression
	| expression LEQ_ /*7N*/ expression
	| expression GEQ_ /*7N*/ expression
	| expression EQEQ_ /*7N*/ expression
	| expression NEQ_ /*7N*/ expression
	| expression AND_ /*6L*/ expression
	| expression OR_ /*6L*/ expression
	| expression DOUBLERIGHTARROW /*5L*/ expression
	| expression LBRACKET /*12L*/ expression RBRACKET
	| unary_operation_expr
	;

unary_operation_expr :
	MINUS_ /*8L*/ expression %prec UMINUS /*10L*/
	| NOT_ /*11L*/ expression
	| AT_ /*11L*/ expression
	| LPAREN expression RPAREN
	;

quantified_formula :
	FORALL_ /*1L*/ type ID expression %prec FORALL_ /*1L*/
	| EXISTS_ /*1L*/ type ID expression %prec EXISTS_ /*1L*/
	;

function_call :
	refer_name LPAREN opt_expression_list RPAREN
	| refer_name
	//| refer_name LPAREN error
	;

if_expr :
	IF expression THEN /*1L*/ expression ELSE /*4L*/ expression
	| IF expression THEN /*1L*/ expression
	;

case_expr :
	CASE expression IN map_construct_expression
	;

opt_expression_list :
	expression_list
	| /*empty*/
	;

expression_list :
	expression_list COMMA expression
	| expression_list extra_commas expression
	| expression
	;

list_expr :
	LBRACKET /*12L*/ opt_expression_list RBRACKET
	| LBRACKET /*12L*/ semi_colon_separated_expression_list RBRACKET
	;

semi_colon_separated_expression_list :
	expression_list SEMI /*3L*/ semi_colon_separated_expression_list
	| expression_list extra_semis semi_colon_separated_expression_list
	| expression_list SEMI /*3L*/ expression_list
	;

map_construct_expression :
	LBRACE expression_pair_list RBRACE
	;

expression_pair_list :
	expression_pair_list COMMA expression RIGHTARROW expression
	| expression RIGHTARROW expression
	;

number_expr :
	NUMSIGN set_expr
	| NUMSIGN type
	//| NUMSIGN error
	;

set_expr :
	explicit_set
	| tuple_set
	;

explicit_set :
	LBRACE opt_expression_list RBRACE
	;

comprehension_expr :
	expression_list FOR type_var_lst COLON expression
	| expression_list FOR type_var_lst
	;

tuple_set :
	LBRACE comprehension_expr RBRACE
	;

evidence_stmt :
	OBS evidence
	| OBS evidence FOR type_var_lst
	| OBS evidence FOR type_var_lst COLON expression
	//| OBS error FOR type_var_lst
	//| OBS error FOR type_var_lst COLON expression
	//| OBS error
	;

evidence :
	value_evidence
	;

value_evidence :
	expression EQ_ /*2N*/ expression
	//| error EQ_ /*2N*/ expression
	//| expression EQ_ /*2N*/ error
	;

query_stmt :
	QUERY expression
	| QUERY expression FOR type_var_lst
	| QUERY expression FOR type_var_lst COLON expression
	//| QUERY error FOR type_var_lst
	//| QUERY error FOR type_var_lst COLON expression
	//| QUERY error
	;

%%

Alpha            [A-Za-z]

Digit            [0-9]

Identifier       {Alpha}({Alpha}|{Digit}|_)*

IntegerLiteral   {Digit}+

FLit1            {Digit}+\.{Digit}*
FLit2            \.{Digit}+
FLit3            {Digit}+
Exponent         [eE][+-]?{Digit}+
DoubleLiteral    ({FLit1}|{FLit2}|{FLit3}){Exponent}?

LineTerminator   [\n\r\r\n]

InputCharacter   [^\r\n]

Whitespace       [ \f\t\n\r]

OCTAL_DIGIT      [01234567]

ZERO_TO_THREE    [0123]

HEX_DIGIT        [0123456789abcdefABCDEF]

/* comments */
TraditionalComment      "/*"([^*]|\*+[^*/])*\*+"/"
EndOfLineComment        "//"{InputCharacter}*{LineTerminator}?
DocumentationComment    "/*""*"+[^/*]~"*/"
Comment                 {TraditionalComment}|{EndOfLineComment}|{DocumentationComment}


%%

\"(\\.|[^"\n\r\\])*\"	STRING_LITERAL

'(\\.|[^'\n\r\\])+'	CHAR_LITERAL

[Ii][Nn]  IN
[Cc][Aa][Ss][Ee]  CASE
[Tt][Yy][Pp][Ee]  TYPE
[Rr][Aa][Nn][Dd][Oo][Mm]  RANDOM
[Nn][Oo][Nn][Rr][Aa][Nn][Dd][Oo][Mm]  FIXED
[Ff][Ii][Xx][Ee][Dd]  FIXED
[Gg][Ee][Nn][Ee][Rr][Aa][Tt][Ii][Nn][Gg]  ORIGIN
[Oo][Rr][Ii][Gg][Ii][Nn]  ORIGIN
[Gg][Uu][Aa][Rr][Aa][Nn][Tt][Ee][Ee][Dd]  DISTINCT
[Dd][Ii][Ss][Tt][Ii][Nn][Cc][Tt]  DISTINCT
///[Ff][Aa][Cc][Tt][Oo][Rr]  FACTOR
///[Pp][Aa][Rr][Ff][Aa][Cc][Tt][Oo][Rr]  PARFACTOR
[Tt][Hh][Ee][Nn]      THEN
[Ee][Ll][Ss][Ee]  	 ELSE
[Ff][Oo][Rr]          FOR
///[Ee][Ll][Ss][Ee][Ii][Ff]   ELSEIF
[Ii][Ff]  		 IF
[Qq][Uu][Ee][Rr][Yy]	 QUERY
[Oo][Bb][Ss]          OBS
[Pp][Aa][Rr][Aa][Mm]  PARAM
[Ee][Xx][Ii][Ss][Tt][Ss]  EXISTS_
[Ff][Oo][Rr][Aa][Ll][Ll]  FORALL_
///[Ll][Ii][Ss][Tt]  LIST
///[Mm][Aa][Pp]  MAP
[Dd][Ii][Tt][Rr][Ii][Bb][Uu][Tt][Ii][Oo][Nn]  DISTRIBUTION
[Ee][Xx][Tt][Ee][Rr][Nn]  EXTERN


"true"	BOOLEAN_LITERAL
"false" BOOLEAN_LITERAL
"null"  NULLITY
{IntegerLiteral}  INT_LITERAL
{DoubleLiteral}   DOUBLE_LITERAL

"+"      PLUS_
"-"      MINUS_
"*"      MULT_
"/"      DIV_
"%"      MOD_
"^"      POWER_
"<"      LT_
">"      GT_
"<="     LEQ_
">="     GEQ_
"=="     EQEQ_
"!="     NEQ_
"&"	     AND_
"|"      OR_
"!"	     NOT_
"@"      AT_
"->"	 RIGHTARROW
"=>"     DOUBLERIGHTARROW

"("		 LPAREN
")"		 RPAREN
"}"		 RBRACE
"{"		 LBRACE
"["		 LBRACKET
"]"		 RBRACKET
";"		 SEMI
":"		 COLON
"."      DOT
","		 COMMA
"="		 EQ_
"~"		 DISTRIB
"#"      NUMSIGN

{Comment} skip()

{Whitespace} skip()

{Identifier} ID


%%
