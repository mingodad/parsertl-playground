//From: https://github.com/matz/streem/blob/d022e833335e490bd1dccf0e3bfff71eb50a40bd/src/parse.y
/*
** parse.y - streem parser
**
** See Copyright Notice in LICENSE file.
*/

/*Tokens*/
%token identifier
%token keyword_case
%token keyword_class
%token keyword_def
%token keyword_else
%token keyword_emit
%token keyword_false
%token keyword_if
%token keyword_import
%token keyword_method
%token keyword_namespace
%token keyword_new
%token keyword_nil
%token keyword_return
%token keyword_skip
%token keyword_true
%token label
%token lit_number
%token lit_string
%token lit_symbol
%token lit_time
%token '\n'
%token op_amper
%token op_and
%token op_bar
//%token op_colon2
%token op_div
%token op_eq
%token op_ge
%token op_gt
%token op_lambda
%token op_lambda2
%token op_lambda3
//%token op_lasgn
%token op_le
%token op_lt
%token op_minus
%token op_mod
%token op_mult
%token op_neq
%token op_or
%token op_plus
%token op_rasgn

%nonassoc /*1*/ op_LOWEST
%right /*2*/ op_lambda op_lambda2 op_lambda3
%right /*3*/ keyword_else
%right /*4*/ keyword_if
%left /*5*/ op_bar
%left /*6*/ op_amper
%left /*7*/ op_or
%left /*8*/ op_and
%nonassoc /*9*/ op_eq op_neq
%left /*10*/ op_lt op_le op_gt op_ge
%left /*11*/ op_plus op_minus
%left /*12*/ op_mult op_div op_mod
%right /*13*/ '!' '~'

%start program

%%

program :
	topstmts
	;

topstmts :
	topstmt_list opt_terms
	| terms topstmt_list opt_terms
	| opt_terms
	;

topstmt_list :
	topstmt
	| topstmt_list terms topstmt
	;

topstmt :
	keyword_namespace identifier '{' topstmts '}'
	| keyword_class identifier '{' topstmts '}'
	| keyword_import identifier
	| keyword_method fname '(' opt_f_args ')' '{' stmts '}'
	| keyword_method fname '(' opt_f_args ')' '=' expr
	| stmt
	;

stmts :
	stmt_list opt_terms
	| terms stmt_list opt_terms
	| opt_terms
	;

stmt_list :
	stmt
	| stmt_list terms stmt
	;

stmt :
	var '=' expr
	| keyword_def fname '(' opt_f_args ')' '{' stmts '}'
	| keyword_def fname '(' opt_f_args ')' '=' expr
	| keyword_def fname '=' expr
	| expr op_rasgn var
	| keyword_skip
	| keyword_emit opt_args
	| keyword_return opt_args
	| expr
	;

var :
	identifier
	;

fname :
	identifier
	| lit_string
	;

expr :
	expr op_plus /*11L*/ expr
	| expr op_minus /*11L*/ expr
	| expr op_mult /*12L*/ expr
	| expr op_div /*12L*/ expr
	| expr op_mod /*12L*/ expr
	| expr op_bar /*5L*/ expr
	| expr op_amper /*6L*/ expr
	| expr op_gt /*10L*/ expr
	| expr op_ge /*10L*/ expr
	| expr op_lt /*10L*/ expr
	| expr op_le /*10L*/ expr
	| expr op_eq /*9N*/ expr
	| expr op_neq /*9N*/ expr
	| op_plus /*11L*/ expr %prec '!' /*13R*/
	| op_minus /*11L*/ expr %prec '!' /*13R*/
	| '!' /*13R*/ expr
	| '~' /*13R*/ expr
	| expr op_and /*8L*/ expr
	| expr op_or /*7L*/ expr
	| '(' opt_f_args op_lambda2 /*2R*/ expr
	| '(' opt_f_args op_lambda3 /*2R*/ stmts '}'
	| keyword_if /*4R*/ condition expr opt_else
	| primary
	;

condition :
	'(' expr ')'
	;

opt_else :
	%prec keyword_else /*3R*/ /*empty*/
	| keyword_else /*3R*/ expr %prec keyword_else /*3R*/
	;

opt_args :
	/*empty*/
	| args
	;

arg :
	expr
	| label expr
	| op_mult /*12L*/ expr
	;

args :
	arg
	| args ',' arg
	;

primary :
	lit_number
	| lit_string
	| lit_symbol
	| lit_time
	| var
	| '(' expr ')'
	| '[' args ']'
	| '[' ']'
	| block
	| keyword_nil
	| keyword_true
	| keyword_false
	| keyword_new identifier '[' opt_args ']'
	| fname block
	| fname '(' opt_args ')' opt_block
	| primary '.' fname '(' opt_args ')' opt_block
	| primary '.' fname opt_block
	| primary '.' '(' opt_args ')' opt_block
	| op_amper /*6L*/ fname
	;

opt_block :
	/*empty*/
	| block
	;

pterm :
	var
	| lit_number
	| lit_string
	| keyword_nil
	| keyword_true
	| keyword_false
	| '[' ']'
	| '[' '@' identifier ']'
	| '[' pattern ']'
	| '[' '@' identifier pattern ']'
	| pterm '@' identifier
	;

pary :
	pterm
	| pary ',' pterm
	;

pstruct :
	label pterm
	| pstruct ',' label pterm
	;

pattern :
	pary
	| pary ',' op_mult /*12L*/ pterm
	| pary ',' op_mult /*12L*/ pterm ',' pary
	| op_mult /*12L*/ pterm
	| op_mult /*12L*/ pterm ',' pary
	| pstruct
	| pstruct ',' op_mult /*12L*/ pterm
	;

cparam :
	op_lambda /*2R*/
	| keyword_if /*4R*/ expr op_lambda /*2R*/
	| pattern op_lambda /*2R*/
	| pattern keyword_if /*4R*/ expr op_lambda /*2R*/
	;

case_body :
	keyword_case cparam stmts
	| case_body keyword_case cparam stmts
	;

block :
	'{' stmts '}'
	| '{' bparam stmts '}'
	| '{' case_body '}'
	| '{' case_body keyword_else /*3R*/ op_lambda /*2R*/ stmts '}'
	;

bparam :
	op_lambda /*2R*/
	| f_args op_lambda /*2R*/
	;

opt_f_args :
	/*empty*/
	| f_args
	;

f_args :
	var
	| f_args ',' var
	;

opt_terms :
	/*empty*/
	| terms
	;

terms :
	term
	| terms term
	;

term :
	';'
	| '\n'
	;

%%

TRAIL  ([\t \n]|"#"[^\n]*"\n")*
CHAR   [a-zA-Z_]|[\302-\337][\200-\277]|[\340-\357][\200-\277]{2}|[\360-\367][\200-\277]{2}|[\370-\373][\200-\277]{4}|[\374-\375][\200-\277]{5}
CHNUM  ({CHAR}|[0-9])
WORD   {CHAR}{CHNUM}*
DATE   [0-9]+\.[0-9]+\.[0-9]+
TIME   [0-9]+":"[0-9]+(":"[0-9]+)?(\.[0-9]+)?
TZONE  "Z"|[+-][0-9]+(":"[0-9]+)?

%%

"+"{TRAIL}  op_plus
"-"{TRAIL}  op_minus
"*"{TRAIL}  op_mult
"/"{TRAIL}  op_div
"%"{TRAIL}  op_mod
"=="{TRAIL} op_eq
"!="{TRAIL} op_neq
"<"{TRAIL}  op_lt
"<="{TRAIL} op_le
">"{TRAIL}  op_gt
">="{TRAIL} op_ge
"&&"{TRAIL} op_and
"||"{TRAIL} op_or
"&"{TRAIL}  op_amper
//"<-"{TRAIL} op_lasgn
"=>"{TRAIL} op_rasgn
"->"{TRAIL} op_lambda
")"" "*"->"{TRAIL} op_lambda2
")"" "*"->"" "*"{"{TRAIL} op_lambda3
"="{TRAIL}  '='
//"::"{TRAIL} op_colon2

if                  keyword_if
{TRAIL}else{TRAIL}  keyword_else
skip{TRAIL}         keyword_skip
case{TRAIL}         keyword_case
emit                keyword_emit
return              keyword_return
namespace           keyword_namespace
class               keyword_class
import              keyword_import
def                 keyword_def
method              keyword_method
new                 keyword_new
nil                 keyword_nil
true                keyword_true
false               keyword_false

{WORD} identifier

{WORD}: label

{TRAIL}"|"{TRAIL}  op_bar
{TRAIL}\.{TRAIL} '.'
"("{TRAIL} '('
"["{TRAIL} '['
"{"{TRAIL} '{'
","{TRAIL} ','
";"{TRAIL} ';'
//":"{TRAIL} ':'
")"	')'
"]"	']'
"}"	'}'
"@"	'@'
"~"	'~'
"!"	'!'
"\n"             '\n'
"#"[^\n]*    skip()

(([1-9][0-9]*)|0) lit_number

(([1-9][0-9]*)|0)(\.[0-9][0-9]*)? lit_number

0x[0-9a-fA-F]+ lit_number

0o[0-7]+ lit_number

{DATE}("T"{TIME}{TZONE}?)? lit_time

\"([^\\\"]|\\.)*\"      lit_string

:{WORD} lit_symbol

\"([^\\\"]|\\.)*\": label

[ \t] skip()


%%
