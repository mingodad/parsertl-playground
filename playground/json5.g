//Based on: https://github.com/Joakker/tree-sitter-json5

%token LCURLY RCURLY COMMA LBRACK RBRACK NULL TRUE FALSE COLON
%token identifier string_dq string_sq num_sign _number_hex _number_zd _number_d _number_infinity _number_nan

%%

file :
	object
	|  array
	;

object :
	LCURLY kv_list  comma_opt RCURLY
	;

comma_opt:
	/*empty*/
	| COMMA
	;

kv_list :
	/*emty*/
	| member
	| kv_list COMMA  member
	;

member :
	name  COLON  _value
	;

name :
	string
	|  identifier
	;

array :
	LBRACK value_list  comma_opt RBRACK
	;

value_list :
	/*empty*/
	| _value
	| value_list COMMA  _value
	;

string :
	string_dq
	| string_sq
	;

number :
	num_sign_opt _number
	;

num_sign_opt:
	/*empty*/
	| num_sign
	;

_number :
	_number_hex
	| _number_zd
	| _number_d
	| _number_infinity
	| _number_nan
	;

_value :
	object
	| array
	| number
	| string
	| NULL
	| TRUE
	| FALSE
	;

%%

spaces	[ \t\r\n]+
line_comment	\/\/[^\r\n]*
block_comment	\/\*(?s:.)*?\*\/

%%

{spaces}	skip()
{line_comment}	skip()
{block_comment}	skip()

/*[\$_\p{L}]([\$_\p{L}]|[0-9])*	identifier*/
[\$a-zA-Z_][\$a-zA-Z_0-9]*	identifier
\"((\\[\"\\bfnrtv\n])|[^\"\\])*\"	string_dq
'((\\['\\bfnrtv\n])|[^'\\])*'	string_sq
\+|\-	num_sign
0[xX][0-9a-fA-F]+	_number_hex
(0|[1-9][0-9]*)(\.[0-9]*)?([eE][+-]?[0-9]+)?	_number_zd
\.[0-9]*([eE][+-]?[0-9]+)?	_number_d
Infinity	_number_infinity
NaN	_number_nan
null	NULL
true	TRUE
false	FALSE
\[	LBRACK
\]	RBRACK
\{	LCURLY
\}	RCURLY
,	COMMA
:	COLON

%%
