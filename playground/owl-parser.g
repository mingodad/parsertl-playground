//From: https://github.com/ianh/owl/blob/ae33e6410273f4e4c1347eef012bfa8c58c0ec53/doc/grammar-reference.md?plain=1

%token TK_colon
%token TK_comma
%token TK_exclude
%token TK_identifier
%token TK_integer
%token TK_lbrack
%token TK_lcurly
%token TK_line_comment_tk
%token TK_lp
//%token TK_number
%token TK_oom
%token TK_operators_tk
%token TK_opt
%token TK_or
%token TK_rbrack
%token TK_rcurly
%token TK_rename
%token TK_rp
%token TK_rule_sep
%token TK_string
%token TK_token_tk
%token TK_using
%token TK_whtespace_tk
%token TK_zom
%token TK_version
%token TK_concat
%token TK_rule_lhs

%%

grammar :
	%empty
	| TK_using TK_version decls
	| decls
	//| tokens
	;

decls :
	decl
	| decls decl
	;

decl :
	rules
	| comment_token
	| custom_token
	| whitespace
	;

rules :
	rule
	| rules rule
	;

rule :
	TK_rule_lhs TK_rule_sep rule_body operators_zom
	;

rule_body :
	rhs
	| rule_body rhs
	;

rhs :
	expr
	| named_choice
	;

named_choice :
	expr TK_colon TK_identifier
	;

operators_zom :
	%empty
	| operators_zom TK_operators_tk fixity operator_oom
	;

fixity :
	"postfix"
	| "prefix"
	| "infix" assoc
	;

assoc :
	"flat"
	| "left"
	| "right"
	| "nonassoc"
	;

operator_oom :
	named_choice
	| operator_oom named_choice
	;

comment_token :
	TK_line_comment_tk TK_string
	;

custom_token :
	TK_token_tk TK_identifier string_zom
	;

whitespace :
	TK_whtespace_tk string_zom
	;

string_zom :
	%empty
	| string_zom TK_string
	;

expr :
	TK_identifier exclude_zom rename_opt //: ident
	| TK_string //: literal
	| /*[*/ TK_lp expr_oom TK_rp /*]*/ //: parens
	| /*[*/ TK_lbrack TK_string expr_zom TK_string TK_rbrack /*]*/ //: bracketed

	| TK_zom //: zero-or-more //.operators postfix
	| TK_oom //: one-or-more //.operators postfix
	| TK_opt //: optional //.operators postfix

	| /*[*/ TK_lcurly  TK_rcurly /*]*/ //: repetition
	| /*[*/ TK_lcurly repetition TK_rcurly /*]*/ //: repetition
	| /*[*/ TK_lcurly expr TK_rcurly /*]*/ //: repetition
	| /*[*/ TK_lcurly expr TK_comma repetition TK_rcurly /*]*/ //: repetition

	| TK_concat //: concatenation //.operators infix flat

	| TK_or //: choice //.operators infix flat
	;

repetition :
	TK_integer //@begin : exact
	| TK_integer /*@begin*/ TK_oom //: at-least
	| TK_integer/*@begin*/ TK_comma TK_integer /*@end*/ //: range
	;

expr_oom :
	expr
	| expr_oom expr
	;

expr_zom :
	%empty
	| expr_zom expr
	;

exclude_zom :
	%empty
	| exclude_zom TK_exclude
	;

rename_opt :
	%empty
	| TK_rename
	;
/*
tokens :
	token
	| tokens token
	;

token :
	TK_colon
	| TK_comma
	| TK_exclude
	| TK_identifier
	| TK_integer
	| TK_lbrack
	| TK_lcurly
	| TK_line_comment_tk
	| TK_lp
	//| TK_number
	| TK_oom
	| TK_operators_tk
	| TK_opt
	| TK_or
	| TK_rbrack
	| TK_rcurly
	| TK_rename
	| TK_rp
	| TK_rule_sep
	| TK_string
	| TK_token_tk
	| TK_using
	| TK_whtespace_tk
	| TK_zom
	| TK_version
	| TK_concat
	| TK_rule_lhs
	;
*/

%%

%x HASH HASH_COMMENT VERSION RULE_LHS

ID [A-Za-z_][A-Za-z0-9_-]*

%%

[ \t\r\n]+	skip()

"("	TK_lp
")"	TK_rp
"|"	TK_or
"?"	TK_opt
"+"	TK_oom
"*"	TK_zom
"{"	TK_lcurly
"}"	TK_rcurly
","	TK_comma
"["	TK_lbrack
"]"	TK_rbrack
":"	TK_colon

"#"<HASH>
<HASH>{
    "using"<VERSION> TK_using
    .<HASH_COMMENT>
}
<HASH_COMMENT> {
    \n<INITIAL> skip()
    .<.>
}
<VERSION>{
    [A-Za-z_][A-Za-z0-9_.-]*<INITIAL>    TK_version
    [ \t]+  skip()
}

{ID}\s*"="<RULE_LHS>    reject()
<RULE_LHS>{
    {ID}    TK_rule_lhs
    "="<INITIAL> TK_rule_sep
    \s+  skip()
}

"flat"	"flat"
"infix"	"infix"
"left"	"left"
"nonassoc"	"nonassoc"
"postfix"	"postfix"
"prefix"	"prefix"
"right"	"right"

".operators"	TK_operators_tk
"."?"line-comment-token"	TK_line_comment_tk
".whitespace"	TK_whtespace_tk
".token"	TK_token_tk
//"#using"	TK_using

//[0-9]+"."[0-9]+	TK_number
[0-9]+	TK_integer

''|\"\"	TK_concat

\"(\\.|[^"\r\n\\])+\"	TK_string
'(\\.|[^'\r\n\\])+'	TK_string

"\\:"{ID}	TK_exclude
"@"{ID}	TK_rename
{ID}	TK_identifier

//"#".*	skip()

%%
