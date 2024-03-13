//From: https://github.com/phorward/unicc/blob/b4b00d8a9d3159c5945acc65e2cd6b3eb1b3ec85/src/parse.par
// UniCC's own grammar parser

%token code
%token type
%token identifier
%token kw
%token ccl_string

%%

/*
 * Grammar
 */

grammar_spec :
	fixed_directive_def* segment*
	;

fixed_directive_def :
	"#!" fixed_directive ';'
	| "%!" fixed_directive ';'
	;

fixed_directive :
	"mode" mode_type
	| "language" string_or_ident
	;

mode_type :
	"scannerless"
	| "scanner"
	;

segment :
	code
	| definition ';'
	| unfixed_directive ';'
	;

unfixed_directive :
	'#' directive_parms
	;

directive_parms :
	"whitespaces" symbol_list
	| "lexeme" symbol_list
	| "fixate" symbol_list
	| "left" symbol_list
	| "right" symbol_list
	| "nonassoc" symbol_list
	| "prefix" string
	| "default action" code_opt
	| "default epsilon action" code_opt
	| "default value type" type
	| "lexeme separation" boolean_opt
	| "case insensitive strings" boolean_opt
	| "reserve terminals" boolean_opt
	| "prologue" code
	| "epilogue" code
	| "pcb" code
	| "extends" string
	;

boolean_opt :
	boolean
	| %empty
	;

boolean :
	"on"
	| "off"
	;

symbol_list :
	symbol_list sym
	| sym
	;

lhs :
	identifier
	;

alt_lhs_list :
	alt_lhs_list lhs
	| lhs
	;

alt_regex_sym :
	alt_regex_sym regex_sym
	| regex_sym
	;

regex_sym :
	identifier
	;

defines :
	"->"
	| ':'
	| "=>"
	| ":="
	;

definition :
	lhs goal_mark alt_lhs_list? type? defines productions
	| '@' alt_regex_sym type regex code_opt ast_node sym_option*
	;

sym_option :
	"#%" "greedy"
	| "#%" "non-greedy"
	;

goal_mark :
	'$'
	| %empty
	;

productions :
	productions '|' production
	| production
	;

ast_node :
	'=' identifier
	| '=' string
	| %empty
	;

production :
	rhs_opt code_opt_dup ast_node prod_directives*
	;

rhs_opt :
	rhs
	| %empty
	;

prod_directives :
	"#%" "precedence" terminal
	;

rhs :
	rhs symbol access_name
	| symbol access_name
	;

symbol :
	sym modifier
	| "&error"
	| "&eof"
	;

sym :
	terminal
	| identifier
	//Embedded productions
	| type '(' stack_cur_prod productions ')'
	;

stack_cur_prod :
	%empty
	;

terminal :
	ccl
	| kw
	| '@' identifier
	;

modifier :
	'*'
	| '+'
	| '?'
	| %empty
	;

access_name :
	':' identifier
	| ':' string_single
	| %empty
	;

/* Regular Expression parser and NFA generator */
regex :
	re_alt
	;

re_alt :
	re_alt '|' re_expr
	| re_expr
	;

re_expr :
	re_expr re_modifier
	| re_modifier
	;

re_modifier :
	re_factor '*'
	| re_factor '+'
	| re_factor '?'
	| re_factor
	;

re_factor :
	ccl
	| kw
	| '.'
	| '(' regex ')'
	;

/* General parsing objects */
string :
	string_single+
	;

string_single :
	ccl_string
	| kw
	;

ccl :
	ccl_string
	| '!' ccl_string
	;

string_or_ident :
	string
	| identifier
	;

code_opt_dup :
	code_opt
	;

code_opt :
	code
	| %empty
	;

%%

%x CODE

ident [A-Za-z_][A-Za-z0-9_]*

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"="	'='
"|"	'|'
";"	';'
":"	':'
"!"	'!'
"?"	'?'
"."	'.'
"("	'('
")"	')'
"@"	'@'
"$"	'$'
"*"	'*'
"+"	'+'

"=>"	"=>"
"->"	"->"
":="	":="
"#"	'#'
"#!"	"#!"
"#%"	"#%"
"%!"	"%!"
"case insensitive strings"	"case insensitive strings"
"default action"	"default action"
"default epsilon action"	"default epsilon action"
"default value type"	"default value type"
"&eof"	"&eof"
"epilogue"	"epilogue"
"&error"	"&error"
"extends"	"extends"
"fixate"	"fixate"
"greedy"	"greedy"
"language"	"language"
"left"	"left"
"lexeme"	"lexeme"
"lexeme separation"	"lexeme separation"
"mode"	"mode"
"nonassoc"	"nonassoc"
"non-greedy"	"non-greedy"
"off"	"off"
"on"	"on"
"pcb"	"pcb"
"precedence"	"precedence"
"prefix"	"prefix"
"prologue"	"prologue"
"reserve terminals"	"reserve terminals"
"right"	"right"
"scanner"	"scanner"
"scannerless"	"scannerless"
"whitespaces"	"whitespaces"

"[*"<>CODE>
<CODE> {
	"[*"<>CODE>
	"*]"<<>	code
	\n|.<.>
}

'(\\.|[^'\r\n\\])+'	ccl_string

\"(\\.|[^"\r\n\\])+\"	kw
//\"\"(\\.|[^"\r\n\\])+\"\"	kw
"<"[^>]+">"	type
{ident}	identifier

/* ------------------------------------- TODO: Must be re-designed... --- */
/*
ccl_string :
	'\'' ccl_str '\''
	;

ccl_str :
	ccl_str ccl_char
	| %empty
	;

ccl_char :
	!"\\\"'
	| "\\" !"\0"
	;

kw :
	"\"" "\"" kw_str "\"" "\""
	| "\"" kw_str "\""
	;

kw_str :
	kw_str kw_char
	| %empty
	;

kw_char :
	!"\\""
	| "\\" !"\0"
	;

type :
	'<' type_str '>'
	| %empty
	;

type_str :
	type_str !'>'
	| %empty
	;

identifier :
	identifier_start identifier_follow
	;

identifier_start :
	"A-Za-z_"
	;

identifier_follow :
	identifier_follow "A-Za-z0-9_"
	| %empty
	;


*/
/* ------------------------------------- TODO: ...until here --- */
/*
integer :
	integer "0-9"
	| "0-9"
	;

code :
	code_begin inner_code_opt "*]"
	;

code_begin :
	"[*"
	;

inner_code_opt :
	inner_code
	| %empty
	;

inner_code :
	inner_code anychar
	| anychar
	;

whitespace :
	' '
	| "\t"
	| "/ *" comment? "* /"
	| "//" scomment? "\n"
	| "\r"
	| "\n"
	;

comment :
	comment anychar
	| anychar
	;

anychar :
	!"\0"
	;

scomment :
	scomment !"\n"
	| !"\n"
	;

line_number :
	%empty
	;
*/
%%
