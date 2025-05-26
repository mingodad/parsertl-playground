//From: https://github.com/moonbitlang/moonyacc/blob/3c101b087254bac23fb747d04342a5e955d10f3d/src/lib/parser/parser.mbty

%token IDENT
%token LANGLE_CODE_RANGLE
%token LBRACE_CODE_RBRACE
%token PERCENT_LBRACE_CODE_PERCENT_RBRACE
%token PKG_AND_IDENT
%token STRING

%%

spec
  : decl_list "%%" rule_list trailer //EOF
  ;

decl_list
  : decl_list decl
  | %empty
  ;

decl
  : PERCENT_LBRACE_CODE_PERCENT_RBRACE
  | "%start" nonempty_symbol_list
  | "%start" LANGLE_CODE_RANGLE nonempty_symbol_list
  | "%token" nonempty_symbol_list
  | "%token" LANGLE_CODE_RANGLE nonempty_symbol_list
  | "%token" symbol STRING
  | "%token" LANGLE_CODE_RANGLE symbol STRING
  | "%type" LANGLE_CODE_RANGLE nonempty_symbol_list
  | "%position" LANGLE_CODE_RANGLE
  | "%left" nonempty_prec_symbol_list
  | "%right" nonempty_prec_symbol_list
  | "%nonassoc" nonempty_prec_symbol_list
  | "%derive" LANGLE_CODE_RANGLE IDENT
  ;

rule_list
  : rule
  | rule_list rule
  ;

trailer
  : PERCENT_LBRACE_CODE_PERCENT_RBRACE
  | "%%" //PERCENT_PERCENT_CODE_EOF
  | %empty
  ;

rule
  : rule_no_modifiers
  | "%inline" rule_no_modifiers
  ;

rule_no_modifiers
  : symbol opt_rule_return_type ':' clause_list ';'
  | symbol opt_rule_generic_params '(' nonempty_rule_param_list ')' opt_rule_return_type ':' clause_list ';'
  ;

opt_rule_return_type
  : "->" type_expr
  | %empty
  ;

nonempty_rule_param_list
  : IDENT
  | IDENT ':' type_expr
  | IDENT ',' nonempty_rule_param_list
  | IDENT ':' type_expr ',' nonempty_rule_param_list
  ;

opt_rule_generic_params
  : %empty
  | '[' nonempty_comma_ident_list ']'
  ;

nonempty_comma_ident_list
  : IDENT
  | nonempty_comma_ident_list ',' IDENT
  ;

type_expr
  : postfix_type_expr
  | '(' ')' "->" type_expr
  | '(' type_expr ')' "->" type_expr
  | '(' type_expr ',' ')' "->" type_expr
  | '(' type_expr ',' nonempty_type_expr_list ')' "->" type_expr
  ;

postfix_type_expr
  : basic_type_expr
  | postfix_type_expr '?'
  ;

basic_type_expr
  : IDENT
  | PKG_AND_IDENT
  | IDENT '[' nonempty_type_expr_list ']'
  | PKG_AND_IDENT '[' nonempty_type_expr_list ']'
  | '(' type_expr ',' nonempty_type_expr_list ')'
  | '(' type_expr ')'
  ;

nonempty_type_expr_list
  : type_expr
  | nonempty_type_expr_list ',' type_expr
  ;

clause_list
  : '|' nonempty_clause_list
  | nonempty_clause_list
  ;

nonempty_clause_list
  : clause_without_action clause_action
  | nonempty_clause_list '|' clause_without_action clause_action
  | nonempty_clause_list '|' nonempty_clause_without_action
  ;

clause_without_action
  : empty_clause_without_action
  | nonempty_clause_without_action
  ;

empty_clause_without_action
  : rule_prec
  ;

nonempty_clause_without_action
  : nonempty_item_list rule_prec
  ;

clause_action
  : LBRACE_CODE_RBRACE
  ;

rule_prec
  : "%prec" prec_symbol
  | %empty
  ;

nonempty_item_list
  : item
  | nonempty_item_list item
  ;

item
  : term
  | IDENT '=' term
  ;

term
  : symbol
  | symbol '(' nonempty_comma_term_list ')'
  | STRING
  ;

nonempty_comma_term_list
  : term
  | nonempty_comma_term_list ',' term
  ;

nonempty_symbol_list
  : symbol
  | nonempty_symbol_list symbol
  ;

nonempty_prec_symbol_list
  : prec_symbol
  | nonempty_prec_symbol_list prec_symbol
  ;

prec_symbol
  : symbol
  | STRING
  ;

symbol
  : IDENT
  ;

%%

%x ANGLE_CODE BRACE_CODE

ident [A-Za-z_][A-Za-z0-9_]*

%%

[ \t\r\n]+	skip()
<*>"(*"(?s:.)*?"*)"	skip()
<*>"/*"(?s:.)*?"*/"	skip()

"%%"	"%%"
"%derive"	"%derive"
"%inline"	"%inline"
"%left"	"%left"
"%nonassoc"	"%nonassoc"
"%position"	"%position"
"%prec"	"%prec"
"%right"	"%right"
"%start"	"%start"
"%token"	"%token"
"%type"	"%type"
":"	':'
";"	';'
"="	'='
"|"	'|'
"("	'('
")"	')'
","	','
"->"	"->"
"?"	'?'
"["	'['
"]"	']'

"<"<>ANGLE_CODE>
<ANGLE_CODE>{
	">"<<>	LANGLE_CODE_RANGLE
	"<"<>ANGLE_CODE>
	.|\n<.>
}
"{"<>BRACE_CODE>
<BRACE_CODE>{
	"}"<<>	LBRACE_CODE_RBRACE
	"{"<>BRACE_CODE>
	.|\n<.>
}
"%{"(?s:.)*?"%}"	PERCENT_LBRACE_CODE_PERCENT_RBRACE
//PERCENT_PERCENT_CODE_EOF	PERCENT_PERCENT_CODE_EOF

\"(\\.|[^"\r\n\\])+\"	STRING

"@"({ident}("/"{ident})*)"."{ident} PKG_AND_IDENT
{ident}	IDENT

%%
