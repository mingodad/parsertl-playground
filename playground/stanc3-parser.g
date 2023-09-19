/* From: https://github.com/stan-dev/stanc3/blob/master/src/frontend/parser.mly */
/** The parser for Stan. A Menhir file. */

%token AND
%token ARRAY
%token ARROWASSIGN
%token ASSIGN
%token BANG
%token BAR
%token BREAK
%token CHOLESKYFACTORCORR
%token CHOLESKYFACTORCOV
%token COLON
%token COMMA
%token COMPLEX
%token COMPLEXMATRIX
%token COMPLEXROWVECTOR
%token COMPLEXVECTOR
%token CONTINUE
%token CORRMATRIX
%token COVMATRIX
%token DATABLOCK
%token DIVIDE
%token DIVIDEASSIGN
%token DOTNUMERAL
%token ELSE
%token ELTDIVIDE
%token ELTDIVIDEASSIGN
%token ELTPOW
%token ELTTIMES
%token ELTTIMESASSIGN
//%token EOF
%token EQUALS
%token FOR
%token FUNCTIONBLOCK
%token GENERATEDQUANTITIESBLOCK
%token GEQ
%token GETLP
%token HAT
%token IDENTIFIER
%token IDIVIDE
%token IF
%token IMAGNUMERAL
%token IN
%token INCREMENTLOGPROB
%token INT
%token INTNUMERAL
%token LABRACK
%token LBRACE
%token LBRACK
%token LDIVIDE
%token LEQ
%token LOWER
%token LPAREN
%token MATRIX
%token MINUS
%token MINUSASSIGN
%token MODELBLOCK
%token MODULO
%token MULTIPLIER
%token NEQUALS
%token OFFSET
%token OR
%token ORDERED
%token PARAMETERSBLOCK
%token PLUS
%token PLUSASSIGN
%token POSITIVEORDERED
%token PRINT
%token PROFILE
%token QMARK
%token RABRACK
%token RBRACE
%token RBRACK
%token REAL
%token REALNUMERAL
%token REJECT
%token RETURN
%token ROWVECTOR
%token RPAREN
%token SEMICOLON
%token SIMPLEX
%token STRINGLITERAL
%token TARGET
%token TILDE
%token TIMES
%token TIMESASSIGN
%token TRANSFORMEDDATABLOCK
%token TRANSFORMEDPARAMETERSBLOCK
%token TRANSPOSE
%token TRUNCATE
%token TUPLE
%token UNITVECTOR
%token UPPER
%token VECTOR
%token VOID
%token WHILE

/* UNREACHABLE tokens will never be produced by the lexer, so we can use them as
   "a thing that will never parse". This is useful in a few places. For example,
   when we the parser to differentiate between different failing states for
   error message purposes, we can partially accept one of them and then fail by
   requiring an UNREACHABLE token.
 */
%token UNREACHABLE

%right COMMA
%right COLON QMARK
%left OR
%left AND
%left EQUALS NEQUALS
%left GEQ LABRACK LEQ RABRACK
%left MINUS PLUS
%left DIVIDE ELTDIVIDE ELTTIMES MODULO TIMES
%left IDIVIDE LDIVIDE
%nonassoc unary_over_binary
%right ELTPOW HAT
%left TRANSPOSE
%left LBRACK
%nonassoc below_ELSE
%nonassoc ELSE

//%start functions_only
%start program

%%

option_DATABLOCK_ :
	/*empty*/
	| DATABLOCK
	;

option_data_block_ :
	/*empty*/
	| data_block
	;

option_expression_ :
	/*empty*/
	| lhs
	| non_lhs
	;

option_function_block_ :
	/*empty*/
	| function_block
	;

option_generated_quantities_block_ :
	/*empty*/
	| generated_quantities_block
	;

option_model_block_ :
	/*empty*/
	| model_block
	;

option_pair_ASSIGN_expression__ :
	/*empty*/
	| ASSIGN lhs
	| ASSIGN non_lhs
	;

option_pair_ASSIGN_no_assign__ :
	/*empty*/
	| ASSIGN no_assign
	;

option_pair_COMMA_expression__ :
	/*empty*/
	| COMMA lhs
	| COMMA non_lhs
	;

option_parameters_block_ :
	/*empty*/
	| parameters_block
	;

option_remaining_declarations_expression__ :
	/*empty*/
	| remaining_declarations_expression_
	;

option_remaining_declarations_no_assign__ :
	/*empty*/
	| remaining_declarations_no_assign_
	;

option_transformed_data_block_ :
	/*empty*/
	| transformed_data_block
	;

option_transformed_parameters_block_ :
	/*empty*/
	| transformed_parameters_block
	;

option_truncation_ :
	/*empty*/
	| truncation
	;

option_unsized_dims_ :
	/*empty*/
	| unsized_dims
	;

loption_separated_nonempty_list_COMMA_arg_decl__ :
	/*empty*/
	| separated_nonempty_list_COMMA_arg_decl_
	;

loption_separated_nonempty_list_COMMA_expression__ :
	/*empty*/
	| separated_nonempty_list_COMMA_expression_
	;

list_COMMA_ :
	/*empty*/
	| COMMA list_COMMA_
	;

list_function_def_ :
	/*empty*/
	| function_def list_function_def_
	;

list_top_var_decl_no_assign_ :
	/*empty*/
	| top_var_decl_no_assign list_top_var_decl_no_assign_
	;

list_top_vardecl_or_statement_ :
	/*empty*/
	| top_vardecl_or_statement list_top_vardecl_or_statement_
	;

list_vardecl_or_statement_ :
	/*empty*/
	| vardecl_or_statement list_vardecl_or_statement_
	;

separated_nonempty_list_COMMA_arg_decl_ :
	arg_decl
	| arg_decl COMMA separated_nonempty_list_COMMA_arg_decl_
	;

separated_nonempty_list_COMMA_expression_ :
	lhs
	| non_lhs
	| lhs COMMA separated_nonempty_list_COMMA_expression_
	| non_lhs COMMA separated_nonempty_list_COMMA_expression_
	;

separated_nonempty_list_COMMA_higher_type_sized_basic_type__ :
	array_type_sized_basic_type_
	| tuple_type_sized_basic_type_
	| sized_basic_type
	| array_type_sized_basic_type_ COMMA separated_nonempty_list_COMMA_higher_type_sized_basic_type__
	| tuple_type_sized_basic_type_ COMMA separated_nonempty_list_COMMA_higher_type_sized_basic_type__
	| sized_basic_type COMMA separated_nonempty_list_COMMA_higher_type_sized_basic_type__
	;

separated_nonempty_list_COMMA_higher_type_top_var_type__ :
	array_type_top_var_type_
	| tuple_type_top_var_type_
	| top_var_type
	| array_type_top_var_type_ COMMA separated_nonempty_list_COMMA_higher_type_top_var_type__
	| tuple_type_top_var_type_ COMMA separated_nonempty_list_COMMA_higher_type_top_var_type__
	| top_var_type COMMA separated_nonempty_list_COMMA_higher_type_top_var_type__
	;

separated_nonempty_list_COMMA_id_and_optional_assignment_expression_decl_identifier_after_comma__ :
	id_and_optional_assignment_expression_decl_identifier_after_comma_
	| id_and_optional_assignment_expression_decl_identifier_after_comma_ COMMA separated_nonempty_list_COMMA_id_and_optional_assignment_expression_decl_identifier_after_comma__
	;

separated_nonempty_list_COMMA_id_and_optional_assignment_no_assign_decl_identifier_after_comma__ :
	id_and_optional_assignment_no_assign_decl_identifier_after_comma_
	| id_and_optional_assignment_no_assign_decl_identifier_after_comma_ COMMA separated_nonempty_list_COMMA_id_and_optional_assignment_no_assign_decl_identifier_after_comma__
	;

separated_nonempty_list_COMMA_unsized_type_ :
	unsized_type
	| unsized_type COMMA separated_nonempty_list_COMMA_unsized_type_
	;

program :
	option_function_block_ option_data_block_ option_transformed_data_block_ option_parameters_block_ option_transformed_parameters_block_ option_model_block_ option_generated_quantities_block_ //EOF
	;

//functions_only :
//	list_function_def_ //EOF
//	;

function_block :
	FUNCTIONBLOCK LBRACE list_function_def_ RBRACE
	;

data_block :
	DATABLOCK LBRACE list_top_var_decl_no_assign_ RBRACE
	;

transformed_data_block :
	TRANSFORMEDDATABLOCK LBRACE list_top_vardecl_or_statement_ RBRACE
	;

parameters_block :
	PARAMETERSBLOCK LBRACE list_top_var_decl_no_assign_ RBRACE
	;

transformed_parameters_block :
	TRANSFORMEDPARAMETERSBLOCK LBRACE list_top_vardecl_or_statement_ RBRACE
	;

model_block :
	MODELBLOCK LBRACE list_vardecl_or_statement_ RBRACE
	;

generated_quantities_block :
	GENERATEDQUANTITIESBLOCK LBRACE list_top_vardecl_or_statement_ RBRACE
	;

identifier :
	IDENTIFIER
	| TRUNCATE
	;

decl_identifier :
	identifier
	| reserved_word
	;

decl_identifier_after_comma :
	identifier
	| reserved_word
	;

reserved_word :
	FUNCTIONBLOCK
	| DATABLOCK
	| PARAMETERSBLOCK
	| MODELBLOCK
	| RETURN
	| IF
	| ELSE
	| WHILE
	| FOR
	| IN
	| BREAK
	| CONTINUE
	| VOID
	| INT
	| REAL
	| COMPLEX
	| VECTOR
	| ROWVECTOR
	| MATRIX
	| COMPLEXVECTOR
	| COMPLEXROWVECTOR
	| COMPLEXMATRIX
	| ORDERED
	| POSITIVEORDERED
	| SIMPLEX
	| UNITVECTOR
	| CHOLESKYFACTORCORR
	| CHOLESKYFACTORCOV
	| CORRMATRIX
	| COVMATRIX
	| PRINT
	| REJECT
	| TARGET
	| GETLP
	| PROFILE
	| TUPLE
	| OFFSET
	| MULTIPLIER
	| LOWER
	| UPPER
	| ARRAY
	;

function_def :
	return_type decl_identifier LPAREN loption_separated_nonempty_list_COMMA_arg_decl__ RPAREN statement
	;

return_type :
	VOID
	| unsized_type
	;

arg_decl :
	option_DATABLOCK_ unsized_type decl_identifier
	;

unsized_type :
	ARRAY unsized_dims basic_type
	| ARRAY unsized_dims TUPLE LPAREN unsized_type COMMA separated_nonempty_list_COMMA_unsized_type_ RPAREN
	| basic_type option_unsized_dims_
	| TUPLE LPAREN unsized_type COMMA separated_nonempty_list_COMMA_unsized_type_ RPAREN
	;

basic_type :
	INT
	| REAL
	| COMPLEX
	| VECTOR
	| ROWVECTOR
	| MATRIX
	| COMPLEXVECTOR
	| COMPLEXROWVECTOR
	| COMPLEXMATRIX
	;

unsized_dims :
	LBRACK list_COMMA_ RBRACK
	;

no_assign :
	UNREACHABLE
	;

optional_assignment_expression_ :
	option_pair_ASSIGN_expression__
	;

optional_assignment_no_assign_ :
	option_pair_ASSIGN_no_assign__
	;

id_and_optional_assignment_expression_decl_identifier_ :
	decl_identifier optional_assignment_expression_
	;

id_and_optional_assignment_expression_decl_identifier_after_comma_ :
	decl_identifier_after_comma optional_assignment_expression_
	;

id_and_optional_assignment_no_assign_decl_identifier_ :
	decl_identifier optional_assignment_no_assign_
	;

id_and_optional_assignment_no_assign_decl_identifier_after_comma_ :
	decl_identifier_after_comma optional_assignment_no_assign_
	;

remaining_declarations_expression_ :
	COMMA separated_nonempty_list_COMMA_id_and_optional_assignment_expression_decl_identifier_after_comma__
	;

remaining_declarations_no_assign_ :
	COMMA separated_nonempty_list_COMMA_id_and_optional_assignment_no_assign_decl_identifier_after_comma__
	;

decl_sized_basic_type_expression_ :
	sized_basic_type decl_identifier dims optional_assignment_expression_ SEMICOLON
	| array_type_sized_basic_type_ id_and_optional_assignment_expression_decl_identifier_ option_remaining_declarations_expression__ SEMICOLON
	| tuple_type_sized_basic_type_ id_and_optional_assignment_expression_decl_identifier_ option_remaining_declarations_expression__ SEMICOLON
	| sized_basic_type id_and_optional_assignment_expression_decl_identifier_ option_remaining_declarations_expression__ SEMICOLON
	;

decl_top_var_type_expression_ :
	top_var_type decl_identifier dims optional_assignment_expression_ SEMICOLON
	| array_type_top_var_type_ id_and_optional_assignment_expression_decl_identifier_ option_remaining_declarations_expression__ SEMICOLON
	| tuple_type_top_var_type_ id_and_optional_assignment_expression_decl_identifier_ option_remaining_declarations_expression__ SEMICOLON
	| top_var_type id_and_optional_assignment_expression_decl_identifier_ option_remaining_declarations_expression__ SEMICOLON
	;

decl_top_var_type_no_assign_ :
	top_var_type decl_identifier dims optional_assignment_no_assign_ SEMICOLON
	| array_type_top_var_type_ id_and_optional_assignment_no_assign_decl_identifier_ option_remaining_declarations_no_assign__ SEMICOLON
	| tuple_type_top_var_type_ id_and_optional_assignment_no_assign_decl_identifier_ option_remaining_declarations_no_assign__ SEMICOLON
	| top_var_type id_and_optional_assignment_no_assign_decl_identifier_ option_remaining_declarations_no_assign__ SEMICOLON
	;

array_type_sized_basic_type_ :
	arr_dims sized_basic_type
	| arr_dims tuple_type_sized_basic_type_
	;

array_type_top_var_type_ :
	arr_dims top_var_type
	| arr_dims tuple_type_top_var_type_
	;

tuple_type_sized_basic_type_ :
	TUPLE LPAREN array_type_sized_basic_type_ COMMA separated_nonempty_list_COMMA_higher_type_sized_basic_type__ RPAREN
	| TUPLE LPAREN tuple_type_sized_basic_type_ COMMA separated_nonempty_list_COMMA_higher_type_sized_basic_type__ RPAREN
	| TUPLE LPAREN sized_basic_type COMMA separated_nonempty_list_COMMA_higher_type_sized_basic_type__ RPAREN
	;

tuple_type_top_var_type_ :
	TUPLE LPAREN array_type_top_var_type_ COMMA separated_nonempty_list_COMMA_higher_type_top_var_type__ RPAREN
	| TUPLE LPAREN tuple_type_top_var_type_ COMMA separated_nonempty_list_COMMA_higher_type_top_var_type__ RPAREN
	| TUPLE LPAREN top_var_type COMMA separated_nonempty_list_COMMA_higher_type_top_var_type__ RPAREN
	;

var_decl :
	decl_sized_basic_type_expression_
	;

top_var_decl :
	decl_top_var_type_expression_
	;

top_var_decl_no_assign :
	decl_top_var_type_no_assign_
	| SEMICOLON
	;

sized_basic_type :
	INT
	| REAL
	| COMPLEX
	| VECTOR LBRACK lhs RBRACK
	| VECTOR LBRACK non_lhs RBRACK
	| ROWVECTOR LBRACK lhs RBRACK
	| ROWVECTOR LBRACK non_lhs RBRACK
	| MATRIX LBRACK lhs COMMA lhs RBRACK
	| MATRIX LBRACK lhs COMMA non_lhs RBRACK
	| MATRIX LBRACK non_lhs COMMA lhs RBRACK
	| MATRIX LBRACK non_lhs COMMA non_lhs RBRACK
	| COMPLEXVECTOR LBRACK lhs RBRACK
	| COMPLEXVECTOR LBRACK non_lhs RBRACK
	| COMPLEXROWVECTOR LBRACK lhs RBRACK
	| COMPLEXROWVECTOR LBRACK non_lhs RBRACK
	| COMPLEXMATRIX LBRACK lhs COMMA lhs RBRACK
	| COMPLEXMATRIX LBRACK lhs COMMA non_lhs RBRACK
	| COMPLEXMATRIX LBRACK non_lhs COMMA lhs RBRACK
	| COMPLEXMATRIX LBRACK non_lhs COMMA non_lhs RBRACK
	;

top_var_type :
	INT range_constraint
	| REAL type_constraint
	| COMPLEX type_constraint
	| VECTOR type_constraint LBRACK lhs RBRACK
	| VECTOR type_constraint LBRACK non_lhs RBRACK
	| ROWVECTOR type_constraint LBRACK lhs RBRACK
	| ROWVECTOR type_constraint LBRACK non_lhs RBRACK
	| MATRIX type_constraint LBRACK lhs COMMA lhs RBRACK
	| MATRIX type_constraint LBRACK lhs COMMA non_lhs RBRACK
	| MATRIX type_constraint LBRACK non_lhs COMMA lhs RBRACK
	| MATRIX type_constraint LBRACK non_lhs COMMA non_lhs RBRACK
	| COMPLEXVECTOR type_constraint LBRACK lhs RBRACK
	| COMPLEXVECTOR type_constraint LBRACK non_lhs RBRACK
	| COMPLEXROWVECTOR type_constraint LBRACK lhs RBRACK
	| COMPLEXROWVECTOR type_constraint LBRACK non_lhs RBRACK
	| COMPLEXMATRIX type_constraint LBRACK lhs COMMA lhs RBRACK
	| COMPLEXMATRIX type_constraint LBRACK lhs COMMA non_lhs RBRACK
	| COMPLEXMATRIX type_constraint LBRACK non_lhs COMMA lhs RBRACK
	| COMPLEXMATRIX type_constraint LBRACK non_lhs COMMA non_lhs RBRACK
	| ORDERED LBRACK lhs RBRACK
	| ORDERED LBRACK non_lhs RBRACK
	| POSITIVEORDERED LBRACK lhs RBRACK
	| POSITIVEORDERED LBRACK non_lhs RBRACK
	| SIMPLEX LBRACK lhs RBRACK
	| SIMPLEX LBRACK non_lhs RBRACK
	| UNITVECTOR LBRACK lhs RBRACK
	| UNITVECTOR LBRACK non_lhs RBRACK
	| CHOLESKYFACTORCORR LBRACK lhs RBRACK
	| CHOLESKYFACTORCORR LBRACK non_lhs RBRACK
	| CHOLESKYFACTORCOV LBRACK lhs option_pair_COMMA_expression__ RBRACK
	| CHOLESKYFACTORCOV LBRACK non_lhs option_pair_COMMA_expression__ RBRACK
	| CORRMATRIX LBRACK lhs RBRACK
	| CORRMATRIX LBRACK non_lhs RBRACK
	| COVMATRIX LBRACK lhs RBRACK
	| COVMATRIX LBRACK non_lhs RBRACK
	;

type_constraint :
	range_constraint
	| LABRACK offset_mult RABRACK
	;

range_constraint :
	/*empty*/
	| LABRACK range RABRACK
	;

range :
	LOWER ASSIGN constr_expression COMMA UPPER ASSIGN constr_expression
	| UPPER ASSIGN constr_expression COMMA LOWER ASSIGN constr_expression
	| LOWER ASSIGN constr_expression
	| UPPER ASSIGN constr_expression
	;

offset_mult :
	OFFSET ASSIGN constr_expression COMMA MULTIPLIER ASSIGN constr_expression
	| MULTIPLIER ASSIGN constr_expression COMMA OFFSET ASSIGN constr_expression
	| OFFSET ASSIGN constr_expression
	| MULTIPLIER ASSIGN constr_expression
	;

arr_dims :
	ARRAY LBRACK separated_nonempty_list_COMMA_expression_ RBRACK
	;

dims :
	LBRACK separated_nonempty_list_COMMA_expression_ RBRACK
	;

lhs :
	identifier
	| lhs LBRACK indexes RBRACK
	| lhs DOTNUMERAL
	;

non_lhs :
	lhs QMARK lhs COLON lhs
	| lhs QMARK lhs COLON non_lhs
	| lhs QMARK non_lhs COLON lhs
	| lhs QMARK non_lhs COLON non_lhs
	| non_lhs QMARK lhs COLON lhs
	| non_lhs QMARK lhs COLON non_lhs
	| non_lhs QMARK non_lhs COLON lhs
	| non_lhs QMARK non_lhs COLON non_lhs
	| lhs PLUS lhs
	| lhs PLUS non_lhs
	| lhs MINUS lhs
	| lhs MINUS non_lhs
	| lhs TIMES lhs
	| lhs TIMES non_lhs
	| lhs DIVIDE lhs
	| lhs DIVIDE non_lhs
	| lhs IDIVIDE lhs
	| lhs IDIVIDE non_lhs
	| lhs MODULO lhs
	| lhs MODULO non_lhs
	| lhs LDIVIDE lhs
	| lhs LDIVIDE non_lhs
	| lhs ELTTIMES lhs
	| lhs ELTTIMES non_lhs
	| lhs ELTDIVIDE lhs
	| lhs ELTDIVIDE non_lhs
	| lhs HAT lhs
	| lhs HAT non_lhs
	| lhs ELTPOW lhs
	| lhs ELTPOW non_lhs
	| lhs OR lhs
	| lhs OR non_lhs
	| lhs AND lhs
	| lhs AND non_lhs
	| lhs EQUALS lhs
	| lhs EQUALS non_lhs
	| lhs NEQUALS lhs
	| lhs NEQUALS non_lhs
	| lhs LABRACK lhs
	| lhs LABRACK non_lhs
	| lhs LEQ lhs
	| lhs LEQ non_lhs
	| lhs RABRACK lhs
	| lhs RABRACK non_lhs
	| lhs GEQ lhs
	| lhs GEQ non_lhs
	| non_lhs PLUS lhs
	| non_lhs PLUS non_lhs
	| non_lhs MINUS lhs
	| non_lhs MINUS non_lhs
	| non_lhs TIMES lhs
	| non_lhs TIMES non_lhs
	| non_lhs DIVIDE lhs
	| non_lhs DIVIDE non_lhs
	| non_lhs IDIVIDE lhs
	| non_lhs IDIVIDE non_lhs
	| non_lhs MODULO lhs
	| non_lhs MODULO non_lhs
	| non_lhs LDIVIDE lhs
	| non_lhs LDIVIDE non_lhs
	| non_lhs ELTTIMES lhs
	| non_lhs ELTTIMES non_lhs
	| non_lhs ELTDIVIDE lhs
	| non_lhs ELTDIVIDE non_lhs
	| non_lhs HAT lhs
	| non_lhs HAT non_lhs
	| non_lhs ELTPOW lhs
	| non_lhs ELTPOW non_lhs
	| non_lhs OR lhs
	| non_lhs OR non_lhs
	| non_lhs AND lhs
	| non_lhs AND non_lhs
	| non_lhs EQUALS lhs
	| non_lhs EQUALS non_lhs
	| non_lhs NEQUALS lhs
	| non_lhs NEQUALS non_lhs
	| non_lhs LABRACK lhs
	| non_lhs LABRACK non_lhs
	| non_lhs LEQ lhs
	| non_lhs LEQ non_lhs
	| non_lhs RABRACK lhs
	| non_lhs RABRACK non_lhs
	| non_lhs GEQ lhs
	| non_lhs GEQ non_lhs
	| BANG lhs %prec unary_over_binary
	| BANG non_lhs %prec unary_over_binary
	| MINUS lhs %prec unary_over_binary
	| MINUS non_lhs %prec unary_over_binary
	| PLUS lhs %prec unary_over_binary
	| PLUS non_lhs %prec unary_over_binary
	| lhs TRANSPOSE
	| non_lhs TRANSPOSE
	| non_lhs LBRACK indexes RBRACK
	| common_expression
	;

constr_expression :
	constr_expression PLUS constr_expression
	| constr_expression MINUS constr_expression
	| constr_expression TIMES constr_expression
	| constr_expression DIVIDE constr_expression
	| constr_expression IDIVIDE constr_expression
	| constr_expression MODULO constr_expression
	| constr_expression LDIVIDE constr_expression
	| constr_expression ELTTIMES constr_expression
	| constr_expression ELTDIVIDE constr_expression
	| constr_expression HAT constr_expression
	| constr_expression ELTPOW constr_expression
	| BANG constr_expression %prec unary_over_binary
	| MINUS constr_expression %prec unary_over_binary
	| PLUS constr_expression %prec unary_over_binary
	| constr_expression TRANSPOSE
	| constr_expression LBRACK indexes RBRACK
	| identifier DOTNUMERAL
	| common_expression
	| identifier
	;

common_expression :
	INTNUMERAL
	| REALNUMERAL
	| DOTNUMERAL
	| IMAGNUMERAL
	| LBRACE separated_nonempty_list_COMMA_expression_ RBRACE
	| LPAREN lhs COMMA separated_nonempty_list_COMMA_expression_ RPAREN
	| LPAREN non_lhs COMMA separated_nonempty_list_COMMA_expression_ RPAREN
	| LBRACK loption_separated_nonempty_list_COMMA_expression__ RBRACK
	| identifier LPAREN loption_separated_nonempty_list_COMMA_expression__ RPAREN
	| TARGET LPAREN RPAREN
	| GETLP LPAREN RPAREN
	| identifier LPAREN lhs BAR loption_separated_nonempty_list_COMMA_expression__ RPAREN
	| identifier LPAREN non_lhs BAR loption_separated_nonempty_list_COMMA_expression__ RPAREN
	| common_expression DOTNUMERAL
	| LPAREN lhs RPAREN
	| LPAREN non_lhs RPAREN
	;

indexes :
	/*empty*/
	| COLON
	| lhs
	| non_lhs
	| lhs COLON
	| non_lhs COLON
	| COLON lhs
	| COLON non_lhs
	| lhs COLON lhs
	| lhs COLON non_lhs
	| non_lhs COLON lhs
	| non_lhs COLON non_lhs
	| indexes COMMA indexes
	;

printables :
	lhs
	| non_lhs
	| string_literal
	| printables COMMA printables
	;

statement :
	atomic_statement
	| nested_statement
	;

atomic_statement :
	lhs ASSIGN lhs SEMICOLON
	| lhs ASSIGN non_lhs SEMICOLON
	| lhs ARROWASSIGN lhs SEMICOLON
	| lhs ARROWASSIGN non_lhs SEMICOLON
	| lhs PLUSASSIGN lhs SEMICOLON
	| lhs PLUSASSIGN non_lhs SEMICOLON
	| lhs MINUSASSIGN lhs SEMICOLON
	| lhs MINUSASSIGN non_lhs SEMICOLON
	| lhs TIMESASSIGN lhs SEMICOLON
	| lhs TIMESASSIGN non_lhs SEMICOLON
	| lhs DIVIDEASSIGN lhs SEMICOLON
	| lhs DIVIDEASSIGN non_lhs SEMICOLON
	| lhs ELTTIMESASSIGN lhs SEMICOLON
	| lhs ELTTIMESASSIGN non_lhs SEMICOLON
	| lhs ELTDIVIDEASSIGN lhs SEMICOLON
	| lhs ELTDIVIDEASSIGN non_lhs SEMICOLON
	| identifier LPAREN loption_separated_nonempty_list_COMMA_expression__ RPAREN SEMICOLON
	| INCREMENTLOGPROB LPAREN lhs RPAREN SEMICOLON
	| INCREMENTLOGPROB LPAREN non_lhs RPAREN SEMICOLON
	| lhs TILDE identifier LPAREN loption_separated_nonempty_list_COMMA_expression__ RPAREN option_truncation_ SEMICOLON
	| non_lhs TILDE identifier LPAREN loption_separated_nonempty_list_COMMA_expression__ RPAREN option_truncation_ SEMICOLON
	| TARGET PLUSASSIGN lhs SEMICOLON
	| TARGET PLUSASSIGN non_lhs SEMICOLON
	| BREAK SEMICOLON
	| CONTINUE SEMICOLON
	| PRINT LPAREN printables RPAREN SEMICOLON
	| REJECT LPAREN printables RPAREN SEMICOLON
	| RETURN lhs SEMICOLON
	| RETURN non_lhs SEMICOLON
	| RETURN SEMICOLON
	| SEMICOLON
	;

string_literal :
	STRINGLITERAL
	;

truncation :
	TRUNCATE LBRACK option_expression_ COMMA option_expression_ RBRACK
	;

nested_statement :
	IF LPAREN lhs RPAREN vardecl_or_statement ELSE vardecl_or_statement
	| IF LPAREN non_lhs RPAREN vardecl_or_statement ELSE vardecl_or_statement
	| IF LPAREN lhs RPAREN vardecl_or_statement %prec below_ELSE
	| IF LPAREN non_lhs RPAREN vardecl_or_statement %prec below_ELSE
	| WHILE LPAREN lhs RPAREN vardecl_or_statement
	| WHILE LPAREN non_lhs RPAREN vardecl_or_statement
	| FOR LPAREN identifier IN lhs COLON lhs RPAREN vardecl_or_statement
	| FOR LPAREN identifier IN lhs COLON non_lhs RPAREN vardecl_or_statement
	| FOR LPAREN identifier IN non_lhs COLON lhs RPAREN vardecl_or_statement
	| FOR LPAREN identifier IN non_lhs COLON non_lhs RPAREN vardecl_or_statement
	| FOR LPAREN identifier IN lhs RPAREN vardecl_or_statement
	| FOR LPAREN identifier IN non_lhs RPAREN vardecl_or_statement
	| PROFILE LPAREN string_literal RPAREN LBRACE list_vardecl_or_statement_ RBRACE
	| LBRACE list_vardecl_or_statement_ RBRACE
	;

vardecl_or_statement :
	statement
	| var_decl
	;

top_vardecl_or_statement :
	statement
	| top_var_decl
	;

%%

/* Some auxiliary definition for variables and constants */
string_literal   \"(\\.|[^"\r\n\\])*\"

/* TODO: We should probably expand the alphabet */
identifier   [a-zA-Z][a-zA-Z0-9_]*

integer_constant    [0-9]+(_ [0-9]+)*

exp_literal   [eE][+-]?{integer_constant}
real_constant1   {integer_constant}"."{integer_constant}?{exp_literal}?
real_constant2   "."{integer_constant}{exp_literal}
real_constant3   {integer_constant}{exp_literal}
real_constant_dot   "."{integer_constant}
real_constant   {real_constant1}|{real_constant2}|{real_constant3}
imag_constant   ({integer_constant}|{real_constant}|{real_constant_dot})i
space     [ \t\f\v]
newline   \n\r?|\r\n?
non_space_or_newline    [^ \t\f\v\r\n]

%%

/* White space, line numbers and comments */
{newline}	skip()
{space}	skip()
"(*"(?s:.)*?"*)"	skip()
"//".*	skip()
"#include"({space}|{newline})+({string_literal}|"<"[^>\r\n]*">"|{non_space_or_newline}*)	skip()
/* deprecated */
"#".*	skip()

/* Program blocks */
"functions"	FUNCTIONBLOCK
"data"	DATABLOCK
"transformed"{space}+"data"	TRANSFORMEDDATABLOCK
"parameters"	PARAMETERSBLOCK
"transformed"{space}+"parameters"	TRANSFORMEDPARAMETERSBLOCK
"model"	MODELBLOCK
"generated"{space}+"quantities"	GENERATEDQUANTITIESBLOCK

/* Punctuation */
"{"	LBRACE
"}"	RBRACE
"("	LPAREN
")"	RPAREN
"["	LBRACK
"]"	RBRACK
"<"	LABRACK
">"	RABRACK
","	COMMA
";"	SEMICOLON
"|"	BAR

/* Control flow keywords */
"return"	RETURN
"if"	IF
"else"	ELSE
"while"	WHILE
"profile"	PROFILE
"for"	FOR
"in"	IN
"break"	BREAK
"continue"	CONTINUE

/* Types */
"void"	VOID
"int"	INT
"real"	REAL
"complex"	COMPLEX
"vector"	VECTOR
"row_vector"	ROWVECTOR
"complex_vector"	COMPLEXVECTOR
"complex_row_vector"	COMPLEXROWVECTOR
"tuple"	TUPLE
"array"	ARRAY
"matrix"	MATRIX
"complex_matrix"	COMPLEXMATRIX
"ordered"	ORDERED
"positive_ordered"	POSITIVEORDERED
"simplex"	SIMPLEX
"unit_vector"	UNITVECTOR
"cholesky_factor_corr"	CHOLESKYFACTORCORR
"cholesky_factor_cov"	CHOLESKYFACTORCOV
"corr_matrix"	CORRMATRIX
"cov_matrix"	COVMATRIX

/* Transformation keywords */
"lower"	LOWER
"upper"	UPPER
"offset"	OFFSET
"multiplier"	MULTIPLIER

/* Operators */
"?"	QMARK
":"	COLON
"!"	BANG
"-"	MINUS
"+"	PLUS
"^"	HAT
"'"	TRANSPOSE
"*"	TIMES
"/"	DIVIDE
"%"	MODULO
"%/%"	IDIVIDE
"\\"	LDIVIDE
".*"	ELTTIMES
".^"	ELTPOW
"./"	ELTDIVIDE
"||"	OR
"&&"	AND
"=="	EQUALS
"!="	NEQUALS
"<="	LEQ
">="	GEQ
"~"	TILDE

/* Assignments */
"="	ASSIGN
"+="	PLUSASSIGN
"-="	MINUSASSIGN
"*="	TIMESASSIGN
"/="	DIVIDEASSIGN
".*="	ELTTIMESASSIGN
"./="	ELTDIVIDEASSIGN
/* deprecated */
"<-"	ARROWASSIGN
/* deprecated */
"increment_log_prob"	INCREMENTLOGPROB

/* Effects */
"print"	PRINT
"reject"	REJECT
/* TODO: this is a hack; we should change to something like truncate and make it a reserved keyword */
"T"	TRUNCATE

/* Constants and identifiers */
{integer_constant}	INTNUMERAL
{real_constant}	REALNUMERAL
/* Separated out because ".1" could be a number or a tuple projection */
{real_constant_dot}	DOTNUMERAL
{imag_constant}	IMAGNUMERAL
/* NB: the stanc2 parser allows variables to be named target. I think it's a bad idea and have disallowed it. */
"target"	TARGET
/* deprecated */
"get_lp"	GETLP
{string_literal}	STRINGLITERAL
{identifier}	IDENTIFIER

/* End of file */
/*
  | eof
  | _
*/

___UNREACHABLE___	UNREACHABLE

%%
