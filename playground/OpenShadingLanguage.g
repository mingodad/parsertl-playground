//From: https://github.com/AcademySoftwareFoundation/OpenShadingLanguage/blob/fefeb5a099c0fe4948f956007cc56a662f76acc9/src/liboslcomp/oslgram.y
/* Copyright Contributors to the Open Shading Language project.
 * SPDX-License-Identifier: BSD-3-Clause
 * https://github.com/AcademySoftwareFoundation/OpenShadingLanguage
 */

/** Parser for Open Shading Language
 **/

/*Tokens*/
%token IDENTIFIER
%token STRING_LITERAL
%token INT_LITERAL
%token FLOAT_LITERAL
%token COLORTYPE
%token FLOATTYPE
%token INTTYPE
%token MATRIXTYPE
%token NORMALTYPE
%token POINTTYPE
%token STRINGTYPE
%token VECTORTYPE
%token VOIDTYPE
%token CLOSURE
%token OUTPUT
//%token PUBLIC
%token STRUCT
%token BREAK
%token CONTINUE
%token DO
%token ELSE
%token FOR
%token IF_TOKEN
//%token ILLUMINATE
//%token ILLUMINANCE
%token RETURN
%token WHILE
//%token RESERVED
%token ','
%token '='
%token ADD_ASSIGN
%token SUB_ASSIGN
%token MUL_ASSIGN
%token DIV_ASSIGN
%token BIT_AND_ASSIGN
%token BIT_OR_ASSIGN
%token XOR_ASSIGN
%token SHL_ASSIGN
%token SHR_ASSIGN
%token '?'
%token ':'
%token OR_OP
%token AND_OP
%token '|'
%token '^'
%token '&'
%token EQ_OP
%token NE_OP
%token '>'
%token GE_OP
%token '<'
%token LE_OP
%token SHL_OP
%token SHR_OP
%token '+'
%token '-'
%token '*'
%token '/'
%token '%'
%token UMINUS_PREC
%token NOT_OP
%token '~'
%token INCREMENT
%token DECREMENT
%token '('
%token ')'
%token '['
%token ']'
%token METADATA_BEGIN
%token '{'
%token '}'
%token ';'
%token '.'
%token '!'
%token PP_DECL

%precedence /*1*/ IF_WITHOUT_ELSE
%precedence /*2*/ ELSE
%left /*3*/ ','
%right /*4*/ '=' ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN BIT_AND_ASSIGN BIT_OR_ASSIGN XOR_ASSIGN SHL_ASSIGN SHR_ASSIGN
%right /*5*/ '?' ':'
%left /*6*/ OR_OP
%left /*7*/ AND_OP
%left /*8*/ '|'
%left /*9*/ '^'
%left /*10*/ '&'
%left /*11*/ EQ_OP NE_OP
%left /*12*/ '>' GE_OP '<' LE_OP
%left /*13*/ SHL_OP SHR_OP
%left /*14*/ '+' '-'
%left /*15*/ '*' '/' '%'
%right /*16*/ UMINUS_PREC NOT_OP '~'
%right /*17*/ INCREMENT DECREMENT
%left /*18*/ '(' ')'
%left /*19*/ '[' ']'
%left /*20*/ METADATA_BEGIN

%start shader_file

%%

shader_file :
	global_declarations_opt
	;

global_declarations_opt :
	global_declarations
	| /*empty*/
	;

global_declarations :
	global_declaration
	| global_declarations global_declaration
	;

global_declaration :
	shader_or_function_declaration
	| struct_declaration
	| PP_DECL
	;

shader_or_function_declaration :
	typespec_or_shadertype IDENTIFIER metadata_block_opt '(' /*18L*/ formal_params_opt ')' /*18L*/ metadata_block_opt function_body_or_just_decl
	;

formal_params_opt :
	formal_params
	| /*empty*/
	;

formal_params :
	formal_param metadata_block_opt
	| formal_params ',' /*3L*/ formal_param metadata_block_opt
	| formal_params ',' /*3L*/
	;

formal_param :
	outputspec typespec ident_init_opt
	| outputspec typespec IDENTIFIER arrayspec initializer_list_opt
	;

metadata_block_opt :
	METADATA_BEGIN /*20L*/ metadata ']' /*19L*/ ']' /*19L*/
	| /*empty*/
	;

metadata :
	metadatum
	| metadata ',' /*3L*/ metadatum
	| metadata ',' /*3L*/
	;

metadatum :
	simple_typename ident_initializer
	| simple_typename IDENTIFIER arrayspec initializer_list
	;

function_body_or_just_decl :
	'{' statement_list '}'
	| ';'
	;

function_declaration :
	typespec IDENTIFIER '(' /*18L*/ formal_params_opt ')' /*18L*/ metadata_block_opt function_body_or_just_decl
	;

struct_declaration :
	STRUCT IDENTIFIER '{' field_declarations '}' ';'
	;

field_declarations :
	field_declaration
	| field_declarations field_declaration
	;

field_declaration :
	typespec typed_field_list ';'
	;

typed_field_list :
	typed_field
	| typed_field_list ',' /*3L*/ typed_field
	;

typed_field :
	IDENTIFIER
	| IDENTIFIER arrayspec
	;

local_declaration :
	function_declaration
	| variable_declaration
	;

variable_declaration :
	typespec def_expressions ';'
	;

def_expressions :
	def_expression
	| def_expressions ',' /*3L*/ def_expression
	;

def_expression :
	ident_init_opt
	| IDENTIFIER arrayspec initializer_list_opt
	;

ident_initializer :
	IDENTIFIER '=' /*4R*/ expression
	;

ident_init_opt :
	IDENTIFIER
	| ident_initializer
	| IDENTIFIER '=' /*4R*/ compound_initializer
	;

initializer_list_opt :
	initializer_list
	| /*empty*/
	;

initializer_list :
	'=' /*4R*/ compound_initializer
	;

compound_initializer :
	'{' init_expression_list '}'
	| '{' '}'
	;

init_expression_list :
	init_expression
	| init_expression_list_rev ',' /*3L*/ init_expression
	;

init_expression_list_rev :
	init_expression
	| init_expression_list_rev ',' /*3L*/ init_expression
	;

init_expression :
	expression
	| compound_initializer
	;

outputspec :
	OUTPUT
	| /*empty*/
	;

simple_typename :
	COLORTYPE
	| FLOATTYPE
	| INTTYPE
	| MATRIXTYPE
	| NORMALTYPE
	| POINTTYPE
	| STRINGTYPE
	| VECTORTYPE
	| VOIDTYPE
	;

arrayspec :
	'[' /*19L*/ INT_LITERAL ']' /*19L*/
	| '[' /*19L*/ ']' /*19L*/
	;

typespec :
	simple_typename
	| CLOSURE simple_typename
	| IDENTIFIER
	;

typespec_or_shadertype :
	simple_typename
	| CLOSURE simple_typename
	| IDENTIFIER
	;

statement_list :
	statement_list statement
	| /*empty*/
	;

statement :
	scoped_statements
	| conditional_statement
	| loop_statement
	| loopmod_statement
	| return_statement
	| local_declaration
	| compound_expression ';'
	| ';'
	| PP_DECL
	;

scoped_statements :
	'{' statement_list '}'
	;

conditional_statement :
	IF_TOKEN '(' /*18L*/ compound_expression ')' /*18L*/ statement %prec IF_WITHOUT_ELSE
	| IF_TOKEN '(' /*18L*/ compound_expression ')' /*18L*/ statement ELSE /*2P*/ statement
	;

loop_statement :
	WHILE '(' /*18L*/ compound_expression ')' /*18L*/ statement
	| DO statement WHILE '(' /*18L*/ compound_expression ')' /*18L*/ ';'
	| FOR '(' /*18L*/ for_init_statement compound_expression_opt ';' compound_expression_opt ')' /*18L*/ statement
	;

loopmod_statement :
	BREAK ';'
	| CONTINUE ';'
	;

return_statement :
	RETURN expression_opt ';'
	| RETURN compound_initializer ';'
	;

for_init_statement :
	expression_opt ';'
	| variable_declaration
	;

expression_list :
	expression
	| expression_list ',' /*3L*/ expression
	;

expression_opt :
	expression
	| /*empty*/
	;

compound_expression_opt :
	compound_expression
	| /*empty*/
	;

compound_expression :
	expression
	| expression ',' /*3L*/ compound_expression
	;

expression :
	INT_LITERAL
	| FLOAT_LITERAL
	| string_literal_group
	| variable_ref
	| incdec_op variable_lvalue
	| binary_expression
	| unary_op expression %prec UMINUS_PREC /*16R*/
	| '(' /*18L*/ compound_expression ')' /*18L*/
	| function_call
	| assign_expression
	| ternary_expression
	| typecast_expression
	| type_constructor
	;

variable_lvalue :
	id_or_field
	| id_or_field '[' /*19L*/ expression ']' /*19L*/
	| id_or_field '[' /*19L*/ expression ']' /*19L*/ '[' /*19L*/ expression ']' /*19L*/
	| id_or_field '[' /*19L*/ expression ']' /*19L*/ '[' /*19L*/ expression ']' /*19L*/ '[' /*19L*/ expression ']' /*19L*/
	;

id_or_field :
	IDENTIFIER
	| variable_lvalue '.' IDENTIFIER
	;

variable_ref :
	variable_lvalue incdec_op_opt
	;

binary_expression :
	expression OR_OP /*6L*/ expression
	| expression AND_OP /*7L*/ expression
	| expression '|' /*8L*/ expression
	| expression '^' /*9L*/ expression
	| expression '&' /*10L*/ expression
	| expression EQ_OP /*11L*/ expression
	| expression NE_OP /*11L*/ expression
	| expression '>' /*12L*/ expression
	| expression GE_OP /*12L*/ expression
	| expression '<' /*12L*/ expression
	| expression LE_OP /*12L*/ expression
	| expression SHL_OP /*13L*/ expression
	| expression SHR_OP /*13L*/ expression
	| expression '+' /*14L*/ expression
	| expression '-' /*14L*/ expression
	| expression '*' /*15L*/ expression
	| expression '/' /*15L*/ expression
	| expression '%' /*15L*/ expression
	;

unary_op :
	'-' /*14L*/
	| '+' /*14L*/
	| '!'
	| NOT_OP /*16R*/
	| '~' /*16R*/
	;

incdec_op_opt :
	incdec_op
	| /*empty*/
	;

incdec_op :
	INCREMENT /*17R*/
	| DECREMENT /*17R*/
	;

type_constructor :
	simple_typename '(' /*18L*/ expression_list ')' /*18L*/
	;

function_call :
	IDENTIFIER '(' /*18L*/ function_args_opt ')' /*18L*/
	;

function_args_opt :
	function_args
	| /*empty*/
	;

function_args :
	expression
	| compound_initializer
	| function_args ',' /*3L*/ expression
	| function_args ',' /*3L*/ compound_initializer
	;

assign_expression :
	variable_lvalue '=' /*4R*/ expression
	| variable_lvalue MUL_ASSIGN /*4R*/ expression
	| variable_lvalue DIV_ASSIGN /*4R*/ expression
	| variable_lvalue ADD_ASSIGN /*4R*/ expression
	| variable_lvalue SUB_ASSIGN /*4R*/ expression
	| variable_lvalue BIT_AND_ASSIGN /*4R*/ expression
	| variable_lvalue BIT_OR_ASSIGN /*4R*/ expression
	| variable_lvalue XOR_ASSIGN /*4R*/ expression
	| variable_lvalue SHL_ASSIGN /*4R*/ expression
	| variable_lvalue SHR_ASSIGN /*4R*/ expression
	;

ternary_expression :
	expression '?' /*5R*/ expression ':' /*5R*/ expression
	;

typecast_expression :
	'(' /*18L*/ simple_typename ')' /*18L*/ expression
	;

string_literal_group :
	STRING_LITERAL
	| string_literal_group STRING_LITERAL
	;

%%

/* Define regular expression macros
  ************************************************/

/* white space, not counting newline */
WHITE           [ \t\v\f\r]+
/* alpha character */
ALPHA           [A-Za-z]
/* numerals */
DIGIT           [0-9]
/* Integer literal */
INTEGER         {DIGIT}+
HEXINTEGER      0[xX][0-9a-fA-F]+
/* floating point literal (E, FLT1, FLT2, FLT3 are just helpers)
  * NB: we don't allow leading +/- due to ambiguity between
  * whether "a-0.5" is really "a -0.5" or "a - 0.5".  Resolve this
  * in the grammar.
  */
E               [eE][-+]?{DIGIT}+
FLT1            {DIGIT}+\.{DIGIT}*{E}?
FLT2            {DIGIT}*\.{DIGIT}+{E}?
FLT3            {DIGIT}+{E}
FLT             {FLT1}|{FLT2}|{FLT3}
/* string literal */
STR     \"(\\.|[^\\"\n])*\"	/* " This extra quote fixes emacs syntax highlighting on this file */
/* Identifier: alphanumeric, may contain digits after the first character */
IDENT           ({ALPHA}|[_])({ALPHA}|{DIGIT}|[_])*
/* C preprocessor (cpp) directives */
CPP             [ \t]*"#"(.|"\\\n")*\n
CPLUSCOMMENT    \/\/.*|"/*"(?s:.)*?"*/"



/* Note for lex newbies: the following '%{ .. %}' section contains literal
  * C code that will be inserted at the top of code that flex generates.
  */

%%

 /************************************************
  * Lexical matching rules
  ************************************************/

 /* preprocessor symbols */
^{CPP}                   PP_DECL

 /* Comments */
{CPLUSCOMMENT}          skip()

 /* keywords */
"break"                 BREAK
"closure"               CLOSURE
"color"                 COLORTYPE
"continue"              CONTINUE
"do"                    DO
"else"                  ELSE
"float"                 FLOATTYPE
"for"                   FOR
"if"                    IF_TOKEN
//"illuminance"           ILLUMINANCE
//"illuminate"            ILLUMINATE
"int"                   INTTYPE
"matrix"                MATRIXTYPE
"normal"                NORMALTYPE
"output"                OUTPUT
"point"                 POINTTYPE
//"public"                PUBLIC
"return"                RETURN
"string"                STRINGTYPE
"struct"                STRUCT
"vector"                VECTORTYPE
"void"                  VOIDTYPE
"while"                 WHILE
"or"                    OR_OP
"and"                   AND_OP
"not"                   NOT_OP

 /* reserved words */
/*
"bool"|"case"|"char"|"class"|"const"|"default"|"double" |    \
"enum"|"extern"|"false"|"friend"|"inline"|"long"|"private" | \
"protected"|"short"|"signed"|"sizeof"|"static"|"struct" |    \
"switch"|"template"|"this"|"true"|"typedef"|"uniform" |      \
"union"|"unsigned"|"varying"|"virtual" RESERVED
*/


 /* Identifiers */
{IDENT}                 IDENTIFIER

 /* Literal values */
{INTEGER}               INT_LITERAL
{HEXINTEGER}            INT_LITERAL

{FLT}                   FLOAT_LITERAL

{STR}                   STRING_LITERAL

 /* The one-char operators (like "+") will return correctly with the
  * catch-all rule, but we need to define the two-character operators
  * so they are not lexed as '+' and '=' separately, for example.
  */
"+="                    ADD_ASSIGN
"-="                    SUB_ASSIGN
"*="                    MUL_ASSIGN
"/="                    DIV_ASSIGN
"&="                    BIT_AND_ASSIGN
"|="                    BIT_OR_ASSIGN
"^="                    XOR_ASSIGN
"<<="                   SHL_ASSIGN
">>="                   SHR_ASSIGN
"<<"                    SHL_OP
">>"                    SHR_OP
"&&"                    AND_OP
"||"                    OR_OP
"<="                    LE_OP
">="                    GE_OP
"=="                    EQ_OP
"!="                    NE_OP
"++"                    INCREMENT
"--"                    DECREMENT

 /* Beginning of metadata */
"[["                    METADATA_BEGIN

 /* End of line */
"\\\n"|[\n]                    skip()

 /* Ignore whitespace */
{WHITE}                 skip()

 /* catch-all rule for any other single characters */
//!                       {  SETLINE;  return (yylval->i = NOT_OP); }
//.                       {  SETLINE;  return (yylval->i = *yytext); }


"^"	'^'
"~"	'~'
"<"	'<'
"="	'='
">"	'>'
"|"	'|'
"-"	'-'
","	','
";"	';'
":"	':'
"!"	'!'
"?"	'?'
"/"	'/'
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"*"	'*'
"&"	'&'
"%"	'%'
"+"	'+'

%%
