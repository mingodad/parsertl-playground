%option caseless

/*Tokens*/
%token T_FOR
%token T_LET
%token T_FILTER
%token T_RETURN
%token T_COLLECT
%token T_SORT
%token T_LIMIT
%token T_WINDOW
%token T_ASC
%token T_DESC
%token T_IN
%token T_WITH
%token T_INTO
%token T_AGGREGATE
%token T_GRAPH
%token T_SHORTEST_PATH
%token T_K_SHORTEST_PATHS
%token T_K_PATHS
%token T_ALL_SHORTEST_PATHS
%token T_DISTINCT
%token T_REMOVE
%token T_INSERT
%token T_UPDATE
%token T_REPLACE
%token T_UPSERT
%token T_NULL
%token T_TRUE
%token T_FALSE
%token T_STRING
%token T_QUOTED_STRING
%token T_INTEGER
%token T_DOUBLE
%token T_PARAMETER
%token T_DATA_SOURCE_PARAMETER
%token T_ASSIGN
%token T_NOT
%token T_AND
%token T_OR
%token T_NOT_IN
%token T_REGEX_MATCH
%token T_REGEX_NON_MATCH
%token T_EQ
%token T_NE
%token T_LT
%token T_GT
%token T_LE
%token T_GE
%token T_LIKE
%token T_PLUS
%token T_MINUS
%token T_TIMES
%token T_DIV
%token T_MOD
%token T_QUESTION
%token T_COLON
%token T_SCOPE
%token T_RANGE
%token T_COMMA
%token T_OPEN
%token T_CLOSE
%token T_OBJECT_OPEN
%token T_OBJECT_CLOSE
%token T_ARRAY_OPEN
%token T_ARRAY_CLOSE
%token T_OUTBOUND
%token T_INBOUND
%token T_ANY
%token T_ALL
%token T_NONE
%token T_AT_LEAST
%token UMINUS
%token UPLUS
%token UNEGATION
%token '.'

%left /*1*/ T_COMMA
%left /*2*/ T_DISTINCT
%right /*3*/ T_QUESTION T_COLON
%right /*4*/ T_ASSIGN
%left /*5*/ T_WITH
%nonassoc /*6*/ T_INTO
%left /*7*/ T_OR
%left /*8*/ T_AND
%nonassoc /*9*/ T_OUTBOUND T_INBOUND T_ANY T_ALL T_NONE
%left /*10*/ T_AT_LEAST
%left /*11*/ T_REGEX_MATCH T_REGEX_NON_MATCH T_EQ T_NE T_LIKE
%left /*12*/ T_IN T_NOT T_NOT_IN
%left /*13*/ T_LT T_GT T_LE T_GE
%left /*14*/ T_RANGE
%left /*15*/ T_PLUS T_MINUS
%left /*16*/ T_TIMES T_DIV T_MOD
%right /*17*/ UMINUS UPLUS UNEGATION
%left /*18*/ FUNCCALL
%left /*19*/ REFERENCE
%left /*20*/ INDEXED
%left /*21*/ EXPANSION
%left /*22*/ T_SCOPE

%start queryStart

%%


optional_prune_variable :
	expression
	| variable_name T_ASSIGN /*4R*/ expression
	;

with_collection :
	T_STRING
	| bind_parameter_datasource_expected
	;

with_collection_list :
	with_collection
	| with_collection_list T_COMMA /*1L*/ with_collection
	| with_collection_list with_collection
	;

optional_with :
	/*empty*/
	| T_WITH /*5L*/ with_collection_list
	;

queryStart :
	optional_with query
	;

query :
	optional_statement_block_statements final_statement
	;

final_statement :
	return_statement
	| remove_statement
	| insert_statement
	| update_statement
	| replace_statement
	| upsert_statement
	;

optional_statement_block_statements :
	/*empty*/
	| optional_statement_block_statements statement_block_statement
	;

statement_block_statement :
	for_statement
	| let_statement
	| filter_statement
	| collect_statement
	| sort_statement
	| limit_statement
	| window_statement
	| remove_statement
	| insert_statement
	| update_statement
	| replace_statement
	| upsert_statement
	;

more_output_variables :
	variable_name
	| more_output_variables T_COMMA /*1L*/ variable_name
	;

for_output_variables :
	more_output_variables
	;

prune_and_options :
	/*empty*/
	| T_STRING optional_prune_variable
	| T_STRING optional_prune_variable T_STRING object
	;

traversal_graph_info :
	graph_direction_steps expression graph_subject
	;

shortest_path_graph_info :
	graph_direction T_SHORTEST_PATH expression T_STRING expression graph_subject options
	;

k_shortest_paths_graph_info :
	graph_direction T_K_SHORTEST_PATHS expression T_STRING expression graph_subject options
	;

k_paths_graph_info :
	graph_direction_steps T_K_PATHS expression T_STRING expression graph_subject options
	;

all_shortest_paths_graph_info :
	graph_direction T_ALL_SHORTEST_PATHS expression T_STRING expression graph_subject options
	;

for_statement :
	T_FOR for_output_variables T_IN /*12L*/ expression for_options
	| T_FOR for_output_variables T_IN /*12L*/ traversal_graph_info prune_and_options
	| T_FOR for_output_variables T_IN /*12L*/ shortest_path_graph_info
	| T_FOR for_output_variables T_IN /*12L*/ k_shortest_paths_graph_info
	| T_FOR for_output_variables T_IN /*12L*/ k_paths_graph_info
	| T_FOR for_output_variables T_IN /*12L*/ all_shortest_paths_graph_info
	;

filter_statement :
	T_FILTER expression
	;

let_statement :
	T_LET let_list
	;

let_list :
	let_element
	| let_list T_COMMA /*1L*/ let_element
	;

let_element :
	variable_name T_ASSIGN /*4R*/ expression
	;

count_into :
	T_WITH /*5L*/ T_STRING T_INTO /*6N*/ variable_name
	;

collect_variable_list :
	T_COLLECT collect_list
	;

collect_statement :
	T_COLLECT count_into options
	| collect_variable_list count_into options
	| T_COLLECT aggregate collect_optional_into options
	| collect_variable_list aggregate collect_optional_into options
	| collect_variable_list collect_optional_into options
	| collect_variable_list collect_optional_into keep options
	;

collect_list :
	collect_element
	| collect_list T_COMMA /*1L*/ collect_element
	;

collect_element :
	variable_name T_ASSIGN /*4R*/ expression
	;

collect_optional_into :
	/*empty*/
	| T_INTO /*6N*/ variable_name
	| T_INTO /*6N*/ variable_name T_ASSIGN /*4R*/ expression
	;

variable_list :
	variable_name
	| variable_list T_COMMA /*1L*/ variable_name
	;

keep :
	T_STRING variable_list
	;

aggregate :
	T_AGGREGATE aggregate_list
	;

aggregate_list :
	aggregate_element
	| aggregate_list T_COMMA /*1L*/ aggregate_element
	;

aggregate_element :
	variable_name T_ASSIGN /*4R*/ aggregate_function_call
	;

aggregate_function_call :
	function_name T_OPEN optional_function_call_arguments T_CLOSE %prec FUNCCALL /*18L*/
	;

sort_statement :
	T_SORT sort_list
	;

sort_list :
	sort_element
	| sort_list T_COMMA /*1L*/ sort_element
	;

sort_element :
	expression sort_direction
	;

sort_direction :
	/*empty*/
	| T_ASC
	| T_DESC
	| simple_value
	;

limit_statement :
	T_LIMIT expression
	| T_LIMIT expression T_COMMA /*1L*/ expression
	;

window_statement :
	T_WINDOW object aggregate
	| T_WINDOW expression T_WITH /*5L*/ object aggregate
	;

return_statement :
	T_RETURN distinct_expression
	;

in_or_into_collection :
	T_IN /*12L*/ in_or_into_collection_name
	| T_INTO /*6N*/ in_or_into_collection_name
	;

remove_statement :
	T_REMOVE expression in_or_into_collection options
	;

insert_statement :
	T_INSERT expression in_or_into_collection options
	;

update_parameters :
	expression in_or_into_collection options
	| expression T_WITH /*5L*/ expression in_or_into_collection options
	;

update_statement :
	T_UPDATE update_parameters
	;

replace_parameters :
	expression in_or_into_collection options
	| expression T_WITH /*5L*/ expression in_or_into_collection options
	;

replace_statement :
	T_REPLACE replace_parameters
	;

update_or_replace :
	T_UPDATE
	| T_REPLACE
	;

upsert_statement :
	T_UPSERT expression T_INSERT expression update_or_replace expression in_or_into_collection options
	;

quantifier :
	T_ALL /*9N*/
	| T_ANY /*9N*/
	| T_NONE /*9N*/
	;

distinct_expression :
	T_DISTINCT /*2L*/ expression
	| expression
	;

expression :
	operator_unary
	| operator_binary
	| operator_ternary
	| value_literal
	| reference
	| expression T_RANGE /*14L*/ expression
	;

function_name :
	T_STRING
	| function_name T_SCOPE /*22L*/ T_STRING
	;

function_call :
	function_name T_OPEN optional_function_call_arguments T_CLOSE %prec FUNCCALL /*18L*/
	| T_LIKE /*11L*/ T_OPEN optional_function_call_arguments T_CLOSE %prec FUNCCALL /*18L*/
	;

operator_unary :
	T_PLUS /*15L*/ expression %prec UPLUS /*17R*/
	| T_MINUS /*15L*/ expression %prec UMINUS /*17R*/
	| T_NOT /*12L*/ expression %prec UNEGATION /*17R*/
	;

operator_binary :
	expression T_OR /*7L*/ expression
	| expression T_AND /*8L*/ expression
	| expression T_PLUS /*15L*/ expression
	| expression T_MINUS /*15L*/ expression
	| expression T_TIMES /*16L*/ expression
	| expression T_DIV /*16L*/ expression
	| expression T_MOD /*16L*/ expression
	| expression T_EQ /*11L*/ expression
	| expression T_NE /*11L*/ expression
	| expression T_LT /*13L*/ expression
	| expression T_GT /*13L*/ expression
	| expression T_LE /*13L*/ expression
	| expression T_GE /*13L*/ expression
	| expression T_IN /*12L*/ expression
	| expression T_NOT_IN /*12L*/ expression
	| expression T_NOT /*12L*/ T_LIKE /*11L*/ expression
	| expression T_NOT /*12L*/ T_REGEX_MATCH /*11L*/ expression
	| expression T_NOT /*12L*/ T_REGEX_NON_MATCH /*11L*/ expression
	| expression T_LIKE /*11L*/ expression
	| expression T_REGEX_MATCH /*11L*/ expression
	| expression T_REGEX_NON_MATCH /*11L*/ expression
	| expression quantifier T_EQ /*11L*/ expression
	| expression quantifier T_NE /*11L*/ expression
	| expression quantifier T_LT /*13L*/ expression
	| expression quantifier T_GT /*13L*/ expression
	| expression quantifier T_LE /*13L*/ expression
	| expression quantifier T_GE /*13L*/ expression
	| expression quantifier T_IN /*12L*/ expression
	| expression quantifier T_NOT_IN /*12L*/ expression
	| expression T_AT_LEAST /*10L*/ T_OPEN expression T_CLOSE T_EQ /*11L*/ expression
	| expression T_AT_LEAST /*10L*/ T_OPEN expression T_CLOSE T_NE /*11L*/ expression
	| expression T_AT_LEAST /*10L*/ T_OPEN expression T_CLOSE T_LT /*13L*/ expression
	| expression T_AT_LEAST /*10L*/ T_OPEN expression T_CLOSE T_GT /*13L*/ expression
	| expression T_AT_LEAST /*10L*/ T_OPEN expression T_CLOSE T_LE /*13L*/ expression
	| expression T_AT_LEAST /*10L*/ T_OPEN expression T_CLOSE T_GE /*13L*/ expression
	| expression T_AT_LEAST /*10L*/ T_OPEN expression T_CLOSE T_IN /*12L*/ expression
	| expression T_AT_LEAST /*10L*/ T_OPEN expression T_CLOSE T_NOT_IN /*12L*/ expression
	;

operator_ternary :
	expression T_QUESTION /*3R*/ expression T_COLON /*3R*/ expression
	| expression T_QUESTION /*3R*/ T_COLON /*3R*/ expression
	;

optional_function_call_arguments :
	/*empty*/
	| function_arguments_list
	;

expression_or_query :
	expression
	| query
	;

function_arguments_list :
	expression_or_query
	| function_arguments_list T_COMMA /*1L*/ expression_or_query
	;

compound_value :
	array
	| object
	;

array :
	T_ARRAY_OPEN optional_array_elements T_ARRAY_CLOSE
	;

optional_array_elements :
	/*empty*/
	| array_elements_list
	| array_elements_list T_COMMA /*1L*/
	;

array_elements_list :
	array_element
	| array_elements_list T_COMMA /*1L*/ array_element
	;

array_element :
	expression
	;

for_options :
	/*empty*/
	| T_STRING expression
	| T_STRING expression T_STRING expression
	;

options :
	/*empty*/
	| T_STRING object
	;

object :
	T_OBJECT_OPEN optional_object_elements T_OBJECT_CLOSE
	;

optional_object_elements :
	/*empty*/
	| object_elements_list
	| object_elements_list T_COMMA /*1L*/
	;

object_elements_list :
	object_element
	| object_elements_list T_COMMA /*1L*/ object_element
	;

object_element :
	T_STRING
	| object_element_name T_COLON /*3R*/ expression
	| T_PARAMETER T_COLON /*3R*/ expression
	| T_ARRAY_OPEN expression T_ARRAY_CLOSE T_COLON /*3R*/ expression
	;

array_filter_operator :
	T_QUESTION /*3R*/
	| array_filter_operator T_QUESTION /*3R*/
	;

array_map_operator :
	T_TIMES /*16L*/
	| array_map_operator T_TIMES /*16L*/
	;

optional_array_filter :
	/*empty*/
	| T_FILTER expression
	| quantifier T_FILTER expression
	| T_AT_LEAST /*10L*/ T_OPEN expression T_CLOSE T_FILTER expression
	| expression T_FILTER expression
	;

optional_array_limit :
	/*empty*/
	| T_LIMIT expression
	| T_LIMIT expression T_COMMA /*1L*/ expression
	;

optional_array_return :
	/*empty*/
	| T_RETURN expression
	;

graph_collection :
	T_STRING
	| bind_parameter_datasource_expected
	| graph_direction T_STRING
	| graph_direction bind_parameter
	;

graph_collection_list :
	graph_collection
	| graph_collection_list T_COMMA /*1L*/ graph_collection
	;

graph_subject :
	graph_collection
	| graph_collection T_COMMA /*1L*/ graph_collection_list
	| T_GRAPH bind_parameter
	| T_GRAPH T_QUOTED_STRING
	| T_GRAPH T_STRING
	;

graph_direction :
	T_OUTBOUND /*9N*/
	| T_INBOUND /*9N*/
	| T_ANY /*9N*/
	;

graph_direction_steps :
	graph_direction
	| expression graph_direction %prec T_OUTBOUND /*9N*/
	;

reference :
	T_STRING
	| compound_value
	| bind_parameter
	| function_call
	| T_OPEN expression T_CLOSE
	| T_OPEN query T_CLOSE
	| reference '.' T_STRING %prec REFERENCE /*19L*/
	| reference '.' bind_parameter %prec REFERENCE /*19L*/
	| reference T_ARRAY_OPEN expression T_ARRAY_CLOSE %prec INDEXED /*20L*/
	| reference T_ARRAY_OPEN array_filter_operator optional_array_filter T_ARRAY_CLOSE %prec EXPANSION /*21L*/
	| reference T_ARRAY_OPEN array_map_operator optional_array_filter optional_array_limit optional_array_return T_ARRAY_CLOSE %prec EXPANSION /*21L*/
	;

simple_value :
	value_literal
	| bind_parameter
	;

numeric_value :
	T_INTEGER
	| T_DOUBLE
	;

value_literal :
	T_QUOTED_STRING
	| numeric_value
	| T_NULL
	| T_TRUE
	| T_FALSE
	;

in_or_into_collection_name :
	T_STRING
	| T_QUOTED_STRING
	| T_DATA_SOURCE_PARAMETER
	;

bind_parameter :
	T_DATA_SOURCE_PARAMETER
	| T_PARAMETER
	;

bind_parameter_datasource_expected :
	T_DATA_SOURCE_PARAMETER
	| T_PARAMETER
	;

object_element_name :
	T_STRING
	| T_QUOTED_STRING
	;

variable_name :
	T_STRING
	;

%%

%%

[ \t\n\r]+	skip()
"//".*		skip()
"/*"(?s:.)*?"*/"

AGGREGATE	T_AGGREGATE
ALL	T_ALL
ALL_SHORTEST_PATHS	T_ALL_SHORTEST_PATHS
"&&"	T_AND
ANY	T_ANY
"]"	T_ARRAY_CLOSE
"["	T_ARRAY_OPEN
ASC	T_ASC
"="	T_ASSIGN
AT[ \t\r\n]+LEAST	T_AT_LEAST
")"	T_CLOSE
COLLECT	T_COLLECT
":"	T_COLON
","	T_COMMA
DATA_SOURCE_PARAM	T_DATA_SOURCE_PARAMETER
DESC	T_DESC
DISTINCT	T_DISTINCT
"/"	T_DIV
DOUBLE	T_DOUBLE
"=="	T_EQ
FALSE	T_FALSE
FILTER	T_FILTER
FOR	T_FOR
">="	T_GE
GRAPH	T_GRAPH
">"	T_GT
IN	T_IN
INBOUND	T_INBOUND
INSERT	T_INSERT
INTEGER	T_INTEGER
INTO	T_INTO
"<="	T_LE
LET	T_LET
LIKE	T_LIKE
LIMIT	T_LIMIT
"<"	T_LT
"-"	T_MINUS
"%"	T_MOD
"!="	T_NE
NONE	T_NONE
"!"	T_NOT
"!"[ \t\r\n]*IN	T_NOT_IN
NOT[ \t\r\n]+IN	T_NOT_IN
NULL	T_NULL
"}"	T_OBJECT_CLOSE
"{"	T_OBJECT_OPEN
"("	T_OPEN
"||"	T_OR
OUTBOUND	T_OUTBOUND
PARAMETER	T_PARAMETER
"+"	T_PLUS
"?"	T_QUESTION
".."	T_RANGE
"=~"	T_REGEX_MATCH
"!~"	T_REGEX_NON_MATCH
REMOVE	T_REMOVE
REPLACE	T_REPLACE
RETURN	T_RETURN
"::"	T_SCOPE
SHORTEST_PATH	T_SHORTEST_PATH
SORT	T_SORT
"*"	T_TIMES
TRUE	T_TRUE
UPDATE	T_UPDATE
UPSERT	T_UPSERT
WINDOW	T_WINDOW
WITH	T_WITH

K_PATHS	T_K_PATHS
K_SHORTEST_PATHS	T_K_SHORTEST_PATHS

"."	'.'

[0-9]+ T_INTEGER
[0-9]+"."[0-9]+    T_DOUBLE
("$"?|"_"+)[a-zA-Z]+[_a-zA-Z0-9]*	T_STRING
"`"("\\".|[^`\n\r\\])*"`"	T_STRING
"´"("\\".|[^´\n\r\\])*"´"	T_STRING
\"("\\".|[^"\n\r\\])*\"	T_QUOTED_STRING
'("\\".|[^''\n\r\\])*'	T_QUOTED_STRING

%%
