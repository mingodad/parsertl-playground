//From: https://github.com/semgrep/semgrep/blob/6f51b94d6bc2249f9ce2b6bb0eef72bf73ed6e9c/languages/javascript/menhir/parser_js.mly
/* Yoann Padioleau
 *
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
/* This file contains a grammar for Javascript (ES6 and more), as well
 * as partial support for Typescript.
 *
 * reference:
 *  - https://en.wikipedia.org/wiki/JavaScript_syntax
 *  - http://www.ecma-international.org/publications/standards/Ecma-262.htm
 *  - https://github.com/Microsoft/TypeScript/blob/master/doc/spec.md#A
 *
 * src: originally ocamlyacc-ified from Marcel Laverdet 'fbjs2' via Emacs
 * macros, itself extracted from the official ECMAscript specification at:
 * http://www.ecma-international.org/publications/standards/ecma-262.htm
 * back in the day (probably ES4 or ES3).
 *
 * I have heavily extended the grammar to provide the first parser for Flow.
 * I have extended it also to deal with many new Javascript features
 * (see cst_js.ml top comment).
 *
 * The grammar is close to the ECMA grammar but I've simplified a few things
 * when I could:
 *  - less intermediate grammar rules for advanced features
 *    (they are inlined in the original grammar rule)
 *  - by using my retagging-tokens technique (see parsing_hacks_js.ml)
 *    I could also get rid of some of the ugliness in the ECMA grammar
 *    that has to deal with ambiguous constructs
 *    (they conflate together expressions and arrow parameters, object
 *    values and object matching, etc.).
 *    Instead, in this grammar things are clearly separated.
 *  - I've used some macros to factorize rules, including some tricky
 *    macros to factorize expression rules.
 */

/*************************************************************************/
/* Tokens */
/*************************************************************************/

%token TUnknown  /* unrecognized token */
//%token EOF

/*-----------------------------------------*/
/* The space/comment tokens */
/*-----------------------------------------*/
/* coupling: Token_helpers.is_comment */
//%token TCommentSpace TCommentNewline
%token TComment

/*-----------------------------------------*/
/* The normal tokens */
/*-----------------------------------------*/

/* tokens with a value */
%token T_INT
%token T_FLOAT
%token T_ID

%token T_STRING
%token T_ENCAPSED_STRING
%token T_REGEX

/*-----------------------------------------*/
/* Keyword tokens */
/*-----------------------------------------*/
/* coupling: if you add an element here, expand also ident_keyword_bis
 * and also maybe the special hack for regexp in lexer_js.mll */

%token T_FUNCTION T_CONST T_VAR T_LET
%token T_IF T_ELSE
%token T_WHILE T_FOR T_DO T_CONTINUE T_BREAK
%token T_SWITCH T_CASE T_DEFAULT
%token T_RETURN
%token T_THROW T_TRY T_CATCH T_FINALLY
%token T_YIELD T_ASYNC T_AWAIT
%token T_NEW T_IN T_OF T_THIS T_SUPER T_WITH
%token T_NULL T_FALSE T_TRUE
%token T_CLASS T_INTERFACE T_EXTENDS T_IMPLEMENTS T_STATIC T_GET T_SET T_CONSTRUCTOR
%token T_IMPORT T_EXPORT T_FROM T_AS
%token T_INSTANCEOF T_TYPEOF
%token T_DELETE  T_VOID
%token T_TYPE  T_ANY_TYPE T_NUMBER_TYPE T_BOOLEAN_TYPE T_STRING_TYPE  T_ENUM
%token T_DECLARE T_MODULE
%token T_PUBLIC T_PRIVATE T_PROTECTED  T_READONLY

/*-----------------------------------------*/
/* Punctuation tokens */
/*-----------------------------------------*/

/* syntax */
%token T_LCURLY T_RCURLY
%token T_LPAREN T_RPAREN
%token T_LBRACKET T_RBRACKET
%token T_SEMICOLON T_COMMA T_PERIOD T_COLON
%token T_QUESTDOT
%token T_PLING
%token T_ARROW
/* regular JS token and also semgrep: */
%token T_DOTS
%token T_BACKQUOTE
%token T_DOLLARCURLY
/* decorators: https://tc39.es/proposal-decorators/ */
%token T_AT
/* semgrep: */
%token LDots RDots


/* operators */
%token T_OR T_AND
%token T_BIT_OR T_BIT_XOR T_BIT_AND
%token T_PLUS T_MINUS
%token T_DIV T_MULT T_MOD
%token T_NOT T_BIT_NOT
%token T_RSHIFT3_ASSIGN T_RSHIFT_ASSIGN T_LSHIFT_ASSIGN
%token T_BIT_XOR_ASSIGN T_BIT_OR_ASSIGN T_BIT_AND_ASSIGN T_MOD_ASSIGN T_DIV_ASSIGN
%token T_MULT_ASSIGN T_MINUS_ASSIGN T_PLUS_ASSIGN
%token T_ASSIGN
%token T_EQUAL T_NOT_EQUAL T_STRICT_EQUAL T_STRICT_NOT_EQUAL
%token T_LESS_THAN_EQUAL T_GREATER_THAN_EQUAL T_LESS_THAN T_GREATER_THAN
%token T_LSHIFT T_RSHIFT T_RSHIFT3
%token T_INCR T_DECR
%token T_EXPONENT

/*-----------------------------------------*/
/* XHP tokens */
/*-----------------------------------------*/
%token  T_XHP_OPEN_TAG
/* The 'option' is for closing tags like </> */
%token T_XHP_CLOSE_TAG

/* ending part of the opening tag */
%token T_XHP_GT T_XHP_SLASH_GT

%token  T_XHP_ATTR T_XHP_TEXT
/* '<>', see https://reactjs.org/docs/fragments.html#short-syntax */
%token T_XHP_SHORT_FRAGMENT

/*-----------------------------------------*/
/* Extra tokens: */
/*-----------------------------------------*/

/* Automatically Inserted Semicolon (ASI), see parse_js.ml */
%token T_VIRTUAL_SEMICOLON
/* fresh_token: the opening '(' of the parameters preceding an '->' */
%token T_LPAREN_ARROW

/* fresh_token: the opening '(' of the parameters of a method in semgrep */
//%token T_LPAREN_METHOD_SEMGREP
/* fresh_token: the first '{' in a semgrep pattern for objects */
//%token T_LCURLY_SEMGREP

/*************************************************************************/
/* Priorities */
/*************************************************************************/

/* must be at the top so that it has the lowest priority */
/* %nonassoc LOW_PRIORITY_RULE */

/* Special if / else associativity*/
%nonassoc p_IF
%nonassoc T_ELSE

%nonassoc below_COLON
%nonassoc T_COLON

/* unused according to menhir:
%nonassoc p_POSTFIX
%right
 T_RSHIFT3_ASSIGN T_RSHIFT_ASSIGN T_LSHIFT_ASSIGN
 T_BIT_XOR_ASSIGN T_BIT_OR_ASSIGN T_BIT_AND_ASSIGN T_MOD_ASSIGN T_DIV_ASSIGN
 T_MULT_ASSIGN T_MINUS_ASSIGN T_PLUS_ASSIGN
*/

%left T_OR
%left T_AND
%left T_BIT_OR
%left T_BIT_XOR
%left T_BIT_AND
%left T_EQUAL T_NOT_EQUAL T_STRICT_EQUAL T_STRICT_NOT_EQUAL
%left T_LESS_THAN_EQUAL T_GREATER_THAN_EQUAL T_LESS_THAN T_GREATER_THAN T_IN T_INSTANCEOF
%left T_LSHIFT T_RSHIFT T_RSHIFT3
%left T_PLUS T_MINUS
%left T_DIV T_MULT T_MOD

%right T_EXPONENT
%right T_NOT T_BIT_NOT T_INCR T_DECR T_DELETE T_TYPEOF T_VOID T_AWAIT

/*************************************************************************/
/* Rules type decl */
/*************************************************************************/
%start main
/*
%start <Ast_js.stmt option> module_item_or_eof
%start <Ast_js.any> sgrep_spatch_pattern
*/
/* for lang_json/ */
/*
%start <Ast_js.expr> json
%start <Ast_js.any> json_pattern
%start <Ast_js.type_> type_for_lsif
*/

%%

//option_T_ASYNC_ :
//	/*empty*/
//	| T_ASYNC
//	;

option_T_COMMA_ :
	/*empty*/
	| T_COMMA
	;

option_T_CONST_ :
	/*empty*/
	| T_CONST
	;

//option_T_STATIC_ :
//	/*empty*/
//	| T_STATIC
//	;

option_annotation_ :
	/*empty*/
	| annotation
	;

option_arguments_ :
	/*empty*/
	| arguments
	;

option_binding_id_ :
	/*empty*/
	| binding_id
	;

option_expr_ :
	/*empty*/
	| expr
	;

option_expr_no_in_ :
	/*empty*/
	| expr_no_in
	;

option_extends_clause_ :
	/*empty*/
	| extends_clause
	;

option_generics_ :
	/*empty*/
	| generics
	;

option_id_ :
	/*empty*/
	| id
	;

option_initializeur_ :
	/*empty*/
	| initializeur
	;

option_sc_ :
	/*empty*/
	| sc
	;

list_case_clause_ :
	/*empty*/
	| list_case_clause_ case_clause
	;

list_class_element_ :
	/*empty*/
	| list_class_element_ class_element
	;

list_encaps_ :
	/*empty*/
	| list_encaps_ encaps
	;

list_module_item_ :
	/*empty*/
	| list_module_item_ module_item
	;

list_type_member_ :
	/*empty*/
	| list_type_member_ type_member
	;

list_xhp_attribute_ :
	/*empty*/
	| list_xhp_attribute_ xhp_attribute
	;

list_xhp_child_ :
	/*empty*/
	| list_xhp_child_ xhp_child
	;

nonempty_list_decorator_ :
	decorator
	| nonempty_list_decorator_ decorator
	;

nonempty_list_item_ :
	item
	| nonempty_list_item_ item
	;

//nonempty_list_module_item_ :
//	module_item
//	| nonempty_list_module_item_ module_item
//	;

listc_argument_ :
	argument
	| listc_argument_ T_COMMA argument
	;

listc_binding_property_ :
	binding_property
	| listc_binding_property_ T_COMMA binding_property
	;

listc_enum_member_ :
	enum_member
	| listc_enum_member_ T_COMMA enum_member
	;

listc_import_specifier_ :
	import_specifier
	| listc_import_specifier_ T_COMMA import_specifier
	;

listc_property_name_and_value_ :
	property_name_and_value
	| listc_property_name_and_value_ T_COMMA property_name_and_value
	;

listc_type__ :
	type_
	| listc_type__ T_COMMA type_
	;

listc_type_argument_ :
	type_argument
	| listc_type_argument_ T_COMMA type_argument
	;

listc_type_parameter_ :
	type_parameter
	| listc_type_parameter_ T_COMMA type_parameter
	;

listc_type_reference_ :
	type_reference_aux
	| listc_type_reference_ T_COMMA type_reference_aux
	;

listc_variable_decl_ :
	variable_decl
	| listc_variable_decl_ T_COMMA variable_decl
	;

listc_variable_decl_no_in_ :
	variable_decl_no_in
	| listc_variable_decl_no_in_ T_COMMA variable_decl_no_in
	;

optl_elision_ :
	/*empty*/
	| elision
	;

optl_implements_clause_ :
	/*empty*/
	| implements_clause
	;

optl_interface_extends_ :
	/*empty*/
	| interface_extends
	;

optl_param_type_list_ :
	/*empty*/
	| param_type_list
	;

optl_stmt_list_ :
	/*empty*/
	| stmt_list
	;

/*************************************************************************/
/* Toplevel */
/*************************************************************************/
main :
	program //EOF
	;

program :
	list_module_item_
	;

///* parse item by item, to allow error recovery and skipping some code */
//module_item_or_eof :
//	module_item
//	| EOF
//	;

module_item :
	item
	| import_decl
	| export_decl
	;

/* item is also in stmt_list, inside every blocks */
item :
	stmt
	| decl
	;

decl :
	/* part of hoistable_declaration in the ECMA grammar */
	function_decl
	/* es6: */
	| generator_decl
	/* es7: */
	| async_decl
	/* es6: */
	| lexical_decl
	| class_decl
	/* typescript-ext: */
	| interface_decl
	| type_alias_decl
	| enum_decl
	;

///* less: could restrict to literals and collections */
//json :
//	expr EOF
//	;
//
//json_pattern :
//	expr EOF
//	| T_ID T_COLON assignment_expr option_T_COMMA_ EOF
//	| string_literal T_COLON assignment_expr option_T_COMMA_ EOF
//	;
//
///*************************************************************************/
///* sgrep */
///*************************************************************************/
//sgrep_spatch_pattern :
//	/* copy-paste of object_literal rule but with T_LCURLY_SEMGREP */
//	T_LCURLY_SEMGREP T_RCURLY
//	| T_LCURLY_SEMGREP listc_property_name_and_value_ option_T_COMMA_ T_RCURLY
//	/* decorators, no body */
//	| nonempty_list_decorator_ option_T_STATIC_ option_T_ASYNC_ T_ID T_LPAREN formal_parameter_list_opt T_RPAREN option_annotation_ EOF
//	| nonempty_list_decorator_ option_T_STATIC_ option_T_ASYNC_ T_ID option_annotation_ EOF
//	/* decorators, with body */
//	| nonempty_list_decorator_ option_T_STATIC_ option_T_ASYNC_ T_ID T_LPAREN formal_parameter_list_opt T_RPAREN option_annotation_ T_LCURLY function_body T_RCURLY EOF
//	/* TODO decorators ioption(T_ASYNC) ioption(method_get_set_star)
//	* but need also to modify parsing hack for T_LPAREN_METHOD_SEMGREP
//	*/
//	| T_ID T_LPAREN_METHOD_SEMGREP formal_parameter_list_opt T_RPAREN option_annotation_ T_LCURLY function_body T_RCURLY EOF
//	| assignment_expr_no_stmt EOF
//	| module_item EOF
//	| module_item nonempty_list_module_item_ EOF
//	| T_FUNCTION T_DOTS call_signature T_LCURLY function_body T_RCURLY
//	/* partial defs */
//	| T_FUNCTION option_id_ call_signature EOF
//	| T_CLASS option_binding_id_ option_generics_ class_heritage EOF
//	/* partial stmts */
//	| T_IF T_LPAREN expr T_RPAREN EOF
//	| T_TRY block EOF
//	| catch EOF
//	| finally EOF
//	/* partial objects, like in json_pattern */
//	/* foo : ... can also be interpeted as a label statement in JS
//	* (we don't have this ambiguity for json_pattern)
//	* which leads to a s/r conflict. property_name2 is actually %inline,
//	* so the shift, which we want, is here, and we want the reduce in
//	* id: of label to be lower priority, hence the %prec below_COLON in
//	* the id rule.
//	* Note that this rule below is a slice of property_name_and_value.
//	*/
//	| T_ID T_COLON assignment_expr option_T_COMMA_ EOF
//	| string_literal T_COLON assignment_expr option_T_COMMA_ EOF
//	;


/*************************************************************************/
/* Namespace */
/*************************************************************************/
/*----------------------------*/
/* import */
/*----------------------------*/

import_decl :
	T_IMPORT import_clause from_clause sc
	| T_IMPORT module_specifier sc
	;

import_clause :
	import_default
	| import_default T_COMMA import_names
	| import_names
	;

import_default :
	binding_id
	;

import_names :
	T_MULT T_AS binding_id
	| named_imports
	/* typing-ext: */
	| T_TYPE named_imports
	;

named_imports :
	T_LCURLY T_RCURLY
	| T_LCURLY listc_import_specifier_ T_RCURLY
	| T_LCURLY listc_import_specifier_ T_COMMA T_RCURLY
	;

/* also valid for export */
from_clause :
	T_FROM module_specifier
	;

import_specifier :
	binding_id
	| id T_AS binding_id
	| T_DEFAULT T_AS binding_id
	/* not in ECMA, not sure what it means */
	| T_DEFAULT
	/* sgrep-ext: this is to allow people to write patterns like
	* import {..., Foo, ...} from 'Bar', but internally we just skip
	* those ... and will return an Import {Foo} from 'Bar'
	*/
	| T_DOTS
	;

module_specifier :
	string_literal
	/* sgrep-ext: allow metavar after 'from', transform it as a string "$X" */
	| T_ID
	;

/*----------------------------*/
/* export */
/*----------------------------*/

/* TODO */
export_decl :
	T_EXPORT export_names
	| T_EXPORT variable_stmt
	| T_EXPORT decl
	/* in theory just func/gen/class, no lexical_decl */
	| T_EXPORT T_DEFAULT decl
	| T_EXPORT T_DEFAULT assignment_expr_no_stmt sc
	/* ugly hack because should use assignment_expr above instead*/
	| T_EXPORT T_DEFAULT object_literal sc
	;

export_names :
	T_MULT from_clause sc
	| export_clause from_clause sc
	| export_clause sc
	;

export_clause :
	T_LCURLY T_RCURLY
	| T_LCURLY listc_import_specifier_ T_RCURLY
	| T_LCURLY listc_import_specifier_ T_COMMA T_RCURLY
	;

/*************************************************************************/
/* Variable decl */
/*************************************************************************/

/* part of 'stmt' */
variable_stmt :
	T_VAR listc_variable_decl_ sc
	;

/* part of 'decl' */
lexical_decl :
	T_CONST listc_variable_decl_ sc
	| T_LET listc_variable_decl_ sc
	;

/* one var from a list of vars */
variable_decl :
	id option_annotation_ option_initializeur_
	| binding_pattern option_annotation_ initializeur
	;

initializeur :
	T_ASSIGN assignment_expr
	;

for_variable_decl :
	T_VAR listc_variable_decl_no_in_
	/* es6: */
	| T_CONST listc_variable_decl_no_in_
	| T_LET listc_variable_decl_no_in_
	;

variable_decl_no_in :
	id initializer_no_in
	| id
	| binding_pattern initializer_no_in
	;

/* 'for ... in' and 'for ... of' declare only one variable */
for_single_variable_decl :
	T_VAR for_binding
	/* es6: */
	| T_CONST for_binding
	| T_LET for_binding
	;

for_binding :
	id option_annotation_
	| binding_pattern
	;

/*----------------------------*/
/* pattern */
/*----------------------------*/

binding_pattern :
	object_binding_pattern
	| array_binding_pattern
	;

object_binding_pattern :
	T_LCURLY T_RCURLY
	| T_LCURLY listc_binding_property_ option_T_COMMA_ T_RCURLY
	;

binding_property :
	binding_id option_initializeur_
	| property_name T_COLON binding_element
	/* can appear only at the end of a binding_property_list in ECMA */
	| T_DOTS binding_id
	| T_DOTS binding_pattern
	/* sgrep-ext: */
	| T_DOTS
	;

/* in theory used also for formal parameter as is */
binding_element :
	binding_id option_initializeur_
	| binding_pattern option_initializeur_
	;

/* array destructuring */

/* TODO use elision below.
 * invent a new Hole category or maybe an array_argument special
 * type like for the (call)argument type.
 */
array_binding_pattern :
	T_LBRACKET T_RBRACKET
	| T_LBRACKET binding_element_list T_RBRACKET
	;

binding_start_element :
	T_COMMA
	| binding_element T_COMMA
	;

binding_start_list :
	/* always ends in a "," */
	binding_start_element
	| binding_start_list binding_start_element
	;

/* can't use listc() here, it's $1 not [$1] below */
binding_element_list :
	binding_start_list
	| binding_elision_element
	| binding_start_list binding_elision_element
	;

binding_elision_element :
	binding_element
	/* can appear only at the end of a binding_property_list in ECMA */
	| T_DOTS binding_id
	| T_DOTS binding_pattern
	;

/*************************************************************************/
/* Function declarations (and exprs) */
/*************************************************************************/

/* ugly: id is None only when part of an 'export default' decl
 * less: use other tech to enforce this? extra rule after
 *  T_EXPORT T_DEFAULT? but then many ambiguities.
 */
function_decl :
	T_FUNCTION option_id_ call_signature T_LCURLY function_body T_RCURLY
	;

/* the id is really optional here */
function_expr :
	T_FUNCTION option_id_ call_signature T_LCURLY function_body T_RCURLY
	;

/* typescript-ext: generics? and annotation? */
call_signature :
	option_generics_ T_LPAREN formal_parameter_list_opt T_RPAREN option_annotation_
	;

function_body :
	optl_stmt_list_
	;

/*----------------------------*/
/* parameters */
/*----------------------------*/

formal_parameter_list_opt :
	/*empty*/
	| formal_parameter_list option_T_COMMA_
	;

/* must be written in a left-recursive way (see conflicts.txt) */
formal_parameter_list :
	formal_parameter_list T_COMMA formal_parameter
	| formal_parameter
	;

/* The ECMA and Typescript grammars imposes more restrictions
 * (some require_parameter, optional_parameter, rest_parameter)
 * but I've simplified.
 * We could also factorize with binding_element as done by ECMA.
 */
formal_parameter :
	id
	/* es6: default parameter */
	| id initializeur
	/* until here this is mostly equivalent to the 'binding_element' rule */
	| binding_pattern option_annotation_ option_initializeur_
	/* es6: spread */
	| T_DOTS id
	/* typing-ext: */
	| id annotation
	/* TODO: token for '?' */
	| id T_PLING
	| id T_PLING annotation
	| id annotation initializeur
	| T_DOTS id annotation
	/* sgrep-ext: */
	| T_DOTS
	;

/*----------------------------*/
/* generators */
/*----------------------------*/

generator_decl :
	T_FUNCTION T_MULT id call_signature T_LCURLY function_body T_RCURLY
	;

/* the id really is optional here */
generator_expr :
	T_FUNCTION T_MULT option_id_ call_signature T_LCURLY function_body T_RCURLY
	;

/*----------------------------*/
/* asynchronous functions */
/*----------------------------*/

async_decl :
	T_ASYNC T_FUNCTION id call_signature T_LCURLY function_body T_RCURLY
	;

/* the id is really optional here */
async_function_expr :
	T_ASYNC T_FUNCTION option_id_ call_signature T_LCURLY function_body T_RCURLY
	;

/*************************************************************************/
/* Class declaration */
/*************************************************************************/

/* ugly: c_name is None only when part of an 'export default' decl
 * less: use other tech to enforce this? extra rule after
 *  T_EXPORT T_DEFAULT? but then many ambiguities.
 * TODO: actually in tree-sitter-js, it's a binding_id without '?'
 */
class_decl :
	T_CLASS option_binding_id_ option_generics_ class_heritage class_body
	| nonempty_list_decorator_ T_CLASS option_binding_id_ option_generics_ class_heritage class_body
	;

class_body :
	T_LCURLY list_class_element_ T_RCURLY
	;

class_heritage :
	option_extends_clause_ optl_implements_clause_
	;

extends_clause :
	T_EXTENDS type_or_expr
	;

/* typescript-ext: */
implements_clause :
	T_IMPLEMENTS listc_type__
	;

binding_id :
	id
	;

class_expr :
	T_CLASS option_binding_id_ option_generics_ class_heritage class_body
	;

/*----------------------------*/
/* Class elements */
/*----------------------------*/

/* can't factorize with static_opt, or access_modifier_opt; ambiguities  */
class_element :
	method_definition
	| access_modifiers method_definition
	| property_name option_annotation_ option_initializeur_ sc
	| access_modifiers property_name option_annotation_ option_initializeur_ sc
	| sc
	/* sgrep-ext: enable class body matching */
	| T_DOTS
	;

/* TODO: cant use access_modifier+, conflict */
access_modifiers :
	access_modifier
	| access_modifiers access_modifier
	;

/* less: should impose an order? */
access_modifier :
	T_STATIC
	/* typescript-ext: */
	| T_PUBLIC
	| T_PRIVATE
	| T_PROTECTED
	| T_READONLY
	;

/*----------------------------*/
/* Method definition (in class or object literal) */
/*----------------------------*/
method_definition :
	property_name call_signature T_LCURLY function_body T_RCURLY
	| method_get_set_star property_name call_signature T_LCURLY function_body T_RCURLY
	/* es7: */
	| T_ASYNC property_name call_signature T_LCURLY function_body T_RCURLY
	| T_ASYNC method_get_set_star property_name call_signature T_LCURLY function_body T_RCURLY
	| nonempty_list_decorator_ property_name call_signature T_LCURLY function_body T_RCURLY
	| nonempty_list_decorator_ method_get_set_star property_name call_signature T_LCURLY function_body T_RCURLY
	| nonempty_list_decorator_ T_ASYNC property_name call_signature T_LCURLY function_body T_RCURLY
	| nonempty_list_decorator_ T_ASYNC method_get_set_star property_name call_signature T_LCURLY function_body T_RCURLY
	;

/* we used to enforce that T_GET had a call_signature with 0 param and
 * T_SET with 1 param, but not worth it (tree-sitter-js does not enforce it)
 */
method_get_set_star :
	T_MULT
	| T_GET
	| T_SET
	;

/*************************************************************************/
/* Interface declaration */
/*************************************************************************/
/* typescript-ext: */
/* TODO: use type_ at the end here and you get conflicts on '['
 * Why? because [] can follow an interface_decl?
 */
interface_decl :
	T_INTERFACE binding_id option_generics_ optl_interface_extends_ object_type
	;

interface_extends :
	T_EXTENDS listc_type_reference_
	;

/*************************************************************************/
/* Type declaration */
/*************************************************************************/
/* typescript-ext: */
type_alias_decl :
	T_TYPE id T_ASSIGN type_ sc
	;

enum_decl :
	option_T_CONST_ T_ENUM id T_LCURLY listc_enum_member_ option_T_COMMA_ T_RCURLY
	;

enum_member :
	property_name
	| property_name T_ASSIGN assignment_expr_no_stmt
	;

/*************************************************************************/
/* Declare (ambient) declaration */
/*************************************************************************/
/* typescript-ext: */

/*************************************************************************/
/* Decorators */
/*************************************************************************/
decorator_name :
	T_ID
	| decorator_name T_PERIOD T_ID
	;

decorator :
	T_AT decorator_name option_arguments_
	;

/*************************************************************************/
/* Types */
/*************************************************************************/
/* typescript-ext: */

/*----------------------------*/
/* Annotations */
/*----------------------------*/

annotation :
	T_COLON type_
	;

complex_annotation :
	annotation
	| option_generics_ T_LPAREN optl_param_type_list_ T_RPAREN T_COLON type_
	;

/*----------------------------*/
/* Types */
/*----------------------------*/

//type_for_lsif :
//	type_ EOF
//	;

/* can't use 'type'; generate syntax error in parser_js.ml */
type_ :
	primary_or_union_type
	| T_PLING type_
	| T_LPAREN_ARROW optl_param_type_list_ T_RPAREN T_ARROW type_
	;

primary_or_union_type :
	primary_or_intersect_type
	| union_type
	;

primary_or_intersect_type :
	primary_type
	| intersect_type
	;

/* I introduced those intermediate rules to remove ambiguities */
primary_type :
	primary_type2
	| primary_type T_LBRACKET T_RBRACKET
	;

primary_type2 :
	predefined_type
	| type_reference_aux
	| object_type
	| T_LBRACKET listc_type__ T_RBRACKET
	/* not in Typescript grammar */
	| T_STRING
	;

predefined_type :
	T_ANY_TYPE
	| T_NUMBER_TYPE
	| T_BOOLEAN_TYPE
	| T_STRING_TYPE
	| T_VOID
	/* not in Typescript grammar, but often part of union type */
	| T_NULL
	;

/* was called nominal_type in Flow */
type_reference_aux :
	type_name
	| type_name type_arguments
	;

/* was called type_reference in Flow */
type_name :
	T_ID
	| module_name T_PERIOD T_ID
	;

module_name :
	T_ID
	| module_name T_PERIOD T_ID
	;

union_type :
	primary_or_union_type T_BIT_OR primary_type
	;

intersect_type :
	primary_or_intersect_type T_BIT_AND primary_type
	;

object_type :
	T_LCURLY list_type_member_ T_RCURLY
	;

/* partial type annotations are not supported */
type_member :
	property_name_typescript complex_annotation sc_or_comma
	| property_name_typescript T_PLING complex_annotation sc_or_comma
	| T_LBRACKET T_ID T_COLON T_STRING_TYPE T_RBRACKET complex_annotation sc_or_comma
	| T_LBRACKET T_ID T_COLON T_NUMBER_TYPE T_RBRACKET complex_annotation sc_or_comma
	;

/* no [xxx] here */
property_name_typescript :
	id
	| string_literal
	| numeric_literal_as_string
	| ident_keyword
	;

param_type_list :
	param_type T_COMMA param_type_list
	| param_type
	| optional_param_type_list
	;

/* partial type annotations are not supported */
param_type :
	id complex_annotation
	;

optional_param_type :
	id T_PLING complex_annotation
	;

optional_param_type_list :
	optional_param_type T_COMMA optional_param_type_list
	| optional_param_type
	| rest_param_type
	;

rest_param_type :
	T_DOTS id complex_annotation
	;

/*----------------------------*/
/* Type parameters (type variables) */
/*----------------------------*/

generics :
	T_LESS_THAN listc_type_parameter_ T_GREATER_THAN
	;

type_parameter :
	T_ID
	;

/*----------------------------*/
/* Type arguments */
/*----------------------------*/

type_arguments :
	T_LESS_THAN listc_type_argument_ T_GREATER_THAN
	| mismatched_type_arguments
	;

type_argument :
	type_
	;

/* a sequence of 2 or 3 closing > will be tokenized as >> or >>> */
/* thus, we allow type arguments to omit 1 or 2 closing > to make it up */
mismatched_type_arguments :
	T_LESS_THAN type_argument_list1 T_RSHIFT
	| T_LESS_THAN type_argument_list2 T_RSHIFT3
	;

type_argument_list1 :
	nominal_type1
	| listc_type_argument_ T_COMMA nominal_type1
	;

nominal_type1 :
	type_name type_arguments1
	;

/* missing 1 closing > */
type_arguments1 :
	T_LESS_THAN listc_type_argument_
	;

type_argument_list2 :
	nominal_type2
	| listc_type_argument_ T_COMMA nominal_type2
	;

nominal_type2 :
	type_name type_arguments2
	;

/* missing 2 closing > */
type_arguments2 :
	T_LESS_THAN type_argument_list1
	;

/*----------------------------*/
/* Type or expr */
/*----------------------------*/

/* Extends arguments can be any expr according to ES6
 * However, this causes ambiguities with type arguments a la TypeScript.
 * Unfortunately, TypeScript enforces severe restrictions here,
 * which e.g. do not admit mixins, which we want to support
 * TODO ambiguity Xxx.yyy, a Period expr or a module path in TypeScript?
 */
type_or_expr :
	/* typescript-ext: */
	type_reference_aux
	;

/*************************************************************************/
/* Stmt */
/*************************************************************************/

stmt :
	block
	| variable_stmt
	| empty_stmt
	| expr_stmt
	| if_stmt
	| iteration_stmt
	| continue_stmt
	| break_stmt
	| return_stmt
	| with_stmt
	| labelled_stmt
	| switch_stmt
	| throw_stmt
	| try_stmt
	/* sgrep-ext:
	* TODO add an sc? then remove the other ugly "..." and less conflicts?
	*/
	| T_DOTS
	;

block :
	T_LCURLY optl_stmt_list_ T_RCURLY
	;

stmt_list :
	nonempty_list_item_
	;

empty_stmt :
	sc
	;

/* less:
 *    | A.String("use strict", tok) ->
 *      [A.ExprStmt (A.Apply(A.IdSpecial (A.UseStrict, tok), fb []), t)]
 */
expr_stmt :
	expr_no_stmt sc
	;

if_stmt :
	T_IF T_LPAREN expr T_RPAREN stmt T_ELSE stmt
	| T_IF T_LPAREN expr T_RPAREN stmt  %prec p_IF
	;

iteration_stmt :
	T_DO stmt T_WHILE T_LPAREN expr T_RPAREN sc
	| T_WHILE T_LPAREN expr T_RPAREN stmt
	| T_FOR T_LPAREN option_expr_no_in_ T_SEMICOLON option_expr_ T_SEMICOLON option_expr_ T_RPAREN stmt
	| T_FOR T_LPAREN for_variable_decl T_SEMICOLON option_expr_ T_SEMICOLON option_expr_ T_RPAREN stmt
	| T_FOR T_LPAREN left_hand_side_expr T_IN expr T_RPAREN stmt
	| T_FOR T_LPAREN for_single_variable_decl T_IN expr T_RPAREN stmt
	| T_FOR T_LPAREN left_hand_side_expr T_OF assignment_expr T_RPAREN stmt
	| T_FOR T_LPAREN for_single_variable_decl T_OF assignment_expr T_RPAREN stmt
	/* sgrep-ext: */
	| T_FOR T_LPAREN T_DOTS T_RPAREN stmt
	;

initializer_no_in :
	T_ASSIGN assignment_expr_no_in
	;

continue_stmt :
	T_CONTINUE option_id_ sc
	;

break_stmt :
	T_BREAK option_id_ sc
	;

return_stmt :
	T_RETURN option_expr_ sc
	;

with_stmt :
	T_WITH T_LPAREN expr T_RPAREN stmt
	;

switch_stmt :
	T_SWITCH T_LPAREN expr T_RPAREN case_block
	;

labelled_stmt :
	id T_COLON stmt
	;

throw_stmt :
	T_THROW expr sc
	;

try_stmt :
	T_TRY block catch
	| T_TRY block finally
	| T_TRY block catch finally
	;

catch :
	T_CATCH T_LPAREN id T_RPAREN block
	/* es2019 */
	| T_CATCH block
	| T_CATCH T_LPAREN binding_pattern T_RPAREN block
	;

finally :
	T_FINALLY block
	;

/*----------------------------*/
/* auxillary stmts */
/*----------------------------*/

case_block :
	T_LCURLY list_case_clause_ T_RCURLY
	| T_LCURLY list_case_clause_ default_clause list_case_clause_ T_RCURLY
	;

case_clause :
	T_CASE expr T_COLON optl_stmt_list_
	;

default_clause :
	T_DEFAULT T_COLON optl_stmt_list_
	;

/*************************************************************************/
/* Exprs */
/*************************************************************************/

expr :
	assignment_expr
	| expr T_COMMA assignment_expr
	;

/* coupling: see also assignment_expr_no_stmt and extend if can? */
assignment_expr :
	conditional_expr_d1_
	| left_hand_side_expr__d1_ assignment_operator assignment_expr
	/* es6: */
	| arrow_function
	/* es6: */
	| T_YIELD
	| T_YIELD assignment_expr
	| T_YIELD T_MULT assignment_expr
	/* typescript-ext: 1.6, because <> cant be used in TSX files */
	| left_hand_side_expr__d1_ T_AS type_
	/* sgrep-ext: TODO can't move in primary_expr_no_braces, get s/r conflicts
	* (LDots however can be put in primary_expr_no_braces)
	*/
	| T_DOTS
	;

left_hand_side_expr :
	left_hand_side_expr__d1_
	;

/*----------------------------*/
/* Generic part (to factorize rules) */
/*----------------------------*/

conditional_expr_d1_ :
	post_in_expr_d1_
	| post_in_expr_d1_ T_PLING assignment_expr T_COLON assignment_expr
	;

conditional_expr_primary_no_stmt_ :
	post_in_expr_primary_no_stmt_
	| post_in_expr_primary_no_stmt_ T_PLING assignment_expr T_COLON assignment_expr
	;

left_hand_side_expr__d1_ :
	new_expr_d1_
	| call_expr_d1_
	;

left_hand_side_expr__primary_no_stmt_ :
	new_expr_primary_no_stmt_
	| call_expr_primary_no_stmt_
	;

post_in_expr_d1_ :
	pre_in_expr_d1_
	| post_in_expr_d1_ T_LESS_THAN post_in_expr_d1_
	| post_in_expr_d1_ T_GREATER_THAN post_in_expr_d1_
	| post_in_expr_d1_ T_LESS_THAN_EQUAL post_in_expr_d1_
	| post_in_expr_d1_ T_GREATER_THAN_EQUAL post_in_expr_d1_
	| post_in_expr_d1_ T_INSTANCEOF post_in_expr_d1_
	/* also T_IN! */
	| post_in_expr_d1_ T_IN post_in_expr_d1_
	| post_in_expr_d1_ T_EQUAL post_in_expr_d1_
	| post_in_expr_d1_ T_NOT_EQUAL post_in_expr_d1_
	| post_in_expr_d1_ T_STRICT_EQUAL post_in_expr_d1_
	| post_in_expr_d1_ T_STRICT_NOT_EQUAL post_in_expr_d1_
	| post_in_expr_d1_ T_BIT_AND post_in_expr_d1_
	| post_in_expr_d1_ T_BIT_XOR post_in_expr_d1_
	| post_in_expr_d1_ T_BIT_OR post_in_expr_d1_
	| post_in_expr_d1_ T_AND post_in_expr_d1_
	| post_in_expr_d1_ T_OR post_in_expr_d1_
	;

post_in_expr_primary_no_stmt_ :
	pre_in_expr_primary_no_stmt_
	| post_in_expr_primary_no_stmt_ T_LESS_THAN post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_GREATER_THAN post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_LESS_THAN_EQUAL post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_GREATER_THAN_EQUAL post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_INSTANCEOF post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_IN post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_EQUAL post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_NOT_EQUAL post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_STRICT_EQUAL post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_STRICT_NOT_EQUAL post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_BIT_AND post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_BIT_XOR post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_BIT_OR post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_AND post_in_expr_d1_
	| post_in_expr_primary_no_stmt_ T_OR post_in_expr_d1_
	;

/* called unary_expr and update_expr in ECMA */
pre_in_expr_d1_ :
	left_hand_side_expr__d1_
	| pre_in_expr_d1_ T_INCR
	| pre_in_expr_d1_ T_DECR
	| T_INCR pre_in_expr_d1_
	| T_DECR pre_in_expr_d1_
	| T_DELETE pre_in_expr_d1_
	| T_VOID pre_in_expr_d1_
	| T_TYPEOF pre_in_expr_d1_
	| T_PLUS pre_in_expr_d1_
	| T_MINUS pre_in_expr_d1_
	| T_BIT_NOT pre_in_expr_d1_
	| T_NOT pre_in_expr_d1_
	/* es7: */
	| T_AWAIT pre_in_expr_d1_
	| pre_in_expr_d1_ T_MULT pre_in_expr_d1_
	| pre_in_expr_d1_ T_DIV pre_in_expr_d1_
	| pre_in_expr_d1_ T_MOD pre_in_expr_d1_
	| pre_in_expr_d1_ T_PLUS pre_in_expr_d1_
	| pre_in_expr_d1_ T_MINUS pre_in_expr_d1_
	| pre_in_expr_d1_ T_LSHIFT pre_in_expr_d1_
	| pre_in_expr_d1_ T_RSHIFT pre_in_expr_d1_
	| pre_in_expr_d1_ T_RSHIFT3 pre_in_expr_d1_
	/* es7: */
	| pre_in_expr_d1_ T_EXPONENT pre_in_expr_d1_
	;

pre_in_expr_primary_no_stmt_ :
	left_hand_side_expr__primary_no_stmt_
	| pre_in_expr_primary_no_stmt_ T_INCR
	| pre_in_expr_primary_no_stmt_ T_DECR
	| T_INCR pre_in_expr_d1_
	| T_DECR pre_in_expr_d1_
	| T_DELETE pre_in_expr_d1_
	| T_VOID pre_in_expr_d1_
	| T_TYPEOF pre_in_expr_d1_
	| T_PLUS pre_in_expr_d1_
	| T_MINUS pre_in_expr_d1_
	| T_BIT_NOT pre_in_expr_d1_
	| T_NOT pre_in_expr_d1_
	| T_AWAIT pre_in_expr_d1_
	| pre_in_expr_primary_no_stmt_ T_MULT pre_in_expr_d1_
	| pre_in_expr_primary_no_stmt_ T_DIV pre_in_expr_d1_
	| pre_in_expr_primary_no_stmt_ T_MOD pre_in_expr_d1_
	| pre_in_expr_primary_no_stmt_ T_PLUS pre_in_expr_d1_
	| pre_in_expr_primary_no_stmt_ T_MINUS pre_in_expr_d1_
	| pre_in_expr_primary_no_stmt_ T_LSHIFT pre_in_expr_d1_
	| pre_in_expr_primary_no_stmt_ T_RSHIFT pre_in_expr_d1_
	| pre_in_expr_primary_no_stmt_ T_RSHIFT3 pre_in_expr_d1_
	| pre_in_expr_primary_no_stmt_ T_EXPONENT pre_in_expr_d1_
	;

call_expr_d1_ :
	member_expr_d1_ arguments
	| call_expr_d1_ arguments
	| call_expr_d1_ T_LBRACKET expr T_RBRACKET
	| call_expr_d1_ access method_name
	/* es6: */
	| call_expr_d1_ template_literal
	| T_SUPER arguments
	| call_expr_d1_ T_PERIOD T_DOTS
	;

call_expr_primary_no_stmt_ :
	member_expr_primary_no_stmt_ arguments
	| call_expr_primary_no_stmt_ arguments
	| call_expr_primary_no_stmt_ T_LBRACKET expr T_RBRACKET
	| call_expr_primary_no_stmt_ access method_name
	| call_expr_primary_no_stmt_ template_literal
	| T_SUPER arguments
	/* sgrep-ext: note that we used to require just a "...", without the "."
	  * before, which was more lightweight, but introduced ambiguity with
	  * ASI for patterns like:
	  *   foo()
	  *   ...
	  * so we now require an extra '.'. Unfortunately this require the user
	  * to add an extra space between the first "." and "..." otherwise it
	  * is parsed as "..." and "."
	*/
	| call_expr_primary_no_stmt_ T_PERIOD T_DOTS
	;

new_expr_d1_ :
	member_expr_d1_
	| T_NEW new_expr_d1_
	;

new_expr_primary_no_stmt_ :
	member_expr_primary_no_stmt_
	| T_NEW new_expr_d1_
	;

access :
	T_PERIOD
	| T_QUESTDOT
	;

member_expr_d1_ :
	primary_expr_d1_
	| member_expr_d1_ T_LBRACKET expr T_RBRACKET
	| member_expr_d1_ access field_name
	| T_NEW member_expr_d1_ arguments
	/* es6: */
	| member_expr_d1_ template_literal
	| T_SUPER T_LBRACKET expr T_RBRACKET
	| T_SUPER access field_name
	| T_NEW T_PERIOD id
	| member_expr_d1_ T_PERIOD T_DOTS
	;

member_expr_primary_no_stmt_ :
	primary_expr_primary_no_stmt_
	| member_expr_primary_no_stmt_ T_LBRACKET expr T_RBRACKET
	| member_expr_primary_no_stmt_ access field_name
	| T_NEW member_expr_d1_ arguments
	| member_expr_primary_no_stmt_ template_literal
	| T_SUPER T_LBRACKET expr T_RBRACKET
	| T_SUPER access field_name
	| T_NEW T_PERIOD id
	/* sgrep-ext: */
	| member_expr_primary_no_stmt_ T_PERIOD T_DOTS
	;

primary_expr_d1_ :
	primary_expr_no_braces
	| d1
	;

primary_expr_primary_no_stmt_ :
	primary_expr_no_braces
	| primary_no_stmt
	;

d1 :
	primary_with_stmt
	;

primary_with_stmt :
	object_literal
	| function_expr
	/* es6: */
	| class_expr
	/* es6: */
	| generator_expr
	/* es7: */
	| async_function_expr
	;

primary_expr_no_braces :
	T_THIS
	| id
	| null_literal
	| boolean_literal
	| numeric_literal
	| string_literal
	/* marcel: this isn't an expansion of literal in ECMA-262... mistake? */
	| regex_literal
	| array_literal
	/* simple! ECMA mixes this rule with arrow parameters (bad) */
	| T_LPAREN expr T_RPAREN
	| T_LPAREN id T_COLON type_ T_RPAREN
	/* xhp: do not put in 'expr', otherwise can't have xhp in function arg */
	| xhp_html
	| template_literal
	/* sgrep-ext: */
	| LDots expr RDots
	;

/*----------------------------*/
/* scalar */
/*----------------------------*/

boolean_literal :
	T_TRUE
	| T_FALSE
	;

null_literal :
	T_NULL
	;

numeric_literal :
	T_INT
	| T_FLOAT
	;

numeric_literal_as_string :
	numeric_literal
	;

regex_literal :
	T_REGEX
	;

string_literal :
	T_STRING
	;

/*----------------------------*/
/* assign */
/*----------------------------*/

assignment_operator :
	T_ASSIGN
	| T_MULT_ASSIGN
	| T_DIV_ASSIGN
	| T_MOD_ASSIGN
	| T_PLUS_ASSIGN
	| T_MINUS_ASSIGN
	| T_LSHIFT_ASSIGN
	| T_RSHIFT_ASSIGN
	| T_RSHIFT3_ASSIGN
	| T_BIT_AND_ASSIGN
	| T_BIT_XOR_ASSIGN
	| T_BIT_OR_ASSIGN
	;

/*----------------------------*/
/* array */
/*----------------------------*/

/* TODO: use elision below */
array_literal :
	T_LBRACKET optl_elision_ T_RBRACKET
	| T_LBRACKET element_list_rev optl_elision_ T_RBRACKET
	;

/* TODO: conflict on ",", */
element_list_rev :
	optl_elision_ element
	| element_list_rev T_COMMA element
	| element_list_rev T_COMMA elision element
	;

element :
	assignment_expr
	/* es6: spread operator: */
	| T_DOTS assignment_expr
	;

/*----------------------------*/
/* object */
/*----------------------------*/

object_literal :
	T_LCURLY T_RCURLY
	| T_LCURLY listc_property_name_and_value_ option_T_COMMA_ T_RCURLY
	;

property_name_and_value :
	property_name T_COLON assignment_expr
	| method_definition
	/* es6: */
	| id
	/* es6: spread operator: */
	| T_DOTS assignment_expr
	| T_DOTS
	;

/*----------------------------*/
/* function call */
/*----------------------------*/

arguments :
	T_LPAREN argument_list_opt T_RPAREN
	;

argument_list_opt :
	/*empty*/
	/* argument_list must be written in a left-recursive way(see conflicts.txt) */
	| listc_argument_ option_T_COMMA_
	;

/* assignment_expr because expr supports sequence of exprs with ',' */
argument :
	assignment_expr
	/* es6: spread operator, allowed not only in last position */
	| T_DOTS assignment_expr
	;

/*----------------------------*/
/* XHP embeded html */
/*----------------------------*/

/* less: we should split $1 in 2 tokens, like we do in tree-sitter-js */
xhp_html :
	T_XHP_OPEN_TAG list_xhp_attribute_ T_XHP_GT list_xhp_child_ T_XHP_CLOSE_TAG
	| T_XHP_OPEN_TAG list_xhp_attribute_ T_XHP_SLASH_GT
	| T_XHP_SHORT_FRAGMENT list_xhp_child_ T_XHP_CLOSE_TAG
	;

xhp_child :
	T_XHP_TEXT
	| xhp_html
	| T_LCURLY expr option_sc_ T_RCURLY
	/* sometimes people use empty { } to put comment in it */
	| T_LCURLY T_RCURLY
	;

xhp_attribute :
	T_XHP_ATTR T_ASSIGN xhp_attribute_value
	| T_LCURLY T_DOTS assignment_expr T_RCURLY
	/* reactjs-ext: see https://www.reactenlightenment.com/react-jsx/5.7.html */
	| T_XHP_ATTR
	| T_DOTS
	;

xhp_attribute_value :
	T_STRING
	| T_LCURLY expr option_sc_ T_RCURLY
	| T_DOTS
	/* sgrep-ext: only metavariable actually */
	| T_XHP_ATTR
	;

/*----------------------------*/
/* interpolated strings */
/*----------------------------*/

/* templated string (a.k.a interpolated strings) */
template_literal :
	T_BACKQUOTE list_encaps_ T_BACKQUOTE
	;

encaps :
	T_ENCAPSED_STRING
	| T_DOLLARCURLY expr T_RCURLY
	;

/*----------------------------*/
/* arrow (short lambda) */
/*----------------------------*/

/* TODO conflict with as then in indent_keyword_bis */
arrow_function :
	/* es7: */
	T_ASYNC id T_ARROW arrow_body
	| id T_ARROW arrow_body
	/* can not factorize with TOPAR parameter_list TCPAR, see conflicts.txt */
	/* es7: */
	| T_ASYNC T_LPAREN_ARROW formal_parameter_list_opt T_RPAREN option_annotation_ T_ARROW arrow_body
	| T_LPAREN_ARROW formal_parameter_list_opt T_RPAREN option_annotation_ T_ARROW arrow_body
	;

/* was called consise body in spec */
arrow_body :
	block
	/* see conflicts.txt for why the %prec */
	| assignment_expr_no_stmt
	/* ugly */
	| function_expr
	/* sgrep-ext: TODO should move in assignment_expr_no_stmt but s/r conflicts */
	| T_DOTS
	;

/*----------------------------*/
/* no in */
/*----------------------------*/

expr_no_in :
	assignment_expr_no_in
	| expr_no_in T_COMMA assignment_expr_no_in
	;

assignment_expr_no_in :
	conditional_expr_no_in
	| left_hand_side_expr__d1_ assignment_operator assignment_expr_no_in
	;

conditional_expr_no_in :
	post_in_expr_no_in
	| post_in_expr_no_in T_PLING assignment_expr_no_in T_COLON assignment_expr_no_in
	;

post_in_expr_no_in :
	pre_in_expr_d1_
	| post_in_expr_no_in T_LESS_THAN post_in_expr_d1_
	| post_in_expr_no_in T_GREATER_THAN post_in_expr_d1_
	| post_in_expr_no_in T_LESS_THAN_EQUAL post_in_expr_d1_
	| post_in_expr_no_in T_GREATER_THAN_EQUAL post_in_expr_d1_
	| post_in_expr_no_in T_INSTANCEOF post_in_expr_d1_
	/* no T_IN case */
	| post_in_expr_no_in T_EQUAL post_in_expr_d1_
	| post_in_expr_no_in T_NOT_EQUAL post_in_expr_d1_
	| post_in_expr_no_in T_STRICT_EQUAL post_in_expr_d1_
	| post_in_expr_no_in T_STRICT_NOT_EQUAL post_in_expr_d1_
	| post_in_expr_no_in T_BIT_AND post_in_expr_d1_
	| post_in_expr_no_in T_BIT_XOR post_in_expr_d1_
	| post_in_expr_no_in T_BIT_OR post_in_expr_d1_
	| post_in_expr_no_in T_AND post_in_expr_d1_
	| post_in_expr_no_in T_OR post_in_expr_d1_
	;

/*----------------------------*/
/* (no stmt, and no object literal like { v: 1 }) */
/*----------------------------*/
expr_no_stmt :
	assignment_expr_no_stmt
	| expr_no_stmt T_COMMA assignment_expr
	;

/* coupling: with assignment_expr */
assignment_expr_no_stmt :
	conditional_expr_primary_no_stmt_
	| left_hand_side_expr__primary_no_stmt_ assignment_operator assignment_expr
	/* es6: */
	| arrow_function
	/* es6: */
	| T_YIELD
	| T_YIELD assignment_expr
	| T_YIELD T_MULT assignment_expr
	;

/* no object_literal here */
primary_no_stmt :
	TUnknown TComment
	;

/*************************************************************************/
/* Entities, names */
/*************************************************************************/

/* used for entities, parameters, labels, etc. */
id :
	T_ID  %prec below_COLON
	| ident_semi_keyword
	;

/* add here keywords which are not considered reserved by ECMA */
ident_semi_keyword :
	T_FROM
	| T_OF
	| T_GET
	| T_SET
	| T_CONSTRUCTOR
	| T_TYPE
	| T_ANY_TYPE
	| T_NUMBER_TYPE
	| T_BOOLEAN_TYPE
	| T_STRING_TYPE
	| T_DECLARE
	| T_MODULE
	| T_PUBLIC
	| T_PRIVATE
	| T_PROTECTED
	| T_READONLY
	/* can have AS and ASYNC here but need to restrict arrow_function then */
	| T_AS
	| T_ASYNC
	/* TODO: would like to add T_IMPORT here, but cause conflicts */
	;

/* alt: use the _last_non_whitespace_like_token trick and look if
 * previous token was a period to return a T_ID
 */
ident_keyword :
	ident_keyword_bis
	;

ident_keyword_bis :
	T_FUNCTION
	| T_CONST
	| T_VAR
	| T_LET
	| T_IF
	| T_ELSE
	| T_WHILE
	| T_FOR
	| T_DO
	| T_CONTINUE
	| T_BREAK
	| T_SWITCH
	| T_CASE
	| T_DEFAULT
	| T_RETURN
	| T_THROW
	| T_TRY
	| T_CATCH
	| T_FINALLY
	| T_YIELD
	| T_AWAIT
	| T_NEW
	| T_IN
	| T_INSTANCEOF
	| T_DELETE
	| T_THIS
	| T_SUPER
	| T_WITH
	| T_NULL
	| T_FALSE
	| T_TRUE
	| T_CLASS
	| T_INTERFACE
	| T_EXTENDS
	| T_STATIC
	| T_IMPORT
	| T_EXPORT
	| T_ENUM
	| T_TYPEOF
	| T_VOID
	;

field_name :
	id
	| ident_keyword
	;

method_name :
	id
	| ident_keyword
	;

property_name :
	id
	| string_literal
	| numeric_literal_as_string
	| ident_keyword
	/* es6: */
	| T_LBRACKET assignment_expr T_RBRACKET
	;

/*************************************************************************/
/* Misc */
/*************************************************************************/
sc :
	T_SEMICOLON
	| T_VIRTUAL_SEMICOLON
	;

sc_or_comma :
	sc
	| T_COMMA
	;

elision :
	T_COMMA
	| elision T_COMMA
	;

%%

%x TRY_REGEX

/*****************************************************************************/
/* Regexp aliases */
/*****************************************************************************/

NEWLINE  ("\r"|"\n"|"\r\n")
HEXA  [0-9a-fA-F]

/* JSX allows also '.' */
XHPLABEL 	[a-zA-Z_][a-zA-Z0-9_  .-]*
XHPTAG_ORIG  XHPLABEL (":"{XHPLABEL})*
XHPATTR  XHPLABEL (":"{XHPLABEL})*
/* sgrep-ext: less: should use Flag.sgrep_guard to forbid $ in normal mode */
XHPTAG  "$"?{XHPTAG_ORIG}

InputCharacter  [^ \r\n]

SPACES	[ \t\r\n]+
COMMENT	"//"[^\r\n]*
C_STYLE_COMMENT "/*"(?s:.)*?"*/"
SWS {SPACES}|{COMMENT}|{C_STYLE_COMMENT}

%%
/*Lexer*/

//{SPACES} skip()
//{COMMENT}	skip()
//{C_STYLE_COMMENT}	skip()
{SWS}   skip()

/* ---------------------------------------------------------------------- */
/* Keywords */
/* ---------------------------------------------------------------------- */
"if"	T_IF
"else"	T_ELSE

"while"	T_WHILE
"do"	T_DO
"for"	T_FOR

"switch"	T_SWITCH
"case"	T_CASE
"default"	T_DEFAULT

"break"	T_BREAK
"continue"	T_CONTINUE

<INITIAL,TRY_REGEX>"return"	T_RETURN

"throw"	T_THROW
"try"	T_TRY
"catch"	T_CATCH
"finally"	T_FINALLY

"function"	T_FUNCTION
"var"	T_VAR
/* es6: */
"const"	T_CONST
"let"	T_LET

"new"	T_NEW
"delete"	T_DELETE

"void"	T_VOID
"null"	T_NULL

"false"	T_FALSE
"true"	T_TRUE

"in"	T_IN
/* es6: */
"of"	T_OF

"this"	T_THIS
/* es6: */
"super"	T_SUPER

"instanceof"	T_INSTANCEOF
"typeof"	T_TYPEOF

"with"	T_WITH

/* es6: */

"yield"	T_YIELD
"async"	T_ASYNC
"await"	T_AWAIT

"class"	T_CLASS
"extends"	T_EXTENDS

"static"	T_STATIC

"get"	T_GET
"set"	T_SET

"import"	T_IMPORT
"export"	T_EXPORT
"from"	T_FROM
"as"	T_AS

/* typescript: */

"interface"	T_INTERFACE
"implements"	T_IMPLEMENTS
"constructor"	T_CONSTRUCTOR

"public"	T_PUBLIC
"private"	T_PRIVATE
"protected"	T_PROTECTED

"readonly"	T_READONLY

"type"	T_TYPE

"any"	T_ANY_TYPE
"number"	T_NUMBER_TYPE
"boolean"	T_BOOLEAN_TYPE
"string"	T_STRING_TYPE
/* void before */

"enum"	T_ENUM

"module"	T_MODULE
"declare"	T_DECLARE

/* less: debugger, opaque, package, require */

//push_mode ST_IN_CODE;
"{" T_LCURLY
//pop_mode ();
"}" T_RCURLY

<INITIAL,TRY_REGEX>"("  T_LPAREN
")"  T_RPAREN

<INITIAL,TRY_REGEX>"["  T_LBRACKET
"]"  T_RBRACKET
"."  T_PERIOD
";"  T_SEMICOLON
<INITIAL,TRY_REGEX>","  T_COMMA
<INITIAL,TRY_REGEX>":"  T_COLON
"?"  T_PLING
"?."  T_QUESTDOT
"&&"  T_AND
"||"  T_OR
"==="  T_STRICT_EQUAL
"!=="  T_STRICT_NOT_EQUAL
"<="  T_LESS_THAN_EQUAL
">="  T_GREATER_THAN_EQUAL
"=="  T_EQUAL
"!="  T_NOT_EQUAL
"++"  T_INCR
"--"  T_DECR
"<<="  T_LSHIFT_ASSIGN
"<<"  T_LSHIFT
">>="  T_RSHIFT_ASSIGN
">>>="  T_RSHIFT3_ASSIGN
">>>"  T_RSHIFT3
">>"  T_RSHIFT
"+="  T_PLUS_ASSIGN
"-="  T_MINUS_ASSIGN

"*="  T_MULT_ASSIGN
"%="  T_MOD_ASSIGN
"&="  T_BIT_AND_ASSIGN
"|="  T_BIT_OR_ASSIGN
"^="  T_BIT_XOR_ASSIGN
/* see also xhp code for handling "< XHPTAG" below */
"<"  T_LESS_THAN
">"  T_GREATER_THAN
"+"  T_PLUS
"-"  T_MINUS
"*"  T_MULT
/* for '/' see below the regexp handling */
"%"  T_MOD
"|"  T_BIT_OR
"&"  T_BIT_AND
"^"  T_BIT_XOR
<INITIAL,TRY_REGEX>"!"  T_NOT
"~"  T_BIT_NOT
<INITIAL,TRY_REGEX>"="  T_ASSIGN
/* es7: */
"**"  T_EXPONENT

/* arrows (aka short lambdas) */
"=>"  T_ARROW
/* variable number of parameters (and sgrep-ext)
* less: enforce directly attached to ident? */
"..."  T_DOTS
/* sgrep-ext: */
"<..."  LDots
"...>"  RDots

/* https://tc39.es/proposal-decorators/ */
"@"   T_AT


//EOF	EOF
T_BACKQUOTE	T_BACKQUOTE
TComment	TComment
"/"	T_DIV
"/="	T_DIV_ASSIGN
"${"	T_DOLLARCURLY
"(=>"	T_LPAREN_ARROW
T_VIRTUAL_SEMICOLON	T_VIRTUAL_SEMICOLON
T_XHP_ATTR	T_XHP_ATTR
T_XHP_CLOSE_TAG	T_XHP_CLOSE_TAG
T_XHP_GT	T_XHP_GT
T_XHP_OPEN_TAG	T_XHP_OPEN_TAG
T_XHP_SHORT_FRAGMENT	T_XHP_SHORT_FRAGMENT
T_XHP_SLASH_GT	T_XHP_SLASH_GT
T_XHP_TEXT	T_XHP_TEXT

([=(!:,\[]|"return"){SPACES}*"/"<TRY_REGEX> reject()
<TRY_REGEX>{
    {SPACES}    skip()
    {COMMENT}<INITIAL> skip()
    {C_STYLE_COMMENT}<INITIAL> skip()
	"/"(\\.|[^/\n\r\\])+"/"[gmi]*<INITIAL>	T_REGEX
}

0[xX][a-fA-F0-9]+|[0-9]+	T_INT
[0-9]+([Ee][+-]?[0-9]+)?|[0-9]*\.[0-9]+([Ee][+-]?[0-9]+)?	T_FLOAT
\"(\\.|[^\"\n\r\\])*\"|'(\\.|[^'\n\r\\])*'	T_STRING
"`"(\\.|[^`\n\r\\])*"`"	T_ENCAPSED_STRING

/* Order matter if identifier comes before keywords they are classified as identifier */
[a-zA-Z_$][a-zA-Z_0-9$]*	T_ID

.	TUnknown

%%

/*
# -*- org -*-

* short lambdas
#(this is similar to lang_php/parsing/conflicts.txt#short_lambdas)

** short body

When we parse 'x => x + 1', it could potentially be parsed as
'( x => x + 1)' or '(x => x) + 1' but we don't
want the second one, so we prefer to shift rather than reduce,
hence the %prec (just like for the dangling else) attached
to 'expr' below:

arrow_body:
 | block { }
 | expr  %prec LOW_PRIORITY_RULE { }

An additional complexity in Javascript compared to PHP is that
'{' is also used for object literal, so one has to use
an 'expr' which does not allow object literal, that is
'assignment_expression_no_statement'
(but do not forget to extend those mostly-copy-pasted rules
with extensions such as arrows, or async, otherwise you can not
even curry and write code like 'x => y => x + y').

** short parameters

The other conflict is that when we see '(x)' in '(x) => ...'
there is no way to know whether this is an expression (reduce) or
the parameter specification of a lambda (shift).

*** technique 1

To solve the conflict one can be more general and do:

 | TOPAR expr TCPAR T_ARROW arrow_body
     { ... }

but you then need to make sure that expr can only be an identifier.


A shift-reduce conflict then exists when we see '(x,' and we prefer to
shift per the following rule, expecting something like '(x,y) => ...'

arrow_function:
  | T_LPAREN identifier T_COMMA formal_parameter_list T_RPAREN
    annotation_opt T_ARROW arrow_body

rather than reduce per the following rule, expecting something like '(x,y) + ...'

expression:
 | expression T_COMMA assignment_expression

This means that something like '(x,y) + ...' does not currently parse;
fortunately, it is uncommon.

*** technique 2

A better technique is to use a parsing hack and retag the '(' T_LPAREN
in a T_LPAREN_ARROW when you see '( <xxx> ) =>' while matching
a fuzzy AST of the JS tokens. Then there is no ambiguity
and you can simply use formal_parameter_list_opt after this
special T_LPAREN_ARROW.

The ECMA grammar uses the CoverParenthesizedExpressionAndArrowParameterList
conflating rule which is ugly. The retag-token technique is far cleaner.

* trailing commas

Introducing trailing commas can introduce some shift/reduce conflicts
on rules using lists written in a non-left recursive way. Indeed on this:

formal_parameter_list_opt:
 | / *empty* /   { }
 | formal_parameter_list trailing_comma  { }

formal_parameter_list:
 | formal_parameter T_COMMA formal_parameter_list { }
 | formal_parameter  { }

Yacc generates this conflict:

238: shift/reduce conflict (shift 517, reduce 139) on T_COMMA
state 238
	formal_parameter_list : formal_parameter . T_COMMA formal_parameter_list  (138)
	formal_parameter_list : formal_parameter .  (139)

	T_COMMA  shift 517

because after one parameter and seeing a comma, it can not decide if this
comma is introducing a new parameter (shift) or if it's part of the
trailing comma after the formal_paramater_list (in which case it needs
to reduce).

You need to rewrite the rule left-recursive like this:

formal_parameter_list:
 | formal_parameter_list T_COMMA formal_parameter { }
 | formal_parameter  { }

Then after a comma it must always just reduce.

* ASI and continue, break, ++, --, etc.

The fact that the parser allows ASI (Automatic Semicolon Insertion)
introduces some ambiguities with the grammar. Indeed, given

 if(true) continue
 x;

can be parsed either as a 'if (true) continue x;' or
'if (true) continue; x;' with ASI. To avoid this ambiguity
the standard allows newline just after a continue but in that
case it always do an ASI. This means we need to have a fix_tokens
phase that inserts those semicolons.

* TODO Types and JSX

Flow does not allow '<T>(x:T):T => ...' since the leading '<T>' looks like
a JSX tag.

But Typescript has some files like that.

* TODO Import

When we start to process 'import *' and we allow
import as an identifier, then there is an ambiguity
and we don't know yet if we need to reduce import to an identifier
which starts a multiplication or to shift to allow an
import namespace declaration.

How to solve the ambiguity?
You could use a parsing hack and looking if you are in the
first column, but this does not always work.

TODO: parsing hack on import() ? retag import
as an identifier?
*/
