//From: https://github.com/matrixorigin/matrixone/blob/9ba26f754ace047e9d8ee02285517ebd43070962/pkg/sql/parsers/dialect/mysql/mysql_sql.y
// Copyright 2021 Matrix Origin
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

%option caseless

/*Tokens*/
%token EMPTY
%token UNION
%token EXCEPT
%token INTERSECT
%token MINUS
%token LOWER_THAN_ORDER
%token ORDER
%token SELECT
%token INSERT
%token UPDATE
%token DELETE
%token FROM
%token WHERE
%token GROUP
%token HAVING
%token BY
%token LIMIT
%token OFFSET
%token FOR
%token CONNECT
%token MANAGE
%token GRANTS
%token OWNERSHIP
%token REFERENCE
%token LOWER_THAN_SET
%token SET
%token ALL
%token DISTINCT
%token DISTINCTROW
%token AS
%token EXISTS
%token ASC
%token DESC
%token INTO
%token DUPLICATE
%token DEFAULT
%token LOCK
%token KEYS
%token NULLS
%token FIRST
%token LAST
%token AFTER
%token INSTANT
%token INPLACE
%token COPY
%token DISABLE
%token ENABLE
%token UNDEFINED
%token MERGE
%token TEMPTABLE
%token DEFINER
%token INVOKER
%token SQL
%token SECURITY
%token CASCADED
%token VALUES
//%token NEXT
//%token VALUE
%token SHARE
%token MODE
//%token SQL_NO_CACHE
//%token SQL_CACHE
%token JOIN
%token STRAIGHT_JOIN
%token LEFT
%token RIGHT
%token INNER
%token OUTER
%token CROSS
%token NATURAL
%token USE
%token FORCE
%token LOWER_THAN_ON
%token ON
%token USING
%token SUBQUERY_AS_EXPR
%token '('
%token ')'
%token LOWER_THAN_STRING
%token ID
%token AT_ID
%token AT_AT_ID
%token STRING
%token VALUE_ARG
//%token LIST_ARG
//%token COMMENT
%token COMMENT_KEYWORD
%token QUOTE_ID
%token STAGE
%token CREDENTIALS
%token STAGES
%token INTEGRAL
//%token HEX
%token BIT_LITERAL
%token FLOAT
%token HEXNUM
%token NULL
%token TRUE
%token FALSE
//%token LOWER_THAN_CHARSET
%token CHARSET
%token UNIQUE
%token KEY
%token OR
%token PIPE_CONCAT
%token XOR
%token AND
%token NOT
%token '!'
%token BETWEEN
%token CASE
%token WHEN
%token THEN
%token ELSE
%token END
%token ELSEIF
%token LOWER_THAN_EQ
%token '='
%token '<'
%token '>'
%token LE
%token GE
%token NE
%token NULL_SAFE_EQUAL
%token IS
%token LIKE
%token REGEXP
%token IN
%token ASSIGNMENT
%token ILIKE
%token '|'
%token '&'
%token SHIFT_LEFT
%token SHIFT_RIGHT
%token '+'
%token '-'
%token '*'
%token '/'
%token DIV
%token '%'
%token MOD
%token '^'
%token '~'
%token UNARY
%token COLLATE
%token BINARY
%token UNDERSCORE_BINARY
%token INTERVAL
%token '.'
%token ','
%token OUT
%token INOUT
%token BEGIN
%token START
%token TRANSACTION
%token COMMIT
%token ROLLBACK
%token WORK
%token CONSISTENT
%token SNAPSHOT
%token CHAIN
%token NO
%token RELEASE
//%token PRIORITY
%token QUICK
%token BIT
%token TINYINT
%token SMALLINT
%token MEDIUMINT
%token INT
%token INTEGER
%token BIGINT
//%token INTNUM
%token REAL
%token DOUBLE
%token FLOAT_TYPE
%token DECIMAL
%token NUMERIC
%token DECIMAL_VALUE
%token TIME
%token TIMESTAMP
%token DATETIME
%token YEAR
%token CHAR
%token VARCHAR
%token BOOL
%token CHARACTER
%token VARBINARY
%token NCHAR
%token TEXT
%token TINYTEXT
%token MEDIUMTEXT
%token LONGTEXT
%token BLOB
%token TINYBLOB
%token MEDIUMBLOB
%token LONGBLOB
%token JSON
%token ENUM
%token UUID
%token VECF32
%token VECF64
%token GEOMETRY
%token POINT
%token LINESTRING
%token POLYGON
%token GEOMETRYCOLLECTION
%token MULTIPOINT
%token MULTILINESTRING
%token MULTIPOLYGON
%token INT1
%token INT2
%token INT3
%token INT4
%token INT8
%token S3OPTION
%token SQL_SMALL_RESULT
%token SQL_BIG_RESULT
%token SQL_BUFFER_RESULT
%token LOW_PRIORITY
%token HIGH_PRIORITY
%token DELAYED
%token CREATE
%token ALTER
%token DROP
%token RENAME
%token ANALYZE
%token ADD
%token RETURNS
%token SCHEMA
%token TABLE
%token SEQUENCE
%token INDEX
%token VIEW
%token TO
%token IGNORE
%token IF
%token PRIMARY
%token COLUMN
%token CONSTRAINT
%token SPATIAL
%token FULLTEXT
%token FOREIGN
%token KEY_BLOCK_SIZE
%token SHOW
%token DESCRIBE
%token EXPLAIN
%token DATE
%token ESCAPE
%token REPAIR
%token OPTIMIZE
%token TRUNCATE
%token MAXVALUE
%token PARTITION
%token REORGANIZE
%token LESS
%token THAN
%token PROCEDURE
%token TRIGGER
%token STATUS
%token VARIABLES
%token ROLE
%token PROXY
%token AVG_ROW_LENGTH
%token STORAGE
%token DISK
%token MEMORY
%token CHECKSUM
%token COMPRESSION
%token DATA
%token DIRECTORY
%token DELAY_KEY_WRITE
%token ENCRYPTION
%token ENGINE
%token MAX_ROWS
%token MIN_ROWS
%token PACK_KEYS
%token ROW_FORMAT
%token STATS_AUTO_RECALC
%token STATS_PERSISTENT
%token STATS_SAMPLE_PAGES
%token DYNAMIC
%token COMPRESSED
%token REDUNDANT
%token COMPACT
%token FIXED
%token COLUMN_FORMAT
%token AUTO_RANDOM
%token ENGINE_ATTRIBUTE
%token SECONDARY_ENGINE_ATTRIBUTE
%token INSERT_METHOD
%token RESTRICT
%token CASCADE
%token ACTION
%token PARTIAL
%token SIMPLE
%token CHECK
%token ENFORCED
%token RANGE
%token LIST
%token ALGORITHM
%token LINEAR
%token PARTITIONS
%token SUBPARTITION
%token SUBPARTITIONS
%token CLUSTER
%token TYPE
%token ANY
%token SOME
%token EXTERNAL
//%token LOCALFILE
%token URL
%token PREPARE
%token DEALLOCATE
%token RESET
%token EXTENSION
%token INCREMENT
%token CYCLE
%token MINVALUE
%token PUBLICATION
%token SUBSCRIPTIONS
%token PUBLICATIONS
%token PROPERTIES
%token PARSER
%token VISIBLE
%token INVISIBLE
%token BTREE
%token HASH
%token RTREE
%token BSI
%token ZONEMAP
%token LEADING
%token BOTH
%token TRAILING
%token UNKNOWN
%token EXPIRE
%token ACCOUNT
%token ACCOUNTS
%token UNLOCK
%token DAY
%token NEVER
//%token PUMP
%token MYSQL_COMPATIBILITY_MODE
%token MODIFY
%token CHANGE
%token SECOND
%token ASCII
%token COALESCE
%token COLLATION
%token HOUR
%token MICROSECOND
%token MINUTE
%token MONTH
%token QUARTER
%token REPEAT
%token REVERSE
%token ROW_COUNT
%token WEEK
%token REVOKE
%token FUNCTION
%token PRIVILEGES
%token TABLESPACE
%token EXECUTE
%token SUPER
%token GRANT
%token OPTION
%token REFERENCES
%token REPLICATION
%token SLAVE
%token CLIENT
%token USAGE
%token RELOAD
%token FILE
%token TEMPORARY
%token ROUTINE
%token EVENT
%token SHUTDOWN
//%token NULLX
%token AUTO_INCREMENT
//%token APPROXNUM
%token SIGNED
%token UNSIGNED
%token ZEROFILL
%token ENGINES
%token LOW_CARDINALITY
%token AUTOEXTEND_SIZE
%token ADMIN_NAME
%token RANDOM
%token SUSPEND
%token ATTRIBUTE
%token HISTORY
%token REUSE
%token CURRENT
%token OPTIONAL
%token FAILED_LOGIN_ATTEMPTS
%token PASSWORD_LOCK_TIME
%token UNBOUNDED
%token SECONDARY
%token RESTRICTED
%token USER
%token IDENTIFIED
//%token CIPHER
//%token ISSUER
%token X509
//%token SUBJECT
//%token SAN
%token REQUIRE
//%token SSL
%token NONE
%token PASSWORD
%token SHARED
%token EXCLUSIVE
%token MAX_QUERIES_PER_HOUR
%token MAX_UPDATES_PER_HOUR
%token MAX_CONNECTIONS_PER_HOUR
%token MAX_USER_CONNECTIONS
%token FORMAT
%token VERBOSE
%token CONNECTION
%token TRIGGERS
%token PROFILES
%token LOAD
%token INLINE
%token INFILE
%token TERMINATED
%token OPTIONALLY
%token ENCLOSED
%token ESCAPED
%token STARTING
%token LINES
%token ROWS
%token IMPORT
%token DISCARD
%token MODUMP
%token OVER
%token PRECEDING
%token FOLLOWING
%token GROUPS
%token DATABASES
%token TABLES
%token SEQUENCES
%token EXTENDED
%token FULL
%token PROCESSLIST
%token FIELDS
%token COLUMNS
%token OPEN
%token ERRORS
%token WARNINGS
%token INDEXES
%token SCHEMAS
%token NODE
%token LOCKS
%token ROLES
%token TABLE_NUMBER
%token COLUMN_NUMBER
%token TABLE_VALUES
%token TABLE_SIZE
%token NAMES
%token GLOBAL
%token PERSIST
%token SESSION
%token ISOLATION
%token LEVEL
%token READ
%token WRITE
%token ONLY
%token REPEATABLE
%token COMMITTED
%token UNCOMMITTED
%token SERIALIZABLE
%token LOCAL
%token EVENTS
%token PLUGINS
%token CURRENT_TIMESTAMP
%token DATABASE
%token CURRENT_TIME
%token LOCALTIME
%token LOCALTIMESTAMP
%token UTC_DATE
%token UTC_TIME
%token UTC_TIMESTAMP
%token REPLACE
%token CONVERT
%token SEPARATOR
%token TIMESTAMPDIFF
%token CURRENT_DATE
%token CURRENT_USER
%token CURRENT_ROLE
%token SECOND_MICROSECOND
%token MINUTE_MICROSECOND
%token MINUTE_SECOND
%token HOUR_MICROSECOND
%token HOUR_SECOND
%token HOUR_MINUTE
%token DAY_MICROSECOND
%token DAY_SECOND
%token DAY_MINUTE
%token DAY_HOUR
%token YEAR_MONTH
%token SQL_TSI_HOUR
%token SQL_TSI_DAY
%token SQL_TSI_WEEK
%token SQL_TSI_MONTH
%token SQL_TSI_QUARTER
%token SQL_TSI_YEAR
%token SQL_TSI_SECOND
%token SQL_TSI_MINUTE
%token RECURSIVE
%token CONFIG
//%token DRAINER
%token SOURCE
%token STREAM
%token HEADERS
%token CONNECTOR
%token CONNECTORS
%token DAEMON
%token PAUSE
%token CANCEL
%token TASK
%token RESUME
%token MATCH
%token AGAINST
%token BOOLEAN
%token LANGUAGE
%token WITH
%token QUERY
%token EXPANSION
%token WITHOUT
%token VALIDATION
%token ADDDATE
%token BIT_AND
%token BIT_OR
%token BIT_XOR
%token CAST
%token COUNT
%token APPROX_COUNT
%token APPROX_COUNT_DISTINCT
%token APPROX_PERCENTILE
%token CURDATE
%token CURTIME
%token DATE_ADD
%token DATE_SUB
%token EXTRACT
%token GROUP_CONCAT
%token MAX
%token MID
%token MIN
%token NOW
%token POSITION
%token SESSION_USER
%token STD
%token STDDEV
%token MEDIAN
%token STDDEV_POP
%token STDDEV_SAMP
%token SUBDATE
%token SUBSTR
%token SUBSTRING
%token SUM
%token SYSDATE
%token SYSTEM_USER
%token TRANSLATE
%token TRIM
%token VARIANCE
%token VAR_POP
%token VAR_SAMP
%token AVG
%token RANK
%token ROW_NUMBER
%token DENSE_RANK
%token BIT_CAST
%token NEXTVAL
%token SETVAL
%token CURRVAL
%token LASTVAL
//%token ARROW
%token ROW
%token OUTFILE
%token HEADER
%token MAX_FILE_SIZE
%token FORCE_QUOTE
%token PARALLEL
%token UNUSED
//%token BINDINGS
%token DO
%token DECLARE
%token LOOP
%token WHILE
%token LEAVE
%token ITERATE
%token UNTIL
%token CALL
%token SPBEGIN
%token BACKEND
%token SERVERS
%token KILL
%token BACKUP
%token FILESYSTEM
%token QUERY_RESULT
%token ';'
%token '{'
%token '}'
%token ':'
%token '@'

%nonassoc /*1*/ EMPTY
%left /*2*/ UNION EXCEPT INTERSECT MINUS
%nonassoc /*3*/ LOWER_THAN_ORDER
%nonassoc /*4*/ ORDER
%nonassoc /*5*/ LOWER_THAN_SET
%nonassoc /*6*/ SET
%left /*7*/ JOIN STRAIGHT_JOIN LEFT RIGHT INNER OUTER CROSS NATURAL USE FORCE
%nonassoc /*8*/ LOWER_THAN_ON
%nonassoc /*9*/ ON USING
%left /*10*/ SUBQUERY_AS_EXPR
%right /*11*/ '('
%left /*12*/ ')'
%nonassoc /*13*/ LOWER_THAN_STRING
%nonassoc /*14*/ ID AT_ID AT_AT_ID STRING VALUE_ARG COMMENT_KEYWORD QUOTE_ID STAGE CREDENTIALS STAGES
//%nonassoc /*15*/ LOWER_THAN_CHARSET
%nonassoc /*16*/ CHARSET
%right /*17*/ UNIQUE KEY
%left /*18*/ OR PIPE_CONCAT
%left /*19*/ XOR
%left /*20*/ AND
%right /*21*/ NOT '!'
%left /*22*/ BETWEEN CASE WHEN THEN ELSE END ELSEIF
%nonassoc /*23*/ LOWER_THAN_EQ
%left /*24*/ '=' '<' '>' LE GE NE NULL_SAFE_EQUAL IS LIKE REGEXP IN ASSIGNMENT ILIKE
%left /*25*/ '|'
%left /*26*/ '&'
%left /*27*/ SHIFT_LEFT SHIFT_RIGHT
%left /*28*/ '+' '-'
%left /*29*/ '*' '/' DIV '%' MOD
%left /*30*/ '^'
%right /*31*/ '~' UNARY
%left /*32*/ COLLATE
%right /*33*/ BINARY UNDERSCORE_BINARY
%right /*34*/ INTERVAL
%nonassoc /*35*/ '.' ','

%start start_command

%%

start_command :
	stmt_type
	;

stmt_type :
	block_stmt
	| stmt_list
	;

stmt_list :
	stmt
	| stmt_list ';' stmt
	;

block_stmt :
	SPBEGIN stmt_list_return END /*22L*/
	;

stmt_list_return :
	block_type_stmt
	| stmt_list_return ';' block_type_stmt
	;

block_type_stmt :
	block_stmt
	| case_stmt
	| if_stmt
	| loop_stmt
	| repeat_stmt
	| while_stmt
	| iterate_stmt
	| leave_stmt
	| normal_stmt
	| declare_stmt
	| /*empty*/
	;

stmt :
	normal_stmt
	| declare_stmt
	| transaction_stmt
	| /*empty*/
	;

normal_stmt :
	create_stmt
	| call_stmt
	| mo_dump_stmt
	| insert_stmt
	| replace_stmt
	| delete_stmt
	| drop_stmt
	| truncate_table_stmt
	| explain_stmt
	| prepare_stmt
	| deallocate_stmt
	| reset_stmt
	| execute_stmt
	| show_stmt
	| alter_stmt
	| analyze_stmt
	| update_stmt
	| use_stmt
	| set_stmt
	| lock_stmt
	| revoke_stmt
	| grant_stmt
	| load_data_stmt
	| load_extension_stmt
	| do_stmt
	| values_stmt
	| select_stmt
	| kill_stmt
	| backup_stmt
	;

backup_stmt :
	BACKUP STRING /*14N*/ FILESYSTEM STRING /*14N*/
	| BACKUP STRING /*14N*/ S3OPTION '{' infile_or_s3_params '}'
	;

kill_stmt :
	KILL kill_opt INTEGRAL statement_id_opt
	;

kill_opt :
	/*empty*/
	| CONNECTION
	| QUERY
	;

statement_id_opt :
	/*empty*/
	| STRING /*14N*/
	;

call_stmt :
	CALL proc_name '(' /*11R*/ expression_list_opt ')' /*12L*/
	;

leave_stmt :
	LEAVE ident
	;

iterate_stmt :
	ITERATE ident
	;

while_stmt :
	WHILE expression DO stmt_list_return END /*22L*/ WHILE
	| ident ':' WHILE expression DO stmt_list_return END /*22L*/ WHILE ident
	;

repeat_stmt :
	REPEAT stmt_list_return UNTIL expression END /*22L*/ REPEAT
	| ident ':' REPEAT stmt_list_return UNTIL expression END /*22L*/ REPEAT ident
	;

loop_stmt :
	LOOP stmt_list_return END /*22L*/ LOOP
	| ident ':' LOOP stmt_list_return END /*22L*/ LOOP ident
	;

if_stmt :
	IF expression THEN /*22L*/ stmt_list_return elseif_clause_list_opt else_clause_opt2 END /*22L*/ IF
	;

elseif_clause_list_opt :
	/*empty*/
	| elseif_clause_list
	;

elseif_clause_list :
	elseif_clause
	| elseif_clause_list elseif_clause
	;

elseif_clause :
	ELSEIF /*22L*/ expression THEN /*22L*/ stmt_list_return
	;

case_stmt :
	CASE /*22L*/ expression when_clause_list2 else_clause_opt2 END /*22L*/ CASE /*22L*/
	;

when_clause_list2 :
	when_clause2
	| when_clause_list2 when_clause2
	;

when_clause2 :
	WHEN /*22L*/ expression THEN /*22L*/ stmt_list_return
	;

else_clause_opt2 :
	/*empty*/
	| ELSE /*22L*/ stmt_list_return
	;

mo_dump_stmt :
	MODUMP QUERY_RESULT STRING /*14N*/ INTO STRING /*14N*/ export_fields export_lines_opt header_opt max_file_size_opt force_quote_opt
	;

load_data_stmt :
	LOAD DATA local_opt load_param_opt duplicate_opt INTO TABLE table_name tail_param_opt parallel_opt
	;

load_extension_stmt :
	LOAD extension_name
	;

load_set_spec_opt :
	/*empty*/
	| SET /*6N*/ load_set_list
	;

load_set_list :
	load_set_item
	| load_set_list ',' /*35N*/ load_set_item
	;

load_set_item :
	normal_ident '=' /*24L*/ DEFAULT
	| normal_ident '=' /*24L*/ expression
	;

parallel_opt :
	/*empty*/
	| PARALLEL STRING /*14N*/
	;

normal_ident :
	ident
	| ident '.' /*35N*/ ident
	| ident '.' /*35N*/ ident '.' /*35N*/ ident
	;

columns_or_variable_list_opt :
	/*empty*/
	| '(' /*11R*/ ')' /*12L*/
	| '(' /*11R*/ columns_or_variable_list ')' /*12L*/
	;

columns_or_variable_list :
	columns_or_variable
	| columns_or_variable_list ',' /*35N*/ columns_or_variable
	;

columns_or_variable :
	column_name_unresolved
	| user_variable
	;

variable_list :
	variable
	| variable_list ',' /*35N*/ variable
	;

variable :
	system_variable
	| user_variable
	;

system_variable :
	AT_AT_ID /*14N*/
	;

user_variable :
	AT_ID /*14N*/
	;

ignore_lines :
	/*empty*/
	| IGNORE INTEGRAL LINES
	| IGNORE INTEGRAL ROWS
	;

load_lines :
	/*empty*/
	| LINES starting lines_terminated_opt
	| LINES lines_terminated starting_opt
	;

starting_opt :
	/*empty*/
	| starting
	;

starting :
	STARTING BY STRING /*14N*/
	;

lines_terminated_opt :
	/*empty*/
	| lines_terminated
	;

lines_terminated :
	TERMINATED BY STRING /*14N*/
	;

load_fields :
	/*empty*/
	| fields_or_columns field_item_list
	;

field_item_list :
	field_item
	| field_item_list field_item
	;

field_item :
	TERMINATED BY field_terminator
	| OPTIONALLY ENCLOSED BY field_terminator
	| ENCLOSED BY field_terminator
	| ESCAPED BY field_terminator
	;

field_terminator :
	STRING /*14N*/
	;

duplicate_opt :
	/*empty*/
	| IGNORE
	| REPLACE
	;

local_opt :
	/*empty*/
	| LOCAL
	;

grant_stmt :
	GRANT priv_list ON /*9N*/ object_type priv_level TO role_spec_list grant_option_opt
	| GRANT role_spec_list TO drop_user_spec_list grant_option_opt
	| GRANT PROXY ON /*9N*/ user_spec TO user_spec_list grant_option_opt
	;

grant_option_opt :
	/*empty*/
	| WITH GRANT OPTION
	;

revoke_stmt :
	REVOKE exists_opt priv_list ON /*9N*/ object_type priv_level FROM role_spec_list
	| REVOKE exists_opt role_spec_list FROM user_spec_list
	;

priv_level :
	'*' /*29L*/
	| '*' /*29L*/ '.' /*35N*/ '*' /*29L*/
	| ident '.' /*35N*/ '*' /*29L*/
	| ident '.' /*35N*/ ident
	| ident
	;

object_type :
	TABLE
	| DATABASE
	| FUNCTION
	| PROCEDURE
	| VIEW
	| ACCOUNT
	;

priv_list :
	priv_elem
	| priv_list ',' /*35N*/ priv_elem
	;

priv_elem :
	priv_type
	| priv_type '(' /*11R*/ column_name_list ')' /*12L*/
	;

column_name_list :
	column_name
	| column_name_list ',' /*35N*/ column_name
	;

priv_type :
	ALL
	| CREATE ACCOUNT
	| DROP ACCOUNT
	| ALTER ACCOUNT
	| ALL PRIVILEGES
	| ALTER TABLE
	| ALTER VIEW
	| CREATE
	| CREATE USER
	| DROP USER
	| ALTER USER
	| CREATE TABLESPACE
	| TRIGGER
	| DELETE
	| DROP TABLE
	| DROP VIEW
	| EXECUTE
	| INDEX
	| INSERT
	| SELECT
	| SUPER
	| CREATE DATABASE
	| DROP DATABASE
	| SHOW DATABASES
	| CONNECT
	| MANAGE GRANTS
	| OWNERSHIP
	| SHOW TABLES
	| CREATE TABLE
	| UPDATE
	| GRANT OPTION
	| REFERENCES
	| REFERENCE
	| REPLICATION SLAVE
	| REPLICATION CLIENT
	| USAGE
	| RELOAD
	| FILE
	| CREATE TEMPORARY TABLES
	| LOCK TABLES
	| CREATE VIEW
	| SHOW VIEW
	| CREATE ROLE
	| DROP ROLE
	| ALTER ROLE
	| CREATE ROUTINE
	| ALTER ROUTINE
	| EVENT
	| SHUTDOWN
	| TRUNCATE
	;

set_stmt :
	set_variable_stmt
	| set_password_stmt
	| set_role_stmt
	| set_default_role_stmt
	| set_transaction_stmt
	;

set_transaction_stmt :
	SET /*6N*/ TRANSACTION transaction_characteristic_list
	| SET /*6N*/ GLOBAL TRANSACTION transaction_characteristic_list
	| SET /*6N*/ SESSION TRANSACTION transaction_characteristic_list
	;

transaction_characteristic_list :
	transaction_characteristic
	| transaction_characteristic_list ',' /*35N*/ transaction_characteristic
	;

transaction_characteristic :
	ISOLATION LEVEL isolation_level
	| access_mode
	;

isolation_level :
	REPEATABLE READ
	| READ COMMITTED
	| READ UNCOMMITTED
	| SERIALIZABLE
	;

access_mode :
	READ WRITE
	| READ ONLY
	;

set_role_stmt :
	SET /*6N*/ ROLE role_spec
	| SET /*6N*/ SECONDARY ROLE ALL
	| SET /*6N*/ SECONDARY ROLE NONE
	;

set_default_role_stmt :
	SET /*6N*/ DEFAULT ROLE set_default_role_opt TO user_spec_list
	;

set_default_role_opt :
	NONE
	| ALL
	| role_spec_list
	;

set_variable_stmt :
	SET /*6N*/ var_assignment_list
	;

set_password_stmt :
	SET /*6N*/ PASSWORD '=' /*24L*/ password_opt
	| SET /*6N*/ PASSWORD FOR user_spec '=' /*24L*/ password_opt
	;

password_opt :
	STRING /*14N*/
	| PASSWORD '(' /*11R*/ auth_string ')' /*12L*/
	;

var_assignment_list :
	var_assignment
	| var_assignment_list ',' /*35N*/ var_assignment
	;

var_assignment :
	var_name equal_or_assignment set_expr
	| GLOBAL var_name equal_or_assignment set_expr
	| PERSIST var_name equal_or_assignment set_expr
	| SESSION var_name equal_or_assignment set_expr
	| LOCAL var_name equal_or_assignment set_expr
	| AT_ID /*14N*/ equal_or_assignment set_expr
	| AT_AT_ID /*14N*/ equal_or_assignment set_expr
	| NAMES charset_name
	| NAMES charset_name COLLATE /*32L*/ DEFAULT
	| NAMES charset_name COLLATE /*32L*/ name_string
	| NAMES DEFAULT
	| charset_keyword charset_name
	| charset_keyword DEFAULT
	;

set_expr :
	ON /*9N*/
	| BINARY /*33R*/
	| expr_or_default
	;

equal_or_assignment :
	'=' /*24L*/
	| ASSIGNMENT /*24L*/
	;

var_name :
	ident
	| ident '.' /*35N*/ ident
	;

var_name_list :
	var_name
	| var_name_list ',' /*35N*/ var_name
	;

transaction_stmt :
	begin_stmt
	| commit_stmt
	| rollback_stmt
	;

rollback_stmt :
	ROLLBACK completion_type
	;

commit_stmt :
	COMMIT completion_type
	;

completion_type :
	/*empty*/
	| WORK
	| AND /*20L*/ CHAIN NO RELEASE
	| AND /*20L*/ CHAIN
	| AND /*20L*/ NO CHAIN RELEASE
	| RELEASE
	| AND /*20L*/ NO CHAIN NO RELEASE
	| AND /*20L*/ NO CHAIN
	| NO RELEASE
	;

begin_stmt :
	BEGIN
	| BEGIN WORK
	| START TRANSACTION
	| START TRANSACTION READ WRITE
	| START TRANSACTION READ ONLY
	| START TRANSACTION WITH CONSISTENT SNAPSHOT
	;

use_stmt :
	USE /*7L*/ ident
	| USE /*7L*/
	| USE /*7L*/ ROLE role_spec
	| USE /*7L*/ SECONDARY ROLE ALL
	| USE /*7L*/ SECONDARY ROLE NONE
	;

update_stmt :
	update_no_with_stmt
	| with_clause update_no_with_stmt
	;

update_no_with_stmt :
	UPDATE priority_opt ignore_opt table_reference SET /*6N*/ update_list where_expression_opt order_by_opt limit_opt
	| UPDATE priority_opt ignore_opt table_references SET /*6N*/ update_list where_expression_opt
	;

update_list :
	update_value
	| update_list ',' /*35N*/ update_value
	;

update_value :
	column_name '=' /*24L*/ expr_or_default
	;

lock_stmt :
	lock_table_stmt
	| unlock_table_stmt
	;

lock_table_stmt :
	LOCK TABLES table_lock_list
	;

table_lock_list :
	table_lock_elem
	| table_lock_list ',' /*35N*/ table_lock_elem
	;

table_lock_elem :
	table_name table_lock_type
	;

table_lock_type :
	READ
	| READ LOCAL
	| WRITE
	| LOW_PRIORITY WRITE
	;

unlock_table_stmt :
	UNLOCK TABLES
	;

prepareable_stmt :
	create_stmt
	| insert_stmt
	| delete_stmt
	| drop_stmt
	| show_stmt
	| update_stmt
	| select_stmt
	;

prepare_stmt :
	prepare_sym stmt_name FROM prepareable_stmt
	| prepare_sym stmt_name FROM STRING /*14N*/
	;

execute_stmt :
	execute_sym stmt_name
	| execute_sym stmt_name USING /*9N*/ variable_list
	;

deallocate_stmt :
	deallocate_sym PREPARE stmt_name
	;

reset_stmt :
	reset_sym PREPARE stmt_name
	;

explainable_stmt :
	delete_stmt
	| load_data_stmt
	| insert_stmt
	| replace_stmt
	| update_stmt
	| select_stmt
	;

explain_stmt :
	explain_sym unresolved_object_name
	| explain_sym unresolved_object_name column_name
	| explain_sym FOR CONNECTION INTEGRAL
	| explain_sym FORMAT '=' /*24L*/ STRING /*14N*/ FOR CONNECTION INTEGRAL
	| explain_sym explainable_stmt
	| explain_sym VERBOSE explainable_stmt
	| explain_sym ANALYZE explainable_stmt
	| explain_sym ANALYZE VERBOSE explainable_stmt
	| explain_sym '(' /*11R*/ utility_option_list ')' /*12L*/ explainable_stmt
	;

explain_option_key :
	ANALYZE
	| VERBOSE
	| FORMAT
	;

explain_foramt_value :
	JSON
	| TEXT
	;

prepare_sym :
	PREPARE
	;

deallocate_sym :
	DEALLOCATE
	;

execute_sym :
	EXECUTE
	;

reset_sym :
	RESET
	;

explain_sym :
	EXPLAIN
	| DESCRIBE
	| DESC
	;

utility_option_list :
	utility_option_elem
	| utility_option_list ',' /*35N*/ utility_option_elem
	;

utility_option_elem :
	utility_option_name utility_option_arg
	;

utility_option_name :
	explain_option_key
	;

utility_option_arg :
	TRUE
	| FALSE
	| explain_foramt_value
	;

analyze_stmt :
	ANALYZE TABLE table_name '(' /*11R*/ column_list ')' /*12L*/
	;

alter_stmt :
	alter_user_stmt
	| alter_account_stmt
	| alter_database_config_stmt
	| alter_view_stmt
	| alter_table_stmt
	| alter_publication_stmt
	| alter_stage_stmt
	| alter_sequence_stmt
	;

alter_sequence_stmt :
	ALTER SEQUENCE exists_opt table_name alter_as_datatype_opt increment_by_opt min_value_opt max_value_opt start_with_opt alter_cycle_opt
	;

alter_view_stmt :
	ALTER VIEW exists_opt table_name column_list_opt AS select_stmt
	;

alter_table_stmt :
	ALTER TABLE table_name alter_option_list
	;

alter_option_list :
	alter_option
	| alter_option_list ',' /*35N*/ alter_option
	;

alter_option :
	ADD table_elem_2
	| MODIFY column_keyword_opt column_def column_position
	| CHANGE column_keyword_opt column_name column_def column_position
	| RENAME COLUMN column_name TO column_name
	| ALTER column_keyword_opt column_name SET /*6N*/ DEFAULT bit_expr
	| ALTER column_keyword_opt column_name SET /*6N*/ visibility
	| ALTER column_keyword_opt column_name DROP DEFAULT
	| ORDER /*4N*/ BY alter_column_order_list %prec LOWER_THAN_ORDER /*3N*/
	| DROP alter_table_drop
	| ALTER alter_table_alter
	| table_option
	| RENAME rename_type alter_table_rename
	| ADD column_keyword_opt column_def column_position
	| ALGORITHM equal_opt algorithm_type
	| default_opt charset_keyword equal_opt charset_name COLLATE /*32L*/ equal_opt charset_name
	| CONVERT TO CHARACTER SET /*6N*/ charset_name
	| CONVERT TO CHARACTER SET /*6N*/ charset_name COLLATE /*32L*/ equal_opt charset_name
	| able_type KEYS
	| space_type TABLESPACE
	| FORCE /*7L*/
	| LOCK equal_opt lock_type
	| with_type VALIDATION
	;

rename_type :
	/*empty*/
	| TO
	| AS
	;

algorithm_type :
	DEFAULT
	| INSTANT
	| INPLACE
	| COPY
	;

able_type :
	DISABLE
	| ENABLE
	;

space_type :
	DISCARD
	| IMPORT
	;

lock_type :
	DEFAULT
	| NONE
	| SHARED
	| EXCLUSIVE
	;

with_type :
	WITHOUT
	| WITH
	;

column_keyword_opt :
	/*empty*/
	| COLUMN
	;

column_position :
	/*empty*/
	| FIRST
	| AFTER column_name
	;

alter_column_order_list :
	alter_column_order
	| alter_column_order_list ',' /*35N*/ alter_column_order
	;

alter_column_order :
	column_name asc_desc_opt
	;

alter_table_rename :
	table_name_unresolved
	;

alter_table_drop :
	INDEX ident
	| KEY /*17R*/ ident
	| ident
	| COLUMN ident
	| FOREIGN KEY /*17R*/ ident
	| PRIMARY KEY /*17R*/
	;

alter_table_alter :
	INDEX ident visibility
	| CHECK ident enforce
	| CONSTRAINT ident enforce
	;

visibility :
	VISIBLE
	| INVISIBLE
	;

alter_account_stmt :
	ALTER ACCOUNT exists_opt account_name alter_account_auth_option account_status_option account_comment_opt
	;

alter_database_config_stmt :
	ALTER DATABASE db_name SET /*6N*/ MYSQL_COMPATIBILITY_MODE '=' /*24L*/ STRING /*14N*/
	| ALTER ACCOUNT CONFIG account_name SET /*6N*/ MYSQL_COMPATIBILITY_MODE '=' /*24L*/ STRING /*14N*/
	| ALTER ACCOUNT CONFIG SET /*6N*/ MYSQL_COMPATIBILITY_MODE var_name equal_or_assignment set_expr
	;

alter_account_auth_option :
	/*empty*/
	| ADMIN_NAME equal_opt account_admin_name account_identified
	;

alter_user_stmt :
	ALTER USER exists_opt user_spec_list_of_create_user default_role_opt pwd_or_lck_opt user_comment_or_attribute_opt
	;

default_role_opt :
	/*empty*/
	| DEFAULT ROLE account_role_name
	;

exists_opt :
	/*empty*/
	| IF EXISTS
	;

pwd_or_lck_opt :
	/*empty*/
	| pwd_or_lck
	;

pwd_or_lck :
	UNLOCK
	| LOCK
	| pwd_expire
	| pwd_expire INTERVAL /*34R*/ INTEGRAL DAY
	| pwd_expire NEVER
	| pwd_expire DEFAULT
	| PASSWORD HISTORY DEFAULT
	| PASSWORD HISTORY INTEGRAL
	| PASSWORD REUSE INTERVAL /*34R*/ DEFAULT
	| PASSWORD REUSE INTERVAL /*34R*/ INTEGRAL DAY
	| PASSWORD REQUIRE CURRENT
	| PASSWORD REQUIRE CURRENT DEFAULT
	| PASSWORD REQUIRE CURRENT OPTIONAL
	| FAILED_LOGIN_ATTEMPTS INTEGRAL
	| PASSWORD_LOCK_TIME INTEGRAL
	| PASSWORD_LOCK_TIME UNBOUNDED
	;

pwd_expire :
	PASSWORD EXPIRE clear_pwd_opt
	;

clear_pwd_opt :
	/*empty*/
	;

auth_string :
	STRING /*14N*/
	;

show_stmt :
	show_create_stmt
	| show_columns_stmt
	| show_databases_stmt
	| show_tables_stmt
	| show_sequences_stmt
	| show_process_stmt
	| show_errors_stmt
	| show_warnings_stmt
	| show_variables_stmt
	| show_status_stmt
	| show_index_stmt
	| show_target_filter_stmt
	| show_table_status_stmt
	| show_grants_stmt
	| show_roles_stmt
	| show_collation_stmt
	| show_function_status_stmt
	| show_procedure_status_stmt
	| show_node_list_stmt
	| show_locks_stmt
	| show_table_num_stmt
	| show_column_num_stmt
	| show_table_values_stmt
	| show_table_size_stmt
	| show_accounts_stmt
	| show_publications_stmt
	| show_subscriptions_stmt
	| show_servers_stmt
	| show_stages_stmt
	| show_connectors_stmt
	;

show_collation_stmt :
	SHOW COLLATION like_opt where_expression_opt
	;

show_stages_stmt :
	SHOW STAGES /*14N*/ like_opt
	;

show_grants_stmt :
	SHOW GRANTS
	| SHOW GRANTS FOR user_name using_roles_opt
	| SHOW GRANTS FOR ROLE ident
	;

using_roles_opt :
	/*empty*/
	| USING /*9N*/ role_spec_list
	;

show_table_status_stmt :
	SHOW TABLE STATUS from_or_in_opt db_name_opt like_opt where_expression_opt
	;

from_or_in_opt :
	/*empty*/
	| from_or_in
	;

db_name_opt :
	/*empty*/
	| db_name
	;

show_function_status_stmt :
	SHOW FUNCTION STATUS like_opt where_expression_opt
	;

show_procedure_status_stmt :
	SHOW PROCEDURE STATUS like_opt where_expression_opt
	;

show_roles_stmt :
	SHOW ROLES like_opt
	;

show_node_list_stmt :
	SHOW NODE LIST
	;

show_locks_stmt :
	SHOW LOCKS
	;

show_table_num_stmt :
	SHOW TABLE_NUMBER from_or_in_opt db_name_opt
	;

show_column_num_stmt :
	SHOW COLUMN_NUMBER table_column_name database_name_opt
	;

show_table_values_stmt :
	SHOW TABLE_VALUES table_column_name database_name_opt
	;

show_table_size_stmt :
	SHOW TABLE_SIZE table_column_name database_name_opt
	;

show_target_filter_stmt :
	SHOW show_target like_opt where_expression_opt
	;

show_target :
	CONFIG
	| charset_keyword
	| ENGINES
	| TRIGGERS from_or_in_opt db_name_opt
	| EVENTS from_or_in_opt db_name_opt
	| PLUGINS
	| PRIVILEGES
	| PROFILES
	;

show_index_stmt :
	SHOW extended_opt index_kwd from_or_in table_name where_expression_opt
	| SHOW extended_opt index_kwd from_or_in ident from_or_in ident where_expression_opt
	;

extended_opt :
	/*empty*/
	| EXTENDED
	;

index_kwd :
	INDEX
	| INDEXES
	| KEYS
	;

show_variables_stmt :
	SHOW global_scope VARIABLES like_opt where_expression_opt
	;

show_status_stmt :
	SHOW global_scope STATUS like_opt where_expression_opt
	;

global_scope :
	/*empty*/
	| GLOBAL
	| SESSION
	;

show_warnings_stmt :
	SHOW WARNINGS limit_opt
	;

show_errors_stmt :
	SHOW ERRORS limit_opt
	;

show_process_stmt :
	SHOW full_opt PROCESSLIST
	;

show_sequences_stmt :
	SHOW SEQUENCES database_name_opt where_expression_opt
	;

show_tables_stmt :
	SHOW full_opt TABLES database_name_opt like_opt where_expression_opt
	| SHOW OPEN full_opt TABLES database_name_opt like_opt where_expression_opt
	;

show_databases_stmt :
	SHOW DATABASES like_opt where_expression_opt
	| SHOW SCHEMAS like_opt where_expression_opt
	;

show_columns_stmt :
	SHOW full_opt fields_or_columns table_column_name database_name_opt like_opt where_expression_opt
	| SHOW EXTENDED full_opt fields_or_columns table_column_name database_name_opt like_opt where_expression_opt
	;

show_accounts_stmt :
	SHOW ACCOUNTS like_opt
	;

show_publications_stmt :
	SHOW PUBLICATIONS like_opt
	;

show_subscriptions_stmt :
	SHOW SUBSCRIPTIONS like_opt
	;

like_opt :
	/*empty*/
	| LIKE /*24L*/ simple_expr
	| ILIKE /*24L*/ simple_expr
	;

database_name_opt :
	/*empty*/
	| from_or_in ident
	;

table_column_name :
	from_or_in unresolved_object_name
	;

from_or_in :
	FROM
	| IN /*24L*/
	;

fields_or_columns :
	FIELDS
	| COLUMNS
	;

full_opt :
	/*empty*/
	| FULL
	;

show_create_stmt :
	SHOW CREATE TABLE table_name_unresolved
	| SHOW CREATE VIEW table_name_unresolved
	| SHOW CREATE DATABASE not_exists_opt db_name
	| SHOW CREATE PUBLICATION db_name
	;

show_servers_stmt :
	SHOW BACKEND SERVERS
	;

table_name_unresolved :
	ident
	| ident '.' /*35N*/ ident
	;

db_name :
	ident
	;

unresolved_object_name :
	ident
	| ident '.' /*35N*/ ident
	| ident '.' /*35N*/ ident '.' /*35N*/ ident
	;

truncate_table_stmt :
	TRUNCATE table_name
	| TRUNCATE TABLE table_name
	;

drop_stmt :
	drop_ddl_stmt
	;

drop_ddl_stmt :
	drop_database_stmt
	| drop_prepare_stmt
	| drop_table_stmt
	| drop_view_stmt
	| drop_index_stmt
	| drop_role_stmt
	| drop_user_stmt
	| drop_account_stmt
	| drop_function_stmt
	| drop_sequence_stmt
	| drop_publication_stmt
	| drop_procedure_stmt
	| drop_stage_stmt
	| drop_connector_stmt
	;

drop_sequence_stmt :
	DROP SEQUENCE exists_opt table_name_list
	;

drop_account_stmt :
	DROP ACCOUNT exists_opt account_name
	;

drop_user_stmt :
	DROP USER exists_opt drop_user_spec_list
	;

drop_user_spec_list :
	drop_user_spec
	| drop_user_spec_list ',' /*35N*/ drop_user_spec
	;

drop_user_spec :
	user_name
	;

drop_role_stmt :
	DROP ROLE exists_opt role_spec_list
	;

drop_index_stmt :
	DROP INDEX exists_opt ident ON /*9N*/ table_name
	;

drop_table_stmt :
	DROP TABLE temporary_opt exists_opt table_name_list drop_table_opt
	| DROP STREAM exists_opt table_name_list
	;

drop_connector_stmt :
	DROP CONNECTOR exists_opt table_name_list
	;

drop_view_stmt :
	DROP VIEW exists_opt table_name_list
	;

drop_database_stmt :
	DROP DATABASE exists_opt ident
	| DROP SCHEMA exists_opt ident
	;

drop_prepare_stmt :
	DROP PREPARE stmt_name
	;

drop_function_stmt :
	DROP FUNCTION func_name '(' /*11R*/ func_args_list_opt ')' /*12L*/
	;

drop_procedure_stmt :
	DROP PROCEDURE proc_name
	| DROP PROCEDURE IF EXISTS proc_name
	;

delete_stmt :
	delete_without_using_stmt
	| delete_with_using_stmt
	| with_clause delete_with_using_stmt
	| with_clause delete_without_using_stmt
	;

delete_without_using_stmt :
	DELETE priority_opt quick_opt ignore_opt FROM table_name partition_clause_opt as_opt_id where_expression_opt order_by_opt limit_opt
	| DELETE priority_opt quick_opt ignore_opt table_name_wild_list FROM table_references where_expression_opt
	;

delete_with_using_stmt :
	DELETE priority_opt quick_opt ignore_opt FROM table_name_wild_list USING /*9N*/ table_references where_expression_opt
	;

table_name_wild_list :
	table_name_opt_wild
	| table_name_wild_list ',' /*35N*/ table_name_opt_wild
	;

table_name_opt_wild :
	ident wild_opt
	| ident '.' /*35N*/ ident wild_opt
	;

wild_opt :
	%prec EMPTY /*1N*/ /*empty*/
	| '.' /*35N*/ '*' /*29L*/
	;

priority_opt :
	/*empty*/
	| priority
	;

priority :
	LOW_PRIORITY
	| HIGH_PRIORITY
	| DELAYED
	;

quick_opt :
	/*empty*/
	| QUICK
	;

ignore_opt :
	/*empty*/
	| IGNORE
	;

replace_stmt :
	REPLACE into_table_name partition_clause_opt replace_data
	;

replace_data :
	VALUES values_list
	| select_stmt
	| '(' /*11R*/ insert_column_list ')' /*12L*/ VALUES values_list
	| '(' /*11R*/ ')' /*12L*/ VALUES values_list
	| '(' /*11R*/ insert_column_list ')' /*12L*/ select_stmt
	| SET /*6N*/ set_value_list
	;

insert_stmt :
	INSERT into_table_name partition_clause_opt insert_data on_duplicate_key_update_opt
	;

accounts_list :
	account_name
	| accounts_list ',' /*35N*/ account_name
	;

insert_data :
	VALUES values_list
	| select_stmt
	| '(' /*11R*/ insert_column_list ')' /*12L*/ VALUES values_list
	| '(' /*11R*/ ')' /*12L*/ VALUES values_list
	| '(' /*11R*/ insert_column_list ')' /*12L*/ select_stmt
	| SET /*6N*/ set_value_list
	;

on_duplicate_key_update_opt :
	/*empty*/
	| ON /*9N*/ DUPLICATE KEY /*17R*/ UPDATE update_list
	;

set_value_list :
	/*empty*/
	| set_value
	| set_value_list ',' /*35N*/ set_value
	;

set_value :
	insert_column '=' /*24L*/ expr_or_default
	;

insert_column_list :
	insert_column
	| insert_column_list ',' /*35N*/ insert_column
	;

insert_column :
	ident
	| ident '.' /*35N*/ ident
	;

values_list :
	row_value
	| values_list ',' /*35N*/ row_value
	;

row_value :
	row_opt '(' /*11R*/ data_opt ')' /*12L*/
	;

row_opt :
	/*empty*/
	| ROW
	;

data_opt :
	/*empty*/
	| data_values
	;

data_values :
	expr_or_default
	| data_values ',' /*35N*/ expr_or_default
	;

expr_or_default :
	expression
	| DEFAULT
	;

partition_clause_opt :
	/*empty*/
	| PARTITION '(' /*11R*/ partition_id_list ')' /*12L*/
	;

partition_id_list :
	ident
	| partition_id_list ',' /*35N*/ ident
	;

into_table_name :
	INTO table_name
	| table_name
	;

export_data_param_opt :
	/*empty*/
	| INTO OUTFILE STRING /*14N*/ export_fields export_lines_opt header_opt max_file_size_opt force_quote_opt
	;

export_fields :
	/*empty*/
	| FIELDS TERMINATED BY STRING /*14N*/
	| FIELDS TERMINATED BY STRING /*14N*/ ENCLOSED BY field_terminator
	| FIELDS ENCLOSED BY field_terminator
	;

export_lines_opt :
	/*empty*/
	| LINES lines_terminated_opt
	;

header_opt :
	/*empty*/
	| HEADER STRING /*14N*/
	;

max_file_size_opt :
	/*empty*/
	| MAX_FILE_SIZE INTEGRAL
	;

force_quote_opt :
	/*empty*/
	| FORCE_QUOTE '(' /*11R*/ force_quote_list ')' /*12L*/
	;

force_quote_list :
	ident
	| force_quote_list ',' /*35N*/ ident
	;

select_stmt :
	select_no_parens
	| select_with_parens
	;

select_no_parens :
	simple_select order_by_opt limit_opt export_data_param_opt select_lock_opt
	| select_with_parens order_by_clause export_data_param_opt
	| select_with_parens order_by_opt limit_clause export_data_param_opt
	| with_clause simple_select order_by_opt limit_opt export_data_param_opt select_lock_opt
	| with_clause select_with_parens order_by_clause export_data_param_opt
	| with_clause select_with_parens order_by_opt limit_clause export_data_param_opt
	;

with_clause :
	WITH cte_list
	| WITH RECURSIVE cte_list
	;

cte_list :
	common_table_expr
	| cte_list ',' /*35N*/ common_table_expr
	;

common_table_expr :
	ident column_list_opt AS '(' /*11R*/ stmt ')' /*12L*/
	;

column_list_opt :
	/*empty*/
	| '(' /*11R*/ column_list ')' /*12L*/
	;

limit_opt :
	/*empty*/
	| limit_clause
	;

limit_clause :
	LIMIT expression
	| LIMIT expression ',' /*35N*/ expression
	| LIMIT expression OFFSET expression
	;

order_by_opt :
	/*empty*/
	| order_by_clause
	;

order_by_clause :
	ORDER /*4N*/ BY order_list
	;

order_list :
	order
	| order_list ',' /*35N*/ order
	;

order :
	expression asc_desc_opt nulls_first_last_opt
	;

asc_desc_opt :
	/*empty*/
	| ASC
	| DESC
	;

nulls_first_last_opt :
	/*empty*/
	| NULLS FIRST
	| NULLS LAST
	;

select_lock_opt :
	/*empty*/
	| FOR UPDATE
	;

select_with_parens :
	'(' /*11R*/ select_no_parens ')' /*12L*/
	| '(' /*11R*/ select_with_parens ')' /*12L*/
	| '(' /*11R*/ values_stmt ')' /*12L*/
	;

simple_select :
	simple_select_clause
	| simple_select union_op simple_select_clause
	| select_with_parens union_op simple_select_clause
	| simple_select union_op select_with_parens
	| select_with_parens union_op select_with_parens
	;

union_op :
	UNION /*2L*/
	| UNION /*2L*/ ALL
	| UNION /*2L*/ DISTINCT
	| EXCEPT /*2L*/
	| EXCEPT /*2L*/ ALL
	| EXCEPT /*2L*/ DISTINCT
	| INTERSECT /*2L*/
	| INTERSECT /*2L*/ ALL
	| INTERSECT /*2L*/ DISTINCT
	| MINUS /*2L*/
	| MINUS /*2L*/ ALL
	| MINUS /*2L*/ DISTINCT
	;

simple_select_clause :
	SELECT distinct_opt select_expression_list from_opt where_expression_opt group_by_opt having_opt
	| SELECT select_option_opt select_expression_list from_opt where_expression_opt group_by_opt having_opt
	;

select_option_opt :
	SQL_SMALL_RESULT
	| SQL_BIG_RESULT
	| SQL_BUFFER_RESULT
	;

distinct_opt :
	/*empty*/
	| ALL
	| distinct_keyword
	;

distinct_keyword :
	DISTINCT
	| DISTINCTROW
	;

having_opt :
	/*empty*/
	| HAVING expression
	;

group_by_opt :
	/*empty*/
	| GROUP BY expression_list
	;

where_expression_opt :
	/*empty*/
	| WHERE expression
	;

select_expression_list :
	select_expression
	| select_expression_list ',' /*35N*/ select_expression
	;

select_expression :
	'*' /*29L*/ %prec '*' /*29L*/
	| expression as_name_opt
	| ident '.' /*35N*/ '*' /*29L*/ %prec '*' /*29L*/
	| ident '.' /*35N*/ ident '.' /*35N*/ '*' /*29L*/ %prec '*' /*29L*/
	;

from_opt :
	/*empty*/
	| from_clause
	;

from_clause :
	FROM table_references
	;

table_references :
	escaped_table_reference
	| table_references ',' /*35N*/ escaped_table_reference
	;

escaped_table_reference :
	table_reference %prec LOWER_THAN_SET /*5N*/
	;

table_reference :
	table_factor
	| join_table
	;

join_table :
	table_reference inner_join table_factor join_condition_opt
	| table_reference straight_join table_factor on_expression_opt
	| table_reference outer_join table_factor join_condition
	| table_reference natural_join table_factor
	;

natural_join :
	NATURAL /*7L*/ JOIN /*7L*/
	| NATURAL /*7L*/ outer_join
	;

outer_join :
	LEFT /*7L*/ JOIN /*7L*/
	| LEFT /*7L*/ OUTER /*7L*/ JOIN /*7L*/
	| RIGHT /*7L*/ JOIN /*7L*/
	| RIGHT /*7L*/ OUTER /*7L*/ JOIN /*7L*/
	;

values_stmt :
	VALUES row_constructor_list order_by_opt limit_opt
	;

row_constructor_list :
	row_constructor
	| row_constructor_list ',' /*35N*/ row_constructor
	;

row_constructor :
	ROW '(' /*11R*/ data_values ')' /*12L*/
	;

on_expression_opt :
	%prec JOIN /*7L*/ /*empty*/
	| ON /*9N*/ expression
	;

straight_join :
	STRAIGHT_JOIN /*7L*/
	;

inner_join :
	JOIN /*7L*/
	| INNER /*7L*/ JOIN /*7L*/
	| CROSS /*7L*/ JOIN /*7L*/
	;

join_condition_opt :
	%prec JOIN /*7L*/ /*empty*/
	| join_condition
	;

join_condition :
	ON /*9N*/ expression
	| USING /*9N*/ '(' /*11R*/ column_list ')' /*12L*/
	;

column_list :
	ident
	| column_list ',' /*35N*/ ident
	;

table_factor :
	aliased_table_name
	| table_subquery as_opt_id column_list_opt
	| table_function as_opt_id
	| '(' /*11R*/ table_references ')' /*12L*/
	;

table_subquery :
	select_with_parens %prec SUBQUERY_AS_EXPR /*10L*/
	;

table_function :
	ident '(' /*11R*/ expression_list_opt ')' /*12L*/
	;

aliased_table_name :
	table_name as_opt_id index_hint_list_opt
	;

index_hint_list_opt :
	/*empty*/
	| index_hint_list
	;

index_hint_list :
	index_hint
	| index_hint_list index_hint
	;

index_hint :
	index_hint_type index_hint_scope '(' /*11R*/ index_name_list ')' /*12L*/
	;

index_hint_type :
	USE /*7L*/ key_or_index
	| IGNORE key_or_index
	| FORCE /*7L*/ key_or_index
	;

index_hint_scope :
	/*empty*/
	| FOR JOIN /*7L*/
	| FOR ORDER /*4N*/ BY
	| FOR GROUP BY
	;

index_name_list :
	/*empty*/
	| ident
	| index_name_list ',' /*35N*/ ident
	| PRIMARY
	| index_name_list ',' /*35N*/ PRIMARY
	;

as_opt_id :
	/*empty*/
	| table_alias
	| AS table_alias
	;

table_alias :
	ident
	| STRING /*14N*/
	;

as_name_opt :
	/*empty*/
	| ident
	| AS ident
	| STRING /*14N*/
	| AS STRING /*14N*/
	;

stmt_name :
	ident
	;

create_stmt :
	create_ddl_stmt
	| create_role_stmt
	| create_user_stmt
	| create_account_stmt
	| create_publication_stmt
	| create_stage_stmt
	;

create_ddl_stmt :
	create_table_stmt
	| create_database_stmt
	| create_index_stmt
	| create_view_stmt
	| create_function_stmt
	| create_extension_stmt
	| create_sequence_stmt
	| create_procedure_stmt
	| create_stream_stmt
	| create_connector_stmt
	| pause_daemon_task_stmt
	| cancel_daemon_task_stmt
	| resume_daemon_task_stmt
	;

create_extension_stmt :
	CREATE EXTENSION extension_lang AS extension_name FILE STRING /*14N*/
	;

extension_lang :
	ident
	;

extension_name :
	ident
	;

create_procedure_stmt :
	CREATE PROCEDURE proc_name '(' /*11R*/ proc_args_list_opt ')' /*12L*/ STRING /*14N*/
	;

proc_name :
	ident
	| ident '.' /*35N*/ ident
	;

proc_args_list_opt :
	/*empty*/
	| proc_args_list
	;

proc_args_list :
	proc_arg
	| proc_args_list ',' /*35N*/ proc_arg
	;

proc_arg :
	proc_arg_decl
	;

proc_arg_decl :
	proc_arg_in_out_type column_name column_type
	;

proc_arg_in_out_type :
	/*empty*/
	| IN /*24L*/
	| OUT
	| INOUT
	;

create_function_stmt :
	CREATE FUNCTION func_name '(' /*11R*/ func_args_list_opt ')' /*12L*/ RETURNS func_return LANGUAGE func_lang AS STRING /*14N*/
	;

func_name :
	ident
	| ident '.' /*35N*/ ident
	;

func_args_list_opt :
	/*empty*/
	| func_args_list
	;

func_args_list :
	func_arg
	| func_args_list ',' /*35N*/ func_arg
	;

func_arg :
	func_arg_decl
	;

func_arg_decl :
	column_type
	| column_name column_type
	| column_name column_type DEFAULT literal
	;

func_lang :
	ident
	;

func_return :
	column_type
	;

create_view_stmt :
	CREATE view_list_opt VIEW not_exists_opt table_name column_list_opt AS select_stmt view_tail
	| CREATE replace_opt VIEW not_exists_opt table_name column_list_opt AS select_stmt view_tail
	;

create_account_stmt :
	CREATE ACCOUNT not_exists_opt account_name account_auth_option account_status_option account_comment_opt
	;

view_list_opt :
	view_opt
	| view_list_opt view_opt
	;

view_opt :
	ALGORITHM '=' /*24L*/ algorithm_type_2
	| DEFINER '=' /*24L*/ user_name
	| SQL SECURITY security_opt
	;

view_tail :
	/*empty*/
	| WITH check_type CHECK OPTION
	;

algorithm_type_2 :
	UNDEFINED
	| MERGE
	| TEMPTABLE
	;

security_opt :
	DEFINER
	| INVOKER
	;

check_type :
	/*empty*/
	| CASCADED
	| LOCAL
	;

account_name :
	ident
	;

account_auth_option :
	ADMIN_NAME equal_opt account_admin_name account_identified
	;

account_admin_name :
	STRING /*14N*/
	| ident
	;

account_identified :
	IDENTIFIED BY STRING /*14N*/
	| IDENTIFIED BY RANDOM PASSWORD
	| IDENTIFIED WITH STRING /*14N*/
	;

account_status_option :
	/*empty*/
	| OPEN
	| SUSPEND
	| RESTRICTED
	;

account_comment_opt :
	/*empty*/
	| COMMENT_KEYWORD /*14N*/ STRING /*14N*/
	;

create_user_stmt :
	CREATE USER not_exists_opt user_spec_list_of_create_user default_role_opt pwd_or_lck_opt user_comment_or_attribute_opt
	;

create_publication_stmt :
	CREATE PUBLICATION not_exists_opt ident DATABASE ident alter_publication_accounts_opt comment_opt
	;

create_stage_stmt :
	CREATE STAGE /*14N*/ not_exists_opt ident urlparams stage_credentials_opt stage_status_opt stage_comment_opt
	;

stage_status_opt :
	/*empty*/
	| ENABLE '=' /*24L*/ TRUE
	| ENABLE '=' /*24L*/ FALSE
	;

stage_comment_opt :
	/*empty*/
	| COMMENT_KEYWORD /*14N*/ STRING /*14N*/
	;

stage_url_opt :
	/*empty*/
	| URL '=' /*24L*/ STRING /*14N*/
	;

stage_credentials_opt :
	/*empty*/
	| CREDENTIALS /*14N*/ '=' /*24L*/ '{' credentialsparams '}'
	;

credentialsparams :
	credentialsparam
	| credentialsparams ',' /*35N*/ credentialsparam
	;

credentialsparam :
	/*empty*/
	| STRING /*14N*/ '=' /*24L*/ STRING /*14N*/
	;

urlparams :
	URL '=' /*24L*/ STRING /*14N*/
	;

comment_opt :
	/*empty*/
	| COMMENT_KEYWORD /*14N*/ STRING /*14N*/
	;

alter_stage_stmt :
	ALTER STAGE /*14N*/ exists_opt ident SET /*6N*/ stage_url_opt stage_credentials_opt stage_status_opt stage_comment_opt
	;

alter_publication_stmt :
	ALTER PUBLICATION exists_opt ident alter_publication_accounts_opt comment_opt
	;

alter_publication_accounts_opt :
	/*empty*/
	| ACCOUNT ALL
	| ACCOUNT accounts_list
	| ACCOUNT ADD accounts_list
	| ACCOUNT DROP accounts_list
	;

drop_publication_stmt :
	DROP PUBLICATION exists_opt ident
	;

drop_stage_stmt :
	DROP STAGE /*14N*/ exists_opt ident
	;

account_role_name :
	ident
	;

user_comment_or_attribute_opt :
	/*empty*/
	| COMMENT_KEYWORD /*14N*/ STRING /*14N*/
	| ATTRIBUTE STRING /*14N*/
	;

user_spec_list_of_create_user :
	user_spec_with_identified
	| user_spec_list_of_create_user ',' /*35N*/ user_spec_with_identified
	;

user_spec_with_identified :
	user_name user_identified
	;

user_spec_list :
	user_spec
	| user_spec_list ',' /*35N*/ user_spec
	;

user_spec :
	user_name user_identified_opt
	;

user_name :
	name_string
	| name_string '@' name_string
	| name_string AT_ID /*14N*/
	;

user_identified_opt :
	/*empty*/
	| user_identified
	;

user_identified :
	IDENTIFIED BY STRING /*14N*/
	| IDENTIFIED BY RANDOM PASSWORD
	| IDENTIFIED WITH STRING /*14N*/
	;

name_string :
	ident
	| STRING /*14N*/
	;

create_role_stmt :
	CREATE ROLE not_exists_opt role_spec_list
	;

role_spec_list :
	role_spec
	| role_spec_list ',' /*35N*/ role_spec
	;

role_spec :
	role_name
	;

role_name :
	ID /*14N*/
	| QUOTE_ID /*14N*/
	| STRING /*14N*/
	;

index_prefix :
	/*empty*/
	| FULLTEXT
	| SPATIAL
	| UNIQUE /*17R*/
	;

create_index_stmt :
	CREATE index_prefix INDEX ident using_opt ON /*9N*/ table_name '(' /*11R*/ index_column_list ')' /*12L*/ index_option_list
	;

index_option_list :
	/*empty*/
	| index_option_list index_option
	;

index_option :
	KEY_BLOCK_SIZE equal_opt INTEGRAL
	| COMMENT_KEYWORD /*14N*/ STRING /*14N*/
	| WITH PARSER ident
	| VISIBLE
	| INVISIBLE
	;

index_column_list :
	index_column
	| index_column_list ',' /*35N*/ index_column
	;

index_column :
	column_name length_opt asc_desc_opt
	| '(' /*11R*/ expression ')' /*12L*/ asc_desc_opt
	;

using_opt :
	/*empty*/
	| USING /*9N*/ BTREE
	| USING /*9N*/ HASH
	| USING /*9N*/ RTREE
	| USING /*9N*/ BSI
	;

create_database_stmt :
	CREATE database_or_schema not_exists_opt ident subcription_opt create_option_list_opt
	;

subcription_opt :
	/*empty*/
	| FROM account_name PUBLICATION ident
	;

database_or_schema :
	DATABASE
	| SCHEMA
	;

not_exists_opt :
	/*empty*/
	| IF NOT /*21R*/ EXISTS
	;

create_option_list_opt :
	/*empty*/
	| create_option_list
	;

create_option_list :
	create_option
	| create_option_list create_option
	;

create_option :
	default_opt charset_keyword equal_opt charset_name
	| default_opt COLLATE /*32L*/ equal_opt collate_name
	| default_opt ENCRYPTION equal_opt STRING /*14N*/
	;

default_opt :
	/*empty*/
	| DEFAULT
	;

create_connector_stmt :
	CREATE CONNECTOR FOR table_name WITH '(' /*11R*/ connector_option_list ')' /*12L*/
	;

show_connectors_stmt :
	SHOW CONNECTORS
	;

pause_daemon_task_stmt :
	PAUSE DAEMON TASK INTEGRAL
	;

cancel_daemon_task_stmt :
	CANCEL DAEMON TASK INTEGRAL
	;

resume_daemon_task_stmt :
	RESUME DAEMON TASK INTEGRAL
	;

create_stream_stmt :
	CREATE replace_opt STREAM not_exists_opt table_name '(' /*11R*/ table_elem_list_opt ')' /*12L*/ stream_option_list_opt
	| CREATE replace_opt SOURCE STREAM not_exists_opt table_name '(' /*11R*/ table_elem_list_opt ')' /*12L*/ stream_option_list_opt
	| CREATE replace_opt STREAM not_exists_opt table_name stream_option_list_opt AS select_stmt
	;

replace_opt :
	/*empty*/
	| OR /*18L*/ REPLACE
	;

create_table_stmt :
	CREATE temporary_opt TABLE not_exists_opt table_name '(' /*11R*/ table_elem_list_opt ')' /*12L*/ table_option_list_opt partition_by_opt cluster_by_opt
	| CREATE EXTERNAL TABLE not_exists_opt table_name '(' /*11R*/ table_elem_list_opt ')' /*12L*/ load_param_opt_2
	| CREATE CLUSTER TABLE not_exists_opt table_name '(' /*11R*/ table_elem_list_opt ')' /*12L*/ table_option_list_opt partition_by_opt cluster_by_opt
	;

load_param_opt_2 :
	load_param_opt tail_param_opt
	;

load_param_opt :
	INFILE STRING /*14N*/
	| INLINE FORMAT '=' /*24L*/ STRING /*14N*/ ',' /*35N*/ DATA '=' /*24L*/ STRING /*14N*/
	| INFILE '{' infile_or_s3_params '}'
	| URL S3OPTION '{' infile_or_s3_params '}'
	;

infile_or_s3_params :
	infile_or_s3_param
	| infile_or_s3_params ',' /*35N*/ infile_or_s3_param
	;

infile_or_s3_param :
	/*empty*/
	| STRING /*14N*/ '=' /*24L*/ STRING /*14N*/
	;

tail_param_opt :
	load_fields load_lines ignore_lines columns_or_variable_list_opt load_set_spec_opt
	;

create_sequence_stmt :
	CREATE SEQUENCE not_exists_opt table_name as_datatype_opt increment_by_opt min_value_opt max_value_opt start_with_opt cycle_opt
	;

as_datatype_opt :
	/*empty*/
	| AS column_type
	;

alter_as_datatype_opt :
	/*empty*/
	| AS column_type
	;

increment_by_opt :
	/*empty*/
	| INCREMENT BY INTEGRAL
	| INCREMENT INTEGRAL
	| INCREMENT BY '-' /*28L*/ INTEGRAL
	| INCREMENT '-' /*28L*/ INTEGRAL
	;

cycle_opt :
	/*empty*/
	| NO CYCLE
	| CYCLE
	;

min_value_opt :
	/*empty*/
	| MINVALUE INTEGRAL
	| MINVALUE '-' /*28L*/ INTEGRAL
	;

max_value_opt :
	/*empty*/
	| MAXVALUE INTEGRAL
	| MAXVALUE '-' /*28L*/ INTEGRAL
	;

alter_cycle_opt :
	/*empty*/
	| NO CYCLE
	| CYCLE
	;

start_with_opt :
	/*empty*/
	| START WITH INTEGRAL
	| START INTEGRAL
	| START WITH '-' /*28L*/ INTEGRAL
	| START '-' /*28L*/ INTEGRAL
	;

temporary_opt :
	/*empty*/
	| TEMPORARY
	;

drop_table_opt :
	/*empty*/
	| RESTRICT
	| CASCADE
	;

partition_by_opt :
	/*empty*/
	| PARTITION BY partition_method partition_num_opt sub_partition_opt partition_list_opt
	;

cluster_by_opt :
	/*empty*/
	| CLUSTER BY column_name
	| CLUSTER BY '(' /*11R*/ column_name_list ')' /*12L*/
	;

sub_partition_opt :
	/*empty*/
	| SUBPARTITION BY sub_partition_method sub_partition_num_opt
	;

partition_list_opt :
	/*empty*/
	| '(' /*11R*/ partition_list ')' /*12L*/
	;

partition_list :
	partition
	| partition_list ',' /*35N*/ partition
	;

partition :
	PARTITION ident values_opt sub_partition_list_opt
	| PARTITION ident values_opt partition_option_list sub_partition_list_opt
	;

sub_partition_list_opt :
	/*empty*/
	| '(' /*11R*/ sub_partition_list ')' /*12L*/
	;

sub_partition_list :
	sub_partition
	| sub_partition_list ',' /*35N*/ sub_partition
	;

sub_partition :
	SUBPARTITION ident
	| SUBPARTITION ident partition_option_list
	;

partition_option_list :
	table_option
	| partition_option_list table_option
	;

values_opt :
	/*empty*/
	| VALUES LESS THAN MAXVALUE
	| VALUES LESS THAN '(' /*11R*/ expression_list ')' /*12L*/
	| VALUES IN /*24L*/ '(' /*11R*/ expression_list ')' /*12L*/
	;

sub_partition_num_opt :
	/*empty*/
	| SUBPARTITIONS INTEGRAL
	;

partition_num_opt :
	/*empty*/
	| PARTITIONS INTEGRAL
	;

partition_method :
	RANGE '(' /*11R*/ bit_expr ')' /*12L*/
	| RANGE fields_or_columns '(' /*11R*/ column_name_list ')' /*12L*/
	| LIST '(' /*11R*/ bit_expr ')' /*12L*/
	| LIST fields_or_columns '(' /*11R*/ column_name_list ')' /*12L*/
	| sub_partition_method
	;

sub_partition_method :
	linear_opt KEY /*17R*/ algorithm_opt '(' /*11R*/ ')' /*12L*/
	| linear_opt KEY /*17R*/ algorithm_opt '(' /*11R*/ column_name_list ')' /*12L*/
	| linear_opt HASH '(' /*11R*/ bit_expr ')' /*12L*/
	;

algorithm_opt :
	/*empty*/
	| ALGORITHM '=' /*24L*/ INTEGRAL
	;

linear_opt :
	/*empty*/
	| LINEAR
	;

connector_option_list :
	connector_option
	| connector_option_list ',' /*35N*/ connector_option
	;

connector_option :
	ident equal_opt literal
	| STRING /*14N*/ equal_opt literal
	;

stream_option_list_opt :
	/*empty*/
	| WITH '(' /*11R*/ stream_option_list ')' /*12L*/
	;

stream_option_list :
	stream_option
	| stream_option_list ',' /*35N*/ stream_option
	;

stream_option :
	ident equal_opt literal
	| STRING /*14N*/ equal_opt literal
	;

table_option_list_opt :
	/*empty*/
	| table_option_list
	;

table_option_list :
	table_option
	| table_option_list ',' /*35N*/ table_option
	| table_option_list table_option
	;

table_option :
	AUTOEXTEND_SIZE equal_opt INTEGRAL
	| AUTO_INCREMENT equal_opt INTEGRAL
	| AVG_ROW_LENGTH equal_opt INTEGRAL
	| default_opt charset_keyword equal_opt charset_name
	| default_opt COLLATE /*32L*/ equal_opt charset_name
	| CHECKSUM equal_opt INTEGRAL
	| COMMENT_KEYWORD /*14N*/ equal_opt STRING /*14N*/
	| COMPRESSION equal_opt STRING /*14N*/
	| CONNECTION equal_opt STRING /*14N*/
	| DATA DIRECTORY equal_opt STRING /*14N*/
	| INDEX DIRECTORY equal_opt STRING /*14N*/
	| DELAY_KEY_WRITE equal_opt INTEGRAL
	| ENCRYPTION equal_opt STRING /*14N*/
	| ENGINE equal_opt table_alias
	| ENGINE_ATTRIBUTE equal_opt STRING /*14N*/
	| INSERT_METHOD equal_opt insert_method_options
	| KEY_BLOCK_SIZE equal_opt INTEGRAL
	| MAX_ROWS equal_opt INTEGRAL
	| MIN_ROWS equal_opt INTEGRAL
	| PACK_KEYS equal_opt INTEGRAL
	| PACK_KEYS equal_opt DEFAULT
	| PASSWORD equal_opt STRING /*14N*/
	| ROW_FORMAT equal_opt row_format_options
	| START TRANSACTION
	| SECONDARY_ENGINE_ATTRIBUTE equal_opt STRING /*14N*/
	| STATS_AUTO_RECALC equal_opt INTEGRAL
	| STATS_AUTO_RECALC equal_opt DEFAULT
	| STATS_PERSISTENT equal_opt INTEGRAL
	| STATS_PERSISTENT equal_opt DEFAULT
	| STATS_SAMPLE_PAGES equal_opt INTEGRAL
	| STATS_SAMPLE_PAGES equal_opt DEFAULT
	| TABLESPACE equal_opt ident
	| storage_opt
	| UNION /*2L*/ equal_opt '(' /*11R*/ table_name_list ')' /*12L*/
	| PROPERTIES '(' /*11R*/ properties_list ')' /*12L*/
	;

properties_list :
	property_elem
	| properties_list ',' /*35N*/ property_elem
	;

property_elem :
	STRING /*14N*/ '=' /*24L*/ STRING /*14N*/
	;

storage_opt :
	STORAGE DISK
	| STORAGE MEMORY
	;

row_format_options :
	DEFAULT
	| DYNAMIC
	| FIXED
	| COMPRESSED
	| REDUNDANT
	| COMPACT
	;

charset_name :
	name_string
	| BINARY /*33R*/
	;

collate_name :
	name_string
	| BINARY /*33R*/
	;

table_name_list :
	table_name
	| table_name_list ',' /*35N*/ table_name
	;

table_name :
	ident
	| ident '.' /*35N*/ ident
	;

table_elem_list_opt :
	/*empty*/
	| table_elem_list
	;

table_elem_list :
	table_elem
	| table_elem_list ',' /*35N*/ table_elem
	;

table_elem :
	column_def
	| constaint_def
	| index_def
	;

table_elem_2 :
	constaint_def
	| index_def
	;

index_def :
	FULLTEXT key_or_index_opt index_name '(' /*11R*/ index_column_list ')' /*12L*/ index_option_list
	| FULLTEXT key_or_index_opt index_name '(' /*11R*/ index_column_list ')' /*12L*/ USING /*9N*/ index_type index_option_list
	| key_or_index not_exists_opt index_name_and_type_opt '(' /*11R*/ index_column_list ')' /*12L*/ index_option_list
	| key_or_index not_exists_opt index_name_and_type_opt '(' /*11R*/ index_column_list ')' /*12L*/ USING /*9N*/ index_type index_option_list
	;

constaint_def :
	constraint_keyword constraint_elem
	| constraint_elem
	;

constraint_elem :
	PRIMARY KEY /*17R*/ index_name_and_type_opt '(' /*11R*/ index_column_list ')' /*12L*/ index_option_list
	| PRIMARY KEY /*17R*/ index_name_and_type_opt '(' /*11R*/ index_column_list ')' /*12L*/ USING /*9N*/ index_type index_option_list
	| UNIQUE /*17R*/ key_or_index_opt index_name_and_type_opt '(' /*11R*/ index_column_list ')' /*12L*/ index_option_list
	| UNIQUE /*17R*/ key_or_index_opt index_name_and_type_opt '(' /*11R*/ index_column_list ')' /*12L*/ USING /*9N*/ index_type index_option_list
	| FOREIGN KEY /*17R*/ not_exists_opt index_name '(' /*11R*/ index_column_list ')' /*12L*/ references_def
	| CHECK '(' /*11R*/ expression ')' /*12L*/ enforce_opt
	;

enforce_opt :
	/*empty*/
	| enforce
	;

key_or_index_opt :
	/*empty*/
	| key_or_index
	;

key_or_index :
	KEY /*17R*/
	| INDEX
	;

index_name_and_type_opt :
	index_name
	| index_name USING /*9N*/ index_type
	| ident TYPE index_type
	;

index_type :
	BTREE
	| HASH
	| RTREE
	| ZONEMAP
	| BSI
	;

insert_method_options :
	NO
	| FIRST
	| LAST
	;

index_name :
	/*empty*/
	| ident
	;

column_def :
	column_name column_type column_attribute_list_opt
	;

column_name_unresolved :
	ident
	| ident '.' /*35N*/ ident
	| ident '.' /*35N*/ ident '.' /*35N*/ ident
	;

ident :
	ID /*14N*/
	| QUOTE_ID /*14N*/
	| not_keyword
	| non_reserved_keyword
	;

column_name :
	ident
	| ident '.' /*35N*/ ident
	| ident '.' /*35N*/ ident '.' /*35N*/ ident
	;

column_attribute_list_opt :
	/*empty*/
	| column_attribute_list
	;

column_attribute_list :
	column_attribute_elem
	| column_attribute_list column_attribute_elem
	;

column_attribute_elem :
	NULL
	| NOT /*21R*/ NULL
	| DEFAULT bit_expr
	| AUTO_INCREMENT
	| keys
	| COMMENT_KEYWORD /*14N*/ STRING /*14N*/
	| COLLATE /*32L*/ collate_name
	| COLUMN_FORMAT column_format
	| SECONDARY_ENGINE_ATTRIBUTE '=' /*24L*/ STRING /*14N*/
	| ENGINE_ATTRIBUTE '=' /*24L*/ STRING /*14N*/
	| STORAGE storage_media
	| AUTO_RANDOM field_length_opt
	| references_def
	| constraint_keyword_opt CHECK '(' /*11R*/ expression ')' /*12L*/
	| constraint_keyword_opt CHECK '(' /*11R*/ expression ')' /*12L*/ enforce
	| ON /*9N*/ UPDATE name_datetime_scale datetime_scale_opt
	| LOW_CARDINALITY
	| VISIBLE
	| INVISIBLE
	| default_opt CHARACTER SET /*6N*/ equal_opt ident
	| HEADER '(' /*11R*/ STRING /*14N*/ ')' /*12L*/
	| HEADERS
	;

enforce :
	ENFORCED
	| NOT /*21R*/ ENFORCED
	;

constraint_keyword_opt :
	/*empty*/
	| constraint_keyword
	;

constraint_keyword :
	CONSTRAINT
	| CONSTRAINT ident
	;

references_def :
	REFERENCES table_name index_column_list_opt match_opt on_delete_update_opt
	;

on_delete_update_opt :
	%prec LOWER_THAN_ON /*8N*/ /*empty*/
	| on_delete %prec LOWER_THAN_ON /*8N*/
	| on_update %prec LOWER_THAN_ON /*8N*/
	| on_delete on_update
	| on_update on_delete
	;

on_delete :
	ON /*9N*/ DELETE ref_opt
	;

on_update :
	ON /*9N*/ UPDATE ref_opt
	;

ref_opt :
	RESTRICT
	| CASCADE
	| SET /*6N*/ NULL
	| NO ACTION
	| SET /*6N*/ DEFAULT
	;

match_opt :
	/*empty*/
	| match
	;

match :
	MATCH FULL
	| MATCH PARTIAL
	| MATCH SIMPLE
	;

index_column_list_opt :
	/*empty*/
	| '(' /*11R*/ index_column_list ')' /*12L*/
	;

field_length_opt :
	/*empty*/
	| '(' /*11R*/ INTEGRAL ')' /*12L*/
	;

storage_media :
	DEFAULT
	| DISK
	| MEMORY
	;

column_format :
	DEFAULT
	| FIXED
	| DYNAMIC
	;

subquery :
	select_with_parens %prec SUBQUERY_AS_EXPR /*10L*/
	;

bit_expr :
	bit_expr '&' /*26L*/ bit_expr %prec '&' /*26L*/
	| bit_expr '|' /*25L*/ bit_expr %prec '|' /*25L*/
	| bit_expr '^' /*30L*/ bit_expr %prec '^' /*30L*/
	| bit_expr '+' /*28L*/ bit_expr %prec '+' /*28L*/
	| bit_expr '-' /*28L*/ bit_expr %prec '-' /*28L*/
	| bit_expr '*' /*29L*/ bit_expr %prec '*' /*29L*/
	| bit_expr '/' /*29L*/ bit_expr %prec '/' /*29L*/
	| bit_expr DIV /*29L*/ bit_expr %prec DIV /*29L*/
	| bit_expr '%' /*29L*/ bit_expr %prec '%' /*29L*/
	| bit_expr MOD /*29L*/ bit_expr %prec MOD /*29L*/
	| bit_expr SHIFT_LEFT /*27L*/ bit_expr %prec SHIFT_LEFT /*27L*/
	| bit_expr SHIFT_RIGHT /*27L*/ bit_expr %prec SHIFT_RIGHT /*27L*/
	| simple_expr
	;

simple_expr :
	normal_ident
	| variable
	| literal
	| '(' /*11R*/ expression ')' /*12L*/
	| '(' /*11R*/ expression_list ',' /*35N*/ expression ')' /*12L*/
	| '+' /*28L*/ simple_expr %prec UNARY /*31R*/
	| '-' /*28L*/ simple_expr %prec UNARY /*31R*/
	| '~' /*31R*/ simple_expr
	| '!' /*21R*/ simple_expr %prec UNARY /*31R*/
	| interval_expr
	| subquery
	| EXISTS subquery
	| CASE /*22L*/ expression_opt when_clause_list else_opt END /*22L*/
	| CAST '(' /*11R*/ expression AS mo_cast_type ')' /*12L*/
	| BIT_CAST '(' /*11R*/ expression AS mo_cast_type ')' /*12L*/
	| CONVERT '(' /*11R*/ expression ',' /*35N*/ mysql_cast_type ')' /*12L*/
	| CONVERT '(' /*11R*/ expression USING /*9N*/ charset_name ')' /*12L*/
	| function_call_generic
	| function_call_keyword
	| function_call_nonkeyword
	| function_call_aggregate
	| function_call_window
	;

function_call_window :
	RANK '(' /*11R*/ ')' /*12L*/ window_spec
	| ROW_NUMBER '(' /*11R*/ ')' /*12L*/ window_spec
	| DENSE_RANK '(' /*11R*/ ')' /*12L*/ window_spec
	;

else_opt :
	/*empty*/
	| ELSE /*22L*/ expression
	;

expression_opt :
	/*empty*/
	| expression
	;

when_clause_list :
	when_clause
	| when_clause_list when_clause
	;

when_clause :
	WHEN /*22L*/ expression THEN /*22L*/ expression
	;

mo_cast_type :
	column_type
	| SIGNED integer_opt
	| UNSIGNED integer_opt
	;

mysql_cast_type :
	decimal_type
	| BINARY /*33R*/ length_option_opt
	| CHAR length_option_opt
	| DATE
	| YEAR length_opt
	| DATETIME timestamp_option_opt
	| TIME length_opt
	| SIGNED integer_opt
	| UNSIGNED integer_opt
	;

integer_opt :
	/*empty*/
	| INTEGER
	| INT
	;

frame_bound :
	frame_bound_start
	| UNBOUNDED FOLLOWING
	| num_literal FOLLOWING
	| interval_expr FOLLOWING
	;

frame_bound_start :
	CURRENT ROW
	| UNBOUNDED PRECEDING
	| num_literal PRECEDING
	| interval_expr PRECEDING
	;

frame_type :
	ROWS
	| RANGE
	| GROUPS
	;

window_frame_clause :
	frame_type frame_bound_start
	| frame_type BETWEEN /*22L*/ frame_bound AND /*20L*/ frame_bound
	;

window_frame_clause_opt :
	/*empty*/
	| window_frame_clause
	;

window_partition_by :
	PARTITION BY expression_list
	;

window_partition_by_opt :
	/*empty*/
	| window_partition_by
	;

separator_opt :
	/*empty*/
	| SEPARATOR STRING /*14N*/
	;

window_spec_opt :
	/*empty*/
	| window_spec
	;

window_spec :
	OVER '(' /*11R*/ window_partition_by_opt order_by_opt window_frame_clause_opt ')' /*12L*/
	;

function_call_aggregate :
	GROUP_CONCAT '(' /*11R*/ func_type_opt expression_list order_by_opt separator_opt ')' /*12L*/ window_spec_opt
	| AVG '(' /*11R*/ func_type_opt expression ')' /*12L*/ window_spec_opt
	| APPROX_COUNT '(' /*11R*/ func_type_opt expression_list ')' /*12L*/ window_spec_opt
	| APPROX_COUNT '(' /*11R*/ '*' /*29L*/ ')' /*12L*/ window_spec_opt
	| APPROX_COUNT_DISTINCT '(' /*11R*/ expression_list ')' /*12L*/ window_spec_opt
	| APPROX_PERCENTILE '(' /*11R*/ expression_list ')' /*12L*/ window_spec_opt
	| BIT_AND '(' /*11R*/ func_type_opt expression ')' /*12L*/ window_spec_opt
	| BIT_OR '(' /*11R*/ func_type_opt expression ')' /*12L*/ window_spec_opt
	| BIT_XOR '(' /*11R*/ func_type_opt expression ')' /*12L*/ window_spec_opt
	| COUNT '(' /*11R*/ func_type_opt expression_list ')' /*12L*/ window_spec_opt
	| COUNT '(' /*11R*/ '*' /*29L*/ ')' /*12L*/ window_spec_opt
	| MAX '(' /*11R*/ func_type_opt expression ')' /*12L*/ window_spec_opt
	| MIN '(' /*11R*/ func_type_opt expression ')' /*12L*/ window_spec_opt
	| SUM '(' /*11R*/ func_type_opt expression ')' /*12L*/ window_spec_opt
	| std_dev_pop '(' /*11R*/ func_type_opt expression ')' /*12L*/ window_spec_opt
	| STDDEV_SAMP '(' /*11R*/ func_type_opt expression ')' /*12L*/ window_spec_opt
	| VAR_POP '(' /*11R*/ func_type_opt expression ')' /*12L*/ window_spec_opt
	| VAR_SAMP '(' /*11R*/ func_type_opt expression ')' /*12L*/ window_spec_opt
	| MEDIAN '(' /*11R*/ func_type_opt expression ')' /*12L*/ window_spec_opt
	;

std_dev_pop :
	STD
	| STDDEV
	| STDDEV_POP
	;

function_call_generic :
	ID /*14N*/ '(' /*11R*/ expression_list_opt ')' /*12L*/
	| substr_option '(' /*11R*/ expression_list_opt ')' /*12L*/
	| substr_option '(' /*11R*/ expression FROM expression ')' /*12L*/
	| substr_option '(' /*11R*/ expression FROM expression FOR expression ')' /*12L*/
	| EXTRACT '(' /*11R*/ time_unit FROM expression ')' /*12L*/
	| func_not_keyword '(' /*11R*/ expression_list_opt ')' /*12L*/
	| VARIANCE '(' /*11R*/ func_type_opt expression ')' /*12L*/
	| NEXTVAL '(' /*11R*/ expression_list ')' /*12L*/
	| SETVAL '(' /*11R*/ expression_list ')' /*12L*/
	| CURRVAL '(' /*11R*/ expression_list ')' /*12L*/
	| LASTVAL '(' /*11R*/ ')' /*12L*/
	| TRIM '(' /*11R*/ expression ')' /*12L*/
	| TRIM '(' /*11R*/ expression FROM expression ')' /*12L*/
	| TRIM '(' /*11R*/ trim_direction FROM expression ')' /*12L*/
	| TRIM '(' /*11R*/ trim_direction expression FROM expression ')' /*12L*/
	| VALUES '(' /*11R*/ insert_column ')' /*12L*/
	;

trim_direction :
	BOTH
	| LEADING
	| TRAILING
	;

substr_option :
	SUBSTRING
	| SUBSTR
	| MID
	;

time_unit :
	time_stamp_unit
	| SECOND_MICROSECOND
	| MINUTE_MICROSECOND
	| MINUTE_SECOND
	| HOUR_MICROSECOND
	| HOUR_SECOND
	| HOUR_MINUTE
	| DAY_MICROSECOND
	| DAY_SECOND
	| DAY_MINUTE
	| DAY_HOUR
	| YEAR_MONTH
	;

time_stamp_unit :
	MICROSECOND
	| SECOND
	| MINUTE
	| HOUR
	| DAY
	| WEEK
	| MONTH
	| QUARTER
	| YEAR
	| SQL_TSI_SECOND
	| SQL_TSI_MINUTE
	| SQL_TSI_HOUR
	| SQL_TSI_DAY
	| SQL_TSI_WEEK
	| SQL_TSI_MONTH
	| SQL_TSI_QUARTER
	| SQL_TSI_YEAR
	;

function_call_nonkeyword :
	CURTIME datetime_scale
	| SYSDATE datetime_scale
	| TIMESTAMPDIFF '(' /*11R*/ time_stamp_unit ',' /*35N*/ expression ',' /*35N*/ expression ')' /*12L*/
	;

function_call_keyword :
	name_confict '(' /*11R*/ expression_list_opt ')' /*12L*/
	| name_braces braces_opt
	| SCHEMA '(' /*11R*/ ')' /*12L*/
	| name_datetime_scale datetime_scale_opt
	| BINARY /*33R*/ '(' /*11R*/ expression_list ')' /*12L*/
	| BINARY /*33R*/ literal
	| BINARY /*33R*/ column_name
	| CHAR '(' /*11R*/ expression_list ')' /*12L*/
	| CHAR '(' /*11R*/ expression_list USING /*9N*/ charset_name ')' /*12L*/
	| DATE STRING /*14N*/
	| TIME STRING /*14N*/
	| INSERT '(' /*11R*/ expression_list_opt ')' /*12L*/
	| MOD /*29L*/ '(' /*11R*/ bit_expr ',' /*35N*/ bit_expr ')' /*12L*/
	| PASSWORD '(' /*11R*/ expression_list_opt ')' /*12L*/
	| TIMESTAMP STRING /*14N*/
	;

datetime_scale_opt :
	/*empty*/
	| datetime_scale
	;

datetime_scale :
	'(' /*11R*/ ')' /*12L*/
	| '(' /*11R*/ INTEGRAL ')' /*12L*/
	;

name_datetime_scale :
	CURRENT_TIME
	| CURRENT_TIMESTAMP
	| LOCALTIME
	| LOCALTIMESTAMP
	| UTC_TIME
	| UTC_TIMESTAMP
	;

braces_opt :
	/*empty*/
	| '(' /*11R*/ ')' /*12L*/
	;

name_braces :
	CURRENT_USER
	| CURRENT_DATE
	| CURRENT_ROLE
	| UTC_DATE
	;

name_confict :
	ASCII
	| CHARSET /*16N*/
	| COALESCE
	| COLLATION
	| DATE
	| DATABASE
	| DAY
	| HOUR
	| IF
	| INTERVAL /*34R*/
	| FORMAT
	| LEFT /*7L*/
	| MICROSECOND
	| MINUTE
	| MONTH
	| QUARTER
	| REPEAT
	| REPLACE
	| REVERSE
	| RIGHT /*7L*/
	| ROW_COUNT
	| SECOND
	| TIME
	| TIMESTAMP
	| TRUNCATE
	| USER
	| WEEK
	| YEAR
	| UUID
	;

interval_expr :
	INTERVAL /*34R*/ expression time_unit
	;

func_type_opt :
	/*empty*/
	| DISTINCT
	| ALL
	;

tuple_expression :
	'(' /*11R*/ expression_list ')' /*12L*/
	;

expression_list_opt :
	/*empty*/
	| expression_list
	;

expression_list :
	expression
	| expression_list ',' /*35N*/ expression
	;

expression :
	expression AND /*20L*/ expression %prec AND /*20L*/
	| expression OR /*18L*/ expression %prec OR /*18L*/
	| expression PIPE_CONCAT /*18L*/ expression %prec PIPE_CONCAT /*18L*/
	| expression XOR /*19L*/ expression %prec XOR /*19L*/
	| NOT /*21R*/ expression %prec NOT /*21R*/
	| MAXVALUE
	| boolean_primary
	;

boolean_primary :
	boolean_primary IS /*24L*/ NULL %prec IS /*24L*/
	| boolean_primary IS /*24L*/ NOT /*21R*/ NULL %prec IS /*24L*/
	| boolean_primary IS /*24L*/ UNKNOWN %prec IS /*24L*/
	| boolean_primary IS /*24L*/ NOT /*21R*/ UNKNOWN %prec IS /*24L*/
	| boolean_primary IS /*24L*/ TRUE %prec IS /*24L*/
	| boolean_primary IS /*24L*/ NOT /*21R*/ TRUE %prec IS /*24L*/
	| boolean_primary IS /*24L*/ FALSE %prec IS /*24L*/
	| boolean_primary IS /*24L*/ NOT /*21R*/ FALSE %prec IS /*24L*/
	| boolean_primary comparison_operator predicate %prec '=' /*24L*/
	| boolean_primary comparison_operator and_or_some subquery %prec '=' /*24L*/
	| predicate
	;

predicate :
	bit_expr IN /*24L*/ col_tuple
	| bit_expr NOT /*21R*/ IN /*24L*/ col_tuple
	| bit_expr LIKE /*24L*/ simple_expr like_escape_opt
	| bit_expr NOT /*21R*/ LIKE /*24L*/ simple_expr like_escape_opt
	| bit_expr ILIKE /*24L*/ simple_expr like_escape_opt
	| bit_expr NOT /*21R*/ ILIKE /*24L*/ simple_expr like_escape_opt
	| bit_expr REGEXP /*24L*/ bit_expr
	| bit_expr NOT /*21R*/ REGEXP /*24L*/ bit_expr
	| bit_expr BETWEEN /*22L*/ bit_expr AND /*20L*/ predicate
	| bit_expr NOT /*21R*/ BETWEEN /*22L*/ bit_expr AND /*20L*/ predicate
	| bit_expr
	;

like_escape_opt :
	/*empty*/
	| ESCAPE simple_expr
	;

col_tuple :
	tuple_expression
	| subquery
	;

and_or_some :
	ALL
	| ANY
	| SOME
	;

comparison_operator :
	'=' /*24L*/
	| '<' /*24L*/
	| '>' /*24L*/
	| LE /*24L*/
	| GE /*24L*/
	| NE /*24L*/
	| NULL_SAFE_EQUAL /*24L*/
	;

keys :
	PRIMARY KEY /*17R*/
	| UNIQUE /*17R*/ KEY /*17R*/
	| UNIQUE /*17R*/
	| KEY /*17R*/
	;

num_literal :
	INTEGRAL
	| FLOAT
	| DECIMAL_VALUE
	;

literal :
	STRING /*14N*/
	| INTEGRAL
	| FLOAT
	| TRUE
	| FALSE
	| NULL
	| HEXNUM
	| UNDERSCORE_BINARY /*33R*/ HEXNUM
	| DECIMAL_VALUE
	| BIT_LITERAL
	| VALUE_ARG /*14N*/
	| UNDERSCORE_BINARY /*33R*/ STRING /*14N*/
	;

column_type :
	numeric_type unsigned_opt zero_fill_opt
	| char_type
	| time_type
	| spatial_type
	;

numeric_type :
	int_type length_opt
	| decimal_type
	;

int_type :
	BIT
	| BOOL
	| BOOLEAN
	| INT1
	| TINYINT
	| INT2
	| SMALLINT
	| INT3
	| MEDIUMINT
	| INT4
	| INT
	| INTEGER
	| INT8
	| BIGINT
	;

decimal_type :
	DOUBLE float_length_opt
	| FLOAT_TYPE float_length_opt
	| DECIMAL decimal_length_opt
	| NUMERIC decimal_length_opt
	| REAL float_length_opt
	;

time_type :
	DATE
	| TIME timestamp_option_opt
	| TIMESTAMP timestamp_option_opt
	| DATETIME timestamp_option_opt
	| YEAR length_opt
	;

char_type :
	CHAR length_option_opt
	| VARCHAR length_option_opt
	| BINARY /*33R*/ length_option_opt
	| VARBINARY length_option_opt
	| TEXT
	| TINYTEXT
	| MEDIUMTEXT
	| LONGTEXT
	| BLOB
	| TINYBLOB
	| MEDIUMBLOB
	| LONGBLOB
	| JSON
	| VECF32 length_option_opt
	| VECF64 length_option_opt
	| ENUM '(' /*11R*/ enum_values ')' /*12L*/
	| SET /*6N*/ '(' /*11R*/ enum_values ')' /*12L*/
	| UUID
	;

do_stmt :
	DO expression_list
	;

declare_stmt :
	DECLARE var_name_list column_type
	| DECLARE var_name_list column_type DEFAULT expression
	;

spatial_type :
	GEOMETRY
	;

enum_values :
	STRING /*14N*/
	| enum_values ',' /*35N*/ STRING /*14N*/
	;

length_opt :
	/*empty*/
	| length
	;

timestamp_option_opt :
	/*empty*/
	| '(' /*11R*/ INTEGRAL ')' /*12L*/
	;

length_option_opt :
	/*empty*/
	| '(' /*11R*/ INTEGRAL ')' /*12L*/
	;

length :
	'(' /*11R*/ INTEGRAL ')' /*12L*/
	;

float_length_opt :
	/*empty*/
	| '(' /*11R*/ INTEGRAL ')' /*12L*/
	| '(' /*11R*/ INTEGRAL ',' /*35N*/ INTEGRAL ')' /*12L*/
	;

decimal_length_opt :
	/*empty*/
	| '(' /*11R*/ INTEGRAL ')' /*12L*/
	| '(' /*11R*/ INTEGRAL ',' /*35N*/ INTEGRAL ')' /*12L*/
	;

unsigned_opt :
	/*empty*/
	| UNSIGNED
	| SIGNED
	;

zero_fill_opt :
	/*empty*/
	| ZEROFILL
	;

charset_keyword :
	CHARSET /*16N*/
	| CHARACTER SET /*6N*/
	| CHAR SET /*6N*/
	;

equal_opt :
	/*empty*/
	| '=' /*24L*/
	;

non_reserved_keyword :
	ACCOUNT
	| ACCOUNTS
	| AGAINST
	| AVG_ROW_LENGTH
	| AUTO_RANDOM
	| ATTRIBUTE
	| ACTION
	| ALGORITHM
	| BEGIN
	| BIGINT
	| BIT
	| BLOB
	| BOOL
	| CANCEL
	| CHAIN
	| CHECKSUM
	| CLUSTER
	| COMPRESSION
	| COMMENT_KEYWORD /*14N*/
	| COMMIT
	| COMMITTED
	| CHARSET /*16N*/
	| COLUMNS
	| CONNECTION
	| CONSISTENT
	| COMPRESSED
	| COMPACT
	| COLUMN_FORMAT
	| CONNECTOR
	| CONNECTORS
	| SECONDARY_ENGINE_ATTRIBUTE
	| ENGINE_ATTRIBUTE
	| INSERT_METHOD
	| CASCADE
	| DAEMON
	| DATA
	| DAY
	| DATETIME
	| DECIMAL
	| DYNAMIC
	| DISK
	| DO
	| DOUBLE
	| DIRECTORY
	| DUPLICATE
	| DELAY_KEY_WRITE
	| ENUM
	| ENCRYPTION
	| ENGINE
	| EXPANSION
	| EXTENDED
	| EXPIRE
	| ERRORS
	| ENFORCED
	| FORMAT
	| FLOAT_TYPE
	| FULL
	| FIXED
	| FIELDS
	| GEOMETRY
	| GEOMETRYCOLLECTION
	| GLOBAL
	| PERSIST
	| GRANT
	| INT
	| INTEGER
	| INDEXES
	| ISOLATION
	| JSON
	| VECF32
	| VECF64
	| KEY_BLOCK_SIZE
	| KEYS
	| LANGUAGE
	| LESS
	| LEVEL
	| LINESTRING
	| LONGBLOB
	| LONGTEXT
	| LOCAL
	| LINEAR
	| LIST
	| MEDIUMBLOB
	| MEDIUMINT
	| MEDIUMTEXT
	| MEMORY
	| MODE
	| MULTILINESTRING
	| MULTIPOINT
	| MULTIPOLYGON
	| MAX_QUERIES_PER_HOUR
	| MAX_UPDATES_PER_HOUR
	| MAX_CONNECTIONS_PER_HOUR
	| MAX_USER_CONNECTIONS
	| MAX_ROWS
	| MIN_ROWS
	| MONTH
	| NAMES
	| NCHAR
	| NUMERIC
	| NEVER
	| NO
	| OFFSET
	| ONLY
	| OPTIMIZE
	| OPEN
	| OPTION
	| PACK_KEYS
	| PARTIAL
	| PARTITIONS
	| POINT
	| POLYGON
	| PROCEDURE
	| PROXY
	| QUERY
	| PAUSE
	| PROFILES
	| ROLE
	| RANGE
	| READ
	| REAL
	| REORGANIZE
	| REDUNDANT
	| REPAIR
	| REPEATABLE
	| RELEASE
	| RESUME
	| REVOKE
	| REPLICATION
	| ROW_FORMAT
	| ROLLBACK
	| RESTRICT
	| SESSION
	| SERIALIZABLE
	| SHARE
	| SIGNED
	| SMALLINT
	| SNAPSHOT
	| SPATIAL
	| START
	| STATUS
	| STORAGE
	| STATS_AUTO_RECALC
	| STATS_PERSISTENT
	| STATS_SAMPLE_PAGES
	| SOURCE
	| SUBPARTITIONS
	| SUBPARTITION
	| SIMPLE
	| TASK
	| TEXT
	| THAN
	| TINYBLOB
	| TIME %prec LOWER_THAN_STRING /*13N*/
	| TINYINT
	| TINYTEXT
	| TRANSACTION
	| TRIGGER
	| UNCOMMITTED
	| UNSIGNED
	| UNUSED
	| UNLOCK
	| USER
	| VARBINARY
	| VARCHAR
	| VARIABLES
	| VIEW
	| WRITE
	| WARNINGS
	| WORK
	| X509
	| ZEROFILL
	| YEAR
	| TYPE
	| HEADER
	| MAX_FILE_SIZE
	| FORCE_QUOTE
	| QUARTER
	| UNKNOWN
	| ANY
	| SOME
	| TIMESTAMP %prec LOWER_THAN_STRING /*13N*/
	| DATE %prec LOWER_THAN_STRING /*13N*/
	| TABLES
	| SEQUENCES
	| URL
	| PASSWORD %prec LOWER_THAN_EQ /*23N*/
	| HASH
	| ENGINES
	| TRIGGERS
	| HISTORY
	| LOW_CARDINALITY
	| S3OPTION
	| EXTENSION
	| NODE
	| ROLES
	| UUID
	| PARALLEL
	| INCREMENT
	| CYCLE
	| MINVALUE
	| PROCESSLIST
	| PUBLICATION
	| SUBSCRIPTIONS
	| PUBLICATIONS
	| PROPERTIES
	| WEEK
	| DEFINER
	| SQL
	| STAGE /*14N*/
	| STAGES /*14N*/
	| BACKUP
	| FILESYSTEM
	;

func_not_keyword :
	DATE_ADD
	| DATE_SUB
	| NOW
	| ADDDATE
	| CURDATE
	| POSITION
	| SESSION_USER
	| SUBDATE
	| SYSTEM_USER
	| TRANSLATE
	;

not_keyword :
	ADDDATE
	| BIT_AND
	| BIT_OR
	| BIT_XOR
	| CAST
	| COUNT
	| APPROX_COUNT
	| APPROX_COUNT_DISTINCT
	| APPROX_PERCENTILE
	| CURDATE
	| CURTIME
	| DATE_ADD
	| DATE_SUB
	| EXTRACT
	| GROUP_CONCAT
	| MAX
	| MID
	| MIN
	| NOW
	| POSITION
	| SESSION_USER
	| STD
	| STDDEV
	| STDDEV_POP
	| STDDEV_SAMP
	| SUBDATE
	| SUBSTR
	| SUBSTRING
	| SUM
	| SYSDATE
	| SYSTEM_USER
	| TRANSLATE
	| TRIM
	| VARIANCE
	| VAR_POP
	| VAR_SAMP
	| AVG
	| TIMESTAMPDIFF
	| NEXTVAL
	| SETVAL
	| CURRVAL
	| LASTVAL
	| HEADERS
	| BIT_CAST
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

"^"	'^'
"~"	'~'
"<"	'<'
"="	'='
">"	'>'
"|"	'|'
"-"	'-'
","	','
";"	';'
":"	':'
"!"	'!'
"/"	'/'
"."	'.'
"("	'('
")"	')'
"{"	'{'
"}"	'}'
"@"	'@'
"*"	'*'
"&"	'&'
"%"	'%'
"+"	'+'

ACCOUNT	ACCOUNT
ACCOUNTS	ACCOUNTS
ACTION	ACTION
ADD	ADD
ADDDATE	ADDDATE
ADMIN_NAME	ADMIN_NAME
AFTER	AFTER
AGAINST	AGAINST
ALGORITHM	ALGORITHM
ALL	ALL
ALTER	ALTER
ANALYZE	ANALYZE
AND	AND
ANY	ANY
APPROX_COUNT	APPROX_COUNT
APPROX_COUNT_DISTINCT	APPROX_COUNT_DISTINCT
APPROX_PERCENTILE	APPROX_PERCENTILE
AS	AS
ASC	ASC
ASCII	ASCII
ASSIGNMENT	ASSIGNMENT
ATTRIBUTE	ATTRIBUTE
AUTOEXTEND_SIZE	AUTOEXTEND_SIZE
AUTO_INCREMENT	AUTO_INCREMENT
AUTO_RANDOM	AUTO_RANDOM
AVG	AVG
AVG_ROW_LENGTH	AVG_ROW_LENGTH
BACKEND	BACKEND
BACKUP	BACKUP
BEGIN	BEGIN
BETWEEN	BETWEEN
BIGINT	BIGINT
BINARY	BINARY
BIT	BIT
BIT_AND	BIT_AND
BIT_CAST	BIT_CAST
BIT_OR	BIT_OR
BIT_XOR	BIT_XOR
BLOB	BLOB
BOOL	BOOL
BOOLEAN	BOOLEAN
BOTH	BOTH
BSI	BSI
BTREE	BTREE
BY	BY
CALL	CALL
CANCEL	CANCEL
CASCADE	CASCADE
CASCADED	CASCADED
CASE	CASE
CAST	CAST
CHAIN	CHAIN
CHANGE	CHANGE
CHAR	CHAR
CHARACTER	CHARACTER
CHARSET	CHARSET
CHECK	CHECK
CHECKSUM	CHECKSUM
CLIENT	CLIENT
CLUSTER	CLUSTER
COALESCE	COALESCE
COLLATE	COLLATE
COLLATION	COLLATION
COLUMN	COLUMN
COLUMN_FORMAT	COLUMN_FORMAT
COLUMN_NUMBER	COLUMN_NUMBER
COLUMNS	COLUMNS
COMMENT_KEYWORD	COMMENT_KEYWORD
COMMIT	COMMIT
COMMITTED	COMMITTED
COMPACT	COMPACT
COMPRESSED	COMPRESSED
COMPRESSION	COMPRESSION
CONFIG	CONFIG
CONNECT	CONNECT
CONNECTION	CONNECTION
CONNECTOR	CONNECTOR
CONNECTORS	CONNECTORS
CONSISTENT	CONSISTENT
CONSTRAINT	CONSTRAINT
CONVERT	CONVERT
COPY	COPY
COUNT	COUNT
CREATE	CREATE
CREDENTIALS	CREDENTIALS
CROSS	CROSS
CURDATE	CURDATE
CURRENT	CURRENT
CURRENT_DATE	CURRENT_DATE
CURRENT_ROLE	CURRENT_ROLE
CURRENT_TIME	CURRENT_TIME
CURRENT_TIMESTAMP	CURRENT_TIMESTAMP
CURRENT_USER	CURRENT_USER
CURRVAL	CURRVAL
CURTIME	CURTIME
CYCLE	CYCLE
DAEMON	DAEMON
DATA	DATA
DATABASE	DATABASE
DATABASES	DATABASES
DATE	DATE
DATE_ADD	DATE_ADD
DATE_SUB	DATE_SUB
DATETIME	DATETIME
DAY	DAY
DAY_HOUR	DAY_HOUR
DAY_MICROSECOND	DAY_MICROSECOND
DAY_MINUTE	DAY_MINUTE
DAY_SECOND	DAY_SECOND
DEALLOCATE	DEALLOCATE
DECIMAL	DECIMAL
DECLARE	DECLARE
DEFAULT	DEFAULT
DEFINER	DEFINER
DELAYED	DELAYED
DELAY_KEY_WRITE	DELAY_KEY_WRITE
DELETE	DELETE
DENSE_RANK	DENSE_RANK
DESC	DESC
DESCRIBE	DESCRIBE
DIRECTORY	DIRECTORY
DISABLE	DISABLE
DISCARD	DISCARD
DISK	DISK
DISTINCT	DISTINCT
DISTINCTROW	DISTINCTROW
DIV	DIV
DO	DO
DOUBLE	DOUBLE
DROP	DROP
DUPLICATE	DUPLICATE
DYNAMIC	DYNAMIC
ELSE	ELSE
ELSEIF	ELSEIF
EMPTY	EMPTY
ENABLE	ENABLE
ENCLOSED	ENCLOSED
ENCRYPTION	ENCRYPTION
END	END
ENFORCED	ENFORCED
ENGINE	ENGINE
ENGINE_ATTRIBUTE	ENGINE_ATTRIBUTE
ENGINES	ENGINES
ENUM	ENUM
ERRORS	ERRORS
ESCAPE	ESCAPE
ESCAPED	ESCAPED
EVENT	EVENT
EVENTS	EVENTS
EXCEPT	EXCEPT
EXCLUSIVE	EXCLUSIVE
EXECUTE	EXECUTE
EXISTS	EXISTS
EXPANSION	EXPANSION
EXPIRE	EXPIRE
EXPLAIN	EXPLAIN
EXTENDED	EXTENDED
EXTENSION	EXTENSION
EXTERNAL	EXTERNAL
EXTRACT	EXTRACT
FAILED_LOGIN_ATTEMPTS	FAILED_LOGIN_ATTEMPTS
FALSE	FALSE
FIELDS	FIELDS
FILE	FILE
FILESYSTEM	FILESYSTEM
FIRST	FIRST
FIXED	FIXED
FLOAT_TYPE	FLOAT_TYPE
FOLLOWING	FOLLOWING
FOR	FOR
FORCE	FORCE
FORCE_QUOTE	FORCE_QUOTE
FOREIGN	FOREIGN
FORMAT	FORMAT
FROM	FROM
FULL	FULL
FULLTEXT	FULLTEXT
FUNCTION	FUNCTION
GE	GE
GEOMETRY	GEOMETRY
GEOMETRYCOLLECTION	GEOMETRYCOLLECTION
GLOBAL	GLOBAL
GRANT	GRANT
GRANTS	GRANTS
GROUP	GROUP
GROUP_CONCAT	GROUP_CONCAT
GROUPS	GROUPS
HASH	HASH
HAVING	HAVING
HEADER	HEADER
HEADERS	HEADERS
HIGH_PRIORITY	HIGH_PRIORITY
HISTORY	HISTORY
HOUR	HOUR
HOUR_MICROSECOND	HOUR_MICROSECOND
HOUR_MINUTE	HOUR_MINUTE
HOUR_SECOND	HOUR_SECOND
IDENTIFIED	IDENTIFIED
IF	IF
IGNORE	IGNORE
ILIKE	ILIKE
IMPORT	IMPORT
IN	IN
INCREMENT	INCREMENT
INDEX	INDEX
INDEXES	INDEXES
INFILE	INFILE
INLINE	INLINE
INNER	INNER
INOUT	INOUT
INPLACE	INPLACE
INSERT	INSERT
INSERT_METHOD	INSERT_METHOD
INSTANT	INSTANT
INT	INT
INT1	INT1
INT2	INT2
INT3	INT3
INT4	INT4
INT8	INT8
INTEGER	INTEGER
INTERSECT	INTERSECT
INTERVAL	INTERVAL
INTO	INTO
INVISIBLE	INVISIBLE
INVOKER	INVOKER
IS	IS
ISOLATION	ISOLATION
ITERATE	ITERATE
JOIN	JOIN
JSON	JSON
KEY	KEY
KEY_BLOCK_SIZE	KEY_BLOCK_SIZE
KEYS	KEYS
KILL	KILL
LANGUAGE	LANGUAGE
LAST	LAST
LASTVAL	LASTVAL
LE	LE
LEADING	LEADING
LEAVE	LEAVE
LEFT	LEFT
LESS	LESS
LEVEL	LEVEL
LIKE	LIKE
LIMIT	LIMIT
LINEAR	LINEAR
LINES	LINES
LINESTRING	LINESTRING
LIST	LIST
LOAD	LOAD
LOCAL	LOCAL
LOCALTIME	LOCALTIME
LOCALTIMESTAMP	LOCALTIMESTAMP
LOCK	LOCK
LOCKS	LOCKS
LONGBLOB	LONGBLOB
LONGTEXT	LONGTEXT
LOOP	LOOP
LOW_CARDINALITY	LOW_CARDINALITY
LOWER_THAN_EQ	LOWER_THAN_EQ
LOWER_THAN_ON	LOWER_THAN_ON
LOWER_THAN_ORDER	LOWER_THAN_ORDER
LOWER_THAN_SET	LOWER_THAN_SET
LOWER_THAN_STRING	LOWER_THAN_STRING
LOW_PRIORITY	LOW_PRIORITY
MANAGE	MANAGE
MATCH	MATCH
MAX	MAX
MAX_CONNECTIONS_PER_HOUR	MAX_CONNECTIONS_PER_HOUR
MAX_FILE_SIZE	MAX_FILE_SIZE
MAX_QUERIES_PER_HOUR	MAX_QUERIES_PER_HOUR
MAX_ROWS	MAX_ROWS
MAX_UPDATES_PER_HOUR	MAX_UPDATES_PER_HOUR
MAX_USER_CONNECTIONS	MAX_USER_CONNECTIONS
MAXVALUE	MAXVALUE
MEDIAN	MEDIAN
MEDIUMBLOB	MEDIUMBLOB
MEDIUMINT	MEDIUMINT
MEDIUMTEXT	MEDIUMTEXT
MEMORY	MEMORY
MERGE	MERGE
MICROSECOND	MICROSECOND
MID	MID
MIN	MIN
MIN_ROWS	MIN_ROWS
MINUS	MINUS
MINUTE	MINUTE
MINUTE_MICROSECOND	MINUTE_MICROSECOND
MINUTE_SECOND	MINUTE_SECOND
MINVALUE	MINVALUE
MOD	MOD
MODE	MODE
MODIFY	MODIFY
MODUMP	MODUMP
MONTH	MONTH
MULTILINESTRING	MULTILINESTRING
MULTIPOINT	MULTIPOINT
MULTIPOLYGON	MULTIPOLYGON
MYSQL_COMPATIBILITY_MODE	MYSQL_COMPATIBILITY_MODE
NAMES	NAMES
NATURAL	NATURAL
NCHAR	NCHAR
NE	NE
NEVER	NEVER
NEXTVAL	NEXTVAL
NO	NO
NODE	NODE
NONE	NONE
NOT	NOT
NOW	NOW
NULL	NULL
NULLS	NULLS
NULL_SAFE_EQUAL	NULL_SAFE_EQUAL
NUMERIC	NUMERIC
OFFSET	OFFSET
ON	ON
ONLY	ONLY
OPEN	OPEN
OPTIMIZE	OPTIMIZE
OPTION	OPTION
OPTIONAL	OPTIONAL
OPTIONALLY	OPTIONALLY
OR	OR
ORDER	ORDER
OUT	OUT
OUTER	OUTER
OUTFILE	OUTFILE
OVER	OVER
OWNERSHIP	OWNERSHIP
PACK_KEYS	PACK_KEYS
PARALLEL	PARALLEL
PARSER	PARSER
PARTIAL	PARTIAL
PARTITION	PARTITION
PARTITIONS	PARTITIONS
PASSWORD	PASSWORD
PASSWORD_LOCK_TIME	PASSWORD_LOCK_TIME
PAUSE	PAUSE
PERSIST	PERSIST
PIPE_CONCAT	PIPE_CONCAT
PLUGINS	PLUGINS
POINT	POINT
POLYGON	POLYGON
POSITION	POSITION
PRECEDING	PRECEDING
PREPARE	PREPARE
PRIMARY	PRIMARY
PRIVILEGES	PRIVILEGES
PROCEDURE	PROCEDURE
PROCESSLIST	PROCESSLIST
PROFILES	PROFILES
PROPERTIES	PROPERTIES
PROXY	PROXY
PUBLICATION	PUBLICATION
PUBLICATIONS	PUBLICATIONS
QUARTER	QUARTER
QUERY	QUERY
QUERY_RESULT	QUERY_RESULT
QUICK	QUICK
QUOTE_ID	QUOTE_ID
RANDOM	RANDOM
RANGE	RANGE
RANK	RANK
READ	READ
REAL	REAL
RECURSIVE	RECURSIVE
REDUNDANT	REDUNDANT
REFERENCE	REFERENCE
REFERENCES	REFERENCES
REGEXP	REGEXP
RELEASE	RELEASE
RELOAD	RELOAD
RENAME	RENAME
REORGANIZE	REORGANIZE
REPAIR	REPAIR
REPEAT	REPEAT
REPEATABLE	REPEATABLE
REPLACE	REPLACE
REPLICATION	REPLICATION
REQUIRE	REQUIRE
RESET	RESET
RESTRICT	RESTRICT
RESTRICTED	RESTRICTED
RESUME	RESUME
RETURNS	RETURNS
REUSE	REUSE
REVERSE	REVERSE
REVOKE	REVOKE
RIGHT	RIGHT
ROLE	ROLE
ROLES	ROLES
ROLLBACK	ROLLBACK
ROUTINE	ROUTINE
ROW	ROW
ROW_COUNT	ROW_COUNT
ROW_FORMAT	ROW_FORMAT
ROW_NUMBER	ROW_NUMBER
ROWS	ROWS
RTREE	RTREE
S3OPTION	S3OPTION
SCHEMA	SCHEMA
SCHEMAS	SCHEMAS
SECOND	SECOND
SECONDARY	SECONDARY
SECONDARY_ENGINE_ATTRIBUTE	SECONDARY_ENGINE_ATTRIBUTE
SECOND_MICROSECOND	SECOND_MICROSECOND
SECURITY	SECURITY
SELECT	SELECT
SEPARATOR	SEPARATOR
SEQUENCE	SEQUENCE
SEQUENCES	SEQUENCES
SERIALIZABLE	SERIALIZABLE
SERVERS	SERVERS
SESSION	SESSION
SESSION_USER	SESSION_USER
SET	SET
SETVAL	SETVAL
SHARE	SHARE
SHARED	SHARED
"<<"	SHIFT_LEFT
">>"	SHIFT_RIGHT
SHOW	SHOW
SHUTDOWN	SHUTDOWN
SIGNED	SIGNED
SIMPLE	SIMPLE
SLAVE	SLAVE
SMALLINT	SMALLINT
SNAPSHOT	SNAPSHOT
SOME	SOME
SOURCE	SOURCE
SPATIAL	SPATIAL
SPBEGIN	SPBEGIN
SQL	SQL
SQL_BIG_RESULT	SQL_BIG_RESULT
SQL_BUFFER_RESULT	SQL_BUFFER_RESULT
SQL_SMALL_RESULT	SQL_SMALL_RESULT
SQL_TSI_DAY	SQL_TSI_DAY
SQL_TSI_HOUR	SQL_TSI_HOUR
SQL_TSI_MINUTE	SQL_TSI_MINUTE
SQL_TSI_MONTH	SQL_TSI_MONTH
SQL_TSI_QUARTER	SQL_TSI_QUARTER
SQL_TSI_SECOND	SQL_TSI_SECOND
SQL_TSI_WEEK	SQL_TSI_WEEK
SQL_TSI_YEAR	SQL_TSI_YEAR
STAGE	STAGE
STAGES	STAGES
START	START
STARTING	STARTING
STATS_AUTO_RECALC	STATS_AUTO_RECALC
STATS_PERSISTENT	STATS_PERSISTENT
STATS_SAMPLE_PAGES	STATS_SAMPLE_PAGES
STATUS	STATUS
STD	STD
STDDEV	STDDEV
STDDEV_POP	STDDEV_POP
STDDEV_SAMP	STDDEV_SAMP
STORAGE	STORAGE
STRAIGHT_JOIN	STRAIGHT_JOIN
STREAM	STREAM
STRING	STRING
SUBDATE	SUBDATE
SUBPARTITION	SUBPARTITION
SUBPARTITIONS	SUBPARTITIONS
SUBQUERY_AS_EXPR	SUBQUERY_AS_EXPR
SUBSCRIPTIONS	SUBSCRIPTIONS
SUBSTR	SUBSTR
SUBSTRING	SUBSTRING
SUM	SUM
SUPER	SUPER
SUSPEND	SUSPEND
SYSDATE	SYSDATE
SYSTEM_USER	SYSTEM_USER
TABLE	TABLE
TABLE_NUMBER	TABLE_NUMBER
TABLES	TABLES
TABLE_SIZE	TABLE_SIZE
TABLESPACE	TABLESPACE
TABLE_VALUES	TABLE_VALUES
TASK	TASK
TEMPORARY	TEMPORARY
TEMPTABLE	TEMPTABLE
TERMINATED	TERMINATED
TEXT	TEXT
THAN	THAN
THEN	THEN
TIME	TIME
TIMESTAMP	TIMESTAMP
TIMESTAMPDIFF	TIMESTAMPDIFF
TINYBLOB	TINYBLOB
TINYINT	TINYINT
TINYTEXT	TINYTEXT
TO	TO
TRAILING	TRAILING
TRANSACTION	TRANSACTION
TRANSLATE	TRANSLATE
TRIGGER	TRIGGER
TRIGGERS	TRIGGERS
TRIM	TRIM
TRUE	TRUE
TRUNCATE	TRUNCATE
TYPE	TYPE
UNARY	UNARY
UNBOUNDED	UNBOUNDED
UNCOMMITTED	UNCOMMITTED
UNDEFINED	UNDEFINED
UNION	UNION
UNIQUE	UNIQUE
UNKNOWN	UNKNOWN
UNLOCK	UNLOCK
UNSIGNED	UNSIGNED
UNTIL	UNTIL
UNUSED	UNUSED
UPDATE	UPDATE
URL	URL
USAGE	USAGE
USE	USE
USER	USER
USING	USING
UTC_DATE	UTC_DATE
UTC_TIME	UTC_TIME
UTC_TIMESTAMP	UTC_TIMESTAMP
UUID	UUID
VALIDATION	VALIDATION
VALUES	VALUES
VARBINARY	VARBINARY
VARCHAR	VARCHAR
VARIABLES	VARIABLES
VARIANCE	VARIANCE
VAR_POP	VAR_POP
VAR_SAMP	VAR_SAMP
VECF32	VECF32
VECF64	VECF64
VERBOSE	VERBOSE
VIEW	VIEW
VISIBLE	VISIBLE
WARNINGS	WARNINGS
WEEK	WEEK
WHEN	WHEN
WHERE	WHERE
WHILE	WHILE
WITH	WITH
WITHOUT	WITHOUT
WORK	WORK
WRITE	WRITE
X509	X509
XOR	XOR
YEAR	YEAR
YEAR_MONTH	YEAR_MONTH
ZEROFILL	ZEROFILL
ZONEMAP	ZONEMAP

0B[01]+	BIT_LITERAL
DECIMAL_VALUE	DECIMAL_VALUE
[0-9]+E[-+]?[0-9]+	FLOAT
[0-9]+"."[0-9]*E[-+]?[0-9]+	FLOAT
"."[0-9]+E[-+]?[0-9]+	FLOAT
[0-9]+"."[0-9]*	FLOAT
"."[0-9]+	FLOAT
[0-9]+	INTEGRAL
0X[0-9A-Z]+	HEXNUM
UNDERSCORE_BINARY	UNDERSCORE_BINARY

'(''|[^'\n])*'	STRING

/* Order matter if identifier comes before keywords they are classified as identifier */
{base_id}	ID
"@@"{base_id}	AT_AT_ID
"@"{base_id}	AT_ID
"?"[0-9]+	VALUE_ARG

%%
