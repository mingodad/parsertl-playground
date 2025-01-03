//From: https://github.com/google/mangle/blob/41f705eb615c44ac79cca2371eac549a52bff0d7/parse/gen/Mangle.g4
// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//grammar Mangle;

%token BYTESTRING
%token CONSTANT
%token FLOAT
%token NAME
%token NUMBER
%token STRING
%token VARIABLE

%%
// Grammar rules

start:
	  program
	;

program:
	  packageDecl_opt useDecl_zom decl_or_clause_opt
	;

decl_or_clause_opt:
	  %empty
	| decl_or_clause_opt decl_or_clause
	;

decl_or_clause:
	  decl
	| clause
	;

useDecl_zom:
	  %empty
	| useDecl_zom useDecl
	;

packageDecl_opt:
	  %empty
	| packageDecl
	;

packageDecl:
	  "Package" NAME atoms_opt '!'
	;

atoms_opt:
	  %empty
	| atoms
	;

useDecl:
	  "Use" NAME atoms_opt '!'
	;

decl:
	  "Decl" atom descrBlock_opt boundsBlock_zom constraintsBlock_opt '.'
	;

constraintsBlock_opt:
	  %empty
	| constraintsBlock
	;

boundsBlock_zom:
	  %empty
	| boundsBlock_zom boundsBlock
	;

descrBlock_opt:
	  %empty
	| descrBlock
	;

descrBlock:
	  "descr" atoms
	;

boundsBlock:
	  "bound" term_list
	;

constraintsBlock:
	  "inclusion" atoms
	;

clause:
	  atom clauseBody_opt '.'
	;

clauseBody_opt:
	  %empty
	| ":-" clauseBody
	;

clauseBody:
	  literalOrFml comma_literalOrFml_zom comma_opt pipe_transform_zom
	;

pipe_transform_zom:
	  %empty
	| pipe_transform_zom "|>" transform
	;

comma_opt:
	  %empty
	| ','
	;

comma_literalOrFml_zom:
	  %empty
	| comma_literalOrFml_zom ',' literalOrFml
	;

transform:
	  "do" term letStmt_zom
	| letStmt comma_letStmt_zom
	;

letStmt_zom:
	  %empty
	| ',' letStmt comma_letStmt_zom
	;

comma_letStmt_zom :
	  %empty
	| comma_letStmt_zom ',' letStmt
	;

letStmt:
	  "let" VARIABLE '=' term
	;

literalOrFml:
	  term literalOrFml_op_term
	| '!' term
	;

literalOrFml_op_term:
	  %empty
	| literalOrFml_op term
	;

literalOrFml_op:
	  '='
	| "!="
	| '<'
	| "<="
	| '>'
	| ">="
	;

term:
	  VARIABLE #Var
	| CONSTANT #Const
	| NUMBER #Num
	| FLOAT #Float
	| STRING #Str
	| BYTESTRING #BStr
	| NAME '('  ')' #Appl
	| NAME '(' term_comma_oom ')' #Appl
	| term_list #List
	| '[' term_oom ']' #Map
	| '{' term_oom_opt '}' #Struct
	;

term_list :
	'[' ']'
	| '[' term_comma_oom comma_opt ']'
	;

term_comma_oom:
	  term
	| term_comma_oom ',' term
	;

term_oom_opt:
	  %empty
	| term_oom
	;

term_oom:
	  term ':' term
	| term_oom ',' term ':' term
	;

// Implementation enforces that this is an atom NAME(...)
atom:
	  term
	;

atoms:
	  '[' ']'
	| '[' atom_oom comma_opt ']'
	;

atom_oom:
	  atom
	| atom_oom ',' atom
	;

%%

// lexer rules

LETTER  [A-Za-z]
DIGIT   [0-9]
HEXDIGIT  [a-f0-9]

VARIABLE_START  [A-Z]
VARIABLE_CHAR  {LETTER}|{DIGIT}

EXPONENT  [eE][+-]?{DIGIT}+

NAME_CHAR  {LETTER}|{DIGIT}|[:_]
CONSTANT_CHAR  {LETTER}|{DIGIT}|[-._~%]

/// stringescapeseq ::=  "\[nt"'\]" | byteescape | unicodeescape | "\<newline>"
/// byteescape ::= "\x" hex hex
/// unicodeescape ::= "\u{" hex hex hex hex hex? hex? "}"
STRING_ESCAPE_SEQ  "\\"([nt"'\\\n]|"x"{HEXDIGIT}{2}|"u"{HEXDIGIT}{4,6})

/// shortstring     ::=  "'" shortstringitem* "'" | '"' shortstringitem* '"'
/// shortstringitem ::=  shortstringchar | stringescapeseq
/// shortstringchar ::=  <any source character except "\" or newline or the quote>
SHORT_STRING  '({STRING_ESCAPE_SEQ}|[^\\'])*'|\"({STRING_ESCAPE_SEQ}|[^\\"])*\"

/// longstringchar  ::=  <any source character except "\">
LONG_STRING_CHAR  [^\\]

/// longstringitem  ::=  longstringchar | stringescapeseq
LONG_STRING_ITEM  {LONG_STRING_CHAR}|{STRING_ESCAPE_SEQ}

/// longstring      ::=  "`" longstringitem* "`"
LONG_STRING  "`"{LONG_STRING_ITEM}*"`"

STRING	{SHORT_STRING}|{LONG_STRING}

WHITESPACE  [ \t\r\n] //( '\t' | ' ' | '\r' | '\n'| '\u000C' )+ -> channel(HIDDEN) ;
COMMENT  "#".*

%%

{WHITESPACE}+	skip()
{COMMENT}	skip()

"Package"	"Package"
"Use"	"Use"
"Decl"	"Decl"
"bound"	"bound"
"let"	"let"
"do"	"do"
"descr"	"descr"
"inclusion"	"inclusion"
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"="	'='
"!="	"!="
","	','
"!"	'!'
":"	':'
"."	'.'
"<"	'<'
"<="	"<="
">"	'>'
">="	">="
":-"	":-"
"|>"	"|>"

"-"?{DIGIT}+	NUMBER
"-"?{DIGIT}+"."{DIGIT}+{EXPONENT}?	FLOAT
"-"?"."{DIGIT}+{EXPONENT}?	FLOAT

"_"|({VARIABLE_START}{VARIABLE_CHAR}*)	VARIABLE

":"?[a-z]({NAME_CHAR}|("."{NAME_CHAR}))*	NAME


"/"{CONSTANT_CHAR}+("/"{CONSTANT_CHAR}+)*	CONSTANT

{STRING}	STRING
"b"{STRING}	BYTESTRING

%%
