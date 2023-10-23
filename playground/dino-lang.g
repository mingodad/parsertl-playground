//From: https://github.com/dino-lang/dino/blob/7d86688ab5a9ecee66c2b4fd18df16346361957d/DINO/d_yacc.y
/*
   Copyright (C) 1997-2016 Vladimir Makarov.

   Written by Vladimir Makarov <vmakarov@gcc.gnu.org>

   This file is part of interpreter of DINO.

   This is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This software is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with GNU CC; see the file COPYING.  If not, write to the Free
   Software Foundation, 59 Temple Place - Suite 330, Boston, MA
   02111-1307, USA.

*/

/*Tokens*/
%token NUMBER
%token CHARACTER
%token STRING
%token IDENT
%token CODE
%token BREAK
%token CASE
%token CATCH
%token CHAR
%token CLASS
%token CONTINUE
%token ELSE
%token EXPOSE
%token EXTERN
%token FIBER
%token FINAL
%token FLOAT
%token FOR
%token FORMER
%token FRIEND
%token FUN
%token HIDE
%token HIDEBLOCK
%token IF
%token IN
%token INT
%token LONG
%token LATER
%token NEW
%token NIL
%token OBJ
%token PMATCH
%token PRIV
%token PUB
%token REQUIRE
%token RETURN
%token RMATCH
%token TAB
%token THIS
%token THREAD
%token THROW
%token TRY
%token TYPE
%token USE
%token VAL
%token VAR
%token VEC
%token WAIT
%token LOGICAL_OR
%token LOGICAL_AND
%token EQ
%token NE
%token IDENTITY
%token UNIDENTITY
%token LE
%token GE
%token LSHIFT
%token RSHIFT
%token ASHIFT
%token MULT_ASSIGN
%token DIV_ASSIGN
%token MOD_ASSIGN
%token PLUS_ASSIGN
%token MINUS_ASSIGN
%token CONCAT_ASSIGN
%token LSHIFT_ASSIGN
%token RSHIFT_ASSIGN
%token ASHIFT_ASSIGN
%token AND_ASSIGN
%token XOR_ASSIGN
%token OR_ASSIGN
%token INCR
%token DECR
%token DOTS
%token FOLD_PLUS
%token FOLD_MULT
%token FOLD_AND
%token FOLD_XOR
%token FOLD_OR
%token FOLD_CONCAT
%token INCLUDE
%token INCLUSION
//%token END_OF_FILE
%token END_OF_INCLUDE_FILE
%token WILDCARD
%token '?'
%token ':'
%token '|'
%token '^'
%token '&'
%token '<'
%token '>'
%token '@'
%token '+'
%token '-'
%token '*'
%token '/'
%token '%'
%token '!'
%token '~'
%token '#'
%token '('
%token ')'
%token '['
%token ']'
%token '{'
%token '}'
%token ';'
%token '.'
%token ','
%token '='

%nonassoc /*1*/ ':'
%nonassoc /*2*/ '?'
%left /*3*/ LOGICAL_OR
%left /*4*/ LOGICAL_AND
%left /*5*/ IN
%left /*6*/ '|'
%left /*7*/ '^'
%left /*8*/ '&'
%left /*9*/ EQ NE IDENTITY UNIDENTITY
%left /*10*/ LE GE '<' '>'
%left /*11*/ LSHIFT RSHIFT ASHIFT
%left /*12*/ '@'
%left /*13*/ '+' '-'
%left /*14*/ '*' '/' '%'
%left /*15*/ FINAL NEW FOLD_PLUS FOLD_MULT FOLD_AND FOLD_XOR FOLD_OR FOLD_CONCAT '!' '~' '#'
%nonassoc /*16*/ CHAR FLOAT INT LONG TAB TYPE VEC
%left /*17*/ '(' '[' '.'

%start program

%%

//clear_flag :
//	/*empty*/
//	;

//set_flag :
//	/*empty*/
//	;

//set_flag2 :
//	/*empty*/
//	;

expr :
	NUMBER
	| CHARACTER
	| NIL
	| STRING
	| type
	| expr '?' /*2N*/ expr ':' /*1N*/ expr
	| expr LOGICAL_OR /*3L*/ expr
	| expr LOGICAL_AND /*4L*/ expr
	| expr IN /*5L*/ expr
	| expr '|' /*6L*/ expr
	| expr '^' /*7L*/ expr
	| expr '&' /*8L*/ expr
	| expr EQ /*9L*/ expr
	| expr NE /*9L*/ expr
	| expr IDENTITY /*9L*/ expr
	| expr UNIDENTITY /*9L*/ expr
	| expr '<' /*10L*/ expr
	| expr '>' /*10L*/ expr
	| expr LE /*10L*/ expr
	| expr GE /*10L*/ expr
	| expr LSHIFT /*11L*/ expr
	| expr RSHIFT /*11L*/ expr
	| expr ASHIFT /*11L*/ expr
	| expr '@' /*12L*/ expr
	| expr '+' /*13L*/ expr
	| expr '-' /*13L*/ expr
	| expr '*' /*14L*/ expr
	| expr '/' /*14L*/ expr
	| expr '%' /*14L*/ expr
	| '!' /*15L*/ expr
	| '+' /*13L*/ expr %prec '!' /*15L*/
	| '-' /*13L*/ expr %prec '!' /*15L*/
	| '~' /*15L*/ expr
	| '#' /*15L*/ expr
	| FOLD_PLUS /*15L*/ expr
	| FOLD_MULT /*15L*/ expr
	| FOLD_AND /*15L*/ expr
	| FOLD_XOR /*15L*/ expr
	| FOLD_OR /*15L*/ expr
	| FOLD_CONCAT /*15L*/ expr
	| FINAL /*15L*/ expr
	| NEW /*15L*/ expr
	| expr actual_parameters %prec '(' /*17L*/
	| designator
	| '(' /*17L*/ expr ')'
	//| '(' /*17L*/ error bracket_stop
	| '[' /*17L*/ /*set_flag*/ elist_parts_list_empty ']'
	//| '[' /*17L*/ error sqbracket_stop
	| TAB /*16N*/ '[' /*17L*/ /*clear_flag*/ elist_parts_list_empty ']'
	//| TAB /*16N*/ '[' /*17L*/ error stmt_stop
	| TYPE /*16N*/ '(' /*17L*/ expr ')'
	| CHAR /*16N*/ '(' /*17L*/ expr ')'
	| INT /*16N*/ '(' /*17L*/ expr ')'
	| LONG /*16N*/ '(' /*17L*/ expr ')'
	| FLOAT /*16N*/ '(' /*17L*/ expr ')'
	| VEC /*16N*/ '(' /*17L*/ expr ')'
	| VEC /*16N*/ '(' /*17L*/ expr ',' expr ')'
	| TAB /*16N*/ '(' /*17L*/ expr ')'
	| THIS
	| TRY '(' /*17L*/ /*set_flag2*/ executive_stmt
	| TRY '(' /*17L*/ /*set_flag2*/ executive_stmt except_class_list ')'
	//| TRY '(' /*17L*/ error bracket_stop
	| WILDCARD
	| DOTS
	;

type :
	CHAR /*16N*/
	| INT /*16N*/
	| LONG /*16N*/
	| FLOAT /*16N*/
	| HIDE
	| HIDEBLOCK
	| VEC /*16N*/
	| TAB /*16N*/
	| fun_fiber_class %prec ':' /*1N*/
	| OBJ
	| THREAD
	| TYPE /*16N*/
	;

//except_class_list_opt :
//	/*empty*/
//	| /*','*/ except_class_list
//	;

aheader :
	fun_fiber_class
	| fun_fiber_class '(' /*17L*/ formal_parameters ')'
	;

//eof_stop :
//	END_OF_FILE
//	| END_OF_INCLUDE_FILE
//	;

//bracket_stop :
//	eof_stop
//	| ')'
//	| '}'
//	| ';'
//	;

//sqbracket_stop :
//	eof_stop
//	| ']'
//	| '}'
//	| ';'
//	;

//stmt_stop :
//	eof_stop
//	| '}'
//	| ';'
//	;

pos :
	/*empty*/
	;

hint :
	/*empty*/
	| '!' /*15L*/ IDENT
	//| '!' /*15L*/ error
	;

designator :
	expr '[' /*17L*/ expr ']'
	| expr '[' /*17L*/ expr_empty ':' /*1N*/ expr_empty opt_step ']'
	//| expr '[' /*17L*/ error sqbracket_stop
	| expr '.' /*17L*/ IDENT
	| IDENT
	| aheader hint block
	;

elist_parts_list :
	elist_part
	| elist_parts_list ',' elist_part
	;

elist_part :
	pos expr
	| pos expr ':' /*1N*/ expr
	;

elist_parts_list_empty :
	/*empty*/
	| elist_parts_list
	;

actual_parameters :
	'(' /*17L*/ expr_list_empty ')'
	//| '(' /*17L*/ error bracket_stop
	;

expr_list_empty :
	/*empty*/
	| expr_list
	;

expr_list :
	pos expr
	| expr_list ',' expr
	;

access :
	/*empty*/
	| PRIV
	| PUB
	;

val_var_list :
	val_var
	| val_var_list ',' val_var
	//| error
	;

val_var :
	IDENT
	| pattern '=' expr
	;

stmt :
	executive_stmt
	| declaration
	//| error stmt_stop
	;

assign :
	'='
	| MULT_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| PLUS_ASSIGN
	| MINUS_ASSIGN
	| CONCAT_ASSIGN
	| LSHIFT_ASSIGN
	| RSHIFT_ASSIGN
	| ASHIFT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

incr_decr :
	INCR
	| DECR
	;

incr_decr_expr:
	designator incr_decr
	| incr_decr designator
    ;

executive_stmt :
	end_exec_stmt
	| expr end_exec_stmt
	| designator assign expr end_exec_stmt
	| incr_decr_expr end_exec_stmt
	| IF '(' /*17L*/ expr ')' stmt else_part
	//| IF '(' /*17L*/ error bracket_stop stmt else_part
	| FOR '(' /*17L*/ /*clear_flag*/ stmt for_guard_expr ';' /*set_flag*/ for_guard2_expr ')' stmt
	| FOR '(' /*17L*/ /*clear_flag*/ designator IN /*5L*/ expr ')' stmt
	//| FOR '(' /*17L*/ error bracket_stop stmt
	| match_head '(' /*17L*/ expr ')' '{' case_list '}'
	| BREAK end_exec_stmt
	| CONTINUE end_exec_stmt
	| RETURN expr_empty end_exec_stmt
	| THROW expr end_exec_stmt
	| WAIT '(' /*17L*/ expr ')' stmt
	//| WAIT '(' /*17L*/ error bracket_stop stmt
	| block_stmt
	| try_block_stmt
	| CODE
	;

match_head :
	PMATCH
	| RMATCH
	;

case_list :
	/*empty*/
	| case_list a_case
	//| error
	;

a_case :
	CASE regexp_pattern opt_cond ':' /*1N*/ stmt_list
	;

opt_cond :
	/*empty*/
	| IF expr
	;

pattern :
	expr
	;

regexp_pattern :
	expr
	;

for_guard_expr :
	/*empty*/
	| expr
	;

for_guard2_expr :
	for_guard_expr
	| incr_decr_expr
	;

block_stmt :
	block
	;

try_block_stmt :
	TRY block catch_list
	;

catch_list :
	/*empty*/
	| catch_list catch
	;

catch :
	CATCH '(' /*17L*/ except_class_list ')' block
	//| error
	;

except_class_list :
	expr
	| except_class_list ',' expr
	;

friend_list :
	IDENT
	| friend_list ',' IDENT
	//| error
	;

declaration :
	access VAL /*set_flag*/ val_var_list end_simple_stmt
	| access VAR /*clear_flag*/ val_var_list end_simple_stmt
	| FRIEND friend_list end_simple_stmt
	| access EXTERN extern_list end_simple_stmt
	| header hint block
	| fun_fiber_class_start IDENT end_simple_stmt
	| OBJ IDENT block
	| PRIV OBJ IDENT block
	| PUB OBJ IDENT block
	| INCLUDE STRING end_simple_stmt inclusion
	| INCLUDE '+' /*13L*/ STRING end_simple_stmt inclusion
	| expose_clause end_simple_stmt
	| USE qual_ident use_clause_list end_simple_stmt
	| REQUIRE NUMBER end_simple_stmt
	;

expose_clause :
	EXPOSE expose_qual_ident
	| expose_clause ',' expose_qual_ident
	;

all_fields :
	'.' /*17L*/ '*' /*14L*/
	| FOLD_MULT /*15L*/
	;

expose_qual_ident :
	qual_ident alias_opt
	| qual_ident all_fields
	;

qual_ident :
	IDENT
	| qual_ident '.' /*17L*/ IDENT
	;

use_clause_list :
	/*empty*/
	| use_clause_list use_item_list
	;

use_item_list :
	FORMER /*set_flag*/ use_item
	| LATER /*clear_flag*/ use_item
	| use_item_list ',' use_item
	;

use_item :
	IDENT alias_opt
	;

alias_opt :
	/*empty*/
	| '(' /*17L*/ IDENT ')'
	;

extern_list :
	extern_item
	| extern_list ',' extern_item
	;

extern_item :
	IDENT
	| IDENT '(' /*17L*/ ')'
	;

inclusion :
	/*empty*/
	| INCLUSION stmt_list END_OF_INCLUDE_FILE
	;

end_simple_stmt :
	';'
	| ')'
	;

end_exec_stmt :
	end_simple_stmt
	| ','
	;

header :
	fun_fiber_class_start IDENT
	| fun_fiber_class_start IDENT '(' /*17L*/ formal_parameters ')'
	;

fun_fiber_class_start :
	fun_fiber_class
	| PRIV fun_fiber_class
	| PUB fun_fiber_class
	| FINAL /*15L*/ fun_fiber_class
	| FINAL /*15L*/ PRIV fun_fiber_class
	| FINAL /*15L*/ PUB fun_fiber_class
	| PRIV FINAL /*15L*/ fun_fiber_class
	| PUB FINAL /*15L*/ fun_fiber_class
	;

fun_fiber_class :
	FUN
	| FIBER
	| CLASS
	;

else_part :
	/*empty*/
	| ELSE stmt
	;

expr_empty :
	/*empty*/
	| expr
	;

opt_step :
	/*empty*/
	| ':' /*1N*/ expr
	;

par_list :
	par
	| par_list ',' par
	//| error
	;

par_kind :
	/*empty*/
	| VAL
	| VAR
	;

par :
	access par_kind IDENT
	| access par_kind IDENT '=' expr
	;

par_list_empty :
	/*empty*/
	| par_list
	;

formal_parameters :
	par_list_empty
	| par_list ',' DOTS
	| DOTS
	;

block :
	'{' stmt_list '}'
	;

stmt_list :
	/*empty*/
	| stmt_list /*clear_flag*/ stmt
	//| stmt_list error
	;

program :
	stmt_list //END_OF_FILE
	;

%%

%%

[\n\r\t ]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

_         WILDCARD
break     BREAK
case      CASE
catch     CATCH
char      CHAR
class     CLASS
continue  CONTINUE
expose    EXPOSE
extern    EXTERN
else      ELSE
fiber     FIBER
final     FINAL
float     FLOAT
for       FOR
former    FORMER
friend    FRIEND
fun       FUN
hide      HIDE
hideblock HIDEBLOCK
if        IF
in        IN
include   INCLUDE
int       INT
later     LATER
long      LONG
new       NEW
nil       NIL
obj       OBJ
pmatch    PMATCH
priv      PRIV
pub       PUB
require   REQUIRE
return    RETURN
rmatch    RMATCH
tab       TAB
thread    THREAD
this      THIS
throw     THROW
try       TRY
type      TYPE
use       USE
val       VAL
var       VAR
vec       VEC
wait      WAIT

"||"	LOGICAL_OR
"&&"	LOGICAL_AND
"=="	EQ
"!="	NE
"==="	IDENTITY
"!=="	UNIDENTITY
"<="	LE
">="	GE
"<<"	LSHIFT
">>"	RSHIFT
">>>"	ASHIFT
"*="	MULT_ASSIGN
"/="	DIV_ASSIGN
"%="	MOD_ASSIGN
"+="	PLUS_ASSIGN
"-="	MINUS_ASSIGN
"@="	CONCAT_ASSIGN
"<<="	LSHIFT_ASSIGN
">>="	RSHIFT_ASSIGN
">>>="	ASHIFT_ASSIGN
"&="	AND_ASSIGN
"^="	XOR_ASSIGN
"|="	OR_ASSIGN
"++"	INCR
"--"	DECR
".."	DOTS
".+"	FOLD_PLUS
".*"	FOLD_MULT
".&"	FOLD_AND
".^"	FOLD_XOR
".|"	FOLD_OR
".@"	FOLD_CONCAT
INCLUSION	INCLUSION
//END_OF_FILE	END_OF_FILE
END_OF_INCLUDE_FILE	END_OF_INCLUDE_FILE

"?" 	'?'
":" 	':'
"|" 	'|'
"^" 	'^'
"&" 	'&'
"<" 	'<'
">" 	'>'
"@" 	'@'
"+" 	'+'
"-" 	'-'
"*" 	'*'
"/" 	'/'
"%" 	'%'
"!" 	'!'
"~" 	'~'
"#" 	'#'
"(" 	'('
")" 	')'
"[" 	'['
"]" 	']'
"{" 	'{'
"}" 	'}'
";" 	';'
"." 	'.'
"," 	','
"=" 	'='

[0-9]+("."[0-9]+)?	NUMBER
'(\\.|[^'\n\r\\])'	CHARACTER
\"(\\(.|\n)|[^"\\])*\"	STRING /* strings can be multiline */
\`(\\(.|\n)|[^`\\])*\`	STRING /* strings can be multiline */
[A-Za-z_][A-Za-z0-9_]*	IDENT
"%{"(?s:.)*?"}%"	CODE


%%
