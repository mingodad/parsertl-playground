//Directives

%token Charset ExitState Literal Macro MacroName Name NL
%token Number Repeat StartState String Skip Reject

%x OPTION GRULE MACRO REGEX RULE ID

%% //Grammar rules

start : file ;
file : directives '%%' grules '%%' rx_macros '%%' rx_rules '%%' ;
directives : %empty | directives directive ;
directive : NL ;
// Read and store %left entries
directive : '%left' tokens NL ;
// Read and store %nonassoc entries
directive : '%nonassoc' tokens NL ;
// Read and store %precedence entries
directive : '%precedence' tokens NL ;
// Read and store %right entries
directive : '%right' tokens NL ;
// Read and store %start
directive : '%start' Name NL ;
// Read and store %token entries
directive : '%token' tokens NL ;
tokens : token | tokens token ;
token : Literal | Name ;
// Read and store %option caseless
directive : '%option' 'caseless' NL ;
// Read and store %x entries
directive : '%x' names NL ;
names : Name | names Name ;
// Grammar rules
grules : %empty | grules grule ;
grule : Name ':' production ';' ;
production : opt_prec_list | production '|' opt_prec_list ;
opt_prec_list: opt_list opt_prec ;
opt_list : %empty | '%empty' | rhs_list ;
rhs_list : rhs | rhs_list rhs ;
rhs : Literal | Name | '[' production ']' | rhs '?' | rhs '*' | rhs '+' | '(' production ')' ;
opt_prec : %empty | '%prec' Literal | '%prec' Name ;
// Token regex macros
rx_macros : %empty ;
rx_macros : rx_macros MacroName regex ;
// Tokens
rx_rules : %empty ;
rx_rules : rx_rules regex rx_return ;
rx_rules : rx_rules StartState regex rx_return ;
rx_rules : rx_rules regex ExitState  rx_return ;
rx_rules : rx_rules StartState regex ExitState rx_return ;
rx_rules : rx_rules StartState regex ExitState ;
rx_rules : rx_rules StartState regex ExitState Reject ;
rx_rules : rx_rules StartState '{' rx_rules '}' ;
rx_rules : rx_rules regex ExitState ;
rx_rules : rx_rules regex ExitState Reject;
rx_return : Number | Literal | Name | Skip ;
// Regex
regex : rx | '^' rx | rx '$' | '^' rx '$' ;
rx : sequence | rx '|' sequence ;
sequence : item | sequence item ;
item : atom | atom repeat ;
atom : Charset | Macro | String | '(' rx ')' ;
repeat : '?' | '\?\?' | '*' | '*?' | '+' | '+?' | Repeat ;

%%

c_comment [/][*](?s:.)*?[*][/]
escape \\(.|x[0-9A-Fa-f]+|c[@a-zA-Z])
posix_name alnum|alpha|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit
posix \[:{posix_name}:\]
state_name [A-Z_a-z][0-9A-Z_a-z]*

%%

<INITIAL,OPTION>[ \t]<.> skip()
\n|\r\n	NL
%left	'%left'
%nonassoc	'%nonassoc'
%precedence	'%precedence'
%right	'%right'
%start	'%start'
%token	'%token'
%x	'%x'
<INITIAL>%option<OPTION>	'%option'
<OPTION>caseless<INITIAL>	'caseless'
<INITIAL>\%\%<GRULE>	'%%'

<GRULE>:<.>	':'
<GRULE>%prec<.>	'%prec'
<GRULE>\[<.>	'['
<GRULE>\]<.>	']'
<GRULE>[(]<.>	'('
<GRULE>[)]<.>	')'
<GRULE>[?]<.>	'?'
<GRULE>[*]<.>	'*'
<GRULE>[+]<.>	'+'
<GRULE>[|]<.>	'|'
<GRULE>;<.>	';'
<GRULE>[ \t]+|\n|\r\n<.>	skip()
<GRULE>%empty<.>	'%empty'
<GRULE>\%\%<MACRO>	'%%'
<INITIAL,GRULE>{c_comment}<.>	skip()
<INITIAL,GRULE>[/][/].*<.>	skip()
<INITIAL,GRULE,ID>'(\\([^0-9cx]|[0-9]{1,3}|c[@a-zA-Z]|x\d+)|[^'\\])+'|[\"](\\([^0-9cx]|[0-9]{1,3}|c[@a-zA-Z]|x\d+)|[^\"\\])+[\"]<.>	Literal
<INITIAL,GRULE,ID>[.A-Z_a-z][-.0-9A-Z_a-z]*<.>	Name
<ID>[1-9][0-9]*<.>	Number

<MACRO,RULE>\%\%<RULE>	'%%'
<MACRO>[A-Z_a-z][0-9A-Z_a-z]*<REGEX>	MacroName
<MACRO,REGEX>\n|\r\n<MACRO>	skip()
<MACRO,RULE>{c_comment}<.>	skip()

<RULE>^[ \t]+({c_comment}([ \t]+|{c_comment})*)?<.>	skip()
<RULE>^<([*]|{state_name}(,{state_name})*)><.>	StartState
<RULE>[ \t]*[{]<.>	'{'
<RULE>[}]<.>	'}'
<REGEX>[ \t]+<.>	skip()
<REGEX,RULE>\^<.>	'^'
<REGEX,RULE>\$<.>	'$'
<REGEX,RULE>[|]<.>	'|'
<REGEX,RULE>[(]([?](-?(i|s))*:)?<.>	'('
<REGEX,RULE>[)]<.>	')'
<REGEX,RULE>[?]<.>	'?'
<REGEX,RULE>[?][?]<.>	'\?\?'
<REGEX,RULE>[*]<.>	'*'
<REGEX,RULE>[*][?]<.>	'*?'
<REGEX,RULE>[+]<.>	'+'
<REGEX,RULE>[+][?]<.>	'+?'
<REGEX,RULE>{escape}|(\[\^?({escape}|{posix}|[^\\\]])*\])|[^\s]<.>	Charset
<REGEX,RULE>[{][A-Z_a-z][-0-9A-Z_a-z]*[}]<.>	Macro
<REGEX,RULE>[{][0-9]+(,([0-9]+)?)?[}][?]?<.>	Repeat
<REGEX,RULE>[\"](\\.|[^\r\n\"\\])*[\"]<.>	String

<RULE,ID>[ \t]+({c_comment}([ \t]+|{c_comment})*)?<ID>	skip()
<RULE><([.]|<|>?{state_name})><ID>	ExitState
<RULE><>{state_name}:{state_name}><ID>	ExitState
<RULE,ID>\n|\r\n<RULE>	skip()
<ID>skip\s*[(]\s*[)]<RULE>	Skip
<ID>reject\s*[(]\s*[)]<RULE>	Reject

%%
