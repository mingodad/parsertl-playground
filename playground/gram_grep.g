//Directives

%token Charset ExitState Index Integer Literal Macro MacroName Name NL Number Repeat ScriptString StartState String

%% //Grammar rules

start : file ;
file : directives "%%" grules "%%" rx_macros "%%" rx_rules "%%" ;
directives : %empty | directives directive ;
directive : NL ;
// Read and set %captures
directive : "%captures" NL ;
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
// Read and store %option caseless
directive : "%option" "caseless" NL ;
// Read and store %x entries
directive : "%x" names NL ;
names : Name | names Name ;
// Grammar rules
grules : %empty | grules grule ;
grule : Name ':' production ';' ;
production : opt_prec_list | production '|' opt_prec_list ;
opt_prec_list: opt_list opt_prec opt_script ;
opt_list : %empty | "%empty" | rhs_list ;
rhs_list : rhs | rhs_list rhs ;
rhs : Literal | Name | '[' production ']' | rhs '?' | rhs '*' | rhs '+' | '(' production ')' ;
opt_prec : %empty | "%prec" Literal | "%prec" Name ;
opt_script : %empty ;
opt_script : '{' cmd_list '}' ;
cmd_list : %empty | cmd_list single_cmd ';' ;
single_cmd : cmd ;
single_cmd : mod_cmd ;
mod_cmd : "erase" '(' Index ')' ;
mod_cmd : "erase" '(' Index ',' Index ')' ;
mod_cmd : "erase" '(' Index '.' first_second ',' Index '.' first_second ')' ;
mod_cmd : "insert" '(' Index ',' ScriptString ')' ;
mod_cmd : "insert" '(' Index '.' "second" ',' ScriptString ')' ;
cmd : "match" '=' Index ;
cmd : "match" '=' "substr" '(' Index ',' Integer ',' Integer ')' ;
cmd : "match" "+=" Index ;
cmd : "match" "+=" "substr" '(' Index ',' Integer ',' Integer ')' ;
mod_cmd : "print" '(' ScriptString ')' ;
mod_cmd : "replace" '(' Index ',' ScriptString ')' ;
mod_cmd : "replace" '(' Index ',' Index ',' ScriptString ')' ;
mod_cmd : "replace" '(' Index '.' first_second ',' Index '.' first_second ',' ScriptString ')' ;
mod_cmd : "replace_all" '(' Index ',' ScriptString ',' ScriptString ')' ;
first_second : "first" | "second" ;
// Token regex macros
rx_macros : %empty ;
rx_macros : rx_macros MacroName regex ;
// Tokens
rx_rules : %empty ;
rx_rules : rx_rules regex Number ;
rx_rules : rx_rules StartState regex ExitState Number ;
rx_rules : rx_rules regex Literal ;
rx_rules : rx_rules StartState regex ExitState Literal ;
rx_rules : rx_rules regex Name ;
rx_rules : rx_rules StartState regex ExitState Name ;
rx_rules : rx_rules regex "skip()" ;
rx_rules : rx_rules StartState regex ExitState "skip()" ;
rx_rules : rx_rules StartState regex ExitState ;
// Regex
regex : rx | '^' rx | rx '$' | '^' rx '$' ;
rx : sequence | rx '|' sequence ;
sequence : item | sequence item ;
item : atom | atom repeat ;
atom : Charset | Macro | String | '(' rx ')' ;
repeat : '?' | "??" | '*' | "*?" | '+' | "+?" | Repeat ;

%%

%x OPTION GRULE SCRIPT MACRO REGEX RULE ID

c_comment [/][*](?s:.)*?[*][/]
escape \\(.|x[0-9A-Fa-f]+|c[@a-zA-Z])
posix_name alnum|alpha|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit
posix \[:{posix_name}:\]
state_name [A-Z_a-z][0-9A-Z_a-z]*

%%

<INITIAL,OPTION>[ \t]<.> skip()
\n|\r\n	NL
%captures	"%captures"
%left	"%left"
%nonassoc	"%nonassoc"
%precedence	"%precedence"
%right	"%right"
%start	"%start"
%token	"%token"
"%x"	"%x"
<INITIAL>%option<OPTION>	"%option"
<OPTION>caseless<INITIAL>	"caseless"
<INITIAL>\%\%<GRULE>	"%%"

<GRULE>:<.>	':'
<GRULE>%prec<.>	"%prec"
<GRULE>\[<.>	'['
<GRULE>\]<.>	']'
<GRULE>[(]<.>	'('
<GRULE>[)]<.>	')'
<GRULE>[?]<.>	'?'
<GRULE>[*]<.>	'*'
<GRULE>[+]<.>	'+'
<GRULE>[|]<.>	'|'
<GRULE>;<.>	';'
<GRULE>[{]<SCRIPT>	'{'
<SCRIPT>[}]<GRULE>	'}'
<SCRIPT>=<.>	'='
<SCRIPT>,<.>	','
<SCRIPT>[(]<.>	'('
<SCRIPT>[)]<.>	')'
<SCRIPT>[.]<.>	'.'
<SCRIPT>;<.>	';'
<SCRIPT>[+]=<.>	"+="
<SCRIPT>erase<.>	"erase"
<SCRIPT>first<.>	"first"
<SCRIPT>insert<.>	"insert"
<SCRIPT>match<.>	"match"
<SCRIPT>print<.>	"print"
<SCRIPT>replace<.>	"replace"
<SCRIPT>replace_all<.>	"replace_all"
<SCRIPT>second<.>	"second"
<SCRIPT>substr<.>	"substr"
<SCRIPT>\d+<.>	Integer
<SCRIPT>\s+<.>	skip()
<SCRIPT>[$][1-9][0-9]*<.>	Index
<SCRIPT>'(''|[^'])*'<.>	ScriptString
<GRULE>[ \t]+|\n|\r\n<.>	skip()
<GRULE>%empty<.>	"%empty"
<GRULE>\%\%<MACRO>	"%%"
<INITIAL,GRULE,SCRIPT>{c_comment}<.>	skip()
<INITIAL,GRULE,SCRIPT>[/][/].*<.>	skip()
<INITIAL,GRULE,ID>'(\\([^0-9cx]|[0-9]{1,3}|c[@a-zA-Z]|x\d+)|[^'\\])+'|[\"](\\([^0-9cx]|[0-9]{1,3}|c[@a-zA-Z]|x\d+)|[^\"\\])+[\"]<.>	Literal
<INITIAL,GRULE,ID>[.A-Z_a-z][-.0-9A-Z_a-z]*<.>	Name
<ID>[1-9][0-9]*<.>	Number

<MACRO,RULE>\%\%<RULE>	"%%"
<MACRO>[A-Z_a-z][0-9A-Z_a-z]*<REGEX>	MacroName
<MACRO,REGEX>\n|\r\n<MACRO>	skip()

<REGEX>[ \t]+<.>	skip()
<RULE>^[ \t]+({c_comment}([ \t]+|{c_comment})*)?<.>	skip()
<RULE>^<([*]|{state_name}(,{state_name})*)><.>	StartState
<REGEX,RULE>\^<.>	'^'
<REGEX,RULE>\$<.>	'$'
<REGEX,RULE>[|]<.>	'|'
<REGEX,RULE>[(]([?](-?(i|s))*:)?<.>	'('
<REGEX,RULE>[)]<.>	')'
<REGEX,RULE>[?]<.>	'?'
<REGEX,RULE>[?][?]<.>	"??"
<REGEX,RULE>[*]<.>	'*'
<REGEX,RULE>[*][?]<.>	"*?"
<REGEX,RULE>[+]<.>	'+'
<REGEX,RULE>[+][?]<.>	"+?"
<REGEX,RULE>{escape}|(\[\^?({escape}|{posix}|[^\\\]])*\])|[^\s]<.>	Charset
<REGEX,RULE>[{][A-Z_a-z][-0-9A-Z_a-z]*[}]<.>	Macro
<REGEX,RULE>[{][0-9]+(,([0-9]+)?)?[}][?]?<.>	Repeat
<REGEX,RULE>[\"](\\.|[^\r\n\"\\])*[\"]<.>	String

<RULE,ID>[ \t]+({c_comment}([ \t]+|{c_comment})*)?<ID>	skip()
<RULE><([.]|<|>?{state_name})><ID>	ExitState
<RULE,ID>\n|\r\n<RULE>	skip()
<ID>skip\s*[(]\s*[)]<RULE>	"skip()"

%%
