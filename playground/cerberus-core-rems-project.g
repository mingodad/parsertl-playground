//Fom: https://github.com/rems-project/cerberus/raw/20f55e1fb2f8d9780ff664c142b3bea75e6f2edb/parsers/core/core_parser.mly

%token ACQUIRE
%token ACQ_REL
%token AILCTYPE
%token AILNAME
%token ALLOC
%token ARE_COMPATIBLE
%token ARRAY
%token ARRAYCTOR
%token ARRAY_SHIFT
%token ATOMIC
%token BACKSLASH_SLASH
%token BOOL
%token BOOLEAN
%token BOUND
%token BRACKETS
%token BUILTIN
%token CARET
%token CASE
%token CATCH_EXCEPTIONAL_CONDITION
%token CCALL
%token CFUNCTION
%token CFUNCTION_VALUE
%token CHAR
%token COLON
%token COLON_COLON
%token COLON_EQ
%token COMMA
%token CONST
%token CONSUME
%token CONV_INT
%token CREATE
%token CREATE_READONLY
%token CSTRING
%token CTYPE
%token DEF
%token DOT
%token DOTS
%token DOUBLE
%token EFF
%token ELSE
%token END
//%token EOF
%token EQ
%token EQ_GT
%token ERROR
%token FALSE
%token FENCE
%token FLOAT
%token FLOATING
%token FREE
%token FUN
%token FVFROMINT
%token GE
%token GLOB
%token GT
%token ICHAR
%token IF
%token IMPL
%token IN
%token INT
%token INT16_T
%token INT32_T
%token INT64_T
%token INT8_T
%token INTEGER
%token INTMAX_T
%token INTPTR_T
%token INT_CONST
%token IS_INTEGER
%token IS_SCALAR
%token IS_SIGNED
%token IS_UNSIGNED
%token IVALIGNOF
%token IVAND
%token IVCOMPL
%token IVFROMFLOAT
%token IVMAX
%token IVMAX_ALIGNMENT
%token IVMIN
%token IVOR
%token IVSIZEOF
%token IVXOR
%token KILL
%token LBRACE
%token LBRACKET
%token LE
%token LET
%token LOAD
%token LOADED
%token LONG
%token LONG_DOUBLE
%token LONG_LONG
%token LPAREN
%token LT
%token MEMBER_SHIFT
%token MEMOP
%token MEMOP_OP
%token MINUS
%token ND
%token NEG
%token NOT
%token NULL
%token OF
%token PAR
%token PCALL
%token PIPE
%token PLUS
%token POINTER
%token PROC
%token PTRDIFF_T
%token PTRMEMBERSHIFT
%token PURE
%token PURE_MEMOP_OP
%token RBRACE
%token RBRACKET
%token RELAXED
%token RELEASE
%token REM_F
%token REM_T
%token RMW
%token RPAREN
%token RUN
%token SAVE
%token SEMICOLON
%token SEQ_CST
%token SEQ_RMW
%token SEQ_RMW_WITH_FORWARD
%token SHORT
%token SIGNED
%token SIZE_T
%token SLASH
%token SLASH_BACKSLASH
%token SPECIFIED
%token SQUOTE
%token STAR
%token STORABLE
%token STORE
%token STORE_LOCK
%token STRING
%token STRONG
%token STRUCT
%token SYM
%token THEN
%token TRUE
%token UB
%token UINT16_T
%token UINT32_T
%token UINT64_T
%token UINT8_T
%token UINTMAX_T
%token UINTPTR_T
%token UNDEF
%token UNDERSCORE
%token UNION
%token UNIT
%token UNIT_VALUE
%token UNSEQ
%token UNSIGNED
%token UNSPECIFIED
%token VOID
%token WEAK
%token WRAPI

%token SKIP //missing ?

%nonassoc ELSE
%nonassoc IN
%right SEMICOLON
%right BACKSLASH_SLASH
%right SLASH_BACKSLASH
%left EQ GE GT LE LT
%left MINUS PLUS
%right COLON_COLON
%left REM_F REM_T SLASH STAR
%nonassoc CARET

%start start

%%

start :
	nonempty_list_declaration_ //EOF
	;

attribute :
	LBRACKET loption_separated_nonempty_list_COMMA_attribute_pair__ RBRACKET
	;

attribute_pair :
	AILNAME EQ CSTRING
	;

integer_base_type :
	ICHAR
	| SHORT
	| INT
	| LONG
	| LONG_LONG
	;

integer_type :
	CHAR
	| BOOL
	| INT8_T
	| INT16_T
	| INT32_T
	| INT64_T
	| UINT8_T
	| UINT16_T
	| UINT32_T
	| UINT64_T
	| INTMAX_T
	| INTPTR_T
	| UINTMAX_T
	| UINTPTR_T
	| SIGNED integer_base_type
	| UNSIGNED integer_base_type
	| SIZE_T
	| PTRDIFF_T
	;

floating_type :
	FLOAT
	| DOUBLE
	| LONG_DOUBLE
	;

basic_type :
	integer_type
	| floating_type
	;

ctype :
	VOID
	| basic_type
	| ctype LBRACKET option_INT_CONST_ RBRACKET
	| ctype LPAREN params RPAREN
	| CONST ctype STAR
	| ctype STAR
	| ATOMIC LPAREN ctype RPAREN
	| SYM
	| STRUCT SYM
	| UNION SYM
	;

params :
	loption_separated_nonempty_list_COMMA_ctype__
	| loption_separated_nonempty_list_COMMA_ctype__ COMMA DOTS
	;

core_object_type :
	INTEGER
	| FLOATING
	| POINTER
	| ARRAY LPAREN core_object_type RPAREN
	| STRUCT SYM
	| UNION SYM
	;

core_base_type :
	UNIT
	| BOOLEAN
	| CTYPE
	| LBRACKET core_base_type RBRACKET
	| LPAREN loption_separated_nonempty_list_COMMA_core_base_type__ RPAREN
	| core_object_type
	| LOADED core_object_type
	| STORABLE
	;

core_type :
	core_base_type
	| EFF core_base_type
	;

name :
	SYM
	| IMPL
	;

cabs_id :
	SYM
	;

memory_order :
	SEQ_CST
	| RELAXED
	| RELEASE
	| ACQUIRE
	| CONSUME
	| ACQ_REL
	;

ctor :
	ARRAYCTOR
	| IVMAX
	| IVMIN
	| IVSIZEOF
	| IVALIGNOF
	| SPECIFIED
	| UNSPECIFIED
	| FVFROMINT
	| IVFROMFLOAT
	| IVCOMPL
	| IVAND
	| IVOR
	| IVXOR
	;

list_pattern :
	BRACKETS COLON core_base_type
	| pattern COLON_COLON pattern
	| LBRACKET loption_separated_nonempty_list_COMMA_pattern__ RBRACKET COLON core_base_type
	;

pattern :
	SYM COLON core_base_type
	| UNDERSCORE COLON core_base_type
	| list_pattern
	| LPAREN pattern COMMA separated_nonempty_list_COMMA_pattern_ RPAREN
	| ctor LPAREN loption_separated_nonempty_list_COMMA_pattern__ RPAREN
	;

pattern_pair_expr_ :
	PIPE pattern EQ_GT expr
	;

pattern_pair_pexpr_ :
	PIPE pattern EQ_GT pexpr
	;

core_ctype :
	SQUOTE ctype SQUOTE
	;

core_integer_type :
	SQUOTE integer_type SQUOTE
	;

value :
	INT_CONST
	| IVMAX_ALIGNMENT
	| NULL LPAREN ctype RPAREN
	| CFUNCTION_VALUE LPAREN name RPAREN
	| UNIT_VALUE
	| TRUE
	| FALSE
	| core_ctype
	;

list_pexpr :
	BRACKETS COLON core_base_type
	| pexpr COLON_COLON pexpr
	| LBRACKET loption_separated_nonempty_list_COMMA_pexpr__ RBRACKET COLON core_base_type
	;

member :
	DOT cabs_id EQ pexpr
	;

pexpr :
	LPAREN pexpr RPAREN
	| UNDEF LPAREN UB RPAREN
	| ERROR LPAREN STRING COMMA pexpr RPAREN
	| value
	| SYM
	| IMPL
	| LPAREN pexpr COMMA separated_nonempty_list_COMMA_pexpr_ RPAREN
	| list_pexpr
	| ctor LPAREN loption_separated_nonempty_list_COMMA_pexpr__ RPAREN
	| CASE pexpr OF list_pattern_pair_pexpr__ END
	| ARRAY_SHIFT LPAREN pexpr COMMA core_ctype COMMA pexpr RPAREN
	| MEMBER_SHIFT LPAREN pexpr COMMA SYM COMMA DOT cabs_id RPAREN
	| NOT LPAREN pexpr RPAREN
	| MINUS pexpr
	| CFUNCTION LPAREN pexpr RPAREN
	| pexpr PLUS pexpr
	| pexpr MINUS pexpr
	| pexpr STAR pexpr
	| pexpr SLASH pexpr
	| pexpr REM_T pexpr
	| pexpr REM_F pexpr
	| pexpr CARET pexpr
	| pexpr EQ pexpr
	| pexpr GT pexpr
	| pexpr LT pexpr
	| pexpr GE pexpr
	| pexpr LE pexpr
	| pexpr SLASH_BACKSLASH pexpr
	| pexpr BACKSLASH_SLASH pexpr
	| CONV_INT LPAREN core_integer_type COMMA pexpr RPAREN
	| WRAPI LPAREN core_integer_type COMMA pexpr COMMA pexpr RPAREN
	| CATCH_EXCEPTIONAL_CONDITION LPAREN core_integer_type COMMA pexpr COMMA pexpr RPAREN
	| MEMOP LPAREN PURE_MEMOP_OP COMMA loption_separated_nonempty_list_COMMA_pexpr__ RPAREN
	| LPAREN STRUCT SYM RPAREN LBRACE loption_separated_nonempty_list_COMMA_member__ RBRACE
	| LPAREN UNION SYM RPAREN LBRACE member RBRACE
	| name LPAREN loption_separated_nonempty_list_COMMA_pexpr__ RPAREN
	| LET pattern EQ pexpr IN pexpr
	| IF pexpr THEN pexpr ELSE pexpr
	| IS_SCALAR LPAREN pexpr RPAREN
	| IS_INTEGER LPAREN pexpr RPAREN
	| IS_SIGNED LPAREN pexpr RPAREN
	| IS_UNSIGNED LPAREN pexpr RPAREN
	| ARE_COMPATIBLE LPAREN pexpr COMMA pexpr RPAREN
	| BRACKETS
	;

memop_op :
	MEMOP_OP
	| PTRMEMBERSHIFT LBRACKET SYM COMMA DOT cabs_id RBRACKET
	;

expr :
	LPAREN expr RPAREN
	| PURE LPAREN pexpr RPAREN
	| MEMOP LPAREN memop_op COMMA loption_separated_nonempty_list_COMMA_pexpr__ RPAREN
	| LET pattern EQ pexpr IN expr
	| IF pexpr THEN expr ELSE expr
	| CASE pexpr OF list_pattern_pair_expr__ END
	| PCALL LPAREN name RPAREN
	| PCALL LPAREN name COMMA separated_nonempty_list_COMMA_pexpr_ RPAREN
	| CCALL LPAREN pexpr COMMA pexpr RPAREN
	| CCALL LPAREN pexpr COMMA pexpr COMMA separated_nonempty_list_COMMA_pexpr_ RPAREN
	| paction
	| UNSEQ LPAREN loption_separated_nonempty_list_COMMA_expr__ RPAREN
	| LET WEAK pattern EQ expr IN expr
	| expr SEMICOLON expr
	| LET STRONG pattern EQ expr IN expr
	| BOUND LPAREN expr RPAREN
	| SAVE SYM COLON core_base_type LPAREN loption_separated_nonempty_list_COMMA_separated_pair_SYM_COLON_separated_pair_core_base_type_COLON_EQ_pexpr____ RPAREN IN expr
	| RUN SYM LPAREN loption_separated_nonempty_list_COMMA_pexpr__ RPAREN
	| ND LPAREN loption_separated_nonempty_list_COMMA_expr__ RPAREN
	| PAR LPAREN loption_separated_nonempty_list_COMMA_expr__ RPAREN
	;

action :
	CREATE LPAREN pexpr COMMA pexpr RPAREN
	| CREATE_READONLY LPAREN pexpr COMMA pexpr COMMA pexpr RPAREN
	| ALLOC LPAREN pexpr COMMA pexpr RPAREN
	| FREE LPAREN pexpr RPAREN
	| KILL LPAREN core_ctype COMMA pexpr RPAREN
	| STORE LPAREN pexpr COMMA pexpr COMMA pexpr RPAREN
	| STORE_LOCK LPAREN pexpr COMMA pexpr COMMA pexpr RPAREN
	| LOAD LPAREN pexpr COMMA pexpr RPAREN
	| STORE LPAREN pexpr COMMA pexpr COMMA pexpr COMMA memory_order RPAREN
	| STORE_LOCK LPAREN pexpr COMMA pexpr COMMA pexpr COMMA memory_order RPAREN
	| LOAD LPAREN pexpr COMMA pexpr COMMA memory_order RPAREN
	| SEQ_RMW LPAREN pexpr COMMA pexpr COMMA SYM EQ_GT pexpr RPAREN
	| SEQ_RMW_WITH_FORWARD LPAREN pexpr COMMA pexpr COMMA SYM EQ_GT pexpr RPAREN
	| RMW LPAREN pexpr COMMA pexpr COMMA pexpr COMMA pexpr COMMA memory_order COMMA memory_order RPAREN
	| FENCE LPAREN memory_order RPAREN
	| SKIP
	;

paction :
	action
	| NEG LPAREN action RPAREN
	;

def_declaration :
	DEF IMPL COLON core_base_type COLON_EQ pexpr
	;

def_field :
	cabs_id COLON core_ctype
	;

def_fields :
	def_field
	| def_fields def_field
	;

def_aggregate_declaration :
	DEF STRUCT SYM COLON_EQ def_fields
	| DEF UNION SYM COLON_EQ def_fields
	;

ifun_declaration :
	FUN IMPL LPAREN loption_separated_nonempty_list_COMMA_separated_pair_SYM_COLON_core_base_type___ RPAREN COLON core_base_type COLON_EQ pexpr
	;

glob_ctype_attribute :
	LBRACKET AILCTYPE EQ core_ctype RBRACKET
	;

glob_declaration :
	GLOB SYM COLON core_type glob_ctype_attribute COLON_EQ expr
	;

fun_declaration :
	FUN SYM LPAREN loption_separated_nonempty_list_COMMA_separated_pair_SYM_COLON_core_base_type___ RPAREN COLON core_base_type COLON_EQ pexpr
	;

proc_declaration :
	PROC option_attribute_ SYM LPAREN loption_separated_nonempty_list_COMMA_separated_pair_SYM_COLON_core_base_type___ RPAREN COLON EFF core_base_type COLON_EQ expr
	;

builtin_declaration :
	BUILTIN SYM LPAREN loption_separated_nonempty_list_COMMA_core_base_type__ RPAREN COLON EFF core_base_type
	;

declaration :
	def_declaration
	| ifun_declaration
	| glob_declaration
	| fun_declaration
	| proc_declaration
	| builtin_declaration
	| def_aggregate_declaration
	;

option_INT_CONST_ :
    %empty
	| INT_CONST
	;

option_attribute_ :
    %empty
	| attribute
	;

loption_separated_nonempty_list_COMMA_attribute_pair__ :
    %empty
	| separated_nonempty_list_COMMA_attribute_pair_
	;

loption_separated_nonempty_list_COMMA_core_base_type__ :
    %empty
	| separated_nonempty_list_COMMA_core_base_type_
	;

loption_separated_nonempty_list_COMMA_ctype__ :
    %empty
	| separated_nonempty_list_COMMA_ctype_
	;

loption_separated_nonempty_list_COMMA_expr__ :
    %empty
	| separated_nonempty_list_COMMA_expr_
	;

loption_separated_nonempty_list_COMMA_member__ :
    %empty
	| separated_nonempty_list_COMMA_member_
	;

loption_separated_nonempty_list_COMMA_pattern__ :
    %empty
	| separated_nonempty_list_COMMA_pattern_
	;

loption_separated_nonempty_list_COMMA_pexpr__ :
    %empty
	| separated_nonempty_list_COMMA_pexpr_
	;

loption_separated_nonempty_list_COMMA_separated_pair_SYM_COLON_core_base_type___ :
    %empty
	| separated_nonempty_list_COMMA_separated_pair_SYM_COLON_core_base_type__
	;

loption_separated_nonempty_list_COMMA_separated_pair_SYM_COLON_separated_pair_core_base_type_COLON_EQ_pexpr____ :
    %empty
	| separated_nonempty_list_COMMA_separated_pair_SYM_COLON_separated_pair_core_base_type_COLON_EQ_pexpr___
	;

list_pattern_pair_expr__ :
    %empty
	| pattern_pair_expr_ list_pattern_pair_expr__
	;

list_pattern_pair_pexpr__ :
    %empty
	| pattern_pair_pexpr_ list_pattern_pair_pexpr__
	;

nonempty_list_declaration_ :
	declaration
	| nonempty_list_declaration_ declaration
	;

separated_nonempty_list_COMMA_attribute_pair_ :
	attribute_pair
	| separated_nonempty_list_COMMA_attribute_pair_ COMMA attribute_pair
	;

separated_nonempty_list_COMMA_core_base_type_ :
	core_base_type
	| separated_nonempty_list_COMMA_core_base_type_ COMMA core_base_type
	;

separated_nonempty_list_COMMA_ctype_ :
	ctype
	| separated_nonempty_list_COMMA_ctype_ COMMA ctype
	;

separated_nonempty_list_COMMA_expr_ :
	expr
	| separated_nonempty_list_COMMA_expr_ COMMA expr
	;

separated_nonempty_list_COMMA_member_ :
	member
	| separated_nonempty_list_COMMA_member_ COMMA member
	;

separated_nonempty_list_COMMA_pattern_ :
	pattern
	| separated_nonempty_list_COMMA_pattern_ COMMA pattern
	;

separated_nonempty_list_COMMA_pexpr_ :
	pexpr
	| separated_nonempty_list_COMMA_pexpr_ COMMA pexpr
	;

separated_nonempty_list_COMMA_separated_pair_SYM_COLON_core_base_type__ :
	SYM COLON core_base_type
	| separated_nonempty_list_COMMA_separated_pair_SYM_COLON_core_base_type__ COMMA SYM COLON core_base_type
	;

separated_nonempty_list_COMMA_separated_pair_SYM_COLON_separated_pair_core_base_type_COLON_EQ_pexpr___ :
	SYM COLON core_base_type COLON_EQ pexpr
	| separated_nonempty_list_COMMA_separated_pair_SYM_COLON_separated_pair_core_base_type_COLON_EQ_pexpr___ COMMA SYM COLON core_base_type COLON_EQ pexpr
	;

%%

%x LCOMMENT

%%

[ \t\r\n]+	skip()
"--".*	skip()
"{-"<>LCOMMENT>
<LCOMMENT>{
    "{-"<>LCOMMENT>
    "-}"<<> skip()
    .|\n<.>
}

"\\/"	BACKSLASH_SLASH
"[]"	BRACKETS
"^"	CARET
":"	COLON
"::"	COLON_COLON
":="	COLON_EQ
","	COMMA
"."	DOT
"..."	DOTS
//EOF	EOF
"="	EQ
"=>"	EQ_GT
">="	GE
">"	GT
"{"	LBRACE
"["	LBRACKET
"<="	LE
"("	LPAREN
"<"	LT
"-"	MINUS
"neg"	NEG
"|"	PIPE
"+"	PLUS
PURE_MEMOP_OP	PURE_MEMOP_OP
"}"	RBRACE
"]"	RBRACKET
"rem_f"	REM_F
"rem_t"	REM_T
")"	RPAREN
";"	SEMICOLON
"/"	SLASH
"/\\"	SLASH_BACKSLASH
"'"	SQUOTE
"*"	STAR
"_"	UNDERSCORE

/* for Core ctypes */
"const"       CONST
"_Atomic"     ATOMIC
"_Bool"       BOOL
"char"        CHAR
"double"      DOUBLE
/* "enum"        ENUM       */
"float"       FLOAT
"int"         INT
"ichar"       ICHAR
"long"        LONG
"long_double" LONG_DOUBLE
"long_long"   LONG_LONG
"short"       SHORT
"signed"      SIGNED
"struct"      STRUCT
"union"       UNION
"unsigned"    UNSIGNED
"void"        VOID
"int8_t"      INT8_T
"int16_t"     INT16_T
"int32_t"     INT32_T
"int64_t"     INT64_T
"uint8_t"     UINT8_T
"uint16_t"    UINT16_T
"uint32_t"    UINT32_T
"uint64_t"    UINT64_T
"intptr_t"    INTPTR_T
"intmax_t"    INTMAX_T
"uintptr_t"   UINTPTR_T
"uintmax_t"   UINTMAX_T
"size_t"      SIZE_T
"ptrdiff_t"   PTRDIFF_T

/* for Core object types */
"integer"   INTEGER
"floating"  FLOATING
"pointer"   POINTER
"array"     ARRAY
"cfunction" CFUNCTION

/* for Core base types */
"unit"     UNIT
"boolean"  BOOLEAN
"ctype"    CTYPE
"loaded"   LOADED
"storable" STORABLE

/* for Core types */
"eff" EFF

/* for Core values */
"NULL"        NULL
"Unit"        UNIT_VALUE
"True"        TRUE
"False"       FALSE
"Ivmax"       IVMAX
"Ivmin"       IVMIN
"Ivsizeof"    IVSIZEOF
"Ivalignof"   IVALIGNOF
"IvCOMPL"     IVCOMPL
"IvAND"       IVAND
"IvOR"        IVOR
"IvXOR"       IVXOR
"Specified"   SPECIFIED
"Unspecified" UNSPECIFIED
"Cfunction"   CFUNCTION_VALUE
"Array"       ARRAYCTOR

"Fvfromint"   FVFROMINT
"Ivfromfloat" IVFROMFLOAT

/* this is a fake constructor at the syntax level */
/* NOTE: it would be better to pass to the Core parser an env with the C types symbols (to resolve max_align_t) */
"IvMaxAlignment" IVMAX_ALIGNMENT

/* for Core (pure) expressions */
"not"          NOT
"undef"        UNDEF
"error"        ERROR
"let"          LET
"in"           IN
"if"           IF
"then"         THEN
"else"         ELSE
"pure"         PURE
"unseq"        UNSEQ
"weak"         WEAK
"strong"       STRONG
"save"         SAVE
"run"          RUN
"bound"        BOUND
"nd"           ND
"par"          PAR
"array_shift"  ARRAY_SHIFT
"member_shift" MEMBER_SHIFT
"case"         CASE
"of"           OF
"end"          END
"pcall"        PCALL
"ccall"        CCALL
"memop"        MEMOP

/* Core (pure) builtins for bounded intger arithmetic */
"__conv_int__" CONV_INT
"wrapI_add" WRAPI
"wrapI_sub" WRAPI
"wrapI_mul" WRAPI
"wrapI_shl" WRAPI
"wrapI_shr" WRAPI
"catch_exceptional_condition_add" CATCH_EXCEPTIONAL_CONDITION
"catch_exceptional_condition_sub" CATCH_EXCEPTIONAL_CONDITION
"catch_exceptional_condition_mul" CATCH_EXCEPTIONAL_CONDITION
"catch_exceptional_condition_shl" CATCH_EXCEPTIONAL_CONDITION
"catch_exceptional_condition_shr" CATCH_EXCEPTIONAL_CONDITION

/* for Core.action_ */
"create" CREATE
"create_readonly" CREATE_READONLY
"alloc"  ALLOC
"free"   FREE
"kill"   KILL
"store"  STORE
"store_lock"  STORE_LOCK
"load"   LOAD
"seq_rmw"   SEQ_RMW
"seq_rmw_with_forward"   SEQ_RMW_WITH_FORWARD
"rmw"    RMW
"fence"  FENCE
/*      "compare_exchange_strong"  COMPARE_EXCHANGE_STRONG */

/* for toplevel declarations */
"def"  DEF /* for implementation files only */
"glob" GLOB
"fun"  FUN
"proc" PROC

/* for C11 memory orders */
"seq_cst" SEQ_CST
"relaxed" RELAXED
"release" RELEASE
"acquire" ACQUIRE
"consume" CONSUME
"acq_rel" ACQ_REL

/* TODO: temporary */
"is_scalar"   IS_SCALAR
"is_integer"  IS_INTEGER
"is_signed"   IS_SIGNED
"is_unsigned" IS_UNSIGNED
"are_compatible" ARE_COMPATIBLE

/* for Memory operations */
"PtrEq"            MEMOP_OP
"PtrNe"            MEMOP_OP
"PtrLt"            MEMOP_OP
"PtrGt"            MEMOP_OP
"PtrLe"            MEMOP_OP
"PtrGe"            MEMOP_OP
"Ptrdiff"          MEMOP_OP
"IntFromPtr"       MEMOP_OP
"PtrFromInt"       MEMOP_OP
"PtrValidForDeref" MEMOP_OP
"PtrWellAligned"   MEMOP_OP
"PtrArrayShift"    MEMOP_OP
"PtrMemberShift"   PTRMEMBERSHIFT

"Memcpy"        MEMOP_OP
"Memcmp"        MEMOP_OP
"Realloc"       MEMOP_OP
"Va_start"      MEMOP_OP
"Va_copy"       MEMOP_OP
"Va_arg"        MEMOP_OP
"Va_end"        MEMOP_OP
"Copy_alloc_id" MEMOP_OP

/* for source attributes */
"ailname" AILNAME

"ail_ctype" AILCTYPE

/* for core builtins */
"builtin" BUILTIN

"skip"    SKIP //missing ?

[0-9]+	INT_CONST
\"(\\.|[^"\r\n\\])*\"	CSTRING

"<"[A-Za-z_.0-9]*">"	IMPL
"<<<"[A-Za-z_0-9]*">>>"	STRING
"<<"([A-Za-z_0-9]*|"DUMMY("[A-Za-z_ .:\-=<>0-9()]*")")">>"	UB
[A-Za-z_][A-Za-z0-9_]*	SYM

%%
