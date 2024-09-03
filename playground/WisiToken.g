//From: https://download.savannah.gnu.org/releases/ada-mode/wisitoken-4.1.0.tgz
// https://stephe-leake.org/ada/wisitoken.html
//; WisiToken grammar for WisiToken grammar, for wisitoken-bnf-generate.
//
//  wisitoken_grammar-mode uses the same grammar for parsing .wy
//  files, but with different actions.
//  (ediff "wisitoken_grammar_1.wy" "../org.wisitoken/wisitoken_grammar.wy")
//
//  The supported syntax is similar to several flavors of Extended
//  Backus-Naur form, as defined by
//  https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form
//
//  In particular, we support grammars for popular languages:
//
//  - the Python grammar file given at
//    https://docs.python.org/3.8/reference/grammar.html
//
//  - the Java grammar file given at
//    https://github.com/antlr/grammars-v4/tree/master/java
//
//  - the Ada grammar given in the Ada Language Reference Manual Annex
//    P; see http://ada-auth.org/arm.html
//
//  This file uses only plain BNF syntax, to simplify working on the
//  EBNF syntax.

//  Copyright (C) 2017 - 2022 Free Software Foundation, Inc.
//
//  Author: Stephen Leake <stephe-leake@stephe-leake.org>
//
//  This file is part of GNU Emacs.
//
//  GNU Emacs is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  GNU Emacs is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.


// In re2c regexps, '...' indicates a case-insensitive match, "..." a
// case-sensitive match.
//
// In nonterminals, '...' indicates a literal, which we translate to a
// token; case-sensitive is then determined by the 'case_insensitive'
// declaration.
//
// 0x22 = "
// 0x27 = '

// No error recovery, because this grammar is not intended for
// interactive use, and to keep wisitoken-bnf-generate independent of
// mckenzie_recover, to simplify working on mckenzie_recover.

//%conflict SHIFT IDENTIFIER_BAR_list | REDUCE rhs_list on token BAR
//%conflict SHIFT declaration_item | REDUCE declaration on token IDENTIFIER
//%conflict SHIFT rhs_element | REDUCE rhs on token IDENTIFIER
//%conflict SHIFT rhs_list | REDUCE semicolon_opt on token PERCENT

%token ACCEPT_I
%token ACTION
%token BAR
%token CODE
%token COLON
%token COLON_COLON_EQUAL
%token CONFLICT
%token CONFLICT_RESOLUTION
%token ELSIF
%token END
%token EQUAL
%token GREATER
%token IDENTIFIER
%token IF
%token IN
%token KEYWORD
%token LEFT_BRACE
%token LEFT_BRACKET
%token LEFT_PAREN
%token LESS
%token MINUS
%token NON_GRAMMAR
%token NUMERIC_LITERAL
%token ON
%token PERCENT
%token PLUS
%token QUESTION
%token RAW_CODE
%token REDUCE_I
%token REGEXP
%token RIGHT_BRACE
%token RIGHT_BRACKET
%token RIGHT_PAREN
%token SEMICOLON
%token SHIFT_I
%token STAR
%token STRING_LITERAL_1
%token STRING_LITERAL_2
%token TOKEN

%start compilation_unit_list

%%

//// grammar rules, no particular order

regexp_string
  : REGEXP
  | STRING_LITERAL_1
  | STRING_LITERAL_2
  ;

conflict_item
  : SHIFT_I IDENTIFIER
  | REDUCE_I IDENTIFIER
  | ACCEPT_I IDENTIFIER
  | IDENTIFIER
  ;

conflict_item_list
  : conflict_item
  | conflict_item_list BAR conflict_item
  ;

token_name : IDENTIFIER | STRING_LITERAL_2 ;

declaration
  : PERCENT TOKEN LESS IDENTIFIER GREATER IDENTIFIER regexp_string regexp_string
  | PERCENT TOKEN LESS IDENTIFIER GREATER IDENTIFIER regexp_string
  | PERCENT NON_GRAMMAR LESS IDENTIFIER GREATER IDENTIFIER regexp_string regexp_string
  | PERCENT NON_GRAMMAR LESS IDENTIFIER GREATER IDENTIFIER regexp_string
  | PERCENT NON_GRAMMAR LESS IDENTIFIER GREATER IDENTIFIER
  | PERCENT KEYWORD IDENTIFIER regexp_string
  | PERCENT CODE identifier_list RAW_CODE
  | PERCENT CONFLICT conflict_item_list ON TOKEN token_name
  | PERCENT CONFLICT_RESOLUTION conflict_item_list ON TOKEN token_name COLON IDENTIFIER

  // %start, %mckenzie*, etc.
  | PERCENT IDENTIFIER declaration_item_list
  // %case_insensitive etc
  | PERCENT IDENTIFIER

  | PERCENT IF IDENTIFIER EQUAL IDENTIFIER
  | PERCENT IF IDENTIFIER IN IDENTIFIER_BAR_list
  | PERCENT ELSIF IDENTIFIER EQUAL IDENTIFIER
  | PERCENT ELSIF IDENTIFIER IN IDENTIFIER_BAR_list
  | PERCENT END IF
  ;

identifier_list
  : IDENTIFIER
  | identifier_list IDENTIFIER
  ;

IDENTIFIER_BAR_list
  : IDENTIFIER
  | IDENTIFIER_BAR_list BAR IDENTIFIER
  ;

declaration_item
  : IDENTIFIER
  | NUMERIC_LITERAL
  | regexp_string
  ;

declaration_item_list
  : declaration_item
  | declaration_item_list declaration_item
  ;

nonterminal
  : IDENTIFIER COLON rhs_list semicolon_opt
  | IDENTIFIER COLON_COLON_EQUAL rhs_list semicolon_opt
  ;

semicolon_opt :
// Terminating semicolon optional for Python grammar syntax (see
// header comments).
  SEMICOLON | ;

rhs_list
  : rhs
  | rhs_list BAR rhs
  | rhs_list PERCENT IF IDENTIFIER EQUAL IDENTIFIER
  | rhs_list PERCENT IF IDENTIFIER IN IDENTIFIER_BAR_list
  | rhs_list PERCENT ELSIF IDENTIFIER EQUAL IDENTIFIER
  | rhs_list PERCENT ELSIF IDENTIFIER IN IDENTIFIER_BAR_list
  | rhs_list PERCENT END IF
  ;

rhs
  : // empty
  | rhs_item_list
  | rhs_item_list ACTION
  | rhs_item_list ACTION ACTION
  ;

rhs_attribute
  : LESS IDENTIFIER EQUAL IDENTIFIER GREATER
  ;

rhs_element
  : rhs_item
  | IDENTIFIER EQUAL rhs_item
  ;

rhs_item_list
  : rhs_element
  | rhs_item_list rhs_element
  ;

rhs_item
  : IDENTIFIER
  | STRING_LITERAL_2   // value of token
  | rhs_attribute // ANTLR attribute
  | rhs_optional_item
  | rhs_multiple_item
  | rhs_group_item
  ;

rhs_group_item
  : LEFT_PAREN rhs_alternative_list RIGHT_PAREN
  // rhs_alternative_list is _not_ marked as an EBNF node; translating
  // rhs_group_item handles it.
  ;

rhs_optional_item
  : LEFT_BRACKET rhs_alternative_list RIGHT_BRACKET
  // rhs_alternative_list is _not_ marked as an EBNF node; translating
  // rhs_optional_item handles it.
  | LEFT_PAREN rhs_alternative_list RIGHT_PAREN QUESTION
  | IDENTIFIER QUESTION
  | STRING_LITERAL_2 QUESTION
  ;

rhs_multiple_item
  : LEFT_BRACE rhs_alternative_list RIGHT_BRACE
  | LEFT_BRACE rhs_alternative_list RIGHT_BRACE MINUS
  | LEFT_PAREN rhs_alternative_list RIGHT_PAREN PLUS
  | LEFT_PAREN rhs_alternative_list RIGHT_PAREN STAR
  | IDENTIFIER PLUS
  | IDENTIFIER STAR
  ;

rhs_alternative_list
  : rhs_item_list
  | rhs_alternative_list BAR rhs_item_list
  ;

// We don't enforce a complete order, nor require all parts, so
// partial files can still be parsed successfully.
compilation_unit
  : declaration
  | nonterminal
  ;

compilation_unit_list
  : compilation_unit
  | compilation_unit_list compilation_unit
  ;

%%

%%

[ \t\r\n]+	skip()
";;".*	skip()

[aA][cC][eE][pP][pP][tT][_][iI][tT]	ACCEPT_I
"%("(?s:.)*?")%"	ACTION
"|"	BAR
code	CODE
":"	COLON
"::="	COLON_COLON_EQUAL
conflict	CONFLICT
conflict_resolution	CONFLICT_RESOLUTION
elsif	ELSIF
end	END
"="	EQUAL
">"	GREATER
if	IF
in	IN
keyword	KEYWORD
"{"	LEFT_BRACE
"["	LEFT_BRACKET
"("	LEFT_PAREN
"<"	LESS
"-"	MINUS
non_grammar	NON_GRAMMAR
on	ON
"%"	PERCENT
"+"	PLUS
"?"	QUESTION
 "%{"(?s:.)*?"}%"	RAW_CODE
[rR][eE][dD][uU][cC][eE]	REDUCE_I
"%["(?s:.)*?"]%"	REGEXP
"}"	RIGHT_BRACE
"]"	RIGHT_BRACKET
")"	RIGHT_PAREN
";"	SEMICOLON
[sS][hH][iI][fF][tT]	SHIFT_I
"*"	STAR
token	TOKEN

[0-9-][0-9_]*	NUMERIC_LITERAL
\"(\\.|[^"\r\n\\])+\"	STRING_LITERAL_1
'(\\.|[^'\r\n\\])+'	STRING_LITERAL_2
//[a-zA-Z\x80-\U0010FFFF][-0-9a-zA-Z_\x80-\U0010FFFF]*	IDENTIFIER
[a-zA-Z][-0-9a-zA-Z_]*	IDENTIFIER

%%
