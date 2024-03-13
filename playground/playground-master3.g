//Directives

%token Charset ExitState Literal Macro MacroName Name NL
%token Number Repeat StartState String Skip Reject

%% //Grammar rules

start : file ;
file : directives "%%" grules "%%" rx_macros "%%" rx_rules "%%" ;
directives : %empty | directives directive ;
directive : NL ;

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
opt_prec_list : opt_list opt_prec ;
opt_list : %empty | "%empty" | rhs_list ;
rhs_list : rhs | rhs_list rhs ;
rhs : Literal | Name | '[' production ']' | rhs '?' | rhs '*' | rhs '+' | '(' production ')' ;
opt_prec : %empty | "%prec" Literal | "%prec" Name ;

// Token regex macros
rx_macros : %empty ;
rx_macros : rx_macros MacroName regex ;

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
rx_rules : rx_rules regex ExitState Reject ;
rx_rules : rx_rules StartState regex ExitState Skip ;
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

%x OPTION GRULE MACRO REGEX RULE ID

c_comment  [/]{2}.*|[/][*](?s:.)*?[*][/]
hex [0-9A-Fa-f]
escape \\(.|x{hex}+|c[@a-zA-Z])
posix_name alnum|alpha|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit
posix \[:{posix_name}:\]
state_name [A-Z_a-z][0-9A-Z_a-z]*
NL  \n|\r\n
literal_common	\\([^0-9cx]|[0-9]{1,3}|c[@a-zA-Z]|x{hex}{2})

%%

<INITIAL,OPTION>[ \t]+	skip()
{NL}	NL
"%left"	"%left"
"%nonassoc"	"%nonassoc"
"%precedence"	"%precedence"
"%right"	"%right"
"%start"	"%start"
"%token"	"%token"
"%x"	"%x"
<INITIAL>"%option"<OPTION>	"%option"
<OPTION>"caseless"<INITIAL>	"caseless"
<INITIAL>"%%"<GRULE>	"%%"

<GRULE> {
    ":"	':'
    "%prec"	"%prec"
    "["	'['
    "]"	']'
    "("	'('
    ")"	')'
    "?"	'?'
    "*"	'*'
    "+"	'+'
    "|"	'|'
    ";"	';'
    [ \t]+|{NL}	skip()
    "%empty"	"%empty"
    "%%"<MACRO>	"%%"
}

<INITIAL,GRULE> {
    {c_comment}	skip()
    /* Bison supports single line comments */
    "//".*	skip()
}
<INITIAL,GRULE,ID> {
    '({literal_common}|[^'\\])+'	Literal
    ["]({literal_common}|[^"\\])+["]	Literal
    [.A-Z_a-z][-.0-9A-Z_a-z]*	Name
}
<ID>[1-9][0-9]*	Number

<MACRO>[A-Z_a-z][0-9A-Z_a-z]*<REGEX>	MacroName
<MACRO,REGEX>{NL}<MACRO>	skip()
<MACRO,RULE> {
    "%%"<RULE>	"%%"
    {c_comment}	skip()
    ^[ \t]+{c_comment}	skip()
}

<RULE> {
    ^[ \t]+({c_comment}([ \t]+|{c_comment})*)?	skip()
    ^<([*]|{state_name}(,{state_name})*)>	StartState
    [ \t]*[{]{NL}	'{'
    [}]{NL}	'}'
    <([.]|<|>?{state_name})><ID>	ExitState
    <>{state_name}:{state_name}><ID>	ExitState
}
<REGEX>[ \t]+	skip()
<REGEX,RULE> {
    "^"	'^'
    "$"	'$'
    "|"	'|'
    [(]([?](-?(i|s|x))*:)?	'('
    ")"	')'
    "?"	'?'
    "??"	"??"
    "*"	'*'
    "*?"	"*?"
    "+"	'+'
    "+?"	"+?"
    {escape}|(\[\^?({escape}|{posix}|[^\\\]])*\])|[^\s]	Charset
    [{][A-Z_a-z][-0-9A-Z_a-z]*[}]	Macro
    [{][0-9]+(,([0-9]+)?)?[}][?]?	Repeat
    ["](\\.|[^\r\n"\\])*["]	String
}

<RULE,ID> {
    [ \t]+({c_comment}([ \t]+|{c_comment})*)?<ID>	skip()
    {NL}<RULE>	skip()
}
<ID> {
	skip\s*[(]\s*[)]<RULE>	Skip
	reject\s*[(]\s*[)]<RULE>	Reject
}

%%
