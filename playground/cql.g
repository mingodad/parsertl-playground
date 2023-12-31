//Grammar directives

//%token ASSIGN ":="
//%token CONCAT "||"
//%token EQEQ "=="
//%token GE ">="
//%token LE "<="
//%token LS "<<"
//%token NE "<>"
//%token NE_ "!="
//%token RS ">>"

%token EXCLUDE_GROUP EXCLUDE_CURRENT_ROW EXCLUDE_TIES EXCLUDE_NO_OTHERS CURRENT_ROW UNBOUNDED PRECEDING FOLLOWING
//%token AT_BLOB_GET_KEY_TYPE AT_BLOB_GET_VAL_TYPE AT_BLOB_GET_KEY AT_BLOB_GET_VAL AT_BLOB_CREATE_KEY AT_BLOB_CREATE_VAL AT_BLOB_UPDATE_KEY AT_BLOB_UPDATE_VAL
%token CREATE DROP TABLE WITHOUT ROWID PRIMARY KEY NULL_ DEFAULT CHECK AT_DUMMY_SEED VIRTUAL AT_EMIT_GROUP AT_EMIT_ENUMS AT_EMIT_CONSTANTS
%token OBJECT TEXT BLOB LONG_ INT_  INTEGER LONG_INT LONG_INTEGER REAL ON UPDATE CASCADE ON_CONFLICT DO NOTHING
%token DELETE INDEX FOREIGN REFERENCES CONSTRAINT UPSERT STATEMENT CONST
%token INSERT INTO VALUES VIEW SELECT QUERY_PLAN EXPLAIN OVER WINDOW FILTER PARTITION RANGE ROWS GROUPS
%token AS CASE WHEN FROM THEN ELSE END LEFT SWITCH
%token OUTER JOIN WHERE GROUP BY ORDER ASC
%token DESC INNER AUTOINCREMENT DISTINCT
%token LIMIT OFFSET TEMP TRIGGER IF ALL CROSS USING RIGHT
%token HIDDEN UNIQUE HAVING SET LET TO DISTINCTROW ENUM
%token FUNC FUNCTION PROC PROCEDURE BEGIN_ OUT INOUT CURSOR DECLARE TYPE FETCH LOOP LEAVE CONTINUE FOR ENCODE CONTEXT_COLUMN CONTEXT_TYPE
%token OPEN CLOSE ELSE_IF WHILE CALL TRY CATCH THROW RETURN
%token SAVEPOINT ROLLBACK COMMIT TRANSACTION RELEASE ARGUMENTS
%token CAST WITH RECURSIVE REPLACE IGNORE ADD COLUMN ALTER
%token AT_ECHO AT_CREATE AT_RECREATE AT_DELETE AT_SCHEMA_UPGRADE_VERSION AT_PREVIOUS_SCHEMA AT_SCHEMA_UPGRADE_SCRIPT
%token AT_RC AT_PROC AT_FILE AT_ATTRIBUTE AT_SENSITIVE DEFERRED NOT_DEFERRABLE DEFERRABLE IMMEDIATE EXCLUSIVE RESTRICT ACTION INITIALLY NO
%token BEFORE AFTER INSTEAD OF FOR_EACH_ROW EXISTS RAISE FAIL ABORT AT_ENFORCE_STRICT AT_ENFORCE_NORMAL AT_ENFORCE_RESET AT_ENFORCE_PUSH AT_ENFORCE_POP
%token AT_BEGIN_SCHEMA_REGION AT_END_SCHEMA_REGION
%token AT_DECLARE_SCHEMA_REGION AT_DECLARE_DEPLOYABLE_REGION AT_SCHEMA_AD_HOC_MIGRATION PRIVATE
//%token  CURSOR_HAS_ROW AT_UNSUB AT_RESUB
%token BOOL_ ID REALLIT INTLIT LONGLIT STRLIT CSTRLIT TRUE_ FALSE_ BLOBLIT AT_DUMMY_NULLABLES AT_DUMMY_DEFAULTS

%left UNION_ALL UNION INTERSECT EXCEPT
%right ASSIGN
%left OR
%left AND
%left NOT
%left BETWEEN NOT_BETWEEN NE NE_ '=' EQEQ LIKE NOT_LIKE GLOB NOT_GLOB MATCH NOT_MATCH REGEXP NOT_REGEXP IN NOT_IN IS_NOT IS IS_TRUE IS_FALSE IS_NOT_TRUE IS_NOT_FALSE
%right ISNULL NOTNULL
%left '<' '>' GE LE
%left LS RS '&' '|'
%left '+' '-'
%left '*' '/' '%'
%left CONCAT
%left COLLATE
%right UMINUS '~'

%start program

%% //Grammar rules

program :
	opt_stmt_list
	;

opt_stmt_list :
	/* empty */
	| stmt_list
	;

stmt_list :
	stmt ';'
	| stmt_list stmt ';'
	;

stmt :
	misc_attrs any_stmt
	;

any_stmt :
	alter_table_add_column_stmt
	| begin_schema_region_stmt
	| begin_trans_stmt
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
	| declare_func_stmt
	| declare_out_call_stmt
	| declare_proc_no_check_stmt
	| declare_proc_stmt
	| declare_schema_region_stmt
	| declare_stmt
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
	| fetch_call_stmt
	| fetch_stmt
	| fetch_values_stmt
	| guard_stmt
	| if_stmt
	| insert_stmt
	| leave_stmt
	| let_stmt
	| loop_stmt
	| open_stmt
	| out_stmt
	| out_union_stmt
	| previous_schema_stmt
	| proc_savepoint_stmt
	| release_savepoint_stmt
	| return_stmt
	| rollback_return_stmt
	| rollback_trans_stmt
	| savepoint_stmt
	| select_stmt
	| schema_ad_hoc_migration_stmt
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
	/* empty */
	| QUERY_PLAN
	;

explain_target :
	select_stmt
	| update_stmt
	| delete_stmt
	| with_delete_stmt
	| with_insert_stmt
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
	SET name ASSIGN expr
	| SET name FROM CURSOR name
	;

let_stmt :
	LET name ASSIGN expr
	;

version_attrs_opt_recreate :
	/* empty */
	| AT_RECREATE
	| AT_RECREATE '(' name ')'
	| version_attrs
	;

opt_version_attrs :
	/* empty */
	| version_attrs
	;

version_attrs :
	AT_CREATE version_annotation opt_version_attrs
	| AT_DELETE version_annotation opt_version_attrs
	;

opt_delete_version_attr :
	/* empty */
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
	CREATE VIRTUAL TABLE opt_if_not_exists name USING name opt_module_args AS '(' col_key_list ')' opt_delete_version_attr
	;

opt_module_args :
	/* empty */
	| '(' misc_attr_value_list ')'
	| '(' ARGUMENTS FOLLOWING ')'
	;

create_table_stmt :
	CREATE opt_temp TABLE opt_if_not_exists name '(' col_key_list ')' opt_no_rowid version_attrs_opt_recreate
	;

opt_temp :
	/* empty */
	| TEMP
	;

opt_if_not_exists :
	/* empty */
	| IF NOT EXISTS
	;

opt_no_rowid :
	/* empty */
	| WITHOUT ROWID
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

shape_def :
	LIKE name
	| LIKE name ARGUMENTS
	;

col_name :
	name
	;

misc_attr_key :
	name
	| name ':' name
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
	| '-' num_literal
	;

misc_attr :
	AT_ATTRIBUTE '(' misc_attr_key ')'
	| AT_ATTRIBUTE '(' misc_attr_key '=' misc_attr_value ')'
	;

misc_attrs :
	/* empty */
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
	/* empty */
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
	/* empty */
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
	/* empty */
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
	/* empty */
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
	;

opt_name :
	/* empty */
	| name
	;

name_list :
	name
	| name ',' name_list
	;

opt_name_list :
	/* empty */
	| name_list
	;

col_attrs :
	/* empty */
	| NOT NULL_ opt_conflict_clause col_attrs
	| PRIMARY KEY opt_conflict_clause col_attrs
	| PRIMARY KEY opt_conflict_clause AUTOINCREMENT col_attrs
	| DEFAULT '-' num_literal col_attrs
	| DEFAULT num_literal col_attrs
	| DEFAULT const_expr col_attrs
	| DEFAULT str_literal col_attrs
	| COLLATE name col_attrs
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
	| '(' INTLIT ',' name ':' name ')'
	| '(' INTLIT ')'
	;

opt_kind :
	/* empty */
	| '<' name '>'
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
	| OBJECT '<' name CURSOR '>'
	| ID
	;

data_type_with_options :
	data_type_any
	| data_type_any NOT NULL_
	| data_type_any AT_SENSITIVE
	| data_type_any AT_SENSITIVE NOT NULL_
	| data_type_any NOT NULL_ AT_SENSITIVE
	;

str_literal :
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

call :
	name '(' arg_list ')' opt_filter_clause
	| name '(' DISTINCT arg_list ')' opt_filter_clause
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
	| '(' select_stmt IF NOTHING expr ')'
	| '(' select_stmt IF NOTHING OR NULL_ expr ')'
	| '(' select_stmt IF NOTHING THROW ')'
	| EXISTS '(' select_stmt ')'
	| CASE expr case_list END
	| CASE expr case_list ELSE expr END
	| CASE case_list END
	| CASE case_list ELSE expr END
	| CAST '(' expr AS data_type_any ')'
	;

math_expr :
	basic_expr
	| math_expr '&' math_expr
	| math_expr '|' math_expr
	| math_expr LS math_expr
	| math_expr RS math_expr
	| math_expr '+' math_expr
	| math_expr '-' math_expr
	| math_expr '*' math_expr
	| math_expr '/' math_expr
	| math_expr '%' math_expr
	| math_expr IS_NOT_TRUE
	| math_expr IS_NOT_FALSE
	| math_expr ISNULL
	| math_expr NOTNULL
	| math_expr IS_TRUE
	| math_expr IS_FALSE
	| '-' math_expr  %prec UMINUS
	| '~' math_expr  %prec UMINUS
	| NOT math_expr
	| math_expr '=' math_expr
	| math_expr EQEQ math_expr
	| math_expr '<' math_expr
	| math_expr '>' math_expr
	| math_expr NE math_expr
	| math_expr NE_ math_expr
	| math_expr GE math_expr
	| math_expr LE math_expr
	| math_expr NOT_IN '(' expr_list ')'
	| math_expr NOT_IN '(' select_stmt ')'
	| math_expr IN '(' expr_list ')'
	| math_expr IN '(' select_stmt ')'
	| math_expr LIKE math_expr
	| math_expr NOT_LIKE math_expr
	| math_expr MATCH math_expr
	| math_expr NOT_MATCH math_expr
	| math_expr REGEXP math_expr
	| math_expr NOT_REGEXP math_expr
	| math_expr GLOB math_expr
	| math_expr NOT_GLOB math_expr
	| math_expr BETWEEN math_expr AND math_expr %prec BETWEEN
	| math_expr NOT_BETWEEN math_expr AND math_expr %prec BETWEEN
	| math_expr IS_NOT math_expr
	| math_expr IS math_expr
	| math_expr CONCAT math_expr
	| math_expr COLLATE name
	;

expr :
	math_expr
	| expr AND expr
	| expr OR expr
	;

case_list :
	WHEN expr THEN expr
	| WHEN expr THEN expr case_list
	;

arg_expr :
	'*'
	| expr
	| shape_arguments
	;

arg_list :
	/* empty */
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

cte_table :
	name '(' name_list ')' AS '(' select_stmt_no_with ')'
	| name '(' '*' ')' AS '(' select_stmt_no_with ')'
	;

with_prefix :
	WITH cte_tables
	| WITH RECURSIVE cte_tables
	;

with_select_stmt :
	with_prefix select_stmt_no_with
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
	UNION
	| UNION_ALL
	| INTERSECT
	| EXCEPT
	;

window_func_inv :
	name '(' arg_list ')' opt_filter_clause OVER window_name_or_defn
	;

opt_filter_clause :
	/* empty */
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
	/* empty */
	| frame_type frame_boundary_opts frame_exclude
	;

frame_type :
	RANGE
	| ROWS
	| GROUPS
	;

frame_exclude :
	/* empty */
	| EXCLUDE_NO_OTHERS
	| EXCLUDE_CURRENT_ROW
	| EXCLUDE_GROUP
	| EXCLUDE_TIES
	;

frame_boundary_opts :
	frame_boundary
	| BETWEEN frame_boundary_start AND frame_boundary_end
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
	/* empty */
	| PARTITION BY expr_list
	;

opt_select_window :
	/* empty */
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

schema_ad_hoc_migration_stmt :
	AT_SCHEMA_AD_HOC_MIGRATION version_annotation
	| AT_SCHEMA_AD_HOC_MIGRATION FOR AT_RECREATE '(' name ',' name ')'
	;

emit_enums_stmt :
	AT_EMIT_ENUMS opt_name_list
	;

emit_group_stmt:
	AT_EMIT_GROUP opt_name_list
	;

emit_constants_stmt:
	AT_EMIT_CONSTANTS name_list
	;

opt_from_query_parts :
	/* empty */
	| FROM query_parts
	;

opt_where :
	/* empty */
	| WHERE expr
	;

opt_groupby :
	/* empty */
	| GROUP BY groupby_list
	;

groupby_list :
	groupby_item
	| groupby_item ',' groupby_list
	;

groupby_item :
	expr opt_asc_desc
	;

opt_asc_desc :
	/* empty */
	| ASC
	| DESC
	;

opt_having :
	/* empty */
	| HAVING expr
	;

opt_orderby :
	/* empty */
	| ORDER BY groupby_list
	;

opt_limit :
	/* empty */
	| LIMIT expr
	;

opt_offset :
	/* empty */
	| OFFSET expr
	;

select_opts :
	/* empty */
	| ALL
	| DISTINCT
	| DISTINCTROW
	;

select_expr_list :
	select_expr
	| select_expr ',' select_expr_list
	| '*'
	;

select_expr :
	expr opt_as_alias
	| name '.' '*'
	;

opt_as_alias :
	/* empty */
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
	| table_function opt_as_alias
	| '(' query_parts ')'
	;

join_type :
	/* empty */
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
	/* empty */
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
	/* empty */
	| AT_DUMMY_SEED '(' expr ')' dummy_modifier
	;

dummy_modifier :
	/* empty */
	| AT_DUMMY_NULLABLES
	| AT_DUMMY_DEFAULTS
	| AT_DUMMY_NULLABLES AT_DUMMY_DEFAULTS
	| AT_DUMMY_DEFAULTS AT_DUMMY_NULLABLES
	;

insert_stmt_type :
	INSERT INTO
	| INSERT OR REPLACE INTO
	| INSERT OR IGNORE INTO
	| INSERT OR ROLLBACK INTO
	| INSERT OR ABORT INTO
	| INSERT OR FAIL INTO
	| REPLACE INTO
	;

with_insert_stmt :
	with_prefix insert_stmt
	;

opt_column_spec :
	/* empty */
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

insert_list :
	/* empty */
	| expr
	| expr ',' insert_list
	;

basic_update_stmt :
	UPDATE opt_name SET update_list opt_where
	;

with_update_stmt :
	with_prefix update_stmt
	;

update_stmt :
	UPDATE name SET update_list opt_where opt_orderby opt_limit
	;

update_entry :
	name '=' expr
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
	/* empty */
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
	| name '=' expr
	;

declare_func_stmt :
	DECLARE function name '(' params ')' data_type_with_options
	| DECLARE SELECT function name '(' params ')' data_type_with_options
	| DECLARE function name '(' params ')' CREATE data_type_with_options
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
	| DECLARE procedure name '(' params ')' OUT UNION '(' typed_names ')'
	| DECLARE procedure name '(' params ')' OUT UNION '(' typed_names ')' USING TRANSACTION
	;

create_proc_stmt :
	CREATE procedure name '(' params ')' BEGIN_ opt_stmt_list END
	;

inout :
	IN
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

param :
	name data_type_with_options
	| inout name data_type_with_options
	| shape_def
	| name shape_def
	;

params :
	/* empty */
	| param
	| param ',' params
	;

declare_stmt :
	DECLARE name_list data_type_with_options
	| DECLARE name CURSOR FOR select_stmt
	| DECLARE name CURSOR FOR explain_stmt
	| DECLARE name CURSOR FOR call_stmt
	| DECLARE name CURSOR FETCH FROM call_stmt
	| DECLARE name CURSOR shape_def
	| DECLARE name CURSOR LIKE select_stmt
	| DECLARE name CURSOR FOR name
	| DECLARE name TYPE data_type_with_options
	;

call_stmt :
	CALL name '(' ')'
	| CALL name '(' call_expr_list ')'
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

open_stmt :
	OPEN name
	;

close_stmt :
	CLOSE name
	;

out_stmt :
	OUT name
	;

out_union_stmt :
	OUT UNION name
	;

if_stmt :
	IF expr THEN opt_stmt_list opt_elseif_list opt_else END IF
	;

opt_else :
	/* empty */
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
	/* empty */
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
	/* empty */
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
	/* empty */
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
	/* empty */
	| OF name_list
	;

trigger_action :
	opt_foreachrow opt_when_expr BEGIN_ trigger_stmts END
	;

opt_foreachrow :
	/* empty */
	| FOR_EACH_ROW
	;

opt_when_expr :
	/* empty */
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
	| IS_TRUE
	| CAST
	| NULL_ CHECK ON NOT NULL_
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

//Regex macros
%%

%option caseless

spaces	[ \t\r\n]+
line_comment	--[^\r\n]*
block_comment	\/\*(?s:.)*?\*\/

%%

{spaces}	skip()
{line_comment}	skip()
{block_comment}	skip()

UNBOUNDED	UNBOUNDED
EXPLAIN	EXPLAIN
QUERY[[:space:]]+PLAN	QUERY_PLAN
@PREVIOUS_SCHEMA	AT_PREVIOUS_SCHEMA
@SCHEMA_UPGRADE_SCRIPT	AT_SCHEMA_UPGRADE_SCRIPT
@SCHEMA_UPGRADE_VERSION	AT_SCHEMA_UPGRADE_VERSION
SET	SET
FROM	FROM
CURSOR	CURSOR
LET	LET
@RECREATE	AT_RECREATE
@CREATE	AT_CREATE
@DELETE	AT_DELETE
DROP	DROP
TABLE	TABLE
IF	IF
EXISTS	EXISTS
VIEW	VIEW
INDEX	INDEX
TRIGGER	TRIGGER
CREATE	CREATE
VIRTUAL	VIRTUAL
USING	USING
AS	AS
ARGUMENTS	ARGUMENTS
FOLLOWING	FOLLOWING
TEMP	TEMP
WITHOUT	WITHOUT
ROWID	ROWID
CONSTRAINT	CONSTRAINT
CHECK	CHECK
@ATTRIBUTE	AT_ATTRIBUTE
PRIMARY	PRIMARY
KEY	KEY
ON[[:space:]]+CONFLICT	ON_CONFLICT
ROLLBACK	ROLLBACK
ABORT	ABORT
FAIL	FAIL
IGNORE	IGNORE
REPLACE	REPLACE
ON	ON
DELETE	DELETE
UPDATE	UPDATE
NULL	NULL_
DEFAULT	DEFAULT
CASCADE	CASCADE
RESTRICT	RESTRICT
NO	NO
ACTION	ACTION
DEFERRABLE	DEFERRABLE
NOT[[:space:]]+DEFERRABLE	NOT_DEFERRABLE
INITIALLY	INITIALLY
DEFERRED	DEFERRED
IMMEDIATE	IMMEDIATE
FOREIGN	FOREIGN
REFERENCES	REFERENCES
UNIQUE	UNIQUE
TEXT	TEXT
TYPE	TYPE
HIDDEN	HIDDEN
PRIVATE	PRIVATE
AUTOINCREMENT	AUTOINCREMENT
@SENSITIVE	AT_SENSITIVE
INT	INT_
INTEGER	INTEGER
REAL	REAL
LONG	LONG_
BOOL	BOOL_
LONG[[:space:]]+INT	LONG_INT
LONG[[:space:]]+INTEGER	LONG_INTEGER
BLOB	BLOB
OBJECT	OBJECT
TRUE_	TRUE_
FALSE	FALSE_
CONST	CONST
@FILE	AT_FILE
@PROC	AT_PROC
RAISE	RAISE
DISTINCT	DISTINCT
@RC	AT_RC
NOTHING	NOTHING
THROW	THROW
CASE	CASE
END	END
ELSE	ELSE
CAST	CAST
WHEN	WHEN
THEN	THEN
WITH	WITH
RECURSIVE	RECURSIVE
SELECT	SELECT
VALUES	VALUES
OVER	OVER
FILTER	FILTER
RANGE	RANGE
ROWS	ROWS
GROUPS	GROUPS
EXCLUDE[[:space:]]+NO[[:space:]]+OTHERS	EXCLUDE_NO_OTHERS
EXCLUDE[[:space:]]+CURRENT[[:space:]]+ROW	EXCLUDE_CURRENT_ROW
EXCLUDE[[:space:]]+GROUP	EXCLUDE_GROUP
EXCLUDE[[:space:]]+TIES	EXCLUDE_TIES
PRECEDING	PRECEDING
CURRENT[[:space:]]+ROW	CURRENT_ROW
PARTITION	PARTITION
BY	BY
WINDOW	WINDOW
@DECLARE_SCHEMA_REGION	AT_DECLARE_SCHEMA_REGION
@DECLARE_DEPLOYABLE_REGION	AT_DECLARE_DEPLOYABLE_REGION
@BEGIN_SCHEMA_REGION	AT_BEGIN_SCHEMA_REGION
@END_SCHEMA_REGION	AT_END_SCHEMA_REGION
@SCHEMA_AD_HOC_MIGRATION	AT_SCHEMA_AD_HOC_MIGRATION
FOR	FOR
@EMIT_CONSTANTS	AT_EMIT_CONSTANTS
@EMIT_ENUMS	AT_EMIT_ENUMS
@EMIT_GROUP	AT_EMIT_GROUP
WHERE	WHERE
GROUP	GROUP
ASC	ASC
DESC	DESC
HAVING	HAVING
ORDER	ORDER
LIMIT	LIMIT
OFFSET	OFFSET
ALL	ALL
DISTINCTROW	DISTINCTROW
LEFT	LEFT
RIGHT	RIGHT
OUTER	OUTER
INNER	INNER
CROSS	CROSS
JOIN	JOIN
@DUMMY_SEED	AT_DUMMY_SEED
@DUMMY_NULLABLES	AT_DUMMY_NULLABLES
@DUMMY_DEFAULTS	AT_DUMMY_DEFAULTS
INSERT	INSERT
INTO	INTO
DO	DO
FUNC	FUNC
FUNCTION	FUNCTION
DECLARE	DECLARE
OUT	OUT
ENUM	ENUM
PROC	PROC
PROCEDURE	PROCEDURE
TRANSACTION	TRANSACTION
BEGIN	BEGIN_
INOUT	INOUT
FETCH	FETCH
CALL	CALL
WHILE	WHILE
SWITCH	SWITCH
LOOP	LOOP
LEAVE	LEAVE
RETURN	RETURN
COMMIT	COMMIT
TRY	TRY
CATCH	CATCH
CONTINUE	CONTINUE
OPEN	OPEN
CLOSE	CLOSE
ELSE[[:space:]]+IF	ELSE_IF
EXCLUSIVE	EXCLUSIVE
TO	TO
SAVEPOINT	SAVEPOINT
RELEASE	RELEASE
@ECHO	AT_ECHO
ALTER	ALTER
ADD	ADD
COLUMN	COLUMN
BEFORE	BEFORE
AFTER	AFTER
INSTEAD	INSTEAD
OF	OF
FOR[[:space:]]+EACH[[:space:]]+ROW	FOR_EACH_ROW
UPSERT	UPSERT
STATEMENT	STATEMENT
ENCODE	ENCODE
CONTEXT[[:space:]]+COLUMN	CONTEXT_COLUMN
CONTEXT[[:space:]]+TYPE	CONTEXT_TYPE
@ENFORCE_STRICT	AT_ENFORCE_STRICT
@ENFORCE_NORMAL	AT_ENFORCE_NORMAL
@ENFORCE_RESET	AT_ENFORCE_RESET
@ENFORCE_PUSH	AT_ENFORCE_PUSH
@ENFORCE_POP	AT_ENFORCE_POP
UNION[[:space:]]+ALL	UNION_ALL
UNION	UNION
INTERSECT	INTERSECT
EXCEPT	EXCEPT
OR	OR
AND	AND
NOT	NOT
NOT[[:space:]]+BETWEEN	NOT_BETWEEN
BETWEEN	BETWEEN
LIKE	LIKE
NOT[[:space:]]+LIKE	NOT_LIKE
GLOB	GLOB
NOT[[:space:]]+GLOB	NOT_GLOB
MATCH	MATCH
NOT[[:space:]]+MATCH	NOT_MATCH
REGEXP	REGEXP
NOT[[:space:]]+REGEXP	NOT_REGEXP
IN	IN
NOT[[:space:]]+IN	NOT_IN
IS[[:space:]]+NOT	IS_NOT
IS[[:space:]]+TRUE	IS_TRUE
IS[[:space:]]+FALSE	IS_FALSE
IS[[:space:]]+NOT[[:space:]]+TRUE	IS_NOT_TRUE
IS[[:space:]]+NOT[[:space:]]+FALSE	IS_NOT_FALSE
IS	IS
ISNULL	ISNULL
NOTNULL	NOTNULL
COLLATE	COLLATE

:=	ASSIGN
\|\|	CONCAT
==	EQEQ
>=	GE
<=	LE
<<	LS
<>	NE
!=	NE_
>>	RS
=	'='
<	'<'
>	'>'
&	'&'
\|	'|'
\+	'+'
-	'-'
\*	'*'
\/	'/'
%	'%'
~	'~'
;	';'
\(	'('
\)	')'
,	','
:	':'
\.	'.'

'(''|[^'\n])*'	STRLIT
\"(\\.|[^\"\n\r\\])*\"	CSTRLIT

([0-9]+\.[0-9]*|\.[0-9]+)([Ee](\+|\-)?[0-9]+)?	REALLIT
[0-9]+	INTLIT
[0-9]+L	LONGLIT
X'([0-9a-fA-F][0-9a-fA-F])*'	BLOBLIT
/* Order matter if identifier comes before keywords they are classified as identifier */
[_a-zA-Z][a-zA-Z0-9_]*	ID

%%
