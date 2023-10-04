//From: https://github.com/tarantool/tarantool/blob/f1b238960c7b094241fb260b50f22ca4ca525504/src/box/sql/parse.y

%token  SEMI EXPLAIN QUERY PLAN OR AND
%token  NOT IS MATCH LIKE_KW BETWEEN IN
%token  NE EQ GT LE LT GE
%token  ESCAPE BITAND BITOR LSHIFT RSHIFT PLUS
%token  MINUS STAR SLASH REM CONCAT COLLATE
%token  BITNOT START TRANSACTION COMMIT ROLLBACK SAVEPOINT
%token  RELEASE TO TABLE CREATE IF EXISTS
%token  LP RP WITH ENGINE STRING COMMA
%token  ID INDEXED ABORT ACTION ADD AFTER
%token  BEFORE CASCADE CONFLICT DEFERRED END
%token  FAIL IGNORE INITIALLY INSTEAD NO KEY
%token  OFFSET RAISE REPLACE RESTRICT RENAME
%token  ENABLE DISABLE UUID CONSTRAINT DEFAULT
%token  NULL PRIMARY UNIQUE CHECK REFERENCES AUTOINCR
%token  ON UPDATE DELETE SIMPLE PARTIAL FULL
%token  SET DEFERRABLE IMMEDIATE FOREIGN DROP VIEW
%token  AS UNION ALL EXCEPT INTERSECT SELECT
%token  VALUES DISTINCT DOT FROM JOIN_KW JOIN
%token  BY USING ORDER ASC DESC GROUP
%token  HAVING LIMIT TRUNCATE WHERE INTO INSERT
%token  FLOAT BLOB FALSE TRUE UNKNOWN INTEGER
%token  VARIABLE CAST TRIM LEADING TRAILING BOTH
%token  CHAR CASE WHEN THEN ELSE INDEX
%token  SESSION PRAGMA BEGIN TRIGGER OF FOR
%token  EACH ROW ALTER COLUMN RECURSIVE TEXT
%token  STRING_KW SCALAR BOOL BOOLEAN VARBINARY VARCHAR
%token  NUMBER DOUBLE INT INTEGER_KW UNSIGNED

%left /*1*/ OR
%left /*2*/ AND
%right /*3*/ NOT
%left /*4*/ IS MATCH LIKE_KW BETWEEN IN NE EQ
%left /*5*/ GT LE LT GE
%right /*6*/ ESCAPE
%left /*7*/ BITAND BITOR LSHIFT RSHIFT
%left /*8*/ PLUS MINUS
%left /*9*/ STAR SLASH REM
%left /*10*/ CONCAT
%left /*11*/ COLLATE
%right /*12*/ BITNOT

%start input

%%

input : cmdlist ;

cmdlist : cmdlist ecmd ;
cmdlist : ecmd ;

ecmd : explain cmdx SEMI ;
ecmd : SEMI ;

explain : /*empty*/ ;
explain : EXPLAIN ;
explain : EXPLAIN QUERY PLAN ;

cmdx : cmd ;

cmd : START TRANSACTION ;
cmd : COMMIT ;
cmd : ROLLBACK ;

savepoint_opt : SAVEPOINT ;
savepoint_opt : /*empty*/ ;

cmd : SAVEPOINT nm ;
cmd : RELEASE savepoint_opt nm ;
cmd : ROLLBACK TO savepoint_opt nm ;
cmd : create_table create_table_args with_opts create_table_end ;

create_table : createkw TABLE ifnotexists nm ;

createkw : CREATE ;

ifnotexists : /*empty*/ ;
ifnotexists : IF NOT /*3R*/ EXISTS %prec NOT /*3R*/ ;

create_table_args : LP columnlist RP ;

with_opts : WITH engine_opts ;
with_opts : /*empty*/ ;

engine_opts : ENGINE EQ /*4L*/ STRING %prec EQ /*4L*/ ;

create_table_end : /*empty*/ ;

columnlist : columnlist COMMA tcons ;
columnlist : columnlist COMMA column_def create_column_end ;
columnlist : column_def create_column_end ;

column_def : column_name_and_type carglist ;

column_name_and_type : nm typedef ;

create_column_end : autoinc ;

columnlist : tcons ;

nm : ID ;
nm : INDEXED ;

carglist : carglist ccons ;
carglist : /*empty*/ ;

cconsname : CONSTRAINT nm ;
cconsname : /*empty*/ ;

ccons : DEFAULT term ;
ccons : DEFAULT LP expr RP ;
ccons : DEFAULT PLUS /*8L*/ term %prec PLUS /*8L*/ ;
ccons : DEFAULT MINUS /*8L*/ term %prec MINUS /*8L*/ ;
ccons : NULL onconf ;
ccons : NOT /*3R*/ NULL onconf %prec NOT /*3R*/ ;
ccons : cconsname PRIMARY KEY sortorder ;
ccons : cconsname UNIQUE ;
ccons : check_constraint_def ;

check_constraint_def : cconsname CHECK LP expr RP ;

ccons : cconsname REFERENCES nm eidlist_opt matcharg refargs ;
ccons : defer_subclause ;
ccons : COLLATE /*11L*/ ID %prec COLLATE /*11L*/ ;
ccons : COLLATE /*11L*/ INDEXED %prec COLLATE /*11L*/ ;

autoinc : /*empty*/ ;
autoinc : AUTOINCR ;

refargs : refact_update ;
refargs : refact_delete ;
refargs : refact_delete refact_update ;
refargs : refact_update refact_delete ;
refargs : /*empty*/ ;

refact_update : ON UPDATE refact ;

refact_delete : ON DELETE refact ;

matcharg : MATCH /*4L*/ SIMPLE %prec MATCH /*4L*/ ;
matcharg : MATCH /*4L*/ PARTIAL %prec MATCH /*4L*/ ;
matcharg : MATCH /*4L*/ FULL %prec MATCH /*4L*/ ;
matcharg : /*empty*/ ;

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

tcons : cconsname PRIMARY KEY LP col_list_with_autoinc RP ;
tcons : cconsname UNIQUE LP sortlist RP ;
tcons : check_constraint_def ;
tcons : cconsname FOREIGN KEY LP eidlist RP REFERENCES nm eidlist_opt matcharg refargs defer_subclause_opt ;

defer_subclause_opt : /*empty*/ ;
defer_subclause_opt : defer_subclause ;

onconf : /*empty*/ ;
onconf : ON CONFLICT resolvetype ;

orconf : /*empty*/ ;
orconf : OR /*1L*/ resolvetype %prec OR /*1L*/ ;

resolvetype : raisetype ;
resolvetype : IGNORE ;
resolvetype : REPLACE ;

cmd : DROP TABLE ifexists fullname ;
cmd : DROP VIEW ifexists fullname ;

ifexists : IF EXISTS ;
ifexists : /*empty*/ ;

cmd : createkw VIEW ifnotexists nm eidlist_opt AS select ;
cmd : select ;

select : with selectnowith ;

selectnowith : oneselect ;
selectnowith : selectnowith multiselect_op oneselect ;

multiselect_op : UNION ;
multiselect_op : UNION ALL ;
multiselect_op : EXCEPT ;
multiselect_op : INTERSECT ;

oneselect : SELECT distinct selcollist from where_opt groupby_opt having_opt orderby_opt limit_opt ;
oneselect : values ;

values : VALUES LP nexprlist RP ;
values : values COMMA LP exprlist RP ;

distinct : DISTINCT ;
distinct : ALL ;
distinct : /*empty*/ ;

sclp : selcollist COMMA ;
sclp : /*empty*/ ;

selcollist : sclp expr as ;
selcollist : sclp STAR /*9L*/ %prec STAR /*9L*/ ;
selcollist : sclp nm DOT STAR /*9L*/ %prec STAR /*9L*/ ;

as : AS nm ;
as : ID ;
as : STRING ;
as : /*empty*/ ;

from : /*empty*/ ;
from : FROM seltablist ;

stl_prefix : seltablist joinop ;
stl_prefix : /*empty*/ ;

seltablist : stl_prefix nm as indexed_opt on_opt using_opt ;
seltablist : stl_prefix nm LP exprlist RP as on_opt using_opt ;
seltablist : stl_prefix LP select RP as on_opt using_opt ;
seltablist : stl_prefix LP seltablist RP as on_opt using_opt ;

fullname : nm ;

join_nm : ID ;
join_nm : INDEXED ;
join_nm : JOIN_KW ;

joinop : COMMA ;
joinop : JOIN ;
joinop : JOIN_KW JOIN ;
joinop : JOIN_KW join_nm JOIN ;
joinop : JOIN_KW join_nm join_nm JOIN ;

on_opt : ON expr ;
on_opt : /*empty*/ ;

indexed_opt : /*empty*/ ;
indexed_opt : INDEXED BY nm ;
indexed_opt : NOT /*3R*/ INDEXED %prec NOT /*3R*/ ;

using_opt : USING LP idlist RP ;
using_opt : /*empty*/ ;

orderby_opt : /*empty*/ ;
orderby_opt : ORDER BY sortlist ;

sortlist : sortlist COMMA expr sortorder ;
sortlist : expr sortorder ;

col_list_with_autoinc : col_list_with_autoinc COMMA expr autoinc ;
col_list_with_autoinc : expr autoinc ;

enable : ENABLE ;
enable : DISABLE ;

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

cmd : with DELETE FROM fullname indexed_opt where_opt ;
cmd : TRUNCATE TABLE fullname ;

where_opt : /*empty*/ ;
where_opt : WHERE expr ;

cmd : with UPDATE orconf fullname indexed_opt SET setlist where_opt ;

setlist : setlist COMMA nm EQ /*4L*/ expr %prec EQ /*4L*/ ;
setlist : setlist COMMA LP idlist RP EQ /*4L*/ expr %prec EQ /*4L*/ ;
setlist : nm EQ /*4L*/ expr %prec EQ /*4L*/ ;
setlist : LP idlist RP EQ /*4L*/ expr %prec EQ /*4L*/ ;

cmd : with insert_cmd INTO fullname idlist_opt select ;
cmd : with insert_cmd INTO fullname idlist_opt DEFAULT VALUES ;

insert_cmd : INSERT orconf ;
insert_cmd : REPLACE ;

idlist_opt : /*empty*/ ;
idlist_opt : LP idlist RP ;

idlist : idlist COMMA nm ;
idlist : nm ;

expr : term ;
expr : LP expr RP ;

term : NULL ;

expr : ID ;
expr : INDEXED ;
expr : JOIN_KW ;
expr : nm DOT nm ;

term : FLOAT ;
term : BLOB ;
term : STRING ;
term : FALSE ;
term : TRUE ;
term : UNKNOWN ;
term : INTEGER ;

expr : VARIABLE ;
expr : expr COLLATE /*11L*/ ID %prec COLLATE /*11L*/ ;
expr : expr COLLATE /*11L*/ INDEXED %prec COLLATE /*11L*/ ;
expr : CAST LP expr AS typedef RP ;
expr : TRIM LP trim_operands RP ;

trim_operands : trim_from_clause expr ;
trim_operands : expr ;

trim_from_clause : expr FROM ;
trim_from_clause : trim_specification expr_optional FROM ;

expr_optional : /*empty*/ ;
expr_optional : expr ;

trim_specification : LEADING ;
trim_specification : TRAILING ;
trim_specification : BOTH ;

expr : ID LP distinct exprlist RP ;
expr : INDEXED LP distinct exprlist RP ;

type_func : CHAR ;

expr : type_func LP distinct exprlist RP ;
expr : ID LP STAR /*9L*/ RP %prec STAR /*9L*/ ;
expr : INDEXED LP STAR /*9L*/ RP %prec STAR /*9L*/ ;
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
expr : expr IS /*4L*/ NULL %prec IS /*4L*/ ;
expr : expr IS /*4L*/ NOT /*3R*/ NULL %prec IS /*4L*/ ;
expr : NOT /*3R*/ expr %prec NOT /*3R*/ ;
expr : BITNOT /*12R*/ expr %prec BITNOT /*12R*/ ;
expr : MINUS /*8L*/ expr %prec BITNOT /*12R*/ ;
expr : PLUS /*8L*/ expr %prec BITNOT /*12R*/ ;

between_op : BETWEEN /*4L*/ %prec BETWEEN /*4L*/ ;
between_op : NOT /*3R*/ BETWEEN /*4L*/ %prec NOT /*3R*/ ;

expr : expr between_op expr AND /*2L*/ expr %prec BETWEEN /*4L*/ ;

in_op : IN /*4L*/ %prec IN /*4L*/ ;
in_op : NOT /*3R*/ IN /*4L*/ %prec NOT /*3R*/ ;

expr : expr in_op LP exprlist RP %prec IN /*4L*/ ;
expr : LP select RP ;
expr : expr in_op LP select RP %prec IN /*4L*/ ;
expr : expr in_op nm paren_exprlist %prec IN /*4L*/ ;
expr : EXISTS LP select RP ;
expr : CASE expr_optional case_exprlist case_else END ;

case_exprlist : case_exprlist WHEN expr THEN expr ;
case_exprlist : WHEN expr THEN expr ;

case_else : ELSE expr ;
case_else : /*empty*/ ;

exprlist : nexprlist ;
exprlist : /*empty*/ ;

nexprlist : nexprlist COMMA expr ;
nexprlist : expr ;

paren_exprlist : /*empty*/ ;
paren_exprlist : LP exprlist RP ;

cmd : createkw uniqueflag INDEX ifnotexists nm ON nm LP sortlist RP ;

uniqueflag : UNIQUE ;
uniqueflag : /*empty*/ ;

eidlist_opt : /*empty*/ ;
eidlist_opt : LP eidlist RP ;

eidlist : eidlist COMMA nm ;
eidlist : nm ;

cmd : DROP INDEX ifexists nm ON fullname ;
cmd : SET SESSION nm EQ /*4L*/ term %prec EQ /*4L*/ ;
cmd : PRAGMA nm ;
cmd : PRAGMA nm LP nm RP ;
cmd : PRAGMA nm LP nm DOT nm RP ;
cmd : createkw trigger_decl BEGIN trigger_cmd_list END ;

trigger_decl : TRIGGER ifnotexists nm trigger_time trigger_event ON fullname foreach_clause when_clause ;

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

trigger_cmd : UPDATE orconf trnm tridxby SET setlist where_opt ;
trigger_cmd : insert_cmd INTO trnm idlist_opt select ;
trigger_cmd : DELETE FROM trnm tridxby where_opt ;
trigger_cmd : select ;

expr : RAISE LP IGNORE RP ;
expr : RAISE LP raisetype COMMA STRING RP ;

raisetype : ROLLBACK ;
raisetype : ABORT ;
raisetype : FAIL ;

cmd : DROP TRIGGER ifexists fullname ;

alter_table_start : ALTER TABLE fullname ;

alter_add_constraint : alter_table_start ADD CONSTRAINT nm ;

alter_add_column : alter_table_start ADD column_name ;

column_name : COLUMN nm ;
column_name : nm ;

cmd : alter_column_def carglist create_column_end ;

alter_column_def : alter_add_column typedef ;

cmd : alter_add_constraint FOREIGN KEY LP eidlist RP REFERENCES nm eidlist_opt matcharg refargs defer_subclause_opt ;
cmd : alter_add_constraint CHECK LP expr RP ;
cmd : alter_add_constraint unique_spec LP sortlist RP ;

unique_spec : UNIQUE ;
unique_spec : PRIMARY KEY ;

cmd : alter_table_start RENAME TO nm ;
cmd : ALTER TABLE fullname DROP CONSTRAINT nm ;
cmd : alter_table_start enable CHECK CONSTRAINT nm ;

with : /*empty*/ ;
with : WITH wqlist ;
with : WITH RECURSIVE wqlist ;

wqlist : nm eidlist_opt AS LP select RP ;
wqlist : wqlist COMMA nm eidlist_opt AS LP select RP ;

typedef : TEXT ;
typedef : STRING_KW ;
typedef : SCALAR ;
typedef : BOOL ;
typedef : BOOLEAN ;
typedef : VARBINARY ;
typedef : UUID ;

char_len : LP INTEGER RP ;

typedef : VARCHAR char_len ;
typedef : number_typedef ;

number_typedef : NUMBER ;
number_typedef : DOUBLE ;
number_typedef : INT ;
number_typedef : INTEGER_KW ;
number_typedef : UNSIGNED ;

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
AND	AND
AS	AS
ASC	ASC
AUTOINCREMENT	AUTOINCR
BEFORE	BEFORE
BEGIN	BEGIN
BETWEEN	BETWEEN
"&"	BITAND
"~"	BITNOT
"|"	BITOR
BLOB	BLOB
BOOL	BOOL
BOOLEAN	BOOLEAN
BOTH	BOTH
BY	BY
CASCADE	CASCADE
CASE	CASE
CAST	CAST
CHAR	CHAR
CHECK	CHECK
COLLATE	COLLATE
COLUMN	COLUMN
","	COMMA
COMMIT	COMMIT
"||"	CONCAT
CONFLICT	CONFLICT
CONSTRAINT	CONSTRAINT
CREATE	CREATE
DEFAULT	DEFAULT
DEFERRABLE	DEFERRABLE
DEFERRED	DEFERRED
DELETE	DELETE
DESC	DESC
DISABLE	DISABLE
DISTINCT	DISTINCT
"."	DOT
DOUBLE	DOUBLE
DROP	DROP
EACH	EACH
ELSE	ELSE
ENABLE	ENABLE
END	END
ENGINE	ENGINE
"="	EQ
ESCAPE	ESCAPE
EXCEPT	EXCEPT
EXISTS	EXISTS
EXPLAIN	EXPLAIN
FAIL	FAIL
FALSE	FALSE
FOR	FOR
FOREIGN	FOREIGN
FROM	FROM
FULL	FULL
">="	GE
GROUP	GROUP
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
INT	INT
INTEGER	INTEGER_KW
INTERSECT	INTERSECT
INTO	INTO
IS	IS
JOIN	JOIN
CROSS|INNER|LEFT|NATURAL|OUTER|RIGHT	JOIN_KW
KEY	KEY
"<="	LE
LEADING	LEADING
LIKE|REGEXP	LIKE_KW
LIMIT	LIMIT
"("	LP
"<<"	LSHIFT
"<"	LT
MATCH	MATCH
"-"	MINUS
"<>"|"!="	NE
NO	NO
NOT	NOT
NULL	NULL
NUMBER	NUMBER
OF	OF
OFFSET	OFFSET
ON	ON
OR	OR
ORDER	ORDER
PARTIAL	PARTIAL
PLAN	PLAN
"+"	PLUS
PRAGMA	PRAGMA
PRIMARY	PRIMARY
QUERY	QUERY
RAISE	RAISE
RECURSIVE	RECURSIVE
REFERENCES	REFERENCES
RELEASE	RELEASE
"%"	REM
RENAME	RENAME
REPLACE	REPLACE
RESTRICT	RESTRICT
ROLLBACK	ROLLBACK
ROW	ROW
")"	RP
">>"	RSHIFT
SAVEPOINT	SAVEPOINT
SCALAR	SCALAR
SELECT	SELECT
";"	SEMI
SESSION	SESSION
SET	SET
SIMPLE	SIMPLE
"/"	SLASH
"*"	STAR
START	START
STRING	STRING_KW
TABLE	TABLE
TEXT	TEXT
THEN	THEN
TO	TO
TRAILING	TRAILING
TRANSACTION	TRANSACTION
TRIGGER	TRIGGER
TRIM	TRIM
TRUE	TRUE
TRUNCATE	TRUNCATE
UNION	UNION
UNIQUE	UNIQUE
UNKNOWN	UNKNOWN
UNSIGNED	UNSIGNED
UPDATE	UPDATE
USING	USING
UUID	UUID
VALUES	VALUES
VARBINARY	VARBINARY
VARCHAR	VARCHAR
VARIABLE	VARIABLE
VIEW	VIEW
WHEN	WHEN
WHERE	WHERE
WITH	WITH

([0-9]+\.[0-9]*|\.[0-9]+)([Ee](\+|\-)?[0-9]+)?	FLOAT
[0-9]+	INTEGER
'(''|[^'\n])*'	STRING
/* Order matter if identifier comes before keywords they are classified as identifier */
{BASE_ID}|\"{BASE_ID}\"	ID

%%
