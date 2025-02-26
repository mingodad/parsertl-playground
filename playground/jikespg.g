//From: https://github.com/modulovalue/jikespg/blob/f23b7ba4ccce8ccaecb4ba96fa981b386c5b7b76/examples/jikespg/jikespg.g

%token ALIAS_KEY
%token ARROW
%token BLOCK
%token DEFINE_KEY
%token EMPTY_SYMBOL
%token END_KEY
%token EOF_SYMBOL
%token EOL_SYMBOL
%token EQUIVALENCE
%token ERROR_SYMBOL
%token HBLOCK
%token MACRO_NAME
%token NAMES_KEY
%token OR
%token RULES_KEY
%token START_KEY
%token SYMBOL
%token TERMINALS_KEY
%token OPTIONS

%%

LPG_INPUT :
	options_opt
	  define_block_opt
	  terminals_block_opt
	  alias_block_opt
	  start_block_opt
	  rules_block_opt
	  names_block_opt
	  END_opt
	| bad_symbol
	;

options_opt :
    %empty
    | options_opt OPTIONS
    ;

bad_symbol :
	EQUIVALENCE
	| ARROW
	| OR
	| EMPTY_SYMBOL
	| ERROR_SYMBOL
	| MACRO_NAME
	| SYMBOL
	| BLOCK
	;

define_block :
	DEFINE_KEY
	| DEFINE_KEY macro_list
	;

macro_list :
	macro_name_symbol macro_block
	| macro_list macro_name_symbol macro_block
	;

macro_name_symbol :
	MACRO_NAME
	| SYMBOL          // Warning, Escape missing !
	| OR             // No Good !!!
	| EMPTY_SYMBOL    // No good !!!
	| ERROR_SYMBOL    // No good !!!
	| produces        // No good !!!
	| BLOCK           // No good !!!
	| DEFINE_KEY         // No good !!!
	;

macro_block :
	BLOCK
	| OR            // No Good !!!
	| EMPTY_SYMBOL   // No good !!!
	| ERROR_SYMBOL   // No good !!!
	| produces       // No good !!!
	| SYMBOL         // No good !!!
	| keyword        // No good !!!
	| END_KEY        // No good !
	;

terminals_block :
	TERMINALS_KEY terminal_symbol_zom
	;

terminal_symbol :
	SYMBOL
	| OR
	| produces
	| DEFINE_KEY         // No Good !!!
	| TERMINALS_KEY      // No Good !!!
	| BLOCK           // No good !!!
	;

alias_block :
	ALIAS_KEY alias_definition_zom
	;

alias_definition :
	alias_lhs produces alias_rhs
	| bad_alias_lhs
	| alias_lhs bad_alias_rhs
	| alias_lhs produces bad_alias_rhs
	;

alias_lhs :
	SYMBOL
	| ERROR_SYMBOL
	| EOL_SYMBOL
	| EOF_SYMBOL
	;

alias_rhs :
	SYMBOL
	| ERROR_SYMBOL
	| EOL_SYMBOL
	| EOF_SYMBOL
	| EMPTY_SYMBOL
	| OR
	| produces
	;

bad_alias_rhs :
	DEFINE_KEY
	| TERMINALS_KEY
	| ALIAS_KEY
	| BLOCK
	;

bad_alias_lhs :
	bad_alias_rhs
	| EMPTY_SYMBOL
	| produces
	| OR
	;

start_block :
	START_KEY start_symbol_zom
	;

start_symbol :
	SYMBOL
	| OR            // No Good !!!
	| EMPTY_SYMBOL   // No good !!!
	| ERROR_SYMBOL   // No good !!!
	| produces       // No good !!!
	| BLOCK          // No good !!!
	| DEFINE_KEY        // No good !!!
	| TERMINALS_KEY     // No good !!!
	| ALIAS_KEY         // No good !!!
	| START_KEY         // No good !!!
	;

rules_block :
	RULES_KEY
	| RULES_KEY rule_list
	;

produces :
	EQUIVALENCE
	| ARROW
	;

rule_list :
	action_block_zom SYMBOL produces
	| rule_list OR
	| rule_list SYMBOL produces
	| rule_list EMPTY_SYMBOL
	| rule_list action_block
	| rule_list ERROR_SYMBOL
	| rule_list SYMBOL
	| OR                    // can't be first SYMBOL
	| EMPTY_SYMBOL           // can't be first SYMBOL
	| ERROR_SYMBOL           // can't be first SYMBOL
	| keyword                // keyword out of place
	| rule_list OR produces            // No good !!!
	| rule_list action_block produces          // No good !!!
	| rule_list EMPTY_SYMBOL produces   // No good !!!
	| rule_list keyword produces        // No good !!!
	;

action_block :
	BLOCK
	| HBLOCK
	;

keyword :
	DEFINE_KEY
	| TERMINALS_KEY
	| ALIAS_KEY
	| START_KEY
	| RULES_KEY
	;

names_block :
	NAMES_KEY names_definition_zom
	;

names_definition :
	name produces name
	| bad_name produces name
	| name produces bad_name
	;

name :
	SYMBOL
	| EMPTY_SYMBOL
	| ERROR_SYMBOL
	| EOL_SYMBOL
	| EOF_SYMBOL
	| OR
	| produces
	;

bad_name :
	DEFINE_KEY
	| TERMINALS_KEY
	| ALIAS_KEY
	| START_KEY
	| RULES_KEY
	| NAMES_KEY
	| BLOCK
	| MACRO_NAME
	;

define_block_opt :
	%empty
	| define_block
	;

terminals_block_opt :
	%empty
	| terminals_block
	;

alias_block_opt :
	%empty
	| alias_block
	;

start_block_opt :
	%empty
	| start_block
	;

rules_block_opt :
	%empty
	| rules_block
	;

names_block_opt :
	%empty
	| names_block
	;

END_opt :
	%empty
	| END_KEY
	;

terminal_symbol_zom :
	%empty
	| terminal_symbol_zom terminal_symbol
	;

start_symbol_zom :
	%empty
	| start_symbol_zom start_symbol
	;

alias_definition_zom :
	%empty
	| alias_definition_zom alias_definition
	;

names_definition_zom :
	%empty
	| names_definition_zom names_definition
	;

action_block_zom :
	%empty
	| action_block_zom action_block
	;

%%

%option caseless

ident	[A-Za-z_][A-Za-z0-9_]*
macroname	"$"{ident}
string  \"(\\.|[^"\r\n"])+\"|'(\\.|[^'\r\n\\'])+'

symbol_lhs {ident}|"{"{ident}"}"|"[""%"?{ident}"]"
symbol {symbol_lhs}|{string}

EQUIVALENCE "::="
PRIORITY_EQUIVALENCE    "::=?"
ARROW   "->"
PRIORITY_ARROW  "->?"

produces    {EQUIVALENCE}|{PRIORITY_EQUIVALENCE}|{ARROW}|{PRIORITY_ARROW}

%%

[ \t\r\n]+	skip()
"--".*	skip()

"%OPTIONS".*    OPTIONS
"$ALIAS"	ALIAS_KEY
{ARROW}	ARROW
"$DEFINE"	DEFINE_KEY
"$EMPTY"	EMPTY_SYMBOL
"$END"	END_KEY
"$EOF"	EOF_SYMBOL
"%EOL"	EOL_SYMBOL
{EQUIVALENCE}	EQUIVALENCE
"%ERROR"	ERROR_SYMBOL
"$NAMES"	NAMES_KEY
"|"	OR
"$RULES"	RULES_KEY
"$START"	START_KEY
"$TERMINALS"	TERMINALS_KEY

"/."(?s:.)*?"./"	BLOCK
"/:"(?s:.)*?":/"	HBLOCK

{macroname}	MACRO_NAME
{symbol}	SYMBOL

%%
