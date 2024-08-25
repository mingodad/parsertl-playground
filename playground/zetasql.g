//From: https://github.com/google/zetasql/blob/194cd32b5d766d60e3ca442651d792c7fe54ea74/zetasql/parser/bison_parser.y
//
// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

// AMBIGUOUS CASES
// ===============
//
// AMBIGUOUS CASE 1: SAFE_CAST(...)
// --------------------------------
// The SAFE_CAST keyword is non-reserved and can be used as an identifier. This
// causes one shift/reduce conflict between keyword_as_identifier and the rule
// that starts with "SAFE_CAST" "(". It is resolved in favor of the SAFE_CAST(
// rule, which is the desired behavior.
//
//
// AMBIGUOUS CASE 2: CREATE TABLE FUNCTION
// ---------------------------------------
// ZetaSQL now supports statements of type CREATE TABLE FUNCTION <name> to
// generate new table-valued functions with user-defined names. It also
// supports statements of type CREATE TABLE <name> to generate tables. In the
// latter case, the table name can be any identifier, including FUNCTION, so
// the parser encounters a shift/reduce conflict when the CREATE TABLE FUNCTION
// tokens are pushed onto the stack. By default, the parser chooses to shift,
// favoring creating a new table-valued function. The user may workaround this
// limitation by surrounding the FUNCTION token in backticks.
// This case is responsible for 3 shift/reduce conflicts:
// 1. The separate parser rules for CREATE EXTERNAL TABLE and CREATE EXTERNAL
//    TABLE FUNCTION encounter a shift/reduce conflict.
// 2. The separate parser rules for CREATE TABLE AS and CREATE TABLE FUNCTION
//    encounter a shift/reduce confict.
// 3. The separate next_statement_kind rules for CREATE TABLE AS and CREATE
//    TABLE FUNCTION encounter a shift/reduce confict.
//
//
// AMBIGUOUS CASE 3: CREATE TABLE CONSTRAINTS
// ------------------------------------------
// The CREATE TABLE rules for the PRIMARY KEY and FOREIGN KEY constraints have
// 2 shift/reduce conflicts, one for each constraint. PRIMARY and FOREIGN can
// be used as keywords for constraint definitions and as identifiers for column
// names. Bison can either shift the PRIMARY or FOREIGN keywords and use them
// for constraint definitions, or it can reduce them as identifiers and use
// them for column definitions. By default Bison shifts them. If the next token
// is KEY, Bison proceeds to reduce table_constraint_definition; otherwise, it
// reduces PRIMARY or FOREIGN as identifier and proceeds to reduce
// table_column_definition. Note that this grammar reports a syntax error when
// using PRIMARY KEY or FOREIGN KEY as column definition name and type pairs.
//
// AMBIGUOUS CASE 4: REPLACE_FIELDS(...)
// --------------------------------
// The REPLACE_FIELDS keyword is non-reserved and can be used as an identifier.
// This causes a shift/reduce conflict between keyword_as_identifier and the
// rule that starts with "REPLACE_FIELDS" "(". It is resolved in favor of the
// REPLACE_FIELDS( rule, which is the desired behavior.
//
// AMBIGUOUS CASE 5: Procedure parameter list in CREATE PROCEDURE
// -------------------------------------------------------------
// With rule procedure_parameter being:
// [<mode>] <identifier> <type>
// Optional <mode> can be non-reserved word OUT or INOUT, which can also be
// used as <identifier>. This causes 4 shift/reduce conflicts:
//   ( OUT
//   ( INOUT
//   , OUT
//   , INOUT
// By default, Bison chooses to "shift" and always treat OUT/INOUT as <mode>.
// In order to use OUT/INOUT as identifier, it needs to be escaped with
// backticks.
//
// AMBIGUOUS CASE 6: CREATE TABLE GENERATED
// -------------------------------------------------------------
// The GENERATED keyword is non-reserved, so when a generated column is defined
// with "<name> [<type>] GENERATED AS ()", we have a shift/reduce conflict, not
// knowing whether the word GENERATED is an identifier from <type> or the
// keyword GENERATED because <type> is missing. By default, Bison chooses
// "shift", treating GENERATED as a keyword. To use it as an identifier, it
// needs to be escaped with backticks.
//
// AMBIGUOUS CASE 7: DESCRIPTOR(...)
// --------------------------------
// The DESCRIPTOR keyword is non-reserved and can be used as an identifier. This
// causes one shift/reduce conflict between keyword_as_identifier and the rule
// that starts with "DESCRIPTOR" "(". It is resolved in favor of DESCRIPTOR(
// rule, which is the desired behavior.
//
// AMBIGUOUS CASE 8: ANALYZE OPTIONS(...)
// --------------------------------
// The OPTIONS keyword is non-reserved and can be used as an identifier.
// This causes a shift/reduce conflict between keyword_as_identifier and the
// rule that starts with "ANALYZE"  "OPTIONS" "(". It is resolved in favor of
// the OPTIONS( rule, which is the desired behavior.
//
// AMBIGUOUS CASE 9: SELECT * FROM T QUALIFY
// --------------------------------
// The QUALIFY keyword is non-reserved and can be used as an identifier.
// This causes a shift/reduce conflict between keyword_as_identifier and the
// rule that starts with "QUALIFY". It is resolved in favor of the QUALIFY rule,
// which is the desired behavior. Currently this is only used to report
// error messages to user when QUALIFY clause is used without
// WHERE/GROUP BY/HAVING.
//
// AMBIGUOUS CASE 10: ALTER COLUMN
// --------------------------------
// Spanner DDL compatibility extensions provide support for Spanner flavor of
// ALTER COLUMN action, which expects full column definition instead of
// sub-action. Column type identifier in this definition causes 2 shift/reduce
// conflicts with
//   ALTER COLUMN... DROP DEFAULT
//   ALTER COLUMN... DROP NOT NULL actions
// In both cases when encountering DROP, bison might either choose to shift
// (e.g. interpret DROP as keyword and proceed with one of the 2 rules above),
// or reduce DROP as type identifier in Spanner-specific rule. Bison chooses to
// shift, which is a desired behavior.
//
// AMBIGUOUS CASE 11: SEQUENCE CLAMPED
// ----------------------------------
// MyFunction(SEQUENCE clamped)
// Resolve to a function call passing a SEQUENCE input argument type.
//
// MyFunction(sequence clamped between x and y)
// Resolve to a function call passing a column 'sequence' modified
// with "clamped between x and y".
//
// Bison favors reducing the 2nd form to an error, so we add a lexer rule to
// force SEQUENCE followed by clamped to resolve to an identifier.
// So bison still thinks there is a conflict but the lexer
// will _never_ produce:
// ... KW_SEQUENCE KW_CLAMPED ...
// it instead produces
// ... IDENTIFIER KW_CLAMPED
// Which will resolve toward the second form
// (sequence clamped between x and y) correctly, and the first form (
// sequence clamped) will result in an error.
//
// In other contexts, CLAMPED will also act as an identifier via the
// keyword_as_identifier rule.
//
// If the user wants to reference a sequence called 'clamped', they must
// identifier quote it (SEQUENCE `clamped`);
//
// Total expected shift/reduce conflicts as described above:
//   1: SAFE CAST
//   3: CREATE TABLE FUNCTION
//   2: CREATE TABLE CONSTRAINTS
//   1: REPLACE FIELDS
//   4: CREATE PROCEDURE
//   1: CREATE TABLE GENERATED
//   1: CREATE EXTERNAL TABLE FUNCTION
//   1: DESCRIPTOR
//   1: ANALYZE
//   5: QUALIFY
//   2: ALTER COLUMN
//   1: SUM(SEQUENCE CLAMPED BETWEEN x and y)
//%expect 23

/*Tokens*/
//%token BACKSLASH
%token BYTES_LITERAL
//%token COMMENT
//%token DECIMAL_INTEGER_LITERAL
//%token DOLLAR_SIGN
//%token EXP_IN_FLOAT_NO_SIGN
%token FLOATING_POINT_LITERAL
//%token HEX_INTEGER_LITERAL
%token IDENTIFIER
%token INTEGER_LITERAL
//%token INVALID_LITERAL_PRECEDING_IDENTIFIER_NO_SPACE
%token KW_ABORT
%token KW_ACCESS
%token KW_ACTION
%token KW_ADD
%token KW_ADD_ASSIGN
%token KW_AGGREGATE
%token KW_ALL
%token KW_ALTER
%token KW_ALWAYS
%token KW_ANALYZE
%token KW_AND
%token KW_ANY
%token KW_APPROX
%token KW_ARE
%token KW_ARRAY
%token KW_AS
%token KW_ASC
%token KW_ASSERT
%token KW_ASSERT_ROWS_MODIFIED
%token KW_AT
%token KW_BATCH
%token KW_BEGIN
%token KW_BETWEEN
%token KW_BIGDECIMAL
%token KW_BIGNUMERIC
%token KW_BREAK
%token KW_BY
%token KW_CALL
%token KW_CASCADE
%token KW_CASE
%token KW_CAST
%token KW_CHECK
%token KW_CLAMPED
%token KW_CLONE
%token KW_CLUSTER
%token KW_COLLATE
%token KW_COLUMN
%token KW_COLUMNS
%token KW_COMMIT
%token KW_CONCAT_OP
%token KW_CONNECTION
%token KW_CONSTANT
%token KW_CONSTRAINT
//%token KW_CONTAINS
%token KW_CONTINUE
%token KW_COPY
%token KW_CORRESPONDING
%token KW_CREATE
%token KW_CROSS
%token KW_CUBE
%token KW_CURRENT
//%token KW_CURRENT_DATETIME_FUNCTION
%token KW_CYCLE
%token KW_DATA
%token KW_DATABASE
%token KW_DATE
%token KW_DATETIME
%token KW_DECIMAL
%token KW_DECLARE
%token KW_DEFAULT
%token KW_DEFINE
%token KW_DEFINE_FOR_MACROS
%token KW_DEFINER
%token KW_DELETE
%token KW_DELETION
%token KW_DEPTH
%token KW_DESC
%token KW_DESCRIBE
%token KW_DESCRIPTOR
%token KW_DETERMINISTIC
%token KW_DISTINCT
%token KW_DO
%token KW_DOUBLE_AT
%token KW_DROP
%token KW_ELSE
%token KW_ELSEIF
%token KW_END
%token KW_ENFORCED
%token KW_ENUM
%token KW_ERROR
//%token KW_ESCAPE
%token KW_EXCEPT
%token KW_EXCEPT_IN_SET_OP
%token KW_EXCEPTION
%token KW_EXCLUDE
%token KW_EXECUTE
%token KW_EXISTS
%token KW_EXPLAIN
%token KW_EXPORT
%token KW_EXTEND
%token KW_EXTERNAL
%token KW_EXTRACT
%token KW_FALSE
//%token KW_FETCH
%token KW_FILES
%token KW_FILL
%token KW_FILTER
%token KW_FIRST
%token KW_FOLLOWING
%token KW_FOR
%token KW_FOREIGN
%token KW_FORMAT
%token KW_FROM
%token KW_FULL
%token KW_FULL_IN_SET_OP
%token KW_FUNCTION
%token KW_GENERATED
%token KW_GRAPH
%token KW_GRANT
%token KW_GREATER_EQUALS
%token KW_GROUP
%token KW_GROUPING
%token KW_GROUP_ROWS
//%token KW_GROUPS
%token KW_HASH
%token KW_HAVING
%token KW_HIDDEN
%token KW_IDENTITY
%token KW_IF
%token KW_IGNORE
%token KW_IMMEDIATE
%token KW_IMMUTABLE
%token KW_IMPORT
%token KW_IN
%token KW_INCLUDE
%token KW_INCREMENT
%token KW_INDEX
%token KW_INNER
%token KW_INOUT
%token KW_INPUT
%token KW_INSERT
%token KW_INTERLEAVE
%token KW_INTERSECT
%token KW_INTERVAL
%token KW_INTO
%token KW_INVOKER
%token KW_IS
%token KW_ISOLATION
%token KW_ITERATE
%token KW_JOIN
%token KW_JSON
%token KW_KEY
%token KW_LAMBDA_ARROW
%token KW_LANGUAGE
%token KW_LAST
//%token KW_LATERAL
%token KW_LEAVE
%token KW_LEFT
%token KW_LEFT_IN_SET_OP
%token KW_LESS_EQUALS
%token KW_LEVEL
%token KW_LIKE
%token KW_LIMIT
%token KW_LOAD
%token KW_LOOKUP
%token KW_LOOP
%token KW_MACRO
%token KW_MAP
%token KW_MATCH
%token KW_MATCHED
%token KW_MATCH_RECOGNIZE_NONRESERVED
%token KW_MATCH_RECOGNIZE_RESERVED
%token KW_MATERIALIZED
%token KW_MAX
%token KW_MAXVALUE
%token KW_MEASURES
%token KW_MERGE
%token KW_MESSAGE
%token KW_METADATA
%token KW_MIN
%token KW_MINVALUE
%token KW_MODEL
%token KW_MODULE
%token KW_NAMED_ARGUMENT_ASSIGNMENT
%token KW_NATURAL
%token KW_NEW
%token KW_NO
%token KW_NOT
%token KW_NOT_EQUALS_C_STYLE
%token KW_NOT_EQUALS_SQL_STYLE
%token KW_NOT_SPECIAL
%token KW_NULL
%token KW_NULL_FILTERED
%token KW_NULLS
%token KW_NUMERIC
%token KW_OF
%token KW_OFFSET
%token KW_ON
%token KW_ONLY
%token KW_OPEN_HINT
%token KW_OPEN_INTEGER_HINT
%token KW_OPTIONS
%token KW_OPTIONS_IN_SELECT_WITH_OPTIONS
%token KW_OR
%token KW_ORDER
%token KW_OUT
%token KW_OUTER
%token KW_OUTPUT
%token KW_OVER
%token KW_OVERWRITE
%token KW_PARENT
%token KW_PARTITION
%token KW_PARTITIONS
%token KW_PATTERN
%token KW_PERCENT
%token KW_PIPE
%token KW_PIVOT
%token KW_POLICIES
%token KW_POLICY
%token KW_PRECEDING
%token KW_PRIMARY
%token KW_PRIVATE
%token KW_PRIVILEGE
%token KW_PRIVILEGES
%token KW_PROCEDURE
%token KW_PROJECT
%token KW_PROTO
%token KW_PUBLIC
%token KW_QUALIFY_NONRESERVED
%token KW_QUALIFY_RESERVED
%token KW_RAISE
%token KW_RANGE
%token KW_READ
%token KW_RECURSIVE
%token KW_REFERENCES
%token KW_REMOTE
%token KW_REMOVE
%token KW_RENAME
%token KW_REPEAT
%token KW_REPEATABLE
%token KW_REPLACE
%token KW_REPLACE_AFTER_INSERT
%token KW_REPLACE_FIELDS
%token KW_REPLICA
%token KW_REPORT
%token KW_RESPECT
%token KW_RESTRICT
%token KW_RESTRICTION
%token KW_RETURN
%token KW_RETURNS
%token KW_REVOKE
%token KW_RIGHT
%token KW_ROLLBACK
%token KW_ROLLUP
%token KW_ROW
%token KW_ROWS
%token KW_RUN
%token KW_SAFE_CAST
%token KW_SCHEMA
%token KW_SEARCH
%token KW_SECURITY
%token KW_SELECT
%token KW_SEQUENCE
%token KW_SET
%token KW_SETS
%token KW_SHIFT_LEFT
%token KW_SHIFT_RIGHT
%token KW_SHOW
%token KW_SIMPLE
%token KW_SNAPSHOT
%token KW_SOME
%token KW_SOURCE
%token KW_SQL
%token KW_STABLE
%token KW_START
%token KW_STATIC_DESCRIBE
%token KW_STORED
%token KW_STORING
%token KW_STRICT
%token KW_STRUCT
%token KW_SUB_ASSIGN
%token KW_SYSTEM
%token KW_SYSTEM_TIME
%token KW_TABLE
%token KW_TABLES
%token KW_TABLESAMPLE
%token KW_TARGET
%token KW_TEMP
%token KW_TEMPORARY
%token KW_THEN
%token KW_TIME
%token KW_TIMESTAMP
%token KW_TO
%token KW_TRANSACTION
%token KW_TRANSFORM
//%token KW_TREAT
%token KW_TRUE
%token KW_TRUNCATE
%token KW_TYPE
%token KW_UNBOUNDED
%token KW_UNDROP
%token KW_UNION
%token KW_UNIQUE
%token KW_UNKNOWN
%token KW_UNNEST
%token KW_UNPIVOT
%token KW_UNTIL
%token KW_UPDATE
%token KW_UPDATE_AFTER_INSERT
%token KW_USING
%token KW_VALUE
%token KW_VALUES
%token KW_VECTOR
%token KW_VIEW
%token KW_VIEWS
%token KW_VOLATILE
%token KW_WEIGHT
%token KW_WHEN
%token KW_WHERE
%token KW_WHILE
%token KW_WINDOW
%token KW_WITH
//%token KW_WITHIN
%token KW_WITH_STARTING_WITH_EXPRESSION
%token KW_WITH_STARTING_WITH_GROUP_ROWS
%token KW_WRITE
%token KW_ZONE
//%token LB_BEGIN_AT_STATEMENT_START
//%token LB_CLOSE_TYPE_TEMPLATE
//%token LB_DOT_IN_PATH_EXPRESSION
//%token LB_END_OF_STATEMENT_LEVEL_HINT
//%token LB_EXPLAIN_SQL_STATEMENT
//%token LB_OPEN_NESTED_DML
//%token LB_OPEN_STATEMENT_BLOCK
//%token LB_OPEN_TYPE_TEMPLATE
//%token LB_WITH_IN_SELECT_WITH_OPTIONS
//%token MACRO_ARGUMENT_REFERENCE
%token MACRO_BODY_TOKEN
//%token MACRO_INVOCATION
%token MODE_EXPRESSION
%token MODE_NEXT_SCRIPT_STATEMENT
%token MODE_NEXT_STATEMENT
%token MODE_NEXT_STATEMENT_KIND
%token MODE_SCRIPT
%token MODE_STATEMENT
%token MODE_TYPE
%token OPEN_INTEGER_PREFIX_HINT
%token SCRIPT_LABEL
//%token SENTINEL_LB_TOKEN_END
//%token SENTINEL_LB_TOKEN_START
//%token SENTINEL_NONRESERVED_KW_END
//%token SENTINEL_NONRESERVED_KW_START
//%token SENTINEL_RESERVED_KW_END
//%token SENTINEL_RESERVED_KW_START
//%token STANDALONE_EXPONENT_SIGN
%token STRING_LITERAL

%left /*1*/ KW_OR
%left /*2*/ KW_AND
%precedence /*3*/ UNARY_NOT_PRECEDENCE
%nonassoc /*4*/ '=' KW_ADD_ASSIGN KW_SUB_ASSIGN KW_NOT_EQUALS_C_STYLE KW_NOT_EQUALS_SQL_STYLE '<' KW_LESS_EQUALS '>' KW_GREATER_EQUALS KW_LIKE KW_IN KW_DISTINCT KW_BETWEEN KW_IS KW_NOT_SPECIAL
%left /*5*/ '|'
%left /*6*/ '^'
%left /*7*/ '&'
%left /*8*/ KW_SHIFT_LEFT KW_SHIFT_RIGHT
%left /*9*/ '+' '-'
%left /*10*/ KW_CONCAT_OP
%left /*11*/ '*' '/'
%precedence /*12*/ UNARY_PRECEDENCE
%precedence /*13*/ DOUBLE_AT_PRECEDENCE
%left /*14*/ '(' '[' '.' PRIMARY_PRECEDENCE

%start start_mode

%%

start_mode :
	input
	| MODE_STATEMENT sql_statement
	| MODE_SCRIPT script
	| MODE_NEXT_STATEMENT next_statement
	| MODE_NEXT_SCRIPT_STATEMENT next_script_statement
	| MODE_NEXT_STATEMENT_KIND next_statement_kind
	| MODE_EXPRESSION expression
	| MODE_TYPE type
	;

//to parse multiple statements on the playground
input :
	unterminated_sql_statement ';'
	| input unterminated_sql_statement ';'
	;

opt_semicolon :
	';'
	| /*empty*/
	;

sql_statement :
	unterminated_sql_statement opt_semicolon
	;

next_script_statement :
	unterminated_statement ';'
	| unterminated_statement
	;

next_statement :
	unterminated_sql_statement ';'
	| unterminated_sql_statement
	;

pre_statement :
	/*empty*/
	;

unterminated_statement :
	pre_statement unterminated_sql_statement
	| pre_statement unterminated_script_statement
	;

statement_level_hint :
	hint
	;

unterminated_sql_statement :
	sql_statement_body
	| statement_level_hint sql_statement_body
	| KW_DEFINE KW_MACRO
	| statement_level_hint KW_DEFINE KW_MACRO
	| statement_level_hint KW_DEFINE_FOR_MACROS KW_MACRO
	;

unterminated_unlabeled_script_statement :
	begin_end_block
	| while_statement
	| loop_statement
	| repeat_statement
	| for_in_statement
	;

unterminated_script_statement :
	if_statement
	| case_statement
	| variable_declaration
	| break_statement
	| continue_statement
	| return_statement
	| raise_statement
	| unterminated_unlabeled_script_statement
	| label ':' unterminated_unlabeled_script_statement opt_identifier
	;

sql_statement_body :
	query_statement
	| alter_statement
	| analyze_statement
	| assert_statement
	| aux_load_data_statement
	| clone_data_statement
	| dml_statement
	| merge_statement
	| truncate_statement
	| begin_statement
	| set_statement
	| commit_statement
	| start_batch_statement
	| run_batch_statement
	| abort_batch_statement
	| create_constant_statement
	| create_connection_statement
	| create_database_statement
	| create_function_statement
	| create_procedure_statement
	| create_index_statement
	| create_privilege_restriction_statement
	| create_row_access_policy_statement
	| create_external_table_statement
	| create_external_table_function_statement
	| create_model_statement
	| create_schema_statement
	| create_external_schema_statement
	| create_snapshot_statement
	| create_table_function_statement
	| create_table_statement
	| create_view_statement
	| create_entity_statement
	| define_macro_statement
	| define_table_statement
	| describe_statement
	| execute_immediate
	| explain_statement
	| export_data_statement
	| export_model_statement
	| export_metadata_statement
	| grant_statement
	| rename_statement
	| revoke_statement
	| rollback_statement
	| show_statement
	| drop_all_row_access_policies_statement
	| drop_statement
	| call_statement
	| import_statement
	| module_statement
	| undrop_statement
	;

define_macro_statement :
	KW_DEFINE_FOR_MACROS KW_MACRO MACRO_BODY_TOKEN macro_body
	;

macro_body :
	/*empty*/
	| macro_token_list
	;

macro_token_list :
	MACRO_BODY_TOKEN
	| macro_token_list MACRO_BODY_TOKEN
	;

query_statement :
	query
	;

alter_action :
	KW_SET KW_OPTIONS options_list
	| KW_SET KW_AS generic_entity_body
	| KW_ADD table_constraint_spec
	| KW_ADD primary_key_spec
	| KW_ADD KW_CONSTRAINT opt_if_not_exists identifier primary_key_or_table_constraint_spec
	| KW_DROP KW_CONSTRAINT opt_if_exists identifier
	| KW_DROP KW_PRIMARY KW_KEY opt_if_exists
	| KW_ALTER KW_CONSTRAINT opt_if_exists identifier constraint_enforcement
	| KW_ALTER KW_CONSTRAINT opt_if_exists identifier KW_SET KW_OPTIONS options_list
	| KW_ADD KW_COLUMN opt_if_not_exists table_column_definition opt_column_position opt_fill_using_expression
	| KW_DROP KW_COLUMN opt_if_exists identifier
	| KW_RENAME KW_COLUMN opt_if_exists identifier KW_TO identifier
	| KW_ALTER KW_COLUMN opt_if_exists identifier KW_SET KW_DATA KW_TYPE field_schema
	| KW_ALTER KW_COLUMN opt_if_exists identifier KW_SET KW_OPTIONS options_list
	| KW_ALTER KW_COLUMN opt_if_exists identifier KW_SET KW_DEFAULT expression
	| KW_ALTER KW_COLUMN opt_if_exists identifier KW_DROP KW_DEFAULT
	| KW_ALTER KW_COLUMN opt_if_exists identifier KW_DROP KW_NOT KW_NULL
	| KW_ALTER KW_COLUMN opt_if_exists identifier KW_DROP KW_GENERATED
	| KW_RENAME KW_TO path_expression
	| KW_SET KW_DEFAULT collate_clause
	| KW_ADD KW_ROW KW_DELETION KW_POLICY opt_if_not_exists '(' /*14L*/ expression ')'
	| KW_REPLACE KW_ROW KW_DELETION KW_POLICY opt_if_exists '(' /*14L*/ expression ')'
	| KW_DROP KW_ROW KW_DELETION KW_POLICY opt_if_exists
	| KW_ALTER generic_sub_entity_type opt_if_exists identifier alter_action
	| KW_ADD generic_sub_entity_type opt_if_not_exists identifier opt_options_list
	| KW_DROP generic_sub_entity_type opt_if_exists identifier
	| spanner_alter_column_action
	| spanner_set_on_delete_action
	;

alter_action_list :
	alter_action
	| alter_action_list ',' alter_action
	;

privilege_restriction_alter_action :
	restrict_to_clause
	| KW_ADD opt_if_not_exists possibly_empty_grantee_list
	| KW_REMOVE opt_if_exists possibly_empty_grantee_list
	;

privilege_restriction_alter_action_list :
	privilege_restriction_alter_action
	| privilege_restriction_alter_action_list ',' privilege_restriction_alter_action
	;

row_access_policy_alter_action :
	grant_to_clause
	| KW_FILTER KW_USING '(' /*14L*/ expression ')'
	| KW_REVOKE KW_FROM '(' /*14L*/ grantee_list ')'
	| KW_REVOKE KW_FROM KW_ALL
	| KW_RENAME KW_TO identifier
	;

row_access_policy_alter_action_list :
	row_access_policy_alter_action
	| row_access_policy_alter_action_list ',' row_access_policy_alter_action
	;

schema_object_kind :
	KW_AGGREGATE KW_FUNCTION
	| KW_APPROX KW_VIEW
	| KW_CONNECTION
	| KW_CONSTANT
	| KW_DATABASE
	| KW_EXTERNAL table_or_table_function
	| KW_EXTERNAL KW_SCHEMA
	| KW_FUNCTION
	| KW_INDEX
	| KW_MATERIALIZED KW_VIEW
	| KW_MODEL
	| KW_PROCEDURE
	| KW_SCHEMA
	| KW_VIEW
	;

alter_statement :
	KW_ALTER table_or_table_function opt_if_exists maybe_dashed_path_expression alter_action_list
	| KW_ALTER schema_object_kind opt_if_exists path_expression alter_action_list
	| KW_ALTER generic_entity_type opt_if_exists path_expression alter_action_list
	| KW_ALTER generic_entity_type opt_if_exists alter_action_list
	| KW_ALTER KW_PRIVILEGE KW_RESTRICTION opt_if_exists KW_ON privilege_list KW_ON identifier path_expression privilege_restriction_alter_action_list
	| KW_ALTER KW_ROW KW_ACCESS KW_POLICY opt_if_exists identifier KW_ON path_expression row_access_policy_alter_action_list
	| KW_ALTER KW_ALL KW_ROW KW_ACCESS KW_POLICIES KW_ON path_expression row_access_policy_alter_action
	;

opt_input_output_clause :
	KW_INPUT table_element_list KW_OUTPUT table_element_list
	| /*empty*/
	;

opt_transform_clause :
	KW_TRANSFORM '(' /*14L*/ select_list ')'
	| /*empty*/
	;

assert_statement :
	KW_ASSERT expression opt_description
	;

opt_description :
	KW_AS string_literal
	| /*empty*/
	;

analyze_statement :
	KW_ANALYZE opt_options_list opt_table_and_column_info_list
	;

opt_table_and_column_info_list :
	table_and_column_info_list
	| /*empty*/
	;

table_and_column_info_list :
	table_and_column_info
	| table_and_column_info_list ',' table_and_column_info
	;

table_and_column_info :
	maybe_dashed_path_expression opt_column_list
	;

transaction_mode :
	KW_READ KW_ONLY
	| KW_READ KW_WRITE
	| KW_ISOLATION KW_LEVEL identifier
	| KW_ISOLATION KW_LEVEL identifier identifier
	;

transaction_mode_list :
	transaction_mode
	| transaction_mode_list ',' transaction_mode
	;

opt_transaction_mode_list :
	transaction_mode_list
	| /*empty*/
	;

begin_statement :
	begin_transaction_keywords opt_transaction_mode_list
	;

begin_transaction_keywords :
	KW_START transaction_keyword
	| KW_BEGIN opt_transaction_keyword
	;

transaction_keyword :
	KW_TRANSACTION
	;

opt_transaction_keyword :
	transaction_keyword
	| /*empty*/
	;

set_statement :
	KW_SET KW_TRANSACTION transaction_mode_list
	| KW_SET identifier '=' /*4N*/ expression
	| KW_SET named_parameter_expression '=' /*4N*/ expression
	| KW_SET system_variable_expression '=' /*4N*/ expression
	| KW_SET '(' /*14L*/ identifier_list ')' '=' /*4N*/ expression
	| KW_SET '(' /*14L*/ ')'
	| KW_SET identifier ',' identifier_list '=' /*4N*/
	;

commit_statement :
	KW_COMMIT opt_transaction_keyword
	;

rollback_statement :
	KW_ROLLBACK opt_transaction_keyword
	;

start_batch_statement :
	KW_START KW_BATCH opt_identifier
	;

run_batch_statement :
	KW_RUN KW_BATCH
	;

abort_batch_statement :
	KW_ABORT KW_BATCH
	;

create_constant_statement :
	KW_CREATE opt_or_replace opt_create_scope KW_CONSTANT opt_if_not_exists path_expression '=' /*4N*/ expression
	;

create_database_statement :
	KW_CREATE KW_DATABASE path_expression opt_options_list
	;

unordered_options_body :
	options opt_as_sql_function_body_or_string
	| as_sql_function_body_or_string opt_options_list
	| /*empty*/
	;

create_function_statement :
	KW_CREATE opt_or_replace opt_create_scope opt_aggregate KW_FUNCTION opt_if_not_exists function_declaration opt_function_returns opt_sql_security_clause opt_determinism_level opt_language_or_remote_with_connection unordered_options_body
	;

opt_aggregate :
	KW_AGGREGATE
	| /*empty*/
	;

opt_not_aggregate :
	KW_NOT KW_AGGREGATE
	| /*empty*/
	;

function_declaration :
	path_expression function_parameters
	;

function_parameter :
	identifier type_or_tvf_schema opt_as_alias_with_required_as opt_default_expression opt_not_aggregate
	| type_or_tvf_schema opt_as_alias_with_required_as opt_not_aggregate
	;

function_parameters_prefix :
	'(' /*14L*/ function_parameter
	| function_parameters_prefix ',' function_parameter
	;

function_parameters :
	function_parameters_prefix ')'
	| '(' /*14L*/ ')'
	;

begin_end_block_or_language_as_code :
	begin_end_block
	| KW_LANGUAGE identifier opt_as_code
	;

opt_external_security_clause :
	KW_EXTERNAL KW_SECURITY external_security_clause_kind
	| /*empty*/
	;

external_security_clause_kind :
	KW_INVOKER
	| KW_DEFINER
	;

create_procedure_statement :
	KW_CREATE opt_or_replace opt_create_scope KW_PROCEDURE opt_if_not_exists path_expression procedure_parameters opt_external_security_clause opt_with_connection_clause opt_options_list begin_end_block_or_language_as_code
	;

procedure_parameters_prefix :
	'(' /*14L*/ procedure_parameter
	| procedure_parameters_prefix ',' procedure_parameter
	;

procedure_parameters :
	procedure_parameters_prefix ')'
	| '(' /*14L*/ ')'
	;

procedure_parameter_termination :
	')'
	| ','
	;

procedure_parameter :
	opt_procedure_parameter_mode identifier type_or_tvf_schema
	| opt_procedure_parameter_mode identifier procedure_parameter_termination
	;

opt_procedure_parameter_mode :
	KW_IN /*4N*/
	| KW_OUT
	| KW_INOUT
	| /*empty*/
	;

opt_returns :
	KW_RETURNS type_or_tvf_schema
	| /*empty*/
	;

opt_function_returns :
	opt_returns
	;

opt_determinism_level :
	KW_DETERMINISTIC
	| KW_NOT KW_DETERMINISTIC
	| KW_IMMUTABLE
	| KW_STABLE
	| KW_VOLATILE
	| /*empty*/
	;

language :
	KW_LANGUAGE identifier
	;

opt_language :
	language
	| /*empty*/
	;

remote_with_connection_clause :
	KW_REMOTE opt_with_connection_clause
	| with_connection_clause
	;

opt_remote_with_connection_clause :
	remote_with_connection_clause
	| /*empty*/
	;

opt_language_or_remote_with_connection :
	KW_LANGUAGE identifier opt_remote_with_connection_clause
	| remote_with_connection_clause opt_language
	| /*empty*/
	;

opt_sql_security_clause :
	KW_SQL KW_SECURITY sql_security_clause_kind
	| /*empty*/
	;

sql_security_clause_kind :
	KW_INVOKER
	| KW_DEFINER
	;

as_sql_function_body_or_string :
	KW_AS sql_function_body
	| KW_AS string_literal
	;

opt_as_sql_function_body_or_string :
	as_sql_function_body_or_string
	| /*empty*/
	;

opt_as_code :
	KW_AS string_literal
	| /*empty*/
	;

path_expression_or_string :
	path_expression
	| string_literal
	;

path_expression_or_default :
	path_expression
	| KW_DEFAULT
	;

sql_function_body :
	'(' /*14L*/ expression ')'
	| '(' /*14L*/ KW_SELECT
	;

restrict_to_clause :
	KW_RESTRICT KW_TO possibly_empty_grantee_list
	;

opt_restrict_to_clause :
	restrict_to_clause
	| /*empty*/
	;

grant_to_clause :
	KW_GRANT KW_TO '(' /*14L*/ grantee_list ')'
	;

create_row_access_policy_grant_to_clause :
	grant_to_clause
	| KW_TO grantee_list
	;

opt_create_row_access_policy_grant_to_clause :
	create_row_access_policy_grant_to_clause
	| /*empty*/
	;

opt_filter :
	KW_FILTER
	| /*empty*/
	;

filter_using_clause :
	opt_filter KW_USING '(' /*14L*/ expression ')'
	;

create_privilege_restriction_statement :
	KW_CREATE opt_or_replace KW_PRIVILEGE KW_RESTRICTION opt_if_not_exists KW_ON privilege_list KW_ON identifier path_expression opt_restrict_to_clause
	;

create_row_access_policy_statement :
	KW_CREATE opt_or_replace KW_ROW opt_access KW_POLICY opt_if_not_exists opt_identifier KW_ON path_expression opt_create_row_access_policy_grant_to_clause filter_using_clause
	;

with_partition_columns_clause :
	KW_WITH KW_PARTITION KW_COLUMNS opt_table_element_list
	;

with_connection_clause :
	KW_WITH connection_clause
	;

opt_external_table_with_clauses :
	with_partition_columns_clause with_connection_clause
	| with_partition_columns_clause
	| with_connection_clause
	| /*empty*/
	;

create_external_table_statement :
	KW_CREATE opt_or_replace opt_create_scope KW_EXTERNAL KW_TABLE opt_if_not_exists maybe_dashed_path_expression opt_table_element_list opt_like_path_expression opt_default_collate_clause opt_external_table_with_clauses opt_options_list
	;

create_external_table_function_statement :
	KW_CREATE opt_or_replace opt_create_scope KW_EXTERNAL KW_TABLE KW_FUNCTION
	;

opt_create_index_statement_suffix :
	partition_by_clause_prefix_no_hint opt_options_list
	| opt_options_list spanner_index_interleave_clause
	| options
	| /*empty*/
	;

create_index_statement :
	KW_CREATE opt_or_replace opt_unique opt_spanner_null_filtered opt_index_type KW_INDEX opt_if_not_exists path_expression on_path_expression opt_as_alias opt_index_unnest_expression_list index_order_by_and_options opt_index_storing_list opt_create_index_statement_suffix
	;

create_schema_statement :
	KW_CREATE opt_or_replace KW_SCHEMA opt_if_not_exists path_expression opt_default_collate_clause opt_options_list
	;

create_external_schema_statement :
	KW_CREATE opt_or_replace opt_create_scope KW_EXTERNAL KW_SCHEMA opt_if_not_exists path_expression opt_with_connection_clause options
	;

create_connection_statement :
	KW_CREATE opt_or_replace KW_CONNECTION opt_if_not_exists path_expression opt_options_list
	;

undrop_statement :
	KW_UNDROP schema_object_kind opt_if_not_exists path_expression opt_at_system_time opt_options_list
	;

create_snapshot_statement :
	KW_CREATE opt_or_replace KW_SNAPSHOT KW_TABLE opt_if_not_exists maybe_dashed_path_expression KW_CLONE clone_data_source opt_options_list
	| KW_CREATE opt_or_replace KW_SNAPSHOT schema_object_kind opt_if_not_exists maybe_dashed_path_expression KW_CLONE clone_data_source opt_options_list
	;

unordered_language_options :
	language opt_options_list
	| options opt_language
	| /*empty*/
	;

create_table_function_statement :
	KW_CREATE opt_or_replace opt_create_scope KW_TABLE KW_FUNCTION opt_if_not_exists path_expression opt_function_parameters opt_returns opt_sql_security_clause unordered_language_options opt_as_query_or_string
	;

create_table_statement :
	KW_CREATE opt_or_replace opt_create_scope KW_TABLE opt_if_not_exists maybe_dashed_path_expression opt_table_element_list opt_spanner_table_options opt_like_path_expression opt_clone_table opt_copy_table opt_default_collate_clause opt_partition_by_clause_no_hint opt_cluster_by_clause_no_hint opt_ttl_clause opt_with_connection_clause opt_options_list opt_as_query
	;

append_or_overwrite :
	KW_INTO
	| KW_OVERWRITE
	;

aux_load_data_from_files_options_list :
	KW_FROM KW_FILES options_list
	;

opt_overwrite :
	KW_OVERWRITE
	| /*empty*/
	;

load_data_partitions_clause :
	opt_overwrite KW_PARTITIONS '(' /*14L*/ expression ')'
	;

opt_load_data_partitions_clause :
	load_data_partitions_clause
	| /*empty*/
	;

maybe_dashed_path_expression_with_scope :
	KW_TEMP KW_TABLE maybe_dashed_path_expression
	| KW_TEMPORARY KW_TABLE maybe_dashed_path_expression
	| maybe_dashed_path_expression
	;

aux_load_data_statement :
	KW_LOAD KW_DATA append_or_overwrite maybe_dashed_path_expression_with_scope opt_table_element_list opt_load_data_partitions_clause opt_collate_clause opt_partition_by_clause_no_hint opt_cluster_by_clause_no_hint opt_options_list aux_load_data_from_files_options_list opt_external_table_with_clauses
	;

generic_entity_type_unchecked :
	IDENTIFIER
	| KW_PROJECT
	;

generic_entity_type :
	generic_entity_type_unchecked
	;

sub_entity_type_identifier :
	IDENTIFIER
	| KW_REPLICA
	;

generic_sub_entity_type :
	sub_entity_type_identifier
	;

generic_entity_body :
	json_literal
	| string_literal
	;

opt_generic_entity_body :
	KW_AS generic_entity_body
	| /*empty*/
	;

create_entity_statement :
	KW_CREATE opt_or_replace generic_entity_type opt_if_not_exists path_expression opt_options_list opt_generic_entity_body
	;

create_model_statement :
	KW_CREATE opt_or_replace opt_create_scope KW_MODEL opt_if_not_exists path_expression opt_input_output_clause opt_transform_clause opt_remote_with_connection_clause opt_options_list opt_as_query_or_aliased_query_list
	;

opt_table_element_list :
	table_element_list
	| /*empty*/
	;

table_element_list :
	table_element_list_prefix ')'
	| '(' /*14L*/ ')'
	;

table_element_list_prefix :
	'(' /*14L*/ table_element
	| table_element_list_prefix ',' table_element
	| table_element_list_prefix ','
	;

table_element :
	table_column_definition
	| table_constraint_definition
	;

table_column_definition :
	identifier table_column_schema opt_column_attributes opt_options_list
	;

table_column_schema :
	column_schema_inner opt_collate_clause opt_column_info
	| generated_column_info
	;

simple_column_schema_inner :
	path_expression
	| KW_INTERVAL
	;

array_column_schema_inner :
	KW_ARRAY template_type_open field_schema template_type_close
	;

range_column_schema_inner :
	KW_RANGE template_type_open field_schema template_type_close
	;

struct_column_field :
	column_schema_inner opt_collate_clause opt_field_attributes
	| identifier field_schema
	;

struct_column_schema_prefix :
	KW_STRUCT template_type_open struct_column_field
	| struct_column_schema_prefix ',' struct_column_field
	;

struct_column_schema_inner :
	KW_STRUCT template_type_open template_type_close
	| struct_column_schema_prefix template_type_close
	;

raw_column_schema_inner :
	simple_column_schema_inner
	| array_column_schema_inner
	| struct_column_schema_inner
	| range_column_schema_inner
	;

column_schema_inner :
	raw_column_schema_inner opt_type_parameters
	;

generated_mode :
	KW_GENERATED KW_AS
	| KW_GENERATED KW_ALWAYS KW_AS
	| KW_GENERATED KW_BY KW_DEFAULT KW_AS
	| KW_AS
	;

stored_mode :
	KW_STORED KW_VOLATILE
	| KW_STORED
	| /*empty*/
	;

signed_numerical_literal :
	integer_literal
	| numeric_literal
	| bignumeric_literal
	| floating_point_literal
	| '-' /*9L*/ integer_literal
	| '-' /*9L*/ floating_point_literal
	;

opt_start_with :
	KW_START KW_WITH signed_numerical_literal
	| /*empty*/
	;

opt_increment_by :
	KW_INCREMENT KW_BY signed_numerical_literal
	| /*empty*/
	;

opt_maxvalue :
	KW_MAXVALUE signed_numerical_literal
	| /*empty*/
	;

opt_minvalue :
	KW_MINVALUE signed_numerical_literal
	| /*empty*/
	;

opt_cycle :
	KW_CYCLE
	| KW_NO KW_CYCLE
	| /*empty*/
	;

identity_column_info :
	KW_IDENTITY '(' /*14L*/ opt_start_with opt_increment_by opt_maxvalue opt_minvalue opt_cycle ')'
	;

generated_column_info :
	generated_mode '(' /*14L*/ expression ')' stored_mode
	| generated_mode identity_column_info
	;

invalid_generated_column :
	generated_column_info
	| /*empty*/
	;

default_column_info :
	KW_DEFAULT expression
	;

invalid_default_column :
	default_column_info
	| /*empty*/
	;

opt_column_info :
	generated_column_info invalid_default_column
	| default_column_info invalid_generated_column
	| /*empty*/
	;

field_schema :
	column_schema_inner opt_collate_clause opt_field_attributes opt_options_list
	;

primary_key_column_attribute :
	KW_PRIMARY KW_KEY
	;

foreign_key_column_attribute :
	opt_constraint_identity foreign_key_reference
	;

hidden_column_attribute :
	KW_HIDDEN
	;

not_null_column_attribute :
	KW_NOT KW_NULL
	;

column_attribute :
	primary_key_column_attribute
	| foreign_key_column_attribute
	| hidden_column_attribute
	| not_null_column_attribute
	;

column_attributes :
	column_attribute
	| column_attributes column_attribute
	| column_attributes constraint_enforcement
	;

opt_column_attributes :
	column_attributes
	| /*empty*/
	;

opt_field_attributes :
	not_null_column_attribute
	| /*empty*/
	;

column_position :
	KW_PRECEDING identifier
	| KW_FOLLOWING identifier
	;

opt_column_position :
	column_position
	| /*empty*/
	;

fill_using_expression :
	KW_FILL KW_USING expression
	;

opt_fill_using_expression :
	fill_using_expression
	| /*empty*/
	;

table_constraint_spec :
	KW_CHECK '(' /*14L*/ expression ')' opt_constraint_enforcement opt_options_list
	| KW_FOREIGN KW_KEY column_list foreign_key_reference opt_constraint_enforcement opt_options_list
	;

primary_key_element :
	identifier opt_asc_or_desc opt_null_order
	;

primary_key_element_list_prefix :
	'(' /*14L*/ primary_key_element
	| primary_key_element_list_prefix ',' primary_key_element
	;

primary_key_element_list :
	primary_key_element_list_prefix ')'
	| '(' /*14L*/ ')'
	;

primary_key_spec :
	KW_PRIMARY KW_KEY primary_key_element_list opt_constraint_enforcement opt_options_list
	;

primary_key_or_table_constraint_spec :
	primary_key_spec
	| table_constraint_spec
	;

table_constraint_definition :
	primary_key_spec
	| table_constraint_spec
	| identifier identifier table_constraint_spec
	;

foreign_key_reference :
	KW_REFERENCES path_expression column_list opt_foreign_key_match opt_foreign_key_actions
	;

opt_foreign_key_match :
	KW_MATCH foreign_key_match_mode
	| /*empty*/
	;

foreign_key_match_mode :
	KW_SIMPLE
	| KW_FULL
	| KW_NOT_SPECIAL /*4N*/ KW_DISTINCT /*4N*/
	;

opt_foreign_key_actions :
	foreign_key_on_update opt_foreign_key_on_delete
	| foreign_key_on_delete opt_foreign_key_on_update
	| /*empty*/
	;

opt_foreign_key_on_update :
	foreign_key_on_update
	| /*empty*/
	;

opt_foreign_key_on_delete :
	foreign_key_on_delete
	| /*empty*/
	;

foreign_key_on_update :
	KW_ON KW_UPDATE foreign_key_action
	;

foreign_key_on_delete :
	KW_ON KW_DELETE foreign_key_action
	;

foreign_key_action :
	KW_NO KW_ACTION
	| KW_RESTRICT
	| KW_CASCADE
	| KW_SET KW_NULL
	;

opt_constraint_identity :
	KW_CONSTRAINT identifier
	| /*empty*/
	;

opt_constraint_enforcement :
	constraint_enforcement
	| /*empty*/
	;

constraint_enforcement :
	KW_ENFORCED
	| KW_NOT KW_ENFORCED
	;

table_or_table_function :
	KW_TABLE KW_FUNCTION
	| KW_TABLE
	;

tvf_schema_column :
	identifier type
	| type
	;

tvf_schema_prefix :
	KW_TABLE template_type_open tvf_schema_column
	| tvf_schema_prefix ',' tvf_schema_column
	;

tvf_schema :
	tvf_schema_prefix template_type_close
	;

opt_recursive :
	KW_RECURSIVE
	| /*empty*/
	;

create_view_statement :
	KW_CREATE opt_or_replace opt_create_scope opt_recursive KW_VIEW opt_if_not_exists maybe_dashed_path_expression opt_column_with_options_list opt_sql_security_clause opt_options_list as_query
	| KW_CREATE opt_or_replace KW_MATERIALIZED opt_recursive KW_VIEW opt_if_not_exists maybe_dashed_path_expression opt_column_with_options_list opt_sql_security_clause opt_partition_by_clause_no_hint opt_cluster_by_clause_no_hint opt_options_list KW_AS query_or_replica_source
	| KW_CREATE opt_or_replace KW_APPROX opt_recursive KW_VIEW opt_if_not_exists maybe_dashed_path_expression opt_column_with_options_list opt_sql_security_clause opt_options_list as_query
	;

query_or_replica_source :
	query
	| KW_REPLICA KW_OF maybe_dashed_path_expression
	;

as_query :
	KW_AS query
	;

opt_as_query :
	as_query
	| /*empty*/
	;

opt_as_query_or_string :
	as_query
	| KW_AS string_literal
	| /*empty*/
	;

opt_as_query_or_aliased_query_list :
	as_query
	| KW_AS '(' /*14L*/ aliased_query_list ')'
	| /*empty*/
	;

opt_if_not_exists :
	KW_IF KW_NOT KW_EXISTS
	| /*empty*/
	;

describe_statement :
	describe_keyword describe_info
	;

describe_info :
	identifier maybe_slashed_or_dashed_path_expression opt_from_path_expression
	| maybe_slashed_or_dashed_path_expression opt_from_path_expression
	;

opt_from_path_expression :
	KW_FROM maybe_slashed_or_dashed_path_expression
	| /*empty*/
	;

explain_statement :
	KW_EXPLAIN unterminated_sql_statement
	;

export_data_statement :
	KW_EXPORT KW_DATA opt_with_connection_clause opt_options_list KW_AS query
	;

export_model_statement :
	KW_EXPORT KW_MODEL path_expression opt_with_connection_clause opt_options_list
	;

export_metadata_statement :
	KW_EXPORT table_or_table_function KW_METADATA KW_FROM maybe_dashed_path_expression opt_with_connection_clause opt_options_list
	;

grant_statement :
	KW_GRANT privileges KW_ON identifier path_expression KW_TO grantee_list
	| KW_GRANT privileges KW_ON identifier identifier path_expression KW_TO grantee_list
	| KW_GRANT privileges KW_ON path_expression KW_TO grantee_list
	;

revoke_statement :
	KW_REVOKE privileges KW_ON identifier path_expression KW_FROM grantee_list
	| KW_REVOKE privileges KW_ON identifier identifier path_expression KW_FROM grantee_list
	| KW_REVOKE privileges KW_ON path_expression KW_FROM grantee_list
	;

privileges :
	KW_ALL opt_privileges_keyword
	| privilege_list
	;

opt_privileges_keyword :
	KW_PRIVILEGES
	| /*empty*/
	;

privilege_list :
	privilege
	| privilege_list ',' privilege
	;

privilege :
	privilege_name opt_path_expression_list_with_parens
	;

privilege_name :
	identifier
	| KW_SELECT
	;

rename_statement :
	KW_RENAME identifier path_expression KW_TO path_expression
	;

import_statement :
	KW_IMPORT import_type path_expression_or_string opt_as_or_into_alias opt_options_list
	;

module_statement :
	KW_MODULE path_expression opt_options_list
	;

column_ordering_and_options_expr :
	expression opt_collate_clause opt_asc_or_desc opt_null_order opt_options_list
	;

index_order_by_and_options_prefix :
	'(' /*14L*/ column_ordering_and_options_expr
	| index_order_by_and_options_prefix ',' column_ordering_and_options_expr
	;

all_column_column_options :
	index_order_by_and_options_prefix ')'
	;

opt_with_column_options :
	KW_WITH KW_COLUMN KW_OPTIONS all_column_column_options
	| /*empty*/
	;

index_all_columns :
	'(' /*14L*/ KW_ALL KW_COLUMNS opt_with_column_options ')'
	;

index_order_by_and_options :
	index_order_by_and_options_prefix ')'
	| index_all_columns
	;

index_unnest_expression_list :
	unnest_expression_with_opt_alias_and_offset
	| index_unnest_expression_list unnest_expression_with_opt_alias_and_offset
	;

opt_index_unnest_expression_list :
	index_unnest_expression_list
	| /*empty*/
	;

index_storing_expression_list_prefix :
	'(' /*14L*/ expression
	| index_storing_expression_list_prefix ',' expression
	;

index_storing_expression_list :
	index_storing_expression_list_prefix ')'
	;

index_storing_list :
	KW_STORING index_storing_expression_list
	;

opt_index_storing_list :
	index_storing_list
	| /*empty*/
	;

column_list_prefix :
	'(' /*14L*/ identifier
	| column_list_prefix ',' identifier
	;

column_list :
	column_list_prefix ')'
	;

opt_column_list :
	column_list
	| /*empty*/
	;

column_with_options :
	identifier opt_options_list
	;

column_with_options_list_prefix :
	'(' /*14L*/ column_with_options
	| column_with_options_list_prefix ',' column_with_options
	;

column_with_options_list :
	column_with_options_list_prefix ')'
	;

opt_column_with_options_list :
	column_with_options_list
	| /*empty*/
	;

grantee_list :
	string_literal_or_parameter
	| grantee_list ',' string_literal_or_parameter
	;

grantee_list_with_parens_prefix :
	'(' /*14L*/ string_literal_or_parameter
	| grantee_list_with_parens_prefix ',' string_literal_or_parameter
	;

possibly_empty_grantee_list :
	grantee_list_with_parens_prefix ')'
	| '(' /*14L*/ ')'
	;

show_statement :
	KW_SHOW show_target opt_from_path_expression opt_like_string_literal
	;

show_target :
	KW_MATERIALIZED KW_VIEWS
	| identifier
	;

opt_like_string_literal :
	KW_LIKE /*4N*/ string_literal
	| /*empty*/
	;

opt_like_path_expression :
	KW_LIKE /*4N*/ maybe_dashed_path_expression
	| /*empty*/
	;

opt_clone_table :
	KW_CLONE clone_data_source
	| /*empty*/
	;

opt_copy_table :
	KW_COPY copy_data_source
	| /*empty*/
	;

all_or_distinct :
	KW_ALL
	| KW_DISTINCT /*4N*/
	;

query_set_operation_type :
	KW_UNION
	| KW_EXCEPT_IN_SET_OP
	| KW_INTERSECT
	;

query_primary_or_set_operation :
	query_primary
	| query_set_operation
	;

parenthesized_query :
	'(' /*14L*/ query ')'
	;

select_or_from_keyword :
	KW_SELECT
	| KW_FROM
	;

bad_keyword_after_from_query :
	KW_WHERE
	| KW_SELECT
	| KW_GROUP
	;

bad_keyword_after_from_query_allows_parens :
	KW_ORDER
	| KW_UNION
	| KW_INTERSECT
	| KW_EXCEPT_IN_SET_OP
	| KW_LIMIT
	;

query_without_pipe_operators :
	with_clause query_primary_or_set_operation opt_order_by_clause opt_limit_offset_clause
	| with_clause_with_trailing_comma select_or_from_keyword
	| with_clause KW_PIPE
	| query_primary_or_set_operation opt_order_by_clause opt_limit_offset_clause
	| opt_with_clause from_clause
	| opt_with_clause from_clause bad_keyword_after_from_query
	| opt_with_clause from_clause bad_keyword_after_from_query_allows_parens
	;

query :
	query_without_pipe_operators
	| query KW_PIPE pipe_operator
	;

pipe_operator :
	pipe_where_clause
	| pipe_select_clause
	| pipe_extend_clause
	| pipe_rename
	| pipe_aggregate_clause
	| pipe_group_by
	| pipe_limit_offset_clause
	| pipe_set_operation_clause
	| pipe_order_by_clause
	| pipe_join
	| pipe_call
	| pipe_window_clause
	| pipe_distinct
	| pipe_tablesample
	| pipe_as
	| pipe_static_describe
	| pipe_assert
	| pipe_drop
	| pipe_set
	| pipe_pivot
	| pipe_unpivot
	;

pipe_where_clause :
	where_clause
	;

pipe_select_clause :
	select_clause
	;

pipe_limit_offset_clause :
	limit_offset_clause
	;

pipe_order_by_clause :
	order_by_clause_with_opt_comma
	;

pipe_extend_clause :
	KW_EXTEND pipe_selection_item_list
	;

pipe_selection_item :
	select_column_expr
	| select_column_dot_star
	;

pipe_selection_item_with_order :
	select_column_expr opt_selection_item_order
	| select_column_dot_star
	;

pipe_selection_item_list_no_comma :
	pipe_selection_item
	| pipe_selection_item_list_no_comma ',' pipe_selection_item
	;

pipe_selection_item_list_no_comma_with_order :
	pipe_selection_item_with_order
	| pipe_selection_item_list_no_comma_with_order ',' pipe_selection_item_with_order
	;

pipe_selection_item_list :
	pipe_selection_item_list_no_comma opt_comma
	;

pipe_selection_item_list_with_order :
	pipe_selection_item_list_no_comma_with_order opt_comma
	;

pipe_selection_item_list_with_order_or_empty :
	pipe_selection_item_list_with_order
	| /*empty*/
	;

pipe_rename_item :
	identifier opt_as identifier
	| identifier '.' /*14L*/
	;

pipe_rename_item_list :
	pipe_rename_item
	| pipe_rename_item_list ',' pipe_rename_item
	;

pipe_rename :
	KW_RENAME pipe_rename_item_list opt_comma
	;

opt_comma :
	','
	| /*empty*/
	;

pipe_aggregate_clause :
	KW_AGGREGATE pipe_selection_item_list_with_order_or_empty opt_group_by_clause_with_opt_comma
	;

pipe_group_by :
	KW_GROUP
	;

pipe_set_operation_clause :
	set_operation_metadata parenthesized_query
	| pipe_set_operation_clause ',' parenthesized_query
	;

pipe_join :
	opt_natural join_type join_hint KW_JOIN opt_hint table_primary opt_on_or_using_clause
	;

pipe_call :
	KW_CALL tvf opt_as_alias
	;

pipe_window_clause :
	KW_WINDOW pipe_selection_item_list
	;

pipe_distinct :
	KW_DISTINCT /*4N*/
	;

pipe_tablesample :
	sample_clause
	;

pipe_as :
	KW_AS identifier
	;

pipe_static_describe :
	KW_STATIC_DESCRIBE
	;

pipe_assert_base :
	KW_ASSERT expression
	| pipe_assert_base ',' expression
	;

pipe_assert :
	pipe_assert_base opt_comma
	;

identifier_in_pipe_drop :
	identifier
	| identifier '.' /*14L*/
	;

identifier_list_in_pipe_drop :
	identifier_in_pipe_drop
	| identifier_list_in_pipe_drop ',' identifier_in_pipe_drop
	;

pipe_drop :
	KW_DROP identifier_list_in_pipe_drop opt_comma
	;

pipe_set_item :
	identifier '=' /*4N*/ expression
	| identifier '.' /*14L*/
	;

pipe_set_item_list :
	pipe_set_item
	| pipe_set_item_list ',' pipe_set_item
	;

pipe_set :
	KW_SET pipe_set_item_list opt_comma
	;

pipe_pivot :
	pivot_clause opt_as_alias
	;

pipe_unpivot :
	unpivot_clause opt_as_alias
	;

opt_corresponding_outer_mode :
	KW_FULL_IN_SET_OP opt_outer
	| KW_OUTER
	| KW_LEFT_IN_SET_OP opt_outer
	| /*empty*/
	;

opt_strict :
	KW_STRICT
	| /*empty*/
	;

opt_column_match_suffix :
	KW_CORRESPONDING
	| KW_CORRESPONDING KW_BY column_list
	| /*empty*/
	;

query_set_operation_prefix :
	query_primary set_operation_metadata query_primary
	| query_set_operation_prefix set_operation_metadata query_primary
	| query_primary set_operation_metadata KW_FROM
	| query_set_operation_prefix set_operation_metadata KW_FROM
	;

set_operation_metadata :
	opt_corresponding_outer_mode query_set_operation_type opt_hint all_or_distinct opt_strict opt_column_match_suffix
	;

query_set_operation :
	query_set_operation_prefix
	;

query_primary :
	select
	| parenthesized_query opt_as_alias_with_required_as
	;

select_clause :
	KW_SELECT opt_hint opt_select_with opt_all_or_distinct opt_select_as_clause select_list
	| KW_SELECT opt_hint opt_select_with opt_all_or_distinct opt_select_as_clause KW_FROM
	;

select :
	select_clause opt_from_clause opt_clauses_following_from
	;

pre_select_with :
	/*empty*/
	;

opt_select_with :
	pre_select_with KW_WITH identifier
	| pre_select_with KW_WITH identifier KW_OPTIONS_IN_SELECT_WITH_OPTIONS options_list
	| pre_select_with
	;

opt_select_as_clause :
	KW_AS KW_STRUCT
	| KW_AS path_expression
	| /*empty*/
	;

extra_identifier_in_hints_name :
	KW_HASH
	| KW_PROTO
	| KW_PARTITION
	;

identifier_in_hints :
	identifier
	| extra_identifier_in_hints_name
	;

hint_entry :
	identifier_in_hints '=' /*4N*/ expression
	| identifier_in_hints '.' /*14L*/ identifier_in_hints '=' /*4N*/ expression
	;

hint_with_body_prefix :
	OPEN_INTEGER_PREFIX_HINT integer_literal KW_OPEN_HINT '{' hint_entry
	| KW_OPEN_HINT '{' hint_entry
	| hint_with_body_prefix ',' hint_entry
	;

hint_with_body :
	hint_with_body_prefix '}'
	;

hint :
	KW_OPEN_INTEGER_HINT integer_literal
	| hint_with_body
	;

opt_all_or_distinct :
	KW_ALL
	| KW_DISTINCT /*4N*/
	| /*empty*/
	;

select_list_prefix :
	select_column
	| select_list_prefix ',' select_column
	;

select_list :
	select_list_prefix
	| select_list_prefix ','
	;

star_except_list_prefix :
	KW_EXCEPT '(' /*14L*/ identifier
	| star_except_list_prefix ',' identifier
	;

star_except_list :
	star_except_list_prefix ')'
	;

star_replace_item :
	expression KW_AS identifier
	;

star_modifiers_with_replace_prefix :
	star_except_list KW_REPLACE '(' /*14L*/ star_replace_item
	| KW_REPLACE '(' /*14L*/ star_replace_item
	| star_modifiers_with_replace_prefix ',' star_replace_item
	;

star_modifiers :
	star_except_list
	| star_modifiers_with_replace_prefix ')'
	;

select_column :
	select_column_expr
	| select_column_dot_star
	| select_column_star
	;

select_column_expr :
	expression
	| select_column_expr_with_as_alias
	| expression identifier
	;

select_list_prefix_with_as_aliases :
	select_column_expr_with_as_alias
	| select_list_prefix_with_as_aliases ',' select_column_expr_with_as_alias
	;

select_column_expr_with_as_alias :
	expression KW_AS identifier
	;

select_column_dot_star :
	expression_higher_prec_than_and '.' /*14L*/ '*' /*11L*/ %prec '.' /*14L*/
	| expression_higher_prec_than_and '.' /*14L*/ '*' /*11L*/ star_modifiers %prec '.' /*14L*/
	;

select_column_star :
	'*' /*11L*/
	| '*' /*11L*/ star_modifiers
	;

opt_as_alias :
	opt_as identifier
	| /*empty*/
	;

opt_as_alias_with_required_as :
	KW_AS identifier
	| /*empty*/
	;

opt_as_or_into_alias :
	KW_AS identifier
	| KW_INTO identifier
	| /*empty*/
	;

opt_as :
	KW_AS
	| /*empty*/
	;

opt_natural :
	KW_NATURAL
	| /*empty*/
	;

opt_outer :
	KW_OUTER
	| /*empty*/
	;

//opt_int_literal_or_parameter :
//	int_literal_or_parameter
//	| /*empty*/
//	;

int_literal_or_parameter :
	integer_literal
	| parameter_expression
	| system_variable_expression
	;

cast_int_literal_or_parameter :
	KW_CAST '(' /*14L*/ int_literal_or_parameter KW_AS type opt_format ')'
	;

possibly_cast_int_literal_or_parameter :
	cast_int_literal_or_parameter
	| int_literal_or_parameter
	;

repeatable_clause :
	KW_REPEATABLE '(' /*14L*/ possibly_cast_int_literal_or_parameter ')'
	;

sample_size_value :
	possibly_cast_int_literal_or_parameter
	| floating_point_literal
	;

sample_size_unit :
	KW_ROWS
	| KW_PERCENT
	;

sample_size :
	sample_size_value sample_size_unit opt_partition_by_clause_no_hint
	;

opt_repeatable_clause :
	repeatable_clause
	| /*empty*/
	;

opt_sample_clause_suffix :
	repeatable_clause
	| KW_WITH KW_WEIGHT opt_repeatable_clause
	| KW_WITH KW_WEIGHT identifier opt_repeatable_clause
	| KW_WITH KW_WEIGHT KW_AS identifier opt_repeatable_clause
	| /*empty*/
	;

sample_clause :
	KW_TABLESAMPLE identifier '(' /*14L*/ sample_size ')' opt_sample_clause_suffix
	;

pivot_expression :
	expression opt_as_alias
	;

pivot_expression_list :
	pivot_expression
	| pivot_expression_list ',' pivot_expression
	;

pivot_value :
	expression opt_as_alias
	;

pivot_value_list :
	pivot_value
	| pivot_value_list ',' pivot_value
	;

pivot_clause :
	KW_PIVOT '(' /*14L*/ pivot_expression_list KW_FOR expression_higher_prec_than_and KW_IN /*4N*/ '(' /*14L*/ pivot_value_list ')' ')'
	;

opt_as_string_or_integer :
	opt_as string_literal
	| opt_as integer_literal
	| /*empty*/
	;

path_expression_list :
	path_expression
	| path_expression_list ',' path_expression
	;

path_expression_list_with_opt_parens :
	'(' /*14L*/ path_expression_list ')'
	| path_expression
	;

path_expression_list_prefix :
	'(' /*14L*/ path_expression
	| path_expression_list_prefix ',' path_expression
	;

path_expression_list_with_parens :
	path_expression_list_prefix ')'
	;

opt_path_expression_list_with_parens :
	path_expression_list_with_parens
	| /*empty*/
	;

unpivot_in_item :
	path_expression_list_with_opt_parens opt_as_string_or_integer
	;

unpivot_in_item_list_prefix :
	'(' /*14L*/ unpivot_in_item
	| unpivot_in_item_list_prefix ',' unpivot_in_item
	;

unpivot_in_item_list :
	unpivot_in_item_list_prefix ')'
	;

opt_unpivot_nulls_filter :
	KW_EXCLUDE KW_NULLS
	| KW_INCLUDE KW_NULLS
	| /*empty*/
	;

unpivot_clause :
	KW_UNPIVOT opt_unpivot_nulls_filter '(' /*14L*/ path_expression_list_with_opt_parens KW_FOR path_expression KW_IN /*4N*/ unpivot_in_item_list ')'
	;

opt_pivot_or_unpivot_clause_and_alias :
	KW_AS identifier
	| identifier
	| KW_AS identifier pivot_clause opt_as_alias
	| KW_AS identifier unpivot_clause opt_as_alias
	| KW_AS identifier qualify_clause_nonreserved
	| identifier pivot_clause opt_as_alias
	| identifier unpivot_clause opt_as_alias
	| identifier qualify_clause_nonreserved
	| pivot_clause opt_as_alias
	| unpivot_clause opt_as_alias
	| qualify_clause_nonreserved
	| /*empty*/
	;

match_recognize_clause :
	KW_MATCH_RECOGNIZE_RESERVED '(' /*14L*/ opt_partition_by_clause order_by_clause KW_MEASURES select_list_prefix_with_as_aliases KW_PATTERN '(' /*14L*/ row_pattern_expr ')' KW_DEFINE with_expression_variable_prefix ')' opt_as_alias
	;

row_pattern_expr :
	row_pattern_concatenation
	| row_pattern_expr '|' /*5L*/ row_pattern_concatenation
	;

row_pattern_concatenation :
	row_pattern_factor
	| row_pattern_concatenation row_pattern_factor
	;

row_pattern_factor :
	identifier
	| '(' /*14L*/ row_pattern_expr ')'
	;

table_subquery :
	parenthesized_query opt_pivot_or_unpivot_clause_and_alias
	;

table_clause :
	KW_TABLE tvf_with_suffixes
	| KW_TABLE path_expression
	;

model_clause :
	KW_MODEL path_expression
	;

connection_clause :
	KW_CONNECTION path_expression_or_default
	;

descriptor_column :
	identifier
	;

descriptor_column_list :
	descriptor_column
	| descriptor_column_list ',' descriptor_column
	;

descriptor_argument :
	KW_DESCRIPTOR '(' /*14L*/ descriptor_column_list ')'
	;

tvf_argument :
	expression
	| descriptor_argument
	| table_clause
	| model_clause
	| connection_clause
	| named_argument
	| '(' /*14L*/ table_clause ')'
	| '(' /*14L*/ model_clause ')'
	| '(' /*14L*/ connection_clause ')'
	| '(' /*14L*/ named_argument ')'
	| KW_SELECT
	| KW_WITH
	;

tvf_prefix_no_args :
	path_expression '(' /*14L*/
	| KW_IF '(' /*14L*/
	;

tvf_prefix :
	tvf_prefix_no_args tvf_argument
	| tvf_prefix ',' tvf_argument
	;

tvf :
	tvf_prefix_no_args ')' opt_hint
	| tvf_prefix ')' opt_hint
	;

tvf_with_suffixes :
	tvf_prefix_no_args ')' opt_hint opt_pivot_or_unpivot_clause_and_alias
	| tvf_prefix ')' opt_hint opt_pivot_or_unpivot_clause_and_alias
	;

table_path_expression_base :
	unnest_expression
	| maybe_slashed_or_dashed_path_expression
	| path_expression '[' /*14L*/
	| path_expression '.' /*14L*/ '(' /*14L*/
	| unnest_expression '[' /*14L*/
	| unnest_expression '.' /*14L*/ '(' /*14L*/
	;

table_path_expression :
	table_path_expression_base opt_hint opt_pivot_or_unpivot_clause_and_alias opt_with_offset_and_alias opt_at_system_time
	;

table_primary :
	tvf_with_suffixes
	| table_path_expression
	| '(' /*14L*/ join ')'
	| table_subquery
	| table_primary match_recognize_clause
	| table_primary sample_clause
	;

opt_at_system_time :
	KW_FOR KW_SYSTEM KW_TIME KW_AS KW_OF expression
	| KW_FOR KW_SYSTEM_TIME KW_AS KW_OF expression
	| /*empty*/
	;

on_clause :
	KW_ON expression
	;

using_clause_prefix :
	KW_USING '(' /*14L*/ identifier
	| using_clause_prefix ',' identifier
	;

using_clause :
	using_clause_prefix ')'
	;

opt_on_or_using_clause_list :
	on_or_using_clause_list
	| /*empty*/
	;

on_or_using_clause_list :
	on_or_using_clause
	| on_or_using_clause_list on_or_using_clause
	;

on_or_using_clause :
	on_clause
	| using_clause
	;

opt_on_or_using_clause :
	on_or_using_clause
	| /*empty*/
	;

join_type :
	KW_CROSS
	| KW_FULL opt_outer
	| KW_INNER
	| KW_LEFT opt_outer
	| KW_RIGHT opt_outer
	| /*empty*/
	;

join_hint :
	KW_HASH
	| KW_LOOKUP
	| /*empty*/
	;

join_input :
	join
	| table_primary
	;

join :
	join_input opt_natural join_type join_hint KW_JOIN opt_hint table_primary opt_on_or_using_clause_list
	;

from_clause_contents :
	table_primary
	| from_clause_contents ',' table_primary
	| from_clause_contents opt_natural join_type join_hint KW_JOIN opt_hint table_primary opt_on_or_using_clause_list
	| '@'
	| '?'
	| KW_DOUBLE_AT
	;

opt_from_clause :
	from_clause
	| /*empty*/
	;

from_clause :
	KW_FROM from_clause_contents
	;

opt_clauses_following_from :
	where_clause opt_group_by_clause opt_having_clause opt_qualify_clause opt_window_clause
	| opt_clauses_following_where
	;

opt_clauses_following_where :
	group_by_clause opt_having_clause opt_qualify_clause opt_window_clause
	| opt_clauses_following_group_by
	;

opt_clauses_following_group_by :
	having_clause opt_qualify_clause opt_window_clause
	| opt_qualify_clause_reserved opt_window_clause
	;

where_clause :
	KW_WHERE expression
	;

opt_where_clause :
	where_clause
	| /*empty*/
	;

rollup_list :
	KW_ROLLUP '(' /*14L*/ expression
	| rollup_list ',' expression
	;

cube_list :
	KW_CUBE '(' /*14L*/ expression
	| cube_list ',' expression
	;

grouping_set :
	'(' /*14L*/ ')'
	| expression
	| rollup_list ')'
	| cube_list ')'
	;

grouping_set_list :
	KW_GROUPING KW_SETS '(' /*14L*/ grouping_set
	| grouping_set_list ',' grouping_set
	;

opt_selection_item_order :
	asc_or_desc opt_null_order
	| /*empty*/
	;

opt_grouping_item_order :
	opt_selection_item_order
	| null_order
	;

grouping_item :
	'(' /*14L*/ ')'
	| expression opt_as_alias_with_required_as opt_grouping_item_order
	| rollup_list ')'
	| cube_list ')'
	| grouping_set_list ')'
	;

opt_and_order :
	KW_AND /*2L*/ KW_ORDER
	| /*empty*/
	;

group_by_preamble :
	KW_GROUP opt_hint opt_and_order KW_BY
	;

group_by_clause_prefix :
	group_by_preamble grouping_item
	| group_by_clause_prefix ',' grouping_item
	;

group_by_all :
	group_by_preamble KW_ALL
	;

group_by_clause :
	group_by_all
	| group_by_clause_prefix
	;

opt_group_by_clause :
	group_by_clause
	| /*empty*/
	;

opt_group_by_clause_with_opt_comma :
	group_by_clause_prefix opt_comma
	| /*empty*/
	;

having_clause :
	KW_HAVING expression
	;

opt_having_clause :
	having_clause
	| /*empty*/
	;

window_definition :
	identifier KW_AS window_specification
	;

window_clause_prefix :
	KW_WINDOW window_definition
	| window_clause_prefix ',' window_definition
	;

opt_window_clause :
	window_clause_prefix
	| /*empty*/
	;

opt_qualify_clause :
	qualify_clause_reserved
	| qualify_clause_nonreserved
	| /*empty*/
	;

qualify_clause_reserved :
	KW_QUALIFY_RESERVED expression
	;

opt_qualify_clause_reserved :
	qualify_clause_reserved
	| /*empty*/
	;

qualify_clause_nonreserved :
	KW_QUALIFY_NONRESERVED expression
	;

limit_offset_clause :
	KW_LIMIT expression KW_OFFSET expression
	| KW_LIMIT expression
	;

opt_limit_offset_clause :
	limit_offset_clause
	| /*empty*/
	;

opt_having_or_group_by_modifier :
	KW_HAVING KW_MAX expression
	| KW_HAVING KW_MIN expression
	| group_by_clause_prefix
	| /*empty*/
	;

opt_clamped_between_modifier :
	KW_CLAMPED KW_BETWEEN /*4N*/ expression_higher_prec_than_and KW_AND /*2L*/ expression %prec KW_BETWEEN /*4N*/
	| /*empty*/
	;

opt_with_report_modifier :
	KW_WITH KW_REPORT opt_with_report_format
	| /*empty*/
	;

opt_with_report_format :
	options_list
	| /*empty*/
	;

opt_null_handling_modifier :
	KW_IGNORE KW_NULLS
	| KW_RESPECT KW_NULLS
	| /*empty*/
	;

possibly_unbounded_int_literal_or_parameter :
	int_literal_or_parameter
	| KW_UNBOUNDED
	;

recursion_depth_modifier :
	KW_WITH KW_DEPTH opt_as_alias_with_required_as
	| KW_WITH KW_DEPTH opt_as_alias_with_required_as KW_BETWEEN /*4N*/ possibly_unbounded_int_literal_or_parameter KW_AND /*2L*/ possibly_unbounded_int_literal_or_parameter %prec KW_BETWEEN /*4N*/
	| KW_WITH KW_DEPTH opt_as_alias_with_required_as KW_MAX possibly_unbounded_int_literal_or_parameter
	;

aliased_query_modifiers :
	recursion_depth_modifier
	| /*empty*/
	;

aliased_query :
	identifier KW_AS parenthesized_query aliased_query_modifiers
	;

aliased_query_list :
	aliased_query
	| aliased_query_list ',' aliased_query
	;

with_clause :
	KW_WITH aliased_query
	| KW_WITH KW_RECURSIVE aliased_query
	| with_clause ',' aliased_query
	;

opt_with_clause :
	with_clause
	| /*empty*/
	;

opt_with_connection_clause :
	with_connection_clause
	| /*empty*/
	;

with_clause_with_trailing_comma :
	with_clause ','
	;

asc_or_desc :
	KW_ASC
	| KW_DESC
	;

opt_asc_or_desc :
	asc_or_desc
	| /*empty*/
	;

null_order :
	KW_NULLS KW_FIRST
	| KW_NULLS KW_LAST
	;

opt_null_order :
	null_order
	| /*empty*/
	;

string_literal_or_parameter :
	string_literal
	| parameter_expression
	| system_variable_expression
	;

collate_clause :
	KW_COLLATE string_literal_or_parameter
	;

opt_collate_clause :
	collate_clause
	| /*empty*/
	;

opt_default_collate_clause :
	KW_DEFAULT collate_clause
	| /*empty*/
	;

ordering_expression :
	expression opt_collate_clause opt_asc_or_desc opt_null_order
	;

order_by_clause_prefix :
	KW_ORDER opt_hint KW_BY ordering_expression
	| order_by_clause_prefix ',' ordering_expression
	;

order_by_clause :
	order_by_clause_prefix
	;

order_by_clause_with_opt_comma :
	order_by_clause_prefix opt_comma
	;

opt_order_by_clause :
	order_by_clause
	| /*empty*/
	;

parenthesized_in_rhs :
	parenthesized_query
	| '(' /*14L*/ expression_maybe_parenthesized_not_a_query ')'
	| in_list_two_or_more_prefix ')'
	;

parenthesized_anysomeall_list_in_rhs :
	parenthesized_query
	| '(' /*14L*/ expression_maybe_parenthesized_not_a_query ')'
	| in_list_two_or_more_prefix ')'
	;

in_list_two_or_more_prefix :
	'(' /*14L*/ expression ',' expression
	| in_list_two_or_more_prefix ',' expression
	;

expression_with_opt_alias :
	expression opt_as_alias_with_required_as
	;

unnest_expression_prefix :
	KW_UNNEST '(' /*14L*/ expression_with_opt_alias
	| unnest_expression_prefix ',' expression_with_opt_alias
	;

opt_array_zip_mode :
	',' named_argument
	| /*empty*/
	;

unnest_expression :
	unnest_expression_prefix opt_array_zip_mode ')'
	| KW_UNNEST '(' /*14L*/ KW_SELECT
	;

unnest_expression_with_opt_alias_and_offset :
	unnest_expression opt_as_alias opt_with_offset_and_alias
	;

comparative_operator :
	'=' /*4N*/
	| KW_NOT_EQUALS_C_STYLE /*4N*/
	| KW_NOT_EQUALS_SQL_STYLE /*4N*/
	| '<' /*4N*/
	| KW_LESS_EQUALS /*4N*/
	| '>' /*4N*/
	| KW_GREATER_EQUALS /*4N*/
	;

additive_operator :
	'+' /*9L*/
	| '-' /*9L*/
	;

multiplicative_operator :
	'*' /*11L*/
	| '/' /*11L*/
	;

shift_operator :
	KW_SHIFT_LEFT /*8L*/
	| KW_SHIFT_RIGHT /*8L*/
	;

import_type :
	KW_MODULE
	| KW_PROTO
	;

any_some_all :
	KW_ANY
	| KW_SOME
	| KW_ALL
	;

like_operator :
	KW_LIKE /*4N*/ %prec KW_LIKE /*4N*/
	| KW_NOT_SPECIAL /*4N*/ KW_LIKE /*4N*/ %prec KW_LIKE /*4N*/
	;

between_operator :
	KW_BETWEEN /*4N*/ %prec KW_BETWEEN /*4N*/
	| KW_NOT_SPECIAL /*4N*/ KW_BETWEEN /*4N*/ %prec KW_BETWEEN /*4N*/
	;

distinct_operator :
	KW_IS /*4N*/ KW_DISTINCT /*4N*/ KW_FROM %prec KW_DISTINCT /*4N*/
	| KW_IS /*4N*/ KW_NOT_SPECIAL /*4N*/ KW_DISTINCT /*4N*/ KW_FROM %prec KW_DISTINCT /*4N*/
	;

in_operator :
	KW_IN /*4N*/ %prec KW_IN /*4N*/
	| KW_NOT_SPECIAL /*4N*/ KW_IN /*4N*/ %prec KW_IN /*4N*/
	;

is_operator :
	KW_IS /*4N*/ %prec KW_IS /*4N*/
	| KW_IS /*4N*/ KW_NOT %prec KW_IS /*4N*/
	;

unary_operator :
	'+' /*9L*/ %prec UNARY_PRECEDENCE /*12P*/
	| '-' /*9L*/ %prec UNARY_PRECEDENCE /*12P*/
	| '~' %prec UNARY_PRECEDENCE /*12P*/
	;

with_expression_variable :
	identifier KW_AS expression
	;

with_expression_variable_prefix :
	with_expression_variable
	| with_expression_variable_prefix ',' with_expression_variable
	;

with_expression :
	KW_WITH_STARTING_WITH_EXPRESSION '(' /*14L*/ with_expression_variable_prefix ',' expression ')'
	;

expression :
	expression_higher_prec_than_and
	| and_expression %prec KW_AND /*2L*/
	| or_expression %prec KW_OR /*1L*/
	;

or_expression :
	expression KW_OR /*1L*/ expression %prec KW_OR /*1L*/
	;

and_expression :
	and_expression KW_AND /*2L*/ expression_higher_prec_than_and %prec KW_AND /*2L*/
	| expression_higher_prec_than_and KW_AND /*2L*/ expression_higher_prec_than_and %prec KW_AND /*2L*/
	;

expression_higher_prec_than_and :
	unparenthesized_expression_higher_prec_than_and
	| parenthesized_expression_not_a_query
	| parenthesized_query
	;

expression_maybe_parenthesized_not_a_query :
	parenthesized_expression_not_a_query
	| unparenthesized_expression_higher_prec_than_and
	| and_expression
	| or_expression
	;

parenthesized_expression_not_a_query :
	'(' /*14L*/ expression_maybe_parenthesized_not_a_query ')'
	;

unparenthesized_expression_higher_prec_than_and :
	null_literal
	| boolean_literal
	| string_literal
	| bytes_literal
	| integer_literal
	| numeric_literal
	| bignumeric_literal
	| json_literal
	| floating_point_literal
	| date_or_time_literal
	| range_literal
	| parameter_expression
	| system_variable_expression
	| array_constructor
	| new_constructor
	| braced_constructor
	| braced_new_constructor
	| struct_braced_constructor
	| case_expression
	| cast_expression
	| extract_expression
	| with_expression
	| replace_fields_expression
	| function_call_expression_with_clauses
	| interval_expression
	| identifier
	| struct_constructor
	| expression_subquery_with_keyword
	| expression_higher_prec_than_and '[' /*14L*/ expression ']' %prec PRIMARY_PRECEDENCE /*14L*/
	| expression_higher_prec_than_and '.' /*14L*/ '(' /*14L*/ path_expression ')' %prec PRIMARY_PRECEDENCE /*14L*/
	| expression_higher_prec_than_and '.' /*14L*/ identifier %prec PRIMARY_PRECEDENCE /*14L*/
	| KW_NOT expression_higher_prec_than_and %prec UNARY_NOT_PRECEDENCE /*3P*/
	| expression_higher_prec_than_and like_operator any_some_all opt_hint unnest_expression %prec KW_LIKE /*4N*/
	| expression_higher_prec_than_and like_operator any_some_all opt_hint parenthesized_anysomeall_list_in_rhs %prec KW_LIKE /*4N*/
	| expression_higher_prec_than_and like_operator expression_higher_prec_than_and %prec KW_LIKE /*4N*/
	| expression_higher_prec_than_and distinct_operator expression_higher_prec_than_and %prec KW_DISTINCT /*4N*/
	| expression_higher_prec_than_and in_operator opt_hint unnest_expression %prec KW_IN /*4N*/
	| expression_higher_prec_than_and in_operator opt_hint parenthesized_in_rhs %prec KW_IN /*4N*/
	| expression_higher_prec_than_and between_operator expression_higher_prec_than_and KW_AND /*2L*/ expression_higher_prec_than_and %prec KW_BETWEEN /*4N*/
	| expression_higher_prec_than_and between_operator expression_higher_prec_than_and KW_OR /*1L*/ %prec KW_BETWEEN /*4N*/
	| expression_higher_prec_than_and is_operator KW_UNKNOWN %prec KW_IS /*4N*/
	| expression_higher_prec_than_and is_operator null_literal %prec KW_IS /*4N*/
	| expression_higher_prec_than_and is_operator boolean_literal %prec KW_IS /*4N*/
	| expression_higher_prec_than_and comparative_operator expression_higher_prec_than_and %prec '=' /*4N*/
	| expression_higher_prec_than_and '|' /*5L*/ expression_higher_prec_than_and
	| expression_higher_prec_than_and '^' /*6L*/ expression_higher_prec_than_and
	| expression_higher_prec_than_and '&' /*7L*/ expression_higher_prec_than_and
	| expression_higher_prec_than_and KW_CONCAT_OP /*10L*/ expression_higher_prec_than_and
	| expression_higher_prec_than_and shift_operator expression_higher_prec_than_and %prec KW_SHIFT_LEFT /*8L*/
	| expression_higher_prec_than_and additive_operator expression_higher_prec_than_and %prec '+' /*9L*/
	| expression_higher_prec_than_and multiplicative_operator expression_higher_prec_than_and %prec '*' /*11L*/
	| unary_operator expression_higher_prec_than_and %prec UNARY_PRECEDENCE /*12P*/
	;

path_expression :
	identifier
	| path_expression '.' /*14L*/ identifier
	;

dashed_identifier :
	identifier '-' /*9L*/ identifier
	| dashed_identifier '-' /*9L*/ identifier
	| identifier '-' /*9L*/ INTEGER_LITERAL
	| dashed_identifier '-' /*9L*/ INTEGER_LITERAL
	| identifier '-' /*9L*/ FLOATING_POINT_LITERAL identifier
	| dashed_identifier '-' /*9L*/ FLOATING_POINT_LITERAL identifier
	;

dashed_path_expression :
	dashed_identifier
	| dashed_path_expression '.' /*14L*/ identifier
	;

maybe_dashed_path_expression :
	path_expression
	| dashed_path_expression
	;

maybe_slashed_or_dashed_path_expression :
	maybe_dashed_path_expression
	| slashed_path_expression
	;

slashed_identifier_separator :
	'-' /*9L*/
	| '/' /*11L*/
	| ':'
	;

identifier_or_integer :
	identifier
	| INTEGER_LITERAL
	| SCRIPT_LABEL
	;

slashed_identifier :
	'/' /*11L*/ identifier_or_integer
	| slashed_identifier slashed_identifier_separator identifier_or_integer
	| slashed_identifier slashed_identifier_separator FLOATING_POINT_LITERAL slashed_identifier_separator identifier_or_integer
	;

slashed_path_expression :
	slashed_identifier
	| slashed_identifier slashed_identifier_separator FLOATING_POINT_LITERAL identifier
	| slashed_identifier slashed_identifier_separator FLOATING_POINT_LITERAL '.' /*14L*/ identifier
	| slashed_path_expression '.' /*14L*/ identifier
	;

array_constructor_prefix_no_expressions :
	KW_ARRAY '[' /*14L*/
	| '[' /*14L*/
	| array_type '[' /*14L*/
	;

array_constructor_prefix :
	array_constructor_prefix_no_expressions expression
	| array_constructor_prefix ',' expression
	;

array_constructor :
	array_constructor_prefix_no_expressions ']'
	| array_constructor_prefix ']'
	;

range_literal :
	range_type string_literal
	;

date_or_time_literal_kind :
	KW_DATE
	| KW_DATETIME
	| KW_TIME
	| KW_TIMESTAMP
	;

date_or_time_literal :
	date_or_time_literal_kind string_literal
	;

interval_expression :
	KW_INTERVAL expression identifier
	| KW_INTERVAL expression identifier KW_TO identifier
	;

parameter_expression :
	named_parameter_expression
	| '?'
	;

named_parameter_expression :
	'@' identifier
	;

type_name :
	path_expression
	| KW_INTERVAL
	;

template_type_open :
	'<' /*4N*/
	;

template_type_close :
	'>' /*4N*/
	;

array_type :
	KW_ARRAY template_type_open type template_type_close
	;

struct_field :
	identifier type
	| type
	;

struct_type_prefix :
	KW_STRUCT template_type_open struct_field
	| struct_type_prefix ',' struct_field
	;

struct_type :
	KW_STRUCT template_type_open template_type_close
	| struct_type_prefix template_type_close
	;

range_type :
	KW_RANGE template_type_open type template_type_close
	;

function_type_prefix :
	KW_FUNCTION template_type_open '(' /*14L*/ type
	| function_type_prefix ',' type
	;

function_type :
	KW_FUNCTION template_type_open '(' /*14L*/ ')' KW_LAMBDA_ARROW type template_type_close
	| KW_FUNCTION template_type_open type KW_LAMBDA_ARROW type template_type_close
	| function_type_prefix ')' KW_LAMBDA_ARROW type template_type_close
	;

map_type :
	KW_MAP template_type_open type ',' type template_type_close
	;

raw_type :
	array_type
	| struct_type
	| type_name
	| range_type
	| function_type
	| map_type
	;

type_parameter :
	integer_literal
	| boolean_literal
	| string_literal
	| bytes_literal
	| floating_point_literal
	| KW_MAX
	;

type_parameters_prefix :
	'(' /*14L*/ type_parameter
	| type_parameters_prefix ',' type_parameter
	;

opt_type_parameters :
	type_parameters_prefix ')'
	| type_parameters_prefix ',' ')'
	| /*empty*/
	;

type :
	raw_type opt_type_parameters opt_collate_clause
	;

templated_parameter_kind :
	KW_PROTO
	| KW_ENUM
	| KW_STRUCT
	| KW_ARRAY
	| identifier
	;

templated_parameter_type :
	KW_ANY templated_parameter_kind
	;

type_or_tvf_schema :
	type
	| templated_parameter_type
	| tvf_schema
	;

new_constructor_prefix_no_arg :
	KW_NEW type_name '(' /*14L*/
	;

new_constructor_arg :
	expression
	| expression KW_AS identifier
	| expression KW_AS '(' /*14L*/ path_expression ')'
	;

new_constructor_prefix :
	new_constructor_prefix_no_arg new_constructor_arg
	| new_constructor_prefix ',' new_constructor_arg
	;

new_constructor :
	new_constructor_prefix ')'
	| new_constructor_prefix_no_arg ')'
	;

braced_constructor_field_value :
	':' expression
	| braced_constructor
	;

braced_constructor_extension_expression_start :
	'(' /*14L*/ path_expression ')'
	;

braced_constructor_extension_expression :
	braced_constructor_extension_expression_start
	;

braced_constructor_extension_lhs :
	braced_constructor_extension_expression
	;

braced_constructor_extension :
	braced_constructor_extension_lhs braced_constructor_field_value
	;

braced_constructor_lhs :
	generalized_path_expression
	;

braced_constructor_field :
	braced_constructor_lhs braced_constructor_field_value
	;

braced_constructor_start :
	'{'
	;

braced_constructor_prefix :
	braced_constructor_start braced_constructor_field
	| braced_constructor_start braced_constructor_extension
	| braced_constructor_prefix ',' braced_constructor_field
	| braced_constructor_prefix braced_constructor_field
	| braced_constructor_prefix ',' braced_constructor_extension
	;

braced_constructor :
	braced_constructor_start '}'
	| braced_constructor_prefix '}'
	| braced_constructor_prefix ',' '}'
	;

braced_new_constructor :
	KW_NEW type_name braced_constructor
	;

struct_braced_constructor :
	struct_type braced_constructor
	| KW_STRUCT braced_constructor
	;

case_no_value_expression_prefix :
	KW_CASE KW_WHEN expression KW_THEN expression
	| case_no_value_expression_prefix KW_WHEN expression KW_THEN expression
	;

case_value_expression_prefix :
	KW_CASE expression KW_WHEN expression KW_THEN expression
	| case_value_expression_prefix KW_WHEN expression KW_THEN expression
	;

case_expression_prefix :
	case_no_value_expression_prefix
	| case_value_expression_prefix
	;

case_expression :
	case_expression_prefix KW_END
	| case_expression_prefix KW_ELSE expression KW_END
	;

opt_at_time_zone :
	KW_AT KW_TIME KW_ZONE expression
	| /*empty*/
	;

opt_format :
	KW_FORMAT expression opt_at_time_zone
	| /*empty*/
	;

cast_expression :
	KW_CAST '(' /*14L*/ expression KW_AS type opt_format ')'
	| KW_CAST '(' /*14L*/ KW_SELECT
	| KW_SAFE_CAST '(' /*14L*/ expression KW_AS type opt_format ')'
	| KW_SAFE_CAST '(' /*14L*/ KW_SELECT
	;

extract_expression_base :
	KW_EXTRACT '(' /*14L*/ expression KW_FROM expression
	;

extract_expression :
	extract_expression_base ')'
	| extract_expression_base KW_AT KW_TIME KW_ZONE expression ')'
	;

replace_fields_arg :
	expression KW_AS generalized_path_expression
	| expression KW_AS generalized_extension_path
	;

replace_fields_prefix :
	KW_REPLACE_FIELDS '(' /*14L*/ expression ',' replace_fields_arg
	| replace_fields_prefix ',' replace_fields_arg
	;

replace_fields_expression :
	replace_fields_prefix ')'
	;

function_name_from_keyword :
	KW_IF
	| KW_GROUPING
	| KW_LEFT
	| KW_RIGHT
	| KW_COLLATE
	| KW_RANGE
	;

function_call_expression_base :
	expression_higher_prec_than_and '(' /*14L*/ KW_DISTINCT /*4N*/ %prec PRIMARY_PRECEDENCE /*14L*/
	| expression_higher_prec_than_and '(' /*14L*/ %prec PRIMARY_PRECEDENCE /*14L*/
	| function_name_from_keyword '(' /*14L*/ %prec PRIMARY_PRECEDENCE /*14L*/
	;

function_call_argument :
	expression opt_as_alias_with_required_as
	| named_argument
	| lambda_argument
	| sequence_arg
	| KW_SELECT
	;

sequence_arg :
	KW_SEQUENCE path_expression
	;

named_argument :
	identifier KW_NAMED_ARGUMENT_ASSIGNMENT expression
	| identifier KW_NAMED_ARGUMENT_ASSIGNMENT lambda_argument
	;

lambda_argument :
	lambda_argument_list KW_LAMBDA_ARROW expression
	;

lambda_argument_list :
	expression
	| '(' /*14L*/ ')'
	;

function_call_expression_with_args_prefix :
	function_call_expression_base function_call_argument
	| function_call_expression_base '*' /*11L*/
	| function_call_expression_with_args_prefix ',' function_call_argument
	;

function_call_expression :
	function_call_expression_base opt_having_or_group_by_modifier opt_order_by_clause opt_limit_offset_clause ')'
	| function_call_expression_with_args_prefix opt_null_handling_modifier opt_having_or_group_by_modifier opt_clamped_between_modifier opt_with_report_modifier opt_order_by_clause opt_limit_offset_clause ')'
	;

opt_identifier :
	identifier
	| /*empty*/
	;

partition_by_clause_prefix :
	KW_PARTITION opt_hint KW_BY expression
	| partition_by_clause_prefix ',' expression
	;

opt_partition_by_clause :
	partition_by_clause_prefix
	| /*empty*/
	;

partition_by_clause_prefix_no_hint :
	KW_PARTITION KW_BY expression
	| partition_by_clause_prefix_no_hint ',' expression
	;

opt_partition_by_clause_no_hint :
	partition_by_clause_prefix_no_hint
	| /*empty*/
	;

cluster_by_clause_prefix_no_hint :
	KW_CLUSTER KW_BY expression
	| cluster_by_clause_prefix_no_hint ',' expression
	;

opt_cluster_by_clause_no_hint :
	cluster_by_clause_prefix_no_hint
	| /*empty*/
	;

opt_ttl_clause :
	KW_ROW KW_DELETION KW_POLICY '(' /*14L*/ expression ')'
	| /*empty*/
	;

preceding_or_following :
	KW_PRECEDING
	| KW_FOLLOWING
	;

window_frame_bound :
	KW_UNBOUNDED preceding_or_following
	| KW_CURRENT KW_ROW
	| expression preceding_or_following
	;

frame_unit :
	KW_ROWS
	| KW_RANGE
	;

opt_window_frame_clause :
	frame_unit KW_BETWEEN /*4N*/ window_frame_bound KW_AND /*2L*/ window_frame_bound %prec KW_BETWEEN /*4N*/
	| frame_unit window_frame_bound
	| /*empty*/
	;

window_specification :
	identifier
	| '(' /*14L*/ opt_identifier opt_partition_by_clause opt_order_by_clause opt_window_frame_clause ')'
	;

function_call_expression_with_clauses :
	function_call_expression opt_hint opt_with_group_rows opt_over_clause
	;

opt_with_group_rows :
	KW_WITH_STARTING_WITH_GROUP_ROWS KW_GROUP KW_ROWS parenthesized_query
	| /*empty*/
	;

opt_over_clause :
	KW_OVER window_specification
	| /*empty*/
	;

struct_constructor_prefix_with_keyword_no_arg :
	struct_type '(' /*14L*/
	| KW_STRUCT '(' /*14L*/
	;

struct_constructor_prefix_with_keyword :
	struct_constructor_prefix_with_keyword_no_arg struct_constructor_arg
	| struct_constructor_prefix_with_keyword ',' struct_constructor_arg
	;

struct_constructor_arg :
	expression opt_as_alias_with_required_as
	;

struct_constructor_prefix_without_keyword :
	'(' /*14L*/ expression ',' expression
	| struct_constructor_prefix_without_keyword ',' expression
	;

struct_constructor :
	struct_constructor_prefix_with_keyword ')'
	| struct_constructor_prefix_with_keyword_no_arg ')'
	| struct_constructor_prefix_without_keyword ')'
	;

expression_subquery_with_keyword :
	KW_ARRAY parenthesized_query
	| KW_EXISTS opt_hint parenthesized_query
	;

null_literal :
	KW_NULL
	;

boolean_literal :
	KW_TRUE
	| KW_FALSE
	;

string_literal_component :
	STRING_LITERAL
	;

string_literal :
	string_literal_component
	| string_literal string_literal_component
	| string_literal bytes_literal_component
	;

bytes_literal_component :
	BYTES_LITERAL
	;

bytes_literal :
	bytes_literal_component
	| bytes_literal bytes_literal_component
	| bytes_literal string_literal_component
	;

integer_literal :
	INTEGER_LITERAL
	;

numeric_literal_prefix :
	KW_NUMERIC
	| KW_DECIMAL
	;

numeric_literal :
	numeric_literal_prefix string_literal
	;

bignumeric_literal_prefix :
	KW_BIGNUMERIC
	| KW_BIGDECIMAL
	;

bignumeric_literal :
	bignumeric_literal_prefix string_literal
	;

json_literal :
	KW_JSON string_literal
	;

floating_point_literal :
	FLOATING_POINT_LITERAL
	;

token_identifier :
	IDENTIFIER
	;

identifier :
	token_identifier
	| keyword_as_identifier
	;

label :
	SCRIPT_LABEL
	;

system_variable_expression :
	KW_DOUBLE_AT path_expression %prec DOUBLE_AT_PRECEDENCE /*13P*/
	;

common_keyword_as_identifier :
	KW_ABORT
	| KW_ACCESS
	| KW_ACTION
	| KW_AGGREGATE
	| KW_ADD
	| KW_ALTER
	| KW_ALWAYS
	| KW_ANALYZE
	| KW_APPROX
	| KW_ARE
	| KW_ASSERT
	| KW_BATCH
	| KW_BEGIN
	| KW_BIGDECIMAL
	| KW_BIGNUMERIC
	| KW_BREAK
	| KW_CALL
	| KW_CASCADE
	| KW_CHECK
	| KW_CLAMPED
	| KW_CLONE
	| KW_COPY
	| KW_CLUSTER
	| KW_COLUMN
	| KW_COLUMNS
	| KW_COMMIT
	| KW_CONNECTION
	| KW_CONSTANT
	| KW_CONSTRAINT
	| KW_CONTINUE
	| KW_CORRESPONDING
	| KW_CYCLE
	| KW_DATA
	| KW_DATABASE
	| KW_DATE
	| KW_DATETIME
	| KW_DECIMAL
	| KW_DECLARE
	| KW_DEFINER
	| KW_DELETE
	| KW_DELETION
	| KW_DEPTH
	| KW_DESCRIBE
	| KW_DETERMINISTIC
	| KW_DO
	| KW_DROP
	| KW_ELSEIF
	| KW_ENFORCED
	| KW_ERROR
	| KW_EXCEPTION
	| KW_EXECUTE
	| KW_EXPLAIN
	| KW_EXPORT
	| KW_EXTEND
	| KW_EXTERNAL
	| KW_FILES
	| KW_FILTER
	| KW_FILL
	| KW_FIRST
	| KW_FOREIGN
	| KW_FORMAT
	| KW_FUNCTION
	| KW_GENERATED
	| KW_GRANT
	| KW_GROUP_ROWS
	| KW_HIDDEN
	| KW_IDENTITY
	| KW_IMMEDIATE
	| KW_IMMUTABLE
	| KW_IMPORT
	| KW_INCLUDE
	| KW_INCREMENT
	| KW_INDEX
	| KW_INOUT
	| KW_INPUT
	| KW_INSERT
	| KW_INVOKER
	| KW_ISOLATION
	| KW_ITERATE
	| KW_JSON
	| KW_KEY
	| KW_LANGUAGE
	| KW_LAST
	| KW_LEAVE
	| KW_LEVEL
	| KW_LOAD
	| KW_LOOP
	| KW_MACRO
	| KW_MAP
	| KW_MATCH
	| KW_MATCH_RECOGNIZE_NONRESERVED
	| KW_MATCHED
	| KW_MATERIALIZED
	| KW_MAX
	| KW_MAXVALUE
	| KW_MEASURES
	| KW_MESSAGE
	| KW_METADATA
	| KW_MIN
	| KW_MINVALUE
	| KW_MODEL
	| KW_MODULE
	| KW_NUMERIC
	| KW_OFFSET
	| KW_ONLY
	| KW_OPTIONS
	| KW_OUT
	| KW_OUTPUT
	| KW_OVERWRITE
	| KW_PARTITIONS
	| KW_PATTERN
	| KW_PERCENT
	| KW_PIVOT
	| KW_POLICIES
	| KW_POLICY
	| KW_PRIMARY
	| KW_PRIVATE
	| KW_PRIVILEGE
	| KW_PRIVILEGES
	| KW_PROCEDURE
	| KW_PROJECT
	| KW_PUBLIC
	| KW_QUALIFY_NONRESERVED
	| KW_RAISE
	| KW_READ
	| KW_REFERENCES
	| KW_REMOTE
	| KW_REMOVE
	| KW_RENAME
	| KW_REPEAT
	| KW_REPEATABLE
	| KW_REPLACE
	| KW_REPLACE_FIELDS
	| KW_REPLICA
	| KW_REPORT
	| KW_RESTRICT
	| KW_RESTRICTION
	| KW_RETURNS
	| KW_RETURN
	| KW_REVOKE
	| KW_ROLLBACK
	| KW_ROW
	| KW_RUN
	| KW_SAFE_CAST
	| KW_SCHEMA
	| KW_SEARCH
	| KW_SECURITY
	| KW_SEQUENCE
	| KW_SETS
	| KW_SHOW
	| KW_SNAPSHOT
	| KW_SOURCE
	| KW_SQL
	| KW_STABLE
	| KW_START
	| KW_STATIC_DESCRIBE
	| KW_STORED
	| KW_STORING
	| KW_STRICT
	| KW_SYSTEM
	| KW_SYSTEM_TIME
	| KW_TABLE
	| KW_TABLES
	| KW_TARGET
	| KW_TEMP
	| KW_TEMPORARY
	| KW_TIME
	| KW_TIMESTAMP
	| KW_TRANSACTION
	| KW_TRANSFORM
	| KW_TRUNCATE
	| KW_TYPE
	| KW_UNDROP
	| KW_UNIQUE
	| KW_UNKNOWN
	| KW_UNPIVOT
	| KW_UNTIL
	| KW_UPDATE
	| KW_VALUE
	| KW_VALUES
	| KW_VECTOR
	| KW_VIEW
	| KW_VIEWS
	| KW_VOLATILE
	| KW_WEIGHT
	| KW_WHILE
	| KW_WRITE
	| KW_ZONE
	| KW_DESCRIPTOR
	| KW_INTERLEAVE
	| KW_NULL_FILTERED
	| KW_PARENT
	;

keyword_as_identifier :
	common_keyword_as_identifier
	| KW_SIMPLE
	;

opt_or_replace :
	KW_OR /*1L*/ KW_REPLACE
	| /*empty*/
	;

opt_create_scope :
	KW_TEMP
	| KW_TEMPORARY
	| KW_PUBLIC
	| KW_PRIVATE
	| /*empty*/
	;

opt_unique :
	KW_UNIQUE
	| /*empty*/
	;

describe_keyword :
	KW_DESCRIBE
	| KW_DESC
	;

opt_hint :
	hint
	| /*empty*/
	;

options_entry :
	identifier_in_hints options_assignment_operator expression_or_proto
	;

options_assignment_operator :
	'=' /*4N*/
	| KW_ADD_ASSIGN /*4N*/
	| KW_SUB_ASSIGN /*4N*/
	;

expression_or_proto :
	KW_PROTO
	| expression
	;

options_list_prefix :
	'(' /*14L*/ options_entry
	| options_list_prefix ',' options_entry
	;

options_list :
	options_list_prefix ')'
	| '(' /*14L*/ ')'
	;

options :
	KW_OPTIONS options_list
	;

opt_options_list :
	options
	| /*empty*/
	;

define_table_statement :
	KW_DEFINE KW_TABLE path_expression options_list
	;

dml_statement :
	insert_statement
	| delete_statement
	| update_statement
	;

opt_from_keyword :
	KW_FROM
	| /*empty*/
	;

opt_where_expression :
	KW_WHERE expression
	| /*empty*/
	;

opt_assert_rows_modified :
	KW_ASSERT_ROWS_MODIFIED possibly_cast_int_literal_or_parameter
	| /*empty*/
	;

opt_returning_clause :
	KW_THEN KW_RETURN select_list
	| KW_THEN KW_RETURN KW_WITH KW_ACTION select_list
	| KW_THEN KW_RETURN KW_WITH KW_ACTION KW_AS identifier select_list
	| /*empty*/
	;

opt_or_ignore_replace_update :
	KW_OR /*1L*/ KW_IGNORE
	| KW_IGNORE
	| KW_OR /*1L*/ KW_REPLACE
	| KW_REPLACE_AFTER_INSERT
	| KW_OR /*1L*/ KW_UPDATE
	| KW_UPDATE_AFTER_INSERT
	| /*empty*/
	;

insert_statement_prefix :
	KW_INSERT opt_or_ignore_replace_update opt_into maybe_dashed_generalized_path_expression opt_hint
	;

insert_statement :
	insert_statement_prefix column_list insert_values_or_query opt_assert_rows_modified opt_returning_clause
	| insert_statement_prefix insert_values_or_query opt_assert_rows_modified opt_returning_clause
	;

copy_data_source :
	maybe_dashed_path_expression opt_at_system_time opt_where_clause
	;

clone_data_source :
	maybe_dashed_path_expression opt_at_system_time opt_where_clause
	;

clone_data_source_list :
	clone_data_source
	| clone_data_source_list KW_UNION KW_ALL clone_data_source
	;

clone_data_statement :
	KW_CLONE KW_DATA KW_INTO maybe_dashed_path_expression KW_FROM clone_data_source_list
	;

expression_or_default :
	expression
	| KW_DEFAULT
	;

insert_values_row_prefix :
	'(' /*14L*/ expression_or_default
	| insert_values_row_prefix ',' expression_or_default
	;

insert_values_row :
	insert_values_row_prefix ')'
	;

insert_values_or_query :
	insert_values_list
	| query
	;

insert_values_list :
	KW_VALUES insert_values_row
	| insert_values_list ',' insert_values_row
	;

delete_statement :
	KW_DELETE opt_from_keyword maybe_dashed_generalized_path_expression opt_hint opt_as_alias opt_with_offset_and_alias opt_where_expression opt_assert_rows_modified opt_returning_clause
	;

opt_with_offset_and_alias :
	KW_WITH KW_OFFSET opt_as_alias
	| /*empty*/
	;

update_statement :
	KW_UPDATE maybe_dashed_generalized_path_expression opt_hint opt_as_alias opt_with_offset_and_alias KW_SET update_item_list opt_from_clause opt_where_expression opt_assert_rows_modified opt_returning_clause
	;

truncate_statement :
	KW_TRUNCATE KW_TABLE maybe_dashed_path_expression opt_where_expression
	;

nested_dml_statement :
	'(' /*14L*/ dml_statement ')'
	;

generalized_path_expression :
	identifier
	| generalized_path_expression '.' /*14L*/ generalized_extension_path
	| generalized_path_expression '.' /*14L*/ identifier
	| generalized_path_expression '[' /*14L*/ expression ']'
	;

maybe_dashed_generalized_path_expression :
	generalized_path_expression
	| dashed_path_expression
	;

generalized_extension_path :
	'(' /*14L*/ path_expression ')'
	| generalized_extension_path '.' /*14L*/ '(' /*14L*/ path_expression ')'
	| generalized_extension_path '.' /*14L*/ identifier
	;

update_set_value :
	generalized_path_expression '=' /*4N*/ expression_or_default
	;

update_item :
	update_set_value
	| nested_dml_statement
	;

update_item_list :
	update_item
	| update_item_list ',' update_item
	;

opt_into :
	KW_INTO
	| /*empty*/
	;

opt_by_target :
	KW_BY KW_TARGET
	| /*empty*/
	;

opt_and_expression :
	KW_AND /*2L*/ expression
	| /*empty*/
	;

merge_insert_value_list_or_source_row :
	KW_VALUES insert_values_row
	| KW_ROW
	;

merge_action :
	KW_INSERT opt_column_list merge_insert_value_list_or_source_row
	| KW_UPDATE KW_SET update_item_list
	| KW_DELETE
	;

merge_when_clause :
	KW_WHEN KW_MATCHED opt_and_expression KW_THEN merge_action
	| KW_WHEN KW_NOT KW_MATCHED opt_by_target opt_and_expression KW_THEN merge_action
	| KW_WHEN KW_NOT KW_MATCHED KW_BY KW_SOURCE opt_and_expression KW_THEN merge_action
	;

merge_when_clause_list :
	merge_when_clause
	| merge_when_clause_list merge_when_clause
	;

merge_source :
	table_path_expression
	| table_subquery
	;

merge_statement_prefix :
	KW_MERGE opt_into maybe_dashed_path_expression opt_as_alias KW_USING merge_source KW_ON expression
	;

merge_statement :
	merge_statement_prefix merge_when_clause_list
	;

call_statement_with_args_prefix :
	KW_CALL path_expression '(' /*14L*/ tvf_argument
	| call_statement_with_args_prefix ',' tvf_argument
	;

call_statement :
	call_statement_with_args_prefix ')'
	| KW_CALL path_expression '(' /*14L*/ ')'
	;

opt_function_parameters :
	function_parameters
	| /*empty*/
	;

opt_if_exists :
	KW_IF KW_EXISTS
	| /*empty*/
	;

opt_access :
	KW_ACCESS
	| /*empty*/
	;

drop_all_row_access_policies_statement :
	KW_DROP KW_ALL KW_ROW opt_access KW_POLICIES KW_ON path_expression
	;

on_path_expression :
	KW_ON path_expression
	;

opt_on_path_expression :
	KW_ON path_expression
	| /*empty*/
	;

opt_drop_mode :
	KW_RESTRICT
	| KW_CASCADE
	| /*empty*/
	;

drop_statement :
	KW_DROP KW_PRIVILEGE KW_RESTRICTION opt_if_exists KW_ON privilege_list KW_ON identifier path_expression
	| KW_DROP KW_ROW KW_ACCESS KW_POLICY opt_if_exists identifier on_path_expression
	| KW_DROP index_type KW_INDEX opt_if_exists path_expression opt_on_path_expression
	| KW_DROP table_or_table_function opt_if_exists maybe_dashed_path_expression opt_function_parameters
	| KW_DROP KW_SNAPSHOT KW_TABLE opt_if_exists maybe_dashed_path_expression
	| KW_DROP generic_entity_type opt_if_exists path_expression
	| KW_DROP schema_object_kind opt_if_exists path_expression opt_function_parameters opt_drop_mode
	;

index_type :
	KW_SEARCH
	| KW_VECTOR
	;

opt_index_type :
	index_type
	| /*empty*/
	;

unterminated_non_empty_statement_list :
	unterminated_statement
	| unterminated_non_empty_statement_list ';' unterminated_statement
	;

unterminated_non_empty_top_level_statement_list :
	unterminated_statement
	| unterminated_non_empty_top_level_statement_list ';' unterminated_statement
	;

opt_execute_into_clause :
	KW_INTO identifier_list
	| /*empty*/
	;

execute_using_argument :
	expression KW_AS identifier
	| expression
	;

execute_using_argument_list :
	execute_using_argument
	| execute_using_argument_list ',' execute_using_argument
	;

opt_execute_using_clause :
	KW_USING execute_using_argument_list
	| /*empty*/
	;

execute_immediate :
	KW_EXECUTE KW_IMMEDIATE expression opt_execute_into_clause opt_execute_using_clause
	;

script :
	unterminated_non_empty_top_level_statement_list
	| unterminated_non_empty_top_level_statement_list ';'
	| /*empty*/
	;

statement_list :
	unterminated_non_empty_statement_list ';'
	| /*empty*/
	;

opt_else :
	KW_ELSE statement_list
	| /*empty*/
	;

elseif_clauses :
	KW_ELSEIF expression KW_THEN statement_list
	| elseif_clauses KW_ELSEIF expression KW_THEN statement_list
	;

opt_elseif_clauses :
	elseif_clauses
	| /*empty*/
	;

if_statement_unclosed :
	KW_IF expression KW_THEN statement_list opt_elseif_clauses opt_else
	;

if_statement :
	if_statement_unclosed KW_END KW_IF
	;

when_then_clauses :
	KW_WHEN expression KW_THEN statement_list
	| when_then_clauses KW_WHEN expression KW_THEN statement_list
	;

opt_expression :
	expression
	| /*empty*/
	;

case_statement :
	KW_CASE opt_expression when_then_clauses opt_else KW_END KW_CASE
	;

begin_end_block :
	KW_BEGIN statement_list opt_exception_handler KW_END
	;

opt_exception_handler :
	KW_EXCEPTION KW_WHEN KW_ERROR KW_THEN statement_list
	| /*empty*/
	;

opt_default_expression :
	KW_DEFAULT expression
	| /*empty*/
	;

identifier_list :
	identifier
	| identifier_list ',' identifier
	;

variable_declaration :
	KW_DECLARE identifier_list type opt_default_expression
	| KW_DECLARE identifier_list KW_DEFAULT expression
	;

loop_statement :
	KW_LOOP statement_list KW_END KW_LOOP
	;

while_statement :
	KW_WHILE expression KW_DO statement_list KW_END KW_WHILE
	;

until_clause :
	KW_UNTIL expression
	;

repeat_statement :
	KW_REPEAT statement_list until_clause KW_END KW_REPEAT
	;

for_in_statement :
	KW_FOR identifier KW_IN /*4N*/ parenthesized_query KW_DO statement_list KW_END KW_FOR
	;

break_statement :
	KW_BREAK opt_identifier
	| KW_LEAVE opt_identifier
	;

continue_statement :
	KW_CONTINUE opt_identifier
	| KW_ITERATE opt_identifier
	;

return_statement :
	KW_RETURN
	;

raise_statement :
	KW_RAISE
	| KW_RAISE KW_USING KW_MESSAGE '=' /*4N*/ expression
	;

next_statement_kind :
	next_statement_kind_without_hint
	| hint next_statement_kind_without_hint
	;

next_statement_kind_parenthesized_select :
	'(' /*14L*/ next_statement_kind_parenthesized_select
	| KW_SELECT
	| KW_WITH
	| KW_FROM
	;

next_statement_kind_table :
	KW_TABLE
	;

next_statement_kind_create_table_opt_as_or_semicolon :
	KW_AS
	| ';'
	| /*empty*/
	;

next_statement_kind_create_modifiers :
	opt_or_replace opt_create_scope
	;

next_statement_kind_without_hint :
	KW_EXPLAIN
	| next_statement_kind_parenthesized_select
	| KW_DEFINE KW_TABLE
	| KW_DEFINE_FOR_MACROS KW_MACRO
	| KW_EXECUTE KW_IMMEDIATE
	| KW_EXPORT KW_DATA
	| KW_EXPORT KW_MODEL
	| KW_EXPORT table_or_table_function KW_METADATA
	| KW_INSERT
	| KW_UPDATE
	| KW_DELETE
	| KW_MERGE
	| KW_CLONE KW_DATA
	| KW_LOAD KW_DATA
	| describe_keyword
	| KW_SHOW
	| KW_DROP KW_PRIVILEGE
	| KW_DROP KW_ALL KW_ROW opt_access KW_POLICIES
	| KW_DROP KW_ROW KW_ACCESS KW_POLICY
	| KW_DROP KW_SEARCH KW_INDEX
	| KW_DROP KW_VECTOR KW_INDEX
	| KW_DROP table_or_table_function
	| KW_DROP KW_SNAPSHOT KW_TABLE
	| KW_DROP generic_entity_type
	| KW_DROP schema_object_kind
	| KW_GRANT
	| KW_GRAPH
	| KW_REVOKE
	| KW_RENAME
	| KW_START
	| KW_BEGIN
	| KW_SET KW_TRANSACTION identifier
	| KW_SET identifier '=' /*4N*/
	| KW_SET named_parameter_expression '=' /*4N*/
	| KW_SET system_variable_expression '=' /*4N*/
	| KW_SET '(' /*14L*/
	| KW_COMMIT
	| KW_ROLLBACK
	| KW_START KW_BATCH
	| KW_RUN KW_BATCH
	| KW_ABORT KW_BATCH
	| KW_ALTER KW_APPROX KW_VIEW
	| KW_ALTER KW_CONNECTION
	| KW_ALTER KW_DATABASE
	| KW_ALTER KW_SCHEMA
	| KW_ALTER KW_EXTERNAL KW_SCHEMA
	| KW_ALTER KW_TABLE
	| KW_ALTER KW_PRIVILEGE
	| KW_ALTER KW_ROW
	| KW_ALTER KW_ALL KW_ROW KW_ACCESS KW_POLICIES
	| KW_ALTER KW_VIEW
	| KW_ALTER KW_MATERIALIZED KW_VIEW
	| KW_ALTER generic_entity_type
	| KW_ALTER KW_MODEL
	| KW_CREATE KW_DATABASE
	| KW_CREATE next_statement_kind_create_modifiers KW_CONNECTION
	| KW_CREATE next_statement_kind_create_modifiers opt_aggregate KW_CONSTANT
	| KW_CREATE next_statement_kind_create_modifiers opt_aggregate KW_FUNCTION
	| KW_CREATE next_statement_kind_create_modifiers KW_PROCEDURE
	| KW_CREATE opt_or_replace opt_unique opt_spanner_null_filtered opt_index_type KW_INDEX
	| KW_CREATE opt_or_replace KW_SCHEMA
	| KW_CREATE opt_or_replace generic_entity_type
	| KW_CREATE next_statement_kind_create_modifiers next_statement_kind_table opt_if_not_exists maybe_dashed_path_expression opt_table_element_list opt_like_path_expression opt_clone_table opt_copy_table opt_default_collate_clause opt_partition_by_clause_no_hint opt_cluster_by_clause_no_hint opt_with_connection_clause opt_options_list next_statement_kind_create_table_opt_as_or_semicolon
	| KW_CREATE next_statement_kind_create_modifiers KW_MODEL
	| KW_CREATE next_statement_kind_create_modifiers KW_TABLE KW_FUNCTION
	| KW_CREATE next_statement_kind_create_modifiers KW_EXTERNAL KW_TABLE
	| KW_CREATE next_statement_kind_create_modifiers KW_EXTERNAL KW_SCHEMA
	| KW_CREATE opt_or_replace KW_PRIVILEGE
	| KW_CREATE opt_or_replace KW_ROW opt_access KW_POLICY
	| KW_CREATE next_statement_kind_create_modifiers opt_recursive KW_VIEW
	| KW_CREATE opt_or_replace KW_APPROX opt_recursive KW_VIEW
	| KW_CREATE opt_or_replace KW_MATERIALIZED opt_recursive KW_VIEW
	| KW_CREATE opt_or_replace KW_SNAPSHOT KW_SCHEMA
	| KW_CREATE opt_or_replace KW_SNAPSHOT KW_TABLE
	| KW_CALL
	| KW_RETURN
	| KW_IMPORT
	| KW_MODULE
	| KW_ANALYZE
	| KW_ASSERT
	| KW_TRUNCATE
	| KW_IF
	| KW_WHILE
	| KW_LOOP
	| KW_DECLARE
	| KW_BREAK
	| KW_LEAVE
	| KW_CONTINUE
	| KW_ITERATE
	| KW_RAISE
	| KW_FOR
	| KW_REPEAT
	| label ':' KW_BEGIN
	| label ':' KW_LOOP
	| label ':' KW_WHILE
	| label ':' KW_FOR
	| label ':' KW_REPEAT
	| KW_UNDROP schema_object_kind
	;

spanner_primary_key :
	KW_PRIMARY KW_KEY primary_key_element_list
	;

spanner_index_interleave_clause :
	',' KW_INTERLEAVE KW_IN /*4N*/ maybe_dashed_path_expression
	;

opt_spanner_interleave_in_parent_clause :
	',' KW_INTERLEAVE KW_IN /*4N*/ KW_PARENT maybe_dashed_path_expression opt_foreign_key_on_delete
	| /*empty*/
	;

opt_spanner_table_options :
	spanner_primary_key opt_spanner_interleave_in_parent_clause
	| /*empty*/
	;

opt_spanner_null_filtered :
	KW_NULL_FILTERED
	| /*empty*/
	;

spanner_generated_or_default :
	KW_AS '(' /*14L*/ expression ')' KW_STORED
	| default_column_info
	;

opt_spanner_generated_or_default :
	spanner_generated_or_default
	| /*empty*/
	;

opt_spanner_not_null_attribute :
	not_null_column_attribute
	| /*empty*/
	;

spanner_alter_column_action :
	KW_ALTER KW_COLUMN opt_if_exists identifier column_schema_inner opt_spanner_not_null_attribute opt_spanner_generated_or_default opt_options_list
	;

spanner_set_on_delete_action :
	KW_SET KW_ON KW_DELETE foreign_key_action
	;

%%

%option caseless
%x NOT_SPECIAL WITH_STARTING_WITH_GROUP_ROWS WITH_STARTING_WITH_EXPRESSION

/* These are some basic regex definitions that are used in the lexer rules
   below.
*/

decimal_digit               [0-9]
decimal_digits              {decimal_digit}+
opt_decimal_digits          {decimal_digit}*
hex_digit                   [0-9a-f]
hex_integer                 (0x{hex_digit}+)

dot                         "."
exp_nosign                  e{decimal_digits}
exp_sign                    e[+-]{decimal_digits}
exp                         ({exp_nosign}|{exp_sign})
opt_exp                     {exp}?

/* Floating point formats are identified by the presence of a dot and/or an
   exponent. If there's a dot, there has to be at least one digit either before
   or after the dot. This is covered by the first two regexes. The third regex
   covers digits with an exponent but without a dot. */
decimal_dot                 {decimal_digits}{dot}{opt_decimal_digits}{opt_exp}
dot_decimal                 {dot}{decimal_digits}{opt_exp}
decimal_exp                 {decimal_digits}{exp}
floating_point_literal      {decimal_dot}|{dot_decimal}|{decimal_exp}

/* Whitespace, including Unicode whitespace characters encoded as UTF-8, as well
   as all comments.
   https://www.cs.tut.fi/~jkorpela/chars/spaces.html

   OGHAM SPACE MARK (U+1680) is omitted because it looks like "-".
   MONGOLIAN VOWEL SEPARATOR (U+180E) is omitted because it has no width.
   ZERO WIDTH SPACE (U+200B) is omitted because it has no width.
   ZERO WIDTH NO-BREAK SPACE (U+FEFF) is omitted because it has no width.

   The whitespace rule has a "*" so that we match all consecutive whitespace
   without running YY_USER_ACTION.
*/
utf8_no_break_space            "\xC2\xA0"
utf8_en_quad                   "\xE2\x80\x80"
utf8_em_quad                   "\xE2\x80\x81"
utf8_en_space                  "\xE2\x80\x82"
utf8_em_space                  "\xE2\x80\x83"
utf8_three_per_em_space        "\xE2\x80\x84"
utf8_four_per_em_space         "\xE2\x80\x85"
utf8_six_per_em_space          "\xE2\x80\x86"
utf8_figure_space              "\xE2\x80\x87"
utf8_punctuation_space         "\xE2\x80\x88"
utf8_thin_space                "\xE2\x80\x89"
utf8_hair_space                "\xE2\x80\x8A"
utf8_narrow_no_break_space     "\xE2\x80\xAF"
utf8_medium_mathematical_space "\xE2\x81\x9F"
utf8_ideographic_space         "\xE3\x80\x80"
whitespace_character           ([ \n\r\t\b\f\v]|{utf8_no_break_space}|{utf8_en_quad}|{utf8_em_quad}|{utf8_en_space}|{utf8_em_space}|{utf8_three_per_em_space}|{utf8_four_per_em_space}|{utf8_six_per_em_space}|{utf8_figure_space}|{utf8_punctuation_space}|{utf8_thin_space}|{utf8_hair_space}|{utf8_narrow_no_break_space}|{utf8_medium_mathematical_space}|{utf8_ideographic_space})

/* String/bytes literals and identifiers.

   The abbreviations here:
     sq = single quote(d)
     dq = double quote(d)
     bq = back quote(d)
     3 = triple quoted
     r = raw
     _0 = unterminated versions. They are used to return better error
          messages for unterminated strings.

   For instance, rsq3 means "raw triple single-quoted", or r'''...'''.

   The regexes accept arbitrary escapes instead of trying to narrow it down to
   just the valid set. This is safe because in valid strings the character after
   the escape is *always* eaten, even in raw strings. The actual validation of
   the escapes, and of things like UTF-8 structure, is done in the parser.
   This also allows us to use the same regex for raw strings that we use for any
   other string. Raw strings interpret the escapes differently (they allow all
   escapes and pass them through verbatim), but the termination condition is
   the same: escaped quotes don't count.

   In single quoted strings/bytes we don't accept \n so that a single-line
   unterminated string literal is recognized as an unterminated string literal
   at that point, instead of being bogusly matched up with another quote on a
   subsequent line. However, we do accept escaped newlines. These get a separate
   and nicer error message pointing directly at the escaped newline.
*/
any_escape                (\\(.|\n|\r|\r\n))
sq                        \'
sq3                       {sq}{sq}{sq}
dq                        \"
dq3                       {dq}{dq}{dq}
bq                        \`
backslash                 \\
no_backslash_sq_newline   [^\'\\\n\r]
no_backslash_dq_newline   [^\"\\\n\r]
no_backslash_sq           [^\'\\]
no_backslash_dq           [^\"\\]

/* Strings and bytes: */
sqtext_0           {sq}({no_backslash_sq_newline}|{any_escape})*
sqtext             {sqtext_0}{sq}
dqtext_0           {dq}({no_backslash_dq_newline}|{any_escape})*
dqtext             {dqtext_0}{dq}
sq3text_0          {sq3}(({sq}|{sq}{sq})?({no_backslash_sq}|{any_escape}))*
sq3text            {sq3text_0}{sq3}
dq3text_0          {dq3}(({dq}|{dq}{dq})?({no_backslash_dq}|{any_escape}))*
dq3text            {dq3text_0}{dq3}
string_literal                  r?({sqtext}|{dqtext}|{sq3text}|{dq3text})
bytes_literal                   (b|rb|br)({sqtext}|{dqtext}|{sq3text}|{dq3text})
unterminated_string_literal     ({sqtext_0}|{dqtext_0})
unterminated_triple_quoted_string_literal ({sq3text_0}|{dq3text_0})
unterminated_raw_string_literal r({sqtext_0}|{dqtext_0})
unterminated_triple_quoted_raw_string_literal r({sq3text_0}|{dq3text_0})
unterminated_bytes_literal      b({sqtext_0}|{dqtext_0})
unterminated_triple_quoted_bytes_literal b({sq3text_0}|{dq3text_0})
unterminated_raw_bytes_literal  (rb|br)({sqtext_0}|{dqtext_0})
unterminated_triple_quoted_raw_bytes_literal  (rb|br)({sq3text_0}|{dq3text_0})

/* Identifiers: */
/* no_generalized_identifier is used only for lookahead rules. */
not_generalized_identifier      [^A-Z_0-9]
unquoted_identifier             [A-Z_][A-Z_0-9]*
unquoted_generalized_identifier [A-Z_0-9]+
bqtext_0                        {bq}([^\\\`\r\n]|({any_escape}))*
bqtext                          {bqtext_0}{bq}
identifier                      {unquoted_identifier}|{bqtext}
generalized_identifier          {unquoted_generalized_identifier}|{bqtext}
unterminated_escaped_identifier {bqtext_0}

/* C-style comments using slash+star.
   cs_ prefix is for "c-style comment", shortened to avoid long lines.
   For more information about how this works, see
   "Using one, even more complicated, pattern" from
   http://www.cs.man.ac.uk/~pjj/cs212/ex2_str_comm.html
*/
cs_start              "/*"
cs_not_star           [^*]
cs_star               "*"
cs_not_star_or_slash  [^/*]
cs_slash              "/"
/* Contents of a C-style comment that may embed a * (or a sequence of stars)
   followed by not-a-slash. */
cs_embed_star         ({cs_not_star}*({cs_star}+{cs_not_star_or_slash})*)*
/* Matches the beginning of a comment, to detect unterminated comments. */
cs_comment_begin      {cs_start}{cs_embed_star}{cs_star}*
cs_comment            {cs_start}{cs_embed_star}{cs_star}+{cs_slash}

/* Requiring a newline at the end of dash_coment and pound_comment does not
   cause an error even if the comment comes in the last line of a query,
   thanks to the newline sentinel input (See:
   https://github.com/google/zetasql/blob/master/zetasql/parser/flex_tokenizer.h?l=128).
*/
/* Dash comments using -- */
dash_comment          \-\-[^\r\n]*(\r|\n|\r\n)

/* # comment ignores anything from # to the end of the line. */
pound_comment         #[^\r\n]*(\r|\n|\r\n)

comment               ({cs_comment}|{dash_comment}|{pound_comment})

opt_whitespace                 ({whitespace_character}|{comment})*
whitespace                     ({whitespace_character}|{comment})+
opt_whitespace_no_comments     {whitespace_character}*
whitespace_no_comments         {whitespace_character}+

%%

[ \t\r\n]+	skip()
"--".*	skip()
"/*"(?s:.)*?"*/"	skip()

"^"	'^'
"~"	'~'
"<<"	KW_SHIFT_LEFT
"<="	KW_LESS_EQUALS
"<>"	KW_NOT_EQUALS_SQL_STYLE
"!="	KW_NOT_EQUALS_C_STYLE
"<"	'<'
"="	'='
">="	KW_GREATER_EQUALS
">>"	KW_SHIFT_RIGHT
">"	'>'
"||"	KW_CONCAT_OP
"|"	'|'
"|>"	KW_PIPE
"-="	KW_SUB_ASSIGN
"->"	KW_LAMBDA_ARROW
"=>"	KW_NAMED_ARGUMENT_ASSIGNMENT
"-"	'-'
","	','
";"	';'
":"	':'
"?"	'?'
"/"	'/'
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"@"	'@'
"@@"	KW_DOUBLE_AT
"*"	'*'
"&"	'&'
"+="	KW_ADD_ASSIGN
"+"	'+'

"DEFINE for macros"	KW_DEFINE_FOR_MACROS
KW_EXCEPT_IN_SET_OP	KW_EXCEPT_IN_SET_OP
KW_FULL_IN_SET_OP	KW_FULL_IN_SET_OP
KW_LEFT_IN_SET_OP	KW_LEFT_IN_SET_OP
KW_OPEN_HINT	KW_OPEN_HINT
KW_OPEN_INTEGER_HINT	KW_OPEN_INTEGER_HINT
KW_OPTIONS_IN_SELECT_WITH_OPTIONS	KW_OPTIONS_IN_SELECT_WITH_OPTIONS
KW_QUALIFY_NONRESERVED	KW_QUALIFY_NONRESERVED
KW_QUALIFY_RESERVED	KW_QUALIFY_RESERVED
KW_REPLACE_AFTER_INSERT	KW_REPLACE_AFTER_INSERT
KW_UPDATE_AFTER_INSERT	KW_UPDATE_AFTER_INSERT

"ABORT"	KW_ABORT
"ACCESS"	KW_ACCESS
"ACTION"	KW_ACTION
"ADD"	KW_ADD
"AGGREGATE"	KW_AGGREGATE
"ALL"	KW_ALL
"ALTER"	KW_ALTER
"ALWAYS"	KW_ALWAYS
"ANALYZE"	KW_ANALYZE
"AND"	KW_AND
"ANY"	KW_ANY
"APPROX"	KW_APPROX
"ARE"	KW_ARE
"ARRAY"	KW_ARRAY
"ASC"	KW_ASC
"AS"	KW_AS
"ASSERT"	KW_ASSERT
"ASSERT_ROWS_MODIFIED"	KW_ASSERT_ROWS_MODIFIED
"AT"	KW_AT
"BATCH"	KW_BATCH
"BEGIN"	KW_BEGIN
"BETWEEN"	KW_BETWEEN
"BIGDECIMAL"	KW_BIGDECIMAL
"BIGNUMERIC"	KW_BIGNUMERIC
"BREAK"	KW_BREAK
"BY"	KW_BY
"CALL"	KW_CALL
"CASCADE"	KW_CASCADE
"CASE"	KW_CASE
"CAST"	KW_CAST
"CHECK"	KW_CHECK
"CLAMPED"	KW_CLAMPED
"CLONE"	KW_CLONE
"CLUSTER"	KW_CLUSTER
"COLLATE"	KW_COLLATE
"COLUMN"	KW_COLUMN
"COLUMNS"	KW_COLUMNS
"COMMIT"	KW_COMMIT
"CONNECTION"	KW_CONNECTION
"CONSTANT"	KW_CONSTANT
"CONSTRAINT"	KW_CONSTRAINT
"CONTINUE"	KW_CONTINUE
"COPY"	KW_COPY
"CORRESPONDING"	KW_CORRESPONDING
"CREATE"	KW_CREATE
"CROSS"	KW_CROSS
"CUBE"	KW_CUBE
"CURRENT"	KW_CURRENT
"CYCLE"	KW_CYCLE
"DATABASE"	KW_DATABASE
"DATA"	KW_DATA
"DATE"	KW_DATE
"DATETIME"	KW_DATETIME
"DECIMAL"	KW_DECIMAL
"DECLARE"	KW_DECLARE
"DEFAULT"	KW_DEFAULT
"DEFINE"	KW_DEFINE
"DEFINER"	KW_DEFINER
"DELETE"	KW_DELETE
"DELETION"	KW_DELETION
"DEPTH"	KW_DEPTH
"DESC"	KW_DESC
"DESCRIBE"	KW_DESCRIBE
"DESCRIPTOR"	KW_DESCRIPTOR
"DETERMINISTIC"	KW_DETERMINISTIC
"DISTINCT"	KW_DISTINCT
"DO"	KW_DO
"DROP"	KW_DROP
"ELSEIF"	KW_ELSEIF
"ELSE"	KW_ELSE
"END"	KW_END
"ENFORCED"	KW_ENFORCED
"ENUM"	KW_ENUM
"ERROR"	KW_ERROR
"EXCEPTION"	KW_EXCEPTION
"EXCEPT"	KW_EXCEPT
"EXCLUDE"	KW_EXCLUDE
"EXECUTE"	KW_EXECUTE
"EXISTS"	KW_EXISTS
"EXPLAIN"	KW_EXPLAIN
"EXPORT"	KW_EXPORT
"EXTEND"	KW_EXTEND
"EXTERNAL"	KW_EXTERNAL
"EXTRACT"	KW_EXTRACT
"FALSE"	KW_FALSE
"FILES"	KW_FILES
"FILL"	KW_FILL
"FILTER"	KW_FILTER
"FIRST"	KW_FIRST
"FOLLOWING"	KW_FOLLOWING
"FOREIGN"	KW_FOREIGN
"FOR"	KW_FOR
"FORMAT"	KW_FORMAT
"FROM"	KW_FROM
"FUNCTION"	KW_FUNCTION
"FULL"	KW_FULL
"GENERATED"	KW_GENERATED
"GRANT"	KW_GRANT
"GRAPH"	KW_GRAPH
"GROUPING"	KW_GROUPING
"GROUP"	KW_GROUP
"GROUP_ROWS"	KW_GROUP_ROWS
"HASH"	KW_HASH
"HAVING"	KW_HAVING
"HIDDEN"	KW_HIDDEN
"IDENTITY"	KW_IDENTITY
"IF"	KW_IF
"IGNORE"	KW_IGNORE
"IMMEDIATE"	KW_IMMEDIATE
"IMMUTABLE"	KW_IMMUTABLE
"IMPORT"	KW_IMPORT
"INCLUDE"	KW_INCLUDE
"INCREMENT"	KW_INCREMENT
"INDEX"	KW_INDEX
"IN"	KW_IN
"INNER"	KW_INNER
"INOUT"	KW_INOUT
"INPUT"	KW_INPUT
"INSERT"	KW_INSERT
"INTERLEAVE"	KW_INTERLEAVE
"INTERSECT"	KW_INTERSECT
"INTERVAL"	KW_INTERVAL
"INTO"	KW_INTO
"INVOKER"	KW_INVOKER
"IS"	KW_IS
"ISOLATION"	KW_ISOLATION
"ITERATE"	KW_ITERATE
"JOIN"	KW_JOIN
"JSON"	KW_JSON
"KEY"	KW_KEY
"LANGUAGE"	KW_LANGUAGE
"LAST"	KW_LAST
"LEAVE"	KW_LEAVE
"LEFT"	KW_LEFT
"LEVEL"	KW_LEVEL
"LIKE"	KW_LIKE
"LIMIT"	KW_LIMIT
"LOAD"	KW_LOAD
"LOOKUP"	KW_LOOKUP
"LOOP"	KW_LOOP
"MACRO"	KW_MACRO
"MAP"	KW_MAP
"MATCHED"	KW_MATCHED
"MATCH"	KW_MATCH
KW_MATCH_RECOGNIZE_RESERVED	KW_MATCH_RECOGNIZE_RESERVED
KW_MATCH_RECOGNIZE_NONRESERVED	KW_MATCH_RECOGNIZE_NONRESERVED
"MATERIALIZED"	KW_MATERIALIZED
"MAX"	KW_MAX
"MAXVALUE"	KW_MAXVALUE
"MEASURES"	KW_MEASURES
"MERGE"	KW_MERGE
"MESSAGE"	KW_MESSAGE
"METADATA"	KW_METADATA
"MIN"	KW_MIN
"MINVALUE"	KW_MINVALUE
"MODEL"	KW_MODEL
"MODULE"	KW_MODULE
"NATURAL"	KW_NATURAL
"NEW"	KW_NEW
"NO"	KW_NO
"NOT"	KW_NOT

"NOT"\s+("BETWEEN"|"IN"|"LIKE"|"DISTINCT")<NOT_SPECIAL> reject()
<NOT_SPECIAL>{
	"NOT"<INITIAL>	KW_NOT_SPECIAL
}

"NULL_FILTERED"	KW_NULL_FILTERED
"NULL"	KW_NULL
"NULLS"	KW_NULLS
"NUMERIC"	KW_NUMERIC
"OFFSET"	KW_OFFSET
"OF"	KW_OF
"ON"	KW_ON
"ONLY"	KW_ONLY
"OPTIONS"	KW_OPTIONS
"ORDER"	KW_ORDER
"OR"	KW_OR
"OUTER"	KW_OUTER
"OUT"	KW_OUT
"OUTPUT"	KW_OUTPUT
"OVER"	KW_OVER
"OVERWRITE"	KW_OVERWRITE
"PARENT"	KW_PARENT
"PARTITION"	KW_PARTITION
"PARTITIONS"	KW_PARTITIONS
"PATTERN"	KW_PATTERN
"PERCENT"	KW_PERCENT
"PIVOT"	KW_PIVOT
"POLICIES"	KW_POLICIES
"POLICY"	KW_POLICY
"PRECEDING"	KW_PRECEDING
"PRIMARY"	KW_PRIMARY
"PRIVATE"	KW_PRIVATE
"PRIVILEGE"	KW_PRIVILEGE
"PRIVILEGES"	KW_PRIVILEGES
"PROCEDURE"	KW_PROCEDURE
"PROJECT"	KW_PROJECT
"PROTO"	KW_PROTO
"PUBLIC"	KW_PUBLIC
"RAISE"	KW_RAISE
"RANGE"	KW_RANGE
"READ"	KW_READ
"RECURSIVE"	KW_RECURSIVE
"REFERENCES"	KW_REFERENCES
"REMOTE"	KW_REMOTE
"REMOVE"	KW_REMOVE
"RENAME"	KW_RENAME
"REPEATABLE"	KW_REPEATABLE
"REPEAT"	KW_REPEAT
"REPLACE_FIELDS"	KW_REPLACE_FIELDS
"REPLACE"	KW_REPLACE
"REPLICA"	KW_REPLICA
"REPORT"	KW_REPORT
"RESPECT"	KW_RESPECT
"RESTRICTION"	KW_RESTRICTION
"RESTRICT"	KW_RESTRICT
"RETURN"	KW_RETURN
"RETURNS"	KW_RETURNS
"REVOKE"	KW_REVOKE
"RIGHT"	KW_RIGHT
"ROLLBACK"	KW_ROLLBACK
"ROLLUP"	KW_ROLLUP
"ROW"	KW_ROW
"ROWS"	KW_ROWS
"RUN"	KW_RUN
"SAFE_CAST"	KW_SAFE_CAST
"SCHEMA"	KW_SCHEMA
"SEARCH"	KW_SEARCH
"SECURITY"	KW_SECURITY
"SELECT"	KW_SELECT
"SEQUENCE"	KW_SEQUENCE
"SET"	KW_SET
"SETS"	KW_SETS
"SHOW"	KW_SHOW
"SIMPLE"	KW_SIMPLE
"SNAPSHOT"	KW_SNAPSHOT
"SOME"	KW_SOME
"SOURCE"	KW_SOURCE
"SQL"	KW_SQL
"STABLE"	KW_STABLE
"START"	KW_START
"STATIC_DESCRIBE"	KW_STATIC_DESCRIBE
"STORED"	KW_STORED
"STORING"	KW_STORING
"STRICT"	KW_STRICT
"STRUCT"	KW_STRUCT
"SYSTEM"	KW_SYSTEM
"SYSTEM_TIME"	KW_SYSTEM_TIME
"TABLE"	KW_TABLE
"TABLESAMPLE"	KW_TABLESAMPLE
"TABLES"	KW_TABLES
"TARGET"	KW_TARGET
"TEMP"	KW_TEMP
"TEMPORARY"	KW_TEMPORARY
"THEN"	KW_THEN
"TIME"	KW_TIME
"TIMESTAMP"	KW_TIMESTAMP
"TO"	KW_TO
"TRANSACTION"	KW_TRANSACTION
"TRANSFORM"	KW_TRANSFORM
"TRUE"	KW_TRUE
"TRUNCATE"	KW_TRUNCATE
"TYPE"	KW_TYPE
"UNBOUNDED"	KW_UNBOUNDED
"UNDROP"	KW_UNDROP
"UNION"	KW_UNION
"UNIQUE"	KW_UNIQUE
"UNKNOWN"	KW_UNKNOWN
"UNNEST"	KW_UNNEST
"UNPIVOT"	KW_UNPIVOT
"UNTIL"	KW_UNTIL
"UPDATE"	KW_UPDATE
"USING"	KW_USING
"VALUE"	KW_VALUE
"VALUES"	KW_VALUES
"VECTOR"	KW_VECTOR
"VIEW"	KW_VIEW
"VIEWS"	KW_VIEWS
"VOLATILE"	KW_VOLATILE
"WEIGHT"	KW_WEIGHT
"WHEN"	KW_WHEN
"WHERE"	KW_WHERE
"WHILE"	KW_WHILE
"WINDOW"	KW_WINDOW
"WITH"	KW_WITH

"WITH"\s+"GROUP"<WITH_STARTING_WITH_GROUP_ROWS> reject()
<WITH_STARTING_WITH_GROUP_ROWS>{
	"WITH"<INITIAL>	KW_WITH_STARTING_WITH_GROUP_ROWS
}

"WITH"\s*"("<WITH_STARTING_WITH_EXPRESSION> reject()
<WITH_STARTING_WITH_EXPRESSION>{
	"WITH"<INITIAL>	KW_WITH_STARTING_WITH_EXPRESSION
}

"WRITE"	KW_WRITE
"ZONE"	KW_ZONE

MACRO_BODY_TOKEN	MACRO_BODY_TOKEN
MODE_EXPRESSION	MODE_EXPRESSION
MODE_NEXT_SCRIPT_STATEMENT	MODE_NEXT_SCRIPT_STATEMENT
MODE_NEXT_STATEMENT_KIND	MODE_NEXT_STATEMENT_KIND
MODE_NEXT_STATEMENT	MODE_NEXT_STATEMENT
MODE_SCRIPT	MODE_SCRIPT
MODE_STATEMENT	MODE_STATEMENT
MODE_TYPE	MODE_TYPE
OPEN_INTEGER_PREFIX_HINT	OPEN_INTEGER_PREFIX_HINT
xxx_PRIMARY_PRECEDENCE	PRIMARY_PRECEDENCE
SCRIPT_LABEL	SCRIPT_LABEL
xxx_UNARY_NOT_PRECEDENCE	UNARY_NOT_PRECEDENCE
xxx_UNARY_PRECEDENCE	UNARY_PRECEDENCE
xxx_DOUBLE_AT_PRECEDENCE	DOUBLE_AT_PRECEDENCE

{bytes_literal}	BYTES_LITERAL
{floating_point_literal}	FLOATING_POINT_LITERAL
{decimal_digits}|{hex_integer}	INTEGER_LITERAL

{string_literal}	STRING_LITERAL

{identifier}	IDENTIFIER

%%
