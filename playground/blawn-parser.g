//From: https://github.com/Naotonosato/Blawn/blob/master/src/compiler/parser/parser.yy

/*Tokens*/
%token END
%token FUNCTION_DEFINITION
%token METHOD_DEFINITION
%token CLASS_DEFINITION
%token C_TYPE_DEFINITION
%token C_FUNCTION_DECLARATION
%token RETURN
%token C_FUNCTION
%token MEMBER_IDENTIFIER
%token IDENTIFIER
%token EQUAL
%token ARROW
%token OP_AND
%token OP_OR
%token OP_EQUAL
%token OP_NOT_EQUAL
%token OP_MORE_EQUAL
%token OP_LESS_EQUAL
%token OP_MORE
%token OP_LESS
%token PLUS
%token MINUS
%token ASTERISK
%token SLASH
%token UMINUS
%token DOT_IDENTIFIER
%token USE
%token COLON
%token SEMICOLON
%token COMMA
%token LEFT_PARENTHESIS
%token RIGHT_PARENTHESIS
%token LEFT_CURLY_BRACE
%token RIGHT_CURLY_BRACE
%token LEFT_BRACKET
%token RIGHT_BRACKET
%token IF
%token ELSE
%token FOR
%token IN
%token WHILE
%token GLOBAL
%token IMPORT
%token C_FUNCTION_ARGUMENT
%token C_FUNCTION_RETURN
%token EOL
%token STRING_LITERAL
%token INT_LITERAL
%token FLOAT_LITERAL

%right /*1*/ EQUAL ARROW
%left /*2*/ OP_AND OP_OR
%left /*3*/ OP_EQUAL OP_NOT_EQUAL OP_MORE_EQUAL OP_LESS_EQUAL OP_MORE OP_LESS
%left /*4*/ PLUS MINUS
%left /*5*/ ASTERISK SLASH
%left /*6*/ UMINUS
%left /*7*/ DOT_IDENTIFIER

%start program

%%

program :
	/*END
	|*/ block
	;

block :
	lines
	;

lines :
	line
	| lines line
	;

line :
	line_content EOL
	| line_content END
	| definition
	| import
	;

import :
	IMPORT STRING_LITERAL EOL
	;

line_content :
	expression
	;

definition :
	function_definition
	| class_definition
	| c_type_definition
	| globals_definition
	| c_function_declaration
	;

function_definition :
	function_start arguments EOL block return_value EOL
	| function_start arguments EOL return_value EOL
	;

function_start :
	FUNCTION_DEFINITION
	;

class_definition :
	class_start arguments EOL members_definition methods
	| class_start arguments EOL members_definition
	| class_start arguments EOL methods
	;

class_start :
	CLASS_DEFINITION
	;

c_type_definition :
	c_type_start EOL C_members_definition
	;

c_type_start :
	C_TYPE_DEFINITION
	;

methods :
	method_definition EOL
	| methods method_definition EOL
	;

method_start :
	METHOD_DEFINITION
	;

method_definition :
	method_start arguments EOL block return_value
	| method_start arguments EOL return_value
	;

members_definition :
	MEMBER_IDENTIFIER EQUAL /*1R*/ expression EOL
	| members_definition MEMBER_IDENTIFIER EQUAL /*1R*/ expression EOL
	;

C_members_definition :
	MEMBER_IDENTIFIER EQUAL /*1R*/ C_type_identifier EOL
	| C_members_definition MEMBER_IDENTIFIER EQUAL /*1R*/ C_type_identifier EOL
	;

C_type_identifier :
	IDENTIFIER
	| C_type_identifier IDENTIFIER
	;

C_arguments :
	C_type_identifier
	| C_arguments COMMA C_type_identifier
	;

C_returns :
	C_type_identifier
	;

return_value :
	RETURN expression
	| RETURN
	;

arguments :
	LEFT_PARENTHESIS definition_arguments RIGHT_PARENTHESIS
	| LEFT_PARENTHESIS RIGHT_PARENTHESIS
	;

definition_arguments :
	IDENTIFIER
	| definition_arguments COMMA IDENTIFIER
	;

globals_definition :
	global_start EOL LEFT_PARENTHESIS EOL globals_variables EOL RIGHT_PARENTHESIS EOL
	;

global_start :
	GLOBAL
	;

globals_variables :
	assign_variable
	| globals_variables EOL assign_variable
	;

c_function_declaration :
	C_FUNCTION_DECLARATION EOL C_FUNCTION_ARGUMENT C_arguments EOL C_FUNCTION_RETURN C_returns EOL
	| C_FUNCTION_DECLARATION EOL C_FUNCTION_ARGUMENT EOL C_FUNCTION_RETURN C_returns EOL
	;

expressions :
	expression
	| expressions COMMA expression
	;

if_start :
	IF
	;

else_start :
	ELSE
	;

for_start :
	FOR expression COMMA expression COMMA expression
	;

else_body :
	else_start EOL LEFT_PARENTHESIS EOL block RIGHT_PARENTHESIS
	;

expression :
	if_start expression EOL LEFT_PARENTHESIS EOL block RIGHT_PARENTHESIS
	| if_start expression EOL LEFT_PARENTHESIS EOL block RIGHT_PARENTHESIS else_body
	| for_start EOL LEFT_PARENTHESIS EOL block RIGHT_PARENTHESIS
	| assign_variable
	| expression ARROW /*1R*/ expression
	| expression PLUS /*4L*/ expression
	| expression MINUS /*4L*/ expression
	| expression ASTERISK /*5L*/ expression
	| expression SLASH /*5L*/ expression
	| expression OP_AND /*2L*/ expression
	| expression OP_OR /*2L*/ expression
	| expression OP_MORE_EQUAL /*3L*/ expression
	| expression OP_LESS_EQUAL /*3L*/ expression
	| expression OP_MORE /*3L*/ expression
	| expression OP_LESS /*3L*/ expression
	| expression OP_NOT_EQUAL /*3L*/ expression
	| expression OP_EQUAL /*3L*/ expression
	| monomial
	| list
	| access
	| MINUS /*4L*/ expression %prec UMINUS /*6L*/
	| LEFT_PARENTHESIS expression RIGHT_PARENTHESIS
	;

list :
	LEFT_CURLY_BRACE expressions RIGHT_CURLY_BRACE
	| LEFT_CURLY_BRACE RIGHT_CURLY_BRACE
	;

access :
	expression DOT_IDENTIFIER /*7L*/
	;

assign_variable :
	IDENTIFIER EQUAL /*1R*/ expression
	| access EQUAL /*1R*/ expression
	;

monomial :
	call
	| STRING_LITERAL
	| FLOAT_LITERAL
	| INT_LITERAL
	| variable
	;

call :
	IDENTIFIER LEFT_PARENTHESIS expressions RIGHT_PARENTHESIS
	| IDENTIFIER LEFT_PARENTHESIS RIGHT_PARENTHESIS
	| access LEFT_PARENTHESIS expressions RIGHT_PARENTHESIS
	| access LEFT_PARENTHESIS RIGHT_PARENTHESIS
	;

variable :
	IDENTIFIER
	;

%%

COMMENT             \/\/.*\n
STRING_LITERAL      \"[^\"]*\"
INT_LITERAL         [0-9]+
FLOAT_LITERAL       [0-9]+\.[0-9]*
USE                 use

OP_EQUAL    ==
OP_NOT_EQUAL \!=
OP_MORE_EQUAL >=
OP_LESS_EQUAL <=
OP_MORE     >
OP_LESS     <
OP_AND      and
OP_OR       or
EQUAL       =
ARROW       <-
PLUS        \+
MINUS       -
ASTERISK    \*
SLASH       \/
DOT_IDENTIFIER \.[a-zA-Z_][0-9a-zA-Z_]*
COLON       \:
SEMICOLON   ;
COMMA       ,

IF          if
ELSE        else
FOR         for
IN          in
WHILE       while
GLOBAL      global
IMPORT      import
C_FUNCTION_DECLARATION  \[Cfunction[ \t]+[a-zA-Z_][0-9a-zA-Z_]*\]
C_FUNCTION_ARGUMENT     arguments:
C_FUNCTION_RETURN       return:
FUNCTION_DEFINITION     function[ \t]+[a-zA-Z_][0-9a-zA-Z_]*
METHOD_DEFINITION       @function[ \t]+[a-zA-Z_][0-9a-zA-Z_]*
C_TYPE_DEFINITION       Ctype[ \t]+[a-zA-Z_][0-9a-zA-Z_]*
CLASS_DEFINITION        class[ \t]+[a-zA-Z_][0-9a-zA-Z_]*
RETURN                  return
LEFT_PARENTHESIS  \(
RIGHT_PARENTHESIS \)
LEFT_BRACKET    \[
RIGHT_BRACKET   \]
LEFT_CURLY_BRACE \{
RIGHT_CURLY_BRACE \}

CALL        .+\(.*\)
C_FUNCTION  c\.[a-zA-Z_][0-9a-zA-Z_]*
MEMBER_IDENTIFIER @[a-zA-Z_][0-9a-zA-Z_]*
IDENTIFIER  [a-zA-Z_][0-9a-zA-Z_]*
EOL                 \n|\r\n

%%

^[ \t]*\n skip()
^[ \t]*\r\n skip()
[ \t] skip()
{COMMENT} skip()
{STRING_LITERAL} STRING_LITERAL
{INT_LITERAL} INT_LITERAL
{FLOAT_LITERAL} FLOAT_LITERAL
{USE} USE
{DOT_IDENTIFIER} DOT_IDENTIFIER
{ASTERISK} ASTERISK
{SLASH} SLASH
{PLUS} PLUS
{MINUS} MINUS
{EQUAL} EQUAL
{ARROW} ARROW
{OP_EQUAL} OP_EQUAL
{OP_NOT_EQUAL} OP_NOT_EQUAL
{OP_MORE_EQUAL} OP_MORE_EQUAL
{OP_LESS_EQUAL} OP_LESS_EQUAL
{OP_MORE} OP_MORE
{OP_LESS} OP_LESS
{OP_AND} OP_AND
{OP_OR} OP_OR
{COLON} COLON
{SEMICOLON} SEMICOLON
{COMMA} COMMA
{LEFT_PARENTHESIS} LEFT_PARENTHESIS
{RIGHT_PARENTHESIS} RIGHT_PARENTHESIS
{LEFT_BRACKET} LEFT_BRACKET
{RIGHT_BRACKET} RIGHT_BRACKET
{LEFT_CURLY_BRACE} LEFT_CURLY_BRACE
{RIGHT_CURLY_BRACE} RIGHT_CURLY_BRACE
{IF} IF
{ELSE} ELSE
{FOR} FOR
{IN} IN
{WHILE} WHILE
{GLOBAL} GLOBAL
{IMPORT} IMPORT
{METHOD_DEFINITION} METHOD_DEFINITION
{FUNCTION_DEFINITION} FUNCTION_DEFINITION
{CLASS_DEFINITION} CLASS_DEFINITION
{C_TYPE_DEFINITION} C_TYPE_DEFINITION
{C_FUNCTION_DECLARATION} C_FUNCTION_DECLARATION
{C_FUNCTION_ARGUMENT} C_FUNCTION_ARGUMENT
{C_FUNCTION_RETURN} C_FUNCTION_RETURN
{RETURN} RETURN
{C_FUNCTION} C_FUNCTION

{MEMBER_IDENTIFIER} MEMBER_IDENTIFIER
{IDENTIFIER} IDENTIFIER
{EOL} EOL

/*<<EOF>> {return 0;}*/

%%
