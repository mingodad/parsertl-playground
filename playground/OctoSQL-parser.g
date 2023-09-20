//From: https://github.com/cube2222/octosql/blob/main/parser/sqlparser/sql.y
/*
Copyright 2017 Google Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

/*
Copyright 2019 The OctoSQL Authors

Licensed under the MIT license, as in the LICENSE file
*/

%option caseless

/*Tokens*/
//%token LEX_ERROR
%token UNION
%token SELECT
%token STREAM
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
%token WATERMARK
%token DELAY
%token COUNTING
%token AFTER
%token ALL
%token DISTINCT
%token AS
%token EXISTS
%token ASC
%token DESC
%token INTO
%token DUPLICATE
%token KEY
%token DEFAULT
%token SET
%token LOCK
%token UNLOCK
%token KEYS
%token VALUES
%token LAST_INSERT_ID
%token NEXT
//%token VALUE
%token SHARE
%token MODE
%token SQL_NO_CACHE
%token SQL_CACHE
%token JOIN
%token STRAIGHT_JOIN
%token LOOKUP
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
%token '('
%token ','
%token ')'
%token ID
%token HEX
%token STRING
%token INTEGRAL
%token FLOAT
%token HEXNUM
%token VALUE_ARG
%token LIST_ARG
%token COMMENT
%token COMMENT_KEYWORD
%token BIT_LITERAL
%token LIST_TYPE
%token OBJECT_TYPE
%token NULL
%token TRUE
%token FALSE
%token OFF
%token OR
%token AND
%token NOT
%token '!'
%token BETWEEN
%token CASE
%token WHEN
%token THEN
%token ELSE
%token END
%token OF
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
%token RIGHTARROW
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
%token NOT_LIKE_REGEXP
%token LIKE_REGEXP_CASE_INSENSITIVE
%token NOT_LIKE_REGEXP_CASE_INSENSITIVE
%token UNARY
%token COLLATE
%token BINARY
%token UNDERSCORE_BINARY
%token UNDERSCORE_UTF8MB4
%token INTERVAL
%token '.'
%token JSON_EXPLODE_OP
%token JSON_EXTRACT_OP
//%token JSON_UNQUOTE_EXTRACT_OP
%token CREATE
%token ALTER
%token DROP
%token RENAME
%token ANALYZE
%token ADD
%token FLUSH
%token SCHEMA
%token TABLE
%token DESCRIPTOR
%token INDEX
%token VIEW
%token TO
%token IGNORE
%token IF
%token UNIQUE
%token PRIMARY
%token COLUMN
%token SPATIAL
%token FULLTEXT
%token KEY_BLOCK_SIZE
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
%token MAXVALUE
%token PARTITION
%token REORGANIZE
%token LESS
%token THAN
%token PROCEDURE
%token TRIGGER
%token VINDEX
%token VINDEXES
%token STATUS
%token VARIABLES
%token WARNINGS
%token BEGIN
%token START
%token TRANSACTION
%token COMMIT
%token ROLLBACK
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
%token GEOMETRY
%token POINT
%token LINESTRING
%token POLYGON
%token GEOMETRYCOLLECTION
%token MULTIPOINT
%token MULTILINESTRING
%token MULTIPOLYGON
//%token NULLX
%token AUTO_INCREMENT
//%token APPROXNUM
%token SIGNED
%token UNSIGNED
%token ZEROFILL
%token COLLATION
%token DATABASES
%token SCHEMAS
%token TABLES
%token VITESS_KEYSPACES
%token VITESS_SHARDS
%token VITESS_TABLETS
%token VSCHEMA
%token VSCHEMA_TABLES
%token VITESS_TARGET
%token FULL
%token PROCESSLIST
%token COLUMNS
%token FIELDS
%token ENGINES
%token PLUGINS
%token NAMES
%token CHARSET
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
%token CURRENT_TIMESTAMP
%token DATABASE
%token CURRENT_DATE
%token CURRENT_TIME
%token LOCALTIME
%token LOCALTIMESTAMP
%token UTC_DATE
%token UTC_TIME
%token UTC_TIMESTAMP
%token REPLACE
%token CONVERT
%token CAST
%token SUBSTR
%token SUBSTRING
%token GROUP_CONCAT
%token SEPARATOR
%token TIMESTAMPADD
%token TIMESTAMPDIFF
%token MATCH
%token AGAINST
%token BOOLEAN
%token LANGUAGE
%token WITH
%token QUERY
%token EXPANSION
%token UNUSED
%token ';'
%token '['
%token ']'

%left /*1*/ UNION
%left /*2*/ JOIN STRAIGHT_JOIN LOOKUP LEFT RIGHT INNER OUTER CROSS NATURAL USE FORCE
%left /*3*/ ON USING
%left /*4*/ OR
%left /*5*/ AND
%right /*6*/ NOT '!'
%left /*7*/ BETWEEN CASE WHEN THEN ELSE END OF
%left /*8*/ '=' '<' '>' LE GE NE NULL_SAFE_EQUAL IS LIKE REGEXP IN RIGHTARROW
%left /*9*/ '|'
%left /*10*/ '&'
%left /*11*/ SHIFT_LEFT SHIFT_RIGHT
%left /*12*/ '+' '-'
%left /*13*/ '*' '/' DIV '%' MOD
%left /*14*/ '^'
%right /*15*/ '~' NOT_LIKE_REGEXP LIKE_REGEXP_CASE_INSENSITIVE NOT_LIKE_REGEXP_CASE_INSENSITIVE UNARY
%left /*16*/ COLLATE
%right /*17*/ BINARY UNDERSCORE_BINARY UNDERSCORE_UTF8MB4
%right /*18*/ INTERVAL
%nonassoc /*19*/ '.'

%start command_list

%%

command_list :
    any_command
    | command_list any_command
    ;

any_command :
	command semicolon_opt
	;

semicolon_opt :
	/*empty*/
	| ';'
	;

command :
	select_statement
	| stream_statement
	| insert_statement
	| update_statement
	| delete_statement
	| set_statement
	| create_statement
	| alter_statement
	| rename_statement
	| drop_statement
	| truncate_statement
	| analyze_statement
	| show_statement
	| use_statement
	| begin_statement
	| commit_statement
	| rollback_statement
	| other_statement
	| flush_statement
	| /*empty*/
	;

select_statement :
	base_select order_by_opt limit_opt lock_opt
	| WITH cte_list comma_opt select_statement
	| union_lhs union_op union_rhs order_by_opt limit_opt lock_opt
	| SELECT comment_opt cache_opt NEXT num_val for_from table_name
	;

comma_opt :
	/*empty*/
	| ','
	;

cte_list :
	cte
	| cte_list ',' cte
	;

cte :
	table_alias AS openb select_statement closeb
	;

stream_statement :
	STREAM comment_opt select_expression FROM table_name
	;

base_select :
	SELECT comment_opt cache_opt distinct_opt straight_join_opt select_expression_list from_opt where_expression_opt group_by_opt having_opt trigger_opt
	;

union_lhs :
	openb select_statement closeb
	;

union_rhs :
	base_select
	| openb select_statement closeb
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
	UPDATE comment_opt ignore_opt table_references SET update_list where_expression_opt order_by_opt limit_opt
	;

delete_statement :
	DELETE comment_opt FROM table_name opt_partition_clause where_expression_opt order_by_opt limit_opt
	| DELETE comment_opt FROM table_name_list USING /*3L*/ table_references where_expression_opt
	| DELETE comment_opt table_name_list from_or_using table_references where_expression_opt
	| DELETE comment_opt delete_table_list from_or_using table_references where_expression_opt
	;

from_or_using :
	FROM
	| USING /*3L*/
	;

table_name_list :
	table_name
	| table_name_list ',' table_name
	;

delete_table_list :
	delete_table_name
	| delete_table_list ',' delete_table_name
	;

opt_partition_clause :
	/*empty*/
	| PARTITION openb partition_list closeb
	;

set_statement :
	SET comment_opt set_list
	| SET comment_opt set_session_or_global set_list
	| SET comment_opt set_session_or_global TRANSACTION transaction_chars
	| SET comment_opt TRANSACTION transaction_chars
	;

transaction_chars :
	transaction_char
	| transaction_chars ',' transaction_char
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
	| GLOBAL
	;

create_statement :
	create_table_prefix table_spec
	| create_table_prefix create_like
	| CREATE constraint_opt INDEX ID using_opt ON /*3L*/ table_name ddl_skip_to_end
	| CREATE VIEW table_name ddl_skip_to_end
	| CREATE OR /*4L*/ REPLACE VIEW table_name ddl_skip_to_end
	| CREATE DATABASE not_exists_opt ID ddl_skip_to_end
	| CREATE SCHEMA not_exists_opt ID ddl_skip_to_end
	;

vindex_type_opt :
	/*empty*/
	| USING /*3L*/ vindex_type
	;

vindex_type :
	ID
	;

vindex_params_opt :
	/*empty*/
	| WITH vindex_param_list
	;

vindex_param_list :
	vindex_param
	| vindex_param_list ',' vindex_param
	;

vindex_param :
	reserved_sql_id '=' /*8L*/ table_opt_value
	;

create_table_prefix :
	CREATE TABLE not_exists_opt table_name
	;

table_spec :
	'(' table_column_list ')' table_option_list
	;

create_like :
	LIKE /*8L*/ table_name
	| '(' LIKE /*8L*/ table_name ')'
	;

table_column_list :
	column_definition
	| table_column_list ',' column_definition
	| table_column_list ',' index_definition
	| table_column_list ',' constraint_definition
	;

column_definition :
	ID column_type null_opt column_default_opt on_update_opt auto_increment_opt column_key_opt column_comment_opt
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
	REAL float_length_opt
	| DOUBLE float_length_opt
	| FLOAT_TYPE float_length_opt
	| DECIMAL decimal_length_opt
	| NUMERIC decimal_length_opt
	;

time_type :
	DATE
	| TIME length_opt
	| TIMESTAMP length_opt
	| DATETIME length_opt
	| YEAR
	;

char_type :
	CHAR length_opt charset_opt collate_opt
	| VARCHAR length_opt charset_opt collate_opt
	| BINARY /*17R*/ length_opt
	| VARBINARY length_opt
	| TEXT charset_opt collate_opt
	| TINYTEXT charset_opt collate_opt
	| MEDIUMTEXT charset_opt collate_opt
	| LONGTEXT charset_opt collate_opt
	| BLOB
	| TINYBLOB
	| MEDIUMBLOB
	| LONGBLOB
	| JSON
	| ENUM '(' enum_values ')' charset_opt collate_opt
	| SET '(' enum_values ')' charset_opt collate_opt
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
	STRING
	| enum_values ',' STRING
	;

length_opt :
	/*empty*/
	| '(' INTEGRAL ')'
	;

float_length_opt :
	/*empty*/
	| '(' INTEGRAL ',' INTEGRAL ')'
	;

decimal_length_opt :
	/*empty*/
	| '(' INTEGRAL ')'
	| '(' INTEGRAL ',' INTEGRAL ')'
	;

unsigned_opt :
	/*empty*/
	| UNSIGNED
	;

zero_fill_opt :
	/*empty*/
	| ZEROFILL
	;

null_opt :
	/*empty*/
	| NULL
	| NOT /*6R*/ NULL
	;

column_default_opt :
	/*empty*/
	| DEFAULT value_expression
	;

on_update_opt :
	/*empty*/
	| ON /*3L*/ UPDATE function_call_nonkeyword
	;

auto_increment_opt :
	/*empty*/
	| AUTO_INCREMENT
	;

charset_opt :
	/*empty*/
	| CHARACTER SET ID
	| CHARACTER SET BINARY /*17R*/
	;

collate_opt :
	/*empty*/
	| COLLATE /*16L*/ ID
	| COLLATE /*16L*/ STRING
	;

column_key_opt :
	/*empty*/
	| PRIMARY KEY
	| KEY
	| UNIQUE KEY
	| UNIQUE
	;

column_comment_opt :
	/*empty*/
	| COMMENT_KEYWORD STRING
	;

index_definition :
	index_info '(' index_column_list ')' index_option_list
	| index_info '(' index_column_list ')'
	;

index_option_list :
	index_option
	| index_option_list index_option
	;

index_option :
	USING /*3L*/ ID
	| KEY_BLOCK_SIZE equal_opt INTEGRAL
	| COMMENT_KEYWORD STRING
	;

equal_opt :
	/*empty*/
	| '=' /*8L*/
	;

index_info :
	PRIMARY KEY
	| SPATIAL index_or_key name_opt
	| UNIQUE index_or_key name_opt
	| UNIQUE name_opt
	| index_or_key name_opt
	;

index_or_key :
	INDEX
	| KEY
	;

name_opt :
	/*empty*/
	| ID
	;

index_column_list :
	index_column
	| index_column_list ',' index_column
	;

index_column :
	sql_id length_opt
	;

constraint_definition :
	CONSTRAINT ID constraint_info
	| constraint_info
	;

constraint_info :
	FOREIGN KEY '(' column_list ')' REFERENCES table_name '(' column_list ')'
	| FOREIGN KEY '(' column_list ')' REFERENCES table_name '(' column_list ')' fk_on_delete
	| FOREIGN KEY '(' column_list ')' REFERENCES table_name '(' column_list ')' fk_on_update
	| FOREIGN KEY '(' column_list ')' REFERENCES table_name '(' column_list ')' fk_on_delete fk_on_update
	;

fk_on_delete :
	ON /*3L*/ DELETE fk_reference_action
	;

fk_on_update :
	ON /*3L*/ UPDATE fk_reference_action
	;

fk_reference_action :
	RESTRICT
	| CASCADE
	| NO ACTION
	| SET DEFAULT
	| SET NULL
	;

table_option_list :
	/*empty*/
	| table_option
	| table_option_list ',' table_option
	;

table_option :
	table_opt_value
	| table_option table_opt_value
	| table_option '=' /*8L*/ table_opt_value
	;

table_opt_value :
	reserved_sql_id
	| STRING
	| INTEGRAL
	;

alter_statement :
	ALTER ignore_opt TABLE table_name non_add_drop_or_rename_operation skip_to_end
	| ALTER ignore_opt TABLE table_name ADD alter_object_type skip_to_end
	| ALTER ignore_opt TABLE table_name DROP alter_object_type skip_to_end
	| ALTER ignore_opt TABLE table_name RENAME to_opt table_name
	| ALTER ignore_opt TABLE table_name RENAME index_opt skip_to_end
	| ALTER VIEW table_name ddl_skip_to_end
	| ALTER ignore_opt TABLE table_name partition_operation
	| ALTER VSCHEMA CREATE VINDEX sql_id vindex_type_opt vindex_params_opt
	| ALTER VSCHEMA DROP VINDEX sql_id
	| ALTER VSCHEMA ADD TABLE table_name
	| ALTER VSCHEMA DROP TABLE table_name
	| ALTER VSCHEMA ON /*3L*/ table_name ADD VINDEX sql_id '(' column_list ')' vindex_type_opt vindex_params_opt
	| ALTER VSCHEMA ON /*3L*/ table_name DROP VINDEX sql_id
	;

alter_object_type :
	COLUMN
	| CONSTRAINT
	| FOREIGN
	| FULLTEXT
	| ID
	| INDEX
	| KEY
	| PRIMARY
	| SPATIAL
	| PARTITION
	| UNIQUE
	;

partition_operation :
	REORGANIZE PARTITION sql_id INTO openb partition_definitions closeb
	;

partition_definitions :
	partition_definition
	| partition_definitions ',' partition_definition
	;

partition_definition :
	PARTITION sql_id VALUES LESS THAN openb value_expression closeb
	| PARTITION sql_id VALUES LESS THAN openb MAXVALUE closeb
	;

rename_statement :
	RENAME TABLE rename_list
	;

rename_list :
	table_name TO table_name
	| rename_list ',' table_name TO table_name
	;

drop_statement :
	DROP TABLE exists_opt table_name_list
	| DROP INDEX ID ON /*3L*/ table_name ddl_skip_to_end
	| DROP VIEW exists_opt table_name ddl_skip_to_end
	| DROP DATABASE exists_opt ID
	| DROP SCHEMA exists_opt ID
	;

truncate_statement :
	TRUNCATE TABLE table_name
	| TRUNCATE table_name
	;

analyze_statement :
	ANALYZE TABLE table_name
	;

show_statement :
	SHOW BINARY /*17R*/ ID ddl_skip_to_end
	| SHOW CHARSET ddl_skip_to_end
	| SHOW CREATE DATABASE ddl_skip_to_end
	| SHOW CREATE ID ddl_skip_to_end
	| SHOW CREATE PROCEDURE ddl_skip_to_end
	| SHOW CREATE TABLE table_name
	| SHOW CREATE TRIGGER ddl_skip_to_end
	| SHOW CREATE VIEW ddl_skip_to_end
	| SHOW DATABASES ddl_skip_to_end
	| SHOW SCHEMAS ddl_skip_to_end
	| SHOW ENGINES
	| SHOW INDEX ddl_skip_to_end
	| SHOW KEYS ddl_skip_to_end
	| SHOW PLUGINS
	| SHOW PROCEDURE ddl_skip_to_end
	| SHOW show_session_or_global STATUS ddl_skip_to_end
	| SHOW TABLE ddl_skip_to_end
	| SHOW full_opt columns_or_fields FROM table_name from_database_opt like_or_where_opt
	| SHOW full_opt tables_or_processlist from_database_opt like_or_where_opt
	| SHOW show_session_or_global VARIABLES ddl_skip_to_end
	| SHOW COLLATION
	| SHOW COLLATION WHERE expression
	| SHOW VITESS_KEYSPACES
	| SHOW VITESS_SHARDS
	| SHOW VITESS_TABLETS
	| SHOW VITESS_TARGET
	| SHOW VSCHEMA TABLES
	| SHOW VSCHEMA VINDEXES
	| SHOW VSCHEMA VINDEXES ON /*3L*/ table_name
	| SHOW WARNINGS
	| SHOW ID ddl_skip_to_end
	;

tables_or_processlist :
	TABLES
	| PROCESSLIST
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
	| IN /*8L*/ table_id
	;

like_or_where_opt :
	/*empty*/
	| LIKE /*8L*/ STRING
	| WHERE expression
	;

show_session_or_global :
	/*empty*/
	| SESSION
	| GLOBAL
	;

use_statement :
	USE /*2L*/ table_id
	| USE /*2L*/
	;

begin_statement :
	BEGIN
	| START TRANSACTION
	;

commit_statement :
	COMMIT
	;

rollback_statement :
	ROLLBACK
	;

other_statement :
	DESC skip_to_end
	| DESCRIBE skip_to_end
	| EXPLAIN skip_to_end
	| REPAIR skip_to_end
	| OPTIMIZE skip_to_end
	| LOCK TABLES skip_to_end
	| UNLOCK TABLES skip_to_end
	;

flush_statement :
	FLUSH skip_to_end
	;

comment_opt :
	comment_list
	;

comment_list :
	/*empty*/
	| comment_list COMMENT
	;

union_op :
	UNION /*1L*/
	| UNION /*1L*/ ALL
	| UNION /*1L*/ DISTINCT
	;

cache_opt :
	/*empty*/
	| SQL_NO_CACHE
	| SQL_CACHE
	;

distinct_opt :
	/*empty*/
	| DISTINCT
	;

straight_join_opt :
	/*empty*/
	| STRAIGHT_JOIN /*2L*/
	;

select_expression_list_opt :
	/*empty*/
	| select_expression_list
	;

select_expression_list :
	select_expression
	| select_expression_list ',' select_expression
	;

select_expression :
	'*' /*13L*/
	| expression as_ci_opt
	| table_id '.' /*19N*/ '*' /*13L*/
	| table_id '.' /*19N*/ reserved_table_id '.' /*19N*/ '*' /*13L*/
	| value_expression JSON_EXPLODE_OP
	;

as_ci_opt :
	/*empty*/
	| col_alias
	| AS col_alias
	;

col_alias :
	sql_id
	| STRING
	;

from_opt :
	/*empty*/
	| FROM table_references
	;

table_references :
	table_reference
	| table_references ',' table_reference
	;

table_reference :
	table_factor
	| join_table
	;

table_factor :
	aliased_table_name
	| subquery as_opt table_id
	| subquery
	| openb table_references closeb
	| ID openb table_valued_function_arguments_opt closeb as_opt table_id
	;

aliased_table_name :
	table_name as_opt_id index_hint_list
	| table_name PARTITION openb partition_list closeb as_opt_id index_hint_list
	;

table_valued_function_arguments_opt :
	/*empty*/
	| table_valued_function_arguments
	;

table_valued_function_arguments :
	table_valued_function_argument
	| table_valued_function_arguments ',' table_valued_function_argument
	;

table_valued_function_argument :
	sql_id RIGHTARROW /*8L*/ table_valued_function_argument_value
	;

table_valued_function_argument_value :
	expression
	| TABLE openb table_reference closeb
	| DESCRIPTOR openb column_name closeb
	;

column_list :
	sql_id
	| column_list ',' sql_id
	;

partition_list :
	sql_id
	| partition_list ',' sql_id
	;

join_table :
	table_reference strategy_opt inner_join table_factor join_condition_opt
	| table_reference straight_join table_factor on_expression_opt
	| table_reference outer_join table_reference join_condition
	| table_reference natural_join table_factor
	;

join_condition :
	ON /*3L*/ expression
	| USING /*3L*/ '(' column_list ')'
	;

join_condition_opt :
	%prec JOIN /*2L*/ /*empty*/
	| join_condition
	;

on_expression_opt :
	%prec JOIN /*2L*/ /*empty*/
	| ON /*3L*/ expression
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

strategy_opt :
	/*empty*/
	| LOOKUP /*2L*/
	| STREAM
	;

table_alias :
	table_id
	| STRING
	;

inner_join :
	JOIN /*2L*/
	| INNER /*2L*/ JOIN /*2L*/
	| CROSS /*2L*/ JOIN /*2L*/
	;

straight_join :
	STRAIGHT_JOIN /*2L*/
	;

outer_join :
	LEFT /*2L*/ JOIN /*2L*/
	| LEFT /*2L*/ OUTER /*2L*/ JOIN /*2L*/
	| RIGHT /*2L*/ JOIN /*2L*/
	| RIGHT /*2L*/ OUTER /*2L*/ JOIN /*2L*/
	| OUTER /*2L*/ JOIN /*2L*/
	;

natural_join :
	NATURAL /*2L*/ JOIN /*2L*/
	| NATURAL /*2L*/ outer_join
	;

into_table_name :
	INTO table_name
	| table_name
	;

table_name :
	table_id
	| table_id '.' /*19N*/ reserved_table_id
	;

delete_table_name :
	table_id '.' /*19N*/ '*' /*13L*/
	;

index_hint_list :
	/*empty*/
	| USE /*2L*/ INDEX openb column_list closeb
	| IGNORE INDEX openb column_list closeb
	| FORCE /*2L*/ INDEX openb column_list closeb
	;

where_expression_opt :
	/*empty*/
	| WHERE expression
	;

expression :
	condition
	| expression AND /*5L*/ expression
	| expression OR /*4L*/ expression
	| NOT /*6R*/ expression
	| expression IS /*8L*/ is_suffix
	| value_expression
	| DEFAULT default_opt
	;

default_opt :
	/*empty*/
	| openb ID closeb
	;

boolean_value :
	TRUE
	| FALSE
	;

condition :
	value_expression compare value_expression
	| value_expression IN /*8L*/ col_tuple
	| value_expression NOT /*6R*/ IN /*8L*/ col_tuple
	| value_expression LIKE /*8L*/ value_expression like_escape_opt
	| value_expression NOT /*6R*/ LIKE /*8L*/ value_expression like_escape_opt
	| value_expression '~' /*15R*/ value_expression
	| value_expression LIKE_REGEXP_CASE_INSENSITIVE /*15R*/ value_expression
	| value_expression NOT_LIKE_REGEXP /*15R*/ value_expression
	| value_expression NOT_LIKE_REGEXP_CASE_INSENSITIVE /*15R*/ value_expression
	| value_expression REGEXP /*8L*/ value_expression
	| value_expression NOT /*6R*/ REGEXP /*8L*/ value_expression
	| value_expression BETWEEN /*7L*/ value_expression AND /*5L*/ value_expression
	| value_expression NOT /*6R*/ BETWEEN /*7L*/ value_expression AND /*5L*/ value_expression
	| EXISTS subquery
	;

is_suffix :
	NULL
	| NOT /*6R*/ NULL
	| TRUE
	| NOT /*6R*/ TRUE
	| FALSE
	| NOT /*6R*/ FALSE
	;

compare :
	'=' /*8L*/
	| '<' /*8L*/
	| '>' /*8L*/
	| LE /*8L*/
	| GE /*8L*/
	| NE /*8L*/
	| NULL_SAFE_EQUAL /*8L*/
	;

like_escape_opt :
	/*empty*/
	| ESCAPE value_expression
	;

col_tuple :
	row_tuple
	| subquery
	| LIST_ARG
	;

subquery :
	openb select_statement closeb
	;

expression_list :
	expression
	| expression_list ',' expression
	;

value_expression :
	value
	| boolean_value
	| column_name
	| tuple_expression
	| subquery
	| value_expression '&' /*10L*/ value_expression
	| value_expression '|' /*9L*/ value_expression
	| value_expression '^' /*14L*/ value_expression
	| value_expression '+' /*12L*/ value_expression
	| value_expression '-' /*12L*/ value_expression
	| value_expression '*' /*13L*/ value_expression
	| value_expression '/' /*13L*/ value_expression
	| value_expression DIV /*13L*/ value_expression
	| value_expression '%' /*13L*/ value_expression
	| value_expression MOD /*13L*/ value_expression
	| value_expression SHIFT_LEFT /*11L*/ value_expression
	| value_expression SHIFT_RIGHT /*11L*/ value_expression
	| value_expression COLLATE /*16L*/ charset
	| BINARY /*17R*/ value_expression %prec UNARY /*15R*/
	| UNDERSCORE_BINARY /*17R*/ value_expression %prec UNARY /*15R*/
	| UNDERSCORE_UTF8MB4 /*17R*/ value_expression %prec UNARY /*15R*/
	| '+' /*12L*/ value_expression %prec UNARY /*15R*/
	| '-' /*12L*/ value_expression %prec UNARY /*15R*/
	| '~' /*15R*/ value_expression
	| '!' /*6R*/ value_expression %prec UNARY /*15R*/
	| INTERVAL /*18R*/ value_expression sql_id
	| function_call_generic
	| function_call_keyword
	| function_call_nonkeyword
	| function_call_conflict
	| value_expression '[' value_expression ']'
	| value_expression LIST_ARG convert_type
	| value_expression JSON_EXTRACT_OP sql_id
	;

function_call_generic :
	sql_id openb select_expression_list_opt closeb
	| sql_id openb DISTINCT select_expression_list closeb
	| table_id '.' /*19N*/ reserved_sql_id openb select_expression_list_opt closeb
	;

function_call_keyword :
	LEFT /*2L*/ openb select_expression_list closeb
	| RIGHT /*2L*/ openb select_expression_list closeb
	| CONVERT openb expression ',' convert_type closeb
	| CAST openb expression AS convert_type closeb
	| CONVERT openb expression USING /*3L*/ charset closeb
	| SUBSTR openb column_name FROM value_expression FOR value_expression closeb
	| SUBSTRING openb column_name FROM value_expression FOR value_expression closeb
	| SUBSTR openb STRING FROM value_expression FOR value_expression closeb
	| SUBSTRING openb STRING FROM value_expression FOR value_expression closeb
	| MATCH openb select_expression_list closeb AGAINST openb value_expression match_option closeb
	| GROUP_CONCAT openb distinct_opt select_expression_list order_by_opt separator_opt closeb
	| CASE /*7L*/ expression_opt when_expression_list else_expression_opt END /*7L*/
	| VALUES openb column_name closeb
	;

function_call_nonkeyword :
	CURRENT_TIMESTAMP func_datetime_opt
	| UTC_TIMESTAMP func_datetime_opt
	| UTC_TIME func_datetime_opt
	| UTC_DATE func_datetime_opt
	| LOCALTIME func_datetime_opt
	| LOCALTIMESTAMP func_datetime_opt
	| CURRENT_DATE func_datetime_opt
	| CURRENT_TIME func_datetime_opt
	| CURRENT_TIMESTAMP func_datetime_precision
	| UTC_TIMESTAMP func_datetime_precision
	| UTC_TIME func_datetime_precision
	| LOCALTIME func_datetime_precision
	| LOCALTIMESTAMP func_datetime_precision
	| CURRENT_TIME func_datetime_precision
	| TIMESTAMPADD openb sql_id ',' value_expression ',' value_expression closeb
	| TIMESTAMPDIFF openb sql_id ',' value_expression ',' value_expression closeb
	;

func_datetime_opt :
	/*empty*/
	| openb closeb
	;

func_datetime_precision :
	openb value_expression closeb
	;

function_call_conflict :
	IF openb select_expression_list closeb
	| DATABASE openb select_expression_list_opt closeb
	| MOD /*13L*/ openb select_expression_list closeb
	| REPLACE openb select_expression_list closeb
	| SUBSTR openb select_expression_list closeb
	| SUBSTRING openb select_expression_list closeb
	;

match_option :
	/*empty*/
	| IN /*8L*/ BOOLEAN MODE
	| IN /*8L*/ NATURAL /*2L*/ LANGUAGE MODE
	| IN /*8L*/ NATURAL /*2L*/ LANGUAGE MODE WITH QUERY EXPANSION
	| WITH QUERY EXPANSION
	;

charset :
	ID
	| STRING
	;

convert_type :
	ID
	| non_reserved_keyword
	| LIST_TYPE
	| OBJECT_TYPE
	;

expression_opt :
	/*empty*/
	| expression
	;

separator_opt :
	/*empty*/
	| SEPARATOR STRING
	;

when_expression_list :
	when_expression
	| when_expression_list when_expression
	;

when_expression :
	WHEN /*7L*/ expression THEN /*7L*/ expression
	;

else_expression_opt :
	/*empty*/
	| ELSE /*7L*/ expression
	;

column_name :
	sql_id
	| table_id '.' /*19N*/ reserved_sql_id
	| table_id '.' /*19N*/ reserved_table_id '.' /*19N*/ reserved_sql_id
	;

value :
	STRING
	| HEX
	| BIT_LITERAL
	| INTEGRAL
	| FLOAT
	| HEXNUM
	| VALUE_ARG
	| NULL
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

order_by_opt :
	/*empty*/
	| ORDER BY order_list
	;

order_list :
	order
	| order_list ',' order
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
	| LIMIT expression
	| LIMIT expression ',' expression
	| LIMIT expression OFFSET expression
	;

lock_opt :
	/*empty*/
	| FOR UPDATE
	| LOCK IN /*8L*/ SHARE MODE
	;

trigger_opt :
	/*empty*/
	| TRIGGER trigger_list
	;

trigger_list :
	trigger
	| trigger_list ',' trigger
	;

trigger :
	ON /*3L*/ WATERMARK
	| ON /*3L*/ END /*7L*/ OF /*7L*/ STREAM
	| AFTER DELAY expression
	| COUNTING expression
	;

insert_data :
	VALUES tuple_list
	| select_statement
	| openb select_statement closeb
	| openb ins_column_list closeb VALUES tuple_list
	| openb ins_column_list closeb select_statement
	| openb ins_column_list closeb openb select_statement closeb
	;

ins_column_list :
	sql_id
	| sql_id '.' /*19N*/ sql_id
	| ins_column_list ',' sql_id
	| ins_column_list ',' sql_id '.' /*19N*/ sql_id
	;

on_dup_opt :
	/*empty*/
	| ON /*3L*/ DUPLICATE KEY UPDATE update_list
	;

tuple_list :
	tuple_or_empty
	| tuple_list ',' tuple_or_empty
	;

tuple_or_empty :
	row_tuple
	| openb closeb
	;

row_tuple :
	openb expression_list closeb
	;

tuple_expression :
	row_tuple
	;

update_list :
	update_expression
	| update_list ',' update_expression
	;

update_expression :
	column_name '=' /*8L*/ expression
	;

set_list :
	set_expression
	| set_list ',' set_expression
	;

set_expression :
	reserved_sql_id '=' /*8L*/ ON /*3L*/
	| reserved_sql_id '=' /*8L*/ OFF
	| reserved_sql_id '=' /*8L*/ expression
	| charset_or_character_set charset_value collate_opt
	;

charset_or_character_set :
	CHARSET
	| CHARACTER SET
	| NAMES
	;

charset_value :
	sql_id
	| STRING
	| DEFAULT
	;

for_from :
	FOR
	| FROM
	;

exists_opt :
	/*empty*/
	| IF EXISTS
	;

not_exists_opt :
	/*empty*/
	| IF NOT /*6R*/ EXISTS
	;

ignore_opt :
	/*empty*/
	| IGNORE
	;

non_add_drop_or_rename_operation :
	ALTER
	| AUTO_INCREMENT
	| CHARACTER
	| COMMENT_KEYWORD
	| DEFAULT
	| ORDER
	| CONVERT
	| PARTITION
	| UNUSED
	| ID
	;

to_opt :
	/*empty*/
	| TO
	| AS
	;

index_opt :
	INDEX
	| KEY
	;

constraint_opt :
	/*empty*/
	| UNIQUE
	| sql_id
	;

using_opt :
	/*empty*/
	| USING /*3L*/ sql_id
	;

sql_id :
	ID
	| non_reserved_keyword
	;

reserved_sql_id :
	sql_id
	| reserved_keyword
	;

table_id :
	ID
	| non_reserved_keyword
	;

reserved_table_id :
	table_id
	| reserved_keyword
	;

reserved_keyword :
	ADD
	| AND /*5L*/
	| AS
	| ASC
	| AUTO_INCREMENT
	| BETWEEN /*7L*/
	| BINARY /*17R*/
	| BY
	| CASE /*7L*/
	| COLLATE /*16L*/
	| CONVERT
	| CREATE
	| CROSS /*2L*/
	| CURRENT_DATE
	| CURRENT_TIME
	| CURRENT_TIMESTAMP
	| SUBSTR
	| SUBSTRING
	| DATABASE
	| DATABASES
	| DEFAULT
	| DELETE
	| DESC
	| DESCRIBE
	| DISTINCT
	| DIV /*13L*/
	| DROP
	| ELSE /*7L*/
	| ESCAPE
	| EXISTS
	| EXPLAIN
	| FALSE
	| FOR
	| FORCE /*2L*/
	| FROM
	| GROUP
	| HAVING
	| IF
	| IGNORE
	| IN /*8L*/
	| INDEX
	| INNER /*2L*/
	| INSERT
	| INTERVAL /*18R*/
	| INTO
	| IS /*8L*/
	| JOIN /*2L*/
	| KEY
	| LEFT /*2L*/
	| LIKE /*8L*/
	| LIMIT
	| LOCALTIME
	| LOCALTIMESTAMP
	| LOCK
	| MATCH
	| MAXVALUE
	| MOD /*13L*/
	| NATURAL /*2L*/
	| NEXT
	| NOT /*6R*/
	| NULL
	| OFF
	| ON /*3L*/
	| OR /*4L*/
	| ORDER
	| OUTER /*2L*/
	| REGEXP /*8L*/
	| RENAME
	| REPLACE
	| RIGHT /*2L*/
	| SCHEMA
	| SELECT
	| SEPARATOR
	| SET
	| SHOW
	| STRAIGHT_JOIN /*2L*/
	| TABLE
	| THEN /*7L*/
	| TIMESTAMPADD
	| TIMESTAMPDIFF
	| TO
	| TRIGGER
	| TRUE
	| UNION /*1L*/
	| UNIQUE
	| UNLOCK
	| UPDATE
	| USE /*2L*/
	| USING /*3L*/
	| UTC_DATE
	| UTC_TIME
	| UTC_TIMESTAMP
	| VALUES
	| WHEN /*7L*/
	| WHERE
	| WITH
	;

non_reserved_keyword :
	AFTER
	| AGAINST
	| ACTION
	| BEGIN
	| BIGINT
	| BIT
	| BLOB
	| BOOL
	| BOOLEAN
	| CASCADE
	| CHAR
	| CHARACTER
	| CHARSET
	| COLLATION
	| COLUMNS
	| COMMENT_KEYWORD
	| COMMIT
	| COMMITTED
	| COUNTING
	| DATE
	| DATETIME
	| DECIMAL
	| DELAY
	| DOUBLE
	| DUPLICATE
	| ENGINES
	| END /*7L*/
	| ENUM
	| EXPANSION
	| FLOAT_TYPE
	| FIELDS
	| FLUSH
	| FOREIGN
	| FULLTEXT
	| GEOMETRY
	| GEOMETRYCOLLECTION
	| GLOBAL
	| INT
	| INTEGER
	| ISOLATION
	| JSON
	| KEY_BLOCK_SIZE
	| KEYS
	| LANGUAGE
	| LAST_INSERT_ID
	| LESS
	| LEVEL
	| LINESTRING
	| LONGBLOB
	| LONGTEXT
	| MEDIUMBLOB
	| MEDIUMINT
	| MEDIUMTEXT
	| MODE
	| MULTILINESTRING
	| MULTIPOINT
	| MULTIPOLYGON
	| NAMES
	| NCHAR
	| NO
	| NUMERIC
	| OF /*7L*/
	| OFFSET
	| ONLY
	| OPTIMIZE
	| PARTITION
	| PLUGINS
	| POINT
	| POLYGON
	| PRIMARY
	| PROCEDURE
	| QUERY
	| READ
	| REAL
	| REFERENCES
	| REORGANIZE
	| REPAIR
	| REPEATABLE
	| RESTRICT
	| ROLLBACK
	| SCHEMAS
	| SESSION
	| SERIALIZABLE
	| SHARE
	| SIGNED
	| SMALLINT
	| SPATIAL
	| START
	| STATUS
	| TABLES
	| TEXT
	| THAN
	| TIME
	| TIMESTAMP
	| TINYBLOB
	| TINYINT
	| TINYTEXT
	| TRANSACTION
	| TRUNCATE
	| UNCOMMITTED
	| UNSIGNED
	| UNUSED
	| VARBINARY
	| VARCHAR
	| VARIABLES
	| VIEW
	| VINDEX
	| VINDEXES
	| VITESS_KEYSPACES
	| VITESS_SHARDS
	| VITESS_TABLETS
	| VSCHEMA
	| VSCHEMA_TABLES
	| VITESS_TARGET
	| WARNINGS
	| WATERMARK
	| WRITE
	| YEAR
	| ZEROFILL
	;

openb :
	'('
	;

closeb :
	')'
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
"["	'['
"]"	']'

ACTION	ACTION
ADD	ADD
AFTER	AFTER
AGAINST	AGAINST
ALL	ALL
ALTER	ALTER
ANALYZE	ANALYZE
AND	AND
AS	AS
ASC	ASC
AUTO_INCREMENT	AUTO_INCREMENT
BEGIN	BEGIN
BETWEEN	BETWEEN
BIGINT	BIGINT
BINARY	BINARY
BIT	BIT
BIT_LITERAL	BIT_LITERAL
BLOB	BLOB
BOOL	BOOL
BOOLEAN	BOOLEAN
BY	BY
CASCADE	CASCADE
CASE	CASE
CAST	CAST
CHAR	CHAR
CHARACTER	CHARACTER
CHARSET	CHARSET
COLLATE	COLLATE
COLLATION	COLLATION
COLUMN	COLUMN
COLUMNS	COLUMNS
COMMENT	COMMENT
COMMENT_KEYWORD	COMMENT_KEYWORD
COMMIT	COMMIT
COMMITTED	COMMITTED
CONSTRAINT	CONSTRAINT
CONVERT	CONVERT
COUNTING	COUNTING
CREATE	CREATE
CROSS	CROSS
CURRENT_DATE	CURRENT_DATE
CURRENT_TIME	CURRENT_TIME
CURRENT_TIMESTAMP	CURRENT_TIMESTAMP
DATABASE	DATABASE
DATABASES	DATABASES
DATE	DATE
DATETIME	DATETIME
DECIMAL	DECIMAL
DEFAULT	DEFAULT
DELAY	DELAY
DELETE	DELETE
DESC	DESC
DESCRIBE	DESCRIBE
DESCRIPTOR	DESCRIPTOR
DISTINCT	DISTINCT
DIV	DIV
DOUBLE	DOUBLE
DROP	DROP
DUPLICATE	DUPLICATE
ELSE	ELSE
END	END
ENGINES	ENGINES
ENUM	ENUM
ESCAPE	ESCAPE
EXISTS	EXISTS
EXPANSION	EXPANSION
EXPLAIN	EXPLAIN
FALSE	FALSE
FIELDS	FIELDS
FLOAT_TYPE	FLOAT_TYPE
FLUSH	FLUSH
FOR	FOR
FORCE	FORCE
FOREIGN	FOREIGN
FROM	FROM
FULL	FULL
FULLTEXT	FULLTEXT
GE	GE
GEOMETRY	GEOMETRY
GEOMETRYCOLLECTION	GEOMETRYCOLLECTION
GLOBAL	GLOBAL
GROUP	GROUP
GROUP_CONCAT	GROUP_CONCAT
HAVING	HAVING
HEX	HEX
HEXNUM	HEXNUM
IF	IF
IGNORE	IGNORE
IN	IN
INDEX	INDEX
INNER	INNER
INSERT	INSERT
INT	INT
INTEGER	INTEGER
INTERVAL	INTERVAL
INTO	INTO
IS	IS
ISOLATION	ISOLATION
JOIN	JOIN
JSON	JSON
JSON_EXPLODE_OP	JSON_EXPLODE_OP
JSON_EXTRACT_OP	JSON_EXTRACT_OP
KEY	KEY
KEY_BLOCK_SIZE	KEY_BLOCK_SIZE
KEYS	KEYS
LANGUAGE	LANGUAGE
LAST_INSERT_ID	LAST_INSERT_ID
LE	LE
LEFT	LEFT
LESS	LESS
LEVEL	LEVEL
LIKE	LIKE
LIKE_REGEXP_CASE_INSENSITIVE	LIKE_REGEXP_CASE_INSENSITIVE
LIMIT	LIMIT
LINESTRING	LINESTRING
LIST_ARG	LIST_ARG
LIST_TYPE	LIST_TYPE
LOCALTIME	LOCALTIME
LOCALTIMESTAMP	LOCALTIMESTAMP
LOCK	LOCK
LONGBLOB	LONGBLOB
LONGTEXT	LONGTEXT
LOOKUP	LOOKUP
MATCH	MATCH
MAXVALUE	MAXVALUE
MEDIUMBLOB	MEDIUMBLOB
MEDIUMINT	MEDIUMINT
MEDIUMTEXT	MEDIUMTEXT
MOD	MOD
MODE	MODE
MULTILINESTRING	MULTILINESTRING
MULTIPOINT	MULTIPOINT
MULTIPOLYGON	MULTIPOLYGON
NAMES	NAMES
NATURAL	NATURAL
NCHAR	NCHAR
NE	NE
NEXT	NEXT
NO	NO
NOT	NOT
NOT_LIKE_REGEXP	NOT_LIKE_REGEXP
NOT_LIKE_REGEXP_CASE_INSENSITIVE	NOT_LIKE_REGEXP_CASE_INSENSITIVE
NULL	NULL
NULL_SAFE_EQUAL	NULL_SAFE_EQUAL
NUMERIC	NUMERIC
OBJECT_TYPE	OBJECT_TYPE
OF	OF
OFF	OFF
OFFSET	OFFSET
ON	ON
ONLY	ONLY
OPTIMIZE	OPTIMIZE
OR	OR
ORDER	ORDER
OUTER	OUTER
PARTITION	PARTITION
PLUGINS	PLUGINS
POINT	POINT
POLYGON	POLYGON
PRIMARY	PRIMARY
PROCEDURE	PROCEDURE
PROCESSLIST	PROCESSLIST
QUERY	QUERY
READ	READ
REAL	REAL
REFERENCES	REFERENCES
REGEXP	REGEXP
RENAME	RENAME
REORGANIZE	REORGANIZE
REPAIR	REPAIR
REPEATABLE	REPEATABLE
REPLACE	REPLACE
RESTRICT	RESTRICT
RIGHT	RIGHT
RIGHTARROW	RIGHTARROW
ROLLBACK	ROLLBACK
SCHEMA	SCHEMA
SCHEMAS	SCHEMAS
SELECT	SELECT
SEPARATOR	SEPARATOR
SERIALIZABLE	SERIALIZABLE
SESSION	SESSION
SET	SET
SHARE	SHARE
SHIFT_LEFT	SHIFT_LEFT
SHIFT_RIGHT	SHIFT_RIGHT
SHOW	SHOW
SIGNED	SIGNED
SMALLINT	SMALLINT
SPATIAL	SPATIAL
SQL_CACHE	SQL_CACHE
SQL_NO_CACHE	SQL_NO_CACHE
START	START
STATUS	STATUS
STRAIGHT_JOIN	STRAIGHT_JOIN
STREAM	STREAM
SUBSTR	SUBSTR
SUBSTRING	SUBSTRING
TABLE	TABLE
TABLES	TABLES
TEXT	TEXT
THAN	THAN
THEN	THEN
TIME	TIME
TIMESTAMP	TIMESTAMP
TIMESTAMPADD	TIMESTAMPADD
TIMESTAMPDIFF	TIMESTAMPDIFF
TINYBLOB	TINYBLOB
TINYINT	TINYINT
TINYTEXT	TINYTEXT
TO	TO
TRANSACTION	TRANSACTION
TRIGGER	TRIGGER
TRUE	TRUE
TRUNCATE	TRUNCATE
UNARY	UNARY
UNCOMMITTED	UNCOMMITTED
UNDERSCORE_BINARY	UNDERSCORE_BINARY
UNDERSCORE_UTF8MB4	UNDERSCORE_UTF8MB4
UNION	UNION
UNIQUE	UNIQUE
UNLOCK	UNLOCK
UNSIGNED	UNSIGNED
UNUSED	UNUSED
UPDATE	UPDATE
USE	USE
USING	USING
UTC_DATE	UTC_DATE
UTC_TIME	UTC_TIME
UTC_TIMESTAMP	UTC_TIMESTAMP
VALUE_ARG	VALUE_ARG
VALUES	VALUES
VARBINARY	VARBINARY
VARCHAR	VARCHAR
VARIABLES	VARIABLES
VIEW	VIEW
VINDEX	VINDEX
VINDEXES	VINDEXES
VITESS_KEYSPACES	VITESS_KEYSPACES
VITESS_SHARDS	VITESS_SHARDS
VITESS_TABLETS	VITESS_TABLETS
VITESS_TARGET	VITESS_TARGET
VSCHEMA	VSCHEMA
VSCHEMA_TABLES	VSCHEMA_TABLES
WARNINGS	WARNINGS
WATERMARK	WATERMARK
WHEN	WHEN
WHERE	WHERE
WITH	WITH
WRITE	WRITE
YEAR	YEAR
ZEROFILL	ZEROFILL


[0-9]+	INTEGRAL
[0-9]+"."[0-9]+	FLOAT
'(''|[^'\n])*'	STRING

/* Order matter if identifier comes before keywords they are classified as identifier */
{basic_id}	ID

%%
