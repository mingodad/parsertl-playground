//From: https://github.com/luapp-org/luapp/blob/master/src/compiler/src/lexer.l

%token ILLEGAL_CHARACTER

%x LCOMMENT
%x COMMENT
%x LSTRING

/*Tokens*/
%token IDENTIFIER_T
%token NUMBER_T
%token STRING_T
%token AND_T
%token BREAK_T
%token DO_T
%token ELSE_T
%token ELSEIF_T
%token END_T
%token FALSE_T
%token TRUE_T
%token FOR_T
%token FUNCTION_T
%token IF_T
%token IN_T
%token LOCAL_T
%token NIL_T
%token NOT_T
%token OR_T
%token REPEAT_T
%token RETURN_T
%token THEN_T
%token UNTIL_T
%token WHILE_T
%token CLASS_T
%token CONSTRUCTOR_T
%token TNUMBER_T
%token TSTRING_T
%token TBOOLEAN_T
%token TANY_T
%token TVOID_T
%token TARRAY_T
%token TTABLE_T
%token PLUS_T
%token MINUS_T
%token ASTERISK_T
%token SLASH_T
%token PERCENT_T
%token EQUAL_T
%token LEFT_PARAN_T
%token RIGHT_PARAN_T
%token RIGHT_SQUARE_T
%token LEFT_SQUARE_T
%token CARROT_T
%token GREATER_THAN_T
%token LESS_THAN_T
%token SQUIGGLE_T
%token COLON_T
%token POUND_T
%token DOT_T
%token COMMA_T
%token LEFT_BRACKET_T
%token RIGHT_BRACKET_T
%token DOUBLE_EQUAL_T
%token NOT_EQUAL_T
%token GREATER_EQUAL_T
%token LESS_EQUAL_T
%token CONCAT_T
%token VARARG_T
%token PLUS_EQUAL_T
%token MINUS_EQUAL_T
%token ASTERISK_EQUAL_T
%token SLASH_EQUAL_T
%token MOD_EQUAL_T
%token CARROT_EQUAL_T
%token CONCAT_EQUAL_T
%token DECREMENT_T
%token INCREMENT_T

%left /*1*/ AND_T OR_T GREATER_THAN_T LESS_THAN_T DOUBLE_EQUAL_T NOT_EQUAL_T GREATER_EQUAL_T LESS_EQUAL_T
%left /*2*/ PLUS_T MINUS_T
%left /*3*/ ASTERISK_T SLASH_T
%left /*4*/ PERCENT_T CARROT_T

%start program

%%

binary_operation :
	expression LESS_THAN_T /*1L*/ expression
	| expression GREATER_THAN_T /*1L*/ expression
	| expression GREATER_EQUAL_T /*1L*/ expression
	| expression LESS_EQUAL_T /*1L*/ expression
	| expression NOT_EQUAL_T /*1L*/ expression
	| expression DOUBLE_EQUAL_T /*1L*/ expression
	| expression AND_T /*1L*/ expression
	| expression OR_T /*1L*/ expression
	| expression PLUS_T /*2L*/ expression
	| expression MINUS_T /*2L*/ expression
	| expression ASTERISK_T /*3L*/ expression
	| expression SLASH_T /*3L*/ expression
	| expression CARROT_T /*4L*/ expression
	| expression PERCENT_T /*4L*/ expression
	| expression CONCAT_T expression
	;

variable_name_reference :
	variable
	;

unary_operation :
	MINUS_T /*2L*/ expression
	| NOT_T expression
	| POUND_T expression
	| INCREMENT_T variable_name_reference
	| DECREMENT_T variable_name_reference
	| variable_name_reference INCREMENT_T
	| variable_name_reference DECREMENT_T
	;

expression_list :
	expression
	| expression COMMA_T expression_list
	;

parameter_list :
	name_list
	| name_list COMMA_T VARARG_T
	| VARARG_T
	;

name_list :
	name_type
	| name_type COMMA_T name_list
	;

type_list :
	type
	| type COMMA_T type_list
	;

type :
	TNUMBER_T
	| TSTRING_T
	| TBOOLEAN_T
	| TANY_T
	| TVOID_T
	| VARARG_T
	| TARRAY_T LESS_THAN_T /*1L*/ type GREATER_THAN_T /*1L*/
	| TTABLE_T LESS_THAN_T /*1L*/ type COMMA_T type GREATER_THAN_T /*1L*/
	| LEFT_PARAN_T type_list RIGHT_PARAN_T COLON_T type_list
	;

name_type :
	IDENTIFIER_T COLON_T type
	| IDENTIFIER_T
	;

array_constructor :
	LEFT_BRACKET_T expression_list RIGHT_BRACKET_T
	| LEFT_BRACKET_T RIGHT_BRACKET_T
	;

pair :
	LEFT_SQUARE_T expression RIGHT_SQUARE_T EQUAL_T expression
	;

pair_list :
	/*empty*/
	| pair
	| pair COMMA_T pair_list
	;

table_constructor :
	LEFT_BRACKET_T pair_list RIGHT_BRACKET_T
	;

variable :
	IDENTIFIER_T
	| prefix_expression LEFT_SQUARE_T expression RIGHT_SQUARE_T
	| prefix_expression DOT_T IDENTIFIER_T
	;

expression_group :
	LEFT_PARAN_T expression RIGHT_PARAN_T
	;

prefix_expression :
	call
	| expression_group
	| variable_name_reference
	;

arguments :
	LEFT_PARAN_T RIGHT_PARAN_T
	| LEFT_PARAN_T expression_list RIGHT_PARAN_T
	| STRING_T
	;

call :
	prefix_expression arguments
	| prefix_expression COLON_T IDENTIFIER_T arguments
	;

expression :
	NIL_T
	| FALSE_T
	| TRUE_T
	| NUMBER_T
	| STRING_T
	| VARARG_T
	| binary_operation
	| prefix_expression
	| unary_operation
	| array_constructor
	| table_constructor
	| FUNCTION_T function_body
	;

program :
	block
	;

variable_list :
	variable
	| variable COMMA_T variable_list
	;

else_body :
	ELSEIF_T expression THEN_T block else_body
	| ELSEIF_T expression THEN_T block END_T
	| ELSE_T block END_T
	;

function_body :
	LEFT_PARAN_T parameter_list RIGHT_PARAN_T COLON_T type_list block END_T
	| LEFT_PARAN_T parameter_list RIGHT_PARAN_T block END_T
	| LEFT_PARAN_T RIGHT_PARAN_T COLON_T type_list block END_T
	| LEFT_PARAN_T RIGHT_PARAN_T block END_T
	;

function_definition :
	FUNCTION_T IDENTIFIER_T function_body
	;

single_assignment :
	variable EQUAL_T expression
	| name_type EQUAL_T expression
	;

assignment :
	variable_list EQUAL_T expression_list
	| variable_list PLUS_EQUAL_T expression_list
	| variable_list MINUS_EQUAL_T expression_list
	| variable_list ASTERISK_EQUAL_T expression_list
	| variable_list SLASH_EQUAL_T expression_list
	| variable_list MOD_EQUAL_T expression_list
	| variable_list CARROT_EQUAL_T expression_list
	| variable_list CONCAT_EQUAL_T expression_list
	;

class_constructor_body :
	LEFT_PARAN_T parameter_list RIGHT_PARAN_T block END_T
	| LEFT_PARAN_T RIGHT_PARAN_T block END_T
	;

class_constructor :
	CONSTRUCTOR_T class_constructor_body
	;

class_member :
	name_type
	| class_constructor
	| function_definition
	;

class_member_list :
	class_member
	| class_member COMMA_T class_member_list
	;

statement :
	assignment
	| call
	| DO_T block END_T
	| WHILE_T expression DO_T block END_T
	| REPEAT_T block UNTIL_T expression
	| IF_T expression THEN_T block END_T
	| IF_T expression THEN_T block else_body
	| FOR_T single_assignment COMMA_T expression DO_T block END_T
	| FOR_T single_assignment COMMA_T expression COMMA_T expression DO_T block END_T
	| FOR_T name_list IN_T expression_list DO_T block END_T
	| LOCAL_T name_list
	| LOCAL_T name_list EQUAL_T expression_list
	| LOCAL_T function_definition
	| CLASS_T IDENTIFIER_T LEFT_BRACKET_T class_member_list RIGHT_BRACKET_T
	| last_statement
	;

block :
	/*empty*/
	| statement
	| block statement
	;

last_statement :
	RETURN_T expression_list
	| RETURN_T
	| BREAK_T
	;

%%

newline         \n
ws              [ \t\v\f]

digit           [[:digit:]]
letter          [[:alpha:]]

identifier      {letter}({letter}|{digit})*
number          [+-]?([0-9]+\.?[0-9]*|\.[0-9]+)
string          \"([^"\\\n]|\\(.|\n))*\"|'([^"\\\n]|\\(.|\n))*'
lstring         \[\[(.*?|\n|\r)\]\]

%%


<INITIAL>"--[["<LCOMMENT>
<LCOMMENT>"]]--"<INITIAL> skip()
<LCOMMENT>\n<.>
<LCOMMENT>.<.>

<INITIAL>"[["<LSTRING>
<LSTRING>"]]"<INITIAL>       STRING_T
<LSTRING>.<.>
<LSTRING>\n<.>
/*<LSTRING><<EOF>>    { compiler_error(*yylloc_param, "unexpected EOF", yytext); yyterminate(); }*/

<INITIAL>"--"<COMMENT>
/*<INITIAL>"//"<COMMENT>*/
<COMMENT>\n<INITIAL>         skip()
<COMMENT>.<.>

"and"               AND_T
"break"             BREAK_T
"do"                DO_T
"else"              ELSE_T
"elseif"            ELSEIF_T
"end"               END_T
"false"             FALSE_T
"true"              TRUE_T
"for"               FOR_T
"function"          FUNCTION_T
"if"                IF_T
"in"                IN_T
"local"             LOCAL_T
"nil"               NIL_T
"not"               NOT_T
"or"                OR_T
"repeat"            REPEAT_T
"return"            RETURN_T
"then"              THEN_T
"until"             UNTIL_T
"while"             WHILE_T
"class"             CLASS_T
"constructor"       CONSTRUCTOR_T

"number"            TNUMBER_T
"string"            TSTRING_T
"boolean"           TBOOLEAN_T
"any"               TANY_T
"void"              TVOID_T
"Array"             TARRAY_T
"Table"             TTABLE_T

\[                  LEFT_SQUARE_T
\]                  RIGHT_SQUARE_T
\+                  PLUS_T
-                   MINUS_T
\*                  ASTERISK_T
\/                  SLASH_T
\=                  EQUAL_T
\)                  RIGHT_PARAN_T
\(                  LEFT_PARAN_T
\^                  CARROT_T
\>                  GREATER_THAN_T
\<                  LESS_THAN_T
\~                  SQUIGGLE_T
\:                  COLON_T
\#                  POUND_T
\%                  PERCENT_T
\,                  COMMA_T
"."                 DOT_T
\{                  LEFT_BRACKET_T
\}                  RIGHT_BRACKET_T
\;                  skip() /* do nothing */

"=="                DOUBLE_EQUAL_T
"~="                NOT_EQUAL_T
">="                GREATER_EQUAL_T
"<="                LESS_EQUAL_T
".."                CONCAT_T
"..."               VARARG_T
"+="                PLUS_EQUAL_T
"-="                MINUS_EQUAL_T
"*="                ASTERISK_EQUAL_T
"/="                SLASH_EQUAL_T
"%="                MOD_EQUAL_T
"^="                CARROT_EQUAL_T
"..="               CONCAT_EQUAL_T
"++"                INCREMENT_T

{identifier}        IDENTIFIER_T
{number}            NUMBER_T
{string}            STRING_T


{newline}           skip()
{ws}                skip()
.                   ILLEGAL_CHARACTER

%%
