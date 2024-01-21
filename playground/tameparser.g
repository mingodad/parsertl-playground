%token language import lexer_symbols lexer
%token ignore weak keywords grammar replace parser
%token test from case sensitive insensitive precedence
%token left right non_associative non_assoc conflict
%token shift reduce can_clash identifier nonterminal
%token regex string character

%%
//
// The top-level definitions
//

Parser_Language :
	TopLevel_Block*
	;

TopLevel_Block : Language_Block
	| Import_Block
	| Parser_Block
	| Test_Block
	;

Language_Block :
	language identifier Language_Inherits? '{' Language_Definition* '}'
	;

Import_Block :
	import string
	;

Language_Inherits :
	':' identifier
	;

//
// The language block
//

Language_Definition :
	Lexer_Symbols_Definition
	| Lexer_Definition
	| Ignore_Definition
	| Keywords_Definition
	| Grammar_Definition
	| Precedence_Definition
	;

//
// Basic language items
//

Lexer_Symbols_Definition :
	Lexer_Symbols_Modifier* lexer_symbols '{' Lexeme_Definition* '}'
	;

Lexer_Definition :
	//[=> <Lexer-Modifier>* lexer]
	Lexer_Modifier* lexer '{' Lexeme_Definition* '}'
	;

Ignore_Definition :
	ignore '{' Keyword_Definition* '}'
	;

Keywords_Definition :
	//[=> <Lexer-Modifier>* keywords]
	Lexer_Modifier* keywords '{' Keyword_Definition* '}'
	;

Lexer_Modifier :
	weak
	| case sensitive
	| case insensitive
	;

Lexer_Symbols_Modifier :
	case sensitive
	| case insensitive
	;

Keyword_Definition :
	identifier
	| Lexeme_Definition
	;

Lexeme_Definition :
	identifier ('=' | "|=") (regex | string | character)
	| /*[=> replace identifier '=']*/ replace identifier '=' (regex | string | character)
	| identifier '=' identifier '.' identifier
	;

//
// Defining grammars
//

Grammar_Definition :
	grammar '{' Nonterminal_Definition* '}'
	;

Nonterminal_Definition :
	//[=> nonterminal ('=' | "|=")]
	nonterminal ('=' | "|=") Production ('|' Production)*
	| /*[=> replace nonterminal '=']*/ replace nonterminal '=' Production ('|' Production)*
	;

// Top level is just a simple EBNF term, as the '|' operator creates a new production at this point
Production :
	Simple_Ebnf_Item*
	;

Ebnf_Item :
	Simple_Ebnf_Item*
	| Simple_Ebnf_Item* '|' Ebnf_Item
	;

Simple_Ebnf_Item :
	Nonterminal Semantic_Specification?
	| Terminal Semantic_Specification?
	| Guard Semantic_Specification?
	| Simple_Ebnf_Item '*' Semantic_Specification?
	| Simple_Ebnf_Item '+' Semantic_Specification?
	| Simple_Ebnf_Item '?' Semantic_Specification?
	| '(' Ebnf_Item ')' Semantic_Specification?
	;

Guard :
	"[=>" Ebnf_Item ']'
	| "[=>" '[' can_clash ']' Ebnf_Item ']'
	;

Nonterminal :
	nonterminal
	| identifier '.' nonterminal
	;

Terminal :
	Basic_Terminal
	| identifier '.' Basic_Terminal
	;

Basic_Terminal :
	identifier
	| string
	| character
	;

//
// Semantics
//

Semantic_Specification :
	'[' Semantic_Item (',' Semantic_Item*) ']'
	;

Semantic_Item :
	identifier
	| conflict '=' shift
	| conflict '=' reduce
	| conflict '=' weak reduce
	;

//
// Defining precedence
//

Precedence_Definition :
	precedence '{' Precedence_Item* '}'
	;

Precedence_Item :
	left Equal_Precedence_Items
	| right Equal_Precedence_Items
	| non_associative  Equal_Precedence_Items
	| non_assoc Equal_Precedence_Items
	;

Equal_Precedence_Items :
	Simple_Ebnf_Item
	| '{' Simple_Ebnf_Item* '}'
	;

//
// The parser declaration block
//

Parser_Block :
	parser identifier ':' identifier '{' Parser_StartSymbol+ '}'
	;

Parser_StartSymbol :
	Nonterminal
	;

//
// Test definition block
//

Test_Block :
	test identifier '{' Test_Definition* '}'
	;

Test_Definition :
	Nonterminal '=' Test_Specification+
	| Nonterminal "!=" Test_Specification+
	| Nonterminal from Test_Specification+
	;

Test_Specification :
	string
	| /*[=> identifier '(']*/ identifier '(' string ')'
	;

%%

/* Commonly used character sets */
/*letter	({unicode-letter}|{unicode-punctuation-dash}|{unicode-punctuation-connector})*/
letter	[a-zA-Z-]
/*digit		{unicode-number}*/
digit		[0-9]
alphanumeric	({letter}|{digit})
/*whitespace	{unicode-separator}|[\t]*/
whitespace	[ \t\n\r]
anycharacter	[^\n\r]

/* Characters valid in regular expressions and strings */
first_re_char	[^\/\*]|(\\\/)
regex_char	[^\/]|(\\\/)
string_char	[^\"]|(\\\")

/* Identifiers, regular expressions */
identifier	{letter}{alphanumeric}*
regex	\/{first_re_char}{regex_char}*\/

%%

\/\/{anycharacter}*    skip()
{whitespace}    skip()


/* Weak keywords */
language	language
import	import
"lexer-symbols" lexer_symbols
lexer	lexer
ignore	ignore
weak	weak
keywords	keywords
grammar	grammar
replace	replace
parser	parser
test	test
from	from
case	case
sensitive	sensitive
insensitive	insensitive
precedence	precedence

left	left
right	right
"non-associative"	non_associative
"non-assoc"	non_assoc

conflict	conflict
shift	shift
reduce	reduce

"can-clash"	can_clash

"{"	'{'
"}"	'}'
":"	':'
"="	'='
"."	'.'
"|="	"|="
"|"	'|'
"*"	'*'
"+"	'+'
"?"	'?'
"("	'('
")"	')'
"[=>"	"[=>"
"]"	']'
"["	'['
","	','
"!="	"!="

/* Order matter if identifier comes before keywords they are classified as identifier */
{identifier}	identifier
\<{identifier}\>	nonterminal
{regex}	regex
\"{string_char}*\"	string
'(.|\\.)'	character

%%
