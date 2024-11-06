//From: https://github.com/CIFASIS/qss-solver/blob/33e6277a62e39f5193f9d186c522227ecee1c504/src/mmoc/ast/parser/mocc.y

/*Tokens*/
%token TOKALGORITHM
%token TOKAND
%token TOKANNOTATION
%token TOKASSING
%token TOKBLOCK
%token TOKBREAK
%token TOKCARET
%token TOKCBRACE
%token TOKCBRACKET
%token TOKCLASS
%token TOKCOLON
%token TOKCOMA
%token TOKCOMPEQ
%token TOKCOMPNE
%token TOKCONNECT
%token TOKCONNECTOR
%token TOKCONSTANT
%token TOKCONSTRAINEDBY
%token TOKCPAREN
%token TOKDER
%token TOKDISCRETE
%token TOKDOT
%token TOKDOTCARET
%token TOKDOTMINUS
%token TOKDOTPLUS
%token TOKDOTSLASH
%token TOKDOTSTAR
%token TOKEACH
%token TOKELSE
%token TOKELSEIF
%token TOKELSEWHEN
%token TOKENCAPSULATED
%token TOKEND
%token TOKENDSUB
%token TOKENUMERATION
%token TOKEQUAL
%token TOKEQUATION
%token TOKEXPANDABLE
%token TOKEXTENDS
%token TOKEXTERNAL
%token TOKFALSE
%token TOKFINAL
%token TOKFLOAT
%token TOKFLOW
%token TOKFOR
%token TOKFUNCTION
%token TOKGREATER
%token TOKGREATEREQ
%token TOKID
%token TOKIF
%token TOKIMPORT
%token TOKIMPURE
%token TOKIN
%token TOKINITIAL
%token TOKINITIALALG
%token TOKINITIALEQ
%token TOKINNER
%token TOKINPUT
%token TOKINT
%token TOKLOOP
%token TOKLOWER
%token TOKLOWEREQ
%token TOKMINUS
%token TOKMODEL
%token TOKNOT
%token TOKOBRACE
%token TOKOBRACKET
%token TOKOPAREN
%token TOKOPERATOR
%token TOKOR
%token TOKOUTER
%token TOKOUTPUT
%token TOKPACKAGE
%token TOKPARAMETER
%token TOKPARTIAL
%token TOKPLUS
%token TOKPROTECTED
%token TOKPUBLIC
%token TOKPURE
%token TOKRECORD
%token TOKREDECLARE
%token TOKREPLACEABLE
%token TOKRETURN
%token TOKSEMICOLON
%token TOKSLASH
%token TOKSTAR
%token TOKSTREAM
%token TOKSTRING
%token TOKTHEN
%token TOKTRUE
%token TOKTYPE
%token TOKWHEN
%token TOKWHILE
%token TOKWITHIN

%left /*1*/ TOKASSING
%left /*2*/ TOKEQUAL
%left /*3*/ TOKTHEN
%left /*4*/ TOKELSE
%left /*5*/ TOKCOLON
%left /*6*/ TOKNOT
%left /*7*/ TOKAND TOKOR
%left /*8*/ TOKLOWER TOKGREATER TOKLOWEREQ TOKGREATEREQ TOKCOMPEQ TOKCOMPNE
%left /*9*/ TOKPLUS TOKDOTPLUS TOKMINUS TOKDOTMINUS
%left /*10*/ TOKUMINUS TOKUPLUS
%left /*11*/ TOKSLASH TOKDOTSLASH TOKSTAR TOKDOTSTAR
%right /*12*/ TOKCARET
%right /*13*/ TOKDOTCARET
%left /*14*/ TOKFC
%left /*15*/ TOKPARENS

%start input

%%

input :
	stored_definition
	;

stored_definition :
	opt_within_name class_definition_list
	;

opt_within_name :
	/*empty*/
	| TOKWITHIN opt_name TOKSEMICOLON
	;

opt_name :
	/*empty*/
	| name
	;

name :
	TOKID
	| TOKDOT TOKID
	| name TOKDOT TOKID
	;

class_definition_list :
	/*empty*/
	| class_definition_list class_definition_aux
	;

class_definition_aux :
	opt_final class_definition TOKSEMICOLON
	;

class_definition :
	opt_encapsulated class_prefix class_specifier
	;

opt_encapsulated :
	/*empty*/
	| TOKENCAPSULATED
	;

class_prefix :
	opt_partial class_prefixes
	;

opt_expandable :
	/*empty*/
	| TOKEXPANDABLE
	;

opt_pure_impure_operator :
	/*empty*/
	| TOKPURE opt_operator
	| TOKIMPURE opt_operator
	;

opt_final :
	/*empty*/
	| TOKFINAL
	;

class_prefixes :
	TOKCLASS
	| TOKMODEL
	| opt_operator TOKRECORD
	| TOKBLOCK
	| opt_expandable TOKCONNECTOR
	| TOKTYPE
	| TOKPACKAGE
	| opt_pure_impure_operator TOKFUNCTION
	| TOKOPERATOR
	;

opt_operator :
	/*empty*/
	| TOKOPERATOR
	;

opt_partial :
	/*empty*/
	| TOKPARTIAL
	;

class_specifier :
	TOKID string_comment composition TOKEND TOKID
	| TOKID TOKEQUAL /*2L*/ base_prefix name opt_array_subscripts opt_class_modification comment
	| TOKID TOKEQUAL /*2L*/ TOKENUMERATION TOKOPAREN enumeration_args TOKCPAREN comment
	| TOKID TOKEQUAL /*2L*/ TOKDER TOKOPAREN name more_ids TOKCPAREN comment
	| TOKEXTENDS TOKID opt_class_modification string_comment composition TOKEND TOKID
	;

more_ids :
	TOKCOMA TOKID
	| more_ids TOKCOMA TOKID
	;

composition :
	composition_aux_1 opt_external_composition opt_annotation_composition
	;

opt_external_composition :
	/*empty*/
	| TOKEXTERNAL opt_language_specification opt_external_function_call opt_annotation TOKSEMICOLON
	| TOKEXTERNAL opt_language_specification component_reference TOKEQUAL /*2L*/ opt_external_function_call opt_annotation TOKSEMICOLON
	;

opt_language_specification :
	/*empty*/
	| TOKSTRING
	;

opt_external_function_call :
	/*empty*/
	| TOKID TOKOPAREN expression_list TOKCPAREN
	| TOKID TOKOPAREN TOKCPAREN
	;

opt_annotation_composition :
	/*empty*/
	| annotation TOKSEMICOLON
	;

composition_aux_1 :
	/*empty*/
	| element TOKSEMICOLON element_list
	| element TOKSEMICOLON element_list composition_element composition_list
	| composition_element composition_list
	;

string_comment :
	/*empty*/
	| TOKSTRING
	| TOKSTRING TOKPLUS /*9L*/ string_comment_no_empty
	;

string_comment_no_empty :
	TOKSTRING
	| TOKSTRING TOKPLUS /*9L*/ string_comment_no_empty
	;

element :
	import_clause
	| extends_clause
	| opt_redeclare opt_final opt_inner opt_outer element_option opt_constraining_clause
	;

import_clause :
	TOKIMPORT opt_import comment
	;

opt_import :
	TOKID TOKEQUAL /*2L*/ name
	| name opt_import_spec
	;

opt_import_spec :
	/*empty*/
	| TOKDOTSTAR /*11L*/
	| TOKDOT TOKOBRACE import_list TOKCBRACE
	;

import_list :
	TOKID
	| import_list TOKCOMA TOKID
	;

comment :
	string_comment opt_annotation
	;

element_list :
	/*empty*/
	| element_list element TOKSEMICOLON
	;

extends_clause :
	TOKEXTENDS name opt_class_modification opt_annotation
	;

opt_redeclare :
	/*empty*/
	| TOKREDECLARE
	;

opt_inner :
	/*empty*/
	| TOKINNER
	;

opt_outer :
	/*empty*/
	| TOKOUTER
	;

opt_constraining_clause :
	/*empty*/
	| constraining_clause comment
	;

constraining_clause :
	TOKCONSTRAINEDBY name opt_class_modification
	;

element_option :
	element_option_1
	| TOKREPLACEABLE element_option_1
	;

element_option_1 :
	class_definition
	| component_clause
	;

component_clause :
	type_prefix type_specifier opt_array_subscripts component_list
	;

type_prefix :
	/*empty*/
	| opt_input_output
	| opt_disc_param_const
	| opt_disc_param_const opt_input_output
	| opt_flow_stream
	| opt_flow_stream opt_disc_param_const
	| opt_flow_stream opt_disc_param_const opt_input_output
	;

opt_flow_stream :
	TOKFLOW
	| TOKSTREAM
	;

opt_disc_param_const :
	TOKDISCRETE
	| TOKPARAMETER
	| TOKCONSTANT
	;

opt_input_output :
	TOKINPUT
	| TOKOUTPUT
	;

type_specifier :
	name
	;

opt_array_subscripts :
	/*empty*/
	| array_subscripts
	;

component_list :
	component_declaration
	| component_list TOKCOMA component_declaration
	;

component_declaration :
	declaration opt_condition_attribute comment
	;

declaration :
	TOKID opt_array_subscripts opt_modification
	;

opt_condition_attribute :
	/*empty*/
	| TOKIF expression
	;

composition_list :
	/*empty*/
	| composition_list composition_element
	;

composition_element :
	TOKPUBLIC element_list
	| TOKPROTECTED element_list
	| eq_alg_section_init
	;

opt_modification :
	/*empty*/
	| modification
	;

modification :
	class_modification opt_equal_exp
	| TOKEQUAL /*2L*/ expression
	| TOKASSING /*1L*/ expression
	;

class_modification :
	TOKOPAREN opt_argument_list TOKCPAREN
	;

opt_argument_list :
	/*empty*/
	| argument_list
	;

argument_list :
	argument
	| argument_list TOKCOMA argument
	;

argument :
	element_modification_replaceable
	| element_redeclaration
	;

opt_each :
	/*empty*/
	| TOKEACH
	;

element_modification_replaceable :
	opt_each opt_final element_modification
	| opt_each opt_final element_replaceable
	;

element_modification :
	name opt_modification string_comment
	;

element_replaceable :
	TOKREPLACEABLE short_class_definition opt_constraining_clause
	| TOKREPLACEABLE component_clause1 opt_constraining_clause
	;

opt_equal_exp :
	/*empty*/
	| TOKEQUAL /*2L*/ expression
	;

element_redeclaration :
	TOKREDECLARE opt_each opt_final element_redeclaration_1
	;

element_redeclaration_1 :
	element_redeclaration_2
	| element_replaceable
	;

element_redeclaration_2 :
	short_class_definition
	| component_clause1
	;

short_class_definition :
	class_prefixes TOKID TOKEQUAL /*2L*/ short_class_definition_exp
	;

short_class_definition_exp :
	base_prefix name opt_array_subscripts opt_class_modification comment
	| TOKENUMERATION TOKOPAREN enumeration_args TOKCPAREN comment
	;

enumeration_args :
	TOKSEMICOLON
	| enum_list
	;

enum_list :
	enumeration_literal
	| enum_list TOKCOMA enumeration_literal
	;

enumeration_literal :
	TOKID comment
	;

component_clause1 :
	type_prefix type_specifier declaration comment
	;

opt_class_modification :
	/*empty*/
	| class_modification
	;

base_prefix :
	type_prefix
	;

subscript_list :
	subscript
	| subscript_list TOKCOMA subscript
	;

subscript :
	TOKCOLON /*5L*/
	| expression
	;

array_subscripts :
	TOKOBRACKET subscript_list TOKCBRACKET
	;

opt_annotation :
	/*empty*/
	| annotation
	;

annotation :
	TOKANNOTATION class_modification
	;

eq_alg_section_init :
	TOKINITIALEQ equation_list
	| TOKEQUATION equation_list
	| TOKINITIALALG statement_list
	| TOKALGORITHM statement_list
	;

equation_list :
	/*empty*/
	| equation_list equation TOKSEMICOLON
	;

equation :
	connect_clause comment
	| if_equation comment
	| simple_expression TOKEQUAL /*2L*/ expression comment
	| primary
	| for_equation comment
	| when_equation
	;

for_indices :
	for_index
	| for_indices TOKCOMA for_index
	;

for_index :
	TOKID opt_in
	;

opt_in :
	/*empty*/
	| TOKIN expression
	;

for_equation :
	TOKFOR for_indices TOKLOOP equation_list TOKEND TOKFOR
	;

when_equation :
	TOKWHEN expression TOKTHEN /*3L*/ equation_list opt_else_when TOKEND TOKWHEN comment
	;

opt_else_when :
	/*empty*/
	| opt_else_when TOKELSEWHEN expression TOKTHEN /*3L*/ equation_list
	;

if_equation :
	TOKIF expression TOKTHEN /*3L*/ equation_list opt_elseif_eq opt_else_eq TOKEND TOKIF
	;

opt_elseif_eq :
	/*empty*/
	| opt_elseif_eq TOKELSEIF expression TOKTHEN /*3L*/ equation_list
	;

opt_else_eq :
	/*empty*/
	| TOKELSE /*4L*/ equation_list
	;

connect_clause :
	TOKCONNECT TOKOPAREN component_reference TOKCOMA component_reference TOKCPAREN
	;

statement_list :
	/*empty*/
	| statement_list statement TOKSEMICOLON
	;

statement :
	component_reference opt_assing comment
	| TOKOPAREN output_expression_list TOKCPAREN TOKASSING /*1L*/ component_reference function_call_args
	| while_statement comment
	| when_statement
	| for_statement comment
	| if_statement comment
	| TOKBREAK comment
	| TOKRETURN comment
	;

while_statement :
	TOKWHILE expression TOKLOOP statement_list TOKEND TOKWHILE
	;

when_statement :
	TOKWHEN expression TOKTHEN /*3L*/ statement_list opt_else_when_list TOKEND TOKWHEN comment
	;

opt_else_when_list :
	/*empty*/
	| opt_else_when_list TOKELSEWHEN expression TOKTHEN /*3L*/ statement_list
	;

for_statement :
	TOKFOR for_indices TOKLOOP statement_list TOKEND TOKFOR
	;

if_statement :
	TOKIF expression TOKTHEN /*3L*/ statement_list opt_esleif_st opt_else_st TOKEND TOKIF
	;

opt_esleif_st :
	/*empty*/
	| opt_esleif_st TOKELSEIF expression TOKTHEN /*3L*/ statement_list
	;

opt_else_st :
	/*empty*/
	| TOKELSE /*4L*/ statement_list
	;

output_expression_list :
	/*empty*/
	| output_expression_list_more
	;

output_expression_list_more :
	expression
	| output_expression_list_more TOKCOMA opt_expression
	;

opt_named_arguments :
	/*empty*/
	| named_arguments
	;

named_arguments :
	named_argument
	| named_arguments TOKCOMA named_argument
	;

named_argument :
	TOKID TOKEQUAL /*2L*/ function_argument
	;

opt_assing :
	TOKASSING /*1L*/ expression
	| function_call_args
	;

function_argument :
	TOKFUNCTION name TOKOPAREN opt_named_arguments TOKCPAREN
	| expression
	;

function_call_args :
	TOKOPAREN opt_function_args TOKCPAREN
	;

opt_function_args :
	/*empty*/
	| function_arguments
	;

function_arguments :
	function_argument opt_function_arguments
	| named_argument opt_function_arguments
	;

opt_function_arguments :
	/*empty*/
	| TOKCOMA function_arguments
	| TOKFOR for_indices
	;

expression :
	primary
	| TOKOPAREN output_expression_list TOKCPAREN %prec TOKPARENS /*15L*/
	| TOKMINUS /*9L*/ expression %prec TOKUMINUS /*10L*/
	| TOKPLUS /*9L*/ expression %prec TOKUPLUS /*10L*/
	| TOKNOT /*6L*/ expression
	| expression TOKCOLON /*5L*/ expression
	| expression TOKLOWER /*8L*/ expression
	| expression TOKLOWEREQ /*8L*/ expression
	| expression TOKGREATER /*8L*/ expression
	| expression TOKGREATEREQ /*8L*/ expression
	| expression TOKCOMPNE /*8L*/ expression
	| expression TOKCOMPEQ /*8L*/ expression
	| expression TOKSLASH /*11L*/ expression
	| expression TOKDOTSLASH /*11L*/ expression
	| expression TOKSTAR /*11L*/ expression
	| expression TOKDOTSTAR /*11L*/ expression
	| expression TOKPLUS /*9L*/ expression
	| expression TOKMINUS /*9L*/ expression
	| expression TOKDOTPLUS /*9L*/ expression
	| expression TOKDOTMINUS /*9L*/ expression
	| expression TOKCARET /*12R*/ expression
	| expression TOKDOTCARET /*13R*/ expression
	| expression TOKAND /*7L*/ expression
	| expression TOKOR /*7L*/ expression
	| TOKIF expression TOKTHEN /*3L*/ expression opt_elseif_exp TOKELSE /*4L*/ expression
	;

opt_expression :
	/*empty*/
	| expression
	;

opt_elseif_exp :
	/*empty*/
	| opt_elseif_exp TOKELSEIF expression TOKTHEN /*3L*/ expression
	;

primary :
	TOKINT
	| TOKFLOAT
	| TOKSTRING
	| TOKFALSE
	| TOKTRUE
	| TOKDER function_call_args
	| TOKINITIAL function_call_args
	| opt_comp_call
	| TOKOBRACKET expression_list primary_exp_list TOKCBRACKET
	| TOKOBRACE function_arguments TOKCBRACE
	| TOKENDSUB
	;

primary_exp_list :
	/*empty*/
	| primary_exp_list TOKSEMICOLON expression_list
	;

component_reference :
	TOKID opt_array_subscripts component_reference_list
	| TOKDOT TOKID opt_array_subscripts component_reference_list
	;

expression_list :
	expression
	| expression_list TOKCOMA expression
	;

component_reference_list :
	/*empty*/
	| component_reference_list TOKDOT TOKID opt_array_subscripts
	;

simple_expression :
	primary
	| TOKOPAREN output_expression_list TOKCPAREN %prec TOKPARENS /*15L*/
	| TOKMINUS /*9L*/ expression %prec TOKUMINUS /*10L*/
	| TOKPLUS /*9L*/ expression %prec TOKUPLUS /*10L*/
	| TOKNOT /*6L*/ expression
	| simple_expression TOKCOLON /*5L*/ expression
	| simple_expression TOKLOWER /*8L*/ expression
	| simple_expression TOKLOWEREQ /*8L*/ expression
	| simple_expression TOKGREATER /*8L*/ expression
	| simple_expression TOKGREATEREQ /*8L*/ expression
	| simple_expression TOKCOMPNE /*8L*/ expression
	| simple_expression TOKCOMPEQ /*8L*/ expression
	| simple_expression TOKSLASH /*11L*/ expression
	| simple_expression TOKDOTSLASH /*11L*/ expression
	| simple_expression TOKSTAR /*11L*/ expression
	| simple_expression TOKDOTSTAR /*11L*/ expression
	| simple_expression TOKPLUS /*9L*/ expression
	| simple_expression TOKMINUS /*9L*/ expression
	| simple_expression TOKDOTPLUS /*9L*/ expression
	| simple_expression TOKDOTMINUS /*9L*/ expression
	| simple_expression TOKCARET /*12R*/ expression
	| simple_expression TOKDOTCARET /*13R*/ expression
	| simple_expression TOKAND /*7L*/ expression
	| simple_expression TOKOR /*7L*/ expression
	;

more_cr :
	/*empty*/
	| more_cr TOKDOT TOKID opt_array_subscripts
	;

more_comp_call :
	/*empty*/
	| more_comp_call TOKDOT TOKID
	;

opt_comp_call :
	TOKDOT TOKID more_comp_call
	| TOKID more_comp_call
	| TOKDOT TOKID more_comp_call array_subscripts more_cr
	| TOKID more_comp_call array_subscripts more_cr
	| TOKDOT TOKID more_comp_call function_call_args
	| TOKID more_comp_call function_call_args %prec TOKFC /*14L*/
	;

%%

DIGIT    [0-9]
NUM	 {DIGIT}+
ID       [_a-zA-Z][_a-zA-Z0-9]*
IDNUM      [_a-zA-Z0-9][_a-zA-Z0-9]*
QUOTED [0-9a-zA-Z\-_#.!$%&()\*+,/:;<>=?@\[\]^{}|~]+

%%

[ \t\r\n]+	skip()
"/*"(?s:.)*?"*/"	skip()
"//".*	skip()

==              TOKCOMPEQ
=               TOKEQUAL
; 	            TOKSEMICOLON
, 	            TOKCOMA
\.\^            TOKDOTCARET
\^             TOKCARET
\( 	            TOKOPAREN
\) 	            TOKCPAREN
\{ 	            TOKOBRACE
\}	            TOKCBRACE
\[ 	            TOKOBRACKET
\]	            TOKCBRACKET
\.\+            TOKDOTPLUS
\.-             TOKDOTMINUS
\.\*            TOKDOTSTAR
\.\/            TOKDOTSLASH
\. 	            TOKDOT
\+ 	            TOKPLUS
- 	            TOKMINUS
\* 	            TOKSTAR
\/ 	            TOKSLASH
\<\>            TOKCOMPNE
\<=  	          TOKLOWEREQ
\<  	          TOKLOWER
\>=  	          TOKGREATEREQ
\>  	          TOKGREATER
:=  	          TOKASSING
:  	            TOKCOLON


initial[\t\ \n]*equation	TOKINITIALEQ
initial[\t\ \n]*algorithm TOKINITIALALG
initial	TOKINITIAL

algorithm		    TOKALGORITHM
and				      TOKAND
annotation		 TOKANNOTATION

block				    TOKBLOCK
break				    TOKBREAK
class				    TOKCLASS
connect				  TOKCONNECT
connector			  TOKCONNECTOR
constant			  TOKCONSTANT
constrainedby	 TOKCONSTRAINEDBY
der				      TOKDER
discrete			  TOKDISCRETE
each				    TOKEACH
else			     TOKELSE
elseif				  TOKELSEIF
elsewhen			  TOKELSEWHEN
encapsulated	 TOKENCAPSULATED
end			 TOKEND //      { if (parser->isParsingSubscript()) { ENDSUB) } else { END} }
ENDSUB	TOKENDSUB
enumeration		 TOKENUMERATION
equation			  TOKEQUATION
expandable		 TOKEXPANDABLE
extends				  TOKEXTENDS
external			  TOKEXTERNAL
false				    TOKFALSE
final				    TOKFINAL
flow				    TOKFLOW
for				      TOKFOR
function			  TOKFUNCTION
if				      TOKIF
import				  TOKIMPORT
impure				  TOKIMPURE
in				      TOKIN
inner				    TOKINNER
input				    TOKINPUT
loop				    TOKLOOP
model				    TOKMODEL
not				      TOKNOT
operator			  TOKOPERATOR
or				      TOKOR
outer				    TOKOUTER
output				  TOKOUTPUT
package				  TOKPACKAGE
parameter			  TOKPARAMETER
partial				  TOKPARTIAL
protected			  TOKPROTECTED
public				  TOKPUBLIC
pure				    TOKPURE
record				  TOKRECORD
redeclare			  TOKREDECLARE
replaceable		 TOKREPLACEABLE
return				  TOKRETURN
stream				  TOKSTREAM
then				    TOKTHEN
true				    TOKTRUE
type				    TOKTYPE
when				    TOKWHEN
while				    TOKWHILE
within				  TOKWITHIN


\"(\\.|[^"\r\n\\])*\"	TOKSTRING
{NUM} TOKINT
([0-9]+|[0-9]+\.[0-9]*)([0-9]*[eE][-+]?[0-9]+)?  TOKFLOAT

'{QUOTED}' TOKID
{ID} TOKID

%%
