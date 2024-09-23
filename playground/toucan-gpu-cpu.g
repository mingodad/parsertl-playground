//From: https://github.com/google/toucan/blob/b14991fb17adfa7b762aa261d19b5026c8c2a0d4/parser/parser.yy
// Copyright 2023 The Toucan Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/*Tokens*/
%token T_ADD_EQUALS
%token T_AUTO
%token T_BOOL
%token T_BYTE
%token T_BYTE_LITERAL
%token T_CLASS
%token T_COHERENT
%token T_COLONCOLON
%token T_COMPUTE
%token T_DEVICEONLY
%token T_DIV_EQUALS
%token T_DO
%token T_DOUBLE
%token T_DOUBLE_LITERAL
%token T_ELSE
%token T_ENUM
%token T_EQ
%token T_FALSE
%token T_FLOAT
%token T_FLOAT_LITERAL
%token T_FOR
%token T_FRAGMENT
%token T_GE
%token T_GT
//%token T_HALF
%token T_IDENTIFIER
%token T_IF
%token T_INDEX
%token T_INLINE
%token T_INT
%token T_INT_LITERAL
%token T_LE
%token T_LOGICAL_AND
%token T_LOGICAL_OR
%token T_LT
%token T_MINUSMINUS
%token T_MUL_EQUALS
%token T_NATIVE
%token T_NE
%token T_NEW
%token T_NULL
%token T_PLUSPLUS
%token T_READONLY
%token T_READWRITE
%token T_RENDERABLE
%token T_RETURN
%token T_SAMPLEABLE
%token T_SHORT
%token T_SHORT_LITERAL
%token T_STATIC
%token T_STORAGE
%token T_STRING_LITERAL
%token T_SUB_EQUALS
%token T_THIS
%token T_TRUE
%token T_TYPENAME
%token T_UBYTE
%token T_UBYTE_LITERAL
%token T_UINT
%token T_UINT_LITERAL
%token T_UNIFORM
%token T_USHORT
%token T_USHORT_LITERAL
%token T_USING
%token T_VERTEX
%token T_VIRTUAL
%token T_VOID
%token T_WHILE
%token T_WRITEONLY
%token T_INCLUDE

%right /*1*/ '=' T_ADD_EQUALS T_SUB_EQUALS T_MUL_EQUALS T_DIV_EQUALS
%left /*2*/ T_LOGICAL_OR
%left /*3*/ T_LOGICAL_AND
%left /*4*/ '|'
%left /*5*/ '^'
%left /*6*/ '&'
%left /*7*/ T_EQ T_NE
%left /*8*/ T_LT T_LE T_GE T_GT
%left /*9*/ '+' '-'
%left /*10*/ '*' '/' '%'
%right /*11*/ UNARYMINUS '!' T_PLUSPLUS T_MINUSMINUS
%left /*12*/ '.' '[' ']' '(' ')'
%left /*13*/ T_COLONCOLON

%start program

%%

program :
	statements
	;

statements :
	statements statement
	| /*empty*/
	;

statement :
	';'
	| expr_statement ';'
	| '{' statements '}'
	| if_statement
	| for_statement
	| while_statement
	| do_statement
	| T_RETURN expr ';'
	| T_RETURN ';'
	| var_decl_statement ';'
	| class_decl
	| class_forward_decl
	| enum_decl
	| using_decl
	| assignment ';'
	| T_INCLUDE
	;

expr_statement :
	expr
	;

assignment :
	assignable '=' /*1R*/ expr_or_list
	| assignable T_ADD_EQUALS /*1R*/ expr
	| assignable T_SUB_EQUALS /*1R*/ expr
	| assignable T_MUL_EQUALS /*1R*/ expr
	| assignable T_DIV_EQUALS /*1R*/ expr
	;

if_statement :
	T_IF '(' /*12L*/ expr ')' /*12L*/ statement opt_else
	;

opt_else :
	T_ELSE statement
	| /*empty*/
	;

for_statement :
	T_FOR '(' /*12L*/ for_loop_stmt ';' opt_expr ';' for_loop_stmt ')' /*12L*/ statement
	;

opt_expr :
	expr
	| /*empty*/
	;

for_loop_stmt :
	assignment
	| expr_statement
	| var_decl_statement
	| /*empty*/
	;

while_statement :
	T_WHILE '(' /*12L*/ expr ')' /*12L*/ statement
	;

do_statement :
	T_DO statement T_WHILE '(' /*12L*/ expr ')' /*12L*/ ';'
	;

var_decl_statement :
	type var_decl_list
	;

simple_type :
	T_TYPENAME
	| scalar_type
	| simple_type T_LT /*8L*/ types T_GT /*8L*/
	| T_VOID
	| simple_type T_LT /*8L*/ T_INT_LITERAL T_GT /*8L*/
	| simple_type T_LT /*8L*/ T_INT_LITERAL ',' T_INT_LITERAL T_GT /*8L*/
	| simple_type T_COLONCOLON /*13L*/ T_IDENTIFIER
	;

qualified_type :
	simple_type
	| type_qualifiers simple_type
	;

type :
	qualified_type
	| type '*' /*10L*/
	| type '^' /*5L*/
	| type '[' /*12L*/ arith_expr ']' /*12L*/
	| type '[' /*12L*/ ']' /*12L*/
	| T_AUTO
	;

var_decl_list :
	var_decl_list ',' var_decl
	| var_decl
	;

class_or_native_class :
	T_CLASS
	| T_NATIVE T_CLASS
	;

class_header :
	class_or_native_class T_IDENTIFIER
	| class_or_native_class T_TYPENAME
	;

template_class_header :
	class_or_native_class T_IDENTIFIER T_LT /*8L*/ template_formal_arguments T_GT /*8L*/
	;

class_forward_decl :
	class_header ';'
	;

class_decl :
	class_header opt_parent_class '{' class_body '}'
	| template_class_header opt_parent_class '{' class_body '}'
	;

opt_parent_class :
	':' simple_type
	| /*empty*/
	;

class_body :
	class_body class_body_decl
	| /*empty*/
	;

enum_decl :
	T_ENUM T_IDENTIFIER '{' enum_list '}'
	;

enum_list :
	enum_list ',' T_IDENTIFIER
	| enum_list ',' T_IDENTIFIER '=' /*1R*/ T_INT_LITERAL
	| T_IDENTIFIER
	| T_IDENTIFIER '=' /*1R*/ T_INT_LITERAL
	| /*empty*/
	;

using_decl :
	T_USING T_IDENTIFIER '=' /*1R*/ type ';'
	;

class_body_decl :
	method_modifiers type T_IDENTIFIER '(' /*12L*/ formal_arguments ')' /*12L*/ opt_shader_type opt_workgroup_size method_body
	| method_modifiers T_TYPENAME '(' /*12L*/ formal_arguments ')' /*12L*/ opt_initializer method_body
	| method_modifiers '~' T_TYPENAME '(' /*12L*/ ')' /*12L*/ method_body
	| method_modifiers type var_decl_list ';'
	| enum_decl ';'
	| using_decl
	;

method_body :
	'{' statements '}'
	| ';'
	;

template_formal_arguments :
	T_IDENTIFIER
	| template_formal_arguments ',' T_IDENTIFIER
	;

method_modifier :
	T_STATIC
	| T_VIRTUAL
	| T_DEVICEONLY
	;

opt_shader_type :
	T_VERTEX
	| T_FRAGMENT
	| T_COMPUTE
	| /*empty*/
	;

opt_workgroup_size :
	'(' /*12L*/ arguments ')' /*12L*/
	| /*empty*/
	;

type_qualifier :
	T_UNIFORM
	| T_STORAGE
	| T_VERTEX
	| T_INDEX
	| T_SAMPLEABLE
	| T_RENDERABLE
	| T_READONLY
	| T_WRITEONLY
	| T_READWRITE
	| T_COHERENT
	;

type_qualifiers :
	type_qualifier type_qualifiers
	| type_qualifier
	;

method_modifiers :
	method_modifier method_modifiers
	| /*empty*/
	;

formal_arguments :
	non_empty_formal_arguments
	| /*empty*/
	;

non_empty_formal_arguments :
	formal_arguments ',' formal_argument
	| formal_argument
	;

formal_argument :
	type T_IDENTIFIER
	| type T_IDENTIFIER '=' /*1R*/ expr_or_list
	;

var_decl :
	T_IDENTIFIER
	| T_IDENTIFIER '=' /*1R*/ expr_or_list
	;

scalar_type :
	T_INT
	| T_UINT
	| T_SHORT
	| T_USHORT
	| T_BYTE
	| T_UBYTE
	| T_FLOAT
	| T_DOUBLE
	| T_BOOL
	;

arguments :
	non_empty_arguments
	| /*empty*/
	;

non_empty_arguments :
	non_empty_arguments ',' argument
	| argument
	;

argument :
	T_IDENTIFIER '=' /*1R*/ expr_or_list
	| expr_or_list
	;

arith_expr :
	arith_expr '+' /*9L*/ arith_expr
	| arith_expr '-' /*9L*/ arith_expr
	| arith_expr '*' /*10L*/ arith_expr
	| arith_expr '/' /*10L*/ arith_expr
	| arith_expr '%' /*10L*/ arith_expr
	| '-' /*9L*/ arith_expr %prec UNARYMINUS /*11R*/
	| arith_expr T_LT /*8L*/ arith_expr
	| arith_expr T_LE /*8L*/ arith_expr
	| arith_expr T_EQ /*7L*/ arith_expr
	| arith_expr T_GT /*8L*/ arith_expr
	| arith_expr T_GE /*8L*/ arith_expr
	| arith_expr T_NE /*7L*/ arith_expr
	| arith_expr T_LOGICAL_AND /*3L*/ arith_expr
	| arith_expr T_LOGICAL_OR /*2L*/ arith_expr
	| arith_expr '&' /*6L*/ arith_expr
	| arith_expr '^' /*5L*/ arith_expr
	| arith_expr '|' /*4L*/ arith_expr
	| '!' /*11R*/ arith_expr
	| T_PLUSPLUS /*11R*/ assignable
	| T_MINUSMINUS /*11R*/ assignable
	| assignable T_PLUSPLUS /*11R*/
	| assignable T_MINUSMINUS /*11R*/
	| '(' /*12L*/ arith_expr ')' /*12L*/
	| '(' /*12L*/ type ')' /*12L*/ arith_expr %prec UNARYMINUS /*11R*/
	| simple_type '(' /*12L*/ arguments ')' /*12L*/
	| simple_type '{' arguments '}'
	| type '[' /*12L*/ arith_expr ']' /*12L*/ '(' /*12L*/ arguments ')' /*12L*/
	| T_INT_LITERAL
	| T_UINT_LITERAL
	| T_BYTE_LITERAL
	| T_UBYTE_LITERAL
	| T_SHORT_LITERAL
	| T_USHORT_LITERAL
	| T_FLOAT_LITERAL
	| T_DOUBLE_LITERAL
	| T_TRUE
	| T_FALSE
	| T_NULL
	| assignable
	;

expr :
	arith_expr
	| T_NEW type '(' /*12L*/ arguments ')' /*12L*/
	| T_NEW type '[' /*12L*/ arith_expr ']' /*12L*/
	| T_NEW '[' /*12L*/ arith_expr ']' /*12L*/ type '(' /*12L*/ arguments ')' /*12L*/
	| T_INLINE '(' /*12L*/ T_STRING_LITERAL ')' /*12L*/
	| T_STRING_LITERAL
	;

expr_or_list :
	expr
	| '{' arguments '}'
	;

opt_initializer :
	':' expr_or_list
	| /*empty*/
	;

types :
	type
	| types ',' type
	;

assignable :
	T_IDENTIFIER
	| T_THIS
	| assignable '[' /*12L*/ expr ']' /*12L*/
	| assignable '.' /*12L*/ T_IDENTIFIER
	| assignable '.' /*12L*/ T_IDENTIFIER '(' /*12L*/ arguments ')' /*12L*/
	| simple_type '.' /*12L*/ T_IDENTIFIER '(' /*12L*/ arguments ')' /*12L*/
	| '*' /*10L*/ assignable %prec UNARYMINUS /*11R*/
	| '&' /*6L*/ assignable %prec UNARYMINUS /*11R*/
	;

%%

ALPHA           [a-zA-Z_]
ALPHANUM        [a-zA-Z0-9_]
EXPONENT        ([Ee]("-"|"+")?[0-9]+)
FLOAT	([0-9]+"."[0-9]*|[0-9]*"."[0-9]+){EXPONENT}?

%%

{FLOAT}  T_FLOAT_LITERAL

{FLOAT}d  T_DOUBLE_LITERAL

[0-9]+{EXPONENT}       T_FLOAT_LITERAL

[0-9]+{EXPONENT}d      T_DOUBLE_LITERAL

0x[0-9a-fA-F]+         T_INT_LITERAL

[0-9]+b                T_BYTE_LITERAL

[0-9]+ub               T_UBYTE_LITERAL

[0-9]+s                T_SHORT_LITERAL

[0-9]+us               T_USHORT_LITERAL

[0-9]+                 T_INT_LITERAL

[0-9]+u                T_UINT_LITERAL

auto    T_AUTO
false   T_FALSE
null    T_NULL
true    T_TRUE
if      T_IF
else    T_ELSE
for     T_FOR
while   T_WHILE
do      T_DO
return  T_RETURN
new     T_NEW
class   T_CLASS
enum    T_ENUM
void    T_VOID
static  T_STATIC
virtual T_VIRTUAL
vertex  T_VERTEX
index   T_INDEX
fragment T_FRAGMENT
compute T_COMPUTE
uniform T_UNIFORM
storage T_STORAGE
sampleable T_SAMPLEABLE
renderable T_RENDERABLE
native  T_NATIVE
this    T_THIS
readonly T_READONLY
writeonly T_WRITEONLY
readwrite T_READWRITE
deviceonly T_DEVICEONLY
coherent T_COHERENT
using   T_USING
inline  T_INLINE
include[ \t\n]+[^ \t\n]+ T_INCLUDE

int     T_INT
uint    T_UINT
float   T_FLOAT
double  T_DOUBLE
bool    T_BOOL
byte    T_BYTE
ubyte   T_UBYTE
short   T_SHORT
ushort  T_USHORT
//half    T_HALF

\${ALPHA}{ALPHANUM}*	T_TYPENAME //Cheating because missing symbol table
{ALPHA}{ALPHANUM}*	T_IDENTIFIER

\"([^\"]|\\\"|\\\\)*\" T_STRING_LITERAL

[ \t\r]+       skip()  /* eat up whitespace */
\/\/.*        skip()

\n+              skip()

\<              T_LT
\<=             T_LE
==              T_EQ
\>=             T_GE
\>              T_GT
!=              T_NE

\+=             T_ADD_EQUALS
-=              T_SUB_EQUALS
\*=             T_MUL_EQUALS
\/=             T_DIV_EQUALS

&&              T_LOGICAL_AND
\|\|            T_LOGICAL_OR

\+\+            T_PLUSPLUS
--              T_MINUSMINUS

::              T_COLONCOLON

"!"	'!'
"%"	'%'
"&"	'&'
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
"["	'['
"]"	']'
"^"	'^'
"{"	'{'
"|"	'|'
"}"	'}'
"~"	'~'

%%
