//From: https://github.com/apache/age/blob/bb704ac54ee562c08d81f2e991b0e7cfa33595a2/src/backend/parser/cypher_gram.y
/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

/*
Semicolon is not optional for the playground to parser multiple statements
*/

%option caseless

%x xdecimalfail
%x mlcomment
%x dqstr sqstr qstru
%x bqid

/*Tokens*/
%token INTEGER
%token DECIMAL
%token STRING
%token IDENTIFIER
%token PARAMETER
%token NOT_EQ
%token LT_EQ
%token GT_EQ
%token DOT_DOT
%token TYPECAST
%token PLUS_EQ
%token EQ_TILDE
%token CONCAT
%token ACCESS_PATH
%token ANY_EXISTS
%token ALL_EXISTS
%token ALL
%token ANALYZE
%token AND
%token AS
%token ASC
%token ASCENDING
%token BY
%token CALL
%token CASE
%token COALESCE
%token CONTAINS
%token CREATE
%token DELETE
%token DESC
%token DESCENDING
%token DETACH
%token DISTINCT
%token ELSE
%token END_P
%token ENDS
%token EXISTS
%token EXPLAIN
%token FALSE_P
%token IN
%token IS
%token LIMIT
%token MATCH
%token MERGE
%token NOT
%token NULL_P
%token OPTIONAL
%token OR
%token ORDER
%token REMOVE
%token RETURN
%token SET
%token SKIP
%token STARTS
%token THEN
%token TRUE_P
%token UNION
%token UNWIND
%token VERBOSE
%token WHEN
%token WHERE
%token WITH
%token XOR
%token YIELD
%token '='
%token '<'
%token '>'
//%token '|'
//%token '&'
%token '?'
%token '+'
%token '-'
%token '*'
%token '/'
%token '%'
%token '^'
%token UNARY_MINUS
%token '['
%token ']'
%token '('
%token ')'
%token '.'
%token ','
%token ';'
%token ':'
%token '{'
%token '}'

%left /*1*/ UNION
%left /*2*/ OR
%left /*3*/ AND
%left /*4*/ XOR
%right /*5*/ NOT
%left /*6*/ NOT_EQ LT_EQ GT_EQ '=' '<' '>'
%left /*7*/ ANY_EXISTS ALL_EXISTS '?' //'&' '||'
%left /*8*/ CONCAT '+' '-'
%left /*9*/ '*' '/' '%'
%left /*10*/ '^'
%nonassoc /*11*/ IN IS
%right /*12*/ UNARY_MINUS
%nonassoc /*13*/ EQ_TILDE CONTAINS ENDS STARTS
%left /*14*/ '[' ']' '(' ')'
%left /*15*/ ACCESS_PATH '.'
%left /*16*/ TYPECAST

%start stmt_list

%%

stmt_list :
    stmt
    | stmt_list stmt
    ;

stmt :
	cypher_stmt semicolon_opt
	| EXPLAIN cypher_stmt semicolon_opt
	| EXPLAIN VERBOSE cypher_stmt semicolon_opt
	| EXPLAIN ANALYZE cypher_stmt semicolon_opt
	| EXPLAIN ANALYZE VERBOSE cypher_stmt semicolon_opt
	;

cypher_stmt :
	single_query
	| cypher_stmt UNION /*1L*/ all_or_distinct cypher_stmt
	;

call_stmt :
	CALL expr_func_norm
	| CALL expr '.' /*15L*/ expr
	| CALL expr_func_norm YIELD yield_item_list where_opt
	| CALL expr '.' /*15L*/ expr YIELD yield_item_list where_opt
	;

yield_item_list :
	yield_item
	| yield_item_list ',' yield_item
	;

yield_item :
	expr AS var_name
	| expr
	;

semicolon_opt :
	';'
	//| /*empty*/
	;

all_or_distinct :
	ALL
	| DISTINCT
	| /*empty*/
	;

single_query :
	query_part_init query_part_last
	;

query_part_init :
	/*empty*/
	| query_part_init reading_clause_list updating_clause_list_0 with
	;

query_part_last :
	reading_clause_list updating_clause_list_1
	| reading_clause_list updating_clause_list_0 return
	| reading_clause_list call_stmt
	;

reading_clause_list :
	/*empty*/
	| reading_clause_list reading_clause
	;

reading_clause :
	match
	| unwind
	| call_stmt
	;

updating_clause_list_0 :
	/*empty*/
	| updating_clause_list_1
	;

updating_clause_list_1 :
	updating_clause
	| updating_clause_list_1 updating_clause
	;

updating_clause :
	create
	| set
	| remove
	| delete
	| merge
	;

cypher_varlen_opt :
	'*' /*9L*/ cypher_range_opt
	| /*empty*/
	;

cypher_range_opt :
	cypher_range_idx
	| cypher_range_idx_opt DOT_DOT cypher_range_idx_opt
	| /*empty*/
	;

cypher_range_idx :
	Iconst
	;

cypher_range_idx_opt :
	cypher_range_idx
	| /*empty*/
	;

Iconst :
	INTEGER
	;

return :
	RETURN DISTINCT return_item_list order_by_opt skip_opt limit_opt
	| RETURN return_item_list order_by_opt skip_opt limit_opt
	;

return_item_list :
	return_item
	| return_item_list ',' return_item
	;

return_item :
	expr AS var_name
	| expr
	| '*' /*9L*/
	;

order_by_opt :
	/*empty*/
	| ORDER BY sort_item_list
	;

sort_item_list :
	sort_item
	| sort_item_list ',' sort_item
	;

sort_item :
	expr order_opt
	;

order_opt :
	/*empty*/
	| ASC
	| ASCENDING
	| DESC
	| DESCENDING
	;

skip_opt :
	/*empty*/
	| SKIP expr
	;

limit_opt :
	/*empty*/
	| LIMIT expr
	;

with :
	WITH DISTINCT return_item_list order_by_opt skip_opt limit_opt where_opt
	| WITH return_item_list order_by_opt skip_opt limit_opt where_opt
	;

match :
	optional_opt MATCH pattern where_opt
	;

optional_opt :
	OPTIONAL
	| /*empty*/
	;

unwind :
	UNWIND expr AS var_name
	;

create :
	CREATE pattern
	;

set :
	SET set_item_list
	;

set_item_list :
	set_item
	| set_item_list ',' set_item
	;

set_item :
	expr '=' /*6L*/ expr
	| expr PLUS_EQ expr
	;

remove :
	REMOVE remove_item_list
	;

remove_item_list :
	remove_item
	| remove_item_list ',' remove_item
	;

remove_item :
	expr
	;

delete :
	detach_opt DELETE expr_list
	;

detach_opt :
	DETACH
	| /*empty*/
	;

merge :
	MERGE path
	;

where_opt :
	/*empty*/
	| WHERE expr
	;

pattern :
	path
	| pattern ',' path
	;

path :
	anonymous_path
	| var_name '=' /*6L*/ anonymous_path
	;

anonymous_path :
	simple_path_opt_parens
	;

simple_path_opt_parens :
	simple_path
	| '(' /*14L*/ simple_path ')' /*14L*/
	;

simple_path :
	path_node
	| simple_path path_relationship path_node
	;

path_node :
	'(' /*14L*/ var_name_opt label_opt properties_opt ')' /*14L*/
	;

path_relationship :
	'-' /*8L*/ path_relationship_body '-' /*8L*/
	| '-' /*8L*/ path_relationship_body '-' /*8L*/ '>' /*6L*/
	| '<' /*6L*/ '-' /*8L*/ path_relationship_body '-' /*8L*/
	;

path_relationship_body :
	'[' /*14L*/ var_name_opt label_opt cypher_varlen_opt properties_opt ']' /*14L*/
	| /*empty*/
	;

label_opt :
	/*empty*/
	| ':' label_name
	;

properties_opt :
	/*empty*/
	| map
	| PARAMETER
	;

expr :
	expr OR /*2L*/ expr
	| expr AND /*3L*/ expr
	| expr XOR /*4L*/ expr
	| NOT /*5R*/ expr
	| expr '=' /*6L*/ expr
	| expr NOT_EQ /*6L*/ expr
	| expr '<' /*6L*/ expr
	| expr LT_EQ /*6L*/ expr
	| expr '>' /*6L*/ expr
	| expr GT_EQ /*6L*/ expr
	| expr '?' /*7L*/ expr %prec '.' /*15L*/
	| expr ANY_EXISTS /*7L*/ expr
	| expr ALL_EXISTS /*7L*/ expr
	| expr CONCAT /*8L*/ expr
	| expr ACCESS_PATH /*15L*/ expr
	| expr '+' /*8L*/ expr
	| expr '-' /*8L*/ expr
	| expr '*' /*9L*/ expr
	| expr '/' /*9L*/ expr
	| expr '%' /*9L*/ expr
	| expr '^' /*10L*/ expr
	| expr IN /*11N*/ expr
	| expr IS /*11N*/ NULL_P %prec IS /*11N*/
	| expr IS /*11N*/ NOT /*5R*/ NULL_P %prec IS /*11N*/
	| '-' /*8L*/ expr %prec UNARY_MINUS /*12R*/
	| expr STARTS /*13N*/ WITH expr %prec STARTS /*13N*/
	| expr ENDS /*13N*/ WITH expr %prec ENDS /*13N*/
	| expr CONTAINS /*13N*/ expr
	| expr EQ_TILDE /*13N*/ expr
	| expr '[' /*14L*/ expr ']' /*14L*/
	| expr '[' /*14L*/ expr_opt DOT_DOT expr_opt ']' /*14L*/
	| expr '.' /*15L*/ expr
	| expr TYPECAST /*16L*/ symbolic_name
	| expr_atom
	;

expr_opt :
	/*empty*/
	| expr
	;

expr_list :
	expr
	| expr_list ',' expr
	;

expr_list_opt :
	/*empty*/
	| expr_list
	;

expr_func :
	expr_func_norm
	| expr_func_subexpr
	;

expr_func_norm :
	func_name '(' /*14L*/ ')' /*14L*/
	| func_name '(' /*14L*/ expr_list ')' /*14L*/
	| func_name '(' /*14L*/ '*' /*9L*/ ')' /*14L*/
	| func_name '(' /*14L*/ DISTINCT expr_list ')' /*14L*/
	;

expr_func_subexpr :
	COALESCE '(' /*14L*/ expr_list ')' /*14L*/
	| EXISTS '(' /*14L*/ anonymous_path ')' /*14L*/
	| EXISTS '(' /*14L*/ property_value ')' /*14L*/
	;

property_value :
	expr_var '.' /*15L*/ property_key_name
	;

expr_atom :
	expr_literal
	| PARAMETER
	| '(' /*14L*/ expr ')' /*14L*/
	| expr_case
	| expr_var
	| expr_func
	;

expr_literal :
	INTEGER
	| DECIMAL
	| STRING
	| TRUE_P
	| FALSE_P
	| NULL_P
	| map
	| list
	;

map :
	'{' map_keyval_list_opt '}'
	;

map_keyval_list_opt :
	/*empty*/
	| map_keyval_list
	;

map_keyval_list :
	property_key_name ':' expr
	| map_keyval_list ',' property_key_name ':' expr
	;

list :
	'[' /*14L*/ expr_list_opt ']' /*14L*/
	;

expr_case :
	CASE expr expr_case_when_list expr_case_default END_P
	| CASE expr_case_when_list expr_case_default END_P
	;

expr_case_when_list :
	expr_case_when
	| expr_case_when_list expr_case_when
	;

expr_case_when :
	WHEN expr THEN expr
	;

expr_case_default :
	ELSE expr
	| /*empty*/
	;

expr_var :
	var_name
	;

func_name :
	symbolic_name
	| safe_keywords '.' /*15L*/ symbolic_name
	;

property_key_name :
	schema_name
	;

var_name :
	symbolic_name
	;

var_name_opt :
	/*empty*/
	| var_name
	;

label_name :
	schema_name
	;

symbolic_name :
	IDENTIFIER
	;

schema_name :
	symbolic_name
	| reserved_keyword
	;

reserved_keyword :
	safe_keywords
	| conflicted_keywords
	;

safe_keywords :
	ALL
	| ANALYZE
	| AND /*3L*/
	| AS
	| ASC
	| ASCENDING
	| BY
	| CALL
	| CASE
	| COALESCE
	| CONTAINS /*13N*/
	| CREATE
	| DELETE
	| DESC
	| DESCENDING
	| DETACH
	| DISTINCT
	| ELSE
	| ENDS /*13N*/
	| EXISTS
	| EXPLAIN
	| IN /*11N*/
	| IS /*11N*/
	| LIMIT
	| MATCH
	| MERGE
	| NOT /*5R*/
	| OPTIONAL
	| OR /*2L*/
	| ORDER
	| REMOVE
	| RETURN
	| SET
	| SKIP
	| STARTS /*13N*/
	| THEN
	| UNION /*1L*/
	| WHEN
	| VERBOSE
	| WHERE
	| WITH
	| XOR /*4L*/
	| YIELD
	;

conflicted_keywords :
	END_P
	| FALSE_P
	| NULL_P
	| TRUE_P
	;

%%

/*
 * whitespace rule in Cypher handles twenty-four characters out of the
 * twenty-five characters defined as whitespace characters, four extra control
 * characters (FS, GS, RS, and US), and Mongolian vowel separator in Unicode.
 *
 * Only six of them below have been considered as whitespace characters here.
 * This character set is a superset of whitespace characters in JSON.
 *
 *     [\t\n\v\f\r ]
 *         U+0009 CHARACTER TABULATION (HT, Horizontal Tab)
 *         U+000A LINE FEED (LF)
 *         U+000B LINE TABULATION (VT, Vertical Tab)
 *         U+000C FORM FEED (FF)
 *         U+000D CARRIAGE RETURN (CR)
 *         U+0020 SPACE
 *
 * The other characters are listed below for future reference. To handle them,
 * you may use the patterns that match UTF-8 encoded code points of them.
 *
 *     \xC2[\x85\xA0]
 *         U+0085 NEXT LINE (NEL) -- not in Cypher
 *         U+00A0 NO-BREAK SPACE
 *     \xE1\x9A\x80
 *         U+1680 OGHAM SPACE MARK
 *     \xE2\x80[\x80-\x8A\xA8\xA9\xAF]
 *         U+2000 EN QUAD
 *         U+2001 EM QUAD
 *         U+2002 EN SPACE
 *         U+2003 EM SPACE
 *         U+2004 THREE-PER-EM SPACE
 *         U+2005 FOUR-PER-EM SPACE
 *         U+2006 SIX-PER-EM SPACE
 *         U+2007 FIGURE SPACE
 *         U+2008 PUNCTUATION SPACE
 *         U+2009 THIN SPACE
 *         U+200A HAIR SPACE
 *         U+2028 LINE SEPARATOR
 *         U+2029 PARAGRAPH SEPARATOR
 *         U+202F NARROW NO-BREAK SPACE
 *     \xE2\x81\x9F
 *         U+205F MEDIUM MATHEMATICAL SPACE
 *     \xE3\x80\x80
 *         U+3000 IDEOGRAPHIC SPACE
 *
 *     [\x1C-\x1F]
 *         U+001C INFORMATION SEPARATOR FOUR (FS, File Separator)
 *         U+001D INFORMATION SEPARATOR THREE (GS, Group Separator)
 *         U+001E INFORMATION SEPARATOR TWO (RS, Record Separator)
 *         U+001F INFORMATION SEPARATOR ONE (US, Unit Separator)
 *
 *     \xE1\xA0\x8E
 *         U+180E MONGOLIAN VOWEL SEPARATOR -- not a whitespace anymore
 */
whitespace [\t\n\v\f\r ]+

/*
 * Comment rule for multi-line comment in Cypher does not match comments that
 * end with an odd number of "*"s before the closing sequence.
 * Therefore, the rule has been modified so that it can match such comments.
 */
mlcstart  "/*"
mlcchars  [^*]+|\*+
mlcstop    \*+\/
slcomment "//"[^\n\r]*

/*
 * For numbers, unary plus and minus are handled as operators later in Cypher
 * grammar although JSON numbers may be prefixed with an optional minus sign.
 *
 * JSON does not support octal and hexadecimal integer literals.
 */

digit    [0-9]
hexdigit [0-9A-Fa-f]

/*
 * digitseq pattern covers DecimalInteger and OctalInteger rules in Cypher.
 * Integer in JSON is represented in "0|[1-9][0-9]*" pattern that is covered by
 * digitseq pattern.
 */
digitseq {digit}+

/*
 * hexint pattern covers HexInteger rule in Cypher and also accepts "0X" prefix
 * for convenience.
 */
hexint     0[Xx]{hexdigit}+
hexintfail 0[Xx]

/*
 * decimal pattern covers RegularDecimalReal rule in Cypher and also accepts
 * "{digitseq}\." pattern (e.g. "1.") which RegularDecimalReal rule doesn't.
 * Decimal in JSON is represented in "(0|[1-9][0-9]*)\.[0-9]+" pattern that is
 * covered by decimal pattern.
 *
 * decimalfail pattern is for ranges (e.g. "0..1"). The action for the pattern
 * consumes digitseq and returns dot_dot back to the input stream so that
 * dot_dot can be matched next.
 */
decimal     {digitseq}\.{digit}*|\.{digitseq}
decimalfail {digitseq}\.\.

/*
 * decimalsci pattern covers ExponentDecimalReal rule in Cypher. It also
 * accepts coefficients in "{digitseq}\." pattern and explicit positive
 * exponents ("+") which ExponentDecimalReal rule doesn't.
 * Scientific notation in JSON is represented in
 * "(0|[1-9][0-9]*)(\.[0-9]+)?[Ee][+-]?[0-9]+" pattern that is covered by
 * decimalsci pattern.
 */
decimalsci      ({digitseq}|{decimal})[Ee][+-]?{digitseq}
decimalscifail1 ({digitseq}|{decimal})[Ee]
decimalscifail2 ({digitseq}|{decimal})[Ee][+-]

/*
 * These patterns cover StringLiteral rule in Cypher and JSON strings.
 * The escape sequence "\/" has been added for JSON strings.
 *
 * esasciifail and esunicodefail patterns handle escape sequences that are not
 * accepted by esascii and esunicode patterns respectively.
 *
 * Since esasciifail pattern can match anything that esascii pattern can,
 * esascii must appear first before esasciifail in the rules section.
 *
 * qstru start condition is for Unicode low surrogates.
 */
dquote        \"
dqchars       [^"\\]+
squote        '
sqchars       [^'\\]+
esascii       \\["'/\\bfnrt]
esasciifail   \\[^Uu]?
esunicode     \\(U{hexdigit}{8}|u{hexdigit}{4})
esunicodefail \\(U{hexdigit}{0,7}|u{hexdigit}{0,3})
any           (?s:.)

/* id pattern is for UnescapedSymbolicName rule in Cypher. */
idstart [A-Z_a-z\x80-\xFF]
idcont  [$0-9A-Z_a-z\x80-\xFF]
id      {idstart}{idcont}*

/* These are for EscapedSymbolicName rule in Cypher. */
bquote   `
bqchars  [^`]+
esbquote {bquote}{bquote}

/*
 * Parameter rule in Cypher is "$" followed by SymbolicName or DecimalInteger
 * rule. However, according to "Cypher Query Language Reference",
 *
 *     Parameters may consist of letters and numbers, and any combination of
 *     these, but cannot start with a number or a currency symbol.
 *
 * So, a modified version of Parameter rule that follows the above explanation
 * has been used.
 */
param \${id}

/*
 * These are tokens that are used as operators and language constructs in
 * Cypher, and some of them are structural characters in JSON.
 */
any_exists  "?|"
all_exists  "?&"
concat      "||"
access_path "#>"
lt_gt       "<>"
lt_eq       "<="
gt_eq       ">="
dot_dot     ".."
plus_eq     "+="
eq_tilde    "=~"
typecast    "::"
self        [?%()*+,\-./:;<=>[\]^{|}]

other .

%%

{whitespace} skip()

{mlcstart}<mlcomment>

<mlcomment>{mlcchars}<.>

<mlcomment>{mlcstop}<INITIAL>	skip()

//<mlcomment><<EOF>> scan_errmsg("unterminated /* comment")

{slcomment} skip()

ALL	ALL
ANALYZE	ANALYZE
AND	AND
AS	AS
ASC	ASC
ASCENDING	ASCENDING
BY	BY
CALL	CALL
CASE	CASE
COALESCE	COALESCE
CONTAINS	CONTAINS
CREATE	CREATE
DELETE	DELETE
DESC	DESC
DESCENDING	DESCENDING
DETACH	DETACH
DISTINCT	DISTINCT
ELSE	ELSE
END	END_P
ENDS	ENDS
EXISTS	EXISTS
EXPLAIN	EXPLAIN
FALSE	FALSE_P
IN	IN
IS	IS
LIMIT	LIMIT
MATCH	MATCH
MERGE	MERGE
NOT	NOT
NULL	NULL_P
OPTIONAL	OPTIONAL
OR	OR
ORDER	ORDER
REMOVE	REMOVE
RETURN	RETURN
SET	SET
SKIP	SKIP
STARTS	STARTS
THEN	THEN
TRUE	TRUE_P
UNION	UNION
UNWIND	UNWIND
VERBOSE	VERBOSE
WHEN	WHEN
WHERE	WHERE
WITH	WITH
XOR	XOR
YIELD	YIELD

"="	'='
"<"	'<'
">"	'>'
"?"	'?'
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
","	','
";"	';'
":"	':'
"{"	'{'
"}"	'}'

{digitseq}	INTEGER
{hexint}	INTEGER

//{hexintfail} scan_errmsg("invalid hexadecimal integer literal")

{decimal}	DECIMAL
{decimalsci} DECIMAL

{decimalfail}<xdecimalfail> reject() // return dot_dot back to the input stream
<xdecimalfail> {
    {digitseq}<INITIAL>	INTEGER
}

//{decimalscifail1}	scan_errmsg("invalid scientific notation literal")
//{decimalscifail2}	scan_errmsg("invalid scientific notation literal")

{dquote}<dqstr>

{squote}<sqstr>

<dqstr>{dqchars}<.>
<sqstr>{sqchars}<.>

<dqstr,sqstr>{esascii}<.>

//<dqstr,sqstr>{esasciifail} scan_errmsg("invalid escape sequence")

<dqstr,sqstr>{esunicode}<.>
<qstru>{esunicode}<.>

//<dqstr,sqstr,qstru>{esunicodefail} scan_errmsg("invalid Unicode escape sequence")

//<qstru>{any} scan_errmsg("invalid Unicode surrogate pair")

<dqstr>{dquote}<INITIAL>	STRING
<sqstr>{squote}<INITIAL>	STRING

//<dqstr,sqstr,qstru><<EOF>> scan_errmsg("unterminated quoted string")

{id}	IDENTIFIER

{bquote}<bqid>

<bqid>{bqchars}<.>

<bqid>{esbquote}<.>

<bqid>{bquote}<INITIAL> IDENTIFIER

//<bqid><<EOF>> scan_errmsg("unterminated quoted identifier"

{param} PARAMETER

{concat} CONCAT

{access_path} ACCESS_PATH

{any_exists} ANY_EXISTS

{all_exists} ALL_EXISTS

{lt_gt} NOT_EQ

{lt_eq} LT_EQ

{gt_eq} GT_EQ

{dot_dot} DOT_DOT

{plus_eq} PLUS_EQ

{eq_tilde} EQ_TILDE

{typecast} TYPECAST

//{self} CHAR

//{other} scan_errmsg("unexpected character")

//<<EOF>> AG_TOKEN_NULL

%%
