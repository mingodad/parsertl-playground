//From: https://github.com/CaspianA1/common-prolog-frontend/blob/c7b89998eb380da899dfe941bd4fc95eb0610099/parse.y

%start expr_seq

//%token eof
%token lparen
%token rparen
%token lbracket
%token rbracket
%token vline
%token comma
%token semicolon
%token horn
%token end_stmt
%token wildcard
%token math_evaluator
%token unifier
%token negation
%token exponent
%token add
%token subtract
%token multiply
%token divide
%token smaller
%token smaller_eq
%token greater
%token greater_eq
%token cut
%token variable
%token atom
%token t_string
%token t_integer
%token t_floating

%left lparen rparen
%left add subtract
%left multiply divide
%left exponent

%right smaller smaller_eq greater greater_eq

%%

expr :
	decl_fact
	| atom end_stmt
	| decl_rule
	| atom horn rule_exprs
	;

expr_seq :
	expr
	| expr_seq expr
	//| eof
	;

list :
	lbracket list_seq rbracket
	;

list_seq :
	value
	| value vline value
	| value comma list_seq
	;

value :
	| atom
	| t_string
	| wildcard
	| structure
	| list
	| math_expr_low
	;

unification :
	value unifier value
	;

structure :
	atom lparen args rparen
	;

args :
	value
	| args comma value
	;

expr_in_functor :
	| unification
	| structure
	| negation expr_in_functor
	| cut
	| atom
	| eval_math
	| math_expr_low
	;

decl_fact :
	structure end_stmt
	;

decl_rule :
	structure horn rule_exprs
	;

expr_delim :
	comma
	| semicolon
	;

rule_exprs :
	expr_in_functor_oom end_stmt
	;

expr_in_functor_oom :
	expr_in_functor
	| expr_in_functor_oom expr_delim expr_in_functor
	;

eval_math :
	math_expr_low math_evaluator math_expr_low
	;

prec_1 :
	smaller
	| smaller_eq
	| greater
	| greater_eq
	;

prec_2 :
	add
	| subtract
	;

prec_3 :
	multiply
	| divide
	;

math_expr_low :  // value comparisons
	math_expr_high
	| math_expr_low prec_1 math_expr_high
	;

math_expr_high :  // add/sub: pemdAS
	math_term_low
	| math_expr_high prec_2 math_term_low
	;

math_term_low :  // mul/div: peMDas
	math_term_high
	| math_term_low prec_3 math_term_high
	;

math_term_high :  // exp: pEmdas
	math_factor
	| math_term_high exponent math_factor
	;

math_factor :  // parens: Pemdas
	operand
	| lparen math_expr_low rparen
	;

operand :  // numbers
	t_integer
	| t_floating
	| variable
	;

%%

%%

[ \t\r\n]+	skip()
"%".*	skip()
"/*"(?s:.)*?"*/"	skip()

"+"	add
","	comma
"!"	cut
"/"	divide
"."	end_stmt
"^"	exponent
">"	greater
">="	greater_eq
":-"	horn
"["	lbracket
"("	lparen
"is"	math_evaluator
"*"	multiply
"\\+"	negation
"]"	rbracket
")"	rparen
";"	semicolon
"<"	smaller
"<="	smaller_eq
"-"	subtract
"="	unifier
"|"	vline
"_"	wildcard

-?[0-9]+\.[0-9]+	t_floating
-?[0-9]+	t_integer
\"[^"\r\n]*\"	t_string
'[^'\r\n]*'	atom
[a-z_][a-zA-Z0-9_]*	atom
[A-Z_][a-zA-Z0-9_]*	variable

%%
