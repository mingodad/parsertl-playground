//From: https://github.com/ecere/ecere-sdk/blob/latest/compiler/libec/src/grammar.y

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
%token AND_OP
%token OR_OP
%token MUL_ASSIGN
%token DIV_ASSIGN
%token MOD_ASSIGN
%token ADD_ASSIGN
%token SUB_ASSIGN
%token LEFT_ASSIGN
%token RIGHT_ASSIGN
%token AND_ASSIGN
%token XOR_ASSIGN
%token OR_ASSIGN
%token TYPE_NAME
%token TYPEDEF
%token EXTERN
%token STATIC
%token AUTO
%token REGISTER
%token CHAR
%token SHORT
%token INT
%token UINT
%token INT64
%token INT128
%token FLOAT128
%token FLOAT16
%token LONG
%token SIGNED
%token UNSIGNED
%token FLOAT
%token DOUBLE
%token CONST
%token VOLATILE
%token VOID
%token VALIST
%token STRUCT
%token UNION
%token ENUM
%token ELLIPSIS
%token CASE
%token DEFAULT
%token IF
%token SWITCH
%token WHILE
%token DO
%token FOR
%token GOTO
%token CONTINUE
%token BREAK
%token RETURN
%token IFX
%token ELSE
%token CLASS
%token THISCLASS
%token PROPERTY
%token SETPROP
%token GETPROP
%token NEWOP
%token RENEW
%token DELETE
%token EXT_DECL
%token EXT_STORAGE
%token IMPORT
%token DEFINE
%token VIRTUAL
%token ATTRIB
%token PUBLIC
%token PRIVATE
%token TYPED_OBJECT
%token ANY_OBJECT
%token _INCREF
%token EXTENSION
%token ASM
%token TYPEOF
%token WATCH
%token STOPWATCHING
%token FIREWATCHERS
%token WATCHABLE
%token CLASS_DESIGNER
%token CLASS_NO_EXPANSION
%token CLASS_FIXED
%token ISPROPSET
%token CLASS_DEFAULT_PROPERTY
%token PROPERTY_CATEGORY
%token CLASS_DATA
%token CLASS_PROPERTY
%token SUBCLASS
%token NAMESPACE
%token NEW0OP
%token RENEW0
%token VAARG
%token DBTABLE
%token DBFIELD
%token DBINDEX
%token DATABASE_OPEN
%token ALIGNOF
%token ATTRIB_DEP
%token __ATTRIB
%token BOOL
%token _BOOL
%token _COMPLEX
%token _IMAGINARY
%token RESTRICT
%token THREAD
%token WIDE_STRING_LITERAL
%token BUILTIN_OFFSETOF
%token PRAGMA
%token STATIC_ASSERT
%token '*'
%token '<'
%token '>'
%token '('
%token ')'
%token '~'
%token ';'
%token '='
%token ','
%token '}'
%token '{'
%token '.'
%token ':'
%token '$'
%token '['
%token ']'
%token '&'
%token '+'
%token '-'
%token '!'
%token '/'
%token '%'
%token '^'
%token '|'
%token '?'

%token ILLEGAL_CHARACTHER

%nonassoc /*1*/ IFX
%nonassoc /*2*/ ELSE

%start thefile

%%

guess_type :
	identifier '*'
	| identifier '<'
	;

type :
	strict_type
	| identifier identifier
	;

base_strict_type :
	TYPE_NAME
	;

base_strict_type_name :
	TYPE_NAME
	;

strict_type :
	base_strict_type
	| base_strict_type '<' template_arguments_list '>'
	| base_strict_type '<' template_arguments_list RIGHT_OP
	;

class_function_definition_start :
	guess_declaration_specifiers declarator_function_type_ok
	| declarator_function
	;

constructor_function_definition_start :
	guess_declaration_specifiers '(' ')'
	;

destructor_function_definition_start :
	'~' guess_declaration_specifiers '(' ')'
	;

virtual_class_function_definition_start :
	VIRTUAL guess_declaration_specifiers declarator_function_type_ok
	| VIRTUAL declarator_function
	;

class_function_definition_start_error :
	guess_declaration_specifiers declarator_function_error_type_ok
	| declarator_function_error
	;

virtual_class_function_definition_start_error :
	VIRTUAL guess_declaration_specifiers declarator_function_error_type_ok
	| VIRTUAL declarator_function_error
	;

class_function_definition :
	class_function_definition_start compound_statement
	| virtual_class_function_definition_start compound_statement
	| virtual_class_function_definition_start ';'
	| constructor_function_definition_start compound_statement
	| destructor_function_definition_start compound_statement
	| class_function_definition_start ';'
	| class_function_definition_start attrib ';'
	;

class_function_definition_error :
	class_function_definition_start compound_statement_error
	| class_function_definition_start_error
	| virtual_class_function_definition_start compound_statement_error
	| virtual_class_function_definition_start_error
	| virtual_class_function_definition_start_error ';'
	;

instance_class_function_definition_start :
	declaration_specifiers declarator_function_type_ok
	| declaration_specifiers declarator_nofunction_type_ok
	;

instance_class_function_definition_start_error :
	declaration_specifiers declarator_function_error_type_ok
	;

instance_class_function_definition :
	instance_class_function_definition_start compound_statement
	;

instance_class_function_definition_error :
	instance_class_function_definition_start compound_statement_error
	| instance_class_function_definition_start_error
	| instance_class_function_definition_start
	;

data_member_initialization :
	postfix_expression '=' initializer_condition
	| initializer_condition
	;

data_member_initialization_error :
	postfix_expression '=' initializer_condition_error
	//| postfix_expression '=' error
	| initializer_condition_error
	;

data_member_initialization_list :
	data_member_initialization
	| data_member_initialization_list ',' data_member_initialization
	| data_member_initialization_list_error ',' data_member_initialization
	;

data_member_initialization_list_error :
	data_member_initialization_error
	| data_member_initialization_list ',' data_member_initialization_error
	| data_member_initialization_list_error ',' data_member_initialization_error
	//| data_member_initialization_list ',' error
	//| data_member_initialization_list_error ',' error
	| ','
	;

data_member_initialization_list_coloned :
	data_member_initialization_list ';'
	| data_member_initialization_list_error ';'
	;

members_initialization_list_coloned :
	data_member_initialization_list_coloned
	| instance_class_function_definition
	| members_initialization_list_error data_member_initialization_list_coloned
	| members_initialization_list_error instance_class_function_definition
	| members_initialization_list_coloned data_member_initialization_list_coloned
	| members_initialization_list_coloned instance_class_function_definition
	//| members_initialization_list_error ';'
	| members_initialization_list_coloned ';'
	| ';'
	;

members_initialization_list :
	members_initialization_list_coloned
	| data_member_initialization_list
	| members_initialization_list_coloned data_member_initialization_list
	| members_initialization_list_error data_member_initialization_list
	;

members_initialization_list_error :
	instance_class_function_definition_error
	| members_initialization_list instance_class_function_definition_error
	| members_initialization_list_error instance_class_function_definition_error
	| members_initialization_list_coloned instance_class_function_definition_error
	| members_initialization_list_coloned data_member_initialization_list_error
	| data_member_initialization_list_error
	//| data_member_initialization_list error
	;

instantiation_named :
	instantiation_named_error '}'
	//| instantiation_named_error error '}'
	;

instantiation_named_error :
	declaration_specifiers identifier '{' members_initialization_list_error
	//| declaration_specifiers identifier '{' members_initialization_list error
	| declaration_specifiers identifier '{' members_initialization_list
	| declaration_specifiers identifier '{'
	//| declaration_specifiers identifier '{' error
	;

guess_instantiation_named :
	guess_instantiation_named_error '}'
	//| guess_instantiation_named_error error '}'
	;

guess_instantiation_named_error :
	guess_declaration_specifiers identifier '{' members_initialization_list_error
	//| guess_declaration_specifiers identifier '{' members_initialization_list error
	| guess_declaration_specifiers identifier '{' members_initialization_list
	| guess_declaration_specifiers identifier '{'
	//| guess_declaration_specifiers identifier '{' error
	;

external_guess_instantiation_named :
	external_guess_declaration_specifiers identifier '{' members_initialization_list '}'
	| external_guess_declaration_specifiers identifier '{' members_initialization_list_error '}'
	| external_guess_declaration_specifiers identifier '{' '}'
	;

instantiation_unnamed :
	instantiation_unnamed_error '}'
	//| instantiation_unnamed_error error '}'
	;

instantiation_unnamed_error :
	strict_type '{' members_initialization_list
	| identifier '{' members_initialization_list
	| strict_type '{' members_initialization_list_error
	| strict_type '{'
	//| strict_type '{' members_initialization_list error
	//| strict_type '{' error
	| identifier '{' members_initialization_list_error
	| identifier '{'
	//| identifier '{' members_initialization_list error
	//| identifier '{' error
	;

instantiation_anon :
	instantiation_anon_error '}'
	//| instantiation_anon_error error '}'
	;

instantiation_anon_error :
	'{' members_initialization_list_error
	//| '{' members_initialization_list error
	//| '{' error
	| '{'
	| '{' members_initialization_list
	;

default_property :
	postfix_expression '=' initializer_condition
	;

default_property_error :
	postfix_expression '=' initializer_condition_error
	//| postfix_expression '=' error
	//| postfix_expression error
	;

default_property_list :
	default_property
	| default_property_list ',' default_property
	| default_property_list_error ',' default_property
	;

default_property_list_error :
	default_property_error
	| default_property_list ',' default_property_error
	| default_property_list_error ',' default_property_error
	//| default_property_list error
	;

property_start :
	PROPERTY property_specifiers identifier '{'
	| PROPERTY property_specifiers abstract_declarator identifier '{'
	| PROPERTY property_specifiers '{'
	| PROPERTY property_specifiers abstract_declarator '{'
	//| PROPERTY error '{'
	;

property_body :
	property_start
	| property_body SETPROP compound_statement
	| property_body GETPROP compound_statement
	| property_body ISPROPSET compound_statement
	| property_body WATCHABLE
	| property_body PROPERTY_CATEGORY i18n_string
	;

property :
	property_body '}'
	;

class_property_start :
	CLASS_PROPERTY property_specifiers identifier '{'
	| CLASS_PROPERTY property_specifiers abstract_declarator identifier '{'
	| CLASS_PROPERTY property_specifiers '{'
	| CLASS_PROPERTY property_specifiers abstract_declarator '{'
	//| CLASS_PROPERTY error '{'
	;

class_property_body :
	class_property_start
	| class_property_body SETPROP compound_statement
	| class_property_body GETPROP compound_statement
	;

class_property :
	class_property_body '}'
	;

watch_property_list :
	identifier
	| watch_property_list identifier
	;

property_watch :
	watch_property_list compound_statement
	| DELETE compound_statement
	;

property_watch_list :
	property_watch
	| property_watch_list property_watch
	;

self_watch_definition :
	WATCH '(' watch_property_list ')' compound_statement
	;

watch_definition :
	WATCH '(' assignment_expression ')' '{' property_watch_list '}'
	| assignment_expression '.' WATCH '(' assignment_expression ')' '{' property_watch_list '}'
	;

stopwatching :
	STOPWATCHING '(' assignment_expression ',' watch_property_list ')'
	| assignment_expression '.' STOPWATCHING '(' assignment_expression ',' watch_property_list ')'
	| STOPWATCHING '(' assignment_expression ')'
	| assignment_expression '.' STOPWATCHING '(' assignment_expression ')'
	;

firewatchers :
	FIREWATCHERS
	| FIREWATCHERS watch_property_list
	| postfix_expression '.' FIREWATCHERS
	| assignment_expression '.' FIREWATCHERS watch_property_list
	;

struct_declaration :
	struct_declaration_error ';'
	| default_property_list ';'
	| class_function_definition
	| property
	| member_access class_function_definition
	| member_access property
	| class_property
	| WATCHABLE
	| CLASS_NO_EXPANSION
	| CLASS_FIXED
	| CLASS_PROPERTY '(' identifier ')' '=' initializer_condition ';'
	| ';'
	| member_access ':'
	| member_access '(' identifier ')'
	;

struct_declaration_error :
	class_function_definition_error
	| guess_declaration_specifiers
	| guess_declaration_specifiers struct_declarator_list
	| member_access guess_declaration_specifiers struct_declarator_list
	| member_access guess_declaration_specifiers
	| member_access instantiation_unnamed
	| member_access guess_instantiation_named
	| CLASS_DATA guess_declaration_specifiers struct_declarator_list
	| self_watch_definition
	| CLASS_DESIGNER identifier
	| CLASS_DESIGNER strict_type
	| CLASS_DEFAULT_PROPERTY identifier
	| instantiation_unnamed
	| guess_instantiation_named
	| default_property_list
	//| guess_instantiation_named_error error
	//| instantiation_unnamed_error error
	| member_access class_function_definition_error
	//| member_access guess_instantiation_named_error error
	//| member_access instantiation_unnamed_error error
	| default_property_list_error
	;

struct_declaration_list :
	struct_declaration
	| struct_declaration_list struct_declaration
	| struct_declaration_list_error struct_declaration
	;

struct_declaration_list_error :
	struct_declaration_error
	//| struct_declaration_list error
	//| struct_declaration_list_error error
	| struct_declaration_list struct_declaration_error
	| struct_declaration_list_error struct_declaration_error
	;

template_datatype :
	guess_declaration_specifiers
	| guess_declaration_specifiers abstract_declarator
	;

template_type_argument :
	guess_declaration_specifiers
	| guess_declaration_specifiers abstract_declarator
	;

template_type_parameter :
	CLASS identifier
	| CLASS identifier '=' template_type_argument
	| CLASS identifier ':' template_datatype
	| CLASS identifier ':' template_datatype '=' template_type_argument
	| CLASS base_strict_type_name
	| CLASS base_strict_type_name '=' template_type_argument
	| CLASS base_strict_type_name ':' template_datatype
	| CLASS base_strict_type_name ':' template_datatype '=' template_type_argument
	;

template_identifier_argument :
	identifier
	;

template_identifier_parameter :
	identifier
	| identifier '=' template_identifier_argument
	;

template_expression_argument :
	shift_expression
	;

template_expression_parameter :
	guess_declaration_specifiers identifier '=' template_expression_argument
	| guess_declaration_specifiers abstract_declarator identifier '=' template_expression_argument
	;

template_parameter :
	template_type_parameter
	| template_identifier_parameter
	| template_expression_parameter
	;

template_parameters_list :
	template_parameter
	| template_parameters_list ',' template_parameter
	;

template_argument :
	template_expression_argument
	| template_identifier_argument
	| template_type_argument
	| identifier '=' template_expression_argument
	| identifier '=' template_identifier_argument
	| identifier '=' template_type_argument
	;

template_arguments_list :
	template_argument
	| template_arguments_list ',' template_argument
	;

class_entry :
	CLASS
	;

class_decl :
	class_entry identifier
	| class_entry base_strict_type
	| identifier class_entry identifier
	| identifier class_entry base_strict_type
	| class_entry identifier '<' template_parameters_list '>'
	| class_entry base_strict_type '<' template_parameters_list '>'
	| identifier class_entry identifier '<' template_parameters_list '>'
	| identifier class_entry base_strict_type '<' template_parameters_list '>'
	;

class :
	class_error '}'
	| class_head ';'
	| class_decl '{' '}'
	| class_head '{' '}'
	| class_entry identifier ';'
	| class_entry type ';'
	;

class_head :
	class_decl ':' inheritance_specifiers
	;

class_error :
	class_decl '{' struct_declaration_list_error
	| class_head '{' struct_declaration_list_error
	| class_decl '{' struct_declaration_list
	| class_head '{' struct_declaration_list
	//| class_decl '{' error
	//| class_head '{' error
	;

identifier :
	IDENTIFIER
	;

primary_expression :
	simple_primary_expression
	| '(' expression ')'
	;

i18n_string :
	string_literal
	| '$' string_literal
	| '$' string_literal '.' string_literal
	;

constant :
	CONSTANT
	;

simple_primary_expression :
	identifier
	| instantiation_unnamed
	| EXTENSION '(' compound_statement ')'
	| EXTENSION '(' expression ')'
	| EXTENSION '(' type_name ')' initializer
	| EXTENSION '(' type_name ')' '(' type_name ')' initializer
	| constant identifier
	| constant
	| i18n_string
	| WIDE_STRING_LITERAL
	| '(' ')'
	| NEWOP new_specifiers abstract_declarator_noarray '[' constant_expression ']'
	| NEWOP new_specifiers abstract_declarator_noarray '[' constant_expression_error ']'
	| NEWOP new_specifiers '[' constant_expression ']'
	| NEWOP new_specifiers '[' constant_expression_error ']'
	| NEW0OP new_specifiers abstract_declarator_noarray '[' constant_expression ']'
	| NEW0OP new_specifiers abstract_declarator_noarray '[' constant_expression_error ']'
	| NEW0OP new_specifiers '[' constant_expression ']'
	| NEW0OP new_specifiers '[' constant_expression_error ']'
	| RENEW constant_expression renew_specifiers abstract_declarator_noarray '[' constant_expression ']'
	| RENEW constant_expression renew_specifiers abstract_declarator_noarray '[' constant_expression_error ']'
	| RENEW constant_expression renew_specifiers '[' constant_expression ']'
	| RENEW constant_expression renew_specifiers '[' constant_expression_error ']'
	| RENEW0 constant_expression renew_specifiers abstract_declarator_noarray '[' constant_expression ']'
	| RENEW0 constant_expression renew_specifiers abstract_declarator_noarray '[' constant_expression_error ']'
	| RENEW0 constant_expression renew_specifiers '[' constant_expression ']'
	| RENEW0 constant_expression renew_specifiers '[' constant_expression_error ']'
	| CLASS '(' declaration_specifiers ')'
	| CLASS '(' declaration_specifiers abstract_declarator ')'
	| CLASS '(' identifier ')'
	| VAARG '(' assignment_expression ',' type_name ')'
	| CLASS_DATA '(' identifier ')'
	| database_open
	| dbfield
	| dbindex
	| dbtable
	| '[' argument_expression_list ']'
	| '[' ']'
	;

anon_instantiation_expression :
	instantiation_anon
	;

anon_instantiation_expression_error :
	//instantiation_anon_error error
	;

primary_expression_error :
	'(' expression
	| '(' expression_error
	;

postfix_expression :
	primary_expression
	| postfix_expression '[' expression ']'
	| postfix_expression '[' expression_error ']'
	| postfix_expression '(' ')'
	| postfix_expression '(' argument_expression_list ')'
	| postfix_expression '(' argument_expression_list_error ')'
	| postfix_expression '.' identifier
	| postfix_expression PTR_OP identifier
	| postfix_expression INC_OP
	| postfix_expression DEC_OP
	| postfix_expression_error '[' expression ']'
	| postfix_expression_error '[' expression_error ']'
	| postfix_expression_error '(' ')'
	| postfix_expression_error '(' argument_expression_list ')'
	| postfix_expression_error '.' identifier
	| postfix_expression_error PTR_OP identifier
	| postfix_expression_error INC_OP
	| postfix_expression_error DEC_OP
	;

argument_expression_list :
	assignment_expression
	| anon_instantiation_expression
	| argument_expression_list ',' assignment_expression
	| argument_expression_list ',' anon_instantiation_expression
	;

argument_expression_list_error :
	assignment_expression_error
	| anon_instantiation_expression_error
	| argument_expression_list ',' assignment_expression_error
	| argument_expression_list ',' anon_instantiation_expression_error
	| argument_expression_list ','
	;

common_unary_expression :
	INC_OP unary_expression
	| DEC_OP unary_expression
	| unary_operator cast_expression
	| unary_operator anon_instantiation_expression
	| SIZEOF unary_expression
	| SIZEOF '(' guess_type_name ')'
	| SIZEOF '(' CLASS type ')'
	| SIZEOF '(' CLASS guess_type ')'
	| ALIGNOF unary_expression
	| ALIGNOF '(' guess_type_name ')'
	| BUILTIN_OFFSETOF '(' guess_type_name ',' identifier ')'
	;

unary_expression :
	common_unary_expression
	| postfix_expression
	;

unary_operator :
	'&'
	| '*'
	| '+'
	| '-'
	| '~'
	| '!'
	| DELETE
	| _INCREF
	;

cast_expression :
	unary_expression
	| '(' type_name ')' initializer_noexp
	| '(' type_name ')' cast_expression
	;

multiplicative_expression :
	cast_expression
	| multiplicative_expression '*' cast_expression
	| multiplicative_expression '/' cast_expression
	| multiplicative_expression '%' cast_expression
	| multiplicative_expression_error '*' cast_expression
	| multiplicative_expression_error '/' cast_expression
	| multiplicative_expression_error '%' cast_expression
	;

additive_expression :
	multiplicative_expression
	| additive_expression '+' multiplicative_expression
	| additive_expression '-' multiplicative_expression
	| additive_expression_error '+' multiplicative_expression
	| additive_expression_error '-' multiplicative_expression
	;

shift_expression :
	additive_expression
	| shift_expression LEFT_OP additive_expression
	| shift_expression RIGHT_OP additive_expression
	| shift_expression_error LEFT_OP additive_expression
	| shift_expression_error RIGHT_OP additive_expression
	;

relational_expression_smaller_than :
	relational_expression '<'
	;

relational_expression :
	shift_expression
	| relational_expression_smaller_than shift_expression
	| relational_expression '>' shift_expression
	| relational_expression LE_OP shift_expression
	| relational_expression GE_OP shift_expression
	| relational_expression_error '<' shift_expression
	| relational_expression_error '>' shift_expression
	| relational_expression_error LE_OP shift_expression
	| relational_expression_error GE_OP shift_expression
	;

equality_expression :
	relational_expression
	| equality_expression EQ_OP relational_expression
	| equality_expression NE_OP relational_expression
	| equality_expression_error EQ_OP relational_expression
	| equality_expression_error NE_OP relational_expression
	| equality_expression EQ_OP anon_instantiation_expression
	| equality_expression NE_OP anon_instantiation_expression
	| equality_expression_error EQ_OP anon_instantiation_expression
	| equality_expression_error NE_OP anon_instantiation_expression
	;

and_expression :
	equality_expression
	| and_expression '&' equality_expression
	| and_expression_error '&' equality_expression
	| and_expression '&' anon_instantiation_expression
	| and_expression_error '&' anon_instantiation_expression
	;

exclusive_or_expression :
	and_expression
	| exclusive_or_expression '^' and_expression
	| exclusive_or_expression_error '^' and_expression
	| exclusive_or_expression '^' anon_instantiation_expression
	| exclusive_or_expression_error '^' anon_instantiation_expression
	;

inclusive_or_expression :
	exclusive_or_expression
	| inclusive_or_expression '|' exclusive_or_expression
	| inclusive_or_expression_error '|' exclusive_or_expression
	| inclusive_or_expression '|' anon_instantiation_expression
	| inclusive_or_expression_error '|' anon_instantiation_expression
	;

logical_and_expression :
	inclusive_or_expression
	| logical_and_expression AND_OP inclusive_or_expression
	| logical_and_expression_error AND_OP inclusive_or_expression
	;

logical_or_expression :
	logical_and_expression
	| logical_or_expression OR_OP logical_and_expression
	| logical_or_expression_error OR_OP logical_and_expression
	;

conditional_expression :
	logical_or_expression
	| logical_or_expression '?' expression ':' conditional_expression
	| logical_or_expression '?' expression_error ':' conditional_expression
	| logical_or_expression_error '?' expression ':' conditional_expression
	| logical_or_expression_error '?' expression_error ':' conditional_expression
	| logical_or_expression '?' expression_anon_inst ':' conditional_expression
	| logical_or_expression '?' expression_anon_inst_error ':' conditional_expression
	| logical_or_expression_error '?' expression_anon_inst ':' conditional_expression
	| logical_or_expression_error '?' expression_anon_inst_error ':' conditional_expression
	| logical_or_expression '?' expression ':' anon_instantiation_expression
	| logical_or_expression '?' expression_error ':' anon_instantiation_expression
	| logical_or_expression_error '?' expression ':' anon_instantiation_expression
	| logical_or_expression_error '?' expression_error ':' anon_instantiation_expression
	| logical_or_expression '?' expression_anon_inst ':' anon_instantiation_expression
	| logical_or_expression '?' expression_anon_inst_error ':' anon_instantiation_expression
	| logical_or_expression_error '?' expression_anon_inst ':' anon_instantiation_expression
	| logical_or_expression_error '?' expression_anon_inst_error ':' anon_instantiation_expression
	;

assignment_expression :
	conditional_expression
	| unary_expression assignment_operator assignment_expression
	| unary_expression_error assignment_operator assignment_expression
	| conditional_expression assignment_operator assignment_expression
	| conditional_expression_error assignment_operator assignment_expression
	| unary_expression assignment_operator anon_instantiation_expression
	| unary_expression_error assignment_operator anon_instantiation_expression
	| conditional_expression assignment_operator anon_instantiation_expression
	| conditional_expression_error assignment_operator anon_instantiation_expression
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
	| expression_error ',' assignment_expression
	| expression_error ')'
	;

expression_anon_inst :
	anon_instantiation_expression
	| expression ',' anon_instantiation_expression
	| expression_error ',' anon_instantiation_expression
	;

postfix_expression_error :
	primary_expression_error
	//| error
	//| postfix_expression error
	//| instantiation_unnamed_error error
	//| postfix_expression PTR_OP error
	//| postfix_expression_error PTR_OP error
	| postfix_expression '(' argument_expression_list
	| postfix_expression '(' argument_expression_list_error
	//| postfix_expression '.' error
	| postfix_expression_error '(' argument_expression_list_error
	//| postfix_expression_error '.' error
	;

common_unary_expression_error :
	INC_OP unary_expression_error
	| DEC_OP unary_expression_error
	| unary_operator cast_expression_error
	| unary_operator anon_instantiation_expression_error
	| SIZEOF unary_expression_error
	//| SIZEOF '(' guess_type_name ')' error
	//| SIZEOF '(' CLASS type ')' error
	//| SIZEOF '(' CLASS guess_type ')' error
	| ALIGNOF unary_expression_error
	//| ALIGNOF '(' guess_type_name ')' error
	;

unary_expression_error :
	common_unary_expression_error
	| postfix_expression_error
	;

cast_expression_error :
	unary_expression_error
	| '(' type_name ')' cast_expression_error
	;

multiplicative_expression_error :
	cast_expression_error
	| multiplicative_expression '*' cast_expression_error
	| multiplicative_expression '/' cast_expression_error
	| multiplicative_expression '%' cast_expression_error
	| multiplicative_expression_error '*' cast_expression_error
	| multiplicative_expression_error '/' cast_expression_error
	| multiplicative_expression_error '%' cast_expression_error
	;

additive_expression_error :
	multiplicative_expression_error
	| additive_expression '+' multiplicative_expression_error
	| additive_expression '-' multiplicative_expression_error
	| additive_expression_error '+' multiplicative_expression_error
	| additive_expression_error '-' multiplicative_expression_error
	;

shift_expression_error :
	additive_expression_error
	| shift_expression LEFT_OP additive_expression_error
	| shift_expression RIGHT_OP additive_expression_error
	| shift_expression_error LEFT_OP additive_expression_error
	| shift_expression_error RIGHT_OP additive_expression_error
	;

relational_expression_error :
	shift_expression_error
	| relational_expression_smaller_than shift_expression_error
	| relational_expression '>' shift_expression_error
	| relational_expression LE_OP shift_expression_error
	| relational_expression GE_OP shift_expression_error
	| relational_expression_error '<' shift_expression_error
	| relational_expression_error '>' shift_expression_error
	| relational_expression_error LE_OP shift_expression_error
	| relational_expression_error GE_OP shift_expression_error
	;

equality_expression_error :
	relational_expression_error
	| equality_expression EQ_OP relational_expression_error
	| equality_expression NE_OP relational_expression_error
	| equality_expression_error EQ_OP relational_expression_error
	| equality_expression_error NE_OP relational_expression_error
	| equality_expression EQ_OP anon_instantiation_expression_error
	| equality_expression NE_OP anon_instantiation_expression_error
	| equality_expression_error EQ_OP anon_instantiation_expression_error
	| equality_expression_error NE_OP anon_instantiation_expression_error
	;

and_expression_error :
	equality_expression_error
	| and_expression '&' equality_expression_error
	| and_expression_error '&' equality_expression_error
	| and_expression '&' anon_instantiation_expression_error
	| and_expression_error '&' anon_instantiation_expression_error
	;

exclusive_or_expression_error :
	and_expression_error
	| exclusive_or_expression '^' and_expression_error
	| exclusive_or_expression_error '^' and_expression_error
	| exclusive_or_expression '^' anon_instantiation_expression_error
	| exclusive_or_expression_error '^' anon_instantiation_expression_error
	;

inclusive_or_expression_error :
	exclusive_or_expression_error
	| inclusive_or_expression '|' exclusive_or_expression_error
	| inclusive_or_expression_error '|' exclusive_or_expression_error
	| inclusive_or_expression '|' anon_instantiation_expression_error
	| inclusive_or_expression_error '|' anon_instantiation_expression_error
	;

logical_and_expression_error :
	inclusive_or_expression_error
	| logical_and_expression AND_OP inclusive_or_expression_error
	| logical_and_expression_error AND_OP inclusive_or_expression_error
	;

logical_or_expression_error :
	logical_and_expression_error
	| logical_or_expression OR_OP logical_and_expression_error
	| logical_or_expression_error OR_OP logical_and_expression_error
	;

conditional_expression_error :
	logical_or_expression_error
	| logical_or_expression '?' expression ':' logical_or_expression_error
	| logical_or_expression '?' expression_error ':' logical_or_expression_error
	| logical_or_expression_error '?' expression ':' logical_or_expression_error
	| logical_or_expression_error '?' expression_error ':' logical_or_expression_error
	| logical_or_expression '?' expression ':'
	| logical_or_expression '?' expression_error ':'
	| logical_or_expression_error '?' expression ':'
	| logical_or_expression_error '?' expression_error ':'
	| logical_or_expression '?' expression_anon_inst ':' logical_or_expression_error
	| logical_or_expression '?' expression_anon_inst_error ':' logical_or_expression_error
	| logical_or_expression_error '?' expression_anon_inst ':' logical_or_expression_error
	| logical_or_expression_error '?' expression_anon_inst_error ':' logical_or_expression_error
	| logical_or_expression '?' expression_anon_inst ':'
	| logical_or_expression '?' expression_anon_inst_error ':'
	| logical_or_expression_error '?' expression_anon_inst ':'
	| logical_or_expression_error '?' expression_anon_inst_error ':'
	| logical_or_expression '?' expression ':' anon_instantiation_expression_error
	| logical_or_expression '?' expression_error ':' anon_instantiation_expression_error
	| logical_or_expression_error '?' expression ':' anon_instantiation_expression_error
	| logical_or_expression_error '?' expression_error ':' anon_instantiation_expression_error
	| logical_or_expression '?' expression_anon_inst ':' anon_instantiation_expression_error
	| logical_or_expression '?' expression_anon_inst_error ':' anon_instantiation_expression_error
	| logical_or_expression_error '?' expression_anon_inst ':' anon_instantiation_expression_error
	| logical_or_expression_error '?' expression_anon_inst_error ':' anon_instantiation_expression_error
	| logical_or_expression '?' ':'
	| logical_or_expression_error '?' ':'
	| logical_or_expression '?'
	| logical_or_expression_error '?'
	;

assignment_expression_error :
	conditional_expression_error
	| unary_expression assignment_operator assignment_expression_error
	| unary_expression_error assignment_operator assignment_expression_error
	| unary_expression assignment_operator anon_instantiation_expression_error
	| unary_expression_error assignment_operator anon_instantiation_expression_error
	;

expression_error :
	assignment_expression_error
	//| assignment_expression error
	| expression ',' assignment_expression_error
	| expression_error ',' assignment_expression_error
	| expression expression
	| expression_error expression
	| expression expression_error
	;

expression_anon_inst_error :
	anon_instantiation_expression_error
	//| anon_instantiation_expression error
	| expression ',' anon_instantiation_expression_error
	| expression_error ',' anon_instantiation_expression_error
	;

constant_expression :
	conditional_expression
	;

constant_expression_error :
	conditional_expression_error
	;

storage_class_specifier :
	TYPEDEF
	| EXTERN
	| STATIC
	| THREAD
	| AUTO
	| REGISTER
	| RESTRICT
	;

external_storage_class_specifier :
	TYPEDEF
	| EXTERN
	| STATIC
	| THREAD
	| AUTO
	| REGISTER
	| RESTRICT
	;

enumerator :
	identifier
	| identifier '=' constant_expression
	| identifier '=' constant_expression_error
	| identifier multi_attrib
	| identifier multi_attrib '=' constant_expression
	| identifier multi_attrib '=' constant_expression_error
	;

enumerator_list :
	enumerator
	| enumerator_list ',' enumerator
	| enumerator_list ','
	;

enum_specifier :
	ENUM
	;

enum_specifier_nocompound :
	enum_specifier identifier
	| enum_specifier strict_type
	;

enum_specifier_compound :
	enum_specifier_compound_error '}'
	| enum_specifier identifier '{' '}'
	| enum_specifier strict_type '{' '}'
	;

enum_specifier_compound_error :
	enum_specifier '{' enumerator_list
	//| enum_specifier '{' error
	| enum_specifier identifier '{' enumerator_list
	//| enum_specifier identifier '{' enumerator_list error
	//| enum_specifier identifier '{' error
	| enum_specifier identifier '{' enumerator_list ';' struct_declaration_list
	| enum_specifier identifier '{' enumerator_list ';' struct_declaration_list_error
	| enum_specifier strict_type '{' enumerator_list
	//| enum_specifier strict_type '{' enumerator_list error
	//| enum_specifier strict_type '{' error
	| enum_specifier strict_type '{' enumerator_list ';' struct_declaration_list
	| enum_specifier strict_type '{' enumerator_list ';' struct_declaration_list_error
	| enum_specifier identifier '{' enumerator_list ';'
	| enum_specifier strict_type '{' enumerator_list ';'
	;

enum_decl :
	enum_specifier identifier
	| enum_specifier strict_type
	;

enum_class :
	enum_class_error '}'
	| enum_decl ':' inheritance_specifiers '{' '}'
	| enum_decl '{' '}'
	;

enum_class_error :
	enum_decl ':' inheritance_specifiers '{' enumerator_list
	//| enum_decl ':' inheritance_specifiers '{' enumerator_list error
	//| enum_decl ':' inheritance_specifiers '{' error
	| enum_decl ':' inheritance_specifiers '{' enumerator_list ';' struct_declaration_list
	| enum_decl ':' inheritance_specifiers '{' enumerator_list ';' struct_declaration_list_error
	//| enum_decl ':' inheritance_specifiers '{' enumerator_list error ';' struct_declaration_list
	//| enum_decl ':' inheritance_specifiers '{' enumerator_list error ';' struct_declaration_list_error
	//| enum_decl ':' inheritance_specifiers '{' error ';' struct_declaration_list
	//| enum_decl ':' inheritance_specifiers '{' error ';' struct_declaration_list_error
	| enum_specifier '{' enumerator_list
	//| enum_specifier '{' error
	| enum_decl '{' enumerator_list
	//| enum_decl '{' enumerator_list error
	//| enum_decl '{' error
	| enum_decl '{' enumerator_list ';' struct_declaration_list
	| enum_decl '{' enumerator_list ';' struct_declaration_list_error
	| enum_decl ':' inheritance_specifiers '{' enumerator_list ';'
	//| enum_decl ':' inheritance_specifiers '{' enumerator_list error ';'
	//| enum_decl ':' inheritance_specifiers '{' error ';'
	| enum_decl '{' enumerator_list ';'
	;

class_specifier :
	enum_class
	| struct_class
	;

class_specifier_error :
	enum_class_error
	| struct_class_error
	;

ext_storage :
	ext_decl
	;

type_qualifier :
	CONST
	| VOLATILE
	| ext_storage
	;

type_qualifier_list :
	type_qualifier
	| type_qualifier_list type_qualifier
	;

type_specifier :
	VOID
	| CHAR
	| SHORT
	| INT
	| UINT
	| INT64
	| INT128
	| FLOAT128
	| FLOAT16
	| VALIST
	| LONG
	| FLOAT
	| DOUBLE
	| SIGNED
	| UNSIGNED
	| EXTENSION
	| struct_or_union_specifier_nocompound
	| enum_specifier_nocompound
	| type
	| TYPEOF '(' assignment_expression ')'
	| SUBCLASS '(' type ')'
	| SUBCLASS '(' identifier ')'
	| THISCLASS
	| TYPED_OBJECT
	| ANY_OBJECT
	| _BOOL
	| BOOL
	| _COMPLEX
	| _IMAGINARY
	;

strict_type_specifier :
	VOID
	| CHAR
	| SHORT
	| INT
	| UINT
	| INT64
	| INT128
	| FLOAT128
	| FLOAT16
	| VALIST
	| LONG
	| FLOAT
	| DOUBLE
	| SIGNED
	| UNSIGNED
	| EXTENSION
	| struct_or_union_specifier_nocompound
	| enum_specifier_nocompound
	| strict_type
	| _BOOL
	| BOOL
	| _COMPLEX
	| _IMAGINARY
	| TYPEOF '(' assignment_expression ')'
	| SUBCLASS '(' type ')'
	| SUBCLASS '(' identifier ')'
	| THISCLASS
	;

struct_declarator :
	declarator_nofunction_type_ok
	| declarator_nofunction_type_ok attrib
	| ':' constant_expression
	| declarator_nofunction_type_ok ':' constant_expression
	| declarator_nofunction_type_ok ':' constant_expression ':' constant_expression
	| ':' constant_expression_error
	| declarator_nofunction_type_ok ':' constant_expression_error
	| declarator_nofunction_type_ok ':' constant_expression ':' constant_expression_error
	| declarator_nofunction_type_ok ':' constant_expression_error ':' constant_expression_error
	| declarator_nofunction_type_ok ':' constant_expression_error ':' constant_expression
	;

struct_declarator_list :
	struct_declarator
	| struct_declarator_list ',' struct_declarator
	;

struct_entry :
	struct_or_union identifier
	| struct_or_union base_strict_type
	| struct_or_union ext_decl identifier
	| struct_or_union ext_decl base_strict_type
	;

struct_or_union_specifier_compound :
	struct_or_union_specifier_compound_error '}'
	| struct_entry '{' '}'
	| struct_or_union '{' '}'
	| struct_or_union ext_decl '{' '}'
	;

struct_or_union_specifier_compound_error :
	struct_entry '{' struct_declaration_list
	| struct_entry '{' struct_declaration_list_error
	//| struct_entry '{' error
	| struct_or_union '{' struct_declaration_list
	| struct_or_union '{' struct_declaration_list_error
	//| struct_or_union '{' error
	| struct_or_union ext_decl '{' struct_declaration_list
	| struct_or_union ext_decl '{' struct_declaration_list_error
	//| struct_or_union ext_decl '{' error
	;

struct_or_union_specifier_nocompound :
	struct_entry
	;

struct_decl :
	struct_entry
	| struct_entry '<' template_parameters_list '>'
	;

struct_head :
	struct_decl ':' inheritance_specifiers
	;

struct_class :
	struct_class_error '}'
	| struct_head '{' '}'
	| struct_decl '{' '}'
	| struct_or_union '{' '}'
	;

struct_class_error :
	struct_head '{' struct_declaration_list
	| struct_head '{' struct_declaration_list_error
	//| struct_head '{' error
	| struct_decl '{' struct_declaration_list
	| struct_decl '{' struct_declaration_list_error
	//| struct_decl '{' error
	| struct_or_union '{' struct_declaration_list
	| struct_or_union '{' struct_declaration_list_error
	//| struct_or_union '{' error
	;

struct_or_union :
	STRUCT
	| UNION
	;

specifier_qualifier_list :
	type_qualifier
	| specifier_qualifier_list type_qualifier
	| type_specifier
	| specifier_qualifier_list type_specifier
	| enum_specifier_compound
	| specifier_qualifier_list enum_specifier_compound
	| struct_or_union_specifier_compound
	| specifier_qualifier_list struct_or_union_specifier_compound
	;

guess_specifier_qualifier_list :
	type_qualifier
	| guess_specifier_qualifier_list type_qualifier
	| type_specifier
	| guess_specifier_qualifier_list type_specifier
	| guess_type
	| guess_specifier_qualifier_list guess_type
	| enum_specifier_compound
	| guess_specifier_qualifier_list enum_specifier_compound
	| struct_or_union_specifier_compound
	| guess_specifier_qualifier_list struct_or_union_specifier_compound
	;

declaration_specifiers :
	storage_class_specifier
	| declaration_specifiers storage_class_specifier
	| type_qualifier
	| declaration_specifiers type_qualifier
	| strict_type_specifier
	| declaration_specifiers strict_type_specifier
	| enum_specifier_compound
	| declaration_specifiers enum_specifier_compound
	| struct_or_union_specifier_compound
	| declaration_specifiers struct_or_union_specifier_compound
	;

guess_declaration_specifiers :
	storage_class_specifier
	| guess_declaration_specifiers storage_class_specifier
	| type_qualifier
	| guess_declaration_specifiers type_qualifier
	| type_specifier
	| guess_declaration_specifiers type_specifier
	| guess_type
	| guess_declaration_specifiers guess_type
	| struct_or_union_specifier_compound
	| guess_declaration_specifiers struct_or_union_specifier_compound
	| enum_specifier_compound
	| guess_declaration_specifiers enum_specifier_compound
	;

external_guess_declaration_specifiers :
	external_storage_class_specifier
	| external_guess_declaration_specifiers external_storage_class_specifier
	| type_qualifier
	| external_guess_declaration_specifiers type_qualifier
	| type_specifier
	| external_guess_declaration_specifiers type_specifier
	| guess_type
	| external_guess_declaration_specifiers guess_type
	| class_specifier
	| external_guess_declaration_specifiers class_specifier
	;

external_guess_declaration_specifiers_error :
	class_specifier_error
	| external_guess_declaration_specifiers class_specifier_error
	;

_inheritance_specifiers :
	PRIVATE
	| PUBLIC
	| storage_class_specifier
	| _inheritance_specifiers storage_class_specifier
	| type_qualifier
	| _inheritance_specifiers type_qualifier
	| strict_type_specifier
	| _inheritance_specifiers strict_type_specifier
	| identifier
	| _inheritance_specifiers identifier
	| identifier '<' template_arguments_list '>'
	| _inheritance_specifiers identifier '<' template_arguments_list '>'
	;

inheritance_specifiers :
	_inheritance_specifiers
	| struct_or_union
	;

property_specifiers :
	storage_class_specifier
	| property_specifiers storage_class_specifier
	| type_qualifier
	| property_specifiers type_qualifier
	| strict_type_specifier
	| property_specifiers strict_type_specifier
	| identifier
	| property_specifiers identifier
	| identifier '<' template_arguments_list '>'
	| property_specifiers identifier '<' template_arguments_list '>'
	;

renew_specifiers :
	storage_class_specifier
	| renew_specifiers storage_class_specifier
	| type_qualifier
	| renew_specifiers type_qualifier
	| strict_type_specifier
	| renew_specifiers strict_type_specifier
	| struct_or_union_specifier_compound
	| renew_specifiers struct_or_union_specifier_compound
	| enum_specifier_compound
	| renew_specifiers enum_specifier_compound
	| identifier
	| renew_specifiers identifier
	| identifier '<' template_arguments_list '>'
	| renew_specifiers identifier '<' template_arguments_list '>'
	;

new_specifiers :
	storage_class_specifier
	| new_specifiers storage_class_specifier
	| type_qualifier
	| new_specifiers type_qualifier
	| strict_type_specifier
	| new_specifiers strict_type_specifier
	| struct_or_union_specifier_compound
	| new_specifiers struct_or_union_specifier_compound
	| enum_specifier_compound
	| new_specifiers enum_specifier_compound
	| identifier
	| new_specifiers identifier
	| identifier '<' template_arguments_list '>'
	| new_specifiers identifier '<' template_arguments_list '>'
	;

identifier_list_error :
	//identifier_list ',' error
	//| identifier_list_error ',' error
	;

identifier_list :
	identifier
	| identifier_list ',' identifier
	| identifier_list_error ',' identifier
	| parameter_list ',' identifier
	| parameter_list_error ',' identifier
	;

direct_declarator_nofunction_type_ok :
	direct_declarator_nofunction
	| base_strict_type
	| UINT
	| base_strict_type '[' constant_expression ']'
	| base_strict_type '[' constant_expression_error ']'
	| base_strict_type '[' type ']'
	| base_strict_type '[' ']'
	| direct_declarator_nofunction_type_ok '[' constant_expression ']'
	| direct_declarator_nofunction_type_ok '[' constant_expression_error ']'
	| direct_declarator_nofunction_type_ok '[' type ']'
	| direct_declarator_nofunction_type_ok '[' ']'
	;

direct_declarator_nofunction :
	identifier
	| '(' declarator ')'
	| '(' ext_decl declarator ')'
	| '(' declarator_type_ok ')'
	| '(' ext_decl declarator_type_ok ')'
	| direct_declarator_nofunction '[' constant_expression ']'
	| direct_declarator_nofunction '[' constant_expression_error ']'
	| direct_declarator_nofunction '[' type ']'
	| direct_declarator_nofunction '[' ']'
	;

direct_declarator_function_start :
	direct_declarator_nofunction '('
	;

direct_declarator_function :
	direct_declarator_function_start parameter_type_list ')'
	| direct_declarator_function_start parameter_type_list_error ')'
	| direct_declarator_function_start identifier_list ')'
	| direct_declarator_function_start identifier_list_error ')'
	| direct_declarator_function_start ')'
	;

direct_declarator_function_error :
	direct_declarator_function_start identifier_list_error
	//| direct_declarator_function_start error
	| direct_declarator_function_start parameter_list '('
	| direct_declarator_function_start guess_declaration_specifiers identifier '('
	;

direct_declarator :
	direct_declarator_function
	| direct_declarator_nofunction
	;

direct_declarator_function_start_type_ok :
	direct_declarator_nofunction_type_ok '('
	;

direct_declarator_function_type_ok :
	direct_declarator_function_start_type_ok parameter_type_list ')'
	| direct_declarator_function_start_type_ok parameter_type_list_error ')'
	| direct_declarator_function_start_type_ok identifier_list ')'
	| direct_declarator_function_start_type_ok identifier_list_error ')'
	| direct_declarator_function_start_type_ok ')'
	;

direct_declarator_function_error_type_ok :
	direct_declarator_function_start_type_ok identifier_list_error
	//| direct_declarator_function_start_type_ok error
	| direct_declarator_function_start_type_ok parameter_list '('
	| direct_declarator_function_start_type_ok guess_declaration_specifiers identifier '('
	;

direct_declarator_type_ok :
	direct_declarator_function_type_ok
	| direct_declarator_nofunction_type_ok
	;

ext_decl :
	EXT_DECL
	| EXT_STORAGE
	| ext_decl EXT_STORAGE
	| ext_decl EXT_DECL
	| attrib
	| multi_attrib
	| ASM '(' string_literal ')'
	;

_attrib :
	ATTRIB
	| ATTRIB_DEP
	| __ATTRIB
	;

attribute_word :
	IDENTIFIER
	| TYPE_NAME
	| EXT_STORAGE
	| EXT_DECL
	| CONST
	;

attribute :
	attribute_word
	| attribute_word '(' expression ')'
	;

attribs_list :
	attribute
	| attribs_list attribute
	| attribs_list ',' attribute
	;

attrib :
	_attrib '(' '(' attribs_list ')' ')'
	| _attrib '(' '(' ')' ')'
	;

multi_attrib :
	attrib
	| multi_attrib attrib
	;

direct_abstract_declarator :
	'(' abstract_declarator ')'
	| '(' ext_decl abstract_declarator ')'
	| '[' ']'
	| '[' constant_expression ']'
	| '[' constant_expression_error ']'
	| '[' type ']'
	| direct_abstract_declarator '[' ']'
	| direct_abstract_declarator '[' constant_expression ']'
	| direct_abstract_declarator '[' type ']'
	| direct_abstract_declarator '[' constant_expression_error ']'
	| '(' ')'
	| '(' parameter_type_list ')'
	| '(' parameter_type_list_error ')'
	| direct_abstract_declarator '(' ')'
	| direct_abstract_declarator '(' parameter_type_list ')'
	| direct_abstract_declarator '(' parameter_type_list_error ')'
	;

direct_abstract_declarator_noarray :
	'(' abstract_declarator_noarray ')'
	| '(' ext_decl abstract_declarator_noarray ')'
	| '(' ')'
	| '(' parameter_type_list ')'
	| '(' parameter_type_list_error ')'
	| direct_abstract_declarator_noarray '(' ')'
	| direct_abstract_declarator_noarray '(' parameter_type_list ')'
	| direct_abstract_declarator_noarray '(' parameter_type_list_error ')'
	;

pointer :
	'*'
	| '*' type_qualifier_list
	| '*' pointer
	| '*' type_qualifier_list pointer
	;

abstract_declarator :
	pointer
	| direct_abstract_declarator
	| pointer direct_abstract_declarator
	| ext_decl pointer
	| ext_decl pointer direct_abstract_declarator
	;

abstract_declarator_noarray :
	pointer
	| direct_abstract_declarator_noarray
	| pointer direct_abstract_declarator_noarray
	| ext_decl pointer
	| ext_decl pointer direct_abstract_declarator_noarray
	;

declarator :
	direct_declarator
	| pointer direct_declarator
	| ext_decl pointer direct_declarator
	| declarator ext_decl
	| declarator_nofunction_type_ok ext_decl
	;

declarator_type_ok :
	direct_declarator_type_ok
	| pointer direct_declarator_type_ok
	| ext_decl pointer direct_declarator_type_ok
	| declarator_type_ok ext_decl
	;

declarator_function :
	direct_declarator_function
	| pointer direct_declarator_function
	| ext_decl pointer direct_declarator_function
	| pointer ext_decl direct_declarator_function
	;

declarator_function_error :
	direct_declarator_function_error
	| pointer direct_declarator_function_error
	| ext_decl pointer direct_declarator_function_error
	| pointer ext_decl direct_declarator_function_error
	;

declarator_function_type_ok :
	direct_declarator_function_type_ok
	| pointer direct_declarator_function_type_ok
	| ext_decl pointer direct_declarator_function_type_ok
	| pointer ext_decl direct_declarator_function_type_ok
	;

declarator_function_error_type_ok :
	direct_declarator_function_error_type_ok
	| pointer direct_declarator_function_error_type_ok
	| ext_decl pointer direct_declarator_function_error_type_ok
	| pointer ext_decl direct_declarator_function_error_type_ok
	;

declarator_nofunction_type_ok :
	direct_declarator_nofunction_type_ok
	| pointer direct_declarator_nofunction_type_ok
	| ext_decl pointer direct_declarator_nofunction_type_ok
	| pointer ext_decl direct_declarator_nofunction_type_ok
	;

initializer :
	assignment_expression
	| '{' initializer_list '}'
	| '{' initializer_list ',' '}'
	;

initializer_noexp :
	'{' initializer_list '}'
	| '{' initializer_list ',' '}'
	;

initializer_error :
	assignment_expression_error
	//| '{' initializer_list '}' error
	| '{' initializer_list
	//| '{' initializer_list ',' '}' error
	| '{' initializer_list ','
	;

initializer_condition :
	conditional_expression
	| anon_instantiation_expression
	;

initializer_condition_error :
	conditional_expression_error
	| anon_instantiation_expression_error
	;

initializer_list :
	initializer
	| initializer_error
	| initializer_list ',' initializer
	| initializer_list ',' initializer_error
	| initializer_list initializer
	| initializer_list initializer_error
	;

init_declarator :
	declarator
	| declarator_type_ok
	| declarator '=' initializer
	;

init_declarator_error :
	/*declarator error
	|*/ declarator '=' initializer_error
	;

init_declarator_list :
	init_declarator
	| init_declarator_list ',' init_declarator
	| UINT ',' init_declarator
	| INT64 ',' init_declarator
	| INT128 ',' init_declarator
	| FLOAT128 ',' init_declarator
	| FLOAT16 ',' init_declarator
	| base_strict_type ',' init_declarator
	| init_declarator_list_error ',' init_declarator
	;

init_declarator_list_error :
	init_declarator_error
	//| init_declarator error
	| init_declarator_list ',' init_declarator_error
	| init_declarator_list_error ',' init_declarator_error
	;

type_name :
	specifier_qualifier_list
	| specifier_qualifier_list abstract_declarator
	;

guess_type_name :
	guess_specifier_qualifier_list
	| guess_specifier_qualifier_list abstract_declarator
	;

parameter_declaration :
	guess_declaration_specifiers declarator_type_ok
	| guess_declaration_specifiers abstract_declarator
	| guess_declaration_specifiers '&'
	| guess_declaration_specifiers '&' declarator_type_ok
	| guess_declaration_specifiers
	| CLASS
	;

parameter_declaration_error :
	//guess_declaration_specifiers declarator_type_ok error
	//| guess_declaration_specifiers abstract_declarator error
	;

parameter_list :
	parameter_declaration
	| parameter_list ',' parameter_declaration
	//| parameter_list error ',' parameter_declaration
	| parameter_list_error ',' parameter_declaration
	//| parameter_list_error error ',' parameter_declaration
	//| error ',' parameter_declaration
	| identifier_list ',' parameter_declaration
	//| identifier_list error ',' parameter_declaration
	| identifier_list_error ',' parameter_declaration
	//| identifier_list_error error ',' parameter_declaration
	;

parameter_list_error :
	parameter_declaration_error
	| parameter_list ',' parameter_declaration_error
	| parameter_list_error ',' parameter_declaration_error
	//| parameter_list_error error ',' parameter_declaration_error
	//| error ',' parameter_declaration_error
	| identifier_list ',' parameter_declaration_error
	| identifier_list_error ',' parameter_declaration_error
	//| identifier_list_error error ',' parameter_declaration_error
	;

parameter_type_list :
	parameter_list
	| parameter_list ',' ELLIPSIS
	| parameter_list_error ',' ELLIPSIS
	| identifier_list ',' ELLIPSIS
	| identifier_list_error ',' ELLIPSIS
	//| error ',' ELLIPSIS
	;

parameter_type_list_error :
	parameter_list_error
	//| parameter_list ',' error
	//| parameter_list_error error
	;

statement :
	labeled_statement
	| attrib
	| compound_statement
	| ';'
	| ':'
	| expression ';'
	| selection_statement
	| iteration_statement
	| jump_statement
	| asm_statement
	| firewatchers ';'
	| stopwatching ';'
	| watch_definition ';'
	;

statement_error :
	labeled_statement_error
	| iteration_statement_error
	| compound_statement_error
	| selection_statement_error
	| jump_statement_error
	//| jump_statement error
	| expression_error
	;

asm_field :
	string_literal
	| string_literal '(' assignment_expression ')'
	| '[' identifier ']' string_literal '(' assignment_expression ')'
	;

asm_field_list :
	asm_field
	| asm_field_list ',' asm_field
	| /*empty*/
	;

asm_statement :
	ASM type_qualifier '(' string_literal ')' ';'
	| ASM type_qualifier '(' string_literal ':' asm_field_list ')' ';'
	| ASM type_qualifier '(' string_literal ':' asm_field_list ':' asm_field_list ')' ';'
	| ASM type_qualifier '(' string_literal ':' asm_field_list ':' asm_field_list ':' asm_field_list ')' ';'
	| ASM type_qualifier '(' string_literal IDENTIFIER asm_field_list ')' ';'
	| ASM type_qualifier '(' string_literal IDENTIFIER asm_field_list ':' asm_field_list ')' ';'
	| ASM type_qualifier '(' string_literal ':' asm_field_list IDENTIFIER asm_field_list ')' ';'
	| ASM '(' string_literal ')' ';'
	| ASM '(' string_literal ':' asm_field_list ')' ';'
	| ASM '(' string_literal ':' asm_field_list ':' asm_field_list ')' ';'
	| ASM '(' string_literal ':' asm_field_list ':' asm_field_list ':' asm_field_list ')' ';'
	| ASM '(' string_literal IDENTIFIER asm_field_list ')' ';'
	| ASM '(' string_literal IDENTIFIER asm_field_list ':' asm_field_list ')' ';'
	| ASM '(' string_literal ':' asm_field_list IDENTIFIER asm_field_list ')' ';'
	;

labeled_statement :
	identifier ':' statement
	| CASE constant_expression ':' statement
	| CASE constant_expression_error ':' statement
	| CASE ':' statement
	| DEFAULT ':' statement
	| identifier ':' declaration
	| CASE constant_expression ':' declaration
	| CASE constant_expression_error ':' declaration
	| CASE ':' declaration
	| DEFAULT ':' declaration
	;

labeled_statement_error :
	identifier ':' statement_error
	| CASE constant_expression ':' statement_error
	| CASE constant_expression_error ':' statement_error
	| CASE ':' statement_error
	| CASE ':'
	| DEFAULT ':' statement_error
	| DEFAULT ':'
	| identifier ':' declaration_error
	| CASE constant_expression ':' declaration_error
	| CASE constant_expression_error ':' declaration_error
	| CASE ':' declaration_error
	| DEFAULT ':' declaration_error
	;

declaration_mode :
	PUBLIC
	| PRIVATE
	| DEFAULT
	;

member_access :
	PUBLIC
	| PRIVATE
	;

declaration :
	declaration_specifiers ';'
	| declaration_specifiers init_declarator_list ';'
	| instantiation_named ';'
	| declaration_error ';'
	| STATIC_ASSERT '(' expression ')'
	| STATIC_ASSERT '(' expression ',' string_literal ')'
	;

external_guess_declaration :
	external_guess_declaration_specifiers ';'
	| external_guess_declaration_specifiers init_declarator_list ';'
	| external_guess_declaration_specifiers_error init_declarator_list ';'
	| external_guess_instantiation_named ';'
	| DEFINE identifier '=' conditional_expression ';'
	| STATIC DEFINE identifier '=' conditional_expression ';'
	;

//external_guess_declaration_error :
//	//external_guess_declaration_specifiers error
//	;

declaration_error :
	//declaration_specifiers error
	//| declaration_error error
	//| instantiation_named_error error
	//| instantiation_named error
	/*|*/ declaration_specifiers init_declarator_list_error
	;

declaration_list :
	declaration
	| declaration_list declaration
	| declaration_list_error declaration
	//| declaration_list error ';'
	;

declaration_list_error :
	declaration_error
	| declaration_list declaration_error
	;

statement_list :
	statement
	| statement_list statement
	| statement_list_error statement
	;

statement_list_error :
	statement_error
	| statement_list statement_error
	| statement_list_error statement_error
	| statement_list declaration
	| statement_list_error declaration
	| statement_list declaration_error
	| statement_list_error declaration_error
	;

compound_inside :
	statement_list
	| declaration_list
	| declaration_list statement_list
	| declaration_list_error statement_list
	;

compound_inside_error :
	statement_list_error
	| declaration_list_error
	| declaration_list statement_list_error
	| declaration_list_error statement_list_error
	;

compound_start :
	'{'
	;

compound_statement :
	compound_statement_error '}'
	;

compound_statement_error :
	compound_start compound_inside_error
	| compound_start
	| compound_start compound_inside
	;

expression_statement :
	';'
	| expression ';'
	| expression_error ';'
	;

selection_statement :
	IF '(' expression ')' statement %prec IFX /*1N*/
	| IF '(' expression_error ')' statement %prec IFX /*1N*/
	| IF '(' expression ')' statement ELSE /*2N*/ statement
	| IF '(' expression_error ')' statement ELSE /*2N*/ statement
	| SWITCH '(' expression ')' statement
	| SWITCH '(' expression_error ')' statement
	;

selection_statement_error :
	IF '(' expression_error
	//| selection_statement error
	;

iteration_statement :
	WHILE '(' expression ')' statement
	| WHILE '(' expression_error statement
	| WHILE '(' ')' statement
	| DO statement WHILE '(' expression ')' ';'
	| DO statement WHILE '(' expression_error ';'
	| FOR '(' expression_statement expression_statement ')' statement
	| FOR '(' expression_statement ')' statement
	| FOR '(' expression_statement expression_statement expression ')' statement
	| FOR '(' expression_statement expression_statement expression_error statement
	| FOR '(' ')' statement
	| FOR '(' identifier ':' expression ')' statement
	| FOR '(' identifier ':' expression ';' expression ')' statement
	;

iteration_statement_error :
	/*FOR '(' error
	| FOR '(' expression_error error
	| FOR '(' expression_statement error
	| FOR '(' expression_statement expression_error error
	|*/ FOR '(' expression_statement expression_statement expression_error
	| FOR '(' expression_statement expression_statement ')' statement_error
	| FOR '(' expression_statement expression_statement expression ')' statement_error
	| FOR '(' expression_statement expression_statement expression_error statement_error
	| DO statement WHILE '(' expression ')'
	| DO statement WHILE '(' expression
	| DO statement WHILE '(' expression_error
	| DO statement WHILE '('
	| DO statement WHILE
	| DO statement
	| DO
	//| WHILE error
	//| WHILE '(' ')' error
	| WHILE '(' expression_error
	| WHILE '(' expression ')' statement_error
	| WHILE '(' expression_error statement_error
	;

jump_statement :
	GOTO identifier ';'
	| CONTINUE ';'
	| BREAK ';'
	| RETURN ';'
	| RETURN expression ';'
	| RETURN expression_error ';'
	| RETURN anon_instantiation_expression ';'
	| RETURN anon_instantiation_expression_error ';'
	;

jump_statement_error :
	RETURN expression_error
	| RETURN anon_instantiation_expression_error
	| RETURN
	| GOTO
	;

function_definition :
	external_guess_declaration_specifiers declarator_function declaration_list compound_statement
	| external_guess_declaration_specifiers declarator_function compound_statement
	| external_guess_declaration_specifiers declarator_function_type_ok declaration_list compound_statement
	| external_guess_declaration_specifiers declarator_function_type_ok compound_statement
	| declarator_function declaration_list compound_statement
	| declarator_function compound_statement
	;

function_definition_error :
	external_guess_declaration_specifiers declarator_function declaration_list compound_statement_error
	| external_guess_declaration_specifiers declarator_function compound_statement_error
	| external_guess_declaration_specifiers declarator_function_type_ok declaration_list compound_statement_error
	| external_guess_declaration_specifiers declarator_function_type_ok compound_statement_error
	| declarator_function declaration_list compound_statement_error
	| declarator_function compound_statement_error
	;

string_literal :
	STRING_LITERAL
	| string_literal STRING_LITERAL
	;

external_declaration :
	function_definition
	| class
	| external_guess_declaration_specifiers class
	| external_guess_declaration
	| IMPORT string_literal
	| IMPORT STATIC string_literal
	| IMPORT identifier string_literal
	| ';'
	| declaration_mode function_definition
	| declaration_mode class
	| declaration_mode external_guess_declaration
	| declaration_mode IMPORT string_literal
	| declaration_mode IMPORT STATIC string_literal
	| declaration_mode IMPORT identifier string_literal
	| declaration_mode ':'
	| STATIC ':'
	| NAMESPACE identifier
	| NAMESPACE strict_type
	| dbtable_definition
	| declaration_mode dbtable_definition
	| PRAGMA
	| STATIC_ASSERT '(' expression ')'
	| STATIC_ASSERT '(' expression ',' string_literal ')'
	;

external_declaration_error :
	class_error
	| external_guess_declaration_specifiers class_error
	| function_definition_error
	| declaration_mode class_error
	| declaration_mode function_definition_error
	//| external_guess_declaration_error
	//| declaration_mode external_guess_declaration_error
	;

translation_unit_error :
	external_declaration_error
	| translation_unit external_declaration_error
	| translation_unit_error external_declaration_error
	//| translation_unit error
	//| translation_unit_error error
	;

translation_unit :
	external_declaration
	| translation_unit external_declaration
	| translation_unit_error class
	| translation_unit_error declaration_mode class
	;

thefile :
	translation_unit
	| translation_unit_error
	| /*empty*/
	;

dbtable_definition :
	DBTABLE string_literal identifier '{' dbfield_definition_list '}'
	| DBTABLE string_literal strict_type '{' dbfield_definition_list '}'
	| DBTABLE string_literal '{' dbfield_definition_list '}'
	;

dbfield_entry :
	guess_declaration_specifiers identifier string_literal ';'
	;

dbindex_item :
	identifier
	| '>' identifier
	| '<' identifier
	;

dbindex_item_list :
	dbindex_item
	| dbindex_item_list ',' dbindex_item
	;

dbindex_entry :
	DBINDEX dbindex_item_list ';'
	| DBINDEX dbindex_item_list identifier ';'
	;

dbfield_definition_list :
	dbfield_entry
	| dbindex_entry
	| dbfield_definition_list dbfield_entry
	| dbfield_definition_list dbindex_entry
	;

database_open :
	DATABASE_OPEN '(' assignment_expression ',' assignment_expression ')'
	;

dbfield :
	DBFIELD '(' string_literal ',' identifier ')'
	;

dbindex :
	DBINDEX '(' string_literal ',' identifier ')'
	;

dbtable :
	DBTABLE '(' string_literal ')'
	;

%%

D         [0-9]
L         [a-zA-Z_]
H         [a-fA-F0-9]
E         [Ee][+-]?{D}+
P         [Pp][+-]?{D}+
FS         (f|F|l|L|i|I|j|J)*
IS         (u|U|l|L|i|I|j|J)*
IDENT    {L}({L}|{D})*

%%

"#"[^\n\r]+	skip()
"//"[^\n\r]*             skip()
"/*"(?s:.)*?"*/"             skip()

"auto"                AUTO
"break"               BREAK
"case"                CASE
"char"                CHAR
"const"               CONST
"continue"            CONTINUE
"default"             DEFAULT
"do"                  DO
"double"              DOUBLE
"else"                ELSE
"enum"                ENUM
"extern"              EXTERN
"float"               FLOAT
"for"                 FOR
"goto"                GOTO
"if"                  IF
"int"                 INT
"__int32"             INT
"int32"               INT
"uint"                UINT
 /* "uint16"             UINT16  */
 /* "uint32"             UINT32  */
 /* "bool"               BOOL_TOKEN  */
"long"                LONG
"register"            REGISTER
"return"              RETURN
"short"               SHORT
"signed"              SIGNED
"__signed"            SIGNED
"__signed__"          SIGNED
"sizeof"              SIZEOF
"__alignof__"         ALIGNOF
"__alignof"           ALIGNOF
"__builtin_offsetof"         BUILTIN_OFFSETOF
"static"              STATIC
"__thread"            THREAD
"struct"              STRUCT
"switch"              SWITCH
"typedef"             TYPEDEF
"union"               UNION
"unsigned"            UNSIGNED
"void"                VOID
"volatile"            VOLATILE
"__volatile__"        VOLATILE
"__volatile"          VOLATILE
"while"               WHILE

"property"            PROPERTY
"set"                 SETPROP     /* TODO: Don't make this a keyword... */
"get"                 GETPROP     /* TODO: Don't make this a keyword... */
"isset"               ISPROPSET     /* TODO: Don't make this a keyword... */
"class"               CLASS
"thisclass"           THISCLASS
"virtual"             VIRTUAL
"delete"              DELETE
"new"                 NEWOP
"new0"                NEW0OP
"renew"               RENEW
"renew0"              RENEW0
"import"              IMPORT
"define"              DEFINE
"__int64"             INT64
"int64"               INT64
"__int128"            INT128
"__float128"          FLOAT128
"_Float128"           FLOAT128
"__float16"          FLOAT16
"_Float16"           FLOAT16
"__builtin_va_list"   VALIST
"__builtin_va_arg"    VAARG
"Bool"                BOOL
"_Bool"               _BOOL
"_Complex"            _COMPLEX
"_Imaginary"          _IMAGINARY
"restrict"            EXT_DECL
"_Nullable"           EXT_DECL
"_Nonnull"            EXT_DECL
"__ptr32"             EXT_DECL
"__ptr64"             EXT_DECL
"_Atomic"             EXT_DECL
"__forceinline"       EXT_DECL
"__unaligned"         EXT_DECL
"_Alignof"            ALIGNOF
"_Static_assert"      STATIC_ASSERT

 /* "__attribute__".?"(("({D}|{L})*"))"  EXT_ATTRIB  */

 /* DID I MEAN? "__attribute__"" "*"(("" "*({D}|{L})*" "*("("({D}|{L})*(" "*","" "*({D}|{L})*)*" "*")")?" "*"))"  EXT_ATTRIB  */

 /*
 "__attribute_deprecated__"(" "*)"(("(" "*)({D}|{L})*(" "*)("("({D}|{L}|\")*((" "*)","(" "*)({D}|{L}|\")*)*(" "*)")")?(" "*)(","(" "*)({D}|{L})*(" "*)("("({D}|{L}|\")*((" "*)","(" "*)({D}|{L}|\")*)*(" "*)")")?(" "*))*"))"  EXT_ATTRIB
 "__attribute__"           (" "*)"(("(" "*)({D}|{L})*(" "*)("("({D}|{L}|\")*((" "*)","(" "*)({D}|{L}|\")*)*(" "*)")")?(" "*)(","(" "*)({D}|{L})*(" "*)("("({D}|{L}|\")*((" "*)","(" "*)({D}|{L}|\")*)*(" "*)")")?(" "*))*"))"  EXT_ATTRIB
 "__attribute"             (" "*)"(("(" "*)({D}|{L})*(" "*)("("({D}|{L}|\")*((" "*)","(" "*)({D}|{L}|\")*)*(" "*)")")?(" "*)(","(" "*)({D}|{L})*(" "*)("("({D}|{L}|\")*((" "*)","(" "*)({D}|{L}|\")*)*(" "*)")")?(" "*))*"))"  EXT_ATTRIB
 */
 /*
 [__attribute__] [spaces]
   [((] [spaces]
      [digits | letters] [spaces]
         ( [(]  [digits or letters or "]  ( [spaces] [,] [spaces] [digits or letters or "] )*  [spaces]  [)] )?
      [spaces]
      ( [,] [spaces]  [digits or letters]  [spaces]
         ( [(]  [digits or letters or "]
            ( [spaces] [,] [spaces] [digits or letters or "] )*  [spaces] [)]
         )? [spaces]
      )*
   [))]
 */
 /* "__attribute__".?"((".?({D}|{L})*.?("("({D}|{L})*(.?",".?({D}|{L})*)*.?")")?.?"))"  EXT_ATTRIB  */
 /* "__attribute".?"((".?({D}|{L})*.?("("({D}|{L})*(.?",".?({D}|{L})*)*.?")")?.?"))"  EXT_ATTRIB */

"__attribute_deprecated__" ATTRIB_DEP
"__attribute__" ATTRIB
"__attribute" __ATTRIB

"__inline__"                EXT_STORAGE
"_inline"                   EXT_STORAGE
"__inline"                  EXT_STORAGE
"inline"                    EXT_STORAGE
"__declspec("({D}|{L}|([ \n\t\r]))*")"  EXT_STORAGE
"__declspec("({D}|{L}|([ \n\t\r]))*"("((({D}|{L})*)|((\"(\\.|[^\\"])*\"([ \n\t\r])*)*))")"([ \n\t\r])*")"  EXT_STORAGE
"dllexport"                 EXT_STORAGE
"dllimport"                 EXT_STORAGE
"_Noreturn"                 EXT_STORAGE
"__cdecl"                   EXT_DECL
"__stdcall"                 EXT_DECL
"__stdcall__"               EXT_DECL
"_stdcall"                  EXT_DECL
"stdcall"                   EXT_DECL
"__restrict"                EXT_DECL
"__const"                   CONST /*EXT_DECL*/
"__restrict__"              EXT_DECL
"public"                    PUBLIC
"private"                   PRIVATE
"typed_object"              TYPED_OBJECT
"any_object"                ANY_OBJECT
"incref"                    _INCREF
"__extension__"             EXTENSION
"_extension_"               EXTENSION
"__asm__"                   ASM
"asm"                       ASM
"__asm"                     ASM
"__typeof"                  TYPEOF
"watch"                     WATCH
"stopwatching"              STOPWATCHING
"firewatchers"              FIREWATCHERS
"watchable"                 WATCHABLE
"class_designer"            CLASS_DESIGNER
"class_no_expansion"        CLASS_NO_EXPANSION
"class_fixed"               CLASS_FIXED
"class_default_property"    CLASS_DEFAULT_PROPERTY
"property_category"         PROPERTY_CATEGORY
"class_data"                CLASS_DATA
"class_property"            CLASS_PROPERTY
"subclass"                  SUBCLASS
"namespace"                 NAMESPACE
"dbtable"                   DBTABLE
"dbfield"                   DBFIELD
"dbindex"                   DBINDEX
"database_open"             DATABASE_OPEN

("::"?(({IDENT}"&"?"::")*))?{IDENT}     IDENTIFIER      /* {L}({L}|{D})*       check_type()   // ("::"|(({IDENT}"::")*)){IDENT}   check_type()      // {L}({L}|{D})*       check_type()  */

0[xX]{H}+{IS}?           CONSTANT

0[xX]{H}+{P}{FS}?     CONSTANT
0[xX]{H}*"."{H}+({P})?{FS}?     CONSTANT
0[xX]{H}+"."{H}*({P})?{FS}?     CONSTANT

0{D}+{IS}?               CONSTANT
{D}+{IS}?                CONSTANT
L?'(\\.|[^\\'])+'        CONSTANT

{D}+{E}{FS}?             CONSTANT
{D}*"."{D}+({E})?{FS}?   CONSTANT
{D}+"."{D}*({E})?{FS}?   CONSTANT
{D}+"."{D}+"."{D}*       CONSTANT   /* For triple OS X versions inside attributes... TODO: Add syntax errors elsewhere */

\"(\\.|[^\\\"])*\"      STRING_LITERAL
L\"(\\.|[^\\\"])*\"      WIDE_STRING_LITERAL

"..."        ELLIPSIS
">>="        RIGHT_ASSIGN
"<<="        LEFT_ASSIGN
"+="         ADD_ASSIGN
"-="         SUB_ASSIGN
"*="         MUL_ASSIGN
"/="         DIV_ASSIGN
"%="         MOD_ASSIGN
"&="         AND_ASSIGN
"^="         XOR_ASSIGN
"|="         OR_ASSIGN
">>"         RIGHT_OP
"<<"         LEFT_OP
"++"         INC_OP
"--"         DEC_OP
"->"         PTR_OP
"&&"         AND_OP
"||"         OR_OP
"<="         LE_OP
">="         GE_OP
"=="         EQ_OP
"!="         NE_OP
   /* "::"         CLASS_OP  */
";"          ';'
("{"|"<%")   '{'
("}"|"%>")   '}'
","          ','
":"          ':'
"="          '='
"("          '('
")"          ')'
("["|"<:")   '['
("]"|":>")   ']'
"."          '.'
"&"          '&'
"!"          '!'
"~"          '~'
"-"          '-'
"+"          '+'
"*"          '*'
"/"          '/'
"%"          '%'
"<"          '<'
">"          '>'
"^"          '^'
"|"          '|'
"?"          '?'
"$"          '$'



[ \v\f]   skip()
[\n+]    skip()
[\t]     skip()
[\r]  skip()
.         ILLEGAL_CHARACTHER

%%
