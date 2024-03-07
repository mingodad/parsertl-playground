//From: https://github.com/polyglot-compiler/polyglot/blob/2518a93b3a00b72976a5f4a6ac20d3ae6e4deb56/tools/ppg/src/ppg/parse/ppg.cup

/*PPG syntax */
%token INCLUDE TO
/* PPG commands and syntax */
%token DROP TRANSFER
%token LBRACE RBRACE
/* CUP extensions */
%token IMPLEMENTS
/* PPG & CUP common */
%token COMMA SEMI COLON COLON_COLON_EQUALS BAR
%token TERMINAL NONTERMINAL
%token PERCENT_PREC DOT
%token LBRACK RBRACK
%token LT GT QUESTION
%token SUPER EXTENDS //CLASS
/* CUP-only */
%token PACKAGE IMPORT CODE ACTION PARSER NON INIT SCAN WITH
%token START STAR PRECEDENCE LEFT RIGHT NONASSOC

%token STRING_CONST ID CODE_STR EXTEND OVERRIDE
// /* PPG nonterminals */
// /* Common */
// /* CUP nonterminals */
// parser_code_part
// init_code scan_code;
///* PPG */
//	 code_str;
//					nt_id_list;
///* Common */
//					term_id robust_id;
///* CUP */
//					multipart_id start_spec type_id new_non_term_id
//					new_term_id;

%fallback ID CODE START

%start spec

%%

/* add ability to override class imports package declaration */
spec :
	ppg_spec
	| cup_spec
	;

/********************************************************************
 * JLGEN *
 ********************************************************************/
ppg_spec :
	include_spec package_spec import_list
		code_parts symbol_list_opt ppg_precedence_list
		ppg_start_spec command_list_opt
	;

include_spec :
	INCLUDE STRING_CONST
	;

symbol_list_opt :
	symbol_list
	| %empty
	;

ppg_precedence_list :
	precedence_list
	| PRECEDENCE SEMI // remove all precedence instructions from grammar
	;

ppg_start_spec :
	START WITH nt_id SEMI
	| ppg_start_spec_list
	;

ppg_start_spec_list :
	ppg_start_spec_list ppg_start_spec_elt
	| ppg_start_spec_elt
	;

ppg_start_spec_elt :
	START WITH id id SEMI
	;

command_list_opt :
	command_list_opt command
	| %empty
	;

command :
	prod_modifier_opt production
	| DROP LBRACE production RBRACE
	| DROP LBRACE nt_id_list RBRACE
	| TRANSFER nt_id transfer_list
	;

nt_id_list :
	nt_id_list COMMA nt_id
	| nt_id
	;

prod_modifier_opt :
	EXTEND
	| OVERRIDE
	| %empty
	;

transfer_list :
	transfer_list TO nt_id LBRACE rhs_list RBRACE
	| TO nt_id LBRACE rhs_list RBRACE
	;

/********************************************************************
 * COMMON *
 ********************************************************************/
production_list :
	production_list production
	| production
	;

production :
	nt_id COLON_COLON_EQUALS rhs_list SEMI
	;

nt_id :
	id
	;

symbol_id :
	id
	;

rhs_list :
	rhs_list BAR rhs
	| rhs
	;

rhs :
	prod_part_list PERCENT_PREC term_id
	| prod_part_list
	;

prod_part_list :
	prod_part_list prod_part
	| %empty
	;

prod_part :
	symbol_id opt_label
	| code_str
	;

opt_label :
	COLON label_id
	| %empty
	;

label_id :
	robust_id
	;

robust_id : /* all ids that aren't reserved words in Java */
	id
	;

non_terminal :
	NON TERMINAL
	| NONTERMINAL
	;

opt_semi :
	SEMI
	| %empty
	;

/********************************************************************
 * CUP *
 ********************************************************************/
cup_spec :
	package_spec import_list code_parts
		symbol_list precedence_list
		start_spec production_list
	;

package_spec :
	PACKAGE multipart_id SEMI
	| %empty
	;

import_list :
	import_list import_spec
	| %empty
	;

import_spec :
	IMPORT import_id SEMI
	;

// allow any order; all parts are optional. [CSA 23-Jul-1999]
// (we check in the part action to make sure we don't have 2 of any part)
code_parts :
	code_parts code_part
	| %empty
	;

code_part :
	action_code_part
	| parser_code_part
	| init_code
	| scan_code
	;

action_code_part :
	ACTION CODE code_str opt_semi
	;

parser_code_part :
	PARSER CODE code_str opt_semi
	| PARSER id extendsimpls code_str opt_semi
	;

extendsimpls :
	%empty
	| extendsimpls EXTENDS multipart_id
	| extendsimpls IMPLEMENTS multipart_id
	;

init_code :
	INIT WITH code_str opt_semi
	;

scan_code :
	SCAN WITH code_str opt_semi
	;

symbol_list :
	symbol_list symbol
	| symbol
	;

symbol :
	TERMINAL type_id declares_term
	| TERMINAL declares_term
	| non_terminal type_id declares_non_term
	| non_terminal declares_non_term
	;

declares_term :
	term_name_list SEMI
	;

declares_non_term :
	non_term_name_list SEMI
	;

term_name_list :
	term_name_list COMMA new_term_id
	| new_term_id
	;

non_term_name_list :
	non_term_name_list COMMA new_non_term_id
	| new_non_term_id
	;

precedence_list :
	precedence_l
	| %empty
	;

precedence_l :
	precedence_l preced
	| preced
	;

preced :
	PRECEDENCE LEFT terminal_list SEMI
	| PRECEDENCE RIGHT terminal_list SEMI
	| PRECEDENCE NONASSOC terminal_list SEMI
	;

terminal_list :
	terminal_list COMMA terminal_id
	| terminal_id
	;

terminal_id :
	term_id
	;

term_id :
	symbol_id
	;

start_spec :
	START WITH nt_id SEMI
	| %empty
	;

multipart_id :
	multipart_id DOT robust_id
	| robust_id
	;

import_id :
	multipart_id DOT STAR
	| multipart_id
	;

type_id :
	multipart_id
	| type_id LBRACK RBRACK
	| multipart_id LT type_id GT
	| multipart_id LT QUESTION EXTENDS type_id GT
	| multipart_id LT QUESTION SUPER type_id GT
	;

new_term_id :
	id
	;

new_non_term_id :
	id
	;

/* some productions to extract info from tokens */
id :
	ID
	;

code_str :
	CODE_STR
	;

%%

letter    [A-Za-z]
identifier    {letter}({letter}|[0-9_])*
white_space_char    [\ \t\n\r\f]
whitespace    {white_space_char}+
slashcomment    "//".*
blockcomment    "/*"(?s:.)*?"*/"
code_block   "{:"(?s:.)*?":}" //[^:]*:(:|[^"}":][^:]*:)*"}"
PC  [\040-\041\043-\133\135-\176]
ES  \\(N|n|t|"^"[\100-\176]|[0-9][0-9][0-9]|\"|\\|{whitespace}\\)
string_lit  ({PC}|{ES})*
string_lit_quote  {string_lit}\"
string_lit_slash  {string_lit}\\

%%

"include"       INCLUDE
"extend"        EXTEND
"drop"          DROP
"override"      OVERRIDE
"transfer"      TRANSFER
"to"            TO

"package"       PACKAGE
"import"        IMPORT
"code"          CODE
"action"        ACTION
"parser"        PARSER
"init"          INIT
"scan"          SCAN
"with"          WITH
"start"         START
"precedence"    PRECEDENCE
"left"          LEFT
"right"         RIGHT
"nonassoc"      NONASSOC
"terminal"      TERMINAL
"non"           NON
"nonterminal"   NONTERMINAL
"super"         SUPER
"extends"       EXTENDS
"implements"    IMPLEMENTS

"::="           COLON_COLON_EQUALS
";"             SEMI
"."             DOT
","             COMMA
"{"             LBRACE
"}"             RBRACE
"["             LBRACK
"]"             RBRACK
"<"             LT
">"             GT
"?"             QUESTION
"|"             BAR
":"             COLON
"*"             STAR
{identifier}    ID
"%prec"         PERCENT_PREC

\"(\\.|[^"\n\r\\])*\"      STRING_CONST

{slashcomment}  skip()
{blockcomment}	skip()
{whitespace}    skip()

{code_block}    CODE_STR

//.       { error("Invalid character: " + yytext());}

%%
