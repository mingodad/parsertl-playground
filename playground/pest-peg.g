//From: https://github.com/pest-parser/pest/blob/14d96d83d7e642d7c4a2b03354356e8aed14d5b3/meta/src/grammar.pest
// pest. The Elegant Parser
// Copyright (c) 2018 Dragoș Tiselice
//
// Licensed under the Apache License, Version 2.0
// <LICENSE-APACHE or http://www.apache.org/licenses/LICENSE-2.0> or the MIT
// license <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
// option. All files in the project carrying such notice may not be copied,
// modified, or distributed except according to those terms.
//! Pest meta-grammar
//!
//! # Warning: Semantic Versioning
//! There may be non-breaking changes to the meta-grammar
//! between minor versions. Those non-breaking changes, however,
//! may translate into semver-breaking changes due to the additional variants
//! added to the `Rule` enum. This is a known issue and will be fixed in the
//! future (e.g. by increasing MSRV and non_exhaustive annotations).

%token assignment_operator
%token atomic_modifier
%token character
%token choice_operator
%token closing_brace
%token closing_brack
%token closing_paren
%token comma
%token compound_atomic_modifier
%token grammar_doc
%token identifier
%token insensitive_string
%token integer
%token line_doc
%token NOT_OP
%token number
%token opening_brace
%token opening_brack
%token opening_paren
%token optional_operator
%token positive_predicate_operator
%token range_operator
%token repeat_once_operator
%token repeat_operator
%token sequence_operator
%token silent_modifier
%token string
%token tag_id

%%

/// The top-level rule of a grammar.
grammar_rules :
	grammar_doc_zom grammar_rule_zom
	;

grammar_doc_zom :
    %empty
    | grammar_doc_zom grammar_doc
    ;

grammar_rule_zom :
    %empty
    | grammar_rule_zom grammar_rule
    ;

/// A rule of a grammar.
grammar_rule :
	identifier  assignment_operator modifier_opt opening_brace  expression  closing_brace
	| line_doc
	;

modifier_opt :
    %empty
    | modifier
    ;

/// A rule modifier.
modifier :
	silent_modifier
	| atomic_modifier
	| compound_atomic_modifier
	| non_atomic_modifier
	;

/// For assigning labels to nodes.
node_tag :
	tag_id assignment_operator
	;

/// A rule expression.
expression :
	choice_operator_opt term
	| expression infix_operator term
	;

choice_operator_opt :
    %empty
    | choice_operator
    ;

/// A rule term.
term :
	node_tag_opt prefix_operator_zom node postfix_operator_zom
	;

node_tag_opt :
    %empty
    | node_tag
    ;

prefix_operator_zom :
    %empty
    | prefix_operator_zom prefix_operator
    ;

postfix_operator_zom :
    %empty
    | postfix_operator_zom postfix_operator
    ;

/// A rule node (inside terms).
node :
	opening_paren expression closing_paren
	| terminal
	;

/// A terminal expression.
terminal :
	_push
	| peek_slice
	| identifier
	| string
	| insensitive_string
	| range
	;

/// Possible predicates for a rule.
prefix_operator :
	positive_predicate_operator
	| negative_predicate_operator
	;

/// Branches or sequences.
infix_operator :
	sequence_operator
	| choice_operator
	;

/// Possible modifiers for a rule.
postfix_operator :
	optional_operator
	| repeat_operator
	| repeat_once_operator
	| repeat_exact
	| repeat_min
	| repeat_max
	| repeat_min_max
	;

/// A repeat exact times.
repeat_exact :
	opening_brace  number  closing_brace
	;

/// A repeat at least times.
repeat_min :
	opening_brace number comma closing_brace
	;

/// A repeat at most times.
repeat_max :
	opening_brace comma number closing_brace
	;

/// A repeat in a range.
repeat_min_max :
	opening_brace number comma number closing_brace
	;

/// A PUSH expression.
_push :
	"PUSH" opening_paren expression closing_paren
	;

/// A PEEK expression.
peek_slice :
	"PEEK" opening_brack integer_opt range_operator integer_opt closing_brack
	;

integer_opt :
    %empty
    | integer
    ;

/// A character range.
range :
	character range_operator character
	;

/// Non-atomic rule prefix.
non_atomic_modifier : NOT_OP ;

/// A negative predicate.
negative_predicate_operator : NOT_OP ;

%%

number	[0-9]+

/// An alpha character.
alpha	[A-Za-z]

/// An alphanumeric character.
alpha_num	{alpha}|[0-9]

/// An identifier.
identifier	("_"|{alpha})("_"|{alpha_num})*

string	\"(\\.|[^"\r\n\\])+\"

%%

[ \t\r\n]+	skip()

/// A multi-line comment.
"/*"(?s:.)*?"*/"	skip()

/// A top-level comment.
"//!".*	grammar_doc

/// A rule comment.
"///".*	line_doc

/// A single line comment.
"//".*	skip()

/// A range operator.
".."	range_operator

/// Assignment operator.
"="	assignment_operator

/// Opening brace for a rule.
"{"	opening_brace

/// Closing brace for a rule.
"}"	closing_brace

/// Opening parenthesis for a branch, PUSH, etc.
"("	opening_paren

/// Closing parenthesis for a branch, PUSH, etc.
")"	closing_paren

/// Opening bracket for PEEK (slice inside).
"["	opening_brack

/// Closing bracket for PEEK (slice inside).
"]"	closing_brack

/// Silent rule prefix.
"_"	silent_modifier

/// Atomic rule prefix.
"@"	atomic_modifier

/// Compound atomic rule prefix.
"$"	compound_atomic_modifier

"!"	NOT_OP

/// A positive predicate.
"&"	positive_predicate_operator

/// A sequence operator.
"~"	sequence_operator

/// A choice operator.
"|"	choice_operator

/// An optional operator.
"?"	optional_operator

/// A repeat operator.
"*"	repeat_operator

/// A repeat at least once operator.
"+"	repeat_once_operator

/// A comma terminal.
","	comma

"PUSH"	"PUSH"
"PEEK"	"PEEK"

/// A number.
{number}	number

/// An integer number (positive or negative).
{number}|"-"{number}	integer // = @{ number | "-" ~ "0"* ~ '1'..'9' ~ number? }

/// A string.
{string}	string

/// An insensitive string.
"^"{string}	insensitive_string

/// A single quoted character
'(\\.|[^'\r\n\\])'	character

/// An identifier.
{identifier}	identifier

/// A tag label.
"#"{identifier}	tag_id

%%