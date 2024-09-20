//From: https://github.com/petergtz/c2c-err-transpiler/blob/e005f0770ca0cb783821da8fbbe477fdd2b67d70/c2c.ypp

/*Tokens*/
%token ADD_ASSIGN
%token AND_ASSIGN
%token AND_OP
%token AUTO
%token BOOL
%token BREAK
%token CAN_FAIL
%token CASE
%token CHAR
%token COMPLEX
%token CONST
%token CONSTANT
%token CONTINUE
%token DEC_OP
%token DEFAULT
%token DIV_ASSIGN
%token DO
%token DOUBLE
%token ELLIPSIS
%token ELSE
%token ENUM
%token EQ_OP
%token EXTERN
%token FAILS_WITH
%token FAIL_WITH
%token FLOAT
%token FOR
%token GE_OP
%token GOTO
%token IDENTIFIER
%token IF
%token IMAGINARY
%token INC_OP
%token INLINE
%token INT
%token LEFT_ASSIGN
%token LEFT_OP
%token LE_OP
%token LONG
%token MOD_ASSIGN
%token MUL_ASSIGN
%token NE_OP
%token OR_ASSIGN
%token OR_ON_ERROR
%token OR_OP
%token PTR_OP
%token REGISTER
%token RESTRICT
%token RETURN
%token RIGHT_ASSIGN
%token RIGHT_OP
%token SHORT
%token SIGNED
%token SIZEOF
%token STATIC
%token STRING_LITERAL
%token STRUCT
%token SUB_ASSIGN
%token SWITCH
%token TYPEDEF
%token TYPE_NAME
%token UNION
%token UNSIGNED
%token VOID
%token VOLATILE
%token WHILE
%token XOR_ASSIGN


%start translation_unit

%%

primary_expression :
	IDENTIFIER
	| CONSTANT
	| STRING_LITERAL
	| '(' expression ')'
	;

postfix_expression :
	primary_expression
	| postfix_expression '[' expression ']'
	| postfix_expression '(' ')'
	| postfix_expression '(' argument_expression_list ')'
	| postfix_expression '.' IDENTIFIER
	| postfix_expression PTR_OP IDENTIFIER
	| postfix_expression INC_OP
	| postfix_expression DEC_OP
	| '(' type_name ')' '{' initializer_list '}'
	| '(' type_name ')' '{' initializer_list ',' '}'
	;

argument_expression_list :
	assignment_expression
	| argument_expression_list ',' assignment_expression
	;

unary_expression :
	postfix_expression
	| INC_OP unary_expression
	| DEC_OP unary_expression
	| unary_operator cast_expression
	| SIZEOF unary_expression
	| SIZEOF '(' type_name ')'
	;

unary_operator :
	'&'
	| '*'
	| '+'
	| '-'
	| '~'
	| '!'
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
	| shift_expression LEFT_OP additive_expression
	| shift_expression RIGHT_OP additive_expression
	;

relational_expression :
	shift_expression
	| relational_expression '<' shift_expression
	| relational_expression '>' shift_expression
	| relational_expression LE_OP shift_expression
	| relational_expression GE_OP shift_expression
	;

equality_expression :
	relational_expression
	| equality_expression EQ_OP relational_expression
	| equality_expression NE_OP relational_expression
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
	| logical_and_expression AND_OP inclusive_or_expression
	;

logical_or_expression :
	logical_and_expression
	| logical_or_expression OR_OP logical_and_expression
	;

conditional_expression :
	logical_or_expression
	| logical_or_expression '?' expression ':' conditional_expression
	;

assignment_expression :
	conditional_expression
	| unary_expression assignment_operator assignment_expression
	;

assignment_operator :
	'='
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
	| LEFT_ASSIGN
	| RIGHT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

expression :
	assignment_expression
	| expression ',' assignment_expression
	;

constant_expression :
	conditional_expression
	;

declaration :
	declaration_specifiers ';'
	| declaration_specifiers init_declarator_list ';'
	| declaration_specifiers function_declarator fail_specifier ';'
	;

function_declarator :
	direct_function_declarator
	| pointer direct_function_declarator
	;

direct_function_declarator :
	direct_declarator '(' ')'
	| direct_declarator '(' parameter_type_list ')'
	;

fail_specifier :
	CAN_FAIL
	| FAILS_WITH IDENTIFIER
	;

declaration_specifiers :
	storage_class_specifier
	| storage_class_specifier declaration_specifiers
	| type_specifier
	| type_specifier declaration_specifiers
	| type_qualifier
	| type_qualifier declaration_specifiers
	| function_specifier
	| function_specifier declaration_specifiers
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
	TYPEDEF
	| EXTERN
	| STATIC
	| AUTO
	| REGISTER
	;

type_specifier :
	VOID
	| CHAR
	| SHORT
	| INT
	| LONG
	| FLOAT
	| DOUBLE
	| SIGNED
	| UNSIGNED
	| BOOL
	| COMPLEX
	| IMAGINARY
	| struct_or_union_specifier
	| enum_specifier
	| TYPE_NAME
	;

struct_or_union_specifier :
	struct_or_union IDENTIFIER '{' struct_declaration_list '}'
	| struct_or_union '{' struct_declaration_list '}'
	| struct_or_union IDENTIFIER
	;

struct_or_union :
	STRUCT
	| UNION
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
	| type_qualifier specifier_qualifier_list
	| type_qualifier
	;

struct_declarator_list :
	struct_declarator
	| struct_declarator_list ',' struct_declarator
	;

struct_declarator :
	declarator
	| ':' constant_expression
	| declarator ':' constant_expression
	;

enum_specifier :
	ENUM '{' enumerator_list '}'
	| ENUM IDENTIFIER '{' enumerator_list '}'
	| ENUM '{' enumerator_list ',' '}'
	| ENUM IDENTIFIER '{' enumerator_list ',' '}'
	| ENUM IDENTIFIER
	;

enumerator_list :
	enumerator
	| enumerator_list ',' enumerator
	;

enumerator :
	IDENTIFIER
	| IDENTIFIER '=' constant_expression
	;

type_qualifier :
	CONST
	| RESTRICT
	| VOLATILE
	;

function_specifier :
	INLINE
	;

declarator :
	pointer direct_declarator
	| direct_declarator
	;

direct_declarator :
	IDENTIFIER
	| '(' declarator ')'
	| direct_declarator '[' type_qualifier_list assignment_expression ']'
	| direct_declarator '[' type_qualifier_list ']'
	| direct_declarator '[' assignment_expression ']'
	| direct_declarator '[' STATIC type_qualifier_list assignment_expression ']'
	| direct_declarator '[' type_qualifier_list STATIC assignment_expression ']'
	| direct_declarator '[' type_qualifier_list '*' ']'
	| direct_declarator '[' '*' ']'
	| direct_declarator '[' ']'
	| direct_declarator '(' identifier_list ')'
	| direct_function_declarator
	;

pointer :
	'*'
	| '*' type_qualifier_list
	| '*' pointer
	| '*' type_qualifier_list pointer
	;

type_qualifier_list :
	type_qualifier
	| type_qualifier_list type_qualifier
	;

parameter_type_list :
	parameter_list
	| parameter_list ',' ELLIPSIS
	;

parameter_list :
	parameter_declaration
	| parameter_list ',' parameter_declaration
	;

parameter_declaration :
	declaration_specifiers declarator
	| declaration_specifiers abstract_declarator
	| declaration_specifiers
	;

identifier_list :
	IDENTIFIER
	| identifier_list ',' IDENTIFIER
	;

type_name :
	specifier_qualifier_list
	| specifier_qualifier_list abstract_declarator
	;

abstract_declarator :
	pointer
	| direct_abstract_declarator
	| pointer direct_abstract_declarator
	;

direct_abstract_declarator :
	'(' abstract_declarator ')'
	| '[' ']'
	| '[' assignment_expression ']'
	| direct_abstract_declarator '[' ']'
	| direct_abstract_declarator '[' assignment_expression ']'
	| '[' '*' ']'
	| direct_abstract_declarator '[' '*' ']'
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
	| designation initializer
	| initializer_list ',' initializer
	| initializer_list ',' designation initializer
	;

designation :
	designator_list '='
	;

designator_list :
	designator
	| designator_list designator
	;

designator :
	'[' constant_expression ']'
	| '.' IDENTIFIER
	;

statement :
	labeled_statement
	| compound_statement
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	;

labeled_statement :
	IDENTIFIER ':' statement
	| CASE constant_expression ':' statement
	| DEFAULT ':' statement
	;

compound_statement :
	'{' '}'
	| '{' block_item_list '}'
	;

block_item_list :
	block_item
	| block_item_list block_item
	;

block_item :
	declaration
	| statement
	;

expression_statement :
	';'
	| expression ';'
	| expression OR_ON_ERROR assignment_expression
	| expression OR_ON_ERROR jump
	| expression OR_ON_ERROR compound_statement
	;

selection_statement :
	IF '(' expression ')' statement
	| IF '(' expression ')' statement ELSE statement
	| SWITCH '(' expression ')' statement
	;

iteration_statement :
	WHILE '(' expression ')' statement
	| DO statement WHILE '(' expression ')' ';'
	| FOR '(' expression_statement expression_statement ')' statement
	| FOR '(' expression_statement expression_statement expression ')' statement
	| FOR '(' declaration expression_statement ')' statement
	| FOR '(' declaration expression_statement expression ')' statement
	;

jump_statement :
	jump ';'
	;

jump :
	GOTO IDENTIFIER
	| CONTINUE
	| BREAK
	| RETURN
	| RETURN expression
	| FAIL_WITH expression
	;

translation_unit :
	external_declaration
	| translation_unit external_declaration
	;

external_declaration :
	function_definition
	| declaration
	;

function_definition :
	declaration_specifiers declarator compound_statement
	| declaration_specifiers function_declarator fail_specifier compound_statement
	;

%%

D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
P           [Pp][+-]?{D}+
FS			(f|F|l|L)
IS          ((u|U)|(u|U)?(l|L|ll|LL)|(l|L|ll|LL)(u|U))

%%

[ \t\v\f\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"can_fail"      CAN_FAIL
"fails_with"    FAILS_WITH
"fail_with"    FAIL_WITH


"auto"			AUTO
"_Bool"			BOOL
"break"			BREAK
"case"			CASE
"char"			CHAR
"_Complex"		COMPLEX
"const"			CONST
"continue"		CONTINUE
"default"		DEFAULT
"do"			DO
"double"		DOUBLE
"else"			ELSE
"enum"			ENUM
"extern"		EXTERN
"float"			FLOAT
"for"			FOR
"goto"			GOTO
"if"			IF
"_Imaginary"	IMAGINARY
"inline"		INLINE
"int"			INT
"long"			LONG
"or_on_error"   OR_ON_ERROR
"register"		REGISTER
"restrict"		RESTRICT
"return"		RETURN
"short"			SHORT
"signed"		SIGNED
"sizeof"		SIZEOF
"static"		STATIC
"struct"		STRUCT
"switch"		SWITCH
"typedef"		TYPEDEF
"union"			UNION
"unsigned"		UNSIGNED
"void"			VOID
"volatile"		VOLATILE
"while"			WHILE

TYPE_NAME	TYPE_NAME
{L}({L}|{D})*	IDENTIFIER //check_type()

0[xX]{H}+{IS}?	CONSTANT
0{D}+{IS}?		CONSTANT
{D}+{IS}?		CONSTANT
L?'(\\.|[^\\'\n])+'	CONSTANT

{D}+{E}{FS}?		            CONSTANT
{D}*"."{D}+({E})?{FS}?	        CONSTANT
{D}+"."{D}*({E})?{FS}?	        CONSTANT
0[xX]{H}+{P}{FS}?               CONSTANT
0[xX]{H}*"."{H}+({P})?{FS}?     CONSTANT
0[xX]{H}+"."{H}*({P})?{FS}?     CONSTANT


L?\"(\\.|[^\\"\n\r])*\"	STRING_LITERAL

"..."			ELLIPSIS
">>="			RIGHT_ASSIGN
"<<="			LEFT_ASSIGN
"+="			ADD_ASSIGN
"-="			SUB_ASSIGN
"*="			MUL_ASSIGN
"/="			DIV_ASSIGN
"%="			MOD_ASSIGN
"&="			AND_ASSIGN
"^="			XOR_ASSIGN
"|="			OR_ASSIGN
">>"			RIGHT_OP
"<<"			LEFT_OP
"++"			INC_OP
"--"			DEC_OP
"->"			PTR_OP
"&&"			AND_OP
"||"			OR_OP
"<="			LE_OP
">="			GE_OP
"=="			EQ_OP
"!="			NE_OP
";"			';'
("{"|"<%")		'{'
("}"|"%>")		'}'
","			','
":"			':'
"="			'='
"("			'('
")"			')'
("["|"<:")		'['
("]"|":>")		']'
"."			'.'
"&"			'&'
"!"			'!'
"~"			'~'
"-"			'-'
"+"			'+'
"*"			'*'
"/"			'/'
"%"			'%'
"<"			'<'
">"			'>'
"^"			'^'
"|"			'|'
"?"			'?'

%%
