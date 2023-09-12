//From: https://github.com/rescript-lang/rescript-compiler/blob/ba5d03058f0f0af6675fc4b5affc3619b6e012dc/jscomp/ml/parser.mly

/**************************************************************************/
/*                                                                        */
/*                                 OCaml                                  */
/*                                                                        */
/*             Xavier Leroy, projet Cristal, INRIA Rocquencourt           */
/*                                                                        */
/*   Copyright 1996 Institut National de Recherche en Informatique et     */
/*     en Automatique.                                                    */
/*                                                                        */
/*   All rights reserved.  This file is distributed under the terms of    */
/*   the GNU Lesser General Public License version 2.1, with the          */
/*   special exception on linking described in the file LICENSE.          */
/*                                                                        */
/**************************************************************************/

%x  BLK_COMMENT

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
%token  CHAR
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
%token FUN
%token FUNCTION
%token FUNCTOR
%token GREATER
%token GREATERRBRACE
//%token GREATERRBRACKET
%token IF
%token IN
%token INCLUDE
%token INFIXOP0
%token INFIXOP1
%token INFIXOP2
%token INFIXOP3
%token INFIXOP4
%token DOTOP
%token INHERIT
%token INITIALIZER
%token INT
%token LABEL
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
%token LESSMINUS
%token LET
%token LIDENT
%token LPAREN
%token LBRACKETAT
%token LBRACKETATAT
%token LBRACKETATATAT
%token MATCH
%token METHOD
%token MINUS
%token MINUSDOT
%token MINUSGREATER
%token MODULE
%token MUTABLE
%token NEW
%token NONREC
%token OBJECT
%token OF
%token OPEN
%token OPTLABEL
%token OR
/* %token PARSER */
%token PERCENT
%token PLUS
%token PLUSDOT
%token PLUSEQ
%token PREFIXOP
%token PRIVATE
%token QUESTION
%token QUOTE
%token RBRACE
%token RBRACKET
%token REC
%token RPAREN
%token SEMI
%token SEMISEMI
%token HASH
%token HASHOP
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
//%token DOCSTRING

//%token EOL

/* Precedences and associativities.

Tokens and rules have precedences.  A reduce/reduce conflict is resolved
in favor of the first rule (in source file order).  A shift/reduce conflict
is resolved by comparing the precedence and associativity of the token to
be shifted with those of the rule to be reduced.

By default, a rule has the precedence of its rightmost terminal (if any).

When there is a shift/reduce conflict between a rule and a token that
have the same precedence, it is resolved using the associativity:
if the token is left-associative, the parser will reduce; if
right-associative, the parser will shift; if non-associative,
the parser will declare a syntax error.

We will only use associativities with operators of the kind  x * x -> x
for example, in the rules of the form    expr: expr BINOP expr
in all other cases, we define two precedences if needed to resolve
conflicts.

The precedences must be listed from low to high.
*/

%nonassoc IN
%nonassoc below_SEMI
%nonassoc SEMI                          /* below EQUAL ({lbl=...; lbl=...}) */
%nonassoc LET                           /* above SEMI ( ...; let ... in ...) */
%nonassoc below_WITH
%nonassoc FUNCTION WITH                 /* below BAR  (match ... with ...) */
%nonassoc AND             /* above WITH (module rec A: SIG with ... and ...) */
%nonassoc THEN                          /* below ELSE (if ... then ...) */
%nonassoc ELSE                          /* (if ... then ... else ...) */
%nonassoc LESSMINUS                     /* below COLONEQUAL (lbl <- x := e) */
%right    COLONEQUAL                    /* expr (e := e := e) */
%nonassoc AS
%left     BAR                           /* pattern (p|p|p) */
%nonassoc below_COMMA
%left     COMMA                         /* expr/expr_comma_list (e,e,e) */
%right    MINUSGREATER                  /* core_type2 (t -> t -> t) */
%right    OR BARBAR                     /* expr (e || e || e) */
%right    AMPERSAND AMPERAMPER          /* expr (e && e && e) */
%nonassoc below_EQUAL
%left     INFIXOP0 EQUAL LESS GREATER   /* expr (e OP e OP e) */
%right    INFIXOP1                      /* expr (e OP e OP e) */
%nonassoc below_LBRACKETAT
%nonassoc LBRACKETAT
%nonassoc LBRACKETATAT
%right    COLONCOLON                    /* expr (e :: e :: e) */
%left     INFIXOP2 PLUS PLUSDOT MINUS MINUSDOT PLUSEQ /* expr (e OP e OP e) */
%left     PERCENT INFIXOP3 STAR                 /* expr (e OP e OP e) */
%right    INFIXOP4                      /* expr (e OP e OP e) */
%nonassoc prec_unary_minus prec_unary_plus /* unary - */
%nonassoc prec_constant_constructor     /* cf. simple_expr (C versus C x) */
%nonassoc prec_constr_appl              /* above AS BAR COLONCOLON COMMA */
%nonassoc below_HASH
%nonassoc HASH                         /* simple_expr/toplevel_directive */
%left     HASHOP
%nonassoc below_DOT
%nonassoc DOT DOTOP
/* Finally, the first tokens of simple_expr are above everything else. */
%nonassoc BACKQUOTE BANG BEGIN CHAR FALSE FLOAT INT LBRACE LBRACELESS LBRACKET LBRACKETBAR LIDENT LPAREN NEW PREFIXOP STRING TRUE UIDENT LBRACKETPERCENT LBRACKETPERCENTPERCENT


/* Entry points */

%start structure

%%

//implementation :
//	structure EOF
//	;
//
//interface :
//	signature EOF
//	;
//
//parse_core_type :
//	core_type EOF
//	;
//
//parse_expression :
//	seq_expr EOF
//	;
//
//parse_pattern :
//	pattern EOF
//	;

functor_arg :
	LPAREN RPAREN
	| LPAREN functor_arg_name COLON module_type RPAREN
	;

functor_arg_name :
	UIDENT
	| UNDERSCORE
	;

functor_args :
	functor_args functor_arg
	| functor_arg
	;

module_expr :
	mod_longident
	| STRUCT attributes structure END
	//| STRUCT attributes structure error
	| FUNCTOR attributes functor_args MINUSGREATER module_expr
	| module_expr paren_module_expr
	| module_expr LPAREN RPAREN
	| paren_module_expr
	| module_expr attribute
	| extension
	;

paren_module_expr :
	LPAREN module_expr COLON module_type RPAREN
	//| LPAREN module_expr COLON module_type error
	| LPAREN module_expr RPAREN
	//| LPAREN module_expr error
	| LPAREN VAL attributes expr RPAREN
	| LPAREN VAL attributes expr COLON package_type RPAREN
	| LPAREN VAL attributes expr COLON package_type COLONGREATER package_type RPAREN
	| LPAREN VAL attributes expr COLONGREATER package_type RPAREN
	//| LPAREN VAL attributes expr COLON error
	//| LPAREN VAL attributes expr COLONGREATER error
	//| LPAREN VAL attributes expr error
	;

structure :
	seq_expr post_item_attributes structure_tail
	| structure_tail
	;

structure_tail :
	/*empty*/
	| SEMISEMI structure
	| structure_item structure_tail
	;

structure_item :
	let_bindings
	| primitive_declaration
	| value_description
	| type_declarations
	| str_type_extension
	| str_exception_declaration
	| module_binding
	| rec_module_bindings
	| module_type_declaration
	| open_statement
	| class_type_declarations
	| str_include_statement
	| item_extension post_item_attributes
	| floating_attribute
	;

str_include_statement :
	INCLUDE ext_attributes module_expr post_item_attributes
	;

module_binding_body :
	EQUAL module_expr
	| COLON module_type EQUAL module_expr
	| functor_arg module_binding_body
	;

module_binding :
	MODULE ext_attributes UIDENT module_binding_body post_item_attributes
	;

rec_module_bindings :
	rec_module_binding
	| rec_module_bindings and_module_binding
	;

rec_module_binding :
	MODULE ext_attributes REC UIDENT module_binding_body post_item_attributes
	;

and_module_binding :
	AND attributes UIDENT module_binding_body post_item_attributes
	;

module_type :
	mty_longident
	| SIG attributes signature END
	//| SIG attributes signature error
	| FUNCTOR attributes functor_args MINUSGREATER module_type %prec below_WITH
	| module_type MINUSGREATER module_type  %prec below_WITH
	| module_type WITH with_constraints
	| MODULE TYPE OF attributes module_expr %prec below_LBRACKETAT
	| LPAREN module_type RPAREN
	//| LPAREN module_type error
	| extension
	| module_type attribute
	;

signature :
	/*empty*/
	| SEMISEMI signature
	| signature_item signature
	;

signature_item :
	value_description
	| primitive_declaration
	| type_declarations
	| sig_type_extension
	| sig_exception_declaration
	| module_declaration
	| module_alias
	| rec_module_declarations
	| module_type_declaration
	| open_statement
	| sig_include_statement
	| class_type_declarations
	| item_extension post_item_attributes
	| floating_attribute
	;

open_statement :
	OPEN override_flag ext_attributes mod_longident post_item_attributes
	;

sig_include_statement :
	INCLUDE ext_attributes module_type post_item_attributes %prec below_WITH
	;

module_declaration_body :
	COLON module_type
	| LPAREN UIDENT COLON module_type RPAREN module_declaration_body
	| LPAREN RPAREN module_declaration_body
	;

module_declaration :
	MODULE ext_attributes UIDENT module_declaration_body post_item_attributes
	;

module_alias :
	MODULE ext_attributes UIDENT EQUAL mod_longident post_item_attributes
	;

rec_module_declarations :
	rec_module_declaration
	| rec_module_declarations and_module_declaration
	;

rec_module_declaration :
	MODULE ext_attributes REC UIDENT COLON module_type post_item_attributes
	;

and_module_declaration :
	AND attributes UIDENT COLON module_type post_item_attributes
	;

module_type_declaration_body :
	/*empty*/
	| EQUAL module_type
	;

module_type_declaration :
	MODULE TYPE ext_attributes ident module_type_declaration_body post_item_attributes
	;

class_type_parameters :
	/*empty*/
	| LBRACKET type_parameter_list RBRACKET
	;

class_structure :
	class_self_pattern class_fields
	;

class_self_pattern :
	LPAREN pattern RPAREN
	| LPAREN pattern COLON core_type RPAREN
	|
	;

class_fields :
	/*empty*/
	| class_fields class_field
	;

class_field :
	VAL value post_item_attributes
	| METHOD method_ post_item_attributes
	| CONSTRAINT attributes constrain_field post_item_attributes
	| INITIALIZER attributes seq_expr post_item_attributes
	| item_extension post_item_attributes
	| floating_attribute
	;

value :
	override_flag attributes MUTABLE VIRTUAL label COLON core_type
	| override_flag attributes VIRTUAL mutable_flag label COLON core_type
	| override_flag attributes mutable_flag label EQUAL seq_expr
	| override_flag attributes mutable_flag label type_constraint EQUAL seq_expr
	;

method_ :
	override_flag attributes PRIVATE VIRTUAL label COLON poly_type
	| override_flag attributes VIRTUAL private_flag label COLON poly_type
	| override_flag attributes private_flag label strict_binding
	| override_flag attributes private_flag label COLON poly_type EQUAL seq_expr
	| override_flag attributes private_flag label COLON TYPE lident_list DOT core_type EQUAL seq_expr
	;

class_signature :
	LBRACKET core_type_comma_list RBRACKET clty_longident
	| clty_longident
	| OBJECT attributes class_sig_body END
	//| OBJECT attributes class_sig_body error
	| class_signature attribute
	| extension
	| LET OPEN override_flag attributes mod_longident IN class_signature
	;

class_sig_body :
	class_self_type class_sig_fields
	;

class_self_type :
	LPAREN core_type RPAREN
	|
	;

class_sig_fields :
	/*empty*/
	| class_sig_fields class_sig_field
	;

class_sig_field :
	INHERIT attributes class_signature post_item_attributes
	| VAL attributes value_type post_item_attributes
	| METHOD attributes private_virtual_flags label COLON poly_type post_item_attributes
	| CONSTRAINT attributes constrain_field post_item_attributes
	| item_extension post_item_attributes
	| floating_attribute
	;

value_type :
	VIRTUAL mutable_flag label COLON core_type
	| MUTABLE virtual_flag label COLON core_type
	| label COLON core_type
	;

constrain :
	core_type EQUAL core_type
	;

constrain_field :
	core_type EQUAL core_type
	;

class_type_declarations :
	class_type_declaration
	| class_type_declarations and_class_type_declaration
	;

class_type_declaration :
	CLASS TYPE ext_attributes virtual_flag class_type_parameters LIDENT EQUAL class_signature post_item_attributes
	;

and_class_type_declaration :
	AND attributes virtual_flag class_type_parameters LIDENT EQUAL class_signature post_item_attributes
	;

seq_expr :
	expr  %prec below_SEMI
	| expr SEMI
	| expr SEMI seq_expr
	| expr SEMI PERCENT attr_id seq_expr
	;

labeled_simple_pattern :
	QUESTION LPAREN label_let_pattern opt_default RPAREN
	| QUESTION label_var
	| OPTLABEL LPAREN let_pattern opt_default RPAREN
	| OPTLABEL pattern_var
	| TILDE LPAREN label_let_pattern RPAREN
	| TILDE label_var
	| LABEL simple_pattern
	| simple_pattern
	;

pattern_var :
	LIDENT
	| UNDERSCORE
	;

opt_default :
	/*empty*/
	| EQUAL seq_expr
	;

label_let_pattern :
	label_var
	| label_var COLON core_type
	;

label_var :
	LIDENT
	;

let_pattern :
	pattern
	| pattern COLON core_type
	;

expr :
	simple_expr %prec below_HASH
	| simple_expr simple_labeled_expr_list
	| let_bindings IN seq_expr
	| LET MODULE ext_attributes UIDENT module_binding_body IN seq_expr
	| LET EXCEPTION ext_attributes let_exception_declaration IN seq_expr
	| LET OPEN override_flag ext_attributes mod_longident IN seq_expr
	| FUNCTION ext_attributes opt_bar match_cases
	| FUN ext_attributes labeled_simple_pattern fun_def
	| FUN ext_attributes LPAREN TYPE lident_list RPAREN fun_def
	| MATCH ext_attributes seq_expr WITH opt_bar match_cases
	| TRY ext_attributes seq_expr WITH opt_bar match_cases
	//| TRY ext_attributes seq_expr WITH error
	| expr_comma_list %prec below_COMMA
	| constr_longident simple_expr %prec below_HASH
	| name_tag simple_expr %prec below_HASH
	| IF ext_attributes seq_expr THEN expr ELSE expr
	| IF ext_attributes seq_expr THEN expr
	| WHILE ext_attributes seq_expr DO seq_expr DONE
	| FOR ext_attributes pattern EQUAL seq_expr direction_flag seq_expr DO seq_expr DONE
	| expr COLONCOLON expr
	| expr INFIXOP0 expr
	| expr INFIXOP1 expr
	| expr INFIXOP2 expr
	| expr INFIXOP3 expr
	| expr INFIXOP4 expr
	| expr PLUS expr
	| expr PLUSDOT expr
	| expr PLUSEQ expr
	| expr MINUS expr
	| expr MINUSDOT expr
	| expr STAR expr
	| expr PERCENT expr
	| expr EQUAL expr
	| expr LESS expr
	| expr GREATER expr
	| expr OR expr
	| expr BARBAR expr
	| expr AMPERSAND expr
	| expr AMPERAMPER expr
	| expr COLONEQUAL expr
	| subtractive expr %prec prec_unary_minus
	| additive expr %prec prec_unary_plus
	| simple_expr DOT label_longident LESSMINUS expr
	| simple_expr DOT LPAREN seq_expr RPAREN LESSMINUS expr
	| simple_expr DOT LBRACKET seq_expr RBRACKET LESSMINUS expr
	| simple_expr DOTOP LBRACKET expr RBRACKET LESSMINUS expr
	| simple_expr DOTOP LPAREN expr RPAREN LESSMINUS expr
	| simple_expr DOTOP LBRACE expr RBRACE LESSMINUS expr
	| simple_expr DOT mod_longident DOTOP LBRACKET expr RBRACKET LESSMINUS expr
	| simple_expr DOT mod_longident DOTOP LPAREN expr RPAREN LESSMINUS expr
	| simple_expr DOT mod_longident DOTOP LBRACE expr RBRACE LESSMINUS expr
	| label LESSMINUS expr
	| ASSERT ext_attributes simple_expr %prec below_HASH
	| LAZY ext_attributes simple_expr %prec below_HASH
	| OBJECT ext_attributes class_structure END
	//| OBJECT ext_attributes class_structure error
	| expr attribute
	| UNDERSCORE
	;

simple_expr :
	val_longident
	| constant
	| constr_longident %prec prec_constant_constructor
	| name_tag %prec prec_constant_constructor
	| LPAREN seq_expr RPAREN
	//| LPAREN seq_expr error
	| BEGIN ext_attributes seq_expr END
	| BEGIN ext_attributes END
	//| BEGIN ext_attributes seq_expr error
	| LPAREN seq_expr type_constraint RPAREN
	| simple_expr DOT label_longident
	| mod_longident DOT LPAREN seq_expr RPAREN
	| mod_longident DOT LPAREN RPAREN
	//| mod_longident DOT LPAREN seq_expr error
	| simple_expr DOT LPAREN seq_expr RPAREN
	//| simple_expr DOT LPAREN seq_expr error
	| simple_expr DOT LBRACKET seq_expr RBRACKET
	//| simple_expr DOT LBRACKET seq_expr error
	| simple_expr DOTOP LBRACKET expr RBRACKET
	//| simple_expr DOTOP LBRACKET expr error
	| simple_expr DOTOP LPAREN expr RPAREN
	//| simple_expr DOTOP LPAREN expr error
	| simple_expr DOTOP LBRACE expr RBRACE
	//| simple_expr DOTOP LBRACE expr error
	| simple_expr DOT mod_longident DOTOP LBRACKET expr RBRACKET
	//| simple_expr DOT mod_longident DOTOP LBRACKET expr error
	| simple_expr DOT mod_longident DOTOP LPAREN expr RPAREN
	//| simple_expr DOT mod_longident DOTOP LPAREN expr error
	| simple_expr DOT mod_longident DOTOP LBRACE expr RBRACE
	//| simple_expr DOT mod_longident DOTOP LBRACE expr error
	//| simple_expr DOT LBRACE expr_comma_list error
	| LBRACE record_expr RBRACE
	//| LBRACE record_expr error
	| mod_longident DOT LBRACE record_expr RBRACE
	//| mod_longident DOT LBRACE record_expr error
	| LBRACKETBAR expr_semi_list opt_semi BARRBRACKET
	//| LBRACKETBAR expr_semi_list opt_semi error
	| LBRACKETBAR BARRBRACKET
	| mod_longident DOT LBRACKETBAR expr_semi_list opt_semi BARRBRACKET
	| mod_longident DOT LBRACKETBAR BARRBRACKET
	//| mod_longident DOT LBRACKETBAR expr_semi_list opt_semi error
	| LBRACKET expr_semi_list opt_semi RBRACKET
	//| LBRACKET expr_semi_list opt_semi error
	| mod_longident DOT LBRACKET expr_semi_list opt_semi RBRACKET
	| mod_longident DOT LBRACKET RBRACKET
	//| mod_longident DOT LBRACKET expr_semi_list opt_semi error
	| PREFIXOP simple_expr
	| BANG simple_expr
	| LBRACELESS field_expr_list GREATERRBRACE
	//| LBRACELESS field_expr_list error
	| LBRACELESS GREATERRBRACE
	| mod_longident DOT LBRACELESS field_expr_list GREATERRBRACE
	| mod_longident DOT LBRACELESS GREATERRBRACE
	//| mod_longident DOT LBRACELESS field_expr_list error
	| simple_expr HASH label
	| simple_expr HASHOP simple_expr
	| LPAREN MODULE ext_attributes module_expr RPAREN
	| LPAREN MODULE ext_attributes module_expr COLON package_type RPAREN
	//| LPAREN MODULE ext_attributes module_expr COLON error
	| mod_longident DOT LPAREN MODULE ext_attributes module_expr COLON package_type RPAREN
	//| mod_longident DOT LPAREN MODULE ext_attributes module_expr COLON error
	| extension
	;

simple_labeled_expr_list :
	labeled_simple_expr
	| simple_labeled_expr_list labeled_simple_expr
	;

labeled_simple_expr :
	simple_expr %prec below_HASH
	| label_expr
	;

label_expr :
	LABEL simple_expr %prec below_HASH
	| TILDE label_ident
	| QUESTION label_ident
	| OPTLABEL simple_expr %prec below_HASH
	;

label_ident :
	LIDENT
	;

lident_list :
	LIDENT
	| LIDENT lident_list
	;

let_binding_body :
	val_ident strict_binding
	| val_ident type_constraint EQUAL seq_expr
	| val_ident COLON typevar_list DOT core_type EQUAL seq_expr
	| val_ident COLON TYPE lident_list DOT core_type EQUAL seq_expr
	| pattern_no_exn EQUAL seq_expr
	| simple_pattern_not_ident COLON core_type EQUAL seq_expr
	;

let_bindings :
	let_binding
	| let_bindings and_let_binding
	;

let_binding :
	LET ext_attributes rec_flag let_binding_body post_item_attributes
	;

and_let_binding :
	AND attributes let_binding_body post_item_attributes
	;

fun_binding :
	strict_binding
	| type_constraint EQUAL seq_expr
	;

strict_binding :
	EQUAL seq_expr
	| labeled_simple_pattern fun_binding
	| LPAREN TYPE lident_list RPAREN fun_binding
	;

match_cases :
	match_case
	| match_cases BAR match_case
	;

match_case :
	pattern MINUSGREATER seq_expr
	| pattern WHEN seq_expr MINUSGREATER seq_expr
	| pattern MINUSGREATER DOT
	;

fun_def :
	MINUSGREATER seq_expr
	| COLON simple_core_type MINUSGREATER seq_expr
	| labeled_simple_pattern fun_def
	| LPAREN TYPE lident_list RPAREN fun_def
	;

expr_comma_list :
	expr_comma_list COMMA expr
	| expr COMMA expr
	;

record_expr :
	simple_expr WITH lbl_expr_list
	| lbl_expr_list
	;

lbl_expr_list :
	lbl_expr
	| lbl_expr SEMI lbl_expr_list
	| lbl_expr SEMI
	;

lbl_expr :
	label_longident opt_type_constraint EQUAL expr
	| label_longident opt_type_constraint
	;

field_expr_list :
	field_expr opt_semi
	| field_expr SEMI field_expr_list
	;

field_expr :
	label EQUAL expr
	| label
	;

expr_semi_list :
	expr
	| expr_semi_list SEMI expr
	;

type_constraint :
	COLON core_type
	| COLON core_type COLONGREATER core_type
	| COLONGREATER core_type
	//| COLON error
	//| COLONGREATER error
	;

opt_type_constraint :
	type_constraint
	|
	;

pattern :
	pattern AS val_ident
	//| pattern AS error
	| pattern_comma_list  %prec below_COMMA
	| pattern COLONCOLON pattern
	//| pattern COLONCOLON error
	| pattern BAR pattern
	//| pattern BAR error
	| EXCEPTION ext_attributes pattern %prec prec_constr_appl
	| pattern attribute
	| pattern_gen
	;

pattern_no_exn :
	pattern_no_exn AS val_ident
	//| pattern_no_exn AS error
	| pattern_no_exn_comma_list  %prec below_COMMA
	| pattern_no_exn COLONCOLON pattern
	//| pattern_no_exn COLONCOLON error
	| pattern_no_exn BAR pattern
	//| pattern_no_exn BAR error
	| pattern_no_exn attribute
	| pattern_gen
	;

pattern_gen :
	simple_pattern
	| constr_longident pattern %prec prec_constr_appl
	| name_tag pattern %prec prec_constr_appl
	| LAZY ext_attributes simple_pattern
	;

simple_pattern :
	val_ident %prec below_EQUAL
	| simple_pattern_not_ident
	;

simple_pattern_not_ident :
	UNDERSCORE
	| signed_constant
	| signed_constant DOTDOT signed_constant
	| constr_longident
	| name_tag
	| HASH type_longident
	| simple_delimited_pattern
	| mod_longident DOT simple_delimited_pattern
	| mod_longident DOT LBRACKET RBRACKET
	| mod_longident DOT LPAREN RPAREN
	| mod_longident DOT LPAREN pattern RPAREN
	//| mod_longident DOT LPAREN pattern error
	//| mod_longident DOT LPAREN error
	| LPAREN pattern RPAREN
	//| LPAREN pattern error
	| LPAREN pattern COLON core_type RPAREN
	//| LPAREN pattern COLON core_type error
	//| LPAREN pattern COLON error
	| LPAREN MODULE ext_attributes UIDENT RPAREN
	| LPAREN MODULE ext_attributes UIDENT COLON package_type RPAREN
	//| LPAREN MODULE ext_attributes UIDENT COLON package_type error
	| extension
	;

simple_delimited_pattern :
	LBRACE lbl_pattern_list RBRACE
	//| LBRACE lbl_pattern_list error
	| LBRACKET pattern_semi_list opt_semi RBRACKET
	//| LBRACKET pattern_semi_list opt_semi error
	| LBRACKETBAR pattern_semi_list opt_semi BARRBRACKET
	| LBRACKETBAR BARRBRACKET
	//| LBRACKETBAR pattern_semi_list opt_semi error
	;

pattern_comma_list :
	pattern_comma_list COMMA pattern
	| pattern COMMA pattern
	//| pattern COMMA error
	;

pattern_no_exn_comma_list :
	pattern_no_exn_comma_list COMMA pattern
	| pattern_no_exn COMMA pattern
	//| pattern_no_exn COMMA error
	;

pattern_semi_list :
	pattern
	| pattern_semi_list SEMI pattern
	;

lbl_pattern_list :
	lbl_pattern
	| lbl_pattern SEMI
	| lbl_pattern SEMI UNDERSCORE opt_semi
	| lbl_pattern SEMI lbl_pattern_list
	;

lbl_pattern :
	label_longident opt_pattern_type_constraint EQUAL pattern
	| label_longident opt_pattern_type_constraint
	;

opt_pattern_type_constraint :
	COLON core_type
	|
	;

value_description :
	VAL ext_attributes val_ident COLON core_type post_item_attributes
	;

primitive_declaration_body :
	STRING
	| STRING primitive_declaration_body
	;

primitive_declaration :
	EXTERNAL ext_attributes val_ident COLON core_type EQUAL primitive_declaration_body post_item_attributes
	;

type_declarations :
	type_declaration
	| type_declarations and_type_declaration
	;

type_declaration :
	TYPE ext_attributes nonrec_flag optional_type_parameters LIDENT type_kind constraints post_item_attributes
	;

and_type_declaration :
	AND attributes optional_type_parameters LIDENT type_kind constraints post_item_attributes
	;

constraints :
	constraints CONSTRAINT constrain
	|
	;

type_kind :
	/*empty*/
	| EQUAL core_type
	| EQUAL PRIVATE core_type
	| EQUAL constructor_declarations
	| EQUAL PRIVATE constructor_declarations
	| EQUAL DOTDOT
	| EQUAL PRIVATE DOTDOT
	| EQUAL private_flag LBRACE label_declarations RBRACE
	| EQUAL core_type EQUAL private_flag constructor_declarations
	| EQUAL core_type EQUAL private_flag DOTDOT
	| EQUAL core_type EQUAL private_flag LBRACE label_declarations RBRACE
	;

optional_type_parameters :
	/*empty*/
	| optional_type_parameter
	| LPAREN optional_type_parameter_list RPAREN
	;

optional_type_parameter :
	type_variance optional_type_variable
	;

optional_type_parameter_list :
	optional_type_parameter
	| optional_type_parameter_list COMMA optional_type_parameter
	;

optional_type_variable :
	QUOTE ident
	| UNDERSCORE
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

type_parameter_list :
	type_parameter
	| type_parameter_list COMMA type_parameter
	;

constructor_declarations :
	constructor_declaration
	| bar_constructor_declaration
	| constructor_declarations bar_constructor_declaration
	;

constructor_declaration :
	constr_ident generalized_constructor_arguments attributes
	;

bar_constructor_declaration :
	BAR constr_ident generalized_constructor_arguments attributes
	;

str_exception_declaration :
	sig_exception_declaration
	| EXCEPTION ext_attributes constr_ident EQUAL constr_longident attributes post_item_attributes
	;

sig_exception_declaration :
	EXCEPTION ext_attributes constr_ident generalized_constructor_arguments attributes post_item_attributes
	;

let_exception_declaration :
	constr_ident generalized_constructor_arguments attributes
	;

generalized_constructor_arguments :
	/*empty*/
	| OF constructor_arguments
	| COLON constructor_arguments MINUSGREATER simple_core_type
	| COLON simple_core_type
	;

constructor_arguments :
	core_type_list
	| LBRACE label_declarations RBRACE
	;

label_declarations :
	label_declaration
	| label_declaration_semi
	| label_declaration_semi label_declarations
	;

label_declaration :
	mutable_flag label COLON poly_type_no_attr attributes
	;

label_declaration_semi :
	mutable_flag label COLON poly_type_no_attr attributes SEMI attributes
	;

str_type_extension :
	TYPE ext_attributes nonrec_flag optional_type_parameters type_longident PLUSEQ private_flag str_extension_constructors post_item_attributes
	;

sig_type_extension :
	TYPE ext_attributes nonrec_flag optional_type_parameters type_longident PLUSEQ private_flag sig_extension_constructors post_item_attributes
	;

str_extension_constructors :
	extension_constructor_declaration
	| bar_extension_constructor_declaration
	| extension_constructor_rebind
	| bar_extension_constructor_rebind
	| str_extension_constructors bar_extension_constructor_declaration
	| str_extension_constructors bar_extension_constructor_rebind
	;

sig_extension_constructors :
	extension_constructor_declaration
	| bar_extension_constructor_declaration
	| sig_extension_constructors bar_extension_constructor_declaration
	;

extension_constructor_declaration :
	constr_ident generalized_constructor_arguments attributes
	;

bar_extension_constructor_declaration :
	BAR constr_ident generalized_constructor_arguments attributes
	;

extension_constructor_rebind :
	constr_ident EQUAL constr_longident attributes
	;

bar_extension_constructor_rebind :
	BAR constr_ident EQUAL constr_longident attributes
	;

with_constraints :
	with_constraint
	| with_constraints AND with_constraint
	;

with_constraint :
	TYPE optional_type_parameters label_longident with_type_binder core_type_no_attr constraints
	| TYPE optional_type_parameters label_longident COLONEQUAL core_type_no_attr
	| MODULE mod_longident EQUAL mod_ext_longident
	| MODULE mod_longident COLONEQUAL mod_ext_longident
	;

with_type_binder :
	EQUAL
	| EQUAL PRIVATE
	;

typevar_list :
	QUOTE ident
	| typevar_list QUOTE ident
	;

poly_type :
	core_type
	| typevar_list DOT core_type
	;

poly_type_no_attr :
	core_type_no_attr
	| typevar_list DOT core_type_no_attr
	;

core_type :
	core_type_no_attr
	| core_type attribute
	;

core_type_no_attr :
	core_type2 %prec MINUSGREATER
	| core_type2 AS QUOTE ident
	;

core_type2 :
	simple_core_type_or_tuple
	| QUESTION LIDENT COLON core_type2 MINUSGREATER core_type2
	| OPTLABEL core_type2 MINUSGREATER core_type2
	| LIDENT COLON core_type2 MINUSGREATER core_type2
	| core_type2 MINUSGREATER core_type2
	;

simple_core_type :
	simple_core_type2  %prec below_HASH
	| LPAREN core_type_comma_list RPAREN  %prec below_HASH
	;

simple_core_type2 :
	QUOTE ident
	| UNDERSCORE
	| type_longident
	| simple_core_type2 type_longident
	| LPAREN core_type_comma_list RPAREN type_longident
	| LESS meth_list GREATER
	| LESS GREATER
	| HASH class_longident
	| simple_core_type2 HASH class_longident
	| LPAREN core_type_comma_list RPAREN HASH class_longident
	| LBRACKET tag_field RBRACKET
	| LBRACKET BAR row_field_list RBRACKET
	| LBRACKET row_field BAR row_field_list RBRACKET
	| LBRACKETGREATER opt_bar row_field_list RBRACKET
	| LBRACKETGREATER RBRACKET
	| LBRACKETLESS opt_bar row_field_list RBRACKET
	| LBRACKETLESS opt_bar row_field_list GREATER name_tag_list RBRACKET
	| LPAREN MODULE ext_attributes package_type RPAREN
	| extension
	;

package_type :
	module_type
	;

row_field_list :
	row_field
	| row_field_list BAR row_field
	;

row_field :
	tag_field
	| simple_core_type
	;

tag_field :
	name_tag OF opt_ampersand amper_type_list attributes
	| name_tag attributes
	;

opt_ampersand :
	AMPERSAND
	|
	;

amper_type_list :
	core_type_no_attr
	| amper_type_list AMPERSAND core_type_no_attr
	;

name_tag_list :
	name_tag
	| name_tag_list name_tag
	;

simple_core_type_or_tuple :
	simple_core_type
	| simple_core_type STAR core_type_list
	;

core_type_comma_list :
	core_type
	| core_type_comma_list COMMA core_type
	;

core_type_list :
	simple_core_type
	| core_type_list STAR simple_core_type
	;

meth_list :
	field_semi meth_list
	| inherit_field_semi meth_list
	| field_semi
	| field
	| inherit_field_semi
	| simple_core_type
	| DOTDOT
	;

field :
	label COLON poly_type_no_attr attributes
	;

field_semi :
	label COLON poly_type_no_attr attributes SEMI attributes
	;

inherit_field_semi :
	simple_core_type SEMI
	;

label :
	LIDENT
	;

constant :
	INT
	| CHAR
	| STRING
	| FLOAT
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

val_ident :
	LIDENT
	| LPAREN operator RPAREN
	//| LPAREN operator error
	//| LPAREN error
	//| LPAREN MODULE error
	;

operator :
	PREFIXOP
	| INFIXOP0
	| INFIXOP1
	| INFIXOP2
	| INFIXOP3
	| INFIXOP4
	| DOTOP LPAREN RPAREN
	| DOTOP LPAREN RPAREN LESSMINUS
	| DOTOP LBRACKET RBRACKET
	| DOTOP LBRACKET RBRACKET LESSMINUS
	| DOTOP LBRACE RBRACE
	| DOTOP LBRACE RBRACE LESSMINUS
	| HASHOP
	| BANG
	| PLUS
	| PLUSDOT
	| MINUS
	| MINUSDOT
	| STAR
	| EQUAL
	| LESS
	| GREATER
	| OR
	| BARBAR
	| AMPERSAND
	| AMPERAMPER
	| COLONEQUAL
	| PLUSEQ
	| PERCENT
	;

constr_ident :
	UIDENT
	| LBRACKET RBRACKET
	| LPAREN RPAREN
	| LPAREN COLONCOLON RPAREN
	| FALSE
	| TRUE
	;

val_longident :
	val_ident
	| mod_longident DOT val_ident
	;

constr_longident :
	mod_longident  %prec below_DOT
	| mod_longident DOT LPAREN COLONCOLON RPAREN
	| LBRACKET RBRACKET
	| LPAREN RPAREN
	| LPAREN COLONCOLON RPAREN
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
	| mod_ext_longident LPAREN mod_ext_longident RPAREN
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

name_tag :
	BACKQUOTE ident
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

private_flag :
	/*empty*/
	| PRIVATE
	;

mutable_flag :
	/*empty*/
	| MUTABLE
	;

virtual_flag :
	/*empty*/
	| VIRTUAL
	;

private_virtual_flags :
	/*empty*/
	| PRIVATE
	| VIRTUAL
	| PRIVATE VIRTUAL
	| VIRTUAL PRIVATE
	;

override_flag :
	/*empty*/
	| BANG
	;

opt_bar :
	/*empty*/
	| BAR
	;

opt_semi :
	/*empty*/
	| SEMI
	;

subtractive :
	MINUS
	| MINUSDOT
	;

additive :
	PLUS
	| PLUSDOT
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
	| MATCH
	| METHOD
	| MODULE
	| MUTABLE
	| NEW
	| NONREC
	| OBJECT
	| OF
	| OPEN
	| OR
	| PRIVATE
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
	;

post_item_attribute :
	LBRACKETATAT attr_id payload RBRACKET
	;

floating_attribute :
	LBRACKETATATAT attr_id payload RBRACKET
	;

post_item_attributes :
	/*empty*/
	| post_item_attribute post_item_attributes
	;

attributes :
	/*empty*/
	| attribute attributes
	;

ext_attributes :
	/*empty*/
	| attribute attributes
	| PERCENT attr_id attributes
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
	| QUESTION pattern WHEN seq_expr
	;

%%

newline   \n\r?|\r\n?
blank   [  \t\v\f]
lowercase   [a-z_]
uppercase   [A-Z]
identchar   [A-Za-z_'0-9]
symbolchar  [!$%&*+\-./:<=>?@^|~]
dotsymbolchar  [!$%&*+\-/:=>?@^|~]
decimal_literal   [0-9][0-9_]*
hex_digit    [0-9A-Fa-f]
hex_literal    0[xX][0-9A-Fa-f][0-9A-Fa-f_]*
oct_literal    0[oO][0-7][0-7_]*
bin_literal   0[bB][0-1][0-1_]*
int_literal  {decimal_literal}|{hex_literal}|{oct_literal}|{bin_literal}
float_literal   [0-9][0-9_]*("."[0-9_]*)?([eE][+-]?[0-9][0-9_]*)?
hex_float_literal   0[xX][0-9A-F a-f][0-9 A-Fa-f_]*("."[0-9A-Fa-f_]*)?([pP][+-]?[0-9][0-9_]*)?
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
"function"	FUNCTION
"functor"	FUNCTOR
"if"	IF
"in"	IN
"include"	INCLUDE
"inherit"	INHERIT
"initializer"	INITIALIZER
"lazy"	LAZY
"let"	LET
"match"	MATCH
"method"	METHOD
"module"	MODULE
"mutable"	MUTABLE
"new"	NEW
"nonrec"	NONREC
"object"	OBJECT
"of"	OF
"open"	OPEN
"or"	OR
/*  "parser"	PARSER */
"private"	PRIVATE
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

"lor"	INFIXOP3 /* Should be INFIXOP2 */
"lxor"	INFIXOP3 /* Should be INFIXOP2 */
"mod"	INFIXOP3
"land"	INFIXOP3
"lsl"	INFIXOP4
"lsr"	INFIXOP4
"asr"	INFIXOP4


"\\"{newline}	skip()
{newline}	skip()
{blank}+		skip()

"_"	UNDERSCORE
"~"	TILDE
"~"{lowercase}{identchar}*":"	LABEL
"?"	QUESTION
"?"{lowercase}{identchar}*":"	OPTLABEL
{lowercase}{identchar}*	LIDENT
{uppercase}{identchar}*	UIDENT
{int_literal}	INT
{int_literal}{literal_modifier}	INT
{float_literal}|{hex_float_literal}	FLOAT
({float_literal}|{hex_float_literal}){literal_modifier}	FLOAT
\"("\\".|[^"\n\r\\])*\"	STRING
"{"{lowercase}*"|"(?s:.)"|"{lowercase}*"}"	STRING
'("\\".|[^'\n\r\\])+'	CHAR

"(*"<>BLK_COMMENT>
<BLK_COMMENT> {
    "(*"<>BLK_COMMENT>
    (?s:.)<.>
    "*)"<<> skip()
}

"(**"(?s:.)*?"*)"	skip()

"#"[ \t]*[0-9]+.*	skip()

"#"	HASH
"&"	AMPERSAND
"&&"	AMPERAMPER
"`"	BACKQUOTE
"\'"	QUOTE
"("	LPAREN
")"	RPAREN
"*"	STAR
","	COMMA
"->"	MINUSGREATER
"."	DOT
".."	DOTDOT
"."	DOTOP
":"	COLON
"::"	COLONCOLON
":="	COLONEQUAL
":>"	COLONGREATER
";"	SEMI
";;"	SEMISEMI
"<"	LESS
"<-"	LESSMINUS
"="	EQUAL
"["	LBRACKET
"[|"	LBRACKETBAR
"[<"	LBRACKETLESS
"[>"	LBRACKETGREATER
"]"	RBRACKET
"{"	LBRACE
"{<"	LBRACELESS
"|"	BAR
"||"	BARBAR
"|]"	BARRBRACKET
">"	GREATER
//">]"	GREATERRBRACKET
"}"	RBRACE
">}"	GREATERRBRACE
"[@"	LBRACKETAT
"[@@"	LBRACKETATAT
"[@@@"	LBRACKETATATAT
"[%" 	LBRACKETPERCENT
"[%%"	LBRACKETPERCENTPERCENT
"!"	BANG
"!="	INFIXOP0
"+"	PLUS
"+."	PLUSDOT
"+="	PLUSEQ
"-"	MINUS
"-."	MINUSDOT

"!"{symbolchar}+	PREFIXOP
[~?]{symbolchar}+	PREFIXOP
[=<>|&$]{symbolchar}*	INFIXOP0
[@^]{symbolchar}*	INFIXOP1
[+-]{symbolchar}*	INFIXOP2
"**"{symbolchar}*	INFIXOP4
"%"   	PERCENT
[*/%]{symbolchar}*	INFIXOP3
"#"({symbolchar}|"#")+	HASHOP

"#!".*	skip()


%%
