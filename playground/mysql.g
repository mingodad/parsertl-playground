/*
   Copyright (c) 2000, 2023, Oracle and/or its affiliates.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License, version 2.0,
   as published by the Free Software Foundation.

   This program is also distributed with certain software (including
   but not limited to OpenSSL) that is licensed under separate terms,
   as designated in a particular file or component or in included license
   documentation.  The authors of MySQL hereby grant you an additional
   permission to link the program and your derivative works with the
   separately licensed software that they have included with MySQL.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License, version 2.0, for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA */

/* sql_yacc.yy */

%option caseless

/*Tokens*/
//%token ABORT_SYM
//%token ACCESSIBLE_SYM
%token ACCOUNT_SYM
%token ACTION
%token ADD
%token ADDDATE_SYM
%token AFTER_SYM
%token AGAINST
%token AGGREGATE_SYM
%token ALGORITHM_SYM
%token ALL
%token ALTER
%token ALWAYS_SYM
//%token OBSOLETE_TOKEN_271
%token ANALYZE_SYM
%token AND_AND_SYM
%token AND_SYM
%token ANY_SYM
%token AS
%token ASC
%token ASCII_SYM
//%token ASENSITIVE_SYM
%token AT_SYM
%token AUTOEXTEND_SIZE_SYM
%token AUTO_INC
%token AVG_ROW_LENGTH
%token AVG_SYM
%token BACKUP_SYM
%token BEFORE_SYM
%token BEGIN_SYM
%token BETWEEN_SYM
%token BIGINT_SYM
%token BINARY_SYM
%token BINLOG_SYM
%token BIN_NUM
%token BIT_AND_SYM
%token BIT_OR_SYM
%token BIT_SYM
%token BIT_XOR_SYM
%token BLOB_SYM
%token BLOCK_SYM
%token BOOLEAN_SYM
%token BOOL_SYM
%token BOTH
%token BTREE_SYM
%token BY
%token BYTE_SYM
%token CACHE_SYM
%token CALL_SYM
%token CASCADE
%token CASCADED
%token CASE_SYM
%token CAST_SYM
%token CATALOG_NAME_SYM
%token CHAIN_SYM
%token CHANGE
%token CHANGED
%token CHANNEL_SYM
%token CHARSET
%token CHAR_SYM
%token CHECKSUM_SYM
%token CHECK_SYM
%token CIPHER_SYM
%token CLASS_ORIGIN_SYM
%token CLIENT_SYM
%token CLOSE_SYM
%token COALESCE
%token CODE_SYM
%token COLLATE_SYM
%token COLLATION_SYM
%token COLUMNS
%token COLUMN_SYM
%token COLUMN_FORMAT_SYM
%token COLUMN_NAME_SYM
%token COMMENT_SYM
%token COMMITTED_SYM
%token COMMIT_SYM
%token COMPACT_SYM
%token COMPLETION_SYM
%token COMPRESSED_SYM
%token COMPRESSION_SYM
%token ENCRYPTION_SYM
%token CONCURRENT
%token CONDITION_SYM
%token CONNECTION_SYM
%token CONSISTENT_SYM
%token CONSTRAINT
%token CONSTRAINT_CATALOG_SYM
%token CONSTRAINT_NAME_SYM
%token CONSTRAINT_SCHEMA_SYM
%token CONTAINS_SYM
%token CONTEXT_SYM
%token CONTINUE_SYM
%token CONVERT_SYM
%token COUNT_SYM
%token CPU_SYM
%token CREATE
%token CROSS
//%token CUBE_SYM
%token CURDATE
%token CURRENT_SYM
%token CURRENT_USER
%token CURSOR_SYM
%token CURSOR_NAME_SYM
%token CURTIME
%token DATABASE
%token DATABASES
%token DATAFILE_SYM
%token DATA_SYM
%token DATETIME_SYM
%token DATE_ADD_INTERVAL
%token DATE_SUB_INTERVAL
%token DATE_SYM
%token DAY_HOUR_SYM
%token DAY_MICROSECOND_SYM
%token DAY_MINUTE_SYM
%token DAY_SECOND_SYM
%token DAY_SYM
%token DEALLOCATE_SYM
%token DECIMAL_NUM
%token DECIMAL_SYM
%token DECLARE_SYM
%token DEFAULT_SYM
%token DEFAULT_AUTH_SYM
%token DEFINER_SYM
%token DELAYED_SYM
%token DELAY_KEY_WRITE_SYM
%token DELETE_SYM
%token DESC
%token DESCRIBE
//%token OBSOLETE_TOKEN_388
%token DETERMINISTIC_SYM
%token DIAGNOSTICS_SYM
%token DIRECTORY_SYM
%token DISABLE_SYM
%token DISCARD_SYM
%token DISK_SYM
%token DISTINCT
%token DIV_SYM
%token DOUBLE_SYM
%token DO_SYM
%token DROP
%token DUAL_SYM
%token DUMPFILE
%token DUPLICATE_SYM
%token DYNAMIC_SYM
%token EACH_SYM
%token ELSE
%token ELSEIF_SYM
%token ENABLE_SYM
%token ENCLOSED
%token END
%token ENDS_SYM
//%token END_OF_INPUT
%token ENGINES_SYM
%token ENGINE_SYM
%token ENUM_SYM
%token EQ
%token EQUAL_SYM
%token ERROR_SYM
%token ERRORS
%token ESCAPED
%token ESCAPE_SYM
%token EVENTS_SYM
%token EVENT_SYM
%token EVERY_SYM
%token EXCHANGE_SYM
%token EXECUTE_SYM
%token EXISTS
%token EXIT_SYM
%token EXPANSION_SYM
%token EXPIRE_SYM
%token EXPORT_SYM
%token EXTENDED_SYM
%token EXTENT_SIZE_SYM
%token EXTRACT_SYM
%token FALSE_SYM
%token FAST_SYM
%token FAULTS_SYM
%token FETCH_SYM
%token FILE_SYM
%token FILE_BLOCK_SIZE_SYM
%token FILTER_SYM
%token FIRST_SYM
%token FIXED_SYM
%token FLOAT_NUM
%token FLOAT_SYM
%token FLUSH_SYM
%token FOLLOWS_SYM
%token FORCE_SYM
%token FOREIGN
%token FOR_SYM
%token FORMAT_SYM
%token FOUND_SYM
%token FROM
%token FULL
%token FULLTEXT_SYM
%token FUNCTION_SYM
%token GE
%token GENERAL
%token GENERATED
%token GROUP_REPLICATION
%token GEOMETRYCOLLECTION_SYM
%token GEOMETRY_SYM
%token GET_FORMAT
%token GET_SYM
%token GLOBAL_SYM
%token GRANT
%token GRANTS
%token GROUP_SYM
%token GROUP_CONCAT_SYM
%token GT_SYM
%token HANDLER_SYM
%token HASH_SYM
%token HAVING
%token HELP_SYM
%token HEX_NUM
%token HIGH_PRIORITY
%token HOST_SYM
%token HOSTS_SYM
%token HOUR_MICROSECOND_SYM
%token HOUR_MINUTE_SYM
%token HOUR_SECOND_SYM
%token HOUR_SYM
%token IDENT
%token IDENTIFIED_SYM
%token IDENT_QUOTED
%token IF
%token IGNORE_SYM
%token IGNORE_SERVER_IDS_SYM
%token IMPORT
%token INDEXES
%token INDEX_SYM
%token INFILE_SYM
%token INITIAL_SIZE_SYM
%token INNER_SYM
%token INOUT_SYM
//%token INSENSITIVE_SYM
%token INSERT_SYM
%token INSERT_METHOD
%token INSTANCE_SYM
%token INSTALL_SYM
%token INTERVAL_SYM
%token INTO
%token INT_SYM
%token INVOKER_SYM
%token IN_SYM
//%token IO_AFTER_GTIDS
//%token IO_BEFORE_GTIDS
%token IO_SYM
%token IPC_SYM
%token IS
%token ISOLATION
%token ISSUER_SYM
%token ITERATE_SYM
%token JOIN_SYM
%token JSON_SEPARATOR_SYM
%token JSON_SYM
%token KEYS
%token KEY_BLOCK_SIZE
%token KEY_SYM
%token KILL_SYM
%token LANGUAGE_SYM
%token LAST_SYM
%token LE
%token LEADING
%token LEAVES
%token LEAVE_SYM
%token LEFT
%token LESS_SYM
%token LEVEL_SYM
%token LEX_HOSTNAME
%token LIKE
%token LIMIT
%token LINEAR_SYM
%token LINES
%token LINESTRING_SYM
%token LIST_SYM
%token LOAD
%token LOCAL_SYM
//%token OBSOLETE_TOKEN_538
%token LOCKS_SYM
%token LOCK_SYM
%token LOGFILE_SYM
%token LOGS_SYM
%token LONGBLOB_SYM
%token LONGTEXT_SYM
%token LONG_NUM
%token LONG_SYM
%token LOOP_SYM
%token LOW_PRIORITY
%token LT
%token MASTER_AUTO_POSITION_SYM
%token MASTER_BIND_SYM
%token MASTER_CONNECT_RETRY_SYM
%token MASTER_DELAY_SYM
%token MASTER_HOST_SYM
%token MASTER_LOG_FILE_SYM
%token MASTER_LOG_POS_SYM
%token MASTER_PASSWORD_SYM
%token MASTER_PORT_SYM
%token MASTER_RETRY_COUNT_SYM
%token MASTER_SSL_CAPATH_SYM
%token MASTER_TLS_VERSION_SYM
%token MASTER_SSL_CA_SYM
%token MASTER_SSL_CERT_SYM
%token MASTER_SSL_CIPHER_SYM
%token MASTER_SSL_CRL_SYM
%token MASTER_SSL_CRLPATH_SYM
%token MASTER_SSL_KEY_SYM
%token MASTER_SSL_SYM
%token MASTER_SSL_VERIFY_SERVER_CERT_SYM
%token MASTER_SYM
%token MASTER_USER_SYM
%token MASTER_HEARTBEAT_PERIOD_SYM
%token MATCH
%token MAX_CONNECTIONS_PER_HOUR
%token MAX_QUERIES_PER_HOUR
%token MAX_ROWS
%token MAX_SIZE_SYM
%token MAX_SYM
%token MAX_UPDATES_PER_HOUR
%token MAX_USER_CONNECTIONS_SYM
%token MAX_VALUE_SYM
%token MEDIUMBLOB_SYM
%token MEDIUMINT_SYM
%token MEDIUMTEXT_SYM
%token MEDIUM_SYM
%token MEMORY_SYM
%token MERGE_SYM
%token MESSAGE_TEXT_SYM
%token MICROSECOND_SYM
%token MIGRATE_SYM
%token MINUTE_MICROSECOND_SYM
%token MINUTE_SECOND_SYM
%token MINUTE_SYM
%token MIN_ROWS
%token MIN_SYM
%token MODE_SYM
%token MODIFIES_SYM
%token MODIFY_SYM
%token MOD_SYM
%token MONTH_SYM
%token MULTILINESTRING_SYM
%token MULTIPOINT_SYM
%token MULTIPOLYGON_SYM
%token MUTEX_SYM
%token MYSQL_ERRNO_SYM
%token NAMES_SYM
%token NAME_SYM
%token NATIONAL_SYM
%token NATURAL
%token NCHAR_STRING
%token NCHAR_SYM
%token NDBCLUSTER_SYM
%token NE
%token NEVER_SYM
%token NEW_SYM
%token NEXT_SYM
%token NODEGROUP_SYM
%token NONE_SYM
%token NOT2_SYM
%token NOT_SYM
%token NOW_SYM
%token NO_SYM
%token NO_WAIT_SYM
%token NO_WRITE_TO_BINLOG
%token NULL_SYM
%token NUM
%token NUMBER_SYM
%token NUMERIC_SYM
%token NVARCHAR_SYM
%token OFFSET_SYM
%token ON_SYM
%token ONE_SYM
%token ONLY_SYM
%token OPEN_SYM
%token OPTIMIZE
%token OPTIMIZER_COSTS_SYM
%token OPTIONS_SYM
%token OPTION
%token OPTIONALLY
%token OR2_SYM
%token ORDER_SYM
%token OR_OR_SYM
%token OR_SYM
%token OUTER_SYM
%token OUTFILE
%token OUT_SYM
%token OWNER_SYM
%token PACK_KEYS_SYM
%token PAGE_SYM
%token PARAM_MARKER
%token PARSER_SYM
//%token OBSOLETE_TOKEN_654
%token PARTIAL
%token PARTITION_SYM
%token PARTITIONS_SYM
%token PARTITIONING_SYM
%token PASSWORD
%token PHASE_SYM
%token PLUGIN_DIR_SYM
%token PLUGIN_SYM
%token PLUGINS_SYM
%token POINT_SYM
%token POLYGON_SYM
%token PORT_SYM
%token POSITION_SYM
%token PRECEDES_SYM
%token PRECISION
%token PREPARE_SYM
%token PRESERVE_SYM
%token PREV_SYM
%token PRIMARY_SYM
%token PRIVILEGES
%token PROCEDURE_SYM
%token PROCESS
%token PROCESSLIST_SYM
%token PROFILE_SYM
%token PROFILES_SYM
%token PROXY_SYM
%token PURGE
%token QUARTER_SYM
%token QUERY_SYM
%token QUICK
%token RANGE_SYM
%token READS_SYM
%token READ_ONLY_SYM
%token READ_SYM
//%token READ_WRITE_SYM
%token REAL_SYM
%token REBUILD_SYM
%token RECOVER_SYM
//%token OBSOLETE_TOKEN_693
%token REDO_BUFFER_SIZE_SYM
%token REDUNDANT_SYM
%token REFERENCES
%token REGEXP
%token RELAY
%token RELAYLOG_SYM
%token RELAY_LOG_FILE_SYM
%token RELAY_LOG_POS_SYM
%token RELAY_THREAD
%token RELEASE_SYM
%token RELOAD
%token REMOVE_SYM
%token RENAME
%token REORGANIZE_SYM
%token REPAIR
%token REPEATABLE_SYM
%token REPEAT_SYM
%token REPLACE_SYM
%token REPLICATION
%token REPLICATE_DO_DB
%token REPLICATE_IGNORE_DB
%token REPLICATE_DO_TABLE
%token REPLICATE_IGNORE_TABLE
%token REPLICATE_WILD_DO_TABLE
%token REPLICATE_WILD_IGNORE_TABLE
%token REPLICATE_REWRITE_DB
%token REQUIRE_SYM
%token RESET_SYM
%token RESIGNAL_SYM
%token RESOURCES
%token RESTORE_SYM
%token RESTRICT
%token RESUME_SYM
%token RETURNED_SQLSTATE_SYM
%token RETURNS_SYM
%token RETURN_SYM
%token REVERSE_SYM
%token REVOKE
%token RIGHT
%token ROLLBACK_SYM
%token ROLLUP_SYM
%token ROTATE_SYM
%token ROUTINE_SYM
%token ROWS_SYM
%token ROW_FORMAT_SYM
%token ROW_SYM
%token ROW_COUNT_SYM
%token RTREE_SYM
%token SAVEPOINT_SYM
%token SCHEDULE_SYM
%token SCHEMA_NAME_SYM
%token SECOND_MICROSECOND_SYM
%token SECOND_SYM
%token SECURITY_SYM
%token SELECT_SYM
//%token SENSITIVE_SYM
%token SEPARATOR_SYM
%token SERIALIZABLE_SYM
%token SERIAL_SYM
%token SESSION_SYM
%token SERVER_SYM
//%token OBSOLETE_TOKEN_755
%token SET_SYM
%token SET_VAR
%token SHARE_SYM
%token SHIFT_LEFT
%token SHIFT_RIGHT
%token SHOW
%token SHUTDOWN
%token SIGNAL_SYM
%token SIGNED_SYM
%token SIMPLE_SYM
%token SLAVE
%token SLOW
%token SMALLINT_SYM
%token SNAPSHOT_SYM
%token SOCKET_SYM
%token SONAME_SYM
%token SOUNDS_SYM
%token SOURCE_SYM
%token SPATIAL_SYM
//%token SPECIFIC_SYM
%token SQLEXCEPTION_SYM
%token SQLSTATE_SYM
%token SQLWARNING_SYM
%token SQL_AFTER_GTIDS
%token SQL_AFTER_MTS_GAPS
%token SQL_BEFORE_GTIDS
%token SQL_BIG_RESULT
%token SQL_BUFFER_RESULT
//%token OBSOLETE_TOKEN_784
%token SQL_CALC_FOUND_ROWS
%token SQL_NO_CACHE_SYM
%token SQL_SMALL_RESULT
%token SQL_SYM
%token SQL_THREAD
%token SSL_SYM
%token STACKED_SYM
%token STARTING
%token STARTS_SYM
%token START_SYM
%token STATS_AUTO_RECALC_SYM
%token STATS_PERSISTENT_SYM
%token STATS_SAMPLE_PAGES_SYM
%token STATUS_SYM
%token STDDEV_SAMP_SYM
%token STD_SYM
%token STOP_SYM
%token STORAGE_SYM
%token STORED_SYM
%token STRAIGHT_JOIN
%token STRING_SYM
%token SUBCLASS_ORIGIN_SYM
%token SUBDATE_SYM
%token SUBJECT_SYM
%token SUBPARTITIONS_SYM
%token SUBPARTITION_SYM
%token SUBSTRING
%token SUM_SYM
%token SUPER_SYM
%token SUSPEND_SYM
%token SWAPS_SYM
%token SWITCHES_SYM
%token SYSDATE
%token TABLES
%token TABLESPACE_SYM
//%token OBSOLETE_TOKEN_820
%token TABLE_SYM
%token TABLE_CHECKSUM_SYM
%token TABLE_NAME_SYM
%token TEMPORARY
%token TEMPTABLE_SYM
%token TERMINATED
%token TEXT_STRING
%token TEXT_SYM
%token THAN_SYM
%token THEN_SYM
%token TIMESTAMP_SYM
%token TIMESTAMP_ADD
%token TIMESTAMP_DIFF
%token TIME_SYM
%token TINYBLOB_SYM
%token TINYINT_SYM
%token TINYTEXT_SYN
%token TO_SYM
%token TRAILING
%token TRANSACTION_SYM
%token TRIGGERS_SYM
%token TRIGGER_SYM
%token TRIM
%token TRUE_SYM
%token TRUNCATE_SYM
%token TYPES_SYM
%token TYPE_SYM
//%token OBSOLETE_TOKEN_848
%token ULONGLONG_NUM
%token UNCOMMITTED_SYM
%token UNDEFINED_SYM
%token UNDERSCORE_CHARSET
%token UNDOFILE_SYM
%token UNDO_BUFFER_SIZE_SYM
%token UNDO_SYM
%token UNICODE_SYM
%token UNINSTALL_SYM
%token UNION_SYM
%token UNIQUE_SYM
%token UNKNOWN_SYM
%token UNLOCK_SYM
%token UNSIGNED_SYM
%token UNTIL_SYM
%token UPDATE_SYM
%token UPGRADE_SYM
%token USAGE
%token USER
%token USE_FRM
%token USE_SYM
%token USING
%token UTC_DATE_SYM
%token UTC_TIMESTAMP_SYM
%token UTC_TIME_SYM
%token VALIDATION_SYM
%token VALUES
%token VALUE_SYM
%token VARBINARY_SYM
%token VARCHAR_SYM
%token VARIABLES
%token VARIANCE_SYM
%token VARYING
%token VAR_SAMP_SYM
%token VIEW_SYM
%token VIRTUAL_SYM
%token WAIT_SYM
%token WARNINGS
%token WEEK_SYM
%token WEIGHT_STRING_SYM
%token WHEN_SYM
%token WHERE
%token WHILE_SYM
%token WITH
//%token OBSOLETE_TOKEN_893
%token WITH_ROLLUP_SYM
%token WITHOUT_SYM
%token WORK_SYM
%token WRAPPER_SYM
%token WRITE_SYM
%token X509_SYM
%token XA_SYM
%token XID_SYM
%token XML_SYM
%token XOR
%token YEAR_MONTH_SYM
%token YEAR_SYM
%token ZEROFILL_SYM
%token JSON_UNQUOTED_SEPARATOR_SYM
%token PERSIST_SYM
%token ROLE_SYM
%token ADMIN_SYM
%token INVISIBLE_SYM
%token VISIBLE_SYM
%token EXCEPT_SYM
%token COMPONENT_SYM
%token RECURSIVE_SYM
%token GRAMMAR_SELECTOR_EXPR
%token GRAMMAR_SELECTOR_GCOL
%token GRAMMAR_SELECTOR_PART
%token GRAMMAR_SELECTOR_CTE
%token JSON_OBJECTAGG
%token JSON_ARRAYAGG
%token OF_SYM
%token SKIP_SYM
%token LOCKED_SYM
%token NOWAIT_SYM
%token GROUPING_SYM
%token PERSIST_ONLY_SYM
%token HISTOGRAM_SYM
%token BUCKETS_SYM
//%token OBSOLETE_TOKEN_930
%token CLONE_SYM
%token CUME_DIST_SYM
%token DENSE_RANK_SYM
%token EXCLUDE_SYM
%token FIRST_VALUE_SYM
%token FOLLOWING_SYM
%token GROUPS_SYM
%token LAG_SYM
%token LAST_VALUE_SYM
%token LEAD_SYM
%token NTH_VALUE_SYM
%token NTILE_SYM
%token NULLS_SYM
%token OTHERS_SYM
%token OVER_SYM
%token PERCENT_RANK_SYM
%token PRECEDING_SYM
%token RANK_SYM
%token RESPECT_SYM
%token ROW_NUMBER_SYM
%token TIES_SYM
%token UNBOUNDED_SYM
%token WINDOW_SYM
%token EMPTY_SYM
%token JSON_TABLE_SYM
%token NESTED_SYM
%token ORDINALITY_SYM
%token PATH_SYM
%token HISTORY_SYM
%token REUSE_SYM
%token SRID_SYM
%token THREAD_PRIORITY_SYM
%token RESOURCE_SYM
%token SYSTEM_SYM
%token VCPU_SYM
%token MASTER_PUBLIC_KEY_PATH_SYM
%token GET_MASTER_PUBLIC_KEY_SYM
%token RESTART_SYM
%token DEFINITION_SYM
%token DESCRIPTION_SYM
%token ORGANIZATION_SYM
%token REFERENCE_SYM
%token ACTIVE_SYM
%token INACTIVE_SYM
%token LATERAL_SYM
%token ARRAY_SYM
%token MEMBER_SYM
%token OPTIONAL_SYM
%token SECONDARY_SYM
%token SECONDARY_ENGINE_SYM
%token SECONDARY_LOAD_SYM
%token SECONDARY_UNLOAD_SYM
%token RETAIN_SYM
%token OLD_SYM
%token ENFORCED_SYM
%token OJ_SYM
%token NETWORK_NAMESPACE_SYM
%token RANDOM_SYM
%token MASTER_COMPRESSION_ALGORITHM_SYM
%token MASTER_ZSTD_COMPRESSION_LEVEL_SYM
%token PRIVILEGE_CHECKS_USER_SYM
%token MASTER_TLS_CIPHERSUITES_SYM
%token REQUIRE_ROW_FORMAT_SYM
%token PASSWORD_LOCK_TIME_SYM
%token FAILED_LOGIN_ATTEMPTS_SYM
%token REQUIRE_TABLE_PRIMARY_KEY_CHECK_SYM
%token STREAM_SYM
%token OFF_SYM
%token RETURNING_SYM
%token JSON_VALUE_SYM
%token TLS_SYM
%token ATTRIBUTE_SYM
%token ENGINE_ATTRIBUTE_SYM
%token SECONDARY_ENGINE_ATTRIBUTE_SYM
%token SOURCE_CONNECTION_AUTO_FAILOVER_SYM
%token ZONE_SYM
%token GRAMMAR_SELECTOR_DERIVED_EXPR
%token REPLICA_SYM
%token REPLICAS_SYM
%token ASSIGN_GTIDS_TO_ANONYMOUS_TRANSACTIONS_SYM
%token GET_SOURCE_PUBLIC_KEY_SYM
%token SOURCE_AUTO_POSITION_SYM
%token SOURCE_BIND_SYM
%token SOURCE_COMPRESSION_ALGORITHM_SYM
%token SOURCE_CONNECT_RETRY_SYM
%token SOURCE_DELAY_SYM
%token SOURCE_HEARTBEAT_PERIOD_SYM
%token SOURCE_HOST_SYM
%token SOURCE_LOG_FILE_SYM
%token SOURCE_LOG_POS_SYM
%token SOURCE_PASSWORD_SYM
%token SOURCE_PORT_SYM
%token SOURCE_PUBLIC_KEY_PATH_SYM
%token SOURCE_RETRY_COUNT_SYM
%token SOURCE_SSL_SYM
%token SOURCE_SSL_CA_SYM
%token SOURCE_SSL_CAPATH_SYM
%token SOURCE_SSL_CERT_SYM
%token SOURCE_SSL_CIPHER_SYM
%token SOURCE_SSL_CRL_SYM
%token SOURCE_SSL_CRLPATH_SYM
%token SOURCE_SSL_KEY_SYM
%token SOURCE_SSL_VERIFY_SERVER_CERT_SYM
%token SOURCE_TLS_CIPHERSUITES_SYM
%token SOURCE_TLS_VERSION_SYM
%token SOURCE_USER_SYM
%token SOURCE_ZSTD_COMPRESSION_LEVEL_SYM
%token ST_COLLECT_SYM
%token KEYRING_SYM
%token AUTHENTICATION_SYM
%token FACTOR_SYM
%token FINISH_SYM
%token INITIATE_SYM
%token REGISTRATION_SYM
%token UNREGISTER_SYM
%token INITIAL_SYM
%token CHALLENGE_RESPONSE_SYM
%token GTID_ONLY_SYM
%token INTERSECT_SYM
%token BULK_SYM
%token URL_SYM
%token GENERATE_SYM
%token DOLLAR_QUOTED_STRING_SYM
%token PARSE_TREE_SYM
%token KEYWORD_USED_AS_IDENT
%token KEYWORD_USED_AS_KEYWORD
%token CONDITIONLESS_JOIN
%token '|'
%token '&'
%token '-'
%token '+'
%token '*'
%token '/'
%token '%'
%token '^'
%token '~'
%token '('
%token ')'
%token ';'
%token '@'
%token ','
%token '.'
%token ':'
%token '!'
%token '{'
%token '}'

%left /*1*/ KEYWORD_USED_AS_IDENT
%nonassoc /*2*/ TEXT_STRING
%left /*3*/ KEYWORD_USED_AS_KEYWORD
%right /*4*/ KEY_SYM UNIQUE_SYM
%left /*5*/ UNION_SYM EXCEPT_SYM
%left /*6*/ INTERSECT_SYM
%left /*7*/ CONDITIONLESS_JOIN
%left /*8*/ CROSS INNER_SYM JOIN_SYM LEFT NATURAL ON_SYM RIGHT STRAIGHT_JOIN USING
%left /*9*/ SET_VAR
%left /*10*/ OR2_SYM OR_SYM
%left /*11*/ XOR
%left /*12*/ AND_AND_SYM AND_SYM
%left /*13*/ BETWEEN_SYM CASE_SYM ELSE THEN_SYM WHEN_SYM
%left /*14*/ EQ EQUAL_SYM GE GT_SYM IN_SYM IS LE LIKE LT NE REGEXP
%left /*15*/ '|'
%left /*16*/ '&'
%left /*17*/ SHIFT_LEFT SHIFT_RIGHT
%left /*18*/ '-' '+'
%left /*19*/ DIV_SYM MOD_SYM '*' '/' '%'
%left /*20*/ '^'
%left /*21*/ OR_OR_SYM
%left /*22*/ NEG '~'
%right /*23*/ NOT2_SYM NOT_SYM
%right /*24*/ BINARY_SYM COLLATE_SYM
%left /*25*/ INTERVAL_SYM
%left /*26*/ SUBQUERY_AS_EXPR
%left /*27*/ '(' ')'
%left /*28*/ EMPTY_FROM_CLAUSE
%right /*29*/ INTO

%start start_entry

%%

start_entry :
	sql_statement
	//| GRAMMAR_SELECTOR_EXPR bit_expr END_OF_INPUT
	//| GRAMMAR_SELECTOR_PART partition_clause END_OF_INPUT
	//| GRAMMAR_SELECTOR_GCOL IDENT_sys '(' /*27L*/ expr ')' /*27L*/ END_OF_INPUT
	//| GRAMMAR_SELECTOR_CTE table_subquery END_OF_INPUT
	//| GRAMMAR_SELECTOR_DERIVED_EXPR expr END_OF_INPUT
	;

sql_statement :
	//END_OF_INPUT
	//simple_statement_or_begin ';' opt_end_of_input
	//| simple_statement_or_begin END_OF_INPUT
	simple_statement_or_begin ';'
	| /*empty*/
	| sql_statement simple_statement_or_begin ';'
	;

//opt_end_of_input :
//	/*empty*/
//	//| END_OF_INPUT
//	;

simple_statement_or_begin :
	simple_statement
	| begin_stmt
	;

simple_statement :
	alter_database_stmt
	| alter_event_stmt
	| alter_function_stmt
	| alter_instance_stmt
	| alter_logfile_stmt
	| alter_procedure_stmt
	| alter_resource_group_stmt
	| alter_server_stmt
	| alter_tablespace_stmt
	| alter_undo_tablespace_stmt
	| alter_table_stmt
	| alter_user_stmt
	| alter_view_stmt
	| analyze_table_stmt
	| binlog_base64_event
	| call_stmt
	| change
	| check_table_stmt
	| checksum
	| clone_stmt
	| commit
	| create
	| create_index_stmt
	| create_resource_group_stmt
	| create_role_stmt
	| create_srs_stmt
	| create_table_stmt
	| deallocate
	| delete_stmt
	| describe_stmt
	| do_stmt
	| drop_database_stmt
	| drop_event_stmt
	| drop_function_stmt
	| drop_index_stmt
	| drop_logfile_stmt
	| drop_procedure_stmt
	| drop_resource_group_stmt
	| drop_role_stmt
	| drop_server_stmt
	| drop_srs_stmt
	| drop_tablespace_stmt
	| drop_undo_tablespace_stmt
	| drop_table_stmt
	| drop_trigger_stmt
	| drop_user_stmt
	| drop_view_stmt
	| execute
	| explain_stmt
	| flush
	| get_diagnostics
	| group_replication
	| grant
	| handler_stmt
	| help
	| import_stmt
	| insert_stmt
	| install_stmt
	| kill
	| load_stmt
	| lock
	| optimize_table_stmt
	| keycache_stmt
	| preload_stmt
	| prepare
	| purge
	| release
	| rename
	| repair_table_stmt
	| replace_stmt
	| reset
	| resignal_stmt
	| restart_server_stmt
	| revoke
	| rollback
	| savepoint
	| select_stmt
	| set
	| set_resource_group_stmt
	| set_role_stmt
	| show_binary_logs_stmt
	| show_binlog_events_stmt
	| show_character_set_stmt
	| show_collation_stmt
	| show_columns_stmt
	| show_count_errors_stmt
	| show_count_warnings_stmt
	| show_create_database_stmt
	| show_create_event_stmt
	| show_create_function_stmt
	| show_create_procedure_stmt
	| show_create_table_stmt
	| show_create_trigger_stmt
	| show_create_user_stmt
	| show_create_view_stmt
	| show_databases_stmt
	| show_engine_logs_stmt
	| show_engine_mutex_stmt
	| show_engine_status_stmt
	| show_engines_stmt
	| show_errors_stmt
	| show_events_stmt
	| show_function_code_stmt
	| show_function_status_stmt
	| show_grants_stmt
	| show_keys_stmt
	| show_master_status_stmt
	| show_open_tables_stmt
	| show_parse_tree_stmt
	| show_plugins_stmt
	| show_privileges_stmt
	| show_procedure_code_stmt
	| show_procedure_status_stmt
	| show_processlist_stmt
	| show_profile_stmt
	| show_profiles_stmt
	| show_relaylog_events_stmt
	| show_replica_status_stmt
	| show_replicas_stmt
	| show_status_stmt
	| show_table_status_stmt
	| show_tables_stmt
	| show_triggers_stmt
	| show_variables_stmt
	| show_warnings_stmt
	| shutdown_stmt
	| signal_stmt
	| start
	| start_replica_stmt
	| stop_replica_stmt
	| truncate_stmt
	| uninstall
	| unlock
	| update_stmt
	| use
	| xa
	;

deallocate :
	deallocate_or_drop PREPARE_SYM ident
	;

deallocate_or_drop :
	DEALLOCATE_SYM
	| DROP
	;

prepare :
	PREPARE_SYM ident FROM prepare_src
	;

prepare_src :
	TEXT_STRING_sys
	| '@' ident_or_text
	;

execute :
	EXECUTE_SYM ident execute_using
	;

execute_using :
	/*empty*/
	| USING /*8L*/ execute_var_list
	;

execute_var_list :
	execute_var_list ',' execute_var_ident
	| execute_var_ident
	;

execute_var_ident :
	'@' ident_or_text
	;

help :
	HELP_SYM ident_or_text
	;

change_replication_source :
	MASTER_SYM
	| REPLICATION SOURCE_SYM
	;

change :
	CHANGE change_replication_source TO_SYM source_defs opt_channel
	| CHANGE REPLICATION FILTER_SYM filter_defs opt_channel
	;

filter_defs :
	filter_def
	| filter_defs ',' filter_def
	;

filter_def :
	REPLICATE_DO_DB EQ /*14L*/ opt_filter_db_list
	| REPLICATE_IGNORE_DB EQ /*14L*/ opt_filter_db_list
	| REPLICATE_DO_TABLE EQ /*14L*/ opt_filter_table_list
	| REPLICATE_IGNORE_TABLE EQ /*14L*/ opt_filter_table_list
	| REPLICATE_WILD_DO_TABLE EQ /*14L*/ opt_filter_string_list
	| REPLICATE_WILD_IGNORE_TABLE EQ /*14L*/ opt_filter_string_list
	| REPLICATE_REWRITE_DB EQ /*14L*/ opt_filter_db_pair_list
	;

opt_filter_db_list :
	'(' /*27L*/ ')' /*27L*/
	| '(' /*27L*/ filter_db_list ')' /*27L*/
	;

filter_db_list :
	filter_db_ident
	| filter_db_list ',' filter_db_ident
	;

filter_db_ident :
	ident
	;

opt_filter_db_pair_list :
	'(' /*27L*/ ')' /*27L*/
	| '(' /*27L*/ filter_db_pair_list ')' /*27L*/
	;

filter_db_pair_list :
	'(' /*27L*/ filter_db_ident ',' filter_db_ident ')' /*27L*/
	| filter_db_pair_list ',' '(' /*27L*/ filter_db_ident ',' filter_db_ident ')' /*27L*/
	;

opt_filter_table_list :
	'(' /*27L*/ ')' /*27L*/
	| '(' /*27L*/ filter_table_list ')' /*27L*/
	;

filter_table_list :
	filter_table_ident
	| filter_table_list ',' filter_table_ident
	;

filter_table_ident :
	schema '.' ident
	;

opt_filter_string_list :
	'(' /*27L*/ ')' /*27L*/
	| '(' /*27L*/ filter_string_list ')' /*27L*/
	;

filter_string_list :
	filter_string
	| filter_string_list ',' filter_string
	;

filter_string :
	filter_wild_db_table_string
	;

source_defs :
	source_def
	| source_defs ',' source_def
	;

change_replication_source_auto_position :
	MASTER_AUTO_POSITION_SYM
	| SOURCE_AUTO_POSITION_SYM
	;

change_replication_source_host :
	MASTER_HOST_SYM
	| SOURCE_HOST_SYM
	;

change_replication_source_bind :
	MASTER_BIND_SYM
	| SOURCE_BIND_SYM
	;

change_replication_source_user :
	MASTER_USER_SYM
	| SOURCE_USER_SYM
	;

change_replication_source_password :
	MASTER_PASSWORD_SYM
	| SOURCE_PASSWORD_SYM
	;

change_replication_source_port :
	MASTER_PORT_SYM
	| SOURCE_PORT_SYM
	;

change_replication_source_connect_retry :
	MASTER_CONNECT_RETRY_SYM
	| SOURCE_CONNECT_RETRY_SYM
	;

change_replication_source_retry_count :
	MASTER_RETRY_COUNT_SYM
	| SOURCE_RETRY_COUNT_SYM
	;

change_replication_source_delay :
	MASTER_DELAY_SYM
	| SOURCE_DELAY_SYM
	;

change_replication_source_ssl :
	MASTER_SSL_SYM
	| SOURCE_SSL_SYM
	;

change_replication_source_ssl_ca :
	MASTER_SSL_CA_SYM
	| SOURCE_SSL_CA_SYM
	;

change_replication_source_ssl_capath :
	MASTER_SSL_CAPATH_SYM
	| SOURCE_SSL_CAPATH_SYM
	;

change_replication_source_ssl_cipher :
	MASTER_SSL_CIPHER_SYM
	| SOURCE_SSL_CIPHER_SYM
	;

change_replication_source_ssl_crl :
	MASTER_SSL_CRL_SYM
	| SOURCE_SSL_CRL_SYM
	;

change_replication_source_ssl_crlpath :
	MASTER_SSL_CRLPATH_SYM
	| SOURCE_SSL_CRLPATH_SYM
	;

change_replication_source_ssl_key :
	MASTER_SSL_KEY_SYM
	| SOURCE_SSL_KEY_SYM
	;

change_replication_source_ssl_verify_server_cert :
	MASTER_SSL_VERIFY_SERVER_CERT_SYM
	| SOURCE_SSL_VERIFY_SERVER_CERT_SYM
	;

change_replication_source_tls_version :
	MASTER_TLS_VERSION_SYM
	| SOURCE_TLS_VERSION_SYM
	;

change_replication_source_tls_ciphersuites :
	MASTER_TLS_CIPHERSUITES_SYM
	| SOURCE_TLS_CIPHERSUITES_SYM
	;

change_replication_source_ssl_cert :
	MASTER_SSL_CERT_SYM
	| SOURCE_SSL_CERT_SYM
	;

change_replication_source_public_key :
	MASTER_PUBLIC_KEY_PATH_SYM
	| SOURCE_PUBLIC_KEY_PATH_SYM
	;

change_replication_source_get_source_public_key :
	GET_MASTER_PUBLIC_KEY_SYM
	| GET_SOURCE_PUBLIC_KEY_SYM
	;

change_replication_source_heartbeat_period :
	MASTER_HEARTBEAT_PERIOD_SYM
	| SOURCE_HEARTBEAT_PERIOD_SYM
	;

change_replication_source_compression_algorithm :
	MASTER_COMPRESSION_ALGORITHM_SYM
	| SOURCE_COMPRESSION_ALGORITHM_SYM
	;

change_replication_source_zstd_compression_level :
	MASTER_ZSTD_COMPRESSION_LEVEL_SYM
	| SOURCE_ZSTD_COMPRESSION_LEVEL_SYM
	;

source_def :
	change_replication_source_host EQ /*14L*/ TEXT_STRING_sys_nonewline
	| NETWORK_NAMESPACE_SYM EQ /*14L*/ TEXT_STRING_sys_nonewline
	| change_replication_source_bind EQ /*14L*/ TEXT_STRING_sys_nonewline
	| change_replication_source_user EQ /*14L*/ TEXT_STRING_sys_nonewline
	| change_replication_source_password EQ /*14L*/ TEXT_STRING_sys_nonewline
	| change_replication_source_port EQ /*14L*/ ulong_num
	| change_replication_source_connect_retry EQ /*14L*/ ulong_num
	| change_replication_source_retry_count EQ /*14L*/ ulong_num
	| change_replication_source_delay EQ /*14L*/ ulong_num
	| change_replication_source_ssl EQ /*14L*/ ulong_num
	| change_replication_source_ssl_ca EQ /*14L*/ TEXT_STRING_sys_nonewline
	| change_replication_source_ssl_capath EQ /*14L*/ TEXT_STRING_sys_nonewline
	| change_replication_source_tls_version EQ /*14L*/ TEXT_STRING_sys_nonewline
	| change_replication_source_tls_ciphersuites EQ /*14L*/ source_tls_ciphersuites_def
	| change_replication_source_ssl_cert EQ /*14L*/ TEXT_STRING_sys_nonewline
	| change_replication_source_ssl_cipher EQ /*14L*/ TEXT_STRING_sys_nonewline
	| change_replication_source_ssl_key EQ /*14L*/ TEXT_STRING_sys_nonewline
	| change_replication_source_ssl_verify_server_cert EQ /*14L*/ ulong_num
	| change_replication_source_ssl_crl EQ /*14L*/ TEXT_STRING_sys_nonewline
	| change_replication_source_ssl_crlpath EQ /*14L*/ TEXT_STRING_sys_nonewline
	| change_replication_source_public_key EQ /*14L*/ TEXT_STRING_sys_nonewline
	| change_replication_source_get_source_public_key EQ /*14L*/ ulong_num
	| change_replication_source_heartbeat_period EQ /*14L*/ NUM_literal
	| IGNORE_SERVER_IDS_SYM EQ /*14L*/ '(' /*27L*/ ignore_server_id_list ')' /*27L*/
	| change_replication_source_compression_algorithm EQ /*14L*/ TEXT_STRING_sys
	| change_replication_source_zstd_compression_level EQ /*14L*/ ulong_num
	| change_replication_source_auto_position EQ /*14L*/ ulong_num
	| PRIVILEGE_CHECKS_USER_SYM EQ /*14L*/ privilege_check_def
	| REQUIRE_ROW_FORMAT_SYM EQ /*14L*/ ulong_num
	| REQUIRE_TABLE_PRIMARY_KEY_CHECK_SYM EQ /*14L*/ table_primary_key_check_def
	| SOURCE_CONNECTION_AUTO_FAILOVER_SYM EQ /*14L*/ real_ulong_num
	| ASSIGN_GTIDS_TO_ANONYMOUS_TRANSACTIONS_SYM EQ /*14L*/ assign_gtids_to_anonymous_transactions_def
	| GTID_ONLY_SYM EQ /*14L*/ real_ulong_num
	| source_file_def
	;

ignore_server_id_list :
	/*empty*/
	| ignore_server_id
	| ignore_server_id_list ',' ignore_server_id
	;

ignore_server_id :
	ulong_num
	;

privilege_check_def :
	user_ident_or_text
	| NULL_SYM
	;

table_primary_key_check_def :
	STREAM_SYM
	| ON_SYM /*8L*/
	| OFF_SYM
	| GENERATE_SYM
	;

assign_gtids_to_anonymous_transactions_def :
	OFF_SYM
	| LOCAL_SYM
	| TEXT_STRING /*2N*/
	;

source_tls_ciphersuites_def :
	TEXT_STRING_sys_nonewline
	| NULL_SYM
	;

source_log_file :
	MASTER_LOG_FILE_SYM
	| SOURCE_LOG_FILE_SYM
	;

source_log_pos :
	MASTER_LOG_POS_SYM
	| SOURCE_LOG_POS_SYM
	;

source_file_def :
	source_log_file EQ /*14L*/ TEXT_STRING_sys_nonewline
	| source_log_pos EQ /*14L*/ ulonglong_num
	| RELAY_LOG_FILE_SYM EQ /*14L*/ TEXT_STRING_sys_nonewline
	| RELAY_LOG_POS_SYM EQ /*14L*/ ulong_num
	;

opt_channel :
	/*empty*/
	| FOR_SYM CHANNEL_SYM TEXT_STRING_sys_nonewline
	;

create_table_stmt :
	CREATE opt_temporary TABLE_SYM opt_if_not_exists table_ident '(' /*27L*/ table_element_list ')' /*27L*/ opt_create_table_options_etc
	| CREATE opt_temporary TABLE_SYM opt_if_not_exists table_ident opt_create_table_options_etc
	| CREATE opt_temporary TABLE_SYM opt_if_not_exists table_ident LIKE /*14L*/ table_ident
	| CREATE opt_temporary TABLE_SYM opt_if_not_exists table_ident '(' /*27L*/ LIKE /*14L*/ table_ident ')' /*27L*/
	;

create_role_stmt :
	CREATE ROLE_SYM opt_if_not_exists role_list
	;

create_resource_group_stmt :
	CREATE RESOURCE_SYM GROUP_SYM ident TYPE_SYM opt_equal resource_group_types opt_resource_group_vcpu_list opt_resource_group_priority opt_resource_group_enable_disable
	;

create :
	CREATE DATABASE opt_if_not_exists ident opt_create_database_options
	| CREATE view_or_trigger_or_sp_or_event
	| CREATE USER opt_if_not_exists create_user_list default_role_clause require_clause connect_options opt_account_lock_password_expire_options opt_user_attribute
	| CREATE LOGFILE_SYM GROUP_SYM ident ADD lg_undofile opt_logfile_group_options
	| CREATE TABLESPACE_SYM ident opt_ts_datafile_name opt_logfile_group_name opt_tablespace_options
	| CREATE UNDO_SYM TABLESPACE_SYM ident ADD ts_datafile opt_undo_tablespace_options
	| CREATE SERVER_SYM ident_or_text FOREIGN DATA_SYM WRAPPER_SYM ident_or_text OPTIONS_SYM '(' /*27L*/ server_options_list ')' /*27L*/
	;

create_srs_stmt :
	CREATE OR_SYM /*10L*/ REPLACE_SYM SPATIAL_SYM REFERENCE_SYM SYSTEM_SYM real_ulonglong_num srs_attributes
	| CREATE SPATIAL_SYM REFERENCE_SYM SYSTEM_SYM opt_if_not_exists real_ulonglong_num srs_attributes
	;

srs_attributes :
	/*empty*/
	| srs_attributes NAME_SYM TEXT_STRING_sys_nonewline
	| srs_attributes DEFINITION_SYM TEXT_STRING_sys_nonewline
	| srs_attributes ORGANIZATION_SYM TEXT_STRING_sys_nonewline IDENTIFIED_SYM BY real_ulonglong_num
	| srs_attributes DESCRIPTION_SYM TEXT_STRING_sys_nonewline
	;

default_role_clause :
	/*empty*/
	| DEFAULT_SYM ROLE_SYM role_list
	;

create_index_stmt :
	CREATE opt_unique INDEX_SYM ident opt_index_type_clause ON_SYM /*8L*/ table_ident '(' /*27L*/ key_list_with_expression ')' /*27L*/ opt_index_options opt_index_lock_and_algorithm
	| CREATE FULLTEXT_SYM INDEX_SYM ident ON_SYM /*8L*/ table_ident '(' /*27L*/ key_list_with_expression ')' /*27L*/ opt_fulltext_index_options opt_index_lock_and_algorithm
	| CREATE SPATIAL_SYM INDEX_SYM ident ON_SYM /*8L*/ table_ident '(' /*27L*/ key_list_with_expression ')' /*27L*/ opt_spatial_index_options opt_index_lock_and_algorithm
	;

server_options_list :
	server_option
	| server_options_list ',' server_option
	;

server_option :
	USER TEXT_STRING_sys
	| HOST_SYM TEXT_STRING_sys
	| DATABASE TEXT_STRING_sys
	| OWNER_SYM TEXT_STRING_sys
	| PASSWORD TEXT_STRING_sys
	| SOCKET_SYM TEXT_STRING_sys
	| PORT_SYM ulong_num
	;

event_tail :
	EVENT_SYM opt_if_not_exists sp_name ON_SYM /*8L*/ SCHEDULE_SYM ev_schedule_time opt_ev_on_completion opt_ev_status opt_ev_comment DO_SYM ev_sql_stmt
	;

ev_schedule_time :
	EVERY_SYM expr interval ev_starts ev_ends
	| AT_SYM expr
	;

opt_ev_status :
	/*empty*/
	| ENABLE_SYM
	| DISABLE_SYM ON_SYM /*8L*/ SLAVE
	| DISABLE_SYM
	;

ev_starts :
	/*empty*/
	| STARTS_SYM expr
	;

ev_ends :
	/*empty*/
	| ENDS_SYM expr
	;

opt_ev_on_completion :
	/*empty*/
	| ev_on_completion
	;

ev_on_completion :
	ON_SYM /*8L*/ COMPLETION_SYM PRESERVE_SYM
	| ON_SYM /*8L*/ COMPLETION_SYM NOT_SYM /*23R*/ PRESERVE_SYM
	;

opt_ev_comment :
	/*empty*/
	| COMMENT_SYM TEXT_STRING_sys
	;

ev_sql_stmt :
	ev_sql_stmt_inner
	;

ev_sql_stmt_inner :
	sp_proc_stmt_statement
	| sp_proc_stmt_return
	| sp_proc_stmt_if
	| case_stmt_specification
	| sp_labeled_block
	| sp_unlabeled_block
	| sp_labeled_control
	| sp_proc_stmt_unlabeled
	| sp_proc_stmt_leave
	| sp_proc_stmt_iterate
	| sp_proc_stmt_open
	| sp_proc_stmt_fetch
	| sp_proc_stmt_close
	;

sp_name :
	ident '.' ident
	| ident
	;

sp_a_chistics :
	/*empty*/
	| sp_a_chistics sp_chistic
	;

sp_c_chistics :
	/*empty*/
	| sp_c_chistics sp_c_chistic
	;

sp_chistic :
	COMMENT_SYM TEXT_STRING_sys
	| LANGUAGE_SYM SQL_SYM
	| LANGUAGE_SYM ident
	| NO_SYM SQL_SYM
	| CONTAINS_SYM SQL_SYM
	| READS_SYM SQL_SYM DATA_SYM
	| MODIFIES_SYM SQL_SYM DATA_SYM
	| sp_suid
	;

sp_c_chistic :
	sp_chistic
	| DETERMINISTIC_SYM
	| not DETERMINISTIC_SYM
	;

sp_suid :
	SQL_SYM SECURITY_SYM DEFINER_SYM
	| SQL_SYM SECURITY_SYM INVOKER_SYM
	;

call_stmt :
	CALL_SYM sp_name opt_paren_expr_list
	;

opt_paren_expr_list :
	/*empty*/
	| '(' /*27L*/ opt_expr_list ')' /*27L*/
	;

sp_fdparam_list :
	/*empty*/
	| sp_fdparams
	;

sp_fdparams :
	sp_fdparams ',' sp_fdparam
	| sp_fdparam
	;

sp_fdparam :
	ident type opt_collate
	;

sp_pdparam_list :
	/*empty*/
	| sp_pdparams
	;

sp_pdparams :
	sp_pdparams ',' sp_pdparam
	| sp_pdparam
	;

sp_pdparam :
	sp_opt_inout ident type opt_collate
	;

sp_opt_inout :
	/*empty*/
	| IN_SYM /*14L*/
	| OUT_SYM
	| INOUT_SYM
	;

sp_proc_stmts :
	/*empty*/
	| sp_proc_stmts sp_proc_stmt ';'
	;

sp_proc_stmts1 :
	sp_proc_stmt ';'
	| sp_proc_stmts1 sp_proc_stmt ';'
	;

sp_decls :
	/*empty*/
	| sp_decls sp_decl ';'
	;

sp_decl :
	DECLARE_SYM sp_decl_idents type opt_collate sp_opt_default
	| DECLARE_SYM ident CONDITION_SYM FOR_SYM sp_cond
	| DECLARE_SYM sp_handler_type HANDLER_SYM FOR_SYM sp_hcond_list sp_proc_stmt
	| DECLARE_SYM ident CURSOR_SYM FOR_SYM select_stmt
	;

sp_handler_type :
	EXIT_SYM
	| CONTINUE_SYM
	;

sp_hcond_list :
	sp_hcond_element
	| sp_hcond_list ',' sp_hcond_element
	;

sp_hcond_element :
	sp_hcond
	;

sp_cond :
	ulong_num
	| sqlstate
	;

sqlstate :
	SQLSTATE_SYM opt_value TEXT_STRING_literal
	;

opt_value :
	/*empty*/
	| VALUE_SYM
	;

sp_hcond :
	sp_cond
	| ident
	| SQLWARNING_SYM
	| not FOUND_SYM
	| SQLEXCEPTION_SYM
	;

signal_stmt :
	SIGNAL_SYM signal_value opt_set_signal_information
	;

signal_value :
	ident
	| sqlstate
	;

opt_signal_value :
	/*empty*/
	| signal_value
	;

opt_set_signal_information :
	/*empty*/
	| SET_SYM signal_information_item_list
	;

signal_information_item_list :
	signal_condition_information_item_name EQ /*14L*/ signal_allowed_expr
	| signal_information_item_list ',' signal_condition_information_item_name EQ /*14L*/ signal_allowed_expr
	;

signal_allowed_expr :
	literal_or_null
	| rvalue_system_or_user_variable
	| simple_ident
	;

signal_condition_information_item_name :
	CLASS_ORIGIN_SYM
	| SUBCLASS_ORIGIN_SYM
	| CONSTRAINT_CATALOG_SYM
	| CONSTRAINT_SCHEMA_SYM
	| CONSTRAINT_NAME_SYM
	| CATALOG_NAME_SYM
	| SCHEMA_NAME_SYM
	| TABLE_NAME_SYM
	| COLUMN_NAME_SYM
	| CURSOR_NAME_SYM
	| MESSAGE_TEXT_SYM
	| MYSQL_ERRNO_SYM
	;

resignal_stmt :
	RESIGNAL_SYM opt_signal_value opt_set_signal_information
	;

get_diagnostics :
	GET_SYM which_area DIAGNOSTICS_SYM diagnostics_information
	;

which_area :
	/*empty*/
	| CURRENT_SYM
	| STACKED_SYM
	;

diagnostics_information :
	statement_information
	| CONDITION_SYM condition_number condition_information
	;

statement_information :
	statement_information_item
	| statement_information ',' statement_information_item
	;

statement_information_item :
	simple_target_specification EQ /*14L*/ statement_information_item_name
	;

simple_target_specification :
	ident
	| '@' ident_or_text
	;

statement_information_item_name :
	NUMBER_SYM
	| ROW_COUNT_SYM
	;

condition_number :
	signal_allowed_expr
	;

condition_information :
	condition_information_item
	| condition_information ',' condition_information_item
	;

condition_information_item :
	simple_target_specification EQ /*14L*/ condition_information_item_name
	;

condition_information_item_name :
	CLASS_ORIGIN_SYM
	| SUBCLASS_ORIGIN_SYM
	| CONSTRAINT_CATALOG_SYM
	| CONSTRAINT_SCHEMA_SYM
	| CONSTRAINT_NAME_SYM
	| CATALOG_NAME_SYM
	| SCHEMA_NAME_SYM
	| TABLE_NAME_SYM
	| COLUMN_NAME_SYM
	| CURSOR_NAME_SYM
	| MESSAGE_TEXT_SYM
	| MYSQL_ERRNO_SYM
	| RETURNED_SQLSTATE_SYM
	;

sp_decl_idents :
	ident
	| sp_decl_idents ',' ident
	;

sp_opt_default :
	/*empty*/
	| DEFAULT_SYM expr
	;

sp_proc_stmt :
	sp_proc_stmt_statement
	| sp_proc_stmt_return
	| sp_proc_stmt_if
	| case_stmt_specification
	| sp_labeled_block
	| sp_unlabeled_block
	| sp_labeled_control
	| sp_proc_stmt_unlabeled
	| sp_proc_stmt_leave
	| sp_proc_stmt_iterate
	| sp_proc_stmt_open
	| sp_proc_stmt_fetch
	| sp_proc_stmt_close
	;

sp_proc_stmt_if :
	IF sp_if END IF
	;

sp_proc_stmt_statement :
	simple_statement
	;

sp_proc_stmt_return :
	RETURN_SYM expr
	;

sp_proc_stmt_unlabeled :
	sp_unlabeled_control
	;

sp_proc_stmt_leave :
	LEAVE_SYM label_ident
	;

sp_proc_stmt_iterate :
	ITERATE_SYM label_ident
	;

sp_proc_stmt_open :
	OPEN_SYM ident
	;

sp_proc_stmt_fetch :
	FETCH_SYM sp_opt_fetch_noise ident INTO /*29R*/ sp_fetch_list
	;

sp_proc_stmt_close :
	CLOSE_SYM ident
	;

sp_opt_fetch_noise :
	/*empty*/
	| NEXT_SYM FROM
	| FROM
	;

sp_fetch_list :
	ident
	| sp_fetch_list ',' ident
	;

sp_if :
	expr THEN_SYM /*13L*/ sp_proc_stmts1 sp_elseifs
	;

sp_elseifs :
	/*empty*/
	| ELSEIF_SYM sp_if
	| ELSE /*13L*/ sp_proc_stmts1
	;

case_stmt_specification :
	simple_case_stmt
	| searched_case_stmt
	;

simple_case_stmt :
	CASE_SYM /*13L*/ expr simple_when_clause_list else_clause_opt END CASE_SYM /*13L*/
	;

searched_case_stmt :
	CASE_SYM /*13L*/ searched_when_clause_list else_clause_opt END CASE_SYM /*13L*/
	;

simple_when_clause_list :
	simple_when_clause
	| simple_when_clause_list simple_when_clause
	;

searched_when_clause_list :
	searched_when_clause
	| searched_when_clause_list searched_when_clause
	;

simple_when_clause :
	WHEN_SYM /*13L*/ expr THEN_SYM /*13L*/ sp_proc_stmts1
	;

searched_when_clause :
	WHEN_SYM /*13L*/ expr THEN_SYM /*13L*/ sp_proc_stmts1
	;

else_clause_opt :
	/*empty*/
	| ELSE /*13L*/ sp_proc_stmts1
	;

sp_labeled_control :
	label_ident ':' sp_unlabeled_control sp_opt_label
	;

sp_opt_label :
	/*empty*/
	| label_ident
	;

sp_labeled_block :
	label_ident ':' sp_block_content sp_opt_label
	;

sp_unlabeled_block :
	sp_block_content
	;

sp_block_content :
	BEGIN_SYM sp_decls sp_proc_stmts END
	;

sp_unlabeled_control :
	LOOP_SYM sp_proc_stmts1 END LOOP_SYM
	| WHILE_SYM expr DO_SYM sp_proc_stmts1 END WHILE_SYM
	| REPEAT_SYM sp_proc_stmts1 UNTIL_SYM expr END REPEAT_SYM
	;

trg_action_time :
	BEFORE_SYM
	| AFTER_SYM
	;

trg_event :
	INSERT_SYM
	| UPDATE_SYM
	| DELETE_SYM
	;

opt_ts_datafile_name :
	/*empty*/
	| ADD ts_datafile
	;

opt_logfile_group_name :
	/*empty*/
	| USE_SYM LOGFILE_SYM GROUP_SYM ident
	;

opt_tablespace_options :
	/*empty*/
	| tablespace_option_list
	;

tablespace_option_list :
	tablespace_option
	| tablespace_option_list opt_comma tablespace_option
	;

tablespace_option :
	ts_option_initial_size
	| ts_option_autoextend_size
	| ts_option_max_size
	| ts_option_extent_size
	| ts_option_nodegroup
	| ts_option_engine
	| ts_option_wait
	| ts_option_comment
	| ts_option_file_block_size
	| ts_option_encryption
	| ts_option_engine_attribute
	;

opt_alter_tablespace_options :
	/*empty*/
	| alter_tablespace_option_list
	;

alter_tablespace_option_list :
	alter_tablespace_option
	| alter_tablespace_option_list opt_comma alter_tablespace_option
	;

alter_tablespace_option :
	ts_option_initial_size
	| ts_option_autoextend_size
	| ts_option_max_size
	| ts_option_engine
	| ts_option_wait
	| ts_option_encryption
	| ts_option_engine_attribute
	;

opt_undo_tablespace_options :
	/*empty*/
	| undo_tablespace_option_list
	;

undo_tablespace_option_list :
	undo_tablespace_option
	| undo_tablespace_option_list opt_comma undo_tablespace_option
	;

undo_tablespace_option :
	ts_option_engine
	;

opt_logfile_group_options :
	/*empty*/
	| logfile_group_option_list
	;

logfile_group_option_list :
	logfile_group_option
	| logfile_group_option_list opt_comma logfile_group_option
	;

logfile_group_option :
	ts_option_initial_size
	| ts_option_undo_buffer_size
	| ts_option_redo_buffer_size
	| ts_option_nodegroup
	| ts_option_engine
	| ts_option_wait
	| ts_option_comment
	;

opt_alter_logfile_group_options :
	/*empty*/
	| alter_logfile_group_option_list
	;

alter_logfile_group_option_list :
	alter_logfile_group_option
	| alter_logfile_group_option_list opt_comma alter_logfile_group_option
	;

alter_logfile_group_option :
	ts_option_initial_size
	| ts_option_engine
	| ts_option_wait
	;

ts_datafile :
	DATAFILE_SYM TEXT_STRING_sys
	;

undo_tablespace_state :
	ACTIVE_SYM
	| INACTIVE_SYM
	;

lg_undofile :
	UNDOFILE_SYM TEXT_STRING_sys
	;

ts_option_initial_size :
	INITIAL_SIZE_SYM opt_equal size_number
	;

ts_option_autoextend_size :
	option_autoextend_size
	;

option_autoextend_size :
	AUTOEXTEND_SIZE_SYM opt_equal size_number
	;

ts_option_max_size :
	MAX_SIZE_SYM opt_equal size_number
	;

ts_option_extent_size :
	EXTENT_SIZE_SYM opt_equal size_number
	;

ts_option_undo_buffer_size :
	UNDO_BUFFER_SIZE_SYM opt_equal size_number
	;

ts_option_redo_buffer_size :
	REDO_BUFFER_SIZE_SYM opt_equal size_number
	;

ts_option_nodegroup :
	NODEGROUP_SYM opt_equal real_ulong_num
	;

ts_option_comment :
	COMMENT_SYM opt_equal TEXT_STRING_sys
	;

ts_option_engine :
	opt_storage ENGINE_SYM opt_equal ident_or_text
	;

ts_option_file_block_size :
	FILE_BLOCK_SIZE_SYM opt_equal size_number
	;

ts_option_wait :
	WAIT_SYM
	| NO_WAIT_SYM
	;

ts_option_encryption :
	ENCRYPTION_SYM opt_equal TEXT_STRING_sys
	;

ts_option_engine_attribute :
	ENGINE_ATTRIBUTE_SYM opt_equal json_attribute
	;

size_number :
	real_ulonglong_num
	| IDENT_sys
	;

opt_create_table_options_etc :
	create_table_options opt_create_partitioning_etc
	| opt_create_partitioning_etc
	;

opt_create_partitioning_etc :
	partition_clause opt_duplicate_as_qe
	| opt_duplicate_as_qe
	;

opt_duplicate_as_qe :
	/*empty*/
	| duplicate as_create_query_expression
	| as_create_query_expression
	;

as_create_query_expression :
	AS query_expression_with_opt_locking_clauses
	| query_expression_with_opt_locking_clauses
	;

partition_clause :
	PARTITION_SYM BY part_type_def opt_num_parts opt_sub_part opt_part_defs
	;

part_type_def :
	opt_linear KEY_SYM /*4R*/ opt_key_algo '(' /*27L*/ opt_name_list ')' /*27L*/
	| opt_linear HASH_SYM '(' /*27L*/ bit_expr ')' /*27L*/
	| RANGE_SYM '(' /*27L*/ bit_expr ')' /*27L*/
	| RANGE_SYM COLUMNS '(' /*27L*/ name_list ')' /*27L*/
	| LIST_SYM '(' /*27L*/ bit_expr ')' /*27L*/
	| LIST_SYM COLUMNS '(' /*27L*/ name_list ')' /*27L*/
	;

opt_linear :
	/*empty*/
	| LINEAR_SYM
	;

opt_key_algo :
	/*empty*/
	| ALGORITHM_SYM EQ /*14L*/ real_ulong_num
	;

opt_num_parts :
	/*empty*/
	| PARTITIONS_SYM real_ulong_num
	;

opt_sub_part :
	/*empty*/
	| SUBPARTITION_SYM BY opt_linear HASH_SYM '(' /*27L*/ bit_expr ')' /*27L*/ opt_num_subparts
	| SUBPARTITION_SYM BY opt_linear KEY_SYM /*4R*/ opt_key_algo '(' /*27L*/ name_list ')' /*27L*/ opt_num_subparts
	;

opt_name_list :
	/*empty*/
	| name_list
	;

name_list :
	ident
	| name_list ',' ident
	;

opt_num_subparts :
	/*empty*/
	| SUBPARTITIONS_SYM real_ulong_num
	;

opt_part_defs :
	/*empty*/
	| '(' /*27L*/ part_def_list ')' /*27L*/
	;

part_def_list :
	part_definition
	| part_def_list ',' part_definition
	;

part_definition :
	PARTITION_SYM ident opt_part_values opt_part_options opt_sub_partition
	;

opt_part_values :
	/*empty*/
	| VALUES LESS_SYM THAN_SYM part_func_max
	| VALUES IN_SYM /*14L*/ part_values_in
	;

part_func_max :
	MAX_VALUE_SYM
	| part_value_item_list_paren
	;

part_values_in :
	part_value_item_list_paren
	| '(' /*27L*/ part_value_list ')' /*27L*/
	;

part_value_list :
	part_value_item_list_paren
	| part_value_list ',' part_value_item_list_paren
	;

part_value_item_list_paren :
	'(' /*27L*/ part_value_item_list ')' /*27L*/
	;

part_value_item_list :
	part_value_item
	| part_value_item_list ',' part_value_item
	;

part_value_item :
	MAX_VALUE_SYM
	| bit_expr
	;

opt_sub_partition :
	/*empty*/
	| '(' /*27L*/ sub_part_list ')' /*27L*/
	;

sub_part_list :
	sub_part_definition
	| sub_part_list ',' sub_part_definition
	;

sub_part_definition :
	SUBPARTITION_SYM ident_or_text opt_part_options
	;

opt_part_options :
	/*empty*/
	| part_option_list
	;

part_option_list :
	part_option_list part_option
	| part_option
	;

part_option :
	TABLESPACE_SYM opt_equal ident
	| opt_storage ENGINE_SYM opt_equal ident_or_text
	| NODEGROUP_SYM opt_equal real_ulong_num
	| MAX_ROWS opt_equal real_ulonglong_num
	| MIN_ROWS opt_equal real_ulonglong_num
	| DATA_SYM DIRECTORY_SYM opt_equal TEXT_STRING_sys
	| INDEX_SYM DIRECTORY_SYM opt_equal TEXT_STRING_sys
	| COMMENT_SYM opt_equal TEXT_STRING_sys
	;

alter_database_options :
	alter_database_option
	| alter_database_options alter_database_option
	;

alter_database_option :
	create_database_option
	| READ_SYM ONLY_SYM opt_equal ternary_option
	;

opt_create_database_options :
	/*empty*/
	| create_database_options
	;

create_database_options :
	create_database_option
	| create_database_options create_database_option
	;

create_database_option :
	default_collation
	| default_charset
	| default_encryption
	;

opt_if_not_exists :
	/*empty*/
	| IF not EXISTS
	;

create_table_options_space_separated :
	create_table_option
	| create_table_options_space_separated create_table_option
	;

create_table_options :
	create_table_option
	| create_table_options opt_comma create_table_option
	;

opt_comma :
	/*empty*/
	| ','
	;

create_table_option :
	ENGINE_SYM opt_equal ident_or_text
	| SECONDARY_ENGINE_SYM opt_equal NULL_SYM
	| SECONDARY_ENGINE_SYM opt_equal ident_or_text
	| MAX_ROWS opt_equal ulonglong_num
	| MIN_ROWS opt_equal ulonglong_num
	| AVG_ROW_LENGTH opt_equal ulonglong_num
	| PASSWORD opt_equal TEXT_STRING_sys
	| COMMENT_SYM opt_equal TEXT_STRING_sys
	| COMPRESSION_SYM opt_equal TEXT_STRING_sys
	| ENCRYPTION_SYM opt_equal TEXT_STRING_sys
	| AUTO_INC opt_equal ulonglong_num
	| PACK_KEYS_SYM opt_equal ternary_option
	| STATS_AUTO_RECALC_SYM opt_equal ternary_option
	| STATS_PERSISTENT_SYM opt_equal ternary_option
	| STATS_SAMPLE_PAGES_SYM opt_equal ulong_num
	| STATS_SAMPLE_PAGES_SYM opt_equal DEFAULT_SYM
	| CHECKSUM_SYM opt_equal ulong_num
	| TABLE_CHECKSUM_SYM opt_equal ulong_num
	| DELAY_KEY_WRITE_SYM opt_equal ulong_num
	| ROW_FORMAT_SYM opt_equal row_types
	| UNION_SYM /*5L*/ opt_equal '(' /*27L*/ opt_table_list ')' /*27L*/
	| default_charset
	| default_collation
	| INSERT_METHOD opt_equal merge_insert_types
	| DATA_SYM DIRECTORY_SYM opt_equal TEXT_STRING_sys
	| INDEX_SYM DIRECTORY_SYM opt_equal TEXT_STRING_sys
	| TABLESPACE_SYM opt_equal ident
	| STORAGE_SYM DISK_SYM
	| STORAGE_SYM MEMORY_SYM
	| CONNECTION_SYM opt_equal TEXT_STRING_sys
	| KEY_BLOCK_SIZE opt_equal ulonglong_num
	| START_SYM TRANSACTION_SYM
	| ENGINE_ATTRIBUTE_SYM opt_equal json_attribute
	| SECONDARY_ENGINE_ATTRIBUTE_SYM opt_equal json_attribute
	| option_autoextend_size
	;

ternary_option :
	ulong_num
	| DEFAULT_SYM
	;

default_charset :
	opt_default character_set opt_equal charset_name
	;

default_collation :
	opt_default COLLATE_SYM /*24R*/ opt_equal collation_name
	;

default_encryption :
	opt_default ENCRYPTION_SYM opt_equal TEXT_STRING_sys
	;

row_types :
	DEFAULT_SYM
	| FIXED_SYM
	| DYNAMIC_SYM
	| COMPRESSED_SYM
	| REDUNDANT_SYM
	| COMPACT_SYM
	;

merge_insert_types :
	NO_SYM
	| FIRST_SYM
	| LAST_SYM
	;

udf_type :
	STRING_SYM
	| REAL_SYM
	| DECIMAL_SYM
	| INT_SYM
	;

table_element_list :
	table_element
	| table_element_list ',' table_element
	;

table_element :
	column_def
	| table_constraint_def
	;

column_def :
	ident field_def opt_references
	;

opt_references :
	/*empty*/
	| references
	;

table_constraint_def :
	key_or_index opt_index_name_and_type '(' /*27L*/ key_list_with_expression ')' /*27L*/ opt_index_options
	| FULLTEXT_SYM opt_key_or_index opt_ident '(' /*27L*/ key_list_with_expression ')' /*27L*/ opt_fulltext_index_options
	| SPATIAL_SYM opt_key_or_index opt_ident '(' /*27L*/ key_list_with_expression ')' /*27L*/ opt_spatial_index_options
	| opt_constraint_name constraint_key_type opt_index_name_and_type '(' /*27L*/ key_list_with_expression ')' /*27L*/ opt_index_options
	| opt_constraint_name FOREIGN KEY_SYM /*4R*/ opt_ident '(' /*27L*/ key_list ')' /*27L*/ references
	| opt_constraint_name check_constraint opt_constraint_enforcement
	;

check_constraint :
	CHECK_SYM '(' /*27L*/ expr ')' /*27L*/
	;

opt_constraint_name :
	/*empty*/
	| CONSTRAINT opt_ident
	;

opt_not :
	/*empty*/
	| NOT_SYM /*23R*/
	;

opt_constraint_enforcement :
	/*empty*/
	| constraint_enforcement
	;

constraint_enforcement :
	opt_not ENFORCED_SYM
	;

field_def :
	type opt_column_attribute_list
	| type opt_collate opt_generated_always AS '(' /*27L*/ expr ')' /*27L*/ opt_stored_attribute opt_column_attribute_list
	;

opt_generated_always :
	/*empty*/
	| GENERATED ALWAYS_SYM
	;

opt_stored_attribute :
	/*empty*/
	| VIRTUAL_SYM
	| STORED_SYM
	;

type :
	int_type opt_field_length field_options
	| real_type opt_precision field_options
	| numeric_type float_options field_options
	| BIT_SYM %prec KEYWORD_USED_AS_KEYWORD /*3L*/
	| BIT_SYM field_length
	| BOOL_SYM
	| BOOLEAN_SYM
	| CHAR_SYM field_length opt_charset_with_opt_binary
	| CHAR_SYM opt_charset_with_opt_binary
	| nchar field_length opt_bin_mod
	| nchar opt_bin_mod
	| BINARY_SYM /*24R*/ field_length
	| BINARY_SYM /*24R*/
	| varchar field_length opt_charset_with_opt_binary
	| nvarchar field_length opt_bin_mod
	| VARBINARY_SYM field_length
	| YEAR_SYM opt_field_length field_options
	| DATE_SYM
	| TIME_SYM type_datetime_precision
	| TIMESTAMP_SYM type_datetime_precision
	| DATETIME_SYM type_datetime_precision
	| TINYBLOB_SYM
	| BLOB_SYM opt_field_length
	| spatial_type
	| MEDIUMBLOB_SYM
	| LONGBLOB_SYM
	| LONG_SYM VARBINARY_SYM
	| LONG_SYM varchar opt_charset_with_opt_binary
	| TINYTEXT_SYN opt_charset_with_opt_binary
	| TEXT_SYM opt_field_length opt_charset_with_opt_binary
	| MEDIUMTEXT_SYM opt_charset_with_opt_binary
	| LONGTEXT_SYM opt_charset_with_opt_binary
	| ENUM_SYM '(' /*27L*/ string_list ')' /*27L*/ opt_charset_with_opt_binary
	| SET_SYM '(' /*27L*/ string_list ')' /*27L*/ opt_charset_with_opt_binary
	| LONG_SYM opt_charset_with_opt_binary
	| SERIAL_SYM
	| JSON_SYM
	;

spatial_type :
	GEOMETRY_SYM
	| GEOMETRYCOLLECTION_SYM
	| POINT_SYM
	| MULTIPOINT_SYM
	| LINESTRING_SYM
	| MULTILINESTRING_SYM
	| POLYGON_SYM
	| MULTIPOLYGON_SYM
	;

nchar :
	NCHAR_SYM
	| NATIONAL_SYM CHAR_SYM
	;

varchar :
	CHAR_SYM VARYING
	| VARCHAR_SYM
	;

nvarchar :
	NATIONAL_SYM VARCHAR_SYM
	| NVARCHAR_SYM
	| NCHAR_SYM VARCHAR_SYM
	| NATIONAL_SYM CHAR_SYM VARYING
	| NCHAR_SYM VARYING
	;

int_type :
	INT_SYM
	| TINYINT_SYM
	| SMALLINT_SYM
	| MEDIUMINT_SYM
	| BIGINT_SYM
	;

real_type :
	REAL_SYM
	| DOUBLE_SYM opt_PRECISION
	;

opt_PRECISION :
	/*empty*/
	| PRECISION
	;

numeric_type :
	FLOAT_SYM
	| DECIMAL_SYM
	| NUMERIC_SYM
	| FIXED_SYM
	;

standard_float_options :
	/*empty*/
	| field_length
	;

float_options :
	/*empty*/
	| field_length
	| precision
	;

precision :
	'(' /*27L*/ NUM ',' NUM ')' /*27L*/
	;

type_datetime_precision :
	/*empty*/
	| '(' /*27L*/ NUM ')' /*27L*/
	;

func_datetime_precision :
	/*empty*/
	| '(' /*27L*/ ')' /*27L*/
	| '(' /*27L*/ NUM ')' /*27L*/
	;

field_options :
	/*empty*/
	| field_opt_list
	;

field_opt_list :
	field_opt_list field_option
	| field_option
	;

field_option :
	SIGNED_SYM
	| UNSIGNED_SYM
	| ZEROFILL_SYM
	;

field_length :
	'(' /*27L*/ LONG_NUM ')' /*27L*/
	| '(' /*27L*/ ULONGLONG_NUM ')' /*27L*/
	| '(' /*27L*/ DECIMAL_NUM ')' /*27L*/
	| '(' /*27L*/ NUM ')' /*27L*/
	;

opt_field_length :
	/*empty*/
	| field_length
	;

opt_precision :
	/*empty*/
	| precision
	;

opt_column_attribute_list :
	/*empty*/
	| column_attribute_list
	;

column_attribute_list :
	column_attribute_list column_attribute
	| column_attribute
	;

column_attribute :
	NULL_SYM
	| not NULL_SYM
	| not SECONDARY_SYM
	| DEFAULT_SYM now_or_signed_literal
	| DEFAULT_SYM '(' /*27L*/ expr ')' /*27L*/
	| ON_SYM /*8L*/ UPDATE_SYM now
	| AUTO_INC
	| SERIAL_SYM DEFAULT_SYM VALUE_SYM
	| opt_primary KEY_SYM /*4R*/
	| UNIQUE_SYM /*4R*/
	| UNIQUE_SYM /*4R*/ KEY_SYM /*4R*/
	| COMMENT_SYM TEXT_STRING_sys
	| COLLATE_SYM /*24R*/ collation_name
	| COLUMN_FORMAT_SYM column_format
	| STORAGE_SYM storage_media
	| SRID_SYM real_ulonglong_num
	| opt_constraint_name check_constraint
	| constraint_enforcement
	| ENGINE_ATTRIBUTE_SYM opt_equal json_attribute
	| SECONDARY_ENGINE_ATTRIBUTE_SYM opt_equal json_attribute
	| visibility
	;

column_format :
	DEFAULT_SYM
	| FIXED_SYM
	| DYNAMIC_SYM
	;

storage_media :
	DEFAULT_SYM
	| DISK_SYM
	| MEMORY_SYM
	;

now :
	NOW_SYM func_datetime_precision
	;

now_or_signed_literal :
	now
	| signed_literal_or_null
	;

character_set :
	CHAR_SYM SET_SYM
	| CHARSET
	;

charset_name :
	ident_or_text
	| BINARY_SYM /*24R*/
	;

opt_load_data_charset :
	/*empty*/
	| character_set charset_name
	;

old_or_new_charset_name :
	ident_or_text
	| BINARY_SYM /*24R*/
	;

old_or_new_charset_name_or_default :
	old_or_new_charset_name
	| DEFAULT_SYM
	;

collation_name :
	ident_or_text
	| BINARY_SYM /*24R*/
	;

opt_collate :
	/*empty*/
	| COLLATE_SYM /*24R*/ collation_name
	;

opt_default :
	/*empty*/
	| DEFAULT_SYM
	;

ascii :
	ASCII_SYM
	| BINARY_SYM /*24R*/ ASCII_SYM
	| ASCII_SYM BINARY_SYM /*24R*/
	;

unicode :
	UNICODE_SYM
	| UNICODE_SYM BINARY_SYM /*24R*/
	| BINARY_SYM /*24R*/ UNICODE_SYM
	;

opt_charset_with_opt_binary :
	/*empty*/
	| ascii
	| unicode
	| BYTE_SYM
	| character_set charset_name opt_bin_mod
	| BINARY_SYM /*24R*/
	| BINARY_SYM /*24R*/ character_set charset_name
	;

opt_bin_mod :
	/*empty*/
	| BINARY_SYM /*24R*/
	;

ws_num_codepoints :
	'(' /*27L*/ real_ulong_num ')' /*27L*/
	;

opt_primary :
	/*empty*/
	| PRIMARY_SYM
	;

references :
	REFERENCES table_ident opt_ref_list opt_match_clause opt_on_update_delete
	;

opt_ref_list :
	/*empty*/
	| '(' /*27L*/ reference_list ')' /*27L*/
	;

reference_list :
	reference_list ',' ident
	| ident
	;

opt_match_clause :
	/*empty*/
	| MATCH FULL
	| MATCH PARTIAL
	| MATCH SIMPLE_SYM
	;

opt_on_update_delete :
	/*empty*/
	| ON_SYM /*8L*/ UPDATE_SYM delete_option
	| ON_SYM /*8L*/ DELETE_SYM delete_option
	| ON_SYM /*8L*/ UPDATE_SYM delete_option ON_SYM /*8L*/ DELETE_SYM delete_option
	| ON_SYM /*8L*/ DELETE_SYM delete_option ON_SYM /*8L*/ UPDATE_SYM delete_option
	;

delete_option :
	RESTRICT
	| CASCADE
	| SET_SYM NULL_SYM
	| NO_SYM ACTION
	| SET_SYM DEFAULT_SYM
	;

constraint_key_type :
	PRIMARY_SYM KEY_SYM /*4R*/
	| UNIQUE_SYM /*4R*/ opt_key_or_index
	;

key_or_index :
	KEY_SYM /*4R*/
	| INDEX_SYM
	;

opt_key_or_index :
	/*empty*/
	| key_or_index
	;

keys_or_index :
	KEYS
	| INDEX_SYM
	| INDEXES
	;

opt_unique :
	/*empty*/
	| UNIQUE_SYM /*4R*/
	;

opt_fulltext_index_options :
	/*empty*/
	| fulltext_index_options
	;

fulltext_index_options :
	fulltext_index_option
	| fulltext_index_options fulltext_index_option
	;

fulltext_index_option :
	common_index_option
	| WITH PARSER_SYM IDENT_sys
	;

opt_spatial_index_options :
	/*empty*/
	| spatial_index_options
	;

spatial_index_options :
	spatial_index_option
	| spatial_index_options spatial_index_option
	;

spatial_index_option :
	common_index_option
	;

opt_index_options :
	/*empty*/
	| index_options
	;

index_options :
	index_option
	| index_options index_option
	;

index_option :
	common_index_option
	| index_type_clause
	;

common_index_option :
	KEY_BLOCK_SIZE opt_equal ulong_num
	| COMMENT_SYM TEXT_STRING_sys
	| visibility
	| ENGINE_ATTRIBUTE_SYM opt_equal json_attribute
	| SECONDARY_ENGINE_ATTRIBUTE_SYM opt_equal json_attribute
	;

opt_index_name_and_type :
	opt_ident
	| opt_ident USING /*8L*/ index_type
	| ident TYPE_SYM index_type
	;

opt_index_type_clause :
	/*empty*/
	| index_type_clause
	;

index_type_clause :
	USING /*8L*/ index_type
	| TYPE_SYM index_type
	;

visibility :
	VISIBLE_SYM
	| INVISIBLE_SYM
	;

index_type :
	BTREE_SYM
	| RTREE_SYM
	| HASH_SYM
	;

key_list :
	key_list ',' key_part
	| key_part
	;

key_part :
	ident opt_ordering_direction
	| ident '(' /*27L*/ NUM ')' /*27L*/ opt_ordering_direction
	;

key_list_with_expression :
	key_list_with_expression ',' key_part_with_expression
	| key_part_with_expression
	;

key_part_with_expression :
	key_part
	| '(' /*27L*/ expr ')' /*27L*/ opt_ordering_direction
	;

opt_ident :
	/*empty*/
	| ident
	;

string_list :
	text_string
	| string_list ',' text_string
	;

alter_table_stmt :
	ALTER TABLE_SYM table_ident opt_alter_table_actions
	| ALTER TABLE_SYM table_ident standalone_alter_table_action
	;

alter_database_stmt :
	ALTER DATABASE ident_or_empty alter_database_options
	;

alter_procedure_stmt :
	ALTER PROCEDURE_SYM sp_name sp_a_chistics
	;

alter_function_stmt :
	ALTER FUNCTION_SYM sp_name sp_a_chistics
	;

alter_view_stmt :
	ALTER view_algorithm definer_opt view_tail
	| ALTER definer_opt view_tail
	;

alter_event_stmt :
	ALTER definer_opt EVENT_SYM sp_name ev_alter_on_schedule_completion opt_ev_rename_to opt_ev_status opt_ev_comment opt_ev_sql_stmt
	;

alter_logfile_stmt :
	ALTER LOGFILE_SYM GROUP_SYM ident ADD lg_undofile opt_alter_logfile_group_options
	;

alter_tablespace_stmt :
	ALTER TABLESPACE_SYM ident ADD ts_datafile opt_alter_tablespace_options
	| ALTER TABLESPACE_SYM ident DROP ts_datafile opt_alter_tablespace_options
	| ALTER TABLESPACE_SYM ident RENAME TO_SYM ident
	| ALTER TABLESPACE_SYM ident alter_tablespace_option_list
	;

alter_undo_tablespace_stmt :
	ALTER UNDO_SYM TABLESPACE_SYM ident SET_SYM undo_tablespace_state opt_undo_tablespace_options
	;

alter_server_stmt :
	ALTER SERVER_SYM ident_or_text OPTIONS_SYM '(' /*27L*/ server_options_list ')' /*27L*/
	;

alter_user_stmt :
	alter_user_command alter_user_list require_clause connect_options opt_account_lock_password_expire_options opt_user_attribute
	| alter_user_command user_func identified_by_random_password opt_replace_password opt_retain_current_password
	| alter_user_command user_func identified_by_password opt_replace_password opt_retain_current_password
	| alter_user_command user_func DISCARD_SYM OLD_SYM PASSWORD
	| alter_user_command user DEFAULT_SYM ROLE_SYM ALL
	| alter_user_command user DEFAULT_SYM ROLE_SYM NONE_SYM
	| alter_user_command user DEFAULT_SYM ROLE_SYM role_list
	| alter_user_command user opt_user_registration
	| alter_user_command user_func opt_user_registration
	;

opt_replace_password :
	/*empty*/
	| REPLACE_SYM TEXT_STRING_password
	;

alter_resource_group_stmt :
	ALTER RESOURCE_SYM GROUP_SYM ident opt_resource_group_vcpu_list opt_resource_group_priority opt_resource_group_enable_disable opt_force
	;

alter_user_command :
	ALTER USER if_exists
	;

opt_user_attribute :
	/*empty*/
	| ATTRIBUTE_SYM TEXT_STRING_literal
	| COMMENT_SYM TEXT_STRING_literal
	;

opt_account_lock_password_expire_options :
	/*empty*/
	| opt_account_lock_password_expire_option_list
	;

opt_account_lock_password_expire_option_list :
	opt_account_lock_password_expire_option
	| opt_account_lock_password_expire_option_list opt_account_lock_password_expire_option
	;

opt_account_lock_password_expire_option :
	ACCOUNT_SYM UNLOCK_SYM
	| ACCOUNT_SYM LOCK_SYM
	| PASSWORD EXPIRE_SYM
	| PASSWORD EXPIRE_SYM INTERVAL_SYM /*25L*/ real_ulong_num DAY_SYM
	| PASSWORD EXPIRE_SYM NEVER_SYM
	| PASSWORD EXPIRE_SYM DEFAULT_SYM
	| PASSWORD HISTORY_SYM real_ulong_num
	| PASSWORD HISTORY_SYM DEFAULT_SYM
	| PASSWORD REUSE_SYM INTERVAL_SYM /*25L*/ real_ulong_num DAY_SYM
	| PASSWORD REUSE_SYM INTERVAL_SYM /*25L*/ DEFAULT_SYM
	| PASSWORD REQUIRE_SYM CURRENT_SYM
	| PASSWORD REQUIRE_SYM CURRENT_SYM DEFAULT_SYM
	| PASSWORD REQUIRE_SYM CURRENT_SYM OPTIONAL_SYM
	| FAILED_LOGIN_ATTEMPTS_SYM real_ulong_num
	| PASSWORD_LOCK_TIME_SYM real_ulong_num
	| PASSWORD_LOCK_TIME_SYM UNBOUNDED_SYM
	;

connect_options :
	/*empty*/
	| WITH connect_option_list
	;

connect_option_list :
	connect_option_list connect_option
	| connect_option
	;

connect_option :
	MAX_QUERIES_PER_HOUR ulong_num
	| MAX_UPDATES_PER_HOUR ulong_num
	| MAX_CONNECTIONS_PER_HOUR ulong_num
	| MAX_USER_CONNECTIONS_SYM ulong_num
	;

user_func :
	USER '(' /*27L*/ ')' /*27L*/
	;

ev_alter_on_schedule_completion :
	/*empty*/
	| ON_SYM /*8L*/ SCHEDULE_SYM ev_schedule_time
	| ev_on_completion
	| ON_SYM /*8L*/ SCHEDULE_SYM ev_schedule_time ev_on_completion
	;

opt_ev_rename_to :
	/*empty*/
	| RENAME TO_SYM sp_name
	;

opt_ev_sql_stmt :
	/*empty*/
	| DO_SYM ev_sql_stmt
	;

ident_or_empty :
	/*empty*/
	| ident
	;

opt_alter_table_actions :
	opt_alter_command_list
	| opt_alter_command_list alter_table_partition_options
	;

standalone_alter_table_action :
	standalone_alter_commands
	| alter_commands_modifier_list ',' standalone_alter_commands
	;

alter_table_partition_options :
	partition_clause
	| REMOVE_SYM PARTITIONING_SYM
	;

opt_alter_command_list :
	/*empty*/
	| alter_commands_modifier_list
	| alter_list
	| alter_commands_modifier_list ',' alter_list
	;

standalone_alter_commands :
	DISCARD_SYM TABLESPACE_SYM
	| IMPORT TABLESPACE_SYM
	| ADD PARTITION_SYM opt_no_write_to_binlog
	| ADD PARTITION_SYM opt_no_write_to_binlog '(' /*27L*/ part_def_list ')' /*27L*/
	| ADD PARTITION_SYM opt_no_write_to_binlog PARTITIONS_SYM real_ulong_num
	| DROP PARTITION_SYM ident_string_list
	| REBUILD_SYM PARTITION_SYM opt_no_write_to_binlog all_or_alt_part_name_list
	| OPTIMIZE PARTITION_SYM opt_no_write_to_binlog all_or_alt_part_name_list
	| ANALYZE_SYM PARTITION_SYM opt_no_write_to_binlog all_or_alt_part_name_list
	| CHECK_SYM PARTITION_SYM all_or_alt_part_name_list opt_mi_check_types
	| REPAIR PARTITION_SYM opt_no_write_to_binlog all_or_alt_part_name_list opt_mi_repair_types
	| COALESCE PARTITION_SYM opt_no_write_to_binlog real_ulong_num
	| TRUNCATE_SYM PARTITION_SYM all_or_alt_part_name_list
	| REORGANIZE_SYM PARTITION_SYM opt_no_write_to_binlog
	| REORGANIZE_SYM PARTITION_SYM opt_no_write_to_binlog ident_string_list INTO /*29R*/ '(' /*27L*/ part_def_list ')' /*27L*/
	| EXCHANGE_SYM PARTITION_SYM ident WITH TABLE_SYM table_ident opt_with_validation
	| DISCARD_SYM PARTITION_SYM all_or_alt_part_name_list TABLESPACE_SYM
	| IMPORT PARTITION_SYM all_or_alt_part_name_list TABLESPACE_SYM
	| SECONDARY_LOAD_SYM
	| SECONDARY_UNLOAD_SYM
	;

opt_with_validation :
	/*empty*/
	| with_validation
	;

with_validation :
	WITH VALIDATION_SYM
	| WITHOUT_SYM VALIDATION_SYM
	;

all_or_alt_part_name_list :
	ALL
	| ident_string_list
	;

alter_list :
	alter_list_item
	| alter_list ',' alter_list_item
	| alter_list ',' alter_commands_modifier
	| create_table_options_space_separated
	| alter_list ',' create_table_options_space_separated
	;

alter_commands_modifier_list :
	alter_commands_modifier
	| alter_commands_modifier_list ',' alter_commands_modifier
	;

alter_list_item :
	ADD opt_column ident field_def opt_references opt_place
	| ADD opt_column '(' /*27L*/ table_element_list ')' /*27L*/
	| ADD table_constraint_def
	| CHANGE opt_column ident ident field_def opt_place
	| MODIFY_SYM opt_column ident field_def opt_place
	| DROP opt_column ident opt_restrict
	| DROP FOREIGN KEY_SYM /*4R*/ ident
	| DROP PRIMARY_SYM KEY_SYM /*4R*/
	| DROP key_or_index ident
	| DROP CHECK_SYM ident
	| DROP CONSTRAINT ident
	| DISABLE_SYM KEYS
	| ENABLE_SYM KEYS
	| ALTER opt_column ident SET_SYM DEFAULT_SYM signed_literal_or_null
	| ALTER opt_column ident SET_SYM DEFAULT_SYM '(' /*27L*/ expr ')' /*27L*/
	| ALTER opt_column ident DROP DEFAULT_SYM
	| ALTER opt_column ident SET_SYM visibility
	| ALTER INDEX_SYM ident visibility
	| ALTER CHECK_SYM ident constraint_enforcement
	| ALTER CONSTRAINT ident constraint_enforcement
	| RENAME opt_to table_ident
	| RENAME key_or_index ident TO_SYM ident
	| RENAME COLUMN_SYM ident TO_SYM ident
	| CONVERT_SYM TO_SYM character_set charset_name opt_collate
	| CONVERT_SYM TO_SYM character_set DEFAULT_SYM opt_collate
	| FORCE_SYM
	| ORDER_SYM BY alter_order_list
	;

alter_commands_modifier :
	alter_algorithm_option
	| alter_lock_option
	| with_validation
	;

opt_index_lock_and_algorithm :
	/*empty*/
	| alter_lock_option
	| alter_algorithm_option
	| alter_lock_option alter_algorithm_option
	| alter_algorithm_option alter_lock_option
	;

alter_algorithm_option :
	ALGORITHM_SYM opt_equal alter_algorithm_option_value
	;

alter_algorithm_option_value :
	DEFAULT_SYM
	| ident
	;

alter_lock_option :
	LOCK_SYM opt_equal alter_lock_option_value
	;

alter_lock_option_value :
	DEFAULT_SYM
	| ident
	;

opt_column :
	/*empty*/
	| COLUMN_SYM
	;

opt_ignore :
	/*empty*/
	| IGNORE_SYM
	;

opt_restrict :
	/*empty*/
	| RESTRICT
	| CASCADE
	;

opt_place :
	/*empty*/
	| AFTER_SYM ident
	| FIRST_SYM
	;

opt_to :
	/*empty*/
	| TO_SYM
	| EQ /*14L*/
	| AS
	;

group_replication :
	group_replication_start opt_group_replication_start_options
	| STOP_SYM GROUP_REPLICATION
	;

group_replication_start :
	START_SYM GROUP_REPLICATION
	;

opt_group_replication_start_options :
	/*empty*/
	| group_replication_start_options
	;

group_replication_start_options :
	group_replication_start_option
	| group_replication_start_options ',' group_replication_start_option
	;

group_replication_start_option :
	group_replication_user
	| group_replication_password
	| group_replication_plugin_auth
	;

group_replication_user :
	USER EQ /*14L*/ TEXT_STRING_sys_nonewline
	;

group_replication_password :
	PASSWORD EQ /*14L*/ TEXT_STRING_sys_nonewline
	;

group_replication_plugin_auth :
	DEFAULT_AUTH_SYM EQ /*14L*/ TEXT_STRING_sys_nonewline
	;

replica :
	SLAVE
	| REPLICA_SYM
	;

stop_replica_stmt :
	STOP_SYM replica opt_replica_thread_option_list opt_channel
	;

start_replica_stmt :
	START_SYM replica opt_replica_thread_option_list opt_replica_until opt_user_option opt_password_option opt_default_auth_option opt_plugin_dir_option opt_channel
	;

start :
	START_SYM TRANSACTION_SYM opt_start_transaction_option_list
	;

opt_start_transaction_option_list :
	/*empty*/
	| start_transaction_option_list
	;

start_transaction_option_list :
	start_transaction_option
	| start_transaction_option_list ',' start_transaction_option
	;

start_transaction_option :
	WITH CONSISTENT_SYM SNAPSHOT_SYM
	| READ_SYM ONLY_SYM
	| READ_SYM WRITE_SYM
	;

opt_user_option :
	/*empty*/
	| USER EQ /*14L*/ TEXT_STRING_sys
	;

opt_password_option :
	/*empty*/
	| PASSWORD EQ /*14L*/ TEXT_STRING_sys
	;

opt_default_auth_option :
	/*empty*/
	| DEFAULT_AUTH_SYM EQ /*14L*/ TEXT_STRING_sys
	;

opt_plugin_dir_option :
	/*empty*/
	| PLUGIN_DIR_SYM EQ /*14L*/ TEXT_STRING_sys
	;

opt_replica_thread_option_list :
	/*empty*/
	| replica_thread_option_list
	;

replica_thread_option_list :
	replica_thread_option
	| replica_thread_option_list ',' replica_thread_option
	;

replica_thread_option :
	SQL_THREAD
	| RELAY_THREAD
	;

opt_replica_until :
	/*empty*/
	| UNTIL_SYM replica_until
	;

replica_until :
	source_file_def
	| replica_until ',' source_file_def
	| SQL_BEFORE_GTIDS EQ /*14L*/ TEXT_STRING_sys
	| SQL_AFTER_GTIDS EQ /*14L*/ TEXT_STRING_sys
	| SQL_AFTER_MTS_GAPS
	;

checksum :
	CHECKSUM_SYM table_or_tables table_list opt_checksum_type
	;

opt_checksum_type :
	/*empty*/
	| QUICK
	| EXTENDED_SYM
	;

repair_table_stmt :
	REPAIR opt_no_write_to_binlog table_or_tables table_list opt_mi_repair_types
	;

opt_mi_repair_types :
	/*empty*/
	| mi_repair_types
	;

mi_repair_types :
	mi_repair_type
	| mi_repair_types mi_repair_type
	;

mi_repair_type :
	QUICK
	| EXTENDED_SYM
	| USE_FRM
	;

analyze_table_stmt :
	ANALYZE_SYM opt_no_write_to_binlog table_or_tables table_list opt_histogram
	;

opt_histogram_update_param :
	/*empty*/
	| WITH NUM BUCKETS_SYM
	| USING /*8L*/ DATA_SYM TEXT_STRING_literal
	;

opt_histogram :
	/*empty*/
	| UPDATE_SYM HISTOGRAM_SYM ON_SYM /*8L*/ ident_string_list opt_histogram_update_param
	| DROP HISTOGRAM_SYM ON_SYM /*8L*/ ident_string_list
	;

binlog_base64_event :
	BINLOG_SYM TEXT_STRING_sys
	;

check_table_stmt :
	CHECK_SYM table_or_tables table_list opt_mi_check_types
	;

opt_mi_check_types :
	/*empty*/
	| mi_check_types
	;

mi_check_types :
	mi_check_type
	| mi_check_type mi_check_types
	;

mi_check_type :
	QUICK
	| FAST_SYM
	| MEDIUM_SYM
	| EXTENDED_SYM
	| CHANGED
	| FOR_SYM UPGRADE_SYM
	;

optimize_table_stmt :
	OPTIMIZE opt_no_write_to_binlog table_or_tables table_list
	;

opt_no_write_to_binlog :
	/*empty*/
	| NO_WRITE_TO_BINLOG
	| LOCAL_SYM
	;

rename :
	RENAME table_or_tables table_to_table_list
	| RENAME USER rename_list
	;

rename_list :
	user TO_SYM user
	| rename_list ',' user TO_SYM user
	;

table_to_table_list :
	table_to_table
	| table_to_table_list ',' table_to_table
	;

table_to_table :
	table_ident TO_SYM table_ident
	;

keycache_stmt :
	CACHE_SYM INDEX_SYM keycache_list IN_SYM /*14L*/ key_cache_name
	| CACHE_SYM INDEX_SYM table_ident adm_partition opt_cache_key_list IN_SYM /*14L*/ key_cache_name
	;

keycache_list :
	assign_to_keycache
	| keycache_list ',' assign_to_keycache
	;

assign_to_keycache :
	table_ident opt_cache_key_list
	;

key_cache_name :
	ident
	| DEFAULT_SYM
	;

preload_stmt :
	LOAD INDEX_SYM INTO /*29R*/ CACHE_SYM table_ident adm_partition opt_cache_key_list opt_ignore_leaves
	| LOAD INDEX_SYM INTO /*29R*/ CACHE_SYM preload_list
	;

preload_list :
	preload_keys
	| preload_list ',' preload_keys
	;

preload_keys :
	table_ident opt_cache_key_list opt_ignore_leaves
	;

adm_partition :
	PARTITION_SYM '(' /*27L*/ all_or_alt_part_name_list ')' /*27L*/
	;

opt_cache_key_list :
	/*empty*/
	| key_or_index '(' /*27L*/ opt_key_usage_list ')' /*27L*/
	;

opt_ignore_leaves :
	/*empty*/
	| IGNORE_SYM LEAVES
	;

select_stmt :
	query_expression
	| query_expression locking_clause_list
	| select_stmt_with_into
	;

select_stmt_with_into :
	'(' /*27L*/ select_stmt_with_into ')' /*27L*/
	| query_expression into_clause
	| query_expression into_clause locking_clause_list
	| query_expression locking_clause_list into_clause
	;

query_expression :
	query_expression_body opt_order_clause opt_limit_clause
	| with_clause query_expression_body opt_order_clause opt_limit_clause
	;

query_expression_body :
	query_primary
	| query_expression_parens %prec SUBQUERY_AS_EXPR /*26L*/
	| query_expression_body UNION_SYM /*5L*/ union_option query_expression_body
	| query_expression_body EXCEPT_SYM /*5L*/ union_option query_expression_body
	| query_expression_body INTERSECT_SYM /*6L*/ union_option query_expression_body
	;

query_expression_parens :
	'(' /*27L*/ query_expression_parens ')' /*27L*/
	| '(' /*27L*/ query_expression_with_opt_locking_clauses ')' /*27L*/
	;

query_primary :
	query_specification
	| table_value_constructor
	| explicit_table
	;

query_specification :
	SELECT_SYM select_options select_item_list into_clause opt_from_clause opt_where_clause opt_group_clause opt_having_clause opt_window_clause
	| SELECT_SYM select_options select_item_list opt_from_clause opt_where_clause opt_group_clause opt_having_clause opt_window_clause
	;

opt_from_clause :
	%prec EMPTY_FROM_CLAUSE /*28L*/ /*empty*/
	| from_clause
	;

from_clause :
	FROM from_tables
	;

from_tables :
	DUAL_SYM
	| table_reference_list
	;

table_reference_list :
	table_reference
	| table_reference_list ',' table_reference
	;

table_value_constructor :
	VALUES values_row_list
	;

explicit_table :
	TABLE_SYM table_ident
	;

select_options :
	/*empty*/
	| select_option_list
	;

select_option_list :
	select_option_list select_option
	| select_option
	;

select_option :
	query_spec_option
	| SQL_NO_CACHE_SYM
	;

locking_clause_list :
	locking_clause_list locking_clause
	| locking_clause
	;

locking_clause :
	FOR_SYM lock_strength opt_locked_row_action
	| FOR_SYM lock_strength table_locking_list opt_locked_row_action
	| LOCK_SYM IN_SYM /*14L*/ SHARE_SYM MODE_SYM
	;

lock_strength :
	UPDATE_SYM
	| SHARE_SYM
	;

table_locking_list :
	OF_SYM table_alias_ref_list
	;

opt_locked_row_action :
	/*empty*/
	| locked_row_action
	;

locked_row_action :
	SKIP_SYM LOCKED_SYM
	| NOWAIT_SYM
	;

select_item_list :
	select_item_list ',' select_item
	| select_item
	| '*' /*19L*/
	;

select_item :
	table_wild
	| expr select_alias
	;

select_alias :
	/*empty*/
	| AS ident
	| AS TEXT_STRING_validated
	| ident
	| TEXT_STRING_validated
	;

optional_braces :
	/*empty*/
	| '(' /*27L*/ ')' /*27L*/
	;

expr :
	expr or expr %prec OR_SYM /*10L*/
	| expr XOR /*11L*/ expr %prec XOR /*11L*/
	| expr and expr %prec AND_SYM /*12L*/
	| NOT_SYM /*23R*/ expr %prec NOT_SYM /*23R*/
	| bool_pri IS /*14L*/ TRUE_SYM %prec IS /*14L*/
	| bool_pri IS /*14L*/ not TRUE_SYM %prec IS /*14L*/
	| bool_pri IS /*14L*/ FALSE_SYM %prec IS /*14L*/
	| bool_pri IS /*14L*/ not FALSE_SYM %prec IS /*14L*/
	| bool_pri IS /*14L*/ UNKNOWN_SYM %prec IS /*14L*/
	| bool_pri IS /*14L*/ not UNKNOWN_SYM %prec IS /*14L*/
	| bool_pri %prec SET_VAR /*9L*/
	;

bool_pri :
	bool_pri IS /*14L*/ NULL_SYM %prec IS /*14L*/
	| bool_pri IS /*14L*/ not NULL_SYM %prec IS /*14L*/
	| bool_pri comp_op predicate
	| bool_pri comp_op all_or_any table_subquery %prec EQ /*14L*/
	| predicate %prec SET_VAR /*9L*/
	;

predicate :
	bit_expr IN_SYM /*14L*/ table_subquery
	| bit_expr not IN_SYM /*14L*/ table_subquery
	| bit_expr IN_SYM /*14L*/ '(' /*27L*/ expr ')' /*27L*/
	| bit_expr IN_SYM /*14L*/ '(' /*27L*/ expr ',' expr_list ')' /*27L*/
	| bit_expr not IN_SYM /*14L*/ '(' /*27L*/ expr ')' /*27L*/
	| bit_expr not IN_SYM /*14L*/ '(' /*27L*/ expr ',' expr_list ')' /*27L*/
	| bit_expr MEMBER_SYM opt_of '(' /*27L*/ simple_expr ')' /*27L*/
	| bit_expr BETWEEN_SYM /*13L*/ bit_expr AND_SYM /*12L*/ predicate
	| bit_expr not BETWEEN_SYM /*13L*/ bit_expr AND_SYM /*12L*/ predicate
	| bit_expr SOUNDS_SYM LIKE /*14L*/ bit_expr
	| bit_expr LIKE /*14L*/ simple_expr
	| bit_expr LIKE /*14L*/ simple_expr ESCAPE_SYM simple_expr %prec LIKE /*14L*/
	| bit_expr not LIKE /*14L*/ simple_expr
	| bit_expr not LIKE /*14L*/ simple_expr ESCAPE_SYM simple_expr %prec LIKE /*14L*/
	| bit_expr REGEXP /*14L*/ bit_expr
	| bit_expr not REGEXP /*14L*/ bit_expr
	| bit_expr %prec SET_VAR /*9L*/
	;

opt_of :
	OF_SYM
	| /*empty*/
	;

bit_expr :
	bit_expr '|' /*15L*/ bit_expr %prec '|' /*15L*/
	| bit_expr '&' /*16L*/ bit_expr %prec '&' /*16L*/
	| bit_expr SHIFT_LEFT /*17L*/ bit_expr %prec SHIFT_LEFT /*17L*/
	| bit_expr SHIFT_RIGHT /*17L*/ bit_expr %prec SHIFT_RIGHT /*17L*/
	| bit_expr '+' /*18L*/ bit_expr %prec '+' /*18L*/
	| bit_expr '-' /*18L*/ bit_expr %prec '-' /*18L*/
	| bit_expr '+' /*18L*/ INTERVAL_SYM /*25L*/ expr interval %prec '+' /*18L*/
	| bit_expr '-' /*18L*/ INTERVAL_SYM /*25L*/ expr interval %prec '-' /*18L*/
	| bit_expr '*' /*19L*/ bit_expr %prec '*' /*19L*/
	| bit_expr '/' /*19L*/ bit_expr %prec '/' /*19L*/
	| bit_expr '%' /*19L*/ bit_expr %prec '%' /*19L*/
	| bit_expr DIV_SYM /*19L*/ bit_expr %prec DIV_SYM /*19L*/
	| bit_expr MOD_SYM /*19L*/ bit_expr %prec MOD_SYM /*19L*/
	| bit_expr '^' /*20L*/ bit_expr
	| simple_expr %prec SET_VAR /*9L*/
	;

or :
	OR_SYM /*10L*/
	| OR2_SYM /*10L*/
	;

and :
	AND_SYM /*12L*/
	| AND_AND_SYM /*12L*/
	;

not :
	NOT_SYM /*23R*/
	| NOT2_SYM /*23R*/
	;

not2 :
	'!'
	| NOT2_SYM /*23R*/
	;

comp_op :
	EQ /*14L*/
	| EQUAL_SYM /*14L*/
	| GE /*14L*/
	| GT_SYM /*14L*/
	| LE /*14L*/
	| LT /*14L*/
	| NE /*14L*/
	;

all_or_any :
	ALL
	| ANY_SYM
	;

simple_expr :
	simple_ident
	| function_call_keyword
	| function_call_nonkeyword
	| function_call_generic
	| function_call_conflict
	| simple_expr COLLATE_SYM /*24R*/ ident_or_text %prec NEG /*22L*/
	| literal_or_null
	| param_marker
	| rvalue_system_or_user_variable
	| in_expression_user_variable_assignment
	| set_function_specification
	| window_func_call
	| simple_expr OR_OR_SYM /*21L*/ simple_expr
	| '+' /*18L*/ simple_expr %prec NEG /*22L*/
	| '-' /*18L*/ simple_expr %prec NEG /*22L*/
	| '~' /*22L*/ simple_expr %prec NEG /*22L*/
	| not2 simple_expr %prec NEG /*22L*/
	| row_subquery
	| '(' /*27L*/ expr ')' /*27L*/
	| '(' /*27L*/ expr ',' expr_list ')' /*27L*/
	| ROW_SYM '(' /*27L*/ expr ',' expr_list ')' /*27L*/
	| EXISTS table_subquery
	| '{' ident expr '}'
	| MATCH ident_list_arg AGAINST '(' /*27L*/ bit_expr fulltext_options ')' /*27L*/
	| BINARY_SYM /*24R*/ simple_expr %prec NEG /*22L*/
	| CAST_SYM '(' /*27L*/ expr AS cast_type opt_array_cast ')' /*27L*/
	| CAST_SYM '(' /*27L*/ expr AT_SYM LOCAL_SYM AS cast_type opt_array_cast ')' /*27L*/
	| CAST_SYM '(' /*27L*/ expr AT_SYM TIME_SYM ZONE_SYM opt_interval TEXT_STRING_literal AS DATETIME_SYM type_datetime_precision ')' /*27L*/
	| CASE_SYM /*13L*/ opt_expr when_list opt_else END
	| CONVERT_SYM '(' /*27L*/ expr ',' cast_type ')' /*27L*/
	| CONVERT_SYM '(' /*27L*/ expr USING /*8L*/ charset_name ')' /*27L*/
	| DEFAULT_SYM '(' /*27L*/ simple_ident ')' /*27L*/
	| VALUES '(' /*27L*/ simple_ident_nospvar ')' /*27L*/
	| INTERVAL_SYM /*25L*/ expr interval '+' /*18L*/ expr %prec INTERVAL_SYM /*25L*/
	| simple_ident JSON_SEPARATOR_SYM TEXT_STRING_literal
	| simple_ident JSON_UNQUOTED_SEPARATOR_SYM TEXT_STRING_literal
	;

opt_array_cast :
	/*empty*/
	| ARRAY_SYM
	;

function_call_keyword :
	CHAR_SYM '(' /*27L*/ expr_list ')' /*27L*/
	| CHAR_SYM '(' /*27L*/ expr_list USING /*8L*/ charset_name ')' /*27L*/
	| CURRENT_USER optional_braces
	| DATE_SYM '(' /*27L*/ expr ')' /*27L*/
	| DAY_SYM '(' /*27L*/ expr ')' /*27L*/
	| HOUR_SYM '(' /*27L*/ expr ')' /*27L*/
	| INSERT_SYM '(' /*27L*/ expr ',' expr ',' expr ',' expr ')' /*27L*/
	| INTERVAL_SYM /*25L*/ '(' /*27L*/ expr ',' expr ')' /*27L*/ %prec INTERVAL_SYM /*25L*/
	| INTERVAL_SYM /*25L*/ '(' /*27L*/ expr ',' expr ',' expr_list ')' /*27L*/ %prec INTERVAL_SYM /*25L*/
	| JSON_VALUE_SYM '(' /*27L*/ simple_expr ',' text_literal opt_returning_type opt_on_empty_or_error ')' /*27L*/
	| LEFT /*8L*/ '(' /*27L*/ expr ',' expr ')' /*27L*/
	| MINUTE_SYM '(' /*27L*/ expr ')' /*27L*/
	| MONTH_SYM '(' /*27L*/ expr ')' /*27L*/
	| RIGHT /*8L*/ '(' /*27L*/ expr ',' expr ')' /*27L*/
	| SECOND_SYM '(' /*27L*/ expr ')' /*27L*/
	| TIME_SYM '(' /*27L*/ expr ')' /*27L*/
	| TIMESTAMP_SYM '(' /*27L*/ expr ')' /*27L*/
	| TIMESTAMP_SYM '(' /*27L*/ expr ',' expr ')' /*27L*/
	| TRIM '(' /*27L*/ expr ')' /*27L*/
	| TRIM '(' /*27L*/ LEADING expr FROM expr ')' /*27L*/
	| TRIM '(' /*27L*/ TRAILING expr FROM expr ')' /*27L*/
	| TRIM '(' /*27L*/ BOTH expr FROM expr ')' /*27L*/
	| TRIM '(' /*27L*/ LEADING FROM expr ')' /*27L*/
	| TRIM '(' /*27L*/ TRAILING FROM expr ')' /*27L*/
	| TRIM '(' /*27L*/ BOTH FROM expr ')' /*27L*/
	| TRIM '(' /*27L*/ expr FROM expr ')' /*27L*/
	| USER '(' /*27L*/ ')' /*27L*/
	| YEAR_SYM '(' /*27L*/ expr ')' /*27L*/
	;

function_call_nonkeyword :
	ADDDATE_SYM '(' /*27L*/ expr ',' expr ')' /*27L*/
	| ADDDATE_SYM '(' /*27L*/ expr ',' INTERVAL_SYM /*25L*/ expr interval ')' /*27L*/
	| CURDATE optional_braces
	| CURTIME func_datetime_precision
	| DATE_ADD_INTERVAL '(' /*27L*/ expr ',' INTERVAL_SYM /*25L*/ expr interval ')' /*27L*/ %prec INTERVAL_SYM /*25L*/
	| DATE_SUB_INTERVAL '(' /*27L*/ expr ',' INTERVAL_SYM /*25L*/ expr interval ')' /*27L*/ %prec INTERVAL_SYM /*25L*/
	| EXTRACT_SYM '(' /*27L*/ interval FROM expr ')' /*27L*/
	| GET_FORMAT '(' /*27L*/ date_time_type ',' expr ')' /*27L*/
	| now
	| POSITION_SYM '(' /*27L*/ bit_expr IN_SYM /*14L*/ expr ')' /*27L*/
	| SUBDATE_SYM '(' /*27L*/ expr ',' expr ')' /*27L*/
	| SUBDATE_SYM '(' /*27L*/ expr ',' INTERVAL_SYM /*25L*/ expr interval ')' /*27L*/
	| SUBSTRING '(' /*27L*/ expr ',' expr ',' expr ')' /*27L*/
	| SUBSTRING '(' /*27L*/ expr ',' expr ')' /*27L*/
	| SUBSTRING '(' /*27L*/ expr FROM expr FOR_SYM expr ')' /*27L*/
	| SUBSTRING '(' /*27L*/ expr FROM expr ')' /*27L*/
	| SYSDATE func_datetime_precision
	| TIMESTAMP_ADD '(' /*27L*/ interval_time_stamp ',' expr ',' expr ')' /*27L*/
	| TIMESTAMP_DIFF '(' /*27L*/ interval_time_stamp ',' expr ',' expr ')' /*27L*/
	| UTC_DATE_SYM optional_braces
	| UTC_TIME_SYM func_datetime_precision
	| UTC_TIMESTAMP_SYM func_datetime_precision
	;

opt_returning_type :
	/*empty*/
	| RETURNING_SYM cast_type
	;

function_call_conflict :
	ASCII_SYM '(' /*27L*/ expr ')' /*27L*/
	| CHARSET '(' /*27L*/ expr ')' /*27L*/
	| COALESCE '(' /*27L*/ expr_list ')' /*27L*/
	| COLLATION_SYM '(' /*27L*/ expr ')' /*27L*/
	| DATABASE '(' /*27L*/ ')' /*27L*/
	| IF '(' /*27L*/ expr ',' expr ',' expr ')' /*27L*/
	| FORMAT_SYM '(' /*27L*/ expr ',' expr ')' /*27L*/
	| FORMAT_SYM '(' /*27L*/ expr ',' expr ',' expr ')' /*27L*/
	| MICROSECOND_SYM '(' /*27L*/ expr ')' /*27L*/
	| MOD_SYM /*19L*/ '(' /*27L*/ expr ',' expr ')' /*27L*/
	| QUARTER_SYM '(' /*27L*/ expr ')' /*27L*/
	| REPEAT_SYM '(' /*27L*/ expr ',' expr ')' /*27L*/
	| REPLACE_SYM '(' /*27L*/ expr ',' expr ',' expr ')' /*27L*/
	| REVERSE_SYM '(' /*27L*/ expr ')' /*27L*/
	| ROW_COUNT_SYM '(' /*27L*/ ')' /*27L*/
	| TRUNCATE_SYM '(' /*27L*/ expr ',' expr ')' /*27L*/
	| WEEK_SYM '(' /*27L*/ expr ')' /*27L*/
	| WEEK_SYM '(' /*27L*/ expr ',' expr ')' /*27L*/
	| WEIGHT_STRING_SYM '(' /*27L*/ expr ')' /*27L*/
	| WEIGHT_STRING_SYM '(' /*27L*/ expr AS CHAR_SYM ws_num_codepoints ')' /*27L*/
	| WEIGHT_STRING_SYM '(' /*27L*/ expr AS BINARY_SYM /*24R*/ ws_num_codepoints ')' /*27L*/
	| WEIGHT_STRING_SYM '(' /*27L*/ expr ',' ulong_num ',' ulong_num ',' ulong_num ')' /*27L*/
	| geometry_function
	;

geometry_function :
	GEOMETRYCOLLECTION_SYM '(' /*27L*/ opt_expr_list ')' /*27L*/
	| LINESTRING_SYM '(' /*27L*/ expr_list ')' /*27L*/
	| MULTILINESTRING_SYM '(' /*27L*/ expr_list ')' /*27L*/
	| MULTIPOINT_SYM '(' /*27L*/ expr_list ')' /*27L*/
	| MULTIPOLYGON_SYM '(' /*27L*/ expr_list ')' /*27L*/
	| POINT_SYM '(' /*27L*/ expr ',' expr ')' /*27L*/
	| POLYGON_SYM '(' /*27L*/ expr_list ')' /*27L*/
	;

function_call_generic :
	IDENT_sys '(' /*27L*/ opt_udf_expr_list ')' /*27L*/
	| ident '.' ident '(' /*27L*/ opt_expr_list ')' /*27L*/
	;

fulltext_options :
	opt_natural_language_mode opt_query_expansion
	| IN_SYM /*14L*/ BOOLEAN_SYM MODE_SYM
	;

opt_natural_language_mode :
	/*empty*/
	| IN_SYM /*14L*/ NATURAL /*8L*/ LANGUAGE_SYM MODE_SYM
	;

opt_query_expansion :
	/*empty*/
	| WITH QUERY_SYM EXPANSION_SYM
	;

opt_udf_expr_list :
	/*empty*/
	| udf_expr_list
	;

udf_expr_list :
	udf_expr
	| udf_expr_list ',' udf_expr
	;

udf_expr :
	expr select_alias
	;

set_function_specification :
	sum_expr
	| grouping_operation
	;

sum_expr :
	AVG_SYM '(' /*27L*/ in_sum_expr ')' /*27L*/ opt_windowing_clause
	| AVG_SYM '(' /*27L*/ DISTINCT in_sum_expr ')' /*27L*/ opt_windowing_clause
	| BIT_AND_SYM '(' /*27L*/ in_sum_expr ')' /*27L*/ opt_windowing_clause
	| BIT_OR_SYM '(' /*27L*/ in_sum_expr ')' /*27L*/ opt_windowing_clause
	| JSON_ARRAYAGG '(' /*27L*/ in_sum_expr ')' /*27L*/ opt_windowing_clause
	| JSON_OBJECTAGG '(' /*27L*/ in_sum_expr ',' in_sum_expr ')' /*27L*/ opt_windowing_clause
	| ST_COLLECT_SYM '(' /*27L*/ in_sum_expr ')' /*27L*/ opt_windowing_clause
	| ST_COLLECT_SYM '(' /*27L*/ DISTINCT in_sum_expr ')' /*27L*/ opt_windowing_clause
	| BIT_XOR_SYM '(' /*27L*/ in_sum_expr ')' /*27L*/ opt_windowing_clause
	| COUNT_SYM '(' /*27L*/ opt_all '*' /*19L*/ ')' /*27L*/ opt_windowing_clause
	| COUNT_SYM '(' /*27L*/ in_sum_expr ')' /*27L*/ opt_windowing_clause
	| COUNT_SYM '(' /*27L*/ DISTINCT expr_list ')' /*27L*/ opt_windowing_clause
	| MIN_SYM '(' /*27L*/ in_sum_expr ')' /*27L*/ opt_windowing_clause
	| MIN_SYM '(' /*27L*/ DISTINCT in_sum_expr ')' /*27L*/ opt_windowing_clause
	| MAX_SYM '(' /*27L*/ in_sum_expr ')' /*27L*/ opt_windowing_clause
	| MAX_SYM '(' /*27L*/ DISTINCT in_sum_expr ')' /*27L*/ opt_windowing_clause
	| STD_SYM '(' /*27L*/ in_sum_expr ')' /*27L*/ opt_windowing_clause
	| VARIANCE_SYM '(' /*27L*/ in_sum_expr ')' /*27L*/ opt_windowing_clause
	| STDDEV_SAMP_SYM '(' /*27L*/ in_sum_expr ')' /*27L*/ opt_windowing_clause
	| VAR_SAMP_SYM '(' /*27L*/ in_sum_expr ')' /*27L*/ opt_windowing_clause
	| SUM_SYM '(' /*27L*/ in_sum_expr ')' /*27L*/ opt_windowing_clause
	| SUM_SYM '(' /*27L*/ DISTINCT in_sum_expr ')' /*27L*/ opt_windowing_clause
	| GROUP_CONCAT_SYM '(' /*27L*/ opt_distinct expr_list opt_gorder_clause opt_gconcat_separator ')' /*27L*/ opt_windowing_clause
	;

window_func_call :
	ROW_NUMBER_SYM '(' /*27L*/ ')' /*27L*/ windowing_clause
	| RANK_SYM '(' /*27L*/ ')' /*27L*/ windowing_clause
	| DENSE_RANK_SYM '(' /*27L*/ ')' /*27L*/ windowing_clause
	| CUME_DIST_SYM '(' /*27L*/ ')' /*27L*/ windowing_clause
	| PERCENT_RANK_SYM '(' /*27L*/ ')' /*27L*/ windowing_clause
	| NTILE_SYM '(' /*27L*/ stable_integer ')' /*27L*/ windowing_clause
	| LEAD_SYM '(' /*27L*/ expr opt_lead_lag_info ')' /*27L*/ opt_null_treatment windowing_clause
	| LAG_SYM '(' /*27L*/ expr opt_lead_lag_info ')' /*27L*/ opt_null_treatment windowing_clause
	| FIRST_VALUE_SYM '(' /*27L*/ expr ')' /*27L*/ opt_null_treatment windowing_clause
	| LAST_VALUE_SYM '(' /*27L*/ expr ')' /*27L*/ opt_null_treatment windowing_clause
	| NTH_VALUE_SYM '(' /*27L*/ expr ',' simple_expr ')' /*27L*/ opt_from_first_last opt_null_treatment windowing_clause
	;

opt_lead_lag_info :
	/*empty*/
	| ',' stable_integer opt_ll_default
	;

stable_integer :
	int64_literal
	| param_or_var
	;

param_or_var :
	param_marker
	| ident
	| '@' ident_or_text
	;

opt_ll_default :
	/*empty*/
	| ',' expr
	;

opt_null_treatment :
	/*empty*/
	| RESPECT_SYM NULLS_SYM
	| IGNORE_SYM NULLS_SYM
	;

opt_from_first_last :
	/*empty*/
	| FROM FIRST_SYM
	| FROM LAST_SYM
	;

opt_windowing_clause :
	/*empty*/
	| windowing_clause
	;

windowing_clause :
	OVER_SYM window_name_or_spec
	;

window_name_or_spec :
	window_name
	| window_spec
	;

window_name :
	ident
	;

window_spec :
	'(' /*27L*/ window_spec_details ')' /*27L*/
	;

window_spec_details :
	opt_existing_window_name opt_partition_clause opt_window_order_by_clause opt_window_frame_clause
	;

opt_existing_window_name :
	/*empty*/
	| window_name
	;

opt_partition_clause :
	/*empty*/
	| PARTITION_SYM BY group_list
	;

opt_window_order_by_clause :
	/*empty*/
	| ORDER_SYM BY order_list
	;

opt_window_frame_clause :
	/*empty*/
	| window_frame_units window_frame_extent opt_window_frame_exclusion
	;

window_frame_extent :
	window_frame_start
	| window_frame_between
	;

window_frame_start :
	UNBOUNDED_SYM PRECEDING_SYM
	| NUM_literal PRECEDING_SYM
	| param_marker PRECEDING_SYM
	| INTERVAL_SYM /*25L*/ expr interval PRECEDING_SYM
	| CURRENT_SYM ROW_SYM
	;

window_frame_between :
	BETWEEN_SYM /*13L*/ window_frame_bound AND_SYM /*12L*/ window_frame_bound
	;

window_frame_bound :
	window_frame_start
	| UNBOUNDED_SYM FOLLOWING_SYM
	| NUM_literal FOLLOWING_SYM
	| param_marker FOLLOWING_SYM
	| INTERVAL_SYM /*25L*/ expr interval FOLLOWING_SYM
	;

opt_window_frame_exclusion :
	/*empty*/
	| EXCLUDE_SYM CURRENT_SYM ROW_SYM
	| EXCLUDE_SYM GROUP_SYM
	| EXCLUDE_SYM TIES_SYM
	| EXCLUDE_SYM NO_SYM OTHERS_SYM
	;

window_frame_units :
	ROWS_SYM
	| RANGE_SYM
	| GROUPS_SYM
	;

grouping_operation :
	GROUPING_SYM '(' /*27L*/ expr_list ')' /*27L*/
	;

in_expression_user_variable_assignment :
	'@' ident_or_text SET_VAR /*9L*/ expr
	;

rvalue_system_or_user_variable :
	'@' ident_or_text
	| '@' '@' opt_rvalue_system_variable_type rvalue_system_variable
	;

opt_distinct :
	/*empty*/
	| DISTINCT
	;

opt_gconcat_separator :
	/*empty*/
	| SEPARATOR_SYM text_string
	;

opt_gorder_clause :
	/*empty*/
	| ORDER_SYM BY gorder_list
	;

gorder_list :
	gorder_list ',' order_expr
	| order_expr
	;

in_sum_expr :
	opt_all expr
	;

cast_type :
	BINARY_SYM /*24R*/ opt_field_length
	| CHAR_SYM opt_field_length opt_charset_with_opt_binary
	| nchar opt_field_length
	| SIGNED_SYM
	| SIGNED_SYM INT_SYM
	| UNSIGNED_SYM
	| UNSIGNED_SYM INT_SYM
	| DATE_SYM
	| YEAR_SYM
	| TIME_SYM type_datetime_precision
	| DATETIME_SYM type_datetime_precision
	| DECIMAL_SYM float_options
	| JSON_SYM
	| real_type
	| FLOAT_SYM standard_float_options
	| POINT_SYM
	| LINESTRING_SYM
	| POLYGON_SYM
	| MULTIPOINT_SYM
	| MULTILINESTRING_SYM
	| MULTIPOLYGON_SYM
	| GEOMETRYCOLLECTION_SYM
	;

opt_expr_list :
	/*empty*/
	| expr_list
	;

expr_list :
	expr
	| expr_list ',' expr
	;

ident_list_arg :
	ident_list
	| '(' /*27L*/ ident_list ')' /*27L*/
	;

ident_list :
	simple_ident
	| ident_list ',' simple_ident
	;

opt_expr :
	/*empty*/
	| expr
	;

opt_else :
	/*empty*/
	| ELSE /*13L*/ expr
	;

when_list :
	WHEN_SYM /*13L*/ expr THEN_SYM /*13L*/ expr
	| when_list WHEN_SYM /*13L*/ expr THEN_SYM /*13L*/ expr
	;

table_reference :
	table_factor
	| joined_table
	| '{' OJ_SYM esc_table_reference '}'
	;

esc_table_reference :
	table_factor
	| joined_table
	;

joined_table :
	table_reference inner_join_type table_reference ON_SYM /*8L*/ expr
	| table_reference inner_join_type table_reference USING /*8L*/ '(' /*27L*/ using_list ')' /*27L*/
	| table_reference outer_join_type table_reference ON_SYM /*8L*/ expr
	| table_reference outer_join_type table_reference USING /*8L*/ '(' /*27L*/ using_list ')' /*27L*/
	| table_reference inner_join_type table_reference %prec CONDITIONLESS_JOIN /*7L*/
	| table_reference natural_join_type table_factor
	;

natural_join_type :
	NATURAL /*8L*/ opt_inner JOIN_SYM /*8L*/
	| NATURAL /*8L*/ RIGHT /*8L*/ opt_outer JOIN_SYM /*8L*/
	| NATURAL /*8L*/ LEFT /*8L*/ opt_outer JOIN_SYM /*8L*/
	;

inner_join_type :
	JOIN_SYM /*8L*/
	| INNER_SYM /*8L*/ JOIN_SYM /*8L*/
	| CROSS /*8L*/ JOIN_SYM /*8L*/
	| STRAIGHT_JOIN /*8L*/
	;

outer_join_type :
	LEFT /*8L*/ opt_outer JOIN_SYM /*8L*/
	| RIGHT /*8L*/ opt_outer JOIN_SYM /*8L*/
	;

opt_inner :
	/*empty*/
	| INNER_SYM /*8L*/
	;

opt_outer :
	/*empty*/
	| OUTER_SYM
	;

opt_use_partition :
	/*empty*/
	| use_partition
	;

use_partition :
	PARTITION_SYM '(' /*27L*/ using_list ')' /*27L*/
	;

table_factor :
	single_table
	| single_table_parens
	| derived_table
	| joined_table_parens
	| table_reference_list_parens
	| table_function
	;

table_reference_list_parens :
	'(' /*27L*/ table_reference_list_parens ')' /*27L*/
	| '(' /*27L*/ table_reference_list ',' table_reference ')' /*27L*/
	;

single_table_parens :
	'(' /*27L*/ single_table_parens ')' /*27L*/
	| '(' /*27L*/ single_table ')' /*27L*/
	;

single_table :
	table_ident opt_use_partition opt_table_alias opt_key_definition
	;

joined_table_parens :
	'(' /*27L*/ joined_table_parens ')' /*27L*/
	| '(' /*27L*/ joined_table ')' /*27L*/
	;

derived_table :
	table_subquery opt_table_alias opt_derived_column_list
	| LATERAL_SYM table_subquery opt_table_alias opt_derived_column_list
	;

table_function :
	JSON_TABLE_SYM '(' /*27L*/ expr ',' text_literal columns_clause ')' /*27L*/ opt_table_alias
	;

columns_clause :
	COLUMNS '(' /*27L*/ columns_list ')' /*27L*/
	;

columns_list :
	jt_column
	| columns_list ',' jt_column
	;

jt_column :
	ident FOR_SYM ORDINALITY_SYM
	| ident type opt_collate jt_column_type PATH_SYM text_literal opt_on_empty_or_error_json_table
	| NESTED_SYM PATH_SYM text_literal columns_clause
	;

jt_column_type :
	/*empty*/
	| EXISTS
	;

opt_on_empty_or_error :
	/*empty*/
	| on_empty
	| on_error
	| on_empty on_error
	;

opt_on_empty_or_error_json_table :
	opt_on_empty_or_error
	| on_error on_empty
	;

on_empty :
	json_on_response ON_SYM /*8L*/ EMPTY_SYM
	;

on_error :
	json_on_response ON_SYM /*8L*/ ERROR_SYM
	;

json_on_response :
	ERROR_SYM
	| NULL_SYM
	| DEFAULT_SYM signed_literal
	;

index_hint_clause :
	/*empty*/
	| FOR_SYM JOIN_SYM /*8L*/
	| FOR_SYM ORDER_SYM BY
	| FOR_SYM GROUP_SYM BY
	;

index_hint_type :
	FORCE_SYM
	| IGNORE_SYM
	;

index_hint_definition :
	index_hint_type key_or_index index_hint_clause '(' /*27L*/ key_usage_list ')' /*27L*/
	| USE_SYM key_or_index index_hint_clause '(' /*27L*/ opt_key_usage_list ')' /*27L*/
	;

index_hints_list :
	index_hint_definition
	| index_hints_list index_hint_definition
	;

opt_index_hints_list :
	/*empty*/
	| index_hints_list
	;

opt_key_definition :
	opt_index_hints_list
	;

opt_key_usage_list :
	/*empty*/
	| key_usage_list
	;

key_usage_element :
	ident
	| PRIMARY_SYM
	;

key_usage_list :
	key_usage_element
	| key_usage_list ',' key_usage_element
	;

using_list :
	ident_string_list
	;

ident_string_list :
	ident
	| ident_string_list ',' ident
	;

interval :
	interval_time_stamp
	| DAY_HOUR_SYM
	| DAY_MICROSECOND_SYM
	| DAY_MINUTE_SYM
	| DAY_SECOND_SYM
	| HOUR_MICROSECOND_SYM
	| HOUR_MINUTE_SYM
	| HOUR_SECOND_SYM
	| MINUTE_MICROSECOND_SYM
	| MINUTE_SECOND_SYM
	| SECOND_MICROSECOND_SYM
	| YEAR_MONTH_SYM
	;

interval_time_stamp :
	DAY_SYM
	| WEEK_SYM
	| HOUR_SYM
	| MINUTE_SYM
	| MONTH_SYM
	| QUARTER_SYM
	| SECOND_SYM
	| MICROSECOND_SYM
	| YEAR_SYM
	;

date_time_type :
	DATE_SYM
	| TIME_SYM
	| TIMESTAMP_SYM
	| DATETIME_SYM
	;

opt_as :
	/*empty*/
	| AS
	;

opt_table_alias :
	/*empty*/
	| opt_as ident
	;

opt_all :
	/*empty*/
	| ALL
	;

opt_where_clause :
	/*empty*/
	| where_clause
	;

where_clause :
	WHERE expr
	;

opt_having_clause :
	/*empty*/
	| HAVING expr
	;

with_clause :
	WITH with_list
	| WITH RECURSIVE_SYM with_list
	;

with_list :
	with_list ',' common_table_expr
	| common_table_expr
	;

common_table_expr :
	ident opt_derived_column_list AS table_subquery
	;

opt_derived_column_list :
	/*empty*/
	| '(' /*27L*/ simple_ident_list ')' /*27L*/
	;

simple_ident_list :
	ident
	| simple_ident_list ',' ident
	;

opt_window_clause :
	/*empty*/
	| WINDOW_SYM window_definition_list
	;

window_definition_list :
	window_definition
	| window_definition_list ',' window_definition
	;

window_definition :
	window_name AS window_spec
	;

opt_group_clause :
	/*empty*/
	| GROUP_SYM BY group_list olap_opt
	;

group_list :
	group_list ',' grouping_expr
	| grouping_expr
	;

olap_opt :
	/*empty*/
	| WITH_ROLLUP_SYM
	;

alter_order_list :
	alter_order_list ',' alter_order_item
	| alter_order_item
	;

alter_order_item :
	simple_ident_nospvar opt_ordering_direction
	;

opt_order_clause :
	/*empty*/
	| order_clause
	;

order_clause :
	ORDER_SYM BY order_list
	;

order_list :
	order_list ',' order_expr
	| order_expr
	;

opt_ordering_direction :
	/*empty*/
	| ordering_direction
	;

ordering_direction :
	ASC
	| DESC
	;

opt_limit_clause :
	/*empty*/
	| limit_clause
	;

limit_clause :
	LIMIT limit_options
	;

limit_options :
	limit_option
	| limit_option ',' limit_option
	| limit_option OFFSET_SYM limit_option
	;

limit_option :
	ident
	| param_marker
	| ULONGLONG_NUM
	| LONG_NUM
	| NUM
	;

opt_simple_limit :
	/*empty*/
	| LIMIT limit_option
	;

ulong_num :
	NUM
	| HEX_NUM
	| LONG_NUM
	| ULONGLONG_NUM
	| DECIMAL_NUM
	| FLOAT_NUM
	;

real_ulong_num :
	NUM
	| HEX_NUM
	| LONG_NUM
	| ULONGLONG_NUM
	| dec_num_error
	;

ulonglong_num :
	NUM
	| ULONGLONG_NUM
	| LONG_NUM
	| DECIMAL_NUM
	| FLOAT_NUM
	;

real_ulonglong_num :
	NUM
	| HEX_NUM
	| ULONGLONG_NUM
	| LONG_NUM
	| dec_num_error
	;

dec_num_error :
	dec_num
	;

dec_num :
	DECIMAL_NUM
	| FLOAT_NUM
	;

select_var_list :
	select_var_list ',' select_var_ident
	| select_var_ident
	;

select_var_ident :
	'@' ident_or_text
	| ident_or_text
	;

into_clause :
	INTO /*29R*/ into_destination
	;

into_destination :
	OUTFILE TEXT_STRING_filesystem opt_load_data_charset opt_field_term opt_line_term
	| DUMPFILE TEXT_STRING_filesystem
	| select_var_list
	;

do_stmt :
	DO_SYM select_item_list
	;

drop_table_stmt :
	DROP opt_temporary table_or_tables if_exists table_list opt_restrict
	;

drop_index_stmt :
	DROP INDEX_SYM ident ON_SYM /*8L*/ table_ident opt_index_lock_and_algorithm
	;

drop_database_stmt :
	DROP DATABASE if_exists ident
	;

drop_function_stmt :
	DROP FUNCTION_SYM if_exists ident '.' ident
	| DROP FUNCTION_SYM if_exists ident
	;

drop_resource_group_stmt :
	DROP RESOURCE_SYM GROUP_SYM ident opt_force
	;

drop_procedure_stmt :
	DROP PROCEDURE_SYM if_exists sp_name
	;

drop_user_stmt :
	DROP USER if_exists user_list
	;

drop_view_stmt :
	DROP VIEW_SYM if_exists table_list opt_restrict
	;

drop_event_stmt :
	DROP EVENT_SYM if_exists sp_name
	;

drop_trigger_stmt :
	DROP TRIGGER_SYM if_exists sp_name
	;

drop_tablespace_stmt :
	DROP TABLESPACE_SYM ident opt_drop_ts_options
	;

drop_undo_tablespace_stmt :
	DROP UNDO_SYM TABLESPACE_SYM ident opt_undo_tablespace_options
	;

drop_logfile_stmt :
	DROP LOGFILE_SYM GROUP_SYM ident opt_drop_ts_options
	;

drop_server_stmt :
	DROP SERVER_SYM if_exists ident_or_text
	;

drop_srs_stmt :
	DROP SPATIAL_SYM REFERENCE_SYM SYSTEM_SYM if_exists real_ulonglong_num
	;

drop_role_stmt :
	DROP ROLE_SYM if_exists role_list
	;

table_list :
	table_ident
	| table_list ',' table_ident
	;

table_alias_ref_list :
	table_ident_opt_wild
	| table_alias_ref_list ',' table_ident_opt_wild
	;

if_exists :
	/*empty*/
	| IF EXISTS
	;

opt_ignore_unknown_user :
	/*empty*/
	| IGNORE_SYM UNKNOWN_SYM USER
	;

opt_temporary :
	/*empty*/
	| TEMPORARY
	;

opt_drop_ts_options :
	/*empty*/
	| drop_ts_option_list
	;

drop_ts_option_list :
	drop_ts_option
	| drop_ts_option_list opt_comma drop_ts_option
	;

drop_ts_option :
	ts_option_engine
	| ts_option_wait
	;

insert_stmt :
	INSERT_SYM insert_lock_option opt_ignore opt_INTO table_ident opt_use_partition insert_from_constructor opt_values_reference opt_insert_update_list
	| INSERT_SYM insert_lock_option opt_ignore opt_INTO table_ident opt_use_partition SET_SYM update_list opt_values_reference opt_insert_update_list
	| INSERT_SYM insert_lock_option opt_ignore opt_INTO table_ident opt_use_partition insert_query_expression opt_insert_update_list
	;

replace_stmt :
	REPLACE_SYM replace_lock_option opt_INTO table_ident opt_use_partition insert_from_constructor
	| REPLACE_SYM replace_lock_option opt_INTO table_ident opt_use_partition SET_SYM update_list
	| REPLACE_SYM replace_lock_option opt_INTO table_ident opt_use_partition insert_query_expression
	;

insert_lock_option :
	/*empty*/
	| LOW_PRIORITY
	| DELAYED_SYM
	| HIGH_PRIORITY
	;

replace_lock_option :
	opt_low_priority
	| DELAYED_SYM
	;

opt_INTO :
	/*empty*/
	| INTO /*29R*/
	;

insert_from_constructor :
	insert_values
	| '(' /*27L*/ ')' /*27L*/ insert_values
	| '(' /*27L*/ insert_columns ')' /*27L*/ insert_values
	;

insert_query_expression :
	query_expression_with_opt_locking_clauses
	| '(' /*27L*/ ')' /*27L*/ query_expression_with_opt_locking_clauses
	| '(' /*27L*/ insert_columns ')' /*27L*/ query_expression_with_opt_locking_clauses
	;

insert_columns :
	insert_columns ',' insert_column
	| insert_column
	;

insert_values :
	value_or_values values_list
	;

query_expression_with_opt_locking_clauses :
	query_expression
	| query_expression locking_clause_list
	;

value_or_values :
	VALUE_SYM
	| VALUES
	;

values_list :
	values_list ',' row_value
	| row_value
	;

values_row_list :
	values_row_list ',' row_value_explicit
	| row_value_explicit
	;

equal :
	EQ /*14L*/
	| SET_VAR /*9L*/
	;

opt_equal :
	/*empty*/
	| equal
	;

row_value :
	'(' /*27L*/ opt_values ')' /*27L*/
	;

row_value_explicit :
	ROW_SYM '(' /*27L*/ opt_values ')' /*27L*/
	;

opt_values :
	/*empty*/
	| values
	;

values :
	values ',' expr_or_default
	| expr_or_default
	;

expr_or_default :
	expr
	| DEFAULT_SYM
	;

opt_values_reference :
	/*empty*/
	| AS ident opt_derived_column_list
	;

opt_insert_update_list :
	/*empty*/
	| ON_SYM /*8L*/ DUPLICATE_SYM KEY_SYM /*4R*/ UPDATE_SYM update_list
	;

update_stmt :
	opt_with_clause UPDATE_SYM opt_low_priority opt_ignore table_reference_list SET_SYM update_list opt_where_clause opt_order_clause opt_simple_limit
	;

opt_with_clause :
	/*empty*/
	| with_clause
	;

update_list :
	update_list ',' update_elem
	| update_elem
	;

update_elem :
	simple_ident_nospvar equal expr_or_default
	;

opt_low_priority :
	/*empty*/
	| LOW_PRIORITY
	;

delete_stmt :
	opt_with_clause DELETE_SYM opt_delete_options FROM table_ident opt_table_alias opt_use_partition opt_where_clause opt_order_clause opt_simple_limit
	| opt_with_clause DELETE_SYM opt_delete_options table_alias_ref_list FROM table_reference_list opt_where_clause
	| opt_with_clause DELETE_SYM opt_delete_options FROM table_alias_ref_list USING /*8L*/ table_reference_list opt_where_clause
	;

opt_wild :
	/*empty*/
	| '.' '*' /*19L*/
	;

opt_delete_options :
	/*empty*/
	| opt_delete_option opt_delete_options
	;

opt_delete_option :
	QUICK
	| LOW_PRIORITY
	| IGNORE_SYM
	;

truncate_stmt :
	TRUNCATE_SYM opt_table table_ident
	;

opt_table :
	/*empty*/
	| TABLE_SYM
	;

opt_profile_defs :
	/*empty*/
	| profile_defs
	;

profile_defs :
	profile_def
	| profile_defs ',' profile_def
	;

profile_def :
	CPU_SYM
	| MEMORY_SYM
	| BLOCK_SYM IO_SYM
	| CONTEXT_SYM SWITCHES_SYM
	| PAGE_SYM FAULTS_SYM
	| IPC_SYM
	| SWAPS_SYM
	| SOURCE_SYM
	| ALL
	;

opt_for_query :
	/*empty*/
	| FOR_SYM QUERY_SYM NUM
	;

show_databases_stmt :
	SHOW DATABASES opt_wild_or_where
	;

show_tables_stmt :
	SHOW opt_show_cmd_type TABLES opt_db opt_wild_or_where
	;

show_triggers_stmt :
	SHOW opt_full TRIGGERS_SYM opt_db opt_wild_or_where
	;

show_events_stmt :
	SHOW EVENTS_SYM opt_db opt_wild_or_where
	;

show_table_status_stmt :
	SHOW TABLE_SYM STATUS_SYM opt_db opt_wild_or_where
	;

show_open_tables_stmt :
	SHOW OPEN_SYM TABLES opt_db opt_wild_or_where
	;

show_plugins_stmt :
	SHOW PLUGINS_SYM
	;

show_engine_logs_stmt :
	SHOW ENGINE_SYM engine_or_all LOGS_SYM
	;

show_engine_mutex_stmt :
	SHOW ENGINE_SYM engine_or_all MUTEX_SYM
	;

show_engine_status_stmt :
	SHOW ENGINE_SYM engine_or_all STATUS_SYM
	;

show_columns_stmt :
	SHOW opt_show_cmd_type COLUMNS from_or_in table_ident opt_db opt_wild_or_where
	;

show_binary_logs_stmt :
	SHOW master_or_binary LOGS_SYM
	;

show_replicas_stmt :
	SHOW SLAVE HOSTS_SYM
	| SHOW REPLICAS_SYM
	;

show_binlog_events_stmt :
	SHOW BINLOG_SYM EVENTS_SYM opt_binlog_in binlog_from opt_limit_clause
	;

show_relaylog_events_stmt :
	SHOW RELAYLOG_SYM EVENTS_SYM opt_binlog_in binlog_from opt_limit_clause opt_channel
	;

show_keys_stmt :
	SHOW opt_extended keys_or_index from_or_in table_ident opt_db opt_where_clause
	;

show_engines_stmt :
	SHOW opt_storage ENGINES_SYM
	;

show_count_warnings_stmt :
	SHOW COUNT_SYM '(' /*27L*/ '*' /*19L*/ ')' /*27L*/ WARNINGS
	;

show_count_errors_stmt :
	SHOW COUNT_SYM '(' /*27L*/ '*' /*19L*/ ')' /*27L*/ ERRORS
	;

show_warnings_stmt :
	SHOW WARNINGS opt_limit_clause
	;

show_errors_stmt :
	SHOW ERRORS opt_limit_clause
	;

show_profiles_stmt :
	SHOW PROFILES_SYM
	;

show_profile_stmt :
	SHOW PROFILE_SYM opt_profile_defs opt_for_query opt_limit_clause
	;

show_status_stmt :
	SHOW opt_var_type STATUS_SYM opt_wild_or_where
	;

show_processlist_stmt :
	SHOW opt_full PROCESSLIST_SYM
	;

show_variables_stmt :
	SHOW opt_var_type VARIABLES opt_wild_or_where
	;

show_character_set_stmt :
	SHOW character_set opt_wild_or_where
	;

show_collation_stmt :
	SHOW COLLATION_SYM opt_wild_or_where
	;

show_privileges_stmt :
	SHOW PRIVILEGES
	;

show_grants_stmt :
	SHOW GRANTS
	| SHOW GRANTS FOR_SYM user
	| SHOW GRANTS FOR_SYM user USING /*8L*/ user_list
	;

show_create_database_stmt :
	SHOW CREATE DATABASE opt_if_not_exists ident
	;

show_create_table_stmt :
	SHOW CREATE TABLE_SYM table_ident
	;

show_create_view_stmt :
	SHOW CREATE VIEW_SYM table_ident
	;

show_master_status_stmt :
	SHOW MASTER_SYM STATUS_SYM
	;

show_replica_status_stmt :
	SHOW replica STATUS_SYM opt_channel
	;

show_create_procedure_stmt :
	SHOW CREATE PROCEDURE_SYM sp_name
	;

show_create_function_stmt :
	SHOW CREATE FUNCTION_SYM sp_name
	;

show_create_trigger_stmt :
	SHOW CREATE TRIGGER_SYM sp_name
	;

show_procedure_status_stmt :
	SHOW PROCEDURE_SYM STATUS_SYM opt_wild_or_where
	;

show_function_status_stmt :
	SHOW FUNCTION_SYM STATUS_SYM opt_wild_or_where
	;

show_procedure_code_stmt :
	SHOW PROCEDURE_SYM CODE_SYM sp_name
	;

show_function_code_stmt :
	SHOW FUNCTION_SYM CODE_SYM sp_name
	;

show_create_event_stmt :
	SHOW CREATE EVENT_SYM sp_name
	;

show_create_user_stmt :
	SHOW CREATE USER user
	;

show_parse_tree_stmt :
	SHOW PARSE_TREE_SYM simple_statement
	;

engine_or_all :
	ident_or_text
	| ALL
	;

master_or_binary :
	MASTER_SYM
	| BINARY_SYM /*24R*/
	;

opt_storage :
	/*empty*/
	| STORAGE_SYM
	;

opt_db :
	/*empty*/
	| from_or_in ident
	;

opt_full :
	/*empty*/
	| FULL
	;

opt_extended :
	/*empty*/
	| EXTENDED_SYM
	;

opt_show_cmd_type :
	/*empty*/
	| FULL
	| EXTENDED_SYM
	| EXTENDED_SYM FULL
	;

from_or_in :
	FROM
	| IN_SYM /*14L*/
	;

opt_binlog_in :
	/*empty*/
	| IN_SYM /*14L*/ TEXT_STRING_sys
	;

binlog_from :
	/*empty*/
	| FROM ulonglong_num
	;

opt_wild_or_where :
	/*empty*/
	| LIKE /*14L*/ TEXT_STRING_literal
	| where_clause
	;

describe_stmt :
	describe_command table_ident opt_describe_column
	;

explain_stmt :
	describe_command opt_explain_options explainable_stmt
	| describe_command opt_explain_options INTO /*29R*/ '@' ident_or_text explainable_stmt
	;

explainable_stmt :
	select_stmt
	| insert_stmt
	| replace_stmt
	| update_stmt
	| delete_stmt
	| FOR_SYM CONNECTION_SYM real_ulong_num
	;

describe_command :
	DESC
	| DESCRIBE
	;

opt_explain_format :
	/*empty*/
	| FORMAT_SYM EQ /*14L*/ ident_or_text
	;

opt_explain_options :
	ANALYZE_SYM opt_explain_format
	| opt_explain_format
	;

opt_describe_column :
	/*empty*/
	| text_string
	| ident
	;

flush :
	FLUSH_SYM opt_no_write_to_binlog flush_options
	;

flush_options :
	table_or_tables opt_table_list opt_flush_lock
	| flush_options_list
	;

opt_flush_lock :
	/*empty*/
	| WITH READ_SYM LOCK_SYM
	| FOR_SYM EXPORT_SYM
	;

flush_options_list :
	flush_options_list ',' flush_option
	| flush_option
	;

flush_option :
	ERROR_SYM LOGS_SYM
	| ENGINE_SYM LOGS_SYM
	| GENERAL LOGS_SYM
	| SLOW LOGS_SYM
	| BINARY_SYM /*24R*/ LOGS_SYM
	| RELAY LOGS_SYM opt_channel
	| HOSTS_SYM
	| PRIVILEGES
	| LOGS_SYM
	| STATUS_SYM
	| RESOURCES
	| OPTIMIZER_COSTS_SYM
	;

opt_table_list :
	/*empty*/
	| table_list
	;

reset :
	RESET_SYM reset_options
	| RESET_SYM PERSIST_SYM opt_if_exists_ident
	;

reset_options :
	reset_options ',' reset_option
	| reset_option
	;

opt_if_exists_ident :
	/*empty*/
	| if_exists persisted_variable_ident
	;

persisted_variable_ident :
	ident
	| ident '.' ident
	| DEFAULT_SYM '.' ident
	;

reset_option :
	SLAVE opt_replica_reset_options opt_channel
	| REPLICA_SYM opt_replica_reset_options opt_channel
	| MASTER_SYM source_reset_options
	;

opt_replica_reset_options :
	/*empty*/
	| ALL
	;

source_reset_options :
	/*empty*/
	| TO_SYM real_ulonglong_num
	;

purge :
	PURGE purge_options
	;

purge_options :
	master_or_binary LOGS_SYM purge_option
	;

purge_option :
	TO_SYM TEXT_STRING_sys
	| BEFORE_SYM expr
	;

kill :
	KILL_SYM kill_option expr
	;

kill_option :
	/*empty*/
	| CONNECTION_SYM
	| QUERY_SYM
	;

use :
	USE_SYM ident
	;

load_stmt :
	LOAD data_or_xml load_data_lock opt_from_keyword opt_local load_source_type TEXT_STRING_filesystem opt_source_count opt_source_order opt_duplicate INTO /*29R*/ TABLE_SYM table_ident opt_use_partition opt_load_data_charset opt_xml_rows_identified_by opt_field_term opt_line_term opt_ignore_lines opt_field_or_var_spec opt_load_data_set_spec opt_load_algorithm
	;

data_or_xml :
	DATA_SYM
	| XML_SYM
	;

opt_local :
	/*empty*/
	| LOCAL_SYM
	;

opt_from_keyword :
	/*empty*/
	| FROM
	;

load_data_lock :
	/*empty*/
	| CONCURRENT
	| LOW_PRIORITY
	;

load_source_type :
	INFILE_SYM
	| URL_SYM
	;

opt_source_count :
	/*empty*/
	| COUNT_SYM NUM
	| IDENT_sys NUM
	;

opt_source_order :
	/*empty*/
	| IN_SYM /*14L*/ PRIMARY_SYM KEY_SYM /*4R*/ ORDER_SYM
	;

opt_duplicate :
	/*empty*/
	| duplicate
	;

duplicate :
	REPLACE_SYM
	| IGNORE_SYM
	;

opt_field_term :
	/*empty*/
	| COLUMNS field_term_list
	;

field_term_list :
	field_term_list field_term
	| field_term
	;

field_term :
	TERMINATED BY text_string
	| OPTIONALLY ENCLOSED BY text_string
	| ENCLOSED BY text_string
	| ESCAPED BY text_string
	;

opt_line_term :
	/*empty*/
	| LINES line_term_list
	;

line_term_list :
	line_term_list line_term
	| line_term
	;

line_term :
	TERMINATED BY text_string
	| STARTING BY text_string
	;

opt_xml_rows_identified_by :
	/*empty*/
	| ROWS_SYM IDENTIFIED_SYM BY text_string
	;

opt_ignore_lines :
	/*empty*/
	| IGNORE_SYM NUM lines_or_rows
	;

lines_or_rows :
	LINES
	| ROWS_SYM
	;

opt_field_or_var_spec :
	/*empty*/
	| '(' /*27L*/ fields_or_vars ')' /*27L*/
	| '(' /*27L*/ ')' /*27L*/
	;

fields_or_vars :
	fields_or_vars ',' field_or_var
	| field_or_var
	;

field_or_var :
	simple_ident_nospvar
	| '@' ident_or_text
	;

opt_load_data_set_spec :
	/*empty*/
	| SET_SYM load_data_set_list
	;

load_data_set_list :
	load_data_set_list ',' load_data_set_elem
	| load_data_set_elem
	;

load_data_set_elem :
	simple_ident_nospvar equal expr_or_default
	;

opt_load_algorithm :
	/*empty*/
	| ALGORITHM_SYM EQ /*14L*/ BULK_SYM
	;

text_literal :
	TEXT_STRING /*2N*/
	| NCHAR_STRING
	| UNDERSCORE_CHARSET TEXT_STRING /*2N*/
	| text_literal TEXT_STRING_literal
	;

text_string :
	TEXT_STRING_literal
	| HEX_NUM
	| BIN_NUM
	;

param_marker :
	PARAM_MARKER
	;

signed_literal :
	literal
	| '+' /*18L*/ NUM_literal
	| '-' /*18L*/ NUM_literal
	;

signed_literal_or_null :
	signed_literal
	| null_as_literal
	;

null_as_literal :
	NULL_SYM
	;

literal :
	text_literal
	| NUM_literal
	| temporal_literal
	| FALSE_SYM
	| TRUE_SYM
	| HEX_NUM
	| BIN_NUM
	| UNDERSCORE_CHARSET HEX_NUM
	| UNDERSCORE_CHARSET BIN_NUM
	;

literal_or_null :
	literal
	| null_as_literal
	;

NUM_literal :
	int64_literal
	| DECIMAL_NUM
	| FLOAT_NUM
	;

int64_literal :
	NUM
	| LONG_NUM
	| ULONGLONG_NUM
	;

temporal_literal :
	DATE_SYM TEXT_STRING /*2N*/
	| TIME_SYM TEXT_STRING /*2N*/
	| TIMESTAMP_SYM TEXT_STRING /*2N*/
	;

opt_interval :
	/*empty*/
	| INTERVAL_SYM /*25L*/
	;

insert_column :
	simple_ident_nospvar
	;

table_wild :
	ident '.' '*' /*19L*/
	| ident '.' ident '.' '*' /*19L*/
	;

order_expr :
	expr opt_ordering_direction
	;

grouping_expr :
	expr
	;

simple_ident :
	ident
	| simple_ident_q
	;

simple_ident_nospvar :
	ident
	| simple_ident_q
	;

simple_ident_q :
	ident '.' ident
	| ident '.' ident '.' ident
	;

table_ident :
	ident
	| ident '.' ident
	;

table_ident_opt_wild :
	ident opt_wild
	| ident '.' ident opt_wild
	;

IDENT_sys :
	IDENT
	| IDENT_QUOTED
	;

TEXT_STRING_sys_nonewline :
	TEXT_STRING_sys
	;

filter_wild_db_table_string :
	TEXT_STRING_sys_nonewline
	;

TEXT_STRING_sys :
	TEXT_STRING /*2N*/
	;

TEXT_STRING_literal :
	TEXT_STRING /*2N*/
	;

TEXT_STRING_filesystem :
	TEXT_STRING /*2N*/
	;

TEXT_STRING_password :
	TEXT_STRING /*2N*/
	;

TEXT_STRING_hash :
	TEXT_STRING_sys
	| HEX_NUM
	;

TEXT_STRING_validated :
	TEXT_STRING /*2N*/
	;

ident :
	IDENT_sys
	| ident_keyword
	;

role_ident :
	IDENT_sys
	| role_keyword
	;

label_ident :
	IDENT_sys
	| label_keyword
	;

lvalue_ident :
	IDENT_sys
	| lvalue_keyword
	;

ident_or_text :
	ident
	| TEXT_STRING_sys
	| LEX_HOSTNAME
	;

role_ident_or_text :
	role_ident
	| TEXT_STRING_sys
	| LEX_HOSTNAME
	;

user_ident_or_text :
	ident_or_text
	| ident_or_text '@' ident_or_text
	;

user :
	user_ident_or_text
	| CURRENT_USER optional_braces
	;

role :
	role_ident_or_text
	| role_ident_or_text '@' ident_or_text
	;

schema :
	ident
	;

ident_keyword :
	ident_keywords_unambiguous
	| ident_keywords_ambiguous_1_roles_and_labels
	| ident_keywords_ambiguous_2_labels
	| ident_keywords_ambiguous_3_roles
	| ident_keywords_ambiguous_4_system_variables
	;

ident_keywords_ambiguous_1_roles_and_labels :
	EXECUTE_SYM
	| RESTART_SYM
	| SHUTDOWN
	;

ident_keywords_ambiguous_2_labels :
	ASCII_SYM
	| BEGIN_SYM
	| BYTE_SYM
	| CACHE_SYM
	| CHARSET
	| CHECKSUM_SYM
	| CLONE_SYM
	| COMMENT_SYM
	| COMMIT_SYM
	| CONTAINS_SYM
	| DEALLOCATE_SYM
	| DO_SYM
	| END
	| FLUSH_SYM
	| FOLLOWS_SYM
	| HANDLER_SYM
	| HELP_SYM
	| IMPORT
	| INSTALL_SYM
	| LANGUAGE_SYM
	| NO_SYM
	| PRECEDES_SYM
	| PREPARE_SYM
	| REPAIR
	| RESET_SYM
	| ROLLBACK_SYM
	| SAVEPOINT_SYM
	| SIGNED_SYM
	| SLAVE
	| START_SYM
	| STOP_SYM
	| TRUNCATE_SYM
	| UNICODE_SYM
	| UNINSTALL_SYM
	| XA_SYM
	;

label_keyword :
	ident_keywords_unambiguous
	| ident_keywords_ambiguous_3_roles
	| ident_keywords_ambiguous_4_system_variables
	;

ident_keywords_ambiguous_3_roles :
	EVENT_SYM
	| FILE_SYM
	| NONE_SYM
	| PROCESS
	| PROXY_SYM
	| RELOAD
	| REPLICATION
	| RESOURCE_SYM
	| SUPER_SYM
	;

ident_keywords_unambiguous :
	ACTION
	| ACCOUNT_SYM
	| ACTIVE_SYM
	| ADDDATE_SYM
	| ADMIN_SYM
	| AFTER_SYM
	| AGAINST
	| AGGREGATE_SYM
	| ALGORITHM_SYM
	| ALWAYS_SYM
	| ANY_SYM
	| ARRAY_SYM
	| AT_SYM
	| ATTRIBUTE_SYM
	| AUTHENTICATION_SYM
	| AUTOEXTEND_SIZE_SYM
	| AUTO_INC
	| AVG_ROW_LENGTH
	| AVG_SYM
	| BACKUP_SYM
	| BINLOG_SYM
	| BIT_SYM %prec KEYWORD_USED_AS_IDENT /*1L*/
	| BLOCK_SYM
	| BOOLEAN_SYM
	| BOOL_SYM
	| BTREE_SYM
	| BUCKETS_SYM
	| BULK_SYM
	| CASCADED
	| CATALOG_NAME_SYM
	| CHAIN_SYM
	| CHALLENGE_RESPONSE_SYM
	| CHANGED
	| CHANNEL_SYM
	| CIPHER_SYM
	| CLASS_ORIGIN_SYM
	| CLIENT_SYM
	| CLOSE_SYM
	| COALESCE
	| CODE_SYM
	| COLLATION_SYM
	| COLUMNS
	| COLUMN_FORMAT_SYM
	| COLUMN_NAME_SYM
	| COMMITTED_SYM
	| COMPACT_SYM
	| COMPLETION_SYM
	| COMPONENT_SYM
	| COMPRESSED_SYM
	| COMPRESSION_SYM
	| CONCURRENT
	| CONNECTION_SYM
	| CONSISTENT_SYM
	| CONSTRAINT_CATALOG_SYM
	| CONSTRAINT_NAME_SYM
	| CONSTRAINT_SCHEMA_SYM
	| CONTEXT_SYM
	| CPU_SYM
	| CURRENT_SYM
	| CURSOR_NAME_SYM
	| DATAFILE_SYM
	| DATA_SYM
	| DATETIME_SYM
	| DATE_SYM %prec KEYWORD_USED_AS_IDENT /*1L*/
	| DAY_SYM
	| DEFAULT_AUTH_SYM
	| DEFINER_SYM
	| DEFINITION_SYM
	| DELAY_KEY_WRITE_SYM
	| DESCRIPTION_SYM
	| DIAGNOSTICS_SYM
	| DIRECTORY_SYM
	| DISABLE_SYM
	| DISCARD_SYM
	| DISK_SYM
	| DUMPFILE
	| DUPLICATE_SYM
	| DYNAMIC_SYM
	| ENABLE_SYM
	| ENCRYPTION_SYM
	| ENDS_SYM
	| ENFORCED_SYM
	| ENGINES_SYM
	| ENGINE_SYM
	| ENGINE_ATTRIBUTE_SYM
	| ENUM_SYM
	| ERRORS
	| ERROR_SYM
	| ESCAPE_SYM
	| EVENTS_SYM
	| EVERY_SYM
	| EXCHANGE_SYM
	| EXCLUDE_SYM
	| EXPANSION_SYM
	| EXPIRE_SYM
	| EXPORT_SYM
	| EXTENDED_SYM
	| EXTENT_SIZE_SYM
	| FACTOR_SYM
	| FAILED_LOGIN_ATTEMPTS_SYM
	| FAST_SYM
	| FAULTS_SYM
	| FILE_BLOCK_SIZE_SYM
	| FILTER_SYM
	| FINISH_SYM
	| FIRST_SYM
	| FIXED_SYM
	| FOLLOWING_SYM
	| FORMAT_SYM
	| FOUND_SYM
	| FULL
	| GENERAL
	| GENERATE_SYM
	| GEOMETRYCOLLECTION_SYM
	| GEOMETRY_SYM
	| GET_FORMAT
	| GET_MASTER_PUBLIC_KEY_SYM
	| GET_SOURCE_PUBLIC_KEY_SYM
	| GRANTS
	| GROUP_REPLICATION
	| GTID_ONLY_SYM
	| HASH_SYM
	| HISTOGRAM_SYM
	| HISTORY_SYM
	| HOSTS_SYM
	| HOST_SYM
	| HOUR_SYM
	| IDENTIFIED_SYM
	| IGNORE_SERVER_IDS_SYM
	| INACTIVE_SYM
	| INDEXES
	| INITIAL_SIZE_SYM
	| INITIAL_SYM
	| INITIATE_SYM
	| INSERT_METHOD
	| INSTANCE_SYM
	| INVISIBLE_SYM
	| INVOKER_SYM
	| IO_SYM
	| IPC_SYM
	| ISOLATION
	| ISSUER_SYM
	| JSON_SYM
	| JSON_VALUE_SYM
	| KEY_BLOCK_SIZE
	| KEYRING_SYM
	| LAST_SYM
	| LEAVES
	| LESS_SYM
	| LEVEL_SYM
	| LINESTRING_SYM
	| LIST_SYM
	| LOCKED_SYM
	| LOCKS_SYM
	| LOGFILE_SYM
	| LOGS_SYM
	| MASTER_AUTO_POSITION_SYM
	| MASTER_COMPRESSION_ALGORITHM_SYM
	| MASTER_CONNECT_RETRY_SYM
	| MASTER_DELAY_SYM
	| MASTER_HEARTBEAT_PERIOD_SYM
	| MASTER_HOST_SYM
	| NETWORK_NAMESPACE_SYM
	| MASTER_LOG_FILE_SYM
	| MASTER_LOG_POS_SYM
	| MASTER_PASSWORD_SYM
	| MASTER_PORT_SYM
	| MASTER_PUBLIC_KEY_PATH_SYM
	| MASTER_RETRY_COUNT_SYM
	| MASTER_SSL_CAPATH_SYM
	| MASTER_SSL_CA_SYM
	| MASTER_SSL_CERT_SYM
	| MASTER_SSL_CIPHER_SYM
	| MASTER_SSL_CRLPATH_SYM
	| MASTER_SSL_CRL_SYM
	| MASTER_SSL_KEY_SYM
	| MASTER_SSL_SYM
	| MASTER_SYM
	| MASTER_TLS_CIPHERSUITES_SYM
	| MASTER_TLS_VERSION_SYM
	| MASTER_USER_SYM
	| MASTER_ZSTD_COMPRESSION_LEVEL_SYM
	| MAX_CONNECTIONS_PER_HOUR
	| MAX_QUERIES_PER_HOUR
	| MAX_ROWS
	| MAX_SIZE_SYM
	| MAX_UPDATES_PER_HOUR
	| MAX_USER_CONNECTIONS_SYM
	| MEDIUM_SYM
	| MEMBER_SYM
	| MEMORY_SYM
	| MERGE_SYM
	| MESSAGE_TEXT_SYM
	| MICROSECOND_SYM
	| MIGRATE_SYM
	| MINUTE_SYM
	| MIN_ROWS
	| MODE_SYM
	| MODIFY_SYM
	| MONTH_SYM
	| MULTILINESTRING_SYM
	| MULTIPOINT_SYM
	| MULTIPOLYGON_SYM
	| MUTEX_SYM
	| MYSQL_ERRNO_SYM
	| NAMES_SYM %prec KEYWORD_USED_AS_IDENT /*1L*/
	| NAME_SYM
	| NATIONAL_SYM
	| NCHAR_SYM
	| NDBCLUSTER_SYM
	| NESTED_SYM
	| NEVER_SYM
	| NEW_SYM
	| NEXT_SYM
	| NODEGROUP_SYM
	| NOWAIT_SYM
	| NO_WAIT_SYM
	| NULLS_SYM
	| NUMBER_SYM
	| NVARCHAR_SYM
	| OFF_SYM
	| OFFSET_SYM
	| OJ_SYM
	| OLD_SYM
	| ONE_SYM
	| ONLY_SYM
	| OPEN_SYM
	| OPTIONAL_SYM
	| OPTIONS_SYM
	| ORDINALITY_SYM
	| ORGANIZATION_SYM
	| OTHERS_SYM
	| OWNER_SYM
	| PACK_KEYS_SYM
	| PAGE_SYM
	| PARSER_SYM
	| PARSE_TREE_SYM
	| PARTIAL
	| PARTITIONING_SYM
	| PARTITIONS_SYM
	| PASSWORD %prec KEYWORD_USED_AS_IDENT /*1L*/
	| PASSWORD_LOCK_TIME_SYM
	| PATH_SYM
	| PHASE_SYM
	| PLUGINS_SYM
	| PLUGIN_DIR_SYM
	| PLUGIN_SYM
	| POINT_SYM
	| POLYGON_SYM
	| PORT_SYM
	| PRECEDING_SYM
	| PRESERVE_SYM
	| PREV_SYM
	| PRIVILEGES
	| PRIVILEGE_CHECKS_USER_SYM
	| PROCESSLIST_SYM
	| PROFILES_SYM
	| PROFILE_SYM
	| QUARTER_SYM
	| QUERY_SYM
	| QUICK
	| RANDOM_SYM
	| READ_ONLY_SYM
	| REBUILD_SYM
	| RECOVER_SYM
	| REDO_BUFFER_SIZE_SYM
	| REDUNDANT_SYM
	| REFERENCE_SYM
	| REGISTRATION_SYM
	| RELAY
	| RELAYLOG_SYM
	| RELAY_LOG_FILE_SYM
	| RELAY_LOG_POS_SYM
	| RELAY_THREAD
	| REMOVE_SYM
	| ASSIGN_GTIDS_TO_ANONYMOUS_TRANSACTIONS_SYM
	| REORGANIZE_SYM
	| REPEATABLE_SYM
	| REPLICAS_SYM
	| REPLICATE_DO_DB
	| REPLICATE_DO_TABLE
	| REPLICATE_IGNORE_DB
	| REPLICATE_IGNORE_TABLE
	| REPLICATE_REWRITE_DB
	| REPLICATE_WILD_DO_TABLE
	| REPLICATE_WILD_IGNORE_TABLE
	| REPLICA_SYM
	| REQUIRE_ROW_FORMAT_SYM
	| REQUIRE_TABLE_PRIMARY_KEY_CHECK_SYM
	| RESOURCES
	| RESPECT_SYM
	| RESTORE_SYM
	| RESUME_SYM
	| RETAIN_SYM
	| RETURNED_SQLSTATE_SYM
	| RETURNING_SYM
	| RETURNS_SYM
	| REUSE_SYM
	| REVERSE_SYM
	| ROLE_SYM
	| ROLLUP_SYM
	| ROTATE_SYM
	| ROUTINE_SYM
	| ROW_COUNT_SYM
	| ROW_FORMAT_SYM
	| RTREE_SYM
	| SCHEDULE_SYM
	| SCHEMA_NAME_SYM
	| SECONDARY_ENGINE_SYM
	| SECONDARY_ENGINE_ATTRIBUTE_SYM
	| SECONDARY_LOAD_SYM
	| SECONDARY_SYM
	| SECONDARY_UNLOAD_SYM
	| SECOND_SYM
	| SECURITY_SYM
	| SERIALIZABLE_SYM
	| SERIAL_SYM
	| SERVER_SYM
	| SHARE_SYM
	| SIMPLE_SYM
	| SKIP_SYM
	| SLOW
	| SNAPSHOT_SYM
	| SOCKET_SYM
	| SONAME_SYM
	| SOUNDS_SYM
	| SOURCE_AUTO_POSITION_SYM
	| SOURCE_BIND_SYM
	| SOURCE_COMPRESSION_ALGORITHM_SYM
	| SOURCE_CONNECTION_AUTO_FAILOVER_SYM
	| SOURCE_CONNECT_RETRY_SYM
	| SOURCE_DELAY_SYM
	| SOURCE_HEARTBEAT_PERIOD_SYM
	| SOURCE_HOST_SYM
	| SOURCE_LOG_FILE_SYM
	| SOURCE_LOG_POS_SYM
	| SOURCE_PASSWORD_SYM
	| SOURCE_PORT_SYM
	| SOURCE_PUBLIC_KEY_PATH_SYM
	| SOURCE_RETRY_COUNT_SYM
	| SOURCE_SSL_CAPATH_SYM
	| SOURCE_SSL_CA_SYM
	| SOURCE_SSL_CERT_SYM
	| SOURCE_SSL_CIPHER_SYM
	| SOURCE_SSL_CRLPATH_SYM
	| SOURCE_SSL_CRL_SYM
	| SOURCE_SSL_KEY_SYM
	| SOURCE_SSL_SYM
	| SOURCE_SSL_VERIFY_SERVER_CERT_SYM
	| SOURCE_SYM
	| SOURCE_TLS_CIPHERSUITES_SYM
	| SOURCE_TLS_VERSION_SYM
	| SOURCE_USER_SYM
	| SOURCE_ZSTD_COMPRESSION_LEVEL_SYM
	| SQL_AFTER_GTIDS
	| SQL_AFTER_MTS_GAPS
	| SQL_BEFORE_GTIDS
	| SQL_BUFFER_RESULT
	| SQL_NO_CACHE_SYM
	| SQL_THREAD
	| SRID_SYM
	| STACKED_SYM
	| STARTS_SYM
	| STATS_AUTO_RECALC_SYM
	| STATS_PERSISTENT_SYM
	| STATS_SAMPLE_PAGES_SYM
	| STATUS_SYM
	| STORAGE_SYM
	| STREAM_SYM
	| STRING_SYM
	| ST_COLLECT_SYM
	| SUBCLASS_ORIGIN_SYM
	| SUBDATE_SYM
	| SUBJECT_SYM
	| SUBPARTITIONS_SYM
	| SUBPARTITION_SYM
	| SUSPEND_SYM
	| SWAPS_SYM
	| SWITCHES_SYM
	| TABLES
	| TABLESPACE_SYM
	| TABLE_CHECKSUM_SYM
	| TABLE_NAME_SYM
	| TEMPORARY
	| TEMPTABLE_SYM
	| TEXT_SYM
	| THAN_SYM
	| THREAD_PRIORITY_SYM
	| TIES_SYM
	| TIMESTAMP_ADD
	| TIMESTAMP_DIFF
	| TIMESTAMP_SYM %prec KEYWORD_USED_AS_IDENT /*1L*/
	| TIME_SYM %prec KEYWORD_USED_AS_IDENT /*1L*/
	| TLS_SYM
	| TRANSACTION_SYM
	| TRIGGERS_SYM
	| TYPES_SYM
	| TYPE_SYM
	| UNBOUNDED_SYM
	| UNCOMMITTED_SYM
	| UNDEFINED_SYM
	| UNDOFILE_SYM
	| UNDO_BUFFER_SIZE_SYM
	| UNKNOWN_SYM
	| UNREGISTER_SYM
	| UNTIL_SYM
	| UPGRADE_SYM
	| URL_SYM
	| USER
	| USE_FRM
	| VALIDATION_SYM
	| VALUE_SYM
	| VARIABLES
	| VCPU_SYM
	| VIEW_SYM
	| VISIBLE_SYM
	| WAIT_SYM
	| WARNINGS
	| WEEK_SYM
	| WEIGHT_STRING_SYM
	| WITHOUT_SYM
	| WORK_SYM
	| WRAPPER_SYM
	| X509_SYM
	| XID_SYM
	| XML_SYM
	| YEAR_SYM
	| ZONE_SYM
	;

role_keyword :
	ident_keywords_unambiguous
	| ident_keywords_ambiguous_2_labels
	| ident_keywords_ambiguous_4_system_variables
	;

lvalue_keyword :
	ident_keywords_unambiguous
	| ident_keywords_ambiguous_1_roles_and_labels
	| ident_keywords_ambiguous_2_labels
	| ident_keywords_ambiguous_3_roles
	;

ident_keywords_ambiguous_4_system_variables :
	GLOBAL_SYM
	| LOCAL_SYM
	| PERSIST_SYM
	| PERSIST_ONLY_SYM
	| SESSION_SYM
	;

set :
	SET_SYM start_option_value_list
	;

start_option_value_list :
	option_value_no_option_type option_value_list_continued
	| TRANSACTION_SYM transaction_characteristics
	| option_type start_option_value_list_following_option_type
	| PASSWORD equal TEXT_STRING_password opt_replace_password opt_retain_current_password
	| PASSWORD TO_SYM RANDOM_SYM opt_replace_password opt_retain_current_password
	| PASSWORD FOR_SYM user equal TEXT_STRING_password opt_replace_password opt_retain_current_password
	| PASSWORD FOR_SYM user TO_SYM RANDOM_SYM opt_replace_password opt_retain_current_password
	;

set_role_stmt :
	SET_SYM ROLE_SYM role_list
	| SET_SYM ROLE_SYM NONE_SYM
	| SET_SYM ROLE_SYM DEFAULT_SYM
	| SET_SYM DEFAULT_SYM ROLE_SYM role_list TO_SYM role_list
	| SET_SYM DEFAULT_SYM ROLE_SYM NONE_SYM TO_SYM role_list
	| SET_SYM DEFAULT_SYM ROLE_SYM ALL TO_SYM role_list
	| SET_SYM ROLE_SYM ALL opt_except_role_list
	;

opt_except_role_list :
	/*empty*/
	| EXCEPT_SYM /*5L*/ role_list
	;

set_resource_group_stmt :
	SET_SYM RESOURCE_SYM GROUP_SYM ident
	| SET_SYM RESOURCE_SYM GROUP_SYM ident FOR_SYM thread_id_list_options
	;

thread_id_list :
	real_ulong_num
	| thread_id_list opt_comma real_ulong_num
	;

thread_id_list_options :
	thread_id_list
	;

start_option_value_list_following_option_type :
	option_value_following_option_type option_value_list_continued
	| TRANSACTION_SYM transaction_characteristics
	;

option_value_list_continued :
	/*empty*/
	| ',' option_value_list
	;

option_value_list :
	option_value
	| option_value_list ',' option_value
	;

option_value :
	option_type option_value_following_option_type
	| option_value_no_option_type
	;

option_type :
	GLOBAL_SYM
	| PERSIST_SYM
	| PERSIST_ONLY_SYM
	| LOCAL_SYM
	| SESSION_SYM
	;

opt_var_type :
	/*empty*/
	| GLOBAL_SYM
	| LOCAL_SYM
	| SESSION_SYM
	;

opt_rvalue_system_variable_type :
	/*empty*/
	| GLOBAL_SYM '.'
	| LOCAL_SYM '.'
	| SESSION_SYM '.'
	;

opt_set_var_ident_type :
	/*empty*/
	| PERSIST_SYM '.'
	| PERSIST_ONLY_SYM '.'
	| GLOBAL_SYM '.'
	| LOCAL_SYM '.'
	| SESSION_SYM '.'
	;

option_value_following_option_type :
	lvalue_variable equal set_expr_or_default
	;

option_value_no_option_type :
	lvalue_variable equal set_expr_or_default
	| '@' ident_or_text equal expr
	| '@' '@' opt_set_var_ident_type lvalue_variable equal set_expr_or_default
	| character_set old_or_new_charset_name_or_default
	| NAMES_SYM equal expr
	| NAMES_SYM charset_name opt_collate
	| NAMES_SYM DEFAULT_SYM
	;

lvalue_variable :
	lvalue_ident
	| lvalue_ident '.' ident
	| DEFAULT_SYM '.' ident
	;

rvalue_system_variable :
	ident_or_text
	| ident_or_text '.' ident
	;

transaction_characteristics :
	transaction_access_mode opt_isolation_level
	| isolation_level opt_transaction_access_mode
	;

transaction_access_mode :
	transaction_access_mode_types
	;

opt_transaction_access_mode :
	/*empty*/
	| ',' transaction_access_mode
	;

isolation_level :
	ISOLATION LEVEL_SYM isolation_types
	;

opt_isolation_level :
	/*empty*/
	| ',' isolation_level
	;

transaction_access_mode_types :
	READ_SYM ONLY_SYM
	| READ_SYM WRITE_SYM
	;

isolation_types :
	READ_SYM UNCOMMITTED_SYM
	| READ_SYM COMMITTED_SYM
	| REPEATABLE_SYM READ_SYM
	| SERIALIZABLE_SYM
	;

set_expr_or_default :
	expr
	| DEFAULT_SYM
	| ON_SYM /*8L*/
	| ALL
	| BINARY_SYM /*24R*/
	| ROW_SYM
	| SYSTEM_SYM
	;

lock :
	LOCK_SYM table_or_tables table_lock_list
	| LOCK_SYM INSTANCE_SYM FOR_SYM BACKUP_SYM
	;

table_or_tables :
	TABLE_SYM
	| TABLES
	;

table_lock_list :
	table_lock
	| table_lock_list ',' table_lock
	;

table_lock :
	table_ident opt_table_alias lock_option
	;

lock_option :
	READ_SYM
	| WRITE_SYM
	| LOW_PRIORITY WRITE_SYM
	| READ_SYM LOCAL_SYM
	;

unlock :
	UNLOCK_SYM table_or_tables
	| UNLOCK_SYM INSTANCE_SYM
	;

shutdown_stmt :
	SHUTDOWN
	;

restart_server_stmt :
	RESTART_SYM
	;

alter_instance_stmt :
	ALTER INSTANCE_SYM alter_instance_action
	;

alter_instance_action :
	ROTATE_SYM ident_or_text MASTER_SYM KEY_SYM /*4R*/
	| RELOAD TLS_SYM
	| RELOAD TLS_SYM NO_SYM ROLLBACK_SYM ON_SYM /*8L*/ ERROR_SYM
	| RELOAD TLS_SYM FOR_SYM CHANNEL_SYM ident
	| RELOAD TLS_SYM FOR_SYM CHANNEL_SYM ident NO_SYM ROLLBACK_SYM ON_SYM /*8L*/ ERROR_SYM
	| ENABLE_SYM ident ident
	| DISABLE_SYM ident ident
	| RELOAD KEYRING_SYM
	;

handler_stmt :
	HANDLER_SYM table_ident OPEN_SYM opt_table_alias
	| HANDLER_SYM ident CLOSE_SYM
	| HANDLER_SYM ident READ_SYM handler_scan_function opt_where_clause opt_limit_clause
	| HANDLER_SYM ident READ_SYM ident handler_rkey_function opt_where_clause opt_limit_clause
	| HANDLER_SYM ident READ_SYM ident handler_rkey_mode '(' /*27L*/ values ')' /*27L*/ opt_where_clause opt_limit_clause
	;

handler_scan_function :
	FIRST_SYM
	| NEXT_SYM
	;

handler_rkey_function :
	FIRST_SYM
	| NEXT_SYM
	| PREV_SYM
	| LAST_SYM
	;

handler_rkey_mode :
	EQ /*14L*/
	| GE /*14L*/
	| LE /*14L*/
	| GT_SYM /*14L*/
	| LT /*14L*/
	;

revoke :
	REVOKE if_exists role_or_privilege_list FROM user_list opt_ignore_unknown_user
	| REVOKE if_exists role_or_privilege_list ON_SYM /*8L*/ opt_acl_type grant_ident FROM user_list opt_ignore_unknown_user
	| REVOKE if_exists ALL opt_privileges ON_SYM /*8L*/ opt_acl_type grant_ident FROM user_list opt_ignore_unknown_user
	| REVOKE if_exists ALL opt_privileges ',' GRANT OPTION FROM user_list opt_ignore_unknown_user
	| REVOKE if_exists PROXY_SYM ON_SYM /*8L*/ user FROM user_list opt_ignore_unknown_user
	;

grant :
	GRANT role_or_privilege_list TO_SYM user_list opt_with_admin_option
	| GRANT role_or_privilege_list ON_SYM /*8L*/ opt_acl_type grant_ident TO_SYM user_list grant_options opt_grant_as
	| GRANT ALL opt_privileges ON_SYM /*8L*/ opt_acl_type grant_ident TO_SYM user_list grant_options opt_grant_as
	| GRANT PROXY_SYM ON_SYM /*8L*/ user TO_SYM user_list opt_grant_option
	;

opt_acl_type :
	/*empty*/
	| TABLE_SYM
	| FUNCTION_SYM
	| PROCEDURE_SYM
	;

opt_privileges :
	/*empty*/
	| PRIVILEGES
	;

role_or_privilege_list :
	role_or_privilege
	| role_or_privilege_list ',' role_or_privilege
	;

role_or_privilege :
	role_ident_or_text opt_column_list
	| role_ident_or_text '@' ident_or_text
	| SELECT_SYM opt_column_list
	| INSERT_SYM opt_column_list
	| UPDATE_SYM opt_column_list
	| REFERENCES opt_column_list
	| DELETE_SYM
	| USAGE
	| INDEX_SYM
	| ALTER
	| CREATE
	| DROP
	| EXECUTE_SYM
	| RELOAD
	| SHUTDOWN
	| PROCESS
	| FILE_SYM
	| GRANT OPTION
	| SHOW DATABASES
	| SUPER_SYM
	| CREATE TEMPORARY TABLES
	| LOCK_SYM TABLES
	| REPLICATION SLAVE
	| REPLICATION CLIENT_SYM
	| CREATE VIEW_SYM
	| SHOW VIEW_SYM
	| CREATE ROUTINE_SYM
	| ALTER ROUTINE_SYM
	| CREATE USER
	| EVENT_SYM
	| TRIGGER_SYM
	| CREATE TABLESPACE_SYM
	| CREATE ROLE_SYM
	| DROP ROLE_SYM
	;

opt_with_admin_option :
	/*empty*/
	| WITH ADMIN_SYM OPTION
	;

opt_and :
	/*empty*/
	| AND_SYM /*12L*/
	;

require_list :
	require_list_element opt_and require_list
	| require_list_element
	;

require_list_element :
	SUBJECT_SYM TEXT_STRING /*2N*/
	| ISSUER_SYM TEXT_STRING /*2N*/
	| CIPHER_SYM TEXT_STRING /*2N*/
	;

grant_ident :
	'*' /*19L*/
	| schema '.' '*' /*19L*/
	| '*' /*19L*/ '.' '*' /*19L*/
	| ident
	| schema '.' ident
	;

user_list :
	user
	| user_list ',' user
	;

role_list :
	role
	| role_list ',' role
	;

opt_retain_current_password :
	/*empty*/
	| RETAIN_SYM CURRENT_SYM PASSWORD
	;

opt_discard_old_password :
	/*empty*/
	| DISCARD_SYM OLD_SYM PASSWORD
	;

opt_user_registration :
	factor INITIATE_SYM REGISTRATION_SYM
	| factor UNREGISTER_SYM
	| factor FINISH_SYM REGISTRATION_SYM SET_SYM CHALLENGE_RESPONSE_SYM AS TEXT_STRING_hash
	;

create_user :
	user identification opt_create_user_with_mfa
	| user identified_with_plugin opt_initial_auth
	| user opt_create_user_with_mfa
	;

opt_create_user_with_mfa :
	/*empty*/
	| AND_SYM /*12L*/ identification
	| AND_SYM /*12L*/ identification AND_SYM /*12L*/ identification
	;

identification :
	identified_by_password
	| identified_by_random_password
	| identified_with_plugin
	| identified_with_plugin_as_auth
	| identified_with_plugin_by_password
	| identified_with_plugin_by_random_password
	;

identified_by_password :
	IDENTIFIED_SYM BY TEXT_STRING_password
	;

identified_by_random_password :
	IDENTIFIED_SYM BY RANDOM_SYM PASSWORD
	;

identified_with_plugin :
	IDENTIFIED_SYM WITH ident_or_text
	;

identified_with_plugin_as_auth :
	IDENTIFIED_SYM WITH ident_or_text AS TEXT_STRING_hash
	;

identified_with_plugin_by_password :
	IDENTIFIED_SYM WITH ident_or_text BY TEXT_STRING_password
	;

identified_with_plugin_by_random_password :
	IDENTIFIED_SYM WITH ident_or_text BY RANDOM_SYM PASSWORD
	;

opt_initial_auth :
	INITIAL_SYM AUTHENTICATION_SYM identified_by_random_password
	| INITIAL_SYM AUTHENTICATION_SYM identified_with_plugin_as_auth
	| INITIAL_SYM AUTHENTICATION_SYM identified_by_password
	;

alter_user :
	user identified_by_password REPLACE_SYM TEXT_STRING_password opt_retain_current_password
	| user identified_with_plugin_by_password REPLACE_SYM TEXT_STRING_password opt_retain_current_password
	| user identified_by_password opt_retain_current_password
	| user identified_by_random_password opt_retain_current_password
	| user identified_by_random_password REPLACE_SYM TEXT_STRING_password opt_retain_current_password
	| user identified_with_plugin
	| user identified_with_plugin_as_auth opt_retain_current_password
	| user identified_with_plugin_by_password opt_retain_current_password
	| user identified_with_plugin_by_random_password opt_retain_current_password
	| user opt_discard_old_password
	| user ADD factor identification
	| user ADD factor identification ADD factor identification
	| user MODIFY_SYM factor identification
	| user MODIFY_SYM factor identification MODIFY_SYM factor identification
	| user DROP factor
	| user DROP factor DROP factor
	;

factor :
	NUM FACTOR_SYM
	;

create_user_list :
	create_user
	| create_user_list ',' create_user
	;

alter_user_list :
	alter_user
	| alter_user_list ',' alter_user
	;

opt_column_list :
	/*empty*/
	| '(' /*27L*/ column_list ')' /*27L*/
	;

column_list :
	ident
	| column_list ',' ident
	;

require_clause :
	/*empty*/
	| REQUIRE_SYM require_list
	| REQUIRE_SYM SSL_SYM
	| REQUIRE_SYM X509_SYM
	| REQUIRE_SYM NONE_SYM
	;

grant_options :
	/*empty*/
	| WITH GRANT OPTION
	;

opt_grant_option :
	/*empty*/
	| WITH GRANT OPTION
	;

opt_with_roles :
	/*empty*/
	| WITH ROLE_SYM role_list
	| WITH ROLE_SYM ALL opt_except_role_list
	| WITH ROLE_SYM NONE_SYM
	| WITH ROLE_SYM DEFAULT_SYM
	;

opt_grant_as :
	/*empty*/
	| AS user opt_with_roles
	;

begin_stmt :
	BEGIN_SYM opt_work
	;

opt_work :
	/*empty*/
	| WORK_SYM
	;

opt_chain :
	/*empty*/
	| AND_SYM /*12L*/ NO_SYM CHAIN_SYM
	| AND_SYM /*12L*/ CHAIN_SYM
	;

opt_release :
	/*empty*/
	| RELEASE_SYM
	| NO_SYM RELEASE_SYM
	;

opt_savepoint :
	/*empty*/
	| SAVEPOINT_SYM
	;

commit :
	COMMIT_SYM opt_work opt_chain opt_release
	;

rollback :
	ROLLBACK_SYM opt_work opt_chain opt_release
	| ROLLBACK_SYM opt_work TO_SYM opt_savepoint ident
	;

savepoint :
	SAVEPOINT_SYM ident
	;

release :
	RELEASE_SYM SAVEPOINT_SYM ident
	;

union_option :
	/*empty*/
	| DISTINCT
	| ALL
	;

row_subquery :
	subquery
	;

table_subquery :
	subquery
	;

subquery :
	query_expression_parens %prec SUBQUERY_AS_EXPR /*26L*/
	;

query_spec_option :
	STRAIGHT_JOIN /*8L*/
	| HIGH_PRIORITY
	| DISTINCT
	| SQL_SMALL_RESULT
	| SQL_BIG_RESULT
	| SQL_BUFFER_RESULT
	| SQL_CALC_FOUND_ROWS
	| ALL
	;

init_lex_create_info :
	/*empty*/
	;

view_or_trigger_or_sp_or_event :
	definer init_lex_create_info definer_tail
	| no_definer init_lex_create_info no_definer_tail
	| view_replace_or_algorithm definer_opt init_lex_create_info view_tail
	;

definer_tail :
	view_tail
	| trigger_tail
	| sp_tail
	| sf_tail
	| event_tail
	;

no_definer_tail :
	view_tail
	| trigger_tail
	| sp_tail
	| sf_tail
	| udf_tail
	| event_tail
	;

definer_opt :
	no_definer
	| definer
	;

no_definer :
	/*empty*/
	;

definer :
	DEFINER_SYM EQ /*14L*/ user
	;

view_replace_or_algorithm :
	view_replace
	| view_replace view_algorithm
	| view_algorithm
	;

view_replace :
	OR_SYM /*10L*/ REPLACE_SYM
	;

view_algorithm :
	ALGORITHM_SYM EQ /*14L*/ UNDEFINED_SYM
	| ALGORITHM_SYM EQ /*14L*/ MERGE_SYM
	| ALGORITHM_SYM EQ /*14L*/ TEMPTABLE_SYM
	;

view_suid :
	/*empty*/
	| SQL_SYM SECURITY_SYM DEFINER_SYM
	| SQL_SYM SECURITY_SYM INVOKER_SYM
	;

view_tail :
	view_suid VIEW_SYM table_ident opt_derived_column_list AS view_query_block
	;

view_query_block :
	query_expression_with_opt_locking_clauses view_check_option
	;

view_check_option :
	/*empty*/
	| WITH CHECK_SYM OPTION
	| WITH CASCADED CHECK_SYM OPTION
	| WITH LOCAL_SYM CHECK_SYM OPTION
	;

trigger_action_order :
	FOLLOWS_SYM
	| PRECEDES_SYM
	;

trigger_follows_precedes_clause :
	/*empty*/
	| trigger_action_order ident_or_text
	;

trigger_tail :
	TRIGGER_SYM opt_if_not_exists sp_name trg_action_time trg_event ON_SYM /*8L*/ table_ident FOR_SYM EACH_SYM ROW_SYM trigger_follows_precedes_clause sp_proc_stmt
	;

udf_tail :
	AGGREGATE_SYM FUNCTION_SYM opt_if_not_exists ident RETURNS_SYM udf_type SONAME_SYM TEXT_STRING_sys
	| FUNCTION_SYM opt_if_not_exists ident RETURNS_SYM udf_type SONAME_SYM TEXT_STRING_sys
	;

sf_tail :
	FUNCTION_SYM opt_if_not_exists sp_name '(' /*27L*/ sp_fdparam_list ')' /*27L*/ RETURNS_SYM type opt_collate sp_c_chistics stored_routine_body
	;

routine_string :
	TEXT_STRING_literal
	| DOLLAR_QUOTED_STRING_SYM
	;

stored_routine_body :
	AS routine_string
	| sp_proc_stmt
	;

sp_tail :
	PROCEDURE_SYM opt_if_not_exists sp_name '(' /*27L*/ sp_pdparam_list ')' /*27L*/ sp_c_chistics stored_routine_body
	;

xa :
	XA_SYM begin_or_start xid opt_join_or_resume
	| XA_SYM END xid opt_suspend
	| XA_SYM PREPARE_SYM xid
	| XA_SYM COMMIT_SYM xid opt_one_phase
	| XA_SYM ROLLBACK_SYM xid
	| XA_SYM RECOVER_SYM opt_convert_xid
	;

opt_convert_xid :
	/*empty*/
	| CONVERT_SYM XID_SYM
	;

xid :
	text_string
	| text_string ',' text_string
	| text_string ',' text_string ',' ulong_num
	;

begin_or_start :
	BEGIN_SYM
	| START_SYM
	;

opt_join_or_resume :
	/*empty*/
	| JOIN_SYM /*8L*/
	| RESUME_SYM
	;

opt_one_phase :
	/*empty*/
	| ONE_SYM PHASE_SYM
	;

opt_suspend :
	/*empty*/
	| SUSPEND_SYM
	| SUSPEND_SYM FOR_SYM MIGRATE_SYM
	;

install_option_type :
	/*empty*/
	| GLOBAL_SYM
	| PERSIST_SYM
	;

install_set_rvalue :
	expr
	| ON_SYM /*8L*/
	;

install_set_value :
	install_option_type lvalue_variable equal install_set_rvalue
	;

install_set_value_list :
	install_set_value
	| install_set_value_list ',' install_set_value
	;

opt_install_set_value_list :
	/*empty*/
	| SET_SYM install_set_value_list
	;

install_stmt :
	INSTALL_SYM PLUGIN_SYM ident SONAME_SYM TEXT_STRING_sys
	| INSTALL_SYM COMPONENT_SYM TEXT_STRING_sys_list opt_install_set_value_list
	;

uninstall :
	UNINSTALL_SYM PLUGIN_SYM ident
	| UNINSTALL_SYM COMPONENT_SYM TEXT_STRING_sys_list
	;

TEXT_STRING_sys_list :
	TEXT_STRING_sys
	| TEXT_STRING_sys_list ',' TEXT_STRING_sys
	;

import_stmt :
	IMPORT TABLE_SYM FROM TEXT_STRING_sys_list
	;

clone_stmt :
	CLONE_SYM LOCAL_SYM DATA_SYM DIRECTORY_SYM opt_equal TEXT_STRING_filesystem
	| CLONE_SYM INSTANCE_SYM FROM user ':' ulong_num IDENTIFIED_SYM BY TEXT_STRING_sys opt_datadir_ssl
	;

opt_datadir_ssl :
	opt_ssl
	| DATA_SYM DIRECTORY_SYM opt_equal TEXT_STRING_filesystem opt_ssl
	;

opt_ssl :
	/*empty*/
	| REQUIRE_SYM SSL_SYM
	| REQUIRE_SYM NO_SYM SSL_SYM
	;

resource_group_types :
	USER
	| SYSTEM_SYM
	;

opt_resource_group_vcpu_list :
	/*empty*/
	| VCPU_SYM opt_equal vcpu_range_spec_list
	;

vcpu_range_spec_list :
	vcpu_num_or_range
	| vcpu_range_spec_list opt_comma vcpu_num_or_range
	;

vcpu_num_or_range :
	NUM
	| NUM '-' /*18L*/ NUM
	;

signed_num :
	NUM
	| '-' /*18L*/ NUM
	;

opt_resource_group_priority :
	/*empty*/
	| THREAD_PRIORITY_SYM opt_equal signed_num
	;

opt_resource_group_enable_disable :
	/*empty*/
	| ENABLE_SYM
	| DISABLE_SYM
	;

opt_force :
	/*empty*/
	| FORCE_SYM
	;

json_attribute :
	TEXT_STRING_sys
	;

%%

spaces	[ \t\r\n]+
line_comment	--[^\r\n]*
block_comment	\/\*(?s:.)*?\*\/

base_id	[_a-zA-Z][a-zA-Z0-9_]*

%%

{spaces}	skip()
{line_comment}	skip()
{block_comment}	skip()

"|"	'|'
"&"	'&'
"-"	'-'
"+"	'+'
"*"	'*'
"/"	'/'
"%"	'%'
"^"	'^'
"~"	'~'
"("	'('
")"	')'
";"	';'
"@"	'@'
","	','
"."	'.'
":"	':'
"!"	'!'
"{"	'{'
"}"	'}'


/*
Insert new SQL keywords after that commentary (by alphabetical order):
*/
"&&"	AND_AND_SYM
"<"	LT
"<="	LE
"<>"	NE
"!="	NE
"="	EQ
">"	GT_SYM
">="	GE
"<<"	SHIFT_LEFT
">>"	SHIFT_RIGHT
"<=>"	EQUAL_SYM
//"ACCESSIBLE"	ACCESSIBLE_SYM
"ACCOUNT"	ACCOUNT_SYM
"ACTION"	ACTION
"ACTIVE"	ACTIVE_SYM
"ADD"	ADD
"ADMIN"	ADMIN_SYM
"AFTER"	AFTER_SYM
"AGAINST"	AGAINST
"AGGREGATE"	AGGREGATE_SYM
"ALL"	ALL
"ALGORITHM"	ALGORITHM_SYM
"ALTER"	ALTER
"ALWAYS"	ALWAYS_SYM
"ANALYZE"	ANALYZE_SYM
"AND"	AND_SYM
"ANY"	ANY_SYM
"ARRAY"	ARRAY_SYM
"AS"	AS
"ASC"	ASC
"ASCII"	ASCII_SYM
//"ASENSITIVE"	ASENSITIVE_SYM
"AT"	AT_SYM
"ATTRIBUTE"	ATTRIBUTE_SYM
"AUTHENTICATION"	AUTHENTICATION_SYM
"AUTO_INCREMENT"	AUTO_INC
"AUTOEXTEND_SIZE"	AUTOEXTEND_SIZE_SYM
"AVG"	AVG_SYM
"AVG_ROW_LENGTH"	AVG_ROW_LENGTH
"BACKUP"	BACKUP_SYM
"BEFORE"	BEFORE_SYM
"BEGIN"	BEGIN_SYM
"BETWEEN"	BETWEEN_SYM
"BIGINT"	BIGINT_SYM
"BINARY"	BINARY_SYM
"BINLOG"	BINLOG_SYM
"BIT"	BIT_SYM
"BLOB"	BLOB_SYM
"BLOCK"	BLOCK_SYM
"BOOL"	BOOL_SYM
"BOOLEAN"	BOOLEAN_SYM
"BOTH"	BOTH
"BTREE"	BTREE_SYM
"BUCKETS"	BUCKETS_SYM
"BULK"	BULK_SYM
"BY"	BY
"BYTE"	BYTE_SYM
"CACHE"	CACHE_SYM
"CALL"	CALL_SYM
"CASCADE"	CASCADE
"CASCADED"	CASCADED
"CASE"	CASE_SYM
"CATALOG_NAME"	CATALOG_NAME_SYM
"CHAIN"	CHAIN_SYM
"CHALLENGE_RESPONSE"	CHALLENGE_RESPONSE_SYM
"CHANGE"	CHANGE
"CHANGED"	CHANGED
"CHANNEL"	CHANNEL_SYM
"CHAR"	CHAR_SYM
"CHARACTER"	CHAR_SYM
"CHARSET"	CHARSET
"CHECK"	CHECK_SYM
"CHECKSUM"	CHECKSUM_SYM
"CIPHER"	CIPHER_SYM
"CLASS_ORIGIN"	CLASS_ORIGIN_SYM
"CLIENT"	CLIENT_SYM
"CLONE"	CLONE_SYM
"CLOSE"	CLOSE_SYM
"COALESCE"	COALESCE
"CODE"	CODE_SYM
"COLLATE"	COLLATE_SYM
"COLLATION"	COLLATION_SYM
"COLUMN"	COLUMN_SYM
"COLUMN_FORMAT"	COLUMN_FORMAT_SYM
"COLUMN_NAME"	COLUMN_NAME_SYM
"COLUMNS"	COLUMNS
"COMMENT"	COMMENT_SYM
"COMMIT"	COMMIT_SYM
"COMMITTED"	COMMITTED_SYM
"COMPACT"	COMPACT_SYM
"COMPLETION"	COMPLETION_SYM
"COMPONENT"	COMPONENT_SYM
"COMPRESSION"	COMPRESSION_SYM
"COMPRESSED"	COMPRESSED_SYM
"ENCRYPTION"	ENCRYPTION_SYM
"CONCURRENT"	CONCURRENT
"CONDITION"	CONDITION_SYM
"CONNECTION"	CONNECTION_SYM
"CONSISTENT"	CONSISTENT_SYM
"CONSTRAINT"	CONSTRAINT
"CONSTRAINT_CATALOG"	CONSTRAINT_CATALOG_SYM
"CONSTRAINT_NAME"	CONSTRAINT_NAME_SYM
"CONSTRAINT_SCHEMA"	CONSTRAINT_SCHEMA_SYM
"CONTAINS"	CONTAINS_SYM
"CONTEXT"	CONTEXT_SYM
"CONTINUE"	CONTINUE_SYM
"CONVERT"	CONVERT_SYM
"CPU"	CPU_SYM
"CREATE"	CREATE
"CROSS"	CROSS
//"CUBE"	CUBE_SYM
"CUME_DIST"	CUME_DIST_SYM
"CURRENT"	CURRENT_SYM
"CURRENT_DATE"	CURDATE
"CURRENT_TIME"	CURTIME
"CURRENT_TIMESTAMP"	NOW_SYM
"CURRENT_USER"	CURRENT_USER
"CURSOR"	CURSOR_SYM
"CURSOR_NAME"	CURSOR_NAME_SYM
"DATA"	DATA_SYM
"DATABASE"	DATABASE
"DATABASES"	DATABASES
"DATAFILE"	DATAFILE_SYM
"DATE"	DATE_SYM
"DATETIME"	DATETIME_SYM
"DAY"	DAY_SYM
"DAY_HOUR"	DAY_HOUR_SYM
"DAY_MICROSECOND"	DAY_MICROSECOND_SYM
"DAY_MINUTE"	DAY_MINUTE_SYM
"DAY_SECOND"	DAY_SECOND_SYM
"DEALLOCATE"	DEALLOCATE_SYM
"DEC"	DECIMAL_SYM
"DECIMAL"	DECIMAL_SYM
"DECLARE"	DECLARE_SYM
"DEFAULT"	DEFAULT_SYM
"DEFAULT_AUTH"	DEFAULT_AUTH_SYM
"DEFINER"	DEFINER_SYM
"DEFINITION"	DEFINITION_SYM
"DELAYED"	DELAYED_SYM
"DELAY_KEY_WRITE"	DELAY_KEY_WRITE_SYM
"DENSE_RANK"	DENSE_RANK_SYM
"DESC"	DESC
"DESCRIBE"	DESCRIBE
"DESCRIPTION"	DESCRIPTION_SYM
"DETERMINISTIC"	DETERMINISTIC_SYM
"DIAGNOSTICS"	DIAGNOSTICS_SYM
"DIRECTORY"	DIRECTORY_SYM
"DISABLE"	DISABLE_SYM
"DISCARD"	DISCARD_SYM
"DISK"	DISK_SYM
"DISTINCT"	DISTINCT
"DISTINCTROW"	DISTINCT /* Access likes this */
"DIV"	DIV_SYM
"DO"	DO_SYM
"DOUBLE"	DOUBLE_SYM
"DROP"	DROP
"DUAL"	DUAL_SYM
"DUMPFILE"	DUMPFILE
"DUPLICATE"	DUPLICATE_SYM
"DYNAMIC"	DYNAMIC_SYM
"EACH"	EACH_SYM
"ELSE"	ELSE
"ELSEIF"	ELSEIF_SYM
"EMPTY"	EMPTY_SYM
"ENABLE"	ENABLE_SYM
"ENCLOSED"	ENCLOSED
"END"	END
"ENDS"	ENDS_SYM
"ENFORCED"	ENFORCED_SYM
"ENGINE"	ENGINE_SYM
"ENGINE_ATTRIBUTE"	ENGINE_ATTRIBUTE_SYM
"ENGINES"	ENGINES_SYM
"ENUM"	ENUM_SYM
"ERROR"	ERROR_SYM
"ERRORS"	ERRORS
"ESCAPE"	ESCAPE_SYM
"ESCAPED"	ESCAPED
"EVENT"	EVENT_SYM
"EVENTS"	EVENTS_SYM
"EVERY"	EVERY_SYM
"EXCEPT"	EXCEPT_SYM
"EXCHANGE"	EXCHANGE_SYM
"EXCLUDE"	EXCLUDE_SYM
"EXECUTE"	EXECUTE_SYM
"EXISTS"	EXISTS
"EXIT"	EXIT_SYM
"EXPANSION"	EXPANSION_SYM
"EXPORT"	EXPORT_SYM
"EXPIRE"	EXPIRE_SYM
"EXPLAIN"	DESCRIBE
"EXTENDED"	EXTENDED_SYM
"EXTENT_SIZE"	EXTENT_SIZE_SYM
"FACTOR"	FACTOR_SYM
"FAILED_LOGIN_ATTEMPTS"	FAILED_LOGIN_ATTEMPTS_SYM
"FALSE"	FALSE_SYM
"FAST"	FAST_SYM
"FAULTS"	FAULTS_SYM
"FETCH"	FETCH_SYM
"FIELDS"	COLUMNS
"FILE"	FILE_SYM
"FILE_BLOCK_SIZE"	FILE_BLOCK_SIZE_SYM
"FILTER"	FILTER_SYM
"FINISH"	FINISH_SYM
"FIRST"	FIRST_SYM
"FIRST_VALUE"	FIRST_VALUE_SYM
"FIXED"	FIXED_SYM
"FLOAT"	FLOAT_SYM
"FLOAT4"	FLOAT_SYM
"FLOAT8"	DOUBLE_SYM
"FLUSH"	FLUSH_SYM
"FOLLOWS"	FOLLOWS_SYM
"FOLLOWING"	FOLLOWING_SYM
"FOR"	FOR_SYM
"FORCE"	FORCE_SYM
"FOREIGN"	FOREIGN
"FORMAT"	FORMAT_SYM
"FOUND"	FOUND_SYM
"FROM"	FROM
"FULL"	FULL
"FULLTEXT"	FULLTEXT_SYM
"FUNCTION"	FUNCTION_SYM
"GENERAL"	GENERAL
"GROUP_REPLICATION"	GROUP_REPLICATION
"GEOMCOLLECTION"	GEOMETRYCOLLECTION_SYM
"GEOMETRY"	GEOMETRY_SYM
"GEOMETRYCOLLECTION"	GEOMETRYCOLLECTION_SYM
"GET_FORMAT"	GET_FORMAT
"GET_MASTER_PUBLIC_KEY"	GET_MASTER_PUBLIC_KEY_SYM
"GET_SOURCE_PUBLIC_KEY"	GET_SOURCE_PUBLIC_KEY_SYM
"GET"	GET_SYM
"GENERATE"	GENERATE_SYM
"GENERATED"	GENERATED
"GLOBAL"	GLOBAL_SYM
"GRANT"	GRANT
"GRANTS"	GRANTS
"GROUP"	GROUP_SYM
"GROUPING"	GROUPING_SYM
"GROUPS"	GROUPS_SYM
"GTID_ONLY"	GTID_ONLY_SYM
"HANDLER"	HANDLER_SYM
"HASH"	HASH_SYM
"HAVING"	HAVING
"HELP"	HELP_SYM
"HIGH_PRIORITY"	HIGH_PRIORITY
"HISTOGRAM"	HISTOGRAM_SYM
"HISTORY"	HISTORY_SYM
"HOST"	HOST_SYM
"HOSTS"	HOSTS_SYM
"HOUR"	HOUR_SYM
"HOUR_MICROSECOND"	HOUR_MICROSECOND_SYM
"HOUR_MINUTE"	HOUR_MINUTE_SYM
"HOUR_SECOND"	HOUR_SECOND_SYM
"IDENTIFIED"	IDENTIFIED_SYM
"IF"	IF
"IGNORE"	IGNORE_SYM
"IGNORE_SERVER_IDS"	IGNORE_SERVER_IDS_SYM
"IMPORT"	IMPORT
"IN"	IN_SYM
"INACTIVE"	INACTIVE_SYM
"INDEX"	INDEX_SYM
"INDEXES"	INDEXES
"INFILE"	INFILE_SYM
"INITIAL"	INITIAL_SYM
"INITIAL_SIZE"	INITIAL_SIZE_SYM
"INITIATE"	INITIATE_SYM
"INNER"	INNER_SYM
"INOUT"	INOUT_SYM
//"INSENSITIVE"	INSENSITIVE_SYM
"INSERT_METHOD"	INSERT_METHOD
"INSTALL"	INSTALL_SYM
"INSTANCE"	INSTANCE_SYM
"INT"	INT_SYM
"INT1"	TINYINT_SYM
"INT2"	SMALLINT_SYM
"INT3"	MEDIUMINT_SYM
"INT4"	INT_SYM
"INT8"	BIGINT_SYM
"INTEGER"	INT_SYM
"INTERSECT"	INTERSECT_SYM
"INTERVAL"	INTERVAL_SYM
"INTO"	INTO
"IO"	IO_SYM
//"IO_AFTER_GTIDS"	IO_AFTER_GTIDS
//"IO_BEFORE_GTIDS"	IO_BEFORE_GTIDS
"IO_THREAD"	RELAY_THREAD
"IPC"	IPC_SYM
"IS"	IS
"ISOLATION"	ISOLATION
"ISSUER"	ISSUER_SYM
"ITERATE"	ITERATE_SYM
"INVISIBLE"	INVISIBLE_SYM
"INVOKER"	INVOKER_SYM
"JOIN"	JOIN_SYM
"JSON"	JSON_SYM
"JSON_TABLE"	JSON_TABLE_SYM
"JSON_VALUE"	JSON_VALUE_SYM
"KEY"	KEY_SYM
"KEYRING"	KEYRING_SYM
"KEYS"	KEYS
"KEY_BLOCK_SIZE"	KEY_BLOCK_SIZE
"KILL"	KILL_SYM
"LAG"	LAG_SYM
"LANGUAGE"	LANGUAGE_SYM
"LAST"	LAST_SYM
"LAST_VALUE"	LAST_VALUE_SYM
"LATERAL"	LATERAL_SYM
"LEAD"	LEAD_SYM
"LEADING"	LEADING
"LEAVE"	LEAVE_SYM
"LEAVES"	LEAVES
"LEFT"	LEFT
"LESS"	LESS_SYM
"LEVEL"	LEVEL_SYM
"LIKE"	LIKE
"LIMIT"	LIMIT
"LINEAR"	LINEAR_SYM
"LINES"	LINES
"LINESTRING"	LINESTRING_SYM
"LIST"	LIST_SYM
"LOAD"	LOAD
"LOCAL"	LOCAL_SYM
"LOCALTIME"	NOW_SYM
"LOCALTIMESTAMP"	NOW_SYM
"LOCK"	LOCK_SYM
"LOCKED"	LOCKED_SYM
"LOCKS"	LOCKS_SYM
"LOGFILE"	LOGFILE_SYM
"LOGS"	LOGS_SYM
"LONG"	LONG_SYM
"LONGBLOB"	LONGBLOB_SYM
"LONGTEXT"	LONGTEXT_SYM
"LOOP"	LOOP_SYM
"LOW_PRIORITY"	LOW_PRIORITY
"MASTER"	MASTER_SYM
"MASTER_AUTO_POSITION"	MASTER_AUTO_POSITION_SYM
"MASTER_BIND"	MASTER_BIND_SYM
"MASTER_CONNECT_RETRY"	MASTER_CONNECT_RETRY_SYM
"MASTER_COMPRESSION_ALGORITHMS"	MASTER_COMPRESSION_ALGORITHM_SYM
"MASTER_DELAY"	MASTER_DELAY_SYM
"MASTER_HEARTBEAT_PERIOD"	MASTER_HEARTBEAT_PERIOD_SYM
"MASTER_HOST"	MASTER_HOST_SYM
"MASTER_LOG_FILE"	MASTER_LOG_FILE_SYM
"MASTER_LOG_POS"	MASTER_LOG_POS_SYM
"MASTER_PASSWORD"	MASTER_PASSWORD_SYM
"MASTER_PORT"	MASTER_PORT_SYM
"MASTER_PUBLIC_KEY_PATH"	MASTER_PUBLIC_KEY_PATH_SYM
"MASTER_RETRY_COUNT"	MASTER_RETRY_COUNT_SYM
"MASTER_SSL"	MASTER_SSL_SYM
"MASTER_SSL_CA"	MASTER_SSL_CA_SYM
"MASTER_SSL_CAPATH"	MASTER_SSL_CAPATH_SYM
"MASTER_SSL_CERT"	MASTER_SSL_CERT_SYM
"MASTER_SSL_CIPHER"	MASTER_SSL_CIPHER_SYM
"MASTER_SSL_CRL"	MASTER_SSL_CRL_SYM
"MASTER_SSL_CRLPATH"	MASTER_SSL_CRLPATH_SYM
"MASTER_SSL_KEY"	MASTER_SSL_KEY_SYM
"MASTER_SSL_VERIFY_SERVER_CERT"	MASTER_SSL_VERIFY_SERVER_CERT_SYM
"MASTER_TLS_CIPHERSUITES"	MASTER_TLS_CIPHERSUITES_SYM
"MASTER_TLS_VERSION"	MASTER_TLS_VERSION_SYM
"MASTER_USER"	MASTER_USER_SYM
"MASTER_ZSTD_COMPRESSION_LEVEL"	MASTER_ZSTD_COMPRESSION_LEVEL_SYM
"MATCH"	MATCH
"MAX_CONNECTIONS_PER_HOUR"	MAX_CONNECTIONS_PER_HOUR
"MAX_QUERIES_PER_HOUR"	MAX_QUERIES_PER_HOUR
"MAX_ROWS"	MAX_ROWS
"MAX_SIZE"	MAX_SIZE_SYM
"MAX_UPDATES_PER_HOUR"	MAX_UPDATES_PER_HOUR
"MAX_USER_CONNECTIONS"	MAX_USER_CONNECTIONS_SYM
"MAXVALUE"	MAX_VALUE_SYM
"MEDIUM"	MEDIUM_SYM
"MEDIUMBLOB"	MEDIUMBLOB_SYM
"MEDIUMINT"	MEDIUMINT_SYM
"MEDIUMTEXT"	MEDIUMTEXT_SYM
"MEMBER"	MEMBER_SYM
"MEMORY"	MEMORY_SYM
"MERGE"	MERGE_SYM
"MESSAGE_TEXT"	MESSAGE_TEXT_SYM
"MICROSECOND"	MICROSECOND_SYM
"MIDDLEINT"	MEDIUMINT_SYM /* For powerbuilder */
"MIGRATE"	MIGRATE_SYM
"MINUTE"	MINUTE_SYM
"MINUTE_MICROSECOND"	MINUTE_MICROSECOND_SYM
"MINUTE_SECOND"	MINUTE_SECOND_SYM
"MIN_ROWS"	MIN_ROWS
"MOD"	MOD_SYM
"MODE"	MODE_SYM
"MODIFIES"	MODIFIES_SYM
"MODIFY"	MODIFY_SYM
"MONTH"	MONTH_SYM
"MULTILINESTRING"	MULTILINESTRING_SYM
"MULTIPOINT"	MULTIPOINT_SYM
"MULTIPOLYGON"	MULTIPOLYGON_SYM
"MUTEX"	MUTEX_SYM
"MYSQL_ERRNO"	MYSQL_ERRNO_SYM
"NAME"	NAME_SYM
"NAMES"	NAMES_SYM
"NATIONAL"	NATIONAL_SYM
"NATURAL"	NATURAL
"NDB"	NDBCLUSTER_SYM
"NDBCLUSTER"	NDBCLUSTER_SYM
"NCHAR"	NCHAR_SYM
"NESTED"	NESTED_SYM
"NETWORK_NAMESPACE"	NETWORK_NAMESPACE_SYM
"NEVER"	NEVER_SYM
"NEW"	NEW_SYM
"NEXT"	NEXT_SYM
"NO"	NO_SYM
"NO_WAIT"	NO_WAIT_SYM
"NOWAIT"	NOWAIT_SYM
"NODEGROUP"	NODEGROUP_SYM
"NONE"	NONE_SYM
"NOT"	NOT_SYM
"NO_WRITE_TO_BINLOG"	NO_WRITE_TO_BINLOG
"NTH_VALUE"	NTH_VALUE_SYM
"NTILE"	NTILE_SYM
"NULL"	NULL_SYM
"NULLS"	NULLS_SYM
"NUMBER"	NUMBER_SYM
"NUMERIC"	NUMERIC_SYM
"NVARCHAR"	NVARCHAR_SYM
"OF"	OF_SYM
"OFF"	OFF_SYM
"OFFSET"	OFFSET_SYM
"OJ"	OJ_SYM
"OLD"	OLD_SYM
"ON"	ON_SYM
"ONE"	ONE_SYM
"ONLY"	ONLY_SYM
"OPEN"	OPEN_SYM
"OPTIMIZE"	OPTIMIZE
"OPTIMIZER_COSTS"	OPTIMIZER_COSTS_SYM
"OPTIONS"	OPTIONS_SYM
"OPTION"	OPTION
"OPTIONAL"	OPTIONAL_SYM
"OPTIONALLY"	OPTIONALLY
"OR"	OR_SYM
"ORGANIZATION"	ORGANIZATION_SYM
"OTHERS"	OTHERS_SYM
"ORDER"	ORDER_SYM
"ORDINALITY"	ORDINALITY_SYM
"OUT"	OUT_SYM
"OUTER"	OUTER_SYM
"OUTFILE"	OUTFILE
"OVER"	OVER_SYM
"OWNER"	OWNER_SYM
"PACK_KEYS"	PACK_KEYS_SYM
"PATH"	PATH_SYM
"PARSE_TREE"	PARSE_TREE_SYM
"PARSER"	PARSER_SYM
"PAGE"	PAGE_SYM
"PARTIAL"	PARTIAL
"PARTITION"	PARTITION_SYM
"PARTITIONING"	PARTITIONING_SYM
"PARTITIONS"	PARTITIONS_SYM
"PASSWORD"	PASSWORD
"PASSWORD_LOCK_TIME"	PASSWORD_LOCK_TIME_SYM
"PERCENT_RANK"	PERCENT_RANK_SYM
"PERSIST"	PERSIST_SYM
"PERSIST_ONLY"	PERSIST_ONLY_SYM
"PHASE"	PHASE_SYM
"PLUGIN"	PLUGIN_SYM
"PLUGINS"	PLUGINS_SYM
"PLUGIN_DIR"	PLUGIN_DIR_SYM
"POINT"	POINT_SYM
"POLYGON"	POLYGON_SYM
"PORT"	PORT_SYM
"PRECEDES"	PRECEDES_SYM
"PRECEDING"	PRECEDING_SYM
"PRECISION"	PRECISION
"PREPARE"	PREPARE_SYM
"PRESERVE"	PRESERVE_SYM
"PREV"	PREV_SYM
"PRIMARY"	PRIMARY_SYM
"PRIVILEGES"	PRIVILEGES
"PRIVILEGE_CHECKS_USER"	PRIVILEGE_CHECKS_USER_SYM
"PROCEDURE"	PROCEDURE_SYM
"PROCESS"	PROCESS
"PROCESSLIST"	PROCESSLIST_SYM
"PROFILE"	PROFILE_SYM
"PROFILES"	PROFILES_SYM
"PROXY"	PROXY_SYM
"PURGE"	PURGE
"QUARTER"	QUARTER_SYM
"QUERY"	QUERY_SYM
"QUICK"	QUICK
"RANDOM"	RANDOM_SYM
"RANK"	RANK_SYM
"RANGE"	RANGE_SYM
"READ"	READ_SYM
"READ_ONLY"	READ_ONLY_SYM
//"READ_WRITE"	READ_WRITE_SYM
"READS"	READS_SYM
"REAL"	REAL_SYM
"REBUILD"	REBUILD_SYM
"RECOVER"	RECOVER_SYM
"RECURSIVE"	RECURSIVE_SYM
"REDO_BUFFER_SIZE"	REDO_BUFFER_SIZE_SYM
"REDUNDANT"	REDUNDANT_SYM
"REFERENCE"	REFERENCE_SYM
"REFERENCES"	REFERENCES
"REGEXP"	REGEXP
"REGISTRATION"	REGISTRATION_SYM
"RELAY"	RELAY
"RELAYLOG"	RELAYLOG_SYM
"RELAY_LOG_FILE"	RELAY_LOG_FILE_SYM
"RELAY_LOG_POS"	RELAY_LOG_POS_SYM
"RELAY_THREAD"	RELAY_THREAD
"RELEASE"	RELEASE_SYM
"RELOAD"	RELOAD
"REMOVE"	REMOVE_SYM
"RENAME"	RENAME
"ASSIGN_GTIDS_TO_ANONYMOUS_TRANSACTIONS"	ASSIGN_GTIDS_TO_ANONYMOUS_TRANSACTIONS_SYM
"REORGANIZE"	REORGANIZE_SYM
"REPAIR"	REPAIR
"REPEATABLE"	REPEATABLE_SYM
"REPLICA"	REPLICA_SYM
"REPLICAS"	REPLICAS_SYM
"REPLICATION"	REPLICATION
"REPLICATE_DO_DB"	REPLICATE_DO_DB
"REPLICATE_IGNORE_DB"	REPLICATE_IGNORE_DB
"REPLICATE_DO_TABLE"	REPLICATE_DO_TABLE
"REPLICATE_IGNORE_TABLE"	REPLICATE_IGNORE_TABLE
"REPLICATE_WILD_DO_TABLE"	REPLICATE_WILD_DO_TABLE
"REPLICATE_WILD_IGNORE_TABLE"	REPLICATE_WILD_IGNORE_TABLE
"REPLICATE_REWRITE_DB"	REPLICATE_REWRITE_DB
"REPEAT"	REPEAT_SYM
"REQUIRE"	REQUIRE_SYM
"REQUIRE_ROW_FORMAT"	REQUIRE_ROW_FORMAT_SYM
"REQUIRE_TABLE_PRIMARY_KEY_CHECK"	REQUIRE_TABLE_PRIMARY_KEY_CHECK_SYM
"RESET"	RESET_SYM
"RESPECT"	RESPECT_SYM
"RESIGNAL"	RESIGNAL_SYM
"RESOURCE"	RESOURCE_SYM
"RESTART"	RESTART_SYM
"RESTORE"	RESTORE_SYM
"RESTRICT"	RESTRICT
"RESUME"	RESUME_SYM
"RETAIN"	RETAIN_SYM
"RETURNED_SQLSTATE"	RETURNED_SQLSTATE_SYM
"RETURN"	RETURN_SYM
"RETURNING"	RETURNING_SYM
"RETURNS"	RETURNS_SYM
"REUSE"	REUSE_SYM
"REVERSE"	REVERSE_SYM
"REVOKE"	REVOKE
"RIGHT"	RIGHT
"RLIKE"	REGEXP /* Like in mSQL2 */
"ROLE"	ROLE_SYM
"ROLLBACK"	ROLLBACK_SYM
"ROLLUP"	ROLLUP_SYM
"ROUTINE"	ROUTINE_SYM
"ROTATE"	ROTATE_SYM
"ROW"	ROW_SYM
"ROW_COUNT"	ROW_COUNT_SYM
"ROW_NUMBER"	ROW_NUMBER_SYM
"ROWS"	ROWS_SYM
"ROW_FORMAT"	ROW_FORMAT_SYM
"RTREE"	RTREE_SYM
"SAVEPOINT"	SAVEPOINT_SYM
"SCHEDULE"	SCHEDULE_SYM
"SCHEMA"	DATABASE
"SCHEMA_NAME"	SCHEMA_NAME_SYM
"SCHEMAS"	DATABASES
"SECOND"	SECOND_SYM
"SECOND_MICROSECOND"	SECOND_MICROSECOND_SYM
"SECONDARY"	SECONDARY_SYM
"SECONDARY_ENGINE"	SECONDARY_ENGINE_SYM
"SECONDARY_ENGINE_ATTRIBUTE"	SECONDARY_ENGINE_ATTRIBUTE_SYM
"SECONDARY_LOAD"	SECONDARY_LOAD_SYM
"SECONDARY_UNLOAD"	SECONDARY_UNLOAD_SYM
"SECURITY"	SECURITY_SYM
//"SENSITIVE"	SENSITIVE_SYM
"SEPARATOR"	SEPARATOR_SYM
"SERIAL"	SERIAL_SYM
"SERIALIZABLE"	SERIALIZABLE_SYM
"SESSION"	SESSION_SYM
"SERVER"	SERVER_SYM
"SET"	SET_SYM
"SHARE"	SHARE_SYM
"SHOW"	SHOW
"SHUTDOWN"	SHUTDOWN
"SIGNAL"	SIGNAL_SYM
"SIGNED"	SIGNED_SYM
"SIMPLE"	SIMPLE_SYM
"SKIP"	SKIP_SYM
"SLAVE"	SLAVE
"SLOW"	SLOW
"SNAPSHOT"	SNAPSHOT_SYM
"SMALLINT"	SMALLINT_SYM
"SOCKET"	SOCKET_SYM
"SOME"	ANY_SYM
"SONAME"	SONAME_SYM
"SOUNDS"	SOUNDS_SYM
"SOURCE"	SOURCE_SYM
"SOURCE_AUTO_POSITION"	SOURCE_AUTO_POSITION_SYM
"SOURCE_BIND"	SOURCE_BIND_SYM
"SOURCE_COMPRESSION_ALGORITHMS"	SOURCE_COMPRESSION_ALGORITHM_SYM
"SOURCE_CONNECT_RETRY"	SOURCE_CONNECT_RETRY_SYM
"SOURCE_CONNECTION_AUTO_FAILOVER"	SOURCE_CONNECTION_AUTO_FAILOVER_SYM
"SOURCE_DELAY"	SOURCE_DELAY_SYM
"SOURCE_HEARTBEAT_PERIOD"	SOURCE_HEARTBEAT_PERIOD_SYM
"SOURCE_HOST"	SOURCE_HOST_SYM
"SOURCE_LOG_FILE"	SOURCE_LOG_FILE_SYM
"SOURCE_LOG_POS"	SOURCE_LOG_POS_SYM
"SOURCE_PASSWORD"	SOURCE_PASSWORD_SYM
"SOURCE_PORT"	SOURCE_PORT_SYM
"SOURCE_PUBLIC_KEY_PATH"	SOURCE_PUBLIC_KEY_PATH_SYM
"SOURCE_RETRY_COUNT"	SOURCE_RETRY_COUNT_SYM
"SOURCE_SSL_CAPATH"	SOURCE_SSL_CAPATH_SYM
"SOURCE_SSL_CA"	SOURCE_SSL_CA_SYM
"SOURCE_SSL_CERT"	SOURCE_SSL_CERT_SYM
"SOURCE_SSL_CIPHER"	SOURCE_SSL_CIPHER_SYM
"SOURCE_SSL_CRL"	SOURCE_SSL_CRL_SYM
"SOURCE_SSL_CRLPATH"	SOURCE_SSL_CRLPATH_SYM
"SOURCE_SSL_KEY"	SOURCE_SSL_KEY_SYM
"SOURCE_SSL"	SOURCE_SSL_SYM
"SOURCE_SSL_VERIFY_SERVER_CERT"	SOURCE_SSL_VERIFY_SERVER_CERT_SYM
"SOURCE_TLS_CIPHERSUITES"	SOURCE_TLS_CIPHERSUITES_SYM
"SOURCE_TLS_VERSION"	SOURCE_TLS_VERSION_SYM
"SOURCE_USER"	SOURCE_USER_SYM
"SOURCE_ZSTD_COMPRESSION_LEVEL"	SOURCE_ZSTD_COMPRESSION_LEVEL_SYM
"SPATIAL"	SPATIAL_SYM
//"SPECIFIC"	SPECIFIC_SYM
"SQL"	SQL_SYM
"SQLEXCEPTION"	SQLEXCEPTION_SYM
"SQLSTATE"	SQLSTATE_SYM
"SQLWARNING"	SQLWARNING_SYM
"SQL_AFTER_GTIDS"	SQL_AFTER_GTIDS
"SQL_AFTER_MTS_GAPS"	SQL_AFTER_MTS_GAPS
"SQL_BEFORE_GTIDS"	SQL_BEFORE_GTIDS
"SQL_BIG_RESULT"	SQL_BIG_RESULT
"SQL_BUFFER_RESULT"	SQL_BUFFER_RESULT
"SQL_CALC_FOUND_ROWS"	SQL_CALC_FOUND_ROWS
"SQL_NO_CACHE"	SQL_NO_CACHE_SYM
"SQL_SMALL_RESULT"	SQL_SMALL_RESULT
"SQL_THREAD"	SQL_THREAD
"SQL_TSI_SECOND"	SECOND_SYM
"SQL_TSI_MINUTE"	MINUTE_SYM
"SQL_TSI_HOUR"	HOUR_SYM
"SQL_TSI_DAY"	DAY_SYM
"SQL_TSI_WEEK"	WEEK_SYM
"SQL_TSI_MONTH"	MONTH_SYM
"SQL_TSI_QUARTER"	QUARTER_SYM
"SQL_TSI_YEAR"	YEAR_SYM
"SRID"	SRID_SYM
"SSL"	SSL_SYM
"STACKED"	STACKED_SYM
"START"	START_SYM
"STARTING"	STARTING
"STARTS"	STARTS_SYM
"STATS_AUTO_RECALC"	STATS_AUTO_RECALC_SYM
"STATS_PERSISTENT"	STATS_PERSISTENT_SYM
"STATS_SAMPLE_PAGES"	STATS_SAMPLE_PAGES_SYM
"STATUS"	STATUS_SYM
"STOP"	STOP_SYM
"STORAGE"	STORAGE_SYM
"STORED"	STORED_SYM
"STRAIGHT_JOIN"	STRAIGHT_JOIN
"STREAM"	STREAM_SYM
"STRING"	STRING_SYM
"SUBCLASS_ORIGIN"	SUBCLASS_ORIGIN_SYM
"SUBJECT"	SUBJECT_SYM
"SUBPARTITION"	SUBPARTITION_SYM
"SUBPARTITIONS"	SUBPARTITIONS_SYM
"SUPER"	SUPER_SYM
"SUSPEND"	SUSPEND_SYM
"SWAPS"	SWAPS_SYM
"SWITCHES"	SWITCHES_SYM
"SYSTEM"	SYSTEM_SYM
"TABLE"	TABLE_SYM
"TABLE_NAME"	TABLE_NAME_SYM
"TABLES"	TABLES
"TABLESPACE"	TABLESPACE_SYM
"TABLE_CHECKSUM"	TABLE_CHECKSUM_SYM
"TEMPORARY"	TEMPORARY
"TEMPTABLE"	TEMPTABLE_SYM
"TERMINATED"	TERMINATED
"TEXT"	TEXT_SYM
"THAN"	THAN_SYM
"THEN"	THEN_SYM
"THREAD_PRIORITY"	THREAD_PRIORITY_SYM
"TIES"	TIES_SYM
"TIME"	TIME_SYM
"TIMESTAMP"	TIMESTAMP_SYM
"TIMESTAMPADD"	TIMESTAMP_ADD
"TIMESTAMPDIFF"	TIMESTAMP_DIFF
"TINYBLOB"	TINYBLOB_SYM
"TINYINT"	TINYINT_SYM
"TINYTEXT"	TINYTEXT_SYN
"TLS"	TLS_SYM
"TO"	TO_SYM
"TRAILING"	TRAILING
"TRANSACTION"	TRANSACTION_SYM
"TRIGGER"	TRIGGER_SYM
"TRIGGERS"	TRIGGERS_SYM
"TRUE"	TRUE_SYM
"TRUNCATE"	TRUNCATE_SYM
"TYPE"	TYPE_SYM
"TYPES"	TYPES_SYM
"UNBOUNDED"	UNBOUNDED_SYM
"UNCOMMITTED"	UNCOMMITTED_SYM
"UNDEFINED"	UNDEFINED_SYM
"UNDO_BUFFER_SIZE"	UNDO_BUFFER_SIZE_SYM
"UNDOFILE"	UNDOFILE_SYM
"UNDO"	UNDO_SYM
"UNICODE"	UNICODE_SYM
"UNION"	UNION_SYM
"UNIQUE"	UNIQUE_SYM
"UNKNOWN"	UNKNOWN_SYM
"UNLOCK"	UNLOCK_SYM
"UNINSTALL"	UNINSTALL_SYM
"UNREGISTER"	UNREGISTER_SYM
"UNSIGNED"	UNSIGNED_SYM
"UNTIL"	UNTIL_SYM
"UPGRADE"	UPGRADE_SYM
"URL"	URL_SYM
"USAGE"	USAGE
"USE"	USE_SYM
"USER"	USER
"USER_RESOURCES"	RESOURCES
"USE_FRM"	USE_FRM
"USING"	USING
"UTC_DATE"	UTC_DATE_SYM
"UTC_TIME"	UTC_TIME_SYM
"UTC_TIMESTAMP"	UTC_TIMESTAMP_SYM
"VALIDATION"	VALIDATION_SYM
"VALUE"	VALUE_SYM
"VALUES"	VALUES
"VARBINARY"	VARBINARY_SYM
"VARCHAR"	VARCHAR_SYM
"VARCHARACTER"	VARCHAR_SYM
"VARIABLES"	VARIABLES
"VARYING"	VARYING
"WAIT"	WAIT_SYM
"WARNINGS"	WARNINGS
"WEEK"	WEEK_SYM
"WEIGHT_STRING"	WEIGHT_STRING_SYM
"WHEN"	WHEN_SYM
"WHERE"	WHERE
"WHILE"	WHILE_SYM
"WINDOW"	WINDOW_SYM
"VCPU"	VCPU_SYM
"VIEW"	VIEW_SYM
"VIRTUAL"	VIRTUAL_SYM
"VISIBLE"	VISIBLE_SYM
"WITH"	WITH
"WITHOUT"	WITHOUT_SYM
"WORK"	WORK_SYM
"WRAPPER"	WRAPPER_SYM
"WRITE"	WRITE_SYM
"X509"	X509_SYM
"XOR"	XOR
"XA"	XA_SYM
"XID"	XID_SYM
"XML"	XML_SYM /* LOAD XML Arnold/Erik */
"YEAR"	YEAR_SYM
"YEAR_MONTH"	YEAR_MONTH_SYM
"ZEROFILL"	ZEROFILL_SYM
"ZONE"	ZONE_SYM
"||"	OR_OR_SYM
/*
Place keywords that accept optimizer hints below this comment.
*/
"DELETE"	DELETE_SYM
"INSERT"	INSERT_SYM
"REPLACE"	REPLACE_SYM
"SELECT"	SELECT_SYM
"UPDATE"	UPDATE_SYM
/*
Insert new function definitions after that commentary (by alphabetical
order)
*/
"ADDDATE"	ADDDATE_SYM
"BIT_AND"	BIT_AND_SYM
"BIT_OR"	BIT_OR_SYM
"BIT_XOR"	BIT_XOR_SYM
"CAST"	CAST_SYM
"COUNT"	COUNT_SYM
"CURDATE"	CURDATE
"CURTIME"	CURTIME
"DATE_ADD"	DATE_ADD_INTERVAL
"DATE_SUB"	DATE_SUB_INTERVAL
"EXTRACT"	EXTRACT_SYM
"GROUP_CONCAT"	GROUP_CONCAT_SYM
"JSON_OBJECTAGG"	JSON_OBJECTAGG
"JSON_ARRAYAGG"	JSON_ARRAYAGG
"MAX"	MAX_SYM
"MID"	SUBSTRING /* unireg function */
"MIN"	MIN_SYM
"NOW"	NOW_SYM
"POSITION"	POSITION_SYM
"SESSION_USER"	USER
"STD"	STD_SYM
"STDDEV"	STD_SYM
"STDDEV_POP"	STD_SYM
"STDDEV_SAMP"	STDDEV_SAMP_SYM
"ST_COLLECT"	ST_COLLECT_SYM
"SUBDATE"	SUBDATE_SYM
"SUBSTR"	SUBSTRING
"SUBSTRING"	SUBSTRING
"SUM"	SUM_SYM
"SYSDATE"	SYSDATE
"SYSTEM_USER"	USER
"TRIM"	TRIM
"VARIANCE"	VARIANCE_SYM
"VAR_POP"	VARIANCE_SYM
"VAR_SAMP"	VAR_SAMP_SYM
/*
Insert new optimizer hint keywords after that commentary:
*/
/*
"BKA"	BKA_HINT
"BNL"	BNL_HINT
"DUPSWEEDOUT"	DUPSWEEDOUT_HINT
"FIRSTMATCH"	FIRSTMATCH_HINT
"INTOEXISTS"	INTOEXISTS_HINT
"LOOSESCAN"	LOOSESCAN_HINT
"MATERIALIZATION"	MATERIALIZATION_HINT
"MAX_EXECUTION_TIME"	MAX_EXECUTION_TIME_HINT
"NO_BKA"	NO_BKA_HINT
"NO_BNL"	NO_BNL_HINT
"NO_ICP"	NO_ICP_HINT
"NO_MRR"	NO_MRR_HINT
"NO_RANGE_OPTIMIZATION"	NO_RANGE_OPTIMIZATION_HINT
"NO_SEMIJOIN"	NO_SEMIJOIN_HINT
"MRR"	MRR_HINT
"QB_NAME"	QB_NAME_HINT
"SEMIJOIN"	SEMIJOIN_HINT
"SET_VAR"	SET_VAR_HINT
"SUBQUERY"	SUBQUERY_HINT
"MERGE"	DERIVED_MERGE_HINT
"NO_MERGE"	NO_DERIVED_MERGE_HINT
"JOIN_PREFIX"	JOIN_PREFIX_HINT
"JOIN_SUFFIX"	JOIN_SUFFIX_HINT
"JOIN_ORDER"	JOIN_ORDER_HINT
"JOIN_FIXED_ORDER"	JOIN_FIXED_ORDER_HINT
"INDEX_MERGE"	INDEX_MERGE_HINT
"NO_INDEX_MERGE"	NO_INDEX_MERGE_HINT
"RESOURCE_GROUP"	RESOURCE_GROUP_HINT
"SKIP_SCAN"	SKIP_SCAN_HINT
"NO_SKIP_SCAN"	NO_SKIP_SCAN_HINT
"HASH_JOIN"	HASH_JOIN_HINT
"NO_HASH_JOIN"	NO_HASH_JOIN_HINT
"INDEX"	INDEX_HINT
"NO_INDEX"	NO_INDEX_HINT
"JOIN_INDEX"	JOIN_INDEX_HINT
"NO_JOIN_INDEX"	NO_JOIN_INDEX_HINT
"GROUP_INDEX"	GROUP_INDEX_HINT
"NO_GROUP_INDEX"	NO_GROUP_INDEX_HINT
"ORDER_INDEX"	ORDER_INDEX_HINT
"NO_ORDER_INDEX"	NO_ORDER_INDEX_HINT
"DERIVED_CONDITION_PUSHDOWN"	DERIVED_CONDITION_PUSHDOWN_HINT
"NO_DERIVED_CONDITION_PUSHDOWN",   NO_DERIVED_CONDITION_PUSHDOWN_HINT
*/

BIN_NUM	BIN_NUM
CONDITIONLESS_JOIN	CONDITIONLESS_JOIN
DECIMAL_NUM	DECIMAL_NUM
DOLLAR_QUOTED_STRING_SYM	DOLLAR_QUOTED_STRING_SYM
//END_OF_INPUT	END_OF_INPUT
[0-9]+"."[0-9]+	FLOAT_NUM
GRAMMAR_SELECTOR_CTE	GRAMMAR_SELECTOR_CTE
GRAMMAR_SELECTOR_DERIVED_EXPR	GRAMMAR_SELECTOR_DERIVED_EXPR
GRAMMAR_SELECTOR_EXPR	GRAMMAR_SELECTOR_EXPR
GRAMMAR_SELECTOR_GCOL	GRAMMAR_SELECTOR_GCOL
GRAMMAR_SELECTOR_PART	GRAMMAR_SELECTOR_PART
HEX_NUM	HEX_NUM
JSON_SEPARATOR_SYM	JSON_SEPARATOR_SYM
JSON_UNQUOTED_SEPARATOR_SYM	JSON_UNQUOTED_SEPARATOR_SYM
KEYWORD_USED_AS_IDENT	KEYWORD_USED_AS_IDENT
KEYWORD_USED_AS_KEYWORD	KEYWORD_USED_AS_KEYWORD
LEX_HOSTNAME	LEX_HOSTNAME
LONG_NUM	LONG_NUM
NCHAR_STRING	NCHAR_STRING
NOT2_SYM	NOT2_SYM
[0-9]+	NUM
OR2_SYM	OR2_SYM
PARAM_MARKER	PARAM_MARKER
SET_VAR	SET_VAR
'(''|[^'\n])*'	TEXT_STRING
ULONGLONG_NUM	ULONGLONG_NUM
UNDERSCORE_CHARSET	UNDERSCORE_CHARSET
WITH_ROLLUP_SYM	WITH_ROLLUP_SYM

/* Order matter if identifier comes before keywords they are classified as identifier */
{base_id}	IDENT
[`]{base_id}[`]	IDENT_QUOTED

%%

