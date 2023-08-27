//From: https://github.com/MiniZinc/libminizinc/blob/master/lib/parser.yxx

%token ILLEGAL_CHARACTER

%x string
%x string_quote
%x multilinecomment
%x doccomment
%x doccomment_file
%x quoted_exp

/*Tokens*/
%token MZN_INTEGER_LITERAL
%token MZN_BOOL_LITERAL
%token MZN_FLOAT_LITERAL
%token MZN_IDENTIFIER
%token MZN_QUOTED_IDENTIFIER
%token MZN_STRING_LITERAL
%token MZN_STRING_QUOTE_START
%token MZN_STRING_QUOTE_MID
%token MZN_STRING_QUOTE_END
%token MZN_TI_IDENTIFIER
%token MZN_TI_ENUM_IDENTIFIER
%token MZN_DOC_COMMENT
%token MZN_DOC_FILE_COMMENT
%token MZN_FIELD_TAIL
%token MZN_VAR
%token MZN_PAR
%token MZN_ABSENT
%token MZN_ANN
%token MZN_ANNOTATION
%token MZN_ANY
%token MZN_ARRAY
%token MZN_BOOL
//%token MZN_CASE
%token MZN_CONSTRAINT
%token MZN_DEFAULT
%token MZN_ELSE
%token MZN_ELSEIF
%token MZN_ENDIF
%token MZN_ENUM
%token MZN_FLOAT
%token MZN_FUNCTION
%token MZN_IF
%token MZN_INCLUDE
%token MZN_INFINITY
%token MZN_INT
%token MZN_LET
%token MZN_LIST
%token MZN_MAXIMIZE
%token MZN_MINIMIZE
%token MZN_OF
%token MZN_OPT
%token MZN_SATISFY
%token MZN_OUTPUT
%token MZN_PREDICATE
%token MZN_RECORD
%token MZN_SET
%token MZN_SOLVE
%token MZN_STRING
%token MZN_TEST
%token MZN_THEN
%token MZN_TUPLE
%token MZN_TYPE
%token MZN_UNDERSCORE
//%token MZN_VARIANT_RECORD
%token MZN_WHERE
%token MZN_LEFT_BRACKET
%token MZN_LEFT_2D_BRACKET
%token MZN_RIGHT_BRACKET
%token MZN_RIGHT_2D_BRACKET
//%token QUOTED_IDENTIFIER
//%token MZN_INVALID_INTEGER_LITERAL
//%token MZN_INVALID_FLOAT_LITERAL
//%token MZN_UNTERMINATED_STRING
//%token MZN_END_OF_LINE_IN_STRING
//%token MZN_INVALID_NULL
//%token MZN_INVALID_STRING_LITERAL
%token MZN_EQUIV
%token MZN_IMPL
%token MZN_RIMPL
%token MZN_OR
%token MZN_XOR
%token MZN_AND
%token MZN_LE
%token MZN_GR
%token MZN_LQ
%token MZN_GQ
%token MZN_EQ
%token MZN_NQ
%token MZN_WEAK_EQ
%token MZN_WEAK_NQ
%token MZN_IN
%token MZN_SUBSET
%token MZN_SUPERSET
%token MZN_UNION
%token MZN_DIFF
%token MZN_SYMDIFF
%token MZN_DOTDOT
%token MZN_DOTDOT_LE
%token MZN_LE_DOTDOT
%token MZN_LE_DOTDOT_LE
%token MZN_PLUS
%token MZN_MINUS
%token MZN_WEAK_PLUS
%token MZN_WEAK_MINUS
%token MZN_MULT
%token MZN_DIV
%token MZN_IDIV
%token MZN_MOD
%token MZN_WEAK_DIV
%token MZN_WEAK_IDIV
%token MZN_INTERSECT
%token MZN_WEAK_MULT
%token MZN_POW
%token MZN_POW_MINUS1
%token MZN_NOT
%token MZN_PLUSPLUS
%token MZN_COLONCOLON
%token PREC_ANNO
%token MZN_EQUIV_QUOTED
%token MZN_IMPL_QUOTED
%token MZN_RIMPL_QUOTED
%token MZN_OR_QUOTED
%token MZN_XOR_QUOTED
%token MZN_AND_QUOTED
%token MZN_LE_QUOTED
%token MZN_GR_QUOTED
%token MZN_LQ_QUOTED
%token MZN_GQ_QUOTED
%token MZN_EQ_QUOTED
%token MZN_NQ_QUOTED
%token MZN_IN_QUOTED
%token MZN_SUBSET_QUOTED
%token MZN_SUPERSET_QUOTED
%token MZN_UNION_QUOTED
%token MZN_DIFF_QUOTED
%token MZN_SYMDIFF_QUOTED
%token MZN_DOTDOT_QUOTED
%token MZN_LE_DOTDOT_QUOTED
%token MZN_DOTDOT_LE_QUOTED
%token MZN_LE_DOTDOT_LE_QUOTED
%token MZN_PLUS_QUOTED
%token MZN_MINUS_QUOTED
%token MZN_MULT_QUOTED
%token MZN_DIV_QUOTED
%token MZN_IDIV_QUOTED
%token MZN_MOD_QUOTED
%token MZN_INTERSECT_QUOTED
%token MZN_POW_QUOTED
%token MZN_NOT_QUOTED
//%token MZN_COLONCOLON_QUOTED
%token MZN_PLUSPLUS_QUOTED
%token ';'
%token '{'
%token '}'
%token '('
%token ')'
%token ','
%token ':'
%token '|'

%right /*1*/ PREC_ANNO
%left /*2*/ MZN_EQUIV
%left /*3*/ MZN_IMPL MZN_RIMPL
%left /*4*/ MZN_OR MZN_XOR
%left /*5*/ MZN_AND
%nonassoc /*6*/ MZN_LE MZN_GR MZN_LQ MZN_GQ MZN_EQ MZN_NQ MZN_WEAK_EQ MZN_WEAK_NQ
%nonassoc /*7*/ MZN_IN MZN_SUBSET MZN_SUPERSET
%left /*8*/ MZN_UNION MZN_DIFF MZN_SYMDIFF MZN_INTERSECT
%nonassoc /*9*/ MZN_DOTDOT MZN_DOTDOT_LE MZN_LE_DOTDOT MZN_LE_DOTDOT_LE
%left /*10*/ MZN_PLUS MZN_MINUS MZN_WEAK_PLUS MZN_WEAK_MINUS
%left /*11*/ MZN_MULT MZN_DIV MZN_IDIV MZN_MOD MZN_WEAK_DIV MZN_WEAK_IDIV MZN_WEAK_MULT
%left /*12*/ MZN_POW MZN_POW_MINUS1
%nonassoc /*13*/ MZN_NOT
%left /*14*/ MZN_PLUSPLUS
%left /*15*/ MZN_DEFAULT
%left /*16*/ MZN_QUOTED_IDENTIFIER
%left /*17*/ MZN_COLONCOLON

%start model

%%

model :
	item_list
	;

item_list :
	/*empty*/
	| item_list_head semi_or_none
	;

item_list_head :
	item
	| doc_file_comments item
	| item_list_head ';' item
	| item_list_head ';' doc_file_comments item
	| item error_item_start
	//| error ';' item
	;

doc_file_comments :
	MZN_DOC_FILE_COMMENT
	| doc_file_comments MZN_DOC_FILE_COMMENT
	;

semi_or_none :
	/*empty*/
	| ';'
	;

item :
	MZN_DOC_COMMENT item_tail
	| item_tail
	;

item_tail :
	include_item
	| vardecl_item
	| assign_item
	| constraint_item
	| solve_item
	| output_item
	| predicate_item
	| function_item
	| annotation_item
	;

error_item_start :
	MZN_INCLUDE
	| MZN_ENUM
	| MZN_OUTPUT
	| MZN_CONSTRAINT
	| MZN_SOLVE
	| MZN_PREDICATE
	| MZN_FUNCTION
	| MZN_TEST
	| MZN_ANNOTATION
	;

include_item :
	MZN_INCLUDE MZN_STRING_LITERAL
	;

vardecl_item :
	ti_expr_and_id
	| ti_expr_and_id MZN_EQ /*6N*/ expr
	| MZN_ENUM MZN_IDENTIFIER annotations
	| MZN_ENUM MZN_IDENTIFIER annotations MZN_EQ /*6N*/ enum_init
	| MZN_ENUM MZN_IDENTIFIER annotations MZN_EQ /*6N*/ MZN_LEFT_BRACKET string_lit_list MZN_RIGHT_BRACKET
	| MZN_TYPE MZN_IDENTIFIER annotations MZN_EQ /*6N*/ ti_expr
	;

enum_init :
	enum_construct
	| enum_init MZN_PLUSPLUS /*14L*/ enum_construct
	;

enum_construct :
	'{' enum_id_list comma_or_none '}'
	| MZN_IDENTIFIER '(' expr ')'
	| MZN_UNDERSCORE '(' expr ')'
	;

string_lit_list :
	/*empty*/
	| MZN_STRING_LITERAL
	| string_lit_list ',' MZN_STRING_LITERAL
	;

enum_id_list :
	/*empty*/
	| MZN_IDENTIFIER
	| enum_id_list ',' MZN_IDENTIFIER
	;

assign_item :
	MZN_IDENTIFIER MZN_EQ /*6N*/ expr
	;

constraint_item :
	MZN_CONSTRAINT expr
	| MZN_CONSTRAINT MZN_COLONCOLON /*17L*/ string_expr expr
	;

solve_item :
	MZN_SOLVE annotations MZN_SATISFY
	| MZN_SOLVE annotations MZN_MINIMIZE expr
	| MZN_SOLVE annotations MZN_MAXIMIZE expr
	;

output_item :
	MZN_OUTPUT expr
	| MZN_OUTPUT MZN_COLONCOLON /*17L*/ string_expr expr
	;

predicate_item :
	MZN_PREDICATE MZN_IDENTIFIER params ann_param annotations operation_item_tail
	| MZN_TEST MZN_IDENTIFIER params ann_param annotations operation_item_tail
	| MZN_PREDICATE MZN_IDENTIFIER MZN_POW_MINUS1 /*12L*/ params ann_param annotations operation_item_tail
	| MZN_TEST MZN_IDENTIFIER MZN_POW_MINUS1 /*12L*/ params ann_param annotations operation_item_tail
	;

function_item :
	MZN_FUNCTION ti_expr ':' id_or_quoted_op params ann_param annotations operation_item_tail
	| ti_expr ':' MZN_IDENTIFIER '(' params_list ')' ann_param annotations operation_item_tail
	;

annotation_item :
	MZN_ANNOTATION MZN_IDENTIFIER params
	| MZN_ANNOTATION MZN_IDENTIFIER params MZN_EQ /*6N*/ expr
	;

ann_param :
	/*empty*/
	| MZN_ANN ':' MZN_IDENTIFIER
	;

operation_item_tail :
	/*empty*/
	| MZN_EQ /*6N*/ expr
	;

params :
	/*empty*/
	| '(' params_list ')'
	//| '(' error ')'
	;

params_list :
	/*empty*/
	| params_list_head comma_or_none
	;

params_list_head :
	ti_expr_and_id_or_anon
	| params_list_head ',' ti_expr_and_id_or_anon
	;

comma_or_none :
	/*empty*/
	| ','
	;

pipe_or_none :
	/*empty*/
	| '|'
	;

ti_expr_and_id_or_anon :
	ti_expr_and_id
	| ti_expr
	;

ti_expr_and_id :
	ti_expr ':' MZN_IDENTIFIER annotations
	;

ti_expr_and_id_list :
	ti_expr_and_id_list_head comma_or_none
	;

ti_expr_and_id_list_head :
	ti_expr_and_id
	| ti_expr_and_id_list_head ',' ti_expr_and_id
	;

ti_expr_list :
	ti_expr_list_head comma_or_none
	;

ti_expr_list_head :
	ti_expr
	| ti_expr_list_head ',' ti_expr
	;

ti_expr :
	base_ti_expr
	| MZN_ARRAY MZN_LEFT_BRACKET ti_expr_list MZN_RIGHT_BRACKET MZN_OF base_ti_expr
	| MZN_LIST MZN_OF base_ti_expr
	| ti_expr MZN_PLUSPLUS /*14L*/ base_ti_expr
	;

base_ti_expr :
	base_ti_expr_tail
	| MZN_OPT base_ti_expr_tail
	| MZN_PAR opt_opt base_ti_expr_tail
	| MZN_VAR opt_opt base_ti_expr_tail
	| MZN_SET MZN_OF base_ti_expr_tail
	| MZN_OPT MZN_SET MZN_OF base_ti_expr_tail
	| MZN_PAR opt_opt MZN_SET MZN_OF base_ti_expr_tail
	| MZN_VAR opt_opt MZN_SET MZN_OF base_ti_expr_tail
	| MZN_ANY MZN_TI_IDENTIFIER
	| MZN_ANY
	;

opt_opt :
	/*empty*/
	| MZN_OPT
	;

base_ti_expr_tail :
	MZN_INT
	| MZN_BOOL
	| MZN_FLOAT
	| MZN_STRING
	| MZN_ANN
	| MZN_TUPLE '(' ti_expr_list ')'
	| MZN_RECORD '(' ti_expr_and_id_list ')'
	| set_expr
	| MZN_TI_IDENTIFIER
	| MZN_TI_ENUM_IDENTIFIER
	;

array_access_expr_list :
	array_access_expr_list_head comma_or_none
	;

array_access_expr_list_head :
	array_access_expr
	| array_access_expr_list_head ',' array_access_expr
	;

array_access_expr :
	expr
	| MZN_DOTDOT /*9N*/
	| MZN_DOTDOT_LE /*9N*/
	| MZN_LE_DOTDOT /*9N*/
	| MZN_LE_DOTDOT_LE /*9N*/
	;

expr_list :
	expr_list_head comma_or_none
	;

expr_list_head :
	expr
	| expr_list_head ',' expr
	;

set_expr :
	expr_atom_head
	| set_expr MZN_COLONCOLON /*17L*/ annotation_expr
	| set_expr MZN_UNION /*8L*/ set_expr
	| set_expr MZN_DIFF /*8L*/ set_expr
	| set_expr MZN_SYMDIFF /*8L*/ set_expr
	| set_expr MZN_DOTDOT /*9N*/ set_expr
	| set_expr MZN_DOTDOT_LE /*9N*/ set_expr
	| set_expr MZN_LE_DOTDOT /*9N*/ set_expr
	| set_expr MZN_LE_DOTDOT_LE /*9N*/ set_expr
	| set_expr MZN_DOTDOT /*9N*/
	| set_expr MZN_DOTDOT_LE /*9N*/
	| set_expr MZN_LE_DOTDOT /*9N*/
	| set_expr MZN_LE_DOTDOT_LE /*9N*/
	| MZN_DOTDOT /*9N*/ set_expr
	| MZN_DOTDOT_LE /*9N*/ set_expr
	| MZN_LE_DOTDOT /*9N*/ set_expr
	| MZN_LE_DOTDOT_LE /*9N*/ set_expr
	| MZN_DOTDOT_LE_QUOTED '(' set_expr ',' set_expr ')'
	| MZN_LE_DOTDOT_QUOTED '(' set_expr ',' set_expr ')'
	| MZN_LE_DOTDOT_LE_QUOTED '(' set_expr ',' set_expr ')'
	| MZN_DOTDOT_QUOTED '(' expr ',' expr ')'
	| MZN_DOTDOT_LE_QUOTED '(' set_expr ')'
	| MZN_LE_DOTDOT_QUOTED '(' set_expr ')'
	| MZN_LE_DOTDOT_LE_QUOTED '(' set_expr ')'
	| MZN_DOTDOT_QUOTED '(' expr ')'
	| set_expr MZN_INTERSECT /*8L*/ set_expr
	| set_expr MZN_PLUS /*10L*/ set_expr
	| set_expr MZN_MINUS /*10L*/ set_expr
	| set_expr MZN_MULT /*11L*/ set_expr
	| set_expr MZN_DIV /*11L*/ set_expr
	| set_expr MZN_IDIV /*11L*/ set_expr
	| set_expr MZN_MOD /*11L*/ set_expr
	| set_expr MZN_POW /*12L*/ set_expr
	| set_expr MZN_WEAK_PLUS /*10L*/ set_expr
	| set_expr MZN_WEAK_MINUS /*10L*/ set_expr
	| set_expr MZN_WEAK_MULT /*11L*/ set_expr
	| set_expr MZN_WEAK_DIV /*11L*/ set_expr
	| set_expr MZN_WEAK_IDIV /*11L*/ set_expr
	| set_expr MZN_WEAK_EQ /*6N*/ set_expr
	| set_expr MZN_WEAK_NQ /*6N*/ set_expr
	| set_expr MZN_DEFAULT /*15L*/ set_expr
	| set_expr MZN_QUOTED_IDENTIFIER /*16L*/ set_expr
	| MZN_PLUS /*10L*/ set_expr %prec MZN_NOT /*13N*/
	| MZN_MINUS /*10L*/ set_expr %prec MZN_NOT /*13N*/
	;

expr :
	expr_atom_head
	| expr MZN_COLONCOLON /*17L*/ annotation_expr
	| expr MZN_EQUIV /*2L*/ expr
	| expr MZN_IMPL /*3L*/ expr
	| expr MZN_RIMPL /*3L*/ expr
	| expr MZN_OR /*4L*/ expr
	| expr MZN_XOR /*4L*/ expr
	| expr MZN_AND /*5L*/ expr
	| expr MZN_LE /*6N*/ expr
	| expr MZN_GR /*6N*/ expr
	| expr MZN_LQ /*6N*/ expr
	| expr MZN_GQ /*6N*/ expr
	| expr MZN_EQ /*6N*/ expr
	| expr MZN_NQ /*6N*/ expr
	| expr MZN_IN /*7N*/ expr
	| expr MZN_SUBSET /*7N*/ expr
	| expr MZN_SUPERSET /*7N*/ expr
	| expr MZN_UNION /*8L*/ expr
	| expr MZN_DIFF /*8L*/ expr
	| expr MZN_SYMDIFF /*8L*/ expr
	| expr MZN_DOTDOT /*9N*/ expr
	| expr MZN_DOTDOT_LE /*9N*/ expr
	| expr MZN_LE_DOTDOT /*9N*/ expr
	| expr MZN_LE_DOTDOT_LE /*9N*/ expr
	| expr MZN_DOTDOT /*9N*/
	| expr MZN_DOTDOT_LE /*9N*/
	| expr MZN_LE_DOTDOT /*9N*/
	| expr MZN_LE_DOTDOT_LE /*9N*/
	| MZN_DOTDOT /*9N*/ expr
	| MZN_DOTDOT_LE /*9N*/ expr
	| MZN_LE_DOTDOT /*9N*/ expr
	| MZN_LE_DOTDOT_LE /*9N*/ expr
	| MZN_DOTDOT_LE_QUOTED '(' expr ',' expr ')'
	| MZN_LE_DOTDOT_QUOTED '(' expr ',' expr ')'
	| MZN_LE_DOTDOT_LE_QUOTED '(' expr ',' expr ')'
	| MZN_DOTDOT_QUOTED '(' expr ',' expr ')'
	| MZN_DOTDOT_LE_QUOTED '(' expr ')'
	| MZN_LE_DOTDOT_QUOTED '(' expr ')'
	| MZN_LE_DOTDOT_LE_QUOTED '(' expr ')'
	| MZN_DOTDOT_QUOTED '(' expr ')'
	| expr MZN_INTERSECT /*8L*/ expr
	| expr MZN_PLUSPLUS /*14L*/ expr
	| expr MZN_PLUS /*10L*/ expr
	| expr MZN_MINUS /*10L*/ expr
	| expr MZN_MULT /*11L*/ expr
	| expr MZN_DIV /*11L*/ expr
	| expr MZN_IDIV /*11L*/ expr
	| expr MZN_MOD /*11L*/ expr
	| expr MZN_POW /*12L*/ expr
	| expr MZN_WEAK_PLUS /*10L*/ expr
	| expr MZN_WEAK_MINUS /*10L*/ expr
	| expr MZN_WEAK_MULT /*11L*/ expr
	| expr MZN_WEAK_DIV /*11L*/ expr
	| expr MZN_WEAK_IDIV /*11L*/ expr
	| expr MZN_WEAK_EQ /*6N*/ expr
	| expr MZN_WEAK_NQ /*6N*/ expr
	| expr MZN_DEFAULT /*15L*/ expr
	| expr MZN_QUOTED_IDENTIFIER /*16L*/ expr
	| MZN_NOT /*13N*/ expr %prec MZN_NOT /*13N*/
	| MZN_PLUS /*10L*/ expr %prec MZN_NOT /*13N*/
	| MZN_MINUS /*10L*/ expr %prec MZN_NOT /*13N*/
	;

expr_atom_head :
	expr_atom_head_nonstring
	| string_expr
	;

expr_atom_head_nonstring :
	'(' expr ')'
	| '(' expr ')' access_tail
	| '(' expr ')' MZN_POW_MINUS1 /*12L*/
	| '(' expr ')' access_tail MZN_POW_MINUS1 /*12L*/
	| MZN_IDENTIFIER
	| MZN_IDENTIFIER access_tail
	| MZN_IDENTIFIER MZN_POW_MINUS1 /*12L*/
	| MZN_IDENTIFIER access_tail MZN_POW_MINUS1 /*12L*/
	| MZN_UNDERSCORE
	| MZN_UNDERSCORE access_tail
	| MZN_UNDERSCORE MZN_POW_MINUS1 /*12L*/
	| MZN_UNDERSCORE access_tail MZN_POW_MINUS1 /*12L*/
	| MZN_BOOL_LITERAL
	| MZN_BOOL_LITERAL MZN_POW_MINUS1 /*12L*/
	| MZN_INTEGER_LITERAL
	| MZN_INTEGER_LITERAL MZN_POW_MINUS1 /*12L*/
	| MZN_INFINITY
	| MZN_INFINITY MZN_POW_MINUS1 /*12L*/
	| MZN_FLOAT_LITERAL
	| MZN_FLOAT_LITERAL MZN_POW_MINUS1 /*12L*/
	| MZN_ABSENT
	| MZN_ABSENT MZN_POW_MINUS1 /*12L*/
	| set_literal
	| set_literal access_tail
	| set_literal MZN_POW_MINUS1 /*12L*/
	| set_literal access_tail MZN_POW_MINUS1 /*12L*/
	| set_comp
	| set_comp access_tail
	| set_comp MZN_POW_MINUS1 /*12L*/
	| set_comp access_tail MZN_POW_MINUS1 /*12L*/
	| simple_array_literal
	| simple_array_literal access_tail
	| simple_array_literal MZN_POW_MINUS1 /*12L*/
	| simple_array_literal access_tail MZN_POW_MINUS1 /*12L*/
	| simple_array_literal_2d
	| simple_array_literal_2d access_tail
	| simple_array_literal_2d MZN_POW_MINUS1 /*12L*/
	| simple_array_literal_2d access_tail MZN_POW_MINUS1 /*12L*/
	| simple_array_comp
	| simple_array_comp access_tail
	| simple_array_comp MZN_POW_MINUS1 /*12L*/
	| simple_array_comp access_tail MZN_POW_MINUS1 /*12L*/
	| if_then_else_expr
	| if_then_else_expr access_tail
	| if_then_else_expr MZN_POW_MINUS1 /*12L*/
	| if_then_else_expr access_tail MZN_POW_MINUS1 /*12L*/
	| let_expr
	| call_expr
	| call_expr access_tail
	| call_expr MZN_POW_MINUS1 /*12L*/
	| call_expr access_tail MZN_POW_MINUS1 /*12L*/
	| tuple_literal
	| tuple_literal access_tail
	| tuple_literal MZN_POW_MINUS1 /*12L*/
	| tuple_literal access_tail MZN_POW_MINUS1 /*12L*/
	| record_literal
	| record_literal access_tail
	| record_literal MZN_POW_MINUS1 /*12L*/
	| record_literal access_tail MZN_POW_MINUS1 /*12L*/
	;

string_expr :
	MZN_STRING_LITERAL
	| MZN_STRING_QUOTE_START string_quote_rest
	;

string_quote_rest :
	expr_list_head MZN_STRING_QUOTE_END
	| expr_list_head MZN_STRING_QUOTE_MID string_quote_rest
	;

access_tail :
	MZN_LEFT_BRACKET array_access_expr_list MZN_RIGHT_BRACKET
	| MZN_FIELD_TAIL
	| access_tail MZN_LEFT_BRACKET array_access_expr_list MZN_RIGHT_BRACKET
	| access_tail MZN_FIELD_TAIL
	;

set_literal :
	'{' '}'
	| '{' expr_list '}'
	;

tuple_literal :
	'(' expr ',' ')'
	| '(' expr ',' expr_list ')'
	;

record_literal :
	'(' record_field_list_head comma_or_none ')'
	;

record_field_list_head :
	record_field
	| record_field_list_head ',' record_field
	;

record_field :
	MZN_IDENTIFIER ':' expr
	;

set_comp :
	'{' expr '|' comp_tail '}'
	;

comp_tail :
	generator_list
	;

generator_list :
	generator_list_head comma_or_none
	;

generator_list_head :
	generator
	| generator_eq
	| generator_eq MZN_WHERE expr
	| generator_list_head ',' generator
	| generator_list_head ',' generator_eq
	| generator_list_head ',' generator_eq MZN_WHERE expr
	;

generator :
	id_list MZN_IN /*7N*/ expr
	| id_list MZN_IN /*7N*/ expr MZN_WHERE expr
	;

generator_eq :
	MZN_IDENTIFIER MZN_EQ /*6N*/ expr
	;

id_list :
	id_list_head comma_or_none
	;

id_list_head :
	MZN_IDENTIFIER
	| MZN_UNDERSCORE
	| id_list_head ',' MZN_IDENTIFIER
	| id_list_head ',' MZN_UNDERSCORE
	;

simple_array_literal :
	MZN_LEFT_BRACKET MZN_RIGHT_BRACKET
	| MZN_LEFT_BRACKET comp_expr_list MZN_RIGHT_BRACKET
	;

simple_array_literal_2d :
	MZN_LEFT_2D_BRACKET MZN_RIGHT_2D_BRACKET
	| MZN_LEFT_2D_BRACKET simple_array_literal_2d_indexed_list MZN_RIGHT_2D_BRACKET
	| MZN_LEFT_2D_BRACKET simple_array_literal_3d_list MZN_RIGHT_2D_BRACKET
	;

simple_array_literal_3d_list :
	'|' '|'
	| '|' simple_array_literal_2d_list '|'
	| simple_array_literal_3d_list ',' '|' simple_array_literal_2d_list '|'
	;

simple_array_literal_2d_list :
	expr_list
	| simple_array_literal_2d_list '|' expr_list
	;

simple_array_literal_2d_indexed_list :
	simple_array_literal_2d_indexed_list_head pipe_or_none
	;

simple_array_literal_2d_indexed_list_head :
	simple_array_literal_2d_indexed_list_row
	| simple_array_literal_2d_indexed_list_row_head ':'
	| simple_array_literal_2d_indexed_list_head '|' simple_array_literal_2d_indexed_list_row
	;

simple_array_literal_2d_indexed_list_row :
	simple_array_literal_2d_indexed_list_row_head comma_or_none
	;

simple_array_literal_2d_indexed_list_row_head :
	expr
	| simple_array_literal_2d_indexed_list_row_head ':' expr
	| simple_array_literal_2d_indexed_list_row_head ',' expr
	;

simple_array_comp :
	MZN_LEFT_BRACKET expr ':' expr '|' comp_tail MZN_RIGHT_BRACKET
	| MZN_LEFT_BRACKET expr '|' comp_tail MZN_RIGHT_BRACKET
	;

comp_expr_list :
	comp_expr_list_head comma_or_none
	;

comp_expr_list_head :
	expr
	| expr ':' expr
	| comp_expr_list_head ',' expr
	| comp_expr_list_head ',' expr ':' expr
	;

if_then_else_expr :
	MZN_IF expr MZN_THEN expr MZN_ENDIF
	| MZN_IF expr MZN_THEN expr elseif_list MZN_ELSE expr MZN_ENDIF
	;

elseif_list :
	/*empty*/
	| elseif_list MZN_ELSEIF expr MZN_THEN expr
	;

quoted_op :
	MZN_EQUIV_QUOTED
	| MZN_IMPL_QUOTED
	| MZN_RIMPL_QUOTED
	| MZN_OR_QUOTED
	| MZN_XOR_QUOTED
	| MZN_AND_QUOTED
	| MZN_LE_QUOTED
	| MZN_GR_QUOTED
	| MZN_LQ_QUOTED
	| MZN_GQ_QUOTED
	| MZN_EQ_QUOTED
	| MZN_NQ_QUOTED
	| MZN_IN_QUOTED
	| MZN_SUBSET_QUOTED
	| MZN_SUPERSET_QUOTED
	| MZN_UNION_QUOTED
	| MZN_DIFF_QUOTED
	| MZN_SYMDIFF_QUOTED
	| MZN_PLUS_QUOTED
	| MZN_MINUS_QUOTED
	| MZN_MULT_QUOTED
	| MZN_POW_QUOTED
	| MZN_DIV_QUOTED
	| MZN_IDIV_QUOTED
	| MZN_MOD_QUOTED
	| MZN_INTERSECT_QUOTED
	| MZN_PLUSPLUS_QUOTED
	| MZN_NOT_QUOTED
	;

quoted_op_call :
	quoted_op '(' expr ',' expr ')'
	| quoted_op '(' expr ')'
	;

call_expr :
	MZN_IDENTIFIER '(' ')'
	| MZN_IDENTIFIER MZN_POW_MINUS1 /*12L*/ '(' ')'
	| quoted_op_call
	| MZN_IDENTIFIER '(' comp_or_expr ')'
	| MZN_IDENTIFIER '(' comp_or_expr ')' '(' expr ')'
	| MZN_IDENTIFIER MZN_POW_MINUS1 /*12L*/ '(' comp_or_expr ')'
	| MZN_IDENTIFIER MZN_POW_MINUS1 /*12L*/ '(' comp_or_expr ')' '(' expr ')'
	;

comp_or_expr :
	comp_or_expr_head comma_or_none
	;

comp_or_expr_head :
	expr
	| expr MZN_WHERE expr
	| comp_or_expr_head ',' expr
	| comp_or_expr_head ',' expr MZN_WHERE expr
	;

let_expr :
	MZN_LET '{' '}' MZN_IN /*7N*/ expr %prec PREC_ANNO /*1R*/
	| MZN_LET '{' let_vardecl_item_list '}' MZN_IN /*7N*/ expr %prec PREC_ANNO /*1R*/
	| MZN_LET '{' let_vardecl_item_list comma_or_semi '}' MZN_IN /*7N*/ expr %prec PREC_ANNO /*1R*/
	;

let_vardecl_item_list :
	let_vardecl_item
	| constraint_item
	| let_vardecl_item_list comma_or_semi let_vardecl_item
	| let_vardecl_item_list comma_or_semi constraint_item
	;

comma_or_semi :
	','
	| ';'
	;

let_vardecl_item :
	ti_expr_and_id
	| ti_expr_and_id MZN_EQ /*6N*/ expr
	;

annotations :
	/*empty*/
	| ne_annotations
	;

annotation_expr :
	expr_atom_head_nonstring
	| MZN_OUTPUT
	| string_expr
	;

ne_annotations :
	MZN_COLONCOLON /*17L*/ annotation_expr
	| ne_annotations MZN_COLONCOLON /*17L*/ annotation_expr
	;

id_or_quoted_op :
	MZN_IDENTIFIER
	| MZN_IDENTIFIER MZN_POW_MINUS1 /*12L*/
	| MZN_EQUIV_QUOTED
	| MZN_IMPL_QUOTED
	| MZN_RIMPL_QUOTED
	| MZN_OR_QUOTED
	| MZN_XOR_QUOTED
	| MZN_AND_QUOTED
	| MZN_LE_QUOTED
	| MZN_GR_QUOTED
	| MZN_LQ_QUOTED
	| MZN_GQ_QUOTED
	| MZN_EQ_QUOTED
	| MZN_NQ_QUOTED
	| MZN_IN_QUOTED
	| MZN_SUBSET_QUOTED
	| MZN_SUPERSET_QUOTED
	| MZN_UNION_QUOTED
	| MZN_DIFF_QUOTED
	| MZN_SYMDIFF_QUOTED
	| MZN_DOTDOT_QUOTED
	| MZN_LE_DOTDOT_QUOTED
	| MZN_DOTDOT_LE_QUOTED
	| MZN_LE_DOTDOT_LE_QUOTED
	| MZN_PLUS_QUOTED
	| MZN_MINUS_QUOTED
	| MZN_MULT_QUOTED
	| MZN_POW_QUOTED
	| MZN_DIV_QUOTED
	| MZN_IDIV_QUOTED
	| MZN_MOD_QUOTED
	| MZN_INTERSECT_QUOTED
	| MZN_NOT_QUOTED
	| MZN_PLUSPLUS_QUOTED
	;

%%

%%

/*<*>\x0               MZN_INVALID_NULL*/

\xa               skip()
[ \f\xd\t]        skip() /* ignore whitespace */

<INITIAL>"/**"<>doccomment>
<doccomment> {
"*/"<<>             MZN_DOC_COMMENT
[^*\xa]+	skip()
"*"	skip()
\xa	skip()
}

<INITIAL>"/***"<>doccomment_file>
/*<doccomment_file>{*/
<doccomment_file>"*/"<<>              MZN_DOC_FILE_COMMENT
<doccomment_file>[^*\xa]+<.>
<doccomment_file>"*"<.>
<doccomment_file>\xa<.>
/*}*/

<INITIAL>"/*"<>multilinecomment>
<multilinecomment>{
"*/"<<>	skip()
[^*\xa]+        skip()
"*"             skip()
\xa             skip()
}


"["                MZN_LEFT_BRACKET
"[|"               MZN_LEFT_2D_BRACKET
"]"                MZN_RIGHT_BRACKET
"|]"               MZN_RIGHT_2D_BRACKET
%[^\xa]*          skip() /* ignore comments */

"true"             MZN_BOOL_LITERAL
"false"            MZN_BOOL_LITERAL

0[xX]([0-9a-fA-F]*\.[0-9a-fA-F]+|[0-9a-fA-F]+\.)([pP][+-]?[0-9]+)|(0[xX][0-9a-fA-F]+[pP][+-]?[0-9]+)   MZN_FLOAT_LITERAL

0[xX][0-9A-Fa-f]+   MZN_INTEGER_LITERAL
0o[0-7]+         MZN_INTEGER_LITERAL
[0-9]+           MZN_INTEGER_LITERAL

[0-9]+\.[0-9]+   MZN_FLOAT_LITERAL
[0-9]+\.[0-9]+[Ee][+-]?[0-9]+   MZN_FLOAT_LITERAL
[0-9]+[Ee][+-]?[0-9]+   MZN_FLOAT_LITERAL
/*[:;|{},\[\]]      { return *yytext; }*/
([ \f\xd\t]*\.[ \f\xd\t]*(([0-9]+)|(_?[A-Za-z][A-Za-z0-9_]*)|('[^\\'\xa\xd\x0]+')))+  MZN_FIELD_TAIL
\.\.               MZN_DOTDOT
"'\.\.'"           MZN_DOTDOT_QUOTED
"\.\.<"            MZN_DOTDOT_LE
"'\.\.<'"          MZN_DOTDOT_LE_QUOTED
"<\.\."            MZN_LE_DOTDOT
"'<\.\.'"          MZN_LE_DOTDOT_QUOTED
"<\.\.<"           MZN_LE_DOTDOT_LE
"'<\.\.<'"         MZN_LE_DOTDOT_LE_QUOTED
::                 MZN_COLONCOLON
_                  MZN_UNDERSCORE
"ann"              MZN_ANN
"annotation"       MZN_ANNOTATION
"any"              MZN_ANY
"array"            MZN_ARRAY
"bool"             MZN_BOOL
/*"case"             MZN_CASE*/
"constraint"       MZN_CONSTRAINT
"default"          MZN_DEFAULT
"div"              MZN_IDIV
"'div'"            MZN_IDIV_QUOTED
"diff"             MZN_DIFF
"'diff'"           MZN_DIFF_QUOTED
"else"             MZN_ELSE
"elseif"           MZN_ELSEIF
"endif"            MZN_ENDIF
"enum"             MZN_ENUM
"float"            MZN_FLOAT
"function"         MZN_FUNCTION
"if"               MZN_IF
"include"          MZN_INCLUDE
"infinity"         MZN_INFINITY
"intersect"        MZN_INTERSECT
"'intersect'"      MZN_INTERSECT_QUOTED
"in"               MZN_IN
"'in'"             MZN_IN_QUOTED
"int"              MZN_INT
"let"              MZN_LET
"list"             MZN_LIST
"maximize"         MZN_MAXIMIZE
"minimize"         MZN_MINIMIZE
"mod"              MZN_MOD
"'mod'"            MZN_MOD_QUOTED
"not"              MZN_NOT
"'not'"            MZN_NOT_QUOTED
"of"               MZN_OF
"output"           MZN_OUTPUT
"opt"              MZN_OPT
"par"              MZN_PAR
"predicate"        MZN_PREDICATE
"record"           MZN_RECORD
"satisfy"          MZN_SATISFY
"set"              MZN_SET
"solve"            MZN_SOLVE
"string"           MZN_STRING
"subset"           MZN_SUBSET
"'subset'"         MZN_SUBSET_QUOTED
"superset"         MZN_SUPERSET
"'superset'"       MZN_SUPERSET_QUOTED
"symdiff"          MZN_SYMDIFF
"'symdiff'"        MZN_SYMDIFF_QUOTED
"test"             MZN_TEST
"then"             MZN_THEN
"tuple"            MZN_TUPLE
"type"             MZN_TYPE
"union"            MZN_UNION
"'union'"          MZN_UNION_QUOTED
"var"              MZN_VAR
/*"variant_record"   MZN_VARIANT_RECORD*/
"where"            MZN_WHERE
"xor"              MZN_XOR
"'xor'"            MZN_XOR_QUOTED
"+"                MZN_PLUS
"'+'"              MZN_PLUS_QUOTED
"-"                MZN_MINUS
"'-'"              MZN_MINUS_QUOTED
"*"                MZN_MULT
"'*'"              MZN_MULT_QUOTED
"/"                MZN_DIV
"'/'"              MZN_DIV_QUOTED
"^-1"              MZN_POW_MINUS1
"^"                MZN_POW
"'^'"              MZN_POW_QUOTED
"++"               MZN_PLUSPLUS
"'++'"             MZN_PLUSPLUS_QUOTED
"<>"               MZN_ABSENT
"<"                MZN_LE
"'<'"              MZN_LE_QUOTED
"<="               MZN_LQ
"'<='"             MZN_LQ_QUOTED
">"                MZN_GR
"'>'"              MZN_GR_QUOTED
">="               MZN_GQ
"'>='"             MZN_GQ_QUOTED
"=="               MZN_EQ
"'=='"             MZN_EQ_QUOTED
"="                MZN_EQ
"'='"              MZN_EQ_QUOTED
"!="               MZN_NQ
"'!='"             MZN_NQ_QUOTED
"->"               MZN_IMPL
"'->'"             MZN_IMPL_QUOTED
"<-"               MZN_RIMPL
"'<-'"             MZN_RIMPL_QUOTED
"<->"              MZN_EQUIV
"'<->'"            MZN_EQUIV_QUOTED
"\\/"              MZN_OR
"'\\/'"            MZN_OR_QUOTED
"/\\"              MZN_AND
"'/\\'"            MZN_AND_QUOTED

"~+"               MZN_WEAK_PLUS
"~*"               MZN_WEAK_MULT
"~="               MZN_WEAK_EQ
"~!="              MZN_WEAK_NQ
"~-"               MZN_WEAK_MINUS
"~/"               MZN_WEAK_DIV
"~div"             MZN_WEAK_IDIV

"'~"[+*=/-]"'"     MZN_IDENTIFIER
";"	';'
"{"	'{'
"}"	'}'
","	','
":"	':'
"|"	'|'

"_objective"       MZN_IDENTIFIER

_?[A-Za-z][A-Za-z0-9_]*  MZN_IDENTIFIER
"'"[^\\'\xa\xd\x0]+"'"  MZN_IDENTIFIER /* isFlatZinc -> QUOTED_IDENTIFIER */

"\xE2\x88\x80"       MZN_IDENTIFIER /*forall*/
"\xE2\x88\x83"       MZN_IDENTIFIER /*exists*/
"\xE2\x88\x88"       MZN_IN
"\xE2\x8A\x86"       MZN_SUBSET
"\xE2\x8A\x87"       MZN_SUPERSET
"\xE2\x88\x9E"       MZN_INFINITY
"\xC2\xAC"           MZN_NOT
"\xE2\x86\x90"       MZN_RIMPL
"\xE2\x86\x92"       MZN_IMPL
"\xE2\x86\x94"       MZN_EQUIV
"\xE2\x88\xA7"       MZN_AND
"\xE2\x88\xA8"       MZN_OR
"\xE2\x89\xA0"       MZN_NQ
"\xE2\x89\xA4"       MZN_LQ
"\xE2\x89\xA5"       MZN_GQ
"\xE2\x88\xAA"       MZN_UNION
"\xE2\x88\xA9"       MZN_INTERSECT
"\xE2\x81\xBB\xC2\xB9"  MZN_POW_MINUS1

\$\$[A-Za-z][A-Za-z0-9_]*  MZN_TI_ENUM_IDENTIFIER

\$[A-Za-z][A-Za-z0-9_]*  MZN_TI_IDENTIFIER

"(" '('
")" ')'
<quoted_exp>")"<<> ')'

<INITIAL>\"<string>
<string,string_quote>[^\\"\xa\xd\x0]+<.>
<string,string_quote>\\n<.>
<string,string_quote>\\t<.>
<string,string_quote>\\x[0-9a-fA-F][0-9a-fA-F]?<.>  /*MZN_INVALID_STRING_LITERAL*/
<string,string_quote>\\[0-7][0-7]?[0-7]?<.>  /*MZN_INVALID_STRING_LITERAL*/

<string,string_quote>\\[\\"']<.>
<string>\\"("<>quoted_exp>       MZN_STRING_QUOTE_START
<string_quote>\\"("<>quoted_exp> MZN_STRING_QUOTE_MID
<string>\"<<>          MZN_STRING_LITERAL
<string_quote>\"<<>          MZN_STRING_QUOTE_END
<string,string_quote>.<.> /*{ return (unsigned char)yytext[0]; }*/
/*<string,string_quote>[\xa\xd\x0] { return MZN_END_OF_LINE_IN_STRING; }*/
/*<string,string_quote><<EOF>> { yy_pop_state(yyscanner); return MZN_UNTERMINATED_STRING; }*/

`[A-Za-z][A-Za-z0-9_]*`  MZN_QUOTED_IDENTIFIER

.                 ILLEGAL_CHARACTER

%%
