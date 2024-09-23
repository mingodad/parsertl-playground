//From: https://github.com/semgrep/semgrep/blob/757814c7a2a811388d8616f65e7c4d9d9db1a53a/languages/cpp/menhir/parser_cpp.mly
/* Yoann Padioleau
 *
 * Copyright (C) 2002-2005 Yoann Padioleau
 * Copyright (C) 2006-2007 Ecole des Mines de Nantes
 * Copyright (C) 2008-2009 University of Urbana Champaign
 * Copyright (C) 2010-2014 Facebook
 * Copyright (C) 2019-2022 r2c
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation, with the
 * special exception on linking described in file license.txt.
 *
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file
 * license.txt for more details.
 */

 /*************************************************************************/
/* Prelude */
/*************************************************************************/
/* This file contains a grammar for C/C++/Cpp.
 * See ast_cpp.ml for more information.
 *
 * reference:
 *  - orig_c.mly and orig_cpp.mly in this directory
 *  - http://www.nongnu.org/hcb/ for an up-to-date hyperlinked C++ grammar
 *  - http://www.externsoft.ch/download/cpp-iso.html
 *  - tree-sitter-cpp grammar
 */

//%token  EOF
%token  LDots
%token  RDots
%token  TAnd
%token  TAndLog
%token  TAny_Action
%token  TAssign
%token  TBang
%token  TCBrace
%token  TCCro
%token  TCCro_new
%token  TCPar
//%token  TCPar_EOL
%token  TChar
%token  TCol
%token  TColCol
%token  TColCol_BeforeTypedef
%token  TComma
//%token  TComment
//%token  TCommentNewline
%token  TCommentNewline_DefineEndOfMacro
//%token  TCommentSpace
//%token  TComment_Cpp
//%token  TComment_Pp
%token  TCppDirectiveOther
%token  TCppEscapedNewline
%token  TDec
%token  TDefParamVariadic
%token  TDefine
%token  TDiv
%token  TDot
%token  TDotStar
%token  TEllipsis
%token  TEndif
%token  TEq
%token  TEqEq
%token  TFloat
%token  TIdent
%token  TIdent_ClassnameInQualifier
%token  TIdent_ClassnameInQualifier_BeforeTypedef
%token  TIdent_Constructor
%token  TIdent_Define
%token  TIdent_MacroDecl
%token  TIdent_MacroIterator
%token  TIdent_MacroStmt
%token  TIdent_MacroString
%token  TIdent_Templatename
%token  TIdent_TemplatenameInQualifier
%token  TIdent_TemplatenameInQualifier_BeforeTypedef
%token  TIdent_Typedef
%token  TIdent_TypedefConstr
%token  TIfdef
%token  TIfdefBool
%token  TIfdefMisc
%token  TIfdefVersion
%token  TIfdefelif
%token  TIfdefelse
%token  TInc
%token  TInclude
%token  TInf
%token  TInfEq
%token  TInf_Template
%token  TInt
//%token  TInt_ZeroVirtual
%token  TMinus
%token  TMod
%token  TMul
%token  TNotEq
%token  TOBrace
%token  TOBrace_DefineInit
%token  TOCro
%token  TOCro_Lambda
%token  TOCro_new
%token  TOPar
%token  TOPar_CplusplusInit
%token  TOPar_Define
%token  TOr
%token  TOrLog
%token  TPlus
%token  TPtVirg
%token  TPtrOp
%token  TPtrOpStar
%token  TShl
%token  TShr
%token  TString
%token  TSup
%token  TSupEq
%token  TSup_Template
%token  TTilde
%token  TUndef
%token  TWhy
%token  TXor
%token  Tasm
//%token  Tattribute
%token  Tauto
%token  Tbool
%token  Tbool_Constr
%token  Tbreak
%token  Tcase
%token  Tcatch
%token  Tchar
%token  Tchar_Constr
%token  Tclass
%token  Tconst
%token  Tconst_MacroDeclConst
%token  Tconst_cast
%token  Tconstexpr
%token  Tcontinue
%token  Tdecltype
%token  Tdefault
%token  Tdelete
%token  Tdo
%token  Tdouble
%token  Tdouble_Constr
%token  Tdynamic_cast
%token  Telse
%token  Tenum
%token  Texplicit
%token  Textern
%token  Tfalse
%token  Tfloat
%token  Tfloat_Constr
%token  Tfor
%token  Tfriend
%token  Tgoto
%token  Tif
%token  Tinline
%token  Tint
%token  Tint_Constr
%token  Tlong
%token  Tlong_Constr
%token  Tmutable
%token  Tnamespace
%token  Tnew
%token  Tnull
%token  Tnullptr
%token  Toperator
%token  Tprivate
%token  Tprotected
%token  Tpublic
%token  Tregister
%token  Treinterpret_cast
%token  Trestrict
%token  Treturn
%token  Tshort
%token  Tshort_Constr
%token  Tsigned
//%token  Tsigned_Constr
%token  Tsizeof
%token  Tstatic
%token  Tstatic_cast
%token  Tstruct
%token  Tswitch
%token  Ttemplate
%token  Tthis
%token  Tthread_local
%token  Tthrow
%token  Ttrue
%token  Ttry
%token  Ttypedef
%token  Ttypeid
%token  Ttypename
%token  Ttypeof
%token  Tunion
%token  Tunsigned
//%token  Tunsigned_Constr
%token  Tusing
%token  Tvirtual
%token  Tvoid
%token  Tvolatile
%token  Twchar_t
%token  Twchar_t_Constr
%token  Twhile

%nonassoc LOW_PRIORITY_RULE
%nonassoc Telse
%left TAnd
%left TMul
%left TAndLog

%start main

%%

option_TColCol_ :
	/*empty*/
	| TColCol
	;

option_TComma_ :
	/*empty*/
	| TComma
	;

option_Tinline_ :
	/*empty*/
	| Tinline
	;

option_Ttemplate_ :
	/*empty*/
	| Ttemplate
	;

option_Ttypename_ :
	/*empty*/
	| Ttypename
	;

option_Tvoid_ :
	/*empty*/
	| Tvoid
	;

option_Tvolatile_ :
	/*empty*/
	| Tvolatile
	;

option_assign_expr_ :
	/*empty*/
	| assign_expr
	;

option_base_clause_ :
	/*empty*/
	| base_clause
	;

option_exn_spec_ :
	/*empty*/
	| exn_spec
	;

option_expr_ :
	/*empty*/
	| expr
	;

option_ident_ :
	/*empty*/
	| ident
	;

option_new_initializer_ :
	/*empty*/
	| new_initializer
	;

option_new_placement_ :
	/*empty*/
	| new_placement
	;

option_parameter_type_list_ :
	/*empty*/
	| parameter_list
	;

list_statement_or_decl_cpp_ :
	/*empty*/
	| list_statement_or_decl_cpp_ statement_or_decl_cpp
	;

nonempty_list_TAny_Action_ :
	TAny_Action
	| nonempty_list_TAny_Action_ TAny_Action
	;

nonempty_list_colon_asm_ :
	colon_asm
	| nonempty_list_colon_asm_ colon_asm
	;

nonempty_list_declaration_cpp_ :
	declaration_cpp
	| nonempty_list_declaration_cpp_ declaration_cpp
	;

nonempty_list_designator_ :
	designator
	| nonempty_list_designator_ designator
	;

nonempty_list_external_declaration_ :
	external_declaration
	| nonempty_list_external_declaration_ external_declaration
	;

nonempty_list_handler_ :
	handler
	| nonempty_list_handler_ handler
	;

//nonempty_list_statement_or_decl_cpp_ :
//	statement_or_decl_cpp
//	| nonempty_list_statement_or_decl_cpp_ statement_or_decl_cpp
//	;

nonempty_list_string_elem_ :
	string_elem
	| nonempty_list_string_elem_ string_elem
	;

listc_argument_ :
	argument
	| listc_argument_ TComma argument
	;

listc_base_specifier_ :
	base_specifier
	| listc_base_specifier_ TComma base_specifier
	;

listc_colon_option_ :
	colon_option
	| listc_colon_option_ TComma colon_option
	;

listc_enumerator_ :
	enumerator
	| listc_enumerator_ TComma enumerator
	;

listc_init_declarator_ :
	init_declarator
	| listc_init_declarator_ TComma init_declarator
	;

listc_mem_initializer_ :
	mem_initializer
	| listc_mem_initializer_ TComma mem_initializer
	;

listc_member_declarator_ :
	member_declarator
	| listc_member_declarator_ TComma member_declarator
	;

listc_param_define_ :
	param_define
	| listc_param_define_ TComma param_define
	;

listc_template_argument_ :
	template_argument
	| listc_template_argument_ TComma template_argument
	;

listc_template_parameter_ :
	template_parameter
	| listc_template_parameter_ TComma template_parameter
	;

optl_listc_argument__ :
	/*empty*/
	| listc_argument_
	;

optl_listc_param_define__ :
	/*empty*/
	| listc_param_define_
	;

optl_listc_template_parameter__ :
	/*empty*/
	| listc_template_parameter_
	;

optl_member_specification_ :
	/*empty*/
	| member_specification
	;

optl_nested_name_specifier_ :
	/*empty*/
	| nested_name_specifier
	;

optl_nested_name_specifier2_ :
	/*empty*/
	| nested_name_specifier2
	;

optl_nonempty_list_declaration_cpp__ :
	/*empty*/
	| nonempty_list_declaration_cpp_
	;

main :
	translation_unit //EOF
	;

translation_unit :
	nonempty_list_external_declaration_
	;

external_declaration :
	function_definition
	| block_declaration
	;

//toplevel :
//	toplevel_aux
//	| EOF
//	;
//
//toplevel_aux :
//	declaration
//	| cpp_directive
//	| cpp_ifdef_directive
//	| cpp_other
//	| TCBrace
//	;

//semgrep_pattern :
//	expr EOF
//	| statement_or_decl_cpp EOF
//	| statement_or_decl_cpp nonempty_list_statement_or_decl_cpp_ EOF
//	| namespace_definition EOF
//	;

id_expression :
	unqualified_id
	| qualified_id
	;

unqualified_id :
	TIdent
	| operator_function_id
	| conversion_function_id
	;

operator_function_id :
	Toperator operator_kind
	;

conversion_function_id :
	Toperator conversion_type_id
	;

operator_kind :
	TEqEq
	| TNotEq
	| TEq
	| TAssign
	| TTilde
	| TBang
	| TComma
	| TPlus
	| TMinus
	| TMul
	| TDiv
	| TMod
	| TOr
	| TXor
	| TAnd
	| TShl
	| TShr
	| TOrLog
	| TAndLog
	| TInf
	| TSup
	| TInfEq
	| TSupEq
	| TInc
	| TDec
	| TPtrOpStar
	| TPtrOp
	| TOPar TCPar
	| TOCro TCCro
	| Tnew
	| Tdelete
	| Tnew TOCro_new TCCro_new
	| Tdelete TOCro_new TCCro_new
	;

qualified_id :
	nested_name_specifier unqualified_id
	;

nested_name_specifier :
	class_or_namespace_name_for_qualifier TColCol optl_nested_name_specifier_
	;

class_or_namespace_name_for_qualifier :
	TIdent_ClassnameInQualifier
	| TIdent_TemplatenameInQualifier TInf_Template listc_template_argument_ TSup_Template
	;

enum_name_or_typedef_name_or_simple_class_name :
	TIdent_Typedef
	;

nested_name_specifier2 :
	class_or_namespace_name_for_qualifier2 TColCol_BeforeTypedef optl_nested_name_specifier2_
	;

class_or_namespace_name_for_qualifier2 :
	TIdent_ClassnameInQualifier_BeforeTypedef
	| TIdent_TemplatenameInQualifier_BeforeTypedef TInf_Template listc_template_argument_ TSup_Template
	;

ident :
	TIdent
	| TIdent_Typedef
	;

expr :
	assign_expr
	| expr TComma assign_expr
	;

assign_expr :
	cond_expr
	| cast_expr TAssign assign_expr
	| cast_expr TEq assign_expr
	| Tthrow option_assign_expr_
	;

cond_expr :
	logical_or_expr
	| logical_or_expr TWhy option_expr_ TCol assign_expr
	;

multiplicative_expr :
	pm_expr
	| multiplicative_expr TMul pm_expr
	| multiplicative_expr TDiv pm_expr
	| multiplicative_expr TMod pm_expr
	;

additive_expr :
	multiplicative_expr
	| additive_expr TPlus multiplicative_expr
	| additive_expr TMinus multiplicative_expr
	;

shift_expr :
	additive_expr
	| shift_expr TShl additive_expr
	| shift_expr TShr additive_expr
	;

relational_expr :
	shift_expr
	| relational_expr TInf shift_expr
	| relational_expr TSup shift_expr
	| relational_expr TInfEq shift_expr
	| relational_expr TSupEq shift_expr
	;

equality_expr :
	relational_expr
	| equality_expr TEqEq relational_expr
	| equality_expr TNotEq relational_expr
	;

and_expr :
	equality_expr
	| and_expr TAnd equality_expr
	;

exclusive_or_expr :
	and_expr
	| exclusive_or_expr TXor and_expr
	;

inclusive_or_expr :
	exclusive_or_expr
	| inclusive_or_expr TOr exclusive_or_expr
	;

logical_and_expr :
	inclusive_or_expr
	| logical_and_expr TAndLog inclusive_or_expr
	;

logical_or_expr :
	logical_and_expr
	| logical_or_expr TOrLog logical_and_expr
	;

pm_expr :
	cast_expr
	| pm_expr TDotStar cast_expr
	| pm_expr TPtrOpStar cast_expr
	;

cast_expr :
	unary_expr
	| TOPar type_id TCPar cast_expr
	| TOPar type_id TIdent TCPar
	;

unary_expr :
	postfix_expr
	| TInc unary_expr
	| TDec unary_expr
	| unary_op cast_expr
	| Tsizeof unary_expr
	| Tsizeof TOPar type_id TCPar
	| Tsizeof TOPar TEllipsis TCPar
	| new_expr
	| delete_expr
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
	| postfix_expr TOCro expr TCCro
	| postfix_expr TOPar optl_listc_argument__ TCPar
	| postfix_expr TDot option_Ttemplate_ option_TColCol_ id_expression
	| postfix_expr TPtrOp option_Ttemplate_ option_TColCol_ id_expression
	| postfix_expr TInc
	| postfix_expr TDec
	| TOPar type_id TCPar braced_init_list
	| cast_operator_expr
	| Ttypeid TOPar unary_expr TCPar
	| Ttypeid TOPar type_id TCPar
	| cast_constructor_expr
	| simple_type_specifier braced_init_list
	| TIdent braced_init_list
	;

primary_expr :
	literal
	| Tthis
	| TOPar expr TCPar
	| TOPar compound TCPar
	| primary_cplusplus_id
	| lambda_introducer compound
	| LDots expr RDots
	;

literal :
	TInt
	| TFloat
	| TChar
	| TString
	| string_elem nonempty_list_string_elem_
	| Ttrue
	| Tfalse
	| Tnullptr
	| Tnull
	;

primary_cplusplus_id :
	id_expression
	| TColCol TIdent
	| TColCol operator_function_id
	| TColCol qualified_id
	;

cast_operator_expr :
	cpp_cast_operator TInf_Template type_id TSup_Template TOPar expr TCPar
	| cpp_cast_operator TOPar expr TCPar
	;

cpp_cast_operator :
	Tstatic_cast
	| Tdynamic_cast
	| Tconst_cast
	| Treinterpret_cast
	;

cast_constructor_expr :
	TIdent_TypedefConstr TOPar optl_listc_argument__ TCPar
	| basic_type_2 TOPar optl_listc_argument__ TCPar
	;

new_expr :
	option_TColCol_ Tnew option_new_placement_ new_type_id option_new_initializer_
	;

delete_expr :
	option_TColCol_ Tdelete cast_expr
	| option_TColCol_ Tdelete TOCro_new TCCro_new cast_expr
	;

new_placement :
	TOPar listc_argument_ TCPar
	;

new_initializer :
	TOPar optl_listc_argument__ TCPar
	;

lambda_introducer :
	TOCro_Lambda TCCro
	| TOCro_Lambda lambda_capture TCCro
	;

lambda_capture :
	capture_list
	| capture_default
	| capture_default TComma capture_list
	;

capture_default :
	TAnd
	| TEq
	;

capture_list :
	capture
	| capture_list TComma capture
	| capture_list TComma capture TEllipsis
	| capture TEllipsis
	;

capture :
	ident
	| TAnd ident
	| Tthis
	| ident TEq assign_expr
	;

string_elem :
	TString
	| TIdent_MacroString
	;

argument :
	assign_expr
	| type_id
	| TEllipsis
	| nonempty_list_TAny_Action_
	;

const_expr :
	cond_expr
	;

basic_type_2 :
	Tchar_Constr
	| Tint_Constr
	| Tfloat_Constr
	| Tdouble_Constr
	| Twchar_t_Constr
	| Tshort_Constr
	| Tlong_Constr
	| Tbool_Constr
	;

statement :
	compound
	| expr_statement
	| labeled
	| selection
	| iteration
	| jump TPtVirg
	| TIdent_MacroStmt
	| try_block
	| TEllipsis
	;

compound :
	TOBrace list_statement_or_decl_cpp_ TCBrace
	;

statement_or_decl :
	statement
	| function_definition
	| block_declaration
	;

expr_statement :
	option_expr_ TPtVirg
	;

labeled :
	ident TCol statement
	| Tcase const_expr TCol statement
	| Tdefault TCol statement
	| Tcase const_expr TEllipsis const_expr TCol statement
	;

selection :
	Tif TOPar expr TCPar statement %prec LOW_PRIORITY_RULE
	| Tif TOPar decl_spec_seq declaratori TEq initializer_clause TCPar statement %prec LOW_PRIORITY_RULE
	| Tif TOPar expr TCPar statement Telse statement
	| Tif TOPar decl_spec_seq declaratori TEq initializer_clause TCPar statement Telse statement
	| Tswitch TOPar expr TCPar statement
	| Tswitch TOPar decl_spec_seq declaratori TEq initializer_clause TCPar statement
	;

iteration :
	Twhile TOPar expr TCPar statement
	| Twhile TOPar decl_spec_seq declaratori TEq initializer_clause TCPar statement
	| Tdo statement Twhile TOPar expr TCPar TPtVirg
	| Tfor TOPar for_init_stmt expr_statement option_expr_ TCPar statement
	| Tfor TOPar for_range_decl TCol for_range_init TCPar statement
	| Tfor TOPar TEllipsis TCPar statement
	| TIdent_MacroIterator TOPar optl_listc_argument__ TCPar statement
	;

jump :
	Tgoto ident
	| Tcontinue
	| Tbreak
	| Treturn
	| Treturn expr
	| Tgoto TMul expr
	;

statement_or_decl_cpp :
	statement_or_decl
	| cpp_directive
	| cpp_ifdef_directive
	| cpp_macro_decl
	;

for_init_stmt :
	expr_statement
	| simple_declaration
	;

for_range_decl :
	decl_spec_seq declarator
	;

for_range_init :
	expr
	;

try_block :
	Ttry compound nonempty_list_handler_
	;

handler :
	Tcatch TOPar exception_decl TCPar compound
	;

exception_decl :
	parameter_decl
	;

type_spec :
	simple_type_specifier
	| elaborated_type_specifier
	| enum_specifier
	| class_specifier
	;

simple_type_specifier :
	Tvoid
	| Tchar
	| Tint
	| Tfloat
	| Tdouble
	| Tshort
	| Tlong
	| Tsigned
	| Tunsigned
	| Tbool
	| Twchar_t
	| Ttypeof TOPar assign_expr TCPar
	| Ttypeof TOPar type_id TCPar
	| type_cplusplus_id
	| decltype_specifier
	;

decltype_specifier :
	Tdecltype TOPar expr TCPar
	| Tdecltype TOPar TIdent_Typedef TCPar
	;

elaborated_type_specifier :
	Tenum ident
	| class_key ident
	| Ttypename type_cplusplus_id
	;

type_cplusplus_id :
	type_name
	| nested_name_specifier2 type_name
	| TColCol_BeforeTypedef type_name
	| TColCol_BeforeTypedef nested_name_specifier2 type_name
	;

type_name :
	enum_name_or_typedef_name_or_simple_class_name
	| template_id
	;

template_id :
	TIdent_Templatename TInf_Template listc_template_argument_ TSup_Template
	;

template_argument :
	type_id
	| assign_expr
	;

cv_qualif :
	Tconst
	| Tvolatile
	| Trestrict
	;

declarator :
	pointer direct_d
	| direct_d
	;

pointer :
	TMul
	| TMul cv_qualif_list
	| TMul pointer
	| TMul cv_qualif_list pointer
	| TAnd
	| TAnd pointer
	| TAndLog
	| TAndLog pointer
	;

direct_d :
	declarator_id
	| TOPar declarator TCPar
	| direct_d TOCro TCCro
	| direct_d TOCro const_expr TCCro
	| direct_d TOPar TCPar const_opt option_exn_spec_
	| direct_d TOPar parameter_list TCPar const_opt option_exn_spec_
	;

declarator_id :
	option_TColCol_ id_expression
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
	| TOPar TCPar
	| TOPar parameter_list TCPar
	| direct_abstract_declarator TOPar TCPar const_opt option_exn_spec_
	| direct_abstract_declarator TOPar parameter_list TCPar const_opt option_exn_spec_
	;

parameter_decl :
	decl_spec_seq declarator
	| decl_spec_seq abstract_declarator
	| decl_spec_seq
	| decl_spec_seq declarator TEq assign_expr
	| decl_spec_seq abstract_declarator TEq assign_expr
	| decl_spec_seq TEq assign_expr
	| TEllipsis
	;

parameter_list :
	parameter_decl2
	| parameter_list TComma parameter_decl2
	;

parameter_decl2 :
	parameter_decl
	| TIdent
	;

exn_spec :
	Tthrow TOPar TCPar
	| Tthrow TOPar exn_name TCPar
	| Tthrow TOPar exn_name TComma exn_name TCPar
	;

exn_name :
	ident
	;

const_opt :
	Tconst
	|
	;

spec_qualif_list :
	type_spec
	| cv_qualif
	| spec_qualif_list type_spec
	| spec_qualif_list cv_qualif
	;

cv_qualif_list :
	cv_qualif
	| cv_qualif_list cv_qualif
	;

type_id :
	spec_qualif_list
	| spec_qualif_list abstract_declarator
	;

new_type_id :
	spec_qualif_list %prec LOW_PRIORITY_RULE
	| spec_qualif_list new_declarator
	;

new_declarator :
	ptr_operator %prec LOW_PRIORITY_RULE
	| direct_new_declarator
	| ptr_operator new_declarator
	;

ptr_operator :
	TMul
	| TAnd
	| TAndLog
	;

direct_new_declarator :
	TOCro expr TCCro
	| direct_new_declarator TOCro expr TCCro
	;

conversion_type_id :
	simple_type_specifier conversion_declarator
	| simple_type_specifier %prec LOW_PRIORITY_RULE
	;

conversion_declarator :
	ptr_operator %prec LOW_PRIORITY_RULE
	| ptr_operator conversion_declarator
	;

class_specifier :
	class_head TOBrace optl_member_specification_ TCBrace
	;

class_head :
	class_key
	| class_key ident option_base_clause_
	| class_key nested_name_specifier ident option_base_clause_
	;

class_key :
	Tstruct
	| Tunion
	| Tclass
	;

base_clause :
	TCol listc_base_specifier_
	;

base_specifier :
	class_name
	| access_specifier class_name
	| Tvirtual access_specifier class_name
	;

class_name :
	type_cplusplus_id
	| TIdent
	;

member_specification :
	member_declaration optl_member_specification_
	| access_specifier TCol optl_member_specification_
	;

access_specifier :
	Tpublic
	| Tprivate
	| Tprotected
	;

member_declaration :
	field_declaration
	| function_definition
	| qualified_id TPtVirg
	| using_declaration
	| template_declaration
	| ctor_dtor_member
	| TPtVirg
	;

field_declaration :
	decl_spec_seq TPtVirg
	| decl_spec_seq listc_member_declarator_ TPtVirg
	;

member_declarator :
	declarator
	| declarator TEq const_expr
	| declarator TCol const_expr
	| TCol const_expr
	;

enum_specifier :
	enum_head TOBrace listc_enumerator_ option_TComma_ TCBrace
	| enum_head TOBrace TCBrace
	;

enum_head :
	Tenum option_ident_
	| Tenum Tclass option_ident_
	| Tenum Tstruct option_ident_
	;

enumerator :
	ident
	| ident TEq const_expr
	;

simple_declaration :
	decl_spec_seq TPtVirg
	| decl_spec_seq listc_init_declarator_ TPtVirg
	;

decl_spec_seq :
	decl_spec
	| decl_spec_seq decl_spec
	;

decl_spec :
	storage_class_spec
	| type_spec
	| function_spec
	| type_qualifier
	| cv_qualif
	| Ttypedef
	| Tfriend
	;

function_spec :
	Tinline
	| Tvirtual
	;

storage_class_spec :
	Tstatic
	| Textern
	| Tauto
	| Tregister
	| Tthread_local
	;

type_qualifier :
	Tmutable
	| Tconstexpr
	;

init_declarator :
	declaratori
	| declaratori TEq initializer_clause
	| declaratori TOPar_CplusplusInit optl_listc_argument__ TCPar
	;

declaratori :
	declarator
	| declarator gcc_asm_decl
	;

gcc_asm_decl :
	Tasm option_Tvolatile_ TOPar asmbody TCPar
	;

initializer_clause :
	assign_expr
	| braced_init_list
	;

braced_init_list :
	TOBrace TCBrace
	| TOBrace initialize_list option_TComma_ TCBrace
	;

initialize_list :
	initialize2
	| initialize_list TComma initialize2
	;

initialize2 :
	cond_expr
	| braced_init_list
	| nonempty_list_designator_ TEq initialize2
	| ident TCol initialize2
	| TOCro const_expr TCCro TEq initialize2
	| TOCro const_expr TCCro initialize2
	;

designator :
	TDot ident
	;

block_declaration :
	simple_declaration
	| asm_definition
	| namespace_alias_definition
	| using_declaration
	| using_directive
	;

namespace_alias_definition :
	Tnamespace TIdent TEq qualified_namespace_spec TPtVirg
	;

using_directive :
	Tusing Tnamespace qualified_namespace_spec TPtVirg
	;

qualified_namespace_spec :
	option_TColCol_ optl_nested_name_specifier_ TIdent
	;

using_declaration :
	Tusing option_Ttypename_ option_TColCol_ nested_name_specifier unqualified_id TPtVirg
	| Tusing option_Ttypename_ option_TColCol_ unqualified_id TPtVirg
	;

asm_definition :
	Tasm option_Tvolatile_ TOPar asmbody TCPar TPtVirg
	;

asmbody :
	nonempty_list_string_elem_ nonempty_list_colon_asm_
	| nonempty_list_string_elem_
	;

colon_asm :
	TCol listc_colon_option_
	;

colon_option :
	TString
	| TString TOPar asm_expr TCPar
	| TOCro TIdent TCCro TString TOPar asm_expr TCPar
	| TIdent
	|
	;

asm_expr :
	assign_expr
	;

declaration :
	block_declaration
	| function_definition
	| ctor_dtor
	| template_declaration
	| linkage_specification
	| namespace_definition
	| TPtVirg
	;

declaration_cpp :
	declaration
	| cpp_directive
	| cpp_ifdef_directive
	| TEllipsis
	;

template_declaration :
	Ttemplate TInf_Template optl_listc_template_parameter__ TSup_Template declaration
	;

template_parameter :
	parameter_decl
	;

linkage_specification :
	Textern TString declaration
	| Textern TString TOBrace optl_nonempty_list_declaration_cpp__ TCBrace
	;

namespace_definition :
	named_namespace_definition
	| unnamed_namespace_definition
	;

named_namespace_definition :
	Tnamespace TIdent TOBrace optl_nonempty_list_declaration_cpp__ TCBrace
	;

unnamed_namespace_definition :
	Tnamespace TOBrace optl_nonempty_list_declaration_cpp__ TCBrace
	;

function_definition :
	decl_spec_seq declarator function_body
	;

function_body :
	compound
	;

ctor_dtor :
	nested_name_specifier TIdent_Constructor TOPar option_parameter_type_list_ TCPar ctor_mem_initializer_list_opt compound
	| nested_name_specifier TTilde ident TOPar option_Tvoid_ TCPar option_exn_spec_ compound
	| option_Tinline_ TIdent_Constructor TOPar option_parameter_type_list_ TCPar ctor_mem_initializer_list_opt compound
	| TTilde ident TOPar option_Tvoid_ TCPar option_exn_spec_ compound
	;

ctor_dtor_member :
	ctor_spec TIdent_Constructor TOPar option_parameter_type_list_ TCPar ctor_mem_initializer_list_opt compound
	| ctor_spec TIdent_Constructor TOPar option_parameter_type_list_ TCPar TPtVirg
	| ctor_spec TIdent_Constructor TOPar option_parameter_type_list_ TCPar TEq Tdelete TPtVirg
	| ctor_spec TIdent_Constructor TOPar option_parameter_type_list_ TCPar TEq Tdefault TPtVirg
	| dtor_spec TTilde ident TOPar option_Tvoid_ TCPar option_exn_spec_ compound
	| dtor_spec TTilde ident TOPar option_Tvoid_ TCPar option_exn_spec_ TPtVirg
	| dtor_spec TTilde ident TOPar option_Tvoid_ TCPar option_exn_spec_ TEq Tdelete TPtVirg
	| dtor_spec TTilde ident TOPar option_Tvoid_ TCPar option_exn_spec_ TEq Tdefault TPtVirg
	;

ctor_spec :
	Texplicit
	| Tinline
	|
	;

dtor_spec :
	Tvirtual
	| Tinline
	|
	;

ctor_mem_initializer_list_opt :
	TCol listc_mem_initializer_
	|
	;

mem_initializer :
	mem_initializer_id TOPar optl_listc_argument__ TCPar
	;

mem_initializer_id :
	primary_cplusplus_id
	;

cpp_directive :
	TInclude
	| TDefine TIdent_Define define_val TCommentNewline_DefineEndOfMacro
	| TDefine TIdent_Define TOPar_Define optl_listc_param_define__ TCPar define_val TCommentNewline_DefineEndOfMacro
	| TUndef
	| TCppDirectiveOther
	;

define_val :
	expr
	| statement
	| Tdo statement Twhile TOPar expr TCPar
	| Tif TOPar expr TCPar id_expression
	| TOBrace_DefineInit initialize_list TCBrace option_TComma_
	|
	;

param_define :
	ident
	| TDefParamVariadic
	| TEllipsis
	| Tregister
	| Tnew
	;

cpp_ifdef_directive :
	TIfdef
	| TIfdefelse
	| TIfdefelif
	| TEndif
	| TIfdefBool
	| TIfdefMisc
	| TIfdefVersion
	;

cpp_macro_decl :
	TIdent_MacroDecl TOPar listc_argument_ TCPar TPtVirg
	| Tstatic TIdent_MacroDecl TOPar listc_argument_ TCPar TPtVirg
	| Tstatic Tconst_MacroDeclConst TIdent_MacroDecl TOPar listc_argument_ TCPar TPtVirg
	;

//cpp_other :
//	TIdent TOPar listc_argument_ TCPar TPtVirg
//	| TIdent TOPar listc_argument_ TCPar_EOL
//	| TIdent TPtVirg
//	;

%%

%x DEFINE_BODY

/* The C/cpp/C++ lexer.
 *
 * This lexer generates tokens for C (int, while, ...), C++ (new, delete, ...),
 * and CPP (#define, #ifdef, ...).
 * It also generate tokens for comments and spaces. This means that
 * it can not be used as-is. Some post-filtering
 * has to be done to feed it to a parser.
 *
 * Note that C and C++ are not context-free languages and so some idents
 * must be disambiguated in some ways. TIdent below must thus be
 * post-processed too (as well as other tokens like '<' for C++).
 * See parsing_hack.ml for examples.
 *
 * note: We can't use Lexer_parser._lexer_hint here to do different
 * things because we now call the lexer to get all the tokens
 * and then only we parse. So we can use the hint only
 * in parse_cpp.ml. For the same reason, we don't handle typedefs
 * here anymore. We really just tokenize ...
 */

/* Regexps aliases */

letter   [A-Za-z_]
digit    [0-9]

/* not used for the moment */
punctuation   [!"#%&\()*+,'-./:;<=>?\[\]\\^{|}~]
space   [ \t\n\r\v\f]
additionnal   [ \b\t\v\n\r\a]
/* 7   \a   bell in C. this is not the only char allowed !!
 * ex @ and $ ` are valid too
 */

cchar   ({letter}|{digit}|{punctuation}|{additionnal})

sp   [ \t]+
spopt   [ \t]*

dec   [0-9]
oct   [0-7]
hex   [0-9a-fA-F]

decimal   (0|([1-9]{dec}*))
octal     [0]{oct}+
hexa      ("0x"|"0X"){hex}+

pent     {dec}+
pfract   {dec}+
sign   [-+]
exp    [eE]{sign}?{dec}+
real   {pent}{exp}|(({pent}?"."{pfract}|{pent}"."{pfract}?){exp}?)

id   {letter}({letter}|{digit})*

%%

TAny_Action	TAny_Action
TCCro_new	TCCro_new
//TCPar_EOL	TCPar_EOL
TColCol_BeforeTypedef	TColCol_BeforeTypedef
TCommentNewline_DefineEndOfMacro	TCommentNewline_DefineEndOfMacro
TDefine	TDefine
TIdent_ClassnameInQualifier	TIdent_ClassnameInQualifier
TIdent_ClassnameInQualifier_BeforeTypedef	TIdent_ClassnameInQualifier_BeforeTypedef
TIdent_Constructor	TIdent_Constructor
TIdent_Define	TIdent_Define
TIdent_MacroDecl	TIdent_MacroDecl
TIdent_MacroIterator	TIdent_MacroIterator
TIdent_MacroStmt	TIdent_MacroStmt
TIdent_MacroString	TIdent_MacroString
TIdent_Templatename	TIdent_Templatename
TIdent_TemplatenameInQualifier	TIdent_TemplatenameInQualifier
TIdent_TemplatenameInQualifier_BeforeTypedef	TIdent_TemplatenameInQualifier_BeforeTypedef
TIdent_Typedef	TIdent_Typedef
TIdent_TypedefConstr	TIdent_TypedefConstr
TIfdefVersion	TIfdefVersion
TInf_Template	TInf_Template
//TInt_ZeroVirtual	TInt_ZeroVirtual
TOBrace_DefineInit	TOBrace_DefineInit
TOCro_Lambda	TOCro_Lambda
TOCro_new	TOCro_new
TOPar_CplusplusInit	TOPar_CplusplusInit
TOPar_Define	TOPar_Define
TSup_Template	TSup_Template
Tbool_Constr	Tbool_Constr
Tchar_Constr	Tchar_Constr
Tconst_MacroDeclConst	Tconst_MacroDeclConst
Tdouble_Constr	Tdouble_Constr
Tfloat_Constr	Tfloat_Constr
Tint_Constr	Tint_Constr
Tlong_Constr	Tlong_Constr
Tshort_Constr	Tshort_Constr
//Tsigned_Constr	Tsigned_Constr
//Tunsigned_Constr	Tunsigned_Constr
Twchar_t_Constr	Twchar_t_Constr

/* Keywords */

"void"	Tvoid
"char"	Tchar
"short"	Tshort
"int"	Tint
"long"	Tlong
"float"	Tfloat
"double"	Tdouble

/* c++ext: */
"bool"	Tbool
"true"	Ttrue
"false"	Tfalse

/* tree-sitter-c: */
"TRUE"	Ttrue
"FALSE"	Tfalse
"NULL"	Tnull

"wchar_t"	Twchar_t
/* c++0x: TODO */
"char16_t"	Twchar_t
"char32_t"	Twchar_t
"nullptr"	Tnullptr

"unsigned"	Tunsigned
"signed"	Tsigned

/* c: and also now a c++0x: */
"auto"	Tauto

"register"	Tregister
"extern"	Textern
"static"	Tstatic

"const"	Tconst
"volatile"	Tvolatile

/* c99:  */
"__restrict__"	Trestrict
/* gccext: and also a c++ext: */
"inline"	Tinline
/* c++ext:  */
"friend"    	Tfriend
"explicit"	Texplicit
"mutable"	Tmutable
"virtual"	Tvirtual

/* c++0x:  */
"constexpr"	Tconstexpr
"thread_local"	Tthread_local

"struct"	Tstruct
"union"	Tunion
"enum"	Tenum

"typedef"	Ttypedef

"if"	Tif
"else"	Telse
"break"	Tbreak
"continue"	Tcontinue
"switch"	Tswitch
"case"	Tcase
"default"	Tdefault
"for"	Tfor
"do"	Tdo
"while"	Twhile
"return"	Treturn
"goto"	Tgoto

"sizeof"	Tsizeof
/* gccext: */
"typeof"	Ttypeof

/* c++ext: */
"typename" 	Ttypename
/* c++0x: */
"decltype" 	Tdecltype

/* gccext: more (cpp) aliases are in macros.h */
"asm"	Tasm
//"__attribute__"	Tattribute

/* c++ext: see also TH.is_cpp_keyword */
"class"	Tclass
"this"	Tthis

"new"    	Tnew
"delete" 	Tdelete

"template" 	Ttemplate
"typeid"   	Ttypeid

"catch" 	Tcatch
"try"   	Ttry
"throw" 	Tthrow

"operator"	Toperator

"public"    	Tpublic
"private"   	Tprivate
"protected" 	Tprotected

"namespace"	Tnamespace
"using"	Tusing

"const_cast"       	Tconst_cast
"dynamic_cast"     	Tdynamic_cast
"static_cast"      	Tstatic_cast
"reinterpret_cast" 	Treinterpret_cast

/* Spaces, comments */

[ \t]+	skip()
/* see also TCppEscapedNewline below */
[\n\r\v\f]+	skip()
"/*"(?s:.)*?"*/"	skip()
/* C++ comments are allowed via gccext, but normally they are deleted by cpp.
   * So we need this here only because we dont call cpp before.
   * Note that we don't keep the trailing \n; it will be in another token.
   */
"//".*		skip()

/* #include */

 /* The difference between a local "" and standard <> include is computed
   * later in parser_cpp.mly. So we redo a little bit of lexing there. It's
   * ugly but simpler to generate a single token here. */
"#"[ \t]*("include"|"include_next"|"import")[ \t]*\"([^"]+)\"|"<"[^>]+">"	TInclude
/* semgrep: added $ */
      /*[A-Z_$]+*/

/* #ifdef */

"#"[ \t]*"if"[ \t]*(0|1)   /* [^'\n']*  '\n' */	TIfdefBool
"#"[ \t]*"ifdef"[ \t]*"__cplusplus"[^\n]*\n	TIfdefMisc

/* can have some ifdef 0  hence the letter|digit even at beginning of word */
"#"[ \t]*"ifdef"[ \t]+({letter}|{digit})(({letter}|{digit})*)[ \t]*	TIfdef
"#"[ \t]*"ifndef"[ \t]+({letter}|{digit})(({letter}|{digit})*)[ \t]*	TIfdef
"#"[ \t]*"if"[ \t]+.*	TIfdef
"#"[ \t]*"if(".*	TIfdef
"#"[ \t]*"elif"[ \t]+.*	TIfdefelif

  /* bugfix: can have #endif LINUX  but at the same time if I eat everything
   * until next line, I may miss some TComment which for some tools
   * are important such as aComment
   */
"#"[ \t]*"endif"*[^\n]*\n*	TEndif
"#"[ \t]*"else"[ \t\n]	TIfdefelse

/* #define, #undef */

  /* The rest of the lexing/parsing of #define is done in fix_tokens_define
   * where we parse all TCppEscapedNewline and finally generate a TDefEol
   */
"#"[ \t]*"define"<DEFINE_BODY>

  /* note: in some cases we can have stuff after the ident as in #undef XXX 50,
   * but I currently don't handle it cos I think it's bad code.
   */
"#"[ \t]*"undef"[ \t]+{id}	TUndef
     /* alt: |> tok_add_s (cpp_eat_until_nl lexbuf)) */

  /* #define body */

  /* We could generate separate tokens for #, ## and then extend
   * the grammar, but there can be ident in many different places, in
   * expression but also in declaration, in function name. So having 3 tokens
   * for an ident does not work well with how we add info in
   * ast_cpp.ml. So it's better to generate just one token, just one info,
   * even if have later to reanalyse those tokens and unsplit.
   *
   * less: do as in yacfe, generate multiple tokens for those constructs?
   */
<DEFINE_BODY> {
	\n\n<INITIAL>	skip()
	{id}"..."<.>	TDefParamVariadic

	/* cppext: string concatenation */
	{id}([ \t]*"##"[ \t]*{id})+		TIdent

	/* cppext: stringificion
	* bugfix: this case must be after the other cases such as #endif
	* otherwise take precedent.
	*/
	"#"{id}	TIdent

	/* cppext: gccext: ##args for variadic macro */
	"##"[ \t]*{id}	TIdent

	/* only in define body normally */
	"\\"\n 	TCppEscapedNewline
}

/* cpp pragmas */

/* bugfix: I want to keep comments so cant do a    sp [^'\n']+ '\n'
* http://gcc.gnu.org/onlinedocs/gcc/Pragmas.html
*/
"#"{spopt}("pragma"|"ident"|"line"|"error"|"warning"|"abort"){sp}[^\n]*\n	TCppDirectiveOther

/* This appears only after calling cpp cpp, as in:
*   # 1 "include/linux/module.h" 1
* Because we handle cpp ourselves, why handle it here?
* Why not ... also one could want to use our parser on
* expanded files sometimes.
*/
"#"{sp}{pent}{sp}\"[^"]*\"({spopt}{pent})*{spopt}\n	TCppDirectiveOther

/* ?? */
"#"[ \t]*\n	TCppDirectiveOther

/* C symbols */

/* stdC:
   * ...   &&   -=   >=   ~   +   ;   ]
   * <<=   &=   ->   >>   %   ,   <   ^
   * >>=   *=   /=   ^=   &   -   =   {
   * !=    ++   <<   |=   (   .   >   |
   * %=    +=   <=   ||   )   /   ?   }
   *     --   ==   !    *   :   [
   * recent addition:    <:  :>  <%  %>
   * only at processing: %:  %:%: # ##
   */

"["	TOCro
"]"	TCCro
"("	TOPar
")"	TCPar
"{"	TOBrace
"}"	TCBrace

"+"	TPlus
"*"	TMul
"-"	TMinus
"/"	TDiv
"%"	TMod

"++"	TInc
"--"	TDec

"="	TEq

"-="	TAssign
"+="	TAssign
"*="		TAssign
"/="		TAssign
"%="	TAssign
"&="	TAssign
"|="	TAssign
"^="	TAssign
"<<="	TAssign
">>="	TAssign

"=="	TEqEq
"!="	TNotEq
">="	TSupEq
"<="	TInfEq
/* c++ext: transformed in TInf_Template in parsing_hacks_cpp.ml */
"<" 	TInf
">"	TSup

"&&"	TAndLog
"||"	TOrLog
">>"	TShr
"<<"	TShl
"&"	TAnd
"|"	TOr
"^"	TXor
"->"	TPtrOp
"."	TDot
","	TComma
";"	TPtVirg
"?"	TWhy
":"	TCol
"!"    TBang
"~"	TTilde


"<:"	TOCro
":>"	TCCro
"<%"	TOBrace
"%>"	TCBrace

/* c++ext: */
"::"	TColCol
"->*"	TPtrOpStar
".*"	TDotStar

/* a valid C construct, also used by semgrep! */
"..."	TEllipsis
/* semgrep-ext: */
"<..."	LDots
"...>"	RDots

/* C keywords and ident */

/* StdC: "must handle at least name of length > 509, but can
* truncate to 31 when compare and truncate to 6 and even lowerise
* in the external linkage phase"
*/
{letter}({letter}|{digit})*	TIdent

/* gccext: apparently gcc allows dollar in variable names. I've found such
* things a few times in Linux and in glibc.
* No need to look in keyword_table here; definitly a TIdent.
* sgrep-ext: can use $X in sgrep too.
*/
({letter}|"$")({letter}|{digit}|"$")*		TIdent

/* sgrep-ext: */
"$..."[A-Z_][A-Z_0-9]*	TIdent

/* C constant */

L?'("\\".|[^'\n\r\\])+'	TChar
L?\"("\\".|[^"\n\r\\])*\"	TString
/* wide character encoding, TODO L'toto' valid ? what is allowed ? */

/* Take care of the order ? No because lex try the longest match. The
* strange diff between decimal and octal constant semantic is not
* understood too by refman :) refman:11.1.4, and ritchie.
*/
/* this is also part of the case below, but we specialize it here to use the
* right int_of_string */
"0"{oct}+	TInt
({decimal}|{hexa}|{octal})([uU]|[lL]|([lL][uU])|([uU][lL])|([uU][lL][lL])|([lL][lL]))?	TInt

{real}([fF]|[lL])?	TFloat

/* gccext: http://gcc.gnu.org/onlinedocs/gcc/Binary-constants.html */
/*
"0b"[0-1]	TInt
[0-1]+"b"	TInt
*/

%%
