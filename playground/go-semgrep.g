
/* // Copyright 2009 The Go Authors. All rights reserved.
 * // Use of this source code is governed by a BSD-style
 * // license that can be found in the LICENSE file.
 *
 * // Go language grammar.
 * //
 * // The Go semicolon rules are:
 * //
 * //  1. all statements and declarations are terminated by semicolons.
 * //  2. semicolons can be omitted before a closing ) or }.
 * //  3. semicolons are inserted by the lexer before a newline
 * //      following a specific list of tokens.
 * //
 * // Rules #1 and #2 are accomplished by writing the lists as
 * // semicolon-separated lists with an optional trailing semicolon.
 * // Rule #3 is implemented in yylex.
 *
 * src: this is mostly an ocamlyacc port of the Go yacc grammar in
 *  src/cmd/compile/internal/gc/go.y in commit
 *  b5fe07710f4a31bfc100fbc2e344be11e4b4d3fc^ in the golang source code
 *  at https://github.com/golang/go
 */
/*
# -*- org -*-

* if header and loop body

Go allow if/for/switch/select to omit the parenthesis around
the conditional/iterator/... as in

  if true { ... }

However, this forces the grammar to introduce a special token
for the left brace of the then body (called loop_body in the grammar).
TODO: why?

Thus, some LBRACE must be retagged as LBODY to maintain a simple
unambiguous grammar. This is currently done in parsing_hacks_go.ml
by using a braced view (see ast_fuzzy.ml) to easily match and find
the right '{' to retag (basically the one following an if/for/switch/select.



* Typename and CompositeLit

From golang spec:

"A parsing ambiguity arises when a composite literal using the TypeName
form of the LiteralType appears as an operand between the keyword and
the opening brace of the block of an "if", "for", or "switch"
statement, and the composite literal is not enclosed in parentheses,
square brackets, or curly braces. In this rare case, the opening brace
of the literal is erroneously parsed as the one introducing the block
of statements. To resolve the ambiguity, the composite literal must
appear within parentheses."

if x == (T{a,b,c}[i]) { ... }
if (x == T{a,b,c}[i]) { ... }
*/

//%token EOF
%token LAND
%token LANDAND
%token LANDNOT
%token LASOP
%token LBANG
%token LBODY
%token LBRACE
//%token LBRACE_SEMGREP
%token LBRACKET
%token LBREAK
%token LCASE
%token LCHAN
%token LCOLAS
%token LCOLON
//%token LCOLON_SEMGREP
%token LCOMM
%token LCOMMA
%token LCONST
%token LCONTINUE
%token LDDD
%token LDEC
%token LDEFAULT
%token LDEFER
%token LDIV
%token LDOT
%token LDots
%token LELSE
%token LEQ
%token LEQEQ
%token LFALL
%token LFLOAT
%token LFOR
%token LFUNC
%token LGE
%token LGO
%token LGOTO
%token LGT
%token LHAT
%token LIF
%token LIMAG
%token LIMPORT
%token LINC
%token LINT
%token LINTERFACE
%token LLE
%token LLSH
%token LLT
%token LMAP
%token LMINUS
%token LMULT
%token LNAME
%token LNE
%token LOROR
%token LPACKAGE
%token LPAREN
//%token LPAREN_SEMGREP
%token LPERCENT
%token LPIPE
%token LPLUS
%token LRANGE
%token LRETURN
%token LRSH
%token LRUNE
%token LSELECT
%token LSEMICOLON
%token LSTR
%token LSTRUCT
%token LSWITCH
%token LTYPE
%token LVAR
%token RBRACE
%token RBRACKET
%token RDots
%token RPAREN
//%token TComment
//%token TCommentNewline
//%token TCommentSpace
//%token TUnknown

%left LCOMM
%left LOROR
%left LANDAND
%left LEQEQ LGE LGT LLE LLT LNE
%left LHAT LMINUS LPIPE LPLUS
%left LAND LANDNOT LDIV LLSH LMULT LPERCENT LRSH
%left NotParen
%left LPAREN

%start file

%%

option_LCOMMA_ :
	/*empty*/
	| LCOMMA
	;

option_LSEMICOLON_ :
	/*empty*/
	| LSEMICOLON
	;

option_LSTR_ :
	/*empty*/
	| LSTR
	;

option_expr_ :
	/*empty*/
	| expr
	;

option_new_name_ :
	/*empty*/
	| sym
	;

option_simple_stmt_ :
	/*empty*/
	| simple_stmt
	;

list_sep_dcl_name_LCOMMA_ :
	sym
	| list_sep_dcl_name_LCOMMA_ LCOMMA sym
	;

list_sep_expr_LCOMMA_ :
	expr
	| list_sep_expr_LCOMMA_ LCOMMA expr
	;

list_sep_expr_or_type_LCOMMA_ :
	expr_or_type
	| list_sep_expr_or_type_LCOMMA_ LCOMMA expr_or_type
	;

list_sep_new_name_LCOMMA_ :
	sym
	| list_sep_new_name_LCOMMA_ LCOMMA sym
	;

list_sep_stmt_LSEMICOLON_ :
	stmt
	| list_sep_stmt_LSEMICOLON_ LSEMICOLON stmt
	;

listsc_stmt_ :
	list_sep_stmt_LSEMICOLON_
	;

listc_dcl_name_ :
	list_sep_dcl_name_LCOMMA_
	;

listc_expr_ :
	list_sep_expr_LCOMMA_
	;

listc_expr_or_type_ :
	list_sep_expr_or_type_LCOMMA_
	;

listc_new_name_ :
	list_sep_new_name_LCOMMA_
	;

list_sep_term_import_stmt_or_dots_LSEMICOLON_ :
	/*import_stmt_or_dots
	|*/ import_stmt_or_dots LSEMICOLON
	| list_sep_term_import_stmt_or_dots_LSEMICOLON_ import_stmt_or_dots LSEMICOLON
	;

list_sep_term_interfacedcl_LSEMICOLON_ :
	/*interfacedcl
	|*/ interfacedcl LSEMICOLON
	| list_sep_term_interfacedcl_LSEMICOLON_ interfacedcl LSEMICOLON
	;

list_sep_term_structdcl_LSEMICOLON_ :
	/*structdcl
	|*/ structdcl LSEMICOLON
	| list_sep_term_structdcl_LSEMICOLON_ structdcl LSEMICOLON
	;

list_sep_term_typedcl_LSEMICOLON_ :
	/*typedcl
	|*/ typedcl LSEMICOLON
	| list_sep_term_typedcl_LSEMICOLON_ typedcl LSEMICOLON
	;

list_sep_term_vardcl_LSEMICOLON_ :
	/*vardcl
	|*/ vardcl LSEMICOLON
	| list_sep_term_vardcl_LSEMICOLON_ vardcl LSEMICOLON
	;

listsc_t_import_stmt_or_dots_ :
	list_sep_term_import_stmt_or_dots_LSEMICOLON_
	;

listsc_t_interfacedcl_ :
	list_sep_term_interfacedcl_LSEMICOLON_
	;

listsc_t_structdcl_ :
	list_sep_term_structdcl_LSEMICOLON_
	;

listsc_t_typedcl_ :
	list_sep_term_typedcl_LSEMICOLON_
	;

listsc_t_vardcl_ :
	list_sep_term_vardcl_LSEMICOLON_
	;

file :
	package LSEMICOLON imports xdcl_list //EOF
	;

package :
	LPACKAGE sym
	;

//sgrep_spatch_pattern :
//	item option_LSEMICOLON_ EOF
//	| item LSEMICOLON item LSEMICOLON item_list EOF
//	| name LPAREN_SEMGREP oarg_type_list_ocomma RPAREN fnret_type option_LSEMICOLON_ EOF
//	| partial EOF
//	;

//partial :
//	LBRACE_SEMGREP braced_keyval_list RBRACE option_LSEMICOLON_
//	| LNAME LCOLON_SEMGREP complitexpr option_LSEMICOLON_
//	;

//item :
//	stmt
//	| import
//	| package
//	| xfndcl
//	;

//item_list :
//	item
//	| item_list LSEMICOLON item
//	;

import :
	LIMPORT import_stmt
	| LIMPORT LPAREN listsc_t_import_stmt_or_dots_ RPAREN
	| LIMPORT LPAREN RPAREN
	;

import_stmt_or_dots :
	import_stmt
	| LDDD
	;

import_stmt :
	LSTR
	| sym LSTR
	| LDOT LSTR
	;

xdcl :
	common_dcl
	| xfndcl
	;

common_dcl :
	LVAR vardcl
	| LVAR LPAREN listsc_t_vardcl_ RPAREN
	| LVAR LPAREN RPAREN
	| LCONST constdcl
	| LCONST LPAREN constdcl option_LSEMICOLON_ RPAREN
	| LCONST LPAREN constdcl LSEMICOLON constdcl1_list option_LSEMICOLON_ RPAREN
	| LCONST LPAREN RPAREN
	| LTYPE typedcl
	| LTYPE LPAREN listsc_t_typedcl_ RPAREN
	| LTYPE LPAREN RPAREN
	;

vardcl :
	listc_dcl_name_ ntype
	| listc_dcl_name_ ntype LEQ listc_expr_
	| listc_dcl_name_ LEQ listc_expr_
	;

constdcl :
	listc_dcl_name_ ntype LEQ listc_expr_
	| listc_dcl_name_ LEQ listc_expr_
	;

constdcl1 :
	constdcl
	| listc_dcl_name_ ntype
	| listc_dcl_name_
	;

typedcl :
	sym ntype
	| sym LEQ ntype
	;

stmt :
	/*empty*/
	| compound_stmt
	| common_dcl
	| non_dcl_stmt
	;

compound_stmt :
	LBRACE listsc_stmt_ RBRACE
	;

non_dcl_stmt :
	simple_stmt
	| if_stmt
	| for_stmt
	| switch_stmt
	| select_stmt
	| sym LCOLON stmt
	| LGOTO sym
	| LBREAK option_new_name_
	| LCONTINUE option_new_name_
	| LRETURN oexpr_list
	| LFALL
	| LGO pseudocall
	| LDEFER pseudocall
	;

simple_stmt :
	expr
	| expr LASOP expr
	| listc_expr_ LEQ listc_expr_
	| listc_expr_ LCOLAS listc_expr_
	| expr LINC
	| expr LDEC
	;

if_stmt :
	LIF if_header loop_body elseif_list else_
	;

if_header :
	option_simple_stmt_
	| option_simple_stmt_ LSEMICOLON option_simple_stmt_
	;

elseif :
	LELSE LIF if_header loop_body
	;

else_ :
	/*empty*/
	| LELSE compound_stmt
	;

for_stmt :
	LFOR option_simple_stmt_ LSEMICOLON option_simple_stmt_ LSEMICOLON option_simple_stmt_ loop_body
	| LFOR simple_stmt loop_body
	| LFOR loop_body
	| LFOR listc_expr_ LEQ LRANGE expr loop_body
	| LFOR listc_expr_ LCOLAS LRANGE expr loop_body
	| LFOR LRANGE expr loop_body
	;

loop_body :
	LBODY listsc_stmt_ RBRACE
	;

switch_stmt :
	LSWITCH if_header LBODY caseblock_list RBRACE
	;

select_stmt :
	LSELECT LBODY caseblock_list RBRACE
	;

case :
	LCASE listc_expr_or_type_ LCOLON
	| LCASE listc_expr_or_type_ LEQ expr LCOLON
	| LCASE listc_expr_or_type_ LCOLAS expr LCOLON
	| LDEFAULT LCOLON
	;

caseblock_list :
	/*empty*/
	| caseblock_list caseblock
	;

caseblock :
	case listsc_stmt_
	| LCASE LDDD option_LSEMICOLON_
	;

expr :
	uexpr
	| expr LOROR expr
	| expr LANDAND expr
	| expr LEQEQ expr
	| expr LNE expr
	| expr LLT expr
	| expr LLE expr
	| expr LGE expr
	| expr LGT expr
	| expr LPLUS expr
	| expr LMINUS expr
	| expr LPIPE expr
	| expr LHAT expr
	| expr LMULT expr
	| expr LDIV expr
	| expr LPERCENT expr
	| expr LAND expr
	| expr LANDNOT expr
	| expr LLSH expr
	| expr LRSH expr
	| expr LCOMM expr
	| LDDD
	| LDots expr RDots
	;

uexpr :
	pexpr
	| LMULT uexpr
	| LAND uexpr
	| LPLUS uexpr
	| LMINUS uexpr
	| LBANG uexpr
	| LHAT uexpr
	| LCOMM uexpr
	;

pexpr :
	pexpr_no_paren
	| LPAREN expr_or_type RPAREN
	;

pexpr_no_paren :
	basic_literal
	| name
	| LPAREN name LCOLON ntype RPAREN
	| pexpr LDOT sym
	| pexpr LDOT LDDD
	| pexpr LDOT LPAREN expr_or_type RPAREN
	| pexpr LDOT LPAREN LTYPE RPAREN
	| pexpr LBRACKET expr RBRACKET
	| pexpr LBRACKET option_expr_ LCOLON option_expr_ RBRACKET
	| pexpr LBRACKET option_expr_ LCOLON option_expr_ LCOLON option_expr_ RBRACKET
	| pseudocall
	| convtype LPAREN expr option_LCOMMA_ RPAREN
	| comptype lbrace braced_keyval_list RBRACE
	| pexpr_no_paren LBRACE braced_keyval_list RBRACE
	| fnliteral
	;

basic_literal :
	LINT
	| LFLOAT
	| LIMAG
	| LRUNE
	| LSTR
	;

pseudocall :
	pexpr LPAREN RPAREN
	| pexpr LPAREN arguments option_LCOMMA_ RPAREN
	| pexpr LPAREN arguments LDDD option_LCOMMA_ RPAREN
	;

arguments :
	argument
	| arguments LCOMMA argument
	;

argument :
	expr_or_type
	;

braced_keyval_list :
	/*empty*/
	| keyval_list option_LCOMMA_
	;

keyval_list :
	keyval
	| bare_complitexpr
	| keyval_list LCOMMA keyval
	| keyval_list LCOMMA bare_complitexpr
	;

keyval :
	complitexpr LCOLON complitexpr
	;

complitexpr :
	expr
	| LBRACE braced_keyval_list RBRACE
	;

bare_complitexpr :
	LDDD LSEMICOLON
	| expr
	| LBRACE braced_keyval_list RBRACE
	;

lbrace :
	LBODY
	| LBRACE
	;

sym :
	LNAME
	;

name :
	sym %prec NotParen
	;

dotname :
	name
	| name LDOT sym
	;

packname :
	LNAME
	| LNAME LDOT sym
	;

ntype :
	dotname
	| ptrtype
	| recvchantype
	| fntype
	| othertype
	| LPAREN ntype RPAREN
	;

non_recvchantype :
	dotname
	| ptrtype
	| fntype
	| othertype
	| LPAREN ntype RPAREN
	;

ptrtype :
	LMULT ntype
	;

recvchantype :
	LCOMM LCHAN ntype
	;

fntype :
	LFUNC LPAREN oarg_type_list_ocomma RPAREN fnres
	;

fnres :
	/*empty*/ %prec NotParen
	| fnret_type
	| LPAREN oarg_type_list_ocomma RPAREN
	;

fnret_type :
	dotname
	| ptrtype
	| recvchantype
	| fntype
	| othertype
	;

othertype :
	LBRACKET oexpr_no_dots RBRACKET ntype
	| LBRACKET LDDD RBRACKET ntype
	| LCHAN non_recvchantype
	| LCHAN LCOMM ntype
	| LMAP LBRACKET ntype RBRACKET ntype
	| structtype
	| interfacetype
	;

oexpr_no_dots :
	/*empty*/
	| expr_no_dots
	;

expr_no_dots :
	uexpr
	| expr LOROR expr
	| expr LANDAND expr
	| expr LEQEQ expr
	| expr LNE expr
	| expr LLT expr
	| expr LLE expr
	| expr LGE expr
	| expr LGT expr
	| expr LPLUS expr
	| expr LMINUS expr
	| expr LPIPE expr
	| expr LHAT expr
	| expr LMULT expr
	| expr LDIV expr
	| expr LPERCENT expr
	| expr LAND expr
	| expr LANDNOT expr
	| expr LLSH expr
	| expr LRSH expr
	| expr LCOMM expr
	;

dotdotdot :
	LDDD ntype
	;

convtype :
	fntype
	| othertype
	;

comptype :
	othertype
	;

expr_or_type :
	expr
	| non_expr_type
	;

non_expr_type :
	fntype
	| recvchantype
	| othertype
	| LMULT non_expr_type
	;

structtype :
	LSTRUCT lbrace listsc_t_structdcl_ RBRACE
	| LSTRUCT lbrace RBRACE
	;

structdcl :
	listc_new_name_ ntype option_LSTR_
	| packname option_LSTR_
	| LMULT packname option_LSTR_
	| LDDD
	;

interfacetype :
	LINTERFACE lbrace listsc_t_interfacedcl_ RBRACE
	| LINTERFACE lbrace RBRACE
	;

interfacedcl :
	sym indcl
	| packname
	| LDDD
	;

indcl :
	LPAREN oarg_type_list_ocomma RPAREN fnres
	;

xfndcl :
	LFUNC fndcl fnbody
	;

fndcl :
	sym LPAREN oarg_type_list_ocomma RPAREN fnres
	| LPAREN oarg_type_list_ocomma RPAREN sym LPAREN oarg_type_list_ocomma RPAREN fnres
	;

fnbody :
	/*empty*/
	| LBRACE listsc_stmt_ RBRACE
	;

fnliteral :
	fnlitdcl lbrace listsc_stmt_ RBRACE
	;

fnlitdcl :
	fntype
	;

arg_type :
	name_or_type
	| sym name_or_type
	| sym dotdotdot
	| dotdotdot
	| LDDD
	;

name_or_type :
	ntype
	;

arg_type_list :
	arg_type
	| arg_type_list LCOMMA arg_type
	;

oarg_type_list_ocomma :
	/*empty*/
	| arg_type_list option_LCOMMA_
	;

elseif_list :
	/*empty*/
	| elseif_list elseif
	;

xdcl_list :
	/*empty*/
	| xdcl_list xdcl LSEMICOLON
	;

imports :
	/*empty*/
	| imports import LSEMICOLON
	;

constdcl1_list :
	constdcl1
	| constdcl1_list LSEMICOLON constdcl1
	;

oexpr_list :
	/*empty*/
	| listc_expr_
	;

%%

/*****************************************************************************/
/* UTF-8 boilerplate */
/*****************************************************************************/
/*
   Generic UTF-8 boilerplate.

   See https://erratique.ch/software/uucp/doc/unicode.html
   for a good explanation of how this works.

   We don't convert UTF-8-encoded data to code points. We only do the minimum
   to ensure the correct identification of the boundaries between scalar
   code points.
*/

/* 0xxxxxxx */
ascii   [\x00-\x7F] //[\000-\127]

/* 110xxxxx */
utf8_head_byte2   [\xC0-\xDF] //[\192-\223]

/* 1110xxxx */
utf8_head_byte3   [\xE0-\xEF] //[\224-\239]

/* 11110xxx */
utf8_head_byte4   [\xF0-\xF7] //[\240-\247]

/* 10xxxxxx */
utf8_tail_byte   [\x80-\xBF] //[\128-\191]

/* 7 bits of payload */
utf8_1   {ascii}

/* 11 bits of payload */
utf8_2   {utf8_head_byte2}{utf8_tail_byte}

/* 16 bits of payload */
utf8_3   {utf8_head_byte3}{utf8_tail_byte}{utf8_tail_byte}

/* 21 bits of payload */
utf8_4   {utf8_head_byte4}{utf8_tail_byte}{utf8_tail_byte}{utf8_tail_byte}

/* Any UTF-8-encoded code point. This set includes more than it should
   for simplicity.

   - This includes encodings of the so-called surrogate code points
     used by UTF-16 and not permitted by UTF-8.
   - This includes the range 0x110000 to 0x1FFFFF which are beyond the
     range of valid Unicode code points.
*/
utf8   {utf8_1}|{utf8_2}|{utf8_3}|{utf8_4}
utf8_nonascii   {utf8_2}|{utf8_3}|{utf8_4}

/*****************************************************************************/
/* Regexp aliases */
/*****************************************************************************/

newline   ("\n"|"\r\n")
whitespace   [ \t]

/* TODO: unicode digits */
unicode_digit   [0-9]

/* TODO: unicode letters */
unicode_letter   [a-zA-Z]

//unicode_char   {ascii}#[\n\r]|{utf8_nonascii}
unicode_char   [\x00-\x09\x0B-\x0C\x0E-\x7F]|{utf8_nonascii}

//unicode_char_no_quote   {ascii}#[\n\r'\\]|{utf8_nonascii}
unicode_char_no_quote   [\x00-\x09\x0B-\x0C\x0E-\x26\x28-\x5B\x5D-\x7F]|{utf8_nonascii}

//unicode_char_no_double_quote   {ascii}#[\n\r"\\]|{utf8_nonascii}
unicode_char_no_double_quote   [\x00-\x09\x0B-\x0C\x0E-\x21\x23-\x5B\x5D-\x7F]|{utf8_nonascii}

//unicode_char_no_backquote   {ascii}#[\n\r`]|{utf8_nonascii}
unicode_char_no_backquote   [\x00-\x09\x0B-\x0C\x0E-\x5F\x61-\x7F]|{utf8_nonascii}

letter   {unicode_letter}|"_"

identifier   {letter}({letter}|{unicode_digit})*


decimal_digit   [0-9]
binary_digit   [0-1]
octal_digit   [0-7]
hex_digit   [0-9a-fA-F]

decimal_digits   {decimal_digit}("_"?{decimal_digit})*
binary_digits   {binary_digit}("_"?{binary_digit})*
octal_digits   {octal_digit}("_"?{octal_digit})*
hex_digits   {hex_digit}("_"?{hex_digit})*

decimal_lit   "0"|[1-9]("_"?{decimal_digits})?
binary_lit   "0"[bB]"_"?{binary_digits}
octal_lit   "0"[oO]?"_"?{octal_digits}
hex_lit   "0"[xX]"_"?{hex_digits}

int_lit    {decimal_lit}|{binary_lit}|{octal_lit}|{hex_lit}

decimal_exponent   [eE][+-]?{decimal_digits}
decimal_float_lit    {decimal_digits}"."{decimal_digits}?{decimal_exponent}?|{decimal_digits}{decimal_exponent}|"."{decimal_digits}{decimal_exponent}?

hex_mantissa    "_"?{hex_digits}"."{hex_digits}?|"_"?{hex_digits}|"."{hex_digits}
hex_exponent   [pP][+-]?{decimal_digits}
hex_float_lit   "0"[xX]{hex_mantissa}{hex_exponent}

float_lit   {decimal_float_lit}|{hex_float_lit}

imaginary_lit   ({decimal_digits}|{int_lit}|{float_lit})"i"

escaped_char   \\[abfnrttv\\'"]

little_u_value   "\\u"{hex_digit}{4}
big_u_value      "\\U"{hex_digit}{8}

/* the Go ref says just unicode_char, but this can not work, hence the
 * use of various xxx_no_yyy below
 */
unicode_value_no_quote   {unicode_char_no_quote}|{little_u_value}|{big_u_value}|{escaped_char}
unicode_value_no_double_quote   {unicode_char_no_double_quote}|{little_u_value}|{big_u_value}|{escaped_char}

octal_byte_value   \\{octal_digit}{3}
hex_byte_value   "\\x"{hex_digit}{2}
byte_value   {octal_byte_value}|{hex_byte_value}

/* semgrep: we can use regexp in semgrep in strings and we want to
 * support any escape characters there, e.g. eval("=~/.*dev\.corp/")
 */
semgrep_escapeseq   "\\_"

%%

  /* ----------------------------------------------------------------------- */
  /* spacing/comments */
  /* ----------------------------------------------------------------------- */
[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

  /* ----------------------------------------------------------------------- */
  /* symbols */
  /* ----------------------------------------------------------------------- */

"+"	LPLUS
"-"	LMINUS
"*"	LMULT
"/"	LDIV
"%"	LPERCENT

"+="	LASOP
"-="	LASOP
"*="	LASOP
"/="	LASOP
"%="	LASOP
"&="	LASOP
"|="	LASOP
"^="	LASOP
"<<="	LASOP
">>="	LASOP
/* Go specific operator */
"&^="	LASOP

"=="	LEQEQ
"!="	LNE

"<="	LLE
">="	LGE
"<"	LLT
">"	LGT

"="	LEQ

"|"	LPIPE
"&"	LAND
"^"	LHAT
"!"	LBANG

"<<"	LLSH
">>"	LRSH

"++"	LINC
"--"	LDEC

"&&"	LANDAND
"||"	LOROR

"<-"	LCOMM
":="	LCOLAS

"("	LPAREN
")"	RPAREN
"["	LBRACKET
"]"	RBRACKET
/* can be transformed in an LBODY by parsing hack later */
"{"	LBRACE
"}"	RBRACE

":"	LCOLON
";"	LSEMICOLON
"."	LDOT
","	LCOMMA

/* part of go and also sgrep-ext: */
"..."	LDDD
/* sgrep-ext: */
//"<..."  { Flag_parsing.sgrep_guard (LDots (tokinfo lexbuf)) }
//"...>"  { Flag_parsing.sgrep_guard (RDots (tokinfo lexbuf)) }

LANDNOT	LANDNOT
LBODY	LBODY
LDots	LDots
RDots	RDots
NotParen	NotParen

  /* ----------------------------------------------------------------------- */
  /* Keywords and ident */
  /* ----------------------------------------------------------------------- */

  /* keywords */

"if"	LIF
"else"	LELSE

"for"	LFOR

"switch"	LSWITCH
"case"	LCASE
"default"	LDEFAULT

"return"	LRETURN
"break"	LBREAK
"continue"	LCONTINUE
"fallthrough"	LFALL
"goto"	LGOTO

"func"	LFUNC
"const"	LCONST
"var"	LVAR
"type"	LTYPE
"struct"	LSTRUCT
"interface"	LINTERFACE


"package"	LPACKAGE
"import"	LIMPORT

"go"	LGO
"chan"	LCHAN
"select"	LSELECT
"defer"	LDEFER
"map"	LMAP
"range"	LRANGE

        /* declared in the "universe block"
         *  - true, false
         *  - iota
         *  - new, make,
         *    panic (CFG effect, like goto), recover,
         *    print, println
         *    complex, imag, real
         *    append, cap,
         *    close, delete, copy,
         *    len,
         *  - nil
         *  - _ (blank identifier)
         */
//_          -> LNAME (id, (tokinfo lexbuf))
{identifier}	LNAME

  /* ----------------------------------------------------------------------- */
  /* Constant */
  /* ----------------------------------------------------------------------- */

  /* literals */
  /* this is also part of int_lit, but we specialize it here to use the
   * right int_of_string */
"0"{octal_digits}  LINT
{int_lit}        LINT
{float_lit}        LFLOAT
{imaginary_lit}        LIMAG

  /* ----------------------------------------------------------------------- */
  /* Chars/Strings */
  /* ----------------------------------------------------------------------- */
'({unicode_value_no_quote}|{byte_value})'       LRUNE
"`"({unicode_char_no_backquote}|{newline})*"`"       LSTR
\"({unicode_value_no_double_quote}|{byte_value})*\"       LSTR

%%
