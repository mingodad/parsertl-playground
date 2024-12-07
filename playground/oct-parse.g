//From: https://github.com/gnu-octave/octave/blob/b2224b4a529daa83b80b389f187c9e0f48c0e0f1/libinterp/parse-tree/oct-parse.yy
////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 1993-2024 The Octave Project Developers
//
// See the file COPYRIGHT.md in the top-level directory of this
// distribution or <https://octave.org/copyright/>.
//
// This file is part of Octave.
//
// Octave is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Octave is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Octave; see the file COPYING.  If not, see
// <https://www.gnu.org/licenses/>.
//
////////////////////////////////////////////////////////////////////////

/*Tokens*/
%token ADD_EQ
%token AND_EQ
%token ARGUMENTS
%token BREAK
%token CASE
%token CATCH
%token CLASSDEF
%token CLEANUP
//%token CONSTANT
%token CONTINUE
%token DIV_EQ
%token DO
%token DQ_STRING
%token EDIV
%token EDIV_EQ
%token ELEFTDIV
%token ELEFTDIV_EQ
%token ELSE
%token ELSEIF
%token EMUL
%token EMUL_EQ
%token END
%token END_OF_INPUT
%token ENUMERATION
%token EPOW
%token EPOW_EQ
%token EVENTS
%token EXPR_AND
%token EXPR_AND_AND
%token EXPR_EQ
%token EXPR_GE
%token EXPR_GT
%token EXPR_LE
%token EXPR_LT
%token EXPR_NE
%token EXPR_OR
%token EXPR_OR_OR
%token FCN_HANDLE
%token FOR
%token FQ_IDENT
%token FUNCTION
%token GET
%token GLOBAL
%token HERMITIAN
%token IF
%token INPUT_FILE
%token LEFTDIV
%token LEFTDIV_EQ
//%token LEXICAL_ERROR
%token METAQUERY
%token METHODS
%token MINUS_MINUS
%token MUL_EQ
%token NAME
%token NL
%token NUMBER
%token OR_EQ
%token OTHERWISE
%token PARFOR
%token PERSISTENT
%token PLUS_PLUS
%token POW
%token POW_EQ
%token PROPERTIES
%token RETURN
%token SET
%token SPMD
%token SQ_STRING
%token STRUCT_ELT
%token SUB_EQ
%token SUPERCLASSREF
%token SWITCH
%token TRANSPOSE
%token TRY
%token UNTIL
%token UNWIND
%token WHILE

%fallback NAME FQ_IDENT

%right /*1*/ '=' ADD_EQ SUB_EQ MUL_EQ DIV_EQ LEFTDIV_EQ POW_EQ EMUL_EQ EDIV_EQ ELEFTDIV_EQ EPOW_EQ AND_EQ OR_EQ
%left /*2*/ EXPR_OR_OR
%left /*3*/ EXPR_AND_AND
%left /*4*/ EXPR_OR
%left /*5*/ EXPR_AND
%left /*6*/ EXPR_LT EXPR_LE EXPR_EQ EXPR_NE EXPR_GE EXPR_GT
%left /*7*/ ':'
%left /*8*/ '-' '+'
%left /*9*/ '*' '/' LEFTDIV EMUL EDIV ELEFTDIV
%right /*10*/ '~' '!' UNARY
%left /*11*/ HERMITIAN TRANSPOSE POW EPOW
%right /*12*/ PLUS_PLUS MINUS_MINUS
%left /*13*/ '(' '{' '.'

%start input

%%

input :
	simple_list NL
	| simple_list END_OF_INPUT
	| file
	//| parse_error
	;

simple_list :
	opt_sep_no_nl
	| simple_list1 opt_sep_no_nl
	;

simple_list1 :
	statement
	| simple_list1 sep_no_nl statement
	;

statement_list :
	opt_sep opt_list
	;

opt_list :
	/*empty*/
	| list
	;

list :
	list1 opt_sep
	;

list1 :
	statement
	| list1 sep statement
	;

opt_fcn_list :
	/*empty*/
	| fcn_list
	;

fcn_list :
	fcn_list1 opt_sep
	;

fcn_list1 :
	function
	| fcn_list1 opt_sep function
	;

statement :
	expression
	| command
	| word_list_cmd
	;

word_list_cmd :
	identifier word_list
	;

word_list :
	string
	| word_list string
	;

identifier :
	NAME
	;

superclass_identifier :
	SUPERCLASSREF
	;

meta_identifier :
	METAQUERY
	;

string :
	DQ_STRING
	| SQ_STRING
	;

constant :
	NUMBER
	| string
	;

matrix :
	'[' matrix_rows ']'
	;

matrix_rows :
	cell_or_matrix_row
	| matrix_rows ';' cell_or_matrix_row
	;

cell :
	'{' /*13L*/ cell_rows '}'
	;

cell_rows :
	cell_or_matrix_row
	| cell_rows ';' cell_or_matrix_row
	;

cell_or_matrix_row :
	/*empty*/
	| ','
	| arg_list
	| arg_list ','
	| ',' arg_list
	| ',' arg_list ','
	;

fcn_handle :
	FCN_HANDLE
	;

anon_fcn_handle :
	'@' param_list anon_fcn_begin expression
	//| '@' param_list anon_fcn_begin error
	;

primary_expr :
	identifier
	| constant
	| fcn_handle
	| matrix
	| cell
	| meta_identifier
	| superclass_identifier
	| '(' /*13L*/ expression ')'
	;

magic_colon :
	':' /*7L*/
	;

magic_tilde :
	'~' /*10R*/
	;

arg_list :
	expression
	| magic_colon
	| magic_tilde
	| arg_list ',' magic_colon
	| arg_list ',' magic_tilde
	| arg_list ',' expression
	;

indirect_ref_op :
	'.' /*13L*/
	;

oper_expr :
	primary_expr
	| oper_expr PLUS_PLUS /*12R*/
	| oper_expr MINUS_MINUS /*12R*/
	| oper_expr '(' /*13L*/ ')'
	| oper_expr '(' /*13L*/ arg_list ')'
	| oper_expr '{' /*13L*/ '}'
	| oper_expr '{' /*13L*/ arg_list '}'
	| oper_expr HERMITIAN /*11L*/
	| oper_expr TRANSPOSE /*11L*/
	| oper_expr indirect_ref_op STRUCT_ELT
	| oper_expr indirect_ref_op '(' /*13L*/ expression ')'
	| PLUS_PLUS /*12R*/ oper_expr %prec UNARY /*10R*/
	| MINUS_MINUS /*12R*/ oper_expr %prec UNARY /*10R*/
	| '~' /*10R*/ oper_expr %prec UNARY /*10R*/
	| '!' /*10R*/ oper_expr %prec UNARY /*10R*/
	| '+' /*8L*/ oper_expr %prec UNARY /*10R*/
	| '-' /*8L*/ oper_expr %prec UNARY /*10R*/
	| oper_expr POW /*11L*/ power_expr
	| oper_expr EPOW /*11L*/ power_expr
	| oper_expr '+' /*8L*/ oper_expr
	| oper_expr '-' /*8L*/ oper_expr
	| oper_expr '*' /*9L*/ oper_expr
	| oper_expr '/' /*9L*/ oper_expr
	| oper_expr EMUL /*9L*/ oper_expr
	| oper_expr EDIV /*9L*/ oper_expr
	| oper_expr LEFTDIV /*9L*/ oper_expr
	| oper_expr ELEFTDIV /*9L*/ oper_expr
	;

power_expr :
	primary_expr
	| power_expr PLUS_PLUS /*12R*/
	| power_expr MINUS_MINUS /*12R*/
	| power_expr '(' /*13L*/ ')'
	| power_expr '(' /*13L*/ arg_list ')'
	| power_expr '{' /*13L*/ '}'
	| power_expr '{' /*13L*/ arg_list '}'
	| power_expr indirect_ref_op STRUCT_ELT
	| power_expr indirect_ref_op '(' /*13L*/ expression ')'
	| PLUS_PLUS /*12R*/ power_expr %prec POW /*11L*/
	| MINUS_MINUS /*12R*/ power_expr %prec POW /*11L*/
	| '~' /*10R*/ power_expr %prec POW /*11L*/
	| '!' /*10R*/ power_expr %prec POW /*11L*/
	| '+' /*8L*/ power_expr %prec POW /*11L*/
	| '-' /*8L*/ power_expr %prec POW /*11L*/
	;

colon_expr :
	oper_expr ':' /*7L*/ oper_expr
	| oper_expr ':' /*7L*/ oper_expr ':' /*7L*/ oper_expr
	;

simple_expr :
	oper_expr
	| colon_expr
	| simple_expr EXPR_LT /*6L*/ simple_expr
	| simple_expr EXPR_LE /*6L*/ simple_expr
	| simple_expr EXPR_EQ /*6L*/ simple_expr
	| simple_expr EXPR_GE /*6L*/ simple_expr
	| simple_expr EXPR_GT /*6L*/ simple_expr
	| simple_expr EXPR_NE /*6L*/ simple_expr
	| simple_expr EXPR_AND /*5L*/ simple_expr
	| simple_expr EXPR_OR /*4L*/ simple_expr
	| simple_expr EXPR_AND_AND /*3L*/ simple_expr
	| simple_expr EXPR_OR_OR /*2L*/ simple_expr
	;

assign_lhs :
	simple_expr
	;

assign_expr :
	assign_lhs '=' /*1R*/ expression
	| assign_lhs ADD_EQ /*1R*/ expression
	| assign_lhs SUB_EQ /*1R*/ expression
	| assign_lhs MUL_EQ /*1R*/ expression
	| assign_lhs DIV_EQ /*1R*/ expression
	| assign_lhs LEFTDIV_EQ /*1R*/ expression
	| assign_lhs POW_EQ /*1R*/ expression
	| assign_lhs EMUL_EQ /*1R*/ expression
	| assign_lhs EDIV_EQ /*1R*/ expression
	| assign_lhs ELEFTDIV_EQ /*1R*/ expression
	| assign_lhs EPOW_EQ /*1R*/ expression
	| assign_lhs AND_EQ /*1R*/ expression
	| assign_lhs OR_EQ /*1R*/ expression
	;

expression :
	simple_expr
	| assign_expr
	| anon_fcn_handle
	;

command :
	declaration
	| select_command
	| loop_command
	| jump_command
	| spmd_command
	| except_command
	| function
	;

declaration :
	GLOBAL decl_init_list
	| PERSISTENT decl_init_list
	;

decl_init_list :
	decl_elt
	| decl_init_list decl_elt
	;

decl_elt :
	identifier
	| identifier '=' /*1R*/ expression
	;

select_command :
	if_command
	| switch_command
	;

if_command :
	if_clause_list else_clause END
	;

if_clause_list :
	if_clause
	| if_clause_list elseif_clause
	;

if_clause :
	IF opt_sep expression stmt_begin statement_list
	;

elseif_clause :
	ELSEIF opt_sep expression stmt_begin statement_list
	;

else_clause :
	/*empty*/
	| ELSE statement_list
	;

switch_command :
	SWITCH expression opt_sep case_list END
	;

case_list :
	/*empty*/
	| default_case
	| case_list1
	| case_list1 default_case
	;

case_list1 :
	switch_case
	| case_list1 switch_case
	;

switch_case :
	CASE opt_sep expression stmt_begin statement_list
	;

default_case :
	OTHERWISE statement_list
	;

loop_command :
	WHILE expression stmt_begin statement_list END
	| DO statement_list UNTIL expression
	| FOR assign_lhs '=' /*1R*/ expression stmt_begin statement_list END
	| FOR '(' /*13L*/ assign_lhs '=' /*1R*/ expression ')' statement_list END
	| PARFOR assign_lhs '=' /*1R*/ expression stmt_begin statement_list END
	| PARFOR '(' /*13L*/ assign_lhs '=' /*1R*/ expression ',' expression ')' statement_list END
	;

jump_command :
	BREAK
	| CONTINUE
	| RETURN
	;

spmd_command :
	SPMD statement_list END
	;

except_command :
	UNWIND statement_list CLEANUP statement_list END
	| TRY statement_list CATCH opt_sep opt_list END
	| TRY statement_list END
	;

push_fcn_symtab :
	/*empty*/
	;

param_list_beg :
	'(' /*13L*/
	;

param_list_end :
	')'
	;

opt_param_list :
	/*empty*/
	| param_list
	;

param_list :
	param_list_beg param_list1 param_list_end
	//| param_list_beg error
	;

param_list1 :
	/*empty*/
	| param_list2
	;

param_list2 :
	param_list_elt
	| param_list2 ',' param_list_elt
	;

param_list_elt :
	decl_elt
	| magic_tilde
	;

return_list :
	'[' ']'
	| identifier
	| '[' return_list1 ']'
	;

return_list1 :
	identifier
	| return_list1 ',' identifier
	;

parsing_local_fcns :
	/*empty*/
	;

push_script_symtab :
	/*empty*/
	;

begin_file :
	push_script_symtab INPUT_FILE
	;

file :
	begin_file statement_list END_OF_INPUT
	| begin_file opt_sep classdef parsing_local_fcns opt_sep opt_fcn_list END_OF_INPUT
	;

function_beg :
	push_fcn_symtab FUNCTION
	;

fcn_name :
	identifier
	| GET '.' /*13L*/ identifier
	| SET '.' /*13L*/ identifier
	;

function_end :
	END
	| END_OF_INPUT
	;

function :
	function_beg fcn_name opt_param_list function_body function_end
	| function_beg return_list '=' /*1R*/ fcn_name opt_param_list function_body function_end
	;

function_body :
	statement_list
	| opt_sep arguments_block_list statement_list
	;

arguments_block_list :
	arguments_block
	| arguments_block_list opt_sep arguments_block
	;

arguments_block :
	arguments_beg opt_sep args_attr_list args_validation_list opt_sep END
	;

arguments_beg :
	ARGUMENTS
	;

args_attr_list :
	/*empty*/
	| '(' /*13L*/ identifier ')'
	;

args_validation_list :
	arg_name arg_validation
	| args_validation_list sep arg_name arg_validation
	;

arg_name :
	identifier
	;

arg_validation :
	size_spec class_name validation_fcns
	| size_spec class_name validation_fcns '=' /*1R*/ expression
	;

size_spec :
	/*empty*/
	| '(' /*13L*/ arg_list ')'
	;

class_name :
	/*empty*/
	| identifier
	;

validation_fcns :
	/*empty*/
	| '{' /*13L*/ arg_list '}'
	;

classdef_beg :
	CLASSDEF
	;

classdef :
	classdef_beg attr_list identifier opt_sep superclass_list class_body END
	;

attr_list :
	/*empty*/
	| '(' /*13L*/ attr_list1 ')' opt_sep
	;

attr_list1 :
	attr
	| attr_list1 ',' attr
	;

attr :
	identifier
	| identifier '=' /*1R*/ expression
	| '~' /*10R*/ identifier
	| '!' /*10R*/ identifier
	;

superclass_list :
	/*empty*/
	| superclass_list1 opt_sep
	;

superclass_list1 :
	EXPR_LT /*6L*/ superclass
	| superclass_list1 EXPR_AND /*5L*/ superclass
	;

superclass :
	FQ_IDENT
	;

class_body :
	/*empty*/
	| class_body1 opt_sep
	;

class_body1 :
	properties_block
	| methods_block
	| events_block
	| enum_block
	| class_body1 opt_sep properties_block
	| class_body1 opt_sep methods_block
	| class_body1 opt_sep events_block
	| class_body1 opt_sep enum_block
	;

properties_block :
	properties_beg opt_sep attr_list property_list END
	;

properties_beg :
	PROPERTIES
	;

property_list :
	/*empty*/
	| property_list1 opt_sep
	;

property_list1 :
	class_property
	| property_list1 sep class_property
	;

class_property :
	identifier arg_validation
	;

methods_block :
	methods_beg opt_sep attr_list method_list END
	;

methods_beg :
	METHODS
	;

method_decl1 :
	identifier
	| identifier param_list
	;

method_decl :
	method_decl1
	| return_list '=' /*1R*/ method_decl1
	;

method :
	method_decl
	| function
	;

method_list :
	/*empty*/
	| method_list1 opt_sep
	;

method_list1 :
	method
	| method_list1 opt_sep method
	;

events_block :
	events_beg opt_sep attr_list event_list END
	;

events_beg :
	EVENTS
	;

event_list :
	/*empty*/
	| event_list1 opt_sep
	;

event_list1 :
	class_event
	| event_list1 opt_sep class_event
	;

class_event :
	identifier
	;

enum_block :
	enumeration_beg opt_sep attr_list enum_list END
	;

enumeration_beg :
	ENUMERATION
	;

enum_list :
	/*empty*/
	| enum_list1 opt_sep
	;

enum_list1 :
	class_enum
	| enum_list1 opt_sep class_enum
	;

class_enum :
	identifier '(' /*13L*/ expression ')'
	;

stmt_begin :
	/*empty*/
	;

anon_fcn_begin :
	/*empty*/
	;

//parse_error :
//	LEXICAL_ERROR
//	//| error
//	;

sep_no_nl :
	','
	| ';'
	| sep_no_nl ','
	| sep_no_nl ';'
	;

opt_sep_no_nl :
	/*empty*/
	| sep_no_nl
	;

sep :
	','
	| ';'
	| NL
	| sep ','
	| sep ';'
	| sep NL
	;

opt_sep :
	/*empty*/
	| sep
	;

%%

D       [0-9]
D_      [0-9_]
S       [ \t]
NL      ((\n)|(\r)|(\r\n))
CCHAR   [#%]
IDENT   ([_a-zA-Z][_a-zA-Z0-9]*)
FQIDENT ({IDENT}({S}*\.{S}*{IDENT})+)

/*
// Decimal numbers may be real or imaginary but always create
// double precision constants initially.  Any conversion to single
// precision happens as part of an expression evaluation in the
// interpreter, not the lexer and parser.
*/

DECIMAL_DIGITS ({D}{D_}*)
EXPONENT       ([DdEe][+-]?{DECIMAL_DIGITS})
REAL_DECIMAL   ((({DECIMAL_DIGITS}\.?)|({DECIMAL_DIGITS}?\.{DECIMAL_DIGITS})){EXPONENT}?)
IMAG_DECIMAL   ({REAL_DECIMAL}[IiJj])
DECIMAL_NUMBER ({REAL_DECIMAL}|{IMAG_DECIMAL})

/*
// It is possible to specify signedness and size for binary and
// hexadecimal numbers but there is no special syntax for imaginary
// constants.  Binary and hexadecimal constants always create integer
// valued constants ({u,}int{8,16,32,64}).  If a size is not specified,
// the smallest integer type that will hold the value is used.  Negative
// values may be created with a signed size specification by applying
// twos-complement conversion (for example, 0xffs8 produces an 8-bit
// signed integer equal to -1 and 0b10000000s8 produces an 8-bit signed
// integer equal to -128).
*/

SIZE_SUFFIX        ([su](8|16|32|64))
BINARY_BITS        (0[bB][01][01_]*)
BINARY_NUMBER      ({BINARY_BITS}|{BINARY_BITS}{SIZE_SUFFIX})
HEXADECIMAL_BITS   (0[xX][0-9a-fA-F][0-9a-fA-F_]*)
HEXADECIMAL_NUMBER ({HEXADECIMAL_BITS}|{HEXADECIMAL_BITS}{SIZE_SUFFIX})

ANY_EXCEPT_NL [^\r\n]
ANY_INCLUDING_NL (.|{NL})

%%

{S}+	skip()
{CCHAR}.*{NL}?	skip()

"!"	'!'
"("	'('
")"	')'
"*"	'*'
"+"	'+'
","	','
"-"	'-'
"."	'.'
"/"	'/'
":"	':'
";"	';'
"="	'='
"@"	'@'
"["	'['
{NL}	NL
"]"	']'
"{"	'{'
"}"	'}'
"~"	'~'
"+="	ADD_EQ
"&="	AND_EQ
arguments	ARGUMENTS
break	BREAK
case	CASE
catch	CATCH
classdef	CLASSDEF
unwind_protect_cleanup	CLEANUP
//CONSTANT	CONSTANT
continue	CONTINUE
"/="	DIV_EQ
do	DO
"./"	EDIV
"./="	EDIV_EQ
".\\"	ELEFTDIV
".\\="	ELEFTDIV_EQ
else	ELSE
elseif	ELSEIF
".*"	EMUL
".*="	EMUL_EQ
end|end_try_catch|end_unwind_protect|endarguments|endclassdef	END
endenumeration|endevents|endfor|endfunction|endif|endmethods	END
endparfor|endproperties|endspmd|endswitch|endwhile	END
END_OF_INPUT	END_OF_INPUT
enumeration	ENUMERATION
".^"	EPOW
"-^="	EPOW_EQ
events	EVENTS
"&"	EXPR_AND
"&&"	EXPR_AND_AND
"=="	EXPR_EQ
">="	EXPR_GE
">"	EXPR_GT
"<="	EXPR_LE
"<"	EXPR_LT
"!="|"~="	EXPR_NE
"|"	EXPR_OR
"||"	EXPR_OR_OR
FCN_HANDLE	FCN_HANDLE
for	FOR
function	FUNCTION
get	GET
global	GLOBAL
hermitian	HERMITIAN
if	IF
INPUT_FILE	INPUT_FILE
"\\"	LEFTDIV
"\\="	LEFTDIV_EQ
methods	METHODS
"--"	MINUS_MINUS
"*="	MUL_EQ
"|="	OR_EQ
otherwise	OTHERWISE
parfor	PARFOR
persistent	PERSISTENT
"++"	PLUS_PLUS
"^"	POW
"^="	POW_EQ
properties	PROPERTIES
return	RETURN
set	SET
spmd	SPMD
"-="	SUB_EQ
switch	SWITCH
transpose	TRANSPOSE
try	TRY
until	UNTIL
unwind_protect	UNWIND
while	WHILE

//__FILE__	__FILE__
//__LINE__	__LINE__

{DECIMAL_NUMBER}	NUMBER
{HEXADECIMAL_NUMBER}	NUMBER

'(\\.|[^'\r\n\\])*'	SQ_STRING
\"(\\.|[^"\r\n\\])*\"	DQ_STRING

STRUCT_ELT	STRUCT_ELT
"?"{FQIDENT}	METAQUERY
"@"{FQIDENT}	SUPERCLASSREF
{FQIDENT}	FQ_IDENT
{IDENT}	NAME

%%
