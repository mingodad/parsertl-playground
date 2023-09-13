//From: https://github.com/reasonml/reason/blob/a3545e5f40bf90f20214a878bd3072b2365d6504/src/reason-parser/reason_parser.mly
/*
 * Copyright (c) 2015-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 *  Forked from OCaml, which is provided under the license below:
 *
 *  Xavier Leroy, projet Cristal, INRIA Rocquencourt
 *
 *  Copyright © 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006 Inria
 *
 *  Permission is hereby granted, free of charge, to the Licensee obtaining a
 *  copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation
 *  the rights to use, copy, modify, merge, publish, distribute, sublicense
 *  under any license of the Licensee's choice, and/or sell copies of the
 *  Software, subject to the following conditions:
 *
 *  1.	Redistributions of source code must retain the above copyright notice
 *  and the following disclaimer.
 *  2.	Redistributions in binary form must reproduce the above copyright
 *  notice, the following disclaimer in the documentation and/or other
 *  materials provided with the distribution.
 *  3.	All advertising materials mentioning features or use of the Software
 *  must display the following acknowledgement: This product includes all or
 *  parts of the Caml system developed by Inria and its contributors.
 *  4.	Other than specified in clause 3, neither the name of Inria nor the
 *  names of its contributors may be used to endorse or promote products
 *  derived from the Software without specific prior written permission.
 *
 *  Disclaimer
 *
 *  This software is provided by Inria and contributors “as is” and any express
 *  or implied warranties, including, but not limited to, the implied
 *  warranties of merchantability and fitness for a particular purpose are
 *  disclaimed. in no event shall Inria or its contributors be liable for any
 *  direct, indirect, incidental, special, exemplary, or consequential damages
 *  (including, but not limited to, procurement of substitute goods or
 *  services; loss of use, data, or profits; or business interruption) however
 *  caused and on any theory of liability, whether in contract, strict
 *  liability, or tort (including negligence or otherwise) arising in any way
 *  out of the use of this software, even if advised of the possibility of such
 *  damage.
 *
 */

%x BLK_COMMENT

/* Tokens */

%token AMPERAMPER
%token AMPERSAND
%token AND
%token AS
%token ASSERT
%token BACKQUOTE
%token BANG
%token BAR
%token BARBAR
%token BARRBRACKET
%token BEGIN
%token CHAR
%token CLASS
%token COLON
%token COLONCOLON
%token COLONEQUAL
%token COLONGREATER
%token COMMA
%token CONSTRAINT
%token DO
%token DONE
%token DOT
%token DOTDOT
%token DOTDOTDOT
%token DOWNTO
%token ELSE
%token END
//%token EOF
%token EQUAL
%token EXCEPTION
%token EXTERNAL
%token FALSE
%token FLOAT
%token FOR
%token FUN ES6_FUN
%token FUNCTION
%token FUNCTOR
%token GREATER
%token GREATERRBRACE
%token GREATERDOTDOTDOT
%token IF
%token IN
%token INCLUDE
%token INFIXOP0
%token INFIXOP1
%token INFIXOP2
%token INFIXOP3
/* SLASHGREATER is an INFIXOP3 that is handled specially */
%token SLASHGREATER
%token INFIXOP4
%token LETOP
%token ANDOP
%token INHERIT
%token INITIALIZER
%token INT
%token LAZY
%token LBRACE
%token LBRACELESS
%token LBRACKET
%token LBRACKETBAR
%token LBRACKETLESS
%token LBRACKETGREATER
%token LBRACKETPERCENT
%token LBRACKETPERCENTPERCENT
%token LESS
%token LESSIDENT
%token LESSUIDENT
%token LESSGREATER
%token LESSSLASHGREATER
%token LESSDOTDOTGREATER
%token EQUALGREATER
%token LET
%token LIDENT
%token LPAREN
%token LBRACKETAT
%token OF
%token PRI
%token SWITCH
%token MINUS
%token MINUSDOT
%token MINUSGREATER
%token MODULE
%token MUTABLE
//%token NATIVEINT
%token NEW
%token NONREC
%token OBJECT
%token OPEN
%token OR
/* %token PARSER */
%token PERCENT
%token PLUS
%token PLUSDOT
%token PLUSEQ
%token PREFIXOP
%token POSTFIXOP
%token PUB
%token QUESTION
%token QUOTE
%token RBRACE
%token RBRACKET
%token REC
%token RPAREN
%token LESSSLASHIDENTGREATER
%token SEMI
//%token SEMISEMI
%token SHARP
%token SHARPOP
%token SHARPEQUAL
%token SIG
%token STAR
%token STRING
%token STRUCT
%token THEN
%token TILDE
%token TO
%token TRUE
%token TRY
%token TYPE
%token UIDENT
%token UNDERSCORE
%token VAL
%token VIRTUAL
%token WHEN
%token WHILE
%token WITH
//%token COMMENT
%token DOCSTRING

//%token EOL

/* Precedences and associativities.

Tokens and rules have precedences and those precedences are used to
resolve what would otherwise be a conflict in the grammar.

Precedence and associativity/Resolving conflicts:
----------------------------
See [http://caml.inria.fr/pub/docs/manual-ocaml-4.00/manual026.html] section
about conflicts.

We will only use associativities with operators of the kind  x * x -> x
for example, in the rules of the form    expr: expr BINOP expr
in all other cases, we define two precedences if needed to resolve
conflicts.

*/
/* Question: Where is the SEMI explicit precedence? */
%nonassoc below_SEMI
%right    EQUALGREATER                  /* core_type2 (t => t => t) */
%right    COLON
%right    EQUAL                         /* below COLONEQUAL (lbl = x := e) */
%right    COLONEQUAL                    /* expr (e := e := e) */
%nonassoc QUESTION
%nonassoc WITH             /* below BAR  (match ... with ...) */
%nonassoc AND             /* above WITH (module rec A: SIG with ... and ...) */
%nonassoc ELSE                          /* (if ... then ... else ...) */
%nonassoc AS
%nonassoc below_BAR                     /* Allows "building up" of many bars */
%left     BAR                           /* pattern (p|p|p) */

%right    OR BARBAR                     /* expr (e || e || e) */
%right    AMPERSAND AMPERAMPER          /* expr (e && e && e) */
%left     INFIXOP0 LESS GREATER GREATERDOTDOTDOT /* expr (e OP e OP e) */
%left     LESSDOTDOTGREATER /* expr (e OP e OP e) */
%right    INFIXOP1                      /* expr (e OP e OP e) */
%right    COLONCOLON                    /* expr (e :: e :: e) */
%left     INFIXOP2 PLUS PLUSDOT MINUS MINUSDOT PLUSEQ /* expr (e OP e OP e) */
%left     PERCENT INFIXOP3 SLASHGREATER STAR          /* expr (e OP e OP e) */
%right    INFIXOP4                      /* expr (e OP e OP e) */

/**
 * With the way attributes are currently parsed, if we want consistent precedence for
 *
 * The OCaml parser parses the following attributes:
 *
 *    let x = true && (false [@attrOnFalse])
 *    let x = true && false [@attrOnFalse]
 *    let x = 10 + 20 [@attrOn20]
 *    let x = (10 + 20) [@attrEntireAddition]
 *
 * As:
 *
 *    let x = true && ((false)[@attrOnFalse ])
 *    let x = true && ((false)[@attrOnFalse ])
 *    let x = ((10 + 20)[@attrOn20 ])
 *    let x = ((10 + 20)[@attrEntireAddition ])
 *
 * That is because the precedence of tokens is configured as following, which
 * only serves to treat certain infix operators as different than others with
 * respect to attributes *only*.
 *
 *    %right    OR BARBAR
 *    %right    AMPERSAND AMPERAMPER
 *    %nonassoc below_EQUAL
 *    %left     INFIXOP0 EQUAL LESS GREATER
 *    %right    INFIXOP1
 *    %nonassoc LBRACKETAT
 *    %right    COLONCOLON
 *    %left     INFIXOP2 PLUS PLUSDOT MINUS MINUSDOT PLUSEQ
 *    %left     PERCENT INFIXOP3 SLASHGREATER STAR
 *    %right    INFIXOP4
 *
 * So instead, with Reason, we treat all infix operators identically w.r.t.
 * attributes. In expressions, they have the same precedence as function
 * arguments, as if they are additional arguments to a function application.
 *
 * Note that unary subtractive/plus parses with lower precedence than function
 * application (and attributes) This means that:
 *
 *   let = - something blah blah [@attr];
 *
 * Will have the attribute applied to the entire content to the right of the
 * unary minus, as if the attribute was merely another argument to the function
 * application.
 *
 *
 * To make the attribute apply to the unary -, wrap in parens.
 *
 *   let = (- something blah blah) [@attr];
 *
 * Where arrows occur, it will (as always) obey the rules of function/type
 * application.
 *
 *   type x = int => int [@onlyAppliedToTheInt];
 *   type x = (int => int) [@appliedToTheArrow];
 *
 * However, unary subtractive/plus parses with *higher* precedence than infix
 * application, so that
 *
 *   3 + - funcCall arg arg + 3;
 *
 * Is parsed as:
 *
 *   3 + (- (funcCall arg arg)) + 3;
 *
 * TODO:
 *
 * We would also like to bring this behavior to `!` as well, when ! becomes
 * "not". This is so that you may do !someFunction(arg, arg) and have the
 * entire function application negated. In fact, we may as well just have all
 * of PREFIXOP have the unary precedence parsing behavior for consistency.
 */

%nonassoc attribute_precedence

%nonassoc prec_unary /* unary - */
%nonassoc prec_constant_constructor     /* cf. simple_expr (C versus C x) */
/* Now that commas require wrapping parens (for tuples), prec_constr_appl no
* longer needs to be above COMMA, but it doesn't hurt */
%nonassoc prec_constr_appl              /* above AS BAR COLONCOLON COMMA */

/* PREFIXOP and BANG precedence */
%nonassoc below_DOT_AND_SHARP           /* practically same as below_SHARP but we convey purpose */
%nonassoc SHARP                         /* simple_expr/toplevel_directive */
%nonassoc below_DOT

/* We need SHARPEQUAL to have lower precedence than `[` to make e.g.
   this work: `foo #= bar[0]`. Otherwise it would turn into `(foo#=bar)[0]` */
%left     SHARPEQUAL
%nonassoc POSTFIXOP
/* LBRACKET and DOT are %nonassoc in OCaml, because the left and right sides
   are never the same, therefore there doesn't need to be a precedence
   disambiguation. This could also work in Reason, but by grouping the tokens
   below into a single precedence rule it becomes clearer that they all have the
   same precedence. */
%left     SHARPOP MINUSGREATER LBRACKET DOT
/* Finally, the first tokens of simple_expr are above everything else. */
%nonassoc LBRACKETLESS LBRACELESS LBRACE LPAREN



/* Entry points */

%start implementation

%%

//embedded___anonymous_0_ :
//	EOF
//	| structure_item SEMI
//	| toplevel_directive SEMI
//	;

//embedded___anonymous_1_ :
//	EOF
//	| structure_item SEMI use_file_no_mapper
//	| toplevel_directive SEMI use_file_no_mapper
//	| structure_item EOF
//	| toplevel_directive EOF
//	;
//
embedded___anonymous_32_ :
	QUOTE ident
	| UNDERSCORE
	| PLUS QUOTE ident
	| PLUS UNDERSCORE
	| MINUS QUOTE ident
	| MINUS UNDERSCORE
	;

//embedded___anonymous_39_ :
//	/*empty*/
//	| STRING
//	| INT
//	| val_longident
//	| mod_longident
//	| FALSE
//	| TRUE
//	;

embedded_private_flag_ :
	/*empty*/
	| PRI
	;

option_COMMA_ :
	/*empty*/
	| COMMA
	;

option_DOT_ :
	/*empty*/
	| DOT
	;

option_DOTDOTDOT_ :
	/*empty*/
	| DOTDOTDOT
	;

option_LET_ :
	/*empty*/
	| LET
	;

option_MODULE_ :
	/*empty*/
	| MODULE
	;

option_OF_ :
	/*empty*/
	| OF
	;

option_SEMI_ :
	/*empty*/
	| SEMI
	;

option_as_loc_preceded_AS_LIDENT___ :
	/*empty*/
	| AS LIDENT
	;

option_constructor_arguments_ :
	/*empty*/
	| constructor_arguments
	;

option_item_extension_sugar_ :
	/*empty*/
	| item_extension_sugar
	;

option_preceded_COLON_class_constructor_type__ :
	/*empty*/
	| COLON class_constructor_type
	;

option_preceded_COLON_core_type__ :
	/*empty*/
	| COLON core_type
	;

option_preceded_COLON_expr__ :
	/*empty*/
	| COLON expr
	;

option_preceded_COLON_non_arrowed_core_type__ :
	/*empty*/
	| COLON non_arrowed_core_type
	;

option_preceded_COLON_poly_type__ :
	/*empty*/
	| COLON poly_type
	;

option_preceded_COLON_simple_module_type__ :
	/*empty*/
	| COLON simple_module_type
	;

option_preceded_COLONGREATER_core_type__ :
	/*empty*/
	| COLONGREATER core_type
	;

option_preceded_WHEN_expr__ :
	/*empty*/
	| WHEN expr
	;

option_type_constraint_ :
	/*empty*/
	| type_constraint
	;

boption_AMPERSAND_ :
	/*empty*/
	| AMPERSAND
	;

loption_class_type_parameters_ :
	/*empty*/
	| LPAREN lseparated_nonempty_list_aux_COMMA_type_parameter_ option_COMMA_ RPAREN
	;

loption_functor_parameters_ :
	/*empty*/
	| functor_parameters
	;

loption_located_attributes_ :
	/*empty*/
	| nonempty_list_as_loc_attribute__
	;

loption_object_label_declarations_ :
	/*empty*/
	| object_label_declarations
	;

loption_parenthesized_class_type_arguments_comma_list__ :
	/*empty*/
	| LPAREN class_type_arguments_comma_list RPAREN
	;

loption_parenthesized_type_variables_with_variance_comma_list__ :
	/*empty*/
	| LPAREN type_variables_with_variance_comma_list RPAREN
	;

loption_preceded_GREATER_nonempty_list_name_tag___ :
	/*empty*/
	| GREATER nonempty_list_name_tag_
	;

loption_row_field_list_ :
	/*empty*/
	| row_field_list
	;

loption_terminated_pattern_comma_list_option_COMMA___ :
	/*empty*/
	| lseparated_nonempty_list_aux_COMMA_opt_spread_pattern__ option_COMMA_
	;

loption_type_parameters_ :
	/*empty*/
	| type_parameters
	;

list_and_class_declaration_ :
	/*empty*/
	| and_class_declaration list_and_class_declaration_
	;

list_and_class_description_ :
	/*empty*/
	| and_class_description list_and_class_description_
	;

list_and_class_type_declaration_ :
	/*empty*/
	| and_class_type_declaration list_and_class_type_declaration_
	;

list_and_let_binding_ :
	/*empty*/
	| AND let_binding_body list_and_let_binding_
	| nonempty_list_as_loc_attribute__ AND let_binding_body list_and_let_binding_
	;

list_and_module_bindings_ :
	/*empty*/
	| and_module_bindings list_and_module_bindings_
	;

list_and_module_rec_declaration_ :
	/*empty*/
	| and_module_rec_declaration list_and_module_rec_declaration_
	;

list_attributed_ext_constructor_either_extension_constructor_declaration_extension_constructor_rebind___ :
	/*empty*/
	| BAR either_extension_constructor_declaration_extension_constructor_rebind_ list_attributed_ext_constructor_either_extension_constructor_declaration_extension_constructor_rebind___
	| BAR nonempty_list_as_loc_attribute__ either_extension_constructor_declaration_extension_constructor_rebind_ list_attributed_ext_constructor_either_extension_constructor_declaration_extension_constructor_rebind___
	| nonempty_list_as_loc_attribute__ BAR either_extension_constructor_declaration_extension_constructor_rebind_ list_attributed_ext_constructor_either_extension_constructor_declaration_extension_constructor_rebind___
	| nonempty_list_as_loc_attribute__ BAR nonempty_list_as_loc_attribute__ either_extension_constructor_declaration_extension_constructor_rebind_ list_attributed_ext_constructor_either_extension_constructor_declaration_extension_constructor_rebind___
	;

list_attributed_ext_constructor_extension_constructor_declaration__ :
	/*empty*/
	| BAR extension_constructor_declaration list_attributed_ext_constructor_extension_constructor_declaration__
	| BAR nonempty_list_as_loc_attribute__ extension_constructor_declaration list_attributed_ext_constructor_extension_constructor_declaration__
	| nonempty_list_as_loc_attribute__ BAR extension_constructor_declaration list_attributed_ext_constructor_extension_constructor_declaration__
	| nonempty_list_as_loc_attribute__ BAR nonempty_list_as_loc_attribute__ extension_constructor_declaration list_attributed_ext_constructor_extension_constructor_declaration__
	;

list_bar_row_field_ :
	/*empty*/
	| bar_row_field list_bar_row_field_
	;

list_simple_expr_no_call_ :
	/*empty*/
	| simple_expr_no_call list_simple_expr_no_call_
	;

nonempty_list___anonymous_31_ :
	STRING
	| STRING nonempty_list___anonymous_31_
	;

nonempty_list_as_loc_LIDENT__ :
	LIDENT
	| LIDENT nonempty_list_as_loc_LIDENT__
	;

nonempty_list_as_loc_attribute__ :
	attribute
	| attribute nonempty_list_as_loc_attribute__
	;

nonempty_list_as_loc_preceded_QUOTE_ident___ :
	QUOTE ident
	| QUOTE ident nonempty_list_as_loc_preceded_QUOTE_ident___
	;

nonempty_list_attributed_ext_constructor_either_extension_constructor_declaration_extension_constructor_rebind___ :
	BAR either_extension_constructor_declaration_extension_constructor_rebind_
	| BAR nonempty_list_as_loc_attribute__ either_extension_constructor_declaration_extension_constructor_rebind_
	| nonempty_list_as_loc_attribute__ BAR either_extension_constructor_declaration_extension_constructor_rebind_
	| nonempty_list_as_loc_attribute__ BAR nonempty_list_as_loc_attribute__ either_extension_constructor_declaration_extension_constructor_rebind_
	| BAR either_extension_constructor_declaration_extension_constructor_rebind_ nonempty_list_attributed_ext_constructor_either_extension_constructor_declaration_extension_constructor_rebind___
	| BAR nonempty_list_as_loc_attribute__ either_extension_constructor_declaration_extension_constructor_rebind_ nonempty_list_attributed_ext_constructor_either_extension_constructor_declaration_extension_constructor_rebind___
	| nonempty_list_as_loc_attribute__ BAR either_extension_constructor_declaration_extension_constructor_rebind_ nonempty_list_attributed_ext_constructor_either_extension_constructor_declaration_extension_constructor_rebind___
	| nonempty_list_as_loc_attribute__ BAR nonempty_list_as_loc_attribute__ either_extension_constructor_declaration_extension_constructor_rebind_ nonempty_list_attributed_ext_constructor_either_extension_constructor_declaration_extension_constructor_rebind___
	;

nonempty_list_attributed_ext_constructor_extension_constructor_declaration__ :
	BAR extension_constructor_declaration
	| BAR nonempty_list_as_loc_attribute__ extension_constructor_declaration
	| nonempty_list_as_loc_attribute__ BAR extension_constructor_declaration
	| nonempty_list_as_loc_attribute__ BAR nonempty_list_as_loc_attribute__ extension_constructor_declaration
	| BAR extension_constructor_declaration nonempty_list_attributed_ext_constructor_extension_constructor_declaration__
	| BAR nonempty_list_as_loc_attribute__ extension_constructor_declaration nonempty_list_attributed_ext_constructor_extension_constructor_declaration__
	| nonempty_list_as_loc_attribute__ BAR extension_constructor_declaration nonempty_list_attributed_ext_constructor_extension_constructor_declaration__
	| nonempty_list_as_loc_attribute__ BAR nonempty_list_as_loc_attribute__ extension_constructor_declaration nonempty_list_attributed_ext_constructor_extension_constructor_declaration__
	;

nonempty_list_name_tag_ :
	BACKQUOTE ident
	| BACKQUOTE ident nonempty_list_name_tag_
	;

nonempty_list_preceded_CONSTRAINT_constrain__ :
	CONSTRAINT constrain
	| CONSTRAINT constrain nonempty_list_preceded_CONSTRAINT_constrain__
	;

separated_nonempty_list_AMPERSAND_non_arrowed_simple_core_types_ :
	non_arrowed_simple_core_types
	| non_arrowed_simple_core_types AMPERSAND separated_nonempty_list_AMPERSAND_non_arrowed_simple_core_types_
	;

implementation :
	structure //EOF
	;

//interface :
//	signature EOF
//	;

//toplevel_phrase :
//	embedded___anonymous_0_
//	;

//use_file_no_mapper :
//	embedded___anonymous_1_
//	;
//
//use_file :
//	use_file_no_mapper
//	;

//parse_core_type :
//	core_type EOF
//	;
//
//parse_expression :
//	expr EOF
//	;
//
//parse_pattern :
//	pattern EOF
//	;

module_parameter :
	LPAREN RPAREN
	| mod_ident COLON module_type
	| module_type
	;

functor_parameters :
	LPAREN RPAREN
	| LPAREN module_parameter RPAREN
	| LPAREN module_parameter COMMA RPAREN
	| LPAREN module_parameter COMMA lseparated_nonempty_list_aux_COMMA_module_parameter_ option_COMMA_ RPAREN
	;

module_complex_expr :
	module_expr
	| module_expr COLON module_type
	| VAL expr
	| VAL expr COLON option_MODULE_ package_type
	| VAL expr COLON option_MODULE_ package_type COLONGREATER option_MODULE_ package_type
	| VAL expr COLONGREATER option_MODULE_ package_type
	;

module_arguments_comma_list :
	option_COMMA_
	| lseparated_nonempty_list_aux_COMMA_module_complex_expr_ option_COMMA_
	;

module_arguments :
	module_expr_structure
	| LPAREN module_arguments_comma_list RPAREN
	;

module_expr_body :
	EQUAL module_expr
	| module_expr_structure
	;

module_expr_structure :
	LBRACE structure RBRACE
	;

module_expr :
	mod_longident
	| module_expr_structure
	| LPAREN module_complex_expr RPAREN
	| LPAREN RPAREN
	| extension
	| either_ES6_FUN_FUN_ functor_parameters option_preceded_COLON_simple_module_type__ EQUALGREATER module_expr
	| module_expr module_arguments
	| attribute module_expr %prec attribute_precedence
	;

structure :
	/*empty*/
	| structure_item
	| structure_item SEMI structure
	;

opt_LET_MODULE_ident :
	opt_LET_MODULE mod_ident
	| opt_LET_MODULE LIDENT
	;

opt_LET_MODULE_REC_ident :
	opt_LET_MODULE REC mod_ident
	| opt_LET_MODULE REC LIDENT
	;

structure_item :
	unattributed_expr
	| nonempty_list_as_loc_attribute__ unattributed_expr
	| item_extension_sugar structure_item
	| nonempty_list_as_loc_attribute__ item_extension_sugar structure_item
	| EXTERNAL val_ident COLON core_type EQUAL primitive_declaration
	| nonempty_list_as_loc_attribute__ EXTERNAL val_ident COLON core_type EQUAL primitive_declaration
	| EXTERNAL val_ident COLON core_type SEMI
	| nonempty_list_as_loc_attribute__ EXTERNAL val_ident COLON core_type SEMI
	| type_declarations
	| str_type_extension
	| str_exception_declaration
	| opt_LET_MODULE_ident module_binding_body
	| nonempty_list_as_loc_attribute__ opt_LET_MODULE_ident module_binding_body
	| opt_LET_MODULE_REC_ident module_binding_body list_and_module_bindings_
	| nonempty_list_as_loc_attribute__ opt_LET_MODULE_REC_ident module_binding_body list_and_module_bindings_
	| MODULE TYPE option_OF_ ident
	| nonempty_list_as_loc_attribute__ MODULE TYPE option_OF_ ident
	| MODULE TYPE option_OF_ ident module_type_body_EQUAL_
	| nonempty_list_as_loc_attribute__ MODULE TYPE option_OF_ ident module_type_body_EQUAL_
	| open_declaration
	| CLASS class_declaration_details list_and_class_declaration_
	| nonempty_list_as_loc_attribute__ CLASS class_declaration_details list_and_class_declaration_
	| class_type_declarations
	| INCLUDE module_expr
	| nonempty_list_as_loc_attribute__ INCLUDE module_expr
	| item_extension
	| nonempty_list_as_loc_attribute__ item_extension
	| let_bindings
	| nonempty_list_as_loc_attribute__
	;

module_binding_body :
	loption_functor_parameters_ module_expr_body
	| loption_functor_parameters_ COLON module_type module_expr_body
	;

and_module_bindings :
	AND mod_ident module_binding_body
	| nonempty_list_as_loc_attribute__ AND mod_ident module_binding_body
	;

simple_module_type :
	LPAREN module_parameter RPAREN
	| module_type_signature
	| mty_longident
	| extension
	| LPAREN MODULE TYPE OF module_expr RPAREN
	;

module_type_signature :
	LBRACE signature RBRACE
	;

module_type :
	module_type WITH lseparated_nonempty_list_aux_AND_with_constraint_
	| simple_module_type
	| attribute module_type %prec attribute_precedence
	| functor_parameters EQUALGREATER module_type %prec below_SEMI
	;

signature :
	/*empty*/
	| signature_items
	| signature_items SEMI signature
	;

signature_item :
	LET val_ident COLON core_type
	| nonempty_list_as_loc_attribute__ LET val_ident COLON core_type
	| EXTERNAL val_ident COLON core_type EQUAL primitive_declaration
	| nonempty_list_as_loc_attribute__ EXTERNAL val_ident COLON core_type EQUAL primitive_declaration
	| EXTERNAL val_ident COLON core_type SEMI
	| nonempty_list_as_loc_attribute__ EXTERNAL val_ident COLON core_type SEMI
	| type_declarations
	| type_subst_declarations
	| sig_type_extension
	| sig_exception_declaration
	| opt_LET_MODULE_ident module_declaration
	| nonempty_list_as_loc_attribute__ opt_LET_MODULE_ident module_declaration
	| opt_LET_MODULE_ident EQUAL mod_longident
	| nonempty_list_as_loc_attribute__ opt_LET_MODULE_ident EQUAL mod_longident
	| opt_LET_MODULE UIDENT COLONEQUAL mod_ext_longident
	| nonempty_list_as_loc_attribute__ opt_LET_MODULE UIDENT COLONEQUAL mod_ext_longident
	| opt_LET_MODULE_REC_ident module_type_body_COLON_ list_and_module_rec_declaration_
	| nonempty_list_as_loc_attribute__ opt_LET_MODULE_REC_ident module_type_body_COLON_ list_and_module_rec_declaration_
	| MODULE TYPE ident
	| nonempty_list_as_loc_attribute__ MODULE TYPE ident
	| MODULE TYPE ident module_type_body_EQUAL_
	| nonempty_list_as_loc_attribute__ MODULE TYPE ident module_type_body_EQUAL_
	| open_description
	| INCLUDE module_type
	| nonempty_list_as_loc_attribute__ INCLUDE module_type
	| class_descriptions
	| class_type_declarations
	| item_extension
	| nonempty_list_as_loc_attribute__ item_extension
	;

signature_items :
	signature_item
	| nonempty_list_as_loc_attribute__
	;

open_declaration :
	OPEN override_flag module_expr
	| nonempty_list_as_loc_attribute__ OPEN override_flag module_expr
	;

open_description :
	OPEN override_flag mod_longident
	| nonempty_list_as_loc_attribute__ OPEN override_flag mod_longident
	;

module_declaration :
	loption_functor_parameters_ module_type_body_COLON_
	;

module_type_body_COLON_ :
	COLON module_type
	| module_type_signature
	;

module_type_body_EQUAL_ :
	EQUAL module_type
	| module_type_signature
	;

and_module_rec_declaration :
	AND mod_ident module_type_body_COLON_
	| nonempty_list_as_loc_attribute__ AND mod_ident module_type_body_COLON_
	;

and_class_declaration :
	AND class_declaration_details
	| nonempty_list_as_loc_attribute__ AND class_declaration_details
	;

class_declaration_details :
	virtual_flag LIDENT class_declaration_body
	| virtual_flag LIDENT LPAREN RPAREN class_declaration_body
	| virtual_flag LIDENT LPAREN lseparated_nonempty_list_aux_COMMA_labeled_pattern_ option_COMMA_ RPAREN class_declaration_body
	| virtual_flag LIDENT LPAREN DOT RPAREN class_declaration_body
	| virtual_flag LIDENT LPAREN DOT lseparated_nonempty_list_aux_COMMA_labeled_pattern_ option_COMMA_ RPAREN class_declaration_body
	| virtual_flag LIDENT LPAREN lseparated_nonempty_list_aux_COMMA_type_parameter_ option_COMMA_ RPAREN class_declaration_body
	| virtual_flag LIDENT LPAREN lseparated_nonempty_list_aux_COMMA_type_parameter_ option_COMMA_ RPAREN LPAREN RPAREN class_declaration_body
	| virtual_flag LIDENT LPAREN lseparated_nonempty_list_aux_COMMA_type_parameter_ option_COMMA_ RPAREN LPAREN lseparated_nonempty_list_aux_COMMA_labeled_pattern_ option_COMMA_ RPAREN class_declaration_body
	| virtual_flag LIDENT LPAREN lseparated_nonempty_list_aux_COMMA_type_parameter_ option_COMMA_ RPAREN LPAREN DOT RPAREN class_declaration_body
	| virtual_flag LIDENT LPAREN lseparated_nonempty_list_aux_COMMA_type_parameter_ option_COMMA_ RPAREN LPAREN DOT lseparated_nonempty_list_aux_COMMA_labeled_pattern_ option_COMMA_ RPAREN class_declaration_body
	;

class_declaration_body :
	option_preceded_COLON_class_constructor_type__ either_preceded_EQUAL_class_expr__class_body_expr_
	;

class_expr_lets_and_rest :
	class_expr
	| let_bindings SEMI class_expr_lets_and_rest
	| object_body
	| option_LET_ OPEN override_flag mod_longident SEMI class_expr_lets_and_rest
	;

object_body_class_fields :
	option_SEMI_
	| lseparated_nonempty_list_aux_SEMI_class_field_ option_SEMI_
	;

object_body :
	loption_located_attributes_ class_self_expr
	| loption_located_attributes_ class_self_expr SEMI object_body_class_fields
	| object_body_class_fields
	;

class_self_expr :
	AS pattern
	;

class_expr :
	class_simple_expr
	| either_ES6_FUN_FUN_ LPAREN RPAREN EQUALGREATER class_expr
	| either_ES6_FUN_FUN_ LPAREN lseparated_nonempty_list_aux_COMMA_labeled_pattern_ option_COMMA_ RPAREN EQUALGREATER class_expr
	| either_ES6_FUN_FUN_ LPAREN DOT RPAREN EQUALGREATER class_expr
	| either_ES6_FUN_FUN_ LPAREN DOT lseparated_nonempty_list_aux_COMMA_labeled_pattern_ option_COMMA_ RPAREN EQUALGREATER class_expr
	| class_simple_expr labeled_arguments
	| attribute class_expr
	| CLASS class_longident loption_type_parameters_
	| extension
	;

class_simple_expr :
	class_longident
	| LBRACE class_expr_lets_and_rest RBRACE
	| LPAREN class_expr COLON class_constructor_type RPAREN
	| LPAREN class_expr RPAREN
	;

class_field :
	INHERIT override_flag class_expr option_as_loc_preceded_AS_LIDENT___
	| nonempty_list_as_loc_attribute__ INHERIT override_flag class_expr option_as_loc_preceded_AS_LIDENT___
	| VAL value
	| nonempty_list_as_loc_attribute__ VAL value
	| either___anonymous_11___anonymous_12_ method_
	| nonempty_list_as_loc_attribute__ either___anonymous_11___anonymous_12_ method_
	| CONSTRAINT constrain_field
	| nonempty_list_as_loc_attribute__ CONSTRAINT constrain_field
	| INITIALIZER simple_expr_call
	| nonempty_list_as_loc_attribute__ INITIALIZER simple_expr_call
	| item_extension
	| nonempty_list_as_loc_attribute__ item_extension
	| nonempty_list_as_loc_attribute__
	;

value :
	override_flag MUTABLE VIRTUAL LIDENT COLON core_type
	| override_flag MUTABLE VIRTUAL LIDENT type_constraint EQUAL expr
	| VIRTUAL mutable_flag LIDENT COLON core_type
	| VIRTUAL mutable_flag LIDENT type_constraint EQUAL expr
	| override_flag mutable_flag LIDENT EQUAL expr
	| override_flag mutable_flag LIDENT type_constraint EQUAL expr
	;

method_ :
	override_flag VIRTUAL LIDENT COLON poly_type
	| override_flag LIDENT fun_def_EQUAL_core_type_
	| override_flag LIDENT option_preceded_COLON_poly_type__ either_preceded_EQUAL_expr__braced_expr_
	| override_flag LIDENT COLON TYPE nonempty_list_as_loc_LIDENT__ DOT core_type either_preceded_EQUAL_expr__braced_expr_
	;

class_constructor_type :
	class_instance_type
	| arrow_type_parameters EQUALGREATER class_constructor_type
	;

class_type_arguments_comma_list :
	lseparated_nonempty_list_aux_COMMA_core_type_ option_COMMA_
	;

class_instance_type :
	clty_longident loption_parenthesized_class_type_arguments_comma_list__
	| attribute class_instance_type
	| class_type_body
	| extension
	;

class_type_body :
	LBRACE class_sig_body_cty RBRACE
	| LBRACE DOT class_sig_body_cty RBRACE
	;

class_sig_body_fields :
	option_SEMI_
	| lseparated_nonempty_list_aux_SEMI_class_sig_field_ option_SEMI_
	;

class_sig_body_cty :
	class_sig_body
	| option_LET_ OPEN override_flag mod_longident SEMI class_sig_body_cty
	;

class_sig_body :
	class_self_type
	| class_self_type SEMI class_sig_body_fields
	| class_sig_body_fields
	;

class_self_type :
	AS core_type
	;

class_sig_field :
	INHERIT class_instance_type
	| nonempty_list_as_loc_attribute__ INHERIT class_instance_type
	| VAL value_type
	| nonempty_list_as_loc_attribute__ VAL value_type
	| PRI virtual_flag LIDENT COLON poly_type
	| nonempty_list_as_loc_attribute__ PRI virtual_flag LIDENT COLON poly_type
	| PUB virtual_flag LIDENT COLON poly_type
	| nonempty_list_as_loc_attribute__ PUB virtual_flag LIDENT COLON poly_type
	| CONSTRAINT constrain_field
	| nonempty_list_as_loc_attribute__ CONSTRAINT constrain_field
	| item_extension
	| nonempty_list_as_loc_attribute__ item_extension
	| nonempty_list_as_loc_attribute__
	;

value_type :
	mutable_or_virtual_flags LIDENT COLON core_type
	;

constrain :
	core_type EQUAL core_type
	;

constrain_field :
	core_type EQUAL core_type
	;

class_descriptions :
	CLASS class_description_details list_and_class_description_
	| nonempty_list_as_loc_attribute__ CLASS class_description_details list_and_class_description_
	;

and_class_description :
	AND class_description_details
	| nonempty_list_as_loc_attribute__ AND class_description_details
	;

class_description_details :
	virtual_flag LIDENT loption_class_type_parameters_ COLON class_constructor_type
	;

class_type_declarations :
	CLASS TYPE class_type_declaration_details list_and_class_type_declaration_
	| nonempty_list_as_loc_attribute__ CLASS TYPE class_type_declaration_details list_and_class_type_declaration_
	;

and_class_type_declaration :
	AND class_type_declaration_details
	| nonempty_list_as_loc_attribute__ AND class_type_declaration_details
	;

class_type_declaration_details :
	virtual_flag LIDENT loption_class_type_parameters_ either_preceded_EQUAL_class_instance_type__class_type_body_
	;

braced_expr :
	LBRACE seq_expr RBRACE
	| LBRACE DOTDOTDOT expr_optional_constraint option_COMMA_ RBRACE
	| LBRACE DOTDOTDOT expr_optional_constraint SEMI RBRACE
	| LBRACE record_expr RBRACE
	| LBRACE record_expr_with_string_keys RBRACE
	| LBRACE object_body RBRACE
	;

seq_expr_no_seq :
	expr option_SEMI_
	| opt_LET_MODULE_ident module_binding_body SEMI seq_expr
	| option_LET_ OPEN override_flag mod_longident SEMI seq_expr
	| nonempty_list_as_loc_attribute__ option_LET_ OPEN override_flag mod_longident SEMI seq_expr
	| str_exception_declaration SEMI seq_expr
	| let_bindings SEMI seq_expr
	| let_bindings option_SEMI_
	| LETOP letop_bindings SEMI seq_expr
	;

seq_expr :
	seq_expr_no_seq
	| item_extension_sugar seq_expr_no_seq
	| expr SEMI seq_expr
	| item_extension_sugar expr SEMI seq_expr
	;

labeled_pattern_constraint :
	AS pattern_optional_constraint
	| option_preceded_COLON_core_type__
	;

labeled_pattern :
	TILDE LIDENT labeled_pattern_constraint
	| TILDE LIDENT labeled_pattern_constraint EQUAL expr
	| TILDE LIDENT labeled_pattern_constraint EQUAL QUESTION
	| pattern_optional_constraint
	| TYPE LIDENT
	;

es6_parameters :
	LPAREN RPAREN
	| LPAREN lseparated_nonempty_list_aux_COMMA_labeled_pattern_ option_COMMA_ RPAREN
	| LPAREN DOT RPAREN
	| LPAREN DOT lseparated_nonempty_list_aux_COMMA_labeled_pattern_ option_COMMA_ RPAREN
	| UNDERSCORE
	| simple_pattern_ident
	;

jsx_arguments :
	/*empty*/
	| LIDENT EQUAL QUESTION simple_expr_call jsx_arguments
	| QUESTION LIDENT jsx_arguments
	| LIDENT EQUAL simple_expr_call jsx_arguments
	| LIDENT jsx_arguments
	| INFIXOP3
	;

jsx_start_tag_and_args :
	LESSIDENT jsx_arguments
	| LESS LIDENT jsx_arguments
	| LESS mod_ext_longident jsx_arguments
	| mod_ext_lesslongident jsx_arguments
	;

jsx_start_tag_and_args_without_leading_less :
	mod_ext_longident jsx_arguments
	| LIDENT jsx_arguments
	;

greater_spread :
	GREATERDOTDOTDOT
	| GREATER DOTDOTDOT
	;

jsx :
	LESSGREATER list_simple_expr_no_call_ LESSSLASHGREATER
	| jsx_start_tag_and_args SLASHGREATER
	| jsx_start_tag_and_args GREATER list_simple_expr_no_call_ LESSSLASHIDENTGREATER
	| jsx_start_tag_and_args greater_spread simple_expr_no_call LESSSLASHIDENTGREATER
	;

jsx_without_leading_less :
	GREATER list_simple_expr_no_call_ LESSSLASHGREATER
	| jsx_start_tag_and_args_without_leading_less SLASHGREATER
	| jsx_start_tag_and_args_without_leading_less GREATER list_simple_expr_no_call_ LESSSLASHIDENTGREATER
	| jsx_start_tag_and_args_without_leading_less greater_spread simple_expr_no_call LESSSLASHIDENTGREATER
	;

optional_expr_extension :
	/*empty*/
	| item_extension_sugar
	;

expr :
	simple_expr_call
	| FUN optional_expr_extension fun_def_EQUALGREATER_non_arrowed_core_type_
	| ES6_FUN es6_parameters EQUALGREATER expr
	| ES6_FUN es6_parameters COLON non_arrowed_core_type EQUALGREATER expr
	| FUN optional_expr_extension match_case_expr_ llist_aux_match_case_expr__ %prec below_BAR
	| SWITCH optional_expr_extension simple_expr_no_constructor LBRACE match_case_seq_expr_ llist_aux_match_case_seq_expr__ RBRACE
	| TRY optional_expr_extension simple_expr_no_constructor LBRACE match_case_seq_expr_ llist_aux_match_case_seq_expr__ RBRACE
	| IF optional_expr_extension parenthesized_expr simple_expr_call
	| IF optional_expr_extension parenthesized_expr simple_expr_call ELSE expr
	| WHILE optional_expr_extension parenthesized_expr simple_expr_call
	| FOR optional_expr_extension LPAREN pattern IN expr direction_flag expr RPAREN simple_expr_call
	| LPAREN COLONCOLON RPAREN LPAREN expr COMMA expr RPAREN
	| expr EQUALGREATER expr //DAD
	| expr GREATER expr
	| expr INFIXOP0 expr
	| expr INFIXOP1 expr
	| expr INFIXOP2 expr
	| expr INFIXOP3 expr
	| expr SLASHGREATER expr
	| expr INFIXOP4 expr
	| expr PLUS expr
	| expr PLUSDOT expr
	| expr MINUS expr
	| expr MINUSDOT expr
	| expr STAR expr
	| expr LESS expr
	| expr OR expr
	| expr BARBAR expr
	| expr AMPERSAND expr
	| expr AMPERAMPER expr
	| expr COLONEQUAL expr
	| expr PLUSEQ expr
	| expr PERCENT expr
	| expr GREATERDOTDOTDOT expr
	| expr LESSDOTDOTGREATER expr
	| expr GREATER GREATER expr
	| MINUS expr %prec prec_unary
	| MINUSDOT expr %prec prec_unary
	| PLUS expr %prec prec_unary
	| PLUSDOT expr %prec prec_unary
	| BANG expr %prec prec_unary
	| simple_expr_call DOT label_longident EQUAL expr
	| simple_expr_call LBRACKET expr RBRACKET EQUAL expr
	| simple_expr_call DOT LBRACKET expr RBRACKET EQUAL expr
	| simple_expr_call DOT LBRACE lseparated_nonempty_list_aux_COMMA_expr_ option_COMMA_ RBRACE EQUAL expr
	| LIDENT EQUAL expr
	| ASSERT simple_expr_call
	| LAZY simple_expr_call
	| expr QUESTION expr COLON expr
	| attribute expr %prec attribute_precedence
	;

unattributed_expr :
	simple_expr_call
	| FUN optional_expr_extension fun_def_EQUALGREATER_non_arrowed_core_type_
	| ES6_FUN es6_parameters EQUALGREATER expr
	| ES6_FUN es6_parameters COLON non_arrowed_core_type EQUALGREATER expr
	| FUN optional_expr_extension match_case_expr_ llist_aux_match_case_expr__ %prec below_BAR
	| SWITCH optional_expr_extension simple_expr_no_constructor LBRACE match_case_seq_expr_ llist_aux_match_case_seq_expr__ RBRACE
	| TRY optional_expr_extension simple_expr_no_constructor LBRACE match_case_seq_expr_ llist_aux_match_case_seq_expr__ RBRACE
	| IF optional_expr_extension parenthesized_expr simple_expr_call
	| IF optional_expr_extension parenthesized_expr simple_expr_call ELSE expr
	| WHILE optional_expr_extension parenthesized_expr simple_expr_call
	| FOR optional_expr_extension LPAREN pattern IN expr direction_flag expr RPAREN simple_expr_call
	| LPAREN COLONCOLON RPAREN LPAREN expr COMMA expr RPAREN
	| unattributed_expr GREATER expr
	| unattributed_expr INFIXOP0 expr
	| unattributed_expr INFIXOP1 expr
	| unattributed_expr INFIXOP2 expr
	| unattributed_expr INFIXOP3 expr
	| unattributed_expr SLASHGREATER expr
	| unattributed_expr INFIXOP4 expr
	| unattributed_expr PLUS expr
	| unattributed_expr PLUSDOT expr
	| unattributed_expr MINUS expr
	| unattributed_expr MINUSDOT expr
	| unattributed_expr STAR expr
	| unattributed_expr LESS expr
	| unattributed_expr OR expr
	| unattributed_expr BARBAR expr
	| unattributed_expr AMPERSAND expr
	| unattributed_expr AMPERAMPER expr
	| unattributed_expr COLONEQUAL expr
	| unattributed_expr PLUSEQ expr
	| unattributed_expr PERCENT expr
	| unattributed_expr GREATERDOTDOTDOT expr
	| unattributed_expr LESSDOTDOTGREATER expr
	| unattributed_expr GREATER GREATER expr
	| MINUS expr %prec prec_unary
	| MINUSDOT expr %prec prec_unary
	| PLUS expr %prec prec_unary
	| PLUSDOT expr %prec prec_unary
	| BANG expr %prec prec_unary
	| simple_expr_call DOT label_longident EQUAL expr
	| simple_expr_call LBRACKET expr RBRACKET EQUAL expr
	| simple_expr_call DOT LBRACKET expr RBRACKET EQUAL expr
	| simple_expr_call DOT LBRACE lseparated_nonempty_list_aux_COMMA_expr_ option_COMMA_ RBRACE EQUAL expr
	| LIDENT EQUAL expr
	| ASSERT simple_expr_call
	| LAZY simple_expr_call
	| unattributed_expr QUESTION expr COLON expr
	;

parenthesized_expr :
	braced_expr
	| LPAREN DOT RPAREN
	| LPAREN expr_list RPAREN
	;

simple_expr_no_constructor :
	val_longident
	| constant
	| jsx
	| simple_expr_direct_argument
	| LBRACKETBAR option_COMMA_ BARRBRACKET
	| LBRACKETBAR lseparated_nonempty_list_aux_COMMA_opt_spread_expr_optional_constraint__ option_COMMA_ BARRBRACKET
	| constr_longident %prec prec_constant_constructor
	| BACKQUOTE ident %prec prec_constant_constructor
	| LPAREN expr_list RPAREN
	| simple_expr_no_constructor POSTFIXOP
	| mod_longident DOT LPAREN expr_list RPAREN
	| simple_expr_no_constructor DOT label_longident
	| mod_longident DOT LBRACE RBRACE
	| simple_expr_no_constructor LBRACKET expr RBRACKET
	| simple_expr_no_constructor DOT LBRACKET expr RBRACKET
	| simple_expr_no_constructor DOT LBRACE lseparated_nonempty_list_aux_COMMA_expr_ option_COMMA_ RBRACE
	| mod_longident DOT LBRACE record_expr RBRACE
	| mod_longident DOT LBRACE record_expr_with_string_keys RBRACE
	| mod_longident DOT LBRACKETBAR expr_list BARRBRACKET
	| mod_longident DOT LBRACKETLESS jsx_without_leading_less RBRACKET
	| mod_longident DOT LBRACKET RBRACKET
	| mod_longident DOT LBRACKET expr_comma_seq_extension RBRACKET
	| PREFIXOP simple_expr_no_constructor %prec below_DOT_AND_SHARP
	| NEW class_longident
	| mod_longident DOT LBRACELESS lseparated_nonempty_list_aux_COMMA_field_expr_ option_COMMA_ GREATERRBRACE
	| simple_expr_no_constructor SHARP LIDENT
	| simple_expr_no_constructor SHARPOP simple_expr_no_call
	| simple_expr_no_constructor SHARPEQUAL simple_expr_call
	| simple_expr_no_constructor MINUSGREATER simple_expr_no_call
	| mod_longident DOT LPAREN MODULE module_expr COLON package_type RPAREN
	| extension
	;

simple_expr_template_constructor :
	constr_longident non_labeled_argument_list
	| constr_longident simple_expr_direct_argument
	| BACKQUOTE ident non_labeled_argument_list
	| BACKQUOTE ident simple_expr_direct_argument
	;

simple_expr_no_call :
	val_longident
	| constant
	| jsx
	| simple_expr_direct_argument
	| LBRACKETBAR option_COMMA_ BARRBRACKET
	| LBRACKETBAR lseparated_nonempty_list_aux_COMMA_opt_spread_expr_optional_constraint__ option_COMMA_ BARRBRACKET
	| constr_longident %prec prec_constant_constructor
	| BACKQUOTE ident %prec prec_constant_constructor
	| LPAREN expr_list RPAREN
	| simple_expr_no_call POSTFIXOP
	| mod_longident DOT LPAREN expr_list RPAREN
	| simple_expr_no_call DOT label_longident
	| mod_longident DOT LBRACE RBRACE
	| simple_expr_no_call LBRACKET expr RBRACKET
	| simple_expr_no_call DOT LBRACKET expr RBRACKET
	| simple_expr_no_call DOT LBRACE lseparated_nonempty_list_aux_COMMA_expr_ option_COMMA_ RBRACE
	| mod_longident DOT LBRACE record_expr RBRACE
	| mod_longident DOT LBRACE record_expr_with_string_keys RBRACE
	| mod_longident DOT LBRACKETBAR expr_list BARRBRACKET
	| mod_longident DOT LBRACKETLESS jsx_without_leading_less RBRACKET
	| mod_longident DOT LBRACKET RBRACKET
	| mod_longident DOT LBRACKET expr_comma_seq_extension RBRACKET
	| PREFIXOP simple_expr_no_call %prec below_DOT_AND_SHARP
	| NEW class_longident
	| mod_longident DOT LBRACELESS lseparated_nonempty_list_aux_COMMA_field_expr_ option_COMMA_ GREATERRBRACE
	| simple_expr_no_call SHARP LIDENT
	| simple_expr_no_call SHARPOP simple_expr_no_call
	| simple_expr_no_call SHARPEQUAL simple_expr_call
	| simple_expr_no_call MINUSGREATER simple_expr_no_call
	| mod_longident DOT LPAREN MODULE module_expr COLON package_type RPAREN
	| extension
	| simple_expr_template_constructor
	;

simple_expr_call :
	val_longident
	| constant
	| jsx
	| simple_expr_direct_argument
	| LBRACKETBAR option_COMMA_ BARRBRACKET
	| LBRACKETBAR lseparated_nonempty_list_aux_COMMA_opt_spread_expr_optional_constraint__ option_COMMA_ BARRBRACKET
	| constr_longident %prec prec_constant_constructor
	| BACKQUOTE ident %prec prec_constant_constructor
	| LPAREN expr_list RPAREN
	| simple_expr_call POSTFIXOP
	| mod_longident DOT LPAREN expr_list RPAREN
	| simple_expr_call DOT label_longident
	| mod_longident DOT LBRACE RBRACE
	| simple_expr_call LBRACKET expr RBRACKET
	| simple_expr_call DOT LBRACKET expr RBRACKET
	| simple_expr_call DOT LBRACE lseparated_nonempty_list_aux_COMMA_expr_ option_COMMA_ RBRACE
	| mod_longident DOT LBRACE record_expr RBRACE
	| mod_longident DOT LBRACE record_expr_with_string_keys RBRACE
	| mod_longident DOT LBRACKETBAR expr_list BARRBRACKET
	| mod_longident DOT LBRACKETLESS jsx_without_leading_less RBRACKET
	| mod_longident DOT LBRACKET RBRACKET
	| mod_longident DOT LBRACKET expr_comma_seq_extension RBRACKET
	| PREFIXOP simple_expr_call %prec below_DOT_AND_SHARP
	| NEW class_longident
	| mod_longident DOT LBRACELESS lseparated_nonempty_list_aux_COMMA_field_expr_ option_COMMA_ GREATERRBRACE
	| simple_expr_call SHARP LIDENT
	| simple_expr_call SHARPOP simple_expr_no_call
	| simple_expr_call SHARPEQUAL simple_expr_call
	| simple_expr_call MINUSGREATER simple_expr_no_call
	| mod_longident DOT LPAREN MODULE module_expr COLON package_type RPAREN
	| extension
	| simple_expr_call labeled_arguments
	| LBRACKET expr_comma_seq_extension RBRACKET
	| simple_expr_template_constructor
	;

simple_expr_direct_argument :
	braced_expr
	| LBRACKETLESS jsx_without_leading_less COMMA expr_comma_seq_extension RBRACKET
	| LBRACKETLESS jsx_without_leading_less RBRACKET
	| LBRACKETLESS jsx_without_leading_less COMMA RBRACKET
	| LBRACELESS lseparated_nonempty_list_aux_COMMA_field_expr_ option_COMMA_ GREATERRBRACE
	| LBRACELESS GREATERRBRACE
	| LPAREN MODULE module_expr RPAREN
	| LPAREN MODULE module_expr COLON package_type RPAREN
	;

non_labeled_argument_list :
	LPAREN lseparated_nonempty_list_aux_COMMA_expr_optional_constraint_ option_COMMA_ RPAREN
	| LPAREN RPAREN
	;

labeled_arguments :
	simple_expr_direct_argument
	| LPAREN option_COMMA_ RPAREN
	| LPAREN lseparated_nonempty_list_aux_COMMA_uncurried_labeled_expr_ option_COMMA_ RPAREN
	| LPAREN DOT RPAREN
	;

labeled_expr_constraint :
	expr_optional_constraint
	| type_constraint
	;

longident_type_constraint :
	val_longident option_type_constraint_
	;

labeled_expr :
	expr_optional_constraint
	| TILDE either_parenthesized_longident_type_constraint__longident_type_constraint_
	| TILDE val_longident QUESTION
	| TILDE LIDENT EQUAL optional labeled_expr_constraint
	| TILDE LIDENT EQUAL optional UNDERSCORE
	| UNDERSCORE
	;

let_bindings :
	let_binding list_and_let_binding_
	;

let_binding :
	LET option_item_extension_sugar_ rec_flag let_binding_body
	| nonempty_list_as_loc_attribute__ LET option_item_extension_sugar_ rec_flag let_binding_body
	;

let_binding_body :
	simple_pattern_ident type_constraint EQUAL expr
	| simple_pattern_ident fun_def_EQUAL_core_type_
	| simple_pattern_ident COLON nonempty_list_as_loc_preceded_QUOTE_ident___ DOT core_type EQUAL expr
	| simple_pattern_ident COLON TYPE nonempty_list_as_loc_LIDENT__ DOT core_type EQUAL expr
	| pattern EQUAL expr
	| simple_pattern_not_ident COLON core_type EQUAL expr
	;

letop_binding_body :
	simple_pattern_ident expr
	| simple_pattern COLON core_type EQUAL expr
	| pattern EQUAL expr
	;

letop_bindings :
	letop_binding_body
	| letop_bindings ANDOP let_binding_body
	;

match_case_expr_ :
	BAR pattern option_preceded_WHEN_expr__ EQUALGREATER expr
	;

match_case_seq_expr_ :
	BAR pattern option_preceded_WHEN_expr__ EQUALGREATER seq_expr
	;

fun_def_EQUAL_core_type_ :
	LPAREN RPAREN option_preceded_COLON_core_type__ either_preceded_EQUAL_expr__braced_expr_
	| LPAREN lseparated_nonempty_list_aux_COMMA_labeled_pattern_ option_COMMA_ RPAREN option_preceded_COLON_core_type__ either_preceded_EQUAL_expr__braced_expr_
	| LPAREN DOT RPAREN option_preceded_COLON_core_type__ either_preceded_EQUAL_expr__braced_expr_
	| LPAREN DOT lseparated_nonempty_list_aux_COMMA_labeled_pattern_ option_COMMA_ RPAREN option_preceded_COLON_core_type__ either_preceded_EQUAL_expr__braced_expr_
	;

fun_def_EQUALGREATER_non_arrowed_core_type_ :
	LPAREN RPAREN option_preceded_COLON_non_arrowed_core_type__ either_preceded_EQUALGREATER_expr__braced_expr_
	| LPAREN lseparated_nonempty_list_aux_COMMA_labeled_pattern_ option_COMMA_ RPAREN option_preceded_COLON_non_arrowed_core_type__ either_preceded_EQUALGREATER_expr__braced_expr_
	| LPAREN DOT RPAREN option_preceded_COLON_non_arrowed_core_type__ either_preceded_EQUALGREATER_expr__braced_expr_
	| LPAREN DOT lseparated_nonempty_list_aux_COMMA_labeled_pattern_ option_COMMA_ RPAREN option_preceded_COLON_non_arrowed_core_type__ either_preceded_EQUALGREATER_expr__braced_expr_
	;

expr_list :
	lseparated_nonempty_list_aux_COMMA_expr_optional_constraint_ option_COMMA_
	;

expr_comma_seq_extension :
	lseparated_nonempty_list_aux_COMMA_opt_spread_expr_optional_constraint__ option_COMMA_
	;

expr_optional_constraint :
	expr
	| expr type_constraint
	;

record_expr :
	DOTDOTDOT expr_optional_constraint COMMA option_DOTDOTDOT_ label_longident COLON expr llist_aux_preceded_COMMA_opt_spread_lbl_expr___ option_COMMA_
	| DOTDOTDOT expr_optional_constraint COMMA option_DOTDOTDOT_ label_longident llist_aux_preceded_COMMA_opt_spread_lbl_expr___ option_COMMA_
	| DOTDOTDOT expr_optional_constraint SEMI lseparated_nonempty_list_aux_COMMA_opt_spread_lbl_expr__ option_COMMA_
	| DOTDOTDOT expr_optional_constraint COMMA option_DOTDOTDOT_ label_longident COLON expr llist_aux_preceded_COMMA_opt_spread_lbl_expr___ SEMI
	| DOTDOTDOT expr_optional_constraint COMMA option_DOTDOTDOT_ label_longident llist_aux_preceded_COMMA_opt_spread_lbl_expr___ SEMI
	| label_longident COLON expr option_COMMA_
	| label_longident COLON expr SEMI
	| label_longident COLON expr COMMA option_DOTDOTDOT_ label_longident COLON expr llist_aux_preceded_COMMA_opt_spread_lbl_expr___ option_COMMA_
	| label_longident COLON expr COMMA option_DOTDOTDOT_ label_longident llist_aux_preceded_COMMA_opt_spread_lbl_expr___ option_COMMA_
	| label_longident COMMA option_DOTDOTDOT_ label_longident COLON expr llist_aux_preceded_COMMA_opt_spread_lbl_expr___ option_COMMA_
	| label_longident COMMA option_DOTDOTDOT_ label_longident llist_aux_preceded_COMMA_opt_spread_lbl_expr___ option_COMMA_
	| label_longident COLON expr COMMA option_DOTDOTDOT_ label_longident COLON expr llist_aux_preceded_COMMA_opt_spread_lbl_expr___ SEMI
	| label_longident COLON expr COMMA option_DOTDOTDOT_ label_longident llist_aux_preceded_COMMA_opt_spread_lbl_expr___ SEMI
	| label_longident COMMA option_DOTDOTDOT_ label_longident COLON expr llist_aux_preceded_COMMA_opt_spread_lbl_expr___ SEMI
	| label_longident COMMA option_DOTDOTDOT_ label_longident llist_aux_preceded_COMMA_opt_spread_lbl_expr___ SEMI
	;

record_expr_with_string_keys :
	DOTDOTDOT expr_optional_constraint COMMA string_literal_exprs_maybe_punned
	| STRING COLON expr option_COMMA_
	| string_literal_expr_maybe_punned_with_comma string_literal_exprs_maybe_punned
	;

string_literal_exprs_maybe_punned :
	lseparated_nonempty_list_aux_COMMA_string_literal_expr_maybe_punned_ option_COMMA_
	;

string_literal_expr_maybe_punned_with_comma :
	STRING COMMA
	| STRING COLON expr COMMA
	;

string_literal_expr_maybe_punned :
	STRING option_preceded_COLON_expr__
	;

field_expr :
	LIDENT COLON expr
	| LIDENT
	;

type_constraint :
	COLON core_type option_preceded_COLONGREATER_core_type__
	| COLONGREATER core_type
	| COLON MODULE package_type
	;

pattern :
	pattern_without_or
	| pattern BAR pattern
	;

pattern_constructor_argument :
	simple_pattern_direct_argument
	| LPAREN lseparated_nonempty_list_aux_COMMA_pattern_optional_constraint_ option_COMMA_ RPAREN
	;

simple_pattern_direct_argument :
	constr_longident
	| LBRACE _lbl_pattern_list RBRACE
	| LBRACKET pattern_comma_list_extension RBRACKET
	| LBRACKETBAR loption_terminated_pattern_comma_list_option_COMMA___ BARRBRACKET
	;

pattern_without_or :
	simple_pattern
	| pattern_without_or AS val_ident
	| constr_longident pattern_constructor_argument
	| BACKQUOTE ident simple_pattern
	| pattern_without_or COLONCOLON pattern_without_or
	| LPAREN COLONCOLON RPAREN LPAREN pattern_without_or COMMA pattern_without_or RPAREN
	| EXCEPTION pattern_without_or %prec prec_constr_appl
	| LAZY simple_pattern
	| attribute pattern_without_or %prec attribute_precedence
	;

simple_pattern :
	simple_pattern_ident
	| simple_pattern_not_ident
	;

simple_pattern_ident :
	val_ident
	;

simple_pattern_not_ident :
	UNDERSCORE
	| signed_constant
	| signed_constant DOTDOT signed_constant
	| signed_constant DOT signed_constant
	| constr_longident
	| BACKQUOTE ident
	| SHARP type_longident
	| LPAREN lseparated_nonempty_list_aux_COMMA_pattern_optional_constraint_ option_COMMA_ RPAREN
	| LPAREN MODULE mod_ident RPAREN
	| simple_pattern_not_ident_
	| extension
	;

simple_pattern_not_ident_ :
	LBRACE _lbl_pattern_list RBRACE
	| LBRACKET pattern_comma_list_extension RBRACKET
	| LBRACKETBAR loption_terminated_pattern_comma_list_option_COMMA___ BARRBRACKET
	| mod_longident DOT LBRACE _lbl_pattern_list RBRACE
	| mod_longident DOT LBRACKET pattern_comma_list_extension RBRACKET
	| mod_longident DOT LBRACKETBAR loption_terminated_pattern_comma_list_option_COMMA___ BARRBRACKET
	| mod_longident DOT LPAREN pattern RPAREN
	| mod_longident DOT LBRACKET RBRACKET
	| mod_longident DOT LPAREN RPAREN
	;

pattern_optional_constraint :
	pattern
	| pattern COLON core_type
	| MODULE mod_ident COLON option_MODULE_ package_type
	;

pattern_comma_list_extension :
	lseparated_nonempty_list_aux_COMMA_opt_spread_pattern__ option_COMMA_
	;

_lbl_pattern_list :
	option_DOTDOTDOT_ lbl_pattern
	| option_DOTDOTDOT_ lbl_pattern COMMA
	| option_DOTDOTDOT_ lbl_pattern COMMA UNDERSCORE option_COMMA_
	| option_DOTDOTDOT_ lbl_pattern COMMA _lbl_pattern_list
	;

lbl_pattern :
	label_longident COLON pattern
	| label_longident
	| label_longident AS val_ident
	;

primitive_declaration :
	nonempty_list___anonymous_31_
	;

type_declarations :
	TYPE nonrec_flag type_declaration_details
	| nonempty_list_as_loc_attribute__ TYPE nonrec_flag type_declaration_details
	;

and_type_declaration :
	/*empty*/
	| AND type_declaration_details
	| nonempty_list_as_loc_attribute__ AND type_declaration_details
	;

type_declaration_details :
	UIDENT type_variables_with_variance type_declaration_kind
	| LIDENT type_variables_with_variance type_declaration_kind
	;

type_declaration_kind :
	EQUAL constructor_declarations
	| EQUAL PRI constructor_declarations
	| EQUAL core_type EQUAL constructor_declarations
	| EQUAL core_type EQUAL PRI constructor_declarations
	| type_other_kind and_type_declaration
	| type_other_kind nonempty_list_preceded_CONSTRAINT_constrain__ and_type_declaration
	;

type_subst_kind :
	COLONEQUAL type_subst_constructor_declarations
	| COLONEQUAL PRI type_subst_constructor_declarations
	| COLONEQUAL core_type EQUAL type_subst_constructor_declarations
	| COLONEQUAL core_type EQUAL PRI type_subst_constructor_declarations
	| type_subst_other_kind and_type_subst_declaration
	| type_subst_other_kind nonempty_list_preceded_CONSTRAINT_constrain__ and_type_subst_declaration
	;

type_subst_declarations :
	TYPE nonrec_flag LIDENT type_variables_with_variance type_subst_kind
	| nonempty_list_as_loc_attribute__ TYPE nonrec_flag LIDENT type_variables_with_variance type_subst_kind
	;

and_type_subst_declaration :
	/*empty*/
	| AND LIDENT type_variables_with_variance type_subst_kind
	| nonempty_list_as_loc_attribute__ AND LIDENT type_variables_with_variance type_subst_kind
	;

type_subst_other_kind :
	COLONEQUAL core_type
	| COLONEQUAL PRI core_type
	| COLONEQUAL record_declaration
	| COLONEQUAL nonempty_list_as_loc_attribute__ record_declaration
	| COLONEQUAL PRI record_declaration
	| COLONEQUAL PRI nonempty_list_as_loc_attribute__ record_declaration
	| COLONEQUAL DOTDOT
	| COLONEQUAL PRI DOTDOT
	| COLONEQUAL core_type EQUAL DOTDOT
	| COLONEQUAL core_type EQUAL record_declaration
	| COLONEQUAL core_type EQUAL nonempty_list_as_loc_attribute__ record_declaration
	| COLONEQUAL core_type EQUAL PRI record_declaration
	| COLONEQUAL core_type EQUAL PRI nonempty_list_as_loc_attribute__ record_declaration
	;

type_other_kind :
	/*empty*/
	| EQUAL core_type
	| EQUAL PRI core_type
	| EQUAL record_declaration
	| EQUAL nonempty_list_as_loc_attribute__ record_declaration
	| EQUAL PRI record_declaration
	| EQUAL PRI nonempty_list_as_loc_attribute__ record_declaration
	| EQUAL DOTDOT
	| EQUAL PRI DOTDOT
	| EQUAL core_type EQUAL DOTDOT
	| EQUAL core_type EQUAL record_declaration
	| EQUAL core_type EQUAL nonempty_list_as_loc_attribute__ record_declaration
	| EQUAL core_type EQUAL PRI record_declaration
	| EQUAL core_type EQUAL PRI nonempty_list_as_loc_attribute__ record_declaration
	;

type_variables_with_variance_comma_list :
	lseparated_nonempty_list_aux_COMMA_type_variable_with_variance_ option_COMMA_
	;

type_variables_with_variance :
	loption_parenthesized_type_variables_with_variance_comma_list__
	| LESS type_variables_with_variance_comma_list GREATER
	;

type_variable_with_variance :
	embedded___anonymous_32_
	;

type_parameter :
	type_variance type_variable
	;

type_variance :
	/*empty*/
	| PLUS
	| MINUS
	;

type_variable :
	QUOTE ident
	;

constructor_declarations :
	BAR and_type_declaration
	| either_constructor_declaration_bar_constructor_declaration_ constructor_declarations_aux
	;

constructor_declarations_aux :
	bar_constructor_declaration constructor_declarations_aux
	| and_type_declaration
	| nonempty_list_preceded_CONSTRAINT_constrain__ and_type_declaration
	;

type_subst_constructor_declarations :
	either_constructor_declaration_bar_constructor_declaration_ type_subst_constructor_declarations_aux
	;

type_subst_constructor_declarations_aux :
	bar_constructor_declaration type_subst_constructor_declarations_aux
	| and_type_subst_declaration
	| nonempty_list_preceded_CONSTRAINT_constrain__ and_type_subst_declaration
	;

bar_constructor_declaration :
	BAR constructor_declaration
	| nonempty_list_as_loc_attribute__ BAR constructor_declaration
	;

constructor_declaration :
	UIDENT generalized_constructor_arguments
	| LBRACKET RBRACKET generalized_constructor_arguments
	| LPAREN RPAREN generalized_constructor_arguments
	| COLONCOLON generalized_constructor_arguments
	| FALSE generalized_constructor_arguments
	| TRUE generalized_constructor_arguments
	| nonempty_list_as_loc_attribute__ UIDENT generalized_constructor_arguments
	| nonempty_list_as_loc_attribute__ LBRACKET RBRACKET generalized_constructor_arguments
	| nonempty_list_as_loc_attribute__ LPAREN RPAREN generalized_constructor_arguments
	| nonempty_list_as_loc_attribute__ COLONCOLON generalized_constructor_arguments
	| nonempty_list_as_loc_attribute__ FALSE generalized_constructor_arguments
	| nonempty_list_as_loc_attribute__ TRUE generalized_constructor_arguments
	;

str_exception_declaration :
	EXCEPTION either_extension_constructor_declaration_extension_constructor_rebind_
	| nonempty_list_as_loc_attribute__ EXCEPTION either_extension_constructor_declaration_extension_constructor_rebind_
	;

sig_exception_declaration :
	EXCEPTION extension_constructor_declaration
	| nonempty_list_as_loc_attribute__ EXCEPTION extension_constructor_declaration
	;

generalized_constructor_arguments :
	option_constructor_arguments_ option_preceded_COLON_core_type__
	;

constructor_arguments_comma_list :
	lseparated_nonempty_list_aux_COMMA_core_type_ option_COMMA_
	;

constructor_arguments :
	object_record_type
	| record_declaration
	| LPAREN record_declaration RPAREN
	| LPAREN constructor_arguments_comma_list RPAREN
	;

record_label_declaration :
	mutable_flag LIDENT
	| nonempty_list_as_loc_attribute__ mutable_flag LIDENT
	| mutable_flag LIDENT COLON poly_type
	| nonempty_list_as_loc_attribute__ mutable_flag LIDENT COLON poly_type
	;

record_declaration :
	LBRACE lseparated_nonempty_list_aux_COMMA_record_label_declaration_ option_COMMA_ RBRACE
	;

str_type_extension :
	TYPE nonrec_flag LIDENT type_variables_with_variance PLUSEQ embedded_private_flag_ attributed_ext_constructors_either_extension_constructor_declaration_extension_constructor_rebind__
	| TYPE nonrec_flag mod_ext_longident DOT LIDENT type_variables_with_variance PLUSEQ embedded_private_flag_ attributed_ext_constructors_either_extension_constructor_declaration_extension_constructor_rebind__
	| nonempty_list_as_loc_attribute__ TYPE nonrec_flag LIDENT type_variables_with_variance PLUSEQ embedded_private_flag_ attributed_ext_constructors_either_extension_constructor_declaration_extension_constructor_rebind__
	| nonempty_list_as_loc_attribute__ TYPE nonrec_flag mod_ext_longident DOT LIDENT type_variables_with_variance PLUSEQ embedded_private_flag_ attributed_ext_constructors_either_extension_constructor_declaration_extension_constructor_rebind__
	;

sig_type_extension :
	TYPE nonrec_flag LIDENT type_variables_with_variance PLUSEQ embedded_private_flag_ attributed_ext_constructors_extension_constructor_declaration_
	| TYPE nonrec_flag mod_ext_longident DOT LIDENT type_variables_with_variance PLUSEQ embedded_private_flag_ attributed_ext_constructors_extension_constructor_declaration_
	| nonempty_list_as_loc_attribute__ TYPE nonrec_flag LIDENT type_variables_with_variance PLUSEQ embedded_private_flag_ attributed_ext_constructors_extension_constructor_declaration_
	| nonempty_list_as_loc_attribute__ TYPE nonrec_flag mod_ext_longident DOT LIDENT type_variables_with_variance PLUSEQ embedded_private_flag_ attributed_ext_constructors_extension_constructor_declaration_
	;

attributed_ext_constructors_either_extension_constructor_declaration_extension_constructor_rebind__ :
	either_extension_constructor_declaration_extension_constructor_rebind_ list_attributed_ext_constructor_either_extension_constructor_declaration_extension_constructor_rebind___
	| nonempty_list_attributed_ext_constructor_either_extension_constructor_declaration_extension_constructor_rebind___
	;

attributed_ext_constructors_extension_constructor_declaration_ :
	extension_constructor_declaration list_attributed_ext_constructor_extension_constructor_declaration__
	| nonempty_list_attributed_ext_constructor_extension_constructor_declaration__
	;

extension_constructor_declaration :
	UIDENT generalized_constructor_arguments
	| LBRACKET RBRACKET generalized_constructor_arguments
	| LPAREN RPAREN generalized_constructor_arguments
	| COLONCOLON generalized_constructor_arguments
	| FALSE generalized_constructor_arguments
	| TRUE generalized_constructor_arguments
	;

extension_constructor_rebind :
	UIDENT EQUAL constr_longident
	| LBRACKET RBRACKET EQUAL constr_longident
	| LPAREN RPAREN EQUAL constr_longident
	| COLONCOLON EQUAL constr_longident
	| FALSE EQUAL constr_longident
	| TRUE EQUAL constr_longident
	;

with_constraint :
	TYPE label_longident type_variables_with_variance EQUAL embedded_private_flag_ core_type
	| TYPE label_longident type_variables_with_variance EQUAL embedded_private_flag_ core_type nonempty_list_preceded_CONSTRAINT_constrain__
	| TYPE label_longident type_variables_with_variance COLONEQUAL core_type
	| MODULE mod_longident EQUAL mod_ext_longident
	| MODULE UIDENT COLONEQUAL mod_ext_longident
	;

poly_type :
	core_type
	| nonempty_list_as_loc_preceded_QUOTE_ident___ DOT core_type
	;

core_type :
	core_type2
	| core_type2 AS QUOTE ident
	;

core_type2 :
	unattributed_core_type
	| nonempty_list_as_loc_attribute__ unattributed_core_type
	;

unattributed_core_type :
	non_arrowed_simple_core_type
	| arrowed_simple_core_type
	;

arrowed_simple_core_type :
	ES6_FUN arrow_type_parameters EQUALGREATER core_type2
	| labelled_arrow_type_parameter_optional EQUALGREATER core_type2
	| basic_core_type EQUALGREATER core_type2
	;

labelled_arrow_type_parameter_optional :
	TILDE LIDENT COLON protected_type EQUAL optional
	;

arrow_type_parameter :
	protected_type
	| TILDE LIDENT COLON protected_type
	| labelled_arrow_type_parameter_optional
	;

arrow_type_parameters :
	LPAREN lseparated_nonempty_list_aux_COMMA_uncurried_arrow_type_parameter_ option_COMMA_ RPAREN
	;

non_arrowed_core_type :
	non_arrowed_simple_core_type
	| attribute non_arrowed_core_type
	;

type_parameters :
	LPAREN lseparated_nonempty_list_aux_COMMA_protected_type_ option_COMMA_ RPAREN
	| LESS lseparated_nonempty_list_aux_COMMA_protected_type_ option_COMMA_ GREATER
	| LESSIDENT option_COMMA_ GREATER
	| LESSIDENT type_parameters option_COMMA_ GREATER
	| LESSIDENT COMMA lseparated_nonempty_list_aux_COMMA_protected_type_ option_COMMA_ GREATER
	| LESSIDENT type_parameters COMMA lseparated_nonempty_list_aux_COMMA_protected_type_ option_COMMA_ GREATER
	;

protected_type :
	MODULE package_type
	| core_type
	;

non_arrowed_simple_core_types :
	type_parameters
	;

non_arrowed_simple_core_type :
	non_arrowed_simple_core_types
	| basic_core_type
	;

basic_core_type :
	type_longident type_parameters
	| SHARP class_longident type_parameters
	| QUOTE ident
	| SHARP class_longident
	| UNDERSCORE
	| type_longident
	| object_record_type
	| LBRACKET row_field_list RBRACKET
	| LBRACKETGREATER loption_row_field_list_ RBRACKET
	| LBRACKETLESS row_field_list loption_preceded_GREATER_nonempty_list_name_tag___ RBRACKET
	| extension
	;

object_record_type :
	LBRACE RBRACE
	| LBRACE DOT string_literal_labels RBRACE
	| LBRACE DOTDOT string_literal_labels RBRACE
	| LBRACE DOT loption_object_label_declarations_ RBRACE
	| LBRACE DOTDOT loption_object_label_declarations_ RBRACE
	;

object_label_declaration :
	LIDENT
	| nonempty_list_as_loc_attribute__ LIDENT
	| LIDENT COLON poly_type
	| nonempty_list_as_loc_attribute__ LIDENT COLON poly_type
	| DOTDOTDOT basic_core_type
	;

object_label_declarations :
	lseparated_nonempty_list_aux_COMMA_object_label_declaration_ option_COMMA_
	;

string_literal_label :
	STRING COLON poly_type
	| nonempty_list_as_loc_attribute__ STRING COLON poly_type
	;

string_literal_labels :
	lseparated_nonempty_list_aux_COMMA_string_literal_label_ option_COMMA_
	;

package_type :
	module_type
	;

row_field_list :
	row_field list_bar_row_field_
	| bar_row_field list_bar_row_field_
	;

row_field :
	tag_field
	| non_arrowed_core_type
	;

bar_row_field :
	BAR row_field
	| nonempty_list_as_loc_attribute__ BAR row_field
	;

tag_field :
	BACKQUOTE ident boption_AMPERSAND_ separated_nonempty_list_AMPERSAND_non_arrowed_simple_core_types_
	| nonempty_list_as_loc_attribute__ BACKQUOTE ident boption_AMPERSAND_ separated_nonempty_list_AMPERSAND_non_arrowed_simple_core_types_
	| BACKQUOTE ident
	| nonempty_list_as_loc_attribute__ BACKQUOTE ident
	;

constant :
	INT
	| CHAR
	| FLOAT
	| STRING
	;

signed_constant :
	constant
	| MINUS INT
	| MINUS FLOAT
	| PLUS INT
	| PLUS FLOAT
	;

ident :
	UIDENT
	| LIDENT
	;

mod_ident :
	UIDENT
	| UNDERSCORE
	;

val_ident :
	LIDENT
	| LPAREN operator RPAREN
	;

operator :
	PREFIXOP
	| POSTFIXOP
	| BANG
	| GREATER
	| INFIXOP0
	| INFIXOP1
	| INFIXOP2
	| INFIXOP3
	| SLASHGREATER
	| INFIXOP4
	| PLUS
	| PLUSDOT
	| MINUS
	| MINUSDOT
	| STAR
	| LESS
	| OR
	| BARBAR
	| AMPERSAND
	| AMPERAMPER
	| COLONEQUAL
	| PLUSEQ
	| PERCENT
	| GREATERDOTDOTDOT
	| LESSDOTDOTGREATER
	| GREATER GREATER
	| LETOP
	| ANDOP
	;

val_longident :
	val_ident
	| mod_longident DOT val_ident
	;

constr_longident :
	mod_longident %prec below_DOT
	| LBRACKET RBRACKET
	| LPAREN RPAREN
	| FALSE
	| TRUE
	;

label_longident :
	LIDENT
	| mod_longident DOT LIDENT
	;

type_longident :
	LIDENT
	| mod_ext_longident DOT LIDENT
	;

mod_longident :
	UIDENT
	| mod_longident DOT UIDENT
	;

mod_ext_longident :
	UIDENT
	| mod_ext_longident DOT UIDENT
	| mod_ext_apply
	;

mod_ext_apply :
	UIDENT LPAREN lseparated_nonempty_list_aux_COMMA_mod_ext_longident_ RPAREN
	| mod_ext_longident DOT UIDENT LPAREN lseparated_nonempty_list_aux_COMMA_mod_ext_longident_ RPAREN
	| mod_ext_apply LPAREN lseparated_nonempty_list_aux_COMMA_mod_ext_longident_ RPAREN
	;

mod_ext_lesslongident :
	LESSUIDENT
	| mod_ext_lesslongident DOT UIDENT
	| mod_ext_less_apply
	;

mod_ext_less_apply :
	LESSUIDENT LPAREN lseparated_nonempty_list_aux_COMMA_mod_ext_longident_ RPAREN
	| mod_ext_lesslongident DOT UIDENT LPAREN lseparated_nonempty_list_aux_COMMA_mod_ext_longident_ RPAREN
	| mod_ext_less_apply LPAREN lseparated_nonempty_list_aux_COMMA_mod_ext_longident_ RPAREN
	;

mty_longident :
	ident
	| mod_ext_longident DOT ident
	;

clty_longident :
	LIDENT
	| mod_ext_longident DOT LIDENT
	;

class_longident :
	LIDENT
	| mod_longident DOT LIDENT
	;

//toplevel_directive :
//	SHARP ident embedded___anonymous_39_
//	;

opt_LET_MODULE :
	MODULE
	| LET MODULE
	;

rec_flag :
	/*empty*/
	| REC
	;

nonrec_flag :
	/*empty*/
	| NONREC
	;

direction_flag :
	TO
	| DOWNTO
	;

mutable_flag :
	/*empty*/
	| MUTABLE
	;

virtual_flag :
	/*empty*/
	| VIRTUAL
	;

mutable_or_virtual_flags :
	/*empty*/
	| VIRTUAL mutable_flag
	| MUTABLE virtual_flag
	;

override_flag :
	/*empty*/
	| BANG
	;

single_attr_id :
	LIDENT
	| UIDENT
	| AND
	| AS
	| ASSERT
	| BEGIN
	| CLASS
	| CONSTRAINT
	| DO
	| DONE
	| DOWNTO
	| ELSE
	| END
	| EXCEPTION
	| EXTERNAL
	| FALSE
	| FOR
	| FUN
	| FUNCTION
	| FUNCTOR
	| IF
	| IN
	| INCLUDE
	| INHERIT
	| INITIALIZER
	| LAZY
	| LET
	| SWITCH
	| MODULE
	| MUTABLE
	| NEW
	| NONREC
	| OBJECT
	| OF
	| OPEN
	| OR
	| PRI
	| REC
	| SIG
	| STRUCT
	| THEN
	| TO
	| TRUE
	| TRY
	| TYPE
	| VAL
	| VIRTUAL
	| WHEN
	| WHILE
	| WITH
	;

attr_id :
	single_attr_id
	| single_attr_id DOT attr_id
	;

attribute :
	LBRACKETAT attr_id payload RBRACKET
	| DOCSTRING
	;

item_extension_sugar :
	PERCENT attr_id
	;

extension :
	LBRACKETPERCENT attr_id payload RBRACKET
	;

item_extension :
	LBRACKETPERCENTPERCENT attr_id payload RBRACKET
	;

payload :
	structure
	| COLON signature
	| COLON core_type
	| QUESTION pattern
	| QUESTION pattern WHEN expr
	| simple_pattern_ident EQUALGREATER expr
	;

optional :
	/*empty*/
	| QUESTION
	;

either_ES6_FUN_FUN_ :
	ES6_FUN
	| FUN
	;

either___anonymous_11___anonymous_12_ :
	PUB
	| PRI
	;

either_constructor_declaration_bar_constructor_declaration_ :
	constructor_declaration
	| bar_constructor_declaration
	;

either_extension_constructor_declaration_extension_constructor_rebind_ :
	extension_constructor_declaration
	| extension_constructor_rebind
	;

either_parenthesized_longident_type_constraint__longident_type_constraint_ :
	LPAREN longident_type_constraint RPAREN
	| longident_type_constraint
	;

either_preceded_EQUAL_class_expr__class_body_expr_ :
	EQUAL class_expr
	| LBRACE class_expr_lets_and_rest RBRACE
	;

either_preceded_EQUAL_class_instance_type__class_type_body_ :
	EQUAL class_instance_type
	| class_type_body
	;

either_preceded_EQUAL_expr__braced_expr_ :
	EQUAL expr
	| braced_expr
	;

either_preceded_EQUALGREATER_expr__braced_expr_ :
	EQUALGREATER expr
	| braced_expr
	;

llist_aux_match_case_expr__ :
	/*empty*/
	| llist_aux_match_case_expr__ match_case_expr_
	;

llist_aux_match_case_seq_expr__ :
	/*empty*/
	| llist_aux_match_case_seq_expr__ match_case_seq_expr_
	;

llist_aux_preceded_COMMA_opt_spread_lbl_expr___ :
	/*empty*/
	| llist_aux_preceded_COMMA_opt_spread_lbl_expr___ COMMA option_DOTDOTDOT_ label_longident COLON expr
	| llist_aux_preceded_COMMA_opt_spread_lbl_expr___ COMMA option_DOTDOTDOT_ label_longident
	;

lseparated_nonempty_list_aux_AND_with_constraint_ :
	with_constraint
	| lseparated_nonempty_list_aux_AND_with_constraint_ AND with_constraint
	;

lseparated_nonempty_list_aux_COMMA_core_type_ :
	core_type
	| lseparated_nonempty_list_aux_COMMA_core_type_ COMMA core_type
	;

lseparated_nonempty_list_aux_COMMA_expr_ :
	expr
	| lseparated_nonempty_list_aux_COMMA_expr_ COMMA expr
	;

lseparated_nonempty_list_aux_COMMA_expr_optional_constraint_ :
	expr_optional_constraint
	| lseparated_nonempty_list_aux_COMMA_expr_optional_constraint_ COMMA expr_optional_constraint
	;

lseparated_nonempty_list_aux_COMMA_field_expr_ :
	field_expr
	| lseparated_nonempty_list_aux_COMMA_field_expr_ COMMA field_expr
	;

lseparated_nonempty_list_aux_COMMA_labeled_pattern_ :
	labeled_pattern
	| lseparated_nonempty_list_aux_COMMA_labeled_pattern_ COMMA labeled_pattern
	;

lseparated_nonempty_list_aux_COMMA_mod_ext_longident_ :
	mod_ext_longident
	| lseparated_nonempty_list_aux_COMMA_mod_ext_longident_ COMMA mod_ext_longident
	;

lseparated_nonempty_list_aux_COMMA_module_complex_expr_ :
	module_complex_expr
	| lseparated_nonempty_list_aux_COMMA_module_complex_expr_ COMMA module_complex_expr
	;

lseparated_nonempty_list_aux_COMMA_module_parameter_ :
	module_parameter
	| lseparated_nonempty_list_aux_COMMA_module_parameter_ COMMA module_parameter
	;

lseparated_nonempty_list_aux_COMMA_object_label_declaration_ :
	object_label_declaration
	| lseparated_nonempty_list_aux_COMMA_object_label_declaration_ COMMA object_label_declaration
	;

lseparated_nonempty_list_aux_COMMA_opt_spread_expr_optional_constraint__ :
	option_DOTDOTDOT_ expr_optional_constraint
	| lseparated_nonempty_list_aux_COMMA_opt_spread_expr_optional_constraint__ COMMA option_DOTDOTDOT_ expr_optional_constraint
	;

lseparated_nonempty_list_aux_COMMA_opt_spread_lbl_expr__ :
	option_DOTDOTDOT_ label_longident COLON expr
	| option_DOTDOTDOT_ label_longident
	| lseparated_nonempty_list_aux_COMMA_opt_spread_lbl_expr__ COMMA option_DOTDOTDOT_ label_longident COLON expr
	| lseparated_nonempty_list_aux_COMMA_opt_spread_lbl_expr__ COMMA option_DOTDOTDOT_ label_longident
	;

lseparated_nonempty_list_aux_COMMA_opt_spread_pattern__ :
	option_DOTDOTDOT_ pattern
	| lseparated_nonempty_list_aux_COMMA_opt_spread_pattern__ COMMA option_DOTDOTDOT_ pattern
	;

lseparated_nonempty_list_aux_COMMA_pattern_optional_constraint_ :
	pattern_optional_constraint
	| lseparated_nonempty_list_aux_COMMA_pattern_optional_constraint_ COMMA pattern_optional_constraint
	;

lseparated_nonempty_list_aux_COMMA_protected_type_ :
	protected_type
	| lseparated_nonempty_list_aux_COMMA_protected_type_ COMMA protected_type
	;

lseparated_nonempty_list_aux_COMMA_record_label_declaration_ :
	record_label_declaration
	| lseparated_nonempty_list_aux_COMMA_record_label_declaration_ COMMA record_label_declaration
	;

lseparated_nonempty_list_aux_COMMA_string_literal_expr_maybe_punned_ :
	string_literal_expr_maybe_punned
	| lseparated_nonempty_list_aux_COMMA_string_literal_expr_maybe_punned_ COMMA string_literal_expr_maybe_punned
	;

lseparated_nonempty_list_aux_COMMA_string_literal_label_ :
	string_literal_label
	| lseparated_nonempty_list_aux_COMMA_string_literal_label_ COMMA string_literal_label
	;

lseparated_nonempty_list_aux_COMMA_type_parameter_ :
	type_parameter
	| lseparated_nonempty_list_aux_COMMA_type_parameter_ COMMA type_parameter
	;

lseparated_nonempty_list_aux_COMMA_type_variable_with_variance_ :
	type_variable_with_variance
	| lseparated_nonempty_list_aux_COMMA_type_variable_with_variance_ COMMA type_variable_with_variance
	;

lseparated_nonempty_list_aux_COMMA_uncurried_arrow_type_parameter_ :
	option_DOT_ arrow_type_parameter
	| lseparated_nonempty_list_aux_COMMA_uncurried_arrow_type_parameter_ COMMA option_DOT_ arrow_type_parameter
	;

lseparated_nonempty_list_aux_COMMA_uncurried_labeled_expr_ :
	option_DOT_ labeled_expr
	| lseparated_nonempty_list_aux_COMMA_uncurried_labeled_expr_ COMMA option_DOT_ labeled_expr
	;

lseparated_nonempty_list_aux_SEMI_class_field_ :
	class_field
	| lseparated_nonempty_list_aux_SEMI_class_field_ SEMI class_field
	;

lseparated_nonempty_list_aux_SEMI_class_sig_field_ :
	class_sig_field
	| lseparated_nonempty_list_aux_SEMI_class_sig_field_ SEMI class_sig_field
	;

%%

newline   \n\r?|\r\n?
blank   [ \t\f]
lowercase   [a-z_]
lowercase_no_under   [a-z]
uppercase   [A-Z]
uppercase_or_lowercase   {lowercase}|{uppercase}
identchar   [A-Za-z_'0-9]
lowercase_latin1   [a-z\xDF-\xF6\xF8-\xFF_]
uppercase_latin1   [A-Z\xC0-\xD6\xD8-\xDE]
identchar_latin1   [A-Za-z_\xC0-\xD6\xD8-\xDE\xF8-\xFF'0-9]

operator_chars   [!$%&+\-:<>?@^|~#.]|(\\?[/*])
dotsymbolchar   [!$%&*+\-/:>?@^|\\a-zA-Z_0-9]
kwdopchar   [$&*+\-/<>@^|.!]

decimal_literal   [0-9][0-9_]*

hex_literal   0[xX][0-9A-Fa-f][0-9A-Fa-f_]*
oct_literal   0[oO][0-7][0-7_]*
bin_literal   0[bB][0-1][0-1_]*

int_literal   {decimal_literal}|{hex_literal}|{oct_literal}|{bin_literal}

float_literal   [0-9][0-9_]*("."[0-9_]*)?([eE][+-]?[0-9][0-9_]*)?

hex_float_literal   0[xX][0-9A-Fa-f][0-9A-Fa-f_]*("."[0-9A-Fa-f_]*)?([pP][+-]?[0-9][0-9_]*)?

literal_modifier   [G-Zg-z]

%%

"and"	AND
"as"	AS
"assert"	ASSERT
"begin"	BEGIN
"class"	CLASS
"constraint"	CONSTRAINT
"do"	DO
"done"	DONE
"downto"	DOWNTO
"else"	ELSE
"end"	END
"exception"	EXCEPTION
"external"	EXTERNAL
"false"	FALSE
"for"	FOR
"fun"	FUN
"esfun"	ES6_FUN
"function"	FUNCTION
"functor"	FUNCTOR
"if"	IF
"in"	IN
"include"	INCLUDE
"inherit"	INHERIT
"initializer"	INITIALIZER
"lazy"	LAZY
"let"	LET
"switch"	SWITCH
"module"	MODULE
"pub"	PUB
"mutable"	MUTABLE
"new"	NEW
"nonrec"	NONREC
"object"	OBJECT
"of"	OF
"open"	OPEN
"or"	OR
/*  "parser"	PARSER */
"pri"	PRI
"rec"	REC
"sig"	SIG
"struct"	STRUCT
"then"	THEN
"to"	TO
"true"	TRUE
"try"	TRY
"type"	TYPE
"val"	VAL
"virtual"	VIRTUAL
"when"	WHEN
"while"	WHILE
"with"	WITH

"mod"	INFIXOP3
"land"	INFIXOP3
"lor"	INFIXOP3
"lxor"	INFIXOP3
"lsl"	INFIXOP4
"lsr"	INFIXOP4
"asr"	INFIXOP4

"\\"{newline}	skip()
{newline}	skip()
{blank}+		skip()
"_"	UNDERSCORE
"~"	TILDE
"?"	QUESTION
"=?"	EQUAL
"#=<"	SHARPEQUAL	/* Allow parsing of foo#=<bar /> */
"#="	SHARPEQUAL
"#"{operator_chars}+	SHARPOP
"#"[ \t]*[0-9]+.*	skip()
"&"   AMPERSAND
"&&"  AMPERAMPER
"`"   BACKQUOTE
"'"   QUOTE
"("   LPAREN
")"   RPAREN
"*"   STAR
","   COMMA
"->"  MINUSGREATER
"=>"  EQUALGREATER
/* allow lexing of | `Variant =><Component /> */
"=><"{uppercase_or_lowercase}({identchar}|".")* 	EQUALGREATER
"#"    SHARP
"."    DOT
".."   DOTDOT
"..."  DOTDOTDOT
":"    COLON
"::"   COLONCOLON
":="   COLONEQUAL
":>"   COLONGREATER
";"    SEMI
//";;"   SEMISEMI
"<"    LESS
"="    EQUAL
"["    LBRACKET
"[|"   LBRACKETBAR
"[<"   LBRACKETLESS
"[>"   LBRACKETGREATER

/* Parsing <_ helps resolve no conflicts in the parser and creates other
* challenges with splitting up INFIXOP0 tokens (in Reason_parser_single)
* so we don't do it. */
"<"(({uppercase}{identchar}*".")*({lowercase_no_under}|{lowercase}{identchar}{identchar}*))	LESSIDENT

"<"{uppercase}{identchar}*		LESSUIDENT
">..."   GREATERDOTDOTDOT

/* Allow parsing of Pexp_override:
* let z = {<state: 0, x: y>};
*
* Make sure {<state is emitted as LBRACELESS.
* This contrasts with jsx:
* in a jsx context {<div needs to be LBRACE LESS (two tokens)
* for a valid parse.
*/
"{<"{uppercase_or_lowercase}{identchar}*{blank}*":"	LBRACELESS
"{<"{uppercase_or_lowercase}({identchar}|".")*	LBRACE
/* allows parsing of `{<Text` in <Description term={<Text text="Age" />}>
 as correct jsx
*/
"{<>" 	LBRACE
"{<>}" 	LBRACELESS
"</"{blank}*(({uppercase_or_lowercase}({identchar}|".")*)){blank}*">"	LESSSLASHIDENTGREATER
"]"   RBRACKET
"{"   LBRACE
"{<"  LBRACELESS
"|"   BAR
"||"  BARBAR
"|]"  BARRBRACKET
">"   GREATER
/* Having a GREATERRBRACKET makes it difficult to parse patterns such
as > ]. The space in between then becomes significant and must be
maintained when printing etc. >] isn't even needed!
| ">]" { GREATERRBRACKET }
*/
"}"   RBRACE
">}"  GREATERRBRACE
"=<"{uppercase_or_lowercase}+	EQUAL
/* allow `let x=<div />;` */
"/>|]"	SLASHGREATER	/* jsx in arrays: [|<div />|]*/
"[|<"	LBRACKETBAR
/* allow parsing of <div /></Component> */
"/></"{uppercase_or_lowercase}+	SLASHGREATER	/* allow parsing of <div asd=1></div> */
"></"{uppercase_or_lowercase}+		GREATER	/* allow parsing of <div asd=1></div> */
"><"{uppercase_or_lowercase}+	GREATER	/* allow parsing of <div><span> */
"[@"  LBRACKETAT
"[%"  LBRACKETPERCENT
"[%%"  LBRACKETPERCENTPERCENT
"!"   BANG
"!="  INFIXOP0
"!=="  INFIXOP0
"\\!="  INFIXOP0
"\\!=="  INFIXOP0
"+"   PLUS
"+."  PLUSDOT
"+="  PLUSEQ
"-"   MINUS
"-."  MINUSDOT
"<>"  LESSGREATER
"</>"  LESSSLASHGREATER
"<..>"  LESSDOTDOTGREATER
"\\"?[~?!]{operator_chars}+	PREFIXOP
"\\"?[=<>|&$]{operator_chars}*	INFIXOP0
/* See decompose_token in Reason_single_parser.ml for how let `x=-1` is lexed
* and broken up into multiple tokens when necessary. */

"\\"?"@"{operator_chars}*	INFIXOP1

"\\"?"^"("\\.")?{operator_chars}*	POSTFIXOP
///////{ match lexeme_without_comment lexbuf with
///////| "^." | "^|" ->
///////(* ^| is not an infix op in [|a^|] *)
///////set_lexeme_length lexbuf
///////  (if Lexing.lexeme_char lexbuf 0 = '\\' then 2 else 1);
///////POSTFIXOP "^"
///////| "^" -> POSTFIXOP "^"
///////| op -> INFIXOP1 (unescape_operator op)
///////}

"++"{operator_chars}*	INFIXOP1
"\\"?[+-]{operator_chars}*	INFIXOP2
/* SLASHGREATER is an INFIXOP3 that is handled specially */
"/>"  SLASHGREATER
///* The second star must be escaped so that the precedence assumptions for
//* printing match those of parsing. (Imagine what could happen if the other
//* rule beginning with * picked up */*, and we internally escaped it to **.
//* Whe printing, we have an understanding of the precedence of "**", which
//* enables us to safely print/group it, but that understanding would not
//* match the *actual* precedence that it was parsed at thanks to the *other*
//* rule beginning with *, picking it up instead of the special double ** rule
//* below.
//*/
"\\"?"*""\\"?"*"{operator_chars}*	INFIXOP4
"%"  PERCENT
////"\\"?[/*]{operator_chars}*
////{ match lexeme_operator lexbuf with
////| "" ->
////  (* If the operator is empty, it means the lexeme is beginning
////   * by a comment sequence: we let the comment lexer handle
////   * the case. *)
////  enter_comment state lexbuf
////| op -> INFIXOP3 op }
////| '%' operator_chars*
////{ INFIXOP3 (lexeme_operator lexbuf) }

"let"{kwdopchar}{dotsymbolchar}*	LETOP
"and"{kwdopchar}{dotsymbolchar}*	ANDOP

"//".*		skip()
"/*"<>BLK_COMMENT>
<BLK_COMMENT> {
    "/*"<>BLK_COMMENT>
    (?s:.)<.>
    "*/"<<> skip()
}

"(**"(?s:.)*?"*)"	DOCSTRING

"#!".*	skip()

{lowercase}{identchar}*	LIDENT
{lowercase_latin1}{identchar_latin1}*	LIDENT
{uppercase}{identchar}*	UIDENT	 /* No capitalized keywords */
{uppercase_latin1}{identchar_latin1}*	UIDENT
{int_literal}	INT
{int_literal}{literal_modifier}	INT
{float_literal}|{hex_float_literal}	FLOAT
({float_literal}|{hex_float_literal}){literal_modifier}	FLOAT

\"("\\".|[^"\n\r\\])*\"	STRING
"{"{lowercase}*"|"(?s:.)"|"{lowercase}*"}"	STRING
'("\\".|[^'\n\r\\])'	CHAR

%%
