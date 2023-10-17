//From: https://www.sqlite.org/src/info/aeb7760d41cfa86465e3adba506500c021597049fd55f82a30e5b7045862c28c

/*
This grammar has inlined "sclp" in "selcollist" for get a shallow parser tree.
Also added "softkeyword" to "nm" as a placeholder to add soft keywords as
a kind of "fallback" functionality.
*/

%token  SEMI EXPLAIN QUERY PLAN BEGIN TRANSACTION
%token  DEFERRED IMMEDIATE EXCLUSIVE COMMIT END ROLLBACK
%token  SAVEPOINT RELEASE TO TABLE CREATE IF
%token  NOT EXISTS TEMP LP RP AS
%token  COMMA WITHOUT ABORT ACTION AFTER ANALYZE
%token  ASC ATTACH BEFORE BY CASCADE CAST
%token  CONFLICT DATABASE DESC DETACH EACH FAIL
%token  OR AND IS MATCH LIKE_KW BETWEEN
%token  IN ISNULL NOTNULL NE EQ GT
%token  LE LT GE ESCAPE ID COLUMNKW
%token  DO FOR IGNORE INITIALLY INSTEAD NO
%token  KEY OF OFFSET PRAGMA RAISE RECURSIVE
%token  REPLACE RESTRICT ROW ROWS TRIGGER VACUUM
%token  VIEW VIRTUAL WITH NULLS FIRST LAST
%token  CURRENT FOLLOWING PARTITION PRECEDING RANGE UNBOUNDED
%token  EXCLUDE GROUPS OTHERS TIES GENERATED ALWAYS
%token  MATERIALIZED REINDEX RENAME CTIME_KW BITAND
%token  BITOR LSHIFT RSHIFT PLUS MINUS STAR
%token  SLASH REM CONCAT PTR COLLATE BITNOT
%token  ON INDEXED STRING JOIN_KW CONSTRAINT DEFAULT
%token  NULL PRIMARY UNIQUE CHECK REFERENCES AUTOINCR
%token  INSERT DELETE UPDATE SET DEFERRABLE FOREIGN
%token  DROP UNION ALL EXCEPT INTERSECT SELECT
%token  VALUES DISTINCT DOT FROM JOIN USING
%token  ORDER GROUP HAVING LIMIT WHERE RETURNING
%token  INTO NOTHING FLOAT BLOB INTEGER VARIABLE
%token  CASE WHEN THEN ELSE INDEX ALTER
%token  ADD WINDOW OVER FILTER

/*
%token COLUMN AGG_COLUMN AGG_FUNCTION TRUEFALSE
%token ISNOT TRUTH REGISTER VECTOR SELECT_COLUMN
%token  FUNCTION UMINUS UPLUS
%token  IF_NULL_ROW ASTERISK
%token  SPAN ERROR SPACE ILLEGAL
*/

%left /*1*/ OR
%left /*2*/ AND
%right /*3*/ NOT
%left /*4*/ IS MATCH LIKE_KW BETWEEN IN ISNULL NOTNULL NE EQ
%left /*5*/ GT LE LT GE
%right /*6*/ ESCAPE
%left /*7*/ BITAND BITOR LSHIFT RSHIFT
%left /*8*/ PLUS MINUS
%left /*9*/ STAR SLASH REM
%left /*10*/ CONCAT PTR
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
ecmd : explain cmdx SEMI ;

explain : EXPLAIN ;
explain : EXPLAIN QUERY PLAN ;

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

create_table : createkw temp TABLE ifnotexists nm dbnm ;

createkw : CREATE ;

ifnotexists : /*empty*/ ;
ifnotexists : IF NOT /*3R*/ EXISTS %prec NOT /*3R*/ ;

temp : TEMP ;
temp : /*empty*/ ;

create_table_args : LP columnlist conslist_opt RP table_option_set ;
create_table_args : AS select ;

table_option_set : /*empty*/ ;
table_option_set : table_option ;
table_option_set : table_option_set COMMA table_option ;

table_option : WITHOUT nm ;
table_option : nm ;

columnlist : columnlist COMMA columnname carglist ;
columnlist : columnname carglist ;

columnname : nm typetoken ;

nm : ID ;
nm : STRING ;
nm : softkeyword ;

/* if needed add soft keywords here to kind of emulate "fallback" */
softkeyword : INDEXED ;
softkeyword : JOIN_KW ;

typetoken : /*empty*/ ;
typetoken : typename ;
typetoken : typename LP signed RP ;
typetoken : typename LP signed COMMA signed RP ;

typename : ID ;
typename : STRING ;
typename : typename ID ;
typename : typename STRING ;

signed : plus_num ;
signed : minus_num ;

scanpt : /*empty*/ ;

scantok : /*empty*/ ;

carglist : carglist ccons ;
carglist : /*empty*/ ;

ccons : CONSTRAINT nm ;
ccons : DEFAULT scantok term ;
ccons : DEFAULT LP expr RP ;
ccons : DEFAULT PLUS /*8L*/ scantok term %prec PLUS /*8L*/ ;
ccons : DEFAULT MINUS /*8L*/ scantok term %prec MINUS /*8L*/ ;
ccons : DEFAULT scantok ID ;
ccons : DEFAULT scantok INDEXED ;
ccons : NULL onconf ;
ccons : NOT /*3R*/ NULL onconf %prec NOT /*3R*/ ;
ccons : PRIMARY KEY sortorder onconf autoinc ;
ccons : UNIQUE onconf ;
ccons : CHECK LP expr RP ;
ccons : REFERENCES nm eidlist_opt refargs ;
ccons : defer_subclause ;
ccons : COLLATE /*11L*/ ID %prec COLLATE /*11L*/ ;
ccons : COLLATE /*11L*/ STRING %prec COLLATE /*11L*/ ;
ccons : GENERATED ALWAYS AS generated ;
ccons : AS generated ;

generated : LP expr RP ;
generated : LP expr RP ID ;

autoinc : /*empty*/ ;
autoinc : AUTOINCR ;

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

defer_subclause : NOT /*3R*/ DEFERRABLE init_deferred_pred_opt %prec NOT /*3R*/ ;
defer_subclause : DEFERRABLE init_deferred_pred_opt ;

init_deferred_pred_opt : /*empty*/ ;
init_deferred_pred_opt : INITIALLY DEFERRED ;
init_deferred_pred_opt : INITIALLY IMMEDIATE ;

conslist_opt : /*empty*/ ;
conslist_opt : COMMA conslist ;

conslist : conslist tconscomma tcons ;
conslist : tcons ;

tconscomma : COMMA ;
tconscomma : /*empty*/ ;

tcons : CONSTRAINT nm ;
tcons : PRIMARY KEY LP sortlist autoinc RP onconf ;
tcons : UNIQUE LP sortlist RP onconf ;
tcons : CHECK LP expr RP onconf ;
tcons : FOREIGN KEY LP eidlist RP REFERENCES nm eidlist_opt refargs defer_subclause_opt ;

defer_subclause_opt : /*empty*/ ;
defer_subclause_opt : defer_subclause ;

onconf : /*empty*/ ;
onconf : ON /*13N*/ CONFLICT resolvetype %prec ON /*13N*/ ;

orconf : /*empty*/ ;
orconf : OR /*1L*/ resolvetype %prec OR /*1L*/ ;

resolvetype : raisetype ;
resolvetype : IGNORE ;
resolvetype : REPLACE ;

cmd : DROP TABLE ifexists fullname ;

ifexists : IF EXISTS ;
ifexists : /*empty*/ ;

cmd : createkw temp VIEW ifnotexists nm dbnm eidlist_opt AS select ;
cmd : DROP VIEW ifexists fullname ;
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

distinct : DISTINCT ;
distinct : ALL ;
distinct : /*empty*/ ;

/* Inlining the next auxiliar rule to get a shallow parser tree */
//sclp : selcollist COMMA ;
//sclp : /*empty*/ ;

selcollist : scanpt expr scanpt as ;
selcollist : selcollist COMMA scanpt expr scanpt as ;
selcollist : scanpt STAR /*9L*/ %prec STAR /*9L*/ ;
selcollist : selcollist COMMA scanpt STAR /*9L*/ %prec STAR /*9L*/ ;
selcollist : scanpt nm DOT STAR /*9L*/ %prec STAR /*9L*/ ;
selcollist : selcollist COMMA scanpt nm DOT STAR /*9L*/ %prec STAR /*9L*/ ;

as : AS nm ;
as : ID ;
as : STRING ;
as : /*empty*/ ;

from : /*empty*/ ;
from : FROM seltablist ;

stl_prefix : seltablist joinop ;
stl_prefix : /*empty*/ ;

seltablist : stl_prefix nm dbnm as on_using ;
seltablist : stl_prefix nm dbnm as indexed_by on_using ;
seltablist : stl_prefix nm dbnm LP exprlist RP as on_using ;
seltablist : stl_prefix LP select RP as on_using ;
seltablist : stl_prefix LP seltablist RP as on_using ;

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

on_using : ON /*13N*/ expr %prec ON /*13N*/ ;
on_using : USING LP idlist RP ;
on_using : /*empty*/ %prec OR /*1L*/ ;

indexed_opt : /*empty*/ ;
indexed_opt : indexed_by ;

indexed_by : INDEXED BY nm ;
indexed_by : NOT /*3R*/ INDEXED %prec NOT /*3R*/ ;

orderby_opt : /*empty*/ ;
orderby_opt : ORDER BY sortlist ;

sortlist : sortlist COMMA expr sortorder nulls ;
sortlist : expr sortorder nulls ;

sortorder : ASC ;
sortorder : DESC ;
sortorder : /*empty*/ ;

nulls : NULLS FIRST ;
nulls : NULLS LAST ;
nulls : /*empty*/ ;

groupby_opt : /*empty*/ ;
groupby_opt : GROUP BY nexprlist ;

having_opt : /*empty*/ ;
having_opt : HAVING expr ;

limit_opt : /*empty*/ ;
limit_opt : LIMIT expr ;
limit_opt : LIMIT expr OFFSET expr ;
limit_opt : LIMIT expr COMMA expr ;

cmd : with DELETE FROM xfullname indexed_opt where_opt_ret ;

where_opt : /*empty*/ ;
where_opt : WHERE expr ;

where_opt_ret : /*empty*/ ;
where_opt_ret : WHERE expr ;
where_opt_ret : RETURNING selcollist ;
where_opt_ret : WHERE expr RETURNING selcollist ;

cmd : with UPDATE orconf xfullname indexed_opt SET setlist from where_opt_ret ;

setlist : setlist COMMA nm EQ /*4L*/ expr %prec EQ /*4L*/ ;
setlist : setlist COMMA LP idlist RP EQ /*4L*/ expr %prec EQ /*4L*/ ;
setlist : nm EQ /*4L*/ expr %prec EQ /*4L*/ ;
setlist : LP idlist RP EQ /*4L*/ expr %prec EQ /*4L*/ ;

cmd : with insert_cmd INTO xfullname idlist_opt select upsert ;
cmd : with insert_cmd INTO xfullname idlist_opt DEFAULT VALUES returning ;

upsert : /*empty*/ ;
upsert : RETURNING selcollist ;
upsert : ON /*13N*/ CONFLICT LP sortlist RP where_opt DO UPDATE SET setlist where_opt upsert %prec ON /*13N*/ ;
upsert : ON /*13N*/ CONFLICT LP sortlist RP where_opt DO NOTHING upsert %prec ON /*13N*/ ;
upsert : ON /*13N*/ CONFLICT DO NOTHING returning %prec ON /*13N*/ ;
upsert : ON /*13N*/ CONFLICT DO UPDATE SET setlist where_opt returning %prec ON /*13N*/ ;

returning : RETURNING selcollist ;
returning : /*empty*/ ;

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
expr : CAST LP expr AS typetoken RP ;
expr : ID LP distinct exprlist RP ;
expr : INDEXED LP distinct exprlist RP ;
expr : JOIN_KW LP distinct exprlist RP ;
expr : ID LP STAR /*9L*/ RP %prec STAR /*9L*/ ;
expr : INDEXED LP STAR /*9L*/ RP %prec STAR /*9L*/ ;
expr : JOIN_KW LP STAR /*9L*/ RP %prec STAR /*9L*/ ;
expr : ID LP distinct exprlist RP filter_over ;
expr : INDEXED LP distinct exprlist RP filter_over ;
expr : JOIN_KW LP distinct exprlist RP filter_over ;
expr : ID LP STAR /*9L*/ RP filter_over %prec STAR /*9L*/ ;
expr : INDEXED LP STAR /*9L*/ RP filter_over %prec STAR /*9L*/ ;
expr : JOIN_KW LP STAR /*9L*/ RP filter_over %prec STAR /*9L*/ ;

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
expr : expr IS /*4L*/ NOT /*3R*/ DISTINCT FROM expr %prec IS /*4L*/ ;
expr : expr IS /*4L*/ DISTINCT FROM expr %prec IS /*4L*/ ;
expr : NOT /*3R*/ expr %prec NOT /*3R*/ ;
expr : BITNOT /*12R*/ expr %prec BITNOT /*12R*/ ;
expr : PLUS /*8L*/ expr %prec BITNOT /*12R*/ ;
expr : MINUS /*8L*/ expr %prec BITNOT /*12R*/ ;
expr : expr PTR /*10L*/ expr %prec PTR /*10L*/ ;

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

cmd : createkw uniqueflag INDEX ifnotexists nm dbnm ON /*13N*/ nm LP sortlist RP where_opt %prec ON /*13N*/ ;

uniqueflag : UNIQUE ;
uniqueflag : /*empty*/ ;

eidlist_opt : /*empty*/ ;
eidlist_opt : LP eidlist RP ;

eidlist : eidlist COMMA nm collate sortorder ;
eidlist : nm collate sortorder ;

collate : /*empty*/ ;
collate : COLLATE /*11L*/ ID %prec COLLATE /*11L*/ ;
collate : COLLATE /*11L*/ STRING %prec COLLATE /*11L*/ ;

cmd : DROP INDEX ifexists fullname ;
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

cmd : createkw trigger_decl BEGIN trigger_cmd_list END ;

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

trigger_cmd : UPDATE orconf trnm tridxby SET setlist from where_opt scanpt ;
trigger_cmd : scanpt insert_cmd INTO trnm idlist_opt select upsert scanpt ;
trigger_cmd : DELETE FROM trnm tridxby where_opt scanpt ;
trigger_cmd : scanpt select scanpt ;

expr : RAISE LP IGNORE RP ;
expr : RAISE LP raisetype COMMA nm RP ;

raisetype : ROLLBACK ;
raisetype : ABORT ;
raisetype : FAIL ;

cmd : DROP TRIGGER ifexists fullname ;
cmd : ATTACH database_kw_opt expr AS expr key_opt ;
cmd : DETACH database_kw_opt expr ;

key_opt : /*empty*/ ;
key_opt : KEY expr ;

database_kw_opt : DATABASE ;
database_kw_opt : /*empty*/ ;

cmd : REINDEX ;
cmd : REINDEX nm dbnm ;
cmd : ANALYZE ;
cmd : ANALYZE nm dbnm ;
cmd : ALTER TABLE fullname RENAME TO nm ;
cmd : ALTER TABLE add_column_fullname ADD kwcolumn_opt columnname carglist ;
cmd : ALTER TABLE fullname DROP kwcolumn_opt nm ;

add_column_fullname : fullname ;

cmd : ALTER TABLE fullname RENAME kwcolumn_opt nm TO nm ;

kwcolumn_opt : /*empty*/ ;
kwcolumn_opt : COLUMNKW ;

cmd : create_vtab ;
cmd : create_vtab LP vtabarglist RP ;

create_vtab : createkw VIRTUAL TABLE ifnotexists nm dbnm USING nm ;

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

wqas : AS ;
wqas : AS MATERIALIZED ;
wqas : AS NOT /*3R*/ MATERIALIZED %prec NOT /*3R*/ ;

wqitem : nm eidlist_opt wqas LP select RP ;

wqlist : wqitem ;
wqlist : wqlist COMMA wqitem ;

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

filter_over : filter_clause over_clause ;
filter_over : over_clause ;
filter_over : filter_clause ;

over_clause : OVER LP window RP ;
over_clause : OVER nm ;

filter_clause : FILTER LP WHERE expr RP ;

ANY : ID ;

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
ALL	ALL
ALTER	ALTER
ALWAYS	ALWAYS
ANALYZE	ANALYZE
AND	AND
AS	AS
ASC	ASC
ATTACH	ATTACH
AUTOINCREMENT	AUTOINCR
BEFORE	BEFORE
BEGIN	BEGIN
BETWEEN	BETWEEN
"&"	BITAND
"~"	BITNOT
"|"	BITOR
BLOB	BLOB
BY	BY
CASCADE	CASCADE
CASE	CASE
CAST	CAST
CHECK	CHECK
COLLATE	COLLATE
COLUMN	COLUMNKW
","	COMMA
COMMIT	COMMIT
"||"	CONCAT
CONFLICT	CONFLICT
CONSTRAINT	CONSTRAINT
CREATE	CREATE
"CURRENT_DATE"|"CURRENT_TIME"|"CURRENT_TIMESTAMP"	CTIME_KW
CURRENT	CURRENT
DATABASE	DATABASE
DEFAULT	DEFAULT
DEFERRABLE	DEFERRABLE
DEFERRED	DEFERRED
DELETE	DELETE
DESC	DESC
DETACH	DETACH
DISTINCT	DISTINCT
DO	DO
"."	DOT
DROP	DROP
EACH	EACH
ELSE	ELSE
END	END
"="	EQ
ESCAPE	ESCAPE
EXCEPT	EXCEPT
EXCLUDE	EXCLUDE
EXCLUSIVE	EXCLUSIVE
EXISTS	EXISTS
EXPLAIN	EXPLAIN
FAIL	FAIL
FILTER	FILTER
FIRST	FIRST
FOLLOWING	FOLLOWING
FOR	FOR
FOREIGN	FOREIGN
FROM	FROM
">="	GE
GENERATED	GENERATED
GROUP	GROUP
GROUPS	GROUPS
">"	GT
HAVING	HAVING
IF	IF
IGNORE	IGNORE
IMMEDIATE	IMMEDIATE
IN	IN
INDEX	INDEX
INDEXED	INDEXED
INITIALLY	INITIALLY
INSERT	INSERT
INSTEAD	INSTEAD
INTERSECT	INTERSECT
INTO	INTO
IS	IS
ISNULL	ISNULL
JOIN	JOIN
CROSS|FULL|INNER|LEFT|NATURAL|OUTER|RIGHT	JOIN_KW
KEY	KEY
LAST	LAST
"<="	LE
LIKE|GLOB|REGEXP	LIKE_KW
LIMIT	LIMIT
"("	LP
"<<"	LSHIFT
"<"	LT
MATCH	MATCH
MATERIALIZED	MATERIALIZED
"-"	MINUS
"<>"|"!="	NE
NO	NO
NOT	NOT
NOTHING	NOTHING
NOTNULL	NOTNULL
NULL	NULL
NULLS	NULLS
OF	OF
OFFSET	OFFSET
ON	ON
OR	OR
ORDER	ORDER
OTHERS	OTHERS
OVER	OVER
PARTITION	PARTITION
PLAN	PLAN
"+"	PLUS
PRAGMA	PRAGMA
PRECEDING	PRECEDING
PRIMARY	PRIMARY
"->"	PTR
QUERY	QUERY
RAISE	RAISE
RANGE	RANGE
RECURSIVE	RECURSIVE
REFERENCES	REFERENCES
REINDEX	REINDEX
RELEASE	RELEASE
"%"	REM
RENAME	RENAME
REPLACE	REPLACE
RESTRICT	RESTRICT
RETURNING	RETURNING
ROLLBACK	ROLLBACK
ROW	ROW
ROWS	ROWS
")"	RP
">>"	RSHIFT
SAVEPOINT	SAVEPOINT
SELECT	SELECT
";"	SEMI
SET	SET
"/"	SLASH
"*"	STAR
TABLE	TABLE
TEMP	TEMP
THEN	THEN
TIES	TIES
TO	TO
TRANSACTION	TRANSACTION
TRIGGER	TRIGGER
UNBOUNDED	UNBOUNDED
UNION	UNION
UNIQUE	UNIQUE
UPDATE	UPDATE
USING	USING
VACUUM	VACUUM
VALUES	VALUES
VARIABLE	VARIABLE
VIEW	VIEW
VIRTUAL	VIRTUAL
WHEN	WHEN
WHERE	WHERE
WINDOW	WINDOW
WITH	WITH
WITHOUT	WITHOUT

([0-9]+\.[0-9]*|\.[0-9]+)([Ee](\+|\-)?[0-9]+)?	FLOAT
[0-9]+	INTEGER
'(''|[^'\n])*'	STRING
/* Order matter if identifier comes before keywords they are classified as identifier */
{BASE_ID}|\"{BASE_ID}\"	ID

%%
