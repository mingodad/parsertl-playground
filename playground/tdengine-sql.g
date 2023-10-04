//From: https://github.com/taosdata/TDengine/blob/8e705d3e748819ed2fee79792f64bc207d207046/source/libs/parser/inc/sql.y
/*
 * Copyright (c) 2019 TAOS Data, Inc. <jhtao@taosdata.com>
 *
 * This program is free software: you can use, redistribute, and/or modify
 * it under the terms of the GNU Affero General Public License, version 3
 * or later ("AGPL"), as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

%token NK_SEMI

%token  OR AND UNION ALL
%token  NK_BITAND NK_BITOR NK_PLUS
%token  NK_MINUS NK_STAR NK_SLASH NK_REM CREATE
%token  ACCOUNT NK_ID PASS NK_STRING ALTER PPS
%token  TSERIES STORAGE STREAMS QTIME DBS USERS
%token  CONNS STATE USER ENABLE NK_INTEGER SYSINFO
%token  DROP GRANT ON TO REVOKE FROM
%token  SUBSCRIBE NK_COMMA READ WRITE NK_DOT WITH
%token  DNODE PORT DNODES RESTORE NK_IPTOKEN FORCE
%token  UNSAFE LOCAL QNODE BNODE SNODE MNODE
%token  VNODE DATABASE USE FLUSH TRIM COMPACT
%token  IF NOT EXISTS BUFFER CACHEMODEL CACHESIZE
%token  COMP DURATION NK_VARIABLE MAXROWS MINROWS KEEP
%token  PAGES PAGESIZE TSDB_PAGESIZE PRECISION REPLICA VGROUPS
%token  SINGLE_STABLE RETENTIONS SCHEMALESS WAL_LEVEL WAL_FSYNC_PERIOD WAL_RETENTION_PERIOD
%token  WAL_RETENTION_SIZE WAL_ROLL_PERIOD WAL_SEGMENT_SIZE STT_TRIGGER TABLE_PREFIX TABLE_SUFFIX
%token  NK_COLON BWLIMIT START TIMESTAMP END TABLE
%token  NK_LP NK_RP STABLE ADD COLUMN MODIFY
%token  RENAME TAG SET NK_EQ USING TAGS
%token  BOOL TINYINT SMALLINT INT INTEGER BIGINT
%token  FLOAT DOUBLE BINARY NCHAR UNSIGNED JSON
%token  VARCHAR MEDIUMBLOB BLOB VARBINARY GEOMETRY DECIMAL
%token  COMMENT MAX_DELAY WATERMARK ROLLUP TTL SMA
%token  DELETE_MARK FIRST LAST SHOW PRIVILEGES DATABASES
%token  TABLES STABLES MNODES QNODES FUNCTIONS INDEXES
%token  ACCOUNTS APPS CONNECTIONS LICENCES GRANTS QUERIES
%token  SCORES TOPICS VARIABLES CLUSTER BNODES SNODES
%token  TRANSACTIONS DISTRIBUTED CONSUMERS SUBSCRIPTIONS VNODES ALIVE
%token  LIKE TBNAME QTAGS AS INDEX FUNCTION
%token  INTERVAL COUNT LAST_ROW META ONLY TOPIC
%token  CONSUMER GROUP DESC DESCRIBE RESET QUERY
%token  CACHE EXPLAIN ANALYZE VERBOSE NK_BOOL RATIO
%token  NK_FLOAT OUTPUTTYPE AGGREGATE BUFSIZE LANGUAGE REPLACE
%token  STREAM INTO PAUSE RESUME TRIGGER AT_ONCE
%token  WINDOW_CLOSE IGNORE EXPIRED FILL_HISTORY UPDATE SUBTABLE
%token  UNTREATED KILL CONNECTION TRANSACTION BALANCE VGROUP
%token  LEADER MERGE REDISTRIBUTE SPLIT DELETE INSERT
%token  NULL NK_QUESTION NK_ARROW ROWTS QSTART QEND
%token  QDURATION WSTART WEND WDURATION IROWTS ISFILLED
%token  CAST NOW TODAY TIMEZONE CLIENT_VERSION SERVER_VERSION
%token  SERVER_STATUS CURRENT_USER CASE WHEN THEN ELSE
%token  BETWEEN IS NK_LT NK_GT NK_LE NK_GE
%token  NK_NE MATCH NMATCH CONTAINS IN JOIN
%token  INNER SELECT NK_HINT DISTINCT WHERE PARTITION
%token  BY SESSION STATE_WINDOW EVENT_WINDOW SLIDING FILL
%token  VALUE VALUE_F NONE PREV NULL_F LINEAR
%token  NEXT HAVING RANGE EVERY ORDER SLIMIT
%token  SOFFSET LIMIT OFFSET ASC NULLS

%left /*1*/ OR
%left /*2*/ AND
%left /*3*/ UNION ALL
%left /*4*/ NK_BITAND NK_BITOR
%left /*5*/ NK_PLUS NK_MINUS
%left /*6*/ NK_STAR NK_SLASH NK_REM

%start commands

%%

commands :
    command
    | commands command
    ;

command :
    NK_SEMI
    | cmd
    ;

cmd : CREATE ACCOUNT NK_ID PASS NK_STRING account_options ;
cmd : ALTER ACCOUNT NK_ID alter_account_options ;

account_options : /*empty*/ ;
account_options : account_options PPS literal ;
account_options : account_options TSERIES literal ;
account_options : account_options STORAGE literal ;
account_options : account_options STREAMS literal ;
account_options : account_options QTIME literal ;
account_options : account_options DBS literal ;
account_options : account_options USERS literal ;
account_options : account_options CONNS literal ;
account_options : account_options STATE literal ;

alter_account_options : alter_account_option ;
alter_account_options : alter_account_options alter_account_option ;

alter_account_option : PASS literal ;
alter_account_option : PPS literal ;
alter_account_option : TSERIES literal ;
alter_account_option : STORAGE literal ;
alter_account_option : STREAMS literal ;
alter_account_option : QTIME literal ;
alter_account_option : DBS literal ;
alter_account_option : USERS literal ;
alter_account_option : CONNS literal ;
alter_account_option : STATE literal ;

cmd : CREATE USER user_name PASS NK_STRING sysinfo_opt ;
cmd : ALTER USER user_name PASS NK_STRING ;
cmd : ALTER USER user_name ENABLE NK_INTEGER ;
cmd : ALTER USER user_name SYSINFO NK_INTEGER ;
cmd : DROP USER user_name ;

sysinfo_opt : /*empty*/ ;
sysinfo_opt : SYSINFO NK_INTEGER ;

cmd : GRANT privileges ON priv_level with_opt TO user_name ;
cmd : REVOKE privileges ON priv_level with_opt FROM user_name ;

privileges : ALL /*3L*/ %prec ALL /*3L*/ ;
privileges : priv_type_list ;
privileges : SUBSCRIBE ;

priv_type_list : priv_type ;
priv_type_list : priv_type_list NK_COMMA priv_type ;

priv_type : READ ;
priv_type : WRITE ;

priv_level : NK_STAR /*6L*/ NK_DOT NK_STAR /*6L*/ %prec NK_STAR /*6L*/ ;
priv_level : db_name NK_DOT NK_STAR /*6L*/ %prec NK_STAR /*6L*/ ;
priv_level : db_name NK_DOT table_name ;
priv_level : topic_name ;

with_opt : /*empty*/ ;
with_opt : WITH search_condition ;

cmd : CREATE DNODE dnode_endpoint ;
cmd : CREATE DNODE dnode_endpoint PORT NK_INTEGER ;
cmd : DROP DNODE NK_INTEGER force_opt ;
cmd : DROP DNODE dnode_endpoint force_opt ;
cmd : DROP DNODE NK_INTEGER unsafe_opt ;
cmd : DROP DNODE dnode_endpoint unsafe_opt ;
cmd : ALTER DNODE NK_INTEGER NK_STRING ;
cmd : ALTER DNODE NK_INTEGER NK_STRING NK_STRING ;
cmd : ALTER ALL /*3L*/ DNODES NK_STRING %prec ALL /*3L*/ ;
cmd : ALTER ALL /*3L*/ DNODES NK_STRING NK_STRING %prec ALL /*3L*/ ;
cmd : RESTORE DNODE NK_INTEGER ;

dnode_endpoint : NK_STRING ;
dnode_endpoint : NK_ID ;
dnode_endpoint : NK_IPTOKEN ;

force_opt : /*empty*/ ;
force_opt : FORCE ;

unsafe_opt : UNSAFE ;

cmd : ALTER LOCAL NK_STRING ;
cmd : ALTER LOCAL NK_STRING NK_STRING ;
cmd : CREATE QNODE ON DNODE NK_INTEGER ;
cmd : DROP QNODE ON DNODE NK_INTEGER ;
cmd : RESTORE QNODE ON DNODE NK_INTEGER ;
cmd : CREATE BNODE ON DNODE NK_INTEGER ;
cmd : DROP BNODE ON DNODE NK_INTEGER ;
cmd : CREATE SNODE ON DNODE NK_INTEGER ;
cmd : DROP SNODE ON DNODE NK_INTEGER ;
cmd : CREATE MNODE ON DNODE NK_INTEGER ;
cmd : DROP MNODE ON DNODE NK_INTEGER ;
cmd : RESTORE MNODE ON DNODE NK_INTEGER ;
cmd : RESTORE VNODE ON DNODE NK_INTEGER ;
cmd : CREATE DATABASE not_exists_opt db_name db_options ;
cmd : DROP DATABASE exists_opt db_name ;
cmd : USE db_name ;
cmd : ALTER DATABASE db_name alter_db_options ;
cmd : FLUSH DATABASE db_name ;
cmd : TRIM DATABASE db_name speed_opt ;
cmd : COMPACT DATABASE db_name start_opt end_opt ;

not_exists_opt : IF NOT EXISTS ;
not_exists_opt : /*empty*/ ;

exists_opt : IF EXISTS ;
exists_opt : /*empty*/ ;

db_options : /*empty*/ ;
db_options : db_options BUFFER NK_INTEGER ;
db_options : db_options CACHEMODEL NK_STRING ;
db_options : db_options CACHESIZE NK_INTEGER ;
db_options : db_options COMP NK_INTEGER ;
db_options : db_options DURATION NK_INTEGER ;
db_options : db_options DURATION NK_VARIABLE ;
db_options : db_options MAXROWS NK_INTEGER ;
db_options : db_options MINROWS NK_INTEGER ;
db_options : db_options KEEP integer_list ;
db_options : db_options KEEP variable_list ;
db_options : db_options PAGES NK_INTEGER ;
db_options : db_options PAGESIZE NK_INTEGER ;
db_options : db_options TSDB_PAGESIZE NK_INTEGER ;
db_options : db_options PRECISION NK_STRING ;
db_options : db_options REPLICA NK_INTEGER ;
db_options : db_options VGROUPS NK_INTEGER ;
db_options : db_options SINGLE_STABLE NK_INTEGER ;
db_options : db_options RETENTIONS retention_list ;
db_options : db_options SCHEMALESS NK_INTEGER ;
db_options : db_options WAL_LEVEL NK_INTEGER ;
db_options : db_options WAL_FSYNC_PERIOD NK_INTEGER ;
db_options : db_options WAL_RETENTION_PERIOD NK_INTEGER ;
db_options : db_options WAL_RETENTION_PERIOD NK_MINUS /*5L*/ NK_INTEGER %prec NK_MINUS /*5L*/ ;
db_options : db_options WAL_RETENTION_SIZE NK_INTEGER ;
db_options : db_options WAL_RETENTION_SIZE NK_MINUS /*5L*/ NK_INTEGER %prec NK_MINUS /*5L*/ ;
db_options : db_options WAL_ROLL_PERIOD NK_INTEGER ;
db_options : db_options WAL_SEGMENT_SIZE NK_INTEGER ;
db_options : db_options STT_TRIGGER NK_INTEGER ;
db_options : db_options TABLE_PREFIX signed ;
db_options : db_options TABLE_SUFFIX signed ;

alter_db_options : alter_db_option ;
alter_db_options : alter_db_options alter_db_option ;

alter_db_option : BUFFER NK_INTEGER ;
alter_db_option : CACHEMODEL NK_STRING ;
alter_db_option : CACHESIZE NK_INTEGER ;
alter_db_option : WAL_FSYNC_PERIOD NK_INTEGER ;
alter_db_option : KEEP integer_list ;
alter_db_option : KEEP variable_list ;
alter_db_option : PAGES NK_INTEGER ;
alter_db_option : REPLICA NK_INTEGER ;
alter_db_option : WAL_LEVEL NK_INTEGER ;
alter_db_option : STT_TRIGGER NK_INTEGER ;
alter_db_option : MINROWS NK_INTEGER ;
alter_db_option : WAL_RETENTION_PERIOD NK_INTEGER ;
alter_db_option : WAL_RETENTION_PERIOD NK_MINUS /*5L*/ NK_INTEGER %prec NK_MINUS /*5L*/ ;
alter_db_option : WAL_RETENTION_SIZE NK_INTEGER ;
alter_db_option : WAL_RETENTION_SIZE NK_MINUS /*5L*/ NK_INTEGER %prec NK_MINUS /*5L*/ ;

integer_list : NK_INTEGER ;
integer_list : integer_list NK_COMMA NK_INTEGER ;

variable_list : NK_VARIABLE ;
variable_list : variable_list NK_COMMA NK_VARIABLE ;

retention_list : retention ;
retention_list : retention_list NK_COMMA retention ;

retention : NK_VARIABLE NK_COLON NK_VARIABLE ;

speed_opt : /*empty*/ ;
speed_opt : BWLIMIT NK_INTEGER ;

start_opt : /*empty*/ ;
start_opt : START WITH NK_INTEGER ;
start_opt : START WITH NK_STRING ;
start_opt : START WITH TIMESTAMP NK_STRING ;

end_opt : /*empty*/ ;
end_opt : END WITH NK_INTEGER ;
end_opt : END WITH NK_STRING ;
end_opt : END WITH TIMESTAMP NK_STRING ;

cmd : CREATE TABLE not_exists_opt full_table_name NK_LP column_def_list NK_RP tags_def_opt table_options ;
cmd : CREATE TABLE multi_create_clause ;
cmd : CREATE STABLE not_exists_opt full_table_name NK_LP column_def_list NK_RP tags_def table_options ;
cmd : DROP TABLE multi_drop_clause ;
cmd : DROP STABLE exists_opt full_table_name ;
cmd : ALTER TABLE alter_table_clause ;
cmd : ALTER STABLE alter_table_clause ;

alter_table_clause : full_table_name alter_table_options ;
alter_table_clause : full_table_name ADD COLUMN column_name type_name ;
alter_table_clause : full_table_name DROP COLUMN column_name ;
alter_table_clause : full_table_name MODIFY COLUMN column_name type_name ;
alter_table_clause : full_table_name RENAME COLUMN column_name column_name ;
alter_table_clause : full_table_name ADD TAG column_name type_name ;
alter_table_clause : full_table_name DROP TAG column_name ;
alter_table_clause : full_table_name MODIFY TAG column_name type_name ;
alter_table_clause : full_table_name RENAME TAG column_name column_name ;
alter_table_clause : full_table_name SET TAG column_name NK_EQ signed_literal ;

multi_create_clause : create_subtable_clause ;
multi_create_clause : multi_create_clause create_subtable_clause ;

create_subtable_clause : not_exists_opt full_table_name USING full_table_name specific_cols_opt TAGS NK_LP expression_list NK_RP table_options ;

multi_drop_clause : drop_table_clause ;
multi_drop_clause : multi_drop_clause NK_COMMA drop_table_clause ;

drop_table_clause : exists_opt full_table_name ;

specific_cols_opt : /*empty*/ ;
specific_cols_opt : NK_LP col_name_list NK_RP ;

full_table_name : table_name ;
full_table_name : db_name NK_DOT table_name ;

column_def_list : column_def ;
column_def_list : column_def_list NK_COMMA column_def ;

column_def : column_name type_name ;

type_name : BOOL ;
type_name : TINYINT ;
type_name : SMALLINT ;
type_name : INT ;
type_name : INTEGER ;
type_name : BIGINT ;
type_name : FLOAT ;
type_name : DOUBLE ;
type_name : BINARY NK_LP NK_INTEGER NK_RP ;
type_name : TIMESTAMP ;
type_name : NCHAR NK_LP NK_INTEGER NK_RP ;
type_name : TINYINT UNSIGNED ;
type_name : SMALLINT UNSIGNED ;
type_name : INT UNSIGNED ;
type_name : BIGINT UNSIGNED ;
type_name : JSON ;
type_name : VARCHAR NK_LP NK_INTEGER NK_RP ;
type_name : MEDIUMBLOB ;
type_name : BLOB ;
type_name : VARBINARY NK_LP NK_INTEGER NK_RP ;
type_name : GEOMETRY NK_LP NK_INTEGER NK_RP ;
type_name : DECIMAL ;
type_name : DECIMAL NK_LP NK_INTEGER NK_RP ;
type_name : DECIMAL NK_LP NK_INTEGER NK_COMMA NK_INTEGER NK_RP ;

tags_def_opt : /*empty*/ ;
tags_def_opt : tags_def ;

tags_def : TAGS NK_LP column_def_list NK_RP ;

table_options : /*empty*/ ;
table_options : table_options COMMENT NK_STRING ;
table_options : table_options MAX_DELAY duration_list ;
table_options : table_options WATERMARK duration_list ;
table_options : table_options ROLLUP NK_LP rollup_func_list NK_RP ;
table_options : table_options TTL NK_INTEGER ;
table_options : table_options SMA NK_LP col_name_list NK_RP ;
table_options : table_options DELETE_MARK duration_list ;

alter_table_options : alter_table_option ;
alter_table_options : alter_table_options alter_table_option ;

alter_table_option : COMMENT NK_STRING ;
alter_table_option : TTL NK_INTEGER ;

duration_list : duration_literal ;
duration_list : duration_list NK_COMMA duration_literal ;

rollup_func_list : rollup_func_name ;
rollup_func_list : rollup_func_list NK_COMMA rollup_func_name ;

rollup_func_name : function_name ;
rollup_func_name : FIRST ;
rollup_func_name : LAST ;

col_name_list : col_name ;
col_name_list : col_name_list NK_COMMA col_name ;

col_name : column_name ;

cmd : SHOW DNODES ;
cmd : SHOW USERS ;
cmd : SHOW USER PRIVILEGES ;
cmd : SHOW DATABASES ;
cmd : SHOW db_name_cond_opt TABLES like_pattern_opt ;
cmd : SHOW db_name_cond_opt STABLES like_pattern_opt ;
cmd : SHOW db_name_cond_opt VGROUPS ;
cmd : SHOW MNODES ;
cmd : SHOW QNODES ;
cmd : SHOW FUNCTIONS ;
cmd : SHOW INDEXES FROM table_name_cond from_db_opt ;
cmd : SHOW INDEXES FROM db_name NK_DOT table_name ;
cmd : SHOW STREAMS ;
cmd : SHOW ACCOUNTS ;
cmd : SHOW APPS ;
cmd : SHOW CONNECTIONS ;
cmd : SHOW LICENCES ;
cmd : SHOW GRANTS ;
cmd : SHOW CREATE DATABASE db_name ;
cmd : SHOW CREATE TABLE full_table_name ;
cmd : SHOW CREATE STABLE full_table_name ;
cmd : SHOW QUERIES ;
cmd : SHOW SCORES ;
cmd : SHOW TOPICS ;
cmd : SHOW VARIABLES ;
cmd : SHOW CLUSTER VARIABLES ;
cmd : SHOW LOCAL VARIABLES ;
cmd : SHOW DNODE NK_INTEGER VARIABLES like_pattern_opt ;
cmd : SHOW BNODES ;
cmd : SHOW SNODES ;
cmd : SHOW CLUSTER ;
cmd : SHOW TRANSACTIONS ;
cmd : SHOW TABLE DISTRIBUTED full_table_name ;
cmd : SHOW CONSUMERS ;
cmd : SHOW SUBSCRIPTIONS ;
cmd : SHOW TAGS FROM table_name_cond from_db_opt ;
cmd : SHOW TAGS FROM db_name NK_DOT table_name ;
cmd : SHOW TABLE TAGS tag_list_opt FROM table_name_cond from_db_opt ;
cmd : SHOW TABLE TAGS tag_list_opt FROM db_name NK_DOT table_name ;
cmd : SHOW VNODES ON DNODE NK_INTEGER ;
cmd : SHOW VNODES ;
cmd : SHOW db_name_cond_opt ALIVE ;
cmd : SHOW CLUSTER ALIVE ;

db_name_cond_opt : /*empty*/ ;
db_name_cond_opt : db_name NK_DOT ;

like_pattern_opt : /*empty*/ ;
like_pattern_opt : LIKE NK_STRING ;

table_name_cond : table_name ;

from_db_opt : /*empty*/ ;
from_db_opt : FROM db_name ;

tag_list_opt : /*empty*/ ;
tag_list_opt : tag_item ;
tag_list_opt : tag_list_opt NK_COMMA tag_item ;

tag_item : TBNAME ;
tag_item : QTAGS ;
tag_item : column_name ;
tag_item : column_name column_alias ;
tag_item : column_name AS column_alias ;

cmd : CREATE SMA INDEX not_exists_opt col_name ON full_table_name index_options ;
cmd : CREATE INDEX not_exists_opt col_name ON full_table_name NK_LP col_name_list NK_RP ;
cmd : DROP INDEX exists_opt full_index_name ;

full_index_name : index_name ;
full_index_name : db_name NK_DOT index_name ;

index_options : FUNCTION NK_LP func_list NK_RP INTERVAL NK_LP duration_literal NK_RP sliding_opt sma_stream_opt ;
index_options : FUNCTION NK_LP func_list NK_RP INTERVAL NK_LP duration_literal NK_COMMA duration_literal NK_RP sliding_opt sma_stream_opt ;

func_list : func ;
func_list : func_list NK_COMMA func ;

func : sma_func_name NK_LP expression_list NK_RP ;

sma_func_name : function_name ;
sma_func_name : COUNT ;
sma_func_name : FIRST ;
sma_func_name : LAST ;
sma_func_name : LAST_ROW ;

sma_stream_opt : /*empty*/ ;
sma_stream_opt : sma_stream_opt WATERMARK duration_literal ;
sma_stream_opt : sma_stream_opt MAX_DELAY duration_literal ;
sma_stream_opt : sma_stream_opt DELETE_MARK duration_literal ;

with_meta : AS ;
with_meta : WITH META AS ;
with_meta : ONLY META AS ;

cmd : CREATE TOPIC not_exists_opt topic_name AS query_or_subquery ;
cmd : CREATE TOPIC not_exists_opt topic_name with_meta DATABASE db_name ;
cmd : CREATE TOPIC not_exists_opt topic_name with_meta STABLE full_table_name where_clause_opt ;
cmd : DROP TOPIC exists_opt topic_name ;
cmd : DROP CONSUMER GROUP exists_opt cgroup_name ON topic_name ;
cmd : DESC full_table_name ;
cmd : DESCRIBE full_table_name ;
cmd : RESET QUERY CACHE ;
cmd : EXPLAIN analyze_opt explain_options query_or_subquery ;
cmd : EXPLAIN analyze_opt explain_options insert_query ;

analyze_opt : /*empty*/ ;
analyze_opt : ANALYZE ;

explain_options : /*empty*/ ;
explain_options : explain_options VERBOSE NK_BOOL ;
explain_options : explain_options RATIO NK_FLOAT ;

cmd : CREATE or_replace_opt agg_func_opt FUNCTION not_exists_opt function_name AS NK_STRING OUTPUTTYPE type_name bufsize_opt language_opt ;
cmd : DROP FUNCTION exists_opt function_name ;

agg_func_opt : /*empty*/ ;
agg_func_opt : AGGREGATE ;

bufsize_opt : /*empty*/ ;
bufsize_opt : BUFSIZE NK_INTEGER ;

language_opt : /*empty*/ ;
language_opt : LANGUAGE NK_STRING ;

or_replace_opt : /*empty*/ ;
or_replace_opt : OR /*1L*/ REPLACE %prec OR /*1L*/ ;

cmd : CREATE STREAM not_exists_opt stream_name stream_options INTO full_table_name col_list_opt tag_def_or_ref_opt subtable_opt AS query_or_subquery ;
cmd : DROP STREAM exists_opt stream_name ;
cmd : PAUSE STREAM exists_opt stream_name ;
cmd : RESUME STREAM exists_opt ignore_opt stream_name ;

col_list_opt : /*empty*/ ;
col_list_opt : NK_LP col_name_list NK_RP ;

tag_def_or_ref_opt : /*empty*/ ;
tag_def_or_ref_opt : tags_def ;
tag_def_or_ref_opt : TAGS NK_LP col_name_list NK_RP ;

stream_options : /*empty*/ ;
stream_options : stream_options TRIGGER AT_ONCE ;
stream_options : stream_options TRIGGER WINDOW_CLOSE ;
stream_options : stream_options TRIGGER MAX_DELAY duration_literal ;
stream_options : stream_options WATERMARK duration_literal ;
stream_options : stream_options IGNORE EXPIRED NK_INTEGER ;
stream_options : stream_options FILL_HISTORY NK_INTEGER ;
stream_options : stream_options DELETE_MARK duration_literal ;
stream_options : stream_options IGNORE UPDATE NK_INTEGER ;

subtable_opt : /*empty*/ ;
subtable_opt : SUBTABLE NK_LP expression NK_RP ;

ignore_opt : /*empty*/ ;
ignore_opt : IGNORE UNTREATED ;

cmd : KILL CONNECTION NK_INTEGER ;
cmd : KILL QUERY NK_STRING ;
cmd : KILL TRANSACTION NK_INTEGER ;
cmd : BALANCE VGROUP ;
cmd : BALANCE VGROUP LEADER ;
cmd : MERGE VGROUP NK_INTEGER NK_INTEGER ;
cmd : REDISTRIBUTE VGROUP NK_INTEGER dnode_list ;
cmd : SPLIT VGROUP NK_INTEGER ;

dnode_list : DNODE NK_INTEGER ;
dnode_list : dnode_list DNODE NK_INTEGER ;

cmd : DELETE FROM full_table_name where_clause_opt ;
cmd : query_or_subquery ;
cmd : insert_query ;

insert_query : INSERT INTO full_table_name NK_LP col_name_list NK_RP query_or_subquery ;
insert_query : INSERT INTO full_table_name query_or_subquery ;

literal : NK_INTEGER ;
literal : NK_FLOAT ;
literal : NK_STRING ;
literal : NK_BOOL ;
literal : TIMESTAMP NK_STRING ;
literal : duration_literal ;
literal : NULL ;
literal : NK_QUESTION ;

duration_literal : NK_VARIABLE ;

signed : NK_INTEGER ;
signed : NK_PLUS /*5L*/ NK_INTEGER %prec NK_PLUS /*5L*/ ;
signed : NK_MINUS /*5L*/ NK_INTEGER %prec NK_MINUS /*5L*/ ;
signed : NK_FLOAT ;
signed : NK_PLUS /*5L*/ NK_FLOAT %prec NK_PLUS /*5L*/ ;
signed : NK_MINUS /*5L*/ NK_FLOAT %prec NK_MINUS /*5L*/ ;

signed_literal : signed ;
signed_literal : NK_STRING ;
signed_literal : NK_BOOL ;
signed_literal : TIMESTAMP NK_STRING ;
signed_literal : duration_literal ;
signed_literal : NULL ;
signed_literal : literal_func ;
signed_literal : NK_QUESTION ;

literal_list : signed_literal ;
literal_list : literal_list NK_COMMA signed_literal ;

db_name : NK_ID ;

table_name : NK_ID ;

column_name : NK_ID ;

function_name : NK_ID ;

table_alias : NK_ID ;

column_alias : NK_ID ;

user_name : NK_ID ;

topic_name : NK_ID ;

stream_name : NK_ID ;

cgroup_name : NK_ID ;

index_name : NK_ID ;

expr_or_subquery : expression ;

expression : literal ;
expression : pseudo_column ;
expression : column_reference ;
expression : function_expression ;
expression : case_when_expression ;
expression : NK_LP expression NK_RP ;
expression : NK_PLUS /*5L*/ expr_or_subquery %prec NK_PLUS /*5L*/ ;
expression : NK_MINUS /*5L*/ expr_or_subquery %prec NK_MINUS /*5L*/ ;
expression : expr_or_subquery NK_PLUS /*5L*/ expr_or_subquery %prec NK_PLUS /*5L*/ ;
expression : expr_or_subquery NK_MINUS /*5L*/ expr_or_subquery %prec NK_MINUS /*5L*/ ;
expression : expr_or_subquery NK_STAR /*6L*/ expr_or_subquery %prec NK_STAR /*6L*/ ;
expression : expr_or_subquery NK_SLASH /*6L*/ expr_or_subquery %prec NK_SLASH /*6L*/ ;
expression : expr_or_subquery NK_REM /*6L*/ expr_or_subquery %prec NK_REM /*6L*/ ;
expression : column_reference NK_ARROW NK_STRING ;
expression : expr_or_subquery NK_BITAND /*4L*/ expr_or_subquery %prec NK_BITAND /*4L*/ ;
expression : expr_or_subquery NK_BITOR /*4L*/ expr_or_subquery %prec NK_BITOR /*4L*/ ;

expression_list : expr_or_subquery ;
expression_list : expression_list NK_COMMA expr_or_subquery ;

column_reference : column_name ;
column_reference : table_name NK_DOT column_name ;

pseudo_column : ROWTS ;
pseudo_column : TBNAME ;
pseudo_column : table_name NK_DOT TBNAME ;
pseudo_column : QSTART ;
pseudo_column : QEND ;
pseudo_column : QDURATION ;
pseudo_column : WSTART ;
pseudo_column : WEND ;
pseudo_column : WDURATION ;
pseudo_column : IROWTS ;
pseudo_column : ISFILLED ;
pseudo_column : QTAGS ;

function_expression : function_name NK_LP expression_list NK_RP ;
function_expression : star_func NK_LP star_func_para_list NK_RP ;
function_expression : CAST NK_LP expr_or_subquery AS type_name NK_RP ;
function_expression : literal_func ;

literal_func : noarg_func NK_LP NK_RP ;
literal_func : NOW ;

noarg_func : NOW ;
noarg_func : TODAY ;
noarg_func : TIMEZONE ;
noarg_func : DATABASE ;
noarg_func : CLIENT_VERSION ;
noarg_func : SERVER_VERSION ;
noarg_func : SERVER_STATUS ;
noarg_func : CURRENT_USER ;
noarg_func : USER ;

star_func : COUNT ;
star_func : FIRST ;
star_func : LAST ;
star_func : LAST_ROW ;

star_func_para_list : NK_STAR /*6L*/ %prec NK_STAR /*6L*/ ;
star_func_para_list : other_para_list ;

other_para_list : star_func_para ;
other_para_list : other_para_list NK_COMMA star_func_para ;

star_func_para : expr_or_subquery ;
star_func_para : table_name NK_DOT NK_STAR /*6L*/ %prec NK_STAR /*6L*/ ;

case_when_expression : CASE when_then_list case_when_else_opt END ;
case_when_expression : CASE common_expression when_then_list case_when_else_opt END ;

when_then_list : when_then_expr ;
when_then_list : when_then_list when_then_expr ;

when_then_expr : WHEN common_expression THEN common_expression ;

case_when_else_opt : /*empty*/ ;
case_when_else_opt : ELSE common_expression ;

predicate : expr_or_subquery compare_op expr_or_subquery ;
predicate : expr_or_subquery BETWEEN expr_or_subquery AND /*2L*/ expr_or_subquery %prec AND /*2L*/ ;
predicate : expr_or_subquery NOT BETWEEN expr_or_subquery AND /*2L*/ expr_or_subquery %prec AND /*2L*/ ;
predicate : expr_or_subquery IS NULL ;
predicate : expr_or_subquery IS NOT NULL ;
predicate : expr_or_subquery in_op in_predicate_value ;

compare_op : NK_LT ;
compare_op : NK_GT ;
compare_op : NK_LE ;
compare_op : NK_GE ;
compare_op : NK_NE ;
compare_op : NK_EQ ;
compare_op : LIKE ;
compare_op : NOT LIKE ;
compare_op : MATCH ;
compare_op : NMATCH ;
compare_op : CONTAINS ;

in_op : IN ;
in_op : NOT IN ;

in_predicate_value : NK_LP literal_list NK_RP ;

boolean_value_expression : boolean_primary ;
boolean_value_expression : NOT boolean_primary ;
boolean_value_expression : boolean_value_expression OR /*1L*/ boolean_value_expression %prec OR /*1L*/ ;
boolean_value_expression : boolean_value_expression AND /*2L*/ boolean_value_expression %prec AND /*2L*/ ;

boolean_primary : predicate ;
boolean_primary : NK_LP boolean_value_expression NK_RP ;

common_expression : expr_or_subquery ;
common_expression : boolean_value_expression ;

from_clause_opt : /*empty*/ ;
from_clause_opt : FROM table_reference_list ;

table_reference_list : table_reference ;
table_reference_list : table_reference_list NK_COMMA table_reference ;

table_reference : table_primary ;
table_reference : joined_table ;

table_primary : table_name alias_opt ;
table_primary : db_name NK_DOT table_name alias_opt ;
table_primary : subquery alias_opt ;
table_primary : parenthesized_joined_table ;

alias_opt : /*empty*/ ;
alias_opt : table_alias ;
alias_opt : AS table_alias ;

parenthesized_joined_table : NK_LP joined_table NK_RP ;
parenthesized_joined_table : NK_LP parenthesized_joined_table NK_RP ;

joined_table : table_reference join_type JOIN table_reference ON search_condition ;

join_type : /*empty*/ ;
join_type : INNER ;

query_specification : SELECT hint_list set_quantifier_opt tag_mode_opt select_list from_clause_opt where_clause_opt partition_by_clause_opt range_opt every_opt fill_opt twindow_clause_opt group_by_clause_opt having_clause_opt ;

hint_list : /*empty*/ ;
hint_list : NK_HINT ;

tag_mode_opt : /*empty*/ ;
tag_mode_opt : TAGS ;

set_quantifier_opt : /*empty*/ ;
set_quantifier_opt : DISTINCT ;
set_quantifier_opt : ALL /*3L*/ %prec ALL /*3L*/ ;

select_list : select_item ;
select_list : select_list NK_COMMA select_item ;

select_item : NK_STAR /*6L*/ %prec NK_STAR /*6L*/ ;
select_item : common_expression ;
select_item : common_expression column_alias ;
select_item : common_expression AS column_alias ;
select_item : table_name NK_DOT NK_STAR /*6L*/ %prec NK_STAR /*6L*/ ;

where_clause_opt : /*empty*/ ;
where_clause_opt : WHERE search_condition ;

partition_by_clause_opt : /*empty*/ ;
partition_by_clause_opt : PARTITION BY partition_list ;

partition_list : partition_item ;
partition_list : partition_list NK_COMMA partition_item ;

partition_item : expr_or_subquery ;
partition_item : expr_or_subquery column_alias ;
partition_item : expr_or_subquery AS column_alias ;

twindow_clause_opt : /*empty*/ ;
twindow_clause_opt : SESSION NK_LP column_reference NK_COMMA duration_literal NK_RP ;
twindow_clause_opt : STATE_WINDOW NK_LP expr_or_subquery NK_RP ;
twindow_clause_opt : INTERVAL NK_LP duration_literal NK_RP sliding_opt fill_opt ;
twindow_clause_opt : INTERVAL NK_LP duration_literal NK_COMMA duration_literal NK_RP sliding_opt fill_opt ;
twindow_clause_opt : EVENT_WINDOW START WITH search_condition END WITH search_condition ;

sliding_opt : /*empty*/ ;
sliding_opt : SLIDING NK_LP duration_literal NK_RP ;

fill_opt : /*empty*/ ;
fill_opt : FILL NK_LP fill_mode NK_RP ;
fill_opt : FILL NK_LP VALUE NK_COMMA expression_list NK_RP ;
fill_opt : FILL NK_LP VALUE_F NK_COMMA expression_list NK_RP ;

fill_mode : NONE ;
fill_mode : PREV ;
fill_mode : NULL ;
fill_mode : NULL_F ;
fill_mode : LINEAR ;
fill_mode : NEXT ;

group_by_clause_opt : /*empty*/ ;
group_by_clause_opt : GROUP BY group_by_list ;

group_by_list : expr_or_subquery ;
group_by_list : group_by_list NK_COMMA expr_or_subquery ;

having_clause_opt : /*empty*/ ;
having_clause_opt : HAVING search_condition ;

range_opt : /*empty*/ ;
range_opt : RANGE NK_LP expr_or_subquery NK_COMMA expr_or_subquery NK_RP ;
range_opt : RANGE NK_LP expr_or_subquery NK_RP ;

every_opt : /*empty*/ ;
every_opt : EVERY NK_LP duration_literal NK_RP ;

query_expression : query_simple order_by_clause_opt slimit_clause_opt limit_clause_opt ;

query_simple : query_specification ;
query_simple : union_query_expression ;

union_query_expression : query_simple_or_subquery UNION /*3L*/ ALL /*3L*/ query_simple_or_subquery %prec UNION /*3L*/ ;
union_query_expression : query_simple_or_subquery UNION /*3L*/ query_simple_or_subquery %prec UNION /*3L*/ ;

query_simple_or_subquery : query_simple ;
query_simple_or_subquery : subquery ;

query_or_subquery : query_expression ;
query_or_subquery : subquery ;

order_by_clause_opt : /*empty*/ ;
order_by_clause_opt : ORDER BY sort_specification_list ;

slimit_clause_opt : /*empty*/ ;
slimit_clause_opt : SLIMIT NK_INTEGER ;
slimit_clause_opt : SLIMIT NK_INTEGER SOFFSET NK_INTEGER ;
slimit_clause_opt : SLIMIT NK_INTEGER NK_COMMA NK_INTEGER ;

limit_clause_opt : /*empty*/ ;
limit_clause_opt : LIMIT NK_INTEGER ;
limit_clause_opt : LIMIT NK_INTEGER OFFSET NK_INTEGER ;
limit_clause_opt : LIMIT NK_INTEGER NK_COMMA NK_INTEGER ;

subquery : NK_LP query_expression NK_RP ;
subquery : NK_LP subquery NK_RP ;

search_condition : common_expression ;

sort_specification_list : sort_specification ;
sort_specification_list : sort_specification_list NK_COMMA sort_specification ;

sort_specification : expr_or_subquery ordering_specification_opt null_ordering_opt ;

ordering_specification_opt : /*empty*/ ;
ordering_specification_opt : ASC ;
ordering_specification_opt : DESC ;

null_ordering_opt : /*empty*/ ;
null_ordering_opt : NULLS FIRST ;
null_ordering_opt : NULLS LAST ;

%%

%option caseless

BASE_ID	[_a-zA-Z][a-zA-Z0-9_]*

%%

[ \t\n\r]+   skip()
"--".*      skip()
"/*"(?s:.)*?"*/"    skip()

ACCOUNT	ACCOUNT
ACCOUNTS	ACCOUNTS
ADD	ADD
AGGREGATE	AGGREGATE
ALIVE	ALIVE
ALL	ALL
ALTER	ALTER
ANALYZE	ANALYZE
AND	AND
APPS	APPS
AS	AS
ASC	ASC
AT_ONCE	AT_ONCE
BALANCE	BALANCE
BETWEEN	BETWEEN
BIGINT	BIGINT
BINARY	BINARY
BLOB	BLOB
BNODE	BNODE
BNODES	BNODES
BOOL	BOOL
BUFFER	BUFFER
BUFSIZE	BUFSIZE
BWLIMIT	BWLIMIT
BY	BY
CACHE	CACHE
CACHEMODEL	CACHEMODEL
CACHESIZE	CACHESIZE
CASE	CASE
CAST	CAST
CLIENT_VERSION	CLIENT_VERSION
CLUSTER	CLUSTER
COLUMN	COLUMN
COMMENT	COMMENT
COMP	COMP
COMPACT	COMPACT
CONNECTION	CONNECTION
CONNECTIONS	CONNECTIONS
CONNS	CONNS
CONSUMER	CONSUMER
CONSUMERS	CONSUMERS
CONTAINS	CONTAINS
COUNT	COUNT
CREATE	CREATE
CURRENT_USER	CURRENT_USER
DATABASE	DATABASE
DATABASES	DATABASES
DBS	DBS
DECIMAL	DECIMAL
DELETE	DELETE
DELETE_MARK	DELETE_MARK
DESC	DESC
DESCRIBE	DESCRIBE
DISTINCT	DISTINCT
DISTRIBUTED	DISTRIBUTED
DNODE	DNODE
DNODES	DNODES
DOUBLE	DOUBLE
DROP	DROP
DURATION	DURATION
ELSE	ELSE
ENABLE	ENABLE
END	END
EVENT_WINDOW	EVENT_WINDOW
EVERY	EVERY
EXISTS	EXISTS
EXPIRED	EXPIRED
EXPLAIN	EXPLAIN
FILL	FILL
FILL_HISTORY	FILL_HISTORY
FIRST	FIRST
FLOAT	FLOAT
FLUSH	FLUSH
FORCE	FORCE
FROM	FROM
FUNCTION	FUNCTION
FUNCTIONS	FUNCTIONS
GEOMETRY	GEOMETRY
GRANT	GRANT
GRANTS	GRANTS
GROUP	GROUP
HAVING	HAVING
IF	IF
IGNORE	IGNORE
IN	IN
INDEX	INDEX
INDEXES	INDEXES
INNER	INNER
INSERT	INSERT
INT	INT
INTEGER	INTEGER
INTERVAL	INTERVAL
INTO	INTO
IROWTS	IROWTS
IS	IS
ISFILLED	ISFILLED
JOIN	JOIN
JSON	JSON
KEEP	KEEP
KILL	KILL
LANGUAGE	LANGUAGE
LAST	LAST
LAST_ROW	LAST_ROW
LEADER	LEADER
LICENCES	LICENCES
LIKE	LIKE
LIMIT	LIMIT
LINEAR	LINEAR
LOCAL	LOCAL
MATCH	MATCH
MAX_DELAY	MAX_DELAY
MAXROWS	MAXROWS
MEDIUMBLOB	MEDIUMBLOB
MERGE	MERGE
META	META
MINROWS	MINROWS
MNODE	MNODE
MNODES	MNODES
MODIFY	MODIFY
NCHAR	NCHAR
NEXT	NEXT
"->"	NK_ARROW
"&"	NK_BITAND
"|"	NK_BITOR
"true"|"false"	NK_BOOL
":"	NK_COLON
","	NK_COMMA
"."	NK_DOT
"="|"=="	NK_EQ
">="	NK_GE
">"	NK_GT
NK_HINT	NK_HINT
NK_IPTOKEN	NK_IPTOKEN
"<="	NK_LE
"("	NK_LP
"<"	NK_LT
"-"	NK_MINUS
"!="|"<>"	NK_NE
"+"	NK_PLUS
"?"	NK_QUESTION
"%"	NK_REM
")"	NK_RP
"/"	NK_SLASH
"*"	NK_STAR
NMATCH	NMATCH
NONE	NONE
NOT	NOT
NOW	NOW
NULL	NULL
NULL_F	NULL_F
NULLS	NULLS
OFFSET	OFFSET
ON	ON
ONLY	ONLY
OR	OR
ORDER	ORDER
OUTPUTTYPE	OUTPUTTYPE
PAGES	PAGES
PAGESIZE	PAGESIZE
PARTITION	PARTITION
PASS	PASS
PAUSE	PAUSE
PORT	PORT
PPS	PPS
PRECISION	PRECISION
PREV	PREV
PRIVILEGES	PRIVILEGES
QDURATION	QDURATION
QEND	QEND
QNODE	QNODE
QNODES	QNODES
QSTART	QSTART
QTAGS	QTAGS
QTIME	QTIME
QUERIES	QUERIES
QUERY	QUERY
RANGE	RANGE
RATIO	RATIO
READ	READ
REDISTRIBUTE	REDISTRIBUTE
RENAME	RENAME
REPLACE	REPLACE
REPLICA	REPLICA
RESET	RESET
RESTORE	RESTORE
RESUME	RESUME
RETENTIONS	RETENTIONS
REVOKE	REVOKE
ROLLUP	ROLLUP
ROWTS	ROWTS
SCHEMALESS	SCHEMALESS
SCORES	SCORES
SELECT	SELECT
SERVER_STATUS	SERVER_STATUS
SERVER_VERSION	SERVER_VERSION
SESSION	SESSION
SET	SET
SHOW	SHOW
SINGLE_STABLE	SINGLE_STABLE
SLIDING	SLIDING
SLIMIT	SLIMIT
SMA	SMA
SMALLINT	SMALLINT
SNODE	SNODE
SNODES	SNODES
SOFFSET	SOFFSET
SPLIT	SPLIT
STABLE	STABLE
STABLES	STABLES
START	START
STATE	STATE
STATE_WINDOW	STATE_WINDOW
STORAGE	STORAGE
STREAM	STREAM
STREAMS	STREAMS
STT_TRIGGER	STT_TRIGGER
SUBSCRIBE	SUBSCRIBE
SUBSCRIPTIONS	SUBSCRIPTIONS
SUBTABLE	SUBTABLE
SYSINFO	SYSINFO
TABLE	TABLE
TABLE_PREFIX	TABLE_PREFIX
TABLES	TABLES
TABLE_SUFFIX	TABLE_SUFFIX
TAG	TAG
TAGS	TAGS
TBNAME	TBNAME
THEN	THEN
TIMESTAMP	TIMESTAMP
TIMEZONE	TIMEZONE
TINYINT	TINYINT
TO	TO
TODAY	TODAY
TOPIC	TOPIC
TOPICS	TOPICS
TRANSACTION	TRANSACTION
TRANSACTIONS	TRANSACTIONS
TRIGGER	TRIGGER
TRIM	TRIM
TSDB_PAGESIZE	TSDB_PAGESIZE
TSERIES	TSERIES
TTL	TTL
UNION	UNION
UNSAFE	UNSAFE
UNSIGNED	UNSIGNED
UNTREATED	UNTREATED
UPDATE	UPDATE
USE	USE
USER	USER
USERS	USERS
USING	USING
VALUE	VALUE
VALUE_F	VALUE_F
VARBINARY	VARBINARY
VARCHAR	VARCHAR
VARIABLES	VARIABLES
VERBOSE	VERBOSE
VGROUP	VGROUP
VGROUPS	VGROUPS
VNODE	VNODE
VNODES	VNODES
WAL_FSYNC_PERIOD	WAL_FSYNC_PERIOD
WAL_LEVEL	WAL_LEVEL
WAL_RETENTION_PERIOD	WAL_RETENTION_PERIOD
WAL_RETENTION_SIZE	WAL_RETENTION_SIZE
WAL_ROLL_PERIOD	WAL_ROLL_PERIOD
WAL_SEGMENT_SIZE	WAL_SEGMENT_SIZE
WATERMARK	WATERMARK
WDURATION	WDURATION
WEND	WEND
WHEN	WHEN
WHERE	WHERE
WINDOW_CLOSE	WINDOW_CLOSE
WITH	WITH
WRITE	WRITE
WSTART	WSTART

";"	NK_SEMI

[0-9]+[buasmhdnywBUASMHDNYW]	NK_VARIABLE
([0-9]+\.[0-9]*|\.[0-9]+)([Ee](\+|\-)?[0-9]+)?	NK_FLOAT
[0-9]+	NK_INTEGER
'(''|[^'\n])*'	NK_STRING
/* Order matter if identifier comes before keywords they are classified as identifier */
{BASE_ID}|\"{BASE_ID}\"|"`"{BASE_ID}"`"	NK_ID
%%
