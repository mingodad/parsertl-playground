/****************************************************************************/
/*                                                                          */
/*  Copyright (C) 2001-2003                                                 */
/*   George C. Necula    <necula@cs.berkeley.edu>                           */
/*   Scott McPeak        <smcpeak@cs.berkeley.edu>                          */
/*   Wes Weimer          <weimer@cs.berkeley.edu>                           */
/*   Ben Liblit          <liblit@cs.berkeley.edu>                           */
/*  All rights reserved.                                                    */
/*                                                                          */
/*  Redistribution and use in source and binary forms, with or without      */
/*  modification, are permitted provided that the following conditions      */
/*  are met:                                                                */
/*                                                                          */
/*  1. Redistributions of source code must retain the above copyright       */
/*  notice, this list of conditions and the following disclaimer.           */
/*                                                                          */
/*  2. Redistributions in binary form must reproduce the above copyright    */
/*  notice, this list of conditions and the following disclaimer in the     */
/*  documentation and/or other materials provided with the distribution.    */
/*                                                                          */
/*  3. The names of the contributors may not be used to endorse or          */
/*  promote products derived from this software without specific prior      */
/*  written permission.                                                     */
/*                                                                          */
/*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS     */
/*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT       */
/*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       */
/*  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE          */
/*  COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,     */
/*  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,    */
/*  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;        */
/*  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER        */
/*  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT      */
/*  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN       */
/*  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         */
/*  POSSIBILITY OF SUCH DAMAGE.                                             */
/*                                                                          */
/*  File modified by CEA (Commissariat à l'énergie atomique et aux          */
/*                        énergies alternatives)                            */
/*               and INRIA (Institut National de Recherche en Informatique  */
/*                          et Automatique).                                */
/****************************************************************************/

/*  3.22.99 Hugues Cass<E9> First version.
    2.0  George Necula 12/12/00: Practically complete rewrite.
*/

%x	hash_st

%token  SPEC
%token  DECL
%token  CODE_ANNOT
%token     LOOP_ANNOT
%token     ATTRIBUTE_ANNOT

%token     IDENT
%token     CST_CHAR
%token     CST_WCHAR
%token     CST_INT
%token     CST_FLOAT
%token     NAMED_TYPE

/* Each character is its own list element, and the terminating nul is not
   included in this list. */
%token     CST_STRING
%token     CST_WSTRING

//%token EOF
%token    BOOL CHAR INT DOUBLE FLOAT VOID INT64
%token    ENUM STRUCT TYPEDEF UNION
%token    SIGNED UNSIGNED LONG SHORT
%token    VOLATILE EXTERN STATIC CONST RESTRICT AUTO REGISTER
%token    THREAD THREAD_LOCAL
%token    GHOST

%token    SIZEOF ALIGNOF GENERIC

%token EQ PLUS_EQ MINUS_EQ STAR_EQ SLASH_EQ PERCENT_EQ
%token AND_EQ PIPE_EQ CIRC_EQ INF_INF_EQ SUP_SUP_EQ
%token ARROW DOT

%token EQ_EQ EXCLAM_EQ INF SUP INF_EQ SUP_EQ
%token    PLUS MINUS STAR
%token SLASH PERCENT
%token    TILDE AND
%token PIPE CIRC
%token    EXCLAM AND_AND
%token PIPE_PIPE
%token INF_INF SUP_SUP
%token    PLUS_PLUS MINUS_MINUS

%token RPAREN
%token    LPAREN RBRACE
%token    LBRACE
%token LBRACKET RBRACKET
%token COLON COLON2
%token    SEMICOLON
%token COMMA ELLIPSIS QUEST

%token    BREAK CONTINUE GOTO RETURN
%token    SWITCH CASE DEFAULT
%token    WHILE DO FOR
%token    IF TRY EXCEPT FINALLY
%token ELSE

%token    ATTRIBUTE INLINE NORETURN STATIC_ASSERT ASM TYPEOF FUNCTION__ PRETTY_FUNCTION__
%token LABEL__
%token    BUILTIN_VA_ARG
%token BLOCKATTRIBUTE
%token    BUILTIN_TYPES_COMPAT BUILTIN_OFFSETOF
%token    DECLSPEC
//%token    MSASM
%token    MSATTR
%token    PRAGMA_LINE
%token    PRAGMA
%token PRAGMA_EOL

/*Frama-C: ghost bracketing */
%token LGHOST RGHOST
%token    LGHOST_ELSE

/* operator precedence */
%nonassoc   if_no_else
%nonassoc   ghost_else_no_else
%nonassoc   ELSE LGHOST_ELSE

%right  NAMED_TYPE /* We'll use this to handle redefinitions of NAMED_TYPE as variables */
%left   IDENT

/* Non-terminals informations */
%start file

%%

//interpret :
//	file
//	;

file :
	globals //EOF
	;

globals :
	/*empty*/
	| global globals
	| ghost_glob_begin ghost_globals globals
	| SEMICOLON globals
	;

ghost_glob_begin :
	LGHOST
	;

ghost_globals :
	declaration ghost_globals
	| function_def ghost_globals
	| RGHOST
	;

global :
	DECL
	| declaration
	| function_def
	| EXTERN string_constant declaration
	| EXTERN string_constant LBRACE globals RBRACE
	| ASM LPAREN string_constant RPAREN SEMICOLON
	//| pragma
	| IDENT LPAREN old_parameter_list_ne RPAREN old_pardef_list SEMICOLON
	| IDENT LPAREN RPAREN SEMICOLON
	;

id_or_typename_as_id :
	IDENT
	| NAMED_TYPE
	;

id_or_typename :
	id_or_typename_as_id
	;

maybecomma :
	/*empty*/
	| COMMA
	;

primary_expression :
	IDENT
	| constant
	| paren_comma_expression
	| LPAREN block RPAREN
	| generic_selection
	;

postfix_expression :
	primary_expression
	| postfix_expression bracket_comma_expression
	| postfix_expression LPAREN arguments RPAREN ghost_arguments_opt
	| BUILTIN_VA_ARG LPAREN expression COMMA type_name RPAREN
	| BUILTIN_TYPES_COMPAT LPAREN type_name COMMA type_name RPAREN
	| BUILTIN_OFFSETOF LPAREN type_name COMMA offsetof_member_designator RPAREN
	| postfix_expression DOT id_or_typename
	| postfix_expression ARROW id_or_typename
	| postfix_expression PLUS_PLUS
	| postfix_expression MINUS_MINUS
	| LPAREN type_name RPAREN LBRACE initializer_list_opt RBRACE
	;

offsetof_member_designator :
	id_or_typename
	| offsetof_member_designator DOT IDENT
	| offsetof_member_designator bracket_comma_expression
	;

unary_expression :
	postfix_expression
	| PLUS_PLUS unary_expression
	| MINUS_MINUS unary_expression
	| SIZEOF unary_expression
	| SIZEOF LPAREN type_name RPAREN
	| ALIGNOF unary_expression
	| ALIGNOF LPAREN type_name RPAREN
	| PLUS cast_expression
	| MINUS cast_expression
	| STAR cast_expression
	| AND cast_expression
	| EXCLAM cast_expression
	| TILDE cast_expression
	| AND_AND id_or_typename_as_id
	;

cast_expression :
	unary_expression
	| LPAREN type_name RPAREN cast_expression
	;

multiplicative_expression :
	cast_expression
	| multiplicative_expression STAR cast_expression
	| multiplicative_expression SLASH cast_expression
	| multiplicative_expression PERCENT cast_expression
	;

additive_expression :
	multiplicative_expression
	| additive_expression PLUS multiplicative_expression
	| additive_expression MINUS multiplicative_expression
	;

shift_expression :
	additive_expression
	| shift_expression INF_INF additive_expression
	| shift_expression SUP_SUP additive_expression
	;

relational_expression :
	shift_expression
	| relational_expression INF shift_expression
	| relational_expression SUP shift_expression
	| relational_expression INF_EQ shift_expression
	| relational_expression SUP_EQ shift_expression
	;

equality_expression :
	relational_expression
	| equality_expression EQ_EQ relational_expression
	| equality_expression EXCLAM_EQ relational_expression
	;

bitwise_and_expression :
	equality_expression
	| bitwise_and_expression AND equality_expression
	;

bitwise_xor_expression :
	bitwise_and_expression
	| bitwise_xor_expression CIRC bitwise_and_expression
	;

bitwise_or_expression :
	bitwise_xor_expression
	| bitwise_or_expression PIPE bitwise_xor_expression
	;

logical_and_expression :
	bitwise_or_expression
	| logical_and_expression AND_AND bitwise_or_expression
	;

logical_or_expression :
	logical_and_expression
	| logical_or_expression PIPE_PIPE logical_and_expression
	;

conditional_expression :
	logical_or_expression
	| logical_or_expression QUEST opt_expression COLON conditional_expression
	;

assignment_expression :
	conditional_expression
	| cast_expression EQ assignment_expression
	| cast_expression PLUS_EQ assignment_expression
	| cast_expression MINUS_EQ assignment_expression
	| cast_expression STAR_EQ assignment_expression
	| cast_expression SLASH_EQ assignment_expression
	| cast_expression PERCENT_EQ assignment_expression
	| cast_expression AND_EQ assignment_expression
	| cast_expression PIPE_EQ assignment_expression
	| cast_expression CIRC_EQ assignment_expression
	| cast_expression INF_INF_EQ assignment_expression
	| cast_expression SUP_SUP_EQ assignment_expression
	;

expression :
	assignment_expression
	;

constant :
	CST_INT
	| CST_FLOAT
	| CST_CHAR
	| CST_WCHAR
	| string_constant
	| wstring_list
	;

string_constant :
	string_list
	;

string_list :
	one_string
	| one_string string_list
	;

wstring_list :
	CST_WSTRING
	| one_string wstring_list
	| CST_WSTRING wstring_list
	| CST_WSTRING string_list
	;

one_string :
	CST_STRING
	| FUNCTION__
	| PRETTY_FUNCTION__
	;

init_expression :
	expression
	| LBRACE initializer_list_opt RBRACE
	;

initializer_list :
	initializer_single
	| initializer_single COMMA initializer_list_opt
	;

initializer_list_opt :
	/*empty*/
	| initializer_list
	;

initializer_single :
	init_designators eq_opt init_expression
	| gcc_init_designators init_expression
	| init_expression
	;

eq_opt :
	EQ
	|
	;

init_designators :
	DOT id_or_typename init_designators_opt
	| LBRACKET expression RBRACKET init_designators_opt
	| LBRACKET expression ELLIPSIS expression RBRACKET
	;

init_designators_opt :
	/*empty*/
	| init_designators
	;

gcc_init_designators :
	id_or_typename COLON
	;

ghost_arguments_opt :
	/*empty*/
	| ghost_arguments
	;

ghost_arguments :
	LGHOST LPAREN arguments RPAREN RGHOST
	;

arguments :
	/*empty*/
	| comma_expression
	;

opt_expression :
	/*empty*/
	| comma_expression
	;

comma_expression :
	expression
	| expression COMMA comma_expression
	;

comma_expression_opt :
	/*empty*/
	| comma_expression
	;

paren_comma_expression :
	LPAREN comma_expression RPAREN
	;

bracket_comma_expression :
	LBRACKET comma_expression RBRACKET
	;

block :
	block_begin local_labels block_attrs block_content RBRACE
	;

block_begin :
	LBRACE
	;

block_attrs :
	/*empty*/
	| BLOCKATTRIBUTE paren_attr_list_ne
	;

block_content :
	block_element_list
	;

block_element_list :
	annot_list_opt
	| annot_list_opt declaration block_element_list
	| annot_list_opt statement block_element_list
	//| annot_list_opt pragma block_element_list
	;

annot_list_opt :
	/*empty*/
	| annot_list
	;

annot_list :
	CODE_ANNOT annot_list_opt
	| LGHOST block_element_list RGHOST annot_list_opt
	;

local_labels :
	/*empty*/
	| LABEL__ local_label_names SEMICOLON local_labels
	;

local_label_names :
	id_or_typename_as_id
	| id_or_typename_as_id COMMA local_label_names
	;

annotated_statement :
	statement
	| annot_list statement
	;

else_part :
	/*empty*/ %prec if_no_else
	| ELSE annotated_statement
	| LGHOST_ELSE annotated_statement RGHOST %prec ghost_else_no_else
	| LGHOST_ELSE annotated_statement RGHOST ELSE annotated_statement
	;

statement :
	SEMICOLON
	| SPEC annotated_statement
	| comma_expression SEMICOLON
	| block
	| IF paren_comma_expression annotated_statement else_part
	| SWITCH paren_comma_expression annotated_statement
	| opt_loop_annotations WHILE paren_comma_expression annotated_statement
	| opt_loop_annotations DO annotated_statement WHILE paren_comma_expression SEMICOLON
	| opt_loop_annotations FOR LPAREN for_clause opt_expression SEMICOLON opt_expression RPAREN annotated_statement
	| id_or_typename_as_id COLON attribute_nocv_list annotated_statement
	| CASE expression COLON annotated_statement
	| CASE expression ELLIPSIS expression COLON annotated_statement
	| DEFAULT COLON annotated_statement
	| RETURN SEMICOLON
	| RETURN comma_expression SEMICOLON
	| BREAK SEMICOLON
	| CONTINUE SEMICOLON
	| GOTO id_or_typename_as_id SEMICOLON
	| GOTO STAR comma_expression SEMICOLON
	| ASM GOTO asmattr LPAREN asmtemplate asmoutputs RPAREN SEMICOLON
	| ASM asmattr LPAREN asmtemplate asmoutputs RPAREN SEMICOLON
	//| MSASM
	| TRY block EXCEPT paren_comma_expression block
	| TRY block FINALLY block
	;

opt_loop_annotations :
	/*empty*/
	| loop_annotations
	;

loop_annotations :
	loop_annotation
	;

loop_annotation :
	LOOP_ANNOT
	;

for_clause :
	opt_expression SEMICOLON
	| declaration
	;

ghost_parameter_opt :
	/*empty*/
	| ghost_parameter
	;

ghost_parameter :
	LGHOST parameter_list_startscope rest_par_list RPAREN RGHOST
	;

declaration :
	decl_spec_list init_declarator_list SEMICOLON
	| decl_spec_list SEMICOLON
	| SPEC decl_spec_list init_declarator_list SEMICOLON
	| SPEC decl_spec_list SEMICOLON
	| static_assert_declaration
	;

static_assert_declaration :
	STATIC_ASSERT LPAREN expression RPAREN
	| STATIC_ASSERT LPAREN expression COMMA string_constant RPAREN
	;

generic_selection :
	GENERIC LPAREN assignment_expression COMMA generic_association_list RPAREN
	| GENERIC LPAREN assignment_expression RPAREN
	;

generic_association_list :
	generic_association
	| generic_association COMMA generic_association_list
	;

generic_association :
	type_name COLON assignment_expression
	| DEFAULT COLON assignment_expression
	;

init_declarator_list :
	decl_and_init_decl_attr_list
	;

decl_and_init_decl_attr_list :
	init_declarator
	| init_declarator COMMA init_declarator_attr_list
	;

init_declarator_attr_list :
	init_declarator_attr
	| init_declarator_attr COMMA init_declarator_attr_list
	;

init_declarator_attr :
	attribute_nocv_list init_declarator
	;

init_declarator :
	declarator
	| declarator EQ init_expression
	;

decl_spec_wo_type :
	TYPEDEF
	| EXTERN
	| STATIC
	| AUTO
	| REGISTER
	| INLINE
	| NORETURN
	| cvspec
	| attribute_nocv
	;

decl_spec_list :
	decl_spec_wo_type decl_spec_list_opt
	| type_spec decl_spec_list_opt_no_named
	;

decl_spec_list_no_named :
	decl_spec_wo_type decl_spec_list_opt_no_named
	| type_spec decl_spec_list_opt_no_named
	;

decl_spec_list_opt :
	/*empty*/ %prec NAMED_TYPE
	| decl_spec_list
	;

decl_spec_list_opt_no_named :
	/*empty*/ %prec IDENT
	| decl_spec_list_no_named
	;

type_spec :
	VOID
	| CHAR
	| BOOL
	| SHORT
	| INT
	| LONG
	| INT64
	| FLOAT
	| DOUBLE
	| SIGNED
	| UNSIGNED
	| STRUCT id_or_typename
	| STRUCT just_attributes id_or_typename
	| STRUCT id_or_typename LBRACE struct_decl_list RBRACE
	| STRUCT LBRACE struct_decl_list RBRACE
	| STRUCT just_attributes id_or_typename LBRACE struct_decl_list RBRACE
	| STRUCT just_attributes LBRACE struct_decl_list RBRACE
	| UNION id_or_typename
	| UNION id_or_typename LBRACE struct_decl_list RBRACE
	| UNION LBRACE struct_decl_list RBRACE
	| UNION just_attributes id_or_typename LBRACE struct_decl_list RBRACE
	| UNION just_attributes LBRACE struct_decl_list RBRACE
	| ENUM id_or_typename
	| ENUM id_or_typename LBRACE enum_list maybecomma RBRACE
	| ENUM LBRACE enum_list maybecomma RBRACE
	| ENUM just_attributes id_or_typename LBRACE enum_list maybecomma RBRACE
	| ENUM just_attributes LBRACE enum_list maybecomma RBRACE
	| NAMED_TYPE
	| TYPEOF LPAREN expression RPAREN
	| TYPEOF LPAREN type_name RPAREN
	;

struct_decl_list :
	/*empty*/
	| decl_spec_list SEMICOLON struct_decl_list
	| SEMICOLON struct_decl_list
	| decl_spec_list field_decl_list SEMICOLON struct_decl_list
	//| pragma struct_decl_list
	| static_assert_declaration
	| static_assert_declaration SEMICOLON struct_decl_list
	;

field_decl_list :
	field_decl
	| field_decl COMMA field_decl_list
	;

field_decl :
	declarator
	| declarator COLON expression attributes
	| COLON expression
	;

enum_list :
	enumerator
	| enum_list COMMA enumerator
	;

enumerator :
	IDENT
	| IDENT EQ expression
	;

declarator :
	pointer_opt direct_decl attributes_with_asm
	;

attributes_or_static :
	attributes comma_expression_opt
	| attribute attributes STATIC comma_expression
	| STATIC attributes comma_expression
	;

direct_decl :
	id_or_typename
	| LPAREN attributes declarator RPAREN
	| direct_decl LBRACKET attributes_or_static RBRACKET
	| direct_decl LPAREN RPAREN ghost_parameter_opt
	| direct_decl parameter_list_startscope rest_par_list RPAREN ghost_parameter_opt
	;

parameter_list_startscope :
	LPAREN
	;

rest_par_list :
	parameter_decl rest_par_list1
	;

rest_par_list1 :
	/*empty*/
	| COMMA ELLIPSIS
	| COMMA parameter_decl rest_par_list1
	;

parameter_decl :
	decl_spec_list declarator
	| decl_spec_list abstract_decl
	| decl_spec_list
	| LPAREN parameter_decl RPAREN
	;

old_proto_decl :
	pointer_opt direct_old_proto_decl
	;

direct_old_proto_decl :
	direct_decl LPAREN old_parameter_list_ne RPAREN old_pardef_list
	;

old_parameter_list_ne :
	IDENT
	| IDENT COMMA old_parameter_list_ne
	;

old_pardef_list :
	/*empty*/
	| decl_spec_list old_pardef SEMICOLON ELLIPSIS
	| decl_spec_list old_pardef SEMICOLON old_pardef_list
	;

old_pardef :
	declarator
	| declarator COMMA old_pardef
	;

pointer :
	STAR attributes pointer_opt
	;

pointer_opt :
	/*empty*/
	| pointer
	;

type_name :
	decl_spec_list abstract_decl
	| decl_spec_list
	;

abstract_decl :
	pointer_opt abs_direct_decl attributes
	| pointer
	;

abs_direct_decl :
	LPAREN attributes abstract_decl RPAREN
	| abs_direct_decl_opt LBRACKET comma_expression_opt RBRACKET
	| abs_direct_decl parameter_list_startscope rest_par_list RPAREN
	| abs_direct_decl LPAREN RPAREN
	;

abs_direct_decl_opt :
	abs_direct_decl
	|
	;

function_def :
	SPEC function_def_start block
	| function_def_start block
	;

function_def_start :
	decl_spec_list declarator
	| decl_spec_list old_proto_decl
	| IDENT parameter_list_startscope rest_par_list RPAREN ghost_parameter_opt
	| IDENT LPAREN old_parameter_list_ne RPAREN old_pardef_list
	| IDENT LPAREN RPAREN ghost_parameter_opt
	;

cvspec :
	CONST
	| VOLATILE
	| RESTRICT
	| GHOST
	| ATTRIBUTE_ANNOT
	;

attributes :
	/*empty*/
	| attribute attributes
	;

attributes_with_asm :
	/*empty*/
	| attribute attributes_with_asm
	| ASM LPAREN string_constant RPAREN attributes
	;

attribute_nocv :
	ATTRIBUTE LPAREN paren_attr_list RPAREN
	| DECLSPEC paren_attr_list_ne
	| MSATTR
	| THREAD
	| THREAD_LOCAL
	;

attribute_nocv_list :
	/*empty*/
	| attribute_nocv attribute_nocv_list
	;

attribute :
	attribute_nocv
	| CONST
	| RESTRICT
	| VOLATILE
	| GHOST
	| ATTRIBUTE_ANNOT
	;

just_attribute :
	ATTRIBUTE LPAREN paren_attr_list RPAREN
	| DECLSPEC paren_attr_list_ne
	;

just_attributes :
	just_attribute
	| just_attribute just_attributes
	;

//pragma :
//	PRAGMA PRAGMA_EOL
//	| PRAGMA attr PRAGMA_EOL
//	| PRAGMA attr SEMICOLON PRAGMA_EOL
//	| PRAGMA_LINE
//	;

var_attr :
	IDENT
	| NAMED_TYPE
	| DEFAULT COLON CST_INT
	| CONST
	| VOLATILE
	| CST_INT COLON CST_INT
	;

basic_attr :
	CST_INT
	| CST_FLOAT
	| var_attr
	;

basic_attr_list_ne :
	basic_attr
	| basic_attr basic_attr_list_ne
	;

parameter_attr_list_ne :
	basic_attr_list_ne
	| basic_attr_list_ne string_constant
	| basic_attr_list_ne string_constant parameter_attr_list_ne
	;

param_attr_list_ne :
	parameter_attr_list_ne
	| string_constant
	;

primary_attr :
	basic_attr
	| LPAREN attr RPAREN
	| string_constant
	;

postfix_attr :
	primary_attr
	| id_or_typename_as_id paren_attr_list_ne
	| id_or_typename_as_id LPAREN RPAREN
	| basic_attr param_attr_list_ne
	| postfix_attr ARROW id_or_typename
	| postfix_attr DOT id_or_typename
	| postfix_attr LBRACKET attr RBRACKET
	;

unary_attr :
	postfix_attr
	| SIZEOF unary_expression
	| SIZEOF LPAREN type_name RPAREN
	| ALIGNOF unary_expression
	| ALIGNOF LPAREN type_name RPAREN
	| PLUS cast_attr
	| MINUS cast_attr
	| STAR cast_attr
	| AND cast_attr
	| EXCLAM cast_attr
	| TILDE cast_attr
	;

cast_attr :
	unary_attr
	;

multiplicative_attr :
	cast_attr
	| multiplicative_attr STAR cast_attr
	| multiplicative_attr SLASH cast_attr
	| multiplicative_attr PERCENT cast_attr
	;

additive_attr :
	multiplicative_attr
	| additive_attr PLUS multiplicative_attr
	| additive_attr MINUS multiplicative_attr
	;

shift_attr :
	additive_attr
	| shift_attr INF_INF additive_attr
	| shift_attr SUP_SUP additive_attr
	;

relational_attr :
	shift_attr
	| relational_attr INF shift_attr
	| relational_attr SUP shift_attr
	| relational_attr INF_EQ shift_attr
	| relational_attr SUP_EQ shift_attr
	;

equality_attr :
	relational_attr
	| equality_attr EQ_EQ relational_attr
	| equality_attr EXCLAM_EQ relational_attr
	;

bitwise_and_attr :
	equality_attr
	| bitwise_and_attr AND equality_attr
	;

bitwise_xor_attr :
	bitwise_and_attr
	| bitwise_xor_attr CIRC bitwise_and_attr
	;

bitwise_or_attr :
	bitwise_xor_attr
	| bitwise_or_attr PIPE bitwise_xor_attr
	;

logical_and_attr :
	bitwise_or_attr
	| logical_and_attr AND_AND bitwise_or_attr
	;

logical_or_attr :
	logical_and_attr
	| logical_or_attr PIPE_PIPE logical_and_attr
	;

conditional_attr :
	logical_or_attr
	| logical_or_attr QUEST attr_test conditional_attr COLON2 conditional_attr
	;

assign_attr :
	conditional_attr
	| conditional_attr EQ conditional_attr
	;

attr_test :
	;

attr :
	assign_attr
	;

attr_list_ne :
	attr
	| attr COMMA attr_list_ne
	;

attr_list :
	/*empty*/
	| attr_list_ne
	;

paren_attr_list_ne :
	LPAREN attr_list_ne RPAREN
	;

paren_attr_list :
	LPAREN attr_list RPAREN
	;

asmattr :
	/*empty*/
	| VOLATILE asmattr
	| CONST asmattr
	;

asmtemplate :
	one_string
	| one_string asmtemplate
	;

asmoutputs :
	/*empty*/
	| COLON asmoperands asminputs
	;

asmoperands :
	/*empty*/
	| asmoperandsne
	;

asmoperandsne :
	asmoperand
	| asmoperandsne COMMA asmoperand
	;

asmoperand :
	asmopname string_constant LPAREN expression RPAREN
	;

asminputs :
	/*empty*/
	| COLON asmoperands asmclobber
	;

asmopname :
	/*empty*/
	| LBRACKET IDENT RBRACKET
	;

asmclobber :
	/*empty*/
	| COLON asmlabels
	| COLON asmcloberlst_ne asmlabels
	;

asmcloberlst_ne :
	string_constant
	| string_constant COMMA asmcloberlst_ne
	;

asmlabels :
	/*empty*/
	| COLON local_label_names
	;

%%

decdigit   [0-9]
octdigit   [0-7]
hexdigit   [0-9a-fA-F]
binarydigit   [01]
letter   [a-zA-Z]

usuffix   [uU]
lsuffix   "l"|"L"|"ll"|"LL"
intsuffix   {lsuffix}|{usuffix}|{usuffix}{lsuffix}|{lsuffix}{usuffix}|{usuffix}?"i64"

hexprefix   0[xX]
binaryprefix   0[bB]

intnum   {decdigit}+{intsuffix}?
octnum   0{octdigit}+{intsuffix}?
hexnum   {hexprefix}{hexdigit}+{intsuffix}?
binarynum   {binaryprefix}{binarydigit}+{intsuffix}?

exponent   [eE][+-]?{decdigit}+
fraction    "."{decdigit}+
decfloat   ({intnum}?{fraction})|({intnum}{exponent})|({intnum}?{fraction}{exponent})|({intnum}".")|({intnum}"."{exponent})


hexfraction   {hexdigit}*"."{hexdigit}+|{hexdigit}+"."
binexponent   [pP][+-]?{decdigit}+
hexfloat   {hexprefix}{hexfraction}{binexponent}|{hexprefix}{hexdigit}+{binexponent}

floatsuffix   [fFlL]
floatnum   ({decfloat}|{hexfloat}){floatsuffix}?

ident   ({letter}|"_")({letter}|{decdigit}|"_"|"$")*
/*\026 this is the plain old DOS eof char*/
blank   [ \t\f\r\x1A]+
escape   "\\".
hex_escape   "\\"[xX]{hexdigit}+
oct_escape   "\\"{octdigit}{octdigit}?{octdigit}?

/* Pragmas that are not parsed by CIL.  We lex them as PRAGMA_LINE tokens */
/* Solaris-style pragmas:  */
solaris_style_pragmas  "ident"|"section"|"option"|"asm"|"use_section"|"weak"|"redefine_extname"|"TCS_align"
/* Embedded world */
embeded_world_pragmas      "global_register"|"location"
no_parse_pragma    "warning"|"GCC"|{solaris_style_pragmas}|{embeded_world_pragmas}

ghost_comments   "//\n"|("//"[^\n@]([^\n]*("\\\n")?)*\n)


%%

"auto"	AUTO
"const"	CONST
"__const"	CONST
"__const__"	CONST
"static"	STATIC
"extern"	EXTERN
"long"	LONG
"short"	SHORT
"register"	REGISTER
"signed"	SIGNED
"__signed"	SIGNED
"unsigned"	UNSIGNED
"volatile"	VOLATILE
"__volatile"	VOLATILE
/* WW: see /usr/include/sys/cdefs.h for why __signed and __volatile
* are accepted GCC-isms */
"char"	CHAR
"_Bool"	BOOL
"int"	INT
"float"	FLOAT
"double"	DOUBLE
"void"	VOID
"enum"	ENUM
"struct"	STRUCT
"typedef"	TYPEDEF
"union"	UNION
"break"	BREAK
"continue"	CONTINUE
"goto"	GOTO
"return"	RETURN
"switch"	SWITCH
"case"	CASE
"default"	DEFAULT
"while"	WHILE
"do"	DO
"for"	FOR
"if"	IF
"else"	ELSE
/*** Implementation specific keywords ***/
"__signed__"	SIGNED
"__inline__"	INLINE
"inline"	INLINE
"__inline"	INLINE
"_inline"	INLINE
"_Noreturn"	NORETURN
"_Static_assert"	STATIC_ASSERT
"__attribute__"	ATTRIBUTE
"__attribute"	ATTRIBUTE
"__blockattribute__"	BLOCKATTRIBUTE
"__blockattribute"	BLOCKATTRIBUTE
"__asm__"	ASM
"asm"	ASM
"__typeof__"	TYPEOF
"__typeof"	TYPEOF
"typeof"	TYPEOF
"__alignof"	ALIGNOF
"__alignof__"	ALIGNOF
"__volatile__"	VOLATILE
"__volatile"	VOLATILE

"__FUNCTION__"	FUNCTION__
"__func__"	FUNCTION__ /* ISO 6.4.2.2 */
"__PRETTY_FUNCTION__"	PRETTY_FUNCTION__
"__label__"	LABEL__
/*** weimer: GCC arcana ***/
"__restrict"	RESTRICT
"restrict"	RESTRICT
/*      ("__extension__", EXTENSION); */
/**** MS VC ***/
"__int64"	INT64
"__int32"	INT
"_cdecl"	MSATTR
"__cdecl"	MSATTR
"_stdcall"	MSATTR
"__stdcall"	MSATTR
"_fastcall"	MSATTR
"__fastcall"	MSATTR
"__w64"	MSATTR
"__declspec"	DECLSPEC
"__forceinline"	INLINE /* !! we turn forceinline
					 * into inline */
"__try"	TRY
"__except"	EXCEPT
"__finally"	FINALLY
/* weimer: some files produced by 'GCC -E' expect this type to be
* defined */
"__builtin_va_list"	NAMED_TYPE
"__builtin_va_arg"	BUILTIN_VA_ARG
"__builtin_types_compatible_p"	BUILTIN_TYPES_COMPAT
"__builtin_offsetof"	BUILTIN_OFFSETOF
"_Thread_local"	THREAD_LOCAL
/* We recognize __thread for GCC machdeps */
"__thread"	THREAD
"__FC_FILENAME__"	CST_STRING
/* The following C11 tokens are not yet supported, so we provide some
 helpful error messages. Usage of 'fatal' instead of 'error' below
 prevents duplicate error messages due to parsing errors. */
 /*
"_Alignas"	"_Alignas is currently unsupported by Frama-C."
"_Alignof"
"_Complex"
"_Imaginary"
*/
"_Generic"	GENERIC

"/*"(?s:.)*?"*/"	skip()
"//".*		skip()
"\\ghost"	GHOST
{blank}	skip()
\n	skip()
"\\"\r*\n	skip()	/*line continuation*/
"#"<hash_st>
"%:"<hash_st>
"_Pragma" 	PRAGMA
'("\\".|[^'\n\r\\])+'	CST_CHAR
L'("\\".|[^'\n\r\\])+'	CST_WCHAR
\"("\\".|[^"\n\r\\])*\"	CST_STRING
L\"("\\".|[^"\n\r\\])*\"	CST_WSTRING
{floatnum}	CST_FLOAT
/* GCC Extension for binary numbers */
{binarynum}    CST_INT
{hexnum}	CST_INT
{octnum}	CST_INT
{intnum}		CST_INT
/*"!quit!"		EOF*/
"..."			ELLIPSIS
"+="		PLUS_EQ
"-="			MINUS_EQ
"*="			STAR_EQ
"/="			SLASH_EQ
"%="		PERCENT_EQ
"|="			PIPE_EQ
"&="		AND_EQ
"^="		CIRC_EQ
"<<="		INF_INF_EQ
">>="		SUP_SUP_EQ
"<<"		INF_INF
">>"		SUP_SUP
"=="		EQ_EQ
"!="			EXCLAM_EQ
"<="		INF_EQ
">="		SUP_EQ
"="			EQ
"<"			INF
">"			SUP
"++"		PLUS_PLUS
"--"			MINUS_MINUS
"->"			ARROW
"+"			PLUS
"-"			MINUS
"*"			STAR
"/"			SLASH
"%"			PERCENT
"!"			EXCLAM
"&&"		AND_AND
"||"			PIPE_PIPE
"&"			AND
"|"			PIPE
"^"			CIRC
"?"			QUEST
":"			COLON
"~"		        TILDE

"{"		       LBRACE
"}"		       RBRACE
"<%"		LBRACE
"%>"		RBRACE
"["			LBRACKET
"]"			RBRACKET
"<:"			LBRACKET
":>"			RBRACKET
"("		       LPAREN
")"			RPAREN
";"		       SEMICOLON
","			COMMA
"."			DOT
"sizeof"		SIZEOF
"__asm"            ASM

/* If we see __pragma we eat it and the matching parentheses as well */
"__pragma"              skip()

/* __extension__ is a black. The parser runs into some conflicts if we let it
 * pass */
"__extension__"         skip()

{ident}                   IDENT

//eof	EOF


/* # <line number> <file name> ... */
<hash_st> {
	\n<INITIAL>	skip()
	{blank}<.>
	{intnum}<.>		/* We are seeing a line number. This is the number for the
                   * next line */
	"line"<.>        /* MSVC line number info */
                /* For pragmas with irregular syntax, like #pragma warning,
                 * we parse them as a whole line. */
	"pragma"{blank}{no_parse_pragma}<.> PRAGMA_LINE
	"pragma"<.>      PRAGMA
	.<.>
}

%%
