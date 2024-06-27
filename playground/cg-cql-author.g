//From: https://github.com/ricomariani/CG-SQL-author/commit/5e4ef0c992dd0240adc97f37dfdb557628b0ed4c
/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

// In case there is any doubt, 'cql.y' is included in the license as well as
// the code bison generates from it.

// cql - pronounced "see-cue-el" is a basic tool for enabling stored
//      procedures for SQLite. The tool does this by parsing specialized
//      .sql files:
//
//      - loose DDL (not in a proc) in the .sql is used to declare tables and views
//        has no other effect
//      - SQL DML and DDL logic is converted to the equivalent sqlite calls to do the work
//      - loose DML and loose control flow is consolidated into a global proc you can name
//        with the --global_proc command line switch
//      - control flow is converted to C control flow
//      - stored procs map into C functions directly, stored procs with a result set
//        become a series of procs for creating, accessing, and destroying the result set
//      - all sqlite code gen has full error checking and participates in SQL try/catch
//        and throw patterns
//      - strings and result sets can be mapped into assorted native objects by
//        defining the items in cqlrt.h
//      - everything is strongly typed, and type checked, using the primitive types:
//        bool, int, long int, real, and text
//
// Design principles:
//
//  1. Keep each pass in one file (simple, focused, and easy refactor).
//  2. Use simple printable AST parse nodes (no separate #define per AST node type).
//  3. 100% unit test coverage on all passes including output validation.

/*Tokens*/
%token ID
%token TRUE_
%token FALSE_
%token STRLIT
%token CSTRLIT
%token BLOBLIT
%token INTLIT
%token BOOL_
%token AT_DUMMY_NULLABLES
%token AT_DUMMY_DEFAULTS
%token LONGLIT
%token REALLIT
%token ':'
%token UNION_ALL
%token UNION
%token INTERSECT
%token EXCEPT
%token OR
%token AND
%token NOT
%token BETWEEN
%token NOT_BETWEEN
%token '='
%token LIKE
%token NOT_LIKE
%token GLOB
%token NOT_GLOB
%token MATCH
%token NOT_MATCH
%token REGEXP
%token NOT_REGEXP
%token IN
%token NOT_IN
%token IS_NOT
%token IS
%token IS_TRUE
%token IS_FALSE
%token IS_NOT_TRUE
%token IS_NOT_FALSE
%token ISNULL
%token NOTNULL
%token '<'
%token '>'
%token '&'
%token '|'
%token '+'
%token '-'
%token '*'
%token '/'
%token '%'
%token COLLATE
%token UMINUS
%token '~'
%token ASSIGN
%token CONCAT
%token EQEQ
%token GE
%token LE
%token LS
%token NE
%token NE_
%token RS
%token EXCLUDE_GROUP
%token EXCLUDE_CURRENT_ROW
%token EXCLUDE_TIES
%token EXCLUDE_NO_OTHERS
%token CURRENT_ROW
%token UNBOUNDED
%token PRECEDING
%token FOLLOWING
%token AT_BLOB_GET_KEY_TYPE
%token AT_BLOB_GET_VAL_TYPE
%token AT_BLOB_GET_KEY
%token AT_BLOB_GET_VAL
%token AT_BLOB_CREATE_KEY
%token AT_BLOB_CREATE_VAL
%token AT_BLOB_UPDATE_KEY
%token AT_BLOB_UPDATE_VAL
%token CREATE
%token DROP
%token TABLE
%token WITHOUT
%token ROWID
%token PRIMARY
%token KEY
%token NULL_
%token DEFAULT
%token CHECK
%token AT_DUMMY_SEED
%token VIRTUAL
%token AT_EMIT_GROUP
%token AT_EMIT_ENUMS
%token AT_EMIT_CONSTANTS
%token OBJECT
%token TEXT
%token BLOB
%token LONG_
%token INT_
%token INTEGER
%token LONG_INT
%token LONG_INTEGER
%token REAL
%token ON
%token UPDATE
%token CASCADE
%token ON_CONFLICT
%token DO
%token NOTHING
%token DELETE
%token INDEX
%token FOREIGN
%token REFERENCES
%token CONSTRAINT
%token UPSERT
%token STATEMENT
%token CONST
%token INSERT
%token INTO
%token VALUES
%token VIEW
%token SELECT
%token QUERY_PLAN
%token EXPLAIN
%token OVER
%token WINDOW
%token FILTER
%token PARTITION
%token RANGE
%token ROWS
%token GROUPS
%token AS
%token CASE
%token WHEN
%token FROM
%token FROM_BLOB
%token THEN
%token ELSE
%token END
%token LEFT
%token SWITCH
%token OUTER
%token JOIN
%token WHERE
%token GROUP
%token BY
%token ORDER
%token ASC
%token NULLS
%token FIRST
%token LAST
%token DESC
%token INNER
%token AUTOINCREMENT
%token DISTINCT
%token LIMIT
%token OFFSET
%token TEMP
%token TRIGGER
%token IF
%token ALL
%token CROSS
%token USING
%token RIGHT
%token AT_EPONYMOUS
%token HIDDEN
%token UNIQUE
%token HAVING
%token SET
%token LET
%token TO
%token DISTINCTROW
%token ENUM
%token FUNC
%token FUNCTION
%token PROC
%token PROCEDURE
%token INTERFACE
%token BEGIN_
%token OUT
%token INOUT
%token CURSOR
%token DECLARE
%token VAR
%token TYPE
%token FETCH
%token LOOP
%token LEAVE
%token CONTINUE
%token FOR
%token ENCODE
%token CONTEXT_COLUMN
%token CONTEXT_TYPE
//%token OPEN
%token CLOSE
%token ELSE_IF
%token WHILE
%token CALL
%token TRY
%token CATCH
%token THROW
%token RETURN
%token SAVEPOINT
%token ROLLBACK
%token COMMIT
%token TRANSACTION
%token RELEASE
%token ARGUMENTS
%token TYPE_CHECK
%token CAST
%token WITH
%token RECURSIVE
%token REPLACE
%token IGNORE
%token ADD
%token COLUMN
%token COLUMNS
//%token RENAME
%token ALTER
%token AT_ECHO
%token AT_CREATE
%token AT_RECREATE
%token AT_DELETE
%token AT_SCHEMA_UPGRADE_VERSION
%token AT_PREVIOUS_SCHEMA
%token AT_SCHEMA_UPGRADE_SCRIPT
%token AT_RC
%token AT_PROC
%token AT_FILE
%token AT_ATTRIBUTE
%token AT_SENSITIVE
%token DEFERRED
%token NOT_DEFERRABLE
%token DEFERRABLE
%token IMMEDIATE
%token EXCLUSIVE
%token RESTRICT
%token ACTION
%token INITIALLY
%token NO
%token BEFORE
%token AFTER
%token INSTEAD
%token OF
%token FOR_EACH_ROW
%token EXISTS
%token RAISE
%token FAIL
%token ABORT
%token AT_ENFORCE_STRICT
%token AT_ENFORCE_NORMAL
%token AT_ENFORCE_RESET
%token AT_ENFORCE_PUSH
%token AT_ENFORCE_POP
%token AT_BEGIN_SCHEMA_REGION
%token AT_END_SCHEMA_REGION
%token AT_DECLARE_SCHEMA_REGION
%token AT_DECLARE_DEPLOYABLE_REGION
%token AT_SCHEMA_AD_HOC_MIGRATION
%token PRIVATE
%token SIGN_FUNCTION
%token CURSOR_HAS_ROW
%token AT_UNSUB
%token ';'
%token '('
%token ')'
%token ','
%token '['
%token ']'
%token '.'

%left /*1*/ ':'
%left /*2*/ UNION_ALL UNION INTERSECT EXCEPT
%right /*3*/ ASSIGN
%left /*4*/ OR
%left /*5*/ AND
%left /*6*/ NOT
%left /*7*/ BETWEEN NOT_BETWEEN '=' LIKE NOT_LIKE GLOB NOT_GLOB MATCH NOT_MATCH REGEXP NOT_REGEXP IN NOT_IN IS_NOT IS IS_TRUE IS_FALSE IS_NOT_TRUE IS_NOT_FALSE EQEQ NE NE_
%right /*8*/ ISNULL NOTNULL
%left /*9*/ '<' '>' GE LE
%left /*10*/ '&' '|' LS RS
%left /*11*/ '+' '-'
%left /*12*/ '*' '/' '%'
%left /*13*/ CONCAT
%left /*14*/ COLLATE
%right /*15*/ UMINUS '~'

%start program

%%

program :
	opt_stmt_list
	;

opt_stmt_list :
	/*empty*/
	| stmt_list
	;

stmt_list :
	stmt
	| stmt_list stmt
	;

stmt :
	misc_attrs any_stmt ';'
	;

any_stmt :
	alter_table_add_column_stmt
	| begin_schema_region_stmt
	| begin_trans_stmt
	| blob_get_key_type_stmt
	| blob_get_val_type_stmt
	| blob_get_key_stmt
	| blob_get_val_stmt
	| blob_create_key_stmt
	| blob_create_val_stmt
	| blob_update_key_stmt
	| blob_update_val_stmt
	| call_stmt
	| close_stmt
	| commit_return_stmt
	| commit_trans_stmt
	| continue_stmt
	| create_index_stmt
	| create_proc_stmt
	| create_table_stmt
	| create_trigger_stmt
	| create_view_stmt
	| create_virtual_table_stmt
	| declare_deployable_region_stmt
	| declare_enum_stmt
	| declare_const_stmt
	| declare_group_stmt
	| declare_select_func_no_check_stmt
	| declare_func_stmt
	| declare_out_call_stmt
	| declare_proc_no_check_stmt
	| declare_proc_stmt
	| declare_interface_stmt
	| declare_schema_region_stmt
	| declare_vars_stmt
	| declare_forward_read_cursor_stmt
	| declare_fetched_value_cursor_stmt
	| declare_type_stmt
	| delete_stmt
	| drop_index_stmt
	| drop_table_stmt
	| drop_trigger_stmt
	| drop_view_stmt
	| echo_stmt
	| emit_enums_stmt
	| emit_group_stmt
	| emit_constants_stmt
	| end_schema_region_stmt
	| enforce_normal_stmt
	| enforce_pop_stmt
	| enforce_push_stmt
	| enforce_reset_stmt
	| enforce_strict_stmt
	| explain_stmt
	| select_nothing_stmt
	| fetch_call_stmt
	| fetch_stmt
	| fetch_values_stmt
	| fetch_cursor_from_blob_stmt
	| guard_stmt
	| if_stmt
	| insert_stmt
	| leave_stmt
	| let_stmt
	| loop_stmt
	| out_stmt
	| out_union_stmt
	| out_union_parent_child_stmt
	| previous_schema_stmt
	| proc_savepoint_stmt
	| release_savepoint_stmt
	| return_stmt
	| rollback_return_stmt
	| rollback_trans_stmt
	| savepoint_stmt
	| select_stmt
	| schema_ad_hoc_migration_stmt
	| schema_unsub_stmt
	| schema_upgrade_script_stmt
	| schema_upgrade_version_stmt
	| set_stmt
	| switch_stmt
	| throw_stmt
	| trycatch_stmt
	| update_cursor_stmt
	| update_stmt
	| upsert_stmt
	| while_stmt
	| with_delete_stmt
	| with_insert_stmt
	| with_update_stmt
	| with_upsert_stmt
	;

explain_stmt :
	EXPLAIN opt_query_plan explain_target
	;

opt_query_plan :
	/*empty*/
	| QUERY_PLAN
	;

explain_target :
	select_stmt
	| update_stmt
	| delete_stmt
	| with_delete_stmt
	| with_insert_stmt
	| with_update_stmt
	| with_upsert_stmt
	| insert_stmt
	| upsert_stmt
	| drop_table_stmt
	| drop_view_stmt
	| drop_index_stmt
	| drop_trigger_stmt
	| begin_trans_stmt
	| commit_trans_stmt
	;

previous_schema_stmt :
	AT_PREVIOUS_SCHEMA
	;

schema_upgrade_script_stmt :
	AT_SCHEMA_UPGRADE_SCRIPT
	;

schema_upgrade_version_stmt :
	AT_SCHEMA_UPGRADE_VERSION '(' INTLIT ')'
	;

set_stmt :
	SET name ASSIGN /*3R*/ expr
	| SET name FROM CURSOR name
	;

let_stmt :
	LET name ASSIGN /*3R*/ expr
	;

version_attrs_opt_recreate :
	/*empty*/
	| AT_RECREATE opt_delete_plain_attr
	| AT_RECREATE '(' name ')' opt_delete_plain_attr
	| version_attrs
	;

opt_delete_plain_attr :
	/*empty*/
	| AT_DELETE
	;

opt_version_attrs :
	/*empty*/
	| version_attrs
	;

version_attrs :
	AT_CREATE version_annotation opt_version_attrs
	| AT_DELETE version_annotation opt_version_attrs
	;

opt_delete_version_attr :
	/*empty*/
	| AT_DELETE version_annotation
	;

drop_table_stmt :
	DROP TABLE IF EXISTS name
	| DROP TABLE name
	;

drop_view_stmt :
	DROP VIEW IF EXISTS name
	| DROP VIEW name
	;

drop_index_stmt :
	DROP INDEX IF EXISTS name
	| DROP INDEX name
	;

drop_trigger_stmt :
	DROP TRIGGER IF EXISTS name
	| DROP TRIGGER name
	;

create_virtual_table_stmt :
	CREATE VIRTUAL TABLE opt_vtab_flags name USING name opt_module_args AS '(' col_key_list ')' opt_delete_version_attr
	;

opt_module_args :
	/*empty*/
	| '(' misc_attr_value_list ')'
	| '(' ARGUMENTS FOLLOWING ')'
	;

create_table_prefix_opt_temp :
	CREATE opt_temp TABLE
	;

create_table_stmt :
	create_table_prefix_opt_temp opt_if_not_exists name '(' col_key_list ')' opt_no_rowid version_attrs_opt_recreate
	;

opt_temp :
	/*empty*/
	| TEMP
	;

opt_if_not_exists :
	/*empty*/
	| IF NOT /*6L*/ EXISTS
	;

opt_no_rowid :
	/*empty*/
	| WITHOUT ROWID
	;

opt_vtab_flags :
	/*empty*/
	| IF NOT /*6L*/ EXISTS
	| AT_EPONYMOUS
	| AT_EPONYMOUS IF NOT /*6L*/ EXISTS
	| IF NOT /*6L*/ EXISTS AT_EPONYMOUS
	;

col_key_list :
	col_key_def
	| col_key_def ',' col_key_list
	;

col_key_def :
	col_def
	| pk_def
	| fk_def
	| unq_def
	| check_def
	| shape_def
	;

check_def :
	CONSTRAINT name CHECK '(' expr ')'
	| CHECK '(' expr ')'
	;

shape_exprs :
	shape_expr ',' shape_exprs
	| shape_expr
	;

shape_expr :
	name
	| '-' /*11L*/ name
	;

shape_def :
	shape_def_base
	| shape_def_base '(' shape_exprs ')'
	;

shape_def_base :
	LIKE /*7L*/ name
	| LIKE /*7L*/ name ARGUMENTS
	;

col_name :
	name
	;

misc_attr_key :
	name
	| name ':' /*1L*/ name
	;

cql_attr_key :
	name
	| name ':' /*1L*/ name
	;

misc_attr_value_list :
	misc_attr_value
	| misc_attr_value ',' misc_attr_value_list
	;

misc_attr_value :
	name
	| any_literal
	| const_expr
	| '(' misc_attr_value_list ')'
	| '-' /*11L*/ num_literal
	| '+' /*11L*/ num_literal
	;

misc_attr :
	AT_ATTRIBUTE '(' misc_attr_key ')'
	| AT_ATTRIBUTE '(' misc_attr_key '=' /*7L*/ misc_attr_value ')'
	| '[' '[' cql_attr_key ']' ']'
	| '[' '[' cql_attr_key '=' /*7L*/ misc_attr_value ']' ']'
	;

misc_attrs :
	/*empty*/
	| misc_attr misc_attrs
	;

col_def :
	misc_attrs col_name data_type_any col_attrs
	;

pk_def :
	CONSTRAINT name PRIMARY KEY '(' indexed_columns ')' opt_conflict_clause
	| PRIMARY KEY '(' indexed_columns ')' opt_conflict_clause
	;

opt_conflict_clause :
	/*empty*/
	| conflict_clause
	;

conflict_clause :
	ON_CONFLICT ROLLBACK
	| ON_CONFLICT ABORT
	| ON_CONFLICT FAIL
	| ON_CONFLICT IGNORE
	| ON_CONFLICT REPLACE
	;

opt_fk_options :
	/*empty*/
	| fk_options
	;

fk_options :
	fk_on_options
	| fk_deferred_options
	| fk_on_options fk_deferred_options
	;

fk_on_options :
	ON DELETE fk_action
	| ON UPDATE fk_action
	| ON UPDATE fk_action ON DELETE fk_action
	| ON DELETE fk_action ON UPDATE fk_action
	;

fk_action :
	SET NULL_
	| SET DEFAULT
	| CASCADE
	| RESTRICT
	| NO ACTION
	;

fk_deferred_options :
	DEFERRABLE fk_initial_state
	| NOT_DEFERRABLE fk_initial_state
	;

fk_initial_state :
	/*empty*/
	| INITIALLY DEFERRED
	| INITIALLY IMMEDIATE
	;

fk_def :
	CONSTRAINT name FOREIGN KEY '(' name_list ')' fk_target_options
	| FOREIGN KEY '(' name_list ')' fk_target_options
	;

fk_target_options :
	REFERENCES name '(' name_list ')' opt_fk_options
	;

unq_def :
	CONSTRAINT name UNIQUE '(' indexed_columns ')' opt_conflict_clause
	| UNIQUE '(' indexed_columns ')' opt_conflict_clause
	;

opt_unique :
	/*empty*/
	| UNIQUE
	;

indexed_column :
	expr opt_asc_desc
	;

indexed_columns :
	indexed_column
	| indexed_column ',' indexed_columns
	;

create_index_stmt :
	CREATE opt_unique INDEX opt_if_not_exists name ON name '(' indexed_columns ')' opt_where opt_delete_version_attr
	;

name :
	ID
	| TEXT
	| TRIGGER
	| ROWID
	| REPLACE
	| KEY
	| VIRTUAL
	| TYPE
	| HIDDEN
	| PRIVATE
	| FIRST
	| LAST
	| ADD
	| VIEW
	;

opt_name :
	/*empty*/
	| name
	;

name_list :
	name
	| name ',' name_list
	;

opt_name_list :
	/*empty*/
	| name_list
	;

cte_binding_list :
	cte_binding
	| cte_binding ',' cte_binding_list
	;

cte_binding :
	name name
	| name AS name
	;

col_attrs :
	/*empty*/
	| NOT /*6L*/ NULL_ opt_conflict_clause col_attrs
	| PRIMARY KEY opt_conflict_clause col_attrs
	| PRIMARY KEY opt_conflict_clause AUTOINCREMENT col_attrs
	| DEFAULT '-' /*11L*/ num_literal col_attrs
	| DEFAULT '+' /*11L*/ num_literal col_attrs
	| DEFAULT num_literal col_attrs
	| DEFAULT const_expr col_attrs
	| DEFAULT str_literal col_attrs
	| COLLATE /*14L*/ name col_attrs
	| CHECK '(' expr ')' col_attrs
	| UNIQUE opt_conflict_clause col_attrs
	| HIDDEN col_attrs
	| AT_SENSITIVE col_attrs
	| AT_CREATE version_annotation col_attrs
	| AT_DELETE version_annotation col_attrs
	| fk_target_options col_attrs
	;

version_annotation :
	'(' INTLIT ',' name ')'
	| '(' INTLIT ',' name ':' /*1L*/ name ')'
	| '(' INTLIT ')'
	;

opt_kind :
	/*empty*/
	| '<' /*9L*/ name '>' /*9L*/
	;

data_type_numeric :
	INT_ opt_kind
	| INTEGER opt_kind
	| REAL opt_kind
	| LONG_ opt_kind
	| BOOL_ opt_kind
	| LONG_ INTEGER opt_kind
	| LONG_ INT_ opt_kind
	| LONG_INT opt_kind
	| LONG_INTEGER opt_kind
	;

data_type_any :
	data_type_numeric
	| TEXT opt_kind
	| BLOB opt_kind
	| OBJECT opt_kind
	| OBJECT '<' /*9L*/ name CURSOR '>' /*9L*/
	| OBJECT '<' /*9L*/ name SET '>' /*9L*/
	| ID
	;

data_type_with_options :
	data_type_any
	| data_type_any NOT /*6L*/ NULL_
	| data_type_any AT_SENSITIVE
	| data_type_any AT_SENSITIVE NOT /*6L*/ NULL_
	| data_type_any NOT /*6L*/ NULL_ AT_SENSITIVE
	;

str_literal :
	str_chain
	;

str_chain :
	str_leaf
	| str_leaf str_chain
	;

str_leaf :
	STRLIT
	| CSTRLIT
	;

num_literal :
	INTLIT
	| LONGLIT
	| REALLIT
	| TRUE_
	| FALSE_
	;

const_expr :
	CONST '(' expr ')'
	;

any_literal :
	str_literal
	| num_literal
	| NULL_
	| AT_FILE '(' str_literal ')'
	| AT_PROC
	| BLOBLIT
	;

raise_expr :
	RAISE '(' IGNORE ')'
	| RAISE '(' ROLLBACK ',' expr ')'
	| RAISE '(' ABORT ',' expr ')'
	| RAISE '(' FAIL ',' expr ')'
	;

opt_distinct :
	/*empty*/
	| DISTINCT
	;

simple_call :
	name '(' opt_distinct arg_list ')' opt_filter_clause
	;

call :
	simple_call
	| basic_expr ':' /*1L*/ simple_call
	| basic_expr ':' /*1L*/ ':' /*1L*/ simple_call
	| basic_expr ':' /*1L*/ ':' /*1L*/ ':' /*1L*/ simple_call
	;

basic_expr :
	name
	| AT_RC
	| name '.' name
	| any_literal
	| const_expr
	| '(' expr ')'
	| call
	| window_func_inv
	| raise_expr
	| '(' select_stmt ')'
	| '(' select_stmt IF NOTHING THEN expr ')'
	| '(' select_stmt IF NOTHING OR /*4L*/ NULL_ THEN expr ')'
	| '(' select_stmt IF NOTHING THEN THROW ')'
	| EXISTS '(' select_stmt ')'
	| CASE expr case_list END
	| CASE expr case_list ELSE expr END
	| CASE case_list END
	| CASE case_list ELSE expr END
	| CAST '(' expr AS data_type_any ')'
	| TYPE_CHECK '(' expr AS data_type_with_options ')'
	;

math_expr :
	basic_expr
	| math_expr '&' /*10L*/ math_expr
	| math_expr '|' /*10L*/ math_expr
	| math_expr LS /*10L*/ math_expr
	| math_expr RS /*10L*/ math_expr
	| math_expr '+' /*11L*/ math_expr
	| math_expr '-' /*11L*/ math_expr
	| math_expr '*' /*12L*/ math_expr
	| math_expr '/' /*12L*/ math_expr
	| math_expr '%' /*12L*/ math_expr
	| math_expr IS_NOT_TRUE /*7L*/
	| math_expr IS_NOT_FALSE /*7L*/
	| math_expr ISNULL /*8R*/
	| math_expr NOTNULL /*8R*/
	| math_expr IS_TRUE /*7L*/
	| math_expr IS_FALSE /*7L*/
	| '-' /*11L*/ math_expr %prec UMINUS /*15R*/
	| '+' /*11L*/ math_expr %prec UMINUS /*15R*/
	| '~' /*15R*/ math_expr
	| NOT /*6L*/ math_expr
	| math_expr '=' /*7L*/ math_expr
	| math_expr EQEQ /*7L*/ math_expr
	| math_expr '<' /*9L*/ math_expr
	| math_expr '>' /*9L*/ math_expr
	| math_expr NE /*7L*/ math_expr
	| math_expr NE_ /*7L*/ math_expr
	| math_expr GE /*9L*/ math_expr
	| math_expr LE /*9L*/ math_expr
	| math_expr NOT_IN /*7L*/ '(' expr_list ')'
	| math_expr NOT_IN /*7L*/ '(' select_stmt ')'
	| math_expr IN /*7L*/ '(' expr_list ')'
	| math_expr IN /*7L*/ '(' select_stmt ')'
	| math_expr LIKE /*7L*/ math_expr
	| math_expr NOT_LIKE /*7L*/ math_expr
	| math_expr MATCH /*7L*/ math_expr
	| math_expr NOT_MATCH /*7L*/ math_expr
	| math_expr REGEXP /*7L*/ math_expr
	| math_expr NOT_REGEXP /*7L*/ math_expr
	| math_expr GLOB /*7L*/ math_expr
	| math_expr NOT_GLOB /*7L*/ math_expr
	| math_expr BETWEEN /*7L*/ math_expr AND /*5L*/ math_expr %prec BETWEEN /*7L*/
	| math_expr NOT_BETWEEN /*7L*/ math_expr AND /*5L*/ math_expr %prec BETWEEN /*7L*/
	| math_expr IS_NOT /*7L*/ math_expr
	| math_expr IS /*7L*/ math_expr
	| math_expr CONCAT /*13L*/ math_expr
	| math_expr COLLATE /*14L*/ name
	;

expr :
	math_expr
	| expr AND /*5L*/ expr
	| expr OR /*4L*/ expr
	;

case_list :
	WHEN expr THEN expr
	| WHEN expr THEN expr case_list
	;

arg_expr :
	'*' /*12L*/
	| expr
	| shape_arguments
	;

arg_list :
	/*empty*/
	| arg_expr
	| arg_expr ',' arg_list
	;

expr_list :
	expr
	| expr ',' expr_list
	;

shape_arguments :
	FROM name
	| FROM name shape_def
	| FROM ARGUMENTS
	| FROM ARGUMENTS shape_def
	;

column_calculation :
	COLUMNS '(' col_calcs ')'
	| COLUMNS '(' DISTINCT col_calcs ')'
	;

col_calcs :
	col_calc
	| col_calc ',' col_calcs
	;

col_calc :
	name
	| shape_def
	| name shape_def
	| name '.' name
	;

call_expr :
	expr
	| shape_arguments
	;

call_expr_list :
	call_expr
	| call_expr ',' call_expr_list
	;

cte_tables :
	cte_table
	| cte_table ',' cte_tables
	;

cte_decl :
	name '(' name_list ')'
	| name '(' '*' /*12L*/ ')'
	| name
	;

shared_cte :
	call_stmt
	| call_stmt USING cte_binding_list
	;

cte_table :
	cte_decl AS '(' select_stmt ')'
	| cte_decl AS '(' shared_cte ')'
	| '(' call_stmt ')'
	| '(' call_stmt USING cte_binding_list ')'
	| cte_decl LIKE /*7L*/ '(' select_stmt ')'
	| cte_decl LIKE /*7L*/ name
	;

with_prefix :
	WITH cte_tables
	| WITH RECURSIVE cte_tables
	;

with_select_stmt :
	with_prefix select_stmt_no_with
	;

select_nothing_stmt :
	SELECT NOTHING
	;

select_stmt :
	with_select_stmt
	| select_stmt_no_with
	;

select_stmt_no_with :
	select_core_list opt_orderby opt_limit opt_offset
	;

select_core_list :
	select_core
	| select_core compound_operator select_core_list
	;

values :
	'(' insert_list ')'
	| '(' insert_list ')' ',' values
	;

select_core :
	SELECT select_opts select_expr_list opt_from_query_parts opt_where opt_groupby opt_having opt_select_window
	| VALUES values
	;

compound_operator :
	UNION /*2L*/
	| UNION_ALL /*2L*/
	| INTERSECT /*2L*/
	| EXCEPT /*2L*/
	;

window_func_inv :
	simple_call OVER window_name_or_defn
	;

opt_filter_clause :
	/*empty*/
	| FILTER '(' opt_where ')'
	;

window_name_or_defn :
	window_defn
	| name
	;

window_defn :
	'(' opt_partition_by opt_orderby opt_frame_spec ')'
	;

opt_frame_spec :
	/*empty*/
	| frame_type frame_boundary_opts frame_exclude
	;

frame_type :
	RANGE
	| ROWS
	| GROUPS
	;

frame_exclude :
	/*empty*/
	| EXCLUDE_NO_OTHERS
	| EXCLUDE_CURRENT_ROW
	| EXCLUDE_GROUP
	| EXCLUDE_TIES
	;

frame_boundary_opts :
	frame_boundary
	| BETWEEN /*7L*/ frame_boundary_start AND /*5L*/ frame_boundary_end
	;

frame_boundary_start :
	UNBOUNDED PRECEDING
	| expr PRECEDING
	| CURRENT_ROW
	| expr FOLLOWING
	;

frame_boundary_end :
	expr PRECEDING
	| CURRENT_ROW
	| expr FOLLOWING
	| UNBOUNDED FOLLOWING
	;

frame_boundary :
	UNBOUNDED PRECEDING
	| expr PRECEDING
	| CURRENT_ROW
	;

opt_partition_by :
	/*empty*/
	| PARTITION BY expr_list
	;

opt_select_window :
	/*empty*/
	| window_clause
	;

window_clause :
	WINDOW window_name_defn_list
	;

window_name_defn_list :
	window_name_defn
	| window_name_defn ',' window_name_defn_list
	;

window_name_defn :
	name AS window_defn
	;

region_spec :
	name
	| name PRIVATE
	;

region_list :
	region_spec ',' region_list
	| region_spec
	;

declare_schema_region_stmt :
	AT_DECLARE_SCHEMA_REGION name
	| AT_DECLARE_SCHEMA_REGION name USING region_list
	;

declare_deployable_region_stmt :
	AT_DECLARE_DEPLOYABLE_REGION name
	| AT_DECLARE_DEPLOYABLE_REGION name USING region_list
	;

begin_schema_region_stmt :
	AT_BEGIN_SCHEMA_REGION name
	;

end_schema_region_stmt :
	AT_END_SCHEMA_REGION
	;

schema_unsub_stmt :
	AT_UNSUB '(' name ')'
	;

schema_ad_hoc_migration_stmt :
	AT_SCHEMA_AD_HOC_MIGRATION version_annotation
	| AT_SCHEMA_AD_HOC_MIGRATION FOR AT_RECREATE '(' name ',' name ')'
	;

emit_enums_stmt :
	AT_EMIT_ENUMS opt_name_list
	;

emit_group_stmt :
	AT_EMIT_GROUP opt_name_list
	;

emit_constants_stmt :
	AT_EMIT_CONSTANTS name_list
	;

opt_from_query_parts :
	/*empty*/
	| FROM query_parts
	;

opt_where :
	/*empty*/
	| WHERE expr
	;

opt_groupby :
	/*empty*/
	| GROUP BY groupby_list
	;

groupby_list :
	groupby_item
	| groupby_item ',' groupby_list
	;

groupby_item :
	expr
	;

opt_asc_desc :
	/*empty*/
	| ASC opt_nullsfirst_nullslast
	| DESC opt_nullsfirst_nullslast
	;

opt_nullsfirst_nullslast :
	/*empty*/
	| NULLS FIRST
	| NULLS LAST
	;

opt_having :
	/*empty*/
	| HAVING expr
	;

opt_orderby :
	/*empty*/
	| ORDER BY orderby_list
	;

orderby_list :
	orderby_item
	| orderby_item ',' orderby_list
	;

orderby_item :
	expr opt_asc_desc
	;

opt_limit :
	/*empty*/
	| LIMIT expr
	;

opt_offset :
	/*empty*/
	| OFFSET expr
	;

select_opts :
	/*empty*/
	| ALL
	| DISTINCT
	| DISTINCTROW
	;

select_expr_list :
	select_expr
	| select_expr ',' select_expr_list
	| '*' /*12L*/
	;

select_expr :
	expr opt_as_alias
	| name '.' '*' /*12L*/
	| column_calculation
	;

opt_as_alias :
	/*empty*/
	| as_alias
	;

as_alias :
	AS name
	| name
	;

query_parts :
	table_or_subquery_list
	| join_clause
	;

table_or_subquery_list :
	table_or_subquery
	| table_or_subquery ',' table_or_subquery_list
	;

join_clause :
	table_or_subquery join_target_list
	;

join_target_list :
	join_target
	| join_target join_target_list
	;

table_or_subquery :
	name opt_as_alias
	| '(' select_stmt ')' opt_as_alias
	| '(' shared_cte ')' opt_as_alias
	| table_function opt_as_alias
	| '(' query_parts ')'
	;

join_type :
	/*empty*/
	| LEFT
	| RIGHT
	| LEFT OUTER
	| RIGHT OUTER
	| INNER
	| CROSS
	;

join_target :
	join_type JOIN table_or_subquery opt_join_cond
	;

opt_join_cond :
	/*empty*/
	| join_cond
	;

join_cond :
	ON expr
	| USING '(' name_list ')'
	;

table_function :
	name '(' arg_list ')'
	;

create_view_stmt :
	CREATE opt_temp VIEW opt_if_not_exists name AS select_stmt opt_delete_version_attr
	;

with_delete_stmt :
	with_prefix delete_stmt
	;

delete_stmt :
	DELETE FROM name opt_where
	;

opt_insert_dummy_spec :
	/*empty*/
	| AT_DUMMY_SEED '(' expr ')' dummy_modifier
	;

dummy_modifier :
	/*empty*/
	| AT_DUMMY_NULLABLES
	| AT_DUMMY_DEFAULTS
	| AT_DUMMY_NULLABLES AT_DUMMY_DEFAULTS
	| AT_DUMMY_DEFAULTS AT_DUMMY_NULLABLES
	;

insert_stmt_type :
	INSERT INTO
	| INSERT OR /*4L*/ REPLACE INTO
	| INSERT OR /*4L*/ IGNORE INTO
	| INSERT OR /*4L*/ ROLLBACK INTO
	| INSERT OR /*4L*/ ABORT INTO
	| INSERT OR /*4L*/ FAIL INTO
	| REPLACE INTO
	;

with_insert_stmt :
	with_prefix insert_stmt
	;

opt_column_spec :
	/*empty*/
	| '(' opt_name_list ')'
	| '(' shape_def ')'
	;

from_shape :
	FROM CURSOR name opt_column_spec
	| FROM name opt_column_spec
	| FROM ARGUMENTS opt_column_spec
	;

insert_stmt :
	insert_stmt_type name opt_column_spec select_stmt opt_insert_dummy_spec
	| insert_stmt_type name opt_column_spec from_shape opt_insert_dummy_spec
	| insert_stmt_type name DEFAULT VALUES
	| insert_stmt_type name USING select_stmt
	| insert_stmt_type name USING expr_names opt_insert_dummy_spec
	;

insert_list_item :
	expr
	| shape_arguments
	;

insert_list :
	/*empty*/
	| insert_list_item
	| insert_list_item ',' insert_list
	;

basic_update_stmt :
	UPDATE opt_name SET update_list opt_from_query_parts opt_where
	;

with_update_stmt :
	with_prefix update_stmt
	;

update_stmt :
	UPDATE name SET update_list opt_from_query_parts opt_where opt_orderby opt_limit
	;

update_entry :
	name '=' /*7L*/ expr
	;

update_list :
	update_entry
	| update_entry ',' update_list
	;

with_upsert_stmt :
	with_prefix upsert_stmt
	;

upsert_stmt :
	insert_stmt ON_CONFLICT conflict_target DO NOTHING
	| insert_stmt ON_CONFLICT conflict_target DO basic_update_stmt
	;

update_cursor_stmt :
	UPDATE CURSOR name opt_column_spec FROM VALUES '(' insert_list ')'
	| UPDATE CURSOR name opt_column_spec from_shape
	| UPDATE CURSOR name USING expr_names
	;

conflict_target :
	/*empty*/
	| '(' indexed_columns ')' opt_where
	;

function :
	FUNC
	| FUNCTION
	;

declare_out_call_stmt :
	DECLARE OUT call_stmt
	;

declare_enum_stmt :
	DECLARE ENUM name data_type_numeric '(' enum_values ')'
	;

enum_values :
	enum_value
	| enum_value ',' enum_values
	;

enum_value :
	name
	| name '=' /*7L*/ expr
	;

declare_const_stmt :
	DECLARE CONST GROUP name '(' const_values ')'
	;

declare_group_stmt :
	DECLARE GROUP name BEGIN_ simple_variable_decls END
	;

simple_variable_decls :
	declare_vars_stmt ';'
	| declare_vars_stmt ';' simple_variable_decls
	;

const_values :
	const_value
	| const_value ',' const_values
	;

const_value :
	name '=' /*7L*/ expr
	;

declare_select_func_no_check_stmt :
	DECLARE SELECT function name NO CHECK data_type_with_options
	| DECLARE SELECT function name NO CHECK '(' typed_names ')'
	;

declare_func_stmt :
	DECLARE function name '(' func_params ')' data_type_with_options
	| DECLARE SELECT function name '(' params ')' data_type_with_options
	| DECLARE function name '(' func_params ')' CREATE data_type_with_options
	| DECLARE SELECT function name '(' params ')' '(' typed_names ')'
	;

procedure :
	PROC
	| PROCEDURE
	;

declare_proc_no_check_stmt :
	DECLARE procedure name NO CHECK
	;

declare_proc_stmt :
	DECLARE procedure name '(' params ')'
	| DECLARE procedure name '(' params ')' '(' typed_names ')'
	| DECLARE procedure name '(' params ')' USING TRANSACTION
	| DECLARE procedure name '(' params ')' OUT '(' typed_names ')'
	| DECLARE procedure name '(' params ')' OUT '(' typed_names ')' USING TRANSACTION
	| DECLARE procedure name '(' params ')' OUT UNION /*2L*/ '(' typed_names ')'
	| DECLARE procedure name '(' params ')' OUT UNION /*2L*/ '(' typed_names ')' USING TRANSACTION
	;

declare_interface_stmt :
	DECLARE INTERFACE name '(' typed_names ')'
	| INTERFACE name '(' typed_names ')'
	;

create_proc_stmt :
	CREATE procedure name '(' params ')' BEGIN_ opt_stmt_list END
	| procedure name '(' params ')' BEGIN_ opt_stmt_list END
	;

inout :
	IN /*7L*/
	| OUT
	| INOUT
	;

typed_name :
	name data_type_with_options
	| shape_def
	| name shape_def
	;

typed_names :
	typed_name
	| typed_name ',' typed_names
	;

func_param :
	param
	| name CURSOR
	;

func_params :
	/*empty*/
	| func_param
	| func_param ',' func_params
	;

param :
	name data_type_with_options
	| inout name data_type_with_options
	| shape_def
	| name shape_def
	;

params :
	/*empty*/
	| param
	| param ',' params
	;

declare_value_cursor :
	DECLARE name CURSOR shape_def
	| CURSOR name shape_def
	| DECLARE name CURSOR LIKE /*7L*/ select_stmt
	| CURSOR name LIKE /*7L*/ select_stmt
	| DECLARE name CURSOR LIKE /*7L*/ '(' typed_names ')'
	| CURSOR name LIKE /*7L*/ '(' typed_names ')'
	;

declare_forward_read_cursor_stmt :
	DECLARE name CURSOR FOR select_stmt
	| CURSOR name FOR select_stmt
	| DECLARE name CURSOR FOR explain_stmt
	| CURSOR name FOR explain_stmt
	| DECLARE name CURSOR FOR call_stmt
	| CURSOR name FOR call_stmt
	| DECLARE name CURSOR FOR expr
	| CURSOR name FOR expr
	;

declare_fetched_value_cursor_stmt :
	DECLARE name CURSOR FETCH FROM call_stmt
	| CURSOR name FETCH FROM call_stmt
	;

declare_type_stmt :
	DECLARE name TYPE data_type_with_options
	| TYPE name data_type_with_options
	;

declare_vars_stmt :
	DECLARE name_list data_type_with_options
	| VAR name_list data_type_with_options
	| declare_value_cursor
	;

call_stmt :
	CALL name '(' ')'
	| CALL name '(' call_expr_list ')'
	| CALL name '(' '*' /*12L*/ ')'
	;

while_stmt :
	WHILE expr BEGIN_ opt_stmt_list END
	;

switch_stmt :
	SWITCH expr switch_case switch_cases
	| SWITCH expr ALL VALUES switch_case switch_cases
	;

switch_case :
	WHEN expr_list THEN stmt_list
	| WHEN expr_list THEN NOTHING
	;

switch_cases :
	switch_case switch_cases
	| ELSE stmt_list END
	| END
	;

loop_stmt :
	LOOP fetch_stmt BEGIN_ opt_stmt_list END
	;

leave_stmt :
	LEAVE
	;

return_stmt :
	RETURN
	;

rollback_return_stmt :
	ROLLBACK RETURN
	;

commit_return_stmt :
	COMMIT RETURN
	;

throw_stmt :
	THROW
	;

trycatch_stmt :
	BEGIN_ TRY opt_stmt_list END TRY ';' BEGIN_ CATCH opt_stmt_list END CATCH
	;

continue_stmt :
	CONTINUE
	;

fetch_stmt :
	FETCH name INTO name_list
	| FETCH name
	;

fetch_cursor_from_blob_stmt :
	FETCH name FROM_BLOB expr
	;

fetch_values_stmt :
	FETCH name opt_column_spec FROM VALUES '(' insert_list ')' opt_insert_dummy_spec
	| FETCH name opt_column_spec from_shape opt_insert_dummy_spec
	| FETCH name USING expr_names opt_insert_dummy_spec
	;

expr_names :
	expr_name
	| expr_name ',' expr_names
	;

expr_name :
	expr as_alias
	;

fetch_call_stmt :
	FETCH name opt_column_spec FROM call_stmt
	;

close_stmt :
	CLOSE name
	;

out_stmt :
	OUT name
	;

out_union_stmt :
	OUT UNION /*2L*/ name
	;

out_union_parent_child_stmt :
	OUT UNION /*2L*/ call_stmt JOIN child_results
	;

child_results :
	child_result
	| child_result AND /*5L*/ child_results
	;

child_result :
	call_stmt USING '(' name_list ')'
	| call_stmt USING '(' name_list ')' AS name
	;

if_stmt :
	IF expr THEN opt_stmt_list opt_elseif_list opt_else END IF
	;

opt_else :
	/*empty*/
	| ELSE opt_stmt_list
	;

elseif_item :
	ELSE_IF expr THEN opt_stmt_list
	;

elseif_list :
	elseif_item
	| elseif_item elseif_list
	;

opt_elseif_list :
	/*empty*/
	| elseif_list
	;

control_stmt :
	commit_return_stmt
	| continue_stmt
	| leave_stmt
	| return_stmt
	| rollback_return_stmt
	| throw_stmt
	;

guard_stmt :
	IF expr control_stmt
	;

transaction_mode :
	/*empty*/
	| DEFERRED
	| IMMEDIATE
	| EXCLUSIVE
	;

begin_trans_stmt :
	BEGIN_ transaction_mode TRANSACTION
	| BEGIN_ transaction_mode
	;

rollback_trans_stmt :
	ROLLBACK
	| ROLLBACK TRANSACTION
	| ROLLBACK TO savepoint_name
	| ROLLBACK TRANSACTION TO savepoint_name
	| ROLLBACK TO SAVEPOINT savepoint_name
	| ROLLBACK TRANSACTION TO SAVEPOINT savepoint_name
	;

commit_trans_stmt :
	COMMIT TRANSACTION
	| COMMIT
	;

proc_savepoint_stmt :
	procedure SAVEPOINT BEGIN_ opt_stmt_list END
	;

savepoint_name :
	AT_PROC
	| name
	;

savepoint_stmt :
	SAVEPOINT savepoint_name
	;

release_savepoint_stmt :
	RELEASE savepoint_name
	| RELEASE SAVEPOINT savepoint_name
	;

echo_stmt :
	AT_ECHO name ',' str_literal
	;

alter_table_add_column_stmt :
	ALTER TABLE name ADD COLUMN col_def
	;

create_trigger_stmt :
	CREATE opt_temp TRIGGER opt_if_not_exists trigger_def opt_delete_version_attr
	;

trigger_def :
	name trigger_condition trigger_operation ON name trigger_action
	;

trigger_condition :
	/*empty*/
	| BEFORE
	| AFTER
	| INSTEAD OF
	;

trigger_operation :
	DELETE
	| INSERT
	| UPDATE opt_of
	;

opt_of :
	/*empty*/
	| OF name_list
	;

trigger_action :
	opt_foreachrow opt_when_expr BEGIN_ trigger_stmts END
	;

opt_foreachrow :
	/*empty*/
	| FOR_EACH_ROW
	;

opt_when_expr :
	/*empty*/
	| WHEN expr
	;

trigger_stmts :
	trigger_stmt
	| trigger_stmt trigger_stmts
	;

trigger_stmt :
	trigger_update_stmt ';'
	| trigger_insert_stmt ';'
	| trigger_delete_stmt ';'
	| trigger_select_stmt ';'
	;

trigger_select_stmt :
	select_stmt_no_with
	;

trigger_insert_stmt :
	insert_stmt
	;

trigger_delete_stmt :
	delete_stmt
	;

trigger_update_stmt :
	basic_update_stmt
	;

enforcement_options :
	FOREIGN KEY ON UPDATE
	| FOREIGN KEY ON DELETE
	| JOIN
	| UPSERT STATEMENT
	| WINDOW function
	| WITHOUT ROWID
	| TRANSACTION
	| SELECT IF NOTHING
	| INSERT SELECT
	| TABLE FUNCTION
	| ENCODE CONTEXT_COLUMN
	| ENCODE CONTEXT_TYPE INTEGER
	| ENCODE CONTEXT_TYPE LONG_INTEGER
	| ENCODE CONTEXT_TYPE REAL
	| ENCODE CONTEXT_TYPE BOOL_
	| ENCODE CONTEXT_TYPE TEXT
	| ENCODE CONTEXT_TYPE BLOB
	| IS_TRUE /*7L*/
	| CAST
	| SIGN_FUNCTION
	| CURSOR_HAS_ROW
	| UPDATE FROM
	;

enforce_strict_stmt :
	AT_ENFORCE_STRICT enforcement_options
	;

enforce_normal_stmt :
	AT_ENFORCE_NORMAL enforcement_options
	;

enforce_reset_stmt :
	AT_ENFORCE_RESET
	;

enforce_push_stmt :
	AT_ENFORCE_PUSH
	;

enforce_pop_stmt :
	AT_ENFORCE_POP
	;

opt_use_offset :
	/*empty*/
	| OFFSET
	;

blob_get_key_type_stmt :
	AT_BLOB_GET_KEY_TYPE name
	;

blob_get_val_type_stmt :
	AT_BLOB_GET_VAL_TYPE name
	;

blob_get_key_stmt :
	AT_BLOB_GET_KEY name opt_use_offset
	;

blob_get_val_stmt :
	AT_BLOB_GET_VAL name opt_use_offset
	;

blob_create_key_stmt :
	AT_BLOB_CREATE_KEY name opt_use_offset
	;

blob_create_val_stmt :
	AT_BLOB_CREATE_VAL name opt_use_offset
	;

blob_update_key_stmt :
	AT_BLOB_UPDATE_KEY name opt_use_offset
	;

blob_update_val_stmt :
	AT_BLOB_UPDATE_VAL name opt_use_offset
	;

%%

%option caseless
%x FROM_BLOB_TS

stop [^A-Z_0-9]
sp [ \t]+
hex [0-9A-F]
d [0-9]

%%

EXCLUDE{sp}NO{sp}OTHERS   EXCLUDE_NO_OTHERS
EXCLUDE{sp}CURRENT{sp}ROW EXCLUDE_CURRENT_ROW
EXCLUDE{sp}GROUP          EXCLUDE_GROUP
EXCLUDE{sp}TIES           EXCLUDE_TIES

CURRENT{sp}ROW        CURRENT_ROW
UNBOUNDED                    UNBOUNDED
PRECEDING                    PRECEDING
FOLLOWING                    FOLLOWING
SWITCH                       SWITCH
RANGE                        RANGE
ENUM                         ENUM
ROWS                         ROWS
GROUPS                       GROUPS
PARTITION                    PARTITION
FILTER                       FILTER
WINDOW                       WINDOW
EXPLAIN                      EXPLAIN
QUERY{sp}PLAN         QUERY_PLAN
SELECT                       SELECT
CAST                         CAST
CREATE                       CREATE
DROP                         DROP
TABLE                        TABLE
TEMP                         TEMP
COLLATE                      COLLATE
HIDDEN                       HIDDEN
PRIMARY                      PRIMARY
KEY                          KEY
IF                           IF
WHILE                        WHILE
CALL                         CALL
EXISTS                       EXISTS
UNION                        UNION
UNION{sp}ALL          UNION_ALL
INTERSECT                    INTERSECT
EXCEPT                       EXCEPT
NOT                          NOT
NULL                         NULL_
NULLS                        NULLS
TRUE                         TRUE_
FALSE                        FALSE_
DEFAULT                      DEFAULT
CHECK                        CHECK
LET                          LET
LONG                         LONG_
LONG_INTEGER                 LONG_INTEGER
LONG_INT                     LONG_INT
INT                          INT_
INTEGER                      INTEGER
TEXT                         TEXT
VIRTUAL                      VIRTUAL
WITH                         WITH
RECURSIVE                    RECURSIVE
WITHOUT                      WITHOUT
ROWID                        ROWID
AUTOINCREMENT                AUTOINCREMENT
BOOL                         BOOL_
REFERENCES                   REFERENCES
FOREIGN                      FOREIGN
REAL                         REAL
CASCADE                      CASCADE
ON                           ON
ON{sp}CONFLICT        ON_CONFLICT
DO                           DO
NOTHING                      NOTHING
UPDATE                       UPDATE
DELETE                       DELETE
CONST                        CONST
CONSTRAINT                   CONSTRAINT
UNIQUE                       UNIQUE
PRIVATE                      PRIVATE
INDEX                        INDEX
ALL                          ALL
AS                           AS
BY                           BY
DISTINCT                     DISTINCT
DISTINCTROW                  DISTINCTROW
INNER                        INNER
OUTER                        OUTER
CROSS                        CROSS
USING                        USING
RIGHT                        RIGHT
FROM                         FROM
FROM{sp}BLOB{stop}<FROM_BLOB_TS>    reject()
<FROM_BLOB_TS> {
    FROM{sp}BLOB<INITIAL>   FROM_BLOB
}
WHERE                        WHERE
GROUP                        GROUP
HAVING                       HAVING
ASC                          ASC
DESC                         DESC
FIRST                        FIRST
LAST                         LAST
LEFT                         LEFT
JOIN                         JOIN
SET                          SET
OVER                         OVER
"<<"                         LS
">>"                         RS
"<>"                         NE
"!="                         NE_
">="                         GE
"<="                         LE
":="                         ASSIGN
"=="                         EQEQ
"||"                         CONCAT
IS{sp}NOT{sp}FALSE    IS_NOT_FALSE
IS{sp}NOT{sp}TRUE     IS_NOT_TRUE
IS{sp}FALSE           IS_FALSE
IS{sp}TRUE            IS_TRUE
IS{sp}NOT             IS_NOT
ISNULL                       ISNULL
NOTNULL                      NOTNULL
IS                           IS
AND                          AND
ORDER                        ORDER
CASE                         CASE
END                          END
WHEN                         WHEN
ELSE                         ELSE
THEN                         THEN
VIEW                         VIEW
INSERT                       INSERT
INTO                         INTO
VALUES                       VALUES
OR                           OR
LIMIT                        LIMIT
OFFSET                       OFFSET
PROC                         PROC
@PROC                        AT_PROC
@RC                          AT_RC
PROCEDURE                    PROCEDURE
INTERFACE                    INTERFACE
FUNCTION                     FUNCTION
FUNC                         FUNC
BEGIN                        BEGIN_
IN                           IN
NOT{sp}IN             NOT_IN
TO                           TO
FOR                          FOR
THROW                        THROW
TRY                          TRY
CATCH                        CATCH
NOT{sp}LIKE           NOT_LIKE
LIKE                         LIKE
NOT{sp}MATCH          NOT_MATCH
MATCH                        MATCH
NOT{sp}REGEXP         NOT_REGEXP
REGEXP                       REGEXP
NOT{sp}GLOB           NOT_GLOB
GLOB                         GLOB
NOT{sp}BETWEEN        NOT_BETWEEN
BETWEEN                      BETWEEN
OUT                          OUT
INOUT                        INOUT
CURSOR                       CURSOR
DECLARE                      DECLARE
VAR                          VAR
FETCH                        FETCH
LOOP                         LOOP
LEAVE                        LEAVE
CONTINUE                     CONTINUE
CLOSE                        CLOSE
ELSE{sp}IF            ELSE_IF
SAVEPOINT                    SAVEPOINT
ROLLBACK                     ROLLBACK
RAISE                        RAISE
FAIL                         FAIL
ABORT                        ABORT
COMMIT                       COMMIT
TRANSACTION                  TRANSACTION
RELEASE                      RELEASE
REPLACE                      REPLACE
IGNORE                       IGNORE
OBJECT                       OBJECT
BLOB                         BLOB
UPSERT                       UPSERT
STATEMENT                    STATEMENT
TYPE                         TYPE
TYPE_CHECK                   TYPE_CHECK
@ATTRIBUTE                   AT_ATTRIBUTE
@BEGIN_SCHEMA_REGION         AT_BEGIN_SCHEMA_REGION
@BLOB_GET_KEY_TYPE           AT_BLOB_GET_KEY_TYPE
@BLOB_GET_VAL_TYPE           AT_BLOB_GET_VAL_TYPE
@BLOB_GET_KEY                AT_BLOB_GET_KEY
@BLOB_GET_VAL                AT_BLOB_GET_VAL
@BLOB_CREATE_KEY             AT_BLOB_CREATE_KEY
@BLOB_CREATE_VAL             AT_BLOB_CREATE_VAL
@BLOB_UPDATE_KEY             AT_BLOB_UPDATE_KEY
@BLOB_UPDATE_VAL             AT_BLOB_UPDATE_VAL
@CREATE                      AT_CREATE
@DECLARE_DEPLOYABLE_REGION   AT_DECLARE_DEPLOYABLE_REGION
@DECLARE_SCHEMA_REGION       AT_DECLARE_SCHEMA_REGION
@DELETE                      AT_DELETE
@DUMMY_DEFAULTS              AT_DUMMY_DEFAULTS
@DUMMY_NULLABLES             AT_DUMMY_NULLABLES
@DUMMY_SEED                  AT_DUMMY_SEED
@ECHO                        AT_ECHO
@EMIT_CONSTANTS              AT_EMIT_CONSTANTS
@EMIT_ENUMS                  AT_EMIT_ENUMS
@EMIT_GROUP                  AT_EMIT_GROUP
@END_SCHEMA_REGION           AT_END_SCHEMA_REGION
@ENFORCE_NORMAL              AT_ENFORCE_NORMAL
@ENFORCE_POP                 AT_ENFORCE_POP
@ENFORCE_PUSH                AT_ENFORCE_PUSH
@ENFORCE_RESET               AT_ENFORCE_RESET
@ENFORCE_STRICT              AT_ENFORCE_STRICT
@EPONYMOUS                   AT_EPONYMOUS
@FILE                        AT_FILE
@PREVIOUS_SCHEMA             AT_PREVIOUS_SCHEMA
@RECREATE                    AT_RECREATE
@SCHEMA_AD_HOC_MIGRATION     AT_SCHEMA_AD_HOC_MIGRATION
@SCHEMA_UPGRADE_SCRIPT       AT_SCHEMA_UPGRADE_SCRIPT
@SCHEMA_UPGRADE_VERSION      AT_SCHEMA_UPGRADE_VERSION
@SENSITIVE                   AT_SENSITIVE
@UNSUB                       AT_UNSUB
ALTER                        ALTER
//RENAME                       RENAME
COLUMN                       COLUMN
COLUMNS                      COLUMNS
ADD                          ADD
ARGUMENTS                    ARGUMENTS
RETURN                       RETURN
DEFERRED                     DEFERRED
DEFERRABLE                   DEFERRABLE
NOT{sp}DEFERRABLE     NOT_DEFERRABLE
IMMEDIATE                    IMMEDIATE
EXCLUSIVE                    EXCLUSIVE
RESTRICT                     RESTRICT
ACTION                       ACTION
INITIALLY                    INITIALLY
NO                           NO
BEFORE                       BEFORE
AFTER                        AFTER
INSTEAD                      INSTEAD
OF                           OF
TRIGGER                      TRIGGER
FOR{sp}EACH{sp}ROW    FOR_EACH_ROW
ENCODE                       ENCODE
CONTEXT{sp}COLUMN     CONTEXT_COLUMN
CONTEXT{sp}TYPE       CONTEXT_TYPE
SIGN{sp}FUNCTION      SIGN_FUNCTION
CURSOR{sp}HAS{sp}ROW  CURSOR_HAS_ROW

//<<EOF>>                      { if (cql_finish_stream()) yyterminate()

0x{hex}+                     INTLIT
0x{hex}+L                    LONGLIT
{d}+                         INTLIT
{d}+L                        LONGLIT

({d}+"."{d}*|"."{d}+)(E("+"|"-")?{d}+)? REALLIT

\"("\\".|[^\\"\n\r])*\"          CSTRLIT
'(''|[^'\n\r])*'               STRLIT
X'({hex}{hex})*'             BLOBLIT

"-"	'-'
"+"	'+'
"&"	'&'
"~"	'~'
"|"	'|'
//"^"	'^'
"/"	'/'
"%"	'%'
"*"	'*'
"("	'('
")"	')'
","	','
"."	'.'
";"	';'
//"!"	'!'
"<"	'<'
">"	'>'
":"	':'
"="	'='

\[                           '['
\]                           ']'
[_A-Z][A-Z0-9_]*             ID

[ \t\n\r]                      skip()
\-\-.*                       skip()

//.                            { yyerror("Unexpected %s\n", yytext)

^"#\ {d}+\ \"[^"]*\".*        skip()
^\ *#line\ {d}+\ \"[^"]*\".* skip()

"/*"(?s:.)*?"*/"	skip()

%%
