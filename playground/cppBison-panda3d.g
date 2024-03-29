//From: https://github.com/panda3d/panda3d/blob/655aa49d815da6f036a2d5708af2e76f727c6316/dtool/src/cppparser/cppBison.yxx
/**
 * @file cppBison.yxx
 * @author drose
 * @date 1999-01-16
 */

/*Tokens*/
%token REAL
%token INTEGER
%token CHAR_TOK
%token SIMPLE_STRING
%token SIMPLE_IDENTIFIER
%token STRING_LITERAL
%token CUSTOM_LITERAL
%token IDENTIFIER
%token TYPENAME_IDENTIFIER
%token TYPEPACK_IDENTIFIER
%token SCOPING
//%token TYPEDEFNAME
%token ELLIPSIS
%token OROR
%token ANDAND
%token EQCOMPARE
%token NECOMPARE
%token LECOMPARE
%token GECOMPARE
%token SPACESHIP
%token LSHIFT
%token RSHIFT
%token POINTSAT_STAR
%token DOT_STAR
%token UNARY
//%token UNARY_NOT
//%token UNARY_NEGATE
//%token UNARY_MINUS
//%token UNARY_PLUS
//%token UNARY_STAR
//%token UNARY_REF
%token POINTSAT
%token SCOPE
%token PLUSPLUS
%token MINUSMINUS
%token TIMESEQUAL
%token DIVIDEEQUAL
%token MODEQUAL
%token PLUSEQUAL
%token MINUSEQUAL
%token OREQUAL
%token ANDEQUAL
%token XOREQUAL
%token LSHIFTEQUAL
%token RSHIFTEQUAL
%token ATTR_LEFT
%token ATTR_RIGHT
%token KW_ALIGNAS
%token KW_ALIGNOF
%token KW_AUTO
%token KW_BEGIN_PUBLISH
%token KW_BLOCKING
%token KW_BOOL
%token KW_BUILTIN_VA_LIST
%token KW_CATCH
%token KW_CHAR
%token KW_CHAR8_T
%token KW_CHAR16_T
%token KW_CHAR32_T
%token KW_CLASS
%token KW_CONST
%token KW_CONSTEVAL
%token KW_CONSTEXPR
%token KW_CONSTINIT
%token KW_CONST_CAST
%token KW_DECLTYPE
%token KW_DEFAULT
%token KW_DELETE
%token KW_DOUBLE
%token KW_DYNAMIC_CAST
%token KW_ELSE
%token KW_END_PUBLISH
%token KW_ENUM
%token KW_EXTENSION
%token KW_EXTERN
%token KW_EXPLICIT
%token KW_EXPLICIT_LPAREN
%token KW_PUBLISHED
%token KW_FALSE
%token KW_FINAL
%token KW_FLOAT
%token KW_FRIEND
%token KW_FOR
%token KW_GOTO
%token KW_HAS_VIRTUAL_DESTRUCTOR
%token KW_IF
%token KW_INLINE
%token KW_INT
%token KW_IS_ABSTRACT
%token KW_IS_BASE_OF
%token KW_IS_CLASS
%token KW_IS_CONSTRUCTIBLE
%token KW_IS_CONVERTIBLE_TO
%token KW_IS_DESTRUCTIBLE
%token KW_IS_EMPTY
%token KW_IS_ENUM
%token KW_IS_FINAL
%token KW_IS_FUNDAMENTAL
%token KW_IS_POD
%token KW_IS_POLYMORPHIC
%token KW_IS_STANDARD_LAYOUT
%token KW_IS_TRIVIAL
%token KW_IS_TRIVIALLY_COPYABLE
%token KW_IS_UNION
%token KW_LONG
%token KW_MAKE_MAP_KEYS_SEQ
%token KW_MAKE_MAP_PROPERTY
%token KW_MAKE_PROPERTY
%token KW_MAKE_PROPERTY2
%token KW_MAKE_SEQ
%token KW_MAKE_SEQ_PROPERTY
%token KW_MUTABLE
%token KW_NAMESPACE
%token KW_NEW
%token KW_NOEXCEPT
%token KW_NOEXCEPT_LPAREN
%token KW_NULLPTR
%token KW_OPERATOR
%token KW_OVERRIDE
%token KW_PRIVATE
%token KW_PROTECTED
%token KW_PUBLIC
%token KW_REGISTER
%token KW_REINTERPRET_CAST
%token KW_RESTRICT
%token KW_RETURN
%token KW_SHORT
%token KW_SIGNED
%token KW_SIZEOF
%token KW_STATIC
%token KW_STATIC_ASSERT
%token KW_STATIC_CAST
%token KW_STRUCT
%token KW_TEMPLATE
%token KW_THREAD_LOCAL
%token KW_THROW
%token KW_TRUE
%token KW_TRY
%token KW_TYPEDEF
%token KW_TYPEID
%token KW_TYPENAME
%token KW_UNDERLYING_TYPE
%token KW_UNION
%token KW_UNSIGNED
%token KW_USING
%token KW_VIRTUAL
%token KW_VOID
%token KW_VOLATILE
%token KW_WCHAR_T
%token KW_WHILE
%token START_CPP
%token START_CONST_EXPR
%token START_TYPE
%token '{'
%token ','
%token ';'
%token ':'
%token '='
%token '?'
%token '|'
%token '^'
%token '&'
%token '<'
%token '>'
%token '+'
%token '-'
%token '*'
%token '/'
%token '%'
%token '~'
%token '.'
%token '('
%token '['
%token ')'
%token '}'
%token '!'
%token ']'

%left /*1*/ IDENTIFIER TYPENAME_IDENTIFIER ELLIPSIS KW_BOOL KW_CHAR KW_CHAR8_T KW_CHAR16_T KW_CHAR32_T KW_DOUBLE KW_ENUM KW_FLOAT KW_INT KW_LONG KW_OPERATOR KW_SHORT KW_SIGNED KW_TYPENAME KW_UNSIGNED KW_WCHAR_T //TYPEDEFNAME
%left /*2*/ '{' ',' ';'
%nonassoc /*3*/ KW_THROW
%right /*4*/ ':'
%right /*5*/ '='
%right /*6*/ '?'
%left /*7*/ OROR
%left /*8*/ ANDAND
%left /*9*/ '|'
%left /*10*/ '^'
%left /*11*/ '&'
%left /*12*/ EQCOMPARE NECOMPARE
%left /*13*/ LECOMPARE GECOMPARE '<' '>'
%left /*14*/ SPACESHIP
%left /*15*/ LSHIFT RSHIFT
%left /*16*/ '+' '-'
%left /*17*/ '*' '/' '%'
%left /*18*/ POINTSAT_STAR DOT_STAR
%right /*19*/ UNARY PLUSPLUS MINUSMINUS '~'
%left /*20*/ POINTSAT '.' '(' '['
%right /*21*/ SCOPE
%nonassoc /*22*/ KW_CATCH KW_DELETE KW_NEW KW_TRY

%start grammar

%%

grammar :
	cpp
	| START_CPP cpp
	| START_CONST_EXPR const_expr
	| START_TYPE full_type
	;

cpp :
	%empty
	| cpp optional_attributes ';' /*2L*/
	| cpp optional_attributes declaration
	;

constructor_inits :
	constructor_init
	| constructor_inits ',' /*2L*/ constructor_init
	;

constructor_init :
	name '(' /*20L*/ optional_const_expr_comma ')'
	| name '(' /*20L*/ optional_const_expr_comma ')' ELLIPSIS /*1L*/
	| name '{' /*2L*/ optional_const_expr_comma '}'
	;

extern_c :
	storage_class '{' /*2L*/ cpp '}'
	;

declaration :
	type_like_declaration
	| template_declaration
	| extern_c
	| namespace_declaration
	| friend_declaration
	| KW_TYPEDEF typedef_declaration
	| KW_BEGIN_PUBLISH
	| KW_END_PUBLISH
	| KW_PUBLISHED ':' /*4R*/
	| KW_PUBLIC ':' /*4R*/
	| KW_PROTECTED ':' /*4R*/
	| KW_PRIVATE ':' /*4R*/
	| KW_MAKE_PROPERTY '(' /*20L*/ name ',' /*2L*/ IDENTIFIER /*1L*/ maybe_comma_identifier ')' ';' /*2L*/
	| KW_MAKE_PROPERTY '(' /*20L*/ name ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ')' ';' /*2L*/
	| KW_MAKE_SEQ_PROPERTY '(' /*20L*/ name ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ')' ';' /*2L*/
	| KW_MAKE_SEQ_PROPERTY '(' /*20L*/ name ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ')' ';' /*2L*/
	| KW_MAKE_SEQ_PROPERTY '(' /*20L*/ name ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ')' ';' /*2L*/
	| KW_MAKE_SEQ_PROPERTY '(' /*20L*/ name ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ')' ';' /*2L*/
	| KW_MAKE_MAP_PROPERTY '(' /*20L*/ name ',' /*2L*/ IDENTIFIER /*1L*/ ')' ';' /*2L*/
	| KW_MAKE_MAP_PROPERTY '(' /*20L*/ name ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ')' ';' /*2L*/
	| KW_MAKE_MAP_PROPERTY '(' /*20L*/ name ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ maybe_comma_identifier ')' ';' /*2L*/
	| KW_MAKE_MAP_KEYS_SEQ '(' /*20L*/ name ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ')' ';' /*2L*/
	| KW_MAKE_PROPERTY2 '(' /*20L*/ name ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ')' ';' /*2L*/
	| KW_MAKE_PROPERTY2 '(' /*20L*/ name ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ')' ';' /*2L*/
	| KW_MAKE_SEQ '(' /*20L*/ name ',' /*2L*/ IDENTIFIER /*1L*/ ',' /*2L*/ IDENTIFIER /*1L*/ ')' ';' /*2L*/
	| KW_STATIC_ASSERT '(' /*20L*/ const_expr ',' /*2L*/ string_literal ')' ';' /*2L*/
	| KW_STATIC_ASSERT '(' /*20L*/ const_expr ')' ';' /*2L*/
	;

friend_declaration :
	KW_FRIEND declaration
	;

storage_class :
	%empty
	| KW_CONST storage_class
	| KW_EXTERN storage_class
	| KW_EXTERN SIMPLE_STRING storage_class
	| KW_STATIC storage_class
	| KW_INLINE storage_class
	| KW_VIRTUAL storage_class
	| KW_EXPLICIT storage_class
	| KW_EXPLICIT_LPAREN const_expr ')' storage_class
	| KW_REGISTER storage_class
	| KW_VOLATILE storage_class
	| KW_MUTABLE storage_class
	| KW_CONSTEVAL storage_class
	| KW_CONSTEXPR storage_class
	| KW_CONSTINIT storage_class
	| KW_BLOCKING storage_class
	| KW_EXTENSION storage_class
	| KW_THREAD_LOCAL storage_class
	;

optional_attributes :
	%empty
	| optional_attributes ATTR_LEFT attribute_specifiers ATTR_RIGHT
	| optional_attributes ATTR_LEFT KW_USING name ':' /*4R*/ attribute_specifiers ATTR_RIGHT
	| optional_attributes KW_ALIGNAS '(' /*20L*/ const_expr ')'
	| optional_attributes KW_ALIGNAS '(' /*20L*/ type_decl ')'
	;

attribute_specifiers :
	attribute_specifier
	| attribute_specifiers ',' /*2L*/ attribute_specifier
	;

attribute_specifier :
	name
	| name '(' /*20L*/ formal_parameter_list ')'
	;

type_like_declaration :
	storage_class var_type_decl multiple_instance_identifiers
	| storage_class type_decl ';' /*2L*/
	| storage_class constructor_prototype maybe_initialize_or_constructor_body
	| storage_class function_prototype maybe_initialize_or_function_body
	| using_declaration
	;

multiple_instance_identifiers :
	instance_identifier_and_maybe_trailing_return_type maybe_initialize_or_function_body
	| instance_identifier_and_maybe_trailing_return_type maybe_initialize ',' /*2L*/ multiple_instance_identifiers
	;

typedef_declaration :
	storage_class var_type_decl typedef_instance_identifiers
	| storage_class function_prototype maybe_initialize_or_function_body
	;

typedef_instance_identifiers :
	instance_identifier_and_maybe_trailing_return_type maybe_initialize_or_function_body
	| instance_identifier_and_maybe_trailing_return_type maybe_initialize ',' /*2L*/ typedef_instance_identifiers
	;

constructor_prototype :
	IDENTIFIER /*1L*/ '(' /*20L*/ function_parameter_list ')' function_post optional_attributes
	| TYPENAME_IDENTIFIER /*1L*/ '(' /*20L*/ IDENTIFIER /*1L*/ ')' '(' /*20L*/ function_parameter_list ')' function_post optional_attributes
	| TYPENAME_IDENTIFIER /*1L*/ '(' /*20L*/ function_parameter_list ')' function_post optional_attributes
	;

function_prototype :
	'~' /*19R*/ name '(' /*20L*/ function_parameter_list ')' function_post optional_attributes
	| TYPENAME_IDENTIFIER /*1L*/ '(' /*20L*/ '*' /*17L*/ instance_identifier ')' '(' /*20L*/ function_parameter_list ')' function_post optional_attributes maybe_trailing_return_type
	| TYPENAME_IDENTIFIER /*1L*/ '(' /*20L*/ SCOPING '*' /*17L*/ instance_identifier ')' '(' /*20L*/ function_parameter_list ')' function_post optional_attributes maybe_trailing_return_type
	| KW_OPERATOR /*1L*/ type not_paren_formal_parameter_identifier '(' /*20L*/ function_parameter_list ')' function_post
	| KW_OPERATOR /*1L*/ KW_CONST type not_paren_formal_parameter_identifier '(' /*20L*/ function_parameter_list ')' function_post
	| IDENTIFIER /*1L*/
	;

function_post :
	%empty
	| function_post KW_CONST
	| function_post KW_VOLATILE
	| function_post KW_NOEXCEPT
	| function_post KW_NOEXCEPT_LPAREN const_expr ')'
	| function_post KW_FINAL
	| function_post KW_OVERRIDE
	| function_post '&' /*11L*/
	| function_post ANDAND /*8L*/
	| function_post KW_MUTABLE
	| function_post KW_CONSTEXPR
	| function_post KW_THROW /*3N*/ '(' /*20L*/ ')'
	| function_post KW_THROW /*3N*/ '(' /*20L*/ name ')'
	| function_post KW_THROW /*3N*/ '(' /*20L*/ name ELLIPSIS /*1L*/ ')'
	;

function_operator :
	'!'
	| '~' /*19R*/
	| '*' /*17L*/
	| '/' /*17L*/
	| '%' /*17L*/
	| '+' /*16L*/
	| '-' /*16L*/
	| '|' /*9L*/
	| '&' /*11L*/
	| '^' /*10L*/
	| OROR /*7L*/
	| ANDAND /*8L*/
	| EQCOMPARE /*12L*/
	| NECOMPARE /*12L*/
	| LECOMPARE /*13L*/
	| GECOMPARE /*13L*/
	| '<' /*13L*/
	| '>' /*13L*/
	| SPACESHIP /*14L*/
	| LSHIFT /*15L*/
	| RSHIFT /*15L*/
	| '=' /*5R*/
	| ',' /*2L*/
	| PLUSPLUS /*19R*/
	| MINUSMINUS /*19R*/
	| TIMESEQUAL
	| DIVIDEEQUAL
	| MODEQUAL
	| PLUSEQUAL
	| MINUSEQUAL
	| OREQUAL
	| ANDEQUAL
	| XOREQUAL
	| LSHIFTEQUAL
	| RSHIFTEQUAL
	| POINTSAT /*20L*/
	| '[' /*20L*/ ']'
	| '(' /*20L*/ ')'
	| KW_NEW /*22N*/
	| KW_DELETE /*22N*/
	;

more_template_declaration :
	type_like_declaration
	| template_declaration
	| friend_declaration
	;

template_declaration :
	KW_EXTERN template_declaration
	| KW_TEMPLATE '<' /*13L*/ template_formal_parameters '>' /*13L*/ more_template_declaration
	| KW_TEMPLATE type_like_declaration
	| KW_TEMPLATE friend_declaration
	;

template_formal_parameters :
	%empty
	| template_nonempty_formal_parameters
	;

template_nonempty_formal_parameters :
	template_formal_parameter
	| template_nonempty_formal_parameters ',' /*2L*/ template_formal_parameter
	;

typename_keyword :
	KW_CLASS
	| KW_TYPENAME /*1L*/
	;

template_formal_parameter :
	typename_keyword
	| typename_keyword name
	| typename_keyword name '=' /*5R*/ full_type
	| typename_keyword ELLIPSIS /*1L*/
	| typename_keyword ELLIPSIS /*1L*/ name
	| template_formal_parameter_type formal_parameter_identifier template_parameter_maybe_initialize
	| KW_CONST template_formal_parameter_type formal_parameter_identifier template_parameter_maybe_initialize
	| template_formal_parameter_type parameter_pack_identifier
	| KW_CONST template_formal_parameter_type parameter_pack_identifier
	| KW_VOLATILE template_formal_parameter_type formal_parameter_identifier template_parameter_maybe_initialize
	| KW_VOLATILE template_formal_parameter_type parameter_pack_identifier
	;

template_formal_parameter_type :
	simple_type
	| IDENTIFIER /*1L*/
	| TYPENAME_IDENTIFIER /*1L*/
	| TYPEPACK_IDENTIFIER
	;

instance_identifier :
	name_no_final optional_attributes
	| KW_OPERATOR /*1L*/ function_operator optional_attributes
	| KW_OPERATOR /*1L*/ SIMPLE_STRING IDENTIFIER /*1L*/ optional_attributes
	| KW_CONST instance_identifier %prec UNARY /*19R*/
	| KW_VOLATILE instance_identifier %prec UNARY /*19R*/
	| '*' /*17L*/ optional_attributes instance_identifier %prec UNARY /*19R*/
	| '&' /*11L*/ optional_attributes instance_identifier %prec UNARY /*19R*/
	| ANDAND /*8L*/ optional_attributes instance_identifier %prec UNARY /*19R*/
	| SCOPING '*' /*17L*/ optional_attributes instance_identifier %prec UNARY /*19R*/
	| instance_identifier '[' /*20L*/ optional_const_expr ']' optional_attributes
	| '(' /*20L*/ instance_identifier ')'
	| instance_identifier '(' /*20L*/ formal_parameter_list ')' function_post optional_attributes
	;

instance_identifier_and_maybe_trailing_return_type :
	instance_identifier maybe_trailing_return_type
	| instance_identifier ':' /*4R*/ const_expr
	;

maybe_trailing_return_type :
	%empty
	| POINTSAT /*20L*/ predefined_type empty_instance_identifier
	| POINTSAT /*20L*/ KW_CONST predefined_type empty_instance_identifier
	;

maybe_comma_identifier :
	%empty
	| ',' /*2L*/ IDENTIFIER /*1L*/
	;

function_parameter_list :
	%empty
	| ELLIPSIS /*1L*/
	| function_parameters
	| function_parameters ',' /*2L*/ ELLIPSIS /*1L*/
	| function_parameters ELLIPSIS /*1L*/
	;

function_parameters :
	function_parameter
	| function_parameters ',' /*2L*/ function_parameter
	;

formal_parameter_list :
	%empty
	| ELLIPSIS /*1L*/
	| formal_parameters
	| formal_parameters ',' /*2L*/ ELLIPSIS /*1L*/
	| formal_parameters ELLIPSIS /*1L*/
	;

formal_parameters :
	formal_parameter
	| formal_parameters ',' /*2L*/ formal_parameter
	;

template_parameter_maybe_initialize :
	%empty
	| '=' /*5R*/ no_angle_bracket_const_expr
	;

maybe_initialize :
	%empty
	| '=' /*5R*/ const_expr
	;

maybe_initialize_or_constructor_body :
	';' /*2L*/
	| '{' /*2L*/ code '}'
	| ':' /*4R*/ constructor_inits '{' /*2L*/ code '}'
	| '=' /*5R*/ KW_DEFAULT ';' /*2L*/
	| '=' /*5R*/ KW_DELETE /*22N*/ ';' /*2L*/
	;

maybe_initialize_or_function_body :
	';' /*2L*/
	| '{' /*2L*/ code '}'
	| '=' /*5R*/ const_expr ';' /*2L*/
	| '=' /*5R*/ KW_DEFAULT ';' /*2L*/
	| '=' /*5R*/ KW_DELETE /*22N*/ ';' /*2L*/
	| '=' /*5R*/ '{' /*2L*/ structure_init '}'
	;

structure_init :
	%empty
	| structure_init_body
	| structure_init_body ',' /*2L*/
	;

structure_init_body :
	const_expr
	| '{' /*2L*/ structure_init '}'
	| structure_init_body ',' /*2L*/ const_expr
	| structure_init_body ',' /*2L*/ '{' /*2L*/ structure_init '}'
	;

function_parameter :
	optional_attributes storage_class type formal_parameter_identifier maybe_initialize
	| optional_attributes storage_class type_pack parameter_pack_identifier maybe_initialize
	;

formal_parameter :
	function_parameter
	| formal_const_expr
	;

not_paren_formal_parameter_identifier :
	%empty
	| name_no_final optional_attributes
	| KW_CONST not_paren_formal_parameter_identifier %prec UNARY /*19R*/
	| KW_VOLATILE not_paren_formal_parameter_identifier %prec UNARY /*19R*/
	| KW_RESTRICT not_paren_formal_parameter_identifier %prec UNARY /*19R*/
	| '*' /*17L*/ optional_attributes not_paren_formal_parameter_identifier %prec UNARY /*19R*/
	| '&' /*11L*/ optional_attributes not_paren_formal_parameter_identifier %prec UNARY /*19R*/
	| ANDAND /*8L*/ optional_attributes not_paren_formal_parameter_identifier %prec UNARY /*19R*/
	| SCOPING '*' /*17L*/ optional_attributes not_paren_formal_parameter_identifier %prec UNARY /*19R*/
	| not_paren_formal_parameter_identifier '[' /*20L*/ optional_const_expr ']' optional_attributes
	;

formal_parameter_identifier :
	%empty
	| name_no_final optional_attributes
	| KW_CONST formal_parameter_identifier %prec UNARY /*19R*/
	| KW_VOLATILE formal_parameter_identifier %prec UNARY /*19R*/
	| KW_RESTRICT formal_parameter_identifier %prec UNARY /*19R*/
	| '*' /*17L*/ optional_attributes formal_parameter_identifier %prec UNARY /*19R*/
	| '&' /*11L*/ optional_attributes formal_parameter_identifier %prec UNARY /*19R*/
	| ANDAND /*8L*/ optional_attributes formal_parameter_identifier %prec UNARY /*19R*/
	| SCOPING '*' /*17L*/ optional_attributes formal_parameter_identifier %prec UNARY /*19R*/
	| formal_parameter_identifier '[' /*20L*/ optional_const_expr ']' optional_attributes
	| '(' /*20L*/ formal_parameter_identifier ')' '(' /*20L*/ function_parameter_list ')' function_post optional_attributes
	| '(' /*20L*/ formal_parameter_identifier ')'
	;

parameter_pack_identifier :
	ELLIPSIS /*1L*/
	| ELLIPSIS /*1L*/ name optional_attributes
	| KW_CONST parameter_pack_identifier %prec UNARY /*19R*/
	| KW_VOLATILE parameter_pack_identifier %prec UNARY /*19R*/
	| KW_RESTRICT parameter_pack_identifier %prec UNARY /*19R*/
	| '*' /*17L*/ optional_attributes parameter_pack_identifier %prec UNARY /*19R*/
	| '&' /*11L*/ optional_attributes parameter_pack_identifier %prec UNARY /*19R*/
	| ANDAND /*8L*/ optional_attributes parameter_pack_identifier %prec UNARY /*19R*/
	| SCOPING '*' /*17L*/ optional_attributes parameter_pack_identifier %prec UNARY /*19R*/
	| parameter_pack_identifier '[' /*20L*/ optional_const_expr ']' optional_attributes
	| '(' /*20L*/ parameter_pack_identifier ')' '(' /*20L*/ function_parameter_list ')' function_post optional_attributes
	| '(' /*20L*/ parameter_pack_identifier ')'
	;

not_paren_empty_instance_identifier :
	%empty
	| ELLIPSIS /*1L*/
	| ELLIPSIS /*1L*/ name optional_attributes
	| KW_CONST not_paren_empty_instance_identifier %prec UNARY /*19R*/
	| KW_VOLATILE not_paren_empty_instance_identifier %prec UNARY /*19R*/
	| KW_RESTRICT not_paren_empty_instance_identifier %prec UNARY /*19R*/
	| '*' /*17L*/ optional_attributes not_paren_empty_instance_identifier %prec UNARY /*19R*/
	| '&' /*11L*/ optional_attributes not_paren_empty_instance_identifier %prec UNARY /*19R*/
	| ANDAND /*8L*/ optional_attributes not_paren_empty_instance_identifier %prec UNARY /*19R*/
	| SCOPING '*' /*17L*/ optional_attributes not_paren_empty_instance_identifier %prec UNARY /*19R*/
	| not_paren_empty_instance_identifier '[' /*20L*/ optional_const_expr ']' optional_attributes
	;

empty_instance_identifier :
	%empty
	| ELLIPSIS /*1L*/
	| ELLIPSIS /*1L*/ name optional_attributes
	| KW_CONST empty_instance_identifier %prec UNARY /*19R*/
	| KW_VOLATILE empty_instance_identifier %prec UNARY /*19R*/
	| KW_RESTRICT empty_instance_identifier %prec UNARY /*19R*/
	| '*' /*17L*/ optional_attributes not_paren_empty_instance_identifier %prec UNARY /*19R*/
	| '&' /*11L*/ optional_attributes not_paren_empty_instance_identifier %prec UNARY /*19R*/
	| ANDAND /*8L*/ optional_attributes not_paren_empty_instance_identifier %prec UNARY /*19R*/
	| SCOPING '*' /*17L*/ optional_attributes not_paren_empty_instance_identifier %prec UNARY /*19R*/
	| not_paren_empty_instance_identifier '[' /*20L*/ optional_const_expr ']' optional_attributes
	| '(' /*20L*/ function_parameter_list ')' function_post optional_attributes maybe_trailing_return_type
	| '(' /*20L*/ '*' /*17L*/ optional_attributes not_paren_empty_instance_identifier ')' '(' /*20L*/ function_parameter_list ')' function_post optional_attributes maybe_trailing_return_type
	| '(' /*20L*/ '&' /*11L*/ optional_attributes not_paren_empty_instance_identifier ')' '(' /*20L*/ function_parameter_list ')' function_post optional_attributes maybe_trailing_return_type
	| '(' /*20L*/ ANDAND /*8L*/ optional_attributes not_paren_empty_instance_identifier ')' '(' /*20L*/ function_parameter_list ')' function_post optional_attributes maybe_trailing_return_type
	;

type :
	simple_type
	| TYPENAME_IDENTIFIER /*1L*/
	| KW_TYPENAME /*1L*/ name
	| anonymous_struct
	| named_struct
	| enum
	| struct_keyword optional_attributes name
	| enum_keyword optional_attributes name_no_final ':' /*4R*/ enum_element_type
	| KW_DECLTYPE '(' /*20L*/ const_expr ')'
	| KW_DECLTYPE '(' /*20L*/ KW_AUTO ')'
	| KW_UNDERLYING_TYPE '(' /*20L*/ full_type ')'
	| KW_AUTO
	| KW_BUILTIN_VA_LIST
	;

type_pack :
	TYPEPACK_IDENTIFIER
	;

type_decl :
	simple_type
	| TYPENAME_IDENTIFIER /*1L*/
	| KW_TYPENAME /*1L*/ name
	| anonymous_struct
	| named_struct
	| enum
	| struct_keyword optional_attributes name
	| enum_keyword optional_attributes name_no_final ':' /*4R*/ enum_element_type
	| enum_keyword optional_attributes name
	| KW_DECLTYPE '(' /*20L*/ const_expr ')'
	| KW_DECLTYPE '(' /*20L*/ KW_AUTO ')'
	| KW_UNDERLYING_TYPE '(' /*20L*/ full_type ')'
	| KW_AUTO
	| KW_BUILTIN_VA_LIST
	;

predefined_type :
	simple_type
	| TYPENAME_IDENTIFIER /*1L*/
	| KW_TYPENAME /*1L*/ name
	| struct_keyword optional_attributes name
	| enum_keyword optional_attributes name
	| KW_DECLTYPE '(' /*20L*/ const_expr ')'
	| KW_UNDERLYING_TYPE '(' /*20L*/ full_type ')'
	| KW_AUTO
	| KW_BUILTIN_VA_LIST
	;

var_type_decl :
	type_decl
	| IDENTIFIER /*1L*/
	;

full_type :
	type empty_instance_identifier
	| KW_CONST type empty_instance_identifier
	| type_pack empty_instance_identifier
	| KW_CONST type_pack empty_instance_identifier
	;

anonymous_struct :
	struct_keyword optional_attributes '{' /*2L*/ cpp '}'
	;

named_struct :
	struct_keyword optional_attributes name_no_final maybe_final maybe_class_derivation '{' /*2L*/ cpp '}'
	;

maybe_final :
	%empty
	| KW_FINAL
	;

maybe_class_derivation :
	%empty
	| class_derivation
	;

class_derivation :
	':' /*4R*/ base_specification
	| class_derivation ',' /*2L*/ base_specification
	;

base_specification :
	class_derivation_name
	| KW_PUBLIC class_derivation_name
	| KW_PROTECTED class_derivation_name
	| KW_PRIVATE class_derivation_name
	| KW_VIRTUAL KW_PUBLIC class_derivation_name
	| KW_VIRTUAL KW_PROTECTED class_derivation_name
	| KW_VIRTUAL KW_PRIVATE class_derivation_name
	| KW_PUBLIC KW_VIRTUAL class_derivation_name
	| KW_PROTECTED KW_VIRTUAL class_derivation_name
	| KW_PRIVATE KW_VIRTUAL class_derivation_name
	;

enum :
	enum_decl '{' /*2L*/ enum_body '}'
	;

enum_decl :
	enum_keyword optional_attributes ':' /*4R*/ enum_element_type
	| enum_keyword optional_attributes
	| enum_keyword optional_attributes name_no_final ':' /*4R*/ enum_element_type
	| enum_keyword optional_attributes name_no_final
	;

enum_element_type :
	simple_int_type
	| TYPENAME_IDENTIFIER /*1L*/
	;

enum_body_trailing_comma :
	%empty
	| enum_body_trailing_comma name optional_attributes ',' /*2L*/
	| enum_body_trailing_comma name optional_attributes '=' /*5R*/ const_expr ',' /*2L*/
	;

enum_body :
	enum_body_trailing_comma
	| enum_body_trailing_comma name optional_attributes
	| enum_body_trailing_comma name optional_attributes '=' /*5R*/ const_expr
	;

enum_keyword :
	KW_ENUM /*1L*/
	| KW_ENUM /*1L*/ KW_CLASS
	| KW_ENUM /*1L*/ KW_STRUCT
	;

struct_keyword :
	KW_CLASS
	| KW_STRUCT
	| KW_UNION
	;

namespace_declaration :
	KW_NAMESPACE optional_attributes name '{' /*2L*/ cpp '}'
	| KW_INLINE KW_NAMESPACE name '{' /*2L*/ cpp '}'
	| KW_NAMESPACE '{' /*2L*/ cpp '}'
	| KW_INLINE KW_NAMESPACE '{' /*2L*/ cpp '}'
	;

using_declaration :
	KW_USING name ';' /*2L*/
	| KW_USING name optional_attributes '=' /*5R*/ full_type ';' /*2L*/
	| KW_USING KW_NAMESPACE name ';' /*2L*/
	| KW_USING KW_ENUM /*1L*/ name ';' /*2L*/
	;

simple_type :
	simple_int_type
	| simple_float_type
	| simple_void_type
	;

simple_int_type :
	KW_BOOL /*1L*/
	| KW_CHAR /*1L*/
	| KW_WCHAR_T /*1L*/
	| KW_CHAR8_T /*1L*/
	| KW_CHAR16_T /*1L*/
	| KW_CHAR32_T /*1L*/
	| KW_SHORT /*1L*/
	| KW_LONG /*1L*/
	| KW_UNSIGNED /*1L*/
	| KW_SIGNED /*1L*/
	| KW_INT /*1L*/
	| KW_SHORT /*1L*/ simple_int_type
	| KW_LONG /*1L*/ simple_int_type
	| KW_UNSIGNED /*1L*/ simple_int_type
	| KW_SIGNED /*1L*/ simple_int_type
	;

simple_float_type :
	KW_FLOAT /*1L*/
	| KW_DOUBLE /*1L*/
	| KW_LONG /*1L*/ KW_DOUBLE /*1L*/
	;

simple_void_type :
	KW_VOID
	;

code :
	code_block
	;

code_block :
	%empty
	| code_block element
	;

element :
	REAL
	| INTEGER
	| SIMPLE_STRING
	| STRING_LITERAL
	| CUSTOM_LITERAL
	| CHAR_TOK
	| IDENTIFIER /*1L*/
	| TYPENAME_IDENTIFIER /*1L*/
	| TYPEPACK_IDENTIFIER
	| SCOPING
	| SIMPLE_IDENTIFIER
	| ELLIPSIS /*1L*/
	| OROR /*7L*/
	| ANDAND /*8L*/
	| EQCOMPARE /*12L*/
	| NECOMPARE /*12L*/
	| LECOMPARE /*13L*/
	| GECOMPARE /*13L*/
	| SPACESHIP /*14L*/
	| LSHIFT /*15L*/
	| RSHIFT /*15L*/
	| POINTSAT_STAR /*18L*/
	| DOT_STAR /*18L*/
	| POINTSAT /*20L*/
	| SCOPE /*21R*/
	| PLUSPLUS /*19R*/
	| MINUSMINUS /*19R*/
	| TIMESEQUAL
	| DIVIDEEQUAL
	| MODEQUAL
	| PLUSEQUAL
	| MINUSEQUAL
	| OREQUAL
	| ANDEQUAL
	| XOREQUAL
	| LSHIFTEQUAL
	| RSHIFTEQUAL
	| ATTR_LEFT
	| ATTR_RIGHT
	| KW_ALIGNAS
	| KW_ALIGNOF
	| KW_AUTO
	| KW_BOOL /*1L*/
	| KW_BUILTIN_VA_LIST
	| KW_CATCH /*22N*/
	| KW_CHAR /*1L*/
	| KW_CHAR8_T /*1L*/
	| KW_CHAR16_T /*1L*/
	| KW_CHAR32_T /*1L*/
	| KW_CLASS
	| KW_CONST
	| KW_CONSTEVAL
	| KW_CONSTEXPR
	| KW_CONSTINIT
	| KW_CONST_CAST
	| KW_DECLTYPE
	| KW_DEFAULT
	| KW_DELETE /*22N*/
	| KW_DOUBLE /*1L*/
	| KW_DYNAMIC_CAST
	| KW_ELSE
	| KW_ENUM /*1L*/
	| KW_EXTERN
	| KW_EXPLICIT
	| KW_EXPLICIT_LPAREN
	| KW_FALSE
	| KW_FINAL
	| KW_FLOAT /*1L*/
	| KW_FRIEND
	| KW_FOR
	| KW_GOTO
	| KW_IF
	| KW_INLINE
	| KW_INT /*1L*/
	| KW_LONG /*1L*/
	| KW_MUTABLE
	| KW_NAMESPACE
	| KW_NEW /*22N*/
	| KW_NOEXCEPT
	| KW_NOEXCEPT_LPAREN
	| KW_NULLPTR
	| KW_OPERATOR /*1L*/
	| KW_OVERRIDE
	| KW_PRIVATE
	| KW_PROTECTED
	| KW_PUBLIC
	| KW_PUBLISHED
	| KW_REGISTER
	| KW_REINTERPRET_CAST
	| KW_RESTRICT
	| KW_RETURN
	| KW_SHORT /*1L*/
	| KW_SIGNED /*1L*/
	| KW_SIZEOF
	| KW_STATIC
	| KW_STATIC_ASSERT
	| KW_STATIC_CAST
	| KW_STRUCT
	| KW_TEMPLATE
	| KW_THREAD_LOCAL
	| KW_THROW /*3N*/
	| KW_TRUE
	| KW_TRY /*22N*/
	| KW_TYPEDEF
	| KW_TYPEID
	| KW_TYPENAME /*1L*/
	| KW_UNDERLYING_TYPE
	| KW_UNION
	| KW_UNSIGNED /*1L*/
	| KW_USING
	| KW_VIRTUAL
	| KW_VOID
	| KW_VOLATILE
	| KW_WCHAR_T /*1L*/
	| KW_WHILE
	| '+' /*16L*/
	| '-' /*16L*/
	| '*' /*17L*/
	| '/' /*17L*/
	| '&' /*11L*/
	| '|' /*9L*/
	| '^' /*10L*/
	| '!'
	| '~' /*19R*/
	| '=' /*5R*/
	| '%' /*17L*/
	| '<' /*13L*/
	| '>' /*13L*/
	| '(' /*20L*/
	| ')'
	| '.' /*20L*/
	| ',' /*2L*/
	| ';' /*2L*/
	| ':' /*4R*/
	| '[' /*20L*/
	| ']'
	| '?' /*6R*/
	| '{' /*2L*/ code_block '}'
	;

optional_const_expr :
	%empty
	| const_expr
	;

optional_const_expr_comma :
	%empty
	| const_expr_comma
	;

const_expr_comma :
	const_expr
	| const_expr_comma ',' /*2L*/ const_expr
	;

no_angle_bracket_const_expr :
	const_operand
	| '(' /*20L*/ full_type ')' no_angle_bracket_const_expr %prec UNARY /*19R*/
	| KW_STATIC_CAST '<' /*13L*/ full_type '>' /*13L*/ '(' /*20L*/ const_expr_comma ')'
	| KW_DYNAMIC_CAST '<' /*13L*/ full_type '>' /*13L*/ '(' /*20L*/ const_expr_comma ')'
	| KW_CONST_CAST '<' /*13L*/ full_type '>' /*13L*/ '(' /*20L*/ const_expr_comma ')'
	| KW_REINTERPRET_CAST '<' /*13L*/ full_type '>' /*13L*/ '(' /*20L*/ const_expr_comma ')'
	| KW_SIZEOF '(' /*20L*/ full_type ')' %prec UNARY /*19R*/
	| KW_SIZEOF no_angle_bracket_const_expr %prec UNARY /*19R*/
	| KW_SIZEOF ELLIPSIS /*1L*/ '(' /*20L*/ name ')' %prec UNARY /*19R*/
	| KW_ALIGNOF '(' /*20L*/ full_type ')' %prec UNARY /*19R*/
	| '!' no_angle_bracket_const_expr %prec UNARY /*19R*/
	| '~' /*19R*/ no_angle_bracket_const_expr %prec UNARY /*19R*/
	| '-' /*16L*/ no_angle_bracket_const_expr %prec UNARY /*19R*/
	| '+' /*16L*/ no_angle_bracket_const_expr %prec UNARY /*19R*/
	| '*' /*17L*/ no_angle_bracket_const_expr %prec UNARY /*19R*/
	| '&' /*11L*/ no_angle_bracket_const_expr %prec UNARY /*19R*/
	| no_angle_bracket_const_expr '*' /*17L*/ no_angle_bracket_const_expr
	| no_angle_bracket_const_expr '/' /*17L*/ no_angle_bracket_const_expr
	| no_angle_bracket_const_expr '%' /*17L*/ no_angle_bracket_const_expr
	| no_angle_bracket_const_expr '+' /*16L*/ no_angle_bracket_const_expr
	| no_angle_bracket_const_expr '-' /*16L*/ no_angle_bracket_const_expr
	| no_angle_bracket_const_expr '|' /*9L*/ no_angle_bracket_const_expr
	| no_angle_bracket_const_expr '^' /*10L*/ no_angle_bracket_const_expr
	| no_angle_bracket_const_expr '&' /*11L*/ no_angle_bracket_const_expr
	| no_angle_bracket_const_expr OROR /*7L*/ no_angle_bracket_const_expr
	| no_angle_bracket_const_expr ANDAND /*8L*/ no_angle_bracket_const_expr
	| no_angle_bracket_const_expr EQCOMPARE /*12L*/ no_angle_bracket_const_expr
	| no_angle_bracket_const_expr NECOMPARE /*12L*/ no_angle_bracket_const_expr
	| no_angle_bracket_const_expr LECOMPARE /*13L*/ no_angle_bracket_const_expr
	| no_angle_bracket_const_expr GECOMPARE /*13L*/ no_angle_bracket_const_expr
	| no_angle_bracket_const_expr SPACESHIP /*14L*/ no_angle_bracket_const_expr
	| no_angle_bracket_const_expr LSHIFT /*15L*/ no_angle_bracket_const_expr
	| no_angle_bracket_const_expr RSHIFT /*15L*/ no_angle_bracket_const_expr
	| no_angle_bracket_const_expr '?' /*6R*/ no_angle_bracket_const_expr ':' /*4R*/ no_angle_bracket_const_expr
	| no_angle_bracket_const_expr '[' /*20L*/ const_expr ']'
	| no_angle_bracket_const_expr '(' /*20L*/ const_expr_comma ')'
	| no_angle_bracket_const_expr '(' /*20L*/ ')'
	| no_angle_bracket_const_expr '.' /*20L*/ name
	| no_angle_bracket_const_expr POINTSAT /*20L*/ no_angle_bracket_const_expr
	| '(' /*20L*/ const_expr_comma ')'
	;

const_expr :
	const_operand
	| '(' /*20L*/ full_type ')' const_expr %prec UNARY /*19R*/
	| KW_STATIC_CAST '<' /*13L*/ full_type '>' /*13L*/ '(' /*20L*/ const_expr_comma ')'
	| KW_DYNAMIC_CAST '<' /*13L*/ full_type '>' /*13L*/ '(' /*20L*/ const_expr_comma ')'
	| KW_CONST_CAST '<' /*13L*/ full_type '>' /*13L*/ '(' /*20L*/ const_expr_comma ')'
	| KW_REINTERPRET_CAST '<' /*13L*/ full_type '>' /*13L*/ '(' /*20L*/ const_expr_comma ')'
	| TYPENAME_IDENTIFIER /*1L*/ '(' /*20L*/ optional_const_expr_comma ')'
	| TYPENAME_IDENTIFIER /*1L*/ '{' /*2L*/ optional_const_expr_comma '}'
	| KW_INT /*1L*/ '(' /*20L*/ optional_const_expr_comma ')'
	| KW_CHAR /*1L*/ '(' /*20L*/ optional_const_expr_comma ')'
	| KW_WCHAR_T /*1L*/ '(' /*20L*/ optional_const_expr_comma ')'
	| KW_CHAR8_T /*1L*/ '(' /*20L*/ optional_const_expr_comma ')'
	| KW_CHAR16_T /*1L*/ '(' /*20L*/ optional_const_expr_comma ')'
	| KW_CHAR32_T /*1L*/ '(' /*20L*/ optional_const_expr_comma ')'
	| KW_BOOL /*1L*/ '(' /*20L*/ optional_const_expr_comma ')'
	| KW_SHORT /*1L*/ '(' /*20L*/ optional_const_expr_comma ')'
	| KW_LONG /*1L*/ '(' /*20L*/ optional_const_expr_comma ')'
	| KW_UNSIGNED /*1L*/ '(' /*20L*/ optional_const_expr_comma ')'
	| KW_SIGNED /*1L*/ '(' /*20L*/ optional_const_expr_comma ')'
	| KW_FLOAT /*1L*/ '(' /*20L*/ optional_const_expr_comma ')'
	| KW_DOUBLE /*1L*/ '(' /*20L*/ optional_const_expr_comma ')'
	| KW_SIZEOF '(' /*20L*/ full_type ')' %prec UNARY /*19R*/
	| KW_SIZEOF const_expr %prec UNARY /*19R*/
	| KW_SIZEOF ELLIPSIS /*1L*/ '(' /*20L*/ name ')' %prec UNARY /*19R*/
	| KW_ALIGNOF '(' /*20L*/ full_type ')' %prec UNARY /*19R*/
	| KW_NEW /*22N*/ predefined_type %prec UNARY /*19R*/
	| KW_NEW /*22N*/ predefined_type '(' /*20L*/ optional_const_expr_comma ')' %prec UNARY /*19R*/
	| KW_TYPEID '(' /*20L*/ full_type ')'
	| KW_TYPEID '(' /*20L*/ const_expr ')'
	| '!' const_expr %prec UNARY /*19R*/
	| '~' /*19R*/ const_expr %prec UNARY /*19R*/
	| '-' /*16L*/ const_expr %prec UNARY /*19R*/
	| '+' /*16L*/ const_expr %prec UNARY /*19R*/
	| '*' /*17L*/ const_expr %prec UNARY /*19R*/
	| '&' /*11L*/ const_expr %prec UNARY /*19R*/
	| const_expr '*' /*17L*/ const_expr
	| const_expr '/' /*17L*/ const_expr
	| const_expr '%' /*17L*/ const_expr
	| const_expr '+' /*16L*/ const_expr
	| const_expr '-' /*16L*/ const_expr
	| const_expr '|' /*9L*/ const_expr
	| const_expr '^' /*10L*/ const_expr
	| const_expr '&' /*11L*/ const_expr
	| const_expr OROR /*7L*/ const_expr
	| const_expr ANDAND /*8L*/ const_expr
	| const_expr EQCOMPARE /*12L*/ const_expr
	| const_expr NECOMPARE /*12L*/ const_expr
	| const_expr LECOMPARE /*13L*/ const_expr
	| const_expr GECOMPARE /*13L*/ const_expr
	| const_expr SPACESHIP /*14L*/ const_expr
	| const_expr '<' /*13L*/ const_expr
	| const_expr '>' /*13L*/ const_expr
	| const_expr LSHIFT /*15L*/ const_expr
	| const_expr RSHIFT /*15L*/ const_expr
	| const_expr '?' /*6R*/ const_expr ':' /*4R*/ const_expr
	| const_expr '[' /*20L*/ const_expr ']'
	| const_expr '(' /*20L*/ const_expr_comma ')'
	| const_expr '(' /*20L*/ ')'
	| KW_NOEXCEPT_LPAREN const_expr ')'
	| const_expr '.' /*20L*/ name
	| const_expr POINTSAT /*20L*/ const_expr
	| '(' /*20L*/ const_expr_comma ')'
	;

const_operand :
	INTEGER
	| KW_TRUE
	| KW_FALSE
	| CHAR_TOK
	| REAL
	| string_literal
	| CUSTOM_LITERAL
	| IDENTIFIER /*1L*/
	| KW_FINAL
	| KW_OVERRIDE
	| KW_NULLPTR
	| '[' /*20L*/ capture_list ']' function_post optional_attributes maybe_trailing_return_type '{' /*2L*/ code '}'
	| '[' /*20L*/ capture_list ']' '(' /*20L*/ function_parameter_list ')' function_post optional_attributes maybe_trailing_return_type '{' /*2L*/ code '}'
	| KW_HAS_VIRTUAL_DESTRUCTOR '(' /*20L*/ full_type ')'
	| KW_IS_ABSTRACT '(' /*20L*/ full_type ')'
	| KW_IS_BASE_OF '(' /*20L*/ full_type ',' /*2L*/ full_type ')'
	| KW_IS_CLASS '(' /*20L*/ full_type ')'
	| KW_IS_CONSTRUCTIBLE '(' /*20L*/ full_type ')'
	| KW_IS_CONSTRUCTIBLE '(' /*20L*/ full_type ',' /*2L*/ full_type ')'
	| KW_IS_CONVERTIBLE_TO '(' /*20L*/ full_type ',' /*2L*/ full_type ')'
	| KW_IS_DESTRUCTIBLE '(' /*20L*/ full_type ')'
	| KW_IS_EMPTY '(' /*20L*/ full_type ')'
	| KW_IS_ENUM '(' /*20L*/ full_type ')'
	| KW_IS_FINAL '(' /*20L*/ full_type ')'
	| KW_IS_FUNDAMENTAL '(' /*20L*/ full_type ')'
	| KW_IS_POD '(' /*20L*/ full_type ')'
	| KW_IS_POLYMORPHIC '(' /*20L*/ full_type ')'
	| KW_IS_STANDARD_LAYOUT '(' /*20L*/ full_type ')'
	| KW_IS_TRIVIAL '(' /*20L*/ full_type ')'
	| KW_IS_TRIVIALLY_COPYABLE '(' /*20L*/ full_type ')'
	| KW_IS_UNION '(' /*20L*/ full_type ')'
	;

formal_const_expr :
	formal_const_operand
	| '(' /*20L*/ full_type ')' const_expr %prec UNARY /*19R*/
	| KW_STATIC_CAST '<' /*13L*/ full_type '>' /*13L*/ '(' /*20L*/ const_expr_comma ')'
	| KW_DYNAMIC_CAST '<' /*13L*/ full_type '>' /*13L*/ '(' /*20L*/ const_expr_comma ')'
	| KW_CONST_CAST '<' /*13L*/ full_type '>' /*13L*/ '(' /*20L*/ const_expr_comma ')'
	| KW_REINTERPRET_CAST '<' /*13L*/ full_type '>' /*13L*/ '(' /*20L*/ const_expr_comma ')'
	| KW_SIZEOF '(' /*20L*/ full_type ')' %prec UNARY /*19R*/
	| KW_SIZEOF formal_const_expr %prec UNARY /*19R*/
	| KW_SIZEOF ELLIPSIS /*1L*/ '(' /*20L*/ name ')' %prec UNARY /*19R*/
	| KW_ALIGNOF '(' /*20L*/ full_type ')' %prec UNARY /*19R*/
	| KW_NEW /*22N*/ predefined_type %prec UNARY /*19R*/
	| KW_NEW /*22N*/ predefined_type '(' /*20L*/ optional_const_expr_comma ')' %prec UNARY /*19R*/
	| KW_TYPEID '(' /*20L*/ full_type ')'
	| KW_TYPEID '(' /*20L*/ const_expr ')'
	| '!' const_expr %prec UNARY /*19R*/
	| '~' /*19R*/ const_expr %prec UNARY /*19R*/
	| '-' /*16L*/ const_expr %prec UNARY /*19R*/
	| '+' /*16L*/ const_expr %prec UNARY /*19R*/
	| '&' /*11L*/ const_expr %prec UNARY /*19R*/
	| formal_const_expr '*' /*17L*/ const_expr
	| formal_const_expr '/' /*17L*/ const_expr
	| formal_const_expr '%' /*17L*/ const_expr
	| formal_const_expr '+' /*16L*/ const_expr
	| formal_const_expr '-' /*16L*/ const_expr
	| formal_const_expr '|' /*9L*/ const_expr
	| formal_const_expr '^' /*10L*/ const_expr
	| formal_const_expr '&' /*11L*/ const_expr
	| formal_const_expr OROR /*7L*/ const_expr
	| formal_const_expr ANDAND /*8L*/ const_expr
	| formal_const_expr EQCOMPARE /*12L*/ const_expr
	| formal_const_expr NECOMPARE /*12L*/ const_expr
	| formal_const_expr LECOMPARE /*13L*/ const_expr
	| formal_const_expr GECOMPARE /*13L*/ const_expr
	| formal_const_expr SPACESHIP /*14L*/ const_expr
	| formal_const_expr '<' /*13L*/ const_expr
	| formal_const_expr '>' /*13L*/ const_expr
	| formal_const_expr LSHIFT /*15L*/ const_expr
	| formal_const_expr RSHIFT /*15L*/ const_expr
	| formal_const_expr '?' /*6R*/ const_expr ':' /*4R*/ const_expr
	| formal_const_expr '[' /*20L*/ const_expr ']'
	| formal_const_expr '(' /*20L*/ const_expr_comma ')'
	| formal_const_expr '(' /*20L*/ ')'
	| formal_const_expr '.' /*20L*/ name
	| formal_const_expr POINTSAT /*20L*/ const_expr
	| '(' /*20L*/ const_expr_comma ')'
	;

formal_const_operand :
	INTEGER
	| KW_TRUE
	| KW_FALSE
	| CHAR_TOK
	| REAL
	| string_literal
	| CUSTOM_LITERAL
	| IDENTIFIER /*1L*/
	| KW_FINAL
	| KW_OVERRIDE
	| KW_NULLPTR
	;

capture_list :
	%empty
	| '=' /*5R*/
	| '&' /*11L*/
	| capture maybe_initialize
	| capture_list ',' /*2L*/ capture maybe_initialize
	;

capture :
	'&' /*11L*/ name
	| '&' /*11L*/ name ELLIPSIS /*1L*/
	| name
	| '*' /*17L*/ name
	;

class_derivation_name :
	name
	| KW_TYPENAME /*1L*/ name
	| name ELLIPSIS /*1L*/
	;

name :
	IDENTIFIER /*1L*/
	| TYPENAME_IDENTIFIER /*1L*/
	| TYPEPACK_IDENTIFIER
	| KW_FINAL
	| KW_OVERRIDE
	| KW_SIGNED /*1L*/
	| KW_FLOAT /*1L*/
	| KW_PUBLIC
	| KW_PRIVATE
	| KW_STATIC
	| KW_DEFAULT
	;

name_no_final :
	IDENTIFIER /*1L*/
	| TYPENAME_IDENTIFIER /*1L*/
	| TYPEPACK_IDENTIFIER
	| KW_OVERRIDE
	;

string_literal :
	SIMPLE_STRING
	| STRING_LITERAL
	| string_literal SIMPLE_STRING
	| string_literal STRING_LITERAL
	;

%%

KW_EXPLICIT	"explicit"
KW_NOEXCEPT	"noexcept"

IDENTIFIER	[A-Za-z_][A-Za-z0-9_]*

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"^"	'^'
"~"	'~'
"<"	'<'
"="	'='
">"	'>'
"|"	'|'
"-"	'-'
","	','
";"	';'
":"	':'
"!"	'!'
"?"	'?'
"/"	'/'
"."	'.'
"("	'('
")"	')'
"["	'['
"]"|":>"	']'
"{"	'{'
"}"|"%>"	'}'
"*"	'*'
"&"	'&'
"%"	'%'
"+"	'+'

"alignas"	KW_ALIGNAS
"alignof"	KW_ALIGNOF
"__alignof"	KW_ALIGNOF
"__alignof__"	KW_ALIGNOF
"auto"	KW_AUTO
"__begin_publish"	KW_BEGIN_PUBLISH
"__blocking"	KW_BLOCKING
"bool"	KW_BOOL
"__builtin_va_list"	KW_BUILTIN_VA_LIST
"catch"	KW_CATCH
"char"	KW_CHAR
"char8_t"	KW_CHAR8_T
"char16_t"	KW_CHAR16_T
"char32_t"	KW_CHAR32_T
"class"	KW_CLASS
"const"	KW_CONST
"__const"	KW_CONST
"__const__"	KW_CONST
"consteval"	KW_CONSTEVAL
"constexpr"	KW_CONSTEXPR
"constinit"	KW_CONSTINIT
"const_cast"	KW_CONST_CAST
"decltype"	KW_DECLTYPE
"default"	KW_DEFAULT
"delete"	KW_DELETE
"double"	KW_DOUBLE
"dynamic_cast"	KW_DYNAMIC_CAST
"else"	KW_ELSE
"__end_publish"	KW_END_PUBLISH
"enum"	KW_ENUM
"extern"	KW_EXTERN
"__extension"	KW_EXTENSION
{KW_EXPLICIT}	KW_EXPLICIT
"__published"	KW_PUBLISHED
"false"	KW_FALSE
"final"	KW_FINAL
"float"	KW_FLOAT
"friend"	KW_FRIEND
"for"	KW_FOR
"goto"	KW_GOTO
"__has_virtual_destructor"	KW_HAS_VIRTUAL_DESTRUCTOR
"if"	KW_IF
"inline"	KW_INLINE
"__inline"	KW_INLINE
"__inline__"	KW_INLINE
"int"	KW_INT
"__is_abstract"	KW_IS_ABSTRACT
"__is_base_of"	KW_IS_BASE_OF
"__is_class"	KW_IS_CLASS
"__is_constructible"	KW_IS_CONSTRUCTIBLE
"__is_convertible_to"	KW_IS_CONVERTIBLE_TO
"__is_destructible"	KW_IS_DESTRUCTIBLE
"__is_empty"	KW_IS_EMPTY
"__is_enum"	KW_IS_ENUM
"__is_final"	KW_IS_FINAL
"__is_fundamental"	KW_IS_FUNDAMENTAL
"__is_pod"	KW_IS_POD
"__is_polymorphic"	KW_IS_POLYMORPHIC
"__is_standard_layout"	KW_IS_STANDARD_LAYOUT
"__is_trivial"	KW_IS_TRIVIAL
"__is_trivially_copyable"	KW_IS_TRIVIALLY_COPYABLE
"__is_union"	KW_IS_UNION
"long"	KW_LONG
"__make_map_keys_seq"	KW_MAKE_MAP_KEYS_SEQ
"__make_map_property"	KW_MAKE_MAP_PROPERTY
"__make_property"	KW_MAKE_PROPERTY
"__make_property2"	KW_MAKE_PROPERTY2
"__make_seq"	KW_MAKE_SEQ
"__make_seq_property"	KW_MAKE_SEQ_PROPERTY
"mutable"	KW_MUTABLE
"namespace"	KW_NAMESPACE
{KW_NOEXCEPT}	KW_NOEXCEPT
"nullptr"	KW_NULLPTR
"new"	KW_NEW
"operator"	KW_OPERATOR
"override"	KW_OVERRIDE
"private"	KW_PRIVATE
"protected"	KW_PROTECTED
"public"	KW_PUBLIC
"register"	KW_REGISTER
"reinterpret_cast"	KW_REINTERPRET_CAST
//"restrict"	KW_RESTRICT
"__restrict"	KW_RESTRICT
"__restrict__"	KW_RESTRICT
"return"	KW_RETURN
"short"	KW_SHORT
"signed"	KW_SIGNED
"sizeof"	KW_SIZEOF
"static"	KW_STATIC
"static_assert"	KW_STATIC_ASSERT
"static_cast"	KW_STATIC_CAST
"struct"	KW_STRUCT
"template"	KW_TEMPLATE
"thread_local"	KW_THREAD_LOCAL
"throw"	KW_THROW
"true"	KW_TRUE
"try"	KW_TRY
"typedef"	KW_TYPEDEF
"typeid"	KW_TYPEID
"typename"	KW_TYPENAME
"__underlying_type"	KW_UNDERLYING_TYPE
"union"	KW_UNION
"unsigned"	KW_UNSIGNED
"using"	KW_USING
"virtual"	KW_VIRTUAL
"void"	KW_VOID
"volatile"	KW_VOLATILE
"wchar_t"	KW_WCHAR_T
"while"	KW_WHILE

// These are alternative ways to refer to built-in operators.
"and"|"&&"	ANDAND
"and_eq"|"&="	ANDEQUAL
"bitand"	'&'
"bitor"	'|'
"compl"	'~'
"not"	'!'
"not_eq"|"!="	NECOMPARE
"or"|"||"	OROR
"or_eq"|"|="	OREQUAL
"xor"	'^'
"xor_eq"|"^="	XOREQUAL

"[["	ATTR_LEFT
"]]"	ATTR_RIGHT
"/="	DIVIDEEQUAL
".*"	DOT_STAR
"..."	ELLIPSIS
"=="	EQCOMPARE
">="	GECOMPARE
"("{KW_EXPLICIT}	KW_EXPLICIT_LPAREN
"("{KW_NOEXCEPT}	KW_NOEXCEPT_LPAREN
"<="	LECOMPARE
"<<"	LSHIFT
"<<="	LSHIFTEQUAL
"-="	MINUSEQUAL
"--"	MINUSMINUS
"%="	MODEQUAL
"*="	PLUSEQUAL
"++"	PLUSPLUS
"->"	POINTSAT
"->*"	POINTSAT_STAR
">>"	RSHIFT
">>"	RSHIFTEQUAL
"::"	SCOPE
SCOPING	SCOPING
"<=>"	SPACESHIP
START_CONST_EXPR	START_CONST_EXPR
START_CPP	START_CPP
START_TYPE	START_TYPE
"*="	TIMESEQUAL

'(\\.|[^'\r\n\\])'	CHAR_TOK
CUSTOM_LITERAL	CUSTOM_LITERAL

\"(\\.|[^"\r\n\\])*\"	STRING_LITERAL
"__FILE__"|"__LINE__"	SIMPLE_STRING

[0-9]+	INTEGER
[0-9]+"."[0-9]*	REAL

SIMPLE_IDENTIFIER	SIMPLE_IDENTIFIER
TYPENAME_IDENTIFIER	TYPENAME_IDENTIFIER
TYPEPACK_IDENTIFIER	TYPEPACK_IDENTIFIER
{IDENTIFIER}	IDENTIFIER

%%
