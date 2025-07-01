//From: https://github.com/dolthub/doltgresql/blob/d6e6cb5b89f14040d8d49b4e4cbdb9b3d53ec29d/postgres/parser/parser/sql.y
// Portions Copyright (c) 1996-2015, PostgreSQL Global Development Group
// Portions Copyright (c) 1994, Regents of the University of California
// Portions Copyright 2023 Dolthub, Inc.

// Portions of this file are additionally subject to the following
// license and copyright.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
// implied. See the License for the specific language governing
// permissions and limitations under the License.

/*Tokens*/
%token ABORT
%token ACCESS
%token ACTION
%token ADD
%token ADMIN
%token AFTER
%token AGGREGATE
%token ALIGNMENT
%token ALL
%token ALLOW_CONNECTIONS
%token ALTER
%token ALWAYS
%token ANALYSE
%token ANALYZE
%token AND
%token AND_AND
%token ANNOTATE_TYPE
%token ANY
%token ARRAY
%token AS
%token ASC
%token AS_LA
%token ASYMMETRIC
%token AT
%token ATOMIC
%token ATTACH
%token ATTRIBUTE
%token AUTHORIZATION
%token AUTO
%token AUTOMATIC
%token BACKUP
%token BACKUPS
%token BASETYPE
%token BCONST
%token BEFORE
%token BEGIN
%token BETWEEN
%token BIGINT
//%token BIGSERIAL
%token BINARY
%token BIT
%token BITCONST
%token BOOLEAN
%token BOTH
%token BOX2D
%token BUCKET_COUNT
%token BUFFER_USAGE_LIMIT
%token BUNDLE
%token BY
%token BYPASSRLS
%token CACHE
%token CALL
%token CALLED
%token CANCEL
%token CANCELQUERY
%token CANONICAL
%token CASCADE
%token CASCADED
%token CASE
%token CAST
%token CATEGORY
%token CBRT
%token CHAIN
%token CHANGEFEED
%token CHAR
%token CHARACTER
%token CHARACTERISTICS
%token CHECK
%token CHECK_OPTION
%token CLASS
%token CLOSE
%token CLUSTER
%token COALESCE
%token COLLATABLE
%token COLLATE
%token COLLATION
%token COLLATION_VERSION
%token COLUMN
%token COLUMNS
%token COMBINEFUNC
%token COMMENT
%token COMMENTS
%token COMMIT
%token COMMITTED
%token COMPACT
%token COMPLETE
%token COMPRESSION
%token CONCAT
%token CONCURRENTLY
%token CONFIGURATION
%token CONFIGURATIONS
%token CONFIGURE
%token CONFLICT
%token CONNECT
%token CONNECTION
%token CONSTRAINT
%token CONSTRAINTS
%token CONTAINED_BY
%token CONTAINS
%token CONTROLCHANGEFEED
%token CONTROLJOB
%token CONVERSION
%token CONVERT
%token COPY
%token COST
%token CREATE
%token CREATEDB
%token CREATELOGIN
%token CREATEROLE
%token CROSS
%token CSV
%token CUBE
%token CURRENT
%token CURRENT_CATALOG
%token CURRENT_DATE
%token CURRENT_ROLE
%token CURRENT_SCHEMA
%token CURRENT_TIME
%token CURRENT_TIMESTAMP
%token CURRENT_USER
%token CYCLE
%token DATA
%token DATABASE
%token DATABASES
%token DATE
%token DAY
%token DEALLOCATE
%token DEC
%token DECIMAL
%token DECLARE
%token DEFAULT
%token DEFAULTS
%token DEFERRABLE
%token DEFERRED
%token DEFINER
%token DELETE
%token DELIMITER
%token DEPENDS
%token DESC
%token DESCRIBE
%token DESERIALFUNC
%token DESTINATION
%token DETACH
%token DETACHED
%token DICTIONARY
%token DISABLE
%token DISABLE_PAGE_SKIPPING
%token DISCARD
%token DISTINCT
%token DO
%token DOMAIN
//%token DOT_DOT
%token DOUBLE
%token DROP
%token EACH
%token ELEMENT
%token ELSE
%token ENABLE
%token ENCODING
%token ENCRYPTED
%token ENCRYPTION_PASSPHRASE
%token END
%token ENUM
%token ENUMS
//%token ERROR
%token ESCAPE
%token EVENT
%token EXCEPT
%token EXCLUDE
%token EXCLUDING
%token EXECUTE
%token EXECUTION
%token EXISTS
%token EXPERIMENTAL
%token EXPERIMENTAL_AUDIT
%token EXPERIMENTAL_FINGERPRINTS
%token EXPERIMENTAL_REPLICA
%token EXPIRATION
%token EXPLAIN
%token EXPORT
%token EXPRESSION
%token EXTENDED
%token EXTENSION
%token EXTERNAL
%token EXTRACT
%token EXTRACT_DURATION
%token FALSE
%token FAMILY
%token FCONST
%token FETCH
%token FETCHTEXT
%token FETCHTEXT_PATH
%token FETCHVAL
%token FETCHVAL_PATH
%token FILES
%token FILTER
%token FINALFUNC
%token FINALFUNC_EXTRA
%token FINALFUNC_MODIFY
%token FINALIZE
%token FIRST
%token FLOAT
//%token FLOAT4
//%token FLOAT8
%token FLOORDIV
%token FOLLOWING
%token FOR
%token FORCE
%token FORCE_INDEX
%token FOREIGN
%token FORMAT
%token FREEZE
%token FROM
%token FULL
%token FUNCTION
%token FUNCTIONS
%token GENERATED
%token GENERATED_ALWAYS
%token GEOGRAPHY
%token GEOMETRY
%token GEOMETRYCOLLECTION
%token GEOMETRYCOLLECTIONM
%token GEOMETRYCOLLECTIONZ
%token GEOMETRYCOLLECTIONZM
%token GEOMETRYM
%token GEOMETRYZ
%token GEOMETRYZM
%token GLOBAL
%token GRANT
%token GRANTED
%token GRANTS
%token GREATER_EQUALS
%token GREATEST
%token GROUP
%token GROUPING
%token GROUPS
%token HANDLER
%token HASH
%token HAVING
%token HEADER
%token HELPTOKEN
%token HIGH
%token HISTOGRAM
%token HOUR
%token HYPOTHETICAL
%token ICONST
%token ICU_LOCALE
%token ICU_RULES
%token IDENT
%token IDENTITY
%token IF
%token IFERROR
%token IFNULL
%token IGNORE_FOREIGN_KEYS
%token ILIKE
%token IMMEDIATE
%token IMMUTABLE
%token IMPORT
%token IN
%token INCLUDE
%token INCLUDING
%token INCREMENT
%token INCREMENTAL
%token INDEX
%token INDEX_CLEANUP
%token INDEXES
//%token INET
%token INET_CONTAINED_BY_OR_EQUALS
%token INET_CONTAINS_OR_EQUALS
%token INHERIT
%token INHERITS
%token INITCOND
%token INITIALLY
%token INJECT
%token INLINE
%token INNER
%token INOUT
%token INPUT
%token INSERT
%token INSTEAD
%token INT
%token INTEGER
%token INTERLEAVE
%token INTERNALLENGTH
%token INTERSECT
%token INTERVAL
%token INTO
%token INTO_DB
%token INVERTED
%token INVOKER
%token IS
%token ISERROR
%token ISNULL
%token ISOLATION
%token IS_TEMPLATE
%token JOB
%token JOBS
%token JOIN
%token JSON
%token JSON_ALL_EXISTS
//%token JSONB
%token JSON_SOME_EXISTS
%token KEY
%token KEYS
%token KMS
%token KV
%token LANGUAGE
%token LARGE
%token LAST
%token LATERAL
%token LATEST
%token LC_COLLATE
%token LC_CTYPE
%token LEADING
%token LEAKPROOF
%token LEASE
%token LEAST
%token LEFT
%token LESS
%token LESS_EQUALS
%token LEVEL
%token LIKE
%token LIMIT
%token LINESTRING
//%token LINESTRINGM
//%token LINESTRINGZ
//%token LINESTRINGZM
%token LIST
%token LOCAL
%token LOCALE
%token LOCALE_PROVIDER
%token LOCALTIME
%token LOCALTIMESTAMP
%token LOCKED
%token LOGGED
%token LOGIN
%token LOOKUP
%token LOW
%token LSHIFT
%token MAIN
%token MATCH
%token MATERIALIZED
%token MAXVALUE
%token MERGE
%token METHOD
%token MFINALFUNC
%token MFINALFUNC_EXTRA
%token MFINALFUNC_MODIFY
%token MINITCOND
%token MINUTE
%token MINVALUE
%token MINVFUNC
%token MODIFYCLUSTERSETTING
%token MODULUS
%token MONTH
%token MSFUNC
%token MSPACE
%token MSSPACE
%token MSTYPE
%token MULTILINESTRING
%token MULTILINESTRINGM
%token MULTILINESTRINGZ
%token MULTILINESTRINGZM
%token MULTIPOINT
%token MULTIPOINTM
%token MULTIPOINTZ
%token MULTIPOINTZM
%token MULTIPOLYGON
%token MULTIPOLYGONM
%token MULTIPOLYGONZ
%token MULTIPOLYGONZM
%token MULTIRANGE_TYPE_NAME
//%token NAME
%token NAMES
%token NAN
%token NATURAL
%token NEVER
%token NEW
%token NEXT
%token NO
%token NOBYPASSRLS
%token NOCANCELQUERY
%token NOCONTROLCHANGEFEED
%token NOCONTROLJOB
%token NOCREATEDB
%token NOCREATELOGIN
%token NOCREATEROLE
%token NO_INDEX_JOIN
%token NOINHERIT
%token NOLOGIN
%token NOMODIFYCLUSTERSETTING
%token NONE
%token NOREPLICATION
%token NORMAL
%token NOSUPERUSER
%token NOT
%token NOT_EQUALS
%token NOTHING
%token NOT_LA
%token NOTNULL
%token NOT_REGIMATCH
%token NOT_REGMATCH
%token NOVIEWACTIVITY
%token NOWAIT
%token NULL
%token NULLIF
%token NULLS
%token NUMERIC
%token OBJECT
%token OF
%token OFF
%token OFFSET
%token OID
%token OIDS
//%token OIDVECTOR
%token OLD
%token ON
%token ONLY
%token ONLY_DATABASE_STATS
%token OPERATOR
%token OPT
%token OPTION
%token OPTIONS
%token OR
%token ORDER
%token ORDINALITY
%token OTHERS
%token OUT
%token OUTER
%token OUTPUT
%token OVER
%token OVERLAPS
%token OVERLAY
%token OWNED
%token OWNER
%token PARALLEL
%token PARAMETER
%token PARENT
%token PARSER
%token PARTIAL
%token PARTITION
%token PARTITIONS
%token PASSEDBYVALUE
%token PASSWORD
%token PAUSE
%token PAUSED
%token PHYSICAL
%token PLACEHOLDER
%token PLACING
%token PLAIN
%token PLAN
%token PLANS
%token POINT
%token POINTM
%token POINTZ
%token POINTZM
%token POLICY
%token POLYGON
%token POLYGONM
%token POLYGONZ
%token POLYGONZM
%token POSITION
//%token POSTFIXOP
%token PRECEDING
%token PRECISION
%token PREFERRED
%token PREPARE
%token PRESERVE
%token PRIMARY
%token PRIORITY
%token PRIVILEGES
%token PROCEDURAL
%token PROCEDURE
%token PROCEDURES
%token PROCESS_MAIN
%token PROCESS_TOAST
%token PUBLIC
%token PUBLICATION
%token QUERIES
%token QUERY
%token RANGE
%token RANGES
%token READ
%token READ_ONLY
%token READ_WRITE
%token REAL
%token RECEIVE
%token RECURRING
%token RECURSIVE
%token REF
%token REFERENCES
%token REFERENCING
%token REFRESH
//%token REGCLASS
%token REGIMATCH
//%token REGNAMESPACE
//%token REGPROC
//%token REGPROCEDURE
//%token REGTYPE
%token REINDEX
%token RELEASE
%token REMAINDER
%token REMOVE_PATH
%token RENAME
%token REPEATABLE
%token REPLACE
%token REPLICA
%token REPLICATION
%token RESET
%token RESTART
%token RESTORE
%token RESTRICT
%token RESTRICTED
%token RESUME
%token RETRY
%token RETURN
%token RETURNING
%token RETURNS
%token REVISION_HISTORY
%token REVOKE
%token RIGHT
%token ROLE
%token ROLES
%token ROLLBACK
%token ROLLUP
%token ROUTINE
%token ROUTINES
%token ROW
%token ROWS
%token RSHIFT
%token RULE
%token RUNNING
%token SAFE
%token SAVEPOINT
%token SCATTER
%token SCHEDULE
%token SCHEDULES
%token SCHEMA
%token SCHEMAS
%token SCONST
%token SCRUB
%token SEARCH
%token SECOND
%token SECURITY
%token SECURITY_BARRIER
%token SECURITY_INVOKER
%token SEED
%token SELECT
%token SEND
%token SEQUENCE
%token SEQUENCES
%token SERIALFUNC
%token SERIALIZABLE
%token SERVER
%token SESSION
%token SESSIONS
%token SESSION_USER
%token SET
%token SETOF
%token SETTING
%token SETTINGS
%token SFUNC
%token SHARE
%token SHAREABLE
%token SHOW
%token SIMILAR
%token SIMPLE
%token SKIP
%token SKIP_DATABASE_STATS
%token SKIP_LOCKED
%token SKIP_MISSING_FOREIGN_KEYS
%token SKIP_MISSING_SEQUENCE_OWNERS
%token SKIP_MISSING_SEQUENCES
%token SKIP_MISSING_VIEWS
%token SMALLINT
//%token SMALLSERIAL
%token SNAPSHOT
%token SOME
%token SORTOP
%token SPLIT
%token SQL
%token SQRT
%token SSPACE
%token STABLE
%token START
%token STATEMENT
%token STATISTICS
%token STATUS
%token STDIN
%token STORAGE
%token STORE
%token STORED
%token STRATEGY
%token STRICT
%token STRING
%token STYPE
%token SUBSCRIPT
%token SUBSCRIPTION
%token SUBSTRING
%token SUBTYPE
%token SUBTYPE_DIFF
%token SUBTYPE_OPCLASS
%token SUPERUSER
%token SUPPORT
%token SYMMETRIC
%token SYNTAX
%token SYSID
%token SYSTEM
%token TABLE
%token TABLES
%token TABLESPACE
%token TEMP
%token TEMPLATE
%token TEMPORARY
%token TEXT
%token TEXTSEARCHMATCH
%token THEN
%token THROTTLING
%token TIES
%token TIME
%token TIMESTAMP
%token TIMESTAMPTZ
%token TIMETZ
%token TO
%token TRACE
//%token TRACING
%token TRAILING
%token TRANSACTION
%token TRANSACTIONS
%token TRANSFORM
%token TREAT
%token TRIGGER
%token TRIM
%token TRUE
%token TRUNCATE
%token TRUSTED
%token TYPE
%token TYPEANNOTATE
%token TYPECAST
%token TYPES
%token TYPMOD_IN
%token TYPMOD_OUT
%token UMINUS
%token UNBOUNDED
%token UNCOMMITTED
%token UNION
%token UNIQUE
%token UNKNOWN
%token UNLOGGED
%token UNSAFE
%token UNSPLIT
%token UNTIL
%token UPDATE
%token UPSERT
%token USAGE
%token USE
%token USER
%token USERS
%token USING
//%token UUID
%token VACUUM
%token VALID
%token VALIDATE
%token VALIDATOR
%token VALUE
%token VALUES
%token VARBIT
%token VARCHAR
%token VARIABLE
%token VARIADIC
%token VARYING
%token VERBOSE
%token VERSION
%token VIEW
%token VIEWACTIVITY
%token VIRTUAL
%token VOLATILE
%token WHEN
%token WHERE
%token WINDOW
%token WITH
%token WITHIN
%token WITH_LA
%token WITHOUT
%token WORK
%token WRAPPER
%token WRITE
%token XML
%token YAML
%token YEAR
%token YES
%token ZONE

%nonassoc /*1*/ VALUES
%nonassoc /*2*/ SET
%left /*3*/ EXCEPT UNION
%left /*4*/ INTERSECT
%left /*5*/ OR
%left /*6*/ AND
%right /*7*/ NOT
%nonassoc /*8*/ IS ISNULL NOTNULL
%nonassoc /*9*/ LESS_EQUALS GREATER_EQUALS NOT_EQUALS '<' '>' '='
%nonassoc /*10*/ NOT_REGMATCH REGIMATCH NOT_REGIMATCH TEXTSEARCHMATCH BETWEEN DEFERRABLE ILIKE IN LIKE SIMILAR NOT_LA '~'
%nonassoc /*11*/ ESCAPE
%nonassoc /*12*/ CONTAINS JSON_SOME_EXISTS JSON_ALL_EXISTS CONTAINED_BY '?'
%nonassoc /*13*/ OVERLAPS
//%left /*14*/ POSTFIXOP
%nonassoc /*15*/ UNBOUNDED
%nonassoc /*16*/ IDENT CUBE FOLLOWING GROUPS NULL PARTITION PRECEDING RANGE ROLLUP ROWS
%left /*17*/ CONCAT FETCHVAL FETCHTEXT FETCHVAL_PATH FETCHTEXT_PATH REMOVE_PATH
%left /*18*/ '|'
%left /*19*/ '#'
%left /*20*/ '&'
%left /*21*/ AND_AND CBRT INET_CONTAINED_BY_OR_EQUALS INET_CONTAINS_OR_EQUALS LSHIFT RSHIFT SQRT
%left /*22*/ '@'
%left /*23*/ '+' '-'
%left /*24*/ FLOORDIV '*' '/' '%'
%left /*25*/ '^'
%left /*26*/ OPERATOR
%left /*27*/ AT
%left /*28*/ COLLATE
%right /*29*/ UMINUS
%left /*30*/ '[' ']'
%left /*31*/ '(' ')'
%left /*32*/ TYPEANNOTATE
%left /*33*/ TYPECAST
%left /*34*/ '.'
%left /*35*/ CROSS FULL INNER JOIN LEFT NATURAL RIGHT
%right /*36*/ HELPTOKEN

%start stmt_block

%%

stmt_block :
	%empty
	| stmt_block stmt ';'
	;

stmt :
	HELPTOKEN /*36R*/
	| non_transaction_stmt
	| transaction_stmt
	| /*empty*/
	;

non_transaction_stmt :
	preparable_stmt
	| analyze_stmt
	| call_stmt
	| copy_from_stmt
	| comment_stmt
	| execute_stmt
	| deallocate_stmt
	| discard_stmt
	| grant_stmt
	| prepare_stmt
	| revoke_stmt
	| savepoint_stmt
	| release_stmt
	| refresh_stmt
	| set_stmt
	| close_cursor_stmt
	| declare_cursor_stmt
	//| reindex_stmt
	| vacuum_stmt
	;

stmt_list :
	non_transaction_stmt
	| stmt_list ';' non_transaction_stmt
	;

alter_stmt :
	alter_ddl_stmt
	| alter_role_stmt
	| alter_aggregate_stmt
	| alter_collation_stmt
	| alter_conversion_stmt
	//| ALTER error
	;

alter_ddl_stmt :
	alter_table_stmt
	| alter_index_stmt
	| alter_function_stmt
	| alter_procedure_stmt
	| alter_view_stmt
	| alter_materialized_view_stmt
	| alter_sequence_stmt
	| alter_database_stmt
	| alter_default_privileges_stmt
	| alter_schema_stmt
	| alter_type_stmt
	| alter_trigger_stmt
	| alter_language_stmt
	| alter_domain_stmt
	;

alter_table_stmt :
	alter_onetable_stmt
	| alter_rename_table_stmt
	| alter_table_set_schema_stmt
	| alter_table_all_in_tablespace_stmt
	| alter_table_parition_stmt
	//| ALTER TABLE error
	;

alter_view_stmt :
	ALTER VIEW relation_expr alter_view_cmd
	| ALTER VIEW IF EXISTS relation_expr alter_view_cmd
	//| ALTER VIEW error
	;

alter_view_cmd :
	ALTER opt_column column_name alter_column_default
	| owner_to
	| RENAME opt_column column_name TO column_name
	| RENAME TO view_name
	| set_schema
	| SET /*2N*/ '(' /*31L*/ view_options ')' /*31L*/
	| RESET '(' /*31L*/ view_options ')' /*31L*/
	;

alter_sequence_stmt :
	alter_rename_sequence_stmt
	| alter_sequence_options_stmt
	| alter_sequence_set_schema_stmt
	| alter_sequence_set_log_stmt
	| alter_sequence_owner_to_stmt
	;

alter_sequence_options_stmt :
	ALTER SEQUENCE sequence_name opt_alter_seq_option_list
	| ALTER SEQUENCE IF EXISTS sequence_name opt_alter_seq_option_list
	;

alter_sequence_set_log_stmt :
	ALTER SEQUENCE relation_expr SET /*2N*/ logged_or_unlogged
	| ALTER SEQUENCE IF EXISTS relation_expr SET /*2N*/ logged_or_unlogged
	;

alter_sequence_owner_to_stmt :
	ALTER SEQUENCE relation_expr owner_to
	;

alter_database_stmt :
	alter_rename_database_stmt
	| opt_alter_database
	| alter_database_to_schema_stmt
	//| ALTER DATABASE error
	;

opt_alter_database :
	ALTER DATABASE database_name owner_to
	| ALTER DATABASE database_name opt_database_with_options
	| ALTER DATABASE database_name set_tablespace
	| ALTER DATABASE database_name REFRESH COLLATION VERSION
	| ALTER DATABASE database_name SET /*2N*/ generic_set_single_config
	| ALTER DATABASE database_name RESET name
	| ALTER DATABASE database_name RESET ALL
	;

opt_database_with_options :
	/*empty*/
	| opt_database_options_list
	| WITH opt_database_options_list
	;

opt_database_options_list :
	opt_database_options
	| opt_database_options_list opt_database_options
	;

opt_database_options :
	ALLOW_CONNECTIONS a_expr
	| CONNECTION LIMIT a_expr
	| IS_TEMPLATE a_expr
	;

alter_default_privileges_stmt :
	ALTER DEFAULT PRIVILEGES adp_abbreviated_grant_or_revoke
	| ALTER DEFAULT PRIVILEGES FOR role_or_user opt_role_list adp_abbreviated_grant_or_revoke
	| ALTER DEFAULT PRIVILEGES IN /*10N*/ SCHEMA schema_name_list adp_abbreviated_grant_or_revoke
	| ALTER DEFAULT PRIVILEGES FOR role_or_user opt_role_list IN /*10N*/ SCHEMA schema_name_list adp_abbreviated_grant_or_revoke
	;

adp_abbreviated_grant_or_revoke :
	GRANT privileges ON targets_for_alter_def_priv TO opt_role_list opt_with_grant_option
	| REVOKE opt_grant_option_for privileges ON targets_for_alter_def_priv FROM opt_role_list opt_drop_behavior
	;

opt_grant_option_for :
	/*empty*/
	| GRANT OPTION FOR
	;

targets_for_alter_def_priv :
	TABLES
	| SEQUENCES
	| FUNCTIONS
	| ROUTINES
	| TYPES
	| SCHEMAS
	;

opt_role_list :
	opt_role
	| opt_role_list ',' opt_role
	;

opt_role :
	role_spec
	| GROUP role_spec
	;

alter_index_stmt :
	alter_oneindex_stmt
	| alter_rename_index_stmt
	| alter_index_all_in_tablespace_stmt
	//| ALTER INDEX error
	;

alter_language_stmt :
	ALTER opt_procedural LANGUAGE name RENAME TO name
	| ALTER opt_procedural LANGUAGE name owner_to
	;

alter_domain_stmt :
	ALTER DOMAIN type_name alter_domain_cmd
	;

alter_domain_cmd :
	SET /*2N*/ DEFAULT a_expr
	| DROP DEFAULT
	| SET /*2N*/ NOT /*7R*/ NULL /*16N*/
	| DROP NOT /*7R*/ NULL /*16N*/
	| ADD domain_constraint opt_not_valid
	| DROP CONSTRAINT constraint_name opt_drop_behavior
	| DROP CONSTRAINT IF EXISTS constraint_name opt_drop_behavior
	| RENAME CONSTRAINT constraint_name TO constraint_name
	| VALIDATE CONSTRAINT constraint_name
	| owner_to
	| RENAME TO name
	| set_schema
	;

opt_not_valid :
	/*empty*/
	| NOT /*7R*/ VALID
	;

alter_function_stmt :
	ALTER FUNCTION routine_name opt_routine_args_with_paren alter_function_option_list opt_restrict
	| ALTER FUNCTION routine_name opt_routine_args_with_paren RENAME TO routine_name
	| ALTER FUNCTION routine_name opt_routine_args_with_paren owner_to
	| ALTER FUNCTION routine_name opt_routine_args_with_paren set_schema
	| ALTER FUNCTION routine_name opt_routine_args_with_paren opt_no DEPENDS ON EXTENSION name
	;

opt_restrict :
	/*empty*/
	| RESTRICT
	;

alter_procedure_stmt :
	ALTER PROCEDURE routine_name opt_routine_args_with_paren alter_procedure_option_list opt_restrict
	| ALTER PROCEDURE routine_name opt_routine_args_with_paren RENAME TO routine_name
	| ALTER PROCEDURE routine_name opt_routine_args_with_paren owner_to
	| ALTER PROCEDURE routine_name opt_routine_args_with_paren set_schema
	| ALTER PROCEDURE routine_name opt_routine_args_with_paren opt_no DEPENDS ON EXTENSION name
	;

alter_onetable_stmt :
	ALTER TABLE relation_expr alter_table_cmd
	| ALTER TABLE IF EXISTS relation_expr alter_table_cmd
	;

alter_oneindex_stmt :
	ALTER INDEX table_index_name alter_index_cmd
	| ALTER INDEX IF EXISTS table_index_name alter_index_cmd
	| ALTER INDEX table_index_name ATTACH PARTITION /*16N*/ index_name
	| ALTER INDEX table_index_name opt_no DEPENDS ON EXTENSION name
	;

opt_no :
	/*empty*/
	| NO
	;

alter_index_all_in_tablespace_stmt :
	ALTER INDEX ALL IN /*10N*/ TABLESPACE tablespace_name opt_owned_by_list set_tablespace opt_nowait
	;

alter_table_cmd :
	RENAME opt_column column_name TO column_name
	| RENAME CONSTRAINT constraint_name TO constraint_name
	| alter_table_actions
	;

alter_table_actions :
	alter_table_action
	| alter_table_actions ',' alter_table_action
	;

alter_table_action :
	ADD alter_column_def
	| ADD IF NOT /*7R*/ EXISTS alter_column_def
	| ADD COLUMN alter_column_def
	| ADD COLUMN IF NOT /*7R*/ EXISTS alter_column_def
	| DROP opt_column column_name opt_drop_behavior
	| DROP opt_column IF EXISTS column_name opt_drop_behavior
	| ALTER opt_column alter_opt_column_options
	| ADD table_constraint opt_validate_behavior
	| ADD CONSTRAINT constraint_name unique_or_primary USING INDEX index_name opt_deferrable_mode opt_initially
	| ALTER CONSTRAINT constraint_name opt_deferrable_mode opt_initially
	| VALIDATE CONSTRAINT constraint_name
	| DROP CONSTRAINT IF EXISTS constraint_name opt_drop_behavior
	| DROP CONSTRAINT constraint_name opt_drop_behavior
	| enable_or_disable_trigger
	| enable_or_disable_rule
	| row_level_security
	| CLUSTER ON index_name
	| SET /*2N*/ WITHOUT CLUSTER
	| SET /*2N*/ WITHOUT OIDS
	| SET /*2N*/ ACCESS METHOD non_reserved_word_or_sconst
	| set_tablespace
	| SET /*2N*/ logged_or_unlogged
	| SET /*2N*/ '(' /*31L*/ storage_parameter_list ')' /*31L*/
	| RESET '(' /*31L*/ storage_parameter_list ')' /*31L*/
	| INHERIT table_name
	| NO INHERIT table_name
	| OF type_name
	| NOT /*7R*/ OF
	| owner_to
	| replica_identity_option
	;

alter_materialized_view_actions :
	alter_materialized_view_action
	| alter_materialized_view_actions ',' alter_materialized_view_action
	;

alter_materialized_view_action :
	ALTER opt_column alter_materialized_view_opt_column_options
	| CLUSTER ON index_name
	| SET /*2N*/ WITHOUT CLUSTER
	| SET /*2N*/ ACCESS METHOD non_reserved_word_or_sconst
	| set_tablespace
	| SET /*2N*/ '(' /*31L*/ storage_parameter_list ')' /*31L*/
	| RESET '(' /*31L*/ storage_parameter_list ')' /*31L*/
	| owner_to
	;

enable_or_disable_trigger :
	DISABLE TRIGGER trigger_option
	| ENABLE TRIGGER trigger_option
	| ENABLE REPLICA TRIGGER trigger_name
	| ENABLE ALWAYS TRIGGER trigger_name
	;

enable_or_disable_rule :
	DISABLE RULE name
	| ENABLE RULE name
	| ENABLE REPLICA RULE name
	| ENABLE ALWAYS RULE name
	;

replica_identity_option :
	REPLICA IDENTITY DEFAULT
	| REPLICA IDENTITY USING INDEX index_name
	| REPLICA IDENTITY FULL /*35L*/
	| REPLICA IDENTITY NOTHING
	;

logged_or_unlogged :
	LOGGED
	| UNLOGGED
	;

row_level_security :
	DISABLE ROW LEVEL SECURITY
	| ENABLE
	| FORCE
	| NO FORCE
	;

trigger_option :
	trigger_name
	| ALL
	| USER
	;

unique_or_primary :
	UNIQUE
	| PRIMARY
	;

alter_opt_column_options :
	column_name opt_set_data TYPE typename opt_collate opt_alter_column_using
	| column_name alter_column_default
	| column_name SET /*2N*/ NOT /*7R*/ NULL /*16N*/
	| column_name DROP NOT /*7R*/ NULL /*16N*/
	| column_name DROP EXPRESSION opt_if_exists
	| column_name ADD col_qual_generated_identity
	| column_name alter_column_set_seq_elem_list
	| column_name DROP IDENTITY opt_if_exists
	| alter_materialized_view_opt_column_options
	;

alter_materialized_view_opt_column_options :
	column_name SET /*2N*/ STATISTICS signed_iconst
	| column_name SET /*2N*/ '(' /*31L*/ attribution_list ')' /*31L*/
	| column_name RESET '(' /*31L*/ attribution_list ')' /*31L*/
	| column_name SET /*2N*/ STORAGE col_storage_option
	| column_name SET /*2N*/ COMPRESSION unrestricted_name
	;

attribution_list :
	storage_parameter_list
	;

col_storage_option :
	PLAIN
	| EXTERNAL
	| EXTENDED
	| MAIN
	;

alter_column_set_seq_elem_list :
	alter_column_set_seq_elem
	| alter_column_set_seq_elem_list alter_column_set_seq_elem
	;

alter_column_set_seq_elem :
	SET /*2N*/ GENERATED_ALWAYS ALWAYS
	| SET /*2N*/ GENERATED BY DEFAULT
	| SET /*2N*/ create_seq_option_elem
	| RESTART opt_restart
	;

opt_restart :
	opt_with signed_iconst
	;

opt_if_exists :
	/*empty*/
	| IF EXISTS
	;

alter_index_cmd :
	set_tablespace
	| SET /*2N*/ '(' /*31L*/ storage_parameter_list ')' /*31L*/
	| RESET '(' /*31L*/ storage_parameter_list ')' /*31L*/
	| ALTER opt_column iconst32 SET /*2N*/ STATISTICS iconst32
	;

alter_column_default :
	SET /*2N*/ DEFAULT a_expr
	| DROP DEFAULT
	;

opt_alter_column_using :
	USING a_expr
	| /*empty*/
	;

opt_drop_behavior :
	CASCADE
	| RESTRICT
	| /*empty*/
	;

opt_validate_behavior :
	NOT /*7R*/ VALID
	| /*empty*/
	;

alter_type_stmt :
	ALTER TYPE type_name owner_to
	| ALTER TYPE type_name RENAME TO name
	| ALTER TYPE type_name set_schema
	| ALTER TYPE type_name RENAME ATTRIBUTE column_name TO column_name opt_drop_behavior
	| ALTER TYPE type_name alter_attribute_action_list
	| ALTER TYPE type_name ADD VALUE SCONST opt_add_val_placement
	| ALTER TYPE type_name ADD VALUE IF NOT /*7R*/ EXISTS SCONST opt_add_val_placement
	| ALTER TYPE type_name RENAME VALUE SCONST TO SCONST
	| ALTER TYPE type_name SET /*2N*/ '(' /*31L*/ type_property_list ')' /*31L*/
	;

alter_attribute_action_list :
	alter_attribute_action
	| alter_attribute_action_list ',' alter_attribute_action
	;

alter_attribute_action :
	ADD ATTRIBUTE column_name type_name opt_collate opt_drop_behavior
	| DROP ATTRIBUTE column_name opt_drop_behavior
	| DROP ATTRIBUTE IF EXISTS column_name opt_drop_behavior
	| ALTER ATTRIBUTE column_name TYPE type_name opt_collate opt_drop_behavior
	| ALTER ATTRIBUTE column_name SET /*2N*/ DATA TYPE type_name opt_collate opt_drop_behavior
	;

type_property_list :
	type_property
	| type_property_list ',' type_property
	;

set_schema :
	SET /*2N*/ SCHEMA schema_name
	;

set_tablespace :
	SET /*2N*/ TABLESPACE tablespace_name
	;

opt_add_val_placement :
	BEFORE SCONST
	| AFTER SCONST
	| /*empty*/
	;

opt_owned_by_list :
	/*empty*/
	| OWNED BY role_spec_list
	;

role_spec_list :
	role_spec
	| role_spec_list ',' role_spec
	;

role_spec :
	non_reserved_word_or_sconst
	| CURRENT_ROLE
	| CURRENT_USER
	| SESSION_USER
	;

owner_to :
	OWNER TO role_spec
	;

alter_trigger_stmt :
	ALTER TRIGGER trigger_name ON table_name RENAME TO trigger_name
	| ALTER TRIGGER trigger_name ON table_name opt_no DEPENDS ON EXTENSION name
	;

alter_aggregate_stmt :
	ALTER AGGREGATE aggregate_name '(' /*31L*/ aggregate_signature ')' /*31L*/ RENAME TO unrestricted_name
	| ALTER AGGREGATE aggregate_name '(' /*31L*/ aggregate_signature ')' /*31L*/ owner_to
	| ALTER AGGREGATE aggregate_name '(' /*31L*/ aggregate_signature ')' /*31L*/ set_schema
	;

aggregate_signature :
	'*' /*24L*/
	| routine_arg_list
	| routine_arg_list ORDER BY routine_arg_list
	| ORDER BY routine_arg_list
	;

opt_routine_args_with_paren :
	/*empty*/
	| '(' /*31L*/ opt_routine_args ')' /*31L*/
	;

opt_routine_args :
	/*empty*/
	| routine_arg_list
	;

routine_arg_list :
	routine_arg
	| routine_arg_list ',' routine_arg
	;

routine_arg :
	typename
	| type_function_name typename
	| IN /*10N*/ typename
	| IN /*10N*/ type_function_name typename
	| VARIADIC typename
	| VARIADIC type_function_name typename
	| OUT typename
	| OUT type_function_name typename
	| INOUT typename
	| INOUT type_function_name typename
	;

alter_collation_stmt :
	ALTER COLLATION unrestricted_name REFRESH VERSION
	| ALTER COLLATION unrestricted_name RENAME TO unrestricted_name
	| ALTER COLLATION unrestricted_name owner_to
	| ALTER COLLATION unrestricted_name set_schema
	;

alter_conversion_stmt :
	ALTER CONVERSION unrestricted_name RENAME TO unrestricted_name
	| ALTER CONVERSION unrestricted_name owner_to
	| ALTER CONVERSION unrestricted_name set_schema
	;

refresh_stmt :
	REFRESH MATERIALIZED VIEW opt_concurrently view_name opt_clear_data
	//| REFRESH error
	;

opt_clear_data :
	WITH DATA
	| WITH NO DATA
	| /*empty*/
	;

backup_stmt :
	BACKUP opt_backup_targets INTO sconst_or_placeholder IN /*10N*/ string_or_placeholder_opt_list opt_as_of_clause opt_with_backup_options
	| BACKUP opt_backup_targets INTO string_or_placeholder_opt_list opt_as_of_clause opt_with_backup_options
	| BACKUP opt_backup_targets INTO LATEST IN /*10N*/ string_or_placeholder_opt_list opt_as_of_clause opt_with_backup_options
	| BACKUP opt_backup_targets TO string_or_placeholder_opt_list opt_as_of_clause opt_incremental opt_with_backup_options
	//| BACKUP error
	;

opt_backup_targets :
	/*empty*/
	| targets_table
	;

opt_with_backup_options :
	WITH backup_options_list
	| WITH OPTIONS '(' /*31L*/ backup_options_list ')' /*31L*/
	| /*empty*/
	;

backup_options_list :
	backup_options
	| backup_options_list ',' backup_options
	;

backup_options :
	ENCRYPTION_PASSPHRASE '=' /*9N*/ string_or_placeholder
	| REVISION_HISTORY
	| DETACHED
	| KMS '=' /*9N*/ string_or_placeholder_opt_list
	;

create_schedule_for_backup_stmt :
	CREATE SCHEDULE opt_description FOR BACKUP opt_backup_targets INTO string_or_placeholder_opt_list opt_with_backup_options cron_expr opt_full_backup_clause opt_with_schedule_options
	//| CREATE SCHEDULE error
	;

opt_description :
	string_or_placeholder
	| /*empty*/
	;

sconst_or_placeholder :
	SCONST
	| PLACEHOLDER
	;

cron_expr :
	RECURRING sconst_or_placeholder
	;

opt_full_backup_clause :
	FULL /*35L*/ BACKUP sconst_or_placeholder
	| FULL /*35L*/ BACKUP ALWAYS
	| /*empty*/
	;

opt_with_schedule_options :
	WITH SCHEDULE OPTIONS kv_option_list
	| WITH SCHEDULE OPTIONS '(' /*31L*/ kv_option_list ')' /*31L*/
	| /*empty*/
	;

restore_stmt :
	RESTORE FROM list_of_string_or_placeholder_opt_list opt_as_of_clause opt_with_restore_options
	| RESTORE targets_table FROM list_of_string_or_placeholder_opt_list opt_as_of_clause opt_with_restore_options
	| RESTORE targets_table FROM string_or_placeholder IN /*10N*/ list_of_string_or_placeholder_opt_list opt_as_of_clause opt_with_restore_options
	//| RESTORE error
	;

string_or_placeholder_opt_list :
	string_or_placeholder
	| '(' /*31L*/ string_or_placeholder_list ')' /*31L*/
	;

list_of_string_or_placeholder_opt_list :
	string_or_placeholder_opt_list
	| list_of_string_or_placeholder_opt_list ',' string_or_placeholder_opt_list
	;

opt_with_restore_options :
	WITH restore_options_list
	| WITH OPTIONS '(' /*31L*/ restore_options_list ')' /*31L*/
	| /*empty*/
	;

restore_options_list :
	restore_options
	| restore_options_list ',' restore_options
	;

restore_options :
	ENCRYPTION_PASSPHRASE '=' /*9N*/ string_or_placeholder
	| KMS '=' /*9N*/ string_or_placeholder_opt_list
	| INTO_DB '=' /*9N*/ string_or_placeholder
	| SKIP_MISSING_FOREIGN_KEYS
	| SKIP_MISSING_SEQUENCES
	| SKIP_MISSING_SEQUENCE_OWNERS
	| SKIP_MISSING_VIEWS
	| DETACHED
	;

import_format :
	name
	;

import_stmt :
	IMPORT import_format '(' /*31L*/ string_or_placeholder ')' /*31L*/ opt_with_options
	| IMPORT import_format string_or_placeholder opt_with_options
	| IMPORT TABLE table_name FROM import_format '(' /*31L*/ string_or_placeholder ')' /*31L*/ opt_with_options
	| IMPORT TABLE table_name FROM import_format string_or_placeholder opt_with_options
	| IMPORT TABLE table_name CREATE USING string_or_placeholder import_format DATA '(' /*31L*/ string_or_placeholder_list ')' /*31L*/ opt_with_options
	| IMPORT TABLE table_name '(' /*31L*/ table_elem_list ')' /*31L*/ import_format DATA '(' /*31L*/ string_or_placeholder_list ')' /*31L*/ opt_with_options
	| IMPORT INTO table_name '(' /*31L*/ insert_column_list ')' /*31L*/ import_format DATA '(' /*31L*/ string_or_placeholder_list ')' /*31L*/ opt_with_options
	| IMPORT INTO table_name import_format DATA '(' /*31L*/ string_or_placeholder_list ')' /*31L*/ opt_with_options
	//| IMPORT error
	;

export_stmt :
	EXPORT INTO import_format string_or_placeholder opt_with_options FROM select_stmt
	//| EXPORT error
	;

string_or_placeholder :
	non_reserved_word_or_sconst
	| PLACEHOLDER
	;

string_or_placeholder_list :
	string_or_placeholder
	| string_or_placeholder_list ',' string_or_placeholder
	;

opt_incremental :
	INCREMENTAL FROM string_or_placeholder_list
	| /*empty*/
	;

kv_option :
	name '=' /*9N*/ string_or_placeholder
	| name
	| SCONST '=' /*9N*/ string_or_placeholder
	| SCONST
	;

kv_option_list :
	kv_option
	| kv_option_list ',' kv_option
	;

opt_with_options :
	WITH kv_option_list
	| WITH OPTIONS '(' /*31L*/ kv_option_list ')' /*31L*/
	| /*empty*/
	;

call_stmt :
	CALL func_application
	;

copy_from_stmt :
	COPY table_name opt_column_list FROM SCONST opt_with '(' /*31L*/ copy_options_list ')' /*31L*/
	| COPY table_name opt_column_list FROM SCONST opt_legacy_copy_options
	| COPY table_name opt_column_list FROM STDIN opt_with '(' /*31L*/ copy_options_list ')' /*31L*/
	| COPY table_name opt_column_list FROM STDIN opt_legacy_copy_options
	;

opt_legacy_copy_options :
	legacy_copy_options_list
	| /*empty*/
	;

legacy_copy_options_list :
	legacy_copy_options
	| legacy_copy_options_list ',' legacy_copy_options
	;

legacy_copy_options :
	BINARY
	| DELIMITER SCONST
	| CSV
	| HEADER
	;

copy_options_list :
	copy_options
	| copy_options_list ',' copy_options
	;

copy_options :
	FORMAT CSV
	| FORMAT TEXT
	| FORMAT BINARY
	| HEADER
	| HEADER boolean_value
	| DELIMITER SCONST
	;

cancel_stmt :
	cancel_jobs_stmt
	| cancel_queries_stmt
	| cancel_sessions_stmt
	//| CANCEL error
	;

cancel_jobs_stmt :
	CANCEL JOB a_expr
	//| CANCEL JOB error
	| CANCEL JOBS select_stmt
	| CANCEL JOBS for_schedules_clause
	//| CANCEL JOBS error
	;

cancel_queries_stmt :
	CANCEL QUERY a_expr
	| CANCEL QUERY IF EXISTS a_expr
	//| CANCEL QUERY error
	| CANCEL QUERIES select_stmt
	| CANCEL QUERIES IF EXISTS select_stmt
	//| CANCEL QUERIES error
	;

cancel_sessions_stmt :
	CANCEL SESSION a_expr
	| CANCEL SESSION IF EXISTS a_expr
	//| CANCEL SESSION error
	| CANCEL SESSIONS select_stmt
	| CANCEL SESSIONS IF EXISTS select_stmt
	//| CANCEL SESSIONS error
	;

comment_stmt :
	COMMENT ON ACCESS METHOD db_object_name IS /*8N*/ comment_text
	| COMMENT ON AGGREGATE aggregate_name '(' /*31L*/ aggregate_signature ')' /*31L*/ IS /*8N*/ comment_text
	| COMMENT ON CAST '(' /*31L*/ typename AS typename ')' /*31L*/ IS /*8N*/ comment_text
	| COMMENT ON COLLATION collation_name IS /*8N*/ comment_text
	| COMMENT ON COLUMN column_path IS /*8N*/ comment_text
	| COMMENT ON CONSTRAINT constraint_name ON table_name IS /*8N*/ comment_text
	| COMMENT ON CONSTRAINT constraint_name ON DOMAIN type_name IS /*8N*/ comment_text
	| COMMENT ON CONVERSION name IS /*8N*/ comment_text
	| COMMENT ON DATABASE database_name IS /*8N*/ comment_text
	| COMMENT ON DOMAIN type_name IS /*8N*/ comment_text
	| COMMENT ON EXTENSION name IS /*8N*/ comment_text
	| COMMENT ON EVENT TRIGGER name IS /*8N*/ comment_text
	| COMMENT ON FOREIGN DATA WRAPPER name IS /*8N*/ comment_text
	| COMMENT ON FOREIGN TABLE name IS /*8N*/ comment_text
	| COMMENT ON FUNCTION routine_name opt_routine_args_with_paren IS /*8N*/ comment_text
	| COMMENT ON INDEX table_index_name IS /*8N*/ comment_text
	| COMMENT ON LARGE OBJECT signed_iconst IS /*8N*/ comment_text
	| COMMENT ON MATERIALIZED VIEW relation_expr IS /*8N*/ comment_text
	| COMMENT ON OPERATOR /*26L*/ operator '(' /*31L*/ typename ',' typename ')' /*31L*/ IS /*8N*/ comment_text
	| COMMENT ON OPERATOR /*26L*/ CLASS name USING name IS /*8N*/ comment_text
	| COMMENT ON OPERATOR /*26L*/ FAMILY name USING name IS /*8N*/ comment_text
	| COMMENT ON POLICY name ON table_name IS /*8N*/ comment_text
	| COMMENT ON LANGUAGE name IS /*8N*/ comment_text
	| COMMENT ON PROCEDURAL LANGUAGE name IS /*8N*/ comment_text
	| COMMENT ON PROCEDURE routine_name opt_routine_args_with_paren IS /*8N*/ comment_text
	| COMMENT ON PUBLICATION name IS /*8N*/ comment_text
	| COMMENT ON ROLE role_spec IS /*8N*/ comment_text
	| COMMENT ON ROUTINE routine_name opt_routine_args_with_paren IS /*8N*/ comment_text
	| COMMENT ON RULE name ON table_name IS /*8N*/ comment_text
	| COMMENT ON SCHEMA schema_name IS /*8N*/ comment_text
	| COMMENT ON SEQUENCE sequence_name IS /*8N*/ comment_text
	| COMMENT ON SERVER name IS /*8N*/ comment_text
	| COMMENT ON STATISTICS name IS /*8N*/ comment_text
	| COMMENT ON SUBSCRIPTION name IS /*8N*/ comment_text
	| COMMENT ON TABLE table_name IS /*8N*/ comment_text
	| COMMENT ON TABLESPACE tablespace_name IS /*8N*/ comment_text
	| COMMENT ON TEXT SEARCH CONFIGURATION name IS /*8N*/ comment_text
	| COMMENT ON TEXT SEARCH DICTIONARY name IS /*8N*/ comment_text
	| COMMENT ON TEXT SEARCH PARSER name IS /*8N*/ comment_text
	| COMMENT ON TEXT SEARCH TEMPLATE name IS /*8N*/ comment_text
	| COMMENT ON TRANSFORM FOR typename LANGUAGE name IS /*8N*/ comment_text
	| COMMENT ON TRIGGER trigger_name ON table_name IS /*8N*/ comment_text
	| COMMENT ON TYPE type_name IS /*8N*/ comment_text
	| COMMENT ON VIEW view_name IS /*8N*/ comment_text
	;

comment_text :
	SCONST
	| NULL /*16N*/
	;

create_stmt :
	create_role_stmt
	| create_ddl_stmt
	| create_stats_stmt
	| create_schedule_for_backup_stmt
	| create_function_stmt
	| create_procedure_stmt
	| create_extension_stmt
	| create_language_stmt
	| create_aggregate_stmt
	//| create_unsupported
	//| CREATE error
	;

//create_unsupported :
//	CREATE CAST error
//	| CREATE CONVERSION error
//	| CREATE DEFAULT CONVERSION error
//	| CREATE FOREIGN TABLE error
//	| CREATE OPERATOR /*26L*/ error
//	| CREATE PUBLICATION error
//	| CREATE opt_or_replace RULE error
//	| CREATE SERVER error
//	| CREATE SUBSCRIPTION error
//	| CREATE TEXT error
//	;

create_aggregate_stmt :
	create_aggregate_args_only_stmt
	| create_aggregate_order_by_args_stmt
	| create_aggregate_old_syntax_stmt
	;

create_aggregate_args_only_stmt :
	CREATE AGGREGATE aggregate_name '(' /*31L*/ opt_routine_args ')' /*31L*/ '(' /*31L*/ SFUNC '=' /*9N*/ name ',' STYPE '=' /*9N*/ type_name create_agg_args_only_option_list ')' /*31L*/
	| CREATE OR /*5L*/ REPLACE AGGREGATE aggregate_name '(' /*31L*/ opt_routine_args ')' /*31L*/ '(' /*31L*/ SFUNC '=' /*9N*/ name ',' STYPE '=' /*9N*/ type_name create_agg_args_only_option_list ')' /*31L*/
	;

create_agg_args_only_option_list :
	/*empty*/
	| create_agg_args_only_option
	| create_agg_args_only_option_list ',' create_agg_args_only_option
	;

create_agg_args_only_option :
	create_agg_old_syntax_option
	| create_agg_parallel_option
	;

create_aggregate_order_by_args_stmt :
	CREATE AGGREGATE aggregate_name '(' /*31L*/ opt_routine_args ORDER BY routine_arg_list ')' /*31L*/ '(' /*31L*/ SFUNC '=' /*9N*/ name ',' STYPE '=' /*9N*/ type_name create_agg_order_by_args_option_list ')' /*31L*/
	| CREATE OR /*5L*/ REPLACE AGGREGATE aggregate_name '(' /*31L*/ opt_routine_args ORDER BY routine_arg_list ')' /*31L*/ '(' /*31L*/ SFUNC '=' /*9N*/ name ',' STYPE '=' /*9N*/ type_name create_agg_order_by_args_option_list ')' /*31L*/
	;

create_agg_order_by_args_option_list :
	/*empty*/
	| create_agg_order_by_args_option
	| create_agg_order_by_args_option_list ',' create_agg_order_by_args_option
	;

create_agg_order_by_args_option :
	create_agg_common_option
	| create_agg_parallel_option
	| HYPOTHETICAL
	;

create_aggregate_old_syntax_stmt :
	CREATE AGGREGATE aggregate_name '(' /*31L*/ BASETYPE '=' /*9N*/ type_name ',' SFUNC '=' /*9N*/ name ',' STYPE '=' /*9N*/ type_name create_agg_old_syntax_option_list ')' /*31L*/
	| CREATE OR /*5L*/ REPLACE AGGREGATE aggregate_name '(' /*31L*/ BASETYPE '=' /*9N*/ type_name ',' SFUNC '=' /*9N*/ name ',' STYPE '=' /*9N*/ type_name create_agg_old_syntax_option_list ')' /*31L*/
	;

create_agg_old_syntax_option_list :
	/*empty*/
	| create_agg_old_syntax_option
	| create_agg_old_syntax_option_list ',' create_agg_old_syntax_option
	;

create_agg_old_syntax_option :
	create_agg_common_option
	| COMBINEFUNC '=' /*9N*/ name
	| SERIALFUNC '=' /*9N*/ name
	| DESERIALFUNC '=' /*9N*/ name
	| MSFUNC '=' /*9N*/ name
	| MINVFUNC '=' /*9N*/ name
	| MSTYPE '=' /*9N*/ type_name
	| MSSPACE '=' /*9N*/ iconst64
	| MFINALFUNC '=' /*9N*/ name
	| MFINALFUNC_EXTRA '=' /*9N*/ TRUE
	| MFINALFUNC_EXTRA '=' /*9N*/ FALSE
	| MFINALFUNC_MODIFY '=' /*9N*/ READ_ONLY
	| MFINALFUNC_MODIFY '=' /*9N*/ SHAREABLE
	| MFINALFUNC_MODIFY '=' /*9N*/ READ_WRITE
	| MINITCOND '=' /*9N*/ a_expr
	| SORTOP '=' /*9N*/ math_op
	;

create_agg_common_option :
	SSPACE '=' /*9N*/ iconst64
	| FINALFUNC '=' /*9N*/ name
	| FINALFUNC_EXTRA '=' /*9N*/ TRUE
	| FINALFUNC_EXTRA '=' /*9N*/ FALSE
	| FINALFUNC_MODIFY '=' /*9N*/ READ_ONLY
	| FINALFUNC_MODIFY '=' /*9N*/ SHAREABLE
	| FINALFUNC_MODIFY '=' /*9N*/ READ_WRITE
	| INITCOND '=' /*9N*/ a_expr
	;

create_agg_parallel_option :
	PARALLEL '=' /*9N*/ SAFE
	| PARALLEL '=' /*9N*/ RESTRICTED
	| PARALLEL '=' /*9N*/ UNSAFE
	;

create_domain_stmt :
	CREATE DOMAIN type_name opt_as typename opt_collate opt_arg_default opt_domain_constraint_list
	;

opt_domain_constraint_list :
	/*empty*/
	| domain_constraint_list
	;

domain_constraint_list :
	domain_constraint
	| domain_constraint_list domain_constraint
	;

domain_constraint :
	NOT /*7R*/ NULL /*16N*/
	| NULL /*16N*/
	| CHECK '(' /*31L*/ a_expr ')' /*31L*/
	| CONSTRAINT constraint_name NOT /*7R*/ NULL /*16N*/
	| CONSTRAINT constraint_name NULL /*16N*/
	| CONSTRAINT constraint_name CHECK '(' /*31L*/ a_expr ')' /*31L*/
	;

create_language_stmt :
	CREATE opt_trusted opt_procedural LANGUAGE name opt_language_handler
	| CREATE OR /*5L*/ REPLACE opt_trusted opt_procedural LANGUAGE name opt_language_handler
	;

opt_language_handler :
	/*empty*/
	| HANDLER routine_name opt_handler_inline opt_handler_validator
	;

opt_handler_inline :
	/*empty*/
	| INLINE routine_name
	;

opt_handler_validator :
	/*empty*/
	| VALIDATOR routine_name
	;

create_extension_stmt :
	CREATE EXTENSION name opt_with opt_schema opt_version opt_cascade
	| CREATE EXTENSION IF NOT /*7R*/ EXISTS name opt_with opt_schema opt_version opt_cascade
	;

create_procedure_stmt :
	CREATE PROCEDURE routine_name opt_routine_arg_with_default_list create_procedure_option_list
	| CREATE OR /*5L*/ REPLACE PROCEDURE routine_name opt_routine_arg_with_default_list create_procedure_option_list
	;

create_function_stmt :
	CREATE FUNCTION routine_name opt_routine_arg_with_default_list create_function_option_list
	| CREATE FUNCTION routine_name opt_routine_arg_with_default_list RETURNS typename create_function_option_list
	| CREATE FUNCTION routine_name opt_routine_arg_with_default_list RETURNS SETOF typename create_function_option_list
	| CREATE FUNCTION routine_name opt_routine_arg_with_default_list RETURNS TABLE '(' /*31L*/ opt_returns_table_col_def_list ')' /*31L*/ create_function_option_list
	| CREATE OR /*5L*/ REPLACE FUNCTION routine_name opt_routine_arg_with_default_list create_function_option_list
	| CREATE OR /*5L*/ REPLACE FUNCTION routine_name opt_routine_arg_with_default_list RETURNS typename create_function_option_list
	| CREATE OR /*5L*/ REPLACE FUNCTION routine_name opt_routine_arg_with_default_list RETURNS SETOF typename create_function_option_list
	| CREATE OR /*5L*/ REPLACE FUNCTION routine_name opt_routine_arg_with_default_list RETURNS TABLE '(' /*31L*/ opt_returns_table_col_def_list ')' /*31L*/ create_function_option_list
	;

opt_returns_table_col_def_list :
	returns_table_col_def
	| opt_returns_table_col_def_list ',' returns_table_col_def
	;

returns_table_col_def :
	column_name typename
	;

opt_routine_arg_with_default_list :
	/*empty*/
	| '(' /*31L*/ ')' /*31L*/
	| '(' /*31L*/ routine_arg_with_default_list ')' /*31L*/
	;

routine_arg_with_default_list :
	routine_arg_with_default
	| routine_arg_with_default_list ',' routine_arg_with_default
	;

routine_arg_with_default :
	routine_arg opt_arg_default
	;

opt_arg_default :
	/*empty*/
	| opt_default a_expr
	;

opt_default :
	DEFAULT
	| '=' /*9N*/
	;

alter_function_option_list :
	alter_function_option
	| alter_function_option_list alter_function_option
	;

alter_function_option :
	function_option
	| alter_procedure_option
	;

create_function_option_list :
	create_function_option
	| create_function_option_list create_function_option
	;

create_function_option :
	create_procedure_option
	| function_option
	| WINDOW
	;

function_option :
	IMMUTABLE
	| STABLE
	| VOLATILE
	| opt_not LEAKPROOF
	| CALLED ON NULL /*16N*/ INPUT
	| RETURNS NULL /*16N*/ ON NULL /*16N*/ INPUT
	| STRICT
	| PARALLEL UNSAFE
	| PARALLEL RESTRICTED
	| PARALLEL SAFE
	| COST signed_iconst
	| ROWS /*16N*/ signed_iconst
	| SUPPORT name
	;

alter_procedure_option_list :
	alter_procedure_option
	| alter_procedure_option_list alter_procedure_option
	;

alter_procedure_option :
	opt_external SECURITY definer_or_invoker
	| SET /*2N*/ generic_set_single_config
	| RESET name
	| RESET ALL
	;

create_procedure_option_list :
	create_procedure_option
	| create_procedure_option_list create_procedure_option
	;

create_procedure_option :
	LANGUAGE name
	| TRANSFORM for_type_list
	| opt_external SECURITY definer_or_invoker
	| SET /*2N*/ generic_set_single_config
	| AS SCONST
	| AS SCONST ',' SCONST
	| sql_body
	;

sql_body :
	RETURN a_expr
	| begin_end_block
	;

definer_or_invoker :
	DEFINER
	| INVOKER
	;

opt_external :
	/*empty*/
	| EXTERNAL
	;

opt_not :
	/*empty*/
	| NOT /*7R*/
	;

for_type_list :
	FOR TYPE typename
	| for_type_list ',' FOR TYPE typename
	;

begin_end_block :
	BEGIN ATOMIC END
	| BEGIN ATOMIC stmt_list ';' END
	;

opt_schema :
	/*empty*/
	| SCHEMA schema_name
	;

opt_version :
	/*empty*/
	| VERSION name
	;

opt_cascade :
	/*empty*/
	| CASCADE
	;

//opt_or_replace :
//	OR /*5L*/ REPLACE
//	| /*empty*/
//	;

opt_trusted :
	/*empty*/
	| TRUSTED
	;

opt_procedural :
	/*empty*/
	| PROCEDURAL
	;

//drop_unsupported :
//	DROP CAST error
//	| DROP COLLATION error
//	| DROP CONVERSION error
//	| DROP FOREIGN TABLE error
//	| DROP FOREIGN DATA error
//	| DROP OPERATOR /*26L*/ error
//	| DROP PUBLICATION error
//	| DROP RULE error
//	| DROP SERVER error
//	| DROP SUBSCRIPTION error
//	| DROP TEXT error
//	;

drop_aggregate_stmt :
	DROP AGGREGATE drop_aggregates opt_drop_behavior
	| DROP AGGREGATE IF EXISTS drop_aggregates opt_drop_behavior
	;

drop_aggregates :
	aggregate_name '(' /*31L*/ aggregate_signature ')' /*31L*/
	| drop_aggregates ',' aggregate_name '(' /*31L*/ aggregate_signature ')' /*31L*/
	;

drop_domain_stmt :
	DROP DOMAIN table_name_list opt_drop_behavior
	| DROP DOMAIN IF EXISTS table_name_list opt_drop_behavior
	;

drop_language_stmt :
	DROP opt_procedural LANGUAGE name opt_drop_behavior
	| DROP opt_procedural LANGUAGE IF EXISTS name opt_drop_behavior
	;

drop_extension_stmt :
	DROP EXTENSION name_list opt_drop_behavior
	| DROP EXTENSION IF EXISTS name_list opt_drop_behavior
	;

drop_procedure_stmt :
	DROP PROCEDURE function_name_with_args_list opt_drop_behavior
	| DROP PROCEDURE IF EXISTS function_name_with_args_list opt_drop_behavior
	;

drop_function_stmt :
	DROP FUNCTION function_name_with_args_list opt_drop_behavior
	| DROP FUNCTION IF EXISTS function_name_with_args_list opt_drop_behavior
	;

function_name_with_args_list :
	db_object_name opt_routine_arg_with_default_list
	| function_name_with_args_list ',' db_object_name opt_routine_arg_with_default_list
	;

create_ddl_stmt :
	create_changefeed_stmt
	| create_database_stmt
	| create_schema_stmt
	| create_type_stmt
	| create_domain_stmt
	| create_ddl_stmt_schema_element
	;

create_ddl_stmt_schema_element :
	create_index_stmt
	| create_table_stmt
	| create_table_as_stmt
	//| CREATE opt_persistence_temp_table TABLE error
	| create_view_stmt
	| create_materialized_view_stmt
	| create_sequence_stmt
	| create_trigger_stmt
	;

create_stats_stmt :
	CREATE STATISTICS statistics_name opt_stats_columns FROM create_stats_target opt_create_stats_options
	//| CREATE STATISTICS error
	;

opt_stats_columns :
	ON name_list
	| /*empty*/
	;

create_stats_target :
	table_name
	| '[' /*30L*/ iconst64 ']' /*30L*/
	;

opt_create_stats_options :
	WITH OPTIONS create_stats_option_list
	| as_of_clause
	| /*empty*/
	;

create_stats_option_list :
	create_stats_option
	| create_stats_option_list create_stats_option
	;

create_stats_option :
	THROTTLING FCONST
	| as_of_clause
	;

create_changefeed_stmt :
	CREATE CHANGEFEED FOR changefeed_targets opt_changefeed_sink opt_with_options
	| EXPERIMENTAL CHANGEFEED FOR changefeed_targets opt_with_options
	;

changefeed_targets :
	single_table_pattern_list
	| TABLE single_table_pattern_list
	;

single_table_pattern_list :
	table_name
	| single_table_pattern_list ',' table_name
	;

opt_changefeed_sink :
	INTO string_or_placeholder
	| /*empty*/
	;

delete_stmt :
	opt_with_clause DELETE FROM table_expr_opt_alias_idx opt_using_clause opt_where_clause opt_sort_clause opt_limit_clause returning_clause
	//| opt_with_clause DELETE error
	;

opt_using_clause :
	USING from_list
	| /*empty*/
	;

discard_stmt :
	DISCARD ALL
	| DISCARD PLANS
	| DISCARD SEQUENCES
	| DISCARD TEMP
	| DISCARD TEMPORARY
	//| DISCARD error
	;

drop_stmt :
	drop_ddl_stmt
	| drop_role_stmt
	| drop_schedule_stmt
	| drop_function_stmt
	| drop_procedure_stmt
	| drop_domain_stmt
	| drop_extension_stmt
	| drop_language_stmt
	| drop_aggregate_stmt
	//| drop_unsupported
	//| DROP error
	;

drop_ddl_stmt :
	drop_database_stmt
	| drop_index_stmt
	| drop_table_stmt
	| drop_trigger_stmt
	| drop_view_stmt
	| drop_sequence_stmt
	| drop_schema_stmt
	| drop_type_stmt
	;

drop_view_stmt :
	DROP VIEW table_name_list opt_drop_behavior
	| DROP VIEW IF EXISTS table_name_list opt_drop_behavior
	| DROP MATERIALIZED VIEW table_name_list opt_drop_behavior
	| DROP MATERIALIZED VIEW IF EXISTS table_name_list opt_drop_behavior
	//| DROP VIEW error
	;

drop_sequence_stmt :
	DROP SEQUENCE table_name_list opt_drop_behavior
	| DROP SEQUENCE IF EXISTS table_name_list opt_drop_behavior
	//| DROP SEQUENCE error
	;

drop_table_stmt :
	DROP TABLE table_name_list opt_drop_behavior
	| DROP TABLE IF EXISTS table_name_list opt_drop_behavior
	//| DROP TABLE error
	;

drop_trigger_stmt :
	DROP TRIGGER trigger_name ON table_name opt_drop_behavior
	| DROP TRIGGER IF EXISTS trigger_name ON table_name opt_drop_behavior
	;

drop_index_stmt :
	DROP INDEX opt_concurrently table_index_name_list opt_drop_behavior
	| DROP INDEX opt_concurrently IF EXISTS table_index_name_list opt_drop_behavior
	//| DROP INDEX error
	;

drop_database_stmt :
	DROP DATABASE database_name opt_with_force
	| DROP DATABASE IF EXISTS database_name opt_with_force
	//| DROP DATABASE error
	;

opt_with_force :
	/*empty*/
	| opt_with '(' /*31L*/ force_list ')' /*31L*/
	;

force_list :
	FORCE
	| force_list ',' FORCE
	;

drop_type_stmt :
	DROP TYPE type_name_list opt_drop_behavior
	| DROP TYPE IF EXISTS type_name_list opt_drop_behavior
	//| DROP TYPE error
	;

type_name_list :
	type_name
	| type_name_list ',' type_name
	;

drop_schema_stmt :
	DROP SCHEMA schema_name_list opt_drop_behavior
	| DROP SCHEMA IF EXISTS schema_name_list opt_drop_behavior
	//| DROP SCHEMA error
	;

schema_name_list :
	schema_name
	| schema_name_list ',' schema_name
	;

drop_role_stmt :
	DROP role_or_group_or_user string_or_placeholder_list
	| DROP role_or_group_or_user IF EXISTS string_or_placeholder_list
	//| DROP role_or_group_or_user error
	;

table_name_list :
	table_name
	| table_name_list ',' table_name
	;

analyze_stmt :
	ANALYZE
	| ANALYZE analyze_target
	//| ANALYZE error
	| ANALYSE analyze_target
	//| ANALYSE error
	;

analyze_target :
	table_name
	;

explain_verb :
	EXPLAIN
	| DESCRIBE
	| DESC
	;

explain_stmt :
	explain_verb preparable_stmt
	//| explain_verb error
	| explain_verb '(' /*31L*/ explain_option_list ')' /*31L*/ preparable_stmt
	| explain_verb ANALYZE preparable_stmt
	| explain_verb ANALYSE preparable_stmt
	| explain_verb ANALYZE '(' /*31L*/ explain_option_list ')' /*31L*/ preparable_stmt
	| explain_verb ANALYSE '(' /*31L*/ explain_option_list ')' /*31L*/ preparable_stmt
	//| explain_verb '(' /*31L*/ error
	;

describe_table_stmt :
	explain_verb db_object_name_no_keywords opt_as_of_clause
	;

preparable_stmt :
	alter_stmt
	| backup_stmt
	| cancel_stmt
	| create_stmt
	| delete_stmt
	| drop_stmt
	| explain_stmt
	| describe_table_stmt
	| import_stmt
	| insert_stmt
	| pause_stmt
	| reset_stmt
	| restore_stmt
	| resume_stmt
	| export_stmt
	| scrub_stmt
	| select_stmt
	| show_stmt
	| truncate_stmt
	| update_stmt
	| upsert_stmt
	;

row_source_extension_stmt :
	delete_stmt
	| explain_stmt
	| insert_stmt
	| select_stmt
	| show_stmt
	| update_stmt
	| upsert_stmt
	;

explain_option_list :
	explain_option_name explain_option_value
	| explain_option_list ',' explain_option_name explain_option_value
	;

explain_option_value :
	/*empty*/
	| TRUE
	| FALSE
	| OFF
	| ON
	| TEXT
	| XML
	| JSON
	| YAML
	;

prepare_stmt :
	PREPARE table_alias_name prep_type_clause AS preparable_stmt
	| PREPARE table_alias_name prep_type_clause AS OPT PLAN SCONST
	//| PREPARE error
	;

prep_type_clause :
	'(' /*31L*/ type_list ')' /*31L*/
	| /*empty*/
	;

execute_stmt :
	EXECUTE table_alias_name execute_param_clause
	| EXECUTE table_alias_name execute_param_clause DISCARD ROWS /*16N*/
	//| EXECUTE error
	;

execute_param_clause :
	'(' /*31L*/ expr_list ')' /*31L*/
	| /*empty*/
	;

deallocate_stmt :
	DEALLOCATE name
	| DEALLOCATE PREPARE name
	| DEALLOCATE ALL
	| DEALLOCATE PREPARE ALL
	//| DEALLOCATE error
	;

grant_stmt :
	GRANT privileges_for_cols ON targets_table TO role_spec_list opt_with_grant_option opt_granted_by
	| GRANT privileges ON targets TO role_spec_list opt_with_grant_option opt_granted_by
	| GRANT privilege_list TO role_spec_list opt_grant_role_with opt_granted_by
	//| GRANT error
	;

targets :
	targets_table
	| other_targets
	;

other_targets :
	SEQUENCE name_list
	| DATABASE name_list
	| DOMAIN name_list
	| FOREIGN DATA WRAPPER name_list
	| FOREIGN SERVER name_list
	| FUNCTION routine_with_args_list
	| PROCEDURE routine_with_args_list
	| ROUTINE routine_with_args_list
	| LANGUAGE name_list
	| LARGE OBJECT int_expr_list
	| PARAMETER name_list
	| SCHEMA schema_name_list
	| TABLESPACE name_list
	| TYPE type_name_list
	| ALL SEQUENCES IN /*10N*/ SCHEMA schema_name_list
	| ALL FUNCTIONS IN /*10N*/ SCHEMA schema_name_list
	| ALL PROCEDURES IN /*10N*/ SCHEMA schema_name_list
	| ALL ROUTINES IN /*10N*/ SCHEMA schema_name_list
	| ALL TABLES IN /*10N*/ SCHEMA schema_name_list
	;

routine_with_args_list :
	routine_with_args
	| routine_with_args_list ',' routine_with_args
	;

routine_with_args :
	name
	| name '(' /*31L*/ opt_routine_args ')' /*31L*/
	;

opt_with_grant_option :
	/*empty*/
	| WITH GRANT OPTION
	;

opt_grant_role_with :
	/*empty*/
	| WITH admin_inherit_set option_true_false
	;

admin_inherit_set :
	ADMIN
	| INHERIT
	| SET /*2N*/
	;

boolean_value :
	TRUE
	| FALSE
	| 't'
	| 'f'
	| YES
	| NO
	| 'y'
	| 'n'
	| ICONST
	;

option_true_false :
	OPTION
	| TRUE
	| FALSE
	;

opt_granted_by :
	/*empty*/
	| GRANTED BY role_spec
	;

revoke_stmt :
	REVOKE privileges_for_cols ON targets_table FROM role_spec_list opt_granted_by opt_drop_behavior
	| REVOKE GRANT OPTION FOR privileges_for_cols ON targets_table FROM role_spec_list opt_granted_by opt_drop_behavior
	| REVOKE privileges ON targets FROM role_spec_list opt_granted_by opt_drop_behavior
	| REVOKE GRANT OPTION FOR privileges ON targets FROM role_spec_list opt_granted_by opt_drop_behavior
	| REVOKE privilege_list FROM role_spec_list opt_granted_by opt_drop_behavior
	| REVOKE admin_inherit_set OPTION FOR privilege_list FROM role_spec_list opt_granted_by opt_drop_behavior
	//| REVOKE error
	;

privileges_for_cols :
	ALL '(' /*31L*/ name_list ')' /*31L*/
	| ALL PRIVILEGES '(' /*31L*/ name_list ')' /*31L*/
	| privilege_for_cols_list
	;

privilege_for_cols_list :
	privilege_for_cols
	| privilege_for_cols_list ',' privilege_for_cols
	;

privilege_for_cols :
	privilege '(' /*31L*/ name_list ')' /*31L*/
	;

privileges :
	ALL
	| ALL PRIVILEGES
	| privilege_list
	;

privilege_list :
	privilege
	| privilege_list ',' privilege
	;

privilege :
	name
	| SELECT
	| REFERENCES
	| CREATE
	| CONNECT
	| ALTER SYSTEM
	;

reset_stmt :
	RESET name
	| RESET TIME ZONE
	| RESET ALL
	| RESET SESSION AUTHORIZATION
	//| RESET error
	;

use_stmt :
	USE use_db_name
	//| USE error
	;

use_db_name :
	SCONST
	| db_object_name_component
	| db_object_name_component '/' /*24L*/ db_object_name_component
	;

set_stmt :
	set_transaction_stmt
	| set_constraints_stmt
	| set_exprs_internal
	| set_session_or_local_stmt
	| use_stmt
	;

scrub_stmt :
	scrub_table_stmt
	| scrub_database_stmt
	//| EXPERIMENTAL SCRUB error
	;

scrub_database_stmt :
	EXPERIMENTAL SCRUB DATABASE database_name opt_as_of_clause
	//| EXPERIMENTAL SCRUB DATABASE error
	;

scrub_table_stmt :
	EXPERIMENTAL SCRUB TABLE table_name opt_as_of_clause opt_scrub_options_clause
	//| EXPERIMENTAL SCRUB TABLE error
	;

opt_scrub_options_clause :
	WITH OPTIONS scrub_option_list
	| /*empty*/
	;

scrub_option_list :
	scrub_option
	| scrub_option_list ',' scrub_option
	;

scrub_option :
	INDEX ALL
	| INDEX '(' /*31L*/ name_list ')' /*31L*/
	| CONSTRAINT ALL
	| CONSTRAINT '(' /*31L*/ name_list ')' /*31L*/
	| PHYSICAL
	;

to_or_eq :
	'=' /*9N*/
	| TO
	;

set_exprs_internal :
	SET /*2N*/ ROW '(' /*31L*/ expr_list ')' /*31L*/
	;

set_transaction_stmt :
	SET /*2N*/ TRANSACTION transaction_mode_list
	| SET /*2N*/ TRANSACTION SNAPSHOT transaction_mode_list
	| SET /*2N*/ SESSION CHARACTERISTICS AS TRANSACTION transaction_mode_list
	;

set_constraints_stmt :
	SET /*2N*/ CONSTRAINTS ALL DEFERRED
	| SET /*2N*/ CONSTRAINTS ALL IMMEDIATE
	| SET /*2N*/ CONSTRAINTS name_list DEFERRED
	| SET /*2N*/ CONSTRAINTS name_list IMMEDIATE
	;

set_session_or_local_stmt :
	SET /*2N*/ set_session_or_local_cmd
	| SET /*2N*/ SESSION set_session_or_local_cmd
	| SET /*2N*/ LOCAL set_session_or_local_cmd
	;

set_session_or_local_cmd :
	set_var
	| set_session_authorization
	| set_role
	;

generic_set_single_config :
	name '.' /*34L*/ name to_or_eq var_list
	| name to_or_eq var_list
	| name FROM CURRENT
	;

var_list :
	var_value
	| var_list ',' var_value
	;

set_var :
	generic_set_single_config
	| TIME ZONE zone_value
	| set_special_syntax
	;

set_special_syntax :
	SCHEMA SCONST
	| set_names
	| SEED numeric_only
	;

set_session_authorization :
	SESSION AUTHORIZATION DEFAULT
	| SESSION AUTHORIZATION non_reserved_word_or_sconst
	;

set_role :
	ROLE non_reserved_word_or_sconst
	;

set_names :
	NAMES SCONST
	| NAMES
	;

var_value :
	a_expr
	| extra_var_value
	;

extra_var_value :
	ON
	| cockroachdb_extra_reserved_keyword
	;

iso_level :
	READ UNCOMMITTED
	| READ COMMITTED
	| SNAPSHOT
	| REPEATABLE READ
	| SERIALIZABLE
	;

user_priority :
	LOW
	| NORMAL
	| HIGH
	;

zone_value :
	SCONST
	| IDENT /*16N*/
	| interval_value
	| numeric_only
	| DEFAULT
	| LOCAL
	;

show_stmt :
	show_backup_stmt
	| show_columns_stmt
	| show_constraints_stmt
	| show_create_stmt
	| show_databases_stmt
	| show_enums_stmt
	| show_types_stmt
	| show_fingerprints_stmt
	| show_grants_stmt
	| show_histogram_stmt
	| show_indexes_stmt
	| show_partitions_stmt
	| show_jobs_stmt
	| show_schedules_stmt
	| show_queries_stmt
	| show_roles_stmt
	| show_savepoint_stmt
	| show_schemas_stmt
	| show_sequences_stmt
	| show_session_stmt
	| show_sessions_stmt
	| show_stats_stmt
	| show_syntax_stmt
	| show_tables_stmt
	| show_trace_stmt
	| show_transaction_stmt
	| show_transactions_stmt
	| show_users_stmt
	//| SHOW error
	| show_last_query_stats_stmt
	;

close_cursor_stmt :
	CLOSE ALL
	| CLOSE cursor_name
	;

declare_cursor_stmt :
	DECLARE
	;

//reindex_stmt :
//	REINDEX TABLE error
//	| REINDEX INDEX error
//	| REINDEX DATABASE error
//	| REINDEX SYSTEM error
//	;

vacuum_stmt :
	VACUUM opt_vacuum_option_list opt_vacuum_table_and_cols_list
	| VACUUM legacy_vacuum_option_list opt_vacuum_table_and_cols_list
	;

opt_vacuum_option_list :
	'(' /*31L*/ vacuum_option_list ')' /*31L*/
	| /*empty*/
	;

vacuum_option_list :
	vacuum_option
	| vacuum_option_list ',' vacuum_option
	;

vacuum_option :
	FULL /*35L*/ boolean_value_for_vacuum_opt
	| FREEZE boolean_value_for_vacuum_opt
	| VERBOSE boolean_value_for_vacuum_opt
	| ANALYZE boolean_value_for_vacuum_opt
	| DISABLE_PAGE_SKIPPING boolean_value_for_vacuum_opt
	| SKIP_LOCKED boolean_value_for_vacuum_opt
	| INDEX_CLEANUP auto_on_off
	| PROCESS_MAIN boolean_value_for_vacuum_opt
	| PROCESS_TOAST boolean_value_for_vacuum_opt
	| TRUNCATE boolean_value_for_vacuum_opt
	| PARALLEL ICONST
	| SKIP_DATABASE_STATS boolean_value_for_vacuum_opt
	| ONLY_DATABASE_STATS boolean_value_for_vacuum_opt
	| BUFFER_USAGE_LIMIT ICONST
	;

boolean_value_for_vacuum_opt :
	/*empty*/
	| boolean_value
	;

auto_on_off :
	AUTO
	| ON
	| OFF
	;

legacy_vacuum_option_list :
	legacy_vacuum_option
	| legacy_vacuum_option_list legacy_vacuum_option
	;

legacy_vacuum_option :
	FULL /*35L*/
	| FREEZE
	| VERBOSE
	| ANALYZE
	;

opt_vacuum_table_and_cols_list :
	/*empty*/
	| vacuum_table_and_cols
	| vacuum_table_and_cols ',' opt_vacuum_table_and_cols_list
	;

vacuum_table_and_cols :
	table_name
	| table_name '(' /*31L*/ name_list ')' /*31L*/
	;

show_session_stmt :
	SHOW session_var
	| SHOW SESSION session_var
	//| SHOW SESSION error
	;

session_var :
	IDENT /*16N*/
	| IDENT /*16N*/ '.' /*34L*/ IDENT /*16N*/
	| ALL
	| DATABASE
	| NAMES
	| SESSION_USER
	| TIME ZONE
	;

show_stats_stmt :
	SHOW STATISTICS FOR TABLE table_name
	| SHOW STATISTICS USING JSON FOR TABLE table_name
	//| SHOW STATISTICS error
	;

show_histogram_stmt :
	SHOW HISTOGRAM ICONST
	//| SHOW HISTOGRAM error
	;

show_backup_stmt :
	SHOW BACKUPS IN /*10N*/ string_or_placeholder
	| SHOW BACKUP string_or_placeholder opt_with_options
	| SHOW BACKUP string_or_placeholder IN /*10N*/ string_or_placeholder opt_with_options
	| SHOW BACKUP SCHEMAS string_or_placeholder opt_with_options
	| SHOW BACKUP RANGES string_or_placeholder opt_with_options
	| SHOW BACKUP FILES string_or_placeholder opt_with_options
	//| SHOW BACKUP error
	;

show_columns_stmt :
	SHOW COLUMNS FROM table_name with_comment
	//| SHOW COLUMNS error
	;

show_partitions_stmt :
	SHOW PARTITIONS FROM TABLE table_name
	| SHOW PARTITIONS FROM DATABASE database_name
	| SHOW PARTITIONS FROM INDEX table_index_name
	| SHOW PARTITIONS FROM INDEX table_name '@' /*22L*/ '*' /*24L*/
	//| SHOW PARTITIONS error
	;

show_databases_stmt :
	SHOW DATABASES with_comment
	//| SHOW DATABASES error
	;

show_enums_stmt :
	SHOW ENUMS
	//| SHOW ENUMS error
	;

show_types_stmt :
	SHOW TYPES
	//| SHOW TYPES error
	;

show_grants_stmt :
	SHOW GRANTS opt_on_targets_roles for_grantee_clause
	//| SHOW GRANTS error
	;

show_indexes_stmt :
	SHOW INDEX FROM table_name with_comment
	//| SHOW INDEX error
	| SHOW INDEX FROM DATABASE database_name with_comment
	| SHOW INDEXES FROM table_name with_comment
	| SHOW INDEXES FROM DATABASE database_name with_comment
	//| SHOW INDEXES error
	| SHOW KEYS FROM table_name with_comment
	| SHOW KEYS FROM DATABASE database_name with_comment
	//| SHOW KEYS error
	;

show_constraints_stmt :
	SHOW CONSTRAINT FROM table_name
	//| SHOW CONSTRAINT error
	| SHOW CONSTRAINTS FROM table_name
	//| SHOW CONSTRAINTS error
	;

show_queries_stmt :
	SHOW opt_cluster QUERIES
	//| SHOW opt_cluster QUERIES error
	| SHOW ALL opt_cluster QUERIES
	//| SHOW ALL opt_cluster QUERIES error
	;

opt_cluster :
	/*empty*/
	| CLUSTER
	| LOCAL
	;

show_jobs_stmt :
	SHOW AUTOMATIC JOBS
	| SHOW JOBS
	//| SHOW AUTOMATIC JOBS error
	//| SHOW JOBS error
	| SHOW JOBS select_stmt
	| SHOW JOBS WHEN COMPLETE select_stmt
	| SHOW JOBS for_schedules_clause
	//| SHOW JOBS select_stmt error
	| SHOW JOB a_expr
	| SHOW JOB WHEN COMPLETE a_expr
	//| SHOW JOB error
	;

show_schedules_stmt :
	SHOW SCHEDULES opt_schedule_executor_type
	//| SHOW SCHEDULES opt_schedule_executor_type error
	| SHOW schedule_state SCHEDULES opt_schedule_executor_type
	//| SHOW schedule_state SCHEDULES opt_schedule_executor_type error
	| SHOW SCHEDULE a_expr
	//| SHOW SCHEDULE error
	;

schedule_state :
	RUNNING
	| PAUSED
	;

opt_schedule_executor_type :
	/*empty*/
	| FOR BACKUP
	;

show_trace_stmt :
	SHOW opt_compact TRACE FOR SESSION
	//| SHOW opt_compact TRACE error
	| SHOW opt_compact KV TRACE FOR SESSION
	//| SHOW opt_compact KV error
	| SHOW opt_compact EXPERIMENTAL_REPLICA TRACE FOR SESSION
	//| SHOW opt_compact EXPERIMENTAL_REPLICA error
	;

opt_compact :
	COMPACT
	| /*empty*/
	;

show_sessions_stmt :
	SHOW opt_cluster SESSIONS
	//| SHOW opt_cluster SESSIONS error
	| SHOW ALL opt_cluster SESSIONS
	//| SHOW ALL opt_cluster SESSIONS error
	;

show_tables_stmt :
	SHOW TABLES FROM name '.' /*34L*/ name with_comment
	| SHOW TABLES FROM name with_comment
	| SHOW TABLES with_comment
	//| SHOW TABLES error
	;

show_transactions_stmt :
	SHOW opt_cluster TRANSACTIONS
	//| SHOW opt_cluster TRANSACTIONS error
	| SHOW ALL opt_cluster TRANSACTIONS
	//| SHOW ALL opt_cluster TRANSACTIONS error
	;

with_comment :
	WITH COMMENT
	| /*empty*/
	;

show_schemas_stmt :
	SHOW SCHEMAS FROM name
	| SHOW SCHEMAS
	//| SHOW SCHEMAS error
	;

show_sequences_stmt :
	SHOW SEQUENCES FROM name
	| SHOW SEQUENCES
	//| SHOW SEQUENCES error
	;

show_syntax_stmt :
	SHOW SYNTAX SCONST
	//| SHOW SYNTAX error
	;

show_last_query_stats_stmt :
	SHOW LAST QUERY STATISTICS
	;

show_savepoint_stmt :
	SHOW SAVEPOINT STATUS
	//| SHOW SAVEPOINT error
	;

show_transaction_stmt :
	SHOW TRANSACTION ISOLATION LEVEL
	| SHOW TRANSACTION PRIORITY
	| SHOW TRANSACTION STATUS
	//| SHOW TRANSACTION error
	;

show_create_stmt :
	SHOW CREATE table_name
	| SHOW CREATE create_kw table_name
	//| SHOW CREATE error
	;

create_kw :
	TABLE
	| VIEW
	| SEQUENCE
	;

show_users_stmt :
	SHOW USERS
	//| SHOW USERS error
	;

show_roles_stmt :
	SHOW ROLES
	//| SHOW ROLES error
	;

show_fingerprints_stmt :
	SHOW EXPERIMENTAL_FINGERPRINTS FROM TABLE table_name
	;

opt_on_targets_roles :
	ON targets_roles
	| /*empty*/
	;

targets_table :
	IDENT /*16N*/
	| col_name_keyword
	| unreserved_keyword
	| complex_table_pattern
	| table_pattern ',' table_pattern_list
	| TABLE table_pattern_list
	;

targets_roles :
	ROLE name_list
	| targets_table
	;

for_grantee_clause :
	FOR name_list
	| /*empty*/
	;

pause_stmt :
	pause_jobs_stmt
	| pause_schedules_stmt
	//| PAUSE error
	;

resume_stmt :
	resume_jobs_stmt
	| resume_schedules_stmt
	//| RESUME error
	;

pause_jobs_stmt :
	PAUSE JOB a_expr
	//| PAUSE JOB error
	| PAUSE JOBS select_stmt
	| PAUSE JOBS for_schedules_clause
	//| PAUSE JOBS error
	;

for_schedules_clause :
	FOR SCHEDULES select_stmt
	| FOR SCHEDULE a_expr
	;

pause_schedules_stmt :
	PAUSE SCHEDULE a_expr
	//| PAUSE SCHEDULE error
	| PAUSE SCHEDULES select_stmt
	//| PAUSE SCHEDULES error
	;

create_schema_stmt :
	CREATE SCHEMA schema_name opt_schema_element_list
	| CREATE SCHEMA opt_schema_name AUTHORIZATION role_spec opt_schema_element_list
	| CREATE SCHEMA IF NOT /*7R*/ EXISTS schema_name
	| CREATE SCHEMA IF NOT /*7R*/ EXISTS opt_schema_name AUTHORIZATION role_spec
	//| CREATE SCHEMA error
	;

opt_schema_element_list :
	/*empty*/
	| schema_element_list
	;

schema_element_list :
	schema_element
	| schema_element_list schema_element
	;

schema_element :
	create_ddl_stmt_schema_element
	| grant_stmt
	;

alter_schema_stmt :
	ALTER SCHEMA schema_name RENAME TO schema_name
	| ALTER SCHEMA schema_name owner_to
	//| ALTER SCHEMA error
	;

create_table_stmt :
	CREATE opt_persistence_temp_table TABLE table_name '(' /*31L*/ opt_table_elem_list ')' /*31L*/ opt_inherits opt_partition_by opt_using_method opt_table_with opt_create_table_on_commit opt_tablespace
	| CREATE opt_persistence_temp_table TABLE IF NOT /*7R*/ EXISTS table_name '(' /*31L*/ opt_table_elem_list ')' /*31L*/ opt_inherits opt_partition_by opt_using_method opt_table_with opt_create_table_on_commit opt_tablespace
	| CREATE opt_persistence_temp_table TABLE table_name OF type_name opt_table_of_elem_list opt_partition_by opt_using_method opt_table_with opt_create_table_on_commit opt_tablespace
	| CREATE opt_persistence_temp_table TABLE IF NOT /*7R*/ EXISTS table_name OF type_name opt_table_of_elem_list opt_partition_by opt_using_method opt_table_with opt_create_table_on_commit opt_tablespace
	| CREATE opt_persistence_temp_table TABLE table_name PARTITION /*16N*/ OF table_name opt_table_of_elem_list partition_of opt_partition_by opt_using_method opt_table_with opt_create_table_on_commit opt_tablespace
	| CREATE opt_persistence_temp_table TABLE IF NOT /*7R*/ EXISTS table_name PARTITION /*16N*/ OF table_name opt_table_of_elem_list partition_of opt_partition_by opt_using_method opt_table_with opt_create_table_on_commit opt_tablespace
	;

partition_of :
	FOR VALUES /*1N*/ partition_bound_spec
	| DEFAULT
	;

partition_bound_spec :
	IN /*10N*/ '(' /*31L*/ partition_bound_expr_list ')' /*31L*/
	| FROM '(' /*31L*/ partition_bound_expr_list ')' /*31L*/ TO '(' /*31L*/ partition_bound_expr_list ')' /*31L*/
	| WITH '(' /*31L*/ MODULUS ICONST ',' REMAINDER ICONST ')' /*31L*/
	;

partition_bound_expr_list :
	partition_bound_expr
	| partition_bound_expr_list ',' partition_bound_expr
	;

partition_bound_expr :
	a_expr
	;

opt_table_of_elem_list :
	'(' /*31L*/ table_of_elem_list ')' /*31L*/
	| /*empty*/
	;

table_of_elem_list :
	table_of_elem
	| table_of_elem_list ',' table_of_elem
	;

table_of_elem :
	column_name opt_col_with_options col_constraint_list
	| table_constraint
	;

opt_col_with_options :
	/*empty*/
	| WITH OPTIONS
	;

opt_inherits :
	/*empty*/
	| INHERITS '(' /*31L*/ table_name_list ')' /*31L*/
	;

opt_table_with :
	opt_with_storage_parameter_list
	| WITHOUT OIDS
	//| WITH OIDS error
	;

opt_with_storage_parameter_list :
	/*empty*/
	| WITH '(' /*31L*/ storage_parameter_list ')' /*31L*/
	;

opt_create_table_on_commit :
	/*empty*/
	| ON COMMIT PRESERVE ROWS /*16N*/
	//| ON COMMIT DELETE ROWS /*16N*/ error
	//| ON COMMIT DROP error
	;

storage_parameter :
	name opt_var_value
	| SCONST opt_var_value
	;

opt_var_value :
	/*empty*/
	| '=' /*9N*/ var_value
	;

storage_parameter_list :
	storage_parameter
	| storage_parameter_list ',' storage_parameter
	;

create_table_as_stmt :
	CREATE opt_persistence_temp_table TABLE table_name opt_index_params_name_only opt_using_method opt_table_with opt_create_table_on_commit opt_tablespace AS select_stmt opt_create_as_with_data
	| CREATE opt_persistence_temp_table TABLE IF NOT /*7R*/ EXISTS table_name opt_index_params_name_only opt_using_method opt_table_with opt_create_table_on_commit opt_tablespace AS select_stmt opt_create_as_with_data
	;

opt_create_as_with_data :
	/*empty*/
	| WITH DATA
	| WITH NO DATA
	;

opt_temp :
	TEMPORARY
	| TEMP
	| /*empty*/
	;

opt_persistence_sequence :
	opt_temp
	| UNLOGGED
	;

opt_persistence_temp_table :
	opt_persistence_sequence
	| LOCAL TEMPORARY
	| LOCAL TEMP
	| GLOBAL TEMPORARY
	| GLOBAL TEMP
	;

opt_table_elem_list :
	table_elem_list
	| /*empty*/
	;

table_elem_list :
	table_elem
	| table_elem_list ',' table_elem
	;

table_elem :
	create_table_column_def
	| table_constraint
	| LIKE /*10N*/ table_name like_table_option_list
	;

like_table_option_list :
	like_table_option_list INCLUDING like_table_option
	| like_table_option_list EXCLUDING like_table_option
	| /*empty*/
	;

like_table_option :
	COMMENTS
	| CONSTRAINTS
	| DEFAULTS
	| IDENTITY
	| GENERATED
	| INDEXES
	| STATISTICS
	| STORAGE
	| ALL
	;

opt_partition_by :
	partition_by
	| /*empty*/
	;

partition_by :
	PARTITION /*16N*/ BY partition_by_type '(' /*31L*/ partition_index_params ')' /*31L*/
	;

partition_by_type :
	LIST
	| RANGE /*16N*/
	| HASH
	;

partition_index_params :
	partition_index_elem
	| partition_index_params ',' partition_index_elem
	;

partition_index_elem :
	name opt_collate opt_opclass
	| '(' /*31L*/ a_expr ')' /*31L*/ opt_collate opt_opclass
	;

alter_column_def :
	column_name typename opt_collate col_constraint_list
	;

create_table_column_def :
	column_name typename opt_compression opt_collate col_constraint_list
	;

opt_compression :
	/*empty*/
	| COMPRESSION unrestricted_name
	;

col_constraint_list :
	col_constraint_list col_qualification
	| /*empty*/
	;

col_qualification :
	CONSTRAINT constraint_name col_qualification_elem opt_deferrable_mode opt_initially
	| col_qualification_elem opt_deferrable_mode opt_initially
	;

col_qualification_elem :
	NOT /*7R*/ NULL /*16N*/
	| NULL /*16N*/
	| CHECK '(' /*31L*/ a_expr ')' /*31L*/ opt_no_inherit
	| DEFAULT b_expr
	| GENERATED_ALWAYS ALWAYS AS '(' /*31L*/ a_expr ')' /*31L*/ STORED
	| col_qual_generated_identity
	| UNIQUE opt_nulls_distinct constraint_index_params
	| PRIMARY KEY constraint_index_params
	| REFERENCES table_name opt_name_parens key_match reference_actions
	;

col_qual_generated_identity :
	GENERATED_ALWAYS ALWAYS AS IDENTITY opt_create_seq_option_list_with_parens
	| GENERATED BY DEFAULT AS IDENTITY opt_create_seq_option_list_with_parens
	;

opt_include_index_cols :
	/*empty*/
	| INCLUDE '(' /*31L*/ index_params_name_only ')' /*31L*/
	;

opt_using_index_tablespace :
	/*empty*/
	| USING INDEX TABLESPACE tablespace_name
	;

opt_create_seq_option_list_with_parens :
	'(' /*31L*/ create_seq_option_list ')' /*31L*/
	| /*empty*/
	;

opt_no_inherit :
	/*empty*/
	| NO INHERIT
	;

table_constraint :
	CONSTRAINT constraint_name table_constraint_elem opt_deferrable_mode opt_initially
	| table_constraint_elem opt_deferrable_mode opt_initially
	;

table_constraint_elem :
	CHECK '(' /*31L*/ a_expr ')' /*31L*/ opt_no_inherit
	| UNIQUE opt_nulls_distinct '(' /*31L*/ index_params ')' /*31L*/ constraint_index_params
	| PRIMARY KEY '(' /*31L*/ index_params ')' /*31L*/ constraint_index_params
	| EXCLUDE opt_using_method '(' /*31L*/ exclude_elems ')' /*31L*/ constraint_index_params opt_where_clause_paren
	| FOREIGN KEY '(' /*31L*/ name_list ')' /*31L*/ REFERENCES table_name opt_column_list key_match reference_actions
	;

exclude_elems :
	index_elem WITH math_op
	| exclude_elems ',' index_elem WITH math_op
	;

opt_index_params_name_only :
	/*empty*/
	| '(' /*31L*/ index_params_name_only ')' /*31L*/
	;

index_params_name_only :
	index_elem_name_only
	| index_params_name_only ',' index_elem_name_only
	;

index_elem_name_only :
	column_name
	;

constraint_index_params :
	opt_include_index_cols opt_with_storage_parameter_list opt_using_index_tablespace
	;

opt_deferrable_mode :
	/*empty*/
	| deferrable_mode
	;

opt_initially :
	/*empty*/
	| INITIALLY DEFERRED
	| INITIALLY IMMEDIATE
	;

opt_column_list :
	'(' /*31L*/ name_list ')' /*31L*/
	| /*empty*/
	;

opt_only :
	/*empty*/
	| ONLY
	;

opt_nulls_distinct :
	NULLS opt_not DISTINCT
	| /*empty*/
	;

key_match :
	MATCH SIMPLE
	| MATCH FULL /*35L*/
	| MATCH PARTIAL
	| /*empty*/
	;

reference_actions :
	reference_on_update
	| reference_on_delete
	| reference_on_update reference_on_delete
	| reference_on_delete reference_on_update
	| /*empty*/
	;

reference_on_update :
	ON UPDATE reference_action
	;

reference_on_delete :
	ON DELETE reference_action
	;

reference_action :
	NO ACTION
	| RESTRICT
	| CASCADE
	| SET /*2N*/ NULL /*16N*/ opt_column_list
	| SET /*2N*/ DEFAULT opt_column_list
	;

create_sequence_stmt :
	CREATE opt_persistence_sequence SEQUENCE sequence_name opt_create_seq_option_list
	| CREATE opt_persistence_sequence SEQUENCE IF NOT /*7R*/ EXISTS sequence_name opt_create_seq_option_list
	;

opt_create_seq_option_list :
	create_seq_option_list
	| /*empty*/
	;

create_seq_option_list :
	create_seq_option_elem
	| create_seq_option_list create_seq_option_elem
	;

create_seq_option_elem :
	seq_as_type
	| seq_increment
	| seq_minvalue
	| seq_maxvalue
	| seq_start
	| seq_cache
	| seq_cycle
	| seq_owned_by
	;

opt_alter_seq_option_list :
	alter_seq_option_list
	| /*empty*/
	;

alter_seq_option_list :
	alter_seq_option_elem
	| alter_seq_option_list alter_seq_option_elem
	;

alter_seq_option_elem :
	create_seq_option_elem
	| seq_restart
	;

seq_as_type :
	AS typename
	;

seq_increment :
	INCREMENT signed_iconst64
	| INCREMENT BY signed_iconst64
	;

seq_minvalue :
	MINVALUE signed_iconst64
	| NO MINVALUE
	;

seq_maxvalue :
	MAXVALUE signed_iconst64
	| NO MAXVALUE
	;

seq_start :
	START opt_with signed_iconst64
	;

seq_cache :
	CACHE signed_iconst64
	;

seq_cycle :
	CYCLE
	| NO CYCLE
	;

seq_owned_by :
	OWNED BY column_path
	| OWNED BY NONE
	;

seq_restart :
	RESTART
	| RESTART opt_with signed_iconst64
	;

truncate_stmt :
	TRUNCATE opt_table relation_expr_list opt_drop_behavior
	//| TRUNCATE error
	;

password_clause :
	PASSWORD non_reserved_word_or_sconst
	| ENCRYPTED PASSWORD non_reserved_word_or_sconst
	| PASSWORD NULL /*16N*/
	;

create_trigger_stmt :
	CREATE opt_constraint TRIGGER trigger_name trigger_time trigger_events ON table_name opt_from_ref_table opt_trigger_deferrable_mode opt_trigger_relations opt_for_each opt_when EXECUTE function_or_procedure routine_name '(' /*31L*/ opt_name_list ')' /*31L*/
	| CREATE OR /*5L*/ REPLACE opt_constraint TRIGGER trigger_name trigger_time trigger_events ON table_name opt_from_ref_table opt_trigger_deferrable_mode opt_trigger_relations opt_for_each opt_when EXECUTE function_or_procedure routine_name '(' /*31L*/ opt_name_list ')' /*31L*/
	;

function_or_procedure :
	FUNCTION
	| PROCEDURE
	;

opt_when :
	/*empty*/
	| WHEN '(' /*31L*/ a_expr ')' /*31L*/
	;

opt_for_each :
	/*empty*/
	| FOR opt_each ROW
	| FOR opt_each STATEMENT
	;

opt_each :
	/*empty*/
	| EACH
	;

opt_trigger_relations :
	/*empty*/
	| REFERENCING trigger_relations
	;

trigger_relations :
	old_or_new TABLE opt_as name
	| trigger_relations old_or_new TABLE opt_as name
	;

old_or_new :
	OLD
	| NEW
	;

opt_as :
	/*empty*/
	| AS
	;

opt_trigger_deferrable_mode :
	/*empty*/
	| DEFERRABLE /*10N*/
	| INITIALLY IMMEDIATE
	| INITIALLY DEFERRED
	| NOT_LA /*10N*/ DEFERRABLE /*10N*/
	| DEFERRABLE /*10N*/ INITIALLY IMMEDIATE
	| DEFERRABLE /*10N*/ INITIALLY DEFERRED
	;

opt_from_ref_table :
	/*empty*/
	| FROM name
	;

trigger_events :
	trigger_event
	| trigger_events OR /*5L*/ trigger_event
	;

trigger_event :
	INSERT
	| UPDATE opt_of_cols
	| DELETE
	| TRUNCATE
	;

opt_of_cols :
	/*empty*/
	| OF name_list
	;

trigger_time :
	BEFORE
	| AFTER
	| INSTEAD OF
	;

opt_constraint :
	/*empty*/
	| CONSTRAINT
	;

create_role_stmt :
	CREATE role_or_group_or_user non_reserved_word_or_sconst opt_role_options
	| CREATE role_or_group_or_user IF NOT /*7R*/ EXISTS non_reserved_word_or_sconst opt_role_options
	//| CREATE role_or_group_or_user error
	;

alter_role_stmt :
	ALTER role_or_group_or_user non_reserved_word_or_sconst opt_role_options
	| ALTER role_or_group_or_user IF EXISTS non_reserved_word_or_sconst opt_role_options
	//| ALTER role_or_group_or_user error
	;

role_or_group_or_user :
	role_or_user
	| GROUP
	;

role_or_user :
	ROLE
	| USER
	;

create_view_stmt :
	CREATE opt_temp opt_view_recursive VIEW view_name opt_column_list opt_with_view_options AS select_stmt opt_with_check_option
	| CREATE OR /*5L*/ REPLACE opt_temp opt_view_recursive VIEW view_name opt_column_list opt_with_view_options AS select_stmt opt_with_check_option
	;

opt_with_check_option :
	/*empty*/
	| WITH CHECK OPTION
	| WITH CASCADED CHECK OPTION
	| WITH LOCAL CHECK OPTION
	;

opt_with_view_options :
	/*empty*/
	| WITH '(' /*31L*/ view_options ')' /*31L*/
	;

view_options :
	view_option
	| view_options ',' view_option
	;

view_option :
	CHECK_OPTION
	| CHECK_OPTION '=' /*9N*/ SCONST
	| SECURITY_BARRIER
	| SECURITY_BARRIER '=' /*9N*/ TRUE
	| SECURITY_BARRIER '=' /*9N*/ FALSE
	| SECURITY_INVOKER
	| SECURITY_INVOKER '=' /*9N*/ TRUE
	| SECURITY_INVOKER '=' /*9N*/ FALSE
	;

create_materialized_view_stmt :
	CREATE MATERIALIZED VIEW view_name opt_column_list opt_using_method opt_with_storage_parameter_list opt_tablespace AS select_stmt opt_create_as_with_data
	| CREATE MATERIALIZED VIEW IF NOT /*7R*/ EXISTS view_name opt_column_list opt_using_method opt_with_storage_parameter_list opt_tablespace AS select_stmt opt_create_as_with_data
	;

role_option :
	SUPERUSER
	| NOSUPERUSER
	| CREATEDB
	| NOCREATEDB
	| CREATEROLE
	| NOCREATEROLE
	| INHERIT
	| NOINHERIT
	| LOGIN
	| NOLOGIN
	| REPLICATION
	| NOREPLICATION
	| BYPASSRLS
	| NOBYPASSRLS
	| CONNECTION LIMIT signed_iconst32
	| SYSID ICONST
	| password_clause
	| valid_until_clause
	;

role_options :
	role_option
	| role_options role_option
	;

opt_role_options :
	opt_with role_options
	| /*empty*/
	;

valid_until_clause :
	VALID UNTIL non_reserved_word_or_sconst
	| VALID UNTIL NULL /*16N*/
	;

opt_view_recursive :
	/*empty*/
	| RECURSIVE
	;

create_type_stmt :
	CREATE TYPE type_name AS '(' /*31L*/ opt_type_composite_list ')' /*31L*/
	| CREATE TYPE type_name AS ENUM '(' /*31L*/ opt_enum_val_list ')' /*31L*/
	| CREATE TYPE type_name AS RANGE /*16N*/ '(' /*31L*/ SUBTYPE '=' /*9N*/ typename type_range_optional_list ')' /*31L*/
	| CREATE TYPE type_name '(' /*31L*/ INPUT '=' /*9N*/ name ',' OUTPUT '=' /*9N*/ name type_base_optional_list ')' /*31L*/
	| CREATE TYPE type_name
	;

opt_type_composite_list :
	/*empty*/
	| type_composite_list
	;

type_composite_list :
	name typename opt_collate
	| type_composite_list ',' name typename opt_collate
	;

type_range_optional_list :
	/*empty*/
	| type_range_option
	| type_range_optional_list ',' type_range_option
	;

type_range_option :
	SUBTYPE_OPCLASS '=' /*9N*/ name
	| COLLATION '=' /*9N*/ collation_name
	| CANONICAL '=' /*9N*/ name
	| SUBTYPE_DIFF '=' /*9N*/ name
	| MULTIRANGE_TYPE_NAME '=' /*9N*/ type_name
	;

type_base_optional_list :
	/*empty*/
	| type_base_option
	| type_base_optional_list ',' type_base_option
	;

type_base_option :
	type_property
	| INTERNALLENGTH '=' /*9N*/ signed_iconst64
	| INTERNALLENGTH '=' /*9N*/ VARIABLE
	| PASSEDBYVALUE
	| ALIGNMENT '=' /*9N*/ name
	| LIKE /*10N*/ '=' /*9N*/ typename
	| CATEGORY '=' /*9N*/ name
	| PREFERRED '=' /*9N*/ TRUE
	| PREFERRED '=' /*9N*/ FALSE
	| DEFAULT '=' /*9N*/ a_expr
	| ELEMENT '=' /*9N*/ typename
	| DELIMITER '=' /*9N*/ non_reserved_word_or_sconst
	| COLLATABLE '=' /*9N*/ TRUE
	| COLLATABLE '=' /*9N*/ FALSE
	;

type_property :
	RECEIVE '=' /*9N*/ name
	| SEND '=' /*9N*/ name
	| TYPMOD_IN '=' /*9N*/ name
	| TYPMOD_OUT '=' /*9N*/ name
	| ANALYZE '=' /*9N*/ name
	| SUBSCRIPT '=' /*9N*/ name
	| STORAGE '=' /*9N*/ name
	;

opt_enum_val_list :
	enum_val_list
	| /*empty*/
	;

enum_val_list :
	SCONST
	| enum_val_list ',' SCONST
	;

create_index_stmt :
	CREATE opt_unique INDEX opt_concurrently opt_index_name ON opt_only table_name opt_using_method '(' /*31L*/ index_params ')' /*31L*/ opt_include_index_cols opt_nulls_distinct opt_with_storage_parameter_list opt_tablespace opt_where_clause
	| CREATE opt_unique INDEX opt_concurrently IF NOT /*7R*/ EXISTS index_name ON opt_only table_name opt_using_method '(' /*31L*/ index_params ')' /*31L*/ opt_include_index_cols opt_nulls_distinct opt_with_storage_parameter_list opt_tablespace opt_where_clause
	//| CREATE opt_unique INDEX error
	;

opt_using_method :
	USING name
	| /*empty*/
	;

opt_concurrently :
	CONCURRENTLY
	| /*empty*/
	;

opt_unique :
	UNIQUE
	| /*empty*/
	;

index_params :
	index_elem
	| index_params ',' index_elem
	;

index_elem :
	name opt_collate opt_opclass opt_asc_desc opt_nulls_order
	| '(' /*31L*/ a_expr ')' /*31L*/ opt_collate opt_opclass opt_asc_desc opt_nulls_order
	;

opt_opclass :
	/*empty*/
	| IDENT /*16N*/
	| IDENT /*16N*/ '(' /*31L*/ opclass_option_list ')' /*31L*/
	;

opclass_option_list :
	name '=' /*9N*/ a_expr
	| opclass_option_list ',' name '=' /*9N*/ a_expr
	;

opt_collate :
	COLLATE /*28L*/ collation_name
	| /*empty*/
	;

opt_asc_desc :
	ASC
	| DESC
	| /*empty*/
	;

alter_database_to_schema_stmt :
	ALTER DATABASE database_name CONVERT TO SCHEMA WITH PARENT database_name
	;

alter_rename_database_stmt :
	ALTER DATABASE database_name RENAME TO database_name
	;

alter_rename_table_stmt :
	ALTER TABLE relation_expr RENAME TO table_name
	| ALTER TABLE IF EXISTS relation_expr RENAME TO table_name
	;

alter_table_set_schema_stmt :
	ALTER TABLE relation_expr set_schema
	| ALTER TABLE IF EXISTS relation_expr set_schema
	;

alter_table_all_in_tablespace_stmt :
	ALTER TABLE ALL IN /*10N*/ TABLESPACE tablespace_name opt_owned_by_list set_tablespace opt_nowait
	;

alter_table_parition_stmt :
	ALTER TABLE table_name ATTACH PARTITION /*16N*/ partition_name partition_of
	| ALTER TABLE IF EXISTS table_name ATTACH PARTITION /*16N*/ partition_name partition_of
	| ALTER TABLE table_name DETACH PARTITION /*16N*/ partition_name detach_partition_type
	| ALTER TABLE IF EXISTS table_name DETACH PARTITION /*16N*/ partition_name detach_partition_type
	;

opt_nowait :
	/*empty*/
	| NOWAIT
	;

detach_partition_type :
	/*empty*/
	| CONCURRENTLY
	| FINALIZE
	;

alter_sequence_set_schema_stmt :
	ALTER SEQUENCE relation_expr set_schema
	| ALTER SEQUENCE IF EXISTS relation_expr set_schema
	;

alter_materialized_view_stmt :
	ALTER MATERIALIZED VIEW relation_expr alter_materialized_view_cmd
	| ALTER MATERIALIZED VIEW IF EXISTS relation_expr alter_materialized_view_cmd
	| ALTER MATERIALIZED VIEW table_name opt_no DEPENDS ON EXTENSION name
	| alter_materialized_view_rename_stmt
	| alter_materialized_view_set_schema_stmt
	| alter_materialized_view_all_in_tablespace_stmt
	;

alter_materialized_view_cmd :
	alter_materialized_view_actions
	| RENAME opt_column column_name TO column_name
	;

alter_materialized_view_rename_stmt :
	ALTER MATERIALIZED VIEW relation_expr RENAME TO view_name
	| ALTER MATERIALIZED VIEW IF EXISTS relation_expr RENAME TO view_name
	;

alter_materialized_view_set_schema_stmt :
	ALTER MATERIALIZED VIEW relation_expr set_schema
	| ALTER MATERIALIZED VIEW IF EXISTS relation_expr set_schema
	;

alter_materialized_view_all_in_tablespace_stmt :
	ALTER MATERIALIZED VIEW ALL IN /*10N*/ TABLESPACE tablespace_name opt_owned_by_list set_tablespace opt_nowait
	;

alter_rename_sequence_stmt :
	ALTER SEQUENCE relation_expr RENAME TO sequence_name
	| ALTER SEQUENCE IF EXISTS relation_expr RENAME TO sequence_name
	;

alter_rename_index_stmt :
	ALTER INDEX table_index_name RENAME TO index_name
	| ALTER INDEX IF EXISTS table_index_name RENAME TO index_name
	;

opt_column :
	COLUMN
	| /*empty*/
	;

opt_set_data :
	SET /*2N*/ DATA
	| /*empty*/
	;

release_stmt :
	RELEASE savepoint_name
	//| RELEASE error
	;

resume_jobs_stmt :
	RESUME JOB a_expr
	//| RESUME JOB error
	| RESUME JOBS select_stmt
	| RESUME JOBS for_schedules_clause
	//| RESUME JOBS error
	;

resume_schedules_stmt :
	RESUME SCHEDULE a_expr
	//| RESUME SCHEDULE error
	| RESUME SCHEDULES select_stmt
	//| RESUME SCHEDULES error
	;

drop_schedule_stmt :
	DROP SCHEDULE a_expr
	//| DROP SCHEDULE error
	| DROP SCHEDULES select_stmt
	//| DROP SCHEDULES error
	;

savepoint_stmt :
	SAVEPOINT name
	//| SAVEPOINT error
	;

transaction_stmt :
	begin_stmt
	| commit_stmt
	| rollback_stmt
	| abort_stmt
	;

begin_stmt :
	BEGIN opt_work_transaction begin_transaction
	//| BEGIN error
	| START TRANSACTION begin_transaction
	//| START error
	;

commit_stmt :
	COMMIT opt_transaction_chain
	//| COMMIT error
	| END opt_transaction_chain
	//| END error
	;

abort_stmt :
	ABORT opt_transaction_chain
	;

opt_transaction_chain :
	opt_work_transaction opt_chain
	;

opt_chain :
	/*empty*/
	| AND /*6L*/ CHAIN
	| AND /*6L*/ NO CHAIN
	;

rollback_stmt :
	ROLLBACK opt_transaction_chain
	| ROLLBACK opt_work_transaction TO savepoint_name
	//| ROLLBACK error
	;

opt_work_transaction :
	TRANSACTION
	| WORK
	| /*empty*/
	;

savepoint_name :
	SAVEPOINT name
	| name
	;

begin_transaction :
	transaction_mode_list
	| /*empty*/
	;

transaction_mode_list :
	transaction_mode
	| transaction_mode_list ',' transaction_mode
	;

transaction_mode :
	transaction_iso_level
	| transaction_user_priority
	| transaction_read_mode
	| as_of_clause
	| deferrable_mode
	;

transaction_user_priority :
	PRIORITY user_priority
	;

transaction_iso_level :
	ISOLATION LEVEL iso_level
	;

transaction_read_mode :
	READ ONLY
	| READ WRITE
	;

deferrable_mode :
	DEFERRABLE /*10N*/
	| NOT_LA /*10N*/ DEFERRABLE /*10N*/
	;

create_database_stmt :
	CREATE DATABASE database_name opt_with opt_owner opt_template opt_encoding opt_strategy opt_locale opt_lc_collate opt_lc_ctype opt_icu_locale opt_icu_rules opt_locale_provider opt_collation_version opt_tablespace opt_allow_connections opt_connection_limit opt_is_template opt_oid
	| CREATE DATABASE IF NOT /*7R*/ EXISTS database_name opt_with opt_owner opt_template opt_encoding opt_strategy opt_locale opt_lc_collate opt_lc_ctype opt_icu_locale opt_icu_rules opt_locale_provider opt_collation_version opt_tablespace opt_allow_connections opt_connection_limit opt_is_template opt_oid
	//| CREATE DATABASE error
	;

opt_owner :
	OWNER opt_equal role_spec
	| /*empty*/
	;

opt_template :
	TEMPLATE opt_equal non_reserved_word_or_sconst
	| /*empty*/
	;

opt_encoding :
	ENCODING opt_equal non_reserved_word_or_sconst
	| /*empty*/
	;

opt_strategy :
	STRATEGY opt_equal non_reserved_word_or_sconst
	| /*empty*/
	;

opt_locale :
	LOCALE opt_equal non_reserved_word_or_sconst
	| /*empty*/
	;

opt_lc_collate :
	LC_COLLATE opt_equal non_reserved_word_or_sconst
	| /*empty*/
	;

opt_lc_ctype :
	LC_CTYPE opt_equal non_reserved_word_or_sconst
	| /*empty*/
	;

opt_icu_locale :
	ICU_LOCALE opt_equal non_reserved_word_or_sconst
	| /*empty*/
	;

opt_icu_rules :
	ICU_RULES opt_equal non_reserved_word_or_sconst
	| /*empty*/
	;

opt_locale_provider :
	LOCALE_PROVIDER opt_equal non_reserved_word_or_sconst
	| /*empty*/
	;

opt_collation_version :
	COLLATION_VERSION opt_equal non_reserved_word_or_sconst
	| /*empty*/
	;

opt_tablespace :
	TABLESPACE opt_equal tablespace_name
	| /*empty*/
	;

opt_allow_connections :
	ALLOW_CONNECTIONS opt_equal a_expr
	| /*empty*/
	;

opt_connection_limit :
	CONNECTION LIMIT opt_equal signed_iconst
	| /*empty*/
	;

opt_is_template :
	IS_TEMPLATE opt_equal a_expr
	| /*empty*/
	;

opt_oid :
	OID opt_equal signed_iconst
	| /*empty*/
	;

opt_equal :
	'=' /*9N*/
	| /*empty*/
	;

insert_stmt :
	opt_with_clause INSERT INTO insert_target insert_rest returning_clause
	| opt_with_clause INSERT INTO insert_target insert_rest on_conflict returning_clause
	//| opt_with_clause INSERT error
	;

upsert_stmt :
	opt_with_clause UPSERT INTO insert_target insert_rest returning_clause
	//| opt_with_clause UPSERT error
	;

insert_target :
	table_name
	| table_name AS table_alias_name
	| numeric_table_ref
	;

insert_rest :
	select_stmt
	| '(' /*31L*/ insert_column_list ')' /*31L*/ select_stmt
	| DEFAULT VALUES /*1N*/
	;

insert_column_list :
	insert_column_item
	| insert_column_list ',' insert_column_item
	;

insert_column_item :
	column_name
	//| column_name '.' /*34L*/ error
	;

on_conflict :
	ON CONFLICT DO NOTHING
	| ON CONFLICT '(' /*31L*/ name_list ')' /*31L*/ opt_where_clause DO NOTHING
	| ON CONFLICT '(' /*31L*/ name_list ')' /*31L*/ opt_where_clause DO UPDATE SET /*2N*/ set_clause_list opt_where_clause
	| ON CONFLICT ON CONSTRAINT constraint_name
	;

returning_clause :
	RETURNING target_list
	| RETURNING NOTHING
	| /*empty*/
	;

update_stmt :
	opt_with_clause UPDATE table_expr_opt_alias_idx SET /*2N*/ set_clause_list opt_from_list opt_where_clause opt_sort_clause opt_limit_clause returning_clause
	//| opt_with_clause UPDATE error
	;

opt_from_list :
	FROM from_list
	| /*empty*/
	;

set_clause_list :
	set_clause
	| set_clause_list ',' set_clause
	;

set_clause :
	single_set_clause
	| multiple_set_clause
	;

single_set_clause :
	column_name '=' /*9N*/ a_expr
	//| column_name '.' /*34L*/ error
	;

multiple_set_clause :
	'(' /*31L*/ insert_column_list ')' /*31L*/ '=' /*9N*/ in_expr
	;

select_stmt :
	select_no_parens %prec UMINUS /*29R*/
	| select_with_parens %prec UMINUS /*29R*/
	;

select_with_parens :
	'(' /*31L*/ select_no_parens ')' /*31L*/
	| '(' /*31L*/ select_with_parens ')' /*31L*/
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

for_locking_clause :
	for_locking_items
	| FOR READ ONLY
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
	for_locking_strength opt_locked_rels opt_nowait_or_skip
	;

for_locking_strength :
	FOR UPDATE
	| FOR NO KEY UPDATE
	| FOR SHARE
	| FOR KEY SHARE
	;

opt_locked_rels :
	/*empty*/
	| OF table_name_list
	;

opt_nowait_or_skip :
	/*empty*/
	| SKIP LOCKED
	| NOWAIT
	;

select_clause :
	//'(' /*31L*/ error
	/*|*/ simple_select
	| select_with_parens
	;

simple_select :
	simple_select_clause
	| empty_select
	| values_clause
	| table_clause
	| set_operation
	;

empty_select :
	SELECT FROM from_list opt_where_clause group_clause having_clause window_clause
	;

simple_select_clause :
	SELECT opt_all_clause target_list from_clause opt_where_clause group_clause having_clause window_clause
	| SELECT distinct_clause target_list from_clause opt_where_clause group_clause having_clause window_clause
	| SELECT distinct_on_clause target_list from_clause opt_where_clause group_clause having_clause window_clause
	//| SELECT error
	;

set_operation :
	select_clause UNION /*3L*/ all_or_distinct select_clause
	| select_clause INTERSECT /*4L*/ all_or_distinct select_clause
	| select_clause EXCEPT /*3L*/ all_or_distinct select_clause
	;

table_clause :
	TABLE table_ref
	//| TABLE error
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

materialize_clause :
	MATERIALIZED
	| NOT /*7R*/ MATERIALIZED
	;

common_table_expr :
	table_alias_name opt_column_list AS '(' /*31L*/ preparable_stmt ')' /*31L*/
	| table_alias_name opt_column_list AS materialize_clause '(' /*31L*/ preparable_stmt ')' /*31L*/
	;

opt_with :
	WITH
	| /*empty*/
	;

opt_with_clause :
	with_clause
	| /*empty*/
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

distinct_clause :
	DISTINCT
	;

distinct_on_clause :
	DISTINCT ON '(' /*31L*/ expr_list ')' /*31L*/
	;

opt_all_clause :
	ALL
	| /*empty*/
	;

opt_sort_clause :
	sort_clause
	| /*empty*/
	;

sort_clause :
	ORDER BY sortby_list
	;

single_sort_clause :
	ORDER BY sortby
	| ORDER BY sortby ',' sortby_list
	;

sortby_list :
	sortby
	| sortby_list ',' sortby
	;

sortby :
	a_expr opt_asc_desc opt_nulls_order
	| PRIMARY KEY table_name opt_asc_desc
	| INDEX table_name '@' /*22L*/ index_name opt_asc_desc
	;

opt_nulls_order :
	NULLS FIRST
	| NULLS LAST
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

opt_limit_clause :
	limit_clause
	| /*empty*/
	;

limit_clause :
	LIMIT ALL
	| LIMIT a_expr
	| FETCH first_or_next select_fetch_first_value row_or_rows ONLY
	| FETCH first_or_next row_or_rows ONLY
	;

offset_clause :
	OFFSET a_expr
	| OFFSET select_fetch_first_value row_or_rows
	;

select_fetch_first_value :
	c_expr
	| only_signed_iconst
	| only_signed_fconst
	;

row_or_rows :
	ROW
	| ROWS /*16N*/
	;

first_or_next :
	FIRST
	| NEXT
	;

group_clause :
	GROUP BY expr_list
	| /*empty*/
	;

having_clause :
	HAVING a_expr
	| /*empty*/
	;

values_clause :
	VALUES /*1N*/ '(' /*31L*/ expr_list ')' /*31L*/ %prec UMINUS /*29R*/
	//| VALUES /*1N*/ error
	| values_clause ',' '(' /*31L*/ expr_list ')' /*31L*/
	;

from_clause :
	FROM from_list
	//| FROM error
	| /*empty*/
	;

from_list :
	table_ref
	| from_list ',' table_ref
	;

index_flags_param :
	FORCE_INDEX '=' /*9N*/ index_name
	| FORCE_INDEX '=' /*9N*/ '[' /*30L*/ iconst64 ']' /*30L*/
	| ASC
	| DESC
	| NO_INDEX_JOIN
	| IGNORE_FOREIGN_KEYS
	;

index_flags_param_list :
	index_flags_param
	| index_flags_param_list ',' index_flags_param
	;

opt_index_flags :
	'@' /*22L*/ index_name
	| '@' /*22L*/ '[' /*30L*/ iconst64 ']' /*30L*/
	| '@' /*22L*/ '{' index_flags_param_list '}'
	| /*empty*/
	;

table_ref :
	numeric_table_ref table_ref_options
	| relation_expr table_ref_options
	| select_with_parens opt_ordinality opt_alias_clause
	| LATERAL select_with_parens opt_ordinality opt_alias_clause
	| joined_table
	| '(' /*31L*/ joined_table ')' /*31L*/ opt_ordinality alias_clause
	| func_table opt_ordinality opt_alias_clause
	| LATERAL func_table opt_ordinality opt_alias_clause
	| '[' /*30L*/ row_source_extension_stmt ']' /*30L*/ opt_ordinality opt_alias_clause
	;

table_ref_options :
	opt_index_flags opt_ordinality
	| opt_index_flags opt_ordinality alias_clause
	| opt_index_flags opt_ordinality as_of_clause
	| opt_index_flags opt_ordinality as_of_clause AS table_alias_name opt_column_list
	| opt_index_flags opt_ordinality as_of_clause table_alias_name opt_column_list
	;

numeric_table_ref :
	'[' /*30L*/ iconst64 opt_tableref_col_list alias_clause ']' /*30L*/
	;

func_table :
	func_expr_windowless
	| ROWS /*16N*/ FROM '(' /*31L*/ rowsfrom_list ')' /*31L*/
	;

rowsfrom_list :
	rowsfrom_item
	| rowsfrom_list ',' rowsfrom_item
	;

rowsfrom_item :
	func_expr_windowless //opt_col_def_list
	;

//opt_col_def_list :
//	/*empty*/
//	| AS '(' /*31L*/ error
//	;

opt_tableref_col_list :
	/*empty*/
	| '(' /*31L*/ ')' /*31L*/
	| '(' /*31L*/ tableref_col_list ')' /*31L*/
	;

tableref_col_list :
	iconst64
	| tableref_col_list ',' iconst64
	;

opt_ordinality :
	WITH_LA ORDINALITY
	| /*empty*/
	;

joined_table :
	'(' /*31L*/ joined_table ')' /*31L*/
	| table_ref CROSS /*35L*/ opt_join_hint JOIN /*35L*/ table_ref
	| table_ref join_type opt_join_hint JOIN /*35L*/ table_ref join_qual
	| table_ref JOIN /*35L*/ table_ref join_qual
	| table_ref NATURAL /*35L*/ join_type opt_join_hint JOIN /*35L*/ table_ref
	| table_ref NATURAL /*35L*/ JOIN /*35L*/ table_ref
	;

alias_clause :
	AS table_alias_name opt_column_list
	| table_alias_name opt_column_list
	;

opt_alias_clause :
	alias_clause
	| /*empty*/
	;

as_of_clause :
	AS_LA OF SYSTEM TIME SCONST
	| AS_LA OF SYSTEM TIME typed_literal
	| AS_LA OF SYSTEM TIME func_expr_common_subexpr
	| AS_LA OF SYSTEM TIME func_application
	| AS_LA OF SCONST
	| AS_LA OF typed_literal
	| AS_LA OF func_expr_common_subexpr
	| AS_LA OF func_application
	;

opt_as_of_clause :
	as_of_clause
	| /*empty*/
	;

join_type :
	FULL /*35L*/ join_outer
	| LEFT /*35L*/ join_outer
	| RIGHT /*35L*/ join_outer
	| INNER /*35L*/
	;

join_outer :
	OUTER
	| /*empty*/
	;

opt_join_hint :
	HASH
	| MERGE
	| LOOKUP
	| /*empty*/
	;

join_qual :
	USING '(' /*31L*/ name_list ')' /*31L*/
	| ON a_expr
	;

relation_expr :
	table_name
	| table_name '*' /*24L*/
	| ONLY table_name
	| ONLY table_name '*' /*24L*/
	| ONLY '(' /*31L*/ table_name ')' /*31L*/
	;

relation_expr_list :
	relation_expr
	| relation_expr_list ',' relation_expr
	;

table_expr_opt_alias_idx :
	table_name_opt_idx %prec UMINUS /*29R*/
	| table_name_opt_idx table_alias_name
	| table_name_opt_idx AS table_alias_name
	| numeric_table_ref opt_index_flags
	;

table_name_opt_idx :
	table_name opt_index_flags
	;

where_clause_paren :
	WHERE '(' /*31L*/ a_expr ')' /*31L*/
	;

opt_where_clause_paren :
	where_clause_paren
	| /*empty*/
	;

where_clause :
	WHERE a_expr
	;

opt_where_clause :
	where_clause
	| /*empty*/
	;

typename :
	simple_typename opt_array_bounds
	| simple_typename ARRAY '[' /*30L*/ ICONST ']' /*30L*/
	//| simple_typename ARRAY '[' /*30L*/ ICONST ']' /*30L*/ '[' /*30L*/ error
	| simple_typename ARRAY
	;

cast_target :
	typename
	;

opt_array_bounds :
	'[' /*30L*/ ']' /*30L*/
	//| '[' /*30L*/ ']' /*30L*/ '[' /*30L*/ error
	| '[' /*30L*/ ICONST ']' /*30L*/
	//| '[' /*30L*/ ICONST ']' /*30L*/ '[' /*30L*/ error
	| /*empty*/
	;

general_type_name :
	type_function_name_no_crdb_extra
	;

complex_type_name :
	general_type_name '.' /*34L*/ unrestricted_name
	| general_type_name '.' /*34L*/ unrestricted_name '.' /*34L*/ unrestricted_name
	;

simple_typename :
	general_type_name
	| '@' /*22L*/ iconst32
	| complex_type_name
	| const_typename
	| bit_with_length
	| character_with_length
	| interval_type
	//| POINT error
	//| POLYGON error
	;

geo_shape_type :
	POINT
	//| POINTM error
	//| POINTZ error
	//| POINTZM error
	| LINESTRING
	//| LINESTRINGM error
	//| LINESTRINGZ error
	//| LINESTRINGZM error
	| POLYGON
	//| POLYGONM error
	//| POLYGONZ error
	//| POLYGONZM error
	| MULTIPOINT
	//| MULTIPOINTM error
	//| MULTIPOINTZ error
	//| MULTIPOINTZM error
	| MULTILINESTRING
	//| MULTILINESTRINGM error
	//| MULTILINESTRINGZ error
	//| MULTILINESTRINGZM error
	| MULTIPOLYGON
	//| MULTIPOLYGONM error
	//| MULTIPOLYGONZ error
	//| MULTIPOLYGONZM error
	| GEOMETRYCOLLECTION
	//| GEOMETRYCOLLECTIONM error
	//| GEOMETRYCOLLECTIONZ error
	//| GEOMETRYCOLLECTIONZM error
	| GEOMETRY
	//| GEOMETRYM error
	//| GEOMETRYZ error
	//| GEOMETRYZM error
	;

const_geo :
	GEOGRAPHY
	| GEOMETRY
	| BOX2D
	| GEOMETRY '(' /*31L*/ geo_shape_type ')' /*31L*/
	| GEOGRAPHY '(' /*31L*/ geo_shape_type ')' /*31L*/
	| GEOMETRY '(' /*31L*/ geo_shape_type ',' signed_iconst ')' /*31L*/
	| GEOGRAPHY '(' /*31L*/ geo_shape_type ',' signed_iconst ')' /*31L*/
	;

const_typename :
	numeric
	| bit_without_length
	| character_without_length
	| const_datetime
	| const_geo
	;

opt_numeric_modifiers :
	'(' /*31L*/ iconst32 ')' /*31L*/
	| '(' /*31L*/ iconst32 ',' iconst32 ')' /*31L*/
	| /*empty*/
	;

numeric :
	INT
	| INTEGER
	| SMALLINT
	| BIGINT
	| REAL
	| FLOAT opt_float
	| DOUBLE PRECISION
	| DECIMAL opt_numeric_modifiers
	| DEC opt_numeric_modifiers
	| NUMERIC opt_numeric_modifiers
	| BOOLEAN
	;

opt_float :
	'(' /*31L*/ ICONST ')' /*31L*/
	| /*empty*/
	;

bit_with_length :
	BIT opt_varying '(' /*31L*/ iconst32 ')' /*31L*/
	| VARBIT '(' /*31L*/ iconst32 ')' /*31L*/
	;

bit_without_length :
	BIT
	| BIT VARYING
	| VARBIT
	;

character_with_length :
	character_base '(' /*31L*/ iconst32 ')' /*31L*/
	;

character_without_length :
	character_base
	;

character_base :
	char_aliases
	| char_aliases VARYING
	| VARCHAR
	| STRING
	;

char_aliases :
	CHAR
	| CHARACTER
	;

opt_varying :
	VARYING
	| /*empty*/
	;

const_datetime :
	DATE
	| TIME opt_timezone
	| TIME '(' /*31L*/ iconst32 ')' /*31L*/ opt_timezone
	| TIMETZ
	| TIMETZ '(' /*31L*/ iconst32 ')' /*31L*/
	| TIMESTAMP opt_timezone
	| TIMESTAMP '(' /*31L*/ iconst32 ')' /*31L*/ opt_timezone
	| TIMESTAMPTZ
	| TIMESTAMPTZ '(' /*31L*/ iconst32 ')' /*31L*/
	;

opt_timezone :
	WITH_LA TIME ZONE
	| WITHOUT TIME ZONE
	| /*empty*/
	;

interval_type :
	INTERVAL
	| INTERVAL interval_qualifier
	| INTERVAL '(' /*31L*/ iconst32 ')' /*31L*/
	;

interval_qualifier :
	YEAR
	| MONTH
	| DAY
	| HOUR
	| MINUTE
	| interval_second
	| YEAR TO MONTH
	| DAY TO HOUR
	| DAY TO MINUTE
	| DAY TO interval_second
	| HOUR TO MINUTE
	| HOUR TO interval_second
	| MINUTE TO interval_second
	;

opt_interval_qualifier :
	interval_qualifier
	| /*empty*/
	;

interval_second :
	SECOND
	| SECOND '(' /*31L*/ iconst32 ')' /*31L*/
	;

a_expr :
	c_expr
	| a_expr TYPECAST /*33L*/ cast_target
	| a_expr TYPEANNOTATE /*32L*/ typename
	| a_expr COLLATE /*28L*/ collation_name
	| a_expr AT /*27L*/ TIME ZONE a_expr %prec AT /*27L*/
	| '+' /*23L*/ a_expr %prec UMINUS /*29R*/
	| '-' /*23L*/ a_expr %prec UMINUS /*29R*/
	| '~' /*10N*/ a_expr %prec UMINUS /*29R*/
	| SQRT /*21L*/ a_expr
	| CBRT /*21L*/ a_expr
	| '@' /*22L*/ a_expr
	| a_expr '+' /*23L*/ a_expr
	| a_expr '-' /*23L*/ a_expr
	| a_expr '*' /*24L*/ a_expr
	| a_expr '/' /*24L*/ a_expr
	| a_expr FLOORDIV /*24L*/ a_expr
	| a_expr '%' /*24L*/ a_expr
	| a_expr '^' /*25L*/ a_expr
	| a_expr '#' /*19L*/ a_expr
	| a_expr '&' /*20L*/ a_expr
	| a_expr '|' /*18L*/ a_expr
	| a_expr '<' /*9N*/ a_expr
	| a_expr '>' /*9N*/ a_expr
	| a_expr '?' /*12N*/ a_expr
	| a_expr JSON_SOME_EXISTS /*12N*/ a_expr
	| a_expr JSON_ALL_EXISTS /*12N*/ a_expr
	| a_expr CONTAINS /*12N*/ a_expr
	| a_expr CONTAINED_BY /*12N*/ a_expr
	| a_expr '=' /*9N*/ a_expr
	| a_expr CONCAT /*17L*/ a_expr
	| a_expr LSHIFT /*21L*/ a_expr
	| a_expr RSHIFT /*21L*/ a_expr
	| a_expr FETCHVAL /*17L*/ a_expr
	| a_expr FETCHTEXT /*17L*/ a_expr
	| a_expr FETCHVAL_PATH /*17L*/ a_expr
	| a_expr FETCHTEXT_PATH /*17L*/ a_expr
	| a_expr REMOVE_PATH /*17L*/ a_expr
	| a_expr INET_CONTAINED_BY_OR_EQUALS /*21L*/ a_expr
	| a_expr AND_AND /*21L*/ a_expr
	| a_expr INET_CONTAINS_OR_EQUALS /*21L*/ a_expr
	| a_expr LESS_EQUALS /*9N*/ a_expr
	| a_expr GREATER_EQUALS /*9N*/ a_expr
	| a_expr NOT_EQUALS /*9N*/ a_expr
	| a_expr AND /*6L*/ a_expr
	| a_expr OR /*5L*/ a_expr
	| NOT /*7R*/ a_expr
	| NOT_LA /*10N*/ a_expr %prec NOT /*7R*/
	| a_expr LIKE /*10N*/ a_expr
	| a_expr LIKE /*10N*/ a_expr ESCAPE /*11N*/ a_expr %prec ESCAPE /*11N*/
	| a_expr NOT_LA /*10N*/ LIKE /*10N*/ a_expr %prec NOT_LA /*10N*/
	| a_expr NOT_LA /*10N*/ LIKE /*10N*/ a_expr ESCAPE /*11N*/ a_expr %prec ESCAPE /*11N*/
	| a_expr ILIKE /*10N*/ a_expr
	| a_expr ILIKE /*10N*/ a_expr ESCAPE /*11N*/ a_expr %prec ESCAPE /*11N*/
	| a_expr NOT_LA /*10N*/ ILIKE /*10N*/ a_expr %prec NOT_LA /*10N*/
	| a_expr NOT_LA /*10N*/ ILIKE /*10N*/ a_expr ESCAPE /*11N*/ a_expr %prec ESCAPE /*11N*/
	| a_expr SIMILAR /*10N*/ TO a_expr %prec SIMILAR /*10N*/
	| a_expr SIMILAR /*10N*/ TO a_expr ESCAPE /*11N*/ a_expr %prec ESCAPE /*11N*/
	| a_expr NOT_LA /*10N*/ SIMILAR /*10N*/ TO a_expr %prec NOT_LA /*10N*/
	| a_expr NOT_LA /*10N*/ SIMILAR /*10N*/ TO a_expr ESCAPE /*11N*/ a_expr %prec ESCAPE /*11N*/
	| a_expr '~' /*10N*/ a_expr
	| a_expr NOT_REGMATCH /*10N*/ a_expr
	| a_expr REGIMATCH /*10N*/ a_expr
	| a_expr NOT_REGIMATCH /*10N*/ a_expr
	| a_expr TEXTSEARCHMATCH /*10N*/ a_expr
	| a_expr IS /*8N*/ NAN %prec IS /*8N*/
	| a_expr IS /*8N*/ NOT /*7R*/ NAN %prec IS /*8N*/
	| a_expr IS /*8N*/ NULL /*16N*/ %prec IS /*8N*/
	| a_expr ISNULL /*8N*/ %prec IS /*8N*/
	| a_expr IS /*8N*/ NOT /*7R*/ NULL /*16N*/ %prec IS /*8N*/
	| a_expr NOTNULL /*8N*/ %prec IS /*8N*/
	| row OVERLAPS /*13N*/ row
	| a_expr IS /*8N*/ TRUE %prec IS /*8N*/
	| a_expr IS /*8N*/ NOT /*7R*/ TRUE %prec IS /*8N*/
	| a_expr IS /*8N*/ FALSE %prec IS /*8N*/
	| a_expr IS /*8N*/ NOT /*7R*/ FALSE %prec IS /*8N*/
	| a_expr IS /*8N*/ UNKNOWN %prec IS /*8N*/
	| a_expr IS /*8N*/ NOT /*7R*/ UNKNOWN %prec IS /*8N*/
	| a_expr IS /*8N*/ DISTINCT FROM a_expr %prec IS /*8N*/
	| a_expr IS /*8N*/ NOT /*7R*/ DISTINCT FROM a_expr %prec IS /*8N*/
	| a_expr IS /*8N*/ OF '(' /*31L*/ type_list ')' /*31L*/ %prec IS /*8N*/
	| a_expr IS /*8N*/ NOT /*7R*/ OF '(' /*31L*/ type_list ')' /*31L*/ %prec IS /*8N*/
	| a_expr BETWEEN /*10N*/ opt_asymmetric b_expr AND /*6L*/ a_expr %prec BETWEEN /*10N*/
	| a_expr NOT_LA /*10N*/ BETWEEN /*10N*/ opt_asymmetric b_expr AND /*6L*/ a_expr %prec NOT_LA /*10N*/
	| a_expr BETWEEN /*10N*/ SYMMETRIC b_expr AND /*6L*/ a_expr %prec BETWEEN /*10N*/
	| a_expr NOT_LA /*10N*/ BETWEEN /*10N*/ SYMMETRIC b_expr AND /*6L*/ a_expr %prec NOT_LA /*10N*/
	| a_expr IN /*10N*/ in_expr
	| a_expr NOT_LA /*10N*/ IN /*10N*/ in_expr %prec NOT_LA /*10N*/
	| a_expr subquery_op sub_type a_expr %prec CONCAT /*17L*/
	| DEFAULT
	//| UNIQUE '(' /*31L*/ error
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ '+' /*23L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ '-' /*23L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ '*' /*24L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ '/' /*24L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ FLOORDIV /*24L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ '%' /*24L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ '^' /*25L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ '#' /*19L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ '&' /*20L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ '|' /*18L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ '<' /*9N*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ '>' /*9N*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ '?' /*12N*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ JSON_SOME_EXISTS /*12N*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ JSON_ALL_EXISTS /*12N*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ '=' /*9N*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ CONCAT /*17L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ LSHIFT /*21L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ RSHIFT /*21L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ FETCHVAL /*17L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ FETCHTEXT /*17L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ FETCHVAL_PATH /*17L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ FETCHTEXT_PATH /*17L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ REMOVE_PATH /*17L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ INET_CONTAINED_BY_OR_EQUALS /*21L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ AND_AND /*21L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ INET_CONTAINS_OR_EQUALS /*21L*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ LESS_EQUALS /*9N*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ GREATER_EQUALS /*9N*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ NOT_EQUALS /*9N*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ '~' /*10N*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ NOT_REGMATCH /*10N*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ REGIMATCH /*10N*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ NOT_REGIMATCH /*10N*/ ')' /*31L*/ a_expr
	| a_expr OPERATOR /*26L*/ '(' /*31L*/ schema_name '.' /*34L*/ TEXTSEARCHMATCH /*10N*/ ')' /*31L*/ a_expr
	;

b_expr :
	c_expr
	| b_expr TYPECAST /*33L*/ cast_target
	| b_expr TYPEANNOTATE /*32L*/ typename
	| '+' /*23L*/ b_expr %prec UMINUS /*29R*/
	| '-' /*23L*/ b_expr %prec UMINUS /*29R*/
	| '~' /*10N*/ b_expr %prec UMINUS /*29R*/
	| b_expr '+' /*23L*/ b_expr
	| b_expr '-' /*23L*/ b_expr
	| b_expr '*' /*24L*/ b_expr
	| b_expr '/' /*24L*/ b_expr
	| b_expr FLOORDIV /*24L*/ b_expr
	| b_expr '%' /*24L*/ b_expr
	| b_expr '^' /*25L*/ b_expr
	| b_expr '#' /*19L*/ b_expr
	| b_expr '&' /*20L*/ b_expr
	| b_expr '|' /*18L*/ b_expr
	| b_expr '<' /*9N*/ b_expr
	| b_expr '>' /*9N*/ b_expr
	| b_expr '=' /*9N*/ b_expr
	| b_expr CONCAT /*17L*/ b_expr
	| b_expr LSHIFT /*21L*/ b_expr
	| b_expr RSHIFT /*21L*/ b_expr
	| b_expr LESS_EQUALS /*9N*/ b_expr
	| b_expr GREATER_EQUALS /*9N*/ b_expr
	| b_expr NOT_EQUALS /*9N*/ b_expr
	| b_expr IS /*8N*/ DISTINCT FROM b_expr %prec IS /*8N*/
	| b_expr IS /*8N*/ NOT /*7R*/ DISTINCT FROM b_expr %prec IS /*8N*/
	| b_expr IS /*8N*/ OF '(' /*31L*/ type_list ')' /*31L*/ %prec IS /*8N*/
	| b_expr IS /*8N*/ NOT /*7R*/ OF '(' /*31L*/ type_list ')' /*31L*/ %prec IS /*8N*/
	;

c_expr :
	d_expr
	| d_expr array_subscripts
	| case_expr
	| EXISTS select_with_parens
	;

d_expr :
	ICONST
	| FCONST
	| SCONST
	| BCONST
	| BITCONST
	| func_name '(' /*31L*/ expr_list opt_sort_clause ')' /*31L*/ SCONST
	| typed_literal
	| interval_value
	| TRUE
	| FALSE
	| NULL /*16N*/
	| column_path_with_star
	| PLACEHOLDER
	| '(' /*31L*/ a_expr ')' /*31L*/ '.' /*34L*/ '*' /*24L*/
	| '(' /*31L*/ a_expr ')' /*31L*/ '.' /*34L*/ unrestricted_name
	| '(' /*31L*/ a_expr ')' /*31L*/ '.' /*34L*/ '@' /*22L*/ ICONST
	| '(' /*31L*/ a_expr ')' /*31L*/
	| func_expr
	| select_with_parens %prec UMINUS /*29R*/
	| labeled_row
	| ARRAY select_with_parens %prec UMINUS /*29R*/
	| ARRAY row
	| ARRAY array_expr
	| GROUPING '(' /*31L*/ expr_list ')' /*31L*/
	;

func_application :
	func_name '(' /*31L*/ ')' /*31L*/
	| func_name '(' /*31L*/ expr_list opt_sort_clause ')' /*31L*/
	| func_name '(' /*31L*/ VARIADIC a_expr opt_sort_clause ')' /*31L*/
	| func_name '(' /*31L*/ expr_list ',' VARIADIC a_expr opt_sort_clause ')' /*31L*/
	| func_name '(' /*31L*/ ALL expr_list opt_sort_clause ')' /*31L*/
	| func_name '(' /*31L*/ DISTINCT expr_list ')' /*31L*/
	| func_name '(' /*31L*/ '*' /*24L*/ ')' /*31L*/
	//| func_name '(' /*31L*/ error
	;

typed_literal :
	func_name_no_crdb_extra SCONST
	| const_typename SCONST
	| bit_with_length SCONST
	| character_with_length SCONST
	;

func_expr :
	func_application within_group_clause filter_clause over_clause
	| func_expr_common_subexpr
	;

func_expr_windowless :
	func_application
	| func_expr_common_subexpr
	;

func_expr_common_subexpr :
	COLLATION FOR '(' /*31L*/ a_expr ')' /*31L*/
	| CURRENT_DATE
	| CURRENT_SCHEMA
	| CURRENT_CATALOG
	| CURRENT_TIMESTAMP
	| CURRENT_TIME
	| LOCALTIMESTAMP
	| LOCALTIME
	| CURRENT_USER
	| CURRENT_ROLE
	| SESSION_USER
	| USER
	| CAST '(' /*31L*/ a_expr AS cast_target ')' /*31L*/
	| ANNOTATE_TYPE '(' /*31L*/ a_expr ',' typename ')' /*31L*/
	| IF '(' /*31L*/ a_expr ',' a_expr ',' a_expr ')' /*31L*/
	| IFERROR '(' /*31L*/ a_expr ',' a_expr ',' a_expr ')' /*31L*/
	| IFERROR '(' /*31L*/ a_expr ',' a_expr ')' /*31L*/
	| ISERROR '(' /*31L*/ a_expr ')' /*31L*/
	| ISERROR '(' /*31L*/ a_expr ',' a_expr ')' /*31L*/
	| NULLIF '(' /*31L*/ a_expr ',' a_expr ')' /*31L*/
	| IFNULL '(' /*31L*/ a_expr ',' a_expr ')' /*31L*/
	| COALESCE '(' /*31L*/ expr_list ')' /*31L*/
	| special_function
	;

special_function :
	CURRENT_DATE '(' /*31L*/ ')' /*31L*/
	//| CURRENT_DATE '(' /*31L*/ error
	| CURRENT_SCHEMA '(' /*31L*/ ')' /*31L*/
	//| CURRENT_SCHEMA '(' /*31L*/ error
	| CURRENT_TIMESTAMP '(' /*31L*/ ')' /*31L*/
	| CURRENT_TIMESTAMP '(' /*31L*/ a_expr ')' /*31L*/
	//| CURRENT_TIMESTAMP '(' /*31L*/ error
	| CURRENT_TIME '(' /*31L*/ ')' /*31L*/
	| CURRENT_TIME '(' /*31L*/ a_expr ')' /*31L*/
	//| CURRENT_TIME '(' /*31L*/ error
	| LOCALTIMESTAMP '(' /*31L*/ ')' /*31L*/
	| LOCALTIMESTAMP '(' /*31L*/ a_expr ')' /*31L*/
	//| LOCALTIMESTAMP '(' /*31L*/ error
	| LOCALTIME '(' /*31L*/ ')' /*31L*/
	| LOCALTIME '(' /*31L*/ a_expr ')' /*31L*/
	//| LOCALTIME '(' /*31L*/ error
	| CURRENT_USER '(' /*31L*/ ')' /*31L*/
	//| CURRENT_USER '(' /*31L*/ error
	| EXTRACT '(' /*31L*/ extract_list ')' /*31L*/
	//| EXTRACT '(' /*31L*/ error
	| EXTRACT_DURATION '(' /*31L*/ extract_list ')' /*31L*/
	//| EXTRACT_DURATION '(' /*31L*/ error
	| OVERLAY '(' /*31L*/ overlay_list ')' /*31L*/
	//| OVERLAY '(' /*31L*/ error
	| POSITION '(' /*31L*/ position_list ')' /*31L*/
	| SUBSTRING '(' /*31L*/ substr_list ')' /*31L*/
	//| SUBSTRING '(' /*31L*/ error
	| TREAT '(' /*31L*/ a_expr AS typename ')' /*31L*/
	| TRIM '(' /*31L*/ BOTH trim_list ')' /*31L*/
	| TRIM '(' /*31L*/ LEADING trim_list ')' /*31L*/
	| TRIM '(' /*31L*/ TRAILING trim_list ')' /*31L*/
	| TRIM '(' /*31L*/ trim_list ')' /*31L*/
	| GREATEST '(' /*31L*/ expr_list ')' /*31L*/
	//| GREATEST '(' /*31L*/ error
	| LEAST '(' /*31L*/ expr_list ')' /*31L*/
	//| LEAST '(' /*31L*/ error
	;

within_group_clause :
	WITHIN GROUP '(' /*31L*/ single_sort_clause ')' /*31L*/
	| /*empty*/
	;

filter_clause :
	FILTER '(' /*31L*/ WHERE a_expr ')' /*31L*/
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
	window_name AS window_specification
	;

over_clause :
	OVER window_specification
	| OVER window_name
	| /*empty*/
	;

window_specification :
	'(' /*31L*/ opt_existing_window_name opt_partition_clause opt_sort_clause opt_frame_clause ')' /*31L*/
	;

opt_existing_window_name :
	name
	| %prec CONCAT /*17L*/ /*empty*/
	;

opt_partition_clause :
	PARTITION /*16N*/ BY expr_list
	| /*empty*/
	;

opt_frame_clause :
	RANGE /*16N*/ frame_extent opt_frame_exclusion
	| ROWS /*16N*/ frame_extent opt_frame_exclusion
	| GROUPS /*16N*/ frame_extent opt_frame_exclusion
	| /*empty*/
	;

frame_extent :
	frame_bound
	| BETWEEN /*10N*/ frame_bound AND /*6L*/ frame_bound
	;

frame_bound :
	UNBOUNDED /*15N*/ PRECEDING /*16N*/
	| UNBOUNDED /*15N*/ FOLLOWING /*16N*/
	| CURRENT ROW
	| a_expr PRECEDING /*16N*/
	| a_expr FOLLOWING /*16N*/
	;

opt_frame_exclusion :
	EXCLUDE CURRENT ROW
	| EXCLUDE GROUP
	| EXCLUDE TIES
	| EXCLUDE NO OTHERS
	| /*empty*/
	;

row :
	ROW '(' /*31L*/ opt_expr_list ')' /*31L*/
	| expr_tuple_unambiguous
	;

labeled_row :
	row
	| '(' /*31L*/ row AS name_list ')' /*31L*/
	;

sub_type :
	ANY
	| SOME
	| ALL
	;

operator :
	subquery_op
	| '~' /*10N*/
	| SQRT /*21L*/
	| CBRT /*21L*/
	| '?' /*12N*/
	| JSON_SOME_EXISTS /*12N*/
	| JSON_ALL_EXISTS /*12N*/
	| CONTAINS /*12N*/
	| CONTAINED_BY /*12N*/
	| CONCAT /*17L*/
	| LSHIFT /*21L*/
	| RSHIFT /*21L*/
	| FETCHVAL /*17L*/
	| FETCHTEXT /*17L*/
	| FETCHVAL_PATH /*17L*/
	| FETCHTEXT_PATH /*17L*/
	| AND_AND /*21L*/
	| TEXTSEARCHMATCH /*10N*/
	;

math_op :
	'+' /*23L*/
	| '-' /*23L*/
	| '*' /*24L*/
	| '/' /*24L*/
	| FLOORDIV /*24L*/
	| '%' /*24L*/
	| '&' /*20L*/
	| '|' /*18L*/
	| '^' /*25L*/
	| '#' /*19L*/
	| '<' /*9N*/
	| '>' /*9N*/
	| '=' /*9N*/
	| LESS_EQUALS /*9N*/
	| GREATER_EQUALS /*9N*/
	| NOT_EQUALS /*9N*/
	| '@' /*22L*/
	;

subquery_op :
	math_op
	| LIKE /*10N*/
	| NOT_LA /*10N*/ LIKE /*10N*/
	| ILIKE /*10N*/
	| NOT_LA /*10N*/ ILIKE /*10N*/
	;

expr_tuple1_ambiguous :
	'(' /*31L*/ ')' /*31L*/
	| '(' /*31L*/ tuple1_ambiguous_values ')' /*31L*/
	;

tuple1_ambiguous_values :
	a_expr
	| a_expr ','
	| a_expr ',' expr_list
	;

expr_tuple_unambiguous :
	'(' /*31L*/ ')' /*31L*/
	| '(' /*31L*/ tuple1_unambiguous_values ')' /*31L*/
	;

tuple1_unambiguous_values :
	a_expr ','
	| a_expr ',' expr_list
	;

opt_expr_list :
	expr_list
	| /*empty*/
	;

expr_list :
	a_expr
	| expr_list ',' a_expr
	;

type_list :
	typename
	| type_list ',' typename
	;

array_expr :
	'[' /*30L*/ opt_expr_list ']' /*30L*/
	| '[' /*30L*/ array_expr_list ']' /*30L*/
	;

array_expr_list :
	array_expr
	| array_expr_list ',' array_expr
	;

extract_list :
	extract_arg FROM a_expr
	| expr_list
	;

extract_arg :
	IDENT /*16N*/
	| YEAR
	| MONTH
	| DAY
	| HOUR
	| MINUTE
	| SECOND
	| SCONST
	;

overlay_list :
	a_expr overlay_placing substr_from substr_for
	| a_expr overlay_placing substr_from
	| expr_list
	;

overlay_placing :
	PLACING a_expr
	;

position_list :
	b_expr IN /*10N*/ b_expr
	| /*empty*/
	;

substr_list :
	a_expr substr_from substr_for
	| a_expr substr_for substr_from
	| a_expr substr_from
	| a_expr substr_for
	| opt_expr_list
	;

substr_from :
	FROM a_expr
	;

substr_for :
	FOR a_expr
	;

trim_list :
	a_expr FROM expr_list
	| FROM expr_list
	| expr_list
	;

in_expr :
	select_with_parens
	| expr_tuple1_ambiguous
	;

case_expr :
	CASE case_arg when_clause_list case_default END
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

array_subscript :
	'[' /*30L*/ a_expr ']' /*30L*/
	| '[' /*30L*/ opt_slice_bound ':' opt_slice_bound ']' /*30L*/
	;

opt_slice_bound :
	a_expr
	| /*empty*/
	;

array_subscripts :
	array_subscript
	| array_subscripts array_subscript
	;

opt_asymmetric :
	ASYMMETRIC
	| /*empty*/
	;

target_list :
	target_elem
	| target_list ',' target_elem
	;

target_elem :
	a_expr AS target_name
	| a_expr IDENT /*16N*/
	| a_expr
	| '*' /*24L*/
	;

table_index_name_list :
	table_index_name
	| table_index_name_list ',' table_index_name
	;

table_pattern_list :
	table_pattern
	| table_pattern_list ',' table_pattern
	;

table_index_name :
	table_name '@' /*22L*/ index_name
	| standalone_index_name
	;

table_pattern :
	simple_db_object_name
	| complex_table_pattern
	;

complex_table_pattern :
	complex_db_object_name
	| db_object_name_component '.' /*34L*/ unrestricted_name '.' /*34L*/ '*' /*24L*/
	| db_object_name_component '.' /*34L*/ '*' /*24L*/
	| '*' /*24L*/
	;

opt_name_list :
	/*empty*/
	| name_list
	;

name_list :
	name
	| name_list ',' name
	;

numeric_only :
	signed_iconst
	| signed_fconst
	;

int_expr_list :
	signed_iconst
	| int_expr_list ',' signed_iconst
	;

signed_iconst :
	ICONST
	| only_signed_iconst
	;

only_signed_iconst :
	'+' /*23L*/ ICONST
	| '-' /*23L*/ ICONST
	;

signed_fconst :
	FCONST
	| only_signed_fconst
	;

only_signed_fconst :
	'+' /*23L*/ FCONST
	| '-' /*23L*/ FCONST
	;

signed_iconst32 :
	signed_iconst
	;

iconst32 :
	ICONST
	;

signed_iconst64 :
	signed_iconst
	;

iconst64 :
	ICONST
	;

interval_value :
	INTERVAL SCONST opt_interval_qualifier
	| INTERVAL '(' /*31L*/ iconst32 ')' /*31L*/ SCONST
	;

collation_name :
	db_object_name
	;

index_name :
	unrestricted_name
	;

opt_index_name :
	opt_name
	;

target_name :
	unrestricted_name
	;

constraint_name :
	name
	;

database_name :
	name
	;

column_name :
	name
	;

table_alias_name :
	name
	;

statistics_name :
	name
	;

window_name :
	name
	;

view_name :
	table_name
	;

trigger_name :
	name
	;

type_name :
	db_object_name
	;

sequence_name :
	db_object_name
	;

schema_name :
	name
	;

opt_schema_name :
	opt_name
	;

table_name :
	db_object_name
	;

standalone_index_name :
	db_object_name
	;

explain_option_name :
	non_reserved_word
	| ANALYZE
	| VERBOSE
	;

cursor_name :
	name
	;

tablespace_name :
	name
	;

partition_name :
	name
	;

routine_name :
	db_object_name
	;

aggregate_name :
	db_object_name
	;

column_path :
	name
	| prefixed_column_path
	;

prefixed_column_path :
	db_object_name_component '.' /*34L*/ unrestricted_name
	| db_object_name_component '.' /*34L*/ unrestricted_name '.' /*34L*/ unrestricted_name
	| db_object_name_component '.' /*34L*/ unrestricted_name '.' /*34L*/ unrestricted_name '.' /*34L*/ unrestricted_name
	;

column_path_with_star :
	column_path
	| db_object_name_component '.' /*34L*/ unrestricted_name '.' /*34L*/ unrestricted_name '.' /*34L*/ '*' /*24L*/
	| db_object_name_component '.' /*34L*/ unrestricted_name '.' /*34L*/ '*' /*24L*/
	| db_object_name_component '.' /*34L*/ '*' /*24L*/
	;

func_name :
	type_function_name
	| prefixed_column_path
	;

func_name_no_crdb_extra :
	type_function_name_no_crdb_extra
	| prefixed_column_path
	;

db_object_name :
	simple_db_object_name
	| complex_db_object_name
	;

db_object_name_no_keywords :
	simple_db_object_name_no_keywords
	| complex_db_object_name_no_keywords
	;

simple_db_object_name :
	db_object_name_component
	;

simple_db_object_name_no_keywords :
	simple_ident
	;

complex_db_object_name :
	db_object_name_component '.' /*34L*/ unrestricted_name
	| db_object_name_component '.' /*34L*/ unrestricted_name '.' /*34L*/ unrestricted_name
	;

complex_db_object_name_no_keywords :
	simple_ident '.' /*34L*/ simple_ident
	| simple_ident '.' /*34L*/ simple_ident '.' /*34L*/ simple_ident
	;

simple_ident :
	IDENT /*16N*/
	| PUBLIC
	;

db_object_name_component :
	name
	| cockroachdb_extra_reserved_keyword
	;

name :
	IDENT /*16N*/
	| unreserved_keyword
	| col_name_keyword
	;

opt_name :
	name
	| /*empty*/
	;

opt_name_parens :
	'(' /*31L*/ name ')' /*31L*/
	| /*empty*/
	;

non_reserved_word_or_sconst :
	non_reserved_word
	| SCONST
	;

type_function_name :
	IDENT /*16N*/
	| unreserved_keyword
	| type_func_name_keyword
	;

type_function_name_no_crdb_extra :
	IDENT /*16N*/
	| unreserved_keyword
	| type_func_name_no_crdb_extra_keyword
	;

non_reserved_word :
	IDENT /*16N*/
	| unreserved_keyword
	| col_name_keyword
	| type_func_name_keyword
	;

unrestricted_name :
	IDENT /*16N*/
	| unreserved_keyword
	| col_name_keyword
	| type_func_name_keyword
	| reserved_keyword
	;

unreserved_keyword :
	ABORT
	| ACCESS
	| ACTION
	| ADD
	| ADMIN
	| AFTER
	| AGGREGATE
	| ALIGNMENT
	| ALLOW_CONNECTIONS
	| ALTER
	| ALWAYS
	| AT /*27L*/
	| ATOMIC
	| ATTACH
	| ATTRIBUTE
	| AUTO
	| AUTOMATIC
	| BACKUP
	| BACKUPS
	| BASETYPE
	| BEFORE
	| BEGIN
	| BINARY
	| BUCKET_COUNT
	| BUFFER_USAGE_LIMIT
	| BUNDLE
	| BY
	| BYPASSRLS
	| CACHE
	| CALL
	| CALLED
	| CANCEL
	| CANCELQUERY
	| CANONICAL
	| CASCADE
	| CASCADED
	| CATEGORY
	| CHAIN
	| CHANGEFEED
	| CHECK_OPTION
	| CLASS
	| CLOSE
	| CLUSTER
	| COLLATABLE
	| COLLATION_VERSION
	| COLUMNS
	| COMBINEFUNC
	| COMMENT
	| COMMENTS
	| COMMIT
	| COMMITTED
	| COMPACT
	| COMPLETE
	| COMPRESSION
	| CONFIGURATION
	| CONFIGURATIONS
	| CONFIGURE
	| CONFLICT
	| CONNECTION
	| CONSTRAINTS
	| CONTROLCHANGEFEED
	| CONTROLJOB
	| CONVERSION
	| CONVERT
	| COPY
	| COST
	| CREATEDB
	| CREATELOGIN
	| CREATEROLE
	| CSV
	| CUBE /*16N*/
	| CURRENT
	| CYCLE
	| DATA
	| DATABASE
	| DATABASES
	| DAY
	| DEALLOCATE
	| DECLARE
	| DEFAULTS
	| DEFERRED
	| DEFINER
	| DELETE
	| DELIMITER
	| DEPENDS
	| DESERIALFUNC
	| DESTINATION
	| DETACH
	| DETACHED
	| DICTIONARY
	| DISABLE
	| DISABLE_PAGE_SKIPPING
	| DISCARD
	| DOMAIN
	| DOUBLE
	| DROP
	| EACH
	| ENABLE
	| ENCODING
	| ENCRYPTED
	| ENCRYPTION_PASSPHRASE
	| ENUM
	| ENUMS
	| ESCAPE /*11N*/
	| EVENT
	| EXCLUDE
	| EXCLUDING
	| EXECUTE
	| EXECUTION
	| EXPERIMENTAL
	| EXPERIMENTAL_AUDIT
	| EXPERIMENTAL_FINGERPRINTS
	| EXPERIMENTAL_REPLICA
	| EXPIRATION
	| EXPLAIN
	| EXPORT
	| EXPRESSION
	| EXTENDED
	| EXTENSION
	| EXTERNAL
	| FAMILY
	| FILES
	| FILTER
	| FINALFUNC
	| FINALFUNC_EXTRA
	| FINALFUNC_MODIFY
	| FINALIZE
	| FIRST
	| FOLLOWING /*16N*/
	| FORCE
	| FORCE_INDEX
	| FORMAT
	| FUNCTION
	| FUNCTIONS
	| GENERATED
	| GEOMETRYCOLLECTION
	| GEOMETRYCOLLECTIONM
	| GEOMETRYCOLLECTIONZ
	| GEOMETRYCOLLECTIONZM
	| GEOMETRYM
	| GEOMETRYZ
	| GEOMETRYZM
	| GLOBAL
	| GRANTED
	| GRANTS
	| GROUPS /*16N*/
	| HANDLER
	| HASH
	| HEADER
	| HIGH
	| HISTOGRAM
	| HOUR
	| HYPOTHETICAL
	| ICU_LOCALE
	| ICU_RULES
	| IDENTITY
	| IGNORE_FOREIGN_KEYS
	| IMMEDIATE
	| IMMUTABLE
	| IMPORT
	| INCLUDE
	| INCLUDING
	| INCREMENT
	| INCREMENTAL
	| INDEXES
	| INDEX_CLEANUP
	| INHERIT
	| INHERITS
	| INITCOND
	| INJECT
	| INLINE
	| INPUT
	| INSERT
	| INSTEAD
	| INTERLEAVE
	| INTERNALLENGTH
	| INTO_DB
	| INVERTED
	| INVOKER
	| ISOLATION
	| IS_TEMPLATE
	| JOB
	| JOBS
	| JSON
	| KEY
	| KEYS
	| KMS
	| KV
	| LANGUAGE
	| LARGE
	| LAST
	| LATEST
	| LC_COLLATE
	| LC_CTYPE
	| LEAKPROOF
	| LEASE
	| LESS
	| LEVEL
	| LINESTRING
	| LIST
	| LOCAL
	| LOCALE
	| LOCALE_PROVIDER
	| LOCKED
	| LOGGED
	| LOGIN
	| LOOKUP
	| LOW
	| MAIN
	| MATCH
	| MATERIALIZED
	| MAXVALUE
	| MERGE
	| METHOD
	| MFINALFUNC
	| MFINALFUNC_EXTRA
	| MFINALFUNC_MODIFY
	| MINITCOND
	| MINUTE
	| MINVALUE
	| MINVFUNC
	| MODIFYCLUSTERSETTING
	| MODULUS
	| MONTH
	| MSFUNC
	| MSPACE
	| MSSPACE
	| MSTYPE
	| MULTILINESTRING
	| MULTILINESTRINGM
	| MULTILINESTRINGZ
	| MULTILINESTRINGZM
	| MULTIPOINT
	| MULTIPOINTM
	| MULTIPOINTZ
	| MULTIPOINTZM
	| MULTIPOLYGON
	| MULTIPOLYGONM
	| MULTIPOLYGONZ
	| MULTIPOLYGONZM
	| MULTIRANGE_TYPE_NAME
	| NAMES
	| NAN
	| NEVER
	| NEW
	| NEXT
	| NO
	| NOBYPASSRLS
	| NOCANCELQUERY
	| NOCONTROLCHANGEFEED
	| NOCONTROLJOB
	| NOCREATEDB
	| NOCREATELOGIN
	| NOCREATEROLE
	| NOINHERIT
	| NOLOGIN
	| NOMODIFYCLUSTERSETTING
	| NOREPLICATION
	| NORMAL
	| NOSUPERUSER
	| NOVIEWACTIVITY
	| NOWAIT
	| NO_INDEX_JOIN
	| NULLS
	| OBJECT
	| OF
	| OFF
	| OID
	| OIDS
	| OLD
	| ONLY_DATABASE_STATS
	| OPERATOR /*26L*/
	| OPT
	| OPTION
	| OPTIONS
	| ORDINALITY
	| OTHERS
	| OUTPUT
	| OVER
	| OWNED
	| OWNER
	| PARALLEL
	| PARAMETER
	| PARENT
	| PARSER
	| PARTIAL
	| PARTITION /*16N*/
	| PARTITIONS
	| PASSEDBYVALUE
	| PASSWORD
	| PAUSE
	| PAUSED
	| PHYSICAL
	| PLAIN
	| PLAN
	| PLANS
	| POINTM
	| POINTZ
	| POINTZM
	| POLICY
	| POLYGONM
	| POLYGONZ
	| POLYGONZM
	| PRECEDING /*16N*/
	| PREFERRED
	| PREPARE
	| PRESERVE
	| PRIORITY
	| PRIVILEGES
	| PROCEDURAL
	| PROCEDURE
	| PROCEDURES
	| PROCESS_MAIN
	| PROCESS_TOAST
	| PUBLIC
	| PUBLICATION
	| QUERIES
	| QUERY
	| RANGE /*16N*/
	| RANGES
	| READ
	| READ_ONLY
	| READ_WRITE
	| RECEIVE
	| RECURRING
	| RECURSIVE
	| REF
	| REFERENCING
	| REFRESH
	| REINDEX
	| RELEASE
	| REMAINDER
	| RENAME
	| REPEATABLE
	| REPLACE
	| REPLICA
	| REPLICATION
	| RESET
	| RESTART
	| RESTORE
	| RESTRICT
	| RESTRICTED
	| RESUME
	| RETRY
	| RETURN
	| RETURNS
	| REVISION_HISTORY
	| REVOKE
	| ROLE
	| ROLES
	| ROLLBACK
	| ROLLUP /*16N*/
	| ROUTINE
	| ROUTINES
	| ROWS /*16N*/
	| RULE
	| RUNNING
	| SAFE
	| SAVEPOINT
	| SCATTER
	| SCHEDULE
	| SCHEDULES
	| SCHEMA
	| SCHEMAS
	| SCRUB
	| SEARCH
	| SECOND
	| SECURITY
	| SECURITY_BARRIER
	| SECURITY_INVOKER
	| SEED
	| SEND
	| SEQUENCE
	| SEQUENCES
	| SERIALFUNC
	| SERIALIZABLE
	| SERVER
	| SESSION
	| SESSIONS
	| SET /*2N*/
	| SETTING
	| SETTINGS
	| SFUNC
	| SHARE
	| SHAREABLE
	| SHOW
	| SIMPLE
	| SKIP
	| SKIP_DATABASE_STATS
	| SKIP_LOCKED
	| SKIP_MISSING_FOREIGN_KEYS
	| SKIP_MISSING_SEQUENCES
	| SKIP_MISSING_SEQUENCE_OWNERS
	| SKIP_MISSING_VIEWS
	| SNAPSHOT
	| SORTOP
	| SPLIT
	| SQL
	| SSPACE
	| STABLE
	| START
	| STATEMENT
	| STATISTICS
	| STATUS
	| STDIN
	| STORAGE
	| STORE
	| STORED
	| STRATEGY
	| STRICT
	| STYPE
	| SUBSCRIPT
	| SUBSCRIPTION
	| SUBTYPE
	| SUBTYPE_DIFF
	| SUBTYPE_OPCLASS
	| SUPERUSER
	| SUPPORT
	| SYNTAX
	| SYSID
	| SYSTEM
	| TABLES
	| TABLESPACE
	| TEMP
	| TEMPLATE
	| TEMPORARY
	| TEXT
	| THROTTLING
	| TIES
	| TRACE
	| TRANSACTION
	| TRANSACTIONS
	| TRANSFORM
	| TRIGGER
	| TRUNCATE
	| TRUSTED
	| TYPE
	| TYPES
	| TYPMOD_IN
	| TYPMOD_OUT
	| UNBOUNDED /*15N*/
	| UNCOMMITTED
	| UNKNOWN
	| UNLOGGED
	| UNSAFE
	| UNSPLIT
	| UNTIL
	| UPDATE
	| UPSERT
	| USAGE
	| USE
	| USERS
	| VACUUM
	| VALID
	| VALIDATE
	| VALIDATOR
	| VALUE
	| VARIABLE
	| VARYING
	| VERSION
	| VIEW
	| VIEWACTIVITY
	| WITHIN
	| WITHOUT
	| WRITE
	| XML
	| YAML
	| YEAR
	| YES
	| ZONE
	;

col_name_keyword :
	ANNOTATE_TYPE
	| BETWEEN /*10N*/
	| BIGINT
	| BIT
	| BOOLEAN
	| BOX2D
	| CHAR
	| CHARACTER
	| CHARACTERISTICS
	| COALESCE
	| DEC
	| DECIMAL
	| EXISTS
	| EXTRACT
	| EXTRACT_DURATION
	| FLOAT
	| GEOGRAPHY
	| GEOMETRY
	| GREATEST
	| GROUPING
	| IF
	| IFERROR
	| IFNULL
	| INOUT
	| INT
	| INTEGER
	| INTERVAL
	| ISERROR
	| LEAST
	| NULLIF
	| NUMERIC
	| OUT
	| OVERLAY
	| POINT
	| POLYGON
	| POSITION
	| PRECISION
	| REAL
	| ROW
	| SETOF
	| SMALLINT
	| STRING
	| SUBSTRING
	| TIME
	| TIMETZ
	| TIMESTAMP
	| TIMESTAMPTZ
	| TREAT
	| TRIM
	| VALUES /*1N*/
	| VARBIT
	| VARCHAR
	| VIRTUAL
	| VOLATILE
	| WORK
	;

type_func_name_keyword :
	type_func_name_no_crdb_extra_keyword
	;

type_func_name_no_crdb_extra_keyword :
	AUTHORIZATION
	| COLLATION
	| CROSS /*35L*/
	| FULL /*35L*/
	| INNER /*35L*/
	| ILIKE /*10N*/
	| IS /*8N*/
	| ISNULL /*8N*/
	| JOIN /*35L*/
	| LEFT /*35L*/
	| LIKE /*10N*/
	| NATURAL /*35L*/
	| NONE
	| NOTNULL /*8N*/
	| OUTER
	| OVERLAPS /*13N*/
	| RIGHT /*35L*/
	| SIMILAR /*10N*/
	;

reserved_keyword :
	ALL
	| ANALYSE
	| ANALYZE
	| AND /*6L*/
	| ANY
	| ARRAY
	| AS
	| ASC
	| ASYMMETRIC
	| BOTH
	| CASE
	| CAST
	| CHECK
	| COLLATE /*28L*/
	| COLUMN
	| CONCURRENTLY
	| CONNECT
	| CONSTRAINT
	| CREATE
	| CURRENT_CATALOG
	| CURRENT_DATE
	| CURRENT_ROLE
	| CURRENT_SCHEMA
	| CURRENT_TIME
	| CURRENT_TIMESTAMP
	| CURRENT_USER
	| DEFAULT
	| DEFERRABLE /*10N*/
	| DESC
	| DESCRIBE
	| DISTINCT
	| DO
	| ELEMENT
	| ELSE
	| END
	| EXCEPT /*3L*/
	| FALSE
	| FETCH
	| FOR
	| FOREIGN
	| FREEZE
	| FROM
	| GRANT
	| GROUP
	| HAVING
	| IN /*10N*/
	| INITIALLY
	| INTERSECT /*4L*/
	| INTO
	| LATERAL
	| LEADING
	| LIMIT
	| LOCALTIME
	| LOCALTIMESTAMP
	| NOT /*7R*/
	| NULL /*16N*/
	| OFFSET
	| ON
	| ONLY
	| OR /*5L*/
	| ORDER
	| PLACING
	| PRIMARY
	| REFERENCES
	| RETURNING
	| SELECT
	| SESSION_USER
	| SOME
	| SYMMETRIC
	| TABLE
	| THEN
	| TO
	| TRAILING
	| TRUE
	| UNION /*3L*/
	| UNIQUE
	| USER
	| USING
	| VARIADIC
	| VERBOSE
	| WHEN
	| WHERE
	| WINDOW
	| WITH
	| WRAPPER
	| cockroachdb_extra_reserved_keyword
	;

cockroachdb_extra_reserved_keyword :
	INDEX
	| NOTHING
	;

%%

%option caseless

%x xdolq

dolq_start		[A-Za-z\200-\377_]
dolq_cont		[A-Za-z\200-\377_0-9]
dolqdelim		\$({dolq_start}{dolq_cont}*)?\$

ident_start		[A-Za-z\200-\377_]
ident_cont		[A-Za-z\200-\377_0-9\$]

identifier		{ident_start}{ident_cont}*

/*
 * Numbers
 *
 * Unary minus is not part of a number here.  Instead we pass it separately to
 * the parser, and there it gets coerced via doNegate().
 *
 * {decimalfail} is used because we would like "1..10" to lex as 1, dot_dot, 10.
 *
 * {realfail} is added to prevent the need for scanner
 * backup when the {real} rule fails to match completely.
 */
digit			[0-9]

integer			{digit}+
decimal			(({digit}*\.{digit}+)|({digit}+\.{digit}*))
real			({integer}|{decimal})[Ee][-+]?{digit}+

param			\${integer}

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

/* Assorted special-case operators and operator-like tokens */
typecast		"::"
dot_dot			\.\.
colon_equals	":="

%%

[ \t\r\n]+	skip()
"--".*	skip()
"/*"(?s:.)*?"*/"	skip()

"#"	'#'
"%"	'%'
"&"	'&'
"("	'('
")"	')'
"*"	'*'
"+"	'+'
","	','
"-"	'-'
"."	'.'
"/"	'/'
":"	':'
";"	';'
"<"	'<'
"="	'='
">"	'>'
"?"	'?'
"@"	'@'
"["	'['
"]"	']'
"^"	'^'
"f"	'f'
"n"	'n'
"t"	't'
"y"	'y'
"{"	'{'
"|"	'|'
"}"	'}'
"~"	'~'

ABORT	ABORT
ACCESS	ACCESS
ACTION	ACTION
ADD	ADD
ADMIN	ADMIN
AFTER	AFTER
AGGREGATE	AGGREGATE
ALIGNMENT	ALIGNMENT
ALL	ALL
ALLOW_CONNECTIONS	ALLOW_CONNECTIONS
ALTER	ALTER
ALWAYS	ALWAYS
ANALYSE	ANALYSE
ANALYZE	ANALYZE
AND	AND
AND_AND	AND_AND
ANNOTATE_TYPE	ANNOTATE_TYPE
ANY	ANY
ARRAY	ARRAY
AS	AS
ASC	ASC
ASYMMETRIC	ASYMMETRIC
AS_LA	AS_LA
AT	AT
ATOMIC	ATOMIC
ATTACH	ATTACH
ATTRIBUTE	ATTRIBUTE
AUTHORIZATION	AUTHORIZATION
AUTO	AUTO
AUTOMATIC	AUTOMATIC
BACKUP	BACKUP
BACKUPS	BACKUPS
BASETYPE	BASETYPE
BEFORE	BEFORE
BEGIN	BEGIN
BETWEEN	BETWEEN
BIGINT	BIGINT
//BIGSERIAL	BIGSERIAL
BINARY	BINARY
BIT	BIT
BITCONST	BITCONST
BOOLEAN	BOOLEAN
BOTH	BOTH
BOX2D	BOX2D
BUCKET_COUNT	BUCKET_COUNT
BUFFER_USAGE_LIMIT	BUFFER_USAGE_LIMIT
BUNDLE	BUNDLE
BY	BY
BYPASSRLS	BYPASSRLS
CACHE	CACHE
CALL	CALL
CALLED	CALLED
CANCEL	CANCEL
CANCELQUERY	CANCELQUERY
CANONICAL	CANONICAL
CASCADE	CASCADE
CASCADED	CASCADED
CASE	CASE
CAST	CAST
CATEGORY	CATEGORY
CBRT	CBRT
CHAIN	CHAIN
CHANGEFEED	CHANGEFEED
CHAR	CHAR
CHARACTER	CHARACTER
CHARACTERISTICS	CHARACTERISTICS
CHECK	CHECK
CHECK_OPTION	CHECK_OPTION
CLASS	CLASS
CLOSE	CLOSE
CLUSTER	CLUSTER
COALESCE	COALESCE
COLLATABLE	COLLATABLE
COLLATE	COLLATE
COLLATION	COLLATION
COLLATION_VERSION	COLLATION_VERSION
COLUMN	COLUMN
COLUMNS	COLUMNS
COMBINEFUNC	COMBINEFUNC
COMMENT	COMMENT
COMMENTS	COMMENTS
COMMIT	COMMIT
COMMITTED	COMMITTED
COMPACT	COMPACT
COMPLETE	COMPLETE
COMPRESSION	COMPRESSION
CONCAT	CONCAT
CONCURRENTLY	CONCURRENTLY
CONFIGURATION	CONFIGURATION
CONFIGURATIONS	CONFIGURATIONS
CONFIGURE	CONFIGURE
CONFLICT	CONFLICT
CONNECT	CONNECT
CONNECTION	CONNECTION
CONSTRAINT	CONSTRAINT
CONSTRAINTS	CONSTRAINTS
CONTAINED_BY	CONTAINED_BY
CONTAINS	CONTAINS
CONTROLCHANGEFEED	CONTROLCHANGEFEED
CONTROLJOB	CONTROLJOB
CONVERSION	CONVERSION
CONVERT	CONVERT
COPY	COPY
COST	COST
CREATE	CREATE
CREATEDB	CREATEDB
CREATELOGIN	CREATELOGIN
CREATEROLE	CREATEROLE
CROSS	CROSS
CSV	CSV
CUBE	CUBE
CURRENT	CURRENT
CURRENT_CATALOG	CURRENT_CATALOG
CURRENT_DATE	CURRENT_DATE
CURRENT_ROLE	CURRENT_ROLE
CURRENT_SCHEMA	CURRENT_SCHEMA
CURRENT_TIME	CURRENT_TIME
CURRENT_TIMESTAMP	CURRENT_TIMESTAMP
CURRENT_USER	CURRENT_USER
CYCLE	CYCLE
DATA	DATA
DATABASE	DATABASE
DATABASES	DATABASES
DATE	DATE
DAY	DAY
DEALLOCATE	DEALLOCATE
DEC	DEC
DECIMAL	DECIMAL
DECLARE	DECLARE
DEFAULT	DEFAULT
DEFAULTS	DEFAULTS
DEFERRABLE	DEFERRABLE
DEFERRED	DEFERRED
DEFINER	DEFINER
DELETE	DELETE
DELIMITER	DELIMITER
DEPENDS	DEPENDS
DESC	DESC
DESCRIBE	DESCRIBE
DESERIALFUNC	DESERIALFUNC
DESTINATION	DESTINATION
DETACH	DETACH
DETACHED	DETACHED
DICTIONARY	DICTIONARY
DISABLE	DISABLE
DISABLE_PAGE_SKIPPING	DISABLE_PAGE_SKIPPING
DISCARD	DISCARD
DISTINCT	DISTINCT
DO	DO
DOMAIN	DOMAIN
//DOT_DOT	DOT_DOT
DOUBLE	DOUBLE
DROP	DROP
EACH	EACH
ELEMENT	ELEMENT
ELSE	ELSE
ENABLE	ENABLE
ENCODING	ENCODING
ENCRYPTED	ENCRYPTED
ENCRYPTION_PASSPHRASE	ENCRYPTION_PASSPHRASE
END	END
ENUM	ENUM
ENUMS	ENUMS
//ERROR	ERROR
ESCAPE	ESCAPE
EVENT	EVENT
EXCEPT	EXCEPT
EXCLUDE	EXCLUDE
EXCLUDING	EXCLUDING
EXECUTE	EXECUTE
EXECUTION	EXECUTION
EXISTS	EXISTS
EXPERIMENTAL	EXPERIMENTAL
EXPERIMENTAL_AUDIT	EXPERIMENTAL_AUDIT
EXPERIMENTAL_FINGERPRINTS	EXPERIMENTAL_FINGERPRINTS
EXPERIMENTAL_REPLICA	EXPERIMENTAL_REPLICA
EXPIRATION	EXPIRATION
EXPLAIN	EXPLAIN
EXPORT	EXPORT
EXPRESSION	EXPRESSION
EXTENDED	EXTENDED
EXTENSION	EXTENSION
EXTERNAL	EXTERNAL
EXTRACT	EXTRACT
EXTRACT_DURATION	EXTRACT_DURATION
FALSE	FALSE
FAMILY	FAMILY
FETCH	FETCH
FETCHTEXT	FETCHTEXT
FETCHTEXT_PATH	FETCHTEXT_PATH
FETCHVAL	FETCHVAL
FETCHVAL_PATH	FETCHVAL_PATH
FILES	FILES
FILTER	FILTER
FINALFUNC	FINALFUNC
FINALFUNC_EXTRA	FINALFUNC_EXTRA
FINALFUNC_MODIFY	FINALFUNC_MODIFY
FINALIZE	FINALIZE
FIRST	FIRST
FLOAT	FLOAT
//FLOAT4	FLOAT4
//FLOAT8	FLOAT8
FLOORDIV	FLOORDIV
FOLLOWING	FOLLOWING
FOR	FOR
FORCE	FORCE
FORCE_INDEX	FORCE_INDEX
FOREIGN	FOREIGN
FORMAT	FORMAT
FREEZE	FREEZE
FROM	FROM
FULL	FULL
FUNCTION	FUNCTION
FUNCTIONS	FUNCTIONS
GENERATED	GENERATED
GENERATED_ALWAYS	GENERATED_ALWAYS
GEOGRAPHY	GEOGRAPHY
GEOMETRY	GEOMETRY
GEOMETRYCOLLECTION	GEOMETRYCOLLECTION
GEOMETRYCOLLECTIONM	GEOMETRYCOLLECTIONM
GEOMETRYCOLLECTIONZ	GEOMETRYCOLLECTIONZ
GEOMETRYCOLLECTIONZM	GEOMETRYCOLLECTIONZM
GEOMETRYM	GEOMETRYM
GEOMETRYZ	GEOMETRYZ
GEOMETRYZM	GEOMETRYZM
GLOBAL	GLOBAL
GRANT	GRANT
GRANTED	GRANTED
GRANTS	GRANTS
GREATEST	GREATEST
GROUP	GROUP
GROUPING	GROUPING
GROUPS	GROUPS
HANDLER	HANDLER
HASH	HASH
HAVING	HAVING
HEADER	HEADER
HELPTOKEN	HELPTOKEN
HIGH	HIGH
HISTOGRAM	HISTOGRAM
HOUR	HOUR
HYPOTHETICAL	HYPOTHETICAL
ICU_LOCALE	ICU_LOCALE
ICU_RULES	ICU_RULES
IDENTITY	IDENTITY
IF	IF
IFERROR	IFERROR
IFNULL	IFNULL
IGNORE_FOREIGN_KEYS	IGNORE_FOREIGN_KEYS
ILIKE	ILIKE
IMMEDIATE	IMMEDIATE
IMMUTABLE	IMMUTABLE
IMPORT	IMPORT
IN	IN
INCLUDE	INCLUDE
INCLUDING	INCLUDING
INCREMENT	INCREMENT
INCREMENTAL	INCREMENTAL
INDEX	INDEX
INDEXES	INDEXES
INDEX_CLEANUP	INDEX_CLEANUP
//INET	INET
INET_CONTAINED_BY_OR_EQUALS	INET_CONTAINED_BY_OR_EQUALS
INET_CONTAINS_OR_EQUALS	INET_CONTAINS_OR_EQUALS
INHERIT	INHERIT
INHERITS	INHERITS
INITCOND	INITCOND
INITIALLY	INITIALLY
INJECT	INJECT
INLINE	INLINE
INNER	INNER
INOUT	INOUT
INPUT	INPUT
INSERT	INSERT
INSTEAD	INSTEAD
INT	INT
INTEGER	INTEGER
INTERLEAVE	INTERLEAVE
INTERNALLENGTH	INTERNALLENGTH
INTERSECT	INTERSECT
INTERVAL	INTERVAL
INTO	INTO
INTO_DB	INTO_DB
INVERTED	INVERTED
INVOKER	INVOKER
IS	IS
ISERROR	ISERROR
ISNULL	ISNULL
ISOLATION	ISOLATION
IS_TEMPLATE	IS_TEMPLATE
JOB	JOB
JOBS	JOBS
JOIN	JOIN
JSON	JSON
//JSONB	JSONB
JSON_ALL_EXISTS	JSON_ALL_EXISTS
JSON_SOME_EXISTS	JSON_SOME_EXISTS
KEY	KEY
KEYS	KEYS
KMS	KMS
KV	KV
LANGUAGE	LANGUAGE
LARGE	LARGE
LAST	LAST
LATERAL	LATERAL
LATEST	LATEST
LC_COLLATE	LC_COLLATE
LC_CTYPE	LC_CTYPE
LEADING	LEADING
LEAKPROOF	LEAKPROOF
LEASE	LEASE
LEAST	LEAST
LEFT	LEFT
LESS	LESS
LEVEL	LEVEL
LIKE	LIKE
LIMIT	LIMIT
LINESTRING	LINESTRING
//LINESTRINGM	LINESTRINGM
//LINESTRINGZ	LINESTRINGZ
//LINESTRINGZM	LINESTRINGZM
LIST	LIST
LOCAL	LOCAL
LOCALE	LOCALE
LOCALE_PROVIDER	LOCALE_PROVIDER
LOCALTIME	LOCALTIME
LOCALTIMESTAMP	LOCALTIMESTAMP
LOCKED	LOCKED
LOGGED	LOGGED
LOGIN	LOGIN
LOOKUP	LOOKUP
LOW	LOW
LSHIFT	LSHIFT
MAIN	MAIN
MATCH	MATCH
MATERIALIZED	MATERIALIZED
MAXVALUE	MAXVALUE
MERGE	MERGE
METHOD	METHOD
MFINALFUNC	MFINALFUNC
MFINALFUNC_EXTRA	MFINALFUNC_EXTRA
MFINALFUNC_MODIFY	MFINALFUNC_MODIFY
MINITCOND	MINITCOND
MINUTE	MINUTE
MINVALUE	MINVALUE
MINVFUNC	MINVFUNC
MODIFYCLUSTERSETTING	MODIFYCLUSTERSETTING
MODULUS	MODULUS
MONTH	MONTH
MSFUNC	MSFUNC
MSPACE	MSPACE
MSSPACE	MSSPACE
MSTYPE	MSTYPE
MULTILINESTRING	MULTILINESTRING
MULTILINESTRINGM	MULTILINESTRINGM
MULTILINESTRINGZ	MULTILINESTRINGZ
MULTILINESTRINGZM	MULTILINESTRINGZM
MULTIPOINT	MULTIPOINT
MULTIPOINTM	MULTIPOINTM
MULTIPOINTZ	MULTIPOINTZ
MULTIPOINTZM	MULTIPOINTZM
MULTIPOLYGON	MULTIPOLYGON
MULTIPOLYGONM	MULTIPOLYGONM
MULTIPOLYGONZ	MULTIPOLYGONZ
MULTIPOLYGONZM	MULTIPOLYGONZM
MULTIRANGE_TYPE_NAME	MULTIRANGE_TYPE_NAME
//NAME	NAME
NAMES	NAMES
NAN	NAN
NATURAL	NATURAL
NEVER	NEVER
NEW	NEW
NEXT	NEXT
NO	NO
NOBYPASSRLS	NOBYPASSRLS
NOCANCELQUERY	NOCANCELQUERY
NOCONTROLCHANGEFEED	NOCONTROLCHANGEFEED
NOCONTROLJOB	NOCONTROLJOB
NOCREATEDB	NOCREATEDB
NOCREATELOGIN	NOCREATELOGIN
NOCREATEROLE	NOCREATEROLE
NOINHERIT	NOINHERIT
NOLOGIN	NOLOGIN
NOMODIFYCLUSTERSETTING	NOMODIFYCLUSTERSETTING
NONE	NONE
NOREPLICATION	NOREPLICATION
NORMAL	NORMAL
NOSUPERUSER	NOSUPERUSER
NOT	NOT
NOTHING	NOTHING
NOTNULL	NOTNULL
NOT_LA	NOT_LA
NOT_REGIMATCH	NOT_REGIMATCH
NOT_REGMATCH	NOT_REGMATCH
NOVIEWACTIVITY	NOVIEWACTIVITY
NOWAIT	NOWAIT
NO_INDEX_JOIN	NO_INDEX_JOIN
NULL	NULL
NULLIF	NULLIF
NULLS	NULLS
NUMERIC	NUMERIC
OBJECT	OBJECT
OF	OF
OFF	OFF
OFFSET	OFFSET
OID	OID
OIDS	OIDS
//OIDVECTOR	OIDVECTOR
OLD	OLD
ON	ON
ONLY	ONLY
ONLY_DATABASE_STATS	ONLY_DATABASE_STATS
OPERATOR	OPERATOR
OPT	OPT
OPTION	OPTION
OPTIONS	OPTIONS
OR	OR
ORDER	ORDER
ORDINALITY	ORDINALITY
OTHERS	OTHERS
OUT	OUT
OUTER	OUTER
OUTPUT	OUTPUT
OVER	OVER
OVERLAPS	OVERLAPS
OVERLAY	OVERLAY
OWNED	OWNED
OWNER	OWNER
PARALLEL	PARALLEL
PARENT	PARENT
PARSER	PARSER
PARTIAL	PARTIAL
PARTITION	PARTITION
PARTITIONS	PARTITIONS
PASSEDBYVALUE	PASSEDBYVALUE
PASSWORD	PASSWORD
PAUSE	PAUSE
PAUSED	PAUSED
PHYSICAL	PHYSICAL
PLACEHOLDER	PLACEHOLDER
PLACING	PLACING
PLAIN	PLAIN
PLAN	PLAN
PLANS	PLANS
POINT	POINT
POINTM	POINTM
POINTZ	POINTZ
POINTZM	POINTZM
POLICY	POLICY
POLYGON	POLYGON
POLYGONM	POLYGONM
POLYGONZ	POLYGONZ
POLYGONZM	POLYGONZM
POSITION	POSITION
//POSTFIXOP	POSTFIXOP
PRECEDING	PRECEDING
PRECISION	PRECISION
PREFERRED	PREFERRED
PREPARE	PREPARE
PRESERVE	PRESERVE
PRIMARY	PRIMARY
PRIORITY	PRIORITY
PRIVILEGES	PRIVILEGES
PROCEDURAL	PROCEDURAL
PROCEDURE	PROCEDURE
PROCEDURES	PROCEDURES
PROCESS_MAIN	PROCESS_MAIN
PROCESS_TOAST	PROCESS_TOAST
PUBLIC	PUBLIC
PUBLICATION	PUBLICATION
QUERIES	QUERIES
QUERY	QUERY
RANGE	RANGE
RANGES	RANGES
READ	READ
READ_ONLY	READ_ONLY
READ_WRITE	READ_WRITE
REAL	REAL
RECEIVE	RECEIVE
RECURRING	RECURRING
RECURSIVE	RECURSIVE
REF	REF
REFERENCES	REFERENCES
REFERENCING	REFERENCING
REFRESH	REFRESH
//REGCLASS	REGCLASS
REGIMATCH	REGIMATCH
//REGNAMESPACE	REGNAMESPACE
//REGPROC	REGPROC
//REGPROCEDURE	REGPROCEDURE
//REGTYPE	REGTYPE
REINDEX	REINDEX
RELEASE	RELEASE
REMAINDER	REMAINDER
REMOVE_PATH	REMOVE_PATH
RENAME	RENAME
REPEATABLE	REPEATABLE
REPLACE	REPLACE
REPLICA	REPLICA
REPLICATION	REPLICATION
RESET	RESET
RESTART	RESTART
RESTORE	RESTORE
RESTRICT	RESTRICT
RESTRICTED	RESTRICTED
RESUME	RESUME
RETRY	RETRY
RETURN	RETURN
RETURNING	RETURNING
RETURNS	RETURNS
REVISION_HISTORY	REVISION_HISTORY
REVOKE	REVOKE
RIGHT	RIGHT
ROLE	ROLE
ROLES	ROLES
ROLLBACK	ROLLBACK
ROLLUP	ROLLUP
ROUTINE	ROUTINE
ROUTINES	ROUTINES
ROW	ROW
ROWS	ROWS
RSHIFT	RSHIFT
RULE	RULE
RUNNING	RUNNING
SAFE	SAFE
SAVEPOINT	SAVEPOINT
SCATTER	SCATTER
SCHEDULE	SCHEDULE
SCHEDULES	SCHEDULES
SCHEMA	SCHEMA
SCHEMAS	SCHEMAS
SCRUB	SCRUB
SEARCH	SEARCH
SECOND	SECOND
SECURITY	SECURITY
SECURITY_BARRIER	SECURITY_BARRIER
SECURITY_INVOKER	SECURITY_INVOKER
SEED	SEED
SELECT	SELECT
SEND	SEND
SEQUENCE	SEQUENCE
SEQUENCES	SEQUENCES
SERIALFUNC	SERIALFUNC
SERIALIZABLE	SERIALIZABLE
SERVER	SERVER
SESSION	SESSION
SESSIONS	SESSIONS
SESSION_USER	SESSION_USER
SET	SET
SETOF	SETOF
SETTING	SETTING
SETTINGS	SETTINGS
SFUNC	SFUNC
SHARE	SHARE
SHAREABLE	SHAREABLE
SHOW	SHOW
SIMILAR	SIMILAR
SIMPLE	SIMPLE
SKIP	SKIP
SKIP_DATABASE_STATS	SKIP_DATABASE_STATS
SKIP_LOCKED	SKIP_LOCKED
SKIP_MISSING_FOREIGN_KEYS	SKIP_MISSING_FOREIGN_KEYS
SKIP_MISSING_SEQUENCES	SKIP_MISSING_SEQUENCES
SKIP_MISSING_SEQUENCE_OWNERS	SKIP_MISSING_SEQUENCE_OWNERS
SKIP_MISSING_VIEWS	SKIP_MISSING_VIEWS
SMALLINT	SMALLINT
//SMALLSERIAL	SMALLSERIAL
SNAPSHOT	SNAPSHOT
SOME	SOME
SORTOP	SORTOP
SPLIT	SPLIT
SQL	SQL
SQRT	SQRT
SSPACE	SSPACE
STABLE	STABLE
START	START
STATEMENT	STATEMENT
STATISTICS	STATISTICS
STATUS	STATUS
STDIN	STDIN
STORAGE	STORAGE
STORE	STORE
STORED	STORED
STRATEGY	STRATEGY
STRICT	STRICT
STRING	STRING
STYPE	STYPE
SUBSCRIPT	SUBSCRIPT
SUBSCRIPTION	SUBSCRIPTION
SUBSTRING	SUBSTRING
SUBTYPE	SUBTYPE
SUBTYPE_DIFF	SUBTYPE_DIFF
SUBTYPE_OPCLASS	SUBTYPE_OPCLASS
SUPERUSER	SUPERUSER
SUPPORT	SUPPORT
SYMMETRIC	SYMMETRIC
SYNTAX	SYNTAX
SYSID	SYSID
SYSTEM	SYSTEM
TABLE	TABLE
TABLES	TABLES
TABLESPACE	TABLESPACE
TEMP	TEMP
TEMPLATE	TEMPLATE
TEMPORARY	TEMPORARY
TEXT	TEXT
TEXTSEARCHMATCH	TEXTSEARCHMATCH
THEN	THEN
THROTTLING	THROTTLING
TIES	TIES
TIME	TIME
TIMESTAMP	TIMESTAMP
TIMESTAMPTZ	TIMESTAMPTZ
TIMETZ	TIMETZ
TO	TO
TRACE	TRACE
//TRACING	TRACING
TRAILING	TRAILING
TRANSACTION	TRANSACTION
TRANSACTIONS	TRANSACTIONS
TRANSFORM	TRANSFORM
TREAT	TREAT
TRIGGER	TRIGGER
TRIM	TRIM
TRUE	TRUE
TRUNCATE	TRUNCATE
TRUSTED	TRUSTED
TYPE	TYPE
TYPEANNOTATE	TYPEANNOTATE
TYPES	TYPES
TYPMOD_IN	TYPMOD_IN
TYPMOD_OUT	TYPMOD_OUT
UMINUS	UMINUS
UNBOUNDED	UNBOUNDED
UNCOMMITTED	UNCOMMITTED
UNION	UNION
UNIQUE	UNIQUE
UNKNOWN	UNKNOWN
UNLOGGED	UNLOGGED
UNSAFE	UNSAFE
UNSPLIT	UNSPLIT
UNTIL	UNTIL
UPDATE	UPDATE
UPSERT	UPSERT
USAGE	USAGE
USE	USE
USER	USER
USERS	USERS
USING	USING
//UUID	UUID
VACUUM	VACUUM
VALID	VALID
VALIDATE	VALIDATE
VALIDATOR	VALIDATOR
VALUE	VALUE
VALUES	VALUES
VARBIT	VARBIT
VARCHAR	VARCHAR
VARIABLE	VARIABLE
VARIADIC	VARIADIC
VARYING	VARYING
VERBOSE	VERBOSE
VERSION	VERSION
VIEW	VIEW
VIEWACTIVITY	VIEWACTIVITY
VIRTUAL	VIRTUAL
VOLATILE	VOLATILE
WHEN	WHEN
WHERE	WHERE
WINDOW	WINDOW
WITH	WITH
WITHIN	WITHIN
WITHOUT	WITHOUT
WITH_LA	WITH_LA
WORK	WORK
WRAPPER	WRAPPER
WRITE	WRITE
XML	XML
YAML	YAML
YEAR	YEAR
YES	YES
ZONE	ZONE

{less_equals}	LESS_EQUALS
{greater_equals}	GREATER_EQUALS
!=|\<>	NOT_EQUALS
//{colon_equals}	COLON_EQUALS
//{equals_greater}	EQUALS_GREATER
{typecast}	TYPECAST


{real}	FCONST
{decimal} FCONST
'(\\['\\]|[^'\n\r])*'	SCONST

<INITIAL>{dolqdelim}<xdolq>
<xdolq>[^$]|\$[^$]<.>
<xdolq>{dolqdelim}<INITIAL> SCONST

BCONST	BCONST
[0-9]+	ICONST
{param}	PARAMETER

/* Order matter if identifier comes before keywords they are classified as identifier */
{identifier}	IDENT
\"(\\[\"\\]|[^\"\n\r])*\"	IDENT


%%
