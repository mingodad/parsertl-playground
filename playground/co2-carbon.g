//From: https://github.com/peterpaul/co2/blob/a0dbc7df7d2e424123655339599360ce4f7f53ad/carbon/src/co2/grammar.y

/* Added _INCLUDE to be viewed on playground */

/*Tokens*/
%token _AND
%token _AND_IS
%token _BREAK
%token _CASE
%token _CATCH
%token _CHAR
%token _CHAR_CONSTANT
%token _CLASS
%token _CONTINUE
%token _DECREASE
%token _DEFAULT
%token _DELETE
%token _DIVIDE
%token _DO
%token _DOUBLE
%token _ELSE
%token _EQ
%token _FINALLY
%token _FLOAT
%token _FLOAT_CONSTANT
%token _FOR
%token _GEQ
%token _GET_VA_ARG
%token _IDENTIFIER
%token _IF
//%token _IMPORT
%token _INCLUDE
%token _INCREASE
%token _INT
%token _INT_CONSTANT
%token _INTERFACE
%token _IS_OF
%token _LEQ
%token _MULTIPLY
%token _NEQ
%token _NEW
%token _NULL_
%token _OR
%token _OR_IS
%token _POWER
%token _REMAINDER
%token _RETURN
%token _SELF
%token _SHIFTL
%token _SHIFTR
%token _SIZEOF
%token _STRING_CONSTANT
%token _STRUCT
%token _SUPER
%token _SWITCH
%token _THROW
%token _TRY
%token _TYPEDEF
%token _TYPE_IDENTIFIER
%token _UNSIGNED
%token _VA_ARG
%token _VA_LIST__
%token _VOID
%token _WHILE
%token _XOR
%token _XOR_IS

%nonassoc /*1*/ _IFX
%nonassoc /*2*/ _ELSE
%nonassoc /*3*/ _CONSTRUCTX
%nonassoc /*4*/ _CATCHX
%nonassoc /*5*/ _CATCH
%nonassoc /*6*/ _FINALLY
%nonassoc /*7*/ CLASSX
%left /*8*/ ','
%right /*9*/ '=' _INCREASE _DECREASE _MULTIPLY _DIVIDE _POWER _REMAINDER _AND_IS _OR_IS _XOR_IS
%left /*10*/ _OR '|'
%left /*11*/ _AND '&'
%left /*12*/ _EQ _NEQ
%nonassoc /*13*/ '<' _LEQ '>' _GEQ
%left /*14*/ _XOR '#'
%left /*15*/ _SHIFTL _SHIFTR
%left /*16*/ '+' '-'
%left /*17*/ '*' '/' '%' '^'
%right /*18*/ '!' _UNARY_MINUS _UNARY_PLUS _ADDRESS_OF _DEREFERENCE
%nonassoc /*19*/ _IS_OF
%right /*20*/ _CASTX
%left /*21*/ ':' '?'
%left /*22*/ '(' '[' '.'

%start input

%%

input :
	global_declaration_list
	;

global_declaration_list :
	global_declaration_list declaration_list_content
	| /*empty*/
	;

declaration_list :
	declaration_list declaration_list_content
	| /*empty*/
	;

declaration_list_content :
	declaration
	| variable_declaration_list
	| definition_declaration
	| function_header ';'
	| _INCLUDE _STRING_CONSTANT //To be viewed on playground
	;

declaration :
	function_declaration
	| struct_declaration
	| class_declaration
	| interface_declaration
	| constructor_declaration
	| destructor_declaration
	| type_declaration
	;

type_declaration :
	_TYPEDEF _TYPE_IDENTIFIER '=' /*9R*/ type ';'
	| _TYPEDEF _TYPE_IDENTIFIER '=' /*9R*/ _STRUCT type ';'
	| _TYPEDEF _TYPE_IDENTIFIER '=' /*9R*/ _IDENTIFIER ';'
	| _TYPEDEF _TYPE_IDENTIFIER '=' /*9R*/ _STRUCT _IDENTIFIER ';'
	;

definition_declaration :
	header_file definition
	| header_file '{' definition_list '}'
	;

definition_list :
	definition_list definition
	| definition
	;

definition :
	function_header ';'
	| declaration
	| variable_declaration_list
	;

header_file :
	'[' /*22L*/ _STRING_CONSTANT ']'
	;

variable_declaration_list :
	type variable_declaration_id_list ';'
	;

variable_declaration_id_list :
	variable_declaration_id_list ',' /*8L*/ variable_declaration_id
	| variable_declaration_id
	;

variable_declaration_id :
	_IDENTIFIER
	| _CLASS
	| _IDENTIFIER '=' /*9R*/ expression
	;

function_declaration :
	function_header statement
	;

function_header :
	type _IDENTIFIER '(' /*22L*/ formal_argument_list_var ')' implemented_interface_methods
	;

implemented_interface_methods :
	implemented_interface_methods implemented_interface_method
	| /*empty*/
	;

implemented_interface_method :
	',' /*8L*/ _TYPE_IDENTIFIER
	| ',' /*8L*/ _TYPE_IDENTIFIER '.' /*22L*/ _IDENTIFIER
	;

formal_argument_list_var :
	formal_argument_list ',' /*8L*/ _VA_ARG
	| opt_formal_argument_list
	| _VA_ARG
	;

opt_formal_argument_list :
	formal_argument_list
	| /*empty*/
	;

formal_argument_list :
	formal_argument_list ',' /*8L*/ formal_argument
	| formal_argument
	;

formal_argument :
	type _IDENTIFIER
	;

struct_declaration :
	_STRUCT identifier '{' struct_declaration_body '}'
	;

identifier :
	_TYPE_IDENTIFIER
	| _IDENTIFIER
	;

struct_declaration_body :
	struct_declaration_body variable_declaration_list
	| /*empty*/
	;

class_declaration :
	class_header '{' declaration_list '}'
	;

class_header :
	_CLASS _TYPE_IDENTIFIER ':' /*21L*/ _TYPE_IDENTIFIER interface_list
	| _CLASS _TYPE_IDENTIFIER interface_list
	;

interface_list :
	interface_list ',' /*8L*/ _TYPE_IDENTIFIER
	| /*empty*/
	;

statement :
	compound_statement
	| if_statement
	| expression_statement
	| do_statement
	| while_statement
	| for_statement
	| return_statement
	| delete_statement
	| try_statement
	| throw_statement
	| break_statement
	| continue_statement
	| switch_statement
	;

compound_statement :
	'{' compound_content_list '}'
	;

compound_content_list :
	compound_content_list compound_content
	| /*empty*/
	;

compound_content :
	statement
	| declaration
	| variable_declaration_list
	;

try_statement :
	_TRY statement catch_statement_list %prec _CATCHX /*4N*/
	| _TRY statement catch_statement_list _FINALLY /*6N*/ statement
	;

catch_statement_list :
	catch_statement_list catch_statement
	| /*empty*/
	;

catch_statement :
	_CATCH /*5N*/ '(' /*22L*/ formal_argument ')' statement
	;

throw_statement :
	_THROW expression ';'
	;

if_statement :
	_IF '(' /*22L*/ expression ')' statement %prec _IFX /*1N*/
	| _IF '(' /*22L*/ expression ')' statement _ELSE /*2N*/ statement
	;

expression_statement :
	expression ';'
	;

do_statement :
	_DO statement _WHILE expression ';'
	;

while_statement :
	_WHILE '(' /*22L*/ expression ')' statement
	;

for_statement :
	_FOR '(' /*22L*/ expression ';' expression ';' expression ')' statement
	;

return_statement :
	_RETURN expression ';'
	| _RETURN ';'
	;

delete_statement :
	_DELETE expression ';'
	;

break_statement :
	_BREAK ';'
	;

continue_statement :
	_CONTINUE ';'
	;

switch_statement :
	_SWITCH '(' /*22L*/ expression ')' '{' case_statement_list_with_default '}'
	;

case_statement_list_with_default :
	case_statement_list default_case
	| case_statement_list
	;

case_statement_list :
	case_statement_list case_statement
	| /*empty*/
	;

case_statement :
	_CASE constant ':' /*21L*/ case_content_list
	| _CASE _IDENTIFIER ':' /*21L*/ case_content_list
	;

case_content_list :
	case_content_list statement
	| /*empty*/
	;

default_case :
	_DEFAULT ':' /*21L*/ case_content_list
	;

interface_declaration :
	interface_header '{' interface_method_declaration_list '}'
	;

interface_header :
	_INTERFACE _TYPE_IDENTIFIER interface_list
	;

interface_method_declaration_list :
	interface_method_declaration_list function_header ';'
	| interface_method_declaration_list function_declaration
	| /*empty*/
	;

type :
	_TYPE_IDENTIFIER %prec _CONSTRUCTX /*3N*/
	| _INT
	| _UNSIGNED
	| _FLOAT
	| _DOUBLE
	| _CHAR
	| type '[' /*22L*/ ']'
	| type '*' /*17L*/
	| _VA_LIST__
	| _VOID
	| type '(' /*22L*/ '*' /*17L*/ ')' '(' /*22L*/ opt_type_list ')'
	;

opt_type_list :
	type_list
	| /*empty*/
	;

type_list :
	type_list ',' /*8L*/ type
	| type
	;

expression :
	constant
	| _IDENTIFIER
	| _TYPE_IDENTIFIER '.' /*22L*/ _CLASS
	| _CLASS
	| _SELF
	| _VA_ARG
	| expression '(' /*22L*/ opt_actual_argument_list ')'
	| expression '[' /*22L*/ expression ']'
	| expression '.' /*22L*/ expression
	| expression '?' /*21L*/ '.' /*22L*/ expression
	| expression '+' /*16L*/ expression
	| expression '-' /*16L*/ expression
	| expression '/' /*17L*/ expression
	| expression '*' /*17L*/ expression
	| expression '^' /*17L*/ expression
	| expression '%' /*17L*/ expression
	| expression '&' /*11L*/ expression
	| expression '|' /*10L*/ expression
	| expression '#' /*14L*/ expression
	| expression '=' /*9R*/ expression
	| expression _AND /*11L*/ expression
	| expression _OR /*10L*/ expression
	| expression _XOR /*14L*/ expression
	| expression _EQ /*12L*/ expression
	| expression _NEQ /*12L*/ expression
	| expression '<' /*13N*/ expression
	| expression '>' /*13N*/ expression
	| expression _LEQ /*13N*/ expression
	| expression _GEQ /*13N*/ expression
	| expression _SHIFTR /*15L*/ expression
	| expression _SHIFTL /*15L*/ expression
	| expression _INCREASE /*9R*/ expression
	| expression _DECREASE /*9R*/ expression
	| expression _MULTIPLY /*9R*/ expression
	| expression _DIVIDE /*9R*/ expression
	| expression _POWER /*9R*/ expression
	| expression _REMAINDER /*9R*/ expression
	| expression _AND_IS /*9R*/ expression
	| expression _OR_IS /*9R*/ expression
	| expression _XOR_IS /*9R*/ expression
	| '-' /*16L*/ expression %prec _UNARY_MINUS /*18R*/
	| '+' /*16L*/ expression %prec _UNARY_PLUS /*18R*/
	| '!' /*18R*/ expression
	| '&' /*11L*/ expression %prec _ADDRESS_OF /*18R*/
	| '*' /*17L*/ expression %prec _DEREFERENCE /*18R*/
	| '(' /*22L*/ expression ')'
	| _NEW type '[' /*22L*/ expression ']'
	| _NEW type '(' /*22L*/ opt_actual_argument_list ')'
	| _NEW type '.' /*22L*/ _IDENTIFIER '(' /*22L*/ opt_actual_argument_list ')'
	| _SUPER '(' /*22L*/ opt_actual_argument_list ')'
	| _SUPER '.' /*22L*/ _IDENTIFIER '(' /*22L*/ opt_actual_argument_list ')'
	| _GET_VA_ARG '(' /*22L*/ type ')'
	| _GET_VA_ARG '(' /*22L*/ expression ',' /*8L*/ type ')'
	| _SIZEOF '(' /*22L*/ type ')'
	| '(' /*22L*/ type ')' expression %prec _CASTX /*20R*/
	| expression '?' /*21L*/ expression ':' /*21L*/ expression
	| expression _IS_OF /*19N*/ _TYPE_IDENTIFIER %prec CLASSX /*7N*/
	| expression _IS_OF /*19N*/ expression
	;

constant :
	_CHAR_CONSTANT
	| _FLOAT_CONSTANT
	| _INT_CONSTANT
	| string_constant
	| _NULL_
	;

opt_actual_argument_list :
	actual_argument_list
	| /*empty*/
	;

actual_argument_list :
	actual_argument_list ',' /*8L*/ expression
	| expression
	;

string_constant :
	string_constant _STRING_CONSTANT
	| _STRING_CONSTANT
	;

constructor_declaration :
	_TYPE_IDENTIFIER '(' /*22L*/ formal_argument_list_var ')' statement
	| _TYPE_IDENTIFIER '.' /*22L*/ _IDENTIFIER '(' /*22L*/ formal_argument_list_var ')' statement
	;

destructor_declaration :
	'~' _TYPE_IDENTIFIER '(' /*22L*/ ')' statement
	;

%%

%x MULTI_LINE_COMMENT
//%x ONE_LINE_COMMENT
%x INCLUDE

DIGIT		[0-9]
LETTER		[a-zA-Z]
UPPER_LETTER	[A-Z]
LOWER_LETTER	[a-z]
USCORE		_

INT_CONST	{DIGIT}+
FLOAT_CONST	{DIGIT}*\.{DIGIT}+(e-?{DIGIT}+)?
IDENTIFIER	({LOWER_LETTER}|{USCORE})({LETTER}|{USCORE}|{DIGIT})*
TYPE_IDENT	{UPPER_LETTER}({LETTER}|{USCORE}|{DIGIT})*
NON_ESCAPED	[^\\\n\'\"]
ESCAPED		[ntvbrfa\\\?\'\"]|[0-7]+|x[0-9A-Fa-f]+
CHAR_SYMBOL	{NON_ESCAPED}|\\{ESCAPED}
CHAR_CONST	\'({CHAR_SYMBOL}|\")\'
CHAR_CONST_ERR	\'({CHAR_SYMBOL}|\")*\'
STRING_CONST	\"({CHAR_SYMBOL}|\')*\"

%%

<INITIAL>{
	"/*"<MULTI_LINE_COMMENT>
	//"//"<ONE_LINE_COMMENT>
	"//".*	skip()
	^"include"<INCLUDE> _INCLUDE
}
<MULTI_LINE_COMMENT>{
	"*/"<INITIAL>	skip()
	[^*\n]+<.> // eat comment in chunks
	"*"<.> // eat the lone star
	\n<.>
}
//<ONE_LINE_COMMENT>{
//	[^\n]+<.> // eat comment in chunks
//	\n<INITIAL>	skip()
//	//<<EOF>>		BEGIN(INITIAL);
//}
<INCLUDE>[ \t\r]+		skip()/* eat the whitespace */
<INCLUDE>[^ \t\r\n]+<INITIAL>	_STRING_CONSTANT
"break"		_BREAK
"catch"		_CATCH
"case"		_CASE
"char"		_CHAR
"class"		_CLASS
"continue"	_CONTINUE
"default"	_DEFAULT
"delete"	_DELETE
"do"		_DO
"double"	_DOUBLE
"else"		_ELSE
"finally"	_FINALLY
"float"		_FLOAT
"for"		_FOR
"if"		_IF
//"import"	_IMPORT
"int"		_INT
"interface"	_INTERFACE
"is_of"		_IS_OF
"new"		_NEW
"null"		_NULL_
"return"	_RETURN
"self"		_SELF
"sizeof"	_SIZEOF
"struct"	_STRUCT
"super"		_SUPER
"switch"	_SWITCH
"throw"		_THROW
"try"		_TRY
"typedef"	_TYPEDEF
"unsigned"	_UNSIGNED
"va_arg"	_GET_VA_ARG
"va_list"	_VA_LIST__
"void"		_VOID
"while"		_WHILE
"..."		_VA_ARG
"&&"		_AND
"||"		_OR
"=="		_EQ
"!="		_NEQ
"##"		_XOR
"<="		_LEQ
">="		_GEQ
">>"		_SHIFTR
"<<"		_SHIFTL
"+="		_INCREASE
"-="		_DECREASE
"*="		_MULTIPLY
"/="		_DIVIDE
"^="		_POWER
"%="		_REMAINDER
"&="		_AND_IS
"|="		_OR_IS
"#="		_XOR_IS

"!"	'!'
"#"	'#'
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
"<"	'<'
"="	'='
">"	'>'
"?"	'?'
"["	'['
"]"	']'
"^"	'^'
"{"	'{'
"|"	'|'
"}"	'}'
"~"	'~'

{INT_CONST}	_INT_CONSTANT
{FLOAT_CONST}	_FLOAT_CONSTANT
{IDENTIFIER}	_IDENTIFIER
{TYPE_IDENT}	_TYPE_IDENTIFIER
{CHAR_CONST}	_CHAR_CONSTANT
//{CHAR_CONST_ERR}  _CHAR_CONSTANT, current_file, linenumber); error(yylval.token, "invalid character constant %s", yytext); yylval.token->type
{STRING_CONST}	_STRING_CONSTANT
//\n		skip() /* count lines */
[ \t\r\n]		skip() /* eat whitespace */
//[\(\)\]\{\}\;\:\,]	return yytext[0]; /* no Token for these characters */
//.		yytext[0], current_file, linenumber); return yylval.token->type;


%%
