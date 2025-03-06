//From: https://github.com/eclipse-langium/langium/blob/c3afb247d7dcfd41733c051b8db0395d50398b33/packages/langium/src/grammar/langium-grammar.langium
// ******************************************************************************
// Copyright 2021 TypeFox GmbH
// This program and the accompanying materials are made available under the
// terms of the MIT License, which is available in the project root.
// *****************************************************************************

%token ID
%token NUMBER
%token RegexLiteral
%token STRING

%%

Grammar:
	  Grammar_name_opt GrammarImport_zom Grammar_decl_oom
	;

Grammar_decl_oom:
	  Grammar_decl
	| Grammar_decl_oom Grammar_decl
	;

Grammar_decl:
	  AbstractRule
	| Interface
	| Type
	;

GrammarImport_zom:
	  %empty
	| GrammarImport_zom GrammarImport
	;

Grammar_name_opt:
	  %empty
	| "grammar" ID with_opt hidden_gram_opt
	;

hidden_gram_opt:
	  %empty
	| "hidden" '(' qualname_opt ')'
	;

qualname_opt:
	  %empty
	| ID dot_ID_zom
	;

with_opt:
	  %empty
	| "with" ID dot_ID_zom
	;

dot_ID_zom:
	  %empty
	| dot_ID_zom ',' ID
	;

Interface:
	  "interface" ID extends_opt '{' TypeAttribute_zom '}' semi_opt
	;

semi_opt:
	  %empty
	| ';'
	;

TypeAttribute_zom:
	  %empty
	| TypeAttribute_zom TypeAttribute
	;

extends_opt:
	  %empty
	| "extends" ID dot_ID_zom
	;

TypeAttribute:
	  FeatureName Questiion_opt ':' TypeDefinition assign_ValueLiteral_opt semi_opt
	;

assign_ValueLiteral_opt:
	  %empty
	| '=' ValueLiteral
	;

Questiion_opt:
	  %empty
	| '?'
	;

ValueLiteral:
	  STRING
	| NUMBER
	| BooleanLiteral
	| ArrayLiteral
	;

BooleanLiteral :
	"false"
	| "true"
	;

ArrayLiteral:
	  '[' ValueLiteral_oom_opt ']'
	;

ValueLiteral_oom_opt:
	  %empty
	| ValueLiteral_oom
	;

ValueLiteral_oom:
	  ValueLiteral
	| ValueLiteral_oom  ',' ValueLiteral
	;

TypeDefinition:
	  UnionType
	;

UnionType:
	  ArrayType
	| UnionType  '|' ArrayType
	;

ArrayType:
	  ReferenceType
	| ReferenceType '[' ']'
	;

ReferenceType:
	  SimpleType
	| '@' SimpleType
	;

SimpleType:
	  '(' TypeDefinition ')'
	| ID
	| PrimitiveType
	| STRING
	;

PrimitiveType:
	  "string"
	| "number"
	| "boolean"
	| "Date"
	| "bigint"
	;

Type:
	  "type" ID '=' TypeDefinition semi_opt
	;

AbstractRule:
	  ParserRule
	| TerminalRule
	;

GrammarImport:
	  "import" STRING semi_opt
	;

ParserRule:
	  ruleKind_opt RuleNameAndParams ParserRuleTypeOrReturn_opt hidden_gram_opt ':' Alternatives ';'
	;

ParserRuleTypeOrReturn_opt:
	  %empty
	| '*'
	| "returns" return_type
	| InferredType
	;

return_type:
	  ID
	| PrimitiveType
	;

ruleKind_opt:
	  %empty
	| "entry"
	| "fragment"
	;

InferredType:
	  infer_kw ID
	;

infer_kw:
	  "infer"
	| "infers"
	;

RuleNameAndParams:
	  ID
	| ID '<' Parameter_oom_opt '>'
	;

Parameter_oom_opt:
	  %empty
	| Parameter_oom
	;

Parameter_oom:
	  Parameter
	| Parameter_oom ',' Parameter
	;

Parameter:
	  ID
	;

Alternatives:
	  ConditionalBranch
	| Alternatives  '|' ConditionalBranch
	;

ConditionalBranch:
	  UnorderedGroup
	| '<' Disjunction '>' AbstractToken_oom
	;

AbstractToken_oom:
	  AbstractToken
	| AbstractToken_oom AbstractToken
	;

UnorderedGroup:
	  Group
	| UnorderedGroup  '&' Group
	;

Group:
	  AbstractToken
	| Group AbstractToken
	;

AbstractToken:
	  AbstractTokenWithCardinality
	| Action
	;

AbstractTokenWithCardinality:
	  Assignment_or_AbstractTerminal repeat_op_opt
	;

repeat_op_opt:
	  %empty
	| '?'
	| '*'
	| '+'
	;

Assignment_or_AbstractTerminal:
	  Assignment
	| AbstractTerminal
	;

Action:
	  '{' action_key action_key_tail_opt '}'
	;

action_key_tail_opt:
	  %empty
	| '.' FeatureName feature_assign_kind "current"
	;

feature_assign_kind:
	  '='
	| "+="
	;

action_key:
	  ID
	| InferredType
	;

AbstractTerminal:
	  Keyword
	| RuleCall
	| ParenthesizedElement
	| PredicatedKeyword
	| PredicatedRuleCall
	| PredicatedGroup
	| EndOfFile
	;

EndOfFile:
	  "EOF"
	;

Keyword:
	  STRING
	;

RuleCall:
	  ID RuleCallType_opt
	;

RuleCallType_opt:
	  %empty
	| '<' NamedArgument comma_NamedArgument_zom '>'
	;

comma_NamedArgument_zom:
	  %empty
	| comma_NamedArgument_zom ',' NamedArgument
	;

NamedArgument:
	  Disjunction
	| ID '=' Disjunction
	;

Disjunction:
	  Conjunction
	| Disjunction '|' Conjunction
	;

Conjunction:
	  Negation
	| Conjunction '&' Negation
	;

Negation:
	  Atom
	| '!' Negation
	;

Atom:
	  ParameterReference
	| ParenthesizedCondition
	| BooleanLiteral
	;

ParenthesizedCondition:
	  '(' Disjunction ')'
	;

ParameterReference:
	  ID
	;

PredicatedKeyword:
	  pred_arrow STRING
	;

pred_arrow:
	  "=>"
	| "->"
	;

PredicatedRuleCall:
	  pred_arrow ID RuleCallType_opt
	;

Assignment:
	  FeatureName Assignment_op AssignableTerminal
	|  pred_arrow FeatureName Assignment_op AssignableTerminal
	;

Assignment_op:
	  "+="
	| '='
	| "?="
	;

AssignableTerminal:
	  Keyword
	| RuleCall
	| ParenthesizedAssignableElement
	| CrossReference
	;

ParenthesizedAssignableElement:
	  '(' AssignableAlternatives ')'
	;

AssignableAlternatives:
	  AssignableTerminal
	| AssignableAlternatives '|' AssignableTerminal
	;

CrossReference:
	  '[' ID CrossReferenceableTerminal_zom ']'
	;

CrossReferenceableTerminal_zom:
	  %empty
	| bar_or_colon CrossReferenceableTerminal
	;

bar_or_colon:
	  '|'
	| ':'
	;

CrossReferenceableTerminal:
	  Keyword
	| RuleCall
	;

ParenthesizedElement:
	  '(' Alternatives ')'
	;

PredicatedGroup:
	  pred_arrow '(' Alternatives ')'
	;

ReturnType:
	  PrimitiveType
	| ID
	;

TerminalRule:
	  hidden_opt "terminal" TerminalRuleName ':' TerminalAlternatives ';'
	;

TerminalRuleName:
	  "fragment" ID
	| ID returns_opt
	;

returns_opt:
	  %empty
	| "returns" ReturnType
	;

hidden_opt:
	  %empty
	| "hidden"
	;

TerminalAlternatives:
	  TerminalGroup
	| TerminalAlternatives '|' TerminalGroup
	;

TerminalGroup:
	  TerminalToken
	| TerminalGroup TerminalToken
	;

TerminalToken:
	  TerminalTokenElement repeat_op_opt
	;

TerminalTokenElement:
	  CharacterRange
	| TerminalRuleCall
	| ParenthesizedTerminalElement
	| NegatedToken
	| UntilToken
	| RegexToken
	| Wildcard
	;

ParenthesizedTerminalElement:
	  '(' TerminalAlternativeKind TerminalAlternatives ')'
	;

TerminalAlternativeKind:
	  %empty
	| "?="
	| "?!"
	| "?<="
	| "?<!"
	;

TerminalRuleCall:
	  ID
	;

NegatedToken:
	  '!' TerminalTokenElement
	;

UntilToken:
	  "->" TerminalTokenElement
	;

RegexToken:
	  RegexLiteral
	;

Wildcard:
	  '.'
	;

CharacterRange:
	  Keyword
	| Keyword ".." Keyword
	;

FeatureName:
	  "current"
	| "entry"
	| "extends"
	| "false"
	| "fragment"
	| "grammar"
	| "hidden"
	| "import"
	| "interface"
	| "returns"
	| "terminal"
	| "true"
	| "type"
	| "infer"
	| "infers"
	| "with"
	| PrimitiveType
	| ID
	;

%%

%x IN_REGEX IN_CLASS

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"!"	'!'
"&"	'&'
"("	'('
")"	')'
"*"	'*'
"+"	'+'
"+="	"+="
","	','
"->"	"->"
"."	'.'
".."	".."
":"	':'
";"	';'
"<"	'<'
"="	'='
"=>"	"=>"
">"	'>'
"?!"	"?!"
"?"	'?'
"?<!"	"?<!"
"?<="	"?<="
"?="	"?="
"@"	'@'
"Date"	"Date"
"EOF"	"EOF"
"["	'['
"]"	']'
"bigint"	"bigint"
"boolean"	"boolean"
"current"	"current"
"entry"	"entry"
"extends"	"extends"
"false"	"false"
"fragment"	"fragment"
"grammar"	"grammar"
"hidden"	"hidden"
"import"	"import"
"infer"	"infer"
"infers"	"infers"
"interface"	"interface"
"number"	"number"
"returns"	"returns"
"string"	"string"
"terminal"	"terminal"
"true"	"true"
"type"	"type"
"with"	"with"
"{"	'{'
"|"	'|'
"}"	'}'

"/"<IN_REGEX>
<IN_REGEX>{
	"/"[a-z]*<INITIAL>	RegexLiteral
	\\.<.>
	"["<>IN_CLASS>
	[^/\\]<.>
}
<IN_CLASS>{
	"]"<<>
	\\.<.>
	[^\]\\]<.>
}

NaN|"-"?((\d*\.\d+|\d+)([Ee][+-]?\d+)?|Infinity)	NUMBER
\"(\\.|[^"\\])*\"|'(\\.|[^'\\])*'	STRING

"^"?[_a-zA-Z][\w_]*	ID

//terminal ID: /\^?[_a-zA-Z][\w_]*/;
//terminal STRING: /"(\\.|[^"\\])*"|'(\\.|[^'\\])*'/;
//terminal NUMBER returns number: /NaN|-?((\d*\.\d+|\d+)([Ee][+-]?\d+)?|Infinity)/;
//terminal RegexLiteral returns string: /\/(?![*+?])(?:[^\r\n\[/\\]|\\.|\[(?:[^\r\n\]\\]|\\.)*\])+\/[a-z]*/;
//
//hidden terminal WS: /\s+/;
//hidden terminal ML_COMMENT: /\/\*[\s\S]*?\*\//;
//hidden terminal SL_COMMENT: /\/\/[^\n\r]*/;

%%
