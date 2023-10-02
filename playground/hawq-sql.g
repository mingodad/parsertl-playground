//From: https://github.com/apache/hawq/blob/e9d43144f7e947e071bba48871af9da354d177d0/src/backend/parser/gram.y
/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/*-------------------------------------------------------------------------
 *
 * gram.y
 *	  POSTGRES SQL YACC rules/actions
 *
 * Portions Copyright (c) 2006-2010, Greenplum inc
 * Portions Copyright (c) 1996-2009, PostgreSQL Global Development Group
 * Portions Copyright (c) 1994, Regents of the University of California
 *
 *
 * IDENTIFICATION
 *	  $PostgreSQL: pgsql/src/backend/parser/gram.y,v 2.568 2006/11/05 22:42:09 tgl Exp $
 *
 * HISTORY
 *	  AUTHOR			DATE			MAJOR EVENT
 *	  Andrew Yu			Sept, 1994		POSTQUEL to SQL conversion
 *	  Andrew Yu			Oct, 1994		lispy code conversion
 *
 * NOTES
 *	  CAPITALS are used to represent terminal symbols.
 *	  non-capitals are used to represent non-terminals.
 *	  SQL92-specific syntax is separated from plain SQL/Postgres syntax
 *	  to help isolate the non-extensible portions of the parser.
 *
 *	  In general, nothing in this file should initiate database accesses
 *	  nor depend on changeable state (such as SET variables).  If you do
 *	  database accesses, your code will fail when we have aborted the
 *	  current transaction and are just parsing commands to find the next
 *	  ROLLBACK or COMMIT.  If you make use of SET variables, then you
 *	  will do the wrong thing in multi-query strings like this:
 *			SET SQL_inheritance TO off; SELECT * FROM foo;
 *	  because the entire string is parsed by gram.y before the SET gets
 *	  executed.  Anything that depends on the database or changeable state
 *	  should be handled during parse analysis so that it happens at the
 *	  right time not the wrong time.  The handling of SQL_inheritance is
 *	  a good example.
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

%option caseless

/*Tokens*/
%token ABORT_P
%token ABSOLUTE_P
%token ACCESS
%token ACTION
%token ACTIVE
%token ADD_P
%token ADMIN
%token AFTER
%token AGGREGATE
%token ALL
%token ALSO
%token ALTER
%token ANALYSE
%token ANALYZE
%token AND
%token ANY
%token ARRAY
%token AS
%token ASC
%token ASSERTION
%token ASSIGNMENT
%token ASYMMETRIC
%token AT
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
%token CALLED
%token CASCADE
%token CASCADED
%token CASE
%token CAST
%token CHAIN
%token CHAR_P
%token CHARACTER
%token CHARACTERISTICS
%token CHECK
%token CHECKPOINT
%token CLASS
%token CLOSE
%token CLUSTER
%token COALESCE
%token COLLATE
%token COLUMN
%token COMMENT
%token COMMIT
%token COMMITTED
%token CONCURRENTLY
%token CONNECTION
%token CONSTRAINT
%token CONSTRAINTS
%token CONTAINS
%token CONTENT_P
%token CONTINUE_P
%token CONVERSION_P
%token CONVERT
%token COPY
%token COST
%token CREATE
%token CREATEDB
%token CREATEEXTTABLE
%token CREATEROLE
%token CREATEUSER
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
%token CURSOR
%token CYCLE
%token DATA_P
%token DATABASE
%token DAY_P
%token DEALLOCATE
%token DEC
%token DECIMAL_P
%token DECLARE
%token DECODE
%token DEFAULT
%token DEFAULTS
%token DEFERRABLE
%token DEFERRED
%token DEFINER
%token DELETE_P
%token DELIMITER
%token DELIMITERS
%token DENY
%token DESC
%token DISABLE_P
%token DISTINCT
%token DISTRIBUTED
%token DISCRIMINATOR
%token DO
%token DOMAIN_P
%token DOUBLE_P
%token DROP
%token DXL
%token EACH
%token ELSE
%token ENABLE_P
%token ENCODING
%token ENCRYPTED
%token END_P
%token ENUM_P
%token ERRORS
%token ESCAPE
%token EVERY
%token EXCEPT
%token EXCHANGE
%token EXCLUDE
%token EXCLUDING
%token EXCLUSIVE
%token EXECUTE
%token EXISTS
%token EXPLAIN
%token EXTERNAL
%token EXTRACT
%token EDGE
%token FALSE_P
%token FETCH
%token FIELDS
%token FILESPACE
%token FILESYSTEM
%token FILL
%token FILTER
%token FIRST_P
%token FLOAT_P
%token FOLLOWING
%token FOR
%token FORCE
%token FOREIGN
%token FORMAT
%token FORMATTER
%token FORWARD
%token FREEZE
%token FROM
%token FULL
%token FUNCTION
%token FUNCTIONS
%token GB
%token GLOBAL
%token GRANT
%token GRANTED
%token GREATEST
%token GROUP_P
%token GROUP_ID
%token GROUPING
%token GRAPH
%token HANDLER
%token HASH
%token HAVING
%token HEADER_P
%token HOLD
%token HOST
%token HOUR_P
%token IDENTITY_P
%token IF_P
%token IGNORE_P
%token ILIKE
%token IMMEDIATE
%token IMMUTABLE
%token IMPLICIT_P
%token IN_P
%token INCLUDE
%token INCLUDING
%token INCLUSIVE
%token INCREMENT
%token INDEX
%token INDEXES
%token INHERIT
%token INHERITS
%token INITIALLY
%token INNER_P
%token INOUT
%token INPUT_P
%token INSENSITIVE
%token INSERT
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
%token KB
%token KEEP
%token KEY
%token LANCOMPILER
%token LANGUAGE
%token LARGE_P
%token LAST_P
%token LEADING
%token LEAST
%token LEFT
%token LEVEL
%token LIKE
%token LIMIT
%token LIST
%token LISTEN
%token LOAD
%token LOCAL
%token LOCALTIME
%token LOCALTIMESTAMP
%token LOCATION
%token LOCK_P
%token LOG_P
%token LOGIN_P
%token MAPPING
%token MASTER
%token MATCH
%token MAXVALUE
%token MB
%token MEDIAN
%token MERGE
%token MINUTE_P
%token MINVALUE
%token MIRROR
%token MISSING
%token MODE
%token MODIFIES
%token MODIFY
%token MONTH_P
%token MOVE
%token NAME_P
%token NAMES
%token NATIONAL
%token NATURAL
%token NCHAR
%token NEW
%token NEWLINE
%token NEXT
%token NO
%token NOCREATEDB
%token NOCREATEEXTTABLE
%token NOCREATEROLE
%token NOCREATEUSER
%token NOINHERIT
%token NOLOGIN_P
%token NONE
%token NOOVERCOMMIT
%token NOSUPERUSER
%token NOT
%token NOTHING
%token NOTIFY
%token NOTNULL
%token NOWAIT
%token NULL_P
%token NULLS_P
%token NULLIF
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
%token ORDERED
%token OTHERS
%token OUT_P
%token OUTER_P
%token OVER
%token OVERCOMMIT
%token OVERLAPS
%token OVERLAY
%token OWNED
%token OWNER
%token PARTIAL
%token PARTITION
%token PARTITIONS
%token PASSWORD
%token PB
%token PERCENT
%token PERCENTILE_CONT
%token PERCENTILE_DISC
%token PLACING
%token POSITION
%token PRECEDING
%token PRECISION
%token PRESERVE
%token PREPARE
%token PREPARED
%token PRIMARY
%token PRIOR
%token PRIVILEGES
%token PROCEDURAL
%token PROCEDURE
%token PROTOCOL
%token QUEUE
%token QUOTE
%token RANDOMLY
%token RANGE
%token READ
%token READABLE
%token READS
%token REAL
%token REASSIGN
%token RECHECK
%token RECURSIVE
%token REFERENCES
%token REINDEX
%token REJECT_P
%token RELATIVE_P
%token RELEASE
%token RENAME
%token REPEATABLE
%token REPLACE
%token RESET
%token RESOURCE
%token RESTART
%token RESTRICT
%token RETURNING
%token RETURNS
%token REVERSED
%token REVOKE
%token RIGHT
%token ROLE
%token ROLLBACK
%token ROLLUP
%token ROOTPARTITION
%token ROW
%token ROWS
%token RULE
%token SAVEPOINT
%token SCATTER
%token SCHEMA
%token SCROLL
%token SEARCH
%token SECOND_P
%token SECURITY
%token SEGMENT
%token SELECT
%token SEQUENCE
%token SEQUENCES
%token SERIALIZABLE
%token SERVER
%token SESSION
%token SESSION_USER
%token SET
%token SETOF
%token SETS
%token SHARE
%token SHOW
%token SIMILAR
%token SIMPLE
%token SMALLINT
%token SOME
%token SPLIT
%token SQL
%token STABLE
%token START
%token STATEMENT
%token STATISTICS
%token STDIN
%token STDOUT
%token STORAGE
%token STRICT_P
%token SUBPARTITION
%token SUBPARTITIONS
%token SUBSTRING
%token SUPERUSER_P
%token SYMMETRIC
%token SYSID
%token SYSTEM_P
%token TABLE
%token TABLES
%token TABLESPACE
%token TB
%token TEMP
%token TEMPLATE
%token TEMPORARY
%token THEN
%token THRESHOLD
%token TIES
%token TIME
%token TIMESTAMP
%token TO
%token TRAILING
%token TRANSACTION
%token TREAT
%token TRIGGER
%token TRIM
%token TRUE_P
%token TRUNCATE
%token TRUSTED
%token TYPE_P
%token UNBOUNDED
%token UNCOMMITTED
%token UNENCRYPTED
%token UNION
%token UNIQUE
%token UNKNOWN
%token UNLISTEN
%token UNTIL
%token UPDATE
%token USER
%token USING
%token VACUUM
%token VALID
%token VALIDATION
%token VALIDATOR
%token VALUE_P
%token VALUES
%token VARCHAR
%token VARYING
%token VERBOSE
%token VERSION_P
%token VIEW
%token VOLATILE
%token VARIADIC
%token VERTEX
%token WEB
%token WHEN
%token WHERE
%token WINDOW
%token WITH
%token WITHIN
%token WITHOUT
%token WORK
%token WRAPPER
%token WRITABLE
%token WRITE
%token YEAR_P
%token ZONE
//%token NULLS_FIRST
//%token NULLS_LAST
%token WITH_CASCADED
%token WITH_LOCAL
%token WITH_CHECK
%token WITH_TIME
%token IDENT
%token FCONST
%token SCONST
%token BCONST
%token XCONST
%token Op
%token ICONST
%token PARAM
%token '='
%token '<'
%token '>'
%token POSTFIXOP
%token '+'
%token '-'
%token '*'
%token '/'
%token '%'
%token '^'
%token UMINUS
%token '['
%token ']'
%token '('
%token ')'
%token TYPECAST
%token '.'
%token ';'
%token ','
%token ':'

/* precedence: lowest to highest */
%nonassoc /*1*/ SET	/* see relation_expr_opt_alias */
%left /*2*/ EXCEPT UNION
%left /*3*/ INTERSECT
%left /*4*/ OR
%left /*5*/ AND
%right /*6*/ NOT
%right /*7*/ '='
%nonassoc /*8*/ '<' '>'
%nonassoc /*9*/ ILIKE LIKE SIMILAR
%nonassoc /*10*/ ESCAPE
%nonassoc /*11*/ OVERLAPS
%nonassoc /*12*/ BETWEEN
%nonassoc /*13*/ IN_P
%left /*14*/ POSTFIXOP	/* dummy for postfix Op rules */
/*
 * To support target_el without AS, we must give IDENT an explicit priority
 * between POSTFIXOP and Op.  We can safely assign the same priority to
 * various unreserved keywords as needed to resolve ambiguities (this can't
 * have any bad effects since obviously the keywords will still behave the
 * same as if they weren't keywords).  We need to do this for PARTITION,
 * RANGE, ROWS to support opt_existing_window_name; and for RANGE, ROWS
 * so that they can follow a_expr without creating
 * postfix-operator problems.
 */
%nonassoc /*15*/ PARTITION RANGE ROWS IDENT
/*
 * This is a bit ugly... To allow these to be column aliases without
 * the "AS" keyword, and not conflict with PostgreSQL's non-standard
 * suffix operators, we need to give these a precidence.
 */
%nonassoc /*16*/ ABORT_P
%nonassoc /*17*/ ABSOLUTE_P
%nonassoc /*18*/ ACCESS
%nonassoc /*19*/ ACTION
%nonassoc /*20*/ ACTIVE
%nonassoc /*21*/ ADD_P
%nonassoc /*22*/ ADMIN
%nonassoc /*23*/ AFTER
%nonassoc /*24*/ AGGREGATE
%nonassoc /*25*/ ALSO
%nonassoc /*26*/ ALTER
%nonassoc /*27*/ ASSERTION
%nonassoc /*28*/ ASSIGNMENT
%nonassoc /*29*/ BACKWARD
%nonassoc /*30*/ BEFORE
%nonassoc /*31*/ BEGIN_P
%nonassoc /*32*/ BY
%nonassoc /*33*/ CACHE
%nonassoc /*34*/ CALLED
%nonassoc /*35*/ CASCADE
%nonassoc /*36*/ CASCADED
%nonassoc /*37*/ CHAIN
%nonassoc /*38*/ CHARACTERISTICS
%nonassoc /*39*/ CHECKPOINT
%nonassoc /*40*/ CLASS
%nonassoc /*41*/ CLOSE
%nonassoc /*42*/ CLUSTER
%nonassoc /*43*/ COMMENT
%nonassoc /*44*/ COMMIT
%nonassoc /*45*/ COMMITTED
%nonassoc /*46*/ CONCURRENTLY
%nonassoc /*47*/ CONNECTION
%nonassoc /*48*/ CONSTRAINTS
%nonassoc /*49*/ CONTAINS
%nonassoc /*50*/ CONTENT_P
%nonassoc /*51*/ CONTINUE_P
%nonassoc /*52*/ CONVERSION_P
%nonassoc /*53*/ COPY
%nonassoc /*54*/ COST
%nonassoc /*55*/ CREATEDB
%nonassoc /*56*/ CREATEEXTTABLE
%nonassoc /*57*/ CREATEROLE
%nonassoc /*58*/ CREATEUSER
%nonassoc /*59*/ CSV
%nonassoc /*60*/ CURRENT
%nonassoc /*61*/ CURSOR
%nonassoc /*62*/ CYCLE
%nonassoc /*63*/ DATA_P
%nonassoc /*64*/ DATABASE
%nonassoc /*65*/ DAY_P
%nonassoc /*66*/ DEALLOCATE
%nonassoc /*67*/ DECLARE
%nonassoc /*68*/ DEFAULTS
%nonassoc /*69*/ DEFERRED
%nonassoc /*70*/ DEFINER
%nonassoc /*71*/ DELETE_P
%nonassoc /*72*/ DELIMITER
%nonassoc /*73*/ DELIMITERS
%nonassoc /*74*/ DISABLE_P
%nonassoc /*75*/ DOMAIN_P
%nonassoc /*76*/ DOUBLE_P
%nonassoc /*77*/ DROP
%nonassoc /*78*/ EACH
%nonassoc /*79*/ ENABLE_P
%nonassoc /*80*/ ENCODING
%nonassoc /*81*/ ENCRYPTED
%nonassoc /*82*/ END_P
%nonassoc /*83*/ ENUM_P
%nonassoc /*84*/ ERRORS
%nonassoc /*85*/ EVERY
%nonassoc /*86*/ EXCHANGE
%nonassoc /*87*/ EXCLUDING
%nonassoc /*88*/ EXCLUSIVE
%nonassoc /*89*/ EXECUTE
%nonassoc /*90*/ EXPLAIN
%nonassoc /*91*/ EXTERNAL
%nonassoc /*92*/ FETCH
%nonassoc /*93*/ FIELDS
%nonassoc /*94*/ FILL
%nonassoc /*95*/ FIRST_P
%nonassoc /*96*/ FORCE
%nonassoc /*97*/ FORMAT
%nonassoc /*98*/ FORMATTER
%nonassoc /*99*/ FORWARD
%nonassoc /*100*/ FUNCTION
%nonassoc /*101*/ GB
%nonassoc /*102*/ GLOBAL
%nonassoc /*103*/ GRANTED
%nonassoc /*104*/ HANDLER
%nonassoc /*105*/ HASH
%nonassoc /*106*/ HEADER_P
%nonassoc /*107*/ HOLD
%nonassoc /*108*/ HOST
%nonassoc /*109*/ HOUR_P
%nonassoc /*110*/ IF_P
%nonassoc /*111*/ IMMEDIATE
%nonassoc /*112*/ IMMUTABLE
%nonassoc /*113*/ IMPLICIT_P
%nonassoc /*114*/ INCLUDING
%nonassoc /*115*/ INCLUSIVE
%nonassoc /*116*/ INCREMENT
%nonassoc /*117*/ INDEX
%nonassoc /*118*/ INDEXES
%nonassoc /*119*/ INHERIT
%nonassoc /*120*/ INHERITS
%nonassoc /*121*/ INPUT_P
%nonassoc /*122*/ INSENSITIVE
%nonassoc /*123*/ INSERT
%nonassoc /*124*/ INSTEAD
%nonassoc /*125*/ INVOKER
%nonassoc /*126*/ ISOLATION
%nonassoc /*127*/ KB
%nonassoc /*128*/ KEEP
%nonassoc /*129*/ KEY
%nonassoc /*130*/ LANCOMPILER
%nonassoc /*131*/ LANGUAGE
%nonassoc /*132*/ LARGE_P
%nonassoc /*133*/ LAST_P
%nonassoc /*134*/ LEVEL
%nonassoc /*135*/ LIST
%nonassoc /*136*/ LISTEN
%nonassoc /*137*/ LOAD
%nonassoc /*138*/ LOCAL
%nonassoc /*139*/ LOCATION
%nonassoc /*140*/ LOCK_P
%nonassoc /*141*/ LOGIN_P
%nonassoc /*142*/ MASTER
%nonassoc /*143*/ MAPPING
%nonassoc /*144*/ MATCH
%nonassoc /*145*/ MAXVALUE
%nonassoc /*146*/ MB
%nonassoc /*147*/ MERGE
%nonassoc /*148*/ MINUTE_P
%nonassoc /*149*/ MINVALUE
%nonassoc /*150*/ MIRROR
%nonassoc /*151*/ MISSING
%nonassoc /*152*/ MODE
%nonassoc /*153*/ MODIFIES
%nonassoc /*154*/ MODIFY
%nonassoc /*155*/ MONTH_P
%nonassoc /*156*/ MOVE
%nonassoc /*157*/ NAME_P
%nonassoc /*158*/ NAMES
%nonassoc /*159*/ NEWLINE
%nonassoc /*160*/ NEXT
%nonassoc /*161*/ NO
%nonassoc /*162*/ NOCREATEDB
%nonassoc /*163*/ NOCREATEEXTTABLE
%nonassoc /*164*/ NOCREATEROLE
%nonassoc /*165*/ NOCREATEUSER
%nonassoc /*166*/ NOINHERIT
%nonassoc /*167*/ NOLOGIN_P
%nonassoc /*168*/ NOOVERCOMMIT
%nonassoc /*169*/ NOSUPERUSER
%nonassoc /*170*/ NOTHING
%nonassoc /*171*/ NOTIFY
%nonassoc /*172*/ NOWAIT
%nonassoc /*173*/ NULLS_P
%nonassoc /*174*/ OBJECT_P
%nonassoc /*175*/ OF
%nonassoc /*176*/ OIDS
%nonassoc /*177*/ OPTION
%nonassoc /*178*/ OPTIONS
%nonassoc /*179*/ OTHERS
%nonassoc /*180*/ OVER
%nonassoc /*181*/ OVERCOMMIT
%nonassoc /*182*/ OWNED
%nonassoc /*183*/ OWNER
%nonassoc /*184*/ PARTIAL
%nonassoc /*185*/ PARTITIONS
%nonassoc /*186*/ PASSWORD
%nonassoc /*187*/ PB
%nonassoc /*188*/ PERCENT
%nonassoc /*189*/ PREPARE
%nonassoc /*190*/ PREPARED
%nonassoc /*191*/ PRESERVE
%nonassoc /*192*/ PRIOR
%nonassoc /*193*/ PRIVILEGES
%nonassoc /*194*/ PROCEDURAL
%nonassoc /*195*/ PROCEDURE
%nonassoc /*196*/ FILESYSTEM
%nonassoc /*197*/ PROTOCOL
%nonassoc /*198*/ QUEUE
%nonassoc /*199*/ QUOTE
%nonassoc /*200*/ RANDOMLY
%nonassoc /*201*/ READ
%nonassoc /*202*/ READABLE
%nonassoc /*203*/ READS
%nonassoc /*204*/ REASSIGN
%nonassoc /*205*/ RECHECK
%nonassoc /*206*/ RECURSIVE
%nonassoc /*207*/ REINDEX
%nonassoc /*208*/ REJECT_P
%nonassoc /*209*/ RELATIVE_P
%nonassoc /*210*/ RELEASE
%nonassoc /*211*/ RENAME
%nonassoc /*212*/ REPEATABLE
%nonassoc /*213*/ REPLACE
%nonassoc /*214*/ RESET
%nonassoc /*215*/ RESOURCE
%nonassoc /*216*/ RESTART
%nonassoc /*217*/ RESTRICT
%nonassoc /*218*/ RETURNS
%nonassoc /*219*/ REVOKE
%nonassoc /*220*/ ROLE
%nonassoc /*221*/ ROLLBACK
%nonassoc /*222*/ RULE
%nonassoc /*223*/ SAVEPOINT
%nonassoc /*224*/ SCHEMA
%nonassoc /*225*/ SCROLL
%nonassoc /*226*/ SEARCH
%nonassoc /*227*/ SECOND_P
%nonassoc /*228*/ SECURITY
%nonassoc /*229*/ SEGMENT
%nonassoc /*230*/ SEQUENCE
%nonassoc /*231*/ SERIALIZABLE
%nonassoc /*232*/ SERVER
%nonassoc /*233*/ SESSION
%nonassoc /*234*/ SHARE
%nonassoc /*235*/ SHOW
%nonassoc /*236*/ SIMPLE
%nonassoc /*237*/ SPLIT
%nonassoc /*238*/ SQL
%nonassoc /*239*/ STABLE
%nonassoc /*240*/ START
%nonassoc /*241*/ STATEMENT
%nonassoc /*242*/ STATISTICS
%nonassoc /*243*/ STDIN
%nonassoc /*244*/ STDOUT
%nonassoc /*245*/ STORAGE
%nonassoc /*246*/ SUBPARTITION
%nonassoc /*247*/ SUBPARTITIONS
%nonassoc /*248*/ SUPERUSER_P
%nonassoc /*249*/ SYSID
%nonassoc /*250*/ SYSTEM_P
%nonassoc /*251*/ STRICT_P
%nonassoc /*252*/ TABLESPACE
%nonassoc /*253*/ TB
%nonassoc /*254*/ TEMP
%nonassoc /*255*/ TEMPLATE
%nonassoc /*256*/ TEMPORARY
%nonassoc /*257*/ THRESHOLD
%nonassoc /*258*/ TIES
%nonassoc /*259*/ TRANSACTION
%nonassoc /*260*/ TRIGGER
%nonassoc /*261*/ TRUNCATE
%nonassoc /*262*/ TRUSTED
%nonassoc /*263*/ TYPE_P
%nonassoc /*264*/ UNCOMMITTED
%nonassoc /*265*/ UNENCRYPTED
%nonassoc /*266*/ UNLISTEN
%nonassoc /*267*/ UNTIL
%nonassoc /*268*/ UPDATE
%nonassoc /*269*/ VACUUM
%nonassoc /*270*/ VALID
%nonassoc /*271*/ VALIDATION
%nonassoc /*272*/ VALIDATOR
%nonassoc /*273*/ VALUE_P
%nonassoc /*274*/ VARYING
%nonassoc /*275*/ VERSION_P
%nonassoc /*276*/ VIEW
%nonassoc /*277*/ VOLATILE
%nonassoc /*278*/ WEB
%nonassoc /*279*/ WITH
%nonassoc /*280*/ WITHIN
%nonassoc /*281*/ WITHOUT
%nonassoc /*282*/ WORK
%nonassoc /*283*/ WRAPPER
%nonassoc /*284*/ WRITABLE
%nonassoc /*285*/ WRITE
%nonassoc /*286*/ YEAR_P
%nonassoc /*287*/ BIGINT
%nonassoc /*288*/ BIT
%nonassoc /*289*/ BOOLEAN_P
%nonassoc /*290*/ CHAR_P
%nonassoc /*291*/ CHARACTER
%nonassoc /*292*/ COALESCE
%nonassoc /*293*/ CONVERT
%nonassoc /*294*/ CUBE
%nonassoc /*295*/ DEC
%nonassoc /*296*/ DECIMAL_P
%nonassoc /*297*/ EXISTS
%nonassoc /*298*/ EXTRACT
%nonassoc /*299*/ FLOAT_P
%nonassoc /*300*/ GREATEST
%nonassoc /*301*/ GROUP_ID
%nonassoc /*302*/ GROUPING
%nonassoc /*303*/ INOUT
%nonassoc /*304*/ INT_P
%nonassoc /*305*/ INTEGER
%nonassoc /*306*/ INTERVAL
%nonassoc /*307*/ LEAST
%nonassoc /*308*/ MEDIAN
%nonassoc /*309*/ NATIONAL
%nonassoc /*310*/ NCHAR
%nonassoc /*311*/ NONE
%nonassoc /*312*/ NULLIF
%nonassoc /*313*/ NUMERIC
%nonassoc /*314*/ OUT_P
%nonassoc /*315*/ OVERLAY
%nonassoc /*316*/ PERCENTILE_CONT
%nonassoc /*317*/ PERCENTILE_DISC
%nonassoc /*318*/ POSITION
%nonassoc /*319*/ PRECISION
%nonassoc /*320*/ REAL
%nonassoc /*321*/ ROLLUP
%nonassoc /*322*/ ROW
%nonassoc /*323*/ SETOF
%nonassoc /*324*/ SETS
%nonassoc /*325*/ SMALLINT
%nonassoc /*326*/ SUBSTRING
%nonassoc /*327*/ TIME
%nonassoc /*328*/ TIMESTAMP
%nonassoc /*329*/ TREAT
%nonassoc /*330*/ TRIM
%nonassoc /*331*/ VALUES
%nonassoc /*332*/ VARCHAR
%nonassoc /*333*/ AUTHORIZATION
%nonassoc /*334*/ BINARY
%nonassoc /*335*/ FREEZE
%nonassoc /*336*/ LOG_P
%nonassoc /*337*/ OUTER_P
%nonassoc /*338*/ VERBOSE
%left /*339*/ OPERATOR Op	/* multi-character ops and user-defined operators */
%nonassoc /*340*/ NOTNULL
%nonassoc /*341*/ ISNULL
%nonassoc /*342*/ FALSE_P IS NULL_P TRUE_P UNKNOWN	/* sets precedence for IS NULL, etc */
%left /*343*/ '+' '-'
%left /*344*/ '*' '/' '%'
%left /*345*/ '^'
/* Unary Operators */
%left /*346*/ AT ZONE	/* sets precedence for AT TIME ZONE */
%right /*347*/ UMINUS
%left /*348*/ '[' ']'
%left /*349*/ '(' ')'
%left /*350*/ TYPECAST
%left /*351*/ '.'
/*
 * These might seem to be low-precedence, but actually they are not part
 * of the arithmetic hierarchy at all in their use as JOIN operators.
 * We make them high-precedence to support their use as function names.
 * They wouldn't be given a precedence at all, were it not that we need
 * left-associativity among the JOIN rules themselves.
 */
%left /*352*/ CROSS FULL INNER_P JOIN LEFT NATURAL RIGHT

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
	AlterDatabaseStmt
	| AlterDatabaseSetStmt
	| AlterDomainStmt
	| AlterFdwStmt
	| AlterForeignServerStmt
	| AlterFunctionStmt
	| AlterGroupStmt
	| AlterObjectSchemaStmt
	| AlterOwnerStmt
	| AlterQueueStmt
	| AlterRoleSetStmt
	| AlterRoleStmt
	| AlterSeqStmt
	| AlterTableStmt
	| AlterTypeStmt
	| AlterUserMappingStmt
	| AlterUserSetStmt
	| AlterUserStmt
	| AnalyzeStmt
	| CheckPointStmt
	| ClosePortalStmt
	| ClusterStmt
	| CommentStmt
	| ConstraintsSetStmt
	| CopyStmt
	| CreateAsStmt
	| CreateAssertStmt
	| CreateCastStmt
	| CreateConversionStmt
	| CreateDomainStmt
	| CreateExternalStmt
	| CreateFdwStmt
	| CreateFileSpaceStmt
	| CreateForeignServerStmt
	| CreateForeignStmt
	| CreateFunctionStmt
	| CreateGroupStmt
	| CreateOpClassStmt
	| CreatePLangStmt
	| CreateQueueStmt
	| CreateSchemaStmt
	| CreateSeqStmt
	| CreateStmt
	| CreateGraphStmt
	| CreateTableSpaceStmt
	| CreateTrigStmt
	| CreateRoleStmt
	| CreateUserStmt
	| CreateUserMappingStmt
	| CreatedbStmt
	| DeallocateStmt
	| DeclareCursorStmt
	| DefineStmt
	| DeleteStmt
	| DropAssertStmt
	| DropCastStmt
	| DropFdwStmt
	| DropForeignServerStmt
	| DropGroupStmt
	| DropOpClassStmt
	| DropOwnedStmt
	| DropPLangStmt
	| DropQueueStmt
	| DropRuleStmt
	| DropStmt
	| DropTrigStmt
	| DropRoleStmt
	| DropUserMappingStmt
	| DropUserStmt
	| DropdbStmt
	| ExecuteStmt
	| ExplainStmt
	| FetchStmt
	| GrantStmt
	| GrantRoleStmt
	| IndexStmt
	| InsertStmt
	| ListenStmt
	| LoadStmt
	| LockStmt
	| NotifyStmt
	| PrepareStmt
	| ReassignOwnedStmt
	| ReindexStmt
	| RemoveAggrStmt
	| RemoveFuncStmt
	| RemoveOperStmt
	| RenameStmt
	| RevokeStmt
	| RevokeRoleStmt
	| RuleStmt
	| SelectStmt
	| TransactionStmt
	| TruncateStmt
	| UnlistenStmt
	| UpdateStmt
	| VacuumStmt
	| VariableResetStmt
	| VariableSetStmt
	| VariableShowStmt
	| ViewStmt
	| /*empty*/
	;

size_unit :
	'%' /*344L*/
	| KB /*127N*/
	| MB /*146N*/
	| GB /*101N*/
	| TB /*253N*/
	| PB /*187N*/
	;

resqueue_attr_definition :
	'(' /*349L*/ resqueue_attr_def_list ')' /*349L*/
	;

resqueue_attr_def_list :
	resqueue_attr_def_elem
	| resqueue_attr_def_list ',' resqueue_attr_def_elem
	;

resqueue_attr_def_elem :
	ColLabel '=' /*7R*/ Sconst
	| ColLabel '=' /*7R*/ '(' /*349L*/ IntegerOnly size_unit ',' IntegerOnly size_unit ')' /*349L*/
	| ColLabel '=' /*7R*/ IntegerOnly size_unit
	| ColLabel '=' /*7R*/ '(' /*349L*/ IntegerOnly ',' IntegerOnly ')' /*349L*/
	| ColLabel '=' /*7R*/ NumericOnly
	| ColLabel
	;

CreateQueueStmt :
	CREATE RESOURCE /*215N*/ QUEUE /*198N*/ QueueId WITH /*279N*/ resqueue_attr_definition
	;

AlterQueueStmt :
	ALTER /*26N*/ RESOURCE /*215N*/ QUEUE /*198N*/ QueueId WITH /*279N*/ resqueue_attr_definition
	| ALTER /*26N*/ RESOURCE /*215N*/ QUEUE /*198N*/ QueueId WITHOUT /*281N*/ resqueue_attr_definition
	| ALTER /*26N*/ RESOURCE /*215N*/ QUEUE /*198N*/ QueueId WITH /*279N*/ resqueue_attr_definition WITHOUT /*281N*/ definition
	;

DropQueueStmt :
	DROP /*77N*/ RESOURCE /*215N*/ QUEUE /*198N*/ QueueId
	;

CreateRoleStmt :
	CREATE ROLE /*220N*/ RoleId opt_with OptRoleList
	;

opt_with :
	WITH /*279N*/
	| /*empty*/
	;

OptRoleList :
	OptRoleList OptRoleElem
	| /*empty*/
	;

OptRoleElem :
	PASSWORD /*186N*/ Sconst
	| PASSWORD /*186N*/ NULL_P /*342N*/
	| ENCRYPTED /*81N*/ PASSWORD /*186N*/ Sconst
	| UNENCRYPTED /*265N*/ PASSWORD /*186N*/ Sconst
	| SUPERUSER_P /*248N*/
	| NOSUPERUSER /*169N*/
	| INHERIT /*119N*/
	| NOINHERIT /*166N*/
	| CREATEDB /*55N*/
	| NOCREATEDB /*162N*/
	| CREATEROLE /*57N*/
	| NOCREATEROLE /*164N*/
	| CREATEUSER /*58N*/
	| NOCREATEUSER /*165N*/
	| LOGIN_P /*141N*/
	| NOLOGIN_P /*167N*/
	| CONNECTION /*47N*/ LIMIT SignedIconst
	| VALID /*270N*/ UNTIL /*267N*/ Sconst
	| RESOURCE /*215N*/ QUEUE /*198N*/ any_name
	| USER name_list
	| SYSID /*249N*/ Iconst
	| ADMIN /*22N*/ name_list
	| ROLE /*220N*/ name_list
	| IN_P /*13N*/ ROLE /*220N*/ name_list
	| IN_P /*13N*/ GROUP_P name_list
	| CREATEEXTTABLE /*56N*/ exttab_auth_list
	| NOCREATEEXTTABLE /*163N*/ exttab_auth_list
	| deny_login_role
	;

deny_login_role :
	DENY deny_interval
	| DENY deny_point
	;

deny_interval :
	BETWEEN /*12N*/ deny_point AND /*5L*/ deny_point
	;

deny_day_specifier :
	Sconst
	| Iconst
	;

deny_point :
	DAY_P /*65N*/ deny_day_specifier opt_time
	;

opt_time :
	TIME /*327N*/ Sconst
	| /*empty*/
	;

exttab_auth_list :
	'(' /*349L*/ keyvalue_list ')' /*349L*/
	| /*empty*/
	;

keyvalue_list :
	keyvalue_pair
	| keyvalue_list ',' keyvalue_pair
	;

keyvalue_pair :
	ColLabel '=' /*7R*/ Sconst
	;

CreateUserStmt :
	CREATE USER RoleId opt_with OptRoleList
	;

AlterRoleStmt :
	ALTER /*26N*/ ROLE /*220N*/ RoleId opt_with OptAlterRoleList
	;

AlterRoleSetStmt :
	ALTER /*26N*/ ROLE /*220N*/ RoleId SET /*1N*/ set_rest
	| ALTER /*26N*/ ROLE /*220N*/ RoleId VariableResetStmt
	;

OptAlterRoleList :
	OptAlterRoleList OptAlterRoleElem
	| /*empty*/
	;

OptAlterRoleElem :
	OptRoleElem
	| DROP /*77N*/ DENY FOR deny_point
	;

AlterUserStmt :
	ALTER /*26N*/ USER RoleId opt_with OptAlterRoleList
	;

AlterUserSetStmt :
	ALTER /*26N*/ USER RoleId SET /*1N*/ set_rest
	| ALTER /*26N*/ USER RoleId VariableResetStmt
	;

DropRoleStmt :
	DROP /*77N*/ ROLE /*220N*/ name_list
	| DROP /*77N*/ ROLE /*220N*/ IF_P /*110N*/ EXISTS /*297N*/ name_list
	;

DropUserStmt :
	DROP /*77N*/ USER name_list
	| DROP /*77N*/ USER IF_P /*110N*/ EXISTS /*297N*/ name_list
	;

CreateGroupStmt :
	CREATE GROUP_P RoleId opt_with OptRoleList
	;

AlterGroupStmt :
	ALTER /*26N*/ GROUP_P RoleId add_drop USER name_list
	;

add_drop :
	ADD_P /*21N*/
	| DROP /*77N*/
	;

DropGroupStmt :
	DROP /*77N*/ GROUP_P name_list
	| DROP /*77N*/ GROUP_P IF_P /*110N*/ EXISTS /*297N*/ name_list
	;

CreateSchemaStmt :
	CREATE SCHEMA /*224N*/ OptSchemaName AUTHORIZATION /*333N*/ RoleId OptSchemaEltList
	| CREATE SCHEMA /*224N*/ ColId OptSchemaEltList
	;

OptSchemaName :
	ColId
	| /*empty*/
	;

OptSchemaEltList :
	OptSchemaEltList schema_stmt
	| /*empty*/
	;

schema_stmt :
	CreateStmt
	| IndexStmt
	| CreateSeqStmt
	| CreateTrigStmt
	| GrantStmt
	| ViewStmt
	;

VariableSetStmt :
	SET /*1N*/ set_rest
	| SET /*1N*/ LOCAL /*138N*/ set_rest
	| SET /*1N*/ SESSION /*233N*/ set_rest
	;

set_rest :
	var_name TO var_list_or_default
	| var_name '=' /*7R*/ var_list_or_default
	| TIME /*327N*/ ZONE /*346L*/ zone_value
	| TRANSACTION /*259N*/ transaction_mode_list
	| SESSION /*233N*/ CHARACTERISTICS /*38N*/ AS TRANSACTION /*259N*/ transaction_mode_list
	| NAMES /*158N*/ opt_encoding
	| ROLE /*220N*/ ColId_or_Sconst
	| SESSION /*233N*/ AUTHORIZATION /*333N*/ ColId_or_Sconst
	| SESSION /*233N*/ AUTHORIZATION /*333N*/ DEFAULT
	;

var_name :
	ColId
	| var_name '.' /*351L*/ ColId
	;

var_list_or_default :
	var_list
	| DEFAULT
	;

var_list :
	var_value
	| var_list ',' var_value
	;

var_value :
	opt_boolean
	| ColId_or_Sconst
	| NumericOnly
	;

iso_level :
	READ /*201N*/ UNCOMMITTED /*264N*/
	| READ /*201N*/ COMMITTED /*45N*/
	| REPEATABLE /*212N*/ READ /*201N*/
	| SERIALIZABLE /*231N*/
	;

opt_boolean :
	TRUE_P /*342N*/
	| FALSE_P /*342N*/
	| ON
	| OFF
	;

zone_value :
	Sconst
	| IDENT /*15N*/
	| ConstInterval Sconst opt_interval
	| ConstInterval '(' /*349L*/ Iconst ')' /*349L*/ Sconst opt_interval
	| NumericOnly
	| DEFAULT
	| LOCAL /*138N*/
	;

opt_encoding :
	Sconst
	| DEFAULT
	| /*empty*/
	;

ColId_or_Sconst :
	ColId
	| SCONST
	;

VariableShowStmt :
	SHOW /*235N*/ var_name
	| SHOW /*235N*/ TIME /*327N*/ ZONE /*346L*/
	| SHOW /*235N*/ TRANSACTION /*259N*/ ISOLATION /*126N*/ LEVEL /*134N*/
	| SHOW /*235N*/ SESSION /*233N*/ AUTHORIZATION /*333N*/
	| SHOW /*235N*/ ALL
	;

VariableResetStmt :
	RESET /*214N*/ var_name
	| RESET /*214N*/ TIME /*327N*/ ZONE /*346L*/
	| RESET /*214N*/ TRANSACTION /*259N*/ ISOLATION /*126N*/ LEVEL /*134N*/
	| RESET /*214N*/ SESSION /*233N*/ AUTHORIZATION /*333N*/
	| RESET /*214N*/ ALL
	;

ConstraintsSetStmt :
	SET /*1N*/ CONSTRAINTS /*48N*/ constraints_set_list constraints_set_mode
	;

constraints_set_list :
	ALL
	| qualified_name_list
	;

constraints_set_mode :
	DEFERRED /*69N*/
	| IMMEDIATE /*111N*/
	;

CheckPointStmt :
	CHECKPOINT /*39N*/
	;

AlterTableStmt :
	ALTER /*26N*/ TABLE relation_expr alter_table_cmds
	| ALTER /*26N*/ EXTERNAL /*91N*/ TABLE relation_expr alter_table_cmds
	| ALTER /*26N*/ FOREIGN TABLE relation_expr alter_table_cmds
	| ALTER /*26N*/ INDEX /*117N*/ relation_expr alter_rel_cmds
	;

alter_table_cmds :
	alter_table_cmd
	| alter_table_cmds ',' alter_table_cmd
	;

alter_table_cmd :
	ADD_P /*21N*/ opt_column columnDef
	| ALTER /*26N*/ opt_column ColId alter_column_default
	| ALTER /*26N*/ opt_column ColId DROP /*77N*/ NOT /*6R*/ NULL_P /*342N*/
	| ALTER /*26N*/ opt_column ColId SET /*1N*/ NOT /*6R*/ NULL_P /*342N*/
	| ALTER /*26N*/ opt_column ColId SET /*1N*/ STATISTICS /*242N*/ IntegerOnly
	| ALTER /*26N*/ opt_column ColId SET /*1N*/ STORAGE /*245N*/ ColId
	| DROP /*77N*/ opt_column ColId opt_drop_behavior
	| ALTER /*26N*/ opt_column ColId TYPE_P /*263N*/ Typename alter_using
	| ADD_P /*21N*/ TableConstraint
	| DROP /*77N*/ CONSTRAINT name opt_drop_behavior
	| SET /*1N*/ WITHOUT /*281N*/ OIDS /*176N*/
	| CLUSTER /*42N*/ ON name
	| SET /*1N*/ WITHOUT /*281N*/ CLUSTER /*42N*/
	| ENABLE_P /*79N*/ TRIGGER /*260N*/ name
	| ENABLE_P /*79N*/ TRIGGER /*260N*/ ALL
	| ENABLE_P /*79N*/ TRIGGER /*260N*/ USER
	| DISABLE_P /*74N*/ TRIGGER /*260N*/ name
	| DISABLE_P /*74N*/ TRIGGER /*260N*/ ALL
	| DISABLE_P /*74N*/ TRIGGER /*260N*/ USER
	| INHERIT /*119N*/ qualified_name opt_inherited_column_list
	| NO /*161N*/ INHERIT /*119N*/ qualified_name
	| SET /*1N*/ DistributedBy
	| SET /*1N*/ WITH /*279N*/ definition DistributedBy
	| SET /*1N*/ WITH /*279N*/ definition
	| alter_table_partition_cmd
	| alter_rel_cmd
	;

opt_table_partition_split_into :
	INTO '(' /*349L*/ alter_table_partition_id_spec_with_opt_default ',' alter_table_partition_id_spec_with_opt_default ')' /*349L*/
	| /*empty*/
	;

opt_table_partition_merge_into :
	INTO alter_table_partition_id_spec_with_opt_default
	| /*empty*/
	;

table_partition_modify :
	TabPartitionBoundarySpecStart OptTabPartitionBoundarySpecEnd OptTabPartitionBoundarySpecEvery
	| TabPartitionBoundarySpecEnd OptTabPartitionBoundarySpecEvery
	| add_drop part_values_clause
	;

opt_table_partition_exchange_validate :
	WITH /*279N*/ VALIDATION /*271N*/
	| WITHOUT /*281N*/ VALIDATION /*271N*/
	| /*empty*/
	;

alter_table_partition_id_spec :
	PartitionColId
	| FOR '(' /*349L*/ TabPartitionBoundarySpecValList ')' /*349L*/
	| FOR '(' /*349L*/ function_name '(' /*349L*/ NumericOnly ')' /*349L*/ ')' /*349L*/
	;

alter_table_partition_id_spec_with_opt_default :
	PARTITION /*15N*/ alter_table_partition_id_spec
	| DEFAULT PARTITION /*15N*/ alter_table_partition_id_spec
	| DEFAULT PARTITION /*15N*/
	;

alter_table_partition_cmd :
	ADD_P /*21N*/ PARTITION /*15N*/ OptTabPartitionBoundarySpec OptTabPartitionStorageAttr OptTabSubPartitionSpec
	| ADD_P /*21N*/ DEFAULT PARTITION /*15N*/ alter_table_partition_id_spec OptTabPartitionBoundarySpec OptTabPartitionStorageAttr OptTabSubPartitionSpec
	| ADD_P /*21N*/ PARTITION /*15N*/ alter_table_partition_id_spec OptTabPartitionBoundarySpec OptTabPartitionStorageAttr OptTabSubPartitionSpec
	| ALTER /*26N*/ alter_table_partition_id_spec_with_opt_default alter_table_cmd
	| partition_coalesce_keyword PARTITION /*15N*/
	| partition_coalesce_keyword PARTITION /*15N*/ alter_table_partition_id_spec
	| DROP /*77N*/ PARTITION /*15N*/ IF_P /*110N*/ EXISTS /*297N*/ alter_table_partition_id_spec opt_drop_behavior
	| DROP /*77N*/ DEFAULT PARTITION /*15N*/ IF_P /*110N*/ EXISTS /*297N*/ opt_drop_behavior
	| DROP /*77N*/ alter_table_partition_id_spec_with_opt_default opt_drop_behavior
	| DROP /*77N*/ PARTITION /*15N*/
	| EXCHANGE /*86N*/ alter_table_partition_id_spec_with_opt_default WITH /*279N*/ TABLE qualified_name opt_table_partition_exchange_validate
	| MERGE /*147N*/ alter_table_partition_id_spec_with_opt_default ',' alter_table_partition_id_spec_with_opt_default opt_table_partition_merge_into
	| MODIFY /*154N*/ alter_table_partition_id_spec_with_opt_default table_partition_modify
	| RENAME /*211N*/ alter_table_partition_id_spec_with_opt_default TO IDENT /*15N*/
	| SET /*1N*/ SUBPARTITION /*246N*/ TEMPLATE /*255N*/ '(' /*349L*/ TabSubPartitionElemList ')' /*349L*/
	| SET /*1N*/ SUBPARTITION /*246N*/ TEMPLATE /*255N*/ '(' /*349L*/ ')' /*349L*/
	| SPLIT /*237N*/ DEFAULT PARTITION /*15N*/ TabPartitionBoundarySpecStart TabPartitionBoundarySpecEnd opt_table_partition_split_into
	| SPLIT /*237N*/ alter_table_partition_id_spec_with_opt_default AT /*346L*/ '(' /*349L*/ part_values_or_spec_list ')' /*349L*/ opt_table_partition_split_into
	| TRUNCATE /*261N*/ alter_table_partition_id_spec_with_opt_default opt_drop_behavior
	;

alter_rel_cmds :
	alter_rel_cmd
	| alter_rel_cmds ',' alter_rel_cmd
	;

alter_rel_cmd :
	OWNER /*183N*/ TO RoleId
	| SET /*1N*/ TABLESPACE /*252N*/ name
	| SET /*1N*/ definition
	| RESET /*214N*/ definition
	;

alter_column_default :
	SET /*1N*/ DEFAULT a_expr
	| DROP /*77N*/ DEFAULT
	;

opt_drop_behavior :
	CASCADE /*35N*/
	| RESTRICT /*217N*/
	| /*empty*/
	;

alter_using :
	USING a_expr
	| /*empty*/
	;

ClosePortalStmt :
	CLOSE /*41N*/ name
	;

CopyStmt :
	COPY /*53N*/ opt_binary qualified_name opt_column_list opt_oids copy_from copy_file_name copy_delimiter opt_with copy_opt_list OptSingleRowErrorHandling
	| COPY /*53N*/ select_with_parens TO copy_file_name opt_with copy_opt_list
	;

copy_from :
	FROM
	| TO
	;

copy_file_name :
	Sconst
	| STDIN /*243N*/
	| STDOUT /*244N*/
	;

copy_opt_list :
	copy_opt_list copy_opt_item
	| /*empty*/
	;

copy_opt_item :
	BINARY /*334N*/
	| OIDS /*176N*/
	| DELIMITER /*72N*/ opt_as Sconst
	| NULL_P /*342N*/ opt_as Sconst
	| CSV /*59N*/
	| HEADER_P /*106N*/
	| QUOTE /*199N*/ opt_as Sconst
	| ESCAPE /*10N*/ opt_as Sconst
	| FORCE /*96N*/ QUOTE /*199N*/ columnList
	| FORCE /*96N*/ NOT /*6R*/ NULL_P /*342N*/ columnList
	| FILL /*94N*/ MISSING /*151N*/ FIELDS /*93N*/
	| NEWLINE /*159N*/ opt_as Sconst
	;

opt_binary :
	BINARY /*334N*/
	| /*empty*/
	;

opt_oids :
	WITH /*279N*/ OIDS /*176N*/
	| /*empty*/
	;

copy_delimiter :
	opt_using DELIMITERS /*73N*/ Sconst
	| /*empty*/
	;

opt_using :
	USING
	| /*empty*/
	;

CreateStmt :
	CREATE OptTemp TABLE qualified_name '(' /*349L*/ OptTableElementList ')' /*349L*/ OptInherit OptWith OnCommitOption OptTableSpace OptDistributedBy OptTabPartitionBy
	| CREATE OptTemp TABLE qualified_name OF /*175N*/ qualified_name '(' /*349L*/ OptTableElementList ')' /*349L*/ OptWith OnCommitOption OptTableSpace OptDistributedBy OptTabPartitionBy
	| CREATE OptTemp TABLE qualified_name '(' /*349L*/ OptTableElementList ')' /*349L*/ ExtTypedesc FORMAT /*97N*/ Sconst format_opt ext_opt_encoding_list OptDistributedBy OptTabPartitionBy
	| CREATE VERTEX qualified_name '(' /*349L*/ OptTableElementList ')' /*349L*/
	| CREATE EDGE qualified_name '(' /*349L*/ fromVlabel ',' toVlabel ',' OptTableElementList ')' /*349L*/
	| CREATE EDGE qualified_name '(' /*349L*/ fromVlabel ',' toVlabel ')' /*349L*/
	;

CreateGraphStmt :
	CREATE GRAPH qualified_name '(' /*349L*/ VERTEX '(' /*349L*/ LabelList ')' /*349L*/ ',' EDGE '(' /*349L*/ LabelList ')' /*349L*/ ')' /*349L*/ FORMAT /*97N*/ Sconst format_opt OptWith
	| CREATE GRAPH qualified_name '(' /*349L*/ VERTEX '(' /*349L*/ LabelList ')' /*349L*/ ',' EDGE '(' /*349L*/ LabelList ')' /*349L*/ ')' /*349L*/ OptWith
	| CREATE GRAPH qualified_name '(' /*349L*/ VERTEX '(' /*349L*/ LabelList ')' /*349L*/ ')' /*349L*/ OptWith
	| CREATE GRAPH qualified_name '(' /*349L*/ VERTEX '(' /*349L*/ LabelList ')' /*349L*/ ')' /*349L*/ FORMAT /*97N*/ Sconst format_opt OptWith
	;

LabelList :
	ColId
	| LabelList ',' ColId
	;

OptTemp :
	TEMPORARY /*256N*/
	| TEMP /*254N*/
	| LOCAL /*138N*/ TEMPORARY /*256N*/
	| LOCAL /*138N*/ TEMP /*254N*/
	| GLOBAL /*102N*/ TEMPORARY /*256N*/
	| GLOBAL /*102N*/ TEMP /*254N*/
	| /*empty*/
	;

OptTableElementList :
	TableElementList
	| /*empty*/
	;

TableElementList :
	TableElement
	| TableElementList ',' TableElement
	;

TableElement :
	columnDef
	| TableLikeClause
	| TableConstraint
	| column_reference_storage_directive
	;

column_reference_storage_directive :
	COLUMN columnElem ENCODING /*80N*/ definition
	| DEFAULT COLUMN ENCODING /*80N*/ definition
	;

columnDef :
	ColId Typename ColQualList opt_storage_encoding
	;

fromVlabel :
	FROM ColId
	;

toVlabel :
	TO ColId
	;

ColQualList :
	ColQualList ColConstraint
	| /*empty*/
	;

ColConstraint :
	CONSTRAINT name ColConstraintElem
	| ColConstraintElem
	| ConstraintAttr
	;

opt_storage_encoding :
	ENCODING /*80N*/ definition
	| /*empty*/
	;

ColConstraintElem :
	NOT /*6R*/ NULL_P /*342N*/
	| NULL_P /*342N*/
	| UNIQUE opt_definition OptConsTableSpace
	| PRIMARY KEY /*129N*/ opt_definition OptConsTableSpace
	| CHECK '(' /*349L*/ a_expr ')' /*349L*/
	| DEFAULT b_expr
	| REFERENCES qualified_name opt_column_list key_match key_actions
	;

ConstraintAttr :
	DEFERRABLE
	| NOT /*6R*/ DEFERRABLE
	| INITIALLY DEFERRED /*69N*/
	| INITIALLY IMMEDIATE /*111N*/
	;

TableLikeClause :
	LIKE /*9N*/ qualified_name TableLikeOptionList
	;

TableLikeOptionList :
	TableLikeOptionList TableLikeOption
	| /*empty*/
	;

TableLikeOption :
	INCLUDING /*114N*/ DEFAULTS /*68N*/
	| EXCLUDING /*87N*/ DEFAULTS /*68N*/
	| INCLUDING /*114N*/ CONSTRAINTS /*48N*/
	| EXCLUDING /*87N*/ CONSTRAINTS /*48N*/
	| INCLUDING /*114N*/ INDEXES /*118N*/
	| EXCLUDING /*87N*/ INDEXES /*118N*/
	;

TableConstraint :
	CONSTRAINT name ConstraintElem
	| ConstraintElem
	;

ConstraintElem :
	CHECK '(' /*349L*/ a_expr ')' /*349L*/
	| UNIQUE '(' /*349L*/ columnList ')' /*349L*/ opt_c_include opt_definition OptConsTableSpace
	| PRIMARY KEY /*129N*/ '(' /*349L*/ columnList ')' /*349L*/ opt_c_include opt_definition OptConsTableSpace
	| DISCRIMINATOR '(' /*349L*/ columnList ')' /*349L*/ opt_definition OptConsTableSpace
	| FOREIGN KEY /*129N*/ '(' /*349L*/ columnList ')' /*349L*/ REFERENCES qualified_name opt_column_list key_match key_actions ConstraintAttributeSpec
	;

opt_column_list :
	'(' /*349L*/ columnList ')' /*349L*/
	| /*empty*/
	;

opt_inherited_column_list :
	'(' /*349L*/ columnList ')' /*349L*/
	| /*empty*/
	;

columnList :
	columnElem
	| columnList ',' columnElem
	;

columnListPlus :
	columnElem ',' columnElem
	| columnListPlus ',' columnElem
	;

columnElem :
	ColId
	;

opt_c_include :
	INCLUDE '(' /*349L*/ columnList ')' /*349L*/
	| /*empty*/
	;

key_match :
	MATCH /*144N*/ FULL /*352L*/
	| MATCH /*144N*/ PARTIAL /*184N*/
	| MATCH /*144N*/ SIMPLE /*236N*/
	| /*empty*/
	;

key_actions :
	key_update
	| key_delete
	| key_update key_delete
	| key_delete key_update
	| /*empty*/
	;

key_update :
	ON UPDATE /*268N*/ key_action
	;

key_delete :
	ON DELETE_P /*71N*/ key_action
	;

key_action :
	NO /*161N*/ ACTION /*19N*/
	| RESTRICT /*217N*/
	| CASCADE /*35N*/
	| SET /*1N*/ NULL_P /*342N*/
	| SET /*1N*/ DEFAULT
	;

OptInherit :
	INHERITS /*120N*/ '(' /*349L*/ qualified_name_list ')' /*349L*/
	| /*empty*/
	;

OptWith :
	WITH /*279N*/ definition
	| WITH /*279N*/ OIDS /*176N*/
	| WITHOUT /*281N*/ OIDS /*176N*/
	| /*empty*/
	;

OnCommitOption :
	ON COMMIT /*44N*/ DROP /*77N*/
	| ON COMMIT /*44N*/ DELETE_P /*71N*/ ROWS /*15N*/
	| ON COMMIT /*44N*/ PRESERVE /*191N*/ ROWS /*15N*/
	| /*empty*/
	;

OptTableSpace :
	TABLESPACE /*252N*/ name
	| /*empty*/
	;

OptConsTableSpace :
	USING INDEX /*117N*/ TABLESPACE /*252N*/ name
	| /*empty*/
	;

DistributedBy :
	DISTRIBUTED BY /*32N*/ '(' /*349L*/ columnList ')' /*349L*/
	| DISTRIBUTED RANDOMLY /*200N*/
	;

OptDistributedBy :
	DistributedBy
	| /*empty*/
	;

OptTabPartitionColumnEncList :
	TabPartitionColumnEncList
	| /*empty*/
	;

TabPartitionColumnEncList :
	column_reference_storage_directive
	| TabPartitionColumnEncList column_reference_storage_directive
	;

OptTabPartitionStorageAttr :
	WITH /*279N*/ definition TABLESPACE /*252N*/ name
	| WITH /*279N*/ definition
	| TABLESPACE /*252N*/ name
	| WITH /*279N*/ '(' /*349L*/ FORMAT /*97N*/ Sconst format_opt ')' /*349L*/
	| /*empty*/
	;

OptTabPartitionsNumber :
	PARTITIONS /*185N*/ IntegerOnly
	| /*empty*/
	;

OptTabSubPartitionsNumber :
	SUBPARTITIONS /*247N*/ IntegerOnly
	| /*empty*/
	;

OptTabPartitionSpec :
	'(' /*349L*/ TabPartitionElemList ')' /*349L*/
	| /*empty*/
	;

OptTabSubPartitionSpec :
	'(' /*349L*/ TabSubPartitionElemList ')' /*349L*/
	| /*empty*/
	;

TabPartitionElemList :
	TabPartitionElem
	| TabPartitionElemList ',' TabPartitionElem
	;

TabSubPartitionElemList :
	TabSubPartitionElem
	| TabSubPartitionElemList ',' TabSubPartitionElem
	;

tab_part_val_no_paran :
	AexprConst
	| CAST '(' /*349L*/ tab_part_val AS Typename ')' /*349L*/
	| tab_part_val_no_paran TYPECAST /*350L*/ Typename
	| '-' /*343L*/ tab_part_val_no_paran
	;

tab_part_val :
	tab_part_val_no_paran
	| '(' /*349L*/ tab_part_val_no_paran ')' /*349L*/
	| '(' /*349L*/ tab_part_val_no_paran ')' /*349L*/ TYPECAST /*350L*/ Typename
	;

TabPartitionBoundarySpecValList :
	tab_part_val
	| TabPartitionBoundarySpecValList ',' tab_part_val
	;

OptTabPartitionBoundarySpecValList :
	TabPartitionBoundarySpecValList
	| /*empty*/
	;

OptTabPartitionRangeInclusive :
	INCLUSIVE /*115N*/
	| EXCLUSIVE /*88N*/
	| /*empty*/
	;

TabPartitionBoundarySpecStart :
	START /*240N*/ '(' /*349L*/ OptTabPartitionBoundarySpecValList ')' /*349L*/ OptTabPartitionRangeInclusive
	;

TabPartitionBoundarySpecEnd :
	END_P /*82N*/ '(' /*349L*/ OptTabPartitionBoundarySpecValList ')' /*349L*/ OptTabPartitionRangeInclusive
	;

OptTabPartitionBoundarySpecEvery :
	EVERY /*85N*/ '(' /*349L*/ TabPartitionBoundarySpecValList ')' /*349L*/
	| /*empty*/
	;

OptTabPartitionBoundarySpecEnd :
	TabPartitionBoundarySpecEnd
	| /*empty*/
	;

TabPartitionBoundarySpec :
	part_values_clause
	| TabPartitionBoundarySpecStart OptTabPartitionBoundarySpecEnd OptTabPartitionBoundarySpecEvery
	| TabPartitionBoundarySpecEnd OptTabPartitionBoundarySpecEvery
	;

OptTabPartitionBoundarySpec :
	TabPartitionBoundarySpec
	| /*empty*/
	;

multi_spec_value_list :
	'(' /*349L*/ part_values_single ')' /*349L*/
	| multi_spec_value_list ',' '(' /*349L*/ part_values_single ')' /*349L*/
	;

part_values_single :
	tab_part_val_no_paran
	| part_values_single ',' tab_part_val_no_paran
	;

part_values_clause :
	VALUES /*331N*/ '(' /*349L*/ part_values_single ')' /*349L*/
	| VALUES /*331N*/ '(' /*349L*/ multi_spec_value_list ')' /*349L*/
	;

part_values_or_spec_list :
	TabPartitionBoundarySpecValList
	| part_values_clause
	;

TabPartitionElem :
	TabPartitionNameDecl OptTabPartitionBoundarySpec OptTabPartitionStorageAttr OptTabPartitionColumnEncList OptTabSubPartitionSpec
	| TabPartitionDefaultNameDecl OptTabPartitionBoundarySpec OptTabPartitionStorageAttr OptTabPartitionColumnEncList OptTabSubPartitionSpec
	| TabPartitionBoundarySpec OptTabPartitionStorageAttr OptTabPartitionColumnEncList OptTabSubPartitionSpec
	| column_reference_storage_directive
	;

TabSubPartitionElem :
	TabSubPartitionNameDecl OptTabPartitionBoundarySpec OptTabPartitionStorageAttr OptTabPartitionColumnEncList OptTabSubPartitionSpec
	| TabSubPartitionDefaultNameDecl OptTabPartitionBoundarySpec OptTabPartitionStorageAttr OptTabPartitionColumnEncList OptTabSubPartitionSpec
	| TabPartitionBoundarySpec OptTabPartitionStorageAttr OptTabPartitionColumnEncList OptTabSubPartitionSpec
	| column_reference_storage_directive
	;

TabPartitionNameDecl :
	PARTITION /*15N*/ PartitionColId
	;

TabPartitionDefaultNameDecl :
	DEFAULT PARTITION /*15N*/ PartitionColId
	;

TabSubPartitionNameDecl :
	SUBPARTITION /*246N*/ PartitionColId
	;

TabSubPartitionDefaultNameDecl :
	DEFAULT SUBPARTITION /*246N*/ PartitionColId
	;

partition_hash_keyword :
	HASH /*105N*/
	;

partition_coalesce_keyword :
	COALESCE /*292N*/
	;

TabPartitionByType :
	RANGE /*15N*/
	| partition_hash_keyword
	| LIST /*135N*/
	| /*empty*/
	;

OptTabPartitionBy :
	PARTITION /*15N*/ BY /*32N*/ TabPartitionByType '(' /*349L*/ columnList ')' /*349L*/ OptTabPartitionsNumber opt_list_subparts OptTabPartitionSpec
	| /*empty*/
	;

TabSubPartitionTemplate :
	SUBPARTITION /*246N*/ TEMPLATE /*255N*/ '(' /*349L*/ TabSubPartitionElemList ')' /*349L*/
	;

opt_list_subparts :
	list_subparts
	| /*empty*/
	;

opt_comma :
	','
	| /*empty*/
	;

list_subparts :
	TabSubPartitionBy
	| list_subparts opt_comma TabSubPartitionBy
	;

TabSubPartitionBy :
	SUBPARTITION /*246N*/ BY /*32N*/ TabPartitionByType '(' /*349L*/ columnList ')' /*349L*/ OptTabSubPartitionsNumber
	| TabSubPartitionTemplate
	;

CreateAsStmt :
	CREATE OptTemp TABLE create_as_target AS SelectStmt opt_with_data OptDistributedBy OptTabPartitionBy
	;

create_as_target :
	qualified_name OptCreateAs OptWith OnCommitOption OptTableSpace
	;

OptCreateAs :
	'(' /*349L*/ CreateAsList ')' /*349L*/
	| /*empty*/
	;

CreateAsList :
	CreateAsElement
	| CreateAsList ',' CreateAsElement
	;

CreateAsElement :
	ColId
	;

opt_with_data :
	WITH /*279N*/ DATA_P /*63N*/
	| WITH /*279N*/ NO /*161N*/ DATA_P /*63N*/
	| /*empty*/
	;

CreateForeignStmt :
	CREATE FOREIGN OptTemp TABLE qualified_name '(' /*349L*/ OptExtTableElementList ')' /*349L*/ SERVER /*232N*/ name create_generic_options
	;

CreateExternalStmt :
	CREATE OptWritable EXTERNAL /*91N*/ OptWeb OptTemp TABLE qualified_name '(' /*349L*/ OptExtTableElementList ')' /*349L*/ ExtTypedesc FORMAT /*97N*/ Sconst format_opt ext_opt_encoding_list OptSingleRowErrorHandling OptDistributedBy
	;

OptWritable :
	WRITABLE /*284N*/
	| READABLE /*202N*/
	| /*empty*/
	;

OptWeb :
	WEB /*278N*/
	| /*empty*/
	;

ExtTypedesc :
	LOCATION /*139N*/ '(' /*349L*/ cdb_string_list ')' /*349L*/
	| EXECUTE /*89N*/ Sconst ext_on_clause_list
	| /*empty*/
	;

ext_on_clause_list :
	ext_on_clause_list ext_on_clause_item
	| /*empty*/
	;

ext_on_clause_item :
	ON ALL
	| ON HOST /*108N*/ Sconst
	| ON HOST /*108N*/
	| ON MASTER /*142N*/
	| ON SEGMENT /*229N*/ Iconst
	| ON Iconst
	;

format_opt :
	'(' /*349L*/ format_opt_list ')' /*349L*/
	| '(' /*349L*/ ')' /*349L*/
	| /*empty*/
	;

format_opt_list :
	format_opt_item2
	| format_opt_item2 '=' /*7R*/ format_opt_item2
	| format_opt_item2 AS format_opt_item2
	| format_opt_list format_opt_item2
	| format_opt_list format_opt_item2 '=' /*7R*/ format_opt_item2
	| format_opt_list format_opt_item2 AS format_opt_item2
	| format_opt_list ',' format_opt_item2 '=' /*7R*/ format_opt_item2
	;

format_opt_keyword :
	DELIMITER /*72N*/
	| NULL_P /*342N*/
	| CSV /*59N*/
	| HEADER_P /*106N*/
	| QUOTE /*199N*/
	| ESCAPE /*10N*/
	| FORCE /*96N*/
	| NOT /*6R*/
	| FILL /*94N*/
	| MISSING /*151N*/
	| FIELDS /*93N*/
	| NEWLINE /*159N*/
	;

format_opt_item2 :
	IDENT /*15N*/
	| Sconst
	| SignedIconst
	| format_opt_keyword
	| '(' /*349L*/ columnListPlus ')' /*349L*/
	;

OptExtTableElementList :
	ExtTableElementList
	| /*empty*/
	;

ExtTableElementList :
	ExtTableElement
	| ExtTableElementList ',' ExtTableElement
	;

ExtTableElement :
	ExtcolumnDef
	| TableLikeClause
	| ExtTableConstraint
	;

ExtcolumnDef :
	ColId Typename
	;

OptSingleRowErrorHandling :
	OptErrorTableName OptSrehKeep SEGMENT /*229N*/ REJECT_P /*208N*/ LIMIT Iconst OptSrehLimitType
	| /*empty*/
	;

OptErrorTableName :
	LOG_P /*336N*/ ERRORS /*84N*/ INTO qualified_name
	| /*empty*/
	;

OptSrehLimitType :
	ROWS /*15N*/
	| PERCENT /*188N*/
	| /*empty*/
	;

OptSrehKeep :
	KEEP /*128N*/
	| /*empty*/
	;

ext_opt_encoding_list :
	ext_opt_encoding_list ext_opt_encoding_item
	| /*empty*/
	;

ext_opt_encoding_item :
	ENCODING /*80N*/ opt_equal Sconst
	| ENCODING /*80N*/ opt_equal Iconst
	;

ExtTableConstraint :
	ExtConstraintElem
	;

ExtConstraintElem :
	PRIMARY KEY /*129N*/ '(' /*349L*/ columnList ')' /*349L*/
	;

CreateSeqStmt :
	CREATE OptTemp SEQUENCE /*230N*/ qualified_name OptSeqList
	;

AlterSeqStmt :
	ALTER /*26N*/ SEQUENCE /*230N*/ qualified_name OptSeqList
	;

OptSeqList :
	OptSeqList OptSeqElem
	| /*empty*/
	;

OptSeqElem :
	CACHE /*33N*/ NumericOnly
	| CYCLE /*62N*/
	| NO /*161N*/ CYCLE /*62N*/
	| INCREMENT /*116N*/ opt_by NumericOnly
	| MAXVALUE /*145N*/ NumericOnly
	| MINVALUE /*149N*/ NumericOnly
	| NO /*161N*/ MAXVALUE /*145N*/
	| NO /*161N*/ MINVALUE /*149N*/
	| OWNED /*182N*/ BY /*32N*/ any_name
	| START /*240N*/ opt_with NumericOnly
	| RESTART /*216N*/ opt_with NumericOnly
	;

opt_by :
	BY /*32N*/
	| /*empty*/
	;

NumericOnly :
	FloatOnly
	| IntegerOnly
	;

FloatOnly :
	FCONST
	| '-' /*343L*/ FCONST
	;

IntegerOnly :
	SignedIconst
	;

CreatePLangStmt :
	CREATE opt_trusted opt_procedural LANGUAGE /*131N*/ ColId_or_Sconst
	| CREATE opt_trusted opt_procedural LANGUAGE /*131N*/ ColId_or_Sconst HANDLER /*104N*/ handler_name opt_validator opt_lancompiler
	;

opt_trusted :
	TRUSTED /*262N*/
	| /*empty*/
	;

handler_name :
	name
	| name attrs
	;

validator_clause :
	VALIDATOR /*272N*/ handler_name
	| NO /*161N*/ VALIDATOR /*272N*/
	;

opt_validator :
	validator_clause
	| /*empty*/
	;

opt_lancompiler :
	LANCOMPILER /*130N*/ Sconst
	| /*empty*/
	;

DropPLangStmt :
	DROP /*77N*/ opt_procedural LANGUAGE /*131N*/ ColId_or_Sconst opt_drop_behavior
	| DROP /*77N*/ opt_procedural LANGUAGE /*131N*/ IF_P /*110N*/ EXISTS /*297N*/ ColId_or_Sconst opt_drop_behavior
	;

opt_procedural :
	PROCEDURAL /*194N*/
	| /*empty*/
	;

CreateFileSpaceStmt :
	CREATE FILESPACE name OptOwner OptStorage '(' /*349L*/ Sconst ')' /*349L*/ opt_definition
	;

OptOwner :
	OWNER /*183N*/ name
	| /*empty*/
	;

OptStorage :
	ON name
	| /*empty*/
	;

CreateTableSpaceStmt :
	CREATE TABLESPACE /*252N*/ name OptOwner FILESPACE name
	;

CreateFdwStmt :
	CREATE FOREIGN DATA_P /*63N*/ WRAPPER /*283N*/ name opt_validator create_generic_options
	;

DropFdwStmt :
	DROP /*77N*/ FOREIGN DATA_P /*63N*/ WRAPPER /*283N*/ name opt_drop_behavior
	| DROP /*77N*/ FOREIGN DATA_P /*63N*/ WRAPPER /*283N*/ IF_P /*110N*/ EXISTS /*297N*/ name opt_drop_behavior
	;

AlterFdwStmt :
	ALTER /*26N*/ FOREIGN DATA_P /*63N*/ WRAPPER /*283N*/ name validator_clause alter_generic_options
	| ALTER /*26N*/ FOREIGN DATA_P /*63N*/ WRAPPER /*283N*/ name validator_clause
	| ALTER /*26N*/ FOREIGN DATA_P /*63N*/ WRAPPER /*283N*/ name alter_generic_options
	;

create_generic_options :
	OPTIONS /*178N*/ '(' /*349L*/ generic_option_list ')' /*349L*/
	| /*empty*/
	;

generic_option_list :
	generic_option_elem
	| generic_option_list ',' generic_option_elem
	;

alter_generic_options :
	OPTIONS /*178N*/ '(' /*349L*/ alter_generic_option_list ')' /*349L*/
	;

alter_generic_option_list :
	alter_generic_option_elem
	| alter_generic_option_list ',' alter_generic_option_elem
	;

alter_generic_option_elem :
	generic_option_elem
	| SET /*1N*/ generic_option_elem
	| ADD_P /*21N*/ generic_option_elem
	| DROP /*77N*/ generic_option_name
	;

generic_option_elem :
	generic_option_name generic_option_arg
	;

generic_option_name :
	ColLabel
	;

generic_option_arg :
	Sconst
	;

CreateForeignServerStmt :
	CREATE SERVER /*232N*/ name opt_type opt_foreign_server_version FOREIGN DATA_P /*63N*/ WRAPPER /*283N*/ name create_generic_options
	;

opt_type :
	TYPE_P /*263N*/ Sconst
	| /*empty*/
	;

foreign_server_version :
	VERSION_P /*275N*/ Sconst
	| VERSION_P /*275N*/ NULL_P /*342N*/
	;

opt_foreign_server_version :
	foreign_server_version
	| /*empty*/
	;

DropForeignServerStmt :
	DROP /*77N*/ SERVER /*232N*/ name opt_drop_behavior
	| DROP /*77N*/ SERVER /*232N*/ IF_P /*110N*/ EXISTS /*297N*/ name opt_drop_behavior
	;

AlterForeignServerStmt :
	ALTER /*26N*/ SERVER /*232N*/ name foreign_server_version alter_generic_options
	| ALTER /*26N*/ SERVER /*232N*/ name foreign_server_version
	| ALTER /*26N*/ SERVER /*232N*/ name alter_generic_options
	;

CreateUserMappingStmt :
	CREATE USER MAPPING /*143N*/ FOR auth_ident SERVER /*232N*/ name create_generic_options
	;

auth_ident :
	CURRENT_USER
	| USER
	| RoleId
	;

DropUserMappingStmt :
	DROP /*77N*/ USER MAPPING /*143N*/ FOR auth_ident SERVER /*232N*/ name
	| DROP /*77N*/ USER MAPPING /*143N*/ IF_P /*110N*/ EXISTS /*297N*/ FOR auth_ident SERVER /*232N*/ name
	;

AlterUserMappingStmt :
	ALTER /*26N*/ USER MAPPING /*143N*/ FOR auth_ident SERVER /*232N*/ name alter_generic_options
	;

CreateTrigStmt :
	CREATE TRIGGER /*260N*/ name TriggerActionTime TriggerEvents ON qualified_name TriggerForSpec EXECUTE /*89N*/ PROCEDURE /*195N*/ func_name '(' /*349L*/ TriggerFuncArgs ')' /*349L*/
	| CREATE CONSTRAINT TRIGGER /*260N*/ name AFTER /*23N*/ TriggerEvents ON qualified_name OptConstrFromTable ConstraintAttributeSpec FOR EACH /*78N*/ ROW /*322N*/ EXECUTE /*89N*/ PROCEDURE /*195N*/ func_name '(' /*349L*/ TriggerFuncArgs ')' /*349L*/
	;

TriggerActionTime :
	BEFORE /*30N*/
	| AFTER /*23N*/
	;

TriggerEvents :
	TriggerOneEvent
	| TriggerOneEvent OR /*4L*/ TriggerOneEvent
	| TriggerOneEvent OR /*4L*/ TriggerOneEvent OR /*4L*/ TriggerOneEvent
	;

TriggerOneEvent :
	INSERT /*123N*/
	| DELETE_P /*71N*/
	| UPDATE /*268N*/
	;

TriggerForSpec :
	FOR TriggerForOpt TriggerForType
	| /*empty*/
	;

TriggerForOpt :
	EACH /*78N*/
	| /*empty*/
	;

TriggerForType :
	ROW /*322N*/
	| STATEMENT /*241N*/
	;

TriggerFuncArgs :
	TriggerFuncArg
	| TriggerFuncArgs ',' TriggerFuncArg
	| /*empty*/
	;

TriggerFuncArg :
	ICONST
	| FCONST
	| Sconst
	| BCONST
	| XCONST
	| ColId
	;

OptConstrFromTable :
	FROM qualified_name
	| /*empty*/
	;

ConstraintAttributeSpec :
	ConstraintDeferrabilitySpec
	| ConstraintDeferrabilitySpec ConstraintTimeSpec
	| ConstraintTimeSpec
	| ConstraintTimeSpec ConstraintDeferrabilitySpec
	| /*empty*/
	;

ConstraintDeferrabilitySpec :
	NOT /*6R*/ DEFERRABLE
	| DEFERRABLE
	;

ConstraintTimeSpec :
	INITIALLY IMMEDIATE /*111N*/
	| INITIALLY DEFERRED /*69N*/
	;

DropTrigStmt :
	DROP /*77N*/ TRIGGER /*260N*/ name ON qualified_name opt_drop_behavior
	| DROP /*77N*/ TRIGGER /*260N*/ IF_P /*110N*/ EXISTS /*297N*/ name ON qualified_name opt_drop_behavior
	;

CreateAssertStmt :
	CREATE ASSERTION /*27N*/ name CHECK '(' /*349L*/ a_expr ')' /*349L*/ ConstraintAttributeSpec
	;

DropAssertStmt :
	DROP /*77N*/ ASSERTION /*27N*/ name opt_drop_behavior
	;

DefineStmt :
	CREATE opt_ordered AGGREGATE /*24N*/ func_name aggr_args definition
	| CREATE opt_ordered AGGREGATE /*24N*/ func_name old_aggr_definition
	| CREATE OPERATOR /*339L*/ any_operator definition
	| CREATE TYPE_P /*263N*/ any_name definition
	| CREATE TYPE_P /*263N*/ any_name
	| CREATE TYPE_P /*263N*/ any_name AS '(' /*349L*/ TableFuncElementList ')' /*349L*/
	| CREATE opt_trusted PROTOCOL /*197N*/ name definition
	| CREATE opt_trusted FILESYSTEM /*196N*/ any_name definition
	;

opt_ordered :
	ORDERED
	| /*empty*/
	;

definition :
	'(' /*349L*/ def_list ')' /*349L*/
	;

def_list :
	def_elem
	| def_list ',' def_elem
	;

def_elem :
	ColLabel '=' /*7R*/ def_arg
	| ColLabel
	;

def_arg :
	func_type
	| ROW /*322N*/
	| func_name_keyword
	| reserved_keyword
	| qual_all_Op
	| NumericOnly
	| Sconst
	| NONE /*311N*/
	;

aggr_args :
	'(' /*349L*/ aggr_args_list ')' /*349L*/
	| '(' /*349L*/ '*' /*344L*/ ')' /*349L*/
	;

aggr_args_list :
	Typename
	| aggr_args_list ',' Typename
	;

old_aggr_definition :
	'(' /*349L*/ old_aggr_list ')' /*349L*/
	;

old_aggr_list :
	old_aggr_elem
	| old_aggr_list ',' old_aggr_elem
	;

old_aggr_elem :
	IDENT /*15N*/ '=' /*7R*/ def_arg
	;

CreateOpClassStmt :
	CREATE OPERATOR /*339L*/ CLASS /*40N*/ any_name opt_default FOR TYPE_P /*263N*/ Typename USING access_method AS opclass_item_list
	;

opclass_item_list :
	opclass_item
	| opclass_item_list ',' opclass_item
	;

opclass_item :
	OPERATOR /*339L*/ Iconst any_operator opt_recheck
	| OPERATOR /*339L*/ Iconst any_operator '(' /*349L*/ oper_argtypes ')' /*349L*/ opt_recheck
	| FUNCTION /*100N*/ Iconst func_name func_args
	| STORAGE /*245N*/ Typename
	;

opt_default :
	DEFAULT
	| /*empty*/
	;

opt_recheck :
	RECHECK /*205N*/
	| /*empty*/
	;

DropOpClassStmt :
	DROP /*77N*/ OPERATOR /*339L*/ CLASS /*40N*/ any_name USING access_method opt_drop_behavior
	| DROP /*77N*/ OPERATOR /*339L*/ CLASS /*40N*/ IF_P /*110N*/ EXISTS /*297N*/ any_name USING access_method opt_drop_behavior
	;

DropOwnedStmt :
	DROP /*77N*/ OWNED /*182N*/ BY /*32N*/ name_list opt_drop_behavior
	;

ReassignOwnedStmt :
	REASSIGN /*204N*/ OWNED /*182N*/ BY /*32N*/ name_list TO name
	;

DropStmt :
	DROP /*77N*/ drop_type IF_P /*110N*/ EXISTS /*297N*/ any_name_list opt_drop_behavior
	| DROP /*77N*/ drop_type any_name_list opt_drop_behavior
	;

drop_type :
	TABLE
	| EXTERNAL /*91N*/ TABLE
	| EXTERNAL /*91N*/ WEB /*278N*/ TABLE
	| SEQUENCE /*230N*/
	| VIEW /*276N*/
	| INDEX /*117N*/
	| TYPE_P /*263N*/
	| DOMAIN_P /*75N*/
	| CONVERSION_P /*52N*/
	| SCHEMA /*224N*/
	| FILESPACE
	| FILESYSTEM /*196N*/
	| TABLESPACE /*252N*/
	| FOREIGN TABLE
	| PROTOCOL /*197N*/
	| VERTEX
	| EDGE
	| GRAPH
	;

any_name_list :
	any_name
	| any_name_list ',' any_name
	;

any_name :
	ColId
	| ColId attrs
	;

attrs :
	'.' /*351L*/ attr_name
	| attrs '.' /*351L*/ attr_name
	;

TruncateStmt :
	TRUNCATE /*261N*/ opt_table qualified_name_list opt_drop_behavior
	;

CommentStmt :
	COMMENT /*43N*/ ON comment_type any_name IS /*342N*/ comment_text
	| COMMENT /*43N*/ ON AGGREGATE /*24N*/ func_name aggr_args IS /*342N*/ comment_text
	| COMMENT /*43N*/ ON FUNCTION /*100N*/ func_name func_args IS /*342N*/ comment_text
	| COMMENT /*43N*/ ON OPERATOR /*339L*/ any_operator '(' /*349L*/ oper_argtypes ')' /*349L*/ IS /*342N*/ comment_text
	| COMMENT /*43N*/ ON CONSTRAINT name ON any_name IS /*342N*/ comment_text
	| COMMENT /*43N*/ ON RULE /*222N*/ name ON any_name IS /*342N*/ comment_text
	| COMMENT /*43N*/ ON RULE /*222N*/ name IS /*342N*/ comment_text
	| COMMENT /*43N*/ ON TRIGGER /*260N*/ name ON any_name IS /*342N*/ comment_text
	| COMMENT /*43N*/ ON OPERATOR /*339L*/ CLASS /*40N*/ any_name USING access_method IS /*342N*/ comment_text
	| COMMENT /*43N*/ ON LARGE_P /*132N*/ OBJECT_P /*174N*/ NumericOnly IS /*342N*/ comment_text
	| COMMENT /*43N*/ ON CAST '(' /*349L*/ Typename AS Typename ')' /*349L*/ IS /*342N*/ comment_text
	| COMMENT /*43N*/ ON opt_procedural LANGUAGE /*131N*/ any_name IS /*342N*/ comment_text
	;

comment_type :
	COLUMN
	| DATABASE /*64N*/
	| SCHEMA /*224N*/
	| INDEX /*117N*/
	| SEQUENCE /*230N*/
	| TABLE
	| DOMAIN_P /*75N*/
	| TYPE_P /*263N*/
	| VIEW /*276N*/
	| CONVERSION_P /*52N*/
	| TABLESPACE /*252N*/
	| ROLE /*220N*/
	| FILESPACE
	| RESOURCE /*215N*/ QUEUE /*198N*/
	;

comment_text :
	Sconst
	| NULL_P /*342N*/
	;

FetchStmt :
	FETCH /*92N*/ fetch_direction from_in name
	| FETCH /*92N*/ name
	| MOVE /*156N*/ fetch_direction from_in name
	| MOVE /*156N*/ name
	;

fetch_direction :
	/*empty*/
	| NEXT /*160N*/
	| PRIOR /*192N*/
	| FIRST_P /*95N*/
	| LAST_P /*133N*/
	| ABSOLUTE_P /*17N*/ SignedIconst
	| RELATIVE_P /*209N*/ SignedIconst
	| SignedIconst
	| ALL
	| FORWARD /*99N*/
	| FORWARD /*99N*/ SignedIconst
	| FORWARD /*99N*/ ALL
	| BACKWARD /*29N*/
	| BACKWARD /*29N*/ SignedIconst
	| BACKWARD /*29N*/ ALL
	;

from_in :
	FROM
	| IN_P /*13N*/
	;

GrantStmt :
	GRANT privileges ON privilege_target TO grantee_list opt_grant_grant_option
	;

RevokeStmt :
	REVOKE /*219N*/ privileges ON privilege_target FROM grantee_list opt_drop_behavior
	| REVOKE /*219N*/ GRANT OPTION /*177N*/ FOR privileges ON privilege_target FROM grantee_list opt_drop_behavior
	;

privileges :
	privilege_list
	| ALL
	| ALL PRIVILEGES /*193N*/
	;

privilege_list :
	privilege
	| privilege_list ',' privilege
	;

privilege :
	SELECT
	| REFERENCES
	| CREATE
	| ColId
	;

privilege_target :
	qualified_name_list
	| TABLE qualified_name_list
	| SEQUENCE /*230N*/ qualified_name_list
	| FOREIGN DATA_P /*63N*/ WRAPPER /*283N*/ name_list
	| FOREIGN SERVER /*232N*/ name_list
	| FUNCTION /*100N*/ function_with_argtypes_list
	| DATABASE /*64N*/ name_list
	| LANGUAGE /*131N*/ name_list
	| SCHEMA /*224N*/ name_list
	| TABLESPACE /*252N*/ name_list
	| PROTOCOL /*197N*/ name_list
	| ALL TABLES IN_P /*13N*/ SCHEMA /*224N*/ name_list
	| ALL SEQUENCES IN_P /*13N*/ SCHEMA /*224N*/ name_list
	| ALL FUNCTIONS IN_P /*13N*/ SCHEMA /*224N*/ name_list
	;

grantee_list :
	grantee
	| grantee_list ',' grantee
	;

grantee :
	RoleId
	| GROUP_P RoleId
	;

opt_grant_grant_option :
	WITH /*279N*/ GRANT OPTION /*177N*/
	| /*empty*/
	;

function_with_argtypes_list :
	function_with_argtypes
	| function_with_argtypes_list ',' function_with_argtypes
	;

function_with_argtypes :
	func_name func_args
	;

GrantRoleStmt :
	GRANT privilege_list TO name_list opt_grant_admin_option opt_granted_by
	;

RevokeRoleStmt :
	REVOKE /*219N*/ privilege_list FROM name_list opt_granted_by opt_drop_behavior
	| REVOKE /*219N*/ ADMIN /*22N*/ OPTION /*177N*/ FOR privilege_list FROM name_list opt_granted_by opt_drop_behavior
	;

opt_grant_admin_option :
	WITH /*279N*/ ADMIN /*22N*/ OPTION /*177N*/
	| /*empty*/
	;

opt_granted_by :
	GRANTED /*103N*/ BY /*32N*/ RoleId
	| /*empty*/
	;

IndexStmt :
	CREATE index_opt_unique INDEX /*117N*/ index_name ON index_opt_reverse qualified_name access_method_clause '(' /*349L*/ index_params ')' /*349L*/ opt_include opt_definition OptTableSpace where_clause
	| CREATE index_opt_unique INDEX /*117N*/ index_name ON index_opt_reverse qualified_name access_method_clause opt_include opt_definition OptTableSpace where_clause
	| CREATE index_opt_unique INDEX /*117N*/ CONCURRENTLY /*46N*/ index_name ON qualified_name access_method_clause '(' /*349L*/ index_params ')' /*349L*/ opt_include opt_definition OptTableSpace where_clause
	;

index_opt_reverse :
	REVERSED
	| /*empty*/
	;

index_opt_unique :
	UNIQUE
	| /*empty*/
	;

access_method_clause :
	USING access_method
	| /*empty*/
	;

index_params :
	index_elem
	| index_params ',' index_elem
	;

index_elem :
	ColId opt_class
	| func_expr opt_class
	| '(' /*349L*/ a_expr ')' /*349L*/ opt_class
	;

opt_include :
	INCLUDE '(' /*349L*/ index_including_params ')' /*349L*/
	| /*empty*/
	;

index_including_params :
	index_elem
	| index_including_params ',' index_elem
	;

opt_class :
	any_name
	| USING any_name
	| /*empty*/
	;

CreateFunctionStmt :
	CREATE opt_or_replace FUNCTION /*100N*/ func_name func_args RETURNS /*218N*/ func_return createfunc_opt_list opt_definition
	| CREATE opt_or_replace FUNCTION /*100N*/ func_name func_args RETURNS /*218N*/ TABLE '(' /*349L*/ table_func_column_list ')' /*349L*/ createfunc_opt_list opt_definition
	| CREATE opt_or_replace FUNCTION /*100N*/ func_name func_args createfunc_opt_list opt_definition
	;

opt_or_replace :
	OR /*4L*/ REPLACE /*213N*/
	| /*empty*/
	;

func_args :
	'(' /*349L*/ func_args_list ')' /*349L*/
	| '(' /*349L*/ ')' /*349L*/
	;

func_args_list :
	func_arg
	| func_args_list ',' func_arg
	;

func_arg :
	arg_class param_name func_type
	| param_name arg_class func_type
	| param_name func_type
	| arg_class func_type
	| func_type
	;

arg_class :
	IN_P /*13N*/
	| OUT_P /*314N*/
	| INOUT /*303N*/
	| IN_P /*13N*/ OUT_P /*314N*/
	| VARIADIC
	;

param_name :
	function_name
	;

func_return :
	func_type
	;

func_type :
	Typename
	| type_name attrs '%' /*344L*/ TYPE_P /*263N*/
	| SETOF /*323N*/ type_name attrs '%' /*344L*/ TYPE_P /*263N*/
	;

createfunc_opt_list :
	createfunc_opt_item
	| createfunc_opt_list createfunc_opt_item
	;

common_func_opt_item :
	CALLED /*34N*/ ON NULL_P /*342N*/ INPUT_P /*121N*/
	| RETURNS /*218N*/ NULL_P /*342N*/ ON NULL_P /*342N*/ INPUT_P /*121N*/
	| STRICT_P /*251N*/
	| IMMUTABLE /*112N*/
	| STABLE /*239N*/
	| VOLATILE /*277N*/
	| EXTERNAL /*91N*/ SECURITY /*228N*/ DEFINER /*70N*/
	| EXTERNAL /*91N*/ SECURITY /*228N*/ INVOKER /*125N*/
	| SECURITY /*228N*/ DEFINER /*70N*/
	| SECURITY /*228N*/ INVOKER /*125N*/
	| NO /*161N*/ SQL /*238N*/
	| CONTAINS /*49N*/ SQL /*238N*/
	| READS /*203N*/ SQL /*238N*/ DATA_P /*63N*/
	| MODIFIES /*153N*/ SQL /*238N*/ DATA_P /*63N*/
	;

createfunc_opt_item :
	AS func_as
	| LANGUAGE /*131N*/ ColId_or_Sconst
	| common_func_opt_item
	;

func_as :
	Sconst
	| Sconst ',' Sconst
	;

opt_definition :
	WITH /*279N*/ definition
	| /*empty*/
	;

table_func_column :
	param_name func_type
	;

table_func_column_list :
	table_func_column
	| table_func_column_list ',' table_func_column
	;

AlterFunctionStmt :
	ALTER /*26N*/ FUNCTION /*100N*/ function_with_argtypes alterfunc_opt_list opt_restrict
	;

alterfunc_opt_list :
	common_func_opt_item
	| alterfunc_opt_list common_func_opt_item
	;

opt_restrict :
	RESTRICT /*217N*/
	| /*empty*/
	;

RemoveFuncStmt :
	DROP /*77N*/ FUNCTION /*100N*/ func_name func_args opt_drop_behavior
	| DROP /*77N*/ FUNCTION /*100N*/ IF_P /*110N*/ EXISTS /*297N*/ func_name func_args opt_drop_behavior
	;

RemoveAggrStmt :
	DROP /*77N*/ AGGREGATE /*24N*/ func_name aggr_args opt_drop_behavior
	| DROP /*77N*/ AGGREGATE /*24N*/ IF_P /*110N*/ EXISTS /*297N*/ func_name aggr_args opt_drop_behavior
	;

RemoveOperStmt :
	DROP /*77N*/ OPERATOR /*339L*/ any_operator '(' /*349L*/ oper_argtypes ')' /*349L*/ opt_drop_behavior
	| DROP /*77N*/ OPERATOR /*339L*/ IF_P /*110N*/ EXISTS /*297N*/ any_operator '(' /*349L*/ oper_argtypes ')' /*349L*/ opt_drop_behavior
	;

oper_argtypes :
	Typename
	| Typename ',' Typename
	| NONE /*311N*/ ',' Typename
	| Typename ',' NONE /*311N*/
	;

any_operator :
	all_Op
	| ColId '.' /*351L*/ any_operator
	;

CreateCastStmt :
	CREATE CAST '(' /*349L*/ Typename AS Typename ')' /*349L*/ WITH /*279N*/ FUNCTION /*100N*/ function_with_argtypes cast_context
	| CREATE CAST '(' /*349L*/ Typename AS Typename ')' /*349L*/ WITHOUT /*281N*/ FUNCTION /*100N*/ cast_context
	;

cast_context :
	AS IMPLICIT_P /*113N*/
	| AS ASSIGNMENT /*28N*/
	| /*empty*/
	;

DropCastStmt :
	DROP /*77N*/ CAST opt_if_exists '(' /*349L*/ Typename AS Typename ')' /*349L*/ opt_drop_behavior
	;

opt_if_exists :
	IF_P /*110N*/ EXISTS /*297N*/
	| /*empty*/
	;

ReindexStmt :
	REINDEX /*207N*/ reindex_type qualified_name opt_force
	| REINDEX /*207N*/ SYSTEM_P /*250N*/ name opt_force
	| REINDEX /*207N*/ DATABASE /*64N*/ name opt_force
	;

reindex_type :
	INDEX /*117N*/
	| TABLE
	;

opt_force :
	FORCE /*96N*/
	| /*empty*/
	;

AlterTypeStmt :
	ALTER /*26N*/ TYPE_P /*263N*/ SimpleTypename SET /*1N*/ DEFAULT ENCODING /*80N*/ definition
	;

RenameStmt :
	ALTER /*26N*/ AGGREGATE /*24N*/ func_name aggr_args RENAME /*211N*/ TO name
	| ALTER /*26N*/ CONVERSION_P /*52N*/ any_name RENAME /*211N*/ TO name
	| ALTER /*26N*/ DATABASE /*64N*/ database_name RENAME /*211N*/ TO database_name
	| ALTER /*26N*/ FILESPACE name RENAME /*211N*/ TO name
	| ALTER /*26N*/ FILESYSTEM /*196N*/ name RENAME /*211N*/ TO name
	| ALTER /*26N*/ FUNCTION /*100N*/ func_name func_args RENAME /*211N*/ TO name
	| ALTER /*26N*/ GROUP_P RoleId RENAME /*211N*/ TO RoleId
	| ALTER /*26N*/ LANGUAGE /*131N*/ name RENAME /*211N*/ TO name
	| ALTER /*26N*/ OPERATOR /*339L*/ CLASS /*40N*/ any_name USING access_method RENAME /*211N*/ TO name
	| ALTER /*26N*/ SCHEMA /*224N*/ name RENAME /*211N*/ TO name
	| ALTER /*26N*/ TABLE relation_expr RENAME /*211N*/ TO name
	| ALTER /*26N*/ INDEX /*117N*/ relation_expr RENAME /*211N*/ TO name
	| ALTER /*26N*/ TABLE relation_expr RENAME /*211N*/ opt_column name TO name
	| ALTER /*26N*/ TRIGGER /*260N*/ name ON relation_expr RENAME /*211N*/ TO name
	| ALTER /*26N*/ ROLE /*220N*/ RoleId RENAME /*211N*/ TO RoleId
	| ALTER /*26N*/ USER RoleId RENAME /*211N*/ TO RoleId
	| ALTER /*26N*/ TABLESPACE /*252N*/ name RENAME /*211N*/ TO name
	| ALTER /*26N*/ PROTOCOL /*197N*/ name RENAME /*211N*/ TO name
	;

opt_column :
	COLUMN
	| /*empty*/
	;

AlterObjectSchemaStmt :
	ALTER /*26N*/ AGGREGATE /*24N*/ func_name aggr_args SET /*1N*/ SCHEMA /*224N*/ name
	| ALTER /*26N*/ DOMAIN_P /*75N*/ any_name SET /*1N*/ SCHEMA /*224N*/ name
	| ALTER /*26N*/ FUNCTION /*100N*/ func_name func_args SET /*1N*/ SCHEMA /*224N*/ name
	| ALTER /*26N*/ SEQUENCE /*230N*/ relation_expr SET /*1N*/ SCHEMA /*224N*/ name
	| ALTER /*26N*/ TABLE relation_expr SET /*1N*/ SCHEMA /*224N*/ name
	| ALTER /*26N*/ TYPE_P /*263N*/ SimpleTypename SET /*1N*/ SCHEMA /*224N*/ name
	;

AlterOwnerStmt :
	ALTER /*26N*/ AGGREGATE /*24N*/ func_name aggr_args OWNER /*183N*/ TO RoleId
	| ALTER /*26N*/ CONVERSION_P /*52N*/ any_name OWNER /*183N*/ TO RoleId
	| ALTER /*26N*/ DATABASE /*64N*/ database_name OWNER /*183N*/ TO RoleId
	| ALTER /*26N*/ DOMAIN_P /*75N*/ any_name OWNER /*183N*/ TO RoleId
	| ALTER /*26N*/ FILESPACE name OWNER /*183N*/ TO RoleId
	| ALTER /*26N*/ FILESYSTEM /*196N*/ name OWNER /*183N*/ TO RoleId
	| ALTER /*26N*/ FUNCTION /*100N*/ func_name func_args OWNER /*183N*/ TO RoleId
	| ALTER /*26N*/ OPERATOR /*339L*/ any_operator '(' /*349L*/ oper_argtypes ')' /*349L*/ OWNER /*183N*/ TO RoleId
	| ALTER /*26N*/ OPERATOR /*339L*/ CLASS /*40N*/ any_name USING access_method OWNER /*183N*/ TO RoleId
	| ALTER /*26N*/ SCHEMA /*224N*/ name OWNER /*183N*/ TO RoleId
	| ALTER /*26N*/ TYPE_P /*263N*/ SimpleTypename OWNER /*183N*/ TO RoleId
	| ALTER /*26N*/ TABLESPACE /*252N*/ name OWNER /*183N*/ TO RoleId
	| ALTER /*26N*/ FOREIGN DATA_P /*63N*/ WRAPPER /*283N*/ name OWNER /*183N*/ TO RoleId
	| ALTER /*26N*/ SERVER /*232N*/ name OWNER /*183N*/ TO RoleId
	| ALTER /*26N*/ PROTOCOL /*197N*/ name OWNER /*183N*/ TO RoleId
	;

RuleStmt :
	CREATE opt_or_replace RULE /*222N*/ name AS ON event TO qualified_name where_clause DO opt_instead RuleActionList
	;

RuleActionList :
	NOTHING /*170N*/
	| RuleActionStmt
	| '(' /*349L*/ RuleActionMulti ')' /*349L*/
	;

RuleActionMulti :
	RuleActionMulti ';' RuleActionStmtOrEmpty
	| RuleActionStmtOrEmpty
	;

RuleActionStmt :
	SelectStmt
	| InsertStmt
	| UpdateStmt
	| DeleteStmt
	| NotifyStmt
	;

RuleActionStmtOrEmpty :
	RuleActionStmt
	| /*empty*/
	;

event :
	SELECT
	| UPDATE /*268N*/
	| DELETE_P /*71N*/
	| INSERT /*123N*/
	;

opt_instead :
	INSTEAD /*124N*/
	| ALSO /*25N*/
	| /*empty*/
	;

DropRuleStmt :
	DROP /*77N*/ RULE /*222N*/ name ON qualified_name opt_drop_behavior
	| DROP /*77N*/ RULE /*222N*/ IF_P /*110N*/ EXISTS /*297N*/ name ON qualified_name opt_drop_behavior
	;

NotifyStmt :
	NOTIFY /*171N*/ qualified_name
	;

ListenStmt :
	LISTEN /*136N*/ qualified_name
	;

UnlistenStmt :
	UNLISTEN /*266N*/ qualified_name
	| UNLISTEN /*266N*/ '*' /*344L*/
	;

TransactionStmt :
	ABORT_P /*16N*/ opt_transaction
	| BEGIN_P /*31N*/ opt_transaction transaction_mode_list_or_empty
	| START /*240N*/ TRANSACTION /*259N*/ transaction_mode_list_or_empty
	| COMMIT /*44N*/ opt_transaction
	| END_P /*82N*/ opt_transaction
	| ROLLBACK /*221N*/ opt_transaction
	| SAVEPOINT /*223N*/ ColId
	| RELEASE /*210N*/ SAVEPOINT /*223N*/ ColId
	| RELEASE /*210N*/ ColId
	| ROLLBACK /*221N*/ opt_transaction TO SAVEPOINT /*223N*/ ColId
	| ROLLBACK /*221N*/ opt_transaction TO ColId
	| PREPARE /*189N*/ TRANSACTION /*259N*/ Sconst
	| COMMIT /*44N*/ PREPARED /*190N*/ Sconst
	| ROLLBACK /*221N*/ PREPARED /*190N*/ Sconst
	;

opt_transaction :
	WORK /*282N*/
	| TRANSACTION /*259N*/
	| /*empty*/
	;

transaction_mode_item :
	ISOLATION /*126N*/ LEVEL /*134N*/ iso_level
	| READ /*201N*/ ONLY
	| READ /*201N*/ WRITE /*285N*/
	;

transaction_mode_list :
	transaction_mode_item
	| transaction_mode_list ',' transaction_mode_item
	| transaction_mode_list transaction_mode_item
	;

transaction_mode_list_or_empty :
	transaction_mode_list
	| /*empty*/
	;

ViewStmt :
	CREATE OptTemp VIEW /*276N*/ qualified_name opt_column_list AS SelectStmt opt_check_option
	| CREATE OR /*4L*/ REPLACE /*213N*/ OptTemp VIEW /*276N*/ qualified_name opt_column_list AS SelectStmt opt_check_option
	;

opt_check_option :
	WITH_CHECK OPTION /*177N*/
	| WITH_CASCADED CHECK OPTION /*177N*/
	| WITH_LOCAL CHECK OPTION /*177N*/
	| /*empty*/
	;

LoadStmt :
	LOAD /*137N*/ file_name
	;

CreatedbStmt :
	CREATE DATABASE /*64N*/ database_name opt_with createdb_opt_list
	;

createdb_opt_list :
	createdb_opt_list createdb_opt_item
	| /*empty*/
	;

createdb_opt_item :
	TABLESPACE /*252N*/ opt_equal name
	| TABLESPACE /*252N*/ opt_equal DEFAULT
	| LOCATION /*139N*/ opt_equal Sconst
	| LOCATION /*139N*/ opt_equal DEFAULT
	| TEMPLATE /*255N*/ opt_equal name
	| TEMPLATE /*255N*/ opt_equal DEFAULT
	| ENCODING /*80N*/ opt_equal Sconst
	| ENCODING /*80N*/ opt_equal Iconst
	| ENCODING /*80N*/ opt_equal DEFAULT
	| CONNECTION /*47N*/ LIMIT opt_equal SignedIconst
	| OWNER /*183N*/ opt_equal name
	| OWNER /*183N*/ opt_equal DEFAULT
	;

opt_equal :
	'=' /*7R*/
	| /*empty*/
	;

AlterDatabaseStmt :
	ALTER /*26N*/ DATABASE /*64N*/ database_name opt_with alterdb_opt_list
	;

AlterDatabaseSetStmt :
	ALTER /*26N*/ DATABASE /*64N*/ database_name SET /*1N*/ set_rest
	| ALTER /*26N*/ DATABASE /*64N*/ database_name VariableResetStmt
	;

alterdb_opt_list :
	alterdb_opt_list alterdb_opt_item
	| /*empty*/
	;

alterdb_opt_item :
	CONNECTION /*47N*/ LIMIT opt_equal SignedIconst
	;

DropdbStmt :
	DROP /*77N*/ DATABASE /*64N*/ database_name
	| DROP /*77N*/ DATABASE /*64N*/ IF_P /*110N*/ EXISTS /*297N*/ database_name
	;

CreateDomainStmt :
	CREATE DOMAIN_P /*75N*/ any_name opt_as Typename ColQualList
	;

AlterDomainStmt :
	ALTER /*26N*/ DOMAIN_P /*75N*/ any_name alter_column_default
	| ALTER /*26N*/ DOMAIN_P /*75N*/ any_name DROP /*77N*/ NOT /*6R*/ NULL_P /*342N*/
	| ALTER /*26N*/ DOMAIN_P /*75N*/ any_name SET /*1N*/ NOT /*6R*/ NULL_P /*342N*/
	| ALTER /*26N*/ DOMAIN_P /*75N*/ any_name ADD_P /*21N*/ TableConstraint
	| ALTER /*26N*/ DOMAIN_P /*75N*/ any_name DROP /*77N*/ CONSTRAINT name opt_drop_behavior
	;

opt_as :
	AS
	| /*empty*/
	;

CreateConversionStmt :
	CREATE opt_default CONVERSION_P /*52N*/ any_name FOR Sconst TO Sconst FROM any_name
	;

ClusterStmt :
	CLUSTER /*42N*/ opt_verbose index_name ON qualified_name
	| CLUSTER /*42N*/ opt_verbose qualified_name
	| CLUSTER /*42N*/ opt_verbose
	;

VacuumStmt :
	VACUUM /*269N*/ opt_full opt_freeze opt_verbose
	| VACUUM /*269N*/ opt_full opt_freeze opt_verbose qualified_name
	| VACUUM /*269N*/ opt_full opt_freeze opt_verbose AnalyzeStmt
	;

AnalyzeStmt :
	analyze_keyword opt_verbose opt_rootonly_all
	| analyze_keyword opt_verbose qualified_name opt_name_list
	| analyze_keyword opt_verbose ROOTPARTITION qualified_name opt_name_list
	;

analyze_keyword :
	ANALYZE
	| ANALYSE
	;

opt_verbose :
	VERBOSE /*338N*/
	| /*empty*/
	;

opt_rootonly_all :
	ROOTPARTITION ALL
	| /*empty*/
	;

opt_full :
	FULL /*352L*/
	| /*empty*/
	;

opt_freeze :
	FREEZE /*335N*/
	| /*empty*/
	;

opt_name_list :
	'(' /*349L*/ name_list ')' /*349L*/
	| /*empty*/
	;

ExplainStmt :
	EXPLAIN /*90N*/ opt_analyze opt_verbose opt_dxl opt_force ExplainableStmt
	;

ExplainableStmt :
	SelectStmt
	| InsertStmt
	| UpdateStmt
	| DeleteStmt
	| DeclareCursorStmt
	| ExecuteStmt
	| CreateAsStmt
	| CreateStmt
	;

opt_dxl :
	DXL
	| /*empty*/
	;

opt_analyze :
	analyze_keyword
	| /*empty*/
	;

PrepareStmt :
	PREPARE /*189N*/ name prep_type_clause AS PreparableStmt
	;

prep_type_clause :
	'(' /*349L*/ prep_type_list ')' /*349L*/
	| /*empty*/
	;

prep_type_list :
	Typename
	| prep_type_list ',' Typename
	;

PreparableStmt :
	SelectStmt
	| InsertStmt
	| UpdateStmt
	| DeleteStmt
	;

ExecuteStmt :
	EXECUTE /*89N*/ name execute_param_clause
	| CREATE OptTemp TABLE create_as_target AS EXECUTE /*89N*/ name execute_param_clause
	;

execute_param_clause :
	'(' /*349L*/ expr_list ')' /*349L*/
	| /*empty*/
	;

DeallocateStmt :
	DEALLOCATE /*66N*/ name
	| DEALLOCATE /*66N*/ PREPARE /*189N*/ name
	;

cdb_string_list :
	cdb_string
	| cdb_string_list ',' cdb_string
	;

cdb_string :
	Sconst
	;

InsertStmt :
	INSERT /*123N*/ INTO qualified_name insert_rest returning_clause
	;

insert_rest :
	SelectStmt
	| '(' /*349L*/ insert_column_list ')' /*349L*/ SelectStmt
	| DEFAULT VALUES /*331N*/
	;

insert_column_list :
	insert_column_item
	| insert_column_list ',' insert_column_item
	;

insert_column_item :
	ColId opt_indirection
	;

returning_clause :
	RETURNING target_list
	| /*empty*/
	;

DeleteStmt :
	DELETE_P /*71N*/ FROM relation_expr_opt_alias using_clause where_or_current_clause returning_clause
	;

using_clause :
	USING from_list
	| /*empty*/
	;

LockStmt :
	LOCK_P /*140N*/ opt_table qualified_name_list opt_lock opt_nowait
	;

opt_lock :
	IN_P /*13N*/ lock_type MODE /*152N*/
	| /*empty*/
	;

lock_type :
	ACCESS /*18N*/ SHARE /*234N*/
	| ROW /*322N*/ SHARE /*234N*/
	| ROW /*322N*/ EXCLUSIVE /*88N*/
	| SHARE /*234N*/ UPDATE /*268N*/ EXCLUSIVE /*88N*/
	| SHARE /*234N*/
	| SHARE /*234N*/ ROW /*322N*/ EXCLUSIVE /*88N*/
	| EXCLUSIVE /*88N*/
	| ACCESS /*18N*/ EXCLUSIVE /*88N*/
	;

opt_nowait :
	NOWAIT /*172N*/
	| /*empty*/
	;

UpdateStmt :
	UPDATE /*268N*/ relation_expr_opt_alias SET /*1N*/ set_clause_list from_clause where_or_current_clause returning_clause
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
	set_target '=' /*7R*/ ctext_expr
	;

multiple_set_clause :
	'(' /*349L*/ set_target_list ')' /*349L*/ '=' /*7R*/ ctext_row
	;

set_target :
	ColId opt_indirection
	;

set_target_list :
	set_target
	| set_target_list ',' set_target
	;

DeclareCursorStmt :
	DECLARE /*67N*/ name cursor_options CURSOR /*61N*/ opt_hold FOR SelectStmt
	;

cursor_options :
	/*empty*/
	| cursor_options NO /*161N*/ SCROLL /*225N*/
	| cursor_options SCROLL /*225N*/
	| cursor_options BINARY /*334N*/
	| cursor_options INSENSITIVE /*122N*/
	;

opt_hold :
	/*empty*/
	| WITH /*279N*/ HOLD /*107N*/
	| WITHOUT /*281N*/ HOLD /*107N*/
	;

SelectStmt :
	select_no_parens %prec UMINUS /*347R*/
	| select_with_parens %prec UMINUS /*347R*/
	;

select_with_parens :
	'(' /*349L*/ select_no_parens ')' /*349L*/
	| '(' /*349L*/ select_with_parens ')' /*349L*/
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

simple_select :
	SELECT opt_distinct target_list into_clause from_clause where_clause group_clause having_clause window_clause
	| values_clause
	| select_clause UNION /*2L*/ opt_all select_clause
	| select_clause INTERSECT /*3L*/ opt_all select_clause
	| select_clause EXCEPT /*2L*/ opt_all select_clause
	;

with_clause :
	WITH /*279N*/ cte_list
	| WITH /*279N*/ RECURSIVE /*206N*/ cte_list
	;

cte_list :
	common_table_expr
	| cte_list ',' common_table_expr
	;

common_table_expr :
	name opt_name_list AS select_with_parens
	;

into_clause :
	INTO OptTempTableName
	| /*empty*/
	;

OptTempTableName :
	TEMPORARY /*256N*/ opt_table qualified_name
	| TEMP /*254N*/ opt_table qualified_name
	| LOCAL /*138N*/ TEMPORARY /*256N*/ opt_table qualified_name
	| LOCAL /*138N*/ TEMP /*254N*/ opt_table qualified_name
	| GLOBAL /*102N*/ TEMPORARY /*256N*/ opt_table qualified_name
	| GLOBAL /*102N*/ TEMP /*254N*/ opt_table qualified_name
	| TABLE qualified_name
	| qualified_name
	;

opt_table :
	TABLE
	| /*empty*/
	;

opt_all :
	ALL
	| DISTINCT
	| /*empty*/
	;

opt_distinct :
	DISTINCT
	| DISTINCT ON '(' /*349L*/ expr_list ')' /*349L*/
	| ALL
	| /*empty*/
	;

opt_sort_clause :
	sort_clause
	| /*empty*/
	;

sort_clause :
	ORDER BY /*32N*/ sortby_list
	;

sortby_list :
	sortby
	| sortby_list ',' sortby
	;

sortby :
	a_expr USING qual_all_Op
	| a_expr ASC
	| a_expr DESC
	| a_expr
	;

select_limit :
	LIMIT select_limit_value OFFSET select_offset_value
	| OFFSET select_offset_value LIMIT select_limit_value
	| LIMIT select_limit_value
	| OFFSET select_offset_value
	| LIMIT select_limit_value ',' select_offset_value
	| OFFSET select_offset_value2 row_or_rows
	| FETCH /*92N*/ first_or_next opt_select_fetch_first_value row_or_rows ONLY
	| OFFSET select_offset_value2 row_or_rows FETCH /*92N*/ first_or_next opt_select_fetch_first_value row_or_rows ONLY
	;

opt_select_limit :
	select_limit
	| /*empty*/
	;

select_limit_value :
	a_expr
	| ALL
	;

opt_select_fetch_first_value :
	SignedIconst
	| '(' /*349L*/ a_expr ')' /*349L*/
	| /*empty*/
	;

select_offset_value :
	a_expr
	;

select_offset_value2 :
	c_expr
	;

row_or_rows :
	ROW /*322N*/
	| ROWS /*15N*/
	;

first_or_next :
	FIRST_P /*95N*/
	| NEXT /*160N*/
	;

group_clause :
	GROUP_P BY /*32N*/ group_elem_list
	| /*empty*/
	;

group_elem_list :
	group_elem
	| group_elem_list ',' group_elem
	;

group_elem :
	a_expr
	| ROLLUP /*321N*/ '(' /*349L*/ expr_list ')' /*349L*/
	| CUBE /*294N*/ '(' /*349L*/ expr_list ')' /*349L*/
	| GROUPING /*302N*/ SETS /*324N*/ '(' /*349L*/ group_elem_list ')' /*349L*/
	| '(' /*349L*/ ')' /*349L*/
	;

having_clause :
	HAVING a_expr
	| /*empty*/
	;

window_clause :
	WINDOW window_definition_list
	| /*empty*/
	;

window_definition_list :
	window_name AS '(' /*349L*/ window_spec ')' /*349L*/
	| window_definition_list ',' window_name AS '(' /*349L*/ window_spec ')' /*349L*/
	;

window_spec :
	opt_window_name opt_window_partition_clause opt_window_order_clause opt_window_frame_clause
	;

opt_window_name :
	window_name
	| /*empty*/
	;

opt_window_partition_clause :
	window_partition_clause
	| /*empty*/
	;

window_partition_clause :
	PARTITION /*15N*/ BY /*32N*/ sortby_list
	;

opt_window_order_clause :
	sort_clause
	| /*empty*/
	;

opt_window_frame_clause :
	window_frame_clause
	| /*empty*/
	;

window_frame_clause :
	window_frame_units window_frame_extent window_frame_exclusion
	;

window_frame_units :
	ROWS /*15N*/
	| RANGE /*15N*/
	;

window_frame_extent :
	window_frame_start
	| window_frame_between
	;

window_frame_start :
	UNBOUNDED PRECEDING
	| window_frame_preceding
	| CURRENT /*60N*/ ROW /*322N*/
	;

window_frame_preceding :
	a_expr PRECEDING
	;

window_frame_between :
	BETWEEN /*12N*/ window_frame_bound AND /*5L*/ window_frame_bound
	;

window_frame_bound :
	window_frame_start
	| UNBOUNDED FOLLOWING
	| window_frame_following
	;

window_frame_following :
	a_expr FOLLOWING
	;

window_frame_exclusion :
	EXCLUDE CURRENT /*60N*/ ROW /*322N*/
	| EXCLUDE GROUP_P
	| EXCLUDE TIES /*258N*/
	| EXCLUDE NO /*161N*/ OTHERS /*179N*/
	| /*empty*/
	;

for_locking_clause :
	for_locking_items
	| FOR READ /*201N*/ ONLY
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
	FOR UPDATE /*268N*/ locked_rels_list opt_nowait
	| FOR SHARE /*234N*/ locked_rels_list opt_nowait
	;

locked_rels_list :
	OF /*175N*/ name_list
	| /*empty*/
	;

values_clause :
	VALUES /*331N*/ ctext_row
	| values_clause ',' ctext_row
	;

from_clause :
	FROM from_list
	| /*empty*/
	;

from_list :
	table_ref
	| from_list ',' table_ref
	;

table_ref :
	relation_expr
	| relation_expr alias_clause
	| func_table
	| func_table alias_clause
	| func_table AS '(' /*349L*/ TableFuncElementList ')' /*349L*/
	| func_table AS ColId '(' /*349L*/ TableFuncElementList ')' /*349L*/
	| func_table ColId '(' /*349L*/ TableFuncElementList ')' /*349L*/
	| select_with_parens
	| select_with_parens alias_clause
	| joined_table
	| '(' /*349L*/ joined_table ')' /*349L*/ alias_clause
	;

joined_table :
	'(' /*349L*/ joined_table ')' /*349L*/
	| table_ref CROSS /*352L*/ JOIN /*352L*/ table_ref
	| table_ref join_type JOIN /*352L*/ table_ref join_qual
	| table_ref JOIN /*352L*/ table_ref join_qual
	| table_ref NATURAL /*352L*/ join_type JOIN /*352L*/ table_ref
	| table_ref NATURAL /*352L*/ JOIN /*352L*/ table_ref
	;

alias_clause :
	AS ColId '(' /*349L*/ name_list ')' /*349L*/
	| AS ColId
	| ColId '(' /*349L*/ name_list ')' /*349L*/
	| ColId
	;

join_type :
	FULL /*352L*/ join_outer
	| LEFT /*352L*/ join_outer
	| RIGHT /*352L*/ join_outer
	| INNER_P /*352L*/
	;

join_outer :
	OUTER_P /*337N*/
	| /*empty*/
	;

join_qual :
	USING '(' /*349L*/ name_list ')' /*349L*/
	| ON a_expr
	;

relation_expr :
	qualified_name
	| qualified_name '*' /*344L*/
	| ONLY qualified_name
	| ONLY '(' /*349L*/ qualified_name ')' /*349L*/
	;

relation_expr_opt_alias :
	relation_expr %prec UMINUS /*347R*/
	| relation_expr ColId
	| relation_expr AS ColId
	;

func_table :
	func_expr
	;

where_clause :
	WHERE a_expr
	| /*empty*/
	;

where_or_current_clause :
	where_clause
	| WHERE CURRENT /*60N*/ OF /*175N*/ name
	;

TableFuncElementList :
	TableFuncElement
	| TableFuncElementList ',' TableFuncElement
	;

TableFuncElement :
	ColId Typename
	;

Typename :
	SimpleTypename opt_array_bounds
	| SETOF /*323N*/ SimpleTypename opt_array_bounds
	| SimpleTypename ARRAY '[' /*348L*/ Iconst ']' /*348L*/
	| SETOF /*323N*/ SimpleTypename ARRAY '[' /*348L*/ Iconst ']' /*348L*/
	;

opt_array_bounds :
	opt_array_bounds '[' /*348L*/ ']' /*348L*/
	| opt_array_bounds '[' /*348L*/ Iconst ']' /*348L*/
	| /*empty*/
	;

SimpleTypename :
	GenericType
	| Numeric
	| Bit
	| Character
	| ConstDatetime
	| ConstInterval opt_interval
	| ConstInterval '(' /*349L*/ Iconst ')' /*349L*/ opt_interval
	| type_name attrs
	;

ConstTypename :
	GenericType
	| Numeric
	| ConstBit
	| ConstCharacter
	| ConstDatetime
	;

GenericType :
	type_name
	;

Numeric :
	INT_P /*304N*/
	| INTEGER /*305N*/
	| SMALLINT /*325N*/
	| BIGINT /*287N*/
	| REAL /*320N*/
	| FLOAT_P /*299N*/ opt_float
	| DOUBLE_P /*76N*/ PRECISION /*319N*/
	| DECIMAL_P /*296N*/ opt_decimal
	| DEC /*295N*/ opt_decimal
	| NUMERIC /*313N*/ opt_numeric
	| BOOLEAN_P /*289N*/
	;

opt_float :
	'(' /*349L*/ Iconst ')' /*349L*/
	| /*empty*/
	;

opt_numeric :
	'(' /*349L*/ Iconst ',' Iconst ')' /*349L*/
	| '(' /*349L*/ Iconst ')' /*349L*/
	| /*empty*/
	;

opt_decimal :
	'(' /*349L*/ Iconst ',' Iconst ')' /*349L*/
	| '(' /*349L*/ Iconst ')' /*349L*/
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
	BIT /*288N*/ opt_varying '(' /*349L*/ Iconst ')' /*349L*/
	;

BitWithoutLength :
	BIT /*288N*/ opt_varying
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
	character '(' /*349L*/ Iconst ')' /*349L*/ opt_charset
	;

CharacterWithoutLength :
	character opt_charset
	;

character :
	CHARACTER /*291N*/ opt_varying
	| CHAR_P /*290N*/ opt_varying
	| VARCHAR /*332N*/
	| NATIONAL /*309N*/ CHARACTER /*291N*/ opt_varying
	| NATIONAL /*309N*/ CHAR_P /*290N*/ opt_varying
	| NCHAR /*310N*/ opt_varying
	;

opt_varying :
	VARYING /*274N*/
	| /*empty*/
	;

opt_charset :
	CHARACTER /*291N*/ SET /*1N*/ ColId
	| /*empty*/
	;

ConstDatetime :
	TIMESTAMP /*328N*/ '(' /*349L*/ Iconst ')' /*349L*/ opt_timezone
	| TIMESTAMP /*328N*/ opt_timezone
	| TIME /*327N*/ '(' /*349L*/ Iconst ')' /*349L*/ opt_timezone
	| TIME /*327N*/ opt_timezone
	;

ConstInterval :
	INTERVAL /*306N*/
	;

opt_timezone :
	WITH_TIME ZONE /*346L*/
	| WITHOUT /*281N*/ TIME /*327N*/ ZONE /*346L*/
	| /*empty*/
	;

opt_interval :
	YEAR_P /*286N*/
	| MONTH_P /*155N*/
	| DAY_P /*65N*/
	| HOUR_P /*109N*/
	| MINUTE_P /*148N*/
	| SECOND_P /*227N*/
	| YEAR_P /*286N*/ TO MONTH_P /*155N*/
	| DAY_P /*65N*/ TO HOUR_P /*109N*/
	| DAY_P /*65N*/ TO MINUTE_P /*148N*/
	| DAY_P /*65N*/ TO SECOND_P /*227N*/
	| HOUR_P /*109N*/ TO MINUTE_P /*148N*/
	| HOUR_P /*109N*/ TO SECOND_P /*227N*/
	| MINUTE_P /*148N*/ TO SECOND_P /*227N*/
	| /*empty*/
	;

a_expr :
	c_expr
	| a_expr TYPECAST /*350L*/ Typename
	| a_expr AT /*346L*/ TIME /*327N*/ ZONE /*346L*/ a_expr
	| '+' /*343L*/ a_expr %prec UMINUS /*347R*/
	| '-' /*343L*/ a_expr %prec UMINUS /*347R*/
	| a_expr '+' /*343L*/ a_expr
	| a_expr '-' /*343L*/ a_expr
	| a_expr '*' /*344L*/ a_expr
	| a_expr '/' /*344L*/ a_expr
	| a_expr '%' /*344L*/ a_expr
	| a_expr '^' /*345L*/ a_expr
	| a_expr '<' /*8N*/ a_expr
	| a_expr '>' /*8N*/ a_expr
	| a_expr '=' /*7R*/ a_expr
	| a_expr qual_Op a_expr %prec Op /*339L*/
	| qual_Op a_expr %prec Op /*339L*/
	| a_expr qual_Op %prec POSTFIXOP /*14L*/
	| a_expr AND /*5L*/ a_expr
	| a_expr OR /*4L*/ a_expr
	| NOT /*6R*/ a_expr
	| a_expr LIKE /*9N*/ a_expr
	| a_expr LIKE /*9N*/ a_expr ESCAPE /*10N*/ a_expr
	| a_expr NOT /*6R*/ LIKE /*9N*/ a_expr
	| a_expr NOT /*6R*/ LIKE /*9N*/ a_expr ESCAPE /*10N*/ a_expr
	| a_expr ILIKE /*9N*/ a_expr
	| a_expr ILIKE /*9N*/ a_expr ESCAPE /*10N*/ a_expr
	| a_expr NOT /*6R*/ ILIKE /*9N*/ a_expr
	| a_expr NOT /*6R*/ ILIKE /*9N*/ a_expr ESCAPE /*10N*/ a_expr
	| a_expr SIMILAR /*9N*/ TO a_expr %prec SIMILAR /*9N*/
	| a_expr SIMILAR /*9N*/ TO a_expr ESCAPE /*10N*/ a_expr
	| a_expr NOT /*6R*/ SIMILAR /*9N*/ TO a_expr %prec SIMILAR /*9N*/
	| a_expr NOT /*6R*/ SIMILAR /*9N*/ TO a_expr ESCAPE /*10N*/ a_expr
	| a_expr IS /*342N*/ NULL_P /*342N*/
	| a_expr ISNULL /*341N*/
	| a_expr IS /*342N*/ NOT /*6R*/ NULL_P /*342N*/
	| a_expr NOTNULL /*340N*/
	| row OVERLAPS /*11N*/ row
	| a_expr IS /*342N*/ TRUE_P /*342N*/
	| a_expr IS /*342N*/ NOT /*6R*/ TRUE_P /*342N*/
	| a_expr IS /*342N*/ FALSE_P /*342N*/
	| a_expr IS /*342N*/ NOT /*6R*/ FALSE_P /*342N*/
	| a_expr IS /*342N*/ UNKNOWN /*342N*/
	| a_expr IS /*342N*/ NOT /*6R*/ UNKNOWN /*342N*/
	| a_expr IS /*342N*/ DISTINCT FROM a_expr %prec IS /*342N*/
	| a_expr IS /*342N*/ NOT /*6R*/ DISTINCT FROM a_expr %prec IS /*342N*/
	| a_expr IS /*342N*/ OF /*175N*/ '(' /*349L*/ type_list ')' /*349L*/ %prec IS /*342N*/
	| a_expr IS /*342N*/ NOT /*6R*/ OF /*175N*/ '(' /*349L*/ type_list ')' /*349L*/ %prec IS /*342N*/
	| a_expr BETWEEN /*12N*/ opt_asymmetric b_expr AND /*5L*/ b_expr %prec BETWEEN /*12N*/
	| a_expr NOT /*6R*/ BETWEEN /*12N*/ opt_asymmetric b_expr AND /*5L*/ b_expr %prec BETWEEN /*12N*/
	| a_expr BETWEEN /*12N*/ SYMMETRIC b_expr AND /*5L*/ b_expr %prec BETWEEN /*12N*/
	| a_expr NOT /*6R*/ BETWEEN /*12N*/ SYMMETRIC b_expr AND /*5L*/ b_expr %prec BETWEEN /*12N*/
	| a_expr IN_P /*13N*/ in_expr
	| a_expr NOT /*6R*/ IN_P /*13N*/ in_expr
	| a_expr subquery_Op sub_type select_with_parens %prec Op /*339L*/
	| a_expr subquery_Op sub_type '(' /*349L*/ a_expr ')' /*349L*/ %prec Op /*339L*/
	| UNIQUE select_with_parens
	;

b_expr :
	c_expr
	| b_expr TYPECAST /*350L*/ Typename
	| '+' /*343L*/ b_expr %prec UMINUS /*347R*/
	| '-' /*343L*/ b_expr %prec UMINUS /*347R*/
	| b_expr '+' /*343L*/ b_expr
	| b_expr '-' /*343L*/ b_expr
	| b_expr '*' /*344L*/ b_expr
	| b_expr '/' /*344L*/ b_expr
	| b_expr '%' /*344L*/ b_expr
	| b_expr '^' /*345L*/ b_expr
	| b_expr '<' /*8N*/ b_expr
	| b_expr '>' /*8N*/ b_expr
	| b_expr '=' /*7R*/ b_expr
	| b_expr qual_Op b_expr %prec Op /*339L*/
	| qual_Op b_expr %prec Op /*339L*/
	| b_expr qual_Op %prec POSTFIXOP /*14L*/
	| b_expr IS /*342N*/ DISTINCT FROM b_expr %prec IS /*342N*/
	| b_expr IS /*342N*/ NOT /*6R*/ DISTINCT FROM b_expr %prec IS /*342N*/
	| b_expr IS /*342N*/ OF /*175N*/ '(' /*349L*/ type_list ')' /*349L*/ %prec IS /*342N*/
	| b_expr IS /*342N*/ NOT /*6R*/ OF /*175N*/ '(' /*349L*/ type_list ')' /*349L*/ %prec IS /*342N*/
	;

c_expr :
	columnref
	| func_expr OVER /*180N*/ '(' /*349L*/ window_spec ')' /*349L*/
	| AexprConst
	| PARAM opt_indirection
	| '(' /*349L*/ a_expr ')' /*349L*/ opt_indirection
	| case_expr
	| decode_expr
	| func_expr
	| select_with_parens %prec UMINUS /*347R*/
	| EXISTS /*297N*/ select_with_parens
	| ARRAY select_with_parens
	| ARRAY array_expr
	| TABLE '(' /*349L*/ table_value_select_clause ')' /*349L*/
	| row
	;

scatter_clause :
	/*empty*/
	| SCATTER RANDOMLY /*200N*/
	| SCATTER BY /*32N*/ expr_list
	;

table_value_select_clause :
	SelectStmt scatter_clause
	;

window_name :
	ColId
	;

simple_func :
	func_name '(' /*349L*/ ')' /*349L*/
	| func_name '(' /*349L*/ expr_list opt_sort_clause ')' /*349L*/
	| func_name '(' /*349L*/ ALL expr_list opt_sort_clause ')' /*349L*/
	| func_name '(' /*349L*/ DISTINCT expr_list opt_sort_clause ')' /*349L*/
	| func_name '(' /*349L*/ '*' /*344L*/ ')' /*349L*/
	| func_name '(' /*349L*/ VARIADIC a_expr ')' /*349L*/
	| func_name '(' /*349L*/ expr_list ',' VARIADIC a_expr ')' /*349L*/
	;

func_expr :
	simple_func FILTER '(' /*349L*/ WHERE a_expr ')' /*349L*/
	| simple_func
	| CURRENT_DATE
	| CURRENT_TIME
	| CURRENT_TIME '(' /*349L*/ Iconst ')' /*349L*/
	| CURRENT_TIMESTAMP
	| CURRENT_TIMESTAMP '(' /*349L*/ Iconst ')' /*349L*/
	| LOCALTIME
	| LOCALTIME '(' /*349L*/ Iconst ')' /*349L*/
	| LOCALTIMESTAMP
	| LOCALTIMESTAMP '(' /*349L*/ Iconst ')' /*349L*/
	| CURRENT_ROLE
	| CURRENT_USER
	| SESSION_USER
	| USER
	| CURRENT_CATALOG
	| CURRENT_SCHEMA
	| CAST '(' /*349L*/ a_expr AS Typename ')' /*349L*/
	| EXTRACT /*298N*/ '(' /*349L*/ extract_list ')' /*349L*/
	| OVERLAY /*315N*/ '(' /*349L*/ overlay_list ')' /*349L*/
	| POSITION /*318N*/ '(' /*349L*/ position_list ')' /*349L*/
	| SUBSTRING /*326N*/ '(' /*349L*/ substr_list ')' /*349L*/
	| TREAT /*329N*/ '(' /*349L*/ a_expr AS Typename ')' /*349L*/
	| TRIM /*330N*/ '(' /*349L*/ BOTH trim_list ')' /*349L*/
	| TRIM /*330N*/ '(' /*349L*/ LEADING trim_list ')' /*349L*/
	| TRIM /*330N*/ '(' /*349L*/ TRAILING trim_list ')' /*349L*/
	| TRIM /*330N*/ '(' /*349L*/ trim_list ')' /*349L*/
	| CONVERT /*293N*/ '(' /*349L*/ a_expr USING any_name ')' /*349L*/
	| CONVERT /*293N*/ '(' /*349L*/ expr_list ')' /*349L*/
	| NULLIF /*312N*/ '(' /*349L*/ a_expr ',' a_expr ')' /*349L*/
	| COALESCE /*292N*/ '(' /*349L*/ expr_list ')' /*349L*/
	| GREATEST /*300N*/ '(' /*349L*/ expr_list ')' /*349L*/
	| LEAST /*307N*/ '(' /*349L*/ expr_list ')' /*349L*/
	| GROUPING /*302N*/ '(' /*349L*/ expr_list ')' /*349L*/
	| GROUP_ID /*301N*/ '(' /*349L*/ ')' /*349L*/
	| MEDIAN /*308N*/ '(' /*349L*/ a_expr ')' /*349L*/
	| PERCENTILE_CONT /*316N*/ '(' /*349L*/ a_expr ')' /*349L*/ WITHIN /*280N*/ GROUP_P '(' /*349L*/ ORDER BY /*32N*/ sortby_list ')' /*349L*/
	| PERCENTILE_DISC /*317N*/ '(' /*349L*/ a_expr ')' /*349L*/ WITHIN /*280N*/ GROUP_P '(' /*349L*/ ORDER BY /*32N*/ sortby_list ')' /*349L*/
	;

row :
	ROW /*322N*/ '(' /*349L*/ expr_list ')' /*349L*/
	| ROW /*322N*/ '(' /*349L*/ ')' /*349L*/
	| '(' /*349L*/ expr_list ',' a_expr ')' /*349L*/
	;

sub_type :
	ANY
	| SOME
	| ALL
	;

all_Op :
	Op /*339L*/
	| MathOp
	;

MathOp :
	'+' /*343L*/
	| '-' /*343L*/
	| '*' /*344L*/
	| '/' /*344L*/
	| '%' /*344L*/
	| '^' /*345L*/
	| '<' /*8N*/
	| '>' /*8N*/
	| '=' /*7R*/
	;

qual_Op :
	Op /*339L*/
	| OPERATOR /*339L*/ '(' /*349L*/ any_operator ')' /*349L*/
	;

qual_all_Op :
	all_Op
	| OPERATOR /*339L*/ '(' /*349L*/ any_operator ')' /*349L*/
	;

subquery_Op :
	all_Op
	| OPERATOR /*339L*/ '(' /*349L*/ any_operator ')' /*349L*/
	| LIKE /*9N*/
	| NOT /*6R*/ LIKE /*9N*/
	| ILIKE /*9N*/
	| NOT /*6R*/ ILIKE /*9N*/
	;

expr_list :
	a_expr
	| expr_list ',' a_expr
	;

extract_list :
	extract_arg FROM a_expr
	| /*empty*/
	;

type_list :
	type_list ',' Typename
	| Typename
	;

array_expr_list :
	array_expr
	| array_expr_list ',' array_expr
	;

array_expr :
	'[' /*348L*/ expr_list ']' /*348L*/
	| '[' /*348L*/ array_expr_list ']' /*348L*/
	;

extract_arg :
	IDENT /*15N*/
	| YEAR_P /*286N*/
	| MONTH_P /*155N*/
	| DAY_P /*65N*/
	| HOUR_P /*109N*/
	| MINUTE_P /*148N*/
	| SECOND_P /*227N*/
	| SCONST
	;

overlay_list :
	a_expr overlay_placing substr_from substr_for
	| a_expr overlay_placing substr_from
	;

overlay_placing :
	PLACING a_expr
	;

position_list :
	b_expr IN_P /*13N*/ b_expr
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
	a_expr FROM expr_list
	| FROM expr_list
	| expr_list
	;

in_expr :
	select_with_parens
	| '(' /*349L*/ expr_list ')' /*349L*/
	;

case_expr :
	CASE case_arg when_clause_list case_default END_P /*82N*/
	;

when_clause_list :
	when_clause
	| when_clause_list when_clause
	;

when_clause :
	WHEN when_operand THEN a_expr
	;

when_operand :
	a_expr
	| IS /*342N*/ NOT /*6R*/ DISTINCT FROM a_expr
	;

case_default :
	ELSE a_expr
	| /*empty*/
	;

case_arg :
	a_expr
	| /*empty*/
	;

decode_expr :
	DECODE '(' /*349L*/ a_expr search_result_list decode_default ')' /*349L*/
	;

search_result_list :
	search_result
	| search_result_list search_result
	;

search_result :
	',' a_expr ',' a_expr
	;

decode_default :
	',' a_expr
	| /*empty*/
	;

columnref :
	relation_name
	| relation_name indirection
	;

indirection_el :
	'.' /*351L*/ attr_name
	| '.' /*351L*/ '*' /*344L*/
	| '[' /*348L*/ a_expr ']' /*348L*/
	| '[' /*348L*/ a_expr ':' a_expr ']' /*348L*/
	;

indirection :
	indirection_el
	| indirection indirection_el
	;

opt_indirection :
	/*empty*/
	| opt_indirection indirection_el
	;

opt_asymmetric :
	ASYMMETRIC
	| /*empty*/
	;

ctext_expr :
	a_expr
	| DEFAULT
	;

ctext_expr_list :
	ctext_expr
	| ctext_expr_list ',' ctext_expr
	;

ctext_row :
	'(' /*349L*/ ctext_expr_list ')' /*349L*/
	;

target_list :
	target_el
	| target_list ',' target_el
	;

target_el :
	a_expr AS ColLabel
	| a_expr IDENT /*15N*/
	| a_expr ColLabelNoAs
	| a_expr
	| '*' /*344L*/
	;

relation_name :
	SpecialRuleRelation
	| ColId
	;

qualified_name_list :
	qualified_name
	| qualified_name_list ',' qualified_name
	;

qualified_name :
	relation_name
	| relation_name indirection
	;

name_list :
	name
	| name_list ',' name
	;

name :
	ColId
	;

database_name :
	ColId
	;

access_method :
	ColId
	;

attr_name :
	ColLabel
	;

index_name :
	ColId
	;

file_name :
	Sconst
	;

func_name :
	function_name
	| relation_name indirection
	;

AexprConst :
	Iconst
	| FCONST
	| Sconst
	| BCONST
	| XCONST
	| ConstTypename Sconst
	| ConstInterval Sconst opt_interval
	| ConstInterval '(' /*349L*/ Iconst ')' /*349L*/ Sconst opt_interval
	| TRUE_P /*342N*/
	| FALSE_P /*342N*/
	| NULL_P /*342N*/
	;

Iconst :
	ICONST
	;

Sconst :
	SCONST
	;

RoleId :
	ColId
	;

QueueId :
	ColId
	;

SignedIconst :
	ICONST
	| '+' /*343L*/ ICONST
	| '-' /*343L*/ ICONST
	;

ColId :
	IDENT /*15N*/
	| unreserved_keyword
	| col_name_keyword
	;

type_name :
	IDENT /*15N*/
	| unreserved_keyword
	;

function_name :
	IDENT /*15N*/
	| unreserved_keyword
	| func_name_keyword
	;

ColLabel :
	IDENT /*15N*/
	| unreserved_keyword
	| col_name_keyword
	| func_name_keyword
	| reserved_keyword
	;

unreserved_keyword :
	ABORT_P /*16N*/
	| ABSOLUTE_P /*17N*/
	| ACCESS /*18N*/
	| ACTION /*19N*/
	| ACTIVE /*20N*/
	| ADD_P /*21N*/
	| ADMIN /*22N*/
	| AFTER /*23N*/
	| AGGREGATE /*24N*/
	| ALSO /*25N*/
	| ALTER /*26N*/
	| ASSERTION /*27N*/
	| ASSIGNMENT /*28N*/
	| AT /*346L*/
	| BACKWARD /*29N*/
	| BEFORE /*30N*/
	| BEGIN_P /*31N*/
	| BY /*32N*/
	| CACHE /*33N*/
	| CALLED /*34N*/
	| CASCADE /*35N*/
	| CASCADED /*36N*/
	| CHAIN /*37N*/
	| CHARACTERISTICS /*38N*/
	| CHECKPOINT /*39N*/
	| CLASS /*40N*/
	| CLOSE /*41N*/
	| CLUSTER /*42N*/
	| COMMENT /*43N*/
	| COMMIT /*44N*/
	| COMMITTED /*45N*/
	| CONCURRENTLY /*46N*/
	| CONNECTION /*47N*/
	| CONSTRAINTS /*48N*/
	| CONTAINS /*49N*/
	| CONTENT_P /*50N*/
	| CONTINUE_P /*51N*/
	| CONVERSION_P /*52N*/
	| COPY /*53N*/
	| COST /*54N*/
	| CREATEDB /*55N*/
	| CREATEEXTTABLE /*56N*/
	| CREATEROLE /*57N*/
	| CREATEUSER /*58N*/
	| CSV /*59N*/
	| CURRENT /*60N*/
	| CURSOR /*61N*/
	| CYCLE /*62N*/
	| DATA_P /*63N*/
	| DATABASE /*64N*/
	| DAY_P /*65N*/
	| DEALLOCATE /*66N*/
	| DECLARE /*67N*/
	| DEFAULTS /*68N*/
	| DEFERRED /*69N*/
	| DEFINER /*70N*/
	| DELETE_P /*71N*/
	| DELIMITER /*72N*/
	| DELIMITERS /*73N*/
	| DENY
	| DISABLE_P /*74N*/
	| DOMAIN_P /*75N*/
	| DOUBLE_P /*76N*/
	| DROP /*77N*/
	| DXL
	| EACH /*78N*/
	| ENABLE_P /*79N*/
	| ENCODING /*80N*/
	| ENCRYPTED /*81N*/
	| ENUM_P /*83N*/
	| ERRORS /*84N*/
	| ESCAPE /*10N*/
	| EVERY /*85N*/
	| EXCHANGE /*86N*/
	| EXCLUDING /*87N*/
	| EXCLUSIVE /*88N*/
	| EXECUTE /*89N*/
	| EXPLAIN /*90N*/
	| EXTERNAL /*91N*/
	| FIELDS /*93N*/
	| FILESPACE
	| FILESYSTEM /*196N*/
	| FILL /*94N*/
	| FIRST_P /*95N*/
	| FORCE /*96N*/
	| FORMAT /*97N*/
	| FORMATTER /*98N*/
	| FORWARD /*99N*/
	| FUNCTION /*100N*/
	| FUNCTIONS
	| GB /*101N*/
	| GLOBAL /*102N*/
	| GRANTED /*103N*/
	| HANDLER /*104N*/
	| HASH /*105N*/
	| HEADER_P /*106N*/
	| HOLD /*107N*/
	| HOST /*108N*/
	| HOUR_P /*109N*/
	| IDENTITY_P
	| IF_P /*110N*/
	| IGNORE_P
	| IMMEDIATE /*111N*/
	| IMMUTABLE /*112N*/
	| IMPLICIT_P /*113N*/
	| INCLUDE
	| INCLUDING /*114N*/
	| INCLUSIVE /*115N*/
	| INCREMENT /*116N*/
	| INDEX /*117N*/
	| INDEXES /*118N*/
	| INHERIT /*119N*/
	| INHERITS /*120N*/
	| INPUT_P /*121N*/
	| INSENSITIVE /*122N*/
	| INSERT /*123N*/
	| INSTEAD /*124N*/
	| INVOKER /*125N*/
	| ISOLATION /*126N*/
	| KB /*127N*/
	| KEEP /*128N*/
	| KEY /*129N*/
	| LANCOMPILER /*130N*/
	| LANGUAGE /*131N*/
	| LARGE_P /*132N*/
	| LAST_P /*133N*/
	| LEVEL /*134N*/
	| LIST /*135N*/
	| LISTEN /*136N*/
	| LOAD /*137N*/
	| LOCAL /*138N*/
	| LOCATION /*139N*/
	| LOCK_P /*140N*/
	| LOGIN_P /*141N*/
	| MAPPING /*143N*/
	| MASTER /*142N*/
	| MATCH /*144N*/
	| MAXVALUE /*145N*/
	| MB /*146N*/
	| MERGE /*147N*/
	| MINUTE_P /*148N*/
	| MINVALUE /*149N*/
	| MIRROR /*150N*/
	| MISSING /*151N*/
	| MODE /*152N*/
	| MODIFIES /*153N*/
	| MODIFY /*154N*/
	| MONTH_P /*155N*/
	| MOVE /*156N*/
	| NAME_P /*157N*/
	| NAMES /*158N*/
	| NEWLINE /*159N*/
	| NEXT /*160N*/
	| NO /*161N*/
	| NOCREATEDB /*162N*/
	| NOCREATEEXTTABLE /*163N*/
	| NOCREATEROLE /*164N*/
	| NOCREATEUSER /*165N*/
	| NOINHERIT /*166N*/
	| NOLOGIN_P /*167N*/
	| NOOVERCOMMIT /*168N*/
	| NOSUPERUSER /*169N*/
	| NOTHING /*170N*/
	| NOTIFY /*171N*/
	| NOWAIT /*172N*/
	| NULLS_P /*173N*/
	| OBJECT_P /*174N*/
	| OF /*175N*/
	| OIDS /*176N*/
	| OPERATOR /*339L*/
	| OPTION /*177N*/
	| OPTIONS /*178N*/
	| ORDERED
	| OTHERS /*179N*/
	| OVER /*180N*/
	| OVERCOMMIT /*181N*/
	| OWNED /*182N*/
	| OWNER /*183N*/
	| PARTIAL /*184N*/
	| PARTITIONS /*185N*/
	| PASSWORD /*186N*/
	| PB /*187N*/
	| PERCENT /*188N*/
	| PREPARE /*189N*/
	| PREPARED /*190N*/
	| PRESERVE /*191N*/
	| PRIOR /*192N*/
	| PRIVILEGES /*193N*/
	| PROCEDURAL /*194N*/
	| PROCEDURE /*195N*/
	| PROTOCOL /*197N*/
	| QUEUE /*198N*/
	| QUOTE /*199N*/
	| RANDOMLY /*200N*/
	| READ /*201N*/
	| READABLE /*202N*/
	| READS /*203N*/
	| REASSIGN /*204N*/
	| RECHECK /*205N*/
	| RECURSIVE /*206N*/
	| REINDEX /*207N*/
	| REJECT_P /*208N*/
	| RELATIVE_P /*209N*/
	| RELEASE /*210N*/
	| RENAME /*211N*/
	| REPEATABLE /*212N*/
	| REPLACE /*213N*/
	| RESET /*214N*/
	| RESOURCE /*215N*/
	| RESTART /*216N*/
	| RESTRICT /*217N*/
	| RETURNS /*218N*/
	| REVOKE /*219N*/
	| ROLE /*220N*/
	| ROLLBACK /*221N*/
	| ROOTPARTITION
	| RULE /*222N*/
	| SAVEPOINT /*223N*/
	| SEARCH /*226N*/
	| SERVER /*232N*/
	| SCHEMA /*224N*/
	| SCROLL /*225N*/
	| SECOND_P /*227N*/
	| SECURITY /*228N*/
	| SEGMENT /*229N*/
	| SEQUENCE /*230N*/
	| SEQUENCES
	| SERIALIZABLE /*231N*/
	| SESSION /*233N*/
	| SET /*1N*/
	| SHARE /*234N*/
	| SHOW /*235N*/
	| SIMPLE /*236N*/
	| SPLIT /*237N*/
	| SQL /*238N*/
	| STABLE /*239N*/
	| START /*240N*/
	| STATEMENT /*241N*/
	| STATISTICS /*242N*/
	| STDIN /*243N*/
	| STDOUT /*244N*/
	| STORAGE /*245N*/
	| STRICT_P /*251N*/
	| SUBPARTITION /*246N*/
	| SUBPARTITIONS /*247N*/
	| SUPERUSER_P /*248N*/
	| SYSID /*249N*/
	| SYSTEM_P /*250N*/
	| TABLES
	| TABLESPACE /*252N*/
	| TB /*253N*/
	| TEMP /*254N*/
	| TEMPLATE /*255N*/
	| TEMPORARY /*256N*/
	| THRESHOLD /*257N*/
	| TIES /*258N*/
	| TRANSACTION /*259N*/
	| TRIGGER /*260N*/
	| TRUNCATE /*261N*/
	| TRUSTED /*262N*/
	| TYPE_P /*263N*/
	| UNCOMMITTED /*264N*/
	| UNENCRYPTED /*265N*/
	| UNKNOWN /*342N*/
	| UNLISTEN /*266N*/
	| UNTIL /*267N*/
	| UPDATE /*268N*/
	| VACUUM /*269N*/
	| VALID /*270N*/
	| VALIDATION /*271N*/
	| VALIDATOR /*272N*/
	| VALUE_P /*273N*/
	| VARYING /*274N*/
	| VERSION_P /*275N*/
	| VIEW /*276N*/
	| VOLATILE /*277N*/
	| WEB /*278N*/
	| WITHIN /*280N*/
	| WITHOUT /*281N*/
	| WORK /*282N*/
	| WRAPPER /*283N*/
	| WRITABLE /*284N*/
	| WRITE /*285N*/
	| YEAR_P /*286N*/
	| ZONE /*346L*/
	;

ColLabelNoAs :
	keywords_ok_in_alias_no_as
	;

keywords_ok_in_alias_no_as :
	PartitionIdentKeyword
	| TABLESPACE /*252N*/
	| ADD_P /*21N*/
	| ALTER /*26N*/
	| AT /*346L*/
	;

PartitionColId :
	PartitionIdentKeyword
	| IDENT /*15N*/
	;

PartitionIdentKeyword :
	ABORT_P /*16N*/
	| ABSOLUTE_P /*17N*/
	| ACCESS /*18N*/
	| ACTION /*19N*/
	| ACTIVE /*20N*/
	| ADMIN /*22N*/
	| AFTER /*23N*/
	| AGGREGATE /*24N*/
	| ALSO /*25N*/
	| ASSERTION /*27N*/
	| ASSIGNMENT /*28N*/
	| BACKWARD /*29N*/
	| BEFORE /*30N*/
	| BEGIN_P /*31N*/
	| BY /*32N*/
	| CACHE /*33N*/
	| CALLED /*34N*/
	| CASCADE /*35N*/
	| CASCADED /*36N*/
	| CHAIN /*37N*/
	| CHARACTERISTICS /*38N*/
	| CHECKPOINT /*39N*/
	| CLASS /*40N*/
	| CLOSE /*41N*/
	| CLUSTER /*42N*/
	| COMMENT /*43N*/
	| COMMIT /*44N*/
	| COMMITTED /*45N*/
	| CONCURRENTLY /*46N*/
	| CONNECTION /*47N*/
	| CONSTRAINTS /*48N*/
	| CONTAINS /*49N*/
	| CONVERSION_P /*52N*/
	| COPY /*53N*/
	| COST /*54N*/
	| CREATEDB /*55N*/
	| CREATEEXTTABLE /*56N*/
	| CREATEROLE /*57N*/
	| CREATEUSER /*58N*/
	| CSV /*59N*/
	| CURRENT /*60N*/
	| CURSOR /*61N*/
	| CYCLE /*62N*/
	| DATABASE /*64N*/
	| DEALLOCATE /*66N*/
	| DECLARE /*67N*/
	| DEFAULTS /*68N*/
	| DEFERRED /*69N*/
	| DEFINER /*70N*/
	| DELETE_P /*71N*/
	| DELIMITER /*72N*/
	| DELIMITERS /*73N*/
	| DISABLE_P /*74N*/
	| DOMAIN_P /*75N*/
	| DOUBLE_P /*76N*/
	| DROP /*77N*/
	| EACH /*78N*/
	| ENABLE_P /*79N*/
	| ENCODING /*80N*/
	| ENCRYPTED /*81N*/
	| ERRORS /*84N*/
	| ESCAPE /*10N*/
	| EVERY /*85N*/
	| EXCHANGE /*86N*/
	| EXCLUDING /*87N*/
	| EXCLUSIVE /*88N*/
	| EXECUTE /*89N*/
	| EXPLAIN /*90N*/
	| EXTERNAL /*91N*/
	| FIELDS /*93N*/
	| FILL /*94N*/
	| FIRST_P /*95N*/
	| FORCE /*96N*/
	| FORMAT /*97N*/
	| FORMATTER /*98N*/
	| FORWARD /*99N*/
	| FUNCTION /*100N*/
	| GB /*101N*/
	| GLOBAL /*102N*/
	| GRANTED /*103N*/
	| HANDLER /*104N*/
	| HASH /*105N*/
	| HEADER_P /*106N*/
	| HOLD /*107N*/
	| HOST /*108N*/
	| IF_P /*110N*/
	| IMMEDIATE /*111N*/
	| IMMUTABLE /*112N*/
	| IMPLICIT_P /*113N*/
	| INCLUDING /*114N*/
	| INCLUSIVE /*115N*/
	| INCREMENT /*116N*/
	| INDEX /*117N*/
	| INDEXES /*118N*/
	| INHERIT /*119N*/
	| INHERITS /*120N*/
	| INPUT_P /*121N*/
	| INSENSITIVE /*122N*/
	| INSERT /*123N*/
	| INSTEAD /*124N*/
	| INVOKER /*125N*/
	| ISOLATION /*126N*/
	| KB /*127N*/
	| KEY /*129N*/
	| LANCOMPILER /*130N*/
	| LANGUAGE /*131N*/
	| LARGE_P /*132N*/
	| LAST_P /*133N*/
	| LEVEL /*134N*/
	| LIST /*135N*/
	| LISTEN /*136N*/
	| LOAD /*137N*/
	| LOCAL /*138N*/
	| LOCATION /*139N*/
	| LOCK_P /*140N*/
	| LOGIN_P /*141N*/
	| MASTER /*142N*/
	| MATCH /*144N*/
	| MAXVALUE /*145N*/
	| MB /*146N*/
	| MERGE /*147N*/
	| MINVALUE /*149N*/
	| MIRROR /*150N*/
	| MISSING /*151N*/
	| MODE /*152N*/
	| MODIFIES /*153N*/
	| MODIFY /*154N*/
	| MOVE /*156N*/
	| NAMES /*158N*/
	| NEWLINE /*159N*/
	| NEXT /*160N*/
	| NO /*161N*/
	| NOCREATEDB /*162N*/
	| NOCREATEROLE /*164N*/
	| NOCREATEUSER /*165N*/
	| NOINHERIT /*166N*/
	| NOLOGIN_P /*167N*/
	| NOOVERCOMMIT /*168N*/
	| NOSUPERUSER /*169N*/
	| NOTHING /*170N*/
	| NOTIFY /*171N*/
	| NOWAIT /*172N*/
	| OBJECT_P /*174N*/
	| OF /*175N*/
	| OIDS /*176N*/
	| OPERATOR /*339L*/
	| OPTION /*177N*/
	| OTHERS /*179N*/
	| OVERCOMMIT /*181N*/
	| OWNED /*182N*/
	| OWNER /*183N*/
	| PARTIAL /*184N*/
	| PARTITIONS /*185N*/
	| PASSWORD /*186N*/
	| PB /*187N*/
	| PERCENT /*188N*/
	| PREPARE /*189N*/
	| PREPARED /*190N*/
	| PRESERVE /*191N*/
	| PRIOR /*192N*/
	| PRIVILEGES /*193N*/
	| PROCEDURAL /*194N*/
	| PROCEDURE /*195N*/
	| PROTOCOL /*197N*/
	| QUEUE /*198N*/
	| QUOTE /*199N*/
	| READ /*201N*/
	| REASSIGN /*204N*/
	| RECHECK /*205N*/
	| REINDEX /*207N*/
	| RELATIVE_P /*209N*/
	| RELEASE /*210N*/
	| RENAME /*211N*/
	| REPEATABLE /*212N*/
	| REPLACE /*213N*/
	| RESET /*214N*/
	| RESOURCE /*215N*/
	| RESTART /*216N*/
	| RESTRICT /*217N*/
	| RETURNS /*218N*/
	| REVOKE /*219N*/
	| ROLE /*220N*/
	| ROLLBACK /*221N*/
	| RULE /*222N*/
	| SAVEPOINT /*223N*/
	| SCHEMA /*224N*/
	| SCROLL /*225N*/
	| SECURITY /*228N*/
	| SEGMENT /*229N*/
	| SEQUENCE /*230N*/
	| SERIALIZABLE /*231N*/
	| SESSION /*233N*/
	| SET /*1N*/
	| SHARE /*234N*/
	| SHOW /*235N*/
	| SIMPLE /*236N*/
	| SPLIT /*237N*/
	| SQL /*238N*/
	| STABLE /*239N*/
	| START /*240N*/
	| STATEMENT /*241N*/
	| STATISTICS /*242N*/
	| STDIN /*243N*/
	| STDOUT /*244N*/
	| STORAGE /*245N*/
	| STRICT_P /*251N*/
	| SUBPARTITION /*246N*/
	| SUBPARTITIONS /*247N*/
	| SUPERUSER_P /*248N*/
	| SYSID /*249N*/
	| SYSTEM_P /*250N*/
	| TB /*253N*/
	| TEMP /*254N*/
	| TEMPLATE /*255N*/
	| TEMPORARY /*256N*/
	| THRESHOLD /*257N*/
	| TIES /*258N*/
	| TRANSACTION /*259N*/
	| TRIGGER /*260N*/
	| TRUNCATE /*261N*/
	| TRUSTED /*262N*/
	| TYPE_P /*263N*/
	| UNCOMMITTED /*264N*/
	| UNENCRYPTED /*265N*/
	| UNKNOWN /*342N*/
	| UNLISTEN /*266N*/
	| UNTIL /*267N*/
	| UPDATE /*268N*/
	| VACUUM /*269N*/
	| VALID /*270N*/
	| VALIDATOR /*272N*/
	| VIEW /*276N*/
	| VOLATILE /*277N*/
	| WORK /*282N*/
	| WRITE /*285N*/
	| ZONE /*346L*/
	| BIGINT /*287N*/
	| BIT /*288N*/
	| BOOLEAN_P /*289N*/
	| COALESCE /*292N*/
	| CONVERT /*293N*/
	| CUBE /*294N*/
	| DEC /*295N*/
	| DECIMAL_P /*296N*/
	| EXISTS /*297N*/
	| EXTRACT /*298N*/
	| FLOAT_P /*299N*/
	| GREATEST /*300N*/
	| GROUP_ID /*301N*/
	| GROUPING /*302N*/
	| INOUT /*303N*/
	| INT_P /*304N*/
	| INTEGER /*305N*/
	| INTERVAL /*306N*/
	| LEAST /*307N*/
	| NATIONAL /*309N*/
	| NCHAR /*310N*/
	| NONE /*311N*/
	| NULLIF /*312N*/
	| NUMERIC /*313N*/
	| OUT_P /*314N*/
	| OVERLAY /*315N*/
	| POSITION /*318N*/
	| PRECISION /*319N*/
	| REAL /*320N*/
	| ROLLUP /*321N*/
	| ROW /*322N*/
	| SETOF /*323N*/
	| SETS /*324N*/
	| SMALLINT /*325N*/
	| SUBSTRING /*326N*/
	| TIME /*327N*/
	| TIMESTAMP /*328N*/
	| TREAT /*329N*/
	| TRIM /*330N*/
	| VALUES /*331N*/
	| VARCHAR /*332N*/
	| AUTHORIZATION /*333N*/
	| BINARY /*334N*/
	| FREEZE /*335N*/
	| LOG_P /*336N*/
	| OUTER_P /*337N*/
	| VERBOSE /*338N*/
	;

col_name_keyword :
	BIGINT /*287N*/
	| BIT /*288N*/
	| BOOLEAN_P /*289N*/
	| CHAR_P /*290N*/
	| CHARACTER /*291N*/
	| COALESCE /*292N*/
	| CONVERT /*293N*/
	| CUBE /*294N*/
	| DEC /*295N*/
	| DECIMAL_P /*296N*/
	| EXISTS /*297N*/
	| EXTRACT /*298N*/
	| FLOAT_P /*299N*/
	| GREATEST /*300N*/
	| GROUP_ID /*301N*/
	| GROUPING /*302N*/
	| INOUT /*303N*/
	| INT_P /*304N*/
	| INTEGER /*305N*/
	| INTERVAL /*306N*/
	| LEAST /*307N*/
	| MEDIAN /*308N*/
	| NATIONAL /*309N*/
	| NCHAR /*310N*/
	| NONE /*311N*/
	| NULLIF /*312N*/
	| NUMERIC /*313N*/
	| OUT_P /*314N*/
	| OVERLAY /*315N*/
	| PERCENTILE_CONT /*316N*/
	| PERCENTILE_DISC /*317N*/
	| POSITION /*318N*/
	| PRECISION /*319N*/
	| REAL /*320N*/
	| ROLLUP /*321N*/
	| ROW /*322N*/
	| SETOF /*323N*/
	| SETS /*324N*/
	| SMALLINT /*325N*/
	| SUBSTRING /*326N*/
	| TIME /*327N*/
	| TIMESTAMP /*328N*/
	| TREAT /*329N*/
	| TRIM /*330N*/
	| VALUES /*331N*/
	| VARCHAR /*332N*/
	;

func_name_keyword :
	AUTHORIZATION /*333N*/
	| BINARY /*334N*/
	| CROSS /*352L*/
	| CURRENT_SCHEMA
	| FREEZE /*335N*/
	| FULL /*352L*/
	| ILIKE /*9N*/
	| INNER_P /*352L*/
	| IS /*342N*/
	| ISNULL /*341N*/
	| JOIN /*352L*/
	| LEFT /*352L*/
	| LIKE /*9N*/
	| LOG_P /*336N*/
	| NATURAL /*352L*/
	| NOTNULL /*340N*/
	| OUTER_P /*337N*/
	| OVERLAPS /*11N*/
	| RIGHT /*352L*/
	| SIMILAR /*9N*/
	| VERBOSE /*338N*/
	;

reserved_keyword :
	ALL
	| ANALYSE
	| ANALYZE
	| AND /*5L*/
	| ANY
	| ARRAY
	| AS
	| ASC
	| ASYMMETRIC
	| BETWEEN /*12N*/
	| BOTH
	| CASE
	| CAST
	| CHECK
	| COLLATE
	| COLUMN
	| CONSTRAINT
	| CREATE
	| CURRENT_CATALOG
	| CURRENT_DATE
	| CURRENT_ROLE
	| CURRENT_TIME
	| CURRENT_TIMESTAMP
	| CURRENT_USER
	| DECODE
	| DEFAULT
	| DEFERRABLE
	| DESC
	| DISCRIMINATOR
	| DISTINCT
	| DISTRIBUTED
	| DO
	| ELSE
	| END_P /*82N*/
	| EXCEPT /*2L*/
	| EXCLUDE
	| EDGE
	| FALSE_P /*342N*/
	| FETCH /*92N*/
	| FILTER
	| FOLLOWING
	| FOR
	| FOREIGN
	| FROM
	| GRANT
	| GRAPH
	| GROUP_P
	| HAVING
	| IN_P /*13N*/
	| INITIALLY
	| INTERSECT /*3L*/
	| INTO
	| LEADING
	| LIMIT
	| LOCALTIME
	| LOCALTIMESTAMP
	| NEW
	| NOT /*6R*/
	| NULL_P /*342N*/
	| OFF
	| OFFSET
	| OLD
	| ON
	| ONLY
	| OR /*4L*/
	| ORDER
	| PARTITION /*15N*/
	| PLACING
	| PRECEDING
	| PRIMARY
	| RANGE /*15N*/
	| REFERENCES
	| RETURNING
	| REVERSED
	| ROWS /*15N*/
	| SCATTER
	| SELECT
	| SESSION_USER
	| SOME
	| SYMMETRIC
	| TABLE
	| THEN
	| TO
	| TRAILING
	| TRUE_P /*342N*/
	| UNBOUNDED
	| UNION /*2L*/
	| UNIQUE
	| USER
	| USING
	| VARIADIC
	| VERTEX
	| WINDOW
	| WITH /*279N*/
	| WHEN
	| WHERE
	;

SpecialRuleRelation :
	OLD
	| NEW
	;

%%

/*
 * In order to make the world safe for Windows and Mac clients as well as
 * Unix ones, we accept either \n or \r as a newline.  A DOS-style \r\n
 * sequence will be seen as two successive newlines, but that doesn't cause
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
xbinside		[^']*

/* Hexadecimal number */
xhstart			[xX]{quote}
xhinside		[^']*

/* National character */
xnstart			[nN]{quote}

/* Quoted string that allows backslash escapes */
xestart			[eE]{quote}
xeinside		[^\\']+
xeescape		[\\][^0-7]
xeoctesc		[\\][0-7]{1,3}
xehexesc		[\\]x[0-9A-Fa-f]{1,2}
xeunicode		[\\](u[0-9A-Fa-f]{4}|U[0-9A-Fa-f]{8})
xeunicodebad	[\\]([uU])

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
uescapefail		("-"|[uU][eE][sS][cC][aA][pP][eE]{whitespace}*"-"|[uU][eE][sS][cC][aA][pP][eE]{whitespace}*{quote}[^']|[uU][eE][sS][cC][aA][pP][eE]{whitespace}*{quote}|[uU][eE][sS][cC][aA][pP][eE]{whitespace}*|[uU][eE][sS][cC][aA][pP]|[uU][eE][sS][cC][aA]|[uU][eE][sS][cC]|[uU][eE][sS]|[uU][eE]|[uU])

/* Quoted identifier with Unicode escapes */
xuistart		[uU]&{dquote}
xuistop1		{dquote}{whitespace}*{uescapefail}?
xuistop2		{dquote}{whitespace}*{uescape}

/* Quoted string with Unicode escapes */
xusstart		[uU]&{quote}
xusstop1		{quote}{whitespace}*{uescapefail}?
xusstop2		{quote}{whitespace}*{uescape}

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
op_chars		[\~\!\@\#\^\&\|\`\?\+\-\*\/\%\<\>\=]
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

typecast		"::"

/* we no longer allow unary minus in numbers.
 * instead we pass it separately to parser. there it gets
 * coerced via doNegate() -- Leon aug 20 1999
 *
 * {realfail1} and {realfail2} are added to prevent the need for scanner
 * backup when the {real} rule fails to match completely.
 */

integer			{digit}+
decimal			(({digit}*\.{digit}+)|({digit}+\.{digit}*))
real			({integer}|{decimal})[Ee][-+]?{digit}+
realfail1		({integer}|{decimal})[Ee]
realfail2		({integer}|{decimal})[Ee][-+]

param			\${integer}

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

xxspaces	[ \t\r\n]+
xxline_comment	--[^\r\n]*
xxblock_comment	\/\*(?s:.)*?\*\/

%%
/*Lexer rules*/

{whitespace}	skip()
{xxblock_comment}   skip()

ABORT	ABORT_P
ABSOLUTE	ABSOLUTE_P
ACCESS	ACCESS
ACTION	ACTION
ACTIVE	ACTIVE
ADD_P	ADD_P
ADMIN	ADMIN
AFTER	AFTER
AGGREGATE	AGGREGATE
ALL	ALL
ALSO	ALSO
ALTER	ALTER
ANALYSE	ANALYSE
ANALYZE	ANALYZE
AND	AND
ANY	ANY
ARRAY	ARRAY
AS	AS
ASC	ASC
ASSERTION	ASSERTION
ASSIGNMENT	ASSIGNMENT
ASYMMETRIC	ASYMMETRIC
AT	AT
AUTHORIZATION	AUTHORIZATION
BACKWARD	BACKWARD
BEFORE	BEFORE
BEGIN_P	BEGIN_P
BETWEEN	BETWEEN
BIGINT	BIGINT
BINARY	BINARY
BIT	BIT
BOOLEAN	BOOLEAN_P
BOTH	BOTH
BY	BY
CACHE	CACHE
CALLED	CALLED
CASCADE	CASCADE
CASCADED	CASCADED
CASE	CASE
CAST	CAST
CHAIN	CHAIN
CHARACTER	CHARACTER
CHARACTERISTICS	CHARACTERISTICS
CHAR	CHAR_P
CHECK	CHECK
CHECKPOINT	CHECKPOINT
CLASS	CLASS
CLOSE	CLOSE
CLUSTER	CLUSTER
COALESCE	COALESCE
COLLATE	COLLATE
COLUMN	COLUMN
COMMENT	COMMENT
COMMIT	COMMIT
COMMITTED	COMMITTED
CONCURRENTLY	CONCURRENTLY
CONNECTION	CONNECTION
CONSTRAINT	CONSTRAINT
CONSTRAINTS	CONSTRAINTS
CONTAINS	CONTAINS
CONTENT	CONTENT_P
CONTINUE	CONTINUE_P
CONVERSION	CONVERSION_P
CONVERT	CONVERT
COPY	COPY
COST	COST
CREATE	CREATE
CREATEDB	CREATEDB
CREATEEXTTABLE	CREATEEXTTABLE
CREATEROLE	CREATEROLE
CREATEUSER	CREATEUSER
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
CURSOR	CURSOR
CYCLE	CYCLE
DATABASE	DATABASE
DATA	DATA_P
DAY	DAY_P
DEALLOCATE	DEALLOCATE
DEC	DEC
DECIMAL	DECIMAL_P
DECLARE	DECLARE
DECODE	DECODE
DEFAULT	DEFAULT
DEFAULTS	DEFAULTS
DEFERRABLE	DEFERRABLE
DEFERRED	DEFERRED
DEFINER	DEFINER
DELETE	DELETE_P
DELIMITER	DELIMITER
DELIMITERS	DELIMITERS
DENY	DENY
DESC	DESC
DISABLE	DISABLE_P
DISCRIMINATOR	DISCRIMINATOR
DISTINCT	DISTINCT
DISTRIBUTED	DISTRIBUTED
DO	DO
DOMAIN	DOMAIN_P
DOUBLE	DOUBLE_P
DROP	DROP
DXL	DXL
EACH	EACH
EDGE	EDGE
ELSE	ELSE
ENABLE	ENABLE_P
ENCODING	ENCODING
ENCRYPTED	ENCRYPTED
END	END_P
ENUM	ENUM_P
ERRORS	ERRORS
ESCAPE	ESCAPE
EVERY	EVERY
EXCEPT	EXCEPT
EXCHANGE	EXCHANGE
EXCLUDE	EXCLUDE
EXCLUDING	EXCLUDING
EXCLUSIVE	EXCLUSIVE
EXECUTE	EXECUTE
EXISTS	EXISTS
EXPLAIN	EXPLAIN
EXTERNAL	EXTERNAL
EXTRACT	EXTRACT
FALSE	FALSE_P
FETCH	FETCH
FIELDS	FIELDS
FILESPACE	FILESPACE
FILESYSTEM	FILESYSTEM
FILL	FILL
FILTER	FILTER
FIRST	FIRST_P
FLOAT	FLOAT_P
FOLLOWING	FOLLOWING
FOR	FOR
FORCE	FORCE
FOREIGN	FOREIGN
FORMAT	FORMAT
FORMATTER	FORMATTER
FORWARD	FORWARD
FREEZE	FREEZE
FROM	FROM
FULL	FULL
FUNCTION	FUNCTION
FUNCTIONS	FUNCTIONS
GB	GB
GLOBAL	GLOBAL
GRANT	GRANT
GRANTED	GRANTED
GRAPH	GRAPH
GREATEST	GREATEST
GROUP_ID	GROUP_ID
GROUPING	GROUPING
GROUP_P	GROUP_P
HANDLER	HANDLER
HASH	HASH
HAVING	HAVING
HEADER	HEADER_P
HOLD	HOLD
HOST	HOST
HOUR	HOUR_P
IDENTITY	IDENTITY_P
IF	IF_P
IGNORE	IGNORE_P
ILIKE	ILIKE
IMMEDIATE	IMMEDIATE
IMMUTABLE	IMMUTABLE
IMPLICIT	IMPLICIT_P
INCLUDE	INCLUDE
INCLUDING	INCLUDING
INCLUSIVE	INCLUSIVE
INCREMENT	INCREMENT
INDEX	INDEX
INDEXES	INDEXES
INHERIT	INHERIT
INHERITS	INHERITS
INITIALLY	INITIALLY
INNER	INNER_P
INOUT	INOUT
IN	IN_P
INPUT	INPUT_P
INSENSITIVE	INSENSITIVE
INSERT	INSERT
INSTEAD	INSTEAD
INTEGER	INTEGER
INTERSECT	INTERSECT
INTERVAL	INTERVAL
INTO	INTO
INT	INT_P
INVOKER	INVOKER
IS	IS
ISNULL	ISNULL
ISOLATION	ISOLATION
JOIN	JOIN
KB	KB
KEEP	KEEP
KEY	KEY
LANCOMPILER	LANCOMPILER
LANGUAGE	LANGUAGE
LARGE	LARGE_P
LAST	LAST_P
LEADING	LEADING
LEAST	LEAST
LEFT	LEFT
LEVEL	LEVEL
LIKE	LIKE
LIMIT	LIMIT
LIST	LIST
LISTEN	LISTEN
LOAD	LOAD
LOCAL	LOCAL
LOCALTIME	LOCALTIME
LOCALTIMESTAMP	LOCALTIMESTAMP
LOCATION	LOCATION
LOCK	LOCK_P
LOGIN	LOGIN_P
LOG	LOG_P
MAPPING	MAPPING
MASTER	MASTER
MATCH	MATCH
MAXVALUE	MAXVALUE
MB	MB
MEDIAN	MEDIAN
MERGE	MERGE
MINUTE	MINUTE_P
MINVALUE	MINVALUE
MIRROR	MIRROR
MISSING	MISSING
MODE	MODE
MODIFIES	MODIFIES
MODIFY	MODIFY
MONTH	MONTH_P
MOVE	MOVE
NAME	NAME_P
NAMES	NAMES
NATIONAL	NATIONAL
NATURAL	NATURAL
NCHAR	NCHAR
NEW	NEW
NEWLINE	NEWLINE
NEXT	NEXT
NO	NO
NOCREATEDB	NOCREATEDB
NOCREATEEXTTABLE	NOCREATEEXTTABLE
NOCREATEROLE	NOCREATEROLE
NOCREATEUSER	NOCREATEUSER
NOINHERIT	NOINHERIT
NOLOGIN	NOLOGIN_P
NONE	NONE
NOOVERCOMMIT	NOOVERCOMMIT
NOSUPERUSER	NOSUPERUSER
NOT	NOT
NOTHING	NOTHING
NOTIFY	NOTIFY
NOTNULL	NOTNULL
NOWAIT	NOWAIT
NULLIF	NULLIF
NULL	NULL_P
NULLS	NULLS_P
NUMERIC	NUMERIC
OBJECT	OBJECT_P
OF	OF
OFF	OFF
OFFSET	OFFSET
OIDS	OIDS
OLD	OLD
ON	ON
ONLY	ONLY
OPERATOR	OPERATOR
OPTION	OPTION
OPTIONS	OPTIONS
OR	OR
ORDER	ORDER
ORDERED	ORDERED
OTHERS	OTHERS
OUTER	OUTER_P
OUT	OUT_P
OVER	OVER
OVERCOMMIT	OVERCOMMIT
OVERLAPS	OVERLAPS
OVERLAY	OVERLAY
OWNED	OWNED
OWNER	OWNER
PARTIAL	PARTIAL
PARTITION	PARTITION
PARTITIONS	PARTITIONS
PASSWORD	PASSWORD
PB	PB
PERCENT	PERCENT
PERCENTILE_CONT	PERCENTILE_CONT
PERCENTILE_DISC	PERCENTILE_DISC
PLACING	PLACING
POSITION	POSITION
PRECEDING	PRECEDING
PRECISION	PRECISION
PREPARE	PREPARE
PREPARED	PREPARED
PRESERVE	PRESERVE
PRIMARY	PRIMARY
PRIOR	PRIOR
PRIVILEGES	PRIVILEGES
PROCEDURAL	PROCEDURAL
PROCEDURE	PROCEDURE
PROTOCOL	PROTOCOL
QUEUE	QUEUE
QUOTE	QUOTE
RANDOMLY	RANDOMLY
RANGE	RANGE
READ	READ
READABLE	READABLE
READS	READS
REAL	REAL
REASSIGN	REASSIGN
RECHECK	RECHECK
RECURSIVE	RECURSIVE
REFERENCES	REFERENCES
REINDEX	REINDEX
REJECT	REJECT_P
RELATIVE_P	RELATIVE_P
RELEASE	RELEASE
RENAME	RENAME
REPEATABLE	REPEATABLE
REPLACE	REPLACE
RESET	RESET
RESOURCE	RESOURCE
RESTART	RESTART
RESTRICT	RESTRICT
RETURNING	RETURNING
RETURNS	RETURNS
REVERSED	REVERSED
REVOKE	REVOKE
RIGHT	RIGHT
ROLE	ROLE
ROLLBACK	ROLLBACK
ROLLUP	ROLLUP
ROOTPARTITION	ROOTPARTITION
ROW	ROW
ROWS	ROWS
RULE	RULE
SAVEPOINT	SAVEPOINT
SCATTER	SCATTER
SCHEMA	SCHEMA
SCROLL	SCROLL
SEARCH	SEARCH
SECOND	SECOND_P
SECURITY	SECURITY
SEGMENT	SEGMENT
SELECT	SELECT
SEQUENCE	SEQUENCE
SEQUENCES	SEQUENCES
SERIALIZABLE	SERIALIZABLE
SERVER	SERVER
SESSION	SESSION
SESSION_USER	SESSION_USER
SET	SET
SETOF	SETOF
SETS	SETS
SHARE	SHARE
SHOW	SHOW
SIMILAR	SIMILAR
SIMPLE	SIMPLE
SMALLINT	SMALLINT
SOME	SOME
SPLIT	SPLIT
SQL	SQL
STABLE	STABLE
START	START
STATEMENT	STATEMENT
STATISTICS	STATISTICS
STDIN	STDIN
STDOUT	STDOUT
STORAGE	STORAGE
STRICT	STRICT_P
SUBPARTITION	SUBPARTITION
SUBPARTITIONS	SUBPARTITIONS
SUBSTRING	SUBSTRING
SUPERUSER	SUPERUSER_P
SYMMETRIC	SYMMETRIC
SYSID	SYSID
SYSTEM	SYSTEM_P
TABLE	TABLE
TABLES	TABLES
TABLESPACE	TABLESPACE
TB	TB
TEMP	TEMP
TEMPLATE	TEMPLATE
TEMPORARY	TEMPORARY
THEN	THEN
THRESHOLD	THRESHOLD
TIES	TIES
TIME	TIME
TIMESTAMP	TIMESTAMP
TO	TO
TRAILING	TRAILING
TRANSACTION	TRANSACTION
TREAT	TREAT
TRIGGER	TRIGGER
TRIM	TRIM
TRUE	TRUE_P
TRUNCATE	TRUNCATE
TRUSTED	TRUSTED
TYPE	TYPE_P
UNBOUNDED	UNBOUNDED
UNCOMMITTED	UNCOMMITTED
UNENCRYPTED	UNENCRYPTED
UNION	UNION
UNIQUE	UNIQUE
UNKNOWN	UNKNOWN
UNLISTEN	UNLISTEN
UNTIL	UNTIL
UPDATE	UPDATE
USER	USER
USING	USING
VACUUM	VACUUM
VALID	VALID
VALIDATION	VALIDATION
VALIDATOR	VALIDATOR
VALUE	VALUE_P
VALUES	VALUES
VARCHAR	VARCHAR
VARIADIC	VARIADIC
VARYING	VARYING
VERBOSE	VERBOSE
VERSION	VERSION_P
VERTEX	VERTEX
VIEW	VIEW
VOLATILE	VOLATILE
WEB	WEB
WHEN	WHEN
WHERE	WHERE
WINDOW	WINDOW
WITH	WITH
WITH_CASCADED	WITH_CASCADED
WITH_CHECK	WITH_CHECK
WITHIN	WITHIN
WITH_LOCAL	WITH_LOCAL
WITHOUT	WITHOUT
WITH_TIME	WITH_TIME
WORK	WORK
WRAPPER	WRAPPER
WRITABLE	WRITABLE
WRITE	WRITE
YEAR	YEAR_P
ZONE	ZONE

{typecast}	TYPECAST


"="	'='
"<"	'<'
">"	'>'
"+"	'+'
"-"	'-'
"*"	'*'
"/"	'/'
"%"	'%'
"^"	'^'
"["	'['
"]"	']'
"("	'('
")"	')'
"."	'.'
";"	';'
","	','
":"	':'

//Op	Op
"<="	Op
">="	Op
"<>"	Op
"!="	Op

/* Order matter if identifier comes before keywords they are classified as identifier */
{identifier}	IDENT
\"(\\[\"\\]|[^\"\n\r])*\"	IDENT
{real}	FCONST
{decimal} FCONST
'(\\['\\]|[^'\n\r])*'	SCONST

BCONST	BCONST
XCONST	XCONST
[0-9]+	ICONST
\$[0-9]+	PARAM

%%
