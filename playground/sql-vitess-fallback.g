//From: https://github.com/vitessio/vitess/blob/b0b3ed68ecfc28d83fcec9ef171361bf81188b53/go/vt/sqlparser/sql.y
/*
Copyright 2019 The Vitess Authors.

Licensed under the Apache License, Version 2.0 (the "License");
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

/*Tokens*/
%token MEMBER
///%token FUNCTION_CALL_NON_KEYWORD
///%token STRING_TYPE_PREFIX_NON_KEYWORD
//%token LEX_ERROR
%token UNION
%token SELECT
%token STREAM
%token VSTREAM
%token INSERT
%token UPDATE
%token DELETE
%token FROM
%token WHERE
%token GROUP
%token HAVING
%token ORDER
%token BY
%token LIMIT
%token OFFSET
%token FOR
%token ALL
%token DISTINCT
%token AS
%token EXISTS
%token ASC
%token DESC
%token INTO
%token DUPLICATE
%token DEFAULT
%token SET
%token LOCK
%token UNLOCK
%token KEYS
%token DO
%token CALL
%token DISTINCTROW
%token PARSER
%token GENERATED
%token ALWAYS
%token OUTFILE
%token S3
%token DATA
%token LOAD
%token LINES
%token TERMINATED
%token ESCAPED
%token ENCLOSED
%token DUMPFILE
%token CSV
%token HEADER
%token MANIFEST
%token OVERWRITE
%token STARTING
%token OPTIONALLY
%token VALUES
///%token LAST_INSERT_ID
%token NEXT
//%token VALUE
%token SHARE
%token MODE
%token SQL_NO_CACHE
%token SQL_CACHE
%token SQL_CALC_FOUND_ROWS
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
%token ON
%token USING
%token INPLACE
%token COPY
%token INSTANT
%token ALGORITHM
%token NONE
%token SHARED
%token EXCLUSIVE
%token SUBQUERY_AS_EXPR
%token '('
%token ','
%token ')'
%token STRING
%token ID
%token AT_ID
%token AT_AT_ID
%token HEX
%token NCHAR_STRING
%token INTEGRAL
%token FLOAT
%token DECIMAL
%token HEXNUM
%token COMMENT
%token COMMENT_KEYWORD
%token BITNUM
%token BIT_LITERAL
%token COMPRESSION
%token VALUE_ARG
%token LIST_ARG
%token OFFSET_ARG
%token JSON_PRETTY
%token JSON_STORAGE_SIZE
%token JSON_STORAGE_FREE
%token JSON_CONTAINS
%token JSON_CONTAINS_PATH
%token JSON_EXTRACT
%token JSON_KEYS
%token JSON_OVERLAPS
%token JSON_SEARCH
%token JSON_VALUE
%token EXTRACT
%token NULL
%token TRUE
%token FALSE
%token OFF
%token DISCARD
%token IMPORT
%token ENABLE
%token DISABLE
%token TABLESPACE
%token VIRTUAL
%token STORED
%token BOTH
%token LEADING
%token TRAILING
%token KILL
%token EMPTY_FROM_CLAUSE
%token LOWER_THAN_CHARSET
%token CHARSET
%token UNIQUE
%token KEY
%token EXPRESSION_PREC_SETTER
%token OR
%token '|'
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
%token RLIKE
%token IN
%token ASSIGNMENT_OPT
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
%token UNDERSCORE_ARMSCII8
%token UNDERSCORE_ASCII
%token UNDERSCORE_BIG5
%token UNDERSCORE_BINARY
%token UNDERSCORE_CP1250
%token UNDERSCORE_CP1251
%token UNDERSCORE_CP1256
%token UNDERSCORE_CP1257
%token UNDERSCORE_CP850
%token UNDERSCORE_CP852
%token UNDERSCORE_CP866
%token UNDERSCORE_CP932
%token UNDERSCORE_DEC8
%token UNDERSCORE_EUCJPMS
%token UNDERSCORE_EUCKR
%token UNDERSCORE_GB18030
%token UNDERSCORE_GB2312
%token UNDERSCORE_GBK
%token UNDERSCORE_GEOSTD8
%token UNDERSCORE_GREEK
%token UNDERSCORE_HEBREW
%token UNDERSCORE_HP8
%token UNDERSCORE_KEYBCS2
%token UNDERSCORE_KOI8R
%token UNDERSCORE_KOI8U
%token UNDERSCORE_LATIN1
%token UNDERSCORE_LATIN2
%token UNDERSCORE_LATIN5
%token UNDERSCORE_LATIN7
%token UNDERSCORE_MACCE
%token UNDERSCORE_MACROMAN
%token UNDERSCORE_SJIS
%token UNDERSCORE_SWE7
%token UNDERSCORE_TIS620
%token UNDERSCORE_UCS2
%token UNDERSCORE_UJIS
%token UNDERSCORE_UTF16
%token UNDERSCORE_UTF16LE
%token UNDERSCORE_UTF32
%token UNDERSCORE_UTF8
%token UNDERSCORE_UTF8MB4
%token UNDERSCORE_UTF8MB3
%token INTERVAL
%token '.'
%token WINDOW_EXPR
%token JSON_EXTRACT_OP
%token JSON_UNQUOTE_EXTRACT_OP
%token CREATE
%token ALTER
%token DROP
%token RENAME
%token ANALYZE
%token ADD
%token FLUSH
%token CHANGE
%token MODIFY
%token DEALLOCATE
%token REVERT
%token QUERIES
%token SCHEMA
%token TABLE
%token INDEX
%token VIEW
%token TO
%token IGNORE
%token IF
%token PRIMARY
%token COLUMN
%token SPATIAL
%token FULLTEXT
%token KEY_BLOCK_SIZE
%token CHECK
%token INDEXES
%token ACTION
%token CASCADE
%token CONSTRAINT
%token FOREIGN
%token NO
%token REFERENCES
%token RESTRICT
%token SHOW
%token DESCRIBE
%token EXPLAIN
%token DATE
%token ESCAPE
%token REPAIR
%token OPTIMIZE
%token TRUNCATE
%token COALESCE
%token EXCHANGE
%token REBUILD
%token PARTITIONING
%token REMOVE
%token PREPARE
%token EXECUTE
%token MAXVALUE
%token PARTITION
%token REORGANIZE
%token LESS
%token THAN
%token PROCEDURE
%token TRIGGER
%token VINDEX
%token VINDEXES
%token DIRECTORY
%token NAME
%token UPGRADE
%token STATUS
%token VARIABLES
%token WARNINGS
%token CASCADED
%token DEFINER
%token OPTION
%token SQL
%token UNDEFINED
%token SEQUENCE
%token MERGE
%token TEMPORARY
%token TEMPTABLE
%token INVOKER
%token SECURITY
%token FIRST
%token AFTER
%token LAST
%token VITESS_MIGRATION
%token CANCEL
%token RETRY
%token LAUNCH
%token COMPLETE
%token CLEANUP
%token THROTTLE
%token UNTHROTTLE
%token EXPIRE
%token RATIO
%token VITESS_THROTTLER
%token BEGIN
%token START
%token TRANSACTION
%token COMMIT
%token ROLLBACK
%token SAVEPOINT
%token RELEASE
%token WORK
%token CONSISTENT
%token SNAPSHOT
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
%token FLOAT4_TYPE
%token FLOAT8_TYPE
%token DECIMAL_TYPE
%token NUMERIC
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
%token JSON_SCHEMA_VALID
%token JSON_SCHEMA_VALIDATION_REPORT
%token ENUM
%token GEOMETRY
%token POINT
%token LINESTRING
%token POLYGON
///%token GEOMCOLLECTION
%token GEOMETRYCOLLECTION
%token MULTIPOINT
%token MULTILINESTRING
%token MULTIPOLYGON
%token ASCII
%token UNICODE
//%token NULLX
%token AUTO_INCREMENT
//%token APPROXNUM
%token SIGNED
%token UNSIGNED
%token ZEROFILL
%token PURGE
%token BEFORE
%token CODE
%token COLLATION
%token COLUMNS
%token DATABASES
%token ENGINES
%token EVENT
%token EXTENDED
%token FIELDS
%token FULL
%token FUNCTION
%token GTID_EXECUTED
%token KEYSPACES
%token OPEN
%token PLUGINS
%token PRIVILEGES
%token PROCESSLIST
%token SCHEMAS
%token TABLES
%token TRIGGERS
%token USER
%token VGTID_EXECUTED
%token VITESS_KEYSPACES
%token VITESS_METADATA
%token VITESS_MIGRATIONS
%token VITESS_REPLICATION_STATUS
%token VITESS_SHARDS
%token VITESS_TABLETS
%token VITESS_TARGET
%token VSCHEMA
%token VITESS_THROTTLED_APPS
%token NAMES
%token GLOBAL
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
%token ADDDATE
%token CURRENT_TIMESTAMP
%token DATABASE
%token CURRENT_DATE
%token CURDATE
%token DATE_ADD
%token DATE_SUB
%token NOW
%token SUBDATE
%token CURTIME
%token CURRENT_TIME
%token LOCALTIME
%token LOCALTIMESTAMP
%token CURRENT_USER
%token UTC_DATE
%token UTC_TIME
%token UTC_TIMESTAMP
%token SYSDATE
%token DAY
%token DAY_HOUR
%token DAY_MICROSECOND
%token DAY_MINUTE
%token DAY_SECOND
%token HOUR
%token HOUR_MICROSECOND
%token HOUR_MINUTE
%token HOUR_SECOND
%token MICROSECOND
%token MINUTE
%token MINUTE_MICROSECOND
%token MINUTE_SECOND
%token MONTH
%token QUARTER
%token SECOND
%token SECOND_MICROSECOND
%token YEAR_MONTH
%token WEEK
%token SQL_TSI_DAY
%token SQL_TSI_WEEK
%token SQL_TSI_HOUR
%token SQL_TSI_MINUTE
%token SQL_TSI_MONTH
%token SQL_TSI_QUARTER
%token SQL_TSI_SECOND
%token SQL_TSI_MICROSECOND
%token SQL_TSI_YEAR
%token REPLACE
%token CONVERT
%token CAST
%token SUBSTR
%token SUBSTRING
%token SEPARATOR
%token TIMESTAMPADD
%token TIMESTAMPDIFF
%token WEIGHT_STRING
%token LTRIM
%token RTRIM
%token TRIM
%token JSON_ARRAY
%token JSON_OBJECT
%token JSON_QUOTE
%token JSON_DEPTH
%token JSON_TYPE
%token JSON_LENGTH
%token JSON_VALID
%token JSON_ARRAY_APPEND
%token JSON_ARRAY_INSERT
%token JSON_INSERT
%token JSON_MERGE
%token JSON_MERGE_PATCH
%token JSON_MERGE_PRESERVE
%token JSON_REMOVE
%token JSON_REPLACE
%token JSON_SET
%token JSON_UNQUOTE
%token COUNT
%token AVG
%token MAX
%token MIN
%token SUM
%token GROUP_CONCAT
%token BIT_AND
%token BIT_OR
%token BIT_XOR
%token STD
%token STDDEV
%token STDDEV_POP
%token STDDEV_SAMP
%token VAR_POP
%token VAR_SAMP
%token VARIANCE
%token ANY_VALUE
%token REGEXP_INSTR
%token REGEXP_LIKE
%token REGEXP_REPLACE
%token REGEXP_SUBSTR
%token ExtractValue
%token UpdateXML
%token GET_LOCK
%token RELEASE_LOCK
%token RELEASE_ALL_LOCKS
%token IS_FREE_LOCK
%token IS_USED_LOCK
%token LOCATE
%token POSITION
%token ST_GeometryCollectionFromText
%token ST_GeometryFromText
%token ST_LineStringFromText
%token ST_MultiLineStringFromText
%token ST_MultiPointFromText
%token ST_MultiPolygonFromText
%token ST_PointFromText
%token ST_PolygonFromText
%token ST_GeometryCollectionFromWKB
%token ST_GeometryFromWKB
%token ST_LineStringFromWKB
%token ST_MultiLineStringFromWKB
%token ST_MultiPointFromWKB
%token ST_MultiPolygonFromWKB
%token ST_PointFromWKB
%token ST_PolygonFromWKB
%token ST_AsBinary
%token ST_AsText
%token ST_Dimension
%token ST_Envelope
%token ST_IsSimple
%token ST_IsEmpty
%token ST_GeometryType
%token ST_X
%token ST_Y
%token ST_Latitude
%token ST_Longitude
%token ST_EndPoint
%token ST_IsClosed
%token ST_Length
%token ST_NumPoints
%token ST_StartPoint
%token ST_PointN
%token ST_Area
%token ST_Centroid
%token ST_ExteriorRing
%token ST_InteriorRingN
%token ST_NumInteriorRings
%token ST_NumGeometries
%token ST_GeometryN
%token ST_LongFromGeoHash
%token ST_PointFromGeoHash
%token ST_LatFromGeoHash
%token ST_GeoHash
%token ST_AsGeoJSON
%token ST_GeomFromGeoJSON
%token MATCH
%token AGAINST
%token BOOLEAN
%token LANGUAGE
%token WITH
%token QUERY
%token EXPANSION
%token WITHOUT
%token VALIDATION
///%token UNUSED
%token ARRAY
%token BYTE
%token CUME_DIST
///%token DESCRIPTION
%token DENSE_RANK
%token EMPTY
//%token EXCEPT
%token FIRST_VALUE
%token GROUPING
%token GROUPS
%token JSON_TABLE
%token LAG
%token LAST_VALUE
%token LATERAL
%token LEAD
%token NTH_VALUE
%token NTILE
%token OF
%token OVER
%token PERCENT_RANK
%token RANK
%token RECURSIVE
%token ROW_NUMBER
%token SYSTEM
%token WINDOW
%token ACTIVE
%token ADMIN
%token AUTOEXTEND_SIZE
%token BUCKETS
%token CLONE
%token COLUMN_FORMAT
%token COMPONENT
%token DEFINITION
%token ENFORCED
%token ENGINE_ATTRIBUTE
%token EXCLUDE
%token FOLLOWING
%token GET_MASTER_PUBLIC_KEY
%token HISTOGRAM
%token HISTORY
%token INACTIVE
%token INVISIBLE
%token LOCKED
%token MASTER_COMPRESSION_ALGORITHMS
%token MASTER_PUBLIC_KEY_PATH
%token MASTER_TLS_CIPHERSUITES
%token MASTER_ZSTD_COMPRESSION_LEVEL
%token NESTED
%token NETWORK_NAMESPACE
%token NOWAIT
%token NULLS
%token OJ
%token OLD
%token OPTIONAL
%token ORDINALITY
%token ORGANIZATION
%token OTHERS
%token PARTIAL
%token PATH
%token PERSIST
%token PERSIST_ONLY
%token PRECEDING
%token PRIVILEGE_CHECKS_USER
%token PROCESS
%token RANDOM
%token REFERENCE
%token REQUIRE_ROW_FORMAT
%token RESOURCE
%token RESPECT
%token RESTART
%token RETAIN
%token REUSE
%token ROLE
%token SECONDARY
%token SECONDARY_ENGINE
%token SECONDARY_ENGINE_ATTRIBUTE
%token SECONDARY_LOAD
%token SECONDARY_UNLOAD
%token SIMPLE
%token SKIP
%token SRID
%token THREAD_PRIORITY
%token TIES
%token UNBOUNDED
%token VCPU
%token VISIBLE
%token RETURNING
%token FORMAT_BYTES
%token FORMAT_PICO_TIME
%token PS_CURRENT_THREAD_ID
%token PS_THREAD_ID
%token GTID_SUBSET
%token GTID_SUBTRACT
%token WAIT_FOR_EXECUTED_GTID_SET
%token WAIT_UNTIL_SQL_THREAD_AFTER_GTIDS
%token FORMAT
%token TREE
%token VITESS
%token TRADITIONAL
%token VTEXPLAIN
%token VEXPLAIN
%token PLAN
%token LOCAL
%token LOW_PRIORITY
%token NO_WRITE_TO_BINLOG
%token LOGS
%token ERROR
%token GENERAL
%token HOSTS
%token OPTIMIZER_COSTS
%token USER_RESOURCES
%token SLOW
%token CHANNEL
%token RELAY
%token EXPORT
%token CURRENT
%token ROW
%token ROWS
%token AVG_ROW_LENGTH
%token CONNECTION
%token CHECKSUM
%token DELAY_KEY_WRITE
%token ENCRYPTION
%token ENGINE
%token INSERT_METHOD
%token MAX_ROWS
%token MIN_ROWS
%token PACK_KEYS
%token PASSWORD
%token FIXED
%token DYNAMIC
%token COMPRESSED
%token REDUNDANT
%token COMPACT
%token ROW_FORMAT
%token STATS_AUTO_RECALC
%token STATS_PERSISTENT
%token STATS_SAMPLE_PAGES
%token STORAGE
%token MEMORY
%token DISK
%token PARTITIONS
%token LINEAR
%token RANGE
%token LIST
%token SUBPARTITION
%token SUBPARTITIONS
%token HASH
%token ';'

%token R_KEYW
%fallback R_KEYW ADD
%fallback R_KEYW ALL
%fallback R_KEYW AND
%fallback R_KEYW AS
%fallback R_KEYW ASC
%fallback R_KEYW BETWEEN
%fallback R_KEYW BINARY
%fallback R_KEYW BOTH
%fallback R_KEYW BY
%fallback R_KEYW CASE
%fallback R_KEYW CALL
%fallback R_KEYW CHANGE
%fallback R_KEYW CHARACTER
%fallback R_KEYW CHECK
%fallback R_KEYW COLLATE
%fallback R_KEYW COLUMN
%fallback R_KEYW CONVERT
%fallback R_KEYW CREATE
%fallback R_KEYW CROSS
%fallback R_KEYW CUME_DIST
%fallback R_KEYW CURRENT_DATE
%fallback R_KEYW CURRENT_TIME
%fallback R_KEYW CURRENT_TIMESTAMP
%fallback R_KEYW CURTIME
%fallback R_KEYW CURRENT_USER
%fallback R_KEYW SUBSTR
%fallback R_KEYW SUBSTRING
%fallback R_KEYW DATABASE
%fallback R_KEYW DATABASES
%fallback R_KEYW DEFAULT
%fallback R_KEYW DELETE
%fallback R_KEYW DENSE_RANK
%fallback R_KEYW DESC
%fallback R_KEYW DESCRIBE
%fallback R_KEYW DISTINCT
%fallback R_KEYW DISTINCTROW
%fallback R_KEYW DIV
%fallback R_KEYW DROP
%fallback R_KEYW ELSE
%fallback R_KEYW EMPTY
%fallback R_KEYW ESCAPE
%fallback R_KEYW EXISTS
%fallback R_KEYW EXPLAIN
%fallback R_KEYW EXTRACT
%fallback R_KEYW FALSE
%fallback R_KEYW FIRST_VALUE
%fallback R_KEYW FOR
%fallback R_KEYW FORCE
%fallback R_KEYW FOREIGN
%fallback R_KEYW FROM
%fallback R_KEYW FULLTEXT
%fallback R_KEYW GENERATED
%fallback R_KEYW GROUP
%fallback R_KEYW GROUPING
%fallback R_KEYW GROUPS
%fallback R_KEYW HAVING
%fallback R_KEYW IF
%fallback R_KEYW IGNORE
%fallback R_KEYW IN
%fallback R_KEYW INDEX
%fallback R_KEYW INNER
%fallback R_KEYW INSERT
%fallback R_KEYW INTERVAL
%fallback R_KEYW INTO
%fallback R_KEYW IS
%fallback R_KEYW JOIN
%fallback R_KEYW JSON_TABLE
%fallback R_KEYW KEY
%fallback R_KEYW KILL
%fallback R_KEYW LAG
%fallback R_KEYW LAST_VALUE
%fallback R_KEYW LATERAL
%fallback R_KEYW LEAD
%fallback R_KEYW LEADING
%fallback R_KEYW LEFT
%fallback R_KEYW LIKE
%fallback R_KEYW LIMIT
%fallback R_KEYW LINEAR
%fallback R_KEYW LOCALTIME
%fallback R_KEYW LOCALTIMESTAMP
%fallback R_KEYW LOCK
%fallback R_KEYW LOW_PRIORITY
%fallback R_KEYW MATCH
%fallback R_KEYW MAXVALUE
%fallback R_KEYW MOD
%fallback R_KEYW NATURAL
%fallback R_KEYW NEXT
%fallback R_KEYW NO_WRITE_TO_BINLOG
%fallback R_KEYW NOT
%fallback R_KEYW NOW
%fallback R_KEYW NTH_VALUE
%fallback R_KEYW NTILE
%fallback R_KEYW NULL
%fallback R_KEYW OF
%fallback R_KEYW OFF
%fallback R_KEYW ON
%fallback R_KEYW OPTIMIZER_COSTS
%fallback R_KEYW OR
%fallback R_KEYW ORDER
%fallback R_KEYW OUTER
%fallback R_KEYW OUTFILE
%fallback R_KEYW OVER
%fallback R_KEYW PARTITION
%fallback R_KEYW PERCENT_RANK
%fallback R_KEYW PRIMARY
%fallback R_KEYW RANGE
%fallback R_KEYW RANK
%fallback R_KEYW READ
%fallback R_KEYW RECURSIVE
%fallback R_KEYW REGEXP
%fallback R_KEYW RENAME
%fallback R_KEYW REPLACE
%fallback R_KEYW RIGHT
%fallback R_KEYW RLIKE
%fallback R_KEYW ROW
%fallback R_KEYW ROW_NUMBER
%fallback R_KEYW ROWS
%fallback R_KEYW SCHEMA
%fallback R_KEYW SCHEMAS
%fallback R_KEYW SELECT
%fallback R_KEYW SEPARATOR
%fallback R_KEYW SET
%fallback R_KEYW SHOW
%fallback R_KEYW SPATIAL
%fallback R_KEYW STORED
%fallback R_KEYW STRAIGHT_JOIN
%fallback R_KEYW SYSDATE
%fallback R_KEYW SYSTEM
%fallback R_KEYW TABLE
%fallback R_KEYW THEN
%fallback R_KEYW TO
%fallback R_KEYW TRAILING
%fallback R_KEYW TRUE
%fallback R_KEYW UNION
%fallback R_KEYW UNIQUE
%fallback R_KEYW UNLOCK
%fallback R_KEYW UPDATE
%fallback R_KEYW USE
%fallback R_KEYW USING
%fallback R_KEYW UTC_DATE
%fallback R_KEYW UTC_TIME
%fallback R_KEYW UTC_TIMESTAMP
%fallback R_KEYW VALUES
%fallback R_KEYW VIRTUAL
%fallback R_KEYW WITH
%fallback R_KEYW WHEN
%fallback R_KEYW WHERE
%fallback R_KEYW WINDOW
%fallback R_KEYW WRITE
%fallback R_KEYW XOR

%token NR_KEYW
%fallback NR_KEYW AGAINST
%fallback NR_KEYW ACTION
%fallback NR_KEYW ACTIVE
%fallback NR_KEYW ADDDATE
%fallback NR_KEYW ADMIN
%fallback NR_KEYW AFTER
%fallback NR_KEYW ALGORITHM
%fallback NR_KEYW ALWAYS
%fallback NR_KEYW ANY_VALUE
%fallback NR_KEYW ARRAY
%fallback NR_KEYW ASCII
%fallback NR_KEYW AUTO_INCREMENT
%fallback NR_KEYW AUTOEXTEND_SIZE
%fallback NR_KEYW AVG
%fallback NR_KEYW AVG_ROW_LENGTH
%fallback NR_KEYW BEFORE
%fallback NR_KEYW BEGIN
%fallback NR_KEYW BIGINT
%fallback NR_KEYW BIT
%fallback NR_KEYW BIT_AND
%fallback NR_KEYW BIT_OR
%fallback NR_KEYW BIT_XOR
%fallback NR_KEYW BLOB
%fallback NR_KEYW BOOL
%fallback NR_KEYW BOOLEAN
%fallback NR_KEYW BUCKETS
%fallback NR_KEYW BYTE
%fallback NR_KEYW CANCEL
%fallback NR_KEYW CASCADE
%fallback NR_KEYW CASCADED
%fallback NR_KEYW CHANNEL
%fallback NR_KEYW CHAR
%fallback NR_KEYW CHARSET
%fallback NR_KEYW CHECKSUM
%fallback NR_KEYW CLEANUP
%fallback NR_KEYW CLONE
%fallback NR_KEYW COALESCE
%fallback NR_KEYW CODE
%fallback NR_KEYW COLLATION
%fallback NR_KEYW COLUMN_FORMAT
%fallback NR_KEYW COLUMNS
%fallback NR_KEYW COMMENT_KEYWORD
%fallback NR_KEYW COMMIT
%fallback NR_KEYW COMMITTED
%fallback NR_KEYW COMPACT
%fallback NR_KEYW COMPLETE
%fallback NR_KEYW COMPONENT
%fallback NR_KEYW COMPRESSED
%fallback NR_KEYW COMPRESSION
%fallback NR_KEYW CONNECTION
%fallback NR_KEYW CONSISTENT
%fallback NR_KEYW COPY
%fallback NR_KEYW COUNT
%fallback NR_KEYW CSV
%fallback NR_KEYW CURRENT
%fallback NR_KEYW DATA
%fallback NR_KEYW DATE
%fallback NR_KEYW DATE_ADD
%fallback NR_KEYW DATE_SUB
%fallback NR_KEYW DATETIME
%fallback NR_KEYW DEALLOCATE
%fallback NR_KEYW DECIMAL_TYPE
%fallback NR_KEYW DELAY_KEY_WRITE
%fallback NR_KEYW DEFINER
%fallback NR_KEYW DEFINITION
///%fallback NR_KEYW DESCRIPTION
%fallback NR_KEYW DIRECTORY
%fallback NR_KEYW DISABLE
%fallback NR_KEYW DISCARD
%fallback NR_KEYW DISK
%fallback NR_KEYW DO
%fallback NR_KEYW DOUBLE
%fallback NR_KEYW DUMPFILE
%fallback NR_KEYW DUPLICATE
%fallback NR_KEYW DYNAMIC
%fallback NR_KEYW ENABLE
%fallback NR_KEYW ENCLOSED
%fallback NR_KEYW ENCRYPTION
%fallback NR_KEYW END
%fallback NR_KEYW ENFORCED
%fallback NR_KEYW ENGINE
%fallback NR_KEYW ENGINE_ATTRIBUTE
%fallback NR_KEYW ENGINES
%fallback NR_KEYW ENUM
%fallback NR_KEYW ERROR
%fallback NR_KEYW ESCAPED
%fallback NR_KEYW EVENT
%fallback NR_KEYW EXCHANGE
%fallback NR_KEYW EXCLUDE
%fallback NR_KEYW EXCLUSIVE
%fallback NR_KEYW EXECUTE
%fallback NR_KEYW EXPANSION
%fallback NR_KEYW EXPIRE
%fallback NR_KEYW EXPORT
%fallback NR_KEYW EXTENDED
%fallback NR_KEYW ExtractValue
%fallback NR_KEYW FLOAT_TYPE
%fallback NR_KEYW FIELDS
%fallback NR_KEYW FIRST
%fallback NR_KEYW FIXED
%fallback NR_KEYW FLUSH
%fallback NR_KEYW FOLLOWING
%fallback NR_KEYW FORMAT
%fallback NR_KEYW FORMAT_BYTES
%fallback NR_KEYW FORMAT_PICO_TIME
%fallback NR_KEYW FULL
%fallback NR_KEYW FUNCTION
%fallback NR_KEYW GENERAL
///%fallback NR_KEYW GEOMCOLLECTION
%fallback NR_KEYW GEOMETRY
%fallback NR_KEYW GEOMETRYCOLLECTION
%fallback NR_KEYW GET_LOCK
%fallback NR_KEYW GET_MASTER_PUBLIC_KEY
%fallback NR_KEYW GLOBAL
%fallback NR_KEYW GROUP_CONCAT
%fallback NR_KEYW GTID_EXECUTED
%fallback NR_KEYW GTID_SUBSET
%fallback NR_KEYW GTID_SUBTRACT
%fallback NR_KEYW HASH
%fallback NR_KEYW HEADER
%fallback NR_KEYW HISTOGRAM
%fallback NR_KEYW HISTORY
%fallback NR_KEYW HOSTS
%fallback NR_KEYW IMPORT
%fallback NR_KEYW INACTIVE
%fallback NR_KEYW INPLACE
%fallback NR_KEYW INSERT_METHOD
%fallback NR_KEYW INSTANT
%fallback NR_KEYW INT
%fallback NR_KEYW INTEGER
%fallback NR_KEYW INVISIBLE
%fallback NR_KEYW INVOKER
%fallback NR_KEYW INDEXES
%fallback NR_KEYW IS_FREE_LOCK
%fallback NR_KEYW IS_USED_LOCK
%fallback NR_KEYW ISOLATION
%fallback NR_KEYW JSON
%fallback NR_KEYW JSON_ARRAY
%fallback NR_KEYW JSON_ARRAY_APPEND
%fallback NR_KEYW JSON_ARRAY_INSERT
%fallback NR_KEYW JSON_CONTAINS
%fallback NR_KEYW JSON_CONTAINS_PATH
%fallback NR_KEYW JSON_DEPTH
%fallback NR_KEYW JSON_EXTRACT
%fallback NR_KEYW JSON_INSERT
%fallback NR_KEYW JSON_KEYS
%fallback NR_KEYW JSON_MERGE
%fallback NR_KEYW JSON_MERGE_PATCH
%fallback NR_KEYW JSON_MERGE_PRESERVE
%fallback NR_KEYW JSON_OBJECT
%fallback NR_KEYW JSON_OVERLAPS
%fallback NR_KEYW JSON_PRETTY
%fallback NR_KEYW JSON_QUOTE
%fallback NR_KEYW JSON_REMOVE
%fallback NR_KEYW JSON_REPLACE
%fallback NR_KEYW JSON_SCHEMA_VALID
%fallback NR_KEYW JSON_SCHEMA_VALIDATION_REPORT
%fallback NR_KEYW JSON_SEARCH
%fallback NR_KEYW JSON_SET
%fallback NR_KEYW JSON_STORAGE_FREE
%fallback NR_KEYW JSON_STORAGE_SIZE
%fallback NR_KEYW JSON_TYPE
%fallback NR_KEYW JSON_VALID
%fallback NR_KEYW JSON_VALUE
%fallback NR_KEYW JSON_UNQUOTE
%fallback NR_KEYW KEY_BLOCK_SIZE
%fallback NR_KEYW KEYS
%fallback NR_KEYW KEYSPACES
%fallback NR_KEYW LANGUAGE
%fallback NR_KEYW LAST
///%fallback NR_KEYW LAST_INSERT_ID
%fallback NR_KEYW LAUNCH
%fallback NR_KEYW LESS
%fallback NR_KEYW LEVEL
%fallback NR_KEYW LINES
%fallback NR_KEYW LINESTRING
%fallback NR_KEYW LIST
%fallback NR_KEYW LOAD
%fallback NR_KEYW LOCAL
%fallback NR_KEYW LOCATE
%fallback NR_KEYW LOCKED
%fallback NR_KEYW LOGS
%fallback NR_KEYW LONGBLOB
%fallback NR_KEYW LONGTEXT
%fallback NR_KEYW LTRIM
%fallback NR_KEYW MANIFEST
%fallback NR_KEYW MASTER_COMPRESSION_ALGORITHMS
%fallback NR_KEYW MASTER_PUBLIC_KEY_PATH
%fallback NR_KEYW MASTER_TLS_CIPHERSUITES
%fallback NR_KEYW MASTER_ZSTD_COMPRESSION_LEVEL
%fallback NR_KEYW MAX
%fallback NR_KEYW MAX_ROWS
%fallback NR_KEYW MEDIUMBLOB
%fallback NR_KEYW MEDIUMINT
%fallback NR_KEYW MEDIUMTEXT
%fallback NR_KEYW MEMORY
%fallback NR_KEYW MEMBER
%fallback NR_KEYW MERGE
%fallback NR_KEYW MIN
%fallback NR_KEYW MIN_ROWS
%fallback NR_KEYW MODE
%fallback NR_KEYW MODIFY
%fallback NR_KEYW MULTILINESTRING
%fallback NR_KEYW MULTIPOINT
%fallback NR_KEYW MULTIPOLYGON
%fallback NR_KEYW NAME
%fallback NR_KEYW NAMES
%fallback NR_KEYW NCHAR
%fallback NR_KEYW NESTED
%fallback NR_KEYW NETWORK_NAMESPACE
%fallback NR_KEYW NOWAIT
%fallback NR_KEYW NO
%fallback NR_KEYW NONE
%fallback NR_KEYW NULLS
%fallback NR_KEYW NUMERIC
%fallback NR_KEYW OFFSET
%fallback NR_KEYW OJ
%fallback NR_KEYW OLD
%fallback NR_KEYW OPEN
%fallback NR_KEYW OPTION
%fallback NR_KEYW OPTIONAL
%fallback NR_KEYW OPTIONALLY
%fallback NR_KEYW ORDINALITY
%fallback NR_KEYW ORGANIZATION
%fallback NR_KEYW ONLY
%fallback NR_KEYW OPTIMIZE
%fallback NR_KEYW OTHERS
%fallback NR_KEYW OVERWRITE
%fallback NR_KEYW PACK_KEYS
%fallback NR_KEYW PARSER
%fallback NR_KEYW PARTIAL
%fallback NR_KEYW PARTITIONING
%fallback NR_KEYW PARTITIONS
%fallback NR_KEYW PASSWORD
%fallback NR_KEYW PATH
%fallback NR_KEYW PERSIST
%fallback NR_KEYW PERSIST_ONLY
%fallback NR_KEYW PLAN
%fallback NR_KEYW PRECEDING
%fallback NR_KEYW PREPARE
%fallback NR_KEYW PRIVILEGE_CHECKS_USER
%fallback NR_KEYW PRIVILEGES
%fallback NR_KEYW PROCESS
%fallback NR_KEYW PS_CURRENT_THREAD_ID
%fallback NR_KEYW PS_THREAD_ID
%fallback NR_KEYW PLUGINS
%fallback NR_KEYW POINT
%fallback NR_KEYW POLYGON
%fallback NR_KEYW POSITION
%fallback NR_KEYW PROCEDURE
%fallback NR_KEYW PROCESSLIST
%fallback NR_KEYW PURGE
%fallback NR_KEYW QUERIES
%fallback NR_KEYW QUERY
%fallback NR_KEYW RANDOM
%fallback NR_KEYW RATIO
%fallback NR_KEYW REAL
%fallback NR_KEYW REBUILD
%fallback NR_KEYW REDUNDANT
%fallback NR_KEYW REFERENCE
%fallback NR_KEYW REFERENCES
%fallback NR_KEYW REGEXP_INSTR
%fallback NR_KEYW REGEXP_LIKE
%fallback NR_KEYW REGEXP_REPLACE
%fallback NR_KEYW REGEXP_SUBSTR
%fallback NR_KEYW RELAY
%fallback NR_KEYW RELEASE_ALL_LOCKS
%fallback NR_KEYW RELEASE_LOCK
%fallback NR_KEYW REMOVE
%fallback NR_KEYW REORGANIZE
%fallback NR_KEYW REPAIR
%fallback NR_KEYW REPEATABLE
%fallback NR_KEYW RESTRICT
%fallback NR_KEYW REQUIRE_ROW_FORMAT
%fallback NR_KEYW RESOURCE
%fallback NR_KEYW RESPECT
%fallback NR_KEYW RESTART
%fallback NR_KEYW RETAIN
%fallback NR_KEYW RETRY
%fallback NR_KEYW RETURNING
%fallback NR_KEYW REUSE
%fallback NR_KEYW ROLE
%fallback NR_KEYW ROLLBACK
%fallback NR_KEYW ROW_FORMAT
%fallback NR_KEYW RTRIM
%fallback NR_KEYW S3
%fallback NR_KEYW SECONDARY
%fallback NR_KEYW SECONDARY_ENGINE
%fallback NR_KEYW SECONDARY_ENGINE_ATTRIBUTE
%fallback NR_KEYW SECONDARY_LOAD
%fallback NR_KEYW SECONDARY_UNLOAD
%fallback NR_KEYW SECURITY
%fallback NR_KEYW SEQUENCE
%fallback NR_KEYW SESSION
%fallback NR_KEYW SERIALIZABLE
%fallback NR_KEYW SHARE
%fallback NR_KEYW SHARED
%fallback NR_KEYW SIGNED
%fallback NR_KEYW SIMPLE
%fallback NR_KEYW SKIP
%fallback NR_KEYW SLOW
%fallback NR_KEYW SMALLINT
%fallback NR_KEYW SNAPSHOT
%fallback NR_KEYW SQL
%fallback NR_KEYW SQL_TSI_DAY
%fallback NR_KEYW SQL_TSI_HOUR
%fallback NR_KEYW SQL_TSI_MINUTE
%fallback NR_KEYW SQL_TSI_MONTH
%fallback NR_KEYW SQL_TSI_QUARTER
%fallback NR_KEYW SQL_TSI_SECOND
%fallback NR_KEYW SQL_TSI_WEEK
%fallback NR_KEYW SQL_TSI_YEAR
%fallback NR_KEYW SRID
%fallback NR_KEYW START
%fallback NR_KEYW STARTING
%fallback NR_KEYW STATS_AUTO_RECALC
%fallback NR_KEYW STATS_PERSISTENT
%fallback NR_KEYW STATS_SAMPLE_PAGES
%fallback NR_KEYW STATUS
%fallback NR_KEYW STORAGE
%fallback NR_KEYW STD
%fallback NR_KEYW STDDEV
%fallback NR_KEYW STDDEV_POP
%fallback NR_KEYW STDDEV_SAMP
%fallback NR_KEYW STREAM
%fallback NR_KEYW ST_Area
%fallback NR_KEYW ST_AsBinary
%fallback NR_KEYW ST_AsGeoJSON
%fallback NR_KEYW ST_AsText
%fallback NR_KEYW ST_Centroid
%fallback NR_KEYW ST_Dimension
%fallback NR_KEYW ST_EndPoint
%fallback NR_KEYW ST_Envelope
%fallback NR_KEYW ST_ExteriorRing
%fallback NR_KEYW ST_GeoHash
%fallback NR_KEYW ST_GeomFromGeoJSON
%fallback NR_KEYW ST_GeometryCollectionFromText
%fallback NR_KEYW ST_GeometryCollectionFromWKB
%fallback NR_KEYW ST_GeometryFromText
%fallback NR_KEYW ST_GeometryFromWKB
%fallback NR_KEYW ST_GeometryN
%fallback NR_KEYW ST_GeometryType
%fallback NR_KEYW ST_InteriorRingN
%fallback NR_KEYW ST_IsClosed
%fallback NR_KEYW ST_IsEmpty
%fallback NR_KEYW ST_IsSimple
%fallback NR_KEYW ST_LatFromGeoHash
%fallback NR_KEYW ST_Latitude
%fallback NR_KEYW ST_Length
%fallback NR_KEYW ST_LineStringFromText
%fallback NR_KEYW ST_LineStringFromWKB
%fallback NR_KEYW ST_LongFromGeoHash
%fallback NR_KEYW ST_Longitude
%fallback NR_KEYW ST_MultiLineStringFromText
%fallback NR_KEYW ST_MultiLineStringFromWKB
%fallback NR_KEYW ST_MultiPointFromText
%fallback NR_KEYW ST_MultiPointFromWKB
%fallback NR_KEYW ST_MultiPolygonFromText
%fallback NR_KEYW ST_MultiPolygonFromWKB
%fallback NR_KEYW ST_NumGeometries
%fallback NR_KEYW ST_NumInteriorRings
%fallback NR_KEYW ST_NumPoints
%fallback NR_KEYW ST_PointFromGeoHash
%fallback NR_KEYW ST_PointFromText
%fallback NR_KEYW ST_PointFromWKB
%fallback NR_KEYW ST_PointN
%fallback NR_KEYW ST_PolygonFromText
%fallback NR_KEYW ST_PolygonFromWKB
%fallback NR_KEYW ST_StartPoint
%fallback NR_KEYW ST_X
%fallback NR_KEYW ST_Y
%fallback NR_KEYW SUBDATE
%fallback NR_KEYW SUBPARTITION
%fallback NR_KEYW SUBPARTITIONS
%fallback NR_KEYW SUM
%fallback NR_KEYW TABLES
%fallback NR_KEYW TABLESPACE
%fallback NR_KEYW TEMPORARY
%fallback NR_KEYW TEMPTABLE
%fallback NR_KEYW TERMINATED
%fallback NR_KEYW TEXT
%fallback NR_KEYW THAN
%fallback NR_KEYW THREAD_PRIORITY
%fallback NR_KEYW THROTTLE
%fallback NR_KEYW TIES
%fallback NR_KEYW TIME
%fallback NR_KEYW TIMESTAMP
%fallback NR_KEYW TIMESTAMPADD
%fallback NR_KEYW TIMESTAMPDIFF
%fallback NR_KEYW TINYBLOB
%fallback NR_KEYW TINYINT
%fallback NR_KEYW TINYTEXT
%fallback NR_KEYW TRADITIONAL
%fallback NR_KEYW TRANSACTION
%fallback NR_KEYW TREE
%fallback NR_KEYW TRIGGER
%fallback NR_KEYW TRIGGERS
%fallback NR_KEYW TRIM
%fallback NR_KEYW TRUNCATE
%fallback NR_KEYW UNBOUNDED
%fallback NR_KEYW UNCOMMITTED
%fallback NR_KEYW UNDEFINED
%fallback NR_KEYW UNICODE
%fallback NR_KEYW UNSIGNED
%fallback NR_KEYW UNTHROTTLE
///%fallback NR_KEYW UNUSED
%fallback NR_KEYW UpdateXML
%fallback NR_KEYW UPGRADE
%fallback NR_KEYW USER
%fallback NR_KEYW USER_RESOURCES
%fallback NR_KEYW VALIDATION
%fallback NR_KEYW VAR_POP
%fallback NR_KEYW VAR_SAMP
%fallback NR_KEYW VARBINARY
%fallback NR_KEYW VARCHAR
%fallback NR_KEYW VARIABLES
%fallback NR_KEYW VARIANCE
%fallback NR_KEYW VCPU
%fallback NR_KEYW VEXPLAIN
%fallback NR_KEYW VGTID_EXECUTED
%fallback NR_KEYW VIEW
%fallback NR_KEYW VINDEX
%fallback NR_KEYW VINDEXES
%fallback NR_KEYW VISIBLE
%fallback NR_KEYW VITESS
%fallback NR_KEYW VITESS_KEYSPACES
%fallback NR_KEYW VITESS_METADATA
%fallback NR_KEYW VITESS_MIGRATION
%fallback NR_KEYW VITESS_MIGRATIONS
%fallback NR_KEYW VITESS_REPLICATION_STATUS
%fallback NR_KEYW VITESS_SHARDS
%fallback NR_KEYW VITESS_TABLETS
%fallback NR_KEYW VITESS_TARGET
%fallback NR_KEYW VITESS_THROTTLED_APPS
%fallback NR_KEYW VITESS_THROTTLER
%fallback NR_KEYW VSCHEMA
%fallback NR_KEYW VTEXPLAIN
%fallback NR_KEYW WAIT_FOR_EXECUTED_GTID_SET
%fallback NR_KEYW WAIT_UNTIL_SQL_THREAD_AFTER_GTIDS
%fallback NR_KEYW WARNINGS
%fallback NR_KEYW WEEK
%fallback NR_KEYW WITHOUT
%fallback NR_KEYW WORK
%fallback NR_KEYW YEAR
%fallback NR_KEYW ZEROFILL
%fallback NR_KEYW DAY
%fallback NR_KEYW DAY_HOUR
%fallback NR_KEYW DAY_MICROSECOND
%fallback NR_KEYW DAY_MINUTE
%fallback NR_KEYW DAY_SECOND
%fallback NR_KEYW HOUR
%fallback NR_KEYW HOUR_MICROSECOND
%fallback NR_KEYW HOUR_MINUTE
%fallback NR_KEYW HOUR_SECOND
%fallback NR_KEYW MICROSECOND
%fallback NR_KEYW MINUTE
%fallback NR_KEYW MINUTE_MICROSECOND
%fallback NR_KEYW MINUTE_SECOND
%fallback NR_KEYW MONTH
%fallback NR_KEYW QUARTER
%fallback NR_KEYW SECOND
%fallback NR_KEYW SECOND_MICROSECOND
%fallback NR_KEYW YEAR_MONTH
%fallback NR_KEYW WEIGHT_STRING

%nonassoc /*1*/ MEMBER
///%nonassoc /*2*/ FUNCTION_CALL_NON_KEYWORD
///%nonassoc /*3*/ STRING_TYPE_PREFIX_NON_KEYWORD
%left /*4*/ UNION
%left /*5*/ JOIN STRAIGHT_JOIN LEFT RIGHT INNER OUTER CROSS NATURAL USE FORCE
%left /*6*/ ON USING INPLACE COPY INSTANT ALGORITHM NONE SHARED EXCLUSIVE
%left /*7*/ SUBQUERY_AS_EXPR
%left /*8*/ '(' ',' ')'
%nonassoc /*9*/ STRING
%left /*10*/ EMPTY_FROM_CLAUSE
%right /*11*/ INTO
%nonassoc /*12*/ LOWER_THAN_CHARSET
%nonassoc /*13*/ CHARSET
%right /*14*/ UNIQUE KEY
%left /*15*/ EXPRESSION_PREC_SETTER
%left /*16*/ OR '|'
%left /*17*/ XOR
%left /*18*/ AND
%right /*19*/ NOT '!'
%left /*20*/ BETWEEN CASE WHEN THEN ELSE END
%left /*21*/ '=' '<' '>' LE GE NE NULL_SAFE_EQUAL IS LIKE REGEXP RLIKE IN ASSIGNMENT_OPT
%left /*22*/ '&'
%left /*23*/ SHIFT_LEFT SHIFT_RIGHT
%left /*24*/ '+' '-'
%left /*25*/ '*' '/' DIV '%' MOD
%left /*26*/ '^'
%right /*27*/ '~' UNARY
%left /*28*/ COLLATE
%right /*29*/ BINARY UNDERSCORE_ARMSCII8 UNDERSCORE_ASCII UNDERSCORE_BIG5 UNDERSCORE_BINARY UNDERSCORE_CP1250 UNDERSCORE_CP1251
%right /*30*/ UNDERSCORE_CP1256 UNDERSCORE_CP1257 UNDERSCORE_CP850 UNDERSCORE_CP852 UNDERSCORE_CP866 UNDERSCORE_CP932
%right /*31*/ UNDERSCORE_DEC8 UNDERSCORE_EUCJPMS UNDERSCORE_EUCKR UNDERSCORE_GB18030 UNDERSCORE_GB2312 UNDERSCORE_GBK UNDERSCORE_GEOSTD8
%right /*32*/ UNDERSCORE_GREEK UNDERSCORE_HEBREW UNDERSCORE_HP8 UNDERSCORE_KEYBCS2 UNDERSCORE_KOI8R UNDERSCORE_KOI8U UNDERSCORE_LATIN1 UNDERSCORE_LATIN2 UNDERSCORE_LATIN5
%right /*33*/ UNDERSCORE_LATIN7 UNDERSCORE_MACCE UNDERSCORE_MACROMAN UNDERSCORE_SJIS UNDERSCORE_SWE7 UNDERSCORE_TIS620 UNDERSCORE_UCS2 UNDERSCORE_UJIS UNDERSCORE_UTF16
%right /*34*/ UNDERSCORE_UTF16LE UNDERSCORE_UTF32 UNDERSCORE_UTF8 UNDERSCORE_UTF8MB4 UNDERSCORE_UTF8MB3
%right /*35*/ INTERVAL
%nonassoc /*36*/ '.'
%left /*37*/ WINDOW_EXPR

%start command_list

%%

command_list :
    any_command
    | command_list any_command
    ;

any_command :
	comment_opt command semicolon_opt
	;

semicolon_opt :
	/*empty*/
	| ';'
	;

command :
	select_statement
	| stream_statement
	| vstream_statement
	| insert_statement
	| update_statement
	| delete_statement
	| set_statement
	| set_transaction_statement
	| create_statement
	| alter_statement
	| rename_statement
	| drop_statement
	| truncate_statement
	| analyze_statement
	| purge_statement
	| show_statement
	| use_statement
	| begin_statement
	| commit_statement
	| rollback_statement
	| savepoint_statement
	| release_statement
	| explain_statement
	| vexplain_statement
	| other_statement
	| flush_statement
	| do_statement
	| load_statement
	| lock_statement
	| unlock_statement
	| call_statement
	| revert_statement
	| prepare_statement
	| execute_statement
	| deallocate_statement
	| kill_statement
	| /*empty*/
	;

user_defined_variable :
	AT_ID
	;

ci_identifier :
	ID
	;

ci_identifier_opt :
	/*empty*/
	| ci_identifier
	;

variable_expr :
	AT_ID
	| AT_AT_ID
	;

do_statement :
	DO expression_list
	;

load_statement :
	LOAD DATA skip_to_end
	;

with_clause :
	WITH with_list
	| WITH RECURSIVE with_list
	;

with_clause_opt :
	/*empty*/
	| with_clause
	;

with_list :
	with_list ',' /*8L*/ common_table_expr
	| common_table_expr
	;

common_table_expr :
	table_id column_list_opt AS subquery
	;

query_expression_parens :
	openb query_expression_parens closeb
	| openb query_expression closeb
	| openb query_expression locking_clause closeb
	;

query_expression :
	query_expression_body order_by_opt limit_opt
	| query_expression_parens limit_clause
	| query_expression_parens order_by_clause limit_opt
	| with_clause query_expression_body order_by_opt limit_opt
	| with_clause query_expression_parens limit_clause
	| with_clause query_expression_parens order_by_clause limit_opt
	| with_clause query_expression_parens
	| SELECT comment_opt cache_opt NEXT num_val for_from table_name
	;

query_expression_body :
	query_primary
	| query_expression_body union_op query_primary
	| query_expression_parens union_op query_primary
	| query_expression_body union_op query_expression_parens
	| query_expression_parens union_op query_expression_parens
	;

select_statement :
	query_expression
	| query_expression locking_clause
	| query_expression_parens
	| select_stmt_with_into
	;

select_stmt_with_into :
	openb select_stmt_with_into closeb
	| query_expression into_clause
	| query_expression into_clause locking_clause
	| query_expression locking_clause into_clause
	| query_expression_parens into_clause
	;

stream_statement :
	STREAM comment_opt select_expression FROM table_name
	;

vstream_statement :
	VSTREAM comment_opt select_expression FROM table_name where_expression_opt limit_opt
	;

query_primary :
	SELECT comment_opt select_options select_expression_list into_clause from_opt where_expression_opt group_by_opt having_opt named_windows_list_opt
	| SELECT comment_opt select_options select_expression_list from_opt where_expression_opt group_by_opt having_opt named_windows_list_opt
	;

insert_statement :
	insert_or_replace comment_opt ignore_opt into_table_name opt_partition_clause insert_data on_dup_opt
	| insert_or_replace comment_opt ignore_opt into_table_name opt_partition_clause SET update_list on_dup_opt
	;

insert_or_replace :
	INSERT
	| REPLACE
	;

update_statement :
	with_clause_opt UPDATE comment_opt ignore_opt table_references SET update_list where_expression_opt order_by_opt limit_opt
	;

delete_statement :
	with_clause_opt DELETE comment_opt ignore_opt FROM table_name as_opt_id opt_partition_clause where_expression_opt order_by_opt limit_opt
	| with_clause_opt DELETE comment_opt ignore_opt FROM table_name_list USING /*6L*/ table_references where_expression_opt
	| with_clause_opt DELETE comment_opt ignore_opt table_name_list from_or_using table_references where_expression_opt
	| with_clause_opt DELETE comment_opt ignore_opt delete_table_list from_or_using table_references where_expression_opt
	;

from_or_using :
	FROM
	| USING /*6L*/
	;

view_name_list :
	table_name
	| view_name_list ',' /*8L*/ table_name
	;

table_name_list :
	table_name
	| table_name_list ',' /*8L*/ table_name
	;

delete_table_list :
	delete_table_name
	| delete_table_list ',' /*8L*/ delete_table_name
	;

opt_partition_clause :
	/*empty*/
	| PARTITION openb partition_list closeb
	;

set_statement :
	SET comment_opt set_list
	;

set_list :
	set_expression
	| set_list ',' /*8L*/ set_expression
	;

set_expression :
	set_variable '=' /*21L*/ ON /*6L*/
	| set_variable '=' /*21L*/ OFF
	| set_variable '=' /*21L*/ expression
	| charset_or_character_set_or_names charset_value collate_opt
	;

set_variable :
	ID
	| variable_expr
	| set_session_or_global ID
	;

set_transaction_statement :
	SET comment_opt set_session_or_global TRANSACTION transaction_chars
	| SET comment_opt TRANSACTION transaction_chars
	;

transaction_chars :
	transaction_char
	| transaction_chars ',' /*8L*/ transaction_char
	;

transaction_char :
	ISOLATION LEVEL isolation_level
	| READ WRITE
	| READ ONLY
	;

isolation_level :
	REPEATABLE READ
	| READ COMMITTED
	| READ UNCOMMITTED
	| SERIALIZABLE
	;

set_session_or_global :
	SESSION
	| LOCAL
	| GLOBAL
	;

create_statement :
	create_table_prefix table_spec
	| create_table_prefix create_like
	| create_index_prefix '(' /*8L*/ index_column_list ')' /*8L*/ index_option_list_opt algorithm_lock_opt
	| CREATE comment_opt replace_opt algorithm_view definer_opt security_view_opt VIEW table_name column_list_opt AS select_statement check_option_opt
	| create_database_prefix create_options_opt
	;

replace_opt :
	/*empty*/
	| OR /*16L*/ REPLACE
	;

vindex_type_opt :
	/*empty*/
	| USING /*6L*/ vindex_type
	;

vindex_type :
	sql_id
	;

vindex_params_opt :
	/*empty*/
	| WITH vindex_param_list
	;

vindex_param_list :
	vindex_param
	| vindex_param_list ',' /*8L*/ vindex_param
	;

vindex_param :
	reserved_sql_id '=' /*21L*/ table_opt_value
	;

json_object_param_opt :
	/*empty*/
	| json_object_param_list
	;

json_object_param_list :
	json_object_param
	| json_object_param_list ',' /*8L*/ json_object_param
	;

json_object_param :
	expression ',' /*8L*/ expression
	;

create_table_prefix :
	CREATE comment_opt temp_opt TABLE not_exists_opt table_name
	;

alter_table_prefix :
	ALTER comment_opt TABLE table_name
	;

create_index_prefix :
	CREATE comment_opt INDEX ci_identifier using_opt ON /*6L*/ table_name
	| CREATE comment_opt FULLTEXT INDEX ci_identifier using_opt ON /*6L*/ table_name
	| CREATE comment_opt SPATIAL INDEX ci_identifier using_opt ON /*6L*/ table_name
	| CREATE comment_opt UNIQUE /*14R*/ INDEX ci_identifier using_opt ON /*6L*/ table_name
	;

create_database_prefix :
	CREATE comment_opt database_or_schema comment_opt not_exists_opt table_id
	;

alter_database_prefix :
	ALTER comment_opt database_or_schema
	;

database_or_schema :
	DATABASE
	| SCHEMA
	;

table_spec :
	'(' /*8L*/ table_column_list ')' /*8L*/ table_option_list_opt partitions_options_opt
	;

create_options_opt :
	/*empty*/
	| create_options
	;

create_options :
	character_set
	| collate
	| encryption
	| create_options collate
	| create_options character_set
	| create_options encryption
	;

default_optional :
	%prec LOWER_THAN_CHARSET /*12N*/ /*empty*/
	| DEFAULT
	;

character_set :
	default_optional charset_or_character_set equal_opt ID
	| default_optional charset_or_character_set equal_opt STRING /*9N*/
	;

collate :
	default_optional COLLATE /*28L*/ equal_opt ID
	| default_optional COLLATE /*28L*/ equal_opt STRING /*9N*/
	;

encryption :
	default_optional ENCRYPTION equal_opt ID
	| default_optional ENCRYPTION equal_opt STRING /*9N*/
	;

create_like :
	LIKE /*21L*/ table_name
	| '(' /*8L*/ LIKE /*21L*/ table_name ')' /*8L*/
	;

column_definition_list :
	column_definition
	| column_definition_list ',' /*8L*/ column_definition
	;

table_column_list :
	column_definition
	| check_constraint_definition
	| table_column_list ',' /*8L*/ column_definition
	| table_column_list ',' /*8L*/ column_definition check_constraint_definition
	| table_column_list ',' /*8L*/ index_definition
	| table_column_list ',' /*8L*/ constraint_definition
	| table_column_list ',' /*8L*/ check_constraint_definition
	;

column_definition :
	sql_id column_type collate_opt column_attribute_list_opt reference_definition_opt
	| sql_id column_type collate_opt generated_always_opt AS '(' /*8L*/ expression ')' /*8L*/ generated_column_attribute_list_opt reference_definition_opt
	;

generated_always_opt :
	/*empty*/
	| GENERATED ALWAYS
	;

column_attribute_list_opt :
	/*empty*/
	| column_attribute_list_opt NULL
	| column_attribute_list_opt NOT /*19R*/ NULL
	| column_attribute_list_opt DEFAULT openb expression closeb
	| column_attribute_list_opt DEFAULT now_or_signed_literal
	| column_attribute_list_opt ON /*6L*/ UPDATE function_call_nonkeyword
	| column_attribute_list_opt AUTO_INCREMENT
	| column_attribute_list_opt COMMENT_KEYWORD STRING /*9N*/
	| column_attribute_list_opt keys
	| column_attribute_list_opt COLLATE /*28L*/ STRING /*9N*/
	| column_attribute_list_opt COLLATE /*28L*/ ci_identifier
	| column_attribute_list_opt COLUMN_FORMAT column_format
	| column_attribute_list_opt SRID INTEGRAL
	| column_attribute_list_opt VISIBLE
	| column_attribute_list_opt INVISIBLE
	| column_attribute_list_opt ENGINE_ATTRIBUTE equal_opt STRING /*9N*/
	| column_attribute_list_opt SECONDARY_ENGINE_ATTRIBUTE equal_opt STRING /*9N*/
	;

column_format :
	FIXED
	| DYNAMIC
	| DEFAULT
	;

column_storage :
	VIRTUAL
	| STORED
	;

generated_column_attribute_list_opt :
	/*empty*/
	| generated_column_attribute_list_opt column_storage
	| generated_column_attribute_list_opt NULL
	| generated_column_attribute_list_opt NOT /*19R*/ NULL
	| generated_column_attribute_list_opt COMMENT_KEYWORD STRING /*9N*/
	| generated_column_attribute_list_opt keys
	| generated_column_attribute_list_opt VISIBLE
	| generated_column_attribute_list_opt INVISIBLE
	;

now_or_signed_literal :
	now
	| signed_literal_or_null
	;

now :
	CURRENT_TIMESTAMP func_datetime_precision
	| LOCALTIME func_datetime_precision
	| LOCALTIMESTAMP func_datetime_precision
	| UTC_TIMESTAMP func_datetime_precision
	| NOW func_datetime_precision
	| SYSDATE func_datetime_precision
	;

signed_literal_or_null :
	signed_literal
	| null_as_literal
	;

null_as_literal :
	NULL
	;

signed_literal :
	literal
	| '+' /*24L*/ NUM_literal
	| '-' /*24L*/ NUM_literal
	;

literal :
	text_literal
	| NUM_literal
	| boolean_value
	| HEX
	| HEXNUM
	| BITNUM
	| BIT_LITERAL
	| VALUE_ARG
	| underscore_charsets BIT_LITERAL %prec UNARY /*27R*/
	| underscore_charsets HEXNUM %prec UNARY /*27R*/
	| underscore_charsets BITNUM %prec UNARY /*27R*/
	| underscore_charsets HEX %prec UNARY /*27R*/
	| underscore_charsets column_name_or_offset %prec UNARY /*27R*/
	| underscore_charsets VALUE_ARG %prec UNARY /*27R*/
	| DATE STRING /*9N*/
	| TIME STRING /*9N*/
	| TIMESTAMP STRING /*9N*/
	;

underscore_charsets :
	UNDERSCORE_ARMSCII8 /*29R*/
	| UNDERSCORE_ASCII /*29R*/
	| UNDERSCORE_BIG5 /*29R*/
	| UNDERSCORE_BINARY /*29R*/
	| UNDERSCORE_CP1250 /*29R*/
	| UNDERSCORE_CP1251 /*29R*/
	| UNDERSCORE_CP1256 /*30R*/
	| UNDERSCORE_CP1257 /*30R*/
	| UNDERSCORE_CP850 /*30R*/
	| UNDERSCORE_CP852 /*30R*/
	| UNDERSCORE_CP866 /*30R*/
	| UNDERSCORE_CP932 /*30R*/
	| UNDERSCORE_DEC8 /*31R*/
	| UNDERSCORE_EUCJPMS /*31R*/
	| UNDERSCORE_EUCKR /*31R*/
	| UNDERSCORE_GB18030 /*31R*/
	| UNDERSCORE_GB2312 /*31R*/
	| UNDERSCORE_GBK /*31R*/
	| UNDERSCORE_GEOSTD8 /*31R*/
	| UNDERSCORE_GREEK /*32R*/
	| UNDERSCORE_HEBREW /*32R*/
	| UNDERSCORE_HP8 /*32R*/
	| UNDERSCORE_KEYBCS2 /*32R*/
	| UNDERSCORE_KOI8R /*32R*/
	| UNDERSCORE_KOI8U /*32R*/
	| UNDERSCORE_LATIN1 /*32R*/
	| UNDERSCORE_LATIN2 /*32R*/
	| UNDERSCORE_LATIN5 /*32R*/
	| UNDERSCORE_LATIN7 /*33R*/
	| UNDERSCORE_MACCE /*33R*/
	| UNDERSCORE_MACROMAN /*33R*/
	| UNDERSCORE_SJIS /*33R*/
	| UNDERSCORE_SWE7 /*33R*/
	| UNDERSCORE_TIS620 /*33R*/
	| UNDERSCORE_UCS2 /*33R*/
	| UNDERSCORE_UJIS /*33R*/
	| UNDERSCORE_UTF16 /*33R*/
	| UNDERSCORE_UTF16LE /*34R*/
	| UNDERSCORE_UTF32 /*34R*/
	| UNDERSCORE_UTF8 /*34R*/
	| UNDERSCORE_UTF8MB4 /*34R*/
	| UNDERSCORE_UTF8MB3 /*34R*/
	;

literal_or_null :
	literal
	| null_as_literal
	;

NUM_literal :
	INTEGRAL
	| FLOAT
	| DECIMAL
	;

text_literal :
	STRING /*9N*/
	| NCHAR_STRING
	| underscore_charsets STRING /*9N*/ %prec UNARY /*27R*/
	;

text_literal_or_arg :
	text_literal
	| VALUE_ARG
	;

keys :
	PRIMARY KEY /*14R*/
	| UNIQUE /*14R*/
	| UNIQUE /*14R*/ KEY /*14R*/
	| KEY /*14R*/
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
	| TINYINT
	| SMALLINT
	| MEDIUMINT
	| INT
	| INTEGER
	| BIGINT
	;

decimal_type :
	REAL double_length_opt
	| DOUBLE double_length_opt
	| FLOAT8_TYPE double_length_opt
	| FLOAT_TYPE float_length_opt
	| FLOAT4_TYPE float_length_opt
	| DECIMAL_TYPE decimal_length_opt
	| NUMERIC decimal_length_opt
	;

time_type :
	DATE
	| TIME length_opt
	| TIMESTAMP length_opt
	| DATETIME length_opt
	| YEAR length_opt
	;

char_type :
	CHAR length_opt charset_opt
	| CHAR length_opt BYTE
	| VARCHAR length_opt charset_opt
	| BINARY /*29R*/ length_opt
	| VARBINARY length_opt
	| TEXT charset_opt
	| TINYTEXT charset_opt
	| MEDIUMTEXT charset_opt
	| LONGTEXT charset_opt
	| BLOB
	| TINYBLOB
	| MEDIUMBLOB
	| LONGBLOB
	| JSON
	| ENUM '(' /*8L*/ enum_values ')' /*8L*/ charset_opt
	| SET '(' /*8L*/ enum_values ')' /*8L*/ charset_opt
	;

spatial_type :
	GEOMETRY
	| POINT
	| LINESTRING
	| POLYGON
	| GEOMETRYCOLLECTION
	| MULTIPOINT
	| MULTILINESTRING
	| MULTIPOLYGON
	;

enum_values :
	STRING /*9N*/
	| enum_values ',' /*8L*/ STRING /*9N*/
	;

length_opt :
	/*empty*/
	| '(' /*8L*/ INTEGRAL ')' /*8L*/
	;

double_length_opt :
	/*empty*/
	| '(' /*8L*/ INTEGRAL ',' /*8L*/ INTEGRAL ')' /*8L*/
	;

float_length_opt :
	double_length_opt
	| '(' /*8L*/ INTEGRAL ')' /*8L*/
	;

decimal_length_opt :
	/*empty*/
	| '(' /*8L*/ INTEGRAL ')' /*8L*/
	| '(' /*8L*/ INTEGRAL ',' /*8L*/ INTEGRAL ')' /*8L*/
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

charset_opt :
	/*empty*/
	| charset_or_character_set sql_id binary_opt
	| charset_or_character_set STRING /*9N*/ binary_opt
	| charset_or_character_set BINARY /*29R*/
	| ASCII binary_opt
	| UNICODE binary_opt
	| BINARY /*29R*/
	| BINARY /*29R*/ ASCII
	| BINARY /*29R*/ UNICODE
	;

binary_opt :
	/*empty*/
	| BINARY /*29R*/
	;

collate_opt :
	/*empty*/
	| COLLATE /*28L*/ ci_identifier
	| COLLATE /*28L*/ STRING /*9N*/
	;

index_definition :
	index_info '(' /*8L*/ index_column_list ')' /*8L*/ index_option_list_opt
	;

index_option_list_opt :
	/*empty*/
	| index_option_list
	;

index_option_list :
	index_option
	| index_option_list index_option
	;

index_option :
	using_index_type
	| KEY_BLOCK_SIZE equal_opt INTEGRAL
	| COMMENT_KEYWORD STRING /*9N*/
	| VISIBLE
	| INVISIBLE
	| WITH PARSER ci_identifier
	| ENGINE_ATTRIBUTE equal_opt STRING /*9N*/
	| SECONDARY_ENGINE_ATTRIBUTE equal_opt STRING /*9N*/
	;

equal_opt :
	/*empty*/
	| '=' /*21L*/
	;

index_info :
	constraint_name_opt PRIMARY KEY /*14R*/ name_opt
	| SPATIAL index_or_key_opt name_opt
	| FULLTEXT index_or_key_opt name_opt
	| constraint_name_opt UNIQUE /*14R*/ index_or_key_opt name_opt
	| index_or_key name_opt
	;

constraint_name_opt :
	/*empty*/
	| CONSTRAINT name_opt
	;

index_symbols :
	INDEX
	| KEYS
	| INDEXES
	;

from_or_in :
	FROM
	| IN /*21L*/
	;

index_or_key_opt :
	/*empty*/
	| index_or_key
	;

index_or_key :
	INDEX
	| KEY /*14R*/
	;

name_opt :
	/*empty*/
	| ci_identifier
	;

index_column_list :
	index_column
	| index_column_list ',' /*8L*/ index_column
	;

index_column :
	sql_id length_opt asc_desc_opt
	| openb expression closeb asc_desc_opt
	;

constraint_definition :
	CONSTRAINT ci_identifier_opt constraint_info
	| constraint_info
	;

check_constraint_definition :
	CONSTRAINT ci_identifier_opt check_constraint_info
	| check_constraint_info
	;

constraint_info :
	FOREIGN KEY /*14R*/ name_opt '(' /*8L*/ column_list ')' /*8L*/ reference_definition
	;

reference_definition :
	REFERENCES table_name '(' /*8L*/ column_list ')' /*8L*/ fk_match_opt
	| REFERENCES table_name '(' /*8L*/ column_list ')' /*8L*/ fk_match_opt fk_on_delete
	| REFERENCES table_name '(' /*8L*/ column_list ')' /*8L*/ fk_match_opt fk_on_update
	| REFERENCES table_name '(' /*8L*/ column_list ')' /*8L*/ fk_match_opt fk_on_delete fk_on_update
	| REFERENCES table_name '(' /*8L*/ column_list ')' /*8L*/ fk_match_opt fk_on_update fk_on_delete
	;

reference_definition_opt :
	/*empty*/
	| reference_definition
	;

check_constraint_info :
	CHECK '(' /*8L*/ expression ')' /*8L*/ enforced_opt
	;

fk_match :
	MATCH fk_match_action
	;

fk_match_action :
	FULL
	| PARTIAL
	| SIMPLE
	;

fk_match_opt :
	/*empty*/
	| fk_match
	;

fk_on_delete :
	ON /*6L*/ DELETE fk_reference_action
	;

fk_on_update :
	ON /*6L*/ UPDATE fk_reference_action
	;

fk_reference_action :
	RESTRICT
	| CASCADE
	| NO ACTION
	| SET DEFAULT
	| SET NULL
	;

restrict_or_cascade_opt :
	/*empty*/
	| RESTRICT
	| CASCADE
	;

enforced :
	ENFORCED
	| NOT /*19R*/ ENFORCED
	;

enforced_opt :
	/*empty*/
	| enforced
	;

table_option_list_opt :
	/*empty*/
	| table_option_list
	;

table_option_list :
	table_option
	| table_option_list ',' /*8L*/ table_option
	| table_option_list table_option
	;

space_separated_table_option_list :
	table_option
	| space_separated_table_option_list table_option
	;

table_option :
	AUTO_INCREMENT equal_opt INTEGRAL
	| AUTOEXTEND_SIZE equal_opt INTEGRAL
	| AVG_ROW_LENGTH equal_opt INTEGRAL
	| default_optional charset_or_character_set equal_opt charset
	| default_optional COLLATE /*28L*/ equal_opt charset
	| CHECKSUM equal_opt INTEGRAL
	| COMMENT_KEYWORD equal_opt STRING /*9N*/
	| COMPRESSION equal_opt STRING /*9N*/
	| CONNECTION equal_opt STRING /*9N*/
	| DATA DIRECTORY equal_opt STRING /*9N*/
	| INDEX DIRECTORY equal_opt STRING /*9N*/
	| DELAY_KEY_WRITE equal_opt INTEGRAL
	| ENCRYPTION equal_opt STRING /*9N*/
	| ENGINE equal_opt table_alias
	| ENGINE_ATTRIBUTE equal_opt STRING /*9N*/
	| INSERT_METHOD equal_opt insert_method_options
	| KEY_BLOCK_SIZE equal_opt INTEGRAL
	| MAX_ROWS equal_opt INTEGRAL
	| MIN_ROWS equal_opt INTEGRAL
	| PACK_KEYS equal_opt INTEGRAL
	| PACK_KEYS equal_opt DEFAULT
	| PASSWORD equal_opt STRING /*9N*/
	| ROW_FORMAT equal_opt row_format_options
	| SECONDARY_ENGINE_ATTRIBUTE equal_opt STRING /*9N*/
	| STATS_AUTO_RECALC equal_opt INTEGRAL
	| STATS_AUTO_RECALC equal_opt DEFAULT
	| STATS_PERSISTENT equal_opt INTEGRAL
	| STATS_PERSISTENT equal_opt DEFAULT
	| STATS_SAMPLE_PAGES equal_opt INTEGRAL
	| TABLESPACE equal_opt sql_id storage_opt
	| UNION /*4L*/ equal_opt '(' /*8L*/ table_name_list ')' /*8L*/
	;

storage_opt :
	/*empty*/
	| STORAGE DISK
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

insert_method_options :
	NO
	| FIRST
	| LAST
	;

table_opt_value :
	table_id '.' /*36N*/ reserved_table_id
	| reserved_sql_id
	| STRING /*9N*/
	| INTEGRAL
	;

column_opt :
	/*empty*/
	| COLUMN
	;

first_opt :
	/*empty*/
	| FIRST
	;

after_opt :
	/*empty*/
	| AFTER column_name
	;

expire_opt :
	/*empty*/
	| EXPIRE STRING /*9N*/
	;

ratio_opt :
	/*empty*/
	| RATIO INTEGRAL
	| RATIO DECIMAL
	;

alter_commands_list :
	/*empty*/
	| alter_options
	| alter_options ',' /*8L*/ ORDER BY column_list
	| alter_commands_modifier_list
	| alter_commands_modifier_list ',' /*8L*/ alter_options
	| alter_commands_modifier_list ',' /*8L*/ alter_options ',' /*8L*/ ORDER BY column_list
	;

alter_options :
	alter_option
	| alter_options ',' /*8L*/ alter_option
	| alter_options ',' /*8L*/ alter_commands_modifier
	;

alter_option :
	space_separated_table_option_list
	| ADD check_constraint_definition
	| ADD constraint_definition
	| ADD index_definition
	| ADD column_opt '(' /*8L*/ column_definition_list ')' /*8L*/
	| ADD column_opt column_definition first_opt after_opt
	| ALTER column_opt column_name DROP DEFAULT
	| ALTER column_opt column_name SET DEFAULT now_or_signed_literal
	| ALTER column_opt column_name SET DEFAULT openb expression closeb
	| ALTER column_opt column_name SET VISIBLE
	| ALTER column_opt column_name SET INVISIBLE
	| ALTER CHECK ci_identifier enforced
	| ALTER INDEX ci_identifier VISIBLE
	| ALTER INDEX ci_identifier INVISIBLE
	| CHANGE column_opt column_name column_definition first_opt after_opt
	| MODIFY column_opt column_definition first_opt after_opt
	| RENAME COLUMN column_name TO column_name
	| CONVERT TO charset_or_character_set charset collate_opt
	| DISABLE KEYS
	| ENABLE KEYS
	| DISCARD TABLESPACE
	| IMPORT TABLESPACE
	| DROP column_opt column_name
	| DROP index_or_key ci_identifier
	| DROP PRIMARY KEY /*14R*/
	| DROP FOREIGN KEY /*14R*/ ci_identifier
	| DROP CHECK ci_identifier
	| DROP CONSTRAINT ci_identifier
	| FORCE /*5L*/
	| RENAME to_opt table_name
	| RENAME index_or_key ci_identifier TO ci_identifier
	;

alter_commands_modifier_list :
	alter_commands_modifier
	| alter_commands_modifier_list ',' /*8L*/ alter_commands_modifier
	;

alter_commands_modifier :
	ALGORITHM /*6L*/ equal_opt DEFAULT
	| ALGORITHM /*6L*/ equal_opt INPLACE /*6L*/
	| ALGORITHM /*6L*/ equal_opt COPY /*6L*/
	| ALGORITHM /*6L*/ equal_opt INSTANT /*6L*/
	| LOCK equal_opt DEFAULT
	| LOCK equal_opt NONE /*6L*/
	| LOCK equal_opt SHARED /*6L*/
	| LOCK equal_opt EXCLUSIVE /*6L*/
	| WITH VALIDATION
	| WITHOUT VALIDATION
	;

alter_statement :
	alter_table_prefix alter_commands_list partitions_options_opt
	| alter_table_prefix alter_commands_list REMOVE PARTITIONING
	| alter_table_prefix alter_commands_modifier_list ',' /*8L*/ partition_operation
	| alter_table_prefix partition_operation
	| ALTER comment_opt algorithm_view definer_opt security_view_opt VIEW table_name column_list_opt AS select_statement check_option_opt
	| alter_database_prefix table_id_opt create_options
	| alter_database_prefix table_id UPGRADE DATA DIRECTORY NAME
	| ALTER comment_opt VSCHEMA CREATE VINDEX table_name vindex_type_opt vindex_params_opt
	| ALTER comment_opt VSCHEMA DROP VINDEX table_name
	| ALTER comment_opt VSCHEMA ADD TABLE table_name
	| ALTER comment_opt VSCHEMA DROP TABLE table_name
	| ALTER comment_opt VSCHEMA ON /*6L*/ table_name ADD VINDEX sql_id '(' /*8L*/ column_list ')' /*8L*/ vindex_type_opt vindex_params_opt
	| ALTER comment_opt VSCHEMA ON /*6L*/ table_name DROP VINDEX sql_id
	| ALTER comment_opt VSCHEMA ADD SEQUENCE table_name
	| ALTER comment_opt VSCHEMA ON /*6L*/ table_name ADD AUTO_INCREMENT sql_id USING /*6L*/ table_name
	| ALTER comment_opt VITESS_MIGRATION STRING /*9N*/ RETRY
	| ALTER comment_opt VITESS_MIGRATION STRING /*9N*/ CLEANUP
	| ALTER comment_opt VITESS_MIGRATION STRING /*9N*/ LAUNCH
	| ALTER comment_opt VITESS_MIGRATION STRING /*9N*/ LAUNCH VITESS_SHARDS STRING /*9N*/
	| ALTER comment_opt VITESS_MIGRATION LAUNCH ALL
	| ALTER comment_opt VITESS_MIGRATION STRING /*9N*/ COMPLETE
	| ALTER comment_opt VITESS_MIGRATION COMPLETE ALL
	| ALTER comment_opt VITESS_MIGRATION STRING /*9N*/ CANCEL
	| ALTER comment_opt VITESS_MIGRATION CANCEL ALL
	| ALTER comment_opt VITESS_MIGRATION STRING /*9N*/ THROTTLE expire_opt ratio_opt
	| ALTER comment_opt VITESS_MIGRATION THROTTLE ALL expire_opt ratio_opt
	| ALTER comment_opt VITESS_MIGRATION STRING /*9N*/ UNTHROTTLE
	| ALTER comment_opt VITESS_MIGRATION UNTHROTTLE ALL
	;

partitions_options_opt :
	/*empty*/
	| PARTITION BY partitions_options_beginning partitions_opt subpartition_opt partition_definitions_opt
	;

partitions_options_beginning :
	linear_opt HASH '(' /*8L*/ expression ')' /*8L*/
	| linear_opt KEY /*14R*/ algorithm_opt '(' /*8L*/ column_list_empty ')' /*8L*/
	| range_or_list '(' /*8L*/ expression ')' /*8L*/
	| range_or_list COLUMNS '(' /*8L*/ column_list ')' /*8L*/
	;

subpartition_opt :
	/*empty*/
	| SUBPARTITION BY linear_opt HASH '(' /*8L*/ expression ')' /*8L*/ subpartitions_opt
	| SUBPARTITION BY linear_opt KEY /*14R*/ algorithm_opt '(' /*8L*/ column_list ')' /*8L*/ subpartitions_opt
	;

partition_definitions_opt :
	/*empty*/
	| '(' /*8L*/ partition_definitions ')' /*8L*/
	;

linear_opt :
	/*empty*/
	| LINEAR
	;

algorithm_opt :
	/*empty*/
	| ALGORITHM /*6L*/ '=' /*21L*/ INTEGRAL
	;

json_table_function :
	JSON_TABLE openb expression ',' /*8L*/ text_literal_or_arg jt_columns_clause closeb as_opt_id
	;

jt_columns_clause :
	COLUMNS openb columns_list closeb
	;

columns_list :
	jt_column
	| columns_list ',' /*8L*/ jt_column
	;

jt_column :
	sql_id FOR ORDINALITY
	| sql_id column_type collate_opt jt_exists_opt PATH text_literal_or_arg
	| sql_id column_type collate_opt jt_exists_opt PATH text_literal_or_arg on_empty
	| sql_id column_type collate_opt jt_exists_opt PATH text_literal_or_arg on_error
	| sql_id column_type collate_opt jt_exists_opt PATH text_literal_or_arg on_empty on_error
	| NESTED jt_path_opt text_literal_or_arg jt_columns_clause
	;

jt_path_opt :
	/*empty*/
	| PATH
	;

jt_exists_opt :
	/*empty*/
	| EXISTS
	;

on_empty :
	json_on_response ON /*6L*/ EMPTY
	;

on_error :
	json_on_response ON /*6L*/ ERROR
	;

json_on_response :
	ERROR
	| NULL
	| DEFAULT text_literal_or_arg
	;

range_or_list :
	RANGE
	| LIST
	;

partitions_opt :
	/*empty*/
	| PARTITIONS INTEGRAL
	;

subpartitions_opt :
	/*empty*/
	| SUBPARTITIONS INTEGRAL
	;

partition_operation :
	ADD PARTITION '(' /*8L*/ partition_definition ')' /*8L*/
	| DROP PARTITION partition_list
	| REORGANIZE PARTITION partition_list INTO /*11R*/ openb partition_definitions closeb
	| DISCARD PARTITION partition_list TABLESPACE
	| DISCARD PARTITION ALL TABLESPACE
	| IMPORT PARTITION partition_list TABLESPACE
	| IMPORT PARTITION ALL TABLESPACE
	| TRUNCATE PARTITION partition_list
	| TRUNCATE PARTITION ALL
	| COALESCE PARTITION INTEGRAL
	| EXCHANGE PARTITION sql_id WITH TABLE table_name without_valid_opt
	| ANALYZE PARTITION partition_list
	| ANALYZE PARTITION ALL
	| CHECK PARTITION partition_list
	| CHECK PARTITION ALL
	| OPTIMIZE PARTITION partition_list
	| OPTIMIZE PARTITION ALL
	| REBUILD PARTITION partition_list
	| REBUILD PARTITION ALL
	| REPAIR PARTITION partition_list
	| REPAIR PARTITION ALL
	| UPGRADE PARTITIONING
	;

without_valid_opt :
	/*empty*/
	| WITH VALIDATION
	| WITHOUT VALIDATION
	;

partition_definitions :
	partition_definition
	| partition_definitions ',' /*8L*/ partition_definition
	;

partition_definition :
	partition_name partition_definition_attribute_list_opt
	;

partition_definition_attribute_list_opt :
	/*empty*/
	| partition_definition_attribute_list_opt partition_value_range
	| partition_definition_attribute_list_opt partition_comment
	| partition_definition_attribute_list_opt partition_engine
	| partition_definition_attribute_list_opt partition_data_directory
	| partition_definition_attribute_list_opt partition_index_directory
	| partition_definition_attribute_list_opt partition_max_rows
	| partition_definition_attribute_list_opt partition_min_rows
	| partition_definition_attribute_list_opt partition_tablespace_name
	| partition_definition_attribute_list_opt subpartition_definition_list_with_brackets
	;

subpartition_definition_list_with_brackets :
	openb subpartition_definition_list closeb
	;

subpartition_definition_list :
	subpartition_definition
	| subpartition_definition_list ',' /*8L*/ subpartition_definition
	;

subpartition_definition :
	SUBPARTITION sql_id subpartition_definition_attribute_list_opt
	;

subpartition_definition_attribute_list_opt :
	/*empty*/
	| subpartition_definition_attribute_list_opt partition_comment
	| subpartition_definition_attribute_list_opt partition_engine
	| subpartition_definition_attribute_list_opt partition_data_directory
	| subpartition_definition_attribute_list_opt partition_index_directory
	| subpartition_definition_attribute_list_opt partition_max_rows
	| subpartition_definition_attribute_list_opt partition_min_rows
	| subpartition_definition_attribute_list_opt partition_tablespace_name
	;

partition_value_range :
	VALUES LESS THAN row_tuple
	| VALUES LESS THAN maxvalue
	| VALUES IN /*21L*/ row_tuple
	;

partition_storage_opt :
	/*empty*/
	| STORAGE
	;

partition_engine :
	partition_storage_opt ENGINE equal_opt table_alias
	;

partition_comment :
	COMMENT_KEYWORD equal_opt STRING /*9N*/
	;

partition_data_directory :
	DATA DIRECTORY equal_opt STRING /*9N*/
	;

partition_index_directory :
	INDEX DIRECTORY equal_opt STRING /*9N*/
	;

partition_max_rows :
	MAX_ROWS equal_opt INTEGRAL
	;

partition_min_rows :
	MIN_ROWS equal_opt INTEGRAL
	;

partition_tablespace_name :
	TABLESPACE equal_opt table_alias
	;

partition_name :
	PARTITION sql_id
	;

maxvalue :
	MAXVALUE
	| openb MAXVALUE closeb
	;

rename_statement :
	RENAME TABLE rename_list
	;

rename_list :
	table_name TO table_name
	| rename_list ',' /*8L*/ table_name TO table_name
	;

drop_statement :
	DROP comment_opt temp_opt TABLE exists_opt table_name_list restrict_or_cascade_opt
	| DROP comment_opt INDEX ci_identifier ON /*6L*/ table_name algorithm_lock_opt
	| DROP comment_opt VIEW exists_opt view_name_list restrict_or_cascade_opt
	| DROP comment_opt database_or_schema exists_opt table_id
	;

truncate_statement :
	TRUNCATE TABLE table_name
	| TRUNCATE table_name
	;

analyze_statement :
	ANALYZE TABLE table_name
	;

purge_statement :
	PURGE BINARY /*29R*/ LOGS TO STRING /*9N*/
	| PURGE BINARY /*29R*/ LOGS BEFORE STRING /*9N*/
	;

show_statement :
	SHOW charset_or_character_set like_or_where_opt
	| SHOW COLLATION like_or_where_opt
	| SHOW full_opt columns_or_fields from_or_in table_name from_database_opt like_or_where_opt
	| SHOW DATABASES like_or_where_opt
	| SHOW SCHEMAS like_or_where_opt
	| SHOW KEYSPACES like_or_where_opt
	| SHOW VITESS_KEYSPACES like_or_where_opt
	| SHOW FUNCTION STATUS like_or_where_opt
	| SHOW extended_opt index_symbols from_or_in table_name from_database_opt like_or_where_opt
	| SHOW OPEN TABLES from_database_opt like_or_where_opt
	| SHOW PRIVILEGES
	| SHOW PROCEDURE STATUS like_or_where_opt
	| SHOW session_or_local_opt STATUS like_or_where_opt
	| SHOW GLOBAL STATUS like_or_where_opt
	| SHOW session_or_local_opt VARIABLES like_or_where_opt
	| SHOW GLOBAL VARIABLES like_or_where_opt
	| SHOW TABLE STATUS from_database_opt like_or_where_opt
	| SHOW full_opt TABLES from_database_opt like_or_where_opt
	| SHOW TRIGGERS from_database_opt like_or_where_opt
	| SHOW CREATE DATABASE table_name
	| SHOW CREATE EVENT table_name
	| SHOW CREATE FUNCTION table_name
	| SHOW CREATE PROCEDURE table_name
	| SHOW CREATE TABLE table_name
	| SHOW CREATE TRIGGER table_name
	| SHOW CREATE VIEW table_name
	| SHOW ENGINES
	| SHOW PLUGINS
	| SHOW GLOBAL GTID_EXECUTED from_database_opt
	| SHOW GLOBAL VGTID_EXECUTED from_database_opt
	| SHOW VITESS_METADATA VARIABLES like_opt
	| SHOW VITESS_MIGRATIONS from_database_opt like_or_where_opt
	| SHOW VITESS_MIGRATION STRING /*9N*/ LOGS
	| SHOW VITESS_THROTTLED_APPS
	| SHOW VITESS_REPLICATION_STATUS like_opt
	| SHOW VITESS_THROTTLER STATUS
	| SHOW VSCHEMA TABLES
	| SHOW VSCHEMA VINDEXES
	| SHOW VSCHEMA VINDEXES from_or_on table_name
	| SHOW WARNINGS
	| SHOW VITESS_SHARDS like_or_where_opt
	| SHOW VITESS_TABLETS like_or_where_opt
	| SHOW VITESS_TARGET
	| SHOW ci_identifier ddl_skip_to_end
	| SHOW CREATE USER ddl_skip_to_end
	| SHOW BINARY /*29R*/ ci_identifier ddl_skip_to_end
	| SHOW BINARY /*29R*/ LOGS ddl_skip_to_end
	| SHOW ENGINE ddl_skip_to_end
	| SHOW FUNCTION CODE table_name
	| SHOW PROCEDURE CODE table_name
	| SHOW full_opt PROCESSLIST from_database_opt like_or_where_opt
	| SHOW STORAGE ddl_skip_to_end
	;

extended_opt :
	/*empty*/
	| EXTENDED
	;

full_opt :
	/*empty*/
	| FULL
	;

columns_or_fields :
	COLUMNS
	| FIELDS
	;

from_database_opt :
	/*empty*/
	| FROM table_id
	| IN /*21L*/ table_id
	;

like_or_where_opt :
	/*empty*/
	| LIKE /*21L*/ STRING /*9N*/
	| WHERE expression
	;

like_opt :
	/*empty*/
	| LIKE /*21L*/ STRING /*9N*/
	;

session_or_local_opt :
	/*empty*/
	| SESSION
	| LOCAL
	;

from_or_on :
	FROM
	| ON /*6L*/
	;

use_statement :
	USE /*5L*/ use_table_name
	| USE /*5L*/
	| USE /*5L*/ use_table_name AT_ID
	;

use_table_name :
	ID
	| AT_ID
	| AT_AT_ID
	| NR_KEYW
	;

begin_statement :
	BEGIN
	| START TRANSACTION tx_chacteristics_opt
	;

tx_chacteristics_opt :
	/*empty*/
	| tx_chars
	;

tx_chars :
	tx_char
	| tx_chars ',' /*8L*/ tx_char
	;

tx_char :
	WITH CONSISTENT SNAPSHOT
	| READ WRITE
	| READ ONLY
	;

commit_statement :
	COMMIT
	;

rollback_statement :
	ROLLBACK
	| ROLLBACK work_opt TO savepoint_opt sql_id
	;

work_opt :
	/*empty*/
	| WORK
	;

savepoint_opt :
	/*empty*/
	| SAVEPOINT
	;

savepoint_statement :
	SAVEPOINT sql_id
	;

release_statement :
	RELEASE SAVEPOINT sql_id
	;

explain_format_opt :
	/*empty*/
	| FORMAT '=' /*21L*/ JSON
	| FORMAT '=' /*21L*/ TREE
	| FORMAT '=' /*21L*/ VITESS
	| FORMAT '=' /*21L*/ VTEXPLAIN
	| FORMAT '=' /*21L*/ TRADITIONAL
	| ANALYZE
	;

vexplain_type_opt :
	/*empty*/
	| PLAN
	| ALL
	| QUERIES
	;

explain_synonyms :
	EXPLAIN
	| DESCRIBE
	| DESC
	;

explainable_statement :
	select_statement
	| update_statement
	| insert_statement
	| delete_statement
	;

wild_opt :
	/*empty*/
	| sql_id
	| STRING /*9N*/
	;

explain_statement :
	explain_synonyms comment_opt table_name wild_opt
	| explain_synonyms comment_opt explain_format_opt explainable_statement
	;

vexplain_statement :
	VEXPLAIN comment_opt vexplain_type_opt explainable_statement
	;

other_statement :
	REPAIR skip_to_end
	| OPTIMIZE skip_to_end
	;

lock_statement :
	LOCK TABLES lock_table_list
	;

lock_table_list :
	lock_table
	| lock_table_list ',' /*8L*/ lock_table
	;

lock_table :
	aliased_table_name lock_type
	;

lock_type :
	READ
	| READ LOCAL
	| WRITE
	| LOW_PRIORITY WRITE
	;

unlock_statement :
	UNLOCK TABLES
	;

revert_statement :
	REVERT comment_opt VITESS_MIGRATION STRING /*9N*/
	;

flush_statement :
	FLUSH local_opt flush_option_list
	| FLUSH local_opt TABLES
	| FLUSH local_opt TABLES WITH READ LOCK
	| FLUSH local_opt TABLES table_name_list
	| FLUSH local_opt TABLES table_name_list WITH READ LOCK
	| FLUSH local_opt TABLES table_name_list FOR EXPORT
	;

flush_option_list :
	flush_option
	| flush_option_list ',' /*8L*/ flush_option
	;

flush_option :
	BINARY /*29R*/ LOGS
	| ENGINE LOGS
	| ERROR LOGS
	| GENERAL LOGS
	| HOSTS
	| LOGS
	| PRIVILEGES
	| RELAY LOGS for_channel_opt
	| SLOW LOGS
	| OPTIMIZER_COSTS
	| STATUS
	| USER_RESOURCES
	;

local_opt :
	/*empty*/
	| LOCAL
	| NO_WRITE_TO_BINLOG
	;

for_channel_opt :
	/*empty*/
	| FOR CHANNEL ci_identifier
	;

comment_opt :
	comment_list
	;

comment_list :
	/*empty*/
	| comment_list COMMENT
	;

union_op :
	UNION /*4L*/
	| UNION /*4L*/ ALL
	| UNION /*4L*/ DISTINCT
	;

cache_opt :
	/*empty*/
	| SQL_NO_CACHE
	| SQL_CACHE
	;

distinct_opt :
	/*empty*/
	| DISTINCT
	| DISTINCTROW
	;

prepare_statement :
	PREPARE comment_opt sql_id FROM text_literal_or_arg
	| PREPARE comment_opt sql_id FROM user_defined_variable
	;

execute_statement :
	EXECUTE comment_opt sql_id execute_statement_list_opt
	;

execute_statement_list_opt :
	/*empty*/
	| USING /*6L*/ at_id_list
	;

deallocate_statement :
	DEALLOCATE comment_opt PREPARE sql_id
	| DROP comment_opt PREPARE sql_id
	;

select_expression_list_opt :
	/*empty*/
	| select_expression_list
	;

select_options :
	/*empty*/
	| select_option
	| select_option select_option
	| select_option select_option select_option
	| select_option select_option select_option select_option
	;

select_option :
	SQL_NO_CACHE
	| SQL_CACHE
	| DISTINCT
	| DISTINCTROW
	| STRAIGHT_JOIN /*5L*/
	| SQL_CALC_FOUND_ROWS
	| ALL
	;

select_expression_list :
	select_expression
	| select_expression_list ',' /*8L*/ select_expression
	;

select_expression :
	'*' /*25L*/
	| expression as_ci_opt
	| table_id '.' /*36N*/ '*' /*25L*/
	| table_id '.' /*36N*/ reserved_table_id '.' /*36N*/ '*' /*25L*/
	;

as_ci_opt :
	/*empty*/
	| col_alias
	| AS col_alias
	;

col_alias :
	sql_id
	| STRING /*9N*/
	;

from_opt :
	%prec EMPTY_FROM_CLAUSE /*10L*/ /*empty*/
	| from_clause
	;

from_clause :
	FROM table_references
	;

table_references :
	table_reference
	| table_references ',' /*8L*/ table_reference
	;

table_reference :
	table_factor
	| join_table
	;

table_factor :
	aliased_table_name
	| derived_table as_opt table_id column_list_opt
	| openb table_references closeb
	| json_table_function
	;

derived_table :
	query_expression_parens
	| LATERAL query_expression_parens
	;

aliased_table_name :
	table_name as_opt_id index_hint_list_opt
	| table_name PARTITION openb partition_list closeb as_opt_id index_hint_list_opt
	;

column_list_opt :
	/*empty*/
	| '(' /*8L*/ column_list ')' /*8L*/
	;

column_list_empty :
	/*empty*/
	| column_list
	;

column_list :
	sql_id
	| column_list ',' /*8L*/ sql_id
	;

at_id_list :
	user_defined_variable
	| at_id_list ',' /*8L*/ user_defined_variable
	;

index_list :
	sql_id
	| PRIMARY
	| index_list ',' /*8L*/ sql_id
	| index_list ',' /*8L*/ PRIMARY
	;

partition_list :
	sql_id
	| partition_list ',' /*8L*/ sql_id
	;

join_table :
	table_reference inner_join table_factor join_condition_opt
	| table_reference straight_join table_factor on_expression_opt
	| table_reference outer_join table_reference join_condition
	| table_reference natural_join table_factor
	;

join_condition :
	ON /*6L*/ expression
	| USING /*6L*/ '(' /*8L*/ column_list ')' /*8L*/
	;

join_condition_opt :
	%prec JOIN /*5L*/ /*empty*/
	| join_condition
	;

on_expression_opt :
	%prec JOIN /*5L*/ /*empty*/
	| ON /*6L*/ expression
	;

as_opt :
	/*empty*/
	| AS
	;

as_opt_id :
	/*empty*/
	| table_alias
	| AS table_alias
	;

table_alias :
	table_id
	| STRING /*9N*/
	;

inner_join :
	JOIN /*5L*/
	| INNER /*5L*/ JOIN /*5L*/
	| CROSS /*5L*/ JOIN /*5L*/
	;

straight_join :
	STRAIGHT_JOIN /*5L*/
	;

outer_join :
	LEFT /*5L*/ JOIN /*5L*/
	| LEFT /*5L*/ OUTER /*5L*/ JOIN /*5L*/
	| RIGHT /*5L*/ JOIN /*5L*/
	| RIGHT /*5L*/ OUTER /*5L*/ JOIN /*5L*/
	;

natural_join :
	NATURAL /*5L*/ JOIN /*5L*/
	| NATURAL /*5L*/ outer_join
	;

into_table_name :
	INTO /*11R*/ table_name
	| table_name
	;

table_name :
	table_id
	| table_id '.' /*36N*/ reserved_table_id
	;

delete_table_name :
	table_id '.' /*36N*/ '*' /*25L*/
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
	USE /*5L*/ index_or_key index_hint_for_opt openb index_list closeb
	| USE /*5L*/ index_or_key index_hint_for_opt openb closeb
	| IGNORE index_or_key index_hint_for_opt openb index_list closeb
	| FORCE /*5L*/ index_or_key index_hint_for_opt openb index_list closeb
	;

index_hint_for_opt :
	/*empty*/
	| FOR JOIN /*5L*/
	| FOR ORDER BY
	| FOR GROUP BY
	;

where_expression_opt :
	/*empty*/
	| WHERE expression
	;

expression :
	expression OR /*16L*/ expression %prec OR /*16L*/
	| expression XOR /*17L*/ expression %prec XOR /*17L*/
	| expression AND /*18L*/ expression %prec AND /*18L*/
	| NOT /*19R*/ expression %prec NOT /*19R*/
	| bool_pri IS /*21L*/ is_suffix %prec IS /*21L*/
	| bool_pri %prec EXPRESSION_PREC_SETTER /*15L*/
	| user_defined_variable ASSIGNMENT_OPT /*21L*/ expression %prec ASSIGNMENT_OPT /*21L*/
	| expression MEMBER /*1N*/ OF openb expression closeb
	;

bool_pri :
	bool_pri IS /*21L*/ NULL %prec IS /*21L*/
	| bool_pri IS /*21L*/ NOT /*19R*/ NULL %prec IS /*21L*/
	| bool_pri compare predicate
	| predicate %prec EXPRESSION_PREC_SETTER /*15L*/
	;

predicate :
	bit_expr IN /*21L*/ col_tuple
	| bit_expr NOT /*19R*/ IN /*21L*/ col_tuple
	| bit_expr BETWEEN /*20L*/ bit_expr AND /*18L*/ predicate
	| bit_expr NOT /*19R*/ BETWEEN /*20L*/ bit_expr AND /*18L*/ predicate
	| bit_expr LIKE /*21L*/ simple_expr
	| bit_expr NOT /*19R*/ LIKE /*21L*/ simple_expr
	| bit_expr LIKE /*21L*/ simple_expr ESCAPE simple_expr %prec LIKE /*21L*/
	| bit_expr NOT /*19R*/ LIKE /*21L*/ simple_expr ESCAPE simple_expr %prec LIKE /*21L*/
	| bit_expr regexp_symbol bit_expr
	| bit_expr NOT /*19R*/ regexp_symbol bit_expr
	| bit_expr %prec EXPRESSION_PREC_SETTER /*15L*/
	;

regexp_symbol :
	REGEXP /*21L*/
	| RLIKE /*21L*/
	;

bit_expr :
	bit_expr '|' /*16L*/ bit_expr %prec '|' /*16L*/
	| bit_expr '&' /*22L*/ bit_expr %prec '&' /*22L*/
	| bit_expr SHIFT_LEFT /*23L*/ bit_expr %prec SHIFT_LEFT /*23L*/
	| bit_expr SHIFT_RIGHT /*23L*/ bit_expr %prec SHIFT_RIGHT /*23L*/
	| bit_expr '+' /*24L*/ bit_expr %prec '+' /*24L*/
	| bit_expr '-' /*24L*/ bit_expr %prec '-' /*24L*/
	| bit_expr '+' /*24L*/ INTERVAL /*35R*/ bit_expr interval %prec '+' /*24L*/
	| bit_expr '-' /*24L*/ INTERVAL /*35R*/ bit_expr interval %prec '-' /*24L*/
	| bit_expr '*' /*25L*/ bit_expr %prec '*' /*25L*/
	| bit_expr '/' /*25L*/ bit_expr %prec '/' /*25L*/
	| bit_expr '%' /*25L*/ bit_expr %prec '%' /*25L*/
	| bit_expr DIV /*25L*/ bit_expr %prec DIV /*25L*/
	| bit_expr MOD /*25L*/ bit_expr %prec MOD /*25L*/
	| bit_expr '^' /*26L*/ bit_expr %prec '^' /*26L*/
	| simple_expr %prec EXPRESSION_PREC_SETTER /*15L*/
	;

simple_expr :
	function_call_keyword
	| function_call_nonkeyword
	| function_call_generic
	| function_call_conflict
	| simple_expr COLLATE /*28L*/ charset %prec UNARY /*27R*/
	| literal_or_null
	| column_name_or_offset
	| variable_expr
	| '+' /*24L*/ simple_expr %prec UNARY /*27R*/
	| '-' /*24L*/ simple_expr %prec UNARY /*27R*/
	| '~' /*27R*/ simple_expr %prec UNARY /*27R*/
	| '!' /*19R*/ simple_expr %prec UNARY /*27R*/
	| subquery
	| tuple_expression
	| EXISTS subquery
	| MATCH column_names_opt_paren AGAINST openb bit_expr match_option closeb
	| CAST openb expression AS convert_type array_opt closeb
	| CONVERT openb expression ',' /*8L*/ convert_type closeb
	| CONVERT openb expression USING /*6L*/ charset closeb
	| BINARY /*29R*/ simple_expr %prec UNARY /*27R*/
	| DEFAULT default_opt
	| INTERVAL /*35R*/ bit_expr interval '+' /*24L*/ bit_expr %prec INTERVAL /*35R*/
	| INTERVAL /*35R*/ openb expression ',' /*8L*/ expression_list closeb
	| column_name_or_offset JSON_EXTRACT_OP text_literal_or_arg
	| column_name_or_offset JSON_UNQUOTE_EXTRACT_OP text_literal_or_arg
	;

column_names_opt_paren :
	column_names
	| openb column_names closeb
	;

column_names :
	column_name
	| column_names ',' /*8L*/ column_name
	;

trim_type :
	BOTH
	| LEADING
	| TRAILING
	;

frame_units :
	ROWS
	| RANGE
	;

argument_less_window_expr_type :
	CUME_DIST
	| DENSE_RANK
	| PERCENT_RANK
	| RANK
	| ROW_NUMBER
	;

frame_point :
	CURRENT ROW
	| UNBOUNDED PRECEDING
	| UNBOUNDED FOLLOWING
	| NUM_literal PRECEDING
	| INTERVAL /*35R*/ bit_expr interval PRECEDING
	| NUM_literal FOLLOWING
	| INTERVAL /*35R*/ bit_expr interval FOLLOWING
	;

frame_clause_opt :
	/*empty*/
	| frame_clause
	;

frame_clause :
	frame_units frame_point
	| frame_units BETWEEN /*20L*/ frame_point AND /*18L*/ frame_point
	;

window_partition_clause_opt :
	/*empty*/
	| PARTITION BY expression_list
	;

sql_id_opt :
	/*empty*/
	| sql_id
	;

window_spec :
	sql_id_opt window_partition_clause_opt order_by_opt frame_clause_opt
	;

over_clause :
	OVER openb window_spec closeb
	| OVER sql_id
	;

null_treatment_clause_opt :
	/*empty*/
	| null_treatment_clause
	;

null_treatment_clause :
	null_treatment_type
	;

null_treatment_type :
	RESPECT NULLS
	| IGNORE NULLS
	;

first_or_last_value_expr_type :
	FIRST_VALUE
	| LAST_VALUE
	;

from_first_last_type :
	FROM FIRST
	| FROM LAST
	;

from_first_last_clause_opt :
	/*empty*/
	| from_first_last_clause
	;

from_first_last_clause :
	from_first_last_type
	;

lag_lead_expr_type :
	LAG
	| LEAD
	;

window_definition :
	sql_id AS openb window_spec closeb
	;

window_definition_list :
	window_definition
	| window_definition_list ',' /*8L*/ window_definition
	;

default_opt :
	/*empty*/
	| openb ci_identifier closeb
	;

boolean_value :
	TRUE
	| FALSE
	;

is_suffix :
	TRUE
	| NOT /*19R*/ TRUE
	| FALSE
	| NOT /*19R*/ FALSE
	;

compare :
	'=' /*21L*/
	| '<' /*21L*/
	| '>' /*21L*/
	| LE /*21L*/
	| GE /*21L*/
	| NE /*21L*/
	| NULL_SAFE_EQUAL /*21L*/
	;

col_tuple :
	row_tuple
	| subquery
	| LIST_ARG
	;

subquery :
	query_expression_parens %prec SUBQUERY_AS_EXPR /*7L*/
	;

expression_list :
	expression
	| expression_list ',' /*8L*/ expression
	;

function_call_generic :
	sql_id openb select_expression_list_opt closeb
	| table_id '.' /*36N*/ reserved_sql_id openb select_expression_list_opt closeb
	;

function_call_keyword :
	LEFT /*5L*/ openb select_expression_list closeb
	| RIGHT /*5L*/ openb select_expression_list closeb
	| SUBSTRING openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| SUBSTRING openb expression ',' /*8L*/ expression closeb
	| SUBSTRING openb expression FROM expression FOR expression closeb
	| SUBSTRING openb expression FROM expression closeb
	| CASE /*20L*/ expression_opt when_expression_list else_expression_opt END /*20L*/
	| VALUES openb column_name closeb
	| INSERT openb expression ',' /*8L*/ expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| CURRENT_USER func_paren_opt
	;

function_call_nonkeyword :
	UTC_DATE func_paren_opt
	| now
	| CURRENT_DATE func_paren_opt
	| CURDATE func_paren_opt
	| UTC_TIME func_datetime_precision
	| CURTIME func_datetime_precision
	| CURRENT_TIME func_datetime_precision
	| COUNT openb '*' /*25L*/ closeb
	| COUNT openb distinct_opt expression_list closeb
	| MAX openb distinct_opt expression closeb
	| MIN openb distinct_opt expression closeb
	| SUM openb distinct_opt expression closeb
	| AVG openb distinct_opt expression closeb
	| BIT_AND openb expression closeb
	| BIT_OR openb expression closeb
	| BIT_XOR openb expression closeb
	| STD openb expression closeb
	| STDDEV openb expression closeb
	| STDDEV_POP openb expression closeb
	| STDDEV_SAMP openb expression closeb
	| VAR_POP openb expression closeb
	| VAR_SAMP openb expression closeb
	| VARIANCE openb expression closeb
	| GROUP_CONCAT openb distinct_opt expression_list order_by_opt separator_opt limit_opt closeb
	| ANY_VALUE openb expression closeb
	| TIMESTAMPADD openb timestampadd_interval ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| TIMESTAMPDIFF openb timestampadd_interval ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| EXTRACT openb interval FROM expression closeb
	| WEIGHT_STRING openb expression convert_type_weight_string closeb
	| JSON_PRETTY openb expression closeb
	| JSON_STORAGE_FREE openb expression closeb
	| JSON_STORAGE_SIZE openb expression closeb
	| LTRIM openb expression closeb
	| RTRIM openb expression closeb
	| TRIM openb trim_type expression_opt FROM expression closeb
	| TRIM openb expression closeb
	| CHAR openb expression_list closeb
	| CHAR openb expression_list USING /*6L*/ charset closeb
	| TRIM openb expression FROM expression closeb
	| LOCATE openb expression ',' /*8L*/ expression closeb
	| LOCATE openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| POSITION openb bit_expr IN /*21L*/ expression closeb
	| GET_LOCK openb expression ',' /*8L*/ expression closeb
	| IS_FREE_LOCK openb expression closeb
	| IS_USED_LOCK openb expression closeb
	| RELEASE_ALL_LOCKS openb closeb
	| RELEASE_LOCK openb expression closeb
	| JSON_SCHEMA_VALID openb expression ',' /*8L*/ expression closeb
	| JSON_SCHEMA_VALIDATION_REPORT openb expression ',' /*8L*/ expression closeb
	| JSON_ARRAY openb expression_list_opt closeb
	| ST_AsBinary openb expression closeb
	| ST_AsBinary openb expression ',' /*8L*/ expression closeb
	| ST_AsText openb expression closeb
	| ST_AsText openb expression ',' /*8L*/ expression closeb
	| ST_IsEmpty openb expression closeb
	| ST_IsSimple openb expression closeb
	| ST_Dimension openb expression closeb
	| ST_Envelope openb expression closeb
	| ST_GeometryType openb expression closeb
	| ST_Latitude openb expression closeb
	| ST_Latitude openb expression ',' /*8L*/ expression closeb
	| ST_Longitude openb expression closeb
	| ST_Longitude openb expression ',' /*8L*/ expression closeb
	| ST_EndPoint openb expression closeb
	| ST_IsClosed openb expression closeb
	| ST_Length openb expression closeb
	| ST_Length openb expression ',' /*8L*/ expression closeb
	| ST_NumPoints openb expression closeb
	| ST_PointN openb expression ',' /*8L*/ expression closeb
	| ST_StartPoint openb expression closeb
	| ST_X openb expression closeb
	| ST_X openb expression ',' /*8L*/ expression closeb
	| ST_Y openb expression closeb
	| ST_Y openb expression ',' /*8L*/ expression closeb
	| ST_GeometryFromText openb expression closeb
	| ST_GeometryFromText openb expression ',' /*8L*/ expression closeb
	| ST_GeometryFromText openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| ST_GeometryCollectionFromText openb expression closeb
	| ST_GeometryCollectionFromText openb expression ',' /*8L*/ expression closeb
	| ST_GeometryCollectionFromText openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| ST_LineStringFromText openb expression closeb
	| ST_LineStringFromText openb expression ',' /*8L*/ expression closeb
	| ST_LineStringFromText openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| ST_MultiLineStringFromText openb expression closeb
	| ST_MultiLineStringFromText openb expression ',' /*8L*/ expression closeb
	| ST_MultiLineStringFromText openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| ST_MultiPointFromText openb expression closeb
	| ST_MultiPointFromText openb expression ',' /*8L*/ expression closeb
	| ST_MultiPointFromText openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| ST_MultiPolygonFromText openb expression closeb
	| ST_MultiPolygonFromText openb expression ',' /*8L*/ expression closeb
	| ST_MultiPolygonFromText openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| ST_PointFromText openb expression closeb
	| ST_PointFromText openb expression ',' /*8L*/ expression closeb
	| ST_PointFromText openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| ST_PolygonFromText openb expression closeb
	| ST_PolygonFromText openb expression ',' /*8L*/ expression closeb
	| ST_PolygonFromText openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| ST_GeometryFromWKB openb expression closeb
	| ST_GeometryFromWKB openb expression ',' /*8L*/ expression closeb
	| ST_GeometryFromWKB openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| ST_GeometryCollectionFromWKB openb expression closeb
	| ST_GeometryCollectionFromWKB openb expression ',' /*8L*/ expression closeb
	| ST_GeometryCollectionFromWKB openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| ST_LineStringFromWKB openb expression closeb
	| ST_LineStringFromWKB openb expression ',' /*8L*/ expression closeb
	| ST_LineStringFromWKB openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| ST_MultiLineStringFromWKB openb expression closeb
	| ST_MultiLineStringFromWKB openb expression ',' /*8L*/ expression closeb
	| ST_MultiLineStringFromWKB openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| ST_MultiPointFromWKB openb expression closeb
	| ST_MultiPointFromWKB openb expression ',' /*8L*/ expression closeb
	| ST_MultiPointFromWKB openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| ST_MultiPolygonFromWKB openb expression closeb
	| ST_MultiPolygonFromWKB openb expression ',' /*8L*/ expression closeb
	| ST_MultiPolygonFromWKB openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| ST_PointFromWKB openb expression closeb
	| ST_PointFromWKB openb expression ',' /*8L*/ expression closeb
	| ST_PointFromWKB openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| ST_PolygonFromWKB openb expression closeb
	| ST_PolygonFromWKB openb expression ',' /*8L*/ expression closeb
	| ST_PolygonFromWKB openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| ST_Area openb expression closeb
	| ST_Centroid openb expression closeb
	| ST_ExteriorRing openb expression closeb
	| ST_InteriorRingN openb expression ',' /*8L*/ expression closeb
	| ST_NumInteriorRings openb expression closeb
	| ST_GeometryN openb expression ',' /*8L*/ expression closeb
	| ST_NumGeometries openb expression closeb
	| ST_GeoHash openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| ST_GeoHash openb expression ',' /*8L*/ expression closeb
	| ST_LatFromGeoHash openb expression closeb
	| ST_LongFromGeoHash openb expression closeb
	| ST_PointFromGeoHash openb expression ',' /*8L*/ expression closeb
	| ST_GeomFromGeoJSON openb expression closeb
	| ST_GeomFromGeoJSON openb expression ',' /*8L*/ expression closeb
	| ST_GeomFromGeoJSON openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| ST_AsGeoJSON openb expression closeb
	| ST_AsGeoJSON openb expression ',' /*8L*/ expression closeb
	| ST_AsGeoJSON openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| JSON_OBJECT openb json_object_param_opt closeb
	| JSON_QUOTE openb expression closeb
	| JSON_CONTAINS openb expression ',' /*8L*/ expression_list closeb
	| JSON_CONTAINS_PATH openb expression ',' /*8L*/ expression ',' /*8L*/ expression_list closeb
	| JSON_EXTRACT openb expression ',' /*8L*/ expression_list closeb
	| JSON_KEYS openb expression closeb
	| JSON_KEYS openb expression ',' /*8L*/ expression closeb
	| JSON_OVERLAPS openb expression ',' /*8L*/ expression closeb
	| JSON_SEARCH openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| JSON_SEARCH openb expression ',' /*8L*/ expression ',' /*8L*/ expression ',' /*8L*/ expression_list closeb
	| JSON_VALUE openb expression ',' /*8L*/ expression returning_type_opt closeb
	| JSON_VALUE openb expression ',' /*8L*/ expression returning_type_opt on_empty closeb
	| JSON_VALUE openb expression ',' /*8L*/ expression returning_type_opt on_error closeb
	| JSON_VALUE openb expression ',' /*8L*/ expression returning_type_opt on_empty on_error closeb
	| JSON_DEPTH openb expression closeb
	| JSON_VALID openb expression closeb
	| JSON_TYPE openb expression closeb
	| JSON_LENGTH openb expression closeb
	| JSON_LENGTH openb expression ',' /*8L*/ expression closeb
	| JSON_ARRAY_APPEND openb expression ',' /*8L*/ json_object_param_list closeb
	| JSON_ARRAY_INSERT openb expression ',' /*8L*/ json_object_param_list closeb
	| JSON_INSERT openb expression ',' /*8L*/ json_object_param_list closeb
	| JSON_REPLACE openb expression ',' /*8L*/ json_object_param_list closeb
	| JSON_SET openb expression ',' /*8L*/ json_object_param_list closeb
	| JSON_MERGE openb expression ',' /*8L*/ expression_list closeb
	| JSON_MERGE_PATCH openb expression ',' /*8L*/ expression_list closeb
	| JSON_MERGE_PRESERVE openb expression ',' /*8L*/ expression_list closeb
	| JSON_REMOVE openb expression ',' /*8L*/ expression_list closeb
	| JSON_UNQUOTE openb expression closeb
	| MULTIPOLYGON openb expression_list closeb
	| MULTIPOINT openb expression_list closeb
	| MULTILINESTRING openb expression_list closeb
	| POLYGON openb expression_list closeb
	| LINESTRING openb expression_list closeb
	| POINT openb expression ',' /*8L*/ expression closeb
	| argument_less_window_expr_type openb closeb over_clause
	| first_or_last_value_expr_type openb expression closeb null_treatment_clause_opt over_clause
	| NTILE openb null_int_variable_arg closeb over_clause
	| NTH_VALUE openb expression ',' /*8L*/ null_int_variable_arg closeb from_first_last_clause_opt null_treatment_clause_opt over_clause
	| lag_lead_expr_type openb expression closeb null_treatment_clause_opt over_clause
	| lag_lead_expr_type openb expression ',' /*8L*/ null_int_variable_arg default_with_comma_opt closeb null_treatment_clause_opt over_clause
	| ADDDATE openb expression ',' /*8L*/ INTERVAL /*35R*/ bit_expr interval closeb
	| ADDDATE openb expression ',' /*8L*/ expression closeb
	| DATE_ADD openb expression ',' /*8L*/ INTERVAL /*35R*/ bit_expr interval closeb
	| DATE_SUB openb expression ',' /*8L*/ INTERVAL /*35R*/ bit_expr interval closeb
	| SUBDATE openb expression ',' /*8L*/ INTERVAL /*35R*/ bit_expr interval closeb
	| SUBDATE openb expression ',' /*8L*/ expression closeb
	| regular_expressions
	| xml_expressions
	| performance_schema_function_expressions
	| gtid_function_expressions
	;

null_int_variable_arg :
	null_as_literal
	| INTEGRAL
	| user_defined_variable
	| VALUE_ARG
	;

default_with_comma_opt :
	/*empty*/
	| ',' /*8L*/ expression
	;

regular_expressions :
	REGEXP_INSTR openb expression ',' /*8L*/ expression closeb
	| REGEXP_INSTR openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| REGEXP_INSTR openb expression ',' /*8L*/ expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| REGEXP_INSTR openb expression ',' /*8L*/ expression ',' /*8L*/ expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| REGEXP_INSTR openb expression ',' /*8L*/ expression ',' /*8L*/ expression ',' /*8L*/ expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| REGEXP_LIKE openb expression ',' /*8L*/ expression closeb
	| REGEXP_LIKE openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| REGEXP_REPLACE openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| REGEXP_REPLACE openb expression ',' /*8L*/ expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| REGEXP_REPLACE openb expression ',' /*8L*/ expression ',' /*8L*/ expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| REGEXP_REPLACE openb expression ',' /*8L*/ expression ',' /*8L*/ expression ',' /*8L*/ expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| REGEXP_SUBSTR openb expression ',' /*8L*/ expression closeb
	| REGEXP_SUBSTR openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| REGEXP_SUBSTR openb expression ',' /*8L*/ expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	| REGEXP_SUBSTR openb expression ',' /*8L*/ expression ',' /*8L*/ expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	;

xml_expressions :
	ExtractValue openb expression ',' /*8L*/ expression closeb
	| UpdateXML openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	;

performance_schema_function_expressions :
	FORMAT_BYTES openb expression closeb
	| FORMAT_PICO_TIME openb expression closeb
	| PS_CURRENT_THREAD_ID openb closeb
	| PS_THREAD_ID openb expression closeb
	;

gtid_function_expressions :
	GTID_SUBSET openb expression ',' /*8L*/ expression closeb
	| GTID_SUBTRACT openb expression ',' /*8L*/ expression closeb
	| WAIT_FOR_EXECUTED_GTID_SET openb expression closeb
	| WAIT_FOR_EXECUTED_GTID_SET openb expression ',' /*8L*/ expression closeb
	| WAIT_UNTIL_SQL_THREAD_AFTER_GTIDS openb expression closeb
	| WAIT_UNTIL_SQL_THREAD_AFTER_GTIDS openb expression ',' /*8L*/ expression closeb
	| WAIT_UNTIL_SQL_THREAD_AFTER_GTIDS openb expression ',' /*8L*/ expression ',' /*8L*/ expression closeb
	;

returning_type_opt :
	/*empty*/
	| RETURNING convert_type
	;

interval :
	DAY_HOUR
	| DAY_MICROSECOND
	| DAY_MINUTE
	| DAY_SECOND
	| HOUR_MICROSECOND
	| HOUR_MINUTE
	| HOUR_SECOND
	| MINUTE_MICROSECOND
	| MINUTE_SECOND
	| SECOND_MICROSECOND
	| YEAR_MONTH
	| DAY
	| WEEK
	| HOUR
	| MINUTE
	| MONTH
	| QUARTER
	| SECOND
	| MICROSECOND
	| YEAR
	;

timestampadd_interval :
	DAY
	| WEEK
	| HOUR
	| MINUTE
	| MONTH
	| QUARTER
	| SECOND
	| MICROSECOND
	| YEAR
	| SQL_TSI_DAY
	| SQL_TSI_WEEK
	| SQL_TSI_HOUR
	| SQL_TSI_MINUTE
	| SQL_TSI_MONTH
	| SQL_TSI_QUARTER
	| SQL_TSI_SECOND
	| SQL_TSI_MICROSECOND
	| SQL_TSI_YEAR
	;

func_paren_opt :
	/*empty*/
	| openb closeb
	;

func_datetime_precision :
	/*empty*/
	| openb closeb
	| openb INTEGRAL closeb
	;

function_call_conflict :
	IF openb select_expression_list closeb
	| DATABASE openb select_expression_list_opt closeb
	| SCHEMA openb select_expression_list_opt closeb
	| MOD /*25L*/ openb select_expression_list closeb
	| REPLACE openb select_expression_list closeb
	;

match_option :
	/*empty*/
	| IN /*21L*/ BOOLEAN MODE
	| IN /*21L*/ NATURAL /*5L*/ LANGUAGE MODE
	| IN /*21L*/ NATURAL /*5L*/ LANGUAGE MODE WITH QUERY EXPANSION
	| WITH QUERY EXPANSION
	;

charset :
	sql_id
	| STRING /*9N*/
	| BINARY /*29R*/
	;

convert_type_weight_string :
	/*empty*/
	| AS BINARY /*29R*/ '(' /*8L*/ INTEGRAL ')' /*8L*/
	| AS CHAR '(' /*8L*/ INTEGRAL ')' /*8L*/
	;

convert_type :
	BINARY /*29R*/ length_opt
	| CHAR length_opt charset_opt
	| DATE
	| DATETIME length_opt
	| DECIMAL_TYPE decimal_length_opt
	| JSON
	| NCHAR length_opt
	| SIGNED
	| SIGNED INTEGER
	| TIME length_opt
	| UNSIGNED
	| UNSIGNED INTEGER
	| FLOAT_TYPE length_opt
	| DOUBLE
	| REAL
	;

array_opt :
	/*empty*/
	| ARRAY
	;

expression_opt :
	/*empty*/
	| expression
	;

separator_opt :
	/*empty*/
	| SEPARATOR STRING /*9N*/
	;

when_expression_list :
	when_expression
	| when_expression_list when_expression
	;

when_expression :
	WHEN /*20L*/ expression THEN /*20L*/ expression
	;

else_expression_opt :
	/*empty*/
	| ELSE /*20L*/ expression
	;

column_name :
	ci_identifier
	| NR_KEYW
	| table_id '.' /*36N*/ reserved_sql_id
	| table_id '.' /*36N*/ reserved_table_id '.' /*36N*/ reserved_sql_id
	;

column_name_or_offset :
	column_name
	| OFFSET_ARG
	;

num_val :
	sql_id
	| INTEGRAL VALUES
	| VALUE_ARG VALUES
	;

group_by_opt :
	/*empty*/
	| GROUP BY expression_list
	;

having_opt :
	/*empty*/
	| HAVING expression
	;

named_window :
	WINDOW window_definition_list %prec WINDOW_EXPR /*37L*/
	;

named_windows_list :
	named_window
	| named_windows_list ',' /*8L*/ named_window
	;

named_windows_list_opt :
	/*empty*/
	| named_windows_list
	;

order_by_opt :
	/*empty*/
	| order_by_clause
	;

order_by_clause :
	ORDER BY order_list
	;

order_list :
	order
	| order_list ',' /*8L*/ order
	;

order :
	expression asc_desc_opt
	;

asc_desc_opt :
	/*empty*/
	| ASC
	| DESC
	;

limit_opt :
	/*empty*/
	| limit_clause
	;

limit_clause :
	LIMIT expression
	| LIMIT expression ',' /*8L*/ expression
	| LIMIT expression OFFSET expression
	;

algorithm_lock_opt :
	/*empty*/
	| lock_index algorithm_index
	| algorithm_index lock_index
	| algorithm_index
	| lock_index
	;

lock_index :
	LOCK equal_opt DEFAULT
	| LOCK equal_opt NONE /*6L*/
	| LOCK equal_opt SHARED /*6L*/
	| LOCK equal_opt EXCLUSIVE /*6L*/
	;

algorithm_index :
	ALGORITHM /*6L*/ equal_opt DEFAULT
	| ALGORITHM /*6L*/ equal_opt INPLACE /*6L*/
	| ALGORITHM /*6L*/ equal_opt COPY /*6L*/
	| ALGORITHM /*6L*/ equal_opt INSTANT /*6L*/
	;

algorithm_view :
	/*empty*/
	| ALGORITHM /*6L*/ '=' /*21L*/ UNDEFINED
	| ALGORITHM /*6L*/ '=' /*21L*/ MERGE
	| ALGORITHM /*6L*/ '=' /*21L*/ TEMPTABLE
	;

security_view_opt :
	/*empty*/
	| SQL SECURITY security_view
	;

security_view :
	DEFINER
	| INVOKER
	;

check_option_opt :
	/*empty*/
	| WITH cascade_or_local_opt CHECK OPTION
	;

cascade_or_local_opt :
	/*empty*/
	| CASCADED
	| LOCAL
	;

definer_opt :
	/*empty*/
	| DEFINER '=' /*21L*/ user
	;

user :
	CURRENT_USER
	| CURRENT_USER '(' /*8L*/ ')' /*8L*/
	| user_username address_opt
	;

user_username :
	STRING /*9N*/
	| ID
	;

address_opt :
	/*empty*/
	| AT_ID
	;

locking_clause :
	FOR UPDATE
	| LOCK IN /*21L*/ SHARE MODE
	;

into_clause :
	INTO /*11R*/ OUTFILE S3 STRING /*9N*/ charset_opt format_opt export_options manifest_opt overwrite_opt
	| INTO /*11R*/ DUMPFILE STRING /*9N*/
	| INTO /*11R*/ OUTFILE STRING /*9N*/ charset_opt export_options
	;

format_opt :
	/*empty*/
	| FORMAT CSV header_opt
	| FORMAT TEXT header_opt
	;

header_opt :
	/*empty*/
	| HEADER
	;

manifest_opt :
	/*empty*/
	| MANIFEST ON /*6L*/
	| MANIFEST OFF
	;

overwrite_opt :
	/*empty*/
	| OVERWRITE ON /*6L*/
	| OVERWRITE OFF
	;

export_options :
	fields_opts lines_opts
	;

lines_opts :
	/*empty*/
	| LINES lines_opt_list
	;

lines_opt_list :
	lines_opt
	| lines_opt_list lines_opt
	;

lines_opt :
	STARTING BY STRING /*9N*/
	| TERMINATED BY STRING /*9N*/
	;

fields_opts :
	/*empty*/
	| columns_or_fields fields_opt_list
	;

fields_opt_list :
	fields_opt
	| fields_opt_list fields_opt
	;

fields_opt :
	TERMINATED BY STRING /*9N*/
	| optionally_opt ENCLOSED BY STRING /*9N*/
	| ESCAPED BY STRING /*9N*/
	;

optionally_opt :
	/*empty*/
	| OPTIONALLY
	;

insert_data :
	VALUES tuple_list
	| select_statement
	| openb ins_column_list closeb VALUES tuple_list
	| openb closeb VALUES tuple_list
	| openb ins_column_list closeb select_statement
	;

ins_column_list :
	sql_id
	| sql_id '.' /*36N*/ sql_id
	| ins_column_list ',' /*8L*/ sql_id
	| ins_column_list ',' /*8L*/ sql_id '.' /*36N*/ sql_id
	;

on_dup_opt :
	/*empty*/
	| ON /*6L*/ DUPLICATE KEY /*14R*/ UPDATE update_list
	;

tuple_list :
	tuple_or_empty
	| tuple_list ',' /*8L*/ tuple_or_empty
	;

tuple_or_empty :
	row_tuple
	| openb closeb
	;

row_tuple :
	openb expression_list closeb
	| ROW openb expression_list closeb
	;

tuple_expression :
	row_tuple
	;

update_list :
	update_expression
	| update_list ',' /*8L*/ update_expression
	;

update_expression :
	column_name '=' /*21L*/ expression
	;

charset_or_character_set :
	CHARSET /*13N*/
	| CHARACTER SET
	;

charset_or_character_set_or_names :
	charset_or_character_set
	| NAMES
	;

charset_value :
	sql_id
	| STRING /*9N*/
	| DEFAULT
	;

for_from :
	FOR
	| FROM
	;

temp_opt :
	/*empty*/
	| TEMPORARY
	;

exists_opt :
	/*empty*/
	| IF EXISTS
	;

not_exists_opt :
	/*empty*/
	| IF NOT /*19R*/ EXISTS
	;

ignore_opt :
	/*empty*/
	| IGNORE
	;

to_opt :
	/*empty*/
	| TO
	| AS
	;

call_statement :
	CALL table_name openb expression_list_opt closeb
	;

expression_list_opt :
	/*empty*/
	| expression_list
	;

using_opt :
	/*empty*/
	| using_index_type
	;

using_index_type :
	USING /*6L*/ sql_id
	;

sql_id :
	ci_identifier
	| NR_KEYW
	;

reserved_sql_id :
	sql_id
	| R_KEYW
	;

table_id :
	ID
	| NR_KEYW
	;

table_id_opt :
	%prec LOWER_THAN_CHARSET /*12N*/ /*empty*/
	| table_id
	;

reserved_table_id :
	table_id
	| R_KEYW
	;

kill_statement :
	KILL kill_type_opt INTEGRAL
	;

kill_type_opt :
	/*empty*/
	| CONNECTION
	| QUERY
	;

openb :
	'(' /*8L*/
	;

closeb :
	')' /*8L*/
	;

skip_to_end :
	/*empty*/
	;

ddl_skip_to_end :
	/*empty*/
	| openb
	| reserved_sql_id
	;

%%

%option caseless

basic_id	[_a-zA-Z][a-zA-Z0-9_]*

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
"|"	'|'
"-"	'-'
","	','
";"	';'
"!"	'!'
"/"	'/'
"."	'.'
"("	'('
")"	')'
"*"	'*'
"&"	'&'
"%"	'%'
"+"	'+'

ACTION	ACTION
ACTIVE	ACTIVE
ADD	ADD
ADDDATE	ADDDATE
ADMIN	ADMIN
AFTER	AFTER
AGAINST	AGAINST
ALGORITHM	ALGORITHM
ALL	ALL
ALTER	ALTER
ALWAYS	ALWAYS
ANALYZE	ANALYZE
AND	AND
ANY_VALUE	ANY_VALUE
ARRAY	ARRAY
AS	AS
ASC	ASC
ASCII	ASCII
ASSIGNMENT_OPT	ASSIGNMENT_OPT
AT_AT_ID	AT_AT_ID
AT_ID	AT_ID
AUTOEXTEND_SIZE	AUTOEXTEND_SIZE
AUTO_INCREMENT	AUTO_INCREMENT
AVG	AVG
AVG_ROW_LENGTH	AVG_ROW_LENGTH
BEFORE	BEFORE
BEGIN	BEGIN
BETWEEN	BETWEEN
BIGINT	BIGINT
BINARY	BINARY
BIT	BIT
BIT_AND	BIT_AND
BIT_LITERAL	BIT_LITERAL
BITNUM	BITNUM
BIT_OR	BIT_OR
BIT_XOR	BIT_XOR
BLOB	BLOB
BOOL	BOOL
BOOLEAN	BOOLEAN
BOTH	BOTH
BUCKETS	BUCKETS
BY	BY
BYTE	BYTE
CALL	CALL
CANCEL	CANCEL
CASCADE	CASCADE
CASCADED	CASCADED
CASE	CASE
CAST	CAST
CHANGE	CHANGE
CHANNEL	CHANNEL
CHAR	CHAR
CHARACTER	CHARACTER
CHARSET	CHARSET
CHECK	CHECK
CHECKSUM	CHECKSUM
CLEANUP	CLEANUP
CLONE	CLONE
COALESCE	COALESCE
CODE	CODE
COLLATE	COLLATE
COLLATION	COLLATION
COLUMN	COLUMN
COLUMN_FORMAT	COLUMN_FORMAT
COLUMNS	COLUMNS
COMMENT	COMMENT
COMMENT_KEYWORD	COMMENT_KEYWORD
COMMIT	COMMIT
COMMITTED	COMMITTED
COMPACT	COMPACT
COMPLETE	COMPLETE
COMPONENT	COMPONENT
COMPRESSED	COMPRESSED
COMPRESSION	COMPRESSION
CONNECTION	CONNECTION
CONSISTENT	CONSISTENT
CONSTRAINT	CONSTRAINT
CONVERT	CONVERT
COPY	COPY
COUNT	COUNT
CREATE	CREATE
CROSS	CROSS
CSV	CSV
CUME_DIST	CUME_DIST
CURDATE	CURDATE
CURRENT	CURRENT
CURRENT_DATE	CURRENT_DATE
CURRENT_TIME	CURRENT_TIME
CURRENT_TIMESTAMP	CURRENT_TIMESTAMP
CURRENT_USER	CURRENT_USER
CURTIME	CURTIME
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
DECIMAL	DECIMAL_TYPE
DEFAULT	DEFAULT
DEFINER	DEFINER
DEFINITION	DEFINITION
DELAY_KEY_WRITE	DELAY_KEY_WRITE
DELETE	DELETE
DENSE_RANK	DENSE_RANK
DESC	DESC
DESCRIBE	DESCRIBE
///DESCRIPTION	DESCRIPTION
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
DUMPFILE	DUMPFILE
DUPLICATE	DUPLICATE
DYNAMIC	DYNAMIC
ELSE	ELSE
EMPTY	EMPTY
EMPTY_FROM_CLAUSE	EMPTY_FROM_CLAUSE
ENABLE	ENABLE
ENCLOSED	ENCLOSED
ENCRYPTION	ENCRYPTION
END	END
ENFORCED	ENFORCED
ENGINE	ENGINE
ENGINE_ATTRIBUTE	ENGINE_ATTRIBUTE
ENGINES	ENGINES
ENUM	ENUM
ERROR	ERROR
ESCAPE	ESCAPE
ESCAPED	ESCAPED
EVENT	EVENT
EXCHANGE	EXCHANGE
EXCLUDE	EXCLUDE
EXCLUSIVE	EXCLUSIVE
EXECUTE	EXECUTE
EXISTS	EXISTS
EXPANSION	EXPANSION
EXPIRE	EXPIRE
EXPLAIN	EXPLAIN
EXPORT	EXPORT
EXPRESSION_PREC_SETTER	EXPRESSION_PREC_SETTER
EXTENDED	EXTENDED
EXTRACT	EXTRACT
ExtractValue	ExtractValue
FALSE	FALSE
FIELDS	FIELDS
FIRST	FIRST
FIRST_VALUE	FIRST_VALUE
FIXED	FIXED
FLOAT	FLOAT
FLOAT4_TYPE	FLOAT4_TYPE
FLOAT8_TYPE	FLOAT8_TYPE
FLOAT_TYPE	FLOAT_TYPE
FLUSH	FLUSH
FOLLOWING	FOLLOWING
FOR	FOR
FORCE	FORCE
FOREIGN	FOREIGN
FORMAT	FORMAT
FORMAT_BYTES	FORMAT_BYTES
FORMAT_PICO_TIME	FORMAT_PICO_TIME
FROM	FROM
FULL	FULL
FULLTEXT	FULLTEXT
FUNCTION	FUNCTION
///FUNCTION_CALL_NON_KEYWORD	FUNCTION_CALL_NON_KEYWORD
GE	GE
GENERAL	GENERAL
GENERATED	GENERATED
///GEOMCOLLECTION	GEOMCOLLECTION
GEOMETRY	GEOMETRY
GEOMETRYCOLLECTION	GEOMETRYCOLLECTION
GET_LOCK	GET_LOCK
GET_MASTER_PUBLIC_KEY	GET_MASTER_PUBLIC_KEY
GLOBAL	GLOBAL
GROUP	GROUP
GROUP_CONCAT	GROUP_CONCAT
GROUPING	GROUPING
GROUPS	GROUPS
GTID_EXECUTED	GTID_EXECUTED
GTID_SUBSET	GTID_SUBSET
GTID_SUBTRACT	GTID_SUBTRACT
HASH	HASH
HAVING	HAVING
HEADER	HEADER
HEX	HEX
HEXNUM	HEXNUM
HISTOGRAM	HISTOGRAM
HISTORY	HISTORY
HOSTS	HOSTS
HOUR	HOUR
HOUR_MICROSECOND	HOUR_MICROSECOND
HOUR_MINUTE	HOUR_MINUTE
HOUR_SECOND	HOUR_SECOND
IF	IF
IGNORE	IGNORE
IMPORT	IMPORT
IN	IN
INACTIVE	INACTIVE
INDEX	INDEX
INDEXES	INDEXES
INNER	INNER
INPLACE	INPLACE
INSERT	INSERT
INSERT_METHOD	INSERT_METHOD
INSTANT	INSTANT
INT	INT
INTEGER	INTEGER
INTEGRAL	INTEGRAL
INTERVAL	INTERVAL
INTO	INTO
INVISIBLE	INVISIBLE
INVOKER	INVOKER
IS	IS
IS_FREE_LOCK	IS_FREE_LOCK
ISOLATION	ISOLATION
IS_USED_LOCK	IS_USED_LOCK
JOIN	JOIN
JSON	JSON
JSON_ARRAY	JSON_ARRAY
JSON_ARRAY_APPEND	JSON_ARRAY_APPEND
JSON_ARRAY_INSERT	JSON_ARRAY_INSERT
JSON_CONTAINS	JSON_CONTAINS
JSON_CONTAINS_PATH	JSON_CONTAINS_PATH
JSON_DEPTH	JSON_DEPTH
JSON_EXTRACT	JSON_EXTRACT
JSON_EXTRACT_OP	JSON_EXTRACT_OP
JSON_INSERT	JSON_INSERT
JSON_KEYS	JSON_KEYS
JSON_LENGTH	JSON_LENGTH
JSON_MERGE	JSON_MERGE
JSON_MERGE_PATCH	JSON_MERGE_PATCH
JSON_MERGE_PRESERVE	JSON_MERGE_PRESERVE
JSON_OBJECT	JSON_OBJECT
JSON_OVERLAPS	JSON_OVERLAPS
JSON_PRETTY	JSON_PRETTY
JSON_QUOTE	JSON_QUOTE
JSON_REMOVE	JSON_REMOVE
JSON_REPLACE	JSON_REPLACE
JSON_SCHEMA_VALID	JSON_SCHEMA_VALID
JSON_SCHEMA_VALIDATION_REPORT	JSON_SCHEMA_VALIDATION_REPORT
JSON_SEARCH	JSON_SEARCH
JSON_SET	JSON_SET
JSON_STORAGE_FREE	JSON_STORAGE_FREE
JSON_STORAGE_SIZE	JSON_STORAGE_SIZE
JSON_TABLE	JSON_TABLE
JSON_TYPE	JSON_TYPE
JSON_UNQUOTE	JSON_UNQUOTE
JSON_UNQUOTE_EXTRACT_OP	JSON_UNQUOTE_EXTRACT_OP
JSON_VALID	JSON_VALID
JSON_VALUE	JSON_VALUE
KEY	KEY
KEY_BLOCK_SIZE	KEY_BLOCK_SIZE
KEYS	KEYS
KEYSPACES	KEYSPACES
KILL	KILL
LAG	LAG
LANGUAGE	LANGUAGE
LAST	LAST
///LAST_INSERT_ID	LAST_INSERT_ID
LAST_VALUE	LAST_VALUE
LATERAL	LATERAL
LAUNCH	LAUNCH
LE	LE
LEAD	LEAD
LEADING	LEADING
LEFT	LEFT
LESS	LESS
LEVEL	LEVEL
LIKE	LIKE
LIMIT	LIMIT
LINEAR	LINEAR
LINES	LINES
LINESTRING	LINESTRING
LIST	LIST
LIST_ARG	LIST_ARG
LOAD	LOAD
LOCAL	LOCAL
LOCALTIME	LOCALTIME
LOCALTIMESTAMP	LOCALTIMESTAMP
LOCATE	LOCATE
LOCK	LOCK
LOCKED	LOCKED
LOGS	LOGS
LONGBLOB	LONGBLOB
LONGTEXT	LONGTEXT
LOWER_THAN_CHARSET	LOWER_THAN_CHARSET
LOW_PRIORITY	LOW_PRIORITY
LTRIM	LTRIM
MANIFEST	MANIFEST
MASTER_COMPRESSION_ALGORITHMS	MASTER_COMPRESSION_ALGORITHMS
MASTER_PUBLIC_KEY_PATH	MASTER_PUBLIC_KEY_PATH
MASTER_TLS_CIPHERSUITES	MASTER_TLS_CIPHERSUITES
MASTER_ZSTD_COMPRESSION_LEVEL	MASTER_ZSTD_COMPRESSION_LEVEL
MATCH	MATCH
MAX	MAX
MAX_ROWS	MAX_ROWS
MAXVALUE	MAXVALUE
MEDIUMBLOB	MEDIUMBLOB
MEDIUMINT	MEDIUMINT
MEDIUMTEXT	MEDIUMTEXT
MEMBER	MEMBER
MEMORY	MEMORY
MERGE	MERGE
MICROSECOND	MICROSECOND
MIN	MIN
MIN_ROWS	MIN_ROWS
MINUTE	MINUTE
MINUTE_MICROSECOND	MINUTE_MICROSECOND
MINUTE_SECOND	MINUTE_SECOND
MOD	MOD
MODE	MODE
MODIFY	MODIFY
MONTH	MONTH
MULTILINESTRING	MULTILINESTRING
MULTIPOINT	MULTIPOINT
MULTIPOLYGON	MULTIPOLYGON
NAME	NAME
NAMES	NAMES
NATURAL	NATURAL
NCHAR	NCHAR
NCHAR_STRING	NCHAR_STRING
NE	NE
NESTED	NESTED
NETWORK_NAMESPACE	NETWORK_NAMESPACE
NEXT	NEXT
NO	NO
NONE	NONE
NOT	NOT
NOW	NOW
NOWAIT	NOWAIT
NO_WRITE_TO_BINLOG	NO_WRITE_TO_BINLOG
NTH_VALUE	NTH_VALUE
NTILE	NTILE
NULL	NULL
NULLS	NULLS
NULL_SAFE_EQUAL	NULL_SAFE_EQUAL
NUMERIC	NUMERIC
OF	OF
OFF	OFF
OFFSET	OFFSET
OFFSET_ARG	OFFSET_ARG
OJ	OJ
OLD	OLD
ON	ON
ONLY	ONLY
OPEN	OPEN
OPTIMIZE	OPTIMIZE
OPTIMIZER_COSTS	OPTIMIZER_COSTS
OPTION	OPTION
OPTIONAL	OPTIONAL
OPTIONALLY	OPTIONALLY
OR	OR
ORDER	ORDER
ORDINALITY	ORDINALITY
ORGANIZATION	ORGANIZATION
OTHERS	OTHERS
OUTER	OUTER
OUTFILE	OUTFILE
OVER	OVER
OVERWRITE	OVERWRITE
PACK_KEYS	PACK_KEYS
PARSER	PARSER
PARTIAL	PARTIAL
PARTITION	PARTITION
PARTITIONING	PARTITIONING
PARTITIONS	PARTITIONS
PASSWORD	PASSWORD
PATH	PATH
PERCENT_RANK	PERCENT_RANK
PERSIST	PERSIST
PERSIST_ONLY	PERSIST_ONLY
PLAN	PLAN
PLUGINS	PLUGINS
POINT	POINT
POLYGON	POLYGON
POSITION	POSITION
PRECEDING	PRECEDING
PREPARE	PREPARE
PRIMARY	PRIMARY
PRIVILEGE_CHECKS_USER	PRIVILEGE_CHECKS_USER
PRIVILEGES	PRIVILEGES
PROCEDURE	PROCEDURE
PROCESS	PROCESS
PROCESSLIST	PROCESSLIST
PS_CURRENT_THREAD_ID	PS_CURRENT_THREAD_ID
PS_THREAD_ID	PS_THREAD_ID
PURGE	PURGE
QUARTER	QUARTER
QUERIES	QUERIES
QUERY	QUERY
RANDOM	RANDOM
RANGE	RANGE
RANK	RANK
RATIO	RATIO
READ	READ
REAL	REAL
REBUILD	REBUILD
RECURSIVE	RECURSIVE
REDUNDANT	REDUNDANT
REFERENCE	REFERENCE
REFERENCES	REFERENCES
REGEXP	REGEXP
REGEXP_INSTR	REGEXP_INSTR
REGEXP_LIKE	REGEXP_LIKE
REGEXP_REPLACE	REGEXP_REPLACE
REGEXP_SUBSTR	REGEXP_SUBSTR
RELAY	RELAY
RELEASE	RELEASE
RELEASE_ALL_LOCKS	RELEASE_ALL_LOCKS
RELEASE_LOCK	RELEASE_LOCK
REMOVE	REMOVE
RENAME	RENAME
REORGANIZE	REORGANIZE
REPAIR	REPAIR
REPEATABLE	REPEATABLE
REPLACE	REPLACE
REQUIRE_ROW_FORMAT	REQUIRE_ROW_FORMAT
RESOURCE	RESOURCE
RESPECT	RESPECT
RESTART	RESTART
RESTRICT	RESTRICT
RETAIN	RETAIN
RETRY	RETRY
RETURNING	RETURNING
REUSE	REUSE
REVERT	REVERT
RIGHT	RIGHT
RLIKE	RLIKE
ROLE	ROLE
ROLLBACK	ROLLBACK
ROW	ROW
ROW_FORMAT	ROW_FORMAT
ROW_NUMBER	ROW_NUMBER
ROWS	ROWS
RTRIM	RTRIM
S3	S3
SAVEPOINT	SAVEPOINT
SCHEMA	SCHEMA
SCHEMAS	SCHEMAS
SECOND	SECOND
SECONDARY	SECONDARY
SECONDARY_ENGINE	SECONDARY_ENGINE
SECONDARY_ENGINE_ATTRIBUTE	SECONDARY_ENGINE_ATTRIBUTE
SECONDARY_LOAD	SECONDARY_LOAD
SECONDARY_UNLOAD	SECONDARY_UNLOAD
SECOND_MICROSECOND	SECOND_MICROSECOND
SECURITY	SECURITY
SELECT	SELECT
SEPARATOR	SEPARATOR
SEQUENCE	SEQUENCE
SERIALIZABLE	SERIALIZABLE
SESSION	SESSION
SET	SET
SHARE	SHARE
SHARED	SHARED
SHIFT_LEFT	SHIFT_LEFT
SHIFT_RIGHT	SHIFT_RIGHT
SHOW	SHOW
SIGNED	SIGNED
SIMPLE	SIMPLE
SKIP	SKIP
SLOW	SLOW
SMALLINT	SMALLINT
SNAPSHOT	SNAPSHOT
SPATIAL	SPATIAL
SQL	SQL
SQL_CACHE	SQL_CACHE
SQL_CALC_FOUND_ROWS	SQL_CALC_FOUND_ROWS
SQL_NO_CACHE	SQL_NO_CACHE
SQL_TSI_DAY	SQL_TSI_DAY
SQL_TSI_HOUR	SQL_TSI_HOUR
SQL_TSI_MICROSECOND	SQL_TSI_MICROSECOND
SQL_TSI_MINUTE	SQL_TSI_MINUTE
SQL_TSI_MONTH	SQL_TSI_MONTH
SQL_TSI_QUARTER	SQL_TSI_QUARTER
SQL_TSI_SECOND	SQL_TSI_SECOND
SQL_TSI_WEEK	SQL_TSI_WEEK
SQL_TSI_YEAR	SQL_TSI_YEAR
SRID	SRID
ST_Area	ST_Area
START	START
STARTING	STARTING
ST_AsBinary	ST_AsBinary
ST_AsGeoJSON	ST_AsGeoJSON
ST_AsText	ST_AsText
STATS_AUTO_RECALC	STATS_AUTO_RECALC
STATS_PERSISTENT	STATS_PERSISTENT
STATS_SAMPLE_PAGES	STATS_SAMPLE_PAGES
STATUS	STATUS
ST_Centroid	ST_Centroid
STD	STD
STDDEV	STDDEV
STDDEV_POP	STDDEV_POP
STDDEV_SAMP	STDDEV_SAMP
ST_Dimension	ST_Dimension
ST_EndPoint	ST_EndPoint
ST_Envelope	ST_Envelope
ST_ExteriorRing	ST_ExteriorRing
ST_GeoHash	ST_GeoHash
ST_GeometryCollectionFromText	ST_GeometryCollectionFromText
ST_GeometryCollectionFromWKB	ST_GeometryCollectionFromWKB
ST_GeometryFromText	ST_GeometryFromText
ST_GeometryFromWKB	ST_GeometryFromWKB
ST_GeometryN	ST_GeometryN
ST_GeometryType	ST_GeometryType
ST_GeomFromGeoJSON	ST_GeomFromGeoJSON
ST_InteriorRingN	ST_InteriorRingN
ST_IsClosed	ST_IsClosed
ST_IsEmpty	ST_IsEmpty
ST_IsSimple	ST_IsSimple
ST_LatFromGeoHash	ST_LatFromGeoHash
ST_Latitude	ST_Latitude
ST_Length	ST_Length
ST_LineStringFromText	ST_LineStringFromText
ST_LineStringFromWKB	ST_LineStringFromWKB
ST_LongFromGeoHash	ST_LongFromGeoHash
ST_Longitude	ST_Longitude
ST_MultiLineStringFromText	ST_MultiLineStringFromText
ST_MultiLineStringFromWKB	ST_MultiLineStringFromWKB
ST_MultiPointFromText	ST_MultiPointFromText
ST_MultiPointFromWKB	ST_MultiPointFromWKB
ST_MultiPolygonFromText	ST_MultiPolygonFromText
ST_MultiPolygonFromWKB	ST_MultiPolygonFromWKB
ST_NumGeometries	ST_NumGeometries
ST_NumInteriorRings	ST_NumInteriorRings
ST_NumPoints	ST_NumPoints
STORAGE	STORAGE
STORED	STORED
ST_PointFromGeoHash	ST_PointFromGeoHash
ST_PointFromText	ST_PointFromText
ST_PointFromWKB	ST_PointFromWKB
ST_PointN	ST_PointN
ST_PolygonFromText	ST_PolygonFromText
ST_PolygonFromWKB	ST_PolygonFromWKB
STRAIGHT_JOIN	STRAIGHT_JOIN
STREAM	STREAM
STRING	STRING
///STRING_TYPE_PREFIX_NON_KEYWORD	STRING_TYPE_PREFIX_NON_KEYWORD
ST_StartPoint	ST_StartPoint
ST_X	ST_X
ST_Y	ST_Y
SUBDATE	SUBDATE
SUBPARTITION	SUBPARTITION
SUBPARTITIONS	SUBPARTITIONS
SUBQUERY_AS_EXPR	SUBQUERY_AS_EXPR
SUBSTR	SUBSTR
SUBSTRING	SUBSTRING
SUM	SUM
SYSDATE	SYSDATE
SYSTEM	SYSTEM
TABLE	TABLE
TABLES	TABLES
TABLESPACE	TABLESPACE
TEMPORARY	TEMPORARY
TEMPTABLE	TEMPTABLE
TERMINATED	TERMINATED
TEXT	TEXT
THAN	THAN
THEN	THEN
THREAD_PRIORITY	THREAD_PRIORITY
THROTTLE	THROTTLE
TIES	TIES
TIME	TIME
TIMESTAMP	TIMESTAMP
TIMESTAMPADD	TIMESTAMPADD
TIMESTAMPDIFF	TIMESTAMPDIFF
TINYBLOB	TINYBLOB
TINYINT	TINYINT
TINYTEXT	TINYTEXT
TO	TO
TRADITIONAL	TRADITIONAL
TRAILING	TRAILING
TRANSACTION	TRANSACTION
TREE	TREE
TRIGGER	TRIGGER
TRIGGERS	TRIGGERS
TRIM	TRIM
TRUE	TRUE
TRUNCATE	TRUNCATE
UNARY	UNARY
UNBOUNDED	UNBOUNDED
UNCOMMITTED	UNCOMMITTED
UNDEFINED	UNDEFINED
UNDERSCORE_ARMSCII8	UNDERSCORE_ARMSCII8
UNDERSCORE_ASCII	UNDERSCORE_ASCII
UNDERSCORE_BIG5	UNDERSCORE_BIG5
UNDERSCORE_BINARY	UNDERSCORE_BINARY
UNDERSCORE_CP1250	UNDERSCORE_CP1250
UNDERSCORE_CP1251	UNDERSCORE_CP1251
UNDERSCORE_CP1256	UNDERSCORE_CP1256
UNDERSCORE_CP1257	UNDERSCORE_CP1257
UNDERSCORE_CP850	UNDERSCORE_CP850
UNDERSCORE_CP852	UNDERSCORE_CP852
UNDERSCORE_CP866	UNDERSCORE_CP866
UNDERSCORE_CP932	UNDERSCORE_CP932
UNDERSCORE_DEC8	UNDERSCORE_DEC8
UNDERSCORE_EUCJPMS	UNDERSCORE_EUCJPMS
UNDERSCORE_EUCKR	UNDERSCORE_EUCKR
UNDERSCORE_GB18030	UNDERSCORE_GB18030
UNDERSCORE_GB2312	UNDERSCORE_GB2312
UNDERSCORE_GBK	UNDERSCORE_GBK
UNDERSCORE_GEOSTD8	UNDERSCORE_GEOSTD8
UNDERSCORE_GREEK	UNDERSCORE_GREEK
UNDERSCORE_HEBREW	UNDERSCORE_HEBREW
UNDERSCORE_HP8	UNDERSCORE_HP8
UNDERSCORE_KEYBCS2	UNDERSCORE_KEYBCS2
UNDERSCORE_KOI8R	UNDERSCORE_KOI8R
UNDERSCORE_KOI8U	UNDERSCORE_KOI8U
UNDERSCORE_LATIN1	UNDERSCORE_LATIN1
UNDERSCORE_LATIN2	UNDERSCORE_LATIN2
UNDERSCORE_LATIN5	UNDERSCORE_LATIN5
UNDERSCORE_LATIN7	UNDERSCORE_LATIN7
UNDERSCORE_MACCE	UNDERSCORE_MACCE
UNDERSCORE_MACROMAN	UNDERSCORE_MACROMAN
UNDERSCORE_SJIS	UNDERSCORE_SJIS
UNDERSCORE_SWE7	UNDERSCORE_SWE7
UNDERSCORE_TIS620	UNDERSCORE_TIS620
UNDERSCORE_UCS2	UNDERSCORE_UCS2
UNDERSCORE_UJIS	UNDERSCORE_UJIS
UNDERSCORE_UTF16	UNDERSCORE_UTF16
UNDERSCORE_UTF16LE	UNDERSCORE_UTF16LE
UNDERSCORE_UTF32	UNDERSCORE_UTF32
UNDERSCORE_UTF8	UNDERSCORE_UTF8
UNDERSCORE_UTF8MB3	UNDERSCORE_UTF8MB3
UNDERSCORE_UTF8MB4	UNDERSCORE_UTF8MB4
UNICODE	UNICODE
UNION	UNION
UNIQUE	UNIQUE
UNLOCK	UNLOCK
UNSIGNED	UNSIGNED
UNTHROTTLE	UNTHROTTLE
///UNUSED	UNUSED
UPDATE	UPDATE
UpdateXML	UpdateXML
UPGRADE	UPGRADE
USE	USE
USER	USER
USER_RESOURCES	USER_RESOURCES
USING	USING
UTC_DATE	UTC_DATE
UTC_TIME	UTC_TIME
UTC_TIMESTAMP	UTC_TIMESTAMP
VALIDATION	VALIDATION
VALUE_ARG	VALUE_ARG
VALUES	VALUES
VARBINARY	VARBINARY
VARCHAR	VARCHAR
VARIABLES	VARIABLES
VARIANCE	VARIANCE
VAR_POP	VAR_POP
VAR_SAMP	VAR_SAMP
VCPU	VCPU
VEXPLAIN	VEXPLAIN
VGTID_EXECUTED	VGTID_EXECUTED
VIEW	VIEW
VINDEX	VINDEX
VINDEXES	VINDEXES
VIRTUAL	VIRTUAL
VISIBLE	VISIBLE
VITESS	VITESS
VITESS_KEYSPACES	VITESS_KEYSPACES
VITESS_METADATA	VITESS_METADATA
VITESS_MIGRATION	VITESS_MIGRATION
VITESS_MIGRATIONS	VITESS_MIGRATIONS
VITESS_REPLICATION_STATUS	VITESS_REPLICATION_STATUS
VITESS_SHARDS	VITESS_SHARDS
VITESS_TABLETS	VITESS_TABLETS
VITESS_TARGET	VITESS_TARGET
VITESS_THROTTLED_APPS	VITESS_THROTTLED_APPS
VITESS_THROTTLER	VITESS_THROTTLER
VSCHEMA	VSCHEMA
VSTREAM	VSTREAM
VTEXPLAIN	VTEXPLAIN
WAIT_FOR_EXECUTED_GTID_SET	WAIT_FOR_EXECUTED_GTID_SET
WAIT_UNTIL_SQL_THREAD_AFTER_GTIDS	WAIT_UNTIL_SQL_THREAD_AFTER_GTIDS
WARNINGS	WARNINGS
WEEK	WEEK
WEIGHT_STRING	WEIGHT_STRING
WHEN	WHEN
WHERE	WHERE
WINDOW	WINDOW
WINDOW_EXPR	WINDOW_EXPR
WITH	WITH
WITHOUT	WITHOUT
WORK	WORK
WRITE	WRITE
XOR	XOR
YEAR	YEAR
YEAR_MONTH	YEAR_MONTH
ZEROFILL	ZEROFILL


DECIMAL_NUM	DECIMAL

[0-9]+	INTEGRAL
[0-9]+"."[0-9]+	FLOAT
'(''|[^'\n])*'	STRING

/* Order matter if identifier comes before keywords they are classified as identifier */
"@"{basic_id}	AT_ID
"@@"{basic_id}	AT_AT_ID
{basic_id}	ID

%%
