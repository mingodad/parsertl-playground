/*================================================================*/
/*
  JavaCup Specification for the JavaCup Specification Language
  by Scott Hudson GVU Center Georgia Tech August 1995
  and Frank Flannery Department of Computer Science Princeton Univ
  July 1996
  Bug Fixes. Scott Ananian Dept of Electrical Engineering Princeton
  University October 1996. [later Massachusetts Institute of Technology]
  This JavaCup specification is used to implement JavaCup itself.
  It specifies the parser for the JavaCup specification language.
  (It also serves as a reasonable example of what a typical JavaCup
  spec looks like).
  The specification has the following parts and import declarations
      These serve the same purpose as in a normal Java source file
      (and will appear in the generated code for the parser). In this
      case we are part of the javacup package and we import both the
      javacup runtime system and Hashtable from the standard Java
      utilities package.
    Action code
      This section provides code that is included with the class encapsulating
      the various pieces of user code embedded in the grammar (i.e. the
      semantic actions).  This provides a series of helper routines and
      data structures that the semantic actions use.
    Parser code
      This section provides code included in the parser class itself.  In
      this case we override the default error reporting routines.
    Init with and scan with
      These sections provide small bits of code that initialize then
      indicate how to invoke the scanner.
    Symbols and grammar
      These sections declare all the terminal and non terminal symbols
      and the types of objects that they will be represented by at runtime
      then indicate the start symbol of the grammar () and finally provide
      the grammar itself (with embedded actions).
    Operation of the parser
      The parser acts primarily by accumulating data structures representing
      various parts of the specification.  Various small parts (e.g. single
      code strings) are stored as static variables of the emit class and
      in a few cases as variables declared in the action code section.
      Terminals non terminals and productions are maintained as collection
      accessible via static methods of those classes.  In addition two
      symbol tables are kept   maintains the name to object mapping for all symbols
      Several intermediate working structures are also declared in the action
      code section.  These include rhs_pos and lhs_nt which
      build up parts of the current production while it is being parsed.
  Author(s)
    Scott Hudson GVU Center Georgia Tech.
    Frank Flannery Department of Computer Science Princeton Univ.
    C. Scott Ananian Department of Electrical Engineering Princeton Univ.
  Revisions
    v0.9a   First released version                     [SEH] 8/29/95
    v0.9b   Updated for beta language (throws clauses) [SEH] 11/25/95
    v0.10a  Made many improvements/changes. now offers value
              left/right positions and propagations
              cleaner label references
              precedence and associativity for terminals
              contextual precedence for productions
              [FF] 7/3/96
    v0.10b  Fixed %prec directive so it works like it's supposed to.
              [CSA] 10/10/96
    v0.10g   Added support for array types on symbols.
              [CSA] 03/23/98
    v0.10i  Broaden set of IDs allowed in multipart_id and label_id so
            that only java reserved words (and not CUP reserved words like
            'parser' and 'start') are prohibited.  Allow reordering of
	    action code parser code init code and scan with sections
	    and made closing semicolon optional for these sections.
	    Added 'nonterminal' as a terminal symbol finally fixing a
	    spelling mistake that's been around since the beginning.
	    For backwards compatibility you can still misspell the
	    word if you like.
    v0.11a  Added support for generic types on symbols.
    v0.12a  Clean up added options added parser name.
    v0.14   Added support for * + ? after symbols.
*/
/*================================================================*/
/*----------------------------------------------------------------*/
%token COMMA STAR DOT COLON COLON_COLON_EQUALS BAR
%token PERCENT_PREC LBRACK RBRACK GT LT QUESTION EQUALS PLUS
%token PACKAGE IMPORT CODE ACTION PARSER TERMINAL NON NONTERMINAL INIT
%token SCAN WITH START PRECEDENCE LEFT RIGHT NONASSOC SUPER EXTENDS
%token AFTER REDUCE OPTION
%token ID CODE_STRING SEMI
/*----------------------------------------------------------------*/
%start spec

%%

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
spec :
	package_spec
	import_spec*
	code_parts
	symbol+
	preced*
	start_spec
	production+
	//|
	///* error recovery assuming something went wrong before symbols
	//   and we have TERMINAL or NON TERMINAL to sync on.  if we get
	//   an error after that we recover inside symbol_list or
	//   production_list
	//*/
	//error
	//symbol+
	//preced*
	//start_spec
	//production+
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
package_spec :
	PACKAGE	multipart_id SEMI
	| /* empty */
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
import_spec :
	IMPORT import_id SEMI
	;

// allow any order; all parts are optional. [CSA 23-Jul-1999]
// (we check in the part action to make sure we don't have 2 of any part)
code_part :
	option_spec
	| parser_spec
	| action_code_part
	| parser_code_part
	| init_code
	| scan_code
	| after_reduce_code
	;

code_parts :
	| code_parts code_part
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
parser_spec :
	  PARSER multipart_id SEMI
	| PARSER multipart_id LT typearglist GT SEMI
    ;

option_spec :
	OPTION option_list SEMI
	;

option_list :
	option_list COMMA option_
	| option_
	;

option_ :
	robust_id
	| robust_id EQUALS robust_id
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
action_code_part :
	ACTION CODE CODE_STRING SEMI?
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
parser_code_part :
	PARSER CODE CODE_STRING SEMI?
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
init_code :
	INIT WITH CODE_STRING SEMI?
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
scan_code :
	SCAN WITH CODE_STRING SEMI?
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
after_reduce_code :
	AFTER REDUCE CODE_STRING SEMI?
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
symbol :
	terminal_non_terminal type_id  decl_symbol_list SEMI
	| terminal_non_terminal decl_symbol_list SEMI
	//|
	///* error recovery productions -- sync on semicolon */
	//terminal_non_terminal error SEMI
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
terminal_non_terminal :
    TERMINAL
    | NON TERMINAL
    | NONTERMINAL
	;

decl_symbol_list :
	decl_symbol_list COMMA new_symbol_id
	| new_symbol_id
	;

new_symbol_id :
	symbol_id
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
preced :
	PRECEDENCE assoc precterminal_list SEMI
	;

assoc :
    LEFT
    | RIGHT
    | NONASSOC
    ;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
precterminal_list :
	precterminal_list COMMA precterminal_id
	| precterminal_id
	;

precterminal_id :
	symbol_id
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
start_spec :
	START WITH symbol_id SEMI
	| /* empty */
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
production :
	symbol_id COLON_COLON_EQUALS rhs_list SEMI
	//| error SEMI
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
rhs_list :
	rhs_list BAR rhs
	| rhs
	;
/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
prod_precedence :
	PERCENT_PREC symbol_id
	| /* empty */
	;

rhs :
	prod_part* prod_precedence
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
prod_part :
	wild_symbol_id label_id?
	| CODE_STRING
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
wild_symbol_id :
	wild_symbol_id STAR
	| wild_symbol_id PLUS
	| wild_symbol_id QUESTION
	| symbol_id
	;

label_id :
	COLON robust_id
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
multipart_id :
	multipart_id DOT robust_id
    | robust_id
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
import_id :
	multipart_id DOT STAR
	| multipart_id
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
type_id :
	multipart_id
	| type_id LBRACK RBRACK
	|multipart_id LT typearglist GT
       	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
typearglist :
    typeargument
    | typearglist COMMA typeargument
    ;

typeargument :
    type_id
    | wildcard
    ;

wildcard :
    QUESTION
    | wildcard EXTENDS type_id
    | wildcard SUPER type_id
    ;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
symbol_id :
	ID
	| OPTION
	| SUPER
	| EXTENDS
	| CODE
	| ACTION
	| PARSER
	| INIT
	| SCAN
	| WITH
	| LEFT
	| RIGHT
	| NONASSOC
	| AFTER
	| REDUCE
	;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . */
robust_id : /* all ids that aren't reserved words in Java */
	ID
	/* package is reserved. */
	/* import is reserved. */
	| OPTION
	| CODE
	| ACTION
	| PARSER
	| TERMINAL
	| NON
	| NONTERMINAL
	| INIT
	| SCAN
	| WITH
	| START
	| PRECEDENCE
	| LEFT
	| RIGHT
	| NONASSOC
	| AFTER
	| REDUCE
	//| error
	;

/*----------------------------------------------------------------*/

%%

%x CODESEG

Newline \r|\n|\r\n
Whitespace [ \t\f]|{Newline}

/* comments */
TraditionalComment "/*"(?s:.)*?"*/"
EndOfLineComment "//".*
Comment {TraditionalComment}|{EndOfLineComment}

ident [A-Za-z_][A-Za-z0-9_]*  // Parse number as ident for options

%%

{Whitespace}  skip()
"?"           QUESTION
";"           SEMI
","	COMMA

"*"           STAR
"+"           PLUS
"."           DOT
"|"           BAR
"["           LBRACK
"]"           RBRACK
":"           COLON
"="           EQUALS
"::="         COLON_COLON_EQUALS
"%prec"       PERCENT_PREC
">"           GT
"<"           LT
{Comment}     skip()
"{:"<CODESEG>
"package"     PACKAGE
"import"      IMPORT
"option"      OPTION
"code"        CODE
"action"      ACTION
"parser"      PARSER
"non"         NON
"terminal" TERMINAL
"nonterminal" NONTERMINAL
"init"        INIT
"scan"        SCAN
"with"        WITH
"start"       START
"precedence"  PRECEDENCE
"left"        LEFT
"right"       RIGHT
"nonassoc"    NONASSOC
"extends"     EXTENDS
"super"       SUPER
"after"       AFTER
"reduce"      REDUCE
{ident}       ID


<CODESEG> {
  ":}"<INITIAL>   CODE_STRING
  \"(\\.|[^"\n\r\\])*\"<.>
  .|\n<.>
}

// error fallback
//.|\n          { emit_warning("Unrecognized character '" +yytext()+"' -- ignored"); }

%%
