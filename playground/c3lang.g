//From: https://github.com/c3lang/c3c/blob/master/resources/grammar/grammar.y

%x COMMENT RAW_STRING

/*Tokens*/
%token IDENT
%token HASH_IDENT
%token CT_IDENT
%token CONST_IDENT
%token TYPE_IDENT
%token CT_TYPE_IDENT
%token AT_TYPE_IDENT
%token AT_IDENT
%token CT_INCLUDE
%token STRING_LITERAL
%token INTEGER
%token INC_OP
%token DEC_OP
%token SHL_OP
%token SHR_OP
%token LE_OP
%token GE_OP
%token EQ_OP
%token NE_OP
%token AND_OP
%token OR_OP
%token MUL_ASSIGN
%token DIV_ASSIGN
%token MOD_ASSIGN
%token ADD_ASSIGN
%token LGENPAR
%token RGENPAR
%token SUB_ASSIGN
%token SHL_ASSIGN
%token SHR_ASSIGN
%token AND_ASSIGN
%token XOR_ASSIGN
%token OR_ASSIGN
%token VAR
%token NUL
%token ELVIS
%token NEXTCASE
%token ANYFAULT
%token MODULE
%token IMPORT
%token DEF
%token EXTERN
%token CHAR
%token SHORT
%token INT
%token LONG
%token FLOAT
%token DOUBLE
%token CONST
%token VOID
%token USZ
%token ISZ
%token UPTR
%token IPTR
%token ANY
%token ICHAR
%token USHORT
%token UINT
%token ULONG
%token BOOL
%token INT128
%token UINT128
%token FLOAT16
%token FLOAT128
%token BFLOAT16
%token TYPEID
%token BITSTRUCT
%token STATIC
%token BANGBANG
//%token AT_CONST_IDENT
//%token HASH_TYPE_IDENT
%token STRUCT
%token UNION
%token ENUM
%token ELLIPSIS
%token DOTDOT
%token BYTES
%token CT_ERROR
%token CASE
%token DEFAULT
%token IF
%token ELSE
%token SWITCH
%token WHILE
%token DO
%token FOR
%token CONTINUE
%token BREAK
%token RETURN
%token FOREACH_R
%token FOREACH
%token FN
%token FAULT
%token MACRO
%token CT_IF
%token CT_ENDIF
%token CT_ELSE
%token CT_SWITCH
%token CT_CASE
%token CT_DEFAULT
%token CT_FOR
%token CT_FOREACH
%token CT_ENDFOREACH
%token CT_ENDFOR
%token CT_ENDSWITCH
%token BUILTIN
%token IMPLIES
%token INITIALIZE
%token FINALIZE
%token CT_ECHO
%token CT_ASSERT
%token CT_EVALTYPE
%token CT_VATYPE
%token TRY
%token CATCH
%token SCOPE
%token DEFER
%token LVEC
%token RVEC
%token OPTELSE
%token CT_TYPEFROM
%token CT_TYPEOF
%token TLOCAL
%token CT_VASPLAT
%token INLINE
%token DISTINCT
%token CT_VACONST
%token CT_NAMEOF
%token CT_VAREF
%token CT_VACOUNT
%token CT_VAARG
%token CT_SIZEOF
%token CT_STRINGIFY
%token CT_QNAMEOF
%token CT_OFFSETOF
%token CT_VAEXPR
%token CT_FEATURE
%token CT_EXTNAMEOF
%token CT_EVAL
%token CT_DEFINED
%token CT_CHECKS
%token CT_ALIGNOF
%token ASSERT
%token ASM
%token CHAR_LITERAL
%token REAL
%token TRUE
%token FALSE
%token CT_CONST_IDENT
%token LBRAPIPE
%token RBRAPIPE
//%token HASH_CONST_IDENT
%token '.'
%token '('
%token ')'
%token '^'
%token ':'
%token '['
%token ']'
%token '!'
%token '&'
%token '*'
%token '+'
%token '-'
%token '~'
%token '/'
%token '%'
%token '|'
%token '<'
%token '>'
%token '?'
%token '='
%token ','
%token ';'
%token '{'
%token '}'


%start translation_unit

%%

path :
	IDENT SCOPE
	| path IDENT SCOPE
	;

path_const :
	path CONST_IDENT
	| CONST_IDENT
	;

path_ident :
	path IDENT
	| IDENT
	;

path_at_ident :
	path AT_IDENT
	| AT_IDENT
	;

ident_expr :
	CONST_IDENT
	| IDENT
	| AT_IDENT
	;

local_ident_expr :
	CT_IDENT
	| HASH_IDENT
	;

ct_call :
	CT_ALIGNOF
	| CT_DEFINED
	| CT_EXTNAMEOF
	| CT_NAMEOF
	| CT_OFFSETOF
	| CT_QNAMEOF
	;

ct_analyse :
	CT_EVAL
	| CT_SIZEOF
	| CT_STRINGIFY
	;

ct_arg :
	CT_VACONST
	| CT_VAARG
	| CT_VAREF
	| CT_VAEXPR
	;

flat_path :
	primary_expr param_path
	| type
	| primary_expr
	;

maybe_optional_type :
	optional_type
	| empty
	;

string_expr :
	STRING_LITERAL
	| string_expr STRING_LITERAL
	;

bytes_expr :
	BYTES
	| bytes_expr BYTES
	;

expr_block :
	LBRAPIPE opt_stmt_list RBRAPIPE
	;

base_expr :
	string_expr
	| INTEGER
	| bytes_expr
	| NUL
	| BUILTIN CONST_IDENT
	| BUILTIN IDENT
	| CHAR_LITERAL
	| REAL
	| TRUE
	| FALSE
	| path ident_expr
	| ident_expr
	| local_ident_expr
	| type initializer_list
	| type '.' access_ident
	| type '.' CONST_IDENT
	| '(' expr ')'
	| expr_block
	| ct_call '(' flat_path ')'
	| ct_arg '(' expr ')'
	| ct_analyse '(' expr ')'
	| CT_VACOUNT
	| CT_FEATURE '(' CONST_IDENT ')'
	| CT_CHECKS '(' expression_list ')'
	| lambda_decl compound_statement
	;

primary_expr :
	base_expr
	| initializer_list
	;

range_loc :
	expr
	| '^' expr
	;

range_expr :
	range_loc DOTDOT range_loc
	| range_loc DOTDOT
	| DOTDOT range_loc
	| range_loc ':' range_loc
	| ':' range_loc
	| range_loc ':'
	| DOTDOT
	;

call_inline_attributes :
	AT_IDENT
	| call_inline_attributes AT_IDENT
	;

call_invocation :
	'(' call_arg_list ')'
	| '(' call_arg_list ')' call_inline_attributes
	;

access_ident :
	IDENT
	| AT_IDENT
	| HASH_IDENT
	| CT_EVAL '(' expr ')'
	| TYPEID
	;

call_trailing :
	'[' range_loc ']'
	| '[' range_expr ']'
	| call_invocation
	| call_invocation compound_statement
	| '.' access_ident
	| generic_expr
	| INC_OP
	| DEC_OP
	| '!'
	| BANGBANG
	;

call_stmt_expr :
	base_expr
	| call_stmt_expr call_trailing
	;

call_expr :
	primary_expr
	| call_expr call_trailing
	;

unary_expr :
	call_expr
	| unary_op unary_expr
	;

unary_stmt_expr :
	call_stmt_expr
	| unary_op unary_expr
	;

unary_op :
	'&'
	| AND_OP
	| '*'
	| '+'
	| '-'
	| '~'
	| '!'
	| INC_OP
	| DEC_OP
	| '(' type ')'
	;

mult_op :
	'*'
	| '/'
	| '%'
	;

mult_expr :
	unary_expr
	| mult_expr mult_op unary_expr
	;

mult_stmt_expr :
	unary_stmt_expr
	| mult_stmt_expr mult_op unary_expr
	;

shift_op :
	SHL_OP
	| SHR_OP
	;

shift_expr :
	mult_expr
	| shift_expr shift_op mult_expr
	;

shift_stmt_expr :
	mult_stmt_expr
	| shift_stmt_expr shift_op mult_expr
	;

bit_op :
	'&'
	| '^'
	| '|'
	;

bit_expr :
	shift_expr
	| bit_expr bit_op shift_expr
	;

bit_stmt_expr :
	shift_stmt_expr
	| bit_stmt_expr bit_op shift_expr
	;

additive_op :
	'+'
	| '-'
	;

additive_expr :
	bit_expr
	| additive_expr additive_op bit_expr
	;

additive_stmt_expr :
	bit_stmt_expr
	| additive_stmt_expr additive_op bit_expr
	;

relational_op :
	'<'
	| '>'
	| LE_OP
	| GE_OP
	| EQ_OP
	| NE_OP
	;

relational_expr :
	additive_expr
	| relational_expr relational_op additive_expr
	;

relational_stmt_expr :
	additive_stmt_expr
	| relational_stmt_expr relational_op additive_expr
	;

rel_or_lambda_expr :
	relational_expr
	| lambda_decl IMPLIES relational_expr
	;

and_expr :
	relational_expr
	| and_expr AND_OP relational_expr
	;

and_stmt_expr :
	relational_stmt_expr
	| and_stmt_expr AND_OP relational_expr
	;

or_expr :
	and_expr
	| or_expr OR_OP and_expr
	;

or_stmt_expr :
	and_stmt_expr
	| or_stmt_expr OR_OP and_expr
	;

suffix_expr :
	or_expr
	| or_expr '?'
	| or_expr '?' '!'
	;

suffix_stmt_expr :
	or_stmt_expr
	| or_stmt_expr '?'
	| or_stmt_expr '?' '!'
	;

ternary_expr :
	suffix_expr
	| or_expr '?' expr ':' ternary_expr
	| suffix_expr ELVIS ternary_expr
	| suffix_expr OPTELSE ternary_expr
	| lambda_decl implies_body
	;

ternary_stmt_expr :
	suffix_stmt_expr
	| or_stmt_expr '?' expr ':' ternary_expr
	| suffix_stmt_expr ELVIS ternary_expr
	| suffix_stmt_expr OPTELSE ternary_expr
	| lambda_decl implies_body
	;

assignment_op :
	'='
	| ADD_ASSIGN
	| SUB_ASSIGN
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| SHL_ASSIGN
	| SHR_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

empty :
	/*empty*/
	;

assignment_expr :
	ternary_expr
	| CT_TYPE_IDENT '=' type
	| unary_expr assignment_op assignment_expr
	;

assignment_stmt_expr :
	ternary_stmt_expr
	| CT_TYPE_IDENT '=' type
	| unary_stmt_expr assignment_op assignment_expr
	;

implies_body :
	IMPLIES expr
	;

lambda_decl :
	FN maybe_optional_type fn_parameter_list opt_attributes
	;

expr_no_list :
	assignment_stmt_expr
	;

expr :
	assignment_expr
	;

constant_expr :
	ternary_expr
	;

param_path_element :
	'[' expr ']'
	| '[' expr DOTDOT expr ']'
	| '.' primary_expr
	;

param_path :
	param_path_element
	| param_path param_path_element
	;

arg :
	param_path '=' expr
	| type
	| param_path '=' type
	| expr
	| CT_VASPLAT '(' range_expr ')'
	| CT_VASPLAT '(' ')'
	| ELLIPSIS expr
	;

arg_list :
	arg
	| arg_list ',' arg
	;

call_arg_list :
	arg_list
	| arg_list ';'
	| arg_list ';' parameters
	| ';'
	| ';' parameters
	| empty
	;

opt_arg_list_trailing :
	arg_list
	| arg_list ','
	| empty
	;

enum_constants :
	enum_constant
	| enum_constants ',' enum_constant
	;

enum_list :
	enum_constants
	| enum_constants ','
	;

enum_constant :
	CONST_IDENT opt_attributes
	| CONST_IDENT '(' arg_list ')' opt_attributes
	| CONST_IDENT '(' arg_list ',' ')' opt_attributes
	;

identifier_list :
	IDENT
	| identifier_list ',' IDENT
	;

enum_param_decl :
	type
	| type IDENT
	| type IDENT '=' expr
	;

base_type :
	VOID
	| BOOL
	| CHAR
	| ICHAR
	| SHORT
	| USHORT
	| INT
	| UINT
	| LONG
	| ULONG
	| INT128
	| UINT128
	| FLOAT
	| DOUBLE
	| FLOAT16
	| BFLOAT16
	| FLOAT128
	| IPTR
	| UPTR
	| ISZ
	| USZ
	| ANYFAULT
	| ANY
	| TYPEID
	| TYPE_IDENT
	| path TYPE_IDENT
	| CT_TYPE_IDENT
	| CT_TYPEOF '(' expr ')'
	| CT_TYPEFROM '(' constant_expr ')'
	| CT_VATYPE '(' constant_expr ')'
	| CT_EVALTYPE '(' constant_expr ')'
	;

type :
	base_type
	| type '*'
	| type '[' constant_expr ']'
	| type '[' ']'
	| type '[' '*' ']'
	| type LVEC constant_expr RVEC
	| type LVEC '*' RVEC
	;

optional_type :
	type
	| type '!'
	;

local_decl_after_type :
	CT_IDENT
	| CT_IDENT '=' constant_expr
	| IDENT opt_attributes
	| IDENT opt_attributes '=' expr
	;

local_decl_storage :
	STATIC
	| TLOCAL
	;

decl_or_expr :
	var_decl
	| optional_type local_decl_after_type
	| expr
	;

var_decl :
	VAR IDENT '=' expr
	| VAR CT_IDENT '=' expr
	| VAR CT_IDENT
	| VAR CT_TYPE_IDENT '=' type
	| VAR CT_TYPE_IDENT
	;

initializer_list :
	'{' opt_arg_list_trailing '}'
	;

ct_case_stmt :
	CT_CASE constant_expr ':' opt_stmt_list
	| CT_CASE type ':' opt_stmt_list
	| CT_DEFAULT ':' opt_stmt_list
	;

ct_switch_body :
	ct_case_stmt
	| ct_switch_body ct_case_stmt
	;

ct_for_stmt :
	CT_FOR '(' for_cond ')' opt_stmt_list CT_ENDFOR
	;

ct_foreach_stmt :
	CT_FOREACH '(' CT_IDENT ':' expr ')' opt_stmt_list CT_ENDFOREACH
	| CT_FOREACH '(' CT_IDENT ',' CT_IDENT ':' expr ')' opt_stmt_list CT_ENDFOREACH
	;

ct_switch :
	CT_SWITCH '(' constant_expr ')'
	| CT_SWITCH '(' type ')'
	| CT_SWITCH
	;

ct_switch_stmt :
	ct_switch ct_switch_body CT_ENDSWITCH
	;

var_stmt :
	var_decl ';'
	;

decl_stmt_after_type :
	local_decl_after_type
	| decl_stmt_after_type ',' local_decl_after_type
	;

declaration_stmt :
	const_declaration
	| local_decl_storage optional_type decl_stmt_after_type ';'
	| optional_type decl_stmt_after_type ';'
	;

return_stmt :
	RETURN expr ';'
	| RETURN ';'
	;

catch_unwrap_list :
	relational_expr
	| catch_unwrap_list ',' relational_expr
	;

catch_unwrap :
	CATCH catch_unwrap_list
	| CATCH IDENT '=' catch_unwrap_list
	| CATCH type IDENT '=' catch_unwrap_list
	;

try_unwrap :
	TRY rel_or_lambda_expr
	| TRY IDENT '=' rel_or_lambda_expr
	| TRY type IDENT '=' rel_or_lambda_expr
	;

try_unwrap_chain :
	try_unwrap
	| try_unwrap_chain AND_OP try_unwrap
	| try_unwrap_chain AND_OP rel_or_lambda_expr
	;

default_stmt :
	DEFAULT ':' opt_stmt_list
	;

case_stmt :
	CASE expr ':' opt_stmt_list
	| CASE expr DOTDOT expr ':' opt_stmt_list
	| CASE type ':' opt_stmt_list
	;

switch_body :
	case_stmt
	| default_stmt
	| switch_body case_stmt
	| switch_body default_stmt
	;

cond_repeat :
	decl_or_expr
	| cond_repeat ',' decl_or_expr
	;

cond :
	try_unwrap_chain
	| catch_unwrap
	| cond_repeat
	| cond_repeat ',' try_unwrap_chain
	| cond_repeat ',' catch_unwrap
	;

else_part :
	ELSE if_stmt
	| ELSE compound_statement
	;

if_stmt :
	IF optional_label paren_cond '{' switch_body '}'
	| IF optional_label paren_cond '{' switch_body '}' else_part
	| IF optional_label paren_cond statement
	| IF optional_label paren_cond compound_statement else_part
	;

expr_list_eos :
	expression_list ';'
	| ';'
	;

cond_eos :
	cond ';'
	| ';'
	;

for_cond :
	expr_list_eos cond_eos expression_list
	| expr_list_eos cond_eos
	;

for_stmt :
	FOR optional_label '(' for_cond ')' statement
	;

paren_cond :
	'(' cond ')'
	;

while_stmt :
	WHILE optional_label paren_cond statement
	;

do_stmt :
	DO optional_label compound_statement WHILE '(' expr ')' ';'
	| DO optional_label compound_statement ';'
	;

optional_label_target :
	CONST_IDENT
	| empty
	;

continue_stmt :
	CONTINUE optional_label_target ';'
	;

break_stmt :
	BREAK optional_label_target ';'
	;

nextcase_stmt :
	NEXTCASE CONST_IDENT ':' expr ';'
	| NEXTCASE expr ';'
	| NEXTCASE CONST_IDENT ':' type ';'
	| NEXTCASE type ';'
	| NEXTCASE CONST_IDENT ':' DEFAULT ';'
	| NEXTCASE DEFAULT ';'
	| NEXTCASE ';'
	;

foreach_var :
	optional_type '&' IDENT
	| optional_type IDENT
	| '&' IDENT
	| IDENT
	;

foreach_vars :
	foreach_var
	| foreach_var ',' foreach_var
	;

foreach_stmt :
	FOREACH optional_label '(' foreach_vars ':' expr ')'
	;

statement :
	FOREACH_R optional_label '(' foreach_vars ':' expr ')' statement
	;

defer_stmt :
	DEFER statement
	| DEFER TRY statement
	| DEFER CATCH statement
	;

ct_if_stmt :
	CT_IF constant_expr ':' opt_stmt_list CT_ENDIF
	| CT_IF constant_expr ':' opt_stmt_list CT_ELSE opt_stmt_list CT_ENDIF
	;

assert_expr_list :
	expr
	| expr ',' assert_expr_list
	;

assert_stmt :
	ASSERT '(' expr ')' ';'
	| ASSERT '(' expr ',' assert_expr_list ')' ';'
	;

asm_stmts :
	asm_stmt
	| asm_stmts asm_stmt
	;

asm_instr :
	INT
	| IDENT
	| INT '.' IDENT
	| IDENT '.' IDENT
	;

asm_addr :
	asm_expr
	| asm_expr additive_op asm_expr
	| asm_expr additive_op asm_expr '*' INTEGER
	| asm_expr additive_op asm_expr '*' INTEGER additive_op INTEGER
	| asm_expr additive_op asm_expr shift_op INTEGER
	| asm_expr additive_op asm_expr additive_op INTEGER
	;

asm_expr :
	CT_IDENT
	| CT_CONST_IDENT
	| IDENT
	| '&' IDENT
	| CONST_IDENT
	| REAL
	| INTEGER
	| '(' expr ')'
	| '[' asm_addr ']'
	;

asm_exprs :
	asm_expr
	| asm_exprs ',' asm_expr
	;

asm_stmt :
	asm_instr asm_exprs ';'
	| asm_instr ';'
	;

asm_block_stmt :
	ASM '(' constant_expr ')'
	| ASM '{' asm_stmts '}'
	| ASM '{' '}'
	;

statement :
	compound_statement
	| var_stmt
	| declaration_stmt
	| return_stmt
	| if_stmt
	| while_stmt
	| defer_stmt
	| switch_stmt
	| do_stmt
	| for_stmt
	| foreach_stmt
	| continue_stmt
	| break_stmt
	| nextcase_stmt
	| asm_block_stmt
	| ct_echo_stmt
	| ct_assert_stmt
	| ct_if_stmt
	| ct_switch_stmt
	| ct_foreach_stmt
	| ct_for_stmt
	| expr_no_list ';'
	| assert_stmt
	| ';'
	;

compound_statement :
	'{' opt_stmt_list '}'
	;

statement_list :
	statement
	| statement_list statement
	;

opt_stmt_list :
	statement_list
	| empty
	;

switch_stmt :
	SWITCH optional_label '{' switch_body '}'
	| SWITCH optional_label '{' '}'
	| SWITCH optional_label paren_cond '{' switch_body '}'
	| SWITCH optional_label paren_cond '{' '}'
	;

expression_list :
	decl_or_expr
	| expression_list ',' decl_or_expr
	;

optional_label :
	CONST_IDENT ':'
	| empty
	;

ct_assert_stmt :
	CT_ASSERT constant_expr ':' constant_expr ';'
	| CT_ASSERT constant_expr ';'
	| CT_ERROR constant_expr ';'
	;

ct_include_stmt :
	CT_INCLUDE string_expr ';'
	;

ct_echo_stmt :
	CT_ECHO constant_expr ';'
	;

bitstruct_declaration :
	BITSTRUCT TYPE_IDENT ':' type opt_attributes bitstruct_body
	;

bitstruct_body :
	'{' '}'
	| '{' bitstruct_defs '}'
	| '{' bitstruct_simple_defs '}'
	;

bitstruct_defs :
	bitstruct_def
	| bitstruct_defs bitstruct_def
	;

bitstruct_simple_defs :
	base_type IDENT ';'
	| bitstruct_simple_defs base_type IDENT ';'
	;

bitstruct_def :
	base_type IDENT ':' constant_expr DOTDOT constant_expr ';'
	| base_type IDENT ':' constant_expr ';'
	;

static_declaration :
	STATIC INITIALIZE opt_attributes compound_statement
	| STATIC FINALIZE opt_attributes compound_statement
	;

attribute_name :
	AT_IDENT
	| AT_TYPE_IDENT
	| path AT_TYPE_IDENT
	;

attribute_operator_expr :
	'&' '[' ']'
	| '[' ']' '='
	| '[' ']'
	;

attr_param :
	attribute_operator_expr
	| constant_expr
	;

attribute_param_list :
	attr_param
	| attribute_param_list ',' attr_param
	;

attribute :
	attribute_name
	| attribute_name '(' attribute_param_list ')'
	;

attribute_list :
	attribute
	| attribute_list attribute
	;

opt_attributes :
	attribute_list
	| empty
	;

trailing_block_param :
	AT_IDENT
	| AT_IDENT '(' ')'
	| AT_IDENT '(' parameters ')'
	;

macro_params :
	parameters
	| parameters ';' trailing_block_param
	| ';' trailing_block_param
	| empty
	;

macro_func_body :
	implies_body ';'
	| compound_statement
	;

macro_declaration :
	MACRO macro_header '(' macro_params ')' opt_attributes macro_func_body
	;

struct_or_union :
	STRUCT
	| UNION
	;

struct_declaration :
	struct_or_union TYPE_IDENT opt_attributes struct_body
	;

struct_body :
	'{' struct_declaration_list '}'
	;

struct_declaration_list :
	struct_member_decl
	| struct_declaration_list struct_member_decl
	;

enum_params :
	enum_param_decl
	| enum_params ',' enum_param_decl
	;

enum_param_list :
	'(' enum_params ')'
	| '(' ')'
	| empty
	;

struct_member_decl :
	type identifier_list opt_attributes ';'
	| struct_or_union IDENT opt_attributes struct_body
	| struct_or_union opt_attributes struct_body
	| BITSTRUCT ':' type opt_attributes bitstruct_body
	| BITSTRUCT IDENT ':' type opt_attributes bitstruct_body
	| INLINE type IDENT opt_attributes ';'
	| INLINE type opt_attributes ';'
	;

enum_spec :
	':' type enum_param_list
	| empty
	;

enum_declaration :
	ENUM TYPE_IDENT enum_spec opt_attributes '{' enum_list '}'
	;

faults :
	CONST_IDENT
	| faults ',' CONST_IDENT
	;

fault_declaration :
	FAULT TYPE_IDENT opt_attributes '{' faults '}'
	| FAULT TYPE_IDENT opt_attributes '{' faults ',' '}'
	;

func_macro_name :
	IDENT
	| AT_IDENT
	;

func_header :
	optional_type type '.' func_macro_name
	| optional_type func_macro_name
	;

macro_header :
	func_header
	| type '.' func_macro_name
	| func_macro_name
	;

fn_parameter_list :
	'(' parameters ')'
	| '(' ')'
	;

parameters :
	parameter '=' expr
	| parameter
	| parameters ',' parameter
	| parameters ',' parameter '=' expr
	;

parameter :
	type IDENT opt_attributes
	| type ELLIPSIS IDENT opt_attributes
	| type ELLIPSIS CT_IDENT
	| type CT_IDENT
	| type ELLIPSIS opt_attributes
	| type HASH_IDENT opt_attributes
	| type '&' IDENT opt_attributes
	| type opt_attributes
	| '&' IDENT opt_attributes
	| HASH_IDENT opt_attributes
	| ELLIPSIS
	| IDENT opt_attributes
	| IDENT ELLIPSIS opt_attributes
	| CT_IDENT
	| CT_IDENT ELLIPSIS
	;

func_definition :
	FN func_header fn_parameter_list opt_attributes ';'
	| FN func_header fn_parameter_list opt_attributes macro_func_body
	;

const_declaration :
	CONST CONST_IDENT opt_attributes '=' expr ';'
	| CONST type CONST_IDENT opt_attributes '=' expr ';'
	;

func_typedef :
	FN optional_type fn_parameter_list
	;

opt_distinct_inline :
	DISTINCT
	| DISTINCT INLINE
	| INLINE DISTINCT
	| INLINE
	| empty
	;

generic_parameters :
	expr
	| type
	| generic_parameters ',' expr
	| generic_parameters ',' type
	;

typedef_type :
	func_typedef
	| type opt_generic_parameters
	;

multi_declaration :
	',' IDENT
	| multi_declaration ',' IDENT
	;

global_storage :
	TLOCAL
	| empty
	;

global_declaration :
	global_storage optional_type IDENT opt_attributes ';'
	| global_storage optional_type IDENT multi_declaration opt_attributes ';'
	| global_storage optional_type IDENT opt_attributes '=' expr ';'
	;

opt_tl_stmts :
	top_level_statements
	| empty
	;

tl_ct_case :
	CT_CASE constant_expr ':' opt_tl_stmts
	| CT_CASE type ':' opt_tl_stmts
	| CT_DEFAULT ':' opt_tl_stmts
	;

tl_ct_switch_body :
	tl_ct_case
	| tl_ct_switch_body tl_ct_case
	;

define_attribute :
	AT_TYPE_IDENT '(' parameters ')' opt_attributes '=' '{' opt_attributes '}'
	| AT_TYPE_IDENT opt_attributes '=' '{' opt_attributes '}'
	;

generic_expr :
	LGENPAR generic_parameters RGENPAR
	;

opt_generic_parameters :
	generic_expr
	| empty
	;

define_ident :
	IDENT '=' path_ident opt_generic_parameters
	| CONST_IDENT '=' path_const opt_generic_parameters
	| AT_IDENT '=' path_at_ident opt_generic_parameters
	;

define_declaration :
	DEF define_ident opt_attributes ';'
	| DEF define_attribute opt_attributes';'
	| DEF TYPE_IDENT opt_attributes '=' opt_distinct_inline typedef_type opt_attributes ';'
	;

tl_ct_if :
	CT_IF constant_expr ':' opt_tl_stmts CT_ENDIF
	| CT_IF constant_expr ':' opt_tl_stmts CT_ELSE opt_tl_stmts CT_ENDIF
	;

tl_ct_switch :
	ct_switch tl_ct_switch_body CT_ENDSWITCH
	;

module_param :
	CONST_IDENT
	| TYPE_IDENT
	;

module_params :
	module_param
	| module_params ',' module_param
	;

module :
	MODULE path_ident opt_attributes ';'
	| MODULE path_ident LGENPAR module_params RGENPAR opt_attributes ';'
	;

import_paths :
	path_ident
	| path_ident ',' path_ident
	;

import_decl :
	IMPORT import_paths opt_attributes ';'
	;

translation_unit :
	top_level_statements
	| empty
	;

top_level_statements :
	top_level
	| top_level_statements top_level
	;

opt_extern :
	EXTERN
	| empty
	;

top_level :
	module
	| import_decl
	| opt_extern func_definition
	| opt_extern const_declaration
	| opt_extern global_declaration
	| ct_assert_stmt
	| ct_echo_stmt
	| ct_include_stmt
	| tl_ct_if
	| tl_ct_switch
	| struct_declaration
	| fault_declaration
	| enum_declaration
	| macro_declaration
	| define_declaration
	| static_declaration
	| bitstruct_declaration
	;

%%

D           [0-9]
DU          [0-9_]
UN          [_]
L           [a-zA-Z_]
AN          [a-zA-Z_0-9]
H           [a-fA-F0-9]
HU          [a-fA-F0-9_]
UA          [A-Z_0-9]
O           [0-7]
B           [0-1]
DC          [a-z]
UC          [A-Z]
CONST       [_]*{UC}{UA}*
TYPE        [_]*{UC}{UA}*{DC}{AN}*
IDENTIFIER  [_]*{DC}{AN}*
E           [Ee][+-]?{D}+
P           [Pp][+-]?{D}+
B64         [ \t\v\n\f]?[A-Za-z0-9+/][ \t\v\n\fA-Za-z0-9+/=]+
HEX         [ \t\v\n\f]?[A-Fa-f0-9][ \t\v\n\fA-Fa-f0-9]+
INTTYPE     (([ui](8|16|32|64|128))|([Uu][Ll]?|[Ll]))?
REALTYPE    [f](8|16|32|64|128)?
INT         {D}(_*{D})*
HINT        {H}(_*{H})*
OINT        {O}(_*{O})*
BINT        {B}(_*{B})*

WS          [ \t\v\n\r\f]

%%

"$alignof"      CT_ALIGNOF
"$assert"       CT_ASSERT
"$case"         CT_CASE
"$checks"       CT_CHECKS
"$default"      CT_DEFAULT
"$defined"      CT_DEFINED
"$echo"         CT_ECHO
"$else"         CT_ELSE
"$endfor"       CT_ENDFOR
"$endforeach"   CT_ENDFOREACH
"$endif"        CT_ENDIF
"$endswitch"    CT_ENDSWITCH
"$error"        CT_ERROR
"$eval"         CT_EVAL
"$evaltype"     CT_EVALTYPE
"$extnameof"    CT_EXTNAMEOF
"$feature"      CT_FEATURE
"$for"          CT_FOR
"$foreach"      CT_FOREACH
"$if"           CT_IF
"$include"      CT_INCLUDE
"$nameof"       CT_NAMEOF
"$offsetof"     CT_OFFSETOF
"$qnameof"      CT_QNAMEOF
"$sizeof"       CT_SIZEOF
"$stringify"    CT_STRINGIFY
"$switch"       CT_SWITCH
"$typefrom"     CT_TYPEFROM
"$typeof"       CT_TYPEOF
"$vaarg"        CT_VAARG
"$vaconst"      CT_VACONST
"$vacount"      CT_VACOUNT
"$vaexpr"       CT_VAEXPR
"$varef"        CT_VAREF
"$vasplat"      CT_VASPLAT
"$vatype"       CT_VATYPE
"/*"<>COMMENT>
<COMMENT>{
	"/*"<>COMMENT>
	"*/"<<>	skip()
	{WS}	skip()
	.	skip()
}
\/\/.*          skip()
"any"           ANY
"anyfault"      ANYFAULT
"asm"           ASM
"assert"        ASSERT
"bitstruct"     BITSTRUCT
"bool"          BOOL
"break"		BREAK
"case"		CASE
"catch"         CATCH
"char"		CHAR
"const"		CONST
"continue"	CONTINUE
"def"           DEF
"default"	DEFAULT
"defer"         DEFER
"distinct"      DISTINCT
"do"		DO
"double"	DOUBLE
"else"		ELSE
"enum"		ENUM
"extern"        EXTERN
"false"         FALSE
"fault"		FAULT
"finalize"      FINALIZE
"float"		FLOAT
"bfloat16"      BFLOAT16
"float16"       FLOAT16
"float128"      FLOAT128
"fn"            FN
"for"		FOR
"foreach"	FOREACH
"foreach_r"	FOREACH_R
"ichar"         ICHAR
"if"		IF
"import"        IMPORT
"initialize"    INITIALIZE
"inline"	INLINE
"int"		INT
"int128"	INT128
"iptr"          IPTR
"isz"           ISZ
"long"		LONG
"macro"         MACRO
"module"        MODULE
"nextcase"      NEXTCASE
"null"          NUL
"return"	RETURN
"short"		SHORT
"struct"	STRUCT
"static"        STATIC
"switch"	SWITCH
"tlocal"        TLOCAL
"true"          TRUE
"try"           TRY
"typeid"        TYPEID
"uint"		UINT
"uint128"	UINT128
"ulong"		ULONG
"union"		UNION
"uptr"          UPTR
"ushort"	USHORT
"usz"           USZ
"var"           VAR
"void"		VOID
"while"		WHILE

//@{CONST}        AT_CONST_IDENT
//#{CONST}        HASH_CONST_IDENT
"$"{CONST}      CT_CONST_IDENT
{CONST}         CONST_IDENT
@{TYPE}         AT_TYPE_IDENT
//#{TYPE}         HASH_TYPE_IDENT
"$"{TYPE}       CT_TYPE_IDENT
{TYPE}          TYPE_IDENT
@{IDENTIFIER}   AT_IDENT
#{IDENTIFIER}   HASH_IDENT
"$"{IDENTIFIER} CT_IDENT
{IDENTIFIER}    IDENT
0[xX]{HINT}{INTTYPE}?	INTEGER
0[oO]{OINT}{INTTYPE}?	INTEGER
0[bB]{BINT}{INTTYPE}?   INTEGER
{INT}{INTTYPE}?	        INTEGER
x\'{HEX}+\' BYTES
x\"{HEX}+\" BYTES
x\`{HEX}+\` BYTES
b64\'{B64}+\' BYTES
b64\"{B64}+\" BYTES
b64\`{B64}+\` BYTES

{INT}{E}{REALTYPE}? REAL
0[xX]{HINT}{P}{REALTYPE}?	REAL
{INT}"."{INT}{E}?{REALTYPE}?	REAL
0[xX]{HINT}"."{HINT}{P}{REALTYPE}? REAL

\"(\\.|[^\\"])*\"	STRING_LITERAL
\'(\\.|[^\\'])*\'	CHAR_LITERAL

"`"<RAW_STRING>
<RAW_STRING>{
	"``"<.>
	"`"<INITIAL>         STRING_LITERAL
	[^`]<.>
}

"..."		ELLIPSIS
".."		DOTDOT
">>="		SHR_ASSIGN
"<<="		SHL_ASSIGN
"+="		ADD_ASSIGN
"-="		SUB_ASSIGN
"*="		MUL_ASSIGN
"/="		DIV_ASSIGN
"%="		MOD_ASSIGN
"&="		AND_ASSIGN
"^="		XOR_ASSIGN
"|="		OR_ASSIGN
">>"		SHR_OP
"<<"		SHL_OP
"++"		INC_OP
"--"		DEC_OP
"&&"		AND_OP
"||"		OR_OP
"<="		LE_OP
">="		GE_OP
"=="		EQ_OP
"!="		NE_OP
"??"            OPTELSE
"::"            SCOPE
"?:"            ELVIS
"=>"            IMPLIES
"[<"            LVEC
">]"            RVEC
"(<"            LGENPAR
">)"            RGENPAR
"$$"            BUILTIN
";"		';'
("{")		'{'
("}")		'}'
","		','
":"		':'
"="		'='
"("		'('
")"		')'
("[")		'['
("]")		']'
"."		'.'
"&"		'&'
"!"		'!'
"!!"		BANGBANG
"~"		'~'
"-"		'-'
"+"		'+'
"*"		'*'
"/"		'/'
"%"		'%'
"<"		'<'
">"		'>'
"^"		'^'
"|"		'|'
"?"		'?'
"{|"        	LBRAPIPE
"|}"        	RBRAPIPE
{WS}		skip()
//.		{ /* ignore bad characters */ }

%%
