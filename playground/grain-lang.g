//From: https://github.com/grain-lang/grain/blob/fc19761e9f7e6c3d1cb54a308de721b17d25e12e/compiler/src/parsing/parser.mly

%token ABSTRACT
%token AND
%token ARROW
%token AS
%token ASSERT
%token AT
%token BIGINT
%token BREAK
%token BYTES
//%token CATCH
%token CHAR
%token COLON
//%token COLONCOLON
%token COMMA
%token CONTINUE
%token DASH
%token DOT
%token ELLIPSIS
%token ELSE
%token ENUM
//%token EOF
%token EOL
%token EQUAL
//%token EXCEPT
%token EXCEPTION
%token FAIL
%token FALSE
%token FLOAT32
%token FLOAT64
%token FOR
%token FOREIGN
%token FROM
%token FUN
%token GETS
%token IF
%token INCLUDE
//%token INFIX_10
%token INFIX_100
%token INFIX_110
//%token INFIX_120
%token INFIX_30
%token INFIX_40
//%token INFIX_50
%token INFIX_60
%token INFIX_70
%token INFIX_80
%token INFIX_90
%token INFIX_ASSIGNMENT_10
%token INT16
%token INT32
%token INT64
%token INT8
%token LBRACE
%token LBRACK
%token LBRACKRCARET
%token LCARET
%token LET
%token LIDENT
%token LPAREN
//%token MACRO
%token MATCH
%token MODULE
%token MUT
%token NUMBER_FLOAT
%token NUMBER_INT
%token PIPE
%token PREFIX_150
%token PRIMITIVE
%token PROVIDE
%token QUESTION
%token RATIONAL
%token RBRACE
%token RBRACK
%token RCARET
%token REC
%token RECORD
%token REM
%token RETURN
%token RPAREN
%token SEMI
%token SLASH
%token STAR
%token STRING
%token THICKARROW
%token THROW
%token TRUE
//%token TRY
%token TYPE
%token UIDENT
%token UINT16
%token UINT32
%token UINT64
%token UINT8
%token UNDERSCORE
%token USE
%token VOID
%token WASM
%token WASMF32
%token WASMF64
%token WASMI32
%token WASMI64
%token WHEN
%token WHILE
//%token YIELD

%nonassoc _below_infix
%left AS
%left INFIX_30
%left INFIX_40
%left PIPE //INFIX_50
%left INFIX_60
%left INFIX_70
%left INFIX_80
%left INFIX_90 LCARET RCARET
%left INFIX_100
%left DASH INFIX_110
%left SLASH STAR REM //INFIX_120
%right COLON COMMA DOT EOL EQUAL LPAREN SEMI
%nonassoc _if
%nonassoc ELSE

%start program

%%

eols :
	nonempty_list_eol_
	;

eos :
	eols
	| SEMI
	| SEMI eols
	;

lbrack :
	LBRACK %prec EOL
	| LBRACK eols %prec EOL
	;

lbrackrcaret :
	LBRACKRCARET %prec EOL
	| LBRACKRCARET eols %prec EOL
	;

rbrack :
	RBRACK
	| eols RBRACK
	;

lparen :
	LPAREN %prec EOL
	| LPAREN eols %prec EOL
	;

rparen :
	RPAREN
	| eols RPAREN
	;

lbrace :
	LBRACE %prec EOL
	| LBRACE eols %prec EOL
	;

rbrace :
	RBRACE
	| eols RBRACE
	;

lcaret :
	LCARET
	| LCARET eols
	;

rcaret :
	RCARET
	| eols RCARET
	;

comma :
	COMMA %prec EOL
	| COMMA eols %prec EOL
	;

arrow :
	ARROW
	| ARROW eols
	;

thickarrow :
	THICKARROW
	| THICKARROW eols
	;

either_arrow :
	arrow
	| thickarrow
	;

equal :
	EQUAL
	| EQUAL eols
	;

const :
	NUMBER_INT
	| NUMBER_FLOAT
	| INT8
	| INT16
	| INT32
	| INT64
	| UINT8
	| UINT16
	| UINT32
	| UINT64
	| FLOAT32
	| FLOAT64
	| WASMI32
	| WASMI64
	| WASMF32
	| WASMF64
	| BIGINT
	| RATIONAL
	| DASH NUMBER_INT
	| DASH NUMBER_FLOAT
	| DASH INT8
	| DASH INT16
	| DASH INT32
	| DASH INT64
	| DASH UINT8
	| DASH UINT16
	| DASH UINT32
	| DASH UINT64
	| DASH FLOAT32
	| DASH FLOAT64
	| DASH WASMI32
	| DASH WASMI64
	| DASH WASMF32
	| DASH WASMF64
	| DASH BIGINT
	| DASH RATIONAL
	| TRUE
	| FALSE
	| VOID
	| STRING
	| BYTES
	| CHAR
	;

expr :
	stmt_expr
	| non_stmt_expr %prec _below_infix
	;

non_binop_expr :
	lam_expr
	| non_assign_expr
	| assign_expr
	;

non_stmt_expr :
	binop_expr
	| annotated_expr
	;

annotated_expr :
	non_binop_expr %prec COLON
	| non_binop_expr COLON typ
	| non_binop_expr COLON eols typ
	;

binop_expr :
	non_stmt_expr INFIX_30 non_stmt_expr
	| non_stmt_expr INFIX_30 eols non_stmt_expr
	| non_stmt_expr INFIX_40 non_stmt_expr
	| non_stmt_expr INFIX_40 eols non_stmt_expr
	//| non_stmt_expr INFIX_50 non_stmt_expr
	//| non_stmt_expr INFIX_50 eols non_stmt_expr
	| non_stmt_expr INFIX_60 non_stmt_expr
	| non_stmt_expr INFIX_60 eols non_stmt_expr
	| non_stmt_expr INFIX_70 non_stmt_expr
	| non_stmt_expr INFIX_70 eols non_stmt_expr
	| non_stmt_expr INFIX_80 non_stmt_expr
	| non_stmt_expr INFIX_80 eols non_stmt_expr
	| non_stmt_expr INFIX_90 non_stmt_expr
	| non_stmt_expr INFIX_90 eols non_stmt_expr
	| non_stmt_expr INFIX_100 non_stmt_expr
	| non_stmt_expr INFIX_100 eols non_stmt_expr
	| non_stmt_expr INFIX_110 non_stmt_expr
	| non_stmt_expr INFIX_110 eols non_stmt_expr
	//| non_stmt_expr INFIX_120 non_stmt_expr
	//| non_stmt_expr INFIX_120 eols non_stmt_expr
	| non_stmt_expr STAR non_stmt_expr
	| non_stmt_expr STAR eols non_stmt_expr
	| non_stmt_expr REM non_stmt_expr
	| non_stmt_expr REM eols non_stmt_expr
	| non_stmt_expr SLASH non_stmt_expr
	| non_stmt_expr SLASH eols non_stmt_expr
	| non_stmt_expr DASH non_stmt_expr
	| non_stmt_expr DASH eols non_stmt_expr
	| non_stmt_expr PIPE non_stmt_expr
	| non_stmt_expr PIPE eols non_stmt_expr
	| non_stmt_expr LCARET non_stmt_expr
	| non_stmt_expr LCARET eols non_stmt_expr
	| non_stmt_expr RCARET non_stmt_expr
	| non_stmt_expr RCARET eols non_stmt_expr
	| non_stmt_expr rcaret_rcaret_op non_stmt_expr %prec INFIX_100
	| non_stmt_expr rcaret_rcaret_op eols non_stmt_expr %prec INFIX_100
	;

pattern :
	pattern COLON typ
	| pattern COLON eols typ
	| UNDERSCORE
	| const
	| NUMBER_INT SLASH option_DASH_ NUMBER_INT
	| DASH NUMBER_INT SLASH option_DASH_ NUMBER_INT
	| LIDENT
	| lparen special_op rparen
	| primitive_
	| lparen tuple_patterns rparen
	| lbrackrcaret patterns rbrack
	| lbrackrcaret rbrack
	| lparen pattern rparen
	| lbrace record_patterns rbrace
	| qualified_uid lparen patterns rparen
	| qualified_uid lbrace record_patterns rbrace
	| qualified_uid
	| lbrack rbrack
	| lbrack lseparated_nonempty_list_inner_comma_list_item_pat_ option_comma_ rbrack
	| pattern PIPE pattern %prec PIPE
	| pattern PIPE eols pattern %prec PIPE
	| pattern AS id_str
	| pattern AS eols id_str
	;

list_item_pat :
	ELLIPSIS pattern
	| pattern
	;

patterns :
	lseparated_nonempty_list_inner_comma_pattern_ option_comma_
	;

tuple_patterns :
	pattern COMMA lseparated_nonempty_list_inner_comma_pattern_
	| pattern COMMA lseparated_nonempty_list_inner_comma_pattern_ comma
	| pattern COMMA eols lseparated_nonempty_list_inner_comma_pattern_
	| pattern COMMA eols lseparated_nonempty_list_inner_comma_pattern_ comma
	;

record_patterns :
	lseparated_nonempty_list_inner_comma_record_pattern_ option_comma_
	;

record_pattern :
	UNDERSCORE
	| qualified_lid COLON pattern
	| qualified_lid COLON eols pattern
	| qualified_lid
	;

data_typ :
	qualified_uid lcaret typs rcaret
	| qualified_uid %prec _below_infix
	;

typ :
	FUN data_typ either_arrow typ
	| FUN LIDENT either_arrow typ
	| FUN lparen option_arg_typs_ rparen either_arrow typ
	| lparen tuple_typs rparen
	| lparen typ rparen
	| LIDENT
	| data_typ
	;

arg_typ :
	LIDENT COLON typ
	| LIDENT COLON eols typ
	| QUESTION LIDENT COLON typ
	| QUESTION LIDENT COLON eols typ
	| typ
	;

typs :
	lseparated_nonempty_list_inner_comma_typ_ option_comma_
	;

arg_typs :
	lseparated_nonempty_list_inner_comma_arg_typ_ option_comma_
	;

tuple_typs :
	typ COMMA lseparated_nonempty_list_inner_comma_typ_
	| typ COMMA lseparated_nonempty_list_inner_comma_typ_ comma
	| typ COMMA eols lseparated_nonempty_list_inner_comma_typ_
	| typ COMMA eols lseparated_nonempty_list_inner_comma_typ_ comma
	;

value_bind :
	pattern equal expr
	;

value_binds :
	lseparated_nonempty_list_inner_AND_value_bind_
	;

as_prefix_id_str_ :
	AS id_str
	| AS eols id_str
	;

as_prefix_lid_ :
	AS lid
	| AS eols lid
	;

as_prefix_uid_ :
	AS uid
	| AS eols uid
	;

aliasable_lid_ :
	lid option_as_prefix_lid__
	;

aliasable_uid_ :
	uid option_as_prefix_uid__
	;

use_item :
	TYPE aliasable_uid_
	| MODULE aliasable_uid_
	| EXCEPTION aliasable_uid_
	| aliasable_lid_
	;

use_items :
	lseparated_nonempty_list_inner_comma_use_item_ option_comma_
	;

use_shape :
	STAR
	| lbrace option_use_items_ rbrace
	;

use_stmt :
	USE lseparated_nonempty_list_inner_dot_type_id_str_ DOT use_shape
	| USE lseparated_nonempty_list_inner_dot_type_id_str_ DOT eols use_shape
	;

include_alias :
	AS qualified_uid
	| AS eols qualified_uid
	;

include_stmt :
	FROM file_path INCLUDE qualified_uid option_include_alias_
	;

data_declaration_stmt :
	ABSTRACT data_declaration
	| PROVIDE data_declaration
	| data_declaration
	;

data_declaration_stmts :
	separated_nonempty_list_AND_data_declaration_stmt_
	;

provide_item :
	TYPE aliasable_uid_
	| MODULE aliasable_uid_
	| EXCEPTION aliasable_uid_
	| aliasable_lid_
	;

provide_items :
	lseparated_nonempty_list_inner_comma_provide_item_ option_comma_
	;

provide_shape :
	lbrace option_provide_items_ rbrace
	;

provide_stmt :
	attributes PROVIDE LET REC value_binds
	| attributes PROVIDE LET value_binds
	| attributes PROVIDE LET REC MUT value_binds
	| attributes PROVIDE LET MUT value_binds
	| attributes PROVIDE foreign_stmt
	| attributes PROVIDE primitive_stmt
	| attributes PROVIDE exception_stmt
	| attributes PROVIDE provide_shape
	| attributes PROVIDE module_stmt
	;

data_constructor :
	UIDENT
	| UIDENT data_tuple_body
	| UIDENT data_record_body
	;

data_constructors :
	lbrace lseparated_nonempty_list_inner_comma_data_constructor_ option_comma_ rbrace
	;

data_label :
	lid COLON typ
	| lid COLON eols typ
	| MUT lid COLON typ
	| MUT lid COLON eols typ
	;

data_tuple_body :
	lparen typs rparen
	;

data_record_body :
	lbrace lseparated_nonempty_list_inner_comma_data_label_ option_comma_ rbrace
	;

id_typ :
	LIDENT
	;

id_vec :
	lcaret lseparated_nonempty_list_inner_comma_id_typ_ option_comma_ rcaret
	;

rec_flag :
	REC
	;

data_declaration :
	TYPE option_rec_flag_ UIDENT option_id_vec_ equal typ
	| ENUM option_rec_flag_ UIDENT option_id_vec_ data_constructors
	| RECORD option_rec_flag_ UIDENT option_id_vec_ data_record_body
	;

unop_expr :
	PREFIX_150 non_assign_expr
	;

paren_expr :
	lparen expr rparen
	;

app_arg :
	expr
	| id_str EQUAL expr
	;

app_expr :
	left_accessor_expr lparen option_comma_ rparen
	| left_accessor_expr lparen lseparated_nonempty_list_inner_comma_app_arg_ option_comma_ rparen
	;

rcaret_rcaret_op :
	lnonempty_list_inner_RCARET_ RCARET
	;

construct_expr :
	qualified_uid lparen option_comma_ rparen
	| qualified_uid lparen lseparated_nonempty_list_inner_comma_expr_ option_comma_ rparen
	| qualified_uid lbrace lseparated_nonempty_list_inner_comma_record_field_ option_comma_ rbrace
	| qualified_uid %prec LPAREN
	;

primitive_ :
	ASSERT
	| THROW
	| FAIL
	;

special_op :
	INFIX_30
	| INFIX_40
	//| INFIX_50
	| INFIX_60
	| INFIX_70
	| INFIX_80
	| INFIX_90
	| INFIX_100
	| INFIX_110
	//| INFIX_120
	| STAR
	| REM
	| SLASH
	| DASH
	| PIPE
	| LCARET
	| RCARET
	| rcaret_rcaret_op
	| PREFIX_150
	;

qualified_lid :
	lseparated_nonempty_list_inner_dot_type_id_str_ DOT id_str
	| lseparated_nonempty_list_inner_dot_type_id_str_ DOT eols id_str
	| id_str %prec EQUAL
	;

qualified_uid :
	lseparated_nonempty_list_inner_dot_type_id_str_ %prec DOT
	;

lid :
	id_str
	;

uid :
	UIDENT
	;

id_expr :
	qualified_lid %prec COLON
	;

simple_expr :
	const
	| lparen tuple_exprs rparen
	| id_expr
	;

braced_expr :
	lbrace block_body rbrace
	| lbrace record_exprs rbrace
	;

arg_default :
	EQUAL non_stmt_expr
	;

lam_arg :
	pattern option_arg_default_
	;

lam_args :
	lseparated_nonempty_list_inner_comma_lam_arg_ option_comma_
	;

lam_expr :
	FUN lparen option_lam_args_ rparen thickarrow expr
	| FUN LIDENT thickarrow expr
	;

attribute_argument :
	STRING
	;

attribute_arguments :
	lparen rparen
	| lparen lseparated_nonempty_list_inner_comma_attribute_argument_ rparen
	;

attribute :
	AT id_str loption_attribute_arguments_
	;

attributes :
	list_terminated_attribute_opt_eols__
	;

let_expr :
	attributes LET REC value_binds
	| attributes LET value_binds
	| attributes LET REC MUT value_binds
	| attributes LET MUT value_binds
	;

if_expr :
	IF lparen expr rparen expr %prec _if
	| IF lparen expr rparen expr ELSE expr %prec _if
	| IF lparen expr rparen expr ELSE eols expr %prec _if
	| IF lparen expr rparen eols expr %prec _if
	| IF lparen expr rparen eols expr ELSE expr %prec _if
	| IF lparen expr rparen eols expr ELSE eols expr %prec _if
	;

while_expr :
	WHILE lparen expr rparen expr
	| WHILE lparen expr rparen eols expr
	;

for_inner_expr :
	/*empty*/%prec EOL
	| expr
	;

for_expr :
	FOR lparen option_block_body_expr_ SEMI for_inner_expr SEMI for_inner_expr rparen expr
	| FOR lparen option_block_body_expr_ SEMI for_inner_expr SEMI for_inner_expr rparen eols expr
	| FOR lparen option_block_body_expr_ SEMI for_inner_expr SEMI eols for_inner_expr rparen expr
	| FOR lparen option_block_body_expr_ SEMI for_inner_expr SEMI eols for_inner_expr rparen eols expr
	| FOR lparen option_block_body_expr_ SEMI for_inner_expr eols SEMI for_inner_expr rparen expr
	| FOR lparen option_block_body_expr_ SEMI for_inner_expr eols SEMI for_inner_expr rparen eols expr
	| FOR lparen option_block_body_expr_ SEMI for_inner_expr eols SEMI eols for_inner_expr rparen expr
	| FOR lparen option_block_body_expr_ SEMI for_inner_expr eols SEMI eols for_inner_expr rparen eols expr
	| FOR lparen option_block_body_expr_ SEMI eols for_inner_expr SEMI for_inner_expr rparen expr
	| FOR lparen option_block_body_expr_ SEMI eols for_inner_expr SEMI for_inner_expr rparen eols expr
	| FOR lparen option_block_body_expr_ SEMI eols for_inner_expr SEMI eols for_inner_expr rparen expr
	| FOR lparen option_block_body_expr_ SEMI eols for_inner_expr SEMI eols for_inner_expr rparen eols expr
	| FOR lparen option_block_body_expr_ SEMI eols for_inner_expr eols SEMI for_inner_expr rparen expr
	| FOR lparen option_block_body_expr_ SEMI eols for_inner_expr eols SEMI for_inner_expr rparen eols expr
	| FOR lparen option_block_body_expr_ SEMI eols for_inner_expr eols SEMI eols for_inner_expr rparen expr
	| FOR lparen option_block_body_expr_ SEMI eols for_inner_expr eols SEMI eols for_inner_expr rparen eols expr
	| FOR lparen option_block_body_expr_ eols SEMI for_inner_expr SEMI for_inner_expr rparen expr
	| FOR lparen option_block_body_expr_ eols SEMI for_inner_expr SEMI for_inner_expr rparen eols expr
	| FOR lparen option_block_body_expr_ eols SEMI for_inner_expr SEMI eols for_inner_expr rparen expr
	| FOR lparen option_block_body_expr_ eols SEMI for_inner_expr SEMI eols for_inner_expr rparen eols expr
	| FOR lparen option_block_body_expr_ eols SEMI for_inner_expr eols SEMI for_inner_expr rparen expr
	| FOR lparen option_block_body_expr_ eols SEMI for_inner_expr eols SEMI for_inner_expr rparen eols expr
	| FOR lparen option_block_body_expr_ eols SEMI for_inner_expr eols SEMI eols for_inner_expr rparen expr
	| FOR lparen option_block_body_expr_ eols SEMI for_inner_expr eols SEMI eols for_inner_expr rparen eols expr
	| FOR lparen option_block_body_expr_ eols SEMI eols for_inner_expr SEMI for_inner_expr rparen expr
	| FOR lparen option_block_body_expr_ eols SEMI eols for_inner_expr SEMI for_inner_expr rparen eols expr
	| FOR lparen option_block_body_expr_ eols SEMI eols for_inner_expr SEMI eols for_inner_expr rparen expr
	| FOR lparen option_block_body_expr_ eols SEMI eols for_inner_expr SEMI eols for_inner_expr rparen eols expr
	| FOR lparen option_block_body_expr_ eols SEMI eols for_inner_expr eols SEMI for_inner_expr rparen expr
	| FOR lparen option_block_body_expr_ eols SEMI eols for_inner_expr eols SEMI for_inner_expr rparen eols expr
	| FOR lparen option_block_body_expr_ eols SEMI eols for_inner_expr eols SEMI eols for_inner_expr rparen expr
	| FOR lparen option_block_body_expr_ eols SEMI eols for_inner_expr eols SEMI eols for_inner_expr rparen eols expr
	;

when_guard :
	WHEN expr
	| eols WHEN expr
	;

match_branch :
	pattern thickarrow expr
	| pattern when_guard thickarrow expr
	;

match_branches :
	lseparated_nonempty_list_inner_comma_match_branch_ option_comma_
	;

match_expr :
	MATCH lparen expr rparen lbrace match_branches rbrace
	;

list_item :
	ELLIPSIS expr
	| expr
	;

list_expr :
	lbrack rbrack
	| lbrack lseparated_nonempty_list_inner_comma_list_item_ option_comma_ rbrack
	;

array_expr :
	lbrackrcaret rbrack
	| lbrackrcaret lseparated_nonempty_list_inner_comma_expr_ option_comma_ rbrack
	| lbrackrcaret eols lseparated_nonempty_list_inner_comma_expr_ option_comma_ rbrack
	;

stmt_expr :
	THROW expr
	| ASSERT expr
	| FAIL expr
	| RETURN %prec _below_infix
	| RETURN expr %prec _below_infix
	| CONTINUE
	| BREAK
	| use_stmt
	;

assign_binop_op :
	INFIX_ASSIGNMENT_10
	;

assign_expr :
	left_accessor_expr GETS expr
	| left_accessor_expr GETS eols expr
	| id_expr equal expr
	| id_expr assign_binop_op expr
	| id_expr assign_binop_op eols expr
	| record_set
	| array_set
	;

non_assign_expr :
	left_accessor_expr
	| unop_expr
	| if_expr
	| while_expr
	| for_expr
	| match_expr
	;

left_accessor_expr :
	app_expr
	| construct_expr
	| simple_expr
	| array_get
	| record_get
	| paren_expr
	| braced_expr
	| list_expr
	| array_expr
	;

block_body_expr :
	let_expr
	| expr
	;

tuple_exprs :
	expr COMMA lseparated_nonempty_list_inner_comma_expr_ option_comma_
	| expr COMMA eols lseparated_nonempty_list_inner_comma_expr_ option_comma_
	;

array_get :
	left_accessor_expr lbrack expr rbrack
	;

array_set :
	left_accessor_expr lbrack expr rbrack equal expr
	| left_accessor_expr lbrack expr rbrack assign_binop_op expr
	;

record_get :
	left_accessor_expr DOT lid
	| left_accessor_expr DOT eols lid
	;

record_set :
	left_accessor_expr DOT lid equal expr
	| left_accessor_expr DOT eols lid equal expr
	| left_accessor_expr DOT lid assign_binop_op expr
	| left_accessor_expr DOT lid assign_binop_op eols expr
	| left_accessor_expr DOT eols lid assign_binop_op expr
	| left_accessor_expr DOT eols lid assign_binop_op eols expr
	;

punned_record_field :
	qualified_lid
	;

non_punned_record_field :
	qualified_lid COLON expr
	| qualified_lid COLON eols expr
	;

spread_record_field :
	ELLIPSIS expr
	;

record_exprs :
	non_punned_record_field option_comma_
	| punned_record_field comma
	| punned_record_field comma lseparated_nonempty_list_inner_comma_record_field_ option_comma_
	| non_punned_record_field comma lseparated_nonempty_list_inner_comma_record_field_ option_comma_
	| spread_record_field comma lseparated_nonempty_list_inner_comma_record_field_ option_comma_
	;

block_body :
	lseparated_nonempty_list_inner_eos_block_body_expr_ %prec SEMI
	| lseparated_nonempty_list_inner_eos_block_body_expr_ eos %prec SEMI
	;

file_path :
	STRING
	;

id_str :
	LIDENT
	| lparen special_op rparen
	;

type_id_str :
	UIDENT
	;

foreign_stmt :
	FOREIGN WASM id_str COLON typ option_as_prefix_id_str__ FROM file_path
	| FOREIGN WASM id_str COLON eols typ option_as_prefix_id_str__ FROM file_path
	;

prim :
	primitive_
	;

primitive_stmt :
	PRIMITIVE id_str equal STRING
	| PRIMITIVE prim equal STRING
	;

exception_stmt :
	EXCEPTION type_id_str
	| EXCEPTION type_id_str lparen option_typs_ rparen
	| EXCEPTION type_id_str data_record_body
	;

module_stmt :
	MODULE UIDENT lbrace toplevel_stmts RBRACE
	;

toplevel_stmt :
	attributes LET REC value_binds
	| attributes LET value_binds
	| attributes LET REC MUT value_binds
	| attributes LET MUT value_binds
	| attributes data_declaration_stmts
	| attributes foreign_stmt
	| attributes include_stmt
	| attributes module_stmt
	| attributes primitive_stmt
	| expr
	| provide_stmt
	| exception_stmt
	;

toplevel_stmts :
	lseparated_nonempty_list_inner_eos_toplevel_stmt_ option_eos_
	;

module_header :
	MODULE UIDENT
	;

program :
	attributes module_header eos toplevel_stmts //EOF
	| eols attributes module_header eos toplevel_stmts //EOF
	| attributes module_header option_eos_ //EOF
	| eols attributes module_header option_eos_ //EOF
	;

option_DASH_ :
	/*empty*/
	| DASH
	;

option_arg_default_ :
	/*empty*/
	| arg_default
	;

option_arg_typs_ :
	/*empty*/
	| arg_typs
	;

option_as_prefix_id_str__ :
	/*empty*/
	| as_prefix_id_str_
	;

option_as_prefix_lid__ :
	/*empty*/
	| as_prefix_lid_
	;

option_as_prefix_uid__ :
	/*empty*/
	| as_prefix_uid_
	;

option_block_body_expr_ :
	/*empty*/
	| block_body_expr
	;

option_comma_ :
	/*empty*/
	| comma
	;

option_eos_ :
	/*empty*/
	| eos
	;

option_id_vec_ :
	/*empty*/
	| id_vec
	;

option_include_alias_ :
	/*empty*/
	| include_alias
	;

option_lam_args_ :
	/*empty*/
	| lam_args
	;

option_provide_items_ :
	/*empty*/
	| provide_items
	;

option_rec_flag_ :
	/*empty*/
	| rec_flag
	;

option_typs_ :
	/*empty*/
	| typs
	;

option_use_items_ :
	/*empty*/
	| use_items
	;

loption_attribute_arguments_ :
	/*empty*/
	| attribute_arguments
	;

list_terminated_attribute_opt_eols__ :
	/*empty*/
	| attribute list_terminated_attribute_opt_eols__
	| attribute eols list_terminated_attribute_opt_eols__
	;

nonempty_list_eol_ :
	EOL
	| EOL nonempty_list_eol_
	;

separated_nonempty_list_AND_data_declaration_stmt_ :
	data_declaration_stmt
	| data_declaration_stmt AND separated_nonempty_list_AND_data_declaration_stmt_
	;

lnonempty_list_inner_RCARET_ :
	lnonempty_list_inner_RCARET_ RCARET
	| RCARET
	;

lseparated_nonempty_list_inner_AND_value_bind_ :
	lseparated_nonempty_list_inner_AND_value_bind_ AND value_bind
	| value_bind
	;

lseparated_nonempty_list_inner_comma_app_arg_ :
	lseparated_nonempty_list_inner_comma_app_arg_ comma app_arg
	| app_arg
	;

lseparated_nonempty_list_inner_comma_arg_typ_ :
	lseparated_nonempty_list_inner_comma_arg_typ_ comma arg_typ
	| arg_typ
	;

lseparated_nonempty_list_inner_comma_attribute_argument_ :
	lseparated_nonempty_list_inner_comma_attribute_argument_ comma attribute_argument
	| attribute_argument
	;

lseparated_nonempty_list_inner_comma_data_constructor_ :
	lseparated_nonempty_list_inner_comma_data_constructor_ comma data_constructor
	| data_constructor
	;

lseparated_nonempty_list_inner_comma_data_label_ :
	lseparated_nonempty_list_inner_comma_data_label_ comma data_label
	| data_label
	;

lseparated_nonempty_list_inner_comma_expr_ :
	lseparated_nonempty_list_inner_comma_expr_ comma expr
	| expr
	;

lseparated_nonempty_list_inner_comma_id_typ_ :
	lseparated_nonempty_list_inner_comma_id_typ_ comma id_typ
	| id_typ
	;

lseparated_nonempty_list_inner_comma_lam_arg_ :
	lseparated_nonempty_list_inner_comma_lam_arg_ comma lam_arg
	| lam_arg
	;

lseparated_nonempty_list_inner_comma_list_item_ :
	lseparated_nonempty_list_inner_comma_list_item_ comma list_item
	| list_item
	;

lseparated_nonempty_list_inner_comma_list_item_pat_ :
	lseparated_nonempty_list_inner_comma_list_item_pat_ comma list_item_pat
	| list_item_pat
	;

lseparated_nonempty_list_inner_comma_match_branch_ :
	lseparated_nonempty_list_inner_comma_match_branch_ comma match_branch
	| match_branch
	;

lseparated_nonempty_list_inner_comma_pattern_ :
	lseparated_nonempty_list_inner_comma_pattern_ comma pattern
	| pattern
	;

lseparated_nonempty_list_inner_comma_provide_item_ :
	lseparated_nonempty_list_inner_comma_provide_item_ comma provide_item
	| provide_item
	;

lseparated_nonempty_list_inner_comma_record_field_ :
	lseparated_nonempty_list_inner_comma_record_field_ comma punned_record_field
	| lseparated_nonempty_list_inner_comma_record_field_ comma non_punned_record_field
	| lseparated_nonempty_list_inner_comma_record_field_ comma spread_record_field
	| punned_record_field
	| non_punned_record_field
	| spread_record_field
	;

lseparated_nonempty_list_inner_comma_record_pattern_ :
	lseparated_nonempty_list_inner_comma_record_pattern_ comma record_pattern
	| record_pattern
	;

lseparated_nonempty_list_inner_comma_typ_ :
	lseparated_nonempty_list_inner_comma_typ_ comma typ
	| typ
	;

lseparated_nonempty_list_inner_comma_use_item_ :
	lseparated_nonempty_list_inner_comma_use_item_ comma use_item
	| use_item
	;

lseparated_nonempty_list_inner_dot_type_id_str_ :
	lseparated_nonempty_list_inner_dot_type_id_str_ DOT type_id_str
	| lseparated_nonempty_list_inner_dot_type_id_str_ DOT eols type_id_str
	| type_id_str
	;

lseparated_nonempty_list_inner_eos_block_body_expr_ :
	lseparated_nonempty_list_inner_eos_block_body_expr_ eos block_body_expr
	| block_body_expr
	;

lseparated_nonempty_list_inner_eos_toplevel_stmt_ :
	lseparated_nonempty_list_inner_eos_toplevel_stmt_ eos toplevel_stmt
	| toplevel_stmt
	;

%%

%%

[ \t\r]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"abstract"	ABSTRACT
"and"	AND
"->"	ARROW
"as"	AS
"assert"	ASSERT
"@"	AT
"bigint"	BIGINT
"break"	BREAK
"BYTES"	BYTES
"char"	CHAR
":"	COLON
","	COMMA
"continue"	CONTINUE
"-"	DASH
"."	DOT
"..."	ELLIPSIS
"else"	ELSE
"enum"	ENUM
//EOF	EOF
"\n"	EOL
"="	EQUAL
"exception"	EXCEPTION
"fail"	FAIL
"false"	FALSE
"float32"	FLOAT32
"float64"	FLOAT64
"for"	FOR
"foreign"	FOREIGN
"from"	FROM
"fun"	FUN
":="	GETS
"if"	IF
"include"	INCLUDE
"<<"|">>"	INFIX_100
"+"|"-"	INFIX_110
//"*"|"%"|"/"	INFIX_120
"!"	PREFIX_150
"||"|"??"	INFIX_30
"&&"	INFIX_40
//"|"	INFIX_50
"^"	INFIX_60
"&"	INFIX_70
("=="|"!=")|"is"|"isnt"	INFIX_80
"<<"|">>"|">>>"	INFIX_90
"+="|"-="|"*="|"/="|"%="	INFIX_ASSIGNMENT_10
"int16"	INT16
"int32"	INT32
"int64"	INT64
"int8"	INT8
"{"	LBRACE
"["	LBRACK
"[>"	LBRACKRCARET
"<"	LCARET
"let"	LET
"("	LPAREN
"match"	MATCH
"module"	MODULE
"mut"	MUT
"|"	PIPE
"primitive"	PRIMITIVE
"provide"	PROVIDE
"?"	QUESTION
"rational"	RATIONAL
"}"	RBRACE
"]"	RBRACK
">"	RCARET
"rec"	REC
"record"	RECORD
"return"	RETURN
")"	RPAREN
";"	SEMI
"/"	SLASH
"*"	STAR
"%"	REM
"=>"	THICKARROW
"throw"	THROW
"true"	TRUE
"type"	TYPE
"uint16"	UINT16
"uint32"	UINT32
"uint64"	UINT64
"uint8"	UINT8
"_"	UNDERSCORE
"use"	USE
"void"	VOID
"wasm"	WASM
"wasmf32"	WASMF32
"wasmf64"	WASMF64
"wasmi32"	WASMI32
"wasmi64"	WASMI64
"when"	WHEN
"while"	WHILE

[0-9]+"."[0-9]+	NUMBER_FLOAT
[0-9]+[n]?	NUMBER_INT
"0x"[0-9A-Fa-f]+[n]?	NUMBER_INT
\"(\\.|[^"\r\n\\])*\"	STRING
'(\\.|[^'\r\n\\])*'	STRING

[A-Z_][A-Za-z0-9_]*	UIDENT
[a-z_][A-Za-z0-9_]*	LIDENT

%%
