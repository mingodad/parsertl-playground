//From: https://github.com/tendra/tendra/blob/46c4502004da94363eeedc1bdcb2d031733fd419/sid/src/parser.sid
/*
 * Copyright 2008-2011, The TenDRA Project.
 * Copyright 1997, United Kingdom Secretary of State for Defence.
 *
 * See doc/copyright/ for the full copyright terms.
 */

/*
 * SID .sid format grammar.
 */

//for fn in `find $HOME/dev/c/A_programming-languages/tendra -name '*.sid'`;do echo $fn:1:1; ./parsertl-playground tendra-sid.g $fn; done

%token SCOPEMARK
%token ALT_SEP
%token HANDLER_SEP
%token TYPEMARK
%token EMPTY
%token SEPARATOR
%token DEFINE
%token PRED_RESULT
%token IGNORE
%token REFERENCE
%token TERMINATOR
%token BEGIN_ACTION
%token END_ACTION
%token BEGIN_RULE
%token END_RULE
%token BEGIN_SCOPE
%token END_SCOPE
%token OPEN_TUPLE
%token CLOSE_TUPLE
%token ARROW
%token BLT_TYPES
%token BLT_TERMINALS
%token BLT_PRODUCTIONS
%token BLT_ENTRY
%token BASIC
%token IDENTIFIER

%%

sid_parse_grammar :
	BLT_TYPES type_decl_list
		BLT_TERMINALS terminal_decn_list
		BLT_PRODUCTIONS production_defn_list
		BLT_ENTRY entry_list TERMINATOR //EOF
	;

type_decl_list :
	/*empty*/
	| type_decl_list type_decl
	;

type_decl :
	IDENTIFIER TERMINATOR
	| IGNORE IDENTIFIER TERMINATOR
	;

terminal_decn_list :
	terminal_decn
	| terminal_decn_list terminal_decn
	;

terminal_decn :
	IGNORE identifier_or_basic function_type_defn TERMINATOR
	| identifier_or_basic function_type_defn TERMINATOR
	;

identifier_or_basic :
	BASIC
	| IDENTIFIER
	;

function_type_defn :
    %empty
	| TYPEMARK type_tuple_defn ARROW type_tuple_defn
	;

type_tuple_defn :
    OPEN_TUPLE CLOSE_TUPLE
	| OPEN_TUPLE tuple_defn_list CLOSE_TUPLE
	;

tuple_defn_list :
	tuple_defn
	| tuple_defn_list SEPARATOR tuple_defn
	;

tuple_defn :
	IDENTIFIER TYPEMARK IDENTIFIER reference_opt
	| TYPEMARK IDENTIFIER reference_opt
	;

reference_opt :
    %empty
    | REFERENCE
    ;

production_defn_list :
	production_defn
	| production_defn_list production_defn
	;

production_defn :
	scopemark_opt action_decn
	| scopemark_opt other_defn
	;

scopemark_opt :
    %empty
    | SCOPEMARK
    ;

action_decn :
	BEGIN_ACTION IDENTIFIER END_ACTION function_type_defn TERMINATOR
	| IGNORE BEGIN_ACTION IDENTIFIER END_ACTION function_type_defn TERMINATOR
	;

other_defn :
	IDENTIFIER TYPEMARK other_defn_more
	| IDENTIFIER define_rule
	;

other_defn_more :
	type_tuple_defn ARROW type_tuple_defn define_rule
	| IDENTIFIER TERMINATOR
	| IDENTIFIER DEFINE BEGIN_ACTION IDENTIFIER END_ACTION TERMINATOR
	;

define_rule :
	production_locals DEFINE BEGIN_RULE production_defn_rhs END_RULE TERMINATOR
	| TERMINATOR
	;

production_locals :
	/*empty*/
	| BEGIN_SCOPE production_defn_list END_SCOPE
	;

production_defn_rhs :
	production_defn_alternatives
	| production_defn_alternatives HANDLER_SEP exception_handler
	;

production_defn_alternatives :
	production_defn_alternative
	| production_defn_alternatives ALT_SEP production_defn_alternative
	;

production_defn_alternative :
	EMPTY TERMINATOR
	| production_defn_non_empty_alternative
	;

production_defn_non_empty_alternative :
	production_defn_item
	| production_defn_non_empty_alternative production_defn_item
	;

production_defn_item :
	BEGIN_RULE production_defn_rhs END_RULE TERMINATOR
	| production_defn_define
	;

production_defn_define :
	REFERENCE IDENTIFIER DEFINE production_defn_define_more
	| identifier_or_basic def_prod
	| lhs_name_tuple DEFINE production_defn_define_more
	| IGNORE DEFINE production_defn_define_more
	| PRED_RESULT DEFINE production_defn_define_more
	| BEGIN_ACTION IDENTIFIER END_ACTION rhs_name_tuple_opt TERMINATOR
	;

production_defn_define_more :
	BEGIN_ACTION IDENTIFIER END_ACTION rhs_name_tuple_opt TERMINATOR
	| identifier_or_basic rhs_name_tuple_opt TERMINATOR
	| rhs_name_tuple TERMINATOR
	| REFERENCE identifier_or_basic TERMINATOR
	;

rhs_name_tuple_opt :
    %empty
    | rhs_name_tuple
    ;

rhs_name_tuple :
	OPEN_TUPLE CLOSE_TUPLE
	| OPEN_TUPLE rhs_name_list CLOSE_TUPLE
	;

rhs_name_list :
	rhs_name
	| rhs_name_list SEPARATOR rhs_name
	;

rhs_name :
	IDENTIFIER
	| REFERENCE IDENTIFIER
	;

def_prod :
	DEFINE production_defn_define_more
	| TERMINATOR
	| rhs_name_tuple TERMINATOR
	;

lhs_name_tuple :
	OPEN_TUPLE lhs_name_list CLOSE_TUPLE
	;

lhs_name_list :
    lhs_name
	| lhs_name_list SEPARATOR lhs_name
	;

lhs_name :
	IDENTIFIER
	| IGNORE
	| PRED_RESULT
	| REFERENCE IDENTIFIER
	;

exception_handler :
	production_defn_non_empty_alternative
	;

entry_list :
	IDENTIFIER
	| entry_list SEPARATOR IDENTIFIER
	;

%%

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"    skip()

"::"	SCOPEMARK
"||"	ALT_SEP
"##"	HANDLER_SEP

":"	TYPEMARK
"$"	EMPTY
","	SEPARATOR
"="	DEFINE
"?"	PRED_RESULT
"!"	IGNORE
"&"	REFERENCE
";"	TERMINATOR

"<"	BEGIN_ACTION
">"	END_ACTION

"{"	BEGIN_RULE
"}"	END_RULE

"["	BEGIN_SCOPE
"]"	END_SCOPE

"("	OPEN_TUPLE
")"	CLOSE_TUPLE

"->"	ARROW

"%types%"	BLT_TYPES
"%terminals%"	BLT_TERMINALS
"%productions%"	BLT_PRODUCTIONS
"%entry%"	BLT_ENTRY

\"[^"]+\"	BASIC
[A-Za-z_-][A-Za-z0-9_-]*	IDENTIFIER

%%
