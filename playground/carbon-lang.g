//From: https://github.com/carbon-language/carbon-lang/tree/trunk/explorer/syntax

/*Tokens*/
//%token END_OF_FILE
%token integer_literal
%token identifier
%token intrinsic_identifier
%token sized_type_literal
%token string_literal
%token ABSTRACT
%token ADDR
%token ALIAS
%token AMPERSAND
%token AMPERSAND_EQUAL
%token AND
%token API
%token ARROW
%token AS
%token AUTO
%token BASE
%token BOOL
%token BREAK
%token CARET
%token CARET_EQUAL
%token CASE
%token CHOICE
%token CLASS
%token COLON
%token COLON_BANG
%token COMMA
%token CONSTRAINT
%token CONTINUE
%token DEFAULT
%token DESTRUCTOR
%token DOUBLE_ARROW
%token ELSE
%token EQUAL
%token EQUAL_EQUAL
%token EXTEND
%token FALSE
%token FN
%token FN_TYPE
%token FOR
%token FORALL
%token GREATER
%token GREATER_EQUAL
%token GREATER_GREATER
%token GREATER_GREATER_EQUAL
%token IF
%token IMPL
%token IMPLS
%token IMPORT
%token IN
%token INTERFACE
%token LEFT_CURLY_BRACE
%token LEFT_PARENTHESIS
%token LEFT_SQUARE_BRACKET
%token LESS
%token LESS_EQUAL
%token LESS_LESS
%token LESS_LESS_EQUAL
%token LET
%token LIBRARY
%token MATCH
%token MATCH_FIRST
%token MINUS
%token MINUS_EQUAL
%token MINUS_MINUS
%token MIX
%token MIXIN
%token NAMESPACE
%token NOT
%token NOT_EQUAL
%token OR
//%token OR_EQUAL
%token PACKAGE
%token PERCENT
%token PERCENT_EQUAL
%token PERIOD
%token PIPE
%token PIPE_EQUAL
%token PLUS
%token PLUS_EQUAL
%token PLUS_PLUS
%token REQUIRE
%token RETURN
%token RETURNED
%token RIGHT_CURLY_BRACE
%token RIGHT_PARENTHESIS
%token RIGHT_SQUARE_BRACKET
%token SELF
%token SEMICOLON
%token SLASH
%token SLASH_EQUAL
%token STAR_EQUAL
%token STRING
%token TEMPLATE
%token THEN
%token TRUE
%token TYPE
%token UNDERSCORE
%token UNIMPL_EXAMPLE
%token VAR
%token VIRTUAL
%token WHERE
%token WHILE
//%token FNARROW
%token UNARY_STAR
%token PREFIX_STAR
%token POSTFIX_STAR
%token BINARY_STAR

%token ILLEGAL_CHARACTER

%start input

%%

input :
	/*END_OF_FILE
	|*/ package_directive import_directives top_level_declaration_list
	;

package_directive :
	PACKAGE identifier optional_library_path api_or_impl SEMICOLON
	;

import_directive :
	IMPORT identifier optional_library_path SEMICOLON
	;

import_directives :
	/*empty*/
	| import_directives import_directive
	;

optional_library_path :
	/*empty*/
	| LIBRARY string_literal
	;

api_or_impl :
	API
	| IMPL
	;

primary_expression :
	identifier
	| designator
	| PERIOD SELF
	| integer_literal
	| string_literal
	| TRUE
	| FALSE
	| sized_type_literal
	| SELF
	| STRING
	| BOOL
	| TYPE
	| paren_expression
	| struct_literal
	| struct_type_literal
	| LEFT_SQUARE_BRACKET expression SEMICOLON expression RIGHT_SQUARE_BRACKET
	| LEFT_SQUARE_BRACKET expression SEMICOLON RIGHT_SQUARE_BRACKET
	;

postfix_expression :
	primary_expression
	| postfix_expression designator
	| postfix_expression ARROW identifier
	| postfix_expression PERIOD LEFT_PARENTHESIS expression RIGHT_PARENTHESIS
	| postfix_expression ARROW LEFT_PARENTHESIS expression RIGHT_PARENTHESIS
	| postfix_expression LEFT_SQUARE_BRACKET expression RIGHT_SQUARE_BRACKET
	| intrinsic_identifier tuple
	| postfix_expression tuple
	| postfix_expression POSTFIX_STAR
	| postfix_expression UNARY_STAR
	;

ref_deref_expression :
	postfix_expression
	| PREFIX_STAR ref_deref_expression
	| UNARY_STAR ref_deref_expression
	| AMPERSAND ref_deref_expression
	;

fn_type_expression :
	FN_TYPE tuple ARROW type_expression
	;

type_expression :
	ref_deref_expression
	| bitwise_and_expression
	| fn_type_expression
	;

minus_expression :
	MINUS ref_deref_expression
	;

complement_expression :
	CARET ref_deref_expression
	;

unary_expression :
	minus_expression
	| complement_expression
	;

simple_binary_operand :
	ref_deref_expression
	| unary_expression
	;

multiplicative_lhs :
	simple_binary_operand
	| multiplicative_expression
	;

multiplicative_expression :
	multiplicative_lhs BINARY_STAR simple_binary_operand
	| multiplicative_lhs SLASH simple_binary_operand
	;

additive_operand :
	simple_binary_operand
	| multiplicative_expression
	;

additive_lhs :
	simple_binary_operand
	| additive_expression
	;

additive_expression :
	multiplicative_expression
	| additive_lhs PLUS additive_operand
	| additive_lhs MINUS additive_operand
	;

modulo_expression :
	simple_binary_operand PERCENT simple_binary_operand
	;

bitwise_and_lhs :
	simple_binary_operand
	| bitwise_and_expression
	;

bitwise_and_expression :
	bitwise_and_lhs AMPERSAND simple_binary_operand
	;

bitwise_or_lhs :
	simple_binary_operand
	| bitwise_or_expression
	;

bitwise_or_expression :
	bitwise_or_lhs PIPE simple_binary_operand
	;

bitwise_xor_lhs :
	simple_binary_operand
	| bitwise_xor_expression
	;

bitwise_xor_expression :
	bitwise_xor_lhs CARET simple_binary_operand
	;

bitwise_expression :
	bitwise_and_expression
	| bitwise_or_expression
	| bitwise_xor_expression
	;

bit_shift_expression :
	simple_binary_operand LESS_LESS simple_binary_operand
	| simple_binary_operand GREATER_GREATER simple_binary_operand
	;

as_expression :
	simple_binary_operand AS simple_binary_operand
	;

unimpl_expression :
	ref_deref_expression UNIMPL_EXAMPLE ref_deref_expression
	;

value_expression :
	additive_expression
	| as_expression
	| bitwise_expression
	| bit_shift_expression
	| fn_type_expression
	| modulo_expression
	| unary_expression
	| unimpl_expression
	;

comparison_operand :
	ref_deref_expression
	| value_expression
	;

comparison_operator :
	EQUAL_EQUAL
	| LESS
	| LESS_EQUAL
	| GREATER
	| GREATER_EQUAL
	| NOT_EQUAL
	;

comparison_expression :
	value_expression
	| comparison_operand comparison_operator comparison_operand
	;

not_expression :
	NOT ref_deref_expression
	;

predicate_expression :
	not_expression
	| comparison_expression
	;

and_or_operand :
	ref_deref_expression
	| predicate_expression
	;

and_lhs :
	and_or_operand
	| and_expression
	;

and_expression :
	and_lhs AND and_or_operand
	;

or_lhs :
	and_or_operand
	| or_expression
	;

or_expression :
	or_lhs OR and_or_operand
	;

where_clause :
	comparison_operand IMPLS comparison_operand
	| comparison_operand EQUAL_EQUAL comparison_operand
	| designator EQUAL comparison_operand
	;

where_clause_list :
	where_clause
	| where_clause_list AND where_clause
	;

where_expression :
	type_expression WHERE where_clause_list
	;

type_or_where_expression :
	type_expression
	| where_expression
	;

statement_expression :
	ref_deref_expression
	| predicate_expression
	| and_expression
	| or_expression
	| where_expression
	;

if_expression :
	statement_expression
	| IF expression THEN if_expression ELSE if_expression
	;

expression :
	if_expression
	;

designator :
	PERIOD identifier
	| PERIOD BASE
	;

paren_expression :
	paren_expression_base
	;

tuple :
	paren_expression_base
	;

paren_expression_base :
	LEFT_PARENTHESIS RIGHT_PARENTHESIS
	| LEFT_PARENTHESIS paren_expression_contents RIGHT_PARENTHESIS
	| LEFT_PARENTHESIS paren_expression_contents COMMA RIGHT_PARENTHESIS
	;

paren_expression_contents :
	expression
	| paren_expression_contents COMMA expression
	;

struct_literal :
	LEFT_CURLY_BRACE RIGHT_CURLY_BRACE
	| LEFT_CURLY_BRACE struct_literal_contents RIGHT_CURLY_BRACE
	| LEFT_CURLY_BRACE struct_literal_contents COMMA RIGHT_CURLY_BRACE
	;

struct_literal_contents :
	designator EQUAL expression
	| struct_literal_contents COMMA designator EQUAL expression
	;

struct_type_literal :
	LEFT_CURLY_BRACE struct_type_literal_contents RIGHT_CURLY_BRACE
	| LEFT_CURLY_BRACE struct_type_literal_contents COMMA RIGHT_CURLY_BRACE
	;

struct_type_literal_contents :
	designator COLON expression
	| struct_type_literal_contents COMMA designator COLON expression
	;

pattern :
	non_expression_pattern
	| expression
	;

non_expression_pattern :
	AUTO
	| binding_lhs COLON pattern
	| binding_lhs COLON_BANG expression
	| TEMPLATE binding_lhs COLON_BANG expression
	| paren_pattern
	| postfix_expression tuple_pattern
	| VAR non_expression_pattern
	;

binding_lhs :
	identifier
	| UNDERSCORE
	;

paren_pattern :
	paren_pattern_base
	;

paren_pattern_base :
	LEFT_PARENTHESIS paren_pattern_contents RIGHT_PARENTHESIS
	| LEFT_PARENTHESIS paren_pattern_contents COMMA RIGHT_PARENTHESIS
	;

paren_pattern_contents :
	non_expression_pattern
	| paren_expression_contents COMMA non_expression_pattern
	| paren_pattern_contents COMMA expression
	| paren_pattern_contents COMMA non_expression_pattern
	;

tuple_pattern :
	paren_pattern_base
	;

maybe_empty_tuple_pattern :
	LEFT_PARENTHESIS RIGHT_PARENTHESIS
	| tuple_pattern
	;

clause :
	CASE pattern DOUBLE_ARROW block
	| DEFAULT DOUBLE_ARROW block
	;

clause_list :
	/*empty*/
	| clause_list clause
	;

statement :
	assign_statement
	| VAR pattern SEMICOLON
	| VAR pattern EQUAL expression SEMICOLON
	| RETURNED VAR variable_declaration SEMICOLON
	| RETURNED VAR variable_declaration EQUAL expression SEMICOLON
	| LET pattern EQUAL expression SEMICOLON
	| statement_expression SEMICOLON
	| if_statement
	| WHILE LEFT_PARENTHESIS expression RIGHT_PARENTHESIS block
	| BREAK SEMICOLON
	| CONTINUE SEMICOLON
	| RETURN return_expression SEMICOLON
	| RETURN VAR SEMICOLON
	| MATCH LEFT_PARENTHESIS expression RIGHT_PARENTHESIS LEFT_CURLY_BRACE clause_list RIGHT_CURLY_BRACE
	| FOR LEFT_PARENTHESIS variable_declaration IN type_expression RIGHT_PARENTHESIS block
	;

assign_statement :
	statement_expression assign_operator expression SEMICOLON
	| PLUS_PLUS expression SEMICOLON
	| MINUS_MINUS expression SEMICOLON
	;

assign_operator :
	EQUAL
	| PLUS_EQUAL
	| SLASH_EQUAL
	| STAR_EQUAL
	| PERCENT_EQUAL
	| MINUS_EQUAL
	| AMPERSAND_EQUAL
	| PIPE_EQUAL
	| CARET_EQUAL
	| LESS_LESS_EQUAL
	| GREATER_GREATER_EQUAL
	;

if_statement :
	IF LEFT_PARENTHESIS expression RIGHT_PARENTHESIS block optional_else
	;

optional_else :
	/*empty*/
	| ELSE if_statement
	| ELSE block
	;

return_expression :
	/*empty*/
	| expression
	;

statement_list :
	/*empty*/
	| statement_list statement
	;

block :
	LEFT_CURLY_BRACE statement_list RIGHT_CURLY_BRACE
	;

return_term :
	/*empty*/
	| ARROW AUTO
	| ARROW expression
	;

generic_binding :
	identifier COLON_BANG expression
	| TEMPLATE identifier COLON_BANG expression
	;

deduced_param :
	generic_binding
	| variable_declaration
	| ADDR variable_declaration
	;

deduced_param_list :
	/*empty*/
	| deduced_param
	| deduced_param_list COMMA deduced_param
	;

deduced_params :
	/*empty*/
	| LEFT_SQUARE_BRACKET deduced_param_list RIGHT_SQUARE_BRACKET
	;

impl_deduced_params :
	/*empty*/
	| FORALL LEFT_SQUARE_BRACKET deduced_param_list RIGHT_SQUARE_BRACKET
	;

declared_name :
	identifier
	| declared_name PERIOD identifier
	| LEFT_PARENTHESIS declared_name RIGHT_PARENTHESIS
	;

fn_virtual_override_intro :
	FN
	| ABSTRACT FN
	| VIRTUAL FN
	| IMPL FN
	;

function_declaration :
	fn_virtual_override_intro declared_name deduced_params maybe_empty_tuple_pattern return_term block
	| fn_virtual_override_intro declared_name deduced_params maybe_empty_tuple_pattern return_term SEMICOLON
	;

variable_declaration :
	identifier COLON pattern
	;

alias_declaration :
	ALIAS declared_name EQUAL expression SEMICOLON
	;

mix_declaration :
	MIX expression SEMICOLON
	;

alternative :
	identifier tuple
	| identifier
	;

alternative_list :
	/*empty*/
	| alternative_list_contents
	| alternative_list_contents COMMA
	;

alternative_list_contents :
	alternative
	| alternative_list_contents COMMA alternative
	;

type_params :
	/*empty*/
	| tuple_pattern
	;

mixin_import :
	/*empty*/
	| FOR expression
	;

class_declaration_extensibility :
	/*empty*/
	| ABSTRACT
	| BASE
	;

declaration :
	function_declaration
	| destructor_declaration
	| class_declaration_extensibility CLASS declared_name type_params LEFT_CURLY_BRACE class_body RIGHT_CURLY_BRACE
	| MIXIN declared_name type_params mixin_import LEFT_CURLY_BRACE mixin_body RIGHT_CURLY_BRACE
	| CHOICE declared_name type_params LEFT_CURLY_BRACE alternative_list RIGHT_CURLY_BRACE
	| VAR variable_declaration SEMICOLON
	| VAR variable_declaration EQUAL expression SEMICOLON
	| LET variable_declaration EQUAL expression SEMICOLON
	| INTERFACE declared_name type_params LEFT_CURLY_BRACE interface_body RIGHT_CURLY_BRACE
	| CONSTRAINT declared_name type_params LEFT_CURLY_BRACE interface_body RIGHT_CURLY_BRACE
	| impl_declaration
	| match_first_declaration
	| alias_declaration
	;

impl_declaration :
	IMPL impl_deduced_params impl_type AS type_or_where_expression LEFT_CURLY_BRACE impl_body RIGHT_CURLY_BRACE
	;

extend_impl_declaration :
	EXTEND IMPL no_impl_type AS type_or_where_expression LEFT_CURLY_BRACE impl_body RIGHT_CURLY_BRACE
	;

impl_type :
	/*empty*/
	| type_expression
	;

no_impl_type :
	/*empty*/
	;

match_first_declaration :
	MATCH_FIRST LEFT_CURLY_BRACE match_first_declaration_list RIGHT_CURLY_BRACE
	;

match_first_declaration_list :
	/*empty*/
	| match_first_declaration_list impl_declaration
	;

destructor_virtual_override_intro :
	DESTRUCTOR
	| VIRTUAL DESTRUCTOR
	| IMPL DESTRUCTOR
	;

destructor_declaration :
	destructor_virtual_override_intro deduced_params block
	;

namespace_declaration :
	NAMESPACE declared_name SEMICOLON
	;

top_level_declaration_list :
	/*empty*/
	| top_level_declaration_list declaration
	| top_level_declaration_list namespace_declaration
	;

extend_base_declaration :
	EXTEND BASE COLON expression SEMICOLON
	;

class_body :
	/*empty*/
	| class_body declaration
	| class_body mix_declaration
	| class_body extend_base_declaration
	| class_body extend_impl_declaration
	;

mixin_body :
	/*empty*/
	| mixin_body function_declaration
	| mixin_body mix_declaration
	;

interface_body :
	/*empty*/
	| interface_body function_declaration
	| interface_body LET generic_binding SEMICOLON
	| interface_body EXTEND expression SEMICOLON
	| interface_body REQUIRE type_expression IMPLS type_or_where_expression SEMICOLON
	;

impl_body :
	/*empty*/
	| impl_body function_declaration
	| impl_body alias_declaration
	;

%%

/* Lexing a token immediately after consuming some whitespace. */
%x AFTER_WHITESPACE
/*
 * Lexing a token immediately after consuming an operand-ending token:
 * a closing bracket, identifier, or literal.
 */
%x AFTER_OPERAND AFTER_OPERAND_BACKTRACK

/* This should be kept table-like, but isn't automatic due to spaces. */
identifier            [A-Za-z_][A-Za-z0-9_]*
/* TODO: Remove Print special casing once we have variadics or overloads. */
intrinsic_identifier  (Print|__intrinsic_[A-Za-z0-9_]*)
sized_type_literal    [iuf][1-9][0-9]*
integer_literal       ([0-9]+|0x[A-Fa-f0-9]+|0b[01]+)
horizontal_whitespace [ \t\r]
whitespace            {horizontal_whitespace}|[\n]
one_line_comment      \/\/[^\n]*\n
operand_start         [(A-Za-z0-9_\"]

%%

/* table-begin */
"abstract"	ABSTRACT
"addr"	ADDR
"alias"	ALIAS
"&"	AMPERSAND
"&="	AMPERSAND_EQUAL
"and"	AND
"api"	API
"->"	ARROW
"as"	AS
"auto"	AUTO
"base"	BASE
"bool"	BOOL
"break"	BREAK
"^"	CARET
"^="	CARET_EQUAL
"case"	CASE
"choice"	CHOICE
"class"	CLASS
":"	COLON
":!"	COLON_BANG
","	COMMA
"constraint"	CONSTRAINT
"continue"	CONTINUE
"default"	DEFAULT
"destructor"	DESTRUCTOR
"=>"	DOUBLE_ARROW
"else"	ELSE
"="	EQUAL
"=="	EQUAL_EQUAL
"extend"	EXTEND
"false"	FALSE
"fn"	FN
"__Fn"	FN_TYPE
"for"	FOR
"forall"	FORALL
">"	GREATER
">="	GREATER_EQUAL
">>"	GREATER_GREATER
">>="	GREATER_GREATER_EQUAL
"if"	IF
"impl"	IMPL
"impls"	IMPLS
"import"	IMPORT
"in"	IN
"interface"	INTERFACE
"{"	LEFT_CURLY_BRACE
"("	LEFT_PARENTHESIS
"["	LEFT_SQUARE_BRACKET
"<"	LESS
"<="	LESS_EQUAL
"<<"	LESS_LESS
"<<="	LESS_LESS_EQUAL
"let"	LET
"library"	LIBRARY
"match"	MATCH
"__match_first"	MATCH_FIRST
"-"	MINUS
"-="	MINUS_EQUAL
"--"	MINUS_MINUS
"__mix"	MIX
"__mixin"	MIXIN
"namespace"	NAMESPACE
"not"	NOT
"!="	NOT_EQUAL
"or"	OR
"package"	PACKAGE
"%"	PERCENT
"%="	PERCENT_EQUAL
"."	PERIOD
"|"	PIPE
"|="	PIPE_EQUAL
"+"	PLUS
"+="	PLUS_EQUAL
"++"	PLUS_PLUS
"require"	REQUIRE
"return"	RETURN
"returned"	RETURNED
<INITIAL>"}"<AFTER_OPERAND>	RIGHT_CURLY_BRACE
<INITIAL>")"<AFTER_OPERAND>	RIGHT_PARENTHESIS
<INITIAL>"]"<AFTER_OPERAND>	RIGHT_SQUARE_BRACKET
"Self"	SELF
";"	SEMICOLON
"/"	SLASH
"/="	SLASH_EQUAL
"*="	STAR_EQUAL
"String"	STRING
"template"	TEMPLATE
"then"	THEN
"true"	TRUE
"type"	TYPE
"_"	UNDERSCORE
"__unimplemented_example_infix"	UNIMPL_EXAMPLE
"var"	VAR
"virtual"	VIRTUAL
"where"	WHERE
"while"	WHILE
/* table-end */

  /*
  * For a `*` operator, we look at whitespace and local context to determine the
  * arity and fixity. There are two ways to write a binary operator:
  *
  * 1) Whitespace on both sides.
  * 2) Whitespace on neither side, and the previous token is considered to be
  *    the end of an operand, and the next token is considered to be the start
  *    of an operand.
  *
  * Otherwise, the operator is unary, but we also check for whitespace to help
  * the parser enforce the rule that whitespace is not permitted between the
  * operator and its operand, leading to three more cases:
  *
  * 3) Whitespace before (but implicitly not after, because that would give a
  *    longer match and hit case 1): this can only be a prefix operator.
  * 4) Whitespace after and not before: this can only be a postfix operator.
  * 5) No whitespace on either side (otherwise the longest match would take us
  *    to case 4): this is a unary operator and could be either prefix or
  *    postfix.
  */

 /* `*` operator case 1: */
<AFTER_WHITESPACE>"*"{whitespace}+<.> BINARY_STAR
 /* `*` operator case 2: */
/*<AFTER_OPERAND>"*"/{operand_start}<INITIAL>	BINARY_STAR*/
<AFTER_OPERAND>"*"{operand_start}<AFTER_OPERAND_BACKTRACK>	reject()
<AFTER_OPERAND_BACKTRACK>"*"<INITIAL>	BINARY_STAR
 /* `*` operator case 3: */
<AFTER_WHITESPACE>"*"<INITIAL>	PREFIX_STAR
 /* `*` operator case 4: */
<INITIAL,AFTER_OPERAND>"*"{whitespace}+<AFTER_WHITESPACE>	POSTFIX_STAR

 /* `*` operator case 5: */
<INITIAL,AFTER_OPERAND>"*"<INITIAL>	UNARY_STAR

/*Exit state*/
<AFTER_WHITESPACE,AFTER_OPERAND>(?s:[^*])<INITIAL> reject()

<INITIAL>{sized_type_literal}<AFTER_OPERAND>	sized_type_literal

<INITIAL>{intrinsic_identifier}<AFTER_OPERAND>	intrinsic_identifier

<INITIAL>{identifier}<AFTER_OPERAND>	identifier

<INITIAL>{integer_literal}<AFTER_OPERAND>	integer_literal

/*#*\"*/
\"(\\.|[^\"\r\n\\])*\" string_literal

/*#*\'\'\'*/
'''(\\.|[^'\\])+''' string_literal

{one_line_comment}	skip()

<INITIAL>{whitespace}+<AFTER_WHITESPACE> skip()

.	ILLEGAL_CHARACTER

%%
