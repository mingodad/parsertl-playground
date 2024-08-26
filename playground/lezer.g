//%token ILLEGAL_CHARACTER

%token name AtName Literal CharSet InvertedCharSet AnyChar

%token "as" "from" "extend" "prop" "propSource" "specialize" "tokens"
%fallback name "as" "from" "extend" "prop" "propSource" "specialize" "tokens"

/*
%precedence scopedSkip
%precedence repeat
%precedence inline
%precedence namespace
%precedence call
*/

%start Grammar

%%

Grammar:
	declaration_zom
	;

declaration_zom:
	%empty
	| declaration_zom declaration
	;

declaration:
	RuleDeclaration
	| topRuleDeclaration
	| PrecedenceDeclaration
	| TokensDeclaration
	| LocalTokensDeclaration
	| ExternalTokensDeclaration
	| ExternalPropDeclaration
	| ExternalPropSourceDeclaration
	| ExternalSpecializeDeclaration
	| ContextDeclaration
	| DialectsDeclaration
	| TopSkipDeclaration
	| SkipScope
	| DetectDelimDeclaration
	;

PrecedenceDeclaration:
	"@precedence" '{' Precedence CommaOptPrecedence_zom '}'
	;

CommaOptPrecedence_zom:
	%empty
	| CommaOptPrecedence_zom Comma_opt Precedence
	;

Comma_opt:
	%empty
	| ','
	;

Precedence:
	PrecedenceName PrecedenceType_opt
	;

PrecedenceType_opt:
	%empty
	| PrecedenceType
	;

PrecedenceType:
	"@left"
	| "@right"
	| "@cut"
	;

TokensDeclaration:
	"@tokens" '{' tokenDeclaration_zom '}'
	;

TokensBody:
	'{' tokenDeclarationOrElseToken_zom '}'
	;

tokenDeclaration_zom:
	%empty
	| tokenDeclaration_zom tokenDeclaration
	;

externalTokenSet:
	'{' externalTokenSetElements '}'
	;

externalTokenSetElements:
	%empty
	| externalTokenSetElements Token Comma_opt
	;

Token:
	RuleName Props_opt
	;

Props_opt:
	%empty
	| Props
	;

LocalTokensDeclaration:
	"@local" "tokens" TokensBody
	;

tokenDeclarationOrElseToken_zom:
	%empty
	| tokenDeclarationOrElseToken_zom tokenDeclarationOrElseToken
	;

tokenDeclarationOrElseToken:
	tokenDeclaration
	| ElseToken
	;

ElseToken:
	"@else" RuleName Props_opt
	;

ExternalTokensDeclaration:
	"@external" "tokens" Name "from" Literal externalTokenSet
	;

ExternalPropDeclaration:
	"@external" "prop" Name AsName_opt "from" Literal
	;

AsName_opt:
	%empty
	| "as" Name
	;

ExternalPropSourceDeclaration:
	"@external" "propSource" Name "from" Literal
	;

ExternalSpecializeDeclaration:
	"@external" ExternalSpecializeType Body Name "from" Literal externalTokenSet
	;

ExternalSpecializeType:
	"extend"
	| "specialize"
	;

ContextDeclaration:
	"@context" Name "from" Literal
	;

DialectsDeclaration:
	"@dialects" DialectBody
	;

DialectBody:
	'{' DialectBodyElements '}'
	;

DialectBodyElements:
	%empty
	| DialectBodyElements Name Comma_opt
	;

TopSkipDeclaration:
	"@skip" Body
	;

SkipScope:
	"@skip" Body SkipBody
	;

SkipBody:
	'{' SkipBodyElements '}'
	;

SkipBodyElements:
	%empty
	| SkipBodyElements RuleDeclaration
	| SkipBodyElements topRuleDeclaration
	;

DetectDelimDeclaration:
	"@detectDelim"
	;

tokenDeclaration:
	TokenPrecedenceDeclaration
	| TokenConflictDeclaration
	| LiteralTokenDeclaration
	| RuleDeclaration
	;

TokenPrecedenceDeclaration:
	"@precedence" '{' LiteralOrNameExpressionCommaOpt_zom '}'
	;

LiteralOrNameExpressionCommaOpt_zom:
	%empty
	| LiteralOrNameExpressionCommaOpt_zom LiteralOrNameExpression Comma_opt
	;

LiteralOrNameExpression:
	Literal
	| nameExpression
	;

TokenConflictDeclaration:
	"@conflict" ConflictBody
	;

ConflictBody:
	'{' LiteralOrNameExpression Comma_opt LiteralOrNameExpression '}'
	;

LiteralTokenDeclaration:
	Literal Props_opt
	;

RuleDeclaration:
	RuleName Props_opt ParamList_opt Body
	;

ParamList_opt:
	%empty
	| ParamList
	;

topRuleDeclaration:
	"@top" RuleName Props_opt ParamList_opt Body
	;

ParamList:
	'<' ParamListArgs_opt '>'
	;

ParamListArgs_opt:
	%empty
	| ParamListElm CommaParamListElm_zom
	;

CommaParamListElm_zom:
	%empty
	| CommaParamListElm_zom ',' ParamListElm
	;

ParamListElm:
	Name
	| AtName
	| Literal
	;

Body:
	'{' Expression_opt '}'
	;

Expression_opt:
	%empty
	| expression
	;

Props:
	'[' PropList_opt ']'
	;

PropList_opt:
	%empty
	| PropComma_zom Prop
	;

PropComma_zom:
	%empty
	| PropComma_zom Prop ','
	;

Prop:
	NameOrAtName
	| NameOrAtName '=' Assignables_zom
	;

Assignables_zom:
	%empty
	| Assignables_zom Assignables
	;

Assignables:
	Literal
	| Name
	| '.'
	| '{' RuleName '}' #PropEsc
	;

NameOrAtName:
	AtName
	| Name
	;

expression:
	seqExpression
	| Choice
	;

Choice:
	seqExpression_opt altSeqExpression_oom
	;

altSeqExpression_oom:
	altSeqExpression
	| altSeqExpression_oom altSeqExpression
	;

altSeqExpression:
	'|' seqExpression_opt
	;

seqExpression_opt:
	%empty
	| seqExpression
	;

seqExpression:
	atomExpression
	| Sequence
	;

Sequence:
	marker atomExpressionOrMarker_zom
	| atomExpression atomExpressionOrMarker_oom
	;

atomExpressionOrMarker_oom:
	atomExpressionOrMarker
	| atomExpressionOrMarker_oom atomExpressionOrMarker
	;

atomExpressionOrMarker_zom:
	%empty
	| atomExpressionOrMarker_zom atomExpressionOrMarker
	;

atomExpressionOrMarker:
	atomExpression
	| marker
	;

atomExpression:
	Literal
	| CharSet
	| AnyChar
	| InvertedCharSet
	| nameExpression
	| CharClass
	| Optional
	| Repeat
	| Repeat1
	| InlineRule
	| ParenExpression
	| Specialization
	;

CharClass:
	"@asciiLetter"
	| "@asciiUpperCase"
	| "@asciiLowerCase"
	| "@digit"
	| "@whitespace"
	| "@eof"
	;

Optional:
	atomExpression '?'
	;

Repeat:
	atomExpression '*'
	;

Repeat1:
	atomExpression '+'
	;

InlineRule:
	RuleNameOrProps Body
	;

RuleNameOrProps:
	RuleName Props_opt
	| Props
	;

ParenExpression:
	'(' Expression_opt ')'
	;

Specialization:
	Specialization_type Props_opt ArgList
	;

Specialization_type:
	"@specialize"
	| "@extend"
	;

nameExpression:
	RuleName
	| ScopedName
	| Call
	;

Call:
	CallName ArgList
	;

CallName:
	RuleName
	| ScopedName
	;

marker:
	PrecedenceMarker
	| AmbiguityMarker
	;

PrecedenceMarker:
	'!' PrecedenceName
	;

ScopedName:
	RuleName '.' RuleName
	;

AmbiguityMarker:
	'~' Name
	;

ArgList:
	'<' expression_oom '>'
	;

expression_oom:
	expression
	| expression_oom ',' expression
	;

RuleName:
	name
	;

PrecedenceName:
	name
	| name ArgList
	| Literal
	;

Name:
	name
	;

%%

whitespace	[ \t\n\r\f]
LineComment "//".*
BlockComment "/*"(?s:.)*?"*/"

asciiLowercase [a-z]
asciiUppercase [A-Z]
/*@eof matches the end of the input*/
asciiLetter	[A-Za-z]
digit	[0-9]
/*name_other	[\-_\u{a1}-\u{10ffff}]*/
name_other	{asciiLetter}|[\-_0-9]
name ({asciiLetter}|{digit}|{name_other})+

Literal \"([^\\\n"]|\\.)*\"|'([^\\\n']|\\.)*'

CharSet "$["([^\\\]]|\\.)*"]"
InvertedCharSet "!["([^\\\]]|\\.)*"]"

%%

{whitespace}+	skip()
{LineComment}	skip()
{BlockComment}	skip()

"~"	'~'
"<"	'<'
"="	'='
">"	'>'
"|"	'|'
","	','
"!"	'!'
"?"	'?'
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"*"	'*'
"+"	'+'
"as"	"as"
"@asciiLetter"	"@asciiLetter"
"@asciiLowerCase"	"@asciiLowerCase"
"@asciiUpperCase"	"@asciiUpperCase"
"@conflict"	"@conflict"
"@context"	"@context"
"@cut"	"@cut"
"@detectDelim"	"@detectDelim"
"@dialects"	"@dialects"
"@digit"	"@digit"
"@else"	"@else"
"@eof"	"@eof"
"@extend"	"@extend"
"extend"	"extend"
"@external"	"@external"
"from"	"from"
"@left"	"@left"
"@local"	"@local"
"@precedence"	"@precedence"
"prop"	"prop"
"propSource"	"propSource"
"@right"	"@right"
"@skip"	"@skip"
"@specialize"	"@specialize"
"specialize"	"specialize"
"@tokens"	"@tokens"
"tokens"	"tokens"
"@top"	"@top"
"@whitespace"	"@whitespace"

"_"	AnyChar

/*@precedence { AnyChar, whitespace, name }*/


/*@precedence { whitespace, keyword }*/

"@"{name}	AtName

{Literal}	Literal

{CharSet}	CharSet
{InvertedCharSet}	InvertedCharSet

/*@precedence { InvertedCharSet, "!" }*/

{name} name

//.	ILLEGAL_CHARACTER

%%
