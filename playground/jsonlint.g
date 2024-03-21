//From: https://github.com/zaach/jsonlint/blob/f6624322e6ba7c2c6e7848729f7309873329e7cb/src/jsonlint.y

%token FALSE
%token NULL
%token NUMBER
%token STRING
%token TRUE

%start JSONText

/*
  ECMA-262 5th Edition, 15.12.1 The JSON Grammar.
*/


%%

JSONString :
	STRING
	;

JSONNumber :
	NUMBER
	;

JSONNullLiteral :
	NULL
	;

JSONBooleanLiteral :
	TRUE
	| FALSE
	;

JSONText :
	JSONValue //EOF
	;

JSONValue :
	JSONNullLiteral
	| JSONBooleanLiteral
	| JSONString
	| JSONNumber
	| JSONObject
	| JSONArray
	;

JSONObject :
	'{' '}'
	| '{' JSONMemberList '}'
	;

JSONMember :
	JSONString ':' JSONValue
	;

JSONMemberList :
	JSONMember
	| JSONMemberList ',' JSONMember
	;

JSONArray :
	'[' ']'
	| '[' JSONElementList ']'
	;

JSONElementList :
	JSONValue
	| JSONElementList ',' JSONValue
	;

%%

int  "-"?([0-9]|[1-9][0-9]+)
exp  [eE][-+]?[0-9]+
frac  "."[0-9]+

%%

\s+      skip() /* skip whitespace */

"{"      '{'
"}"      '}'
"["      '['
"]"      ']'
","      ','
":"      ':'
"true"   TRUE
"false"  FALSE
"null"   NULL
//<<EOF>>  'EOF'
//.        'INVALID'

{int}{frac}?{exp}?    NUMBER
\"(?:\\[\\"bfnrt/]|\\u[a-fA-F0-9]{4}|[^\\\x00-\x09\x0a-\x1f"])*\"    STRING

%%
