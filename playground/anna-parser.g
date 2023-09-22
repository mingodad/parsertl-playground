//From: https://github.com/liljencrantz/anna/blob/dce1085594ab1f0cfb115997b726a74d120d6432/src/yacc.y

%x COMMENT
%x LONG_STRING

%token ILLEGAL_CHARACTHER

/*Tokens*/
%token LITERAL_INTEGER_BASE_2
%token LITERAL_INTEGER_BASE_8
%token LITERAL_INTEGER_BASE_10
%token LITERAL_INTEGER_BASE_16
%token LITERAL_FLOAT
%token LITERAL_CHAR
%token LITERAL_STRING
%token LITERAL_STRING_LONG_ELEMENT
%token LITERAL_STRING_LONG_BEGIN
%token LITERAL_STRING_LONG_END
%token IDENTIFIER
%token TYPE_IDENTIFIER
%token APPEND
%token INCREASE
%token DECREASE
%token NEXT
%token PREV
%token RANGE
%token DEF
%token MACRO
%token NULL_SYM
%token EQUAL
%token NOT_EQUAL
%token GREATER_OR_EQUAL
%token LESS_OR_EQUAL
%token AND
%token OR
%token VAR
%token CONST
%token RETURN
//%token RAISE
%token BREAK
%token CONTINUE
%token SEPARATOR
%token AS
%token IN
%token ELLIPSIS
%token TO
%token PAIR
%token DECLARE_VAR
%token DECLARE_CONST
%token SPECIALIZATION_BEGIN
%token SPECIALIZATION_END
%token SPECIALIZATION_BEGIN2
%token SPECIALIZATION_END2
%token STATIC_MEMBER_GET
%token '{'
%token '}'
%token '='
%token '!'
%token '^'
%token '('
%token ')'
%token '-'
%token '['
%token ']'
%token '.'
%token '<'
%token '>'
%token '+'
%token '~'
%token '*'
%token '/'
%token '%'


%start module

%%

module :
	opt_expression_list
	//| error separators
	;

block :
	'{' opt_expression_list '}'
	;

separators :
	SEPARATOR
	| separators SEPARATOR
	;

opt_expression_list :
	opt_separator
	| opt_separator expression_list opt_separator
	;

expression_list :
	expression_list separators expression
	| expression
	;

opt_declaration_init :
	'=' expression
	| /*empty*/
	;

expression :
	expression2 '=' expression
	| expression2 op expression
	| expression2
	| declaration_expression
	| type_definition
	| jump expression
	| jump
	;

jump :
	RETURN
	| CONTINUE
	| BREAK
	;

expression2 :
	expression2 op2 expression3
	| expression3
	;

opt_separator :
	/*empty*/
	| separators
	;

expression3 :
	expression3 op3 expression4
	| expression4
	;

expression4 :
	expression4 op4 expression5
	| expression4 RANGE expression5
	| expression4 ELLIPSIS
	| expression5
	;

expression5 :
	expression5 op5 expression6
	| expression6
	;

expression6 :
	expression6 op6 expression7
	| expression7
	;

expression7 :
	expression7 op7 expression8
	| expression8
	;

expression8 :
	'!' expression9
	| '^' identifier expression9
	| expression9 post_op8
	| expression9
	| expression8 AS expression9
	;

expression9 :
	expression9 '(' opt_expression_list ')' opt_blocks
	| '-' expression10
	| expression10 block
	| expression9 '[' opt_expression_list ']'
	| expression10
	| opt_specialization '[' opt_expression_list ']'
	| expression9 '.' expression10
	| expression9 STATIC_MEMBER_GET expression10
	| expression9 specialization
	;

expression10 :
	literal
	| any_identifier
	| '(' opt_expression_list ')'
	| NULL_SYM
	| block
	;

op :
	APPEND
	| INCREASE
	| DECREASE
	| TO
	;

op2 :
	AND
	| OR
	;

op3 :
	'<'
	| '>'
	| EQUAL
	| NOT_EQUAL
	| LESS_OR_EQUAL
	| GREATER_OR_EQUAL
	| IN
	;

op4 :
	'^' identifier
	;

op5 :
	PAIR
	;

op6 :
	'+'
	| '-'
	| '~'
	;

op7 :
	'*'
	| '/'
	| '%'
	;

post_op8 :
	NEXT
	| PREV
	;

opt_identifier :
	identifier
	| /*empty*/
	;

type_identifier :
	type_identifier2
	| '%' type_identifier2
	;

type_identifier2 :
	TYPE_IDENTIFIER
	;

identifier :
	identifier2
	| '%' identifier2
	;

identifier2 :
	IDENTIFIER
	| IN
	| AS
	| AND
	| OR
	;

any_identifier :
	identifier
	| type_identifier
	;

literal :
	LITERAL_INTEGER_BASE_10
	| LITERAL_INTEGER_BASE_16
	| LITERAL_INTEGER_BASE_8
	| LITERAL_INTEGER_BASE_2
	| LITERAL_FLOAT
	| LITERAL_CHAR
	| LITERAL_STRING
	| literal_string_long
	;

literal_string_long :
	literal_string_long_begin literal_string_long_internal LITERAL_STRING_LONG_END
	;

literal_string_long_begin :
	LITERAL_STRING_LONG_BEGIN
	;

literal_string_long_internal :
	LITERAL_STRING_LONG_ELEMENT
	| literal_string_long_internal LITERAL_STRING_LONG_ELEMENT
	;

opt_block :
	/*empty*/
	| block
	;

opt_blocks :
	/*empty*/
	| blocks
	;

blocks :
	block
	| blocks identifier block
	;

function_declaration :
	DEF opt_type_and_opt_name declaration_list opt_declaration_init
	;

function_signature :
	DEF opt_type_and_opt_name declaration_list
	;

opt_type_and_opt_name :
	type_remainder '.' any_identifier opt_specialization opt_identifier
	| function_signature opt_identifier
	| identifier
	| type_identifier opt_specialization opt_identifier
	| /*empty*/
	;

type_remainder :
	any_identifier
	| type_remainder '.' any_identifier
	;

function_definition :
	DEF opt_type_and_opt_name declaration_list attribute_list opt_block
	| MACRO identifier '(' identifier ')' attribute_list block
	;

declaration_list :
	'(' opt_separator ')'
	| '(' opt_separator declaration_list2 opt_separator ')'
	;

declaration_list2 :
	declaration_list_item
	| declaration_list2 separators declaration_list_item
	;

var_or_const :
	VAR
	| CONST
	;

declaration_expression :
	var_or_const opt_type_and_opt_name attribute_list opt_declaration_init
	| function_definition
	| expression2 DECLARE_VAR expression
	| expression2 DECLARE_CONST expression
	;

opt_ellipsis :
	/*empty*/
	| ELLIPSIS
	| TO
	;

type_and_name :
	type_remainder opt_specialization identifier
	| function_signature identifier
	;

variable_declaration :
	type_and_name opt_ellipsis attribute_list opt_declaration_init
	;

declaration_list_item :
	variable_declaration
	| function_declaration
	;

opt_specialization :
	/*empty*/
	| specialization
	;

specialization :
	SPECIALIZATION_BEGIN2 expression_list opt_separator SPECIALIZATION_END2
	| SPECIALIZATION_BEGIN expression_list opt_separator SPECIALIZATION_END
	;

type_definition :
	identifier type_identifier2 attribute_list block
	;

attribute_list :
	/*empty*/
	| '(' opt_expression_list ')'
	;

%%

%%

/*<COMMENT><<EOF>> anna_lex_unbalanced_comment();return 0; */
<COMMENT>\/\*<.>	skip()
<COMMENT>\*\/<INITIAL>	skip()
<COMMENT>.<.> 	skip()
<COMMENT>[ \t\n]<.> 	skip()

<LONG_STRING>\"=*\/<INITIAL>	LITERAL_STRING_LONG_ELEMENT
<LONG_STRING>\n<.>
<LONG_STRING>.<.>

<INITIAL>\/\*<COMMENT>
<INITIAL>_*[a-z][a-zA-Z0-9_!?]*\/=+\"<LONG_STRING>	LITERAL_STRING_LONG_BEGIN
<INITIAL>\/=*\"<LONG_STRING>	LITERAL_STRING_LONG_BEGIN
\/\/[^\n]*\n 	SEPARATOR
^#[^\n]*\n 	skip()
0[oO][0-7][0-7_]*_*[a-z][a-zA-Z0-9_!?]*	LITERAL_INTEGER_BASE_8
0[oO][0-7][0-7_]*	LITERAL_INTEGER_BASE_8
0[bB][0-1][0-1_]*_*[a-z][a-zA-Z0-9_!?]*	LITERAL_INTEGER_BASE_2
0[bB][0-1][0-1_]*	LITERAL_INTEGER_BASE_2
0[xX][0-9a-fA-F][0-9a-fA-F_]*_*[a-z][a-zA-Z0-9_!?]*	LITERAL_INTEGER_BASE_16
0[xX][0-9a-fA-F][0-9a-fA-F_]*	LITERAL_INTEGER_BASE_16
[0-9][0-9_]*_*[a-z][a-zA-Z0-9_!?]*	LITERAL_INTEGER_BASE_10
[0-9][0-9_]*	LITERAL_INTEGER_BASE_10
[0-9][0-9_]*\.[0-9_]*[0-9]+[0-9_]*([eE][-+]?[0-9_]+)?_*[a-z][a-zA-Z0-9_!?]*	LITERAL_FLOAT
[0-9][0-9_]*\.[0-9_]*[0-9]+[0-9_]*([eE][-+]?[0-9_]+)?	LITERAL_FLOAT
\(	'('
\)	')'
\[	'['
\]	']'
\{	'{'
\}	'}'
def	DEF
macro	MACRO
\?	NULL_SYM
and	AND
or	OR
var	VAR
const	CONST
return	RETURN
break	BREAK
continue	CONTINUE
as	AS
in	IN
_*[a-z][a-zA-Z0-9_!?]*'([^\'\\]|\\.)*'	LITERAL_CHAR
'([^\'\\]|\\.)*'	LITERAL_CHAR
_*[a-z][a-zA-Z0-9_!?]*\"([^\"\\]|\\.)*\"	LITERAL_STRING
\"([^\"\\]|\\.)*\"	LITERAL_STRING
_*[a-z][a-zA-Z0-9_!?]*	IDENTIFIER
_*[A-Z][a-zA-Z0-9_!?]*	TYPE_IDENTIFIER
~	'~'
~=	APPEND
\+	'+'
\+=	INCREASE
\-=	DECREASE
\+\+	NEXT
\-\-	PREV
-	'-'
\*	'*'
\/	'/'
==	EQUAL
!=	NOT_EQUAL
\<=	LESS_OR_EQUAL
>=	GREATER_OR_EQUAL
::	STATIC_MEMBER_GET
:	TO
\<	'<'
>	'>'
=	'='
:=	DECLARE_VAR
:==	DECLARE_CONST
\|	PAIR
\\\r?\n	skip()
\r?\n	SEPARATOR
,	SEPARATOR
!	'!'
%	'%'
\^	'^'
\.\.\.	ELLIPSIS
\.\.	RANGE
\.	'.'
«	SPECIALIZATION_BEGIN
»	SPECIALIZATION_END
\<\<	SPECIALIZATION_BEGIN2
>>	SPECIALIZATION_END2
[\r \t]	skip()
.	ILLEGAL_CHARACTHER

%%
