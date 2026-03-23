//kmyacc -l -m /home/mingo/dev/c/A_grammars/kmyacc-js-strict/kmyacc.js.parser ts-ebnf.y
// Lexical tokens (recognized by lexer)
%token Identifier
%token StringLiteral
%token Regex
%token Number

// Grammar directives and keywords
%token PercentName
%token PercentExtras
%token PercentExternals
%token PercentPrecedences
%token PercentInline
%token PercentSupertypes
%token PercentWord
%token PercentReserved
%token PercentConflicts

// Decorators (used in rule syntax)
%token AtAs
%token AtPrec
%token AtPrecLeft
%token AtPrecRight
%token AtPrecDynamic
%token AtToken
%token AtImmediate
%token AtTokenImmediate
%token AtReserved

// Literal syntactic symbols (used in rules)
%token Colon
%token PctPct
%token Equal
%token Semicolon
%token Pipe
%token Star
%token Plus
%token Question
%token LeftParen
%token RightParen
%token LeftBrace
%token RightBrace
%token Comma

%%

grammar:
	  directive_oom PctPct rule_oom PctPct_rule_zom_opt
	;

PctPct_rule_zom_opt:
	  %empty
	| PctPct
	| PctPct rule_oom
	;

rule_oom:
	 rule
	| rule_oom rule
	;

directive_oom:
	  directive
	| directive_oom directive
	;

directive:
	  PercentName Identifier
	| PercentExtras LeftBrace expression_list_opt RightBrace
	| PercentExternals LeftBrace expression_list_opt RightBrace
	| PercentPrecedences LeftBrace precedence_list_opt RightBrace
	| PercentInline LeftBrace identifier_list_opt RightBrace
	| PercentSupertypes LeftBrace identifier_list_opt RightBrace
	| PercentWord Identifier
	| PercentReserved LeftBrace reserved_body_opt RightBrace
	| PercentConflicts LeftBrace conflict_list_opt RightBrace
	;

conflict_list_opt:
	  %empty
	| conflict_list
	;

reserved_body_opt:
	  %empty
	| reserved_body
	;

identifier_list_opt:
	  %empty
	| identifier_list
	;

precedence_list_opt:
	  %empty
	| precedence_list
	;

expression_list_opt:
	  %empty
	| expression_list
	;

reserved_body:
	  expression_list
	| wordset_list
	;

wordset_list:
	  wordset coma_wordset_zom Comma_opt
	;

coma_wordset_zom:
     Comma wordset
    | coma_wordset_zom Comma wordset
    ;

Comma_opt:
	  %empty
	| Comma
	;

wordset:
	  Identifier LeftBrace expression_list_opt RightBrace
	;

rule:
	  Identifier Colon expression Semicolon
	;

expression:
	  choice
	;

choice:
	  sequence
	| choice  Pipe sequence
	;

sequence:
	  postfix
	| sequence postfix
	;

postfix:
	  primary postfix_op_zom
	|  Identifier Equal primary postfix_op_zom
	;

postfix_op_zom:
	  %empty
	| postfix_op_zom postfix_op
	;

postfix_op:
	  Star
	| Plus
	| Question
	| decorator
	;

decorator:
	  AtAs LeftParen id_or_str RightParen
	| AtPrec LeftParen prec_arg RightParen
	| AtPrecLeft LeftParen prec_arg_opt RightParen
	| AtPrecRight LeftParen prec_arg_opt RightParen
	| AtPrecDynamic LeftParen prec_arg RightParen
	| AtToken
	| AtImmediate
	| AtTokenImmediate
	| AtReserved LeftParen id_or_str RightParen
	;

prec_arg_opt:
	  %empty
	| prec_arg
	;

prec_arg:
	  Number
	| StringLiteral
	;

primary:
	  Identifier
	| StringLiteral
	| Regex
	| LeftParen expression RightParen
	;

expression_list:
	  expression Comma_expression_zom Comma_opt
	;

Comma_expression_zom:
	  %empty
	| Comma_expression_zom Comma expression
	;

precedence_list:
	  precedence_group Comma_precedence_group_zom Comma_opt
	;

Comma_precedence_group_zom:
	  %empty
	| Comma_precedence_group_zom Comma precedence_group
	;

precedence_group:
	  LeftParen id_or_str_Comma_opt_id_or_str_zom_zom RightParen
	;

id_or_str_Comma_opt_id_or_str_zom_zom:
	  %empty
	|  id_or_str  Comma_opt_id_or_str_zom
	;

 Comma_opt_id_or_str_zom:
	  %empty
	|  Comma_opt_id_or_str_zom  Comma_opt id_or_str
	;

conflict_list:
	  conflict_group Comma_conflict_group_zom Comma_opt
	;

Comma_conflict_group_zom:
	  %empty
	| Comma_conflict_group_zom Comma conflict_group
	;

conflict_group:
	  LeftParen identifier_list_opt RightParen
	;

identifier_list:
	  Identifier Comma_Identifier_zom Comma_opt
	;

Comma_Identifier_zom:
	  %empty
	| Comma_Identifier_zom Comma Identifier
	;

id_or_str:
	  Identifier
	| StringLiteral
	;

%%

O   [0-7]
D   [0-9]
NZ  [1-9]
L   [a-zA-Z_]
A   [a-zA-Z_0-9]
H   [a-fA-F0-9]
HP  ("0"[xX])
E   ([Ee][+-]?D+)
P   ([Pp][+-]?D+)
FS  [fFlL]
IS  (([uU]("l"|"L"|"ll"|"LL")?)|(("l"|"L"|"ll"|"LL")[uU]?))
CP  ("u"|"U"|"L")
SP  ("u8"|"u"|"U"|"L")
ES  ("\\"(['"?\\abfnrtv]|{O}{1,3}|"x"{H}+))
LWS  [ \t\v\f]
WS  [ \t\v\n\f]

DQSTR  \"([^"\n\r\\]|\\.)+\"i?
SQSTR  '([^'\n\r\\]|\\.)+'i?
CHARCLASS  "[""^"?([^\]\n\r\\]|\\.)+"]"i?

%%

    // Whitespace handling
[ \t\n\r]+ skip()

    // Handle comments
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()
    // Directive handling
"%name"   PercentName
"%extras"   PercentExtras
"%externals"   PercentExternals
"%precedences"   PercentPrecedences
"%inline"    PercentInline
"%supertypes"    PercentSupertypes
"%word"    PercentWord
"%reserved"    PercentReserved
"%conflicts"    PercentConflicts

	// Decorators (used in rules)
"@as"    AtAs
"@prec"    AtPrec
"@prec.left"    AtPrecLeft
"@prec.right"    AtPrecRight
"@prec.dynamic"    AtPrecDynamic
"@token"   AtToken
"@immediate"   AtImmediate
"@token.immediate"   AtTokenImmediate
"@reserved"    AtReserved

	// Literal syntactic symbols (used in grammar rules)
":"    Colon
"="    Equal
";"    Semicolon
"|"    Pipe
"*"    Star
"+"    Plus
"?"    Question
"("    LeftParen
")"    RightParen
"{"    LeftBrace
"}"    RightBrace
","    Comma
"%%"    PctPct

r{DQSTR}	Regex
r{SQSTR}	Regex
{DQSTR}	StringLiteral
{SQSTR}	StringLiteral
-?{D}+ Number
    // Identifiers
{L}{A}*   Identifier

%%
