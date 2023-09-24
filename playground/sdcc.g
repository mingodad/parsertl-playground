//From: 1faccfeca8d08631c691262cf0a2a5a796a297b0
/*-----------------------------------------------------------------------

  SDCC.y - parser definition file for sdcc

  Written By : Sandeep Dutta . sandeep.dutta@usa.net (1997)
  Revised by : Philipp Klaus Krause krauspeh@informatik.uni-freiburg.de (2022)
  Using inspiration from the grammar by Jutta Degener as extended by Jens Gustedt (under Expat license)

   This program is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
   Free Software Foundation; either version 2, or (at your option) any
   later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

   In other words, you are welcome to use, share and improve this program.
   You are forbidden to forbid anyone else to use, share and improve
   what you give them.   Help stamp out software-hoarding!
-------------------------------------------------------------------------*/

%x asm

/*Tokens*/
%token IDENTIFIER
%token TYPE_NAME
%token ADDRSPACE_NAME
%token CONSTANT
%token SIZEOF
%token OFFSETOF
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
%token ATTR_START
%token TOK_SEP
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
%token TYPEDEF
%token EXTERN
%token STATIC
%token AUTO
%token REGISTER
%token CONSTEXPR
%token CODE
%token EEPROM
%token INTERRUPT
%token SFR
%token SFR16
%token SFR32
%token ADDRESSMOD
%token AT
%token SBIT
%token REENTRANT
%token USING
%token XDATA
%token DATA
%token IDATA
%token PDATA
%token ELLIPSIS
%token CRITICAL
%token NONBANKED
%token BANKED
%token SHADOWREGS
%token SD_WPARAM
%token SD_BOOL
%token SD_CHAR
%token SD_SHORT
%token SD_INT
%token SD_LONG
%token SIGNED
%token UNSIGNED
%token SD_FLOAT
%token DOUBLE
%token FIXED16X16
%token SD_CONST
%token VOLATILE
%token SD_VOID
%token BIT
%token COMPLEX
%token IMAGINARY
%token STRUCT
%token UNION
%token ENUM
//%token RANGE
//%token SD_FAR
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
%token NAKED
%token JAVANATIVE
%token OVERLAY
%token TRAP
%token STRING_LITERAL
%token INLINEASM
%token FUNC
//%token IFX
//%token ADDRESS_OF
//%token GET_VALUE_AT_ADDRESS
//%token SET_VALUE_AT_ADDRESS
//%token SPIL
//%token UNSPIL
//%token GETABIT
//%token GETBYTE
//%token GETWORD
//%token BITWISEAND
//%token UNARYMINUS
//%token IPUSH
///%token IPUSH_VALUE_AT_ADDRESS
//%token IPOP
//%token PCALL
//%token ENDFUNCTION
//%token JUMPTABLE
%token ROT
//%token CAST
//%token CALL
//%token PARAM
//%token NULLOP
//%token BLOCK
//%token LABEL
//%token RECEIVE
//%token SEND
//%token ARRAYINIT
//%token DUMMY_READ_VOLATILE
//%token ENDCRITICAL
%token INLINE
%token RESTRICT
%token SMALLC
%token RAISONANCE
%token IAR
%token COSMIC
%token SDCCCALL
%token PRESERVES_REGS
%token Z88DK_FASTCALL
%token Z88DK_CALLEE
%token Z88DK_SHORTCALL
%token Z88DK_PARAMS_OFFSET
%token ALIGNAS
%token ALIGNOF
%token ATOMIC
%token GENERIC
%token NORETURN
%token STATIC_ASSERT
%token THREAD_LOCAL
%token TOKEN_FALSE
%token TOKEN_TRUE
%token NULLPTR
%token TYPEOF
%token TYPEOF_UNQUAL
%token SD_BITINT
%token DECIMAL32
%token DECIMAL64
%token DECIMAL128
%token ASM
//%token GENERIC_ASSOC_LIST
//%token GENERIC_ASSOCIATION
%token '('
%token ')'
%token ','
%token ':'
%token '['
%token ']'
%token '.'
%token '{'
%token '}'
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
%token '='
%token ';'


%start file

%%

primary_expression :
	identifier
	| CONSTANT
	| string_literal_val
	| '(' expression ')'
	| generic_selection
	| predefined_constant
	;

predefined_constant :
	TOKEN_FALSE
	| TOKEN_TRUE
	| NULLPTR
	;

generic_selection :
	GENERIC '(' assignment_expr ',' generic_assoc_list ')'
	;

generic_assoc_list :
	generic_association
	| generic_assoc_list ',' generic_association
	;

generic_association :
	type_name ':' assignment_expr
	| DEFAULT ':' assignment_expr
	;

postfix_expression :
	primary_expression
	| postfix_expression '[' expression ']'
	| postfix_expression '(' ')'
	| postfix_expression '(' argument_expr_list ')'
	| postfix_expression '.' identifier
	| postfix_expression PTR_OP identifier
	| postfix_expression INC_OP
	| postfix_expression DEC_OP
	| '(' type_name ')' '{' initializer_list '}'
	| '(' type_name ')' '{' initializer_list ',' '}'
	| '(' type_name ')' '{' '}'
	;

argument_expr_list :
	assignment_expr
	| assignment_expr ',' argument_expr_list
	;

unary_expression :
	postfix_expression
	| INC_OP unary_expression
	| DEC_OP unary_expression
	| unary_operator cast_expression
	| SIZEOF unary_expression
	| SIZEOF '(' type_name ')'
	| ALIGNOF '(' type_name ')'
	| OFFSETOF '(' type_name ',' offsetof_member_designator ')'
	| ROT '(' unary_expression ',' unary_expression ')'
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

logical_and_expr :
	inclusive_or_expression
	| logical_and_expr AND_OP inclusive_or_expression
	;

logical_or_expr :
	logical_and_expr
	| logical_or_expr OR_OP logical_and_expr
	;

conditional_expr :
	logical_or_expr
	| logical_or_expr '?' expression ':' conditional_expr
	;

assignment_expr :
	conditional_expr
	| unary_expression assignment_operator assignment_expr
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
	assignment_expr
	| expression ',' assignment_expr
	;

expression_opt :
	/*empty*/
	| expression
	;

constant_expr :
	conditional_expr
	;

declaration :
	declaration_specifiers ';'
	| declaration_specifiers init_declarator_list ';'
	| static_assert_declaration
	| attribute_declaration
	;

declaration_specifiers :
	declaration_specifiers_
	;

declaration_specifiers_ :
	storage_class_specifier
	| storage_class_specifier declaration_specifiers_
	| type_specifier_qualifier
	| type_specifier_qualifier declaration_specifiers_
	| function_specifier
	| function_specifier declaration_specifiers_
	;

init_declarator_list :
	init_declarator
	| init_declarator_list ',' init_declarator
	;

init_declarator :
	declarator
	| declarator '=' initializer
	;

attribute_declaration :
	attribute_specifier_sequence ';'
	;

storage_class_specifier :
	TYPEDEF
	| EXTERN
	| STATIC
	| THREAD_LOCAL
	| AUTO
	| REGISTER
	| CONSTEXPR
	;

type_specifier :
	SD_VOID
	| SD_CHAR
	| SD_SHORT
	| SD_INT
	| SD_LONG
	| SD_FLOAT
	| DOUBLE
	| SIGNED
	| UNSIGNED
	| SD_BITINT '(' constant_expr ')'
	| SD_BOOL
	| COMPLEX
	| IMAGINARY
	| DECIMAL32
	| DECIMAL64
	| DECIMAL128
	| struct_or_union_specifier
	| enum_specifier
	| TYPE_NAME
	| typeof_specifier
	| FIXED16X16
	| BIT
	| AT CONSTANT
	| AT '(' constant_expr ')'
	| sfr_reg_bit
	;

typeof_specifier :
	TYPEOF '(' expression ')'
	| TYPEOF '(' type_name ')'
	| TYPEOF_UNQUAL '(' expression ')'
	| TYPEOF_UNQUAL '(' type_name ')'
	;

struct_or_union_specifier :
	struct_or_union attribute_specifier_sequence_opt opt_stag '{' member_declaration_list '}'
	| struct_or_union attribute_specifier_sequence_opt stag
	;

struct_or_union :
	STRUCT
	| UNION
	;

member_declaration_list :
	member_declaration
	| member_declaration_list member_declaration
	;

member_declaration :
	attribute_specifier_sequence_opt specifier_qualifier_list member_declarator_list ';'
	;

type_specifier_qualifier :
	type_specifier
	| type_qualifier
	| alignment_specifier
	;

member_declarator_list :
	member_declarator
	| member_declarator_list ',' member_declarator
	;

member_declarator :
	declarator
	| ':' constant_expr
	| declarator ':' constant_expr
	| /*empty*/
	;

enum_specifier :
	ENUM '{' enumerator_list enum_comma_opt '}'
	| ENUM identifier '{' enumerator_list enum_comma_opt '}'
	| ENUM identifier
	;

enum_comma_opt :
	/*empty*/
	| ','
	;

enumerator_list :
	enumerator
	| enumerator_list ',' enumerator
	;

enumerator :
	identifier attribute_specifier_sequence_opt opt_assign_expr
	;

type_qualifier :
	SD_CONST
	| RESTRICT
	| VOLATILE
	| ATOMIC
	| ADDRSPACE_NAME
	| XDATA
	| CODE
	| EEPROM
	| DATA
	| IDATA
	| PDATA
	;

function_specifier :
	INLINE
	| NORETURN
	;

alignment_specifier :
	ALIGNAS '(' type_name ')'
	| ALIGNAS '(' constant_expr ')'
	;

declarator :
	direct_declarator
	| pointer direct_declarator
	;

direct_declarator :
	identifier attribute_specifier_sequence_opt
	| '(' declarator ')'
	| array_declarator attribute_specifier_sequence_opt
	| declarator2_function_attributes attribute_specifier_sequence_opt
	;

declarator2 :
	identifier
	| '(' declarator ')'
	| array_declarator
	;

array_declarator :
	direct_declarator '[' type_qualifier_list_opt ']'
	| direct_declarator '[' type_qualifier_list_opt assignment_expr ']'
	| direct_declarator '[' STATIC type_qualifier_list_opt assignment_expr ']'
	| direct_declarator '[' type_qualifier_list STATIC assignment_expr ']'
	;

declarator2_function_attributes :
	function_declarator
	| function_declarator function_attributes
	;

function_declarator :
	declarator2 '(' ')'
	| declarator2 '(' parameter_type_list ')'
	| declarator2 '(' identifier_list ')'
	;

pointer :
	unqualified_pointer
	| unqualified_pointer AT '(' constant_expr ')'
	| unqualified_pointer type_qualifier_list
	| unqualified_pointer type_qualifier_list AT '(' constant_expr ')'
	| unqualified_pointer pointer
	| unqualified_pointer type_qualifier_list pointer
	;

unqualified_pointer :
	'*'
	;

type_qualifier_list :
	type_qualifier
	| type_qualifier_list type_qualifier
	;

type_qualifier_list_opt :
	/*empty*/
	| type_qualifier_list
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
	| type_name
	;

abstract_declarator :
	pointer
	| direct_abstract_declarator
	| pointer direct_abstract_declarator
	;

direct_abstract_declarator :
	'(' abstract_declarator ')'
	| array_abstract_declarator
	| function_abstract_declarator
	;

direct_abstract_declarator_opt :
	/*empty*/
	| direct_abstract_declarator
	;

array_abstract_declarator :
	direct_abstract_declarator_opt '[' ']'
	| direct_abstract_declarator_opt '[' constant_expr ']'
	;

function_abstract_declarator :
	'(' ')'
	| direct_abstract_declarator '(' ')'
	| '(' parameter_type_list ')'
	| direct_abstract_declarator '(' parameter_type_list ')'
	;

initializer :
	assignment_expr
	| '{' '}'
	| '{' initializer_list '}'
	| '{' initializer_list ',' '}'
	;

initializer_list :
	designation_opt initializer
	| initializer_list ',' designation_opt initializer
	;

designation_opt :
	/*empty*/
	| designation
	;

designation :
	designator_list '='
	;

designator_list :
	designator
	| designator_list designator
	;

designator :
	'[' constant_expr ']'
	| '.' identifier
	;

static_assert_declaration :
	STATIC_ASSERT '(' constant_expr ',' STRING_LITERAL ')' ';'
	| STATIC_ASSERT '(' constant_expr ')' ';'
	;

attribute_specifier_sequence :
	attribute_specifier_sequence attribute_specifier
	| attribute_specifier
	;

attribute_specifier_sequence_opt :
	/*empty*/
	| attribute_specifier_sequence
	;

attribute_specifier :
	ATTR_START attribute_list ']' ']'
	;

attribute_list :
	attribute_opt
	| attribute_list ',' attribute_opt
	;

attribute :
	attribute_token
	| attribute_token attribute_argument_clause
	;

attribute_opt :
	/*empty*/
	| attribute
	;

attribute_token :
	identifier
	| identifier TOK_SEP identifier
	;

attribute_argument_clause :
	'(' ')'
	| '(' balanced_token_sequence ')'
	;

balanced_token_sequence :
	balanced_token
	| balanced_token_sequence balanced_token
	;

balanced_token :
	identifier
	| STRING_LITERAL
	| CONSTANT
	;

statement :
	labeled_statement
	| unlabeled_statement
	;

unlabeled_statement :
	expression_statement
	| attribute_specifier_sequence_opt primary_block
	| attribute_specifier_sequence_opt jump_statement
	| critical_statement
	| asm_statement
	;

primary_block :
	compound_statement
	| selection_statement
	| iteration_statement
	;

secondary_block :
	statement
	;

labeled_statement :
	label statement
	;

label :
	identifier ':'
	| attribute_specifier_sequence_opt CASE constant_expr ':'
	| attribute_specifier_sequence_opt DEFAULT ':'
	;

start_block :
	'{'
	;

end_block :
	'}'
	;

compound_statement :
	start_block end_block
	| start_block block_item_list end_block
	;

block_item_list :
	statements_and_implicit
	| declaration_list
	| declaration_list statements_and_implicit
	;

expression_statement :
	expression_opt ';'
	| attribute_specifier_sequence expression ';'
	;

else_statement :
	ELSE statement
	| /*empty*/
	;

selection_statement :
	IF '(' expression ')' statement else_statement
	| SWITCH '(' expression ')' secondary_block
	;

iteration_statement :
	while '(' expression ')' secondary_block
	| do secondary_block WHILE '(' expression ')' ';'
	| for '(' expression_opt ';' expression_opt ';' expression_opt ')' secondary_block
	| for '(' declaration expression_opt ';' expression_opt ')' secondary_block
	;

jump_statement :
	GOTO identifier ';'
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
	| addressmod
	;

function_definition :
	declarator function_body
	| declaration_specifiers declarator function_body
	;

function_body :
	compound_statement
	| kr_declaration_list compound_statement
	;

file :
	/*empty*/
	| translation_unit
	;

function_attributes :
	function_attribute
	| function_attributes function_attribute
	;

function_attribute :
	USING '(' constant_expr ')'
	| REENTRANT
	| CRITICAL
	| NAKED
	| JAVANATIVE
	| OVERLAY
	| NONBANKED
	| SHADOWREGS
	| SD_WPARAM
	| BANKED
	| Interrupt_storage
	| TRAP
	| SMALLC
	| RAISONANCE
	| IAR
	| COSMIC
	| SDCCCALL '(' constant_expr ')'
	| Z88DK_FASTCALL
	| Z88DK_CALLEE
	| Z88DK_PARAMS_OFFSET '(' constant_expr ')'
	| Z88DK_SHORTCALL '(' constant_expr ',' constant_expr ')'
	| PRESERVES_REGS '(' identifier_list ')'
	;

offsetof_member_designator :
	identifier
	| offsetof_member_designator '.' identifier
	| offsetof_member_designator '[' expression ']'
	;

string_literal_val :
	FUNC
	| STRING_LITERAL
	;

Interrupt_storage :
	INTERRUPT
	| INTERRUPT '(' constant_expr ')'
	;

sfr_reg_bit :
	SBIT
	| sfr_attributes
	;

sfr_attributes :
	SFR
	| SFR BANKED
	| SFR16
	| SFR32
	;

opt_stag :
	stag
	| /*empty*/
	;

stag :
	identifier
	;

opt_assign_expr :
	'=' constant_expr
	| /*empty*/
	;

specifier_qualifier_list :
	type_specifier_list_
	;

type_specifier_list_ :
	type_specifier_qualifier
	| type_specifier_list_ type_specifier_qualifier
	;

identifier_list :
	identifier
	| identifier_list ',' identifier
	;

type_name :
	declaration_specifiers
	| declaration_specifiers abstract_declarator
	;

critical :
	CRITICAL
	;

critical_statement :
	critical statement
	;

statements_and_implicit :
	statement_list
	| statement_list implicit_block
	;

declaration_after_statement :
	declaration_list
	;

implicit_block :
	declaration_after_statement statements_and_implicit
	| declaration_after_statement
	;

declaration_list :
	declaration
	| declaration_list declaration
	;

kr_declaration :
	declaration_specifiers init_declarator_list ';'
	;

kr_declaration_list :
	kr_declaration
	| kr_declaration_list kr_declaration
	;

statement_list :
	unlabeled_statement
	| label
	| statement_list unlabeled_statement
	| statement_list label
	;

while :
	WHILE
	;

do :
	DO
	;

for :
	FOR
	;

asm_string_literal :
	STRING_LITERAL
	;

asm_statement :
	ASM '(' asm_string_literal ')' ';'
	| INLINEASM ';'
	;

addressmod :
	ADDRESSMOD identifier identifier ';'
	| ADDRESSMOD identifier SD_CONST identifier ';'
	;

identifier :
	IDENTIFIER
	;

%%

DC  '?[0-9]
OC  '?[0-7]
HC  '?[a-fA-F0-9]
BC  '?[01]

D       [0-9]
H       [a-fA-F0-9]
B       [01]
L       [a-zA-Z_$]
E       [Ee][+-]?{D}+
BE      [Pp][+-]?{D}+
FS      (f|F|l|L|df|dd|dl|DF|DD|DL)
IS      [uUlL]*
WB      (((u|U)(wb|WB))|((wb|WB)(u|U)?))
CP      (L|u|U|u8)
HASH    (#|%:)
UCN     \\u{H}{4}|\\U{H}{8}

UTF8PART1       \xc2[\xa8\xaa\xad\xaf\xb2-\xb5\xb7-\xba\xbc-\xbe]|\xc3[\x80-\x96\x98-\xb6\xb8-\xbf]|[\xc4-\xcb\xce-\xdf][\x80-\xbf]|\xcd[\xb0-\xbf]
UTF8PART2       \xe0[\xa0-\xbf][\x80-\xbf]|\xe1([\x80-\x99\x9b-\x9f\xa1-\xb6\xb8-\xbf][\x80-\xbf]|\x9a[\x81-\xbf]|\xa0[\x80-\x8d\x8f-\xbf])
UTF8PART3       \xe2(\x80[\x8b-\x8d\xaa-\xae\xbf]|\x81[\x80\x94\xa0-\xbf]|\x82[\x80-\xbf]|[\x83\x86][\x80-\x8f]|[\x84-\x85\x92-\x93\xb0-\xb7\xba-\xbf][\x80-\xbf]|\x91[\xa0-\xbf]|\x9d[\xb6-\xbf]|\x9e[\x80-\x93])
UTF8PART4       \xe3(\x80[\x84-\x87\xa1-\xaf\xb1-\xbf]|[\x81-\xbf][\x80-\xbf])|[\xe4-\xec][\x80-\xbf][\x80-\xbf]|\xed[\x80-\x9f][\x80-\xbf]
UTF8PART5       \xef([\xa4-\xb3\xb5-\xb6\xba-\xbe][\x80-\xbf]|\xb4[\x80-\xbd]|\xb7[\x80-\x8f]|[\xb7-\xb8][\xb0-\xbf]|\xb8[\x80-\x9f]|\xb9[\x80-\x84\x87-\xbf]|\xbf[\x80-\xbd])
UTF8PART6       \xf0([\x90-\x9e\xa0-\xae\xb0-\xbe][\x80-\xbf][\x80-\xbf]|[\x9f\xaf\xbf]([\x80-\xbe][\x80-\xbf]|\xbf[\x80-\xbd]))
UTF8PART7       [\xf1-\xf2]([\x80-\x8e\x90-\x9e\xa0-\xae\xb0-\xbe][\x80-\xbf][\x80-\xbf]|[\x8f\x9f\xaf\xbf]([\x80-\xbe][\x80-\xbf]|\xbf[\x80-\xbd]))
UTF8PART8       \xf3([\x80-\x8e\x90-\x9e\xa0-\xae][\x80-\xbf][\x80-\xbf]|[\x8f\x9f\xaf]([\x80-\xbe][\x80-\xbf]|\xbf[\x80-\xbd]))

UTF8IDF1ST      {UTF8PART1}|{UTF8PART2}|{UTF8PART3}|{UTF8PART4}|{UTF8PART5}|{UTF8PART6}|{UTF8PART7}|{UTF8PART8}
UTF8IDF         {UTF8IDF1ST}|\xcc[\x80-\xbf]|\xcd[\x80-\xaf]|\xe2\x83[\x90-\xbf]|\xef\xb8[\xa0-\xaf]|\xe1\xb7[\x80-\xbf]

string_lit	\"(\\.|[^"\n\r\\])*\"

%%

"__asm"<asm>
<asm>	{
	"__endasm"<INITIAL>        INLINEASM
	^{HASH}.*<.>
	\n<.>
	.<.>
}

 /* C90 */
"auto"                  AUTO
"break"                 BREAK
"case"                  CASE
"char"                  SD_CHAR
"const"                 SD_CONST
"continue"              CONTINUE
"default"               DEFAULT
"do"                    DO
"double"                DOUBLE
"else"                  ELSE
"enum"                  ENUM
"extern"                EXTERN
"float"                 SD_FLOAT
"for"                   FOR
"goto"                  GOTO
"if"                    IF
"int"                   SD_INT
"long"                  SD_LONG
"register"              REGISTER
"return"                RETURN
"short"                 SD_SHORT
"signed"                SIGNED
"sizeof"                SIZEOF
"static"                STATIC
"struct"                STRUCT
"switch"                SWITCH
"typedef"               TYPEDEF
"union"                 UNION
"unsigned"              UNSIGNED
"void"                  SD_VOID
"volatile"              VOLATILE
"while"                 WHILE
"..."                   ELLIPSIS

 /* C99 */
"__func__"              FUNC
"_Bool"                 SD_BOOL
"_Complex"              COMPLEX
"_Imaginary"            IMAGINARY
"_Noreturn"             NORETURN
"_Static_assert"        STATIC_ASSERT
"inline"                INLINE
"restrict"              RESTRICT

 /* C11 */
"_Alignas"              ALIGNAS
"_Alignof"              ALIGNOF
"_Atomic"               ATOMIC
"_Generic"              GENERIC
"_Thread_local"         THREAD_LOCAL

 /* C2X */
"_BitInt"               SD_BITINT
"_Decimal32"            DECIMAL32
"_Decimal64"            DECIMAL64
"_Decimal128"           DECIMAL128
"alignas"               ALIGNAS
"alignof"               ALIGNOF
"bool"                  SD_BOOL
"static_assert"         STATIC_ASSERT
"true"                  TOKEN_TRUE
"false"                 TOKEN_FALSE
"nullptr"               NULLPTR
"constexpr"             CONSTEXPR
"typeof"                TYPEOF
"typeof_unqual"         TYPEOF_UNQUAL

 /* SDCC-specific intrinsic named address spaces (as per Embedded C TS) */
"__code"                CODE
"__data"                DATA
"__eeprom"              EEPROM
"__far"                 XDATA
"__flash"               CODE
"__idata"               IDATA
"__near"                DATA
"__pdata"               PDATA
"__sram"                XDATA
"__xdata"               XDATA
"__zp"                  DATA

 /* SDCC language extensions */
"__asm__"               ASM
"__at"                  AT
"__bit"                 BIT
"__critical"            CRITICAL
"__fixed16x16"          FIXED16X16
"__interrupt"           INTERRUPT
"__nonbanked"           NONBANKED
"__banked"              BANKED
"__trap"                TRAP
"__reentrant"           REENTRANT
"__shadowregs"          SHADOWREGS
"__wparam"              SD_WPARAM
"__sfr"                 SFR
"__sfr16"               SFR16
"__sfr32"               SFR32
"__sbit"                SBIT
"__builtin_offsetof"    OFFSETOF
"__builtin_rot"         ROT
"__using"               USING
"__naked"               NAKED
"_JavaNative"           JAVANATIVE
"__overlay"             OVERLAY
"__smallc"              SMALLC
"__raisonance"          RAISONANCE
"__iar"                 IAR
"__cosmic"              COSMIC
"__sdcccall"            SDCCCALL
"__preserves_regs"      PRESERVES_REGS
"__z88dk_fastcall"      Z88DK_FASTCALL
"__z88dk_callee"        Z88DK_CALLEE
"__z88dk_shortcall"     Z88DK_SHORTCALL
"__z88dk_params_offset" Z88DK_PARAMS_OFFSET
"__addressmod"          ADDRESSMOD
"__typeof"              TYPEOF


TYPE_NAME	TYPE_NAME
ADDRSPACE_NAME	ADDRSPACE_NAME
({L}|{UCN}|{UTF8IDF1ST})({L}|{D}|{UCN}|{UTF8IDF})*  IDENTIFIER


[1-9]{DC}*({IS}|{WB})?       CONSTANT
0[xX]{H}{HC}*({IS}|{WB})?    CONSTANT
0{OC}*({IS}|{WB})?           CONSTANT
/* C2X binary integer constant. All standard version warnings on integer constants are done in constIntVal. */
0[bB]{B}{BC}*({IS}|{WB})?    CONSTANT
 /* ' make syntax highlighter happy */
{CP}?'(\\.|[^\\'])+'         CONSTANT
{D}+{E}{FS}?                 CONSTANT
{D}*"."{D}+({E})?{FS}?       CONSTANT
{D}+"."{D}*({E})?{FS}?       CONSTANT
0[xX]{H}+{BE}{FS}?           CONSTANT
0[xX]{H}*"."{H}+({BE})?{FS}? CONSTANT
0[xX]{H}+"."{H}*({BE})?{FS}? CONSTANT
{string_lit}                           STRING_LITERAL
"L"{string_lit}                        STRING_LITERAL
"u8"{string_lit}                       STRING_LITERAL
"u"{string_lit}                        STRING_LITERAL
"U"{string_lit}                        STRING_LITERAL
">>="                   RIGHT_ASSIGN
"<<="                   LEFT_ASSIGN
"+="                    ADD_ASSIGN
"-="                    SUB_ASSIGN
"*="                    MUL_ASSIGN
"/="                    DIV_ASSIGN
"%="                    MOD_ASSIGN
"&="                     AND_ASSIGN
"^="                    XOR_ASSIGN
"|="                    OR_ASSIGN
">>"                    RIGHT_OP
"<<"                    LEFT_OP
"++"                    INC_OP
"--"                    DEC_OP
"->"                    PTR_OP
"&&"                    AND_OP
"||"                    OR_OP
"<="                    LE_OP
">="                    GE_OP
"=="                    EQ_OP
"!="                    NE_OP
";"                     ';'
"{"|"<%"                '{'
"}"|"%>"                '}'
","                     ','
":"                     ':'
"="                     '='
"("                     '('
")"                     ')'
/* The double brackets of attributes. Otherwise the ambiguity of the grammar explodes. */
"[["|"<:<:"             ATTR_START
"["|"<:"                '['
"]"|":>"                ']'
"."                     '.'
"&"                     '&'
"!"                     '!'
"~"                     '~'
"-"                     '-'
"+"                     '+'
"*"                     '*'
"/"                     '/'
"%"                     '%'
"<"                     '<'
">"                     '>'
"^"                     '^'
"|"                     '|'
"?"                     '?'
"::"                    TOK_SEP
^{HASH}pragma.*         skip()
^{HASH}.*               skip()

"\r\n"                  skip()
"\n"                    skip()
[ \t\v\f]               skip()
/* Line continuation */
\\\n                     skip()

//.                       { count ()

%%
