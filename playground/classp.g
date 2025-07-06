//From: https://github.com/google/classp/blob/757eb1070f8a949bb4ad5f272a62a20a7447deb4/src/classp.y
/*
 * This file is a part of the Classp parser, formatter, and AST generator.
 * Description: Parser for the Classp language.
 *
 * Copyright 2015 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
*/


/*
   The declaration of tokens.  The word that follows most of the token names is
   used for emitting error messages.  We use backquotes to defeat the broken
   heuristics of Bison.
*/
//%token TOK_EOF 0

/* Simple tokens. */
%token TOK_AND
%token TOK_BAR
%token TOK_COLON
%token TOK_COMMA
//%token TOK_DOLLARDOLLAR
//%token TOK_DOTDOT
//%token TOK_EQUAL
%token TOK_EQL
%token TOK_FALSE
%token TOK_GEQ
%token TOK_GTR
%token TOK_LBRACE
%token TOK_LBRACK
%token TOK_LEQ
%token TOK_LPAREN
%token TOK_LSHIFT
%token TOK_LSS
%token TOK_MINUS
%token TOK_NEQ
%token TOK_NOT
%token TOK_NULL
%token TOK_OR
%token TOK_PERCENT
//%token TOK_PERIOD
%token TOK_PLUS
%token TOK_RIGHTARROW
%token TOK_QUESTION
%token TOK_RBRACE
%token TOK_RBRACK
%token TOK_RPAREN
%token TOK_RSHIFT
%token TOK_SEMICOLON
%token TOK_SLASH
%token TOK_STAR
%token TOK_TRUE

/* Keywords */
%token TOK_CLASS
%token TOK_OPTIONAL
%token TOK_SYNTAX
%token TOK_SAMPLE
%token TOK_DEFAULT

/* Complex tokens. */
%token TOK_IDENTIFIER
%token TOK_INTEGER_LITERAL
%token TOK_FLOAT_LITERAL
%token TOK_SINGLE_QUOTED_STRING_LITERAL
%token TOK_DOUBLE_QUOTED_STRING_LITERAL

/* These tokens are never extracted from the source, they are used to cause
   Bison to parse a particular nonterminal. */
//%token TOK_START_EXPRESSION
//%token TOK_START_REFERENCE

%start start

/*
   And now the rules of the grammar.  As much as possible the actions of the
   grammar dispatch to some virtual operation of the object parser, so that it
   is possible to use different subclasses of classp::ParserBase for different
   purposes.  The result of the parsing is stored in *result.  As much as
   possible the names of the nonterminals follow those of the 'old' parser.
*/
%%

start:
    opt_code_literal declaration_list //TOK_EOF
  ;

opt_code_literal:
    %empty
  | TOK_SINGLE_QUOTED_STRING_LITERAL
  ;

operand:
    literal
  | identifier
  | TOK_NULL
  | TOK_LPAREN expression TOK_RPAREN
  ;

identifier:
    TOK_IDENTIFIER
  ;

numeric_literal:
    TOK_INTEGER_LITERAL
  | TOK_FLOAT_LITERAL
  ;

literal:
    numeric_literal
  | TOK_TRUE
  | TOK_FALSE
  | string_literal
  ;

string_literal:
    TOK_SINGLE_QUOTED_STRING_LITERAL
  | TOK_DOUBLE_QUOTED_STRING_LITERAL
  ;

/* Expressions. */

expression:
    conjunction
  | expression TOK_OR conjunction
  ;

conjunction:
    comparison
  | conjunction TOK_AND comparison
  ;

comparison:
    simple_expression
  | simple_expression relational_operator simple_expression
  ;

relational_operator:
    TOK_EQL
  | TOK_NEQ
  | TOK_LSS
  | TOK_LEQ
  | TOK_GTR
  | TOK_GEQ
  ;

simple_expression:
    term
  | simple_expression additive_operator term
  ;

additive_operator:
    TOK_PLUS
  | TOK_MINUS
  ;

term:
    factor
  | term multiplicative_operator factor
  ;

multiplicative_operator:
    TOK_STAR
  | TOK_SLASH
  | TOK_PERCENT
  | TOK_LSHIFT
  | TOK_RSHIFT
  ;

factor:
    operand
  | unary_operator operand
  ;

unary_operator:
    TOK_MINUS
  | TOK_NOT
  ;

declaration_list:
    /* for now we don't accept empty files */
    declaration
  | declaration_list opt_semicolon declaration
  ;

opt_semicolon: | TOK_SEMICOLON;

declaration:
    TOK_CLASS TOK_IDENTIFIER parents_list TOK_LBRACE class_body TOK_RBRACE
  ;

parents_list:
    %empty
  | TOK_COLON parents_list2
  ;

parents_list2:
    TOK_IDENTIFIER
  | parents_list2 TOK_COMMA TOK_IDENTIFIER
  ;

class_body:
    %empty
  | class_body attribute_decl TOK_SEMICOLON
  ;

attribute_decl:
    opt_optional TOK_IDENTIFIER TOK_IDENTIFIER opt_array opt_initializer
    opt_syntax_decl
  | syntax_decl
  | sample_decl
  | TOK_PERCENT identifier
  ;

opt_initializer:
    %empty
  | TOK_DEFAULT expression
  ;

opt_optional:
    %empty
  | TOK_OPTIONAL
  ;

opt_array:
    %empty
  | TOK_LBRACK TOK_RBRACK
  ;

opt_identifier:
    %empty
  | TOK_IDENTIFIER
  ;

opt_syntax_decl:
    %empty
  | syntax_decl
  ;

syntax_decl:
    TOK_SYNTAX opt_identifier TOK_LPAREN syntax_alt_list TOK_RPAREN features
  ;

sample_decl:
    TOK_SAMPLE TOK_LPAREN string_literal TOK_RPAREN
  | TOK_SAMPLE TOK_LPAREN string_literal TOK_COMMA identifier TOK_RPAREN
  | TOK_SAMPLE TOK_LPAREN string_literal TOK_COMMA string_literal TOK_RPAREN
  ;

features:
    %empty
  | features TOK_PERCENT identifier numeric_literal
  ;

syntax_alt_list:
    syntax_spec
  | syntax_alt_list TOK_BAR syntax_spec
  ;

syntax_spec:
    opt_syntax_item_list
  | opt_syntax_item_list TOK_STAR syntax_item_list
  | opt_syntax_item_list TOK_PLUS syntax_item_list
  | opt_syntax_item_list TOK_STAR
  | opt_syntax_item_list TOK_PLUS
  | opt_syntax_item_list TOK_QUESTION
  ;

opt_syntax_item_list:
   %empty
  | syntax_item_list
  ;

syntax_item_list:
    syntax_item
  | syntax_item_list syntax_item
  ;

syntax_item:
    string_literal
  | syntax_attribute
  | syntax_attribute TOK_LBRACE syntax_case_list TOK_RBRACE
  | TOK_LPAREN syntax_alt_list TOK_RPAREN
  ;

syntax_attribute:
    identifier
  ;

syntax_case_list:
    expression TOK_RIGHTARROW syntax_spec
  | syntax_case_list TOK_BAR expression TOK_RIGHTARROW syntax_spec
  ;

%%

%x squote_multiline

EOL    \r\n|\n

EXP    [eE]
SIGN    [+-]

BDIGIT    [01]
ODIGIT    [0-7]
DDIGIT    [[:digit:]]
XDIGIT    [[:xdigit:]]

ALNUM    [[:alnum:]_]
ALPHA    [[:alpha:]_]
BLANK    [[:blank:]\t]

DDIGITS  {DDIGIT}(_?{DDIGIT})*
EXPONENT {EXP}{SIGN}?{DDIGITS}

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"&&"	TOK_AND
"|"	TOK_BAR
"class"	TOK_CLASS
":"	TOK_COLON
","	TOK_COMMA
"default"	TOK_DEFAULT
//"$$"	TOK_DOLLARDOLLAR
//".."	TOK_DOTDOT
"=="	TOK_EQL
//"="	TOK_EQUAL
"false"	TOK_FALSE
">="	TOK_GEQ
">"	TOK_GTR
"{"	TOK_LBRACE
"["	TOK_LBRACK
"<="	TOK_LEQ
"("	TOK_LPAREN
"<<"	TOK_LSHIFT
"<"	TOK_LSS
"-"	TOK_MINUS
"!="	TOK_NEQ
"!"	TOK_NOT
"null"	TOK_NULL
"optional"	TOK_OPTIONAL
"||"	TOK_OR
"%"	TOK_PERCENT
//"."	TOK_PERIOD
"+"	TOK_PLUS
"?"	TOK_QUESTION
"}"	TOK_RBRACE
"]"	TOK_RBRACK
"->"	TOK_RIGHTARROW
")"	TOK_RPAREN
">>"	TOK_RSHIFT
"sample"	TOK_SAMPLE
";"	TOK_SEMICOLON
"/"	TOK_SLASH
"*"	TOK_STAR
//TOK_START_EXPRESSION	TOK_START_EXPRESSION
//TOK_START_REFERENCE	TOK_START_REFERENCE
"syntax"	TOK_SYNTAX
"true"	TOK_TRUE

\"(\\.|[^"\r\n\\])*\"	TOK_DOUBLE_QUOTED_STRING_LITERAL
'(\\.|''|[^'\r\n\\]*)'	TOK_SINGLE_QUOTED_STRING_LITERAL

@@'<>squote_multiline>
<squote_multiline>{
 '@@<INITIAL>	TOK_SINGLE_QUOTED_STRING_LITERAL
 ''<.>
 \n|.<.>
}

{DDIGITS}\.{DDIGITS}{EXPONENT}	TOK_FLOAT_LITERAL
{DDIGITS}\.{DDIGITS}	TOK_FLOAT_LITERAL
{DDIGITS}\.{EXPONENT}	TOK_FLOAT_LITERAL
{DDIGITS}{EXPONENT}	TOK_FLOAT_LITERAL
\.{DDIGITS}{EXPONENT}	TOK_FLOAT_LITERAL
\.{DDIGITS}	TOK_FLOAT_LITERAL

{DDIGITS}	TOK_INTEGER_LITERAL

{ALPHA}(-*{ALNUM})*	TOK_IDENTIFIER
`[^`[:cntrl:]]*`	TOK_IDENTIFIER

%%
