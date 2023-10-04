//From: https://github.com/baidu/BaikalDB/blob/844a6d1fc5dc540dbb857f92f4c356f85e4787d7/include/sqlparser/sql_parse.y
// Copyright 2013 The ql Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSES/QL-LICENSE file.
// Copyright 2015 PingCAP, Inc.
// Modifications copyright (C) 2018-present, Baidu.com, Inc.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// See the License for the specific language governing permissions and
// limitations under the License.

/*Tokens*/
%token ADD
%token ALL
%token ALTER
//%token ANALYZE
%token AND
%token AS
%token ASC
%token BETWEEN
%token BIGINT
%token BINARY
%token BLOB
%token BY
%token CASCADE
%token CASE
//%token CHANGE
%token CHARACTER
%token CHAR
%token CHECK
%token COLLATE
%token COLUMN
%token CONSTRAINT
%token CONVERT
%token CREATE
%token CROSS
//%token CURRENT_USER
%token DATABASE
%token DATABASES
%token DECIMAL
%token DEFAULT
%token DELAYED
%token DELETE
%token DESC
%token DESCRIBE
%token DISTINCT
%token DISTINCTROW
//%token DIV
%token DOUBLE
%token DROP
%token DUAL
%token ELSE
%token ENCLOSED
%token ESCAPED
%token EXISTS
%token EXPLAIN
%token FALSE
%token FLOAT
%token FOR
%token FORCE
//%token FOREIGN
%token FROM
%token FULLTEXT
//%token GENERATED
//%token GRANT
%token GROUP
%token HAVING
%token HIGH_PRIORITY
%token IF
%token IGNORE
%token IN
%token INDEX
%token INFILE
%token INNER
%token INTEGER
%token INTERVAL
%token INTO
%token IS
%token INSERT
%token INT
%token INT1
%token INT2
%token INT3
%token INT4
%token INT8
%token JOIN
%token KEY
%token KEYS
%token KILL
%token LEFT
%token LIKE
%token EXACT_LIKE
%token LIMIT
%token LINES
%token LOAD
%token LOCK
%token LONGBLOB
%token LONGTEXT
%token LOW_PRIORITY
%token MATCH
%token MAXVALUE
%token MEDIUMBLOB
%token MEDIUMINT
%token MEDIUMTEXT
%token MOD
%token NOT
//%token NO_WRITE_TO_BINLOG
%token NULLX
%token NUMERIC
%token NVARCHAR
%token ON
//%token OPTION
%token OR
%token ORDER
%token OUTER
//%token PACK_KEYS
%token PARTITION
%token PRECISION
%token PROCEDURE
//%token SHARD_ROW_ID_BITS
%token RANGE
%token READ
%token REAL
//%token REFERENCES
%token REGEXP
%token RENAME
//%token REPEAT
%token REPLACE
%token MERGE
%token RESTRICT
//%token REVOKE
%token RIGHT
%token RLIKE
%token SELECT
%token SET
%token SHOW
%token SMALLINT
//%token SQL
%token SQL_CALC_FOUND_ROWS
%token STARTING
%token STRAIGHT_JOIN
%token TABLE
//%token STORED
%token TERMINATED
%token OPTIONALLY
%token THEN
%token TINYBLOB
%token TINYINT
%token TINYTEXT
%token TO
//%token TRIGGER
%token TRUE
%token UNIQUE
%token UNION
//%token UNLOCK
%token UNSIGNED
%token UPDATE
//%token USAGE
%token USE
%token USING
//%token UTC_DATE
//%token UTC_TIME
%token VALUES
%token LONG
%token VARCHAR
%token VARBINARY
%token _BINARY
%token VIRTUAL
%token WHEN
%token WHERE
//%token WRITE
//%token WITH
%token XOR
%token ZEROFILL
%token NATURAL
%token BOTH
%token CURRENT_DATE
%token CURRENT_TIME
%token DAY_HOUR
%token DAY_MICROSECOND
%token DAY_MINUTE
%token DAY_SECOND
%token HOUR_MICROSECOND
%token HOUR_MINUTE
%token HOUR_SECOND
%token LEADING
%token MINUTE_MICROSECOND
%token MINUTE_SECOND
%token PRIMARY
%token SECOND_MICROSECOND
%token TRAILING
%token YEAR_MONTH
%token ACTION
%token AFTER
%token AGAINST
%token ALWAYS
%token ALGORITHM
%token ANY
%token ASCII
%token AUTO_INCREMENT
%token AVG_ROW_LENGTH
%token AVG
%token BEGINX
%token WORK
%token BINLOG
%token BIT
%token BOOLEAN
%token BOOL
%token BTREE
%token BYTE
%token CASCADED
%token CHARSET
%token CHECKSUM
%token CLEANUP
%token CLIENT
%token COALESCE
%token COLLATION
%token COLUMNS
%token COMMENT
%token COMMIT
%token COMMITTED
%token COMPACT
%token COMPRESSED
%token COMPRESSION
%token CONNECTION
%token CONSISTENT
%token DAY
%token DATA
%token DATE
%token DATETIME
%token DEALLOCATE
%token DEFINER
%token DELAY_KEY_WRITE
%token DISABLE
%token DO
%token DUPLICATE
%token DYNAMIC
%token ENABLE
%token END
%token ENGINE
%token ENGINES
%token ENUM
%token EVENT
%token EVENTS
%token ESCAPE
%token EXCLUSIVE
%token EXECUTE
%token FIELDS
%token FIRST
%token FIXED
%token FLUSH
%token FORMAT
%token FULL
%token FUNCTION
%token GRANTS
%token HASH
%token HOUR
%token IDENTIFIED
%token ISOLATION
%token INDEXES
%token INVOKER
%token JSON
%token KEY_BLOCK_SIZE
%token DYNAMIC_PARTITION_ATTR
%token LANGUAGE
%token LOCAL
%token LESS
%token LEVEL
%token MASTER
%token MICROSECOND
%token MINUTE
%token MODE
%token MODIFY
%token MONTH
%token MAX_ROWS
%token MAX_CONNECTIONS_PER_HOUR
%token MAX_QUERIES_PER_HOUR
%token MAX_UPDATES_PER_HOUR
%token MAX_USER_CONNECTIONS
%token MIN_ROWS
%token NAMES
%token NATIONAL
%token NO
%token NONE
%token OFFSET
%token ONLY
%token PASSWORD
%token PARTITIONS
%token PLUGINS
%token PREPARE
%token PRIVILEGES
%token PROCESS
%token PROCESSLIST
%token PROFILES
%token QUARTER
%token QUERY
%token QUERIES
%token QUICK
%token RECOVER
%token RESTORE
%token REDUNDANT
%token RELOAD
%token REPEATABLE
%token REPLICATION
%token REVERSE
%token ROLLBACK
%token ROUTINE
%token ROW
%token ROW_COUNT
%token ROW_FORMAT
%token SECOND
%token SECURITY
%token SEPARATOR
%token SERIALIZABLE
%token SESSION
%token SHARE
%token SHARED
%token SIGNED
%token SLAVE
%token SNAPSHOT
%token SQL_CACHE
%token SQL_NO_CACHE
%token START
%token STATS_PERSISTENT
%token STATUS
%token SUPER
%token SOME
%token SWAP
%token GLOBAL
%token TABLES
%token TEMPORARY
%token TEMPTABLE
%token TEXT
%token THAN
%token TIME
%token TIMESTAMP
%token TRACE
%token TRANSACTION
%token TRIGGERS
%token TRUNCATE
%token UNCOMMITTED
%token UNKNOWN
%token USER
%token UNDEFINED
%token VALUE
%token VARIABLES
%token VIEW
%token VECTOR
%token WARNINGS
%token WEEK
%token YEAR
%token HLL
%token BITMAP
%token TDIGEST
%token LEARNER
%token ADDDATE
%token BIT_AND
%token BIT_OR
%token BIT_XOR
%token CAST
%token COUNT
%token CURDATE
%token CURTIME
%token CURRENT_TIMESTAMP
%token DATE_ADD
%token DATE_SUB
%token EXTRACT
%token GROUP_CONCAT
%token LOCALTIME
%token LOCALTIMESTAMP
%token MAX
%token MID
%token MIN
%token NOW
%token UTC_TIMESTAMP
%token POSITION
%token SESSION_USER
%token STD
%token STDDEV
%token STDDEV_POP
%token STDDEV_SAMP
%token SUBDATE
%token SUBSTR
%token SUBSTRING
%token TIMESTAMPADD
%token TIMESTAMPDIFF
%token SUM
%token SYSDATE
%token SYSTEM_USER
%token TRIM
%token VARIANCE
%token VAR_POP
%token VAR_SAMP
%token USER_AGG
%token EQ_OP
%token ASSIGN_OP
%token MOD_OP
%token GE_OP
%token GT_OP
%token LE_OP
%token LT_OP
%token NE_OP
//%token AND_OP
//%token OR_OP
%token NOT_OP
%token LS_OP
%token RS_OP
//%token CHINESE_DOT
%token IDENT
%token STRING_LIT
%token INTEGER_LIT
%token DECIMAL_LIT
%token PLACE_HOLDER_LIT
%token empty
%token lowerThanSetKeyword
%token lowerThanKey
%token tableRefPriority
%token '|'
%token '&'
%token '+'
%token '-'
%token '*'
%token '/'
%token '^'
%token '~'
%token NEG
%token '.'
%token '('
%token lowerThanComma
%token ','
%token ';'
%token ')'
%token '{'
%token '}'
%token ESCAPE
%token '['

%nonassoc /*1*/ empty
%nonassoc /*2*/ lowerThanSetKeyword
%nonassoc /*3*/ SET
%nonassoc /*4*/ lowerThanKey
%nonassoc /*5*/ KEY
%nonassoc /*6*/ SQL_CACHE SQL_NO_CACHE
%left /*7*/ tableRefPriority
%left /*8*/ CROSS INNER JOIN LEFT RIGHT STRAIGHT_JOIN NATURAL FULL
%precedence /*9*/ ON USING
%left /*10*/ OR XOR
%left /*11*/ AND
%left /*12*/ IN IS LIKE EQ_OP GE_OP GT_OP LE_OP LT_OP NE_OP
%left /*13*/ '|'
%left /*14*/ '&'
%left /*15*/ LS_OP RS_OP
%left /*16*/ '+' '-'
%left /*17*/ MOD MOD_OP '*' '/'
%left /*18*/ '^'
%left /*19*/ BINARY COLLATE
%right /*20*/ NOT NOT_OP '~' NEG
%right /*21*/ '.'
%nonassoc /*22*/ '('
%nonassoc /*23*/ QUICK
%precedence /*24*/ lowerThanComma
%precedence /*25*/ ','

%start MultiStmt

%%

MultiStmt :
	Statement
	| MultiStmt ';' Statement
	| MultiStmt ';'
	;

Statement :
	InsertStmt
	| ReplaceStmt
	| UpdateStmt
	| DeleteStmt
	| TruncateStmt
	| CreateTableStmt
	| SelectStmt
	| UnionStmt
	| DropTableStmt
	| RestoreTableStmt
	| CreateDatabaseStmt
	| DropDatabaseStmt
	| StartTransactionStmt
	| CommitTransactionStmt
	| RollbackTransactionStmt
	| SetStmt
	| ShowStmt
	| AlterTableStmt
	| NewPrepareStmt
	| ExecPrepareStmt
	| DeallocPrepareStmt
	| ExplainStmt
	| KillStmt
	| LoadDataStmt
	;

InsertStmt :
	INSERT PriorityOpt IgnoreOptional MergeOptional IntoOpt TableName PartitionNameListOpt InsertValues OnDuplicateKeyUpdate
	;

ReplaceStmt :
	REPLACE PriorityOpt IntoOpt TableName PartitionNameListOpt InsertValues
	;

PriorityOpt :
	/*empty*/
	| LOW_PRIORITY
	| HIGH_PRIORITY
	| DELAYED
	;

IgnoreOptional :
	/*empty*/
	| IGNORE
	;

MergeOptional :
	/*empty*/
	| MERGE
	;

QuickOptional :
	%prec empty /*1N*/ /*empty*/
	| QUICK /*23N*/
	;

IntoOpt :
	/*empty*/
	| INTO
	;

InsertValues :
	'(' /*22N*/ ColumnNameListOpt ')' values_sym ValueList
	| '(' /*22N*/ ColumnNameListOpt ')' SelectStmt
	| '(' /*22N*/ ColumnNameListOpt ')' '(' /*22N*/ SelectStmt ')'
	| '(' /*22N*/ ColumnNameListOpt ')' UnionStmt
	| '(' /*22N*/ SelectStmt ')'
	| SelectStmt
	| '(' /*22N*/ UnionStmt ')'
	| UnionStmt
	| values_sym ValueList
	| SET /*3N*/ AssignmentList
	;

values_sym :
	VALUE
	| VALUES
	;

OnDuplicateKeyUpdate :
	/*empty*/
	| ON /*9P*/ DUPLICATE KEY /*5N*/ UPDATE AssignmentList
	;

AssignmentList :
	Assignment
	| AssignmentList ',' /*25P*/ Assignment
	;

Assignment :
	ColumnName EqAssign Expr
	;

EqAssign :
	EQ_OP /*12L*/
	| ASSIGN_OP
	;

ValueList :
	'(' /*22N*/ ExprList ')'
	| ValueList ',' /*25P*/ '(' /*22N*/ ExprList ')'
	;

RowExprList :
	RowExpr
	| RowExprList ',' /*25P*/ RowExpr
	;

RowExpr :
	'(' /*22N*/ ExprList ',' /*25P*/ Expr ')'
	| ROW '(' /*22N*/ ExprList ',' /*25P*/ Expr ')'
	;

ExprList :
	Expr
	| ExprList ',' /*25P*/ Expr
	;

ColumnNameListOpt :
	/*empty*/
	| ColumnNameList
	;

ColumnNameList :
	ColumnName
	| ColumnNameList ',' /*25P*/ ColumnName
	;

ColumnName :
	AllIdent
	| AllIdent '.' /*21R*/ AllIdent
	| AllIdent '.' /*21R*/ AllIdent '.' /*21R*/ AllIdent
	;

TableName :
	AllIdent
	| AllIdent '.' /*21R*/ AllIdent
	;

TableNameList :
	TableName
	| TableNameList ',' /*25P*/ TableName
	;

UpdateStmt :
	UPDATE PriorityOpt IgnoreOptional TableRef SET /*3N*/ AssignmentList WhereClauseOptional OrderByOptional LimitClause
	| UPDATE PriorityOpt IgnoreOptional TableRefs SET /*3N*/ AssignmentList WhereClauseOptional
	;

TruncateStmt :
	TRUNCATE TABLE TableName PartitionNameListOpt
	| TRUNCATE TableName PartitionNameListOpt
	;

DeleteStmt :
	DELETE PriorityOpt QuickOptional IgnoreOptional FROM TableName PartitionNameListOpt WhereClauseOptional OrderByOptional LimitClause
	| DELETE PriorityOpt QuickOptional IgnoreOptional TableNameList FROM TableRefs WhereClauseOptional
	;

TableRefs :
	EscapedTableRef
	| TableRefs ',' /*25P*/ EscapedTableRef
	;

EscapedTableRef :
	TableRef %prec lowerThanSetKeyword /*2N*/
	| '{' AllIdent TableRef '}'
	;

TableRef :
	TableFactor
	| JoinTable
	;

TableFactor :
	TableName PartitionNameListOpt TableAsNameOpt IndexHintListOpt
	| '(' /*22N*/ SelectStmt ')' TableAsName
	| '(' /*22N*/ UnionStmt ')' TableAsName
	| '(' /*22N*/ TableRefs ')'
	;

PartitionNameListOpt :
	/*empty*/
	| PARTITION '(' /*22N*/ PartitionNameList ')'
	;

PartitionNameList :
	AllIdent
	| PartitionNameList ',' /*25P*/ AllIdent
	;

TableAsNameOpt :
	/*empty*/
	| TableAsName
	;

TableAsName :
	AllIdent
	| AS AllIdent
	;

IndexHintListOpt :
	/*empty*/
	| IndexHintList
	;

ForceOrNot :
	/*empty*/
	| FORCE
	;

IndexHintList :
	IndexHint
	| IndexHintList IndexHint
	;

IndexHint :
	IndexHintType IndexHintScope '(' /*22N*/ IndexNameList ')'
	;

IndexHintType :
	USE KeyOrIndex
	| IGNORE KeyOrIndex
	| FORCE KeyOrIndex
	;

KeyOrIndex :
	KEY /*5N*/
	| INDEX
	;

KeyOrIndexOpt :
	/*empty*/
	| KeyOrIndex
	;

IndexHintScope :
	/*empty*/
	| FOR JOIN /*8L*/
	| FOR ORDER BY
	| FOR GROUP BY
	;

IndexNameList :
	/*empty*/
	| AllIdentOrPrimary
	| IndexNameList ',' /*25P*/ AllIdentOrPrimary
	;

AllIdentOrPrimary :
	AllIdent
	| PRIMARY
	;

JoinTable :
	TableRef CrossOpt TableRef %prec tableRefPriority /*7L*/
	| TableRef CrossOpt TableRef ON /*9P*/ Expr
	| TableRef CrossOpt TableRef USING /*9P*/ '(' /*22N*/ ColumnNameList ')'
	| TableRef JoinType OuterOpt JOIN /*8L*/ TableRef ON /*9P*/ Expr
	| TableRef JoinType OuterOpt JOIN /*8L*/ TableRef USING /*9P*/ '(' /*22N*/ ColumnNameList ')'
	| TableRef STRAIGHT_JOIN /*8L*/ TableRef
	| TableRef STRAIGHT_JOIN /*8L*/ TableRef ON /*9P*/ Expr
	| TableRef NATURAL /*8L*/ JOIN /*8L*/ TableRef
	| TableRef NATURAL /*8L*/ INNER /*8L*/ JOIN /*8L*/ TableRef
	| TableRef NATURAL /*8L*/ JoinType OuterOpt JOIN /*8L*/ TableRef
	;

JoinType :
	LEFT /*8L*/
	| RIGHT /*8L*/
	;

OuterOpt :
	/*empty*/
	| OUTER
	;

CrossOpt :
	JOIN /*8L*/
	| CROSS /*8L*/ JOIN /*8L*/
	| INNER /*8L*/ JOIN /*8L*/
	;

LimitClause :
	/*empty*/
	| LIMIT SimpleExpr
	| LIMIT SimpleExpr ',' /*25P*/ SimpleExpr
	| LIMIT SimpleExpr OFFSET SimpleExpr
	;

WhereClause :
	WHERE Expr
	;

WhereClauseOptional :
	/*empty*/
	| WhereClause
	;

HavingClauseOptional :
	/*empty*/
	| HAVING Expr
	;

OrderByOptional :
	/*empty*/
	| OrderBy
	;

OrderBy :
	ORDER BY ByList
	;

GroupByOptional :
	/*empty*/
	| GroupBy
	;

GroupBy :
	GROUP BY ByList
	;

ByList :
	ByItem
	| ByList ',' /*25P*/ ByItem
	;

ByItem :
	Expr Order
	;

Order :
	/*empty*/
	| ASC
	| DESC
	;

SelectStmtOpts :
	DefaultFalseDistinctOpt PriorityOpt SelectStmtStraightJoin SelectStmtSQLCache SelectStmtCalcFoundRows
	;

SelectStmtBasic :
	SELECT SelectStmtOpts SelectFieldList
	;

SelectStmtFromDual :
	SelectStmtBasic FromDual WhereClauseOptional
	;

SelectStmtFromTable :
	SelectStmtBasic FROM TableRefs WhereClauseOptional GroupByOptional HavingClauseOptional
	;

SelectStmt :
	SelectStmtBasic OrderByOptional LimitClause SelectLockOpt
	| SelectStmtFromDual LimitClause SelectLockOpt
	| SelectStmtFromTable OrderByOptional LimitClause SelectLockOpt
	;

SelectLockOpt :
	/*empty*/
	| FOR UPDATE
	| LOCK IN /*12L*/ SHARE MODE
	;

FromDual :
	FROM DUAL
	;

SelectStmtCalcFoundRows :
	/*empty*/
	| SQL_CALC_FOUND_ROWS
	;

SelectStmtSQLCache :
	%prec empty /*1N*/ /*empty*/
	| SQL_CACHE /*6N*/
	| SQL_NO_CACHE /*6N*/
	;

SelectStmtStraightJoin :
	/*empty*/
	| STRAIGHT_JOIN /*8L*/
	;

SelectFieldList :
	SelectField
	| SelectFieldList ',' /*25P*/ SelectField
	;

SelectField :
	'*' /*17L*/
	| AllIdent '.' /*21R*/ '*' /*17L*/
	| AllIdent '.' /*21R*/ AllIdent '.' /*21R*/ '*' /*17L*/
	| Expr FieldAsNameOpt
	| '{' AllIdent Expr '}' FieldAsNameOpt
	;

FieldAsNameOpt :
	/*empty*/
	| FieldAsName
	;

FieldAsName :
	AllIdent
	| AS AllIdent
	| STRING_LIT
	| AS STRING_LIT
	;

SubSelect :
	'(' /*22N*/ SelectStmt ')'
	| '(' /*22N*/ UnionStmt ')'
	;

UnionStmt :
	UnionClauseList UNION UnionOpt SelectStmtBasic OrderByOptional LimitClause SelectLockOpt
	| UnionClauseList UNION UnionOpt SelectStmtFromTable OrderByOptional LimitClause SelectLockOpt
	| UnionClauseList UNION UnionOpt '(' /*22N*/ SelectStmt ')' OrderByOptional LimitClause SelectLockOpt
	;

UnionClauseList :
	UnionSelect
	| UnionClauseList UNION UnionOpt UnionSelect
	;

UnionSelect :
	SelectStmt
	| '(' /*22N*/ SelectStmt ')'
	;

UnionOpt :
	DefaultTrueDistinctOpt
	;

Expr :
	Operators
	| PredicateOp
	| SimpleExpr
	;

FunctionCall :
	BuildInFun
	| IDENT '(' /*22N*/ ')'
	| IDENT '(' /*22N*/ ExprList ')'
	;

BuildInFun :
	SumExpr
	| FunctionCallNonKeyword
	| FunctionCallKeyword
	;

FuncDatetimePrecListOpt :
	/*empty*/
	| INTEGER_LIT
	;

FunctionNameDateArithMultiForms :
	ADDDATE
	| SUBDATE
	;

FunctionNameDateArith :
	DATE_ADD
	| DATE_SUB
	;

FunctionNameSubstring :
	SUBSTR
	| SUBSTRING
	;

TimestampUnit :
	MICROSECOND
	| SECOND
	| MINUTE
	| HOUR
	| DAY
	| WEEK
	| MONTH
	| QUARTER
	| YEAR
	;

TimeUnit :
	MICROSECOND
	| SECOND
	| MINUTE
	| HOUR
	| DAY
	| WEEK
	| MONTH
	| QUARTER
	| YEAR
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

TrimDirection :
	BOTH
	| LEADING
	| TRAILING
	;

FunctionNameCurtime :
	CURTIME
	| CURRENT_TIME
	;

FunctionaNameCurdate :
	CURDATE
	| CURRENT_DATE
	;

FunctionaNameDateRelate :
	HOUR
	| DAY
	| MONTH
	| YEAR
	| DATE
	;

FunctionCallNonKeyword :
	FunctionNameCurtime '(' /*22N*/ FuncDatetimePrecListOpt ')'
	| CURRENT_TIME
	| FunctionaNameCurdate '(' /*22N*/ ')'
	| CURRENT_DATE
	| FunctionaNameDateRelate '(' /*22N*/ Expr ')'
	| WEEK '(' /*22N*/ Expr ',' /*25P*/ Expr ')'
	| WEEK '(' /*22N*/ Expr ')'
	| SYSDATE '(' /*22N*/ FuncDatetimePrecListOpt ')'
	| NOW '(' /*22N*/ ')'
	| NOW '(' /*22N*/ INTEGER_LIT ')'
	| UTC_TIMESTAMP '(' /*22N*/ ')'
	| TIMESTAMP '(' /*22N*/ ExprList ')'
	| FunctionNameDateArithMultiForms '(' /*22N*/ Expr ',' /*25P*/ Expr ')'
	| FunctionNameDateArithMultiForms '(' /*22N*/ Expr ',' /*25P*/ INTERVAL Expr TimeUnit ')'
	| FunctionNameDateArith '(' /*22N*/ Expr ',' /*25P*/ INTERVAL Expr TimeUnit ')'
	| CONVERT '(' /*22N*/ Expr ',' /*25P*/ DATE ')'
	| CAST '(' /*22N*/ Expr AS DATE ')'
	| CONVERT '(' /*22N*/ Expr ',' /*25P*/ DATETIME ')'
	| CAST '(' /*22N*/ Expr AS DATETIME ')'
	| CONVERT '(' /*22N*/ Expr ',' /*25P*/ TIME ')'
	| CAST '(' /*22N*/ Expr AS TIME ')'
	| CONVERT '(' /*22N*/ Expr ',' /*25P*/ StringType ')'
	| CAST '(' /*22N*/ Expr AS StringType ')'
	| CONVERT '(' /*22N*/ Expr ',' /*25P*/ SIGNED INTEGER ')'
	| CONVERT '(' /*22N*/ Expr ',' /*25P*/ SIGNED ')'
	| CAST '(' /*22N*/ Expr AS SIGNED INTEGER ')'
	| CAST '(' /*22N*/ Expr AS SIGNED ')'
	| CONVERT '(' /*22N*/ Expr ',' /*25P*/ UNSIGNED INTEGER ')'
	| CONVERT '(' /*22N*/ Expr ',' /*25P*/ UNSIGNED ')'
	| CAST '(' /*22N*/ Expr AS UNSIGNED INTEGER ')'
	| CAST '(' /*22N*/ Expr AS UNSIGNED ')'
	| CONVERT '(' /*22N*/ Expr ',' /*25P*/ BINARY /*19L*/ ')'
	| CAST '(' /*22N*/ Expr AS BINARY /*19L*/ ')'
	| CONVERT '(' /*22N*/ Expr ',' /*25P*/ DECIMAL ')'
	| CAST '(' /*22N*/ Expr AS DECIMAL ')'
	| USER '(' /*22N*/ ')'
	| SYSTEM_USER '(' /*22N*/ ')'
	| SESSION_USER '(' /*22N*/ ')'
	| EXTRACT '(' /*22N*/ TimeUnit FROM Expr ')'
	| POSITION '(' /*22N*/ Expr IN /*12L*/ Expr ')'
	| FunctionNameSubstring '(' /*22N*/ Expr ',' /*25P*/ Expr ')'
	| FunctionNameSubstring '(' /*22N*/ Expr FROM Expr ')'
	| FunctionNameSubstring '(' /*22N*/ Expr ',' /*25P*/ Expr ',' /*25P*/ Expr ')'
	| FunctionNameSubstring '(' /*22N*/ Expr FROM Expr FOR Expr ')'
	| TIMESTAMPADD '(' /*22N*/ TimestampUnit ',' /*25P*/ Expr ',' /*25P*/ Expr ')'
	| TIMESTAMPDIFF '(' /*22N*/ TimestampUnit ',' /*25P*/ Expr ',' /*25P*/ Expr ')'
	| TRIM '(' /*22N*/ Expr ')'
	| TRIM '(' /*22N*/ Expr FROM Expr ')'
	| TRIM '(' /*22N*/ TrimDirection FROM Expr ')'
	| TRIM '(' /*22N*/ TrimDirection Expr FROM Expr ')'
	| MOD /*17L*/ '(' /*22N*/ Expr ',' /*25P*/ Expr ')'
	;

FunctionCallKeyword :
	VALUES '(' /*22N*/ ColumnName ')'
	| LEFT /*8L*/ '(' /*22N*/ Expr ',' /*25P*/ Expr ')'
	| RIGHT /*8L*/ '(' /*22N*/ Expr ',' /*25P*/ Expr ')'
	| REPLACE '(' /*22N*/ Expr ',' /*25P*/ Expr ',' /*25P*/ Expr ')'
	| IF '(' /*22N*/ Expr ',' /*25P*/ Expr ',' /*25P*/ Expr ')'
	| DATABASE '(' /*22N*/ ')'
	| DEFAULT '(' /*22N*/ ColumnName ')'
	| FunctionNameCurTimestamp
	| FunctionNameCurTimestamp '(' /*22N*/ ')'
	| FunctionNameCurTimestamp '(' /*22N*/ INTEGER_LIT ')'
	;

SumExpr :
	AVG '(' /*22N*/ BuggyDefaultFalseDistinctOpt Expr ')'
	| BIT_AND '(' /*22N*/ Expr ')'
	| BIT_AND '(' /*22N*/ ALL Expr ')'
	| BIT_OR '(' /*22N*/ Expr ')'
	| BIT_OR '(' /*22N*/ ALL Expr ')'
	| BIT_XOR '(' /*22N*/ Expr ')'
	| BIT_XOR '(' /*22N*/ ALL Expr ')'
	| COUNT '(' /*22N*/ DistinctKwd ExprList ')'
	| COUNT '(' /*22N*/ ALL Expr ')'
	| COUNT '(' /*22N*/ Expr ')'
	| COUNT '(' /*22N*/ '*' /*17L*/ ')'
	| MAX '(' /*22N*/ BuggyDefaultFalseDistinctOpt Expr ')'
	| MIN '(' /*22N*/ BuggyDefaultFalseDistinctOpt Expr ')'
	| SUM '(' /*22N*/ BuggyDefaultFalseDistinctOpt Expr ')'
	| GROUP_CONCAT '(' /*22N*/ BuggyDefaultFalseDistinctOpt ExprList OrderByOptional SeparatorOpt ')'
	| USER_AGG '(' /*22N*/ Expr ')'
	;

SeparatorOpt :
	/*empty*/
	| SEPARATOR STRING_LIT
	;

DistinctKwd :
	DISTINCT
	| DISTINCTROW
	;

DistinctOpt :
	ALL
	| DistinctKwd
	;

DefaultFalseDistinctOpt :
	/*empty*/
	| DistinctOpt
	;

DefaultTrueDistinctOpt :
	/*empty*/
	| DistinctOpt
	;

BuggyDefaultFalseDistinctOpt :
	DefaultFalseDistinctOpt
	| DistinctKwd ALL
	;

AllIdent :
	IDENT
	| ACTION
	| AFTER
	| ALWAYS
	| ALGORITHM
	| ANY
	| ASCII
	| AUTO_INCREMENT
	| AVG_ROW_LENGTH
	| AVG
	| BEGINX
	| WORK
	| BINLOG
	| BIT
	| BOOLEAN
	| BOOL
	| BTREE
	| BYTE
	| CASCADED
	| CHARSET
	| CHECKSUM
	| CLEANUP
	| CLIENT
	| COALESCE
	| COLLATION
	| COLUMNS
	| COMMENT
	| COMMIT
	| COMMITTED
	| COMPACT
	| COMPRESSED
	| COMPRESSION
	| CONNECTION
	| CONSISTENT
	| DAY
	| DATA
	| DATE
	| DATETIME
	| DEALLOCATE
	| DEFINER
	| DELAY_KEY_WRITE
	| DISABLE
	| DO
	| DUPLICATE
	| DYNAMIC
	| ENABLE
	| END
	| ENGINE
	| ENGINES
	| ENUM
	| EVENT
	| EVENTS
	| ESCAPE
	| EXCLUSIVE
	| EXECUTE
	| FIELDS
	| FIRST
	| FIXED
	| FLUSH
	| FORMAT
	| FULL /*8L*/
	| FUNCTION
	| GRANTS
	| HASH
	| HOUR
	| IDENTIFIED
	| ISOLATION
	| INDEXES
	| INVOKER
	| JSON
	| KEY_BLOCK_SIZE
	| DYNAMIC_PARTITION_ATTR
	| LANGUAGE
	| LOCAL
	| LESS
	| LEVEL
	| MASTER
	| MICROSECOND
	| MINUTE
	| MODE
	| MODIFY
	| MONTH
	| MAX_ROWS
	| MAX_CONNECTIONS_PER_HOUR
	| MAX_QUERIES_PER_HOUR
	| MAX_UPDATES_PER_HOUR
	| MAX_USER_CONNECTIONS
	| MERGE
	| MIN_ROWS
	| NAMES
	| NATIONAL
	| NO
	| NONE
	| OFFSET
	| ONLY
	| PASSWORD
	| PARTITIONS
	| PLUGINS
	| PREPARE
	| PRIVILEGES
	| PROCESS
	| PROCESSLIST
	| PROFILES
	| QUARTER
	| QUERY
	| QUERIES
	| QUICK /*23N*/
	| RECOVER
	| RESTORE
	| REDUNDANT
	| RELOAD
	| REPEATABLE
	| REPLICATION
	| REVERSE
	| ROLLBACK
	| ROUTINE
	| ROW
	| ROW_COUNT
	| ROW_FORMAT
	| SECOND
	| SECURITY
	| SEPARATOR
	| SERIALIZABLE
	| SESSION
	| SHARE
	| SHARED
	| SIGNED
	| SLAVE
	| SNAPSHOT
	| SQL_CACHE /*6N*/
	| SQL_NO_CACHE /*6N*/
	| START
	| STATS_PERSISTENT
	| STATUS
	| SUPER
	| SOME
	| GLOBAL
	| TABLES
	| TEMPORARY
	| TEMPTABLE
	| TEXT
	| THAN
	| TIME
	| TIMESTAMP
	| TRACE
	| TRANSACTION
	| TRIGGERS
	| TRUNCATE
	| UNCOMMITTED
	| UNKNOWN
	| USER
	| UNDEFINED
	| VALUE
	| VARIABLES
	| VIEW
	| WARNINGS
	| WEEK
	| YEAR
	| ADDDATE
	| BIT_AND
	| BIT_OR
	| BIT_XOR
	| CAST
	| COUNT
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
	| UTC_TIMESTAMP
	| POSITION
	| SESSION_USER
	| STD
	| STDDEV
	| STDDEV_POP
	| STDDEV_SAMP
	| SUBDATE
	| SUBSTR
	| SUBSTRING
	| TIMESTAMPADD
	| TIMESTAMPDIFF
	| SUM
	| SYSDATE
	| SYSTEM_USER
	| TRIM
	| VARIANCE
	| VAR_POP
	| VAR_SAMP
	;

NumLiteral :
	INTEGER_LIT
	| DECIMAL_LIT
	;

Literal :
	NULLX
	| TRUE
	| FALSE
	| NumLiteral
	| STRING_LIT
	| _BINARY STRING_LIT
	;

SimpleExpr :
	Literal
	| PLACE_HOLDER_LIT
	| ColumnName
	| RowExpr %prec empty /*1N*/
	| FunctionCall
	| SubSelect
	| EXISTS SubSelect
	| '-' /*16L*/ SimpleExpr %prec NEG /*20R*/
	| '+' /*16L*/ SimpleExpr %prec NEG /*20R*/
	| NOT /*20R*/ SimpleExpr
	| NOT_OP /*20R*/ SimpleExpr
	| MATCH '(' /*22N*/ ColumnNameList ')' AGAINST '(' /*22N*/ SimpleExpr FulltextSearchModifierOpt ')'
	| '~' /*20R*/ SimpleExpr
	| '(' /*22N*/ Expr ')'
	| CASE Expr WhenClauseList ElseOpt END
	| CASE WhenClauseList ElseOpt END
	;

FulltextSearchModifierOpt :
	/*empty*/
	| IN /*12L*/ NATURAL /*8L*/ LANGUAGE MODE
	| IN /*12L*/ BOOLEAN MODE
	| IN /*12L*/ VECTOR MODE
	;

WhenClauseList :
	WhenClause
	| WhenClauseList WhenClause
	;

WhenClause :
	WHEN Expr THEN Expr
	;

ElseOpt :
	/*empty*/
	| ELSE Expr
	;

Operators :
	CompareSubqueryExpr
	| Expr '+' /*16L*/ Expr
	| Expr '-' /*16L*/ Expr
	| Expr '*' /*17L*/ Expr
	| Expr '/' /*17L*/ Expr
	| Expr MOD /*17L*/ Expr
	| Expr MOD_OP /*17L*/ Expr
	| Expr LS_OP /*15L*/ Expr
	| Expr RS_OP /*15L*/ Expr
	| Expr '&' /*14L*/ Expr
	| Expr '|' /*13L*/ Expr
	| Expr '^' /*18L*/ Expr
	| Expr CompareOp Expr %prec EQ_OP /*12L*/
	| Expr AND /*11L*/ Expr
	| Expr OR /*10L*/ Expr
	| Expr XOR /*10L*/ Expr
	| BINARY /*19L*/ Expr
	| Expr COLLATE /*19L*/ StringName
	;

CompareOp :
	GE_OP /*12L*/
	| GT_OP /*12L*/
	| LE_OP /*12L*/
	| LT_OP /*12L*/
	| NE_OP /*12L*/
	| EQ_OP /*12L*/
	;

CompareSubqueryExpr :
	Expr CompareOp AnyOrAll SubSelect %prec EQ_OP /*12L*/
	;

PredicateOp :
	Expr IsOrNot NULLX %prec IS /*12L*/
	| Expr IsOrNot TRUE %prec IS /*12L*/
	| Expr IsOrNot FALSE %prec IS /*12L*/
	| Expr IsOrNot UNKNOWN %prec IS /*12L*/
	| SimpleExpr InOrNot '(' /*22N*/ ExprList ')' %prec IN /*12L*/
	| RowExpr InOrNot '(' /*22N*/ RowExprList ')' %prec IN /*12L*/
	| RowExpr InOrNot SubSelect %prec IN /*12L*/
	| SimpleExpr InOrNot SubSelect %prec IN /*12L*/
	| SimpleExpr LikeOrNot SimpleExpr LikeEscapeOpt %prec LIKE /*12L*/
	| SimpleExpr EXACT_LIKE SimpleExpr LikeEscapeOpt %prec LIKE /*12L*/
	| SimpleExpr RegexpOrNot SimpleExpr %prec LIKE /*12L*/
	| SimpleExpr BetweenOrNot SimpleExpr AND /*11L*/ SimpleExpr
	;

IsOrNot :
	IS /*12L*/
	| IS /*12L*/ NOT /*20R*/
	;

InOrNot :
	IN /*12L*/
	| NOT /*20R*/ IN /*12L*/
	;

AnyOrAll :
	ANY
	| SOME
	| ALL
	;

LikeOrNot :
	LIKE /*12L*/
	| NOT /*20R*/ LIKE /*12L*/
	;

LikeEscapeOpt :
	/*empty*/
	| ESCAPE STRING_LIT
	;

RegexpOrNot :
	REGEXP
	| RLIKE
	| NOT /*20R*/ REGEXP
	| NOT /*20R*/ RLIKE
	;

BetweenOrNot :
	BETWEEN
	| NOT /*20R*/ BETWEEN
	;

CreateTableStmt :
	CREATE TABLE IfNotExists TableName '(' /*22N*/ TableElementList ')' CreateTableOptionListOpt
	;

IfNotExists :
	/*empty*/
	| IF NOT /*20R*/ EXISTS
	;

IfExists :
	/*empty*/
	| IF EXISTS
	;

TableElementList :
	TableElement
	| TableElementList ',' /*25P*/ TableElement
	;

TableElement :
	ColumnDef
	| Constraint
	| CHECK '(' /*22N*/ Expr ')'
	;

ColumnDef :
	ColumnName Type ColumnOptionList
	;

ColumnDefList :
	ColumnDef
	| ColumnDefList ',' /*25P*/ ColumnDef
	;

ColumnOptionList :
	/*empty*/
	| ColumnOptionList ColumnOption
	;

ColumnOption :
	NOT /*20R*/ NULLX
	| NULLX
	| AUTO_INCREMENT
	| PrimaryOpt KEY /*5N*/
	| UNIQUE %prec lowerThanKey /*4N*/
	| UNIQUE KEY /*5N*/
	| DEFAULT DefaultValue
	| ON /*9P*/ UPDATE FunctionCallCurTimestamp
	| COMMENT STRING_LIT
	| COLLATE /*19L*/ StringName
	;

SignedLiteral :
	Literal
	| '+' /*16L*/ NumLiteral
	| '-' /*16L*/ NumLiteral
	;

DefaultValue :
	FunctionCallCurTimestamp
	| SignedLiteral
	;

FunctionCallCurTimestamp :
	NOW '(' /*22N*/ ')'
	| FunctionNameCurTimestamp
	| FunctionNameCurTimestamp '(' /*22N*/ ')'
	;

FunctionNameCurTimestamp :
	CURRENT_TIMESTAMP
	| LOCALTIME
	| LOCALTIMESTAMP
	;

PrimaryOpt :
	/*empty*/
	| PRIMARY
	;

DefaultKwdOpt :
	/*empty*/
	| DEFAULT
	;

Constraint :
	ConstraintKeywordOpt ConstraintElem
	;

ConstraintKeywordOpt :
	/*empty*/
	| CONSTRAINT
	| CONSTRAINT AllIdent
	;

ConstraintElem :
	PRIMARY KEY /*5N*/ '(' /*22N*/ ColumnNameList ')' IndexOptionList
	| FULLTEXT KeyOrIndexOpt IndexName '(' /*22N*/ ColumnNameList ')' IndexOptionList
	| VECTOR KeyOrIndexOpt IndexName '(' /*22N*/ ColumnNameList ')' IndexOptionList
	| KeyOrIndex IndexName '(' /*22N*/ ColumnNameList ')' IndexOptionList
	| UNIQUE KeyOrIndexOpt IndexName '(' /*22N*/ ColumnNameList ')' IndexOptionList
	| KeyOrIndex GlobalOrLocal IndexName '(' /*22N*/ ColumnNameList ')' IndexOptionList
	| UNIQUE KeyOrIndexOpt GlobalOrLocal IndexName '(' /*22N*/ ColumnNameList ')' IndexOptionList
	;

GlobalOrLocal :
	GLOBAL
	| LOCAL
	;

GlobalOrLocalOpt :
	/*empty*/
	| GlobalOrLocal
	;

IndexName :
	AllIdent
	;

IndexOptionList :
	/*empty*/
	| IndexOptionList IndexOption
	;

IndexOption :
	KEY_BLOCK_SIZE EqOpt INTEGER_LIT
	| IndexType
	| COMMENT STRING_LIT
	;

IndexType :
	USING /*9P*/ BTREE
	| USING /*9P*/ HASH
	;

Type :
	NumericType
	| StringType
	| DateAndTimeType
	;

NumericType :
	IntegerType OptFieldLen FieldOpts
	| BooleanType FieldOpts
	| FixedPointType FloatOpt FieldOpts
	| FloatingPointType FloatOpt FieldOpts
	| BitValueType OptFieldLen
	;

IntegerType :
	TINYINT
	| SMALLINT
	| MEDIUMINT
	| INT
	| INT1
	| INT2
	| INT3
	| INT4
	| INT8
	| INTEGER
	| BIGINT
	;

BooleanType :
	BOOL
	| BOOLEAN
	;

FixedPointType :
	DECIMAL
	| NUMERIC
	;

FloatingPointType :
	FLOAT
	| REAL
	| DOUBLE
	| DOUBLE PRECISION
	;

BitValueType :
	BIT
	;

StringType :
	NationalOpt CHAR FieldLen OptBinary OptCharset OptCollate
	| NationalOpt CHAR OptBinary OptCharset OptCollate
	| Varchar FieldLen OptBinary OptCharset OptCollate
	| BINARY /*19L*/ OptFieldLen
	| VARBINARY FieldLen
	| BlobType
	| TextType OptBinary OptCharset OptCollate
	| ENUM '(' /*22N*/ StringList ')' OptCharset OptCollate
	| SET /*3N*/ '(' /*22N*/ StringList ')' OptCharset OptCollate
	| JSON
	| HLL
	| BITMAP
	| TDIGEST
	;

NationalOpt :
	/*empty*/
	| NATIONAL
	;

Varchar :
	NATIONAL VARCHAR
	| VARCHAR
	| NVARCHAR
	;

BlobType :
	TINYBLOB
	| BLOB OptFieldLen
	| MEDIUMBLOB
	| LONGBLOB
	;

TextType :
	TINYTEXT
	| TEXT OptFieldLen
	| MEDIUMTEXT
	| LONGTEXT
	| LONG VARCHAR
	;

DateAndTimeType :
	DATE
	| DATETIME OptFieldLen
	| TIMESTAMP OptFieldLen
	| TIME OptFieldLen
	| YEAR OptFieldLen
	;

OptFieldLen :
	/*empty*/
	| FieldLen
	;

FieldLen :
	'(' /*22N*/ INTEGER_LIT ')'
	;

FieldOpt :
	UNSIGNED
	| SIGNED
	| ZEROFILL
	;

FieldOpts :
	/*empty*/
	| FieldOpts FieldOpt
	;

FloatOpt :
	/*empty*/
	| FieldLen
	| Precision
	;

Precision :
	'(' /*22N*/ INTEGER_LIT ',' /*25P*/ INTEGER_LIT ')'
	;

OptBinary :
	/*empty*/
	| BINARY /*19L*/
	;

OptCharset :
	/*empty*/
	| CharsetKw StringName
	;

CharsetKw :
	CHARACTER SET /*3N*/
	| CHARSET
	;

OptCollate :
	/*empty*/
	| COLLATE /*19L*/ StringName
	;

StringList :
	STRING_LIT
	| StringList ',' /*25P*/ STRING_LIT
	;

StringName :
	STRING_LIT
	| AllIdent
	;

CreateTableOptionListOpt :
	/*empty*/
	| TableOptionList
	;

TableOptionList :
	TableOption
	| TableOptionList TableOption
	| TableOptionList ',' /*25P*/ TableOption
	;

TableOption :
	ENGINE EqOpt StringName
	| DefaultKwdOpt CharsetKw EqOpt StringName
	| DefaultKwdOpt COLLATE /*19L*/ EqOpt StringName
	| AUTO_INCREMENT EqOpt INTEGER_LIT
	| COMMENT EqOpt STRING_LIT
	| AVG_ROW_LENGTH EqOpt INTEGER_LIT
	| KEY_BLOCK_SIZE EqOpt INTEGER_LIT
	| DYNAMIC_PARTITION_ATTR EqOpt STRING_LIT
	| PARTITION BY TablePartitionOpt
	;

PartitionOption :
	COMMENT EqOpt STRING_LIT
	;

PartitionOptionList :
	PartitionOption
	| PartitionOptionList PartitionOption
	;

PartitionOptionListOpt :
	/*empty*/
	| PartitionOptionList
	;

PartitionRange :
	PARTITION AllIdent VALUES LESS THAN '(' /*22N*/ Expr ')' PartitionOptionListOpt
	| PARTITION AllIdent VALUES LESS THAN MAXVALUE PartitionOptionListOpt
	| PARTITION AllIdent VALUES '[' Expr ',' /*25P*/ Expr ')' PartitionOptionListOpt
	| PARTITION AllIdent VALUES '[' Expr ',' /*25P*/ MAXVALUE ')' PartitionOptionListOpt
	;

PartitionRangeList :
	PartitionRange
	| PartitionRangeList ',' /*25P*/ PartitionRange
	;

PartitionRangeListOpt :
	/*empty*/
	| PartitionRangeList
	;

TablePartitionOpt :
	RANGE '(' /*22N*/ Expr ')' '(' /*22N*/ PartitionRangeListOpt ')'
	| HASH '(' /*22N*/ Expr ')' PARTITIONS INTEGER_LIT
	;

EqOpt :
	/*empty*/
	| EQ_OP /*12L*/
	;

DropTableStmt :
	DROP TableOrTables IfExists TableNameList RestrictOrCascadeOpt
	;

TableOrTables :
	TABLE
	| TABLES
	;

RestrictOrCascadeOpt :
	/*empty*/
	| RESTRICT
	| CASCADE
	;

RestoreTableStmt :
	RESTORE TableOrTables TableNameList
	;

CreateDatabaseStmt :
	CREATE DATABASE IfNotExists DBName DatabaseOptionListOpt
	;

DBName :
	AllIdent
	;

ResourceTag :
	AllIdent
	;

DatabaseOption :
	DefaultKwdOpt CharsetKw EqOpt StringName
	| DefaultKwdOpt COLLATE /*19L*/ EqOpt StringName
	;

DatabaseOptionListOpt :
	/*empty*/
	| DatabaseOptionList
	;

DatabaseOptionList :
	DatabaseOption
	| DatabaseOptionList DatabaseOption
	;

DropDatabaseStmt :
	DROP DATABASE IfExists DBName
	;

WorkOpt :
	/*empty*/
	| WORK
	;

StartTransactionStmt :
	START TRANSACTION
	| START TRANSACTION READ ONLY
	| BEGINX WorkOpt
	;

CommitTransactionStmt :
	COMMIT WorkOpt
	;

RollbackTransactionStmt :
	ROLLBACK WorkOpt
	;

SetStmt :
	SET /*3N*/ VarAssignList
	| SET /*3N*/ GLOBAL TRANSACTION TransactionChars
	| SET /*3N*/ SESSION TRANSACTION TransactionChars
	| SET /*3N*/ TRANSACTION TransactionChars
	;

VarAssignList :
	VarAssignItem
	| VarAssignList ',' /*25P*/ VarAssignItem
	;

VarAssignItem :
	VarName EQ_OP /*12L*/ Expr
	| VarName EQ_OP /*12L*/ ON /*9P*/
	| VarName EQ_OP /*12L*/ DEFAULT
	| VarName ASSIGN_OP Expr
	| CharsetKw AllIdent
	;

VarName :
	AllIdent
	| GLOBAL AllIdent
	| SESSION AllIdent
	| LOCAL AllIdent
	;

TransactionChars :
	TransactionChar
	| TransactionChars ',' /*25P*/ TransactionChar
	;

TransactionChar :
	ISOLATION LEVEL IsolationLevel
	;

IsolationLevel :
	REPEATABLE READ
	| READ COMMITTED
	| READ UNCOMMITTED
	| SERIALIZABLE
	;

ShowStmt :
	SHOW ShowTargetFilterable ShowLikeOrWhereOpt
	| SHOW CREATE TABLE TableName
	| SHOW CREATE DATABASE DBName
	| SHOW GRANTS
	| SHOW MASTER STATUS
	| SHOW OptFull PROCESSLIST
	| SHOW PROFILES
	| SHOW PRIVILEGES
	;

ShowIndexKwd :
	INDEX
	| INDEXES
	| KEYS
	;

FromOrIn :
	FROM
	| IN /*12L*/
	;

ShowTargetFilterable :
	ENGINES
	| DATABASES
	| CharsetKw
	| OptFull TABLES ShowDatabaseNameOpt
	| TABLE STATUS ShowDatabaseNameOpt
	| ShowIndexKwd FromOrIn TableName
	| ShowIndexKwd FromOrIn AllIdent FromOrIn AllIdent
	| OptFull COLUMNS ShowTableAliasOpt ShowDatabaseNameOpt
	| OptFull FIELDS ShowTableAliasOpt ShowDatabaseNameOpt
	| WARNINGS
	| GlobalScope VARIABLES
	| GlobalScope STATUS
	| COLLATION
	| TRIGGERS ShowDatabaseNameOpt
	| PROCEDURE STATUS
	| FUNCTION STATUS
	| EVENTS ShowDatabaseNameOpt
	| PLUGINS
	;

ShowLikeOrWhereOpt :
	/*empty*/
	| LIKE /*12L*/ SimpleExpr
	| WHERE Expr
	;

GlobalScope :
	/*empty*/
	| GLOBAL
	| SESSION
	;

OptFull :
	/*empty*/
	| FULL /*8L*/
	;

ShowDatabaseNameOpt :
	/*empty*/
	| FromOrIn DBName
	;

ShowTableAliasOpt :
	FromOrIn TableName
	;

AlterTableStmt :
	ALTER IgnoreOptional TABLE TableName AlterSpecList
	| CREATE KeyOrIndex GlobalOrLocalOpt IndexName ON /*9P*/ TableName '(' /*22N*/ ColumnNameList ')' IndexOptionList
	| CREATE UNIQUE KeyOrIndexOpt GlobalOrLocalOpt IndexName ON /*9P*/ TableName '(' /*22N*/ ColumnNameList ')' IndexOptionList
	;

AlterSpecList :
	AlterSpec
	| AlterSpecList ',' /*25P*/ AlterSpec
	;

ColumnKwdOpt :
	/*empty*/
	| COLUMN
	;

AsOrToOpt :
	/*empty*/
	| AS
	| TO
	;

ColumnPosOpt :
	/*empty*/
	| FIRST
	| AFTER ColumnName
	;

AlterSpec :
	TableOptionList %prec lowerThanComma /*24P*/
	| ADD ColumnKwdOpt ColumnDef ColumnPosOpt
	| ADD COLUMN UNIQUE ColumnDef ColumnPosOpt
	| ADD ColumnKwdOpt '(' /*22N*/ ColumnDefList ')'
	| DROP ColumnKwdOpt AllIdent
	| RENAME COLUMN AllIdent TO ColumnName
	| RENAME AsOrToOpt TableName
	| SWAP AsOrToOpt TableName
	| ADD ConstraintKeywordOpt ConstraintElem
	| ADD VIRTUAL ConstraintKeywordOpt ConstraintElem
	| DROP KeyOrIndex IndexName ForceOrNot
	| DROP VIRTUAL KeyOrIndex IndexName
	| RESTORE KeyOrIndex IndexName
	| ADD LEARNER ResourceTag
	| DROP LEARNER ResourceTag
	| MODIFY COLUMN SET /*3N*/ AssignmentList WhereClauseOptional
	| MODIFY ColumnKwdOpt ColumnDef ColumnPosOpt
	| ADD PartitionRange
	| DROP PARTITION AllIdent
	| MODIFY PARTITION AllIdent PartitionOptionListOpt
	;

NewPrepareStmt :
	PREPARE AllIdent FROM STRING_LIT
	| PREPARE AllIdent FROM VarName
	;

ExecPrepareStmt :
	EXECUTE AllIdent
	| EXECUTE AllIdent USING /*9P*/ VarList
	;

VarList :
	VarName
	| VarList ',' /*25P*/ VarName
	;

DeallocPrepareStmt :
	DEALLOCATE PREPARE AllIdent
	| DROP PREPARE AllIdent
	;

ExplainSym :
	EXPLAIN
	| DESCRIBE
	| DESC
	;

ExplainStmt :
	ExplainSym ExplainableStmt
	| ExplainSym FORMAT EQ_OP /*12L*/ STRING_LIT ExplainableStmt
	;

KillStmt :
	KILL INTEGER_LIT
	| KILL CONNECTION INTEGER_LIT
	| KILL QUERY INTEGER_LIT
	;

LoadDataStmt :
	LOAD DATA LocalOpt INFILE STRING_LIT DuplicateOpt INTO TABLE TableName OptCharset Fields Lines IgnoreLines ColumnNameOrUserVarListOptWithBrackets LoadDataSetSpecOpt
	;

LocalOpt :
	/*empty*/
	| LOCAL
	;

IgnoreLines :
	/*empty*/
	| IGNORE INTEGER_LIT LINES
	;

DuplicateOpt :
	/*empty*/
	| IGNORE
	| REPLACE
	;

Fields :
	/*empty*/
	| FieldsOrColumns FieldItemList
	;

FieldsOrColumns :
	FIELDS
	| COLUMNS
	;

FieldItemList :
	FieldItem
	| FieldItemList FieldItem
	;

FieldItem :
	TERMINATED BY STRING_LIT
	| OPTIONALLY ENCLOSED BY STRING_LIT
	| ENCLOSED BY STRING_LIT
	| ESCAPED BY STRING_LIT
	;

Lines :
	/*empty*/
	| LINES Starting LinesTerminated
	;

Starting :
	/*empty*/
	| STARTING BY STRING_LIT
	;

LinesTerminated :
	/*empty*/
	| TERMINATED BY STRING_LIT
	;

ColumnNameOrUserVarListOptWithBrackets :
	/*empty*/
	| '(' /*22N*/ ColumnNameListOpt ')'
	;

LoadDataSetSpecOpt :
	/*empty*/
	| SET /*3N*/ AssignmentList
	;

ExplainableStmt :
	SelectStmt
	| DeleteStmt
	| UpdateStmt
	| InsertStmt
	| ReplaceStmt
	| LoadDataStmt
	;

%%

%option caseless

%%

/* The following tokens belong to ReservedKeyword. */
ADD  ADD
ALL  ALL
ALTER  ALTER
//ANALYZE  ANALYZE
AND  AND
AS  AS
ASC  ASC
BETWEEN  BETWEEN
BIGINT  BIGINT
BINARY  BINARY
BLOB  BLOB
BOTH  BOTH
BY  BY
CASCADE  CASCADE
CASE  CASE
//CHANGE  CHANGE
CHARACTER  CHARACTER
CHAR  CHAR
CHECK  CHECK
COLLATE  COLLATE
COLUMN  COLUMN
CONSTRAINT  CONSTRAINT
CONVERT  CONVERT
CREATE  CREATE
CROSS  CROSS
CURRENT_DATE  CURRENT_DATE
CURRENT_TIME  CURRENT_TIME
//CURRENT_USER  CURRENT_USER
DATABASE  DATABASE
DATABASES  DATABASES
DAY_HOUR  DAY_HOUR
DAY_MICROSECOND  DAY_MICROSECOND
DAY_MINUTE  DAY_MINUTE
DAY_SECOND  DAY_SECOND
DECIMAL  DECIMAL
DEFAULT  DEFAULT
DELAYED  DELAYED
DELETE  DELETE
DESC  DESC
DESCRIBE  DESCRIBE
DISTINCT  DISTINCT
DISTINCTROW  DISTINCTROW
//DIV  DIV
DOUBLE  DOUBLE
DROP  DROP
DUAL  DUAL
ELSE  ELSE
ENCLOSED  ENCLOSED
ESCAPED  ESCAPED
EXISTS  EXISTS
EXPLAIN  EXPLAIN
FALSE  FALSE
FLOAT  FLOAT
FOR  FOR
FORCE  FORCE
//FOREIGN  FOREIGN
FROM  FROM
FULLTEXT  FULLTEXT
//GENERATED  GENERATED
//GRANT  GRANT
GROUP  GROUP
HAVING  HAVING
HIGH_PRIORITY  HIGH_PRIORITY
HOUR_MICROSECOND  HOUR_MICROSECOND
HOUR_MINUTE  HOUR_MINUTE
HOUR_SECOND  HOUR_SECOND
IF  IF
IGNORE  IGNORE
IN  IN
INDEX  INDEX
INFILE  INFILE
INNER  INNER
INTEGER  INTEGER
INTERVAL  INTERVAL
INTO  INTO
IS  IS
INSERT  INSERT
INT  INT
INT1  INT1
INT2  INT2
INT3  INT3
INT4  INT4
INT8  INT8
JOIN  JOIN
KEY  KEY
KEYS  KEYS
KILL  KILL
LEADING  LEADING
LEFT  LEFT
LIKE  LIKE
EXACT_LIKE  EXACT_LIKE
LIMIT  LIMIT
LINES  LINES
LOAD  LOAD
LOCALTIME  LOCALTIME
LOCALTIMESTAMP  LOCALTIMESTAMP
LOCK  LOCK
LONGBLOB  LONGBLOB
LONGTEXT  LONGTEXT
LOW_PRIORITY  LOW_PRIORITY
MATCH  MATCH
MAXVALUE  MAXVALUE
MEDIUMBLOB  MEDIUMBLOB
MEDIUMINT  MEDIUMINT
MEDIUMTEXT  MEDIUMTEXT
MINUTE_MICROSECOND  MINUTE_MICROSECOND
MINUTE_SECOND  MINUTE_SECOND
MOD  MOD
NOT  NOT
//NO_WRITE_TO_BINLOG  NO_WRITE_TO_BINLOG
NULL  NULLX
NUMERIC  NUMERIC
NVARCHAR  NVARCHAR
ON  ON
//OPTION  OPTION
OR  OR
ORDER  ORDER
OUTER  OUTER
//PACK_KEYS  PACK_KEYS
PARTITION  PARTITION
PRECISION  PRECISION
PRIMARY  PRIMARY
PROCEDURE  PROCEDURE
//SHARD_ROW_ID_BITS  SHARD_ROW_ID_BITS
RANGE  RANGE
READ  READ
REAL  REAL
//REFERENCES  REFERENCES
REGEXP  REGEXP
RENAME  RENAME
//REPEAT  REPEAT
REPLACE  REPLACE
MERGE  MERGE
RESTRICT  RESTRICT
//REVOKE  REVOKE
RIGHT  RIGHT
RLIKE  RLIKE
SECOND_MICROSECOND  SECOND_MICROSECOND
SELECT  SELECT
SET  SET
SHOW  SHOW
SMALLINT  SMALLINT
//SQL  SQL
SQL_CALC_FOUND_ROWS  SQL_CALC_FOUND_ROWS
STARTING  STARTING
STRAIGHT_JOIN  STRAIGHT_JOIN
TABLE  TABLE
//STORED  STORED
TERMINATED  TERMINATED
OPTIONALLY  OPTIONALLY
THEN  THEN
TINYBLOB  TINYBLOB
TINYINT  TINYINT
TINYTEXT  TINYTEXT
TO  TO
TRAILING  TRAILING
//TRIGGER  TRIGGER
TRUE  TRUE
UNIQUE  UNIQUE
UNION  UNION
//UNLOCK  UNLOCK
UNSIGNED  UNSIGNED
UPDATE  UPDATE
//USAGE  USAGE
USE  USE
USING  USING
//UTC_DATE  UTC_DATE
//UTC_TIME  UTC_TIME
VALUES  VALUES
LONG  LONG
VARCHAR  VARCHAR
VARBINARY  VARBINARY
_BINARY  _BINARY
VIRTUAL  VIRTUAL
WHEN  WHEN
WHERE  WHERE
//WRITE  WRITE
//WITH  WITH
XOR  XOR
YEAR_MONTH  YEAR_MONTH
ZEROFILL  ZEROFILL
NATURAL  NATURAL

/* The following tokens belong to UnReservedKeyword. */
ACTION  ACTION
AFTER  AFTER
AGAINST  AGAINST
ALWAYS  ALWAYS
ALGORITHM  ALGORITHM
ANY  ANY
ASCII  ASCII
AUTO_INCREMENT  AUTO_INCREMENT
AVG_ROW_LENGTH  AVG_ROW_LENGTH
DYNAMIC_PARTITION_ATTR  DYNAMIC_PARTITION_ATTR
AVG  AVG
BEGIN  BEGINX
WORK   WORK
BINLOG  BINLOG
BIT  BIT
BOOLEAN  BOOLEAN
BOOL  BOOL
BTREE  BTREE
BYTE  BYTE
CASCADED  CASCADED
CHARSET  CHARSET
CHECKSUM  CHECKSUM
CLEANUP  CLEANUP
CLIENT  CLIENT
COALESCE  COALESCE
COLLATION  COLLATION
COLUMNS  COLUMNS
COMMENT  COMMENT
COMMIT  COMMIT
COMMITTED  COMMITTED
COMPACT  COMPACT
COMPRESSED  COMPRESSED
COMPRESSION  COMPRESSION
CONNECTION  CONNECTION
CONSISTENT  CONSISTENT
DAY  DAY
DATA  DATA
DATE  DATE
DATETIME  DATETIME
DEALLOCATE  DEALLOCATE
DEFINER  DEFINER
DELAY_KEY_WRITE  DELAY_KEY_WRITE
DISABLE  DISABLE
DO  DO
DUPLICATE  DUPLICATE
DYNAMIC  DYNAMIC
ENABLE  ENABLE
END  END
ENGINE  ENGINE
ENGINES  ENGINES
ENUM  ENUM
EVENT  EVENT
EVENTS  EVENTS
ESCAPE  ESCAPE
EXCLUSIVE  EXCLUSIVE
EXECUTE  EXECUTE
FIELDS  FIELDS
FIRST  FIRST
FIXED  FIXED
FLUSH  FLUSH
FORMAT  FORMAT
FULL  FULL
FUNCTION  FUNCTION
GRANTS  GRANTS
HASH  HASH
HOUR  HOUR
IDENTIFIED  IDENTIFIED
ISOLATION  ISOLATION
INDEXES  INDEXES
INVOKER  INVOKER
JSON  JSON
KEY_BLOCK_SIZE  KEY_BLOCK_SIZE
LANGUAGE  LANGUAGE
LOCAL  LOCAL
LESS  LESS
LEVEL  LEVEL
MASTER  MASTER
MICROSECOND  MICROSECOND
MINUTE  MINUTE
MODE  MODE
MODIFY  MODIFY
MONTH  MONTH
MAX_ROWS  MAX_ROWS
MAX_CONNECTIONS_PER_HOUR  MAX_CONNECTIONS_PER_HOUR
MAX_QUERIES_PER_HOUR  MAX_QUERIES_PER_HOUR
MAX_UPDATES_PER_HOUR  MAX_UPDATES_PER_HOUR
MAX_USER_CONNECTIONS  MAX_USER_CONNECTIONS
MERGE  MERGE
MIN_ROWS  MIN_ROWS
NAMES  NAMES
NATIONAL  NATIONAL
NO  NO
NONE  NONE
OFFSET  OFFSET
ONLY  ONLY
PASSWORD  PASSWORD
PARTITIONS  PARTITIONS
PLUGINS  PLUGINS
PREPARE  PREPARE
PRIVILEGES  PRIVILEGES
PROCESS  PROCESS
PROCESSLIST  PROCESSLIST
PROFILES  PROFILES
QUARTER  QUARTER
QUERY  QUERY
QUERIES  QUERIES
QUICK  QUICK
RECOVER  RECOVER
RESTORE  RESTORE
REDUNDANT  REDUNDANT
RELOAD  RELOAD
REPEATABLE  REPEATABLE
REPLICATION  REPLICATION
REVERSE  REVERSE
ROLLBACK  ROLLBACK
ROUTINE  ROUTINE
ROW  ROW
ROW_COUNT  ROW_COUNT
ROW_FORMAT  ROW_FORMAT
SECOND  SECOND
SECURITY  SECURITY
SEPARATOR  SEPARATOR
SERIALIZABLE  SERIALIZABLE
SESSION  SESSION
SHARE  SHARE
SHARED  SHARED
SIGNED  SIGNED
SLAVE  SLAVE
SNAPSHOT  SNAPSHOT
SQL_CACHE  SQL_CACHE
SQL_NO_CACHE  SQL_NO_CACHE
START  START
STATS_PERSISTENT  STATS_PERSISTENT
STATUS  STATUS
SUPER  SUPER
SOME  SOME
SWAP  SWAP
GLOBAL  GLOBAL
TABLES  TABLES
TEMPORARY  TEMPORARY
TEMPTABLE  TEMPTABLE
TEXT  TEXT
THAN  THAN
TIME  TIME
TIMESTAMP  TIMESTAMP
TRACE  TRACE
TRANSACTION  TRANSACTION
TRIGGERS  TRIGGERS
TRUNCATE  TRUNCATE
UNCOMMITTED  UNCOMMITTED
UNKNOWN  UNKNOWN
USER  USER
UNDEFINED  UNDEFINED
VALUE  VALUE
VARIABLES  VARIABLES
VIEW  VIEW
VECTOR  VECTOR
WARNINGS  WARNINGS
WEEK  WEEK
YEAR  YEAR
HLL  HLL
BITMAP  BITMAP
TDIGEST  TDIGEST
LEARNER  LEARNER

/* The following tokens belong to builtin functions. */
ADDDATE  ADDDATE
BIT_AND  BIT_AND
BIT_OR  BIT_OR
BIT_XOR  BIT_XOR
CAST  CAST
COUNT  COUNT
CURDATE  CURDATE
CURTIME  CURTIME
DATE_ADD  DATE_ADD
DATE_SUB  DATE_SUB
EXTRACT  EXTRACT
GROUP_CONCAT  GROUP_CONCAT
MAX  MAX
MID  MID
MIN  MIN
NOW  NOW
CURRENT_TIMESTAMP  CURRENT_TIMESTAMP
UTC_TIMESTAMP  UTC_TIMESTAMP
POSITION  POSITION
SESSION_USER  SESSION_USER
STD  STD
STDDEV  STDDEV
STDDEV_POP  STDDEV_POP
STDDEV_SAMP  STDDEV_SAMP
SUBDATE  SUBDATE
SUBSTR  SUBSTR
SUBSTRING  SUBSTRING
TIMESTAMPADD  TIMESTAMPADD
TIMESTAMPDIFF  TIMESTAMPDIFF
SUM  SUM
SYSDATE  SYSDATE
SYSTEM_USER  SYSTEM_USER
TRIM  TRIM
VARIANCE  VARIANCE
VAR_POP  VAR_POP
VAR_SAMP  VAR_SAMP
([A-Za-z0-9_]+)_AGG  USER_AGG

ESCAPE	ESCAPE

"|"	'|'
"&"	'&'
"+"	'+'
"-"	'-'
"*"	'*'
"/"	'/'
"^"	'^'
"~"	'~'
"."	'.'
"("	'('
","	','
";"	';'
")"	')'
"{"	'{'
"}"	'}'
"["	'['

!  NOT_OP
=  EQ_OP
:=  ASSIGN_OP
%  MOD_OP
\>=  GE_OP
\>  GT_OP
\<=  LE_OP
\<  LT_OP
!=|\<\>  NE_OP
&&  AND
\|\|  OR
\<\<  LS_OP
\>\>  RS_OP

[0-9]+ INTEGER_LIT
[0-9]+E[-+]?[0-9]+ DECIMAL_LIT
[0-9]+\.[0-9]*E[-+]?[0-9]+ DECIMAL_LIT
\.[0-9]+E[-+]?[0-9]+ DECIMAL_LIT
[0-9]+\.[0-9]+    DECIMAL_LIT
[0-9]+\.        DECIMAL_LIT
\.[0-9]+ DECIMAL_LIT

0[b][0-1]+ STRING_LIT

[bB]\'[0-1]*\' STRING_LIT

0[x][0-9a-fA-F]+ STRING_LIT

[xX]\'[0-9a-fA-F]*\' STRING_LIT

\"([^\\\"]|\\.)*\" STRING_LIT
\'([^\\\']|\\.)*\' STRING_LIT

"?" PLACE_HOLDER_LIT

(([A-Za-z0-9_]+)|(`[^`]+`))((@([A-Za-z0-9_*]+|(`[^`]`)+))*) IDENT

@@?[A-Za-z][A-Za-z0-9_.$]* IDENT

"--".*  skip() /* single line comment; do nothing */
"#".* skip() /* single line comment; do nothing */

[ \t\r\n] skip()
//[\0]  0

//[-,\.*+(){}|&/^~;]  yytext[0]
//[][]  yytext[0]

"/*"([*]*(([^*/])+([/])*)*)*"*/" skip() /* comment; do nothing */

//.  CHINESE_DOT

%%
