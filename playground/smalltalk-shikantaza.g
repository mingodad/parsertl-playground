//From: https://github.com/shikantaza/smalltalk/blob/39b8f8981eb3accced302d0c85bbb403169dc96a/src/parser.y

/*Tokens*/
%token T_ASSIGNMENT_OPERATOR
%token T_BINARY_SELECTOR
%token T_COLON
//%token T_COMMENT
%token T_FLOAT
%token T_HASH
%token T_HASHED_STRING
%token T_IDENTIFIER
%token T_INTEGER
%token T_KEYWORD
%token T_LEFT_PAREN
%token T_LEFT_SQUARE_BRACKET
//%token T_MINUS
%token T_PERIOD
%token T_QUOTED_CHARACTER
%token T_QUOTED_SELECTOR
%token T_QUOTED_STRING
%token T_RETURN_OPERATOR
%token T_RIGHT_PAREN
%token T_RIGHT_SQUARE_BRACKET
%token T_SCALED_DECIMAL
%token T_SEMI_COLON
%token T_VERTICAL_BAR


%start executable_code

%%

executable_code :
	temporaries statements
	| temporaries
	| statements
	;

temporaries :
	T_VERTICAL_BAR identifiers T_VERTICAL_BAR
	;

identifiers :
	/*empty*/
	| identifiers T_IDENTIFIER
	;

statements :
	return_statement
	| return_statement T_PERIOD
	| expression
	| expression T_PERIOD statements
	;

return_statement :
	T_RETURN_OPERATOR expression
	;

expression :
	assignment
	| basic_expression
	;

assignment :
	T_IDENTIFIER T_ASSIGNMENT_OPERATOR expression
	;

basic_expression :
	primary
	| primary message cascaded_messages
	;

primary :
	T_IDENTIFIER
	| literal
	| block_constructor
	| T_LEFT_PAREN expression T_RIGHT_PAREN
	;

block_constructor :
	T_LEFT_SQUARE_BRACKET block_argument block_arguments T_VERTICAL_BAR executable_code T_RIGHT_SQUARE_BRACKET
	| T_LEFT_SQUARE_BRACKET executable_code T_RIGHT_SQUARE_BRACKET
	;

block_arguments :
	/*empty*/
	| block_arguments block_argument
	;

block_argument :
	T_COLON T_IDENTIFIER
	;

message :
	unary_message unary_messages binary_messages
	| unary_message unary_messages binary_messages keyword_message
	| binary_message binary_messages
	| binary_message binary_messages keyword_message
	| keyword_message
	;

unary_message :
	T_IDENTIFIER
	;

unary_messages :
	/*empty*/
	| unary_messages unary_message
	;

binary_messages :
	/*empty*/
	| binary_messages binary_message
	;

binary_message :
	T_BINARY_SELECTOR binary_argument
	;

binary_argument :
	primary unary_messages
	;

keyword_message :
	keyword_arg_pair keyword_arg_pairs
	;

keyword_argument :
	primary unary_messages binary_messages
	;

keyword_arg_pair :
	T_KEYWORD keyword_argument
	;

keyword_arg_pairs :
	/*empty*/
	| keyword_arg_pairs keyword_arg_pair
	;

cascaded_messages :
	/*empty*/
	| cascaded_messages cascaded_message
	;

cascaded_message :
	T_SEMI_COLON message
	;

literal :
	number
	| string_literal
	| character_literal
	| symbol_literal
	| selector_literal
	| array_literal
	;

number :
	T_INTEGER
	| T_FLOAT
	| T_SCALED_DECIMAL
	;

character_literal :
	T_QUOTED_CHARACTER
	;

string_literal :
	T_QUOTED_STRING
	;

symbol_literal :
	T_HASHED_STRING
	;

selector_literal :
	T_QUOTED_SELECTOR
	;

array_literal :
	T_HASH T_LEFT_PAREN array_elements T_RIGHT_PAREN
	;

array_elements :
	/*empty*/
	| array_elements array_element
	;

array_element :
	literal
	| T_IDENTIFIER
	;

%%

ID	[a-zA-Z][a-zA-Z_0-9]*
STR	'("''"|[^'])*\'

%%

[ \t\r\n\v\f]+	skip()
\"(\\.|[^"\\])*\"   skip() /* ignore comments */

":="	T_ASSIGNMENT_OPERATOR
":"	T_COLON
//T_COMMENT	T_COMMENT
"#"	T_HASH
"("	T_LEFT_PAREN
"["	T_LEFT_SQUARE_BRACKET
//T_MINUS	T_MINUS
"."	T_PERIOD
"^"	T_RETURN_OPERATOR
")"	T_RIGHT_PAREN
"]"	T_RIGHT_SQUARE_BRACKET
";"	T_SEMI_COLON
"|"	T_VERTICAL_BAR

"#"([a-zA-Z][a-zA-Z_0-9]*|(!|%|&|\*|\+|,|\/|<|=|>|\?|@|\\|~|\||-)+|([a-zA-Z_][a-zA-Z_0-9]*:)+)	T_QUOTED_SELECTOR
"#"{STR}	T_HASHED_STRING
{STR}	T_QUOTED_STRING
"$".	T_QUOTED_CHARACTER

(!|%|&|\*|\+|,|\/|<|=|>|\?|@|\\|~|-)+	T_BINARY_SELECTOR
[-]?[0-9]+|[0-9]+r[0-9A-Z]+	T_INTEGER
[-]?[0-9]+\.[0-9]+((e|d|q)[-]?[0-9]+)?	T_FLOAT
([-]?[0-9]+\.[0-9]+|[-]?[0-9]+)s[0-9]+	T_SCALED_DECIMAL

{ID}":"	T_KEYWORD
{ID}	T_IDENTIFIER

%%
