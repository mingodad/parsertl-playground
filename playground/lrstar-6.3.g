//From: https://github.com/VestniK/lrstar/blob/dda66a8b1cf0f37aa79cef8d44497d98afdb9e9f/PG.grm

// LRSTAR Syntactical Grammar.

%token TK_GOALSYMBOL
%token TK_HEADSYMBOL
%token TK_alpha
%token TK_integer
%token TK_lexical
%token TK_literal
%token TK_semantic
%token TK_string

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// NONTERMINAL PG_SYMBOLS ...

%start Grammar

%%

Grammar :
	Options ErrorDecl Declarations OperPrec Rules
	;

Options :
	%empty
	| TK_string
	;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// DECLARATIONS ...

Declarations :
    %empty
	| ConstDecl_oom
	| TokenDecl_oom
	| ConstDecl_oom TokenDecl_oom
	;

ConstDecl_oom :
	ConstDecl
	| ConstDecl_oom ConstDecl
	;

TokenDecl_oom :
	TokenDecl
	| TokenDecl_oom TokenDecl
	;

ConstDecl :
	DefCon Value ';'
	;

DefCon :
	TK_alpha
	;

Value :
	TK_integer
	;

ErrorDecl :
	%empty
	;

TokenDecl :
	DefCon Token ';'
	| DefCon Token TokenAction ';'
	| Token ';'
	| Token TokenAction ';'
	;

Token :
	TK_alpha
	| TK_alpha '^'
	| TK_lexical
	| TK_semantic
	| TK_literal
	| TK_literal '^'
	| "<error>"
	| "<eof>"
	;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// OPERATOR PRECEDENCE ...

OperPrec :
	%empty
	| OperPrecLine_oom
	;

OperPrecLine_oom :
	OperPrecLine
	| OperPrecLine_oom OperPrecLine
	;

OperPrecLine :
	'{' Operator_oom '}' "<<"
	| '{' Operator_oom '}' ">>"
	;

Operator_oom :
	Operator
	| Operator_oom Operator
	;

Operator :
	TK_alpha
	| TK_lexical
	| TK_semantic
	| TK_literal
	;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// RULES ...

Rules :
	GoalSymbolDef NonterminalDef_zom
	;

NonterminalDef_zom :
	%empty
	| NonterminalDef_zom NonterminalDef
	;

GoalSymbolDef :
	GoalSymbol GoalSymbolRule
	;

GoalSymbol :
	TK_GOALSYMBOL
	;

GoalSymbolRule :
	':' GoalTails RuleActions semi_opt
	| "->" GoalTails RuleActions semi_opt
	;

semi_opt :
	%empty
	| ';'
	;

GoalTails :
	TailPosition EOF
	;

EOF :
	EOF2
	;

EOF2 :
	"<eof>"
	;

NonterminalDef	:
	HeadSymbol ColonFirst semi_opt
	| HeadSymbol ColonFirst BarRules semi_opt
	| HeadSymbol ArrowFirst semi_opt
	| HeadSymbol ArrowFirst BarRules semi_opt
	| HeadSymbol ArrowFirst ArrowRules semi_opt
	| HeadSymbol OtherFirst semi_opt
	| HeadSymbol OtherFirst ArrowRules semi_opt
	;

HeadSymbol :
	TK_HEADSYMBOL
	;

ColonFirst :
	':' TailExprList RuleActions
	;

ArrowFirst :
	"->" TailExprList RuleActions
	;

OtherFirst :
	"~>" TailExprList RuleActions
	| "/->" TailExprList RuleActions
	| "/~>" TailExprList RuleActions
	;

BarRules :
	BarRule
	| BarRules BarRule
	;

BarRule :
	Bar TailExprList RuleActions
	;

Bar :
	'|'
	;

ArrowRules :
	ArrowRule
	| ArrowRules ArrowRule
	;

ArrowRule :
	Arrow TailExprList RuleActions
	;

Arrow :
	"->"
	| "~>"
	| "/->"
	| "/~>"
	;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// EXPRESSIONS ...

TailExprList :
	%empty
	| TailPosition_oom
	;

TailPosition_oom :
	TailPosition
	| TailPosition_oom TailPosition
	;

TailPosition :
	TailExpr
	;

TailExpr :
	Tail
	| Tail '+'
	| Tail "..."
	| TailAst
	| TailQuest
	| Tail SepExpr
	| Tail SepExprRev
	| Group
	| Group '+'
	| Group "..."
	| Group '~'
	| Group "~.."
	| Group SepExpr
	| Group SepExprRev
	| OGroup '?'
	| OGroup '*'
	| OptGroup
	| OptGroup '~'
	| OptGroup "..."
	| OptGroup "~.."
	| OptGroup SepExpr
	| OptGroup SepExprRev
	;

SepExpr :
	'/' Sep '+'
	| '/' Sep "..."
	;

SepExprRev :
	'/' Sep "~.."
	;

TailAst :
	TailAst2
	;

TailAst2 :
	Tail '*'
	;

TailQuest :
	TailQuest2
	;

TailQuest2 :
	Tail '?'
	;

Group :
	'(' GroupTails ')'
	;

OGroup :
	'(' GroupTails ')'
	;

OptGroup :
	'[' GroupTails ']'
	;

GroupTails :
	GroupExprList OrGroupExprList_zom
	;

OrGroupExprList_zom :
	%empty
	| OrGroupExprList_zom OrGroupExprList
	;

GroupExprList :
	TailExpr_oom
	;

TailExpr_oom :
	TailExpr
	| TailExpr_oom TailExpr
	;

OrGroupExprList :
	'|' TailExpr_oom
	;

Tail :
	TK_alpha
	| TK_literal
	| TK_lexical
	| TK_semantic
	| "<error>"
	| "<keyword>"
	;

Sep :
	TK_alpha
	| TK_lexical
	| TK_literal
	| Group
	;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// ACTIONS ...

TokenAction :
	"=>" TokenActionSpec
	;

RuleActions :
	%empty
	| ParseAction
	| MakeNode
	| MakeNodeWithAction
	| ParseActionMakeNode
	| ParseActionMakeNodeWA
	;

ParseAction :
	"=>" ParseActionSpec
	;

MakeNode :
	"+>" NodeSpec
	;

MakeNodeWithAction :
	"*>" NodeSpec BlankNodeAction
	| "*>" NodeSpec NodeAction
	;

ParseActionMakeNode :
	"=+>" PANodeSpec BlankParseAction
	;

ParseActionMakeNodeWA :
	"=*>" PANodeSpec BlankParseAction BlankNodeAction
	| "=*>" PANodeSpec BlankParseAction NodeAction
	;

TokenActionSpec :
	TokenActionName Args
	;

TokenActionName :
	TK_alpha
	;

ParseActionSpec :
	ParseActionName Args
	;

ParseActionName :
	TK_alpha
	;

BlankParseAction :
	%empty
	;

NodeSpec :
	NodeName NNArgs
	;

NodeName :
	TK_alpha
	| %empty
	;

PANodeSpec :
	PANodeName NNArgs
	;

PANodeName :
	TK_alpha
	| %empty
	;

NodeAction :
	NodeActionName NAArgs
	;

NodeActionName :
	TK_alpha
	;

BlankNodeAction :
	BlankNodeActionName	NAArgs
	;

BlankNodeActionName :
	%empty
	;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// ARGUMENTS ...

Args :
	%empty
	| '(' ')'
	//| '(' Arg /','... ')'
	| '(' Arg_oom ')'
	;

Arg_oom :
	Arg
	| Arg_oom ',' Arg
	;

NNArgs :
	%empty
	| '(' ')'
	| '(' FirstArg NextArgs_zom ')'
	;

NextArgs_zom :
	%empty
	| ',' Arg
	| ',' NoArg
	| NextArgs_zom ',' Arg
	| NextArgs_zom ',' NoArg
	;

NAArgs :
	NoArg NoArg NoArg
	| '(' NoArg NoArg NoArg ')'
	| '(' NAArg ',' NAArg ',' NAArg ')'
	;

NAArg :
	Arg
	| NoArg
	;

NoArg :
	%empty
	;

FirstArg :
	ArgNum
	;

Arg :
	ArgVar
	| ArgExpr
	;

ArgVar :
	TK_lexical
	| TK_semantic
	| TK_literal
	| TK_string
	| "<eof>"
	| "<error>"
	;

ArgNum :
	TK_integer
	;

ArgExpr :
	ArgExprNum
	| ArgExpr '|' ArgExprNum
	;

ArgExprNum :
	TK_integer
	| TK_alpha
	;

//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

%%

%x head_sym rule_action block_comment

base_id [A-Za-z_][A-Za-z0-9_]*

white_space [\n\r\t ]

%%

<INITIAL,head_sym> {
    {white_space}+  skip()
    "//".*  skip()
    "/*"<>block_comment>
}

<block_comment>{
	"/*"<>block_comment>
	"*/"<<>	skip()
	.|\n<.>
}

"("	'('
")"	')'
"*"	'*'
"+"	'+'
","	','
"->"	"->"
"..."	"..."
"/"	'/'
"/->"	"/->"
"/~>"	"/~>"
":"	':'
";"	';'
"<<"	"<<"
"<eof>"	"<eof>"
"<error>"	"<error>"
"<keyword>"	"<keyword>"
"=*>"	"=*>"
"=+>"	"=+>"
"=>"	"=>"
">>"	">>"
"?"	'?'
"["	'['
"]"	']'
"^"	'^'
"{"	'{'
"|"	'|'
"}"	'}'
"~"	'~'
"~.."	"~.."
"~>"	"~>"

"*>"<rule_action>	"*>"
"+>"<rule_action>	"+>"
<rule_action> {
    {base_id}<INITIAL>	TK_alpha
    \s+ skip()
}

[0-9]+	TK_integer
'(\\.|[^'\n\r\\])+'	TK_literal
\"(\\.|[^"\n\r\\])+\"	TK_string
"{"{base_id}"}"	TK_semantic
"<"{base_id}">"	TK_lexical
{base_id}	TK_alpha

{base_id}({white_space})*(":"|"->")<head_sym>	reject()
<head_sym> {
    ("Goal"|"Start")<INITIAL>	TK_GOALSYMBOL
    {base_id}<INITIAL>   TK_HEADSYMBOL
}

%%
