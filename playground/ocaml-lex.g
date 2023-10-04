/**************************************************************************/
/*                                                                        */
/*                                 OCaml                                  */
/*                                                                        */
/*             Xavier Leroy, projet Cristal, INRIA Rocquencourt           */
/*                                                                        */
/*   Copyright 1996 Institut National de Recherche en Informatique et     */
/*     en Automatique.                                                    */
/*                                                                        */
/*   All rights reserved.  This file is distributed under the terms of    */
/*   the GNU Lesser General Public License version 2.1, with the          */
/*   special exception on linking described in the file LICENSE.          */
/*                                                                        */
/**************************************************************************/

/* The grammar for lexer definitions */

%token  Tident
%token  Tchar
%token  Tstring
%token  Taction
%token  Trule Tparse Tparse_shortest Tand Tequal Tor Tunderscore Teof //Tend
%token  Tlbracket Trbracket Trefill
%token  Tstar Tmaybe Tplus Tlparen Trparen Tcaret Tdash Tlet Tas Thash

%right Tas
%left Tor
%nonassoc CONCAT
%nonassoc Tmaybe Tstar Tplus
%left Thash
%nonassoc Tident Tchar Tstring Tunderscore Teof Tlbracket Tlparen

%start lexer_definition

%%

lexer_definition :
	header named_regexps refill_handler Trule definition other_definitions header //Tend
	;

header :
	Taction
	|
	;

named_regexps :
	named_regexps Tlet Tident Tequal regexp
	|
	;

other_definitions :
	other_definitions Tand definition
	|
	;

refill_handler :
	Trefill Taction
	|
	;

definition :
	Tident arguments Tequal Tparse entry
	| Tident arguments Tequal Tparse_shortest entry
	;

arguments :
    /*empty*/
	| arguments Tident
	;

entry :
	case rest_of_entry
	| Tor case rest_of_entry
	;

rest_of_entry :
	rest_of_entry Tor case
	|
	;

case :
	regexp Taction
	;

regexp :
	Tunderscore
	| Teof
	| Tchar
	| Tstring
	| Tlbracket char_class Trbracket
	| regexp Tstar
	| regexp Tmaybe
	| regexp Tplus
	| regexp Thash regexp
	| regexp Tor regexp
	| regexp regexp %prec CONCAT
	| Tlparen regexp Trparen
	| Tident
	| regexp Tas ident
	;

ident :
	Tident
	;

char_class :
	Tcaret char_class1
	| char_class1
	;

char_class1 :
	Tchar Tdash Tchar
	| Tchar
	| char_class1 char_class1 %prec CONCAT
	;

%%

%x comment_st string_st char_st action_st

/*identstart   [A-Za-z_\192-\214 \216-\246 \248-\255]*/
identstart   [A-Za-z_\xC0-\xD6\xD8-\xF6\xF8-\xFF]
identbody   {identstart}|['0-9]
backslash_escapes   [\\'"ntbr ]

lowercase  [a-z_]
ident  {identstart}{identbody}*
extattrident  {ident}("."{ident})*
blank  [ \t\f]

digit  [0-9]
hexdigit  [0-9A-Fa-f]

%%

[ \t\f\v\r]+		skip()
\n	skip()

/* Line number */
"#"[ \t]*[0-9]+[ \t]*(\"[^\n\r"]*\")?[^\n\r]*\n	skip()
"(*"<>comment_st>
"_"  Tunderscore

"rule"  Trule
"parse"  Tparse
"shortest"  Tparse_shortest
"and"  Tand
"eof"  Teof
"let"  Tlet
"as"   Tas
"refill"  Trefill

{ident}	Tident
\"<>string_st>

'<>char_st>
<char_st> {
	/* note: ''' is a valid character literal (by contrast with the compiler) */
	'<<>	Tchar
	"''"<<>	Tchar
	[^\\]<.>
	"\\"{backslash_escapes}<.>
	"\\"{digit}{digit}{digit}<.>
	"\\o"[0-3][0-7][0-7]<.>
	"\\x"{hexdigit}{hexdigit}<.>
}

"{"<>action_st>
"="   Tequal
"|"   Tor
"["   Tlbracket
"]"   Trbracket
"*"   Tstar
"?"   Tmaybe
"+"   Tplus
"("   Tlparen
")"   Trparen
"^"   Tcaret
"-"   Tdash
"#"   Thash
//eof   Tend


/* String parsing comes from the compiler lexer */
<string_st> {
	\"<<>	Tstring
	"\\"(\r*\n)[ \t]*<.>
	"\\"{backslash_escapes}<.>
	"\\"{digit}{digit}{digit}<.>
	"\\o"[0-3][0-7][0-7]<.>
	"\\x"{hexdigit}{hexdigit}<.>
	"\\u{"{hexdigit}+"}"<.>
	.<.>
}

/*
   Lexers comment and action are quite similar.
   They should lex strings, quoted strings and characters,
   in order not to be confused by what is inside them.
*/

<comment_st> {
	"(*"<>comment_st>
	"*)"<<>	skip()
	\"<>string_st>
	// '{' ('%' '%'? extattrident blank*/? (lowercase* as delim) "|"
	'<>char_st>
	\n<.>
	{ident}<.>
	.<.>
}

<action_st> {
	"{"<>action_st>
	"}"<<>	Taction
	\"<>string_st>
	// '{' ('%' '%'? extattrident blank*/? (lowercase* as delim) "|"
	'<>char_st>
	"/*"<>comment_st>
	\n<.>
	{ident}<.>
	.<.>
}

%%
