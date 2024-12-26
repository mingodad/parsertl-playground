//From: https://github.com/coccinelle/coccinelle/blob/0e82e2d4b96d4b359f36a8e2b8636c39ae414e55/parsing_c/parser_c.mly
/* Yoann Padioleau
 *
 * Copyright (C) 2002, 2006, 2007, 2008, 2009 Yoann Padioleau
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License (GPL)
 * version 2 as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * file license.txt for more details.
 */

/**
 * This grammar has been inspired by:
 * http://www.lysator.liu.se/c/ANSI-C-grammar-y.html
 */

%token TAction
%token TAnd
%token TAndLog
%token TAssign
%token TBang
%token TCBrace
%token TCCro
%token TCPar
%token TCParEOL
%token TChar
%token TColonColon
%token TComma
%token TCppConcatOp
%token TCppDirectiveOther
%token TDec
%token TDecimal
%token TDefEOL
%token TDefine
%token TDiv
%token TDot
%token TDotDot
%token TEllipsis
%token TEndif
%token TEq
%token TEqEq
%token TFloat
%token TFormat
%token TIdent
%token TIdentDefine
%token TIfdef
%token TIfdefBool
%token TIfdefMisc
%token TIfdefVersion
%token TIfdefelif
%token TIfdefelse
%token TInc
%token TIncludeFilename
%token TIncludeStart
%token TInf
%token TInf3
%token TInfEq
%token TInt
%token TKRParam
%token TMacroAttr
%token TMacroAttrArgs
%token TMacroDecl
%token TMacroIdStmt
%token TMacroIdentBuilder
%token TMacroIterator
%token TMacroStmt
%token TMacroString
%token TMax
%token TMin
%token TMinus
%token TMod
%token TMul
%token TNoComma
%token TNotEq
%token TOBrace
%token TOBraceDefineInit
%token TOCro
%token TOCroCro
%token TOPar
%token TOParCplusplusInit
%token TOParDefine
%token TOr
%token TOrLog
%token TPct
%token TPlus
%token TPragma
%token TPragmaString
%token TPtVirg
%token TPtrOp
%token TQualExp
%token TQualId
%token TQualType
%token TQuote
%token TShl
%token TShr
%token TString
%token TSubString
%token TSup
%token TSup3
%token TSupEq
%token TTemplateEnd
%token TTemplateStart
%token TTilde
%token TUelseif
%token TUendif
%token TUifdef
%token TUndef
%token TWhy
%token TXor
%token Talignas
%token Tasm
%token Tattribute
%token TattributeNoarg
%token Tauto
%token TautoType
%token Tbreak
%token Tcase
%token Tcatch
%token Tchar
%token Tclass
%token Tcomplex
%token Tconst
%token Tconstructorname
%token Tcontinue
%token Tcpp_struct
%token Tcpp_union
%token Tdecimal
%token Tdefault
%token Tdefined
%token Tdelete
%token Tdo
%token Tdouble
%token Telse
%token Tenum
%token Texec
%token Textern
%token Tfinal
%token Tfloat
%token Tfor
%token Tgoto
%token Tif
%token Tinline
%token Tint
%token Tlong
%token Tnamespace
%token Tnew
%token Toperator
%token Tprivate
%token Tprotected
%token Tptrdiff_t
%token Tpublic
%token Tregister
%token Trestrict
%token Treturn
%token Tshort
%token Tsigned
%token Tsize_t
%token Tsizeof
%token Tssize_t
%token Tstatic
%token Tstruct
%token Tswitch
%token Ttemplate
%token Ttry
%token Ttypedef
%token Ttypename
%token Ttypeof
%token Tunion
%token Tunsigned
%token Tusing
%token Tvirtual
%token Tvoid
%token Tvolatile
%token Twhile
%token TypedefIdent

%nonassoc SHIFTHERE
%nonassoc Telse
%left TOrLog
%left TAndLog
%left TOr
%left TXor
%left TAnd
%left TEqEq TNotEq
%left TInf TInfEq TSup TSupEq
%left TShl TShr
%left TMinus TPlus
%left TDiv TMax TMin TMod TMul

%%

main :
	translation_unit //EOF
	;

translation_unit :
	/*empty*/
	| translation_unit external_declaration
	| translation_unit Tnamespace TIdent TOBrace translation_unit TCBrace
	| translation_unit Tnamespace TOBrace translation_unit TCBrace
	;

ident :
	TIdent
	| TypedefIdent
	;

identifier :
	TIdent
	;

identifier_cpp :
	TIdent
	| ident_extra_cpp
	;

ident_cpp :
	TIdent
	| TypedefIdent
	| ident_extra_cpp
	;

ident_extra_cpp :
	TIdent TCppConcatOp identifier_cpp_list
	| TCppConcatOp TIdent
	| TMacroIdentBuilder TOPar param_define_list TCPar
	| TQualId qual_id
	;

identifier_cpp_list :
	ident_or_kwd
	| identifier_cpp_list TCppConcatOp ident_or_kwd
	;

qual_id :
	ident
	| TColonColon ident
	| qual_id TColonColon ident
	;

ident_or_kwd :
	TIdent
	| Talignas
	| Tasm
	| Tattribute
	| TattributeNoarg
	| Tauto
	| TautoType
	| Tbreak
	| Tcase
	| Tchar
	| Tclass
	| Tcomplex
	| Tconst
	| Tcontinue
	| Tcpp_struct
	| Tcpp_union
	| Tdecimal
	| Tdefault
	| Tdelete
	| Tdo
	| Ttry
	| Tdouble
	| Telse
	| Tenum
	| Texec
	| Textern
	| Tfinal
	| Tvirtual
	| Tfloat
	| Tfor
	| Tgoto
	| Tif
	| Tinline
	| Tint
	| Tlong
	| TMacroAttr
	| Tnamespace
	| Tnew
	| Toperator
	| Tprivate
	| Tprotected
	| Tptrdiff_t
	| Tpublic
	| Tregister
	| Trestrict
	| Treturn
	| Tshort
	| Tsigned
	| Tsizeof
	| Tsize_t
	| Tssize_t
	| Tstatic
	| Tstruct
	| Tswitch
	| Ttemplate
	| Ttypedef
	| Ttypename
	| Ttypeof
	| Tunion
	| Tunsigned
	| Tusing
	| Tvoid
	| Tvolatile
	| Twhile
	;

expr :
	assign_expr
	| expr TComma assign_expr
	;

assign_expr :
	cond_expr
	| unary_expr TAssign assign_expr
	| unary_expr TEq assign_expr
	| unary_expr TAssign tuple_expr
	| unary_expr TEq tuple_expr
	;

cond_expr :
	arith_expr
	| arith_expr TWhy gcc_opt_expr TDotDot cond_expr
	| Tnew cpp_type cpp_initialiser_opt
	| Tnew placement_params cpp_type cpp_initialiser_opt
	;

placement_params :
	TOPar argument_list_ne_without_paramdecl TCPar
	;

cpp_initialiser_opt :
	TOPar argument_list TCPar
	| TOBrace argument_list TCBrace
	|
	;

cpp_type :
	TOPar simple_type TCPar
	| cpp_type_noparen
	;

cpp_type_noparen :
	simple_type
	| identifier_cpp
	;

arith_expr :
	cast_expr
	| arith_expr TMul arith_expr
	| arith_expr TDiv arith_expr
	| arith_expr TMin arith_expr
	| arith_expr TMax arith_expr
	| arith_expr TMod arith_expr
	| arith_expr TPlus arith_expr
	| arith_expr TMinus arith_expr
	| arith_expr TShl arith_expr
	| arith_expr TShr arith_expr
	| arith_expr TInf arith_expr
	| arith_expr TSup arith_expr
	| arith_expr TInfEq arith_expr
	| arith_expr TSupEq arith_expr
	| arith_expr TEqEq arith_expr
	| arith_expr TNotEq arith_expr
	| arith_expr TAnd arith_expr
	| arith_expr TOr arith_expr
	| arith_expr TXor arith_expr
	| arith_expr TAndLog arith_expr
	| arith_expr TOrLog arith_expr
	;

arith_expr_nosup :
	cast_expr
	| arith_expr_nosup TMul arith_expr_nosup
	| arith_expr_nosup TDiv arith_expr_nosup
	| arith_expr_nosup TMin arith_expr_nosup
	| arith_expr_nosup TMax arith_expr_nosup
	| arith_expr_nosup TMod arith_expr_nosup
	| arith_expr_nosup TPlus arith_expr_nosup
	| arith_expr_nosup TMinus arith_expr_nosup
	| arith_expr_nosup TShl arith_expr_nosup
	| arith_expr_nosup TShr arith_expr_nosup
	| arith_expr_nosup TInf arith_expr_nosup
	| arith_expr_nosup TInfEq arith_expr_nosup
	| arith_expr_nosup TSupEq arith_expr_nosup
	| arith_expr_nosup TEqEq arith_expr_nosup
	| arith_expr_nosup TNotEq arith_expr_nosup
	| arith_expr_nosup TAnd arith_expr_nosup
	| arith_expr_nosup TOr arith_expr_nosup
	| arith_expr_nosup TXor arith_expr_nosup
	| arith_expr_nosup TAndLog arith_expr_nosup
	| arith_expr_nosup TOrLog arith_expr_nosup
	;

cast_expr :
	unary_expr
	| topar2 type_name tcpar2 cast_expr
	;

unary_expr :
	postfix_expr
	| TInc unary_expr
	| TDec unary_expr
	| unary_op cast_expr
	| Tsizeof unary_expr
	| Tsizeof topar2 type_name tcpar2
	| Tdelete cast_expr
	| Tdelete TOCro TCCro cast_expr
	| Tdefined identifier_cpp
	| Tdefined TOPar identifier_cpp TCPar
	;

unary_op :
	TAnd
	| TMul
	| TPlus
	| TMinus
	| TTilde
	| TBang
	| TAndLog
	;

postfix_expr :
	primary_expr
	| TQualExp qual_type
	| postfix_expr TOCro argument_list_ne TCCro
	| postfix_expr TOPar argument_list TCPar
	| postfix_expr TInf3 argument_list TSup3
	| postfix_expr TDot ident_cpp
	| postfix_expr TPtrOp ident_cpp
	| postfix_expr TInc
	| postfix_expr TDec
	| topar2 type_name tcpar2 TOBrace outer_initialize_list TCBrace
	;

primary_expr_without_ident :
	TInt
	| TFloat
	| TString
	| TQuote string_fragments TQuote
	| TChar
	| TDecimal
	| TOPar expr TCPar
	| TMacroString
	| string_elem string_list
	| TOPar compound TCPar
	;

primary_expr :
	identifier_cpp
	| primary_expr_without_ident
	;

string_fragments :
	/*empty*/
	| string_fragment string_fragments
	;

string_fragment :
	TPct string_format
	| TSubString
	;

string_format :
	TFormat
	;

argument_ne :
	assign_expr
	| tuple_expr
	| parameter_decl_arg
	| action_higherordermacro_ne
	;

argument_ne_without_paramdecl :
	primary_expr_without_ident
	| action_higherordermacro_ne
	;

argument :
	assign_expr
	| tuple_expr
	| parameter_decl_arg
	| action_higherordermacro
	;

action_higherordermacro_ne :
	taction_list_ne
	;

action_higherordermacro :
	taction_list
	;

const_expr :
	cond_expr
	;

topar2 :
	TOPar
	;

tcpar2 :
	TCPar
	;

statement :
	statement2
	;

statement2 :
	labeled
	| compound
	| expr_statement
	| selection
	| iteration
	| jump TPtVirg
	| Tasm TOPar asmbody TCPar TPtVirg
	| Tasm Tvolatile TOPar asmbody TCPar TPtVirg
	| TMacroStmt TOPar macro_argument_list TCPar
	| TMacroIdStmt
	| Texec identifier exec_list TPtVirg
	;

labeled :
	ident_cpp TDotDot sw_stat_or_decl
	| Tcase const_expr TDotDot sw_stat_or_decl
	| Tcase const_expr TEllipsis const_expr TDotDot sw_stat_or_decl
	| Tdefault TDotDot sw_stat_or_decl
	;

sw_stat_or_decl :
	decl
	| statement
	;

end_labeled :
	ident_cpp TDotDot
	| Tcase const_expr TDotDot
	| Tdefault TDotDot
	;

compound :
	tobrace compound2 tcbrace
	;

compound2 :
	/*empty*/
	| stat_or_decl_list
	;

stat_or_decl_list :
	stat_or_decl
	| end_labeled
	| stat_or_decl stat_or_decl_list
	;

stat_or_decl :
	decl
	| statement
	| function_definition
	| cpp_directive
	| cpp_ifdef_directive
	;

expr_statement :
	TPtVirg
	| expr TPtVirg
	;

handler :
	Tcatch TOPar parameter_decl TCPar compound
	;

handler_sequence :
	handler
	| handler_sequence handler
	;

selection :
	Tif TOPar expr TCPar cpp_ifdef_statement %prec SHIFTHERE
	| Tif TOPar expr TCPar cpp_ifdef_statement Telse cpp_ifdef_statement
	| Tswitch TOPar expr TCPar statement
	| TUifdef Tif TOPar expr TCPar statement Telse TUendif statement
	| TUifdef Tif TOPar expr TCPar statement Telse TUelseif statement TUendif statement
	| Ttry compound handler_sequence
	;

iteration :
	Twhile TOPar expr TCPar cpp_ifdef_statement
	| Twhile TOPar decl_spec init_declarator_list TCPar cpp_ifdef_statement
	| Tdo statement Twhile TOPar expr TCPar TPtVirg
	| Tfor TOPar expr_statement expr_statement TCPar cpp_ifdef_statement
	| Tfor TOPar expr_statement expr_statement expr TCPar cpp_ifdef_statement
	| Tfor TOPar decl expr_statement TCPar cpp_ifdef_statement
	| Tfor TOPar decl expr_statement expr TCPar cpp_ifdef_statement
	| Tfor TOPar decl_spec declaratorifn TDotDot initialize TCPar cpp_ifdef_statement
	| TMacroIterator TOPar argument_list TCPar cpp_ifdef_statement
	;

jump :
	Tgoto ident_cpp
	| Tcontinue
	| Tbreak
	| Treturn
	| Treturn expr
	| Treturn tuple_expr
	| Tgoto TMul expr
	;

tuple_expr :
	TOBrace outer_initialize_list TCBrace
	;

string_elem :
	TQuote string_fragments TQuote
	| TString
	| TMacroString
	;

asmbody :
	string_list colon_asm_list
	| string_list
	;

colon_asm :
	TDotDot colon_option_list
	;

colon_option :
	TString
	| TString TOPar asm_expr TCPar
	| TOCro identifier TCCro TString TOPar asm_expr TCPar
	| identifier
	|
	;

exec_list :
	/*empty*/
	| TDotDot identifier_cpp exec_ident exec_list
	| TIdent exec_ident2 exec_list
	| token exec_list
	;

exec_ident :
	/*empty*/
	| TDot TIdent exec_ident
	| TPtrOp TIdent exec_ident
	| TOCro argument_list_ne TCCro exec_ident
	;

exec_ident2 :
	/*empty*/
	| TDot TIdent exec_ident2
	;

asm_expr :
	assign_expr
	;

token :
	TPlus
	| TMinus
	| TMul
	| TDiv
	| TMod
	| TMin
	| TMax
	| TInc
	| TDec
	| TEq
	| TAssign
	| TEqEq
	| TNotEq
	| TSupEq
	| TInfEq
	| TSup
	| TInf
	| TAndLog
	| TOrLog
	| TShr
	| TShl
	| TAnd
	| TOr
	| TXor
	| TOBrace
	| TCBrace
	| TOPar
	| TCPar
	| TWhy
	| TBang
	| TComma
	| TypedefIdent
	| Tif
	| Telse
	| TInt
	| TFloat
	| TString
	| TChar
	;

simple_type :
	Tvoid
	| Tchar
	| Tint
	| Tfloat
	| Tdouble
	| Tcomplex
	| Tsize_t
	| Tssize_t
	| Tptrdiff_t
	| Tshort
	| Tlong
	| Tsigned
	| Tunsigned
	| Tdecimal TOPar const_expr TComma const_expr TCPar
	| Tdecimal TOPar const_expr TCPar
	| TautoType
	| Ttypeof TOPar assign_expr TCPar
	| Ttypeof TOPar type_name TCPar
	| TypedefIdent
	| TQualType qual_type
	;

qual_type :
	ident
	| qual_type TColonColon ident
	| TColonColon ident
	| qual_type TTemplateStart argument_list TTemplateEnd
	;

type_spec2_without_braces :
	simple_type
	| enum_ident_independant
	;

type_spec2_with_braces :
	struct_or_union_spec
	| enum_spec
	;

type_spec :
	type_spec2_without_braces
	| type_spec2_with_braces
	;

type_qualif :
	Tconst
	| Tvolatile
	| Trestrict
	;

attribute :
	attribute_gcc
	| attr_arg
	;

attr_arg :
	TMacroAttr
	| TMacroAttrArgs TOPar argument_list TCPar
	| TMacroAttrArgs TOPar argument_list TCParEOL
	;

attribute_gcc :
	Tattribute tdouble_opar_gcc_attr argument_list tdouble_cpar_gcc_attr
	| tdouble_ocro_cxx_attr argument_list tdouble_ccro_cxx_attr
	| tdouble_ocro_cxx_attr Tusing ident_cpp TDotDot argument_list tdouble_ccro_cxx_attr
	;

declarator :
	pointer direct_d
	| direct_d
	;

declarator_fn :
	pointer direct_d_fn
	| direct_d_fn
	;

pointer :
	tmul type_qualif_list
	| tmul type_qualif_list pointer
	;

tmul :
	TMul
	| TAnd
	| TAndLog
	;

direct_d :
	identifier_cpp
	| operator_c_plus_plus
	| TOPar declarator TCPar
	| direct_d tocro tccro
	| direct_d tocro const_expr tccro
	;

direct_d_fn :
	direct_d topar parameter_type_list tcpar
	;

operator_c_plus_plus :
	Toperator unary_op
	| Toperator TInc
	| Toperator TDec
	| Toperator Tdelete
	| Toperator Tnew
	| Toperator TDiv
	| Toperator TMin
	| Toperator TMax
	| Toperator TMod
	| Toperator TShl
	| Toperator TShr
	| Toperator TInf
	| Toperator TSup
	| Toperator TInfEq
	| Toperator TSupEq
	| Toperator TEqEq
	| Toperator TNotEq
	| Toperator TOr
	| Toperator TXor
	| Toperator TOrLog
	| Toperator TOCro TCCro
	| Toperator TOPar TCPar
	| Toperator TAssign
	| Toperator TEq
	;

tocro :
	TOCro
	;

tccro :
	TCCro
	;

abstract_declarator :
	pointer
	| direct_abstract_declarator
	| pointer direct_abstract_declarator
	;

direct_abstract_declarator :
	TOPar abstract_declarator TCPar
	| TOCro TCCro
	| TOCro const_expr TCCro
	| direct_abstract_declarator TOCro TCCro
	| direct_abstract_declarator TOCro const_expr TCCro
	| topar parameter_type_list tcpar
	| direct_abstract_declarator topar parameter_type_list tcpar
	;

parameter_type_list :
	/*empty*/
	| parameter_list
	| parameter_list TComma TEllipsis
	;

parameter_decl2 :
	TKRParam
	| decl_spec declaratorp
	| decl_spec abstract_declaratorp
	| decl_spec
	;

parameter_decl_arg :
	TKRParam
	| decl_spec declaratorp
	| decl_spec abstract_declaratorp
	| decl_spec
	;

template_parameter_decl2 :
	Ttypename ident
	| Ttypename ident TEq type_spec
	| Tclass ident
	| Tclass ident TEq type_spec
	| type_spec2_without_braces declaratorp
	| type_spec2_without_braces declaratorp TEq initialize_arg
	| Tconst type_spec2_without_braces declaratorp
	| Tconst type_spec2_without_braces declaratorp TEq initialize_arg
	| Ttemplate TTemplateStart template_parameter_list_ne TTemplateEnd template_parameter_decl2
	;

parameter_decl :
	parameter_decl2
	;

template_parameter_decl :
	template_parameter_decl2
	;

declaratorp :
	declarator attributes_opt
	| declarator_fn attributes_opt
	;

abstract_declaratorp :
	abstract_declarator
	;

spec_qualif_list2 :
	type_spec
	| type_qualif
	| attribute
	| type_spec spec_qualif_list
	| type_qualif spec_qualif_list
	| attribute spec_qualif_list
	;

spec_qualif_list :
	spec_qualif_list2
	;

type_qualif_list :
	/*empty*/
	| type_qualif_list type_qualif
	| type_qualif_list attribute
	;

type_name :
	spec_qualif_list
	| spec_qualif_list abstract_declaratort
	;

abstract_declaratort :
	abstract_declarator
	;

decl2 :
	decl_spec TPtVirg
	| decl_spec init_declarator_list TPtVirg
	| TMacroDecl TOPar macro_argument_list TCPar attributes_opt TPtVirg
	| TMacroDecl TOPar macro_argument_list TCPar attributes_opt teq initialize TPtVirg
	| decl_spec TMacroDecl TOPar macro_argument_list TCPar attributes_opt TPtVirg
	| decl_spec TMacroDecl TOPar macro_argument_list TCPar attributes_opt teq initialize TPtVirg
	;

decl_spec2 :
	storage_class_spec
	| type_spec
	| type_qualif
	| Tinline
	| align_class_prod
	| attribute
	| storage_class_spec decl_spec2
	| type_qualif decl_spec2
	| align_class_prod decl_spec2
	| Tinline decl_spec2
	| attribute decl_spec2
	| type_spec decl_spec2
	;

align_class_prod :
	Talignas TOPar argument TCPar
	;

storage_class_spec_nt :
	Tstatic
	| Textern
	| Tauto
	| Tregister
	;

storage_class_spec :
	storage_class_spec_nt
	| Ttypedef
	;

decl :
	decl2
	;

decl_spec :
	decl_spec2
	;

init_declarator2 :
	declaratorifn
	| declaratorifn teq initialize
	| declaratori topar_ini_cxx valinit tcpar_ini
	| declaratori tobrace_ini valinit tcbrace_ini
	;

init_declarator_attrs2 :
	declaratorifn
	| attributes declaratorifn
	| declaratorifn teq initialize
	| attributes declaratorifn teq initialize
	| declaratori topar_ini_cxx valinit tcpar_ini
	| attributes declaratori topar_ini_cxx valinit tcpar_ini
	| declaratori tobrace_ini valinit tcbrace_ini
	| attributes declaratori tobrace_ini valinit tcbrace_ini
	;

teq :
	TEq
	;

init_declarator :
	init_declarator2
	;

init_declarator_attrs :
	init_declarator_attrs2
	;

declaratori :
	declarator attributes_opt
	| declarator gcc_asm_decl
	;

declaratorifn :
	declarator attributes_opt
	| declarator gcc_asm_decl
	| declarator_fn attributes_opt
	| declarator_fn gcc_asm_decl
	;

gcc_asm_decl :
	Tasm TOPar asmbody TCPar
	| Tasm Tvolatile TOPar asmbody TCPar
	;

initialize :
	assign_expr
	| tobrace_ini outer_initialize_list tcbrace_ini
	;

initialize_arg :
	arith_expr_nosup
	| tobrace_ini outer_initialize_list tcbrace_ini
	;

initialize_list :
	initialize2
	| initialize_list TComma initialize2
	| initialize_list TNoComma initialize2
	;

outer_initialize_list :
	/*empty*/
	| initialize_list gcc_comma_opt_struct
	;

valinit :
	outer_initialize_list
	;

initialize2 :
	cond_expr
	| tobrace_ini outer_initialize_list tcbrace_ini
	| designator_list TEq initialize2
	| ident TDotDot initialize2
	;

designator :
	TDot ident
	| TOCro const_expr TCCro
	| TOCro const_expr TEllipsis const_expr TCCro
	;

gcc_comma_opt_struct :
	TComma
	| TNoComma
	|
	;

s_or_u_spec2 :
	cpp_struct_or_union ident optfinal TDotDot base_classes tobrace_struct cpp_struct_decl_list_gcc tcbrace_struct
	| cpp_struct_or_union ident optfinal tobrace_struct cpp_struct_decl_list_gcc tcbrace_struct
	| struct_or_union ident tobrace_struct struct_decl_list_gcc tcbrace_struct
	| cpp_struct_or_union TDotDot base_classes tobrace_struct cpp_struct_decl_list_gcc tcbrace_struct
	| cpp_struct_or_union tobrace_struct cpp_struct_decl_list_gcc tcbrace_struct
	| struct_or_union tobrace_struct struct_decl_list_gcc tcbrace_struct
	| struct_or_union ident
	| cpp_struct_or_union ident
	;

struct_or_union2 :
	Tstruct
	| Tunion
	| Tstruct attributes
	| Tunion attributes
	;

cpp_struct_or_union2 :
	Tcpp_struct
	| Tcpp_union
	| Tclass
	| Tcpp_struct attributes
	| Tcpp_union attributes
	| Tclass attributes
	;

struct_decl2 :
	field_declaration
	| TPtVirg
	| identifier TOPar macro_argument_list TCPar attributes_opt TPtVirg
	| TMacroDecl TOPar macro_argument_list TCPar attributes_opt TPtVirg
	| cpp_directive
	| cpp_ifdef_directive
	;

cpp_struct_decl2 :
	function_definition
	| decl
	| TPtVirg
	| c_plus_plus_constructor_decl
	| cpp_directive
	| cpp_ifdef_directive
	| Tpublic TDotDot
	| Tprotected TDotDot
	| Tprivate TDotDot
	;

c_plus_plus_constructor_decl :
	pre_member_function identifier TOPar parameter_type_list TCPar constr_inits post_constructor TPtVirg
	| pre_member_function TTilde identifier TOPar parameter_type_list TCPar post_constructor TPtVirg
	| pre_member_function identifier TOPar parameter_type_list TCPar constr_inits post_constructor compound
	| pre_member_function TTilde identifier TOPar parameter_type_list TCPar post_constructor compound
	;

constr_inits :
	TDotDot constructor_init_list
	|
	;

constructor_init_list :
	constructor_init
	| constructor_init_list TComma constructor_init
	;

constructor_init :
	ident_cpp TOPar argument_list TCPar
	| ident_cpp TOBrace argument_list TCBrace
	;

pre_member_function :
	Tvirtual
	|
	;

post_constructor :
	Tfinal
	|
	;

optfinal :
	Tfinal
	|
	;

field_declaration :
	decl_spec struct_declarator_list TPtVirg
	| decl_spec TPtVirg
	| simple_type dotdot const_expr2 TPtVirg
	;

struct_declarator :
	declarator attributes_opt
	| declarator dotdot const_expr2
	| declarator_fn attributes_opt
	| declarator_fn dotdot const_expr2
	;

struct_or_union_spec :
	s_or_u_spec2
	;

struct_or_union :
	struct_or_union2
	;

cpp_struct_or_union :
	cpp_struct_or_union2
	;

struct_decl :
	struct_decl2
	;

cpp_struct_decl :
	cpp_struct_decl2
	;

dotdot :
	TDotDot
	;

const_expr2 :
	const_expr
	;

struct_decl_list_gcc :
	struct_decl_list
	|
	;

cpp_struct_decl_list_gcc :
	cpp_struct_decl_list
	|
	;

enum_spec :
	enum_ident enum_base tobrace_enum enumerator_list gcc_comma_opt_struct tcbrace_enum
	;

enum_ident_independant :
	Tenum enum_key ident
	| Tenum ident
	;

enum_ident_dependant :
	Tenum enum_key
	| Tenum
	;

enum_ident :
	enum_ident_independant
	| enum_ident_dependant
	;

enum_base :
	TDotDot simple_type
	|
	;

enum_key :
	Tcpp_struct
	| Tclass
	;

enumerator :
	idente
	| idente TEq const_expr
	;

idente :
	ident_cpp
	;

function_definition :
	function_def
	;

cpp_directive_list :
	cpp_directive
	| cpp_directive_list cpp_directive
	;

function_def :
	start_fun compound
	| start_fun cpp_directive_list compound
	;

start_fun :
	start_fun2
	;

start_fun2 :
	decl_spec declaratorfd
	| ctor_dtor
	;

ctor_dtor :
	Tconstructorname topar parameter_type_list tcpar
	| Tconstructorname topar parameter_type_list tcpar TDotDot constr_extra_list
	;

constr_extra :
	TIdent TOPar argument_list TCPar
	| TypedefIdent TOPar argument_list TCPar
	;

declaratorfd :
	declarator_fn attributes_opt
	;

cpp_directive :
	TIncludeStart TIncludeFilename
	| TDefine TIdentDefine define_val TDefEOL
	| TDefine TIdentDefine TOParDefine call_param_define_list TCPar define_val TDefEOL
	| TUndef TIdentDefine TDefEOL
	| TPragma TIdent pragma_strings TDefEOL
	| TCppDirectiveOther
	| Tusing TIdent TEq Ttypename cpp_type_noparen TPtVirg
	| Tusing TIdent TEq cpp_type_noparen TPtVirg
	| Tusing TypedefIdent TEq Ttypename cpp_type_noparen TPtVirg
	| Tusing TypedefIdent TEq cpp_type_noparen TPtVirg
	| Tusing identifier_cpp TPtVirg
	| Tusing Tnamespace identifier_cpp TPtVirg
	;

pragma_strings :
	TPragmaString
	;

define_val :
	expr
	| statement
	| decl
	| decl_spec
	| decl_spec abstract_declarator
	| stat_or_decl stat_or_decl_list
	| function_definition
	| TOBraceDefineInit outer_initialize_list TCBrace comma_opt
	| Tdo statement Twhile TOPar expr TCPar
	| Tasm TOPar asmbody TCPar
	| Tasm Tvolatile TOPar asmbody TCPar
	| designator_list TEq initialize2 gcc_comma_opt_struct
	| designator_list TEq initialize2 TComma initialize_list gcc_comma_opt_struct
	|
	;

param_define :
	TIdent
	| TypedefIdent
	| TEllipsis
	| TIdent TEllipsis
	| TypedefIdent TEllipsis
	| Tregister
	;

cpp_ifdef_statement :
	ifdef cpp_ifdef_statement cpp_ifdef_statement_tail
	| statement
	;

cpp_ifdef_statement_tail :
	ifdefelse cpp_ifdef_statement endif
	| ifdefelif cpp_ifdef_statement cpp_ifdef_statement_tail
	;

ifdef :
	TIfdef
	;

ifdefelse :
	TIfdefelse
	;

ifdefelif :
	TIfdefelif
	;

endif :
	TEndif
	;

cpp_ifdef_directive :
	ifdef
	| ifdefelse
	| ifdefelif
	| endif
	| TIfdefBool
	| TIfdefMisc
	| TIfdefVersion
	;
/*
cpp_other :
	identifier TOPar macro_argument_list TCPar attributes_opt TPtVirg
	| identifier TOPar macro_argument_list TCPar compound
	| identifier TOPar macro_argument_list TCParEOL
	| identifier TPtVirg
	;
*/
external_declaration :
	Ttemplate TTemplateStart template_parameter_list_ne TTemplateEnd external_declaration
	| function_definition
	| decl
	;
/*
celem :
	Tnamespace ident TOBrace translation_unit TCBrace
	| Tnamespace TOBrace translation_unit TCBrace
	| external_declaration
	| cpp_directive
	| cpp_other
	| cpp_ifdef_directive
	| Tasm TOPar asmbody TCPar TPtVirg
	| TPtVirg
	| EOF
	;
*/
base_class :
	base_class_name
	| Tpublic base_class_name
	| Tprotected base_class_name
	| Tprivate base_class_name
	;

base_class_name :
	ident_cpp
	;

base_classes :
	base_class
	| base_classes TComma base_class
	;

tobrace :
	TOBrace
	;

tcbrace :
	TCBrace
	;

tobrace_enum :
	TOBrace
	;

tcbrace_enum :
	TCBrace
	;

tobrace_ini :
	TOBrace
	;

tcbrace_ini :
	TCBrace
	;

topar_ini_cxx :
	TOParCplusplusInit
	;

tcpar_ini :
	TCPar
	;

tobrace_struct :
	TOBrace
	;

tcbrace_struct :
	TCBrace
	;

call_param_define_list :
	param_define_list
	;

topar :
	TOPar
	;

tcpar :
	TCPar
	;

tdouble_opar_gcc_attr :
	TOPar TOPar
	;

tdouble_cpar_gcc_attr :
	TCPar TCPar
	;

tdouble_ocro_cxx_attr :
	TOCroCro
	;

tdouble_ccro_cxx_attr :
	TCCro TCCro
	;

string_list :
	string_elem
	| string_list string_elem
	;

colon_asm_list :
	colon_asm
	| colon_asm_list colon_asm
	;

colon_option_list :
	colon_option
	| colon_option_list TComma colon_option
	;

constr_extra_list :
	constr_extra
	| constr_extra_list TComma constr_extra
	;

argument_list :
	/*empty*/
	| argument_list_ne
	;

argument_list_ne :
	argument_ne
	| argument_list_ne TComma argument
	;

argument_list_ne_without_paramdecl :
	argument_ne_without_paramdecl
	| argument_list_ne TComma argument_ne_without_paramdecl
	;

macro_argument_list :
	argument
	| macro_argument_list TComma argument
	;

struct_decl_list :
	struct_decl
	| struct_decl_list struct_decl
	;

cpp_struct_decl_list :
	cpp_struct_decl
	| cpp_struct_decl_list cpp_struct_decl
	;

struct_declarator_list :
	struct_declarator
	| struct_declarator_list TComma cpp_directive_list struct_declarator
	| struct_declarator_list TComma struct_declarator
	;

enumerator_list :
	enumerator
	| enumerator_list TComma cpp_directive_list enumerator
	| enumerator_list TComma enumerator
	|
	;

init_declarator_list :
	init_declarator
	| init_declarator_list TComma cpp_directive_list init_declarator_attrs
	| init_declarator_list TComma init_declarator_attrs
	;

parameter_list :
	parameter_decl
	| parameter_list TComma parameter_decl
	;

template_parameter_list_ne :
	template_parameter_decl
	| template_parameter_list_ne TComma template_parameter_decl
	;

taction_list_ne :
	TAction
	| TAction taction_list_ne
	;

taction_list :
	/*empty*/
	| TAction taction_list
	;

param_define_list :
	/*empty*/
	| param_define
	| param_define_list TComma param_define
	;

designator_list :
	designator
	| designator_list designator
	;

attribute_list :
	attribute
	| attribute_list attribute
	;

attributes :
	attribute_list
	;

attributes_opt :
	attribute_list
	|
	;

comma_opt :
	TComma
	|
	;

gcc_opt_expr :
	expr
	|
	;

%%

letter   [A-Za-z_]
digit    [0-9]

cplusplus_ident   ({letter}|"$")({letter}|{digit}|"$")*

/* not used for the moment */
punctuation   [!\"#%&\'()*+,-./:;<=>?[\]^{|}~]
space   [ \t\n\r\011\012]
additionnal   [ \b\t\011\n\r\007]
/* 7   \a   bell in C. this is not the only char allowed !!
 * ex @ and $ ` are valid too
 */

cchar   ({letter}|{digit}|{punctuation}|{additionnal})

sp   [ \t]
//spopt   [ \t]*

dec   [0-9]
oct   [0-7]
hex   [0-9a-fA-F]

decimal   ("0"|([1-9]{dec}*))
octal     [0]{oct}+
hexa      ("0x"|"0X"){hex}+


pent     {dec}+
pfract   {dec}+
sign   [-+]
exp    [eE]{sign}?{dec}+
real   {pent}{exp}|(({pent}?"."{pfract}|{pent}"."{pfract}?){exp}?)
ddecimal   (({pent}?"."{pfract}|{pent}"."{pfract}?))

id   {letter}({letter}|{digit})*

%%

[ \t\r\n]+ skip()
"//".*  skip()
"/*"(?s:.)*?"*/"    skip()

//EOF	EOF
TAction	TAction
alignas	Talignas
"&"	TAnd
"&&"	TAndLog
"asm"|"__asm"|"__asm__"	Tasm
"-="|"+="|"*="|"/="|"%="|"&="|"and_eq"|"|="|"or_eq"|"^="|"xor_eq"|"<<="|">>="|">?="|"<?="	TAssign
"__attribute__"|"__attribute"	Tattribute
auto	Tauto
TautoType	TautoType
"!"	TBang
break	Tbreak
case	Tcase
catch	Tcatch
"%>"	TCBrace
"}"	TCBrace
":>"	TCCro
"]"	TCCro
char	Tchar
'(\\.|[^'\r\n\\])?'	TChar
class	Tclass
"::"	TColonColon
","	TComma
complex	Tcomplex
const	Tconst
Tconstructorname	Tconstructorname
continue	Tcontinue
")"	TCPar
TCParEOL	TCParEOL
TCppConcatOp	TCppConcatOp
TCppDirectiveOther	TCppDirectiveOther
Tcpp_struct	Tcpp_struct
Tcpp_union	Tcpp_union
"--"	TDec
Tdecimal	Tdecimal
TDecimal	TDecimal
default	Tdefault
TDefEOL	TDefEOL
TDefine	TDefine
Tdefined	Tdefined
delete	Tdelete
"/"	TDiv
do	Tdo
"."	TDot
":"	TDotDot
double	Tdouble
"..."	TEllipsis
else	Telse
TEndif	TEndif
enum	Tenum
"="	TEq
"=="	TEqEq
Texec	Texec
//"__extension__" TattributeNoarg /* found a lot in expanded code */
extern	Textern
final	Tfinal
float	Tfloat
{real}[fF]	TFloat
{real}[lL]	TFloat
{real}	TFloat
for	Tfor
TFormat	TFormat
goto	Tgoto
TIdentDefine	TIdentDefine
if	Tif
TIfdef	TIfdef
"#"{sp}*"ifdef"{sp}+{id}	TIfdefBool
TIfdefelif	TIfdefelif
TIfdefelse	TIfdefelse
TIfdefMisc	TIfdefMisc
TIfdefVersion	TIfdefVersion
"++"	TInc
TIncludeFilename	TIncludeFilename
TIncludeStart	TIncludeStart
"<"	TInf
"<<<"	TInf3
"<="	TInfEq
"inline"|"__inline"|"__inline__"	Tinline
int	Tint
{decimal}	TInt
{hexa}	TInt
{octal}	TInt
TKRParam	TKRParam
long	Tlong
TMacroAttr	TMacroAttr
TMacroAttrArgs	TMacroAttrArgs
TMacroDecl	TMacroDecl
TMacroIdentBuilder	TMacroIdentBuilder
TMacroIdStmt	TMacroIdStmt
TMacroIterator	TMacroIterator
TMacroStmt	TMacroStmt
TMacroString	TMacroString
">?"	TMax
"<?"	TMin
"-"	TMinus
"%"	TMod
"*"	TMul
namespace	Tnamespace
new	Tnew
TNoComma	TNoComma
"!="	TNotEq
"<%"	TOBrace
"{"	TOBrace
TOBraceDefineInit	TOBraceDefineInit
"<:"	TOCro
"["	TOCro
"[["	TOCroCro
"("	TOPar
TOParCplusplusInit	TOParCplusplusInit
TOParDefine	TOParDefine
operator	Toperator
"|"	TOr
"||"	TOrLog
TPct	TPct
"+"	TPlus
TPragma	TPragma
TPragmaString	TPragmaString
private	Tprivate
protected	Tprotected
ptrdiff_t	Tptrdiff_t
"->"	TPtrOp
";"	TPtVirg
public	Tpublic
TQuote	TQuote
register	Tregister
restrict	Trestrict
return	Treturn
"<<"	TShl
short	Tshort
">>"	TShr
"signed"	Tsigned
//"__signed__"	Tsigned
sizeof	Tsizeof
size_t	Tsize_t
ssize_t	Tssize_t
static	Tstatic
\"(\\.|[^"\r\n\\])*\"	TString
struct	Tstruct
TSubString	TSubString
">"	TSup
">>>"	TSup3
">="	TSupEq
switch	Tswitch
template	Ttemplate
TTemplateEnd	TTemplateEnd
TTemplateStart	TTemplateStart
"~"	TTilde
try	Ttry
typedef	Ttypedef
typename	Ttypename
"typeof"	Ttypeof
//"__typeof"|"__typeof__"	Ttypeof
TUelseif	TUelseif
TUendif	TUendif
TUifdef	TUifdef
TUndef	TUndef
union	Tunion
unsigned	Tunsigned
using	Tusing
virtual	Tvirtual
void	Tvoid
volatile	Tvolatile
while	Twhile
"?"	TWhy
"^"	TXor

"__extension__"	TattributeNoarg
"__stdcall"	TattributeNoarg
"__cdecl"	TattributeNoarg
"WINAPI"	TattributeNoarg
"APIENTRY"	TattributeNoarg
"CALLBACK"	TattributeNoarg

TQualExp	TQualExp
TQualId	TQualId
TQualType	TQualType

TypedefIdent	TypedefIdent
{id}	TIdent

%%
