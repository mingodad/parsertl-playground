//From: https://github.com/souffle-lang/souffle/blob/master/src/parser/parser.yy

//%token IP_NUMBER

/*Tokens*/
%token END
%token STRING
%token IDENT
%token NUMBER
%token UNSIGNED
%token FLOAT
%token AUTOINC
%token PRAGMA
%token OUTPUT_QUALIFIER
%token INPUT_QUALIFIER
%token PRINTSIZE_QUALIFIER
%token BRIE_QUALIFIER
%token BTREE_QUALIFIER
%token BTREE_DELETE_QUALIFIER
%token EQREL_QUALIFIER
%token OVERRIDABLE_QUALIFIER
%token INLINE_QUALIFIER
%token NO_INLINE_QUALIFIER
%token MAGIC_QUALIFIER
%token NO_MAGIC_QUALIFIER
%token TMATCH
%token TCONTAINS
%token STATEFUL
%token CAT
%token ORD
%token RANGE
%token STRLEN
%token SUBSTR
%token MEAN
%token MIN
%token MAX
%token COUNT
%token SUM
%token TRUELIT
%token FALSELIT
%token PLAN
%token ITERATION
%token CHOICEDOMAIN
%token IF
%token DECL
%token FUNCTOR
%token INPUT_DECL
%token OUTPUT_DECL
%token DEBUG_DELTA
//%token UNIQUE
%token PRINTSIZE_DECL
%token LIMITSIZE_DECL
%token OVERRIDE
%token TYPE
%token LATTICE
%token COMPONENT
%token INSTANTIATE
%token NUMBER_TYPE
%token SYMBOL_TYPE
%token TOFLOAT
%token TONUMBER
%token TOSTRING
%token TOUNSIGNED
//%token ITOU
//%token ITOF
//%token UTOI
//%token UTOF
//%token FTOI
//%token FTOU
%token AS
%token AT
%token NIL
%token PIPE
%token LBRACKET
%token RBRACKET
%token UNDERSCORE
%token DOLLAR
%token PLUS
%token MINUS
%token EXCLAMATION
%token LPAREN
%token RPAREN
%token COMMA
%token COLON
//%token DOUBLECOLON
%token SEMICOLON
%token DOT
%token EQUALS
%token STAR
%token SLASH
%token CARET
%token PERCENT
%token LBRACE
%token RBRACE
%token SUBTYPE
%token LT
%token GT
%token LE
%token GE
%token NE
%token MAPSTO
%token BW_AND
%token BW_OR
%token BW_XOR
%token BW_SHIFT_L
%token BW_SHIFT_R
%token BW_SHIFT_R_UNSIGNED
%token BW_NOT
%token L_AND
%token L_OR
%token L_XOR
%token L_NOT
//%token FOLD

%left /*1*/ L_OR
%left /*2*/ L_XOR
%left /*3*/ L_AND
%left /*4*/ BW_OR
%left /*5*/ BW_XOR
%left /*6*/ BW_AND
%left /*7*/ BW_SHIFT_L BW_SHIFT_R BW_SHIFT_R_UNSIGNED
%left /*8*/ PLUS MINUS
%left /*9*/ STAR SLASH PERCENT
%precedence /*10*/ BW_NOT L_NOT NEG
%right /*11*/ CARET

%start program

%%

program :
	END
	| unit
	;

unit :
	/*empty*/
	| unit directive_head
	| unit rule
	| unit fact
	| unit component_decl
	| unit component_init
	| unit pragma
	| unit type_decl
	| unit lattice_decl
	| unit functor_decl
	| unit relation_decl
	;

qualified_name :
	IDENT
	| qualified_name DOT IDENT
	;

type_decl :
	TYPE IDENT SUBTYPE qualified_name
	| TYPE IDENT EQUALS union_type_list
	| TYPE IDENT EQUALS record_type_list
	| TYPE IDENT EQUALS adt_branch_list
	| NUMBER_TYPE IDENT
	| SYMBOL_TYPE IDENT
	| TYPE IDENT
	;

record_type_list :
	LBRACKET RBRACKET
	| LBRACKET non_empty_attributes RBRACKET
	;

union_type_list :
	qualified_name
	| union_type_list PIPE qualified_name
	;

adt_branch_list :
	adt_branch
	| adt_branch_list PIPE adt_branch
	;

adt_branch :
	IDENT LBRACE RBRACE
	| IDENT LBRACE non_empty_attributes RBRACE
	;

lattice_decl :
	LATTICE IDENT LT GT LBRACE lattice_operator_list RBRACE
	;

lattice_operator_list :
	lattice_operator COMMA lattice_operator_list
	| lattice_operator
	;

lattice_operator :
	IDENT MAPSTO arg
	;

relation_decl :
	DECL relation_names attributes_list relation_tags dependency_list
	| DECL IDENT EQUALS DEBUG_DELTA LPAREN IDENT RPAREN relation_tags
	;

relation_names :
	IDENT
	| relation_names COMMA IDENT
	;

attributes_list :
	LPAREN RPAREN
	| LPAREN non_empty_attributes RPAREN
	;

non_empty_attributes :
	attribute
	| non_empty_attributes COMMA attribute
	;

attribute :
	IDENT COLON qualified_name
	| IDENT COLON qualified_name LT GT
	;

relation_tags :
	/*empty*/
	| relation_tags OVERRIDABLE_QUALIFIER
	| relation_tags INLINE_QUALIFIER
	| relation_tags NO_INLINE_QUALIFIER
	| relation_tags MAGIC_QUALIFIER
	| relation_tags NO_MAGIC_QUALIFIER
	| relation_tags BRIE_QUALIFIER
	| relation_tags BTREE_QUALIFIER
	| relation_tags BTREE_DELETE_QUALIFIER
	| relation_tags EQREL_QUALIFIER
	| relation_tags OUTPUT_QUALIFIER
	| relation_tags INPUT_QUALIFIER
	| relation_tags PRINTSIZE_QUALIFIER
	;

non_empty_attribute_names :
	IDENT
	| non_empty_attribute_names COMMA IDENT
	;

dependency :
	IDENT
	| LPAREN non_empty_attribute_names RPAREN
	;

dependency_list_aux :
	dependency
	| dependency_list_aux COMMA dependency
	;

dependency_list :
	/*empty*/
	| CHOICEDOMAIN dependency_list_aux
	;

fact :
	atom DOT
	;

rule :
	rule_def
	| rule_def query_plan
	| atom LE atom IF body DOT
	| atom LE atom IF body DOT query_plan
	;

rule_def :
	head IF body DOT
	;

head :
	atom
	| head COMMA atom
	;

body :
	disjunction
	;

disjunction :
	conjunction
	| disjunction SEMICOLON conjunction
	;

conjunction :
	term
	| conjunction COMMA term
	;

term :
	atom
	| constraint
	| LPAREN disjunction RPAREN
	| EXCLAMATION term
	;

atom :
	qualified_name LPAREN arg_list RPAREN
	;

constraint :
	arg LT arg
	| arg GT arg
	| arg LE arg
	| arg GE arg
	| arg EQUALS arg
	| arg NE arg
	| TMATCH LPAREN arg COMMA arg RPAREN
	| TCONTAINS LPAREN arg COMMA arg RPAREN
	| TRUELIT
	| FALSELIT
	;

arg_list :
	/*empty*/
	| non_empty_arg_list
	;

non_empty_arg_list :
	arg
	| non_empty_arg_list COMMA arg
	;

arg :
	STRING
	| FLOAT
	| UNSIGNED
	| NUMBER
	| ITERATION LPAREN RPAREN
	| UNDERSCORE
	| DOLLAR
	| AUTOINC LPAREN RPAREN
	| IDENT
	| NIL
	| LBRACKET arg_list RBRACKET
	| DOLLAR qualified_name LPAREN arg_list RPAREN
	| LPAREN arg RPAREN
	| AS LPAREN arg COMMA qualified_name RPAREN
	| AT IDENT LPAREN arg_list RPAREN
	| functor_built_in LPAREN arg_list RPAREN
	| aggregate_func LPAREN arg COMMA non_empty_arg_list RPAREN
	| MINUS /*8L*/ arg %prec NEG /*10P*/
	| BW_NOT /*10P*/ arg
	| L_NOT /*10P*/ arg
	| arg PLUS /*8L*/ arg
	| arg MINUS /*8L*/ arg
	| arg STAR /*9L*/ arg
	| arg SLASH /*9L*/ arg
	| arg PERCENT /*9L*/ arg
	| arg CARET /*11R*/ arg
	| arg L_AND /*3L*/ arg
	| arg L_OR /*1L*/ arg
	| arg L_XOR /*2L*/ arg
	| arg BW_AND /*6L*/ arg
	| arg BW_OR /*4L*/ arg
	| arg BW_XOR /*5L*/ arg
	| arg BW_SHIFT_L /*7L*/ arg
	| arg BW_SHIFT_R /*7L*/ arg
	| arg BW_SHIFT_R_UNSIGNED /*7L*/ arg
	| AT AT IDENT arg_list COLON arg COMMA aggregate_body
	| aggregate_func arg_list COLON aggregate_body
	;

functor_built_in :
	CAT
	| ORD
	| RANGE
	| STRLEN
	| SUBSTR
	| TOFLOAT
	| TONUMBER
	| TOSTRING
	| TOUNSIGNED
	;

aggregate_func :
	COUNT
	| MAX
	| MEAN
	| MIN
	| SUM
	;

aggregate_body :
	LBRACE body RBRACE
	| atom
	;

query_plan :
	PLAN query_plan_list
	;

query_plan_list :
	NUMBER COLON plan_order
	| query_plan_list COMMA NUMBER COLON plan_order
	;

plan_order :
	LPAREN RPAREN
	| LPAREN non_empty_plan_order_list RPAREN
	;

non_empty_plan_order_list :
	NUMBER
	| non_empty_plan_order_list COMMA NUMBER
	;

component_decl :
	component_head LBRACE component_body RBRACE
	;

component_head :
	COMPONENT component_type
	| component_head COLON component_type
	| component_head COMMA component_type
	;

component_type :
	IDENT component_type_params
	;

component_type_params :
	/*empty*/
	| LT component_param_list GT
	;

component_param_list :
	IDENT
	| component_param_list COMMA IDENT
	;

component_body :
	/*empty*/
	| component_body directive_head
	| component_body rule
	| component_body fact
	| component_body OVERRIDE IDENT
	| component_body component_init
	| component_body component_decl
	| component_body type_decl
	| component_body lattice_decl
	| component_body relation_decl
	;

component_init :
	INSTANTIATE IDENT EQUALS component_type
	;

functor_decl :
	FUNCTOR IDENT LPAREN functor_arg_type_list RPAREN COLON qualified_name
	| FUNCTOR IDENT LPAREN functor_arg_type_list RPAREN COLON qualified_name STATEFUL
	;

functor_arg_type_list :
	/*empty*/
	| non_empty_functor_arg_type_list
	;

non_empty_functor_arg_type_list :
	functor_attribute
	| non_empty_functor_arg_type_list COMMA functor_attribute
	;

functor_attribute :
	qualified_name
	| IDENT COLON qualified_name
	;

pragma :
	PRAGMA STRING STRING
	| PRAGMA STRING
	;

directive_head :
	directive_head_decl directive_list
	;

directive_head_decl :
	INPUT_DECL
	| OUTPUT_DECL
	| PRINTSIZE_DECL
	| LIMITSIZE_DECL
	;

directive_list :
	relation_directive_list
	| relation_directive_list LPAREN RPAREN
	| relation_directive_list LPAREN non_empty_key_value_pairs RPAREN
	;

relation_directive_list :
	qualified_name
	| relation_directive_list COMMA qualified_name
	;

non_empty_key_value_pairs :
	IDENT EQUALS kvp_value
	| non_empty_key_value_pairs COMMA IDENT EQUALS kvp_value
	;

kvp_value :
	STRING
	| IDENT
	| NUMBER
	| TRUELIT
	| FALSELIT
	;

%%

%x  INCLUDE /*COMMENT*/

WS [ \t\r\v\f]

%%

".decl"                          DECL
".functor"                       FUNCTOR
".input"                         INPUT_DECL
".output"                        OUTPUT_DECL
".printsize"                     PRINTSIZE_DECL
".lattice"                       LATTICE
".limitsize"                     LIMITSIZE_DECL
".type"                          TYPE
".comp"                          COMPONENT
".init"                          INSTANTIATE
".number_type"                   NUMBER_TYPE
".symbol_type"                   SYMBOL_TYPE
".override"                      OVERRIDE
".pragma"                        PRAGMA
".plan"                          PLAN

<INITIAL>".include"<INCLUDE>
".once"	END

"debug_delta"                         DEBUG_DELTA
"autoinc"                             AUTOINC
"band"                                BW_AND
"bor"                                 BW_OR
"bxor"                                BW_XOR
"bnot"                                BW_NOT
"bshl"                                BW_SHIFT_L
"bshr"                                BW_SHIFT_R
"bshru"                               BW_SHIFT_R_UNSIGNED
"land"                                L_AND
"lor"                                 L_OR
"lxor"                                L_XOR
"lnot"                                L_NOT
"match"                               TMATCH
"mean"                                MEAN
"cat"                                 CAT
"ord"                                 ORD
/*"fold"                                FOLD*/
"range"                               RANGE
"strlen"                              STRLEN
"substr"                              SUBSTR
"stateful"                            STATEFUL
"contains"                            TCONTAINS
"output"                              OUTPUT_QUALIFIER
"input"                               INPUT_QUALIFIER
"overridable"                         OVERRIDABLE_QUALIFIER
"printsize"                           PRINTSIZE_QUALIFIER
"eqrel"                               EQREL_QUALIFIER
"inline"                              INLINE_QUALIFIER
"no_inline"                           NO_INLINE_QUALIFIER
"magic"                               MAGIC_QUALIFIER
"no_magic"                            NO_MAGIC_QUALIFIER
"brie"                                BRIE_QUALIFIER
"btree_delete"                        BTREE_DELETE_QUALIFIER
"btree"                               BTREE_QUALIFIER
"min"                                 MIN
"max"                                 MAX
"as"                                  AS
"nil"                                 NIL
"_"                                   UNDERSCORE
"count"                               COUNT
"sum"                                 SUM
"true"                                TRUELIT
"false"                               FALSELIT
"to_float"                            TOFLOAT
"to_number"                           TONUMBER
"to_string"                           TOSTRING
"to_unsigned"                         TOUNSIGNED
"choice-domain"                       CHOICEDOMAIN
"recursive_iteration_cnt"             ITERATION

/*
"__FILE__"                            STRING
"__LINE__"                            NUMBER
"__INCL__"                            STRING
*/

"|"                                   PIPE
"["                                   LBRACKET
"]"                                   RBRACKET
"$"                                   DOLLAR
"+"                                   PLUS
"-"                                   MINUS
"("                                   LPAREN
")"                                   RPAREN
","                                   COMMA
":"                                   COLON
";"                                   SEMICOLON
"."                                   DOT
"<:"                                  SUBTYPE
"<="                                  LE
">="                                  GE
"!="                                  NE
"="                                   EQUALS
"!"                                   EXCLAMATION
"*"                                   STAR
"@"                                   AT
"/"                                   SLASH
"^"                                   CARET
"%"                                   PERCENT
"{"                                   LBRACE
"}"                                   RBRACE
"<"                                   LT
">"                                   GT
":-"                                  IF
"->"                                  MAPSTO

//[0-9]+"."[0-9]+"."[0-9]+"."[0-9]+	IP_NUMBER

[0-9]+[.][0-9]+                       FLOAT
[0-9]+                                NUMBER
0b[0-1]+                              NUMBER
0x[a-fA-F0-9]+                        NUMBER
[0-9]+u                               UNSIGNED
0b[0-1]+u                             UNSIGNED
0x[a-fA-F0-9]+u                       UNSIGNED
/* Order matter if identifier comes before keywords they are classified as identifier */
[\?a-zA-Z]|[_\?a-zA-Z][_\?a-zA-Z0-9]+ IDENT
\"(\\.|[^"\\])*\"                     STRING

\#.*$	skip()
"//".*$	skip()
\/\*(?s:.)*?\*\/	skip()

<INCLUDE>{WS}+<.>	skip()
<INCLUDE>\"(\\.|[^"\\])*\"<INITIAL>	skip()

\n	skip()
{WS}+	skip()

%%
