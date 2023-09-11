/*

From: https://github.com/coq/coq/blob/master/coqpp/coqpp_parse.mly

- Changed right recursion by left recursion.

*/

/************************************************************************/
/*         *   The Coq Proof Assistant / The Coq Development Team       */
/*  v      *         Copyright INRIA, CNRS and contributors             */
/* <O___,, * (see version control and CREDITS file for authors & dates) */
/*   \VV/  **************************************************************/
/*    //   *    This file is distributed under the terms of the         */
/*         *     GNU Lesser General Public License Version 2.1          */
/*         *     (see LICENSE file for the text of the license)         */
/************************************************************************/

%x start_comment start_ocaml start_string

%token CODE
//%token  COMMENT
%token  IDENT QUALID
%token  STRING
%token  INT
%token VERNAC TACTIC GRAMMAR DOC_GRAMMAR EXTEND END DECLARE PLUGIN DEPRECATED ARGUMENT
%token RAW_PRINTED GLOB_PRINTED
%token SYNTERP COMMAND CLASSIFIED STATE PRINTED TYPED INTERPRETED GLOBALIZED SUBSTITUTED BY AS
%token BANGBRACKET HASHBRACKET LBRACKET RBRACKET PIPE ARROW FUN COMMA EQUAL STAR
%token LPAREN RPAREN COLON SEMICOLON
%token GLOBAL TOP FIRST LAST BEFORE AFTER LEVEL LEFTA RIGHTA NONA
//%token EOF

%start file

%%

file :
	nodes //EOF
	;

nodes :
	/*empty*/
	| nodes node
	;

node :
	CODE
	//| COMMENT
	| declare_plugin
	| grammar_extend
	| vernac_extend
	| tactic_extend
	| argument_extend
	| doc_gram
	;

declare_plugin :
	DECLARE PLUGIN STRING
	| DECLARE GLOBAL PLUGIN
	;

grammar_extend :
	GRAMMAR EXTEND qualid_or_ident globals gram_entries END
	;

argument_extend :
	ARGUMENT EXTEND IDENT typed_opt printed_opt interpreted_opt globalized_opt substituted_opt raw_printed_opt glob_printed_opt tactic_rules END
	| VERNAC ARGUMENT EXTEND IDENT printed_opt tactic_rules END
	;

printed_opt :
	/*empty*/
	| PRINTED BY CODE
	;

raw_printed_opt :
	/*empty*/
	| RAW_PRINTED BY CODE
	;

glob_printed_opt :
	/*empty*/
	| GLOB_PRINTED BY CODE
	;

interpreted_modifier_opt :
	/*empty*/
	| LBRACKET IDENT RBRACKET
	;

interpreted_opt :
	/*empty*/
	| INTERPRETED interpreted_modifier_opt BY CODE
	;

globalized_opt :
	/*empty*/
	| GLOBALIZED BY CODE
	;

substituted_opt :
	/*empty*/
	| SUBSTITUTED BY CODE
	;

typed_opt :
	/*empty*/
	| TYPED AS argtype
	;

argtype :
	IDENT
	| argtype IDENT
	| LPAREN argtype STAR argtype RPAREN
	;

vernac_extend :
	VERNAC vernac_entry EXTEND IDENT vernac_classifier vernac_state vernac_rules END
	;

vernac_entry :
	COMMAND
	| CODE
	;

vernac_classifier :
	/*empty*/
	| CLASSIFIED BY CODE
	| CLASSIFIED AS IDENT
	;

vernac_state :
	/*empty*/
	| STATE IDENT
	;

vernac_rules :
	vernac_rule
	| vernac_rules vernac_rule
	;

vernac_rule :
	PIPE vernac_attributes_opt rule_state LBRACKET ext_tokens RBRACKET rule_deprecation rule_classifier synterp_fun ARROW CODE
	;

rule_state :
	/*empty*/
	| BANGBRACKET IDENT RBRACKET
	;

vernac_attributes_opt :
	/*empty*/
	| HASHBRACKET vernac_attributes semicolon_opt RBRACKET
	;


vernac_attributes :
	vernac_attribute
	| vernac_attributes SEMICOLON vernac_attribute
	;

semicolon_opt :
    /*empty*/
    | SEMICOLON
    ;

vernac_attribute :
	qualid_or_ident EQUAL qualid_or_ident
	| qualid_or_ident
	;

rule_deprecation :
	/*empty*/
	| DEPRECATED
	;

rule_classifier :
	/*empty*/
	| FUN CODE
	;

synterp_fun :
	/*empty*/
	| SYNTERP AS IDENT CODE
	;

tactic_extend :
	TACTIC EXTEND IDENT tactic_deprecated tactic_level tactic_rules END
	;

tactic_deprecated :
	/*empty*/
	| DEPRECATED CODE
	;

tactic_level :
	/*empty*/
	| LEVEL INT
	;

tactic_rules :
	/*empty*/
	| tactic_rules tactic_rule
	;

tactic_rule :
	PIPE LBRACKET ext_tokens RBRACKET ARROW CODE
	;

ext_tokens :
	/*empty*/
	| ext_tokens ext_token
	;

ext_token :
	STRING
	| IDENT
	| IDENT LPAREN IDENT RPAREN
	| IDENT LPAREN IDENT COMMA STRING RPAREN
	;

qualid_or_ident :
	QUALID
	| IDENT
	;

globals :
	/*empty*/
	| GLOBAL COLON idents SEMICOLON
	;

idents :
	/*empty*/
	| idents qualid_or_ident
	;

gram_entries :
	/*empty*/
	| gram_entries gram_entry
	;

gram_entry :
	qualid_or_ident COLON reuse LBRACKET LBRACKET rules_opt RBRACKET RBRACKET SEMICOLON
	| qualid_or_ident COLON position_opt LBRACKET levels RBRACKET SEMICOLON
	;

reuse :
	TOP
	| LEVEL STRING
	;

position_opt :
	/*empty*/
	| position
	;

position :
	FIRST
	| LAST
	| BEFORE STRING
	| AFTER STRING
	;

string_opt :
	/*empty*/
	| STRING
	;

assoc_opt :
	/*empty*/
	| assoc
	;

assoc :
	LEFTA
	| RIGHTA
	| NONA
	;

levels :
	level
	| levels PIPE level
	;

level :
	string_opt assoc_opt LBRACKET rules_opt RBRACKET
	;

rules_opt :
	/*empty*/
	| rules
	;

rules :
	rule
	| rules PIPE rule
	;

rule :
	symbols_opt ARROW CODE
	;

symbols_opt :
	/*empty*/
	| symbols
	;

symbols :
	symbol
	| symbols SEMICOLON symbol
	;

symbol :
	IDENT EQUAL gram_tokens
	| gram_tokens
	;

gram_token :
	qualid_or_ident
	| qualid_or_ident LEVEL STRING
	| LPAREN gram_tokens RPAREN
	| LBRACKET rules RBRACKET
	| STRING
	;

gram_tokens :
	gram_token
	| gram_tokens gram_token
	;

doc_gram :
	DOC_GRAMMAR doc_gram_entries
	;

doc_gram_entries :
	/*empty*/
	| doc_gram_entries doc_gram_entry
	;

doc_gram_entry :
	qualid_or_ident COLON LBRACKET PIPE doc_gram_rules RBRACKET
	| qualid_or_ident COLON LBRACKET RBRACKET
	;

doc_gram_rules :
	doc_gram_rule
	| doc_gram_rules PIPE doc_gram_rule
	;

doc_gram_rule :
	doc_gram_symbols_opt
	;

doc_gram_symbols_opt :
	/*empty*/
	| doc_gram_symbols
	| doc_gram_symbols SEMICOLON
	;

doc_gram_symbols :
	doc_gram_symbol
	| doc_gram_symbols SEMICOLON doc_gram_symbol
	;

doc_gram_symbol :
	IDENT EQUAL doc_gram_gram_tokens
	| doc_gram_gram_tokens
	;

doc_gram_gram_tokens :
	doc_gram_gram_token
	| doc_gram_gram_tokens doc_gram_gram_token
	;

doc_gram_gram_token :
	qualid_or_ident
	| LPAREN doc_gram_gram_tokens RPAREN
	| LBRACKET doc_gram_rules RBRACKET
	| STRING
	;

%%

letter   [a-zA-Z]
letterlike   [_a-zA-Z]
alphanum   [_a-zA-Z0-9']
ident   {letterlike}{alphanum}*
qualid   {ident}("."{ident})*
space   [ \t\r\n]
number   [0-9]+

%%

{space}+	skip()

"GRAMMAR"	GRAMMAR
"VERNAC"	VERNAC
"COMMAND"	COMMAND
"TACTIC"	TACTIC
"EXTEND"	EXTEND
"DOC_GRAMMAR"	DOC_GRAMMAR
"END"	END
"DECLARE"	DECLARE
"PLUGIN"	PLUGIN
"DEPRECATED"	DEPRECATED
"CLASSIFIED"	CLASSIFIED
"STATE"	STATE
"PRINTED"	PRINTED
"TYPED"	TYPED
"INTERPRETED"	INTERPRETED
"GLOBALIZED"	GLOBALIZED
"SUBSTITUTED"	SUBSTITUTED
"ARGUMENT"	ARGUMENT
"RAW_PRINTED"	RAW_PRINTED
"GLOB_PRINTED"	GLOB_PRINTED
"SYNTERP"	SYNTERP
"BY"	BY
"AS"	AS
/** Camlp5 specific keywords */
"GLOBAL"	GLOBAL
"TOP"	TOP
"FIRST"	FIRST
"LAST"	LAST
"BEFORE"	BEFORE
"AFTER"	AFTER
"LEVEL"	LEVEL
"LEFTA"	LEFTA
"RIGHTA"	RIGHTA
"NONA"	NONA
/** Standard */
"!["	BANGBRACKET
"#["	HASHBRACKET
"["	LBRACKET
"]"	RBRACKET
"|"	PIPE
"->"	ARROW
"=>"	FUN
","	COMMA
":"	COLON
";"	SEMICOLON
"("	LPAREN
")"	RPAREN
"="	EQUAL
"*"	STAR

"(*"<>start_comment>
<start_comment> {
	"(*"<>start_comment>
	"*)"<<>	skip()
	(?s:.)<.>
}

"{"<>start_ocaml>
<start_ocaml> {
	"{"<>start_ocaml>
	"}"<<>	CODE
	\"<>start_string>
	"(*"<>start_comment>
	[^}]<.>
}

\"<>start_string>
<start_string> {
	("\\".|[^"\r\n\\])<.>
	\"<<>	STRING
}

{ident}  IDENT
{qualid}  QUALID
{number}  INT

%%
