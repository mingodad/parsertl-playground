//From: https://github.com/jsinger67/parol/blob/e44e8f0dc05677e15cfd4294c767a7405b3d661a/crates/parol/src/parser/parol.par

//%start Parol
//%title "Parol grammar"
//%comment "Parol's own grammar"
//%grammar_type 'll(k)'
//%line_comment '//'
//%block_comment '/*' '*/'
//%user_type UserType = crate::parser::parol_grammar::UserDefinedTypeName
//%user_type ScannerConfig = crate::parser::parol_grammar::ScannerConfig

%token Identifier
%token RawString
%token Regex
%token String

%%

Parol:
	  Prolog GrammarDefinition
	;

Prolog:
	  StartDeclaration Declaration_zom ScannerState_zom
	;

ScannerState_zom:
	  %empty
	| ScannerState_zom ScannerState
	;

Declaration_zom:
	  %empty
	| Declaration_zom Declaration
	;

StartDeclaration:
	  "%start" Identifier
	;

Declaration:
	  "%title" String
	| "%comment" String
	| "%user_type" Identifier '=' UserTypeName
	| "%grammar_type" RawString
	| ScannerDirectives
	;

ScannerDirectives:
	  "%line_comment" TokenLiteral
	| "%block_comment" TokenLiteral TokenLiteral
	| "%auto_newline_off"
	| "%auto_ws_off"
	| "%on" IdentifierList "%enter" Identifier
	;

GrammarDefinition:
	  "%%" Production Production_zom
	;

Production_zom:
	  %empty
	| Production_zom Production
	;

DoubleColon:
	  "::"
	;

Production:
	  Identifier ':' Alternations ';'
	;

Alternations:
	  Alternation
	| Alternations '|' Alternation
	;

Alternation:
	  %empty
	| Alternation Factor
	;

Factor:
	  Group
	| Repeat
	| Optional
	| Symbol
	;

Symbol:
	  NonTerminal
	| SimpleToken
	| TokenWithStates
	| ScannerSwitch
	;

TokenLiteral:
	  String
	| RawString
	| Regex
	;

SimpleToken:
	  TokenLiteral ASTControl_opt
	;

ASTControl_opt:
	  %empty
	| ASTControl
	;

TokenWithStates:
	  '<' IdentifierList '>' TokenLiteral ASTControl_opt
	;

Group:
	  '(' Alternations ')'
	;

Optional:
	  '[' Alternations ']'
	;

Repeat:
	  '{' Alternations '}'
	;

NonTerminal:
	  Identifier ASTControl_opt
	;

ScannerState:
	  "%scanner" Identifier '{' ScannerDirectives_zom '}'
	;

ScannerDirectives_zom:
	  %empty
	| ScannerDirectives_zom ScannerDirectives
	;

IdentifierList:
	  Identifier
	| IdentifierList ',' Identifier
	;

ScannerSwitch:
	  "%sc" '(' Identifier_opt ')'
	| "%push" '(' Identifier ')'
	| "%pop" '(' ')'
	;

Identifier_opt:
	  %empty
	| Identifier
	;

ASTControl:
	  CutOperator
	| UserTypeDeclaration
	;

CutOperator:
	  '^'
	;

UserTypeDeclaration:
	  ':' UserTypeName
	;

UserTypeName:
	  Identifier
	| UserTypeName DoubleColon Identifier
	;

%%

%%

[ \t\r\n]+  skip()
"//".*  skip()
"/*"(?s:.)*?"*/"    skip()


"^"	'^'
"<"	'<'
"="	'='
">"	'>'
"|"	'|'
","	','
";"	';'
"::"	"::"
":"	':'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"%%"	"%%"
"%auto_newline_off"	"%auto_newline_off"
"%auto_ws_off"	"%auto_ws_off"
"%block_comment"	"%block_comment"
"%comment"	"%comment"
"%enter"	"%enter"
"%grammar_type"	"%grammar_type"
"%line_comment"	"%line_comment"
"%on"	"%on"
"%pop"	"%pop"
"%push"	"%push"
"%scanner"	"%scanner"
"%sc"	"%sc"
"%start"	"%start"
"%title"	"%title"
"%user_type"	"%user_type"

'(\\.|[^'\r\n\\])+'	RawString
"/"(\\.|[^/\r\n\\])+"/"	Regex
\"(\\.|[^"\r\n\\])+\"	String
[a-zA-Z_][a-zA-Z0-9_]*	Identifier

%%
