//From: https://github.com/dino-lang/dino/blob/7d86688ab5a9ecee66c2b4fd18df16346361957d/MSTA/yacc.y

%token IDENTIFIER_OR_LITERAL
%token C_IDENTIFIER
%token NUMBER
%token STRING
%token CODE_INSERTION
%token YACC_CODE_INSERTION
%token ADDITIONAL_C_CODE
%token LEFT
%token RIGHT
%token NONASSOC
%token TOKEN
%token PREC
%token TYPE
%token START
%token UNION
%token LOCAL
%token IMPORT
%token EXPORT
%token SCANNER
%token EXPECT
%token CP
%token LA
%token PERCENTS
%token SEMICOLON
%token BAR
%token SLASH
%token STAR
%token PLUS
%token LESS
%token GREATER
%token LEFT_PARENTHESIS
%token RIGHT_PARENTHESIS
%token LEFT_SQUARE_BRACKET
%token RIGHT_SQUARE_BRACKET
%token AT
%token RANGE
%token RANGE_NO_LEFT_BOUND
%token RANGE_NO_RIGHT_BOUND
%token RANGE_NO_LEFT_RIGHT_BOUNDS


%start description

%%

description :
	 definitions PERCENTS rules tail
	;
tail :
	 /*empty*/
	| ADDITIONAL_C_CODE
	;
definitions :
	 /*empty*/
	| definitions definition definition_tail
	//| definitions error
	;
definition_tail :
	 /*empty*/
	| definition_semicolon_list
	;
definition_semicolon_list :
	 SEMICOLON
	| definition_semicolon_list SEMICOLON
	;
definition :
	 START IDENTIFIER_OR_LITERAL
	;
definition :
	 UNION CODE_INSERTION
	| YACC_CODE_INSERTION
	;
definition :
	 LOCAL CODE_INSERTION
	;
definition :
	 IMPORT CODE_INSERTION
	;
definition :
	 EXPORT CODE_INSERTION
	| SCANNER
	;
definition :
	 EXPECT NUMBER
	| symbol_list_start tag symbol_list
	;
symbol_list_start :
	 TOKEN
	| LEFT
	| RIGHT
	| NONASSOC
	| TYPE
	;
tag :
	 /*empty*/
	| LESS IDENTIFIER_OR_LITERAL GREATER
	;
symbol_list :
	 symbol
	| symbol_list symbol
	;
symbol :
	 IDENTIFIER_OR_LITERAL
	| IDENTIFIER_OR_LITERAL NUMBER
	;
rules :
	 rule semicolons
	| rules rule semicolons
	;
rule :
	 C_IDENTIFIER pattern
	//| error
	;
pattern :
	 alternatives
	;
alternatives :
	 alternatives BAR alternative
	| alternative
	;
alternative :
	 fix_position sequence prec_la
	;
alternative :
	 fix_position sequence prec_la SLASH sequence prec_la
	;
fix_position :
	 /*empty*/
	;
sequence :
	 /*empty*/
	| sequence sequence_element
	;
sequence_element :
	 CP
	| nonamed_sequence_element
	| nonamed_sequence_element AT IDENTIFIER_OR_LITERAL
	;
nonamed_sequence_element :
	 LEFT_SQUARE_BRACKET pattern RIGHT_SQUARE_BRACKET
	| unit STAR
	| unit PLUS
	| CODE_INSERTION code_insertion_tail
	| unit
	;
code_insertion_tail :
	 /*empty*/
	| code_insertion_semicolon_list
	;
code_insertion_semicolon_list :
	 SEMICOLON
	| code_insertion_semicolon_list SEMICOLON
	;
unit :
	 LEFT_PARENTHESIS pattern RIGHT_PARENTHESIS
	| IDENTIFIER_OR_LITERAL
	| STRING
	;
unit :
	 IDENTIFIER_OR_LITERAL RANGE IDENTIFIER_OR_LITERAL
	;
unit :
	 IDENTIFIER_OR_LITERAL RANGE_NO_LEFT_BOUND IDENTIFIER_OR_LITERAL
	;
unit :
	 IDENTIFIER_OR_LITERAL RANGE_NO_RIGHT_BOUND IDENTIFIER_OR_LITERAL
	;
unit :
	 IDENTIFIER_OR_LITERAL RANGE_NO_LEFT_RIGHT_BOUNDS IDENTIFIER_OR_LITERAL
	;
prec_la :
	 /*empty*/
	| PREC IDENTIFIER_OR_LITERAL
	| PREC IDENTIFIER_OR_LITERAL CODE_INSERTION code_insertion_tail
	| LA NUMBER
	| PREC IDENTIFIER_OR_LITERAL LA NUMBER
	| LA NUMBER PREC IDENTIFIER_OR_LITERAL
	| LA NUMBER CODE_INSERTION code_insertion_tail
	| PREC IDENTIFIER_OR_LITERAL LA NUMBER CODE_INSERTION code_insertion_tail
	| LA NUMBER PREC IDENTIFIER_OR_LITERAL CODE_INSERTION code_insertion_tail
	;
semicolons :
	 /*empty*/
	| semicolons SEMICOLON
	;

%%

IDENTIFIER	[a-zA-Z_][a-zA-Z0-9_]*

%%

[ \t\n\r]+  skip()
"/*"(?s:.)*?"*/" skip()

"%%"	PERCENTS             /* the %% mark */
";"	SEMICOLON
"|"	BAR
"/"	SLASH
"*"	STAR
"+"	PLUS
"<"	LESS
">"	GREATER
"("	LEFT_PARENTHESIS
")"	RIGHT_PARENTHESIS
"["	LEFT_SQUARE_BRACKET
"]"	RIGHT_SQUARE_BRACKET
"@"	AT
"-"	RANGE
"<-"	RANGE_NO_LEFT_BOUND
"->"	RANGE_NO_RIGHT_BOUND
"<->"	RANGE_NO_LEFT_RIGHT_BOUNDS

"%left"	LEFT
"%right"	RIGHT
"%nonassoc"	NONASSOC
"%token"	TOKEN
"%prec"	PREC
"%type"	TYPE
"%start"	START
"%union"	UNION
"%local"	LOCAL
"%import"	IMPORT
"%export"	EXPORT
"%scanner"	SCANNER
"%expect"	EXPECT
"%cp"	CP
"%la"	LA

[a-zA-Z_][a-zA-Z0-9_.]*	IDENTIFIER_OR_LITERAL
[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*:	C_IDENTIFIER
[0-9][0-9]*	NUMBER
\"(\\.|[^\"\n\r\\])+\"|'(\\.|[^'\n\r\\])'	STRING
\{(?s:.)*?\}	CODE_INSERTION
\%\{(?s:.)*?\%\}	YACC_CODE_INSERTION
/*\%\%(?s:.)*	ADDITIONAL_C_CODE*/

%%
