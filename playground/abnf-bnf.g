//From: https://github.com/GuntherRademacher/ebnf-convert/blob/7b5b882ee60d7cbf7ee9202a16be2227fb4fec49/src/main/java/de/bottlecaps/convert/abnf/abnf.ebnf
// created from http://www.ietf.org/rfc/rfc2234.txt
//
// however:
// - more liberal whitespace
// - extra '::=' allowed in production defined-as
// - extra '|' allowed in production alternation
// - underscore allowed in rule names
// - CR optional in CRLF

%token defined_as
%token integer
%token num_val
%token prose_val
%token quoted_string
%token rulename
%token rulename_lhs

%%

input :
	  rulelist
	;

rulelist :
	  rule
	| rulelist rule
	;

rule:
	  rulename_lhs defined_as elements
	;

elements:
	  alternation
	;

alternation:
	concatenation
	| alternation '/' concatenation
	| alternation '|' concatenation
	;

concatenation:
	repetition
	| concatenation repetition
	;

repetition:
	  repetition_opt element
	;

repetition_opt:
	  %empty
	| repeat
	;

repeat:
	integer
	| '*'
	| integer '*'
	| integer '*' integer
	;

element:
	  rulename
	| group
	| option
	| char_val
	| num_val
	| prose_val
	;

group:
	  '(' alternation ')'
	;

option:
	  '[' alternation ']'
	;

char_val:
	  case_insensitive_string
	| case_sensitive_string
	;

case_insensitive_string:
	  case_insensitive_string_mark quoted_string
	;

case_insensitive_string_mark:
	  %empty
	| "%i"
	;

case_sensitive_string:
	  "%s" quoted_string
	;

%%

%x RULE_LHS

HTAB \x09	// horizontal tab
LF \x0A	// linefeed
SP \x20	// space
WSP {SP}|{HTAB}	// white space
CR \x0D	// carriage return
CRLF {CR}?{LF}	// Internet standard newline
VCHAR [\x21-\x7E]	// visible (printing) characters

comment ";"({WSP}|{VCHAR})*{CRLF}
c_nl {comment}|{CRLF}	// comment or newline

c_wsp ({WSP}|({c_nl}{WSP}))+
whitespace {c_wsp}|{c_nl}|{CR}|{LF}	/* ws: definition */

ALPHA [\x41-\x5A\x61-\x7A] // A-Z / a-z
DIGIT [\x30-\x39]	// 0-9

DQUOTE \x22	// " (Double Quote)
BIT [01]
HEXDIG {DIGIT}|[A-Fa-f]

bits	{BIT}+
hexdigs	{HEXDIG}+
integer	{DIGIT}+

// series of concatenated bit values
// or single ONEOF range
bin_val "b"{bits}(("."{bits})+|("-"{bits}))?
dec_val	"d"{integer}(("."{integer})+|("-"{integer}))?
hex_val	"x"{hexdigs}(("."{hexdigs})+|("-"{hexdigs}))?

rulename	{ALPHA}({ALPHA}|{DIGIT}|[-_])*

defined_as	"="|"=/"|"::="

%%

//<?TOKENS?>

{whitespace}	skip()

"|"	'|'
"/"	'/'
"("	'('
")"	')'
"["	'['
"]"	']'
"*"	'*'
"%i"	"%i"
"%s"	"%s"

{defined_as}	defined_as
{integer}	integer
// quoted string of SP and VCHAR
// without DQUOTE
{DQUOTE}([\x20-\x21]|[\x23-\x7E])*{DQUOTE}	quoted_string

// bracketed string of SP and VCHAR
// without angles
// prose description, to be used as
// last resort
"<"([\x20-\x3D]|[\x3F-\x7E])*">"	prose_val

"%"({bin_val}|{dec_val}|{hex_val})	num_val

{rulename}\s+{defined_as}<RULE_LHS>	reject()
<RULE_LHS>{
	{rulename}	rulename_lhs
	.<INITIAL>	reject()
}

{rulename}	rulename

//EOF $

%%
