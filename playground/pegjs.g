//From: https://github.com/pegjs/pegjs/blob/b7b87ea8aeeaa1caf096e2da99fd95a971890ca1/src/parser.pegjs
// PEG.js Grammar
// ==============
//
// PEG.js grammar syntax is designed to be simple, expressive, and similar to
// JavaScript where possible. This means that many rules, especially in the
// lexical part, are based on the grammar from ECMA-262, 5.1 Edition [1]. Some
// are directly taken or adapted from the JavaScript example grammar (see
// examples/javascript.pegjs).
//
// Limitations:
//
//   * Non-BMP characters are completely ignored to avoid surrogate pair
//     handling.
//
//   * One can create identifiers containing illegal characters using Unicode
//     escape sequences. For example, "abcd\u0020efgh" is not a valid
//     identifier, but it is accepted by the parser.
//
// Both limitations could be resolved, but the costs would likely outweigh
// the benefits.
//
// [1] http://www.ecma-international.org/publications/standards/Ecma-262.htm

%token AnyMatcher
%token CharacterClassMatcher
%token CodeBlock
%token Identifier
//%token LiteralMatcher
%token StringLiteral
%token LabelId RuleId

%%

// ---- Syntactic Grammar -----

Grammar:
	  Initializer_opt Rule_oom
	;

Rule_oom:
	  Rule
	| Rule_oom Rule
	;

Initializer_opt:
	  %empty
	| Initializer
	;

Initializer:
	  CodeBlock
	;

Rule:
	  RuleId StringLiteral_opt '=' Expression
	;

StringLiteral_opt:
	  %empty
	| StringLiteral
	;

Expression:
	  ChoiceExpression
	;

ChoiceExpression:
	  ActionExpression
	| ChoiceExpression '/' ActionExpression
	;

ActionExpression:
	  SequenceExpression CodeBlock_opt
	;

CodeBlock_opt:
	  %empty
	| CodeBlock
	;

SequenceExpression:
	 LabeledExpression
	| SequenceExpression LabeledExpression
	;

LabeledExpression:
	  '@' LabelIdentifier_opt PrefixedExpression
	| LabelIdentifier PrefixedExpression
	| PrefixedExpression
	;

LabelIdentifier_opt:
	  %empty
	| LabelIdentifier
	;

LabelIdentifier:
	  LabelId ':'
	;

PrefixedExpression:
	  PrefixedOperator SuffixedExpression
	| SuffixedExpression
	;

PrefixedOperator:
	  '$'
	| '&'
	| '!'
	;

SuffixedExpression:
	  PrimaryExpression SuffixedOperator
	| PrimaryExpression
	;

SuffixedOperator:
	  '?'
	| '*'
	| '+'
	;

PrimaryExpression:
	  StringLiteral
	| CharacterClassMatcher
	| AnyMatcher
	| RuleReferenceExpression
	| SemanticPredicateExpression
	| '(' Expression ')'
	;

RuleReferenceExpression:
	  Identifier
	;

SemanticPredicateExpression:
	  SemanticPredicateOperator CodeBlock
	;

SemanticPredicateOperator:
	  '&'
	| '!'
	;

%%

%x CODE_BLOCK LABEL_ID RULE_ID

STR ('(\\.|[^'\r\n\\])*'|\"(\\.|[^"\r\n\\])*\")
ID  [A-Za-z_$][A-Za-z0-9_]*

%%
// ---- Lexical Grammar -----

[ \t\v\f\n\r]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"!"	'!'
"$"	'$'
"&"	'&'
"("	'('
")"	')'
"*"	'*'
"+"	'+'
"/"	'/'
":"	':'
"="	'='
"?"	'?'
"@"	'@'
"."	AnyMatcher
"[""^"?(\\.|[^\]\r\n\\])+"]"	CharacterClassMatcher
"{"<>CODE_BLOCK>
<CODE_BLOCK>{
    "}"<<>  CodeBlock
    "{"<>CODE_BLOCK>
    {STR}<.>
    \n|.<.>
}
//LiteralMatcher	LiteralMatcher

{STR}i?	StringLiteral

{ID}\s*":"<LABEL_ID>    reject()
<LABEL_ID>{
    {ID}<INITIAL>	LabelId
}

{ID}\s+{STR}\s*"="<RULE_ID>   reject()
{ID}\s*"="<RULE_ID>   reject()
<RULE_ID>{
    {ID}<INITIAL>	RuleId
}

{ID}	Identifier

%%
