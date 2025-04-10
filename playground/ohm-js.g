//From: https://github.com/ohmjs/ohm/blob/039b6b3efd3a95d7b8324c6725d89bc68c6ea276/packages/ohm-js/src/ohm-grammar.ohm

%token caseName
%token ruleName
%token name
%token oneCharTerminal
%token ruleDescr
%token terminal

%%

Grammars :
	Grammar
	| Grammars Grammar
	;

Grammar :
	ident SuperGrammar_opt '{' Rule_zom '}'
	;

SuperGrammar_opt :
	%empty
	| SuperGrammar
	;

SuperGrammar :
	"<:" ident
	;

Rule_zom :
	%empty
	| Rule_zom Rule
	;

Rule :
	ruleName Formals_opt  '='  RuleBody  #define
	| ruleName Formals_opt ruleDescr '='  RuleBody  #define
	| ruleName Formals_opt            ":=" OverrideRuleBody  #override
	| ruleName Formals_opt            "+=" RuleBody  #extend
	;

RuleBody :
	//'|'? NonemptyListOf<TopLevelTerm, '|'>
	TopLevelTerm
	| '|' TopLevelTerm
	| RuleBody '|' TopLevelTerm
	;

TopLevelTerm :
	Seq caseName  #inline
	| Seq
	;

OverrideRuleBody :
	//'|'? NonemptyListOf<OverrideTopLevelTerm, '|'>
	OverrideTopLevelTerm
	| '|' OverrideTopLevelTerm
	| OverrideRuleBody '|' OverrideTopLevelTerm
	;

OverrideTopLevelTerm :
	"..."  #superSplice
	| TopLevelTerm
	;

Formals_opt :
	%empty
	| Formals
	;

Formals :
	'<' ListOf_ident_comma_opt '>'
	;

ListOf_ident_comma_opt :
	%empty
	| ListOf_ident_comma
	;

ListOf_ident_comma :
	ident
	| ListOf_ident_comma ',' ident
	;

Params :
	'<' '>'
	| '<' Seq comma_seq_zom '>'
	;

comma_seq_zom :
	%empty
	| comma_seq_zom ',' Seq
	;

Alt :
	//NonemptyListOf<Seq, '|'>
	Seq
	| Alt '|' Seq
	;

Seq :
	%empty
	| Seq Iter
	;

Iter :
	Pred '*'  #star
	| Pred '+'  #plus
	| Pred '?'  #opt
	| Pred
	;

Pred :
	'~' Lex  #not
	| '&' Lex  #lookahead
	| Lex
	;

Lex :
	'#' Base  #lex
	| Base
	;

Base :
	//ident Params? ~(ruleDescr? '=' | ":=" | "+=")  #application
	ident
	| ident Params
	| oneCharTerminal ".." oneCharTerminal           #range
	| oneCharTerminal
	| terminal                                       #terminal
	| '(' Alt ')'                                    #paren
	;

ident : //(an identifier)
	name
	;

//tokens :
//	%empty
//	| tokens token
//	;
//
//token :
//	caseName
//	| comment
//	| ident
//	| operator
//	| punctuation
//	| terminal
//	| any
//	;

//operator :
//	"<:" | '=' | ":=" | "+=" | '*' | '+' | '?' | '~' | '&'
//	;
//
//punctuation :
//	'<' | '>' | ',' | "--"
//	;

%%

%x RULE_LHS

hexDigit    [0-9A-Fa-f]
ID	[A-Za-z_][A-Za-z0-9_]*

RULE_SEP ("="|":="|"+=")

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"#"	'#'
"&"	'&'
"("	'('
")"	')'
"*"	'*'
"+"	'+'
"+="	"+="
","	','
".."	".."
"..."	"..."
":="	":="
"<"	'<'
"<:"	"<:"
"="	'='
">"	'>'
"?"	'?'
"{"	'{'
"|"	'|'
"}"	'}'
"~"	'~'

{ID}\s*{RULE_SEP}<RULE_LHS>	reject()
{ID}\s*"<"[^><]+">"\s*{RULE_SEP}<RULE_LHS>	reject()
{ID}\s*"("[^)]+")"\s*{RULE_SEP}<RULE_LHS>	reject()
{ID}\s*"<"[^><]+">"\s*"("[^)]+")"\s*{RULE_SEP}<RULE_LHS>	reject()
<RULE_LHS>{
	{ID}<INITIAL>	ruleName
}

_X_ruleDescr	ruleDescr

\"("\\x"{hexDigit}{2}|"\\u"{hexDigit}{4}|"\\u{"{hexDigit}{1,6}"}"|\\.|[^"\r\n\\])\"	oneCharTerminal
\"(\\.|[^"\r\n\\])*\"	terminal

"--".*	caseName
{ID}	name

%%
