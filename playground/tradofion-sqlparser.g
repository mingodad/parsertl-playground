//From: https://github.com/chimdiadi/trafodion/blob/master/core/sql/parser/sqlparser.y
/* -*-C++-*-
******************************************************************************
*
* File:         SqlParser.y
* Description:  SQL Parser
*
* Created:      4/28/94
* Language:     C++
*
*
*	Is there a parser, much bemus'd in beer,
*	A maudlin poetess, a rhyming peer,
*	A clerk, foredoom'd his father's soul to cross,
*	Who pens a stanza, when he should engross?
*		-- with my apologies to Alexander Pope
*
******************************************************************************
*/

// As of 07/26/01, yacc (bison) reports for this file:
// w:\parser\sqlparser.y contains 56 shift/reduce conflicts and 9 reduce/reduce conflicts.
// As of 02/23/07, yacc (bison) reports for this file:
// w:\parser\sqlparser.y contains 71 shift/reduce conflicts and 12 reduce/reduce conflicts.

// shift/reduce case study: DROP GHOST TABLE
// Before the invention of ghost tables, the second production for drop_table_statement was:
//   drop_table_statement : TOK_DROP TOK_TABLE ddl_qualified_name optional_cleanup
//                            optional_drop_invalidate_dependent_behavior optional_validate optional_logfile
// I wanted to insert an optional TOK_GHOST like this:
//   drop_table_statement : TOK_DROP optional_ghost TOK_TABLE ddl_qualified_name optional_cleanup
//                            optional_drop_invalidate_dependent_behavior optional_validate optional_logfile
//   optional_ghost : empty | TOK_GHOST
// Unfortunately that introduced a shift/reduce conflict. After reading TOK_DROP, if the next
// token is TOK_TABLE, bison wanted to reduce
//   optional_ghost -> empty
// but it also wanted to shift TOK_TABLE because DROP TABLE was not enough to distinguish the
// first two productions for drop_table_statement. So in order to avoid introducing a
// shift/reduce conflict, the productions have been written like this:
//   drop_table_statement : drop_table_start_tokens ddl_qualified_name optional_cleanup
//                            optional_drop_invalidate_dependent_behavior optional_validate optional_logfile
//   drop_table_start_tokens : TOK_DROP TOK_TABLE | TOK_DROP TOK_GHOST TOK_TABLE
// This solves the problem because bison does not have to reduce after reading TOK_DROP. Rather,
// after reading TOK_DROP TOK_TABLE, it can lookahead at the next token to decide what to do.

%option caseless

/*Tokens*/
//%token NON_SQLTEXT_CHARACTER
%token ARITH_PLACEHOLDER
%token BOOL_PLACEHOLDER
%token DELIMITED_IDENTIFIER
%token BACKQUOTED_IDENTIFIER
%token CALL_CASED_IDENTIFIER
%token GOTO_CASED_IDENTIFIER
%token PERFORM_CASED_IDENTIFIER
%token HOSTVAR
%token IDENTIFIER
%token NUMERIC_LITERAL_APPROX
%token NUMERIC_LITERAL_EXACT_NO_SCALE
%token NUMERIC_LITERAL_EXACT_WITH_SCALE
%token PARAMETER
%token QUOTED_STRING
%token ANY_STRING
%token BACKSLASH_SYSTEM_NAME
%token SYSTEM_VOLUME_NAME
%token TOK_PICTURE
%token TOK_SBYTE_LITERAL
%token TOK_MBYTE_LITERAL
%token SYSTEM_CPU_IDENTIFIER
%token '('
%token ')'
%token '*'
%token '+'
%token ','
%token '-'
%token '.'
%token '/'
%token '<'
%token '='
%token '>'
//%token '$'
%token ';'
%token TOK_TYPE
%token TOK_TYPE_ANSI
%token TOK_TYPE_FS
%token TOK_TYPES
%token TOK_DATETIME_CODE
%token TOK_LENGTH
%token TOK_PRECISION
%token TOK_SCALE
%token TOK_LEADING_PRECISION
%token TOK_NULLABLE
%token TOK_CHARACTER_SET_CATALOG
%token TOK_CHARACTER_SET_SCHEMA
%token TOK_CHARACTER_SET_NAME
%token TOK_COLLATION
%token TOK_COLLATION_CATALOG
%token TOK_COLLATION_SCHEMA
%token TOK_COLLATION_NAME
%token TOK_NAME
%token TOK_UNNAMED
%token TOK_INDICATOR_TYPE
%token TOK_INET_ATON
%token TOK_INET_NTOA
%token TOK_VARIABLE_POINTER
%token TOK_INDICATOR_POINTER
%token TOK_RETURNED_LENGTH
%token TOK_RETURNED_OCTET_LENGTH
%token TOK_VARIABLE_DATA
%token TOK_INDICATOR_DATA
%token TOK_CONDITION_NUMBER
%token TOK_RETURNED_SQLSTATE
%token TOK_CLASS_ORIGIN
%token TOK_SUBCLASS_ORIGIN
%token TOK_SERVER_NAME
%token TOK_CONNECTION_NAME
%token TOK_CONSTRAINT_CATALOG
%token TOK_CONSTRAINT_SCHEMA
%token TOK_CONSTRAINT_NAME
%token TOK_TRIGGER_CATALOG
%token TOK_TRIGGER_SCHEMA
%token TOK_TRIGGER_NAME
%token TOK_CATALOG_NAME
%token TOK_SCHEMA_NAME
%token TOK_TABLE_NAME
%token TOK_COLUMN_NAME
%token TOK_CURSOR_NAME
%token TOK_MESSAGE_TEXT
%token TOK_MESSAGE_LEN
%token TOK_MESSAGE_OCTET_LEN
%token TOK_COLUMN_NUMBER
%token TOK_NATIVE
%token TOK_ROW_NUMBER
%token TOK_SOURCE
%token TOK_SOURCE_FILE
%token TOK_LINE_NUMBER
%token TOK_SUBSYSTEM_ID
%token TOK_ABORT
%token TOK_ABS
%token TOK_ACOS
%token TOK_ASIN
%token TOK_ATAN
%token TOK_ATAN2
%token TOK_ACCESS
%token TOK_ACCUMULATED
%token TOK_ADD_MONTHS
%token TOK_ADMIN
%token TOK_AES_ENCRYPT
%token TOK_AES_DECRYPT
%token TOK_AFTER
%token TOK_ALL
%token TOK_ALL_DDL
%token TOK_ALL_DML
%token TOK_ALL_UTILITY
%token TOK_ALLOCATE
%token TOK_ALLOWED
%token TOK_ALWAYS
%token TOK_AND
%token TOK_AQR
%token TOK_ANSIVARCHAR
%token TOK_ANY
%token TOK_APPEND
%token TOK_ARE
%token TOK_AS
%token TOK_ASC
%token TOK_ASCII
%token TOK_ATOMIC
%token TOK_AUDITONREFRESH
%token TOK_AUTOABORT
%token TOK_AUTOBEGIN
%token TOK_AUTOCOMMIT
%token TOK_AUTOMATIC
%token TOK_AVERAGE_STREAM_WAIT
%token TOK_AVG
%token TOK_BEFORE
%token TOK_BEGIN
%token TOK_BEGIN_HINT
%token TOK_BT
%token TOK_END_HINT
%token TOK_BALANCE
%token TOK_NOT_BETWEEN
%token TOK_BETWEEN
%token TOK_BIT
%token TOK_BITAND
%token TOK_BITOR
%token TOK_BITXOR
%token TOK_BITNOT
%token TOK_BITEXTRACT
%token TOK_CONVERTTOBITS
%token TOK_BITOR_OPERATOR
%token TOK_BLOB
%token TOK_BLOCKS
%token TOK_BOTH
%token TOK_BOOLEAN
%token TOK_BY
%token TOK_BYTEINT
%token TOK_C
%token TOK_CPP
%token TOK_CALL
%token TOK_CANCEL
%token TOK_CARDINALITY
%token TOK_CASE
%token TOK_CAST
%token TOK_CENTURY
%token TOK_TYPECAST
%token TOK_CATCHUP
%token TOK_TRANSLATE
%token TOK_CEIL
%token TOK_CEILING
%token TOK_CHAR
%token TOK_CHARS
%token TOK_CHR
%token TOK_CHARACTER
%token TOK_CHARACTERS
%token TOK_CHANGED
%token TOK_CHANGES
%token TOK_CHAR_LENGTH
%token TOK_CLOB
%token TOK_CLOSE
%token TOK_CLUSTER
%token TOK_CLUSTERS
%token TOK_CLUSTERING
%token TOK_COALESCE
%token TOK_COLLATE
%token TOK_COLUMN_CREATE
%token TOK_COLUMN_LOOKUP
%token TOK_COLUMN_DISPLAY
%token TOK_HBASE_TIMESTAMP
%token TOK_HBASE_VERSION
%token TOK_COMMANDS
%token TOK_COMMAND_FUNCTION
%token TOK_COMMENT
%token TOK_COMMIT
%token TOK_COMP
%token TOK_COMPACT
%token TOK_COMPARE
%token TOK_COMPLETE
%token TOK_COMPRESS
%token TOK_COMPRESSED
%token TOK_CONCAT
%token TOK_CONCATENATION
%token TOK_CONCURRENCY
%token TOK_CONCURRENT
%token TOK_CONVERT
%token TOK_CONVERTFROMHEX
%token TOK_CONVERTTIMESTAMP
%token TOK_CONVERTTOHEX
%token TOK_CONVERTTOHX_INTN
%token TOK_CONTAINS
%token TOK_CONTINUE
%token TOK_CONTROL
//%token TOK_CORRESPONDING
%token TOK_COS
%token TOK_COSH
%token TOK_COST
%token TOK_COUNT
%token TOK_CRC32
%token TOK_CQD
%token TOK_CROSS
%token TOK_CURDATE
%token TOK_CURRENT
%token TOK_CURRENT_DATE
%token TOK_CURRENT_RUNNING
%token TOK_CURRENT_TIME
%token TOK_CURRENT_TIMESTAMP
%token TOK_CURRENT_TIMESTAMP_RUNNING
%token TOK_CURRENT_TIMESTAMP_UTC
%token TOK_CURRENT_TIME_UTC
%token TOK_CURRENT_USER
%token TOK_CURRNT_USR_INTN
%token TOK_CURSOR
%token TOK_CURTIME
%token TOK_CACHE
%token TOK_CYCLE
%token TOK_D
%token TOK_DATABASE
%token TOK_DATE
%token TOK_DATEADD
%token TOK_DATE_ADD
%token TOK_DATE_SUB
%token TOK_DATE_PART
%token TOK_DATE_BEFORE_QUOTE
%token TOK_DATE_TRUNC
%token TOK_DATEDIFF
%token TOK_DATEFORMAT
%token TOK_DATETIME
%token TOK_DAY
%token TOK_DAYNAME
%token TOK_DAYOFWEEK
%token TOK_DAYOFYEAR
%token TOK_DAYOFMONTH
%token TOK_DEALLOCATE
%token TOK_DECIMAL
%token TOK_DECLARE
%token TOK_DEFAULT
%token TOK_DEFAULTS
%token TOK_DEFINITION
%token TOK_DEBUG
%token TOK_DEGREES
%token TOK_DE
%token TOK_DECODE
%token TOK_DELAY
%token TOK_DELETE
%token TOK_DESC
%token TOK_DESCRIBE
%token TOK_DESCRIPTOR
%token TOK_DELIMITER
%token TOK_DETAIL
%token TOK_DETAILS
%token TOK_DETERMINISTIC
%token TOK_DIAGNOSTICS
%token TOK_DISABLE
%token TOK_DIFF1
%token TOK_DIFF2
%token TOK_DIRECTEDBY
%token TOK_DISPLAY
%token TOK_DISTINCT
%token TOK_DIVISION
%token TOK_DO
%token TOK_DOT_STAR
%token TOK_DOUBLE
%token TOK_DOUBLE_IEEE
%token TOK_DUPLICATE
%token TOK_DYNAMIC
%token TOK_DYNAMIC_FUNCTION
%token TOK_D_RANK
%token TOK_DECADE
%token TOK_DOW
%token TOK_DOY
%token TOK_EACH
%token TOK_EID
%token TOK_ELSEIF
%token TOK_ELSE
%token TOK_ENABLE
%token TOK_END
%token TOK_ENCODE_KEY
%token TOK_ENCODE_BASE64
%token TOK_DECODE_BASE64
%token TOK_ENFORCED
%token TOK_ENFORCERS
%token TOK_ENTERPRISE
%token TOK_ERROR
%token TOK_ESCAPE
%token TOK_ET
%token TOK_EUROPEAN
%token TOK_EVERY
%token TOK_EXCEPT
%token TOK_EXCEPTION
%token TOK_EXCEPTIONS
%token TOK_EXCEPTION_TABLE
%token TOK_EXCHANGE
%token TOK_EXCHANGE_AND_SORT
%token TOK_EXCLUSIVE
%token TOK_EXECUTE
%token TOK_EXISTING
%token TOK_EXISTS
%token TOK_EXIT
%token TOK_EXP
%token TOK_EXPLAIN
%token TOK_EXPONENTIATE
%token TOK_EXTEND
%token TOK_EXTERNAL
%token TOK_EXTRACT
%token TOK_EXTRACT_SOURCE
%token TOK_EXTRACT_TARGET
%token TOK_EPOCH
%token TOK_FALSE
%token TOK_FAMILY
%token TOK_FEATURE_VERSION_INFO
%token TOK_FETCH
%token TOK_FIRST
%token TOK_FIRSTDAYOFYEAR
%token TOK_FIRST_FSCODE
%token TOK_FLOAT
%token TOK_FLOAT_IEEE
%token TOK_FLOOR
%token TOK_FN
%token TOK_FOLLOWING
%token TOK_FOR
%token TOK_FOR_MAXRUNTIME
%token TOK_LPAREN_BEFORE_DATATYPE
%token TOK_LPAREN_BEFORE_DATE_AND_LPAREN
%token TOK_LPAREN_BEFORE_DATE_COMMA_AND_FORMAT
%token TOK_LPAREN_BEFORE_FORMAT
%token TOK_LPAREN_BEFORE_NAMED
%token TOK_FORCE
//%token TOK_FOR_BROWSE
%token TOK_FOR_READ
%token TOK_FOR_READ_ONLY
%token TOK_FOR_REPEATABLE
%token TOK_FOR_SERIALIZABLE
//%token TOK_FOR_STABLE
%token TOK_FOR_USER
%token TOK_FOR_ROLE
%token TOK_FOR_LIBRARY
%token TOK_FOUND
%token TOK_FRACTION
%token TOK_FROM
%token TOK_FROM_HEX
%token TOK_FULL
%token TOK_GENERAL
%token TOK_GENERATE
%token TOK_GENERATED
%token TOK_GET
%token TOK_GLOBAL
//%token TOK_GO
//%token TOK_GOTO
%token TOK_GREATER_EQUAL
%token TOK_GREATEST
%token TOK_GROUP
%token TOK_GROUP_CONCAT
%token TOK_GZIP
%token TOK_HAVING
%token TOK_HIVE
%token TOK_HIVEMD
%token TOK_QUALIFY
%token TOK_HEADER
%token TOK_TRAFODION
%token TOK_HBASE
%token TOK_HBASE_OPTIONS
%token TOK_SERIALIZED
%token TOK_HEX
%token TOK_HEXADECIMAL
%token TOK_UNHEX
%token TOK_HIGH_VALUE
%token TOK_HOLD
%token TOK_HOUR
%token TOK_HOURS
%token TOK_IDENTITY
%token TOK_IF
%token TOK_IGNORE
%token TOK_IGNORETRIGGERS
%token TOK_IGNORE_TRIGGER
%token TOK_IMMEDIATE
%token TOK_IMMUTABLE
%token TOK_IMPLICIT
%token TOK_IN
%token TOK_INCREMENT
%token TOK_INCREMENTAL
%token TOK_INOUT
%token TOK_INSTR
%token TOK_NOT_IN
%token TOK_SYS_GUID
%token TOK_INCLUSIVE
%token TOK_INDICATOR
%token TOK_INITIALIZATION
%token TOK_INITIAL
%token TOK_INITIALIZED
%token TOK_INGEST
%token TOK_INNER
%token TOK_INPUT
%token TOK_INPUTS
%token TOK_BUFFERTOLOB
%token TOK_EXTERNALTOLOB
%token TOK_FILETOLOB
%token TOK_FILETOEXTERNAL
%token TOK_LOADTOLOB
%token TOK_STRINGTOLOB
%token TOK_STRINGTOEXTERNAL
%token TOK_LOB
%token TOK_LOBLENGTH
%token TOK_LOBTOBUFFER
%token TOK_LOBTOFILE
%token TOK_LOBTOSTRING
%token TOK_EXTERNALTOSTRING
%token TOK_EMPTY_BLOB
%token TOK_EMPTY_CLOB
%token TOK_INSERT
%token TOK_INSERT_ONLY
%token TOK_INS
%token TOK_ISOLATE
%token TOK_INTEGER
%token TOK_INTERNAL
%token TOK_INTERNAL_EXPR
%token TOK_INTERNAL_COLUMN_DEFINITION
%token TOK_INTERNALSP
%token TOK_INTERSECT
%token TOK_INTERVAL
%token TOK_INTERVALS
%token TOK_INTO
%token TOK_INVOKE
%token TOK_IS
%token TOK_ISNULL
%token TOK_IUDLOG
%token TOK_JAVA
%token TOK_JOIN
%token TOK_JSONOBJECTFIELDTEXT
%token TOK_JULIANTIMESTAMP
%token TOK_LAG
%token TOK_LANGUAGE
%token TOK_LARGEINT
%token TOK_LASTNOTNULL
%token TOK_LAST
%token TOK_LAST_DAY
%token TOK_LAST_FSCODE
%token TOK_LAST_SYSKEY
%token TOK_LASTSYSKEY
%token TOK_LCASE
%token TOK_LEAD
%token TOK_LEADING
%token TOK_LEAST
%token TOK_LEFT
%token TOK_LESS_EQUAL
%token TOK_LIBRARY
%token TOK_LIBRARIES
%token TOK_LIKE
%token TOK_LIMIT
%token TOK_LOAD
%token TOK_LOAD_ID
%token TOK_LOCAL
%token TOK_LOCATE
%token TOK_LOCK
%token TOK_LOCK_ROW
%token TOK_LOG
%token TOK_LOGGABLE
%token TOK_LOGON
%token TOK_LZO
%token TOK_IUD_LOG_TABLE
%token TOK_RANGE_LOG_TABLE
%token TOK_LOG10
%token TOK_LOG2
%token TOK_LONGWVARCHAR
%token TOK_LOW_VALUE
%token TOK_LOWER
%token TOK_LPAD
%token TOK_LSDECIMAL
%token TOK_LTRIM
%token TOK_MAINTAIN
%token TOK_MANAGEMENT
%token TOK_MANUAL
%token TOK_MASTER
%token TOK_MATCH
%token TOK_MATCHED
%token TOK_MATERIALIZED
%token TOK_MAVG
%token TOK_MAX
%token TOK_MAXRUNTIME
%token TOK_MAXVALUE
%token TOK_MCOUNT
%token TOK_MEMORY
%token TOK_MERGE
%token TOK_METADATA
%token TOK_MD5
%token TOK_MIN
%token TOK_MINIMAL
%token TOK_MINUTE
%token TOK_MINUTES
%token TOK_MINVALUE
%token TOK_MIXED
%token TOK_MOD
%token TOK_MODIFIES
%token TOK_MMAX
%token TOK_MMIN
%token TOK_MODE
%token TOK_MODULE
%token TOK_MODULES
%token TOK_MONTH
%token TOK_MONTHS_BETWEEN
%token TOK_MONTHNAME
%token TOK_MORE
%token TOK_MRANK
%token TOK_MSCK
%token TOK_MSTDDEV
%token TOK_MSUM
%token TOK_MV
%token TOK_MVATTRIBUTE
%token TOK_MVATTRIBUTES
%token TOK_MVS
%token TOK_MVSTATUS
%token TOK_MV_TABLE
%token TOK_MVARIANCE
%token TOK_MVGROUP
%token TOK_MVGROUPS
%token TOK_MVS_UMD
%token TOK_MVUID
%token TOK_MULTI
%token TOK_MULTIDELTA
%token TOK_MULTISET
%token TOK_NAMED
%token TOK_NAMES
%token TOK_NAMETYPE
%token TOK_NATIONAL
%token TOK_NATURAL
%token TOK_NCHAR
%token TOK_NECESSARY
%token TOK_NEEDED
%token TOK_NEW
%token TOK_NEXT
%token TOK_NEXT_DAY
%token TOK_NODELETE
%token TOK_NODES
%token TOK_NOT
%token TOK_NOT_EQUAL
%token TOK_NOW
%token TOK_NSK_CODE
%token TOK_NULL
%token TOK_NULLIF
%token TOK_NULLIFZERO
%token TOK_NULL_STRING
%token TOK_ZEROIFNULL
%token TOK_NUMBER
%token TOK_NUMERIC
%token TOK_NVL
%token TOK_OCTET_LENGTH
%token TOK_OF
%token TOK_OFFSET
%token TOK_OJ
%token TOK_OLD
%token TOK_ON
//%token TOK_ON_COMMIT
%token TOK_ONLY
%token TOK_OPEN
%token TOK_OR
%token TOK_ORDER
%token TOK_ORDERED
%token TOK_OS_USERID
%token TOK_OUT
%token TOK_OUTER
%token TOK_OUTPUT
%token TOK_OVER
%token TOK_OVERLAPS
%token TOK_OVERRIDE
%token TOK_OVERWRITE
%token TOK_PAGE
%token TOK_PAGES
%token TOK_PARAMETER
%token TOK_PARENT
%token TOK_PARSERFLAGS
%token TOK_ENVVAR
%token TOK_ENVVARS
%token TOK_PARTIAL
%token TOK_PATH
%token TOK_PERCENT
%token TOK_PERFORM
%token TOK_PERIODIC
%token TOK_PERTABLE
%token TOK_PHASE
%token TOK_PI
%token TOK_PIVOT
%token TOK_PIVOT_GROUP
%token TOK_POS
%token TOK_POSITION
%token TOK_POWER
%token TOK_PRECEDING
%token TOK_PREFER_FOR_SCAN_KEY
%token TOK_PREPARE
%token TOK_PRESERVE
%token TOK_PRIORITY
%token TOK_PRIORITY_DELTA
%token TOK_PROCEDURE
%token TOK_PROCEDURES
%token TOK_PROCESS
%token TOK_PROGRESS
%token TOK_PROTOTYPE
%token TOK_QUERY
%token TOK_QUERY_CACHE
%token TOK_HYBRID_QUERY_CACHE
%token TOK_HYBRID_QUERY_CACHE_ENTRIES
%token TOK_CATMAN_CACHE
%token TOK_NATABLE_CACHE
%token TOK_NATABLE_CACHE_ENTRIES
%token TOK_NAROUTINE_CACHE
%token TOK_NAROUTINE_ACTION_CACHE
%token TOK_QUERY_CACHE_ENTRIES
%token TOK_QUERYID_EXTRACT
%token TOK_QUARTER
%token TOK_RADIANS
%token TOK_RAND
%token TOK_RANDOM
%token TOK_RATE
%token TOK_RAVG
%token TOK_RCOUNT
%token TOK_READ
%token TOK_REAL
%token TOK_REAL_IEEE
%token TOK_RECOMPUTE
%token TOK_RECORD_SEPARATOR
%token TOK_SEPARATOR
%token TOK_RECOVER
%token TOK_RECOVERY
%token TOK_RECURSIVE
%token TOK_REFERENCING
%token TOK_REFRESH
%token TOK_RELATED
%token TOK_RELATEDNESS
%token TOK_RELOAD
%token TOK_REMOTE
%token TOK_TEMP_TABLE
%token TOK_TEMPORARY
%token TOK_REPAIR
%token TOK_REPEAT
%token TOK_REPEATABLE
//%token TOK_REPEATABLE_ACCESS
%token TOK_REPEATABLE_READ
%token TOK_REPLACE
%token TOK_REPOSITORY
%token TOK_REQUEST
%token TOK_REQUIRED
%token TOK_RESET
%token TOK_RESTORE
%token TOK_RESUME
%token TOK_REWRITE
%token TOK_RESULT
%token TOK_RETRIES
%token TOK_RIGHT
%token TOK_RMAX
%token TOK_RMIN
%token TOK_ROLE
%token TOK_ROLES
%token TOK_ROLLBACK
%token TOK_ROUND
%token TOK_ROW
%token TOK_ROW_COUNT
%token TOK_ROWNUM
%token TOK_ROWS_DELETED
%token TOK_ROWS_INSERTED
%token TOK_ROWS_UPDATED
%token TOK_ROWS_COVERED
%token TOK_NUM_OF_RANGES
%token TOK_RPAD
%token TOK_RRANK
%token TOK_RSTDDEV
%token TOK_RSUM
%token TOK_RTRIM
%token TOK_RVARIANCE
%token TOK_SAMPLE
%token TOK_SAMPLE_FIRST
%token TOK_SAMPLE_PERIODIC
%token TOK_SAMPLE_RANDOM
%token TOK_RUN
%token TOK_STRING_SEARCH
%token TOK_SECOND
%token TOK_SECONDS
%token TOK_SECTION
%token TOK_SELECT
%token TOK_SEL
%token TOK_SELECTIVITY
%token TOK_SEQNUM
%token TOK_SEQUENCE
%token TOK_SEQUENCES
%token TOK_SEQUENCE_BY
%token TOK_SESSION
%token TOK_SESSIONS
%token TOK_SESSION_USER
%token TOK_SESSN_USR_INTN
%token TOK_SET
%token TOK_SETS
%token TOK_SG_TABLE
%token TOK_SHA
%token TOK_SHA1
%token TOK_SHA2
%token TOK_SHAPE
%token TOK_SHARE
%token TOK_SHARED
%token TOK_SUSPEND
%token TOK_SHOW
%token TOK_SHOWCONTROL
%token TOK_SHOWDDL_ROLE
%token TOK_SHOWDDL_COMPONENT
%token TOK_SHOWDDL_LIBRARY
%token TOK_SHOWDDL_SEQUENCE
%token TOK_SHOWDDL_USER
%token TOK_SHOWDDL
%token TOK_SYSDATE
%token TOK_SYSTIMESTAMP
%token TOK_TARGET
%token TOK_SYSTEM
%token TOK_SHOWSTATS
%token TOK_SHOWTRANSACTION
%token TOK_ARKCMP
%token TOK_PROMPT
%token TOK_SHOWPLAN
%token TOK_SHOWSET
%token TOK_SHOWSHAPE
%token TOK_SIGN
%token TOK_SIGNAL
%token TOK_SIGNED
%token TOK_SIN
%token TOK_SINCE
%token TOK_SINGLEDELTA
%token TOK_SINH
%token TOK_SLACK
%token TOK_SPACE
%token TOK_SMALLINT
%token TOK_SOME
%token TOK_SOUNDEX
%token TOK_SORT
%token TOK_SORT_KEY
%token TOK_SP_RESULT_SET
%token TOK_STATUS
%token TOK_STDDEV
%token TOK_STOP
%token TOK_SPLIT_PART
%token TOK_STORED
%token TOK_SQL
%token TOK_SQL_DOUBLE
%token TOK_SQLCODE
%token TOK_SQLERROR
%token TOK_SQLSTATE
%token TOK_SQL_WARNING
%token TOK_SQRT
%token TOK_STATEMENT
%token TOK_STATIC
%token TOK_STYLE
%token TOK_SUBSTRING
%token TOK_SUM
%token TOK_SUMMARY
%token TOK_T
%token TOK_TABLE
%token TOK_TABLES
%token TOK_TABLESPACE
%token TOK_TAN
%token TOK_TANH
%token TOK_THEN
%token TOK_THIS
%token TOK_TIME
%token TOK_TIME_BEFORE_QUOTE
%token TOK_TIMEOUT
%token TOK_TIMESTAMP
%token TOK_TIMESTAMPADD
%token TOK_TIMESTAMPDIFF
%token TOK_TINYINT
%token TOK_TITLE
%token TOK_TO
%token TOK_TO_BINARY
%token TOK_TO_CHAR
%token TOK_TO_DATE
%token TOK_TO_HEX
%token TOK_TO_NUMBER
%token TOK_TO_TIME
%token TOK_TO_TIMESTAMP
%token TOK_TOKENSTR
%token TOK_TRAILING
%token TOK_TRANSACTION
%token TOK_TRANSFORM
%token TOK_TRANSPOSE
%token TOK_TRIGGER
%token TOK_TRIGGERS
%token TOK_TRIM
%token TOK_TRUE
%token TOK_TRUNC
%token TOK_TRUNCATE
%token TOK_TS
%token TOK_UCASE
%token TOK_CODE_VALUE
%token TOK_UNION
%token TOK_UNION_JOIN
%token TOK_UNIQUE
%token TOK_UNIQUE_ID
%token TOK_UUID
%token TOK_UNKNOWN
%token TOK_UNLOAD
%token TOK_SCAN
%token TOK_SNAPSHOT
%token TOK_SUFFIX
%token TOK_UNLOCK
%token TOK_UNSIGNED
%token TOK_UPDATE
%token TOK_UPDATE_STATS
%token TOK_UPDATE_LOB
%token TOK_UPD
%token TOK_UPGRADE
%token TOK_UPPER
%token TOK_UPSERT
%token TOK_UPPERCASE
%token TOK_UPSHIFT
%token TOK_USA
%token TOK_USAGE
%token TOK_USE
%token TOK_USER
%token TOK_USERNAMEINTTOEXT
%token TOK_USERS
%token TOK_USING
%token TOK_VALUE
%token TOK_VALUES
%token TOK_VARBINARY
%token TOK_VARCHAR
%token TOK_VARIANCE
%token TOK_VARWCHAR
%token TOK_VARYING
%token TOK_VERSION
%token TOK_VERSIONS
%token TOK_VPROC
%token TOK_VERSION_INFO
%token TOK_VOLATILE
%token TOK_WAITED
%token TOK_WAITEDIO
%token TOK_WCHAR
%token TOK_WEEK
%token TOK_WOM
%token TOK_WHEN
%token TOK_WHENEVER
%token TOK_WHERE
%token TOK_WITH
%token TOK_SLEEP
%token TOK_UUID_SHORT
%token TOK_UNIX_TIMESTAMP
%token TOK_WITHOUT
%token TOK_WORK
%token TOK_WRITE
%token TOK_XMLAGG
%token TOK_XMLELEMENT
%token TOK_YEAR
%token TOK_ACTION
%token TOK_ADD
%token TOK_REMOVE
%token TOK_OPENBLOWNAWAY
%token TOK_REDEFTIME
%token TOK_ALTER
%token TOK_ALTER_LIBRARY
%token TOK_ALTER_MV
%token TOK_ALTER_MV_GROUP
%token TOK_ALTER_ROUTINE
%token TOK_ALTER_ROUTINE_ACTION
%token TOK_ALTER_SYNONYM
%token TOK_ALTER_TABLE
%token TOK_ALTER_TRIGGER
%token TOK_ALTER_VIEW
%token TOK_ASCENDING
//%token TOK_ASSERTION
%token TOK_ATTRIBUTE
%token TOK_ATTRIBUTES
%token TOK_AUDIT
%token TOK_AUDITCOMPRESS
%token TOK_AUTHENTICATION
%token TOK_AUTHNAME
%token TOK_AUTHORIZATION
%token TOK_AUTHTYPE
%token TOK_BLOCKSIZE
%token TOK_BRIEF
%token TOK_BUFFER
%token TOK_BUFFERED
%token TOK_BYTE
%token TOK_BYTES
%token TOK_CAPTURE
%token TOK_CASCADE
%token TOK_CASCADED
%token TOK_CATALOG
%token TOK_CATALOGS
%token TOK_CHECK
%token TOK_CLEAN
%token TOK_CLEANUP
%token TOK_CLEANUP_OBSOLETE
%token TOK_CLEAR
%token TOK_CLEARONPURGE
%token TOK_COLUMN
%token TOK_COLUMNS
%token TOK_COMPILE
%token TOK_COMPONENT
%token TOK_COMPONENTS
%token TOK_COMPRESSION
%token TOK_CONFIG
%token TOK_CONSTRAINT
%token TOK_CONSTRAINTS
%token TOK_COPY
%token TOK_CREATE
%token TOK_CREATE_LIBRARY
%token TOK_CREATE_MV
%token TOK_CREATE_MV_GROUP
%token TOK_CREATE_PROCEDURE
%token TOK_CREATE_ROUTINE
%token TOK_CREATE_ROUTINE_ACTION
%token TOK_CREATE_TABLE
%token TOK_CREATE_TRIGGER
%token TOK_CREATE_SYNONYM
%token TOK_CREATE_VIEW
%token TOK_DATA
%token TOK_DBA
%token TOK_DCOMPRESS
%token TOK_DDL
%token TOK_DESCENDING
%token TOK_DEPENDENT
%token TOK_DROP
%token TOK_DROP_LIBRARY
%token TOK_DROP_MV
%token TOK_DROP_MV_GROUP
%token TOK_DROP_PROCEDURE
%token TOK_DROP_ROUTINE
%token TOK_DROP_ROUTINE_ACTION
%token TOK_DROP_SYNONYM
%token TOK_DROP_TABLE
%token TOK_DROP_TRIGGER
%token TOK_DROP_VIEW
%token TOK_DROPPABLE
%token TOK_DSLACK
%token TOK_ENTRY
%token TOK_ENTRIES
%token TOK_EXECUTION
%token TOK_FOREIGN
%token TOK_G
%token TOK_GHOST
%token TOK_GIVE
%token TOK_GRANT
%token TOK_GRANTEES
%token TOK_GRANTED
%token TOK_HARDWARE
%token TOK_HASH
%token TOK_HASH2
%token TOK_HASHPARTFUNC
%token TOK_HASH2PARTFUNC
%token TOK_HEADING
%token TOK_HEADINGS
%token TOK_ICOMPRESS
%token TOK_HORIZONTAL
%token TOK_INITIALIZE
%token TOK_INITIALIZE_MAINTAIN
%token TOK_REINITIALIZE_MAINTAIN
%token TOK_INITIALIZE_SQL
%token TOK_INDEX
%token TOK_INDEXES
%token TOK_INDEX_TABLE
%token TOK_INSERTLOG
%token TOK_INVALID
%token TOK_INVALIDATE
%token TOK_ISIPV4
%token TOK_ISIPV6
%token TOK_ISLACK
%token TOK_K
%token TOK_KEY
%token TOK_KEY_RANGE_COMPARE
%token TOK_LABEL
%token TOK_LABEL_CREATE
%token TOK_LABEL_DROP
%token TOK_LABEL_ALTER
%token TOK_LABEL_PURGEDATA
%token TOK_LOCATION
%token TOK_LOCKING
%token TOK_LOCKONREFRESH
%token TOK_M
%token TOK_MOVE
%token TOK_MOVEMENT
%token TOK_MVLOG
%token TOK_NAMESPACE
%token TOK_NO
%token TOK_NONE
%token TOK_NOMVLOG
%token TOK_NOLOG
%token TOK_NO_DEFAULT
%token TOK_NO_PARTITION
%token TOK_NO_PARTITIONS
%token TOK_NO_LOAD
%token TOK_NOT_DROPPABLE
%token TOK_NOT_ENFORCED
%token TOK_OBSOLETE
%token TOK_OBJECT
%token TOK_OBJECTS
%token TOK_OFF
%token TOK_OFFLINE
%token TOK_ONLINE
%token TOK_OPCODE
%token TOK_OPTION
%token TOK_OPTIONS
%token TOK_OSIM
%token TOK_SIMULATE
%token TOK_PARALLEL
%token TOK_PARTITION
%token TOK_PARTITIONING
%token TOK_PARTITIONS
%token TOK_PIPELINE
%token TOK_POPULATE
%token TOK_PRIMARY
%token TOK_PRIMARY_INDEX
%token TOK_PRIVATE
%token TOK_PRIVILEGE
%token TOK_PRIVILEGES
%token TOK_PUBLIC
%token TOK_PURGEDATA
%token TOK_RANGE
%token TOK_RANGE_N
%token TOK_RANGELOG
%token TOK_REBUILD
%token TOK_REFERENCES
%token TOK_REGEXP
%token TOK_REGION
%token TOK_REGISTER
%token TOK_REGISTERED
%token TOK_UNREGISTER
%token TOK_RENAME
//%token TOK_REPLICATE
%token TOK_RESTRICT
%token TOK_REVOKE
%token TOK_ROWS
%token TOK_RRPARTFUNC
%token TOK_SALT
%token TOK_SCHEMA
%token TOK_SCHEMAS
%token TOK_SECURITY
%token TOK_STORE
%token TOK_STORAGE
%token TOK_STATISTICS
%token TOK_HBMAP_TABLE
%token TOK_STATS
%token TOK_UNBOUNDED
%token TOK_VIEW
%token TOK_VIEWS
%token TOK_VALIDATE
%token TOK_ALIAS
%token TOK_SYNONYM
%token TOK_SYNONYMS
%token TOK_LONG
%token TOK_BIGINT
%token TOK_LEVEL
%token TOK_LEVELS
%token TOK_EOF
%token TOK_ISOLATION
%token TOK_COMMITTED
%token TOK_UNAVAILABLE
%token TOK_UNCOMMITTED
%token TOK_SIZE
%token TOK_SERIALIZABLE
%token TOK_SERIALIZABLE_ACCESS
%token TOK_SOFTWARE
%token TOK_REINITIALIZE
%token TOK_SEPARATE
%token TOK_BACKUP
%token TOK_STREAM
%token TOK_SKIP
%token TOK_CONFLICT
%token TOK_SKIP_CONFLICT_ACCESS
%token TOK_FOR_SKIP
%token TOK_RETURN
%token TOK_CURSOR_WITH_HOLD
%token TOK_CURSOR_WITHOUT_HOLD
%token TOK_VSBB
%token TOK_ROWSET
%token TOK_ROWWISE
%token TOK_ROWSET_SIZE
%token TOK_ROWSET_VAR_LAYOUT_SIZE
%token TOK_ROWSET_IND_LAYOUT_SIZE
%token DOLLAR_IDENTIFIER
%token TOK_PARAMETER_MODE
%token TOK_PARAMETER_ORDINAL_POSITION
%token TOK_PARAMETER_INDEX
%token TOK_ALIGNED
%token TOK_PACKED
%token TOK_QID
%token TOK_QID_INTERNAL
%token TOK_PID
%token TOK_CPU
%token TOK_ACTIVE
%token TOK_RMS
%token TOK_REVERSE
%token TOK_OVERLAY
%token TOK_STUFF
%token TOK_PLACING
%token TOK_DATA_OFFSET
%token TOK_NULL_IND_OFFSET
%token TOK_ALIGNED_LENGTH
%token TOK_ACTIVATE
%token TOK_PARTITION_BY
%token TOK_UDF
%token TOK_REPLICATE_PARTITION
%token TOK_RETURNS
%token TOK_PASS
%token TOK_THROUGH
%token TOK_TEXT
%token TOK_FILE
%token TOK_FINAL
%token TOK_ALLOW
%token TOK_PARALLELISM
%token TOK_AREA
%token TOK_TABLE_MAPPING
%token TOK_SCALAR
%token TOK_TAG
%token TOK_UNIVERSAL
%token TOK_FAST
%token TOK_SAFE
%token TOK_MESSAGE
%token TOK_NORMAL
%token TOK_IO
%token TOK_SAS_FORMAT
%token TOK_SAS_LOCALE
%token TOK_SAS_MODEL_INPUT_TABLE
%token TOK_SQLROW
%token TOK_DEFINER
%token TOK_INVOKER
//%token TOK_VERIFY
//%token TOK_AGGREGATE
//%token TOK_ARRAY
%token TOK_BINARY
//%token TOK_CLASS
//%token TOK_CONSTRUCTOR
//%token TOK_CUBE
//%token TOK_CURRENT_PATH
//%token TOK_DEREF
//%token TOK_DESTROY
//%token TOK_DESTRUCTOR
//%token TOK_FREE
%token TOK_FUNCTION
%token TOK_FUNCTIONS
%token TOK_GROUPING
%token TOK_GROUPING_ID
%token TOK_HOST
//%token TOK_ITERATE
//%token TOK_LARGE
//%token TOK_LATERAL
//%token TOK_LOCALTIME
//%token TOK_LOCALTIMESTAMP
//%token TOK_LOCATOR
%token TOK_MAP
//%token TOK_NCLOB
//%token TOK_ORDINALITY
//%token TOK_POSTFIX
%token TOK_READS
%token TOK_ROLLUP
//%token TOK_SCOPE
//%token TOK_SPECIFIC
//%token TOK_SPECIFICTYPE
%token TOK_START
%token TOK_STATE
//%token TOK_TERMINATE
//%token TOK_THAN
//%token TOK_TREAT
//%token TOK_UNNEST
%token TOK_EXTENT
%token TOK_MAXEXTENTS
%token TOK_UID
%token TOK_DISK
%token TOK_POOL
%token TOK_MTS
%token TOK_CHECKSUM
%token TOK_FALLBACK
%token TOK_PROTECTED
%token TOK_PROTECTION
%token TOK_FREESPACE
%token TOK_DUAL
%token TOK_JOURNAL
%token TOK_FORMAT
%token TOK_CASESPECIFIC
%token TOK_NOT_CASESPECIFIC
%token TOK_FIXED
%token '{'
%token '}'
%token '&'
%token '^'
%token '~'
%token '!'
%token '['
%token ']'

%right /*1*/ ','
%left /*2*/ TOK_EXCEPT TOK_INTERSECT TOK_UNION
%left /*3*/ TOK_CROSS TOK_FULL TOK_INNER TOK_JOIN TOK_LEFT TOK_NATURAL TOK_RIGHT TOK_UNION_JOIN
%left /*4*/ TOK_ON
%left /*5*/ '<' '=' '>' TOK_GREATER_EQUAL TOK_LESS_EQUAL TOK_NOT_EQUAL
%left /*6*/ TOK_AND
%left /*7*/ '+' '-'
%left /*8*/ '*' '/'
%left /*9*/ '.'

%start starting_production

%%

sign :
	'+' /*7L*/
	| '-' /*7L*/
	;

disableCharsetInference :
	/*empty*/
	;

enableCharsetInferenceInColDefaultVal :
	/*empty*/
	;

numeric_literal_exact :
	NUMERIC_LITERAL_EXACT_NO_SCALE
	;

numeric_literal :
	numeric_literal_exact
	| NUMERIC_LITERAL_EXACT_WITH_SCALE
	| NUMERIC_LITERAL_APPROX
	;

character_literal_sbyte :
	sbyte_string_literal character_literal_notcasespecific_option
	| std_char_string_literal character_literal_notcasespecific_option
	;

literal :
	numeric_literal
	| TOK_INTERVAL disableCharsetInference sign QUOTED_STRING interval_qualifier
	| TOK_INTERVAL disableCharsetInference QUOTED_STRING interval_qualifier
	| '{' TOK_INTERVAL disableCharsetInference sign QUOTED_STRING interval_qualifier '}'
	| '{' TOK_INTERVAL disableCharsetInference QUOTED_STRING interval_qualifier '}'
	| '{' TOK_D disableCharsetInference QUOTED_STRING '}'
	| TOK_DATE_BEFORE_QUOTE disableCharsetInference QUOTED_STRING
	| QUOTED_STRING TOK_LPAREN_BEFORE_DATE_COMMA_AND_FORMAT TOK_DATE ',' /*1R*/ TOK_FORMAT QUOTED_STRING ')'
	| '{' TOK_T disableCharsetInference QUOTED_STRING '}'
	| TOK_TIME_BEFORE_QUOTE disableCharsetInference QUOTED_STRING
	| TOK_TIMESTAMP disableCharsetInference QUOTED_STRING
	| '{' TOK_TS disableCharsetInference QUOTED_STRING '}'
	| character_literal_sbyte
	| unicode_string_literal
	| TOK_DATETIME disableCharsetInference QUOTED_STRING datetime_qualifier
	| boolean_literal
	;

boolean_literal :
	truth_value
	;

character_literal_notcasespecific_option :
	'(' TOK_NOT_CASESPECIFIC ')'
	| '(' TOK_CASESPECIFIC ')'
	| empty
	;

literal_negatable :
	literal
	| sign NUMERIC_LITERAL_EXACT_NO_SCALE
	| sign NUMERIC_LITERAL_EXACT_WITH_SCALE
	| sign NUMERIC_LITERAL_APPROX
	| sign TOK_INTERVAL disableCharsetInference QUOTED_STRING interval_qualifier
	| sign TOK_INTERVAL disableCharsetInference sign QUOTED_STRING interval_qualifier
	;

literal_as_string :
	NUMERIC_LITERAL_EXACT_NO_SCALE
	| NUMERIC_LITERAL_EXACT_WITH_SCALE
	| NUMERIC_LITERAL_APPROX
	| TOK_INTERVAL disableCharsetInference sign QUOTED_STRING interval_qualifier
	| TOK_INTERVAL disableCharsetInference QUOTED_STRING interval_qualifier
	| sign NUMERIC_LITERAL_EXACT_NO_SCALE
	| sign NUMERIC_LITERAL_EXACT_WITH_SCALE
	| sign NUMERIC_LITERAL_APPROX
	| sign TOK_INTERVAL disableCharsetInference QUOTED_STRING interval_qualifier
	| TOK_DATE disableCharsetInference QUOTED_STRING
	| TOK_TIME disableCharsetInference QUOTED_STRING
	| TOK_TIMESTAMP disableCharsetInference QUOTED_STRING
	| character_string_literal
	;

character_string_literal :
	sbyte_string_literal
	| std_char_string_literal
	;

sbyte_string_literal :
	TOK_SBYTE_LITERAL
	| sbyte_string_literal TOK_SBYTE_LITERAL
	| sbyte_string_literal QUOTED_STRING
	| std_char_string_literal TOK_SBYTE_LITERAL
	| sbyte_string_literal TOK_MBYTE_LITERAL
	;

unicode_string_literal :
	TOK_MBYTE_LITERAL
	| unicode_string_literal TOK_MBYTE_LITERAL
	| std_char_string_literal TOK_MBYTE_LITERAL
	| unicode_string_literal QUOTED_STRING
	| unicode_string_literal TOK_SBYTE_LITERAL
	;

declare_static_cursor :
	TOK_DECLARE entity_name TOK_CURSOR TOK_FOR cursor_spec
	| TOK_DECLARE entity_name TOK_CURSOR_WITH_HOLD TOK_FOR cursor_spec
	| TOK_DECLARE entity_name TOK_CURSOR_WITHOUT_HOLD TOK_FOR cursor_spec
	;

declare_dynamic_cursor :
	TOK_DECLARE entity_name TOK_CURSOR TOK_FOR entity_name
	| TOK_DECLARE entity_name TOK_CURSOR_WITH_HOLD TOK_FOR entity_name
	| TOK_DECLARE entity_name TOK_CURSOR_WITHOUT_HOLD TOK_FOR entity_name
	| TOK_ALLOCATE entity_name TOK_CURSOR TOK_FOR entity_name
	| TOK_ALLOCATE entity_name TOK_CURSOR_WITH_HOLD TOK_FOR entity_name
	| TOK_ALLOCATE entity_name TOK_CURSOR_WITHOUT_HOLD TOK_FOR entity_name
	;

entity_name :
	identifier
	| scope_spec character_string_literal
	| scope_spec simple_host_variable
	;

entity_name_as_item :
	identifier
	| simple_host_variable
	;

scope_spec :
	/*empty*/
	| TOK_GLOBAL
	| TOK_LOCAL
	;

cursor_spec :
	query_exp_for_cursor
	| rowset_for_input query_exp_for_cursor
	;

query_exp_for_cursor :
	query_expression for_update_spec
	| query_expression order_by_clause access_type optional_lock_mode for_update_spec
	;

for_update_spec :
	TOK_FOR_READ_ONLY
	| TOK_FOR TOK_UPDATE
	| TOK_FOR TOK_UPDATE TOK_OF column_list
	| /*empty*/
	;

using_clause :
	TOK_USING input_hostvar_list
	;

into_clause :
	TOK_INTO output_hostvar_list
	;

output_hostvar_list :
	hostvar_expression
	| output_hostvar_list ',' /*1R*/ hostvar_expression
	;

input_hostvar_list :
	input_hostvar_expression
	| input_hostvar_list ',' /*1R*/ input_hostvar_expression
	;

open_cursor :
	TOK_OPEN entity_name
	| TOK_OPEN entity_name extended_input_designation
	;

extended_input_designation :
	using_clause
	| using_descriptor
	;

using_descriptor :
	TOK_USING TOK_SQL TOK_DESCRIPTOR entity_name
	;

fetch_cursor :
	TOK_FETCH entity_name extended_output_designation
	| TOK_FETCH TOK_FROM entity_name extended_output_designation
	;

extended_output_designation :
	into_clause
	| into_descriptor
	;

into_descriptor :
	TOK_INTO TOK_SQL TOK_DESCRIPTOR entity_name
	;

dynamic_prepare :
	TOK_PREPARE entity_name TOK_FROM simple_host_variable
	;

dynamic_execute :
	TOK_EXECUTE entity_name
	| TOK_EXECUTE entity_name extended_input_designation
	| TOK_EXECUTE entity_name extended_output_designation
	| TOK_EXECUTE entity_name extended_input_designation extended_output_designation
	;

execute_immediate :
	TOK_EXECUTE TOK_IMMEDIATE simple_host_variable
	;

whenever_statement :
	TOK_WHENEVER whenever_condition whenever_action
	;

whenever_condition :
	TOK_NOT TOK_FOUND
	| TOK_SQLERROR
	| TOK_SQL_WARNING
	;

whenever_action :
	CALL_CASED_IDENTIFIER
	| CALL_CASED_IDENTIFIER '.' /*9L*/ regular_identifier
	| GOTO_CASED_IDENTIFIER
	| PERFORM_CASED_IDENTIFIER
	| TOK_CONTINUE
	;

describe_statement :
	TOK_DESCRIBE output_or_input entity_name describe_target
	;

describe_target :
	TOK_INTO entity_name
	| using_descriptor
	;

output_or_input :
	/*empty*/
	| TOK_INPUT
	| TOK_OUTPUT
	;

alloc_static_desc_stmt :
	TOK_ALLOCATE TOK_STATIC input_or_output TOK_DESCRIPTOR identifier for_stmt_or_curs '(' host_var_type_list ')'
	| TOK_ALLOCATE TOK_STATIC input_or_output TOK_DESCRIPTOR identifier for_stmt_or_curs TOK_LPAREN_BEFORE_DATATYPE host_var_type_list ')'
	;

input_or_output :
	/*empty*/
	| TOK_INPUT
	| TOK_OUTPUT
	;

for_stmt_or_curs :
	/*empty*/
	| TOK_FOR TOK_STATEMENT identifier
	| TOK_FOR TOK_CURSOR identifier
	;

host_var_type_list :
	/*empty*/
	| host_var_type_item
	| host_var_type_list ',' /*1R*/ host_var_type_item
	;

host_var_type_item :
	proc_arg_data_type TOK_NULL
	| proc_arg_data_type TOK_NOT TOK_NULL
	| literal_negatable
	;

procedure_stmt :
	TOK_PROCEDURE identifier argList_establishment sql_statement
	;

argList_establishment :
	'(' proc_arg_decls ')'
	;

proc_arg_decl :
	HOSTVAR proc_arg_data_type
	| identifier proc_arg_data_type
	;

proc_arg_decls :
	/*empty*/
	| proc_arg_decl
	| proc_arg_decls ',' /*1R*/ proc_arg_decl
	;

module_statement :
	TOK_MODULE module_name TOK_NAMES TOK_ARE identifier
	| TOK_MODULE module_name
	;

source_file_statement :
	TOK_SOURCE_FILE QUOTED_STRING
	;

module_timestamp :
	TOK_TIMESTAMP TOK_DEFINITION left_largeint_right
	;

dealloc_stmt_statement :
	TOK_DEALLOCATE TOK_PREPARE entity_name
	;

dealloc_desc_statement :
	TOK_DEALLOCATE TOK_DESCRIPTOR entity_name
	;

close_statement :
	TOK_CLOSE entity_name
	;

simple_value_spec :
	literal_as_string
	| simple_host_variable
	;

alloc_desc_statement :
	TOK_ALLOCATE TOK_DESCRIPTOR entity_name TOK_WITH TOK_MAX simple_value_spec
	| TOK_ALLOCATE TOK_DESCRIPTOR entity_name
	;

get_desccount_statement :
	TOK_GET TOK_DESCRIPTOR entity_name simple_host_variable '=' /*5L*/ TOK_COUNT
	;

get_rowsetsize_statement :
	TOK_GET TOK_DESCRIPTOR entity_name simple_host_variable '=' /*5L*/ TOK_ROWSET_SIZE
	;

get_info_item_list :
	get_info_item
	| get_info_item_list ',' /*1R*/ get_info_item
	;

get_info_item :
	simple_host_variable '=' /*5L*/ info_item_name
	;

info_item_name :
	TOK_TYPE
	| TOK_TYPE_ANSI
	| TOK_TYPE_FS
	| TOK_DATETIME_CODE
	| TOK_LENGTH
	| TOK_OCTET_LENGTH
	| TOK_PRECISION
	| TOK_SCALE
	| TOK_LEADING_PRECISION
	| TOK_NULLABLE
	| TOK_CHAR TOK_SET
	| TOK_CHARACTER TOK_SET
	| TOK_CHARACTER_SET_CATALOG
	| TOK_CHARACTER_SET_SCHEMA
	| TOK_CHARACTER_SET_NAME
	| TOK_COLLATION
	| TOK_COLLATION_CATALOG
	| TOK_COLLATION_SCHEMA
	| TOK_COLLATION_NAME
	| TOK_NAME
	| TOK_UNNAMED
	| TOK_HEADING
	| TOK_INDICATOR_TYPE
	| TOK_VARIABLE_POINTER
	| TOK_ROWSET_VAR_LAYOUT_SIZE
	| TOK_INDICATOR_POINTER
	| TOK_ROWSET_IND_LAYOUT_SIZE
	| TOK_RETURNED_LENGTH
	| TOK_RETURNED_OCTET_LENGTH
	| TOK_DATA
	| TOK_VARIABLE_DATA
	| TOK_INDICATOR
	| TOK_INDICATOR_DATA
	| TOK_PARAMETER_MODE
	| TOK_PARAMETER_ORDINAL_POSITION
	| TOK_PARAMETER_INDEX
	| TOK_DATA_OFFSET
	| TOK_NULL_IND_OFFSET
	| TOK_ALIGNED_LENGTH
	;

get_descitem_statement :
	TOK_GET TOK_DESCRIPTOR entity_name TOK_VALUE simple_value_spec get_info_item_list
	;

set_desccount_statement :
	TOK_SET TOK_DESCRIPTOR entity_name TOK_COUNT '=' /*5L*/ simple_value_spec
	;

set_rowsetsize_statement :
	TOK_SET TOK_DESCRIPTOR entity_name TOK_ROWSET_SIZE '=' /*5L*/ simple_value_spec
	;

set_info_item_list :
	set_info_item
	| set_info_item_list ',' /*1R*/ set_info_item
	;

set_info_item :
	info_item_name '=' /*5L*/ simple_value_spec
	;

set_descitem_statement :
	TOK_SET TOK_DESCRIPTOR entity_name TOK_VALUE simple_value_spec set_info_item_list
	;

stmt_info_item_list :
	stmt_info_item
	| stmt_info_item_list ',' /*1R*/ stmt_info_item
	;

stmt_info_item :
	simple_host_variable '=' /*5L*/ stmt_info_item_name
	;

stmt_info_item_name :
	TOK_NUMBER
	| TOK_MORE
	| TOK_COMMAND_FUNCTION
	| TOK_DYNAMIC_FUNCTION
	| TOK_ROW_COUNT
	| TOK_AVERAGE_STREAM_WAIT
	| TOK_COST
	| TOK_FIRST_FSCODE
	| TOK_LAST_FSCODE
	| TOK_LAST_SYSKEY
	;

get_stmtdiags_statement :
	TOK_GET TOK_DIAGNOSTICS stmt_info_item_list
	;

cond_info_item_list :
	cond_info_item
	| cond_info_item_list ',' /*1R*/ cond_info_item
	;

cond_info_item :
	simple_host_variable '=' /*5L*/ cond_info_item_name
	;

cond_info_item_name :
	TOK_CONDITION_NUMBER
	| TOK_SQLCODE
	| TOK_RETURNED_SQLSTATE
	| TOK_CLASS_ORIGIN
	| TOK_SUBCLASS_ORIGIN
	| TOK_SERVER_NAME
	| TOK_CONNECTION_NAME
	| TOK_CONSTRAINT_CATALOG
	| TOK_CONSTRAINT_SCHEMA
	| TOK_CONSTRAINT_NAME
	| TOK_TRIGGER_CATALOG
	| TOK_TRIGGER_SCHEMA
	| TOK_TRIGGER_NAME
	| TOK_NSK_CODE
	| TOK_CATALOG_NAME
	| TOK_SCHEMA_NAME
	| TOK_TABLE_NAME
	| TOK_COLUMN_NAME
	| TOK_CURSOR_NAME
	| TOK_MESSAGE_TEXT
	| TOK_MESSAGE_LEN
	| TOK_MESSAGE_OCTET_LEN
	| TOK_COLUMN_NUMBER
	| TOK_NATIVE
	| TOK_ROW_NUMBER
	| TOK_SOURCE_FILE
	| TOK_LINE_NUMBER
	| TOK_SUBSYSTEM_ID
	;

get_conddiags_statement :
	TOK_GET TOK_DIAGNOSTICS TOK_EXCEPTION simple_value_spec cond_info_item_list
	;

table_name :
	special_table_name
	| actual_table_name
	| exception_table_name
	;

special_index_table_name :
	TOK_TABLE '(' TOK_INDEX_TABLE actual_table_name optional_special_table_loc_clause optional_special_utility_open_clause optional_with_shared_access_clause ')'
	| TOK_TABLE '(' ghost TOK_INDEX_TABLE actual_table_name optional_special_table_loc_clause optional_special_utility_open_clause optional_with_shared_access_clause ')'
	;

special_regular_table_name :
	TOK_TABLE '(' TOK_TABLE actual_table_name optional_special_table_loc_clause optional_special_utility_open_clause optional_with_shared_access_clause ')'
	;

special_table_name :
	special_regular_table_name
	| special_index_table_name
	| TOK_TABLE '(' TOK_TEMP_TABLE actual_table_name optional_special_table_loc_clause ')'
	| TOK_TABLE '(' TOK_MV_TABLE actual_table_name optional_special_table_loc_clause ')'
	| TOK_TABLE '(' TOK_IUD_LOG_TABLE actual_table_name optional_special_table_loc_clause ')'
	| TOK_TABLE '(' TOK_GHOST TOK_IUD_LOG_TABLE actual_table_name optional_special_table_loc_clause ')'
	| TOK_TABLE '(' TOK_RANGE_LOG_TABLE actual_table_name optional_special_table_loc_clause ')'
	| TOK_TABLE '(' TOK_MVS_UMD actual_table_name optional_special_table_loc_clause ')'
	| TOK_TABLE '(' ghost TOK_TABLE actual_table_name optional_special_table_loc_clause ')'
	| TOK_TABLE '(' ghost TOK_MV_TABLE actual_table_name optional_special_table_loc_clause ')'
	| TOK_TABLE '(' TOK_EXCEPTION_TABLE actual_table_name optional_special_table_loc_clause ')'
	| TOK_TABLE '(' TOK_SG_TABLE actual_table_name ')'
	| TOK_TABLE '(' TOK_HBMAP_TABLE actual_table_name ')'
	;

exception_table_name :
	TOK_EXCEPTION TOK_TABLE actual_table_name
	;

optional_special_table_loc_clause :
	empty
	| ',' /*1R*/ special_table_loc_clause
	;

optional_special_utility_open_clause :
	empty
	| TOK_OPEN NUMERIC_LITERAL_EXACT_NO_SCALE
	;

optional_with_shared_access_clause :
	empty
	| TOK_WITH TOK_SHARED TOK_ACCESS
	;

special_table_loc_clause :
	TOK_LOCATION fully_expanded_guardian_loc_name
	| TOK_PARTITION partition_name
	| TOK_PARTITION TOK_NAME partition_name
	| TOK_PARTITION TOK_NUMBER NUMERIC_LITERAL_EXACT_NO_SCALE
	| TOK_PARTITION TOK_NUMBER TOK_FROM NUMERIC_LITERAL_EXACT_NO_SCALE TOK_TO NUMERIC_LITERAL_EXACT_NO_SCALE
	| TOK_PARTITION TOK_NUMBER TOK_FROM NUMERIC_LITERAL_EXACT_NO_SCALE
	| TOK_PARTITION TOK_NUMBER TOK_TO NUMERIC_LITERAL_EXACT_NO_SCALE
	;

fully_expanded_guardian_loc_name :
	guardian_location_name
	;

actual_table_name :
	qualified_name
	| '=' /*5L*/ identifier
	| hostvar_and_prototype
	| param_and_prototype
	;

actual_routine_name :
	qualified_name
	;

actual_routine_action_name :
	routine_action_name
	;

actual_table_name2 :
	qualified_name
	| hostvar_and_prototype
	;

identifier :
	regular_identifier
	| DELIMITED_IDENTIFIER
	| BACKQUOTED_IDENTIFIER
	;

identifier_with_hat :
	regular_identifier
	| DELIMITED_IDENTIFIER
	;

identifier_with_dollar :
	regular_identifier
	| DELIMITED_IDENTIFIER
	;

regular_identifier :
	IDENTIFIER
	| nonreserved_word
	| nonreserved_func_word
	| MP_nonreserved_word
	| MP_nonreserved_func_word
	| nonreserved_datatype
	;

regular_identifier_not_builtin :
	IDENTIFIER
	| nonreserved_word
	| MP_nonreserved_word
	| nonreserved_datatype
	;

qualified_name :
	identifier
	| qualified_name '.' /*9L*/ identifier
	;

module_name :
	identifier_with_hat
	| qualified_name '.' /*9L*/ identifier_with_hat
	;

routine_action_name :
	identifier_with_dollar
	| qualified_name '.' /*9L*/ identifier_with_dollar
	;

correlation_name :
	identifier
	;

table_as_procedure :
	TOK_TABLE '(' TOK_INTERNALSP '(' character_string_literal ')' ')'
	| TOK_TABLE '(' TOK_INTERNALSP '(' character_string_literal ',' /*1R*/ value_expression_list ')' ')'
	| TOK_TABLE '(' proc_identifier '(' value_expression_list ')' ')'
	| TOK_TABLE '(' TOK_HIVEMD '(' hivemd_identifier ')' ')'
	| TOK_TABLE '(' TOK_HIVEMD '(' hivemd_identifier ',' /*1R*/ identifier ')' ')'
	| TOK_TABLE '(' TOK_HIVEMD '(' hivemd_identifier ',' /*1R*/ identifier ',' /*1R*/ identifier ')' ')'
	| TOK_TABLE '(' TOK_QUERY_CACHE '(' value_expression_list ')' ')'
	| TOK_TABLE '(' TOK_QUERY_CACHE_ENTRIES '(' value_expression_list ')' ')'
	| TOK_TABLE '(' TOK_HYBRID_QUERY_CACHE '(' value_expression_list ')' ')'
	| TOK_TABLE '(' TOK_HYBRID_QUERY_CACHE_ENTRIES '(' value_expression_list ')' ')'
	| TOK_TABLE '(' TOK_CATMAN_CACHE '(' ')' ')'
	| TOK_TABLE '(' TOK_NATABLE_CACHE '(' value_expression_list ')' ')'
	| TOK_TABLE '(' TOK_NATABLE_CACHE_ENTRIES '(' value_expression_list ')' ')'
	| TOK_TABLE '(' TOK_NAROUTINE_CACHE '(' value_expression_list ')' ')'
	| TOK_TABLE '(' TOK_NAROUTINE_ACTION_CACHE '(' value_expression_list ')' ')'
	| TOK_TABLE '(' TOK_VERSION_INFO '(' value_expression_list ')' ')'
	| TOK_TABLE '(' TOK_RELATEDNESS '(' value_expression_list ')' ')'
	| TOK_TABLE '(' TOK_FEATURE_VERSION_INFO '(' value_expression_list ')' ')'
	| sp_proxy_stmt_prefix '(' proxy_columns ')' ')'
	| sp_proxy_stmt_prefix '(' proxy_columns ',' /*1R*/ spproxy_string_list ')' ')'
	| TOK_TABLE '(' TOK_EXTRACT_SOURCE '(' extract_type ',' /*1R*/ QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ proxy_columns ')' ')'
	| TOK_TABLE '(' TOK_LOB QUOTED_STRING ')'
	| TOK_TABLE '(' TOK_CLUSTER stats_or_statistics '(' ')' ')'
	| TOK_TABLE '(' TOK_REGION stats_or_statistics '(' ')' ')'
	| TOK_TABLE '(' TOK_REGION stats_or_statistics '(' table_name ')' ')'
	| TOK_TABLE '(' TOK_REGION stats_or_statistics '(' TOK_INDEX table_name ')' ')'
	| TOK_TABLE '(' TOK_LOB stats_or_statistics '(' ')' ')'
	| TOK_TABLE '(' TOK_LOB stats_or_statistics '(' table_name ')' ')'
	| TOK_TABLE '(' TOK_REGION stats_or_statistics '(' TOK_USING rel_subquery ')' ')'
	;

hivemd_identifier :
	TOK_ALIAS
	| TOK_COLUMNS
	| TOK_PRIMARY TOK_KEY
	| TOK_FOREIGN TOK_KEY
	| TOK_SYNONYMS
	| TOK_TABLES
	| TOK_VIEWS
	| TOK_SYSTEM TOK_TABLES
	| TOK_SCHEMAS
	;

sp_proxy_stmt_prefix :
	TOK_TABLE '(' TOK_SP_RESULT_SET
	;

extract_type :
	QUOTED_STRING
	;

proxy_column :
	qualified_name data_type optional_column_attributes
	;

proxy_columns :
	proxy_column
	| proxy_columns ',' /*1R*/ proxy_column
	;

spproxy_string :
	QUOTED_STRING
	;

spproxy_string_list :
	spproxy_string
	| spproxy_string_list ',' /*1R*/ spproxy_string
	;

table_as_stream_any :
	table_as_stream
	| table_as_stream TOK_AFTER TOK_LAST TOK_ROW
	;

table_as_stream :
	TOK_STREAM '(' table_name optimizer_hint ')'
	;

proc_identifier :
	TOK_EXPLAIN
	| TOK_STATISTICS
	;

rowset_input_host_variable :
	hostvar_expression
	;

rowset_input_host_variable_list :
	rowset_input_host_variable
	| rowset_input_host_variable ',' /*1R*/ rowset_input_host_variable_list
	;

rowset_size :
	unsigned_integer
	| simple_host_variable
	| dynamic_parameter
	;

rowset_derived_table :
	TOK_ROWSET '(' rowset_input_host_variable_list ')'
	| TOK_ROWSET '(' rowset_input_host_variable_list ')' rowset_index
	| TOK_ROWSET rowset_size '(' rowset_input_host_variable_list ')'
	| TOK_ROWSET rowset_size '(' rowset_input_host_variable_list ')' rowset_index
	;

global_hint :
	empty
	| TOK_BEGIN_HINT TOK_ORDERED TOK_END_HINT
	;

hbase_access_options :
	empty
	| '{' TOK_VERSIONS NUMERIC_LITERAL_EXACT_NO_SCALE '}'
	| '{' TOK_VERSIONS TOK_MAX '}'
	| '{' TOK_VERSIONS TOK_ALL '}'
	;

optimizer_hint :
	empty
	| TOK_BEGIN_HINT hints TOK_END_HINT
	;

hints :
	TOK_CARDINALITY number
	| TOK_INDEX index_hints
	| TOK_SELECTIVITY number
	| TOK_CARDINALITY number TOK_BITOR_OPERATOR TOK_INDEX index_hints
	| TOK_CARDINALITY number TOK_BITOR_OPERATOR TOK_SELECTIVITY number
	| TOK_INDEX index_hints TOK_BITOR_OPERATOR TOK_CARDINALITY number
	| TOK_INDEX index_hints TOK_BITOR_OPERATOR TOK_SELECTIVITY number
	| TOK_SELECTIVITY number TOK_BITOR_OPERATOR TOK_INDEX index_hints
	| TOK_SELECTIVITY number TOK_BITOR_OPERATOR TOK_CARDINALITY number
	| TOK_CARDINALITY number TOK_BITOR_OPERATOR TOK_INDEX index_hints TOK_BITOR_OPERATOR TOK_SELECTIVITY number
	| TOK_CARDINALITY number TOK_BITOR_OPERATOR TOK_SELECTIVITY number TOK_BITOR_OPERATOR TOK_INDEX index_hints
	| TOK_INDEX index_hints TOK_BITOR_OPERATOR TOK_CARDINALITY number TOK_BITOR_OPERATOR TOK_SELECTIVITY number
	| TOK_INDEX index_hints TOK_BITOR_OPERATOR TOK_SELECTIVITY number TOK_BITOR_OPERATOR TOK_CARDINALITY number
	| TOK_SELECTIVITY number TOK_BITOR_OPERATOR TOK_INDEX index_hints TOK_BITOR_OPERATOR TOK_CARDINALITY number
	| TOK_SELECTIVITY number TOK_BITOR_OPERATOR TOK_CARDINALITY number TOK_BITOR_OPERATOR TOK_INDEX index_hints
	;

number :
	NUMERIC_LITERAL_APPROX
	| NUMERIC_LITERAL_EXACT_WITH_SCALE
	;

index_hints :
	index_hint
	| index_hints ',' /*1R*/ index_hint
	;

index_hint :
	qualified_name
	;

table_reference :
	table_name_and_hint
	| table_as_procedure
	| table_as_procedure as_clause
	| table_as_procedure as_clause '(' derived_column_list ')'
	| table_as_stream_any
	| table_as_stream_any as_clause
	| table_as_stream_any as_clause '(' derived_column_list ')'
	| upd_stmt_w_acc_type_and_as_clause
	| upd_stmt_w_acc_type_and_as_clause_col_list
	| upd_stmt_w_acc_type_rtn_list_and_as_clause
	| upd_stmt_w_acc_type_rtn_list_and_as_clause_col_list
	| del_stmt_w_acc_type_and_as_clause
	| del_stmt_w_acc_type_and_as_clause_col_list
	| del_stmt_w_acc_type_rtn_list_and_as_clause
	| del_stmt_w_acc_type_rtn_list_and_as_clause_col_list
	| '(' front_of_insert TOK_WITH TOK_MTS TOK_INTO table_name query_expression ')' as_clause
	| '(' front_of_insert TOK_WITH TOK_MTS TOK_INTO table_name query_expression ')' as_clause '(' derived_column_list ')'
	| '(' Front_Of_Insert Rest_Of_insert_statement ')' as_clause
	| '(' Front_Of_Insert Rest_Of_insert_statement ')' as_clause '(' derived_column_list ')'
	| table_name_as_clause_and_hint
	| table_name_as_clause_hint_and_col_list
	| '(' exe_util_get_statistics ')' as_clause '(' derived_column_list ')'
	| '(' exe_util_get_metadata_info ')' as_clause '(' derived_column_list ')'
	| '(' exe_util_get_version_info ')' as_clause '(' derived_column_list ')'
	| '(' exe_util_get_uid ')' as_clause '(' derived_column_list ')'
	| rel_subquery_and_as_clause
	| rel_subquery_as_clause_and_col_list
	| rel_subquery
	| joined_table
	| rowset_derived_table as_clause '(' derived_column_list ')'
	| table_as_tmudf_function
	| table_as_tmudf_function as_clause
	| table_as_tmudf_function as_clause '(' derived_column_list ')'
	| TOK_DUAL
	;

table_as_tmudf_function :
	TOK_UDF '(' table_mapping_function_invocation ')'
	;

table_name_and_hint :
	table_name optimizer_hint hbase_access_options
	| '(' table_name_and_hint ')'
	;

upd_stmt_w_acc_type_and_as_clause :
	'(' update_statement_searched access_type ')' as_clause
	| '(' upd_stmt_w_acc_type_and_as_clause ')'
	;

upd_stmt_w_acc_type_and_as_clause_col_list :
	'(' update_statement_searched access_type ')' as_clause '(' derived_column_list ')'
	| '(' upd_stmt_w_acc_type_and_as_clause_col_list ')'
	;

upd_stmt_w_acc_type_rtn_list_and_as_clause :
	'(' update_statement_searched access_type return_list ')' as_clause
	| '(' upd_stmt_w_acc_type_rtn_list_and_as_clause ')'
	;

upd_stmt_w_acc_type_rtn_list_and_as_clause_col_list :
	'(' update_statement_searched access_type return_list ')' as_clause '(' derived_column_list ')'
	| '(' upd_stmt_w_acc_type_rtn_list_and_as_clause_col_list ')'
	;

del_stmt_w_acc_type_and_as_clause :
	'(' delete_statement access_type ')' as_clause
	| '(' del_stmt_w_acc_type_and_as_clause ')'
	;

del_stmt_w_acc_type_and_as_clause_col_list :
	'(' delete_statement access_type ')' as_clause '(' derived_column_list ')'
	| '(' del_stmt_w_acc_type_and_as_clause_col_list ')'
	;

del_stmt_w_acc_type_rtn_list_and_as_clause :
	'(' delete_statement access_type return_list ')' as_clause
	| '(' del_stmt_w_acc_type_rtn_list_and_as_clause ')'
	;

del_stmt_w_acc_type_rtn_list_and_as_clause_col_list :
	'(' delete_statement access_type return_list ')' as_clause '(' derived_column_list ')'
	| '(' del_stmt_w_acc_type_rtn_list_and_as_clause_col_list ')'
	;

table_name_as_clause_and_hint :
	table_name as_clause optimizer_hint hbase_access_options
	| '(' table_name_as_clause_and_hint ')'
	;

table_name_as_clause_hint_and_col_list :
	table_name as_clause optimizer_hint hbase_access_options '(' derived_column_list ')'
	| '(' table_name_as_clause_hint_and_col_list ')'
	;

rel_subquery_and_as_clause :
	rel_subquery as_clause
	| '(' rel_subquery_and_as_clause ')'
	;

with_clause :
	TOK_WITH with_clause_elements
	| TOK_WITH TOK_RECURSIVE with_clause_elements
	;

with_clause_elements :
	with_clause_element
	| with_clause_elements ',' /*1R*/ with_clause_element
	;

with_clause_element :
	correlation_name TOK_AS '(' query_expression ')'
	;

rel_subquery_as_clause_and_col_list :
	rel_subquery as_clause '(' derived_column_list ')'
	| '(' rel_subquery_as_clause_and_col_list ')'
	;

joined_table_needing_spec :
	joined_table_needing_spec2
	;

joined_table_needing_spec2 :
	table_reference TOK_JOIN /*3L*/ table_reference
	| table_reference TOK_INNER /*3L*/ TOK_JOIN /*3L*/ table_reference
	| table_reference left_outer TOK_JOIN /*3L*/ table_reference
	| table_reference right_outer TOK_JOIN /*3L*/ table_reference
	| table_reference full_outer TOK_JOIN /*3L*/ table_reference
	;

joined_table :
	'(' joined_table ')'
	| '{' TOK_OJ joined_table '}'
	| table_reference TOK_CROSS /*3L*/ TOK_JOIN /*3L*/ table_reference
	| joined_table_needing_spec join_specification
	| table_reference TOK_NATURAL /*3L*/ TOK_JOIN /*3L*/ table_reference
	| table_reference TOK_NATURAL /*3L*/ TOK_INNER /*3L*/ TOK_JOIN /*3L*/ table_reference
	| table_reference TOK_NATURAL /*3L*/ left_outer TOK_JOIN /*3L*/ table_reference
	| table_reference TOK_NATURAL /*3L*/ right_outer TOK_JOIN /*3L*/ table_reference
	| table_reference TOK_NATURAL /*3L*/ full_outer TOK_JOIN /*3L*/ table_reference
	| table_reference TOK_UNION_JOIN /*3L*/ table_reference
	;

full_outer :
	TOK_FULL /*3L*/
	| TOK_FULL /*3L*/ TOK_OUTER
	;

right_outer :
	TOK_RIGHT /*3L*/
	| TOK_RIGHT /*3L*/ TOK_OUTER
	;

left_outer :
	TOK_LEFT /*3L*/
	| TOK_LEFT /*3L*/ TOK_OUTER
	;

derived_column_list :
	identifier
	| identifier ',' /*1R*/ derived_column_list
	;

set_function_specification :
	set_function_type '(' set_quantifier value_expression ')'
	| set_function_type '(' set_quantifier value_expression ',' /*1R*/ value_expression ')'
	| set_function_type '(' '*' /*8L*/ ')'
	| TOK_GROUP_CONCAT '(' set_quantifier value_expression concat_options ')'
	| TOK_PIVOT '(' set_quantifier value_expression pivot_options ')'
	| TOK_PIVOT_GROUP '(' set_quantifier value_expression pivot_options ')'
	| TOK_XMLAGG '(' TOK_XMLELEMENT '(' identifier ',' /*1R*/ value_expression ')' order_by_clause ')' '.' /*9L*/ TOK_EXTRACT '(' QUOTED_STRING ')' '.' /*9L*/ identifier '(' ')'
	;

set_function_type :
	TOK_AVG
	| TOK_MAX
	| TOK_MIN
	| TOK_SUM
	| TOK_COUNT
	| TOK_VARIANCE
	| TOK_STDDEV
	| TOK_GROUPING
	;

concat_options :
	empty
	| concat_options_list
	;

pivot_options :
	empty
	| ',' /*1R*/ pivot_options_list
	;

concat_options_list :
	concat_option
	| concat_option concat_options_list
	;

pivot_options_list :
	pivot_option
	| pivot_option ',' /*1R*/ pivot_options_list
	;

concat_option :
	TOK_SEPARATOR QUOTED_STRING
	| TOK_ORDER TOK_BY sort_spec_list
	| TOK_MAX TOK_LENGTH NUMERIC_LITERAL_EXACT_NO_SCALE
	;

pivot_option :
	TOK_DELIMITER QUOTED_STRING
	| TOK_ORDER TOK_BY '(' sort_spec_list ')'
	| TOK_MAX TOK_LENGTH NUMERIC_LITERAL_EXACT_NO_SCALE
	;

sequence_func_specification :
	offset_sequence_function
	| this_sequence_function
	| moving_sequence_function
	| running_sequence_function
	| olap_sequence_function
	;

this_sequence_function :
	TOK_THIS '(' value_expression ')'
	;

offset_sequence_function :
	TOK_OFFSET '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_OFFSET '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	| TOK_DIFF1 '(' value_expression ')'
	| TOK_DIFF1 '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_DIFF2 '(' value_expression ')'
	| TOK_DIFF2 '(' value_expression ',' /*1R*/ value_expression ')'
	;

running_sequence_function :
	TOK_RCOUNT '(' '*' /*8L*/ ')'
	| TOK_RCOUNT '(' value_expression ')'
	| TOK_ROWS TOK_SINCE TOK_CHANGED '(' value_expression_list ')'
	| running_func_type '(' value_expression ')'
	| TOK_RRANK '(' sort_by_value_expression_list ')'
	;

running_func_type :
	TOK_RAVG
	| TOK_LASTNOTNULL
	| TOK_RMAX
	| TOK_RMIN
	| TOK_RSTDDEV
	| TOK_RSUM
	| TOK_RVARIANCE
	;

moving_sequence_function :
	TOK_ROWS TOK_SINCE '(' search_condition ')'
	| TOK_ROWS TOK_SINCE '(' search_condition ',' /*1R*/ value_expression ')'
	| TOK_ROWS TOK_SINCE TOK_INCLUSIVE '(' search_condition ')'
	| TOK_ROWS TOK_SINCE TOK_INCLUSIVE '(' search_condition ',' /*1R*/ value_expression ')'
	| TOK_MCOUNT '(' '*' /*8L*/ ',' /*1R*/ value_expression ')'
	| TOK_MCOUNT '(' '*' /*8L*/ ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	| TOK_MCOUNT '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_MCOUNT '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	| moving_func_type '(' value_expression ',' /*1R*/ value_expression ')'
	| moving_func_type '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	;

moving_func_type :
	TOK_MAVG
	| TOK_MMAX
	| TOK_MMIN
	| TOK_MSTDDEV
	| TOK_MSUM
	| TOK_MVARIANCE
	| TOK_MRANK
	;

olap_sequence_function :
	set_function_specification TOK_OVER '(' opt_olap_part_clause opt_olap_order_clause ')'
	| set_function_specification TOK_OVER '(' opt_olap_part_clause opt_olap_order_clause TOK_ROWS olap_rows_spec ')'
	| set_function_specification TOK_OVER '(' opt_olap_part_clause opt_olap_order_clause TOK_ROWS TOK_BETWEEN olap_rows_spec TOK_AND /*6L*/ olap_rows_spec ')'
	| TOK_RRANK '(' ')' TOK_OVER '(' opt_olap_part_clause opt_olap_order_clause ')'
	| TOK_D_RANK '(' ')' TOK_OVER '(' opt_olap_part_clause opt_olap_order_clause ')'
	| TOK_ROW_NUMBER '(' ')' TOK_OVER '(' opt_olap_part_clause opt_olap_order_clause ')'
	| TOK_LEAD '(' value_expression ')' TOK_OVER '(' opt_olap_part_clause opt_olap_order_clause ')'
	| TOK_LEAD '(' value_expression ',' /*1R*/ value_expression ')' TOK_OVER '(' opt_olap_part_clause opt_olap_order_clause ')'
	| TOK_LEAD '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')' TOK_OVER '(' opt_olap_part_clause opt_olap_order_clause ')'
	| TOK_LAG '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')' TOK_OVER '(' opt_olap_part_clause opt_olap_order_clause ')'
	| TOK_LAG '(' value_expression ',' /*1R*/ value_expression ')' TOK_OVER '(' opt_olap_part_clause opt_olap_order_clause ')'
	| TOK_LAG '(' value_expression ')' TOK_OVER '(' opt_olap_part_clause opt_olap_order_clause ')'
	;

opt_olap_part_clause :
	empty
	| TOK_PARTITION_BY value_expression_list
	;

opt_olap_order_clause :
	empty
	| TOK_ORDER TOK_BY sort_by_value_expression_list
	;

olap_rows_spec :
	TOK_UNBOUNDED olap_prec_follow
	| unsigned_smallint olap_prec_follow
	| TOK_CURRENT TOK_ROW
	;

olap_prec_follow :
	TOK_PRECEDING
	| TOK_FOLLOWING
	;

value_expression_list :
	value_expression %prec ',' /*1R*/
	| value_expression_list_comma %prec ',' /*1R*/
	| value_expression_list_paren %prec ',' /*1R*/
	;

value_expression_list_paren :
	'(' value_expression_list_comma ')'
	| '(' value_expression_list_paren ')'
	;

value_expression_list_comma :
	value_expression ',' /*1R*/ value_expression
	| value_expression ',' /*1R*/ value_expression_list_comma
	| value_expression ',' /*1R*/ value_expression as_clause
	| value_expression ',' /*1R*/ HOSTVAR TOK_PROTOTYPE
	| value_expression ',' /*1R*/ SYSTEM_VOLUME_NAME
	| value_expression ',' /*1R*/ DOLLAR_IDENTIFIER
	;

value_expression_list_lr :
	value_expression
	| value_expression_list_lr ',' /*1R*/ value_expression
	;

value_expression :
	value_expression_sans_collate collation_option
	;

value_expression_sans_collate :
	term
	| value_expression '+' /*7L*/ term
	| value_expression '-' /*7L*/ term
	| value_expression TOK_CONCATENATION term
	| value_expression '&' term
	| value_expression TOK_BITOR_OPERATOR term
	| value_expression '^' term
	| '~' term
	;

term :
	factor1
	| term '*' /*8L*/ factor1
	| term '/' /*8L*/ factor1
	;

factor1 :
	factor
	| factor TOK_EXPONENTIATE factor1
	;

factor :
	sign primary
	| '!' primary
	| primary
	| primary TOK_LPAREN_BEFORE_FORMAT TOK_FORMAT character_string_literal ')'
	| primary TOK_LPAREN_BEFORE_FORMAT TOK_FORMAT character_string_literal ')' TOK_LPAREN_BEFORE_DATATYPE data_type ')'
	| primary TOK_LPAREN_BEFORE_FORMAT TOK_FORMAT character_string_literal ',' /*1R*/ TOK_TITLE character_string_literal ')'
	| primary TOK_LPAREN_BEFORE_FORMAT TOK_FORMAT character_string_literal ',' /*1R*/ TOK_TITLE character_string_literal ')' TOK_LPAREN_BEFORE_DATATYPE data_type ')'
	| primary TOK_LPAREN_BEFORE_NAMED TOK_NAMED correlation_name ')'
	| primary TOK_LPAREN_BEFORE_DATATYPE data_type optional_cast_spec_not_null_spec ')'
	;

row_subquery :
	rel_subquery
	| '(' row_subquery ')'
	;

primary :
	'(' value_expression ')'
	| '(' value_expression ')' interval_qualifier
	| row_subquery
	| dml_column_reference
	| dml_column_reference TOK_LPAREN_BEFORE_DATE_COMMA_AND_FORMAT TOK_DATE ',' /*1R*/ TOK_FORMAT character_string_literal ')'
	| hostvar_expression
	| literal
	| dynamic_parameter
	| dynamic_parameter_array
	| internal_arith_placeholder
	| set_function_specification
	| sequence_func_specification
	| cast_specification
	| value_function
	| '{' TOK_FN set_function_specification '}'
	| '{' TOK_FN value_function '}'
	| '{' TOK_FN TOK_LENGTH '(' value_expression ')' '}'
	| '{' TOK_FN cast_specification '}'
	| TOK_USERNAMEINTTOEXT '(' value_expression ')'
	| TOK_DEFAULT
	| null_constant
	;

null_constant :
	TOK_NULL
	;

value_function :
	builtin_function_user
	| datetime_misc_function
	| datetime_misc_function_used_as_default
	| datetime_value_function
	| math_function
	| misc_function
	| string_function
	| user_defined_scalar_function
	| select_lob_to_obj_function
	;

user_defined_function_name :
	regular_identifier_not_builtin
	| DELIMITED_IDENTIFIER
	| qualified_name '.' /*9L*/ regular_identifier_not_builtin
	;

user_defined_scalar_function :
	user_defined_function_name '(' udr_value_expression_list ')'
	;

table_mapping_function_invocation :
	qualified_name '(' tmudf_table_expression ',' /*1R*/ tmudf_table_expression optional_tmudf_param_list_with_comma ')'
	| qualified_name '(' tmudf_table_expression optional_tmudf_param_list_with_comma ')'
	| qualified_name '(' optional_tmudf_param_list ')'
	;

tmudf_table_expression :
	TOK_TABLE '(' tmudf_query_expression ')'
	| TOK_TABLE '(' tmudf_query_expression ')' as_clause
	| TOK_TABLE '(' tmudf_query_expression ')' as_clause '(' derived_column_list ')'
	;

tmudf_query_expression :
	query_specification optional_tmudf_order_by
	| query_specification TOK_PARTITION_BY value_expression_list optional_tmudf_order_by
	| query_specification TOK_NO_PARTITION optional_tmudf_order_by
	| query_specification TOK_REPLICATE_PARTITION optional_tmudf_order_by
	;

optional_tmudf_order_by :
	empty
	| TOK_ORDER TOK_BY sort_by_value_expression_list
	;

optional_tmudf_param_list_with_comma :
	empty
	| ',' /*1R*/ tmudf_param_list
	;

optional_tmudf_param_list :
	empty
	| tmudf_param_list
	;

tmudf_param_list :
	tmudf_param
	| tmudf_param ',' /*1R*/ tmudf_param_list
	;

tmudf_param :
	value_expression
	;

udr_value_expression_list :
	value_expression
	| table_name_dot_star
	| value_expression ',' /*1R*/ udr_value_expression_list
	| table_name_dot_star ',' /*1R*/ udr_value_expression_list
	| empty
	;

table_name_dot_star :
	actual_table_name TOK_DOT_STAR
	;

datetime_value_function :
	TOK_CURDATE '(' ')'
	| TOK_CURRENT_DATE
	| TOK_SYSDATE
	| TOK_DATE
	| TOK_TIME
	| TOK_LPAREN_BEFORE_DATE_AND_LPAREN TOK_DATE TOK_LPAREN_BEFORE_FORMAT TOK_FORMAT character_string_literal ',' /*1R*/ TOK_TITLE character_string_literal ')' ')'
	| TOK_LPAREN_BEFORE_DATE_AND_LPAREN TOK_DATE TOK_LPAREN_BEFORE_FORMAT TOK_FORMAT character_string_literal ')' ')'
	| TOK_CURRENT
	| TOK_CURRENT ts_left_unsigned_right
	| TOK_CURRENT datetime_qualifier
	| TOK_CURRENT_TIME
	| TOK_CURRENT_TIME ts_left_unsigned_right
	| TOK_CURRENT_TIMESTAMP
	| TOK_SYSTIMESTAMP
	| TOK_CURRENT_TIMESTAMP ts_left_unsigned_right
	| TOK_CURRENT_RUNNING
	| TOK_CURRENT_TIMESTAMP_RUNNING
	| TOK_CURRENT_TIMESTAMP_UTC
	| TOK_CURRENT_TIME_UTC
	| TOK_CURTIME '(' ')'
	| TOK_NOW '(' ')'
	| TOK_UNIX_TIMESTAMP '(' ')'
	| TOK_UNIX_TIMESTAMP '(' value_expression ')'
	| TOK_SYS_GUID '(' ')'
	| TOK_UUID '(' ')'
	| TOK_UUID_SHORT '(' ')'
	;

datetime_misc_function_used_as_default :
	TOK_TO_CHAR '(' value_expression ',' /*1R*/ character_string_literal ')'
	;

datetime_misc_function :
	TOK_CONVERTTIMESTAMP '(' value_expression ')'
	| TOK_DATEFORMAT '(' value_expression ',' /*1R*/ date_format ')'
	| TOK_DAYOFWEEK '(' value_expression ')'
	| TOK_DAYOFYEAR '(' value_expression ')'
	| TOK_DAYNAME '(' value_expression ')'
	| TOK_FIRSTDAYOFYEAR '(' value_expression ')'
	| TOK_DAYOFMONTH '(' value_expression ')'
	| TOK_MONTHNAME '(' value_expression ')'
	| TOK_QUARTER '(' value_expression ')'
	| TOK_WEEK '(' value_expression ')'
	| TOK_JULIANTIMESTAMP '(' value_expression ')'
	| TOK_YEAR '(' value_expression ')'
	| TOK_MONTH '(' value_expression ')'
	| TOK_DAY '(' value_expression ')'
	| TOK_HOUR '(' value_expression ')'
	| TOK_MINUTE '(' value_expression ')'
	| TOK_SECOND '(' value_expression ')'
	| TOK_EXTEND '(' value_expression ',' /*1R*/ datetime_qualifier ')'
	| TOK_EXTEND '(' value_expression ')'
	| TOK_TO_BINARY '(' value_expression ',' /*1R*/ unsigned_integer ')'
	| TOK_TO_BINARY '(' value_expression ')'
	| TOK_TO_CHAR '(' value_expression ')'
	| TOK_TO_DATE '(' value_expression ',' /*1R*/ character_string_literal ')'
	| TOK_TO_DATE '(' value_expression ')'
	| TOK_TO_NUMBER '(' value_expression ')'
	| TOK_TO_TIME '(' value_expression ',' /*1R*/ character_string_literal ')'
	| TOK_TO_TIMESTAMP '(' value_expression ')'
	| TOK_SLEEP '(' numeric_literal_exact ')'
	;

CHAR_FUNC_optional_character_set :
	',' /*1R*/ CHAR_FUNC_character_set
	| empty
	;

optional_character_set :
	',' /*1R*/ character_set
	| empty
	;

string_function :
	TOK_ASCII '(' value_expression ')'
	| TOK_CODE_VALUE '(' value_expression ')'
	| TOK_CHAR '(' value_expression CHAR_FUNC_optional_character_set ')'
	| TOK_CHR '(' value_expression CHAR_FUNC_optional_character_set ')'
	| TOK_CHAR_LENGTH '(' value_expression ')'
	| TOK_COALESCE '(' value_expression_list ')'
	| TOK_CONVERTFROMHEX '(' value_expression ')'
	| TOK_UNHEX '(' value_expression ')'
	| TOK_FROM_HEX '(' value_expression ')'
	| TOK_CONVERTTOHEX '(' value_expression ')'
	| TOK_TO_HEX '(' value_expression ')'
	| TOK_HEX '(' value_expression ')'
	| TOK_CONVERTTOHX_INTN '(' value_expression ')'
	| TOK_DECODE '(' value_expression_list ')'
	| TOK_INSERT '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	| TOK_LEFT /*3L*/ '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_LOCATE '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_LOCATE '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	| TOK_LPAD '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_LPAD '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	| TOK_RPAD '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_RPAD '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	| TOK_LTRIM '(' value_expression ')'
	| TOK_OCTET_LENGTH '(' value_expression ')'
	| TOK_POSITION '(' value_expression TOK_IN value_expression ')'
	| TOK_INSTR '(' value_expression TOK_IN value_expression ')'
	| TOK_INSTR '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_INSTR '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	| TOK_INSTR '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	| TOK_CONCAT '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_REPEAT '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_REPEAT '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	| TOK_REPLACE '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	| TOK_RIGHT /*3L*/ '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_RTRIM '(' value_expression ')'
	| TOK_RTRIM '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_SPACE '(' value_expression optional_character_set ')'
	| TOK_SUBSTRING '(' value_expression TOK_FROM value_expression ')'
	| TOK_SUBSTRING '(' value_expression TOK_FROM value_expression TOK_FOR value_expression ')'
	| TOK_SUBSTRING '(' value_expression TOK_FOR value_expression ')'
	| TOK_SUBSTRING '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	| TOK_SUBSTRING '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_SUBSTRING TOK_LPAREN_BEFORE_DATE_AND_LPAREN value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	| TOK_UCASE '(' value_expression ')'
	| TOK_UPPER '(' value_expression ')'
	| TOK_UPSHIFT '(' value_expression ')'
	| TOK_LCASE '(' value_expression ')'
	| TOK_LOWER '(' value_expression ')'
	| TOK_TRIM '(' trim_operands ')'
	| TOK_EXTRACT '(' datetime_field TOK_FROM value_expression ')'
	| TOK_CONVERTTOBITS '(' value_expression ')'
	| TOK_TOKENSTR '(' QUOTED_STRING ',' /*1R*/ value_expression ')'
	| TOK_REVERSE '(' value_expression ')'
	| TOK_OVERLAY '(' value_expression TOK_PLACING value_expression TOK_FROM value_expression TOK_FOR value_expression ')'
	| TOK_OVERLAY '(' value_expression TOK_PLACING value_expression TOK_FROM value_expression ')'
	| TOK_STUFF '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	| TOK_SPLIT_PART '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	;

builtin_function_user :
	TOK_USER
	| TOK_USER '(' ')'
	| TOK_CURRENT_USER
	| TOK_CURRNT_USR_INTN
	| TOK_SESSION_USER
	| TOK_SESSN_USR_INTN
	;

sg_identity_function :
	TOK_IDENTITY
	| TOK_INTERNAL
	| TOK_IDENTITY '(' sequence_generator_options ')'
	;

all_sequence_generator_options :
	empty
	| sequence_generator_option_list
	| reset_option
	;

sequence_generator_options :
	empty
	| sequence_generator_option_list
	;

sequence_generator_option_list :
	sequence_generator_option
	| sequence_generator_option_list sequence_generator_option
	;

sequence_generator_option :
	start_with_option
	| increment_option
	| max_value_option
	| min_value_option
	| cycle_option
	| cache_option
	| datatype_option
	;

start_with_option :
	TOK_START TOK_WITH sg_sign NUMERIC_LITERAL_EXACT_NO_SCALE
	;

max_value_option :
	TOK_MAXVALUE sg_sign NUMERIC_LITERAL_EXACT_NO_SCALE
	| TOK_NO TOK_MAXVALUE
	;

min_value_option :
	TOK_MINVALUE sg_sign NUMERIC_LITERAL_EXACT_NO_SCALE
	| TOK_NO TOK_MINVALUE
	;

increment_option :
	TOK_INCREMENT TOK_BY sg_sign NUMERIC_LITERAL_EXACT_NO_SCALE
	;

cycle_option :
	TOK_CYCLE
	| TOK_NO TOK_CYCLE
	;

reset_option :
	TOK_RESET
	;

cache_option :
	TOK_CACHE NUMERIC_LITERAL_EXACT_NO_SCALE
	| TOK_NO TOK_CACHE
	;

datatype_option :
	int_type
	;

sg_sign :
	empty
	| '+' /*7L*/
	| '-' /*7L*/
	;

optional_round_scale :
	empty
	| ',' /*1R*/ value_expression
	;

math_function :
	TOK_ABS '(' value_expression ')'
	| TOK_MOD '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_RAND '(' ')'
	| TOK_RANDOM '(' ')'
	| TOK_RAND '(' value_expression ')'
	| TOK_SIGN '(' value_expression ')'
	| TOK_TRANSLATE '(' value_expression TOK_USING regular_identifier ')'
	| TOK_ROUND '(' value_expression optional_round_scale ')'
	| TOK_ROUND '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	| TOK_BITNOT '(' value_expression ')'
	| TOK_BITAND '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_BITOR '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_BITXOR '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_BITEXTRACT '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	| TOK_LOG '(' value_expression ')'
	| TOK_LOG '(' value_expression ',' /*1R*/ value_expression ')'
	| math_func_0_operand '(' ')'
	| math_func_1_operand '(' value_expression ')'
	| math_func_2_operands '(' value_expression ',' /*1R*/ value_expression ')'
	;

math_func_0_operand :
	TOK_PI
	;

math_func_1_operand :
	TOK_ACOS
	| TOK_ASIN
	| TOK_ATAN
	| TOK_CEIL
	| TOK_CEILING
	| TOK_COS
	| TOK_COSH
	| TOK_DEGREES
	| TOK_EXP
	| TOK_FLOOR
	| TOK_LOG10
	| TOK_LOG2
	| TOK_RADIANS
	| TOK_SIN
	| TOK_SINH
	| TOK_SQRT
	| TOK_TAN
	| TOK_TANH
	;

math_func_2_operands :
	TOK_ATAN2
	| TOK_POWER
	;

misc_function :
	TOK_OS_USERID '(' value_expression ')'
	| TOK_USER '(' value_expression ')'
	| TOK_AUTHNAME '(' value_expression ')'
	| TOK_AUTHTYPE '(' value_expression ')'
	| TOK_CASE case_expression TOK_END
	| TOK_SHA '(' value_expression ')'
	| TOK_SHA1 '(' value_expression ')'
	| TOK_SHA2 '(' value_expression ',' /*1R*/ NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	| TOK_MD5 '(' value_expression ')'
	| TOK_CRC32 '(' value_expression ')'
	| TOK_GREATEST '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_LEAST '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_NULLIFZERO '(' value_expression ')'
	| TOK_ISIPV4 '(' value_expression ')'
	| TOK_ISIPV6 '(' value_expression ')'
	| TOK_INET_ATON '(' value_expression ')'
	| TOK_INET_NTOA '(' value_expression ')'
	| TOK_ISNULL '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_NVL '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_JSONOBJECTFIELDTEXT '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_NULLIF '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_QUERYID_EXTRACT '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_ZEROIFNULL '(' value_expression ')'
	| TOK_ENCODE_KEY '(' encode_key_cast_spec optional_encode_key_ordering_spec ')'
	| TOK_SOUNDEX '(' value_expression ')'
	| TOK_SORT_KEY '(' value_expression optional_Collation_type optional_sort_direction ')'
	| TOK_HASHPARTFUNC '(' value_expression_list TOK_FOR value_expression ')'
	| TOK_HASH2PARTFUNC '(' value_expression_list TOK_FOR value_expression ')'
	| TOK_RRPARTFUNC '(' value_expression TOK_FOR value_expression ')'
	| TOK_DATE_PART '(' QUOTED_STRING ',' /*1R*/ value_expression ')'
	| TOK_DATE_TRUNC '(' QUOTED_STRING ',' /*1R*/ value_expression ')'
	| TOK_TRUNC '(' value_expression ',' /*1R*/ QUOTED_STRING ')'
	| TOK_DATEDIFF '(' date_time_operand ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	| TOK_MONTHS_BETWEEN '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_TIMESTAMPDIFF '(' IDENTIFIER ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	| TOK_ADD_MONTHS '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_ADD_MONTHS '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ unsigned_integer ')'
	| TOK_DATE_ADD '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_DATEADD '(' datetime_keywords ',' /*1R*/ value_expression ')'
	| TOK_TIMESTAMPADD '(' timestamp_keywords ',' /*1R*/ value_expression ')'
	| TOK_DATE_SUB '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_LAST_DAY '(' value_expression ')'
	| TOK_NEXT_DAY '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_TRUNC '(' value_expression ',' /*1R*/ unsigned_integer ')'
	| TOK_TRUNC '(' value_expression ')'
	| TOK_TRUNCATE '(' value_expression ',' /*1R*/ unsigned_integer ')'
	| TOK_UNIQUE_ID '(' ')'
	| TOK_COLUMN_LOOKUP '(' dml_column_reference ',' /*1R*/ QUOTED_STRING ')'
	| TOK_COLUMN_LOOKUP '(' dml_column_reference ',' /*1R*/ QUOTED_STRING ',' /*1R*/ TOK_CAST TOK_AS Set_Cast_Global_False_and_data_type ')'
	| TOK_COLUMN_LOOKUP '(' dml_column_reference ',' /*1R*/ QUOTED_STRING ',' /*1R*/ TOK_TYPE TOK_AS Set_Cast_Global_False_and_data_type ')'
	| TOK_COLUMN_CREATE '(' hbase_column_create_list ')'
	| TOK_COLUMN_DISPLAY '(' dml_column_reference ')'
	| TOK_COLUMN_DISPLAY '(' dml_column_reference ',' /*1R*/ NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	| TOK_COLUMN_DISPLAY '(' dml_column_reference ',' /*1R*/ '(' quoted_string_list ')' ')'
	| TOK_COLUMN_DISPLAY '(' dml_column_reference ',' /*1R*/ '(' quoted_string_list ')' ',' /*1R*/ NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	| TOK_SEQNUM '(' ddl_qualified_name ')'
	| TOK_SEQNUM '(' ddl_qualified_name ',' /*1R*/ TOK_CURRENT ')'
	| TOK_SEQNUM '(' ddl_qualified_name ',' /*1R*/ TOK_NEXT ')'
	| TOK_ROWNUM '(' ')'
	| TOK_HBASE_VERSION '(' dml_column_reference ')'
	| TOK_HBASE_TIMESTAMP '(' dml_column_reference ')'
	| TOK_GROUPING_ID '(' value_expression_list ')'
	| TOK_AES_ENCRYPT '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	| TOK_AES_ENCRYPT '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_AES_DECRYPT '(' value_expression ',' /*1R*/ value_expression ',' /*1R*/ value_expression ')'
	| TOK_AES_DECRYPT '(' value_expression ',' /*1R*/ value_expression ')'
	| TOK_ENCODE_BASE64 '(' value_expression ')'
	| TOK_DECODE_BASE64 '(' value_expression ')'
	;

hbase_column_create_list :
	'(' hbase_column_create_value ')'
	| hbase_column_create_value
	| '(' hbase_column_create_value ')' ',' /*1R*/ hbase_column_create_list
	;

hbase_column_create_value :
	value_expression ',' /*1R*/ value_expression ',' /*1R*/ TOK_TYPE TOK_AS Set_Cast_Global_False_and_data_type
	| value_expression ',' /*1R*/ value_expression ',' /*1R*/ TOK_CAST TOK_AS data_type
	| value_expression ',' /*1R*/ value_expression
	;

date_time_operand :
	TOK_YEAR
	| TOK_MONTH
	| TOK_M
	| TOK_DAY
	| TOK_D
	| TOK_HOUR
	| TOK_MINUTE
	| TOK_SECOND
	| TOK_QUARTER
	| TOK_WEEK
	| IDENTIFIER
	;

datetime_keywords :
	TOK_QUARTER ',' /*1R*/ value_expression
	| TOK_WEEK ',' /*1R*/ value_expression
	| TOK_YEAR ',' /*1R*/ value_expression
	| TOK_MONTH ',' /*1R*/ value_expression
	| TOK_DAY ',' /*1R*/ value_expression
	| TOK_M ',' /*1R*/ value_expression
	| TOK_D ',' /*1R*/ value_expression
	| TOK_HOUR ',' /*1R*/ value_expression
	| TOK_MINUTE ',' /*1R*/ value_expression
	| TOK_SECOND ',' /*1R*/ value_expression
	| IDENTIFIER ',' /*1R*/ value_expression
	;

timestamp_keywords :
	IDENTIFIER ',' /*1R*/ value_expression
	;

encode_key_cast_spec :
	cast_specification
	| TOK_LOW_VALUE '(' data_type optional_cast_spec_not_null_spec ')'
	| TOK_HIGH_VALUE '(' data_type optional_cast_spec_not_null_spec ')'
	| TOK_LOW_VALUE TOK_LPAREN_BEFORE_DATATYPE data_type optional_cast_spec_not_null_spec ')'
	| TOK_HIGH_VALUE TOK_LPAREN_BEFORE_DATATYPE data_type optional_cast_spec_not_null_spec ')'
	;

optional_encode_key_ordering_spec :
	empty
	| TOK_ASC
	| TOK_DESC
	;

optional_Collation_type :
	empty
	| TOK_FOR TOK_SORT
	| TOK_FOR TOK_COMPARE
	| TOK_FOR TOK_STRING_SEARCH
	;

optional_sort_direction :
	empty
	| TOK_ASC
	| TOK_DESC
	;

trim_operands :
	value_expression
	| TOK_FROM value_expression
	| trim_spec TOK_FROM value_expression
	| value_expression TOK_FROM value_expression
	| trim_spec value_expression TOK_FROM value_expression
	;

trim_spec :
	TOK_LEADING
	| TOK_TRAILING
	| TOK_BOTH
	;

date_format :
	TOK_DEFAULT
	| TOK_EUROPEAN
	| TOK_USA
	;

case_expression :
	case_operand simple_when_then_list
	| searched_when_then_list
	;

case_operand :
	value_expression
	;

simple_when_then_list :
	simple_when_then else_clause
	| simple_when_then simple_when_then_list
	;

simple_when_then :
	TOK_WHEN value_expression TOK_THEN result_expr
	;

searched_when_then_list :
	searched_when_then else_clause
	| searched_when_then searched_when_then_list
	;

searched_when_then :
	TOK_WHEN search_condition TOK_THEN result_expr
	;

else_clause :
	TOK_ELSE result_expr
	| /*empty*/
	;

result_expr :
	value_expression
	;

optional_cast_spec_not_null_spec :
	empty
	| TOK_NOT TOK_NULL
	;

optional_nullable_pkey :
	empty
	| TOK_NULLABLE
	;

cast_specification :
	TOK_CAST '(' value_expression TOK_AS Set_Cast_Global_False_and_data_type optional_cast_spec_not_null_spec ')'
	| TOK_CONVERT '(' value_expression ',' /*1R*/ data_type ')'
	| TOK_TYPECAST '(' value_expression ',' /*1R*/ data_type ')'
	| TOK_CAST '(' value_expression TOK_AS TOK_NULLABLE ')'
	;

proc_arg_data_type :
	predefined_type
	| proc_arg_rowset_type
	| proc_arg_float_type
	;

data_type :
	predef_type
	| rowset_type
	;

predef_type :
	predefined_type
	| float_type
	;

predefined_type :
	date_time_type
	| interval_type
	| numeric_type
	| pic_type
	| string_type
	| blob_type
	| boolean_type
	;

rowset_type :
	TOK_ROWSET unsigned_integer predefined_type
	| TOK_ROWSET unsigned_integer float_type
	;

proc_arg_rowset_type :
	TOK_ROWSET unsigned_integer predefined_type
	| TOK_ROWSET unsigned_integer proc_arg_float_type
	;

numeric_type :
	non_int_type
	| int_type
	;

int_type :
	TOK_INTEGER signed_option
	| TOK_SMALLINT signed_option
	| TOK_LARGEINT signed_option
	| TOK_BIGINT signed_option
	| TOK_BIT TOK_PRECISION TOK_INTEGER left_unsigned_right signed_option
	| TOK_BIT
	| TOK_TINYINT signed_option
	| TOK_BYTEINT signed_option
	;

numeric_type_token :
	TOK_NUMERIC
	;

non_int_type :
	numeric_type_token left_uint_uint_right signed_option
	| TOK_NUMERIC signed_option
	| TOK_LSDECIMAL left_uint_uint_right signed_option
	| TOK_LSDECIMAL signed_option
	| TOK_DECIMAL left_uint_uint_right signed_option
	| TOK_DECIMAL signed_option
	;

float_type :
	TOK_FLOAT
	| TOK_FLOAT left_unsigned_right
	| TOK_REAL
	| TOK_DOUBLE TOK_PRECISION
	| TOK_SQL_DOUBLE
	;

proc_arg_float_type :
	TOK_FLOAT_IEEE
	| TOK_FLOAT_IEEE left_unsigned_right
	| TOK_REAL_IEEE
	| TOK_DOUBLE_IEEE
	| TOK_FLOAT
	| TOK_FLOAT left_unsigned_right
	| TOK_REAL
	| TOK_DOUBLE TOK_PRECISION
	;

pic_type :
	TOK_PICTURE char_set collation_option pic_tail pic_notcasespecific_option
	;

pic_tail :
	/*empty*/
	| TOK_DISPLAY
	| TOK_DISPLAY TOK_SIGN TOK_IS TOK_LEADING
	| TOK_DISPLAY TOK_UPSHIFT
	| TOK_UPSHIFT
	| TOK_COMP
	;

signed_option :
	/*empty*/
	| TOK_SIGNED
	| TOK_UNSIGNED
	;

string_type :
	tok_char_or_character_or_byte new_optional_left_charlen_right char_set collation_option upshift_flag notcasespecific_option
	| TOK_ANSIVARCHAR left_charlen_right char_set collation_option upshift_flag notcasespecific_option
	| tok_char_or_character_or_byte TOK_VARYING toggled_optional_left_charlen_right char_set collation_option upshift_flag notcasespecific_option
	| TOK_VARCHAR toggled_optional_left_charlen_right char_set collation_option upshift_flag notcasespecific_option
	| TOK_LONG TOK_VARCHAR char_set collation_option upshift_flag notcasespecific_option
	| TOK_LONG TOK_VARCHAR new_left_charlen_right char_set collation_option upshift_flag notcasespecific_option
	| nchar optional_left_charlen_right collation_option upshift_flag notcasespecific_option
	| nchar_varying left_charlen_right collation_option upshift_flag notcasespecific_option
	| TOK_WCHAR left_unsigned_right collation_option upshift_flag notcasespecific_option
	| TOK_VARWCHAR left_unsigned_right collation_option upshift_flag notcasespecific_option
	| TOK_LONGWVARCHAR collation_option upshift_flag notcasespecific_option
	| TOK_LONGWVARCHAR left_unsigned_right collation_option upshift_flag notcasespecific_option
	| TOK_BINARY
	| TOK_BINARY left_unsigned_right
	| TOK_VARBINARY
	| TOK_VARBINARY left_unsigned_right
	| TOK_BINARY TOK_VARYING left_unsigned_right
	| TOK_LONG TOK_VARBINARY
	| TOK_LONG TOK_VARBINARY left_unsigned_right
	;

tok_char_or_character :
	TOK_CHAR
	| TOK_CHARACTER
	;

tok_char_or_character_or_byte :
	TOK_CHAR
	| TOK_CHARACTER
	| TOK_BYTE
	;

blob_type :
	TOK_BLOB blob_optional_left_len_right
	| TOK_CLOB clob_optional_left_len_right
	;

blob_optional_left_len_right :
	'(' NUMERIC_LITERAL_EXACT_NO_SCALE optional_lob_unit ')'
	| empty
	;

optional_lob_unit :
	TOK_K
	| TOK_M
	| TOK_G
	| empty
	;

clob_optional_left_len_right :
	'(' NUMERIC_LITERAL_EXACT_NO_SCALE optional_lob_unit ')'
	| empty
	;

boolean_type :
	TOK_BOOLEAN
	;

toggled_optional_left_charlen_right :
	new_left_charlen_right
	| empty
	;

optional_left_charlen_right :
	left_charlen_right
	| empty
	;

new_optional_left_charlen_right :
	new_left_charlen_right
	| empty
	;

nchar :
	TOK_NATIONAL tok_char_or_character
	| TOK_NCHAR
	;

nchar_varying :
	TOK_NATIONAL tok_char_or_character TOK_VARYING
	| TOK_NCHAR TOK_VARYING
	;

char_set :
	/*empty*/
	| TOK_CHARACTER TOK_SET character_set
	;

CHAR_FUNC_character_set :
	IDENTIFIER
	;

character_set :
	IDENTIFIER
	;

upshift_flag :
	/*empty*/
	| TOK_UPSHIFT
	| TOK_UPPERCASE
	;

notcasespecific_option :
	empty
	| TOK_NOT_CASESPECIFIC
	| TOK_CASESPECIFIC
	;

pic_notcasespecific_option :
	empty
	| TOK_NOT_CASESPECIFIC
	;

unsigned_integer :
	NUMERIC_LITERAL_EXACT_NO_SCALE
	;

unsigned_smallint :
	NUMERIC_LITERAL_EXACT_NO_SCALE
	;

left_largeint_right :
	'(' NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	;

ts_left_unsigned_right :
	'(' NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	;

left_charlen_right :
	left_unsigned optional_charlen_unit ')'
	;

optional_charlen_unit :
	TOK_CHARACTERS
	| TOK_CHAR
	| TOK_CHARS
	| TOK_CHARACTER
	| empty
	;

new_left_charlen_right :
	left_unsigned new_optional_charlen_unit ')'
	;

new_optional_charlen_unit :
	TOK_CHAR
	| TOK_CHARS
	| TOK_CHARACTER
	| TOK_CHARACTERS
	| TOK_BYTE
	| TOK_BYTES
	| empty
	;

left_unsigned_right :
	left_unsigned ')'
	;

left_unsigned :
	'(' NUMERIC_LITERAL_EXACT_NO_SCALE
	;

left_uint_uint_right :
	'(' NUMERIC_LITERAL_EXACT_NO_SCALE ',' /*1R*/ NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	| left_unsigned_right
	;

date_time_type :
	TOK_DATE disableCharsetInference format_attributes
	| TOK_TIME
	| TOK_TIME ts_left_unsigned_right
	| TOK_TIMESTAMP disableCharsetInference format_attributes
	| TOK_TIMESTAMP ts_left_unsigned_right disableCharsetInference format_attributes
	| TOK_DATETIME datetime_qualifier
	;

datetime_qualifier :
	datetime_start_field
	| datetime_start_field TOK_TO datetime_end_field
	| fraction_only_datetime
	;

datetime_start_field :
	non_second_datetime_field
	| TOK_SECOND
	;

datetime_end_field :
	non_second_datetime_field
	| TOK_SECOND
	| datetime_fraction_field
	;

fraction_only_datetime :
	datetime_fraction_field
	| TOK_FRACTION TOK_TO datetime_fraction_field
	;

datetime_fraction_field :
	TOK_FRACTION
	| TOK_FRACTION ts_left_unsigned_right
	;

interval_type :
	TOK_INTERVAL interval_qualifier
	;

interval_qualifier :
	start_field TOK_TO end_field
	| single_datetime_field
	| TOK_SECOND TOK_TO interval_fraction_field
	| TOK_SECOND ts_left_unsigned_right TOK_TO interval_fraction_field
	| TOK_SECOND TOK_TO TOK_SECOND
	| TOK_SECOND ts_left_unsigned_right TOK_TO TOK_SECOND
	| fraction_only_interval
	;

start_field :
	non_second_datetime_field
	| non_second_datetime_field ts_left_unsigned_right
	;

fraction_only_interval :
	TOK_FRACTION
	| TOK_FRACTION ts_left_unsigned_right
	| TOK_FRACTION TOK_TO interval_fraction_field
	| TOK_FRACTION ts_left_unsigned_right TOK_TO interval_fraction_field
	;

interval_fraction_field :
	TOK_FRACTION
	| TOK_FRACTION ts_left_unsigned_right
	;

end_field :
	non_second_datetime_field
	| TOK_SECOND
	| TOK_SECOND ts_left_unsigned_right
	| interval_fraction_field
	;

single_datetime_field :
	start_field
	| TOK_SECOND
	| TOK_SECOND ts_left_unsigned_right
	| TOK_SECOND '(' unsigned_integer ',' /*1R*/ unsigned_integer ')'
	;

non_second_datetime_field :
	TOK_YEAR
	| TOK_MONTH
	| TOK_DAY
	| TOK_HOUR
	| TOK_MINUTE
	;

new_non_second_datetime_field :
	TOK_CENTURY
	| TOK_DECADE
	| TOK_WEEK
	| TOK_QUARTER
	| TOK_EPOCH
	| TOK_DOW
	| TOK_DOY
	| TOK_WOM
	;

datetime_field :
	non_second_datetime_field
	| new_non_second_datetime_field
	| TOK_SECOND
	;

dynamic_parameter :
	PARAMETER
	;

dynamic_parameter_array :
	PARAMETER '[' unsigned_integer ']'
	;

simple_host_variable :
	HOSTVAR
	;

hostvar_and_prototype :
	HOSTVAR TOK_PROTOTYPE mvs_umd_option character_string_literal
	;

param_and_prototype :
	PARAMETER TOK_PROTOTYPE character_string_literal
	;

mvs_umd_option :
	empty
	| TOK_MVS_UMD
	;

input_hostvar_expression :
	HOSTVAR
	| HOSTVAR HOSTVAR
	| HOSTVAR TOK_INDICATOR HOSTVAR
	;

Set_Cast_Global_False_and_data_type :
	data_type
	;

hostvar_expression :
	input_hostvar_expression
	| TOK_CAST '(' HOSTVAR TOK_AS Set_Cast_Global_False_and_data_type ')'
	| TOK_CAST '(' HOSTVAR TOK_AS Set_Cast_Global_False_and_data_type ')' HOSTVAR
	| TOK_CAST '(' HOSTVAR TOK_AS Set_Cast_Global_False_and_data_type ')' TOK_INDICATOR HOSTVAR
	;

internal_arith_placeholder :
	ARITH_PLACEHOLDER
	;

internal_bool_placeholder :
	BOOL_PLACEHOLDER
	| TOK_TRUE '(' value_expression ')'
	| TOK_FALSE '(' value_expression ')'
	;

insert_value_expression_list :
	insert_value_expression
	| insert_value_expression_list_comma %prec ',' /*1R*/
	| insert_value_expression_list_paren %prec ',' /*1R*/
	;

insert_value_expression_list_comma :
	insert_value_expression ',' /*1R*/ insert_value_expression
	| insert_value_expression_list_comma ',' /*1R*/ insert_value_expression
	;

insert_value_expression_list_paren :
	'(' insert_value_expression_list_comma ')'
	| '(' insert_value_expression_list_paren ')'
	;

insert_value_expression :
	value_expression
	| insert_obj_to_lob_function
	| insert_empty_blob_clob
	;

insert_obj_to_lob_function :
	TOK_STRINGTOLOB '(' value_expression ')'
	| TOK_BUFFERTOLOB '(' TOK_LOCATION value_expression ',' /*1R*/ TOK_SIZE value_expression ')'
	| TOK_FILETOLOB '(' character_literal_sbyte ')'
	| TOK_LOADTOLOB '(' literal ')'
	| TOK_EXTERNALTOLOB '(' literal ')'
	| TOK_EXTERNALTOLOB '(' literal ',' /*1R*/ literal ')'
	;

insert_empty_blob_clob :
	TOK_EMPTY_BLOB '(' ')'
	| TOK_EMPTY_CLOB '(' ')'
	;

update_obj_to_lob_function :
	TOK_STRINGTOLOB '(' value_expression ')'
	| TOK_STRINGTOLOB '(' value_expression ',' /*1R*/ TOK_APPEND ')'
	| TOK_FILETOLOB '(' character_literal_sbyte ')'
	| TOK_FILETOLOB '(' character_literal_sbyte ',' /*1R*/ TOK_APPEND ')'
	| TOK_BUFFERTOLOB '(' TOK_LOCATION value_expression ',' /*1R*/ TOK_SIZE value_expression ')'
	| TOK_BUFFERTOLOB '(' TOK_LOCATION value_expression ',' /*1R*/ TOK_SIZE value_expression ',' /*1R*/ TOK_APPEND ')'
	| TOK_EXTERNALTOLOB '(' literal ')'
	| TOK_EXTERNALTOLOB '(' literal ',' /*1R*/ TOK_APPEND ')'
	| TOK_EXTERNALTOLOB '(' literal ',' /*1R*/ literal ')'
	| TOK_LOADTOLOB '(' literal ',' /*1R*/ TOK_APPEND ')'
	| TOK_EMPTY_BLOB '(' ')'
	| TOK_EMPTY_CLOB '(' ')'
	;

select_lob_to_obj_function :
	TOK_LOBTOFILE '(' value_expression ',' /*1R*/ literal ')'
	| TOK_LOBTOSTRING '(' value_expression ')'
	| TOK_LOBTOSTRING '(' value_expression ',' /*1R*/ NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	| TOK_LOBTOSTRING '(' value_expression ',' /*1R*/ TOK_EXTRACT ',' /*1R*/ TOK_OUTPUT TOK_ROW TOK_SIZE NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	| TOK_LOBTOSTRING '(' value_expression ',' /*1R*/ TOK_EXTRACT ')'
	;

table_value_constructor :
	TOK_VALUES '(' insert_value_expression_list ')'
	| TOK_VALUES '(' insert_value_expression_list ')' ',' /*1R*/ list_of_values
	;

list_of_values :
	'(' insert_value_expression_list ')'
	| list_of_values ',' /*1R*/ '(' insert_value_expression_list ')'
	;

table_expression :
	from_clause where_clause sample_clause cond_transpose_clause_list sequence_by_clause group_by_clause_non_empty qualify_clause
	| from_clause where_clause sample_clause cond_transpose_clause_list sequence_by_clause having_clause_non_empty
	| from_clause where_clause sample_clause cond_transpose_clause_list sequence_by_clause qualify_clause
	| from_clause where_clause sample_clause cond_transpose_clause_list sequence_by_clause group_by_clause_non_empty having_clause_non_empty
	| from_clause where_clause sample_clause cond_transpose_clause_list sequence_by_clause having_clause_non_empty group_by_clause_non_empty
	;

from_clause :
	TOK_FROM global_hint table_reference
	| from_clause ',' /*1R*/ table_reference
	;

join_specification :
	join_condition
	;

join_condition :
	TOK_ON /*4L*/ search_condition
	;

where_clause :
	/*empty*/
	| TOK_WHERE search_condition
	;

group_by_clause_non_empty :
	TOK_GROUP TOK_BY value_expression_list
	| TOK_GROUP TOK_BY TOK_ROLLUP '(' value_expression_list ')'
	;

having_clause_non_empty :
	TOK_HAVING search_condition
	;

qualify_clause :
	/*empty*/
	| TOK_QUALIFY search_condition
	;

sort_by_value_expression :
	value_expression
	| value_expression ordering_spec
	;

sort_by_value_expression_list :
	sort_by_value_expression
	| sort_by_value_expression ',' /*1R*/ sort_by_value_expression_list
	;

sort_by_key :
	dml_column_reference
	| dml_column_reference ordering_spec
	;

sort_by_key_list :
	sort_by_key
	| sort_by_key ',' /*1R*/ sort_by_key_list
	;

sort_by_clause :
	/*empty*/
	| TOK_SORT TOK_BY sort_by_key_list
	;

sequence_by_clause :
	/*empty*/
	| TOK_SEQUENCE_BY sort_by_key_list
	;

transpose_value :
	value_expression
	| value_expression_list_paren
	;

transpose_item_list :
	transpose_value
	| transpose_value ',' /*1R*/ transpose_item_list
	;

transpose_col_list :
	identifier
	| '(' column_list ')'
	;

transpose_set :
	transpose_item_list TOK_AS transpose_col_list
	;

transpose_list :
	transpose_set
	| transpose_set transpose_list
	;

transpose_clause :
	TOK_TRANSPOSE transpose_list TOK_KEY TOK_BY identifier
	| TOK_TRANSPOSE transpose_list
	;

cond_transpose_clause_list :
	/*empty*/
	| transpose_clause_list
	;

transpose_clause_list :
	transpose_clause
	| transpose_clause_list transpose_clause
	;

sample_clause :
	sample_clause_x
	;

sample_clause_x :
	/*empty*/
	| TOK_SAMPLE_FIRST sample_size_expr sort_by_clause
	| TOK_SAMPLE_PERIODIC sample_size_expr TOK_EVERY sample_size_numeric sample_absolute_rows sort_by_clause
	| TOK_SAMPLE_RANDOM sample_size_expr
	| TOK_SAMPLE_RANDOM sample_cluster_expr
	;

sample_clusters :
	TOK_CLUSTERS TOK_OF NUMERIC_LITERAL_EXACT_NO_SCALE TOK_BLOCKS
	;

sample_absolute :
	/*empty*/
	| TOK_PERCENT
	;

sample_absolute_rows :
	TOK_ROWS
	| TOK_PERCENT
	| TOK_PERCENT TOK_ROWS
	;

sample_size_numeric :
	NUMERIC_LITERAL_EXACT_NO_SCALE
	| NUMERIC_LITERAL_EXACT_WITH_SCALE
	;

sample_cluster_expr :
	sample_size_numeric sample_absolute sample_clusters
	;

sample_size_expr :
	sample_size_numeric sample_absolute_rows
	| balance_expr
	;

balance_expr :
	TOK_BALANCE balance_when_then_list TOK_END
	;

balance_when_then_list :
	balance_when_then balance_when_then_list
	| balance_when_then balance_else
	;

balance_when_then :
	TOK_WHEN search_condition TOK_THEN sample_size_numeric sample_absolute_rows
	;

balance_else :
	TOK_ELSE sample_size_numeric sample_absolute_rows
	| /*empty*/
	;

optional_locking_stmt_list :
	empty
	| locking_stmt_list
	;

locking_stmt_list :
	locking_stmt
	| locking_stmt_list locking_stmt
	;

locking_stmt :
	TOK_LOCKING actual_table_name TOK_FOR TOK_ACCESS
	| TOK_LOCKING TOK_TABLE actual_table_name TOK_FOR TOK_ACCESS
	| TOK_LOCK actual_table_name TOK_FOR TOK_ACCESS
	| TOK_LOCK TOK_TABLE actual_table_name TOK_FOR TOK_ACCESS
	| TOK_LOCK_ROW TOK_FOR TOK_ACCESS
	| TOK_LOCKING TOK_ROW TOK_FOR TOK_ACCESS
	| TOK_LOCKING TOK_FOR TOK_ACCESS
	;

select_token :
	TOK_SELECT
	| TOK_SEL
	| TOK_SELECT TOK_BEGIN_HINT ignore_ms4_hints TOK_END_HINT
	;

ignore_ms4_hints :
	identifier '(' NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	| identifier
	;

query_specification :
	select_token set_quantifier query_spec_body
	| exe_util_maintain_object
	| exe_util_aqr
	| exe_util_get_qid
	| exe_util_get_lob_info
	| select_token '[' firstn_sorted NUMERIC_LITERAL_EXACT_NO_SCALE ']' set_quantifier query_spec_body
	;

firstn_sorted :
	TOK_ANY
	| TOK_FIRST
	| TOK_LAST
	;

set_quantifier :
	/*empty*/
	| TOK_ALL
	| TOK_DISTINCT
	| TOK_UNIQUE
	;

query_spec_body :
	query_select_list table_expression access_type optional_lock_mode
	| query_select_list into_clause table_expression access_type optional_lock_mode
	;

query_select_list :
	select_list
	;

access_type :
	TOK_REPEATABLE_READ TOK_ACCESS
	| TOK_SERIALIZABLE_ACCESS
	| TOK_FOR_REPEATABLE TOK_READ TOK_ACCESS
	| TOK_FOR_SERIALIZABLE TOK_ACCESS
	| TOK_READ TOK_UNCOMMITTED TOK_ACCESS
	| TOK_READ TOK_COMMITTED TOK_ACCESS
	| TOK_FOR_READ TOK_UNCOMMITTED TOK_ACCESS
	| TOK_FOR_READ TOK_COMMITTED TOK_ACCESS
	| TOK_FOR_SKIP TOK_CONFLICT TOK_ACCESS
	| TOK_SKIP_CONFLICT_ACCESS
	| /*empty*/
	;

return_list :
	TOK_RETURN select_list
	;

select_list :
	select_list_item
	| select_list_item ',' /*1R*/ select_list
	;

select_list_item :
	derived_column
	| '*' /*8L*/
	| actual_table_name2 TOK_DOT_STAR
	;

derived_column :
	value_expression
	| value_expression as_clause
	;

as_clause :
	TOK_AS correlation_name
	| correlation_name
	;

starting_production :
	starting_production2 ';'
	;

starting_production2 :
	sql_statement
	| TOK_INTERNAL_EXPR any_expression
	| TOK_INTERNAL_COLUMN_DEFINITION column_definition
	;

any_expression :
	value_expression_list
	| search_condition
	;

rowset_input_size :
	TOK_INPUT TOK_SIZE rowset_size
	;

rowset_output_size :
	TOK_OUTPUT TOK_SIZE rowset_size
	;

rowset_index :
	TOK_KEY TOK_BY identifier
	;

rowset_for_output :
	TOK_ROWSET TOK_FOR rowset_input_size ',' /*1R*/ rowset_output_size ',' /*1R*/ rowset_index
	| TOK_ROWSET TOK_FOR rowset_input_size ',' /*1R*/ rowset_output_size
	| TOK_ROWSET TOK_FOR rowset_output_size ',' /*1R*/ rowset_index
	| TOK_ROWSET TOK_FOR rowset_output_size
	;

rowset_for_input :
	TOK_ROWSET TOK_FOR rowset_input_size ',' /*1R*/ rowset_index
	| TOK_ROWSET TOK_FOR rowset_input_size
	| TOK_ROWSET TOK_FOR rowset_index
	;

rowset_for :
	rowset_for_input
	| rowset_for_output
	;

rowwise_rowset_info :
	'(' TOK_MAX TOK_ROWSET TOK_SIZE literal ',' /*1R*/ TOK_INPUT TOK_ROWSET TOK_SIZE dynamic_parameter ',' /*1R*/ TOK_INPUT TOK_ROW TOK_MAX TOK_LENGTH dynamic_parameter ',' /*1R*/ TOK_ROWSET TOK_BUFFER dynamic_parameter ')'
	;

sql_statement :
	interactive_query_expression
	| TOK_DISPLAY interactive_query_expression
	| TOK_BEGIN TOK_DECLARE TOK_SECTION
	| TOK_END TOK_DECLARE TOK_SECTION
	| alloc_desc_statement
	| alloc_static_desc_stmt
	| close_statement
	| dealloc_desc_statement
	| dealloc_stmt_statement
	| declare_dynamic_cursor
	| declare_static_cursor
	| describe_statement
	| dynamic_prepare
	| dynamic_execute
	| execute_immediate
	| fetch_cursor
	| get_conddiags_statement
	| get_desccount_statement
	| get_rowsetsize_statement
	| get_descitem_statement
	| get_stmtdiags_statement
	| module_statement
	| source_file_statement
	| module_timestamp
	| open_cursor
	| procedure_stmt
	| set_desccount_statement
	| set_rowsetsize_statement
	| set_descitem_statement
	| whenever_statement
	| explain_stmt_finalized
	;

explain_stmt_finalized :
	exe_util_display_explain
	;

set_transaction_statement :
	TOK_SET TOK_TRANSACTION transaction_mode_list
	;

transaction_mode_list :
	transaction_mode
	| transaction_mode_list ',' /*1R*/ transaction_mode
	;

transaction_mode :
	isolation_level
	| transaction_access_mode
	| diagnostics_size
	| rollback_mode_on_off
	| autoabort_interval_stmt
	| multi_commit_mode
	;

isolation_level :
	TOK_ISOLATION TOK_LEVEL isolation_level_enum
	;

isolation_level_enum :
	TOK_READ TOK_UNCOMMITTED
	| TOK_READ TOK_COMMITTED
	| TOK_REPEATABLE_READ
	| TOK_SERIALIZABLE
	;

transaction_access_mode :
	transaction_access
	;

transaction_access :
	TOK_READ TOK_ONLY
	| TOK_READ TOK_WRITE
	;

diagnostics_size :
	TOK_DIAGNOSTICS TOK_SIZE number_of_conditions
	;

number_of_conditions :
	literal
	| simple_host_variable
	| dynamic_parameter
	;

rollback_mode_on_off :
	TOK_NO TOK_ROLLBACK on_off
	;

autoabort_interval_stmt :
	TOK_AUTOABORT autoabort_interval
	;

multi_commit_mode :
	TOK_MULTI TOK_COMMIT on_or_empty TOK_EVERY unsigned_integer TOK_ROWS
	| TOK_MULTI TOK_COMMIT on_off
	;

sql_schema_statement_prologue :
	/*empty*/
	;

sql_schema_statement :
	sql_schema_statement_prologue sql_schema_definition_statement
	| sql_schema_statement_prologue sql_schema_manipulation_statement
	;

sql_schema_definition_statement :
	schema_definition
	| create_synonym_stmt
	| create_library_stmt
	| table_definition
	| view_definition
	| grant_statement
	| grant_component_privilege_stmt
	| create_component_privilege_stmt
	| drop_component_privilege_stmt
	| register_component_statement
	| register_user_statement
	| unregister_component_statement
	| unregister_user_statement
	| catalog_definition
	| index_definition
	| populate_index_definition
	| initialize_sql_statement
	| create_mvrgroup_statement
	| trigger_definition
	| mv_definition
	| routine_definition
	| grant_schema_statement
	| grant_role_statement
	| create_role_statement
	| create_sequence_statement
	| alter_sequence_statement
	| cleanup_objects_statement
	| register_hive_statement
	| unregister_hive_statement
	| register_hbase_statement
	| unregister_hbase_statement
	| comment_on_statement
	;

sql_schema_manipulation_statement :
	drop_schema_statement
	| alter_audit_config_statement
	| alter_catalog_statement
	| alter_schema_statement
	| alter_index_statement
	| alter_function_statement
	| alter_library_statement
	| alter_table_statement
	| alter_mv_refresh_group_statement
	| alter_synonym_statement
	| alter_trigger_statement
	| alter_mv_statement
	| alter_user_statement
	| alter_view_statement
	| drop_synonym_stmt
	| drop_exception_stmt
	| drop_all_exception_stmt
	| drop_sql
	| drop_table_statement
	| drop_mvrgroup_statement
	| drop_trigger_statement
	| drop_mv_statement
	| drop_index_statement
	| drop_library_statement
	| drop_routine_statement
	| drop_view_statement
	| give_statement
	| revoke_component_privilege_stmt
	| revoke_statement
	| revoke_schema_statement
	| revoke_role_statement
	| drop_catalog_statement
	| drop_module
	| drop_role_statement
	| drop_sequence_statement
	;

item_signal_statement :
	TOK_SIGNAL TOK_SQLSTATE QUOTED_STRING '(' value_expression ')'
	;

signal_statement :
	item_signal_statement
	;

interactive_query_expression :
	rowset_for dml_statement
	| locking_stmt_list dml_statement
	| dml_statement
	| front_of_insert no_check_log no_rollback TOK_INTO TOK_TABLE '(' TOK_EXTRACT_TARGET '(' extract_type ',' /*1R*/ unsigned_integer ')' ')' '(' dml_query ')'
	| control_statement
	| osim_statement
	| set_statement
	| transaction_statement
	| lock_unlock_statement
	| sql_schema_statement
	| psm_3gl_statement
	| assignment_statement
	| show_statement
	| TOK_EXIT
	| signal_statement
	| internal_refresh_command
	| mvlog_command
	| standalone_call_statement
	| exe_util_statement
	| exe_util_cleanup_volatile_tables
	| exe_util_get_volatile_info
	| exe_util_get_error_info
	| exe_util_get_statistics
	| exe_util_get_metadata_info
	| exe_util_get_version_info
	| query_suspend_safe
	| query_suspend_forced
	| query_activate
	| query_cancel_optional_comment
	| truncate_table
	| exe_util_get_uid
	| exe_util_populate_in_memory_statistics
	| exe_util_lob_extract
	| unload_statement
	| exe_util_lob_update
	| exe_util_init_hbase
	| exe_util_get_region_access_stats
	| exe_util_hive_query
	;

dml_query :
	query_expression order_by_clause access_type optional_lock_mode for_update_spec optional_limit_spec
	| query_expression order_by_clause_non_empty group_by_clause_non_empty access_type optional_lock_mode for_update_spec optional_limit_spec
	;

optional_limit_spec :
	TOK_LIMIT NUMERIC_LITERAL_EXACT_NO_SCALE
	| TOK_LIMIT dynamic_parameter
	| /*empty*/
	;

dml_statement :
	dml_query
	| with_clause dml_query
	| front_of_insert_with_rwrs rowwise_rowset_info Rest_Of_insert_statement
	| front_of_insert Rest_Of_insert_statement
	| front_of_insert Rest_Of_insert_wo_INTO_statement
	| update_statement_searched access_type
	| merge_statement
	| delete_statement access_type
	| load_statement
	;

exe_util_statement :
	TOK_INSERT TOK_USING TOK_ALTER TOK_INTO table_name query_expression
	;

exe_util_cleanup_volatile_tables :
	TOK_CLEANUP_OBSOLETE TOK_VOLATILE TOK_TABLES
	| TOK_CLEANUP_OBSOLETE TOK_VOLATILE TOK_TABLES TOK_IN TOK_ALL TOK_CATALOGS
	| TOK_CLEANUP_OBSOLETE TOK_VOLATILE TOK_TABLES TOK_IN TOK_CATALOG character_string_literal
	;

exe_util_get_error_info :
	TOK_GET TOK_TEXT TOK_FOR TOK_ERROR NUMERIC_LITERAL_EXACT_NO_SCALE
	;

exe_util_get_volatile_info :
	TOK_GET TOK_ALL TOK_VOLATILE TOK_SCHEMAS
	| TOK_GET TOK_ALL TOK_VOLATILE TOK_TABLES
	| TOK_GET TOK_VOLATILE TOK_TABLES TOK_FOR TOK_SESSION QUOTED_STRING
	;

explain_starting_tokens :
	TOK_EXPLAIN optional_options
	;

exe_util_get_statistics :
	TOK_GET TOK_STATISTICS stats_merge_clause get_statistics_optional_options
	| TOK_GET TOK_STATISTICS TOK_FOR TOK_STATEMENT identifier stats_merge_clause get_statistics_optional_options
	| TOK_GET TOK_STATISTICS TOK_FOR TOK_QID qid_identifier stats_merge_clause get_statistics_optional_options
	| TOK_GET TOK_STATISTICS TOK_FOR TOK_QID_INTERNAL qid_internal_identifier qid_internal_stats_merge_clause
	| TOK_GET TOK_STATISTICS TOK_FOR TOK_PID pid_identifier stats_active_clause stats_merge_clause
	| TOK_GET TOK_PROCESS TOK_STATISTICS TOK_FOR pid_identifier
	| TOK_GET TOK_STATISTICS TOK_FOR TOK_CPU cpu_identifier stats_active_clause stats_merge_clause
	| TOK_GET TOK_STATISTICS TOK_FOR TOK_RMS cpu_identifier_with_all reset_clause
	;

get_statistics_optional_options :
	/*empty*/
	| ',' /*1R*/ TOK_OPTIONS QUOTED_STRING
	;

procedure_or_function :
	TOK_PROCEDURES
	| TOK_FUNCTIONS
	| TOK_TABLE_MAPPING TOK_FUNCTIONS
	;

exe_util_get_metadata_info :
	TOK_GET get_info_aus_clause objects_identifier get_info_io_clause object_identifier table_name optional_no_header_and_match_pattern_clause
	| TOK_GET get_info_aus_clause objects_identifier optional_no_header_and_match_pattern_clause
	| TOK_GET get_info_aus_clause procedure_or_function TOK_FOR_LIBRARY table_name optional_no_header_and_match_pattern_clause
	| TOK_GET get_info_aus_clause obj_priv_identifier for_user_or_role authorization_identifier optional_no_header_and_match_pattern_clause
	| TOK_GET get_info_aus_clause TOK_PRIVILEGES TOK_ON /*4L*/ object_identifier table_name optional_for_user_clause optional_no_header_and_match_pattern_clause
	| TOK_GET get_info_aus_clause TOK_PRIVILEGES TOK_ON /*4L*/ TOK_PROCEDURE table_name optional_for_user_clause optional_no_header_and_match_pattern_clause
	| TOK_GET get_info_aus_clause TOK_COMPONENTS optional_no_header_and_match_pattern_clause
	| TOK_GET get_info_aus_clause TOK_COMPONENT TOK_PRIVILEGES TOK_ON /*4L*/ component_name optional_authid_clause optional_drop_behavior optional_no_header_and_match_pattern_clause
	| TOK_GET get_info_aus_clause TOK_PRIVILEGES TOK_ON /*4L*/ TOK_COMPONENT component_name optional_authid_clause optional_drop_behavior optional_no_header_and_match_pattern_clause
	| TOK_GET get_info_aus_clause TOK_HBASE TOK_OBJECTS
	| TOK_GET get_info_aus_clause TOK_HBASE TOK_OBJECTS ',' /*1R*/ TOK_MATCH QUOTED_STRING
	;

for_user_or_role :
	TOK_FOR_USER
	| TOK_FOR_ROLE
	;

optional_for_user_clause :
	empty
	| TOK_FOR authorization_identifier
	| TOK_FOR_USER authorization_identifier
	;

optional_authid_clause :
	empty
	| TOK_FOR authorization_identifier
	;

get_info_aus_clause :
	empty
	| TOK_ALL
	| TOK_USER
	| TOK_CURRENT_USER
	| TOK_IUDLOG
	| TOK_RANGELOG
	| TOK_TEMP_TABLE
	| TOK_SYSTEM
	| TOK_EXTERNAL
	;

object_identifier :
	TOK_CATALOG
	| TOK_CONSTRAINT
	| TOK_INDEX
	| TOK_LIBRARY
	| TOK_TABLE_MAPPING TOK_FUNCTION
	| TOK_FUNCTION
	| TOK_MV
	| TOK_SCHEMA
	| TOK_SYNONYM
	| TOK_TABLE
	| TOK_TRIGGER
	| TOK_VIEW
	| TOK_SEQUENCE
	;

objects_identifier :
	TOK_CATALOGS
	| TOK_CONSTRAINTS
	| TOK_INDEXES
	| TOK_LIBRARIES
	| TOK_MVS
	| TOK_MVGROUPS
	| TOK_OBJECTS
	| TOK_PARTITIONS
	| TOK_PROCEDURES
	| TOK_ROLES
	| TOK_SCHEMAS
	| TOK_SEQUENCES
	| TOK_SYNONYMS
	| TOK_TABLES
	| TOK_TRIGGERS
	| TOK_USERS
	| TOK_VIEWS
	| TOK_INVALID TOK_VIEWS
	| TOK_FUNCTIONS
	| TOK_TABLE_MAPPING TOK_FUNCTIONS
	| TOK_HIVE TOK_REGISTERED TOK_TABLES
	| TOK_HIVE TOK_REGISTERED TOK_VIEWS
	| TOK_HIVE TOK_REGISTERED TOK_SCHEMAS
	| TOK_HIVE TOK_REGISTERED TOK_OBJECTS
	| TOK_HIVE TOK_EXTERNAL TOK_TABLES
	| TOK_HBASE TOK_REGISTERED TOK_TABLES
	;

privileges_identifier :
	TOK_PRIVILEGES
	;

obj_priv_identifier :
	objects_identifier
	| privileges_identifier
	;

get_info_io_clause :
	TOK_IN
	| TOK_ON /*4L*/
	;

optional_no_header_and_match_pattern_clause :
	empty
	| ',' /*1R*/ TOK_NO TOK_HEADER
	| ',' /*1R*/ TOK_MATCH QUOTED_STRING
	| ',' /*1R*/ TOK_RETURN TOK_FULL /*3L*/ TOK_NAMES
	| ',' /*1R*/ TOK_NO TOK_HEADER ',' /*1R*/ TOK_MATCH QUOTED_STRING
	| ',' /*1R*/ TOK_NO TOK_HEADER ',' /*1R*/ TOK_RETURN TOK_FULL /*3L*/ TOK_NAMES
	| ',' /*1R*/ TOK_NO TOK_HEADER ',' /*1R*/ TOK_RETURN TOK_FULL /*3L*/ TOK_NAMES ',' /*1R*/ TOK_MATCH QUOTED_STRING
	;

exe_util_get_version_info :
	TOK_GET TOK_VERSION TOK_OF TOK_METADATA
	| TOK_GET TOK_VERSION TOK_OF TOK_SOFTWARE
	| TOK_GET TOK_VPROC TOK_OF TOK_SYSTEM TOK_MODULES
	| TOK_GET TOK_VPROC TOK_OF TOK_MODULE QUOTED_STRING
	| TOK_GET TOK_VERSION TOK_OF TOK_PROCEDURE '(' QUOTED_STRING ',' /*1R*/ QUOTED_STRING ')'
	| TOK_GET TOK_VERSION TOK_OF TOK_STATEMENT explain_identifier
	| TOK_GET TOK_VERSION TOK_OF TOK_SYSTEM
	| TOK_GET TOK_VERSION TOK_OF TOK_SYSTEM nsk_node_name
	| TOK_GET TOK_VERSION TOK_OF TOK_MODULE QUOTED_STRING
	| TOK_GET TOK_VERSION TOK_OF TOK_SYSTEM TOK_SCHEMA
	| TOK_GET TOK_VERSION TOK_OF TOK_SYSTEM TOK_SCHEMA nsk_node_name
	| TOK_GET TOK_VERSION TOK_OF TOK_PROCEDURE actual_routine_name
	| TOK_GET TOK_VERSION TOK_OF TOK_STORED TOK_PROCEDURE actual_routine_name
	| TOK_GET TOK_VERSION TOK_OF object_identifier table_name
	| TOK_GET TOK_NAMES TOK_OF TOK_RELATED objects_identifier TOK_FOR table_name
	| TOK_GET TOK_NAMES TOK_OF TOK_RELATED TOK_NODES TOK_FOR nsk_node_name
	| TOK_GET TOK_NAMES TOK_OF TOK_RELATED TOK_NODES
	| TOK_GET TOK_SYSTEM TOK_NAME
	;

exe_util_get_uid :
	TOK_GET TOK_UID TOK_OF maintain_object_token table_name
	;

exe_util_get_qid :
	TOK_GET TOK_QID TOK_FOR TOK_STATEMENT IDENTIFIER
	;

exe_util_populate_in_memory_statistics :
	TOK_GENERATE TOK_STATISTICS TOK_FOR TOK_TABLE table_name TOK_LIKE table_name optional_from_schema
	;

exe_util_lob_extract :
	TOK_EXTRACT TOK_LOBLENGTH '(' TOK_LOB QUOTED_STRING ')' TOK_LOCATION NUMERIC_LITERAL_EXACT_NO_SCALE
	| TOK_EXTRACT TOK_LOBLENGTH '(' TOK_LOB QUOTED_STRING ')'
	| TOK_EXTRACT TOK_NAME '(' TOK_LOB QUOTED_STRING ')' TOK_LOCATION NUMERIC_LITERAL_EXACT_NO_SCALE
	| TOK_EXTRACT TOK_NAME '(' TOK_LOB QUOTED_STRING ')'
	| TOK_EXTRACT TOK_OFFSET '(' TOK_LOB QUOTED_STRING ')' TOK_LOCATION NUMERIC_LITERAL_EXACT_NO_SCALE
	| TOK_EXTRACT TOK_OFFSET '(' TOK_LOB QUOTED_STRING ')'
	| TOK_EXTRACT TOK_LOBTOSTRING '(' TOK_LOB QUOTED_STRING ',' /*1R*/ TOK_SIZE NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	| TOK_EXTRACT TOK_LOBTOBUFFER '(' TOK_LOB QUOTED_STRING ',' /*1R*/ TOK_LOCATION NUMERIC_LITERAL_EXACT_NO_SCALE ',' /*1R*/ TOK_SIZE NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	| TOK_EXTRACT TOK_LOBTOFILE '(' TOK_LOB QUOTED_STRING ',' /*1R*/ QUOTED_STRING ')'
	| TOK_EXTRACT TOK_LOBTOFILE '(' TOK_LOB QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ TOK_TRUNCATE ')'
	| TOK_EXTRACT TOK_LOBTOFILE '(' TOK_LOB QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ TOK_CREATE ',' /*1R*/ TOK_TRUNCATE ')'
	| TOK_EXTRACT TOK_LOBTOFILE '(' TOK_LOB QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ TOK_CREATE ',' /*1R*/ TOK_APPEND ')'
	| TOK_EXTRACT TOK_LOBTOFILE '(' TOK_LOB QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ TOK_APPEND ')'
	| TOK_EXTRACT TOK_LOBTOSTRING '(' TOK_LOB QUOTED_STRING ',' /*1R*/ TOK_OUTPUT TOK_ROW TOK_SIZE NUMERIC_LITERAL_EXACT_NO_SCALE ',' /*1R*/ TOK_LOB TOK_BUFFER TOK_SIZE NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	| TOK_EXTRACT TOK_EXTERNALTOSTRING '(' QUOTED_STRING ',' /*1R*/ TOK_OUTPUT TOK_ROW TOK_SIZE NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	| TOK_EXTRACT TOK_EXTERNALTOSTRING '(' QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ TOK_OUTPUT TOK_ROW TOK_SIZE NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	| TOK_EXTRACT TOK_EXTERNALTOSTRING '(' QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ TOK_BUFFER TOK_SIZE NUMERIC_LITERAL_EXACT_NO_SCALE ',' /*1R*/ TOK_OUTPUT TOK_ROW TOK_SIZE NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	| TOK_EXTRACT TOK_EXTERNALTOSTRING '(' QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ TOK_OUTPUT TOK_ROW TOK_SIZE NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	| TOK_LOAD TOK_STRINGTOEXTERNAL '(' QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	| TOK_LOAD TOK_STRINGTOEXTERNAL '(' QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ NUMERIC_LITERAL_EXACT_NO_SCALE ',' /*1R*/ TOK_WITH TOK_CREATE ')'
	| TOK_LOAD TOK_FILETOEXTERNAL '(' QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	| TOK_LOAD TOK_FILETOEXTERNAL '(' QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ NUMERIC_LITERAL_EXACT_NO_SCALE ',' /*1R*/ TOK_WITH TOK_CREATE ')'
	| TOK_LOAD TOK_FILETOEXTERNAL '(' QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ NUMERIC_LITERAL_EXACT_NO_SCALE ',' /*1R*/ NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	| TOK_LOAD TOK_FILETOEXTERNAL '(' QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ QUOTED_STRING ',' /*1R*/ NUMERIC_LITERAL_EXACT_NO_SCALE ',' /*1R*/ NUMERIC_LITERAL_EXACT_NO_SCALE ',' /*1R*/ TOK_WITH TOK_CREATE ')'
	;

exe_util_lob_update :
	TOK_UPDATE_LOB '(' TOK_LOB QUOTED_STRING ',' /*1R*/ TOK_LOCATION NUMERIC_LITERAL_EXACT_NO_SCALE ',' /*1R*/ TOK_SIZE NUMERIC_LITERAL_EXACT_NO_SCALE ')'
	| TOK_UPDATE_LOB '(' TOK_LOB QUOTED_STRING ',' /*1R*/ TOK_LOCATION NUMERIC_LITERAL_EXACT_NO_SCALE ',' /*1R*/ TOK_SIZE NUMERIC_LITERAL_EXACT_NO_SCALE ',' /*1R*/ TOK_APPEND ')'
	| TOK_UPDATE_LOB '(' TOK_LOB QUOTED_STRING ',' /*1R*/ TOK_EMPTY_BLOB '(' ')' ')'
	| TOK_UPDATE_LOB '(' TOK_LOB QUOTED_STRING ',' /*1R*/ TOK_EMPTY_CLOB '(' ')' ')'
	;

optional_from_schema :
	/*empty*/
	| TOK_FROM TOK_SCHEMA schema_name
	;

exe_util_init_hbase :
	TOK_INITIALIZE TOK_TRAFODION
	| TOK_INITIALIZE TOK_TRAFODION ',' /*1R*/ TOK_MINIMAL
	| TOK_INITIALIZE TOK_TRAFODION ',' /*1R*/ TOK_NO TOK_RETURN TOK_STATUS
	| TOK_INITIALIZE TOK_TRAFODION ',' /*1R*/ TOK_MINIMAL ',' /*1R*/ TOK_NO TOK_RETURN TOK_STATUS
	| TOK_INITIALIZE TOK_TRAFODION ',' /*1R*/ TOK_DROP
	| TOK_INITIALIZE TOK_TRAFODION ',' /*1R*/ TOK_CREATE TOK_METADATA TOK_VIEWS
	| TOK_INITIALIZE TOK_TRAFODION ',' /*1R*/ TOK_DROP TOK_METADATA TOK_VIEWS
	| TOK_INITIALIZE TOK_TRAFODION ',' /*1R*/ TOK_UPGRADE
	| TOK_INITIALIZE TOK_TRAFODION ',' /*1R*/ TOK_CREATE TOK_SCHEMA TOK_OBJECTS
	| TOK_INITIALIZE TOK_TRAFODION ',' /*1R*/ TOK_CREATE TOK_LIBRARY TOK_MANAGEMENT
	| TOK_INITIALIZE TOK_TRAFODION ',' /*1R*/ TOK_DROP TOK_LIBRARY TOK_MANAGEMENT
	| TOK_INITIALIZE TOK_TRAFODION ',' /*1R*/ TOK_UPGRADE TOK_LIBRARY TOK_MANAGEMENT
	| TOK_INITIALIZE TOK_TRAFODION ',' /*1R*/ TOK_CREATE TOK_REPOSITORY
	| TOK_INITIALIZE TOK_TRAFODION ',' /*1R*/ TOK_DROP TOK_REPOSITORY
	| TOK_INITIALIZE TOK_TRAFODION ',' /*1R*/ TOK_UPGRADE TOK_REPOSITORY
	| TOK_INITIALIZE TOK_AUTHORIZATION
	| TOK_INITIALIZE TOK_AUTHORIZATION ',' /*1R*/ TOK_CLEANUP
	| TOK_INITIALIZE TOK_AUTHORIZATION ',' /*1R*/ TOK_DROP
	| TOK_INITIALIZE TOK_TRAFODION ',' /*1R*/ TOK_UPDATE TOK_SOFTWARE TOK_VERSION
	;

exe_util_get_region_access_stats :
	TOK_GET TOK_REGION stats_or_statistics TOK_FOR TOK_TABLE table_name
	| TOK_GET TOK_REGION stats_or_statistics TOK_FOR TOK_INDEX table_name
	| TOK_GET TOK_REGION stats_or_statistics TOK_FOR rel_subquery
	| TOK_GET TOK_REGION stats_or_statistics TOK_FOR TOK_TABLE table_name ',' /*1R*/ TOK_SUMMARY
	| TOK_GET TOK_REGION stats_or_statistics TOK_FOR TOK_INDEX table_name ',' /*1R*/ TOK_SUMMARY
	| TOK_GET TOK_REGION stats_or_statistics TOK_FOR rel_subquery ',' /*1R*/ TOK_SUMMARY
	;

stats_or_statistics :
	TOK_STATS
	| TOK_STATISTICS
	;

exe_util_get_lob_info :
	TOK_GET TOK_LOB stats_or_statistics TOK_FOR TOK_TABLE table_name
	;

exe_util_hive_query :
	TOK_PROCESS TOK_HIVE TOK_STATEMENT QUOTED_STRING
	| TOK_PROCESS TOK_HIVE TOK_DDL QUOTED_STRING
	| TOK_PROCESS TOK_HIVE TOK_STATEMENT TOK_FROM TOK_FILE QUOTED_STRING
	;

dummy_token_lookahead :
	empty
	| TOK_EXIT
	;

exe_util_display_explain :
	explain_starting_tokens explain_identifier
	;

explain_identifier :
	IDENTIFIER
	| DELIMITED_IDENTIFIER
	| nonreserved_word_for_explain
	;

exe_util_display_explain :
	explain_starting_tokens TOK_PROCEDURE '(' QUOTED_STRING ',' /*1R*/ QUOTED_STRING ')'
	| explain_starting_tokens TOK_FOR TOK_QID qid_identifier
	| explain_starting_tokens TOK_QID qid_identifier TOK_FROM TOK_RMS
	| explain_starting_tokens TOK_QID qid_identifier TOK_FROM TOK_REPOSITORY
	| explain_starting_tokens interactive_query_expression dummy_token_lookahead
	;

optional_options :
	/*empty*/
	| TOK_OPTION QUOTED_STRING
	| TOK_OPTIONS QUOTED_STRING
	;

quoted_string_list :
	QUOTED_STRING
	| quoted_string_list ',' /*1R*/ QUOTED_STRING
	;

col_fam_quoted_string_list :
	TOK_COLUMN TOK_FAMILY QUOTED_STRING
	| col_fam_quoted_string_list ',' /*1R*/ TOK_COLUMN TOK_FAMILY QUOTED_STRING
	;

exe_util_maintain_object :
	TOK_MAINTAIN maintain_object_token table_name maintain_object_options
	| TOK_MAINTAIN TOK_DATABASE maintain_object_options
	| TOK_MAINTAIN TOK_TABLES '(' pipeline_mv_name_list ')' maintain_object_options
	| TOK_INITIALIZE_MAINTAIN
	| TOK_REINITIALIZE_MAINTAIN
	| TOK_REINITIALIZE_MAINTAIN ',' /*1R*/ TOK_DROP TOK_ONLY
	| TOK_REINITIALIZE_MAINTAIN ',' /*1R*/ TOK_CREATE TOK_VIEW
	| TOK_REINITIALIZE_MAINTAIN ',' /*1R*/ TOK_DROP TOK_VIEW
	| TOK_MAINTAIN TOK_CLEAN maintain_object_options
	;

maintain_object_token :
	TOK_TABLE
	| TOK_INDEX
	| TOK_MV
	| TOK_MVGROUP
	| TOK_SCHEMA
	| TOK_CATALOG
	;

maintain_object_options :
	empty
	| ',' /*1R*/ maintain_object_options_list
	;

maintain_object_options_list :
	maintain_object_option
	| maintain_object_option ',' /*1R*/ maintain_object_options_list
	;

maintain_object_option :
	TOK_ALL
	| TOK_UPDATE TOK_STATISTICS optional_mt_options
	| TOK_REFRESH optional_mt_options
	| TOK_REFRESH TOK_ALL TOK_MVS optional_mt_options
	| TOK_UPDATE TOK_MVLOG TOK_STATISTICS optional_mt_options
	| TOK_REFRESH TOK_MVGROUPS TOK_ONLY optional_mt_options
	| TOK_REFRESH TOK_MVS TOK_ONLY optional_mt_options
	| TOK_UPDATE TOK_STATISTICS TOK_ALL TOK_MVS optional_mt_options
	| TOK_GET TOK_DETAILS
	| TOK_GET TOK_DETAILS TOK_OPTIONS QUOTED_STRING
	| TOK_GET TOK_STATUS
	| TOK_GET TOK_STATUS TOK_OPTIONS QUOTED_STRING
	| TOK_GET TOK_LABEL TOK_STATISTICS
	| TOK_GET TOK_LABEL TOK_STATISTICS TOK_ALL TOK_INDEXES
	| TOK_GET TOK_LABEL TOK_STATISTICS TOK_ALL TOK_INTERNAL
	| TOK_GET TOK_LABEL TOK_STATISTICS TOK_ALL TOK_RELATED
	| TOK_RUN run_from run_to run_for
	| TOK_IF TOK_NEEDED
	| TOK_MAX NUMERIC_LITERAL_EXACT_NO_SCALE TOK_TABLES
	| TOK_ENABLE
	| TOK_DISABLE
	| TOK_RESET
	| TOK_CONTINUE TOK_ON /*4L*/ TOK_ERROR
	| TOK_STOP TOK_ON /*4L*/ TOK_ERROR
	| TOK_RETURN TOK_SUMMARY
	| TOK_RETURN TOK_SUMMARY TOK_OPTIONS QUOTED_STRING
	| TOK_RETURN TOK_DETAIL TOK_OUTPUT
	| TOK_DISPLAY
	| TOK_DISPLAY TOK_DETAIL
	| TOK_NO TOK_OUTPUT
	;

run_from :
	TOK_FROM TOK_TIMESTAMP QUOTED_STRING
	| /*empty*/
	;

run_to :
	TOK_TO TOK_TIMESTAMP QUOTED_STRING
	| /*empty*/
	;

run_for :
	TOK_FOR_MAXRUNTIME maxruntime_interval
	| /*empty*/
	;

optional_mt_options :
	QUOTED_STRING
	| /*empty*/
	;

truncate_table_name :
	TOK_PURGEDATA optional_if_exists_clause table_name
	| TOK_TRUNCATE optional_if_exists_clause ddl_qualified_name
	| TOK_TRUNCATE TOK_TABLE optional_if_exists_clause ddl_qualified_name
	;

truncate_table :
	truncate_table_name
	;

exe_util_aqr :
	TOK_GET TOK_ALL TOK_AQR TOK_ENTRIES
	| TOK_SET TOK_AQR TOK_CLEAR TOK_ALL TOK_ENTRIES
	| TOK_SET TOK_AQR TOK_RESET TOK_ALL TOK_ENTRIES
	| TOK_SET TOK_AQR TOK_ENTRY aqr_task aqr_options_list
	;

aqr_task :
	TOK_ADD
	| TOK_DELETE
	| TOK_UPDATE
	;

aqr_options_list :
	aqr_option
	| aqr_option ',' /*1R*/ aqr_options_list
	;

aqr_option :
	TOK_SQLCODE '=' /*5L*/ NUMERIC_LITERAL_EXACT_NO_SCALE
	| TOK_NSK_CODE '=' /*5L*/ NUMERIC_LITERAL_EXACT_NO_SCALE
	| TOK_NUMBER TOK_OF TOK_RETRIES '=' /*5L*/ NUMERIC_LITERAL_EXACT_NO_SCALE
	| TOK_DELAY '=' /*5L*/ NUMERIC_LITERAL_EXACT_NO_SCALE
	| TOK_TYPE '=' /*5L*/ NUMERIC_LITERAL_EXACT_NO_SCALE
	;

load_statement :
	TOK_LOAD TOK_TRANSFORM load_sample_option TOK_INTO table_name query_expression optional_limit_spec
	| TOK_LOAD optional_hbbload_options TOK_INTO table_name query_expression optional_limit_spec
	| TOK_LOAD TOK_COMPLETE TOK_FOR TOK_TABLE table_name
	| TOK_LOAD TOK_CLEANUP TOK_FOR TOK_TABLE table_name
	;

load_sample_option :
	TOK_WITH TOK_SAMPLE
	| empty
	;

optional_hbbload_options :
	TOK_WITH hbbload_option_list
	| empty
	;

hbbload_option_list :
	hbbload_option
	| hbbload_option ',' /*1R*/ hbbload_option_list
	| hbbload_option hbbload_option_list
	;

hbbload_option :
	hbb_no_recovery_option
	| hbb_truncate_option
	| hbb_update_stats_option
	| hbb_continue_on_error
	| hbb_stop_after_n_error_rows
	| hbb_log_error_rows
	| hbb_no_duplicate_check
	| hbb_no_output
	| hbb_rebuild_indexes
	| hbb_constraints
	| hbb_index_table_only
	| hbb_upsert_using_load
	;

hbb_no_recovery_option :
	TOK_NO TOK_RECOVERY
	;

hbb_truncate_option :
	TOK_TRUNCATE TOK_TABLE
	;

hbb_update_stats_option :
	TOK_UPDATE TOK_STATISTICS
	;

hbb_index_table_only :
	TOK_INDEX TOK_TABLE TOK_ONLY
	;

hbb_no_duplicate_check :
	TOK_NO TOK_DUPLICATE TOK_CHECK
	;

hbb_continue_on_error :
	TOK_CONTINUE TOK_ON /*4L*/ TOK_ERROR
	;

hbb_log_error_rows :
	TOK_LOG TOK_ERROR TOK_ROWS
	| TOK_LOG TOK_ERROR TOK_ROWS TOK_TO QUOTED_STRING
	;

hbb_stop_after_n_error_rows :
	TOK_STOP TOK_AFTER unsigned_integer TOK_ERROR TOK_ROWS
	;

hbb_no_output :
	TOK_NO TOK_OUTPUT
	;

hbb_rebuild_indexes :
	TOK_REBUILD TOK_INDEXES
	;

hbb_constraints :
	TOK_CONSTRAINTS
	;

hbb_upsert_using_load :
	TOK_UPSERT TOK_USING TOK_LOAD
	;

unload_statement :
	TOK_UNLOAD optional_hbb_unload_options TOK_INTO std_char_string_literal query_expression
	| TOK_UNLOAD TOK_EXTRACT optional_hbb_unload_options TOK_TO std_char_string_literal query_expression
	;

optional_hbb_unload_options :
	TOK_WITH hbb_unload_option_list
	| empty
	;

hbb_unload_option_list :
	hbb_unload_option
	| hbb_unload_option hbb_unload_option_list
	;

hbb_unload_option :
	hbb_unload_empty_target
	| hbb_unload_compress
	| hbb_unload_one_file
	| hbb_unload_no_output
	| hbb_unload_delimiter
	| hbb_unload_record_separator
	| hbb_unload_null_string
	| hbb_unload_header
	| hbb_unload_append
	| hbb_unload_snapshot
	;

hbb_unload_empty_target :
	TOK_PURGEDATA TOK_FROM TOK_TARGET
	| TOK_TRUNCATE TOK_FROM TOK_TARGET
	;

hbb_unload_compress :
	TOK_COMPRESSION TOK_GZIP
	;

hbb_unload_one_file :
	TOK_MERGE TOK_FILE std_char_string_literal hbb_unload_optional_overwrite
	;

hbb_unload_no_output :
	TOK_NO TOK_OUTPUT
	;

hbb_unload_delimiter :
	TOK_DELIMITER std_char_string_literal
	| TOK_DELIMITER unsigned_smallint
	;

hbb_unload_record_separator :
	TOK_RECORD_SEPARATOR std_char_string_literal
	| TOK_RECORD_SEPARATOR unsigned_smallint
	;

hbb_unload_null_string :
	TOK_NULL_STRING std_char_string_literal
	;

hbb_unload_header :
	TOK_NO TOK_HEADER
	;

hbb_unload_append :
	TOK_APPEND
	;

hbb_unload_snapshot :
	hbb_unload_existing_snap TOK_SNAPSHOT TOK_HAVING TOK_SUFFIX QUOTED_STRING
	;

hbb_unload_existing_snap :
	TOK_NEW
	| TOK_EXISTING
	;

hbb_unload_optional_overwrite :
	TOK_OVERWRITE
	| empty
	;

standalone_call_statement :
	TOK_CALL routine_invocation
	| '{' TOK_CALL routine_invocation '}'
	;

routine_invocation :
	routine_name '(' routine_arg_list ')'
	;

routine_name :
	qualified_name
	;

routine_arg_list :
	/*empty*/
	| value_expression_list
	;

query_expression :
	non_join_query_expression
	;

query_term :
	non_join_query_term
	;

query_primary :
	non_join_query_primary
	;

non_join_query_expression :
	non_join_query_term
	| query_expression TOK_UNION /*2L*/ query_term
	| query_expression TOK_UNION /*2L*/ TOK_ALL query_term
	| query_expression TOK_EXCEPT /*2L*/ query_term
	| query_expression TOK_EXCEPT /*2L*/ TOK_ALL query_term
	;

non_join_query_term :
	non_join_query_primary
	| query_term TOK_INTERSECT /*2L*/ distinct_sugar query_primary
	| query_term TOK_INTERSECT /*2L*/ TOK_ALL query_primary
	;

distinct_sugar :
	TOK_DISTINCT
	| /*empty*/
	;

non_join_query_primary :
	simple_table
	| rel_subquery
	;

simple_table :
	query_specification
	| table_value_constructor
	| TOK_TABLE table_name
	;

rel_subquery :
	'(' query_expression order_by_clause optional_limit_spec ')'
	;

predicate :
	directed_comparison_predicate
	| key_comparison_predicate
	| overlaps_predicate
	| between_predicate predicate_selectivity_hint
	| quantified_predicate predicate_selectivity_hint
	| in_predicate predicate_selectivity_hint
	| like_predicate predicate_selectivity_hint
	| exists_predicate
	| null_predicate predicate_selectivity_hint
	| internal_bool_placeholder
	;

predicate_selectivity_hint :
	empty
	| TOK_BEGIN_HINT TOK_SELECTIVITY selectivity_number TOK_END_HINT
	;

selectivity_number :
	number
	;

null_predicate :
	value_expression_list TOK_IS TOK_NULL
	| value_expression_list TOK_IS TOK_NOT TOK_NULL
	;

comparison_operator :
	'=' /*5L*/
	| '<' /*5L*/
	| '>' /*5L*/
	| TOK_NOT_EQUAL /*5L*/
	| TOK_LESS_EQUAL /*5L*/
	| TOK_GREATER_EQUAL /*5L*/
	;

between_operator :
	TOK_BETWEEN
	| TOK_NOT_BETWEEN
	;

quantifier :
	TOK_ALL
	| TOK_ANY
	| TOK_SOME
	;

comparison_predicate :
	value_expression comparison_operator value_expression
	| row_subquery comparison_operator value_expression
	| value_expression_list_comma comparison_operator value_expression_list_comma
	| value_expression_list_comma comparison_operator row_subquery
	| row_subquery comparison_operator value_expression_list_comma
	| value_expression_list_paren comparison_operator value_expression_list_paren
	| value_expression_list_paren comparison_operator row_subquery
	| row_subquery comparison_operator value_expression_list_paren
	;

scan_key_hint :
	empty
	| TOK_BEGIN_HINT TOK_PREFER_FOR_SCAN_KEY TOK_END_HINT
	;

key_comparison_predicate :
	TOK_KEY_RANGE_COMPARE '(' partitioning_key_type comparison_operator '(' value_expression_list ')' pkey_access_path ')'
	| TOK_KEY_RANGE_COMPARE '(' TOK_CLUSTERING TOK_KEY comparison_operator '(' value_expression_list ')' ckey_access_path ')'
	;

partitioning_key_type :
	TOK_PARTITIONING TOK_KEY '(' value_expression_list ')'
	;

pkey_access_path :
	TOK_ON /*4L*/ TOK_TABLE actual_table_name
	| TOK_ON /*4L*/ TOK_INDEX_TABLE actual_table_name
	;

ckey_access_path :
	pkey_access_path
	| TOK_ON /*4L*/ special_regular_table_name
	| TOK_ON /*4L*/ special_index_table_name
	| /*empty*/
	;

directed_comparison_predicate :
	comparison_predicate scan_key_hint
	| comparison_predicate TOK_BEGIN_HINT TOK_SELECTIVITY selectivity_number TOK_END_HINT
	| comparison_predicate TOK_DIRECTEDBY direction_vector
	;

direction_vector :
	'(' direction_vector_comma_list ')'
	;

direction_vector_comma_list :
	direction_literal
	| direction_vector_comma_list ',' /*1R*/ direction_literal
	;

direction_literal :
	ddl_ordering_spec
	;

quantified_predicate :
	value_expression comparison_operator quantifier rel_subquery
	| row_subquery comparison_operator quantifier rel_subquery
	| value_expression_list_comma comparison_operator quantifier rel_subquery
	| value_expression_list_paren comparison_operator quantifier rel_subquery
	;

in_predicate :
	value_expression_list TOK_IN rel_subquery
	| value_expression_list TOK_NOT_IN rel_subquery
	| value_expression_list TOK_IN '(' value_expression_list_lr ')'
	| value_expression_list TOK_NOT_IN '(' value_expression_list_lr ')'
	| value_expression_list TOK_IN literal
	;

between_predicate :
	value_expression between_operator value_expression TOK_AND /*6L*/ value_expression
	| row_subquery between_operator value_expression TOK_AND /*6L*/ value_expression
	| row_subquery between_operator row_subquery TOK_AND /*6L*/ row_subquery
	| value_expression_list_comma between_operator value_expression_list_comma TOK_AND /*6L*/ value_expression_list_comma
	| value_expression_list_comma between_operator value_expression_list_comma TOK_AND /*6L*/ row_subquery
	| value_expression_list_comma between_operator row_subquery TOK_AND /*6L*/ value_expression_list_comma
	| value_expression_list_comma between_operator row_subquery TOK_AND /*6L*/ row_subquery
	| row_subquery between_operator value_expression_list_comma TOK_AND /*6L*/ value_expression_list_comma
	| row_subquery between_operator value_expression_list_comma TOK_AND /*6L*/ row_subquery
	| row_subquery between_operator row_subquery TOK_AND /*6L*/ value_expression_list_comma
	| value_expression_list_paren between_operator value_expression_list_paren TOK_AND /*6L*/ value_expression_list_paren
	| value_expression_list_paren between_operator value_expression_list_paren TOK_AND /*6L*/ row_subquery
	| value_expression_list_paren between_operator row_subquery TOK_AND /*6L*/ value_expression_list_paren
	| value_expression_list_paren between_operator row_subquery TOK_AND /*6L*/ row_subquery
	| row_subquery between_operator value_expression_list_paren TOK_AND /*6L*/ value_expression_list_paren
	| row_subquery between_operator value_expression_list_paren TOK_AND /*6L*/ row_subquery
	| row_subquery between_operator row_subquery TOK_AND /*6L*/ value_expression_list_paren
	;

not_like :
	TOK_LIKE
	| TOK_NOT TOK_LIKE
	;

like_predicate :
	value_expression not_like value_expression
	| value_expression not_like value_expression TOK_ESCAPE value_expression
	| value_expression not_like value_expression '{' TOK_ESCAPE value_expression '}'
	| value_expression TOK_REGEXP value_expression
	;

exists_predicate :
	TOK_EXISTS rel_subquery
	;

overlaps_predicate :
	value_expression_list_paren TOK_OVERLAPS value_expression_list_paren
	;

search_condition :
	boolean_term
	| search_condition TOK_OR boolean_term
	;

boolean_term :
	boolean_factor
	| boolean_term TOK_AND /*6L*/ boolean_factor
	;

boolean_factor :
	TOK_NOT boolean_test
	| boolean_test
	;

boolean_test :
	boolean_primary TOK_IS TOK_NOT truth_value
	| boolean_primary TOK_IS truth_value
	| boolean_primary
	;

truth_value :
	TOK_TRUE
	| TOK_FALSE
	| TOK_UNKNOWN
	;

boolean_primary :
	predicate
	| '(' search_condition ')'
	| '(' search_condition ')' TOK_BEGIN_HINT TOK_SELECTIVITY selectivity_number TOK_END_HINT
	;

Rest_Of_insert_statement :
	no_check_log no_rollback TOK_INTO table_name query_expression order_by_clause access_type optional_limit_spec
	| no_check_log no_rollback TOK_INTO TOK_TABLE table_name query_expression order_by_clause access_type optional_limit_spec
	| TOK_OVERWRITE TOK_TABLE table_name query_expression order_by_clause access_type optional_limit_spec
	| no_check_log no_rollback TOK_INTO table_name '(' '*' /*8L*/ ')' query_expression order_by_clause access_type optional_limit_spec
	| no_check_log no_rollback TOK_INTO table_name TOK_DEFAULT TOK_VALUES
	| no_check_log no_rollback TOK_INTO table_name '(' '*' /*8L*/ ')' TOK_DEFAULT TOK_VALUES
	| no_check_log no_rollback TOK_INTO table_name '(' column_list ')' query_expression order_by_clause optional_limit_spec
	| no_check_log no_rollback TOK_INTO table_name table_value_constructor atomic_clause
	| no_check_log no_rollback TOK_INTO table_name '(' '*' /*8L*/ ')' table_value_constructor atomic_clause
	| no_check_log no_rollback TOK_INTO table_name '(' column_list ')' table_value_constructor atomic_clause
	;

Rest_Of_insert_wo_INTO_statement :
	table_name query_expression order_by_clause access_type
	| table_name '(' column_list ')' query_expression order_by_clause
	;

Front_Of_Insert :
	TOK_INSERT
	| TOK_UPSERT
	| TOK_INSERT TOK_USING TOK_VSBB
	| TOK_INSERT TOK_USING TOK_LOAD
	| TOK_UPSERT TOK_USING TOK_LOAD
	;

front_of_insert_with_rwrs :
	TOK_UPSERT TOK_USING TOK_ROWSET
	;

front_of_insert :
	TOK_INS
	| Front_Of_Insert
	;

atomic_clause :
	TOK_ATOMIC
	| TOK_NOT TOK_ATOMIC
	;

column_list :
	identifier
	| identifier ',' /*1R*/ column_list
	;

merge_statement :
	merge_stmt_start_tokens TOK_INTO table_name merge_stmt_using_clause merge_stmt_on_condition merge_stmt_when_clause
	;

merge_stmt_start_tokens :
	TOK_MERGE
	;

merge_stmt_using_clause :
	empty
	| TOK_USING rel_subquery as_clause
	| TOK_USING rel_subquery as_clause '(' derived_column_list ')'
	;

merge_stmt_on_condition :
	TOK_ON /*4L*/ search_condition
	;

merge_stmt_when_clause :
	merge_stmt_when_matched
	| merge_stmt_when_not_matched
	| merge_stmt_when_matched merge_stmt_when_not_matched
	| merge_stmt_when_not_matched merge_stmt_when_matched
	;

merge_stmt_when_matched :
	TOK_WHEN TOK_MATCHED TOK_THEN TOK_UPDATE TOK_SET merge_stmt_set_clause where_clause
	| TOK_WHEN TOK_MATCHED TOK_THEN TOK_UPD TOK_SET merge_stmt_set_clause where_clause
	| TOK_WHEN TOK_MATCHED TOK_THEN TOK_DELETE
	;

merge_stmt_set_clause :
	set_update_commit_list
	;

merge_stmt_when_not_matched :
	TOK_WHEN TOK_NOT TOK_MATCHED TOK_THEN TOK_INSERT merge_insert_with_values
	| TOK_WHEN TOK_NOT TOK_MATCHED TOK_THEN TOK_INS merge_insert_with_values
	;

merge_insert_with_values :
	'(' column_list ')' TOK_VALUES '(' value_expression_list ')'
	| TOK_VALUES '(' value_expression_list ')'
	;

update_statement_searched :
	TOK_UPDATE update_statement_searched_body
	;

update_statement_searched_body :
	update_statement_target_table set_update_list where_clause
	| update_statement_target_table as_clause set_update_list where_clause
	| TOK_WITH TOK_NO TOK_ROLLBACK update_statement_target_table set_update_list where_clause
	| TOK_WITH TOK_NO TOK_ROLLBACK update_statement_target_table as_clause set_update_list where_clause
	| update_statement_target_table set_update_list TOK_WHERE TOK_CURRENT TOK_OF entity_name_as_item
	| update_statement_target_table as_clause set_update_list TOK_WHERE TOK_CURRENT TOK_OF entity_name_as_item
	| table_as_stream_any set_update_list where_clause
	| '[' firstn_sorted NUMERIC_LITERAL_EXACT_NO_SCALE ']' update_statement_target_table set_update_list where_clause
	| '[' firstn_sorted NUMERIC_LITERAL_EXACT_NO_SCALE ']' update_statement_target_table as_clause set_update_list where_clause
	| TOK_WITH TOK_NO TOK_ROLLBACK '[' firstn_sorted NUMERIC_LITERAL_EXACT_NO_SCALE ']' update_statement_target_table set_update_list where_clause
	| TOK_WITH TOK_NO TOK_ROLLBACK '[' firstn_sorted NUMERIC_LITERAL_EXACT_NO_SCALE ']' update_statement_target_table as_clause set_update_list where_clause
	;

update_statement_target_table :
	table_name optimizer_hint
	;

set_delete_list :
	TOK_SET TOK_ON /*4L*/ TOK_ROLLBACK set_delete_rollback_list
	;

set_delete_rollback_list :
	set_clause
	| set_clause ',' /*1R*/ set_delete_rollback_list
	;

set_update_list :
	TOK_SET set_update_commit_list
	;

set_update_commit_list :
	set_clause
	| set_clause ',' /*1R*/ set_update_commit_list
	| set_clause TOK_SET TOK_ON /*4L*/ TOK_ROLLBACK set_update_rollback_list
	;

set_update_rollback_list :
	set_clause
	| set_clause ',' /*1R*/ set_update_rollback_list
	;

set_clause :
	identifier '=' /*5L*/ value_expression
	| '(' column_list ')' '=' /*5L*/ '(' value_expression_list ')'
	| '(' column_list ')' '=' /*5L*/ rel_subquery
	| identifier '=' /*5L*/ update_obj_to_lob_function
	;

delete_start_tokens :
	TOK_DELETE no_check_log TOK_FROM table_name optimizer_hint
	| TOK_DELETE no_check_log TOK_FROM table_name TOK_AS correlation_name optimizer_hint
	;

delete_statement :
	TOK_DELETE TOK_COLUMNS '(' quoted_string_list ')' TOK_FROM table_name optimizer_hint where_clause
	| delete_start_tokens where_clause
	| TOK_DELETE no_check_log TOK_WITH TOK_NO TOK_ROLLBACK TOK_FROM table_name optimizer_hint where_clause
	| TOK_DELETE no_check_log TOK_WITH TOK_NO TOK_ROLLBACK TOK_FROM table_name TOK_AS correlation_name optimizer_hint where_clause
	| TOK_DELETE no_check_log ignore_triggers '[' firstn_sorted NUMERIC_LITERAL_EXACT_NO_SCALE ']' TOK_FROM table_name optimizer_hint where_clause
	| TOK_DELETE no_check_log TOK_WITH TOK_NO TOK_ROLLBACK '[' firstn_sorted NUMERIC_LITERAL_EXACT_NO_SCALE ']' TOK_FROM table_name optimizer_hint where_clause
	| delete_start_tokens TOK_WHERE TOK_CURRENT TOK_OF entity_name_as_item
	| TOK_DELETE no_check_log TOK_FROM table_as_stream_any where_clause
	| TOK_DELETE no_check_log TOK_FROM table_name set_delete_list where_clause
	| TOK_DELETE no_check_log TOK_FROM table_name set_delete_list TOK_WHERE TOK_CURRENT TOK_OF entity_name_as_item
	| TOK_DELETE no_check_log TOK_FROM table_as_stream_any set_delete_list where_clause
	| TOK_DELETE no_check_log TOK_WITH TOK_MULTI TOK_COMMIT multi_commit_size TOK_FROM table_name
	| TOK_DELETE no_check_log TOK_WITH TOK_MULTI TOK_COMMIT multi_commit_size TOK_FROM table_name TOK_WHERE search_condition
	| TOK_DELETE TOK_ALL TOK_FROM TOK_TABLE '(' TOK_NATABLE_CACHE '(' ')' ')'
	| TOK_DELETE TOK_ALL TOK_FROM TOK_TABLE '(' TOK_QUERY_CACHE '(' value_expression_list ')' ')'
	| TOK_DELETE TOK_ALL TOK_FROM TOK_TABLE '(' TOK_NAROUTINE_CACHE '(' ')' ')'
	;

multi_commit_size :
	empty
	| TOK_EVERY unsigned_integer TOK_ROWS
	;

transaction_statement :
	TOK_BEGIN
	| TOK_BEGIN TOK_WORK
	| TOK_BT
	| TOK_COMMIT
	| TOK_COMMIT TOK_WORK
	| TOK_ET
	| TOK_ROLLBACK
	| TOK_ROLLBACK TOK_WORK
	| TOK_ROLLBACK TOK_WAITED
	| TOK_ROLLBACK TOK_WORK TOK_WAITED
	| TOK_ROLLBACK TOK_NO TOK_WAITED
	| TOK_ROLLBACK TOK_WORK TOK_NO TOK_WAITED
	| TOK_SET TOK_TRANSACTION TOK_AUTOCOMMIT on_off
	| TOK_SET TOK_TRANSACTION TOK_AUTOBEGIN on_off
	| TOK_SET TOK_TRANSACTION TOK_ROLLBACK TOK_WAITED
	| TOK_SET TOK_TRANSACTION TOK_ROLLBACK TOK_NO TOK_WAITED
	| set_transaction_statement
	;

on_off :
	TOK_OFF
	| TOK_ON /*4L*/
	| empty
	;

on_or_empty :
	TOK_OFF
	| TOK_ON /*4L*/
	| empty
	;

autoabort_interval :
	TOK_RESET
	| NUMERIC_LITERAL_EXACT_NO_SCALE hour_hours
	| NUMERIC_LITERAL_EXACT_NO_SCALE minute_minutes
	| NUMERIC_LITERAL_EXACT_NO_SCALE second_seconds
	| unsigned_integer
	;

maxruntime_interval :
	NUMERIC_LITERAL_EXACT_NO_SCALE hour_hours
	| NUMERIC_LITERAL_EXACT_NO_SCALE minute_minutes
	;

hour_hours :
	TOK_HOUR
	| TOK_HOURS
	;

minute_minutes :
	TOK_MINUTE
	| TOK_MINUTES
	;

second_seconds :
	TOK_SECOND
	| TOK_SECONDS
	;

query_suspend_safe :
	TOK_CONTROL TOK_QUERY TOK_SUSPEND TOK_QID identifier
	;

query_suspend_forced :
	TOK_CONTROL TOK_QUERY TOK_SUSPEND TOK_QID identifier ',' /*1R*/ TOK_FORCE
	;

query_activate :
	TOK_CONTROL TOK_QUERY TOK_ACTIVATE TOK_QID identifier
	;

query_cancel_qid :
	TOK_CONTROL TOK_QUERY TOK_CANCEL TOK_QID identifier
	;

query_cancel_pname :
	TOK_CONTROL TOK_QUERY TOK_CANCEL TOK_PID DOLLAR_IDENTIFIER
	;

query_cancel_nid_pid :
	TOK_CONTROL TOK_QUERY TOK_CANCEL TOK_PID NUMERIC_LITERAL_EXACT_NO_SCALE ',' /*1R*/ NUMERIC_LITERAL_EXACT_NO_SCALE
	;

query_cancel_no_comment :
	query_cancel_qid
	| query_cancel_pname
	| query_cancel_nid_pid
	;

query_cancel_optional_comment :
	query_cancel_no_comment
	| query_cancel_no_comment TOK_COMMENT QUOTED_STRING
	;

lock_unlock_statement :
	lock_statement
	| unlock_statement
	;

lock_statement :
	TOK_LOCK TOK_TABLE table_name lock_mode lock_index_option
	| TOK_LOCK TOK_TABLE table_name lock_mode lock_index_option TOK_PARALLEL TOK_EXECUTION TOK_ON /*4L*/
	;

lock_index_option :
	TOK_NO TOK_INDEX TOK_LOCK
	| empty
	;

optional_lock_mode :
	lock_mode
	| /*empty*/
	;

lock_mode :
	TOK_IN TOK_SHARE TOK_MODE
	| TOK_IN TOK_EXCLUSIVE TOK_MODE
	| TOK_IN TOK_PROTECTED TOK_MODE
	;

unlock_statement :
	TOK_UNLOCK TOK_TABLE table_name
	| TOK_UNLOCK TOK_TABLE table_name TOK_PARALLEL TOK_EXECUTION TOK_ON /*4L*/
	;

control_statement :
	TOK_CONTROL TOK_QUERY TOK_SHAPE query_shape_options query_shape_control
	| TOK_CONTROL TOK_QUERY TOK_DEFAULT query_default_control
	| TOK_CQD query_default_control
	| TOK_CONTROL TOK_TABLE table_control
	| TOK_CONTROL TOK_SESSION session_control
	| declare_or_set_cqd
	| set_session_default_statement
	;

osim_statement :
	TOK_CONTROL TOK_OSIM TOK_CAPTURE TOK_LOCATION character_string_literal
	| TOK_CONTROL TOK_OSIM TOK_CAPTURE TOK_STOP
	| TOK_CONTROL TOK_OSIM TOK_LOAD TOK_FROM character_string_literal optional_osim_force
	| TOK_CONTROL TOK_OSIM TOK_SIMULATE TOK_START
	| TOK_CONTROL TOK_OSIM TOK_SIMULATE TOK_CONTINUE character_string_literal
	| TOK_CONTROL TOK_OSIM TOK_UNLOAD character_string_literal
	;

optional_osim_force :
	',' /*1R*/ TOK_FORCE
	| empty
	;

declare_or_set_cqd :
	TOK_DECLARE TOK_CATALOG character_string_literal
	| TOK_DECLARE TOK_CATALOG sql_mx_catalog_name
	| TOK_DECLARE TOK_SCHEMA character_string_literal
	| TOK_DECLARE TOK_SCHEMA schema_name
	| TOK_DECLARE TOK_NAMETYPE character_string_literal
	| TOK_DECLARE TOK_NAMETYPE regular_identifier
	| TOK_SET TOK_CATALOG character_string_literal
	| TOK_SET TOK_CATALOG sql_mx_catalog_name
	| TOK_SET TOK_SCHEMA character_string_literal
	| TOK_SET TOK_SCHEMA schema_name
	| TOK_SET TOK_NAMETYPE character_string_literal
	| TOK_SET TOK_NAMETYPE regular_identifier
	;

query_shape_options :
	TOK_IMPLICIT TOK_EXCHANGE
	| TOK_WITHOUT TOK_EXCHANGE
	| TOK_IMPLICIT TOK_SORT
	| TOK_WITHOUT TOK_SORT
	| TOK_IMPLICIT TOK_EXCHANGE_AND_SORT
	| TOK_IMPLICIT TOK_ENFORCERS
	| TOK_WITHOUT TOK_EXCHANGE_AND_SORT
	| TOK_WITHOUT TOK_ENFORCERS
	| /*empty*/
	;

query_shape_control :
	shape_identifier
	| literal
	| shape_identifier literal
	| shape_identifier shape_identifier
	| shape_identifier '(' shape_arg_list ')'
	| shape_identifier shape_identifier '(' shape_arg_list ')'
	;

shape_identifier :
	identifier
	| token_shape_identifier
	;

token_shape_identifier :
	TOK_JOIN /*3L*/
	| TOK_UNION /*2L*/
	| TOK_OFF
	| TOK_ANY
	| TOK_ALL
	| TOK_TABLE
	| TOK_GROUP
	| TOK_TRANSPOSE
	| TOK_INSERT
	| TOK_UPDATE
	| TOK_DELETE
	;

shape_arg_list :
	query_shape_control
	| shape_arg_list ',' /*1R*/ query_shape_control
	;

qid_identifier :
	identifier
	| TOK_CURRENT
	;

query_default_control :
	default_identifier QUOTED_STRING
	| default_identifier TOK_RESET
	| '*' /*8L*/ TOK_RESET
	| '*' /*8L*/ TOK_RESET TOK_RESET
	| default_identifier TOK_HOLD
	| default_identifier TOK_RESTORE
	;

default_identifier :
	identifier
	| TOK_CATALOG
	| TOK_SCHEMA
	;

table_control :
	table_name table_control_identifier QUOTED_STRING
	| '*' /*8L*/ table_control_identifier QUOTED_STRING
	| table_name table_control_identifier TOK_RESET
	| '*' /*8L*/ table_control_identifier TOK_RESET
	| table_name TOK_RESET
	| '*' /*8L*/ TOK_RESET
	;

table_control_identifier :
	identifier
	| '*' /*8L*/
	;

session_control :
	QUOTED_STRING QUOTED_STRING
	| TOK_SET QUOTED_STRING QUOTED_STRING
	| QUOTED_STRING TOK_RESET
	| TOK_RESET QUOTED_STRING
	| '*' /*8L*/ TOK_RESET
	| TOK_RESET '*' /*8L*/
	;

showcontrol_type :
	'*' /*8L*/
	| TOK_ALL
	| TOK_SHAPE
	| TOK_QUERY TOK_SHAPE
	| TOK_DEFAULT
	| TOK_DEFAULTS
	| TOK_QUERY TOK_DEFAULT
	| TOK_QUERY TOK_DEFAULTS
	| TOK_TABLE
	| TOK_SESSION
	;

showplan_starting_tokens :
	TOK_SHOWPLAN showplan_options
	;

show_statement :
	TOK_SHOWCONTROL showcontrol_type optional_control_identifier optional_comma_match_clause
	| TOK_SHOWDDL table_name ',' /*1R*/ TOK_EXPLAIN
	| TOK_SHOWDDL table_name ',' /*1R*/ TOK_EXPLAIN ',' /*1R*/ TOK_NO TOK_LABEL TOK_STATISTICS
	| TOK_SHOWDDL table_name ',' /*1R*/ TOK_EXPLAIN TOK_INTERNAL ',' /*1R*/ attribute_num_rows_clause
	| TOK_SHOWDDL table_name optional_showddl_object_options_list
	| TOK_SHOWDDL table_name ',' /*1R*/ TOK_LOB TOK_DETAILS optional_showddl_object_options_list
	| TOK_SHOWDDL TOK_TABLE table_name optional_showddl_object_options_list
	| TOK_SHOWDDL table_mapping_function_tokens actual_routine_name optional_showddl_object_options_list
	| TOK_SHOWDDL TOK_SCHEMA schema_name optional_showddl_schema_options_list
	| TOK_SHOWDDL_USER authorization_identifier
	| TOK_SHOWDDL_ROLE authorization_identifier optional_showddl_role_option
	| TOK_SHOWDDL_COMPONENT identifier
	| TOK_SHOWDDL_LIBRARY table_name optional_showddl_object_options_list
	| TOK_SHOWDDL_SEQUENCE table_name optional_showddl_object_options_list
	| TOK_SHOWDDL TOK_PROCEDURE actual_routine_name optional_showddl_object_options_list
	| TOK_SHOWDDL TOK_FUNCTION actual_routine_name optional_showddl_action_name_clause optional_showddl_object_options_list
	| TOK_INVOKE table_name
	| TOK_INVOKE table_as_procedure
	| showplan_starting_tokens interactive_query_expression
	| showplan_starting_tokens TOK_EXPLAIN optional_options interactive_query_expression
	| showplan_starting_tokens TOK_PROCEDURE '(' character_string_literal ',' /*1R*/ character_string_literal ')'
	| TOK_SHOWSHAPE interactive_query_expression
	| TOK_SHOWSTATS TOK_FOR TOK_QUERY query_expression
	| TOK_SHOWSTATS TOK_FOR TOK_TABLE table_name TOK_ON /*4L*/ group_list showstats_opts
	| TOK_SHOWSTATS TOK_FOR TOK_LOG TOK_TABLE table_name TOK_ON /*4L*/ group_list showstats_opts
	| TOK_SHOWTRANSACTION
	| TOK_SHOWSET TOK_DEFAULTS TOK_ALL
	| TOK_SHOWSET TOK_DEFAULTS
	| TOK_SHOWSET TOK_DEFAULT default_identifier
	| TOK_GET TOK_ENVVARS
	;

optional_showddl_action_name_clause :
	empty
	| TOK_ACTION actual_routine_action_name
	;

group_list :
	id_group_list
	| TOK_EVERY TOK_KEY
	| TOK_EVERY TOK_COLUMN
	| TOK_EXISTING TOK_COLUMN
	| TOK_EXISTING TOK_COLUMNS
	| TOK_NECESSARY TOK_COLUMN
	| TOK_NECESSARY TOK_COLUMNS
	| TOK_EVERY TOK_KEY ',' /*1R*/ id_group_list
	| TOK_EVERY TOK_COLUMN ',' /*1R*/ id_group_list
	| TOK_EXISTING TOK_COLUMN ',' /*1R*/ id_group_list
	| TOK_EXISTING TOK_COLUMNS ',' /*1R*/ id_group_list
	| TOK_NECESSARY TOK_COLUMN ',' /*1R*/ id_group_list
	| TOK_NECESSARY TOK_COLUMNS ',' /*1R*/ id_group_list
	;

id_group_list :
	id_group
	| id_group ',' /*1R*/ id_group_list
	;

id_group :
	identifier
	| '(' id_list ')'
	| identifier TOK_TO identifier
	| '(' identifier ')' TOK_TO identifier
	| identifier TOK_TO '(' identifier ')'
	| '(' identifier ')' TOK_TO '(' identifier ')'
	;

id_list :
	identifier
	| identifier ',' /*1R*/ id_list
	;

showstats_opts :
	empty
	| TOK_DETAIL
	;

optional_comma_match_clause :
	empty
	| ',' /*1R*/ TOK_MATCH TOK_FULL /*3L*/
	| ',' /*1R*/ TOK_MATCH TOK_PARTIAL
	| ',' /*1R*/ TOK_MATCH TOK_FULL /*3L*/ ',' /*1R*/ TOK_NO TOK_HEADER
	;

optional_control_identifier :
	default_identifier
	| '*' /*8L*/
	| empty
	;

collate_clause :
	TOK_COLLATE TOK_DEFAULT
	| TOK_COLLATE TOK_CHARACTER TOK_SET
	| TOK_COLLATE qualified_name
	| TOK_COLLATE guardian_location_name
	;

collation_option :
	/*empty*/
	| collate_clause
	;

ordering_spec :
	TOK_ASC
	| TOK_DESC
	| TOK_ASCENDING
	| TOK_DESCENDING
	;

sort_or_group_key :
	value_expression
	;

dml_column_reference :
	qualified_name
	;

sort_spec :
	sort_or_group_key
	| sort_or_group_key collate_clause
	| sort_or_group_key ordering_spec
	| sort_or_group_key collate_clause ordering_spec
	;

sort_spec_list :
	sort_spec
	| sort_spec ',' /*1R*/ sort_spec_list
	;

order_by_clause_non_empty :
	TOK_ORDER TOK_BY sort_spec_list
	;

order_by_clause :
	TOK_ORDER TOK_BY sort_spec_list
	| empty
	;

set_statement :
	set_table_statement
	;

set_table_name :
	table_name
	| HOSTVAR
	| '*' /*8L*/
	;

optional_stream :
	TOK_STREAM
	| empty
	;

timeout_value :
	literal
	| simple_host_variable
	| dynamic_parameter
	;

set_table_statement :
	TOK_SET TOK_TABLE set_table_name optional_stream TOK_TIMEOUT TOK_RESET
	| TOK_SET TOK_TABLE set_table_name optional_stream TOK_TIMEOUT timeout_value
	;

set_session_default_statement :
	TOK_SET TOK_SESSION TOK_DEFAULT default_identifier QUOTED_STRING
	| TOK_SET TOK_PARSERFLAGS NUMERIC_LITERAL_EXACT_NO_SCALE
	| TOK_RESET TOK_PARSERFLAGS NUMERIC_LITERAL_EXACT_NO_SCALE
	| TOK_RESET TOK_PARSERFLAGS
	| TOK_SET TOK_ENVVAR identifier ANY_STRING
	| TOK_RESET TOK_ENVVAR identifier
	;

opt_atomic_clause :
	empty
	| atomic_clause
	;

psm_3gl_statement :
	TOK_BEGIN opt_atomic_clause psm_3gl_block_start TOK_END
	| TOK_IF any_expression TOK_THEN psm_3gl_block_end elseif_else_opt TOK_END TOK_IF
	| TOK_BEGIN TOK_END
	;

elseif_else_opt :
	empty
	| TOK_ELSEIF any_expression TOK_THEN psm_3gl_block_end elseif_else_opt
	| TOK_ELSE psm_3gl_block_end
	;

psm_3gl_block_start :
	psm_3gl_block_end
	;

psm_3gl_block_end :
	psm_3gl_stmt ';' psm_3gl_block_end
	| psm_3gl_stmt ';'
	| psm_3gl_stmt ';' ';'
	;

psm_3gl_stmt :
	interactive_query_expression
	| dynamic_sql_disallowed_in_cs
	;

dynamic_sql_disallowed_in_cs :
	close_statement
	| declare_dynamic_cursor
	| describe_statement
	| dynamic_prepare
	| dynamic_execute
	| execute_immediate
	| fetch_cursor
	| open_cursor
	;

assignment_value :
	query_specification
	| value_expression_list
	;

assignment_statement :
	TOK_SET output_hostvar_list '=' /*5L*/ assignment_value
	;

optional_showddl_schema_options_list :
	empty
	| ',' /*1R*/ showddl_options_list
	;

showddl_options_list :
	showddl_options
	| showddl_options_list ',' /*1R*/ showddl_options
	;

showddl_options :
	TOK_DETAIL
	| TOK_BRIEF
	| TOK_PRIVILEGES
	| TOK_GRANTEES
	| TOK_EXTERNAL
	| TOK_INTERNAL
	| TOK_PRIVILEGES TOK_ONLY
	| TOK_SYNONYMS TOK_ONLY
	;

optional_showddl_object_options_list :
	empty
	| ',' /*1R*/ showddl_options_list
	;

optional_showddl_role_option :
	empty
	| ',' /*1R*/ TOK_GRANTEES
	| ',' /*1R*/ TOK_PRIVILEGES
	;

schema_or_database :
	TOK_SCHEMA
	| TOK_DATABASE
	;

schema_definition :
	TOK_CREATE schema_class schema_or_database schema_name_clause char_set collation_option
	| TOK_CREATE schema_class schema_or_database TOK_IF TOK_NOT TOK_EXISTS schema_name_clause char_set collation_option
	| TOK_CREATE TOK_VOLATILE TOK_SCHEMA
	;

schema_class :
	empty
	| TOK_PRIVATE
	| TOK_SHARED
	;

schema_name_clause :
	schema_name
	| TOK_AUTHORIZATION schema_authorization_identifier
	| schema_name TOK_AUTHORIZATION schema_authorization_identifier
	;

schema_name :
	schema_name_ss
	;

schema_name_ss :
	identifier
	| schema_name_ss '.' /*9L*/ identifier
	;

schema_authorization_identifier :
	authorization_identifier
	;

authorization_identifier :
	identifier
	;

external_user_identifier :
	identifier
	;

routine_definition :
	TOK_CREATE TOK_PROCEDURE optional_if_not_exists_clause ddl_qualified_name routine_params_list_clause optional_create_routine_attribute_list optional_by_auth_identifier
	| TOK_CREATE create_scalar_function_tokens optional_if_not_exists_clause ddl_qualified_name routine_params_list_clause optional_routine_returns_clause optional_passthrough_inputs_clause optional_create_function_attribute_list
	| TOK_CREATE table_mapping_function_tokens optional_if_not_exists_clause ddl_qualified_name routine_params_list_clause optional_routine_returns_clause optional_passthrough_inputs_clause optional_create_function_attribute_list optional_by_auth_identifier
	| TOK_CREATE universal_function_tokens optional_if_not_exists_clause ddl_qualified_name universal_function_param_clause optional_create_function_attribute_list
	;

create_scalar_function_tokens :
	TOK_FUNCTION
	| TOK_SCALAR TOK_FUNCTION
	;

table_mapping_function_tokens :
	TOK_TABLE_MAPPING TOK_FUNCTION
	;

universal_function_tokens :
	TOK_UNIVERSAL TOK_FUNCTION
	;

universal_function_param_clause :
	'(' universal_function_param_list ')'
	;

universal_function_param_list :
	universal_function_param
	| universal_function_param_list ',' /*1R*/ universal_function_param
	;

universal_function_param :
	empty
	| TOK_ACTION
	| TOK_SAS_FORMAT
	| TOK_SAS_LOCALE
	| TOK_SAS_MODEL_INPUT_TABLE
	;

routine_params_list_clause :
	'(' routine_params_list ')'
	| TOK_LPAREN_BEFORE_DATATYPE routine_params_list ')'
	;

alter_function_statement :
	TOK_ALTER universal_function_tokens ddl_qualified_name TOK_ADD TOK_ACTION routine_action_qualified_name routine_params_list_clause routine_returns_clause optional_passthrough_inputs_clause optional_create_function_attribute_list
	| TOK_ALTER universal_function_tokens ddl_qualified_name TOK_DROP TOK_ACTION routine_action_qualified_name optional_cleanup optional_drop_behavior optional_validate optional_logfile
	| TOK_ALTER TOK_FUNCTION ddl_qualified_name optional_alter_passthrough_inputs_clause optional_add_passthrough_inputs_clause optional_create_function_attribute_list
	| TOK_ALTER universal_function_tokens ddl_qualified_name TOK_ALTER TOK_ACTION routine_action_qualified_name optional_alter_passthrough_inputs_clause optional_add_passthrough_inputs_clause optional_create_function_attribute_list
	| TOK_ALTER table_mapping_function_tokens ddl_qualified_name optional_alter_passthrough_inputs_clause optional_add_passthrough_inputs_clause optional_create_function_attribute_list
	;

optional_alter_passthrough_inputs_clause :
	empty
	| alter_passthrough_inputs_clause
	;

alter_passthrough_inputs_clause :
	TOK_ALTER passthrough_inputs_clause_start_tokens alter_passthrough_params_list
	;

alter_passthrough_params_list :
	alter_passthrough_param
	| '(' alter_passthrough_params ')'
	;

alter_passthrough_params :
	alter_passthrough_param
	| alter_passthrough_params ',' /*1R*/ alter_passthrough_param
	;

alter_passthrough_param :
	passthrough_param_position passthrough_input_value optional_passthrough_input_type
	;

optional_add_passthrough_inputs_clause :
	empty
	| TOK_ADD passthrough_inputs_clause
	;

routine_execution_mode :
	TOK_FAST
	| TOK_SAFE
	;

optional_routine_returns_clause :
	empty
	| routine_returns_clause
	;

routine_returns_clause :
	return_tokens routine_return_param
	| return_tokens routine_return_params
	;

return_tokens :
	TOK_RETURN
	| TOK_RETURNS
	;

routine_return_params :
	'(' routine_return_param_list ')'
	| TOK_LPAREN_BEFORE_DATATYPE routine_return_param_list ')'
	;

routine_return_param_list :
	routine_return_param_optional_not_null
	| routine_return_param_list ',' /*1R*/ routine_return_param_optional_not_null
	;

routine_return_param :
	optional_return_param_mode optional_param_name routine_predef_type
	;

routine_return_param_optional_not_null :
	optional_return_param_mode optional_param_name routine_predef_type optional_cast_spec_not_null_spec
	;

optional_return_param_mode :
	TOK_OUT
	| empty
	;

passthrough_inputs_clause_start_tokens :
	TOK_PASS TOK_THROUGH TOK_INPUT
	| TOK_PASS TOK_THROUGH TOK_INPUTS
	;

optional_passthrough_inputs_clause :
	empty
	| passthrough_inputs_clause
	;

passthrough_inputs_clause :
	passthrough_inputs_clause_start_tokens passthrough_params_list
	;

passthrough_params_list :
	passthrough_param
	| '(' passthrough_params ')'
	;

passthrough_params :
	passthrough_param
	| passthrough_params ',' /*1R*/ passthrough_param
	;

passthrough_param :
	passthrough_input_value optional_passthrough_input_type
	;

optional_passthrough_input_type :
	TOK_TEXT
	| TOK_BINARY
	| empty
	;

passthrough_param_position :
	TOK_POSITION unsigned_integer
	;

passthrough_input_value :
	TOK_VALUE literal_negatable
	| TOK_VALUE TOK_FROM TOK_FILE std_char_string_literal
	;

routine_params_list :
	empty
	| routine_params
	;

routine_params :
	routine_param
	| routine_params ',' /*1R*/ routine_param
	;

routine_param :
	optional_param_mode optional_param_name routine_predef_type optional_cast_spec_not_null_spec
	;

routine_predef_type :
	predef_type
	;

optional_param_name :
	empty
	| param_name
	;

param_name :
	IDENTIFIER
	| DELIMITED_IDENTIFIER
	| nonreserved_word
	| nonreserved_func_word
	;

optional_param_mode :
	TOK_IN
	| TOK_OUT
	| TOK_INOUT
	| empty
	;

optional_create_routine_attribute_list :
	empty
	| create_routine_attribute_list
	;

create_routine_attribute_list :
	create_routine_attribute
	| create_routine_attribute_list create_routine_attribute
	;

optional_create_function_attribute_list :
	empty
	| create_function_attribute_list
	;

create_function_attribute_list :
	create_function_attribute
	| create_function_attribute_list create_function_attribute
	;

std_char_string_literal :
	QUOTED_STRING
	| std_char_string_literal QUOTED_STRING
	;

create_routine_attribute :
	location_clause
	| udr_external_name_clause
	| udr_external_path_clause
	| udr_language_clause
	| udr_library_clause
	| udr_param_style_clause
	| udr_access_clause
	| udr_result_sets_clause
	| udr_deterministic_clause
	| udr_isolate_clause
	| udr_transaction_clause
	| udr_external_security_clause
	;

create_function_attribute :
	create_function_udr_attribute
	| create_function_udf_attribute
	;

create_function_udr_attribute :
	location_clause
	| udr_external_name_clause
	| udr_language_clause
	| udr_deterministic_clause
	| udr_access_clause
	| udr_isolate_clause
	| udr_transaction_clause
	| udr_library_clause
	;

create_function_udf_attribute :
	udf_param_style_clause
	| udf_version_tag_clause
	| udf_optimization_hint_clause
	| udf_state_area_clause
	| udf_execution_mode_clause
	| udf_special_attributes_clause
	| udf_parallelism_clause
	| udf_final_call_clause
	;

udr_external_name_clause :
	TOK_EXTERNAL TOK_NAME std_char_string_literal
	;

udr_external_path_clause :
	TOK_EXTERNAL TOK_PATH std_char_string_literal
	;

udr_language_clause :
	TOK_LANGUAGE TOK_JAVA
	| TOK_LANGUAGE TOK_C
	| TOK_LANGUAGE TOK_CPP
	| TOK_LANGUAGE TOK_SQL
	;

udr_library_clause :
	TOK_LIBRARY ddl_qualified_name
	;

udf_param_style_clause :
	routine_parameter_style_sql
	| routine_parameter_style_sqlrow
	;

routine_parameter_style_sql :
	TOK_PARAMETER TOK_STYLE TOK_SQL
	;

routine_parameter_style_sqlrow :
	TOK_PARAMETER TOK_STYLE TOK_SQLROW
	;

udr_param_style_clause :
	TOK_PARAMETER TOK_STYLE TOK_JAVA
	| routine_parameter_style_sql
	| routine_parameter_style_sqlrow
	| TOK_PARAMETER TOK_STYLE TOK_GENERAL
	;

udr_access_clause :
	TOK_NO TOK_SQL
	| TOK_MODIFIES TOK_SQL TOK_DATA
	| TOK_READS TOK_SQL TOK_DATA
	| TOK_CONTAINS TOK_SQL
	;

udr_result_sets_clause :
	TOK_DYNAMIC TOK_RESULT TOK_SETS unsigned_integer
	;

udr_deterministic_clause :
	TOK_DETERMINISTIC
	| TOK_NOT TOK_DETERMINISTIC
	;

udr_isolate_clause :
	TOK_ISOLATE
	| TOK_NO TOK_ISOLATE
	;

udr_transaction_clause :
	TOK_TRANSACTION TOK_REQUIRED
	| TOK_NO TOK_TRANSACTION TOK_REQUIRED
	;

udr_external_security_clause :
	udr_external_security_definer
	| udr_external_security_invoker
	;

udr_external_security_definer :
	TOK_EXTERNAL TOK_SECURITY TOK_DEFINER
	;

udr_external_security_invoker :
	TOK_EXTERNAL TOK_SECURITY TOK_INVOKER
	;

udf_special_attributes_clause :
	file_attribute_keyword udf_special_attributes
	;

udf_special_attributes :
	std_char_string_literal
	| '(' std_char_string_literal ')'
	;

udf_final_call_clause :
	TOK_FINAL TOK_CALL
	| TOK_NO TOK_FINAL TOK_CALL
	;

udf_state_area_clause :
	TOK_STATE TOK_AREA TOK_SIZE unsigned_integer
	| TOK_NO TOK_STATE TOK_AREA
	;

udf_parallelism_clause :
	TOK_ALLOW TOK_ANY TOK_PARALLELISM
	| TOK_NO TOK_PARALLELISM
	;

udf_execution_mode_clause :
	routine_execution_mode TOK_EXECUTION TOK_MODE
	;

udf_optimization_hint_clause :
	udf_number_of_unique_values_clause
	| udf_optimization_stage udf_resource_kind TOK_COST udf_cost
	;

udf_optimization_stage :
	TOK_INITIAL
	| TOK_NORMAL
	;

udf_resource_kind :
	TOK_CPU
	| TOK_IO
	| TOK_MESSAGE
	;

udf_cost :
	TOK_SYSTEM
	| unsigned_integer
	;

number_of_unique_values_tokens :
	TOK_NUMBER TOK_OF TOK_UNIQUE TOK_OUTPUT TOK_VALUES
	;

udf_number_of_unique_values_clause :
	number_of_unique_values_tokens number_of_unique_output_values
	;

number_of_unique_output_values :
	TOK_SYSTEM
	| '(' unique_output_value_list ')'
	;

unique_output_value_list :
	unique_output_value
	| unique_output_value_list ',' /*1R*/ unique_output_value
	;

unique_output_value :
	TOK_SYSTEM
	| literal
	;

udf_version_tag_clause :
	TOK_VERSION TOK_TAG std_char_string_literal
	;

optional_hive_options :
	empty
	| TOK_HIVE TOK_OPTIONS QUOTED_STRING
	;

table_definition :
	create_table_start_tokens ddl_qualified_name table_definition_body optional_create_table_attribute_list optional_in_memory_clause optional_map_to_hbase_clause optional_hbase_data_format
	| create_table_start_tokens ddl_qualified_name like_definition
	| TOK_CREATE special_table_name table_definition_body optional_create_table_attribute_list
	| create_table_start_tokens ddl_qualified_name table_definition_body optional_create_table_attribute_list create_table_as_attr_list_end ctas_load_and_in_memory_options ctas_insert_columns optional_hive_options create_table_as_token optional_locking_stmt_list query_expression optional_limit_spec
	| create_table_start_tokens ddl_qualified_name optional_create_table_attribute_list create_table_as_attr_list_end ctas_load_and_in_memory_options ctas_insert_columns optional_hive_options create_table_as_token optional_locking_stmt_list query_expression optional_limit_spec
	| TOK_CREATE TOK_HBASE TOK_TABLE identifier '(' col_fam_quoted_string_list ')'
	| TOK_CREATE TOK_HBASE TOK_TABLE identifier '(' col_fam_quoted_string_list ')' hbase_table_options
	;

create_table_start_tokens :
	TOK_CREATE TOK_TABLE optional_if_not_exists_clause
	| TOK_CREATE TOK_EXTERNAL TOK_TABLE optional_if_not_exists_clause
	| TOK_CREATE TOK_IMPLICIT TOK_EXTERNAL TOK_TABLE optional_if_not_exists_clause
	| TOK_CREATE TOK_SET TOK_TABLE optional_if_not_exists_clause
	| TOK_CREATE TOK_MULTISET TOK_TABLE optional_if_not_exists_clause
	| TOK_CREATE TOK_VOLATILE TOK_TABLE optional_if_not_exists_clause
	| TOK_CREATE TOK_LOCAL TOK_TEMPORARY TOK_TABLE optional_if_not_exists_clause
	| TOK_CREATE TOK_GLOBAL TOK_TEMPORARY TOK_TABLE optional_if_not_exists_clause
	| TOK_CREATE ghost TOK_TABLE
	| TOK_CREATE TOK_SET TOK_VOLATILE TOK_TABLE optional_if_not_exists_clause
	| TOK_CREATE TOK_MULTISET TOK_VOLATILE TOK_TABLE optional_if_not_exists_clause
	;

optional_if_not_exists_clause :
	empty
	| TOK_IF TOK_NOT TOK_EXISTS
	;

optional_if_exists_clause :
	empty
	| TOK_IF TOK_EXISTS
	;

optional_if_not_registered_clause :
	empty
	| TOK_IF TOK_NOT TOK_REGISTERED
	| TOK_IF TOK_NOT TOK_EXISTS
	;

optional_if_registered_clause :
	empty
	| TOK_IF TOK_REGISTERED
	| TOK_IF TOK_EXISTS
	;

create_table_as_attr_list_start :
	empty
	;

create_table_as_attr_list_end :
	empty
	;

ctas_load_and_in_memory_options :
	TOK_LOAD TOK_IF TOK_EXISTS
	| TOK_NO_LOAD
	| TOK_NO_LOAD TOK_IN TOK_MEMORY
	| TOK_LOAD TOK_IF TOK_EXISTS TOK_WITH TOK_TRUNCATE
	| TOK_LOAD TOK_IF TOK_EXISTS TOK_WITH TOK_DELETE TOK_DATA
	| empty
	;

ctas_insert_columns :
	TOK_INSERT TOK_COLUMNS '(' view_column_def_list ')'
	| empty
	;

create_table_as_token :
	TOK_AS
	;

table_definition_body :
	table_element_list
	| external_table_definition
	| table_element_list external_table_definition
	;

table_element_list :
	'(' table_elements ')'
	| optional_ignored_table_options '(' table_elements ')'
	;

empty :
	/*empty*/
	;

table_elements :
	table_element
	| table_elements ',' /*1R*/ table_element
	;

table_element :
	set_in_column_defn column_definition reset_in_column_defn
	| table_constraint_definition
	;

set_in_column_defn :
	/*empty*/
	;

reset_in_column_defn :
	/*empty*/
	;

column_definition :
	qualified_name data_type optional_column_attributes
	| qualified_name
	;

column_name :
	identifier
	;

col_def_default_clause :
	TOK_DEFAULT enableCharsetInferenceInColDefaultVal col_def_default_clause_argument
	| TOK_NO_DEFAULT
	| TOK_GENERATED sg_type sg_identity_option
	;

col_def_default_clause_argument :
	literal_negatable
	| datetime_value_function
	| datetime_misc_function_used_as_default
	| builtin_function_user
	| null_constant
	;

sg_type :
	TOK_BY TOK_DEFAULT TOK_AS
	| TOK_ALWAYS TOK_AS
	;

sg_identity_option :
	sg_identity_function
	;

optional_column_attributes :
	empty
	| compress_clause
	| column_attributes optional_compress_clause
	;

column_attributes :
	column_attribute
	| column_attributes column_attribute
	;

column_attribute :
	column_constraint_definition
	| optional_loggable
	| optional_lobattrs
	| heading
	| serialized
	| col_def_default_clause
	;

column_constraint_definition :
	constraint_name_definition column_constraint optional_constraint_attributes
	| column_constraint optional_constraint_attributes
	;

constraint_name_definition :
	TOK_CONSTRAINT constraint_name
	;

column_constraint :
	TOK_NOT TOK_NULL
	| TOK_NOT TOK_NULL TOK_ENABLE
	| TOK_NULL
	| column_unique_specification
	| references_specification
	| check_constraint_definition
	;

optional_loggable :
	TOK_LOGGABLE
	| TOK_NOT TOK_LOGGABLE
	;

optional_lobattrs :
	TOK_STORAGE QUOTED_STRING
	;

ddl_ordering_spec :
	TOK_ASC
	| TOK_ASCENDING
	| TOK_DESC
	| TOK_DESCENDING
	;

column_unique_specification :
	unique_constraint_specification
	| TOK_PRIMARY TOK_KEY optional_nullable_pkey
	| TOK_PRIMARY TOK_KEY optional_nullable_pkey ddl_ordering_spec
	;

unique_constraint_specification :
	TOK_UNIQUE
	;

unique_specification :
	unique_constraint_specification
	| TOK_PRIMARY TOK_KEY optional_nullable_pkey
	| TOK_PRIMARY TOK_KEY optional_nullable_pkey TOK_SERIALIZED
	| TOK_PRIMARY TOK_KEY optional_nullable_pkey TOK_NOT TOK_SERIALIZED
	;

check_constraint_definition :
	check_constraint_starting_tokens search_condition ')'
	;

check_constraint_starting_tokens :
	TOK_CHECK '('
	;

references_specification :
	TOK_REFERENCES referenced_table_and_columns optional_ri_match_clause optional_referential_triggered_action
	;

referenced_table_and_columns :
	ddl_qualified_name
	| ddl_qualified_name '(' reference_column_list ')'
	;

optional_ri_match_clause :
	empty
	| match_clause
	;

match_clause :
	TOK_MATCH match_type
	;

match_type :
	TOK_FULL /*3L*/
	| TOK_PARTIAL
	;

optional_referential_triggered_action :
	empty
	| referential_triggered_actions
	;

referential_triggered_actions :
	referential_triggered_action
	| referential_triggered_actions referential_triggered_action
	;

referential_triggered_action :
	update_rule
	| delete_rule
	;

update_rule :
	TOK_ON /*4L*/ TOK_UPDATE referential_action
	;

delete_rule :
	TOK_ON /*4L*/ TOK_DELETE referential_action
	;

referential_action :
	TOK_CASCADE
	| TOK_SET TOK_NULL
	| TOK_SET TOK_DEFAULT
	| TOK_NO TOK_ACTION
	| TOK_RESTRICT
	;

optional_constraint_attributes :
	empty
	| constraint_attributes
	;

constraint_attributes :
	constraint_attribute
	| constraint_attributes constraint_attribute
	;

format_attributes :
	empty
	| TOK_FORMAT QUOTED_STRING
	;

constraint_attribute :
	constraint_attribute_droppable
	| constraint_attribute_enforced
	;

constraint_attribute_droppable :
	TOK_DROPPABLE
	| TOK_NOT_DROPPABLE
	;

constraint_attribute_enforced :
	TOK_ENFORCED
	| TOK_NOT_ENFORCED
	;

heading :
	TOK_HEADING heading_character_string_literal
	| TOK_NO TOK_HEADING
	;

heading_character_string_literal :
	character_string_literal
	| unicode_string_literal
	;

serialized :
	TOK_SERIALIZED
	| TOK_NOT TOK_SERIALIZED
	;

optional_compress_clause :
	empty
	| compress_clause
	;

compress_clause :
	TOK_COMPRESS
	| TOK_COMPRESS literal
	| TOK_COMPRESS '(' literal ')'
	| TOK_COMPRESS value_expression_list_paren
	;

table_constraint_definition :
	constraint_name_definition table_constraint optional_constraint_attributes
	| table_constraint optional_constraint_attributes
	;

table_constraint :
	unique_constraint_definition
	| references_constraint_definition
	| check_constraint_definition
	;

unique_constraint_definition :
	unique_specification '(' unique_column_list ')'
	;

unique_column_list :
	column_reference_list
	;

column_reference_list :
	column_reference
	| column_reference_list ',' /*1R*/ column_reference
	;

column_reference :
	column_name
	| column_name ddl_ordering_spec
	;

references_constraint_definition :
	TOK_FOREIGN TOK_KEY '(' referencing_columns ')' references_specification
	;

referencing_columns :
	reference_column_list
	;

reference_column_list :
	column_name_list
	;

column_name_list :
	column_name_spec
	| column_name_list ',' /*1R*/ column_name_spec
	;

column_name_spec :
	column_name
	;

like_definition :
	TOK_LIKE source_table optional_like_option_list
	;

external_table_definition :
	TOK_FOR source_table
	;

source_table :
	qualified_name
	| TOK_TABLE '(' TOK_IUD_LOG_TABLE qualified_name optional_special_table_loc_clause ')'
	| TOK_TABLE '(' TOK_RANGE_LOG_TABLE qualified_name optional_special_table_loc_clause ')'
	;

optional_like_option_list :
	empty
	| like_option_list
	;

like_option_list :
	like_option
	| like_option_list like_option
	;

like_option :
	TOK_WITHOUT TOK_CONSTRAINTS
	| TOK_WITH TOK_CONSTRAINTS
	| TOK_WITH TOK_HEADINGS
	| TOK_WITH TOK_PARTITIONS
	| TOK_WITH TOK_HORIZONTAL TOK_PARTITIONS
	| TOK_WITHOUT TOK_SALT
	| TOK_WITHOUT TOK_DIVISION
	| salt_by_clause
	| TOK_LIMIT TOK_COLUMN TOK_LENGTH TOK_TO unsigned_integer
	| TOK_WITHOUT TOK_ROW TOK_FORMAT
	| TOK_WITHOUT TOK_LOB TOK_COLUMNS
	;

optional_create_table_attribute_list :
	create_table_as_attr_list_start
	| create_table_as_attr_list_start create_table_attribute_list
	;

create_table_attribute_list :
	create_table_attribute
	| create_table_attribute_list create_table_attribute
	;

create_table_attribute :
	file_attribute_clause
	| location_clause
	| partition_definition
	| salt_by_clause
	| division_by_clause
	| store_by_clause
	| mv_file_attribute_clause
	| file_attribute_pos_clause
	| table_feature
	| hbase_table_options
	;

file_attribute_clause :
	file_attribute_keyword file_attribute_list
	;

file_attribute_keyword :
	TOK_ATTRIBUTE
	| TOK_ATTRIBUTES
	;

file_attribute_list :
	file_attribute
	| file_attribute_list file_attribute
	| file_attribute_list ',' /*1R*/ file_attribute
	;

file_attribute :
	file_attribute_allocate_clause
	| file_attribute_audit_clause
	| file_attribute_audit_compress_clause
	| file_attribute_block_size_clause
	| file_attribute_buffered_clause
	| file_attribute_clear_on_purge_clause
	| file_attribute_compression_clause
	| file_attribute_deallocate_clause
	| file_attribute_icompress_clause
	| file_attribute_extent_clause
	| file_attribute_maxextent_clause
	| file_attribute_rangelog_clause
	| file_attribute_lockonrefresh_clause
	| file_attribute_insertlog_clause
	| file_attribute_mvs_allowed_clause
	| file_attribute_uid_clause
	| file_attribute_row_format_clause
	| file_attribute_no_label_update_clause
	| file_attribute_owner_clause
	| file_attribute_default_col_fam
	;

file_attribute_allocate_clause :
	TOK_ALLOCATE unsigned_smallint
	;

file_attribute_audit_clause :
	TOK_AUDIT
	| TOK_NO TOK_AUDIT
	;

file_attribute_audit_compress_clause :
	TOK_AUDITCOMPRESS
	| TOK_NO TOK_AUDITCOMPRESS
	;

file_attribute_block_size_clause :
	TOK_BLOCKSIZE unsigned_integer optional_block_size_unit
	;

optional_block_size_unit :
	empty
	| TOK_BYTES
	;

file_attribute_buffered_clause :
	TOK_BUFFERED
	| TOK_NO TOK_BUFFERED
	;

file_attribute_clear_on_purge_clause :
	TOK_CLEARONPURGE
	| TOK_NO TOK_CLEARONPURGE
	;

file_attribute_compression_clause :
	TOK_COMPRESSION
	| TOK_NO TOK_COMPRESSION
	| TOK_COMPRESSION TOK_TYPE TOK_NONE
	| TOK_COMPRESSION TOK_TYPE TOK_SOFTWARE
	| TOK_COMPRESSION TOK_TYPE TOK_HARDWARE
	;

file_attribute_deallocate_clause :
	TOK_DEALLOCATE
	;

file_attribute_icompress_clause :
	TOK_ICOMPRESS
	| TOK_NO TOK_ICOMPRESS
	;

file_attribute_extent_clause :
	TOK_EXTENT file_attribute_extent
	;

optional_page :
	empty
	| TOK_PAGE
	| TOK_PAGES
	;

extent_page :
	unsigned_integer optional_page
	;

signed_extent_page :
	sign extent_page
	;

file_attribute_extent :
	TOK_UNBOUNDED
	| extent_page
	| '(' extent_page ')'
	| '(' extent_page ',' /*1R*/ extent_page ')'
	| signed_extent_page
	| '(' signed_extent_page ')'
	| '(' signed_extent_page ',' /*1R*/ extent_page ')'
	| '(' extent_page ',' /*1R*/ signed_extent_page ')'
	| '(' signed_extent_page ',' /*1R*/ signed_extent_page ')'
	;

file_attribute_maxextent_clause :
	TOK_MAXEXTENTS file_attribute_maxextent
	;

file_attribute_maxextent :
	TOK_UNBOUNDED
	| extent_page
	;

file_attribute_no_label_update_clause :
	TOK_NO TOK_LABEL TOK_UPDATE
	;

file_attribute_rangelog_clause :
	range_log_type TOK_RANGELOG
	;

range_log_type :
	TOK_NO
	| TOK_AUTOMATIC
	| TOK_MANUAL
	| TOK_MIXED
	;

file_attribute_lockonrefresh_clause :
	TOK_LOCKONREFRESH
	| TOK_NO TOK_LOCKONREFRESH
	;

file_attribute_insertlog_clause :
	TOK_INSERTLOG
	| TOK_NO TOK_INSERTLOG
	;

file_attribute_mvs_allowed_clause :
	mvs_allowed_type TOK_MVS TOK_ALLOWED
	;

mvs_allowed_type :
	TOK_NO
	| TOK_ON /*4L*/ TOK_STATEMENT
	| TOK_ON /*4L*/ TOK_REQUEST
	| TOK_RECOMPUTE
	| TOK_ALL
	;

file_attribute_uid_clause :
	TOK_UID NUMERIC_LITERAL_EXACT_NO_SCALE
	;

file_attribute_owner_clause :
	TOK_BY authorization_identifier
	;

file_attribute_row_format_clause :
	TOK_ALIGNED TOK_FORMAT
	| TOK_PACKED TOK_FORMAT
	| TOK_HBASE TOK_FORMAT
	;

file_attribute_default_col_fam :
	TOK_DEFAULT TOK_COLUMN TOK_FAMILY QUOTED_STRING
	;

attribute_inmemory_options_clause :
	TOK_INDEX TOK_LEVELS unsigned_integer
	| TOK_PARTITIONS TOK_EOF NUMERIC_LITERAL_EXACT_NO_SCALE
	;

file_attribute_pos_clause :
	TOK_INITIAL TOK_TABLE TOK_SIZE unsigned_integer
	| TOK_MAX TOK_TABLE TOK_SIZE unsigned_integer
	| TOK_TABLE TOK_SIZE '(' unsigned_integer ',' /*1R*/ unsigned_integer ')'
	| attribute_num_rows_clause
	| attribute_inmemory_options_clause
	| TOK_NUMBER TOK_OF TOK_LOCAL TOK_PARTITIONS unsigned_integer
	| TOK_NO_PARTITION
	| TOK_NO_PARTITIONS
	| TOK_IGNORE TOK_POS
	| TOK_NUMBER TOK_OF TOK_LOCAL TOK_PARTITIONS TOK_SYSTEM
	| TOK_NUMBER TOK_OF TOK_ALL TOK_PARTITIONS unsigned_integer
	| TOK_NUMBER TOK_OF TOK_ALL TOK_PARTITIONS TOK_SYSTEM
	| TOK_NUMBER TOK_OF TOK_PARTITIONS unsigned_integer
	| TOK_NUMBER TOK_OF TOK_PARTITIONS TOK_SYSTEM
	| TOK_DISK TOK_POOL unsigned_integer
	| TOK_DISK TOK_POOL unsigned_integer TOK_OF unsigned_integer
	| TOK_DISK TOK_POOL TOK_ANY TOK_OF unsigned_integer
	;

attribute_num_rows_clause :
	TOK_NUMBER TOK_OF TOK_ROWS unsigned_integer
	| TOK_NUMBER TOK_OF TOK_ROWS NUMERIC_LITERAL_APPROX
	;

partition_type :
	empty
	| TOK_RANGE
	| TOK_HASH
	| TOK_HASH2
	;

table_feature :
	TOK_NOT_DROPPABLE
	| TOK_DROPPABLE
	| TOK_INSERT_ONLY
	| TOK_INSERT_ONLY ',' /*1R*/ TOK_NOT_DROPPABLE
	| TOK_INSERT_ONLY ',' /*1R*/ TOK_DROPPABLE
	| TOK_NOT_DROPPABLE ',' /*1R*/ TOK_INSERT_ONLY
	| TOK_DROPPABLE ',' /*1R*/ TOK_INSERT_ONLY
	;

is_not_droppable :
	TOK_DROPPABLE
	| TOK_NOT_DROPPABLE
	;

online_or_offline :
	TOK_ONLINE
	| TOK_OFFLINE
	;

optional_in_memory_clause :
	empty
	| TOK_IN TOK_MEMORY
	;

optional_map_to_hbase_clause :
	empty
	| TOK_MAP TOK_TO TOK_HBASE TOK_TABLE identifier
	;

optional_hbase_data_format :
	empty
	| TOK_DATA TOK_FORMAT TOK_VARCHAR
	| TOK_DATA TOK_FORMAT TOK_NATIVE
	;

hbase_table_options :
	TOK_HBASE_OPTIONS '(' hbase_options_list ')'
	;

hbase_options_list :
	hbase_option
	| hbase_options_list ',' /*1R*/ hbase_option
	;

hbase_option :
	identifier '=' /*5L*/ QUOTED_STRING
	;

partition_definition :
	partition_type TOK_PARTITION optional_partition_definition_body
	| partition_type TOK_PARTITION_BY partition_by_column_list optional_partition_definition_body
	| partition_type TOK_PARTITION_BY TOK_RANGE_N '(' range_n_args ')'
	;

range_n_args :
	range_n_arg
	| range_n_arg ',' /*1R*/ range_n_args
	;

range_n_arg :
	value_expression TOK_BETWEEN value_expression
	| value_expression TOK_BETWEEN '*' /*8L*/
	| value_expression TOK_BETWEEN value_expression TOK_AND /*6L*/ value_expression
	| value_expression TOK_BETWEEN '*' /*8L*/ TOK_AND /*6L*/ value_expression
	| value_expression TOK_BETWEEN value_expression TOK_AND /*6L*/ '*' /*8L*/
	| value_expression TOK_BETWEEN '*' /*8L*/ TOK_AND /*6L*/ '*' /*8L*/
	| value_expression TOK_BETWEEN value_expression TOK_EACH literal
	| value_expression TOK_BETWEEN value_expression TOK_AND /*6L*/ value_expression TOK_EACH literal
	| value_expression TOK_BETWEEN value_expression TOK_AND /*6L*/ '*' /*8L*/ TOK_EACH literal
	| value_expression
	| '*' /*8L*/
	| value_expression TOK_AND /*6L*/ value_expression
	| '*' /*8L*/ TOK_AND /*6L*/ value_expression
	| value_expression TOK_AND /*6L*/ '*' /*8L*/
	| '*' /*8L*/ TOK_AND /*6L*/ '*' /*8L*/
	| value_expression TOK_EACH literal
	| value_expression TOK_AND /*6L*/ value_expression TOK_EACH literal
	| value_expression TOK_AND /*6L*/ '*' /*8L*/ TOK_EACH literal
	| TOK_NO TOK_RANGE TOK_OR TOK_UNKNOWN
	| TOK_NO TOK_RANGE
	;

partition_by_column_list :
	'(' column_reference_list ')'
	;

optional_partition_definition_body :
	empty
	| partition_definition_body
	;

partition_definition_body :
	'(' partition_list ')'
	;

partition_list :
	range_partition_list
	| system_partition_list
	;

range_partition_list :
	range_partition
	| range_partition_list ',' /*1R*/ range_partition
	;

range_partition :
	partition_add_drop_option TOK_FIRST TOK_KEY key_list location_clause optional_partition_attribute_list
	;

key_list :
	key_value
	| '(' key_value_list ')'
	;

system_partition_list :
	system_partition
	| system_partition_list ',' /*1R*/ system_partition
	;

system_partition :
	partition_add_drop_option location_clause optional_partition_attribute_list
	;

optional_partition_attribute_list :
	empty
	| partition_attribute_list
	;

partition_attribute_list :
	partition_attribute
	| partition_attribute_list partition_attribute
	;

partition_attribute :
	file_attribute_extent_clause
	| file_attribute_maxextent_clause
	;

partition_add_drop_option :
	TOK_ADD
	| TOK_DROP
	;

key_value :
	literal_negatable
	| null_constant
	;

key_value_list :
	key_value
	| key_value_list ',' /*1R*/ key_value
	;

division_by_clause_starting_tokens :
	TOK_DIVISION TOK_BY '('
	;

salt_by_clause :
	TOK_SALT TOK_USING NUMERIC_LITERAL_EXACT_NO_SCALE TOK_PARTITIONS optional_salt_column_list
	;

optional_salt_column_list :
	TOK_ON /*4L*/ '(' column_reference_list ')'
	| /*empty*/
	;

salt_like_clause :
	TOK_SALT TOK_LIKE TOK_TABLE
	;

division_by_clause :
	division_by_clause_starting_tokens sort_by_value_expression_list optional_division_column_names ')'
	;

optional_division_column_names :
	empty
	| TOK_NAMED TOK_AS '(' column_reference_list ')'
	;

store_by_clause :
	TOK_STORE TOK_BY store_option_clause
	| TOK_UNIQUE TOK_PRIMARY_INDEX '(' column_reference_list ')'
	| TOK_PRIMARY_INDEX '(' column_reference_list ')'
	| TOK_PRIMARY TOK_KEY TOK_NOT TOK_SERIALIZED '(' column_reference_list ')'
	| TOK_PRIMARY TOK_KEY TOK_SERIALIZED '(' column_reference_list ')'
	| TOK_PRIMARY TOK_KEY '(' column_reference_list ')'
	;

store_option_clause :
	TOK_UNIQUE unique_store_option
	| store_option
	;

unique_store_option :
	TOK_PRIMARY TOK_KEY
	| '(' column_reference_list ')'
	;

store_option :
	TOK_PRIMARY TOK_KEY
	| '(' column_reference_list ')'
	| TOK_ENTRY TOK_ORDER
	;

view_definition :
	create_view_keywords optional_if_not_exists_clause ddl_qualified_name optional_view_column_list optional_location_clause optional_by_auth_identifier TOK_AS optional_locking_stmt_list query_expression order_by_clause optional_with_check_option
	;

create_view_keywords :
	TOK_CREATE TOK_VIEW
	| TOK_CREATE TOK_SYSTEM TOK_VIEW
	| TOK_CREATE TOK_OR TOK_REPLACE TOK_VIEW
	| TOK_CREATE TOK_OR TOK_REPLACE TOK_VIEW TOK_CASCADE
	;

routine_action_qualified_name :
	routine_action_name
	;

ddl_qualified_name :
	qualified_name
	;

volatile_ddl_qualified_name :
	qualified_name
	;

optional_ignored_table_options :
	optional_ignored_table_option
	| optional_ignored_table_option optional_ignored_table_options
	;

optional_ignored_table_option :
	',' /*1R*/ TOK_FALLBACK optional_ignored_suffix
	| ',' /*1R*/ TOK_NO TOK_FALLBACK optional_ignored_suffix
	| ',' /*1R*/ TOK_FREESPACE '=' /*5L*/ unsigned_integer optional_ignored_suffix
	| ',' /*1R*/ TOK_CHECKSUM '=' /*5L*/ optional_ignored_suffix
	| ',' /*1R*/ TOK_CHECKSUM '=' /*5L*/ IDENTIFIER
	| ',' /*1R*/ TOK_LOG
	| ',' /*1R*/ TOK_NO TOK_LOG
	| ',' /*1R*/ optional_ignored_prefix optional_ignored_prefix2 TOK_JOURNAL
	;

optional_ignored_suffix :
	empty
	| TOK_PROTECTION
	| TOK_PERCENT
	| TOK_ALL
	| TOK_DEFAULT
	;

optional_ignored_prefix :
	empty
	| TOK_NO
	| TOK_DUAL
	| TOK_LOCAL
	| TOK_NOT TOK_LOCAL
	;

optional_ignored_prefix2 :
	empty
	| TOK_BEFORE
	| TOK_AFTER
	;

optional_view_column_list :
	empty
	| view_column_list
	;

view_column_list :
	'(' view_column_def_list ')'
	;

view_column_def_list :
	view_column_definition
	| view_column_def_list ',' /*1R*/ view_column_definition
	;

view_column_definition :
	column_name
	| column_name heading
	;

optional_with_check_option :
	empty
	| with_check_option
	;

with_check_option :
	TOK_WITH optional_levels_clause TOK_CHECK TOK_OPTION
	;

optional_levels_clause :
	empty
	| levels_clause
	;

levels_clause :
	TOK_CASCADED
	| TOK_LOCAL
	;

give_statement :
	TOK_GIVE TOK_SCHEMA schema_name TOK_TO authorization_identifier optional_drop_behavior
	| TOK_GIVE givable_object_type ddl_qualified_name TOK_TO authorization_identifier
	| TOK_GIVE TOK_ALL TOK_FROM authorization_identifier TOK_TO authorization_identifier
	;

givable_object_type :
	TOK_TABLE
	| TOK_VIEW
	| TOK_LIBRARY
	| TOK_PROCEDURE
	| TOK_FUNCTION
	;

revoke_role_statement :
	TOK_REVOKE optional_with_admin_option TOK_ROLE authorization_identifier_list TOK_FROM grantee_list optional_drop_behavior optional_granted_by
	;

optional_with_admin_option :
	empty
	| TOK_WITH TOK_ADMIN TOK_OPTION
	;

authorization_identifier_list :
	authorization_identifier
	| authorization_identifier_list ',' /*1R*/ authorization_identifier
	;

optional_granted_by :
	empty
	| optional_granted TOK_BY TOK_CURRENT_USER
	| optional_granted TOK_BY authorization_identifier
	;

optional_granted :
	empty
	| TOK_GRANTED
	;

grant_statement :
	TOK_GRANT privileges TOK_ON /*4L*/ ddl_object_name optional_action TOK_TO grantee_list optional_with_grant_option optional_granted_by
	;

grant_schema_statement :
	TOK_GRANT privileges TOK_ON /*4L*/ TOK_SCHEMA schema_name TOK_TO grantee_list optional_with_grant_option optional_granted_by
	| TOK_GRANT privileges TOK_ON /*4L*/ TOK_DEFAULT TOK_SCHEMA TOK_TO grantee_list optional_with_grant_option optional_granted_by
	;

grant_role_statement :
	TOK_GRANT TOK_ROLE authorization_identifier_list TOK_TO grantee_list optional_with_admin_option optional_granted_by
	;

grant_component_privilege_stmt :
	TOK_GRANT TOK_COMPONENT privilege_or_privileges_token component_privilege_name_list TOK_ON /*4L*/ component_name TOK_TO authorization_identifier_or_public optional_with_grant_option optional_granted_by
	;

authorization_identifier_or_public :
	authorization_identifier
	| TOK_PUBLIC
	;

component_privilege_name_list :
	component_privilege_name
	| component_privilege_name_list ',' /*1R*/ component_privilege_name
	;

privilege_or_privileges_token :
	TOK_PRIVILEGE
	| TOK_PRIVILEGES
	;

privileges :
	TOK_ALL TOK_PRIVILEGES
	| TOK_ALL
	| privilege_action_list
	;

privilege_action_list :
	privilege_action
	| privilege_action_list ',' /*1R*/ privilege_action
	;

privilege_action :
	TOK_SELECT optional_privilege_column_list
	| TOK_DELETE
	| TOK_EXECUTE
	| TOK_INSERT optional_privilege_column_list
	| TOK_UPDATE optional_privilege_column_list
	| TOK_USAGE
	| TOK_REFERENCES optional_privilege_column_list
	| TOK_ALTER
	| TOK_ALTER_LIBRARY
	| TOK_ALTER_MV
	| TOK_ALTER_MV_GROUP
	| TOK_ALTER_ROUTINE_ACTION
	| TOK_ALTER_ROUTINE
	| TOK_ALTER_SYNONYM
	| TOK_ALTER_TABLE
	| TOK_ALTER_TRIGGER
	| TOK_ALTER_VIEW
	| TOK_CREATE
	| TOK_CREATE_LIBRARY
	| TOK_CREATE_MV
	| TOK_CREATE_MV_GROUP
	| TOK_CREATE_ROUTINE_ACTION
	| TOK_CREATE_ROUTINE
	| TOK_CREATE_TABLE
	| TOK_CREATE_TRIGGER
	| TOK_CREATE_SYNONYM
	| TOK_CREATE_PROCEDURE
	| TOK_CREATE_VIEW
	| TOK_DBA
	| TOK_DROP
	| TOK_DROP_LIBRARY
	| TOK_DROP_MV
	| TOK_DROP_MV_GROUP
	| TOK_DROP_PROCEDURE
	| TOK_DROP_ROUTINE_ACTION
	| TOK_DROP_ROUTINE
	| TOK_DROP_SYNONYM
	| TOK_DROP_TABLE
	| TOK_DROP_TRIGGER
	| TOK_DROP_VIEW
	| TOK_MAINTAIN
	| TOK_REFRESH
	| TOK_TRANSFORM
	| TOK_UPDATE_STATS
	| TOK_ALL_DDL
	| TOK_ALL_DML
	| TOK_ALL_UTILITY
	;

optional_privilege_column_list :
	empty
	| '(' privilege_column_list ')'
	;

privilege_column_list :
	column_name_list
	;

ddl_object_name :
	ddl_qualified_name
	| TOK_TABLE ddl_qualified_name
	| TOK_TABLE_MAPPING ddl_qualified_name
	| TOK_PROCEDURE ddl_qualified_name
	| TOK_FUNCTION ddl_qualified_name
	| TOK_LIBRARY ddl_qualified_name
	| TOK_SEQUENCE ddl_qualified_name
	;

grantee_list :
	grantee
	| grantee_list ',' /*1R*/ grantee
	;

grantee :
	TOK_PUBLIC
	| authorization_identifier
	;

optional_with_grant_option :
	empty
	| with_grant_option
	;

optional_action :
	empty
	| TOK_FOR TOK_ACTION routine_action_qualified_name
	;

with_grant_option :
	TOK_WITH TOK_GRANT TOK_OPTION
	;

optional_by_auth_identifier :
	empty
	| TOK_BY authorization_identifier
	;

constraint_name :
	ddl_qualified_name
	;

catalog_definition :
	TOK_CREATE TOK_CATALOG catalog_definition2
	;

catalog_definition2 :
	sql_mx_catalog_name optional_create_catalog_attribute_list
	;

catalog_name :
	sql_mx_catalog_name
	| sql_mp_catalog_name
	;

sql_mx_catalog_name :
	identifier
	;

sql_mp_catalog_name :
	SYSTEM_VOLUME_NAME '.' /*9L*/ identifier
	| empty
	;

optional_create_catalog_attribute_list :
	empty
	| create_catalog_attribute_list
	;

create_catalog_attribute_list :
	create_catalog_attribute
	| create_catalog_attribute_list create_catalog_attribute
	;

create_catalog_attribute :
	location_clause
	;

location_clause :
	TOK_LOCATION location_definition optional_partition_name_clause
	;

volume_only_name :
	DOLLAR_IDENTIFIER
	;

oss_path_name :
	oss_path_name_elem
	| oss_path_name oss_path_name_elem
	;

oss_path_name_elem :
	'/' /*8L*/ regular_identifier
	;

log_file_name :
	std_char_string_literal
	| regular_identifier
	| oss_path_name
	;

optional_partition_name_clause :
	empty
	| TOK_NAME partition_name
	;

location_definition :
	guardian_location_name
	;

guardian_location_name :
	guardian_volume_name
	| guardian_volume_name '.' /*9L*/ regular_identifier '.' /*9L*/ regular_identifier
	;

guardian_volume_name :
	SYSTEM_VOLUME_NAME
	| volume_only_name
	;

partition_name :
	identifier
	;

trigger_set_clause_list :
	trigger_set_clause
	| trigger_set_clause_list ',' /*1R*/ trigger_set_clause
	;

trigger_set_clause :
	identifier '=' /*5L*/ value_expression
	| identifier '.' /*9L*/ identifier '=' /*5L*/ value_expression
	;

triggered_before_action :
	empty
	| item_signal_statement
	| TOK_SET trigger_set_clause_list
	;

triggered_after_action :
	empty
	| TOK_SET
	| front_of_insert Rest_Of_insert_statement
	| update_statement_searched access_type
	| delete_statement access_type
	| signal_statement
	| standalone_call_statement
	| psm_3gl_statement
	;

triggerred_when_clause :
	empty
	| TOK_WHEN '(' any_expression ')'
	;

iud_event :
	TOK_INSERT
	| TOK_UPDATE
	| TOK_DELETE
	;

optional_update_column_list :
	empty
	| TOK_OF '(' column_reference_list ')'
	;

optional_row_table :
	/*empty*/
	| TOK_ROW
	| TOK_TABLE
	;

referencing_clause :
	empty
	| TOK_REFERENCING TOK_OLD optional_row_table as_clause
	| TOK_REFERENCING TOK_NEW optional_row_table as_clause
	| TOK_REFERENCING TOK_OLD optional_row_table as_clause ',' /*1R*/ TOK_NEW optional_row_table as_clause
	| TOK_REFERENCING TOK_NEW optional_row_table as_clause ',' /*1R*/ TOK_OLD optional_row_table as_clause
	;

before_action_orientation :
	empty
	| TOK_FOR TOK_EACH TOK_ROW
	| TOK_FOR TOK_EACH TOK_STATEMENT
	;

after_action_orientation :
	empty
	| TOK_FOR TOK_EACH TOK_ROW
	| TOK_FOR TOK_EACH TOK_STATEMENT
	;

trigger_definition :
	before_trigger_definition
	| after_trigger_definition
	;

before_trigger_definition :
	before_trigger_prefix triggerred_when_clause triggered_before_action
	;

after_trigger_definition :
	after_trigger_prefix triggerred_when_clause triggered_after_action
	;

before_trigger_prefix :
	create_trigger_keywords ddl_qualified_name optional_by_auth_identifier TOK_BEFORE iud_event optional_update_column_list TOK_ON /*4L*/ ddl_qualified_name referencing_clause before_action_orientation
	;

after_trigger_prefix :
	create_trigger_keywords ddl_qualified_name optional_by_auth_identifier TOK_AFTER iud_event optional_update_column_list TOK_ON /*4L*/ ddl_qualified_name referencing_clause after_action_orientation
	;

create_trigger_keywords :
	TOK_CREATE TOK_TRIGGER
	;

mv_token :
	TOK_MV
	| TOK_MATERIALIZED TOK_VIEW
	;

refresh_type :
	TOK_RECOMPUTE
	| TOK_REFRESH TOK_ON /*4L*/ TOK_STATEMENT
	| TOK_REFRESH TOK_ON /*4L*/ TOK_REQUEST
	| TOK_REFRESH TOK_BY TOK_USER
	;

create_mv_attribute_table_lists :
	empty
	| create_mv_one_attribute_table_list
	| create_mv_attribute_table_lists create_mv_one_attribute_table_list
	;

create_mv_one_attribute_table_list :
	ignore_changes_on_table_list
	;

ignore_changes_on_table_list :
	TOK_IGNORE TOK_CHANGES TOK_ON /*4L*/ qual_name_list
	;

qual_name_list :
	qual_name
	| qual_name_list ',' /*1R*/ qual_name
	;

qual_name :
	ddl_qualified_name
	;

mv_initialization_clause :
	TOK_INITIALIZE TOK_ON /*4L*/ TOK_CREATE
	| TOK_INITIALIZED TOK_ON /*4L*/ TOK_CREATE
	| TOK_INITIALIZE TOK_ON /*4L*/ TOK_REFRESH
	| TOK_INITIALIZED TOK_ON /*4L*/ TOK_REFRESH
	| TOK_NO TOK_INITIALIZATION
	| TOK_INITIALIZE TOK_BY TOK_USER
	;

optional_query_rewrite :
	empty
	| enable_status TOK_QUERY TOK_REWRITE
	;

optional_create_mv_file_options :
	empty
	| create_table_attribute_list
	;

mv_file_attribute_clause :
	mv_file_attribute_keyword mv_file_attribute_list
	;

mv_file_attribute_keyword :
	TOK_MVATTRIBUTE
	| TOK_MVATTRIBUTES
	;

mv_file_attribute_list :
	mv_file_attribute
	| mv_file_attribute_list ',' /*1R*/ mv_file_attribute
	;

mv_file_attribute :
	mv_audit_type
	| TOK_COMMIT TOK_REFRESH TOK_EACH unsigned_integer
	;

mv_audit_type :
	TOK_AUDIT
	| TOK_NO TOK_AUDIT
	| TOK_NO TOK_AUDITONREFRESH
	;

as_token :
	TOK_AS
	;

mv_definition :
	create_mv_keywords ddl_qualified_name optional_view_column_list refresh_type create_mv_attribute_table_lists mv_initialization_clause optional_query_rewrite optional_create_mv_file_options optional_in_memory_clause as_token query_expression
	;

create_mv_keywords :
	TOK_CREATE optional_ghost mv_token
	;

create_mvrgroup_statement :
	TOK_CREATE TOK_MVGROUP ddl_qualified_name
	;

index_definition :
	TOK_CREATE optional_unique_optional_ghost TOK_INDEX index_name TOK_ON /*4L*/ optional_ghost_ddl_qualified_name index_column_list optional_ignore_clause optional_index_option_list optional_in_memory_clause
	| TOK_CREATE TOK_VOLATILE optional_unique_option TOK_INDEX index_name TOK_ON /*4L*/ volatile_ddl_qualified_name index_column_list optional_index_option_list optional_in_memory_clause
	;

populate_index_definition :
	TOK_POPULATE TOK_INDEX index_name TOK_ON /*4L*/ ddl_qualified_name optional_purgedata
	| TOK_POPULATE TOK_ALL TOK_INDEXES TOK_ON /*4L*/ ddl_qualified_name
	| TOK_POPULATE TOK_ALL TOK_UNIQUE TOK_INDEXES TOK_ON /*4L*/ ddl_qualified_name
	;

optional_purgedata :
	empty
	| TOK_PURGEDATA
	;

optional_unique_option :
	empty
	| TOK_UNIQUE
	;

optional_unique_optional_ghost :
	empty
	| TOK_UNIQUE
	| ghost
	| TOK_UNIQUE ghost
	;

optional_ghost_ddl_qualified_name :
	ddl_qualified_name
	| ghost TOK_TABLE ddl_qualified_name
	;

index_name :
	identifier
	;

index_column_list :
	'(' column_reference_list ')'
	;

optional_ignore_clause :
	empty
	| TOK_IGNORE TOK_POS
	;

optional_index_option_list :
	empty
	| index_option_list
	;

index_option_list :
	index_option_spec
	| index_option_list index_option_spec
	;

index_option_spec :
	location_clause
	| partition_definition
	| file_attribute_clause
	| parallel_execution_clause
	| populate_option
	| attribute_num_rows_clause
	| index_division_clause
	| hbase_table_options
	| salt_like_clause
	| TOK_TABLESPACE IDENTIFIER
	;

index_division_clause :
	division_by_clause
	| TOK_DIVISION TOK_LIKE TOK_TABLE
	;

populate_option :
	TOK_NO TOK_POPULATE
	| TOK_POPULATE
	;

parallel_execution_clause :
	TOK_PARALLEL TOK_EXECUTION parallel_execution_spec
	;

parallel_execution_spec :
	TOK_ON /*4L*/
	| TOK_ON /*4L*/ TOK_CONFIG oss_path_name
	| TOK_OFF
	;

initialize_sql_statement :
	TOK_INITIALIZE_SQL optional_create_role_list optional_register_user_list
	;

optional_create_role_list :
	empty
	| init_create_role_list
	;

init_create_role_list :
	init_create_role_element
	| init_create_role_list init_create_role_element
	;

init_create_role_element :
	create_role_statement
	;

optional_register_user_list :
	empty
	| init_register_user_list
	;

init_register_user_list :
	init_register_user_element
	| init_register_user_list init_register_user_element
	;

init_register_user_element :
	register_user_statement
	;

optional_location_clause :
	empty
	| location_clause
	;

create_sequence_statement :
	TOK_CREATE TOK_SEQUENCE ddl_qualified_name sequence_generator_options
	| TOK_CREATE TOK_INTERNAL TOK_SEQUENCE ddl_qualified_name sequence_generator_options
	;

alter_sequence_statement :
	TOK_ALTER TOK_SEQUENCE ddl_qualified_name all_sequence_generator_options
	| TOK_ALTER TOK_INTERNAL TOK_SEQUENCE ddl_qualified_name all_sequence_generator_options
	;

cleanup_objects_statement :
	TOK_CLEANUP cleanup_object_identifier ddl_qualified_name optional_cleanup_return_details
	| TOK_CLEANUP cleanup_object_identifier ddl_qualified_name ',' /*1R*/ TOK_UID NUMERIC_LITERAL_EXACT_NO_SCALE optional_cleanup_return_details
	| TOK_CLEANUP TOK_UID NUMERIC_LITERAL_EXACT_NO_SCALE
	| TOK_CLEANUP TOK_METADATA optional_cleanup_return_details
	| TOK_CLEANUP TOK_METADATA ',' /*1R*/ TOK_CHECK optional_cleanup_return_details
	;

cleanup_object_identifier :
	object_identifier
	| TOK_PRIVATE TOK_SCHEMA
	| TOK_SHARED TOK_SCHEMA
	| TOK_OBJECT
	| TOK_HIVE TOK_TABLE
	| TOK_HIVE TOK_VIEW
	| TOK_HBASE TOK_TABLE
	;

optional_cleanup_return_details :
	empty
	| ',' /*1R*/ TOK_RETURN TOK_DETAILS
	;

drop_sequence_statement :
	TOK_DROP TOK_SEQUENCE ddl_qualified_name
	;

drop_schema_statement :
	TOK_DROP schema_or_database schema_name_clause optional_cleanup optional_drop_behavior
	| TOK_DROP schema_or_database TOK_IF TOK_EXISTS schema_name_clause optional_cleanup optional_drop_behavior
	| TOK_DROP TOK_VOLATILE TOK_SCHEMA schema_name optional_cleanup optional_drop_behavior
	| TOK_DROP TOK_IMPLICIT TOK_VOLATILE TOK_SCHEMA optional_cleanup optional_drop_behavior
	| TOK_DROP TOK_IMPLICIT TOK_VOLATILE TOK_SCHEMA TOK_TABLES optional_cleanup optional_drop_behavior
	;

extension_drop_behavior :
	empty
	| TOK_CASCADE
	;

optional_drop_behavior :
	empty
	| drop_behavior
	;

drop_behavior :
	TOK_CASCADE
	| TOK_RESTRICT
	| TOK_NO TOK_CHECK
	;

optional_drop_index_behavior :
	empty
	| TOK_CASCADE
	| TOK_RESTRICT
	| TOK_NO TOK_CHECK
	;

optional_drop_invalidate_dependent_behavior :
	empty
	| TOK_CASCADE TOK_INVALIDATE
	| drop_behavior
	;

optional_cleanup :
	empty
	| TOK_CLEANUP
	| TOK_WITH TOK_CLEANUP
	;

optional_validate :
	empty
	| TOK_VALIDATE
	;

optional_logfile :
	empty
	| TOK_LOG log_file_name
	;

alter_index_statement :
	TOK_ALTER optional_ghost TOK_INDEX ddl_qualified_name alter_index_action
	;

alter_index_action :
	file_attribute_clause
	| TOK_ALTER hbase_table_options
	;

alter_mv_refresh_group_statement :
	TOK_ALTER TOK_MVGROUP mv_group_name_to_alter mv_group_alter_action_type mv_name_list
	;

mv_group_name_to_alter :
	ddl_qualified_name
	;

mv_group_alter_action_type :
	TOK_ADD
	| TOK_REMOVE
	| TOK_OPENBLOWNAWAY
	| TOK_REDEFTIME
	;

mv_name_list :
	mv_name_node
	| mv_name_list ',' /*1R*/ mv_name_node
	;

mv_name_node :
	ddl_qualified_name
	;

internal_refresh_command :
	TOK_INTERNAL TOK_REFRESH internal_refresh_options
	;

internal_refresh_options :
	internal_refresh_mv_name recompute_refresh_options
	| internal_refresh_mv_name incremental_refresh_options
	;

internal_refresh_mv_name :
	qualified_name
	;

recompute_refresh_options :
	TOK_RECOMPUTE TOK_NODELETE
	| TOK_RECOMPUTE
	;

incremental_refresh_options :
	TOK_FROM TOK_SINGLEDELTA delta_definition_list optional_nrows_clause optional_pipeline_clause
	| TOK_FROM TOK_MULTIDELTA delta_definition_list TOK_PHASE unsigned_integer optional_pipeline_clause
	;

delta_definition_list :
	delta_definition_node
	| delta_definition_list ',' /*1R*/ delta_definition_node
	;

delta_definition_node :
	qualified_name TOK_BETWEEN begin_epoch TOK_AND /*6L*/ end_epoch delta_options
	;

begin_epoch :
	unsigned_integer
	;

end_epoch :
	unsigned_integer
	;

delta_options :
	TOK_DE TOK_LEVEL unsigned_integer delta_def_logs
	;

delta_def_logs :
	delta_def_range_log delta_def_iud_log
	;

delta_def_range_log :
	TOK_USE TOK_NO TOK_RANGELOG
	| TOK_USE TOK_RANGELOG unsigned_integer TOK_NUM_OF_RANGES
	| TOK_USE TOK_RANGELOG unsigned_integer TOK_NUM_OF_RANGES unsigned_integer TOK_ROWS_COVERED
	;

delta_def_iud_log :
	TOK_USE TOK_IUDLOG iud_statistics_rows
	| TOK_USE TOK_NO TOK_IUDLOG
	| TOK_USE TOK_IUDLOG TOK_INSERT TOK_ONLY
	| TOK_USE TOK_IUDLOG
	;

iud_statistics_rows :
	num_inserted num_deleted num_updated optional_update_collumns
	;

num_inserted :
	unsigned_integer TOK_ROWS_INSERTED
	;

num_deleted :
	unsigned_integer TOK_ROWS_DELETED
	;

num_updated :
	unsigned_integer TOK_ROWS_UPDATED
	;

optional_update_collumns :
	TOK_COLUMNS '(' columns_num_list ')'
	| empty
	;

columns_num_list :
	unsigned_integer
	| columns_num_list ',' /*1R*/ unsigned_integer
	;

optional_nrows_clause :
	empty
	| TOK_COMMIT TOK_EACH unsigned_integer TOK_PHASE phase_num optional_catchup
	;

phase_num :
	unsigned_integer
	;

optional_catchup :
	empty
	| TOK_CATCHUP unsigned_integer
	| TOK_CATCHUP dynamic_parameter
	;

optional_pipeline_clause :
	empty
	| pipeline_clause
	;

pipeline_clause :
	TOK_PIPELINE '(' pipeline_mv_name_list ')' pipeline_def_list
	| TOK_PIPELINE '(' pipeline_mv_name_list ')'
	;

pipeline_def_list :
	pipeline_def
	| pipeline_def_list ',' /*1R*/ pipeline_def
	;

pipeline_def :
	qualified_name TOK_PIPELINE '(' pipeline_mv_name_list ')'
	;

pipeline_mv_name_list :
	pipeline_mv_name_node
	| pipeline_mv_name_list ',' /*1R*/ pipeline_mv_name_node
	;

pipeline_mv_name_node :
	qualified_name
	;

mvlog_command :
	mvlog_keywords mvlog_table_name '(' column_list ')' TOK_BETWEEN mvlog_values_list TOK_AND /*6L*/ mvlog_values_list
	;

mvlog_values_list :
	'(' value_expression ')'
	| '(' value_expression_list_comma ')'
	;

mvlog_keywords :
	TOK_MVLOG TOK_INTO TOK_RANGELOG TOK_OF
	;

mvlog_table_name :
	qualified_name
	;

no_check_log :
	empty
	| TOK_NOMVLOG
	| TOK_NO TOK_CHECK
	| TOK_NOMVLOG TOK_NO TOK_CHECK
	| TOK_NO TOK_CHECK TOK_NOMVLOG
	;

ignore_triggers :
	empty
	| TOK_IGNORETRIGGERS
	;

no_rollback :
	empty
	| TOK_WITH TOK_NO TOK_ROLLBACK
	;

enable_status :
	TOK_DISABLE
	| TOK_ENABLE
	;

optional_all_of :
	empty
	| TOK_ALL TOK_OF
	;

alter_trigger_statement :
	TOK_ALTER TOK_TRIGGER enable_status optional_all_of ddl_qualified_name
	;

alter_view_start_tokens :
	TOK_ALTER TOK_VIEW
	;

alter_view_statement :
	alter_view_start_tokens ddl_qualified_name TOK_RENAME TOK_TO identifier
	| alter_view_start_tokens ddl_qualified_name TOK_COMPILE optional_cascade
	;

alter_mv_statement :
	TOK_ALTER optional_ghost mv_token alter_mv_body
	;

alter_mv_body :
	alter_mv_query_rewrite
	| alter_mv_file_attribs
	| alter_mv_mvfile_attribs
	| alter_mv_rename
	| alter_mv_attribute_table_lists
	;

alter_mv_query_rewrite :
	ddl_qualified_name enable_status TOK_QUERY TOK_REWRITE
	;

alter_mv_file_attribs :
	ddl_qualified_name file_attribute_clause
	;

alter_mv_mvfile_attribs :
	ddl_qualified_name mv_file_attribute_clause
	;

alter_mv_rename :
	ddl_qualified_name TOK_RENAME TOK_TO identifier optional_cascade
	;

alter_mv_attribute_table_lists :
	ddl_qualified_name TOK_ADD ignore_changes_on_table_list
	| ddl_qualified_name TOK_REMOVE ignore_changes_on_table_list
	;

optional_cascade :
	empty
	| TOK_CASCADE
	;

optional_skip_view_check :
	empty
	| TOK_SKIP TOK_VIEW TOK_CHECK
	;

alter_audit_config_statement :
	TOK_ALTER TOK_AUDIT TOK_CONFIG TOK_LOG QUOTED_STRING QUOTED_STRING QUOTED_STRING
	;

alter_catalog_statement :
	TOK_ALTER TOK_CATALOG sql_mx_catalog_name enable_status TOK_SCHEMA schema_name
	| TOK_ALTER TOK_CATALOG sql_mx_catalog_name enable_status TOK_ALL TOK_SCHEMA
	| TOK_ALTER TOK_CATALOG sql_mx_catalog_name enable_status TOK_CREATE
	| TOK_ALTER TOK_ALL TOK_CATALOG enable_status TOK_CREATE
	| TOK_ALTER TOK_ALL TOK_CATALOGS enable_status TOK_CREATE
	| TOK_ALTER TOK_CATALOG sql_mx_catalog_name enable_status TOK_CREATE TOK_IN TOK_SCHEMA schema_name
	;

alter_schema_start_tokens :
	TOK_ALTER schema_or_database
	;

alter_schema_statement :
	alter_schema_start_tokens schema_name_clause alter_stored_descriptor_option
	| alter_schema_start_tokens schema_name_clause TOK_DROP TOK_ALL TOK_TABLES
	| alter_schema_start_tokens schema_name_clause TOK_RENAME TOK_TO identifier
	;

alter_library_statement :
	TOK_ALTER TOK_LIBRARY ddl_qualified_name TOK_FILE std_char_string_literal optional_library_clientname optional_library_clientfilename
	;

optional_library_clientname :
	empty
	| TOK_HOST TOK_NAME std_char_string_literal
	;

optional_library_clientfilename :
	empty
	| TOK_LOCAL TOK_FILE std_char_string_literal
	;

create_library_stmt :
	TOK_CREATE optional_system TOK_LIBRARY ddl_qualified_name TOK_FILE std_char_string_literal optional_library_clientname optional_library_clientfilename optional_by_auth_identifier
	;

optional_system :
	empty
	| TOK_SYSTEM
	;

drop_library_statement :
	TOK_DROP TOK_LIBRARY ddl_qualified_name optional_drop_behavior
	;

alter_table_start_tokens :
	TOK_ALTER optional_ghost TOK_TABLE
	;

alter_table_statement :
	alter_table_start_tokens ddl_qualified_name alter_table_action
	| alter_table_start_tokens ddl_qualified_name is_not_droppable
	| alter_table_start_tokens ddl_qualified_name TOK_INSERT_ONLY
	| alter_table_start_tokens ddl_qualified_name TOK_NAMESPACE
	| alter_table_start_tokens ddl_qualified_name online_or_offline
	| alter_table_start_tokens ddl_qualified_name online_or_offline TOK_FOR TOK_PURGEDATA
	| TOK_ALTER TOK_VOLATILE TOK_TABLE volatile_ddl_qualified_name alter_table_action
	| TOK_MSCK TOK_REPAIR TOK_TABLE ddl_qualified_name
	| alter_table_start_tokens ddl_qualified_name TOK_RECOVER TOK_PARTITIONS
	;

ghost :
	TOK_GHOST
	;

optional_ghost :
	empty
	| ghost
	;

alter_table_action :
	add_table_constraint_definition
	| drop_table_constraint_definition
	| file_attribute_clause
	| alter_table_disable_index_clause
	| alter_table_enable_index_clause
	| alter_table_column_clause
	| alter_table_move_clause
	| partition_definition
	| alter_table_rename_clause
	| alter_table_set_constraint_clause
	| alter_table_disable_constraint_clause
	| alter_table_enable_constraint_clause
	| alter_table_add_column_clause
	| alter_table_drop_column_clause
	| alter_table_alter_column_clause
	| alter_table_alter_column_datatype
	| alter_table_alter_column_rename
	| alter_table_alter_column_default_value
	| alter_table_alter_column_set_sg_option
	| TOK_ALTER hbase_table_options
	| alter_stored_descriptor_option
	;

alter_synonym_statement :
	TOK_ALTER TOK_SYNONYM ddl_qualified_name TOK_TO ddl_qualified_name
	;

drop_table_constraint_definition :
	TOK_DROP TOK_CONSTRAINT constraint_name optional_drop_index_behavior
	;

add_table_constraint_definition :
	TOK_ADD table_constraint_definition
	;

alter_table_column_clause :
	TOK_COLUMN identifier heading
	;

alter_table_alter_column_datatype :
	TOK_ALTER TOK_COLUMN column_definition
	;

alter_table_alter_column_default_value :
	TOK_ALTER TOK_COLUMN column_name TOK_DEFAULT enableCharsetInferenceInColDefaultVal alter_col_default_clause_arg
	;

alter_table_alter_column_rename :
	TOK_ALTER TOK_COLUMN column_name TOK_RENAME TOK_TO column_name
	;

alter_table_alter_column_set_sg_option :
	TOK_ALTER TOK_COLUMN column_name TOK_SET sequence_generator_options
	| TOK_ALTER TOK_COLUMN column_name reset_option
	;

alter_col_default_clause_arg :
	literal
	;

alter_table_alter_column_clause :
	TOK_ALTER TOK_COLUMN column_name alter_column_type
	;

alter_column_type :
	TOK_LOGGABLE
	| TOK_NOT TOK_LOGGABLE
	;

alter_table_move_clause :
	TOK_MOVE source_location_list TOK_TO dest_location_list
	;

alter_table_set_constraint_clause :
	TOK_SET constraints_keyword constraint_name_list constraint_setting
	;

constraints_keyword :
	TOK_CONSTRAINT
	| TOK_CONSTRAINTS
	;

constraint_name_list :
	constraint_simple_name
	| constraint_name_list ',' /*1R*/ constraint_simple_name
	;

constraint_simple_name :
	qualified_name
	;

constraint_setting :
	TOK_OFF
	| TOK_ON /*4L*/
	;

source_location_list :
	location_list
	;

dest_location_list :
	location_list
	;

location_list :
	location_definition
	;

alter_table_disable_index_clause :
	TOK_DISABLE TOK_ALL TOK_INDEXES
	| TOK_DISABLE TOK_ALL TOK_UNIQUE TOK_INDEXES
	| TOK_DISABLE TOK_ALL TOK_INDEX
	| TOK_DISABLE TOK_INDEX index_name
	;

alter_table_enable_index_clause :
	TOK_ENABLE TOK_ALL TOK_INDEXES
	| TOK_ENABLE TOK_ALL TOK_UNIQUE TOK_INDEXES
	| TOK_ENABLE TOK_ALL TOK_INDEX
	| TOK_ENABLE TOK_INDEX index_name
	;

alter_table_rename_clause :
	TOK_RENAME TOK_TO identifier optional_cascade optional_skip_view_check
	;

alter_table_disable_constraint_clause :
	TOK_DISABLE TOK_ALL TOK_CONSTRAINTS
	| TOK_DISABLE TOK_CONSTRAINT constraint_name
	;

alter_table_enable_constraint_clause :
	TOK_ENABLE TOK_ALL TOK_CONSTRAINTS optional_validate_clause
	| TOK_ENABLE TOK_CONSTRAINT constraint_name optional_validate_clause
	;

optional_validate_clause :
	empty
	| TOK_VALIDATE
	| TOK_NO TOK_VALIDATE
	;

alter_table_add_column_clause :
	TOK_ADD optional_col_keyword column_definition
	| TOK_ADD TOK_IF TOK_NOT TOK_EXISTS optional_col_keyword column_definition
	;

optional_col_keyword :
	empty
	| TOK_COLUMN
	;

alter_table_drop_column_clause :
	TOK_DROP optional_col_keyword column_name
	| TOK_DROP optional_col_keyword TOK_IF TOK_EXISTS column_name
	;

alter_stored_descriptor_option :
	TOK_GENERATE TOK_STORED TOK_DESCRIPTOR
	| TOK_CHECK TOK_STORED TOK_DESCRIPTOR
	| TOK_DELETE TOK_STORED TOK_DESCRIPTOR
	| TOK_ENABLE TOK_STORED TOK_DESCRIPTOR
	| TOK_DISABLE TOK_STORED TOK_DESCRIPTOR
	;

drop_sql :
	TOK_DROP TOK_SQL extension_drop_behavior
	;

drop_module :
	TOK_DROP TOK_MODULE module_name
	;

drop_synonym_stmt :
	TOK_DROP TOK_SYNONYM ddl_qualified_name
	;

drop_exception_stmt :
	TOK_DROP TOK_EXCEPTION TOK_TABLE ddl_qualified_name TOK_ON /*4L*/ ddl_qualified_name optional_cleanup optional_drop_behavior optional_logfile
	;

drop_all_exception_stmt :
	TOK_DROP TOK_ALL TOK_EXCEPTION TOK_TABLES TOK_ON /*4L*/ ddl_qualified_name optional_cleanup optional_drop_behavior optional_logfile
	;

drop_table_statement :
	TOK_DROP special_table_name optional_drop_behavior
	| drop_table_start_tokens ddl_qualified_name optional_cleanup optional_drop_invalidate_dependent_behavior
	| TOK_DROP TOK_VOLATILE TOK_TABLE volatile_ddl_qualified_name optional_cleanup optional_drop_behavior
	| TOK_DROP TOK_LOCAL TOK_TEMPORARY TOK_TABLE volatile_ddl_qualified_name optional_cleanup optional_drop_behavior
	| TOK_DROP TOK_HBASE TOK_TABLE identifier
	| drop_table_start_tokens identifier TOK_FOR ddl_qualified_name optional_cleanup optional_drop_behavior
	;

drop_table_start_tokens :
	TOK_DROP TOK_TABLE
	| TOK_DROP ghost TOK_TABLE
	| TOK_DROP TOK_TABLE TOK_IF TOK_EXISTS
	| TOK_DROP TOK_EXTERNAL TOK_TABLE
	| TOK_DROP TOK_EXTERNAL TOK_TABLE TOK_IF TOK_EXISTS
	;

drop_mvrgroup_statement :
	TOK_DROP TOK_MVGROUP ddl_qualified_name
	;

drop_trigger_statement :
	TOK_DROP TOK_TRIGGER ddl_qualified_name optional_cleanup optional_validate optional_logfile
	;

drop_mv_statement :
	TOK_DROP optional_ghost mv_token ddl_qualified_name optional_cleanup optional_drop_behavior optional_validate optional_logfile
	;

drop_index_statement :
	TOK_DROP optional_ghost TOK_INDEX ddl_qualified_name optional_cleanup optional_drop_index_behavior optional_validate optional_logfile
	;

drop_routine_type_tokens :
	TOK_FUNCTION
	| TOK_SCALAR TOK_FUNCTION
	| table_mapping_function_tokens
	| universal_function_tokens
	| TOK_PROCEDURE
	;

drop_routine_statement :
	TOK_DROP drop_routine_type_tokens optional_if_exists_clause ddl_qualified_name optional_cleanup optional_drop_behavior optional_validate optional_logfile
	;

drop_view_statement :
	TOK_DROP TOK_VIEW optional_if_exists_clause ddl_qualified_name optional_cleanup optional_drop_invalidate_dependent_behavior optional_validate optional_logfile
	;

drop_index_statement :
	TOK_DROP TOK_VOLATILE TOK_INDEX volatile_ddl_qualified_name optional_drop_behavior
	;

revoke_schema_statement :
	TOK_REVOKE optional_grant_option_for privileges TOK_ON /*4L*/ TOK_SCHEMA schema_name TOK_FROM grantee_list optional_drop_behavior optional_granted_by
	;

revoke_component_privilege_stmt :
	TOK_REVOKE optional_grant_option_for TOK_COMPONENT privilege_or_privileges_token component_privilege_name_list TOK_ON /*4L*/ component_name TOK_FROM authorization_identifier_or_public optional_drop_behavior optional_granted_by
	;

revoke_statement :
	TOK_REVOKE optional_grant_option_for privileges TOK_ON /*4L*/ ddl_object_name optional_action TOK_FROM grantee_list optional_drop_behavior optional_granted_by
	;

optional_grant_option_for :
	empty
	| grant_option_for
	;

grant_option_for :
	TOK_GRANT TOK_OPTION TOK_FOR
	;

drop_catalog_statement :
	TOK_DROP TOK_CATALOG catalog_name extension_drop_behavior
	;

alter_user_statement :
	TOK_ALTER TOK_USER authorization_identifier TOK_SET TOK_EXTERNAL TOK_NAME external_user_identifier
	| TOK_ALTER TOK_USER authorization_identifier TOK_SET TOK_ONLINE
	| TOK_ALTER TOK_USER authorization_identifier TOK_SET TOK_OFFLINE
	;

register_component_statement :
	TOK_REGISTER TOK_COMPONENT component_name optional_system optional_component_detail_clause
	;

optional_component_detail_clause :
	empty
	| TOK_DETAIL component_str_lit
	;

component_str_lit :
	std_char_string_literal
	;

register_user_statement :
	TOK_REGISTER TOK_USER external_user_identifier optional_as_auth_clause optional_schema_clause
	;

optional_schema_clause :
	empty
	| schema_class TOK_SCHEMA
	;

unregister_component_statement :
	TOK_UNREGISTER TOK_COMPONENT component_name optional_drop_behavior
	;

unregister_user_statement :
	TOK_UNREGISTER TOK_USER external_user_identifier optional_drop_behavior
	;

as_auth_clause :
	TOK_AS authorization_identifier
	;

optional_as_auth_clause :
	empty
	| as_auth_clause
	;

nsk_node_name :
	BACKSLASH_SYSTEM_NAME
	;

register_hive_statement :
	TOK_REGISTER optional_internal_clause TOK_HIVE object_identifier optional_if_not_registered_clause ddl_qualified_name optional_cascade
	;

unregister_hive_statement :
	TOK_UNREGISTER optional_internal_clause TOK_HIVE object_identifier optional_if_registered_clause ddl_qualified_name optional_cascade optional_cleanup
	;

register_hbase_statement :
	TOK_REGISTER optional_internal_clause TOK_HBASE TOK_TABLE optional_if_not_registered_clause ddl_qualified_name
	;

unregister_hbase_statement :
	TOK_UNREGISTER optional_internal_clause TOK_HBASE TOK_TABLE optional_if_registered_clause ddl_qualified_name optional_cleanup
	;

optional_internal_clause :
	empty
	| TOK_INTERNAL
	;

create_role_statement :
	TOK_CREATE TOK_ROLE authorization_identifier optional_with_admin_clause
	;

optional_with_admin_clause :
	empty
	| with_admin_clause
	;

with_admin_clause :
	TOK_WITH TOK_ADMIN authorization_identifier
	| TOK_WITH TOK_ADMIN TOK_CURRENT_USER
	;

drop_role_statement :
	TOK_DROP TOK_ROLE authorization_identifier
	;

create_component_privilege_stmt :
	TOK_CREATE TOK_COMPONENT TOK_PRIVILEGE component_privilege_name TOK_AS priv_abbrev_str_lit TOK_ON /*4L*/ component_name optional_system optional_component_detail_clause
	;

drop_component_privilege_stmt :
	TOK_DROP TOK_COMPONENT TOK_PRIVILEGE component_privilege_name TOK_ON /*4L*/ component_name optional_drop_behavior
	;

priv_abbrev_str_lit :
	component_str_lit
	;

component_privilege_name :
	identifier_with_7_bit_ascii_chars_only
	;

component_name :
	regular_identifier_with_7_bit_ascii_chars_only
	;

regular_identifier_with_7_bit_ascii_chars_only :
	regular_identifier
	;

identifier_with_7_bit_ascii_chars_only :
	identifier
	;

create_synonym_stmt :
	TOK_CREATE TOK_SYNONYM ddl_qualified_name TOK_FOR ddl_qualified_name optional_by_auth_identifier
	;

showplan_options :
	optional_options
	;

cpu_identifier :
	SYSTEM_CPU_IDENTIFIER
	| NUMERIC_LITERAL_EXACT_NO_SCALE
	;

cpu_identifier_with_all :
	cpu_identifier
	| TOK_ALL
	;

pid_identifier :
	cpu_identifier ',' /*1R*/ NUMERIC_LITERAL_EXACT_NO_SCALE
	| DOLLAR_IDENTIFIER
	| TOK_CURRENT
	;

qid_internal_identifier :
	NUMERIC_LITERAL_EXACT_NO_SCALE ',' /*1R*/ NUMERIC_LITERAL_EXACT_NO_SCALE ',' /*1R*/ NUMERIC_LITERAL_EXACT_NO_SCALE ',' /*1R*/ NUMERIC_LITERAL_EXACT_NO_SCALE
	;

stats_active_clause :
	/*empty*/
	| TOK_ACTIVE NUMERIC_LITERAL_EXACT_NO_SCALE
	;

reset_clause :
	/*empty*/
	| TOK_RESET
	;

qid_internal_stats_merge_clause :
	/*empty*/
	| ',' /*1R*/ stats_merge_clause
	;

stats_merge_clause :
	/*empty*/
	| TOK_ACCUMULATED
	| TOK_PERTABLE
	| TOK_PROGRESS
	| TOK_DEFAULT
	;

comment_on_statement :
	TOK_COMMENT TOK_ON /*4L*/ comment_on_object_types ddl_qualified_name TOK_IS QUOTED_STRING
	| TOK_COMMENT TOK_ON /*4L*/ TOK_SCHEMA schema_name TOK_IS QUOTED_STRING
	| TOK_COMMENT TOK_ON /*4L*/ TOK_COLUMN qualified_name TOK_IS QUOTED_STRING
	;

comment_on_object_types :
	TOK_TABLE
	| TOK_INDEX
	| TOK_VIEW
	| TOK_LIBRARY
	| TOK_PROCEDURE
	| TOK_FUNCTION
	| TOK_SEQUENCE
	;

nonreserved_word :
	TOK_ABORT
	| TOK_ACCESS
	| TOK_ACCUMULATED
	| TOK_ACTIVATE
	| TOK_ACTIVE
	| TOK_ALIGNED
	| TOK_ALLOW
	| TOK_ALLOWED
	| TOK_APPEND
	| TOK_AREA
	| TOK_AUTOABORT
	| TOK_AUTOMATIC
	| TOK_REPEATABLE
	| TOK_SERIALIZABLE
	| TOK_ALL_DDL
	| TOK_ALL_DML
	| TOK_ALL_UTILITY
	| TOK_ALTER_LIBRARY
	| TOK_ALTER_MV
	| TOK_ALTER_MV_GROUP
	| TOK_ALTER_ROUTINE
	| TOK_ALTER_ROUTINE_ACTION
	| TOK_ALTER_SYNONYM
	| TOK_ALTER_TABLE
	| TOK_ALTER_TRIGGER
	| TOK_ALTER_VIEW
	| TOK_ALWAYS
	| TOK_AQR
	| TOK_ARKCMP
	| TOK_ASCENDING
	| TOK_ATOMIC
	| TOK_ATTRIBUTE
	| TOK_ATTRIBUTES
	| TOK_AUDITONREFRESH
	| TOK_AUDIT
	| TOK_AUTOBEGIN
	| TOK_AUTOCOMMIT
	| TOK_AUDITCOMPRESS
	| TOK_AUTHENTICATION
	| TOK_AVERAGE_STREAM_WAIT
	| TOK_BACKUP
	| TOK_BLOCKSIZE
	| TOK_BT
	| TOK_BRIEF
	| TOK_BUFFER
	| TOK_BUFFERED
	| TOK_BYTES
	| TOK_C
	| TOK_CANCEL
	| TOK_CARDINALITY
	| TOK_CATALOGS
	| TOK_CATALOG_NAME
	| TOK_CATCHUP
	| TOK_CENTURY
	| TOK_CHANGED
	| TOK_CHANGES
	| TOK_CHARS
	| TOK_CHARACTERS
	| TOK_CHARACTER_SET_CATALOG
	| TOK_CHARACTER_SET_NAME
	| TOK_CHARACTER_SET_SCHEMA
	| TOK_CLASS_ORIGIN
	| TOK_CLEAN
	| TOK_CLEANUP
	| TOK_CLEAR
	| TOK_CLEARONPURGE
	| TOK_CLUSTER
	| TOK_CLUSTERING
	| TOK_COLLATION_CATALOG
	| TOK_COLLATION_NAME
	| TOK_COLLATION_SCHEMA
	| TOK_COLUMNS
	| TOK_COLUMN_NAME
	| TOK_COLUMN_NUMBER
	| TOK_COMMANDS
	| TOK_COMMAND_FUNCTION
	| TOK_COMMENT
	| TOK_COMMITTED
	| TOK_COMP
	| TOK_COMPACT
	| TOK_COMPARE
	| TOK_COMPLETE
	| TOK_COMPONENT
	| TOK_COMPONENTS
	| TOK_COMPRESS
	| TOK_COMPRESSED
	| TOK_COMPRESSION
	| TOK_CONCURRENT
	| TOK_CONCURRENCY
	| TOK_CONDITION_NUMBER
	| TOK_CONFIG
	| TOK_CONNECTION_NAME
	| TOK_CONSTRAINT_CATALOG
	| TOK_CONSTRAINT_NAME
	| TOK_CONSTRAINT_SCHEMA
	| TOK_CONTAINS
	| TOK_CONTROL
	| TOK_COPY
	| TOK_COST
	| TOK_CPP
	| TOK_CPU
	| TOK_CREATE_LIBRARY
	| TOK_CREATE_MV
	| TOK_CREATE_MV_GROUP
	| TOK_CREATE_PROCEDURE
	| TOK_CREATE_ROUTINE
	| TOK_CREATE_ROUTINE_ACTION
	| TOK_CREATE_TABLE
	| TOK_CREATE_TRIGGER
	| TOK_CREATE_SYNONYM
	| TOK_CREATE_VIEW
	| TOK_CQD
	| TOK_CURSOR_NAME
	| TOK_CACHE
	| TOK_CYCLE
	| TOK_D
	| TOK_DATA
	| TOK_DATETIME_CODE
	| TOK_DBA
	| TOK_DCOMPRESS
	| TOK_DDL
	| TOK_DE
	| TOK_DECADE
	| TOK_DEFINER
	| TOK_DEFINITION
	| TOK_DEFAULTS
	| TOK_DELAY
	| TOK_DELIMITER
	| TOK_DEPENDENT
	| TOK_DESCENDING
	| TOK_DETAIL
	| TOK_DETAILS
	| TOK_DIRECTEDBY
	| TOK_DISABLE
	| TOK_DISK
	| TOK_DISPLAY
	| TOK_DIVISION
	| TOK_DO
	| TOK_DOUBLE_IEEE
	| TOK_DOW
	| TOK_DOY
	| TOK_DROP_LIBRARY
	| TOK_DROP_MV
	| TOK_DROP_MV_GROUP
	| TOK_DROP_PROCEDURE
	| TOK_DROP_ROUTINE
	| TOK_DROP_ROUTINE_ACTION
	| TOK_DROP_SYNONYM
	| TOK_DROP_TABLE
	| TOK_DROP_TRIGGER
	| TOK_DROP_VIEW
	| TOK_DROPPABLE
	| TOK_DSLACK
	| TOK_DUPLICATE
	| TOK_DYNAMIC_FUNCTION
	| TOK_EID
	| TOK_ENABLE
	| TOK_ENFORCED
	| TOK_ENFORCERS
	| TOK_ERROR
	| TOK_ENTERPRISE
	| TOK_ENTRY
	| TOK_ENTRIES
	| TOK_EPOCH
	| TOK_ET
	| TOK_EUROPEAN
	| TOK_EXCEPTIONS
	| TOK_EXCEPTION_TABLE
	| TOK_EXCHANGE
	| TOK_EXCHANGE_AND_SORT
	| TOK_EXCLUSIVE
	| TOK_EXECUTION
	| TOK_EXIT
	| TOK_EXPLAIN
	| TOK_EXTENT
	| TOK_EXTRACT_SOURCE
	| TOK_EXTRACT_TARGET
	| TOK_FAMILY
	| TOK_FAST
	| TOK_FEATURE_VERSION_INFO
	| TOK_FILE
	| TOK_FINAL
	| TOK_FIRST_FSCODE
	| TOK_FLOAT_IEEE
	| TOK_FOLLOWING
	| TOK_FOR_MAXRUNTIME
	| TOK_FORMAT
	| TOK_FORCE
	| TOK_G
	| TOK_GENERATE
	| TOK_GENERATED
	| TOK_GHOST
	| TOK_GIVE
	| TOK_GRANTEES
	| TOK_GRANTED
	| TOK_HARDWARE
	| TOK_HASH
	| TOK_HASH2
	| TOK_TRAFODION
	| TOK_HBASE
	| TOK_HBASE_OPTIONS
	| TOK_SERIALIZED
	| TOK_HEADER
	| TOK_HEADING
	| TOK_HEADINGS
	| TOK_HEXADECIMAL
	| TOK_HORIZONTAL
	| TOK_HIGH_VALUE
	| TOK_HOURS
	| TOK_SHOW
	| TOK_SHOWSTATS
	| TOK_SHOWTRANSACTION
	| TOK_ICOMPRESS
	| TOK_IGNORETRIGGERS
	| TOK_IGNORE_TRIGGER
	| TOK_IMMUTABLE
	| TOK_IMPLICIT
	| TOK_INCREMENT
	| TOK_INDEX_TABLE
	| TOK_INDICATOR_DATA
	| TOK_INDICATOR_POINTER
	| TOK_INDICATOR_TYPE
	| TOK_INGEST
	| TOK_INITIALIZATION
	| TOK_INITIALIZE
	| TOK_INITIALIZED
	| TOK_INPUTS
	| TOK_INSERT_ONLY
	| TOK_INSERTLOG
	| TOK_INTERNAL
	| TOK_INTERNALSP
	| TOK_INDEX
	| TOK_INDEXES
	| TOK_INS
	| TOK_INTERVALS
	| TOK_INVOKER
	| TOK_IO
	| TOK_ISLACK
	| TOK_ISOLATE
	| TOK_INVALID
	| TOK_INVALIDATE
	| TOK_JAVA
	| TOK_K
	| TOK_LABEL
	| TOK_LABEL_CREATE
	| TOK_LABEL_DROP
	| TOK_LABEL_ALTER
	| TOK_LABEL_PURGEDATA
	| TOK_LANGUAGE
	| TOK_LAST_FSCODE
	| TOK_LAST_SYSKEY
	| TOK_LASTSYSKEY
	| TOK_LEADING_PRECISION
	| TOK_LEVELS
	| TOK_EOF
	| TOK_LIBRARY
	| TOK_LIBRARIES
	| TOK_LINE_NUMBER
	| TOK_LOAD
	| TOK_LOAD_ID
	| TOK_LOCATION
	| TOK_LOCK
	| TOK_LOCK_ROW
	| TOK_LOCKING
	| TOK_LOCKONREFRESH
	| TOK_LOGGABLE
	| TOK_LOGON
	| TOK_LZO
	| TOK_GZIP
	| TOK_IUDLOG
	| TOK_IUD_LOG_TABLE
	| TOK_RANGE_LOG_TABLE
	| TOK_LOW_VALUE
	| TOK_M
	| TOK_MAP
	| TOK_MASTER
	| TOK_MATERIALIZED
	| TOK_MAXEXTENTS
	| TOK_MAXRUNTIME
	| TOK_MAXVALUE
	| TOK_MEMORY
	| TOK_MERGE
	| TOK_MESSAGE
	| TOK_MESSAGE_LEN
	| TOK_MESSAGE_OCTET_LEN
	| TOK_MESSAGE_TEXT
	| TOK_METADATA
	| TOK_MINIMAL
	| TOK_MINUTES
	| TOK_MINVALUE
	| TOK_MODE
	| TOK_MODULES
	| TOK_MORE
	| TOK_MOVE
	| TOK_MOVEMENT
	| TOK_MTS
	| TOK_MV
	| TOK_MULTI
	| TOK_MULTIDELTA
	| TOK_MSCK
	| TOK_MVATTRIBUTE
	| TOK_MVATTRIBUTES
	| TOK_MV_TABLE
	| TOK_MVSTATUS
	| TOK_MVS_UMD
	| TOK_REGEXP
	| TOK_REMOVE
	| TOK_OPENBLOWNAWAY
	| TOK_REDEFTIME
	| TOK_MVGROUP
	| TOK_MVGROUPS
	| TOK_MVLOG
	| TOK_MVUID
	| TOK_NAME
	| TOK_NAMED
	| TOK_NAMESPACE
	| TOK_NAMETYPE
	| TOK_NATABLE_CACHE_ENTRIES
	| TOK_NATIVE
	| TOK_NECESSARY
	| TOK_NEEDED
	| TOK_NEXT
	| TOK_NODELETE
	| TOK_NODES
	| TOK_NOMVLOG
	| TOK_NOLOG
	| TOK_NORMAL
	| TOK_NSK_CODE
	| TOK_NULLABLE
	| TOK_NULL_STRING
	| TOK_NUMBER
	| TOK_OBSOLETE
	| TOK_OBJECT
	| TOK_OBJECTS
	| TOK_OFFLINE
	| TOK_OJ
	| TOK_ONLINE
	| TOK_OPCODE
	| TOK_OPTIONS
	| TOK_ORDERED
	| TOK_OVER
	| TOK_OVERRIDE
	| TOK_PACKED
	| TOK_PAGE
	| TOK_PAGES
	| TOK_PARALLEL
	| TOK_PARALLELISM
	| TOK_PARENT
	| TOK_PARSERFLAGS
	| TOK_ENVVAR
	| TOK_ENVVARS
	| TOK_PARTITION
	| TOK_PARTITIONING
	| TOK_PARTITIONS
	| TOK_PASS
	| TOK_PATH
	| TOK_PERTABLE
	| TOK_PHASE
	| TOK_PID
	| TOK_PIPELINE
	| TOK_PLACING
	| TOK_POOL
	| TOK_POPULATE
	| TOK_POS
	| TOK_PRECEDING
	| TOK_PREFER_FOR_SCAN_KEY
	| TOK_PRESERVE
	| TOK_PRIORITY
	| TOK_PRIORITY_DELTA
	| TOK_PRIVATE
	| TOK_PRIVILEGE
	| TOK_PROCESS
	| TOK_PROGRESS
	| TOK_PROMPT
	| TOK_QID
	| TOK_QID_INTERNAL
	| TOK_QUERY
	| TOK_QUERY_CACHE
	| TOK_HYBRID_QUERY_CACHE
	| TOK_HYBRID_QUERY_CACHE_ENTRIES
	| TOK_QUERY_CACHE_ENTRIES
	| TOK_CATMAN_CACHE
	| TOK_NATABLE_CACHE
	| TOK_NAROUTINE_CACHE
	| TOK_NAROUTINE_ACTION_CACHE
	| TOK_RANGE
	| TOK_RANGE_N
	| TOK_RANGELOG
	| TOK_RATE
	| TOK_REAL_IEEE
	| TOK_REBUILD
	| TOK_RECOMPUTE
	| TOK_RECORD_SEPARATOR
	| TOK_RECOVER
	| TOK_RECOVERY
	| TOK_REFRESH
	| TOK_REGION
	| TOK_REGISTER
	| TOK_REGISTERED
	| TOK_REINITIALIZE
	| TOK_RELATED
	| TOK_RELATEDNESS
	| TOK_RELOAD
	| TOK_REMOTE
	| TOK_RENAME
	| TOK_REPAIR
	| TOK_REPOSITORY
	| TOK_REQUEST
	| TOK_REQUIRED
	| TOK_RESET
	| TOK_RETURNED_LENGTH
	| TOK_RETURNED_OCTET_LENGTH
	| TOK_RETURNED_SQLSTATE
	| TOK_REWRITE
	| TOK_ROLE
	| TOK_ROLES
	| TOK_ROW_COUNT
	| TOK_ROWS_INSERTED
	| TOK_ROWS_DELETED
	| TOK_ROWS_UPDATED
	| TOK_ROWS_COVERED
	| TOK_NUM_OF_RANGES
	| TOK_ROWWISE
	| TOK_ROWSET_IND_LAYOUT_SIZE
	| TOK_ROWSET_SIZE
	| TOK_ROWSET_VAR_LAYOUT_SIZE
	| TOK_RUN
	| TOK_SAFE
	| TOK_SALT
	| TOK_SAS_FORMAT
	| TOK_SAS_LOCALE
	| TOK_SAS_MODEL_INPUT_TABLE
	| TOK_SCALAR
	| TOK_SCALE
	| TOK_SCAN
	| TOK_SCHEMAS
	| TOK_SCHEMA_NAME
	| TOK_SECONDS
	| TOK_SECURITY
	| TOK_SELECTIVITY
	| TOK_SEPARATE
	| TOK_SERVER_NAME
	| TOK_SESSIONS
	| TOK_SG_TABLE
	| TOK_SHAPE
	| TOK_SHARE
	| TOK_SHARED
	| TOK_SIGNED
	| TOK_SINGLEDELTA
	| TOK_SLACK
	| TOK_SOFTWARE
	| TOK_SOURCE
	| TOK_SNAPSHOT
	| TOK_SUFFIX
	| TOK_TARGET
	| TOK_SOURCE_FILE
	| TOK_SP_RESULT_SET
	| TOK_SQL_WARNING
	| TOK_SQLROW
	| TOK_START
	| TOK_STATE
	| TOK_STATEMENT
	| TOK_STATIC
	| TOK_STATISTICS
	| TOK_STATS
	| TOK_STATUS
	| TOK_STORAGE
	| TOK_STORE
	| TOK_STORED
	| TOK_STRING_SEARCH
	| TOK_STYLE
	| TOK_SUBCLASS_ORIGIN
	| TOK_SUBSYSTEM_ID
	| TOK_HBMAP_TABLE
	| TOK_SUSPEND
	| TOK_SYNONYMS
	| TOK_T
	| TOK_TABLE_MAPPING
	| TOK_TABLE_NAME
	| TOK_TABLES
	| TOK_TABLESPACE
	| TOK_TAG
	| TOK_TEMP_TABLE
	| TOK_TEXT
	| TOK_THROUGH
	| TOK_TIMEOUT
	| TOK_TITLE
	| TOK_TRANSFORM
	| TOK_TRIGGERS
	| TOK_TRIGGER_CATALOG
	| TOK_TRIGGER_NAME
	| TOK_TRIGGER_SCHEMA
	| TOK_TS
	| TOK_TYPE
	| TOK_TYPES
	| TOK_TYPE_ANSI
	| TOK_TYPE_FS
	| TOK_UDF
	| TOK_UNBOUNDED
	| TOK_UNCOMMITTED
	| TOK_UNIVERSAL
	| TOK_UNLOCK
	| TOK_UNLOAD
	| TOK_UNNAMED
	| TOK_UNREGISTER
	| TOK_UNSIGNED
	| TOK_UPD
	| TOK_UPGRADE
	| TOK_UPDATE_STATS
	| TOK_UPDATE_LOB
	| TOK_UPPERCASE
	| TOK_USA
	| TOK_USE
	| TOK_USERS
	| TOK_VALUE
	| TOK_VARIABLE_DATA
	| TOK_VARIABLE_POINTER
	| TOK_VOLATILE
	| TOK_VERSION
	| TOK_VERSIONS
	| TOK_VPROC
	| TOK_VERSION_INFO
	| TOK_VIEWS
	| TOK_VSBB
	| TOK_WAITED
	| TOK_WAITEDIO
	| TOK_WOM
	| TOK_INVOKE
	| TOK_SHOWCONTROL
	| TOK_SHOWDDL
	| TOK_SHOWPLAN
	| TOK_SHOWSHAPE
	| TOK_SHOWSET
	| TOK_SAMPLE
	| TOK_PERIODIC
	| TOK_PERCENT
	| TOK_BALANCE
	| TOK_EVERY
	| TOK_EXISTING
	| TOK_SORT
	| TOK_CLUSTERS
	| TOK_BLOCKS
	| TOK_INCLUSIVE
	| TOK_SEQUENCE
	| TOK_SEQUENCES
	| TOK_SINCE
	| TOK_MANAGEMENT
	| TOK_MANUAL
	| TOK_MIXED
	| TOK_MVS
	| TOK_PURGEDATA
	| TOK_INCREMENTAL
	| TOK_PROCEDURES
	| TOK_SUMMARY
	| TOK_SYSTEM
	| TOK_UNAVAILABLE
	| TOK_UID
	| TOK_STREAM
	| TOK_SKIP
	| TOK_CONFLICT
	| TOK_HOLD
	| TOK_VALIDATE
	| TOK_RMS
	;

nonreserved_word_for_explain :
	TOK_C
	| TOK_D
	| TOK_G
	| TOK_K
	| TOK_M
	| TOK_T
	;

nonreserved_func_word :
	TOK_ABS
	| TOK_ACOS
	| TOK_ASCII
	| TOK_ASIN
	| TOK_ATAN
	| TOK_ATAN2
	| TOK_AUTHNAME
	| TOK_AUTHTYPE
	| TOK_BITAND
	| TOK_BITOR
	| TOK_BITXOR
	| TOK_BITNOT
	| TOK_BITEXTRACT
	| TOK_CONVERTTOBITS
	| TOK_CEIL
	| TOK_CEILING
	| TOK_CHR
	| TOK_CODE_VALUE
	| TOK_COLUMN_CREATE
	| TOK_COLUMN_LOOKUP
	| TOK_COLUMN_DISPLAY
	| TOK_CONCAT
	| TOK_CONVERTFROMHEX
	| TOK_CONVERTTIMESTAMP
	| TOK_CONVERTTOHEX
	| TOK_CONVERTTOHX_INTN
	| TOK_COS
	| TOK_COSH
	| TOK_CRC32
	| TOK_CURDATE
	| TOK_CURTIME
	| TOK_D_RANK
	| TOK_DATABASE
	| TOK_DATEFORMAT
	| TOK_DAYNAME
	| TOK_DAYOFMONTH
	| TOK_DAYOFWEEK
	| TOK_DAYOFYEAR
	| TOK_DEBUG
	| TOK_DEGREES
	| TOK_DIFF1
	| TOK_DIFF2
	| TOK_ENCODE_KEY
	| TOK_ENCODE_BASE64
	| TOK_DECODE_BASE64
	| TOK_EXP
	| TOK_EXTEND
	| TOK_FIRSTDAYOFYEAR
	| TOK_FLOOR
	| TOK_FN
	| TOK_FROM_HEX
	| TOK_GREATEST
	| TOK_GROUPING_ID
	| TOK_HASHPARTFUNC
	| TOK_HASH2PARTFUNC
	| TOK_HBASE_TIMESTAMP
	| TOK_HBASE_VERSION
	| TOK_HEX
	| TOK_HIVE
	| TOK_HIVEMD
	| TOK_INET_ATON
	| TOK_INET_NTOA
	| TOK_INITIAL
	| TOK_INSTR
	| TOK_ISIPV4
	| TOK_ISIPV6
	| TOK_KEY_RANGE_COMPARE
	| TOK_JSONOBJECTFIELDTEXT
	| TOK_JULIANTIMESTAMP
	| TOK_LASTNOTNULL
	| TOK_LAST_DAY
	| TOK_LCASE
	| TOK_LEAST
	| TOK_LENGTH
	| TOK_LOCATE
	| TOK_LOG
	| TOK_LOG10
	| TOK_LOG2
	| TOK_LPAD
	| TOK_LTRIM
	| TOK_MAVG
	| TOK_MCOUNT
	| TOK_MD5
	| TOK_MMAX
	| TOK_MMIN
	| TOK_MOD
	| TOK_MONTHNAME
	| TOK_MONTHS_BETWEEN
	| TOK_MRANK
	| TOK_MSTDDEV
	| TOK_MSUM
	| TOK_MVARIANCE
	| TOK_NEXT_DAY
	| TOK_NOW
	| TOK_NVL
	| TOK_NULLIFZERO
	| TOK_OFFSET
	| TOK_OS_USERID
	| TOK_PI
	| TOK_PIVOT
	| TOK_PIVOT_GROUP
	| TOK_POWER
	| TOK_QUARTER
	| TOK_QUERYID_EXTRACT
	| TOK_RADIANS
	| TOK_RAND
	| TOK_RANDOM
	| TOK_RAVG
	| TOK_RCOUNT
	| TOK_REPEAT
	| TOK_RESTORE
	| TOK_RESUME
	| TOK_RETRIES
	| TOK_RETURNS
	| TOK_RMAX
	| TOK_RMIN
	| TOK_ROUND
	| TOK_ROWNUM
	| TOK_ROW_NUMBER
	| TOK_RPAD
	| TOK_RRANK
	| TOK_RRPARTFUNC
	| TOK_RSTDDEV
	| TOK_RSUM
	| TOK_RTRIM
	| TOK_RVARIANCE
	| TOK_SEQNUM
	| TOK_SHA
	| TOK_SHA1
	| TOK_SHA2
	| TOK_SIGN
	| TOK_SIN
	| TOK_SINH
	| TOK_SOUNDEX
	| TOK_SORT_KEY
	| TOK_SPACE
	| TOK_SQRT
	| TOK_STDDEV
	| TOK_STOP
	| TOK_TAN
	| TOK_TANH
	| TOK_THIS
	| TOK_TOKENSTR
	| TOK_TO_BINARY
	| TOK_TO_CHAR
	| TOK_TO_DATE
	| TOK_TO_HEX
	| TOK_TO_NUMBER
	| TOK_TO_TIME
	| TOK_TO_TIMESTAMP
	| TOK_TRUNC
	| TOK_TRUNCATE
	| TOK_TYPECAST
	| TOK_UCASE
	| TOK_UNIQUE_ID
	| TOK_UUID
	| TOK_SYS_GUID
	| TOK_USERNAMEINTTOEXT
	| TOK_VARIANCE
	| TOK_WEEK
	| TOK_XMLAGG
	| TOK_XMLELEMENT
	| TOK_ZEROIFNULL
	| TOK_PERFORM
	| TOK_PARAMETER_MODE
	| TOK_PARAMETER_ORDINAL_POSITION
	| TOK_PARAMETER_INDEX
	| TOK_DATA_OFFSET
	| TOK_NULL_IND_OFFSET
	| TOK_ALIGNED_LENGTH
	| TOK_ADD_MONTHS
	| TOK_DATEADD
	| TOK_DATE_ADD
	| TOK_DATE_SUB
	| TOK_DECODE
	| TOK_DATE_PART
	| TOK_DATE_TRUNC
	| TOK_DATEDIFF
	| TOK_TIMESTAMPADD
	| TOK_TIMESTAMPDIFF
	| TOK_ISNULL
	| TOK_CHECKSUM
	| TOK_FALLBACK
	| TOK_PROTECTION
	| TOK_FREESPACE
	| TOK_JOURNAL
	| TOK_MULTISET
	| TOK_CASESPECIFIC
	| TOK_FIXED
	| TOK_BUFFERTOLOB
	| TOK_EXTERNALTOLOB
	| TOK_FILETOLOB
	| TOK_FILETOEXTERNAL
	| TOK_LOADTOLOB
	| TOK_STRINGTOLOB
	| TOK_STRINGTOEXTERNAL
	| TOK_LOB
	| TOK_LOBLENGTH
	| TOK_LOBTOBUFFER
	| TOK_LOBTOFILE
	| TOK_LOBTOSTRING
	| TOK_EXTERNALTOSTRING
	| TOK_EMPTY_CLOB
	| TOK_EMPTY_BLOB
	| TOK_UNHEX
	;

nonreserved_datatype :
	TOK_ANSIVARCHAR
	| TOK_BIGINT
	| TOK_BYTE
	| TOK_BYTEINT
	| TOK_LARGEINT
	| TOK_LONG
	| TOK_LONGWVARCHAR
	| TOK_LSDECIMAL
	| TOK_ROWSET
	| TOK_TINYINT
	| TOK_VARBINARY
	| TOK_VARWCHAR
	| TOK_WCHAR
	;

MP_nonreserved_word :
	TOK_DOUBLE
	| TOK_ELSE
	| TOK_END
	| TOK_FLOAT
	| TOK_NATIONAL
	| TOK_NCHAR
	| TOK_PRECISION
	| TOK_REAL
	| TOK_VARCHAR
	| TOK_VARYING
	| TOK_NEW
	| TOK_OLD
	| TOK_AFTER
	| TOK_BEFORE
	| TOK_EACH
	| TOK_REFERENCING
	| TOK_SIGNAL
	| TOK_SQLSTATE
	| TOK_TRIGGER
	;

MP_nonreserved_func_word :
	TOK_CAST
	| TOK_CHAR_LENGTH
	| TOK_LOWER
	| TOK_MIN
	| TOK_OCTET_LENGTH
	| TOK_OVERLAY
	| TOK_STUFF
	| TOK_POSITION
	| TOK_REVERSE
	| TOK_TRIM
	| TOK_SUBSTRING
	| TOK_UPPER
	| TOK_UPSHIFT
	;

%%

ident	[A-Za-z_][A-Za-z0-9_]*

spaces	[ \t\r\n]+
line_comment	--[^\r\n]*
block_comment	\/\*(?s:.)*?\*\/

%%

{spaces}	skip()
{line_comment}	skip()
{block_comment}	skip()

"^"	'^'
"~"	'~'
"<"	'<'
"="	'='
">"	'>'
"-"	'-'
","	','
";"	';'
"!"	'!'
"/"	'/'
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
//"$"	'$'
"*"	'*'
"&"	'&'
"+"	'+'

ABORT	TOK_ABORT
ABS	TOK_ABS
ACCESS	TOK_ACCESS
ACCUMULATED	TOK_ACCUMULATED
ACOS	TOK_ACOS
ACTION	TOK_ACTION
ACTIVATE	TOK_ACTIVATE
ACTIVE	TOK_ACTIVE
ADD	TOK_ADD
ADD_MONTHS	TOK_ADD_MONTHS
ADMIN	TOK_ADMIN
AES_DECRYPT	TOK_AES_DECRYPT
AES_ENCRYPT	TOK_AES_ENCRYPT
AFTER	TOK_AFTER
ALIAS	TOK_ALIAS
ALIGNED	TOK_ALIGNED
ALIGNED_LENGTH	TOK_ALIGNED_LENGTH
ALL	TOK_ALL
ALL_DDL	TOK_ALL_DDL
ALL_DML	TOK_ALL_DML
ALLOCATE	TOK_ALLOCATE
ALLOW	TOK_ALLOW
ALLOWED	TOK_ALLOWED
ALL_UTILITY	TOK_ALL_UTILITY
ALTER	TOK_ALTER
ALTER_LIBRARY	TOK_ALTER_LIBRARY
ALTER_MV	TOK_ALTER_MV
ALTER_MV_GROUP	TOK_ALTER_MV_GROUP
ALTER_ROUTINE	TOK_ALTER_ROUTINE
ALTER_ROUTINE_ACTION	TOK_ALTER_ROUTINE_ACTION
ALTER_SYNONYM	TOK_ALTER_SYNONYM
ALTER_TABLE	TOK_ALTER_TABLE
ALTER_TRIGGER	TOK_ALTER_TRIGGER
ALTER_VIEW	TOK_ALTER_VIEW
ALWAYS	TOK_ALWAYS
AND	TOK_AND
ANSIVARCHAR	TOK_ANSIVARCHAR
ANY	TOK_ANY
APPEND	TOK_APPEND
AQR	TOK_AQR
ARE	TOK_ARE
AREA	TOK_AREA
ARKCMP	TOK_ARKCMP
AS	TOK_AS
ASC	TOK_ASC
ASCENDING	TOK_ASCENDING
ASCII	TOK_ASCII
ASIN	TOK_ASIN
ATAN	TOK_ATAN
ATAN2	TOK_ATAN2
ATOMIC	TOK_ATOMIC
ATTRIBUTE	TOK_ATTRIBUTE
ATTRIBUTES	TOK_ATTRIBUTES
AUDIT	TOK_AUDIT
AUDITCOMPRESS	TOK_AUDITCOMPRESS
AUDITONREFRESH	TOK_AUDITONREFRESH
AUTHENTICATION	TOK_AUTHENTICATION
AUTHNAME	TOK_AUTHNAME
AUTHORIZATION	TOK_AUTHORIZATION
AUTHTYPE	TOK_AUTHTYPE
AUTOABORT	TOK_AUTOABORT
AUTOBEGIN	TOK_AUTOBEGIN
AUTOCOMMIT	TOK_AUTOCOMMIT
AUTOMATIC	TOK_AUTOMATIC
AVERAGE_STREAM_WAIT	TOK_AVERAGE_STREAM_WAIT
AVG	TOK_AVG
BACKUP	TOK_BACKUP
BALANCE	TOK_BALANCE
BEFORE	TOK_BEFORE
BEGIN	TOK_BEGIN
BEGIN_HINT	TOK_BEGIN_HINT
BETWEEN	TOK_BETWEEN
BIGINT	TOK_BIGINT
BINARY	TOK_BINARY
BIT	TOK_BIT
BITAND	TOK_BITAND
BITEXTRACT	TOK_BITEXTRACT
BITNOT	TOK_BITNOT
BITOR	TOK_BITOR
BITOR_OPERATOR	TOK_BITOR_OPERATOR
BITXOR	TOK_BITXOR
BLOB	TOK_BLOB
BLOCKS	TOK_BLOCKS
BLOCKSIZE	TOK_BLOCKSIZE
BOOLEAN	TOK_BOOLEAN
BOTH	TOK_BOTH
BRIEF	TOK_BRIEF
BT	TOK_BT
BUFFER	TOK_BUFFER
BUFFERED	TOK_BUFFERED
BUFFERTOLOB	TOK_BUFFERTOLOB
BY	TOK_BY
BYTE	TOK_BYTE
BYTEINT	TOK_BYTEINT
BYTES	TOK_BYTES
C	TOK_C
CACHE	TOK_CACHE
CALL	TOK_CALL
CANCEL	TOK_CANCEL
CAPTURE	TOK_CAPTURE
CARDINALITY	TOK_CARDINALITY
CASCADE	TOK_CASCADE
CASCADED	TOK_CASCADED
CASE	TOK_CASE
CASESPECIFIC	TOK_CASESPECIFIC
CAST	TOK_CAST
CATALOG	TOK_CATALOG
CATALOG_NAME	TOK_CATALOG_NAME
CATALOGS	TOK_CATALOGS
CATCHUP	TOK_CATCHUP
CATMAN_CACHE	TOK_CATMAN_CACHE
CEIL	TOK_CEIL
CEILING	TOK_CEILING
CENTURY	TOK_CENTURY
CHANGED	TOK_CHANGED
CHANGES	TOK_CHANGES
CHAR	TOK_CHAR
CHARACTER	TOK_CHARACTER
CHARACTERS	TOK_CHARACTERS
CHARACTER_SET_CATALOG	TOK_CHARACTER_SET_CATALOG
CHARACTER_SET_NAME	TOK_CHARACTER_SET_NAME
CHARACTER_SET_SCHEMA	TOK_CHARACTER_SET_SCHEMA
CHAR_LENGTH	TOK_CHAR_LENGTH
CHARS	TOK_CHARS
CHECK	TOK_CHECK
CHECKSUM	TOK_CHECKSUM
CHR	TOK_CHR
CLASS_ORIGIN	TOK_CLASS_ORIGIN
CLEAN	TOK_CLEAN
CLEANUP	TOK_CLEANUP
CLEANUP_OBSOLETE	TOK_CLEANUP_OBSOLETE
CLEAR	TOK_CLEAR
CLEARONPURGE	TOK_CLEARONPURGE
CLOB	TOK_CLOB
CLOSE	TOK_CLOSE
CLUSTER	TOK_CLUSTER
CLUSTERING	TOK_CLUSTERING
CLUSTERS	TOK_CLUSTERS
COALESCE	TOK_COALESCE
CODE_VALUE	TOK_CODE_VALUE
COLLATE	TOK_COLLATE
COLLATION	TOK_COLLATION
COLLATION_CATALOG	TOK_COLLATION_CATALOG
COLLATION_NAME	TOK_COLLATION_NAME
COLLATION_SCHEMA	TOK_COLLATION_SCHEMA
COLUMN	TOK_COLUMN
COLUMN_CREATE	TOK_COLUMN_CREATE
COLUMN_DISPLAY	TOK_COLUMN_DISPLAY
COLUMN_LOOKUP	TOK_COLUMN_LOOKUP
COLUMN_NAME	TOK_COLUMN_NAME
COLUMN_NUMBER	TOK_COLUMN_NUMBER
COLUMNS	TOK_COLUMNS
COMMAND_FUNCTION	TOK_COMMAND_FUNCTION
COMMANDS	TOK_COMMANDS
COMMENT	TOK_COMMENT
COMMIT	TOK_COMMIT
COMMITTED	TOK_COMMITTED
COMP	TOK_COMP
COMPACT	TOK_COMPACT
COMPARE	TOK_COMPARE
COMPILE	TOK_COMPILE
COMPLETE	TOK_COMPLETE
COMPONENT	TOK_COMPONENT
COMPONENTS	TOK_COMPONENTS
COMPRESS	TOK_COMPRESS
COMPRESSED	TOK_COMPRESSED
COMPRESSION	TOK_COMPRESSION
CONCAT	TOK_CONCAT
CONCATENATION	TOK_CONCATENATION
CONCURRENCY	TOK_CONCURRENCY
CONCURRENT	TOK_CONCURRENT
CONDITION_NUMBER	TOK_CONDITION_NUMBER
CONFIG	TOK_CONFIG
CONFLICT	TOK_CONFLICT
CONNECTION_NAME	TOK_CONNECTION_NAME
CONSTRAINT	TOK_CONSTRAINT
CONSTRAINT_CATALOG	TOK_CONSTRAINT_CATALOG
CONSTRAINT_NAME	TOK_CONSTRAINT_NAME
CONSTRAINTS	TOK_CONSTRAINTS
CONSTRAINT_SCHEMA	TOK_CONSTRAINT_SCHEMA
CONTAINS	TOK_CONTAINS
CONTINUE	TOK_CONTINUE
CONTROL	TOK_CONTROL
CONVERT	TOK_CONVERT
CONVERTFROMHEX	TOK_CONVERTFROMHEX
CONVERTTIMESTAMP	TOK_CONVERTTIMESTAMP
CONVERTTOBITS	TOK_CONVERTTOBITS
CONVERTTOHEX	TOK_CONVERTTOHEX
CONVERTTOHX_INTN	TOK_CONVERTTOHX_INTN
COPY	TOK_COPY
COS	TOK_COS
COSH	TOK_COSH
COST	TOK_COST
COUNT	TOK_COUNT
CPP	TOK_CPP
CPU	TOK_CPU
CQD	TOK_CQD
CRC32	TOK_CRC32
CREATE	TOK_CREATE
CREATE_LIBRARY	TOK_CREATE_LIBRARY
CREATE_MV	TOK_CREATE_MV
CREATE_MV_GROUP	TOK_CREATE_MV_GROUP
CREATE_PROCEDURE	TOK_CREATE_PROCEDURE
CREATE_ROUTINE	TOK_CREATE_ROUTINE
CREATE_ROUTINE_ACTION	TOK_CREATE_ROUTINE_ACTION
CREATE_SYNONYM	TOK_CREATE_SYNONYM
CREATE_TABLE	TOK_CREATE_TABLE
CREATE_TRIGGER	TOK_CREATE_TRIGGER
CREATE_VIEW	TOK_CREATE_VIEW
CROSS	TOK_CROSS
CURDATE	TOK_CURDATE
CURRENT	TOK_CURRENT
CURRENT_DATE	TOK_CURRENT_DATE
CURRENT_RUNNING	TOK_CURRENT_RUNNING
CURRENT_TIME	TOK_CURRENT_TIME
CURRENT_TIMESTAMP	TOK_CURRENT_TIMESTAMP
CURRENT_TIMESTAMP_RUNNING	TOK_CURRENT_TIMESTAMP_RUNNING
CURRENT_TIMESTAMP_UTC	TOK_CURRENT_TIMESTAMP_UTC
CURRENT_TIME_UTC	TOK_CURRENT_TIME_UTC
CURRENT_USER	TOK_CURRENT_USER
CURRNT_USR_INTN	TOK_CURRNT_USR_INTN
CURSOR	TOK_CURSOR
CURSOR_NAME	TOK_CURSOR_NAME
CURSOR_WITH_HOLD	TOK_CURSOR_WITH_HOLD
CURSOR_WITHOUT_HOLD	TOK_CURSOR_WITHOUT_HOLD
CURTIME	TOK_CURTIME
CYCLE	TOK_CYCLE
D	TOK_D
DATA	TOK_DATA
DATABASE	TOK_DATABASE
DATA_OFFSET	TOK_DATA_OFFSET
DATE	TOK_DATE
DATEADD	TOK_DATEADD
DATE_ADD	TOK_DATE_ADD
DATE_BEFORE_QUOTE	TOK_DATE_BEFORE_QUOTE
DATEDIFF	TOK_DATEDIFF
DATEFORMAT	TOK_DATEFORMAT
DATE_PART	TOK_DATE_PART
DATE_SUB	TOK_DATE_SUB
DATETIME	TOK_DATETIME
DATETIME_CODE	TOK_DATETIME_CODE
DATE_TRUNC	TOK_DATE_TRUNC
DAY	TOK_DAY
DAYNAME	TOK_DAYNAME
DAYOFMONTH	TOK_DAYOFMONTH
DAYOFWEEK	TOK_DAYOFWEEK
DAYOFYEAR	TOK_DAYOFYEAR
DBA	TOK_DBA
DCOMPRESS	TOK_DCOMPRESS
DDL	TOK_DDL
DE	TOK_DE
DEALLOCATE	TOK_DEALLOCATE
DEBUG	TOK_DEBUG
DECADE	TOK_DECADE
DECIMAL	TOK_DECIMAL
DECLARE	TOK_DECLARE
DECODE	TOK_DECODE
DECODE_BASE64	TOK_DECODE_BASE64
DEFAULT	TOK_DEFAULT
DEFAULTS	TOK_DEFAULTS
DEFINER	TOK_DEFINER
DEFINITION	TOK_DEFINITION
DEGREES	TOK_DEGREES
DELAY	TOK_DELAY
DELETE	TOK_DELETE
DELIMITER	TOK_DELIMITER
DEPENDENT	TOK_DEPENDENT
DESC	TOK_DESC
DESCENDING	TOK_DESCENDING
DESCRIBE	TOK_DESCRIBE
DESCRIPTOR	TOK_DESCRIPTOR
DETAIL	TOK_DETAIL
DETAILS	TOK_DETAILS
DETERMINISTIC	TOK_DETERMINISTIC
DIAGNOSTICS	TOK_DIAGNOSTICS
DIFF1	TOK_DIFF1
DIFF2	TOK_DIFF2
DIRECTEDBY	TOK_DIRECTEDBY
DISABLE	TOK_DISABLE
DISK	TOK_DISK
DISPLAY	TOK_DISPLAY
DISTINCT	TOK_DISTINCT
DIVISION	TOK_DIVISION
DO	TOK_DO
DOT_STAR	TOK_DOT_STAR
DOUBLE	TOK_DOUBLE
DOUBLE_IEEE	TOK_DOUBLE_IEEE
DOW	TOK_DOW
DOY	TOK_DOY
D_RANK	TOK_D_RANK
DROP	TOK_DROP
DROP_LIBRARY	TOK_DROP_LIBRARY
DROP_MV	TOK_DROP_MV
DROP_MV_GROUP	TOK_DROP_MV_GROUP
DROPPABLE	TOK_DROPPABLE
DROP_PROCEDURE	TOK_DROP_PROCEDURE
DROP_ROUTINE	TOK_DROP_ROUTINE
DROP_ROUTINE_ACTION	TOK_DROP_ROUTINE_ACTION
DROP_SYNONYM	TOK_DROP_SYNONYM
DROP_TABLE	TOK_DROP_TABLE
DROP_TRIGGER	TOK_DROP_TRIGGER
DROP_VIEW	TOK_DROP_VIEW
DSLACK	TOK_DSLACK
DUAL	TOK_DUAL
DUPLICATE	TOK_DUPLICATE
DYNAMIC	TOK_DYNAMIC
DYNAMIC_FUNCTION	TOK_DYNAMIC_FUNCTION
EACH	TOK_EACH
EID	TOK_EID
ELSE	TOK_ELSE
ELSEIF	TOK_ELSEIF
EMPTY_BLOB	TOK_EMPTY_BLOB
EMPTY_CLOB	TOK_EMPTY_CLOB
ENABLE	TOK_ENABLE
ENCODE_BASE64	TOK_ENCODE_BASE64
ENCODE_KEY	TOK_ENCODE_KEY
END	TOK_END
END_HINT	TOK_END_HINT
ENFORCED	TOK_ENFORCED
ENFORCERS	TOK_ENFORCERS
ENTERPRISE	TOK_ENTERPRISE
ENTRIES	TOK_ENTRIES
ENTRY	TOK_ENTRY
ENVVAR	TOK_ENVVAR
ENVVARS	TOK_ENVVARS
EOF	TOK_EOF
EPOCH	TOK_EPOCH
ERROR	TOK_ERROR
ESCAPE	TOK_ESCAPE
ET	TOK_ET
EUROPEAN	TOK_EUROPEAN
EVERY	TOK_EVERY
EXCEPT	TOK_EXCEPT
EXCEPTION	TOK_EXCEPTION
EXCEPTIONS	TOK_EXCEPTIONS
EXCEPTION_TABLE	TOK_EXCEPTION_TABLE
EXCHANGE	TOK_EXCHANGE
EXCHANGE_AND_SORT	TOK_EXCHANGE_AND_SORT
EXCLUSIVE	TOK_EXCLUSIVE
EXECUTE	TOK_EXECUTE
EXECUTION	TOK_EXECUTION
EXISTING	TOK_EXISTING
EXISTS	TOK_EXISTS
EXIT	TOK_EXIT
EXP	TOK_EXP
EXPLAIN	TOK_EXPLAIN
EXPONENTIATE	TOK_EXPONENTIATE
EXTEND	TOK_EXTEND
EXTENT	TOK_EXTENT
EXTERNAL	TOK_EXTERNAL
EXTERNALTOLOB	TOK_EXTERNALTOLOB
EXTERNALTOSTRING	TOK_EXTERNALTOSTRING
EXTRACT	TOK_EXTRACT
EXTRACT_SOURCE	TOK_EXTRACT_SOURCE
EXTRACT_TARGET	TOK_EXTRACT_TARGET
FALLBACK	TOK_FALLBACK
FALSE	TOK_FALSE
FAMILY	TOK_FAMILY
FAST	TOK_FAST
FEATURE_VERSION_INFO	TOK_FEATURE_VERSION_INFO
FETCH	TOK_FETCH
FILE	TOK_FILE
FILETOEXTERNAL	TOK_FILETOEXTERNAL
FILETOLOB	TOK_FILETOLOB
FINAL	TOK_FINAL
FIRST	TOK_FIRST
FIRSTDAYOFYEAR	TOK_FIRSTDAYOFYEAR
FIRST_FSCODE	TOK_FIRST_FSCODE
FIXED	TOK_FIXED
FLOAT	TOK_FLOAT
FLOAT_IEEE	TOK_FLOAT_IEEE
FLOOR	TOK_FLOOR
FN	TOK_FN
FOLLOWING	TOK_FOLLOWING
FOR	TOK_FOR
FORCE	TOK_FORCE
FOREIGN	TOK_FOREIGN
FOR_LIBRARY	TOK_FOR_LIBRARY
FORMAT	TOK_FORMAT
FOR_MAXRUNTIME	TOK_FOR_MAXRUNTIME
FOR_READ	TOK_FOR_READ
FOR_READ_ONLY	TOK_FOR_READ_ONLY
FOR_REPEATABLE	TOK_FOR_REPEATABLE
FOR_ROLE	TOK_FOR_ROLE
FOR_SERIALIZABLE	TOK_FOR_SERIALIZABLE
FOR_SKIP	TOK_FOR_SKIP
FOR_USER	TOK_FOR_USER
FOUND	TOK_FOUND
FRACTION	TOK_FRACTION
FREESPACE	TOK_FREESPACE
FROM	TOK_FROM
FROM_HEX	TOK_FROM_HEX
FULL	TOK_FULL
FUNCTION	TOK_FUNCTION
FUNCTIONS	TOK_FUNCTIONS
G	TOK_G
GENERAL	TOK_GENERAL
GENERATE	TOK_GENERATE
GENERATED	TOK_GENERATED
GET	TOK_GET
GHOST	TOK_GHOST
GIVE	TOK_GIVE
GLOBAL	TOK_GLOBAL
GRANT	TOK_GRANT
GRANTED	TOK_GRANTED
GRANTEES	TOK_GRANTEES
GREATER_EQUAL	TOK_GREATER_EQUAL
GREATEST	TOK_GREATEST
GROUP	TOK_GROUP
GROUP_CONCAT	TOK_GROUP_CONCAT
GROUPING	TOK_GROUPING
GROUPING_ID	TOK_GROUPING_ID
GZIP	TOK_GZIP
HARDWARE	TOK_HARDWARE
HASH	TOK_HASH
HASH2	TOK_HASH2
HASH2PARTFUNC	TOK_HASH2PARTFUNC
HASHPARTFUNC	TOK_HASHPARTFUNC
HAVING	TOK_HAVING
HBASE	TOK_HBASE
HBASE_OPTIONS	TOK_HBASE_OPTIONS
HBASE_TIMESTAMP	TOK_HBASE_TIMESTAMP
HBASE_VERSION	TOK_HBASE_VERSION
HBMAP_TABLE	TOK_HBMAP_TABLE
HEADER	TOK_HEADER
HEADING	TOK_HEADING
HEADINGS	TOK_HEADINGS
HEX	TOK_HEX
HEXADECIMAL	TOK_HEXADECIMAL
HIGH_VALUE	TOK_HIGH_VALUE
HIVE	TOK_HIVE
HIVEMD	TOK_HIVEMD
HOLD	TOK_HOLD
HORIZONTAL	TOK_HORIZONTAL
HOST	TOK_HOST
HOUR	TOK_HOUR
HOURS	TOK_HOURS
HYBRID_QUERY_CACHE	TOK_HYBRID_QUERY_CACHE
HYBRID_QUERY_CACHE_ENTRIES	TOK_HYBRID_QUERY_CACHE_ENTRIES
ICOMPRESS	TOK_ICOMPRESS
IDENTITY	TOK_IDENTITY
IF	TOK_IF
IGNORE	TOK_IGNORE
IGNORE_TRIGGER	TOK_IGNORE_TRIGGER
IGNORETRIGGERS	TOK_IGNORETRIGGERS
IMMEDIATE	TOK_IMMEDIATE
IMMUTABLE	TOK_IMMUTABLE
IMPLICIT	TOK_IMPLICIT
IN	TOK_IN
INCLUSIVE	TOK_INCLUSIVE
INCREMENT	TOK_INCREMENT
INCREMENTAL	TOK_INCREMENTAL
INDEX	TOK_INDEX
INDEXES	TOK_INDEXES
INDEX_TABLE	TOK_INDEX_TABLE
INDICATOR	TOK_INDICATOR
INDICATOR_DATA	TOK_INDICATOR_DATA
INDICATOR_POINTER	TOK_INDICATOR_POINTER
INDICATOR_TYPE	TOK_INDICATOR_TYPE
INET_ATON	TOK_INET_ATON
INET_NTOA	TOK_INET_NTOA
INGEST	TOK_INGEST
INITIAL	TOK_INITIAL
INITIALIZATION	TOK_INITIALIZATION
INITIALIZE	TOK_INITIALIZE
INITIALIZED	TOK_INITIALIZED
INITIALIZE_MAINTAIN	TOK_INITIALIZE_MAINTAIN
INITIALIZE_SQL	TOK_INITIALIZE_SQL
INNER	TOK_INNER
INOUT	TOK_INOUT
INPUT	TOK_INPUT
INPUTS	TOK_INPUTS
INS	TOK_INS
INSERT	TOK_INSERT
INSERTLOG	TOK_INSERTLOG
INSERT_ONLY	TOK_INSERT_ONLY
INSTR	TOK_INSTR
INTEGER	TOK_INTEGER
INTERNAL	TOK_INTERNAL
INTERNAL_COLUMN_DEFINITION	TOK_INTERNAL_COLUMN_DEFINITION
INTERNAL_EXPR	TOK_INTERNAL_EXPR
INTERNALSP	TOK_INTERNALSP
INTERSECT	TOK_INTERSECT
INTERVAL	TOK_INTERVAL
INTERVALS	TOK_INTERVALS
INTO	TOK_INTO
INVALID	TOK_INVALID
INVALIDATE	TOK_INVALIDATE
INVOKE	TOK_INVOKE
INVOKER	TOK_INVOKER
IO	TOK_IO
IS	TOK_IS
ISIPV4	TOK_ISIPV4
ISIPV6	TOK_ISIPV6
ISLACK	TOK_ISLACK
ISNULL	TOK_ISNULL
ISOLATE	TOK_ISOLATE
ISOLATION	TOK_ISOLATION
IUDLOG	TOK_IUDLOG
IUD_LOG_TABLE	TOK_IUD_LOG_TABLE
JAVA	TOK_JAVA
JOIN	TOK_JOIN
JOURNAL	TOK_JOURNAL
JSONOBJECTFIELDTEXT	TOK_JSONOBJECTFIELDTEXT
JULIANTIMESTAMP	TOK_JULIANTIMESTAMP
K	TOK_K
KEY	TOK_KEY
KEY_RANGE_COMPARE	TOK_KEY_RANGE_COMPARE
LABEL	TOK_LABEL
LABEL_ALTER	TOK_LABEL_ALTER
LABEL_CREATE	TOK_LABEL_CREATE
LABEL_DROP	TOK_LABEL_DROP
LABEL_PURGEDATA	TOK_LABEL_PURGEDATA
LAG	TOK_LAG
LANGUAGE	TOK_LANGUAGE
LARGEINT	TOK_LARGEINT
LAST	TOK_LAST
LAST_DAY	TOK_LAST_DAY
LAST_FSCODE	TOK_LAST_FSCODE
LASTNOTNULL	TOK_LASTNOTNULL
LASTSYSKEY	TOK_LASTSYSKEY
LAST_SYSKEY	TOK_LAST_SYSKEY
LCASE	TOK_LCASE
LEAD	TOK_LEAD
LEADING	TOK_LEADING
LEADING_PRECISION	TOK_LEADING_PRECISION
LEAST	TOK_LEAST
LEFT	TOK_LEFT
LENGTH	TOK_LENGTH
LESS_EQUAL	TOK_LESS_EQUAL
LEVEL	TOK_LEVEL
LEVELS	TOK_LEVELS
LIBRARIES	TOK_LIBRARIES
LIBRARY	TOK_LIBRARY
LIKE	TOK_LIKE
LIMIT	TOK_LIMIT
LINE_NUMBER	TOK_LINE_NUMBER
LOAD	TOK_LOAD
LOAD_ID	TOK_LOAD_ID
LOADTOLOB	TOK_LOADTOLOB
LOB	TOK_LOB
LOBLENGTH	TOK_LOBLENGTH
LOBTOBUFFER	TOK_LOBTOBUFFER
LOBTOFILE	TOK_LOBTOFILE
LOBTOSTRING	TOK_LOBTOSTRING
LOCAL	TOK_LOCAL
LOCATE	TOK_LOCATE
LOCATION	TOK_LOCATION
LOCK	TOK_LOCK
LOCKING	TOK_LOCKING
LOCKONREFRESH	TOK_LOCKONREFRESH
LOCK_ROW	TOK_LOCK_ROW
LOG	TOK_LOG
LOG10	TOK_LOG10
LOG2	TOK_LOG2
LOGGABLE	TOK_LOGGABLE
LOGON	TOK_LOGON
LONG	TOK_LONG
LONGWVARCHAR	TOK_LONGWVARCHAR
LOWER	TOK_LOWER
LOW_VALUE	TOK_LOW_VALUE
LPAD	TOK_LPAD
LPAREN_BEFORE_DATATYPE	TOK_LPAREN_BEFORE_DATATYPE
LPAREN_BEFORE_DATE_AND_LPAREN	TOK_LPAREN_BEFORE_DATE_AND_LPAREN
LPAREN_BEFORE_DATE_COMMA_AND_FORMAT	TOK_LPAREN_BEFORE_DATE_COMMA_AND_FORMAT
LPAREN_BEFORE_FORMAT	TOK_LPAREN_BEFORE_FORMAT
LPAREN_BEFORE_NAMED	TOK_LPAREN_BEFORE_NAMED
LSDECIMAL	TOK_LSDECIMAL
LTRIM	TOK_LTRIM
LZO	TOK_LZO
M	TOK_M
MAINTAIN	TOK_MAINTAIN
MANAGEMENT	TOK_MANAGEMENT
MANUAL	TOK_MANUAL
MAP	TOK_MAP
MASTER	TOK_MASTER
MATCH	TOK_MATCH
MATCHED	TOK_MATCHED
MATERIALIZED	TOK_MATERIALIZED
MAVG	TOK_MAVG
MAX	TOK_MAX
MAXEXTENTS	TOK_MAXEXTENTS
MAXRUNTIME	TOK_MAXRUNTIME
MAXVALUE	TOK_MAXVALUE
MBYTE_LITERAL	TOK_MBYTE_LITERAL
MCOUNT	TOK_MCOUNT
MD5	TOK_MD5
MEMORY	TOK_MEMORY
MERGE	TOK_MERGE
MESSAGE	TOK_MESSAGE
MESSAGE_LEN	TOK_MESSAGE_LEN
MESSAGE_OCTET_LEN	TOK_MESSAGE_OCTET_LEN
MESSAGE_TEXT	TOK_MESSAGE_TEXT
METADATA	TOK_METADATA
MIN	TOK_MIN
MINIMAL	TOK_MINIMAL
MINUTE	TOK_MINUTE
MINUTES	TOK_MINUTES
MINVALUE	TOK_MINVALUE
MIXED	TOK_MIXED
MMAX	TOK_MMAX
MMIN	TOK_MMIN
MOD	TOK_MOD
MODE	TOK_MODE
MODIFIES	TOK_MODIFIES
MODULE	TOK_MODULE
MODULES	TOK_MODULES
MONTH	TOK_MONTH
MONTHNAME	TOK_MONTHNAME
MONTHS_BETWEEN	TOK_MONTHS_BETWEEN
MORE	TOK_MORE
MOVE	TOK_MOVE
MOVEMENT	TOK_MOVEMENT
MRANK	TOK_MRANK
MSCK	TOK_MSCK
MSTDDEV	TOK_MSTDDEV
MSUM	TOK_MSUM
MTS	TOK_MTS
MULTI	TOK_MULTI
MULTIDELTA	TOK_MULTIDELTA
MULTISET	TOK_MULTISET
MV	TOK_MV
MVARIANCE	TOK_MVARIANCE
MVATTRIBUTE	TOK_MVATTRIBUTE
MVATTRIBUTES	TOK_MVATTRIBUTES
MVGROUP	TOK_MVGROUP
MVGROUPS	TOK_MVGROUPS
MVLOG	TOK_MVLOG
MVS	TOK_MVS
MVSTATUS	TOK_MVSTATUS
MVS_UMD	TOK_MVS_UMD
MV_TABLE	TOK_MV_TABLE
MVUID	TOK_MVUID
NAME	TOK_NAME
NAMED	TOK_NAMED
NAMES	TOK_NAMES
NAMESPACE	TOK_NAMESPACE
NAMETYPE	TOK_NAMETYPE
NAROUTINE_ACTION_CACHE	TOK_NAROUTINE_ACTION_CACHE
NAROUTINE_CACHE	TOK_NAROUTINE_CACHE
NATABLE_CACHE	TOK_NATABLE_CACHE
NATABLE_CACHE_ENTRIES	TOK_NATABLE_CACHE_ENTRIES
NATIONAL	TOK_NATIONAL
NATIVE	TOK_NATIVE
NATURAL	TOK_NATURAL
NCHAR	TOK_NCHAR
NECESSARY	TOK_NECESSARY
NEEDED	TOK_NEEDED
NEW	TOK_NEW
NEXT	TOK_NEXT
NEXT_DAY	TOK_NEXT_DAY
NO	TOK_NO
NO_DEFAULT	TOK_NO_DEFAULT
NODELETE	TOK_NODELETE
NODES	TOK_NODES
NO_LOAD	TOK_NO_LOAD
NOLOG	TOK_NOLOG
NOMVLOG	TOK_NOMVLOG
NONE	TOK_NONE
NO_PARTITION	TOK_NO_PARTITION
NO_PARTITIONS	TOK_NO_PARTITIONS
NORMAL	TOK_NORMAL
NOT	TOK_NOT
NOT_BETWEEN	TOK_NOT_BETWEEN
NOT_CASESPECIFIC	TOK_NOT_CASESPECIFIC
NOT_DROPPABLE	TOK_NOT_DROPPABLE
NOT_ENFORCED	TOK_NOT_ENFORCED
NOT_EQUAL	TOK_NOT_EQUAL
NOT_IN	TOK_NOT_IN
NOW	TOK_NOW
NSK_CODE	TOK_NSK_CODE
NULL	TOK_NULL
NULLABLE	TOK_NULLABLE
NULLIF	TOK_NULLIF
NULLIFZERO	TOK_NULLIFZERO
NULL_IND_OFFSET	TOK_NULL_IND_OFFSET
NULL_STRING	TOK_NULL_STRING
NUMBER	TOK_NUMBER
NUMERIC	TOK_NUMERIC
NUM_OF_RANGES	TOK_NUM_OF_RANGES
NVL	TOK_NVL
OBJECT	TOK_OBJECT
OBJECTS	TOK_OBJECTS
OBSOLETE	TOK_OBSOLETE
OCTET_LENGTH	TOK_OCTET_LENGTH
OF	TOK_OF
OFF	TOK_OFF
OFFLINE	TOK_OFFLINE
OFFSET	TOK_OFFSET
OJ	TOK_OJ
OLD	TOK_OLD
ON	TOK_ON
ONLINE	TOK_ONLINE
ONLY	TOK_ONLY
OPCODE	TOK_OPCODE
OPEN	TOK_OPEN
OPENBLOWNAWAY	TOK_OPENBLOWNAWAY
OPTION	TOK_OPTION
OPTIONS	TOK_OPTIONS
OR	TOK_OR
ORDER	TOK_ORDER
ORDERED	TOK_ORDERED
OSIM	TOK_OSIM
OS_USERID	TOK_OS_USERID
OUT	TOK_OUT
OUTER	TOK_OUTER
OUTPUT	TOK_OUTPUT
OVER	TOK_OVER
OVERLAPS	TOK_OVERLAPS
OVERLAY	TOK_OVERLAY
OVERRIDE	TOK_OVERRIDE
OVERWRITE	TOK_OVERWRITE
PACKED	TOK_PACKED
PAGE	TOK_PAGE
PAGES	TOK_PAGES
PARALLEL	TOK_PARALLEL
PARALLELISM	TOK_PARALLELISM
PARAMETER	TOK_PARAMETER
PARAMETER_INDEX	TOK_PARAMETER_INDEX
PARAMETER_MODE	TOK_PARAMETER_MODE
PARAMETER_ORDINAL_POSITION	TOK_PARAMETER_ORDINAL_POSITION
PARENT	TOK_PARENT
PARSERFLAGS	TOK_PARSERFLAGS
PARTIAL	TOK_PARTIAL
PARTITION	TOK_PARTITION
PARTITION_BY	TOK_PARTITION_BY
PARTITIONING	TOK_PARTITIONING
PARTITIONS	TOK_PARTITIONS
PASS	TOK_PASS
PATH	TOK_PATH
PERCENT	TOK_PERCENT
PERFORM	TOK_PERFORM
PERIODIC	TOK_PERIODIC
PERTABLE	TOK_PERTABLE
PHASE	TOK_PHASE
PI	TOK_PI
PICTURE	TOK_PICTURE
PID	TOK_PID
PIPELINE	TOK_PIPELINE
PIVOT	TOK_PIVOT
PIVOT_GROUP	TOK_PIVOT_GROUP
PLACING	TOK_PLACING
POOL	TOK_POOL
POPULATE	TOK_POPULATE
POS	TOK_POS
POSITION	TOK_POSITION
POWER	TOK_POWER
PRECEDING	TOK_PRECEDING
PRECISION	TOK_PRECISION
PREFER_FOR_SCAN_KEY	TOK_PREFER_FOR_SCAN_KEY
PREPARE	TOK_PREPARE
PRESERVE	TOK_PRESERVE
PRIMARY	TOK_PRIMARY
PRIMARY_INDEX	TOK_PRIMARY_INDEX
PRIORITY	TOK_PRIORITY
PRIORITY_DELTA	TOK_PRIORITY_DELTA
PRIVATE	TOK_PRIVATE
PRIVILEGE	TOK_PRIVILEGE
PRIVILEGES	TOK_PRIVILEGES
PROCEDURE	TOK_PROCEDURE
PROCEDURES	TOK_PROCEDURES
PROCESS	TOK_PROCESS
PROGRESS	TOK_PROGRESS
PROMPT	TOK_PROMPT
PROTECTED	TOK_PROTECTED
PROTECTION	TOK_PROTECTION
PROTOTYPE	TOK_PROTOTYPE
PUBLIC	TOK_PUBLIC
PURGEDATA	TOK_PURGEDATA
QID	TOK_QID
QID_INTERNAL	TOK_QID_INTERNAL
QUALIFY	TOK_QUALIFY
QUARTER	TOK_QUARTER
QUERY	TOK_QUERY
QUERY_CACHE	TOK_QUERY_CACHE
QUERY_CACHE_ENTRIES	TOK_QUERY_CACHE_ENTRIES
QUERYID_EXTRACT	TOK_QUERYID_EXTRACT
RADIANS	TOK_RADIANS
RAND	TOK_RAND
RANDOM	TOK_RANDOM
RANGE	TOK_RANGE
RANGELOG	TOK_RANGELOG
RANGE_LOG_TABLE	TOK_RANGE_LOG_TABLE
RANGE_N	TOK_RANGE_N
RATE	TOK_RATE
RAVG	TOK_RAVG
RCOUNT	TOK_RCOUNT
READ	TOK_READ
READS	TOK_READS
REAL	TOK_REAL
REAL_IEEE	TOK_REAL_IEEE
REBUILD	TOK_REBUILD
RECOMPUTE	TOK_RECOMPUTE
RECORD_SEPARATOR	TOK_RECORD_SEPARATOR
RECOVER	TOK_RECOVER
RECOVERY	TOK_RECOVERY
RECURSIVE	TOK_RECURSIVE
REDEFTIME	TOK_REDEFTIME
REFERENCES	TOK_REFERENCES
REFERENCING	TOK_REFERENCING
REFRESH	TOK_REFRESH
REGEXP	TOK_REGEXP
REGION	TOK_REGION
REGISTER	TOK_REGISTER
REGISTERED	TOK_REGISTERED
REINITIALIZE	TOK_REINITIALIZE
REINITIALIZE_MAINTAIN	TOK_REINITIALIZE_MAINTAIN
RELATED	TOK_RELATED
RELATEDNESS	TOK_RELATEDNESS
RELOAD	TOK_RELOAD
REMOTE	TOK_REMOTE
REMOVE	TOK_REMOVE
RENAME	TOK_RENAME
REPAIR	TOK_REPAIR
REPEAT	TOK_REPEAT
REPEATABLE	TOK_REPEATABLE
REPEATABLE_READ	TOK_REPEATABLE_READ
REPLACE	TOK_REPLACE
REPLICATE_PARTITION	TOK_REPLICATE_PARTITION
REPOSITORY	TOK_REPOSITORY
REQUEST	TOK_REQUEST
REQUIRED	TOK_REQUIRED
RESET	TOK_RESET
RESTORE	TOK_RESTORE
RESTRICT	TOK_RESTRICT
RESULT	TOK_RESULT
RESUME	TOK_RESUME
RETRIES	TOK_RETRIES
RETURN	TOK_RETURN
RETURNED_LENGTH	TOK_RETURNED_LENGTH
RETURNED_OCTET_LENGTH	TOK_RETURNED_OCTET_LENGTH
RETURNED_SQLSTATE	TOK_RETURNED_SQLSTATE
RETURNS	TOK_RETURNS
REVERSE	TOK_REVERSE
REVOKE	TOK_REVOKE
REWRITE	TOK_REWRITE
RIGHT	TOK_RIGHT
RMAX	TOK_RMAX
RMIN	TOK_RMIN
RMS	TOK_RMS
ROLE	TOK_ROLE
ROLES	TOK_ROLES
ROLLBACK	TOK_ROLLBACK
ROLLUP	TOK_ROLLUP
ROUND	TOK_ROUND
ROW	TOK_ROW
ROW_COUNT	TOK_ROW_COUNT
ROWNUM	TOK_ROWNUM
ROW_NUMBER	TOK_ROW_NUMBER
ROWS	TOK_ROWS
ROWS_COVERED	TOK_ROWS_COVERED
ROWS_DELETED	TOK_ROWS_DELETED
ROWSET	TOK_ROWSET
ROWSET_IND_LAYOUT_SIZE	TOK_ROWSET_IND_LAYOUT_SIZE
ROWSET_SIZE	TOK_ROWSET_SIZE
ROWSET_VAR_LAYOUT_SIZE	TOK_ROWSET_VAR_LAYOUT_SIZE
ROWS_INSERTED	TOK_ROWS_INSERTED
ROWS_UPDATED	TOK_ROWS_UPDATED
ROWWISE	TOK_ROWWISE
RPAD	TOK_RPAD
RRANK	TOK_RRANK
RRPARTFUNC	TOK_RRPARTFUNC
RSTDDEV	TOK_RSTDDEV
RSUM	TOK_RSUM
RTRIM	TOK_RTRIM
RUN	TOK_RUN
RVARIANCE	TOK_RVARIANCE
SAFE	TOK_SAFE
SALT	TOK_SALT
SAMPLE	TOK_SAMPLE
SAMPLE_FIRST	TOK_SAMPLE_FIRST
SAMPLE_PERIODIC	TOK_SAMPLE_PERIODIC
SAMPLE_RANDOM	TOK_SAMPLE_RANDOM
SAS_FORMAT	TOK_SAS_FORMAT
SAS_LOCALE	TOK_SAS_LOCALE
SAS_MODEL_INPUT_TABLE	TOK_SAS_MODEL_INPUT_TABLE
SBYTE_LITERAL	TOK_SBYTE_LITERAL
SCALAR	TOK_SCALAR
SCALE	TOK_SCALE
SCAN	TOK_SCAN
SCHEMA	TOK_SCHEMA
SCHEMA_NAME	TOK_SCHEMA_NAME
SCHEMAS	TOK_SCHEMAS
SECOND	TOK_SECOND
SECONDS	TOK_SECONDS
SECTION	TOK_SECTION
SECURITY	TOK_SECURITY
SEL	TOK_SEL
SELECT	TOK_SELECT
SELECTIVITY	TOK_SELECTIVITY
SEPARATE	TOK_SEPARATE
SEPARATOR	TOK_SEPARATOR
SEQNUM	TOK_SEQNUM
SEQUENCE	TOK_SEQUENCE
SEQUENCE_BY	TOK_SEQUENCE_BY
SEQUENCES	TOK_SEQUENCES
SERIALIZABLE	TOK_SERIALIZABLE
SERIALIZABLE_ACCESS	TOK_SERIALIZABLE_ACCESS
SERIALIZED	TOK_SERIALIZED
SERVER_NAME	TOK_SERVER_NAME
SESSION	TOK_SESSION
SESSIONS	TOK_SESSIONS
SESSION_USER	TOK_SESSION_USER
SESSN_USR_INTN	TOK_SESSN_USR_INTN
SET	TOK_SET
SETS	TOK_SETS
SG_TABLE	TOK_SG_TABLE
SHA	TOK_SHA
SHA1	TOK_SHA1
SHA2	TOK_SHA2
SHAPE	TOK_SHAPE
SHARE	TOK_SHARE
SHARED	TOK_SHARED
SHOW	TOK_SHOW
SHOWCONTROL	TOK_SHOWCONTROL
SHOWDDL	TOK_SHOWDDL
SHOWDDL_COMPONENT	TOK_SHOWDDL_COMPONENT
SHOWDDL_LIBRARY	TOK_SHOWDDL_LIBRARY
SHOWDDL_ROLE	TOK_SHOWDDL_ROLE
SHOWDDL_SEQUENCE	TOK_SHOWDDL_SEQUENCE
SHOWDDL_USER	TOK_SHOWDDL_USER
SHOWPLAN	TOK_SHOWPLAN
SHOWSET	TOK_SHOWSET
SHOWSHAPE	TOK_SHOWSHAPE
SHOWSTATS	TOK_SHOWSTATS
SHOWTRANSACTION	TOK_SHOWTRANSACTION
SIGN	TOK_SIGN
SIGNAL	TOK_SIGNAL
SIGNED	TOK_SIGNED
SIMULATE	TOK_SIMULATE
SIN	TOK_SIN
SINCE	TOK_SINCE
SINGLEDELTA	TOK_SINGLEDELTA
SINH	TOK_SINH
SIZE	TOK_SIZE
SKIP	TOK_SKIP
SKIP_CONFLICT_ACCESS	TOK_SKIP_CONFLICT_ACCESS
SLACK	TOK_SLACK
SLEEP	TOK_SLEEP
SMALLINT	TOK_SMALLINT
SNAPSHOT	TOK_SNAPSHOT
SOFTWARE	TOK_SOFTWARE
SOME	TOK_SOME
SORT	TOK_SORT
SORT_KEY	TOK_SORT_KEY
SOUNDEX	TOK_SOUNDEX
SOURCE	TOK_SOURCE
SOURCE_FILE	TOK_SOURCE_FILE
SPACE	TOK_SPACE
SPLIT_PART	TOK_SPLIT_PART
SP_RESULT_SET	TOK_SP_RESULT_SET
SQL	TOK_SQL
SQLCODE	TOK_SQLCODE
SQL_DOUBLE	TOK_SQL_DOUBLE
SQLERROR	TOK_SQLERROR
SQLROW	TOK_SQLROW
SQLSTATE	TOK_SQLSTATE
SQL_WARNING	TOK_SQL_WARNING
SQRT	TOK_SQRT
START	TOK_START
STATE	TOK_STATE
STATEMENT	TOK_STATEMENT
STATIC	TOK_STATIC
STATISTICS	TOK_STATISTICS
STATS	TOK_STATS
STATUS	TOK_STATUS
STDDEV	TOK_STDDEV
STOP	TOK_STOP
STORAGE	TOK_STORAGE
STORE	TOK_STORE
STORED	TOK_STORED
STREAM	TOK_STREAM
STRING_SEARCH	TOK_STRING_SEARCH
STRINGTOEXTERNAL	TOK_STRINGTOEXTERNAL
STRINGTOLOB	TOK_STRINGTOLOB
STUFF	TOK_STUFF
STYLE	TOK_STYLE
SUBCLASS_ORIGIN	TOK_SUBCLASS_ORIGIN
SUBSTRING	TOK_SUBSTRING
SUBSYSTEM_ID	TOK_SUBSYSTEM_ID
SUFFIX	TOK_SUFFIX
SUM	TOK_SUM
SUMMARY	TOK_SUMMARY
SUSPEND	TOK_SUSPEND
SYNONYM	TOK_SYNONYM
SYNONYMS	TOK_SYNONYMS
SYSDATE	TOK_SYSDATE
SYS_GUID	TOK_SYS_GUID
SYSTEM	TOK_SYSTEM
SYSTIMESTAMP	TOK_SYSTIMESTAMP
T	TOK_T
TABLE	TOK_TABLE
TABLE_MAPPING	TOK_TABLE_MAPPING
TABLE_NAME	TOK_TABLE_NAME
TABLES	TOK_TABLES
TABLESPACE	TOK_TABLESPACE
TAG	TOK_TAG
TAN	TOK_TAN
TANH	TOK_TANH
TARGET	TOK_TARGET
TEMPORARY	TOK_TEMPORARY
TEMP_TABLE	TOK_TEMP_TABLE
TEXT	TOK_TEXT
THEN	TOK_THEN
THIS	TOK_THIS
THROUGH	TOK_THROUGH
TIME	TOK_TIME
TIME_BEFORE_QUOTE	TOK_TIME_BEFORE_QUOTE
TIMEOUT	TOK_TIMEOUT
TIMESTAMP	TOK_TIMESTAMP
TIMESTAMPADD	TOK_TIMESTAMPADD
TIMESTAMPDIFF	TOK_TIMESTAMPDIFF
TINYINT	TOK_TINYINT
TITLE	TOK_TITLE
TO	TOK_TO
TO_BINARY	TOK_TO_BINARY
TO_CHAR	TOK_TO_CHAR
TO_DATE	TOK_TO_DATE
TO_HEX	TOK_TO_HEX
TOKENSTR	TOK_TOKENSTR
TO_NUMBER	TOK_TO_NUMBER
TO_TIME	TOK_TO_TIME
TO_TIMESTAMP	TOK_TO_TIMESTAMP
TRAFODION	TOK_TRAFODION
TRAILING	TOK_TRAILING
TRANSACTION	TOK_TRANSACTION
TRANSFORM	TOK_TRANSFORM
TRANSLATE	TOK_TRANSLATE
TRANSPOSE	TOK_TRANSPOSE
TRIGGER	TOK_TRIGGER
TRIGGER_CATALOG	TOK_TRIGGER_CATALOG
TRIGGER_NAME	TOK_TRIGGER_NAME
TRIGGERS	TOK_TRIGGERS
TRIGGER_SCHEMA	TOK_TRIGGER_SCHEMA
TRIM	TOK_TRIM
TRUE	TOK_TRUE
TRUNC	TOK_TRUNC
TRUNCATE	TOK_TRUNCATE
TS	TOK_TS
TYPE	TOK_TYPE
TYPE_ANSI	TOK_TYPE_ANSI
TYPECAST	TOK_TYPECAST
TYPE_FS	TOK_TYPE_FS
TYPES	TOK_TYPES
UCASE	TOK_UCASE
UDF	TOK_UDF
UID	TOK_UID
UNAVAILABLE	TOK_UNAVAILABLE
UNBOUNDED	TOK_UNBOUNDED
UNCOMMITTED	TOK_UNCOMMITTED
UNHEX	TOK_UNHEX
UNION	TOK_UNION
UNION_JOIN	TOK_UNION_JOIN
UNIQUE	TOK_UNIQUE
UNIQUE_ID	TOK_UNIQUE_ID
UNIVERSAL	TOK_UNIVERSAL
UNIX_TIMESTAMP	TOK_UNIX_TIMESTAMP
UNKNOWN	TOK_UNKNOWN
UNLOAD	TOK_UNLOAD
UNLOCK	TOK_UNLOCK
UNNAMED	TOK_UNNAMED
UNREGISTER	TOK_UNREGISTER
UNSIGNED	TOK_UNSIGNED
UPD	TOK_UPD
UPDATE	TOK_UPDATE
UPDATE_LOB	TOK_UPDATE_LOB
UPDATE_STATS	TOK_UPDATE_STATS
UPGRADE	TOK_UPGRADE
UPPER	TOK_UPPER
UPPERCASE	TOK_UPPERCASE
UPSERT	TOK_UPSERT
UPSHIFT	TOK_UPSHIFT
USA	TOK_USA
USAGE	TOK_USAGE
USE	TOK_USE
USER	TOK_USER
USERNAMEINTTOEXT	TOK_USERNAMEINTTOEXT
USERS	TOK_USERS
USING	TOK_USING
UUID	TOK_UUID
UUID_SHORT	TOK_UUID_SHORT
VALIDATE	TOK_VALIDATE
VALUE	TOK_VALUE
VALUES	TOK_VALUES
VARBINARY	TOK_VARBINARY
VARCHAR	TOK_VARCHAR
VARIABLE_DATA	TOK_VARIABLE_DATA
VARIABLE_POINTER	TOK_VARIABLE_POINTER
VARIANCE	TOK_VARIANCE
VARWCHAR	TOK_VARWCHAR
VARYING	TOK_VARYING
VERSION	TOK_VERSION
VERSION_INFO	TOK_VERSION_INFO
VERSIONS	TOK_VERSIONS
VIEW	TOK_VIEW
VIEWS	TOK_VIEWS
VOLATILE	TOK_VOLATILE
VPROC	TOK_VPROC
VSBB	TOK_VSBB
WAITED	TOK_WAITED
WAITEDIO	TOK_WAITEDIO
WCHAR	TOK_WCHAR
WEEK	TOK_WEEK
WHEN	TOK_WHEN
WHENEVER	TOK_WHENEVER
WHERE	TOK_WHERE
WITH	TOK_WITH
WITHOUT	TOK_WITHOUT
WOM	TOK_WOM
WORK	TOK_WORK
WRITE	TOK_WRITE
XMLAGG	TOK_XMLAGG
XMLELEMENT	TOK_XMLELEMENT
YEAR	TOK_YEAR
ZEROIFNULL	TOK_ZEROIFNULL

ANY_STRING	ANY_STRING
BACKSLASH_SYSTEM_NAME	BACKSLASH_SYSTEM_NAME
CALL_CASED_IDENTIFIER	CALL_CASED_IDENTIFIER
GOTO_CASED_IDENTIFIER	GOTO_CASED_IDENTIFIER
HOSTVAR	HOSTVAR
PERFORM_CASED_IDENTIFIER	PERFORM_CASED_IDENTIFIER
SYSTEM_CPU_IDENTIFIER	SYSTEM_CPU_IDENTIFIER
SYSTEM_VOLUME_NAME	SYSTEM_VOLUME_NAME

\?{ident}	PARAMETER
\@[A][0-9]+	ARITH_PLACEHOLDER
\@[B][0-9]+	BOOL_PLACEHOLDER
'([^']|"''")*'	QUOTED_STRING
\d+[Ee][+-]?\d+	NUMERIC_LITERAL_APPROX
\d+	NUMERIC_LITERAL_EXACT_NO_SCALE
\d+"."\d+	NUMERIC_LITERAL_EXACT_WITH_SCALE

[`]{ident}[`]	BACKQUOTED_IDENTIFIER
\"{ident}\"	DELIMITED_IDENTIFIER
"$"{ident}	DOLLAR_IDENTIFIER
{ident}	IDENTIFIER

%%
