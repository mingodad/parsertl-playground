//From: https://github.com/praeclarum/CLanguage/blob/b6761465e28016d56d5080d139071817373b9351/CLanguage/Parser/CParser.jay
///    The C Parser
///    http://www.quut.com/c/ANSI-C-grammar-y.html

/*Tokens*/
%token IDENTIFIER
%token CONSTANT
%token STRING_LITERAL
%token SIZEOF
%token PTR_OP
%token INC_OP
%token DEC_OP
%token LEFT_OP
%token RIGHT_OP
%token LE_OP
%token GE_OP
%token EQ_OP
%token NE_OP
%token COLONCOLON
%token AND_OP
%token OR_OP
%token MUL_ASSIGN
%token DIV_ASSIGN
%token MOD_ASSIGN
%token ADD_ASSIGN
%token SUB_ASSIGN
%token LEFT_ASSIGN
%token RIGHT_ASSIGN
%token BINARY_AND_ASSIGN
%token BINARY_XOR_ASSIGN
%token BINARY_OR_ASSIGN
%token AND_ASSIGN
%token OR_ASSIGN
%token TYPE_NAME
%token PUBLIC
%token PRIVATE
%token PROTECTED
%token TYPEDEF
%token EXTERN
%token STATIC
%token AUTO
%token REGISTER
%token INLINE
%token RESTRICT
%token CHAR
%token SHORT
%token INT
%token LONG
%token SIGNED
%token UNSIGNED
%token FLOAT
%token DOUBLE
%token CONST
%token VOLATILE
%token VOID
%token BOOL
%token COMPLEX
%token IMAGINARY
%token TRUE
%token FALSE
%token STRUCT
%token CLASS
%token UNION
%token ENUM
%token ELLIPSIS
%token CASE
%token DEFAULT
%token IF
%token ELSE
%token SWITCH
%token WHILE
%token DO
%token FOR
%token GOTO
%token CONTINUE
%token BREAK
%token RETURN
//%token EOL
%token '('
%token ')'
%token '['
%token ']'
%token '.'
%token '{'
%token '}'
%token ','
%token '&'
%token '*'
%token '+'
%token '-'
%token '~'
%token '!'
%token '/'
%token '%'
%token '<'
%token '>'
%token '^'
%token '|'
%token '?'
%token ':'
%token '='
%token ';'
%token '#'
%token '\\'


%start translation_unit

%%

primary_expression :
	IDENTIFIER
	| CONSTANT
	| STRING_LITERAL
	| TRUE
	| FALSE
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
	| '&' cast_expression
	| '*' cast_expression
	| unary_operator cast_expression
	| SIZEOF unary_expression
	| SIZEOF '(' type_name ')'
	;

unary_operator :
	'+'
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
	| BINARY_AND_ASSIGN
	| BINARY_XOR_ASSIGN
	| BINARY_OR_ASSIGN
	| AND_ASSIGN
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
	;

declaration_specifiers :
	storage_class_specifier
	| declaration_specifiers storage_class_specifier
	| type_specifier
	| declaration_specifiers type_specifier
	| type_qualifier
	| declaration_specifiers type_qualifier
	| function_specifier
	| declaration_specifiers function_specifier
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
	| struct_or_union_or_class_specifier
	| enum_specifier
	| TYPE_NAME
	;

identifier_or_typename :
	IDENTIFIER
	| TYPE_NAME
	;

struct_or_union_or_class_specifier :
	struct_or_union_or_class identifier_or_typename class_body
	| struct_or_union_or_class class_body
	| struct_or_union_or_class identifier_or_typename
	;

struct_or_union_or_class :
	STRUCT
	| CLASS
	| UNION
	;

specifier_qualifier_list :
	type_specifier specifier_qualifier_list
	| type_specifier
	| type_qualifier specifier_qualifier_list
	| type_qualifier
	;

enum_specifier :
	ENUM '{' enumerator_list '}'
	| ENUM identifier_or_typename '{' enumerator_list '}'
	| ENUM '{' enumerator_list ',' '}'
	| ENUM identifier_or_typename '{' enumerator_list ',' '}'
	| ENUM identifier_or_typename
	;

enumerator_list :
	enumerator
	| enumerator_list ',' enumerator
	;

enumerator :
	IDENTIFIER
	| IDENTIFIER '=' constant_expression
	;

function_specifier :
	INLINE
	;

declarator :
	pointer direct_declarator
	| direct_declarator
	;

direct_declarator_identifier_list :
	IDENTIFIER
	| '~' IDENTIFIER
	| direct_declarator_identifier_list COLONCOLON IDENTIFIER
	| direct_declarator_identifier_list COLONCOLON '~' IDENTIFIER
	;

direct_declarator :
	direct_declarator_identifier_list
	| '(' declarator ')'
	| direct_declarator '[' type_qualifier_list assignment_expression ']'
	| direct_declarator '[' type_qualifier_list ']'
	| direct_declarator '[' assignment_expression ']'
	| direct_declarator '[' STATIC type_qualifier_list assignment_expression ']'
	| direct_declarator '[' type_qualifier_list STATIC assignment_expression ']'
	| direct_declarator '[' type_qualifier_list '*' ']'
	| direct_declarator '[' '*' ']'
	| direct_declarator '[' ']'
	| direct_declarator '(' parameter_type_list ')'
	| direct_declarator '(' argument_expression_list ')'
	| direct_declarator '(' ')'
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

type_qualifier :
	CONST
	| RESTRICT
	| VOLATILE
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
	| declaration_specifiers declarator '=' assignment_expression
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

class_body :
	'{' '}'
	| '{' class_block_item_list '}'
	;

class_block_item_list :
	class_block_item
	| class_block_item_list class_block_item
	;

class_block_item :
	declaration
	| visibility
	| ctor_declaration
	;

visibility :
	PUBLIC ':'
	| PRIVATE ':'
	| PROTECTED ':'
	;

ctor_declarator :
	direct_declarator_identifier_list '(' parameter_type_list ')'
	| direct_declarator_identifier_list '(' ')'
	;

ctor_declaration :
	ctor_declarator ';'
	;

expression_statement :
	';'
	| expression ';'
	;

selection_statement :
	IF '(' expression ')' statement
	| IF '(' expression ')' statement ELSE statement
	| SWITCH '(' expression ')' '{' switch_cases '}'
	| SWITCH '(' expression ')' '{' '}'
	;

switch_cases :
	switch_case
	| switch_cases switch_case
	;

switch_case :
	CASE constant_expression ':' block_item_list
	| DEFAULT ':' block_item_list
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
	GOTO IDENTIFIER ';'
	| CONTINUE ';'
	| BREAK ';'
	| RETURN ';'
	| RETURN expression ';'
	;

translation_unit :
	external_declaration
	| translation_unit external_declaration
	;

external_declaration :
	function_definition
	| declaration
	| ';'
	| ctor_definition
	;

function_definition :
	declaration_specifiers declarator declaration_list compound_statement
	| declaration_specifiers declarator compound_statement
	;

ctor_identifier_list :
	TYPE_NAME
	| ctor_identifier_list COLONCOLON TYPE_NAME
	| ctor_identifier_list COLONCOLON '~' TYPE_NAME
	;

ctor_definition :
	ctor_identifier_list '(' ')' compound_statement
	| ctor_identifier_list '(' parameter_type_list ')' compound_statement
	;

declaration_list :
	declaration
	| preproc declaration
	| declaration_list declaration
	;

preproc :
	/*EOL
	|*/ '#'
	| '\\'
	;

%%

%%

[\n\r\t ]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"auto"	AUTO
"bool"	BOOL
"break"	BREAK
"case"	CASE
"char"	CHAR
"class"	CLASS
"const"	CONST
"continue"	CONTINUE
"default"	DEFAULT
"do"	DO
"double"	DOUBLE
"else"	ELSE
"enum"	ENUM
"extern"	EXTERN
"false"	FALSE
"float"	FLOAT
"for"	FOR
"goto"	GOTO
"if"	IF
"inline"	INLINE
"int"	INT
"long"	LONG
"public"	PUBLIC
"private"	PRIVATE
"protected"	PROTECTED
"register"	REGISTER
"restrict"	RESTRICT
"return"	RETURN
"short"	SHORT
"signed"	SIGNED
"sizeof"	SIZEOF
"static"	STATIC
"struct"	STRUCT
"switch"	SWITCH
"true"	TRUE
"typedef"	TYPEDEF
"union"	UNION
"unsigned"	UNSIGNED
"void"	VOID
"volatile"	VOLATILE
"while"	WHILE

"+="	ADD_ASSIGN
"&="	AND_ASSIGN
"&&"	AND_OP
"&="	BINARY_AND_ASSIGN
"|="	BINARY_OR_ASSIGN
"^="	BINARY_XOR_ASSIGN
"::"	COLONCOLON
COMPLEX	COMPLEX
"--"	DEC_OP
"/="	DIV_ASSIGN
"..."	ELLIPSIS
//\n	EOL
"=="	EQ_OP
">="	GE_OP
IMAGINARY	IMAGINARY
"++"	INC_OP
"<<="	LEFT_ASSIGN
"<<"	LEFT_OP
"<="	LE_OP
"%="	MOD_ASSIGN
"*="	MUL_ASSIGN
"!="	NE_OP
"||="	OR_ASSIGN
"||"	OR_OP
"->"	PTR_OP
">>="	RIGHT_ASSIGN
">>"	RIGHT_OP
"-="	SUB_ASSIGN

"("	'('
")"	')'
"["	'['
"]"	']'
"."	'.'
"{"	'{'
"}"	'}'
","	','
"&"	'&'
"*"	'*'
"+"	'+'
"-"	'-'
"~"	'~'
"!"	'!'
"/"	'/'
"%"	'%'
"<"	'<'
">"	'>'
"^"	'^'
"|"	'|'
"?"	'?'
":"	':'
"="	'='
";"	';'
"#"	'#'
"\\"	'\\'

[0-9]+	CONSTANT
[0-9]+"."[0-9]+	CONSTANT
'(\\.|[^'\n\r\\])+'	CONSTANT
\"(\\.|[^"\n\r\\])*\"	STRING_LITERAL

TYPE_NAME	TYPE_NAME
[A-Za-z_][A-Za-z0-9_]*	IDENTIFIER

%%
