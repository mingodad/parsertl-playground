//Directives

%token Charset ExitState Literal Macro MacroName Name NL
%token Number Repeat StartState String Skip Reject SymbolTable IndentTrack
%token ProdAlias

%% //Grammar rules

start : file ;
file : directives "%%" grules "%%" rx_directives rx_macros "%%" rx_rules "%%" ;
directives : %empty | directives directive ;
directive : NL ;

// Read and store %fallback entries
directive : "%fallback" tokens NL ;
// Read and store %left entries
directive : "%left" tokens NL ;
// Read and store %nonassoc entries
directive : "%nonassoc" tokens NL ;
// Read and store %precedence entries
directive : "%precedence" tokens NL ;
// Read and store %right entries
directive : "%right" tokens NL ;
// Read and store %start
directive : "%start" Name NL ;
// Read and store %token entries
directive : "%token" tokens NL ;
tokens : token | tokens token ;
token : Literal | Name ;
names : Name | names Name ;
// Read and store %token_indent entry
directive : "%token_indent" Name NL ;
// Read and store %token_dedent entry
directive : "%token_dedent" Name NL ;
// Read and store %token_symbol_table entry
directive : "%token_symbol_table" Name NL ;

// Grammar rules
grules : %empty | grules grule ;
grule : Name ':' production ';' ;
production : opt_prec_list | production '|' opt_prec_list ;
opt_prec_list : opt_list opt_prec opt_prod_alias;
opt_list : %empty | "%empty" | rhs_list ;
rhs_list : rhs | rhs_list rhs ;
rhs : Literal | Name | '[' production ']' | rhs '?' | '{' production '}' | rhs '*' | rhs '+' | '(' production ')' ;
opt_prec : %empty | "%prec" Literal | "%prec" Name ;
opt_prod_alias : %empty | ProdAlias ;

// Token regex macros
rx_macros : %empty ;
rx_macros : rx_macros MacroName regex ;

rx_directives :  %empty | rx_directives rx_directive ;

// Read and store %x entries
rx_directive : "%x" names NL ;
// Read and store %option caseless
rx_directive : "%option" "caseless" NL ;

// Tokens
rx_rules : %empty ;
rx_rules : rx_rules regex ExitState ;
rx_rules : rx_rules regex Number ;
rx_rules : rx_rules StartState regex Number ;
rx_rules : rx_rules regex ExitState Number ;
rx_rules : rx_rules StartState regex ExitState Number ;
rx_rules : rx_rules regex Literal ;
rx_rules : rx_rules StartState regex Literal ;
rx_rules : rx_rules regex ExitState Literal ;
rx_rules : rx_rules StartState regex ExitState Literal ;
rx_rules : rx_rules regex Name ;
rx_rules : rx_rules StartState regex Name ;
rx_rules : rx_rules regex ExitState Name ;
rx_rules : rx_rules StartState regex ExitState Name ;
rx_rules : rx_rules regex Skip ;
rx_rules : rx_rules StartState regex Skip ;
rx_rules : rx_rules regex ExitState Skip ;
rx_rules : rx_rules StartState regex ExitState Skip ;
rx_rules : rx_rules regex SymbolTable ;
rx_rules : rx_rules StartState regex SymbolTable ;
rx_rules : rx_rules regex ExitState SymbolTable ;
rx_rules : rx_rules StartState regex ExitState SymbolTable ;
rx_rules : rx_rules regex IndentTrack ;
rx_rules : rx_rules StartState regex IndentTrack ;
rx_rules : rx_rules regex ExitState IndentTrack ;
rx_rules : rx_rules StartState regex ExitState IndentTrack ;
rx_rules : rx_rules regex ExitState Reject ;
rx_rules : rx_rules StartState regex ExitState Reject ;
rx_rules : rx_rules StartState regex ExitState ;
rx_rules : rx_rules rx_group_start rx_group_end ;
rx_group_start : StartState '{' ;
rx_group_end : rx_rules '}' ;

// Regex
regex : rx | '^' rx | rx '$' | '^' rx '$' ;
rx : sequence | rx '|' sequence ;
sequence : item | sequence item ;
item : atom | atom repeat ;
atom : Charset | Macro | String | '(' rx ')' ;
repeat : '?' | "??" | '*' | "*?" | '+' | "+?" | Repeat ;

%%

%x OPTION GRULE MACRO REGEX RULE ID RXDIRECTIVES PRODALIAS

c_comment  [/]{2}.*|[/][*](?s:.)*?[*][/]
hex [0-9A-Fa-f]
escape \\(.|x{hex}+|c[@a-zA-Z])
posix_name alnum|alpha|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit
posix \[:{posix_name}:\]
state_name [A-Z_a-z][0-9A-Z_a-z]*
NL  \n|\r\n
literal_common	\\([^0-9cx]|[0-9]{1,3}|c[@a-zA-Z]|x{hex}+)

%%

<INITIAL,OPTION,RXDIRECTIVES>[ \t]+	skip()
{NL}	NL
"%fallback"	"%fallback"
"%left"	"%left"
"%nonassoc"	"%nonassoc"
"%precedence"	"%precedence"
"%right"	"%right"
"%start"	"%start"
"%token"	"%token"
"%token_symbol_table"	"%token_symbol_table"
"%token_indent"	"%token_indent"
"%token_dedent"	"%token_dedent"
<INITIAL>"%%"<GRULE>	"%%"

<PRODALIAS> {
    "#"   skip()
    {state_name}<GRULE> ProdAlias
}
<GRULE>"#"{state_name}<PRODALIAS> reject()

<GRULE>":"	':'
<GRULE>"%prec"	"%prec"
<GRULE>"["	'['
<GRULE>"]"	']'
<GRULE>"("	'('
<GRULE>")"	')'
<GRULE>"{"	'{'
<GRULE>"}"	'}'
<GRULE>"?"	'?'
<GRULE>"*"	'*'
<GRULE>"+"	'+'
<GRULE>"|"	'|'
<GRULE>";"	';'
<GRULE>[ \t]+|{NL}	skip()
<GRULE>"%empty"	"%empty"
<GRULE>"%%"<MACRO>	"%%"
<INITIAL,GRULE>{c_comment}	skip()
/* Bison supports single line comments */
<INITIAL,GRULE>"//".*	skip()
<INITIAL,GRULE,ID>'({literal_common}|[^'\\])'|["]({literal_common}|[^"\\])+["]	Literal
<INITIAL,GRULE,ID,RXDIRECTIVES>[.A-Z_a-z][-.0-9A-Z_a-z]*	Name
<ID>[1-9][0-9]*	Number

<MACRO,RULE>"%%"<RULE>	"%%"
<MACRO>"%option"<OPTION>	"%option"
<OPTION>"caseless"	"caseless"
<OPTION,RXDIRECTIVES>{NL}<MACRO> NL
<MACRO,RULE>"%x"<RXDIRECTIVES>	"%x"
<MACRO>[A-Z_a-z][0-9A-Z_a-z]*<REGEX>	MacroName
<MACRO,REGEX>{NL}<MACRO>	skip()
<MACRO,RULE,REGEX,RXDIRECTIVES>{c_comment}	skip()

<RULE>^[ \t]+({c_comment}([ \t]+|{c_comment})*)?	skip()
<RULE>^<([*]|{state_name}(,{state_name})*)>	StartState
<RULE>[ \t]*[{]{NL}	'{'
<RULE>[}]{NL}	'}'
<REGEX>[ \t]+	skip()
<REGEX,RULE>"^"	'^'
<REGEX,RULE>"$"	'$'
<REGEX,RULE>"|"	'|'
<REGEX,RULE>[(]([?](-?(i|s|x))*:)?	'('
<REGEX,RULE>")"	')'
<REGEX,RULE>"?"	'?'
<REGEX,RULE>"??"	"??"
<REGEX,RULE>"*"	'*'
<REGEX,RULE>"*?"	"*?"
<REGEX,RULE>"+"	'+'
<REGEX,RULE>"+?"	"+?"
<REGEX,RULE>{escape}|(\[\^?({escape}|{posix}|[^\\\]])*\])|[^\s]	Charset
<REGEX,RULE>[{][A-Z_a-z][-0-9A-Z_a-z]*[}]	Macro
<REGEX,RULE>[{][0-9]+(,([0-9]+)?)?[}][?]?	Repeat
<REGEX,RULE>["](\\.|[^\r\n"\\])*["]	String

<RULE,ID>[ \t]+({c_comment}([ \t]+|{c_comment})*)?<ID> skip()
<RULE><([.]|<|>?{state_name})><ID>	ExitState
<RULE><>{state_name}:{state_name}><ID>	ExitState
<RULE,ID>{NL}<RULE>	skip()
<ID>skip\s*[(]\s*[)]<RULE>	Skip
<ID>reject\s*[(]\s*[)]<RULE>	Reject
<ID>symbol_table\s*[(]\s*[)]<RULE>	SymbolTable
<ID>indent_track\s*[(]\s*[)]<RULE>	IndentTrack

%%
