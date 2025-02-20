//From: 4edab9bf864f76449fbb0a671456b4b9bb2e4080
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


/*Tokens*/
%token ADD_ASSIGN
%token ADDRESSMOD
//%token ADDRESS_OF
%token ADDRSPACE_NAME
%token ALIGNAS
%token ALIGNOF
%token AND_ASSIGN
%token AND_OP
//%token ARRAYINIT
%token ASM
%token AT
%token ATOMIC
%token ATTR_START
%token AUTO
%token BANKED
%token BIT
//%token BITWISEAND
//%token BLOCK
%token BREAK
//%token CALL
%token CASE
//%token CAST
%token CODE
%token COMPLEX
%token CONSTANT
%token CONSTEXPR
%token CONTINUE
%token COSMIC
%token CRITICAL
%token DATA
%token DECIMAL128
%token DECIMAL32
%token DECIMAL64
%token DEC_OP
%token DEFAULT
%token DIV_ASSIGN
%token DO
%token DOUBLE
//%token DUMMY_READ_VOLATILE
%token EEPROM
%token ELLIPSIS
%token ELSE
//%token ENDCRITICAL
//%token ENDFUNCTION
%token ENUM
%token EQ_OP
%token EXTERN
%token FIXED16X16
%token FOR
%token FUNC
%token GENERIC
//%token GENERIC_ASSOCIATION
//%token GENERIC_ASSOC_LIST
%token GE_OP
//%token GETABIT
//%token GETBYTE
//%token GET_VALUE_AT_ADDRESS
//%token GETWORD
%token GOTO
%token IAR
%token IDATA
%token IDENTIFIER
%token IF
//%token IFX
%token IMAGINARY
%token INC_OP
%token INLINE
%token INLINEASM
%token INTERRUPT
//%token IPOP
//%token IPUSH
//%token IPUSH_VALUE_AT_ADDRESS
%token JAVANATIVE
//%token JUMPTABLE
//%token LABEL
%token LEFT_ASSIGN
%token LEFT_OP
%token LE_OP
%token MOD_ASSIGN
%token MUL_ASSIGN
%token NAKED
%token NE_OP
%token NONBANKED
%token NORETURN
//%token NULLOP
%token NULLPTR
%token OFFSETOF
%token OR_ASSIGN
%token OR_OP
%token OVERLAY
//%token PARAM
//%token PCALL
%token PDATA
%token PRESERVES_REGS
%token PTR_OP
%token RAISONANCE
//%token RANGE
//%token RECEIVE
%token REENTRANT
%token REGISTER
%token RESTRICT
%token RETURN
%token RIGHT_ASSIGN
%token RIGHT_OP
%token ROT
%token SBIT
%token SD_BITINT
%token SD_BOOL
%token SDCCCALL
%token SD_CHAR
%token SD_CONST
//%token SD_FAR
%token SD_FLOAT
%token SD_INT
%token SD_LONG
%token SD_SHORT
%token SD_VOID
%token SD_WPARAM
//%token SEND
//%token SET_VALUE_AT_ADDRESS
%token SFR
%token SFR16
%token SFR32
%token SHADOWREGS
%token SIGNED
%token SIZEOF
%token SMALLC
//%token SPIL
%token STATIC
%token STATIC_ASSERT
%token STRING_LITERAL
%token STRUCT
%token SUB_ASSIGN
%token SWITCH
%token THREAD_LOCAL
%token TOKEN_FALSE
%token TOKEN_TRUE
%token TOK_SEP
%token TRAP
%token TYPEDEF
%token TYPE_NAME
%token TYPEOF
%token TYPEOF_UNQUAL
//%token UNARYMINUS
%token UNION
%token UNSIGNED
//%token UNSPIL
%token USING
%token VOLATILE
%token WHILE
%token XDATA
%token XOR_ASSIGN
%token Z88DK_CALLEE
%token Z88DK_FASTCALL
%token Z88DK_PARAMS_OFFSET
%token Z88DK_SHORTCALL

%right /*1*/ ENUM '{' ':'

%start file

%%

 /* C23 A.2.1 Expressions */

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
	GENERIC '(' generic_controlling_operand ',' generic_assoc_list ')'
	;

generic_controlling_operand :
	assignment_expr
	| type_name
	;

generic_assoc_list :
	generic_association
	| generic_assoc_list ',' generic_association
	;

generic_association :
	type_name ':' /*1R*/ assignment_expr
	| DEFAULT ':' /*1R*/ assignment_expr
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
	| '(' type_name ')' '{' /*1R*/ initializer_list '}'
	| '(' type_name ')' '{' /*1R*/ initializer_list ',' '}'
	| '(' type_name ')' '{' /*1R*/ '}'
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
	| logical_or_expr '?' expression ':' /*1R*/ conditional_expr
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

constant_range_expr :
	constant_expr ELLIPSIS constant_expr
	;

   /* C23 A.2.2 Declarations */

declaration :
	simple_typed_enum_decl
	| declaration_specifiers ';'
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

/* NOTE:
 * Structs and unions have been factored out to avoid parsing conflicts with
 * enum-type-specifier, which semantically cannot be a struct or union, anyway.
 */

type_specifier :
	type_specifier_without_struct_or_union
	| struct_or_union_specifier
	;

type_specifier_without_struct_or_union :
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
	struct_or_union attribute_specifier_sequence_opt opt_stag '{' /*1R*/ member_declaration_list '}'
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

type_specifier_qualifier_without_struct_or_union :
	type_specifier_without_struct_or_union
	| struct_or_union
	| type_qualifier
	| alignment_specifier
	;

member_declarator_list :
	member_declarator
	| member_declarator_list ',' member_declarator
	;

member_declarator :
	declarator
	| ':' /*1R*/ constant_expr
	| declarator ':' /*1R*/ constant_expr
	| /*empty*/
	;

enum_specifier :
	ENUM /*1R*/ '{' /*1R*/ enumerator_list enum_comma_opt '}'
	| ENUM /*1R*/ enum_type_specifier '{' /*1R*/ enumerator_list enum_comma_opt '}'
	| ENUM /*1R*/ identifier '{' /*1R*/ enumerator_list enum_comma_opt '}'
	| ENUM /*1R*/ identifier enum_type_specifier '{' /*1R*/ enumerator_list enum_comma_opt '}'
	| ENUM /*1R*/ identifier
	;

/* C23:
 * An enum specifier of the form "enum identifier enum-type-specifier"
 * may not appear except in a declaration of the form "enum identifier enum-type-specifier ;"
 */

simple_typed_enum_decl :
	ENUM /*1R*/ identifier enum_type_specifier ';'
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

enum_type_specifier :
	':' /*1R*/ type_specifier_list_without_struct_or_union
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
	| '{' /*1R*/ '}'
	| '{' /*1R*/ initializer_list '}'
	| '{' /*1R*/ initializer_list ',' '}'
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

   /* C23 A.2.3 Statements */

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
	identifier ':' /*1R*/
	| attribute_specifier_sequence_opt CASE constant_range_expr ':' /*1R*/
	| attribute_specifier_sequence_opt CASE constant_expr ':' /*1R*/
	| attribute_specifier_sequence_opt DEFAULT ':' /*1R*/
	;

start_block :
	'{' /*1R*/
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

   /* This gives us an unavoidable shift / reduce conflict, but yacc does the right thing for C */
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

   /* C23 A.2.4 External definitions */

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

   /* SDCC-specific stuff */

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

type_specifier_list_without_struct_or_union :
	type_specifier_qualifier_without_struct_or_union
	| type_specifier_list_without_struct_or_union type_specifier_qualifier_without_struct_or_union
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

// The parameter declarations in K&R-style functions need to be handled in a special way to avoid
// ambiguities in the grammer. We do this by not allowing attributes on the parameter declarations.
// Otherwise, in e.g.
//  void f(x) [[attribute]] int x; {}
// it would be unclear if the attribute applies to the type of f vs. the declaration of x.

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

%x asm

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
