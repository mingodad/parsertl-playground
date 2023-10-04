/*From: https://gitlab.inria.fr/fpottier/menhir/-/blob/master/src/stage1/parser.mly */
/******************************************************************************/
/*                                                                            */
/*                                    Menhir                                  */
/*                                                                            */
/*   Copyright Inria. All rights reserved. This file is distributed under     */
/*   the terms of the GNU General Public License version 2, as described in   */
/*   the file LICENSE.                                                        */
/*                                                                            */
/******************************************************************************/

/* This is the crude version of the parser. It is meant to be processed
   by ocamlyacc. Its existence is necessary for bootstrapping. It is kept
   in sync with [fancy-parser], with a few differences:
   0. [yacc-parser] produces dummy position information;
   1. [fancy-parser] exploits many features of Menhir;
   2. [fancy-parser] performs slightly more refined error handling;
   3. [fancy-parser] supports anonymous rules.
   4. [fancy-parser] supports the new rule syntax. */


%token TOKEN TYPE LEFT RIGHT NONASSOC START PREC PUBLIC COLON BAR EQUAL
%token INLINE LPAREN RPAREN COMMA QUESTION STAR PLUS PARAMETER ON_ERROR_REDUCE
%token PERCENTATTRIBUTE SEMI
%token LID UID QID
%token HEADER
%token OCAMLTYPE
%token PERCENTPERCENT
%token ACTION
%token ATTRIBUTE GRAMMARATTRIBUTE
/* For the new rule syntax: */
//%token LET TILDE UNDERSCORE COLONEQUAL EQUALEQUAL EOF

%start grammar

/* These declarations solve a shift-reduce conflict in favor of
   shifting: when the declaration of a non-terminal symbol begins with
   a leading bar, it is understood as an (insignificant) leading
   optional bar, *not* as an empty right-hand side followed by a bar.
   This ambiguity arises due to the existence of a new notation for
   letting several productions share a single semantic action. */

%nonassoc no_optional_bar
%nonassoc BAR

%%

/* ------------------------------------------------------------------------- */
/* A grammar consists of declarations and rules, followed by an optional
   postlude, which we do not parse. */

grammar:
	declarations PERCENTPERCENT rules postlude
	;

postlude:
	/*EOF
	|*/ PERCENTPERCENT /* followed by actual postlude */
	;

/* ------------------------------------------------------------------------- */
/* A declaration is an %{ OCaml header %}, or a %token, %start,
   %type, %left, %right, or %nonassoc declaration. */

declarations:
	/* epsilon */
	| declarations declaration
	| declarations SEMI
	;

declaration:
	HEADER /* lexically delimited by %{ ... %} */
	| TOKEN optional_ocamltype terminals
	| START nonterminals
	| TYPE OCAMLTYPE actuals
	| START OCAMLTYPE nonterminals
	/* %start <ocamltype> foo is syntactic sugar for %start foo %type <ocamltype> foo */
	| priority_keyword symbols
	| PARAMETER OCAMLTYPE
	| GRAMMARATTRIBUTE
	| PERCENTATTRIBUTE actuals attributes
	| ON_ERROR_REDUCE actuals
	;

optional_ocamltype:
	/* epsilon */
	| OCAMLTYPE /* lexically delimited by angle brackets */
	;

priority_keyword:
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

symbols:
	/* epsilon */
	| symbols optional_comma symbol
	;

symbol:
	LID
	| UID
	| QID
	;

optional_comma:
	/* epsilon */
	| COMMA
	;

attributes:
	/* epsilon */
	| ATTRIBUTE attributes
	;

/* ------------------------------------------------------------------------- */
/* Terminals must begin with an uppercase letter. Nonterminals that are
   declared to be start symbols must begin with a lowercase letter. */

terminals:
	/* epsilon */
	| terminals optional_comma UID optional_alias attributes
	;

nonterminals:
	/* epsilon */
	| nonterminals LID
	;

optional_alias:
	/* epsilon */
	| QID
	;

/* ------------------------------------------------------------------------- */
/* A rule defines a symbol. It is optionally declared %public, and optionally
   carries a number of formal parameters. The right-hand side of the definition
   consists of a list of production groups. */

rules:
	/* epsilon */
	| rules rule
	| rules SEMI
	;

rule:
	flags symbol attributes optional_formal_parameters COLON optional_bar production_group production_groups
	;

flags:
	/* epsilon */
	| PUBLIC
	| INLINE
	| PUBLIC INLINE
	| INLINE PUBLIC
	;

/* ------------------------------------------------------------------------- */
/* Parameters are surroundered with parentheses and delimited by commas.
   The syntax of actual parameters allows applications, whereas the syntax
   of formal parameters does not. It also allows use of the "?", "+", and
   "*" shortcuts. */

optional_formal_parameters:
	/* epsilon */
	| LPAREN formal_parameters RPAREN
	;

formal_parameters:
	symbol
	| symbol COMMA formal_parameters
	;

optional_actuals:
	/* epsilon */
	| LPAREN actuals_comma RPAREN
	;

actuals_comma:
	actual
	| actual COMMA actuals_comma
	;

actual:
	symbol optional_actuals
	| actual modifier
	;

actuals:
	/* epsilon */
	| actuals optional_comma actual
	;

optional_bar:
	/* epsilon */ %prec no_optional_bar
	| BAR
	;

/* ------------------------------------------------------------------------- */
/* The "?", "+", and "*" modifiers are short-hands for applications of
   certain parameterized nonterminals, defined in the standard library. */

modifier:
	QUESTION
	| PLUS
	| STAR
	;

/* ------------------------------------------------------------------------- */
/* A production group is a set of productions that share a semantic action.

   Thus a production group is a list of productions,
   followed by a semantic action,
   followed by an optional precedence specification,
   followed by a possibly empty list of attributes. */

production_groups:
	/* epsilon */
	| production_groups BAR production_group
	;

production_group:
	productions
		ACTION /* action is lexically delimited by braces */
		optional_precedence
		attributes
	;

optional_precedence:
	/* epsilon */
	| PREC symbol
	;

/* ------------------------------------------------------------------------- */
/* A production is a list of producers, optionally followed by a
   precedence declaration. Lists of productions are nonempty and
   separated with bars. */

productions:
	production
	| production bar_productions
	;

bar_productions:
	BAR production
	| BAR production bar_productions
	;

production:
	producers optional_precedence
	;

producers:
	/* epsilon */
	| producers producer
	;

/* ------------------------------------------------------------------------- */
/* A producer is an actual parameter, possibly preceded by a
   binding, and possibly followed with attributes. */

producer:
	actual attributes optional_semis
	| LID EQUAL actual attributes optional_semis
	;

/* ------------------------------------------------------------------------- */
/* Semicolons used to be considered whitespace by our lexer, but are no longer.
   We must allow optional semicolons in a few conventional places. */

optional_semis:
	/* empty */
	| optional_semis SEMI
	;

%%

%x ACTION_ST OBLK_COMMENT CBLK_COMMENT

%%

[ \t\n\r]	skip()

"/*"<>CBLK_COMMENT>
<CBLK_COMMENT> {
    "/*"<>CBLK_COMMENT>
    "*/"<<> skip()
    (?s:.)<.>   skip()
}

"(*"<>OBLK_COMMENT>
<OBLK_COMMENT> {
    "(*"<>OBLK_COMMENT>
    "*)"<<> skip()
    (?s:.)<.>   skip()
}

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

"{"<>ACTION_ST>
<ACTION_ST> {
    "{"<>ACTION_ST>
    [^}]<.>
    "}"<<>  ACTION
}

[a-z][A-Za-z0-9_]*	LID
[A-Z][A-Za-z0-9_]*	UID
\"("\\".|[^"\n\r\\])*\"	QID

%%
