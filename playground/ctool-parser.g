 //From: https://ctool.sourceforge.net/
 /*
 ======================================================================

    CTool Library
    Copyright (C) 1995-2001	Shaun Flisakowski

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 1, or (at your option)
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

 ======================================================================
 */

/* grammar File for C - Shaun Flisakowski and Patrick Baudin */
/* Grammar was constructed with the assistance of:
    "C - A Reference Manual" (Fourth Edition),
    by Samuel P Harbison, and Guy L Steele Jr. */

/*Tokens*/
%token ALIGNED
%token AND
%token ARROW
%token ASSIGN
//%token AT
%token ATTRIBUTE
%token AUTO
//%token BACKQUOTE
%token B_AND
//%token B_AND_EQ
%token B_NOT
%token BOOL
%token B_OR
//%token B_OR_EQ
%token BREAK
%token B_XOR
//%token B_XOR_EQ
%token CASE
%token CDECL
%token CHAR
%token CHAR_CONST
%token COLON
%token COMMA
%token COMP_ARITH
%token COMP_EQ
%token CONST
%token CONT
%token DECR
%token DEFLT
%token DIV
//%token DIV_EQ
%token DO
%token DOT
//%token DOUB_LB_SIGN
%token DOUBLE
%token ELLIPSIS
%token ELSE
%token ENUM
%token EQ
//%token EQUAL
%token EXTRN
%token FLOAT
%token FOR
%token FORMAT
%token GOTO
//%token GRTR
//%token GRTR_EQ
//%token HYPERUNARY
%token IDENT
%token IF
%token INCR
%token INT
%token INT16
%token INT32
%token INT64
%token INT8
%token INUM
//%token INVALID
%token LABEL_NAME
%token LBRACE
%token LBRCKT
//%token LB_SIGN
%token LCHAR_CONST
%token LESS
%token LESS_EQ
%token LONG
%token LPAREN
%token L_SHIFT
//%token L_SHIFT_EQ
%token LSTRING
%token MALLOC
%token MINUS
//%token MINUS_EQ
%token MOD
%token MODE
//%token MOD_EQ
%token NORETURN
%token NOT
%token NOT_EQ
%token OR
%token PACKED
%token PLUS
//%token PLUS_EQ
%token PP_LINE
%token QUESTMARK
%token RBRACE
%token RBRCKT
%token REGISTR
%token RETURN
%token RNUM
%token RPAREN
%token R_SHIFT
//%token R_SHIFT_EQ
%token SEMICOLON
%token SGNED
%token SHORT
%token SIZEOF
%token STAR
//%token STAR_EQ
%token STATIC
%token STRING
%token STRUCT
%token SWITCH
%token TAG_NAME
%token TYPEDEF
%token TYPEDEF_NAME
%token UNARY
%token UNION
%token UNSGNED
%token VOID
%token VOLATILE
%token WHILE

//%fallback IDENT LABEL_NAME

%nonassoc /*1*/ IF
%nonassoc /*2*/ ELSE
%left /*3*/ COMMA_OP
%right /*4*/ EQ ASSIGN
%right /*5*/ QUESTMARK COLON COMMA_SEP
%left /*6*/ OR
%left /*7*/ AND
%left /*8*/ B_OR
%left /*9*/ B_XOR
%left /*10*/ B_AND
%left /*11*/ COMP_EQ
%left /*12*/ COMP_ARITH LESS GRTR
%left /*13*/ L_SHIFT R_SHIFT
%left /*14*/ PLUS MINUS
%left /*15*/ STAR DIV MOD
%right /*16*/ CAST
%right /*17*/ UNARY NOT B_NOT SIZEOF INCR DECR
%left /*18*/ HYPERUNARY
%left /*19*/ ARROW DOT LPAREN LBRCKT

%start program

%%

program :
	/*empty*/
	| trans_unit
	//| error
	;

trans_unit :
	top_level_decl top_level_exit
	| trans_unit top_level_decl top_level_exit
	;

top_level_exit :
	/*empty*/
	;

top_level_decl :
	decl_stemnt
	| func_def
	| PP_LINE
	//| error SEMICOLON
	//| error RBRACE top_level_exit
	;

func_def :
	func_spec cmpnd_stemnt
	;

func_spec :
	decl_specs func_declarator opt_KnR_declaration_list
	| no_decl_specs declarator opt_KnR_declaration_list
	;

cmpnd_stemnt :
	LBRACE opt_declaration_list opt_stemnt_list RBRACE
	//| error RBRACE
	;

opt_stemnt_list :
	/*empty*/
	| stemnt_list
	;

stemnt_list :
	stemnt
	| stemnt_list stemnt
	| stemnt_list PP_LINE
	;

stemnt :
	stemnt_reentrance
	;

cmpnd_stemnt_reentrance :
	LBRACE opt_declaration_list opt_stemnt_list_reentrance RBRACE
	//| error RBRACE
	;

opt_stemnt_list_reentrance :
	/*empty*/
	| stemnt_list_reentrance
	;

stemnt_list_reentrance :
	stemnt_reentrance
	| stemnt_list_reentrance stemnt_reentrance
	| stemnt_list_reentrance PP_LINE
	;

stemnt_reentrance :
	expr_stemnt
	| labeled_stemnt
	| cmpnd_stemnt_reentrance
	| cond_stemnt
	| iter_stemnt
	| switch_stemnt
	| break_stemnt
	| continue_stemnt
	| return_stemnt
	| goto_stemnt
	| null_stemnt
	//| error SEMICOLON
	;

expr_stemnt :
	expr SEMICOLON
	;

labeled_stemnt :
	label COLON /*5R*/ stemnt_reentrance
	;

cond_stemnt :
	if_stemnt
	| if_else_stemnt
	;

iter_stemnt :
	do_stemnt
	| while_stemnt
	| for_stemnt
	;

switch_stemnt :
	SWITCH LPAREN /*19L*/ expr RPAREN stemnt_reentrance
	;

break_stemnt :
	BREAK SEMICOLON
	;

continue_stemnt :
	CONT SEMICOLON
	;

return_stemnt :
	RETURN opt_expr SEMICOLON
	;

goto_stemnt :
	GOTO IDENT /*LABEL_NAME*/ SEMICOLON
	;

null_stemnt :
	SEMICOLON
	;

if_stemnt :
	IF /*1N*/ LPAREN /*19L*/ expr RPAREN stemnt_reentrance %prec IF /*1N*/
	;

if_else_stemnt :
	IF /*1N*/ LPAREN /*19L*/ expr RPAREN stemnt_reentrance ELSE /*2N*/ stemnt_reentrance
	;

do_stemnt :
	DO stemnt_reentrance WHILE LPAREN /*19L*/ expr RPAREN SEMICOLON
	;

while_stemnt :
	WHILE LPAREN /*19L*/ expr RPAREN stemnt_reentrance
	;

for_stemnt :
	FOR LPAREN /*19L*/ opt_expr SEMICOLON opt_expr SEMICOLON opt_expr RPAREN stemnt_reentrance
	;

label :
	named_label
	| case_label
	| deflt_label
	;

named_label :
	ident
	;

case_label :
	CASE const_expr
	| CASE const_expr ELLIPSIS const_expr
	;

deflt_label :
	DEFLT
	;

cond_expr :
	log_or_expr
	| log_or_expr QUESTMARK /*5R*/ expr COLON /*5R*/ cond_expr
	;

assign_expr :
	cond_expr
	| unary_expr assign_op assign_expr
	;

opt_const_expr :
	/*empty*/
	| const_expr
	;

const_expr :
	expr
	;

opt_expr :
	/*empty*/
	| expr
	;

expr :
	comma_expr
	;

log_or_expr :
	log_and_expr
	| log_or_expr OR /*6L*/ log_and_expr
	;

log_and_expr :
	bitwise_or_expr
	| log_and_expr AND /*7L*/ bitwise_or_expr
	;

log_neg_expr :
	NOT /*17R*/ cast_expr
	;

bitwise_or_expr :
	bitwise_xor_expr
	| bitwise_or_expr B_OR /*8L*/ bitwise_xor_expr
	;

bitwise_xor_expr :
	bitwise_and_expr
	| bitwise_xor_expr B_XOR /*9L*/ bitwise_and_expr
	;

bitwise_and_expr :
	equality_expr
	| bitwise_and_expr B_AND /*10L*/ equality_expr
	;

bitwise_neg_expr :
	B_NOT /*17R*/ cast_expr
	;

cast_expr :
	unary_expr
	| LPAREN /*19L*/ type_name RPAREN cast_expr %prec CAST /*16R*/
	;

equality_expr :
	relational_expr
	| equality_expr equality_op relational_expr
	;

relational_expr :
	shift_expr
	| relational_expr relation_op shift_expr
	;

shift_expr :
	additive_expr
	| shift_expr shift_op additive_expr
	;

additive_expr :
	mult_expr
	| additive_expr add_op mult_expr
	;

mult_expr :
	cast_expr
	| mult_expr mult_op cast_expr
	;

unary_expr :
	postfix_expr
	| sizeof_expr
	| unary_minus_expr
	| unary_plus_expr
	| log_neg_expr
	| bitwise_neg_expr
	| addr_expr
	| indirection_expr
	| preinc_expr
	| predec_expr
	;

sizeof_expr :
	SIZEOF /*17R*/ LPAREN /*19L*/ type_name RPAREN %prec HYPERUNARY /*18L*/
	| SIZEOF /*17R*/ unary_expr
	;

unary_minus_expr :
	MINUS /*14L*/ cast_expr %prec UNARY /*17R*/
	;

unary_plus_expr :
	PLUS /*14L*/ cast_expr %prec UNARY /*17R*/
	;

addr_expr :
	B_AND /*10L*/ cast_expr %prec UNARY /*17R*/
	;

indirection_expr :
	STAR /*15L*/ cast_expr %prec UNARY /*17R*/
	;

preinc_expr :
	INCR /*17R*/ unary_expr
	;

predec_expr :
	DECR /*17R*/ unary_expr
	;

comma_expr :
	assign_expr
	| comma_expr COMMA assign_expr %prec COMMA_OP /*3L*/
	;

prim_expr :
	ident
	| paren_expr
	| constant
	;

paren_expr :
	LPAREN /*19L*/ expr RPAREN
	//| LPAREN /*19L*/ error RPAREN
	;

postfix_expr :
	prim_expr
	| subscript_expr
	| comp_select_expr
	| func_call
	| postinc_expr
	| postdec_expr
	;

subscript_expr :
	postfix_expr LBRCKT /*19L*/ expr RBRCKT
	;

comp_select_expr :
	direct_comp_select
	| indirect_comp_select
	;

postinc_expr :
	postfix_expr INCR /*17R*/
	;

postdec_expr :
	postfix_expr DECR /*17R*/
	;

field_ident :
	any_ident
	;

direct_comp_select :
	postfix_expr DOT /*19L*/ field_ident
	;

indirect_comp_select :
	postfix_expr ARROW /*19L*/ field_ident
	;

func_call :
	postfix_expr LPAREN /*19L*/ opt_expr_list RPAREN
	;

opt_expr_list :
	/*empty*/
	| expr_list
	;

expr_list :
	assign_expr
	| expr_list COMMA assign_expr %prec COMMA_SEP /*5R*/
	;

add_op :
	PLUS /*14L*/
	| MINUS /*14L*/
	;

mult_op :
	STAR /*15L*/
	| DIV /*15L*/
	| MOD /*15L*/
	;

equality_op :
	COMP_EQ /*11L*/
	;

relation_op :
	COMP_ARITH /*12L*/
	;

shift_op :
	L_SHIFT /*13L*/
	| R_SHIFT /*13L*/
	;

assign_op :
	EQ /*4R*/
	| ASSIGN /*4R*/
	;

constant :
	INUM
	| RNUM
	| CHAR_CONST
	| LCHAR_CONST
	| STRING
	| LSTRING
	;

opt_KnR_declaration_list :
	/*empty*/
	| declaration_list
	;

opt_declaration_list :
	/*empty*/
	| declaration_list
	;

declaration_list :
	declaration SEMICOLON
	| declaration SEMICOLON declaration_list
	;

decl_stemnt :
	old_style_declaration SEMICOLON
	| declaration SEMICOLON
	;

old_style_declaration :
	no_decl_specs opt_init_decl_list
	;

declaration :
	decl_specs opt_init_decl_list
	;

no_decl_specs :
	/*empty*/
	;

decl_specs :
	decl_specs_reentrance_bis
	;

abs_decl :
	abs_decl_reentrance
	;

type_name :
	type_name_bis
	;

type_name_bis :
	decl_specs_reentrance_bis
	| decl_specs_reentrance_bis abs_decl
	;

decl_specs_reentrance_bis :
	decl_specs_reentrance
	;

local_or_global_storage_class :
	EXTRN
	| STATIC
	| TYPEDEF
	;

local_storage_class :
	AUTO
	| REGISTR
	;

storage_class :
	local_or_global_storage_class
	| local_storage_class
	;

type_spec :
	type_spec_reentrance
	;

opt_decl_specs_reentrance :
	/*empty*/
	| decl_specs_reentrance
	;

decl_specs_reentrance :
	storage_class opt_decl_specs_reentrance
	| type_spec opt_decl_specs_reentrance
	| type_qual opt_decl_specs_reentrance
	;

opt_comp_decl_specs :
	/*empty*/
	| comp_decl_specs_reentrance
	;

comp_decl_specs_reentrance :
	type_spec_reentrance opt_comp_decl_specs
	| type_qual opt_comp_decl_specs
	;

comp_decl_specs :
	comp_decl_specs_reentrance
	;

decl :
	declarator opt_gcc_attrib
	;

init_decl :
	decl
	| decl EQ /*4R*/ initializer
	;

opt_init_decl_list :
	/*empty*/
	| init_decl_list
	;

init_decl_list :
	init_decl_list_reentrance
	;

init_decl_list_reentrance :
	init_decl
	| init_decl_list_reentrance COMMA init_decl %prec COMMA_OP /*3L*/
	;

initializer :
	initializer_reentrance
	;

initializer_list :
	initializer_reentrance
	| initializer_list COMMA initializer_reentrance %prec COMMA_OP /*3L*/
	;

initializer_reentrance :
	assign_expr
	| LBRACE initializer_list opt_comma RBRACE
	;

opt_comma :
	/*empty*/
	| COMMA %prec COMMA_SEP /*5R*/
	;

type_qual :
	type_qual_token
	;

type_qual_token :
	CONST
	| VOLATILE
	;

type_qual_list :
	type_qual_token
	| type_qual_list type_qual_token
	;

opt_type_qual_list :
	/*empty*/
	| type_qual_list
	;

type_spec_reentrance :
	enum_type_define
	| struct_type_define
	| union_type_define
	| enum_tag_ref
	| struct_tag_ref
	| union_tag_ref
	| typedef_name
	| VOID
	| BOOL
	| CHAR
	| SHORT
	| INT
	| INT8
	| INT16
	| INT32
	| INT64
	| LONG
	| FLOAT
	| DOUBLE
	| SGNED
	| UNSGNED
	;

typedef_name :
	TYPEDEF_NAME
	;

tag_ref :
	TAG_NAME
	;

struct_tag_ref :
	STRUCT tag_ref
	;

union_tag_ref :
	UNION tag_ref
	;

enum_tag_ref :
	ENUM tag_ref
	;

struct_tag_def :
	STRUCT tag_ref
	;

struct_type_define :
	STRUCT LBRACE struct_or_union_definition RBRACE
	| struct_tag_def LBRACE struct_or_union_definition RBRACE
	;

union_tag_def :
	UNION tag_ref
	;

union_type_define :
	UNION LBRACE struct_or_union_definition RBRACE
	| union_tag_def LBRACE struct_or_union_definition RBRACE
	;

enum_tag_def :
	ENUM tag_ref
	;

enum_type_define :
	ENUM LBRACE enum_definition RBRACE
	| enum_tag_def LBRACE enum_definition RBRACE
	;

struct_or_union_definition :
	/*empty*/
	| field_list
	;

enum_definition :
	/*empty*/
	| enum_def_list opt_trailing_comma
	;

opt_trailing_comma :
	/*empty*/
	| COMMA %prec COMMA_SEP /*5R*/
	;

enum_def_list :
	enum_def_list_reentrance
	;

enum_def_list_reentrance :
	enum_const_def
	| enum_def_list COMMA enum_const_def %prec COMMA_OP /*3L*/
	;

enum_const_def :
	enum_constant
	| enum_constant EQ /*4R*/ assign_expr
	;

enum_constant :
	any_ident
	;

field_list :
	field_list_reentrance
	;

field_list_reentrance :
	comp_decl SEMICOLON
	| field_list_reentrance SEMICOLON
	| field_list_reentrance comp_decl SEMICOLON
	;

comp_decl :
	comp_decl_specs comp_decl_list
	| comp_decl_specs
	;

comp_decl_list :
	comp_decl_list_reentrance
	;

comp_decl_list_reentrance :
	comp_declarator opt_gcc_attrib
	| comp_decl_list_reentrance COMMA comp_declarator opt_gcc_attrib %prec COMMA_OP /*3L*/
	;

comp_declarator :
	simple_comp
	| bit_field
	;

simple_comp :
	declarator
	;

bit_field :
	opt_declarator COLON /*5R*/ width
	;

width :
	cond_expr
	;

opt_declarator :
	/*empty*/
	| declarator
	;

declarator :
	declarator_reentrance_bis
	;

func_declarator :
	declarator_reentrance_bis
	;

declarator_reentrance_bis :
	pointer direct_declarator_reentrance_bis
	| direct_declarator_reentrance_bis
	;

direct_declarator_reentrance_bis :
	direct_declarator_reentrance
	;

direct_declarator_reentrance :
	ident
	| LPAREN /*19L*/ declarator_reentrance_bis RPAREN
	| array_decl
	| direct_declarator_reentrance LPAREN /*19L*/ param_type_list RPAREN
	| direct_declarator_reentrance LPAREN /*19L*/ ident_list RPAREN
	| direct_declarator_reentrance LPAREN /*19L*/ RPAREN
	;

array_decl :
	direct_declarator_reentrance LBRCKT /*19L*/ opt_const_expr RBRCKT
	;

pointer_start :
	STAR /*15L*/ opt_type_qual_list
	;

pointer_reentrance :
	pointer_start
	| pointer_reentrance pointer_start
	;

pointer :
	pointer_reentrance
	;

ident_list :
	ident_list_reentrance
	;

ident_list_reentrance :
	ident
	| ident_list_reentrance COMMA ident %prec COMMA_OP /*3L*/
	;

ident :
	IDENT
	;

typename_as_ident :
	TYPEDEF_NAME
	;

any_ident :
	ident
	| typename_as_ident
	;

opt_param_type_list :
	/*empty*/
	| param_type_list_bis
	;

param_type_list :
	param_type_list_bis
	;

param_type_list_bis :
	param_list
	| param_list COMMA ELLIPSIS %prec COMMA_OP /*3L*/
	;

param_list :
	param_decl
	| param_list COMMA param_decl %prec COMMA_OP /*3L*/
	;

param_decl :
	param_decl_bis
	;

param_decl_bis :
	decl_specs_reentrance_bis declarator
	| decl_specs_reentrance_bis abs_decl_reentrance
	| decl_specs_reentrance_bis
	;

abs_decl_reentrance :
	pointer
	| direct_abs_decl_reentrance_bis
	| pointer direct_abs_decl_reentrance_bis
	;

direct_abs_decl_reentrance_bis :
	direct_abs_decl_reentrance
	;

direct_abs_decl_reentrance :
	LPAREN /*19L*/ abs_decl_reentrance RPAREN
	| LBRCKT /*19L*/ opt_const_expr RBRCKT
	| direct_abs_decl_reentrance LBRCKT /*19L*/ opt_const_expr RBRCKT
	| LPAREN /*19L*/ opt_param_type_list RPAREN
	| direct_abs_decl_reentrance LPAREN /*19L*/ opt_param_type_list RPAREN
	;

opt_gcc_attrib :
	/*empty*/
	| gcc_attrib
	;

gcc_attrib :
	ATTRIBUTE LPAREN /*19L*/ LPAREN /*19L*/ gcc_inner RPAREN RPAREN
	;

gcc_inner :
	/*empty*/
	| PACKED
	| CDECL
	| CONST
	| NORETURN
	| ALIGNED LPAREN /*19L*/ INUM RPAREN
	| MODE LPAREN /*19L*/ ident RPAREN
	| FORMAT LPAREN /*19L*/ ident COMMA INUM COMMA INUM RPAREN
	| MALLOC
	;

%%

//%x Start PP CMMT CC STR PPLN PAREN_ELIM GCC_ATTRIB MSC_ASM_ELIM
%x PP PPLN PAREN_ELIM GCC_ATTRIB MSC_ASM_ELIM

dot		"."
digit		[0-9]
octdigit	[0-7]
hexdigit	[0-9a-fA-F]
digits          {digit}+
alpha		[a-zA-Z_$]
alphanum	{alpha}|{digit}

usuffix         [uU]
lsuffix         [lL]
intsuffix       {usuffix}{lsuffix}?|{lsuffix}{usuffix}?
intnum		{digit}+{intsuffix}?
octnum		0{octdigit}+{intsuffix}?
hexnum		0[xX]{hexdigit}+{intsuffix}?

exponent	[Ee][+-]?{digits}
floatsuffix     [fFlL]

whitespace      [ \t\f\v]
allwhite        [ \t\f\b\v\r\n]

pp_strt         ^{whitespace}*"#"{whitespace}*

char_const	'(\\.|[^'\n\r\\])'
str_const	\"(\\.|[^"\n\r\\])*\"

%%

"/*"(?s:.)*?"*/"	skip()
"//".*	skip()
//"//*"      // Ambiguous C++ style comment, must parse as
                      //    '/' '/*' to be Ansi compliant

//"//"[^*].*$ { /* C++ style comment */


{char_const}	CHAR_CONST
L{char_const}	LCHAR_CONST
{str_const}	STRING
L{str_const}	LSTRING


"auto"     AUTO
"extern"   EXTRN
"register" REGISTR
"static"   STATIC
"typedef"  TYPEDEF

"const"    CONST
"volatile" VOLATILE

"void"     VOID
"_Bool"     BOOL
"char"     CHAR
"short"    SHORT
"int"      INT
"__int64"  INT64
"__int32"  INT32
"__int16"  INT16
"__int8"   INT8
"long"     LONG
"float"    FLOAT
"double"   DOUBLE
"signed"   SGNED
"unsigned" UNSGNED
"enum"     ENUM
"struct"   STRUCT
"union"    UNION

"__builtin_va_list"    ELLIPSIS 	/* A GCC extension */
"break"    BREAK
"case"     CASE
"continue" CONT
"default"  DEFLT
"do"       DO
"else"     ELSE
"for"      FOR
"goto"     GOTO
"if"       IF
"return"   RETURN
"sizeof"   SIZEOF
"switch"   SWITCH
"while"    WHILE

  /* Microsoft Extensions */
"__asm"<MSC_ASM_ELIM>
"__declspec"<>PAREN_ELIM>

  /* GCC2 Extensions */
"asm"<>PAREN_ELIM>
"__asm__"<>PAREN_ELIM>

<PAREN_ELIM>"("[^()]*<>PAREN_ELIM>
<PAREN_ELIM>[^()]+<.>      /* Throw away */
<PAREN_ELIM>")"<<>	skip()

<MSC_ASM_ELIM>[^}]+<.>   /* Throw away */
<MSC_ASM_ELIM>"}"<INITIAL>

"__attribute"<GCC_ATTRIB>    ATTRIBUTE
"__attribute__"<GCC_ATTRIB>  ATTRIBUTE

<GCC_ATTRIB>"aligned"<INITIAL>     ALIGNED
<GCC_ATTRIB>"__aligned"<INITIAL>   ALIGNED
<GCC_ATTRIB>"__aligned__"<INITIAL> ALIGNED
<GCC_ATTRIB>"packed"<INITIAL>      PACKED
<GCC_ATTRIB>"__packed"<INITIAL>    PACKED
<GCC_ATTRIB>"__packed__"<INITIAL>  PACKED
<GCC_ATTRIB>"cdecl"<INITIAL>       CDECL
<GCC_ATTRIB>"__cdecl"<INITIAL>     CDECL
<GCC_ATTRIB>"__cdecl__"<INITIAL>   CDECL

<GCC_ATTRIB>{whitespace}+ skip()  /* space/tab/formfeed/vertical tab (ignore) */
<GCC_ATTRIB>"("           LPAREN

<GCC_ATTRIB>"format"|"__format"|"__format__"<INITIAL>      FORMAT
<GCC_ATTRIB>"mode"|"__mode"|"__mode__"<INITIAL>        MODE
<GCC_ATTRIB>"const"|"__const"|"__const__"<INITIAL>       CONST
<GCC_ATTRIB>"noreturn"|"__noreturn"|"__noreturn__"<INITIAL>    NORETURN
<GCC_ATTRIB>"__malloc__"<INITIAL> MALLOC

"__const"  CONST
"__const__"  CONST
"__signed" SGNED
"__signed__" SGNED
"__volatile"  VOLATILE
"__volatile__" VOLATILE

"typeof"      skip()
"__typeof"    skip()
"__typeof__"  skip()

"inline"      skip()
"__inline"    skip()
"__inline__"  skip()

"__extension__"  skip()

"alignof"      skip()
"__alignof"    skip()
"__alignof__"  skip()

"__imag"     skip()
"__imag__"   skip()
"__real"     skip()
"__real__"   skip()
"__complex"    skip()
"__complex__"  skip()
"__iterator"   skip()
"__iterator__" skip()
"__label__"    skip()

/* Windows only non-standard C crud */
"_cdecl"       skip()
"__cdecl"      skip()
"_stdcall"     skip()
"__stdcall"    skip()
"_fastcall"    skip()
"__fastcall"   skip()


"+"        PLUS
"-"        MINUS
"*"        STAR
"/"        DIV
"%"        MOD

"+="       ASSIGN
"-="       ASSIGN
"*="       ASSIGN
"/="       ASSIGN
"%="       ASSIGN

"!"        NOT
"&&"       AND
"||"       OR

"~"        B_NOT
"&"        B_AND
"|"        B_OR
"^"        B_XOR

"&="       ASSIGN
"|="       ASSIGN
"^="       ASSIGN

"<<"       L_SHIFT
">>"       R_SHIFT
"<<="      ASSIGN
">>="      ASSIGN

"=="       COMP_EQ
"<"        COMP_ARITH
"<="       COMP_ARITH
">"        COMP_ARITH
">="       COMP_ARITH
"!="       COMP_EQ

"="        EQ
"++"       INCR
"--"       DECR

"("        LPAREN
")"        RPAREN
"["        LBRCKT
"]"        RBRCKT
"{"        LBRACE
"}"        RBRACE

"."        DOT
"->"       ARROW

"?"        QUESTMARK
":"        COLON
";"        SEMICOLON
","        COMMA
"..."      ELLIPSIS

"__restrict"  skip()  /* ignore GNU extension */

	/* Unused (invalid) characters */
//"`"        BACKQUOTE
//"@"        AT

	/* Preprocessor Stuff */
{pp_strt}\n       skip()

{pp_strt}"line"{whitespace}*<PPLN>
{pp_strt}"file"{whitespace}*<PPLN>
{pp_strt}{digit}<PPLN>
{pp_strt}<PP>

<PPLN>[^\n]+<PP>	PP_LINE

<PP>\\(\n)<.>              /* Preprocessor continuation line */

<PP>\n<INITIAL>              skip()  /* End of this preprocessor logical line */

<PP>[^\n\\]+<.>           /* Swallow cpp junk to prevent it being echo'd */

//LABEL_NAME LABEL_NAME
//TAG_NAME	TAG_NAME
//TYPEDEF_NAME	TYPEDEF_NAME
{alpha}{alphanum}*   IDENT  /* Identifier or TAG_NAME LABEL_NAME TYPEDEF_NAME */

{octnum}|{intnum}|{hexnum}   INUM  /* An integer */

{digits}{dot}{digits}{exponent}?{floatsuffix}? RNUM
{digits}{dot}{exponent}?{floatsuffix}?         RNUM
{dot}{digits}{exponent}?{floatsuffix}?         RNUM
{digits}{exponent}{floatsuffix}? RNUM
                         /*
                         ** Note: The floatsuffix, if any, will be
                         ** ignored by atof().
                         */


////<STR>\"{allwhite}*\"<.>      /* String Pasting */
////
////<STR>\"<<>     STRING   /* Closing quote */
////
//////<STR>\n<<>   INVALID                /* Error - unterminated string constant */
////
////<STR>\\[0-7]+<.>           /* octal escape sequence */
////
////<STR>\\x{hexdigit}+<.>       /* hex escape sequence - ISO C */
////
////<STR>\\{digits}<.>          /* Bad escape sequence */
////
////<STR>\\n<.>               //"String constant too long"
////
////<STR>\\t<.>		//"String constant too long");
////
////<STR>\\r<.>               //"String constant too long"
////
////<STR>\\b<.>               //"String constant too long"
////
////<STR>\\f<.>               //"String constant too long"
////
////<STR>\\v<.>               //"String constant too long"
////
////<STR>\\a<.>               //"String constant too long"
////
////<STR>\\e<.>               //"String constant too long"
////
////<STR>\\(\n)<.>           //  /* String continuation */
////
////<STR>\\.<.>               //"String constant too long"
////
////<STR>[^\\\n\"]+<.>        //"String constant too long"

////<CMMT>[^*\n/\\]*<.>         /* Inside C-style comment */
////
////<CMMT>[^*\n/\\]*\n<.>
////<CMMT>"/"[^*\n]<.>
////<CMMT>\\\n<.>
////<CMMT>\\[^\n]<.>
////<CMMT>"/"\n<.>
////<CMMT>"/*"<.>             // yywarn("/* inside comment");
////<CMMT>"*"+[^*/\n\\]*<.>     /* Stars */
////<CMMT>"*"+[^*/\n\\]*\n<.>
////<CMMT>"*"+"/"<<>          skip()

////<CC>\\[0-7]{1,3}"'"<<>    CHAR_CONST   /* octal escape sequence */
////
////<CC>\\x{hexdigit}+"'"<<>  CHAR_CONST   /* hex escape sequence - ISO C */
////
//////<CC>\\{digits}"'"<<>   CHAR_CONST     /* Bad escape sequence */
////
//////<CC>\n<<>    CHAR_CONST             /* Error unterminated char constant */
////
////<CC>\\n"'"<<>     CHAR_CONST
////
////<CC>\\t"'"<<>      CHAR_CONST
////
////<CC>\\r"'"<<>       CHAR_CONST
////
////<CC>\\b"'"<<>     CHAR_CONST
////
////<CC>\\f"'"<<>     CHAR_CONST
////
////<CC>\\v"'"<<>     CHAR_CONST
////
////<CC>\\a"'"<<>      CHAR_CONST
////
////<CC>\\e"'"<<>      CHAR_CONST
////
////<CC>\\\n"'"<<>   CHAR_CONST
////
////<CC>\\."'"<<>      CHAR_CONST
////
////<CC>[^']"'"<<>
////
////<CC>"'"<<>       CHAR_CONST          /* Empty */
////
////<CC>[^\\\n][^']+"'"<<>   CHAR_CONST  /* Multiple characters */

{whitespace}+ skip()  /* space/tab/formfeed/vertical tab (ignore) */

//<INITIAL,CMMT>\n|\r    skip()
<INITIAL>\n|\r    skip()

//<CMMT><<EOF>>          yyerr("EOF reached inside comment");

//<CC><<EOF>>            yyerr("EOF reached inside character constant");

//<STR><<EOF>>           yyerr("EOF reached inside string constant");

//.                      /* Any unknown char is an error */

%%
