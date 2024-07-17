// /home/mingo/dev/c/A_grammars/lalr/lalr-nb/dist/Release/GNU-Linux/lalr-nb bison.g


//%error_recovery_show;
//%error_recovery_off;


/*Tokens*/
%token STRING
%token TSTRING
//%token PERCENT_TOKEN
//%token PERCENT_NTERM
//%token PERCENT_TYPE
//%token PERCENT_DESTRUCTOR
//%token PERCENT_PRINTER
//%token PERCENT_LEFT
//%token PERCENT_RIGHT
//%token PERCENT_NONASSOC
//%token PERCENT_PRECEDENCE
//%token PERCENT_PREC
//%token PERCENT_DPREC
//%token PERCENT_MERGE
//%token PERCENT_CODE
//%token PERCENT_DEFAULT_PREC
//%token PERCENT_DEFINE
//%token PERCENT_ERROR_VERBOSE
//%token PERCENT_EXPECT
//%token PERCENT_EXPECT_RR
//%token PERCENT_FILE_PREFIX
//%token PERCENT_FLAG
//%token PERCENT_GLR_PARSER
//%token PERCENT_HEADER
//%token PERCENT_INITIAL_ACTION
//%token PERCENT_LANGUAGE
//%token PERCENT_NAME_PREFIX
//%token PERCENT_NO_DEFAULT_PREC
//%token PERCENT_NO_LINES
//%token PERCENT_NONDETERMINISTIC_PARSER
//%token PERCENT_OUTPUT
//%token PERCENT_PURE_PARSER
//%token PERCENT_REQUIRE
//%token PERCENT_SKELETON
//%token PERCENT_START
//%token PERCENT_TOKEN_TABLE
//%token PERCENT_VERBOSE
//%token PERCENT_YACC
//%token BRACED_CODE
//%token BRACED_PREDICATE
%token BRACKETED_ID
%token CHAR_LITERAL
//%token COLON
%token EPILOGUE
//%token EQUAL
%token ID
%token ID_COLON
//%token PERCENT_PERCENT
//%token PIPE
//%token PROLOGUE
//%token SEMICOLON
%token TAG
//%token TAG_ANY
//%token TAG_NONE
%token INT_LITERAL
//%token PERCENT_PARAM
//%token PERCENT_UNION
//%token PERCENT_EMPTY

%token SECTION_MARK ACTION_CODE VERBATIN_CODE

%start input

%%

input :
	prologue_declarations SECTION_MARK grammar epilogue_opt
	;

prologue_declarations :
	%empty
	| prologue_declarations prologue_declaration
	;

prologue_declaration :
	grammar_declaration
	| VERBATIN_CODE
	| "%<flag>"
	| "%define" variable value
	| "%header" string_opt
	| "%error-verbose"
	| "%expect" INT_LITERAL
	| "%expect-rr" INT_LITERAL
	| "%file-prefix" STRING
	| "%glr-parser"
	| "%initial-action" ACTION_CODE
	| "%language" STRING
	| "%name-prefix" STRING
	| "%no-lines"
	| "%nondeterministic-parser"
	| "%output" STRING
	| "%param" params
	| "%pure-parser"
	| "%require" STRING
	| "%skeleton" STRING
	| "%token-table"
	| "%verbose"
	| "%yacc"
	//| error ';'
	| ';'
	;

params :
	params ACTION_CODE
	| ACTION_CODE
	;

grammar_declaration :
	symbol_declaration
	| "%start" symbols_1
	| code_props_type ACTION_CODE generic_symlist
	| "%default-prec"
	| "%no-default-prec"
	| "%code" ACTION_CODE
	| "%code" ID ACTION_CODE
	;

code_props_type :
	"%destructor"
	| "%printer"
	;

union_name :
	%empty
	| ID
	;

grammar_declaration :
	"%union" union_name ACTION_CODE
	;

symbol_declaration :
	"%nterm" nterm_decls
	| "%token" token_decls
	| "%type" symbol_decls
	| precedence_declarator token_decls_for_prec
	;

precedence_declarator :
	"%left"
	| "%right"
	| "%nonassoc"
	| "%precedence"
	;

string_opt :
	%empty
	| STRING
	;

tag_opt :
	%empty
	| TAG
	;

generic_symlist :
	generic_symlist_item
	| generic_symlist generic_symlist_item
	;

generic_symlist_item :
	symbol
	| tag
	;

tag :
	TAG
	//| "<*>"
	//| "<>"
	;

nterm_decls :
	token_decls
	;

token_decls :
	token_decl_1
	| TAG token_decl_1
	| token_decls TAG token_decl_1
	;

token_decl_1 :
	token_decl
	| token_decl_1 token_decl
	;

token_decl :
	id int_opt alias
	;

int_opt :
	%empty
	| INT_LITERAL
	;

alias :
	%empty
	| string_as_id
	| TSTRING
	;

token_decls_for_prec :
	token_decl_for_prec_1
	| TAG token_decl_for_prec_1
	| token_decls_for_prec TAG token_decl_for_prec_1
	;

token_decl_for_prec_1 :
	token_decl_for_prec
	| token_decl_for_prec_1 token_decl_for_prec
	;

token_decl_for_prec :
	id int_opt
	| string_as_id
	;

symbol_decls :
	symbols_1
	| TAG symbols_1
	| symbol_decls TAG symbols_1
	;

symbols_1 :
	symbol
	| symbols_1 symbol
	;

grammar :
	rules_or_grammar_declaration
	| grammar rules_or_grammar_declaration
	;

rules_or_grammar_declaration :
	rules
	| grammar_declaration ';'
	//| error ';'
	;

rules :
	id_colon rhses_1 ';'
	| id_colon named_ref_opt ':' rhses_1 ';'
	;

rhses_1 :
	rhs
	| rhses_1 '|' rhs
	;

rhs :
	%empty
	| rhs symbol named_ref_opt
	| rhs tag_opt ACTION_CODE named_ref_opt
	| rhs "%?{...}"
	| rhs "%empty"
	| rhs "%prec" symbol
	| rhs "%dprec" INT_LITERAL
	| rhs "%merge" TAG
	| rhs "%expect" INT_LITERAL
	| rhs "%expect-rr" INT_LITERAL
	;

named_ref_opt :
	%empty
	| BRACKETED_ID
	;

variable :
	ID
	;

value :
	%empty
	| ID
	| STRING
	| ACTION_CODE
	;

id :
	ID
	| CHAR_LITERAL
	;

id_colon :
	ID_COLON
	;

symbol :
	id
	| string_as_id
	;

string_as_id :
	STRING
	;

epilogue_opt :
	%empty
	| SECTION_MARK
	| SECTION_MARK EPILOGUE
	;

%%

%x RULES_ST EPILOGUE_ST ACTION_CODE_ST

/*Macros*/

SPACES	[ \t\r\n]+
COMMENT	"//"[^\r\n]*
C_STYLE_COMMENT [/][*](?s:.)*?[*][/]

STRING	\"(\\.|[^\"\n\r\\])*\"
ACTION_CODE [{](?s:.)*?[}]
VERBATIN_CODE "%{"(?s:.)*?"%}"

ID	[a-zA-Z_][a-zA-Z_.0-9-]*

%%
/*Lexer*/

<INITIAL>"%%"<RULES_ST>	SECTION_MARK
<RULES_ST>"%%"<EPILOGUE_ST>	SECTION_MARK
<EPILOGUE_ST>(?s:.)+   EPILOGUE

<INITIAL,RULES_ST> {
    {SPACES} skip()
    {COMMENT}	skip()
    {C_STYLE_COMMENT}	skip()

    "%<flag>"	"%<flag>"
    "%define"	"%define"
    "%header"	"%header"
    "%error-verbose"	"%error-verbose"
    "%expect"	"%expect"
    "%expect-rr"	"%expect-rr"
    "%file-prefix"	"%file-prefix"
    "%glr-parser"	"%glr-parser"
    "%initial-action"	"%initial-action"
    "%language"	"%language"
    "%name-prefix"	"%name-prefix"
    "%no-lines"	"%no-lines"
    "%output"	"%output"
    "%param"	"%param"
    "%pure-parser"	"%pure-parser"
    "%require"	"%require"
    "%skeleton"	"%skeleton"
    "%token-table"	"%token-table"
    "%verbose"	"%verbose"
    "%yacc"	"%yacc"
    ";"	';'
    "%start"	"%start"
    "%default-prec"	"%default-prec"
    "%no-default-prec"	"%no-default-prec"
    "%code"	"%code"
    "%destructor"	"%destructor"
    "%printer"	"%printer"
    "%union"	"%union"
    "%nterm"	"%nterm"
    "%token"	"%token"
    "%type"	"%type"
    "%left"	"%left"
    "%right"	"%right"
    "%nonassoc"	"%nonassoc"
    "%precedence"	"%precedence"
    ":"	':'
    "|"	'|'
    "%?{...}"	"%?{...}"
    "%empty"	"%empty"
    "%prec"	"%prec"
    "%dprec"	"%dprec"
    "%merge"	"%merge"
    "%nondeterministic-parser"	"%nondeterministic-parser"

    [0-9]+	INT_LITERAL
    {STRING}	STRING
    "_("{STRING}")"	TSTRING
    \<[^>]*>	TAG
    '(\\.|[^'\n\r\\])'	CHAR_LITERAL

    "{"<>ACTION_CODE_ST>
    {VERBATIN_CODE}	VERBATIN_CODE

    /* Order matter if identifier comes before keywords they are classified as identifier */
    /*ID_COLON : ID ':' */
    {ID}[[:space:]]*\:	ID_COLON /*Order matter, need be before ID*/
    {ID}	ID
    /*BRACKETED_ID : '[' ID ']' ;*/
    \[{ID}\]	BRACKETED_ID
}

<ACTION_CODE_ST> {
    "{"<>ACTION_CODE_ST>
    "}"<<> ACTION_CODE
    (?s:.)<.>
}

%%
