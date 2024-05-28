//From commit: https://github.com/duckdb/duckdb/commit/7400e11a5ecec3f5e3ab775691f5fb6e4cb3b281
/*-------------------------------------------------------------------------
 *
 * gram.y
 *	  POSTGRESQL BISON rules/actions
 *
 * Portions Copyright (c) 1996-2017, PostgreSQL Global Development PGGroup
 * Portions Copyright (c) 1994, Regents of the University of California
 *
 *
 * IDENTIFICATION
 *	  src/backend/parser/gram.y
 *
 * HISTORY
 *	  AUTHOR			DATE			MAJOR EVENT
 *	  Andrew Yu			Sept, 1994		POSTQUEL to SQL conversion
 *	  Andrew Yu			Oct, 1994		lispy code conversion
 *
 * NOTES
 *	  CAPITALS are used to represent terminal symbols.
 *	  non-capitals are used to represent non-terminals.
 *
 *	  In general, nothing in this file should initiate database accesses
 *	  nor depend on changeable state (such as SET variables).  If you do
 *	  database accesses, your code will fail when we have aborted the
 *	  current transaction and are just parsing commands to find the next
 *	  ROLLBACK or COMMIT.  If you make use of SET variables, then you
 *	  will do the wrong thing in multi-query strings like this:
 *			SET constraint_exclusion TO off; SELECT * FROM foo;
 *	  because the entire string is parsed by gram.y before the SET gets
 *	  executed.  Anything that depends on the database or changeable state
 *	  should be handled during parse analysis so that it happens at the
 *	  right time not the wrong time.
 *
 * WARNINGS
 *	  If you use a list, make sure the datum is a node so that the printing
 *	  routines work.
 *
 *	  Sometimes we assign constants to makeStrings. Make sure we don't free
 *	  those.
 *
 *-------------------------------------------------------------------------
 */

/*Tokens*/
%token IDENT
%token FCONST
%token SCONST
%token BCONST
%token XCONST
%token Op
%token ICONST
%token PARAM
%token TYPECAST
//%token DOT_DOT
%token COLON_EQUALS
%token EQUALS_GREATER
%token INTEGER_DIVISION
%token POWER_OF
%token LAMBDA_ARROW
%token DOUBLE_ARROW
%token LESS_EQUALS
%token GREATER_EQUALS
%token NOT_EQUALS
%token ABORT_P
%token ABSOLUTE_P
%token ACCESS
%token ACTION
%token ADD_P
%token ADMIN
%token AFTER
%token AGGREGATE
%token ALL
%token ALSO
%token ALTER
%token ALWAYS
%token ANALYSE
%token ANALYZE
%token AND
%token ANTI
%token ANY
%token ARRAY
%token AS
%token ASC_P
%token ASOF
%token ASSERTION
%token ASSIGNMENT
%token ASYMMETRIC
%token AT
%token ATTACH
%token ATTRIBUTE
%token AUTHORIZATION
%token BACKWARD
%token BEFORE
%token BEGIN_P
%token BETWEEN
%token BIGINT
%token BINARY
%token BIT
%token BOOLEAN_P
%token BOTH
%token BY
%token CACHE
%token CALL_P
%token CALLED
%token CASCADE
%token CASCADED
%token CASE
%token CAST
%token CATALOG_P
%token CHAIN
%token CHAR_P
%token CHARACTER
%token CHARACTERISTICS
%token CHECK_P
%token CHECKPOINT
%token CLASS
%token CLOSE
%token CLUSTER
%token COALESCE
%token COLLATE
%token COLLATION
%token COLUMN
%token COLUMNS
%token COMMENT
%token COMMENTS
%token COMMIT
%token COMMITTED
%token COMPRESSION
%token CONCURRENTLY
%token CONFIGURATION
%token CONFLICT
%token CONNECTION
%token CONSTRAINT
%token CONSTRAINTS
%token CONTENT_P
%token CONTINUE_P
%token CONVERSION_P
%token COPY
%token COST
%token CREATE_P
%token CROSS
%token CSV
%token CUBE
%token CURRENT_P
%token CURSOR
%token CYCLE
%token DATA_P
%token DATABASE
%token DAY_P
%token DAYS_P
%token DEALLOCATE
%token DEC
%token DECIMAL_P
%token DECLARE
%token DEFAULT
%token DEFAULTS
%token DEFERRABLE
%token DEFERRED
%token DEFINER
%token DELETE_P
%token DELIMITER
%token DELIMITERS
%token DEPENDS
%token DESC_P
%token DESCRIBE
%token DETACH
%token DICTIONARY
%token DISABLE_P
%token DISCARD
%token DISTINCT
%token DO
%token DOCUMENT_P
%token DOMAIN_P
%token DOUBLE_P
%token DROP
%token EACH
%token ELSE
%token ENABLE_P
%token ENCODING
%token ENCRYPTED
%token END_P
%token ENUM_P
%token ESCAPE
%token EVENT
%token EXCEPT
%token EXCLUDE
%token EXCLUDING
%token EXCLUSIVE
%token EXECUTE
%token EXISTS
%token EXPLAIN
%token EXPORT_P
%token EXPORT_STATE
%token EXTENSION
%token EXTERNAL
%token EXTRACT
%token FALSE_P
%token FAMILY
%token FETCH
%token FILTER
%token FIRST_P
%token FLOAT_P
%token FOLLOWING
%token FOR
%token FORCE
%token FOREIGN
%token FORWARD
%token FREEZE
%token FROM
%token FULL
%token FUNCTION
%token FUNCTIONS
%token GENERATED
%token GLOB
%token GLOBAL
%token GRANT
%token GRANTED
%token GROUP_P
%token GROUPING
%token GROUPING_ID
%token HANDLER
%token HAVING
%token HEADER_P
%token HOLD
%token HOUR_P
%token HOURS_P
%token IDENTITY_P
%token IF_P
%token IGNORE_P
%token ILIKE
%token IMMEDIATE
%token IMMUTABLE
%token IMPLICIT_P
%token IMPORT_P
%token IN_P
%token INCLUDE_P
%token INCLUDING
%token INCREMENT
%token INDEX
%token INDEXES
%token INHERIT
%token INHERITS
%token INITIALLY
%token INLINE_P
%token INNER_P
%token INOUT
%token INPUT_P
%token INSENSITIVE
%token INSERT
%token INSTALL
%token INSTEAD
%token INT_P
%token INTEGER
%token INTERSECT
%token INTERVAL
%token INTO
%token INVOKER
%token IS
%token ISNULL
%token ISOLATION
%token JOIN
%token JSON
%token KEY
%token LABEL
%token LANGUAGE
%token LARGE_P
%token LAST_P
%token LATERAL_P
%token LEADING
%token LEAKPROOF
%token LEFT
%token LEVEL
%token LIKE
%token LIMIT
%token LISTEN
%token LOAD
%token LOCAL
%token LOCATION
%token LOCK_P
%token LOCKED
%token LOGGED
%token MACRO
%token MAP
%token MAPPING
%token MATCH
%token MATERIALIZED
%token MAXVALUE
%token METHOD
%token MICROSECOND_P
%token MICROSECONDS_P
%token MILLISECOND_P
%token MILLISECONDS_P
%token MINUTE_P
%token MINUTES_P
%token MINVALUE
%token MODE
%token MONTH_P
%token MONTHS_P
%token MOVE
%token NAME_P
%token NAMES
%token NATIONAL
%token NATURAL
%token NCHAR
%token NEW
%token NEXT
%token NO
%token NONE
%token NOT
%token NOTHING
%token NOTIFY
%token NOTNULL
%token NOWAIT
%token NULL_P
%token NULLIF
%token NULLS_P
%token NUMERIC
%token OBJECT_P
%token OF
%token OFF
%token OFFSET
%token OIDS
%token OLD
%token ON
%token ONLY
%token OPERATOR
%token OPTION
%token OPTIONS
%token OR
%token ORDER
%token ORDINALITY
%token OUT_P
%token OUTER_P
%token OVER
%token OVERLAPS
%token OVERLAY
%token OVERRIDING
%token OWNED
%token OWNER
%token PARALLEL
%token PARSER
%token PARTIAL
%token PARTITION
%token PASSING
%token PASSWORD
%token PERCENT
%token PIVOT
%token PIVOT_LONGER
%token PIVOT_WIDER
%token PLACING
%token PLANS
%token POLICY
%token POSITION
%token POSITIONAL
%token PRAGMA_P
%token PRECEDING
%token PRECISION
%token PREPARE
%token PREPARED
%token PRESERVE
%token PRIMARY
%token PRIOR
%token PRIVILEGES
%token PROCEDURAL
%token PROCEDURE
%token PROGRAM
%token PUBLICATION
%token QUALIFY
%token QUOTE
%token RANGE
%token READ_P
%token REAL
%token REASSIGN
%token RECHECK
%token RECURSIVE
%token REF
%token REFERENCES
%token REFERENCING
%token REFRESH
%token REINDEX
%token RELATIVE_P
%token RELEASE
%token RENAME
%token REPEATABLE
%token REPLACE
%token REPLICA
%token RESET
%token RESPECT_P
%token RESTART
%token RESTRICT
%token RETURNING
%token RETURNS
%token REVOKE
%token RIGHT
%token ROLE
%token ROLLBACK
%token ROLLUP
%token ROW
%token ROWS
%token RULE
%token SAMPLE
%token SAVEPOINT
%token SCHEMA
%token SCHEMAS
%token SCROLL
%token SEARCH
%token SECOND_P
%token SECONDS_P
%token SECURITY
%token SELECT
%token SEMI
%token SEQUENCE
%token SEQUENCES
%token SERIALIZABLE
%token SERVER
%token SESSION
%token SET
%token SETOF
%token SETS
%token SHARE
%token SHOW
%token SIMILAR
%token SIMPLE
%token SKIP
%token SMALLINT
%token SNAPSHOT
%token SOME
%token SQL_P
%token STABLE
%token STANDALONE_P
%token START
%token STATEMENT
%token STATISTICS
%token STDIN
%token STDOUT
%token STORAGE
%token STORED
%token STRICT_P
%token STRIP_P
%token STRUCT
%token SUBSCRIPTION
%token SUBSTRING
%token SUMMARIZE
%token SYMMETRIC
%token SYSID
%token SYSTEM_P
%token TABLE
%token TABLES
%token TABLESAMPLE
%token TABLESPACE
%token TEMP
%token TEMPLATE
%token TEMPORARY
%token TEXT_P
%token THEN
%token TIME
%token TIMESTAMP
%token TO
%token TRAILING
%token TRANSACTION
%token TRANSFORM
%token TREAT
%token TRIGGER
%token TRIM
%token TRUE_P
%token TRUNCATE
%token TRUSTED
%token TRY_CAST
%token TYPE_P
%token TYPES_P
%token UNBOUNDED
%token UNCOMMITTED
%token UNENCRYPTED
%token UNION
%token UNIQUE
%token UNKNOWN
%token UNLISTEN
%token UNLOGGED
%token UNPIVOT
%token UNTIL
%token UPDATE
%token USE_P
%token USER
%token USING
%token VACUUM
%token VALID
%token VALIDATE
%token VALIDATOR
%token VALUE_P
%token VALUES
%token VARCHAR
%token VARIADIC
%token VARYING
%token VERBOSE
%token VERSION_P
%token VIEW
%token VIEWS
%token VIRTUAL
%token VOLATILE
%token WHEN
%token WHERE
%token WHITESPACE_P
%token WINDOW
%token WITH
%token WITHIN
%token WITHOUT
%token WORK
%token WRAPPER
%token WRITE_P
%token XML_P
%token XMLATTRIBUTES
%token XMLCONCAT
%token XMLELEMENT
%token XMLEXISTS
%token XMLFOREST
%token XMLNAMESPACES
%token XMLPARSE
%token XMLPI
%token XMLROOT
%token XMLSERIALIZE
%token XMLTABLE
%token YEAR_P
%token YEARS_P
%token YES_P
%token ZONE
%token NOT_LA
%token NULLS_LA
%token WITH_LA
%token '<'
%token '>'
%token '='
%token '+'
%token '-'
%token '*'
%token '/'
%token '%'
%token '^'
%token '['
%token ']'
%token '('
%token ')'
%token '.'
%token ';'
%token ','
%token '#'
%token '$'
%token '?'
%token '{'
%token '}'
%token ':'

%nonassoc /*1*/ SET
%left /*2*/ EXCEPT UNION
%left /*3*/ INTERSECT
%left /*4*/ LAMBDA_ARROW DOUBLE_ARROW
%left /*5*/ OR
%left /*6*/ AND
%right /*7*/ NOT
%nonassoc /*8*/ IS ISNULL NOTNULL
%nonassoc /*9*/ LESS_EQUALS GREATER_EQUALS NOT_EQUALS '<' '>' '='
%nonassoc /*10*/ BETWEEN GLOB ILIKE IN_P LIKE SIMILAR NOT_LA
%nonassoc /*11*/ ESCAPE
%left /*12*/ POSTFIXOP
%nonassoc /*13*/ UNBOUNDED
%nonassoc /*14*/ IDENT CUBE ENUM_P FOLLOWING GENERATED NULL_P PARTITION PRECEDING RANGE ROLLUP ROWS
%left /*15*/ Op OPERATOR
%left /*16*/ '+' '-'
%left /*17*/ INTEGER_DIVISION '*' '/' '%'
%left /*18*/ POWER_OF '^'
%left /*19*/ AT
%left /*20*/ COLLATE
%right /*21*/ UMINUS
%left /*22*/ '[' ']'
%left /*23*/ '(' ')'
%left /*24*/ TYPECAST
%left /*25*/ '.'
%left /*26*/ ANTI ASOF CROSS FULL INNER_P JOIN LEFT NATURAL PIVOT POSITIONAL RIGHT SEMI UNPIVOT
%right /*27*/ IGNORE_P PRESERVE RESPECT_P STRIP_P

%start stmtblock

%%

stmtblock :
	stmtmulti
	;

stmtmulti :
	stmtmulti ';' stmt
	| stmt
	;

stmt :
	AlterObjectSchemaStmt
	| AlterSeqStmt
	| AlterTableStmt
	| AnalyzeStmt
	| AttachStmt
	| CallStmt
	| CheckPointStmt
	| CopyStmt
	| CreateAsStmt
	| CreateFunctionStmt
	| CreateSchemaStmt
	| CreateSeqStmt
	| CreateStmt
	| CreateTypeStmt
	| DeallocateStmt
	| DeleteStmt
	| DetachStmt
	| DropStmt
	| ExecuteStmt
	| ExplainStmt
	| ExportStmt
	| ImportStmt
	| IndexStmt
	| InsertStmt
	| LoadStmt
	| PragmaStmt
	| PrepareStmt
	| RenameStmt
	| SelectStmt
	| TransactionStmt
	| UpdateStmt
	| UseStmt
	| VacuumStmt
	| VariableResetStmt
	| VariableSetStmt
	| VariableShowStmt
	| ViewStmt
	| /*empty*/
	;

AlterTableStmt :
	ALTER TABLE relation_expr alter_table_cmds
	| ALTER TABLE IF_P EXISTS relation_expr alter_table_cmds
	| ALTER INDEX qualified_name alter_table_cmds
	| ALTER INDEX IF_P EXISTS qualified_name alter_table_cmds
	| ALTER SEQUENCE qualified_name alter_table_cmds
	| ALTER SEQUENCE IF_P EXISTS qualified_name alter_table_cmds
	| ALTER VIEW qualified_name alter_table_cmds
	| ALTER VIEW IF_P EXISTS qualified_name alter_table_cmds
	;

alter_identity_column_option_list :
	alter_identity_column_option
	| alter_identity_column_option_list alter_identity_column_option
	;

alter_column_default :
	SET /*1N*/ DEFAULT a_expr
	| DROP DEFAULT
	;

alter_identity_column_option :
	RESTART
	| RESTART opt_with NumericOnly
	| SET /*1N*/ SeqOptElem
	| SET /*1N*/ GENERATED /*14N*/ generated_when
	;

alter_generic_option_list :
	alter_generic_option_elem
	| alter_generic_option_list ',' alter_generic_option_elem
	;

alter_table_cmd :
	ADD_P columnDef
	| ADD_P IF_P NOT /*7R*/ EXISTS columnDef
	| ADD_P COLUMN columnDef
	| ADD_P COLUMN IF_P NOT /*7R*/ EXISTS columnDef
	| ALTER opt_column ColId alter_column_default
	| ALTER opt_column ColId DROP NOT /*7R*/ NULL_P /*14N*/
	| ALTER opt_column ColId SET /*1N*/ NOT /*7R*/ NULL_P /*14N*/
	| ALTER opt_column ColId SET /*1N*/ STATISTICS SignedIconst
	| ALTER opt_column ColId SET /*1N*/ reloptions
	| ALTER opt_column ColId RESET reloptions
	| ALTER opt_column ColId SET /*1N*/ STORAGE ColId
	| ALTER opt_column ColId ADD_P GENERATED /*14N*/ generated_when AS IDENTITY_P OptParenthesizedSeqOptList
	| ALTER opt_column ColId alter_identity_column_option_list
	| ALTER opt_column ColId DROP IDENTITY_P
	| ALTER opt_column ColId DROP IDENTITY_P IF_P EXISTS
	| DROP opt_column IF_P EXISTS ColId opt_drop_behavior
	| DROP opt_column ColId opt_drop_behavior
	| ALTER opt_column ColId opt_set_data TYPE_P Typename opt_collate_clause alter_using
	| ALTER opt_column ColId alter_generic_options
	| ADD_P TableConstraint
	| ALTER CONSTRAINT name ConstraintAttributeSpec
	| VALIDATE CONSTRAINT name
	| DROP CONSTRAINT IF_P EXISTS name opt_drop_behavior
	| DROP CONSTRAINT name opt_drop_behavior
	| SET /*1N*/ LOGGED
	| SET /*1N*/ UNLOGGED
	| SET /*1N*/ reloptions
	| RESET reloptions
	| alter_generic_options
	;

alter_using :
	USING a_expr
	| /*empty*/
	;

alter_generic_option_elem :
	generic_option_elem
	| SET /*1N*/ generic_option_elem
	| ADD_P generic_option_elem
	| DROP generic_option_name
	;

alter_table_cmds :
	alter_table_cmd
	| alter_table_cmds ',' alter_table_cmd
	;

alter_generic_options :
	OPTIONS '(' /*23L*/ alter_generic_option_list ')' /*23L*/
	;

opt_set_data :
	SET /*1N*/ DATA_P
	| SET /*1N*/
	| /*empty*/
	;

qualified_name :
	ColIdOrString
	| ColId indirection
	;

ColId :
	IDENT /*14N*/
	| unreserved_keyword
	| col_name_keyword
	;

ColIdOrString :
	ColId
	| SCONST
	;

Sconst :
	SCONST
	;

indirection :
	indirection_el
	| indirection indirection_el
	;

indirection_el :
	'.' /*25L*/ attr_name
	;

attr_name :
	ColLabel
	;

ColLabel :
	IDENT /*14N*/
	| other_keyword
	| unreserved_keyword
	| reserved_keyword
	;

LoadStmt :
	LOAD file_name
	| INSTALL file_name
	| FORCE INSTALL file_name
	| INSTALL file_name FROM repo_path
	| FORCE INSTALL file_name FROM repo_path
	;

file_name :
	Sconst
	| ColId
	;

repo_path :
	Sconst
	| ColId
	;

UpdateStmt :
	opt_with_clause UPDATE relation_expr_opt_alias SET /*1N*/ set_clause_list_opt_comma from_clause where_or_current_clause returning_clause
	;

AttachStmt :
	ATTACH opt_database Sconst opt_database_alias copy_options
	;

DetachStmt :
	DETACH opt_database IDENT /*14N*/
	| DETACH DATABASE IF_P EXISTS IDENT /*14N*/
	;

opt_database :
	DATABASE
	| /*empty*/
	;

opt_database_alias :
	AS ColId
	| /*empty*/
	;

///ident_name :
///	IDENT /*14N*/
///	;

///ident_list :
///	ident_name
///	| ident_list ',' ident_name
///	;

InsertStmt :
	opt_with_clause INSERT opt_or_action INTO insert_target opt_by_name_or_position insert_rest opt_on_conflict returning_clause
	;

insert_rest :
	SelectStmt
	| OVERRIDING override_kind VALUE_P SelectStmt
	| '(' /*23L*/ insert_column_list ')' /*23L*/ SelectStmt
	| '(' /*23L*/ insert_column_list ')' /*23L*/ OVERRIDING override_kind VALUE_P SelectStmt
	| DEFAULT VALUES
	;

insert_target :
	qualified_name
	| qualified_name AS ColId
	;

opt_by_name_or_position :
	BY NAME_P
	| BY POSITION
	| /*empty*/
	;

opt_conf_expr :
	'(' /*23L*/ index_params ')' /*23L*/ where_clause
	| ON CONSTRAINT name
	| /*empty*/
	;

opt_with_clause :
	with_clause
	| /*empty*/
	;

insert_column_item :
	ColId opt_indirection
	;

set_clause :
	set_target '=' /*9N*/ a_expr
	| '(' /*23L*/ set_target_list ')' /*23L*/ '=' /*9N*/ a_expr
	;

opt_or_action :
	OR /*5L*/ REPLACE
	| OR /*5L*/ IGNORE_P /*27R*/
	| /*empty*/
	;

opt_on_conflict :
	ON CONFLICT opt_conf_expr DO UPDATE SET /*1N*/ set_clause_list_opt_comma where_clause
	| ON CONFLICT opt_conf_expr DO NOTHING
	| /*empty*/
	;

index_elem :
	ColId opt_collate opt_class opt_asc_desc opt_nulls_order
	| func_expr_windowless opt_collate opt_class opt_asc_desc opt_nulls_order
	| '(' /*23L*/ a_expr ')' /*23L*/ opt_collate opt_class opt_asc_desc opt_nulls_order
	;

returning_clause :
	RETURNING target_list
	| /*empty*/
	;

override_kind :
	USER
	| SYSTEM_P
	;

set_target_list :
	set_target
	| set_target_list ',' set_target
	;

opt_collate :
	COLLATE /*20L*/ any_name
	| /*empty*/
	;

opt_class :
	any_name
	| /*empty*/
	;

insert_column_list :
	insert_column_item
	| insert_column_list ',' insert_column_item
	;

set_clause_list :
	set_clause
	| set_clause_list ',' set_clause
	;

set_clause_list_opt_comma :
	set_clause_list
	| set_clause_list ','
	;

index_params :
	index_elem
	| index_params ',' index_elem
	;

set_target :
	ColId opt_indirection
	;

DropStmt :
	DROP drop_type_any_name IF_P EXISTS any_name_list opt_drop_behavior
	| DROP drop_type_any_name any_name_list opt_drop_behavior
	| DROP drop_type_name IF_P EXISTS name_list opt_drop_behavior
	| DROP drop_type_name name_list opt_drop_behavior
	| DROP drop_type_name_on_any_name name ON any_name opt_drop_behavior
	| DROP drop_type_name_on_any_name IF_P EXISTS name ON any_name opt_drop_behavior
	| DROP TYPE_P type_name_list opt_drop_behavior
	| DROP TYPE_P IF_P EXISTS type_name_list opt_drop_behavior
	;

drop_type_any_name :
	TABLE
	| SEQUENCE
	| FUNCTION
	| MACRO
	| MACRO TABLE
	| VIEW
	| MATERIALIZED VIEW
	| INDEX
	| FOREIGN TABLE
	| COLLATION
	| CONVERSION_P
	| SCHEMA
	| STATISTICS
	| TEXT_P SEARCH PARSER
	| TEXT_P SEARCH DICTIONARY
	| TEXT_P SEARCH TEMPLATE
	| TEXT_P SEARCH CONFIGURATION
	;

drop_type_name :
	ACCESS METHOD
	| EVENT TRIGGER
	| EXTENSION
	| FOREIGN DATA_P WRAPPER
	| PUBLICATION
	| SERVER
	;

any_name_list :
	any_name
	| any_name_list ',' any_name
	;

opt_drop_behavior :
	CASCADE
	| RESTRICT
	| /*empty*/
	;

drop_type_name_on_any_name :
	POLICY
	| RULE
	| TRIGGER
	;

type_name_list :
	Typename
	| type_name_list ',' Typename
	;

VariableShowStmt :
	show_or_describe SelectStmt
	| SUMMARIZE SelectStmt
	| SUMMARIZE table_id
	| show_or_describe table_id
	| show_or_describe TIME ZONE
	| show_or_describe TRANSACTION ISOLATION LEVEL
	| show_or_describe ALL opt_tables
	| show_or_describe
	;

show_or_describe :
	SHOW
	| DESCRIBE
	;

opt_tables :
	TABLES
	| /*empty*/
	;

var_name :
	ColId
	| var_name '.' /*25L*/ ColId
	;

table_id :
	ColId
	| table_id '.' /*25L*/ ColId
	;

ExecuteStmt :
	EXECUTE name execute_param_clause
	| CREATE_P OptTemp TABLE create_as_target AS EXECUTE name execute_param_clause opt_with_data
	| CREATE_P OptTemp TABLE IF_P NOT /*7R*/ EXISTS create_as_target AS EXECUTE name execute_param_clause opt_with_data
	;

execute_param_expr :
	a_expr
	| param_name COLON_EQUALS a_expr
	;

execute_param_list :
	execute_param_expr
	| execute_param_list ',' execute_param_expr
	;

execute_param_clause :
	'(' /*23L*/ execute_param_list ')' /*23L*/
	| /*empty*/
	;

SelectStmt :
	select_no_parens %prec UMINUS /*21R*/
	| select_with_parens %prec UMINUS /*21R*/
	;

select_with_parens :
	'(' /*23L*/ select_no_parens ')' /*23L*/
	| '(' /*23L*/ select_with_parens ')' /*23L*/
	;

select_no_parens :
	simple_select
	| select_clause sort_clause
	| select_clause opt_sort_clause for_locking_clause opt_select_limit
	| select_clause opt_sort_clause select_limit opt_for_locking_clause
	| with_clause select_clause
	| with_clause select_clause sort_clause
	| with_clause select_clause opt_sort_clause for_locking_clause opt_select_limit
	| with_clause select_clause opt_sort_clause select_limit opt_for_locking_clause
	;

select_clause :
	simple_select
	| select_with_parens
	;

opt_select :
	SELECT opt_all_clause opt_target_list_opt_comma
	| /*empty*/
	;

simple_select :
	SELECT opt_all_clause opt_target_list_opt_comma into_clause from_clause where_clause group_clause having_clause window_clause qualify_clause sample_clause
	| SELECT distinct_clause target_list_opt_comma into_clause from_clause where_clause group_clause having_clause window_clause qualify_clause sample_clause
	| FROM from_list opt_select into_clause where_clause group_clause having_clause window_clause qualify_clause sample_clause
	| FROM from_list SELECT distinct_clause target_list_opt_comma into_clause where_clause group_clause having_clause window_clause qualify_clause sample_clause
	| values_clause_opt_comma
	| TABLE relation_expr
	| select_clause UNION /*2L*/ all_or_distinct by_name select_clause
	| select_clause UNION /*2L*/ all_or_distinct select_clause
	| select_clause INTERSECT /*3L*/ all_or_distinct select_clause
	| select_clause EXCEPT /*2L*/ all_or_distinct select_clause
	| pivot_keyword table_ref USING target_list_opt_comma
	| pivot_keyword table_ref USING target_list_opt_comma GROUP_P BY name_list_opt_comma_opt_bracket
	| pivot_keyword table_ref GROUP_P BY name_list_opt_comma_opt_bracket
	| pivot_keyword table_ref ON pivot_column_list
	| pivot_keyword table_ref ON pivot_column_list GROUP_P BY name_list_opt_comma_opt_bracket
	| pivot_keyword table_ref ON pivot_column_list USING target_list_opt_comma
	| pivot_keyword table_ref ON pivot_column_list USING target_list_opt_comma GROUP_P BY name_list_opt_comma_opt_bracket
	| unpivot_keyword table_ref ON target_list_opt_comma INTO NAME_P name value_or_values name_list_opt_comma_opt_bracket
	| unpivot_keyword table_ref ON target_list_opt_comma
	;

value_or_values :
	VALUE_P
	| VALUES
	;

pivot_keyword :
	PIVOT /*26L*/
	| PIVOT_WIDER
	;

unpivot_keyword :
	UNPIVOT /*26L*/
	| PIVOT_LONGER
	;

pivot_column_entry :
	b_expr
	| b_expr IN_P /*10N*/ '(' /*23L*/ select_no_parens ')' /*23L*/
	| single_pivot_value
	;

pivot_column_list_internal :
	pivot_column_entry
	| pivot_column_list_internal ',' pivot_column_entry
	;

pivot_column_list :
	pivot_column_list_internal
	| pivot_column_list_internal ','
	;

with_clause :
	WITH cte_list
	| WITH_LA cte_list
	| WITH RECURSIVE cte_list
	;

cte_list :
	common_table_expr
	| cte_list ',' common_table_expr
	;

common_table_expr :
	name opt_name_list AS opt_materialized '(' /*23L*/ PreparableStmt ')' /*23L*/
	;

opt_materialized :
	MATERIALIZED
	| NOT /*7R*/ MATERIALIZED
	| /*empty*/
	;

into_clause :
	INTO OptTempTableName
	| /*empty*/
	;

OptTempTableName :
	TEMPORARY opt_table qualified_name
	| TEMP opt_table qualified_name
	| LOCAL TEMPORARY opt_table qualified_name
	| LOCAL TEMP opt_table qualified_name
	| GLOBAL TEMPORARY opt_table qualified_name
	| GLOBAL TEMP opt_table qualified_name
	| UNLOGGED opt_table qualified_name
	| TABLE qualified_name
	| qualified_name
	;

opt_table :
	TABLE
	| /*empty*/
	;

all_or_distinct :
	ALL
	| DISTINCT
	| /*empty*/
	;

by_name :
	BY NAME_P
	;

distinct_clause :
	DISTINCT
	| DISTINCT ON '(' /*23L*/ expr_list_opt_comma ')' /*23L*/
	;

opt_all_clause :
	ALL
	| /*empty*/
	;

opt_ignore_nulls :
	IGNORE_P /*27R*/ NULLS_P
	| RESPECT_P /*27R*/ NULLS_P
	| /*empty*/
	;

opt_sort_clause :
	sort_clause
	| /*empty*/
	;

sort_clause :
	ORDER BY sortby_list
	| ORDER BY ALL opt_asc_desc opt_nulls_order
	;

sortby_list :
	sortby
	| sortby_list ',' sortby
	;

sortby :
	a_expr USING qual_all_Op opt_nulls_order
	| a_expr opt_asc_desc opt_nulls_order
	;

opt_asc_desc :
	ASC_P
	| DESC_P
	| /*empty*/
	;

opt_nulls_order :
	NULLS_LA FIRST_P
	| NULLS_LA LAST_P
	| /*empty*/
	;

select_limit :
	limit_clause offset_clause
	| offset_clause limit_clause
	| limit_clause
	| offset_clause
	;

opt_select_limit :
	select_limit
	| /*empty*/
	;

limit_clause :
	LIMIT select_limit_value
	| LIMIT select_limit_value ',' select_offset_value
	| FETCH first_or_next select_fetch_first_value row_or_rows ONLY
	| FETCH first_or_next row_or_rows ONLY
	;

offset_clause :
	OFFSET select_offset_value
	| OFFSET select_fetch_first_value row_or_rows
	;

sample_count :
	FCONST '%' /*17L*/
	| ICONST '%' /*17L*/
	| FCONST PERCENT
	| ICONST PERCENT
	| ICONST
	| ICONST ROWS /*14N*/
	;

sample_clause :
	USING SAMPLE tablesample_entry
	| /*empty*/
	;

opt_sample_func :
	ColId
	| /*empty*/
	;

tablesample_entry :
	opt_sample_func '(' /*23L*/ sample_count ')' /*23L*/ opt_repeatable_clause
	| sample_count
	| sample_count '(' /*23L*/ ColId ')' /*23L*/
	| sample_count '(' /*23L*/ ColId ',' ICONST ')' /*23L*/
	;

tablesample_clause :
	TABLESAMPLE tablesample_entry
	;

opt_tablesample_clause :
	tablesample_clause
	| /*empty*/
	;

opt_repeatable_clause :
	REPEATABLE '(' /*23L*/ ICONST ')' /*23L*/
	| /*empty*/
	;

select_limit_value :
	a_expr
	| ALL
	| a_expr '%' /*17L*/
	| FCONST PERCENT
	| ICONST PERCENT
	;

select_offset_value :
	a_expr
	;

select_fetch_first_value :
	c_expr
	| '+' /*16L*/ I_or_F_const
	| '-' /*16L*/ I_or_F_const
	;

I_or_F_const :
	Iconst
	| FCONST
	;

row_or_rows :
	ROW
	| ROWS /*14N*/
	;

first_or_next :
	FIRST_P
	| NEXT
	;

group_clause :
	GROUP_P BY group_by_list_opt_comma
	| GROUP_P BY ALL
	| /*empty*/
	;

group_by_list :
	group_by_item
	| group_by_list ',' group_by_item
	;

group_by_list_opt_comma :
	group_by_list
	| group_by_list ','
	;

group_by_item :
	a_expr
	| empty_grouping_set
	| cube_clause
	| rollup_clause
	| grouping_sets_clause
	;

empty_grouping_set :
	'(' /*23L*/ ')' /*23L*/
	;

rollup_clause :
	ROLLUP /*14N*/ '(' /*23L*/ expr_list_opt_comma ')' /*23L*/
	;

cube_clause :
	CUBE /*14N*/ '(' /*23L*/ expr_list_opt_comma ')' /*23L*/
	;

grouping_sets_clause :
	GROUPING SETS '(' /*23L*/ group_by_list_opt_comma ')' /*23L*/
	;

grouping_or_grouping_id :
	GROUPING
	| GROUPING_ID
	;

having_clause :
	HAVING a_expr
	| /*empty*/
	;

qualify_clause :
	QUALIFY a_expr
	| /*empty*/
	;

for_locking_clause :
	for_locking_items
	| FOR READ_P ONLY
	;

opt_for_locking_clause :
	for_locking_clause
	| /*empty*/
	;

for_locking_items :
	for_locking_item
	| for_locking_items for_locking_item
	;

for_locking_item :
	for_locking_strength locked_rels_list opt_nowait_or_skip
	;

for_locking_strength :
	FOR UPDATE
	| FOR NO KEY UPDATE
	| FOR SHARE
	| FOR KEY SHARE
	;

locked_rels_list :
	OF qualified_name_list
	| /*empty*/
	;

opt_nowait_or_skip :
	NOWAIT
	| SKIP LOCKED
	| /*empty*/
	;

values_clause :
	VALUES '(' /*23L*/ expr_list_opt_comma ')' /*23L*/
	| values_clause ',' '(' /*23L*/ expr_list_opt_comma ')' /*23L*/
	;

values_clause_opt_comma :
	values_clause
	| values_clause ','
	;

from_clause :
	FROM from_list_opt_comma
	| /*empty*/
	;

from_list :
	table_ref
	| from_list ',' table_ref
	;

from_list_opt_comma :
	from_list
	| from_list ','
	;

table_ref :
	relation_expr opt_alias_clause opt_tablesample_clause
	| func_table func_alias_clause opt_tablesample_clause
	| values_clause_opt_comma alias_clause opt_tablesample_clause
	| LATERAL_P func_table func_alias_clause
	| select_with_parens opt_alias_clause opt_tablesample_clause
	| LATERAL_P select_with_parens opt_alias_clause
	| joined_table
	| '(' /*23L*/ joined_table ')' /*23L*/ alias_clause
	| table_ref PIVOT /*26L*/ '(' /*23L*/ target_list_opt_comma FOR pivot_value_list opt_pivot_group_by ')' /*23L*/ opt_alias_clause
	| table_ref UNPIVOT /*26L*/ opt_include_nulls '(' /*23L*/ unpivot_header FOR unpivot_value_list ')' /*23L*/ opt_alias_clause
	;

opt_pivot_group_by :
	GROUP_P BY name_list_opt_comma
	| /*empty*/
	;

opt_include_nulls :
	INCLUDE_P NULLS_P
	| EXCLUDE NULLS_P
	| /*empty*/
	;

single_pivot_value :
	b_expr IN_P /*10N*/ '(' /*23L*/ target_list_opt_comma ')' /*23L*/
	| b_expr IN_P /*10N*/ ColIdOrString
	;

pivot_header :
	d_expr
	| '(' /*23L*/ c_expr_list_opt_comma ')' /*23L*/
	;

pivot_value :
	pivot_header IN_P /*10N*/ '(' /*23L*/ target_list_opt_comma ')' /*23L*/
	| pivot_header IN_P /*10N*/ ColIdOrString
	;

pivot_value_list :
	pivot_value
	| pivot_value_list pivot_value
	;

unpivot_header :
	ColIdOrString
	| '(' /*23L*/ name_list_opt_comma ')' /*23L*/
	;

unpivot_value :
	unpivot_header IN_P /*10N*/ '(' /*23L*/ target_list_opt_comma ')' /*23L*/
	;

unpivot_value_list :
	unpivot_value
	| unpivot_value_list unpivot_value
	;

joined_table :
	'(' /*23L*/ joined_table ')' /*23L*/
	| table_ref CROSS /*26L*/ JOIN /*26L*/ table_ref
	| table_ref join_type JOIN /*26L*/ table_ref join_qual
	| table_ref JOIN /*26L*/ table_ref join_qual
	| table_ref NATURAL /*26L*/ join_type JOIN /*26L*/ table_ref
	| table_ref NATURAL /*26L*/ JOIN /*26L*/ table_ref
	| table_ref ASOF /*26L*/ join_type JOIN /*26L*/ table_ref join_qual
	| table_ref ASOF /*26L*/ JOIN /*26L*/ table_ref join_qual
	| table_ref POSITIONAL /*26L*/ JOIN /*26L*/ table_ref
	| table_ref ANTI /*26L*/ JOIN /*26L*/ table_ref join_qual
	| table_ref SEMI /*26L*/ JOIN /*26L*/ table_ref join_qual
	;

alias_clause :
	AS ColIdOrString '(' /*23L*/ name_list_opt_comma ')' /*23L*/
	| AS ColIdOrString
	| ColId '(' /*23L*/ name_list_opt_comma ')' /*23L*/
	| ColId
	;

opt_alias_clause :
	alias_clause
	| /*empty*/
	;

func_alias_clause :
	alias_clause
	| AS '(' /*23L*/ TableFuncElementList ')' /*23L*/
	| AS ColIdOrString '(' /*23L*/ TableFuncElementList ')' /*23L*/
	| ColId '(' /*23L*/ TableFuncElementList ')' /*23L*/
	| /*empty*/
	;

join_type :
	FULL /*26L*/ join_outer
	| LEFT /*26L*/ join_outer
	| RIGHT /*26L*/ join_outer
	| SEMI /*26L*/
	| ANTI /*26L*/
	| INNER_P /*26L*/
	;

join_outer :
	OUTER_P
	| /*empty*/
	;

join_qual :
	USING '(' /*23L*/ name_list_opt_comma ')' /*23L*/
	| ON a_expr
	;

relation_expr :
	qualified_name
	| qualified_name '*' /*17L*/
	| ONLY qualified_name
	| ONLY '(' /*23L*/ qualified_name ')' /*23L*/
	;

func_table :
	func_expr_windowless opt_ordinality
	| ROWS /*14N*/ FROM '(' /*23L*/ rowsfrom_list ')' /*23L*/ opt_ordinality
	;

rowsfrom_item :
	func_expr_windowless opt_col_def_list
	;

rowsfrom_list :
	rowsfrom_item
	| rowsfrom_list ',' rowsfrom_item
	;

opt_col_def_list :
	AS '(' /*23L*/ TableFuncElementList ')' /*23L*/
	| /*empty*/
	;

opt_ordinality :
	WITH_LA ORDINALITY
	| /*empty*/
	;

where_clause :
	WHERE a_expr
	| /*empty*/
	;

TableFuncElementList :
	TableFuncElement
	| TableFuncElementList ',' TableFuncElement
	;

TableFuncElement :
	ColIdOrString Typename opt_collate_clause
	;

opt_collate_clause :
	COLLATE /*20L*/ any_name
	| /*empty*/
	;

colid_type_list :
	ColId Typename
	| colid_type_list ',' ColId Typename
	;

RowOrStruct :
	ROW
	| STRUCT
	;

opt_Typename :
	Typename
	| /*empty*/
	;

Typename :
	SimpleTypename opt_array_bounds
	| SETOF SimpleTypename opt_array_bounds
	| SimpleTypename ARRAY '[' /*22L*/ Iconst ']' /*22L*/
	| SETOF SimpleTypename ARRAY '[' /*22L*/ Iconst ']' /*22L*/
	| SimpleTypename ARRAY
	| SETOF SimpleTypename ARRAY
	| RowOrStruct '(' /*23L*/ colid_type_list ')' /*23L*/ opt_array_bounds
	| MAP '(' /*23L*/ type_list ')' /*23L*/ opt_array_bounds
	| UNION /*2L*/ '(' /*23L*/ colid_type_list ')' /*23L*/ opt_array_bounds
	;

opt_array_bounds :
	opt_array_bounds '[' /*22L*/ ']' /*22L*/
	| opt_array_bounds '[' /*22L*/ Iconst ']' /*22L*/
	| /*empty*/
	;

SimpleTypename :
	GenericType
	| Numeric
	| Bit
	| Character
	| ConstDatetime
	| ConstInterval opt_interval
	| ConstInterval '(' /*23L*/ Iconst ')' /*23L*/
	;

ConstTypename :
	Numeric
	| ConstBit
	| ConstCharacter
	| ConstDatetime
	;

GenericType :
	type_name_token opt_type_modifiers
	;

opt_type_modifiers :
	'(' /*23L*/ opt_expr_list_opt_comma ')' /*23L*/
	| /*empty*/
	;

Numeric :
	INT_P
	| INTEGER
	| SMALLINT
	| BIGINT
	| REAL
	| FLOAT_P opt_float
	| DOUBLE_P PRECISION
	| DECIMAL_P opt_type_modifiers
	| DEC opt_type_modifiers
	| NUMERIC opt_type_modifiers
	| BOOLEAN_P
	;

opt_float :
	'(' /*23L*/ Iconst ')' /*23L*/
	| /*empty*/
	;

Bit :
	BitWithLength
	| BitWithoutLength
	;

ConstBit :
	BitWithLength
	| BitWithoutLength
	;

BitWithLength :
	BIT opt_varying '(' /*23L*/ expr_list_opt_comma ')' /*23L*/
	;

BitWithoutLength :
	BIT opt_varying
	;

Character :
	CharacterWithLength
	| CharacterWithoutLength
	;

ConstCharacter :
	CharacterWithLength
	| CharacterWithoutLength
	;

CharacterWithLength :
	character '(' /*23L*/ Iconst ')' /*23L*/
	;

CharacterWithoutLength :
	character
	;

character :
	CHARACTER opt_varying
	| CHAR_P opt_varying
	| VARCHAR
	| NATIONAL CHARACTER opt_varying
	| NATIONAL CHAR_P opt_varying
	| NCHAR opt_varying
	;

opt_varying :
	VARYING
	| /*empty*/
	;

ConstDatetime :
	TIMESTAMP '(' /*23L*/ Iconst ')' /*23L*/ opt_timezone
	| TIMESTAMP opt_timezone
	| TIME '(' /*23L*/ Iconst ')' /*23L*/ opt_timezone
	| TIME opt_timezone
	;

ConstInterval :
	INTERVAL
	;

opt_timezone :
	WITH_LA TIME ZONE
	| WITHOUT TIME ZONE
	| /*empty*/
	;

year_keyword :
	YEAR_P
	| YEARS_P
	;

month_keyword :
	MONTH_P
	| MONTHS_P
	;

day_keyword :
	DAY_P
	| DAYS_P
	;

hour_keyword :
	HOUR_P
	| HOURS_P
	;

minute_keyword :
	MINUTE_P
	| MINUTES_P
	;

second_keyword :
	SECOND_P
	| SECONDS_P
	;

millisecond_keyword :
	MILLISECOND_P
	| MILLISECONDS_P
	;

microsecond_keyword :
	MICROSECOND_P
	| MICROSECONDS_P
	;

opt_interval :
	year_keyword
	| month_keyword
	| day_keyword
	| hour_keyword
	| minute_keyword
	| second_keyword
	| millisecond_keyword
	| microsecond_keyword
	| year_keyword TO month_keyword
	| day_keyword TO hour_keyword
	| day_keyword TO minute_keyword
	| day_keyword TO second_keyword
	| hour_keyword TO minute_keyword
	| hour_keyword TO second_keyword
	| minute_keyword TO second_keyword
	| /*empty*/
	;

a_expr :
	c_expr
	| a_expr TYPECAST /*24L*/ Typename
	| a_expr COLLATE /*20L*/ any_name
	| a_expr AT /*19L*/ TIME ZONE a_expr %prec AT /*19L*/
	| '+' /*16L*/ a_expr %prec UMINUS /*21R*/
	| '-' /*16L*/ a_expr %prec UMINUS /*21R*/
	| a_expr '+' /*16L*/ a_expr
	| a_expr '-' /*16L*/ a_expr
	| a_expr '*' /*17L*/ a_expr
	| a_expr '/' /*17L*/ a_expr
	| a_expr INTEGER_DIVISION /*17L*/ a_expr
	| a_expr '%' /*17L*/ a_expr
	| a_expr '^' /*18L*/ a_expr
	| a_expr POWER_OF /*18L*/ a_expr
	| a_expr '<' /*9N*/ a_expr
	| a_expr '>' /*9N*/ a_expr
	| a_expr '=' /*9N*/ a_expr
	| a_expr LESS_EQUALS /*9N*/ a_expr
	| a_expr GREATER_EQUALS /*9N*/ a_expr
	| a_expr NOT_EQUALS /*9N*/ a_expr
	| a_expr qual_Op a_expr %prec Op /*15L*/
	| qual_Op a_expr %prec Op /*15L*/
	| a_expr qual_Op %prec POSTFIXOP /*12L*/
	| a_expr AND /*6L*/ a_expr
	| a_expr OR /*5L*/ a_expr
	| NOT /*7R*/ a_expr
	| NOT_LA /*10N*/ a_expr %prec NOT /*7R*/
	| a_expr GLOB /*10N*/ a_expr %prec GLOB /*10N*/
	| a_expr LIKE /*10N*/ a_expr
	| a_expr LIKE /*10N*/ a_expr ESCAPE /*11N*/ a_expr %prec LIKE /*10N*/
	| a_expr NOT_LA /*10N*/ LIKE /*10N*/ a_expr %prec NOT_LA /*10N*/
	| a_expr NOT_LA /*10N*/ LIKE /*10N*/ a_expr ESCAPE /*11N*/ a_expr %prec NOT_LA /*10N*/
	| a_expr ILIKE /*10N*/ a_expr
	| a_expr ILIKE /*10N*/ a_expr ESCAPE /*11N*/ a_expr %prec ILIKE /*10N*/
	| a_expr NOT_LA /*10N*/ ILIKE /*10N*/ a_expr %prec NOT_LA /*10N*/
	| a_expr NOT_LA /*10N*/ ILIKE /*10N*/ a_expr ESCAPE /*11N*/ a_expr %prec NOT_LA /*10N*/
	| a_expr SIMILAR /*10N*/ TO a_expr %prec SIMILAR /*10N*/
	| a_expr SIMILAR /*10N*/ TO a_expr ESCAPE /*11N*/ a_expr %prec SIMILAR /*10N*/
	| a_expr NOT_LA /*10N*/ SIMILAR /*10N*/ TO a_expr %prec NOT_LA /*10N*/
	| a_expr NOT_LA /*10N*/ SIMILAR /*10N*/ TO a_expr ESCAPE /*11N*/ a_expr %prec NOT_LA /*10N*/
	| a_expr IS /*8N*/ NULL_P /*14N*/ %prec IS /*8N*/
	| a_expr ISNULL /*8N*/
	| a_expr IS /*8N*/ NOT /*7R*/ NULL_P /*14N*/ %prec IS /*8N*/
	| a_expr NOT /*7R*/ NULL_P /*14N*/
	| a_expr NOTNULL /*8N*/
	| a_expr LAMBDA_ARROW /*4L*/ a_expr
	| a_expr DOUBLE_ARROW /*4L*/ a_expr %prec Op /*15L*/
	| row OVERLAPS row
	| a_expr IS /*8N*/ TRUE_P %prec IS /*8N*/
	| a_expr IS /*8N*/ NOT /*7R*/ TRUE_P %prec IS /*8N*/
	| a_expr IS /*8N*/ FALSE_P %prec IS /*8N*/
	| a_expr IS /*8N*/ NOT /*7R*/ FALSE_P %prec IS /*8N*/
	| a_expr IS /*8N*/ UNKNOWN %prec IS /*8N*/
	| a_expr IS /*8N*/ NOT /*7R*/ UNKNOWN %prec IS /*8N*/
	| a_expr IS /*8N*/ DISTINCT FROM a_expr %prec IS /*8N*/
	| a_expr IS /*8N*/ NOT /*7R*/ DISTINCT FROM a_expr %prec IS /*8N*/
	| a_expr IS /*8N*/ OF '(' /*23L*/ type_list ')' /*23L*/ %prec IS /*8N*/
	| a_expr IS /*8N*/ NOT /*7R*/ OF '(' /*23L*/ type_list ')' /*23L*/ %prec IS /*8N*/
	| a_expr BETWEEN /*10N*/ opt_asymmetric b_expr AND /*6L*/ a_expr %prec BETWEEN /*10N*/
	| a_expr NOT_LA /*10N*/ BETWEEN /*10N*/ opt_asymmetric b_expr AND /*6L*/ a_expr %prec NOT_LA /*10N*/
	| a_expr BETWEEN /*10N*/ SYMMETRIC b_expr AND /*6L*/ a_expr %prec BETWEEN /*10N*/
	| a_expr NOT_LA /*10N*/ BETWEEN /*10N*/ SYMMETRIC b_expr AND /*6L*/ a_expr %prec NOT_LA /*10N*/
	| a_expr IN_P /*10N*/ in_expr
	| a_expr NOT_LA /*10N*/ IN_P /*10N*/ in_expr %prec NOT_LA /*10N*/
	| a_expr subquery_Op sub_type select_with_parens %prec Op /*15L*/
	| a_expr subquery_Op sub_type '(' /*23L*/ a_expr ')' /*23L*/ %prec Op /*15L*/
	| DEFAULT
	| COLUMNS '(' /*23L*/ a_expr ')' /*23L*/
	| '*' /*17L*/ opt_except_list opt_replace_list
	| ColId '.' /*25L*/ '*' /*17L*/ opt_except_list opt_replace_list
	;

b_expr :
	c_expr
	| b_expr TYPECAST /*24L*/ Typename
	| '+' /*16L*/ b_expr %prec UMINUS /*21R*/
	| '-' /*16L*/ b_expr %prec UMINUS /*21R*/
	| b_expr '+' /*16L*/ b_expr
	| b_expr '-' /*16L*/ b_expr
	| b_expr '*' /*17L*/ b_expr
	| b_expr '/' /*17L*/ b_expr
	| b_expr INTEGER_DIVISION /*17L*/ b_expr
	| b_expr '%' /*17L*/ b_expr
	| b_expr '^' /*18L*/ b_expr
	| b_expr POWER_OF /*18L*/ b_expr
	| b_expr '<' /*9N*/ b_expr
	| b_expr '>' /*9N*/ b_expr
	| b_expr '=' /*9N*/ b_expr
	| b_expr LESS_EQUALS /*9N*/ b_expr
	| b_expr GREATER_EQUALS /*9N*/ b_expr
	| b_expr NOT_EQUALS /*9N*/ b_expr
	| b_expr qual_Op b_expr %prec Op /*15L*/
	| qual_Op b_expr %prec Op /*15L*/
	| b_expr qual_Op %prec POSTFIXOP /*12L*/
	| b_expr IS /*8N*/ DISTINCT FROM b_expr %prec IS /*8N*/
	| b_expr IS /*8N*/ NOT /*7R*/ DISTINCT FROM b_expr %prec IS /*8N*/
	| b_expr IS /*8N*/ OF '(' /*23L*/ type_list ')' /*23L*/ %prec IS /*8N*/
	| b_expr IS /*8N*/ NOT /*7R*/ OF '(' /*23L*/ type_list ')' /*23L*/ %prec IS /*8N*/
	;

c_expr :
	d_expr
	| row
	| indirection_expr opt_extended_indirection
	;

d_expr :
	columnref
	| AexprConst
	| '#' ICONST
	| '$' ColLabel
	| '[' /*22L*/ opt_expr_list_opt_comma ']' /*22L*/
	| list_comprehension
	| ARRAY select_with_parens
	| ARRAY '[' /*22L*/ opt_expr_list_opt_comma ']' /*22L*/
	| case_expr
	| select_with_parens %prec UMINUS /*21R*/
	| select_with_parens indirection
	| EXISTS select_with_parens
	| grouping_or_grouping_id '(' /*23L*/ expr_list_opt_comma ')' /*23L*/
	;

indirection_expr :
	'?'
	| PARAM
	| '(' /*23L*/ a_expr ')' /*23L*/
	| struct_expr
	| MAP '{' opt_map_arguments_opt_comma '}'
	| func_expr
	;

struct_expr :
	'{' dict_arguments_opt_comma '}'
	;

func_application :
	func_name '(' /*23L*/ ')' /*23L*/
	| func_name '(' /*23L*/ func_arg_list opt_sort_clause opt_ignore_nulls ')' /*23L*/
	| func_name '(' /*23L*/ VARIADIC func_arg_expr opt_sort_clause opt_ignore_nulls ')' /*23L*/
	| func_name '(' /*23L*/ func_arg_list ',' VARIADIC func_arg_expr opt_sort_clause opt_ignore_nulls ')' /*23L*/
	| func_name '(' /*23L*/ ALL func_arg_list opt_sort_clause opt_ignore_nulls ')' /*23L*/
	| func_name '(' /*23L*/ DISTINCT func_arg_list opt_sort_clause opt_ignore_nulls ')' /*23L*/
	;

func_expr :
	func_application within_group_clause filter_clause export_clause over_clause
	| func_expr_common_subexpr
	;

func_expr_windowless :
	func_application
	| func_expr_common_subexpr
	;

func_expr_common_subexpr :
	COLLATION FOR '(' /*23L*/ a_expr ')' /*23L*/
	| CAST '(' /*23L*/ a_expr AS Typename ')' /*23L*/
	| TRY_CAST '(' /*23L*/ a_expr AS Typename ')' /*23L*/
	| EXTRACT '(' /*23L*/ extract_list ')' /*23L*/
	| OVERLAY '(' /*23L*/ overlay_list ')' /*23L*/
	| POSITION '(' /*23L*/ position_list ')' /*23L*/
	| SUBSTRING '(' /*23L*/ substr_list ')' /*23L*/
	| TREAT '(' /*23L*/ a_expr AS Typename ')' /*23L*/
	| TRIM '(' /*23L*/ BOTH trim_list ')' /*23L*/
	| TRIM '(' /*23L*/ LEADING trim_list ')' /*23L*/
	| TRIM '(' /*23L*/ TRAILING trim_list ')' /*23L*/
	| TRIM '(' /*23L*/ trim_list ')' /*23L*/
	| NULLIF '(' /*23L*/ a_expr ',' a_expr ')' /*23L*/
	| COALESCE '(' /*23L*/ expr_list_opt_comma ')' /*23L*/
	;

list_comprehension :
	'[' /*22L*/ a_expr FOR ColId IN_P /*10N*/ a_expr ']' /*22L*/
	| '[' /*22L*/ a_expr FOR ColId IN_P /*10N*/ c_expr IF_P a_expr ']' /*22L*/
	;

within_group_clause :
	WITHIN GROUP_P '(' /*23L*/ sort_clause ')' /*23L*/
	| /*empty*/
	;

filter_clause :
	FILTER '(' /*23L*/ WHERE a_expr ')' /*23L*/
	| FILTER '(' /*23L*/ a_expr ')' /*23L*/
	| /*empty*/
	;

export_clause :
	EXPORT_STATE
	| /*empty*/
	;

window_clause :
	WINDOW window_definition_list
	| /*empty*/
	;

window_definition_list :
	window_definition
	| window_definition_list ',' window_definition
	;

window_definition :
	ColId AS window_specification
	;

over_clause :
	OVER window_specification
	| OVER ColId
	| /*empty*/
	;

window_specification :
	'(' /*23L*/ opt_existing_window_name opt_partition_clause opt_sort_clause opt_frame_clause ')' /*23L*/
	;

opt_existing_window_name :
	ColId
	| %prec Op /*15L*/ /*empty*/
	;

opt_partition_clause :
	PARTITION /*14N*/ BY expr_list
	| /*empty*/
	;

opt_frame_clause :
	RANGE /*14N*/ frame_extent
	| ROWS /*14N*/ frame_extent
	| /*empty*/
	;

frame_extent :
	frame_bound
	| BETWEEN /*10N*/ frame_bound AND /*6L*/ frame_bound
	;

frame_bound :
	UNBOUNDED /*13N*/ PRECEDING /*14N*/
	| UNBOUNDED /*13N*/ FOLLOWING /*14N*/
	| CURRENT_P ROW
	| a_expr PRECEDING /*14N*/
	| a_expr FOLLOWING /*14N*/
	;

qualified_row :
	ROW '(' /*23L*/ expr_list_opt_comma ')' /*23L*/
	| ROW '(' /*23L*/ ')' /*23L*/
	;

row :
	qualified_row
	| '(' /*23L*/ expr_list ',' a_expr ')' /*23L*/
	;

dict_arg :
	ColIdOrString ':' a_expr
	;

dict_arguments :
	dict_arg
	| dict_arguments ',' dict_arg
	;

dict_arguments_opt_comma :
	dict_arguments
	| dict_arguments ','
	;

map_arg :
	a_expr ':' a_expr
	;

map_arguments :
	map_arg
	| map_arguments ',' map_arg
	;

map_arguments_opt_comma :
	map_arguments
	| map_arguments ','
	;

opt_map_arguments_opt_comma :
	map_arguments_opt_comma
	| /*empty*/
	;

sub_type :
	ANY
	| SOME
	| ALL
	;

all_Op :
	Op /*15L*/
	| MathOp
	;

MathOp :
	'+' /*16L*/
	| '-' /*16L*/
	| '*' /*17L*/
	| '/' /*17L*/
	| INTEGER_DIVISION /*17L*/
	| '%' /*17L*/
	| '^' /*18L*/
	| POWER_OF /*18L*/
	| '<' /*9N*/
	| '>' /*9N*/
	| '=' /*9N*/
	| LESS_EQUALS /*9N*/
	| GREATER_EQUALS /*9N*/
	| NOT_EQUALS /*9N*/
	;

qual_Op :
	Op /*15L*/
	| OPERATOR /*15L*/ '(' /*23L*/ any_operator ')' /*23L*/
	;

qual_all_Op :
	all_Op
	| OPERATOR /*15L*/ '(' /*23L*/ any_operator ')' /*23L*/
	;

subquery_Op :
	all_Op
	| OPERATOR /*15L*/ '(' /*23L*/ any_operator ')' /*23L*/
	| LIKE /*10N*/
	| NOT_LA /*10N*/ LIKE /*10N*/
	| GLOB /*10N*/
	| NOT_LA /*10N*/ GLOB /*10N*/
	| ILIKE /*10N*/
	| NOT_LA /*10N*/ ILIKE /*10N*/
	;

any_operator :
	all_Op
	| ColId '.' /*25L*/ any_operator
	;

c_expr_list :
	c_expr
	| c_expr_list ',' c_expr
	;

c_expr_list_opt_comma :
	c_expr_list
	| c_expr_list ','
	;

expr_list :
	a_expr
	| expr_list ',' a_expr
	;

expr_list_opt_comma :
	expr_list
	| expr_list ','
	;

opt_expr_list_opt_comma :
	expr_list_opt_comma
	| /*empty*/
	;

func_arg_list :
	func_arg_expr
	| func_arg_list ',' func_arg_expr
	;

func_arg_expr :
	a_expr
	| param_name COLON_EQUALS a_expr
	| param_name EQUALS_GREATER a_expr
	;

type_list :
	Typename
	| type_list ',' Typename
	;

extract_list :
	extract_arg FROM a_expr
	| /*empty*/
	;

extract_arg :
	IDENT /*14N*/
	| year_keyword
	| month_keyword
	| day_keyword
	| hour_keyword
	| minute_keyword
	| second_keyword
	| millisecond_keyword
	| microsecond_keyword
	| Sconst
	;

overlay_list :
	a_expr overlay_placing substr_from substr_for
	| a_expr overlay_placing substr_from
	;

overlay_placing :
	PLACING a_expr
	;

position_list :
	b_expr IN_P /*10N*/ b_expr
	| /*empty*/
	;

substr_list :
	a_expr substr_from substr_for
	| a_expr substr_for substr_from
	| a_expr substr_from
	| a_expr substr_for
	| expr_list
	| /*empty*/
	;

substr_from :
	FROM a_expr
	;

substr_for :
	FOR a_expr
	;

trim_list :
	a_expr FROM expr_list_opt_comma
	| FROM expr_list_opt_comma
	| expr_list_opt_comma
	;

in_expr :
	select_with_parens
	| '(' /*23L*/ expr_list_opt_comma ')' /*23L*/
	;

case_expr :
	CASE case_arg when_clause_list case_default END_P
	;

when_clause_list :
	when_clause
	| when_clause_list when_clause
	;

when_clause :
	WHEN a_expr THEN a_expr
	;

case_default :
	ELSE a_expr
	| /*empty*/
	;

case_arg :
	a_expr
	| /*empty*/
	;

columnref :
	ColId
	| ColId indirection
	;

indirection_el :
	'[' /*22L*/ a_expr ']' /*22L*/
	| '[' /*22L*/ opt_slice_bound ':' opt_slice_bound ']' /*22L*/
	| '[' /*22L*/ opt_slice_bound ':' opt_slice_bound ':' opt_slice_bound ']' /*22L*/
	| '[' /*22L*/ opt_slice_bound ':' '-' /*16L*/ ':' opt_slice_bound ']' /*22L*/
	;

opt_slice_bound :
	a_expr
	| /*empty*/
	;

opt_indirection :
	/*empty*/
	| opt_indirection indirection_el
	;

opt_func_arguments :
	/*empty*/
	| '(' /*23L*/ ')' /*23L*/
	| '(' /*23L*/ func_arg_list ')' /*23L*/
	;

extended_indirection_el :
	'.' /*25L*/ attr_name opt_func_arguments
	| '[' /*22L*/ a_expr ']' /*22L*/
	| '[' /*22L*/ opt_slice_bound ':' opt_slice_bound ']' /*22L*/
	| '[' /*22L*/ opt_slice_bound ':' opt_slice_bound ':' opt_slice_bound ']' /*22L*/
	| '[' /*22L*/ opt_slice_bound ':' '-' /*16L*/ ':' opt_slice_bound ']' /*22L*/
	;

///extended_indirection :
///	extended_indirection_el
///	| extended_indirection extended_indirection_el
///	;

opt_extended_indirection :
	/*empty*/
	| opt_extended_indirection extended_indirection_el
	;

opt_asymmetric :
	ASYMMETRIC
	| /*empty*/
	;

opt_target_list_opt_comma :
	target_list_opt_comma
	| /*empty*/
	;

target_list :
	target_el
	| target_list ',' target_el
	;

target_list_opt_comma :
	target_list
	| target_list ','
	;

target_el :
	a_expr AS ColLabelOrString
	| a_expr IDENT /*14N*/
	| a_expr
	;

except_list :
	EXCLUDE '(' /*23L*/ name_list_opt_comma ')' /*23L*/
	| EXCLUDE ColId
	;

opt_except_list :
	except_list
	| /*empty*/
	;

replace_list_el :
	a_expr AS ColId
	;

replace_list :
	replace_list_el
	| replace_list ',' replace_list_el
	;

replace_list_opt_comma :
	replace_list
	| replace_list ','
	;

opt_replace_list :
	REPLACE '(' /*23L*/ replace_list_opt_comma ')' /*23L*/
	| REPLACE replace_list_el
	| /*empty*/
	;

qualified_name_list :
	qualified_name
	| qualified_name_list ',' qualified_name
	;

name_list :
	name
	| name_list ',' name
	;

name_list_opt_comma :
	name_list
	| name_list ','
	;

name_list_opt_comma_opt_bracket :
	name_list_opt_comma
	| '(' /*23L*/ name_list_opt_comma ')' /*23L*/
	;

name :
	ColIdOrString
	;

func_name :
	function_name_token
	| ColId indirection
	;

AexprConst :
	Iconst
	| FCONST
	| Sconst opt_indirection
	| BCONST
	| XCONST
	| func_name Sconst
	| func_name '(' /*23L*/ func_arg_list opt_sort_clause opt_ignore_nulls ')' /*23L*/ Sconst
	| ConstTypename Sconst
	| ConstInterval '(' /*23L*/ a_expr ')' /*23L*/ opt_interval
	| ConstInterval Iconst opt_interval
	| ConstInterval Sconst opt_interval
	| TRUE_P
	| FALSE_P
	| NULL_P /*14N*/
	;

Iconst :
	ICONST
	;

type_function_name :
	IDENT /*14N*/
	| unreserved_keyword
	| type_func_name_keyword
	;

function_name_token :
	IDENT /*14N*/
	| unreserved_keyword
	| func_name_keyword
	;

type_name_token :
	IDENT /*14N*/
	| unreserved_keyword
	| type_name_keyword
	;

any_name :
	ColId
	| ColId attrs
	;

attrs :
	'.' /*25L*/ attr_name
	| attrs '.' /*25L*/ attr_name
	;

opt_name_list :
	'(' /*23L*/ name_list_opt_comma ')' /*23L*/
	| /*empty*/
	;

param_name :
	type_function_name
	;

ColLabelOrString :
	ColLabel
	| SCONST
	;

CreateAsStmt :
	CREATE_P OptTemp TABLE create_as_target AS SelectStmt opt_with_data
	| CREATE_P OptTemp TABLE IF_P NOT /*7R*/ EXISTS create_as_target AS SelectStmt opt_with_data
	| CREATE_P OR /*5L*/ REPLACE OptTemp TABLE create_as_target AS SelectStmt opt_with_data
	;

opt_with_data :
	WITH DATA_P
	| WITH NO DATA_P
	| /*empty*/
	;

create_as_target :
	qualified_name opt_column_list OptWith OnCommitOption
	;

DeallocateStmt :
	DEALLOCATE name
	| DEALLOCATE PREPARE name
	| DEALLOCATE ALL
	| DEALLOCATE PREPARE ALL
	;

ExplainStmt :
	EXPLAIN ExplainableStmt
	| EXPLAIN analyze_keyword opt_verbose ExplainableStmt
	| EXPLAIN VERBOSE ExplainableStmt
	| EXPLAIN '(' /*23L*/ explain_option_list ')' /*23L*/ ExplainableStmt
	;

opt_verbose :
	VERBOSE
	| /*empty*/
	;

explain_option_arg :
	opt_boolean_or_string
	| NumericOnly
	| /*empty*/
	;

ExplainableStmt :
	AlterObjectSchemaStmt
	| AlterSeqStmt
	| AlterTableStmt
	| CallStmt
	| CheckPointStmt
	| CopyStmt
	| CreateAsStmt
	| CreateFunctionStmt
	| CreateSchemaStmt
	| CreateSeqStmt
	| CreateStmt
	| CreateTypeStmt
	| DeallocateStmt
	| DeleteStmt
	| DropStmt
	| ExecuteStmt
	| IndexStmt
	| InsertStmt
	| LoadStmt
	| PragmaStmt
	| PrepareStmt
	| RenameStmt
	| SelectStmt
	| TransactionStmt
	| UpdateStmt
	| VacuumStmt
	| VariableResetStmt
	| VariableSetStmt
	| VariableShowStmt
	| ViewStmt
	;

NonReservedWord :
	IDENT /*14N*/
	| unreserved_keyword
	| other_keyword
	;

NonReservedWord_or_Sconst :
	NonReservedWord
	| Sconst
	;

explain_option_list :
	explain_option_elem
	| explain_option_list ',' explain_option_elem
	;

analyze_keyword :
	ANALYZE
	| ANALYSE
	;

opt_boolean_or_string :
	TRUE_P
	| FALSE_P
	| ON
	| NonReservedWord_or_Sconst
	;

explain_option_elem :
	explain_option_name explain_option_arg
	;

explain_option_name :
	NonReservedWord
	| analyze_keyword
	;

IndexStmt :
	CREATE_P opt_unique INDEX opt_concurrently opt_index_name ON qualified_name access_method_clause '(' /*23L*/ index_params ')' /*23L*/ opt_reloptions where_clause
	| CREATE_P opt_unique INDEX opt_concurrently IF_P NOT /*7R*/ EXISTS index_name ON qualified_name access_method_clause '(' /*23L*/ index_params ')' /*23L*/ opt_reloptions where_clause
	;

access_method :
	ColId
	;

access_method_clause :
	USING access_method
	| /*empty*/
	;

opt_concurrently :
	CONCURRENTLY
	| /*empty*/
	;

opt_index_name :
	index_name
	| /*empty*/
	;

opt_reloptions :
	WITH reloptions
	| /*empty*/
	;

opt_unique :
	UNIQUE
	| /*empty*/
	;

DeleteStmt :
	opt_with_clause DELETE_P FROM relation_expr_opt_alias using_clause where_or_current_clause returning_clause
	| TRUNCATE opt_table relation_expr_opt_alias
	;

relation_expr_opt_alias :
	relation_expr %prec UMINUS /*21R*/
	| relation_expr ColId
	| relation_expr AS ColId
	;

where_or_current_clause :
	WHERE a_expr
	| /*empty*/
	;

using_clause :
	USING from_list_opt_comma
	| /*empty*/
	;

CallStmt :
	CALL_P func_application
	;

ViewStmt :
	CREATE_P OptTemp VIEW qualified_name opt_column_list opt_reloptions AS SelectStmt opt_check_option
	| CREATE_P OptTemp VIEW IF_P NOT /*7R*/ EXISTS qualified_name opt_column_list opt_reloptions AS SelectStmt opt_check_option
	| CREATE_P OR /*5L*/ REPLACE OptTemp VIEW qualified_name opt_column_list opt_reloptions AS SelectStmt opt_check_option
	| CREATE_P OptTemp RECURSIVE VIEW qualified_name '(' /*23L*/ columnList ')' /*23L*/ opt_reloptions AS SelectStmt opt_check_option
	| CREATE_P OR /*5L*/ REPLACE OptTemp RECURSIVE VIEW qualified_name '(' /*23L*/ columnList ')' /*23L*/ opt_reloptions AS SelectStmt opt_check_option
	;

opt_check_option :
	WITH CHECK_P OPTION
	| WITH CASCADED CHECK_P OPTION
	| WITH LOCAL CHECK_P OPTION
	| /*empty*/
	;

PragmaStmt :
	PRAGMA_P ColId
	| PRAGMA_P ColId '=' /*9N*/ var_list
	| PRAGMA_P ColId '(' /*23L*/ func_arg_list ')' /*23L*/
	;

CheckPointStmt :
	FORCE CHECKPOINT opt_col_id
	| CHECKPOINT opt_col_id
	;

opt_col_id :
	ColId
	| /*empty*/
	;

AnalyzeStmt :
	analyze_keyword opt_verbose
	| analyze_keyword opt_verbose qualified_name opt_name_list
	;

UseStmt :
	USE_P qualified_name
	;

VariableResetStmt :
	RESET reset_rest
	| RESET LOCAL reset_rest
	| RESET SESSION reset_rest
	| RESET GLOBAL reset_rest
	;

generic_reset :
	var_name
	| ALL
	;

reset_rest :
	generic_reset
	| TIME ZONE
	| TRANSACTION ISOLATION LEVEL
	;

CreateTypeStmt :
	CREATE_P TYPE_P qualified_name AS ENUM_P /*14N*/ select_with_parens
	| CREATE_P TYPE_P qualified_name AS ENUM_P /*14N*/ '(' /*23L*/ opt_enum_val_list ')' /*23L*/
	| CREATE_P TYPE_P qualified_name AS Typename
	;

opt_enum_val_list :
	enum_val_list
	| /*empty*/
	;

enum_val_list :
	Sconst
	| enum_val_list ',' Sconst
	;

RenameStmt :
	ALTER SCHEMA name RENAME TO name
	| ALTER TABLE relation_expr RENAME TO name
	| ALTER TABLE IF_P EXISTS relation_expr RENAME TO name
	| ALTER SEQUENCE qualified_name RENAME TO name
	| ALTER SEQUENCE IF_P EXISTS qualified_name RENAME TO name
	| ALTER VIEW qualified_name RENAME TO name
	| ALTER VIEW IF_P EXISTS qualified_name RENAME TO name
	| ALTER INDEX qualified_name RENAME TO name
	| ALTER INDEX IF_P EXISTS qualified_name RENAME TO name
	| ALTER TABLE relation_expr RENAME opt_column name TO name
	| ALTER TABLE IF_P EXISTS relation_expr RENAME opt_column name TO name
	| ALTER TABLE relation_expr RENAME CONSTRAINT name TO name
	| ALTER TABLE IF_P EXISTS relation_expr RENAME CONSTRAINT name TO name
	;

opt_column :
	COLUMN
	| /*empty*/
	;

ExportStmt :
	EXPORT_P DATABASE Sconst copy_options
	| EXPORT_P DATABASE ColId TO Sconst copy_options
	;

ImportStmt :
	IMPORT_P DATABASE Sconst
	;

AlterObjectSchemaStmt :
	ALTER TABLE relation_expr SET /*1N*/ SCHEMA name
	| ALTER TABLE IF_P EXISTS relation_expr SET /*1N*/ SCHEMA name
	| ALTER SEQUENCE qualified_name SET /*1N*/ SCHEMA name
	| ALTER SEQUENCE IF_P EXISTS qualified_name SET /*1N*/ SCHEMA name
	| ALTER VIEW qualified_name SET /*1N*/ SCHEMA name
	| ALTER VIEW IF_P EXISTS qualified_name SET /*1N*/ SCHEMA name
	;

PrepareStmt :
	PREPARE name prep_type_clause AS PreparableStmt
	;

prep_type_clause :
	'(' /*23L*/ type_list ')' /*23L*/
	| /*empty*/
	;

PreparableStmt :
	SelectStmt
	| InsertStmt
	| UpdateStmt
	| CopyStmt
	| DeleteStmt
	;

TransactionStmt :
	ABORT_P opt_transaction
	| BEGIN_P opt_transaction
	| START opt_transaction
	| COMMIT opt_transaction
	| END_P opt_transaction
	| ROLLBACK opt_transaction
	;

opt_transaction :
	WORK
	| TRANSACTION
	| /*empty*/
	;

CreateSeqStmt :
	CREATE_P OptTemp SEQUENCE qualified_name OptSeqOptList
	| CREATE_P OptTemp SEQUENCE IF_P NOT /*7R*/ EXISTS qualified_name OptSeqOptList
	| CREATE_P OR /*5L*/ REPLACE OptTemp SEQUENCE qualified_name OptSeqOptList
	;

OptSeqOptList :
	SeqOptList
	| /*empty*/
	;

CreateFunctionStmt :
	CREATE_P OptTemp macro_alias qualified_name param_list AS TABLE SelectStmt
	| CREATE_P OptTemp macro_alias IF_P NOT /*7R*/ EXISTS qualified_name param_list AS TABLE SelectStmt
	| CREATE_P OR /*5L*/ REPLACE OptTemp macro_alias qualified_name param_list AS TABLE SelectStmt
	| CREATE_P OptTemp macro_alias qualified_name param_list AS a_expr
	| CREATE_P OptTemp macro_alias IF_P NOT /*7R*/ EXISTS qualified_name param_list AS a_expr
	| CREATE_P OR /*5L*/ REPLACE OptTemp macro_alias qualified_name param_list AS a_expr
	;

macro_alias :
	FUNCTION
	| MACRO
	;

param_list :
	'(' /*23L*/ ')' /*23L*/
	| '(' /*23L*/ func_arg_list ')' /*23L*/
	;

CreateSchemaStmt :
	CREATE_P SCHEMA qualified_name OptSchemaEltList
	| CREATE_P SCHEMA IF_P NOT /*7R*/ EXISTS qualified_name OptSchemaEltList
	| CREATE_P OR /*5L*/ REPLACE SCHEMA qualified_name OptSchemaEltList
	;

OptSchemaEltList :
	OptSchemaEltList schema_stmt
	| /*empty*/
	;

schema_stmt :
	CreateStmt
	| IndexStmt
	| CreateSeqStmt
	| ViewStmt
	;

AlterSeqStmt :
	ALTER SEQUENCE qualified_name SeqOptList
	| ALTER SEQUENCE IF_P EXISTS qualified_name SeqOptList
	;

SeqOptList :
	SeqOptElem
	| SeqOptList SeqOptElem
	;

opt_with :
	WITH
	| WITH_LA
	| /*empty*/
	;

NumericOnly :
	FCONST
	| '+' /*16L*/ FCONST
	| '-' /*16L*/ FCONST
	| SignedIconst
	;

SeqOptElem :
	AS SimpleTypename
	| CACHE NumericOnly
	| CYCLE
	| NO CYCLE
	| INCREMENT opt_by NumericOnly
	| MAXVALUE NumericOnly
	| MINVALUE NumericOnly
	| NO MAXVALUE
	| NO MINVALUE
	| OWNED BY any_name
	| SEQUENCE NAME_P any_name
	| START opt_with NumericOnly
	| RESTART
	| RESTART opt_with NumericOnly
	;

opt_by :
	BY
	| /*empty*/
	;

SignedIconst :
	Iconst
	| '+' /*16L*/ Iconst
	| '-' /*16L*/ Iconst
	;

VacuumStmt :
	VACUUM opt_full opt_freeze opt_verbose
	| VACUUM opt_full opt_freeze opt_verbose qualified_name opt_name_list
	| VACUUM opt_full opt_freeze opt_verbose AnalyzeStmt
	| VACUUM '(' /*23L*/ vacuum_option_list ')' /*23L*/
	| VACUUM '(' /*23L*/ vacuum_option_list ')' /*23L*/ qualified_name opt_name_list
	;

vacuum_option_elem :
	analyze_keyword
	| VERBOSE
	| FREEZE
	| FULL /*26L*/
	| IDENT /*14N*/
	;

opt_full :
	FULL /*26L*/
	| /*empty*/
	;

vacuum_option_list :
	vacuum_option_elem
	| vacuum_option_list ',' vacuum_option_elem
	;

opt_freeze :
	FREEZE
	| /*empty*/
	;

CopyStmt :
	COPY opt_binary qualified_name opt_column_list opt_oids copy_from opt_program copy_file_name copy_delimiter opt_with copy_options
	| COPY '(' /*23L*/ SelectStmt ')' /*23L*/ TO opt_program copy_file_name opt_with copy_options
	;

copy_from :
	FROM
	| TO
	;

copy_delimiter :
	opt_using DELIMITERS Sconst
	| /*empty*/
	;

copy_generic_opt_arg_list :
	copy_generic_opt_arg_list_item
	| copy_generic_opt_arg_list ',' copy_generic_opt_arg_list_item
	;

opt_using :
	USING
	| /*empty*/
	;

opt_as :
	AS
	| /*empty*/
	;

opt_program :
	PROGRAM
	| /*empty*/
	;

copy_options :
	copy_opt_list
	| '(' /*23L*/ copy_generic_opt_list ')' /*23L*/
	;

copy_generic_opt_arg :
	opt_boolean_or_string
	| NumericOnly
	| '*' /*17L*/
	| '(' /*23L*/ copy_generic_opt_arg_list ')' /*23L*/
	| struct_expr
	| /*empty*/
	;

copy_generic_opt_elem :
	ColLabel copy_generic_opt_arg
	;

opt_oids :
	WITH OIDS
	| /*empty*/
	;

copy_opt_list :
	copy_opt_list copy_opt_item
	| /*empty*/
	;

opt_binary :
	BINARY
	| /*empty*/
	;

copy_opt_item :
	BINARY
	| OIDS
	| FREEZE
	| DELIMITER opt_as Sconst
	| NULL_P /*14N*/ opt_as Sconst
	| CSV
	| HEADER_P
	| QUOTE opt_as Sconst
	| ESCAPE /*11N*/ opt_as Sconst
	| FORCE QUOTE columnList
	| FORCE QUOTE '*' /*17L*/
	| PARTITION /*14N*/ BY columnList
	| PARTITION /*14N*/ BY '*' /*17L*/
	| FORCE NOT /*7R*/ NULL_P /*14N*/ columnList
	| FORCE NULL_P /*14N*/ columnList
	| ENCODING Sconst
	;

copy_generic_opt_arg_list_item :
	opt_boolean_or_string
	;

copy_file_name :
	Sconst
	| STDIN
	| STDOUT
	;

copy_generic_opt_list :
	copy_generic_opt_elem
	| copy_generic_opt_list ',' copy_generic_opt_elem
	;

VariableSetStmt :
	SET /*1N*/ set_rest
	| SET /*1N*/ LOCAL set_rest
	| SET /*1N*/ SESSION set_rest
	| SET /*1N*/ GLOBAL set_rest
	;

set_rest :
	generic_set
	| var_name FROM CURRENT_P
	| TIME ZONE zone_value
	| SCHEMA Sconst
	;

generic_set :
	var_name TO var_list
	| var_name '=' /*9N*/ var_list
	| var_name TO DEFAULT
	| var_name '=' /*9N*/ DEFAULT
	;

var_value :
	opt_boolean_or_string
	| NumericOnly
	;

zone_value :
	Sconst
	| IDENT /*14N*/
	| ConstInterval Sconst opt_interval
	| ConstInterval '(' /*23L*/ Iconst ')' /*23L*/ Sconst
	| NumericOnly
	| DEFAULT
	| LOCAL
	;

var_list :
	var_value
	| var_list ',' var_value
	;

CreateStmt :
	CREATE_P OptTemp TABLE qualified_name '(' /*23L*/ OptTableElementList ')' /*23L*/ OptWith OnCommitOption
	| CREATE_P OptTemp TABLE IF_P NOT /*7R*/ EXISTS qualified_name '(' /*23L*/ OptTableElementList ')' /*23L*/ OptWith OnCommitOption
	| CREATE_P OR /*5L*/ REPLACE OptTemp TABLE qualified_name '(' /*23L*/ OptTableElementList ')' /*23L*/ OptWith OnCommitOption
	;

ConstraintAttributeSpec :
	/*empty*/
	| ConstraintAttributeSpec ConstraintAttributeElem
	;

def_arg :
	func_type
	| reserved_keyword
	| qual_all_Op
	| NumericOnly
	| Sconst
	| NONE
	;

OptParenthesizedSeqOptList :
	'(' /*23L*/ SeqOptList ')' /*23L*/
	| /*empty*/
	;

generic_option_arg :
	Sconst
	;

key_action :
	NO ACTION
	| RESTRICT
	| CASCADE
	| SET /*1N*/ NULL_P /*14N*/
	| SET /*1N*/ DEFAULT
	;

ColConstraint :
	CONSTRAINT name ColConstraintElem
	| ColConstraintElem
	| ConstraintAttr
	| COLLATE /*20L*/ any_name
	;

ColConstraintElem :
	NOT /*7R*/ NULL_P /*14N*/
	| NULL_P /*14N*/
	| UNIQUE opt_definition
	| PRIMARY KEY opt_definition
	| CHECK_P '(' /*23L*/ a_expr ')' /*23L*/ opt_no_inherit
	| USING COMPRESSION name
	| DEFAULT b_expr
	| REFERENCES qualified_name opt_column_list key_match key_actions
	;

GeneratedColumnType :
	VIRTUAL
	| STORED
	;

opt_GeneratedColumnType :
	GeneratedColumnType
	| /*empty*/
	;

GeneratedConstraintElem :
	GENERATED /*14N*/ generated_when AS IDENTITY_P OptParenthesizedSeqOptList
	| GENERATED /*14N*/ generated_when AS '(' /*23L*/ a_expr ')' /*23L*/ opt_GeneratedColumnType
	| AS '(' /*23L*/ a_expr ')' /*23L*/ opt_GeneratedColumnType
	;

generic_option_elem :
	generic_option_name generic_option_arg
	;

key_update :
	ON UPDATE key_action
	;

key_actions :
	key_update
	| key_delete
	| key_update key_delete
	| key_delete key_update
	| /*empty*/
	;

OnCommitOption :
	ON COMMIT DROP
	| ON COMMIT DELETE_P ROWS /*14N*/
	| ON COMMIT PRESERVE /*27R*/ ROWS /*14N*/
	| /*empty*/
	;

reloptions :
	'(' /*23L*/ reloption_list ')' /*23L*/
	;

opt_no_inherit :
	NO INHERIT
	| /*empty*/
	;

TableConstraint :
	CONSTRAINT name ConstraintElem
	| ConstraintElem
	;

TableLikeOption :
	COMMENTS
	| CONSTRAINTS
	| DEFAULTS
	| IDENTITY_P
	| INDEXES
	| STATISTICS
	| STORAGE
	| ALL
	;

reloption_list :
	reloption_elem
	| reloption_list ',' reloption_elem
	;

ExistingIndex :
	USING INDEX index_name
	;

ConstraintAttr :
	DEFERRABLE
	| NOT /*7R*/ DEFERRABLE
	| INITIALLY DEFERRED
	| INITIALLY IMMEDIATE
	;

OptWith :
	WITH reloptions
	| WITH OIDS
	| WITHOUT OIDS
	| /*empty*/
	;

definition :
	'(' /*23L*/ def_list ')' /*23L*/
	;

TableLikeOptionList :
	TableLikeOptionList INCLUDING TableLikeOption
	| TableLikeOptionList EXCLUDING TableLikeOption
	| /*empty*/
	;

generic_option_name :
	ColLabel
	;

ConstraintAttributeElem :
	NOT /*7R*/ DEFERRABLE
	| DEFERRABLE
	| INITIALLY IMMEDIATE
	| INITIALLY DEFERRED
	| NOT /*7R*/ VALID
	| NO INHERIT
	;

columnDef :
	ColId Typename ColQualList
	| ColId opt_Typename GeneratedConstraintElem ColQualList
	;

def_list :
	def_elem
	| def_list ',' def_elem
	;

index_name :
	ColId
	;

TableElement :
	columnDef
	| TableLikeClause
	| TableConstraint
	;

def_elem :
	ColLabel '=' /*9N*/ def_arg
	| ColLabel
	;

opt_definition :
	WITH definition
	| /*empty*/
	;

OptTableElementList :
	TableElementList
	| TableElementList ','
	| /*empty*/
	;

columnElem :
	ColId
	;

opt_column_list :
	'(' /*23L*/ columnList ')' /*23L*/
	| /*empty*/
	;

ColQualList :
	ColQualList ColConstraint
	| /*empty*/
	;

key_delete :
	ON DELETE_P key_action
	;

reloption_elem :
	ColLabel '=' /*9N*/ def_arg
	| ColLabel
	| ColLabel '.' /*25L*/ ColLabel '=' /*9N*/ def_arg
	| ColLabel '.' /*25L*/ ColLabel
	;

columnList :
	columnElem
	| columnList ',' columnElem
	;

columnList_opt_comma :
	columnList
	| columnList ','
	;

func_type :
	Typename
	| type_function_name attrs '%' /*17L*/ TYPE_P
	| SETOF type_function_name attrs '%' /*17L*/ TYPE_P
	;

ConstraintElem :
	CHECK_P '(' /*23L*/ a_expr ')' /*23L*/ ConstraintAttributeSpec
	| UNIQUE '(' /*23L*/ columnList_opt_comma ')' /*23L*/ opt_definition ConstraintAttributeSpec
	| UNIQUE ExistingIndex ConstraintAttributeSpec
	| PRIMARY KEY '(' /*23L*/ columnList_opt_comma ')' /*23L*/ opt_definition ConstraintAttributeSpec
	| PRIMARY KEY ExistingIndex ConstraintAttributeSpec
	| FOREIGN KEY '(' /*23L*/ columnList_opt_comma ')' /*23L*/ REFERENCES qualified_name opt_column_list key_match key_actions ConstraintAttributeSpec
	;

TableElementList :
	TableElement
	| TableElementList ',' TableElement
	;

key_match :
	MATCH FULL /*26L*/
	| MATCH PARTIAL
	| MATCH SIMPLE
	| /*empty*/
	;

TableLikeClause :
	LIKE /*10N*/ qualified_name TableLikeOptionList
	;

OptTemp :
	TEMPORARY
	| TEMP
	| LOCAL TEMPORARY
	| LOCAL TEMP
	| GLOBAL TEMPORARY
	| GLOBAL TEMP
	| UNLOGGED
	| /*empty*/
	;

generated_when :
	ALWAYS
	| BY DEFAULT
	;

unreserved_keyword :
	ABORT_P
	| ABSOLUTE_P
	| ACCESS
	| ACTION
	| ADD_P
	| ADMIN
	| AFTER
	| AGGREGATE
	| ALSO
	| ALTER
	| ALWAYS
	| ASSERTION
	| ASSIGNMENT
	| AT /*19L*/
	| ATTACH
	| ATTRIBUTE
	| BACKWARD
	| BEFORE
	| BEGIN_P
	| BY
	| CACHE
	| CALL_P
	| CALLED
	| CASCADE
	| CASCADED
	| CATALOG_P
	| CHAIN
	| CHARACTERISTICS
	| CHECKPOINT
	| CLASS
	| CLOSE
	| CLUSTER
	| COMMENT
	| COMMENTS
	| COMMIT
	| COMMITTED
	| COMPRESSION
	| CONFIGURATION
	| CONFLICT
	| CONNECTION
	| CONSTRAINTS
	| CONTENT_P
	| CONTINUE_P
	| CONVERSION_P
	| COPY
	| COST
	| CSV
	| CUBE /*14N*/
	| CURRENT_P
	| CURSOR
	| CYCLE
	| DATA_P
	| DATABASE
	| DAY_P
	| DAYS_P
	| DEALLOCATE
	| DECLARE
	| DEFAULTS
	| DEFERRED
	| DEFINER
	| DELETE_P
	| DELIMITER
	| DELIMITERS
	| DEPENDS
	| DESCRIBE
	| DETACH
	| DICTIONARY
	| DISABLE_P
	| DISCARD
	| DOCUMENT_P
	| DOMAIN_P
	| DOUBLE_P
	| DROP
	| EACH
	| ENABLE_P
	| ENCODING
	| ENCRYPTED
	| ENUM_P /*14N*/
	| ESCAPE /*11N*/
	| EVENT
	| EXCLUDE
	| EXCLUDING
	| EXCLUSIVE
	| EXECUTE
	| EXPLAIN
	| EXPORT_P
	| EXPORT_STATE
	| EXTENSION
	| EXTERNAL
	| FAMILY
	| FILTER
	| FIRST_P
	| FOLLOWING /*14N*/
	| FORCE
	| FORWARD
	| FUNCTION
	| FUNCTIONS
	| GLOBAL
	| GRANTED
	| HANDLER
	| HEADER_P
	| HOLD
	| HOUR_P
	| HOURS_P
	| IDENTITY_P
	| IF_P
	| IGNORE_P /*27R*/
	| IMMEDIATE
	| IMMUTABLE
	| IMPLICIT_P
	| IMPORT_P
	| INCLUDE_P
	| INCLUDING
	| INCREMENT
	| INDEX
	| INDEXES
	| INHERIT
	| INHERITS
	| INLINE_P
	| INPUT_P
	| INSENSITIVE
	| INSERT
	| INSTALL
	| INSTEAD
	| INVOKER
	| ISOLATION
	| JSON
	| KEY
	| LABEL
	| LANGUAGE
	| LARGE_P
	| LAST_P
	| LEAKPROOF
	| LEVEL
	| LISTEN
	| LOAD
	| LOCAL
	| LOCATION
	| LOCK_P
	| LOCKED
	| LOGGED
	| MACRO
	| MAPPING
	| MATCH
	| MATERIALIZED
	| MAXVALUE
	| METHOD
	| MICROSECOND_P
	| MICROSECONDS_P
	| MILLISECOND_P
	| MILLISECONDS_P
	| MINUTE_P
	| MINUTES_P
	| MINVALUE
	| MODE
	| MONTH_P
	| MONTHS_P
	| MOVE
	| NAME_P
	| NAMES
	| NEW
	| NEXT
	| NO
	| NOTHING
	| NOTIFY
	| NOWAIT
	| NULLS_P
	| OBJECT_P
	| OF
	| OFF
	| OIDS
	| OLD
	| OPERATOR /*15L*/
	| OPTION
	| OPTIONS
	| ORDINALITY
	| OVER
	| OVERRIDING
	| OWNED
	| OWNER
	| PARALLEL
	| PARSER
	| PARTIAL
	| PARTITION /*14N*/
	| PASSING
	| PASSWORD
	| PERCENT
	| PLANS
	| POLICY
	| PRAGMA_P
	| PRECEDING /*14N*/
	| PREPARE
	| PREPARED
	| PRESERVE /*27R*/
	| PRIOR
	| PRIVILEGES
	| PROCEDURAL
	| PROCEDURE
	| PROGRAM
	| PUBLICATION
	| QUOTE
	| RANGE /*14N*/
	| READ_P
	| REASSIGN
	| RECHECK
	| RECURSIVE
	| REF
	| REFERENCING
	| REFRESH
	| REINDEX
	| RELATIVE_P
	| RELEASE
	| RENAME
	| REPEATABLE
	| REPLACE
	| REPLICA
	| RESET
	| RESPECT_P /*27R*/
	| RESTART
	| RESTRICT
	| RETURNS
	| REVOKE
	| ROLE
	| ROLLBACK
	| ROLLUP /*14N*/
	| ROWS /*14N*/
	| RULE
	| SAMPLE
	| SAVEPOINT
	| SCHEMA
	| SCHEMAS
	| SCROLL
	| SEARCH
	| SECOND_P
	| SECONDS_P
	| SECURITY
	| SEQUENCE
	| SEQUENCES
	| SERIALIZABLE
	| SERVER
	| SESSION
	| SET /*1N*/
	| SETS
	| SHARE
	| SHOW
	| SIMPLE
	| SKIP
	| SNAPSHOT
	| SQL_P
	| STABLE
	| STANDALONE_P
	| START
	| STATEMENT
	| STATISTICS
	| STDIN
	| STDOUT
	| STORAGE
	| STORED
	| STRICT_P
	| STRIP_P /*27R*/
	| SUBSCRIPTION
	| SUMMARIZE
	| SYSID
	| SYSTEM_P
	| TABLES
	| TABLESPACE
	| TEMP
	| TEMPLATE
	| TEMPORARY
	| TEXT_P
	| TRANSACTION
	| TRANSFORM
	| TRIGGER
	| TRUNCATE
	| TRUSTED
	| TYPE_P
	| TYPES_P
	| UNBOUNDED /*13N*/
	| UNCOMMITTED
	| UNENCRYPTED
	| UNKNOWN
	| UNLISTEN
	| UNLOGGED
	| UNTIL
	| UPDATE
	| USE_P
	| USER
	| VACUUM
	| VALID
	| VALIDATE
	| VALIDATOR
	| VALUE_P
	| VARYING
	| VERSION_P
	| VIEW
	| VIEWS
	| VIRTUAL
	| VOLATILE
	| WHITESPACE_P
	| WITHIN
	| WITHOUT
	| WORK
	| WRAPPER
	| WRITE_P
	| XML_P
	| YEAR_P
	| YEARS_P
	| YES_P
	| ZONE
	;

col_name_keyword :
	BETWEEN /*10N*/
	| BIGINT
	| BIT
	| BOOLEAN_P
	| CHAR_P
	| CHARACTER
	| COALESCE
	| COLUMNS
	| DEC
	| DECIMAL_P
	| EXISTS
	| EXTRACT
	| FLOAT_P
	| GENERATED /*14N*/
	| GROUPING
	| GROUPING_ID
	| INOUT
	| INT_P
	| INTEGER
	| INTERVAL
	| MAP
	| NATIONAL
	| NCHAR
	| NONE
	| NULLIF
	| NUMERIC
	| OUT_P
	| OVERLAY
	| POSITION
	| PRECISION
	| REAL
	| ROW
	| SETOF
	| SMALLINT
	| STRUCT
	| SUBSTRING
	| TIME
	| TIMESTAMP
	| TREAT
	| TRIM
	| TRY_CAST
	| VALUES
	| VARCHAR
	| XMLATTRIBUTES
	| XMLCONCAT
	| XMLELEMENT
	| XMLEXISTS
	| XMLFOREST
	| XMLNAMESPACES
	| XMLPARSE
	| XMLPI
	| XMLROOT
	| XMLSERIALIZE
	| XMLTABLE
	;

func_name_keyword :
	ASOF /*26L*/
	| AUTHORIZATION
	| BINARY
	| COLLATION
	| CONCURRENTLY
	| CROSS /*26L*/
	| FREEZE
	| FULL /*26L*/
	| GENERATED /*14N*/
	| GLOB /*10N*/
	| ILIKE /*10N*/
	| INNER_P /*26L*/
	| IS /*8N*/
	| ISNULL /*8N*/
	| JOIN /*26L*/
	| LEFT /*26L*/
	| LIKE /*10N*/
	| MAP
	| NATURAL /*26L*/
	| NOTNULL /*8N*/
	| OUTER_P
	| OVERLAPS
	| POSITIONAL /*26L*/
	| RIGHT /*26L*/
	| SIMILAR /*10N*/
	| STRUCT
	| TABLESAMPLE
	| VERBOSE
	;

type_name_keyword :
	ANTI /*26L*/
	| ASOF /*26L*/
	| AUTHORIZATION
	| BINARY
	| COLLATION
	| COLUMNS
	| CONCURRENTLY
	| CROSS /*26L*/
	| FREEZE
	| FULL /*26L*/
	| GLOB /*10N*/
	| ILIKE /*10N*/
	| INNER_P /*26L*/
	| IS /*8N*/
	| ISNULL /*8N*/
	| JOIN /*26L*/
	| LEFT /*26L*/
	| LIKE /*10N*/
	| NATURAL /*26L*/
	| NOTNULL /*8N*/
	| OUTER_P
	| OVERLAPS
	| POSITIONAL /*26L*/
	| RIGHT /*26L*/
	| SEMI /*26L*/
	| SIMILAR /*10N*/
	| TABLESAMPLE
	| TRY_CAST
	| VERBOSE
	;

other_keyword :
	ANTI /*26L*/
	| ASOF /*26L*/
	| AUTHORIZATION
	| BETWEEN /*10N*/
	| BIGINT
	| BINARY
	| BIT
	| BOOLEAN_P
	| CHARACTER
	| CHAR_P
	| COALESCE
	| COLLATION
	| COLUMNS
	| CONCURRENTLY
	| CROSS /*26L*/
	| DEC
	| DECIMAL_P
	| EXISTS
	| EXTRACT
	| FLOAT_P
	| FREEZE
	| FULL /*26L*/
	| GENERATED /*14N*/
	| GLOB /*10N*/
	| GROUPING
	| GROUPING_ID
	| ILIKE /*10N*/
	| INNER_P /*26L*/
	| INOUT
	| INTEGER
	| INTERVAL
	| INT_P
	| IS /*8N*/
	| ISNULL /*8N*/
	| JOIN /*26L*/
	| LEFT /*26L*/
	| LIKE /*10N*/
	| MAP
	| NATIONAL
	| NATURAL /*26L*/
	| NCHAR
	| NONE
	| NOTNULL /*8N*/
	| NULLIF
	| NUMERIC
	| OUTER_P
	| OUT_P
	| OVERLAPS
	| OVERLAY
	| POSITION
	| POSITIONAL /*26L*/
	| PRECISION
	| REAL
	| RIGHT /*26L*/
	| ROW
	| SEMI /*26L*/
	| SETOF
	| SIMILAR /*10N*/
	| SMALLINT
	| STRUCT
	| SUBSTRING
	| TABLESAMPLE
	| TIME
	| TIMESTAMP
	| TREAT
	| TRIM
	| TRY_CAST
	| VALUES
	| VARCHAR
	| VERBOSE
	| XMLATTRIBUTES
	| XMLCONCAT
	| XMLELEMENT
	| XMLEXISTS
	| XMLFOREST
	| XMLNAMESPACES
	| XMLPARSE
	| XMLPI
	| XMLROOT
	| XMLSERIALIZE
	| XMLTABLE
	;

type_func_name_keyword :
	ANTI /*26L*/
	| ASOF /*26L*/
	| AUTHORIZATION
	| BINARY
	| COLLATION
	| COLUMNS
	| CONCURRENTLY
	| CROSS /*26L*/
	| FREEZE
	| FULL /*26L*/
	| GENERATED /*14N*/
	| GLOB /*10N*/
	| ILIKE /*10N*/
	| INNER_P /*26L*/
	| IS /*8N*/
	| ISNULL /*8N*/
	| JOIN /*26L*/
	| LEFT /*26L*/
	| LIKE /*10N*/
	| MAP
	| NATURAL /*26L*/
	| NOTNULL /*8N*/
	| OUTER_P
	| OVERLAPS
	| POSITIONAL /*26L*/
	| RIGHT /*26L*/
	| SEMI /*26L*/
	| SIMILAR /*10N*/
	| STRUCT
	| TABLESAMPLE
	| TRY_CAST
	| VERBOSE
	;

reserved_keyword :
	ALL
	| ANALYSE
	| ANALYZE
	| AND /*6L*/
	| ANY
	| ARRAY
	| AS
	| ASC_P
	| ASYMMETRIC
	| BOTH
	| CASE
	| CAST
	| CHECK_P
	| COLLATE /*20L*/
	| COLUMN
	| CONSTRAINT
	| CREATE_P
	| DEFAULT
	| DEFERRABLE
	| DESC_P
	| DISTINCT
	| DO
	| ELSE
	| END_P
	| EXCEPT /*2L*/
	| FALSE_P
	| FETCH
	| FOR
	| FOREIGN
	| FROM
	| GRANT
	| GROUP_P
	| HAVING
	| IN_P /*10N*/
	| INITIALLY
	| INTERSECT /*3L*/
	| INTO
	| LATERAL_P
	| LEADING
	| LIMIT
	| NOT /*7R*/
	| NULL_P /*14N*/
	| OFFSET
	| ON
	| ONLY
	| OR /*5L*/
	| ORDER
	| PIVOT /*26L*/
	| PIVOT_LONGER
	| PIVOT_WIDER
	| PLACING
	| PRIMARY
	| QUALIFY
	| REFERENCES
	| RETURNING
	| SELECT
	| SOME
	| SYMMETRIC
	| TABLE
	| THEN
	| TO
	| TRAILING
	| TRUE_P
	| UNION /*2L*/
	| UNIQUE
	| UNPIVOT /*26L*/
	| USING
	| VARIADIC
	| WHEN
	| WHERE
	| WINDOW
	| WITH
	;

%%

%option caseless

%x NOT_LA_ST NULLS_LA_ST WITH_LA_ST

%x xb
%x xc
%x xd
%x xh
%x xe
%x xq
%x xdolq
%x xui
%x xuiend
%x xus
%x xusend
%x xeu

/*
 * In order to make the world safe for Windows and Mac clients as well as
 * Unix ones, we accept either \n or \r as a newline.  A DOS-style \r\n
 * sequence will be seen as two successive newlines, but that doesn't cause '
 * any problems.  Comments that start with -- and extend to the next
 * newline are treated as equivalent to a single whitespace character.
 *
 * NOTE a fine point: if there is no newline following --, we will absorb
 * everything to the end of the input as a comment.  This is correct.  Older
 * versions of Postgres failed to recognize -- as a comment if the input
 * did not end with a newline.
 *
 * XXX perhaps \f (formfeed) should be treated as a newline as well?
 *
 * XXX if you change the set of whitespace characters, fix scanner_isspace()
 * to agree, and see also the plpgsql lexer.
 */

space			[ \t\n\r\f]
horiz_space		[ \t\f]
newline			[\n\r]
non_newline		[^\n\r]

comment			("--"{non_newline}*)

whitespace		({space}+|{comment})

/*
 * SQL requires at least one newline in the whitespace separating
 * string literals that are to be concatenated.  Silly, but who are we
 * to argue?  Note that {whitespace_with_newline} should not have * after
 * it, whereas {whitespace} should generally have a * after it...
 */

special_whitespace		({space}+|{comment}{newline})
horiz_whitespace		({horiz_space}|{comment})
whitespace_with_newline	({horiz_whitespace}*{newline}{special_whitespace}*)

/*
 * To ensure that {quotecontinue} can be scanned without having to back up
 * if the full pattern isn't matched, we include trailing whitespace in
 * {quotestop}.  This matches all cases where {quotecontinue} fails to match,
 * except for {quote} followed by whitespace and just one "-" (not two,
 * which would start a {comment}).  To cover that we have {quotefail}.
 * The actions for {quotestop} and {quotefail} must throw back characters
 * beyond the quote proper.
 */
quote			'
quotestop		{quote}{whitespace}*
quotecontinue	{quote}{whitespace_with_newline}{quote}
quotefail		{quote}{whitespace}*"-"

/* Bit string
 * It is tempting to scan the string for only those characters
 * which are allowed. However, this leads to silently swallowed
 * characters if illegal characters are included in the string.
 * For example, if xbinside is [01] then B'ABCD' is interpreted
 * as a zero-length string, and the ABCD' is lost!
 * Better to pass the string forward and let the input routines
 * validate the contents.
 */
xbstart			[bB]{quote}
xbinside		[^']+

/* Hexadecimal number */
xhstart			[xX]{quote}
xhinside		[^']+

/* National character */
xnstart			[nN]{quote}

/* Quoted string that allows backslash escapes */
xestart			[eE]{quote}
xeinside		[^\\']+
xeescape		[\\][^0-7]
xeoctesc		[\\][0-7]{1,3}
xehexesc		[\\]x[0-9A-Fa-f]{1,2}
xeunicode		[\\](u[0-9A-Fa-f]{4}|U[0-9A-Fa-f]{8})
xeunicodefail	[\\](u[0-9A-Fa-f]{0,3}|U[0-9A-Fa-f]{0,7})

/* Extended quote
 * xqdouble implements embedded quote, ''''
 */
xqstart			{quote}
xqdouble		{quote}{quote}
xqinside		[^']+

/* $foo$ style quotes ("dollar quoting")
 * The quoted string starts with $foo$ where "foo" is an optional string
 * in the form of an identifier, except that it may not contain "$",
 * and extends to the first occurrence of an identical string.
 * There is *no* processing of the quoted text.
 *
 * {dolqfailed} is an error rule to avoid scanner backup when {dolqdelim}
 * fails to match its trailing "$".
 */
dolq_start		[A-Za-z\200-\377_]
dolq_cont		[A-Za-z\200-\377_0-9]
dolqdelim		\$({dolq_start}{dolq_cont}*)?\$
dolqfailed		\${dolq_start}{dolq_cont}*
dolqinside		[^$]+

/* Double quote
 * Allows embedded spaces and other special characters into identifiers.
 */
dquote			\"
xdstart			{dquote}
xdstop			{dquote}
xddouble		{dquote}{dquote}
xdinside		[^"]+

/* Unicode escapes */
uescape			[uU][eE][sS][cC][aA][pP][eE]{whitespace}*{quote}[^']{quote}
/* error rule to avoid backup */
uescapefail		[uU][eE][sS][cC][aA][pP][eE]{whitespace}*"-"|[uU][eE][sS][cC][aA][pP][eE]{whitespace}*{quote}[^']|[uU][eE][sS][cC][aA][pP][eE]{whitespace}*{quote}|[uU][eE][sS][cC][aA][pP][eE]{whitespace}*|[uU][eE][sS][cC][aA][pP]|[uU][eE][sS][cC][aA]|[uU][eE][sS][cC]|[uU][eE][sS]|[uU][eE]|[uU]

/* Quoted identifier with Unicode escapes */
xuistart		[uU]&{dquote}

/* Quoted string with Unicode escapes */
xusstart		[uU]&{quote}

/* Optional UESCAPE after a quoted string or identifier with Unicode escapes. */
xustop1		{uescapefail}
xustop2		{uescape}

/* error rule to avoid backup */
xufailed		[uU]&

/*
 * "self" is the set of chars that should be returned as single-character
 * tokens.  "op_chars" is the set of chars that can make up "Op" tokens,
 * which can be one or more characters long (but if a single-char token
 * appears in the "self" set, it is not to be returned as an Op).  Note
 * that the sets overlap, but each has some chars that are not in the other.
 *
 * If you change either set, adjust the character lists appearing in the
 * rule for "operator"!
 */
self			[,()\[\].;\:\+\-\*\/\%\^\<\>\=]
op_chars		[\~\!\@\^\&\|\`\+\-\*\/\%\<\>\=]
operator		{op_chars}+

/* C-style comments
 *
 * The "extended comment" syntax closely resembles allowable operator syntax.
 * The tricky part here is to get lex to recognize a string starting with
 * slash-star as a comment, when interpreting it as an operator would produce
 * a longer match --- remember lex will prefer a longer match!  Also, if we
 * have something like plus-slash-star, lex will think this is a 3-character
 * operator whereas we want to see it as a + operator and a comment start.
 * The solution is two-fold:
 * 1. append {op_chars}* to xcstart so that it matches as much text as
 *    {operator} would. Then the tie-breaker (first matching rule of same
 *    length) ensures xcstart wins.  We put back the extra stuff with yyless()
 *    in case it contains a star-slash that should terminate the comment.
 * 2. In the operator rule, check for slash-star within the operator, and
 *    if found throw it back with yyless().  This handles the plus-slash-star
 *    problem.
 * Dash-dash comments have similar interactions with the operator rule.
 */
xcstart			\/\*{op_chars}*
xcstop			\*+\/
xcinside		[^*/]+

digit			[0-9]
ident_start		[A-Za-z\200-\377_]
ident_cont		[A-Za-z\200-\377_0-9\$]

identifier		{ident_start}{ident_cont}*

/* Assorted special-case operators and operator-like tokens */
typecast		"::"
dot_dot			\.\.
colon_equals	":="
lambda_arrow	"->"
double_arrow    "->>"
power_of        "**"
integer_div     "//"

/* " */

/*
 * These operator-like tokens (unlike the above ones) also match the {operator}
 * rule, which means that they might be overridden by a longer match if they
 * are followed by a comment start or a + or - character. Accordingly, if you
 * add to this list, you must also add corresponding code to the {operator}
 * block to return the correct token in such cases. (This is not needed in
 * psqlscan.l since the token value is ignored there.)
 */
equals_greater	"=>"
less_equals		"<="
greater_equals	">="
less_greater	"<>"
not_equals		"!="

/* we no longer allow unary minus in numbers.
 * instead we pass it separately to parser. there it gets
 * coerced via doNegate() -- Leon aug 20 1999
 *
 * {decimalfail} is used because we would like "1..10" to lex as 1, dot_dot, 10.
 *
 * {realfail1} and {realfail2} are added to prevent the need for scanner
 * backup when the {real} rule fails to match completely.
 */

integer			{digit}+
decimal			(({digit}*\.{digit}+)|({digit}+\.{digit}*))
decimalfail		{digit}+\.\.
real			({integer}|{decimal})[Ee][-+]?{digit}+
realfail1		({integer}|{decimal})[Ee]
realfail2		({integer}|{decimal})[Ee][-+]

param			\${integer}
param2			\?{integer}

other			.

/*
 * Dollar quoted strings are totally opaque, and no escaping is done on them.
 * Other quoted strings must allow some special characters such as single-quote
 *  and newline.
 * Embedded single-quotes are implemented both in the SQL standard
 *  style of two adjacent single quotes "''" and in the Postgres/Java style
 *  of escaped-quote "\'".
 * Other embedded escaped characters are matched explicitly and the leading
 *  backslash is dropped from the string.
 * Note that xcstart must appear before operator, as explained above!
 *  Also whitespace (comment) must appear before operator.
 */

%%

{whitespace}	skip()

"abort"	ABORT_P
"absolute"	ABSOLUTE_P
"access"	ACCESS
"action"	ACTION
"add"	ADD_P
"admin"	ADMIN
"after"	AFTER
"aggregate"	AGGREGATE
"all"	ALL
"also"	ALSO
"alter"	ALTER
"always"	ALWAYS
"analyse"	ANALYSE
"analyze"	ANALYZE
"and"	AND
"anti"	ANTI
"any"	ANY
"array"	ARRAY
"as"	AS
"asc"	ASC_P
"asof"	ASOF
"assertion"	ASSERTION
"assignment"	ASSIGNMENT
"asymmetric"	ASYMMETRIC
"at"	AT
"attach"	ATTACH
"attribute"	ATTRIBUTE
"authorization"	AUTHORIZATION
"backward"	BACKWARD
"before"	BEFORE
"begin"	BEGIN_P
"between"	BETWEEN
"bigint"	BIGINT
"binary"	BINARY
"bit"	BIT
"boolean"	BOOLEAN_P
"both"	BOTH
"by"	BY
"cache"	CACHE
"call"	CALL_P
"called"	CALLED
"cascade"	CASCADE
"cascaded"	CASCADED
"case"	CASE
"cast"	CAST
"catalog"	CATALOG_P
"chain"	CHAIN
"char"	CHAR_P
"character"	CHARACTER
"characteristics"	CHARACTERISTICS
"check"	CHECK_P
"checkpoint"	CHECKPOINT
"class"	CLASS
"close"	CLOSE
"cluster"	CLUSTER
"coalesce"	COALESCE
"collate"	COLLATE
"collation"	COLLATION
"column"	COLUMN
"columns"	COLUMNS
"comment"	COMMENT
"comments"	COMMENTS
"commit"	COMMIT
"committed"	COMMITTED
"compression"	COMPRESSION
"concurrently"	CONCURRENTLY
"configuration"	CONFIGURATION
"conflict"	CONFLICT
"connection"	CONNECTION
"constraint"	CONSTRAINT
"constraints"	CONSTRAINTS
"content"	CONTENT_P
"continue"	CONTINUE_P
"conversion"	CONVERSION_P
"copy"	COPY
"cost"	COST
"create"	CREATE_P
"cross"	CROSS
"csv"	CSV
"cube"	CUBE
"current"	CURRENT_P
"cursor"	CURSOR
"cycle"	CYCLE
"data"	DATA_P
"database"	DATABASE
"day"	DAY_P
"days"	DAYS_P
"deallocate"	DEALLOCATE
"dec"	DEC
"decimal"	DECIMAL_P
"declare"	DECLARE
"default"	DEFAULT
"defaults"	DEFAULTS
"deferrable"	DEFERRABLE
"deferred"	DEFERRED
"definer"	DEFINER
"delete"	DELETE_P
"delimiter"	DELIMITER
"delimiters"	DELIMITERS
"depends"	DEPENDS
"desc"	DESC_P
"describe"	DESCRIBE
"detach"	DETACH
"dictionary"	DICTIONARY
"disable"	DISABLE_P
"discard"	DISCARD
"distinct"	DISTINCT
"do"	DO
"document"	DOCUMENT_P
"domain"	DOMAIN_P
"double"	DOUBLE_P
"drop"	DROP
"each"	EACH
"else"	ELSE
"enable"	ENABLE_P
"encoding"	ENCODING
"encrypted"	ENCRYPTED
"end"	END_P
"enum"	ENUM_P
"escape"	ESCAPE
"event"	EVENT
"except"	EXCEPT
"exclude"	EXCLUDE
"excluding"	EXCLUDING
"exclusive"	EXCLUSIVE
"execute"	EXECUTE
"exists"	EXISTS
"explain"	EXPLAIN
"export"	EXPORT_P
"export_state"	EXPORT_STATE
"extension"	EXTENSION
"external"	EXTERNAL
"extract"	EXTRACT
"false"	FALSE_P
"family"	FAMILY
"fetch"	FETCH
"filter"	FILTER
"first"	FIRST_P
"float"	FLOAT_P
"following"	FOLLOWING
"for"	FOR
"force"	FORCE
"foreign"	FOREIGN
"forward"	FORWARD
"freeze"	FREEZE
"from"	FROM
"full"	FULL
"function"	FUNCTION
"functions"	FUNCTIONS
"generated"	GENERATED
"glob"	GLOB
"global"	GLOBAL
"grant"	GRANT
"granted"	GRANTED
"group"	GROUP_P
"grouping"	GROUPING
"grouping_id"	GROUPING_ID
"handler"	HANDLER
"having"	HAVING
"header"	HEADER_P
"hold"	HOLD
"hour"	HOUR_P
"hours"	HOURS_P
"identity"	IDENTITY_P
"if"	IF_P
"ignore"	IGNORE_P
"ilike"	ILIKE
"immediate"	IMMEDIATE
"immutable"	IMMUTABLE
"implicit"	IMPLICIT_P
"import"	IMPORT_P
"in"	IN_P
"include"	INCLUDE_P
"including"	INCLUDING
"increment"	INCREMENT
"index"	INDEX
"indexes"	INDEXES
"inherit"	INHERIT
"inherits"	INHERITS
"initially"	INITIALLY
"inline"	INLINE_P
"inner"	INNER_P
"inout"	INOUT
"input"	INPUT_P
"insensitive"	INSENSITIVE
"insert"	INSERT
"install"	INSTALL
"instead"	INSTEAD
"int"	INT_P
"integer"	INTEGER
"intersect"	INTERSECT
"interval"	INTERVAL
"into"	INTO
"invoker"	INVOKER
"is"	IS
"isnull"	ISNULL
"isolation"	ISOLATION
"join"	JOIN
"json"	JSON
"key"	KEY
"label"	LABEL
"language"	LANGUAGE
"large"	LARGE_P
"last"	LAST_P
"lateral"	LATERAL_P
"leading"	LEADING
"leakproof"	LEAKPROOF
"left"	LEFT
"level"	LEVEL
"like"	LIKE
"limit"	LIMIT
"listen"	LISTEN
"load"	LOAD
"local"	LOCAL
"location"	LOCATION
"lock"	LOCK_P
"locked"	LOCKED
"logged"	LOGGED
"macro"	MACRO
"map"	MAP
"mapping"	MAPPING
"match"	MATCH
"materialized"	MATERIALIZED
"maxvalue"	MAXVALUE
"method"	METHOD
"microsecond"	MICROSECOND_P
"microseconds"	MICROSECONDS_P
"millisecond"	MILLISECOND_P
"milliseconds"	MILLISECONDS_P
"minute"	MINUTE_P
"minutes"	MINUTES_P
"minvalue"	MINVALUE
"mode"	MODE
"month"	MONTH_P
"months"	MONTHS_P
"move"	MOVE
"name"	NAME_P
"names"	NAMES
"national"	NATIONAL
"natural"	NATURAL
"nchar"	NCHAR
"new"	NEW
"next"	NEXT
"no"	NO
"none"	NONE
"not"	NOT
"nothing"	NOTHING
"notify"	NOTIFY
"notnull"	NOTNULL
"nowait"	NOWAIT
"null"	NULL_P
"nullif"	NULLIF
"nulls"	NULLS_P
"numeric"	NUMERIC
"object"	OBJECT_P
"of"	OF
"off"	OFF
"offset"	OFFSET
"oids"	OIDS
"old"	OLD
"on"	ON
"only"	ONLY
"operator"	OPERATOR
"option"	OPTION
"options"	OPTIONS
"or"	OR
"order"	ORDER
"ordinality"	ORDINALITY
"out"	OUT_P
"outer"	OUTER_P
"over"	OVER
"overlaps"	OVERLAPS
"overlay"	OVERLAY
"overriding"	OVERRIDING
"owned"	OWNED
"owner"	OWNER
"parallel"	PARALLEL
"parser"	PARSER
"partial"	PARTIAL
"partition"	PARTITION
"passing"	PASSING
"password"	PASSWORD
"percent"	PERCENT
"pivot"	PIVOT
"pivot_longer"	PIVOT_LONGER
"pivot_wider"	PIVOT_WIDER
"placing"	PLACING
"plans"	PLANS
"policy"	POLICY
"position"	POSITION
"positional"	POSITIONAL
"pragma"	PRAGMA_P
"preceding"	PRECEDING
"precision"	PRECISION
"prepare"	PREPARE
"prepared"	PREPARED
"preserve"	PRESERVE
"primary"	PRIMARY
"prior"	PRIOR
"privileges"	PRIVILEGES
"procedural"	PROCEDURAL
"procedure"	PROCEDURE
"program"	PROGRAM
"publication"	PUBLICATION
"qualify"	QUALIFY
"quote"	QUOTE
"range"	RANGE
"read"	READ_P
"real"	REAL
"reassign"	REASSIGN
"recheck"	RECHECK
"recursive"	RECURSIVE
"ref"	REF
"references"	REFERENCES
"referencing"	REFERENCING
"refresh"	REFRESH
"reindex"	REINDEX
"relative"	RELATIVE_P
"release"	RELEASE
"rename"	RENAME
"repeatable"	REPEATABLE
"replace"	REPLACE
"replica"	REPLICA
"reset"	RESET
"respect"	RESPECT_P
"restart"	RESTART
"restrict"	RESTRICT
"returning"	RETURNING
"returns"	RETURNS
"revoke"	REVOKE
"right"	RIGHT
"role"	ROLE
"rollback"	ROLLBACK
"rollup"	ROLLUP
"row"	ROW
"rows"	ROWS
"rule"	RULE
"sample"	SAMPLE
"savepoint"	SAVEPOINT
"schema"	SCHEMA
"schemas"	SCHEMAS
"scroll"	SCROLL
"search"	SEARCH
"second"	SECOND_P
"seconds"	SECONDS_P
"security"	SECURITY
"select"	SELECT
"semi"	SEMI
"sequence"	SEQUENCE
"sequences"	SEQUENCES
"serializable"	SERIALIZABLE
"server"	SERVER
"session"	SESSION
"set"	SET
"setof"	SETOF
"sets"	SETS
"share"	SHARE
"show"	SHOW
"similar"	SIMILAR
"simple"	SIMPLE
"skip"	SKIP
"smallint"	SMALLINT
"snapshot"	SNAPSHOT
"some"	SOME
"sql"	SQL_P
"stable"	STABLE
"standalone"	STANDALONE_P
"start"	START
"statement"	STATEMENT
"statistics"	STATISTICS
"stdin"	STDIN
"stdout"	STDOUT
"storage"	STORAGE
"stored"	STORED
"strict"	STRICT_P
"strip"	STRIP_P
"struct"	STRUCT
"subscription"	SUBSCRIPTION
"substring"	SUBSTRING
"summarize"	SUMMARIZE
"symmetric"	SYMMETRIC
"sysid"	SYSID
"system"	SYSTEM_P
"table"	TABLE
"tables"	TABLES
"tablesample"	TABLESAMPLE
"tablespace"	TABLESPACE
"temp"	TEMP
"template"	TEMPLATE
"temporary"	TEMPORARY
"text"	TEXT_P
"then"	THEN
"time"	TIME
"timestamp"	TIMESTAMP
"to"	TO
"trailing"	TRAILING
"transaction"	TRANSACTION
"transform"	TRANSFORM
"treat"	TREAT
"trigger"	TRIGGER
"trim"	TRIM
"true"	TRUE_P
"truncate"	TRUNCATE
"trusted"	TRUSTED
"try_cast"	TRY_CAST
"type"	TYPE_P
"types"	TYPES_P
"unbounded"	UNBOUNDED
"uncommitted"	UNCOMMITTED
"unencrypted"	UNENCRYPTED
"union"	UNION
"unique"	UNIQUE
"unknown"	UNKNOWN
"unlisten"	UNLISTEN
"unlogged"	UNLOGGED
"unpivot"	UNPIVOT
"until"	UNTIL
"update"	UPDATE
"use"	USE_P
"user"	USER
"using"	USING
"vacuum"	VACUUM
"valid"	VALID
"validate"	VALIDATE
"validator"	VALIDATOR
"value"	VALUE_P
"values"	VALUES
"varchar"	VARCHAR
"variadic"	VARIADIC
"varying"	VARYING
"verbose"	VERBOSE
"version"	VERSION_P
"view"	VIEW
"views"	VIEWS
"virtual"	VIRTUAL
"volatile"	VOLATILE
"when"	WHEN
"where"	WHERE
"whitespace"	WHITESPACE_P
"window"	WINDOW
"with"	WITH
"within"	WITHIN
"without"	WITHOUT
"work"	WORK
"wrapper"	WRAPPER
"write"	WRITE_P
"xml"	XML_P
"xmlattributes"	XMLATTRIBUTES
"xmlconcat"	XMLCONCAT
"xmlelement"	XMLELEMENT
"xmlexists"	XMLEXISTS
"xmlforest"	XMLFOREST
"xmlnamespaces"	XMLNAMESPACES
"xmlparse"	XMLPARSE
"xmlpi"	XMLPI
"xmlroot"	XMLROOT
"xmlserialize"	XMLSERIALIZE
"xmltable"	XMLTABLE
"year"	YEAR_P
"years"	YEARS_P
"yes"	YES_P
"zone"	ZONE

"^"	'^'
"<"	'<'
"="	'='
">"	'>'
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
"$"	'$'
"*"	'*'
"#"	'#'
"%"	'%'
"+"	'+'

NOT\s+(BETWEEN|IN_P|LIKE|ILIKE|SIMILAR)<NOT_LA_ST>	reject()
<NOT_LA_ST> {
	NOT<INITIAL>	NOT_LA
}
NULLS_P\s+(FIRST_P|LAST_P)<NULLS_LA_ST>	reject()
<NULLS_LA_ST> {
	NULLS_P<INITIAL>	NULLS_LA
}

WITH\s+(TIME|ORDINALITY)<WITH_LA_ST>	reject()
<WITH_LA_ST> {
	WITH<INITIAL>	WITH_LA
}


{xcstart}<>xc>

<xc>{xcstart}<>xc>

<xc>{xcstop}<<>	skip()

<xc>{xcinside}	skip()

<xc>{op_chars}	skip()

<xc>\*+			skip()

//<xc><<EOF>>		{ yyerror("unterminated /* comment"); }

{xbstart}<xb>
<xb>{quotestop}<INITIAL>	BCONST
//<xb>{quotefail}
<xh,xb>{xhinside}<.>
<xh,xb>{quotecontinue}	skip()

//<xb><<EOF>>		{ yyerror("unterminated bit string literal"); }

{xhstart}<xh>
<xh>{quotestop}<INITIAL>	XCONST
//<xh>{quotefail}
//<xh><<EOF>>		{ yyerror("unterminated hexadecimal string literal"); }

//{xnstart}		IDENT

{xqstart}<xe>
{xestart}<xe>
{xusstart}<xus>
<xq,xe>{quotestop}<INITIAL>	SCONST
//<xq,xe>{quotefail}
<xus>{quotestop}<xusend>
//<xus>{quotefail}
<xusend>{whitespace}<.>
//<xusend><<EOF>> |
<xusend>{other}|{xustop1}<INITIAL>	SCONST
<xusend>{xustop2}<INITIAL>	 SCONST
<xq,xe,xus>{xqdouble}<.>
<xq,xus>{xqinside}<.>
<xe>{xeinside}<.>
<xe>{xeunicode}<.>
<xeu>{xeunicode}<xe>
//<xeu>.			{ yyerror("invalid Unicode surrogate pair"); }
//<xeu>\n			{ yyerror("invalid Unicode surrogate pair"); }
//<xeu><<EOF>>	{ yyerror("invalid Unicode surrogate pair"); }
//<xe,xeu>{xeunicodefail}
<xe>{xeescape}<.>
<xe>{xeoctesc}<.>
<xe>{xehexesc}<.>
<xq,xe,xus>{quotecontinue} skip()
<xe>.<.>
//<xq,xe,xus><<EOF>>		{ yyerror("unterminated quoted string"); }

{dolqdelim}<xdolq>
//{dolqfailed}			/* throw back all but the initial "$" */

<xdolq>{dolqdelim}<INITIAL>	 SCONST
<xdolq>{dolqinside}<.>
<xdolq>{dolqfailed}<.>
<xdolq>.<.>		/* This is only needed for $ inside the quoted text */
//<xdolq><<EOF>>	{ yyerror("unterminated dollar-quoted string"); }

{xdstart}<xd>
{xuistart}<xui>
<xd>{xdstop}<INITIAL>	IDENT
<xui>{dquote}<xuiend>
<xuiend>{whitespace}<.>
//<xuiend><<EOF>>
<xuiend>{other}|{xustop1}<INITIAL>	IDENT
<xuiend>{xustop2}<INITIAL>		IDENT
<xd,xui>{xddouble}<.>
<xd,xui>{xdinside}<.>
//<xd,xui><<EOF>>		{ yyerror("unterminated quoted identifier"); }

//{xufailed}	IDENT

{typecast}		TYPECAST

//{dot_dot}		DOT_DOT

{colon_equals}	COLON_EQUALS

{lambda_arrow}	LAMBDA_ARROW

{double_arrow}  DOUBLE_ARROW

{power_of}	POWER_OF

{integer_div}	INTEGER_DIVISION

{equals_greater} EQUALS_GREATER

{less_equals}	LESS_EQUALS

{greater_equals} GREATER_EQUALS

{less_greater}	NOT_EQUALS

{not_equals}	NOT_EQUALS

//{self}			return yytext[0];

{operator}		Op

{param}			PARAM

{param2}		PARAM

{integer}		ICONST
{decimal}		FCONST
//{decimalfail}	process_integer_literal(yytext, yylval);

{real}			FCONST
{realfail1}		FCONST
{realfail2}		FCONST


{identifier}	IDENT

//{other}

//<<EOF>>			yyterminate();

%%
