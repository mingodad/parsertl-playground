//From: https://github.com/AcademySoftwareFoundation/OpenRV/blob/main/src/lib/mu/MuLang/Grammar.y

%token ILLEGAL_CHARACTER

/*Tokens*/
%token MU_CONSTRUCT
%token MU_FLOATCONST
%token MU_BOOLCONST
%token MU_CHARCONST
%token MU_INTCONST
%token MU_MEMBERVARIABLE
%token MU_MODULESYMBOL
%token MU_IDENTIFIER
%token MU_OBJECTCONST
%token MU_STRINGCONST
%token MU_EQUALS
%token MU_GREATEREQUALS
%token MU_LESSEQUALS
%token MU_LOGICAND
%token MU_LOGICOR
%token MU_LSHIFT
%token MU_NOTEQUALS
%token MU_OP_ASSIGN
%token MU_EQ
%token MU_NEQ
%token MU_OP_INC
%token MU_OP_SYMASSIGN
%token MU_RSHIFT
%token MU_SYMBOLICCONST
%token MU_PREFIXEDSYMBOL
%token MU_SYMBOL
%token MU_VARIABLEATTRIBUTE
%token MU_KIND_KEY
%token MU_TYPE_KEY
%token MU_ALIAS
%token MU_ARROW
%token MU_BREAK
%token MU_CASE
%token MU_CATCH
%token MU_CLASS
%token MU_CONST
%token MU_CONTINUE
%token MU_DO
%token MU_DOCUMENTATION
%token MU_DOUBLECOLON
%token MU_DOUBLEDOT
%token MU_ELLIPSIS
%token MU_ELSE
%token MU_FOR
%token MU_FOREACH
%token MU_FORINDEX
%token MU_FUNCTION
%token MU_GLOBAL
%token MU_IF
%token MU_INTERFACE
%token MU_LAMBDA
%token MU_LET
%token MU_METHOD
%token MU_MODULE
%token MU_NIL
%token MU_OPERATOR
%token MU_QUADRUPLEDOT
%token MU_DOUBLEARROW
%token MU_REPEAT
%token MU_REQUIRE
%token MU_RETURN
%token MU_TEMPLATE
%token MU_THEN
%token MU_THROW
%token MU_TRY
%token MU_UNION
%token MU_USE
%token MU_WHILE
%token MU_YIELD
%token MU_TYPE
%token MU_TYPECONSTRUCTOR
%token MU_TYPEMODIFIER
%token MU_VARIABLE
%token MU_CALL
%token MU_JUSTIF
%token ';'
%token '{'
%token '}'
%token '='
%token '-'
%token '.'
%token '|'
%token ':'
%token ','
%token '('
%token ')'
%token '_'
%token '['
%token ']'
%token '^'
%token '&'
%token '>'
%token '<'
%token '+'
%token '*'
%token '/'
%token '%'
%token '!'
%token '~'
%token '\''

%nonassoc /*1*/ MU_CALL
%nonassoc /*2*/ MU_JUSTIF
%nonassoc /*3*/ MU_ELSE
%nonassoc /*4*/ MU_THEN

%start compilation_unit

%%

compilation_unit :
	expression
	| /*empty*/
	| statement_list
	| type
	//| error
	;

statement_list :
	statement
	| statement_list statement
	;

statement :
	';'
	| expression_statement
	| if_statement
	| case_statement
	| iteration_statement
	| compound_statement
	| declaration_statement
	| break_or_continue_statement
	| return_statement
	| try_catch_statement
	| throw_statement
	| module_statement
	| documentation_module
	//| error ';'
	| type_or_function_declaration
	| documentation_statement
	| require_statement
	| use_statement
	| symbolic_statement
	;

type_or_function_declaration_list :
	type_or_function_declaration
	| type_or_function_declaration_list type_or_function_declaration
	;

type_or_function_declaration :
	function_declaration
	| type_declaration
	;

type_declaration :
	class_or_interface_declaration
	| variant_type_declaration
	;

module_prolog :
	MU_MODULE identifier_or_symbol
	| MU_MODULE module
	;

module_statement :
	module_prolog '{' statement_list '}'
	;

require_statement :
	MU_REQUIRE identifier ';'
	| MU_REQUIRE module ';'
	;

use_statement :
	MU_USE identifier ';'
	| MU_USE module ';'
	| MU_USE primary_type ';'
	;

sym_assign_op :
	MU_OP_SYMASSIGN
	;

symbolic_statement :
	identifier sym_assign_op symbol_type_or_module ';'
	| MU_ALIAS identifier '=' symbol_type_or_module ';'
	| type_or_module sym_assign_op symbol_type_or_module ';'
	| MU_ALIAS type_or_module '=' symbol_type_or_module ';'
	| identifier sym_assign_op value_expression ';'
	| identifier sym_assign_op '-' value_expression ';'
	| MU_ALIAS identifier '=' value_expression ';'
	;

documentation_module :
	MU_DOCUMENTATION '{' documentation_declaration_list '}'
	;

documentation_declaration_list :
	documentation_declaration
	| documentation_declaration_list documentation_declaration
	;

documentation_declaration :
	documentation_identifier MU_STRINGCONST
	| documentation_identifier type MU_STRINGCONST
	| MU_STRINGCONST
	;

documentation_identifier :
	identifier_or_symbol_or_module_or_type
	| documentation_identifier '.' identifier_or_symbol_or_module_or_type
	;

documentation_statement :
	MU_DOCUMENTATION documentation_declaration
	;

variant_tag :
	identifier_or_symbol_or_module_or_type
	| identifier_or_symbol_or_module_or_type type
	;

variant_tag_list :
	variant_tag
	| variant_tag_list '|' variant_tag
	;

variant_prolog :
	MU_UNION identifier_or_symbol_or_module_or_type
	;

variant_type_declaration :
	variant_prolog '{' type_or_function_declaration_list variant_tag_list '}'
	| variant_prolog '{' variant_tag_list '}'
	;

class_or_interface_declaration :
	class_or_interface_prolog '{' statement_list '}'
	;

class_or_interface :
	MU_CLASS
	| MU_INTERFACE
	;

class_or_interface_imp_opt :
	/*empty*/
	| ':' type_list
	;

class_or_interface_prolog :
	class_or_interface identifier_or_symbol_or_module_or_type class_or_interface_imp_opt
	;

parameter_assignment :
	/*empty*/
	| '=' conditional_expression
	;

parameter :
	declaration_type
	| declaration_type identifier_or_symbol parameter_assignment
	;

parameter_list :
	parameter
	| parameter_list ',' parameter
	| /*empty*/
	;

function_prolog :
	MU_OPERATOR identifier '(' type ';' parameter_list ')'
	| MU_OPERATOR identifier '(' parameter_list ')'
	| MU_FUNCTION identifier_or_symbol_or_type '(' type ';' parameter_list ')'
	| MU_FUNCTION identifier_or_symbol_or_type '(' parameter_list ')'
	| MU_METHOD identifier_or_symbol_or_type '(' type ';' parameter_list ')'
	| MU_METHOD identifier_or_symbol_or_type '(' parameter_list ')'
	;

function_declaration :
	function_prolog compound_statement
	| function_prolog ';'
	;

lambda_prolog :
	MU_FUNCTION '(' type ';' parameter_list ')'
	| MU_FUNCTION '(' parameter_list ')'
	;

lambda_value_expression :
	lambda_prolog compound_statement
	;

compound_statement :
	'{' anonymous_scope statement_list '}'
	;

anonymous_scope :
	/*empty*/
	;

for_init_expression :
	assignment_expression
	| declaration
	;

for_each_init_expressions :
	identifier_or_initializer_symbol ';' expression
	;

for_index_init_expressions :
	identifier_or_initializer_symbol_list ';' expression
	;

iteration_statement :
	MU_FOR anonymous_scope '(' for_init_expression ';' expression_or_true ';' assignment_expression ')' statement
	| MU_FOREACH anonymous_scope '(' for_each_init_expressions ')' statement
	| MU_FORINDEX anonymous_scope '(' for_index_init_expressions ')' statement
	| MU_WHILE '(' expression ')' statement
	| MU_REPEAT '(' expression ')' statement
	| MU_DO statement MU_WHILE '(' expression ')'
	| MU_CONSTRUCT anonymous_scope '(' for_init_expression ';' argument_list_opt ')' statement
	| MU_CONSTRUCT anonymous_scope '(' argument_list_opt ')' statement
	;

if_statement :
	MU_IF '(' expression ')' statement %prec MU_JUSTIF /*2N*/
	| MU_IF '(' expression ')' statement MU_ELSE /*3N*/ statement
	;

case_prolog :
	MU_CASE '(' expression ')'
	;

case_statement :
	case_prolog '{' case_pattern_statement_list '}'
	;

case_pattern :
	anonymous_scope pattern
	;

case_pattern_statement :
	case_pattern MU_ARROW statement
	;

case_pattern_statement_list :
	case_pattern_statement
	| case_pattern_statement_list case_pattern_statement
	;

return_statement :
	MU_RETURN ';'
	| MU_RETURN expression ';'
	;

break_or_continue_statement :
	MU_BREAK ';'
	| MU_CONTINUE ';'
	;

throw_statement :
	MU_THROW expression ';'
	| MU_THROW ';'
	;

try_catch_statement :
	MU_TRY compound_statement catch_clause_list
	;

catch_clause :
	MU_CATCH anonymous_scope '(' catch_declaration ')' compound_statement
	;

catch_clause_list :
	catch_clause
	| catch_clause_list catch_clause
	;

catch_declaration :
	declaration_type identifier_or_initializer_symbol
	| MU_ELLIPSIS
	;

declaration_statement :
	declaration ';'
	;

declaration :
	declaration_type initializer_list
	| MU_LET let_initializer_list
	| MU_GLOBAL declaration_type initializer_list
	| MU_GLOBAL MU_LET let_initializer_list
	;

declaration_type :
	type
	;

let_initializer_list :
	let_initializer
	| let_initializer_list ',' let_initializer
	;

let_initializer :
	pattern '=' conditional_expression
	;

initializer_list :
	initializer
	| initializer_list ',' initializer
	;

initializer :
	identifier_or_initializer_symbol
	| identifier_or_initializer_symbol '=' conditional_expression
	| identifier_or_initializer_symbol '=' aggregate_initializer
	;

pattern :
	cons_pattern
	;

cons_pattern :
	primary_pattern
	| cons_pattern ':' primary_pattern
	;

primary_pattern :
	identifier_or_initializer_symbol
	| constant_suffix
	| '-' constant_suffix
	| type_constructor
	| type_constructor pattern
	| '_'
	| '(' pattern_list ')'
	| '{' pattern_list '}'
	| '[' pattern_list ']'
	;

pattern_list :
	pattern
	| pattern_list ',' pattern
	;

identifier_or_initializer_symbol :
	identifier
	| initializer_symbol
	;

identifier_or_initializer_symbol_list :
	identifier_or_initializer_symbol
	| identifier_or_initializer_symbol_list ',' identifier_or_initializer_symbol
	;

initializer_symbol :
	symbol
	;

expression_statement :
	assignment_expression ';'
	;

expression_or_true :
	expression
	| /*empty*/
	;

expression :
	tuple_expression
	;

argument_opt :
	conditional_expression
	| /*empty*/
	;

argument_list_opt :
	/*empty*/
	| argument_list
	;

argument_list :
	conditional_expression
	| argument_list ',' conditional_expression
	;

argument_slot_list_opt :
	argument_slot_list
	;

argument_slot_list :
	argument_opt
	| argument_slot_list ',' argument_opt
	;

assignment_expression :
	conditional_expression
	| postfix_value_expression assignment_operator assignment_expression
	;

assignment_operator :
	'='
	| MU_OP_ASSIGN
	;

tuple_expression :
	conditional_expression
	| tuple_expression ',' conditional_expression
	;

list_element_list :
	conditional_expression
	| list_element_list ',' conditional_expression
	;

conditional_expression :
	colon_expression
	| MU_IF colon_expression MU_THEN /*4N*/ conditional_expression MU_ELSE /*3N*/ conditional_expression
	;

colon_expression :
	lambda_expression
	| lambda_expression ':' colon_expression
	;

lambda_expression :
	lambda_value_expression
	| logical_OR_expression
	;

logical_OR_expression :
	logical_AND_expression
	| logical_OR_expression MU_LOGICOR logical_AND_expression
	;

logical_AND_expression :
	inclusive_OR_expression
	| logical_AND_expression MU_LOGICAND inclusive_OR_expression
	;

inclusive_OR_expression :
	exclusive_OR_expression
	| inclusive_OR_expression '|' exclusive_OR_expression
	;

exclusive_OR_expression :
	AND_expression
	| exclusive_OR_expression '^' AND_expression
	;

AND_expression :
	equality_expression
	| AND_expression '&' equality_expression
	;

equality_expression :
	relational_expression
	| equality_expression MU_EQUALS relational_expression
	| equality_expression MU_NOTEQUALS relational_expression
	| equality_expression MU_EQ relational_expression
	| equality_expression MU_NEQ relational_expression
	;

relational_expression :
	shift_expression
	| relational_expression '>' shift_expression
	| relational_expression '<' shift_expression
	| relational_expression MU_LESSEQUALS shift_expression
	| relational_expression MU_GREATEREQUALS shift_expression
	;

shift_expression :
	additive_expression
	| shift_expression MU_LSHIFT additive_expression
	| shift_expression MU_RSHIFT additive_expression
	;

additive_expression :
	multiplicative_expression
	| additive_expression '+' multiplicative_expression
	| additive_expression '-' multiplicative_expression
	;

multiplicative_expression :
	cast_expression
	| multiplicative_expression '*' cast_expression
	| multiplicative_expression '/' cast_expression
	| multiplicative_expression '%' cast_expression
	;

cast_expression :
	unary_expression
	;

unary_expression :
	postfix_value_expression
	| MU_OP_INC unary_expression
	| '-' cast_expression
	| '+' cast_expression
	| '*' cast_expression
	| '!' cast_expression
	| '~' cast_expression
	;

value_prefix :
	postfix_value_expression '.'
	;

postfix_value_expression :
	postfix_expression
	| value_expression
	;

postfix_expression :
	primary_expression
	| postfix_expression MU_OP_INC
	| postfix_expression '[' argument_list ']'
	;

value_expression :
	constant_suffix
	| aggregate_value
	| MU_NIL
	;

primary_expression :
	value_prefix MU_MEMBERVARIABLE
	| value_prefix symbol
	| value_prefix symbol '(' argument_slot_list_opt ')'
	| value_prefix identifier
	| '(' expression ')'
	| '[' list_element_list opt_comma ']'
	| '(' naked_operator ')'
	| scope_prefix naked_operator
	| symbol
	| symbol '(' argument_slot_list_opt ')'
	| identifier
	| prefixed_symbol
	| prefixed_symbol '(' argument_slot_list_opt ')'
	| type_constructor
	| type_constructor '(' argument_slot_list_opt ')'
	| type '(' argument_slot_list_opt ')'
	| identifier '(' argument_slot_list_opt ')'
	| postfix_expression '(' argument_slot_list_opt ')'
	;

aggregate_value :
	type aggregate_initializer
	;

opt_comma :
	/*empty*/
	| ','
	;

aggregate_next_field_type :
	aggregate_initializer_list ','
	;

aggregate_initializer_list :
	aggregate_initializer
	| aggregate_next_field_type aggregate_initializer
	| aggregate_next_field_type conditional_expression
	;

aggregate_initializer :
	'{' '}'
	| '{' argument_list '}'
	| '{' aggregate_initializer_list opt_comma '}'
	;

symbol_type_or_module :
	symbol
	| prefixed_symbol
	| type_or_module
	;

type_or_module :
	type
	| module
	;

prefixed_symbol :
	MU_PREFIXEDSYMBOL
	| scope_prefix symbol
	;

symbol :
	MU_SYMBOL
	;

scope_prefix :
	postfix_type '.'
	| module '.'
	;

type :
	unary_type
	;

type_list :
	/*empty*/
	| unary_type
	| type_list ',' unary_type
	;

type_constructor :
	MU_TYPECONSTRUCTOR
	| scope_prefix MU_TYPECONSTRUCTOR
	;

unary_type :
	postfix_type
	| MU_TYPEMODIFIER unary_type
	;

postfix_type :
	primary_type
	| postfix_type '[' type ']'
	| postfix_type '[' array_multidimension_declaration ']'
	;

primary_type :
	MU_TYPE
	| scope_prefix MU_TYPE
	| '\'' identifier_or_symbol
	| '\'' constant
	| '[' type ']'
	| '(' type_list ')'
	| '(' type ';' type_list ')'
	;

array_multidimension_declaration :
	array_dimension_declaration
	| array_multidimension_declaration ',' array_dimension_declaration
	;

array_dimension_declaration :
	/*empty*/
	| MU_INTCONST
	;

module :
	MU_MODULESYMBOL
	| scope_prefix MU_MODULESYMBOL
	;

identifier_or_symbol_or_module_or_type :
	identifier_or_symbol_or_type
	| MU_MODULESYMBOL
	;

identifier_or_symbol_or_type :
	identifier_or_symbol
	| MU_TYPE
	;

identifier_or_symbol :
	identifier
	| symbol
	;

naked_operator :
	'+'
	| '-'
	| '/'
	| '*'
	| '%'
	| '^'
	| '|'
	| '&'
	| '<'
	| '>'
	| ':'
	| '[' ']'
	| '(' ')'
	| MU_LESSEQUALS
	| MU_GREATEREQUALS
	| MU_LSHIFT
	| MU_RSHIFT
	| MU_EQUALS
	| MU_NOTEQUALS
	| MU_EQ
	| MU_NEQ
	;

identifier :
	MU_IDENTIFIER
	;

constant_suffix :
	constant
	| constant identifier_or_symbol
	;

constant :
	MU_FLOATCONST
	| MU_INTCONST
	| MU_BOOLCONST
	| MU_STRINGCONST
	| MU_CHARCONST
	| MU_SYMBOLICCONST
	| scope_prefix MU_SYMBOLICCONST
	;

%%

%x COMMENT
%x STRING
%x VERBATIM
%x IDMODE
//%x CHAR

Identifier		[A-Za-z_][A-Za-z_0-9]*
NewLine 		\r?[\n]
WhiteSpace		[[:blank:]]+
NonWhiteSpace		[^[:blank:]]+
FloatNumA 		[[:digit:]]*\.[[:digit:]]+([Ee][+-]?[[:digit:]]+)?
FloatNumB 		[[:digit:]]+\.?([Ee][+-]?[[:digit:]]+)?
IntNum			[[:digit:]]+
HexNum			0x[[:xdigit:]]+
UnicodeEsc		\\u[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]+
CUnicodeEsc             \'\\u[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]+\'
OctalEsc		\\[0-3][0-7][0-7]
BOM                     \xef\xbb\xbf

%%

{BOM}                   skip() /* ignore BOMs in file */
{WhiteSpace}            skip()
{NewLine}               skip()

"true"|"false"			MU_BOOLCONST

"nil"			MU_NIL

"_"                     '_'
"if"			MU_IF
"else"			MU_ELSE
"then"			MU_THEN
"case"			MU_CASE
"do"			MU_DO
"for"			MU_FOR
"let"                   MU_LET
"for_each"		MU_FOREACH
"for_index"		MU_FORINDEX
"repeat"		MU_REPEAT
"while"			MU_WHILE
"break"			MU_BREAK
"continue"		MU_CONTINUE
"try"			MU_TRY
"catch"			MU_CATCH
"const"			MU_CONST
"throw"			MU_THROW
"return"		MU_RETURN
"require"		MU_REQUIRE
"use"			MU_USE
"global"		MU_GLOBAL
"yield"                 MU_YIELD
"class:"                MU_CLASS
"interface:"            MU_INTERFACE
"method:"               MU_METHOD
"module:"               MU_MODULE
"function:"|"\\:"	MU_FUNCTION
"documentation:"	MU_DOCUMENTATION
"union:"                MU_UNION
"type:"                 MU_TYPE_KEY
"alias:"                MU_ALIAS
<INITIAL>"operator:"<IDMODE>		MU_OPERATOR

<IDMODE>{WhiteSpace}<.>
<IDMODE>{NewLine}<.>
<IDMODE>{NonWhiteSpace}<INITIAL>	MU_IDENTIFIER

\(			'('
\)			')'

"//".*{NewLine}		skip()
<INITIAL>"/*"<COMMENT>
<COMMENT>{NewLine}<.>
<COMMENT>"*/"<INITIAL>		skip()
<COMMENT>(?s:.)<.>	skip()

<INITIAL>"\"\"\""<VERBATIM>
<VERBATIM>{UnicodeEsc}<.>
<VERBATIM>{OctalEsc}<.>
<VERBATIM>{NewLine}<.>
<VERBATIM>"\\r"<.>
<VERBATIM>"\\\\"<.>
<VERBATIM>"\\\""<.>
<VERBATIM>"\"\"\""<INITIAL> MU_STRINGCONST
<VERBATIM>.<.>

<INITIAL>"\""<STRING>
<STRING>{UnicodeEsc}<.>
<STRING>{OctalEsc}<.>
<STRING>{NewLine}<.>
<STRING>"\\b"<.>
<STRING>"\\t"<.>
<STRING>"\\n"<.>
<STRING>"\\f"<.>
<STRING>"\\r"<.>
<STRING>"\\\""<.>
<STRING>"\'"<.>
<STRING>"\\\\"<.>
<STRING>"\""<INITIAL>MU_STRINGCONST
<STRING>.<.>

{IntNum}|{HexNum}		MU_INTCONST

{FloatNumA}|{FloatNumB}             MU_FLOATCONST

\'\\[btnfr\\]\'         MU_CHARCONST

{CUnicodeEsc}           MU_CHARCONST

\'[^\']{1,4}\'|\'\\\'\'                MU_CHARCONST

"{%%debug%%}"           skip()

".."                    MU_DOUBLEDOT
"..."			MU_ELLIPSIS
"...."			MU_QUADRUPLEDOT
"++"|"--"			MU_OP_INC
":="			MU_OP_SYMASSIGN
"+="|"-="|"*="|"/="|"%="|"&="|"^="|"|="|"<<="|">>="	MU_OP_ASSIGN
"eq"			MU_EQ
"neq"			MU_NEQ
"=>"			MU_DOUBLEARROW
"->"			MU_ARROW
">>"			MU_RSHIFT
"<<"			MU_LSHIFT
"<="			MU_LESSEQUALS
">="			MU_GREATEREQUALS
"=="			MU_EQUALS
"!="			MU_NOTEQUALS
"&&"			MU_LOGICAND
"||"			MU_LOGICOR
">"			'>'
"<"			'<'

";"	';'
"{"	'{'
"}"	'}'
"="	'='
"-"	'-'
"."	'.'
"|"	'|'
":"	':'
","	','
"["	'['
"]"	']'
"^"	'^'
"&"	'&'
"+"	'+'
"*"	'*'
"/"	'/'
"%"	'%'
"!"	'!'
"~"	'~'
"'"	'\''

{Identifier}		MU_IDENTIFIER

.			ILLEGAL_CHARACTER

%%
