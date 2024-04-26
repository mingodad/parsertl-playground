/*
 * [The "BSD license"]
 *  Copyright (c) 2012-2014 Terence Parr
 *  Copyright (c) 2012-2014 Sam Harwell
 *  Copyright (c) 2015 Gerald Rosenberg
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *
 *  1. Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *  2. Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *  3. The name of the author may not be used to endorse or promote products
 *     derived from this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 *  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 *  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 *  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*	A grammar for ANTLR v4 written in ANTLR v4.
 *
 *	Modified 2015.06.16 gbr
 *	-- update for compatibility with Antlr v4.5
 *	-- add mode for channels
 *	-- moved members to LexerAdaptor
 * 	-- move fragments to imports
 */
//parser grammar ANTLRv4Parser;


//options { tokenVocab = ANTLRv4Lexer; }

//%token ILLEGAL_CHARACTER
%token INT STRING_LITERAL RBRACE SEMI ASSIGN DOT
%token BEGIN_ACTION BEGIN_ARGUMENT
%token TOKENS OPTIONS CHANNELS IMPORT FRAGMENT LEXER
%token PARSER GRAMMAR COMMA COLONCOLON
%token AT ACTION_CONTENT END_ACTION END_ARGUMENT
%token MODE RULE_REF COLON CATCH FINALLY RETURNS
%token THROWS LOCALS QUESTION PROTECTED PUBLIC PRIVATE
%token LPAREN RPAREN RARROW LT GT STAR PLUS_ASSIGN
%token PLUS OR RANGE POUND NOT ARGUMENT_CONTENT
%token TOKEN_REF LEXER_CHAR_SET

%%

grammarSpec:
	  grammarDecl prequelConstruct_zom rules modeSpec_zom
	;

modeSpec_zom:
	  %empty
	| modeSpec_zom modeSpec
	;

prequelConstruct_zom:
	  %empty
	| prequelConstruct_zom prequelConstruct
	;

grammarDecl:
	  grammarType identifier SEMI
	;

grammarType:
	  LEXER GRAMMAR
	| PARSER GRAMMAR
	| GRAMMAR
	;

prequelConstruct:
	  optionsSpec
	| delegateGrammars
	| tokensSpec
	| channelsSpec
	| action_
	;

optionsSpec:
	  OPTIONS optionSEMI_zom RBRACE
	;

optionSEMI_zom :
	  %empty
	| optionSEMI_zom option SEMI
	;

option:
	  identifier ASSIGN optionValue
	;

optionValue:
	  identifier DOTidentifier_zom
	| STRING_LITERAL
	| actionBlock
	| INT
	;

DOTidentifier_zom :
	  %empty
	| DOTidentifier_zom DOT identifier
	;

delegateGrammars:
	  IMPORT delegateGrammar COMMAdelegateGrammar_zom SEMI
	;

COMMAdelegateGrammar_zom :
	  %empty
	| COMMAdelegateGrammar_zom COMMA delegateGrammar
	;

delegateGrammar:
	  identifier ASSIGN identifier
	| identifier
	;

tokensSpec:
	  TOKENS idList_opt RBRACE
	;

idList_opt:
	  %empty
	| idList
	;

channelsSpec:
	  CHANNELS idList_opt RBRACE
	;

idList:
	  identifier idList_zom comma_opt
	;

comma_opt :
	  %empty
	| COMMA
	;

idList_zom:
	  %empty
	| idList_zom COMMA identifier
	;

action_:
    AT identifier actionBlock
    | AT actionScopeName COLONCOLON identifier actionBlock
	;

actionScopeName:
	  identifier
	| LEXER
	| PARSER
	;

actionBlock:
	  BEGIN_ACTION ACTION_CONTENT_zom END_ACTION
	;

ACTION_CONTENT_zom:
	  %empty
	| ACTION_CONTENT_zom ACTION_CONTENT
	;

argActionBlock:
	  BEGIN_ARGUMENT ARGUMENT_CONTENT_zom END_ARGUMENT
	;

ARGUMENT_CONTENT_zom:
	  %empty
	| ARGUMENT_CONTENT_zom ARGUMENT_CONTENT
	;

modeSpec:
	  MODE identifier SEMI lexerRuleSpec_zom
	;

lexerRuleSpec_zom:
	  %empty
	| lexerRuleSpec_zom lexerRuleSpec
	;

rules:
	  %empty
	| rules ruleSpec
	;

ruleSpec:
	  parserRuleSpec
	| lexerRuleSpec
	;

parserRuleSpec:
	  ruleModifiers_opt RULE_REF argActionBlock_opt ruleReturns_opt throwsSpec_opt localsSpec_opt rulePrequel_zom COLON ruleBlock SEMI exceptionGroup
	;

rulePrequel_zom:
	  %empty
	| rulePrequel_zom rulePrequel
	;

localsSpec_opt:
	  %empty
	| localsSpec
	;

throwsSpec_opt:
	  %empty
	| throwsSpec
	;

ruleReturns_opt:
	  %empty
	| ruleReturns
	;

argActionBlock_opt:
	  %empty
	| argActionBlock
	;

ruleModifiers_opt:
	  %empty
	| ruleModifiers
	;

exceptionGroup:
	  exceptionHandler_zom finallyClause_opt
	;

finallyClause_opt:
	  %empty
	| finallyClause
	;

exceptionHandler_zom:
	  %empty
	| exceptionHandler_zom exceptionHandler
	;

exceptionHandler:
	  CATCH argActionBlock actionBlock
	;

finallyClause:
	  FINALLY actionBlock
	;

rulePrequel:
	  optionsSpec
	| ruleAction
	;

ruleReturns:
	  RETURNS argActionBlock
	;

throwsSpec:
	  THROWS identifier COMMAidentifier_zom
	;

COMMAidentifier_zom :
	  %empty
	| COMMAidentifier_zom COMMA identifier
	;

localsSpec:
	  LOCALS argActionBlock
	;

ruleAction:
	  AT identifier actionBlock
	;

ruleModifiers:
	  ruleModifier
	| ruleModifiers ruleModifier
	;

ruleModifier:
	  PUBLIC
	| PRIVATE
	| PROTECTED
	| FRAGMENT
	;

ruleBlock:
	  ruleAltList
	;

ruleAltList:
	  labeledAlt ORlabeledAlt_zom
	;

ORlabeledAlt_zom:
	  %empty
	| ORlabeledAlt_zom OR labeledAlt
	;

labeledAlt:
	  alternative POUNDidentifier_opt
	;

POUNDidentifier_opt:
	  %empty
	| POUND identifier
	;

lexerRuleSpec:
	  fragment_opt TOKEN_REF optionsSpec_opt COLON lexerRuleBlock SEMI
	;

optionsSpec_opt:
	  %empty
	| optionsSpec
	;

fragment_opt:
	  %empty
	| FRAGMENT
	;

lexerRuleBlock:
	  lexerAltList
	;

lexerAltList:
	  lexerAlt orLexerAltList
	;

orLexerAltList:
	  %empty
	| orLexerAltList OR lexerAlt
	;

lexerAlt:
	  lexerElements
	|  lexerElements lexerCommands
	| %empty
	;

lexerElements:
	  lexerElement
	| lexerElements lexerElement
	;

lexerElement:
	  lexerAtom ebnfSuffix_opt
	| lexerBlock ebnfSuffix_opt
	| actionBlock questio_opt
	;

ebnfSuffix_opt :
	  %empty
	| ebnfSuffix
	;

lexerBlock:
	  LPAREN lexerAltList RPAREN
	;

lexerCommands:
	  RARROW lexerCommand COMMAlexerCommand_zom
	;

COMMAlexerCommand_zom:
	  %empty
	| COMMAlexerCommand_zom COMMA lexerCommand
	;

lexerCommand:
	  lexerCommandName LPAREN lexerCommandExpr RPAREN
	| lexerCommandName
	;

lexerCommandName:
	  identifier
	| MODE
	;

lexerCommandExpr:
	  identifier
	| INT
	;

altList:
	  alternative ORalternative_zom
	;

ORalternative_zom:
	  %empty
	| ORalternative_zom OR alternative
	;

alternative:
	  elementOptions_opt element_oom
	| %empty
	;

element_oom:
	  element
	| element_oom element
	;

elementOptions_opt:
	  %empty
	| elementOptions
	;

element:
	  labeledElement ebnfSuffix_opt
	| atom ebnfSuffix_opt
	| ebnf
	| actionBlock questio_opt
	;

labeledElement:
	  identifier assing atomOrBlock
	;

atomOrBlock:
	  atom
	| block
	;

assing:
	  ASSIGN
	| PLUS_ASSIGN
	;

ebnf:
	  block blockSuffix_opt
	;

blockSuffix_opt:
	  %empty
	| blockSuffix
	;

blockSuffix:
	  ebnfSuffix
	;

ebnfSuffix:
	  QUESTION questio_opt
	| STAR questio_opt
	| PLUS questio_opt
	;

questio_opt:
	  %empty
	| QUESTION
	;

lexerAtom:
	  characterRange
	| terminal
	| notSet
	| LEXER_CHAR_SET
	| DOT elementOptions_opt
	;

atom:
	  terminal
	| ruleref
	| notSet
	| DOT elementOptions_opt
	;

notSet:
	  NOT setElement
	| NOT blockSet
	;

blockSet:
	  LPAREN setElement ORsetElement_zom RPAREN
	;

ORsetElement_zom:
	  %empty
	| ORsetElement_zom OR setElement
	;

setElement:
	  TOKEN_REF elementOptions_opt
	| STRING_LITERAL elementOptions_opt
	| characterRange
	| LEXER_CHAR_SET
	;

block:
	  LPAREN ruleActionList altList RPAREN
	;

ruleActionList:
	  %empty
	| optionsSpec_opt ruleAction_zom COLON
	;

ruleAction_zom:
	  %empty
	| ruleAction_zom ruleAction
	;

ruleref:
	  RULE_REF argActionBlock_opt elementOptions_opt
	;

characterRange:
	  STRING_LITERAL RANGE STRING_LITERAL
	;

terminal:
	  TOKEN_REF elementOptions_opt
	| STRING_LITERAL elementOptions_opt
	;

elementOptions:
	  LT elementOption COMMAelementOption_zom GT
	;

COMMAelementOption_zom:
	  %empty
	| COMMAelementOption_zom COMMA elementOption
	;

elementOption:
	  identifier
	| identifier ASSIGN idOrStr
	;

idOrStr:
	  identifier
	| STRING_LITERAL
	;

identifier:
	  RULE_REF
	| TOKEN_REF
	;

%%

%x Argument TargetLanguageAction

/*
lexer grammar LexBasic;
// ======================================================
// Lexer fragments
*/

/* ----------------------------------- */
/* Whitespace & Comments */

Hws	[ \t]

Vws	[\r\n\f]

Ws	{Hws}|{Vws}

BlockComment	"/*"(?s:.)*?("*/")
/*|{EOF}*/

DocComment	"/**"(?s:.)*?("*/")
/*|{EOF}*/

LineComment	"//"[^\r\n]*

/* ----------------------------------- */
/* Symbols */

Esc	"\\"
Colon	":"
DColon	"::"
SQuote	"'"
DQuote	["]
LParen	"("
RParen	")"
LBrace	"{"
RBrace	"}"
LBrack	"["
RBrack	"]"
RArrow	"->"
Lt	"<"
Gt	">"
Equal	"="
Question	"?"
Star	"*"
Plus	"+"
PlusAssign	"+="
Underscore	"_"
Pipe	"|"
Dollar	"$"
Comma	","
Semi	";"
Dot	"."
Range	".."
At	"@"
Pound	"#"
Tilde	"~"

/* ----------------------------------- */
/* Digits */

HexDigit	[0-9a-fA-F]

DecDigit	[0-9]

/* ----------------------------------- */
/* Escapes */
/* Any kind of escaped character that we can embed within ANTLR literal strings. */

UnicodeEsc	u({HexDigit}({HexDigit}({HexDigit}{HexDigit}?)?)?)

EscSeq	{Esc}([btnfr"'\\]|{UnicodeEsc}|.)
/*|{EOF}*/

EscAny	{Esc}.

/* ----------------------------------- */
/* Numerals */

DecimalNumeral	0|[1-9]{DecDigit}*

/* ----------------------------------- */
/* Literals */

BoolLiteral	"true"|"false"

CharLiteral	{SQuote}({EscSeq}|[^'\r\n\\]){SQuote}

SQuoteLiteral	{SQuote}({EscSeq}|[^'\r\n\\])*{SQuote}

DQuoteLiteral	{DQuote}({EscSeq}|[^"\r\n\\])*{DQuote}

/*USQuoteLiteral	{SQuote}({EscSeq}|[^'\r\n\\])* */

/* ----------------------------------- */
/* Character ranges */

NameStartChar	[A-Za-z\xC0-\xD6\xD8-\xF6]
/*
   | '\u00F8' .. '\u02FF'
   | '\u0370' .. '\u037D'
   | '\u037F' .. '\u1FFF'
   | '\u200C' .. '\u200D'
   | '\u2070' .. '\u218F'
   | '\u2C00' .. '\u2FEF'
   | '\u3001' .. '\uD7FF'
   | '\uF900' .. '\uFDCF'
   | '\uFDF0' .. '\uFFFD'
   ;
*/
/* ignores | ['\u10000-'\uEFFFF] */

NameChar		{NameStartChar}|[0-9]|{Underscore}|\xB7
/*
   | '\u0300' .. '\u036F'
   | '\u203F' .. '\u2040'
   ;
*/
/* ----------------------------------- */
/* Types */

Int	"int"
/* ----------------------------------- */

WSNLCHARS {Ws}

/* ------------------------------------------------------------------------------
// Grammar specific Keywords, Punctuation, etc.
*/
ID	{NameStartChar}{NameChar}*

%%

/* ------------------------- */
/* Comments */
{DocComment}			skip()
/*DOC_COMMENT DocComment -> channel (COMMENT)*/

{BlockComment}		skip()
/*BLOCK_COMMENT BlockComment -> channel (COMMENT)*/

{LineComment}			skip()
/*LINE_COMMENT LineComment -> channel (COMMENT)*/

/* ------------------------- */
/* Integer */

{DecimalNumeral}	INT

/* ------------------------- */
/* Literal string
//
// ANTLR makes no distinction between a single character literal and a
// multi-character string. All literals are single quote delimited and
// may contain unicode escape sequences of the form \uxxxx, where x
// is a valid hexadecimal number (per Unicode standard).
*/
{SQuoteLiteral}	STRING_LITERAL

/*{USQuoteLiteral}	UNTERMINATED_STRING_LITERAL*/

/* ------------------------- */
/* Arguments
//
// Certain argument lists, such as those specifying call parameters
// to a rule invocation, or input parameters to a rule specification
// are contained within square brackets.
*/
{LBrack}<>Argument>	BEGIN_ARGUMENT

/* ------------------------- */
/* Target Language Actions */
{LBrace}<>TargetLanguageAction>	BEGIN_ACTION

/* ------------------------- */
/* Keywords
//
// 'options', 'tokens', and 'channels' are considered keywords
// but only when followed by '{', and considered as a single token.
// Otherwise, the symbols are tokenized as RULE_REF and allowed as
// an identifier in a labeledElement.
*/
"options"{WSNLCHARS}*"{"	OPTIONS
"tokens"{WSNLCHARS}*"{"	TOKENS
"channels"{WSNLCHARS}*"{"	CHANNELS


"import"	IMPORT
"fragment"	FRAGMENT
"lexer"	LEXER
"parser"	PARSER
"grammar"	GRAMMAR
"protected"	PROTECTED
"public"	PUBLIC
"private"	PRIVATE
"returns"	RETURNS
"locals"	LOCALS
"throws"	THROWS
"catch"	CATCH
"finally"	FINALLY
"mode"	MODE

/* ------------------------- */
/* Punctuation */

{Colon}	COLON
{DColon}	COLONCOLON
{Comma}	COMMA
{Semi}	SEMI
{LParen}	LPAREN
{RParen}	RPAREN
/*{LBrace}	LBRACE*/
{RBrace}	RBRACE
{RArrow}	RARROW
{Lt}	LT
{Gt}	GT
{Equal}	ASSIGN
{Question}	QUESTION
{Star}	STAR
{PlusAssign}	PLUS_ASSIGN
{Plus}	PLUS
{Pipe}	OR
/*{Dollar}	DOLLAR*/
{Range}	RANGE
{Dot}	DOT
{At}	AT
{Pound}	POUND
{Tilde}	NOT

/* ------------------------- */
/* Identifiers - allows unicode rule/token names */

/*{Id}	ID*/

/* ------------------------- */
/* Whitespace */

{Ws}+	skip()
/*Ws+ -> channel (OFF_CHANNEL) */

/* ------------------------- */
/* Illegal Characters
//
// This is an illegal character trap which is always the last rule in the
// lexer specification. It matches a single character of any value and being
// the last rule in the file will match when no other rule knows what to do
// about the character. It is reported as an error but is not passed on to the
// parser. This means that the parser to deal with the gramamr file anyway
// but we will not try to analyse or code generate from a file with lexical
// errors.

// Comment this rule out to allow the error to be propagated to the parser

ERRCHAR
   : . -> channel (HIDDEN)
   ;
*/

/*
//======================================================
// Lexer modes
// -------------------------
// Arguments

mode Argument;
*/
<Argument> {
/* E.g., [int x, List<String> a[]]*/
{LBrack}<>Argument>

{EscAny}	ARGUMENT_CONTENT

{DQuoteLiteral}	ARGUMENT_CONTENT

{SQuoteLiteral}	ARGUMENT_CONTENT

{RBrack}<<> END_ARGUMENT
/*
// added this to return non-EOF token type here. EOF does something weird
UNTERMINATED_ARGUMENT
   : EOF -> popMode
   ;
*/
(?s:[^\]])+?	ARGUMENT_CONTENT

}
/*
// TODO: This grammar and the one used in the Intellij Antlr4 plugin differ
// for "actions". This needs to be resolved at some point.
// The Intellij Antlr4 grammar is here:
// https://github.com/antlr/intellij-plugin-v4/blob/1f36fde17f7fa63cb18d7eeb9cb213815ac658fb/src/main/antlr/org/antlr/intellij/plugin/parser/ANTLRv4Lexer.g4#L587

// -------------------------
// Target Language Actions
//
// Many language targets use {} as block delimiters and so we
// must recursively match {} delimited blocks to balance the
// braces. Additionally, we must make some assumptions about
// literal string representation in the target language. We assume
// that they are delimited by ' or " and so consume these
// in their own alts so as not to inadvertantly match {}.
mode TargetLanguageAction;
*/
<TargetLanguageAction> {
{LBrace}<>TargetLanguageAction>

{EscAny} ACTION_CONTENT

{DQuoteLiteral} ACTION_CONTENT

{SQuoteLiteral} ACTION_CONTENT

{DocComment} ACTION_CONTENT

{BlockComment} ACTION_CONTENT

{LineComment} ACTION_CONTENT

{RBrace}<<> END_ACTION
/*
UNTERMINATED_ACTION
   : EOF -> popMode
   ;
*/
(?s:[^}])+?	ACTION_CONTENT

}
/*
// -------------------------
mode LexerCharSet;
LEXER_CHAR_SET_BODY
   : (~ [\]\\] | EscAny)+ -> more
   ;

LEXER_CHAR_SET
   : RBrack -> popMode
   ;

UNTERMINATED_CHAR_SET
   : EOF -> popMode
   ;
*/

/* Standard set of fragments */
/*
tokens { TOKEN_REF , RULE_REF , LEXER_CHAR_SET }
channels { OFF_CHANNEL , COMMENT }
*/

/* Order matter if identifier comes before keywords they are classified as identifier */
{ID}	TOKEN_REF
{ID}	RULE_REF
{LBrack}([^\]\\]|{EscAny})+{RBrack}	LEXER_CHAR_SET

/* Order matter if ILLEGAL_CHARACTER comes before identifier one letter identifer is classified as ILLEGAL_CHARACTER */
//.	ILLEGAL_CHARACTER

%%

