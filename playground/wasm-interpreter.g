//From: https://github.com/WebAssembly/spec/blob/master/interpreter/text/parser.mly

%token LPAR RPAR
%token NAT INT FLOAT STRING VAR
%token NUM_TYPE
%token VEC_TYPE
%token VEC_SHAPE
%token FUNCREF EXTERNREF EXTERN MUT
%token UNREACHABLE NOP DROP SELECT
%token BLOCK END IF THEN ELSE LOOP BR BR_IF BR_TABLE
%token CALL CALL_INDIRECT RETURN
%token LOCAL_GET LOCAL_SET LOCAL_TEE GLOBAL_GET GLOBAL_SET
%token TABLE_GET TABLE_SET
%token TABLE_SIZE TABLE_GROW TABLE_FILL TABLE_COPY TABLE_INIT ELEM_DROP
%token MEMORY_SIZE MEMORY_GROW MEMORY_FILL MEMORY_COPY MEMORY_INIT DATA_DROP
%token LOAD STORE
%token OFFSET_EQ_NAT ALIGN_EQ_NAT
%token CONST
%token UNARY BINARY TEST COMPARE CONVERT
%token REF_NULL REF_FUNC REF_EXTERN REF_IS_NULL
%token VEC_LOAD VEC_STORE
%token VEC_LOAD_LANE VEC_STORE_LANE
%token VEC_CONST
%token VEC_UNARY VEC_BINARY VEC_TERNARY VEC_TEST
%token VEC_SHIFT VEC_BITMASK VEC_SPLAT
%token VEC_SHUFFLE
%token VEC_EXTRACT VEC_REPLACE
%token FUNC START TYPE PARAM RESULT LOCAL GLOBAL
%token TABLE ELEM MEMORY DATA DECLARE OFFSET ITEM IMPORT EXPORT
%token MODULE BIN QUOTE
%token SCRIPT REGISTER INVOKE GET
%token ASSERT_MALFORMED ASSERT_INVALID ASSERT_UNLINKABLE
%token ASSERT_RETURN ASSERT_TRAP ASSERT_EXHAUSTION
%token NAN
%token INPUT OUTPUT
//%token EOF

//%start script script1 module1
%start script

%%

/* Auxiliaries */

name :
	STRING
	;

string_list :
	/* empty */
	| string_list STRING
	;

/* Types */

ref_kind :
	FUNC
	| EXTERN
	;

ref_type :
	FUNCREF
	| EXTERNREF
	;

value_type :
	NUM_TYPE
	| VEC_TYPE
	| ref_type
	;

value_type_list :
	/* empty */
	| value_type value_type_list
	;

global_type :
	value_type
	| LPAR MUT value_type RPAR
	;

def_type :
	LPAR FUNC func_type RPAR
	;

func_type :
	func_type_result
	| LPAR PARAM value_type_list RPAR func_type
	| LPAR PARAM bind_var value_type RPAR func_type  /* Sugar */
	;


func_type_result :
	/* empty */
	| LPAR RESULT value_type_list RPAR func_type_result
	;


table_type :
	limits ref_type
	;

memory_type :
	limits
	;

limits :
	NAT
	| NAT NAT
	;

type_use :
	LPAR TYPE var RPAR
	;


/* Immediates */

num :
	NAT
	| INT
	| FLOAT
	;

num_list:
	/* empty */
	| num num_list
	;

var :
	NAT
	| VAR
	;

var_list :
	/* empty */
	| var var_list
	;

bind_var_opt :
	/* empty */
	| bind_var   /* Sugar */
	;

bind_var :
	VAR
	;

labeling_opt :
	/* empty */
	| bind_var
	;

labeling_end_opt :
	/* empty */
	| bind_var
	;

offset_opt :
	/* empty */
	| OFFSET_EQ_NAT
	;

align_opt :
	/* empty */
	| ALIGN_EQ_NAT
	;

/* Instructions & Expressions */

instr_list :
	/* empty */
	| instr1 instr_list
	| select_instr_instr_list
	| call_instr_instr_list
	;

instr1 :
	plain_instr
	| block_instr
	| expr   /* Sugar */
	;

plain_instr :
	UNREACHABLE
	| NOP
	| DROP
	| BR var
	| BR_IF var
	| BR_TABLE var var_list
	| RETURN
	| CALL var
	| LOCAL_GET var
	| LOCAL_SET var
	| LOCAL_TEE var
	| GLOBAL_GET var
	| GLOBAL_SET var
	| TABLE_GET var
	| TABLE_SET var
	| TABLE_SIZE var
	| TABLE_GROW var
	| TABLE_FILL var
	| TABLE_COPY var var
	| TABLE_INIT var var
	| TABLE_GET   /* Sugar */
	| TABLE_SET   /* Sugar */
	| TABLE_SIZE   /* Sugar */
	| TABLE_GROW   /* Sugar */
	| TABLE_FILL   /* Sugar */
	| TABLE_COPY  /* Sugar */
	| TABLE_INIT var  /* Sugar */
	| ELEM_DROP var
	| LOAD offset_opt align_opt
	| STORE offset_opt align_opt
	| VEC_LOAD offset_opt align_opt
	| VEC_STORE offset_opt align_opt
	| VEC_LOAD_LANE offset_opt align_opt NAT
	| VEC_STORE_LANE offset_opt align_opt NAT
	| MEMORY_SIZE
	| MEMORY_GROW
	| MEMORY_FILL
	| MEMORY_COPY
	| MEMORY_INIT var
	| DATA_DROP var
	| REF_NULL ref_kind
	| REF_IS_NULL
	| REF_FUNC var
	| CONST num
	| TEST
	| COMPARE
	| UNARY
	| BINARY
	| CONVERT
	| VEC_CONST VEC_SHAPE num_list
	| VEC_UNARY
	| VEC_BINARY
	| VEC_TERNARY
	| VEC_TEST
	| VEC_SHIFT
	| VEC_BITMASK
	| VEC_SHUFFLE num_list
	| VEC_SPLAT
	| VEC_EXTRACT NAT
	| VEC_REPLACE NAT
	;


select_instr_instr_list :
	SELECT select_instr_results_instr_list
	;

select_instr_results_instr_list :
	LPAR RESULT value_type_list RPAR select_instr_results_instr_list
	| instr_list
	;

call_instr_instr_list :
	CALL_INDIRECT var call_instr_type_instr_list
	| CALL_INDIRECT call_instr_type_instr_list  /* Sugar */
	;

call_instr_type_instr_list :
	type_use call_instr_params_instr_list
	;

call_instr_params_instr_list :
	LPAR PARAM value_type_list RPAR call_instr_params_instr_list
	| call_instr_results_instr_list
	;


call_instr_results_instr_list :
	LPAR RESULT value_type_list RPAR call_instr_results_instr_list
	| instr_list
	;

block_instr :
	BLOCK labeling_opt block END labeling_end_opt
	| LOOP labeling_opt block END labeling_end_opt
	| IF labeling_opt block END labeling_end_opt
	| IF labeling_opt block ELSE labeling_end_opt instr_list END labeling_end_opt
	;

block :
	type_use block_param_body
	| block_param_body  /* Sugar */
	;

block_param_body :
	block_result_body
	| LPAR PARAM value_type_list RPAR block_param_body
	;

block_result_body :
	instr_list
	| LPAR RESULT value_type_list RPAR block_result_body
	;


expr :  /* Sugar */
	LPAR expr1 RPAR
	;


expr1 :  /* Sugar */
	plain_instr expr_list
	| SELECT select_expr_results
	| CALL_INDIRECT var call_expr_type
	| CALL_INDIRECT call_expr_type  /* Sugar */
	| BLOCK labeling_opt block
	| LOOP labeling_opt block
	| IF labeling_opt if_block
	;

select_expr_results :
	LPAR RESULT value_type_list RPAR select_expr_results
	| expr_list
	;


call_expr_type :
	type_use call_expr_params
	;

call_expr_params :
	LPAR PARAM value_type_list RPAR call_expr_params
	| call_expr_results
	;


call_expr_results :
	LPAR RESULT value_type_list RPAR call_expr_results
	| expr_list
	;



if_block :
	type_use if_block_param_body
	| if_block_param_body  /* Sugar */
	;

if_block_param_body :
	if_block_result_body
	| LPAR PARAM value_type_list RPAR if_block_param_body
	;

if_block_result_body :
	if_
	| LPAR RESULT value_type_list RPAR if_block_result_body
	;

if_ :
	expr if_
	| LPAR THEN instr_list RPAR LPAR ELSE instr_list RPAR  /* Sugar */
	| LPAR THEN instr_list RPAR  /* Sugar */
	;


expr_list :
	/* empty */
	| expr expr_list
	;

const_expr :
	instr_list
	;


/* Functions */

func :
	LPAR FUNC bind_var_opt func_fields RPAR
	;

func_fields :
	type_use func_fields_body
	| func_fields_body  /* Sugar */
	| inline_import type_use func_fields_import  /* Sugar */
	| inline_import func_fields_import  /* Sugar */
	| inline_export func_fields  /* Sugar */
	;

func_fields_import :  /* Sugar */
	func_fields_import_result
	| LPAR PARAM value_type_list RPAR func_fields_import
	| LPAR PARAM bind_var value_type RPAR func_fields_import  /* Sugar */
	;


func_fields_import_result :  /* Sugar */
	/* empty */
	| LPAR RESULT value_type_list RPAR func_fields_import_result
	;


func_fields_body :
	func_result_body
	| LPAR PARAM value_type_list RPAR func_fields_body
	| LPAR PARAM bind_var value_type RPAR func_fields_body  /* Sugar */
	;

func_result_body :
	func_body
	| LPAR RESULT value_type_list RPAR func_result_body
	;

func_body :
	instr_list
	| LPAR LOCAL value_type_list RPAR func_body
	| LPAR LOCAL bind_var value_type RPAR func_body  /* Sugar */
	;


/* Tables, Memories & Globals */

table_use :
	LPAR TABLE var RPAR
	;

memory_use :
	LPAR MEMORY var RPAR
	;

offset :
	LPAR OFFSET const_expr RPAR
	| expr   /* Sugar */
	;

elem_kind :
	FUNC
	;

elem_expr :
	LPAR ITEM const_expr RPAR
	| expr   /* Sugar */
	;

elem_expr_list :
	/* empty */
	| elem_expr elem_expr_list
	;

elem_var_list :
	var_list
	;

elem_list :
	elem_kind elem_var_list
	| ref_type elem_expr_list
	;



elem :
	LPAR ELEM bind_var_opt elem_list RPAR
	| LPAR ELEM bind_var_opt table_use offset elem_list RPAR
	| LPAR ELEM bind_var_opt DECLARE elem_list RPAR
	| LPAR ELEM bind_var_opt offset elem_list RPAR  /* Sugar */
	| LPAR ELEM bind_var_opt offset elem_var_list RPAR  /* Sugar */
	;

table :
	LPAR TABLE bind_var_opt table_fields RPAR
	;

table_fields :
	table_type
	| inline_import table_type  /* Sugar */
	| inline_export table_fields  /* Sugar */
	| ref_type LPAR ELEM elem_expr elem_expr_list RPAR  /* Sugar */
	| ref_type LPAR ELEM elem_var_list RPAR  /* Sugar */
	;

data :
	LPAR DATA bind_var_opt string_list RPAR
	| LPAR DATA bind_var_opt memory_use offset string_list RPAR
	| LPAR DATA bind_var_opt offset string_list RPAR  /* Sugar */
	;

memory :
	LPAR MEMORY bind_var_opt memory_fields RPAR
	;

memory_fields :
	memory_type
	| inline_import memory_type  /* Sugar */
	| inline_export memory_fields  /* Sugar */
	| LPAR DATA string_list RPAR  /* Sugar */
	;

global :
	LPAR GLOBAL bind_var_opt global_fields RPAR
	;

global_fields :
	global_type const_expr
	| inline_import global_type  /* Sugar */
	| inline_export global_fields  /* Sugar */
	;


/* Imports & Exports */

import_desc :
	LPAR FUNC bind_var_opt type_use RPAR
	| LPAR FUNC bind_var_opt func_type RPAR  /* Sugar */
	| LPAR TABLE bind_var_opt table_type RPAR
	| LPAR MEMORY bind_var_opt memory_type RPAR
	| LPAR GLOBAL bind_var_opt global_type RPAR
	;

import :
	LPAR IMPORT name name import_desc RPAR
	;

inline_import :
	LPAR IMPORT name name RPAR
	;

export_desc :
	LPAR FUNC var RPAR
	| LPAR TABLE var RPAR
	| LPAR MEMORY var RPAR
	| LPAR GLOBAL var RPAR
	;

export :
	LPAR EXPORT name export_desc RPAR
	;

inline_export :
	LPAR EXPORT name RPAR
	;



/* Modules */

type_ :
	def_type
	;

type_def :
	LPAR TYPE type_ RPAR
	| LPAR TYPE bind_var type_ RPAR  /* Sugar */
	;


start :
	LPAR START var RPAR
	;


module_fields :
	/* empty */
	| module_fields1
	;

module_fields1 :
	type_def module_fields
	| global module_fields
	| table module_fields
	| memory module_fields
	| func module_fields
	| elem module_fields
	| data module_fields
	| start module_fields
	| import module_fields
	| export module_fields
	;

module_var_opt :
	/* empty */
	| VAR   /* Sugar */
	;

module_ :
	LPAR MODULE module_var_opt module_fields RPAR
	;


//inline_module :  /* Sugar */
//	module_fields
//	;

inline_module1 :  /* Sugar */
	module_fields1
	;


/* Scripts */

script_var_opt :
	/* empty */
	| VAR   /* Sugar */
	;

script_module :
	module_
	| LPAR MODULE module_var_opt BIN string_list RPAR
	| LPAR MODULE module_var_opt QUOTE string_list RPAR
	;


action :
	LPAR INVOKE module_var_opt name literal_list RPAR
	| LPAR GET module_var_opt name RPAR
	;

assertion :
	LPAR ASSERT_MALFORMED script_module STRING RPAR
	| LPAR ASSERT_INVALID script_module STRING RPAR
	| LPAR ASSERT_UNLINKABLE script_module STRING RPAR
	| LPAR ASSERT_TRAP script_module STRING RPAR
	| LPAR ASSERT_RETURN action result_list RPAR
	| LPAR ASSERT_TRAP action STRING RPAR
	| LPAR ASSERT_EXHAUSTION action STRING RPAR
	;

cmd :
	action
	| assertion
	| script_module
	| LPAR REGISTER name module_var_opt RPAR
	| meta
	;

cmd_list :
	/* empty */
	| cmd cmd_list
	;

meta :
	LPAR SCRIPT script_var_opt cmd_list RPAR
	| LPAR INPUT script_var_opt STRING RPAR
	| LPAR OUTPUT script_var_opt STRING RPAR
	| LPAR OUTPUT script_var_opt RPAR
	;

literal_num :
	LPAR CONST num RPAR
	;

literal_vec :
	LPAR VEC_CONST VEC_SHAPE num_list RPAR
	;

literal_ref :
	LPAR REF_NULL ref_kind RPAR
	| LPAR REF_EXTERN NAT RPAR
	;

literal :
	literal_num
	| literal_vec
	| literal_ref
	;

literal_list :
	/* empty */
	| literal literal_list
	;

numpat :
	num
	| NAN
	;

numpat_list:
	/* empty */
	| numpat numpat_list
	;

result :
	literal_num
	| LPAR CONST NAN RPAR
	| literal_ref
	| LPAR REF_FUNC RPAR
	| LPAR REF_EXTERN RPAR
	| LPAR VEC_CONST VEC_SHAPE numpat_list RPAR
	;

result_list :
	/* empty */
	| result result_list
	;

script :
	cmd_list //EOF
	| inline_module1 //EOF   /* Sugar */
	;

//script1 :
//	cmd
//	;
//
//module1 :
//	module_ //EOF
//	| inline_module //EOF   /* Sugar */
//	;

%%

sign  [+-]
digit	[0-9]
hexdigit	[0-9a-fA-F]
num	{digit}(_?{digit})*
hexnum	{hexdigit}(_?{hexdigit})*

letter	[a-zA-Z]
symbol	[+\-*/\\^~=<>!?@#$%&|:`.']

space	[ \t\n\r]
/* space */
control	[\x00-\x1f]
ascii	[\x00-\x7f]
/* '\x0a' */
ascii_no_nl	{ascii}
utf8cont	[\x80-\xbf]
utf8enc	[\xc2-\xdf]{utf8cont}|[\xe0][\xa0-\xbf]{utf8cont}|[\xed][\x80-\x9f]{utf8cont}|[\xe1-\xec\xee-\xef]{utf8cont}{2}|[\xf0][\x90-\xbf]{utf8cont}{2}|[\xf4][\x80-\x8f]{utf8cont}{2}|[\xf1-\xf3]{utf8cont}{3}
utf8	{ascii}|{utf8enc}
utf8_no_nl	{ascii_no_nl}|{utf8enc}

escape	[nrt\\"]
character	[^"\\\x00-\x1f\x7f-\xff]|{utf8enc}|"\\"{escape}|"\\"{hexdigit}{2}|"\\u{"{hexnum}"}"

nat	{num}|"0x"{hexnum}
int	{sign}{nat}
frac	{num}
hexfrac	{hexnum}
float		{sign}?({num}"."{frac}?|{num}("."{frac}?)?[eE]{sign}?{num}|"0x"{hexnum}"."{hexfrac}?|"0x"{hexnum}("."{hexfrac}?)?[pP]{sign}?{num}|"inf"|"nan"|"nan:""0x"{hexnum})
string	\"{character}*\"

idchar	{letter}|{digit}|"_"|{symbol}
name	{idchar}+
id	"$"{name}

keyword	[a-z]({letter}|{digit}|"_"|"."|":")+
reserved	({idchar}|{string})+|","|";"|"["|"]"|"{"|"}"

ixx	"i"("32"|"64")
fxx	"f"("32"|"64")
nxx	{ixx}|{fxx}
vxxx	"v128"
mixx	"i"("8"|"16"|"32"|"64")
//sign	"s"|"u"
mem_size	"8"|"16"|"32"
v128_int_shape	"i8x16"|"i16x8"|"i32x4"|"i64x2"
v128_float_shape	"f32x4"|"f64x2"
v128_shape	{v128_int_shape}|{v128_float_shape}

%%

//rule token = parse
"("	LPAR
")"	RPAR

{nat}	NAT
{int}	INT
{float}	FLOAT

{string}	STRING
//'"'character*('\n'|eof) { error lexbuf "unclosed string literal" }
//'"'character*['\x00'-'\x09''\x0b'-'\x1f''\x7f'] { error lexbuf "illegal control character in string literal" }
//'"'character*'\\'_ { error_nest (Lexing.lexeme_end_p lexbuf) lexbuf "illegal escape" }

//keyword as s
//{ match s with
"i32"	NUM_TYPE
"i64"	NUM_TYPE
"f32"	NUM_TYPE
"f64"	NUM_TYPE
"v128"	VEC_TYPE
"i8x16"	VEC_SHAPE
"i16x8"	VEC_SHAPE
"i32x4"	VEC_SHAPE
"i64x2"	VEC_SHAPE
"f32x4"	VEC_SHAPE
"f64x2"	VEC_SHAPE

"extern"	EXTERN
"externref"	EXTERNREF
"funcref"	FUNCREF
"mut"	MUT

"nop"	NOP
"unreachable"	UNREACHABLE
"drop"	DROP
"block"	BLOCK
"loop"	LOOP
"end"	END
"br"	BR
"br_if"	BR_IF
"br_table"	BR_TABLE
"return"	RETURN
"if"	IF
"then"	THEN
"else"	ELSE
"select"	SELECT
"call"	CALL
"call_indirect"	CALL_INDIRECT

"local.get"	LOCAL_GET
"local.set"	LOCAL_SET
"local.tee"	LOCAL_TEE
"global.get"	GLOBAL_GET
"global.set"	GLOBAL_SET

"table.get"	TABLE_GET
"table.set"	TABLE_SET
"table.size"	TABLE_SIZE
"table.grow"	TABLE_GROW
"table.fill"	TABLE_FILL
"table.copy"	TABLE_COPY
"table.init"	TABLE_INIT
"elem.drop"	ELEM_DROP

"memory.size"	MEMORY_SIZE
"memory.grow"	MEMORY_GROW
"memory.fill"	MEMORY_FILL
"memory.copy"	MEMORY_COPY
"memory.init"	MEMORY_INIT
"data.drop"	DATA_DROP

"i32.load"	LOAD
"i64.load"	LOAD
"f32.load"	LOAD
"f64.load"	LOAD
"i32.store"	STORE
"i64.store"	STORE
"f32.store"	STORE
"f64.store"	STORE

"i32.load8_u"	LOAD
"i32.load8_s"	LOAD
"i32.load16_u"	LOAD
"i32.load16_s"	LOAD
"i64.load8_u"	LOAD
"i64.load8_s"	LOAD
"i64.load16_u"	LOAD
"i64.load16_s"	LOAD
"i64.load32_u"	LOAD
"i64.load32_s"	LOAD

"i32.store8"	LOAD
"i32.store16"	LOAD
"i64.store8"	LOAD
"i64.store16"	LOAD
"i64.store32"	LOAD

"v128.load"	VEC_LOAD
"v128.store"	VEC_STORE
"v128.load8x8_u"	VEC_LOAD
"v128.load8x8_s"	VEC_LOAD
"v128.load16x4_u"	VEC_LOAD
"v128.load16x4_s"	VEC_LOAD
"v128.load32x2_u"	VEC_LOAD
"v128.load32x2_s"	VEC_LOAD
"v128.load8_splat"	VEC_LOAD
"v128.load16_splat"	VEC_LOAD
"v128.load32_splat"	VEC_LOAD
"v128.load64_splat"	VEC_LOAD
"v128.load32_zero"	VEC_LOAD
"v128.load64_zero"	VEC_LOAD
"v128.load8_lane"	VEC_LOAD_LANE
"v128.load16_lane"	VEC_LOAD_LANE
"v128.load32_lane"	VEC_LOAD_LANE
"v128.load64_lane"	VEC_LOAD_LANE
"v128.store8_lane"	VEC_STORE_LANE
"v128.store16_lane"	VEC_STORE_LANE
"v128.store32_lane"	VEC_STORE_LANE
"v128.store64_lane"	VEC_STORE_LANE

"i32.const"	CONST
"i64.const"	CONST
"f32.const"	CONST
"f64.const"	CONST
"v128.const"	VEC_CONST

"ref.null"	REF_NULL
"ref.func"	REF_FUNC
"ref.extern"	REF_EXTERN
"ref.is_null"	REF_IS_NULL

"i32.clz"	UNARY
"i32.ctz"	UNARY
"i32.popcnt"	UNARY
"i32.extend8_s"	UNARY
"i32.extend16_s"	UNARY
"i64.clz"	UNARY
"i64.ctz"	UNARY
"i64.popcnt"	UNARY
"i64.extend8_s"	UNARY
"i64.extend16_s"	UNARY
"i64.extend32_s"	UNARY

"f32.neg"	UNARY
"f32.abs"	UNARY
"f32.sqrt"	UNARY
"f32.ceil"	UNARY
"f32.floor"	UNARY
"f32.trunc"	UNARY
"f32.nearest"	UNARY
"f64.neg"	UNARY
"f64.abs"	UNARY
"f64.sqrt"	UNARY
"f64.ceil"	UNARY
"f64.floor"	UNARY
"f64.trunc"	UNARY
"f64.nearest"	UNARY

"i32.add"	BINARY
"i32.sub"	BINARY
"i32.mul"	BINARY
"i32.div_u"	BINARY
"i32.div_s"	BINARY
"i32.rem_u"	BINARY
"i32.rem_s"	BINARY
"i32.and"	BINARY
"i32.or"	BINARY
"i32.xor"	BINARY
"i32.shl"	BINARY
"i32.shr_u"	BINARY
"i32.shr_s"	BINARY
"i32.rotl"	BINARY
"i32.rotr"	BINARY
"i64.add"	BINARY
"i64.sub"	BINARY
"i64.mul"	BINARY
"i64.div_u"	BINARY
"i64.div_s"	BINARY
"i64.rem_u"	BINARY
"i64.rem_s"	BINARY
"i64.and"	BINARY
"i64.or"	BINARY
"i64.xor"	BINARY
"i64.shl"	BINARY
"i64.shr_u"	BINARY
"i64.shr_s"	BINARY
"i64.rotl"	BINARY
"i64.rotr"	BINARY

"f32.add"	BINARY
"f32.sub"	BINARY
"f32.mul"	BINARY
"f32.div"	BINARY
"f32.min"	BINARY
"f32.max"	BINARY
"f32.copysign"	BINARY
"f64.add"	BINARY
"f64.sub"	BINARY
"f64.mul"	BINARY
"f64.div"	BINARY
"f64.min"	BINARY
"f64.max"	BINARY
"f64.copysign"	BINARY

"i32.eqz"	TEST
"i64.eqz"	TEST

"i32.eq"	COMPARE
"i32.ne"	COMPARE
"i32.lt_u"	COMPARE
"i32.lt_s"	COMPARE
"i32.le_u"	COMPARE
"i32.le_s"	COMPARE
"i32.gt_u"	COMPARE
"i32.gt_s"	COMPARE
"i32.ge_u"	COMPARE
"i32.ge_s"	COMPARE
"i64.eq"	COMPARE
"i64.ne"	COMPARE
"i64.lt_u"	COMPARE
"i64.lt_s"	COMPARE
"i64.le_u"	COMPARE
"i64.le_s"	COMPARE
"i64.gt_u"	COMPARE
"i64.gt_s"	COMPARE
"i64.ge_u"	COMPARE
"i64.ge_s"	COMPARE

"f32.eq"	COMPARE
"f32.ne"	COMPARE
"f32.lt"	COMPARE
"f32.le"	COMPARE
"f32.gt"	COMPARE
"f32.ge"	COMPARE
"f64.eq"	COMPARE
"f64.ne"	COMPARE
"f64.lt"	COMPARE
"f64.le"	COMPARE
"f64.gt"	COMPARE
"f64.ge"	COMPARE

"i32.wrap_i64"	CONVERT
"i64.extend_i32_s"	CONVERT
"i64.extend_i32_u"	CONVERT
"f32.demote_f64"	CONVERT
"f64.promote_f32"	CONVERT
"i32.trunc_f32_u"	CONVERT
"i32.trunc_f32_s"	CONVERT
"i64.trunc_f32_u"	CONVERT
"i64.trunc_f32_s"	CONVERT
"i32.trunc_f64_u"	CONVERT
"i32.trunc_f64_s"	CONVERT
"i64.trunc_f64_u"	CONVERT
"i64.trunc_f64_s"	CONVERT
"i32.trunc_sat_f32_u"	CONVERT
"i32.trunc_sat_f32_s"	CONVERT
"i64.trunc_sat_f32_u"	CONVERT
"i64.trunc_sat_f32_s"	CONVERT
"i32.trunc_sat_f64_u"	CONVERT
"i32.trunc_sat_f64_s"	CONVERT
"i64.trunc_sat_f64_u"	CONVERT
"i64.trunc_sat_f64_s"	CONVERT
"f32.convert_i32_u"	CONVERT
"f32.convert_i32_s"	CONVERT
"f64.convert_i32_u"	CONVERT
"f64.convert_i32_s"	CONVERT
"f32.convert_i64_u"	CONVERT
"f32.convert_i64_s"	CONVERT
"f64.convert_i64_u"	CONVERT
"f64.convert_i64_s"	CONVERT
"f32.reinterpret_i32"	CONVERT
"f64.reinterpret_i64"	CONVERT
"i32.reinterpret_f32"	CONVERT
"i64.reinterpret_f64"	CONVERT

"v128.not"	VEC_UNARY
"v128.and"	VEC_UNARY
"v128.andnot"	VEC_UNARY
"v128.or"	VEC_UNARY
"v128.xor"	VEC_UNARY
"v128.bitselect"	VEC_TERNARY
"v128.any_true"	VEC_TEST

"i8x16.neg"	VEC_UNARY
"i16x8.neg"	VEC_UNARY
"i32x4.neg"	VEC_UNARY
"i64x2.neg"	VEC_UNARY
"i8x16.abs"	VEC_UNARY
"i16x8.abs"	VEC_UNARY
"i32x4.abs"	VEC_UNARY
"i64x2.abs"	VEC_UNARY
"i8x16.popcnt"	VEC_UNARY
"i8x16.avgr_u"	VEC_UNARY
"i16x8.avgr_u"	VEC_UNARY

"f32x4.neg"	VEC_UNARY
"f64x2.neg"	VEC_UNARY
"f32x4.abs"	VEC_UNARY
"f64x2.abs"	VEC_UNARY
"f32x4.sqrt"	VEC_UNARY
"f64x2.sqrt"	VEC_UNARY
"f32x4.ceil"	VEC_UNARY
"f64x2.ceil"	VEC_UNARY
"f32x4.floor"	VEC_UNARY
"f64x2.floor"	VEC_UNARY
"f32x4.trunc"	VEC_UNARY
"f64x2.trunc"	VEC_UNARY
"f32x4.nearest"	VEC_UNARY
"f64x2.nearest"	VEC_UNARY

"i32x4.trunc_sat_f32x4_u"	VEC_UNARY
"i32x4.trunc_sat_f32x4_s"	VEC_UNARY
"i32x4.trunc_sat_f64x2_u_zero"	VEC_UNARY
"i32x4.trunc_sat_f64x2_s_zero"	VEC_UNARY
"f64x2.promote_low_f32x4"	VEC_UNARY
"f32x4.demote_f64x2_zero"	VEC_UNARY
"f32x4.convert_i32x4_u"	VEC_UNARY
"f32x4.convert_i32x4_s"	VEC_UNARY
"f64x2.convert_low_i32x4_u"	VEC_UNARY
"f64x2.convert_low_i32x4_s"	VEC_UNARY
"i16x8.extadd_pairwise_i8x16_u"	VEC_UNARY
"i16x8.extadd_pairwise_i8x16_s"	VEC_UNARY
"i32x4.extadd_pairwise_i16x8_u"	VEC_UNARY
"i32x4.extadd_pairwise_i16x8_s"	VEC_UNARY

"i8x16.eq"	VEC_BINARY
"i16x8.eq"	VEC_BINARY
"i32x4.eq"	VEC_BINARY
"i64x2.eq"	VEC_BINARY
"i8x16.ne"	VEC_BINARY
"i16x8.ne"	VEC_BINARY
"i32x4.ne"	VEC_BINARY
"i64x2.ne"	VEC_BINARY
"i8x16.lt_u"	VEC_BINARY
"i8x16.lt_s"	VEC_BINARY
"i16x8.lt_u"	VEC_BINARY
"i16x8.lt_s"	VEC_BINARY
"i32x4.lt_u"	VEC_BINARY
"i32x4.lt_s"	VEC_BINARY
"i64x2.lt_s"	VEC_BINARY
"i8x16.le_u"	VEC_BINARY
"i8x16.le_s"	VEC_BINARY
"i16x8.le_u"	VEC_BINARY
"i16x8.le_s"	VEC_BINARY
"i32x4.le_u"	VEC_BINARY
"i32x4.le_s"	VEC_BINARY
"i64x2.le_s"	VEC_BINARY
"i8x16.gt_u"	VEC_BINARY
"i8x16.gt_s"	VEC_BINARY
"i16x8.gt_u"	VEC_BINARY
"i16x8.gt_s"	VEC_BINARY
"i32x4.gt_u"	VEC_BINARY
"i32x4.gt_s"	VEC_BINARY
"i64x2.gt_s"	VEC_BINARY
"i8x16.ge_u"	VEC_BINARY
"i8x16.ge_s"	VEC_BINARY
"i16x8.ge_u"	VEC_BINARY
"i16x8.ge_s"	VEC_BINARY
"i32x4.ge_u"	VEC_BINARY
"i32x4.ge_s"	VEC_BINARY
"i64x2.ge_s"	VEC_BINARY

"f32x4.eq"	VEC_BINARY
"f64x2.eq"	VEC_BINARY
"f32x4.ne"	VEC_BINARY
"f64x2.ne"	VEC_BINARY
"f32x4.lt"	VEC_BINARY
"f64x2.lt"	VEC_BINARY
"f32x4.le"	VEC_BINARY
"f64x2.le"	VEC_BINARY
"f32x4.gt"	VEC_BINARY
"f64x2.gt"	VEC_BINARY
"f32x4.ge"	VEC_BINARY
"f64x2.ge"	VEC_BINARY
"i8x16.swizzle"	VEC_BINARY

"i8x16.add"	VEC_BINARY
"i16x8.add"	VEC_BINARY
"i32x4.add"	VEC_BINARY
"i64x2.add"	VEC_BINARY
"i8x16.sub"	VEC_BINARY
"i16x8.sub"	VEC_BINARY
"i32x4.sub"	VEC_BINARY
"i64x2.sub"	VEC_BINARY
"i16x8.mul"	VEC_BINARY
"i32x4.mul"	VEC_BINARY
"i64x2.mul"	VEC_BINARY
"i8x16.add_sat_u"	VEC_BINARY
"i8x16.add_sat_s"	VEC_BINARY
"i16x8.add_sat_u"	VEC_BINARY
"i16x8.add_sat_s"	VEC_BINARY
"i8x16.sub_sat_u"	VEC_BINARY
"i8x16.sub_sat_s"	VEC_BINARY
"i16x8.sub_sat_u"	VEC_BINARY
"i16x8.sub_sat_s"	VEC_BINARY
"i32x4.dot_i16x8_s"	VEC_BINARY

"i8x16.min_u"	VEC_BINARY
"i16x8.min_u"	VEC_BINARY
"i32x4.min_u"	VEC_BINARY
"i8x16.min_s"	VEC_BINARY
"i16x8.min_s"	VEC_BINARY
"i32x4.min_s"	VEC_BINARY
"i8x16.max_u"	VEC_BINARY
"i16x8.max_u"	VEC_BINARY
"i32x4.max_u"	VEC_BINARY
"i8x16.max_s"	VEC_BINARY
"i16x8.max_s"	VEC_BINARY
"i32x4.max_s"	VEC_BINARY

"f32x4.add"	VEC_BINARY
"f64x2.add"	VEC_BINARY
"f32x4.sub"	VEC_BINARY
"f64x2.sub"	VEC_BINARY
"f32x4.mul"	VEC_BINARY
"f64x2.mul"	VEC_BINARY
"f32x4.div"	VEC_BINARY
"f64x2.div"	VEC_BINARY

"f32x4.min"	VEC_BINARY
"f64x2.min"	VEC_BINARY
"f32x4.max"	VEC_BINARY
"f64x2.max"	VEC_BINARY
"f32x4.pmin"	VEC_BINARY
"f64x2.pmin"	VEC_BINARY
"f32x4.pmax"	VEC_BINARY
"f64x2.pmax"	VEC_BINARY

"i16x8.q15mulr_sat_s"	VEC_BINARY
"i8x16.narrow_i16x8_u"	VEC_BINARY
"i8x16.narrow_i16x8_s"	VEC_BINARY
"i16x8.narrow_i32x4_u"	VEC_BINARY
"i16x8.narrow_i32x4_s"	VEC_BINARY
"i16x8.extend_low_i8x16_u"	VEC_UNARY
"i16x8.extend_low_i8x16_s"	VEC_UNARY
"i16x8.extend_high_i8x16_u"	VEC_UNARY
"i16x8.extend_high_i8x16_s"	VEC_UNARY
"i32x4.extend_low_i16x8_u"	VEC_UNARY
"i32x4.extend_low_i16x8_s"	VEC_UNARY
"i32x4.extend_high_i16x8_u"	VEC_UNARY
"i32x4.extend_high_i16x8_s"	VEC_UNARY
"i64x2.extend_low_i32x4_u"	VEC_UNARY
"i64x2.extend_low_i32x4_s"	VEC_UNARY
"i64x2.extend_high_i32x4_u"	VEC_UNARY
"i64x2.extend_high_i32x4_s"	VEC_UNARY
"i16x8.extmul_low_i8x16_u"	VEC_UNARY
"i16x8.extmul_low_i8x16_s"	VEC_UNARY
"i16x8.extmul_high_i8x16_u"	VEC_UNARY
"i16x8.extmul_high_i8x16_s"	VEC_UNARY
"i32x4.extmul_low_i16x8_u"	VEC_UNARY
"i32x4.extmul_low_i16x8_s"	VEC_UNARY
"i32x4.extmul_high_i16x8_u"	VEC_UNARY
"i32x4.extmul_high_i16x8_s"	VEC_UNARY
"i64x2.extmul_low_i32x4_u"	VEC_UNARY
"i64x2.extmul_low_i32x4_s"	VEC_UNARY
"i64x2.extmul_high_i32x4_u"	VEC_UNARY
"i64x2.extmul_high_i32x4_s"	VEC_UNARY

"i8x16.all_true"	VEC_TEST
"i16x8.all_true"	VEC_TEST
"i32x4.all_true"	VEC_TEST
"i64x2.all_true"	VEC_TEST
"i8x16.bitmask"	VEC_BITMASK
"i16x8.bitmask"	VEC_BITMASK
"i32x4.bitmask"	VEC_BITMASK
"i64x2.bitmask"	VEC_BITMASK
"i8x16.shl"	VEC_SHIFT
"i16x8.shl"	VEC_SHIFT
"i32x4.shl"	VEC_SHIFT
"i64x2.shl"	VEC_SHIFT
"i8x16.shr_u"	VEC_SHIFT
"i8x16.shr_s"	VEC_SHIFT
"i16x8.shr_u"	VEC_SHIFT
"i16x8.shr_s"	VEC_SHIFT
"i32x4.shr_u"	VEC_SHIFT
"i32x4.shr_s"	VEC_SHIFT
"i64x2.shr_u"	VEC_SHIFT
"i64x2.shr_s"	VEC_SHIFT
"i8x16.shuffle"	VEC_SHUFFLE

"i8x16.splat"	VEC_SPLAT
"i16x8.splat"	VEC_SPLAT
"i32x4.splat"	VEC_SPLAT
"i64x2.splat"	VEC_SPLAT
"f32x4.splat"	VEC_SPLAT
"f64x2.splat"	VEC_SPLAT
"i8x16.extract_lane_u"	VEC_EXTRACT
"i8x16.extract_lane_s"	VEC_EXTRACT
"i16x8.extract_lane_u"	VEC_EXTRACT
"i16x8.extract_lane_s"	VEC_EXTRACT
"i32x4.extract_lane"	VEC_EXTRACT
"i64x2.extract_lane"	VEC_EXTRACT
"f32x4.extract_lane"	VEC_EXTRACT
"f64x2.extract_lane"	VEC_EXTRACT
"i8x16.replace_lane"	VEC_REPLACE
"i16x8.replace_lane"	VEC_REPLACE
"i32x4.replace_lane"	VEC_REPLACE
"i64x2.replace_lane"	VEC_REPLACE
"f32x4.replace_lane"	VEC_REPLACE
"f64x2.replace_lane"	VEC_REPLACE

"type"	TYPE
"func"	FUNC
"param"	PARAM
"result"	RESULT
"start"	START
"local"	LOCAL
"global"	GLOBAL
"table"	TABLE
"memory"	MEMORY
"elem"	ELEM
"data"	DATA
"declare"	DECLARE
"offset"	OFFSET
"item"	ITEM
"import"	IMPORT
"export"	EXPORT

"module"	MODULE
"binary"	BIN
"quote"	QUOTE

"script"	SCRIPT
"register"	REGISTER
"invoke"	INVOKE
"get"	GET
"assert_malformed"	ASSERT_MALFORMED
"assert_invalid"	ASSERT_INVALID
"assert_unlinkable"	ASSERT_UNLINKABLE
"assert_return"	ASSERT_RETURN
"assert_trap"	ASSERT_TRAP
"assert_exhaustion"	ASSERT_EXHAUSTION
"nan:canonical"	NAN
"nan:arithmetic"	NAN
"input"	INPUT
"output"	OUTPUT

//_	unknown lexbuf
//    }

"offset="{nat} 	OFFSET_EQ_NAT
"align="{nat}	ALIGN_EQ_NAT

{id}	VAR

/*
";;"utf8_no_nl*eof { EOF }
";;"utf8_no_nl*'\n' { Lexing.new_line lexbuf; token lexbuf }
";;"utf8_no_nl* { token lexbuf (* causes error on following position *) }
"(;" { comment (Lexing.lexeme_start_p lexbuf) lexbuf; token lexbuf }
space#'\n' { token lexbuf }
'\n' { Lexing.new_line lexbuf; token lexbuf }
eof { EOF }
*/
";;".*	skip()
[ \t\n\r]	skip()

/*
reserved { unknown lexbuf }
control { error lexbuf "misplaced control character" }
utf8enc { error lexbuf "misplaced unicode character" }
_ { error lexbuf "malformed UTF-8 encoding" }
*/

/*
and comment start = parse
| ";)" { () }
| "(;" { comment (Lexing.lexeme_start_p lexbuf) lexbuf; comment start lexbuf }
| '\n' { Lexing.new_line lexbuf; comment start lexbuf }
| utf8_no_nl { comment start lexbuf }
| eof { error_nest start lexbuf "unclosed comment" }
| _ { error lexbuf "malformed UTF-8 encoding" }
*/
"(;"(?s:.)*?";)"	skip()

%%
