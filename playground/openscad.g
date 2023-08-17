//From: https://github.com/openscad/openscad/blob/2835e35fa93a36ffa757c5b80d95b0ed49703fc1/src/core/parser.y

%x cond_comment cond_lcomment cond_string
%x cond_include
%x cond_use

%token ILLEGAL_CHARACTER

/*Tokens*/
//%token TOK_ERROR
%token TOK_EOT
%token TOK_MODULE
%token TOK_FUNCTION
%token TOK_IF
%token TOK_ELSE
%token TOK_FOR
%token TOK_LET
%token TOK_ASSERT
%token TOK_ECHO
%token TOK_EACH
%token TOK_ID
%token TOK_STRING
%token TOK_USE
%token TOK_NUMBER
%token TOK_TRUE
%token TOK_FALSE
%token TOK_UNDEF
%token LE
%token GE
%token EQ
%token NEQ
%token AND
%token OR
%token NO_ELSE
%token ';'
%token '{'
%token '}'
%token '('
%token ')'
%token '='
%token '!'
%token '#'
%token '%'
%token '*'
%token '?'
%token ':'
%token '>'
%token '<'
%token '+'
%token '-'
%token '/'
%token '^'
%token '['
%token ']'
%token '.'
%token ','

%nonassoc /*1*/ NO_ELSE
%nonassoc /*2*/ TOK_ELSE

%start input

%%

input :
	/*empty*/
	| input TOK_USE
	| input statement
	;

statement :
	';'
	| '{' inner_input '}'
	| module_instantiation
	| assignment
	| TOK_MODULE TOK_ID '(' parameters ')' statement
	| TOK_FUNCTION TOK_ID '(' parameters ')' '=' expr ';'
	| TOK_EOT
	;

inner_input :
	/*empty*/
	| inner_input statement
	;

assignment :
	TOK_ID '=' expr ';'
	;

module_instantiation :
	'!' module_instantiation
	| '#' module_instantiation
	| '%' module_instantiation
	| '*' module_instantiation
	| single_module_instantiation child_statement
	| ifelse_statement
	;

ifelse_statement :
	if_statement %prec NO_ELSE /*1N*/
	| if_statement TOK_ELSE /*2N*/ child_statement
	;

if_statement :
	TOK_IF '(' expr ')' child_statement
	;

child_statements :
	/*empty*/
	| child_statements child_statement
	| child_statements assignment
	;

child_statement :
	';'
	| '{' child_statements '}'
	| module_instantiation
	;

module_id :
	TOK_ID
	| TOK_FOR
	| TOK_LET
	| TOK_ASSERT
	| TOK_ECHO
	| TOK_EACH
	;

single_module_instantiation :
	module_id '(' arguments ')'
	;

expr :
	logic_or
	| TOK_FUNCTION '(' parameters ')' expr %prec NO_ELSE /*1N*/
	| logic_or '?' expr ':' expr
	| TOK_LET '(' arguments ')' expr
	| TOK_ASSERT '(' arguments ')' expr_or_empty
	| TOK_ECHO '(' arguments ')' expr_or_empty
	;

logic_or :
	logic_and
	| logic_or OR logic_and
	;

logic_and :
	equality
	| logic_and AND equality
	;

equality :
	comparison
	| equality EQ comparison
	| equality NEQ comparison
	;

comparison :
	addition
	| comparison '>' addition
	| comparison GE addition
	| comparison '<' addition
	| comparison LE addition
	;

addition :
	multiplication
	| addition '+' multiplication
	| addition '-' multiplication
	;

multiplication :
	unary
	| multiplication '*' unary
	| multiplication '/' unary
	| multiplication '%' unary
	;

unary :
	exponent
	| '+' unary
	| '-' unary
	| '!' unary
	;

exponent :
	call
	| call '^' unary
	;

call :
	primary
	| call '(' arguments ')'
	| call '[' expr ']'
	| call '.' TOK_ID
	;

primary :
	TOK_TRUE
	| TOK_FALSE
	| TOK_UNDEF
	| TOK_NUMBER
	| TOK_STRING
	| TOK_ID
	| '(' expr ')'
	| '[' expr ':' expr ']'
	| '[' expr ':' expr ':' expr ']'
	| '[' ']'
	| '[' vector_elements optional_trailing_comma ']'
	;

expr_or_empty :
	/*empty*/
	| expr
	;

list_comprehension_elements :
	TOK_LET '(' arguments ')' list_comprehension_elements_p
	| TOK_EACH vector_element
	| TOK_FOR '(' arguments ')' vector_element
	| TOK_FOR '(' arguments ';' expr ';' arguments ')' vector_element
	| TOK_IF '(' expr ')' vector_element %prec NO_ELSE /*1N*/
	| TOK_IF '(' expr ')' vector_element TOK_ELSE /*2N*/ vector_element
	;

list_comprehension_elements_p :
	list_comprehension_elements
	| '(' list_comprehension_elements ')'
	;

optional_trailing_comma :
	/*empty*/
	| ','
	;

vector_elements :
	vector_element
	| vector_elements ',' vector_element
	;

vector_element :
	list_comprehension_elements_p
	| expr
	;

parameters :
	/*empty*/
	| parameter_list optional_trailing_comma
	;

parameter_list :
	parameter
	| parameter_list ',' parameter
	;

parameter :
	TOK_ID
	| TOK_ID '=' expr
	;

arguments :
	/*empty*/
	| argument_list optional_trailing_comma
	;

argument_list :
	argument
	| argument_list ',' argument
	;

argument :
	expr
	| TOK_ID '=' expr
	;

%%

D [0-9]
E [Ee][+-]?{D}+
H [0-9a-fA-F]

U       [\x80-\xbf]
U2      [\xc2-\xdf]
U3      [\xe0-\xef]
U4      [\xf0-\xf4]
UNICODE {U2}{U}|{U3}{U}{U}|{U4}{U}{U}{U}

%%

<INITIAL>include[ \t\r\n]*"<"<cond_include>
<cond_include>[\n\r]<.>	skip()
<cond_include>[^\t\r\n>]*"/"<.>
<cond_include>[^\t\r\n>/]+<.>
<cond_include>">"<INITIAL>	skip()


<INITIAL>use[ \t\r\n]*"<"<cond_use>
<cond_use>[\n\r]<.>	skip()
<cond_use>[^\t\r\n>]+<.>
<cond_use>">"<INITIAL>		TOK_USE

<INITIAL>\"<cond_string>
<cond_string>\\n<.>
<cond_string>\\t<.>
<cond_string>\\r<.>
<cond_string>\\\\<.>
<cond_string>\\\"<.>
<cond_string>{UNICODE}<.>
<cond_string>\\x[0-7]{H}<.>
<cond_string>\\u{H}{4}|\\U{H}{6}<.>
<cond_string>[^\\\n\"]<.>
<cond_string>[\n\r]<.>
<cond_string>\"<INITIAL>	TOK_STRING

[\t ]	skip()
[\n\r]	skip()

<INITIAL>\/\/<cond_lcomment>
<cond_lcomment>\n<INITIAL>	skip()
<cond_lcomment>{UNICODE}<.>	skip()
<cond_lcomment>[^\n]<.>	skip()


<INITIAL>"/*"<cond_comment>
<cond_comment>"*/"<INITIAL>
<cond_comment>{UNICODE}<.>	skip()
<cond_comment>(?s:.)<.>	skip()
/*<cond_comment>eoi<.>	TOK_ERROR*/


"\x03"		TOK_EOT

"module"	TOK_MODULE
"function"	TOK_FUNCTION
"if"		TOK_IF
"else"		TOK_ELSE
"let"		TOK_LET
"assert"	TOK_ASSERT
"echo"	        TOK_ECHO
"for"		TOK_FOR
"each"		TOK_EACH

"true"		TOK_TRUE
"false"		TOK_FALSE
"undef"		TOK_UNDEF

/*
 U+00A0 (UTF-8 encoded: C2A0) is no-break space. We support it since Qt's QTextEdit
 automatically converts these to spaces and we want to be able to process the same
 files on the cmd-line as in the editor.
*/

[\xc2\xa0]+	skip()

/*{UNICODE}+              TOK_ERROR*/

{D}+{E}?|{D}*\.{D}+{E}?|{D}+\.{D}*{E}?        TOK_NUMBER
"$"?[a-zA-Z0-9_]+       TOK_ID

"<="	LE
">="	GE
"=="	EQ
"!="	NEQ
"&&"	AND
"||"	OR

";"	';'
"{"	'{'
"}"	'}'
"("	'('
")"	')'
"="	'='
"!"	'!'
"#"	'#'
"%"	'%'
"*"	'*'
"?"	'?'
":"	':'
">"	'>'
"<"	'<'
"+"	'+'
"-"	'-'
"/"	'/'
"^"	'^'
"["	'['
"]"	']'
"."	'.'
","	','

. 	ILLEGAL_CHARACTER

%%
