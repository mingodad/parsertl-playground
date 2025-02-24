//From: https://github.com/A-LPG/LPG2/blob/d4d4c36cdfb2879bb30ad1ec587d91fbacce1b96/lpg2/grammar/jikespg.g

%token ALIAS_KEY
%token ARROW
%token AST_KEY
%token BLOCK
%token DEFINE_KEY
%token DISJOINTPREDECESSORSETS_KEY
%token DROPACTIONS_KEY
%token DROPRULES_KEY
%token DROPSYMBOLS_KEY
%token EMPTY_KEY
%token END_KEY
%token EOF_KEY
%token EOL_KEY
%token EQUIVALENCE
%token ERROR_KEY
%token EXPORT_KEY
%token GLOBALS_KEY
%token HEADERS_KEY
%token IDENTIFIER_KEY
%token IMPORT_KEY
%token INCLUDE_KEY
%token MACRO_NAME
%token MACRO_NAME_LHS
%token NAMES_KEY
%token NOTICE_KEY
%token OR_MARKER
%token PRIORITY_ARROW
%token PRIORITY_EQUIVALENCE
%token RECOVER_KEY
%token RULES_KEY
%token SOFTKEYWORDS_KEY
%token START_KEY
%token SYMBOL
%token SYMBOL_LHS
%token TERMINALS_KEY
%token TRAILERS_KEY
%token TYPES_KEY
%token OPTIONS

%%

JikesPG_INPUT :
	options_opt Grammar
	;

options_opt :
    %empty
    | options_opt OPTIONS
    ;

Grammar :
	%empty
	| Grammar include_segment END_KEY_opt
	| Grammar notice_segment END_KEY_opt
	| Grammar define_segment END_KEY_opt
	| Grammar terminals_segment END_KEY_opt
	| Grammar export_segment END_KEY_opt
	| Grammar import_segment END_KEY_opt
	| Grammar softkeywords_segment END_KEY_opt
	| Grammar eof_segment END_KEY_opt
	| Grammar eol_segment END_KEY_opt
	| Grammar error_segment END_KEY_opt
	| Grammar recover_segment END_KEY_opt
	| Grammar identifier_segment END_KEY_opt
	| Grammar start_segment END_KEY_opt
	| Grammar alias_segment END_KEY_opt
	| Grammar names_segment END_KEY_opt
	| Grammar headers_segment END_KEY_opt
	| Grammar ast_segment END_KEY_opt
	| Grammar globals_segment END_KEY_opt
	| Grammar trailers_segment END_KEY_opt
	| Grammar rules_segment END_KEY_opt
	| Grammar types_segment END_KEY_opt
	| Grammar dps_segment END_KEY_opt
	;

include_segment :
	INCLUDE_KEY
	| INCLUDE_KEY SYMBOL
	;

notice_segment :
	NOTICE_KEY
	| notice_segment action_segment
	;

define_segment :
	DEFINE_KEY
	| define_segment macro_name_symbol macro_segment
	;

macro_name_symbol :
	MACRO_NAME
	| SYMBOL // warning: escape prefix missing...
	;

macro_segment :
	BLOCK
	;

terminals_segment :
	TERMINALS_KEY
	| terminals_segment terminal_symbol
	| terminals_segment terminal_symbol_lhs produces name
	;

export_segment :
	EXPORT_KEY
    | export_segment terminal_symbol
	;

import_segment :
	IMPORT_KEY
	| IMPORT_KEY SYMBOL drop_command_zom
	;

drop_command :
	drop_symbols
	| drop_rules
    //
    // TODO: NOT YET IMPLEMENTED !!!
    //
	| DROPACTIONS_KEY
	;

drop_symbols :
	DROPSYMBOLS_KEY
	| drop_symbols SYMBOL
	;

drop_rules :
	DROPRULES_KEY
	| drop_rules drop_rule
	;

drop_rule :
	SYMBOL produces rhs
	| SYMBOL MACRO_NAME produces rhs
	| drop_rule OR_MARKER rhs
	;

drop_command_zom :
	%empty
	| drop_command_zom drop_command
	;

softkeywords_segment :
	SOFTKEYWORDS_KEY
	| softkeywords_segment terminal_symbol
	| softkeywords_segment terminal_symbol produces name
	;

error_segment :
	ERROR_KEY
	| ERROR_KEY terminal_symbol
	;

recover_segment :
	RECOVER_KEY
	| recover_segment terminal_symbol
	;

identifier_segment :
	IDENTIFIER_KEY
	| IDENTIFIER_KEY terminal_symbol
	;

eol_segment :
	EOL_KEY
	| EOL_KEY terminal_symbol
	;

eof_segment :
	EOF_KEY
	| EOF_KEY terminal_symbol
	;

terminal_symbol :
	SYMBOL
	| MACRO_NAME // warning: escape prefix used in symbol
	;

terminal_symbol_lhs :
	SYMBOL_LHS
	| MACRO_NAME_LHS // warning: escape prefix used in symbol
	;

alias_segment :
	ALIAS_KEY
	| alias_segment ERROR_KEY produces alias_rhs
	| alias_segment EOL_KEY produces alias_rhs
	| alias_segment EOF_KEY produces alias_rhs
	| alias_segment IDENTIFIER_KEY produces alias_rhs
	| alias_segment SYMBOL produces alias_rhs
	| alias_segment alias_lhs_macro_name produces alias_rhs
	;

alias_lhs_macro_name :
	MACRO_NAME // warning: escape prefix used in symbol
	;

alias_rhs :
	SYMBOL
	| MACRO_NAME // warning: escape prefix used in symbol
	| ERROR_KEY
	| EOL_KEY
	| EOF_KEY
	| EMPTY_KEY
	| IDENTIFIER_KEY
	;

start_segment :
	START_KEY
	| start_segment start_symbol
	;

headers_segment :
	HEADERS_KEY
	| headers_segment headers_action_segment_list
	;

headers_action_segment_list :
	action_segment
	| headers_action_segment_list action_segment
	;

ast_segment :
	AST_KEY
	| ast_segment action_segment
	;

globals_segment :
	GLOBALS_KEY
        | globals_segment action_segment
	;

trailers_segment :
	TRAILERS_KEY
        | trailers_segment action_segment
	;

start_symbol :
	SYMBOL
        | MACRO_NAME
	;

rules_segment :
	RULES_KEY action_segment_zom
	| rules_segment rules
	;

rules :
	SYMBOL_LHS produces rhs
	| SYMBOL_LHS MACRO_NAME_LHS produces rhs
	| SYMBOL_LHS MACRO_NAME_LHS MACRO_NAME_LHS produces rhs
	| rules OR_MARKER rhs
	;

produces :
	EQUIVALENCE
	| PRIORITY_EQUIVALENCE
	| ARROW
	| PRIORITY_ARROW
        ;

rhs :
	%empty
	| rhs SYMBOL
	| rhs SYMBOL MACRO_NAME
	| rhs EMPTY_KEY
	| rhs rhs_action_segment_list
        ;

rhs_action_segment_list :
	action_segment
        | rhs_action_segment_list action_segment
	;

action_segment :
	BLOCK
        ;

types_segment :
	TYPES_KEY
        | types_segment type_declarationlist
        ;

type_declarationlist :
	type_declarations
	| type_declarations BLOCK
	;

type_declarations :
	SYMBOL_LHS produces SYMBOL
	| type_declarations OR_MARKER SYMBOL
	;

dps_segment :
	DISJOINTPREDECESSORSETS_KEY
        | dps_segment SYMBOL SYMBOL
	;

names_segment :
	NAMES_KEY
    | names_segment name produces name
	;

name :
	SYMBOL
	| MACRO_NAME // warning: escape prefix used in symbol
	| EMPTY_KEY
        | ERROR_KEY
	| EOL_KEY
        | IDENTIFIER_KEY
	;

END_KEY_opt :
	%empty
       | END_KEY
       ;

action_segment_zom :
	%empty
	| action_segment_zom action_segment
	;

%%

%option caseless

%x LHS

ident	[A-Za-z_][A-Za-z0-9_]*
macroname	"$"{ident}
string  \"(\\.|[^"\r\n"])+\"|'(\\.|[^'\r\n\\'])+'

symbol_lhs {ident}|"{"{ident}"}"
symbol {symbol_lhs}|{string}

EQUIVALENCE "::="
PRIORITY_EQUIVALENCE    "::=?"
ARROW   "->"
PRIORITY_ARROW  "->?"

produces    {EQUIVALENCE}|{PRIORITY_EQUIVALENCE}|{ARROW}|{PRIORITY_ARROW}

%%

[ \t\r\n]+	skip()
"--".*	skip()

"%Options".*    OPTIONS

"%DropSymbols"	DROPSYMBOLS_KEY
"%DropActions"	DROPACTIONS_KEY
"%DropRules"	DROPRULES_KEY
"%Notice"	NOTICE_KEY
"%Ast"	AST_KEY
"%Globals"	GLOBALS_KEY
"%Define"	DEFINE_KEY
"%Terminals"	TERMINALS_KEY
"%SoftKeywords"	SOFTKEYWORDS_KEY
"%Eol"	EOL_KEY
"%Eof"	EOF_KEY
"%Error"	ERROR_KEY
"%Identifier"	IDENTIFIER_KEY
"%Alias"	ALIAS_KEY
"%Empty"	EMPTY_KEY
"%Start"	START_KEY
"%Types"	TYPES_KEY
"%Rules"	RULES_KEY
"%Names"	NAMES_KEY
"%End"	END_KEY
"%Headers"	HEADERS_KEY
"%Trailers"	TRAILERS_KEY
"%Export"	EXPORT_KEY
"%Import"	IMPORT_KEY
"%Include"	INCLUDE_KEY
"%Recover"	RECOVER_KEY
"%DisjointPredecessorSets"	DISJOINTPREDECESSORSETS_KEY
{EQUIVALENCE}	EQUIVALENCE
{PRIORITY_EQUIVALENCE}	PRIORITY_EQUIVALENCE
{ARROW}	ARROW
{PRIORITY_ARROW}	PRIORITY_ARROW
"|"	OR_MARKER

"/."(?s:.)*?"./"	BLOCK
"/:"(?s:.)*?":/"	BLOCK
"/!"(?s:.)*?"!/"	BLOCK

{symbol_lhs}\s+{produces}<LHS>   reject()

<LHS>{
    {symbol_lhs} SYMBOL_LHS
    {EQUIVALENCE}<INITIAL>	EQUIVALENCE
    {PRIORITY_EQUIVALENCE}<INITIAL>	PRIORITY_EQUIVALENCE
    {ARROW}<INITIAL>	ARROW
    {PRIORITY_ARROW}<INITIAL>	PRIORITY_ARROW
    \s+ skip()
}

{macroname}	MACRO_NAME
{symbol}	SYMBOL

%%
