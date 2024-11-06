//From: https://github.com/qt/qtbase/blob/f5cad8035d04b7d10d879369d327917c2fef8141/src/tools/qlalr/lalr.g
// Copyright (C) 2016 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only WITH Qt-GPL-exception-1.0

%token ID
%token STRING_LITERAL

%token DECL_FILE
%token EXPECT
%token EXPECT_RR
%token IMPL_FILE
%token LEFT
%token MERGED_OUTPUT
%token NONASSOC
%token PARSER
%token PREC
%token RIGHT
%token START
%token TOKEN
%token TOKEN_PREFIX

%token COLON
%token OR
%token SEMICOLON

%token DECL
%token IMPL

//%token ERROR

%start Specification

%%
//----------------------------------------------------------- SPECS
Specification : Options Tokens Start Rules ;

Options : Empty ;
Options : Options Option ;

StartHeader : START ID ;

Start : StartHeader UserActionOpt ;

//----------------------------------------------------------- OPTIONS
Option : PARSER ID ;

Option : MERGED_OUTPUT ID ;

Option : DECL_FILE ID ;

Option : IMPL_FILE ID ;

Option : EXPECT ID ;

Option : EXPECT_RR ID ;

Option : TOKEN_PREFIX ID ;

//----------------------------------------------------------- TOKENS
Tokens : Empty ;
Tokens : Tokens Token ;

Token : TOKEN TerminalList ;

TerminalList : Terminal ;

TerminalList : TerminalList Terminal ;

Terminal : ID Empty ;

Terminal : ID STRING_LITERAL ;

PrecHeader: LEFT ;

PrecHeader: RIGHT ;

PrecHeader: NONASSOC ;

Token : PrecHeader TokenList ;

TokenList : TokenId ;
TokenList : TokenList TokenId ;

TokenId : ID ;

//----------------------------------------------------------- Code
Code : DECL ;

Code : IMPL ;

UserAction : Code ;
UserAction : UserAction Code ;

UserActionOpt : ;
UserActionOpt : UserAction ;

//----------------------------------------------------------- RULES
Rules : Empty ;
Rules : Rules Rule ;

RuleHeader : ID COLON ;

Rule : RuleHeader RuleDefinition SEMICOLON UserActionOpt ;

RuleDefinition : Symbols PrecOpt UserActionOpt ;
RuleDefinition : RuleDefinition NewRule OR Symbols PrecOpt UserActionOpt ;

NewRule : ;

PrecOpt : ;

PrecOpt : PREC ID ;

//----------------------------------------------------------- SYMBOLS
Symbols : Empty ;
Symbols : Symbols ID ;

//----------------------------------------------------------- HELPERS
Empty : ;

//----------------------------------------------------------- END
%%

%x DECL IMPL

cstr \"(\\.|[^"\r\n\\])*\"
cline_comment "//".*
cblock_comment "/*"(?s:.)*?"*/"

%%

[ \t\r\n]+	skip()
"--".*	skip()

"%decl"	DECL_FILE
"%expect"	EXPECT
"%expect-lr"	EXPECT_RR
"%impl"	IMPL_FILE
"%left"	LEFT
"%merged_output"	MERGED_OUTPUT
"%nonassoc"	NONASSOC
"%parser"	PARSER
"%prec"	PREC
"%right"	RIGHT
"%start"	START
"%token"	TOKEN
"%token_prefix"	TOKEN_PREFIX

"/."<DECL>
<DECL>{
    "./"<INITIAL>	DECL
    {cstr}<.>
    {cline_comment}<.>
    {cblock_comment}<.>
    .|\n<.>
}
"/:"<IMPL>
<IMPL>{
    ":/"<INITIAL>	IMPL
    {cstr}<.>
    {cline_comment}<.>
    {cblock_comment}<.>
    .|\n<.>
}
//ERROR	ERROR

":"|"::="	COLON
"|"	OR
";"	SEMICOLON

\"[^"\r\n]+\"	STRING_LITERAL
[A-Z-a-z0-9_][A-Z-a-z0-9_.]* ID

%%
