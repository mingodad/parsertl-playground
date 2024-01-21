//From: https://github.com/FirebirdSQL/firebird/blob/a2762554352b2102f3641f312717ca7c800286d3/src/dsql/parse.y
/*
 *	PROGRAM:	Dynamic SQL runtime support
 *	MODULE:		parse.y
 *	DESCRIPTION:	Dynamic SQL parser
 *
 * The contents of this file are subject to the Interbase Public
 * License Version 1.0 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy
 * of the License at http://www.Inprise.com/IPL.html
 *
 * Software distributed under the License is distributed on an
 * "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express
 * or implied. See the License for the specific language governing
 * rights and limitations under the License.
 *
 * The Original Code was created by Inprise Corporation
 * and its predecessors. Portions created by Inprise Corporation are
 * Copyright (C) Inprise Corporation.
 *
 * All Rights Reserved.
 * Contributor(s): ______________________________________.
 *
 * 2002-02-24 Sean Leyne - Code Cleanup of old Win 3.1 port (WINDOWS_ONLY)
 * 2001.05.20 Neil McCalden: Allow a udf to be used in a 'group by' clause.
 * 2001.05.30 Claudio Valderrama: DROP TABLE and DROP VIEW lead now to two
 *   different node types so DDL can tell which is which.
 * 2001.06.13 Claudio Valderrama: SUBSTRING is being surfaced.
 * 2001.06.30 Claudio valderrama: Feed (line,column) for each node. See node.h.
 * 2001.07.10 Claudio Valderrama: Better (line,column) report and "--" for comments.
 * 2001.07.28 John Bellardo: Changes to support parsing LIMIT and FIRST
 * 2001.08.03 John Bellardo: Finalized syntax for LIMIT, change LIMIT to SKIP
 * 2001.08.05 Claudio Valderrama: closed Bug #448062 and other spaces that appear
 *   in rdbdd_source fields when altering domains plus one unexpected null pointer.
 * 2001.08.12 Claudio Valderrama: adjust SUBSTRING's starting pos argument here
 *   and not in gen.c; this closes Bug #450301.
 * 2001.10.01 Claudio Valderrama: enable explicit GRANT...to ROLE role_name.
 * 2001.10.06 Claudio Valderrama: Honor explicit USER keyword in GRANTs and REVOKEs.
 * 2002.07.05 Mark O'Donohue: change keyword DEBUG to KW_DEBUG to avoid
 *			clashes with normal DEBUG macro.
 * 2002.07.30 Arno Brinkman:
 * 2002.07.30 	Let IN predicate handle value_expressions
 * 2002.07.30 	tokens CASE, NULLIF, COALESCE added
 * 2002.07.30 	See block < CASE expression > what is added to value as case_expression
 * 2002.07.30 	function is split up into aggregate_function, numeric_value_function, string_value_function, generate_value_function
 * 2002.07.30 	new group_by_function and added to grp_column_elem
 * 2002.07.30 	cast removed from function and added as cast_specification to value
 * 2002.08.04 Claudio Valderrama: allow declaring and defining variables at the same time
 * 2002.08.04 Dmitry Yemanov: ALTER VIEW
 * 2002.08.06 Arno Brinkman: ordinal added to grp_column_elem for using positions in group by
 * 2002.08.07 Dmitry Yemanov: INT64/LARGEINT are replaced with BIGINT and available in dialect 3 only
 * 2002.08.31 Dmitry Yemanov: allowed user-defined index names for PK/FK/UK constraints
 * 2002.09.01 Dmitry Yemanov: RECREATE VIEW
 * 2002.09.28 Dmitry Yemanov: Reworked internal_info stuff, enhanced
 *							exception handling in SPs/triggers,
 *							implemented ROWS_AFFECTED system variable
 * 2002.10.21 Nickolay Samofatov: Added support for explicit pessimistic locks
 * 2002.10.29 Nickolay Samofatov: Added support for savepoints
 * 2002.12.03 Dmitry Yemanov: Implemented ORDER BY clause in subqueries.
 * 2002.12.18 Dmitry Yemanov: Added support for SQL-compliant labels and LEAVE statement
 * 2002.12.28 Dmitry Yemanov: Added support for parametrized events.
 * 2003.01.14 Dmitry Yemanov: Fixed bug with cursors in triggers.
 * 2003.01.15 Dmitry Yemanov: Added support for runtime trigger action checks.
 * 2003.02.10 Mike Nordell  : Undefined Microsoft introduced macros to get a clean compile.
 * 2003.05.24 Nickolay Samofatov: Make SKIP and FIRST non-reserved keywords
 * 2003.06.13 Nickolay Samofatov: Make INSERTING/UPDATING/DELETING non-reserved keywords
 * 2003.07.01 Blas Rodriguez Somoza: Change DEBUG and IN to avoid conflicts in win32 build/bison
 * 2003.08.11 Arno Brinkman: Changed GROUP BY to support all expressions and added "AS" support
 *						   with table alias. Also removed group_by_function and ordinal.
 * 2003.08.14 Arno Brinkman: Added support for derived tables.
 * 2003.10.05 Dmitry Yemanov: Added support for explicit cursors in PSQL.
 * 2004.01.16 Vlad Horsun: added support for default parameters and
 *   EXECUTE BLOCK statement
 * Adriano dos Santos Fernandes
 */

%token ACTIVE
%token ADD
%token AFTER
%token ALL
%token ALTER
%token AND
%token ANY
%token AS
%token ASC
%token AT
%token AVG
%token AUTO
%token BEFORE
%token BEGIN
%token BETWEEN
%token BLOB
%token BY
%token CAST
%token CHARACTER
%token CHECK
%token COLLATE
%token COMMIT
%token COMMITTED
%token COMPUTED
%token CONCATENATE
%token CONDITIONAL
%token CONSTRAINT
%token CONTAINING
%token COUNT
%token CREATE
%token CSTRING
%token CURRENT
%token CURSOR
%token DATABASE
%token DATE
%token DB_KEY
%token DECIMAL
%token DECLARE
%token DEFAULT
%token DELETE
%token DESC
%token DISTINCT
%token DO
%token DOMAIN
%token DROP
%token ELSE
%token END
%token ENTRY_POINT
%token ESCAPE
%token EXCEPTION
%token EXECUTE
%token EXISTS
%token EXIT
%token EXTERNAL
%token FILTER
%token FOR
%token FOREIGN
%token FROM
%token FULL
%token FUNCTION
%token GDSCODE
%token GEQ
%token GENERATOR
%token GEN_ID
%token GRANT
%token GROUP
%token HAVING
%token IF
%token IN
%token INACTIVE
%token INNER
%token INPUT_TYPE
%token INDEX
%token INSERT
%token INTEGER
%token INTO
%token IS
%token ISOLATION
%token JOIN
%token KEY
%token CHAR
%token DEC
%token DOUBLE
%token FILE
%token FLOAT
%token INT
%token LONG
%token NULL
%token NUMERIC
%token UPPER
%token VALUE
%token LENGTH
%token LEFT
%token LEQ
%token LEVEL
%token LIKE
%token MANUAL
%token MAXIMUM
%token MERGE
%token MINIMUM
%token MODULE_NAME
%token NAMES
%token NATIONAL
%token NATURAL
%token NCHAR
%token NEQ
%token NO
%token NOT
%token NOT_GTR
%token NOT_LSS
%token OF
%token ON
%token ONLY
%token OPTION
%token OR
%token ORDER
%token OUTER
%token OUTPUT_TYPE
%token OVERFLOW
%token PAGE
%token PAGES
%token PAGE_SIZE
%token PARAMETER
%token PASSWORD
%token PLAN
%token POSITION
%token POST_EVENT
%token PRECISION
%token PRIMARY
%token PRIVILEGES
%token PROCEDURE
%token PROTECTED
%token READ
%token REAL
%token REFERENCES
%token RESERVING
%token RETAIN
%token RETURNING_VALUES
%token RETURNS
%token REVOKE
%token RIGHT
%token ROLLBACK
%token SEGMENT
%token SELECT
%token SET
%token SHADOW
%token SHARED
%token SINGULAR
%token SIZE
%token SMALLINT
%token SNAPSHOT
%token SOME
%token SORT
%token SQLCODE
%token STABILITY
%token STARTING
%token STATISTICS
%token SUB_TYPE
%token SUSPEND
%token SUM
%token TABLE
%token THEN
%token TO
%token TRANSACTION
%token TRIGGER
%token UNCOMMITTED
%token UNION
%token UNIQUE
%token UPDATE
%token USER
%token VALUES
%token VARCHAR
%token VARIABLE
%token VARYING
%token VERSION
%token VIEW
%token WAIT
%token WHEN
%token WHERE
%token WHILE
%token WITH
%token WORK
%token WRITE
%token FLOAT_NUMBER
%token DECIMAL_NUMBER
%token LIMIT64_NUMBER
%token LIMIT64_INT
%token NUM128
%token SYMBOL
%token NUMBER32BIT
%token STRING
%token INTRODUCER
%token ACTION
%token ADMIN
%token CASCADE
%token FREE_IT
%token RESTRICT
%token ROLE
%token COLUMN
%token TYPE
%token EXTRACT
%token YEAR
%token MONTH
%token DAY
%token HOUR
%token MINUTE
%token SECOND
%token WEEKDAY
%token YEARDAY
%token TIME
%token TIMESTAMP
%token CURRENT_DATE
%token CURRENT_TIME
%token CURRENT_TIMESTAMP
%token NUMBER64BIT
%token SCALEDINT
%token CURRENT_USER
%token CURRENT_ROLE
%token BREAK
%token SUBSTRING
%token RECREATE
%token DESCRIPTOR
%token FIRST
%token SKIP
%token CURRENT_CONNECTION
%token CURRENT_TRANSACTION
%token BIGINT
%token CASE
%token NULLIF
%token COALESCE
%token USING
%token NULLS
%token LAST
%token ROW_COUNT
%token LOCK
%token SAVEPOINT
%token RELEASE
%token STATEMENT
%token LEAVE
%token INSERTING
%token UPDATING
%token DELETING
%token BACKUP
%token DIFFERENCE
%token OPEN
%token CLOSE
%token FETCH
%token ROWS
%token BLOCK
%token IIF
%token SCALAR_ARRAY
%token CROSS
%token NEXT
%token SEQUENCE
%token RESTART
%token BOTH
%token COLLATION
%token COMMENT
%token BIT_LENGTH
%token CHAR_LENGTH
%token CHARACTER_LENGTH
%token LEADING
%token LOWER
%token OCTET_LENGTH
%token TRAILING
%token TRIM
%token RETURNING
%token IGNORE
%token LIMBO
%token UNDO
%token REQUESTS
%token TIMEOUT
%token ABS
%token ACCENT
%token ACOS
%token ALWAYS
%token ASCII_CHAR
%token ASCII_VAL
%token ASIN
%token ATAN
%token ATAN2
%token BIN_AND
%token BIN_OR
%token BIN_SHL
%token BIN_SHR
%token BIN_XOR
%token CEIL
%token CONNECT
%token COS
%token COSH
%token COT
%token DATEADD
%token DATEDIFF
%token DECODE
%token DISCONNECT
%token EXP
%token FLOOR
%token GEN_UUID
%token GENERATED
%token GLOBAL
%token HASH
%token INSENSITIVE
%token LIST
%token LN
%token LOG
%token LOG10
%token LPAD
%token MATCHED
%token MATCHING
%token MAXVALUE
%token MILLISECOND
%token MINVALUE
%token MOD
%token OVERLAY
%token PAD
%token PI
%token PLACING
%token POWER
%token PRESERVE
%token RAND
%token RECURSIVE
%token REPLACE
%token REVERSE
%token ROUND
%token RPAD
%token SENSITIVE
%token SIGN
%token SIN
%token SINH
%token SPACE
%token SQRT
%token START
%token TAN
%token TANH
%token TEMPORARY
%token TRUNC
%token WEEK
%token AUTONOMOUS
%token CHAR_TO_UUID
%token FIRSTNAME
%token GRANTED
%token LASTNAME
%token MIDDLENAME
%token MAPPING
%token OS_NAME
%token SIMILAR
%token UUID_TO_CHAR
%token CALLER
%token COMMON
%token DATA
%token SOURCE
%token TWO_PHASE
%token BIND_PARAM
%token BIN_NOT
%token BODY
%token CONTINUE
%token DDL
%token DECRYPT
%token ENCRYPT
%token ENGINE
%token NAME
%token OVER
%token PACKAGE
%token PARTITION
%token RDB_GET_CONTEXT
%token RDB_SET_CONTEXT
%token SCROLL
%token PRIOR
%token ABSOLUTE
%token RELATIVE
%token ACOSH
%token ASINH
%token ATANH
%token RETURN
%token DETERMINISTIC
%token IDENTITY
%token DENSE_RANK
%token FIRST_VALUE
%token NTH_VALUE
%token LAST_VALUE
%token LAG
%token LEAD
%token RANK
%token ROW_NUMBER
%token SQLSTATE
%token BOOLEAN
%token FALSE
%token TRUE
%token UNKNOWN
%token USAGE
%token RDB_RECORD_VERSION
%token LINGER
%token TAGS
%token PLUGIN
%token SERVERWIDE
%token INCREMENT
%token TRUSTED
%token ROW
%token OFFSET
%token STDDEV_SAMP
%token STDDEV_POP
%token VAR_SAMP
%token VAR_POP
%token COVAR_SAMP
%token COVAR_POP
%token CORR
%token REGR_AVGX
%token REGR_AVGY
%token REGR_COUNT
%token REGR_INTERCEPT
%token REGR_R2
%token REGR_SLOPE
%token REGR_SXX
%token REGR_SXY
%token REGR_SYY
%token BASE64_DECODE
%token BASE64_ENCODE
%token BINARY
%token BIND
%token COMPARE_DECFLOAT
%token CONSISTENCY
%token COUNTER
%token CRYPT_HASH
%token CTR_BIG_ENDIAN
%token CTR_LENGTH
%token CTR_LITTLE_ENDIAN
%token CUME_DIST
%token DECFLOAT
%token DEFINER
%token DISABLE
%token ENABLE
%token EXCESS
%token EXCLUDE
%token EXTENDED
%token FIRST_DAY
%token FOLLOWING
%token HEX_DECODE
%token HEX_ENCODE
%token IDLE
%token INCLUDE
%token INT128
%token INVOKER
%token IV
%token LAST_DAY
%token LATERAL
%token LEGACY
%token LOCAL
%token LOCALTIME
%token LOCALTIMESTAMP
%token LPARAM
%token MAKE_DBKEY
%token MESSAGE
%token MODE
%token NATIVE
%token NORMALIZE_DECFLOAT
%token NTILE
%token NUMBER
%token OTHERS
%token OVERRIDING
%token PERCENT_RANK
%token PRECEDING
%token PRIVILEGE
%token PUBLICATION
%token QUANTIZE
%token RANGE
%token RESETTING
%token RDB_ERROR
%token RDB_GET_TRANSACTION_CN
%token RDB_ROLE_IN_USE
%token RDB_SYSTEM_PRIVILEGE
%token RESET
%token RSA_DECRYPT
%token RSA_ENCRYPT
%token RSA_PRIVATE
%token RSA_PUBLIC
%token RSA_SIGN_HASH
%token RSA_VERIFY_HASH
%token SALT_LENGTH
%token SECURITY
%token SESSION
%token SIGNATURE
%token SQL
%token SYSTEM
%token TIES
%token TIMEZONE_HOUR
%token TIMEZONE_MINUTE
%token TOTALORDER
%token TRAPS
%token UNBOUNDED
%token VARBINARY
%token WINDOW
%token WITHOUT
%token ZONE
%token CONNECTIONS
%token POOL
%token LIFETIME
%token CLEAR
%token OLDEST
%token DEBUG
%token PKCS_1_5
%token BLOB_APPEND
%token LOCKED
%token OPTIMIZE
%token QUARTER
%token TARGET
%token TIMEZONE_NAME
%token UNICODE_CHAR
%token UNICODE_VAL
%token ANY_VALUE
%token CALL
%token FORMAT
%token NAMED_ARG_ASSIGN
%token '='
%token '<'
%token '>'
%token '+'
%token '-'
%token '*'
%token '/'
%token UMINUS
%token UPLUS
%token ';'
%token ','
%token '('
%token ')'
%token '.'
%token ':'
%token '['
%token ']'
%token '?'

%fallback SYMBOL LOWER TRIM
%fallback SYMBOL ABS ABSOLUTE ACCENT ACOS ACOSH ACTION ACTIVE AFTER ALWAYS ANY_VALUE
%fallback SYMBOL ASC ASCII_CHAR ASCII_VAL ASIN ASINH ATAN ATAN2 ATANH AUTO AUTONOMOUS
%fallback SYMBOL BACKUP BASE64_DECODE BASE64_ENCODE BEFORE BIN_AND BIND BIN_NOT
%fallback SYMBOL BIN_OR BIN_SHL BIN_SHR BIN_XOR BLOB_APPEND BLOCK BODY BREAK CALLER
%fallback SYMBOL CASCADE CEIL CHAR_TO_UUID CLEAR COALESCE COLLATION COMMITTED COMMON
%fallback SYMBOL COMPARE_DECFLOAT COMPUTED CONDITIONAL CONNECTIONS CONSISTENCY
%fallback SYMBOL CONTAINING CONTINUE COS COSH COT COUNTER CRYPT_HASH CSTRING
%fallback SYMBOL CTR_BIG_ENDIAN CTR_LENGTH CTR_LITTLE_ENDIAN CUME_DIST DATA DATABASE
%fallback SYMBOL DATEADD DATEDIFF DDL DEBUG DECODE DECRYPT DEFINER DENSE_RANK DESC
%fallback SYMBOL DESCRIPTOR DIFFERENCE DISABLE DO DOMAIN ENABLE ENCRYPT ENGINE ENTRY_POINT
%fallback SYMBOL EXCEPTION EXCESS EXCLUDE EXIT EXP EXTENDED FILE FIRST FIRST_DAY FIRSTNAME
%fallback SYMBOL FIRST_VALUE FLOOR FOLLOWING FORMAT FREE_IT GENERATED GENERATOR GEN_ID
%fallback SYMBOL GEN_UUID GRANTED HASH HEX_DECODE HEX_ENCODE IDENTITY IDLE IF IGNORE IIF
%fallback SYMBOL INACTIVE INCLUDE INCREMENT INPUT_TYPE INVOKER ISOLATION IV KEY LAG LAST
%fallback SYMBOL LAST_DAY LASTNAME LAST_VALUE LEAD LEAVE LEGACY LENGTH LEVEL LIFETIME
%fallback SYMBOL LIMBO LINGER LIST LN LOCK LOCKED LOG LOG10 LPAD LPARAM MAKE_DBKEY MANUAL
%fallback SYMBOL MAPPING MATCHED MATCHING MAXVALUE MESSAGE MIDDLENAME MILLISECOND
%fallback SYMBOL MINVALUE MOD MODE MODULE_NAME NAME NAMES NATIVE NEXT NORMALIZE_DECFLOAT
%fallback SYMBOL NTH_VALUE NTILE NULLIF NULLS NUMBER OLDEST OPTIMIZE OPTION OS_NAME OTHERS
%fallback SYMBOL OUTPUT_TYPE OVERFLOW OVERLAY OVERRIDING PACKAGE PAD PAGE PAGES PAGE_SIZE
%fallback SYMBOL PARTITION PASSWORD PERCENT_RANK PI PKCS_1_5 PLACING PLUGIN POOL POWER
%fallback SYMBOL PRECEDING PRESERVE PRIOR PRIVILEGE PRIVILEGES PROTECTED QUANTIZE QUARTER
%fallback SYMBOL RAND RANGE RANK READ RELATIVE REPLACE REQUESTS RESERVING RESET RESTART
%fallback SYMBOL RESTRICT RETAIN RETURNING REVERSE ROLE ROUND ROW_NUMBER RPAD RSA_DECRYPT
%fallback SYMBOL RSA_ENCRYPT RSA_PRIVATE RSA_PUBLIC RSA_SIGN_HASH RSA_VERIFY_HASH SALT_LENGTH
%fallback SYMBOL SCALAR_ARRAY SECURITY SEGMENT SEQUENCE SERVERWIDE SESSION SHADOW SHARED
%fallback SYMBOL SIGN SIGNATURE SIN SINGULAR SINH SIZE SKIP SNAPSHOT SORT SOURCE SPACE SQL SQRT
%fallback SYMBOL STABILITY STARTING STATEMENT STATISTICS SUBSTRING SUB_TYPE SUSPEND SYSTEM
%fallback SYMBOL TAGS TAN TANH TARGET TEMPORARY TIES TIMEOUT TIMEZONE_NAME TOTALORDER
%fallback SYMBOL TRANSACTION TRAPS TRUNC TRUSTED TWO_PHASE TYPE UNCOMMITTED UNDO
%fallback SYMBOL UNICODE_CHAR UNICODE_VAL USAGE UUID_TO_CHAR WAIT WEEK WEEKDAY WORK WRITE YEARDAY ZONE

%left /*1*/ OR
%left /*2*/ AND
%left /*3*/ NOT
%left /*4*/ BETWEEN CONTAINING GEQ IN LEQ LIKE NEQ NOT_GTR NOT_LSS STARTING SIMILAR '=' '<' '>'
%left /*5*/ IS
%left /*6*/ '+' '-'
%left /*7*/ '*' '/'
%left /*8*/ UMINUS UPLUS
%left /*9*/ CONCATENATE
%left /*10*/ COLLATE
%left /*11*/ AT
%nonassoc /*12*/ THEN
%nonassoc /*13*/ ELSE
%nonassoc /*14*/ ALTER
%nonassoc /*15*/ COLUMN

//%start top

%%

input :
    top
    | input top
    ;

top :
	 statement
	| statement ';'
	;
statement :
	 dml_statement
	| ddl_statement
	| tra_statement
	| mng_statement
	;
dml_statement :
	 delete
	| insert
	| merge
	| exec_procedure
	| call
	| exec_block
	| select
	| update
	| update_or_insert
	;
ddl_statement :
	 alter
	| comment
	| create
	| create_or_alter
	| declare
	| drop
	| grant
	| recreate
	| revoke
	| set_statistics
	;
tra_statement :
	 set_transaction
	| savepoint
	| commit
	| rollback
	;
mng_statement :
	 set_debug_option
	| set_decfloat_round
	| set_decfloat_traps
	| session_statement
	| set_role
	| session_reset
	| set_time_zone
	| set_bind
	| set_optimize
	;
grant :
	 GRANT grant0
	;
grant0 :
	 privileges ON table_noise symbol_table_name TO non_role_grantee_list grant_option granted_by
	| execute_privilege ON PROCEDURE symbol_procedure_name TO non_role_grantee_list grant_option granted_by
	| execute_privilege ON FUNCTION symbol_UDF_name TO non_role_grantee_list grant_option granted_by
	| execute_privilege ON PACKAGE symbol_package_name TO non_role_grantee_list grant_option granted_by
	| usage_privilege ON EXCEPTION symbol_exception_name TO non_role_grantee_list grant_option granted_by
	| usage_privilege ON GENERATOR symbol_generator_name TO non_role_grantee_list grant_option granted_by
	| usage_privilege ON SEQUENCE symbol_generator_name TO non_role_grantee_list grant_option granted_by
	| ddl_privileges object TO non_role_grantee_list grant_option granted_by
	| db_ddl_privileges DATABASE TO non_role_grantee_list grant_option granted_by
	| role_name_list TO role_grantee_list role_admin_option granted_by
	;
object :
	 TABLE
	| VIEW
	| PROCEDURE
	| FUNCTION
	| PACKAGE
	| GENERATOR
	| SEQUENCE
	| DOMAIN
	| EXCEPTION
	| ROLE
	| CHARACTER SET
	| COLLATION
	| FILTER
	;
table_noise :
	 /*empty*/
	| TABLE
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
execute_privilege :
	 EXECUTE
	;
usage_privilege :
	 USAGE
	;
privilege :
	 SELECT
	| INSERT
	| DELETE
	| UPDATE column_parens_opt
	| REFERENCES column_parens_opt
	;
ddl_privileges :
	 ALL privileges_opt
	| ddl_privilege_list
	;
privileges_opt :
	 /*empty*/
	| PRIVILEGES
	;
ddl_privilege_list :
	 ddl_privilege
	| ddl_privilege_list ',' ddl_privilege
	;
ddl_privilege :
	 CREATE
	| ALTER /*14N*/ ANY
	| DROP ANY
	;
db_ddl_privileges :
	 ALL privileges_opt
	| db_ddl_privilege_list
	;
db_ddl_privilege_list :
	 db_ddl_privilege
	| db_ddl_privilege_list ',' db_ddl_privilege
	;
db_ddl_privilege :
	 CREATE
	| ALTER /*14N*/
	| DROP
	;
grant_option :
	 /*empty*/
	| WITH GRANT OPTION
	;
role_admin_option :
	 /*empty*/
	| WITH ADMIN OPTION
	;
granted_by :
	 /*empty*/
	| granted_by_text grantor
	;
granted_by_text :
	 GRANTED BY
	| AS
	;
grantor :
	 symbol_user_name
	| USER symbol_user_name
	;
revoke :
	 REVOKE revoke0
	;
revoke0 :
	 rev_grant_option privileges ON table_noise symbol_table_name FROM non_role_grantee_list granted_by
	| rev_grant_option execute_privilege ON PROCEDURE symbol_procedure_name FROM non_role_grantee_list granted_by
	| rev_grant_option execute_privilege ON FUNCTION symbol_UDF_name FROM non_role_grantee_list granted_by
	| rev_grant_option execute_privilege ON PACKAGE symbol_package_name FROM non_role_grantee_list granted_by
	| rev_grant_option usage_privilege ON EXCEPTION symbol_exception_name FROM non_role_grantee_list granted_by
	| rev_grant_option usage_privilege ON GENERATOR symbol_generator_name FROM non_role_grantee_list granted_by
	| rev_grant_option usage_privilege ON SEQUENCE symbol_generator_name FROM non_role_grantee_list granted_by
	| rev_grant_option ddl_privileges object FROM non_role_grantee_list granted_by
	| rev_grant_option db_ddl_privileges DATABASE FROM non_role_grantee_list granted_by
	| ADMIN OPTION FOR role_name_list FROM role_grantee_list granted_by
	| role_name_list FROM role_grantee_list granted_by
	| ALL ON ALL FROM non_role_grantee_list
	;
rev_grant_option :
	 /*empty*/
	| GRANT OPTION FOR
	;
non_role_grantee_list :
	 grantee
	| user_grantee
	| non_role_grantee_list ',' grantee
	| non_role_grantee_list ',' user_grantee
	;
grantee :
	 PROCEDURE symbol_procedure_name
	| FUNCTION symbol_UDF_name
	| PACKAGE symbol_package_name
	| TRIGGER symbol_trigger_name
	| VIEW symbol_view_name
	| ROLE symbol_role_name
	| SYSTEM PRIVILEGE valid_symbol_name
	;
user_grantee :
	 symbol_user_name
	| USER symbol_user_name
	| GROUP symbol_user_name
	;
role_name_list :
	 role_name
	| role_name_list ',' role_name
	;
role_name :
	 symbol_role_name
	| DEFAULT symbol_role_name
	;
role_grantee_list :
	 role_grantee
	| role_grantee_list ',' role_grantee
	;
role_grantee :
	 symbol_user_name
	| USER symbol_user_name
	| ROLE symbol_user_name
	;
declare :
	 DECLARE declare_clause
	;
declare_clause :
	 FILTER filter_decl_clause
	| EXTERNAL FUNCTION udf_decl_clause
	;
udf_decl_clause :
	 symbol_UDF_name arg_desc_list1 RETURNS return_value1 ENTRY_POINT utf_string MODULE_NAME utf_string
	;
udf_data_type :
	 simple_type
	| BLOB
	| CSTRING '(' pos_short_integer ')' charset_clause
	;
arg_desc_list1 :
	 /*empty*/
	| arg_desc_list
	| '(' arg_desc_list ')'
	;
arg_desc_list :
	 arg_desc
	| arg_desc_list ',' arg_desc
	;
arg_desc :
	 udf_data_type param_mechanism
	;
param_mechanism :
	 /*empty*/
	| BY DESCRIPTOR
	| BY SCALAR_ARRAY
	| NULL
	;
return_value1 :
	 return_value
	| '(' return_value ')'
	;
return_value :
	 udf_data_type return_mechanism
	| PARAMETER pos_short_integer
	;
return_mechanism :
	 /*empty*/
	| BY VALUE
	| BY DESCRIPTOR
	| FREE_IT
	| BY DESCRIPTOR FREE_IT
	;
filter_decl_clause :
	 symbol_filter_name INPUT_TYPE blob_filter_subtype OUTPUT_TYPE blob_filter_subtype ENTRY_POINT utf_string MODULE_NAME utf_string
	;
blob_filter_subtype :
	 symbol_blob_subtype_name
	| signed_short_integer
	;
create :
	 CREATE create_clause
	;
create_clause :
	 EXCEPTION exception_clause
	;
create_clause :
	 unique_opt order_direction INDEX symbol_index_name ON simple_table_name index_definition
	| FUNCTION function_clause
	| PROCEDURE procedure_clause
	| TABLE table_clause
	| GLOBAL TEMPORARY TABLE gtt_table_clause
	| TRIGGER trigger_clause
	| VIEW view_clause
	| GENERATOR generator_clause
	| SEQUENCE generator_clause
	| DATABASE db_clause
	| DOMAIN domain_clause
	| SHADOW shadow_clause
	| ROLE role_clause
	| COLLATION collation_clause
	| USER create_user_clause
	| PACKAGE package_clause
	| PACKAGE BODY package_body_clause
	| MAPPING create_map_clause
	| GLOBAL MAPPING create_map_clause
	;
recreate :
	 RECREATE recreate_clause
	;
recreate_clause :
	 PROCEDURE procedure_clause
	| FUNCTION function_clause
	| TABLE table_clause
	| GLOBAL TEMPORARY TABLE gtt_table_clause
	| VIEW view_clause
	| TRIGGER trigger_clause
	| PACKAGE package_clause
	| PACKAGE BODY package_body_clause
	| EXCEPTION exception_clause
	| GENERATOR generator_clause
	| SEQUENCE generator_clause
	| USER create_user_clause
	;
create_or_alter :
	 CREATE OR /*1L*/ ALTER /*14N*/ replace_clause
	;
replace_clause :
	 PROCEDURE replace_procedure_clause
	| FUNCTION replace_function_clause
	| TRIGGER replace_trigger_clause
	| PACKAGE replace_package_clause
	| VIEW replace_view_clause
	| EXCEPTION replace_exception_clause
	| GENERATOR replace_sequence_clause
	| SEQUENCE replace_sequence_clause
	| USER replace_user_clause
	| MAPPING replace_map_clause
	| GLOBAL MAPPING replace_map_clause
	;
exception_clause :
	 symbol_exception_name sql_string
	;
replace_exception_clause :
	 symbol_exception_name sql_string
	;
alter_exception_clause :
	 symbol_exception_name sql_string
	;
unique_opt :
	 /*empty*/
	| UNIQUE
	;
index_definition :
	 index_column_expr index_condition_opt
	;
index_column_expr :
	 column_list
	| column_parens
	| computed_by '(' value ')'
	;
index_condition_opt :
	 /*empty*/
	| WHERE search_condition
	;
shadow_clause :
	 pos_short_integer manual_auto conditional utf_string first_file_length sec_shadow_files
	;
manual_auto :
	 /*empty*/
	| MANUAL
	| AUTO
	;
conditional :
	 /*empty*/
	| CONDITIONAL
	;
first_file_length :
	 /*empty*/
	| LENGTH equals long_integer page_noise
	;
sec_shadow_files :
	 /*empty*/
	| db_file_list
	;
db_file_list :
	 db_file
	| db_file_list db_file
	;
domain_clause :
	 symbol_column_name as_opt data_type domain_default_opt domain_constraints_opt collate_clause
	;
domain_constraints_opt :
	 /*empty*/
	| domain_constraints
	;
domain_constraints :
	 domain_constraint
	| domain_constraints domain_constraint
	;
domain_constraint :
	 null_constraint
	| check_constraint
	;
as_opt :
	 /*empty*/
	| AS
	;
domain_default :
	 DEFAULT default_value
	;
domain_default_opt :
	 /*empty*/
	| domain_default
	;
null_constraint :
	 NOT /*3L*/ NULL
	;
check_constraint :
	 CHECK '(' search_condition ')'
	;
generator_clause :
	 symbol_generator_name create_sequence_options
	;
create_sequence_options :
	 /*empty*/
	| create_seq_option create_sequence_options
	;
create_seq_option :
	 start_with_opt
	| step_option
	;
start_with_opt :
	 START WITH sequence_value
	;
step_option :
	 INCREMENT by_noise signed_long_integer
	;
by_noise :
	 /*empty*/
	| BY
	;
replace_sequence_clause :
	 symbol_generator_name replace_sequence_options
	;
replace_sequence_options :
	 /*empty*/
	| replace_seq_option replace_sequence_options
	;
replace_seq_option :
	 RESTART
	| start_with_opt
	| step_option
	;
alter_sequence_clause :
	 symbol_generator_name alter_sequence_options
	;
alter_sequence_options :
	 /*empty*/
	| alter_seq_option alter_sequence_options
	;
alter_seq_option :
	 restart_option
	| step_option
	;
restart_option :
	 RESTART with_opt
	;
with_opt :
	 /*empty*/
	| WITH sequence_value
	;
set_generator_clause :
	 SET GENERATOR symbol_generator_name TO sequence_value
	;
sequence_value :
	 signed_long_integer
	| NUMBER64BIT
	| '-' /*6L*/ NUMBER64BIT
	| '-' /*6L*/ LIMIT64_INT
	;
role_clause :
	 symbol_role_name opt_system_privileges
	;
opt_system_privileges :
	 /*empty*/
	| set_system_privileges
	| drop_system_privileges
	;
set_system_privileges :
	 SET SYSTEM PRIVILEGES TO system_privileges_list
	;
drop_system_privileges :
	 DROP SYSTEM PRIVILEGES
	;
system_privileges_list :
	 system_privilege
	| system_privileges_list ',' system_privilege
	;
system_privilege :
	 valid_symbol_name
	;
collation_clause :
	 symbol_collation_name FOR symbol_character_set_name collation_sequence_definition collation_attribute_list_opt collation_specific_attribute_opt
	;
collation_sequence_definition :
	 /*empty*/
	| FROM symbol_collation_name
	| FROM EXTERNAL '(' utf_string ')'
	;
collation_attribute_list_opt :
	 /*empty*/
	| collation_attribute_list
	;
collation_attribute_list :
	 collation_attribute
	| collation_attribute_list collation_attribute
	;
collation_attribute :
	 collation_pad_attribute
	| collation_case_attribute
	| collation_accent_attribute
	;
collation_pad_attribute :
	 NO PAD
	| PAD SPACE
	;
collation_case_attribute :
	 CASE SENSITIVE
	| CASE INSENSITIVE
	;
collation_accent_attribute :
	 ACCENT SENSITIVE
	| ACCENT INSENSITIVE
	;
collation_specific_attribute_opt :
	 /*empty*/
	| utf_string
	;
alter_charset_clause :
	 symbol_character_set_name SET DEFAULT COLLATION symbol_collation_name
	;
alter_eds_conn_pool_clause :
	 SET SIZE unsigned_short_integer
	| SET LIFETIME unsigned_short_integer eds_pool_lifetime_mult
	| CLEAR sql_string
	| CLEAR ALL
	| CLEAR OLDEST
	;
eds_pool_lifetime_mult :
	 HOUR
	| MINUTE
	| SECOND
	;
db_clause :
	 db_name db_initial_desc1 db_rem_desc1
	;
equals :
	 /*empty*/
	| '=' /*4L*/
	;
db_name :
	 utf_string
	;
db_initial_desc1 :
	 /*empty*/
	| db_initial_desc
	;
db_initial_desc :
	 db_initial_option
	| db_initial_desc db_initial_option
	;
db_initial_option :
	 PAGE_SIZE equals NUMBER32BIT
	| USER symbol_user_name
	| USER utf_string
	| ROLE valid_symbol_name
	| ROLE utf_string
	| PASSWORD utf_string
	| SET NAMES utf_string
	| LENGTH equals long_integer page_noise
	;
db_rem_desc1 :
	 /*empty*/
	| db_rem_desc
	;
db_rem_desc :
	 db_rem_option
	| db_rem_desc db_rem_option
	;
db_rem_option :
	 db_file
	| DEFAULT CHARACTER SET symbol_character_set_name
	| DEFAULT CHARACTER SET symbol_character_set_name COLLATION symbol_collation_name
	| DIFFERENCE FILE utf_string
	;
db_file :
	 FILE utf_string file_desc1
	;
file_desc1 :
	 /*empty*/
	| file_desc
	;
file_desc :
	 file_clause
	| file_desc file_clause
	;
file_clause :
	 STARTING /*4L*/ file_clause_noise long_integer
	| LENGTH equals long_integer page_noise
	;
file_clause_noise :
	 /*empty*/
	| AT /*11L*/
	| AT /*11L*/ PAGE
	;
page_noise :
	 /*empty*/
	| PAGE
	| PAGES
	;
table_clause :
	 simple_table_name external_file '(' table_elements ')' table_attributes
	;
table_attributes :
	 /*empty*/
	| table_attribute table_attributes
	;
table_attribute :
	 sql_security_clause
	| publication_state
	;
sql_security_clause :
	 SQL SECURITY DEFINER
	| SQL SECURITY INVOKER
	;
sql_security_clause_opt :
	 /*empty*/
	| sql_security_clause
	;
publication_state :
	 ENABLE PUBLICATION
	| DISABLE PUBLICATION
	;
gtt_table_clause :
	 simple_table_name '(' table_elements ')' gtt_ops
	;
gtt_ops :
	 gtt_op
	| gtt_ops ',' gtt_op
	;
gtt_op :
	 /*empty*/
	| sql_security_clause_opt
	| ON COMMIT DELETE ROWS
	| ON COMMIT PRESERVE ROWS
	;
external_file :
	 /*empty*/
	| EXTERNAL FILE utf_string
	| EXTERNAL utf_string
	;
table_elements :
	 table_element
	| table_elements ',' table_element
	;
table_element :
	 column_def
	| table_constraint_definition
	;
column_def :
	 symbol_column_name data_type_or_domain domain_default_opt column_constraint_clause collate_clause
	;
column_def :
	 symbol_column_name data_type_or_domain identity_clause column_constraint_clause collate_clause
	| symbol_column_name non_array_type def_computed
	| symbol_column_name def_computed
	;
identity_clause :
	 GENERATED identity_clause_type AS IDENTITY identity_clause_options_opt
	;
identity_clause_type :
	 BY DEFAULT
	| ALWAYS
	;
identity_clause_options_opt :
	 /*empty*/
	| '(' identity_clause_options ')'
	;
identity_clause_options :
	 identity_clause_options identity_clause_option
	| identity_clause_option
	;
identity_clause_option :
	 START WITH sequence_value
	| INCREMENT by_noise signed_long_integer
	;
def_computed :
	 computed_clause '(' value ')'
	;
computed_clause :
	 computed_by
	| generated_always_clause
	;
generated_always_clause :
	 GENERATED ALWAYS AS
	;
computed_by :
	 COMPUTED BY
	| COMPUTED
	;
data_type_or_domain :
	 data_type
	| symbol_column_name
	;
collate_clause :
	 /*empty*/
	| COLLATE /*10L*/ symbol_collation_name
	;
data_type_descriptor :
	 data_type
	| TYPE OF symbol_column_name
	| TYPE OF COLUMN /*15N*/ symbol_column_name '.' symbol_column_name
	| symbol_column_name
	;
default_value :
	 constant
	| current_user
	| current_role
	| internal_info
	| null_value
	| datetime_value_expression
	;
column_constraint_clause :
	 /*empty*/
	| column_constraint_list
	;
column_constraint_list :
	 column_constraint_def
	| column_constraint_list column_constraint_def
	;
column_constraint_def :
	 constraint_name_opt column_constraint
	;
column_constraint :
	 null_constraint
	| check_constraint
	| REFERENCES symbol_table_name column_parens_opt referential_trigger_action constraint_index_opt
	| UNIQUE constraint_index_opt
	| PRIMARY KEY constraint_index_opt
	;
table_constraint_definition :
	 constraint_name_opt table_constraint
	;
constraint_name_opt :
	 /*empty*/
	| CONSTRAINT symbol_constraint_name
	;
table_constraint :
	 UNIQUE column_parens constraint_index_opt
	| PRIMARY KEY column_parens constraint_index_opt
	| FOREIGN KEY column_parens REFERENCES symbol_table_name column_parens_opt referential_trigger_action constraint_index_opt
	| check_constraint
	;
constraint_index_opt :
	 /*empty*/
	| USING order_direction INDEX symbol_index_name
	;
referential_trigger_action :
	 /*empty*/
	| update_rule
	| delete_rule
	| delete_rule update_rule
	| update_rule delete_rule
	;
update_rule :
	 ON UPDATE referential_action
	;
delete_rule :
	 ON DELETE referential_action
	;
referential_action :
	 CASCADE
	| SET DEFAULT
	| SET NULL
	| NO ACTION
	;
procedure_clause :
	 psql_procedure_clause
	| external_procedure_clause
	;
psql_procedure_clause :
	 procedure_clause_start sql_security_clause_opt AS local_declarations_opt full_proc_block
	;
external_procedure_clause :
	 procedure_clause_start external_clause external_body_clause_opt
	;
procedure_clause_start :
	 symbol_procedure_name input_parameters output_parameters
	;
alter_procedure_clause :
	 procedure_clause
	;
replace_procedure_clause :
	 procedure_clause
	;
input_parameters :
	 /*empty*/
	| '(' ')'
	| '(' input_proc_parameters ')'
	;
output_parameters :
	 /*empty*/
	| RETURNS '(' output_proc_parameters ')'
	;
input_proc_parameters :
	 input_proc_parameter
	| input_proc_parameters ',' input_proc_parameter
	;
input_proc_parameter :
	 column_domain_or_non_array_type collate_clause default_par_opt
	;
output_proc_parameters :
	 output_proc_parameter
	| output_proc_parameters ',' output_proc_parameter
	;
output_proc_parameter :
	 column_domain_or_non_array_type collate_clause
	;
column_domain_or_non_array_type :
	 symbol_column_name domain_or_non_array_type
	;
default_par_opt :
	 /*empty*/
	| DEFAULT default_value
	| '=' /*4L*/ default_value
	;
function_clause :
	 psql_function_clause
	| external_function_clause
	;
change_opt_function_clause :
	 change_deterministic_opt_function_clause
	;
psql_function_clause :
	 function_clause_start sql_security_clause_opt AS local_declarations_opt full_proc_block
	;
external_function_clause :
	 function_clause_start external_clause external_body_clause_opt
	;
function_clause_start :
	 symbol_UDF_name input_parameters RETURNS domain_or_non_array_type collate_clause deterministic_clause_opt
	;
change_deterministic_opt_function_clause :
	 symbol_UDF_name deterministic_clause
	;
deterministic_clause :
	 NOT /*3L*/ DETERMINISTIC
	| DETERMINISTIC
	;
deterministic_clause_opt :
	 /*empty*/
	| deterministic_clause
	;
external_clause :
	 EXTERNAL NAME utf_string ENGINE valid_symbol_name
	| EXTERNAL ENGINE valid_symbol_name
	;
external_body_clause_opt :
	 /*empty*/
	| AS utf_string
	;
alter_function_clause :
	 function_clause
	| change_opt_function_clause
	;
replace_function_clause :
	 function_clause
	;
package_clause :
	 symbol_package_name sql_security_clause_opt AS BEGIN package_items_opt END
	;
package_items_opt :
	 package_items
	| /*empty*/
	;
package_items :
	 package_item
	| package_items package_item
	;
package_item :
	 FUNCTION function_clause_start ';'
	| PROCEDURE procedure_clause_start ';'
	;
alter_package_clause :
	 package_clause
	;
replace_package_clause :
	 package_clause
	;
package_body_clause :
	 symbol_package_name AS BEGIN package_items package_body_items_opt END
	| symbol_package_name AS BEGIN package_body_items_opt END
	;
package_body_items_opt :
	 /*empty*/
	| package_body_items
	;
package_body_items :
	 package_body_item
	| package_body_items package_body_item
	;
package_body_item :
	 FUNCTION psql_function_clause
	| FUNCTION external_function_clause ';'
	| PROCEDURE psql_procedure_clause
	| PROCEDURE external_procedure_clause ';'
	;
local_declarations_opt :
	 local_forward_declarations_opt local_nonforward_declarations_opt
	;
local_forward_declarations_opt :
	 /*empty*/
	| local_forward_declarations
	;
local_forward_declarations :
	 local_forward_declaration
	| local_forward_declarations local_forward_declaration
	;
local_forward_declaration :
	 local_declaration_subproc_start ';'
	| local_declaration_subfunc_start ';'
	;
local_nonforward_declarations_opt :
	 /*empty*/
	| local_nonforward_declarations
	;
local_nonforward_declarations :
	 local_nonforward_declaration
	| local_nonforward_declarations local_nonforward_declaration
	;
local_nonforward_declaration :
	 DECLARE var_decl_opt local_declaration_item ';'
	| local_declaration_subproc_start AS local_declarations_opt full_proc_block
	| local_declaration_subfunc_start AS local_declarations_opt full_proc_block
	;
local_declaration_subproc_start :
	 DECLARE PROCEDURE symbol_procedure_name input_parameters output_parameters
	;
local_declaration_subfunc_start :
	 DECLARE FUNCTION symbol_UDF_name input_parameters RETURNS domain_or_non_array_type collate_clause deterministic_clause_opt
	;
local_declaration_item :
	 var_declaration_item
	| cursor_declaration_item
	;
var_declaration_item :
	 column_domain_or_non_array_type collate_clause var_declaration_initializer
	;
var_declaration_initializer :
	 /*empty*/
	| DEFAULT value
	| '=' /*4L*/ value
	;
var_decl_opt :
	 /*empty*/
	| VARIABLE
	;
cursor_declaration_item :
	 symbol_cursor_name scroll_opt CURSOR FOR '(' select ')'
	;
scroll_opt :
	 /*empty*/
	| NO SCROLL
	| SCROLL
	;
proc_block :
	 proc_statement
	| full_proc_block
	;
full_proc_block :
	 BEGIN full_proc_block_body END
	;
full_proc_block_body :
	 /*empty*/
	| proc_statements
	| proc_statements excp_hndl_statements
	;
proc_statements :
	 proc_block
	| proc_statements proc_block
	;
proc_statement :
	 simple_proc_statement ';'
	| complex_proc_statement
	;
simple_proc_statement :
	 assignment_statement
	| insert
	| merge
	| update
	| update_or_insert
	| delete
	| singleton_select
	| exec_procedure
	| call
	| exec_sql
	| exec_into
	| exec_function
	| excp_statement
	| raise_statement
	| post_event
	| cursor_statement
	| breakleave
	| continue
	| SUSPEND
	| EXIT
	| RETURN value
	| mng_statement
	;
assignment_statement :
	 assignment
	| ':' assignment
	;
complex_proc_statement :
	 in_autonomous_transaction
	| if_then_else
	| while
	| for_select
	| for_exec_into
	;
in_autonomous_transaction :
	 IN /*4L*/ AUTONOMOUS TRANSACTION DO proc_block
	;
excp_statement :
	 EXCEPTION symbol_exception_name
	| EXCEPTION symbol_exception_name value
	| EXCEPTION symbol_exception_name USING '(' value_list ')'
	;
raise_statement :
	 EXCEPTION
	;
for_select :
	 label_def_opt FOR select for_select_into_cursor DO proc_block
	;
for_select_into_cursor :
	 into_variable_list cursor_def_opt
	| into_variable_list_opt cursor_def
	;
into_variable_list_opt :
	 /*empty*/
	| into_variable_list
	;
into_variable_list :
	 INTO variable_list
	;
exec_sql :
	 EXECUTE STATEMENT exec_stmt_inputs exec_stmt_options
	;
exec_into :
	 exec_sql INTO variable_list
	;
for_exec_into :
	 label_def_opt FOR exec_into DO proc_block
	;
exec_stmt_inputs :
	 value
	| '(' value ')' '(' named_params_list ')'
	| '(' value ')' '(' not_named_params_list ')'
	;
named_params_list :
	 named_param
	| named_params_list ',' named_param
	;
named_param :
	 symbol_variable_name BIND_PARAM value
	| EXCESS symbol_variable_name BIND_PARAM value
	;
not_named_params_list :
	 not_named_param
	| not_named_params_list ',' not_named_param
	;
not_named_param :
	 value
	;
exec_stmt_options :
	 /*empty*/
	| exec_stmt_options_list
	;
exec_stmt_options_list :
	 exec_stmt_options_list exec_stmt_option
	| exec_stmt_option
	;
exec_stmt_option :
	 ON EXTERNAL DATA SOURCE value
	| ON EXTERNAL value
	| AS USER value
	| PASSWORD value
	| ROLE value
	| WITH AUTONOMOUS TRANSACTION
	| WITH COMMON TRANSACTION
	| WITH CALLER PRIVILEGES
	;
if_then_else :
	 IF '(' search_condition ')' THEN /*12N*/ proc_block ELSE /*13N*/ proc_block
	| IF '(' search_condition ')' THEN /*12N*/ proc_block
	;
post_event :
	 POST_EVENT value event_argument_opt
	;
event_argument_opt :
	 /*empty*/
	;
singleton_select :
	 select INTO variable_list
	;
variable :
	 ':' symbol_variable_name
	;
variable_list :
	 variable
	| column_name
	| variable_list ',' column_name
	| variable_list ',' variable
	;
while :
	 label_def_opt WHILE '(' search_condition ')' DO proc_block
	;
label_def_opt :
	 /*empty*/
	| symbol_label_name ':'
	;
breakleave :
	 BREAK
	| LEAVE label_use_opt
	;
continue :
	 CONTINUE label_use_opt
	;
label_use_opt :
	 /*empty*/
	| symbol_label_name
	;
cursor_def_opt :
	 /*empty*/
	| cursor_def
	;
cursor_def :
	 AS CURSOR symbol_cursor_name
	;
excp_hndl_statements :
	 excp_hndl_statement
	| excp_hndl_statements excp_hndl_statement
	;
excp_hndl_statement :
	 WHEN errors DO proc_block
	;
errors :
	 err
	| errors ',' err
	;
err :
	 SQLCODE signed_short_integer
	| SQLSTATE STRING
	| GDSCODE symbol_gdscode_name
	| EXCEPTION symbol_exception_name
	| ANY
	;
cursor_statement :
	 open_cursor
	| fetch_cursor
	| close_cursor
	;
open_cursor :
	 OPEN symbol_cursor_name
	;
close_cursor :
	 CLOSE symbol_cursor_name
	;
fetch_cursor :
	 FETCH fetch_scroll FROM symbol_cursor_name into_variable_list_opt
	| FETCH symbol_cursor_name into_variable_list_opt
	;
fetch_scroll :
	 FIRST
	| LAST
	| PRIOR
	| NEXT
	| ABSOLUTE value
	| RELATIVE value
	;
exec_procedure :
	 EXECUTE PROCEDURE symbol_procedure_name proc_inputs proc_outputs_opt
	| EXECUTE PROCEDURE symbol_package_name '.' symbol_procedure_name proc_inputs proc_outputs_opt
	;
proc_inputs :
	 /*empty*/
	| argument_list
	| '(' argument_list ')'
	;
proc_outputs_opt :
	 /*empty*/
	| RETURNING_VALUES variable_list
	| RETURNING_VALUES '(' variable_list ')'
	;
call :
	 CALL symbol_procedure_name '(' argument_list_opt ')'
	| CALL symbol_package_name '.' symbol_procedure_name '(' argument_list_opt ')' into_variable_list_opt
	;
exec_block :
	 EXECUTE BLOCK block_input_params output_parameters AS local_declarations_opt full_proc_block
	;
block_input_params :
	 /*empty*/
	| '(' block_parameters ')'
	;
block_parameters :
	 block_parameter
	| block_parameters ',' block_parameter
	;
block_parameter :
	 column_domain_or_non_array_type collate_clause '=' /*4L*/ parameter
	;
view_clause :
	 simple_table_name column_parens_opt AS select_expr check_opt
	;
replace_view_clause :
	 view_clause
	;
alter_view_clause :
	 view_clause
	;
check_opt :
	 /*empty*/
	| WITH CHECK OPTION
	;
trigger_clause :
	 create_trigger_start trg_sql_security_clause AS local_declarations_opt full_proc_block
	| create_trigger_start external_clause external_body_clause_opt
	;
create_trigger_start :
	 symbol_trigger_name create_trigger_common
	;
create_trigger_common :
	 trigger_active trigger_type trigger_position
	| FOR symbol_table_name trigger_active table_trigger_type trigger_position
	;
replace_trigger_clause :
	 trigger_clause
	;
trigger_active :
	 ACTIVE
	| INACTIVE
	| /*empty*/
	;
trigger_type :
	 table_trigger_type trigger_position ON symbol_table_name
	| ON trigger_db_type
	| trigger_type_prefix trigger_ddl_type
	;
table_trigger_type :
	 trigger_type_prefix trigger_type_suffix
	;
trigger_db_type :
	 CONNECT
	| DISCONNECT
	| TRANSACTION START
	| TRANSACTION COMMIT
	| TRANSACTION ROLLBACK
	;
trigger_ddl_type :
	 trigger_ddl_type_items
	| ANY DDL STATEMENT
	;
trigger_ddl_type_items :
	 CREATE TABLE
	| ALTER /*14N*/ TABLE
	| DROP TABLE
	| CREATE PROCEDURE
	| ALTER /*14N*/ PROCEDURE
	| DROP PROCEDURE
	| CREATE FUNCTION
	| ALTER /*14N*/ FUNCTION
	| DROP FUNCTION
	| CREATE TRIGGER
	| ALTER /*14N*/ TRIGGER
	| DROP TRIGGER
	| CREATE EXCEPTION
	| ALTER /*14N*/ EXCEPTION
	| DROP EXCEPTION
	| CREATE VIEW
	| ALTER /*14N*/ VIEW
	| DROP VIEW
	| CREATE DOMAIN
	| ALTER /*14N*/ DOMAIN
	| DROP DOMAIN
	| CREATE ROLE
	| ALTER /*14N*/ ROLE
	| DROP ROLE
	| CREATE SEQUENCE
	| ALTER /*14N*/ SEQUENCE
	| DROP SEQUENCE
	| CREATE USER
	| ALTER /*14N*/ USER
	| DROP USER
	| CREATE INDEX
	| ALTER /*14N*/ INDEX
	| DROP INDEX
	| CREATE COLLATION
	| DROP COLLATION
	| ALTER /*14N*/ CHARACTER SET
	| CREATE PACKAGE
	| ALTER /*14N*/ PACKAGE
	| DROP PACKAGE
	| CREATE PACKAGE BODY
	| DROP PACKAGE BODY
	| CREATE MAPPING
	| ALTER /*14N*/ MAPPING
	| DROP MAPPING
	| trigger_ddl_type OR /*1L*/ trigger_ddl_type
	;
trigger_type_prefix :
	 BEFORE
	| AFTER
	;
trigger_type_suffix :
	 INSERT
	| UPDATE
	| DELETE
	| INSERT OR /*1L*/ UPDATE
	| INSERT OR /*1L*/ DELETE
	| UPDATE OR /*1L*/ INSERT
	| UPDATE OR /*1L*/ DELETE
	| DELETE OR /*1L*/ INSERT
	| DELETE OR /*1L*/ UPDATE
	| INSERT OR /*1L*/ UPDATE OR /*1L*/ DELETE
	| INSERT OR /*1L*/ DELETE OR /*1L*/ UPDATE
	| UPDATE OR /*1L*/ INSERT OR /*1L*/ DELETE
	| UPDATE OR /*1L*/ DELETE OR /*1L*/ INSERT
	| DELETE OR /*1L*/ INSERT OR /*1L*/ UPDATE
	| DELETE OR /*1L*/ UPDATE OR /*1L*/ INSERT
	;
trigger_position :
	 /*empty*/
	| POSITION nonneg_short_integer
	;
alter :
	 ALTER /*14N*/ alter_clause
	| set_generator_clause
	;
alter_clause :
	 EXCEPTION alter_exception_clause
	;
alter_clause :
	 TABLE simple_table_name alter_ops
	| VIEW alter_view_clause
	| TRIGGER alter_trigger_clause
	| PROCEDURE alter_procedure_clause
	| PACKAGE alter_package_clause
	;
alter_clause :
	 DATABASE alter_db
	| DOMAIN alter_domain
	| INDEX alter_index_clause
	| EXTERNAL FUNCTION alter_udf_clause
	| FUNCTION alter_function_clause
	| ROLE alter_role_clause
	| USER alter_user_clause
	| CURRENT USER alter_cur_user_clause
	| CHARACTER SET alter_charset_clause
	| GENERATOR alter_sequence_clause
	| SEQUENCE alter_sequence_clause
	| MAPPING alter_map_clause
	| GLOBAL MAPPING alter_map_clause
	| EXTERNAL CONNECTIONS POOL alter_eds_conn_pool_clause
	;
alter_domain :
	 keyword_or_column alter_domain_ops
	;
alter_domain_ops :
	 alter_domain_op
	| alter_domain_ops alter_domain_op
	;
alter_domain_op :
	 SET domain_default
	| ADD CONSTRAINT check_constraint
	| ADD check_constraint
	| DROP DEFAULT
	| DROP CONSTRAINT
	| DROP NOT /*3L*/ NULL
	| SET NOT /*3L*/ NULL
	| TO symbol_column_name
	| TYPE non_array_type
	;
alter_ops :
	 alter_op
	| alter_ops ',' alter_op
	;
alter_op :
	 DROP symbol_column_name drop_behaviour
	| DROP CONSTRAINT symbol_constraint_name
	| ADD column_def
	| ADD table_constraint_definition
	| col_opt alter_column_name POSITION pos_short_integer
	| col_opt alter_column_name TO symbol_column_name
	| col_opt alter_column_name DROP NOT /*3L*/ NULL
	| col_opt alter_column_name SET NOT /*3L*/ NULL
	| col_opt symbol_column_name TYPE alter_data_type_or_domain
	| col_opt symbol_column_name TYPE non_array_type def_computed
	| col_opt symbol_column_name def_computed
	| col_opt symbol_column_name SET domain_default
	| col_opt symbol_column_name DROP DEFAULT
	;
alter_op :
	 col_opt symbol_column_name alter_identity_clause_spec
	| col_opt symbol_column_name DROP IDENTITY
	| ALTER /*14N*/ SQL SECURITY DEFINER
	| ALTER /*14N*/ SQL SECURITY INVOKER
	| DROP SQL SECURITY
	| ENABLE PUBLICATION
	| DISABLE PUBLICATION
	;
alter_column_name :
	 keyword_or_column
	;
keyword_or_column :
	 valid_symbol_name
	| ADMIN
	| COLUMN /*15N*/
	| EXTRACT
	| YEAR
	| MONTH
	| DAY
	| HOUR
	| MINUTE
	| SECOND
	| TIME
	| TIMESTAMP
	| CURRENT_DATE
	| CURRENT_TIME
	| CURRENT_TIMESTAMP
	| CURRENT_USER
	| CURRENT_ROLE
	| RECREATE
	| CURRENT_CONNECTION
	| CURRENT_TRANSACTION
	| BIGINT
	| CASE
	| RELEASE
	| ROW_COUNT
	| SAVEPOINT
	| OPEN
	| CLOSE
	| FETCH
	| ROWS
	| USING
	| CROSS
	| BIT_LENGTH
	| BOTH
	| CHAR_LENGTH
	| CHARACTER_LENGTH
	| COMMENT
	| LEADING
	| LOWER
	| OCTET_LENGTH
	| TRAILING
	| TRIM
	| CONNECT
	| DISCONNECT
	| GLOBAL
	| INSENSITIVE
	| RECURSIVE
	| SENSITIVE
	| START
	| SIMILAR /*4L*/
	| BOOLEAN
	| CORR
	| COVAR_POP
	| COVAR_SAMP
	| DELETING
	| DETERMINISTIC
	| FALSE
	| INSERTING
	| OFFSET
	| OVER
	| REGR_AVGX
	| REGR_AVGY
	| REGR_COUNT
	| REGR_INTERCEPT
	| REGR_R2
	| REGR_SLOPE
	| REGR_SXX
	| REGR_SXY
	| REGR_SYY
	| RETURN
	| ROW
	| SCROLL
	| SQLSTATE
	| STDDEV_SAMP
	| STDDEV_POP
	| TRUE
	| UNKNOWN
	| UPDATING
	| VAR_SAMP
	| VAR_POP
	| BINARY
	| DECFLOAT
	| INT128
	| LATERAL
	| LOCAL
	| LOCALTIME
	| LOCALTIMESTAMP
	| PUBLICATION
	| RESETTING
	| TIMEZONE_HOUR
	| TIMEZONE_MINUTE
	| UNBOUNDED
	| VARBINARY
	| WINDOW
	| WITHOUT
	| CALL
	;
col_opt :
	 ALTER /*14N*/
	| ALTER /*14N*/ COLUMN /*15N*/
	;
alter_data_type_or_domain :
	 non_array_type
	| symbol_column_name
	;
alter_identity_clause_spec :
	 alter_identity_clause_generation alter_identity_clause_options_opt
	| alter_identity_clause_options
	;
alter_identity_clause_generation :
	 SET GENERATED ALWAYS
	| SET GENERATED BY DEFAULT
	;
alter_identity_clause_options_opt :
	 /*empty*/
	| alter_identity_clause_options
	;
alter_identity_clause_options :
	 alter_identity_clause_options alter_identity_clause_option
	| alter_identity_clause_option
	;
alter_identity_clause_option :
	 RESTART with_opt
	| SET INCREMENT by_noise signed_long_integer
	;
drop_behaviour :
	 /*empty*/
	| RESTRICT
	| CASCADE
	;
alter_index_clause :
	 symbol_index_name ACTIVE
	| symbol_index_name INACTIVE
	;
alter_udf_clause :
	 symbol_UDF_name entry_op module_op
	;
entry_op :
	 /*empty*/
	| ENTRY_POINT utf_string
	;
module_op :
	 /*empty*/
	| MODULE_NAME utf_string
	;
alter_role_2X_compatibility :
	 symbol_role_name alter_role_enable AUTO ADMIN MAPPING
	;
alter_role_clause :
	 role_clause
	| alter_role_2X_compatibility
	;
alter_role_enable :
	 SET
	| DROP
	;
alter_db :
	 db_alter_clause
	| alter_db db_alter_clause
	;
db_alter_clause :
	 ADD db_file_list
	| ADD DIFFERENCE FILE utf_string
	| DROP DIFFERENCE FILE
	| BEGIN BACKUP
	| END BACKUP
	| SET DEFAULT CHARACTER SET symbol_character_set_name
	| ENCRYPT WITH valid_symbol_name crypt_key_clause
	| DECRYPT
	| SET LINGER TO long_integer
	| DROP LINGER
	| SET DEFAULT sql_security_clause
	| ENABLE PUBLICATION
	| DISABLE PUBLICATION
	| INCLUDE pub_table_filter TO PUBLICATION
	| EXCLUDE pub_table_filter FROM PUBLICATION
	;
crypt_key_clause :
	 /*empty*/
	| KEY valid_symbol_name
	;
pub_table_filter :
	 ALL
	| TABLE pub_table_list
	;
pub_table_list :
	 pub_table_clause
	| pub_table_list ',' pub_table_clause
	;
pub_table_clause :
	 symbol_table_name
	;
alter_trigger_clause :
	 symbol_trigger_name trigger_active trigger_type_opt trigger_position trg_sql_security_clause AS local_declarations_opt full_proc_block
	| symbol_trigger_name trigger_active trigger_type_opt trigger_position external_clause external_body_clause_opt
	| symbol_trigger_name trigger_active trigger_type_opt trigger_position trg_sql_security_clause
	;
trigger_type_opt :
	 trigger_type_prefix trigger_type_suffix
	| /*empty*/
	;
trg_sql_security_clause :
	 /*empty*/
	| SQL SECURITY DEFINER
	| SQL SECURITY INVOKER
	| DROP SQL SECURITY
	;
drop :
	 DROP drop_clause
	;
drop_clause :
	 EXCEPTION symbol_exception_name
	| INDEX symbol_index_name
	| PROCEDURE symbol_procedure_name
	| TABLE symbol_table_name
	| TRIGGER symbol_trigger_name
	| VIEW symbol_view_name
	| FILTER symbol_filter_name
	| DOMAIN symbol_domain_name
	| EXTERNAL FUNCTION symbol_UDF_name
	| FUNCTION symbol_UDF_name
	| SHADOW pos_short_integer opt_no_file_delete
	| ROLE symbol_role_name
	| GENERATOR symbol_generator_name
	| SEQUENCE symbol_generator_name
	| COLLATION symbol_collation_name
	| USER symbol_user_name USING PLUGIN valid_symbol_name
	| USER symbol_user_name
	| PACKAGE symbol_package_name
	| PACKAGE BODY symbol_package_name
	| MAPPING drop_map_clause
	| GLOBAL MAPPING drop_map_clause
	;
opt_no_file_delete :
	 /*empty*/
	| PRESERVE FILE
	| DELETE FILE
	;
data_type :
	 non_array_type
	| array_type
	;
domain_or_non_array_type :
	 domain_or_non_array_type_name
	| domain_or_non_array_type_name NOT /*3L*/ NULL
	;
domain_or_non_array_type_name :
	 non_array_type
	| domain_type
	;
domain_type :
	 TYPE OF symbol_column_name
	| TYPE OF COLUMN /*15N*/ symbol_column_name '.' symbol_column_name
	| symbol_column_name
	;
non_array_type :
	 simple_type
	| blob_type
	;
array_type :
	 non_charset_simple_type '[' array_spec ']'
	| character_type '[' array_spec ']' charset_clause
	;
array_spec :
	 array_range
	| array_spec ',' array_range
	;
array_range :
	 signed_long_integer
	| signed_long_integer ':' signed_long_integer
	;
simple_type :
	 non_charset_simple_type
	| character_type charset_clause
	;
non_charset_simple_type :
	 national_character_type
	| binary_character_type
	| numeric_type
	| float_type
	| decfloat_type
	| date_time_type
	| BIGINT
	| INT128
	| integer_keyword
	| SMALLINT
	| BOOLEAN
	;
integer_keyword :
	 INTEGER
	| INT
	;
without_time_zone_opt :
	 /*empty*/
	| WITHOUT TIME ZONE
	;
blob_type :
	 BLOB blob_subtype blob_segsize charset_clause
	| BLOB '(' unsigned_short_integer ')'
	| BLOB '(' unsigned_short_integer ',' signed_short_integer ')'
	| BLOB '(' ',' signed_short_integer ')'
	;
blob_segsize :
	 /*empty*/
	| SEGMENT SIZE unsigned_short_integer
	;
blob_subtype :
	 /*empty*/
	| SUB_TYPE signed_short_integer
	| SUB_TYPE symbol_blob_subtype_name
	;
charset_clause :
	 /*empty*/
	| CHARACTER SET symbol_character_set_name
	;
national_character_type :
	 national_character_keyword '(' pos_short_integer ')'
	| national_character_keyword
	| national_character_keyword VARYING '(' pos_short_integer ')'
	;
binary_character_type :
	 binary_character_keyword '(' pos_short_integer ')'
	| binary_character_keyword
	| varbinary_character_keyword '(' pos_short_integer ')'
	;
character_type :
	 character_keyword '(' pos_short_integer ')'
	| character_keyword
	| varying_keyword '(' pos_short_integer ')'
	;
varying_keyword :
	 VARCHAR
	| CHARACTER VARYING
	| CHAR VARYING
	;
character_keyword :
	 CHARACTER
	| CHAR
	;
national_character_keyword :
	 NCHAR
	| NATIONAL CHARACTER
	| NATIONAL CHAR
	;
binary_character_keyword :
	 BINARY
	;
varbinary_character_keyword :
	 VARBINARY
	| BINARY VARYING
	;
decfloat_type :
	 DECFLOAT precision_opt_nz
	;
numeric_type :
	 NUMERIC prec_scale
	| decimal_keyword prec_scale
	;
prec_scale :
	 /*empty*/
	| '(' signed_long_integer ')'
	| '(' signed_long_integer ',' signed_long_integer ')'
	;
decimal_keyword :
	 DECIMAL
	| DEC
	;
float_type :
	 FLOAT precision_opt_nz
	| LONG FLOAT precision_opt_nz
	| REAL
	| DOUBLE PRECISION
	;
precision_opt_nz :
	 /*empty*/
	| '(' pos_short_integer ')'
	;
savepoint :
	 set_savepoint
	| release_savepoint
	| undo_savepoint
	;
set_savepoint :
	 SAVEPOINT symbol_savepoint_name
	;
release_savepoint :
	 RELEASE SAVEPOINT symbol_savepoint_name
	| RELEASE SAVEPOINT symbol_savepoint_name ONLY
	;
undo_savepoint :
	 ROLLBACK optional_work TO optional_savepoint symbol_savepoint_name
	;
optional_savepoint :
	 /*empty*/
	| SAVEPOINT
	;
commit :
	 COMMIT optional_work optional_retain
	;
rollback :
	 ROLLBACK optional_work optional_retain
	;
optional_work :
	 /*empty*/
	| WORK
	;
optional_retain :
	 /*empty*/
	| RETAIN opt_snapshot
	;
opt_snapshot :
	 /*empty*/
	| SNAPSHOT
	;
set_transaction :
	 SET TRANSACTION tran_option_list_opt
	;
session_reset :
	 ALTER /*14N*/ SESSION RESET
	;
set_role :
	 SET ROLE valid_symbol_name
	| SET TRUSTED ROLE
	;
set_debug_option :
	 SET DEBUG OPTION valid_symbol_name '=' /*4L*/ constant
	;
set_decfloat_round :
	 SET DECFLOAT ROUND valid_symbol_name
	;
set_decfloat_traps :
	 SET DECFLOAT TRAPS TO decfloat_traps_list_opt
	;
set_bind :
	 SET BIND OF set_bind_from TO set_bind_to
	;
set_bind_from :
	 bind_type
	| TIME ZONE
	;
bind_type :
	 non_array_type
	| varying_keyword
	;
set_bind_to :
	 bind_type
	| LEGACY
	| NATIVE
	| EXTENDED
	| EXTENDED TIME WITH TIME ZONE
	| EXTENDED TIMESTAMP WITH TIME ZONE
	;
decfloat_traps_list_opt :
	 /*empty*/
	| decfloat_traps_list
	;
decfloat_traps_list :
	 decfloat_trap
	| decfloat_traps_list ',' decfloat_trap
	;
decfloat_trap :
	 valid_symbol_name
	;
set_optimize :
	 SET OPTIMIZE optimize_mode
	| SET OPTIMIZE TO DEFAULT
	;
session_statement :
	 SET SESSION IDLE TIMEOUT long_integer timepart_sesion_idle_tout
	| SET STATEMENT TIMEOUT long_integer timepart_ses_stmt_tout
	;
timepart_sesion_idle_tout :
	 /*empty*/
	| HOUR
	| MINUTE
	| SECOND
	;
timepart_ses_stmt_tout :
	 /*empty*/
	| HOUR
	| MINUTE
	| SECOND
	| MILLISECOND
	;
set_time_zone :
	 SET TIME ZONE set_time_zone_option
	;
set_time_zone_option :
	 sql_string
	| LOCAL
	;
tran_option_list_opt :
	 /*empty*/
	| tran_option_list
	;
tran_option_list :
	 tran_option
	| tran_option_list tran_option
	;
tran_option :
	 READ ONLY
	| READ WRITE
	| WAIT
	| NO WAIT
	| isolation_mode
	| NO AUTO UNDO
	| IGNORE LIMBO
	| RESTART REQUESTS
	| AUTO COMMIT
	| LOCK TIMEOUT nonneg_short_integer
	;
tran_option :
	 RESERVING restr_list
	;
isolation_mode :
	 ISOLATION LEVEL iso_mode
	| iso_mode
	;
iso_mode :
	 snap_shot
	| READ UNCOMMITTED version_mode
	| READ COMMITTED version_mode
	;
snap_shot :
	 SNAPSHOT
	| SNAPSHOT AT /*11L*/ NUMBER snapshot_number
	| SNAPSHOT TABLE
	| SNAPSHOT TABLE STABILITY
	;
snapshot_number :
	 NUMBER32BIT
	| NUMBER64BIT
	;
version_mode :
	 /*empty*/
	| VERSION
	| NO VERSION
	| READ CONSISTENCY
	;
lock_type :
	 /*empty*/
	| SHARED
	| PROTECTED
	;
lock_mode :
	 READ
	| WRITE
	;
restr_list :
	 restr_option
	| restr_list ',' restr_option
	;
restr_option :
	 table_list table_lock
	;
table_lock :
	 /*empty*/
	| FOR lock_type lock_mode
	;
table_list :
	 symbol_table_name
	| table_list ',' symbol_table_name
	;
set_statistics :
	 SET STATISTICS INDEX symbol_index_name
	;
comment :
	 COMMENT ON ddl_type0 IS /*5L*/ ddl_desc
	| COMMENT ON ddl_type1 symbol_ddl_name IS /*5L*/ ddl_desc
	| COMMENT ON ddl_type2 symbol_ddl_name ddl_subname IS /*5L*/ ddl_desc
	| COMMENT ON ddl_type3 ddl_qualified_name ddl_subname IS /*5L*/ ddl_desc
	| COMMENT ON ddl_type4 ddl_qualified_name IS /*5L*/ ddl_desc
	| comment_on_user
	| comment_on_mapping
	;
comment_on_user :
	 COMMENT ON USER symbol_user_name opt_use_plugin IS /*5L*/ ddl_desc
	;
opt_use_plugin :
	 /*empty*/
	| use_plugin
	;
ddl_type0 :
	 DATABASE
	;
ddl_type1 :
	 DOMAIN
	| TABLE
	| VIEW
	| TRIGGER
	| FILTER
	| EXCEPTION
	| GENERATOR
	| SEQUENCE
	| INDEX
	| ROLE
	| CHARACTER SET
	| COLLATION
	| PACKAGE
	;
ddl_type2 :
	 COLUMN /*15N*/
	;
ddl_type3 :
	 PARAMETER
	| PROCEDURE PARAMETER
	| FUNCTION PARAMETER
	;
ddl_type4 :
	 PROCEDURE
	| EXTERNAL FUNCTION
	| FUNCTION
	;
ddl_subname :
	 '.' symbol_ddl_name
	;
ddl_qualified_name :
	 symbol_ddl_name
	| symbol_ddl_name '.' symbol_ddl_name
	;
ddl_desc :
	 utf_string
	| NULL
	;
select :
	 select_expr for_update_clause lock_clause optimize_clause
	;
for_update_clause :
	 /*empty*/
	| FOR UPDATE for_update_list
	;
for_update_list :
	 /*empty*/
	| OF column_list
	;
lock_clause :
	 /*empty*/
	| WITH LOCK skip_locked_clause_opt
	;
skip_locked_clause_opt :
	 /*empty*/
	| SKIP LOCKED
	;
optimize_clause :
	 OPTIMIZE optimize_mode
	| /*empty*/
	;
optimize_mode :
	 FOR FIRST ROWS
	| FOR ALL ROWS
	;
select_expr :
	 with_clause select_expr_body order_clause_opt rows_clause
	| with_clause select_expr_body order_clause_opt result_offset_clause fetch_first_clause
	;
with_clause :
	 /*empty*/
	| WITH RECURSIVE with_list
	| WITH with_list
	;
with_list :
	 with_item
	| with_list ',' with_item
	;
with_item :
	 symbol_table_alias_name derived_column_list AS '(' select_expr ')'
	;
column_select :
	 select_expr
	;
column_singleton :
	 column_select
	;
select_expr_body :
	 query_term
	| select_expr_body UNION distinct_noise query_term
	| select_expr_body UNION ALL query_term
	;
query_term :
	 query_primary
	;
query_primary :
	 query_spec
	| '(' select_expr_body order_clause_opt result_offset_clause fetch_first_clause ')'
	;
query_spec :
	 SELECT limit_clause distinct_clause select_list from_clause where_clause group_clause having_clause named_windows_clause plan_clause
	;
limit_clause :
	 /*empty*/
	| first_clause skip_clause
	| first_clause
	| skip_clause
	;
first_clause :
	 FIRST long_integer
	| FIRST '(' value ')'
	| FIRST parameter
	;
skip_clause :
	 SKIP long_integer
	| SKIP '(' value ')'
	| SKIP parameter
	;
distinct_clause :
	 DISTINCT
	| all_noise
	;
select_list :
	 select_items
	| '*' /*7L*/
	;
select_items :
	 select_item
	| select_items ',' select_item
	;
select_item :
	 value_opt_alias
	| symbol_table_alias_name '.' '*' /*7L*/
	;
value_opt_alias :
	 value
	| value as_noise symbol_item_alias_name
	;
as_noise :
	 /*empty*/
	| AS
	;
from_clause :
	 FROM from_list
	;
from_list :
	 table_reference
	| from_list ',' table_reference
	;
table_reference :
	 joined_table
	| table_primary
	;
table_primary :
	 table_proc
	| derived_table
	| lateral_derived_table
	| parenthesized_joined_table
	;
parenthesized_joined_table :
	 '(' parenthesized_joined_table ')'
	| '(' joined_table ')'
	;
derived_table :
	 '(' select_expr ')' correlation_name_opt derived_column_list
	;
lateral_derived_table :
	 LATERAL derived_table
	;
correlation_name_opt :
	 /*empty*/
	| symbol_table_alias_name
	| AS symbol_table_alias_name
	;
derived_column_list :
	 /*empty*/
	| '(' alias_list ')'
	;
alias_list :
	 symbol_item_alias_name
	| alias_list ',' symbol_item_alias_name
	;
joined_table :
	 cross_join
	| natural_join
	| qualified_join
	;
cross_join :
	 table_reference CROSS JOIN table_primary
	;
natural_join :
	 table_reference NATURAL join_type JOIN table_primary
	;
qualified_join :
	 table_reference join_type JOIN table_reference join_condition
	| table_reference join_type JOIN table_reference named_columns_join
	;
join_condition :
	 ON search_condition
	;
named_columns_join :
	 USING '(' column_list ')'
	;
table_proc :
	 symbol_procedure_name table_proc_inputs as_noise symbol_table_alias_name
	| symbol_procedure_name table_proc_inputs
	| symbol_package_name '.' symbol_procedure_name table_proc_inputs as_noise symbol_table_alias_name
	| symbol_package_name '.' symbol_procedure_name table_proc_inputs
	;
table_proc_inputs :
	 /*empty*/
	| '(' argument_list ')'
	;
table_name :
	 simple_table_name
	| simple_table_name as_noise symbol_table_alias_name
	;
simple_table_name :
	 symbol_table_name
	;
join_type :
	 /*empty*/
	| INNER
	| LEFT outer_noise
	| RIGHT outer_noise
	| FULL outer_noise
	;
outer_noise :
	 /*empty*/
	| OUTER
	;
group_clause :
	 /*empty*/
	| GROUP BY group_by_list
	;
group_by_list :
	 group_by_item
	| group_by_list ',' group_by_item
	;
group_by_item :
	 value
	;
having_clause :
	 /*empty*/
	| HAVING search_condition
	;
where_clause :
	 /*empty*/
	| WHERE search_condition
	;
named_windows_clause :
	 /*empty*/
	| WINDOW window_definition_list
	;
window_definition_list :
	 window_definition
	| window_definition_list ',' window_definition
	;
window_definition :
	 symbol_window_name AS '(' window_clause ')'
	;
symbol_window_name_opt :
	 /*empty*/
	| symbol_window_name
	;
plan_clause :
	 /*empty*/
	| PLAN plan_expression
	;
plan_expression :
	 plan_type '(' plan_item_list ')'
	;
plan_type :
	 /*empty*/
	| JOIN
	| SORT MERGE
	| MERGE
	| HASH
	| SORT
	;
plan_item_list :
	 plan_item
	| plan_item_list ',' plan_item
	;
plan_item :
	 table_or_alias_list access_type
	| plan_expression
	;
table_or_alias_list :
	 symbol_table_name
	| table_or_alias_list symbol_table_name
	;
access_type :
	 NATURAL
	;
access_type :
	 INDEX '(' index_list ')'
	;
access_type :
	 ORDER symbol_index_name extra_indices_opt
	;
index_list :
	 symbol_index_name
	| index_list ',' symbol_index_name
	;
extra_indices_opt :
	 /*empty*/
	| INDEX '(' index_list ')'
	;
order_clause_opt :
	 /*empty*/
	| order_clause
	;
order_clause :
	 ORDER BY order_list
	;
order_list :
	 order_item
	| order_list ',' order_item
	;
order_item :
	 value order_direction nulls_clause
	;
order_direction :
	 /*empty*/
	| ASC
	| DESC
	;
nulls_clause :
	 /*empty*/
	| NULLS nulls_placement
	;
nulls_placement :
	 FIRST
	| LAST
	;
rows_clause :
	 ROWS value
	| ROWS value TO value
	;
rows_clause_optional :
	 /*empty*/
	| rows_clause
	;
row_noise :
	 ROW
	| ROWS
	;
result_offset_clause :
	 /*empty*/
	| OFFSET simple_value_spec row_noise
	;
first_next_noise :
	 FIRST
	| NEXT
	;
fetch_first_clause :
	 /*empty*/
	| FETCH first_next_noise simple_value_spec row_noise ONLY
	| FETCH first_next_noise row_noise ONLY
	;
insert :
	 insert_start ins_column_parens_opt override_opt VALUES '(' value_or_default_list ')' returning_clause
	| insert_start ins_column_parens_opt override_opt select_expr returning_clause
	| insert_start DEFAULT VALUES returning_clause
	;
insert_start :
	 INSERT INTO simple_table_name
	;
override_opt :
	 /*empty*/
	| OVERRIDING USER VALUE
	| OVERRIDING SYSTEM VALUE
	;
value_or_default_list :
	 value_or_default
	| value_or_default_list ',' value_or_default
	;
value_or_default :
	 value
	| DEFAULT
	;
merge :
	 MERGE INTO table_name USING table_reference ON search_condition merge_when_clause plan_clause order_clause_opt returning_clause
	;
merge_when_clause :
	 merge_when_matched_clause
	| merge_when_not_matched_clause
	| merge_when_clause merge_when_matched_clause
	| merge_when_clause merge_when_not_matched_clause
	;
merge_when_matched_clause :
	 WHEN MATCHED merge_update_specification
	;
merge_when_not_matched_clause :
	 WHEN NOT /*3L*/ MATCHED by_target_noise merge_insert_specification
	;
merge_when_not_matched_clause :
	 WHEN NOT /*3L*/ MATCHED BY SOURCE merge_update_specification
	;
by_target_noise :
	 /*empty*/
	| BY TARGET
	;
merge_update_specification :
	 THEN /*12N*/ UPDATE SET update_assignments
	| AND /*2L*/ search_condition THEN /*12N*/ UPDATE SET update_assignments
	| THEN /*12N*/ DELETE
	| AND /*2L*/ search_condition THEN /*12N*/ DELETE
	;
merge_insert_specification :
	 THEN /*12N*/ INSERT ins_column_parens_opt override_opt VALUES '(' value_or_default_list ')'
	| AND /*2L*/ search_condition THEN /*12N*/ INSERT ins_column_parens_opt override_opt VALUES '(' value_or_default_list ')'
	;
delete :
	 delete_searched
	| delete_positioned
	;
delete_searched :
	 DELETE FROM table_name where_clause plan_clause order_clause_opt rows_clause_optional skip_locked_clause_opt returning_clause
	;
delete_positioned :
	 DELETE FROM table_name cursor_clause returning_clause
	;
update :
	 update_searched
	| update_positioned
	;
update_searched :
	 UPDATE table_name SET update_assignments where_clause plan_clause order_clause_opt rows_clause_optional skip_locked_clause_opt returning_clause
	;
update_positioned :
	 UPDATE table_name SET update_assignments cursor_clause returning_clause
	;
update_or_insert :
	 UPDATE OR /*1L*/ INSERT INTO simple_table_name ins_column_parens_opt override_opt VALUES '(' value_or_default_list ')' update_or_insert_matching_opt plan_clause order_clause_opt rows_clause_optional returning_clause
	;
update_or_insert_matching_opt :
	 /*empty*/
	| MATCHING ins_column_parens
	;
returning_clause :
	 /*empty*/
	| RETURNING select_list
	| RETURNING select_list INTO variable_list
	;
cursor_clause :
	 WHERE CURRENT OF symbol_cursor_name
	;
assignment :
	 update_column_name '=' /*4L*/ value
	;
update_assignments :
	 update_assignment
	| update_assignments ',' update_assignment
	;
update_assignment :
	 update_column_name '=' /*4L*/ value
	| update_column_name '=' /*4L*/ DEFAULT
	;
exec_function :
	 udf
	| non_aggregate_function
	;
column_parens_opt :
	 /*empty*/
	| column_parens
	;
column_parens :
	 '(' column_list ')'
	;
column_list :
	 simple_column_name
	| column_list ',' simple_column_name
	;
ins_column_parens_opt :
	 /*empty*/
	| ins_column_parens
	;
ins_column_parens :
	 '(' ins_column_list ')'
	;
ins_column_list :
	 update_column_name
	| ins_column_list ',' update_column_name
	;
column_name :
	 simple_column_name
	| symbol_table_alias_name '.' symbol_column_name
	| ':' symbol_table_alias_name '.' symbol_column_name
	;
simple_column_name :
	 symbol_column_name
	;
update_column_name :
	 simple_column_name
	| symbol_table_alias_name '.' symbol_column_name
	;
search_condition :
	 value
	;
boolean_value_expression :
	 predicate
	| value OR /*1L*/ value
	| value AND /*2L*/ value
	| NOT /*3L*/ value
	| '(' boolean_value_expression ')'
	| value IS /*5L*/ boolean_literal
	| value IS /*5L*/ NOT /*3L*/ boolean_literal
	;
predicate :
	 comparison_predicate
	| distinct_predicate
	| between_predicate
	| binary_pattern_predicate
	| ternary_pattern_predicate
	| in_predicate
	| null_predicate
	| quantified_predicate
	| exists_predicate
	| singular_predicate
	| trigger_action_predicate
	| session_reset_predicate
	;
comparison_predicate :
	 value comparison_operator value %prec '=' /*4L*/
	;
comparison_operator :
	 '=' /*4L*/
	| '<' /*4L*/
	| '>' /*4L*/
	| GEQ /*4L*/
	| LEQ /*4L*/
	| NOT_GTR /*4L*/
	| NOT_LSS /*4L*/
	| NEQ /*4L*/
	;
quantified_predicate :
	 value comparison_operator quantified_flag '(' column_select ')'
	;
quantified_flag :
	 ALL
	| SOME
	| ANY
	;
distinct_predicate :
	 value IS /*5L*/ DISTINCT FROM value %prec IS /*5L*/
	| value IS /*5L*/ NOT /*3L*/ DISTINCT FROM value %prec IS /*5L*/
	;
between_predicate :
	 value BETWEEN /*4L*/ value_special AND /*2L*/ value_special %prec BETWEEN /*4L*/
	| value NOT /*3L*/ BETWEEN /*4L*/ value_special AND /*2L*/ value_special %prec BETWEEN /*4L*/
	;
binary_pattern_predicate :
	 value binary_pattern_operator value %prec CONTAINING /*4L*/
	| value NOT /*3L*/ binary_pattern_operator value %prec CONTAINING /*4L*/
	;
binary_pattern_operator :
	 CONTAINING /*4L*/
	| STARTING /*4L*/
	| STARTING /*4L*/ WITH
	;
ternary_pattern_predicate :
	 value LIKE /*4L*/ value %prec LIKE /*4L*/
	| value LIKE /*4L*/ value ESCAPE value %prec LIKE /*4L*/
	| value NOT /*3L*/ LIKE /*4L*/ value %prec LIKE /*4L*/
	| value NOT /*3L*/ LIKE /*4L*/ value ESCAPE value %prec LIKE /*4L*/
	| value SIMILAR /*4L*/ TO value %prec SIMILAR /*4L*/
	| value SIMILAR /*4L*/ TO value ESCAPE value %prec SIMILAR /*4L*/
	| value NOT /*3L*/ SIMILAR /*4L*/ TO value %prec SIMILAR /*4L*/
	| value NOT /*3L*/ SIMILAR /*4L*/ TO value ESCAPE value %prec SIMILAR /*4L*/
	;
in_predicate :
	 value IN /*4L*/ in_predicate_value
	| value NOT /*3L*/ IN /*4L*/ in_predicate_value
	;
exists_predicate :
	 EXISTS '(' select_expr ')'
	;
singular_predicate :
	 SINGULAR '(' select_expr ')'
	;
trigger_action_predicate :
	 INSERTING
	| UPDATING
	| DELETING
	;
session_reset_predicate :
	 RESETTING
	;
null_predicate :
	 value IS /*5L*/ NULL
	| value IS /*5L*/ UNKNOWN
	| value IS /*5L*/ NOT /*3L*/ NULL
	| value IS /*5L*/ NOT /*3L*/ UNKNOWN
	;
in_predicate_value :
	 table_subquery
	| '(' value_list ')'
	;
table_subquery :
	 '(' column_select ')'
	;
create_user_clause :
	 symbol_user_name user_fixed_list_opt
	;
alter_user_clause :
	 symbol_user_name set_noise user_fixed_list_opt
	;
alter_cur_user_clause :
	 set_noise user_fixed_list_opt
	;
replace_user_clause :
	 symbol_user_name set_noise user_fixed_list_opt
	;
set_noise :
	 /*empty*/
	| SET
	;
user_fixed_list_opt :
	 /*empty*/
	| user_fixed_list
	;
user_fixed_list :
	 user_fixed_option
	| user_fixed_list user_fixed_option
	;
user_fixed_option :
	 FIRSTNAME utf_string
	| MIDDLENAME utf_string
	| LASTNAME utf_string
	| PASSWORD utf_string
	| GRANT ADMIN ROLE
	| REVOKE ADMIN ROLE
	| ACTIVE
	| INACTIVE
	| use_plugin
	| TAGS '(' user_var_list ')'
	;
use_plugin :
	 USING PLUGIN valid_symbol_name
	;
user_var_list :
	 user_var_option
	| user_var_list ',' user_var_option
	;
user_var_option :
	 valid_symbol_name '=' /*4L*/ utf_string
	| DROP valid_symbol_name
	;
create_map_clause :
	 map_clause map_to
	;
alter_map_clause :
	 map_clause map_to
	;
replace_map_clause :
	 map_clause map_to
	;
drop_map_clause :
	 map_name
	;
comment_on_mapping :
	 COMMENT ON MAPPING map_comment
	| COMMENT ON GLOBAL MAPPING map_comment
	;
map_comment :
	 map_name IS /*5L*/ ddl_desc
	;
map_clause :
	 map_name USING map_using FROM map_from
	;
map_name :
	 valid_symbol_name
	;
map_from :
	 map_from_symbol_name map_logoninfo
	| ANY map_from_symbol_name
	;
map_from_symbol_name :
	 valid_symbol_name
	| USER
	| GROUP
	;
map_logoninfo :
	 sql_string
	| valid_symbol_name
	;
map_using :
	 PLUGIN valid_symbol_name map_in
	| ANY PLUGIN map_in
	| ANY PLUGIN SERVERWIDE
	| MAPPING map_in
	| '*' /*7L*/ map_in
	;
map_in :
	 /*empty*/
	| IN /*4L*/ valid_symbol_name
	;
map_to :
	 TO map_role valid_symbol_name
	| TO map_role
	;
map_role :
	 ROLE
	| USER
	;
value :
	 value_primary
	| boolean_value_expression
	;
value_special :
	 value_primary
	| '(' boolean_value_expression ')'
	;
value_primary :
	 nonparenthesized_value
	| '(' value_primary ')'
	;
simple_value_spec :
	 constant
	| variable
	| parameter
	;
nonparenthesized_value :
	 column_name
	| array_element
	| function
	| u_constant
	| boolean_literal
	| parameter
	| variable
	| cast_specification
	| case_expression
	| next_value_expression
	| udf
	| '-' /*6L*/ value_special %prec UMINUS /*8L*/
	| '+' /*6L*/ value_special %prec UPLUS /*8L*/
	| value_special '+' /*6L*/ value_special
	| value_special CONCATENATE /*9L*/ value_special
	| value_special COLLATE /*10L*/ symbol_collation_name
	| value_special AT /*11L*/ LOCAL %prec AT /*11L*/
	| value_special AT /*11L*/ TIME ZONE value_special %prec AT /*11L*/
	| value_special '-' /*6L*/ value_special
	| value_special '*' /*7L*/ value_special
	| value_special '/' /*7L*/ value_special
	| '(' column_singleton ')'
	| current_user
	| current_role
	| internal_info
	| recordKeyType
	| symbol_table_alias_name '.' recordKeyType
	| VALUE
	| datetime_value_expression
	| null_value
	;
recordKeyType :
	 DB_KEY
	| RDB_RECORD_VERSION
	;
datetime_value_expression :
	 CURRENT_DATE
	| LOCALTIME time_precision_opt
	| CURRENT_TIME time_precision_opt
	| LOCALTIMESTAMP timestamp_precision_opt
	| CURRENT_TIMESTAMP timestamp_precision_opt
	;
time_precision_opt :
	 /*empty*/
	| '(' nonneg_short_integer ')'
	;
timestamp_precision_opt :
	 /*empty*/
	| '(' nonneg_short_integer ')'
	;
array_element :
	 column_name '[' value_list ']'
	;
value_list_opt :
	 /*empty*/
	| value_list
	;
value_list :
	 value
	| value_list ',' value
	;
constant :
	 u_constant
	| '-' /*6L*/ ul_numeric_constant
	| '-' /*6L*/ LIMIT64_INT
	| '-' /*6L*/ LIMIT64_NUMBER
	| '-' /*6L*/ u_constant_128
	| boolean_literal
	;
u_numeric_constant :
	 ul_numeric_constant
	| LIMIT64_NUMBER
	| LIMIT64_INT
	| u_constant_128
	;
u_constant_128 :
	 NUM128
	;
ul_numeric_constant :
	 NUMBER32BIT
	| FLOAT_NUMBER
	| DECIMAL_NUMBER
	| NUMBER64BIT
	| SCALEDINT
	;
u_constant :
	 u_numeric_constant
	| sql_string
	| DATE STRING
	| TIME STRING
	| TIMESTAMP STRING
	;
boolean_literal :
	 FALSE
	| TRUE
	;
parameter :
	 '?'
	;
current_user :
	 USER
	| CURRENT_USER
	;
current_role :
	 CURRENT_ROLE
	;
internal_info :
	 CURRENT_CONNECTION
	| CURRENT_TRANSACTION
	| GDSCODE
	| SQLCODE
	| SQLSTATE
	| ROW_COUNT
	| RDB_ERROR '(' error_context ')'
	;
error_context :
	 GDSCODE
	| SQLCODE
	| SQLSTATE
	| EXCEPTION
	| MESSAGE
	;
sql_string :
	 STRING
	| INTRODUCER STRING
	;
utf_string :
	 sql_string
	;
signed_short_integer :
	 nonneg_short_integer
	| '-' /*6L*/ neg_short_integer
	;
nonneg_short_integer :
	 NUMBER32BIT
	;
neg_short_integer :
	 NUMBER32BIT
	;
pos_short_integer :
	 nonneg_short_integer
	;
unsigned_short_integer :
	 NUMBER32BIT
	;
signed_long_integer :
	 long_integer
	| '-' /*6L*/ long_integer
	;
long_integer :
	 NUMBER32BIT
	;
function :
	 aggregate_function
	| non_aggregate_function
	| over_clause
	;
non_aggregate_function :
	 numeric_value_function
	| string_value_function
	| system_function_expression
	;
aggregate_function :
	 aggregate_function_prefix
	| aggregate_function_prefix FILTER '(' WHERE search_condition ')'
	;
aggregate_function_prefix :
	 COUNT '(' '*' /*7L*/ ')'
	| COUNT '(' all_noise value ')'
	| COUNT '(' DISTINCT value ')'
	| SUM '(' all_noise value ')'
	| SUM '(' DISTINCT value ')'
	| AVG '(' all_noise value ')'
	| AVG '(' DISTINCT value ')'
	| MINIMUM '(' all_noise value ')'
	| MINIMUM '(' DISTINCT value ')'
	| MAXIMUM '(' all_noise value ')'
	| MAXIMUM '(' DISTINCT value ')'
	| LIST '(' all_noise value delimiter_opt ')'
	| LIST '(' DISTINCT value delimiter_opt ')'
	| STDDEV_SAMP '(' value ')'
	| STDDEV_POP '(' value ')'
	| VAR_SAMP '(' value ')'
	| VAR_POP '(' value ')'
	| COVAR_SAMP '(' value ',' value ')'
	| COVAR_POP '(' value ',' value ')'
	| CORR '(' value ',' value ')'
	| REGR_AVGX '(' value ',' value ')'
	| REGR_AVGY '(' value ',' value ')'
	| REGR_COUNT '(' value ',' value ')'
	| REGR_INTERCEPT '(' value ',' value ')'
	| REGR_R2 '(' value ',' value ')'
	| REGR_SLOPE '(' value ',' value ')'
	| REGR_SXX '(' value ',' value ')'
	| REGR_SXY '(' value ',' value ')'
	| REGR_SYY '(' value ',' value ')'
	| ANY_VALUE '(' distinct_noise value ')'
	;
window_function :
	 DENSE_RANK '(' ')'
	| RANK '(' ')'
	| PERCENT_RANK '(' ')'
	| CUME_DIST '(' ')'
	| ROW_NUMBER '(' ')'
	| FIRST_VALUE '(' value ')'
	| LAST_VALUE '(' value ')'
	| NTH_VALUE '(' value ',' value ')' nth_from
	| LAG '(' value ',' value ',' value ')'
	| LAG '(' value ',' value ')'
	| LAG '(' value ')'
	| LEAD '(' value ',' value ',' value ')'
	| LEAD '(' value ',' value ')'
	| LEAD '(' value ')'
	| NTILE '(' ntile_arg ')'
	;
nth_from :
	 /*empty*/
	| FROM FIRST
	| FROM LAST
	;
ntile_arg :
	 u_numeric_constant
	| variable
	| parameter
	;
aggregate_window_function :
	 aggregate_function
	| window_function
	;
over_clause :
	 aggregate_window_function OVER symbol_window_name
	| aggregate_window_function OVER '(' window_clause ')'
	;
window_clause :
	 symbol_window_name_opt window_partition_opt order_clause_opt window_frame_extent window_frame_exclusion_opt
	;
window_partition_opt :
	 /*empty*/
	| PARTITION BY value_list
	;
window_frame_extent :
	 /*empty*/
	;
window_frame_extent :
	 RANGE window_frame
	;
window_frame_extent :
	 ROWS window_frame
	;
window_frame :
	 window_frame_start
	| BETWEEN /*4L*/ window_frame_between_bound1 AND /*2L*/ window_frame_between_bound2
	;
window_frame_start :
	 UNBOUNDED PRECEDING
	| CURRENT ROW
	| value PRECEDING
	;
window_frame_between_bound1 :
	 UNBOUNDED PRECEDING
	| CURRENT ROW
	| value PRECEDING
	| value FOLLOWING
	;
window_frame_between_bound2 :
	 UNBOUNDED FOLLOWING
	| CURRENT ROW
	| value PRECEDING
	| value FOLLOWING
	;
window_frame_exclusion_opt :
	 /*empty*/
	| EXCLUDE NO OTHERS
	| EXCLUDE CURRENT ROW
	| EXCLUDE GROUP
	| EXCLUDE TIES
	;
delimiter_opt :
	 /*empty*/
	| ',' value
	;
numeric_value_function :
	 extract_expression
	| length_expression
	;
extract_expression :
	 EXTRACT '(' timestamp_part FROM value ')'
	;
length_expression :
	 bit_length_expression
	| char_length_expression
	| octet_length_expression
	;
bit_length_expression :
	 BIT_LENGTH '(' value ')'
	;
char_length_expression :
	 CHAR_LENGTH '(' value ')'
	| CHARACTER_LENGTH '(' value ')'
	;
octet_length_expression :
	 OCTET_LENGTH '(' value ')'
	;
system_function_expression :
	 system_function_std_syntax '(' value_list_opt ')'
	| system_function_special_syntax
	;
system_function_std_syntax :
	 ABS
	| ACOS
	| ACOSH
	| ASCII_CHAR
	| ASCII_VAL
	| ASIN
	| ASINH
	| ATAN
	| ATAN2
	| ATANH
	| BASE64_DECODE
	| BASE64_ENCODE
	| BIN_AND
	| BIN_NOT
	| BIN_OR
	| BIN_SHL
	| BIN_SHR
	| BIN_XOR
	| BLOB_APPEND
	| CEIL
	| CHAR_TO_UUID
	| COS
	| COSH
	| COT
	| EXP
	| FLOOR
	| GEN_UUID
	| HEX_DECODE
	| HEX_ENCODE
	| LEFT
	| LN
	| LOG
	| LOG10
	| LPAD
	| MAKE_DBKEY
	| MAXVALUE
	| MINVALUE
	| MOD
	| PI
	| POWER
	| RAND
	| RDB_GET_CONTEXT
	| RDB_GET_TRANSACTION_CN
	| RDB_ROLE_IN_USE
	| RDB_SET_CONTEXT
	| REPLACE
	| REVERSE
	| RIGHT
	| ROUND
	| RPAD
	| RSA_PRIVATE
	| RSA_PUBLIC
	| SIGN
	| SIN
	| SINH
	| SQRT
	| TAN
	| TANH
	| TRUNC
	| UNICODE_CHAR
	| UNICODE_VAL
	| UUID_TO_CHAR
	| QUANTIZE
	| TOTALORDER
	| NORMALIZE_DECFLOAT
	| COMPARE_DECFLOAT
	;
system_function_special_syntax :
	 DATEADD '(' value timestamp_part TO value ')'
	| DATEADD '(' timestamp_part ',' value ',' value ')'
	| DATEDIFF '(' timestamp_part FROM value TO value ')'
	| DATEDIFF '(' timestamp_part ',' value ',' value ')'
	| encrypt_decrypt '(' value USING valid_symbol_name crypt_opt_mode KEY value crypt_opt_iv crypt_opt_counter_type crypt_opt_counter ')'
	| FIRST_DAY '(' of_first_last_day_part FROM value ')'
	| HASH '(' value ')'
	| hash_func '(' value USING valid_symbol_name ')'
	| LAST_DAY '(' of_first_last_day_part FROM value ')'
	| OVERLAY '(' value PLACING value FROM value FOR value ')'
	| OVERLAY '(' value PLACING value FROM value ')'
	| POSITION '(' value IN /*4L*/ value ')'
	| POSITION '(' value_list_opt ')'
	| rsa_encrypt_decrypt '(' value KEY value crypt_opt_lparam crypt_opt_hash crypt_opt_pkcs ')'
	| RSA_SIGN_HASH '(' value KEY value crypt_opt_hash crypt_opt_saltlen crypt_opt_pkcs ')'
	| RSA_VERIFY_HASH '(' value SIGNATURE value KEY value crypt_opt_hash crypt_opt_saltlen crypt_opt_pkcs ')'
	| RDB_SYSTEM_PRIVILEGE '(' valid_symbol_name ')'
	;
hash_func :
	 HASH
	| CRYPT_HASH
	;
rsa_encrypt_decrypt :
	 RSA_DECRYPT
	| RSA_ENCRYPT
	;
crypt_opt_lparam :
	 /*empty*/
	| LPARAM value
	;
crypt_opt_pkcs :
	 /*empty*/
	| PKCS_1_5
	;
crypt_opt_hash :
	 /*empty*/
	| HASH valid_symbol_name
	;
crypt_opt_saltlen :
	 /*empty*/
	| SALT_LENGTH value
	;
crypt_opt_mode :
	 /*empty*/
	| MODE valid_symbol_name
	;
crypt_opt_iv :
	 /*empty*/
	| IV value
	;
crypt_opt_counter_type :
	 /*empty*/
	| crypt_counter_type
	;
crypt_counter_type :
	 CTR_BIG_ENDIAN
	| CTR_LITTLE_ENDIAN
	;
crypt_opt_counter :
	 /*empty*/
	| crypt_counter_name value
	;
crypt_counter_name :
	 COUNTER
	| CTR_LENGTH
	;
encrypt_decrypt :
	 ENCRYPT
	| DECRYPT
	;
of_first_last_day_part :
	 OF YEAR
	| OF QUARTER
	| OF MONTH
	| OF WEEK
	;
string_value_function :
	 substring_function
	| trim_function
	| UPPER '(' value ')'
	| LOWER '(' value ')'
	;
substring_function :
	 SUBSTRING '(' value FROM value string_length_opt ')'
	| SUBSTRING '(' value SIMILAR /*4L*/ value ESCAPE value ')'
	;
string_length_opt :
	 /*empty*/
	| FOR value
	;
trim_function :
	 TRIM '(' trim_specification value FROM value ')'
	| TRIM '(' value FROM value ')'
	| TRIM '(' trim_specification FROM value ')'
	| TRIM '(' value ')'
	;
trim_specification :
	 BOTH
	| TRAILING
	| LEADING
	;
udf :
	 symbol_UDF_call_name '(' argument_list_opt ')'
	| symbol_package_name '.' symbol_UDF_name '(' argument_list_opt ')'
	;
argument_list_opt :
	 /*empty*/
	| argument_list
	;
argument_list :
	 named_argument_list
	| value_or_default_list
	| value_or_default_list ',' named_argument_list
	;
named_argument_list :
	 named_argument
	| named_argument_list ',' named_argument
	;
named_argument :
	 symbol_column_name NAMED_ARG_ASSIGN value_or_default
	;
cast_specification :
	 CAST '(' value AS data_type_descriptor ')'
	| CAST '(' value AS cast_format_type cast_format_clause utf_string ')'
	;
cast_format_clause :
	 FORMAT
	;
date_time_type :
	 DATE
	| TIME without_time_zone_opt
	| TIME WITH TIME ZONE
	| TIMESTAMP without_time_zone_opt
	| TIMESTAMP WITH TIME ZONE
	;
cast_format_type :
	 character_type
	| date_time_type
	;
case_expression :
	 case_abbreviation
	| case_specification
	;
case_abbreviation :
	 NULLIF '(' value ',' value ')'
	| IIF '(' search_condition ',' value ',' value ')'
	| COALESCE '(' value ',' value_list ')'
	| DECODE '(' value ',' decode_pairs ')'
	| DECODE '(' value ',' decode_pairs ',' value ')'
	;
case_specification :
	 simple_case
	| searched_case
	;
simple_case :
	 CASE case_operand simple_when_clause else_case_result_opt END
	;
simple_when_clause :
	 WHEN when_operand THEN /*12N*/ case_result
	| simple_when_clause WHEN when_operand THEN /*12N*/ case_result
	;
else_case_result_opt :
	 /*empty*/
	| ELSE /*13N*/ case_result
	;
searched_case :
	 CASE searched_when_clause END
	| CASE searched_when_clause ELSE /*13N*/ case_result END
	;
searched_when_clause :
	 WHEN search_condition THEN /*12N*/ case_result
	| searched_when_clause WHEN search_condition THEN /*12N*/ case_result
	;
when_operand :
	 value
	;
case_operand :
	 value
	;
case_result :
	 value
	;
decode_pairs :
	 value ',' value
	| decode_pairs ',' value ',' value
	;
next_value_expression :
	 NEXT VALUE FOR symbol_generator_name
	| GEN_ID '(' symbol_generator_name ',' value ')'
	;
timestamp_part :
	 YEAR
	| QUARTER
	| MONTH
	| DAY
	| HOUR
	| MINUTE
	| SECOND
	| MILLISECOND
	| TIMEZONE_HOUR
	| TIMEZONE_MINUTE
	| TIMEZONE_NAME
	| WEEK
	| WEEKDAY
	| YEARDAY
	;
all_noise :
	 /*empty*/
	| ALL
	;
distinct_noise :
	 /*empty*/
	| DISTINCT
	;
null_value :
	 NULL
	| UNKNOWN
	;
symbol_UDF_call_name :
	 SYMBOL
	;
symbol_UDF_name :
	 valid_symbol_name
	;
symbol_blob_subtype_name :
	 valid_symbol_name
	| BINARY
	;
symbol_character_set_name :
	 valid_symbol_name
	| BINARY
	;
symbol_collation_name :
	 valid_symbol_name
	;
symbol_column_name :
	 valid_symbol_name
	;
symbol_constraint_name :
	 valid_symbol_name
	;
symbol_cursor_name :
	 valid_symbol_name
	;
symbol_domain_name :
	 valid_symbol_name
	;
symbol_exception_name :
	 valid_symbol_name
	;
symbol_filter_name :
	 valid_symbol_name
	;
symbol_gdscode_name :
	 valid_symbol_name
	;
symbol_generator_name :
	 valid_symbol_name
	;
symbol_index_name :
	 valid_symbol_name
	;
symbol_item_alias_name :
	 valid_symbol_name
	;
symbol_label_name :
	 valid_symbol_name
	;
symbol_ddl_name :
	 valid_symbol_name
	;
symbol_procedure_name :
	 valid_symbol_name
	;
symbol_role_name :
	 valid_symbol_name
	;
symbol_table_alias_name :
	 valid_symbol_name
	;
symbol_table_name :
	 valid_symbol_name
	;
symbol_trigger_name :
	 valid_symbol_name
	;
symbol_user_name :
	 valid_symbol_name
	;
symbol_variable_name :
	 valid_symbol_name
	;
symbol_view_name :
	 valid_symbol_name
	;
symbol_savepoint_name :
	 valid_symbol_name
	;
symbol_package_name :
	 valid_symbol_name
	;
symbol_window_name :
	 valid_symbol_name
	;
valid_symbol_name :
	 SYMBOL
	//| non_reserved_word
	;

%%

%option caseless

%%

[\n\r\t ]+	skip()
"--".*	skip()
"/*"(?s:.)*?"*/"	skip()

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
"*"	'*'
"+"	'+'

ABS	ABS
ABSOLUTE	ABSOLUTE
ACCENT	ACCENT
ACOS	ACOS
ACOSH	ACOSH
ACTION	ACTION
ACTIVE	ACTIVE
ADD	ADD
ADMIN	ADMIN
AFTER	AFTER
ALL	ALL
ALTER	ALTER
ALWAYS	ALWAYS
AND	AND
ANY	ANY
ANY_VALUE	ANY_VALUE
AS	AS
ASC|ASCENDING	ASC
ASCII_CHAR	ASCII_CHAR
ASCII_VAL	ASCII_VAL
ASIN	ASIN
ASINH	ASINH
AT	AT
ATAN	ATAN
ATAN2	ATAN2
ATANH	ATANH
AUTO	AUTO
AUTONOMOUS	AUTONOMOUS
AVG	AVG
BACKUP	BACKUP
BASE64_DECODE	BASE64_DECODE
BASE64_ENCODE	BASE64_ENCODE
BEFORE	BEFORE
BEGIN	BEGIN
BETWEEN	BETWEEN
BIGINT	BIGINT
BIN_AND	BIN_AND
BINARY	BINARY
BIND	BIND
BIND_PARAM	BIND_PARAM
BIN_NOT	BIN_NOT
BIN_OR	BIN_OR
BIN_SHL	BIN_SHL
BIN_SHR	BIN_SHR
BIN_XOR	BIN_XOR
BIT_LENGTH	BIT_LENGTH
BLOB	BLOB
BLOB_APPEND	BLOB_APPEND
BLOCK	BLOCK
BODY	BODY
BOOLEAN	BOOLEAN
BOTH	BOTH
BREAK	BREAK
BY	BY
CALL	CALL
CALLER	CALLER
CASCADE	CASCADE
CASE	CASE
CAST	CAST
CEIL	CEIL
CHAR	CHAR
CHARACTER	CHARACTER
CHARACTER_LENGTH	CHARACTER_LENGTH
CHAR_LENGTH	CHAR_LENGTH
CHAR_TO_UUID	CHAR_TO_UUID
CHECK	CHECK
CLEAR	CLEAR
CLOSE	CLOSE
COALESCE	COALESCE
COLLATE	COLLATE
COLLATION	COLLATION
COLUMN	COLUMN
COMMENT	COMMENT
COMMIT	COMMIT
COMMITTED	COMMITTED
COMMON	COMMON
COMPARE_DECFLOAT	COMPARE_DECFLOAT
COMPUTED	COMPUTED
"||"	CONCATENATE
CONDITIONAL	CONDITIONAL
CONNECT	CONNECT
CONNECTIONS	CONNECTIONS
CONSISTENCY	CONSISTENCY
CONSTRAINT	CONSTRAINT
CONTAINING	CONTAINING
CONTINUE	CONTINUE
CORR	CORR
COS	COS
COSH	COSH
COT	COT
COUNT	COUNT
COUNTER	COUNTER
COVAR_POP	COVAR_POP
COVAR_SAMP	COVAR_SAMP
CREATE	CREATE
CROSS	CROSS
CRYPT_HASH	CRYPT_HASH
CSTRING	CSTRING
CTR_BIG_ENDIAN	CTR_BIG_ENDIAN
CTR_LENGTH	CTR_LENGTH
CTR_LITTLE_ENDIAN	CTR_LITTLE_ENDIAN
CUME_DIST	CUME_DIST
CURRENT	CURRENT
CURRENT_CONNECTION	CURRENT_CONNECTION
CURRENT_DATE	CURRENT_DATE
CURRENT_ROLE	CURRENT_ROLE
CURRENT_TIME	CURRENT_TIME
CURRENT_TIMESTAMP	CURRENT_TIMESTAMP
CURRENT_TRANSACTION	CURRENT_TRANSACTION
CURRENT_USER	CURRENT_USER
CURSOR	CURSOR
DATA	DATA
DATABASE	DATABASE
DATE	DATE
DATEADD	DATEADD
DATEDIFF	DATEDIFF
DAY	DAY
DB_KEY	DB_KEY
DDL	DDL
DEBUG	DEBUG
DEC	DEC
DECFLOAT	DECFLOAT
DECIMAL	DECIMAL
DECLARE	DECLARE
DECODE	DECODE
DECRYPT	DECRYPT
DEFAULT	DEFAULT
DEFINER	DEFINER
DELETE	DELETE
DELETING	DELETING
DENSE_RANK	DENSE_RANK
DESC|DESCENDING	DESC
DESCRIPTOR	DESCRIPTOR
DETERMINISTIC	DETERMINISTIC
DIFFERENCE	DIFFERENCE
DISABLE	DISABLE
DISCONNECT	DISCONNECT
DISTINCT	DISTINCT
DO	DO
DOMAIN	DOMAIN
DOUBLE	DOUBLE
DROP	DROP
ELSE	ELSE
ENABLE	ENABLE
ENCRYPT	ENCRYPT
END	END
ENGINE	ENGINE
ENTRY_POINT	ENTRY_POINT
ESCAPE	ESCAPE
EXCEPTION	EXCEPTION
EXCESS	EXCESS
EXCLUDE	EXCLUDE
EXECUTE	EXECUTE
EXISTS	EXISTS
EXIT	EXIT
EXP	EXP
EXTENDED	EXTENDED
EXTERNAL	EXTERNAL
EXTRACT	EXTRACT
FALSE	FALSE
FETCH	FETCH
FILE	FILE
FILTER	FILTER
FIRST	FIRST
FIRST_DAY	FIRST_DAY
FIRSTNAME	FIRSTNAME
FIRST_VALUE	FIRST_VALUE
FLOAT	FLOAT
FLOAT_NUMBER	FLOAT_NUMBER
FLOOR	FLOOR
FOLLOWING	FOLLOWING
FOR	FOR
FOREIGN	FOREIGN
FORMAT	FORMAT
FREE_IT	FREE_IT
FROM	FROM
FULL	FULL
FUNCTION	FUNCTION
GDSCODE	GDSCODE
GENERATED	GENERATED
GENERATOR	GENERATOR
GEN_ID	GEN_ID
GEN_UUID	GEN_UUID
">="	GEQ
GLOBAL	GLOBAL
GRANT	GRANT
GRANTED	GRANTED
GROUP	GROUP
HASH	HASH
HAVING	HAVING
HEX_DECODE	HEX_DECODE
HEX_ENCODE	HEX_ENCODE
HOUR	HOUR
IDENTITY	IDENTITY
IDLE	IDLE
IF	IF
IGNORE	IGNORE
IIF	IIF
IN	IN
INACTIVE	INACTIVE
INCLUDE	INCLUDE
INCREMENT	INCREMENT
INDEX	INDEX
INNER	INNER
INPUT_TYPE	INPUT_TYPE
INSENSITIVE	INSENSITIVE
INSERT	INSERT
INSERTING	INSERTING
INT	INT
INT128	INT128
INTEGER	INTEGER
INTO	INTO
INTRODUCER	INTRODUCER
INVOKER	INVOKER
IS	IS
ISOLATION	ISOLATION
IV	IV
JOIN	JOIN
KEY	KEY
LAG	LAG
LAST	LAST
LAST_DAY	LAST_DAY
LASTNAME	LASTNAME
LAST_VALUE	LAST_VALUE
LATERAL	LATERAL
LEAD	LEAD
LEADING	LEADING
LEAVE	LEAVE
LEFT	LEFT
LEGACY	LEGACY
LENGTH	LENGTH
"<="	LEQ
LEVEL	LEVEL
LIFETIME	LIFETIME
LIKE	LIKE
LIMBO	LIMBO
LIMIT64_INT	LIMIT64_INT
LIMIT64_NUMBER	LIMIT64_NUMBER
LINGER	LINGER
LIST	LIST
LN	LN
LOCAL	LOCAL
LOCALTIME	LOCALTIME
LOCALTIMESTAMP	LOCALTIMESTAMP
LOCK	LOCK
LOCKED	LOCKED
LOG	LOG
LOG10	LOG10
LONG	LONG
LOWER	LOWER
LPAD	LPAD
LPARAM	LPARAM
MAKE_DBKEY	MAKE_DBKEY
MANUAL	MANUAL
MAPPING	MAPPING
MATCHED	MATCHED
MATCHING	MATCHING
MAXIMUM	MAXIMUM
MAXVALUE	MAXVALUE
MERGE	MERGE
MESSAGE	MESSAGE
MIDDLENAME	MIDDLENAME
MILLISECOND	MILLISECOND
MINIMUM	MINIMUM
MINUTE	MINUTE
MINVALUE	MINVALUE
MOD	MOD
MODE	MODE
MODULE_NAME	MODULE_NAME
MONTH	MONTH
NAME    NAME
NAMED_ARG_ASSIGN	NAMED_ARG_ASSIGN
NAMES	NAMES
NATIONAL	NATIONAL
NATIVE	NATIVE
NATURAL	NATURAL
NCHAR	NCHAR
"<>"	NEQ
NEXT	NEXT
NO	NO
NORMALIZE_DECFLOAT	NORMALIZE_DECFLOAT
NOT	NOT
NOT_GTR	NOT_GTR
NOT_LSS	NOT_LSS
NTH_VALUE	NTH_VALUE
NTILE	NTILE
NULL	NULL
NULLIF	NULLIF
NULLS	NULLS
NUM128	NUM128
NUMBER	NUMBER
NUMERIC	NUMERIC
OCTET_LENGTH	OCTET_LENGTH
OF	OF
OFFSET	OFFSET
OLDEST	OLDEST
ON	ON
ONLY	ONLY
OPEN	OPEN
OPTIMIZE	OPTIMIZE
OPTION	OPTION
OR	OR
ORDER	ORDER
OS_NAME	OS_NAME
OTHERS	OTHERS
OUTER	OUTER
OUTPUT_TYPE	OUTPUT_TYPE
OVER	OVER
OVERFLOW	OVERFLOW
OVERLAY	OVERLAY
OVERRIDING	OVERRIDING
PACKAGE	PACKAGE
PAD	PAD
PAGE	PAGE
PAGES	PAGES
PAGE_SIZE	PAGE_SIZE
PARAMETER	PARAMETER
PARTITION	PARTITION
PASSWORD	PASSWORD
PERCENT_RANK	PERCENT_RANK
PI	PI
PKCS_1_5	PKCS_1_5
PLACING	PLACING
PLAN	PLAN
PLUGIN	PLUGIN
POOL	POOL
POSITION	POSITION
POST_EVENT	POST_EVENT
POWER	POWER
PRECEDING	PRECEDING
PRECISION	PRECISION
PRESERVE	PRESERVE
PRIMARY	PRIMARY
PRIOR	PRIOR
PRIVILEGE	PRIVILEGE
PRIVILEGES	PRIVILEGES
PROCEDURE	PROCEDURE
PROTECTED	PROTECTED
PUBLICATION	PUBLICATION
QUANTIZE	QUANTIZE
QUARTER	QUARTER
RAND	RAND
RANGE	RANGE
RANK	RANK
RDB_ERROR	RDB_ERROR
RDB_GET_CONTEXT	RDB_GET_CONTEXT
RDB_GET_TRANSACTION_CN	RDB_GET_TRANSACTION_CN
RDB_RECORD_VERSION	RDB_RECORD_VERSION
RDB_ROLE_IN_USE	RDB_ROLE_IN_USE
RDB_SET_CONTEXT	RDB_SET_CONTEXT
RDB_SYSTEM_PRIVILEGE	RDB_SYSTEM_PRIVILEGE
READ	READ
REAL	REAL
RECREATE	RECREATE
RECURSIVE	RECURSIVE
REFERENCES	REFERENCES
REGR_AVGX	REGR_AVGX
REGR_AVGY	REGR_AVGY
REGR_COUNT	REGR_COUNT
REGR_INTERCEPT	REGR_INTERCEPT
REGR_R2	REGR_R2
REGR_SLOPE	REGR_SLOPE
REGR_SXX	REGR_SXX
REGR_SXY	REGR_SXY
REGR_SYY	REGR_SYY
RELATIVE	RELATIVE
RELEASE	RELEASE
REPLACE	REPLACE
REQUESTS	REQUESTS
RESERVING	RESERVING
RESET	RESET
RESETTING	RESETTING
RESTART	RESTART
RESTRICT	RESTRICT
RETAIN	RETAIN
RETURN	RETURN
RETURNING	RETURNING
RETURNING_VALUES	RETURNING_VALUES
RETURNS	RETURNS
REVERSE	REVERSE
REVOKE	REVOKE
RIGHT	RIGHT
ROLE	ROLE
ROLLBACK	ROLLBACK
ROUND	ROUND
ROW	ROW
ROW_COUNT	ROW_COUNT
ROW_NUMBER	ROW_NUMBER
ROWS	ROWS
RPAD	RPAD
RSA_DECRYPT	RSA_DECRYPT
RSA_ENCRYPT	RSA_ENCRYPT
RSA_PRIVATE	RSA_PRIVATE
RSA_PUBLIC	RSA_PUBLIC
RSA_SIGN_HASH	RSA_SIGN_HASH
RSA_VERIFY_HASH	RSA_VERIFY_HASH
SALT_LENGTH	SALT_LENGTH
SAVEPOINT	SAVEPOINT
SCALAR_ARRAY	SCALAR_ARRAY
SCALEDINT	SCALEDINT
SCROLL	SCROLL
SECOND	SECOND
SECURITY	SECURITY
SEGMENT	SEGMENT
SELECT	SELECT
SENSITIVE	SENSITIVE
SEQUENCE	SEQUENCE
SERVERWIDE	SERVERWIDE
SESSION	SESSION
SET	SET
SHADOW	SHADOW
SHARED	SHARED
SIGN	SIGN
SIGNATURE	SIGNATURE
SIMILAR	SIMILAR
SIN	SIN
SINGULAR	SINGULAR
SINH	SINH
SIZE	SIZE
SKIP	SKIP
SMALLINT	SMALLINT
SNAPSHOT	SNAPSHOT
SOME	SOME
SORT	SORT
SOURCE	SOURCE
SPACE	SPACE
SQL	SQL
SQLCODE	SQLCODE
SQLSTATE	SQLSTATE
SQRT	SQRT
STABILITY	STABILITY
START	START
STARTING	STARTING
STATEMENT	STATEMENT
STATISTICS	STATISTICS
STDDEV_POP	STDDEV_POP
STDDEV_SAMP	STDDEV_SAMP
SUBSTRING	SUBSTRING
SUB_TYPE	SUB_TYPE
SUM	SUM
SUSPEND	SUSPEND
SYSTEM	SYSTEM
TABLE	TABLE
TAGS	TAGS
TAN	TAN
TANH	TANH
TARGET	TARGET
TEMPORARY	TEMPORARY
THEN	THEN
TIES	TIES
TIME	TIME
TIMEOUT	TIMEOUT
TIMESTAMP	TIMESTAMP
TIMEZONE_HOUR	TIMEZONE_HOUR
TIMEZONE_MINUTE	TIMEZONE_MINUTE
TIMEZONE_NAME	TIMEZONE_NAME
TO	TO
TOTALORDER	TOTALORDER
TRAILING	TRAILING
TRANSACTION	TRANSACTION
TRAPS	TRAPS
TRIGGER	TRIGGER
TRIM	TRIM
TRUE	TRUE
TRUNC	TRUNC
TRUSTED	TRUSTED
TWO_PHASE	TWO_PHASE
TYPE	TYPE
UMINUS	UMINUS
UNBOUNDED	UNBOUNDED
UNCOMMITTED	UNCOMMITTED
UNDO	UNDO
UNICODE_CHAR	UNICODE_CHAR
UNICODE_VAL	UNICODE_VAL
UNION	UNION
UNIQUE	UNIQUE
UNKNOWN	UNKNOWN
UPDATE	UPDATE
UPDATING	UPDATING
UPLUS	UPLUS
UPPER	UPPER
USAGE	USAGE
USER	USER
USING	USING
UUID_TO_CHAR	UUID_TO_CHAR
VALUE	VALUE
VALUES	VALUES
VARBINARY	VARBINARY
VARCHAR	VARCHAR
VARIABLE	VARIABLE
VAR_POP	VAR_POP
VAR_SAMP	VAR_SAMP
VARYING	VARYING
VERSION	VERSION
VIEW	VIEW
WAIT	WAIT
WEEK	WEEK
WEEKDAY	WEEKDAY
WHEN	WHEN
WHERE	WHERE
WHILE	WHILE
WINDOW	WINDOW
WITH	WITH
WITHOUT	WITHOUT
WORK	WORK
WRITE	WRITE
YEAR	YEAR
YEARDAY	YEARDAY
ZONE	ZONE

[0-9]+	NUMBER32BIT
NUMBER64BIT	NUMBER64BIT

[0-9]+"."[0-9]+	DECIMAL_NUMBER

'(\\.|[^'\n\r\\])*'	STRING

[A-Z_][A-Z0-9_]*	SYMBOL


%%
