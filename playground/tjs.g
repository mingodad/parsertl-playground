//From: https://github.com/krkrz/krkrz/blob/df0617687d3260a23e3c0ebd08f3f5edd0ed914c/tjs2/syntax/tjs.y
/*---------------------------------------------------------------------------*/
/*
	TJS2 Script Engine
	Copyright (C) 2000 W.Dee <dee@kikyou.info> and contributors

	See details of license at "license.txt"
*/

/*Tokens*/
%token T_CONSTVAL
%token T_INT
%token T_OCTET
%token T_REAL
%token T_REGEXP
%token T_STRING
%token T_SYMBOL
%token T_VOID

%start program

%%

program :
	global_list
	;

global_list :
	def_list
	;

def_list :
	/*empty*/
	| def_list block_or_statement
	//| def_list error ';'
	;

block_or_statement :
	statement
	| block
	;

statement :
	';'
	| expr ';'
	| if
	| if_else
	| while
	| do_while
	| for
	| "break" ';'
	| "continue" ';'
	| "debugger" ';'
	| variable_def
	| func_def
	| property_def
	| class_def
	| return
	| switch
	| with
	| case
	| try
	| throw
	;

block :
	'{' def_list '}'
	;

while :
	"while" '(' expr ')' block_or_statement
	;

do_while :
	"do" block_or_statement "while" '(' expr ')' ';'
	;

if :
	"if" '(' expr ')' block_or_statement
	;

if_else :
	if "else" block_or_statement
	;

for :
	"for" '(' for_first_clause ';' for_second_clause ';' for_third_clause ')' block_or_statement
	;

for_first_clause :
	/*empty*/
	| variable_def_inner
	| expr
	;

for_second_clause :
	/*empty*/
	| expr
	;

for_third_clause :
	/*empty*/
	| expr
	;

variable_def :
	variable_def_inner ';'
	;

variable_def_inner :
	"var" variable_id_list
	| "const" variable_id_list
	;

variable_id_list :
	variable_id
	| variable_id_list ',' variable_id
	;

variable_id :
	T_SYMBOL variable_type
	| T_SYMBOL variable_type '=' expr_no_comma
	;

variable_type :
	/*empty*/
	| ':' T_SYMBOL
	| ':' T_VOID
	| ':' T_INT
	| ':' T_REAL
	| ':' T_STRING
	| ':' T_OCTET
	;

func_def :
	"function" T_SYMBOL func_decl_arg_opt variable_type block
	;

func_expr_def :
	"function" func_decl_arg_opt variable_type block
	;

func_decl_arg_opt :
	/*empty*/
	| '(' func_decl_arg_collapse ')'
	| '(' func_decl_arg_list ')'
	| '(' func_decl_arg_at_least_one ',' func_decl_arg_collapse ')'
	;

func_decl_arg_list :
	/*empty*/
	| func_decl_arg_at_least_one
	;

func_decl_arg_at_least_one :
	func_decl_arg
	| func_decl_arg_at_least_one ',' func_decl_arg
	;

func_decl_arg :
	T_SYMBOL variable_type
	| T_SYMBOL variable_type '=' expr_no_comma
	;

func_decl_arg_collapse :
	'*'
	| T_SYMBOL variable_type '*'
	;

property_def :
	"property" T_SYMBOL '{' property_handler_def_list '}'
	;

property_handler_def_list :
	property_handler_setter
	| property_handler_getter
	| property_handler_setter property_handler_getter
	| property_handler_getter property_handler_setter
	;

property_handler_setter :
	"setter" '(' T_SYMBOL variable_type ')' block
	;

property_handler_getter :
	property_getter_handler_head block
	;

property_getter_handler_head :
	"getter" '(' ')' variable_type
	| "getter" variable_type
	;

class_def :
	"class" T_SYMBOL class_extender block
	;

class_extender :
	/*empty*/
	| "extends" expr_no_comma
	| "extends" expr_no_comma ',' extends_list
	;

extends_list :
	extends_name
	| extends_list ',' extends_name
	;

extends_name :
	expr_no_comma
	;

return :
	"return" ';'
	| "return" expr ';'
	;

switch :
	"switch" '(' expr ')' block
	;

with :
	"with" '(' expr ')' block_or_statement
	;

case :
	"case" expr ':'
	| "default" ':'
	;

try :
	"try" block_or_statement catch block_or_statement
	;

catch :
	"catch"
	| "catch" '(' ')'
	| "catch" '(' T_SYMBOL ')'
	;

throw :
	"throw" expr ';'
	;

expr_no_comma :
	assign_expr
	;

expr :
	comma_expr
	| comma_expr "if" expr
	;

comma_expr :
	assign_expr
	| comma_expr ',' assign_expr
	;

assign_expr :
	cond_expr
	| cond_expr "<->" assign_expr
	| cond_expr '=' assign_expr
	| cond_expr "&=" assign_expr
	| cond_expr "|=" assign_expr
	| cond_expr "^=" assign_expr
	| cond_expr "-=" assign_expr
	| cond_expr "+=" assign_expr
	| cond_expr "%=" assign_expr
	| cond_expr "/=" assign_expr
	| cond_expr "\\=" assign_expr
	| cond_expr "*=" assign_expr
	| cond_expr "||=" assign_expr
	| cond_expr "&&=" assign_expr
	| cond_expr ">>=" assign_expr
	| cond_expr "<<=" assign_expr
	| cond_expr ">>>=" assign_expr
	;

cond_expr :
	logical_or_expr
	| logical_or_expr '?' cond_expr ':' cond_expr
	;

logical_or_expr :
	logical_and_expr
	| logical_or_expr "||" logical_and_expr
	;

logical_and_expr :
	inclusive_or_expr
	| logical_and_expr "&&" inclusive_or_expr
	;

inclusive_or_expr :
	exclusive_or_expr
	| inclusive_or_expr '|' exclusive_or_expr
	;

exclusive_or_expr :
	and_expr
	| exclusive_or_expr '^' and_expr
	;

and_expr :
	identical_expr
	| and_expr '&' identical_expr
	;

identical_expr :
	compare_expr
	| identical_expr "!=" compare_expr
	| identical_expr "==" compare_expr
	| identical_expr "!==" compare_expr
	| identical_expr "===" compare_expr
	;

compare_expr :
	shift_expr
	| compare_expr '<' shift_expr
	| compare_expr '>' shift_expr
	| compare_expr "<=" shift_expr
	| compare_expr ">=" shift_expr
	;

shift_expr :
	add_sub_expr
	| shift_expr ">>" add_sub_expr
	| shift_expr "<<" add_sub_expr
	| shift_expr ">>>" add_sub_expr
	;

add_sub_expr :
	mul_div_expr
	| add_sub_expr '+' mul_div_expr
	| add_sub_expr '-' mul_div_expr
	;

mul_div_expr :
	unary_expr
	| mul_div_expr '%' unary_expr
	| mul_div_expr '/' unary_expr
	| mul_div_expr "\\" unary_expr
	| mul_div_expr_and_asterisk unary_expr
	;

mul_div_expr_and_asterisk :
	mul_div_expr '*'
	;

unary_expr :
	incontextof_expr
	| '!' unary_expr
	| '~' unary_expr
	| "--" unary_expr
	| "++" unary_expr
	| "new" func_call_expr
	| "invalidate" unary_expr
	| "isvalid" unary_expr
	| incontextof_expr "isvalid"
	| "delete" unary_expr
	| "typeof" unary_expr
	| '#' unary_expr
	| '$' unary_expr
	| '+' unary_expr
	| '-' unary_expr
	| '&' unary_expr
	| '*' unary_expr
	| incontextof_expr "instanceof" unary_expr
	| '(' "int" ')' unary_expr
	| "int" unary_expr
	| '(' "real" ')' unary_expr
	| "real" unary_expr
	| '(' "string" ')' unary_expr
	| "string" unary_expr
	;

incontextof_expr :
	priority_expr
	| priority_expr "incontextof" incontextof_expr
	;

priority_expr :
	factor_expr
	| '(' expr ')'
	| priority_expr '[' expr ']'
	| func_call_expr
	| priority_expr '.' T_SYMBOL
	| priority_expr "++"
	| priority_expr "--"
	| priority_expr '!'
	| '.' T_SYMBOL
	;

factor_expr :
	T_CONSTVAL
	| T_SYMBOL
	| "this"
	| "super"
	| func_expr_def
	| "global"
	| "void"
	| inline_array
	| inline_dic
	| const_inline_array
	| const_inline_dic
	| "/=" T_REGEXP
	| '/' T_REGEXP
	;

func_call_expr :
	priority_expr '(' call_arg_list ')'
	;

call_arg_list :
	"..."
	| call_arg
	| call_arg_list ',' call_arg
	;

call_arg :
	/*empty*/
	| '*'
	| mul_div_expr_and_asterisk
	| expr_no_comma
	;

inline_array :
	'[' array_elm_list ']'
	;

array_elm_list :
	array_elm
	| array_elm_list ',' array_elm
	;

array_elm :
	/*empty*/
	| expr_no_comma
	;

inline_dic :
	'%' '[' dic_elm_list dic_dummy_elm_opt ']'
	;

dic_elm_list :
	/*empty*/
	| dic_elm
	| dic_elm_list ',' dic_elm
	;

dic_elm :
	expr_no_comma ',' expr_no_comma
	| T_SYMBOL ':' expr_no_comma
	;

dic_dummy_elm_opt :
	/*empty*/
	| ','
	;

const_inline_array :
	'(' "const" ')' '[' const_array_elm_list_opt ']'
	;

const_array_elm_list_opt :
	/*empty*/
	| const_array_elm_list
	;

const_array_elm_list :
	const_array_elm
	| const_array_elm_list ',' const_array_elm
	;

const_array_elm :
	'-' T_CONSTVAL
	| '+' T_CONSTVAL
	| T_CONSTVAL
	| "void"
	| const_inline_array
	| const_inline_dic
	;

const_inline_dic :
	'(' "const" ')' '%' '[' const_dic_elm_list ']'
	;

const_dic_elm_list :
	/*empty*/
	| const_dic_elm
	| const_dic_elm_list ',' const_dic_elm
	;

const_dic_elm :
	T_CONSTVAL ',' '-' T_CONSTVAL
	| T_CONSTVAL ',' '+' T_CONSTVAL
	| T_CONSTVAL ',' T_CONSTVAL
	| T_CONSTVAL ',' "void"
	| T_CONSTVAL ',' const_inline_array
	| T_CONSTVAL ',' const_inline_dic
	;

%%

%%

[ \t\r\n]+  skip()
"//".*  skip()
"/*"(?s:.)*?"*/"  skip()

"^="	"^="
"^"	'^'
"~"	'~'
"<<="	"<<="
"<<"	"<<"
"<="	"<="
"<->"	"<->"
"<"	'<'
"==="	"==="
"=="	"=="
"="	'='
">="	">="
">>="	">>="
">>>="	">>>="
">>>"	">>>"
">>"	">>"
">"	'>'
"|="	"|="
"||="	"||="
"||"	"||"
"|"	'|'
"-="	"-="
"--"	"--"
"-"	'-'
","	','
";"	';'
":"	':'
"!=="	"!=="
"!="	"!="
"!"	'!'
"?"	'?'
"/="	"/="
"/"	'/'
"..."	"..."
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"$"	'$'
"*="	"*="
"*"	'*'
"\\="	"\\="
"\\"	"\\"
"&="	"&="
"&"	'&'
"&&="	"&&="
"&&"	"&&"
"#"	'#'
"%="	"%="
"%"	'%'
"+="	"+="
"+"	'+'
"++"	"++"
"break"	"break"
"case"	"case"
"catch"	"catch"
"class"	"class"
"const"	"const"
"continue"	"continue"
"debugger"	"debugger"
"default"	"default"
"delete"	"delete"
"do"	"do"
"else"	"else"
"extends"	"extends"
"for"	"for"
"function"	"function"
"getter"	"getter"
"global"	"global"
"if"	"if"
"incontextof"	"incontextof"
"instanceof"	"instanceof"
"int"	"int"
"invalidate"	"invalidate"
"isvalid"	"isvalid"
"new"	"new"
"property"	"property"
"real"	"real"
"return"	"return"
"setter"	"setter"
"string"	"string"
"super"	"super"
"switch"	"switch"
"this"	"this"
"throw"	"throw"
"try"	"try"
"typeof"	"typeof"
"var"	"var"
"void"	"void"
"while"	"while"
"with"	"with"

"void"	T_VOID
"octet"	T_OCTET
"octet"	T_CONSTVAL
"int"	T_INT
"real"  T_REAL

[0-9]+	T_CONSTVAL
[0-9]+"."[0-9]+	T_CONSTVAL
\"(\\.|[^"\r\n\\])*\"	T_CONSTVAL
[/](\\.|[^/\r\n\\])+[/]	T_REGEXP

[A-Za-z_][A-Za-z0-9_]*	T_SYMBOL

%%
