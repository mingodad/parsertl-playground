//FRom: https://github.com/bloomberg/comdb2/blob/d92f778ac37f6a029390a358bd5b08e058d4a17d/sqlite/src/parse.y
/*
** 2001 September 15
**
** The author disclaims copyright to this source code.  In place of
** a legal notice, here is a blessing:
**
**    May you do good and not evil.
**    May you find forgiveness for yourself and forgive others.
**    May you share freely, never taking more than you give.
**
*************************************************************************
** This file contains SQLite's grammar for SQL.  Process this file
** using the lemon parser generator to generate C code that runs
** the parser.  Lemon will also generate a header file containing
** numeric codes for all of the tokens.
*/

//defined(SQLITE_BUILDING_FOR_COMDB2)

%token  SEMI EXPLAIN QUERY PLAN DISTRIBUTION BEGIN
%token  TRANSACTION DEFERRED IMMEDIATE EXCLUSIVE COMMIT END
%token  ROLLBACK SAVEPOINT RELEASE TO TABLE NOSQL
%token  CREATE IF NOT EXISTS TEMP LP
%token  RP PARTITIONED BY TIME PERIOD STRING
%token  RETENTION INTEGER START NONE MANUAL MERGE
%token  LIKE_KW COMMA ABORT ACTION AFTER ANALYZE
%token  ASC ATTACH BEFORE CASCADE CAST CONFLICT
%token  DATABASE DESC DETACH EACH FAIL OR
%token  AND IS MATCH BETWEEN IN ISNULL
%token  NOTNULL NE EQ GT LE LT
%token  GE ESCAPE ID COLUMNKW DO FOR
%token  IGNORE INSTEAD NO KEY OF //INITIALLY
%token  OFFSET PRAGMA RAISE RECURSIVE REPLACE RESTRICT
%token  ROW ROWS SEQUENCE TRIGGER VACUUM VIEW
%token  VIRTUAL WITH WITHOUT CURRENT FOLLOWING PARTITION
%token  PRECEDING RANGE UNBOUNDED EXCLUDE GROUPS OTHERS
%token  TIES REINDEX RENAME CTIME_KW ADD AGGREGATE
%token  ALIAS ANALYZEEXPERT ANALYZESQLITE AUTHENTICATION BLOBFIELD BULKIMPORT
%token  CHECK COMMITSLEEP CONSUMER CONVERTSLEEP COUNTER COVERAGE
%token  CRLE DATA DATABLOB DATACOPY DBPAD //DEFERRABLE
%token  DETERMINISTIC DISABLE DRYRUN ENABLE EXEC EXECUTE
%token  FORCE FUNCTION GENID48 GET GRANT INCLUDE
%token  INCREMENT IPU ISC KW LUA LZ4
%token  ODH OFF OP OPTION OPTIONS PAGEORDER
%token  PASSWORD PAUSE PENDING PROCEDURE PUT REBUILD
%token  READ READONLY REC RESERVED RESUME REVOKE
%token  RLE ROWLOCKS SCALAR SCHEMACHANGE SKIPSCAN SUMMARIZE
%token  THREADS THRESHOLD TRUNCATE TUNABLE TYPE VERSION
%token  WRITE DDL USERSCHEMA ZLIB BITAND //ANY
%token  BITOR LSHIFT RSHIFT PLUS MINUS STAR
%token  SLASH REM CONCAT COLLATE BITNOT ON
%token  INDEXED JOIN_KW CONSTRAINT DEFAULT AUTOINCR NULL
%token  PRIMARY UNIQUE REFERENCES INDEX INSERT DELETE
%token  UPDATE SET FOREIGN DROP AS UNION
%token  ALL EXCEPT INTERSECT SELECT VALUES SELECTV
%token  DISTINCT DOT FROM JOIN USING ORDER
%token  GROUP HAVING LIMIT WHERE INTO NOTHING
%token  FLOAT BLOB VARIABLE CASE WHEN THEN
%token  ELSE ALTER WINDOW OVER FILTER //TRUEFALSE
//%token  ISNOT COLUMN AGG_FUNCTION AGG_COLUMN UMINUS UPLUS
//%token  TRUTH REGISTER VECTOR SELECT_COLUMN IF_NULL_ROW ASTERISK
//%token  SPAN TO_TEXT TO_DATETIME TO_INTERVAL_YE TO_INTERVAL_MO TO_INTERVAL_DY
//%token  TO_INTERVAL_HO TO_INTERVAL_MI TO_INTERVAL_SE TO_BLOB TO_NUMERIC TO_INT
//%token  TO_REAL TO_DECIMAL SPACE ILLEGAL

%left /*1*/ OR
%left /*2*/ AND
%right /*3*/ NOT
%left /*4*/ LIKE_KW IS MATCH BETWEEN IN ISNULL NOTNULL NE EQ
%left /*5*/ GT LE LT GE
%right /*6*/ ESCAPE
%left /*7*/ BITAND BITOR LSHIFT RSHIFT
%left /*8*/ PLUS MINUS
%left /*9*/ STAR SLASH REM
%left /*10*/ CONCAT
%left /*11*/ COLLATE
%right /*12*/ BITNOT
%nonassoc /*13*/ ON

%start input

%%

input : cmdlist ;

cmdlist : cmdlist ecmd ;
cmdlist : ecmd ;

ecmd : SEMI ;
ecmd : cmdx SEMI ;
ecmd : explain cmdx ;

explain : EXPLAIN ;
explain : EXPLAIN QUERY PLAN ;
explain : EXPLAIN DISTRIBUTION ;

cmdx : cmd ;

cmd : BEGIN transtype trans_opt ;

trans_opt : /*empty*/ ;
trans_opt : TRANSACTION ;
trans_opt : TRANSACTION nm ;

transtype : /*empty*/ ;
transtype : DEFERRED ;
transtype : IMMEDIATE ;
transtype : EXCLUSIVE ;

cmd : COMMIT trans_opt ;
cmd : END trans_opt ;
cmd : ROLLBACK trans_opt ;

savepoint_opt : SAVEPOINT ;
savepoint_opt : /*empty*/ ;

cmd : SAVEPOINT nm ;
cmd : RELEASE savepoint_opt nm ;
cmd : ROLLBACK trans_opt TO savepoint_opt nm ;
cmd : create_table create_table_args ;

create_table : dryrun createkw temp TABLE ifnotexists nm dbnm ;

cmd : comdb2_create_table_csc2 ;

comdb2_create_table_csc2 : dryrun createkw temp TABLE ifnotexists nm dbnm comdb2opt NOSQL ;

createkw : CREATE ;

ifnotexists : /*empty*/ ;
ifnotexists : IF NOT /*3R*/ EXISTS %prec NOT /*3R*/ ;

temp : TEMP ;
temp : /*empty*/ ;

create_table_args : LP columnlist conslist_opt RP comdb2opt table_options partitioned merge ;

partitioned : /*empty*/ ;
partitioned : partitioned_by ;

partitioned_by : PARTITIONED BY partition_options ;

partition_options : TIME PERIOD STRING RETENTION INTEGER START STRING ;
partition_options : NONE ;
partition_options : MANUAL RETENTION INTEGER START INTEGER ;
partition_options : MANUAL RETENTION INTEGER ;

merge : /*empty*/ ;
merge : merge_with ;

merge_with : MERGE nm dbnm ;

merge_with_alter : MERGE nm dbnm ;

create_table_args : LIKE_KW /*4L*/ nm dbnm %prec LIKE_KW /*4L*/ ;

table_options : /*empty*/ ;

columnlist : columnlist COMMA columnname carglist ;
columnlist : columnname carglist ;

columnname : nm typetoken ;

nm : ID ;
nm : INDEXED ;
nm : STRING ;
nm : JOIN_KW ;

typetoken : /*empty*/ ;
typetoken : typename ;
typetoken : typename LP signed RP ;

typename : ID ;
typename : STRING ;
typename : typename ID ;
typename : typename STRING ;

signed : plus_num ;
signed : minus_num ;

scanpt : /*empty*/ ;

carglist : carglist ccons ;
carglist : /*empty*/ ;

ccons : CONSTRAINT nm ;
ccons : DEFAULT scanpt term scanpt ;
ccons : DEFAULT LP expr RP ;
ccons : DEFAULT PLUS /*8L*/ term scanpt %prec PLUS /*8L*/ ;
ccons : DEFAULT MINUS /*8L*/ term scanpt %prec MINUS /*8L*/ ;
ccons : DEFAULT scanpt ID ;
ccons : DEFAULT scanpt INDEXED ;
ccons : AUTOINCR ;
ccons : NULL onconf ;
ccons : NOT /*3R*/ NULL onconf %prec NOT /*3R*/ ;
ccons : PRIMARY KEY sortorder onconf autoinc ;
ccons : UNIQUE onconf ;
ccons : REFERENCES nm LP eidlist RP refargs ;
ccons : INDEX onconf ;
ccons : COLLATE /*11L*/ ID %prec COLLATE /*11L*/ ;
ccons : COLLATE /*11L*/ STRING %prec COLLATE /*11L*/ ;
ccons : OPTION DBPAD EQ /*4L*/ INTEGER %prec EQ /*4L*/ ;

autoinc : /*empty*/ ;

refargs : /*empty*/ ;
refargs : refargs refarg ;

refarg : MATCH /*4L*/ nm %prec MATCH /*4L*/ ;
refarg : ON /*13N*/ INSERT refact %prec ON /*13N*/ ;
refarg : ON /*13N*/ DELETE refact %prec ON /*13N*/ ;
refarg : ON /*13N*/ UPDATE refact %prec ON /*13N*/ ;

refact : SET NULL ;
refact : SET DEFAULT ;
refact : CASCADE ;
refact : RESTRICT ;
refact : NO ACTION ;

conslist_opt : /*empty*/ ;
conslist_opt : COMMA conslist ;

conslist : conslist tconscomma tcons ;
conslist : tcons ;

tconscomma : COMMA ;
tconscomma : /*empty*/ ;

nm_opt : /*empty*/ ;
nm_opt : nm ;

with_opt : OPTION DATACOPY ;
with_opt : /*empty*/ ;

tcons : CONSTRAINT nm ;
tcons : PRIMARY KEY LP sortlist autoinc RP onconf ;
tcons : UNIQUE nm_opt LP sortlist RP onconf with_opt scanpt where_opt scanpt ;
tcons : INDEX nm_opt LP sortlist RP with_opt scanpt where_opt scanpt ;
tcons : UNIQUE nm_opt LP sortlist RP onconf INCLUDE with_opt2 with_inc scanpt where_opt scanpt ;
tcons : INDEX nm_opt LP sortlist RP INCLUDE with_opt2 with_inc scanpt where_opt scanpt ;
tcons : FOREIGN KEY LP eidlist RP REFERENCES nm LP eidlist RP refargs defer_subclause_opt ;
tcons : CHECK LP scanpt expr scanpt RP ;

defer_subclause_opt : /*empty*/ ;

onconf : /*empty*/ ;
onconf : ON /*13N*/ CONFLICT resolvetype %prec ON /*13N*/ ;

orconf : /*empty*/ ;
orconf : OR /*1L*/ resolvetype %prec OR /*1L*/ ;

resolvetype : IGNORE ;
resolvetype : REPLACE ;

cmd : drop_table ;

drop_table : dryrun DROP TABLE ifexists fullname ;

ifexists : IF EXISTS ;
ifexists : /*empty*/ ;

cmd : dryrun createkw temp VIEW ifnotexists nm dbnm eidlist_opt AS select ;
cmd : dryrun DROP VIEW ifexists fullname ;
cmd : select ;

select : WITH wqlist selectnowith ;
select : WITH RECURSIVE wqlist selectnowith ;
select : selectnowith ;

selectnowith : oneselect ;
selectnowith : selectnowith multiselect_op oneselect ;

multiselect_op : UNION ;
multiselect_op : UNION ALL ;
multiselect_op : EXCEPT ;
multiselect_op : INTERSECT ;

oneselect : SELECT distinct selcollist from where_opt groupby_opt having_opt orderby_opt limit_opt ;
oneselect : SELECT distinct selcollist from where_opt groupby_opt having_opt window_clause orderby_opt limit_opt ;
oneselect : values ;

values : VALUES LP nexprlist RP ;
values : values COMMA LP nexprlist RP ;

oneselect : SELECTV distinct selcollist from where_opt groupby_opt having_opt orderby_opt limit_opt ;
oneselect : SELECTV distinct selcollist from where_opt groupby_opt having_opt window_clause orderby_opt limit_opt ;

distinct : DISTINCT ;
distinct : ALL ;
distinct : /*empty*/ ;

sclp : selcollist COMMA ;
sclp : /*empty*/ ;

selcollist : sclp scanpt expr scanpt as ;
selcollist : sclp scanpt STAR /*9L*/ %prec STAR /*9L*/ ;
selcollist : sclp scanpt nm DOT STAR /*9L*/ %prec STAR /*9L*/ ;

as : AS nm ;
as : ID ;
as : STRING ;
as : /*empty*/ ;

from : /*empty*/ ;
from : FROM seltablist ;

stl_prefix : seltablist joinop ;
stl_prefix : /*empty*/ ;

seltablist : stl_prefix nm dbnm as indexed_opt on_opt using_opt ;
seltablist : stl_prefix nm dbnm LP exprlist RP as on_opt using_opt ;
seltablist : stl_prefix LP select RP as on_opt using_opt ;
seltablist : stl_prefix LP seltablist RP as on_opt using_opt ;

dbnm : /*empty*/ ;
dbnm : DOT nm ;

fullname : nm ;
fullname : nm DOT nm ;

xfullname : nm ;
xfullname : nm DOT nm ;
xfullname : nm DOT nm AS nm ;
xfullname : nm AS nm ;

joinop : COMMA ;
joinop : JOIN ;
joinop : JOIN_KW JOIN ;
joinop : JOIN_KW nm JOIN ;
joinop : JOIN_KW nm nm JOIN ;

on_opt : ON /*13N*/ expr %prec ON /*13N*/ ;
on_opt : /*empty*/ %prec OR /*1L*/ ;

indexed_opt : /*empty*/ ;

using_opt : USING LP idlist RP ;
using_opt : /*empty*/ ;

orderby_opt : /*empty*/ ;
orderby_opt : ORDER BY sortlist ;

sortlist : sortlist COMMA expr sortorder ;
sortlist : expr sortorder ;

sortorder : ASC ;
sortorder : DESC ;
sortorder : /*empty*/ ;

groupby_opt : /*empty*/ ;
groupby_opt : GROUP BY nexprlist ;

having_opt : /*empty*/ ;
having_opt : HAVING expr ;

limit_opt : /*empty*/ ;
limit_opt : LIMIT expr ;
limit_opt : LIMIT expr OFFSET expr ;
limit_opt : LIMIT expr COMMA expr ;

cmd : with DELETE FROM xfullname indexed_opt where_opt ;

where_opt : /*empty*/ ;
where_opt : WHERE expr ;

cmd : with UPDATE xfullname indexed_opt SET setlist where_opt ;

setlist : setlist COMMA nm EQ /*4L*/ expr %prec EQ /*4L*/ ;
setlist : setlist COMMA LP idlist RP EQ /*4L*/ expr %prec EQ /*4L*/ ;
setlist : nm EQ /*4L*/ expr %prec EQ /*4L*/ ;
setlist : LP idlist RP EQ /*4L*/ expr %prec EQ /*4L*/ ;

cmd : with insert_cmd INTO xfullname idlist_opt select upsert ;
cmd : with insert_cmd INTO xfullname idlist_opt DEFAULT VALUES ;

upsert : /*empty*/ ;
upsert : ON /*13N*/ CONFLICT LP sortlist RP where_opt DO UPDATE SET setlist where_opt %prec ON /*13N*/ ;
upsert : ON /*13N*/ CONFLICT LP sortlist RP where_opt DO NOTHING %prec ON /*13N*/ ;
upsert : ON /*13N*/ CONFLICT DO NOTHING %prec ON /*13N*/ ;

insert_cmd : INSERT orconf ;
insert_cmd : REPLACE ;

idlist_opt : /*empty*/ ;
idlist_opt : LP idlist RP ;

idlist : idlist COMMA nm ;
idlist : nm ;

expr : term ;
expr : LP expr RP ;
expr : ID ;
expr : INDEXED ;
expr : JOIN_KW ;
expr : nm DOT nm ;
expr : nm DOT nm DOT nm ;

term : NULL ;
term : FLOAT ;
term : BLOB ;
term : STRING ;
term : INTEGER ;

expr : VARIABLE ;
expr : expr COLLATE /*11L*/ ID %prec COLLATE /*11L*/ ;
expr : expr COLLATE /*11L*/ STRING %prec COLLATE /*11L*/ ;
expr : expr COLLATE /*11L*/ DATACOPY %prec COLLATE /*11L*/ ;
expr : CAST LP expr AS typetoken RP ;
expr : ID LP distinct exprlist RP ;
expr : INDEXED LP distinct exprlist RP ;
expr : ID LP STAR /*9L*/ RP %prec STAR /*9L*/ ;
expr : INDEXED LP STAR /*9L*/ RP %prec STAR /*9L*/ ;
expr : ID LP distinct exprlist RP over_clause ;
expr : INDEXED LP distinct exprlist RP over_clause ;
expr : ID LP STAR /*9L*/ RP over_clause %prec STAR /*9L*/ ;
expr : INDEXED LP STAR /*9L*/ RP over_clause %prec STAR /*9L*/ ;

term : CTIME_KW ;

expr : LP nexprlist COMMA expr RP ;
expr : expr AND /*2L*/ expr %prec AND /*2L*/ ;
expr : expr OR /*1L*/ expr %prec OR /*1L*/ ;
expr : expr LT /*5L*/ expr %prec LT /*5L*/ ;
expr : expr GT /*5L*/ expr %prec LT /*5L*/ ;
expr : expr GE /*5L*/ expr %prec LT /*5L*/ ;
expr : expr LE /*5L*/ expr %prec LT /*5L*/ ;
expr : expr EQ /*4L*/ expr %prec EQ /*4L*/ ;
expr : expr NE /*4L*/ expr %prec EQ /*4L*/ ;
expr : expr BITAND /*7L*/ expr %prec BITAND /*7L*/ ;
expr : expr BITOR /*7L*/ expr %prec BITAND /*7L*/ ;
expr : expr LSHIFT /*7L*/ expr %prec BITAND /*7L*/ ;
expr : expr RSHIFT /*7L*/ expr %prec BITAND /*7L*/ ;
expr : expr PLUS /*8L*/ expr %prec PLUS /*8L*/ ;
expr : expr MINUS /*8L*/ expr %prec PLUS /*8L*/ ;
expr : expr STAR /*9L*/ expr %prec STAR /*9L*/ ;
expr : expr SLASH /*9L*/ expr %prec STAR /*9L*/ ;
expr : expr REM /*9L*/ expr %prec STAR /*9L*/ ;
expr : expr CONCAT /*10L*/ expr %prec CONCAT /*10L*/ ;

likeop : LIKE_KW /*4L*/ %prec LIKE_KW /*4L*/ ;
likeop : MATCH /*4L*/ %prec LIKE_KW /*4L*/ ;
likeop : NOT /*3R*/ LIKE_KW /*4L*/ %prec NOT /*3R*/ ;
likeop : NOT /*3R*/ MATCH /*4L*/ %prec NOT /*3R*/ ;

expr : expr likeop expr %prec LIKE_KW /*4L*/ ;
expr : expr likeop expr ESCAPE /*6R*/ expr %prec LIKE_KW /*4L*/ ;
expr : expr ISNULL /*4L*/ %prec ISNULL /*4L*/ ;
expr : expr NOTNULL /*4L*/ %prec ISNULL /*4L*/ ;
expr : expr NOT /*3R*/ NULL %prec NOT /*3R*/ ;
expr : expr IS /*4L*/ expr %prec IS /*4L*/ ;
expr : expr IS /*4L*/ NOT /*3R*/ expr %prec IS /*4L*/ ;
expr : NOT /*3R*/ expr %prec NOT /*3R*/ ;
expr : BITNOT /*12R*/ expr %prec BITNOT /*12R*/ ;
expr : PLUS /*8L*/ expr %prec BITNOT /*12R*/ ;
expr : MINUS /*8L*/ expr %prec BITNOT /*12R*/ ;

between_op : BETWEEN /*4L*/ %prec BETWEEN /*4L*/ ;
between_op : NOT /*3R*/ BETWEEN /*4L*/ %prec NOT /*3R*/ ;

expr : expr between_op expr AND /*2L*/ expr %prec BETWEEN /*4L*/ ;

in_op : IN /*4L*/ %prec IN /*4L*/ ;
in_op : NOT /*3R*/ IN /*4L*/ %prec NOT /*3R*/ ;

expr : expr in_op LP exprlist RP %prec IN /*4L*/ ;
expr : LP select RP ;
expr : expr in_op LP select RP %prec IN /*4L*/ ;
expr : expr in_op nm dbnm paren_exprlist %prec IN /*4L*/ ;
expr : EXISTS LP select RP ;
expr : CASE case_operand case_exprlist case_else END ;

case_exprlist : case_exprlist WHEN expr THEN expr ;
case_exprlist : WHEN expr THEN expr ;

case_else : ELSE expr ;
case_else : /*empty*/ ;

case_operand : expr ;
case_operand : /*empty*/ ;

exprlist : nexprlist ;
exprlist : /*empty*/ ;

nexprlist : nexprlist COMMA expr ;
nexprlist : expr ;

paren_exprlist : /*empty*/ ;
paren_exprlist : LP exprlist RP ;

pdl : pdl COMMA nm ;
pdl : nm ;

with_inc : LP pdl RP ;
with_inc : /*empty*/ ;

with_opt2 : ALL ;
with_opt2 : /*empty*/ ;

cmd : dryrun createkw temp uniqueflag INDEX ifnotexists nm dbnm ON /*13N*/ nm LP sortlist RP with_opt scanpt where_opt scanpt %prec ON /*13N*/ ;
cmd : dryrun createkw temp uniqueflag INDEX ifnotexists nm dbnm ON /*13N*/ nm LP sortlist RP INCLUDE with_opt2 with_inc scanpt where_opt scanpt %prec ON /*13N*/ ;

uniqueflag : UNIQUE ;
uniqueflag : /*empty*/ ;

eidlist_opt : /*empty*/ ;
eidlist_opt : LP eidlist RP ;

eidlist : eidlist COMMA nm collate sortorder ;
eidlist : nm collate sortorder ;

collate : /*empty*/ ;

cmd : dryrun DROP INDEX ifexists nm ;
cmd : dryrun DROP INDEX ifexists nm ON /*13N*/ nm %prec ON /*13N*/ ;
cmd : VACUUM vinto ;
cmd : VACUUM nm vinto ;

vinto : INTO expr ;
vinto : /*empty*/ ;

cmd : PRAGMA nm dbnm ;
cmd : PRAGMA nm dbnm EQ /*4L*/ nmnum %prec EQ /*4L*/ ;
cmd : PRAGMA nm dbnm LP nmnum RP ;
cmd : PRAGMA nm dbnm EQ /*4L*/ minus_num %prec EQ /*4L*/ ;
cmd : PRAGMA nm dbnm LP minus_num RP ;

nmnum : plus_num ;
nmnum : nm ;
nmnum : ON /*13N*/ %prec ON /*13N*/ ;
nmnum : DELETE ;
nmnum : DEFAULT ;

plus_num : PLUS /*8L*/ INTEGER %prec PLUS /*8L*/ ;
plus_num : PLUS /*8L*/ FLOAT %prec PLUS /*8L*/ ;
plus_num : INTEGER ;
plus_num : FLOAT ;

minus_num : MINUS /*8L*/ INTEGER %prec MINUS /*8L*/ ;
minus_num : MINUS /*8L*/ FLOAT %prec MINUS /*8L*/ ;

cmd : dryrun createkw trigger_decl BEGIN trigger_cmd_list END ;

trigger_decl : temp TRIGGER ifnotexists nm dbnm trigger_time trigger_event ON /*13N*/ fullname foreach_clause when_clause %prec ON /*13N*/ ;

trigger_time : BEFORE ;
trigger_time : AFTER ;
trigger_time : INSTEAD OF ;
trigger_time : /*empty*/ ;

trigger_event : DELETE ;
trigger_event : INSERT ;
trigger_event : UPDATE ;
trigger_event : UPDATE OF idlist ;

foreach_clause : /*empty*/ ;
foreach_clause : FOR EACH ROW ;

when_clause : /*empty*/ ;
when_clause : WHEN expr ;

trigger_cmd_list : trigger_cmd_list trigger_cmd SEMI ;
trigger_cmd_list : trigger_cmd SEMI ;

trnm : nm ;
trnm : nm DOT nm ;

tridxby : /*empty*/ ;
tridxby : INDEXED BY nm ;
tridxby : NOT /*3R*/ INDEXED %prec NOT /*3R*/ ;

trigger_cmd : UPDATE orconf trnm tridxby SET setlist where_opt scanpt ;
trigger_cmd : scanpt insert_cmd INTO trnm idlist_opt select upsert scanpt ;
trigger_cmd : DELETE FROM trnm tridxby where_opt scanpt ;
trigger_cmd : scanpt select scanpt ;

expr : RAISE LP IGNORE RP ;
expr : RAISE LP raisetype COMMA nm RP ;

raisetype : ROLLBACK ;
raisetype : ABORT ;
raisetype : FAIL ;

cmd : dryrun DROP TRIGGER ifexists fullname ;

dryrun : DRYRUN ;
dryrun : /*empty*/ ;

cmd : ATTACH database_kw_opt expr AS expr key_opt ;
cmd : DETACH database_kw_opt expr ;

key_opt : /*empty*/ ;
key_opt : KEY expr ;

database_kw_opt : DATABASE ;
database_kw_opt : /*empty*/ ;

cmd : REINDEX ;
cmd : REINDEX nm dbnm ;
cmd : ANALYZESQLITE ;
cmd : ANALYZESQLITE nm dbnm ;
cmd : ANALYZEEXPERT ;
cmd : ANALYZEEXPERT nm dbnm ;

constraint_opt : /*empty*/ ;
constraint_opt : CONSTRAINT nm ;

alter_comma : COMMA ;

tconspk : PRIMARY KEY LP sortlist autoinc RP onconf ;

tconsfk : constraint_opt FOREIGN KEY LP eidlist RP REFERENCES nm LP eidlist RP refargs defer_subclause_opt ;

tconscheck : constraint_opt CHECK LP scanpt expr scanpt RP ;

cmd : alter_table_csc2 ;
cmd : alter_table alter_table_action_list ;

alter_table : dryrun ALTER TABLE nm dbnm ;

alter_table_csc2 : dryrun ALTER TABLE nm dbnm comdb2opt NOSQL ;

alter_table_add_column : ADD kwcolumn_opt columnname carglist ;

alter_table_drop_column : DROP kwcolumn_opt nm ;

set_data_opt : /*empty*/ ;
set_data_opt : SET DATA ;

alter_table_alter_column_start : ALTER kwcolumn_opt nm ;

alter_table_alter_column_cmd : set_data_opt TYPE typetoken ;
alter_table_alter_column_cmd : SET DEFAULT scanpt term scanpt ;
alter_table_alter_column_cmd : DROP DEFAULT ;
alter_table_alter_column_cmd : DROP AUTOINCR ;
alter_table_alter_column_cmd : SET NOT /*3R*/ NULL %prec NOT /*3R*/ ;
alter_table_alter_column_cmd : DROP NOT /*3R*/ NULL %prec NOT /*3R*/ ;

alter_table_alter_column : alter_table_alter_column_start alter_table_alter_column_cmd ;

alter_table_add_pk : ADD tconspk ;

alter_table_drop_pk : DROP PRIMARY KEY ;

alter_table_add_fk : ADD tconsfk ;

alter_table_drop_fk : DROP FOREIGN KEY nm ;

alter_table_add_check_cons : ADD tconscheck ;

alter_table_drop_cons : DROP CONSTRAINT nm ;

alter_table_add_index : ADD uniqueflag INDEX nm LP sortlist RP with_opt where_opt ;
alter_table_add_index : ADD uniqueflag INDEX nm LP sortlist RP INCLUDE with_opt2 with_inc where_opt ;

alter_table_drop_index : DROP INDEX nm ;

alter_table_commit_pending : SET COMMIT PENDING ;

alter_table_partitioned : partitioned_by ;

alter_table_merge : merge_with_alter ;

alter_table_alter_options : ALTER OPTIONS LP comdb2optlist RP ;

alter_table_action : alter_table_add_column ;
alter_table_action : alter_table_drop_column ;
alter_table_action : alter_table_alter_column ;
alter_table_action : alter_table_add_pk ;
alter_table_action : alter_table_drop_pk ;
alter_table_action : alter_table_add_fk ;
alter_table_action : alter_table_drop_fk ;
alter_table_action : alter_table_add_check_cons ;
alter_table_action : alter_table_drop_cons ;
alter_table_action : alter_table_add_index ;
alter_table_action : alter_table_drop_index ;
alter_table_action : alter_table_commit_pending ;
alter_table_action : alter_table_partitioned ;
alter_table_action : alter_table_merge ;
alter_table_action : alter_table_alter_options ;

alter_table_action_list : DO NOTHING ;
alter_table_action_list : alter_table_action ;
alter_table_action_list : alter_table_action_list alter_comma alter_table_action ;

cmd : dryrun ALTER TABLE nm RENAME TO nm ;

kwcolumn_opt : /*empty*/ ;
kwcolumn_opt : COLUMNKW ;

cmd : create_vtab ;
cmd : create_vtab LP vtabarglist RP ;

create_vtab : dryrun createkw VIRTUAL TABLE ifnotexists nm dbnm USING nm ;

vtabarglist : vtabarg ;
vtabarglist : vtabarglist COMMA vtabarg ;

vtabarg : /*empty*/ ;
vtabarg : vtabarg vtabargtoken ;

vtabargtoken : ANY ;
vtabargtoken : lp anylist RP ;

lp : LP ;

anylist : /*empty*/ ;
anylist : anylist LP anylist RP ;
anylist : anylist ANY ;

with : /*empty*/ ;
with : WITH wqlist ;
with : WITH RECURSIVE wqlist ;

wqlist : nm eidlist_opt AS LP select RP ;
wqlist : wqlist COMMA nm eidlist_opt AS LP select RP ;

cmd : EXEC sproccmd ;
cmd : EXECUTE sproccmd ;

exec_proc_arg : NULL ;
exec_proc_arg : FLOAT ;
exec_proc_arg : BLOB ;
exec_proc_arg : STRING ;
exec_proc_arg : INTEGER ;

exec_proc_arg_list : exec_proc_arg ;
exec_proc_arg_list : exec_proc_arg_list COMMA exec_proc_arg ;

sproccmd : PROCEDURE ID LP exec_proc_arg_list RP ;
sproccmd : PROCEDURE STRING LP exec_proc_arg_list RP ;

cmd : GET getcmd ;

getcmd : ALIAS nm ;
getcmd : KW ;
getcmd : RESERVED KW ;
getcmd : NOT /*3R*/ RESERVED KW %prec NOT /*3R*/ ;
getcmd : ANALYZE COVERAGE nm dbnm ;
getcmd : ANALYZE THRESHOLD nm dbnm ;

cmd : PUT putcmd ;

putcmd : ANALYZE COVERAGE nm dbnm INTEGER ;
putcmd : GENID48 ENABLE ;
putcmd : GENID48 DISABLE ;
putcmd : ROWLOCKS ENABLE ;
putcmd : ROWLOCKS DISABLE ;
putcmd : ANALYZE THRESHOLD nm dbnm INTEGER ;
putcmd : SKIPSCAN ENABLE nm dbnm ;
putcmd : SKIPSCAN DISABLE nm dbnm ;
putcmd : DEFAULT PROCEDURE nm INTEGER ;
putcmd : DEFAULT PROCEDURE nm STRING ;
putcmd : ALIAS nm nm ;
putcmd : PASSWORD OFF FOR nm ;
putcmd : PASSWORD STRING FOR nm ;
putcmd : AUTHENTICATION ON /*13N*/ %prec ON /*13N*/ ;
putcmd : AUTHENTICATION OFF ;
putcmd : TIME PARTITION nm dbnm RETENTION INTEGER ;
putcmd : COUNTER nm dbnm INCREMENT ;
putcmd : COUNTER nm dbnm SET INTEGER ;
putcmd : SCHEMACHANGE COMMITSLEEP INTEGER ;
putcmd : SCHEMACHANGE CONVERTSLEEP INTEGER ;

tunable_value : INTEGER ;
tunable_value : MINUS /*8L*/ INTEGER %prec MINUS /*8L*/ ;
tunable_value : MINUS /*8L*/ FLOAT %prec MINUS /*8L*/ ;
tunable_value : STRING ;

opteq : /*empty*/ ;
opteq : EQ /*4L*/ %prec EQ /*4L*/ ;

putcmd : TUNABLE nm dbnm opteq tunable_value ;

cmd : rebuild ;

rebuild : dryrun REBUILD nm dbnm comdb2opt ;
rebuild : dryrun REBUILD INDEX nm dbnm nm comdb2opt ;
rebuild : dryrun REBUILD DATA nm dbnm comdb2opt ;
rebuild : dryrun REBUILD DATABLOB nm dbnm comdb2opt ;

cmd : scctrl ;

scaction : PAUSE ;
scaction : RESUME ;
scaction : COMMIT ;
scaction : ABORT ;

scctrl : SCHEMACHANGE scaction nm dbnm ;

sql_permission : READ ;
sql_permission : WRITE ;
sql_permission : DDL ;

op_permission : OP ;

userschema : USERSCHEMA ;

cmd : GRANT sql_permission ON /*13N*/ nm dbnm TO nm %prec ON /*13N*/ ;
cmd : GRANT op_permission TO nm ;
cmd : GRANT userschema nm TO nm ;
cmd : REVOKE sql_permission ON /*13N*/ nm dbnm TO nm %prec ON /*13N*/ ;
cmd : REVOKE sql_permission ON /*13N*/ nm dbnm FROM nm %prec ON /*13N*/ ;
cmd : REVOKE op_permission TO nm ;
cmd : REVOKE op_permission FROM nm ;
cmd : REVOKE userschema nm TO nm ;
cmd : REVOKE userschema nm FROM nm ;

table_opt : /*empty*/ ;
table_opt : TABLE ;

cmd : dryrun TRUNCATE table_opt nm dbnm ;
cmd : BULKIMPORT nm DOT nm nm DOT nm ;
cmd : dryrun createkw RANGE PARTITION ON /*13N*/ nm WHERE columnname IN /*4L*/ LP exprlist RP %prec ON /*13N*/ ;
cmd : dryrun createkw partition_type PARTITION ON /*13N*/ nm AS nm PERIOD STRING RETENTION INTEGER START STRING %prec ON /*13N*/ ;

partition_type : /*empty*/ ;
partition_type : TIME ;

cmd : dryrun DROP TIME PARTITION nm ;
cmd : ANALYZE nm dbnm analyzepercentage analyzeopt ;
cmd : ANALYZE ALL analyzepercentage analyzeopt ;
cmd : ANALYZE analyzepercentage analyzeopt ;

analyzepercentage : /*empty*/ ;
analyzepercentage : INTEGER ;

analyzeopt : /*empty*/ ;
analyzeopt : OPTIONS analyzeoptlst ;

analyzeoptlst : analyze_thds COMMA analyze_sumthds ;
analyzeoptlst : analyze_sumthds COMMA analyze_thds ;
analyzeoptlst : analyze_thds ;
analyzeoptlst : analyze_sumthds ;

analyze_thds : THREADS INTEGER ;

analyze_sumthds : SUMMARIZE INTEGER ;

comdb2opt : /*empty*/ ;
comdb2opt : OPTIONS comdb2optlist ;

comdb2optlist : comdb2optlist COMMA comdb2optfield ;
comdb2optlist : comdb2optfield ;

comdb2optfield : odh ;
comdb2optfield : ipu ;
comdb2optfield : isc ;
comdb2optfield : FORCE ;
comdb2optfield : PAGEORDER ;
comdb2optfield : READONLY ;
comdb2optfield : compress_blob ;
comdb2optfield : compress_rec ;

odh : ODH OFF ;
odh : ODH ON /*13N*/ %prec ON /*13N*/ ;

ipu : IPU OFF ;
ipu : IPU ON /*13N*/ %prec ON /*13N*/ ;

isc : ISC OFF ;
isc : ISC ON /*13N*/ %prec ON /*13N*/ ;

compress_blob : BLOBFIELD blob_compress_type ;

blob_compress_type : NONE ;
blob_compress_type : RLE ;
blob_compress_type : ZLIB ;
blob_compress_type : LZ4 ;

compress_rec : REC rle_compress_type ;

rle_compress_type : NONE ;
rle_compress_type : RLE ;
rle_compress_type : CRLE ;
rle_compress_type : ZLIB ;
rle_compress_type : LZ4 ;

cmd : dryrun CREATE PROCEDURE nm NOSQL ;
cmd : dryrun CREATE PROCEDURE nm VERSION STRING NOSQL ;
cmd : dryrun DROP PROCEDURE nm INTEGER ;
cmd : dryrun DROP PROCEDURE nm VERSION INTEGER ;
cmd : dryrun DROP PROCEDURE nm STRING ;
cmd : dryrun DROP PROCEDURE nm VERSION STRING ;

sfuncattr : DETERMINISTIC ;
sfuncattr : /*empty*/ ;

cmd : dryrun CREATE LUA SCALAR FUNCTION nm sfuncattr ;
cmd : dryrun CREATE LUA AGGREGATE FUNCTION nm ;
cmd : dryrun CREATE trigger nm withsequence ON /*13N*/ table_trigger_event %prec ON /*13N*/ ;

trigger : LUA TRIGGER ;
trigger : LUA CONSUMER ;
trigger : DEFAULT LUA CONSUMER ;

table_trigger_event : table_trigger_event COMMA LP TABLE fullname FOR trigger_events RP ;
table_trigger_event : LP TABLE fullname FOR trigger_events RP ;

withsequence : /*empty*/ ;
withsequence : WITHOUT SEQUENCE ;
withsequence : WITH SEQUENCE ;

trigger_events : trigger_events AND /*2L*/ cdb2_trigger_event %prec AND /*2L*/ ;
trigger_events : cdb2_trigger_event ;

cdb2_trigger_event : DELETE ;
cdb2_trigger_event : INSERT ;
cdb2_trigger_event : UPDATE ;
cdb2_trigger_event : DELETE OF idlist ;
cdb2_trigger_event : INSERT OF idlist ;
cdb2_trigger_event : UPDATE OF idlist ;

cmd : dryrun DROP LUA SCALAR FUNCTION nm ;
cmd : dryrun DROP LUA AGGREGATE FUNCTION nm ;
cmd : dryrun DROP LUA TRIGGER nm ;
cmd : dryrun DROP LUA CONSUMER nm ;

windowdefn_list : windowdefn ;
windowdefn_list : windowdefn_list COMMA windowdefn ;

windowdefn : nm AS LP window RP ;

window : PARTITION BY nexprlist orderby_opt frame_opt ;
window : nm PARTITION BY nexprlist orderby_opt frame_opt ;
window : ORDER BY sortlist frame_opt ;
window : nm ORDER BY sortlist frame_opt ;
window : frame_opt ;
window : nm frame_opt ;

frame_opt : /*empty*/ ;
frame_opt : range_or_rows frame_bound_s frame_exclude_opt ;
frame_opt : range_or_rows BETWEEN /*4L*/ frame_bound_s AND /*2L*/ frame_bound_e frame_exclude_opt %prec BETWEEN /*4L*/ ;

range_or_rows : RANGE ;
range_or_rows : ROWS ;
range_or_rows : GROUPS ;

frame_bound_s : frame_bound ;
frame_bound_s : UNBOUNDED PRECEDING ;

frame_bound_e : frame_bound ;
frame_bound_e : UNBOUNDED FOLLOWING ;

frame_bound : expr PRECEDING ;
frame_bound : expr FOLLOWING ;
frame_bound : CURRENT ROW ;

frame_exclude_opt : /*empty*/ ;
frame_exclude_opt : EXCLUDE frame_exclude ;

frame_exclude : NO OTHERS ;
frame_exclude : CURRENT ROW ;
frame_exclude : GROUP ;
frame_exclude : TIES ;

window_clause : WINDOW windowdefn_list ;

over_clause : filter_opt OVER LP window RP ;
over_clause : filter_opt OVER nm ;

filter_opt : /*empty*/ ;
filter_opt : FILTER LP WHERE expr RP ;

ANY : ID ; //for playground

%%

%option caseless

BASE_ID	[_a-zA-Z][a-zA-Z0-9_]*

%%

[ \t\n\r]+   skip()
"--".*      skip()
"/*"(?s:.)*?"*/"    skip()

ABORT	ABORT
ACTION	ACTION
ADD	ADD
AFTER	AFTER
AGGREGATE	AGGREGATE
ALIAS	ALIAS
ALL	ALL
ALTER	ALTER
ANALYZE	ANALYZE
ANALYZEEXPERT	ANALYZEEXPERT
ANALYZESQLITE	ANALYZESQLITE
AND	AND
AS	AS
ASC	ASC
ATTACH	ATTACH
AUTHENTICATION	AUTHENTICATION
AUTOINCR	AUTOINCR
BEFORE	BEFORE
BEGIN	BEGIN
BETWEEN	BETWEEN
"&"	BITAND
"~"	BITNOT
"|"	BITOR
BLOB	BLOB
BLOBFIELD	BLOBFIELD
BULKIMPORT	BULKIMPORT
BY	BY
CASCADE	CASCADE
CASE	CASE
CAST	CAST
CHECK	CHECK
COLLATE	COLLATE
COLUMNKW	COLUMNKW
","	COMMA
COMMIT	COMMIT
COMMITSLEEP	COMMITSLEEP
"||"	CONCAT
CONFLICT	CONFLICT
CONSTRAINT	CONSTRAINT
CONSUMER	CONSUMER
CONVERTSLEEP	CONVERTSLEEP
COUNTER	COUNTER
COVERAGE	COVERAGE
CREATE	CREATE
CRLE	CRLE
"CURRENT_DATE"|"CURRENT_TIME"|"CURRENT_TIMESTAMP"	CTIME_KW
CURRENT	CURRENT
DATA	DATA
DATABASE	DATABASE
DATABLOB	DATABLOB
DATACOPY	DATACOPY
DBPAD	DBPAD
DDL	DDL
DEFAULT	DEFAULT
DEFERRED	DEFERRED
DELETE	DELETE
DESC	DESC
DETACH	DETACH
DETERMINISTIC	DETERMINISTIC
DISABLE	DISABLE
DISTINCT	DISTINCT
DISTRIBUTION	DISTRIBUTION
DO	DO
"."	DOT
DROP	DROP
DRYRUN	DRYRUN
EACH	EACH
ELSE	ELSE
ENABLE	ENABLE
END	END
"="	EQ
ESCAPE	ESCAPE
EXCEPT	EXCEPT
EXCLUDE	EXCLUDE
EXCLUSIVE	EXCLUSIVE
EXEC	EXEC
EXECUTE	EXECUTE
EXISTS	EXISTS
EXPLAIN	EXPLAIN
FAIL	FAIL
FILTER	FILTER
FOLLOWING	FOLLOWING
FOR	FOR
FORCE	FORCE
FOREIGN	FOREIGN
FROM	FROM
FUNCTION	FUNCTION
">="	GE
GENID48	GENID48
GET	GET
GRANT	GRANT
GROUP	GROUP
GROUPS	GROUPS
">"	GT
HAVING	HAVING
IF	IF
IGNORE	IGNORE
IMMEDIATE	IMMEDIATE
IN	IN
INCLUDE	INCLUDE
INCREMENT	INCREMENT
INDEX	INDEX
INDEXED	INDEXED
INSERT	INSERT
INSTEAD	INSTEAD
INTERSECT	INTERSECT
INTO	INTO
IPU	IPU
IS	IS
ISC	ISC
ISNULL	ISNULL
JOIN	JOIN
CROSS|FULL|INNER|LEFT|NATURAL|OUTER|RIGHT	JOIN_KW
KEY	KEY
KW	KW
"<="	LE
LIKE|GLOB|REGEXP	LIKE_KW
LIMIT	LIMIT
"("	LP
"<<"	LSHIFT
"<"	LT
LUA	LUA
LZ4	LZ4
MANUAL	MANUAL
MATCH	MATCH
MERGE	MERGE
"-"	MINUS
"<>"|"!="	NE
NO	NO
NONE	NONE
NOSQL	NOSQL
NOT	NOT
NOTHING	NOTHING
NOTNULL	NOTNULL
NULL	NULL
ODH	ODH
OF	OF
OFF	OFF
OFFSET	OFFSET
ON	ON
OP	OP
OPTION	OPTION
OPTIONS	OPTIONS
OR	OR
ORDER	ORDER
OTHERS	OTHERS
OVER	OVER
PAGEORDER	PAGEORDER
PARTITION	PARTITION
PARTITIONED	PARTITIONED
PASSWORD	PASSWORD
PAUSE	PAUSE
PENDING	PENDING
PERIOD	PERIOD
PLAN	PLAN
"+"	PLUS
PRAGMA	PRAGMA
PRECEDING	PRECEDING
PRIMARY	PRIMARY
PROCEDURE	PROCEDURE
PUT	PUT
QUERY	QUERY
RAISE	RAISE
RANGE	RANGE
READ	READ
READONLY	READONLY
REBUILD	REBUILD
REC	REC
RECURSIVE	RECURSIVE
REFERENCES	REFERENCES
REINDEX	REINDEX
RELEASE	RELEASE
"%"	REM
RENAME	RENAME
REPLACE	REPLACE
RESERVED	RESERVED
RESTRICT	RESTRICT
RESUME	RESUME
RETENTION	RETENTION
REVOKE	REVOKE
RLE	RLE
ROLLBACK	ROLLBACK
ROW	ROW
ROWLOCKS	ROWLOCKS
ROWS	ROWS
")"	RP
">>"	RSHIFT
SAVEPOINT	SAVEPOINT
SCALAR	SCALAR
SCHEMACHANGE	SCHEMACHANGE
SELECT	SELECT
SELECTV	SELECTV
";"	SEMI
SEQUENCE	SEQUENCE
SET	SET
SKIPSCAN	SKIPSCAN
"/"	SLASH
"*"	STAR
START	START
SUMMARIZE	SUMMARIZE
TABLE	TABLE
TEMP	TEMP
THEN	THEN
THREADS	THREADS
THRESHOLD	THRESHOLD
TIES	TIES
TIME	TIME
TO	TO
TRANSACTION	TRANSACTION
TRIGGER	TRIGGER
TRUNCATE	TRUNCATE
TUNABLE	TUNABLE
TYPE	TYPE
UNBOUNDED	UNBOUNDED
UNION	UNION
UNIQUE	UNIQUE
UPDATE	UPDATE
USERSCHEMA	USERSCHEMA
USING	USING
VACUUM	VACUUM
VALUES	VALUES
VARIABLE	VARIABLE
VERSION	VERSION
VIEW	VIEW
VIRTUAL	VIRTUAL
WHEN	WHEN
WHERE	WHERE
WINDOW	WINDOW
WITH	WITH
WITHOUT	WITHOUT
WRITE	WRITE
ZLIB	ZLIB

([0-9]+\.[0-9]*|\.[0-9]+)([Ee](\+|\-)?[0-9]+)?	FLOAT
[0-9]+	INTEGER
'(''|[^'\n])*'	STRING
/* Order matter if identifier comes before keywords they are classified as identifier */
{BASE_ID}|\"{BASE_ID}\"	ID


%%
