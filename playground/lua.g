// /home/mingo/dev/c/A_grammars/lalr/lalr-nb/dist/Release/GNU-Linux/lalr-nb lua.g

/*Tokens*/
%token AND
%token BREAK
%token CONCAT
%token DO
%token ELLIPSES
%token ELSE
%token ELSEIF
%token END
%token EQ
%token FALSE
%token FOR
%token FUNCTION
%token GE
%token IDENTIFIER
%token IF
%token IN
%token LE
%token LOCAL
%token NE
%token NIL
%token NOT
%token NUMBER
%token OR
%token REPEAT
%token RETURN
%token SPECIAL
//%token SPECIAL_CONST
//%token SPECIAL_NUMBER
%token STRING
%token THEN
%token TRUE
%token UNARY_OPERATOR
%token UNTIL
%token WHILE

//declared to eliminate/silence the 2 shift reduce conflicts
%right '('
%left IDENTIFIER
%left STRING

%left /*1*/ OR
%left /*2*/ AND
%left /*3*/ GE LE '<' '>'
%left /*4*/ EQ NE
%right /*5*/ CONCAT
%left /*6*/ '+' '-'
%left /*7*/ '*' '/' '%'
%left /*8*/ UNARY_OPERATOR
%right /*9*/ '^'

%start file

%%

file :
	opt_block
	;

opt_block :
	opt_block_statements
	;

opt_block_statements :
	%empty
	| last_statement
	| statement_list
	| statement_list last_statement
	;

nobr_stmt_or_call :
	nobr_statement opt_special
	| nobr_statement ';' opt_special
	| nobr_function_call ';'
	;

br_stmt_or_call :
	br_statement
	| br_statement ';'
	| br_function_call ';'
	;

statement_list :
	nobr_function_call_list_oom
	| br_function_call_list_oom
	| nobr_stmt_or_call_list_oom
	| br_stmt_or_call_list_oom
	;

nobr_function_call_list_oom :
	nobr_function_call
	| nobr_function_call_list_oom nobr_function_call
	| br_function_call_list_oom nobr_function_call
	| nobr_stmt_or_call_list_oom nobr_function_call
	| br_stmt_or_call_list_oom nobr_function_call
	;

br_function_call_list_oom :
	br_function_call
	| nobr_stmt_or_call_list_oom br_function_call
	| br_stmt_or_call_list_oom br_function_call
	;

nobr_stmt_or_call_list_oom :
	nobr_stmt_or_call
	| nobr_function_call_list_oom nobr_stmt_or_call
	| br_function_call_list_oom nobr_stmt_or_call
	| nobr_stmt_or_call_list_oom nobr_stmt_or_call
	| br_stmt_or_call_list_oom nobr_stmt_or_call
	;

br_stmt_or_call_list_oom :
	br_stmt_or_call
	| nobr_stmt_or_call_list_oom br_stmt_or_call
	| br_stmt_or_call_list_oom br_stmt_or_call
	;

nobr_statement :
	nobr_variable_list '=' expression_list
	| DO opt_block END
	| WHILE expression DO opt_block END
	| REPEAT opt_block UNTIL expression
	| IF expression THEN opt_block opt_elseif_block_list opt_else_block END
	| FOR IDENTIFIER '=' expression ',' expression DO opt_block END
	| FOR IDENTIFIER '=' expression ',' expression ',' expression DO opt_block END
	| FOR identifier_list IN expression_list DO opt_block END
	| FUNCTION func_name_list function_body
	| FUNCTION func_name_list ':' IDENTIFIER function_body
	| LOCAL FUNCTION IDENTIFIER function_body
	| LOCAL identifier_list
	| LOCAL identifier_list '=' expression_list
	| IDENTIFIER STRING
	;

br_statement :
	br_variable_list '=' expression_list
	;

opt_elseif_block_list :
	%empty
	| elseif_block_list
	;

elseif_block_list :
	elseif_block
	| elseif_block_list elseif_block
	;

elseif_block :
	ELSEIF expression THEN opt_block
	;

opt_else_block :
	%empty
	| ELSE opt_block
	;

last_statement :
	RETURN opt_semicolon
	| RETURN expression_list opt_semicolon
	| BREAK opt_semicolon
	;

nobr_variable_list :
	nobr_variable
	| nobr_variable_list ',' nobr_variable
	| nobr_variable_list ',' br_variable
	;

br_variable_list :
	br_variable
	| br_variable_list ',' nobr_variable
	| br_variable_list ',' br_variable
	;

func_name_list :
	IDENTIFIER
	| func_name_list '.' IDENTIFIER
	;

expression :
	NIL
	| FALSE
	| TRUE
	| NUMBER
	| STRING
	| ELLIPSES
	| FUNCTION function_body
	| nobr_prefix_expression %prec '('
	| '(' expression ')'
	| table_constructor
	| expression CONCAT /*5R*/ expression
	| expression '+' /*6L*/ expression
	| expression '-' /*6L*/ expression
	| expression '*' /*7L*/ expression
	| expression '/' /*7L*/ expression
	| expression '^' /*9R*/ expression
	| expression '%' /*7L*/ expression
	| expression '<' /*3L*/ expression
	| expression LE /*3L*/ expression
	| expression '>' /*3L*/ expression
	| expression GE /*3L*/ expression
	| expression EQ /*4L*/ expression
	| expression NE /*4L*/ expression
	| expression AND /*2L*/ expression
	| expression OR /*1L*/ expression
	| NOT expression %prec UNARY_OPERATOR /*8L*/
	| '-' /*6L*/ expression %prec UNARY_OPERATOR /*8L*/
	| '#' expression %prec UNARY_OPERATOR /*8L*/
	;

expression_list :
	expression
	| expression_list ',' expression
	;

nobr_prefix_expression :
	nobr_variable
	| nobr_function_call
	;

nobr_variable :
	IDENTIFIER
	| nobr_prefix_expression '[' expression ']'
	| nobr_prefix_expression '.' IDENTIFIER
	;

br_variable :
	'(' expression ')' '[' expression ']'
	| '(' expression ')' '.' IDENTIFIER
	;

nobr_function_call :
	nobr_prefix_expression arguments
	| nobr_prefix_expression ':' IDENTIFIER arguments
	;

br_function_call :
	'(' expression ')' arguments
	| '(' expression ')' ':' IDENTIFIER arguments
	;

arguments :
	'(' ')'
	| '(' expression_list ')'
	| table_constructor
	| STRING
	;

function_body :
	'(' opt_parameter_list ')' opt_block END
	;

opt_parameter_list :
	%empty
	| ELLIPSES
	| identifier_list
	| identifier_list ',' ELLIPSES
	;

table_constructor :
	'{' '}'
	| '{' field_list opt_field_separator '}'
	;

field_list :
	field
	| field_list field_separator field
	;

field :
	'[' expression ']' '=' expression
	| IDENTIFIER '=' expression
	| expression
	;

opt_semicolon :
	%empty
	| ';'
	;

field_separator :
	','
	| ';'
	;

opt_field_separator :
	%empty
	| field_separator
	;

identifier_list :
	IDENTIFIER
	| identifier_list ',' IDENTIFIER
	;

opt_special :
	%empty
	| SPECIAL
	;

%%

whitespace [ \t\r\n]+
line_comment	\-\-[^\n\r]*

%%

/* Tokens */
/*\("[^"]+"\)\s+{ TOKEN(\([^)]+\)); }*/
and	AND
break	BREAK
do	DO
else	ELSE
elseif	ELSEIF
end	END
false	FALSE
for	FOR
function	FUNCTION
if	IF
in	IN
local	LOCAL
nil	NIL
not	NOT
or	OR
repeat	REPEAT
return	RETURN
then	THEN
true	TRUE
until	UNTIL
while	WHILE
".."	CONCAT
"..."	ELLIPSES
"=="	EQ
">="	GE
"<="	LE
"~="	NE
\<	'<'
>	'>'
\+	'+'
-	'-'
\*	'*'
\/	'/'
\%	'%'
\^	'^'
;	';'
=	'='
,	','
:	':'
\.	'.'
\(	'('
\)	')'
#	'#'
\[	'['
\]	']'
\{	'{'
\}	'}'

/* Order matter if identifier comes before keywords they are classified as identifier */
[a-zA-Z_][a-zA-Z_0-9]*	IDENTIFIER
0[xX][a-fA-F0-9]+|[0-9]+([Ee][+-]?[0-9]+)?|[0-9]*\.[0-9]+([Ee][+-]?[0-9]+)?	NUMBER
\"(\\.|[^\"\n\r\\])*\"|'(\\.|[^'\n\r\\])*'	STRING
"--@"	SPECIAL

{whitespace}	skip()
{line_comment}	skip() //need be the last to not shadow SPECIAL

%%
