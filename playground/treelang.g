/* TREELANG Compiler parser.

---------------------------------------------------------------------

Copyright (C) 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2007
Free Software Foundation, Inc.

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 3, or (at your option) any
later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; see the file COPYING3.  If not see
<http://www.gnu.org/licenses/>.

In other words, you are welcome to use, share and improve this program.
You are forbidden to forbid anyone else to use, share and improve
what you give them.   Help stamp out software-hoarding!

---------------------------------------------------------------------

Written by Tim Josling 1999-2001, based in part on other parts of
the GCC compiler.  */

/* Grammar Conflicts
   *****************
   There are no conflicts in this grammar.  Please keep it that way.  */

/*Tokens*/
%token RIGHT_BRACE
%token LEFT_BRACE
//%token RIGHT_SQUARE_BRACKET
//%token LEFT_SQUARE_BRACKET
%token RIGHT_PARENTHESIS
%token LEFT_PARENTHESIS
%token SEMICOLON
//%token ASTERISK
%token COMMA
%token EQUALS
%token ASSIGN
%token tl_PLUS
%token tl_MINUS
%token INTEGER
%token IF
%token ELSE
%token tl_RETURN
%token CHAR
%token INT
%token UNSIGNED
%token VOID
//%token TYPEDEF
%token NAME
%token STATIC
%token AUTOMATIC
%token EXTERNAL_DEFINITION
%token EXTERNAL_REFERENCE
//%token WHITESPACE
//%token COMMENT
//%token PROD_VARIABLE_NAME
//%token PROD_TYPE_NAME
//%token PROD_FUNCTION_NAME
//%token PROD_INTEGER_CONSTANT
//%token PROD_PLUS_EXPRESSION
//%token PROD_MINUS_EXPRESSION
//%token PROD_ASSIGN_EXPRESSION
//%token PROD_VARIABLE_REFERENCE_EXPRESSION
//%token PROD_PARAMETER
//%token PROD_FUNCTION_INVOCATION

%right /*1*/ EQUALS
%right /*2*/ ASSIGN
%left /*3*/ tl_PLUS
%left /*4*/ tl_MINUS

%start file

%%

file :
	/*empty*/
	| declarations
	;

declarations :
	declaration
	| declarations declaration
	;

declaration :
	variable_def
	| function_prototype
	| function
	;

variable_def :
	storage typename NAME init_opt SEMICOLON
	;

storage :
	STATIC
	| AUTOMATIC
	| EXTERNAL_DEFINITION
	| EXTERNAL_REFERENCE
	;

parameter :
	typename NAME
	;

function_prototype :
	storage typename NAME LEFT_PARENTHESIS parameters_opt RIGHT_PARENTHESIS SEMICOLON
	;

function :
	NAME LEFT_BRACE variable_defs_opt statements_opt RIGHT_BRACE
	;

variable_defs_opt :
	/*empty*/
	| variable_defs
	;

statements_opt :
	/*empty*/
	| statements
	;

variable_defs :
	variable_def
	| variable_defs variable_def
	;

typename :
	INT
	| UNSIGNED INT
	| CHAR
	| UNSIGNED CHAR
	| VOID
	;

parameters_opt :
	/*empty*/
	| parameters
	;

parameters :
	parameter
	| parameters COMMA parameter
	;

statements :
	statement
	| statements statement
	;

statement :
	expression SEMICOLON
	| return SEMICOLON
	| if_statement
	;

if_statement :
	IF LEFT_PARENTHESIS expression RIGHT_PARENTHESIS LEFT_BRACE variable_defs_opt statements_opt RIGHT_BRACE ELSE LEFT_BRACE variable_defs_opt statements_opt RIGHT_BRACE
	;

return :
	tl_RETURN expression_opt
	;

expression_opt :
	/*empty*/
	| expression
	;

expression :
	INTEGER
	| variable_ref
	| expression tl_PLUS /*3L*/ expression
	| expression tl_MINUS /*4L*/ expression %prec tl_PLUS /*3L*/
	| expression EQUALS /*1R*/ expression
	| variable_ref ASSIGN /*2R*/ expression
	| function_invocation
	;

function_invocation :
	NAME LEFT_PARENTHESIS expressions_with_commas_opt RIGHT_PARENTHESIS
	;

expressions_with_commas_opt :
	/*empty*/
	| expressions_with_commas
	;

expressions_with_commas :
	expression
	| expressions_with_commas COMMA expression
	;

variable_ref :
	NAME
	;

init_opt :
	/*empty*/
	| init
	;

init :
	ASSIGN /*2R*/ init_element
	;

init_element :
	INTEGER
	;

%%

%%

[ \n\t]+ skip()

"//".*  skip()

"{" LEFT_BRACE

"}" RIGHT_BRACE

"(" LEFT_PARENTHESIS

")" RIGHT_PARENTHESIS

"," COMMA

";" SEMICOLON

"+" tl_PLUS

"-" tl_MINUS

"=" ASSIGN

"==" EQUALS

[+-]?[0-9]+ INTEGER

"external_reference" EXTERNAL_REFERENCE

"external_definition" EXTERNAL_DEFINITION

"static" STATIC

"automatic" AUTOMATIC

"int" INT

"char" CHAR

"void" VOID

"unsigned" UNSIGNED

"return" tl_RETURN

"if" IF

"else" ELSE

[A-Za-z_]+[A-Za-z_0-9]* NAME

//[^\n]  error ("%HUnrecognized character %qc.");


%%
