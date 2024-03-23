//From: https://github.com/kfsone/parseland/blob/ab99531b550d90c1a5b0a9ec6e79009d873c6293/flexbison/parser.yy

// Declaration of tokens and for those with types, what value type they have.
//%token YYEOF			0			"end of file"
%token KW_ENUM						//"'enum' keyword"
%token KW_TYPE						//"'type' keyword"
%token KW_TRUE						//"'true'"
%token KW_FALSE					//"'false'"

%token SCOPE						//"scope operator ('::')"
%token COLON						//"colon (':')"
%token LBRACE						//"left brace ('{')"
%token RBRACE						//"right brace ('}')"
%token LBRACKET					//"left bracket ('[')"
%token RBRACKET					//"right bracket (']')"
%token EQUALS 						//"equals ('=')"
%token COMMA						//"comma (',')"

%token FLOAT						//"floating-point number"
%token INTEGER						//"integer"
%token IDENTIFIER					//"identifier"
%token STRING						//"string literal"


%%

// Grammar proper

root :
	definition
	| root definition
	;

definition :
	enum_definition
	| type_definition
	;

enum_definition :
	KW_ENUM IDENTIFIER LBRACE enum_values RBRACE
	;

enum_values :
	%empty
	| enum_values enum_value
	;

enum_value :
	IDENTIFIER COMMA
	| IDENTIFIER
	;


type_definition :
	KW_TYPE IDENTIFIER type_parent LBRACE member_definitions RBRACE
	;

type_parent :
	%empty
	| COLON IDENTIFIER
	;

member_definitions :
	%empty		/* no members, legal */
	| member_definitions member_definition
	;


member_definition :
	type type_var
	| type type_var EQUALS value
	;

type_var :
    IDENTIFIER
    | IDENTIFIER LBRACKET RBRACKET
    ;

type :
    IDENTIFIER
    ;

value :
	bool_value
	| float_value
	| integer_value
	| string_value
	| compound_value
	| qualified_ident
	;


bool_value :
	KW_TRUE
	| KW_FALSE
	;

float_value :
	FLOAT
	;

integer_value :
	INTEGER
	;

string_value :
	STRING
	;

compound_value :
	LBRACE member_definitions RBRACE
	;

qualified_ident :
    IDENTIFIER
    | qualified_ident SCOPE IDENTIFIER
    ;

%%

%x BLOCK_COMMENT STRING

// Named pattern fragments
digit	[0-9]
sign	[+-]
decimalval	\.{digit}
float	{sign}?({digit}+\.{digit}*|\.{digit}+)
integer	{sign}?{digit}+

%%

// Nestable block coments
<INITIAL,BLOCK_COMMENT>"/*"<>BLOCK_COMMENT>
<BLOCK_COMMENT>{
	"/*"<>BLOCK_COMMENT>
	"*/"<<>	skip()
	.<.>
	//<<EOF>>			{ report_error(*yylloc, "unterminated block comment, did you forget the '*/'?"); return YYEOF; }
}

// Line comments
"//"[^\n]*	skip()				/* ignore line comment */


// Keywords
"enum"	KW_ENUM
"type"	KW_TYPE
"false"	KW_FALSE
"true"	KW_TRUE

/* Symbols */
"::"	SCOPE
":"	COLON
"{"	LBRACE
"}"	RBRACE
"["	LBRACKET
"]"	RBRACKET
"="	EQUALS
","	COMMA

// Abstract terminals
{float}	FLOAT
{integer}	INTEGER
[A-Za-z_][A-Za-z0-9_]*	IDENTIFIER

// String literal
<INITIAL>"\""<STRING>
<STRING>{
	"\\[\\\"0-9A-Za-z_]"<.>
	//"\\."					{ report_error(*yylloc, "invalid escape in string literal"); return YYEOF; }
	[^\\\"]+<.>				/* todo */
	"\""<INITIAL>	STRING
	//<<EOF>>					{ report_error(*yylloc, "unterminated string literal"); return YYEOF; }
}

//<*><<EOF>>						return YYEOF;

// Whitespace
[ \t\r]+	skip()						/*ignore*/
<*>\n	skip()

//.								{ report_error(*yylloc, "unexpected character: " + std::string(yytext)); }

%%
