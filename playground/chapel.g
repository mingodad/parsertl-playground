//From: https://github.com/chapel-lang/chapel/blob/main/frontend/lib/parsing/chpl.ypp

/*Tokens*/
%token TIDENT
%token TQUERIEDIDENT
%token INTLITERAL
%token REALLITERAL
%token IMAGLITERAL
%token STRINGLITERAL
%token BYTESLITERAL
%token CSTRINGLITERAL
%token EXTERNCODE
%token TALIGN
%token TAS
%token TATOMIC
%token TBEGIN
%token TBREAK
%token TBOOL
%token TBORROWED
%token TBY
%token TBYTES
%token TCATCH
%token TCLASS
%token TCOBEGIN
%token TCOFORALL
%token TCOMPLEX
%token TCONFIG
%token TCONST
%token TCONTINUE
%token TDEFER
%token TDELETE
%token TDMAPPED
%token TDO
%token TDOMAIN
%token TELSE
%token TENUM
%token TEXCEPT
%token TEXPORT
%token TEXTERN
%token TFALSE
%token TFOR
%token TFORALL
%token TFOREACH
%token TFORWARDING
%token TIF
%token TIMAG
%token TIMPORT
%token TIN
%token TINCLUDE
%token TINDEX
%token TINLINE
%token TINOUT
%token TINT
%token TITER
%token TINITEQUALS
%token TIMPLEMENTS
%token TINTERFACE
%token TLABEL
%token TLAMBDA
%token TLET
%token TLIFETIME
%token TLOCAL
%token TLOCALE
%token TMANAGE
%token TMINUSMINUS
%token TMODULE
%token TNEW
%token TNIL
%token TNOINIT
%token TNONE
%token TNOTHING
%token TON
%token TONLY
%token TOPERATOR
%token TOTHERWISE
%token TOUT
%token TOVERRIDE
%token TOWNED
%token TPARAM
%token TPLUSPLUS
%token TPRAGMA
%token TPRIMITIVE
%token TPRIVATE
%token TPROC
%token TPROTOTYPE
%token TPUBLIC
%token TPROCLP
%token TREAL
%token TRECORD
%token TREDUCE
%token TREF
%token TREQUIRE
%token TRETURN
%token TSCAN
%token TSELECT
%token TSERIAL
%token TSHARED
%token TSINGLE
%token TSPARSE
%token TSTRING
%token TSUBDOMAIN
%token TSYNC
%token TTHEN
%token TTHIS
%token TTHROW
%token TTHROWS
%token TTRUE
%token TTRY
%token TTRYBANG
%token TTYPE
%token TUINT
%token TUNDERSCORE
%token TUNION
%token TUNMANAGED
%token TUSE
%token TVAR
%token TVOID
%token TWHEN
%token TWHERE
%token TWHILE
%token TWITH
%token TYIELD
%token TZIP
%token TALIAS
%token TAND
%token TASSIGN
%token TASSIGNBAND
%token TASSIGNBOR
%token TASSIGNBXOR
%token TASSIGNDIVIDE
%token TASSIGNEXP
%token TASSIGNLAND
%token TASSIGNLOR
%token TASSIGNMINUS
%token TASSIGNMOD
%token TASSIGNMULTIPLY
%token TASSIGNPLUS
%token TASSIGNREDUCE
%token TASSIGNSL
%token TASSIGNSR
%token TATMARK
%token TBANG
%token TBAND
%token TBNOT
%token TBOR
%token TBXOR
%token TCOLON
%token TCOMMA
%token TDIVIDE
%token TDOT
%token TDOTDOT
%token TDOTDOTDOT
%token TEQUAL
%token TEXP
%token TGREATER
%token TGREATEREQUAL
%token THASH
%token TLESS
%token TLESSEQUAL
%token TMINUS
%token TMOD
%token TNOTEQUAL
%token TOR
%token TPLUS
%token TQUESTION
%token TSEMI
%token TSHIFTLEFT
%token TSHIFTRIGHT
%token TSTAR
%token TSWAP
%token TLCBR
%token TRCBR
%token TLP
%token TRP
%token TLSBR
%token TRSBR
%token TNOELSE
%token TDOTDOTOPENHIGH
%token TUPLUS
%token TUMINUS
%token TLNOT

%token ILLEGAL_CHARACTHER

%left /*1*/ TNOELSE
%left /*2*/ TELSE TTHROWS
%right /*3*/ TCONST TPARAM TREF TTYPE TVAR
%right /*4*/ TCOMMA
%nonassoc /*5*/ TIDENT TBOOL TBYTES TCOMPLEX TDOMAIN TIMAG TINDEX TINT TLOCALE TNOTHING TREAL TSTRING TUINT TVOID
%nonassoc /*6*/ TFALSE TNONE TTHIS TTRUE
%left /*7*/ TATOMIC TFOR TFORALL TFOREACH TIF TSINGLE TSYNC
%left /*8*/ TIN
%left /*9*/ TALIGN TBY THASH
%left /*10*/ TOR
%left /*11*/ TAND
%left /*12*/ TEQUAL TNOTEQUAL
%left /*13*/ TGREATER TGREATEREQUAL TLESS TLESSEQUAL
%left /*14*/ TDOTDOT TDOTDOTOPENHIGH
%left /*15*/ TMINUS TPLUS
%left /*16*/ TBOR
%left /*17*/ TBXOR
%left /*18*/ TBAND
%left /*19*/ TSHIFTLEFT TSHIFTRIGHT
%right /*20*/ TUPLUS TUMINUS
%left /*21*/ TDIVIDE TMOD TSTAR
%right /*22*/ TBNOT TLNOT
%left /*23*/ TDMAPPED TREDUCE TSCAN
%right /*24*/ TEXP
%left /*25*/ TCOLON
%right /*26*/ TBORROWED TOWNED TSHARED TUNMANAGED
%left /*27*/ TLCBR TRSBR
%left /*28*/ TBANG TQUESTION
%right /*29*/ TNEW
%left /*30*/ TDOT TLP
%nonassoc /*31*/ TPRAGMA TALIAS

%start program

%%

program :
	toplevel_stmt_ls
	;

toplevel_stmt_ls :
	/*empty*/
	| toplevel_stmt_ls toplevel_stmt
	;

toplevel_stmt :
	stmt
	| pragma_ls stmt
	;

pragma_ls :
	TPRAGMA /*31N*/ STRINGLITERAL
	| pragma_ls TPRAGMA /*31N*/ STRINGLITERAL
	;

stmt :
	attribute_group attribute_receiver
	| stmt_base
	;

stmt_base :
	tryable_stmt
	| decl_base
	| include_module_stmt
	| block_stmt
	| use_stmt
	| import_stmt
	| require_stmt
	| extern_block_stmt
	| implements_stmt
	| interface_stmt
	| TDEFER stmt
	| try_stmt
	| return_stmt
	| TBREAK opt_label_ident TSEMI
	| TCONTINUE opt_label_ident TSEMI
	| TLABEL ident_def stmt
	| TYIELD opt_try_expr TSEMI
	//| error TSEMI
	;

tryable_stmt :
	assignment_stmt
	| if_stmt
	| loop_stmt
	| select_stmt
	| manage_stmt
	| stmt_level_expr TSEMI
	| throw_stmt
	| TBEGIN opt_task_intent_ls stmt
	| TCOBEGIN opt_task_intent_ls block_stmt
	| TDELETE expr_ls TSEMI
	| TLOCAL expr do_stmt
	| TLOCAL do_stmt
	| TON expr do_stmt
	| TSERIAL expr do_stmt
	| TSERIAL do_stmt
	| TSYNC /*7L*/ stmt
	;

decl_base :
	module_decl_stmt
	| class_level_stmt
	;

attribute_receiver :
	loop_stmt
	| decl_base
	| block_stmt
	;

attribute_group :
	attribute_decl_stmt_ls
	;

attribute_decl_stmt_ls :
	attribute_decl_stmt
	| attribute_decl_stmt_ls attribute_decl_stmt
	;

attribute_decl_stmt :
	attribute_decl_begin opt_attribute_decl_toolspace opt_attribute_actuals
	| attribute_decl_begin opt_attribute_decl_toolspace
	| attribute_decl_begin STRINGLITERAL
	;

attribute_decl_begin :
	TATMARK TIDENT /*5N*/
	;

opt_attribute_decl_toolspace :
	/*empty*/
	| TDOT /*30L*/ TIDENT /*5N*/ opt_attribute_decl_toolspace
	;

opt_attribute_actuals :
	TLP /*30L*/ TRP
	| TLP /*30L*/ attribute_actuals_ls TRP
	;

attribute_actuals_ls :
	attribute_actual
	| attribute_actuals_ls TCOMMA /*4R*/ attribute_actual
	;

attribute_actual :
	actual_expr
	;

module_decl_start :
	opt_access_control opt_prototype TMODULE ident_def
	;

module_decl_stmt :
	module_decl_start TLCBR /*27L*/ TRCBR
	| module_decl_start TLCBR /*27L*/ stmt_ls TRCBR
	//| module_decl_start TLCBR /*27L*/ error TRCBR
	;

opt_access_control :
	/*empty*/
	| TPUBLIC
	| TPRIVATE
	;

opt_prototype :
	/*empty*/
	| TPROTOTYPE
	;

include_module_stmt :
	TINCLUDE opt_access_control opt_prototype TMODULE ident_def TSEMI
	;

block_stmt_body :
	TLCBR /*27L*/ TRCBR
	| TLCBR /*27L*/ stmt_ls TRCBR
	//| TLCBR /*27L*/ error TRCBR
	;

block_stmt :
	block_stmt_body
	;

stmt_ls :
	toplevel_stmt
	| stmt_ls toplevel_stmt
	;

renames_ls :
	expr
	| all_op_name
	| expr TAS expr
	| renames_ls TCOMMA /*4R*/ expr
	| renames_ls TCOMMA /*4R*/ all_op_name
	| renames_ls TCOMMA /*4R*/ expr TAS expr
	;

use_renames_ls :
	expr
	| expr TAS expr
	| expr TAS TUNDERSCORE
	| use_renames_ls TCOMMA /*4R*/ expr
	| use_renames_ls TCOMMA /*4R*/ expr TAS expr
	| use_renames_ls TCOMMA /*4R*/ expr TAS TUNDERSCORE
	;

opt_only_ls :
	/*empty*/
	| renames_ls
	;

use_stmt :
	opt_access_control TUSE use_renames_ls TSEMI
	| opt_access_control TUSE expr TEXCEPT renames_ls TSEMI
	| opt_access_control TUSE expr TAS expr TEXCEPT renames_ls TSEMI
	| opt_access_control TUSE expr TAS TUNDERSCORE TEXCEPT renames_ls TSEMI
	| opt_access_control TUSE expr TONLY opt_only_ls TSEMI
	| opt_access_control TUSE expr TAS expr TONLY opt_only_ls TSEMI
	| opt_access_control TUSE expr TAS TUNDERSCORE TONLY opt_only_ls TSEMI
	;

import_stmt :
	opt_access_control TIMPORT import_ls TSEMI
	;

import_internal_type_ident :
	TBOOL /*5N*/
	| TINT /*5N*/
	| TUINT /*5N*/
	| TREAL /*5N*/
	| TIMAG /*5N*/
	| TCOMPLEX /*5N*/
	| TBYTES /*5N*/
	| TSTRING /*5N*/
	| TSYNC /*7L*/
	| TSINGLE /*7L*/
	| TOWNED /*26R*/
	| TSHARED /*26R*/
	| TBORROWED /*26R*/
	| TUNMANAGED /*26R*/
	| TINDEX /*5N*/
	| TNOTHING /*5N*/
	| TVOID /*5N*/
	;

import_expr :
	expr
	| expr TDOT /*30L*/ all_op_name
	| expr TDOT /*30L*/ import_internal_type_ident
	| expr TAS ident_use
	| expr TDOT /*30L*/ TLCBR /*27L*/ renames_ls TRCBR
	;

import_ls :
	import_expr
	| import_ls TCOMMA /*4R*/ import_expr
	;

require_stmt :
	TREQUIRE expr_ls TSEMI
	;

assignment_stmt :
	lhs_expr assignop_ident opt_try_expr TSEMI
	| lhs_expr TSWAP opt_try_expr TSEMI
	| lhs_expr TASSIGNREDUCE opt_try_expr TSEMI
	| lhs_expr TASSIGNLAND opt_try_expr TSEMI
	| lhs_expr TASSIGNLOR opt_try_expr TSEMI
	| lhs_expr TASSIGN TNOINIT TSEMI
	;

opt_label_ident :
	/*empty*/
	| TIDENT /*5N*/
	;

reserved_word_ident :
	TNONE /*6N*/
	| TTHIS /*6N*/
	| TFALSE /*6N*/
	| TTRUE /*6N*/
	| internal_type_ident_def
	;

ident_def :
	TIDENT /*5N*/
	| reserved_word_ident
	;

ident_use :
	TIDENT /*5N*/
	| TTHIS /*6N*/
	;

internal_type_ident_def :
	TBOOL /*5N*/
	| TINT /*5N*/
	| TUINT /*5N*/
	| TREAL /*5N*/
	| TIMAG /*5N*/
	| TCOMPLEX /*5N*/
	| TBYTES /*5N*/
	| TSTRING /*5N*/
	| TSYNC /*7L*/
	| TSINGLE /*7L*/
	| TOWNED /*26R*/
	| TSHARED /*26R*/
	| TBORROWED /*26R*/
	| TUNMANAGED /*26R*/
	| TDOMAIN /*5N*/
	| TINDEX /*5N*/
	| TLOCALE /*5N*/
	| TNOTHING /*5N*/
	| TVOID /*5N*/
	;

scalar_type :
	TBOOL /*5N*/
	| TENUM
	| TINT /*5N*/
	| TUINT /*5N*/
	| TREAL /*5N*/
	| TIMAG /*5N*/
	| TCOMPLEX /*5N*/
	| TBYTES /*5N*/
	| TSTRING /*5N*/
	| TLOCALE /*5N*/
	| TNOTHING /*5N*/
	| TVOID /*5N*/
	;

reserved_type_ident_use :
	TSYNC /*7L*/
	| TSINGLE /*7L*/
	| TDOMAIN /*5N*/
	| TINDEX /*5N*/
	;

do_stmt :
	TDO stmt
	| block_stmt
	;

return_stmt :
	TRETURN TSEMI
	| TRETURN opt_try_expr TSEMI
	;

class_level_stmt :
	TSEMI
	| inner_class_level_stmt
	| TPUBLIC inner_class_level_stmt
	| TPRIVATE inner_class_level_stmt
	;

inner_class_level_stmt :
	fn_decl_stmt_complete
	| var_decl_stmt
	| enum_decl_stmt
	| type_alias_decl_stmt
	| class_decl_stmt
	| forwarding_decl_stmt
	| extern_export_decl_stmt
	;

forwarding_decl_stmt :
	forwarding_decl_start expr TSEMI
	| forwarding_decl_start expr TEXCEPT renames_ls TSEMI
	| forwarding_decl_start expr TONLY opt_only_ls TSEMI
	| forwarding_decl_start var_decl_stmt
	;

forwarding_decl_start :
	TFORWARDING
	;

extern_or_export :
	TEXTERN
	| TEXPORT
	;

extern_export_decl_stmt_start :
	extern_or_export
	;

extern_export_decl_stmt :
	extern_export_decl_stmt_start class_start opt_inherit TLCBR /*27L*/ class_level_stmt_ls TRCBR
	| extern_export_decl_stmt_start STRINGLITERAL class_start opt_inherit TLCBR /*27L*/ class_level_stmt_ls TRCBR
	| extern_export_decl_stmt_start opt_expr fn_decl_stmt
	| extern_export_decl_stmt_start opt_expr var_decl_type var_decl_stmt_inner_ls TSEMI
	| extern_export_decl_stmt_start opt_expr TTYPE /*3R*/ type_alias_decl_stmt_inner_ls TSEMI
	;

extern_block_stmt :
	TEXTERN EXTERNCODE
	;

loop_stmt :
	TDO stmt TWHILE expr TSEMI
	| TWHILE expr do_stmt
	| TWHILE ifvar do_stmt
	| TCOFORALL expr TIN /*8L*/ expr opt_task_intent_ls do_stmt
	| TCOFORALL expr TIN /*8L*/ zippered_iterator opt_task_intent_ls do_stmt
	| TCOFORALL expr opt_task_intent_ls do_stmt
	| TFOR /*7L*/ expr TIN /*8L*/ expr do_stmt
	| TFOR /*7L*/ expr TIN /*8L*/ zippered_iterator do_stmt
	| TFOR /*7L*/ expr do_stmt
	| TFOR /*7L*/ zippered_iterator do_stmt
	| TFOR /*7L*/ TPARAM /*3R*/ ident_def TIN /*8L*/ expr do_stmt
	| TFORALL /*7L*/ expr TIN /*8L*/ expr do_stmt
	| TFORALL /*7L*/ expr TIN /*8L*/ expr forall_intent_clause do_stmt
	| TFORALL /*7L*/ expr TIN /*8L*/ zippered_iterator do_stmt
	| TFORALL /*7L*/ expr TIN /*8L*/ zippered_iterator forall_intent_clause do_stmt
	| TFORALL /*7L*/ expr do_stmt
	| TFORALL /*7L*/ expr forall_intent_clause do_stmt
	| TFORALL /*7L*/ zippered_iterator do_stmt
	| TFORALL /*7L*/ zippered_iterator forall_intent_clause do_stmt
	| TFOREACH /*7L*/ expr TIN /*8L*/ expr do_stmt
	| TFOREACH /*7L*/ expr TIN /*8L*/ expr forall_intent_clause do_stmt
	| TFOREACH /*7L*/ expr TIN /*8L*/ zippered_iterator do_stmt
	| TFOREACH /*7L*/ expr TIN /*8L*/ zippered_iterator forall_intent_clause do_stmt
	| TFOREACH /*7L*/ expr do_stmt
	| TFOREACH /*7L*/ expr forall_intent_clause do_stmt
	| TFOREACH /*7L*/ zippered_iterator do_stmt
	| TFOREACH /*7L*/ zippered_iterator forall_intent_clause do_stmt
	| TLSBR expr_ls TIN /*8L*/ expr TRSBR /*27L*/ stmt
	| TLSBR expr_ls TIN /*8L*/ expr forall_intent_clause TRSBR /*27L*/ stmt
	| TLSBR expr_ls TIN /*8L*/ zippered_iterator TRSBR /*27L*/ stmt
	| TLSBR expr_ls TIN /*8L*/ zippered_iterator forall_intent_clause TRSBR /*27L*/ stmt
	| TLSBR expr_ls TRSBR /*27L*/ stmt
	| TLSBR expr_ls forall_intent_clause TRSBR /*27L*/ stmt
	| TLSBR zippered_iterator TRSBR /*27L*/ stmt
	| TLSBR zippered_iterator forall_intent_clause TRSBR /*27L*/ stmt
	;

zippered_iterator :
	TZIP TLP /*30L*/ expr_ls TRP
	;

if_stmt :
	TIF /*7L*/ expr TTHEN stmt %prec TNOELSE /*1L*/
	| TIF /*7L*/ expr block_stmt %prec TNOELSE /*1L*/
	| TIF /*7L*/ expr TTHEN stmt TELSE /*2L*/ stmt
	| TIF /*7L*/ expr block_stmt TELSE /*2L*/ stmt
	| TIF /*7L*/ ifvar TTHEN stmt %prec TNOELSE /*1L*/
	| TIF /*7L*/ ifvar block_stmt %prec TNOELSE /*1L*/
	| TIF /*7L*/ ifvar TTHEN stmt TELSE /*2L*/ stmt
	| TIF /*7L*/ ifvar block_stmt TELSE /*2L*/ stmt
	| TIF /*7L*/ expr assignop_ident expr TTHEN stmt %prec TNOELSE /*1L*/
	| TIF /*7L*/ expr assignop_ident expr block_stmt %prec TNOELSE /*1L*/
	| TIF /*7L*/ expr assignop_ident expr TTHEN stmt TELSE /*2L*/ stmt
	| TIF /*7L*/ expr assignop_ident expr block_stmt TELSE /*2L*/ stmt
	;

ifvar :
	TVAR /*3R*/ ident_def TASSIGN expr
	| TCONST /*3R*/ ident_def TASSIGN expr
	;

interface_stmt :
	TINTERFACE ident_def TLP /*30L*/ ifc_formal_ls TRP block_stmt
	| TINTERFACE ident_def block_stmt
	;

ifc_formal_ls :
	ifc_formal
	| ifc_formal_ls TCOMMA /*4R*/ ifc_formal
	;

ifc_formal :
	ident_def
	;

implements_type_ident :
	TIDENT /*5N*/
	| TBOOL /*5N*/
	| TINT /*5N*/
	| TUINT /*5N*/
	| TREAL /*5N*/
	| TIMAG /*5N*/
	| TCOMPLEX /*5N*/
	| TBYTES /*5N*/
	| TSTRING /*5N*/
	| TLOCALE /*5N*/
	| TNOTHING /*5N*/
	| TVOID /*5N*/
	| implements_type_error_ident
	;

implements_type_error_ident :
	TNONE /*6N*/
	| TTHIS /*6N*/
	| TFALSE /*6N*/
	| TTRUE /*6N*/
	| TDOMAIN /*5N*/
	| TINDEX /*5N*/
	;

implements_stmt :
	TIMPLEMENTS ident_def TLP /*30L*/ actual_ls TRP TSEMI
	| implements_type_ident TIMPLEMENTS ident_def TSEMI
	| implements_type_ident TIMPLEMENTS ident_def TLP /*30L*/ actual_ls TRP TSEMI
	;

ifc_constraint :
	TIMPLEMENTS ident_def TLP /*30L*/ actual_ls TRP
	| implements_type_ident TIMPLEMENTS ident_def
	| implements_type_ident TIMPLEMENTS ident_def TLP /*30L*/ actual_ls TRP
	;

try_stmt :
	TTRY tryable_stmt
	| TTRYBANG tryable_stmt
	| TTRY block_stmt catch_expr_ls
	| TTRYBANG block_stmt catch_expr_ls
	;

catch_expr_ls :
	/*empty*/
	| catch_expr_ls catch_expr
	;

catch_expr :
	TCATCH block_stmt
	| TCATCH catch_expr_inner block_stmt
	| TCATCH TLP /*30L*/ catch_expr_inner TRP block_stmt
	;

catch_expr_inner :
	ident_def
	| ident_def TCOLON /*25L*/ expr
	;

throw_stmt :
	TTHROW expr TSEMI
	;

select_stmt :
	TSELECT expr TLCBR /*27L*/ when_stmt_ls TRCBR
	//| TSELECT expr TLCBR /*27L*/ error TRCBR
	;

when_stmt_ls :
	/*empty*/
	| when_stmt_ls when_stmt
	;

when_stmt :
	TWHEN expr_ls do_stmt
	| TOTHERWISE stmt
	| TOTHERWISE TDO stmt
	;

manager_expr :
	expr TAS var_decl_type ident_def
	| expr TAS ident_def
	| expr
	;

manager_expr_ls :
	manager_expr
	| manager_expr_ls TCOMMA /*4R*/ manager_expr
	;

manage_stmt :
	TMANAGE manager_expr_ls do_stmt
	;

class_decl_stmt :
	class_start opt_inherit TLCBR /*27L*/ class_level_stmt_ls TRCBR
	//| class_start opt_inherit TLCBR /*27L*/ error TRCBR
	;

class_start :
	class_tag ident_def
	;

class_tag :
	TCLASS
	| TRECORD
	| TUNION
	;

opt_inherit :
	/*empty*/
	| TCOLON /*25L*/ expr_ls
	;

class_level_stmt_ls :
	/*empty*/
	| class_level_stmt_ls class_level_stmt
	| class_level_stmt_ls attribute_decl_stmt_ls class_level_stmt
	| class_level_stmt_ls pragma_ls class_level_stmt
	| class_level_stmt_ls pragma_ls attribute_decl_stmt_ls class_level_stmt
	;

enum_decl_stmt :
	enum_header_lcbr enum_ls TRCBR
	//| enum_header_lcbr error TRCBR
	;

enum_header_lcbr :
	TENUM ident_def TLCBR /*27L*/
	;

enum_ls :
	enum_item
	| enum_ls TCOMMA /*4R*/
	| enum_ls TCOMMA /*4R*/ enum_item
	| attribute_decl_stmt_ls enum_item
	| enum_ls TCOMMA /*4R*/ attribute_decl_stmt_ls enum_item
	;

enum_item :
	ident_def
	| ident_def TASSIGN expr
	;

lambda_decl_start :
	TLAMBDA
	;

lambda_decl_expr :
	lambda_decl_start req_formal_ls opt_ret_tag opt_type opt_throws_error opt_lifetime_where function_body_stmt
	;

linkage_spec_empty :
	/*empty*/
	;

linkage_spec :
	linkage_spec_empty
	| TINLINE
	| TOVERRIDE
	;

opt_fn_type_formal_ls :
	/*empty*/
	| fn_type_formal_ls
	;

fn_type_formal_ls :
	fn_type_formal
	| fn_type_formal_ls TCOMMA /*4R*/ fn_type_formal
	;

fn_type_formal :
	named_formal
	| required_intent_tag TCOLON /*25L*/ formal_type
	| formal_type
	;

opt_fn_type_ret_type :
	%prec TNOELSE /*1L*/ /*empty*/
	| TCOLON /*25L*/ formal_or_ret_type_expr
	;

fn_type :
	TPROCLP opt_fn_type_formal_ls TRP opt_ret_tag opt_fn_type_ret_type opt_throws_error
	;

fn_expr :
	fn_type block_stmt_body
	| fn_type TALIAS /*31N*/ expr
	;

fn_decl_stmt_complete :
	fn_decl_stmt
	;

fn_decl_stmt :
	fn_decl_stmt_inner opt_ret_tag opt_ret_type opt_throws_error opt_lifetime_where opt_function_body_stmt
	;

fn_decl_stmt_inner :
	fn_decl_stmt_start opt_this_intent_tag fn_ident opt_formal_ls
	| fn_decl_stmt_start opt_this_intent_tag assignop_ident opt_formal_ls
	| fn_decl_stmt_start opt_this_intent_tag fn_decl_receiver_expr TDOT /*30L*/ fn_ident opt_formal_ls
	| fn_decl_stmt_start opt_this_intent_tag fn_decl_receiver_expr TDOT /*30L*/ assignop_ident opt_formal_ls
	//| fn_decl_stmt_start opt_this_intent_tag error opt_formal_ls
	;

fn_decl_stmt_start :
	linkage_spec proc_iter_or_op
	;

fn_decl_receiver_expr :
	ident_expr
	| TLP /*30L*/ expr TRP
	;

fn_ident :
	ident_def
	| op_ident
	| ident_def TBANG /*28L*/
	;

op_ident :
	TBAND /*18L*/
	| TBOR /*16L*/
	| TBXOR /*17L*/
	| TBNOT /*22R*/
	| TEQUAL /*12L*/
	| TNOTEQUAL /*12L*/
	| TLESSEQUAL /*13L*/
	| TGREATEREQUAL /*13L*/
	| TLESS /*13L*/
	| TGREATER /*13L*/
	| TPLUS /*15L*/
	| TMINUS /*15L*/
	| TSTAR /*21L*/
	| TDIVIDE /*21L*/
	| TSHIFTLEFT /*19L*/
	| TSHIFTRIGHT /*19L*/
	| TMOD /*21L*/
	| TEXP /*24R*/
	| TBANG /*28L*/
	| TBY /*9L*/
	| THASH /*9L*/
	| TALIGN /*9L*/
	| TSWAP
	| TINITEQUALS
	| TCOLON /*25L*/
	;

assignop_ident :
	TASSIGN
	| TASSIGNPLUS
	| TASSIGNMINUS
	| TASSIGNMULTIPLY
	| TASSIGNDIVIDE
	| TASSIGNMOD
	| TASSIGNEXP
	| TASSIGNBAND
	| TASSIGNBOR
	| TASSIGNBXOR
	| TASSIGNSR
	| TASSIGNSL
	;

all_op_name :
	op_ident
	| assignop_ident
	;

formal_var_arg_expr :
	TDOTDOTDOT
	| TDOTDOTDOT expr
	;

opt_formal_ls :
	/*empty*/
	| TLP /*30L*/ formal_ls TRP
	;

req_formal_ls :
	TLP /*30L*/ TRP
	| TLP /*30L*/ formal_ls_inner TRP
	;

formal_ls_inner :
	formal
	| formal_ls_inner TCOMMA /*4R*/ formal
	;

formal_ls :
	/*empty*/
	| formal_ls_inner
	;

formal :
	named_formal
	;

formal_ident_def :
	ident_def
	| TUNDERSCORE
	;

named_formal :
	opt_formal_intent_tag formal_ident_def opt_colon_formal_type opt_init_expr
	| pragma_ls opt_formal_intent_tag formal_ident_def opt_colon_formal_type opt_init_expr
	| opt_formal_intent_tag formal_ident_def opt_colon_formal_type formal_var_arg_expr
	| pragma_ls opt_formal_intent_tag formal_ident_def opt_colon_formal_type formal_var_arg_expr
	| opt_formal_intent_tag TLP /*30L*/ tuple_var_decl_stmt_inner_ls TRP opt_colon_formal_type opt_init_expr
	| opt_formal_intent_tag TLP /*30L*/ tuple_var_decl_stmt_inner_ls TRP opt_colon_formal_type formal_var_arg_expr
	;

opt_formal_intent_tag :
	%prec TFOR /*7L*/ /*empty*/
	| required_intent_tag
	;

required_intent_tag :
	TIN /*8L*/
	| TINOUT
	| TOUT
	| TCONST /*3R*/ TIN /*8L*/
	| TCONST /*3R*/ TREF /*3R*/
	| TCONST /*3R*/
	| TPARAM /*3R*/
	| TREF /*3R*/
	| TTYPE /*3R*/
	;

opt_this_intent_tag :
	/*empty*/
	| TPARAM /*3R*/
	| TREF /*3R*/
	| TCONST /*3R*/ TREF /*3R*/
	| TCONST /*3R*/
	| TTYPE /*3R*/
	;

proc_iter_or_op :
	TPROC
	| TITER
	| TOPERATOR
	;

opt_ret_tag :
	%prec TNOELSE /*1L*/ /*empty*/
	| TOUT
	| TCONST /*3R*/
	| TCONST /*3R*/ TREF /*3R*/
	| TREF /*3R*/
	| TPARAM /*3R*/
	| TTYPE /*3R*/
	;

opt_throws_error :
	%prec TNOELSE /*1L*/ /*empty*/
	| TTHROWS /*2L*/
	;

opt_function_body_stmt :
	TSEMI
	| function_body_stmt
	;

function_body_stmt :
	block_stmt_body
	| TDO toplevel_stmt
	| return_stmt
	;

query_expr :
	TQUERIEDIDENT
	;

opt_lifetime_where :
	/*empty*/
	| TWHERE expr
	| TLIFETIME lifetime_components_expr
	| TWHERE expr TLIFETIME lifetime_components_expr
	| TLIFETIME lifetime_components_expr TWHERE expr
	;

lifetime_components_expr :
	lifetime_expr
	| lifetime_components_expr TCOMMA /*4R*/ lifetime_expr
	;

lifetime_expr :
	lifetime_ident TASSIGN lifetime_ident
	| lifetime_ident TLESS /*13L*/ lifetime_ident
	| lifetime_ident TLESSEQUAL /*13L*/ lifetime_ident
	| lifetime_ident TEQUAL /*12L*/ lifetime_ident
	| lifetime_ident TGREATER /*13L*/ lifetime_ident
	| lifetime_ident TGREATEREQUAL /*13L*/ lifetime_ident
	| TRETURN lifetime_ident
	;

lifetime_ident :
	TIDENT /*5N*/
	| TTHIS /*6N*/
	;

type_alias_decl_stmt :
	type_alias_decl_stmt_start type_alias_decl_stmt_inner_ls TSEMI
	;

type_alias_decl_stmt_start :
	TTYPE /*3R*/
	| TCONFIG TTYPE /*3R*/
	;

type_alias_decl_stmt_inner_ls :
	type_alias_decl_stmt_inner
	| type_alias_decl_stmt_inner_ls TCOMMA /*4R*/ type_alias_decl_stmt_inner
	;

type_alias_decl_stmt_inner :
	ident_def opt_init_type
	;

opt_init_type :
	/*empty*/
	| TASSIGN expr
	;

var_decl_type :
	TPARAM /*3R*/
	| TCONST /*3R*/ TREF /*3R*/
	| TREF /*3R*/
	| TCONST /*3R*/
	| TVAR /*3R*/
	;

var_decl_stmt :
	TCONFIG var_decl_type var_decl_stmt_inner_ls TSEMI
	| var_decl_type var_decl_stmt_inner_ls TSEMI
	;

var_decl_stmt_inner_ls :
	var_decl_stmt_inner
	| var_decl_stmt_inner_ls TCOMMA /*4R*/ var_decl_stmt_inner
	;

var_decl_stmt_inner :
	ident_def opt_type opt_init_expr
	| TLP /*30L*/ tuple_var_decl_stmt_inner_ls TRP opt_type opt_init_expr
	;

tuple_var_decl_component :
	TUNDERSCORE
	| ident_def
	| TLP /*30L*/ tuple_var_decl_stmt_inner_ls TRP
	;

tuple_var_decl_stmt_inner_ls :
	tuple_var_decl_component
	| tuple_var_decl_stmt_inner_ls TCOMMA /*4R*/
	| tuple_var_decl_stmt_inner_ls TCOMMA /*4R*/ tuple_var_decl_component
	;

opt_init_expr :
	/*empty*/
	| TASSIGN TNOINIT
	| TASSIGN opt_try_expr
	;

formal_or_ret_type_expr :
	expr %prec TNOELSE /*1L*/
	;

ret_type :
	formal_or_ret_type_expr
	| reserved_type_ident_use
	//| error
	;

colon_ret_type :
	TCOLON /*25L*/ ret_type
	//| error
	;

opt_ret_type :
	/*empty*/
	| colon_ret_type
	;

opt_type :
	/*empty*/
	| TCOLON /*25L*/ expr
	| TCOLON /*25L*/ reserved_type_ident_use
	//| error
	;

formal_type :
	formal_or_ret_type_expr
	| reserved_type_ident_use
	;

colon_formal_type :
	TCOLON /*25L*/ formal_type
	;

opt_colon_formal_type :
	/*empty*/
	| colon_formal_type
	;

expr_ls :
	expr
	| expr_ls TCOMMA /*4R*/ expr
	;

tuple_component :
	TUNDERSCORE
	| opt_try_expr
	;

tuple_expr_ls :
	tuple_component TCOMMA /*4R*/ tuple_component
	| tuple_expr_ls TCOMMA /*4R*/ tuple_component
	;

opt_actual_ls :
	/*empty*/
	| actual_ls
	;

actual_ls :
	actual_expr
	| actual_ls TCOMMA /*4R*/ actual_expr
	;

actual_expr :
	ident_use TASSIGN opt_try_expr
	| opt_try_expr
	;

ident_expr :
	ident_use
	| scalar_type
	;

sub_type_level_expr :
	nil_expr
	| lhs_expr
	| cond_expr
	| unary_op_expr
	| binary_op_expr
	| TSINGLE /*7L*/ expr
	| TINDEX /*5N*/ TLP /*30L*/ opt_actual_ls TRP
	| TDOMAIN /*5N*/ TLP /*30L*/ opt_actual_ls TRP
	| TSUBDOMAIN TLP /*30L*/ opt_actual_ls TRP
	| TSPARSE TSUBDOMAIN TLP /*30L*/ actual_expr TRP
	| TATOMIC /*7L*/ expr
	| TSYNC /*7L*/ expr
	| TOWNED /*26R*/
	| TOWNED /*26R*/ expr
	| TUNMANAGED /*26R*/
	| TUNMANAGED /*26R*/ expr
	| TSHARED /*26R*/
	| TSHARED /*26R*/ expr
	| TBORROWED /*26R*/
	| TBORROWED /*26R*/ expr
	| TCLASS
	| TRECORD
	;

for_expr :
	TFOR /*7L*/ expr TIN /*8L*/ expr TDO expr %prec TFOR /*7L*/
	| TFOR /*7L*/ expr TIN /*8L*/ zippered_iterator TDO expr %prec TFOR /*7L*/
	| TFOR /*7L*/ expr TDO expr %prec TFOR /*7L*/
	| TFOR /*7L*/ expr TIN /*8L*/ expr TDO TIF /*7L*/ expr TTHEN expr %prec TNOELSE /*1L*/
	| TFOR /*7L*/ expr TIN /*8L*/ zippered_iterator TDO TIF /*7L*/ expr TTHEN expr %prec TNOELSE /*1L*/
	| TFOR /*7L*/ expr TDO TIF /*7L*/ expr TTHEN expr %prec TNOELSE /*1L*/
	| TFORALL /*7L*/ expr TIN /*8L*/ expr TDO expr %prec TFOR /*7L*/
	| TFORALL /*7L*/ expr TIN /*8L*/ zippered_iterator TDO expr %prec TFOR /*7L*/
	| TFORALL /*7L*/ expr TDO expr %prec TFOR /*7L*/
	| TFORALL /*7L*/ expr TIN /*8L*/ expr TDO TIF /*7L*/ expr TTHEN expr %prec TNOELSE /*1L*/
	| TFORALL /*7L*/ expr TIN /*8L*/ zippered_iterator TDO TIF /*7L*/ expr TTHEN expr %prec TNOELSE /*1L*/
	| TFORALL /*7L*/ expr TDO TIF /*7L*/ expr TTHEN expr %prec TNOELSE /*1L*/
	;

bracket_loop_expr :
	TLSBR TRSBR /*27L*/
	| TLSBR TRSBR /*27L*/ expr %prec TFOR /*7L*/
	| TLSBR expr_ls TRSBR /*27L*/ expr %prec TFOR /*7L*/
	| TLSBR expr_ls TIN /*8L*/ expr TRSBR /*27L*/ expr %prec TFOR /*7L*/
	| TLSBR expr_ls TIN /*8L*/ zippered_iterator TRSBR /*27L*/ expr %prec TFOR /*7L*/
	| TLSBR expr_ls TIN /*8L*/ expr TRSBR /*27L*/ TIF /*7L*/ expr TTHEN expr %prec TNOELSE /*1L*/
	| TLSBR expr_ls TIN /*8L*/ zippered_iterator TRSBR /*27L*/ TIF /*7L*/ expr TTHEN expr %prec TNOELSE /*1L*/
	;

cond_expr :
	TIF /*7L*/ expr TTHEN expr TELSE /*2L*/ expr
	;

nil_expr :
	TNIL
	;

stmt_level_expr :
	nil_expr
	| ident_expr
	| dot_expr
	| call_expr
	| lambda_decl_expr
	| new_expr
	| let_expr
	;

opt_task_intent_ls :
	/*empty*/
	| task_intent_clause
	;

task_intent_clause :
	TWITH TLP /*30L*/ task_intent_ls TRP
	;

task_intent_ls :
	intent_expr
	| task_intent_ls TCOMMA /*4R*/ intent_expr
	;

forall_intent_clause :
	TWITH TLP /*30L*/ forall_intent_ls TRP
	;

forall_intent_ls :
	intent_expr
	| forall_intent_ls TCOMMA /*4R*/ intent_expr
	;

intent_expr :
	task_var_prefix ident_expr opt_type opt_init_expr
	| reduce_scan_op_expr TREDUCE /*23L*/ ident_expr
	| expr TREDUCE /*23L*/ ident_expr
	;

task_var_prefix :
	TCONST /*3R*/
	| TIN /*8L*/
	| TCONST /*3R*/ TIN /*8L*/
	| TREF /*3R*/
	| TCONST /*3R*/ TREF /*3R*/
	| TVAR /*3R*/
	;

new_maybe_decorated :
	TNEW /*29R*/ %prec TNOELSE /*1L*/
	| TNEW /*29R*/ TOWNED /*26R*/
	| TNEW /*29R*/ TSHARED /*26R*/
	| TNEW /*29R*/ TUNMANAGED /*26R*/
	| TNEW /*29R*/ TBORROWED /*26R*/
	;

new_expr :
	new_maybe_decorated expr %prec TNEW /*29R*/
	| TNEW /*29R*/ TOWNED /*26R*/ TLP /*30L*/ expr TRP TLP /*30L*/ opt_actual_ls TRP %prec TNOELSE /*1L*/
	| TNEW /*29R*/ TSHARED /*26R*/ TLP /*30L*/ expr TRP TLP /*30L*/ opt_actual_ls TRP %prec TNOELSE /*1L*/
	| TNEW /*29R*/ TOWNED /*26R*/ TLP /*30L*/ expr TRP TLP /*30L*/ opt_actual_ls TRP TQUESTION /*28L*/
	| TNEW /*29R*/ TSHARED /*26R*/ TLP /*30L*/ expr TRP TLP /*30L*/ opt_actual_ls TRP TQUESTION /*28L*/
	;

let_expr :
	TLET var_decl_stmt_inner_ls TIN /*8L*/ expr
	;

range_literal_expr :
	expr TDOTDOT /*14L*/ expr
	| expr TDOTDOTOPENHIGH /*14L*/ expr
	| expr TDOTDOT /*14L*/
	| TDOTDOT /*14L*/ expr
	| TDOTDOTOPENHIGH /*14L*/ expr
	| TDOTDOT /*14L*/
	;

cast_expr :
	expr TCOLON /*25L*/ expr
	;

tuple_expand_expr :
	TLP /*30L*/ TDOTDOTDOT expr TRP
	;

super_expr :
	fn_expr
	| expr
	;

expr :
	for_expr
	| sub_type_level_expr %prec TNOELSE /*1L*/
	| sub_type_level_expr TQUESTION /*28L*/ %prec TQUESTION /*28L*/
	| TQUESTION /*28L*/
	| bracket_loop_expr
	| query_expr
	| literal_expr
	| fn_type
	| reduce_expr
	| scan_expr
	| lambda_decl_expr
	| new_expr
	| let_expr
	| ifc_constraint
	| tuple_expand_expr
	| cast_expr
	| range_literal_expr
	;

opt_expr :
	/*empty*/
	| expr
	;

opt_try_expr :
	TTRY expr
	| TTRYBANG expr
	| super_expr
	;

lhs_expr :
	ident_expr
	| call_expr
	| dot_expr
	| parenthesized_expr
	;

call_base_expr :
	lhs_expr
	| expr TBANG /*28L*/
	| sub_type_level_expr TQUESTION /*28L*/
	| lambda_decl_expr
	| str_bytes_literal
	;

call_expr :
	call_base_expr TLP /*30L*/ opt_actual_ls TRP
	| call_base_expr TLSBR opt_actual_ls TRSBR /*27L*/
	| TPRIMITIVE TLP /*30L*/ opt_actual_ls TRP
	;

dot_expr :
	expr TDOT /*30L*/ ident_use
	| expr TDOT /*30L*/ TTYPE /*3R*/
	| expr TDOT /*30L*/ TDOMAIN /*5N*/
	| expr TDOT /*30L*/ TLOCALE /*5N*/
	| expr TDOT /*30L*/ TBYTES /*5N*/ TLP /*30L*/ TRP
	| expr TDOT /*30L*/ TBYTES /*5N*/ TLSBR TRSBR /*27L*/
	;

parenthesized_expr :
	TLP /*30L*/ tuple_component TRP
	| TLP /*30L*/ tuple_component TCOMMA /*4R*/ TRP
	| TLP /*30L*/ tuple_expr_ls TRP
	| TLP /*30L*/ tuple_expr_ls TCOMMA /*4R*/ TRP
	;

bool_literal :
	TFALSE /*6N*/
	| TTRUE /*6N*/
	;

str_bytes_literal :
	STRINGLITERAL
	| BYTESLITERAL
	;

literal_expr :
	bool_literal
	| str_bytes_literal
	| INTLITERAL
	| REALLITERAL
	| IMAGLITERAL
	| CSTRINGLITERAL
	| TNONE /*6N*/
	| TLCBR /*27L*/ expr_ls TRCBR
	| TLCBR /*27L*/ expr_ls TCOMMA /*4R*/ TRCBR
	| TLSBR expr_ls TRSBR /*27L*/
	| TLSBR expr_ls TCOMMA /*4R*/ TRSBR /*27L*/
	| TLSBR assoc_expr_ls TRSBR /*27L*/
	| TLSBR assoc_expr_ls TCOMMA /*4R*/ TRSBR /*27L*/
	;

assoc_expr_ls :
	expr TALIAS /*31N*/ expr
	| assoc_expr_ls TCOMMA /*4R*/ expr TALIAS /*31N*/ expr
	;

binary_op_expr :
	expr TPLUS /*15L*/ expr
	| expr TMINUS /*15L*/ expr
	| expr TSTAR /*21L*/ expr
	| expr TDIVIDE /*21L*/ expr
	| expr TSHIFTLEFT /*19L*/ expr
	| expr TSHIFTRIGHT /*19L*/ expr
	| expr TMOD /*21L*/ expr
	| expr TEQUAL /*12L*/ expr
	| expr TNOTEQUAL /*12L*/ expr
	| expr TLESSEQUAL /*13L*/ expr
	| expr TGREATEREQUAL /*13L*/ expr
	| expr TLESS /*13L*/ expr
	| expr TGREATER /*13L*/ expr
	| expr TBAND /*18L*/ expr
	| expr TBOR /*16L*/ expr
	| expr TBXOR /*17L*/ expr
	| expr TAND /*11L*/ expr
	| expr TOR /*10L*/ expr
	| expr TEXP /*24R*/ expr
	| expr TBY /*9L*/ expr
	| expr TALIGN /*9L*/ expr
	| expr THASH /*9L*/ expr
	| expr TDMAPPED /*23L*/ expr
	;

unary_op_expr :
	TPLUS /*15L*/ expr %prec TUPLUS /*20R*/
	| TMINUS /*15L*/ expr %prec TUMINUS /*20R*/
	| TMINUSMINUS expr %prec TUMINUS /*20R*/
	| TPLUSPLUS expr %prec TUPLUS /*20R*/
	| TBANG /*28L*/ expr %prec TLNOT /*22R*/
	| expr TBANG /*28L*/
	| TBNOT /*22R*/ expr
	;

reduce_expr :
	expr TREDUCE /*23L*/ expr
	| expr TREDUCE /*23L*/ zippered_iterator
	| reduce_scan_op_expr TREDUCE /*23L*/ expr
	| reduce_scan_op_expr TREDUCE /*23L*/ zippered_iterator
	;

scan_expr :
	expr TSCAN /*23L*/ expr
	| expr TSCAN /*23L*/ zippered_iterator
	| reduce_scan_op_expr TSCAN /*23L*/ expr
	| reduce_scan_op_expr TSCAN /*23L*/ zippered_iterator
	;

reduce_scan_op_expr :
	TPLUS /*15L*/
	| TSTAR /*21L*/
	| TAND /*11L*/
	| TOR /*10L*/
	| TBAND /*18L*/
	| TBOR /*16L*/
	| TBXOR /*17L*/
	;

%%

bit              [0-1]
octDigit         [0-7]
digit            [0-9]
hexDigit         [0-9a-fA-F]

letter           [_a-zA-Z]

ident            {letter}({letter}|{digit}|"$")*
queriedIdent     \?{ident}

binaryLiteral    0[bB]{bit}(_|{bit})*
octalLiteral     0[oO]{octDigit}(_|{octDigit})*
decimalLiteral   {digit}(_|{digit})*
hexLiteral       0[xX]{hexDigit}(_|{hexDigit})*
intLiteral       {binaryLiteral}|{octalLiteral}|{decimalLiteral}|{hexLiteral}

digitsOrSeps     {digit}(_|{digit})*
exponent         [Ee][\+\-]?{digitsOrSeps}
floatLiteral1    {digitsOrSeps}?"."{digitsOrSeps}({exponent})?
floatLiteral2    {digitsOrSeps}"."{exponent}
floatLiteral3    {digitsOrSeps}{exponent}

/* hex float literals, have decimal exponents indicating the power of 2 */
hexDigitsOrSeps  {hexDigit}(_|{hexDigit})*
hexDecExponent   [Pp][\+\-]?{digitsOrSeps}
floatLiteral4    0[xX]{hexDigitsOrSeps}?"."{hexDigitsOrSeps}({hexDecExponent})?
floatLiteral5    0[xX]{hexDigitsOrSeps}"."{hexDecExponent}
floatLiteral6    0[xX]{hexDigitsOrSeps}{hexDecExponent}

decFloatLiteral  {floatLiteral1}|{floatLiteral2}|{floatLiteral3}
hexFloatLiteral  {floatLiteral4}|{floatLiteral5}|{floatLiteral6}

floatLiteral     {decFloatLiteral}|{hexFloatLiteral}

dq_string	\"(\\.|[^\r\n\"\\])*\"
sq_string	'(\\.|[^\r\n'\\])*'

%%

align             TALIGN
as                TAS
atomic            TATOMIC
begin             TBEGIN
bool              TBOOL
borrowed          TBORROWED
break             TBREAK
by                TBY
bytes             TBYTES
catch             TCATCH
class             TCLASS
cobegin           TCOBEGIN
coforall          TCOFORALL
complex           TCOMPLEX
config            TCONFIG
const             TCONST
continue          TCONTINUE
defer             TDEFER
delete            TDELETE
dmapped           TDMAPPED
do                TDO
domain            TDOMAIN
else              TELSE
enum              TENUM
export            TEXPORT
except            TEXCEPT
extern           TEXTERN
false             TFALSE
for               TFOR
forall            TFORALL
foreach           TFOREACH
forwarding        TFORWARDING
if                TIF
imag              TIMAG
import            TIMPORT
in                TIN
include           TINCLUDE
index             TINDEX
inline            TINLINE
inout             TINOUT
int               TINT
implements        TIMPLEMENTS
interface         TINTERFACE
iter              TITER
label             TLABEL
lambda            TLAMBDA
let               TLET
lifetime          TLIFETIME
local             TLOCAL
locale            TLOCALE
manage            TMANAGE
module            TMODULE
new               TNEW
nil               TNIL
noinit            TNOINIT
none              TNONE
nothing           TNOTHING
on                TON
only              TONLY
operator          TOPERATOR
otherwise         TOTHERWISE
out               TOUT
override          TOVERRIDE
owned             TOWNED
param             TPARAM
pragma            TPRAGMA
__primitive       TPRIMITIVE
private           TPRIVATE
proc"("           TPROCLP
proc              TPROC
prototype         TPROTOTYPE
public            TPUBLIC
real              TREAL
record            TRECORD
reduce            TREDUCE
ref               TREF
require           TREQUIRE
return            TRETURN
scan              TSCAN
select            TSELECT
serial            TSERIAL
shared            TSHARED
single            TSINGLE
sparse            TSPARSE
string            TSTRING
subdomain         TSUBDOMAIN
sync              TSYNC
then              TTHEN
this              TTHIS
throw             TTHROW
throws            TTHROWS
true              TTRUE
try               TTRY
"try!"            TTRYBANG
type              TTYPE
uint              TUINT
union             TUNION
unmanaged         TUNMANAGED
use               TUSE
var               TVAR
void              TVOID
when              TWHEN
where             TWHERE
while             TWHILE
with              TWITH
yield             TYIELD
zip               TZIP

"@"               TATMARK
"_"               TUNDERSCORE

"="               TASSIGN
"+="              TASSIGNPLUS
"-="              TASSIGNMINUS
"*="              TASSIGNMULTIPLY
"/="              TASSIGNDIVIDE
"**="             TASSIGNEXP
"%="              TASSIGNMOD
"&="              TASSIGNBAND
"|="              TASSIGNBOR
"^="              TASSIGNBXOR
"&&="             TASSIGNLAND
"||="             TASSIGNLOR
"<<="             TASSIGNSL
">>="             TASSIGNSR
"reduce="         TASSIGNREDUCE

"init="           TINITEQUALS

"=>"              TALIAS

"<=>"             TSWAP

"#"               THASH
".."              TDOTDOT
"..<"             TDOTDOTOPENHIGH
                 /* The following cases would extend the current '..<'
                    open range interval constructor to also support
                    '<..' and '<..<'.  This concept didn't win enough
                    support to merge as present, but are here in case
                    we change our minds in a future release. */
                 /* "<.."             TDOTDOTOPENLOW  */
                 /* "<..<"            TDOTDOTOPENBOTH  */
"..."             TDOTDOTDOT

"&&"              TAND
"||"              TOR
"!"               TBANG

"&"               TBAND
"|"               TBOR
"^"               TBXOR
"~"               TBNOT

"<<"              TSHIFTLEFT
">>"              TSHIFTRIGHT

"=="              TEQUAL
"!="              TNOTEQUAL
"<="              TLESSEQUAL
">="              TGREATEREQUAL
"<"               TLESS
">"               TGREATER

"+"               TPLUS
"-"               TMINUS
"*"               TSTAR
"/"               TDIVIDE
"%"               TMOD
"--"              TMINUSMINUS
"++"              TPLUSPLUS

"**"              TEXP

":"               TCOLON
";"               TSEMI
","               TCOMMA
"."               TDOT
"("               TLP
")"               TRP
"["               TLSBR
"]"               TRSBR
/*<externmode>"{"  return processExternCode(yyscanner */
<INITIAL>"{"<.>      TLCBR
"}"               TRCBR
"?"               TQUESTION

{intLiteral}      INTLITERAL
{floatLiteral}    REALLITERAL

{intLiteral}i     IMAGLITERAL
{floatLiteral}i   IMAGLITERAL

{ident}          TIDENT /*processIdentifier false*/
{queriedIdent}   TIDENT /*processIdentifier true*/

"\"\""{dq_string}"\"\""         STRINGLITERAL
"'''"{sq_string}"'''"            STRINGLITERAL
"b\"\""{dq_string}"\"\""        BYTESLITERAL
"b''"{sq_string}"''"           BYTESLITERAL
{dq_string}             STRINGLITERAL
{sq_string}              STRINGLITERAL
b{dq_string}            BYTESLITERAL
b{sq_string}            BYTESLITERAL
c{dq_string}            CSTRINGLITERAL
c{sq_string}             CSTRINGLITERAL
"//"[^\n\r]*             skip()
"/*"(?s:.)*?"*/"             skip()

\n               skip()

[ \t\r\f]        skip()
.                ILLEGAL_CHARACTHER

%%
