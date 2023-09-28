//From: https://github.com/YPLiang19/Mango/blob/3b6d313fed05a7272e4203d7ca4b2e8c43b1d4c1/MangoFix/Compiler/lex_yacc/mango.y

/*Tokens*/
%token ADD
%token ADD_ASSIGN
%token ADDRESS
%token AND
%token ANNOTATION
%token ASSIGN
%token ASSIGN_MEM
%token ASTERISK
%token ASTERISK_ASSIGN
%token AT
%token ATOMIC
%token BLOCK
%token BOOL_
%token BREAK
%token CASE
%token C_FUNCTION
%token CHAR
%token CLASS
%token CLASS_
%token COLON
%token COMMA
%token CONTINUE
%token COPY
%token C_STRING
%token DECLARE
%token DECREMENT
%token DEFAULT
%token DIV
%token DIV_ASSIGN
%token DO
%token DOT
%token DOUBLE
%token DOUBLE_LITERAL
%token ELSE
%token EQ
%token EXTERN
%token FOR
%token GE
%token GT
%token ID
%token IDENTIFIER
%token IF
%token IN
%token INCREMENT
%token INT
%token INTETER_LITERAL
%token LB
%token LC
%token LE
%token LP
%token LT
%token MOD
%token MOD_ASSIGN
%token NE
%token NIL
%token NO_
%token NONATOMIC
%token NOT
%token NULL_
%token OR
%token POINTER
%token POWER
%token PROPERTY
%token QUESTION
%token RB
%token RC
%token RETURN
%token RP
%token SEL_
%token SELECTOR
%token SELF
%token SEMICOLON
%token STATIC
%token STRING_LITERAL
%token STRONG
%token __STRONG
%token STRUCT
%token SUB
%token SUB_ASSIGN
%token SUPER
%token SWIFT_CLASS_ALIAS
%token SWITCH
%token TYPEDEF
%token U_INT
%token VOID
%token WEAK
%token __WEAK
%token WHILE
%token YES_

%start compile_util

%%

compile_util :
	/*empty*/
	| definition_list
	;

definition_list :
	definition
	| definition_list definition
	;

definition :
	class_definition
	| annotation_list class_definition
	| declare_struct
	| annotation_list declare_struct
	| top_statement
	| typedef_definition
	| swift_class_alias
	;

annotation :
	ANNOTATION
	| ANNOTATION LP expression RP
	;

annotation_list :
	annotation
	| annotation_list annotation
	;

annotation_list_opt :
	/*empty*/
	| annotation_list
	;

declare_struct :
	DECLARE STRUCT IDENTIFIER LC IDENTIFIER COLON STRING_LITERAL COMMA IDENTIFIER COLON identifier_list RC
	| DECLARE STRUCT IDENTIFIER LC IDENTIFIER COLON identifier_list COMMA IDENTIFIER COLON STRING_LITERAL RC
	;

identifier_list :
	IDENTIFIER
	| identifier_list COMMA IDENTIFIER
	;

class_definition :
	CLASS IDENTIFIER COLON annotation_list_opt IDENTIFIER LC RC
	| CLASS IDENTIFIER COLON annotation_list_opt IDENTIFIER LC member_definition_list RC
	| CLASS IDENTIFIER COLON annotation_list_opt IDENTIFIER LT protocol_list GT LC RC
	| CLASS IDENTIFIER COLON annotation_list_opt IDENTIFIER LT protocol_list GT LC member_definition_list RC
	;

protocol_list :
	IDENTIFIER
	| protocol_list COMMA IDENTIFIER
	;

property_definition :
	annotation_list_opt PROPERTY LP property_modifier_list RP type_specifier IDENTIFIER SEMICOLON
	| annotation_list_opt PROPERTY LP RP type_specifier IDENTIFIER SEMICOLON
	;

property_modifier_list :
	property_modifier
	| property_modifier_list COMMA property_modifier
	;

property_modifier :
	property_rc_modifier
	| property_atomic_modifier
	;

property_rc_modifier :
	WEAK
	| STRONG
	| COPY
	| ASSIGN_MEM
	;

property_atomic_modifier :
	NONATOMIC
	| ATOMIC
	;

swift_class_alias :
	SWIFT_CLASS_ALIAS IDENTIFIER IDENTIFIER SEMICOLON
	| SWIFT_CLASS_ALIAS IDENTIFIER DOT IDENTIFIER IDENTIFIER SEMICOLON
	| SWIFT_CLASS_ALIAS IDENTIFIER DOT IDENTIFIER DOT IDENTIFIER IDENTIFIER SEMICOLON
	| SWIFT_CLASS_ALIAS IDENTIFIER DOT IDENTIFIER DOT IDENTIFIER DOT IDENTIFIER IDENTIFIER SEMICOLON
	| SWIFT_CLASS_ALIAS IDENTIFIER DOT IDENTIFIER DOT IDENTIFIER DOT IDENTIFIER DOT IDENTIFIER IDENTIFIER SEMICOLON
	;

typedef_definition :
	TYPEDEF BOOL_ IDENTIFIER SEMICOLON
	| TYPEDEF INT IDENTIFIER SEMICOLON
	| TYPEDEF U_INT IDENTIFIER SEMICOLON
	| TYPEDEF DOUBLE IDENTIFIER SEMICOLON
	| TYPEDEF C_STRING IDENTIFIER SEMICOLON
	| TYPEDEF ID IDENTIFIER SEMICOLON
	| TYPEDEF BLOCK IDENTIFIER SEMICOLON
	| TYPEDEF CLASS_ IDENTIFIER SEMICOLON
	| TYPEDEF SEL_ IDENTIFIER SEMICOLON
	| TYPEDEF POINTER IDENTIFIER SEMICOLON
	| TYPEDEF IDENTIFIER IDENTIFIER SEMICOLON
	;

type_specifier :
	VOID
	| BOOL_
	| INT
	| U_INT
	| DOUBLE
	| C_STRING
	| ID
	| CLASS_
	| SEL_
	| annotation_list_opt BLOCK
	| POINTER
	| C_FUNCTION LT c_type_identier_list GT
	| IDENTIFIER ASTERISK
	| STRUCT IDENTIFIER
	| IDENTIFIER
	;

method_definition :
	instance_method_definition
	| class_method_definition
	;

instance_method_definition :
	annotation_list_opt SUB LP type_specifier RP method_name block_statement
	;

class_method_definition :
	annotation_list_opt ADD LP type_specifier RP method_name block_statement
	;

method_name :
	method_name_1
	| method_name_2
	;

method_name_1 :
	IDENTIFIER
	;

method_name_2 :
	method_name_item
	| method_name_2 method_name_item
	;

method_name_item :
	IDENTIFIER COLON LP type_specifier RP IDENTIFIER
	;

member_definition :
	property_definition
	| method_definition
	;

member_definition_list :
	member_definition
	| member_definition_list member_definition
	;

selector :
	selector_1
	| selector_2
	;

selector_1 :
	IDENTIFIER
	| key_work_identifier
	;

selector_2 :
	selector_1 COLON
	| selector_2 selector_1 COLON
	;

expression :
	assign_expression
	;

assign_expression :
	ternary_operator_expression
	| primary_expression assignment_operator ternary_operator_expression
	;

assignment_operator :
	ASSIGN
	| SUB_ASSIGN
	| ADD_ASSIGN
	| ASTERISK_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	;

ternary_operator_expression :
	logic_or_expression
	| logic_or_expression QUESTION ternary_operator_expression COLON ternary_operator_expression
	| logic_or_expression QUESTION COLON ternary_operator_expression
	;

logic_or_expression :
	logic_and_expression
	| logic_or_expression OR logic_and_expression
	;

logic_and_expression :
	equality_expression
	| logic_and_expression AND equality_expression
	;

equality_expression :
	relational_expression
	| equality_expression EQ relational_expression
	| equality_expression NE relational_expression
	;

relational_expression :
	additive_expression
	| relational_expression LT additive_expression
	| relational_expression LE additive_expression
	| relational_expression GT additive_expression
	| relational_expression GE additive_expression
	;

additive_expression :
	multiplication_expression
	| additive_expression ADD multiplication_expression
	| additive_expression SUB multiplication_expression
	;

multiplication_expression :
	unary_expression
	| multiplication_expression ASTERISK unary_expression
	| multiplication_expression DIV unary_expression
	| multiplication_expression MOD unary_expression
	;

unary_expression :
	postfix_expression
	| NOT unary_expression
	| SUB unary_expression
	;

postfix_expression :
	primary_expression
	| primary_expression INCREMENT
	| primary_expression DECREMENT
	;

expression_list :
	assign_expression
	| expression_list COMMA assign_expression
	;

dic_entry :
	primary_expression COLON primary_expression
	;

dic_entry_list :
	dic_entry
	| dic_entry_list COMMA dic_entry
	;

dic :
	AT LC dic_entry_list RC
	| AT LC RC
	;

struct_entry :
	IDENTIFIER COLON primary_expression
	;

struct_entry_list :
	struct_entry
	| struct_entry_list COMMA struct_entry
	;

struct_literal :
	LC struct_entry_list RC
	;

c_type_identier :
	key_work_identifier
	| IDENTIFIER
	| VOID ASTERISK
	| CHAR ASTERISK
	| STRUCT IDENTIFIER
	;

c_type_identier_list :
	c_type_identier
	| c_type_identier_list COMMA c_type_identier
	;

key_work_identifier :
	ID
	| CLASS
	| CLASS_
	| COPY
	| BOOL_
	| INT
	| U_INT
	| DOUBLE
	| SEL_
	| VOID
	;

primary_expression :
	IDENTIFIER
	| ADDRESS IDENTIFIER
	| primary_expression DOT IDENTIFIER
	| primary_expression DOT key_work_identifier
	| primary_expression DOT selector LP RP
	| primary_expression DOT selector LP expression_list RP
	| primary_expression LP RP
	| primary_expression LP expression_list RP
	| LP expression RP
	| primary_expression LB expression RB
	| YES_
	| NO_
	| INTETER_LITERAL
	| DOUBLE_LITERAL
	| STRING_LITERAL
	| NIL
	| NULL_
	| SELECTOR LP selector RP
	| AT INTETER_LITERAL
	| AT DOUBLE_LITERAL
	| AT STRING_LITERAL
	| AT YES_
	| AT NO_
	| SELF
	| SUPER
	| AT LP expression RP
	| AT LB expression_list RB
	| AT LB RB
	| C_FUNCTION LP expression RP
	| dic
	| struct_literal
	| block_body
	;

block_body :
	POWER type_specifier LP RP block_statement
	| POWER type_specifier block_statement
	| POWER type_specifier LP function_param_list RP block_statement
	| POWER LP RP block_statement
	| POWER block_statement
	| POWER LP function_param_list RP block_statement
	;

function_param_list :
	function_param
	| function_param_list COMMA function_param
	;

function_param :
	type_specifier IDENTIFIER
	;

declaration_statement :
	declaration SEMICOLON
	;

declaration_modifier :
	__WEAK
	| __STRONG
	| STATIC
	;

declaration_modifier_list :
	declaration_modifier
	| declaration_modifier_list declaration_modifier
	;

declaration :
	declaration_modifier_list type_specifier IDENTIFIER
	| declaration_modifier_list type_specifier IDENTIFIER ASSIGN expression
	| type_specifier IDENTIFIER
	| type_specifier IDENTIFIER ASSIGN expression
	| EXTERN type_specifier IDENTIFIER
	;

if_statement :
	IF LP expression RP block_statement
	| IF LP expression RP block_statement ELSE block_statement
	| IF LP expression RP block_statement else_if_list
	| IF LP expression RP block_statement else_if_list ELSE block_statement
	;

else_if_list :
	else_if
	| else_if_list else_if
	;

else_if :
	ELSE IF LP expression RP block_statement
	;

switch_statement :
	SWITCH LP expression RP LC case_list default_opt RC
	;

case_list :
	one_case
	| case_list one_case
	;

one_case :
	CASE expression COLON block_statement
	;

default_opt :
	/*empty*/
	| DEFAULT COLON block_statement
	;

expression_opt :
	/*empty*/
	| expression
	;

for_statement :
	FOR LP expression_opt SEMICOLON expression_opt SEMICOLON expression_opt RP block_statement
	| FOR LP declaration SEMICOLON expression_opt SEMICOLON expression_opt RP block_statement
	;

while_statement :
	WHILE LP expression RP block_statement
	;

do_while_statement :
	DO block_statement WHILE LP expression RP SEMICOLON
	;

foreach_statement :
	FOR LP type_specifier IDENTIFIER IN expression RP block_statement
	| FOR LP IDENTIFIER IN expression RP block_statement
	;

continue_statement :
	CONTINUE SEMICOLON
	;

break_statement :
	BREAK SEMICOLON
	;

return_statement :
	RETURN expression_opt SEMICOLON
	;

expression_statement :
	expression SEMICOLON
	;

block_statement :
	LC RC
	| LC statement_list RC
	;

statement_list :
	statement
	| statement_list statement
	;

statement :
	declaration_statement
	| if_statement
	| switch_statement
	| for_statement
	| foreach_statement
	| while_statement
	| do_while_statement
	| break_statement
	| continue_statement
	| return_statement
	| expression_statement
	;

top_statement :
	declaration_statement
	| if_statement
	| switch_statement
	| for_statement
	| foreach_statement
	| while_statement
	| do_while_statement
	| expression_statement
	;

%%

%%

":"  COLON
"^"  POWER
","  COMMA
";"  SEMICOLON
"("  LP
")"  RP
"["  LB
"]"  RB
"{"  LC
"}"  RC
"?"  QUESTION
"."  DOT
"&"  ADDRESS
"@"  AT



"&&"  AND
"||"  OR
"!"  NOT

"=="  EQ
"!="  NE
"<"  LT
"<="  LE
">"  GT
">="  GE

"-"  SUB
"+"  ADD
"*"  ASTERISK
"/"  DIV
"%"  MOD
"++"  INCREMENT
"--"  DECREMENT

"-="  SUB_ASSIGN
"+="  ADD_ASSIGN
"*="  ASTERISK_ASSIGN
"/="  DIV_ASSIGN
"%="  MOD_ASSIGN
"="  ASSIGN

"declare"   DECLARE
"struct"   STRUCT
"class"   CLASS


"if"   IF
"else"   ELSE
"for"   FOR
"in"  IN
"while"   WHILE
"do"   DO
"switch"   SWITCH
"case"   CASE
"default"   DEFAULT
"break"   BREAK
"continue"   CONTINUE
"return"  RETURN


"@property"  PROPERTY
"@selector"  SELECTOR


"weak"  WEAK
"strong"  STRONG
"copy"  COPY
"assign"  ASSIGN_MEM
"nonatomic"  NONATOMIC
"atomic"  ATOMIC

"void"  VOID
"char"  CHAR
"BOOL"  BOOL_
"int"  INT
"uint"  U_INT
"double"  DOUBLE
"CString"  C_STRING
"id"  ID
"Class"  CLASS_
"SEL"  SEL_
"Block"  BLOCK
"Pointer"  POINTER
"CFunction"   C_FUNCTION
"__weak"  __WEAK
"__strong"  __STRONG
"static"  STATIC
"typedef"  TYPEDEF
"extern"  EXTERN



"@SwiftClassAlias"  SWIFT_CLASS_ALIAS


"self" SELF
"super" SUPER
"nil" NIL

"NULL" NULL_

"YES" YES_

"NO" NO_

@[A-Za-z_$][A-Za-z_$0-9]* ANNOTATION

"#If" ANNOTATION

[A-Za-z_$][A-Za-z_$0-9]* IDENTIFIER

[0-9][0-9]* INTETER_LITERAL

"0"[xX][0-9a-fA-F]+ INTETER_LITERAL

"0"[0-7]+ INTETER_LITERAL

[0-9]+\.[0-9]+ DOUBLE_LITERAL

\"(\\.|[^"\n\r\\])*\" STRING_LITERAL

[ \t] skip()
[\n] skip()

"/*"(?s:.)*?"*/"	skip()
"//".* skip()

%%
