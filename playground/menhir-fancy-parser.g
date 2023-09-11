/*
menhir --only-preprocess-for-ocamlyacc  menhir-fancy-parser.mly > menhir-fancy-parser-yacc.mly
ocamlyacc -v menhir-fancy-parser-yacc.mly
*/

/******************************************************************************/
/*                                                                            */
/*                                    Menhir                                  */
/*                                                                            */
/*   Copyright Inria. All rights reserved. This file is distributed under     */
/*   the terms of the GNU General Public License version 2, as described in   */
/*   the file LICENSE.                                                        */
/*                                                                            */
/******************************************************************************/

/* This is the fancy version of the parser, to be processed by menhir.
   It is kept in sync with [Parser], but exercises menhir's features. */

/* As of 2014/12/02, the $previouserror keyword and the --error-recovery
   mode no longer exist. Thus, we replace all calls to [Error.signal]
   with calls to [Error.error], and report just one error. */

%x ACTION_ST

%token TOKEN TYPE LEFT RIGHT NONASSOC START PREC
%token PUBLIC COLON BAR EQUAL INLINE LPAREN
%token RPAREN COMMA QUESTION STAR PLUS PARAMETER
%token ON_ERROR_REDUCE PERCENTATTRIBUTE SEMI

//%token EOF

%token LID UID QID
%token HEADER
%token OCAMLTYPE
%token PERCENTPERCENT
%token ACTION
%token ATTRIBUTE GRAMMARATTRIBUTE

/* For the new rule syntax: */
%token LET TILDE UNDERSCORE COLONEQUAL EQUALEQUAL

/* ------------------------------------------------------------------------- */
/* Type annotations and start symbol. */

%start grammar

/* ------------------------------------------------------------------------- */
/* Priorities. */

/* These declarations solve a shift-reduce conflict in favor of shifting: when
   the right-hand side of an old-style rule begins with a leading bar, this
   bar is understood as an (insignificant) leading optional bar, *not* as an
   empty right-hand side followed by a bar. This ambiguity arises due to the
   possibility for several productions to share a single semantic action.
   The new rule syntax does not have this possibility, and has no ambiguity. */

%nonassoc no_optional_bar
%nonassoc BAR


%%

option_COMMA_ :
	/*empty*/
	| COMMA
	;

option_OCAMLTYPE_ :
	/*empty*/
	| OCAMLTYPE
	;

option_QID_ :
	/*empty*/
	| QID
	;

boption_PUBLIC_ :
	/*empty*/
	| PUBLIC
	;

loption_delimited_LPAREN_separated_nonempty_list_COMMA_expression__RPAREN__ :
	/*empty*/
	| LPAREN separated_nonempty_list_COMMA_expression_ RPAREN
	;

loption_delimited_LPAREN_separated_nonempty_list_COMMA_lax_actual__RPAREN__ :
	/*empty*/
	| LPAREN separated_nonempty_list_COMMA_lax_actual_ RPAREN
	;

loption_delimited_LPAREN_separated_nonempty_list_COMMA_strict_actual__RPAREN__ :
	/*empty*/
	| LPAREN separated_nonempty_list_COMMA_strict_actual_ RPAREN
	;

loption_delimited_LPAREN_separated_nonempty_list_COMMA_symbol__RPAREN__ :
	/*empty*/
	| LPAREN separated_nonempty_list_COMMA_symbol_ RPAREN
	;

loption_separated_nonempty_list_COMMA_pattern__ :
	/*empty*/
	| separated_nonempty_list_COMMA_pattern_
	;

list_ATTRIBUTE_ :
	/*empty*/
	| ATTRIBUTE list_ATTRIBUTE_
	;

list_SEMI_ :
	/*empty*/
	| SEMI list_SEMI_
	;

list_declaration_ :
	/*empty*/
	| declaration list_declaration_
	;

list_producer_ :
	/*empty*/
	| producer list_producer_
	;

/* ------------------------------------------------------------------------- */
/* A rule is expressed either in the traditional (yacc-style) syntax or in
   the new syntax. */

list_rule_ :
	/*empty*/
	| old_rule list_rule_
	/* The new syntax is converted on the fly to the old syntax. */
	| new_rule list_rule_
	;

nonempty_list_ATTRIBUTE_ :
	ATTRIBUTE
	| ATTRIBUTE nonempty_list_ATTRIBUTE_
	;

separated_nonempty_list_BAR_production_ :
	production
	| production BAR separated_nonempty_list_BAR_production_
	;

separated_nonempty_list_BAR_production_group_ :
	production_group
	| production_group BAR separated_nonempty_list_BAR_production_group_
	;

separated_nonempty_list_COMMA_expression_ :
	expression
	| expression COMMA separated_nonempty_list_COMMA_expression_
	;

separated_nonempty_list_COMMA_lax_actual_ :
	lax_actual
	| lax_actual COMMA separated_nonempty_list_COMMA_lax_actual_
	;

separated_nonempty_list_COMMA_pattern_ :
	pattern
	| pattern COMMA separated_nonempty_list_COMMA_pattern_
	;

separated_nonempty_list_COMMA_strict_actual_ :
	strict_actual
	| strict_actual COMMA separated_nonempty_list_COMMA_strict_actual_
	;

separated_nonempty_list_COMMA_symbol_ :
	symbol
	| symbol COMMA separated_nonempty_list_COMMA_symbol_
	;

separated_nonempty_list_option_COMMA__nonterminal_ :
	LID
	| LID option_COMMA_ separated_nonempty_list_option_COMMA__nonterminal_
	;

separated_nonempty_list_option_COMMA__strict_actual_ :
	strict_actual
	| strict_actual option_COMMA_ separated_nonempty_list_option_COMMA__strict_actual_
	;

separated_nonempty_list_option_COMMA__symbol_ :
	symbol
	| symbol option_COMMA_ separated_nonempty_list_option_COMMA__symbol_
	;

/* ------------------------------------------------------------------------- */
/* Terminals must begin with an uppercase letter. Nonterminals that are
   declared to be start symbols must begin with a lowercase letter. */

/* In declarations, terminals must be UIDs, but we may also declare
   token aliases, which are QIDs. */

separated_nonempty_list_option_COMMA__terminal_alias_attrs_ :
	UID option_QID_ list_ATTRIBUTE_
	| UID option_QID_ list_ATTRIBUTE_ option_COMMA_ separated_nonempty_list_option_COMMA__terminal_alias_attrs_
	;

/* ------------------------------------------------------------------------- */
/* A grammar consists of declarations and rules, followed by an optional
   postlude, which we do not parse. */

grammar :
	list_declaration_ PERCENTPERCENT list_rule_ postlude
	;

/* ------------------------------------------------------------------------- */
/* A declaration is an %{ OCaml header %}, or a %token, %start,
   %type, %left, %right, or %nonassoc declaration. */

declaration :
	HEADER
	| TOKEN option_OCAMLTYPE_ separated_nonempty_list_option_COMMA__terminal_alias_attrs_
	| START option_OCAMLTYPE_ separated_nonempty_list_option_COMMA__nonterminal_
	/* %start <ocamltype> foo is syntactic sugar for %start foo %type <ocamltype> foo */
	| TYPE OCAMLTYPE separated_nonempty_list_option_COMMA__strict_actual_
	| priority_keyword separated_nonempty_list_option_COMMA__symbol_
	| PARAMETER OCAMLTYPE
	| GRAMMARATTRIBUTE
	| PERCENTATTRIBUTE separated_nonempty_list_option_COMMA__strict_actual_ nonempty_list_ATTRIBUTE_
	| ON_ERROR_REDUCE separated_nonempty_list_option_COMMA__strict_actual_
	| SEMI
	/* This production recognizes tokens that are valid in the rules section,
	   but not in the declarations section. This is a hint that a %% was
	   forgotten. */
	| PUBLIC
	| INLINE
	| COLON
	| LET
	//| EOF
	;

priority_keyword :
	LEFT
	| RIGHT
	| NONASSOC
	;

/* ------------------------------------------------------------------------- */
/* A symbol is a terminal or nonterminal symbol. */

/* One would like to require nonterminal symbols to begin with a lowercase
   letter, so as to lexically distinguish them from terminal symbols, which
   must begin with an uppercase letter. However, for compatibility with
   ocamlyacc, this is impossible. It can be required only for nonterminal
   symbols that are also start symbols. */

/* We also accept token aliases in place of ordinary terminal symbols.
   Token aliases are quoted strings. */

symbol :
	LID
	| UID
	| QID
	;

/* ------------------------------------------------------------------------- */
/* A rule defines a symbol. It is optionally declared %public, and optionally
   carries a number of formal parameters. The right-hand side of the definition
   consists of a list of productions. */

old_rule :
	flags symbol list_ATTRIBUTE_ loption_delimited_LPAREN_separated_nonempty_list_COMMA_symbol__RPAREN__ COLON optional_bar separated_nonempty_list_BAR_production_group_ list_SEMI_
	;

flags :
	/*empty*/
	| PUBLIC
	| INLINE
	| PUBLIC INLINE
	| INLINE PUBLIC
	;

optional_bar :
	/*empty*/ %prec no_optional_bar
	| BAR
	;

/* ------------------------------------------------------------------------- */
/* A production group is a set of productions that share a semantic action.

   Thus a production group is a list of productions,
   followed by a semantic action,
   followed by an optional precedence specification,
   followed by a possibly empty list of attributes. */

production_group :
	separated_nonempty_list_BAR_production_ ACTION list_ATTRIBUTE_
	| separated_nonempty_list_BAR_production_ ACTION precedence list_ATTRIBUTE_
	;

precedence :
	PREC symbol
	;

/* ------------------------------------------------------------------------- */
/* A production is a list of producers, optionally followed by a
   precedence declaration. */

production :
	list_producer_
	| list_producer_ precedence
	;

/* ------------------------------------------------------------------------- */
/* A producer is an actual parameter, possibly preceded by a
   binding, and possibly followed with attributes.

   Because both [ioption] and [terminated] are defined as inlined by
   the standard library, this definition expands to two productions,
   one of which begins with id = LID, the other of which begins with
   p = actual. The token LID is in FIRST(actual),
   but the LR(1) formalism can deal with that. If [option] was used
   instead of [ioption], an LR(1) conflict would arise -- looking
   ahead at LID would not allow determining whether to reduce an
   empty [option] or to shift. */

producer :
	actual list_ATTRIBUTE_ list_SEMI_
	| LID EQUAL actual list_ATTRIBUTE_ list_SEMI_
	;

/* ------------------------------------------------------------------------- */
/* The ideal syntax of actual parameters includes:
   1. a symbol, optionally applied to a list of actual parameters;
   2. an actual parameter followed with a modifier;
   3. an anonymous rule. (Not delimited by parentheses! Otherwise
      one would often end up writing two pairs of parentheses.) */

/* In order to avoid a few ambiguities, we restrict this ideal syntax as
   follows:
   a. Within a %type declaration, we use [strict_actual], which
      allows 1- and 2- (this is undocumented; the documentation says we
      require a symbol) but not 3-, which would not make semantic sense
      anyway.
   b. Within a producer, we use [actual], which allows 1- and
      2- but not 3-. Case 3- is allowed by switching to [lax_actual]
      within the actual arguments of an application, which are clearly
      delimited by parentheses and commas.
   c. In front of a modifier, we can never allow [lax_actual],
      as this would create an ambiguity: basically, [A | B?] could be
      interpreted either as [(A | B)?] or as [A | (B?)].
*/

strict_actual :
	symbol loption_delimited_LPAREN_separated_nonempty_list_COMMA_strict_actual__RPAREN__
	| strict_actual located_modifier_
	;

actual :
	symbol loption_delimited_LPAREN_separated_nonempty_list_COMMA_lax_actual__RPAREN__
	| actual located_modifier_
	;

lax_actual :
	symbol loption_delimited_LPAREN_separated_nonempty_list_COMMA_lax_actual__RPAREN__
	| actual located_modifier_
	| located_branches_
	;

/* ------------------------------------------------------------------------- */
/* The "?", "+", and "*" modifiers are short-hands for applications of
   certain parameterized nonterminals, defined in the standard library. */

modifier :
	QUESTION
	| PLUS
	| STAR
	;

/* ------------------------------------------------------------------------- */
/* A postlude is announced by %%, but is optional. */

postlude :
	/*EOF
	|*/ PERCENTPERCENT
	;

/* -------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------- */

/* The new rule syntax. */

/* Whereas the old rule syntax allows a nonterminal symbol to begin with an
   uppercase letter, the new rule syntax disallows it. The left-hand side of a
   new rule must be a lowercase identifier [LID]. */

/* A new rule *cannot* be terminated by a semicolon. (This is contrast with a
   traditional rule, which can be followed with any number of semicolons.) We
   are forced to forbid the use of semicolons as a rule terminator because
   they are used already as a sequencing construct. Permitting both uses would
   give rise to a shift/reduce conflict that we would not be able to solve. */

new_rule :
	boption_PUBLIC_ LET LID list_ATTRIBUTE_ loption_delimited_LPAREN_separated_nonempty_list_COMMA_symbol__RPAREN__ equality_symbol expression
	;

/* A new rule is written [let foo := ...] or [let foo == ...].
   In the former case, we get an ordinary nonterminal symbol;
   in the latter case, we get an %inline nonterminal symbol. */

equality_symbol :
	COLONEQUAL
	| EQUALEQUAL
	;

/* The right-hand side of a new rule is an expression. */

/* An expression is a choice expression. */

expression :
	located_choice_expression_
	;

/* A sequence expression takes one of the following forms:

         e1; e2     a sequence that binds no variables (sugar for _ = e1; e2)
     p = e1; e2     a sequence that binds the variables in the pattern p

   or is an symbol expression or an action expression. */

/* Allowing an symbol expression [e] where a sequence expression is expected
   can be understood as syntactic sugar for [x = e; { x }]. */

/* In a sequence [e1; e2] or [p = e1; e2], the left-hand expression [e1] is
   *not* allowed to be an action expression. That would be a Bison-style
   midrule action. Instead, one must explicitly write [midrule({ ... })]. */

/* In a sequence, the semicolon cannot be omitted. This is in contrast with
   old-style rules, where semicolons are optional. Here, semicolons are
   required for disambiguation: indeed, in the absence of mandatory
   semicolons, when a sequence begins with x(y,z), it would be unclear whether
   1- x is a parameterized symbol and (y,z) are its actual arguments, or 2- x
   is unparameterized and (y, z) is a tuple pattern which forms the beginning
   of the next element of the sequence. */

/* We *could* allow the semicolon to be omitted when it precedes an action
   expression (as opposed to a sequence expression). This would be implemented
   in the definition of the nonterminal symbol [continuation]. We choose not
   to do this, as we wish to make it clear in this case that this is a
   sequence whose last element is the action expression. */

raw_seq_expression :
	symbol_expression SEMI located_raw_seq_expression_
	| pattern EQUAL symbol_expression SEMI located_raw_seq_expression_
	| symbol_expression
	| action_expression
	;

/* A symbol expression takes one of the following forms:

     foo(...)       a terminal or nonterminal symbol (with parameters)
     e*             same as above
     e+             same as above
     e?             same as above */

/* Note the absence of parenthesized expressions [(e)] in the syntax of symbol
   expressions. There are two reasons why they are omitted. At the syntactic
   level, introducing them would create a conflict. At a semantic level, they
   are both unnecessary and ambiguous, as one can instead write [endrule(e)]
   or [midrule(e)] and thereby indicate whether the anonymous nonterminal
   symbol that is generated should or should not be marked %inline. */

symbol_expression :
	symbol loption_delimited_LPAREN_separated_nonempty_list_COMMA_expression__RPAREN__ list_ATTRIBUTE_
	| located_symbol_expression_ located_modifier_ list_ATTRIBUTE_
	;

/* An action expression is a semantic action, optionally preceded or followed
   with a precedence annotation. */

action_expression :
	action list_ATTRIBUTE_
	| precedence action list_ATTRIBUTE_
	| action precedence list_ATTRIBUTE_
	;

/* A semantic action is either a traditional semantic action (an OCaml
   expression between curly braces) or a point-free semantic action (an
   optional OCaml identifier between angle brackets). */

/* The token OCAMLTYPE, which until now was supposed to denote an OCaml
   type between angle brackets, is re-used for this purpose. This is not
   very pretty. */

/* The stretch produced by the lexer is validated -- i.e., we check that
   it contains just an OCaml identifier, or is empty. The parentheses
   added by the lexer to the [stretch_content] field are removed (ugh!)
   because they are problematic when this identifier is a data constructor. */

action :
	ACTION
	| OCAMLTYPE
	;

/* Patterns. */

pattern :
	LID
	| UNDERSCORE
	| TILDE
	| LPAREN loption_separated_nonempty_list_COMMA_pattern__ RPAREN
	;

reversed_preceded_or_separated_nonempty_llist_BAR_branch_ :
	located_raw_seq_expression_
	| BAR located_raw_seq_expression_
	| reversed_preceded_or_separated_nonempty_llist_BAR_branch_ BAR located_raw_seq_expression_
	;

located_branches_ :
	separated_nonempty_list_BAR_production_group_
	;

/* A choice expression is a bar-separated list of alternatives, with an
   optional leading bar, which is ignored. Each alternative is a sequence
   expression. */

/* We cannot allow a choice expression to be empty, even though that would
   make semantic sense (the empty sum is void). Indeed, that would create a
   shift/reduce conflict: after reading [def x = y], it would be unclear
   whether this is a definition of [x] as an alias for [y], or a definition of
   [x] as an alias for the empty sum, followed with an old-style rule that
   happens to begin with [y]. */

located_choice_expression_ :
	reversed_preceded_or_separated_nonempty_llist_BAR_branch_
	;

located_modifier_ :
	modifier
	;

located_raw_seq_expression_ :
	raw_seq_expression
	;

located_symbol_expression_ :
	symbol_expression
	;

%%

%%

[ \t\n\r]	skip()
"/*"(?s:.)*?"*/"	skip()
"(*"(?s:.)*?"*)"	skip()


"[".+?"]"	ATTRIBUTE
"%attribute" PERCENTATTRIBUTE
"|"              BAR
":"            COLON
","            COMMA
"="            EQUAL
"%[".+?"]"	GRAMMARATTRIBUTE
"%inline"           INLINE
"%left"             LEFT
"("           LPAREN
"%nonassoc"         NONASSOC
"%on_error_reduce"  ON_ERROR_REDUCE
"%parameter"        PARAMETER
"%%"	PERCENTPERCENT
"+"             PLUS
"%prec"             PREC
"%public"           PUBLIC
"?"         QUESTION
"%right"            RIGHT
")"           RPAREN
";"             SEMI
"%{"(?s:.)*?"%}"	HEADER
"*"             STAR
"%start"            START
"%token"            TOKEN
"%type"             TYPE
"<".+?">"	OCAMLTYPE

"let"  LET
"~"  TILDE
"_"  UNDERSCORE
":="  COLONEQUAL
"=="  EQUALEQUAL

"{"<>ACTION_ST>
<ACTION_ST> {
    "{"<>ACTION_ST>
    [^}]<.>
    "}"<<>  ACTION
}

[a-z][A-Za-z0-9_]*	LID
[A-Z][A-Z0-9_]*	UID
\"("\\".|[^"\n\r\\])*\"	QID

%%
