//From: https://github.com/qpoint-io/rulekit/blob/174860d1b724832fbbe7e300f436915b579f0d47/parser.y

%token token_FIELD
%token token_STRING token_HEX_STRING
%token token_INT token_FLOAT
%token token_BOOL
%token token_IP_CIDR
%token token_IP
%token token_REGEX

// Tokens without values
%token op_NOT op_AND op_OR
%token token_LPAREN token_RPAREN
%token token_LBRACKET token_RBRACKET
%token token_COMMA
%token op_EQ op_NE
%token op_GT op_GE op_LT op_LE
%token op_CONTAINS op_MATCHES op_IN
//%token token_ARRAY
//%token token_ERROR

// Operator precedence
%left op_AND
%left op_OR
%right op_NOT

%%
search_condition:
	predicate
	| search_condition op_AND search_condition
	| search_condition op_OR search_condition
	| op_NOT search_condition
	| token_LPAREN search_condition token_RPAREN
	;

predicate:
	// numeric values accept additional inequality operators
	numeric_value_token ineq_operator numeric_value_token
	// all values including numeric accept equality operators
	| array_or_single_value_token eq_operator array_or_single_value_token
	// op_MATCHES supports regex values
	| array_or_single_value_token op_MATCHES token_REGEX
	| array_or_single_value_token
	// op_IN supports array values
	| array_or_single_value_token op_IN array_value_token
	;

ineq_operator:
	op_GT
	| op_GE
	| op_LT
	| op_LE
	;

eq_operator:
	op_EQ
	| op_NE
	| op_CONTAINS
	;

// Array handling rules
array_values:
	value_token
	| array_values token_COMMA value_token
	;

array_value_token:
	token_LBRACKET array_values token_RBRACKET
	;

array_or_single_value_token:
	value_token
	| array_value_token
	;

// value tokens
value_token:
	numeric_value_token
	| token_STRING
	| token_BOOL
	| token_IP
	| token_IP_CIDR
	| token_HEX_STRING
	| token_REGEX
	;

numeric_value_token:
	token_INT
	| token_FLOAT
	| token_FIELD
	;

%%

%option caseless

// Basic types
// ---
digit	[0-9]
int    [-+]?{digit}+
float  [-+]?{digit}*"."{digit}+
bool   "true"|"false"

// String types
// ---

dstring \"([^"]|"\\n"|"\\t"|"\\r"|"\\\"")*\"
sstring "'"([^']|"\\n"|"\\t"|"\\r"|"\\'")*"'"
string  {dstring}|{sstring}
// hex values e.g. 47:45:54 ="GET"
hex   [0-9a-fA-F]
hex_string {hex}{2}(":"{hex}{2})*

// Network types
// ---

octet {digit}|([\x31-\x39]{digit})|("1"{digit}{2})|("2"[\x30-\x34]{digit})|("25"[\x30-\x35])
ipv4  {octet}"."{octet}"."{octet}"."{octet}
h16   {hex}{1,4}
ls32  ({h16}":"{h16})|{ipv4}
ipv6_1  (({h16}":"){6}{ls32})
ipv6_2       ("::"(h16":"){5}{ls32})
ipv6_3       ({h16}?"::"({h16}":"){4}{ls32})
ipv6_4       ((({h16}":")?{h16})?"::"({h16}":"){3}{ls32})
ipv6_5       ((({h16}":"){2}{h16})?"::"({h16}":"){2}{ls32})
ipv6_6       ((({h16}":"){3}{h16})?"::"{h16}":"{ls32})
ipv6_7       ((({h16}":"){4}{h16})?"::"{ls32})
ipv6_8       ((({h16}":"){5}{h16})?"::"{h16})
ipv6_9       ((({h16}":"){6}{h16})?"::")

ipv6 {ipv6_1}|{ipv6_2}|{ipv6_3}|{ipv6_4}|{ipv6_5}|{ipv6_6}|{ipv6_7}|{ipv6_8}|{ipv6_9}
ip {ipv4}|{ipv6}
ip_cidr {ip}"/"{digit}{1,2}

// MAC addresses e.g. 47:45:54 or 47-45-54
// mac_delim ':' | '-';
// mac hex{2} (mac_delim hex{2}){5,6};

// Regex types
// ---

escaped_regex_char "\\".
// /some\/thing/ -style regex literal
not_slash_or_escape [^/\\]
regex_forward_slash "/"({not_slash_or_escape}|{escaped_regex_char})*"/"
// |some/thing|  -style regex literal
not_pipe_or_escape [^|\\]
regex_pipe "|"({not_pipe_or_escape}|{escaped_regex_char})*"|"

regex_pattern {regex_forward_slash}|{regex_pipe}

// Whitespace and comments
// ---

ws [ \t\n\r]
comment_line  "--".*
comment_block "/*"(?s:.)*?"*/"

alpha [A-Za-z]
field_char {alpha}|{digit}|"_"|"."
field ({alpha}|"_"){field_char}*  // Must start with alpha or underscore

%%

// --- lexer logic ---
// Skip comments and whitespace
{comment_line}|{comment_block}|{ws} skip()

// Control
"(" token_LPAREN
")" token_RPAREN
"[" token_LBRACKET
"]" token_RBRACKET
"," token_COMMA

// Logical operators
("!"|"not")  op_NOT
("&&"|"and") op_AND
("||"|"or")  op_OR

// Comparison operators
("=="|"eq") op_EQ
("!="|"ne") op_NE
("<"|"lt")  op_LT
("<="|"le") op_LE
(">"|"gt")  op_GT
(">="|"ge") op_GE

"contains"         op_CONTAINS
("=~"|"matches") op_MATCHES
"in"               op_IN

// Values
{int}    token_INT
{float}  token_FLOAT
{bool}   token_BOOL
{string} token_STRING

{ip}            token_IP
{ip_cidr}       token_IP_CIDR
{hex_string}    token_HEX_STRING
{regex_pattern} token_REGEX

// Field names (allow alphanumeric and dots with restrictions)
{field} token_FIELD

// Add an error rule at the end to catch any unrecognized characters

%%
