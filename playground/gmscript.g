//From: https://github.com/publicrepo/gmscript/blob/0388fade77c82ff25dbbef89390584a5202ca56c/gmsrc/src/gm/gmParser.y
/**********************************************************
                  GameMonkey Script
                     created by
            Matthew Riek and Greg Douglas
**********************************************************/

/**********************************************************
GameMonkey Script License

Copyright (c) 2003  Auran Development Ltd.

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the
Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice
shall be included in all copies or substantial portions of
the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
**********************************************************/

/*Tokens*/
%token CONSTANT_BINARY
%token CONSTANT_CHAR
%token CONSTANT_FLOAT
%token CONSTANT_HEX
%token CONSTANT_INT
%token CONSTANT_STRING
%token IDENTIFIER
%token KEYWORD_AND
%token KEYWORD_BREAK
%token KEYWORD_CASE
%token KEYWORD_CONTINUE
%token KEYWORD_DEFAULT
%token KEYWORD_DOWHILE
%token KEYWORD_ELSE
%token KEYWORD_FALSE
%token KEYWORD_FOR
%token KEYWORD_FOREACH
%token KEYWORD_FORK
%token KEYWORD_FUNCTION
%token KEYWORD_GLOBAL
%token KEYWORD_IF
%token KEYWORD_IN
%token KEYWORD_LOCAL
%token KEYWORD_MEMBER
%token KEYWORD_NULL
%token KEYWORD_OR
%token KEYWORD_RETURN
%token KEYWORD_SWITCH
%token KEYWORD_TABLE
%token KEYWORD_THIS
%token KEYWORD_TRUE
%token KEYWORD_WHILE
%token SYMBOL_ASGN_ADD
%token SYMBOL_ASGN_BAND
%token SYMBOL_ASGN_BOR
%token SYMBOL_ASGN_BSL
%token SYMBOL_ASGN_BSR
%token SYMBOL_ASGN_BXOR
%token SYMBOL_ASGN_DIVIDE
%token SYMBOL_ASGN_MINUS
%token SYMBOL_ASGN_REM
%token SYMBOL_ASGN_TIMES
%token SYMBOL_DEC
%token SYMBOL_EQ
%token SYMBOL_GTE
%token SYMBOL_INC
%token SYMBOL_LEFT_SHIFT
%token SYMBOL_LTE
%token SYMBOL_NEQ
%token SYMBOL_RIGHT_SHIFT
//%token TOKEN_ERROR


%start program

%%

program :
	statement_list
	;

statement_list :
	statement
	| statement_list statement
	;

statement :
	expression_statement
	| var_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	| function_statement
	;

compound_statement :
	'{' '}'
	| '{' statement_list '}'
	;

function_statement :
	KEYWORD_FUNCTION identifier '(' ')' compound_statement
	| KEYWORD_FUNCTION identifier '(' parameter_list ')' compound_statement
	| KEYWORD_FUNCTION tablemember_expression '(' ')' compound_statement
	| KEYWORD_FUNCTION tablemember_expression '(' parameter_list ')' compound_statement
	;

tablemember_expression :
	identifier '.' identifier
	| tablemember_expression '.' identifier
	;

var_statement :
	var_type identifier ';'
	| var_type identifier '=' constant_expression ';'
	| var_type KEYWORD_FUNCTION identifier '(' ')' compound_statement
	| var_type KEYWORD_FUNCTION identifier '(' parameter_list ')' compound_statement
	;

var_type :
	KEYWORD_LOCAL
	| KEYWORD_GLOBAL
	| KEYWORD_MEMBER
	;

expression_statement :
	';'
	| assignment_expression ';'
	;

selection_statement :
	KEYWORD_IF '(' constant_expression ')' compound_statement
	| KEYWORD_IF '(' constant_expression ')' compound_statement KEYWORD_ELSE compound_statement
	| KEYWORD_IF '(' constant_expression ')' compound_statement KEYWORD_ELSE selection_statement
	| KEYWORD_FORK identifier compound_statement
	| KEYWORD_FORK compound_statement
	| KEYWORD_SWITCH '(' constant_expression ')' '{' case_selection_statement_list '}'
	;

case_selection_statement :
	KEYWORD_CASE postfix_case_expression ':'
	| KEYWORD_CASE postfix_case_expression ':' compound_statement
	| KEYWORD_DEFAULT ':' compound_statement
	;

case_selection_statement_list :
	case_selection_statement
	| case_selection_statement_list case_selection_statement
	;

postfix_case_expression :
	case_expression
	| postfix_case_expression '[' constant_expression ']'
	| postfix_case_expression '.' identifier
	;

case_expression :
	identifier
	| '.' identifier
	| KEYWORD_THIS
	| constant
	;

iteration_statement :
	KEYWORD_WHILE '(' constant_expression ')' compound_statement
	| KEYWORD_DOWHILE '(' constant_expression ')' compound_statement
	| KEYWORD_FOR '(' expression_statement constant_expression_statement ')' compound_statement
	| KEYWORD_FOR '(' expression_statement constant_expression_statement assignment_expression ')' compound_statement
	| KEYWORD_FOREACH '(' identifier KEYWORD_IN constant_expression ')' compound_statement
	| KEYWORD_FOREACH '(' identifier KEYWORD_AND identifier KEYWORD_IN constant_expression ')' compound_statement
	;

jump_statement :
	KEYWORD_CONTINUE ';'
	| KEYWORD_BREAK ';'
	| KEYWORD_RETURN ';'
	| KEYWORD_RETURN constant_expression ';'
	;

assignment_expression :
	logical_or_expression
	| postfix_expression '=' logical_or_expression
	| postfix_expression SYMBOL_ASGN_BSR logical_or_expression
	| postfix_expression SYMBOL_ASGN_BSL logical_or_expression
	| postfix_expression SYMBOL_ASGN_ADD logical_or_expression
	| postfix_expression SYMBOL_ASGN_MINUS logical_or_expression
	| postfix_expression SYMBOL_ASGN_TIMES logical_or_expression
	| postfix_expression SYMBOL_ASGN_DIVIDE logical_or_expression
	| postfix_expression SYMBOL_ASGN_REM logical_or_expression
	| postfix_expression SYMBOL_ASGN_BAND logical_or_expression
	| postfix_expression SYMBOL_ASGN_BOR logical_or_expression
	| postfix_expression SYMBOL_ASGN_BXOR logical_or_expression
	;

constant_expression_statement :
	';'
	| constant_expression ';'
	;

constant_expression :
	logical_or_expression
	;

logical_or_expression :
	logical_and_expression
	| logical_or_expression KEYWORD_OR logical_and_expression
	;

logical_and_expression :
	inclusive_or_expression
	| logical_and_expression KEYWORD_AND inclusive_or_expression
	;

inclusive_or_expression :
	exclusive_or_expression
	| inclusive_or_expression '|' exclusive_or_expression
	;

exclusive_or_expression :
	and_expression
	| exclusive_or_expression '^' and_expression
	;

and_expression :
	equality_expression
	| and_expression '&' equality_expression
	;

equality_expression :
	relational_expression
	| equality_expression SYMBOL_EQ relational_expression
	| equality_expression SYMBOL_NEQ relational_expression
	;

relational_expression :
	shift_expression
	| relational_expression '<' shift_expression
	| relational_expression '>' shift_expression
	| relational_expression SYMBOL_LTE shift_expression
	| relational_expression SYMBOL_GTE shift_expression
	;

shift_expression :
	additive_expression
	| shift_expression SYMBOL_LEFT_SHIFT additive_expression
	| shift_expression SYMBOL_RIGHT_SHIFT additive_expression
	;

additive_expression :
	multiplicative_expression
	| additive_expression '+' multiplicative_expression
	| additive_expression '-' multiplicative_expression
	;

multiplicative_expression :
	unary_expression
	| multiplicative_expression '*' unary_expression
	| multiplicative_expression '/' unary_expression
	| multiplicative_expression '%' unary_expression
	;

unary_expression :
	postfix_expression
	| SYMBOL_INC unary_expression
	| SYMBOL_DEC unary_expression
	| unary_operator unary_expression
	;

unary_operator :
	'+'
	| '-'
	| '~'
	| '!'
	;

postfix_expression :
	primary_expression
	| postfix_expression '[' constant_expression ']'
	| postfix_expression '(' ')'
	| postfix_expression '(' argument_expression_list ')'
	| postfix_expression ':' identifier '(' ')'
	| postfix_expression ':' identifier '(' argument_expression_list ')'
	| postfix_expression '.' identifier
	;

argument_expression_list :
	constant_expression
	| argument_expression_list ',' constant_expression
	;

table_constructor :
	KEYWORD_TABLE '(' ')'
	| KEYWORD_TABLE '(' field_list ')'
	| '{' '}'
	| '{' field_list '}'
	| '{' field_list ',' '}'
	;

function_constructor :
	KEYWORD_FUNCTION '(' parameter_list ')' compound_statement
	| KEYWORD_FUNCTION '(' ')' compound_statement
	;

field_list :
	field
	| field_list ',' field
	;

field :
	constant_expression
	| identifier '=' constant_expression
	;

parameter_list :
	parameter
	| parameter_list ',' parameter
	;

parameter :
	identifier
	| identifier '=' constant_expression
	;

primary_expression :
	identifier
	| '.' identifier
	| KEYWORD_THIS
	| constant
	| table_constructor
	| function_constructor
	| '(' constant_expression ')'
	;

identifier :
	IDENTIFIER
	;

constant :
	CONSTANT_HEX
	| CONSTANT_BINARY
	| CONSTANT_INT
	| KEYWORD_TRUE
	| KEYWORD_FALSE
	| CONSTANT_CHAR
	| CONSTANT_FLOAT
	| constant_string_list
	| KEYWORD_NULL
	;

constant_string_list :
	CONSTANT_STRING
	| constant_string_list CONSTANT_STRING
	;

%%

DIGIT     [0-9]
LETTER    [a-zA-Z_]
HEX       [a-fA-F0-9]
BINARY    [0-1]
SCI		    [Ee][+-]?{DIGIT}+
FL		    (f|F)

%%

[ \t\v\r\n\f]                     skip()

"/*"(?s:.)*?"*/"	skip()

"//"[^\n]*	skip()

"local"                           KEYWORD_LOCAL
"global"                          KEYWORD_GLOBAL
"member"                          KEYWORD_MEMBER
"and"                             KEYWORD_AND
"or"                              KEYWORD_OR
"if"                              KEYWORD_IF
"else"                            KEYWORD_ELSE
"while"                           KEYWORD_WHILE
"for"                             KEYWORD_FOR
"foreach"                         KEYWORD_FOREACH
"in"                              KEYWORD_IN
"dowhile"                         KEYWORD_DOWHILE
"break"                           KEYWORD_BREAK
"continue"                        KEYWORD_CONTINUE
"null"                            KEYWORD_NULL
"return"                          KEYWORD_RETURN
"function"                        KEYWORD_FUNCTION
"table"                           KEYWORD_TABLE
"this"                            KEYWORD_THIS
"true"                            KEYWORD_TRUE
"false"                           KEYWORD_FALSE
"fork"                            KEYWORD_FORK
"switch"                          KEYWORD_SWITCH
"case"                            KEYWORD_CASE
"default"                         KEYWORD_DEFAULT

"&&"                              KEYWORD_AND
"||"                              KEYWORD_OR
">>="                             SYMBOL_ASGN_BSR
"<<="                             SYMBOL_ASGN_BSL
"+="                              SYMBOL_ASGN_ADD
"-="                              SYMBOL_ASGN_MINUS
"*="                              SYMBOL_ASGN_TIMES
"/="                              SYMBOL_ASGN_DIVIDE
"%="                              SYMBOL_ASGN_REM
"&="                              SYMBOL_ASGN_BAND
"|="                              SYMBOL_ASGN_BOR
"^="                              SYMBOL_ASGN_BXOR
">>"                              SYMBOL_RIGHT_SHIFT
"<<"                              SYMBOL_LEFT_SHIFT
"++"                              SYMBOL_INC
"--"                              SYMBOL_DEC
"<="                              SYMBOL_LTE
">="                              SYMBOL_GTE
"=="                              SYMBOL_EQ
"!="                              SYMBOL_NEQ
";"                               ';'
"{"                               '{'
"}"                               '}'
","                               ','
"="                               '='
"("                               '('
")"                               ')'
"["                               '['
"]"                               ']'
"."                               '.'
"!"                               '!'
"-"                               '-'
"+"                               '+'
"*"                               '*'
"/"                               '/'
"%"                               '%'
"<"                               '<'
">"                               '>'
"&"                               '&'
"|"                               '|'
"^"                               '^'
"~"                               '~'
":"                               ':'
":"                               ':'

0[xX]{HEX}+                       CONSTANT_HEX
0[bB]{BINARY}+                    CONSTANT_BINARY
{DIGIT}+                          CONSTANT_INT
'(\\.|[^\\'])+'                   CONSTANT_CHAR
{DIGIT}+{SCI}{FL}?		            CONSTANT_FLOAT
{DIGIT}*"."{DIGIT}+({SCI})?{FL}?	CONSTANT_FLOAT
{DIGIT}+"."{DIGIT}*({SCI})?{FL}?	CONSTANT_FLOAT
\"(\\.|[^\\"])*\"                 CONSTANT_STRING
`([^`]|`{2})*`                    CONSTANT_STRING

{LETTER}({LETTER}|{DIGIT})*       IDENTIFIER

//.                                 TOKEN_ERROR

%%
