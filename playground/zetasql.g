//From: https://github.com/google/zetasql/blob/f6df6971a205790966e73eda0134f05a022d0e6a/zetasql/parser/bison_parser.y
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

%token KW_DEFINE_FOR_MACROS
%token KW_EXCEPT_IN_SET_OP
%token KW_FULL_IN_SET_OP
%token KW_LEFT_IN_SET_OP
%token KW_OPTIONS_IN_SELECT_WITH_OPTIONS
%token KW_OPEN_HINT
%token KW_OPEN_INTEGER_HINT
%token KW_LEFT
%token KW_DOUBLE_AT
%token KW_QUALIFY_RESERVED
%token KW_QUALIFY_NONRESERVED
%token KW_WITH_STARTING_WITH_EXPRESSION
%token KW_NAMED_ARGUMENT_ASSIGNMENT
%token KW_WITH_STARTING_WITH_GROUP_ROWS
%token KW_REPLACE_AFTER_INSERT
%token KW_UPDATE_AFTER_INSERT

%token BYTES_LITERAL
%token FLOATING_POINT_LITERAL
%token IDENTIFIER
%token INTEGER_LITERAL
%token MACRO_BODY_TOKEN
%token MODE_EXPRESSION
%token MODE_NEXT_SCRIPT_STATEMENT
%token MODE_NEXT_STATEMENT
%token MODE_NEXT_STATEMENT_KIND
%token MODE_SCRIPT
%token MODE_STATEMENT
%token MODE_TYPE
%token OPEN_INTEGER_PREFIX_HINT
%token SCRIPT_LABEL
%token STRING_LITERAL

%left /*1*/ "OR"
%left /*2*/ "AND"
%precedence /*3*/ UNARY_NOT_PRECEDENCE
%nonassoc /*4*/ '=' "+=" "-=" "!=" "<>" '<' "<=" '>' ">=" "LIKE" "IN" "DISTINCT" "BETWEEN" "IS" "NOT_SPECIAL"
%left /*5*/ '|'
%left /*6*/ '^'
%left /*7*/ '&'
%left /*8*/ "<<" ">>"
%left /*9*/ '+' '-'
%left /*10*/ "||"
%left /*11*/ '*' '/'
%precedence /*12*/ UNARY_PRECEDENCE
%precedence /*13*/ DOUBLE_AT_PRECEDENCE
%left /*14*/ '(' '[' '.' PRIMARY_PRECEDENCE

%start start_mode

%%

start_mode :
    input //to parse multiple statements on the playground
	| MODE_STATEMENT sql_statement
	| MODE_SCRIPT script
	| MODE_NEXT_STATEMENT next_statement
	| MODE_NEXT_SCRIPT_STATEMENT next_script_statement
	| MODE_NEXT_STATEMENT_KIND next_statement_kind
	| MODE_EXPRESSION expression
	| MODE_TYPE type
	;

input :
    sql_statement
    | input sql_statement
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
	| "DEFINE" "MACRO"
	| statement_level_hint "DEFINE" "MACRO"
	| statement_level_hint KW_DEFINE_FOR_MACROS "MACRO"
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
	KW_DEFINE_FOR_MACROS "MACRO" MACRO_BODY_TOKEN macro_body
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
	"SET" "OPTIONS" options_list
	| "SET" "AS" generic_entity_body
	| "ADD" table_constraint_spec
	| "ADD" primary_key_spec
	| "ADD" "CONSTRAINT" opt_if_not_exists identifier primary_key_or_table_constraint_spec
	| "DROP" "CONSTRAINT" opt_if_exists identifier
	| "DROP" "PRIMARY" "KEY" opt_if_exists
	| "ALTER" "CONSTRAINT" opt_if_exists identifier constraint_enforcement
	| "ALTER" "CONSTRAINT" opt_if_exists identifier "SET" "OPTIONS" options_list
	| "ADD" "COLUMN" opt_if_not_exists table_column_definition opt_column_position opt_fill_using_expression
	| "DROP" "COLUMN" opt_if_exists identifier
	| "RENAME" "COLUMN" opt_if_exists identifier "TO" identifier
	| "ALTER" "COLUMN" opt_if_exists identifier "SET" "DATA" "TYPE" field_schema
	| "ALTER" "COLUMN" opt_if_exists identifier "SET" "OPTIONS" options_list
	| "ALTER" "COLUMN" opt_if_exists identifier "SET" "DEFAULT" expression
	| "ALTER" "COLUMN" opt_if_exists identifier "DROP" "DEFAULT"
	| "ALTER" "COLUMN" opt_if_exists identifier "DROP" "NOT" "NULL"
	| "ALTER" "COLUMN" opt_if_exists identifier "DROP" "GENERATED"
	| "RENAME" "TO" path_expression
	| "SET" "DEFAULT" collate_clause
	| "ADD" "ROW" "DELETION" "POLICY" opt_if_not_exists '(' /*14L*/ expression ')'
	| "REPLACE" "ROW" "DELETION" "POLICY" opt_if_exists '(' /*14L*/ expression ')'
	| "DROP" "ROW" "DELETION" "POLICY" opt_if_exists
	| "ALTER" generic_sub_entity_type opt_if_exists identifier alter_action
	| "ADD" generic_sub_entity_type opt_if_not_exists identifier opt_options_list
	| "DROP" generic_sub_entity_type opt_if_exists identifier
	| spanner_alter_column_action
	| spanner_set_on_delete_action
	;

alter_action_list :
	alter_action
	| alter_action_list ',' alter_action
	;

privilege_restriction_alter_action :
	restrict_to_clause
	| "ADD" opt_if_not_exists possibly_empty_grantee_list
	| "REMOVE" opt_if_exists possibly_empty_grantee_list
	;

privilege_restriction_alter_action_list :
	privilege_restriction_alter_action
	| privilege_restriction_alter_action_list ',' privilege_restriction_alter_action
	;

row_access_policy_alter_action :
	grant_to_clause
	| "FILTER" "USING" '(' /*14L*/ expression ')'
	| "REVOKE" "FROM" '(' /*14L*/ grantee_list ')'
	| "REVOKE" "FROM" "ALL"
	| "RENAME" "TO" identifier
	;

row_access_policy_alter_action_list :
	row_access_policy_alter_action
	| row_access_policy_alter_action_list ',' row_access_policy_alter_action
	;

schema_object_kind :
	"AGGREGATE" "FUNCTION"
	| "APPROX" "VIEW"
	| "CONSTANT"
	| "DATABASE"
	| "EXTERNAL" table_or_table_function
	| "EXTERNAL" "SCHEMA"
	| "FUNCTION"
	| "INDEX"
	| "MATERIALIZED" "VIEW"
	| "MODEL"
	| "PROCEDURE"
	| "SCHEMA"
	| "VIEW"
	;

alter_statement :
	"ALTER" table_or_table_function opt_if_exists maybe_dashed_path_expression alter_action_list
	| "ALTER" schema_object_kind opt_if_exists path_expression alter_action_list
	| "ALTER" generic_entity_type opt_if_exists path_expression alter_action_list
	| "ALTER" generic_entity_type opt_if_exists alter_action_list
	| "ALTER" "PRIVILEGE" "RESTRICTION" opt_if_exists "ON" privilege_list "ON" identifier path_expression privilege_restriction_alter_action_list
	| "ALTER" "ROW" "ACCESS" "POLICY" opt_if_exists identifier "ON" path_expression row_access_policy_alter_action_list
	| "ALTER" "ALL" "ROW" "ACCESS" "POLICIES" "ON" path_expression row_access_policy_alter_action
	;

opt_input_output_clause :
	"INPUT" table_element_list "OUTPUT" table_element_list
	| /*empty*/
	;

opt_transform_clause :
	"TRANSFORM" '(' /*14L*/ select_list ')'
	| /*empty*/
	;

assert_statement :
	"ASSERT" expression opt_description
	;

opt_description :
	"AS" string_literal
	| /*empty*/
	;

analyze_statement :
	"ANALYZE" opt_options_list opt_table_and_column_info_list
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
	"READ" "ONLY"
	| "READ" "WRITE"
	| "ISOLATION" "LEVEL" identifier
	| "ISOLATION" "LEVEL" identifier identifier
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
	"START" transaction_keyword
	| "BEGIN" opt_transaction_keyword
	;

transaction_keyword :
	"TRANSACTION"
	;

opt_transaction_keyword :
	transaction_keyword
	| /*empty*/
	;

set_statement :
	"SET" "TRANSACTION" transaction_mode_list
	| "SET" identifier '=' /*4N*/ expression
	| "SET" named_parameter_expression '=' /*4N*/ expression
	| "SET" system_variable_expression '=' /*4N*/ expression
	| "SET" '(' /*14L*/ identifier_list ')' '=' /*4N*/ expression
	| "SET" '(' /*14L*/ ')'
	| "SET" identifier ',' identifier_list '=' /*4N*/
	;

commit_statement :
	"COMMIT" opt_transaction_keyword
	;

rollback_statement :
	"ROLLBACK" opt_transaction_keyword
	;

start_batch_statement :
	"START" "BATCH" opt_identifier
	;

run_batch_statement :
	"RUN" "BATCH"
	;

abort_batch_statement :
	"ABORT" "BATCH"
	;

create_constant_statement :
	"CREATE" opt_or_replace opt_create_scope "CONSTANT" opt_if_not_exists path_expression '=' /*4N*/ expression
	;

create_database_statement :
	"CREATE" "DATABASE" path_expression opt_options_list
	;

unordered_options_body :
	options opt_as_sql_function_body_or_string
	| as_sql_function_body_or_string opt_options_list
	| /*empty*/
	;

create_function_statement :
	"CREATE" opt_or_replace opt_create_scope opt_aggregate "FUNCTION" opt_if_not_exists function_declaration opt_function_returns opt_sql_security_clause opt_determinism_level opt_language_or_remote_with_connection unordered_options_body
	;

opt_aggregate :
	"AGGREGATE"
	| /*empty*/
	;

opt_not_aggregate :
	"NOT" "AGGREGATE"
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
	| "LANGUAGE" identifier opt_as_code
	;

opt_external_security_clause :
	"EXTERNAL" "SECURITY" external_security_clause_kind
	| /*empty*/
	;

external_security_clause_kind :
	"INVOKER"
	| "DEFINER"
	;

create_procedure_statement :
	"CREATE" opt_or_replace opt_create_scope "PROCEDURE" opt_if_not_exists path_expression procedure_parameters opt_external_security_clause opt_with_connection_clause opt_options_list begin_end_block_or_language_as_code
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
	"IN" /*4N*/
	| "OUT"
	| "INOUT"
	| /*empty*/
	;

opt_returns :
	"RETURNS" type_or_tvf_schema
	| /*empty*/
	;

opt_function_returns :
	opt_returns
	;

opt_determinism_level :
	"DETERMINISTIC"
	| "NOT" "DETERMINISTIC"
	| "IMMUTABLE"
	| "STABLE"
	| "VOLATILE"
	| /*empty*/
	;

language :
	"LANGUAGE" identifier
	;

opt_language :
	language
	| /*empty*/
	;

remote_with_connection_clause :
	"REMOTE" opt_with_connection_clause
	| with_connection_clause
	;

opt_remote_with_connection_clause :
	remote_with_connection_clause
	| /*empty*/
	;

opt_language_or_remote_with_connection :
	"LANGUAGE" identifier opt_remote_with_connection_clause
	| remote_with_connection_clause opt_language
	| /*empty*/
	;

opt_sql_security_clause :
	"SQL" "SECURITY" sql_security_clause_kind
	| /*empty*/
	;

sql_security_clause_kind :
	"INVOKER"
	| "DEFINER"
	;

as_sql_function_body_or_string :
	"AS" sql_function_body
	| "AS" string_literal
	;

opt_as_sql_function_body_or_string :
	as_sql_function_body_or_string
	| /*empty*/
	;

opt_as_code :
	"AS" string_literal
	| /*empty*/
	;

path_expression_or_string :
	path_expression
	| string_literal
	;

path_expression_or_default :
	path_expression
	| "DEFAULT"
	;

sql_function_body :
	'(' /*14L*/ expression ')'
	| '(' /*14L*/ "SELECT"
	;

restrict_to_clause :
	"RESTRICT" "TO" possibly_empty_grantee_list
	;

opt_restrict_to_clause :
	restrict_to_clause
	| /*empty*/
	;

grant_to_clause :
	"GRANT" "TO" '(' /*14L*/ grantee_list ')'
	;

create_row_access_policy_grant_to_clause :
	grant_to_clause
	| "TO" grantee_list
	;

opt_create_row_access_policy_grant_to_clause :
	create_row_access_policy_grant_to_clause
	| /*empty*/
	;

opt_filter :
	"FILTER"
	| /*empty*/
	;

filter_using_clause :
	opt_filter "USING" '(' /*14L*/ expression ')'
	;

create_privilege_restriction_statement :
	"CREATE" opt_or_replace "PRIVILEGE" "RESTRICTION" opt_if_not_exists "ON" privilege_list "ON" identifier path_expression opt_restrict_to_clause
	;

create_row_access_policy_statement :
	"CREATE" opt_or_replace "ROW" opt_access "POLICY" opt_if_not_exists opt_identifier "ON" path_expression opt_create_row_access_policy_grant_to_clause filter_using_clause
	;

with_partition_columns_clause :
	"WITH" "PARTITION" "COLUMNS" opt_table_element_list
	;

with_connection_clause :
	"WITH" connection_clause
	;

opt_external_table_with_clauses :
	with_partition_columns_clause with_connection_clause
	| with_partition_columns_clause
	| with_connection_clause
	| /*empty*/
	;

create_external_table_statement :
	"CREATE" opt_or_replace opt_create_scope "EXTERNAL" "TABLE" opt_if_not_exists maybe_dashed_path_expression opt_table_element_list opt_like_path_expression opt_default_collate_clause opt_external_table_with_clauses opt_options_list
	;

create_external_table_function_statement :
	"CREATE" opt_or_replace opt_create_scope "EXTERNAL" "TABLE" "FUNCTION"
	;

create_index_statement :
	"CREATE" opt_or_replace opt_unique opt_spanner_null_filtered opt_index_type "INDEX" opt_if_not_exists path_expression "ON" path_expression opt_as_alias opt_index_unnest_expression_list index_order_by opt_index_storing_list opt_options_list opt_spanner_index_interleave_clause
	;

create_schema_statement :
	"CREATE" opt_or_replace "SCHEMA" opt_if_not_exists path_expression opt_default_collate_clause opt_options_list
	;

create_external_schema_statement :
	"CREATE" opt_or_replace opt_create_scope "EXTERNAL" "SCHEMA" opt_if_not_exists path_expression opt_with_connection_clause options
	;

undrop_statement :
	"UNDROP" schema_object_kind opt_if_not_exists path_expression opt_at_system_time opt_options_list
	;

create_snapshot_statement :
	"CREATE" opt_or_replace "SNAPSHOT" "TABLE" opt_if_not_exists maybe_dashed_path_expression "CLONE" clone_data_source opt_options_list
	| "CREATE" opt_or_replace "SNAPSHOT" schema_object_kind opt_if_not_exists maybe_dashed_path_expression "CLONE" clone_data_source opt_options_list
	;

unordered_language_options :
	language opt_options_list
	| options opt_language
	| /*empty*/
	;

create_table_function_statement :
	"CREATE" opt_or_replace opt_create_scope "TABLE" "FUNCTION" opt_if_not_exists path_expression opt_function_parameters opt_returns opt_sql_security_clause unordered_language_options opt_as_query_or_string
	;

create_table_statement :
	"CREATE" opt_or_replace opt_create_scope "TABLE" opt_if_not_exists maybe_dashed_path_expression opt_table_element_list opt_spanner_table_options opt_like_path_expression opt_clone_table opt_copy_table opt_default_collate_clause opt_partition_by_clause_no_hint opt_cluster_by_clause_no_hint opt_ttl_clause opt_with_connection_clause opt_options_list opt_as_query
	;

append_or_overwrite :
	"INTO"
	| "OVERWRITE"
	;

aux_load_data_from_files_options_list :
	"FROM" "FILES" options_list
	;

opt_overwrite :
	"OVERWRITE"
	| /*empty*/
	;

load_data_partitions_clause :
	opt_overwrite "PARTITIONS" '(' /*14L*/ expression ')'
	;

opt_load_data_partitions_clause :
	load_data_partitions_clause
	| /*empty*/
	;

maybe_dashed_path_expression_with_scope :
	"TEMP" "TABLE" maybe_dashed_path_expression
	| "TEMPORARY" "TABLE" maybe_dashed_path_expression
	| maybe_dashed_path_expression
	;

aux_load_data_statement :
	"LOAD" "DATA" append_or_overwrite maybe_dashed_path_expression_with_scope opt_table_element_list opt_load_data_partitions_clause opt_collate_clause opt_partition_by_clause_no_hint opt_cluster_by_clause_no_hint opt_options_list aux_load_data_from_files_options_list opt_external_table_with_clauses
	;

generic_entity_type_unchecked :
	IDENTIFIER
	| "PROJECT"
	;

generic_entity_type :
	generic_entity_type_unchecked
	;

sub_entity_type_identifier :
	IDENTIFIER
	| "REPLICA"
	;

generic_sub_entity_type :
	sub_entity_type_identifier
	;

generic_entity_body :
	json_literal
	| string_literal
	;

opt_generic_entity_body :
	"AS" generic_entity_body
	| /*empty*/
	;

create_entity_statement :
	"CREATE" opt_or_replace generic_entity_type opt_if_not_exists path_expression opt_options_list opt_generic_entity_body
	;

create_model_statement :
	"CREATE" opt_or_replace opt_create_scope "MODEL" opt_if_not_exists path_expression opt_input_output_clause opt_transform_clause opt_remote_with_connection_clause opt_options_list opt_as_query_or_aliased_query_list
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
	| "INTERVAL"
	;

array_column_schema_inner :
	"ARRAY" template_type_open field_schema template_type_close
	;

range_column_schema_inner :
	"RANGE" template_type_open field_schema template_type_close
	;

struct_column_field :
	column_schema_inner opt_collate_clause opt_field_attributes
	| identifier field_schema
	;

struct_column_schema_prefix :
	"STRUCT" template_type_open struct_column_field
	| struct_column_schema_prefix ',' struct_column_field
	;

struct_column_schema_inner :
	"STRUCT" template_type_open template_type_close
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
	"GENERATED" "AS"
	| "GENERATED" "ALWAYS" "AS"
	| "GENERATED" "BY" "DEFAULT" "AS"
	| "AS"
	;

stored_mode :
	"STORED" "VOLATILE"
	| "STORED"
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
	"START" "WITH" signed_numerical_literal
	| /*empty*/
	;

opt_increment_by :
	"INCREMENT" "BY" signed_numerical_literal
	| /*empty*/
	;

opt_maxvalue :
	"MAXVALUE" signed_numerical_literal
	| /*empty*/
	;

opt_minvalue :
	"MINVALUE" signed_numerical_literal
	| /*empty*/
	;

opt_cycle :
	"CYCLE"
	| "NO" "CYCLE"
	| /*empty*/
	;

identity_column_info :
	"IDENTITY" '(' /*14L*/ opt_start_with opt_increment_by opt_maxvalue opt_minvalue opt_cycle ')'
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
	"DEFAULT" expression
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
	"PRIMARY" "KEY"
	;

foreign_key_column_attribute :
	opt_constraint_identity foreign_key_reference
	;

hidden_column_attribute :
	"HIDDEN"
	;

not_null_column_attribute :
	"NOT" "NULL"
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
	"PRECEDING" identifier
	| "FOLLOWING" identifier
	;

opt_column_position :
	column_position
	| /*empty*/
	;

fill_using_expression :
	"FILL" "USING" expression
	;

opt_fill_using_expression :
	fill_using_expression
	| /*empty*/
	;

table_constraint_spec :
	"CHECK" '(' /*14L*/ expression ')' opt_constraint_enforcement opt_options_list
	| "FOREIGN" "KEY" column_list foreign_key_reference opt_constraint_enforcement opt_options_list
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
	"PRIMARY" "KEY" primary_key_element_list opt_constraint_enforcement opt_options_list
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
	"REFERENCES" path_expression column_list opt_foreign_key_match opt_foreign_key_actions
	;

opt_foreign_key_match :
	"MATCH" foreign_key_match_mode
	| /*empty*/
	;

foreign_key_match_mode :
	"SIMPLE"
	| "FULL"
	| "NOT_SPECIAL" /*4N*/ "DISTINCT" /*4N*/
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
	"ON" "UPDATE" foreign_key_action
	;

foreign_key_on_delete :
	"ON" "DELETE" foreign_key_action
	;

foreign_key_action :
	"NO" "ACTION"
	| "RESTRICT"
	| "CASCADE"
	| "SET" "NULL"
	;

opt_constraint_identity :
	"CONSTRAINT" identifier
	| /*empty*/
	;

opt_constraint_enforcement :
	constraint_enforcement
	| /*empty*/
	;

constraint_enforcement :
	"ENFORCED"
	| "NOT" "ENFORCED"
	;

table_or_table_function :
	"TABLE" "FUNCTION"
	| "TABLE"
	;

tvf_schema_column :
	identifier type
	| type
	;

tvf_schema_prefix :
	"TABLE" template_type_open tvf_schema_column
	| tvf_schema_prefix ',' tvf_schema_column
	;

tvf_schema :
	tvf_schema_prefix template_type_close
	;

opt_recursive :
	"RECURSIVE"
	| /*empty*/
	;

create_view_statement :
	"CREATE" opt_or_replace opt_create_scope opt_recursive "VIEW" opt_if_not_exists maybe_dashed_path_expression opt_column_with_options_list opt_sql_security_clause opt_options_list as_query
	| "CREATE" opt_or_replace "MATERIALIZED" opt_recursive "VIEW" opt_if_not_exists maybe_dashed_path_expression opt_column_with_options_list opt_sql_security_clause opt_partition_by_clause_no_hint opt_cluster_by_clause_no_hint opt_options_list "AS" query_or_replica_source
	| "CREATE" opt_or_replace "APPROX" opt_recursive "VIEW" opt_if_not_exists maybe_dashed_path_expression opt_column_with_options_list opt_sql_security_clause opt_options_list as_query
	;

query_or_replica_source :
	query
	| "REPLICA" "OF" maybe_dashed_path_expression
	;

as_query :
	"AS" query
	;

opt_as_query :
	as_query
	| /*empty*/
	;

opt_as_query_or_string :
	as_query
	| "AS" string_literal
	| /*empty*/
	;

opt_as_query_or_aliased_query_list :
	as_query
	| "AS" '(' /*14L*/ aliased_query_list ')'
	| /*empty*/
	;

opt_if_not_exists :
	"IF" "NOT" "EXISTS"
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
	"FROM" maybe_slashed_or_dashed_path_expression
	| /*empty*/
	;

explain_statement :
	"EXPLAIN" unterminated_sql_statement
	;

export_data_statement :
	"EXPORT" "DATA" opt_with_connection_clause opt_options_list "AS" query
	;

export_model_statement :
	"EXPORT" "MODEL" path_expression opt_with_connection_clause opt_options_list
	;

export_metadata_statement :
	"EXPORT" table_or_table_function "METADATA" "FROM" maybe_dashed_path_expression opt_with_connection_clause opt_options_list
	;

grant_statement :
	"GRANT" privileges "ON" identifier path_expression "TO" grantee_list
	| "GRANT" privileges "ON" identifier identifier path_expression "TO" grantee_list
	| "GRANT" privileges "ON" path_expression "TO" grantee_list
	;

revoke_statement :
	"REVOKE" privileges "ON" identifier path_expression "FROM" grantee_list
	| "REVOKE" privileges "ON" identifier identifier path_expression "FROM" grantee_list
	| "REVOKE" privileges "ON" path_expression "FROM" grantee_list
	;

privileges :
	"ALL" opt_privileges_keyword
	| privilege_list
	;

opt_privileges_keyword :
	"PRIVILEGES"
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
	| "SELECT"
	;

rename_statement :
	"RENAME" identifier path_expression "TO" path_expression
	;

import_statement :
	"IMPORT" import_type path_expression_or_string opt_as_or_into_alias opt_options_list
	;

module_statement :
	"MODULE" path_expression opt_options_list
	;

index_order_by_prefix :
	'(' /*14L*/ ordering_expression
	| index_order_by_prefix ',' ordering_expression
	;

index_all_columns :
	'(' /*14L*/ "ALL" "COLUMNS" ')'
	;

index_order_by :
	index_order_by_prefix ')'
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
	"STORING" index_storing_expression_list
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
	"SHOW" show_target opt_from_path_expression opt_like_string_literal
	;

show_target :
	"MATERIALIZED" "VIEWS"
	| identifier
	;

opt_like_string_literal :
	"LIKE" /*4N*/ string_literal
	| /*empty*/
	;

opt_like_path_expression :
	"LIKE" /*4N*/ maybe_dashed_path_expression
	| /*empty*/
	;

opt_clone_table :
	"CLONE" clone_data_source
	| /*empty*/
	;

opt_copy_table :
	"COPY" copy_data_source
	| /*empty*/
	;

all_or_distinct :
	"ALL"
	| "DISTINCT" /*4N*/
	;

query_set_operation_type :
	"UNION"
	| KW_EXCEPT_IN_SET_OP
	| "INTERSECT"
	;

query_primary_or_set_operation :
	query_primary
	| query_set_operation
	;

parenthesized_query :
	'(' /*14L*/ query ')'
	;

select_or_from_keyword :
	"SELECT"
	| "FROM"
	;

query :
	with_clause query_primary_or_set_operation opt_order_by_clause opt_limit_offset_clause
	| with_clause_with_trailing_comma select_or_from_keyword
	| query_primary_or_set_operation opt_order_by_clause opt_limit_offset_clause
	| opt_with_clause "FROM"
	;

opt_corresponding_outer_mode :
	KW_FULL_IN_SET_OP opt_outer
	| "OUTER"
	| KW_LEFT_IN_SET_OP opt_outer
	| /*empty*/
	;

opt_strict :
	"STRICT"
	| /*empty*/
	;

opt_column_match_suffix :
	"CORRESPONDING"
	| "CORRESPONDING" "BY" column_list
	| /*empty*/
	;

query_set_operation_prefix :
	query_primary set_operation_metadata query_primary
	| query_set_operation_prefix set_operation_metadata query_primary
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
	"SELECT" opt_hint opt_select_with opt_all_or_distinct opt_select_as_clause select_list
	| "SELECT" opt_hint opt_select_with opt_all_or_distinct opt_select_as_clause "FROM"
	;

select :
	select_clause opt_from_clause opt_clauses_following_from
	;

pre_select_with :
	/*empty*/
	;

opt_select_with :
	pre_select_with "WITH" identifier
	| pre_select_with "WITH" identifier KW_OPTIONS_IN_SELECT_WITH_OPTIONS options_list
	| pre_select_with
	;

opt_select_as_clause :
	"AS" "STRUCT"
	| "AS" path_expression
	| /*empty*/
	;

extra_identifier_in_hints_name :
	"HASH"
	| "PROTO"
	| "PARTITION"
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
	"ALL"
	| "DISTINCT" /*4N*/
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
	"EXCEPT" '(' /*14L*/ identifier
	| star_except_list_prefix ',' identifier
	;

star_except_list :
	star_except_list_prefix ')'
	;

star_replace_item :
	expression "AS" identifier
	;

star_modifiers_with_replace_prefix :
	star_except_list "REPLACE" '(' /*14L*/ star_replace_item
	| "REPLACE" '(' /*14L*/ star_replace_item
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
	| expression "AS" identifier
	| expression identifier
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
	"AS" identifier
	| /*empty*/
	;

opt_as_or_into_alias :
	"AS" identifier
	| "INTO" identifier
	| /*empty*/
	;

opt_as :
	"AS"
	| /*empty*/
	;

opt_natural :
	"NATURAL"
	| /*empty*/
	;

opt_outer :
	"OUTER"
	| /*empty*/
	;

int_literal_or_parameter :
	integer_literal
	| parameter_expression
	| system_variable_expression
	;

cast_int_literal_or_parameter :
	"CAST" '(' /*14L*/ int_literal_or_parameter "AS" type opt_format ')'
	;

possibly_cast_int_literal_or_parameter :
	cast_int_literal_or_parameter
	| int_literal_or_parameter
	;

repeatable_clause :
	"REPEATABLE" '(' /*14L*/ possibly_cast_int_literal_or_parameter ')'
	;

sample_size_value :
	possibly_cast_int_literal_or_parameter
	| floating_point_literal
	;

sample_size_unit :
	"ROWS"
	| "PERCENT"
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
	| "WITH" "WEIGHT" opt_repeatable_clause
	| "WITH" "WEIGHT" identifier opt_repeatable_clause
	| "WITH" "WEIGHT" "AS" identifier opt_repeatable_clause
	| /*empty*/
	;

sample_clause :
	"TABLESAMPLE" identifier '(' /*14L*/ sample_size ')' opt_sample_clause_suffix
	;

opt_sample_clause :
	sample_clause
	| /*empty*/
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
	"PIVOT" '(' /*14L*/ pivot_expression_list "FOR" expression_higher_prec_than_and "IN" /*4N*/ '(' /*14L*/ pivot_value_list ')' ')'
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
	"EXCLUDE" "NULLS"
	| "INCLUDE" "NULLS"
	| /*empty*/
	;

unpivot_clause :
	"UNPIVOT" opt_unpivot_nulls_filter '(' /*14L*/ path_expression_list_with_opt_parens "FOR" path_expression "IN" /*4N*/ unpivot_in_item_list ')'
	;

opt_pivot_or_unpivot_clause_and_alias :
	"AS" identifier
	| identifier
	| "AS" identifier pivot_clause opt_as_alias
	| "AS" identifier unpivot_clause opt_as_alias
	| "AS" identifier qualify_clause_nonreserved
	| identifier pivot_clause opt_as_alias
	| identifier unpivot_clause opt_as_alias
	| identifier qualify_clause_nonreserved
	| pivot_clause opt_as_alias
	| unpivot_clause opt_as_alias
	| qualify_clause_nonreserved
	| /*empty*/
	;

table_subquery :
	parenthesized_query opt_pivot_or_unpivot_clause_and_alias opt_sample_clause
	;

table_clause :
	"TABLE" tvf_with_suffixes
	| "TABLE" path_expression
	;

model_clause :
	"MODEL" path_expression
	;

connection_clause :
	"CONNECTION" path_expression_or_default
	;

descriptor_column :
	identifier
	;

descriptor_column_list :
	descriptor_column
	| descriptor_column_list ',' descriptor_column
	;

descriptor_argument :
	"DESCRIPTOR" '(' /*14L*/ descriptor_column_list ')'
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
	| "SELECT"
	| "WITH"
	;

tvf_prefix_no_args :
	path_expression '(' /*14L*/
	| "IF" '(' /*14L*/
	;

tvf_prefix :
	tvf_prefix_no_args tvf_argument
	| tvf_prefix ',' tvf_argument
	;

tvf_with_suffixes :
	tvf_prefix_no_args ')' opt_hint opt_pivot_or_unpivot_clause_and_alias opt_sample_clause
	| tvf_prefix ')' opt_hint opt_pivot_or_unpivot_clause_and_alias opt_sample_clause
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
	table_path_expression_base opt_hint opt_pivot_or_unpivot_clause_and_alias opt_with_offset_and_alias opt_at_system_time opt_sample_clause
	;

table_primary :
	tvf_with_suffixes
	| table_path_expression
	| '(' /*14L*/ join ')' opt_sample_clause
	| table_subquery
	;

opt_at_system_time :
	"FOR" "SYSTEM" "TIME" "AS" "OF" expression
	| "FOR" "SYSTEM_TIME" "AS" "OF" expression
	| /*empty*/
	;

on_clause :
	"ON" expression
	;

using_clause_prefix :
	"USING" '(' /*14L*/ identifier
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

join_type :
	"CROSS"
	| "FULL" opt_outer
	| "INNER"
	| KW_LEFT opt_outer
	| "RIGHT" opt_outer
	| /*empty*/
	;

join_hint :
	"HASH"
	| "LOOKUP"
	| /*empty*/
	;

join_input :
	join
	| table_primary
	;

join :
	join_input opt_natural join_type join_hint "JOIN" opt_hint table_primary opt_on_or_using_clause_list
	;

from_clause_contents :
	table_primary
	| from_clause_contents ',' table_primary
	| from_clause_contents opt_natural join_type join_hint "JOIN" opt_hint table_primary opt_on_or_using_clause_list
	| '@'
	| '?'
	| KW_DOUBLE_AT
	;

opt_from_clause :
	from_clause
	| /*empty*/
	;

from_clause :
	"FROM" from_clause_contents
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
	"WHERE" expression
	;

opt_where_clause :
	where_clause
	| /*empty*/
	;

rollup_list :
	"ROLLUP" '(' /*14L*/ expression
	| rollup_list ',' expression
	;

cube_list :
	"CUBE" '(' /*14L*/ expression
	| cube_list ',' expression
	;

grouping_set :
	'(' /*14L*/ ')'
	| expression
	| rollup_list ')'
	| cube_list ')'
	;

grouping_set_list :
	"GROUPING" "SETS" '(' /*14L*/ grouping_set
	| grouping_set_list ',' grouping_set
	;

grouping_item :
	'(' /*14L*/ ')'
	| expression opt_as_alias_with_required_as
	| rollup_list ')'
	| cube_list ')'
	| grouping_set_list ')'
	;

group_by_preamble :
	"GROUP" opt_hint "BY"
	;

group_by_clause_prefix :
	group_by_preamble grouping_item
	| group_by_clause_prefix ',' grouping_item
	;

group_by_all :
	group_by_preamble "ALL"
	;

group_by_clause :
	group_by_all
	| group_by_clause_prefix
	;

opt_group_by_clause :
	group_by_clause
	| /*empty*/
	;

having_clause :
	"HAVING" expression
	;

opt_having_clause :
	having_clause
	| /*empty*/
	;

window_definition :
	identifier "AS" window_specification
	;

window_clause_prefix :
	"WINDOW" window_definition
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
	"LIMIT" expression "OFFSET" expression
	| "LIMIT" expression
	;

opt_limit_offset_clause :
	limit_offset_clause
	| /*empty*/
	;

opt_having_or_group_by_modifier :
	"HAVING" "MAX" expression
	| "HAVING" "MIN" expression
	| group_by_clause_prefix
	| /*empty*/
	;

opt_clamped_between_modifier :
	"CLAMPED" "BETWEEN" /*4N*/ expression_higher_prec_than_and "AND" /*2L*/ expression %prec "BETWEEN" /*4N*/
	| /*empty*/
	;

opt_with_report_modifier :
	"WITH" "REPORT" opt_with_report_format
	| /*empty*/
	;

opt_with_report_format :
	options_list
	| /*empty*/
	;

opt_null_handling_modifier :
	"IGNORE" "NULLS"
	| "RESPECT" "NULLS"
	| /*empty*/
	;

possibly_unbounded_int_literal_or_parameter :
	int_literal_or_parameter
	| "UNBOUNDED"
	;

recursion_depth_modifier :
	"WITH" "DEPTH" opt_as_alias_with_required_as
	| "WITH" "DEPTH" opt_as_alias_with_required_as "BETWEEN" /*4N*/ possibly_unbounded_int_literal_or_parameter "AND" /*2L*/ possibly_unbounded_int_literal_or_parameter %prec "BETWEEN" /*4N*/
	| "WITH" "DEPTH" opt_as_alias_with_required_as "MAX" possibly_unbounded_int_literal_or_parameter
	;

aliased_query_modifiers :
	recursion_depth_modifier
	| /*empty*/
	;

aliased_query :
	identifier "AS" parenthesized_query aliased_query_modifiers
	;

aliased_query_list :
	aliased_query
	| aliased_query_list ',' aliased_query
	;

with_clause :
	"WITH" aliased_query
	| "WITH" "RECURSIVE" aliased_query
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
	"ASC"
	| "DESC"
	;

opt_asc_or_desc :
	asc_or_desc
	| /*empty*/
	;

opt_null_order :
	"NULLS" "FIRST"
	| "NULLS" "LAST"
	| /*empty*/
	;

string_literal_or_parameter :
	string_literal
	| parameter_expression
	| system_variable_expression
	;

collate_clause :
	"COLLATE" string_literal_or_parameter
	;

opt_collate_clause :
	collate_clause
	| /*empty*/
	;

opt_default_collate_clause :
	"DEFAULT" collate_clause
	| /*empty*/
	;

ordering_expression :
	expression opt_collate_clause opt_asc_or_desc opt_null_order
	;

order_by_clause_prefix :
	"ORDER" opt_hint "BY" ordering_expression
	| order_by_clause_prefix ',' ordering_expression
	;

order_by_clause :
	order_by_clause_prefix
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
	"UNNEST" '(' /*14L*/ expression_with_opt_alias
	| unnest_expression_prefix ',' expression_with_opt_alias
	;

opt_array_zip_mode :
	',' named_argument
	| /*empty*/
	;

unnest_expression :
	unnest_expression_prefix opt_array_zip_mode ')'
	| "UNNEST" '(' /*14L*/ "SELECT"
	;

unnest_expression_with_opt_alias_and_offset :
	unnest_expression opt_as_alias opt_with_offset_and_alias
	;

comparative_operator :
	'=' /*4N*/
	| "!=" /*4N*/
	| "<>" /*4N*/
	| '<' /*4N*/
	| "<=" /*4N*/
	| '>' /*4N*/
	| ">=" /*4N*/
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
	"<<" /*8L*/
	| ">>" /*8L*/
	;

import_type :
	"MODULE"
	| "PROTO"
	;

any_some_all :
	"ANY"
	| "SOME"
	| "ALL"
	;

like_operator :
	"LIKE" /*4N*/ %prec "LIKE" /*4N*/
	| "NOT_SPECIAL" /*4N*/ "LIKE" /*4N*/ %prec "LIKE" /*4N*/
	;

between_operator :
	"BETWEEN" /*4N*/ %prec "BETWEEN" /*4N*/
	| "NOT_SPECIAL" /*4N*/ "BETWEEN" /*4N*/ %prec "BETWEEN" /*4N*/
	;

distinct_operator :
	"IS" /*4N*/ "DISTINCT" /*4N*/ "FROM" %prec "DISTINCT" /*4N*/
	| "IS" /*4N*/ "NOT_SPECIAL" /*4N*/ "DISTINCT" /*4N*/ "FROM" %prec "DISTINCT" /*4N*/
	;

in_operator :
	"IN" /*4N*/ %prec "IN" /*4N*/
	| "NOT_SPECIAL" /*4N*/ "IN" /*4N*/ %prec "IN" /*4N*/
	;

is_operator :
	"IS" /*4N*/ %prec "IS" /*4N*/
	| "IS" /*4N*/ "NOT" %prec "IS" /*4N*/
	;

unary_operator :
	'+' /*9L*/ %prec UNARY_PRECEDENCE /*12P*/
	| '-' /*9L*/ %prec UNARY_PRECEDENCE /*12P*/
	| '~' %prec UNARY_PRECEDENCE /*12P*/
	;

with_expression_variable :
	identifier "AS" expression
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
	| and_expression %prec "AND" /*2L*/
	| or_expression %prec "OR" /*1L*/
	;

or_expression :
	expression "OR" /*1L*/ expression %prec "OR" /*1L*/
	;

and_expression :
	and_expression "AND" /*2L*/ expression_higher_prec_than_and %prec "AND" /*2L*/
	| expression_higher_prec_than_and "AND" /*2L*/ expression_higher_prec_than_and %prec "AND" /*2L*/
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
	| "NOT" expression_higher_prec_than_and %prec UNARY_NOT_PRECEDENCE /*3P*/
	| expression_higher_prec_than_and like_operator any_some_all opt_hint unnest_expression %prec "LIKE" /*4N*/
	| expression_higher_prec_than_and like_operator any_some_all opt_hint parenthesized_anysomeall_list_in_rhs %prec "LIKE" /*4N*/
	| expression_higher_prec_than_and like_operator expression_higher_prec_than_and %prec "LIKE" /*4N*/
	| expression_higher_prec_than_and distinct_operator expression_higher_prec_than_and %prec "DISTINCT" /*4N*/
	| expression_higher_prec_than_and in_operator opt_hint unnest_expression %prec "IN" /*4N*/
	| expression_higher_prec_than_and in_operator opt_hint parenthesized_in_rhs %prec "IN" /*4N*/
	| expression_higher_prec_than_and between_operator expression_higher_prec_than_and "AND" /*2L*/ expression_higher_prec_than_and %prec "BETWEEN" /*4N*/
	| expression_higher_prec_than_and between_operator expression_higher_prec_than_and "OR" /*1L*/ %prec "BETWEEN" /*4N*/
	| expression_higher_prec_than_and is_operator "UNKNOWN" %prec "IS" /*4N*/
	| expression_higher_prec_than_and is_operator null_literal %prec "IS" /*4N*/
	| expression_higher_prec_than_and is_operator boolean_literal %prec "IS" /*4N*/
	| expression_higher_prec_than_and comparative_operator expression_higher_prec_than_and %prec '=' /*4N*/
	| expression_higher_prec_than_and '|' /*5L*/ expression_higher_prec_than_and
	| expression_higher_prec_than_and '^' /*6L*/ expression_higher_prec_than_and
	| expression_higher_prec_than_and '&' /*7L*/ expression_higher_prec_than_and
	| expression_higher_prec_than_and "||" /*10L*/ expression_higher_prec_than_and
	| expression_higher_prec_than_and shift_operator expression_higher_prec_than_and %prec "<<" /*8L*/
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
	"ARRAY" '[' /*14L*/
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
	"DATE"
	| "DATETIME"
	| "TIME"
	| "TIMESTAMP"
	;

date_or_time_literal :
	date_or_time_literal_kind string_literal
	;

interval_expression :
	"INTERVAL" expression identifier
	| "INTERVAL" expression identifier "TO" identifier
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
	| "INTERVAL"
	;

template_type_open :
	'<' /*4N*/
	;

template_type_close :
	'>' /*4N*/
	;

array_type :
	"ARRAY" template_type_open type template_type_close
	;

struct_field :
	identifier type
	| type
	;

struct_type_prefix :
	"STRUCT" template_type_open struct_field
	| struct_type_prefix ',' struct_field
	;

struct_type :
	"STRUCT" template_type_open template_type_close
	| struct_type_prefix template_type_close
	;

range_type :
	"RANGE" template_type_open type template_type_close
	;

function_type_prefix :
	"FUNCTION" template_type_open '(' /*14L*/ type
	| function_type_prefix ',' type
	;

function_type :
	"FUNCTION" template_type_open '(' /*14L*/ ')' "->" type template_type_close
	| "FUNCTION" template_type_open type "->" type template_type_close
	| function_type_prefix ')' "->" type template_type_close
	;

map_type :
	"MAP" template_type_open type ',' type template_type_close
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
	| "MAX"
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
	"PROTO"
	| "ENUM"
	| "STRUCT"
	| "ARRAY"
	| identifier
	;

templated_parameter_type :
	"ANY" templated_parameter_kind
	;

type_or_tvf_schema :
	type
	| templated_parameter_type
	| tvf_schema
	;

new_constructor_prefix_no_arg :
	"NEW" type_name '(' /*14L*/
	;

new_constructor_arg :
	expression
	| expression "AS" identifier
	| expression "AS" '(' /*14L*/ path_expression ')'
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

braced_constructor_extension :
	'(' /*14L*/ path_expression ')' braced_constructor_field_value
	;

braced_constructor_field :
	identifier braced_constructor_field_value
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
	"NEW" type_name braced_constructor
	;

struct_braced_constructor :
	struct_type braced_constructor
	| "STRUCT" braced_constructor
	;

case_no_value_expression_prefix :
	"CASE" "WHEN" expression "THEN" expression
	| case_no_value_expression_prefix "WHEN" expression "THEN" expression
	;

case_value_expression_prefix :
	"CASE" expression "WHEN" expression "THEN" expression
	| case_value_expression_prefix "WHEN" expression "THEN" expression
	;

case_expression_prefix :
	case_no_value_expression_prefix
	| case_value_expression_prefix
	;

case_expression :
	case_expression_prefix "END"
	| case_expression_prefix "ELSE" expression "END"
	;

opt_at_time_zone :
	"AT" "TIME" "ZONE" expression
	| /*empty*/
	;

opt_format :
	"FORMAT" expression opt_at_time_zone
	| /*empty*/
	;

cast_expression :
	"CAST" '(' /*14L*/ expression "AS" type opt_format ')'
	| "CAST" '(' /*14L*/ "SELECT"
	| "SAFE_CAST" '(' /*14L*/ expression "AS" type opt_format ')'
	| "SAFE_CAST" '(' /*14L*/ "SELECT"
	;

extract_expression_base :
	"EXTRACT" '(' /*14L*/ expression "FROM" expression
	;

extract_expression :
	extract_expression_base ')'
	| extract_expression_base "AT" "TIME" "ZONE" expression ')'
	;

replace_fields_arg :
	expression "AS" generalized_path_expression
	| expression "AS" generalized_extension_path
	;

replace_fields_prefix :
	"REPLACE_FIELDS" '(' /*14L*/ expression ',' replace_fields_arg
	| replace_fields_prefix ',' replace_fields_arg
	;

replace_fields_expression :
	replace_fields_prefix ')'
	;

function_name_from_keyword :
	"IF"
	| "GROUPING"
	| KW_LEFT
	| "RIGHT"
	| "COLLATE"
	| "RANGE"
	;

function_call_expression_base :
	expression_higher_prec_than_and '(' /*14L*/ "DISTINCT" /*4N*/ %prec PRIMARY_PRECEDENCE /*14L*/
	| expression_higher_prec_than_and '(' /*14L*/ %prec PRIMARY_PRECEDENCE /*14L*/
	| function_name_from_keyword '(' /*14L*/ %prec PRIMARY_PRECEDENCE /*14L*/
	;

function_call_argument :
	expression opt_as_alias_with_required_as
	| named_argument
	| lambda_argument
	| sequence_arg
	| "SELECT"
	;

sequence_arg :
	"SEQUENCE" path_expression
	;

named_argument :
	identifier KW_NAMED_ARGUMENT_ASSIGNMENT expression
	| identifier KW_NAMED_ARGUMENT_ASSIGNMENT lambda_argument
	;

lambda_argument :
	lambda_argument_list "->" expression
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
	"PARTITION" opt_hint "BY" expression
	| partition_by_clause_prefix ',' expression
	;

opt_partition_by_clause :
	partition_by_clause_prefix
	| /*empty*/
	;

partition_by_clause_prefix_no_hint :
	"PARTITION" "BY" expression
	| partition_by_clause_prefix_no_hint ',' expression
	;

opt_partition_by_clause_no_hint :
	partition_by_clause_prefix_no_hint
	| /*empty*/
	;

cluster_by_clause_prefix_no_hint :
	"CLUSTER" "BY" expression
	| cluster_by_clause_prefix_no_hint ',' expression
	;

opt_cluster_by_clause_no_hint :
	cluster_by_clause_prefix_no_hint
	| /*empty*/
	;

opt_ttl_clause :
	"ROW" "DELETION" "POLICY" '(' /*14L*/ expression ')'
	| /*empty*/
	;

preceding_or_following :
	"PRECEDING"
	| "FOLLOWING"
	;

window_frame_bound :
	"UNBOUNDED" preceding_or_following
	| "CURRENT" "ROW"
	| expression preceding_or_following
	;

frame_unit :
	"ROWS"
	| "RANGE"
	;

opt_window_frame_clause :
	frame_unit "BETWEEN" /*4N*/ window_frame_bound "AND" /*2L*/ window_frame_bound %prec "BETWEEN" /*4N*/
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
	KW_WITH_STARTING_WITH_GROUP_ROWS "GROUP" "ROWS" parenthesized_query
	| /*empty*/
	;

opt_over_clause :
	"OVER" window_specification
	| /*empty*/
	;

struct_constructor_prefix_with_keyword_no_arg :
	struct_type '(' /*14L*/
	| "STRUCT" '(' /*14L*/
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
	"ARRAY" parenthesized_query
	| "EXISTS" opt_hint parenthesized_query
	;

null_literal :
	"NULL"
	;

boolean_literal :
	"TRUE"
	| "FALSE"
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
	"NUMERIC"
	| "DECIMAL"
	;

numeric_literal :
	numeric_literal_prefix string_literal
	;

bignumeric_literal_prefix :
	"BIGNUMERIC"
	| "BIGDECIMAL"
	;

bignumeric_literal :
	bignumeric_literal_prefix string_literal
	;

json_literal :
	"JSON" string_literal
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
	"ABORT"
	| "ACCESS"
	| "ACTION"
	| "AGGREGATE"
	| "ADD"
	| "ALTER"
	| "ALWAYS"
	| "ANALYZE"
	| "APPROX"
	| "ARE"
	| "ASSERT"
	| "BATCH"
	| "BEGIN"
	| "BIGDECIMAL"
	| "BIGNUMERIC"
	| "BREAK"
	| "CALL"
	| "CASCADE"
	| "CHECK"
	| "CLAMPED"
	| "CLONE"
	| "COPY"
	| "CLUSTER"
	| "COLUMN"
	| "COLUMNS"
	| "COMMIT"
	| "CONNECTION"
	| "CONSTANT"
	| "CONSTRAINT"
	| "CONTINUE"
	| "CORRESPONDING"
	| "CYCLE"
	| "DATA"
	| "DATABASE"
	| "DATE"
	| "DATETIME"
	| "DECIMAL"
	| "DECLARE"
	| "DEFINER"
	| "DELETE"
	| "DELETION"
	| "DEPTH"
	| "DESCRIBE"
	| "DETERMINISTIC"
	| "DO"
	| "DROP"
	| "ELSEIF"
	| "ENFORCED"
	| "ERROR"
	| "EXCEPTION"
	| "EXECUTE"
	| "EXPLAIN"
	| "EXPORT"
	| "EXTEND"
	| "EXTERNAL"
	| "FILES"
	| "FILTER"
	| "FILL"
	| "FIRST"
	| "FOREIGN"
	| "FORMAT"
	| "FUNCTION"
	| "GENERATED"
	| "GRANT"
	| "GROUP_ROWS"
	| "HIDDEN"
	| "IDENTITY"
	| "IMMEDIATE"
	| "IMMUTABLE"
	| "IMPORT"
	| "INCLUDE"
	| "INCREMENT"
	| "INDEX"
	| "INOUT"
	| "INPUT"
	| "INSERT"
	| "INVOKER"
	| "ISOLATION"
	| "ITERATE"
	| "JSON"
	| "KEY"
	| "LANGUAGE"
	| "LAST"
	| "LEAVE"
	| "LEVEL"
	| "LOAD"
	| "LOOP"
	| "MACRO"
	| "MAP"
	| "MATCH"
	| "MATCHED"
	| "MATERIALIZED"
	| "MAX"
	| "MAXVALUE"
	| "MESSAGE"
	| "METADATA"
	| "MIN"
	| "MINVALUE"
	| "MODEL"
	| "MODULE"
	| "NUMERIC"
	| "OFFSET"
	| "ONLY"
	| "OPTIONS"
	| "OUT"
	| "OUTPUT"
	| "OVERWRITE"
	| "PARTITIONS"
	| "PERCENT"
	| "PIVOT"
	| "POLICIES"
	| "POLICY"
	| "PRIMARY"
	| "PRIVATE"
	| "PRIVILEGE"
	| "PRIVILEGES"
	| "PROCEDURE"
	| "PROJECT"
	| "PUBLIC"
	| KW_QUALIFY_NONRESERVED
	| "RAISE"
	| "READ"
	| "REFERENCES"
	| "REMOTE"
	| "REMOVE"
	| "RENAME"
	| "REPEAT"
	| "REPEATABLE"
	| "REPLACE"
	| "REPLACE_FIELDS"
	| "REPLICA"
	| "REPORT"
	| "RESTRICT"
	| "RESTRICTION"
	| "RETURNS"
	| "RETURN"
	| "REVOKE"
	| "ROLLBACK"
	| "ROW"
	| "RUN"
	| "SAFE_CAST"
	| "SCHEMA"
	| "SEARCH"
	| "SECURITY"
	| "SEQUENCE"
	| "SETS"
	| "SHOW"
	| "SNAPSHOT"
	| "SOURCE"
	| "SQL"
	| "STABLE"
	| "START"
	| "STORED"
	| "STORING"
	| "STRICT"
	| "SYSTEM"
	| "SYSTEM_TIME"
	| "TABLE"
	| "TABLES"
	| "TARGET"
	| "TEMP"
	| "TEMPORARY"
	| "TIME"
	| "TIMESTAMP"
	| "TRANSACTION"
	| "TRANSFORM"
	| "TRUNCATE"
	| "TYPE"
	| "UNDROP"
	| "UNIQUE"
	| "UNKNOWN"
	| "UNPIVOT"
	| "UNTIL"
	| "UPDATE"
	| "VALUE"
	| "VALUES"
	| "VECTOR"
	| "VIEW"
	| "VIEWS"
	| "VOLATILE"
	| "WEIGHT"
	| "WHILE"
	| "WRITE"
	| "ZONE"
	| "DESCRIPTOR"
	| "INTERLEAVE"
	| "NULL_FILTERED"
	| "PARENT"
	;

keyword_as_identifier :
	common_keyword_as_identifier
	| "SIMPLE"
	;

opt_or_replace :
	"OR" /*1L*/ "REPLACE"
	| /*empty*/
	;

opt_create_scope :
	"TEMP"
	| "TEMPORARY"
	| "PUBLIC"
	| "PRIVATE"
	| /*empty*/
	;

opt_unique :
	"UNIQUE"
	| /*empty*/
	;

describe_keyword :
	"DESCRIBE"
	| "DESC"
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
	| "+=" /*4N*/
	| "-=" /*4N*/
	;

expression_or_proto :
	"PROTO"
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
	"OPTIONS" options_list
	;

opt_options_list :
	options
	| /*empty*/
	;

define_table_statement :
	"DEFINE" "TABLE" path_expression options_list
	;

dml_statement :
	insert_statement
	| delete_statement
	| update_statement
	;

opt_from_keyword :
	"FROM"
	| /*empty*/
	;

opt_where_expression :
	"WHERE" expression
	| /*empty*/
	;

opt_assert_rows_modified :
	"ASSERT_ROWS_MODIFIED" possibly_cast_int_literal_or_parameter
	| /*empty*/
	;

opt_returning_clause :
	"THEN" "RETURN" select_list
	| "THEN" "RETURN" "WITH" "ACTION" select_list
	| "THEN" "RETURN" "WITH" "ACTION" "AS" identifier select_list
	| /*empty*/
	;

opt_or_ignore_replace_update :
	"OR" /*1L*/ "IGNORE"
	| "IGNORE"
	| "OR" /*1L*/ "REPLACE"
	| KW_REPLACE_AFTER_INSERT
	| "OR" /*1L*/ "UPDATE"
	| KW_UPDATE_AFTER_INSERT
	| /*empty*/
	;

insert_statement_prefix :
	"INSERT" opt_or_ignore_replace_update opt_into maybe_dashed_generalized_path_expression opt_hint
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
	| clone_data_source_list "UNION" "ALL" clone_data_source
	;

clone_data_statement :
	"CLONE" "DATA" "INTO" maybe_dashed_path_expression "FROM" clone_data_source_list
	;

expression_or_default :
	expression
	| "DEFAULT"
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
	"VALUES" insert_values_row
	| insert_values_list ',' insert_values_row
	;

delete_statement :
	"DELETE" opt_from_keyword maybe_dashed_generalized_path_expression opt_hint opt_as_alias opt_with_offset_and_alias opt_where_expression opt_assert_rows_modified opt_returning_clause
	;

opt_with_offset_and_alias :
	"WITH" "OFFSET" opt_as_alias
	| /*empty*/
	;

update_statement :
	"UPDATE" maybe_dashed_generalized_path_expression opt_hint opt_as_alias opt_with_offset_and_alias "SET" update_item_list opt_from_clause opt_where_expression opt_assert_rows_modified opt_returning_clause
	;

truncate_statement :
	"TRUNCATE" "TABLE" maybe_dashed_path_expression opt_where_expression
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
	"INTO"
	| /*empty*/
	;

opt_by_target :
	"BY" "TARGET"
	| /*empty*/
	;

opt_and_expression :
	"AND" /*2L*/ expression
	| /*empty*/
	;

merge_insert_value_list_or_source_row :
	"VALUES" insert_values_row
	| "ROW"
	;

merge_action :
	"INSERT" opt_column_list merge_insert_value_list_or_source_row
	| "UPDATE" "SET" update_item_list
	| "DELETE"
	;

merge_when_clause :
	"WHEN" "MATCHED" opt_and_expression "THEN" merge_action
	| "WHEN" "NOT" "MATCHED" opt_by_target opt_and_expression "THEN" merge_action
	| "WHEN" "NOT" "MATCHED" "BY" "SOURCE" opt_and_expression "THEN" merge_action
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
	"MERGE" opt_into maybe_dashed_path_expression opt_as_alias "USING" merge_source "ON" expression
	;

merge_statement :
	merge_statement_prefix merge_when_clause_list
	;

call_statement_with_args_prefix :
	"CALL" path_expression '(' /*14L*/ tvf_argument
	| call_statement_with_args_prefix ',' tvf_argument
	;

call_statement :
	call_statement_with_args_prefix ')'
	| "CALL" path_expression '(' /*14L*/ ')'
	;

opt_function_parameters :
	function_parameters
	| /*empty*/
	;

opt_if_exists :
	"IF" "EXISTS"
	| /*empty*/
	;

opt_access :
	"ACCESS"
	| /*empty*/
	;

drop_all_row_access_policies_statement :
	"DROP" "ALL" "ROW" opt_access "POLICIES" "ON" path_expression
	;

on_path_expression :
	"ON" path_expression
	;

opt_on_path_expression :
	"ON" path_expression
	| /*empty*/
	;

opt_drop_mode :
	"RESTRICT"
	| "CASCADE"
	| /*empty*/
	;

drop_statement :
	"DROP" "PRIVILEGE" "RESTRICTION" opt_if_exists "ON" privilege_list "ON" identifier path_expression
	| "DROP" "ROW" "ACCESS" "POLICY" opt_if_exists identifier on_path_expression
	| "DROP" index_type "INDEX" opt_if_exists path_expression opt_on_path_expression
	| "DROP" table_or_table_function opt_if_exists maybe_dashed_path_expression opt_function_parameters
	| "DROP" "SNAPSHOT" "TABLE" opt_if_exists maybe_dashed_path_expression
	| "DROP" generic_entity_type opt_if_exists path_expression
	| "DROP" schema_object_kind opt_if_exists path_expression opt_function_parameters opt_drop_mode
	;

index_type :
	"SEARCH"
	| "VECTOR"
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
	"INTO" identifier_list
	| /*empty*/
	;

execute_using_argument :
	expression "AS" identifier
	| expression
	;

execute_using_argument_list :
	execute_using_argument
	| execute_using_argument_list ',' execute_using_argument
	;

opt_execute_using_clause :
	"USING" execute_using_argument_list
	| /*empty*/
	;

execute_immediate :
	"EXECUTE" "IMMEDIATE" expression opt_execute_into_clause opt_execute_using_clause
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
	"ELSE" statement_list
	| /*empty*/
	;

elseif_clauses :
	"ELSEIF" expression "THEN" statement_list
	| elseif_clauses "ELSEIF" expression "THEN" statement_list
	;

opt_elseif_clauses :
	elseif_clauses
	| /*empty*/
	;

if_statement_unclosed :
	"IF" expression "THEN" statement_list opt_elseif_clauses opt_else
	;

if_statement :
	if_statement_unclosed "END" "IF"
	//| if_statement_unclosed error
	;

when_then_clauses :
	"WHEN" expression "THEN" statement_list
	| when_then_clauses "WHEN" expression "THEN" statement_list
	;

opt_expression :
	expression
	| /*empty*/
	;

case_statement :
	"CASE" opt_expression when_then_clauses opt_else "END" "CASE"
	;

begin_end_block :
	"BEGIN" statement_list opt_exception_handler "END"
	;

opt_exception_handler :
	"EXCEPTION" "WHEN" "ERROR" "THEN" statement_list
	| /*empty*/
	;

opt_default_expression :
	"DEFAULT" expression
	| /*empty*/
	;

identifier_list :
	identifier
	| identifier_list ',' identifier
	;

variable_declaration :
	"DECLARE" identifier_list type opt_default_expression
	| "DECLARE" identifier_list "DEFAULT" expression
	;

loop_statement :
	"LOOP" statement_list "END" "LOOP"
	;

while_statement :
	"WHILE" expression "DO" statement_list "END" "WHILE"
	;

until_clause :
	"UNTIL" expression
	;

repeat_statement :
	"REPEAT" statement_list until_clause "END" "REPEAT"
	;

for_in_statement :
	"FOR" identifier "IN" /*4N*/ parenthesized_query "DO" statement_list "END" "FOR"
	;

break_statement :
	"BREAK" opt_identifier
	| "LEAVE" opt_identifier
	;

continue_statement :
	"CONTINUE" opt_identifier
	| "ITERATE" opt_identifier
	;

return_statement :
	"RETURN"
	;

raise_statement :
	"RAISE"
	| "RAISE" "USING" "MESSAGE" '=' /*4N*/ expression
	;

next_statement_kind :
	next_statement_kind_without_hint
	| hint next_statement_kind_without_hint
	;

next_statement_kind_parenthesized_select :
	'(' /*14L*/ next_statement_kind_parenthesized_select
	| "SELECT"
	| "WITH"
	| "FROM"
	;

next_statement_kind_table :
	"TABLE"
	;

next_statement_kind_create_table_opt_as_or_semicolon :
	"AS"
	| ';'
	| /*empty*/
	;

next_statement_kind_create_modifiers :
	opt_or_replace opt_create_scope
	;

next_statement_kind_without_hint :
	"EXPLAIN"
	| next_statement_kind_parenthesized_select
	| "DEFINE" "TABLE"
	| KW_DEFINE_FOR_MACROS "MACRO"
	| "EXECUTE" "IMMEDIATE"
	| "EXPORT" "DATA"
	| "EXPORT" "MODEL"
	| "EXPORT" table_or_table_function "METADATA"
	| "INSERT"
	| "UPDATE"
	| "DELETE"
	| "MERGE"
	| "CLONE" "DATA"
	| "LOAD" "DATA"
	| describe_keyword
	| "SHOW"
	| "DROP" "PRIVILEGE"
	| "DROP" "ALL" "ROW" opt_access "POLICIES"
	| "DROP" "ROW" "ACCESS" "POLICY"
	| "DROP" "SEARCH" "INDEX"
	| "DROP" "VECTOR" "INDEX"
	| "DROP" table_or_table_function
	| "DROP" "SNAPSHOT" "TABLE"
	| "DROP" generic_entity_type
	| "DROP" schema_object_kind
	| "GRANT"
	| "GRAPH"
	| "REVOKE"
	| "RENAME"
	| "START"
	| "BEGIN"
	| "SET" "TRANSACTION" identifier
	| "SET" identifier '=' /*4N*/
	| "SET" named_parameter_expression '=' /*4N*/
	| "SET" system_variable_expression '=' /*4N*/
	| "SET" '(' /*14L*/
	| "COMMIT"
	| "ROLLBACK"
	| "START" "BATCH"
	| "RUN" "BATCH"
	| "ABORT" "BATCH"
	| "ALTER" "APPROX" "VIEW"
	| "ALTER" "DATABASE"
	| "ALTER" "SCHEMA"
	| "ALTER" "EXTERNAL" "SCHEMA"
	| "ALTER" "TABLE"
	| "ALTER" "PRIVILEGE"
	| "ALTER" "ROW"
	| "ALTER" "ALL" "ROW" "ACCESS" "POLICIES"
	| "ALTER" "VIEW"
	| "ALTER" "MATERIALIZED" "VIEW"
	| "ALTER" generic_entity_type
	| "ALTER" "MODEL"
	| "CREATE" "DATABASE"
	| "CREATE" next_statement_kind_create_modifiers opt_aggregate "CONSTANT"
	| "CREATE" next_statement_kind_create_modifiers opt_aggregate "FUNCTION"
	| "CREATE" next_statement_kind_create_modifiers "PROCEDURE"
	| "CREATE" opt_or_replace opt_unique opt_spanner_null_filtered opt_index_type "INDEX"
	| "CREATE" opt_or_replace "SCHEMA"
	| "CREATE" opt_or_replace generic_entity_type
	| "CREATE" next_statement_kind_create_modifiers next_statement_kind_table opt_if_not_exists maybe_dashed_path_expression opt_table_element_list opt_like_path_expression opt_clone_table opt_copy_table opt_default_collate_clause opt_partition_by_clause_no_hint opt_cluster_by_clause_no_hint opt_with_connection_clause opt_options_list next_statement_kind_create_table_opt_as_or_semicolon
	| "CREATE" next_statement_kind_create_modifiers "MODEL"
	| "CREATE" next_statement_kind_create_modifiers "TABLE" "FUNCTION"
	| "CREATE" next_statement_kind_create_modifiers "EXTERNAL" "TABLE"
	| "CREATE" next_statement_kind_create_modifiers "EXTERNAL" "SCHEMA"
	| "CREATE" opt_or_replace "PRIVILEGE"
	| "CREATE" opt_or_replace "ROW" opt_access "POLICY"
	| "CREATE" next_statement_kind_create_modifiers opt_recursive "VIEW"
	| "CREATE" opt_or_replace "APPROX" opt_recursive "VIEW"
	| "CREATE" opt_or_replace "MATERIALIZED" opt_recursive "VIEW"
	| "CREATE" opt_or_replace "SNAPSHOT" "SCHEMA"
	| "CREATE" opt_or_replace "SNAPSHOT" "TABLE"
	| "CALL"
	| "RETURN"
	| "IMPORT"
	| "MODULE"
	| "ANALYZE"
	| "ASSERT"
	| "TRUNCATE"
	| "IF"
	| "WHILE"
	| "LOOP"
	| "DECLARE"
	| "BREAK"
	| "LEAVE"
	| "CONTINUE"
	| "ITERATE"
	| "RAISE"
	| "FOR"
	| "REPEAT"
	| label ':' "BEGIN"
	| label ':' "LOOP"
	| label ':' "WHILE"
	| label ':' "FOR"
	| label ':' "REPEAT"
	| "UNDROP" schema_object_kind
	;

spanner_primary_key :
	"PRIMARY" "KEY" primary_key_element_list
	;

opt_spanner_index_interleave_clause :
	',' "INTERLEAVE" "IN" /*4N*/ maybe_dashed_path_expression
	| /*empty*/
	;

opt_spanner_interleave_in_parent_clause :
	',' "INTERLEAVE" "IN" /*4N*/ "PARENT" maybe_dashed_path_expression opt_foreign_key_on_delete
	| /*empty*/
	;

opt_spanner_table_options :
	spanner_primary_key opt_spanner_interleave_in_parent_clause
	| /*empty*/
	;

opt_spanner_null_filtered :
	"NULL_FILTERED"
	| /*empty*/
	;

spanner_generated_or_default :
	"AS" '(' /*14L*/ expression ')' "STORED"
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
	"ALTER" "COLUMN" opt_if_exists identifier column_schema_inner opt_spanner_not_null_attribute opt_spanner_generated_or_default opt_options_list
	;

spanner_set_on_delete_action :
	"SET" "ON" "DELETE" foreign_key_action
	;

%%

%option caseless

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
"<<"	"<<"
"<="	"<="
"<>"	"<>"
"<"	'<'
"="	'='
">="	">="
">>"	">>"
">"	'>'
"||"	"||"
"|"	'|'
"-="	"-="
"->"	"->"
"-"	'-'
","	','
";"	';'
":"	':'
"!="	"!="
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
"*"	'*'
"&"	'&'
"+="	"+="
"+"	'+'
"ABORT"	"ABORT"
"ACCESS"	"ACCESS"
"ACTION"	"ACTION"
"ADD"	"ADD"
"AGGREGATE"	"AGGREGATE"
"ALL"	"ALL"
"ALTER"	"ALTER"
"ALWAYS"	"ALWAYS"
"ANALYZE"	"ANALYZE"
"ANY"	"ANY"
"APPROX"	"APPROX"
"ARE"	"ARE"
"ARRAY"	"ARRAY"
"AS"	"AS"
"ASC"	"ASC"
"ASSERT"	"ASSERT"
"ASSERT_ROWS_MODIFIED"	"ASSERT_ROWS_MODIFIED"
"AT"	"AT"
"BATCH"	"BATCH"
"BEGIN"	"BEGIN"
"BETWEEN"	"BETWEEN"
"BIGDECIMAL"	"BIGDECIMAL"
"BIGNUMERIC"	"BIGNUMERIC"
"BREAK"	"BREAK"
"BY"	"BY"
"CALL"	"CALL"
"CASCADE"	"CASCADE"
"CASE"	"CASE"
"CAST"	"CAST"
"CHECK"	"CHECK"
"CLAMPED"	"CLAMPED"
"CLONE"	"CLONE"
"CLUSTER"	"CLUSTER"
"COLLATE"	"COLLATE"
"COLUMN"	"COLUMN"
"COLUMNS"	"COLUMNS"
"COMMIT"	"COMMIT"
"CONNECTION"	"CONNECTION"
"CONSTANT"	"CONSTANT"
"CONSTRAINT"	"CONSTRAINT"
"CONTINUE"	"CONTINUE"
"COPY"	"COPY"
"CORRESPONDING"	"CORRESPONDING"
"CREATE"	"CREATE"
"CROSS"	"CROSS"
"CUBE"	"CUBE"
"CURRENT"	"CURRENT"
"CYCLE"	"CYCLE"
"DATABASE"	"DATABASE"
"DATA"	"DATA"
"DATE"	"DATE"
"DATETIME"	"DATETIME"
"DECIMAL"	"DECIMAL"
"DECLARE"	"DECLARE"
"DEFAULT"	"DEFAULT"
"DEFINE"	"DEFINE"
"DEFINE for macros"	KW_DEFINE_FOR_MACROS
"DEFINER"	"DEFINER"
"DELETE"	"DELETE"
"DELETION"	"DELETION"
"DEPTH"	"DEPTH"
"DESC"	"DESC"
"DESCRIBE"	"DESCRIBE"
"DESCRIPTOR"	"DESCRIPTOR"
"DETERMINISTIC"	"DETERMINISTIC"
"DISTINCT"	"DISTINCT"
"DO"	"DO"
"DROP"	"DROP"
"ELSE"	"ELSE"
"ELSEIF"	"ELSEIF"
"END"	"END"
"ENFORCED"	"ENFORCED"
"ENUM"	"ENUM"
"ERROR"	"ERROR"
"EXCEPT"	"EXCEPT"
"EXCEPTION"	"EXCEPTION"
"EXCLUDE"	"EXCLUDE"
"EXECUTE"	"EXECUTE"
"EXISTS"	"EXISTS"
"EXPLAIN"	"EXPLAIN"
"EXPORT"	"EXPORT"
"EXTEND"	"EXTEND"
"EXTERNAL"	"EXTERNAL"
"EXTRACT"	"EXTRACT"
"FALSE"	"FALSE"
"FILES"	"FILES"
"FILL"	"FILL"
"FILTER"	"FILTER"
"FIRST"	"FIRST"
"FOLLOWING"	"FOLLOWING"
"FOREIGN"	"FOREIGN"
"FOR"	"FOR"
"FORMAT"	"FORMAT"
"FROM"	"FROM"
"FUNCTION"	"FUNCTION"
"GENERATED"	"GENERATED"
"GRANT"	"GRANT"
"GRAPH"	"GRAPH"
"GROUP"	"GROUP"
"GROUPING"	"GROUPING"
"GROUP_ROWS"	"GROUP_ROWS"
"HASH"	"HASH"
"HAVING"	"HAVING"
"HIDDEN"	"HIDDEN"
"IDENTITY"	"IDENTITY"
"IF"	"IF"
"IGNORE"	"IGNORE"
"IMMEDIATE"	"IMMEDIATE"
"IMMUTABLE"	"IMMUTABLE"
"IMPORT"	"IMPORT"
"INCLUDE"	"INCLUDE"
"INCREMENT"	"INCREMENT"
"INDEX"	"INDEX"
"IN"	"IN"
"INNER"	"INNER"
"INOUT"	"INOUT"
"INPUT"	"INPUT"
"INSERT"	"INSERT"
"INTERLEAVE"	"INTERLEAVE"
"INTERSECT"	"INTERSECT"
"INTERVAL"	"INTERVAL"
"INTO"	"INTO"
"INVOKER"	"INVOKER"
"IS"	"IS"
"ISOLATION"	"ISOLATION"
"ITERATE"	"ITERATE"
"JOIN"	"JOIN"
"JSON"	"JSON"
"KEY"	"KEY"
"AND"	"AND"
"@@"	KW_DOUBLE_AT
"EXCEPT in set operation"	KW_EXCEPT_IN_SET_OP
KW_FULL_IN_SET_OP	KW_FULL_IN_SET_OP
"FULL"	"FULL"
KW_LEFT_IN_SET_OP	KW_LEFT_IN_SET_OP
"LEFT"	KW_LEFT
"=>"	KW_NAMED_ARGUMENT_ASSIGNMENT
KW_OPEN_HINT	KW_OPEN_HINT
KW_OPEN_INTEGER_HINT	KW_OPEN_INTEGER_HINT
KW_OPTIONS_IN_SELECT_WITH_OPTIONS	KW_OPTIONS_IN_SELECT_WITH_OPTIONS
"OR"	"OR"
KW_QUALIFY_NONRESERVED	KW_QUALIFY_NONRESERVED
KW_QUALIFY_RESERVED	KW_QUALIFY_RESERVED
KW_REPLACE_AFTER_INSERT	KW_REPLACE_AFTER_INSERT
KW_UPDATE_AFTER_INSERT	KW_UPDATE_AFTER_INSERT
KW_WITH_STARTING_WITH_EXPRESSION	KW_WITH_STARTING_WITH_EXPRESSION
KW_WITH_STARTING_WITH_GROUP_ROWS	KW_WITH_STARTING_WITH_GROUP_ROWS
"LANGUAGE"	"LANGUAGE"
"LAST"	"LAST"
"LEAVE"	"LEAVE"
"LEVEL"	"LEVEL"
"LIKE"	"LIKE"
"LIMIT"	"LIMIT"
"LOAD"	"LOAD"
"LOOKUP"	"LOOKUP"
"LOOP"	"LOOP"
"MACRO"	"MACRO"
"MAP"	"MAP"
"MATCHED"	"MATCHED"
"MATCH"	"MATCH"
"MATERIALIZED"	"MATERIALIZED"
"MAX"	"MAX"
"MAXVALUE"	"MAXVALUE"
"MERGE"	"MERGE"
"MESSAGE"	"MESSAGE"
"METADATA"	"METADATA"
"MIN"	"MIN"
"MINVALUE"	"MINVALUE"
"MODEL"	"MODEL"
"MODULE"	"MODULE"
"NATURAL"	"NATURAL"
"NEW"	"NEW"
"NO"	"NO"
"NOT"	"NOT"
"NOT_SPECIAL"	"NOT_SPECIAL"
"NULL_FILTERED"	"NULL_FILTERED"
"NULL"	"NULL"
"NULLS"	"NULLS"
"NUMERIC"	"NUMERIC"
"OFFSET"	"OFFSET"
"OF"	"OF"
"ONLY"	"ONLY"
"ON"	"ON"
"OPTIONS"	"OPTIONS"
"ORDER"	"ORDER"
"OUTER"	"OUTER"
"OUT"	"OUT"
"OUTPUT"	"OUTPUT"
"OVER"	"OVER"
"OVERWRITE"	"OVERWRITE"
"PARENT"	"PARENT"
"PARTITION"	"PARTITION"
"PARTITIONS"	"PARTITIONS"
"PERCENT"	"PERCENT"
"PIVOT"	"PIVOT"
"POLICIES"	"POLICIES"
"POLICY"	"POLICY"
"PRECEDING"	"PRECEDING"
"PRIMARY"	"PRIMARY"
"PRIVATE"	"PRIVATE"
"PRIVILEGE"	"PRIVILEGE"
"PRIVILEGES"	"PRIVILEGES"
"PROCEDURE"	"PROCEDURE"
"PROJECT"	"PROJECT"
"PROTO"	"PROTO"
"PUBLIC"	"PUBLIC"
"RAISE"	"RAISE"
"RANGE"	"RANGE"
"READ"	"READ"
"RECURSIVE"	"RECURSIVE"
"REFERENCES"	"REFERENCES"
"REMOTE"	"REMOTE"
"REMOVE"	"REMOVE"
"RENAME"	"RENAME"
"REPEATABLE"	"REPEATABLE"
"REPEAT"	"REPEAT"
"REPLACE_FIELDS"	"REPLACE_FIELDS"
"REPLACE"	"REPLACE"
"REPLICA"	"REPLICA"
"REPORT"	"REPORT"
"RESPECT"	"RESPECT"
"RESTRICTION"	"RESTRICTION"
"RESTRICT"	"RESTRICT"
"RETURN"	"RETURN"
"RETURNS"	"RETURNS"
"REVOKE"	"REVOKE"
"RIGHT"	"RIGHT"
"ROLLBACK"	"ROLLBACK"
"ROLLUP"	"ROLLUP"
"ROW"	"ROW"
"ROWS"	"ROWS"
"RUN"	"RUN"
"SAFE_CAST"	"SAFE_CAST"
"SCHEMA"	"SCHEMA"
"SEARCH"	"SEARCH"
"SECURITY"	"SECURITY"
"SELECT"	"SELECT"
"SEQUENCE"	"SEQUENCE"
"SET"	"SET"
"SETS"	"SETS"
"SHOW"	"SHOW"
"SIMPLE"	"SIMPLE"
"SNAPSHOT"	"SNAPSHOT"
"SOME"	"SOME"
"SOURCE"	"SOURCE"
"SQL"	"SQL"
"STABLE"	"STABLE"
"START"	"START"
"STORED"	"STORED"
"STORING"	"STORING"
"STRICT"	"STRICT"
"STRUCT"	"STRUCT"
"SYSTEM"	"SYSTEM"
"SYSTEM_TIME"	"SYSTEM_TIME"
"TABLESAMPLE"	"TABLESAMPLE"
"TABLES"	"TABLES"
"TABLE"	"TABLE"
"TARGET"	"TARGET"
"TEMPORARY"	"TEMPORARY"
"TEMP"	"TEMP"
"THEN"	"THEN"
"TIMESTAMP"	"TIMESTAMP"
"TIME"	"TIME"
"TO"	"TO"
"TRANSACTION"	"TRANSACTION"
"TRANSFORM"	"TRANSFORM"
"TRUE"	"TRUE"
"TRUNCATE"	"TRUNCATE"
"TYPE"	"TYPE"
"UNBOUNDED"	"UNBOUNDED"
"UNDROP"	"UNDROP"
"UNION"	"UNION"
"UNIQUE"	"UNIQUE"
"UNKNOWN"	"UNKNOWN"
"UNNEST"	"UNNEST"
"UNPIVOT"	"UNPIVOT"
"UNTIL"	"UNTIL"
"UPDATE"	"UPDATE"
"USING"	"USING"
"VALUES"	"VALUES"
"VALUE"	"VALUE"
"VECTOR"	"VECTOR"
"VIEWS"	"VIEWS"
"VIEW"	"VIEW"
"VOLATILE"	"VOLATILE"
"WEIGHT"	"WEIGHT"
"WHEN"	"WHEN"
"WHERE"	"WHERE"
"WHILE"	"WHILE"
"WINDOW"	"WINDOW"
"WITH"	"WITH"
"WRITE"	"WRITE"
"ZONE"	"ZONE"

{bytes_literal}	BYTES_LITERAL
{floating_point_literal}	FLOATING_POINT_LITERAL
{decimal_digits}|{hex_integer}	INTEGER_LITERAL
MACRO_BODY_TOKEN	MACRO_BODY_TOKEN
MODE_EXPRESSION	MODE_EXPRESSION
MODE_NEXT_SCRIPT_STATEMENT	MODE_NEXT_SCRIPT_STATEMENT
MODE_NEXT_STATEMENT_KIND	MODE_NEXT_STATEMENT_KIND
MODE_NEXT_STATEMENT	MODE_NEXT_STATEMENT
MODE_SCRIPT	MODE_SCRIPT
MODE_STATEMENT	MODE_STATEMENT
MODE_TYPE	MODE_TYPE
OPEN_INTEGER_PREFIX_HINT	OPEN_INTEGER_PREFIX_HINT
SCRIPT_LABEL	SCRIPT_LABEL
{string_literal}	STRING_LITERAL

{identifier}	IDENTIFIER

%%
