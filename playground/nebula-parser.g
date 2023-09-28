//From: https://github.com/vesoft-inc/nebula/blob/798d48e6c78e72dd4995fa9596a006072eaadd12/src/parser/parser.yy

/* Define some exclusive states.
 * Each state is referenced within a `<>` in the rules section
 * <DQ_STR> double quoted string literal
 * <SQ_STR> single quoted string literal
 * <LB_STR> accent quoted label, eg. `v2`
 * <COMMENT> comment
 */
%x DQ_STR
%x SQ_STR
%x LB_STR
%x COMMENT

%option caseless

/*Tokens*/
%token KW_BOOL
%token KW_INT8
%token KW_INT16
%token KW_INT32
%token KW_INT64
%token KW_INT
%token KW_FLOAT
%token KW_DOUBLE
%token KW_STRING
%token KW_FIXED_STRING
%token KW_TIMESTAMP
%token KW_DATE
%token KW_TIME
%token KW_DATETIME
%token KW_DURATION
%token KW_GO
%token KW_AS
%token KW_TO
%token KW_USE
%token KW_SET
%token KW_FROM
%token KW_WHERE
%token KW_ALTER
%token KW_MATCH
%token KW_INSERT
%token KW_VALUE
%token KW_VALUES
%token KW_YIELD
%token KW_RETURN
%token KW_CREATE
%token KW_VERTEX
%token KW_VERTICES
%token KW_IGNORE_EXISTED_INDEX
%token KW_EDGE
%token KW_EDGES
%token KW_STEPS
%token KW_OVER
%token KW_UPTO
%token KW_REVERSELY
%token KW_SPACE
%token KW_DELETE
%token KW_FIND
%token KW_TAG
%token KW_TAGS
%token KW_UNION
%token KW_INTERSECT
%token KW_MINUS
//%token KW_NO
//%token KW_OVERWRITE
%token KW_IN
%token KW_DESCRIBE
%token KW_DESC
%token KW_SHOW
%token KW_HOST
%token KW_HOSTS
%token KW_PART
%token KW_PARTS
%token KW_ADD
%token KW_PARTITION_NUM
%token KW_REPLICA_FACTOR
%token KW_CHARSET
%token KW_COLLATE
%token KW_COLLATION
%token KW_VID_TYPE
%token KW_ATOMIC_EDGE
%token KW_COMMENT
%token KW_S2_MAX_LEVEL
%token KW_S2_MAX_CELLS
%token KW_DROP
%token KW_CLEAR
%token KW_REMOVE
%token KW_SPACES
%token KW_INGEST
%token KW_INDEX
%token KW_INDEXES
%token KW_IF
%token KW_NOT
%token KW_EXISTS
%token KW_WITH
%token KW_BY
%token KW_DOWNLOAD
%token KW_HDFS
%token KW_UUID
%token KW_CONFIGS
%token KW_FORCE
%token KW_GET
//%token KW_DECLARE
%token KW_GRAPH
%token KW_META
%token KW_STORAGE
%token KW_AGENT
//%token KW_TTL
%token KW_TTL_DURATION
%token KW_TTL_COL
%token KW_DATA
%token KW_STOP
%token KW_FETCH
%token KW_PROP
%token KW_UPDATE
%token KW_UPSERT
%token KW_WHEN
%token KW_ORDER
%token KW_ASC
%token KW_LIMIT
%token KW_SAMPLE
%token KW_OFFSET
%token KW_ASCENDING
%token KW_DESCENDING
%token KW_DISTINCT
%token KW_ALL
%token KW_OF
%token KW_BALANCE
%token KW_LEADER
%token KW_RESET
%token KW_PLAN
%token KW_SHORTEST
%token KW_PATH
%token KW_NOLOOP
%token KW_SHORTESTPATH
%token KW_ALLSHORTESTPATHS
//%token KW_IS
%token KW_NULL
%token KW_DEFAULT
%token KW_SNAPSHOT
%token KW_SNAPSHOTS
%token KW_LOOKUP
%token KW_JOBS
%token KW_JOB
%token KW_RECOVER
%token KW_FLUSH
%token KW_COMPACT
%token KW_REBUILD
%token KW_SUBMIT
%token KW_STATS
%token KW_STATUS
%token KW_BIDIRECT
%token KW_USER
%token KW_USERS
%token KW_ACCOUNT
%token KW_PASSWORD
%token KW_CHANGE
%token KW_ROLE
%token KW_ROLES
%token KW_GOD
%token KW_ADMIN
%token KW_DBA
%token KW_GUEST
%token KW_GRANT
%token KW_REVOKE
%token KW_ON
%token KW_OUT
%token KW_BOTH
%token KW_SUBGRAPH
//%token KW_ACROSS
%token KW_EXPLAIN
%token KW_PROFILE
%token KW_FORMAT
%token KW_CONTAINS
%token KW_STARTS
%token KW_ENDS
%token KW_UNWIND
%token KW_SKIP
%token KW_OPTIONAL
%token KW_CASE
%token KW_THEN
%token KW_ELSE
%token KW_END
%token KW_GROUP
%token KW_ZONE
%token KW_GROUPS
%token KW_ZONES
%token KW_INTO
%token KW_NEW
%token KW_LISTENER
%token KW_ELASTICSEARCH
%token KW_FULLTEXT
%token KW_HTTPS
%token KW_HTTP
%token KW_AUTO
%token KW_ES_QUERY
%token KW_ANALYZER
%token KW_TEXT
%token KW_SEARCH
%token KW_CLIENTS
%token KW_SIGN
%token KW_SERVICE
%token KW_TEXT_SEARCH
%token KW_ANY
%token KW_SINGLE
%token KW_NONE
%token KW_REDUCE
%token KW_LOCAL
%token KW_SESSIONS
%token KW_SESSION
%token KW_KILL
%token KW_QUERY
%token KW_QUERIES
%token KW_TOP
%token KW_GEOGRAPHY
%token KW_POINT
%token KW_LINESTRING
%token KW_POLYGON
%token KW_LIST
%token KW_MAP
%token KW_MERGE
%token KW_DIVIDE
%token KW_RENAME
%token KW_JOIN
%token KW_LEFT
%token KW_RIGHT
%token KW_OUTER
%token KW_INNER
%token KW_SEMI
%token KW_ANTI
%token L_PAREN
%token R_PAREN
%token L_BRACKET
%token R_BRACKET
%token L_BRACE
%token R_BRACE
%token COMMA
%token MINUS_L_BRACKET
%token R_BRACKET_MINUS
%token L_ARROW_L_BRACKET
%token R_BRACKET_R_ARROW
%token PIPE
%token MINUS_MINUS
%token MINUS_R_ARROW
%token L_ARROW_MINUS
%token L_ARROW_R_ARROW
%token ASSIGN
%token DOT
%token DOT_DOT
%token COLON
%token QM
%token SEMICOLON
//%token L_ARROW
%token R_ARROW
%token AT
//%token ID_PROP
%token TYPE_PROP
%token SRC_ID_PROP
%token DST_ID_PROP
%token RANK_PROP
%token INPUT_REF
%token DST_REF
%token SRC_REF
%token BOOL
%token INTEGER
%token DOUBLE
%token STRING
%token VARIABLE
%token LABEL
%token IPV4
%token KW_OR
%token KW_XOR
%token KW_AND
%token EQ
%token NE
%token LT
%token LE
%token GT
%token GE
%token REG
%token KW_NOT_IN
%token KW_NOT_CONTAINS
%token KW_STARTS_WITH
%token KW_ENDS_WITH
%token KW_NOT_STARTS_WITH
%token KW_NOT_ENDS_WITH
%token KW_IS_NULL
%token KW_IS_NOT_NULL
%token KW_IS_EMPTY
%token KW_IS_NOT_EMPTY
%token DUMMY_LOWER_THAN_MINUS
%token PLUS
%token MINUS
%token STAR
%token DIV
%token MOD
%token NOT

%left /*1*/ COLON QM
%left /*2*/ KW_OR KW_XOR
%left /*3*/ KW_AND
%right /*4*/ KW_NOT
%left /*5*/ KW_IN KW_CONTAINS EQ NE LT LE GT GE REG KW_NOT_IN KW_NOT_CONTAINS KW_STARTS_WITH KW_ENDS_WITH KW_NOT_STARTS_WITH KW_NOT_ENDS_WITH KW_IS_NULL KW_IS_NOT_NULL KW_IS_EMPTY KW_IS_NOT_EMPTY
%nonassoc /*6*/ DUMMY_LOWER_THAN_MINUS
%left /*7*/ PLUS MINUS
%left /*8*/ STAR DIV MOD
%right /*9*/ NOT
%nonassoc /*10*/ DUMMY_LOWER_THAN_L_BRACE
%nonassoc /*11*/ KW_MAP L_BRACE
%nonassoc /*12*/ UNARY_PLUS
%nonassoc /*13*/ UNARY_MINUS
%nonassoc /*14*/ CASTING

%start sentences

%%

name_label :
	LABEL
	| unreserved_keyword
	;

name_label_list :
	name_label
	| name_label_list COMMA name_label
	;

legal_integer :
	INTEGER
	;

unreserved_keyword :
	KW_SPACE
	| KW_VALUE
	| KW_VALUES
	| KW_HOST
	| KW_HOSTS
	| KW_SPACES
	| KW_USER
	| KW_USERS
	| KW_PASSWORD
	| KW_ROLE
	| KW_ROLES
	| KW_GOD
	| KW_ADMIN
	| KW_DBA
	| KW_GUEST
	| KW_GROUP
	| KW_DATA
	| KW_LEADER
	| KW_UUID
	| KW_JOB
	| KW_JOBS
	| KW_BIDIRECT
	| KW_FORCE
	| KW_PART
	| KW_PARTS
	| KW_DEFAULT
	| KW_CONFIGS
	| KW_ACCOUNT
	| KW_HDFS
	| KW_PARTITION_NUM
	| KW_REPLICA_FACTOR
	| KW_CHARSET
	| KW_COLLATE
	| KW_COLLATION
	| KW_ATOMIC_EDGE
	| KW_TTL_DURATION
	| KW_TTL_COL
	| KW_SNAPSHOT
	| KW_SNAPSHOTS
	| KW_GRAPH
	| KW_META
	| KW_STORAGE
	| KW_AGENT
	| KW_ALL
	| KW_ANY
	| KW_SINGLE
	| KW_NONE
	| KW_REDUCE
	| KW_SHORTEST
	| KW_SHORTESTPATH
	| KW_ALLSHORTESTPATHS
	| KW_NOLOOP
	| KW_CONTAINS /*5L*/
	| KW_STARTS
	| KW_ENDS
	| KW_VID_TYPE
	| KW_LIMIT
	| KW_SKIP
	| KW_OPTIONAL
	| KW_OFFSET
	| KW_FORMAT
	| KW_PROFILE
	| KW_BOTH
	| KW_OUT
	| KW_SUBGRAPH
	| KW_THEN
	| KW_ELSE
	| KW_END
	| KW_INTO
	| KW_NEW
	| KW_GROUPS
	| KW_ZONE
	| KW_ZONES
	| KW_LISTENER
	| KW_ELASTICSEARCH
	| KW_FULLTEXT
	| KW_STATS
	| KW_STATUS
	| KW_AUTO
	| KW_ES_QUERY
	| KW_TEXT
	| KW_SEARCH
	| KW_CLIENTS
	| KW_SIGN
	| KW_SERVICE
	| KW_TEXT_SEARCH
	| KW_RESET
	| KW_PLAN
	| KW_COMMENT
	| KW_S2_MAX_LEVEL
	| KW_S2_MAX_CELLS
	| KW_SESSION
	| KW_SESSIONS
	| KW_LOCAL
	| KW_SAMPLE
	| KW_QUERIES
	| KW_QUERY
	| KW_KILL
	| KW_TOP
	| KW_POINT
	| KW_LINESTRING
	| KW_POLYGON
	| KW_HTTP
	| KW_HTTPS
	| KW_MERGE
	| KW_DIVIDE
	| KW_RENAME
	| KW_CLEAR
	| KW_ANALYZER
	;

expression :
	expression_internal
	;

expression_internal :
	constant_expression
	| name_label
	| VARIABLE
	| compound_expression
	| MINUS /*7L*/ expression_internal %prec UNARY_MINUS /*13N*/
	| PLUS /*7L*/ expression_internal %prec UNARY_PLUS /*12N*/
	| NOT /*9R*/ expression_internal
	| KW_NOT /*4R*/ expression_internal
	| L_PAREN type_spec R_PAREN expression_internal %prec CASTING /*14N*/
	| expression_internal STAR /*8L*/ expression_internal
	| expression_internal DIV /*8L*/ expression_internal
	| expression_internal MOD /*8L*/ expression_internal
	| expression_internal PLUS /*7L*/ expression_internal
	| expression_internal MINUS /*7L*/ expression_internal
	| expression_internal LT /*5L*/ expression_internal
	| expression_internal GT /*5L*/ expression_internal
	| expression_internal LE /*5L*/ expression_internal
	| expression_internal GE /*5L*/ expression_internal
	| expression_internal REG /*5L*/ expression_internal
	| expression_internal KW_IN /*5L*/ expression_internal
	| expression_internal KW_NOT_IN /*5L*/ expression_internal
	| expression_internal KW_CONTAINS /*5L*/ expression_internal
	| expression_internal KW_NOT_CONTAINS /*5L*/ expression_internal
	| expression_internal KW_STARTS_WITH /*5L*/ expression_internal
	| expression_internal KW_NOT_STARTS_WITH /*5L*/ expression_internal
	| expression_internal KW_ENDS_WITH /*5L*/ expression_internal
	| expression_internal KW_NOT_ENDS_WITH /*5L*/ expression_internal
	| expression_internal KW_IS_NULL /*5L*/
	| expression_internal KW_IS_NOT_NULL /*5L*/
	| expression_internal KW_IS_EMPTY /*5L*/
	| expression_internal KW_IS_NOT_EMPTY /*5L*/
	| expression_internal EQ /*5L*/ expression_internal
	| expression_internal NE /*5L*/ expression_internal
	| expression_internal KW_AND /*3L*/ expression_internal
	| expression_internal KW_OR /*2L*/ expression_internal
	| expression_internal KW_XOR /*2L*/ expression_internal
	| case_expression
	| predicate_expression
	| reduce_expression
	| uuid_expression
	;

constant_expression :
	DOUBLE
	| STRING
	| BOOL
	| KW_NULL
	| INTEGER
	;

compound_expression :
	match_path_pattern_expression
	| parenthesized_expression
	| property_expression
	| function_call_expression
	| container_expression
	| list_comprehension_expression
	| subscript_expression
	| subscript_range_expression
	| attribute_expression
	;

parenthesized_expression :
	L_PAREN expression_internal R_PAREN
	;

property_expression :
	input_prop_expression
	| vertex_prop_expression
	| var_prop_expression
	| edge_prop_expression
	;

subscript_expression :
	name_label L_BRACKET expression_internal R_BRACKET
	| VARIABLE L_BRACKET expression_internal R_BRACKET
	| compound_expression L_BRACKET expression_internal R_BRACKET
	;

subscript_range_expression :
	name_label L_BRACKET expression_internal DOT_DOT expression_internal R_BRACKET
	| name_label L_BRACKET DOT_DOT expression_internal R_BRACKET
	| name_label L_BRACKET expression_internal DOT_DOT R_BRACKET
	| VARIABLE L_BRACKET expression_internal DOT_DOT expression_internal R_BRACKET
	| VARIABLE L_BRACKET DOT_DOT expression_internal R_BRACKET
	| VARIABLE L_BRACKET expression_internal DOT_DOT R_BRACKET
	| compound_expression L_BRACKET expression_internal DOT_DOT expression_internal R_BRACKET
	| compound_expression L_BRACKET DOT_DOT expression_internal R_BRACKET
	| compound_expression L_BRACKET expression_internal DOT_DOT R_BRACKET
	;

attribute_expression :
	name_label DOT name_label
	| compound_expression DOT name_label
	;

case_expression :
	generic_case_expression
	| conditional_expression
	;

generic_case_expression :
	KW_CASE case_condition when_then_list case_default KW_END
	;

conditional_expression :
	expression_internal QM /*1L*/ expression_internal COLON /*1L*/ expression_internal
	;

case_condition :
	/*empty*/
	| expression_internal
	;

case_default :
	/*empty*/
	| KW_ELSE expression_internal
	;

when_then_list :
	KW_WHEN expression_internal KW_THEN expression_internal
	| when_then_list KW_WHEN expression_internal KW_THEN expression_internal
	;

predicate_name :
	KW_ALL
	| KW_ANY
	| KW_SINGLE
	| KW_NONE
	;

predicate_expression :
	predicate_name L_PAREN expression_internal KW_IN /*5L*/ expression_internal KW_WHERE expression_internal R_PAREN
	| KW_EXISTS L_PAREN expression_internal R_PAREN
	;

list_comprehension_expression :
	L_BRACKET expression_internal KW_IN /*5L*/ expression_internal KW_WHERE expression_internal R_BRACKET
	| L_BRACKET expression_internal KW_IN /*5L*/ expression_internal PIPE expression_internal R_BRACKET
	| L_BRACKET expression_internal KW_IN /*5L*/ expression_internal KW_WHERE expression_internal PIPE expression_internal R_BRACKET
	;

reduce_expression :
	KW_REDUCE L_PAREN name_label ASSIGN expression_internal COMMA name_label KW_IN /*5L*/ expression_internal PIPE expression_internal R_PAREN
	;

input_prop_expression :
	INPUT_REF DOT name_label
	| INPUT_REF DOT STAR /*8L*/
	;

vertex_prop_expression :
	SRC_REF DOT name_label DOT name_label
	| DST_REF DOT name_label DOT name_label
	;

var_prop_expression :
	VARIABLE DOT name_label
	| VARIABLE DOT STAR /*8L*/
	;

edge_prop_expression :
	name_label DOT TYPE_PROP
	| name_label DOT SRC_ID_PROP
	| name_label DOT DST_ID_PROP
	| name_label DOT RANK_PROP
	;

function_call_expression :
	LABEL L_PAREN opt_argument_list R_PAREN
	| LABEL L_PAREN KW_DISTINCT expression_internal R_PAREN
	| LABEL L_PAREN STAR /*8L*/ R_PAREN
	| KW_TIMESTAMP L_PAREN opt_argument_list R_PAREN
	| KW_DATE L_PAREN opt_argument_list R_PAREN
	| KW_TIME L_PAREN opt_argument_list R_PAREN
	| KW_DATETIME L_PAREN opt_argument_list R_PAREN
	| KW_TAGS L_PAREN opt_argument_list R_PAREN
	| KW_SIGN L_PAREN opt_argument_list R_PAREN
	| KW_DURATION L_PAREN opt_argument_list R_PAREN
	| KW_LEFT L_PAREN opt_argument_list R_PAREN
	| KW_RIGHT L_PAREN opt_argument_list R_PAREN
	;

uuid_expression :
	KW_UUID L_PAREN R_PAREN
	;

match_path_pattern_expression :
	match_relationships_pattern %prec DUMMY_LOWER_THAN_MINUS /*6N*/
	;

opt_argument_list :
	/*empty*/
	| argument_list
	;

argument_list :
	KW_VERTEX
	| SRC_REF
	| DST_REF
	| KW_EDGE
	| expression_internal
	| argument_list COMMA expression_internal
	;

geo_shape_type :
	KW_POINT
	| KW_LINESTRING
	| KW_POLYGON
	;

type_spec :
	KW_BOOL
	| KW_INT8
	| KW_INT16
	| KW_INT32
	| KW_INT64
	| KW_INT
	| KW_FLOAT
	| KW_DOUBLE
	| KW_STRING
	| KW_FIXED_STRING L_PAREN INTEGER R_PAREN
	| KW_TIMESTAMP
	| KW_DATE
	| KW_TIME
	| KW_DATETIME
	| KW_GEOGRAPHY
	| KW_GEOGRAPHY L_PAREN geo_shape_type R_PAREN
	| KW_DURATION
	;

container_expression :
	list_expression
	| set_expression
	| map_expression
	;

list_expression :
	L_BRACKET expression_list R_BRACKET
	| KW_LIST L_BRACKET opt_expression_list R_BRACKET
	;

set_expression :
	L_BRACE /*11N*/ expression_list R_BRACE
	| KW_SET L_BRACE /*11N*/ opt_expression_list R_BRACE
	;

opt_expression_list :
	/*empty*/
	| expression_list
	;

expression_list :
	expression_internal
	| expression_list COMMA expression_internal
	;

map_expression :
	L_BRACE /*11N*/ map_item_list R_BRACE
	| KW_MAP /*11N*/ L_BRACE /*11N*/ opt_map_item_list R_BRACE
	;

opt_map_item_list :
	/*empty*/
	| map_item_list
	;

map_item_list :
	name_label COLON /*1L*/ expression_internal
	| map_item_list COMMA name_label COLON /*1L*/ expression_internal
	;

truncate_clause :
	/*empty*/
	| KW_SAMPLE expression
	| KW_LIMIT expression
	;

go_sentence :
	KW_GO step_clause from_clause over_clause where_clause yield_clause truncate_clause
	;

step_clause :
	/*empty*/
	| legal_integer KW_STEPS
	| legal_integer KW_TO legal_integer KW_STEPS
	;

from_clause :
	KW_FROM vid_list
	| KW_FROM vid_ref_expression
	;

vid_list :
	vid
	| vid_list COMMA vid
	;

vid :
	unary_integer
	| function_call_expression
	| uuid_expression
	| STRING
	| VARIABLE
	;

unary_integer :
	PLUS /*7L*/ legal_integer
	| MINUS /*7L*/ INTEGER
	| legal_integer
	;

vid_ref_expression :
	input_prop_expression
	| var_prop_expression
	;

over_edge :
	name_label
	| name_label KW_AS name_label
	;

over_edges :
	over_edge
	| over_edges COMMA over_edge
	;

over_clause :
	KW_OVER STAR /*8L*/
	| KW_OVER STAR /*8L*/ KW_REVERSELY
	| KW_OVER STAR /*8L*/ KW_BIDIRECT
	| KW_OVER over_edges
	| KW_OVER over_edges KW_REVERSELY
	| KW_OVER over_edges KW_BIDIRECT
	;

where_clause :
	/*empty*/
	| KW_WHERE expression
	;

when_clause :
	/*empty*/
	| KW_WHEN expression
	;

yield_clause :
	/*empty*/
	| KW_YIELD yield_columns
	| KW_YIELD KW_DISTINCT yield_columns
	;

yield_columns :
	yield_column
	| yield_columns COMMA yield_column
	;

yield_column :
	KW_VERTEX
	| KW_VERTEX KW_AS name_label
	| SRC_REF
	| SRC_REF KW_AS name_label
	| DST_REF
	| DST_REF KW_AS name_label
	| KW_VERTICES
	| KW_VERTICES KW_AS name_label
	| KW_EDGE
	| KW_EDGE KW_AS name_label
	| KW_EDGES
	| KW_EDGES KW_AS name_label
	| KW_PATH
	| KW_PATH KW_AS name_label
	| expression
	| expression KW_AS name_label
	;

group_clause :
	yield_columns
	;

join_mode :
	KW_INNER KW_JOIN
	| KW_LEFT KW_JOIN
	| KW_RIGHT KW_JOIN
	| KW_OUTER KW_JOIN
	| KW_SEMI KW_JOIN
	| KW_ANTI KW_JOIN
	;

join_clause :
	KW_FROM VARIABLE KW_JOIN VARIABLE
	| KW_FROM VARIABLE join_mode VARIABLE KW_ON var_prop_expression EQ /*5L*/ var_prop_expression
	;

yield_sentence :
	KW_YIELD yield_columns where_clause
	| KW_YIELD KW_DISTINCT yield_columns where_clause
	| KW_YIELD yield_columns join_clause
	| KW_YIELD KW_DISTINCT yield_columns join_clause
	| KW_RETURN yield_columns
	| KW_RETURN KW_DISTINCT yield_columns
	;

unwind_clause :
	KW_UNWIND expression KW_AS name_label
	;

unwind_sentence :
	KW_UNWIND expression KW_AS name_label
	;

with_clause :
	KW_WITH match_return_items match_order_by match_skip match_limit where_clause
	| KW_WITH KW_DISTINCT match_return_items match_order_by match_skip match_limit where_clause
	;

match_clause :
	KW_MATCH match_path_list where_clause
	| KW_OPTIONAL KW_MATCH match_path_list where_clause
	;

reading_clause :
	unwind_clause
	| match_clause
	;

reading_clauses :
	reading_clause
	| reading_clauses reading_clause
	;

reading_with_clause :
	with_clause
	| reading_clauses with_clause
	;

reading_with_clauses :
	reading_with_clause
	| reading_with_clauses reading_with_clause
	;

match_sentence :
	reading_clauses match_return
	| reading_with_clauses match_return
	| reading_with_clauses reading_clauses match_return
	;

match_relationships_pattern :
	match_node match_edge match_node
	| match_relationships_pattern match_edge match_node
	;

match_path_pattern :
	match_node
	| match_path_pattern match_edge match_node
	| KW_SHORTESTPATH L_PAREN match_path_pattern R_PAREN
	| KW_ALLSHORTESTPATHS L_PAREN match_path_pattern R_PAREN
	;

match_path :
	match_path_pattern
	| name_label ASSIGN match_path_pattern
	;

match_path_list :
	match_path
	| match_path_list COMMA match_path
	;

match_node :
	L_PAREN R_PAREN
	| parenthesized_expression
	| L_PAREN match_alias match_node_label_list R_PAREN
	| L_PAREN match_alias map_expression R_PAREN
	;

match_node_label :
	COLON /*1L*/ name_label
	| COLON /*1L*/ name_label map_expression
	;

match_node_label_list :
	match_node_label
	| match_node_label_list match_node_label
	;

match_alias :
	%prec DUMMY_LOWER_THAN_L_BRACE /*10N*/ /*empty*/
	| name_label
	;

match_edge :
	MINUS_MINUS
	| MINUS_R_ARROW
	| L_ARROW_MINUS
	| L_ARROW_R_ARROW
	| MINUS_L_BRACKET match_edge_prop R_BRACKET_MINUS
	| MINUS_L_BRACKET match_edge_prop R_BRACKET_R_ARROW
	| L_ARROW_L_BRACKET match_edge_prop R_BRACKET_MINUS
	| L_ARROW_L_BRACKET match_edge_prop R_BRACKET_R_ARROW
	;

match_edge_prop :
	match_alias opt_match_edge_type_list match_step_range
	| match_alias opt_match_edge_type_list match_step_range map_expression
	;

opt_match_edge_type_list :
	/*empty*/
	| match_edge_type_list
	;

match_step_range :
	/*empty*/
	| STAR /*8L*/
	| STAR /*8L*/ legal_integer
	| STAR /*8L*/ DOT_DOT legal_integer
	| STAR /*8L*/ legal_integer DOT_DOT
	| STAR /*8L*/ legal_integer DOT_DOT legal_integer
	;

match_edge_type_list :
	COLON /*1L*/ name_label
	| match_edge_type_list PIPE name_label
	| match_edge_type_list PIPE COLON /*1L*/ name_label
	;

match_return :
	KW_RETURN match_return_items match_order_by match_skip match_limit
	| KW_RETURN KW_DISTINCT match_return_items match_order_by match_skip match_limit
	;

match_return_items :
	STAR /*8L*/
	| STAR /*8L*/ COMMA yield_columns
	| yield_columns
	;

match_order_by :
	/*empty*/
	| KW_ORDER KW_BY order_factors
	;

match_skip :
	/*empty*/
	| KW_SKIP expression
	;

match_limit :
	/*empty*/
	| KW_LIMIT expression
	;

service_client_item :
	L_PAREN host_item R_PAREN
	| L_PAREN host_item COMMA KW_HTTP R_PAREN
	| L_PAREN host_item COMMA KW_HTTPS R_PAREN
	| L_PAREN host_item COMMA STRING COMMA STRING R_PAREN
	| L_PAREN host_item COMMA KW_HTTP COMMA STRING COMMA STRING R_PAREN
	| L_PAREN host_item COMMA KW_HTTPS COMMA STRING COMMA STRING R_PAREN
	;

service_client_list :
	service_client_item
	| service_client_list COMMA service_client_item
	| service_client_list COMMA
	;

sign_in_service_sentence :
	KW_SIGN KW_IN /*5L*/ KW_TEXT KW_SERVICE service_client_list
	;

sign_out_service_sentence :
	KW_SIGN KW_OUT KW_TEXT KW_SERVICE
	;

text_search_argument :
	name_label COMMA STRING
	;

text_search_expression :
	KW_ES_QUERY L_PAREN text_search_argument R_PAREN
	;

lookup_where_clause :
	/*empty*/
	| KW_WHERE text_search_expression
	| KW_WHERE expression
	;

lookup_sentence :
	KW_LOOKUP KW_ON name_label lookup_where_clause yield_clause
	;

order_factor :
	expression
	| expression KW_ASC
	| expression KW_DESC
	| expression KW_ASCENDING
	| expression KW_DESCENDING
	;

order_factors :
	order_factor
	| order_factors COMMA order_factor
	;

order_by_sentence :
	KW_ORDER KW_BY order_factors
	;

fetch_vertices_sentence :
	KW_FETCH KW_PROP KW_ON name_label_list vid_list yield_clause
	| KW_FETCH KW_PROP KW_ON name_label_list vid_ref_expression yield_clause
	| KW_FETCH KW_PROP KW_ON STAR /*8L*/ vid_list yield_clause
	| KW_FETCH KW_PROP KW_ON STAR /*8L*/ vid_ref_expression yield_clause
	;

edge_key :
	vid R_ARROW vid AT rank
	| vid R_ARROW vid
	;

edge_keys :
	edge_key
	| edge_keys COMMA edge_key
	;

edge_key_ref :
	input_prop_expression R_ARROW input_prop_expression AT input_prop_expression
	| input_prop_expression R_ARROW input_prop_expression AT constant_expression
	| var_prop_expression R_ARROW var_prop_expression AT var_prop_expression
	| var_prop_expression R_ARROW var_prop_expression AT constant_expression
	| input_prop_expression R_ARROW input_prop_expression
	| var_prop_expression R_ARROW var_prop_expression
	;

fetch_edges_sentence :
	KW_FETCH KW_PROP KW_ON name_label_list edge_keys yield_clause
	| KW_FETCH KW_PROP KW_ON name_label_list edge_key_ref yield_clause
	;

fetch_sentence :
	fetch_vertices_sentence
	| fetch_edges_sentence
	;

find_path_sentence :
	KW_FIND KW_ALL KW_PATH opt_with_properties from_clause to_clause over_clause where_clause find_path_upto_clause yield_clause
	| KW_FIND KW_SHORTEST KW_PATH opt_with_properties from_clause to_clause over_clause where_clause find_path_upto_clause yield_clause
	| KW_FIND KW_SINGLE KW_SHORTEST KW_PATH opt_with_properties from_clause to_clause over_clause where_clause find_path_upto_clause yield_clause
	| KW_FIND KW_NOLOOP KW_PATH opt_with_properties from_clause to_clause over_clause where_clause find_path_upto_clause yield_clause
	;

opt_with_properties :
	/*empty*/
	| KW_WITH KW_PROP
	;

find_path_upto_clause :
	/*empty*/
	| KW_UPTO legal_integer KW_STEPS
	;

to_clause :
	KW_TO vid_list
	| KW_TO vid_ref_expression
	;

limit_sentence :
	KW_LIMIT legal_integer
	| KW_LIMIT legal_integer COMMA legal_integer
	| KW_LIMIT legal_integer KW_OFFSET legal_integer
	| KW_OFFSET legal_integer KW_LIMIT legal_integer
	;

group_by_yield_clause :
	KW_YIELD yield_columns
	| KW_YIELD KW_DISTINCT yield_columns
	;

group_by_sentence :
	KW_GROUP KW_BY group_clause group_by_yield_clause
	;

in_bound_clause :
	/*empty*/
	| KW_IN /*5L*/ over_edges
	;

out_bound_clause :
	/*empty*/
	| KW_OUT over_edges
	;

both_in_out_clause :
	/*empty*/
	| KW_BOTH over_edges
	;

get_subgraph_sentence :
	KW_GET KW_SUBGRAPH opt_with_properties step_clause from_clause in_bound_clause out_bound_clause both_in_out_clause where_clause yield_clause
	;

use_sentence :
	KW_USE name_label
	;

opt_if_not_exists :
	/*empty*/
	| KW_IF KW_NOT /*4R*/ KW_EXISTS
	;

opt_if_exists :
	/*empty*/
	| KW_IF KW_EXISTS
	;

opt_create_schema_prop_list :
	/*empty*/
	| create_schema_prop_list
	;

opt_ignore_existed_index :
	/*empty*/
	| KW_IGNORE_EXISTED_INDEX
	;

create_schema_prop_list :
	create_schema_prop_item
	| create_schema_prop_list COMMA create_schema_prop_item
	;

create_schema_prop_item :
	KW_TTL_DURATION ASSIGN legal_integer
	| KW_TTL_COL ASSIGN STRING
	| comment_prop_assignment
	;

create_tag_sentence :
	KW_CREATE KW_TAG opt_if_not_exists name_label L_PAREN R_PAREN opt_create_schema_prop_list
	| KW_CREATE KW_TAG opt_if_not_exists name_label L_PAREN column_spec_list R_PAREN opt_create_schema_prop_list
	| KW_CREATE KW_TAG opt_if_not_exists name_label L_PAREN column_spec_list COMMA R_PAREN opt_create_schema_prop_list
	;

alter_tag_sentence :
	KW_ALTER KW_TAG name_label alter_schema_opt_list
	| KW_ALTER KW_TAG name_label alter_schema_prop_list
	| KW_ALTER KW_TAG name_label alter_schema_opt_list alter_schema_prop_list
	;

alter_schema_opt_list :
	alter_schema_opt_item
	| alter_schema_opt_list COMMA alter_schema_opt_item
	;

alter_schema_opt_item :
	KW_ADD L_PAREN column_spec_list R_PAREN
	| KW_CHANGE L_PAREN column_spec_list R_PAREN
	| KW_DROP L_PAREN column_name_list R_PAREN
	;

alter_schema_prop_list :
	alter_schema_prop_item
	| alter_schema_prop_list COMMA alter_schema_prop_item
	;

alter_schema_prop_item :
	KW_TTL_DURATION ASSIGN legal_integer
	| KW_TTL_COL ASSIGN STRING
	| comment_prop_assignment
	;

create_edge_sentence :
	KW_CREATE KW_EDGE opt_if_not_exists name_label L_PAREN R_PAREN opt_create_schema_prop_list
	| KW_CREATE KW_EDGE opt_if_not_exists name_label L_PAREN column_spec_list R_PAREN opt_create_schema_prop_list
	| KW_CREATE KW_EDGE opt_if_not_exists name_label L_PAREN column_spec_list COMMA R_PAREN opt_create_schema_prop_list
	;

alter_edge_sentence :
	KW_ALTER KW_EDGE name_label alter_schema_opt_list
	| KW_ALTER KW_EDGE name_label alter_schema_prop_list
	| KW_ALTER KW_EDGE name_label alter_schema_opt_list alter_schema_prop_list
	;

column_name_list :
	name_label
	| column_name_list COMMA name_label
	;

column_spec_list :
	column_spec
	| column_spec_list COMMA column_spec
	;

column_spec :
	name_label type_spec
	| name_label type_spec column_properties
	;

column_properties :
	column_property
	| column_properties column_property
	;

column_property :
	KW_NULL
	| KW_NOT /*4R*/ KW_NULL
	| KW_DEFAULT expression
	| comment_prop
	;

describe_user_sentence :
	KW_DESCRIBE KW_USER name_label
	| KW_DESC KW_USER name_label
	;

describe_tag_sentence :
	KW_DESCRIBE KW_TAG name_label
	| KW_DESC KW_TAG name_label
	;

describe_edge_sentence :
	KW_DESCRIBE KW_EDGE name_label
	| KW_DESC KW_EDGE name_label
	;

drop_tag_sentence :
	KW_DROP KW_TAG opt_if_exists name_label
	;

drop_edge_sentence :
	KW_DROP KW_EDGE opt_if_exists name_label
	;

index_field :
	name_label
	| name_label L_PAREN INTEGER R_PAREN
	;

index_field_list :
	index_field
	| index_field_list COMMA index_field
	;

opt_index_field_list :
	/*empty*/
	| index_field_list
	;

create_tag_index_sentence :
	KW_CREATE KW_TAG KW_INDEX opt_if_not_exists name_label KW_ON name_label L_PAREN opt_index_field_list R_PAREN opt_with_index_param_list opt_comment_prop
	;

create_edge_index_sentence :
	KW_CREATE KW_EDGE KW_INDEX opt_if_not_exists name_label KW_ON name_label L_PAREN opt_index_field_list R_PAREN opt_with_index_param_list opt_comment_prop
	;

opt_analyzer :
	/*empty*/
	| KW_ANALYZER ASSIGN STRING
	;

create_fulltext_index_sentence :
	KW_CREATE KW_FULLTEXT KW_TAG KW_INDEX name_label KW_ON name_label L_PAREN name_label_list R_PAREN opt_analyzer
	| KW_CREATE KW_FULLTEXT KW_EDGE KW_INDEX name_label KW_ON name_label L_PAREN name_label_list R_PAREN opt_analyzer
	;

drop_fulltext_index_sentence :
	KW_DROP KW_FULLTEXT KW_INDEX name_label
	;

comment_prop_assignment :
	KW_COMMENT ASSIGN STRING
	;

comment_prop :
	KW_COMMENT STRING
	;

opt_comment_prop :
	/*empty*/
	| comment_prop
	;

opt_with_index_param_list :
	/*empty*/
	| KW_WITH L_PAREN index_param_list R_PAREN
	;

index_param_list :
	index_param_item
	| index_param_list COMMA index_param_item
	;

index_param_item :
	KW_S2_MAX_LEVEL ASSIGN legal_integer
	| KW_S2_MAX_CELLS ASSIGN legal_integer
	;

drop_tag_index_sentence :
	KW_DROP KW_TAG KW_INDEX opt_if_exists name_label
	;

drop_edge_index_sentence :
	KW_DROP KW_EDGE KW_INDEX opt_if_exists name_label
	;

describe_tag_index_sentence :
	KW_DESCRIBE KW_TAG KW_INDEX name_label
	| KW_DESC KW_TAG KW_INDEX name_label
	;

describe_edge_index_sentence :
	KW_DESCRIBE KW_EDGE KW_INDEX name_label
	| KW_DESC KW_EDGE KW_INDEX name_label
	;

rebuild_tag_index_sentence :
	KW_REBUILD KW_TAG KW_INDEX name_label_list
	| KW_REBUILD KW_TAG KW_INDEX
	;

rebuild_edge_index_sentence :
	KW_REBUILD KW_EDGE KW_INDEX name_label_list
	| KW_REBUILD KW_EDGE KW_INDEX
	;

rebuild_fulltext_index_sentence :
	KW_REBUILD KW_FULLTEXT KW_INDEX
	;

add_hosts_sentence :
	KW_ADD KW_HOSTS host_list
	| KW_ADD KW_HOSTS host_list KW_INTO KW_ZONE name_label
	| KW_ADD KW_HOSTS host_list KW_INTO KW_NEW KW_ZONE name_label
	;

drop_hosts_sentence :
	KW_DROP KW_HOSTS host_list
	;

merge_zone_sentence :
	KW_MERGE KW_ZONE zone_name_list KW_INTO name_label
	;

drop_zone_sentence :
	KW_DROP KW_ZONE name_label
	;

zone_item :
	name_label L_PAREN host_list R_PAREN
	;

zone_item_list :
	zone_item
	| zone_item_list zone_item
	;

divide_zone_sentence :
	KW_DIVIDE KW_ZONE name_label KW_INTO zone_item_list
	;

rename_zone_sentence :
	KW_RENAME KW_ZONE name_label KW_TO name_label
	;

desc_zone_sentence :
	KW_DESCRIBE KW_ZONE name_label
	| KW_DESC KW_ZONE name_label
	;

traverse_sentence :
	L_PAREN set_sentence R_PAREN
	| go_sentence
	| lookup_sentence
	| group_by_sentence
	| order_by_sentence
	| fetch_sentence
	| find_path_sentence
	| yield_sentence
	| get_subgraph_sentence
	| delete_vertex_sentence
	| delete_tag_sentence
	| delete_edge_sentence
	| show_queries_sentence
	| kill_query_sentence
	| describe_user_sentence
	| unwind_sentence
	| show_sentence
	| kill_session_sentence
	;

piped_sentence :
	traverse_sentence
	| piped_sentence PIPE traverse_sentence
	| piped_sentence PIPE limit_sentence
	;

set_sentence :
	piped_sentence
	| set_sentence KW_UNION KW_ALL piped_sentence
	| set_sentence KW_UNION piped_sentence
	| set_sentence KW_UNION KW_DISTINCT piped_sentence
	| set_sentence KW_INTERSECT piped_sentence
	| set_sentence KW_MINUS piped_sentence
	;

match_sentences :
	match_sentence
	| match_sentences KW_UNION KW_ALL match_sentence
	| match_sentences KW_UNION match_sentence
	| match_sentences KW_UNION KW_DISTINCT match_sentence
	| match_sentences KW_INTERSECT match_sentence
	| match_sentences KW_MINUS match_sentence
	;

assignment_sentence :
	VARIABLE ASSIGN set_sentence
	;

insert_vertex_sentence :
	KW_INSERT KW_VERTEX opt_if_not_exists opt_ignore_existed_index vertex_tag_list KW_VALUES vertex_row_list
	| KW_INSERT KW_VERTEX opt_if_not_exists opt_ignore_existed_index KW_VALUES vertex_row_list
	;

vertex_tag_list :
	vertex_tag_item
	| vertex_tag_list COMMA vertex_tag_item
	;

vertex_tag_item :
	name_label
	| name_label L_PAREN R_PAREN
	| name_label L_PAREN prop_list R_PAREN
	;

prop_list :
	name_label
	| prop_list COMMA name_label
	| prop_list COMMA
	;

vertex_row_list :
	vertex_row_item
	| vertex_row_list COMMA vertex_row_item
	;

vertex_row_item :
	vid COLON /*1L*/ L_PAREN R_PAREN
	| vid COLON /*1L*/ L_PAREN value_list R_PAREN
	;

value_list :
	expression
	| value_list COMMA expression
	| value_list COMMA
	;

insert_edge_sentence :
	KW_INSERT KW_EDGE opt_if_not_exists opt_ignore_existed_index name_label KW_VALUES edge_row_list
	| KW_INSERT KW_EDGE opt_if_not_exists opt_ignore_existed_index name_label L_PAREN R_PAREN KW_VALUES edge_row_list
	| KW_INSERT KW_EDGE opt_if_not_exists opt_ignore_existed_index name_label L_PAREN prop_list R_PAREN KW_VALUES edge_row_list
	;

edge_row_list :
	edge_row_item
	| edge_row_list COMMA edge_row_item
	;

edge_row_item :
	vid R_ARROW vid COLON /*1L*/ L_PAREN R_PAREN
	| vid R_ARROW vid COLON /*1L*/ L_PAREN value_list R_PAREN
	| vid R_ARROW vid AT rank COLON /*1L*/ L_PAREN R_PAREN
	| vid R_ARROW vid AT rank COLON /*1L*/ L_PAREN value_list R_PAREN
	;

rank :
	unary_integer
	;

update_list :
	update_item
	| update_list COMMA update_item
	;

update_item :
	name_label ASSIGN expression
	| name_label DOT name_label ASSIGN expression
	;

update_vertex_sentence :
	KW_UPDATE KW_VERTEX vid KW_SET update_list when_clause yield_clause
	| KW_UPSERT KW_VERTEX vid KW_SET update_list when_clause yield_clause
	| KW_UPDATE KW_VERTEX KW_ON name_label vid KW_SET update_list when_clause yield_clause
	| KW_UPSERT KW_VERTEX KW_ON name_label vid KW_SET update_list when_clause yield_clause
	;

update_edge_sentence :
	KW_UPDATE KW_EDGE vid R_ARROW vid KW_OF name_label KW_SET update_list when_clause yield_clause
	| KW_UPSERT KW_EDGE vid R_ARROW vid KW_OF name_label KW_SET update_list when_clause yield_clause
	| KW_UPDATE KW_EDGE vid R_ARROW vid AT rank KW_OF name_label KW_SET update_list when_clause yield_clause
	| KW_UPSERT KW_EDGE vid R_ARROW vid AT rank KW_OF name_label KW_SET update_list when_clause yield_clause
	| KW_UPDATE KW_EDGE KW_ON name_label vid R_ARROW vid KW_SET update_list when_clause yield_clause
	| KW_UPSERT KW_EDGE KW_ON name_label vid R_ARROW vid KW_SET update_list when_clause yield_clause
	| KW_UPDATE KW_EDGE KW_ON name_label vid R_ARROW vid AT rank KW_SET update_list when_clause yield_clause
	| KW_UPSERT KW_EDGE KW_ON name_label vid R_ARROW vid AT rank KW_SET update_list when_clause yield_clause
	;

delete_vertex_sentence :
	KW_DELETE KW_VERTEX vid_list
	| KW_DELETE KW_VERTEX vid_ref_expression
	| KW_DELETE KW_VERTEX delete_vertex_with_edge_sentence
	;

delete_vertex_with_edge_sentence :
	vid_list KW_WITH KW_EDGE
	| vid_ref_expression KW_WITH KW_EDGE
	;

delete_tag_sentence :
	KW_DELETE KW_TAG name_label_list KW_FROM vid_list
	| KW_DELETE KW_TAG STAR /*8L*/ KW_FROM vid_list
	| KW_DELETE KW_TAG name_label_list KW_FROM vid_ref_expression
	| KW_DELETE KW_TAG STAR /*8L*/ KW_FROM vid_ref_expression
	;

download_sentence :
	KW_DOWNLOAD KW_HDFS STRING
	;

ingest_sentence :
	KW_INGEST
	;

delete_edge_sentence :
	KW_DELETE KW_EDGE name_label edge_keys
	| KW_DELETE KW_EDGE name_label edge_key_ref
	;

admin_job_sentence :
	KW_SUBMIT KW_JOB KW_COMPACT
	| KW_SUBMIT KW_JOB KW_FLUSH
	| KW_SUBMIT KW_JOB KW_DOWNLOAD KW_HDFS STRING
	| KW_SUBMIT KW_JOB KW_INGEST
	| KW_SUBMIT KW_JOB KW_STATS
	| KW_SHOW KW_JOBS
	| KW_SHOW KW_JOB legal_integer
	| KW_STOP KW_JOB legal_integer
	| KW_RECOVER KW_JOB
	| KW_RECOVER KW_JOB integer_list
	| KW_SUBMIT KW_JOB KW_BALANCE KW_LEADER
	| KW_SUBMIT KW_JOB KW_BALANCE KW_DATA
	| KW_SUBMIT KW_JOB KW_BALANCE KW_DATA KW_REMOVE host_list
	;

show_queries_sentence :
	KW_SHOW KW_LOCAL KW_QUERIES
	| KW_SHOW KW_QUERIES
	;

show_sentence :
	KW_SHOW KW_HOSTS
	| KW_SHOW KW_HOSTS list_host_type
	| KW_SHOW KW_SPACES
	| KW_SHOW KW_PARTS
	| KW_SHOW KW_PART integer_list
	| KW_SHOW KW_PARTS integer_list
	| KW_SHOW KW_TAGS
	| KW_SHOW KW_EDGES
	| KW_SHOW KW_TAG KW_INDEXES
	| KW_SHOW KW_TAG KW_INDEXES KW_BY name_label
	| KW_SHOW KW_EDGE KW_INDEXES
	| KW_SHOW KW_EDGE KW_INDEXES KW_BY name_label
	| KW_SHOW KW_USERS
	| KW_SHOW KW_ROLES KW_IN /*5L*/ name_label
	| KW_SHOW KW_CONFIGS show_config_item
	| KW_SHOW KW_CREATE KW_SPACE name_label
	| KW_SHOW KW_CREATE KW_TAG name_label
	| KW_SHOW KW_CREATE KW_TAG KW_INDEX name_label
	| KW_SHOW KW_CREATE KW_EDGE name_label
	| KW_SHOW KW_CREATE KW_EDGE KW_INDEX name_label
	| KW_SHOW KW_TAG KW_INDEX KW_STATUS
	| KW_SHOW KW_EDGE KW_INDEX KW_STATUS
	| KW_SHOW KW_SNAPSHOTS
	| KW_SHOW KW_CHARSET
	| KW_SHOW KW_COLLATION
	| KW_SHOW KW_ZONES
	| KW_SHOW KW_STATS
	| KW_SHOW KW_TEXT KW_SEARCH KW_CLIENTS
	| KW_SHOW KW_FULLTEXT KW_INDEXES
	| KW_SHOW KW_SESSIONS
	| KW_SHOW KW_LOCAL KW_SESSIONS
	| KW_SHOW KW_SESSION legal_integer
	| KW_SHOW KW_META KW_LEADER
	;

list_host_type :
	KW_GRAPH
	| KW_META
	| KW_STORAGE
	| KW_AGENT
	| KW_STORAGE KW_LISTENER
	;

config_module_enum :
	KW_GRAPH
	| KW_META
	| KW_STORAGE
	;

get_config_item :
	config_module_enum COLON /*1L*/ name_label
	| name_label
	;

set_config_item :
	config_module_enum COLON /*1L*/ name_label ASSIGN expression
	| name_label ASSIGN expression
	| config_module_enum COLON /*1L*/ name_label ASSIGN L_BRACE /*11N*/ update_list R_BRACE
	| name_label ASSIGN L_BRACE /*11N*/ update_list R_BRACE
	;

show_config_item :
	/*empty*/
	| config_module_enum
	;

zone_name_list :
	name_label
	| zone_name_list COMMA name_label
	;

alter_space_sentence :
	KW_ALTER KW_SPACE name_label KW_ADD KW_ZONE name_label_list
	;

create_space_sentence :
	KW_CREATE KW_SPACE opt_if_not_exists name_label
	| KW_CREATE KW_SPACE opt_if_not_exists name_label comment_prop_assignment
	| KW_CREATE KW_SPACE opt_if_not_exists name_label KW_ON zone_name_list
	| KW_CREATE KW_SPACE opt_if_not_exists name_label KW_ON zone_name_list comment_prop_assignment
	| KW_CREATE KW_SPACE opt_if_not_exists name_label L_PAREN space_opt_list R_PAREN
	| KW_CREATE KW_SPACE opt_if_not_exists name_label L_PAREN space_opt_list R_PAREN comment_prop_assignment
	| KW_CREATE KW_SPACE opt_if_not_exists name_label L_PAREN space_opt_list R_PAREN KW_ON zone_name_list
	| KW_CREATE KW_SPACE opt_if_not_exists name_label L_PAREN space_opt_list R_PAREN KW_ON zone_name_list comment_prop_assignment
	| KW_CREATE KW_SPACE opt_if_not_exists name_label KW_AS name_label
	;

describe_space_sentence :
	KW_DESCRIBE KW_SPACE name_label
	| KW_DESC KW_SPACE name_label
	;

space_opt_list :
	space_opt_item
	| space_opt_list COMMA space_opt_item
	| space_opt_list COMMA
	;

space_opt_item :
	KW_PARTITION_NUM ASSIGN legal_integer
	| KW_REPLICA_FACTOR ASSIGN legal_integer
	| KW_CHARSET ASSIGN name_label
	| KW_COLLATE ASSIGN name_label
	| KW_VID_TYPE ASSIGN type_spec
	;

drop_space_sentence :
	KW_DROP KW_SPACE opt_if_exists name_label
	;

clear_space_sentence :
	KW_CLEAR KW_SPACE opt_if_exists name_label
	;

create_user_sentence :
	KW_CREATE KW_USER opt_if_not_exists name_label KW_WITH KW_PASSWORD STRING
	| KW_CREATE KW_USER opt_if_not_exists name_label
	;

alter_user_sentence :
	KW_ALTER KW_USER name_label KW_WITH KW_PASSWORD STRING
	;

drop_user_sentence :
	KW_DROP KW_USER opt_if_exists name_label
	;

change_password_sentence :
	KW_CHANGE KW_PASSWORD name_label KW_FROM STRING KW_TO STRING
	;

role_type_clause :
	KW_GOD
	| KW_ADMIN
	| KW_DBA
	| KW_USER
	| KW_GUEST
	;

acl_item_clause :
	KW_ROLE role_type_clause KW_ON name_label
	| role_type_clause KW_ON name_label
	;

grant_sentence :
	KW_GRANT acl_item_clause KW_TO name_label
	;

revoke_sentence :
	KW_REVOKE acl_item_clause KW_FROM name_label
	;

get_config_sentence :
	KW_GET KW_CONFIGS get_config_item
	;

set_config_sentence :
	KW_UPDATE KW_CONFIGS set_config_item
	;

host_list :
	host_item
	| host_list COMMA host_item
	| host_list COMMA
	;

host_item :
	IPV4 COLON /*1L*/ port
	| STRING COLON /*1L*/ port
	;

port :
	INTEGER
	;

integer_list :
	legal_integer
	| integer_list COMMA INTEGER
	| integer_list COMMA
	;

balance_sentence :
	KW_BALANCE KW_LEADER
	| KW_BALANCE KW_DATA
	| KW_BALANCE KW_DATA KW_REMOVE host_list
	;

create_snapshot_sentence :
	KW_CREATE KW_SNAPSHOT
	;

drop_snapshot_sentence :
	KW_DROP KW_SNAPSHOT name_label
	;

add_listener_sentence :
	KW_ADD KW_LISTENER KW_ELASTICSEARCH host_list
	;

remove_listener_sentence :
	KW_REMOVE KW_LISTENER KW_ELASTICSEARCH
	;

list_listener_sentence :
	KW_SHOW KW_LISTENER
	;

kill_query_sentence :
	KW_KILL KW_QUERY L_PAREN query_unique_identifier R_PAREN
	;

kill_session_sentence :
	KW_KILL KW_SESSIONS expression
	| KW_KILL KW_SESSION expression
	;

query_unique_identifier_value :
	legal_integer
	| input_prop_expression
	;

query_unique_identifier :
	KW_PLAN ASSIGN query_unique_identifier_value
	| KW_SESSION ASSIGN query_unique_identifier_value COMMA KW_PLAN ASSIGN query_unique_identifier_value
	| KW_PLAN ASSIGN query_unique_identifier_value COMMA KW_SESSION ASSIGN query_unique_identifier_value
	;

mutate_sentence :
	insert_vertex_sentence
	| insert_edge_sentence
	| update_vertex_sentence
	| update_edge_sentence
	| download_sentence
	| ingest_sentence
	| admin_job_sentence
	;

maintain_sentence :
	create_space_sentence
	| describe_space_sentence
	| alter_space_sentence
	| drop_space_sentence
	| clear_space_sentence
	| create_tag_sentence
	| create_edge_sentence
	| alter_tag_sentence
	| alter_edge_sentence
	| describe_tag_sentence
	| describe_edge_sentence
	| drop_tag_sentence
	| drop_edge_sentence
	| create_tag_index_sentence
	| create_edge_index_sentence
	| create_fulltext_index_sentence
	| drop_tag_index_sentence
	| drop_edge_index_sentence
	| drop_fulltext_index_sentence
	| describe_tag_index_sentence
	| describe_edge_index_sentence
	| rebuild_tag_index_sentence
	| rebuild_edge_index_sentence
	| rebuild_fulltext_index_sentence
	| add_hosts_sentence
	| drop_hosts_sentence
	| merge_zone_sentence
	| drop_zone_sentence
	| divide_zone_sentence
	| rename_zone_sentence
	| desc_zone_sentence
	| create_user_sentence
	| alter_user_sentence
	| drop_user_sentence
	| change_password_sentence
	| grant_sentence
	| revoke_sentence
	| get_config_sentence
	| set_config_sentence
	| balance_sentence
	| add_listener_sentence
	| remove_listener_sentence
	| list_listener_sentence
	| create_snapshot_sentence
	| drop_snapshot_sentence
	| sign_in_service_sentence
	| sign_out_service_sentence
	;

sentence :
	maintain_sentence
	| use_sentence
	| set_sentence
	| assignment_sentence
	| mutate_sentence
	| match_sentences
	;

seq_sentences :
	sentence
	| seq_sentences SEMICOLON sentence
	| seq_sentences SEMICOLON
	| /*empty*/
	;

explain_sentence :
	KW_EXPLAIN sentence
	| KW_EXPLAIN KW_FORMAT ASSIGN STRING sentence
	| KW_EXPLAIN L_BRACE /*11N*/ seq_sentences R_BRACE
	| KW_EXPLAIN KW_FORMAT ASSIGN STRING L_BRACE /*11N*/ seq_sentences R_BRACE
	| KW_PROFILE sentence
	| KW_PROFILE KW_FORMAT ASSIGN STRING sentence
	| KW_PROFILE L_BRACE /*11N*/ seq_sentences R_BRACE
	| KW_PROFILE KW_FORMAT ASSIGN STRING L_BRACE /*11N*/ seq_sentences R_BRACE
	| explain_sentence SEMICOLON
	;

sentences :
	seq_sentences
	| explain_sentence
	;

%%

nbsp                        (\xc2\xa0)
blank_without_newline       ([ \t\r]|{nbsp})
blank                       ({blank_without_newline}|[\n])

blanks                      ({blank}+)

NOT_IN                      (NOT{blanks}IN)
NOT_CONTAINS                (NOT{blanks}CONTAINS)
STARTS_WITH                 (STARTS{blanks}WITH)
NOT_STARTS_WITH             (NOT{blanks}STARTS{blanks}WITH)
ENDS_WITH                   (ENDS{blanks}WITH)
NOT_ENDS_WITH               (NOT{blanks}ENDS{blanks}WITH)
IS_NULL                     (IS{blanks}NULL)
IS_NOT_NULL                 (IS{blanks}NOT{blanks}NULL)
IS_EMPTY                    (IS{blanks}EMPTY)
IS_NOT_EMPTY                (IS{blanks}NOT{blanks}EMPTY)

DEC                         ([0-9])
EXP                         ([eE][-+]?[0-9]+)
HEX                         ([0-9a-fA-F])
OCT                         ([0-7])
IP_OCTET                    ([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])

U                           [\x80-\x9f\xa1-\xbf]
UA0                         \xa0
U2                          [\xc3-\xdf]
UC2                         \xc2
U3                          [\xe0-\xee]
U4                          [\xf0-\xf4]
CHINESE                     {U2}{UA0}|{UC2}{U}|{U2}{U}|{U3}{U}{U}|{U4}{U}{U}{U}
CN_EN                       {CHINESE}|[a-zA-Z]
CN_EN_NUM                   {CHINESE}|[_a-zA-Z0-9]
LABEL                       {CN_EN}{CN_EN_NUM}*

U3_FULL_WIDTH               [\xe0-\xef]
CHINESE_FULL_WIDTH          {U2}{UA0}|{UC2}{U}|{U2}{U}|{U3_FULL_WIDTH}{U}{U}|{U4}{U}{U}{U}
CN_EN_FULL_WIDTH            {CHINESE_FULL_WIDTH}|[a-zA-Z]
CN_EN_NUM_FULL_WIDTH        {CHINESE_FULL_WIDTH}|[_a-zA-Z0-9 ]
LABEL_FULL_WIDTH            {CN_EN_FULL_WIDTH}{CN_EN_NUM_FULL_WIDTH}*

%%

/* Flex rules section */
 /* How Does the input is matched?
  * When the generated scanner is run, it analyzes its input looking for strings which match any of its patterns.
  * 1. If it finds more than one match, it takes the one matching the most text.
  * 2. If it finds two or more matches of the same length, the rule listed first in the flex input file is chosen.
  * Once the match is determined, the text corresponding to the match is made available in the global character pointer yytext, and its length in the global integer yyleng.
  * The action corresponding to the matched pattern is then executed, and then the remaining input is scanned for another match.
  * The last rule `.` could match any single character except `\n`.
  */
 /* Reserved keyword */
"GO"                        KW_GO
"AS"                        KW_AS
"TO"                        KW_TO
"OR"                        KW_OR
"AND"                       KW_AND
"XOR"                       KW_XOR
"USE"                       KW_USE
"SET"                       KW_SET
"LIST"                      KW_LIST
"MAP"                       KW_MAP
"FROM"                      KW_FROM
"WHERE"                     KW_WHERE
"MATCH"                     KW_MATCH
"INSERT"                    KW_INSERT
"YIELD"                     KW_YIELD
"RETURN"                    KW_RETURN
"DESCRIBE"                  KW_DESCRIBE
"DESC"                      KW_DESC
"VERTEX"                    KW_VERTEX
"VERTICES"                  KW_VERTICES
"EDGE"                      KW_EDGE
"EDGES"                     KW_EDGES
"UPDATE"                    KW_UPDATE
"UPSERT"                    KW_UPSERT
"WHEN"                      KW_WHEN
"DELETE"                    KW_DELETE
"FIND"                      KW_FIND
"PATH"                      KW_PATH
"LOOKUP"                    KW_LOOKUP
"ALTER"                     KW_ALTER
"STEPS"                     KW_STEPS
"STEP"                      KW_STEPS
"OVER"                      KW_OVER
"UPTO"                      KW_UPTO
"REVERSELY"                 KW_REVERSELY
"INDEX"                     KW_INDEX
"INDEXES"                   KW_INDEXES
"REBUILD"                   KW_REBUILD
"BOOL"                      KW_BOOL
"INT8"                      KW_INT8
"INT16"                     KW_INT16
"INT32"                     KW_INT32
"INT64"                     KW_INT64
"INT"                       KW_INT
"FLOAT"                     KW_FLOAT
"DOUBLE"                    KW_DOUBLE
"STRING"                    KW_STRING
"FIXED_STRING"              KW_FIXED_STRING
"TIMESTAMP"                 KW_TIMESTAMP
"DATE"                      KW_DATE
"TIME"                      KW_TIME
"DATETIME"                  KW_DATETIME
"TAG"                       KW_TAG
"TAGS"                      KW_TAGS
"UNION"                     KW_UNION
"INTERSECT"                 KW_INTERSECT
"MINUS"                     KW_MINUS
//"NO"                        KW_NO
//"OVERWRITE"                 KW_OVERWRITE
"SHOW"                      KW_SHOW
"ADD"                       KW_ADD
"CREATE"                    KW_CREATE
"DROP"                      KW_DROP
"REMOVE"                    KW_REMOVE
"IF"                        KW_IF
"NOT"                       KW_NOT
"EXISTS"                    KW_EXISTS
"IGNORE_EXISTED_INDEX"      KW_IGNORE_EXISTED_INDEX
"WITH"                      KW_WITH
"CHANGE"                    KW_CHANGE
"GRANT"                     KW_GRANT
"REVOKE"                    KW_REVOKE
"ON"                        KW_ON
"BY"                        KW_BY
"IN"                        KW_IN
{NOT_IN}                    KW_NOT_IN
"DOWNLOAD"                  KW_DOWNLOAD
"GET"                       KW_GET
"OF"                        KW_OF
"ORDER"                     KW_ORDER
"INGEST"                    KW_INGEST
"COMPACT"                   KW_COMPACT
"FLUSH"                     KW_FLUSH
"SUBMIT"                    KW_SUBMIT
"ASC"                       KW_ASC
"ASCENDING"                 KW_ASCENDING
"DESCENDING"                KW_DESCENDING
"DISTINCT"                  KW_DISTINCT
"FETCH"                     KW_FETCH
"PROP"                      KW_PROP
"BALANCE"                   KW_BALANCE
"STOP"                      KW_STOP
"LIMIT"                     KW_LIMIT
"OFFSET"                    KW_OFFSET
//"IS"                        KW_IS
"NULL"                      KW_NULL
"RECOVER"                   KW_RECOVER
"EXPLAIN"                   KW_EXPLAIN
"PROFILE"                   KW_PROFILE
"FORMAT"                    KW_FORMAT
"CASE"                      KW_CASE
//"ACROSS"                    KW_ACROSS
"JOIN"                      KW_JOIN
"LEFT"                      KW_LEFT
"RIGHT"                     KW_RIGHT
"INNER"                     KW_INNER
"OUTER"                     KW_OUTER
"SEMI"                      KW_SEMI
"ANTI"                      KW_ANTI

 /**
  * TODO(dutor) Manage the dynamic allocated objects with an object pool,
  *     so that we ease the operations such as expression rewriting, associating
  *     the original text for an unreserved keywords, etc.
  *
  */
 /* Unreserved keyword */
"HOST"                      KW_HOST
"HOSTS"                     KW_HOSTS
"SPACE"                     KW_SPACE
"SPACES"                    KW_SPACES
"VALUE"                     KW_VALUE
"VALUES"                    KW_VALUES
"USER"                      KW_USER
"USERS"                     KW_USERS
"PASSWORD"                  KW_PASSWORD
"ROLE"                      KW_ROLE
"ROLES"                     KW_ROLES
"GOD"                       KW_GOD
"ADMIN"                     KW_ADMIN
"DBA"                       KW_DBA
"GUEST"                     KW_GUEST
"GROUP"                     KW_GROUP
"PARTITION_NUM"             KW_PARTITION_NUM
"REPLICA_FACTOR"            KW_REPLICA_FACTOR
"VID_TYPE"                  KW_VID_TYPE
"CHARSET"                   KW_CHARSET
"COLLATE"                   KW_COLLATE
"COLLATION"                 KW_COLLATION
"ATOMIC_EDGE"               KW_ATOMIC_EDGE
"ALL"                       KW_ALL
"ANY"                       KW_ANY
"SINGLE"                    KW_SINGLE
"NONE"                      KW_NONE
"REDUCE"                    KW_REDUCE
"LEADER"                    KW_LEADER
"UUID"                      KW_UUID
"DATA"                      KW_DATA
"SNAPSHOT"                  KW_SNAPSHOT
"SNAPSHOTS"                 KW_SNAPSHOTS
"ACCOUNT"                   KW_ACCOUNT
"JOBS"                      KW_JOBS
"JOB"                       KW_JOB
"BIDIRECT"                  KW_BIDIRECT
"STATS"                     KW_STATS
"STATUS"                    KW_STATUS
"FORCE"                     KW_FORCE
"PART"                      KW_PART
"PARTS"                     KW_PARTS
"DEFAULT"                   KW_DEFAULT
"HDFS"                      KW_HDFS
"CONFIGS"                   KW_CONFIGS
"TTL_DURATION"              KW_TTL_DURATION
"TTL_COL"                   KW_TTL_COL
"GRAPH"                     KW_GRAPH
"META"                      KW_META
"AGENT"                     KW_AGENT
"STORAGE"                   KW_STORAGE
"SHORTEST"                  KW_SHORTEST
"NOLOOP"                    KW_NOLOOP
"SHORTESTPATH"              KW_SHORTESTPATH
"AllSHORTESTPATHS"          KW_ALLSHORTESTPATHS
"OUT"                       KW_OUT
"BOTH"                      KW_BOTH
"SUBGRAPH"                  KW_SUBGRAPH
"CONTAINS"                  KW_CONTAINS
{NOT_CONTAINS}              KW_NOT_CONTAINS
"STARTS"                    KW_STARTS
{STARTS_WITH}               KW_STARTS_WITH
{NOT_STARTS_WITH}           KW_NOT_STARTS_WITH
"ENDS"                      KW_ENDS
{ENDS_WITH}                 KW_ENDS_WITH
{NOT_ENDS_WITH}             KW_NOT_ENDS_WITH
{IS_NULL}                   KW_IS_NULL
{IS_NOT_NULL}               KW_IS_NOT_NULL
{IS_EMPTY}                  KW_IS_EMPTY
{IS_NOT_EMPTY}              KW_IS_NOT_EMPTY
"UNWIND"                    KW_UNWIND
"SKIP"                      KW_SKIP
"OPTIONAL"                  KW_OPTIONAL
"THEN"                      KW_THEN
"ELSE"                      KW_ELSE
"END"                       KW_END
"GROUPS"                    KW_GROUPS
"ZONE"                      KW_ZONE
"ZONES"                     KW_ZONES
"INTO"                      KW_INTO
"NEW"                       KW_NEW
"LISTENER"                  KW_LISTENER
"ELASTICSEARCH"             KW_ELASTICSEARCH
"HTTP"                      KW_HTTP
"HTTPS"                     KW_HTTPS
"FULLTEXT"                  KW_FULLTEXT
"ANALYZER"                  KW_ANALYZER
"AUTO"                      KW_AUTO
"ES_QUERY"                  KW_ES_QUERY
"TEXT"                      KW_TEXT
"SEARCH"                    KW_SEARCH
"CLIENTS"                   KW_CLIENTS
"SIGN"                      KW_SIGN
"SERVICE"                   KW_SERVICE
"TEXT_SEARCH"               KW_TEXT_SEARCH
"RESET"                     KW_RESET
"PLAN"                      KW_PLAN
"COMMENT"                   KW_COMMENT
"S2_MAX_LEVEL"              KW_S2_MAX_LEVEL
"S2_MAX_CELLS"              KW_S2_MAX_CELLS
"LOCAL"                     KW_LOCAL
"SESSIONS"                  KW_SESSIONS
"SESSION"                   KW_SESSION
"SAMPLE"                    KW_SAMPLE
"QUERIES"                   KW_QUERIES
"QUERY"                     KW_QUERY
"KILL"                      KW_KILL
"TOP"                       KW_TOP
"GEOGRAPHY"                 KW_GEOGRAPHY
"POINT"                     KW_POINT
"LINESTRING"                KW_LINESTRING
"POLYGON"                   KW_POLYGON
"DURATION"                  KW_DURATION
"MERGE"                     KW_MERGE
"RENAME"                    KW_RENAME
"DIVIDE"                    KW_DIVIDE
"CLEAR"                     KW_CLEAR

"TRUE"                      BOOL
"FALSE"                     BOOL

"."                         DOT
".."                        DOT_DOT
","                         COMMA
":"                         COLON
";"                         SEMICOLON
"@"                         AT
"?"                         QM

"+"                         PLUS
"-"                         MINUS
"*"                         STAR
"/"                         DIV
"%"                         MOD
"!"                         NOT

"<"                         LT
"<="                        LE
">"                         GT
">="                        GE
"=="                        EQ
"!="                        NE
"<>"                        NE
"=~"                        REG

"|"                         PIPE

"="                         ASSIGN

"("                         L_PAREN
")"                         R_PAREN
"["                         L_BRACKET
"]"                         R_BRACKET
"{"                         L_BRACE
"}"                         R_BRACE

//"<-"                        L_ARROW
"->"                        R_ARROW

"-["                        MINUS_L_BRACKET
"]-"                        R_BRACKET_MINUS
"<-["                       L_ARROW_L_BRACKET
"]->"                       R_BRACKET_R_ARROW
"--"                        MINUS_MINUS
"-->"                       MINUS_R_ARROW
"<--"                       L_ARROW_MINUS
"<-->"                      L_ARROW_R_ARROW

//"_id"                       ID_PROP
"_type"                     TYPE_PROP
"_src"                      SRC_ID_PROP
"_dst"                      DST_ID_PROP
"_rank"                     RANK_PROP
"$$"                        DST_REF
"$^"                        SRC_REF
"$-"                        INPUT_REF

{LABEL}                     LABEL
\`<LB_STR>
<LB_STR>\`<INITIAL>                 LABEL
{IP_OCTET}(\.{IP_OCTET}){3} IPV4
0[Xx]{HEX}+                 INTEGER
0{OCT}+                     INTEGER

{DEC}+\.\.                  INTEGER  // remove the extra counted column number
{DEC}+                      INTEGER

{DEC}*\.{DEC}+{EXP}?        DOUBLE
{DEC}+\.{DEC}*{EXP}?        DOUBLE
{DEC}+{EXP}                 DOUBLE

\${LABEL}                   VARIABLE


\"<DQ_STR>
\'<SQ_STR>
<DQ_STR>\"<INITIAL>                  STRING
<SQ_STR>\'<INITIAL>                  STRING
//<DQ_STR,SQ_STR,LB_STR><<EOF>>      throw GraphParser::syntax_error(*yylloc, "Unterminated string: ");

//<DQ_STR,SQ_STR,LB_STR>\n           { yyterminate()
<DQ_STR>[^\\\n\"]+<.>
<SQ_STR>[^\\\n\']+<.>
<LB_STR>[^\\\n\`\.]+<.>
<DQ_STR,SQ_STR,LB_STR>\\{OCT}{1,3}<.>
<DQ_STR,SQ_STR,LB_STR>\\{DEC}+<.>
<DQ_STR,SQ_STR,LB_STR>\\[uUxX]{HEX}{4}<.>
<DQ_STR,SQ_STR,LB_STR>\\n<.>
<DQ_STR,SQ_STR,LB_STR>\\t<.>
<DQ_STR,SQ_STR,LB_STR>\\r<.>
<DQ_STR,SQ_STR,LB_STR>\\b<.>
<DQ_STR,SQ_STR,LB_STR>\\f<.>
<DQ_STR,SQ_STR,LB_STR>\\(.|\n)<.>
//<DQ_STR,SQ_STR,LB_STR>\\           // This rule should have never been matched,

/* We use DOT to access property of entities, so it's meta character in this language.
  * Disable DOT in label to avoid mistakes in system and confusing to user.
  */
//<LB_STR>\.                  throw GraphParser::syntax_error(*yylloc, "Don't allow DOT in label:");


{blank_without_newline}     skip()
\n                          skip()
"#".*                      skip() // Skip the annotation
"//".*                     skip() // Skip the annotation
"--".*                     skip() // Skip the annotation
"/*"<COMMENT>
<COMMENT>"*/"<INITIAL>	skip()
<COMMENT>([^*]|\n)+|.   skip()
//<COMMENT><<EOF>>            throw GraphParser::syntax_error(*yylloc, "unterminated comment");

\`{LABEL_FULL_WIDTH}\`      LABEL
//.                           {
                                /**
                                 * Any other unmatched byte sequences will get us here,
                                 * including the non-ascii ones, which are negative
                                 * in terms of type of `signed char'. At the same time, because
                                 * Bison translates all negative tokens to EOF(i.e. YY_NULL),
                                 * so we have to cast illegal characters to type of `unsigned char'
                                 * This will make Bison receive an unknown token, which leads to
                                 * a syntax error.
                                 *
                                 * Please note that it is not Flex but Bison to regard illegal
                                 * characters as errors, in such case.
                                 */
                                //return static_cast<unsigned char>(yytext[0]);

                                /**
                                 * Alternatively, we could report illegal characters by
                                 * throwing a `syntax_error' exception.
                                 * In such a way, we could distinguish illegal characters
                                 * from normal syntax errors, but at cost of poor performance
                                 * incurred by the expensive exception handling.
                                 */
                                // throw GraphParser::syntax_error(*yylloc, "char illegal");
//                            }

%%
