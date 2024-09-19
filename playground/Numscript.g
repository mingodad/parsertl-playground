//From: https://github.com/formancehq/numscript/blob/308d86741382a9c9c5ed9acdb0e39eb56dc28d22/Numscript.g4

%token ACCOUNT
%token ALLOWING
%token ASSET
%token COMMA
%token DESTINATION
%token EQ
%token FROM
%token IDENTIFIER
%token KEPT
%token LBRACE
%token LBRACKET
%token LPARENS
%token MAX
%token NUMBER
%token OVERDRAFT
%token PERCENTAGE_PORTION_LITERAL
%token RATIO_PORTION_LITERAL
%token RBRACE
%token RBRACKET
%token REMAINING
%token RPARENS
%token SEND
%token SOURCE
%token STAR
%token STRING
%token TO
%token UNBOUNDED
%token UP
%token VARIABLE_NAME
%token VARS

%start program

%%

monetaryLit:
	  LBRACKET /*asset =*/ literal /*amt =*/ literal RBRACKET
	;

portion:
	  RATIO_PORTION_LITERAL	#ratio
	| PERCENTAGE_PORTION_LITERAL	#percentage
	;

literal:
	  ASSET	#assetLiteral
	| STRING	#stringLiteral
	| ACCOUNT	#accountLiteral
	| VARIABLE_NAME	#variableLiteral
	| NUMBER	#numberLiteral
	| monetaryLit	#monetaryLiteral
	| portion	#portionLiteral
	;

functionCallArgs:
	  literal
	| functionCallArgs COMMA literal
	;

functionCall:
	  IDENTIFIER LPARENS functionCallArgs_opt RPARENS
	;

functionCallArgs_opt:
	  %empty
	| functionCallArgs
	;

varOrigin:
	  EQ functionCall
	;

varDeclaration:
	/*type_ =*/ IDENTIFIER /*name =*/ VARIABLE_NAME varOrigin_opt
	;

varOrigin_opt:
	  %empty
	| varOrigin
	;

varsDeclaration:
	  VARS LBRACE varDeclaration_zom RBRACE
	;

varDeclaration_zom:
	  %empty
	| varDeclaration_zom varDeclaration
	;

program:
	  varsDeclaration_opt statement_zom
	;

statement_zom:
	  %empty
	| statement_zom statement
	;

varsDeclaration_opt:
	  %empty
	| varsDeclaration
	;

sentAllLit:
	  LBRACKET /*asset =*/ literal STAR RBRACKET
	;

cap:
	  monetaryLit	#litCap
	| VARIABLE_NAME	#varCap
	;

allotment:
	  portion	#portionedAllotment
	| VARIABLE_NAME	#portionVariable
	| REMAINING	#remainingAllotment
	;

source:
	/*address =*/ literal ALLOWING UNBOUNDED OVERDRAFT	#srcAccountUnboundedOverdraft
	| /*address =*/ literal ALLOWING OVERDRAFT UP TO /*maxOvedraft =*/ literal	#srcAccountBoundedOverdraft
	| literal	#srcAccount
	| LBRACE allotmentClauseSrc_oom RBRACE	#srcAllotment
	| LBRACE source_zom RBRACE	#srcInorder
	| MAX cap FROM source	#srcCapped
	;

source_zom:
	  %empty
	| source_zom source
	;

allotmentClauseSrc_oom:
	  allotmentClauseSrc
	| allotmentClauseSrc_oom allotmentClauseSrc
	;

allotmentClauseSrc:
	  allotment FROM source
	;

keptOrDestination:
	  TO destination	#destinationTo
	| KEPT	#destinationKept
	;

destinationInOrderClause:
	  MAX literal keptOrDestination
	;

destination:
	  literal	#destAccount
	| LBRACE allotmentClauseDest_oom RBRACE	#destAllotment
	| LBRACE destinationInOrderClause_opt REMAINING keptOrDestination RBRACE	#destInorder
	;

destinationInOrderClause_opt:
	  %empty
	| destinationInOrderClause_opt destinationInOrderClause
	;

allotmentClauseDest_oom:
	  allotmentClauseDest
	| allotmentClauseDest_oom allotmentClauseDest
	;

allotmentClauseDest:
	  allotment keptOrDestination
	;

sentValue:
	  literal	#sentLiteral
	| sentAllLit	#sentAll
	;

statement:
	  SEND sentValue LPARENS SOURCE EQ source DESTINATION EQ destination RPARENS	#sendStatement
	| functionCall	#fnCallStatement
	;

%%

%%

// Tokens
//WS: [ \t\r\n]+ -> skip;
//NEWLINE: [\r\n]+;
[ \t\r\n]+	skip()
"/*"(?s:.)*?"*/"	skip() //MULTILINE_COMMENT
"//".*	skip() //LINE_COMMENT

"vars"	VARS
"max"	MAX
"source"	SOURCE
"destination"	DESTINATION
"send"	SEND
"from"	FROM
"up"	UP
"to"	TO
"remaining"	REMAINING
"allowing"	ALLOWING
"unbounded"	UNBOUNDED
"overdraft"	OVERDRAFT
"kept"	KEPT
"("	LPARENS
")"	RPARENS
"["	LBRACKET
"]"	RBRACKET
"{"	LBRACE
"}"	RBRACE
","	COMMA
"="	EQ
"*"	STAR

[0-9]+[ ]?"/"[ ]?[0-9]+	RATIO_PORTION_LITERAL
[0-9]+("."[0-9]+)?"%"	PERCENTAGE_PORTION_LITERAL

\"(\\\"|[^\r\n"])*\"	STRING

[0-9]+	NUMBER
"$"[a-z_]+[a-z0-9_]*	VARIABLE_NAME
"@"[a-zA-Z0-9_-]+(":"[a-zA-Z0-9_-]+)*	ACCOUNT
[A-Z/0-9]+	ASSET
[a-z]+[a-z_]*	IDENTIFIER

%%