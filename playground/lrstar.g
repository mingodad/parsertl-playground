//From: https://github.com/thutt/lrstar/blob/29433f7fdbd4642168d9920f08d1365cff9757f9/src/lrstar/PG.grm.grammar.txt
////////////////////////////////////////////////////////////////////////////////////////////////////
//
// LRSTAR 24 Grammar
//
// This grammar is LALR(1) because the headsymbol() does a get-next-token
// to see if the next token is a "->" or a ':', which would indicate that
// the current token is the goal symbol of the grammar.
//
// Aug 15 2022 by Paul B Mann
//

//%token ERRORSYMBOL
//%token EOFSYMBOL
%token GOALSYMBOL
%token HEADSYMBOL
%token ALPHA
%token LEXICAL
%token LITERAL
%token SEMANTIC
%token INTEGER
//%token STRINGX
//%token EOFLITERAL
//%token ARROW
//%token COLON
//%token BAR
//%token SEMI
//%token ACTION

//%fallback SEMANTIC GOALSYMBOL HEADSYMBOL

%%

/* Productions */

Goal
	: Grammar //eof
	;

Grammar
	: Declarations OperPrec Rules
	;

Declarations
	:
	| TerminalDecl_plus
	;

TerminalDecl
	: DefCon Terminal ';'
	| DefCon Terminal TerminalAction ';'
	| Terminal ';'
	| Terminal TerminalAction ';'
	;

DefCon
	: ALPHA
	;

Terminal
	: ALPHA
	| LEXICAL
	| LITERAL
	| SEMANTIC
	| "<eof>"
	;

OperPrec
	:
	| OperPrecLine_plus
	;

OperPrecLine
	: '{' Operator_plus '}' "<<"
	| '{' Operator_plus '}' ">>"
	;

Operator
	: ALPHA
	| LEXICAL
	| SEMANTIC
	| LITERAL
	;

Rules
	: GoalSymbolDef NonterminalDef_zom
	;

GoalSymbolDef
	: GoalSymbol GoalSymbolRule
	;

GoalSymbol
	: GOALSYMBOL
	;

GoalSymbolRule
	: ':' GoalExprList RuleAction ';'
	| "->" GoalExprList RuleAction
	;

GoalExprList
	: TailExpr EOFTailExpr
	;

EOFTailExpr
	: EOFTail
	;

EOFTail
	: "<eof>"
	| ALPHA
	;

NonterminalDef
	: HeadSymbol ColonFirst ';'
	| HeadSymbol ColonFirst BarRules ';'
	| HeadSymbol ArrowFirst
	| HeadSymbol ArrowFirst ArrowRules
	;

HeadSymbol
	: HEADSYMBOL
	;

ColonFirst
	: ':' TailList RuleAction
	| ':' SemTail RuleAction
	;

ArrowFirst
	: "->" TailList RuleAction
	| "->" SemTail RuleAction
	;

BarRules
	: BarRule_plus
	;

BarRule
	: '|' TailList RuleAction
	| '#' '|' TailList RuleAction
	| '|' SemTail RuleAction
	;

ArrowRules
	: ArrowRule_plus
	;

ArrowRule
	: "->" TailList RuleAction
	| '#' "->" TailList RuleAction
	| "->" SemTail RuleAction
	;

TailList
	:
	| TailExpr_plus
	;

SemTail
	: TailUpgrade
	;

TailUpgrade
	: TailUpgrade2
	;

TailExpr
	: Tail
	| ComplexTail
	;

ComplexTail
	: Tail '+'
	| Tail "..."
	| Tail '*'
	| Tail '?'
	| Tail '/' SepExpr '+'
	| Tail '/' SepExpr "..."
	| Tail '/' SepExpr '*'
	| Group
	| Group '+'
	| Group "..."
	| Group '*'
	| Group '?'
	| Group '/' SepExpr '+'
	| Group '/' SepExpr "..."
	| Group '/' SepExpr '*'
	| OptGroup
	| OptGroup '+'
	| OptGroup "..."
	| OptGroup '/' SepExpr '+'
	| OptGroup '/' SepExpr "..."
	;

Group
	: '(' ComplexSection_or_plus ')'
	;

OptGroup
	: '[' ComplexSection_or_plus ']'
	;

SepGroup
	: '(' SimpleSection_or_plus ')'
	;

ComplexSection
	: Tail_or_ComplexTail_plus
	;

SimpleSection
	: Tail_plus
	;

SepExpr
	: Sep
	| SepGroup
	;

TailUpgrade2
	: LexVar '^' SemVar
	;

LexVar
	: ALPHA
	| LEXICAL
	;

SemVar
	: ALPHA
	| SEMANTIC
	;

Tail
	: ALPHA
	| LEXICAL
	| LITERAL
	| SEMANTIC
	;

Sep
	: ALPHA
	| LEXICAL
	| LITERAL
	| SEMANTIC
	;

TerminalAction
	: "=>" TAName
	;

TAName
	: ALPHA TArgs
	;

RuleAction
	:
	| "+>" NodeName PArgs Rev
	| "*>" NodeNameWA PArgs Rev
	;

NodeName
	: ALPHA
	;

NodeNameWA
	: NodeAction
	;

NodeAction
	: ALPHA
	;

Rev
	:
	| '~'
	;

TArgs
	:
	| '(' ')'
	| '(' ArgVar ')'
	;

PArgs
	:
	| '(' ')'
	| '(' FirstArg ')'
	;

FirstArg
	: ArgNum
	;

ArgNum
	: INTEGER
	;

ArgVar
	: ALPHA
	| LEXICAL
	| LITERAL
	| SEMANTIC
	| "<eof>"
	;

TerminalDecl_plus
	: TerminalDecl
	| TerminalDecl_plus TerminalDecl
	;

OperPrecLine_plus
	: OperPrecLine
	| OperPrecLine_plus OperPrecLine
	;

Operator_plus
	: Operator
	| Operator_plus Operator
	;

NonterminalDef_zom
	:
	| NonterminalDef_zom NonterminalDef
	;

BarRule_plus
	: BarRule
	| BarRule_plus BarRule
	;

ArrowRule_plus
	: ArrowRule
	| ArrowRule_plus ArrowRule
	;

TailExpr_plus
	: TailExpr
	| TailExpr_plus TailExpr
	;

ComplexSection_or_plus
	: ComplexSection
	| ComplexSection_or_plus '|' ComplexSection
	;

SimpleSection_or_plus
	: SimpleSection
	| SimpleSection_or_plus '|' SimpleSection
	;

Tail_or_ComplexTail
	: Tail
	| ComplexTail
	;

Tail_or_ComplexTail_plus
	: Tail_or_ComplexTail
	| Tail_or_ComplexTail_plus Tail_or_ComplexTail
	;

Tail_plus
	: Tail
	| Tail_plus Tail
	;

%%

%x head_sym rule_action

base_id [A-Za-z_][A-Za-z0-9_]*

white_space [\n\r\t ]
line_comment    "//".*
blocl_comment   "/*"(?s:.)*?"*/"

%%

<INITIAL,head_sym> {
    {white_space}+  skip()
    {line_comment}  skip()
    {blocl_comment}    skip()
}

";"	';'
"<eof>"	"<eof>"
"{"	'{'
"}"	'}'
"<<"	"<<"
">>"	">>"
":"	':'
"->"	"->"
"|"	'|'
"#"	'#'
"+"	'+'
"..."	"..."
"*"	'*'
"?"	'?'
"/"	'/'
"("	'('
")"	')'
"["	'['
"]"	']'
"^"	'^'
"=>"	"=>"
"+>"<rule_action>	"+>"
"*>"<rule_action>	"*>"
"~" '~'

<rule_action> {
    {base_id}<INITIAL>	ALPHA
    \s+ skip()
}
\"(\\.|[^"\n\r\\])+\"	LITERAL
'(\\.|[^'\n\r\\])+'	LITERAL
[0-9]+	INTEGER

"{"{base_id}"}"	SEMANTIC
"<"{base_id}">"	LEXICAL
{base_id}	ALPHA

{base_id}({white_space})*(":"|"->")<head_sym>	reject()
<head_sym> {
    ("Goal"|"Start")<INITIAL>	GOALSYMBOL
    {base_id}   HEADSYMBOL
    (":"|"->")<INITIAL> reject()
}

%%
