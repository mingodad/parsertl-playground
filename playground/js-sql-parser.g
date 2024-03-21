//From: https://github.com/JavaScriptor/js-sql-parser/blob/4baa4a937450b529fb31799d8912f4bc2f4a5776/src/sqlParser.jison

%token ALL
%token ANY
%token AS
%token ASC
%token BETWEEN
%token BINARY
%token CASE
//%token COLLATE
%token CROSS
%token DESC
%token DISTINCT
%token DISTINCTROW
%token ELSE
%token END
%token ESCAPE
%token EXISTS
%token EXPONENT_NUMERIC
%token FALSE
%token FOR
%token FORCE
%token FROM
%token GROUP_BY
%token HAVING
%token HEX_NUMERIC
%token HIGH_PRIORITY
%token IDENTIFIER
%token IGNORE
%token IN
%token INDEX
%token INNER
%token IS
%token JOIN
%token KEY
%token LEFT
%token LIKE
%token LIMIT
%token LOCK
%token MAX_STATEMENT_TIME
%token MODE
%token MULTI
%token NATURAL
%token NULL
%token NUMERIC
%token OFFSET
%token OJ
%token ORDER_BY
%token OUTER
%token PLACE_HOLDER
%token PROCEDURE
%token REGEXP
%token RIGHT
%token ROLLUP
%token ROW
%token SELECT
%token SELECT_EXPR_STAR
%token SHARE
%token SOUNDS
%token SQL_BIG_RESULT
%token SQL_BUFFER_RESULT
%token SQL_CACHE
%token SQL_CALC_FOUND_ROWS
%token SQL_NO_CACHE
%token SQL_SMALL_RESULT
%token STRAIGHT_JOIN
%token STRING
%token THEN
%token TRUE
%token UNION
%token UNKNOWN
%token UPDATE
%token USE
%token WHEN
%token WHERE
%token WITH


%left ',' TABLE_REF_COMMA
%nonassoc NO_PARTITION
%nonassoc PARTITION
%left INDEX_HINT_LIST
%left INDEX_HINT_COMMA
%left INNER_CROSS_JOIN_NULL LEFT_RIGHT_JOIN
%left INNER_CROSS_JOIN
%right USING
%right ON
%left OR XOR "||"
%left "&&" AND
%left '|'
%left '^'
%left '&'
%left '=' "!="        /* = in sql equels == */
%left '>' ">=" '<' "<="
%left "<<" ">>"
%left '+' '-'
%left DIV MOD '/' '%' '*'
%right UPLUS UMINUS UNOT '~' NOT
%left DOT

%start main

%% /* language grammar */

main
  : selectClause ';' // semicolonOpt //EOF
  | unionClause ';' // semicolonOpt //EOF
  | main selectClause ';'
  | main unionClause ';'
  ;

//semicolonOpt
//  : ';'
//  | %empty
//  ;

unionClause
  : unionClauseNotParenthesized
  | unionClauseParenthesized order_by_opt limit_opt
  ;

unionClauseParenthesized
  : selectClauseParenthesized UNION distinctOpt selectClauseParenthesized
  | selectClauseParenthesized UNION distinctOpt unionClauseParenthesized
  ;

selectClauseParenthesized
  : '(' selectClause ')'
  ;

unionClauseNotParenthesized
  : selectClause UNION distinctOpt selectClause
  | selectClause UNION distinctOpt unionClauseNotParenthesized
  ;

selectClause
  : SELECT
      distinctOpt
      highPriorityOpt
      maxStateMentTimeOpt
      straightJoinOpt
      sqlSmallResultOpt
      sqlBigResultOpt
      sqlBufferResultOpt
      sqlCacheOpt
      sqlCalcFoundRowsOpt
      selectExprList
      selectDataSetOpt
  ;

distinctOpt
  : ALL
  | DISTINCT
  | DISTINCTROW
  | %empty
  ;
highPriorityOpt
  : HIGH_PRIORITY
  | %empty
  ;
maxStateMentTimeOpt
  : MAX_STATEMENT_TIME '=' NUMERIC
  | %empty
  ;
straightJoinOpt
  : STRAIGHT_JOIN
  | %empty
  ;
sqlSmallResultOpt
  : SQL_SMALL_RESULT
  | %empty
  ;
sqlBigResultOpt
  : SQL_BIG_RESULT
  | %empty
  ;
sqlBufferResultOpt
  : SQL_BUFFER_RESULT
  | %empty
  ;
sqlCacheOpt
  : %empty
  | SQL_CACHE
  | SQL_NO_CACHE
  ;
sqlCalcFoundRowsOpt
  : SQL_CALC_FOUND_ROWS
  | %empty
  ;
selectExprList
  : selectExprList ',' selectExpr
  | selectExpr
  ;
selectExpr
  : '*'
  | SELECT_EXPR_STAR
  | expr selectExprAliasOpt
  ;
selectExprAliasOpt
  : %empty
  | AS IDENTIFIER
  | IDENTIFIER
  | AS STRING
  | STRING
  ;
string
  : STRING
  ;
number
  : NUMERIC
  | EXPONENT_NUMERIC
  | HEX_NUMERIC
  ;
boolean
  : TRUE
  | FALSE
  ;
null
  : NULL
  ;
literal
  : string
  | number
  | boolean
  | null
  | place_holder
  ;
function_call
  : IDENTIFIER '(' function_call_param_list ')'
  ;
function_call_param_list
  : function_call_param_list ',' function_call_param
  | function_call_param
  ;
function_call_param
  : %empty
  | '*'
  | SELECT_EXPR_STAR
  | DISTINCT expr
  | expr
  ;
identifier
  : IDENTIFIER
  | identifier DOT IDENTIFIER
  ;
identifier_list
  : identifier
  | identifier_list ',' identifier
  ;
case_expr_opt
  : %empty
  | expr
  ;
when_then_list
  : WHEN expr THEN expr
  | when_then_list WHEN expr THEN expr
  ;
case_when_else
  : %empty
  | ELSE expr
  ;
case_when
  : CASE case_expr_opt when_then_list case_when_else END
  ;
simple_expr_prefix
  : '+' simple_expr %prec UPLUS
  | '-' simple_expr %prec UMINUS
  | '~' simple_expr
  | '!' simple_expr %prec UNOT
  |  BINARY simple_expr
  ;
simple_expr
  : literal
  | identifier
  | function_call
  | simple_expr_prefix
  | '(' expr_list ')'
  | ROW '(' expr_list ')'
  | '(' selectClause ')'
  | EXISTS '(' selectClause ')'
  | '{' identifier expr '}'
  | case_when
  ;
bit_expr
  : simple_expr
  | bit_expr '|' bit_expr
  | bit_expr '&' bit_expr
  | bit_expr "<<" bit_expr
  | bit_expr ">>" bit_expr
  | bit_expr '+' bit_expr
  | bit_expr '-' bit_expr
  | bit_expr '*' bit_expr %prec MULTI
  | bit_expr '/' bit_expr
  | bit_expr DIV bit_expr
  | bit_expr MOD bit_expr
  | bit_expr '%' bit_expr
  | bit_expr '^' bit_expr
  ;
not_opt
  : %empty
  | NOT
  ;
escape_opt
  : %empty
  | ESCAPE simple_expr
  ;
predicate
  : bit_expr
  | bit_expr not_opt IN '(' selectClause ')'
  | bit_expr not_opt IN '(' expr_list ')'
  | bit_expr not_opt BETWEEN bit_expr AND predicate
  | bit_expr SOUNDS LIKE bit_expr
  | bit_expr not_opt LIKE simple_expr escape_opt
  | bit_expr not_opt REGEXP bit_expr
  ;
comparison_operator
  : '='
  | ">="
  | '>'
  | "<="
  | '<'
  | "<>"
  | "!="
  ;
sub_query_data_set_opt
 : ALL
 | ANY
 ;
boolean_primary
  : predicate
  | boolean_primary IS not_opt NULL
  | boolean_primary comparison_operator predicate
  | boolean_primary comparison_operator sub_query_data_set_opt '(' selectClause ')'
  ;
boolean_extra
  : boolean
  | UNKNOWN
  ;
expr
  : boolean_primary
  | boolean_primary IS not_opt boolean_extra
  | NOT expr
  | expr "&&" expr
  | expr "||" expr
  | expr OR expr
  | expr AND expr
  | expr XOR expr
  ;
expr_list
  : expr
  | expr_list ',' expr
  ;

where_opt
  : %empty
  | WHERE expr
  ;
group_by_opt
  : %empty
  | group_by
  ;
roll_up_opt
  : %empty
  | WITH ROLLUP
  ;
group_by
  : GROUP_BY group_by_order_by_item_list roll_up_opt
  ;
order_by_opt
  : %empty
  | order_by
  ;
order_by
  : ORDER_BY group_by_order_by_item_list roll_up_opt
  ;
group_by_order_by_item_list
  : group_by_order_by_item
  | group_by_order_by_item_list ',' group_by_order_by_item
  ;
group_by_order_by_item
  : expr sort_opt
  ;
sort_opt
  : %empty
  | ASC
  | DESC
  ;
having_opt
  : %empty
  | HAVING expr
  ;
limit
  : LIMIT NUMERIC
  | LIMIT NUMERIC ',' NUMERIC
  | LIMIT NUMERIC OFFSET NUMERIC
  ;
limit_opt
  : %empty
  | limit
  ;
procedure_opt
  : %empty
  | procedure
  ;
procedure
  : PROCEDURE function_call
  ;
for_update_lock_in_share_mode_opt
  : %empty
  | FOR UPDATE
  | LOCK IN SHARE MODE
  ;
selectDataSetOpt
  : %empty
  | FROM table_references partitionOpt where_opt group_by_opt having_opt order_by_opt limit_opt procedure_opt for_update_lock_in_share_mode_opt

  ;
table_references
  : escaped_table_reference
  | table_references ',' escaped_table_reference %prec TABLE_REF_COMMA
  ;
escaped_table_reference
  : table_reference
  | '{' OJ table_reference '}'
  ;
join_inner_cross
  : %empty
  | INNER
  | CROSS
  ;
left_right
  : LEFT
  | RIGHT
  ;
out_opt
  : %empty
  | OUTER
  ;
left_right_out_opt
  : %empty
  | left_right out_opt
  ;
join_table
  : table_reference join_inner_cross JOIN table_factor %prec INNER_CROSS_JOIN_NULL
  | table_reference join_inner_cross JOIN table_factor join_condition  %prec INNER_CROSS_JOIN
  | table_reference STRAIGHT_JOIN table_factor on_join_condition
  | table_reference left_right out_opt JOIN table_reference join_condition %prec LEFT_RIGHT_JOIN
  | table_reference NATURAL left_right_out_opt JOIN table_factor
  ;
//join_condition_opt
//  : %empty
//  | join_condition
//  ;
on_join_condition
  : ON expr
  ;
join_condition
  : on_join_condition
  | USING '(' identifier_list ')'
  ;
table_reference
  : table_factor
  | join_table
  ;
partition_names
  : identifier
  | partition_names ',' identifier
  ;
partitionOpt
  :  %empty %prec NO_PARTITION
  | PARTITION '(' partition_names ')'
  ;
aliasOpt
  : %empty
  | AS identifier
  | identifier
  ;
index_or_key
  : INDEX
  | KEY
  ;
for_opt
  : %empty
  | FOR JOIN
  | FOR ORDER_BY
  | FOR GROUP_BY
  ;
identifier_list_opt
  : %empty
  | identifier_list
  ;
index_hint_list_opt
  : %empty
  | index_hint_list %prec INDEX_HINT_LIST
  ;
index_hint_list
  : index_hint
  | index_hint_list ',' index_hint %prec INDEX_HINT_COMMA
  ;
index_hint
  : USE index_or_key for_opt '(' identifier_list_opt ')'
  | IGNORE index_or_key for_opt '(' identifier_list ')'
  | FORCE index_or_key for_opt '(' identifier_list ')'
  ;
table_factor
  : identifier partitionOpt aliasOpt index_hint_list_opt
  | '(' selectClause ')' aliasOpt
  | '(' table_references ')'
  | function_call aliasOpt index_hint_list_opt
  ;
place_holder
  : PLACE_HOLDER
  ;

%%

%option caseless

%%

[/][*](.|\n)*?[*][/]                                           skip()   /* skip comments */
[-][-].*\n                                                   skip()   /* skip sql comments */
[#].*\n                                                     skip()    /* skip sql comments */
\s+                                                           skip()    /* skip whitespace */

SELECT                                                            SELECT
ALL                                                               ALL
ANY                                                               ANY
DISTINCT                                                          DISTINCT
DISTINCTROW                                                       DISTINCTROW
HIGH_PRIORITY                                                     HIGH_PRIORITY
MAX_STATEMENT_TIME                                                MAX_STATEMENT_TIME
STRAIGHT_JOIN                                                     STRAIGHT_JOIN
SQL_SMALL_RESULT                                                  SQL_SMALL_RESULT
SQL_BIG_RESULT                                                    SQL_BIG_RESULT
SQL_BUFFER_RESULT                                                 SQL_BUFFER_RESULT
SQL_CACHE                                                         SQL_CACHE
SQL_NO_CACHE                                                      SQL_NO_CACHE
SQL_CALC_FOUND_ROWS                                               SQL_CALC_FOUND_ROWS
([a-zA-Z_\u4e00-\u9fa5][a-zA-Z0-9_\u4e00-\u9fa5]*\.){1,2}\*       SELECT_EXPR_STAR
AS                                                                AS
TRUE                                                              TRUE
FALSE                                                             FALSE
NULL                                                              NULL
//COLLATE                                                           COLLATE
BINARY                                                            BINARY
ROW                                                               ROW
EXISTS                                                            EXISTS
CASE                                                              CASE
WHEN                                                              WHEN
THEN                                                              THEN
ELSE                                                              ELSE
END                                                               END
DIV                                                               DIV
MOD                                                               MOD
NOT                                                               NOT
BETWEEN                                                           BETWEEN
IN                                                                IN
SOUNDS                                                            SOUNDS
LIKE                                                              LIKE
ESCAPE                                                            ESCAPE
REGEXP                                                            REGEXP
IS                                                                IS
UNKNOWN                                                           UNKNOWN
AND                                                               AND
OR                                                                OR
XOR                                                               XOR
FROM                                                              FROM
PARTITION                                                         PARTITION
USE                                                               USE
INDEX                                                             INDEX
KEY                                                               KEY
FOR                                                               FOR
JOIN                                                              JOIN
ORDER\s+BY                                                        ORDER_BY
GROUP\s+BY                                                        GROUP_BY
IGNORE                                                            IGNORE
FORCE                                                             FORCE
INNER                                                             INNER
CROSS                                                             CROSS
ON                                                                ON
USING                                                             USING
LEFT                                                              LEFT
RIGHT                                                             RIGHT
OUTER                                                             OUTER
NATURAL                                                           NATURAL
WHERE                                                             WHERE
ASC                                                               ASC
DESC                                                              DESC
WITH                                                              WITH
ROLLUP                                                            ROLLUP
HAVING                                                            HAVING
OFFSET                                                            OFFSET
PROCEDURE                                                         PROCEDURE
UPDATE                                                            UPDATE
LOCK                                                              LOCK
SHARE                                                             SHARE
MODE                                                              MODE
OJ                                                                OJ
LIMIT                                                             LIMIT
UNION                                                             UNION

","                                                               ','
"="                                                               '='
"("                                                               '('
")"                                                               ')'
"~"                                                               '~'
"!="                                                              "!="
"!"                                                               '!'
"|"                                                               '|'
"||"                                                               "||"
"&"                                                               '&'
"&&"                                                               "&&"
"+"                                                               '+'
"-"                                                               '-'
"*"                                                               '*'
"/"                                                               '/'
"%"                                                               '%'
"^"                                                               '^'
">>"                                                              ">>"
">="                                                              ">="
">"                                                               '>'
"<<"                                                              "<<"
"<="                                                              "<="
"<>"                                                              "<>"
"<"                                                               '<'
"{"                                                               '{'
"}"                                                               '}'
";"                                                               ';'

['](\\.|[^'])*[']                                                 STRING
["](\\.|[^"])*["]                                                 STRING
[0][x][0-9a-fA-F]+                                                HEX_NUMERIC
[-]?[0-9]+(\.[0-9]+)?                                             NUMERIC
[-]?[0-9]+(\.[0-9]+)?[eE][-][0-9]+(\.[0-9]+)?                     EXPONENT_NUMERIC

//[a-zA-Z_\u0080-\uFFFF][a-zA-Z0-9_\u0080-\uFFFF]*                  IDENTIFIER
[a-zA-Z_][a-zA-Z0-9_]*                  IDENTIFIER
\.                                                                DOT
["][a-zA-Z_\u4e00-\u9fa5][a-zA-Z0-9_\u4e00-\u9fa5]*["]            STRING
['][a-zA-Z_\u4e00-\u9fa5][a-zA-Z0-9_\u4e00-\u9fa5]*[']            STRING
[`](\\.|[^`\\])*[`]                                         IDENTIFIER

[$][{](.+?)[}]                                                    PLACE_HOLDER
[`][a-zA-Z0-9_\u0080-\uFFFF]*[`]                                  IDENTIFIER
//[\w]+[\u0080-\uFFFF]+[0-9a-zA-Z_\u0080-\uFFFF]*                   IDENTIFIER
//[\u0080-\uFFFF][0-9a-zA-Z_\u0080-\uFFFF]*                         IDENTIFIER

//<<EOF>>                                                           EOF
//.                                                                 INVALID'

%%
