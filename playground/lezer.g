%token ILLEGAL_CHARACTHER

%token name AtName Literal CharSet InvertedCharSet AnyChar

%precedence scopedSkip
%precedence repeat
%precedence inline
%precedence namespace
%precedence call

%start lezer

%%

lezer :
	declaration*
	;

declaration :
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

PrecedenceDeclaration :
	"@precedence" PrecedenceBody
	;

PrecedenceBody :
	"{" (Precedence ","?)* "}"
	;

Precedence : PrecedenceName ("@left" | "@right" | "@cut")? ;

TokensDeclaration :
	"@tokens" TokensBody
	;

TokensBody : "{" tokenDeclaration* "}" ;

externalTokenSet :
	"{" (Token ","?)* "}"
	;

Token : RuleName Props? ;

LocalTokensDeclaration :
	"@local" "tokens" TokensBody
	;

TokensBody : "{" (tokenDeclaration | ElseToken)* "}" ;

ElseToken : "@else" RuleName Props? ;

ExternalTokensDeclaration :
	"@external" "tokens" Name "from" Literal externalTokenSet
	;

ExternalPropDeclaration :
	"@external" "prop" Name ("as" Name)? "from" Literal
	;

ExternalPropSourceDeclaration :
	"@external" "propSource" Name "from" Literal
	;

ExternalSpecializeDeclaration :
	"@external" ("extend" | "specialize") Body Name "from" Literal externalTokenSet
	;

ContextDeclaration :
	"@context" Name "from" Literal
	;

DialectsDeclaration :
	"@dialects" DialectBody
	;

DialectBody : "{" (Name ","?)* "}" ;

TopSkipDeclaration :
	"@skip" Body
	;

SkipScope :
	"@skip" Body /*%prec scopedSkip*/ SkipBody
	;

SkipBody : "{" (RuleDeclaration | topRuleDeclaration)* "}" ;

DetectDelimDeclaration : "@detectDelim" ;

tokenDeclaration :
	TokenPrecedenceDeclaration
	| TokenConflictDeclaration
	| LiteralTokenDeclaration
	| RuleDeclaration
	;

TokenPrecedenceDeclaration :
	"@precedence" PrecedenceBody
	;

PrecedenceBody : "{" ((Literal | nameExpression) ","?)* "}" ;

TokenConflictDeclaration :
	"@conflict" ConflictBody
	;

ConflictBody : "{" (Literal | nameExpression) ","? (Literal | nameExpression) "}" ;

LiteralTokenDeclaration :
	Literal Props?
	;

RuleDeclaration : RuleName Props? ParamList? Body ;

topRuleDeclaration : "@top" RuleName Props? ParamList? Body ;

ParamList : "<" (ParamListElm ("," ParamListElm)*)? ">" ;
ParamListElm : Name | AtName | Literal ;

Body : "{" expression? "}" ;

Props : "[" ((Prop ",")* Prop)? "]" ;

Prop : (AtName | Name) ("=" (Literal | Name | "." | PropEsc)*)? ;

PropEsc : "{" RuleName "}" ;

expression :
	seqExpression
	| Choice
	;

Choice : seqExpression? ("|" seqExpression?)+ ;

seqExpression :
	atomExpression
	| Sequence
	;

Sequence :
	marker (atomExpression | marker)*
	| atomExpression (atomExpression | marker)+
	;

atomExpression :
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

CharClass :
	"@asciiLetter" | "@asciiUpperCase" | "@asciiLowerCase" | "@digit" | "@whitespace" | "@eof"
	;
Optional : atomExpression /*%prec repeat*/ "?" ;
Repeat : atomExpression /*%prec repeat*/ "*" ;
Repeat1 : atomExpression /*%prec repeat*/ "+" ;
InlineRule : (RuleName /*%prec inline*/ Props? | Props) Body ;
ParenExpression : "(" expression? ")" ;
Specialization : ("@specialize" | "@extend") Props? ArgList ;

nameExpression :
	RuleName
	| ScopedName
	| Call
	;

Call : (RuleName | ScopedName) /*%prec*/ call ArgList ;

marker :
	PrecedenceMarker
	| AmbiguityMarker
	;

PrecedenceMarker : "!" PrecedenceName ;

ScopedName : RuleName /*%prec namespace*/ "." RuleName ;
AmbiguityMarker : "~" Name ;

ArgList :
	"<" (expression ("," expression)*)? ">"
	;

RuleName : name ;

PrecedenceName : name ;

Name : name ;

/*
kw<value> { @specialize[@name={value}]<keyword, value> }

at<value> { @specialize[@name={value}]<AtName, value> }
*/


//@external propSource lezerHighlighting from "./highlight"

//@detectDelim

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

"~"	"~"
"<"	"<"
"="	"="
">"	">"
"|"	"|"
","	","
"!"	"!"
"?"	"?"
"."	"."
"("	"("
")"	")"
"["	"["
"]"	"]"
"{"	"{"
"}"	"}"
"*"	"*"
"+"	"+"
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

{name}  name

.	ILLEGAL_CHARACTHER

%%
