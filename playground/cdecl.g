//From: https://github.com/paul-j-lucas/cdecl/blob/2d267345fbd842fe467cc77bc7089fe0ac40e6bf/src/parser.y
/*
**      cdecl -- C gibberish translator
**      src/parser.y
**
**      Copyright (C) 2017-2024  Paul J. Lucas, et al.
**
**      This program is free software: you can redistribute it and/or modify
**      it under the terms of the GNU General Public License as published by
**      the Free Software Foundation, either version 3 of the License, or
**      (at your option) any later version.
**
**      This program is distributed in the hope that it will be useful,
**      but WITHOUT ANY WARRANTY; without even the implied warranty of
**      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**      GNU General Public License for more details.
**
**      You should have received a copy of the GNU General Public License
**      along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

/*Tokens*/
%token Y_cast
%token Y_const_ENG
%token Y_declare
%token Y_define
%token Y_dynamic
%token Y_explain
%token Y_no
%token Y_quit
%token Y_reinterpret
%token Y_set
%token Y_show
%token Y_aligned
%token Y_all
%token Y_array
%token Y_as
%token Y_bit
%token Y_bit_precise
%token Y_bits
%token Y_by
%token Y_bytes
%token Y_capturing
//%token Y_commands
%token Y_constructor
%token Y_conversion
%token Y_copy
%token Y_defined
%token Y_destructor
%token Y_english
%token Y_evaluation
%token Y_expand
%token Y_expression
%token Y_floating
%token Y_function
%token Y_initialization
%token Y_into
%token Y_lambda
%token Y_length
%token Y_linkage
%token Y_literal
%token Y_macros
%token Y_member
%token Y_non_empty
%token Y_non_member
%token Y_of
//%token Y_options
%token Y_point
%token Y_pointer
%token Y_precise
%token Y_precision
%token Y_predefined
%token Y_pure
%token Y_reference
%token Y_returning
%token Y_rvalue
%token Y_scope
%token Y_to
%token Y_user
%token Y_user_defined
%token Y_variable
%token Y_wide
%token Y_width
%token Y_PREC_LESS_THAN_upc_layout_qualifier
%token Y_COLON_COLON
%token Y_COLON_COLON_STAR
%token Y_PLUS_PLUS
%token Y_MINUS_MINUS
%token Y_MINUS_GREATER
//%token Y_sizeof
%token Y_DOT_STAR
%token Y_MINUS_GREATER_STAR
%token Y_LESS_LESS
%token Y_GREATER_GREATER
%token Y_LESS_EQUAL_GREATER
%token Y_LESS_EQUAL
%token Y_GREATER_EQUAL
%token Y_EQUAL_EQUAL
%token Y_EXCLAM_EQUAL
//%token Y_bit_and
%token Y_AMPER_AMPER
%token Y_PIPE_PIPE
%token Y_QMARK_COLON
%token Y_PERCENT_EQUAL
%token Y_AMPER_EQUAL
%token Y_STAR_EQUAL
%token Y_PLUS_EQUAL
%token Y_MINUS_EQUAL
%token Y_SLASH_EQUAL
%token Y_LESS_LESS_EQUAL
%token Y_GREATER_GREATER_EQUAL
%token Y_CARET_EQUAL
%token Y_PIPE_EQUAL
%token Y_auto_STORAGE
//%token Y_break
//%token Y_case
%token Y_char
//%token Y_continue
%token Y_default
//%token Y_do
%token Y_double
//%token Y_else
%token Y_extern
%token Y_float
//%token Y_for
//%token Y_goto
//%token Y_if
%token Y_int
%token Y_long
%token Y_register
%token Y_return
%token Y_short
%token Y_static
%token Y_struct
//%token Y_switch
%token Y_typedef
%token Y_union
%token Y_unsigned
//%token Y_while
%token PY_CONCAT
%token PY_SPACE
%token PY_define
%token PY_elif
%token PY_else
%token PY_error
%token PY_if
%token PY_ifdef
%token PY_ifndef
%token PY_line
%token PY_undef
%token PY___VA_ARGS__
%token PY___VA_OPT__
%token PY_pragma
%token PY_elifdef
%token PY_elifndef
%token PY_embed
%token PY_warning
%token Y_asm
%token Y_const
//%token Y_DOT_DOT_DOT
%token Y_enum
%token Y_signed
%token Y_void
%token Y_volatile
%token Y_wchar_t
%token Y__Bool
%token Y__Complex
%token Y__Imaginary
%token Y_inline
%token Y_restrict
%token Y__Alignas
//%token Y__Alignof
%token Y__Atomic_QUAL
%token Y__Atomic_SPEC
//%token Y__Generic
%token Y__Noreturn
//%token Y__Static_assert
%token Y__Thread_local
%token Y_thread
%token Y_local
%token Y_bool
//%token Y_catch
%token Y_class
%token Y_const_cast
%token Y_CONSTRUCTOR_SNAME
%token Y_delete
%token Y_DESTRUCTOR_SNAME
%token Y_dynamic_cast
%token Y_explicit
%token Y_false
%token Y_friend
%token Y_mutable
%token Y_namespace
%token Y_new
%token Y_operator
%token Y_OPERATOR_SNAME
//%token Y_private
//%token Y_protected
//%token Y_public
%token Y_reinterpret_cast
%token Y_static_cast
%token Y_template
%token Y_this
%token Y_throw
%token Y_true
//%token Y_try
//%token Y_typeid
%token Y_typename
%token Y_using
%token Y_virtual
%token Y_char16_t
%token Y_char32_t
%token Y__BitInt
%token Y_reproducible
%token Y_typeof
%token Y_typeof_unqual
%token Y_unsequenced
%token Y_ATTR_BEGIN
%token Y_alignas
//%token Y_alignof
%token Y_auto_TYPE
%token Y_carries
%token Y_dependency
%token Y_carries_dependency
%token Y_constexpr
//%token Y_decltype
%token Y_except
%token Y_final
%token Y_noexcept
//%token Y_nullptr
%token Y_override
//%token Y_static_assert
%token Y_thread_local
%token Y_deprecated
%token Y_discard
%token Y_maybe_unused
%token Y_maybe
%token Y_unused
%token Y_nodiscard
%token Y_noreturn
%token Y_char8_t
//%token Y_concept
%token Y_consteval
%token Y_constinit
%token Y_co_await
//%token Y_co_return
//%token Y_co_yield
%token Y_export
%token Y_no_unique_address
//%token Y_requires
%token Y_unique
%token Y_address
%token Y_EMC__Accum
%token Y_EMC__Fract
%token Y_EMC__Sat
%token Y_UPC_relaxed
%token Y_UPC_shared
%token Y_UPC_strict
%token Y_GNU___attribute__
%token Y_GNU___restrict
%token Y_Apple___block
%token Y_Apple_block
%token Y_MSC___cdecl
%token Y_MSC___clrcall
%token Y_MSC___declspec
%token Y_MSC___fastcall
%token Y_MSC___stdcall
%token Y_MSC___thiscall
%token Y_MSC___vectorcall
%token Y_CHAR_LIT
%token Y_END
//%token Y_ERROR
%token Y_FLOAT_LIT
%token Y_GLOB
%token Y_INT_LIT
%token Y_NAME
%token Y_SET_OPTION
%token Y_STR_LIT
%token Y_TYPEDEF_NAME
%token Y_TYPEDEF_SNAME
%token Y_LEXER_ERROR

%nonassoc /*1*/ Y_PREC_LESS_THAN_upc_layout_qualifier
%left /*2*/ Y_COLON_COLON Y_COLON_COLON_STAR
%left /*3*/ '(' ')' '[' ']' '.' Y_MINUS_GREATER
%right /*4*/ '&' '*' '!'  '~' //Y_sizeof
%left /*5*/ Y_DOT_STAR Y_MINUS_GREATER_STAR
%left /*6*/ '/' '%'
%left /*7*/ '-' '+'
%left /*8*/ Y_LESS_LESS Y_GREATER_GREATER
%left /*9*/ Y_LESS_EQUAL_GREATER
%left /*10*/ '<' '>' Y_LESS_EQUAL Y_GREATER_EQUAL
%left /*11*/ Y_EQUAL_EQUAL Y_EXCLAM_EQUAL
//%left /*12*/ Y_bit_and
%left /*13*/ '^'
%left /*14*/ '|'
%left /*15*/ Y_AMPER_AMPER
%left /*16*/ Y_PIPE_PIPE
%right /*17*/ Y_QMARK_COLON '=' Y_PERCENT_EQUAL  Y_AMPER_EQUAL Y_STAR_EQUAL Y_PLUS_EQUAL Y_MINUS_EQUAL Y_SLASH_EQUAL Y_LESS_LESS_EQUAL Y_GREATER_GREATER_EQUAL Y_CARET_EQUAL Y_PIPE_EQUAL
%left /*18*/ ','

%start command_list

%%

command_list :
	/*empty*/
	| command_list command
	;

command :
	cast_command semi_or_end
	| declare_command semi_or_end
	| define_command semi_or_end
	| expand_command semi_or_end
	| explain_command semi_or_end
	| help_command semi_or_end
	| preprocessor_command Y_END
	| quit_command semi_or_end
	| scoped_command
	| set_command semi_or_end
	| show_command semi_or_end
	| template_command semi_or_end
	| typedef_command semi_or_end
	| using_command semi_or_end
	| semi_or_end
	//| error
	;

cast_command :
	Y_cast sname_english_opt as_into_to_exp decl_english_ast
	| new_style_cast_english sname_english_exp as_into_to_exp decl_english_ast
	;

new_style_cast_english :
	Y_const cast_exp
	| Y_dynamic cast_exp
	| Y_reinterpret cast_exp
	| Y_static cast_exp
	| new_style_cast_c
	;

declare_command :
	Y_declare sname_list_english as_exp alignas_or_width_decl_english_ast
	| Y_declare c_operator of_scope_list_english_opt as_exp type_qualifier_list_english_type_opt ref_qualifier_english_stid_opt member_or_non_member_opt operator_exp paren_param_decl_list_english_opt returning_english_ast_opt
	| Y_declare storage_class_subset_english_type_opt Y_lambda capturing_paren_capture_decl_list_english_opt paren_param_decl_list_english_opt returning_english_ast_opt
	| Y_declare storage_class_subset_english_type_opt cv_qualifier_list_stid_opt user_defined conversion_exp operator_opt of_scope_list_english_opt returning_exp decl_english_ast
	//| Y_declare error
	;

alignas_or_width_decl_english_ast :
	decl_english_ast
	| decl_english_ast alignas_specifier_english
	| decl_english_ast width_specifier_english_uint
	;

alignas_specifier_english :
	aligned_english uint_lit bytes_opt
	| aligned_english decl_english_ast
	//| aligned_english error
	;

aligned_english :
	Y_aligned as_or_to_opt
	| Y__Alignas
	| Y_alignas
	;

capturing_paren_capture_decl_list_english_opt :
	/*empty*/
	| Y_capturing paren_capture_decl_list_english
	| '[' /*3L*/ capture_decl_list_english_opt ']' /*3L*/
	;

paren_capture_decl_list_english :
	'[' /*3L*/ capture_decl_list_english_opt ']' /*3L*/
	| '(' /*3L*/ capture_decl_list_english_opt ')' /*3L*/
	//| error
	;

capture_decl_list_english_opt :
	/*empty*/
	| capture_decl_list_english
	;

capture_decl_list_english :
	capture_decl_list_english comma_exp capture_decl_english_ast
	| capture_decl_english_ast
	;

capture_decl_english_ast :
	Y_copy capture_default_opt
	| Y_reference capture_default_opt
	| Y_reference Y_to name_exp
	| capture_decl_c_ast
	;

capture_default_opt :
	/*empty*/
	| Y_by default_exp
	| Y_default
	;

width_specifier_english_uint :
	Y_width uint_lit_exp bits_opt
	;

storage_class_subset_english_type_opt :
	/*empty*/
	| storage_class_subset_english_type_opt storage_class_subset_english_type
	;

storage_class_subset_english_type :
	attribute_english_atid
	| storage_class_subset_english_stid
	;

storage_class_subset_english_stid :
	Y_const_ENG eval_expr_init_stid
	| Y_consteval
	| Y_constexpr
	| Y_constinit
	| Y_explicit
	| Y_export
	| Y_final
	| Y_friend
	| Y_inline
	| Y_mutable
	| Y_no Y_except
	| Y_noexcept
	| Y_override
	| Y_static
	| Y_throw
	| Y_virtual
	| Y_pure virtual_stid_exp
	;

define_command :
	Y_define sname_english_exp as_exp decl_english_ast
	;

expand_command :
	Y_expand Y_NAME expand_command2
	//| Y_expand error
	;

expand_command2 :
	/*empty*/
	| p_extra_token_except_lparen p_extra_tokens_opt
	| '(' /*3L*/ p_arg_list_opt ')' /*3L*/ p_extra_tokens_opt
	;

p_extra_token_except_lparen :
	p_arg_token_with_comma
	| ')' /*3L*/
	;

p_extra_tokens_opt :
	/*empty*/
	| p_extra_tokens
	;

p_extra_tokens :
	p_extra_tokens p_extra_token
	| p_extra_token
	;

p_extra_token :
	p_extra_token_except_lparen
	| '(' /*3L*/
	;

p_arg_list_opt :
	/*empty*/
	| p_arg_list
	| p_comma_arg_list
	| p_comma_arg_list p_arg_list
	| p_comma_arg_list p_arg_list p_comma_arg_list
	| p_arg_list p_comma_arg_list
	//| error
	;

p_comma_arg_list :
	p_comma_arg_list ',' /*18L*/
	| ',' /*18L*/
	;

p_arg_list :
	p_arg_list p_comma_arg_list p_arg_tokens
	| p_arg_tokens
	;

p_arg_tokens :
	p_arg_tokens p_arg_token_as_list
	| p_arg_token_as_list
	;

p_arg_token_as_list :
	p_arg_token
	| '(' /*3L*/ p_arg_tokens_with_comma_opt ')' /*3L*/
	;

p_arg_token :
	Y_CHAR_LIT
	| Y_NAME
	| p_num_lit
	| PY_SPACE
	| Y_STR_LIT
	| p_other
	| p_punctuator
	;

p_num_lit :
	Y_FLOAT_LIT
	| Y_INT_LIT
	;

p_other :
	'$'
	| '@'
	| '`'
	;

p_punctuator :
	'!' /*4R*/
	| '#'
	| '%' /*6L*/
	| '&' /*4R*/
	| '*' /*4R*/
	| '+' /*7L*/
	| '-' /*7L*/
	| '.' /*3L*/
	| '/' /*6L*/
	| ':'
	| ';'
	| '<' /*10L*/
	| '=' /*17R*/
	| '>' /*10L*/
	| '?'
	| '[' /*3L*/
	| ']' /*3L*/
	| '^' /*13L*/
	| '{'
	| '|' /*14L*/
	| '}'
	| '~' /*4R*/
	| Y_AMPER_AMPER /*15L*/
	| Y_AMPER_EQUAL /*17R*/
	| Y_CARET_EQUAL /*17R*/
	| Y_COLON_COLON /*2L*/
	| "..."
	| Y_DOT_STAR /*5L*/
	| Y_EQUAL_EQUAL /*11L*/
	| Y_EXCLAM_EQUAL /*11L*/
	| Y_GREATER_EQUAL /*10L*/
	| Y_GREATER_GREATER /*8L*/
	| Y_GREATER_GREATER_EQUAL /*17R*/
	| Y_LESS_EQUAL /*10L*/
	| Y_LESS_EQUAL_GREATER /*9L*/
	| Y_LESS_LESS /*8L*/
	| Y_LESS_LESS_EQUAL /*17R*/
	| Y_MINUS_EQUAL /*17R*/
	| Y_MINUS_GREATER /*3L*/
	| Y_MINUS_GREATER_STAR /*5L*/
	| Y_MINUS_MINUS
	| Y_PERCENT_EQUAL /*17R*/
	| Y_PIPE_EQUAL /*17R*/
	| Y_PIPE_PIPE /*16L*/
	| Y_PLUS_EQUAL /*17R*/
	| Y_PLUS_PLUS
	| Y_SLASH_EQUAL /*17R*/
	| Y_STAR_EQUAL /*17R*/
	;

p_arg_tokens_with_comma_opt :
	/*empty*/
	| p_arg_tokens_with_comma
	;

p_arg_tokens_with_comma :
	p_arg_tokens_with_comma p_arg_token_with_comma_as_list
	| p_arg_token_with_comma_as_list
	;

p_arg_token_with_comma_as_list :
	p_arg_token_with_comma
	| '(' /*3L*/ p_arg_tokens_with_comma_opt ')' /*3L*/
	;

p_arg_token_with_comma :
	p_arg_token
	| ',' /*18L*/
	;

explain_command :
	explain c_style_cast_expr_c
	| explain new_style_cast_expr_c
	| explain typed_declaration_c
	| explain aligned_declaration_c
	| explain asm_declaration_c
	| explain file_scope_constructor_declaration_c
	| explain destructor_declaration_c
	| explain file_scope_destructor_declaration_c
	| explain lambda_declaration_c
	| explain pc99_func_or_constructor_declaration_c
	| explain pc99_pointer_decl_list_c
	| explain template_declaration_c
	| explain Y_typename typed_declaration_c
	| explain user_defined_conversion_declaration_c
	| explain extern_linkage_c_stid_opt using_decl_c_ast
	| explain sname_c
	//| explain error
	;

explain :
	Y_explain
	;

help_command :
	'?' help_what_opt
	;

help_what_opt :
	/*empty*/
	| name_cat
	| '#' Y_NAME
	//| '#' error
	//| error
	;

preprocessor_command :
	'#'
	| '#' p_define
	| '#' p_undef
	| '#' PY_elif
	| '#' PY_elifdef
	| '#' PY_elifndef
	| '#' PY_else
	| '#' PY_embed
	| '#' PY_error
	| '#' PY_if
	| '#' PY_ifdef
	| '#' PY_ifndef
	| '#' PY_line
	| '#' PY_pragma
	| '#' PY_warning
	//| '#' error
	;

p_define :
	PY_define name_exp p_paren_param_list_opt p_replace_list_opt
	;

p_paren_param_list_opt :
	/*empty*/
	| '(' /*3L*/ p_param_list_opt ')' /*3L*/
	;

p_param_list_opt :
	/*empty*/
	| p_param_list
	;

p_param_list :
	p_param_list comma_exp p_param
	| p_param
	;

p_param :
	Y_NAME
	| "..."
	//| error
	;

p_replace_list_opt :
	/*empty*/
	| p_replace_list
	;

p_replace_list :
	p_replace_list p_replace_token
	| p_replace_token
	;

p_replace_token :
	p_arg_token
	| '(' /*3L*/
	| ')' /*3L*/
	| ',' /*18L*/
	| PY_CONCAT
	| PY___VA_ARGS__
	| PY___VA_OPT__
	;

p_undef :
	PY_undef name_exp
	;

quit_command :
	Y_quit
	;

scoped_command :
	scoped_declaration_c
	;

set_command :
	Y_set
	| Y_set set_option_list
	;

set_option_list :
	set_option_list set_option
	| set_option
	;

set_option :
	Y_SET_OPTION set_option_value_opt
	;

set_option_value_opt :
	/*empty*/
	| '=' /*17R*/ Y_SET_OPTION
	//| '=' /*17R*/ error
	;

show_command :
	Y_show any_typedef show_format_opt
	| Y_show any_typedef Y_as show_format_exp
	| Y_show show_types_opt glob_opt show_format_opt
	| Y_show show_types_opt glob_opt Y_as show_format_exp
	| Y_show show_types_opt Y_macros
	| Y_show Y_NAME
	//| Y_show error
	;

show_format :
	Y_english
	| Y_typedef
	| Y_using
	;

show_format_exp :
	show_format
	//| error
	;

show_format_opt :
	/*empty*/
	| show_format
	;

show_types_opt :
	/*empty*/
	| Y_all predefined_or_user_types_opt
	| Y_predefined
	| Y_user
	;

predefined_or_user_types_opt :
	/*empty*/
	| Y_predefined
	| Y_user
	;

template_command :
	template_declaration_c
	;

typedef_command :
	typedef_declaration_c
	;

using_command :
	using_declaration_c
	;

c_style_cast_expr_c :
	'(' /*3L*/ type_c_ast cast_c_astp_opt rparen_exp sname_c_opt
	| '(' /*3L*/ pc99_pointer_decl_list_c rparen_exp
	;

new_style_cast_expr_c :
	new_style_cast_c lt_exp type_c_ast cast_c_astp_opt gt_exp lparen_exp sname_c_exp rparen_exp
	;

new_style_cast_c :
	Y_const_cast
	| Y_dynamic_cast
	| Y_reinterpret_cast
	| Y_static_cast
	;

aligned_declaration_c :
	alignas_specifier_c typename_flag_opt typed_declaration_c
	;

alignas_specifier_c :
	alignas lparen_exp uint_lit rparen_exp
	| alignas lparen_exp type_c_ast cast_c_astp_opt rparen_exp
	//| alignas lparen_exp error ')' /*3L*/
	;

alignas :
	Y__Alignas
	| Y_alignas
	;

asm_declaration_c :
	Y_asm lparen_exp str_lit_exp rparen_exp
	;

scoped_declaration_c :
	class_struct_union_declaration_c
	| enum_declaration_c
	| namespace_declaration_c
	;

class_struct_union_declaration_c :
	class_struct_union_btid any_sname_c_exp brace_in_scope_declaration_c_opt
	;

enum_declaration_c :
	enum_btids any_sname_c_exp enum_fixed_type_c_ast_opt
	;

namespace_declaration_c :
	namespace_type namespace_sname_c_exp brace_in_scope_declaration_c_exp
	;

namespace_sname_c_exp :
	namespace_sname_c
	| namespace_typedef_sname_c
	//| error
	;

namespace_sname_c :
	namespace_sname_c Y_COLON_COLON /*2L*/ Y_NAME
	| namespace_sname_c Y_COLON_COLON /*2L*/ any_typedef
	| namespace_sname_c Y_COLON_COLON /*2L*/ Y_inline name_exp
	| Y_NAME
	;

namespace_typedef_sname_c :
	namespace_typedef_sname_c Y_COLON_COLON /*2L*/ sname_c
	| namespace_typedef_sname_c Y_COLON_COLON /*2L*/ any_typedef
	| namespace_typedef_sname_c Y_COLON_COLON /*2L*/ Y_inline name_exp
	| any_typedef
	;

brace_in_scope_declaration_c_exp :
	brace_in_scope_declaration_c
	//| error
	;

brace_in_scope_declaration_c_opt :
	/*empty*/
	| brace_in_scope_declaration_c
	;

brace_in_scope_declaration_c :
	'{' '}'
	| '{' in_scope_declaration_c_exp semi_opt rbrace_exp
	;

in_scope_declaration_c_exp :
	scoped_declaration_c
	| typedef_declaration_c semi_exp
	| using_declaration_c semi_exp
	//| error
	;

lambda_declaration_c :
	'[' /*3L*/ capture_decl_list_c_opt ']' /*3L*/ lambda_param_c_ast_list_opt storage_class_subset_english_type_opt lambda_return_type_c_ast_opt
	;

capture_decl_list_c_opt :
	/*empty*/
	| capture_decl_list_c
	;

capture_decl_list_c :
	capture_decl_list_c comma_exp capture_decl_c_ast
	| capture_decl_c_ast
	;

capture_decl_c_ast :
	'&' /*4R*/
	| '&' /*4R*/ Y_NAME
	| '=' /*17R*/
	| Y_NAME
	| Y_this
	| '*' /*4R*/ this_exp
	;

lambda_param_c_ast_list_opt :
	/*empty*/
	| '(' /*3L*/ param_c_ast_list_opt ')' /*3L*/
	;

lambda_return_type_c_ast_opt :
	/*empty*/
	| Y_MINUS_GREATER /*3L*/ type_c_ast cast_c_astp_opt
	;

template_declaration_c :
	Y_template
	;

typed_declaration_c :
	type_c_ast decl_list_c_opt
	;

typedef_declaration_c :
	Y_typedef typename_flag_opt type_c_ast typedef_decl_list_c
	;

typedef_decl_list_c :
	typedef_decl_list_c ',' /*18L*/ typedef_decl_c_exp
	| typedef_decl_c
	;

typedef_decl_c :
	decl_c_astp
	;

typedef_decl_c_exp :
	typedef_decl_c
	//| error
	;

user_defined_conversion_declaration_c :
	user_defined_conversion_decl_c_astp
	;

using_declaration_c :
	using_decl_c_ast
	;

using_decl_c_ast :
	Y_using any_name_exp attribute_specifier_list_c_atid_opt equals_exp type_c_ast cast_c_astp_opt
	;

decl_list_c_opt :
	/*empty*/
	| decl_list_c
	;

decl_list_c :
	decl_list_c ',' /*18L*/ decl_c_exp
	| decl_c
	;

decl_c :
	decl_c_astp
	;

decl_c_exp :
	decl_c
	//| error
	;

decl_c_astp :
	decl2_c_astp
	| pointer_decl_c_astp
	| pointer_to_member_decl_c_astp
	| reference_decl_c_astp
	| msc_calling_convention_atid msc_calling_convention_c_astp
	;

msc_calling_convention_c_astp :
	func_decl_c_astp
	| pointer_decl_c_astp
	;

decl2_c_astp :
	array_decl_c_astp
	| block_decl_c_astp
	| func_decl_c_astp
	| nested_decl_c_astp
	| oper_decl_c_astp
	| sname_c_ast gnu_attribute_specifier_list_c_opt
	| typedef_type_decl_c_ast
	| user_defined_conversion_decl_c_astp
	| user_defined_literal_decl_c_astp
	;

array_decl_c_astp :
	decl2_c_astp array_size_c_ast gnu_attribute_specifier_list_c_opt
	;

array_size_c_ast :
	'[' /*3L*/ rbracket_exp
	| '[' /*3L*/ uint_lit rbracket_exp
	| '[' /*3L*/ Y_NAME rbracket_exp
	| '[' /*3L*/ type_qualifier_list_c_stid rbracket_exp
	| '[' /*3L*/ type_qualifier_list_c_stid static_stid_opt uint_lit rbracket_exp
	| '[' /*3L*/ type_qualifier_list_c_stid static_stid_opt Y_NAME rbracket_exp
	| '[' /*3L*/ type_qualifier_list_c_stid_opt '*' /*4R*/ rbracket_exp
	| '[' /*3L*/ Y_static type_qualifier_list_c_stid_opt uint_lit rbracket_exp
	| '[' /*3L*/ Y_static type_qualifier_list_c_stid_opt Y_NAME rbracket_exp
	//| '[' /*3L*/ error ']' /*3L*/
	;

block_decl_c_astp :
	'(' /*3L*/ '^' /*13L*/ type_qualifier_list_c_stid_opt decl_c_astp rparen_exp lparen_exp param_c_ast_list_opt ')' /*3L*/ gnu_attribute_specifier_list_c_opt
	;

destructor_declaration_c :
	virtual_stid_opt '~' /*4R*/ any_name_exp lparen_exp no_destructor_params rparen_func_qualifier_list_c_stid_opt noexcept_c_stid_opt gnu_attribute_specifier_list_c_opt func_equals_c_stid_opt
	;

no_destructor_params :
	/*empty*/
	//| error
	;

file_scope_constructor_declaration_c :
	inline_stid_opt Y_CONSTRUCTOR_SNAME lparen_exp param_c_ast_list_opt rparen_func_qualifier_list_c_stid_opt noexcept_c_stid_opt gnu_attribute_specifier_list_c_opt
	;

file_scope_destructor_declaration_c :
	inline_stid_opt destructor_sname lparen_exp no_destructor_params rparen_func_qualifier_list_c_stid_opt noexcept_c_stid_opt gnu_attribute_specifier_list_c_opt
	;

func_decl_c_astp :
	decl2_c_astp '(' /*3L*/ param_c_ast_list_opt rparen_func_qualifier_list_c_stid_opt func_ref_qualifier_c_stid_opt noexcept_c_stid_opt trailing_return_type_c_ast_opt func_equals_c_stid_opt
	;

pc99_func_or_constructor_declaration_c :
	Y_NAME '(' /*3L*/ param_c_ast_list_opt ')' /*3L*/ noexcept_c_stid_opt func_equals_c_stid_opt
	;

rparen_func_qualifier_list_c_stid_opt :
	')' /*3L*/ func_qualifier_list_c_stid_opt
	;

func_qualifier_list_c_stid_opt :
	/*empty*/
	| func_qualifier_list_c_stid_opt func_qualifier_c_stid
	;

func_qualifier_c_stid :
	cv_qualifier_stid
	| Y_final
	| Y_override
	| Y_GNU___restrict
	;

func_ref_qualifier_c_stid_opt :
	/*empty*/
	| '&' /*4R*/
	| Y_AMPER_AMPER /*15L*/
	;

noexcept_c_stid_opt :
	/*empty*/
	| Y_noexcept
	| Y_noexcept '(' /*3L*/ noexcept_bool_stid_exp rparen_exp
	| Y_throw lparen_exp rparen_exp
	| Y_throw lparen_exp param_c_ast_list ')' /*3L*/
	;

noexcept_bool_stid_exp :
	Y_false
	| Y_true
	//| error
	;

trailing_return_type_c_ast_opt :
	/*empty*/
	| Y_MINUS_GREATER /*3L*/ type_c_ast cast_c_astp_opt
	| gnu_attribute_specifier_list_c
	;

func_equals_c_stid_opt :
	/*empty*/
	| '=' /*17R*/ Y_default
	| '=' /*17R*/ Y_delete
	| '=' /*17R*/ uint_lit
	//| '=' /*17R*/ error
	;

param_c_ast_list_exp :
	param_c_ast_list
	//| error
	;

param_c_ast_list_opt :
	/*empty*/
	| param_c_ast_list
	;

param_c_ast_list :
	param_c_ast_list comma_exp param_c_ast_exp
	| param_c_ast
	;

param_c_ast :
	this_stid_opt type_c_ast cast_c_astp_opt
	| name_ast
	| "..."
	;

param_c_ast_exp :
	param_c_ast
	//| error
	;

nested_decl_c_astp :
	'(' /*3L*/ decl_c_astp rparen_exp
	;

oper_decl_c_astp :
	oper_sname_c_opt Y_operator c_operator lparen_exp param_c_ast_list_opt rparen_func_qualifier_list_c_stid_opt func_ref_qualifier_c_stid_opt noexcept_c_stid_opt trailing_return_type_c_ast_opt func_equals_c_stid_opt
	;

pointer_decl_c_astp :
	pointer_type_c_ast decl_c_astp
	;

pointer_type_c_ast :
	'*' /*4R*/ type_qualifier_list_c_stid_opt
	;

pc99_pointer_decl_list_c :
	pc99_pointer_decl_c ',' /*18L*/ decl_list_c
	| pc99_pointer_decl_c
	;

pc99_pointer_decl_c :
	pc99_pointer_type_c_ast decl_c_astp
	;

pc99_pointer_type_c_ast :
	'*' /*4R*/ type_qualifier_list_c_stid_opt
	;

pointer_to_member_decl_c_astp :
	pointer_to_member_type_c_ast decl_c_astp
	;

pointer_to_member_type_c_ast :
	any_sname_c Y_COLON_COLON_STAR /*2L*/ '*' /*4R*/ cv_qualifier_list_stid_opt
	;

reference_decl_c_astp :
	reference_type_c_ast decl_c_astp
	;

reference_type_c_ast :
	'&' /*4R*/ type_qualifier_list_c_stid_opt
	| Y_AMPER_AMPER /*15L*/ type_qualifier_list_c_stid_opt
	;

typedef_type_decl_c_ast :
	typedef_type_c_ast bit_field_c_uint_opt
	;

user_defined_conversion_decl_c_astp :
	oper_sname_c_opt Y_operator type_c_ast udc_decl_c_ast_opt lparen_exp rparen_func_qualifier_list_c_stid_opt noexcept_c_stid_opt func_equals_c_stid_opt
	;

user_defined_literal_decl_c_astp :
	oper_sname_c_opt Y_operator empty_str_lit_exp name_exp lparen_exp param_c_ast_list_exp ')' /*3L*/ noexcept_c_stid_opt trailing_return_type_c_ast_opt
	;

cast_c_astp_opt :
	/*empty*/
	| cast_c_astp
	;

cast_c_astp :
	cast2_c_astp
	| pointer_cast_c_astp
	| pointer_to_member_cast_c_astp
	| reference_cast_c_astp
	;

cast2_c_astp :
	array_cast_c_astp
	| block_cast_c_astp
	| func_cast_c_astp
	| nested_cast_c_astp
	| sname_c_ast
	;

array_cast_c_astp :
	cast_c_astp_opt array_size_c_ast
	;

block_cast_c_astp :
	'(' /*3L*/ '^' /*13L*/ type_qualifier_list_c_stid_opt cast_c_astp_opt rparen_exp lparen_exp param_c_ast_list_opt ')' /*3L*/
	;

func_cast_c_astp :
	cast2_c_astp '(' /*3L*/ param_c_ast_list_opt rparen_func_qualifier_list_c_stid_opt noexcept_c_stid_opt trailing_return_type_c_ast_opt
	;

nested_cast_c_astp :
	'(' /*3L*/ cast_c_astp_opt rparen_exp
	;

pointer_cast_c_astp :
	pointer_type_c_ast cast_c_astp_opt
	;

pointer_to_member_cast_c_astp :
	pointer_to_member_type_c_ast cast_c_astp_opt
	;

reference_cast_c_astp :
	reference_type_c_ast cast_c_astp_opt
	;

udc_decl_c_ast_opt :
	/*empty*/
	| udc_decl_c_ast
	;

udc_decl_c_ast :
	pointer_udc_decl_c_ast
	| pointer_to_member_udc_decl_c_ast
	| reference_udc_decl_c_ast
	| sname_c_ast
	;

pointer_udc_decl_c_ast :
	pointer_type_c_ast udc_decl_c_ast_opt
	;

pointer_to_member_udc_decl_c_ast :
	pointer_to_member_type_c_ast udc_decl_c_ast_opt
	;

reference_udc_decl_c_ast :
	reference_type_c_ast udc_decl_c_ast_opt
	;

type_c_ast :
	type_modifier_list_c_type
	| type_modifier_list_c_type east_modified_type_c_ast
	| east_modified_type_c_ast
	;

type_modifier_list_c_type_opt :
	/*empty*/
	| type_modifier_list_c_type
	;

type_modifier_list_c_type :
	type_modifier_list_c_type type_modifier_c_type
	| type_modifier_c_type
	;

type_modifier_c_type :
	type_modifier_base_type
	| type_qualifier_c_stid
	| storage_class_c_type
	| attribute_specifier_list_c_atid
	;

type_modifier_base_type :
	Y__Complex
	| Y__Imaginary
	| Y_long
	| Y_short
	| Y_signed
	| Y_unsigned
	| Y_EMC__Sat
	| Y_register
	;

east_modified_type_c_ast :
	atomic_builtin_typedef_type_c_ast type_modifier_list_c_type_opt
	| enum_class_struct_union_c_ast cv_qualifier_list_stid_opt
	;

atomic_builtin_typedef_type_c_ast :
	atomic_specifier_type_c_ast
	| builtin_type_c_ast
	| typedef_type_c_ast
	| typeof_type_c_ast
	;

atomic_specifier_type_c_ast :
	Y__Atomic_SPEC lparen_exp type_c_ast cast_c_astp_opt rparen_exp
	;

builtin_type_c_ast :
	builtin_no_BitInt_c_btid
	| Y__BitInt lparen_exp uint_lit_exp rparen_exp
	;

builtin_no_BitInt_c_btid :
	Y_void
	| Y_auto_TYPE
	| Y__Bool
	| Y_bool
	| Y_char
	| Y_char8_t
	| Y_char16_t
	| Y_char32_t
	| Y_wchar_t
	| Y_int
	| Y_float
	| Y_double
	| Y_EMC__Accum
	| Y_EMC__Fract
	;

typeof_type_c_ast :
	typeof lparen_exp type_c_ast cast_c_astp_opt rparen_exp
	//| typeof lparen_exp error
	;

typeof :
	Y_typeof
	| Y_typeof_unqual
	;

enum_class_struct_union_c_ast :
	class_struct_union_c_ast
	| enum_c_ast
	;

class_struct_union_c_ast :
	class_struct_union_btid attribute_specifier_list_c_atid_opt any_sname_c_exp
	| class_struct_union_btid attribute_specifier_list_c_atid_opt any_sname_c_opt '{'
	;

enum_c_ast :
	enum_btids attribute_specifier_list_c_atid_opt any_sname_c_exp enum_fixed_type_c_ast_opt
	| enum_btids attribute_specifier_list_c_atid_opt any_sname_c_opt '{'
	;

enum_btids :
	Y_enum class_struct_btid_opt
	;

enum_fixed_type_c_ast_opt :
	/*empty*/
	| ':' enum_fixed_type_c_ast
	//| ':' error
	;

enum_fixed_type_c_ast :
	enum_fixed_type_modifier_list_btid
	| enum_fixed_type_modifier_list_btid enum_unmodified_fixed_type_c_ast enum_fixed_type_modifier_list_btid_opt
	| enum_unmodified_fixed_type_c_ast enum_fixed_type_modifier_list_btid_opt
	;

enum_fixed_type_modifier_list_btid_opt :
	/*empty*/
	| enum_fixed_type_modifier_list_btid
	;

enum_fixed_type_modifier_list_btid :
	enum_fixed_type_modifier_list_btid enum_fixed_type_modifier_btid
	| enum_fixed_type_modifier_btid
	;

enum_fixed_type_modifier_btid :
	Y_long
	| Y_short
	| Y_signed
	| Y_unsigned
	;

enum_unmodified_fixed_type_c_ast :
	builtin_type_c_ast
	| typedef_type_c_ast
	| typeof_type_c_ast
	;

class_struct_btid_opt :
	/*empty*/
	| class_struct_btid
	;

class_struct_btid :
	Y_class
	| Y_struct
	;

class_struct_union_btid :
	class_struct_btid
	| Y_union
	;

type_qualifier_list_c_stid_opt :
	/*empty*/
	| type_qualifier_list_c_stid
	;

type_qualifier_list_c_stid :
	type_qualifier_list_c_stid type_qualifier_c_stid gnu_or_msc_attribute_specifier_list_c_opt
	| gnu_or_msc_attribute_specifier_list_c type_qualifier_c_stid
	| type_qualifier_c_stid gnu_or_msc_attribute_specifier_list_c_opt
	;

type_qualifier_c_stid :
	Y__Atomic_QUAL
	| cv_qualifier_stid
	| restrict_qualifier_c_stid
	| Y_UPC_relaxed
	| Y_UPC_shared %prec Y_PREC_LESS_THAN_upc_layout_qualifier /*1N*/
	| Y_UPC_shared upc_layout_qualifier_c
	| Y_UPC_strict
	;

cv_qualifier_stid :
	Y_const
	| Y_volatile
	;

cv_qualifier_list_stid_opt :
	/*empty*/
	| cv_qualifier_list_stid_opt cv_qualifier_stid
	;

restrict_qualifier_c_stid :
	Y_restrict
	| Y_GNU___restrict
	;

upc_layout_qualifier_c :
	'[' /*3L*/ ']' /*3L*/
	| '[' /*3L*/ uint_lit rbracket_exp
	| '[' /*3L*/ '*' /*4R*/ rbracket_exp
	//| '[' /*3L*/ error ']' /*3L*/
	;

storage_class_c_type :
	Y_auto_STORAGE
	| Y_Apple___block
	| Y_consteval
	| Y_constexpr
	| Y_constinit
	| Y_explicit
	| Y_export
	| Y_extern
	| extern_linkage_c_stid
	| Y_final
	| Y_friend
	| Y_inline
	| Y_mutable
	| _Noreturn_atid
	| Y_override
	| Y_static
	| Y_typedef
	| Y__Thread_local
	| Y_thread_local
	| Y_virtual
	;

_Noreturn_atid :
	Y__Noreturn
	| Y_noreturn
	;

attribute_specifier_list_c_atid_opt :
	/*empty*/
	| attribute_specifier_list_c_atid
	;

attribute_specifier_list_c_atid :
	Y_ATTR_BEGIN '[' /*3L*/ using_opt attribute_list_c_atid_opt ']' /*3L*/ rbracket_exp
	| gnu_or_msc_attribute_specifier_list_c
	;

using_opt :
	/*empty*/
	| Y_using name_exp colon_exp
	;

attribute_list_c_atid_opt :
	/*empty*/
	| attribute_list_c_atid
	;

attribute_list_c_atid :
	attribute_list_c_atid comma_exp attribute_c_atid_exp
	| attribute_c_atid_exp
	;

attribute_c_atid_exp :
	Y_carries_dependency
	| Y_deprecated attribute_str_arg_c_opt
	| Y_maybe_unused
	| Y_nodiscard attribute_str_arg_c_opt
	| Y_noreturn
	| Y_no_unique_address
	| Y_reproducible
	| Y_unsequenced
	| sname_c
	//| error
	;

attribute_str_arg_c_opt :
	/*empty*/
	| '(' /*3L*/ str_lit_exp rparen_exp
	;

gnu_or_msc_attribute_specifier_list_c_opt :
	/*empty*/
	| gnu_or_msc_attribute_specifier_list_c
	;

gnu_or_msc_attribute_specifier_list_c :
	gnu_attribute_specifier_list_c
	| msc_attribute_specifier_list_c
	;

gnu_attribute_specifier_list_c_opt :
	/*empty*/
	| gnu_attribute_specifier_list_c
	;

gnu_attribute_specifier_list_c :
	gnu_attribute_specifier_list_c gnu_attribute_specifier_c
	| gnu_attribute_specifier_c
	;

gnu_attribute_specifier_c :
	Y_GNU___attribute__ lparen_exp lparen_exp gnu_attribute_list_c_opt ')' /*3L*/ rparen_exp
	;

gnu_attribute_list_c_opt :
	/*empty*/
	| gnu_attribuet_list_c
	;

gnu_attribuet_list_c :
	gnu_attribuet_list_c comma_exp gnu_attribute_c_exp
	| gnu_attribute_c_exp
	;

gnu_attribute_c_exp :
	Y_NAME gnu_attribute_decl_arg_list_c_opt
	//| error
	;

gnu_attribute_decl_arg_list_c_opt :
	/*empty*/
	| '(' /*3L*/ gnu_attribute_arg_list_c_opt ')' /*3L*/
	;

gnu_attribute_arg_list_c_opt :
	/*empty*/
	| gnu_attribute_arg_list_c
	;

gnu_attribute_arg_list_c :
	gnu_attribute_arg_list_c comma_exp gnu_attribute_arg_c
	| gnu_attribute_arg_c
	;

gnu_attribute_arg_c :
	Y_NAME
	| Y_CHAR_LIT
	| Y_INT_LIT
	| Y_STR_LIT
	| '(' /*3L*/ gnu_attribute_arg_list_c rparen_exp
	| Y_LEXER_ERROR
	;

msc_attribute_specifier_list_c :
	msc_attribute_specifier_list_c msc_attribute_specifier_c
	| msc_attribute_specifier_c
	;

msc_attribute_specifier_c :
	Y_MSC___declspec lparen_exp msc_attribute_list_c_opt ')' /*3L*/
	;

msc_attribute_list_c_opt :
	/*empty*/
	| msc_attribuet_list_c
	;

msc_attribuet_list_c :
	msc_attribuet_list_c gnu_attribute_c_exp
	| gnu_attribute_c_exp
	;

decl_english_ast :
	qualified_decl_english_ast
	| user_defined_literal_decl_english_ast
	| var_decl_english_ast
	;

array_decl_english_ast :
	Y_array array_size_decl_ast of_exp decl_english_ast
	| Y_variable length_opt array_exp name_opt of_exp decl_english_ast
	;

array_size_decl_ast :
	/*empty*/
	| uint_lit
	| Y_NAME
	| '*' /*4R*/
	;

length_opt :
	/*empty*/
	| Y_length
	;

block_decl_english_ast :
	Y_Apple_block paren_param_decl_list_english_opt returning_english_ast_opt
	;

constructor_decl_english_ast :
	Y_constructor paren_param_decl_list_english_opt
	;

destructor_decl_english_ast :
	Y_destructor destructor_parens_opt
	;

destructor_parens_opt :
	/*empty*/
	| '(' /*3L*/ no_destructor_params ')' /*3L*/
	;

func_decl_english_ast :
	func_qualifier_english_type_opt member_or_non_member_opt Y_function paren_param_decl_list_english_opt returning_english_ast_opt
	;

func_qualifier_english_type_opt :
	ref_qualifier_english_stid_opt
	| msc_calling_convention_atid
	;

msc_calling_convention_atid :
	Y_MSC___cdecl
	| Y_MSC___clrcall
	| Y_MSC___fastcall
	| Y_MSC___stdcall
	| Y_MSC___thiscall
	| Y_MSC___vectorcall
	;

paren_param_decl_list_english_opt :
	/*empty*/
	| paren_param_decl_list_english
	;

paren_param_decl_list_english :
	'(' /*3L*/ param_decl_list_english_opt ')' /*3L*/
	;

param_decl_list_english_opt :
	/*empty*/
	| param_decl_list_english
	;

param_decl_list_english :
	param_decl_list_english comma_exp decl_english_ast_exp
	| decl_english_ast
	;

decl_english_ast_exp :
	decl_english_ast
	//| error
	;

ref_qualifier_english_stid_opt :
	/*empty*/
	| Y_reference
	| Y_rvalue reference_exp
	;

returning_english_ast_opt :
	/*empty*/
	| returning_english_ast
	;

returning_english_ast :
	returning decl_english_ast
	//| returning error
	;

qualified_decl_english_ast :
	type_qualifier_list_english_type_opt qualifiable_decl_english_ast
	;

type_qualifier_list_english_type_opt :
	/*empty*/
	| type_qualifier_list_english_type
	;

type_qualifier_list_english_type :
	type_qualifier_list_english_type type_qualifier_english_type
	| type_qualifier_english_type
	;

type_qualifier_english_type :
	attribute_english_atid
	| storage_class_english_stid
	| type_qualifier_english_stid
	;

attribute_english_atid :
	Y_carries dependency_exp
	| Y_carries_dependency
	| Y_deprecated
	| Y_maybe unused_exp
	| Y_maybe_unused
	| Y_no Y_discard
	| Y_nodiscard
	| Y_no Y_return
	| Y__Noreturn
	| Y_noreturn
	| Y_no Y_unique address_exp
	| Y_no_unique_address
	| Y_reproducible
	| Y_unsequenced
	;

storage_class_english_stid :
	Y_auto_STORAGE
	| Y_Apple___block
	| Y_const_ENG eval_expr_init_stid
	| Y_consteval
	| Y_constexpr
	| Y_constinit
	| Y_default
	| Y_delete
	| Y_explicit
	| Y_export
	| Y_extern
	| Y_extern linkage_stid linkage_opt
	| Y_final
	| Y_friend
	| Y_inline
	| Y_mutable
	| Y_no Y_except
	| Y_noexcept
	| Y_non_empty
	| Y_override
	| Y_static
	| Y_this
	| Y_thread local_exp
	| Y__Thread_local
	| Y_thread_local
	| Y_throw
	| Y_typedef
	| Y_virtual
	| Y_pure virtual_stid_exp
	;

eval_expr_init_stid :
	Y_evaluation
	| Y_expression
	| Y_initialization
	;

linkage_stid :
	str_lit
	;

linkage_opt :
	/*empty*/
	| Y_linkage
	;

type_qualifier_english_stid :
	Y__Atomic_QUAL
	| cv_qualifier_stid
	| restrict_qualifier_c_stid
	| Y_UPC_relaxed
	| Y_UPC_shared %prec Y_PREC_LESS_THAN_upc_layout_qualifier /*1N*/
	| Y_UPC_shared upc_layout_qualifier_english
	| Y_UPC_strict
	;

upc_layout_qualifier_english :
	uint_lit
	| '*' /*4R*/
	;

qualifiable_decl_english_ast :
	array_decl_english_ast
	| block_decl_english_ast
	| constructor_decl_english_ast
	| destructor_decl_english_ast
	| func_decl_english_ast
	| pointer_decl_english_ast
	| reference_decl_english_ast
	| type_english_ast
	;

pointer_decl_english_ast :
	Y_pointer to_exp decl_english_ast
	| Y_pointer to_exp Y_member of_exp class_struct_union_btid_exp sname_english_exp decl_english_ast
	//| Y_pointer to_exp error
	;

reference_decl_english_ast :
	reference_english_ast to_exp decl_english_ast
	;

reference_english_ast :
	Y_reference
	| Y_rvalue reference_exp
	;

user_defined_literal_decl_english_ast :
	user_defined literal_exp lparen_exp param_decl_list_english_opt ')' /*3L*/ returning_english_ast_opt
	;

var_decl_english_ast :
	sname_c Y_as decl_english_ast
	| sname_english_ast
	| "..."
	;

type_english_ast :
	type_modifier_list_english_type_opt unmodified_type_english_ast
	| type_modifier_list_english_type
	;

type_modifier_list_english_type_opt :
	/*empty*/
	| type_modifier_list_english_type
	;

type_modifier_list_english_type :
	type_modifier_list_english_type type_modifier_english_type
	| type_modifier_english_type
	;

type_modifier_english_type :
	type_modifier_base_type
	;

unmodified_type_english_ast :
	builtin_type_english_ast
	| class_struct_union_english_ast
	| enum_english_ast
	| typedef_type_c_ast
	;

builtin_type_english_ast :
	builtin_no_BitInt_english_btid
	| BitInt_english_int
	;

builtin_no_BitInt_english_btid :
	Y_void
	| Y_auto_TYPE
	| Y__Bool
	| Y_bool
	| Y_char uint_lit_opt
	| Y_char8_t
	| Y_char16_t
	| Y_char32_t
	| Y_wchar_t
	| Y_wide char_exp
	| Y_int
	| Y_float
	| Y_floating point_exp
	| Y_double precision_opt
	| Y_EMC__Accum
	| Y_EMC__Fract
	;

BitInt_english_int :
	BitInt_english uint_lit bits_opt
	| BitInt_english '(' /*3L*/ uint_lit_exp rparen_exp
	| BitInt_english Y_width uint_lit_exp bits_opt
	//| BitInt_english error
	;

BitInt_english :
	Y__BitInt
	| Y_bit_precise int_exp
	| Y_bit precise_opt int_exp
	;

precise_opt :
	/*empty*/
	| Y_precise
	;

class_struct_union_english_ast :
	class_struct_union_btid any_sname_c_exp
	;

enum_english_ast :
	enum_btids any_sname_c_exp of_type_enum_fixed_type_english_ast_opt
	;

of_type_enum_fixed_type_english_ast_opt :
	/*empty*/
	| Y_of type_opt enum_fixed_type_english_ast
	;

enum_fixed_type_english_ast :
	enum_fixed_type_modifier_list_english_btid_opt enum_unmodified_fixed_type_english_ast
	| enum_fixed_type_modifier_list_english_btid
	;

enum_fixed_type_modifier_list_english_btid_opt :
	/*empty*/
	| enum_fixed_type_modifier_list_english_btid
	;

enum_fixed_type_modifier_list_english_btid :
	enum_fixed_type_modifier_list_english_btid enum_fixed_type_modifier_btid
	| enum_fixed_type_modifier_btid
	;

enum_unmodified_fixed_type_english_ast :
	builtin_type_english_ast
	| sname_english_ast
	;

any_name :
	Y_NAME
	| Y_TYPEDEF_NAME
	;

any_name_exp :
	any_name
	//| error
	;

any_sname_c :
	sname_c
	| typedef_sname_c
	;

any_sname_c_exp :
	any_sname_c
	//| error
	;

any_sname_c_opt :
	/*empty*/
	| any_sname_c
	;

any_typedef :
	Y_TYPEDEF_NAME
	| Y_TYPEDEF_SNAME
	;

name_ast :
	Y_NAME
	;

name_exp :
	Y_NAME
	//| error
	;

name_cat :
	name_cat Y_NAME
	| Y_NAME
	;

name_opt :
	/*empty*/
	| Y_NAME
	;

oper_sname_c_opt :
	/*empty*/
	| Y_OPERATOR_SNAME Y_COLON_COLON /*2L*/
	;

typedef_type_c_ast :
	any_typedef sub_scope_sname_c_opt
	;

sub_scope_sname_c_opt :
	/*empty*/
	| Y_COLON_COLON /*2L*/ any_sname_c
	;

sname_c :
	sname_c Y_COLON_COLON /*2L*/ Y_NAME
	| sname_c Y_COLON_COLON /*2L*/ any_typedef
	| Y_NAME
	;

sname_c_ast :
	sname_c bit_field_c_uint_opt
	;

bit_field_c_uint_opt :
	/*empty*/
	| ':' uint_lit_exp
	;

sname_c_exp :
	sname_c
	//| error
	;

sname_c_opt :
	/*empty*/
	| sname_c
	;

sname_english :
	any_sname_c of_scope_list_english_opt
	;

sname_english_ast :
	Y_NAME of_scope_list_english_opt
	;

sname_english_exp :
	sname_english
	//| error
	;

sname_english_opt :
	/*empty*/
	| sname_english
	;

sname_list_english :
	sname_list_english ',' /*18L*/ sname_english_exp
	| sname_english
	;

typedef_sname_c :
	typedef_sname_c Y_COLON_COLON /*2L*/ sname_c
	| typedef_sname_c Y_COLON_COLON /*2L*/ any_typedef
	| any_typedef
	;

address_exp :
	Y_address
	//| error
	;

array_exp :
	Y_array
	//| error
	;

as_exp :
	Y_as
	//| error
	;

as_into_to_exp :
	Y_as
	| Y_into
	| Y_to
	//| error
	;

as_or_to_opt :
	/*empty*/
	| Y_as
	| Y_to
	;

bits_opt :
	/*empty*/
	| Y_bit
	| Y_bits
	;

bytes_opt :
	/*empty*/
	| Y_bytes
	;

cast_exp :
	Y_cast
	//| error
	;

char_exp :
	Y_char
	//| error
	;

class_struct_union_btid_exp :
	class_struct_union_btid
	//| error
	;

colon_exp :
	':'
	//| error
	;

comma_exp :
	',' /*18L*/
	//| error
	;

conversion_exp :
	Y_conversion
	//| error
	;

c_operator :
	Y_co_await
	| Y_new
	| Y_new '[' /*3L*/ rbracket_exp
	| Y_delete
	| Y_delete '[' /*3L*/ rbracket_exp
	| '!' /*4R*/
	| Y_EXCLAM_EQUAL /*11L*/
	| '%' /*6L*/
	| Y_PERCENT_EQUAL /*17R*/
	| '&' /*4R*/
	| Y_AMPER_AMPER /*15L*/
	| Y_AMPER_EQUAL /*17R*/
	| '(' /*3L*/ rparen_exp
	| '*' /*4R*/
	| Y_STAR_EQUAL /*17R*/
	| '+' /*7L*/
	| Y_PLUS_PLUS
	| Y_PLUS_EQUAL /*17R*/
	| ',' /*18L*/
	| '-' /*7L*/
	| Y_MINUS_MINUS
	| Y_MINUS_EQUAL /*17R*/
	| Y_MINUS_GREATER /*3L*/
	| Y_MINUS_GREATER_STAR /*5L*/
	| '.' /*3L*/
	| Y_DOT_STAR /*5L*/
	| '/' /*6L*/
	| Y_SLASH_EQUAL /*17R*/
	| Y_COLON_COLON /*2L*/
	| '<' /*10L*/
	| Y_LESS_LESS /*8L*/
	| Y_LESS_LESS_EQUAL /*17R*/
	| Y_LESS_EQUAL /*10L*/
	| Y_LESS_EQUAL_GREATER /*9L*/
	| '=' /*17R*/
	| Y_EQUAL_EQUAL /*11L*/
	| '>' /*10L*/
	| Y_GREATER_GREATER /*8L*/
	| Y_GREATER_GREATER_EQUAL /*17R*/
	| Y_GREATER_EQUAL /*10L*/
	| Y_QMARK_COLON /*17R*/
	| '[' /*3L*/ rbracket_exp
	| '^' /*13L*/
	| Y_CARET_EQUAL /*17R*/
	| '|' /*14L*/
	| Y_PIPE_PIPE /*16L*/
	| Y_PIPE_EQUAL /*17R*/
	| '~' /*4R*/
	;

default_exp :
	Y_default
	//| error
	;

defined_exp :
	Y_defined
	//| error
	;

dependency_exp :
	Y_dependency
	//| error
	;

destructor_sname :
	Y_DESTRUCTOR_SNAME
	| Y_LEXER_ERROR
	;

empty_str_lit_exp :
	str_lit_exp
	;

equals_exp :
	'=' /*17R*/
	//| error
	;

extern_linkage_c_stid :
	Y_extern linkage_stid
	| Y_extern linkage_stid '{'
	;

extern_linkage_c_stid_opt :
	/*empty*/
	| extern_linkage_c_stid
	;

glob :
	Y_GLOB
	;

glob_opt :
	/*empty*/
	| glob
	;

gt_exp :
	'>' /*10L*/
	//| error
	;

inline_stid_opt :
	/*empty*/
	| Y_inline
	;

int_exp :
	Y_int
	//| error
	;

literal_exp :
	Y_literal
	//| error
	;

local_exp :
	Y_local
	//| error
	;

lparen_exp :
	'(' /*3L*/
	//| error
	;

lt_exp :
	'<' /*10L*/
	//| error
	;

member_or_non_member_opt :
	/*empty*/
	| Y_member
	| Y_non_member
	;

namespace_btid_exp :
	Y_namespace
	//| error
	;

namespace_type :
	Y_namespace
	| Y_inline namespace_btid_exp
	;

of_exp :
	Y_of
	//| error
	;

of_scope_english :
	Y_of scope_english_type_exp any_sname_c_exp
	;

of_scope_list_english :
	of_scope_list_english of_scope_english
	| of_scope_english
	;

of_scope_list_english_opt :
	/*empty*/
	| of_scope_list_english
	;

operator_exp :
	Y_operator
	//| error
	;

operator_opt :
	/*empty*/
	| Y_operator
	;

point_exp :
	Y_point
	//| error
	;

precision_opt :
	/*empty*/
	| Y_precision
	;

rbrace_exp :
	'}'
	//| error
	;

rbracket_exp :
	']' /*3L*/
	//| error
	;

reference_exp :
	Y_reference
	//| error
	;

returning :
	Y_returning
	| Y_return
	;

returning_exp :
	returning
	//| error
	;

rparen_exp :
	')' /*3L*/
	//| error
	;

scope_english_type :
	class_struct_union_btid
	| namespace_type
	| Y_scope
	;

scope_english_type_exp :
	scope_english_type
	//| error
	;

semi_exp :
	';'
	//| error
	;

semi_opt :
	/*empty*/
	| ';'
	;

semi_or_end :
	';'
	| Y_END
	;

static_stid_opt :
	/*empty*/
	| Y_static
	;

str_lit :
	Y_STR_LIT
	| Y_LEXER_ERROR
	;

str_lit_exp :
	str_lit
	//| error
	;

this_exp :
	Y_this
	//| error
	;

this_stid_opt :
	/*empty*/
	| Y_this
	;

to_exp :
	Y_to
	//| error
	;

type_opt :
	/*empty*/
	| Y_typedef
	;

typename_flag_opt :
	/*empty*/
	| Y_typename
	;

uint_lit :
	Y_INT_LIT
	;

uint_lit_exp :
	uint_lit
	//| error
	;

uint_lit_opt :
	/*empty*/
	| uint_lit
	;

unused_exp :
	Y_unused
	//| error
	;

user_defined :
	Y_user_defined
	| Y_user defined_exp
	;

virtual_stid_exp :
	Y_virtual
	//| error
	;

virtual_stid_opt :
	/*empty*/
	| Y_virtual
	;

%%

/*
 * For the "expand" command.
 */
//%x X_EXPAND

/*
 * For "include" files.
 */
//%x X_INCL

/*
 * For the C preprocessor.
 */
//%x X_P_COMMAND X_P_TOKENS

/*
 * For the "set" command, we want to allow (almost) any character sequence for
 * the command's options.
 */
//%x X_SET

/*
 * For the "show" command, we want to allow globs (scoped names containing
 * `*`).
 */
//%s S_SHOW

/*
 * For C character and string literals.
 */
//%x X_CHAR X_STR X_RSTR

L             [A-Za-z_]
B             [01]
O             [0-7]
D             [0-9]
H             [0-9A-Fa-f]
NI            [^A-Za-z_0-9]
S             [ \f\r\t\v]
NS            [^ \f\r\t\v]

identifier    {L}({L}|{D})*
sname         {identifier}({S}*::{S}*{identifier})+
dtor_sname    ({identifier}{S}*::{S}*)+(~|compl{S}){S}*{identifier}
oper_sname    ({identifier}{S}*::{S}*)+operator{NI}
hyphenated    [a-z]+-([a-z]+-)*[a-z]+

glob_scope    \*?({identifier}\*?)*
glob          (\*\*|{glob_scope})({S}*::{S}*{glob_scope})*

cstr_pfx      L|u8?|U
rstr_pfx      {cstr_pfx}?R\"[^ \f\n\r\t\v()\\]*"("

flt_sfx       [flFL]
hex_pfx       0[xX]
int_sfx       [lL][lL]?[uU]?|wb|WB|[uU]([lL][lL]?|wb|WB|[zZ])?|[zZ][uU]?
set_option    [^=; \f\n\r\t\v]+

bin_int       -?0[bB]{B}+('{B}+)*{int_sfx}?
oct_int       -?0{O}*('{O}+)*{int_sfx}?
dec_int       -?[1-9]{D}*('{D}+)*{int_sfx}?
hex_int       -?{hex_pfx}{H}+('{H}+)*{int_sfx}?

int_lit	{bin_int}|{oct_int}|{dec_int}|{hex_int}

exp           [eE][+-]?{D}+
bexp          [pP][+-]?{D}+
dec_frac      ({D}*"."{D}+)|({D}+".")
hex_frac      ({H}*"."{H}+)|({H}+".")
dec_flt       ({dec_frac}{exp}?)|({D}+{exp})
hex_flt       {hex_pfx}({hex_frac}|{H}+){bexp}

flt_lit       -?({dec_flt}|{hex_flt}){flt_sfx}?

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"`"	'`'
"^"	'^'
"~"	'~'
"<"	'<'
"="	'='
">"	'>'
"|"	'|'
"-"	'-'
","	','
";"	';'
":"	':'
"!"	'!'
"?"	'?'
"/"	'/'
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"@"	'@'
"$"	'$'
"*"	'*'
"&"	'&'
"#"	'#'
"%"	'%'
"+"	'+'
"..."	"..."

"##"	PY_CONCAT
"#define"	PY_define
"#elif"	PY_elif
"#elifdef"	PY_elifdef
"#elifndef"	PY_elifndef
"#else"	PY_else
"#embed"	PY_embed
"#error"	PY_error
"#if"	PY_if
"#ifdef"	PY_ifdef
"#ifndef"	PY_ifndef
"#line"	PY_line
"#pragma"	PY_pragma
PY_SPACE	PY_SPACE
"#undef"	PY_undef
PY___VA_ARGS__	PY___VA_ARGS__
PY___VA_OPT__	PY___VA_OPT__
"#warning"	PY_warning
address	Y_address
alignas	Y_alignas
_Alignas	Y__Alignas
aligned	Y_aligned
all	Y_all
"&&"	Y_AMPER_AMPER
"&="	Y_AMPER_EQUAL
Apple_block	Y_Apple_block
Apple___block	Y_Apple___block
array	Y_array
as	Y_as
asm	Y_asm
_Atomic_QUAL	Y__Atomic_QUAL
_Atomic_SPEC	Y__Atomic_SPEC
ATTR_BEGIN	Y_ATTR_BEGIN
auto_STORAGE	Y_auto_STORAGE
auto_TYPE	Y_auto_TYPE
bit	Y_bit
_BitInt	Y__BitInt
bit_precise	Y_bit_precise
bits	Y_bits
bool	Y_bool
_Bool	Y__Bool
by	Y_by
bytes	Y_bytes
capturing	Y_capturing
"^="	Y_CARET_EQUAL
carries	Y_carries
carries_dependency	Y_carries_dependency
cast	Y_cast
char	Y_char
char16_t	Y_char16_t
char32_t	Y_char32_t
char8_t	Y_char8_t
class	Y_class
co_await	Y_co_await
"::"	Y_COLON_COLON
"::*"	Y_COLON_COLON_STAR
_Complex	Y__Complex
const	Y_const
const_cast	Y_const_cast
const_ENG	Y_const_ENG
consteval	Y_consteval
constexpr	Y_constexpr
constinit	Y_constinit
constructor	Y_constructor
CONSTRUCTOR_SNAME	Y_CONSTRUCTOR_SNAME
conversion	Y_conversion
copy	Y_copy
declare	Y_declare
default	Y_default
define	Y_define
defined	Y_defined
delete	Y_delete
dependency	Y_dependency
deprecated	Y_deprecated
destructor	Y_destructor
Y_DESTRUCTOR_SNAME	Y_DESTRUCTOR_SNAME
discard	Y_discard
//"..."	Y_DOT_DOT_DOT
".*"	Y_DOT_STAR
double	Y_double
dynamic	Y_dynamic
dynamic_cast	Y_dynamic_cast
EMC__Accum	Y_EMC__Accum
EMC__Fract	Y_EMC__Fract
EMC__Sat	Y_EMC__Sat
END	Y_END
english	Y_english
enum	Y_enum
"=="	Y_EQUAL_EQUAL
evaluation	Y_evaluation
except	Y_except
"!="	Y_EXCLAM_EQUAL
expand	Y_expand
explain	Y_explain
explicit	Y_explicit
export	Y_export
expression	Y_expression
extern	Y_extern
false	Y_false
final	Y_final
float	Y_float
floating	Y_floating
friend	Y_friend
function	Y_function
GLOB	Y_GLOB
GNU___attribute__	Y_GNU___attribute__
GNU___restrict	Y_GNU___restrict
">="	Y_GREATER_EQUAL
">>"	Y_GREATER_GREATER
">>="	Y_GREATER_GREATER_EQUAL
_Imaginary	Y__Imaginary
initialization	Y_initialization
inline	Y_inline
int	Y_int
into	Y_into
lambda	Y_lambda
length	Y_length
"<="	Y_LESS_EQUAL
"<=>"	Y_LESS_EQUAL_GREATER
"<<"	Y_LESS_LESS
"<<="	Y_LESS_LESS_EQUAL
LEXER_ERROR	Y_LEXER_ERROR
linkage	Y_linkage
literal	Y_literal
local	Y_local
long	Y_long
macros	Y_macros
maybe	Y_maybe
maybe_unused	Y_maybe_unused
member	Y_member
"-="	Y_MINUS_EQUAL
"->"	Y_MINUS_GREATER
"->*"	Y_MINUS_GREATER_STAR
"--"	Y_MINUS_MINUS
MSC___cdecl	Y_MSC___cdecl
MSC___clrcall	Y_MSC___clrcall
MSC___declspec	Y_MSC___declspec
MSC___fastcall	Y_MSC___fastcall
MSC___stdcall	Y_MSC___stdcall
MSC___thiscall	Y_MSC___thiscall
MSC___vectorcall	Y_MSC___vectorcall
mutable	Y_mutable
namespace	Y_namespace
new	Y_new
no	Y_no
nodiscard	Y_nodiscard
noexcept	Y_noexcept
non_empty	Y_non_empty
non_member	Y_non_member
noreturn	Y_noreturn
_Noreturn	Y__Noreturn
no_unique_address	Y_no_unique_address
of	Y_of
operator	Y_operator
Y_OPERATOR_SNAME	Y_OPERATOR_SNAME
override	Y_override
"%="	Y_PERCENT_EQUAL
"|="	Y_PIPE_EQUAL
"||"	Y_PIPE_PIPE
"+="	Y_PLUS_EQUAL
"++"	Y_PLUS_PLUS
point	Y_point
pointer	Y_pointer
precise	Y_precise
precision	Y_precision
Y_PREC_LESS_THAN_upc_layout_qualifier	Y_PREC_LESS_THAN_upc_layout_qualifier
predefined	Y_predefined
pure	Y_pure
"?:"	Y_QMARK_COLON
quit	Y_quit
reference	Y_reference
register	Y_register
reinterpret	Y_reinterpret
reinterpret_cast	Y_reinterpret_cast
reproducible	Y_reproducible
restrict	Y_restrict
return	Y_return
returning	Y_returning
rvalue	Y_rvalue
scope	Y_scope
set	Y_set
Y_SET_OPTION	Y_SET_OPTION
short	Y_short
show	Y_show
signed	Y_signed
"/="	Y_SLASH_EQUAL
"*="	Y_STAR_EQUAL
static	Y_static
static_cast	Y_static_cast
Y_struct	Y_struct
template	Y_template
this	Y_this
thread	Y_thread
thread_local	Y_thread_local
_Thread_local	Y__Thread_local
throw	Y_throw
to	Y_to
true	Y_true
typedef	Y_typedef
Y_TYPEDEF_NAME	Y_TYPEDEF_NAME
Y_TYPEDEF_SNAME	Y_TYPEDEF_SNAME
typename	Y_typename
typeof	Y_typeof
typeof_unqual	Y_typeof_unqual
union	Y_union
unique	Y_unique
unsequenced	Y_unsequenced
unsigned	Y_unsigned
unused	Y_unused
UPC_relaxed	Y_UPC_relaxed
UPC_shared	Y_UPC_shared
UPC_strict	Y_UPC_strict
user	Y_user
user_defined	Y_user_defined
using	Y_using
variable	Y_variable
virtual	Y_virtual
void	Y_void
volatile	Y_volatile
wchar_t	Y_wchar_t
wide	Y_wide
width	Y_width

\"(\\.|[^"\r\n\\])*\"	Y_STR_LIT
'(\\.|[^'\r\n\\])'	Y_CHAR_LIT
{int_lit}	Y_INT_LIT
{flt_lit}	Y_FLOAT_LIT
{identifier}	Y_NAME

%%
