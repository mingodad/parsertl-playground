//From: https://github.com/dreamanlan/MetaDSL/blob/29e88dc3dca699d8236eed4fb63314624bf90155/DslParser/dsl.txt

%token ANGLE_BRACKET_COLON_BEGIN
%token ANGLE_BRACKET_COLON_END
%token ANGLE_BRACKET_PERCENT_BEGIN
%token ANGLE_BRACKET_PERCENT_END
%token BRACE_PERCENT_BEGIN
%token BRACE_PERCENT_END
%token BRACKET_COLON_BEGIN
%token BRACKET_COLON_END
%token BRACKET_PERCENT_BEGIN
%token BRACKET_PERCENT_END
%token DOLLAR_STRING
%token IDENTIFIER
%token NUMBER
%token OP_TOKEN_0
%token OP_TOKEN_1
%token OP_TOKEN_10
%token OP_TOKEN_11
%token OP_TOKEN_12
%token OP_TOKEN_13
%token OP_TOKEN_14
%token OP_TOKEN_15
%token OP_TOKEN_2
%token OP_TOKEN_3
%token OP_TOKEN_4
%token OP_TOKEN_5
%token OP_TOKEN_6
%token OP_TOKEN_7
%token OP_TOKEN_8
%token OP_TOKEN_9
%token OP_TOKEN_COLON
%token OP_TOKEN_QUESTION
%token PARENTHESIS_COLON_BEGIN
%token PARENTHESIS_COLON_END
%token PARENTHESIS_PERCENT_BEGIN
%token PARENTHESIS_PERCENT_END
%token PERIOD_STAR
%token POINTER
%token POINTER_STAR
%token QUESTION_BRACE
%token QUESTION_BRACKET
%token QUESTION_PARENTHESIS
%token QUESTION_PERIOD
%token QUESTION_PERIOD_STAR
%token SCRIPT_CONTENT
%token STRING

%%

PROGRAM:
	STATEMENTS
	;

STATEMENTS:
	STATEMENT
	| STATEMENTS SEP STATEMENT
	;

STATEMENT:
	OPERATOR_STATEMENT_DESC_0
	;

OPERATOR_STATEMENT_0:
	OPERATOR_STATEMENT_DESC_0
	;

OPERATOR_STATEMENT_1:
	OPERATOR_STATEMENT_DESC_1
	;

//OPERATOR_STATEMENT_2:
//	OPERATOR_STATEMENT_DESC_2

OPERATOR_STATEMENT_COLON:
	OPERATOR_STATEMENT_DESC_COLON
	;

OPERATOR_STATEMENT_QUESTION_COLON:
	OPERATOR_STATEMENT_DESC_QUESTION_COLON
	;

//OPERATOR_STATEMENT_3:
//	OPERATOR_STATEMENT_DESC_3

OPERATOR_STATEMENT_4:
	OPERATOR_STATEMENT_DESC_4
	;

OPERATOR_STATEMENT_5:
	OPERATOR_STATEMENT_DESC_5
	;

OPERATOR_STATEMENT_6:
	OPERATOR_STATEMENT_DESC_6
	;

OPERATOR_STATEMENT_7:
	OPERATOR_STATEMENT_DESC_7
	;

OPERATOR_STATEMENT_8:
	OPERATOR_STATEMENT_DESC_8
	;

OPERATOR_STATEMENT_9:
	OPERATOR_STATEMENT_DESC_9
	;

OPERATOR_STATEMENT_10:
	OPERATOR_STATEMENT_DESC_10
	;

OPERATOR_STATEMENT_11:
	OPERATOR_STATEMENT_DESC_11
	;

OPERATOR_STATEMENT_12:
	OPERATOR_STATEMENT_DESC_12
	;

OPERATOR_STATEMENT_13:
	OPERATOR_STATEMENT_DESC_13
	;

OPERATOR_STATEMENT_14:
	OPERATOR_STATEMENT_DESC_14
	;

OPERATOR_STATEMENT_15:
	OPERATOR_STATEMENT_DESC_15
	;

OPERATOR_STATEMENT_DESC_0:
	OPERATOR_STATEMENT_DESC_1
	| OPERATOR_STATEMENT_DESC_1 OP_TOKEN_0 OPERATOR_STATEMENT_0
	;

OPERATOR_STATEMENT_DESC_1:
	OPERATOR_STATEMENT_DESC_2
	| OPERATOR_STATEMENT_DESC_2 OP_TOKEN_1 OPERATOR_STATEMENT_1
	;

OPERATOR_STATEMENT_DESC_2:
	OPERATOR_STATEMENT_DESC_COLON
	| OPERATOR_STATEMENT_DESC_2 OP_TOKEN_2 OPERATOR_STATEMENT_COLON
	;

OPERATOR_STATEMENT_DESC_COLON:
	OPERATOR_STATEMENT_DESC_QUESTION_COLON
	| OPERATOR_STATEMENT_DESC_COLON OP_TOKEN_COLON OPERATOR_STATEMENT_QUESTION_COLON
	;

OPERATOR_STATEMENT_DESC_QUESTION_COLON:
	OPERATOR_STATEMENT_DESC_3
	| OPERATOR_STATEMENT_DESC_3 OP_TOKEN_QUESTION OPERATOR_STATEMENT_QUESTION_COLON OP_TOKEN_COLON OPERATOR_STATEMENT_QUESTION_COLON
	;

OPERATOR_STATEMENT_DESC_3:
	OPERATOR_STATEMENT_DESC_4
	| OPERATOR_STATEMENT_DESC_3 OP_TOKEN_3 OPERATOR_STATEMENT_4
	;

OPERATOR_STATEMENT_DESC_4:
	OPERATOR_STATEMENT_DESC_5
	| OPERATOR_STATEMENT_DESC_4 OP_TOKEN_4 OPERATOR_STATEMENT_5
	;

OPERATOR_STATEMENT_DESC_5:
	OPERATOR_STATEMENT_DESC_6
	| OPERATOR_STATEMENT_DESC_5 OP_TOKEN_5 OPERATOR_STATEMENT_6
	;

OPERATOR_STATEMENT_DESC_6:
	OPERATOR_STATEMENT_DESC_7
	| OPERATOR_STATEMENT_DESC_6 OP_TOKEN_6 OPERATOR_STATEMENT_7
	;

OPERATOR_STATEMENT_DESC_7:
	OPERATOR_STATEMENT_DESC_8
	| OPERATOR_STATEMENT_DESC_7 OP_TOKEN_7 OPERATOR_STATEMENT_8
	;

OPERATOR_STATEMENT_DESC_8:
	OPERATOR_STATEMENT_DESC_9
	| OPERATOR_STATEMENT_DESC_8 OP_TOKEN_8 OPERATOR_STATEMENT_9
	;

OPERATOR_STATEMENT_DESC_9:
	OPERATOR_STATEMENT_DESC_10
	| OPERATOR_STATEMENT_DESC_9 OP_TOKEN_9 OPERATOR_STATEMENT_10
	;

OPERATOR_STATEMENT_DESC_10:
	OPERATOR_STATEMENT_DESC_11
	| OPERATOR_STATEMENT_DESC_10 OP_TOKEN_10 OPERATOR_STATEMENT_11
	;

OPERATOR_STATEMENT_DESC_11:
	OPERATOR_STATEMENT_DESC_12
	| OPERATOR_STATEMENT_DESC_11 OP_TOKEN_11 OPERATOR_STATEMENT_12
	;

OPERATOR_STATEMENT_DESC_12:
	OPERATOR_STATEMENT_DESC_13
	| OPERATOR_STATEMENT_DESC_12 OP_TOKEN_12 OPERATOR_STATEMENT_13
	;

OPERATOR_STATEMENT_DESC_13:
	OPERATOR_STATEMENT_DESC_14
	| OPERATOR_STATEMENT_DESC_13 OP_TOKEN_13 OPERATOR_STATEMENT_14
	;

OPERATOR_STATEMENT_DESC_14:
	OPERATOR_STATEMENT_DESC_15
	| OPERATOR_STATEMENT_DESC_14 OP_TOKEN_14 OPERATOR_STATEMENT_15
	;

OPERATOR_STATEMENT_DESC_15:
	FUNCTION_STATEMENT_DESC
	| OPERATOR_STATEMENT_DESC_15 OP_TOKEN_15 FUNCTION_STATEMENT
	;

FUNCTION_STATEMENT:
	FUNCTION_STATEMENT_DESC
	;

FUNCTION_STATEMENT_DESC:
	 FUNCTION_CALLS
	;

FUNCTION_CALLS:
	FUNCTION_EX_CALL_zom
	| FUNCTION_EX_CALL_SPECIAL FUNCTION_EX_CALL_zom
	;

FUNCTION_EX_CALL_zom:
	/*empty*/
	| FUNCTION_EX_CALL_zom FUNCTION_EX_CALL
	;

FUNCTION_EX_CALL:
	FUNCTION_ID
	| FUNCTION_ID FUNCTION_PARAMS
	;

FUNCTION_EX_CALL_SPECIAL:
	FUNCTION_PARAMS
	;

FUNCTION_PARAMS:
	FUNCTION_PARAMS0
	| FUNCTION_PARAMS0 FUNCTION_PARAMS
	;

FUNCTION_PARAMS0:
	'(' STATEMENTS ')'
	| '[' STATEMENTS ']'
	| "::" STATIC_MEMBER_DESC
	| '.' MEMBER_DESC
	| QUESTION_PERIOD MEMBER_DESC2
	| QUESTION_PARENTHESIS STATEMENTS ')'
	| QUESTION_BRACKET STATEMENTS ']'
	| QUESTION_BRACE STATEMENTS '}'
	| POINTER MEMBER_DESC3
	| PERIOD_STAR MEMBER_DESC4
	| QUESTION_PERIOD_STAR MEMBER_DESC5
	| POINTER_STAR MEMBER_DESC6
	| '{' STATEMENTS '}'
	| SCRIPT_CONTENT
	| BRACKET_COLON_BEGIN STATEMENTS BRACKET_COLON_END
	| PARENTHESIS_COLON_BEGIN STATEMENTS PARENTHESIS_COLON_END
	| ANGLE_BRACKET_COLON_BEGIN STATEMENTS ANGLE_BRACKET_COLON_END
	| BRACE_PERCENT_BEGIN STATEMENTS BRACE_PERCENT_END
	| BRACKET_PERCENT_BEGIN STATEMENTS BRACKET_PERCENT_END
	| PARENTHESIS_PERCENT_BEGIN STATEMENTS PARENTHESIS_PERCENT_END
	| ANGLE_BRACKET_PERCENT_BEGIN STATEMENTS ANGLE_BRACKET_PERCENT_END
	;

STATIC_MEMBER_DESC:
	MEMBER_DESC
	;

MEMBER_DESC:
	FUNCTION_ID
	| '(' STATEMENTS ')'
	| '[' STATEMENTS ']'
	| '{' STATEMENTS '}'
	;

MEMBER_DESC2:
	FUNCTION_ID
	;

MEMBER_DESC3:
	FUNCTION_ID
	;

MEMBER_DESC4:
	 FUNCTION_ID
	;

MEMBER_DESC5:
	FUNCTION_ID
	;

MEMBER_DESC6:
	FUNCTION_ID
	;

FUNCTION_ID:
	IDENTIFIER
	| STRING
	| NUMBER
	| DOLLAR_STRING
	;

SEP:
	','
	| ';'
	;

%%

operators [~`!%^&*\-+=|:<>?/]

%%

[\n\r\t ]+	skip()
"#".*	skip()
"//".*		skip()
"/*"(?s:.)*?"*/"	skip()

"("	'('
")"	')'
"["	'['
"]"	']'
"::"	"::"
"."	'.'
"}"	'}'
"{"	'{'
","	','
";"	';'

"<:"	ANGLE_BRACKET_COLON_BEGIN
":>"	ANGLE_BRACKET_COLON_END
"<%"	ANGLE_BRACKET_PERCENT_BEGIN
"%>"	ANGLE_BRACKET_PERCENT_END
"{%"	BRACE_PERCENT_BEGIN
"%}"	BRACE_PERCENT_END
"[:"	BRACKET_COLON_BEGIN
":]"	BRACKET_COLON_END
"[%"	BRACKET_PERCENT_BEGIN
"%]"	BRACKET_PERCENT_END
"="	OP_TOKEN_0
"=>"|"<-"	OP_TOKEN_1
"<<"|">>"|">>>"	OP_TOKEN_10
"+"|"-"	OP_TOKEN_11
"*"|"/"|"%"|".."	OP_TOKEN_12
"++"|"--"|"~"|"!"	OP_TOKEN_13
OP_TOKEN_14	OP_TOKEN_14
OP_TOKEN_15	OP_TOKEN_15
OP_TOKEN_2	OP_TOKEN_2
"||"|"??"	OP_TOKEN_3
"&&"	OP_TOKEN_4
"|"	OP_TOKEN_5
"^"	OP_TOKEN_6
"&"	OP_TOKEN_7
"=="|"!="|"<=>"	OP_TOKEN_8
"<="|">="|"<"|">"	OP_TOKEN_9
":"	OP_TOKEN_COLON
"?"	OP_TOKEN_QUESTION
"(:"	PARENTHESIS_COLON_BEGIN
":)"	PARENTHESIS_COLON_END
"(%"	PARENTHESIS_PERCENT_BEGIN
"%)"	PARENTHESIS_PERCENT_END
".*"	PERIOD_STAR
"->"	POINTER
"->*"	POINTER_STAR
"?{"	QUESTION_BRACE
"?["	QUESTION_BRACKET
"?("	QUESTION_PARENTHESIS
"?."	QUESTION_PERIOD
"?.*"	QUESTION_PERIOD_STAR
SCRIPT_CONTENT	SCRIPT_CONTENT

DOLLAR_STRING	DOLLAR_STRING
\"(\\.|[^"\n\r\\])+\"	STRING
'(\\.|[^'\n\r\\])+'	STRING
[0-9]+	NUMBER
[@A-Za-z_][A-Za-z0-9_]*	IDENTIFIER

%%
