/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * This file is part of SableCC.                             *
 * See the file "LICENSE" for copyright information and the  *
 * terms and conditions for copying, distribution and        *
 * modification of SableCC.                                  *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


/* This grammar defines the SableCC 3.x input language. */

/* These are token definitions. It is allowed to use helper regular *
 * expressions in the body of a token definition.                   *
 * On a given input, the longest valid definition is chosen, In     *
 * case of a match, the definition that appears first is chosen.    *
 * Example: on input -> 's' <- "char" will have precedence on       *
 * "string", because it appears first.                              */

%token abstract
%token arrow
%token bar
%token colon
%token comma
%token d_dot
%token dec_char
%token dot
%token equal
%token hex_char
%token id
%token ignored
%token l_bkt
%token l_brace
%token l_par
%token minus
%token new
%token null
%token pkg_id
%token plus
%token production_specifier
%token q_mark
%token r_bkt
%token r_brace
%token r_par
%token semicolon
%token slash
%token star
%token string
%token syntax
%token T.char
%token T.helpers
%token token_specifier
%token T.package
%token T.productions
%token tree
%token T.states
%token T.tokens

%fallback pkg_id id

%start grammar

%%
//Productions

/* These are the productions of the grammar. The first production is *
 * used by the implicit start production:                            *
 *   start = (first production) EOF;                                 *
 * ?, * and + have the same meaning as in a regular expression.      *
 * In case a token and a production share the same name, the use of  *
 * P. (for production) or T. (for token) is required.                *
 * Each alternative can be explicitely named by preceding it with a  *
 * name enclosed in braces.                                          *
 * Each alternative element can be explicitely named by preceding it *
 * with a name enclosed in brackets and followed by a colon.         */


grammar:
	  P.package_opt P.helpers_opt grammar_3 P.tokens_opt ign_tokens_opt P.productions_opt P.ast_opt
	;

P.ast_opt:
	  %empty
	| P.ast
	;

P.productions_opt:
	  %empty
	| P.productions
	;

ign_tokens_opt:
	  %empty
	| ign_tokens
	;

P.tokens_opt:
	  %empty
	| P.tokens
	;

grammar_3:
	  %empty
	| P.states
	;

P.helpers_opt:
	  %empty
	| P.helpers
	;

P.package_opt:
	  %empty
	| P.package
	;

P.package:
	  T.package pkg_name
	;

pkg_name:
	  pkg_id pkg_name_tail_zom semicolon
	;

pkg_name_tail_zom:
	  %empty
	| pkg_name_tail_zom pkg_name_tail
	;

pkg_name_tail:
	  dot pkg_id
	;

P.helpers:
	  T.helpers P.helper_def_oom
	;

P.helper_def_oom:
	  helper_def
	| P.helper_def_oom helper_def
	;

helper_def:
	  id equal reg_exp semicolon
	;

P.states:
	  T.states id_list semicolon
	;

id_list:
	  id id_list_tail_zom
	;

id_list_tail_zom:
	  %empty
	| id_list_tail_zom id_list_tail
	;

id_list_tail:
	  comma id
	;

P.tokens:
	  T.tokens P.token_def_oom
	;

P.token_def_oom:
	  token_def
	| P.token_def_oom token_def
	;

token_def:
	  state_list_opt id equal reg_exp look_ahead_opt semicolon
	;

look_ahead_opt:
	  %empty
	| look_ahead
	;

state_list_opt:
	  %empty
	| state_list
	;

state_list:
	  l_brace id transition_opt state_list_tail_zom r_brace
	;

state_list_tail_zom:
	  %empty
	| state_list_tail_zom state_list_tail
	;

transition_opt:
	  %empty
	| transition
	;

state_list_tail:
	  comma id transition_opt
	;

transition:
	  arrow id
	;

ign_tokens:
	  ignored T.tokens id_list_opt semicolon
	;

id_list_opt:
	  %empty
	| id_list
	;

look_ahead:
	  slash reg_exp
	;

reg_exp:
	  concat reg_exp_tail_zom
	;

reg_exp_tail_zom:
	  %empty
	| reg_exp_tail_zom reg_exp_tail
	;

reg_exp_tail:
	  bar concat
	;

concat:
	  %empty
	| concat un_exp
	;

un_exp:
	  basic un_op_opt
	;

un_op_opt:
	  %empty
	| un_op
	;

basic:
	  P.char
	| set
	| string
	| id
	| l_par reg_exp r_par
	;

P.char:
	  T.char
	| dec_char
	| hex_char
	;

set:
	  l_bkt basic bin_op basic r_bkt
	| l_bkt P.char d_dot P.char r_bkt
	;

un_op:
	  star
	| q_mark
	| plus
	;

bin_op:
	  plus
	| minus
	;

P.productions:
	  T.productions P.prod_oom
	;

P.prod_oom:
	  prod
	| P.prod_oom prod
	;

prod:
	  id prod_transform_opt equal alts semicolon
	;

prod_transform_opt:
	  %empty
	| prod_transform
	;

prod_transform:
	  l_brace arrow elem_zom r_brace
	;

elem_zom:
	  %empty
	| elem_zom elem
	;

alts:
	  alt alts_tail_zom
	;

alts_tail_zom:
	  %empty
	| alts_tail_zom alts_tail
	;

alts_tail:
	  bar alt
	;

alt:
	  alt_name_opt elem_zom alt_transform_opt
	;

alt_transform_opt:
	  %empty
	| alt_transform
	;

alt_name_opt:
	  %empty
	| alt_name
	;

alt_transform:
	  l_brace arrow term_zom r_brace
	;

term_zom:
	  %empty
	| term_zom term
	;

term:
	  new prod_name l_par params_opt r_par
	| l_bkt list_of_list_term_opt r_bkt
	| specifier_opt id simple_term_tail_opt
	| null
	;

simple_term_tail_opt:
	  %empty
	| simple_term_tail
	;

specifier_opt:
	  %empty
	| specifier
	;

list_of_list_term_opt:
	  %empty
	| list_of_list_term
	;

params_opt:
	  %empty
	| params
	;

list_of_list_term:
	  list_term list_term_tail_zom
	;

list_term_tail_zom:
	  %empty
	| list_term_tail_zom list_term_tail
	;

list_term:
	  new prod_name l_par params_opt r_par
	| specifier_opt id simple_term_tail_opt
	;

list_term_tail:
	  comma list_term
	;

simple_term_tail:
	  dot id
	;

prod_name:
	  id prod_name_tail_opt
	;

prod_name_tail_opt:
	  %empty
	| prod_name_tail
	;

prod_name_tail:
	  dot id
	;

params:
	  term params_tail_zom
	;

params_tail_zom:
	  %empty
	| params_tail_zom params_tail
	;

params_tail:
	  comma term
	;

alt_name:
	  l_brace id r_brace
	;

elem:
	  elem_name_opt specifier_opt id un_op_opt
	;

elem_name_opt:
	  %empty
	| elem_name
	;

elem_name:
	  l_bkt id r_bkt colon
	;

specifier:
	  token_specifier dot
	| production_specifier dot
	;

P.ast:
	  abstract syntax tree ast_prod_oom
	;

ast_prod_oom:
	  ast_prod
	| ast_prod_oom ast_prod
	;

ast_prod:
	  id equal ast_alts semicolon
	;

ast_alts:
	  ast_alt ast_alts_tail_zom
	;

ast_alts_tail_zom:
	  %empty
	| ast_alts_tail_zom ast_alts_tail
	;

ast_alts_tail:
	  bar ast_alt
	;

ast_alt:
	  alt_name_opt elem_zom
	;

%%

//%x package

/* These are character sets and regular expressions used in the
   definition of tokens. */

all   [0 .. 0xFF]
lowercase   [a-z]
uppercase   [A-Z]
digit   [0-9]
hex_digit   [0-9a-fA-F]

tab   \t
cr   \r
lf   \n
eol   {cr}{lf}|{cr}|{lf} // This takes care of different platforms

not_cr_lf   [^\r\n]
not_star   [^*]
not_star_slash   [^*/]

blank   (" "|{tab}|{eol})+

short_comment   "//".*
long_comment  "/*"{not_star}*"*"+({not_star_slash}{not_star}*"*"+)*"/"
comment   {short_comment}|{long_comment}

letter   {lowercase}|{uppercase}|"_"|"$"
id_part   {lowercase}({lowercase}|{digit})*

%%

/* These are token definitions. It is allowed to use helper regular *
 * expressions in the body of a token definition.                   *
 * On a given input, the longest valid definition is chosen, In     *
 * case of a match, the definition that appears first is chosen.    *
 * Example: on input -> 's' <- "char" will have precedence on       *
 * "string", because it appears first.                              */

//{normal->package}
"Package"	T.package

"States"	T.states
"Helpers"	T.helpers
"Tokens"	T.tokens
"Ignored"	ignored
"Productions"	T.productions

"Abstract"	abstract
"Syntax"	syntax
"Tree"	tree
"New"	new
"Null"	null

"T"	token_specifier
"P"	production_specifier

"."	dot
".."	d_dot

//{normal, package->normal}
";"	semicolon

"="	equal
"["	l_bkt
"]"	r_bkt
"("	l_par
")"	r_par
"{"	l_brace
"}"	r_brace
"+"	plus
"-"	minus
"?"	q_mark
"*"	star
"|"	bar
","	comma
"/"	slash
"->"	arrow
":"	colon

{id_part}("_"{id_part})*	id

"'"{not_cr_lf}"'"	T.char
{digit}+	dec_char
"0"[xX]{hex_digit}+	hex_char

"'"[^\r\n']+"'"	string

//{package}
{letter}({letter}|{digit})*	pkg_id

//Ignored Tokens

/* These tokens are simply ignored by the parser. */

{blank}	skip()
{comment}	skip()

%%
