//From: https://github.com/clever-lang/clever/blob/2c03e4d4a4bd48b110226907fd158ba76bbccb97/core/parser.y

/**
 * Clever programming language
 * Copyright (c) Clever Team
 *
 * This file is distributed under the MIT license. See LICENSE for details.
 */

/*Tokens*/
%token VAR
%token TYPE
%token IDENT
%token NUM_INTEGER
%token NUM_DOUBLE
%token STR
%token FOR
%token WHILE
%token IF
%token ELSE
%token ELSEIF
%token LESS_EQUAL
%token GREATER_EQUAL
%token LESS
%token GREATER
%token RSHIFT
%token RSHIFT_EQUAL
%token LSHIFT
%token LSHIFT_EQUAL
%token BREAK
//%token EQUAL
%token NOT_EQUAL
%token IMPORT
%token PLUS_EQUAL
%token MULT_EQUAL
%token DIV_EQUAL
%token MINUS_EQUAL
%token MOD_EQUAL
%token BOOLEAN_OR
%token LOGICAL_OR
%token BOOLEAN_AND
%token LOGICAL_AND
%token BW_AND_EQUAL
%token BW_OR_EQUAL
%token BW_XOR_EQUAL
%token RETURN
%token TRUE
%token FALSE
%token CONST
%token FUNC
%token CRITICAL
%token INC
%token DEC
%token NIL
%token NEW
%token FINALLY
%token CATCH
%token TRY
%token THROW
%token CONTINUE
%token CONSTANT
%token CLASS
%token PUBLIC
%token PRIVATE
%token SWITCH
%token CASE
%token DEFAULT
%token IN
%token DO
%token STATIC
%token ','
%token '='
//%token XOR_EQUAL
%token ':'
%token '^'
%token '-'
%token '+'
%token '.'
%token '*'
%token '/'
%token '%'
%token '!'
%token '~'
%token '['
%token '{'
%token '}'
%token UMINUS
%token ';'
%token '('
%token ')'
%token ']'

%left /*1*/ ','
%left /*2*/ LOGICAL_OR
%left /*3*/ LOGICAL_AND
%right /*4*/ RSHIFT_EQUAL LSHIFT_EQUAL PLUS_EQUAL MULT_EQUAL DIV_EQUAL MINUS_EQUAL MOD_EQUAL BW_AND_EQUAL BW_OR_EQUAL BW_XOR_EQUAL //XOR_EQUAL
%left /*5*/ ':'
%left /*6*/ BOOLEAN_OR
%left /*7*/ BOOLEAN_AND
%left /*9*/ '^'
%nonassoc /*11*/ '=' NOT_EQUAL IN
%nonassoc /*12*/ LESS_EQUAL GREATER_EQUAL LESS GREATER
%left /*13*/ RSHIFT LSHIFT
%left /*14*/ '-' '+' '.'
%left /*15*/ '*' '/' '%'
%right /*16*/ '!'
%right /*17*/ INC DEC '~'
%right /*18*/ '[' '{' '}'
%left /*19*/ ELSEIF
%left /*20*/ ELSE
%left /*21*/ UMINUS

%start program

%%

program :
	statement_list
	;

statement_list :
	/*empty*/
	| statement_list statement
	;

statement :
	import ';'
	| variable_decl ';'
	| assignment ';'
	| fcall ';'
	| mcall ';'
	| fdecl
	| return_stmt ';'
	| if
	| while
	| for
	| inc_dec ';'
	| block
	| critical_block
	| throw ';'
	| break ';'
	| continue ';'
	| try_catch_finally
	| class_def
	| fully_qualified_call ';'
	| instantiation ';'
	| switch_expr
	| arithmetic ';'
	| bitwise ';'
	;

block :
	'{' /*18R*/ statement_list '}' /*18R*/
	;

instantiation :
	TYPE '.' /*14L*/ NEW
	| TYPE '.' /*14L*/ NEW '(' call_args ')'
	;

break :
	BREAK
	;

continue :
	CONTINUE
	;

critical_block :
	CRITICAL block
	;

object :
	IDENT
	| CONSTANT
	| STR
	| NUM_INTEGER
	| NUM_DOUBLE
	| NIL
	| TRUE
	| FALSE
	| map
	| array
	| '(' rvalue ')'
	| fcall
	| instantiation
	;

rvalue :
	object
	| subscript
	| unary
	| arithmetic
	| logic
	| bitwise
	| boolean
	| comparison
	| assignment
	| inc_dec
	| anonymous_fdecl
	| mcall
	| fully_qualified_call
	| property_access
	;

lvalue :
	IDENT
	| property_access
	| subscript
	;

subscript :
	lvalue '[' /*18R*/ rvalue ']'
	;

switch_expr :
	SWITCH '(' rvalue ')' '{' /*18R*/ case_list '}' /*18R*/
	;

label :
	IDENT
	| CONSTANT
	| STR
	| NUM_INTEGER
	| NUM_DOUBLE
	| property_access
	;

case_list :
	CASE label ':' /*5L*/ statement_list
	| DEFAULT ':' /*5L*/ statement_list
	| case_list CASE label ':' /*5L*/ statement_list
	| case_list DEFAULT ':' /*5L*/ statement_list
	;

unary :
	'-' /*14L*/ rvalue %prec UMINUS /*21L*/
	| '+' /*14L*/ rvalue %prec UMINUS /*21L*/
	| '!' /*16R*/ rvalue
	| '~' /*17R*/ rvalue
	;

class_def :
	CLASS TYPE '{' /*18R*/ class_member_decl '}' /*18R*/
	;

attr_rvalue :
	IDENT
	| CONSTANT
	| STR
	| NUM_INTEGER
	| NUM_DOUBLE
	| NIL
	| TRUE
	| FALSE
	;

class_attr_decl_list :
	class_attr_decl_impl
	| class_attr_decl_list ',' /*1L*/ class_attr_decl_impl
	;

class_attr_decl_impl :
	IDENT '=' /*4R*/ attr_rvalue
	| IDENT
	;

class_attr_const_decl_list :
	class_attr_const_decl_impl
	| class_attr_const_decl_list ',' /*1L*/ class_attr_const_decl_impl
	;

class_attr_const_decl_impl :
	IDENT '=' /*4R*/ attr_rvalue
	;

class_member_decl :
	/*empty*/
	| class_member_list
	;

visibility :
	/*empty*/
	| PUBLIC
	| PRIVATE
	;

class_member_list :
	visibility fdecl
	| STATIC visibility fdecl
	| visibility VAR class_attr_decl_list ';'
	| visibility CONST class_attr_const_decl_list ';'
	| class_member_list visibility fdecl
	| class_member_list STATIC visibility fdecl
	| class_member_list visibility VAR class_attr_decl_list ';'
	| class_member_list visibility CONST class_attr_const_decl_list ';'
	;

array :
	'[' /*18R*/ call_args ']'
	;

key_value_list :
	STR ':' /*5L*/ rvalue
	| key_value_list ',' /*1L*/ STR ':' /*5L*/ rvalue
	;

map :
	'{' /*18R*/ ':' /*5L*/ '}' /*18R*/
	| '{' /*18R*/ key_value_list '}' /*18R*/
	;

throw :
	THROW rvalue
	;

catch :
	not_empty_catch
	;

not_empty_catch :
	catch_impl
	| not_empty_catch catch_impl
	;

catch_impl :
	CATCH '(' IDENT ')' block
	;

finally :
	/*empty*/
	| FINALLY block
	;

try_catch_finally :
	TRY block catch finally
	;

property_access :
	object '.' /*14L*/ IDENT
	| object '.' /*14L*/ CONSTANT
	| TYPE '.' /*14L*/ IDENT
	| TYPE '.' /*14L*/ CONSTANT
	| property_access '.' /*14L*/ IDENT
	| property_access '.' /*14L*/ CONSTANT
	| subscript '.' /*14L*/ IDENT
	| subscript '.' /*14L*/ CONSTANT
	;

mcall_chain :
	/*empty*/
	| mcall_chain '.' /*14L*/ IDENT '(' call_args ')'
	| mcall_chain '.' /*14L*/ IDENT
	| mcall_chain '.' /*14L*/ CONSTANT
	;

mcall :
	object '.' /*14L*/ IDENT '(' call_args ')' mcall_chain
	| property_access '.' /*14L*/ IDENT '(' call_args ')' mcall_chain
	| TYPE '.' /*14L*/ IDENT '(' call_args ')' mcall_chain
	| subscript '.' /*14L*/ IDENT '(' call_args ')' mcall_chain
	;

inc_dec :
	object INC /*17R*/
	| object DEC /*17R*/
	| INC /*17R*/ object
	| DEC /*17R*/ object
	| property_access INC /*17R*/
	| property_access DEC /*17R*/
	| INC /*17R*/ property_access
	| DEC /*17R*/ property_access
	| subscript INC /*17R*/
	| subscript DEC /*17R*/
	| INC /*17R*/ subscript
	| DEC /*17R*/ subscript
	;

comparison :
	rvalue '=' /*11N*/ rvalue
	| rvalue NOT_EQUAL /*11N*/ rvalue
	| rvalue GREATER /*12N*/ rvalue
	| rvalue GREATER_EQUAL /*12N*/ rvalue
	| rvalue LESS /*12N*/ rvalue
	| rvalue LESS_EQUAL /*12N*/ rvalue
	;

boolean :
	rvalue BOOLEAN_OR /*6L*/ rvalue
	| rvalue BOOLEAN_AND /*7L*/ rvalue
	;

logic :
	rvalue LOGICAL_OR /*2L*/ rvalue
	| rvalue LOGICAL_AND /*3L*/ rvalue
	;

arithmetic :
	rvalue '+' /*14L*/ rvalue
	| rvalue '-' /*14L*/ rvalue
	| rvalue '*' /*15L*/ rvalue
	| rvalue '/' /*15L*/ rvalue
	| rvalue '%' /*15L*/ rvalue
	| lvalue PLUS_EQUAL /*4R*/ rvalue
	| lvalue MINUS_EQUAL /*4R*/ rvalue
	| lvalue MULT_EQUAL /*4R*/ rvalue
	| lvalue DIV_EQUAL /*4R*/ rvalue
	| lvalue MOD_EQUAL /*4R*/ rvalue
	;

bitwise :
	rvalue BOOLEAN_AND /*10L*/ rvalue
	| rvalue BOOLEAN_OR /*8L*/ rvalue
	| rvalue '^' /*9L*/ rvalue
	| rvalue LSHIFT /*13L*/ rvalue
	| rvalue RSHIFT /*13L*/ rvalue
	| lvalue BW_AND_EQUAL /*4R*/ rvalue
	| lvalue BW_OR_EQUAL /*4R*/ rvalue
	| lvalue BW_XOR_EQUAL /*4R*/ rvalue
	| lvalue LSHIFT_EQUAL /*4R*/ rvalue
	| lvalue RSHIFT_EQUAL /*4R*/ rvalue
	;

variable_decl :
	VAR variable_decl_list
	| CONST const_decl_list
	;

variable_decl_list :
	variable_decl_impl
	| variable_decl_list ',' /*1L*/ variable_decl_impl
	;

variable_decl_impl :
	IDENT '=' /*4R*/ rvalue
	| IDENT
	;

const_decl_list :
	const_decl_impl
	| const_decl_list ',' /*1L*/ const_decl_impl
	;

const_decl_impl :
	CONSTANT '=' /*4R*/ rvalue
	;

assignment :
	lvalue '=' /*4R*/ rvalue
	;

import_ident_list :
	IDENT
	| import_ident_list '.' /*14L*/ IDENT
	;

import :
	IMPORT import_ident_list '.' /*14L*/ '*' /*15L*/
	| IMPORT import_ident_list ':' /*5L*/ '*' /*15L*/
	| IMPORT import_ident_list ':' /*5L*/ IDENT
	| IMPORT import_ident_list ':' /*5L*/ TYPE
	| IMPORT import_ident_list
	;

vararg :
	IDENT '.' /*14L*/ '.' /*14L*/ '.' /*14L*/
	;

fdecl :
	FUNC IDENT '(' ')' block
	| FUNC TYPE '(' ')' block
	| FUNC '~' /*17R*/ TYPE '(' ')' block
	| FUNC IDENT '(' vararg ')' block
	| FUNC TYPE '(' vararg ')' block
	| FUNC IDENT '(' variable_decl_list ')' block
	| FUNC TYPE '(' variable_decl_list ')' block
	| FUNC IDENT '(' variable_decl_list ',' /*1L*/ vararg ')' block
	| FUNC TYPE '(' variable_decl_list ',' /*1L*/ vararg ')' block
	;

anonymous_fdecl :
	FUNC '(' ')' block
	| FUNC '(' vararg ')' block
	| FUNC '(' variable_decl_list ')' block
	| FUNC '(' variable_decl_list ',' /*1L*/ vararg ')' block
	;

call_args :
	/*empty*/
	| non_empty_call_args
	;

non_empty_call_args :
	rvalue
	| non_empty_call_args ',' /*1L*/ rvalue
	;

fcall_chain :
	/*empty*/
	| fcall_chain '(' call_args ')'
	| fcall_chain '[' /*18R*/ rvalue ']'
	;

fully_qualified_name :
	IDENT
	| fully_qualified_name ':' /*5L*/ IDENT
	;

fully_qualified_call :
	fully_qualified_name ':' /*5L*/ IDENT '(' call_args ')' fcall_chain
	| fully_qualified_name ':' /*5L*/ CONSTANT
	| fully_qualified_name ':' /*5L*/ IDENT
	| fully_qualified_name ':' /*5L*/ TYPE '.' /*14L*/ CONSTANT
	| fully_qualified_name ':' /*5L*/ TYPE '.' /*14L*/ NEW
	| fully_qualified_name ':' /*5L*/ TYPE '.' /*14L*/ NEW '(' call_args ')'
	| fully_qualified_name ':' /*5L*/ TYPE '.' /*14L*/ IDENT '(' call_args ')' mcall_chain
	;

fcall :
	IDENT '(' call_args ')' fcall_chain
	;

return_stmt :
	RETURN rvalue
	| RETURN
	;

while :
	WHILE '(' rvalue ')' block
	| DO block WHILE '(' rvalue ')' ';'
	;

for_expr_1 :
	/*empty*/
	| variable_decl
	| non_empty_call_args
	;

for_expr_2 :
	/*empty*/
	| rvalue
	;

for_expr_3 :
	call_args
	;

for :
	FOR '(' for_expr_1 ';' for_expr_2 ';' for_expr_3 ')' block
	| FOR '(' /*VAR*/ IDENT IN /*11N*/ rvalue ')' block
	;

elseif :
	/*empty*/
	| elseif ELSEIF /*19L*/ '(' rvalue ')' block
	;

else :
	/*empty*/
	| ELSE /*20L*/ block
	;

if :
	IF '(' rvalue ')' block elseif else
	;

%%

IDENTIFIER   [_a-z][a-zA-Z0-9_]*
INTEGER      [0-9]+
DOUBLE       [-]?([0-9]*"."[0-9]+)|[-]?([0-9]+"."[0-9]+)
EXP_DOUBLE   (({INTEGER}|{DOUBLE})[eE][+-]?{INTEGER})
HEXINT       [0][x][0-9a-zA-Z]+
OCTINT       [0][0-7]+
SPACE 	     [\r\t\v ]+
STRING       (["]([^\\"]*|"\\"["]?)*["]|[']([^\\']*|"\\"[']?)*['])
SPECIAL      [;(),{}&~^|=+*/-]
TYPE         [A-Z][a-zA-Z0-9_]*
CONSTANT     [A-Z][A-Z0-9_]*

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"^"	'^'
"~"	'~'
"="	'='
"-"	'-'
","	','
";"	';'
":"	':'
"!"	'!'
"/"	'/'
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"*"	'*'
"%"	'%'
"+"	'+'

"&"	BOOLEAN_AND
"|"	BOOLEAN_OR
break	BREAK
"&="	BW_AND_EQUAL
"|="	BW_OR_EQUAL
"^⁼"	BW_XOR_EQUAL
case	CASE
catch	CATCH
class	CLASS
const	CONST
continue	CONTINUE
critical	CRITICAL
"--"	DEC
default	DEFAULT
"/="	DIV_EQUAL
do	DO
else	ELSE
elseif	ELSEIF
"="	EQUAL
false	FALSE
finally	FINALLY
for	FOR
function	FUNC
">"	GREATER
">="	GREATER_EQUAL
if	IF
import	IMPORT
in	IN
"++"	INC
"<"	LESS
"<="	LESS_EQUAL
"&&"	LOGICAL_AND
"||"	LOGICAL_OR
"<<"	LSHIFT
"<<="	LSHIFT_EQUAL
"-="	MINUS_EQUAL
"%="	MOD_EQUAL
"*="	MULT_EQUAL
new	NEW
nil	NIL
"!="	NOT_EQUAL
"+="	PLUS_EQUAL
private	PRIVATE
public	PUBLIC
return	RETURN
">>"	RSHIFT
">>="	RSHIFT_EQUAL
static	STATIC
switch	SWITCH
throw	THROW
true	TRUE
try	TRY
var	VAR
while	WHILE

{STRING}	STR
{DOUBLE}|{EXP_DOUBLE}	NUM_DOUBLE
{INTEGER}|{HEXINT}|{OCTINT}	NUM_INTEGER
{CONSTANT}	CONSTANT
{IDENTIFIER}	IDENT
{TYPE}	TYPE

%%
