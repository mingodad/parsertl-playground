//From: https://github.com/MonetDB/MonetDB/blob/d11d51798c355c4f7752ec68be1e69377a6e74a5/sql/server/sql_parser.y
/*
 * SPDX-License-Identifier: MPL-2.0
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0.  If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * Copyright 2024 MonetDB Foundation;
 * Copyright August 2008 - 2023 MonetDB B.V.;
 * Copyright 1997 - July 2008 CWI.
 */

/*Tokens*/
%token STRING
%token USTRING
%token XSTRING
%token IDENT
%token UIDENT
%token aTYPE
%token RANK
%token MARGFUNC
%token sqlINT
%token OIDNUM
%token HEXADECIMALNUM
%token OCTALNUM
%token BINARYNUM
%token INTNUM
%token APPROXNUM
%token USING
%token GLOBAL
%token CAST
%token CONVERT
%token CHARACTER
%token VARYING
%token LARGE
%token OBJECT
%token VARCHAR
%token CLOB
%token sqlTEXT
%token BINARY
%token sqlBLOB
%token sqlDECIMAL
%token sqlFLOAT
%token TINYINT
%token SMALLINT
%token BIGINT
%token HUGEINT
%token sqlINTEGER
%token sqlDOUBLE
%token sqlREAL
%token PRECISION
%token PARTIAL
%token SIMPLE
%token ACTION
%token CASCADE
%token RESTRICT
%token sqlBOOL
%token BOOL_FALSE
%token BOOL_TRUE
%token CURRENT_DATE
%token CURRENT_TIMESTAMP
%token CURRENT_TIME
%token LOCALTIMESTAMP
%token LOCALTIME
%token BIG
%token LITTLE
%token NATIVE
%token ENDIAN
%token LEX_ERROR
%token GEOMETRY
%token GEOMETRYSUBTYPE
%token GEOMETRYA
%token USER
%token CURRENT_USER
%token SESSION_USER
%token LOCAL
%token BEST
%token EFFORT
%token CURRENT_ROLE
%token sqlSESSION
%token CURRENT_SCHEMA
%token CURRENT_TIMEZONE
%token sqlDELETE
%token UPDATE
%token SELECT
%token INSERT
%token MATCHED
%token LOGIN
%token LATERAL
%token LEFT
%token RIGHT
%token FULL
%token OUTER
%token NATURAL
%token CROSS
%token JOIN
%token INNER
%token COMMIT
%token ROLLBACK
%token SAVEPOINT
%token RELEASE
%token WORK
%token CHAIN
%token NO
%token PRESERVE
%token ROWS
%token START
%token TRANSACTION
%token READ
%token WRITE
%token ONLY
%token ISOLATION
%token LEVEL
%token UNCOMMITTED
%token COMMITTED
%token sqlREPEATABLE
%token SERIALIZABLE
%token DIAGNOSTICS
%token sqlSIZE
%token STORAGE
%token SNAPSHOT
%token ASYMMETRIC
%token SYMMETRIC
%token ORDER
%token ORDERED
%token BY
%token IMPRINTS
%token ESCAPE
%token UESCAPE
%token HAVING
%token sqlGROUP
%token ROLLUP
%token CUBE
%token sqlNULL
%token GROUPING
%token SETS
%token FROM
%token FOR
%token MATCH
%token EXTRACT
%token SEQUENCE
%token INCREMENT
%token RESTART
%token CONTINUE
%token MAXVALUE
%token MINVALUE
%token CYCLE
%token NEXT
%token VALUE
%token CACHE
%token GENERATED
%token ALWAYS
%token IDENTITY
%token SERIAL
%token BIGSERIAL
%token AUTO_INCREMENT
%token SCOLON
%token AT
%token XMLCOMMENT
%token XMLCONCAT
%token XMLDOCUMENT
%token XMLELEMENT
%token XMLATTRIBUTES
%token XMLFOREST
%token XMLPARSE
%token STRIP
%token WHITESPACE
%token XMLPI
%token XMLQUERY
%token PASSING
%token XMLTEXT
%token NIL
%token REF
%token ABSENT
%token EMPTY
%token DOCUMENT
%token ELEMENT
%token CONTENT
%token XMLNAMESPACES
%token NAMESPACE
%token XMLVALIDATE
%token RETURNING
%token LOCATION
%token ID
%token ACCORDING
%token XMLSCHEMA
%token URI
%token XMLAGG
%token FIELD
%token FILTER
%token UNION
%token EXCEPT
%token INTERSECT
%token CORRESPONDING
%token DATA
%token '('
%token ')'
%token '{'
%token '}'
%token NOT
%token '='
%token ALL
%token ANY
%token NOT_BETWEEN
%token BETWEEN
%token NOT_IN
%token sqlIN
%token NOT_EXISTS
%token EXISTS
%token NOT_LIKE
%token LIKE
%token NOT_ILIKE
%token ILIKE
%token OR
%token SOME
%token AND
%token COMPARISON
%token '+'
%token '-'
%token '&'
%token '|'
%token '^'
%token LEFT_SHIFT
%token RIGHT_SHIFT
%token LEFT_SHIFT_ASSIGN
%token RIGHT_SHIFT_ASSIGN
%token CONCATSTRING
%token SUBSTRING
%token TRIM
%token POSITION
%token SPLIT_PART
%token '*'
%token '/'
%token '%'
%token '~'
%token GEOM_OVERLAP
%token GEOM_OVERLAP_OR_ABOVE
%token GEOM_OVERLAP_OR_BELOW
%token GEOM_OVERLAP_OR_LEFT
%token GEOM_OVERLAP_OR_RIGHT
%token GEOM_BELOW
%token GEOM_ABOVE
%token GEOM_DIST
%token GEOM_MBR_EQUAL
%token TEMP
%token TEMPORARY
%token MERGE
%token REMOTE
%token REPLICA
%token UNLOGGED
%token ASC
%token DESC
%token AUTHORIZATION
%token CHECK
%token CONSTRAINT
%token CREATE
%token COMMENT
%token NULLS
%token FIRST
%token LAST
%token TYPE
%token PROCEDURE
%token FUNCTION
%token sqlLOADER
%token AGGREGATE
%token RETURNS
%token EXTERNAL
%token sqlNAME
%token DECLARE
%token CALL
%token LANGUAGE
%token ANALYZE
%token MINMAX
%token SQL_EXPLAIN
%token SQL_PLAN
%token SQL_TRACE
%token PREP
%token PREPARE
%token EXEC
%token EXECUTE
%token DEALLOCATE
%token DEFAULT
%token DISTINCT
%token DROP
%token TRUNCATE
%token FOREIGN
%token RENAME
%token ENCRYPTED
%token UNENCRYPTED
%token PASSWORD
%token GRANT
%token REVOKE
%token ROLE
%token ADMIN
%token INTO
%token IS
%token KEY
%token ON
%token OPTION
%token OPTIONS
%token PATH
%token PRIMARY
%token PRIVILEGES
%token PUBLIC
%token REFERENCES
%token SCHEMA
%token SET
%token AUTO_COMMIT
%token RETURN
%token LEADING
%token TRAILING
%token BOTH
%token ALTER
%token ADD
%token TABLE
%token COLUMN
%token TO
%token UNIQUE
%token VALUES
%token VIEW
%token WHERE
%token WITH
%token WITHOUT
%token sqlDATE
%token TIME
%token TIMESTAMP
%token INTERVAL
%token CENTURY
%token DECADE
%token YEAR
%token QUARTER
%token DOW
%token DOY
%token MONTH
%token WEEK
%token DAY
%token HOUR
%token MINUTE
%token SECOND
%token EPOCH
%token ZONE
%token LIMIT
%token OFFSET
%token SAMPLE
%token SEED
%token FETCH
%token CASE
%token WHEN
%token THEN
%token ELSE
%token NULLIF
%token COALESCE
%token IFNULL
%token IF
%token ELSEIF
%token WHILE
%token DO
%token ATOMIC
%token BEGIN
%token END
%token COPY
%token RECORDS
%token DELIMITERS
%token STDIN
%token STDOUT
%token FWF
%token CLIENT
%token SERVER
%token INDEX
%token REPLACE
%token AS
%token TRIGGER
%token OF
%token BEFORE
%token AFTER
%token ROW
%token STATEMENT
%token sqlNEW
%token OLD
%token EACH
%token REFERENCING
%token OVER
%token PARTITION
%token CURRENT
%token EXCLUDE
%token FOLLOWING
%token PRECEDING
%token OTHERS
%token TIES
%token RANGE
%token UNBOUNDED
%token GROUPS
%token WINDOW
%token X_BODY
%token MAX_MEMORY
%token MAX_WORKERS
%token OPTIMIZER
%token DAYNAME
%token MONTHNAME
%token TIMESTAMPADD
%token TIMESTAMPDIFF
%token SQL_BIGINT
%token SQL_BINARY
%token SQL_BIT
%token SQL_CHAR
%token SQL_DATE
%token SQL_DECIMAL
%token SQL_DOUBLE
%token SQL_FLOAT
%token SQL_GUID
%token SQL_HUGEINT
%token SQL_INTEGER
%token SQL_INTERVAL_DAY
%token SQL_INTERVAL_DAY_TO_HOUR
%token SQL_INTERVAL_DAY_TO_MINUTE
%token SQL_INTERVAL_DAY_TO_SECOND
%token SQL_INTERVAL_HOUR
%token SQL_INTERVAL_HOUR_TO_MINUTE
%token SQL_INTERVAL_HOUR_TO_SECOND
%token SQL_INTERVAL_MINUTE
%token SQL_INTERVAL_MINUTE_TO_SECOND
%token SQL_INTERVAL_MONTH
%token SQL_INTERVAL_SECOND
%token SQL_INTERVAL_YEAR
%token SQL_INTERVAL_YEAR_TO_MONTH
%token SQL_LONGVARBINARY
%token SQL_LONGVARCHAR
%token SQL_NUMERIC
%token SQL_REAL
%token SQL_SMALLINT
%token SQL_TIME
%token SQL_TIMESTAMP
%token SQL_TINYINT
%token SQL_VARBINARY
%token SQL_VARCHAR
%token SQL_WCHAR
%token SQL_WLONGVARCHAR
%token SQL_WVARCHAR
%token SQL_TSI_FRAC_SECOND
%token SQL_TSI_SECOND
%token SQL_TSI_MINUTE
%token SQL_TSI_HOUR
%token SQL_TSI_DAY
%token SQL_TSI_WEEK
%token SQL_TSI_MONTH
%token SQL_TSI_QUARTER
%token SQL_TSI_YEAR
%token ODBC_DATE_ESCAPE_PREFIX
%token ODBC_TIME_ESCAPE_PREFIX
%token ODBC_TIMESTAMP_ESCAPE_PREFIX
%token ODBC_GUID_ESCAPE_PREFIX
%token ODBC_FUNC_ESCAPE_PREFIX
%token ODBC_OJ_ESCAPE_PREFIX
%token ':'
%token ','
%token '.'
%token '['
%token ']'
%token '?'

%right /*1*/ STRING USTRING XSTRING
%right /*2*/ X_BODY
%left /*3*/ UNION EXCEPT INTERSECT CORRESPONDING
%left /*4*/ LEFT RIGHT FULL NATURAL CROSS JOIN INNER
%left /*5*/ DATA WITH
%left /*6*/ '(' ')' '{' '}'
%left /*7*/ NOT
%left /*8*/ '='
%left /*9*/ ALL ANY NOT_BETWEEN BETWEEN NOT_IN sqlIN NOT_EXISTS EXISTS NOT_LIKE LIKE NOT_ILIKE ILIKE OR SOME
%left /*10*/ AND
%left /*11*/ COMPARISON
%left /*12*/ '+' '-' '&' '|' '^' LEFT_SHIFT RIGHT_SHIFT LEFT_SHIFT_ASSIGN RIGHT_SHIFT_ASSIGN CONCATSTRING SUBSTRING TRIM POSITION SPLIT_PART
%left /*13*/ '*' '/' '%'
%left /*14*/ UMINUS
%left /*15*/ '~'
%left /*16*/ GEOM_OVERLAP GEOM_OVERLAP_OR_ABOVE GEOM_OVERLAP_OR_BELOW GEOM_OVERLAP_OR_LEFT
%left /*17*/ GEOM_OVERLAP_OR_RIGHT GEOM_BELOW GEOM_ABOVE GEOM_DIST GEOM_MBR_EQUAL

%start input

%%

input :
    sqlstmt
    | input sqlstmt
    ;

sqlstmt :
	sql SCOLON
	| sql ':' named_arg_list_ref SCOLON
	| prepare sql SCOLON
	| SQL_PLAN sql SCOLON
	| SQL_EXPLAIN sql SCOLON
	| SQL_TRACE sqlstmt
	| exec SCOLON
	| dealloc SCOLON
	| /*empty*/
	| SCOLON
	//| error SCOLON
	| LEX_ERROR
	;

prepare :
	PREPARE
	| PREP
	;

execute :
	EXECUTE
	| EXEC
	;

opt_prepare :
	/*empty*/
	| prepare
	;

deallocate :
	DEALLOCATE
	;

create :
	CREATE
	;

create_or_replace :
	create
	| CREATE OR /*9L*/ REPLACE
	;

if_exists :
	/*empty*/
	| IF EXISTS /*9L*/
	;

if_not_exists :
	/*empty*/
	| IF NOT_EXISTS /*9L*/
	;

drop :
	DROP
	;

set :
	SET
	;

declare :
	DECLARE
	;

sql :
	schema
	| grant
	| revoke
	| create_statement
	| drop_statement
	| alter_statement
	| declare_statement
	| set_statement
	| ANALYZE qname opt_column_list opt_sample opt_minmax
	| call_procedure_statement
	| comment_on_statement
	;

opt_minmax :
	/*empty*/
	| MINMAX
	;

declare_statement :
	declare variable_list
	| declare table_def
	;

variable_ref_commalist :
	variable_ref
	| variable_ref_commalist ',' variable_ref
	;

variable_list :
	variable_ref_commalist data_type
	| variable_list ',' variable_ref_commalist data_type
	;

opt_equal :
	'=' /*8L*/
	| /*empty*/
	;

set_statement :
	set variable_ref '=' /*8L*/ search_condition
	| set variable_ref_commalist_parens '=' /*8L*/ subquery
	| set sqlSESSION AUTHORIZATION opt_equal ident
	| set session_schema opt_equal ident
	| set session_user opt_equal ident
	| set session_role opt_equal ident
	| set session_timezone opt_equal LOCAL
	| set session_timezone opt_equal literal
	;

schema :
	create SCHEMA if_not_exists schema_name_clause opt_schema_default_char_set opt_path_specification opt_schema_element_list
	| drop SCHEMA if_exists qname drop_action
	;

schema_name_clause :
	ident
	| AUTHORIZATION authorization_identifier
	| ident AUTHORIZATION authorization_identifier
	;

authorization_identifier :
	ident
	;

opt_schema_default_char_set :
	/*empty*/
	| DEFAULT CHARACTER SET ident
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
	grant
	| revoke
	| create_statement
	| drop_statement
	| alter_statement
	;

opt_grantor :
	/*empty*/
	| WITH /*5L*/ ADMIN grantor
	;

grantor :
	CURRENT_USER
	| CURRENT_ROLE
	;

grant :
	GRANT privileges TO grantee_commalist opt_with_grant opt_from_grantor
	| GRANT authid_list TO grantee_commalist opt_with_admin opt_from_grantor
	;

authid_list :
	authid
	| authid_list ',' authid
	;

opt_with_grant :
	/*empty*/
	| WITH /*5L*/ GRANT OPTION
	;

opt_with_admin :
	/*empty*/
	| WITH /*5L*/ ADMIN OPTION
	;

opt_from_grantor :
	/*empty*/
	| FROM grantor
	;

revoke :
	REVOKE opt_grant_for privileges FROM grantee_commalist opt_from_grantor
	| REVOKE opt_admin_for authid_list FROM grantee_commalist opt_from_grantor
	;

opt_grant_for :
	/*empty*/
	| GRANT OPTION FOR
	;

opt_admin_for :
	/*empty*/
	| ADMIN OPTION FOR
	;

privileges :
	global_privileges
	| object_privileges ON object_name
	;

global_privileges :
	global_privilege
	| global_privilege ',' global_privilege
	;

global_privilege :
	COPY FROM
	| COPY INTO
	;

object_name :
	TABLE qname
	| qname
	| routine_designator
	;

object_privileges :
	ALL /*9L*/ PRIVILEGES
	| ALL /*9L*/
	| operation_commalist
	;

operation_commalist :
	operation
	| operation_commalist ',' operation
	;

operation :
	INSERT
	| sqlDELETE
	| TRUNCATE
	| UPDATE opt_column_list
	| SELECT opt_column_list
	| REFERENCES opt_column_list
	| execute
	;

grantee_commalist :
	grantee
	| grantee_commalist ',' grantee
	;

grantee :
	PUBLIC
	| authid
	;

alter_statement :
	ALTER TABLE if_exists qname ADD opt_column add_table_element
	| ALTER TABLE if_exists qname ADD TABLE qname opt_as_partition
	| ALTER TABLE if_exists qname ALTER alter_table_element
	| ALTER TABLE if_exists qname DROP drop_table_element
	| ALTER TABLE if_exists qname SET READ ONLY
	| ALTER TABLE if_exists qname SET INSERT ONLY
	| ALTER TABLE if_exists qname SET READ WRITE
	| ALTER TABLE if_exists qname SET TABLE qname opt_as_partition
	| ALTER TABLE if_exists qname RENAME TO ident
	| ALTER TABLE if_exists qname RENAME opt_column ident TO ident
	| ALTER TABLE if_exists qname SET SCHEMA ident
	| ALTER USER ident opt_with_encrypted_password user_schema opt_schema_path opt_default_role opt_max_memory opt_max_workers
	| ALTER USER ident RENAME TO ident
	| ALTER USER SET opt_encrypted PASSWORD string USING OLD PASSWORD string
	| ALTER SCHEMA if_exists ident RENAME TO ident
	;

opt_with_encrypted_password :
	WITH /*5L*/ opt_encrypted PASSWORD string
	| /*empty*/
	;

user_schema :
	SET SCHEMA ident
	| /*empty*/
	;

opt_schema_path :
	SCHEMA PATH string
	| /*empty*/
	;

alter_table_element :
	opt_column ident SET DEFAULT default_value
	| opt_column ident SET sqlNULL
	| opt_column ident SET NOT /*7L*/ sqlNULL
	| opt_column ident DROP DEFAULT
	| opt_column ident SET STORAGE string
	| opt_column ident SET STORAGE sqlNULL
	;

drop_table_element :
	opt_column ident drop_action
	| CONSTRAINT ident drop_action
	| TABLE qname drop_action
	;

opt_column :
	COLUMN
	| /*empty*/
	;

create_statement :
	create role_def
	| create table_def
	| view_def
	| type_def
	| func_def
	| index_def
	| seq_def
	| trigger_def
	;

seq_def :
	create SEQUENCE qname opt_seq_params
	| drop SEQUENCE qname
	| ALTER SEQUENCE qname opt_alt_seq_params
	;

opt_seq_params :
	params_list
	| /*empty*/
	;

params_list :
	opt_seq_param
	| params_list opt_seq_param
	;

opt_alt_seq_params :
	opt_alt_seq_param
	| opt_alt_seq_params opt_alt_seq_param
	;

opt_seq_param :
	AS data_type
	| START WITH /*5L*/ opt_sign lngval
	| opt_seq_common_param
	;

opt_alt_seq_param :
	AS data_type
	| RESTART
	| RESTART WITH /*5L*/ opt_sign lngval
	| RESTART WITH /*5L*/ subquery
	| opt_seq_common_param
	;

opt_seq_common_param :
	INCREMENT BY opt_sign lngval
	| MINVALUE opt_sign lngval
	| NO MINVALUE
	| MAXVALUE opt_sign lngval
	| NO MAXVALUE
	| CACHE nonzerolng
	| CYCLE
	| NO CYCLE
	;

index_def :
	create opt_index_type INDEX ident ON qname '(' /*6L*/ ident_commalist ')' /*6L*/
	;

opt_index_type :
	UNIQUE
	| ORDERED
	| IMPRINTS
	| /*empty*/
	;

role_def :
	ROLE ident opt_grantor
	| USER ident WITH /*5L*/ opt_encrypted PASSWORD string sqlNAME string opt_schema_details_list opt_max_memory opt_max_workers opt_optimizer opt_default_role
	;

opt_max_memory :
	/*empty*/
	| NO MAX_MEMORY
	| MAX_MEMORY poslng
	;

opt_max_workers :
	/*empty*/
	| NO MAX_WORKERS
	| MAX_WORKERS posint
	;

opt_optimizer :
	/*empty*/
	| OPTIMIZER string
	;

opt_default_role :
	/*empty*/
	| DEFAULT ROLE ident
	;

opt_schema_details_list :
	opt_schema_path
	| SCHEMA ident opt_schema_path
	;

opt_encrypted :
	/*empty*/
	| UNENCRYPTED
	| ENCRYPTED
	;

table_def :
	TABLE if_not_exists qname table_content_source
	| TABLE if_not_exists qname FROM sqlLOADER func_ref
	| MERGE TABLE if_not_exists qname table_content_source opt_partition_by
	| REPLICA TABLE if_not_exists qname table_content_source
	| REMOTE TABLE if_not_exists qname table_content_source ON string with_opt_credentials
	| UNLOGGED TABLE if_not_exists qname table_content_source
	| opt_temp TABLE if_not_exists qname table_content_source opt_on_commit
	;

partition_type :
	RANGE
	| VALUES
	;

partition_expression :
	search_condition
	;

partition_on :
	ON '(' /*6L*/ ident ')' /*6L*/
	| USING '(' /*6L*/ partition_expression ')' /*6L*/
	;

opt_partition_by :
	/*empty*/
	| PARTITION BY partition_type partition_on
	;

partition_list_value :
	search_condition
	;

partition_range_from :
	search_condition
	| RANGE MINVALUE
	;

partition_range_to :
	search_condition
	| RANGE MAXVALUE
	;

partition_list :
	partition_list_value
	| partition_list ',' partition_list_value
	;

opt_with_nulls :
	/*empty*/
	| WITH /*5L*/ sqlNULL VALUES
	;

opt_partition_spec :
	sqlIN /*9L*/ '(' /*6L*/ partition_list ')' /*6L*/ opt_with_nulls
	| FROM partition_range_from TO partition_range_to opt_with_nulls
	| FOR sqlNULL VALUES
	;

opt_as_partition :
	/*empty*/
	| AS PARTITION opt_partition_spec
	;

with_opt_credentials :
	/*empty*/
	| WITH /*5L*/ USER string opt_encrypted PASSWORD string
	| WITH /*5L*/ opt_encrypted PASSWORD string
	;

opt_temp :
	TEMPORARY
	| TEMP
	| LOCAL TEMPORARY
	| LOCAL TEMP
	| GLOBAL TEMPORARY
	| GLOBAL TEMP
	;

opt_on_commit :
	/*empty*/
	| ON COMMIT sqlDELETE ROWS
	| ON COMMIT PRESERVE ROWS
	| ON COMMIT DROP
	;

table_content_source :
	'(' /*6L*/ table_element_list ')' /*6L*/
	| as_subquery_clause
	;

as_subquery_clause :
	opt_column_list AS query_expression_def with_or_without_data
	;

with_or_without_data :
	/*empty*/
	| WITH /*5L*/ NO DATA /*5L*/
	| WITH /*5L*/ DATA /*5L*/
	;

table_element_list :
	table_element
	| table_element_list ',' table_element
	;

add_table_element :
	column_def
	| table_constraint
	;

table_element :
	add_table_element
	| column_options
	| like_table
	;

serial_or_bigserial :
	SERIAL
	| BIGSERIAL
	;

column_def :
	column data_type opt_column_def_opt_list
	| column serial_or_bigserial
	;

opt_column_def_opt_list :
	/*empty*/
	| column_def_opt_list
	;

column_def_opt_list :
	column_option
	| column_def_opt_list column_option
	;

column_options :
	ident WITH /*5L*/ OPTIONS '(' /*6L*/ column_option_list ')' /*6L*/
	;

column_option_list :
	column_option
	| column_option_list ',' column_option
	;

column_option :
	default
	| column_constraint
	| generated_column
	;

default :
	DEFAULT default_value
	;

default_value :
	search_condition
	;

column_constraint :
	opt_constraint_name column_constraint_type
	;

always_or_by_default :
	ALWAYS
	| BY DEFAULT
	;

generated_column :
	GENERATED always_or_by_default AS IDENTITY serial_opt_params
	| AUTO_INCREMENT
	;

serial_opt_params :
	/*empty*/
	| '(' /*6L*/ params_list ')' /*6L*/
	;

table_constraint :
	opt_constraint_name table_constraint_type
	;

opt_constraint_name :
	/*empty*/
	| CONSTRAINT ident
	;

ref_action :
	NO ACTION
	| CASCADE
	| RESTRICT
	| SET sqlNULL
	| SET DEFAULT
	;

ref_on_update :
	ON UPDATE ref_action
	;

ref_on_delete :
	ON sqlDELETE ref_action
	;

opt_ref_action :
	/*empty*/
	| ref_on_update
	| ref_on_delete
	| ref_on_delete ref_on_update
	| ref_on_update ref_on_delete
	;

opt_match_type :
	/*empty*/
	| FULL /*4L*/
	| PARTIAL
	| SIMPLE
	;

opt_match :
	/*empty*/
	| MATCH opt_match_type
	;

column_constraint_type :
	NOT /*7L*/ sqlNULL
	| sqlNULL
	| UNIQUE
	| UNIQUE NULLS DISTINCT
	| UNIQUE NULLS NOT /*7L*/ DISTINCT
	| PRIMARY KEY
	| REFERENCES qname opt_column_list opt_match opt_ref_action
	| domain_constraint_type
	;

table_constraint_type :
	UNIQUE column_commalist_parens
	| UNIQUE NULLS DISTINCT column_commalist_parens
	| UNIQUE NULLS NOT /*7L*/ DISTINCT column_commalist_parens
	| PRIMARY KEY column_commalist_parens
	| FOREIGN KEY column_commalist_parens REFERENCES qname opt_column_list opt_match opt_ref_action
	;

domain_constraint_type :
	CHECK '(' /*6L*/ search_condition ')' /*6L*/
	;

ident_commalist :
	ident
	| ident_commalist ',' ident
	;

like_table :
	LIKE /*9L*/ qname
	;

view_def :
	create_or_replace VIEW qname opt_column_list AS query_expression_def opt_with_check_option
	;

query_expression_def :
	query_expression
	| '(' /*6L*/ query_expression_def ')' /*6L*/
	;

query_expression :
	select_no_parens_orderby
	| with_query
	;

opt_with_check_option :
	/*empty*/
	| WITH /*5L*/ CHECK OPTION
	;

opt_column_list :
	/*empty*/
	| column_commalist_parens
	;

column_commalist_parens :
	'(' /*6L*/ ident_commalist ')' /*6L*/
	;

variable_ref_commalist_parens :
	'(' /*6L*/ variable_ref_commalist ')' /*6L*/
	;

type_def :
	create TYPE qname EXTERNAL sqlNAME ident
	;

external_function_name :
	ident '.' ident
	;

function_body :
	X_BODY /*2R*/
	| string
	;

func_def_type :
	FUNCTION
	| PROCEDURE
	| AGGREGATE
	| AGGREGATE FUNCTION
	| FILTER
	| FILTER FUNCTION
	| WINDOW
	| WINDOW FUNCTION
	| sqlLOADER
	| sqlLOADER FUNCTION
	;

func_def_opt_return :
	RETURNS func_data_type
	| /*empty*/
	;

func_def :
	create_or_replace func_def_type qname '(' /*6L*/ opt_paramlist ')' /*6L*/ func_def_opt_return EXTERNAL sqlNAME external_function_name
	| create_or_replace func_def_type qname '(' /*6L*/ opt_paramlist ')' /*6L*/ func_def_opt_return routine_body
	| create_or_replace func_def_type qname '(' /*6L*/ opt_paramlist ')' /*6L*/ func_def_opt_return LANGUAGE IDENT function_body
	;

routine_body :
	procedure_statement
	| BEGIN procedure_statement_list procedure_statement SCOLON END
	| BEGIN ATOMIC procedure_statement_list procedure_statement SCOLON END
	;

procedure_statement_list :
	/*empty*/
	| procedure_statement_list procedure_statement SCOLON
	;

trigger_procedure_statement_list :
	/*empty*/
	| trigger_procedure_statement_list trigger_procedure_statement SCOLON
	;

procedure_statement :
	transaction_statement
	| update_statement
	| schema
	| grant
	| revoke
	| create_statement
	| drop_statement
	| alter_statement
	| declare_statement
	| set_statement
	| control_statement
	| select_statement_single_row
	;

trigger_procedure_statement :
	transaction_statement
	| update_statement
	| grant
	| revoke
	| declare_statement
	| set_statement
	| control_statement
	| select_statement_single_row
	;

control_statement :
	call_procedure_statement
	| call_statement
	| while_statement
	| if_statement
	| case_statement
	| return_statement
	;

call_statement :
	CALL routine_invocation
	;

call_procedure_statement :
	CALL func_ref
	| '{' /*6L*/ CALL func_ref '}' /*6L*/
	;

routine_invocation :
	routine_name '(' /*6L*/ argument_list ')' /*6L*/
	;

routine_name :
	qname
	;

argument_list :
	/*empty*/
	| search_condition
	| argument_list ',' search_condition
	;

return_statement :
	RETURN return_value
	;

return_value :
	query_expression
	| search_condition
	| TABLE '(' /*6L*/ query_expression ')' /*6L*/
	;

case_statement :
	CASE search_condition when_statements case_opt_else_statement END CASE
	| CASE when_search_statements case_opt_else_statement END CASE
	;

when_statement :
	WHEN search_condition THEN procedure_statement_list
	;

when_statements :
	when_statement
	| when_statements when_statement
	;

when_search_statement :
	WHEN search_condition THEN procedure_statement_list
	;

when_search_statements :
	when_search_statement
	| when_search_statements when_search_statement
	;

case_opt_else_statement :
	/*empty*/
	| ELSE procedure_statement_list
	;

if_statement :
	IF search_condition THEN procedure_statement_list elseif_list_opt else_opt END IF
	;

else_opt :
	/*empty*/
	| ELSE procedure_statement_list
	;

elseif_list_opt :
	/*empty*/
	| elseif_list_opt elseif
	;

elseif :
	ELSEIF search_condition THEN procedure_statement_list
	;

while_statement :
	opt_begin_label WHILE search_condition DO procedure_statement_list END WHILE opt_end_label
	;

opt_begin_label :
	/*empty*/
	| ident ':'
	;

opt_end_label :
	/*empty*/
	| ident
	;

table_function_column_list :
	column data_type
	| table_function_column_list ',' column data_type
	;

func_data_type :
	TABLE '(' /*6L*/ table_function_column_list ')' /*6L*/
	| data_type
	;

opt_paramlist :
	paramlist
	| '*' /*13L*/
	| /*empty*/
	;

paramlist :
	paramlist ',' ident data_type
	| ident data_type
	;

trigger_def :
	create_or_replace TRIGGER qname trigger_action_time trigger_event opt_qname opt_referencing_list triggered_action
	;

opt_qname :
	/*empty*/
	| ON qname
	;

trigger_action_time :
	BEFORE
	| AFTER
	;

trigger_event :
	INSERT
	| sqlDELETE
	| TRUNCATE
	| UPDATE
	| UPDATE OF ident_commalist
	| LOGIN
	;

opt_referencing_list :
	/*empty*/
	| REFERENCING old_or_new_values_alias_list
	;

old_or_new_values_alias_list :
	old_or_new_values_alias
	| old_or_new_values_alias_list old_or_new_values_alias
	;

old_or_new_values_alias :
	OLD opt_row opt_as ident
	| sqlNEW opt_row opt_as ident
	| OLD TABLE opt_as ident
	| sqlNEW TABLE opt_as ident
	;

opt_as :
	/*empty*/
	| AS
	;

opt_row :
	/*empty*/
	| ROW
	;

triggered_action :
	opt_for_each opt_when triggered_statement
	;

opt_for_each :
	/*empty*/
	| FOR EACH row_or_statement
	;

row_or_statement :
	ROW
	| STATEMENT
	;

opt_when :
	/*empty*/
	| WHEN '(' /*6L*/ search_condition ')' /*6L*/
	;

triggered_statement :
	trigger_procedure_statement
	| BEGIN ATOMIC trigger_procedure_statement_list END
	;

routine_designator :
	func_def_type qname opt_typelist
	;

drop_statement :
	drop TABLE if_exists qname drop_action
	| drop func_def_type if_exists qname opt_typelist drop_action
	| drop ALL /*9L*/ func_def_type qname drop_action
	| drop VIEW if_exists qname drop_action
	| drop TYPE qname drop_action
	| drop ROLE ident
	| drop USER ident
	| drop INDEX qname
	| drop TRIGGER if_exists qname
	;

opt_typelist :
	/*empty*/
	| '(' /*6L*/ typelist ')' /*6L*/
	| '(' /*6L*/ ')' /*6L*/
	;

typelist :
	data_type
	| typelist ',' data_type
	;

drop_action :
	/*empty*/
	| RESTRICT
	| CASCADE
	;

sql :
	transaction_statement
	| update_statement
	;

update_statement :
	delete_stmt
	| truncate_stmt
	| insert_stmt
	| update_stmt
	| merge_stmt
	| copyfrom_stmt
	| copyto_stmt
	;

transaction_statement :
	transaction_stmt
	;

start_transaction :
	START
	| BEGIN
	;

transaction_stmt :
	COMMIT opt_work opt_chain
	| SAVEPOINT ident
	| RELEASE SAVEPOINT ident
	| ROLLBACK opt_work opt_chain opt_to_savepoint
	| start_transaction TRANSACTION transaction_mode_list
	| SET LOCAL TRANSACTION transaction_mode_list
	| SET TRANSACTION transaction_mode_list
	;

transaction_mode_list :
	/*empty*/
	| _transaction_mode_list
	;

_transaction_mode_list :
	transaction_mode
	| _transaction_mode_list ',' transaction_mode
	;

transaction_mode :
	READ ONLY
	| READ WRITE
	| ISOLATION LEVEL iso_level
	| DIAGNOSTICS sqlSIZE intval
	;

iso_level :
	READ UNCOMMITTED
	| READ COMMITTED
	| sqlREPEATABLE READ
	| SNAPSHOT
	| SERIALIZABLE
	;

opt_work :
	WORK
	| /*empty*/
	;

opt_chain :
	AND /*10L*/ CHAIN
	| AND /*10L*/ NO CHAIN
	| /*empty*/
	;

opt_to_savepoint :
	/*empty*/
	| TO SAVEPOINT ident
	;

opt_on_location :
	/*empty*/
	| ON CLIENT
	| ON SERVER
	;

copyfrom_stmt :
	COPY opt_nr INTO qname opt_column_list FROM string_commalist opt_header_list opt_on_location opt_seps opt_escape opt_null_string opt_best_effort opt_fwf_widths
	| COPY opt_nr INTO qname opt_column_list FROM STDIN opt_header_list opt_seps opt_escape opt_null_string opt_best_effort
	| COPY sqlLOADER INTO qname FROM func_ref
	| COPY opt_endianness BINARY INTO qname opt_column_list FROM string_commalist opt_on_location
	;

copyto_stmt :
	COPY query_expression_def INTO string opt_on_location opt_seps opt_null_string
	| COPY query_expression_def INTO STDOUT opt_seps opt_null_string
	| COPY query_expression_def INTO opt_endianness BINARY string_commalist opt_on_location
	;

opt_fwf_widths :
	/*empty*/
	| FWF '(' /*6L*/ fwf_widthlist ')' /*6L*/
	;

fwf_widthlist :
	poslng
	| fwf_widthlist ',' poslng
	;

opt_header_list :
	/*empty*/
	| '(' /*6L*/ header_list ')' /*6L*/
	;

header_list :
	header
	| header_list ',' header
	;

header :
	ident
	| ident string
	;

opt_seps :
	/*empty*/
	| opt_using DELIMITERS string
	| opt_using DELIMITERS string ',' string
	| opt_using DELIMITERS string ',' string ',' string
	;

opt_using :
	/*empty*/
	| USING
	;

opt_nr :
	/*empty*/
	| poslng RECORDS
	| OFFSET poslng
	| poslng OFFSET poslng RECORDS
	| poslng RECORDS OFFSET poslng
	;

opt_null_string :
	/*empty*/
	| sqlNULL opt_as string
	;

opt_escape :
	/*empty*/
	| ESCAPE
	| NO ESCAPE
	;

opt_best_effort :
	/*empty*/
	| BEST EFFORT
	;

string_commalist :
	string_commalist_contents
	| '(' /*6L*/ string_commalist_contents ')' /*6L*/
	;

string_commalist_contents :
	string
	| string_commalist_contents ',' string
	;

opt_endianness :
	/*empty*/
	| BIG ENDIAN
	| LITTLE ENDIAN
	| NATIVE ENDIAN
	;

delete_stmt :
	sqlDELETE FROM qname opt_alias_name opt_where_clause
	;

check_identity :
	/*empty*/
	| CONTINUE IDENTITY
	| RESTART IDENTITY
	;

truncate_stmt :
	TRUNCATE TABLE qname check_identity drop_action
	| TRUNCATE qname check_identity drop_action
	;

update_stmt :
	UPDATE qname opt_alias_name SET assignment_commalist opt_from_clause opt_where_clause
	;

opt_search_condition :
	/*empty*/
	| AND /*10L*/ search_condition
	;

merge_update_or_delete :
	UPDATE SET assignment_commalist
	| sqlDELETE
	;

merge_insert :
	INSERT opt_column_list values_or_query_spec
	;

merge_match_clause :
	WHEN MATCHED opt_search_condition THEN merge_update_or_delete
	| WHEN NOT /*7L*/ MATCHED opt_search_condition THEN merge_insert
	;

merge_when_list :
	merge_match_clause
	| merge_when_list merge_match_clause
	;

merge_stmt :
	MERGE INTO qname opt_alias_name USING table_ref ON search_condition merge_when_list
	;

insert_stmt :
	INSERT INTO qname values_or_query_spec
	| INSERT INTO qname column_commalist_parens values_or_query_spec
	;

values_or_query_spec :
	/*empty*/
	| DEFAULT VALUES
	| query_expression
	;

row_commalist :
	'(' /*6L*/ atom_commalist ')' /*6L*/
	| row_commalist ',' '(' /*6L*/ atom_commalist ')' /*6L*/
	;

atom_commalist :
	insert_atom
	| atom_commalist ',' insert_atom
	;

value_commalist :
	value
	| value_commalist ',' value
	;

named_value_commalist :
	ident value
	| named_value_commalist ',' ident value
	;

null :
	sqlNULL
	;

insert_atom :
	search_condition
	| DEFAULT
	;

value :
	search_condition
	| select_no_parens
	| with_query
	;

opt_distinct :
	/*empty*/
	| ALL /*9L*/
	| DISTINCT
	;

assignment_commalist :
	assignment
	| assignment_commalist ',' assignment
	;

assignment :
	column '=' /*8L*/ insert_atom
	| column_commalist_parens '=' /*8L*/ subquery
	;

opt_where_clause :
	/*empty*/
	| WHERE search_condition
	;

joined_table :
	'(' /*6L*/ joined_table ')' /*6L*/
	| table_ref CROSS /*4L*/ JOIN /*4L*/ table_ref
	| table_ref join_type JOIN /*4L*/ table_ref join_spec
	| table_ref NATURAL /*4L*/ join_type JOIN /*4L*/ table_ref
	| '{' /*6L*/ ODBC_OJ_ESCAPE_PREFIX table_ref outer_join_type OUTER JOIN /*4L*/ table_ref join_spec '}' /*6L*/
	;

join_type :
	/*empty*/
	| INNER /*4L*/
	| outer_join_type opt_outer
	;

opt_outer :
	/*empty*/
	| OUTER
	;

outer_join_type :
	LEFT /*4L*/
	| RIGHT /*4L*/
	| FULL /*4L*/
	;

join_spec :
	ON search_condition
	| USING column_commalist_parens
	;

sql :
	with_query
	;

with_query :
	WITH /*5L*/ with_list with_query_expression
	;

with_list :
	with_list ',' with_list_element
	| with_list_element
	;

with_list_element :
	ident opt_column_list AS subquery_with_orderby
	;

with_query_expression :
	select_no_parens_orderby
	| select_statement_single_row
	| delete_stmt
	| insert_stmt
	| update_stmt
	| merge_stmt
	;

sql :
	select_statement_single_row
	| select_no_parens_orderby
	;

simple_select :
	SELECT opt_distinct selection table_exp
	;

select_statement_single_row :
	SELECT opt_distinct selection INTO variable_ref_commalist table_exp
	;

select_no_parens_orderby :
	select_no_parens opt_order_by_clause opt_limit opt_offset opt_sample opt_seed
	| select_no_parens opt_order_by_clause opt_offset_rows opt_fetch opt_sample opt_seed
	;

select_no_parens :
	select_no_parens UNION /*3L*/ set_distinct opt_corresponding select_no_parens
	| select_no_parens OUTER UNION /*3L*/ set_distinct opt_corresponding select_no_parens
	| select_no_parens EXCEPT /*3L*/ set_distinct opt_corresponding select_no_parens
	| select_no_parens INTERSECT /*3L*/ set_distinct opt_corresponding select_no_parens
	| VALUES row_commalist
	| '(' /*6L*/ select_no_parens ')' /*6L*/
	| simple_select
	;

set_distinct :
	/*empty*/
	| ALL /*9L*/
	| DISTINCT
	;

opt_corresponding :
	/*empty*/
	| CORRESPONDING /*3L*/
	| CORRESPONDING /*3L*/ BY '(' /*6L*/ column_ref_commalist ')' /*6L*/
	;

selection :
	column_exp_commalist
	;

table_exp :
	opt_from_clause opt_window_clause opt_where_clause opt_group_by_clause opt_having_clause
	;

window_definition :
	ident AS '(' /*6L*/ window_specification ')' /*6L*/
	;

window_definition_list :
	window_definition
	| window_definition_list ',' window_definition
	;

opt_window_clause :
	/*empty*/
	| WINDOW window_definition_list
	;

opt_from_clause :
	/*empty*/
	| FROM table_ref_commalist
	;

table_ref_commalist :
	table_ref
	| table_ref_commalist ',' table_ref
	;

table_ref :
	qname opt_table_name
	| string opt_table_name
	| func_ref opt_table_name
	| LATERAL func_ref opt_table_name
	| subquery_with_orderby table_name
	| LATERAL subquery table_name
	| subquery_with_orderby
	| joined_table
	;

table_name :
	AS ident '(' /*6L*/ ident_commalist ')' /*6L*/
	| AS ident
	| ident '(' /*6L*/ ident_commalist ')' /*6L*/
	| ident
	;

opt_table_name :
	/*empty*/
	| table_name
	;

opt_group_by_clause :
	/*empty*/
	| sqlGROUP BY group_by_list
	;

group_by_list :
	group_by_element
	| group_by_list ',' group_by_element
	;

group_by_element :
	search_condition
	| ROLLUP '(' /*6L*/ ordinary_grouping_set ')' /*6L*/
	| CUBE '(' /*6L*/ ordinary_grouping_set ')' /*6L*/
	| GROUPING SETS '(' /*6L*/ grouping_set_list ')' /*6L*/
	| '(' /*6L*/ ')' /*6L*/
	;

ordinary_grouping_set :
	ordinary_grouping_element
	| ordinary_grouping_set ',' ordinary_grouping_element
	;

ordinary_grouping_element :
	'(' /*6L*/ column_ref_commalist ')' /*6L*/
	| column_ref
	;

column_ref_commalist :
	column_ref
	| column_ref_commalist ',' column_ref
	;

grouping_set_list :
	grouping_set_element
	| grouping_set_list ',' grouping_set_element
	;

grouping_set_element :
	ordinary_grouping_element
	| ROLLUP '(' /*6L*/ ordinary_grouping_set ')' /*6L*/
	| CUBE '(' /*6L*/ ordinary_grouping_set ')' /*6L*/
	| GROUPING SETS '(' /*6L*/ grouping_set_list ')' /*6L*/
	| '(' /*6L*/ ')' /*6L*/
	;

opt_having_clause :
	/*empty*/
	| HAVING search_condition
	;

search_condition :
	search_condition OR /*9L*/ and_exp
	| and_exp
	;

and_exp :
	and_exp AND /*10L*/ pred_exp
	| pred_exp
	;

opt_order_by_clause :
	/*empty*/
	| ORDER BY sort_specification_list
	;

first_next :
	FIRST
	| NEXT
	;

opt_rows :
	/*empty*/
	| rows
	;

rows :
	ROW
	| ROWS
	;

opt_limit :
	/*empty*/
	| LIMIT nonzerolng
	| LIMIT param
	;

opt_offset :
	/*empty*/
	| OFFSET poslng
	| OFFSET param
	;

opt_offset_rows :
	/*empty*/
	| OFFSET poslng opt_rows
	| OFFSET param opt_rows
	;

opt_fetch :
	/*empty*/
	| FETCH first_next nonzerolng rows ONLY
	| FETCH first_next param rows ONLY
	| FETCH first_next rows ONLY
	;

opt_sample :
	/*empty*/
	| SAMPLE poslng
	| SAMPLE INTNUM
	| SAMPLE param
	;

opt_seed :
	/*empty*/
	| SEED intval
	| SEED param
	;

sort_specification_list :
	ordering_spec
	| sort_specification_list ',' ordering_spec
	;

ordering_spec :
	search_condition opt_asc_desc opt_nulls_first_last
	;

opt_asc_desc :
	/*empty*/
	| ASC
	| DESC
	;

opt_nulls_first_last :
	/*empty*/
	| NULLS LAST
	| NULLS FIRST
	;

predicate :
	comparison_predicate
	| between_predicate
	| like_predicate
	| test_for_null
	| in_predicate
	| existence_test
	| filter_exp
	| scalar_exp
	;

pred_exp :
	NOT /*7L*/ pred_exp
	| predicate
	;

any_all_some :
	ANY /*9L*/
	| SOME /*9L*/
	| ALL /*9L*/
	;

comparison_predicate :
	pred_exp COMPARISON /*11L*/ pred_exp
	| pred_exp '=' /*8L*/ pred_exp
	| pred_exp COMPARISON /*11L*/ any_all_some '(' /*6L*/ value ')' /*6L*/
	| pred_exp '=' /*8L*/ any_all_some '(' /*6L*/ value ')' /*6L*/
	| pred_exp IS NOT /*7L*/ DISTINCT FROM pred_exp
	| pred_exp IS DISTINCT FROM pred_exp
	;

between_predicate :
	pred_exp NOT_BETWEEN /*9L*/ opt_bounds pred_exp AND /*10L*/ pred_exp
	| pred_exp BETWEEN /*9L*/ opt_bounds pred_exp AND /*10L*/ pred_exp
	;

opt_bounds :
	/*empty*/
	| ASYMMETRIC
	| SYMMETRIC
	;

like_predicate :
	pred_exp NOT_LIKE /*9L*/ like_exp
	| pred_exp NOT_ILIKE /*9L*/ like_exp
	| pred_exp LIKE /*9L*/ like_exp
	| pred_exp ILIKE /*9L*/ like_exp
	;

like_exp :
	scalar_exp
	| scalar_exp ESCAPE string
	| scalar_exp '{' /*6L*/ ESCAPE string '}' /*6L*/
	;

test_for_null :
	pred_exp IS NOT /*7L*/ sqlNULL
	| pred_exp IS sqlNULL
	;

in_predicate :
	pred_exp NOT_IN /*9L*/ '(' /*6L*/ value_commalist ')' /*6L*/
	| pred_exp sqlIN /*9L*/ '(' /*6L*/ value_commalist ')' /*6L*/
	| '(' /*6L*/ pred_exp_list ')' /*6L*/ NOT_IN /*9L*/ '(' /*6L*/ value_commalist ')' /*6L*/
	| '(' /*6L*/ pred_exp_list ')' /*6L*/ sqlIN /*9L*/ '(' /*6L*/ value_commalist ')' /*6L*/
	;

pred_exp_list :
	pred_exp
	| pred_exp_list ',' pred_exp
	;

existence_test :
	EXISTS /*9L*/ subquery
	| NOT_EXISTS /*9L*/ subquery
	;

filter_arg_list :
	pred_exp
	| filter_arg_list ',' pred_exp
	;

filter_args :
	'[' filter_arg_list ']'
	;

filter_exp :
	filter_args qname filter_args
	;

subquery_with_orderby :
	'(' /*6L*/ select_no_parens_orderby ')' /*6L*/
	| '(' /*6L*/ with_query ')' /*6L*/
	;

subquery :
	'(' /*6L*/ select_no_parens ')' /*6L*/
	| '(' /*6L*/ with_query ')' /*6L*/
	;

simple_scalar_exp :
	value_exp
	| scalar_exp '+' /*12L*/ scalar_exp
	| scalar_exp '-' /*12L*/ scalar_exp
	| scalar_exp '*' /*13L*/ scalar_exp
	| scalar_exp '/' /*13L*/ scalar_exp
	| scalar_exp '%' /*13L*/ scalar_exp
	| scalar_exp '^' /*12L*/ scalar_exp
	| scalar_exp '&' /*12L*/ scalar_exp
	| scalar_exp GEOM_OVERLAP /*16L*/ scalar_exp
	| scalar_exp GEOM_OVERLAP_OR_LEFT /*16L*/ scalar_exp
	| scalar_exp GEOM_OVERLAP_OR_RIGHT /*17L*/ scalar_exp
	| scalar_exp GEOM_OVERLAP_OR_BELOW /*16L*/ scalar_exp
	| scalar_exp GEOM_BELOW /*17L*/ scalar_exp
	| scalar_exp GEOM_OVERLAP_OR_ABOVE /*16L*/ scalar_exp
	| scalar_exp GEOM_ABOVE /*17L*/ scalar_exp
	| scalar_exp GEOM_DIST /*17L*/ scalar_exp
	| scalar_exp AT scalar_exp
	| scalar_exp '|' /*12L*/ scalar_exp
	| scalar_exp '~' /*15L*/ scalar_exp
	| scalar_exp GEOM_MBR_EQUAL /*17L*/ scalar_exp
	| '~' /*15L*/ scalar_exp
	| scalar_exp LEFT_SHIFT /*12L*/ scalar_exp
	| scalar_exp RIGHT_SHIFT /*12L*/ scalar_exp
	| scalar_exp LEFT_SHIFT_ASSIGN /*12L*/ scalar_exp
	| scalar_exp RIGHT_SHIFT_ASSIGN /*12L*/ scalar_exp
	| '+' /*12L*/ scalar_exp %prec UMINUS /*14L*/
	| '-' /*12L*/ scalar_exp %prec UMINUS /*14L*/
	| '(' /*6L*/ search_condition ')' /*6L*/
	;

scalar_exp :
	simple_scalar_exp
	| subquery %prec UMINUS /*14L*/
	;

opt_over :
	OVER '(' /*6L*/ window_specification ')' /*6L*/
	| OVER ident
	| /*empty*/
	;

value_exp :
	atom
	| aggr_or_window_ref opt_over
	| case_exp
	| cast_exp
	| column_ref
	| session_user
	| CURRENT_SCHEMA
	| CURRENT_ROLE
	| CURRENT_TIMEZONE
	| datetime_funcs
	| GROUPING '(' /*6L*/ column_ref_commalist ')' /*6L*/
	| NEXT VALUE FOR qname
	| null
	| param
	| string_funcs
	| XML_value_function
	| odbc_scalar_func_escape
	| map_funcs
	| multi_arg_func
	;

map_funcs :
	FIELD '(' /*6L*/ search_condition_commalist ')' /*6L*/
	;

param :
	'?'
	| ':' ident
	;

window_specification :
	window_ident_clause window_partition_clause window_order_clause window_frame_clause
	;

window_ident_clause :
	/*empty*/
	| ident
	;

search_condition_commalist :
	search_condition
	| search_condition_commalist ',' search_condition
	;

window_partition_clause :
	/*empty*/
	| PARTITION BY search_condition_commalist
	;

window_order_clause :
	/*empty*/
	| ORDER BY sort_specification_list
	;

window_frame_clause :
	/*empty*/
	| window_frame_units window_frame_extent window_frame_exclusion
	;

window_frame_units :
	ROWS
	| RANGE
	| GROUPS
	;

window_frame_extent :
	window_frame_start
	| window_frame_between
	;

window_frame_start :
	UNBOUNDED PRECEDING
	| search_condition PRECEDING
	| CURRENT ROW
	;

window_bound :
	window_frame_start
	| window_following_bound
	;

window_frame_between :
	BETWEEN /*9L*/ window_bound AND /*10L*/ window_bound
	;

window_following_bound :
	UNBOUNDED FOLLOWING
	| search_condition FOLLOWING
	;

window_frame_exclusion :
	/*empty*/
	| EXCLUDE CURRENT ROW
	| EXCLUDE sqlGROUP
	| EXCLUDE TIES
	| EXCLUDE NO OTHERS
	;

func_ref :
	qfunc '(' /*6L*/ ')' /*6L*/
	| qfunc '(' /*6L*/ search_condition_commalist ')' /*6L*/
	;

qfunc :
	func_ident
	| ident '.' func_ident
	;

func_ident :
	ident
	| LEFT /*4L*/
	| RIGHT /*4L*/
	| INSERT
	;

datetime_funcs :
	EXTRACT '(' /*6L*/ extract_datetime_field FROM scalar_exp ')' /*6L*/
	| CURRENT_DATE opt_brackets
	| CURRENT_TIME opt_brackets
	| CURRENT_TIMESTAMP opt_brackets
	| LOCALTIME opt_brackets
	| LOCALTIMESTAMP opt_brackets
	;

opt_brackets :
	/*empty*/
	| '(' /*6L*/ ')' /*6L*/
	;

opt_trim_type :
	/*empty*/
	| LEADING
	| TRAILING
	| BOTH
	;

opt_trim_characters :
	/*empty*/
	| string
	;

string_funcs :
	SUBSTRING /*12L*/ '(' /*6L*/ scalar_exp FROM scalar_exp FOR scalar_exp ')' /*6L*/
	| SUBSTRING /*12L*/ '(' /*6L*/ scalar_exp ',' scalar_exp ',' scalar_exp ')' /*6L*/
	| SUBSTRING /*12L*/ '(' /*6L*/ scalar_exp FROM scalar_exp ')' /*6L*/
	| SUBSTRING /*12L*/ '(' /*6L*/ scalar_exp ',' scalar_exp ')' /*6L*/
	| POSITION /*12L*/ '(' /*6L*/ scalar_exp sqlIN /*9L*/ scalar_exp ')' /*6L*/
	| scalar_exp CONCATSTRING /*12L*/ scalar_exp
	| SPLIT_PART /*12L*/ '(' /*6L*/ scalar_exp ',' scalar_exp ',' scalar_exp ')' /*6L*/
	| TRIM /*12L*/ '(' /*6L*/ opt_trim_type opt_trim_characters FROM scalar_exp ')' /*6L*/
	| TRIM /*12L*/ '(' /*6L*/ scalar_exp ',' scalar_exp ')' /*6L*/
	| TRIM /*12L*/ '(' /*6L*/ scalar_exp ')' /*6L*/
	;

column_exp_commalist :
	column_exp
	| column_exp_commalist ',' column_exp
	;

column_exp :
	'*' /*13L*/
	| ident '.' '*' /*13L*/
	| func_ref '.' '*' /*13L*/
	| search_condition opt_alias_name
	;

opt_alias_name :
	/*empty*/
	| opt_as ident
	;

atom :
	literal
	;

qrank :
	RANK
	| ident '.' RANK
	;

aggr_or_window_ref :
	qrank '(' /*6L*/ ')' /*6L*/
	| qrank '(' /*6L*/ search_condition_commalist ')' /*6L*/
	| qrank '(' /*6L*/ DISTINCT search_condition_commalist ')' /*6L*/
	| qrank '(' /*6L*/ ALL /*9L*/ search_condition_commalist ')' /*6L*/
	| qfunc '(' /*6L*/ '*' /*13L*/ ')' /*6L*/
	| qfunc '(' /*6L*/ ident '.' '*' /*13L*/ ')' /*6L*/
	| qfunc '(' /*6L*/ ')' /*6L*/
	| qfunc '(' /*6L*/ search_condition_commalist ')' /*6L*/
	| qfunc '(' /*6L*/ DISTINCT search_condition_commalist ')' /*6L*/
	| qfunc '(' /*6L*/ ALL /*9L*/ search_condition_commalist ')' /*6L*/
	| XML_aggregate
	;

opt_sign :
	'+' /*12L*/
	| '-' /*12L*/
	| /*empty*/
	;

tz :
	WITH /*5L*/ TIME ZONE
	| WITHOUT TIME ZONE
	| /*empty*/
	;

time_precision :
	'(' /*6L*/ intval ')' /*6L*/
	| /*empty*/
	;

timestamp_precision :
	'(' /*6L*/ intval ')' /*6L*/
	| /*empty*/
	;

datetime_type :
	sqlDATE
	| TIME time_precision tz
	| TIMESTAMP timestamp_precision tz
	;

non_second_datetime_field :
	YEAR
	| MONTH
	| DAY
	| HOUR
	| MINUTE
	;

datetime_field :
	non_second_datetime_field
	| SECOND
	;

extract_datetime_field :
	datetime_field
	| CENTURY
	| DECADE
	| QUARTER
	| WEEK
	| DOW
	| DOY
	| EPOCH
	;

start_field :
	non_second_datetime_field time_precision
	;

end_field :
	non_second_datetime_field
	| SECOND timestamp_precision
	;

single_datetime_field :
	non_second_datetime_field time_precision
	| SECOND timestamp_precision
	;

interval_qualifier :
	start_field TO end_field
	| single_datetime_field
	;

interval_type :
	INTERVAL interval_qualifier
	;

session_user :
	USER
	| SESSION_USER
	| CURRENT_USER
	;

session_timezone :
	TIME ZONE
	| CURRENT_TIMEZONE
	;

session_schema :
	SCHEMA
	| CURRENT_SCHEMA
	;

session_role :
	ROLE
	| CURRENT_ROLE
	;

literal :
	string
	| BINARYNUM
	| OCTALNUM
	| HEXADECIMALNUM
	| OIDNUM
	| sqlINT
	| INTNUM
	| APPROXNUM
	| sqlDATE string
	| odbc_date_escape
	| TIME time_precision tz string
	| odbc_time_escape
	| TIMESTAMP timestamp_precision tz string
	| odbc_timestamp_escape
	| interval_expression
	| odbc_interval_escape
	| blob string
	| blobstring
	| aTYPE string
	| sqlBOOL string
	| ident_or_uident string
	| odbc_guid_escape
	| BOOL_FALSE
	| BOOL_TRUE
	;

interval_expression :
	INTERVAL opt_sign string interval_qualifier
	;

qname :
	ident
	| ident '.' ident
	| ident '.' ident '.' ident
	;

column_ref :
	ident
	| ident '.' ident
	| ident '.' ident '.' ident
	;

variable_ref :
	ident
	| ident '.' ident
	;

cast_exp :
	CAST '(' /*6L*/ search_condition AS data_type ')' /*6L*/
	| CONVERT '(' /*6L*/ search_condition ',' data_type ')' /*6L*/
	;

case_exp :
	NULLIF '(' /*6L*/ search_condition ',' search_condition ')' /*6L*/
	| IFNULL '(' /*6L*/ search_condition ',' search_condition ')' /*6L*/
	| COALESCE '(' /*6L*/ case_search_condition_commalist ')' /*6L*/
	| CASE search_condition when_value_list case_opt_else END
	| CASE when_search_list case_opt_else END
	;

case_search_condition_commalist :
	search_condition ',' search_condition
	| case_search_condition_commalist ',' search_condition
	;

when_value :
	WHEN search_condition THEN search_condition
	;

when_value_list :
	when_value
	| when_value_list when_value
	;

when_search :
	WHEN search_condition THEN search_condition
	;

when_search_list :
	when_search
	| when_search_list when_search
	;

case_opt_else :
	/*empty*/
	| ELSE search_condition
	;

nonzero :
	intval
	;

nonzerolng :
	lngval
	;

poslng :
	lngval
	;

posint :
	intval
	;

data_type :
	CHARACTER
	| varchar
	| clob
	| CHARACTER '(' /*6L*/ nonzero ')' /*6L*/
	| varchar '(' /*6L*/ nonzero ')' /*6L*/
	| clob '(' /*6L*/ nonzero ')' /*6L*/
	| blob
	| blob '(' /*6L*/ nonzero ')' /*6L*/
	| TINYINT
	| SMALLINT
	| sqlINTEGER
	| BIGINT
	| HUGEINT
	| sqlDECIMAL
	| sqlDECIMAL '(' /*6L*/ nonzero ')' /*6L*/
	| sqlDECIMAL '(' /*6L*/ nonzero ',' posint ')' /*6L*/
	| sqlFLOAT
	| sqlFLOAT '(' /*6L*/ nonzero ')' /*6L*/
	| sqlFLOAT '(' /*6L*/ intval ',' intval ')' /*6L*/
	| sqlDOUBLE
	| sqlDOUBLE PRECISION
	| sqlREAL
	| datetime_type
	| interval_type
	| aTYPE
	| aTYPE '(' /*6L*/ nonzero ')' /*6L*/
	| sqlBOOL
	| ident_or_uident
	| ident_or_uident '(' /*6L*/ nonzero ')' /*6L*/
	| GEOMETRY
	| GEOMETRY '(' /*6L*/ subgeometry_type ')' /*6L*/
	| GEOMETRY '(' /*6L*/ subgeometry_type ',' intval ')' /*6L*/
	| GEOMETRYA
	| GEOMETRYSUBTYPE
	;

subgeometry_type :
	GEOMETRYSUBTYPE
	| string
	;

varchar :
	VARCHAR
	| CHARACTER VARYING
	;

clob :
	CLOB
	| sqlTEXT
	| CHARACTER LARGE OBJECT
	;

blob :
	sqlBLOB
	| BINARY LARGE OBJECT
	;

column :
	ident
	;

authid :
	restricted_ident
	;

calc_restricted_ident :
	IDENT
	| UIDENT opt_uescape
	| aTYPE
	| RANK
	;

restricted_ident :
	calc_restricted_ident
	;

calc_ident :
	IDENT
	| UIDENT opt_uescape
	| aTYPE
	| RANK
	| MARGFUNC
	| non_reserved_word
	;

ident :
	calc_ident
	;

non_reserved_word :
	AS
	| AUTHORIZATION
	| COLUMN
	| CYCLE
	| sqlDATE
	| DEALLOCATE
	| DISTINCT
	| EXEC
	| EXECUTE
	| FILTER
	| INTERVAL
	| LANGUAGE
	| LARGE
	| MATCH
	| NO
	| PRECISION
	| PREPARE
	| RELEASE
	| ROW
	| START
	| TABLE
	| TIME
	| TIMESTAMP
	| UESCAPE
	| VALUE
	| WITHOUT
	| ACTION
	| ANALYZE
	| ASC
	| AUTO_COMMIT
	| BIG
	| sqlBOOL
	| CACHE
	| CENTURY
	| CLIENT
	| COMMENT
	| DATA /*5L*/
	| DECADE
	| DESC
	| DIAGNOSTICS
	| DOW
	| DOY
	| ENDIAN
	| EPOCH
	| SQL_EXPLAIN
	| FIRST
	| FIELD
	| GEOMETRY
	| IMPRINTS
	| INCREMENT
	| KEY
	| LAST
	| LEVEL
	| LITTLE
	| LOGIN
	| MAX_MEMORY
	| MAXVALUE
	| MAX_WORKERS
	| MINMAX
	| MINVALUE
	| sqlNAME
	| NATIVE
	| NULLS
	| OBJECT
	| OPTIMIZER
	| OPTIONS
	| PASSWORD
	| PATH
	| SQL_PLAN
	| PREP
	| PRIVILEGES
	| QUARTER
	| REPLACE
	| ROLE
	| SCHEMA
	| SERVER
	| sqlSESSION
	| sqlSIZE
	| STATEMENT
	| STORAGE
	| TEMP
	| TEMPORARY
	| sqlTEXT
	| SQL_TRACE
	| TYPE
	| UNLOGGED
	| WEEK
	| ZONE
	| ABSENT
	| ACCORDING
	| CONTENT
	| DOCUMENT
	| ELEMENT
	| EMPTY
	| ID
	| LOCATION
	| NAMESPACE
	| NIL
	| PASSING
	| REF
	| RETURNING
	| STRIP
	| URI
	| WHITESPACE
	| ODBC_DATE_ESCAPE_PREFIX
	| ODBC_TIME_ESCAPE_PREFIX
	| ODBC_TIMESTAMP_ESCAPE_PREFIX
	| ODBC_GUID_ESCAPE_PREFIX
	| ODBC_FUNC_ESCAPE_PREFIX
	| ODBC_OJ_ESCAPE_PREFIX
	| DAYNAME
	| MONTHNAME
	| TIMESTAMPADD
	| TIMESTAMPDIFF
	| IFNULL
	;

lngval :
	sqlINT
	;

ident_or_uident :
	IDENT
	| UIDENT opt_uescape
	;

intval :
	sqlINT
	;

opt_uescape :
	/*empty*/
	| UESCAPE string
	;

ustring :
	USTRING /*1R*/
	| USTRING /*1R*/ sstring
	;

blobstring :
	XSTRING /*1R*/
	| XSTRING /*1R*/ sstring
	;

sstring :
	STRING /*1R*/
	| STRING /*1R*/ sstring
	;

string :
	sstring
	| ustring opt_uescape
	;

exec :
	execute exec_ref
	;

dealloc_ref :
	posint
	| ALL /*9L*/
	;

dealloc :
	deallocate opt_prepare dealloc_ref
	;

exec_ref :
	posint arg_list_ref
	;

arg_list_ref :
	'(' /*6L*/ ')' /*6L*/
	| '(' /*6L*/ value_commalist ')' /*6L*/
	;

named_arg_list_ref :
	'(' /*6L*/ ')' /*6L*/
	| '(' /*6L*/ named_value_commalist ')' /*6L*/
	;

opt_path_specification :
	/*empty*/
	| path_specification
	;

path_specification :
	PATH schema_name_list
	;

schema_name_list :
	ident_commalist
	;

comment_on_statement :
	COMMENT ON catalog_object IS string
	| COMMENT ON catalog_object IS sqlNULL
	;

catalog_object :
	SCHEMA ident
	| TABLE qname
	| VIEW qname
	| COLUMN ident '.' ident
	| COLUMN ident '.' ident '.' ident
	| INDEX qname
	| SEQUENCE qname
	| routine_designator
	;

XML_value_expression :
	XML_primary
	;

XML_value_expression_list :
	XML_value_expression
	| XML_value_expression_list ',' XML_value_expression
	;

XML_primary :
	scalar_exp
	;

XML_value_function :
	XML_comment
	| XML_concatenation
	| XML_document
	| XML_element
	| XML_forest
	| XML_parse
	| XML_PI
	| XML_query
	| XML_text
	| XML_validate
	;

XML_comment :
	XMLCOMMENT '(' /*6L*/ value_exp opt_XML_returning_clause ')' /*6L*/
	;

XML_concatenation :
	XMLCONCAT '(' /*6L*/ XML_value_expression_list opt_XML_returning_clause ')' /*6L*/
	;

XML_document :
	XMLDOCUMENT '(' /*6L*/ XML_value_expression opt_XML_returning_clause ')' /*6L*/
	;

XML_element :
	XMLELEMENT '(' /*6L*/ sqlNAME XML_element_name opt_comma_XML_namespace_declaration_attributes_element_content opt_XML_returning_clause ')' /*6L*/
	;

opt_comma_XML_namespace_declaration_attributes_element_content :
	/*empty*/
	| ',' XML_namespace_declaration
	| ',' XML_namespace_declaration ',' XML_attributes
	| ',' XML_namespace_declaration ',' XML_attributes ',' XML_element_content_and_option
	| ',' XML_namespace_declaration ',' XML_element_content_and_option
	| ',' XML_attributes
	| ',' XML_attributes ',' XML_element_content_and_option
	| ',' XML_element_content_and_option
	;

XML_element_name :
	ident
	;

XML_attributes :
	XMLATTRIBUTES '(' /*6L*/ XML_attribute_list ')' /*6L*/
	;

XML_attribute_list :
	XML_attribute
	| XML_attribute_list ',' XML_attribute
	;

XML_attribute :
	XML_attribute_value opt_XML_attribute_name
	;

opt_XML_attribute_name :
	/*empty*/
	| AS XML_attribute_name
	;

XML_attribute_value :
	scalar_exp
	;

XML_attribute_name :
	ident
	;

XML_element_content_and_option :
	XML_element_content_list opt_XML_content_option
	;

XML_element_content_list :
	XML_element_content
	| XML_element_content_list ',' XML_element_content
	;

XML_element_content :
	scalar_exp
	;

opt_XML_content_option :
	/*empty*/
	| OPTION XML_content_option
	;

XML_content_option :
	sqlNULL ON sqlNULL
	| EMPTY ON sqlNULL
	| ABSENT ON sqlNULL
	| NIL ON sqlNULL
	| NIL ON NO CONTENT
	;

XML_forest :
	XMLFOREST '(' /*6L*/ opt_XML_namespace_declaration_and_comma forest_element_list opt_XML_content_option opt_XML_returning_clause ')' /*6L*/
	;

opt_XML_namespace_declaration_and_comma :
	/*empty*/
	| XML_namespace_declaration ','
	;

forest_element_list :
	forest_element
	| forest_element_list ',' forest_element
	;

forest_element :
	forest_element_value opt_forest_element_name
	;

forest_element_value :
	scalar_exp
	;

opt_forest_element_name :
	/*empty*/
	| AS forest_element_name
	;

forest_element_name :
	ident
	;

XML_parse :
	XMLPARSE '(' /*6L*/ document_or_content value_exp XML_whitespace_option ')' /*6L*/
	;

XML_whitespace_option :
	PRESERVE WHITESPACE
	| STRIP WHITESPACE
	;

XML_PI :
	XMLPI '(' /*6L*/ sqlNAME XML_PI_target opt_comma_string_value_expression opt_XML_returning_clause ')' /*6L*/
	;

XML_PI_target :
	ident
	;

opt_comma_string_value_expression :
	/*empty*/
	| ',' value_exp
	;

XML_query :
	XMLQUERY '(' /*6L*/ XQuery_expression opt_XML_query_argument_list opt_XML_returning_clause opt_XML_query_returning_mechanism XML_query_empty_handling_option ')' /*6L*/
	;

XQuery_expression :
	STRING /*1R*/
	;

opt_XML_query_argument_list :
	/*empty*/
	| PASSING XML_query_default_passing_mechanism XML_query_argument_list
	;

XML_query_default_passing_mechanism :
	XML_passing_mechanism
	;

XML_query_argument_list :
	XML_query_argument
	| XML_query_argument_list ',' XML_query_argument
	;

XML_query_argument :
	XML_query_context_item
	| XML_query_variable
	;

XML_query_context_item :
	value_exp opt_XML_passing_mechanism
	;

XML_query_variable :
	value_exp AS ident opt_XML_passing_mechanism
	;

opt_XML_query_returning_mechanism :
	/*empty*/
	| XML_passing_mechanism
	;

XML_query_empty_handling_option :
	sqlNULL ON EMPTY
	| EMPTY ON EMPTY
	;

XML_text :
	XMLTEXT '(' /*6L*/ value_exp opt_XML_returning_clause ')' /*6L*/
	;

XML_validate :
	XMLVALIDATE '(' /*6L*/ document_or_content_or_sequence XML_value_expression opt_XML_valid_according_to_clause ')' /*6L*/
	;

document_or_content_or_sequence :
	document_or_content
	| SEQUENCE
	;

document_or_content :
	DOCUMENT
	| CONTENT
	;

opt_XML_returning_clause :
	/*empty*/
	| RETURNING CONTENT
	| RETURNING SEQUENCE
	;

XML_namespace_declaration :
	XMLNAMESPACES '(' /*6L*/ XML_namespace_declaration_item_list ')' /*6L*/
	;

XML_namespace_declaration_item_list :
	XML_namespace_declaration_item
	| XML_namespace_declaration_item_list ',' XML_namespace_declaration_item
	;

XML_namespace_declaration_item :
	XML_regular_namespace_declaration_item
	| XML_default_namespace_declaration_item
	;

XML_namespace_prefix :
	ident
	;

XML_namespace_URI :
	scalar_exp
	;

XML_regular_namespace_declaration_item :
	XML_namespace_URI AS XML_namespace_prefix
	;

XML_default_namespace_declaration_item :
	DEFAULT XML_namespace_URI
	| NO DEFAULT
	;

opt_XML_passing_mechanism :
	/*empty*/
	| XML_passing_mechanism
	;

XML_passing_mechanism :
	BY REF
	| BY VALUE
	;

opt_XML_valid_according_to_clause :
	/*empty*/
	| XML_valid_according_to_clause
	;

XML_valid_according_to_clause :
	ACCORDING TO XMLSCHEMA XML_valid_according_to_what opt_XML_valid_element_clause
	;

XML_valid_according_to_what :
	XML_valid_according_to_URI
	| XML_valid_according_to_identifier
	;

XML_valid_according_to_URI :
	URI XML_valid_target_namespace_URI opt_XML_valid_schema_location
	| NO NAMESPACE opt_XML_valid_schema_location
	;

XML_valid_target_namespace_URI :
	XML_URI
	;

XML_URI :
	STRING /*1R*/
	;

opt_XML_valid_schema_location :
	/*empty*/
	| LOCATION XML_valid_schema_location_URI
	;

XML_valid_schema_location_URI :
	XML_URI
	;

XML_valid_according_to_identifier :
	ID registered_XML_Schema_name
	;

registered_XML_Schema_name :
	ident
	;

opt_XML_valid_element_clause :
	/*empty*/
	| XML_valid_element_clause
	;

XML_valid_element_clause :
	XML_valid_element_name_specification
	| XML_valid_element_namespace_specification opt_XML_valid_element_name_specification
	;

opt_XML_valid_element_name_specification :
	/*empty*/
	| XML_valid_element_name_specification
	;

XML_valid_element_name_specification :
	ELEMENT XML_valid_element_name
	;

XML_valid_element_namespace_specification :
	NO NAMESPACE
	| NAMESPACE XML_valid_element_namespace_URI
	;

XML_valid_element_namespace_URI :
	XML_URI
	;

XML_valid_element_name :
	ident
	;

XML_aggregate :
	XMLAGG '(' /*6L*/ XML_value_expression opt_order_by_clause opt_XML_returning_clause ')' /*6L*/
	;

odbc_date_escape :
	'{' /*6L*/ ODBC_DATE_ESCAPE_PREFIX string '}' /*6L*/
	;

odbc_time_escape :
	'{' /*6L*/ ODBC_TIME_ESCAPE_PREFIX string '}' /*6L*/
	;

odbc_timestamp_escape :
	'{' /*6L*/ ODBC_TIMESTAMP_ESCAPE_PREFIX string '}' /*6L*/
	;

odbc_guid_escape :
	'{' /*6L*/ ODBC_GUID_ESCAPE_PREFIX string '}' /*6L*/
	;

odbc_interval_escape :
	'{' /*6L*/ interval_expression '}' /*6L*/
	;

odbc_scalar_func_escape :
	'{' /*6L*/ ODBC_FUNC_ESCAPE_PREFIX odbc_scalar_func '}' /*6L*/
	;

odbc_datetime_func :
	HOUR '(' /*6L*/ search_condition ')' /*6L*/
	| MINUTE '(' /*6L*/ search_condition ')' /*6L*/
	| SECOND '(' /*6L*/ search_condition ')' /*6L*/
	| DAYNAME '(' /*6L*/ search_condition ')' /*6L*/
	| MONTHNAME '(' /*6L*/ search_condition ')' /*6L*/
	| MONTH '(' /*6L*/ search_condition ')' /*6L*/
	| YEAR '(' /*6L*/ search_condition ')' /*6L*/
	| TIMESTAMPADD '(' /*6L*/ odbc_tsi_qualifier ',' scalar_exp ',' search_condition ')' /*6L*/
	| TIMESTAMPDIFF '(' /*6L*/ odbc_tsi_qualifier ',' search_condition ',' search_condition ')' /*6L*/
	;

odbc_scalar_func :
	func_ref
	| string_funcs
	| datetime_funcs
	| odbc_datetime_func
	| CONVERT '(' /*6L*/ search_condition ',' odbc_data_type ')' /*6L*/
	| USER '(' /*6L*/ ')' /*6L*/
	| CHARACTER '(' /*6L*/ search_condition ')' /*6L*/
	| TRUNCATE '(' /*6L*/ search_condition ',' search_condition ')' /*6L*/
	| IFNULL '(' /*6L*/ search_condition ',' search_condition ')' /*6L*/
	;

odbc_data_type :
	SQL_BIGINT
	| SQL_BINARY
	| SQL_BIT
	| SQL_CHAR
	| SQL_DATE
	| SQL_DECIMAL
	| SQL_DOUBLE
	| SQL_FLOAT
	| SQL_GUID
	| SQL_HUGEINT
	| SQL_INTEGER
	| SQL_INTERVAL_YEAR
	| SQL_INTERVAL_YEAR_TO_MONTH
	| SQL_INTERVAL_MONTH
	| SQL_INTERVAL_DAY
	| SQL_INTERVAL_DAY_TO_HOUR
	| SQL_INTERVAL_DAY_TO_MINUTE
	| SQL_INTERVAL_DAY_TO_SECOND
	| SQL_INTERVAL_HOUR
	| SQL_INTERVAL_HOUR_TO_MINUTE
	| SQL_INTERVAL_HOUR_TO_SECOND
	| SQL_INTERVAL_MINUTE
	| SQL_INTERVAL_MINUTE_TO_SECOND
	| SQL_INTERVAL_SECOND
	| SQL_LONGVARBINARY
	| SQL_LONGVARCHAR
	| SQL_NUMERIC
	| SQL_REAL
	| SQL_SMALLINT
	| SQL_TIME
	| SQL_TIMESTAMP
	| SQL_TINYINT
	| SQL_VARBINARY
	| SQL_VARCHAR
	| SQL_WCHAR
	| SQL_WLONGVARCHAR
	| SQL_WVARCHAR
	;

odbc_tsi_qualifier :
	SQL_TSI_FRAC_SECOND
	| SQL_TSI_SECOND
	| SQL_TSI_MINUTE
	| SQL_TSI_HOUR
	| SQL_TSI_DAY
	| SQL_TSI_WEEK
	| SQL_TSI_MONTH
	| SQL_TSI_QUARTER
	| SQL_TSI_YEAR
	;

multi_arg_func :
	MARGFUNC '(' /*6L*/ case_search_condition_commalist ')' /*6L*/
	;

%%

%option caseless

%%

"^"	'^'
"~"	'~'
"="	'='
"|"	'|'
"-"	'-'
","	','
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
"*"	'*'
"&"	'&'
"%"	'%'
"+"	'+'


"false"	BOOL_FALSE
"true"	BOOL_TRUE
"bool"	sqlBOOL

"ALTER"	ALTER
"ADD"	ADD
"AND"	AND

"RANK"	RANK
"DENSE_RANK"	RANK
"PERCENT_RANK"	RANK
"CUME_DIST"	RANK
"ROW_NUMBER"	RANK
"NTILE"	RANK
"LAG"	RANK
"LEAD"	RANK
"FETCH"	FETCH
"FIRST_VALUE"	RANK
"LAST_VALUE"	RANK
"NTH_VALUE"	RANK

"BEST"	BEST
"EFFORT"	EFFORT

"AS"	AS
"ASC"	ASC
"AUTHORIZATION"	AUTHORIZATION
"BETWEEN"	BETWEEN
"SYMMETRIC"	SYMMETRIC
"ASYMMETRIC"	ASYMMETRIC
"BY"	BY
"CAST"	CAST
"CONVERT"	CONVERT
"CHARACTER"	CHARACTER
"CHAR"	CHARACTER
"VARYING"	VARYING
"VARCHAR"	VARCHAR
"BINARY"	BINARY
"LARGE"	LARGE
"OBJECT"	OBJECT
"CLOB"	CLOB
"BLOB"	sqlBLOB
"TEXT"	sqlTEXT
"TINYTEXT"	sqlTEXT
"STRING"	CLOB	/* ? */
"CHECK"	CHECK
"CLIENT"	CLIENT
"SERVER"	SERVER
"COMMENT"	COMMENT
"CONSTRAINT"	CONSTRAINT
"CREATE"	CREATE
"CROSS"	CROSS
"COPY"	COPY
"RECORDS"	RECORDS
"DELIMITERS"	DELIMITERS
"STDIN"	STDIN
"STDOUT"	STDOUT

"TINYINT"	TINYINT
"SMALLINT"	SMALLINT
"INTEGER"	sqlINTEGER
"INT"	sqlINTEGER
"MEDIUMINT"	sqlINTEGER
"BIGINT"	BIGINT
//"HUGEINT"	HUGEINT
"DEC"	sqlDECIMAL
"DECIMAL"	sqlDECIMAL
"NUMERIC"	sqlDECIMAL
"DECLARE"	DECLARE
"DEFAULT"	DEFAULT
"DESC"	DESC
"DISTINCT"	DISTINCT
"DOUBLE"	sqlDOUBLE
"REAL"	sqlREAL
"DROP"	DROP
"ESCAPE"	ESCAPE
"EXISTS"	EXISTS
"UESCAPE"	UESCAPE
"EXTRACT"	EXTRACT
"FLOAT"	sqlFLOAT
"FOR"	FOR
"FOREIGN"	FOREIGN
"FROM"	FROM
"FWF"	FWF

"BIG"	BIG
"LITTLE"	LITTLE
"NATIVE"	NATIVE
"ENDIAN"	ENDIAN

"REFERENCES"	REFERENCES

"MATCH"	MATCH
"FULL"	FULL
"PARTIAL"	PARTIAL
"SIMPLE"	SIMPLE

"INSERT"	INSERT
"UPDATE"	UPDATE
"DELETE"	sqlDELETE
"TRUNCATE"	TRUNCATE
"MATCHED"	MATCHED

"ACTION"	ACTION
"CASCADE"	CASCADE
"RESTRICT"	RESTRICT
"FIRST"	FIRST
"GLOBAL"	GLOBAL
"GROUP"	sqlGROUP
"GROUPING"	GROUPING
"ROLLUP"	ROLLUP
"CUBE"	CUBE
"HAVING"	HAVING
"ILIKE"	ILIKE
"IMPRINTS"	IMPRINTS
"IN"	sqlIN
"INNER"	INNER
"INTO"	INTO
"IS"	IS
"JOIN"	JOIN
"KEY"	KEY
"LATERAL"	LATERAL
"LEFT"	LEFT
"LIKE"	LIKE
"LIMIT"	LIMIT
"SAMPLE"	SAMPLE
"SEED"	SEED
"LAST"	LAST
"LOCAL"	LOCAL
"NATURAL"	NATURAL
"NOT"	NOT
"NULL"	sqlNULL
"NULLS"	NULLS
"OFFSET"	OFFSET
"ON"	ON
"OPTIONS"	OPTIONS
"OPTION"	OPTION
"OR"	OR
"ORDER"	ORDER
"ORDERED"	ORDERED
"OUTER"	OUTER
"OVER"	OVER
"PARTITION"	PARTITION
"PATH"	PATH
"PRECISION"	PRECISION
"PRIMARY"	PRIMARY

"USER"	USER
"RENAME"	RENAME
"UNENCRYPTED"	UNENCRYPTED
"ENCRYPTED"	ENCRYPTED
"PASSWORD"	PASSWORD
"GRANT"	GRANT
"REVOKE"	REVOKE
"ROLE"	ROLE
"ADMIN"	ADMIN
"PRIVILEGES"	PRIVILEGES
"PUBLIC"	PUBLIC
"CURRENT_USER"	CURRENT_USER
"CURRENT_ROLE"	CURRENT_ROLE
"SESSION_USER"	SESSION_USER
"CURRENT_SCHEMA"	CURRENT_SCHEMA
"SESSION"	sqlSESSION
"MAX_MEMORY"	MAX_MEMORY
"MAX_WORKERS"	MAX_WORKERS
"OPTIMIZER"	OPTIMIZER

"RIGHT"	RIGHT
"SCHEMA"	SCHEMA
"SELECT"	SELECT
"SET"	SET
"SETS"	SETS
"AUTO_COMMIT"	AUTO_COMMIT

"ALL"	ALL
"ANY"	ANY
"SOME"	SOME
"EVERY"	ANY
/*
   "SQLCODE"	SQLCODE
 */
"COLUMN"	COLUMN
"TABLE"	TABLE
"TEMPORARY"	TEMPORARY
"TEMP"	TEMP
"REMOTE"	REMOTE
"MERGE"	MERGE
"REPLICA"	REPLICA
"UNLOGGED"	UNLOGGED
"TO"	TO
"UNION"	UNION
"EXCEPT"	EXCEPT
"INTERSECT"	INTERSECT
"CORRESPONDING"	CORRESPONDING
"UNIQUE"	UNIQUE
"USING"	USING
"VALUES"	VALUES
"VIEW"	VIEW
"WHERE"	WHERE
"WITH"	WITH
"WITHOUT"	WITHOUT
"DATA"	DATA

"DATE"	sqlDATE
"TIME"	TIME
"TIMESTAMP"	TIMESTAMP
"INTERVAL"	INTERVAL
"CURRENT_DATE"	CURRENT_DATE
"CURRENT_TIME"	CURRENT_TIME
"CURRENT_TIMESTAMP"	CURRENT_TIMESTAMP
"CURRENT_TIMEZONE"	CURRENT_TIMEZONE
"NOW"	CURRENT_TIMESTAMP
"LOCALTIME"	LOCALTIME
"LOCALTIMESTAMP"	LOCALTIMESTAMP
"ZONE"	ZONE

"CENTURY"	CENTURY
"DECADE"	DECADE
"YEAR"	YEAR
"QUARTER"	QUARTER
"MONTH"	MONTH
"WEEK"	WEEK
"DOW"	DOW
"DOY"	DOY
"DAY"	DAY
"HOUR"	HOUR
"MINUTE"	MINUTE
"SECOND"	SECOND
"EPOCH"	EPOCH

"POSITION"	POSITION
"SUBSTRING"	SUBSTRING
"SPLIT_PART"	SPLIT_PART
"TRIM"	TRIM
"LEADING"	LEADING
"TRAILING"	TRAILING
"BOTH"	BOTH

"CASE"	CASE
"WHEN"	WHEN
"THEN"	THEN
"ELSE"	ELSE
"END"	END
"NULLIF"	NULLIF
"COALESCE"	COALESCE
"ELSEIF"	ELSEIF
"IF"	IF
"WHILE"	WHILE
"DO"	DO

"COMMIT"	COMMIT
"ROLLBACK"	ROLLBACK
"SAVEPOINT"	SAVEPOINT
"RELEASE"	RELEASE
"WORK"	WORK
"CHAIN"	CHAIN
"PRESERVE"	PRESERVE
"ROWS"	ROWS
"NO"	NO
"START"	START
"TRANSACTION"	TRANSACTION
"READ"	READ
"WRITE"	WRITE
"ONLY"	ONLY
"ISOLATION"	ISOLATION
"LEVEL"	LEVEL
"UNCOMMITTED"	UNCOMMITTED
"COMMITTED"	COMMITTED
"REPEATABLE"	sqlREPEATABLE
"SNAPSHOT"	SNAPSHOT
"SERIALIZABLE"	SERIALIZABLE
"DIAGNOSTICS"	DIAGNOSTICS
"SIZE"	sqlSIZE
"STORAGE"	STORAGE

"TYPE"	TYPE
"PROCEDURE"	PROCEDURE
"FUNCTION"	FUNCTION
"LOADER"	sqlLOADER
"REPLACE"	REPLACE

"FIELD"	FIELD
"FILTER"	FILTER
"AGGREGATE"	AGGREGATE
"RETURNS"	RETURNS
"EXTERNAL"	EXTERNAL
"NAME"	sqlNAME
"RETURN"	RETURN
"CALL"	CALL
"LANGUAGE"	LANGUAGE

"ANALYZE"	ANALYZE
"MINMAX"	MINMAX
"EXPLAIN"	SQL_EXPLAIN
"PLAN"	SQL_PLAN
"TRACE"	SQL_TRACE
"PREPARE"	PREPARE
"PREP"	PREP
"EXECUTE"	EXECUTE
"EXEC"	EXEC
"DEALLOCATE"	DEALLOCATE

"INDEX"	INDEX

"SEQUENCE"	SEQUENCE
"RESTART"	RESTART
"INCREMENT"	INCREMENT
"MAXVALUE"	MAXVALUE
"MINVALUE"	MINVALUE
"CYCLE"	CYCLE
"CACHE"	CACHE
"NEXT"	NEXT
"VALUE"	VALUE
"GENERATED"	GENERATED
"ALWAYS"	ALWAYS
"IDENTITY"	IDENTITY
"SERIAL"	SERIAL
"BIGSERIAL"	BIGSERIAL
"AUTO_INCREMENT"	AUTO_INCREMENT
"CONTINUE"	CONTINUE

"TRIGGER"	TRIGGER
"ATOMIC"	ATOMIC
"BEGIN"	BEGIN
"OF"	OF
"BEFORE"	BEFORE
"AFTER"	AFTER
"ROW"	ROW
"STATEMENT"	STATEMENT
"NEW"	sqlNEW
"OLD"	OLD
"EACH"	EACH
"REFERENCING"	REFERENCING

"RANGE"	RANGE
"UNBOUNDED"	UNBOUNDED
"PRECEDING"	PRECEDING
"FOLLOWING"	FOLLOWING
"CURRENT"	CURRENT
"EXCLUDE"	EXCLUDE
"OTHERS"	OTHERS
"TIES"	TIES
"GROUPS"	GROUPS
"WINDOW"	WINDOW

/* special SQL/XML keywords */
"XMLCOMMENT"	XMLCOMMENT
"XMLCONCAT"	XMLCONCAT
"XMLDOCUMENT"	XMLDOCUMENT
"XMLELEMENT"	XMLELEMENT
"XMLATTRIBUTES"	XMLATTRIBUTES
"XMLFOREST"	XMLFOREST
"XMLPARSE"	XMLPARSE
"STRIP"	STRIP
"WHITESPACE"	WHITESPACE
"XMLPI"	XMLPI
"XMLQUERY"	XMLQUERY
"PASSING"	PASSING
"XMLTEXT"	XMLTEXT
"NIL"	NIL
"REF"	REF
"ABSENT"	ABSENT
"DOCUMENT"	DOCUMENT
"ELEMENT"	ELEMENT
"CONTENT"	CONTENT
"XMLNAMESPACES"	XMLNAMESPACES
"NAMESPACE"	NAMESPACE
"XMLVALIDATE"	XMLVALIDATE
"RETURNING"	RETURNING
"LOCATION"	LOCATION
"ID"	ID
"ACCORDING"	ACCORDING
"XMLSCHEMA"	XMLSCHEMA
"URI"	URI
"XMLAGG"	XMLAGG

/* keywords for opengis */
"GEOMETRY"	GEOMETRY

"POINT"	GEOMETRYSUBTYPE
"LINESTRING"	GEOMETRYSUBTYPE
"POLYGON"	GEOMETRYSUBTYPE
"MULTIPOINT"	GEOMETRYSUBTYPE
"MULTILINESTRING"	GEOMETRYSUBTYPE
"MULTIPOLYGON"	GEOMETRYSUBTYPE
"GEOMETRYCOLLECTION"	GEOMETRYSUBTYPE

"POINTZ"	GEOMETRYSUBTYPE
"LINESTRINGZ"	GEOMETRYSUBTYPE
"POLYGONZ"	GEOMETRYSUBTYPE
"MULTIPOINTZ"	GEOMETRYSUBTYPE
"MULTILINESTRINGZ"	GEOMETRYSUBTYPE
"MULTIPOLYGONZ"	GEOMETRYSUBTYPE
"GEOMETRYCOLLECTIONZ"	GEOMETRYSUBTYPE

"POINTM"	GEOMETRYSUBTYPE
"LINESTRINGM"	GEOMETRYSUBTYPE
"POLYGONM"	GEOMETRYSUBTYPE
"MULTIPOINTM"	GEOMETRYSUBTYPE
"MULTILINESTRINGM"	GEOMETRYSUBTYPE
"MULTIPOLYGONM"	GEOMETRYSUBTYPE
"GEOMETRYCOLLECTIONM"	GEOMETRYSUBTYPE

"POINTZM"	GEOMETRYSUBTYPE
"LINESTRINGZM"	GEOMETRYSUBTYPE
"POLYGONZM"	GEOMETRYSUBTYPE
"MULTIPOINTZM"	GEOMETRYSUBTYPE
"MULTILINESTRINGZM"	GEOMETRYSUBTYPE
"MULTIPOLYGONZM"	GEOMETRYSUBTYPE
"GEOMETRYCOLLECTIONZM"	GEOMETRYSUBTYPE
"LOGIN"	LOGIN
// odbc keywords
"d"	ODBC_DATE_ESCAPE_PREFIX
"t"	ODBC_TIME_ESCAPE_PREFIX
"ts"	ODBC_TIMESTAMP_ESCAPE_PREFIX
"guid"	ODBC_GUID_ESCAPE_PREFIX
"fn"	ODBC_FUNC_ESCAPE_PREFIX
"oj"	ODBC_OJ_ESCAPE_PREFIX
"DAYNAME"	DAYNAME
"IFNULL"	IFNULL
"MONTHNAME"	MONTHNAME
"TIMESTAMPADD"	TIMESTAMPADD
"TIMESTAMPDIFF"	TIMESTAMPDIFF
"SQL_BIGINT"	SQL_BIGINT
"SQL_BINARY"	SQL_BINARY
"SQL_BIT"	SQL_BIT
"SQL_CHAR"	SQL_CHAR
"SQL_DATE"	SQL_DATE
"SQL_DECIMAL"	SQL_DECIMAL
"SQL_DOUBLE"	SQL_DOUBLE
"SQL_FLOAT"	SQL_FLOAT
"SQL_GUID"	SQL_GUID
"SQL_HUGEINT"	SQL_HUGEINT
"SQL_INTEGER"	SQL_INTEGER
"SQL_INTERVAL_DAY"	SQL_INTERVAL_DAY
"SQL_INTERVAL_DAY_TO_HOUR"	SQL_INTERVAL_DAY_TO_HOUR
"SQL_INTERVAL_DAY_TO_MINUTE"	SQL_INTERVAL_DAY_TO_MINUTE
"SQL_INTERVAL_DAY_TO_SECOND"	SQL_INTERVAL_DAY_TO_SECOND
"SQL_INTERVAL_HOUR"	SQL_INTERVAL_HOUR
"SQL_INTERVAL_HOUR_TO_MINUTE"	SQL_INTERVAL_HOUR_TO_MINUTE
"SQL_INTERVAL_HOUR_TO_SECOND"	SQL_INTERVAL_HOUR_TO_SECOND
"SQL_INTERVAL_MINUTE"	SQL_INTERVAL_MINUTE
"SQL_INTERVAL_MINUTE_TO_SECOND"	SQL_INTERVAL_MINUTE_TO_SECOND
"SQL_INTERVAL_MONTH"	SQL_INTERVAL_MONTH
"SQL_INTERVAL_SECOND"	SQL_INTERVAL_SECOND
"SQL_INTERVAL_YEAR"	SQL_INTERVAL_YEAR
"SQL_INTERVAL_YEAR_TO_MONTH"	SQL_INTERVAL_YEAR_TO_MONTH
"SQL_LONGVARBINARY"	SQL_LONGVARBINARY
"SQL_LONGVARCHAR"	SQL_LONGVARCHAR
"SQL_NUMERIC"	SQL_NUMERIC
"SQL_REAL"	SQL_REAL
"SQL_SMALLINT"	SQL_SMALLINT
"SQL_TIME"	SQL_TIME
"SQL_TIMESTAMP"	SQL_TIMESTAMP
"SQL_TINYINT"	SQL_TINYINT
"SQL_VARBINARY"	SQL_VARBINARY
"SQL_VARCHAR"	SQL_VARCHAR
"SQL_WCHAR"	SQL_WCHAR
"SQL_WLONGVARCHAR"	SQL_WLONGVARCHAR
"SQL_WVARCHAR"	SQL_WVARCHAR
"SQL_TSI_FRAC_SECOND"	SQL_TSI_FRAC_SECOND
"SQL_TSI_SECOND"	SQL_TSI_SECOND
"SQL_TSI_MINUTE"	SQL_TSI_MINUTE
"SQL_TSI_HOUR"	SQL_TSI_HOUR
"SQL_TSI_DAY"	SQL_TSI_DAY
"SQL_TSI_WEEK"	SQL_TSI_WEEK
"SQL_TSI_MONTH"	SQL_TSI_MONTH
"SQL_TSI_QUARTER"	SQL_TSI_QUARTER
"SQL_TSI_YEAR"	SQL_TSI_YEAR

"LEAST"	MARGFUNC
"GREATEST"	MARGFUNC


[0-9]+"."[0-9]+	APPROXNUM
"@"	AT
aTYPE	aTYPE
BINARYNUM	BINARYNUM
"<"|">"|">="|"<="|"<>"	COMPARISON
"||"	CONCATSTRING
EMPTY	EMPTY
"|>"	GEOM_ABOVE
"<=|"	GEOM_BELOW
"->"	GEOM_DIST
GEOMETRYA	GEOMETRYA
"~="	GEOM_MBR_EQUAL
"&&"	GEOM_OVERLAP
"|&>"	GEOM_OVERLAP_OR_ABOVE
"&<|"	GEOM_OVERLAP_OR_BELOW
"&<"	GEOM_OVERLAP_OR_LEFT
"&>"	GEOM_OVERLAP_OR_RIGHT
HEXADECIMALNUM	HEXADECIMALNUM
HUGEINT	HUGEINT
INTNUM	INTNUM
"<<"	LEFT_SHIFT
"<<="	LEFT_SHIFT_ASSIGN
LEX_ERROR	LEX_ERROR

NOT\s+BETWEEN	NOT_BETWEEN
NOT\s+EXISTS	NOT_EXISTS
NOT\s+ILIKE	NOT_ILIKE
NOT\s+IN	NOT_IN
NOT\s+LIKE	NOT_LIKE

OCTALNUM	OCTALNUM
OIDNUM	OIDNUM
">>"	RIGHT_SHIFT
">>="	RIGHT_SHIFT_ASSIGN
";"	SCOLON
[0-9]+	sqlINT
'(\\.|[^'\r\n\\])*'	STRING
UIDENT	UIDENT
USTRING	USTRING
X_BODY	X_BODY
XSTRING	XSTRING

[ \t\r\n]   skip()
"/*"(?s:.)*?"*/"	skip()
"--".*	skip()
"#".*	skip()

\"[^"\r\n]+\"	IDENT
[A-Z_][A-Z0-9_]*	IDENT


%%
