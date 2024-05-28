%token language import lexer_symbols lexer
%token ignore weak keywords grammar replace parser
%token test from case sensitive insensitive precedence
%token left right non_associative non_assoc conflict
%token shift reduce can_clash identifier nonterminal
%token regex string character rule_header

%fallback identifier language import lexer_symbols lexer
%fallback identifier ignore weak keywords grammar replace
%fallback identifier parser test from case sensitive
%fallback identifier insensitive precedence left
%fallback identifier right non_associative non_assoc
%fallback identifier conflict shift reduce can_clash

%%
//
// The top-level definitions
//

Parser_Language :
	TopLevel_Block_zom
	;

TopLevel_Block_zom :
	%empty
	| TopLevel_Block_zom TopLevel_Block
	;

TopLevel_Block :
	Language_Block
	| Import_Block
	| Parser_Block
	| Test_Block
	;

Language_Block :
	language identifier Language_Inherits_opt '{' Language_Definition_zom '}'
	;

Import_Block :
	import string
	;

Language_Inherits_opt :
	%empty
	| ':' identifier
	;

//
// The language block
//

Language_Definition_zom :
	%empty
	| Language_Definition_zom Language_Definition
	;

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
	Lexer_Symbols_Modifier lexer_symbols '{' Lexeme_Definition_zom '}'
	;

Lexer_Definition :
	//[=> <Lexer-Modifier>* lexer]
	Lexer_Modifier lexer '{' Lexeme_Definition_zom '}'
	;

Ignore_Definition :
	ignore '{' Keyword_Definition_zom '}'
	;

Keywords_Definition :
	//[=> <Lexer-Modifier>* keywords]
	Lexer_Modifier keywords '{' Keyword_Definition_zom '}'
	;

Lexer_Modifier :
	Lexer_Symbols_Modifier
	| weak Lexer_Symbols_Modifier
	;

Lexer_Symbols_Modifier :
	%empty
	| case sensitive
	| case insensitive
	;

Keyword_Definition_zom :
	%empty
	| Keyword_Definition_zom Keyword_Definition
	;

Keyword_Definition :
	identifier
	| Lexeme_Definition
	;

Lexeme_Definition_zom :
	%empty
	| Lexeme_Definition_zom Lexeme_Definition
	;

Lexeme_Definition :
	identifier LR_assign Lexeme_literal
	| /*[=> replace identifier '=']*/ replace identifier '=' Lexeme_literal
	| identifier '=' identifier '.' identifier
	;

LR_assign :
	'=' | "|="
	;

Lexeme_literal :
	regex | string | character
	;

//
// Defining grammars
//

Grammar_Definition :
	grammar '{' Nonterminal_Definition_zom '}'
	;

Nonterminal_Definition_zom :
	%empty
	| Nonterminal_Definition_zom Nonterminal_Definition
	;

Nonterminal_Definition :
	//[=> nonterminal LR_assign]
	rule_header Production_alt_list
	| /*[=> replace nonterminal '=']*/ replace nonterminal '=' Production_alt_list
	;

Production_alt_list :
	Production
	| Production_alt_list '|' Production
	;

// Top level is just a simple EBNF term, as the '|' operator creates a new production at this point
Production :
	Simple_Ebnf_Item
	| Production Simple_Ebnf_Item
	;

Ebnf_Item :
	Simple_Ebnf_Item
	| Ebnf_Item Simple_Ebnf_Item
	| Simple_Ebnf_Item '|' Ebnf_Item
	;

Simple_Ebnf_Item_zom :
	%empty
	| Simple_Ebnf_Item_zom Simple_Ebnf_Item
	;

Simple_Ebnf_Item :
	Nonterminal Semantic_Specification_opt
	| Terminal Semantic_Specification_opt
	| Guard Semantic_Specification_opt
	| Simple_Ebnf_Item '*' Semantic_Specification_opt
	| Simple_Ebnf_Item '+' Semantic_Specification_opt
	| Simple_Ebnf_Item '?' Semantic_Specification_opt
	| '(' Ebnf_Item ')' Semantic_Specification_opt
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

Semantic_Specification_opt :
	%empty
	| Semantic_Specification
	;
Semantic_Specification :
	'[' Semantic_Item_list ']'
	;

Semantic_Item_list :
	Semantic_Item
	| Semantic_Item_list ',' Semantic_Item
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
	precedence '{' Precedence_Item_zom '}'
	;

Precedence_Item_zom :
	%empty
	| Precedence_Item_zom Precedence_Item
	;

Precedence_Item :
	left Equal_Precedence_Items
	| right Equal_Precedence_Items
	| non_associative  Equal_Precedence_Items
	| non_assoc Equal_Precedence_Items
	;

Equal_Precedence_Items :
	Simple_Ebnf_Item
	| '{' Simple_Ebnf_Item_zom '}'
	;

//
// The parser declaration block
//

Parser_Block :
	parser identifier ':' identifier '{' Parser_StartSymbol '}'
	;

Parser_StartSymbol :
	Nonterminal
	| Parser_StartSymbol Nonterminal
	;

//
// Test definition block
//

Test_Block :
	test identifier '{' Test_Definition_zom '}'
	;

Test_Definition_zom :
	%empty
	| Test_Definition_zom Test_Definition
	;

Test_Definition :
	Nonterminal '=' Test_Specification_list
	| Nonterminal "!=" Test_Specification_list
	| Nonterminal from Test_Specification_list
	;

Test_Specification_list :
	Test_Specification
	| Test_Specification_list Test_Specification
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
nonterminal \<{identifier}\>

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
{nonterminal}	nonterminal
{nonterminal}\s*("="|"|=") rule_header
{regex}	regex
\"{string_char}*\"	string
'(.|\\.)'	character

%%
