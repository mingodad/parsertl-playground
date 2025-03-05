//From: https://github.com/skycoin/cx/blob/1ac5024d59b06d6caa6ff846da4039cdecb72cde/cxparser/cxpartialparsing/cxpartialparsing.y

// Notice that automatic semicolon isn't working

/*Tokens*/
%token ADD_ASSIGN
%token ADD_OP
//%token ADDR
%token AFF
//%token AFFVAR
//%token AND
%token AND_ASSIGN
%token AND_OP
%token ASSIGN
//%token BASICTYPE
//%token BITANDEQ
%token BITCLEAR_OP
//%token BITOREQ
%token BITOR_OP
//%token BITXOREQ
%token BITXOR_OP
%token BOOL
%token BOOLEAN_LITERAL
%token BREAK
%token BYTE_LITERAL
//%token CAFF
%token CASE
%token CASSIGN
//%token CLAUSES
%token COLON
%token COMMA
//%token COMMENT
//%token CONST
%token CONTINUE
%token DEC_OP
//%token DEF
%token DEFAULT
%token DIV_ASSIGN
//%token DIVEQ
%token DIV_OP
%token DOUBLE_LITERAL
//%token DPROGRAM
//%token DSTACK
//%token DSTATE
%token ELSE
//%token ENUM
%token EQ_OP
//%token EQUAL
//%token EQUALWORD
//%token EXP
//%token EXPEQ
//%token EXPR
%token F32
%token F64
//%token FIELD
%token FLOAT_LITERAL
%token FOR
%token FUNC
//%token GE_OP
%token GOTO
%token GTEQ_OP
//%token GTHANEQ
//%token GTHANWORD
%token GT_OP
%token I16
%token I32
%token I64
%token I8
%token IDENTIFIER
%token IF
%token IMPORT
%token INC_OP
%token INFER
%token INT_LITERAL
%token LBRACE
%token LBRACK
%token LEFT_ASSIGN
%token LEFT_OP
//%token LEFTSHIFT
//%token LEFTSHIFTEQ
//%token LE_OP
%token LONG_LITERAL
%token LPAREN
%token LTEQ_OP
//%token LTHANEQ
//%token LTHANWORD
%token LT_OP
//%token MINUSEQ
//%token MINUSMINUS
%token MOD_ASSIGN
%token MOD_OP
%token MUL_ASSIGN
%token MUL_OP
//%token MULTEQ
%token NEG_OP
%token NE_OP
//%token NEW
//%token NEWLINE
//%token NOT
//%token OBJECT
//%token OBJECTS
//%token OP
//%token OR
%token OR_ASSIGN
%token OR_OP
%token PACKAGE
%token PERIOD
//%token PLUSEQ
//%token PLUSPLUS
//%token PTR_OP
%token RBRACE
%token RBRACK
%token REF_OP
//%token REM
//%token REMAINDER
//%token REMAINDEREQ
%token RETURN
%token RIGHT_ASSIGN
%token RIGHT_OP
//%token RIGHTSHIFT
//%token RIGHTSHIFTEQ
%token RPAREN
%token SEMICOLON
%token SHORT_LITERAL
%token STR
%token STRING_LITERAL
%token STRUCT
%token SUB_ASSIGN
%token SUB_OP
%token SWITCH
//%token TAG
%token TYPE
//%token TYPSTRUCT
%token UI16
%token UI32
%token UI64
%token UI8
//%token UNEQUAL
//%token UNION
%token UNSIGNED_BYTE_LITERAL
%token UNSIGNED_INT_LITERAL
%token UNSIGNED_LONG_LITERAL
%token UNSIGNED_SHORT_LITERAL
//%token VALUE
%token VAR
%token XOR_ASSIGN
//%token yyDefault

%right /*1*/ LBRACE IDENTIFIER

%start translation_unit

%%

translation_unit :
	external_declaration
	| translation_unit external_declaration
	;

external_declaration :
	package_declaration
	| global_declaration
	| function_declaration
	| import_declaration
	| struct_declaration
	;

global_declaration :
	VAR declarator declaration_specifiers SEMICOLON
	| VAR declarator declaration_specifiers ASSIGN initializer SEMICOLON
	;

struct_declaration :
	TYPE IDENTIFIER /*1R*/ STRUCT struct_fields
	;

struct_fields :
	LBRACE /*1R*/ RBRACE SEMICOLON
	| LBRACE /*1R*/ fields RBRACE SEMICOLON
	;

fields :
	parameter_declaration SEMICOLON
	| fields parameter_declaration SEMICOLON
	;

package_declaration :
	PACKAGE IDENTIFIER /*1R*/ SEMICOLON
	;

import_declaration :
	IMPORT STRING_LITERAL SEMICOLON
	;

function_header :
	FUNC IDENTIFIER /*1R*/
	| FUNC LPAREN parameter_type_list RPAREN IDENTIFIER /*1R*/
	;

function_parameters :
	LPAREN RPAREN
	| LPAREN parameter_type_list RPAREN
	;

function_declaration :
	function_header function_parameters compound_statement
	| function_header function_parameters function_parameters compound_statement
	;

parameter_type_list :
	parameter_list
	;

parameter_list :
	parameter_declaration
	| parameter_list COMMA parameter_declaration
	;

parameter_declaration :
	declarator declaration_specifiers
	;

//identifier_list :
//	IDENTIFIER /*1R*/
//	| identifier_list COMMA IDENTIFIER /*1R*/
//	;

declarator :
	direct_declarator
	;

direct_declarator :
	IDENTIFIER /*1R*/
	| LPAREN declarator RPAREN
	;

id_list :
	IDENTIFIER /*1R*/
	| type_specifier
	| id_list COMMA IDENTIFIER /*1R*/
	| id_list COMMA type_specifier
	;

types_list :
	LPAREN id_list RPAREN
	| LPAREN RPAREN
	;

declaration_specifiers :
	FUNC types_list types_list
	| MUL_OP declaration_specifiers
	| LBRACK RBRACK declaration_specifiers
	| type_specifier
	| IDENTIFIER /*1R*/
	| indexing_literal type_specifier
	| indexing_literal IDENTIFIER /*1R*/
	| IDENTIFIER /*1R*/ PERIOD IDENTIFIER /*1R*/
	| type_specifier PERIOD IDENTIFIER /*1R*/
	;

type_specifier :
	AFF
	| BOOL
	| STR
	| F32
	| F64
	| I8
	| I16
	| I32
	| I64
	| UI8
	| UI16
	| UI32
	| UI64
	;

struct_literal_fields :
	/*empty*/
	| IDENTIFIER /*1R*/ COLON constant_expression
	| struct_literal_fields COMMA IDENTIFIER /*1R*/ COLON constant_expression
	;

array_literal_expression_list :
	assignment_expression
	| LBRACE /*1R*/ array_literal_expression_list RBRACE
	| array_literal_expression_list COMMA assignment_expression
	;

indexing_literal :
	LBRACK INT_LITERAL RBRACK
	| indexing_literal LBRACK INT_LITERAL RBRACK
	;

//indexing_slice_literal :
//	LBRACK RBRACK
//	| indexing_slice_literal LBRACK RBRACK
//	;

array_literal_expression :
	indexing_literal IDENTIFIER /*1R*/ LBRACE /*1R*/ array_literal_expression_list RBRACE
	| indexing_literal IDENTIFIER /*1R*/ LBRACE /*1R*/ RBRACE
	| indexing_literal type_specifier LBRACE /*1R*/ array_literal_expression_list RBRACE
	| indexing_literal type_specifier LBRACE /*1R*/ RBRACE
	;

slice_literal_expression :
	LBRACK RBRACK IDENTIFIER /*1R*/ LBRACE /*1R*/ argument_expression_list RBRACE
	| LBRACK RBRACK IDENTIFIER /*1R*/ LBRACE /*1R*/ RBRACE
	| LBRACK RBRACK type_specifier LBRACE /*1R*/ argument_expression_list RBRACE
	| LBRACK RBRACK type_specifier LBRACE /*1R*/ RBRACE
	| LBRACK RBRACK slice_literal_expression
	;

infer_action_arg :
	IDENTIFIER /*1R*/
	| INT_LITERAL
	| type_specifier PERIOD IDENTIFIER /*1R*/
	;

infer_action :
	IDENTIFIER /*1R*/ LPAREN infer_action_arg COMMA IDENTIFIER /*1R*/ RPAREN
	| IDENTIFIER /*1R*/ LPAREN infer_action_arg RPAREN
	| IDENTIFIER /*1R*/ LPAREN infer_action RPAREN
	| IDENTIFIER /*1R*/ LPAREN infer_action COMMA infer_action RPAREN
	;

infer_actions :
	infer_action SEMICOLON
	| infer_actions infer_action SEMICOLON
	;

infer_clauses :
	/*empty*/
	| infer_actions
	;

//int_value :
//	INT_LITERAL
//	| SUB_OP INT_LITERAL
//	;

primary_expression :
	IDENTIFIER /*1R*/
	| INFER LBRACE /*1R*/ infer_clauses RBRACE
	| STRING_LITERAL
	| BOOLEAN_LITERAL
	| BYTE_LITERAL
	| SHORT_LITERAL
	| INT_LITERAL
	| LONG_LITERAL
	| UNSIGNED_BYTE_LITERAL
	| UNSIGNED_SHORT_LITERAL
	| UNSIGNED_INT_LITERAL
	| UNSIGNED_LONG_LITERAL
	| FLOAT_LITERAL
	| DOUBLE_LITERAL
	| LPAREN expression RPAREN
	| array_literal_expression
	| slice_literal_expression
	;

after_period :
	type_specifier
	| IDENTIFIER /*1R*/
	;

postfix_expression :
	primary_expression
	| postfix_expression LBRACK expression RBRACK
	| type_specifier PERIOD after_period
	| postfix_expression LPAREN RPAREN
	| postfix_expression LPAREN argument_expression_list RPAREN
	| postfix_expression INC_OP
	| postfix_expression DEC_OP
	| postfix_expression PERIOD IDENTIFIER /*1R*/
	;

argument_expression_list :
	assignment_expression
	| argument_expression_list COMMA assignment_expression
	;

unary_expression :
	postfix_expression
	| INC_OP unary_expression
	| DEC_OP unary_expression
	| unary_operator unary_expression
	;

unary_operator :
	REF_OP
	| MUL_OP
	| ADD_OP
	| SUB_OP
	| NEG_OP
	;

multiplicative_expression :
	unary_expression
	| multiplicative_expression MUL_OP unary_expression
	| multiplicative_expression DIV_OP unary_expression
	| multiplicative_expression MOD_OP unary_expression
	;

additive_expression :
	multiplicative_expression
	| additive_expression ADD_OP multiplicative_expression
	| additive_expression SUB_OP multiplicative_expression
	;

shift_expression :
	additive_expression
	| shift_expression LEFT_OP additive_expression
	| shift_expression RIGHT_OP additive_expression
	| shift_expression BITCLEAR_OP additive_expression
	;

relational_expression :
	shift_expression
	| relational_expression EQ_OP shift_expression
	| relational_expression NE_OP shift_expression
	| relational_expression LT_OP shift_expression
	| relational_expression GT_OP shift_expression
	| relational_expression LTEQ_OP shift_expression
	| relational_expression GTEQ_OP shift_expression
	;

and_expression :
	relational_expression
	| and_expression REF_OP relational_expression
	;

exclusive_or_expression :
	and_expression
	| exclusive_or_expression BITXOR_OP and_expression
	;

inclusive_or_expression :
	exclusive_or_expression
	| inclusive_or_expression BITOR_OP exclusive_or_expression
	;

logical_and_expression :
	inclusive_or_expression
	| logical_and_expression AND_OP inclusive_or_expression
	;

logical_or_expression :
	logical_and_expression
	| logical_or_expression OR_OP logical_and_expression
	;

conditional_expression :
	logical_or_expression
	| logical_or_expression '?' expression COLON conditional_expression
	;

struct_literal_expression :
	conditional_expression
	| IDENTIFIER /*1R*/ LBRACE /*1R*/ struct_literal_fields RBRACE
	| unary_operator IDENTIFIER /*1R*/ LBRACE /*1R*/ struct_literal_fields RBRACE
	| postfix_expression PERIOD IDENTIFIER /*1R*/ LBRACE /*1R*/ struct_literal_fields RBRACE
	;

assignment_expression :
	struct_literal_expression
	| unary_expression assignment_operator assignment_expression
	;

assignment_operator :
	ASSIGN
	| CASSIGN
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
	| LEFT_ASSIGN
	| RIGHT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

expression :
	assignment_expression
	| expression COMMA assignment_expression
	;

constant_expression :
	conditional_expression
	;

declaration :
	VAR declarator declaration_specifiers SEMICOLON
	| VAR declarator declaration_specifiers ASSIGN initializer SEMICOLON
	;

initializer :
	assignment_expression
	;

statement :
	labeled_statement
	| compound_statement
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	;

labeled_statement :
	IDENTIFIER /*1R*/ COLON block_item
	| CASE constant_expression COLON statement
	| DEFAULT COLON statement
	;

compound_statement :
	LBRACE /*1R*/ RBRACE SEMICOLON
	| LBRACE /*1R*/ block_item_list RBRACE SEMICOLON
	;

block_item_list :
	block_item
	| block_item_list block_item
	;

block_item :
	declaration
	| statement
	;

expression_statement :
	SEMICOLON
	| expression SEMICOLON
	;

selection_statement :
	IF conditional_expression LBRACE /*1R*/ block_item_list RBRACE elseif_list else_statement SEMICOLON
	| IF conditional_expression LBRACE /*1R*/ block_item_list RBRACE else_statement SEMICOLON
	| IF conditional_expression LBRACE /*1R*/ RBRACE else_statement SEMICOLON
	| IF conditional_expression LBRACE /*1R*/ block_item_list RBRACE elseif_list SEMICOLON
	| IF conditional_expression LBRACE /*1R*/ RBRACE elseif_list SEMICOLON
	| IF conditional_expression LBRACE /*1R*/ RBRACE elseif_list else_statement SEMICOLON
	| IF conditional_expression compound_statement
	| SWITCH LPAREN conditional_expression RPAREN statement
	;

elseif :
	ELSE IF conditional_expression LBRACE /*1R*/ block_item_list RBRACE
	| ELSE IF conditional_expression LBRACE /*1R*/ RBRACE
	;

elseif_list :
	elseif
	| elseif_list elseif
	;

else_statement :
	ELSE LBRACE /*1R*/ block_item_list RBRACE
	| ELSE LBRACE /*1R*/ RBRACE
	;

iteration_statement :
	FOR expression compound_statement
	| FOR expression_statement expression_statement compound_statement
	| FOR expression_statement expression_statement expression compound_statement
	| FOR declaration expression_statement compound_statement
	| FOR declaration expression_statement expression compound_statement
	;

jump_statement :
	GOTO IDENTIFIER /*1R*/ SEMICOLON
	| CONTINUE SEMICOLON
	| BREAK SEMICOLON
	| RETURN SEMICOLON
	| RETURN expression SEMICOLON
	;

%%

INT_LIT [0-9]+
FLOAT_LIT [0-9]+"."[0-9]+

%%

[ \t\r\n]+    skip()
"//".*  skip()
"/*"(?s:.)*?"*/"    skip()

"?"	'?'

// Keywords
"func"      FUNC
"var"       VAR
"package"   PACKAGE
"if"        IF
"else"      ELSE
"for"       FOR
"struct"    STRUCT
"import"    IMPORT
"return"    RETURN
"goto"      GOTO
//"new"       NEW
"bool"      BOOL
"i8"        I8
"ui8"       UI8
"i16"       I16
"ui16"      UI16
"i32"       I32
"ui32"      UI32
"f32"       F32
"i64"       I64
"ui64"      UI64
"f64"       F64
"str"       STR
"aff"       AFF
//"union"     UNION
//"enum"      ENUM
//"const"     CONST
"case"      CASE
"default"   DEFAULT
"switch"    SWITCH
"break"     BREAK
"continue"  CONTINUE
"type"      TYPE
//"dl"       DSTATE
//"dLocals"  DSTATE
//"ds"       DSTACK
//"dStack"   DSTACK
//"dp"       DPROGRAM
//"dProgram" DPROGRAM
//"rem"      REM
//"aff"      CAFF
//"def"       DEF
//"clauses"   CLAUSES
//"field"     FIELD
"true"      BOOLEAN_LITERAL
"false"     BOOLEAN_LITERAL

"+="	ADD_ASSIGN
"+"	ADD_OP
"&="	AND_ASSIGN
"&&"	AND_OP
"="	ASSIGN
"&"	BITCLEAR_OP
"|"	BITOR_OP
"^"	BITXOR_OP
":="	CASSIGN
":"	COLON
","	COMMA
"--"	DEC_OP
"/="	DIV_ASSIGN
"/"	DIV_OP
"=="	EQ_OP
">="	GTEQ_OP
">"	GT_OP
"++"	INC_OP
"#"	INFER
"{"	LBRACE
"["	LBRACK
"<<="	LEFT_ASSIGN
"<<"	LEFT_OP
"("	LPAREN
"<="	LTEQ_OP
"<"	LT_OP
"%="	MOD_ASSIGN
"%"	MOD_OP
"*="	MUL_ASSIGN
"*"	MUL_OP
"!"	NEG_OP
"!="	NE_OP
"|="	OR_ASSIGN
"||"	OR_OP
"."	PERIOD
"}"	RBRACE
"]"	RBRACK
REF_OP	REF_OP
">>="	RIGHT_ASSIGN
">>"	RIGHT_OP
")"	RPAREN
";"	SEMICOLON
"-="	SUB_ASSIGN
"-"	SUB_OP
"^="	XOR_ASSIGN

{INT_LIT}B	BYTE_LITERAL
{FLOAT_LIT}D	DOUBLE_LITERAL
{FLOAT_LIT}F?	FLOAT_LITERAL
{INT_LIT}	INT_LITERAL
{INT_LIT}L	LONG_LITERAL
{INT_LIT}S	SHORT_LITERAL
\`[^`]*\`	STRING_LITERAL
\"(\\.|[^"\r\n\\])*\"	STRING_LITERAL
{INT_LIT}UB	UNSIGNED_BYTE_LITERAL
{INT_LIT}U	UNSIGNED_INT_LITERAL
{INT_LIT}UL	UNSIGNED_LONG_LITERAL
{INT_LIT}US	UNSIGNED_SHORT_LITERAL

[A-Za-z_][A-Za-z0-9_]*	IDENTIFIER

%%
