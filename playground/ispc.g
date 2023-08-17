//From: https://github.com/ispc/ispc

/*
Commented out 'error'
*/

/*Tokens*/
%token TOKEN_INT8_CONSTANT
%token TOKEN_UINT8_CONSTANT
%token TOKEN_INT16_CONSTANT
%token TOKEN_UINT16_CONSTANT
%token TOKEN_INT32_CONSTANT
%token TOKEN_UINT32_CONSTANT
%token TOKEN_INT64_CONSTANT
%token TOKEN_UINT64_CONSTANT
%token TOKEN_INT32DOTDOTDOT_CONSTANT
%token TOKEN_UINT32DOTDOTDOT_CONSTANT
%token TOKEN_INT64DOTDOTDOT_CONSTANT
%token TOKEN_UINT64DOTDOTDOT_CONSTANT
%token TOKEN_FLOAT16_CONSTANT
%token TOKEN_FLOAT_CONSTANT
%token TOKEN_DOUBLE_CONSTANT
%token TOKEN_STRING_C_LITERAL
%token TOKEN_STRING_SYCL_LITERAL
%token TOKEN_IDENTIFIER
%token TOKEN_STRING_LITERAL
%token TOKEN_TYPE_NAME
%token TOKEN_PRAGMA
%token TOKEN_NULL
%token TOKEN_TEMPLATE
%token TOKEN_TEMPLATE_NAME
%token TOKEN_TYPENAME
%token TOKEN_PTR_OP
%token TOKEN_INC_OP
%token TOKEN_DEC_OP
%token TOKEN_LEFT_OP
%token TOKEN_RIGHT_OP
%token TOKEN_LE_OP
%token TOKEN_GE_OP
%token TOKEN_EQ_OP
%token TOKEN_NE_OP
%token TOKEN_AND_OP
%token TOKEN_OR_OP
%token TOKEN_MUL_ASSIGN
%token TOKEN_DIV_ASSIGN
%token TOKEN_MOD_ASSIGN
%token TOKEN_ADD_ASSIGN
%token TOKEN_SUB_ASSIGN
%token TOKEN_LEFT_ASSIGN
%token TOKEN_RIGHT_ASSIGN
%token TOKEN_AND_ASSIGN
%token TOKEN_OR_ASSIGN
%token TOKEN_XOR_ASSIGN
%token TOKEN_SIZEOF
%token TOKEN_NEW
%token TOKEN_DELETE
%token TOKEN_IN
%token TOKEN_INTRINSIC_CALL
%token TOKEN_ALLOCA
%token TOKEN_EXTERN
%token TOKEN_EXPORT
%token TOKEN_STATIC
%token TOKEN_INLINE
%token TOKEN_NOINLINE
%token TOKEN_VECTORCALL
%token TOKEN_REGCALL
%token TOKEN_TASK
%token TOKEN_DECLSPEC
%token TOKEN_UNIFORM
%token TOKEN_VARYING
%token TOKEN_TYPEDEF
%token TOKEN_SOA
%token TOKEN_UNMASKED
%token TOKEN_INT
%token TOKEN_SIGNED
%token TOKEN_UNSIGNED
%token TOKEN_FLOAT16
%token TOKEN_FLOAT
%token TOKEN_DOUBLE
%token TOKEN_INT8
%token TOKEN_INT16
%token TOKEN_INT64
%token TOKEN_CONST
%token TOKEN_VOID
%token TOKEN_BOOL
%token TOKEN_UINT8
%token TOKEN_UINT16
%token TOKEN_UINT
%token TOKEN_UINT64
%token TOKEN_ENUM
%token TOKEN_STRUCT
%token TOKEN_TRUE
%token TOKEN_FALSE
%token TOKEN_CASE
%token TOKEN_DEFAULT
%token TOKEN_IF
%token TOKEN_ELSE
%token TOKEN_SWITCH
%token TOKEN_WHILE
%token TOKEN_DO
%token TOKEN_LAUNCH
%token TOKEN_FOREACH
%token TOKEN_FOREACH_TILED
%token TOKEN_FOREACH_UNIQUE
%token TOKEN_FOREACH_ACTIVE
%token TOKEN_DOTDOTDOT
%token TOKEN_FOR
%token TOKEN_GOTO
%token TOKEN_CONTINUE
%token TOKEN_BREAK
%token TOKEN_RETURN
%token TOKEN_CIF
%token TOKEN_CDO
%token TOKEN_CFOR
%token TOKEN_CWHILE
%token TOKEN_SYNC
%token TOKEN_PRINT
%token TOKEN_ASSERT
%token TOKEN_INVOKE_SYCL
%token '('
%token ')'
%token '['
%token ']'
%token ','
%token '<'
%token '>'
%token '.'
%token '&'
%token '*'
%token '+'
%token '-'
%token '~'
%token '!'
%token '/'
%token '%'
%token '^'
%token '|'
%token '?'
%token ':'
%token '='
%token ';'
%token '{'
%token '}'

%token ILLEGAL_CHARACTER

%nonassoc /*1*/ IF_WITHOUT_ELSE
%nonassoc /*2*/ TOKEN_ELSE

%start translation_unit

%%

string_constant :
	TOKEN_STRING_LITERAL
	| string_constant TOKEN_STRING_LITERAL
	;

primary_expression :
	TOKEN_IDENTIFIER
	| TOKEN_INT8_CONSTANT
	| TOKEN_UINT8_CONSTANT
	| TOKEN_INT16_CONSTANT
	| TOKEN_UINT16_CONSTANT
	| TOKEN_INT32_CONSTANT
	| TOKEN_UINT32_CONSTANT
	| TOKEN_INT64_CONSTANT
	| TOKEN_UINT64_CONSTANT
	| TOKEN_FLOAT16_CONSTANT
	| TOKEN_FLOAT_CONSTANT
	| TOKEN_DOUBLE_CONSTANT
	| TOKEN_TRUE
	| TOKEN_FALSE
	| TOKEN_NULL
	| '(' expression ')'
	//| '(' error ')'
	;

launch_expression :
	TOKEN_LAUNCH postfix_expression '(' argument_expression_list ')'
	| TOKEN_LAUNCH postfix_expression '(' ')'
	| TOKEN_LAUNCH '[' assignment_expression ']' postfix_expression '(' argument_expression_list ')'
	| TOKEN_LAUNCH '[' assignment_expression ']' postfix_expression '(' ')'
	| TOKEN_LAUNCH '[' assignment_expression ',' assignment_expression ']' postfix_expression '(' argument_expression_list ')'
	| TOKEN_LAUNCH '[' assignment_expression ',' assignment_expression ']' postfix_expression '(' ')'
	| TOKEN_LAUNCH '[' assignment_expression ']' '[' assignment_expression ']' postfix_expression '(' argument_expression_list ')'
	| TOKEN_LAUNCH '[' assignment_expression ']' '[' assignment_expression ']' postfix_expression '(' ')'
	| TOKEN_LAUNCH '[' assignment_expression ',' assignment_expression ',' assignment_expression ']' postfix_expression '(' argument_expression_list ')'
	| TOKEN_LAUNCH '[' assignment_expression ',' assignment_expression ',' assignment_expression ']' postfix_expression '(' ')'
	| TOKEN_LAUNCH '[' assignment_expression ']' '[' assignment_expression ']' '[' assignment_expression ']' postfix_expression '(' argument_expression_list ')'
	| TOKEN_LAUNCH '[' assignment_expression ']' '[' assignment_expression ']' '[' assignment_expression ']' postfix_expression '(' ')'
	| TOKEN_LAUNCH '<' postfix_expression '(' argument_expression_list ')' '>'
	| TOKEN_LAUNCH '<' postfix_expression '(' ')' '>'
	| TOKEN_LAUNCH '[' assignment_expression ']' '<' postfix_expression '(' argument_expression_list ')' '>'
	| TOKEN_LAUNCH '[' assignment_expression ']' '<' postfix_expression '(' ')' '>'
	;

invoke_sycl_expression :
	TOKEN_INVOKE_SYCL '(' postfix_expression ')'
	| TOKEN_INVOKE_SYCL '(' postfix_expression ',' argument_expression_list ')'
	//| TOKEN_INVOKE_SYCL '(' error ')'
	;

postfix_expression :
	primary_expression
	| postfix_expression '[' expression ']'
	//| postfix_expression '[' error ']'
	| launch_expression
	| postfix_expression '.' TOKEN_IDENTIFIER
	| postfix_expression TOKEN_PTR_OP TOKEN_IDENTIFIER
	| postfix_expression TOKEN_INC_OP
	| postfix_expression TOKEN_DEC_OP
	;

intrinsic_name :
	TOKEN_INTRINSIC_CALL
	;

intrincall_expression :
	intrinsic_name '(' argument_expression_list ')'
	;

funcall_expression :
	postfix_expression
	| postfix_expression '(' ')'
	| postfix_expression '(' argument_expression_list ')'
	//| postfix_expression '(' error ')'
	| simple_template_id '(' ')'
	| simple_template_id '(' argument_expression_list ')'
	//| simple_template_id '(' error ')'
	;

argument_expression_list :
	assignment_expression
	| argument_expression_list ',' assignment_expression
	;

unary_expression :
	funcall_expression
	| intrincall_expression
	| invoke_sycl_expression
	| TOKEN_INC_OP unary_expression
	| TOKEN_DEC_OP unary_expression
	| '&' unary_expression
	| '*' unary_expression
	| '+' cast_expression
	| '-' cast_expression
	| '~' cast_expression
	| '!' cast_expression
	| TOKEN_SIZEOF unary_expression
	| TOKEN_SIZEOF '(' type_name ')'
	| TOKEN_ALLOCA '(' assignment_expression ')'
	;

cast_expression :
	unary_expression
	| '(' type_name ')' cast_expression
	;

multiplicative_expression :
	cast_expression
	| multiplicative_expression '*' cast_expression
	| multiplicative_expression '/' cast_expression
	| multiplicative_expression '%' cast_expression
	;

additive_expression :
	multiplicative_expression
	| additive_expression '+' multiplicative_expression
	| additive_expression '-' multiplicative_expression
	;

shift_expression :
	additive_expression
	| shift_expression TOKEN_LEFT_OP additive_expression
	| shift_expression TOKEN_RIGHT_OP additive_expression
	;

relational_expression :
	shift_expression
	| relational_expression '<' shift_expression
	| relational_expression '>' shift_expression
	| relational_expression TOKEN_LE_OP shift_expression
	| relational_expression TOKEN_GE_OP shift_expression
	;

equality_expression :
	relational_expression
	| equality_expression TOKEN_EQ_OP relational_expression
	| equality_expression TOKEN_NE_OP relational_expression
	;

and_expression :
	equality_expression
	| and_expression '&' equality_expression
	;

exclusive_or_expression :
	and_expression
	| exclusive_or_expression '^' and_expression
	;

inclusive_or_expression :
	exclusive_or_expression
	| inclusive_or_expression '|' exclusive_or_expression
	;

logical_and_expression :
	inclusive_or_expression
	| logical_and_expression TOKEN_AND_OP inclusive_or_expression
	;

logical_or_expression :
	logical_and_expression
	| logical_or_expression TOKEN_OR_OP logical_and_expression
	;

conditional_expression :
	logical_or_expression
	| logical_or_expression '?' expression ':' conditional_expression
	;

rate_qualified_new :
	TOKEN_NEW
	| TOKEN_UNIFORM TOKEN_NEW
	| TOKEN_VARYING TOKEN_NEW
	;

rate_qualified_type_specifier :
	type_specifier
	| TOKEN_UNIFORM type_specifier
	| TOKEN_VARYING type_specifier
	| soa_width_specifier type_specifier
	;

new_expression :
	conditional_expression
	| rate_qualified_new rate_qualified_type_specifier
	| rate_qualified_new rate_qualified_type_specifier '(' initializer_list ')'
	| rate_qualified_new rate_qualified_type_specifier '[' expression ']'
	;

assignment_expression :
	new_expression
	| unary_expression '=' assignment_expression
	| unary_expression TOKEN_MUL_ASSIGN assignment_expression
	| unary_expression TOKEN_DIV_ASSIGN assignment_expression
	| unary_expression TOKEN_MOD_ASSIGN assignment_expression
	| unary_expression TOKEN_ADD_ASSIGN assignment_expression
	| unary_expression TOKEN_SUB_ASSIGN assignment_expression
	| unary_expression TOKEN_LEFT_ASSIGN assignment_expression
	| unary_expression TOKEN_RIGHT_ASSIGN assignment_expression
	| unary_expression TOKEN_AND_ASSIGN assignment_expression
	| unary_expression TOKEN_XOR_ASSIGN assignment_expression
	| unary_expression TOKEN_OR_ASSIGN assignment_expression
	;

expression :
	assignment_expression
	| expression ',' assignment_expression
	;

constant_expression :
	conditional_expression
	;

declaration_statement :
	declaration
	;

declaration :
	declaration_specifiers ';'
	| declaration_specifiers init_declarator_list ';'
	;

soa_width_specifier :
	TOKEN_SOA '<' int_constant '>'
	;

declspec_item :
	TOKEN_IDENTIFIER
	;

declspec_list :
	declspec_item
	| declspec_list ',' declspec_item
	;

declspec_specifier :
	TOKEN_DECLSPEC '(' declspec_list ')'
	;

declaration_specifiers :
	storage_class_specifier
	| storage_class_specifier declaration_specifiers
	| declspec_specifier
	| declspec_specifier declaration_specifiers
	| soa_width_specifier
	| soa_width_specifier declaration_specifiers
	| type_specifier
	| type_specifier '<' int_constant '>'
	| type_specifier declaration_specifiers
	| type_qualifier
	| type_qualifier declaration_specifiers
	;

init_declarator_list :
	init_declarator
	| init_declarator_list ',' init_declarator
	;

init_declarator :
	declarator
	| declarator '=' initializer
	;

storage_class_specifier :
	TOKEN_TYPEDEF
	| TOKEN_EXTERN
	| TOKEN_EXTERN TOKEN_STRING_C_LITERAL
	| TOKEN_EXTERN TOKEN_STRING_SYCL_LITERAL
	| TOKEN_STATIC
	;

type_specifier :
	atomic_var_type_specifier
	| TOKEN_TYPE_NAME
	| struct_or_union_specifier
	| enum_specifier
	;

type_specifier_list :
	type_specifier
	| type_specifier_list ',' type_specifier
	;

atomic_var_type_specifier :
	TOKEN_VOID
	| TOKEN_BOOL
	| TOKEN_INT8
	| TOKEN_UINT8
	| TOKEN_INT16
	| TOKEN_UINT16
	| TOKEN_INT
	| TOKEN_UINT
	| TOKEN_FLOAT16
	| TOKEN_FLOAT
	| TOKEN_DOUBLE
	| TOKEN_INT64
	| TOKEN_UINT64
	;

short_vec_specifier :
	atomic_var_type_specifier '<' int_constant '>'
	;

struct_or_union_name :
	TOKEN_IDENTIFIER
	| TOKEN_TYPE_NAME
	;

struct_or_union_and_name :
	struct_or_union struct_or_union_name
	;

struct_or_union_specifier :
	struct_or_union_and_name
	| struct_or_union_and_name '{' struct_declaration_list '}'
	| struct_or_union '{' struct_declaration_list '}'
	| struct_or_union '{' '}'
	| struct_or_union_and_name '{' '}'
	;

struct_or_union :
	TOKEN_STRUCT
	;

struct_declaration_list :
	struct_declaration
	| struct_declaration_list struct_declaration
	;

struct_declaration :
	specifier_qualifier_list struct_declarator_list ';'
	;

specifier_qualifier_list :
	type_specifier specifier_qualifier_list
	| type_specifier
	| short_vec_specifier
	| type_qualifier specifier_qualifier_list
	;

struct_declarator_list :
	struct_declarator
	| struct_declarator_list ',' struct_declarator
	;

struct_declarator :
	declarator
	;

enum_identifier :
	TOKEN_IDENTIFIER
	;

enum_specifier :
	TOKEN_ENUM '{' enumerator_list '}'
	| TOKEN_ENUM enum_identifier '{' enumerator_list '}'
	| TOKEN_ENUM '{' enumerator_list ',' '}'
	| TOKEN_ENUM enum_identifier '{' enumerator_list ',' '}'
	| TOKEN_ENUM enum_identifier
	;

enumerator_list :
	enumerator
	| enumerator_list ',' enumerator
	;

enumerator :
	enum_identifier
	| enum_identifier '=' constant_expression
	;

type_qualifier :
	TOKEN_CONST
	| TOKEN_UNIFORM
	| TOKEN_VARYING
	| TOKEN_TASK
	| TOKEN_UNMASKED
	| TOKEN_EXPORT
	| TOKEN_INLINE
	| TOKEN_NOINLINE
	| TOKEN_VECTORCALL
	| TOKEN_REGCALL
	| TOKEN_SIGNED
	| TOKEN_UNSIGNED
	;

type_qualifier_list :
	type_qualifier
	| type_qualifier_list type_qualifier
	;

declarator :
	pointer direct_declarator
	| reference direct_declarator
	| direct_declarator
	;

int_constant :
	TOKEN_INT8_CONSTANT
	| TOKEN_INT16_CONSTANT
	| TOKEN_INT32_CONSTANT
	| TOKEN_INT64_CONSTANT
	;

direct_declarator :
	TOKEN_IDENTIFIER
	| TOKEN_TEMPLATE_NAME
	| '(' declarator ')'
	| direct_declarator '[' constant_expression ']'
	| direct_declarator '[' ']'
	//| direct_declarator '[' error ']'
	| direct_declarator '(' parameter_type_list ')'
	| direct_declarator '(' ')'
	//| direct_declarator '(' error ')'
	;

pointer :
	'*'
	| '*' type_qualifier_list
	| '*' pointer
	| '*' type_qualifier_list pointer
	;

reference :
	'&'
	;

parameter_type_list :
	parameter_list
	;

parameter_list :
	parameter_declaration
	| parameter_list ',' parameter_declaration
	//| error ','
	;

parameter_declaration :
	declaration_specifiers declarator
	| declaration_specifiers declarator '=' initializer
	| declaration_specifiers abstract_declarator
	| declaration_specifiers
	;

type_name :
	specifier_qualifier_list
	| specifier_qualifier_list abstract_declarator
	;

abstract_declarator :
	pointer
	| direct_abstract_declarator
	| pointer direct_abstract_declarator
	| reference
	| reference direct_abstract_declarator
	;

direct_abstract_declarator :
	'(' abstract_declarator ')'
	| '[' ']'
	| '[' constant_expression ']'
	| direct_abstract_declarator '[' ']'
	| direct_abstract_declarator '[' constant_expression ']'
	| '(' ')'
	| '(' parameter_type_list ')'
	| direct_abstract_declarator '(' ')'
	| direct_abstract_declarator '(' parameter_type_list ')'
	;

initializer :
	assignment_expression
	| '{' initializer_list '}'
	| '{' initializer_list ',' '}'
	;

initializer_list :
	initializer
	| initializer_list ',' initializer
	;

pragma :
	TOKEN_PRAGMA
	;

attributed_statement :
	pragma attributed_statement
	| statement
	;

statement :
	labeled_statement
	| compound_statement
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	| declaration_statement
	| print_statement
	| assert_statement
	| sync_statement
	| delete_statement
	| unmasked_statement
	//| error ';'
	;

labeled_statement :
	goto_identifier ':' attributed_statement
	| TOKEN_CASE constant_expression ':' attributed_statement
	| TOKEN_DEFAULT ':' attributed_statement
	;

start_scope :
	'{'
	;

end_scope :
	'}'
	;

compound_statement :
	'{' '}'
	| start_scope statement_list end_scope
	;

statement_list :
	attributed_statement
	| statement_list attributed_statement
	;

expression_statement :
	';'
	| expression ';'
	;

selection_statement :
	TOKEN_IF '(' expression ')' attributed_statement %prec IF_WITHOUT_ELSE
	| TOKEN_IF '(' expression ')' attributed_statement TOKEN_ELSE attributed_statement
	| TOKEN_CIF '(' expression ')' attributed_statement %prec IF_WITHOUT_ELSE
	| TOKEN_CIF '(' expression ')' attributed_statement TOKEN_ELSE attributed_statement
	| TOKEN_SWITCH '(' expression ')' attributed_statement
	;

for_test :
	';'
	| expression ';'
	;

for_init_statement :
	expression_statement
	| declaration_statement
	;

for_scope :
	TOKEN_FOR
	;

cfor_scope :
	TOKEN_CFOR
	;

foreach_scope :
	TOKEN_FOREACH
	;

foreach_tiled_scope :
	TOKEN_FOREACH_TILED
	;

foreach_identifier :
	TOKEN_IDENTIFIER
	;

foreach_active_scope :
	TOKEN_FOREACH_ACTIVE
	;

foreach_active_identifier :
	TOKEN_IDENTIFIER
	;

integer_dotdotdot :
	TOKEN_INT32DOTDOTDOT_CONSTANT
	| TOKEN_UINT32DOTDOTDOT_CONSTANT
	| TOKEN_INT64DOTDOTDOT_CONSTANT
	| TOKEN_UINT64DOTDOTDOT_CONSTANT
	;

foreach_dimension_specifier :
	foreach_identifier '=' assignment_expression TOKEN_DOTDOTDOT assignment_expression
	| foreach_identifier '=' integer_dotdotdot assignment_expression
	;

foreach_dimension_list :
	foreach_dimension_specifier
	| foreach_dimension_list ',' foreach_dimension_specifier
	;

foreach_unique_scope :
	TOKEN_FOREACH_UNIQUE
	;

foreach_unique_identifier :
	TOKEN_IDENTIFIER
	;

iteration_statement :
	TOKEN_WHILE '(' expression ')' attributed_statement
	| TOKEN_CWHILE '(' expression ')' attributed_statement
	| TOKEN_DO attributed_statement TOKEN_WHILE '(' expression ')' ';'
	| TOKEN_CDO attributed_statement TOKEN_WHILE '(' expression ')' ';'
	| for_scope '(' for_init_statement for_test ')' attributed_statement
	| for_scope '(' for_init_statement for_test expression ')' attributed_statement
	| cfor_scope '(' for_init_statement for_test ')' attributed_statement
	| cfor_scope '(' for_init_statement for_test expression ')' attributed_statement
	| foreach_scope '(' foreach_dimension_list ')' attributed_statement
	| foreach_tiled_scope '(' foreach_dimension_list ')' attributed_statement
	| foreach_active_scope '(' foreach_active_identifier ')' attributed_statement
	| foreach_unique_scope '(' foreach_unique_identifier TOKEN_IN expression ')' attributed_statement
	;

goto_identifier :
	TOKEN_IDENTIFIER
	;

jump_statement :
	TOKEN_GOTO goto_identifier ';'
	| TOKEN_CONTINUE ';'
	| TOKEN_BREAK ';'
	| TOKEN_RETURN ';'
	| TOKEN_RETURN expression ';'
	;

sync_statement :
	TOKEN_SYNC ';'
	;

delete_statement :
	TOKEN_DELETE expression ';'
	;

unmasked_statement :
	TOKEN_UNMASKED '{' statement_list '}'
	;

print_statement :
	TOKEN_PRINT '(' string_constant ')' ';'
	| TOKEN_PRINT '(' string_constant ',' argument_expression_list ')' ';'
	;

assert_statement :
	TOKEN_ASSERT '(' string_constant ',' expression ')' ';'
	;

translation_unit :
	external_declaration
	| translation_unit external_declaration
	//| error ';'
	;

external_declaration :
	function_definition
	| template_function_declaration_or_definition
	| template_function_specialization
	| template_function_instantiation
	| TOKEN_EXTERN TOKEN_STRING_C_LITERAL '{' declaration '}'
	| TOKEN_EXTERN TOKEN_STRING_SYCL_LITERAL '{' declaration '}'
	| TOKEN_EXPORT '{' type_specifier_list '}' ';'
	| declaration
	| ';'
	;

function_definition :
	declaration_specifiers declarator compound_statement
	;

template_type_parameter :
	TOKEN_TYPENAME TOKEN_IDENTIFIER
	| TOKEN_TYPENAME TOKEN_IDENTIFIER '=' type_specifier
	;

template_int_parameter :
	TOKEN_INT TOKEN_IDENTIFIER
	;

template_parameter :
	template_type_parameter
	| template_int_parameter
	;

template_parameter_list :
	template_parameter
	| template_parameter_list ',' template_parameter
	;

template_head :
	TOKEN_TEMPLATE '<' template_parameter_list '>'
	;

template_declaration :
	template_head declaration_specifiers declarator
	;

template_function_declaration_or_definition :
	template_declaration ';'
	| template_declaration compound_statement
	;

template_argument_list :
	rate_qualified_type_specifier
	| template_argument_list ',' rate_qualified_type_specifier
	;

template_identifier :
	TOKEN_TEMPLATE_NAME
	;

simple_template_id :
	template_identifier '<' template_argument_list '>'
	| template_identifier
	;

template_function_instantiation :
	TOKEN_TEMPLATE declaration_specifiers simple_template_id '(' parameter_type_list ')' ';'
	| TOKEN_TEMPLATE declaration_specifiers simple_template_id '(' ')' ';'
	//| TOKEN_TEMPLATE declaration_specifiers simple_template_id '(' error ')' ';'
	;

template_function_specialization :
	TOKEN_TEMPLATE '<' '>' declaration_specifiers declarator ';'
	| TOKEN_TEMPLATE '<' '>' declaration_specifiers declarator compound_statement
	;

%%

WHITESPACE [ \t\r]+
INT_NUMBER (([0-9]+)|(0[xX][0-9a-fA-F]+)|(0b[01]+))[uUlL]*[kMG]?[uUlL]*
INT_NUMBER_DOTDOTDOT (([0-9]+)|(0[xX][0-9a-fA-F]+)|(0b[01]+))[uUlL]*[kMG]?[uUlL]*\.\.\.
FLOAT_NUMBER_DECIMAL ((([0-9]+\.[0-9]*)|(\.[0-9]+))([dD]|[fF]|[fF]16)?)
FLOAT_NUMBER_DECIMAL_DEPRECATED ([0-9]+[fF])
FLOAT_NUMBER_DECIMAL_ILLEGAL ([0-9]+([dD]|[fF]16))
FLOAT_NUMBER_SCIENTIFIC (([0-9]+|(([0-9]+\.[0-9]*)|(\.[0-9]+)))([eE][-+]?[0-9]+)([dD]|[fF]|[fF]16)?)
FLOAT_NUMBER_HEXADECIMAL (0[xX][01](\.[0-9a-fA-F]*)?[pP][-+]?[0-9]+([dD]|[fF]|[fF]16)?)
FORTRAN_DOUBLE_NUMBER (([0-9]+|(([0-9]+\.[0-9]*)|(\.[0-9]+)))([dD][-+]?[0-9]+))



IDENT [a-zA-Z_][a-zA-Z_0-9]*
INTRINSIC_CALL [@][l][l][v][m][.][.a-zA-Z_0-9]*
ZO_SWIZZLE ([01]+[w-z]+)+|([01]+[rgba]+)+|([01]+[uv]+)+

%%

[/][*](?s:.)*?[*][/]	skip()
"//"[^\n\r]*	skip()

"#pragma"	TOKEN_PRAGMA

__assert	TOKEN_ASSERT
bool	TOKEN_BOOL
break	TOKEN_BREAK
case	TOKEN_CASE
cbreak	TOKEN_BREAK
ccontinue	TOKEN_CONTINUE /*emit warning message*/
cdo	TOKEN_CDO
cfor	TOKEN_CFOR
cif	TOKEN_CIF
cwhile	TOKEN_CWHILE
const	TOKEN_CONST
continue	TOKEN_CONTINUE
creturn	TOKEN_RETURN /*emit warning message*/
__declspec	TOKEN_DECLSPEC
default	TOKEN_DEFAULT
do	TOKEN_DO
delete	TOKEN_DELETE
delete\[\]	TOKEN_DELETE
double	TOKEN_DOUBLE
else	TOKEN_ELSE
enum	TOKEN_ENUM
export	TOKEN_EXPORT
extern	TOKEN_EXTERN
false	TOKEN_FALSE
float	TOKEN_FLOAT
for	TOKEN_FOR
foreach	TOKEN_FOREACH
foreach_active	TOKEN_FOREACH_ACTIVE
foreach_tiled	TOKEN_FOREACH_TILED
foreach_unique	TOKEN_FOREACH_UNIQUE
float16	TOKEN_FLOAT16
goto	TOKEN_GOTO
if	TOKEN_IF
in	TOKEN_IN
inline	TOKEN_INLINE
noinline	TOKEN_NOINLINE
__vectorcall	TOKEN_VECTORCALL
__regcall	TOKEN_REGCALL
int	TOKEN_INT
uint	TOKEN_UINT
int8	TOKEN_INT8
uint8	TOKEN_UINT8
int16	TOKEN_INT16
uint16	TOKEN_UINT16
int32	TOKEN_INT
uint32	TOKEN_UINT
int64	TOKEN_INT64
uint64	TOKEN_UINT64
launch	TOKEN_LAUNCH
invoke_sycl	TOKEN_INVOKE_SYCL
new	TOKEN_NEW
NULL	TOKEN_NULL
print	TOKEN_PRINT
return	TOKEN_RETURN
soa	TOKEN_SOA
signed	TOKEN_SIGNED
sizeof	TOKEN_SIZEOF
alloca	TOKEN_ALLOCA
static	TOKEN_STATIC
struct	TOKEN_STRUCT
switch	TOKEN_SWITCH
sync	TOKEN_SYNC
task	TOKEN_TASK
template	TOKEN_TEMPLATE
true	TOKEN_TRUE
typedef	TOKEN_TYPEDEF
typename	TOKEN_TYPENAME
uniform	TOKEN_UNIFORM
unmasked	TOKEN_UNMASKED
unsigned	TOKEN_UNSIGNED
varying	TOKEN_VARYING
void	TOKEN_VOID
while	TOKEN_WHILE
\"C\"	TOKEN_STRING_C_LITERAL
\"SYCL\"	TOKEN_STRING_SYCL_LITERAL
\.\.\.	TOKEN_DOTDOTDOT

"operator*"	TOKEN_IDENTIFIER
"operator+"	TOKEN_IDENTIFIER
"operator-"	TOKEN_IDENTIFIER
"operator<<"	TOKEN_IDENTIFIER
"operator>>"	TOKEN_IDENTIFIER
"operator/"	TOKEN_IDENTIFIER
"operator%"	TOKEN_IDENTIFIER

L?\"(\\.|[^\"\n\r\\])*\"	TOKEN_STRING_LITERAL

/* Order matter if identifier comes before keywords they are classified as identifier */
{IDENT}	TOKEN_IDENTIFIER /*TOKEN_TYPE_NAME,TOKEN_TEMPLATE_NAME*/

{INTRINSIC_CALL}	TOKEN_INTRINSIC_CALL


{INT_NUMBER}	TOKEN_INT32_CONSTANT
{FLOAT_NUMBER_DECIMAL}|{FLOAT_NUMBER_SCIENTIFIC}	TOKEN_DOUBLE_CONSTANT

/*
{INT_NUMBER}
{INT_NUMBER_DOTDOTDOT}
{FORTRAN_DOUBLE_NUMBER}
{FLOAT_NUMBER_DECIMAL}|{FLOAT_NUMBER_SCIENTIFIC}
{FLOAT_NUMBER_DECIMAL_DEPRECATED}
{FLOAT_NUMBER_DECIMAL_ILLEGAL}
{FLOAT_NUMBER_HEXADECIMAL}
*/

"++"	TOKEN_INC_OP
"--"	TOKEN_DEC_OP
"<<"	TOKEN_LEFT_OP
">>"	TOKEN_RIGHT_OP
"<="	TOKEN_LE_OP
">="	TOKEN_GE_OP
"=="	TOKEN_EQ_OP
"!="	TOKEN_NE_OP
"&&"	TOKEN_AND_OP
"||"	TOKEN_OR_OP
"*="	TOKEN_MUL_ASSIGN
"/="	TOKEN_DIV_ASSIGN
"%="	TOKEN_MOD_ASSIGN
"+="	TOKEN_ADD_ASSIGN
"-="	TOKEN_SUB_ASSIGN
"<<="	TOKEN_LEFT_ASSIGN
">>="	TOKEN_RIGHT_ASSIGN
"&="	TOKEN_AND_ASSIGN
"^="	TOKEN_XOR_ASSIGN
"|="	TOKEN_OR_ASSIGN
"->"	TOKEN_PTR_OP
";"            	';'
("{"|"<%")     	'{'
("}"|"%>")     	'}'
","            	','
":"            	':'
"="            	'='
"("            	'('
")"            	')'
("["|"<:")     	'['
("]"|":>")     	']'
"."            	'.'
"&"            	'&'
"!"            	'!'
"~"            	'~'
"-"            	'-'
"+"            	'+'
"*"            	'*'
"/"            	'/'
"%"            	'%'
"<"            	'<'
">"            	'>'
"^"            	'^'
"|"            	'|'
"?"            	'?'

{WHITESPACE}	skip()

\n	skip()

#(line)?[ ][0-9]+[ ]\"(\\.|[^\\"])*\"[^\n]*	skip()

.	ILLEGAL_CHARACTER

%%