//From: https://github.com/GNOME/vala/blob/843551ed85dcfcfdf803fa6961ccd5498a9cee8a/gobject-introspection/scannerparser.y
/* GObject introspection: C parser
 *
 * Copyright (c) 1997 Sandro Sigala  <ssigala@globalnet.it>
 * Copyright (c) 2007-2008 Jürg Billeter  <j@bitron.ch>
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*Tokens*/
%token ADDEQ
%token ANDAND
%token ANDEQ
%token ARROW
%token AUTO
%token BOOL
%token BREAK
%token CASE
%token CHAR
%token CHARACTER
%token CONST
%token CONTINUE
%token DEFAULT
%token DIVEQ
%token DO
%token DOUBLE
%token ELLIPSIS
%token ELSE
%token ENUM
%token EQ
%token EXTERN
%token FLOAT
%token FLOATING
%token FOR
%token FUNCTION_MACRO
%token GOTO
%token GTEQ
%token IDENTIFIER
%token IF
%token INLINE
%token INT
%token INTEGER
%token LONG
%token LTEQ
%token MINUSMINUS
%token MODEQ
%token MULEQ
%token NOTEQ
%token OBJECT_MACRO
%token OREQ
%token OROR
%token PLUSPLUS
%token REGISTER
%token RESTRICT
%token RETURN
%token SHORT
%token SIGNED
%token SIZEOF
%token SL
%token SLEQ
%token SR
%token SREQ
%token STATIC
%token STRING
%token STRUCT
%token SUBEQ
%token SWITCH
%token TYPEDEF
%token TYPEDEF_NAME
%token UNION
%token UNSIGNED
%token VOID
%token VOLATILE
%token WHILE
%token XOREQ


%start translation_unit

%%

primary_expression :
	identifier
	| INTEGER
	| CHARACTER
	| FLOATING
	| strings
	| '(' expression ')'
	;

strings :
	STRING
	| strings STRING
	;

identifier :
	IDENTIFIER
	;

identifier_or_typedef_name :
	identifier
	| typedef_name
	;

postfix_expression :
	primary_expression
	| postfix_expression '[' expression ']'
	| postfix_expression '(' argument_expression_list ')'
	| postfix_expression '(' ')'
	| postfix_expression '.' identifier_or_typedef_name
	| postfix_expression ARROW identifier_or_typedef_name
	| postfix_expression PLUSPLUS
	| postfix_expression MINUSMINUS
	;

argument_expression_list :
	assignment_expression
	| argument_expression_list ',' assignment_expression
	;

unary_expression :
	postfix_expression
	| PLUSPLUS unary_expression
	| MINUSMINUS unary_expression
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
	| shift_expression SL additive_expression
	| shift_expression SR additive_expression
	;

relational_expression :
	shift_expression
	| relational_expression '<' shift_expression
	| relational_expression '>' shift_expression
	| relational_expression LTEQ shift_expression
	| relational_expression GTEQ shift_expression
	;

equality_expression :
	relational_expression
	| equality_expression EQ relational_expression
	| equality_expression NOTEQ relational_expression
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
	| logical_and_expression ANDAND inclusive_or_expression
	;

logical_or_expression :
	logical_and_expression
	| logical_or_expression OROR logical_and_expression
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
	| MULEQ
	| DIVEQ
	| MODEQ
	| ADDEQ
	| SUBEQ
	| SLEQ
	| SREQ
	| ANDEQ
	| XOREQ
	| OREQ
	;

expression :
	assignment_expression
	| expression ',' assignment_expression
	;

constant_expression :
	conditional_expression
	;

declaration :
	declaration_specifiers init_declarator_list ';'
	| declaration_specifiers ';'
	;

declaration_specifiers :
	storage_class_specifier declaration_specifiers
	| storage_class_specifier
	| type_specifier declaration_specifiers
	| type_specifier
	| type_qualifier declaration_specifiers
	| type_qualifier
	| function_specifier declaration_specifiers
	| function_specifier
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
	| struct_or_union_specifier
	| enum_specifier
	| typedef_name
	;

struct_or_union_specifier :
	struct_or_union identifier_or_typedef_name '{' struct_declaration_list '}'
	| struct_or_union '{' struct_declaration_list '}'
	| struct_or_union identifier_or_typedef_name
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
	/*empty*/
	| declarator
	| ':' constant_expression
	| declarator ':' constant_expression
	;

enum_specifier :
	ENUM identifier_or_typedef_name '{' enumerator_list '}'
	| ENUM '{' enumerator_list '}'
	| ENUM identifier_or_typedef_name '{' enumerator_list ',' '}'
	| ENUM '{' enumerator_list ',' '}'
	| ENUM identifier_or_typedef_name
	;

enumerator_list :
	enumerator
	| enumerator_list ',' enumerator
	;

enumerator :
	identifier
	| identifier '=' constant_expression
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
	identifier
	| '(' declarator ')'
	| direct_declarator '[' assignment_expression ']'
	| direct_declarator '[' ']'
	| direct_declarator '(' parameter_type_list ')'
	| direct_declarator '(' identifier_list ')'
	| direct_declarator '(' ')'
	;

pointer :
	'*' type_qualifier_list
	| '*'
	| '*' type_qualifier_list pointer
	| '*' pointer
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
	identifier
	| identifier_list ',' identifier
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
	| '(' ')'
	| '(' parameter_type_list ')'
	| direct_abstract_declarator '(' ')'
	| direct_abstract_declarator '(' parameter_type_list ')'
	;

typedef_name :
	TYPEDEF_NAME
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

statement :
	labeled_statement
	| compound_statement
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	;

labeled_statement :
	identifier_or_typedef_name ':' statement
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
	;

selection_statement :
	IF '(' expression ')' statement
	| IF '(' expression ')' statement ELSE statement
	| SWITCH '(' expression ')' statement
	;

iteration_statement :
	WHILE '(' expression ')' statement
	| DO statement WHILE '(' expression ')' ';'
	| FOR '(' ';' ';' ')' statement
	| FOR '(' expression ';' ';' ')' statement
	| FOR '(' ';' expression ';' ')' statement
	| FOR '(' expression ';' expression ';' ')' statement
	| FOR '(' ';' ';' expression ')' statement
	| FOR '(' expression ';' ';' expression ')' statement
	| FOR '(' ';' expression ';' expression ')' statement
	| FOR '(' expression ';' expression ';' expression ')' statement
	;

jump_statement :
	GOTO identifier_or_typedef_name ';'
	| CONTINUE ';'
	| BREAK ';'
	| RETURN ';'
	| RETURN expression ';'
	;

translation_unit :
	%empty
	| translation_unit external_declaration
	;

external_declaration :
	function_definition
	| declaration
	| macro
	;

function_definition :
	declaration_specifiers declarator declaration_list compound_statement
	| declaration_specifiers declarator compound_statement
	;

declaration_list :
	declaration
	| declaration_list declaration
	;

function_macro :
	FUNCTION_MACRO
	;

object_macro :
	OBJECT_MACRO
	;

function_macro_define :
	function_macro '(' identifier_list ')'
	;

object_macro_define :
	object_macro constant_expression
	;

macro :
	function_macro_define
	| object_macro_define
	//| error
	;

%%

intsuffix				([uU][lL]?[lL]?)|([lL][lL]?[uU]?)
fracconst				([0-9]*\.[0-9]+)|([0-9]+\.)
exppart					[eE][-+]?[0-9]+
floatsuffix				[fFlL]
chartext				([^\\\'])|(\\.)
stringtext				([^\\\"])|(\\.)

%%

[\t\f\v\r\n ]+	skip()

"/*"(?s:.)*?"*/"	skip()
"//".*	skip()

"#define "[a-zA-Z_][a-zA-Z_0-9]*"("	FUNCTION_MACRO
"#define "[a-zA-Z_][a-zA-Z_0-9]*	OBJECT_MACRO

"# "[0-9]+" ".*"\n"			skip()
"#line "[0-9]+" ".*"\n"			skip()
"#"			                skip()
"{"					'{'
"<%"					'{'
"}"					'}'
"%>"					'}'
"["					'['
"<:"					'['
"]"					']'
":>"					']'
"("					'('
")"					')'
";"					';'
":"					':'
"..."					ELLIPSIS
"?"					'?'
"."					'.'
"+"					'+'
"-"					'-'
"*"					'*'
"/"					'/'
"%"					'%'
"^"					'^'
"&"					'&'
"|"					'|'
"~"					'~'
"!"					'!'
"="					'='
"<"					'<'
">"					'>'
"+="					ADDEQ
"-="					SUBEQ
"*="					MULEQ
"/="					DIVEQ
"%="					MODEQ
"^="					XOREQ
"&="					ANDEQ
"|="					OREQ
"<<"					SL
">>"					SR
"<<="					SLEQ
">>="					SREQ
"=="					EQ
"!="					NOTEQ
"<="					LTEQ
">="					GTEQ
"&&"					ANDAND
"||"					OROR
"++"					PLUSPLUS
"--"					MINUSMINUS
","					','
"->"					ARROW

"__asm"[\t\f\v\r ]+"volatile"  	        skip() //{ if (!parse_ignored_macro()) REJECT
"__asm__"[\t\f\v\r ]+"volatile"	        skip() //{ if (!parse_ignored_macro()) REJECT
"__asm__"[\t\f\v\r ]+"__volatile__"	skip() //{ if (!parse_ignored_macro()) REJECT
"__asm" 	        	        skip() //{ if (!parse_ignored_macro()) REJECT
"__asm__" 	        	        skip() //{ if (!parse_ignored_macro()) REJECT
"__attribute__" 		        skip() //{ if (!parse_ignored_macro()) REJECT
"__attribute" 		                skip() //{ if (!parse_ignored_macro()) REJECT
"__const"                               CONST
"__extension__"                         skip() //{ /* Ignore */ }
"__inline__"                            INLINE
"__inline"				INLINE
"__nonnull" 			        skip() //{ if (!parse_ignored_macro()) REJECT
"_Nonnull"				skip() //{ /* Ignore */ }
"_Nullable"				skip() //{ /* Ignore */ }
"_Null_unspecified"			skip() //{ /* Ignore */ }
"_Noreturn" 			        skip() //{ /* Ignore */ }
"__signed"				SIGNED
"__signed__"				SIGNED
"__restrict"				RESTRICT
"__restrict__"				RESTRICT
"__typeof"				skip() //{ if (!parse_ignored_macro()) REJECT
"__volatile"	        	        VOLATILE
"__volatile__"	        	        VOLATILE
"_Bool"					BOOL
"typedef char __static_assert_t".*"\n"	skip() //{ /* Ignore */ }
"__cdecl" 	        	        skip() //{ /* Ignore */ }
"__declspec(deprecated(".*"))"		skip() //{ /* Ignore */ }
"__declspec"[\t ]*"("[a-z\t ]+")"	skip() //{ /* Ignore */ }
"__stdcall" 			        skip() //{ /* ignore */ }
"__w64"					skip() //{ /* ignore */ }
"__int64"				INT
"_Float128"				FLOAT


//[a-zA-Z_][a-zA-Z_0-9]*			{ if (igenerator->macro_scan) return check_identifier(igenerator, yytext); else REJECT

"asm"           		        skip() //{ if (!parse_ignored_macro()) REJECT

"auto"					AUTO
"bool"					BOOL
"break"					BREAK
"case"					CASE
"char"					CHAR
"const"					CONST
"continue"				CONTINUE
"default"				DEFAULT
"do"					DO
"double"				DOUBLE
"else"					ELSE
"enum"					ENUM
"extern"				EXTERN
"float"					FLOAT
"for"					FOR
"goto"					GOTO
"if"					IF
"inline"				INLINE
"int"					INT
"__uint128_t"				INT
"__int128_t"				INT
"__uint128"				INT
"__int128"				INT
"long"					LONG
"register"				REGISTER
"restrict"				RESTRICT
"return"				RETURN
"short"					SHORT
"signed"				SIGNED
"sizeof"				SIZEOF
"static"				STATIC
"struct"				STRUCT
"switch"				SWITCH
"typedef"				TYPEDEF
"union"					UNION
"unsigned"				UNSIGNED
"void"					VOID
"volatile"				VOLATILE
"while"					WHILE



"0"[xX][0-9a-fA-F]+{intsuffix}?		INTEGER
"0"[0-7]+{intsuffix}?			INTEGER
[0-9]+{intsuffix}?			INTEGER

{fracconst}{exppart}?{floatsuffix}?	FLOATING
[0-9]+{exppart}{floatsuffix}?		FLOATING

"'"{chartext}*"'"			CHARACTER
"L'"{chartext}*"'"			CHARACTER

"\""{stringtext}*"\""			STRING
"L\""{stringtext}*"\""			STRING

TYPEDEF_NAME	TYPEDEF_NAME
[a-zA-Z_][a-zA-Z_0-9]*			IDENTIFIER //check_identifier(igenerator, yytext)

//.					{ print_error(igenerator)


%%
