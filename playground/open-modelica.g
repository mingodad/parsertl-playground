//From: https://github.com/OpenModelica/OpenModelica/blob/89f5c775641f512aff73b810162a37d5a1fcb8bc/OMParser/modelica.g4

%token BOM
%token IDENT
%token STRING
%token UNSIGNED_INTEGER
%token UNSIGNED_REAL

%%

stored_definition:
	  bom_opt within_opt class_definition_zom
	;

class_definition_zom:
	  %empty
	| class_definition_zom final_opt class_definition ';'
	;

final_opt:
	  %empty
	| "final"
	;

within_opt:
	  %empty
	| "within" name_opt ';'
	;

name_opt:
	  %empty
	| name
	;

bom_opt:
	  %empty
	| BOM
	;

class_definition:
	  encapsulated_opt class_prefixes class_specifier
	;

encapsulated_opt:
	  %empty
	| "encapsulated"
	;

class_prefixes:
	  partial_opt class_prefixes_kind
	;

class_prefixes_kind:
	  "class"
	| "model"
	| operator_opt "record"
	| "block"
	| expandable_opt "connector"
	| "type"
	| "package"
	| class_prefixe_purity operator_opt "function"
	| "operator"
	;

class_prefixe_purity:
	  %empty
	| "pure"
	| "impure"
	;

expandable_opt:
	  %empty
	| "expandable"
	;

operator_opt:
	  %empty
	| "operator"
	;

partial_opt:
	  %empty
	| "partial"
	;

class_specifier:
	  long_class_specifier
	| short_class_specifier
	| der_class_specifier
	;

long_class_specifier:
	  IDENT string_comment composition "end" IDENT
	| "extends" IDENT class_modification_opt string_comment composition "end" IDENT
	;

class_modification_opt:
	  %empty
	| class_modification
	;

short_class_specifier:
	  IDENT '=' short_class_specifier_kind comment
	;

short_class_specifier_kind:
	  base_prefix type_specifier array_subscripts_opt class_modification_opt
	| "enumeration" '(' enum_values_opt ')'
	;

enum_values_opt:
	  %empty
	| enum_list
	| ':'
	;

array_subscripts_opt:
	  %empty
	| array_subscripts
	;

der_class_specifier:
	  IDENT '=' "der" '(' type_specifier ',' IDENT comma_IDENT_zom ')' comment
	;

comma_IDENT_zom:
	  %empty
	| comma_IDENT_zom ',' IDENT
	;

base_prefix:
	  in_out_opt
	;

in_out_opt:
	  %empty
	| "input"
	| "output"
	;

enum_list:
	  enumeration_literal
	| enum_list ',' enumeration_literal
	;

enumeration_literal:
	  IDENT comment
	;

composition:
	  element_list composition_more_zom ext_lang_spec_opt annotation_comment_semi_opt
	;

annotation_comment_semi_opt:
	  %empty
	| annotation_comment ';'
	;

ext_lang_spec_opt:
	  %empty
	| "external" language_specification_opt external_function_call_opt annotation_comment_opt ';'
	;

annotation_comment_opt:
	  %empty
	| annotation_comment
	;

external_function_call_opt:
	  %empty
	| external_function_call
	;

language_specification_opt:
	  %empty
	| language_specification
	;

composition_more_zom:
	  %empty
	| composition_more_zom composition_more
	;

composition_more:
	  "public" element_list
	| "protected" element_list
	| equation_section
	| algorithm_section
	;

language_specification:
	  STRING
	;

external_function_call:
	  IDENT '(' expression_list_opt ')'
	| component_reference '=' IDENT '(' expression_list_opt ')'
	;

expression_list_opt:
	  %empty
	| expression_list
	;

element_list:
	  %empty
	| element_list element ';'
	;

element:
	  import_clause
	| extends_clause
	| redeclare_opt final_opt inner_opt outer_opt element_kind
	;

element_kind:
	  class_definition
	| component_clause
	| "replaceable" class_definition constraining_clause_comment_opt
	| "replaceable" component_clause constraining_clause_comment_opt
	;

constraining_clause_comment_opt:
	  %empty
	| constraining_clause comment
	;

outer_opt:
	  %empty
	| "outer"
	;

inner_opt:
	  %empty
	| "inner"
	;

redeclare_opt:
	  %empty
	| "redeclare"
	;

import_clause:
	  "import" import_clause_kind comment
	;

import_clause_kind:
	  IDENT '=' name
	| name import_clause_tail
	;

import_clause_tail:
	  %empty
	| '.' import_clause_tail_kind
	| ".*"
	;

import_clause_tail_kind:
	  '*'
	| '{' import_list '}'
	;

import_list:
	  IDENT comma_IDENT_zom
	;

extends_clause:
	  "extends" type_specifier class_modification_opt annotation_comment_opt
	;

constraining_clause:
	  "constrainedby" type_specifier class_modification_opt
	;

component_clause:
	  type_prefix type_specifier array_subscripts_opt component_list
	;

type_prefix:
	  flow_or_stream_opt type_prefix_kind in_out_opt
	;

type_prefix_kind:
	  %empty
	| "discrete"
	| "parameter"
	| "constant"
	;

flow_or_stream_opt:
	  %empty
	| "flow"
	| "stream"
	;

component_list:
	  component_declaration
	| component_list ',' component_declaration
	;

component_declaration:
	  declaration condition_attribute_opt comment
	;

condition_attribute_opt:
	  %empty
	| condition_attribute
	;

condition_attribute:
	  "if" expression
	;

declaration:
	  IDENT array_subscripts_opt modification_opt
	;

modification_opt:
	  %empty
	| modification
	;

modification:
	  class_modification assign_expr_opt
	| '=' expression
	| ":=" expression
	;

assign_expr_opt:
	  %empty
	| '=' expression
	;

class_modification:
	  '(' argument_list_opt ')'
	;

argument_list_opt:
	  %empty
	| argument_list
	;

argument_list:
	  argument
	| argument_list ',' argument
	;

argument:
	  element_modification_or_replaceable
	| element_redeclaration
	;

element_modification_or_replaceable:
	  each_opt final_opt element_modification
	| each_opt final_opt element_replaceable
	;

each_opt:
	  %empty
	| "each"
	;

element_modification:
	  name modification_opt string_comment
	;

element_redeclaration:
	  "redeclare" each_opt final_opt element_redeclaration_kind
	;

element_redeclaration_kind:
	  short_class_definition
	| element_declaration
	| element_replaceable
	;

element_replaceable:
	  "replaceable" element_replaceable_kind constraining_clause_opt
	;

constraining_clause_opt:
	  %empty
	| constraining_clause
	;

element_replaceable_kind:
	  short_class_definition
	| element_declaration
	;

element_declaration:
	  type_prefix type_specifier declaration comment
	;

short_class_definition:
	  class_prefixes short_class_specifier
	;

equation_section:
	  initial_opt "equation" equation_semi_oom
	;

equation_semi_oom:
	  equation ';'
	| equation_semi_oom equation ';'
	;

initial_opt:
	  %empty
	| "initial"
	;

algorithm_section:
	  initial_opt "algorithm" statement_semi_oom
	;

statement_semi_oom:
	  statement ';'
	| statement_semi_oom statement ';'
	;

equation:
	  equation_kind comment
	;

equation_kind:
	  simple_expression assign_expr_opt
	| if_equation
	| for_equation
	| connect_clause
	| when_equation
	;

statement:
	  statement_kind comment
	;

statement_kind:
	  component_reference ":=" expression
	| component_reference function_call_args
	| '(' output_expression_list ')' ":=" component_reference function_call_args
	| "break"
	| "return"
	| if_statement
	| for_statement
	| while_statement
	| when_statement
	;

if_equation:
	  "if" expression "then" equation_semi_oom elseif_equation_zom else_equation_opt "end" "if"
	;

else_equation_opt:
	  %empty
	| "else" equation_semi_oom
	;

elseif_equation_zom:
	  %empty
	| elseif_equation_zom "elseif" expression "then" equation_semi_oom
	;

if_statement:
	  "if" expression "then" statement_semi_oom elseif_statement_zom else_statement_opt "end" "if"
	;

else_statement_opt:
	  %empty
	| "else" statement_semi_oom
	;

elseif_statement_zom:
	  %empty
	| elseif_statement_zom "elseif" expression "then" statement_semi_oom
	;

for_equation:
	  "for" for_indices "loop" equation_semi_oom "end" "for"
	;

for_statement:
	  "for" for_indices "loop" statement_semi_oom "end" "for"
	;

for_indices:
	  for_index
	| for_indices  ',' for_index
	;

for_index:
	  IDENT
	| IDENT "in" expression
	;

while_statement:
	  "while" expression "loop" statement_semi_oom "end" "while"
	;

when_equation:
	  "when" expression "then" equation_semi_oom elsewhen_equation_zom "end" "when"
	;

elsewhen_equation_zom:
	  %empty
	| elsewhen_equation_zom "elsewhen" expression "then" equation_semi_oom
	;

when_statement:
	  "when" expression "then" statement_semi_oom elsewhen_statement_zom "end" "when"
	;

elsewhen_statement_zom:
	  %empty
	| elsewhen_statement_zom "elsewhen" expression "then" statement_semi_oom
	;

connect_clause:
	  "connect" '(' component_reference ',' component_reference ')'
	;

expression:
	  simple_expression
	| "if" expression "then" expression elseif_expression_zom "else" expression
	;

elseif_expression_zom:
	  %empty
	| elseif_expression_zom "elseif" expression "then" expression
	;

simple_expression:
	  logical_expression semi_logical_expression_opt
	;

semi_logical_expression_opt:
	  %empty
	| ':' logical_expression
	| ':' logical_expression ':' logical_expression
	;

logical_expression:
	  logical_term
	| logical_expression "or" logical_term
	;

logical_term:
	  logical_factor
	| logical_term "and" logical_factor
	;

logical_factor:
	  relation
	| "not" relation
	;

relation:
	  arithmetic_expression
	| arithmetic_expression relational_operator arithmetic_expression
	;

relational_operator:
	  '<'
	| "<="
	| '>'
	| ">="
	| "=="
	| "<>"
	;

arithmetic_expression:
	  term
	| add_operator term
	| arithmetic_expression add_operator term
	;

add_operator:
	  '+'
	| '-'
	| ".+"
	| ".-"
	;

term:
	  factor
	| term mul_operator factor
	;

mul_operator:
	  '*'
	| '/'
	| ".*"
	| "./"
	;

factor:
	  primary
	| primary '^' primary
	| primary ".^" primary
	;

primary:
	  UNSIGNED_NUMBER
	| STRING
	| "false"
	| "true"
	| function_call_args_kind function_call_args
	| component_reference function_call_args_opt
	| '(' output_expression_list ')'
	| '[' expression_list semi_expression_list_zom ']'
	| '{' array_arguments '}'
	//| "end"
	;

semi_expression_list_zom:
	  %empty
	| semi_expression_list_zom ';' expression_list
	;

function_call_args_opt:
	  %empty
	| function_call_args
	;

function_call_args_kind:
	  "der"
	| "initial"
	| "pure"
	;

UNSIGNED_NUMBER:
	  UNSIGNED_INTEGER
	| UNSIGNED_REAL
	;

type_specifier:
	  name
	| '.' name
	;

name:
	  IDENT
	| name '.' IDENT
	;

component_reference:
	  IDENT array_subscripts_opt dot_IDENT_array_sub_opt_zom
	| '.' IDENT array_subscripts_opt dot_IDENT_array_sub_opt_zom
	;

dot_IDENT_array_sub_opt_zom:
	  %empty
	| dot_IDENT_array_sub_opt_zom '.' IDENT array_subscripts_opt
	;

function_call_args:
	  '(' function_arguments_opt ')'
	;

function_arguments_opt:
	  %empty
	| function_arguments
	;

function_arguments:
	  expression
	| expression ',' function_arguments_non_first
	| expression "for" for_indices
	| function_partial_application comma_function_arguments_non_first_opt
	| named_arguments
	;

comma_function_arguments_non_first_opt:
	  %empty
	| ',' function_arguments_non_first
	;

function_arguments_non_first:
	  function_argument comma_function_arguments_non_first_opt
	| named_arguments
	;

array_arguments:
	  expression array_arguments_tail
	;

array_arguments_tail:
	  comma_expr_zom
	| "for" for_indices
	;

comma_expr_zom:
	  %empty
	| comma_expr_zom ',' expression
	;

named_arguments:
	  named_argument
	| named_arguments ',' named_argument
	;

named_argument:
	  IDENT '=' function_argument
	;

function_argument:
	  function_partial_application
	| expression
	;

function_partial_application:
	  "function" type_specifier '(' named_arguments_opt ')'
	;

named_arguments_opt:
	  %empty
	| named_arguments
	;

output_expression_list:
	  expression_opt comma_expression_opt_zom
	;

comma_expression_opt_zom:
	  %empty
	| comma_expression_opt_zom ',' expression_opt
	;

expression_opt:
	  %empty
	| expression
	;

expression_list:
	  expression comma_expr_zom
	;

array_subscripts:
	  '[' subscript comma_subscript_zom ']'
	;

comma_subscript_zom:
	  %empty
	| comma_subscript_zom ',' subscript
	;

subscript:
	  ':'
	| expression
	;

comment:
	  string_comment annotation_comment_opt
	;

string_comment:
	  %empty
	| STRING plus_STRING_zom
	;

plus_STRING_zom:
	  %empty
	| plus_STRING_zom  '+' STRING
	;

annotation_comment:
	  "annotation" class_modification
	;

%%

DIGIT	[0-9]
EXPONENT	[eE][+-]?{DIGIT}+
UNSIGNED_INTEGER	{DIGIT}+

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"("	'('
")"	')'
"*"	'*'
"+"	'+'
","	','
"-"	'-'
"."	'.'
".*"	".*"
".+"	".+"
".-"	".-"
"./"	"./"
".^"	".^"
"/"	'/'
":"	':'
":="	":="
";"	';'
"<"	'<'
"<="	"<="
"<>"	"<>"
"="	'='
"=="	"=="
">"	'>'
">="	">="
"["	'['
"\uFEFF"	BOM
"]"	']'
"^"	'^'
"algorithm"	"algorithm"
"and"	"and"
"annotation"	"annotation"
"block"	"block"
"break"	"break"
"class"	"class"
"connect"	"connect"
"connector"	"connector"
"constant"	"constant"
"constrainedby"	"constrainedby"
"der"	"der"
"discrete"	"discrete"
"each"	"each"
"else"	"else"
"elseif"	"elseif"
"elsewhen"	"elsewhen"
"encapsulated"	"encapsulated"
"end"	"end"
"enumeration"	"enumeration"
"equation"	"equation"
"expandable"	"expandable"
"extends"	"extends"
"external"	"external"
"false"	"false"
"final"	"final"
"flow"	"flow"
"for"	"for"
"function"	"function"
"if"	"if"
"import"	"import"
"impure"	"impure"
"in"	"in"
"initial"	"initial"
"inner"	"inner"
"input"	"input"
"loop"	"loop"
"model"	"model"
"not"	"not"
"operator"	"operator"
"or"	"or"
"outer"	"outer"
"output"	"output"
"package"	"package"
"parameter"	"parameter"
"partial"	"partial"
"protected"	"protected"
"public"	"public"
"pure"	"pure"
"record"	"record"
"redeclare"	"redeclare"
"replaceable"	"replaceable"
"return"	"return"
"stream"	"stream"
"then"	"then"
"true"	"true"
"type"	"type"
"when"	"when"
"while"	"while"
"within"	"within"
"{"	'{'
"}"	'}'

\"(\\.|[^"\\])*\"	STRING
{UNSIGNED_INTEGER}	UNSIGNED_INTEGER
{UNSIGNED_INTEGER}"."{UNSIGNED_INTEGER}?	UNSIGNED_REAL
{UNSIGNED_INTEGER}("."{UNSIGNED_INTEGER}?)?{EXPONENT}	UNSIGNED_REAL
"."{UNSIGNED_INTEGER}{EXPONENT}?	UNSIGNED_REAL

'(\\.|[^'\r\n\\])+'	IDENT
[A-Za-z_][A-Za-z0-9_]*	IDENT

%%
