//From: https://github.com/cil-project/cil/blob/936b04103eb573f320c6badf280e8bb17f6e7b26/src/frontc/cparser.mly
/*(*
 *
 * Copyright (c) 2001-2003,
 *  George C. Necula    <necula@cs.berkeley.edu>
 *  Scott McPeak        <smcpeak@cs.berkeley.edu>
 *  Wes Weimer          <weimer@cs.berkeley.edu>
 *  Ben Liblit          <liblit@cs.berkeley.edu>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 * 1. Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * 3. The names of the contributors may not be used to endorse or promote
 * products derived from this software without specific prior written
 * permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 * IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
 * OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 **)
(**
** 1.0	3.22.99	Hugues Cass�	First version.
** 2.0  George Necula 12/12/00: Practically complete rewrite.
*)
*/

%token  IDENT
%token  QUALIFIER
%token CST_CHAR
%token CST_WCHAR
%token  CST_INT
%token  CST_FLOAT
%token  NAMED_TYPE

/* Each character is its own list element, and the terminating nul is not
   included in this list. */
%token CST_STRING
%token CST_WSTRING

//%token EOF
%token CHAR INT BOOL DOUBLE FLOAT VOID INT64 //INT32
%token ENUM STRUCT TYPEDEF UNION
%token SIGNED UNSIGNED LONG SHORT
%token VOLATILE EXTERN STATIC CONST RESTRICT AUTO REGISTER
%token THREAD

%token SIZEOF ALIGNOF

%token EQ PLUS_EQ MINUS_EQ STAR_EQ SLASH_EQ PERCENT_EQ
%token AND_EQ PIPE_EQ CIRC_EQ INF_INF_EQ SUP_SUP_EQ
%token ARROW DOT

%token EQ_EQ EXCLAM_EQ INF SUP INF_EQ SUP_EQ
%token PLUS MINUS STAR
%token SLASH PERCENT
%token TILDE AND
%token PIPE CIRC
%token EXCLAM AND_AND
%token PIPE_PIPE
%token INF_INF SUP_SUP
%token PLUS_PLUS MINUS_MINUS

%token RPAREN
%token LPAREN RBRACE
%token LBRACE
%token LBRACKET RBRACKET
%token COLON
%token SEMICOLON
%token COMMA ELLIPSIS QUEST

%token BREAK CONTINUE GOTO RETURN
%token SWITCH CASE DEFAULT
%token WHILE DO FOR
%token IF TRY EXCEPT FINALLY
%token ELSE

%token ATTRIBUTE INLINE ASM TYPEOF FUNCTION__ PRETTY_FUNCTION__
%token LABEL__
%token BUILTIN_VA_ARG //ATTRIBUTE_USED
//%token BUILTIN_VA_LIST
%token BLOCKATTRIBUTE
%token BUILTIN_TYPES_COMPAT BUILTIN_OFFSETOF
%token DECLSPEC
%token MSASM MSATTR
%token PRAGMA_LINE
%token PRAGMA
%token PRAGMA_EOL

/* sm: cabs tree transformation specification keywords */
%token AT_TRANSFORM AT_TRANSFORMEXPR AT_SPECIFIER AT_EXPR
%token AT_NAME


/* operator precedence */
%nonassoc 	IF
%nonassoc 	ELSE


%left	COMMA
%right	EQ PLUS_EQ MINUS_EQ STAR_EQ SLASH_EQ PERCENT_EQ AND_EQ PIPE_EQ CIRC_EQ INF_INF_EQ SUP_SUP_EQ
%right	QUEST COLON
%left	PIPE_PIPE
%left	AND_AND
%left	PIPE
%left 	CIRC
%left	AND
%left	EQ_EQ EXCLAM_EQ
%left	INF SUP INF_EQ SUP_EQ
%left	INF_INF SUP_SUP
%left	PLUS MINUS
%left	STAR SLASH PERCENT CONST RESTRICT VOLATILE
%right	EXCLAM TILDE PLUS_PLUS MINUS_MINUS RPAREN SIZEOF ALIGNOF //CAST ADDROF
%left 	LBRACKET
%left	DOT ARROW LPAREN LBRACE
%right  NAMED_TYPE     /* We'll use this to handle redefinitions of
                        * NAMED_TYPE as variables */
%left   IDENT


%%

file :
	globals
	;

globals :
	%empty
	| globals global
	| globals SEMICOLON
	;

//location :
//	;

global :
	declaration
	| function_def
	| EXTERN string_constant declaration
	| EXTERN string_constant LBRACE globals RBRACE
	| ASM LPAREN string_constant RPAREN SEMICOLON
	| pragma
	| IDENT LPAREN old_parameter_list_ne RPAREN old_pardef_list SEMICOLON
	| IDENT LPAREN RPAREN SEMICOLON
	| AT_TRANSFORM LBRACE global RBRACE IDENT LBRACE globals RBRACE
	| AT_TRANSFORMEXPR LBRACE expression RBRACE IDENT LBRACE expression RBRACE
	//| location error SEMICOLON
	;

id_or_typename :
	IDENT
	| NAMED_TYPE
	| AT_NAME LPAREN IDENT RPAREN
	;

maybecomma :
	%empty
	| COMMA
	;

primary_expression :
	IDENT
	| constant
	| paren_comma_expression
	| LPAREN block RPAREN
	| AT_EXPR LPAREN IDENT RPAREN
	;

postfix_expression :
	primary_expression
	| postfix_expression bracket_comma_expression
	| postfix_expression LPAREN arguments RPAREN
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
	| AND_AND IDENT
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

one_string_constant :
	CST_STRING
	;

string_list :
	one_string
	| string_list one_string
	;

wstring_list :
	CST_WSTRING
	| wstring_list one_string
	| wstring_list CST_WSTRING
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

/* Previous with poor performance
initializer_list :
	initializer
	| initializer COMMA initializer_list_opt
	;

initializer_list_opt :
	%empty
	| initializer_list
	;
*/
/*Huge performance improvement with this initializer_list_opt/initializer_list changes */
initializer_list :
	initializer
	| initializer_list COMMA initializer
	;

initializer_list_opt :
	%empty
	| initializer_list COMMA
	| initializer_list
	;

initializer :
	init_designators eq_opt init_expression
	| gcc_init_designators init_expression
	| init_expression
	;

eq_opt :
	EQ
	| %empty
	;

init_designators :
	DOT id_or_typename init_designators_opt
	| LBRACKET expression RBRACKET init_designators_opt
	| LBRACKET expression ELLIPSIS expression RBRACKET
	;

init_designators_opt :
	%empty
	| init_designators
	;

gcc_init_designators :
	id_or_typename COLON
	;

arguments :
	%empty
	| comma_expression
	;

opt_expression :
	%empty
	| comma_expression
	;

comma_expression :
	expression
	| comma_expression COMMA expression
	//| error COMMA comma_expression
	;

comma_expression_opt :
	%empty
	| comma_expression
	;

paren_comma_expression :
	LPAREN comma_expression RPAREN
	//| LPAREN error RPAREN
	;

bracket_comma_expression :
	LBRACKET comma_expression RBRACKET
	//| LBRACKET error RBRACKET
	;

block :
	block_begin local_labels block_attrs block_element_list RBRACE
	//| error location RBRACE
	;

block_begin :
	LBRACE
	;

block_attrs :
	%empty
	| BLOCKATTRIBUTE paren_attr_list_ne
	;

/*
block_element_list :
	%empty
	| declaration block_element_list
	| statement block_element_list
	| IDENT COLON
	| pragma block_element_list
	;
*/
block_element_list :
	%empty
	| IDENT COLON
	| block_element_list_oom
	;

block_element_list_oom :
	declaration
	| statement
	| pragma
	| block_element_list_oom declaration
	| block_element_list_oom statement
	| block_element_list_oom pragma
	;

local_labels :
	%empty
	| local_labels LABEL__ local_label_names SEMICOLON
	;

local_label_names :
	IDENT
	| local_label_names COMMA IDENT
	;

statement :
	SEMICOLON
	| comma_expression SEMICOLON
	| block
	| IF paren_comma_expression statement %prec IF
	| IF paren_comma_expression statement ELSE statement
	| SWITCH paren_comma_expression statement
	| WHILE paren_comma_expression statement
	| DO statement WHILE paren_comma_expression SEMICOLON
	| FOR LPAREN for_clause opt_expression SEMICOLON opt_expression RPAREN statement
	| IDENT COLON attribute_nocv_list statement
	| CASE expression COLON statement
	| CASE expression ELLIPSIS expression COLON statement
	| DEFAULT COLON statement
	| RETURN SEMICOLON
	| RETURN comma_expression SEMICOLON
	| BREAK SEMICOLON
	| CONTINUE SEMICOLON
	| GOTO IDENT SEMICOLON
	| GOTO STAR comma_expression SEMICOLON
	| ASM asmattr LPAREN asmtemplate asmoutputs RPAREN SEMICOLON
	| MSASM
	| TRY block EXCEPT paren_comma_expression block
	| TRY block FINALLY block
	//| error location SEMICOLON
	;

for_clause :
	opt_expression SEMICOLON
	| declaration
	;

declaration :
	decl_spec_list init_declarator_list SEMICOLON
	| decl_spec_list SEMICOLON
	;

init_declarator_list :
	init_declarator
	| init_declarator_list COMMA init_declarator
	;

init_declarator :
	declarator
	| declarator EQ init_expression
	;

decl_spec_list :
	TYPEDEF decl_spec_list_opt
	| EXTERN decl_spec_list_opt
	| STATIC decl_spec_list_opt
	| AUTO decl_spec_list_opt
	| REGISTER decl_spec_list_opt
	| type_spec decl_spec_list_opt_no_named
	| INLINE decl_spec_list_opt
	| cvspec decl_spec_list_opt
	| attribute_nocv decl_spec_list_opt
	| AT_SPECIFIER LPAREN IDENT RPAREN
	;

decl_spec_list_opt :
	%empty %prec NAMED_TYPE
	| decl_spec_list
	;

decl_spec_list_opt_no_named :
	%empty %prec IDENT
	| decl_spec_list
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

/*
struct_decl_list :
	%empty
	| decl_spec_list SEMICOLON struct_decl_list
	| SEMICOLON struct_decl_list
	| decl_spec_list field_decl_list SEMICOLON struct_decl_list
	| pragma struct_decl_list
	//| error SEMICOLON struct_decl_list
	;
*/
struct_decl_list :
	%empty
	| struct_decl_list_oom
	;

struct_decl_list_oom :
	SEMICOLON
	| struct_decl_list_oom SEMICOLON
	| decl_spec_list SEMICOLON
	| struct_decl_list_oom decl_spec_list SEMICOLON
	| decl_spec_list field_decl_list SEMICOLON
	| struct_decl_list_oom decl_spec_list field_decl_list SEMICOLON
	| pragma
	| struct_decl_list_oom pragma
	;

field_decl_list :
	field_decl
	| field_decl_list COMMA field_decl
	;

field_decl :
	declarator
	| declarator COLON expression attributes
	| COLON expression
	;

enum_list :
	enumerator
	| enum_list COMMA enumerator
	//| enum_list COMMA error
	;

enumerator :
	IDENT
	| IDENT EQ expression
	;

declarator :
	pointer_opt direct_decl attributes_with_asm
	;

direct_decl :
	id_or_typename
	| LPAREN attributes declarator RPAREN
	| direct_decl LBRACKET attributes comma_expression_opt RBRACKET
	//| direct_decl LBRACKET attributes error RBRACKET
	| direct_decl parameter_list_startscope rest_par_list RPAREN
	;

parameter_list_startscope :
	LPAREN
	;

rest_par_list :
	%empty
	| parameter_decl rest_par_list1
	;

/*
rest_par_list1 :
	%empty
	| COMMA ELLIPSIS
	| COMMA parameter_decl rest_par_list1
	;
*/
rest_par_list1 :
	%empty
	| COMMA ELLIPSIS
	| rest_par_list_oom
	;

rest_par_list_oom :
	COMMA parameter_decl
	| rest_par_list_oom COMMA parameter_decl
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
	| direct_decl LPAREN RPAREN
	;

old_parameter_list_ne :
	IDENT
	| old_parameter_list_ne COMMA IDENT
	;

/*
old_pardef_list :
	%empty
	| decl_spec_list old_pardef SEMICOLON ELLIPSIS
	| decl_spec_list old_pardef SEMICOLON old_pardef_list
	;
*/
old_pardef_list :
	%empty
	| decl_spec_list old_pardef SEMICOLON ELLIPSIS
	| old_pardef_list_oom
	;

old_pardef_list_oom :
	decl_spec_list old_pardef SEMICOLON
	| old_pardef_list_oom decl_spec_list old_pardef SEMICOLON
	;

old_pardef :
	declarator
	| old_pardef COMMA declarator
	//| error
	;

pointer :
	STAR attributes pointer_opt
	;

pointer_opt :
	%empty
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
	//| LPAREN error RPAREN
	| abs_direct_decl_opt LBRACKET comma_expression_opt RBRACKET
	| abs_direct_decl parameter_list_startscope rest_par_list RPAREN
	;

abs_direct_decl_opt :
	abs_direct_decl
	| %empty
	;

function_def :
	function_def_start block
	;

function_def_start :
	decl_spec_list declarator
	| decl_spec_list old_proto_decl
	| IDENT parameter_list_startscope rest_par_list RPAREN
	| IDENT LPAREN old_parameter_list_ne RPAREN old_pardef_list
	| IDENT LPAREN RPAREN
	;

cvspec :
	CONST
	| VOLATILE
	| RESTRICT
	;

attributes :
	%empty
	| attributes attribute
	;

attributes_with_asm :
	%empty
	| attribute attributes_with_asm
	| ASM LPAREN string_constant RPAREN attributes
	;

attribute_nocv :
	ATTRIBUTE LPAREN paren_attr_list RPAREN
	| DECLSPEC paren_attr_list_ne
	| MSATTR
	| THREAD
	| QUALIFIER
	;

attribute_nocv_list :
	%empty
	| attribute_nocv_list attribute_nocv
	;

attribute :
	attribute_nocv
	| CONST
	| RESTRICT
	| VOLATILE
	;

just_attribute :
	ATTRIBUTE LPAREN paren_attr_list RPAREN
	| DECLSPEC paren_attr_list_ne
	;

just_attributes :
	just_attribute
	| just_attributes just_attribute
	;

pragma :
	PRAGMA attr PRAGMA_EOL
	| PRAGMA attr SEMICOLON PRAGMA_EOL
	| PRAGMA_LINE
	;

primary_attr :
	IDENT
	| NAMED_TYPE
	| LPAREN attr RPAREN
	| IDENT IDENT
	| CST_INT
	| string_constant
	| CONST
	| IDENT COLON CST_INT
	| CST_INT COLON CST_INT
	| DEFAULT COLON CST_INT
	| VOLATILE
	;

postfix_attr :
	primary_attr
	| IDENT LPAREN RPAREN
	| IDENT paren_attr_list_ne
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
	| logical_or_attr QUEST conditional_attr COLON conditional_attr
	;

attr :
	conditional_attr
	;

attr_list_ne :
	attr
	| attr_list_ne COMMA attr
	//| error COMMA attr_list_ne
	;

attr_list :
	%empty
	| attr_list_ne
	;

paren_attr_list_ne :
	LPAREN attr_list_ne RPAREN
	//| LPAREN error RPAREN
	;

paren_attr_list :
	LPAREN attr_list RPAREN
	//| LPAREN error RPAREN
	;

asmattr :
	%empty
	| asmattr VOLATILE
	| asmattr CONST
	;

asmtemplate :
	one_string_constant
	| asmtemplate one_string_constant
	;

asmoutputs :
	%empty
	| COLON asmoperands asminputs
	;

asmoperands :
	%empty
	| asmoperandsne
	;

asmoperandsne :
	asmoperand
	| asmoperandsne COMMA asmoperand
	;

asmoperand :
	asmopname string_constant LPAREN expression RPAREN
	//| asmopname string_constant LPAREN error RPAREN
	;

asminputs :
	%empty
	| COLON asmoperands asmclobber
	;

asmopname :
	%empty
	| LBRACKET IDENT RBRACKET
	;

asmclobber :
	%empty
	| COLON asmcloberlst
	;

asmcloberlst :
	%empty
	| asmcloberlst_ne
	;

asmcloberlst_ne :
	one_string_constant
	| asmcloberlst_ne COMMA one_string_constant
	;

%%

decdigit	[0-9]
octdigit	[0-7]
hexdigit	[0-9a-fA-F]
letter	[a-zA-Z]


usuffix	[uU]
lsuffix	"l"|"L"|"ll"|"LL"
intsuffix	{lsuffix}|{usuffix}|{usuffix}{lsuffix}|{lsuffix}{usuffix}|{usuffix}?"i64"


hexprefix	"0"[xX]

intnum	{decdigit}+{intsuffix}?
octnum	"0"{octdigit}+{intsuffix}?
hexnum	{hexprefix}{hexdigit}+{intsuffix}?

exponent	[eE][+-]?{decdigit}+
fraction 	"."{decdigit}+
decfloat	({intnum}?{fraction})|({intnum}{exponent})|({intnum}?{fraction}{exponent})|({intnum}".")|({intnum}"."{exponent})

hexfraction	{hexdigit}*"."{hexdigit}+|{hexdigit}+"."
binexponent	[pP][+-]?{decdigit}+
hexfloat	{hexprefix}{hexfraction}{binexponent}|{hexprefix}{hexdigit}+{binexponent}

floatsuffix	[fFlLqQ]|"f128"|"F128"
floatnum	({decfloat}|{hexfloat}){floatsuffix}?

complexnum	({decfloat}|{hexfloat})(([iI]{floatsuffix})|({floatsuffix}?[iI]))


blank	[ \t\n\r]+
escape	"\\_"
hex_escape	"\\"[xX]{hexdigit}+
oct_escape	"\\"{octdigit}{octdigit}?{octdigit}?
hexquad	{hexdigit}{4}
universal_escape	"\\"("u"{hexquad}|"U"{hexquad}{hexquad})
ident	({letter}|"_"|{universal_escape})({letter}|{decdigit}|"_"|{universal_escape})*

/* Pragmas that are not parsed by CIL.  We lex them as PRAGMA_LINE tokens */
no_parse_pragma0   "warning"|"GCC"|"STDC"|"clang"
/* Solaris-style pragmas:  */
no_parse_pragma1	"ident"|"section"|"option"|"asm"|"use_section"|"weak"
no_parse_pragma2             "redefine_extname"|"TCS_align"|"mark"

no_parse_pragma	{no_parse_pragma0}|{no_parse_pragma1}|{no_parse_pragma2}

str_body	(\\.|[^"\r\n\\])*\"
char_body	(\\.|[^'\r\n\\])\'

%%

"auto"	AUTO
"const"	CONST
"__const"	CONST
"__const__"	CONST
//"_Atomic"	ATOMIC
//"_Complex"	COMPLEX
//"__complex__"	COMPLEX
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
 are accepted GCC-isms */
"_Bool"	BOOL
"char"	CHAR
"int"	INT
"float"	FLOAT
//"__float128"	FLOAT128
//"_Float128"	FLOAT128
//"_Float32"	FLOAT32
//"_Float64"	FLOAT64
//"_Float32x"	FLOAT32X
//"_Float64x"	FLOAT64X
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
"_inline"	INLINE
//"_Noreturn"	NORETURN
//"_Static_assert"	STATIC_ASSERT
"__attribute__"	ATTRIBUTE
"__attribute"	ATTRIBUTE
/*
"__attribute_used__"	ATTRIBUTE_USED
*/
"__blockattribute__"	BLOCKATTRIBUTE
"__blockattribute"	BLOCKATTRIBUTE
"__asm__"	ASM
"asm"	ASM
"__typeof__"	TYPEOF
"__typeof"	TYPEOF
"typeof"	TYPEOF
"__alignof"	ALIGNOF
"_Alignof"	ALIGNOF
"__alignof__"	ALIGNOF
//"_Alignas"	ALIGNAS
"__volatile__"	VOLATILE
"__volatile"	VOLATILE
//"__real__"	REAL
//"__imag__"	IMAG
//"__builtin_classify_type"	CLASSIFYTYPE
"__FUNCTION__"	FUNCTION__
"__func__"	FUNCTION__  /* ISO 6.4.2.2 */
"__PRETTY_FUNCTION__"	PRETTY_FUNCTION__
"__label__"	LABEL__
/*** weimer: GCC arcana ***/
"__restrict"	RESTRICT
"__restrict__"	RESTRICT
"restrict"	RESTRICT
//"__auto_type"	AUTOTYPE
/*      "__extension__"	EXTENSION */
/**** MS VC ***/
"__int32"	INT
"__int64"	INT64
//"__int128"	INT128
"__declspec"	DECLSPEC
"__forceinline"	INLINE  /* !! we turn forceinline
					   into inline */
/* weimer: some files produced by 'GCC -E' expect this type to be
 defined */
"__builtin_va_list"	NAMED_TYPE
//"__builtin_va_list"	BUILTIN_VA_ARG
"__builtin_va_arg"	BUILTIN_VA_ARG
"__builtin_types_compatible_p"	BUILTIN_TYPES_COMPAT
"__builtin_offsetof"	BUILTIN_OFFSETOF
/* On some versions of GCC __thread is a regular identifier */
"__thread"	THREAD
//"_Generic"	GENERIC

"/*"(?s:.)*?"*/"	skip()
"//".*	skip()
{blank}	skip()
"\n"	skip()         //PRAGMA_EOL
"\\""\r"*"\n"        skip()

//"#"			{ addWhite lexbuf; hash lexbuf}
//"_Pragma" 	        { PRAGMA (currentLoc ()) }

'{char_body}			CST_CHAR
"L'"{char_body}		CST_WCHAR
//"u'"{char_body}      CST_CHAR16
//"U'"{char_body}      CST_CHAR32

/* matth: BUG:  this could be either a regular string or a wide string.
    e.g. if it's the "world" in
       L"Hello, " "world"
    then it should be treated as wide even though there's no L immediately
    preceding it.  See test/small1/wchar5.c for a failure case. */

\"{str_body}            CST_STRING
//"u8\""{str_body}    CST_U8STRING
/* weimer: wchar_t string literal */
"L\""{str_body}	CST_WSTRING
//"u\""{str_body}       CST_STRING16
//"U\""{str_body}       CST_STRING32

{floatnum}		CST_FLOAT
//{complexnum}  CST_COMPLEX
{hexnum}			CST_INT
{octnum}			CST_INT
{intnum}			CST_INT
//"!quit!"		EOF
"..."			ELLIPSIS
"+="			PLUS_EQ
"-="			MINUS_EQ
"*="			STAR_EQ
"/="			SLASH_EQ
"%="			PERCENT_EQ
"|="			PIPE_EQ
"&="			AND_EQ
"^="			CIRC_EQ
"<<="			INF_INF_EQ
">>="			SUP_SUP_EQ
"<<"			INF_INF
">>"			SUP_SUP
"=="			EQ_EQ
"!="			EXCLAM_EQ
"<="			INF_EQ
">="			SUP_EQ
"="				EQ
"<"				INF
">"				SUP
"++"			PLUS_PLUS
"--"			MINUS_MINUS
"->"			ARROW
"+"				PLUS
"-"				MINUS
"*"				STAR
"/"				SLASH
"%"				PERCENT
"!"			EXCLAM
"&&"			AND_AND
"||"			PIPE_PIPE
"&"				AND
"|"				PIPE
"^"				CIRC
"?"				QUEST
":"				COLON
"~"		       TILDE

"{"		       LBRACE
"}"		       RBRACE
"["				LBRACKET
"]"				RBRACKET
"("		       LPAREN
")"				RPAREN
";"		       SEMICOLON
","				COMMA
"."				DOT
"sizeof"		SIZEOF
 "__asm"                 ASM

/* If we see __pragma we eat it and the matching parentheses as well */
//"__pragma"

/* sm: tree transformation keywords */
"@transform"            AT_TRANSFORM
"@transformExpr"        AT_TRANSFORMEXPR
"@specifier"            AT_SPECIFIER
"@expr"                 AT_EXPR
"@name"                 AT_NAME

/* __extension__ is a black. The parser runs into some conflicts if we let it
   pass */
"__extension__"         skip()

"_cdecl"	MSATTR
"__cdecl"	MSATTR
"_stdcall"	MSATTR
"__stdcall"	MSATTR
"_fastcall"	MSATTR
"__fastcall"	MSATTR
"__w64"	MSATTR

"__try"	TRY
"__except"	EXCEPT
"__finally"	FINALLY

{ident}			IDENT
"$"{ident}	QUALIFIER
//eof			{EOF}
//_			{E.parse_error "Invalid symbol"}

%%
