//From: https://github.com/probcomp/bayeslite/blob/211e5eb3821a464a2fffeb9d35e3097e1b7a99ba/src/grammar.y
/*
 *  Copyright (c) 2010-2016, MIT Probabilistic Computing Project
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

%token  T_SEMI K_BEGIN K_ROLLBACK K_COMMIT K_CREATE K_TABLE
%token  K_AS K_FROM K_DROP K_ALTER T_COMMA K_RENAME
%token  K_TO K_COLUMN L_STRING K_GUESS K_SCHEMA K_FOR
%token  K_POPULATION T_LROUND T_LCURLY T_RROUND T_RCURLY K_WITH
%token  K_SET K_STATTYPES K_STATTYPE K_OF K_ADD K_VARIABLE
%token  K_IGNORE L_NAME T_STAR K_GENERATOR K_USING //ANY
%token  K_INITIALIZE L_INTEGER K_ANALYZE K_TEMP K_TEMPORARY K_IF
%token  K_EXISTS K_NOT T_MINUS K_OR K_CHECKPOINT K_ITERATION
%token  K_ITERATIONS K_MINUTE K_MINUTES K_SECOND K_SECONDS K_REGRESS
%token  K_GIVEN K_BY K_WITHIN K_SELECT K_ESTIMATE K_COLUMNS
%token  K_PAIRWISE K_INFER K_EXPLICIT K_CONFIDENCE K_PREDICT //K_ROW
%token  K_SIMULATE T_EQ K_MODELS K_DISTINCT K_ALL T_DOT
%token  K_VARIABLES K_MODELED K_MODELLED K_WHERE K_MODEL K_GROUP
%token  K_HAVING K_ORDER K_ASC K_DESC K_ACCURACY K_LIMIT
%token  K_OFFSET K_AND K_IS K_LIKE K_ESCAPE K_GLOB
%token  K_REGEXP K_MATCH K_BETWEEN K_IN K_ISNULL K_NOTNULL
%token  T_NEQ T_LT T_LEQ T_GEQ T_GT T_BITAND
%token  T_BITOR T_LSHIFT T_RSHIFT T_PLUS T_SLASH T_PERCENT
%token  T_CONCAT K_COLLATE T_BITNOT K_PREDICTIVE K_PROBABILITY K_DENSITY
%token  K_VALUE K_SIMILARITY K_RELEVANCE K_DEPENDENCE K_MUTUAL K_INFORMATION
%token  K_EXISTING K_ROWS K_HYPOTHETICAL K_VALUES K_CORRELATION K_PVALUE
%token  K_THE K_CONTEXT K_SAMPLES L_NUMPAR L_NAMPAR K_CAST
%token  K_CASE K_END K_WHEN K_THEN K_ELSE K_NULL
%token  L_FLOAT //K_BTABLE K_CONF K_DEFAULT K_LATENT K_UNSET



%start bql

%%

bql : phrases ;

phrases : /*empty*/ ;
phrases : phrases phrase_opt T_SEMI ;

phrase_opt : /*empty*/ ;
phrase_opt : phrase ;

phrase : command ;
phrase : query ;

command : K_BEGIN ;
command : K_ROLLBACK ;
command : K_COMMIT ;
command : K_CREATE temp_opt K_TABLE ifnotexists table_name K_AS query ;
command : K_CREATE temp_opt K_TABLE ifnotexists table_name K_FROM pathname ;
command : K_DROP K_TABLE ifexists table_name ;
command : K_ALTER K_TABLE table_name altertab_cmds ;

altertab_cmds : altertab_cmd ;
altertab_cmds : altertab_cmds T_COMMA altertab_cmd ;

altertab_cmd : K_RENAME K_TO table_name ;
altertab_cmd : K_RENAME k_column_opt column_name K_TO column_name ;

k_column_opt : /*empty*/ ;
k_column_opt : K_COLUMN ;

pathname : L_STRING ;

command : K_GUESS K_SCHEMA K_FOR table_name ;
command : K_CREATE K_POPULATION ifnotexists population_name K_FOR table_name with_schema_opt T_LROUND pop_schema T_RROUND ;
command : K_CREATE K_POPULATION ifnotexists population_name K_FOR table_name with_schema_opt T_LCURLY pop_schema T_RCURLY ;
command : K_CREATE K_POPULATION ifnotexists K_FOR table_name with_schema_opt T_LROUND pop_schema T_RROUND ;
command : K_CREATE K_POPULATION ifnotexists K_FOR table_name with_schema_opt T_LCURLY pop_schema T_RCURLY ;
command : K_DROP K_POPULATION ifexists population_name ;

with_schema_opt : /*empty*/ ;
with_schema_opt : K_WITH K_SCHEMA ;

command : K_ALTER K_POPULATION population_name alterpop_cmds ;

alterpop_cmds : alterpop_cmd ;
alterpop_cmds : alterpop_cmds T_COMMA alterpop_cmd ;

alterpop_cmd : K_RENAME K_TO population_name ;
alterpop_cmd : K_SET K_STATTYPES K_OF pop_columns K_TO stattype ;
alterpop_cmd : K_SET K_STATTYPE K_OF pop_columns K_TO stattype ;
alterpop_cmd : K_ADD K_VARIABLE column_name stattype_opt ;

pop_schema : pop_clause ;
pop_schema : pop_schema T_SEMI pop_clause ;

pop_clause : /*empty*/ ;
pop_clause : column_name stattype ;
pop_clause : K_SET K_STATTYPES K_OF pop_columns K_TO stattype ;
pop_clause : K_SET K_STATTYPE K_OF pop_columns K_TO stattype ;
pop_clause : K_IGNORE pop_columns ;
pop_clause : K_GUESS stattypes_of_opt pop_columns_guess ;

stattype_opt : /*empty*/ ;
stattype_opt : stattype ;

stattype : L_NAME ;

pop_columns_guess : T_LROUND T_STAR T_RROUND ;
pop_columns_guess : pop_columns ;

pop_columns : column_name ;
pop_columns : pop_columns T_COMMA column_name ;

stattypes_of_opt : /*empty*/ ;
stattypes_of_opt : K_STATTYPE K_OF ;
stattypes_of_opt : K_STATTYPES K_OF ;

command : K_CREATE K_GENERATOR ifnotexists generator_name K_FOR population_name backend_name_opt generator_schema_opt ;
command : K_CREATE K_GENERATOR ifnotexists K_FOR population_name backend_name_opt generator_schema_opt ;
command : K_DROP K_GENERATOR ifexists generator_name ;
command : K_ALTER K_GENERATOR generator_name anmodelset_matched_opt altergen_cmds ;

altergen_cmds : altergen_cmd ;
altergen_cmds : altergen_cmds T_COMMA altergen_cmd ;

altergen_cmd : K_RENAME K_TO generator_name ;
altergen_cmd : generator_schemum ;

backend_name_opt : /*empty*/ ;
backend_name_opt : K_USING backend_name ;

generator_schema_opt : /*empty*/ ;
generator_schema_opt : T_LROUND generator_schema T_RROUND ;
generator_schema_opt : T_LCURLY generator_schema T_RCURLY ;

generator_schema : generator_schemum ;
generator_schema : generator_schema T_COMMA generator_schemum ;

generator_schemum : /*empty*/ ;
generator_schemum : generator_schemum gs_token ;

gs_token : T_LROUND generator_schemum T_RROUND ;
gs_token : ANY ;

command : K_INITIALIZE L_INTEGER model_token ifnotexists K_FOR generator_name ;
command : K_ANALYZE generator_name anmodelset_opt anlimit anckpt_opt analysis_program_opt ;
command : K_DROP model_token modelset_opt K_FROM generator_name ;

temp_opt : /*empty*/ ;
temp_opt : K_TEMP ;
temp_opt : K_TEMPORARY ;

ifexists : /*empty*/ ;
ifexists : K_IF K_EXISTS ;

ifnotexists : /*empty*/ ;
ifnotexists : K_IF K_NOT K_EXISTS ;

anmodelset_opt : /*empty*/ ;
anmodelset_opt : model_token modelset ;

anmodelset_matched_opt : /*empty*/ ;
anmodelset_matched_opt : model_token T_LROUND modelset T_RROUND ;

modelset_opt : /*empty*/ ;
modelset_opt : modelset ;

modelset : modelrange ;
modelset : modelset T_COMMA modelrange ;

modelrange : L_INTEGER ;
modelrange : L_INTEGER T_MINUS L_INTEGER ;

anlimit : K_FOR anduration ;
anlimit : K_FOR anduration K_OR anduration ;

anckpt_opt : /*empty*/ ;
anckpt_opt : K_CHECKPOINT anduration ;

anduration : L_INTEGER K_ITERATION ;
anduration : L_INTEGER K_ITERATIONS ;
anduration : L_INTEGER K_MINUTE ;
anduration : L_INTEGER K_MINUTES ;
anduration : L_INTEGER K_SECOND ;
anduration : L_INTEGER K_SECONDS ;

analysis_program_opt : /*empty*/ ;
analysis_program_opt : T_LROUND analysis_program T_RROUND ;

analysis_program : /*empty*/ ;
analysis_program : analysis_program analysis_token ;

analysis_token : T_LROUND analysis_program T_RROUND ;
analysis_token : ANY ;

command : K_REGRESS column_name K_GIVEN T_LROUND select_columns T_RROUND nsamples_opt K_BY population_name modeledby_opt usingmodel_opt ;
command : K_REGRESS column_name K_GIVEN T_LROUND select_columns T_RROUND nsamples_opt K_WITHIN population_name modeledby_opt usingmodel_opt ;

query : select ;
query : estimate ;
query : estby ;
//query : estcol ;
//query : estpairrow ;
//query : estpaircol ;
query : infer ;
query : simulate ;

select : K_SELECT select_quant select_columns from_sel_opt where group_by order_by limit_opt ;

estimate : K_ESTIMATE select_quant select_columns from_est modeledby_opt usingmodel_opt where group_by order_by limit_opt ;

//estcol : K_ESTIMATE K_COLUMNS error T_SEMI ;

//estpairrow : K_ESTIMATE K_PAIRWISE K_ROW error T_SEMI ;

//estpaircol : K_ESTIMATE K_PAIRWISE error T_SEMI ;

estby : K_ESTIMATE select_quant select_columns K_BY population_name modeledby_opt usingmodel_opt ;
estby : K_ESTIMATE select_quant select_columns K_WITHIN population_name modeledby_opt usingmodel_opt ;

infer : K_INFER infer_auto_columns withconf_opt nsamples_opt K_FROM population_name modeledby_opt usingmodel_opt where group_by order_by limit_opt ;
infer : K_INFER K_EXPLICIT infer_exp_columns K_FROM population_name modeledby_opt usingmodel_opt where group_by order_by limit_opt ;

infer_auto_columns : infer_auto_column ;
infer_auto_columns : infer_auto_columns T_COMMA infer_auto_column ;

infer_auto_column : T_STAR ;
infer_auto_column : column_name as ;

withconf_opt : /*empty*/ ;
withconf_opt : withconf ;

withconf : K_WITH K_CONFIDENCE primary ;

infer_exp_columns : infer_exp_column ;
infer_exp_columns : infer_exp_columns T_COMMA infer_exp_column ;

infer_exp_column : select_column ;
infer_exp_column : K_PREDICT column_name as conf_opt nsamples_opt ;

conf_opt : /*empty*/ ;
conf_opt : K_CONFIDENCE column_name ;

simulate : K_SIMULATE select_columns K_FROM population_name modeledby_opt usingmodel_opt given_opt limit accuracy_opt ;
simulate : K_SIMULATE select_columns K_FROM population_name modeledby_opt usingmodel_opt given_opt ;

given_opt : /*empty*/ ;
given_opt : K_GIVEN constraints ;

constraints : constraint ;
constraints : constraints T_COMMA constraint ;

constraint : column_name T_EQ expression ;

constraints_opt : /*empty*/ ;
constraints_opt : constraints ;

constraints_list : T_LROUND constraints T_RROUND ;
constraints_list : constraints_list T_COMMA T_LROUND constraints T_RROUND ;

simulate : K_SIMULATE select_columns K_FROM K_MODELS K_OF population_name modeledby_opt ;

select_quant : K_DISTINCT ;
select_quant : K_ALL ;
select_quant : /*empty*/ ;

select_columns : select_column ;
select_columns : select_columns T_COMMA select_column ;

select_column : T_STAR ;
select_column : table_name T_DOT T_STAR ;
select_column : table_name T_DOT T_LROUND query T_RROUND ;
select_column : expression as ;

as : /*empty*/ ;
as : K_AS L_NAME ;

from_sel_opt : /*empty*/ ;
from_sel_opt : K_FROM select_tables ;

from_est : K_FROM population_name ;
from_est : K_FROM K_PAIRWISE population_name ;
from_est : K_FROM K_COLUMNS K_OF population_name ;
from_est : K_FROM K_VARIABLES K_OF population_name ;
from_est : K_FROM K_PAIRWISE K_COLUMNS K_OF population_name for ;
from_est : K_FROM K_PAIRWISE K_VARIABLES K_OF population_name for ;

modeledby_opt : /*empty*/ ;
modeledby_opt : K_MODELED K_BY generator_name ;
modeledby_opt : K_MODELLED K_BY generator_name ;

usingmodel_opt : /*empty*/ ;
usingmodel_opt : K_USING model_token modelset ;

select_tables : select_table ;
select_tables : select_tables T_COMMA select_table ;

select_table : table_name as ;
select_table : T_LROUND query T_RROUND as ;

for : /*empty*/ ;
for : K_FOR column_lists ;

where : /*empty*/ ;
where : K_WHERE expression ;

column_name : L_NAME ;

generator_name : L_NAME ;

backend_name : L_NAME ;

population_name : L_NAME ;

table_name : L_NAME ;

model_token : K_MODEL ;
model_token : K_MODELS ;

group_by : /*empty*/ ;
group_by : K_GROUP K_BY expressions ;
group_by : K_GROUP K_BY expressions K_HAVING expression ;

order_by : /*empty*/ ;
order_by : K_ORDER K_BY order_keys ;

order_keys : order_key ;
order_keys : order_keys T_COMMA order_key ;

order_key : expression order_sense ;

order_sense : /*empty*/ ;
order_sense : K_ASC ;
order_sense : K_DESC ;

accuracy_opt : /*empty*/ ;
accuracy_opt : K_ACCURACY L_INTEGER ;

limit_opt : /*empty*/ ;
limit_opt : limit ;

limit : K_LIMIT expression ;
limit : K_LIMIT expression K_OFFSET expression ;
limit : K_LIMIT expression T_COMMA expression ;

expressions_opt : /*empty*/ ;
expressions_opt : expressions ;

expressions : expression ;
expressions : expressions T_COMMA expression ;

expression : boolean_or ;

boolean_or : boolean_or K_OR boolean_and ;
boolean_or : boolean_and ;

boolean_and : boolean_and K_AND boolean_not ;
boolean_and : boolean_not ;

boolean_not : K_NOT boolean_not ;
boolean_not : equality ;

equality : equality K_IS ordering ;
equality : equality K_IS K_NOT ordering ;
equality : equality K_LIKE ordering ;
equality : equality K_NOT K_LIKE ordering ;
equality : equality K_LIKE ordering K_ESCAPE ordering ;
equality : equality K_NOT K_LIKE ordering K_ESCAPE ordering ;
equality : equality K_GLOB ordering ;
equality : equality K_NOT K_GLOB ordering ;
equality : equality K_GLOB ordering K_ESCAPE ordering ;
equality : equality K_NOT K_GLOB ordering K_ESCAPE ordering ;
equality : equality K_REGEXP ordering ;
equality : equality K_NOT K_REGEXP ordering ;
equality : equality K_REGEXP ordering K_ESCAPE ordering ;
equality : equality K_NOT K_REGEXP ordering K_ESCAPE ordering ;
equality : equality K_MATCH ordering ;
equality : equality K_NOT K_MATCH ordering ;
equality : equality K_MATCH ordering K_ESCAPE ordering ;
equality : equality K_NOT K_MATCH ordering K_ESCAPE ordering ;
equality : equality K_BETWEEN ordering K_AND ordering ;
equality : equality K_NOT K_BETWEEN ordering K_AND ordering ;
equality : equality K_IN T_LROUND query T_RROUND ;
equality : equality K_NOT K_IN T_LROUND query T_RROUND ;
equality : equality K_IN T_LROUND expressions_opt T_RROUND ;
equality : equality K_NOT K_IN T_LROUND expressions_opt T_RROUND ;
equality : equality K_ISNULL ;
equality : equality K_NOTNULL ;
equality : equality T_NEQ ordering ;
equality : equality T_EQ ordering ;
equality : ordering ;

ordering : ordering T_LT bitwise ;
ordering : ordering T_LEQ bitwise ;
ordering : ordering T_GEQ bitwise ;
ordering : ordering T_GT bitwise ;
ordering : bitwise ;

bitwise : bitwise T_BITAND additive ;
bitwise : bitwise T_BITOR additive ;
bitwise : bitwise T_LSHIFT additive ;
bitwise : bitwise T_RSHIFT additive ;
bitwise : additive ;

additive : additive T_PLUS multiplicative ;
additive : additive T_MINUS multiplicative ;
additive : multiplicative ;

multiplicative : multiplicative T_STAR concatenative ;
multiplicative : multiplicative T_SLASH concatenative ;
multiplicative : multiplicative T_PERCENT concatenative ;
multiplicative : concatenative ;

concatenative : concatenative T_CONCAT collating ;
concatenative : collating ;

collating : collating K_COLLATE L_NAME ;
collating : collating K_COLLATE L_STRING ;
collating : unary ;

unary : T_BITNOT unary ;
unary : T_MINUS unary ;
unary : T_PLUS unary ;
unary : bqlfn ;

bqlfn : K_PREDICTIVE K_PROBABILITY K_OF column_list ;
bqlfn : K_PREDICTIVE K_PROBABILITY K_OF T_LROUND column_lists T_RROUND ;
bqlfn : K_PREDICTIVE K_PROBABILITY K_OF column_list K_GIVEN T_LROUND column_lists T_RROUND ;
bqlfn : K_PREDICTIVE K_PROBABILITY K_OF T_LROUND column_lists T_RROUND K_GIVEN T_LROUND column_lists T_RROUND ;
bqlfn : K_PROBABILITY K_DENSITY K_OF column_name T_EQ unary ;
bqlfn : K_PROBABILITY K_DENSITY K_OF T_LROUND constraints_opt T_RROUND ;
bqlfn : K_PROBABILITY K_DENSITY K_OF column_name T_EQ primary K_GIVEN T_LROUND constraints_opt T_RROUND ;
bqlfn : K_PROBABILITY K_DENSITY K_OF T_LROUND constraints_opt T_RROUND K_GIVEN T_LROUND constraints_opt T_RROUND ;
bqlfn : K_PROBABILITY K_DENSITY K_OF K_VALUE unary ;
bqlfn : K_PROBABILITY K_DENSITY K_OF K_VALUE primary K_GIVEN T_LROUND constraints_opt T_RROUND ;
bqlfn : K_SIMILARITY K_OF T_LROUND expression T_RROUND K_TO T_LROUND expression T_RROUND wrt ;
bqlfn : K_SIMILARITY K_TO T_LROUND expression T_RROUND wrt ;
bqlfn : K_SIMILARITY wrt ;
bqlfn : K_PREDICTIVE K_RELEVANCE predrel_of_opt K_TO existing_rows wrt ;
bqlfn : K_PREDICTIVE K_RELEVANCE predrel_of_opt K_TO hypothetical_rows wrt ;
bqlfn : K_PREDICTIVE K_RELEVANCE predrel_of_opt K_TO existing_rows K_AND hypothetical_rows wrt ;
bqlfn : K_DEPENDENCE K_PROBABILITY ofwith ;
bqlfn : K_MUTUAL K_INFORMATION ofwithmulti mi_given_opt nsamples_opt ;
bqlfn : K_PROBABILITY K_OF T_LROUND expression T_RROUND ;

predrel_of_opt : /*empty*/ ;
predrel_of_opt : K_OF T_LROUND expression T_RROUND ;

existing_rows : K_EXISTING K_ROWS T_LROUND expression T_RROUND ;

hypothetical_rows : K_HYPOTHETICAL K_ROWS K_WITH K_VALUES T_LROUND constraints_list T_RROUND ;

ofwithmulti : /*empty*/ ;
ofwithmulti : K_WITH mi_columns ;
ofwithmulti : K_OF mi_columns K_WITH mi_columns ;

mi_columns : column_name ;
mi_columns : T_LROUND mi_column_list T_RROUND ;

mi_column_list : column_name ;
mi_column_list : mi_column_list T_COMMA column_name ;

mi_given_opt : /*empty*/ ;
mi_given_opt : K_GIVEN T_LROUND mi_constraints T_RROUND ;

mi_constraints : mi_constraint ;
mi_constraints : mi_constraints T_COMMA mi_constraint ;

mi_constraint : column_name T_EQ expression ;
mi_constraint : column_name ;

bqlfn : K_CORRELATION ofwith ;
bqlfn : K_CORRELATION K_PVALUE ofwith ;
bqlfn : K_PREDICT column_name withconf nsamples_opt ;
bqlfn : primary ;

wrt : K_IN K_THE K_CONTEXT K_OF column_list ;

ofwith : /*empty*/ ;
ofwith : K_WITH column_name ;
ofwith : K_OF column_name K_WITH column_name ;

nsamples_opt : /*empty*/ ;
nsamples_opt : K_USING primary K_SAMPLES ;

column_lists : column_list ;
column_lists : column_lists T_COMMA column_list ;
column_lists : column_lists K_AND column_list ;

column_list : T_STAR ;
column_list : column_name ;
column_list : T_LROUND query T_RROUND ;

primary : literal ;
primary : L_NUMPAR ;
primary : L_NAMPAR ;
primary : L_NAME T_LROUND expressions_opt T_RROUND ;
primary : L_NAME T_LROUND K_DISTINCT expressions_opt T_RROUND ;
primary : L_NAME T_LROUND T_STAR T_RROUND ;
primary : T_LROUND expression T_RROUND ;
primary : T_LROUND query T_RROUND ;
primary : K_CAST T_LROUND expression K_AS type T_RROUND ;
primary : K_EXISTS T_LROUND query T_RROUND ;
primary : column_name ;
primary : table_name T_DOT column_name ;
primary : K_CASE case_key_opt case_whens_opt case_else_opt K_END ;

case_key_opt : /*empty*/ ;
case_key_opt : expression ;

case_whens_opt : /*empty*/ ;
case_whens_opt : case_whens_opt K_WHEN expression K_THEN expression ;

case_else_opt : /*empty*/ ;
case_else_opt : K_ELSE expression ;

literal : K_NULL ;
literal : L_INTEGER ;
literal : L_FLOAT ;
literal : L_STRING ;

type : typename ;
type : typename T_LROUND typearg T_RROUND ;
type : typename T_LROUND typearg T_COMMA typearg T_RROUND ;

typename : L_NAME ;
typename : typename L_NAME ;

typearg : L_INTEGER ;
typearg : T_PLUS L_INTEGER ;
typearg : T_MINUS L_INTEGER ;

ANY : L_NAME ;

%%

%option caseless

BASE_ID	[_a-zA-Z][a-zA-Z0-9_]*

%%

[ \t\n\r]+   skip()
"--".*      skip()
"/*"(?s:.)*?"*/"    skip()

ACCURACY	K_ACCURACY
ADD	K_ADD
ALL	K_ALL
ALTER	K_ALTER
ANALYZE	K_ANALYZE
AND	K_AND
AS	K_AS
ASC	K_ASC
BEGIN	K_BEGIN
BETWEEN	K_BETWEEN
BY	K_BY
CASE	K_CASE
CAST	K_CAST
CHECKPOINT	K_CHECKPOINT
COLLATE	K_COLLATE
COLUMN	K_COLUMN
COLUMNS	K_COLUMNS
COMMIT	K_COMMIT
CONFIDENCE	K_CONFIDENCE
CONTEXT	K_CONTEXT
CORRELATION	K_CORRELATION
CREATE	K_CREATE
DENSITY	K_DENSITY
DEPENDENCE	K_DEPENDENCE
DESC	K_DESC
DISTINCT	K_DISTINCT
DROP	K_DROP
ELSE	K_ELSE
END	K_END
ESCAPE	K_ESCAPE
ESTIMATE	K_ESTIMATE
EXISTING	K_EXISTING
EXISTS	K_EXISTS
EXPLICIT	K_EXPLICIT
FOR	K_FOR
FROM	K_FROM
GENERATOR	K_GENERATOR
GIVEN	K_GIVEN
GLOB	K_GLOB
GROUP	K_GROUP
GUESS	K_GUESS
HAVING	K_HAVING
HYPOTHETICAL	K_HYPOTHETICAL
IF	K_IF
IGNORE	K_IGNORE
IN	K_IN
INFER	K_INFER
INFORMATION	K_INFORMATION
INITIALIZE	K_INITIALIZE
IS	K_IS
ISNULL	K_ISNULL
ITERATION	K_ITERATION
ITERATIONS	K_ITERATIONS
LIKE	K_LIKE
LIMIT	K_LIMIT
MATCH	K_MATCH
MINUTE	K_MINUTE
MINUTES	K_MINUTES
MODEL	K_MODEL
MODELED	K_MODELED
MODELLED	K_MODELLED
MODELS	K_MODELS
MUTUAL	K_MUTUAL
NOT	K_NOT
NOTNULL	K_NOTNULL
NULL	K_NULL
OF	K_OF
OFFSET	K_OFFSET
OR	K_OR
ORDER	K_ORDER
PAIRWISE	K_PAIRWISE
POPULATION	K_POPULATION
PREDICT	K_PREDICT
PREDICTIVE	K_PREDICTIVE
PROBABILITY	K_PROBABILITY
PVALUE	K_PVALUE
REGEXP	K_REGEXP
REGRESS	K_REGRESS
RELEVANCE	K_RELEVANCE
RENAME	K_RENAME
ROLLBACK	K_ROLLBACK
ROWS	K_ROWS
SAMPLES	K_SAMPLES
SCHEMA	K_SCHEMA
SECOND	K_SECOND
SECONDS	K_SECONDS
SELECT	K_SELECT
SET	K_SET
SIMILARITY	K_SIMILARITY
SIMULATE	K_SIMULATE
STATTYPE	K_STATTYPE
STATTYPES	K_STATTYPES
TABLE	K_TABLE
TEMP	K_TEMP
TEMPORARY	K_TEMPORARY
THE	K_THE
THEN	K_THEN
TO	K_TO
USING	K_USING
VALUE	K_VALUE
VALUES	K_VALUES
VARIABLE	K_VARIABLE
VARIABLES	K_VARIABLES
WHEN	K_WHEN
WHERE	K_WHERE
WITH	K_WITH
WITHIN	K_WITHIN
"&"	T_BITAND
"~"	T_BITNOT
"|"	T_BITOR
","	T_COMMA
"||"	T_CONCAT
".."	T_DOT
"="	T_EQ
">="	T_GEQ
">"	T_GT
"{"	T_LCURLY
"<="	T_LEQ
"("	T_LROUND
"<<"	T_LSHIFT
"<"	T_LT
"-"	T_MINUS
"<>"|"!="	T_NEQ
"%"	T_PERCENT
"+"	T_PLUS
"}"	T_RCURLY
")"	T_RROUND
">>"	T_RSHIFT
";"	T_SEMI
"/"	T_SLASH
"*"	T_STAR

([0-9]+\.[0-9]*|\.[0-9]+)([Ee](\+|\-)?[0-9]+)?	L_FLOAT
[0-9]+	L_INTEGER
{BASE_ID}	L_NAME
\"{BASE_ID}\"	L_NAME
L_NAMPAR	L_NAMPAR
L_NUMPAR	L_NUMPAR
'(''|[^'\n])*'	L_STRING

%%
