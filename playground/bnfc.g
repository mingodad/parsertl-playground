//From: https://github.com/BNFC/bnfc/blob/35c66af24839c176bd12a5b8294e1d552d835c3b/source/src/BNFC.cf
/*
    BNF Converter: Language definition
    Copyright (C) 2004  Author: Markus Forsberg, Michael Pellauer, Aarne Ranta


*/

%token Identifier String Integer Char Double

%%

// A Grammar is a sequence of definitions

//Grammar . Grammar ::= [Def] ;
Grammar :
	Def_list
	;

// separator Def ";" ;  // Note: this still permits a final semicolon.
//[].       [Def] ::= ;
//(:[]).    [Def] ::= Def ;
//(:).      [Def] ::= Def ";" [Def] ;
//// extra semicolons allowed
//_.        [Def] ::= ";" [Def] ;
Def_list :
	%empty
	| Def_list Def ';'
	;

// The rules of the grammar
//Rule .    Def ::= Label "." Cat "::=" [Item] ;
Def :
	Label '.' Cat "::=" Item_list
	;

// Items
//Terminal  . Item ::= String ;
//NTerminal . Item ::= Cat ;
Item :
	String #Terminal
	| Cat #NTerminal
	;

Item_list :
	%empty
	| Item_list Item
	;

//terminator Item "" ;

// Categories (non-terminals)
//ListCat  . Cat ::= "[" Cat "]" ;
//IdCat    . Cat ::= Identifier ;
Cat :
	'[' Cat ']' #ListCat
	| Identifier #IdCat
	;

Cat_list :
	Cat
	| Cat_list ',' Cat
	;

//separator Cat "," ; // for "entrypoints"

// Labels
//Id       . Label ::= Identifier          ;  // AST constructor
//Wild     . Label ::= "_"                 ;  // No AST constructor (embedding)
//ListE    . Label ::= "[" "]"             ;  // Empty list
//ListCons . Label ::= "(" ":" ")"         ;  // Cons
//ListOne  . Label ::= "(" ":" "[" "]" ")" ;  // Singleton list
Label :
	Identifier #Id
	| '_'	#Wild
	| '[' ']' #ListE
	| '(' ':' ')' #ListCons
	| '(' ':' '[' ']' ')' #ListOne
	;

// Pragmas
//Comment  .  Def ::= "comment"  String                     ; // Line comment
//Comments .  Def ::= "comment"  String String              ; // Block comment
//Internal .  Def ::= "internal" Label "." Cat "::=" [Item] ; // No parsing, AST and printing only
//Token.      Def ::=            "token" Identifier Reg     ; // Lexer token
//PosToken.   Def ::= "position" "token" Identifier Reg     ; // Lexer token with position info
//Entryp.     Def ::= "entrypoints" [Cat]                   ; // Names of parsers
//Separator.  Def ::= "separator"   MinimumSize Cat String  ; // List
//Terminator. Def ::= "terminator"  MinimumSize Cat String  ; // List
//Delimiters. Def ::= "delimiters"  Cat String String Separation MinimumSize;
//Coercions.  Def ::= "coercions"   Identifier Integer      ; // Embeddings and parenthesized exprs.
//Rules.      Def ::= "rules"       Identifier "::=" [RHS]  ; // Automatically generated lables (e.g. enums)
//Function.   Def ::= "define"      Identifier [Arg] "=" Exp;
Def :
	"comment"  String #Comment
	| "comment"  String String #Comments
	| "internal" Label '.' Cat "::=" Item_list #Internal
	| "token" Identifier Reg #Token
	| "position" "token" Identifier Reg #PosToken
	| "entrypoints" Cat_list #Entryp
	| "separator"   MinimumSize Cat String #Separator
	| "terminator"  MinimumSize Cat String #Terminator
	| "delimiters"  Cat String String Separation MinimumSize #Delimiters
	| "coercions"   Identifier Integer #Coercions
	| "rules"       Identifier "::=" RHS_list #Rules
	| "define"      Identifier Arg_list '=' Exp #Function
	;

//Arg.        Arg ::= Identifier ;
//separator   Arg "" ;
Arg :
	Identifier
	;

Arg_list :
	Arg
	| Arg_list Arg
	;

// Lists
//SepNone.    Separation ::= ;
//SepTerm.    Separation ::= "terminator" String;
//SepSepar.   Separation ::= "separator"  String;
Separation :
	%empty #SepNone
	| "terminator" String #SepTerm
	| "separator"  String #SepSepar
	;

// Layout
//Layout.     Def ::= "layout" [String]        ; // Layout start keywords
//LayoutStop. Def ::= "layout" "stop" [String] ; // Layout stop keywords
//LayoutTop.  Def ::= "layout" "toplevel"      ; // Should the toplevel be a block?
Def :
	"layout" String_list #Layout
	| "layout" "stop" String_list #LayoutStop
	| "layout" "toplevel" #LayoutTop
	;

String_list :
	String
	| String_list ',' String
	;

//separator nonempty String "," ;

// Expressions for "define" pragma
//Cons.       Exp  ::= Exp1 ":" Exp ;
Exp :
    Exp1
	| Exp ':' Exp1  #Cons
	;
//App.        Exp1 ::= Identifier [Exp2] ;
Exp1 :
    Exp2
	| Identifier Exp2_list #App
	;
//Var.        Exp2 ::= Identifier ;
//LitInt.     Exp2 ::= Integer ;
//LitChar.    Exp2 ::= Char ;
//LitString.  Exp2 ::= String ;
//LitDouble.  Exp2 ::= Double ;
//List.       Exp2 ::= "[" [Exp] "]" ;
Exp2 :
	Identifier #Var
	| Integer #LitInt
	| Char #LitChar
	| String #LitString
	| Double #LitDouble
	| '[' Exp_list ']'
	| '(' Exp ')'
	;

Exp2_list :
	Exp2
	| Exp2_list Exp2
	;

Exp_list :
    %empty
	| Exp
	| Exp_list ',' Exp
	;

//coercions   Exp 2;

//separator   Exp ","        ; // list list
//separator nonempty Exp2 "" ; // argument list

//RHS.      RHS ::= [Item] ;
//separator nonempty RHS "|" ;
RHS_list :
	Item_list
	| RHS_list '|' Item_list
	;

// List size condition
//MNonempty.  MinimumSize ::= "nonempty" ;
//MEmpty.     MinimumSize ::=  ;
MinimumSize :
	%empty #MEmpty
	| "nonempty" #MNonempty
	;

// Regular expressions

//RAlt.     Reg  ::= Reg  "|" Reg1  ;  // left-associative
Reg  :
    Reg1
	| Reg  '|' Reg1  #RAlt
	;

//RMinus.   Reg1 ::= Reg1 "-" Reg2  ;  // left-associative
Reg1 :
    Reg2
	| Reg1 '-' Reg2  #RMinus
	;

//RSeq.     Reg2 ::= Reg2 Reg3      ;  // left-associative
Reg2 :
    Reg3
	| Reg2 Reg3  #RSeq
	;

//RStar.    Reg3 ::= Reg3 "*"       ;
//RPlus.    Reg3 ::= Reg3 "+"       ;
//ROpt.     Reg3 ::= Reg3 "?"       ;
//
//REps.     Reg3 ::= "eps"          ;  // empty string, same as {""}
//
//RChar.    Reg3 ::= Char           ;  // single character
//RAlts.    Reg3 ::= "[" String "]" ;  // list of alternative characters
//RSeqs.    Reg3 ::= "{" String "}" ;  // character sequence
//
//RDigit.   Reg3 ::= "digit"        ;
//RLetter.  Reg3 ::= "letter"       ;
//RUpper.   Reg3 ::= "upper"        ;
//RLower.   Reg3 ::= "lower"        ;
//RAny.     Reg3 ::= "char"         ;
//
//coercions Reg 3;
Reg3 :
	Reg3 '*'  #RStar
	| Reg3 '+' #RPlus
	| Reg3 '?' #ROpt
	| "eps" #REps
	| Char #RChar
	| '[' String ']' #RAlts
	| '{' String '}' #RSeqs
	| "digit" #RDigit
	| "letter" #RLetter
	| "upper" #RUpper
	| "lower" #RLower
	| "char" #RAny
	| '(' Reg ')'
	;

%%

letter [A-Za-z]
digit [0-9]


%%

[ \t\r\n]+	skip()
// Comments in BNF source
//comment "--"
//comment "{-" "-}"
"--".*	skip()
"{-"(?s:.)*?"-}"	skip()

"("	'('
")"	')'
"*"	'*'
"+"	'+'
","	','
"-"	'-'
"."	'.'
":"	':'
"::="	"::="
";"	';'
"="	'='
"?"	'?'
"["	'['
"]"	']'
"_"	'_'
"char"	"char"
"coercions"	"coercions"
"comment"	"comment"
"define"	"define"
"delimiters"	"delimiters"
"digit"	"digit"
"entrypoints"	"entrypoints"
"eps"	"eps"
"internal"	"internal"
"layout"	"layout"
"letter"	"letter"
"lower"	"lower"
"nonempty"	"nonempty"
"position"	"position"
"rules"	"rules"
"separator"	"separator"
"stop"	"stop"
"terminator"	"terminator"
"token"	"token"
"toplevel"	"toplevel"
"upper"	"upper"
"{"	'{'
"|"	'|'
"}"	'}'

'(\\.|[^'\r\n])'	Char
[0-9]+"."[0-9]+	Double
[0-9]+	Integer
\"(\\.|[^"\r\n\\])*\"	String

// LBNF identifiers
//position token Identifier letter (letter | digit | '_')* ;
{letter}({letter}|{digit}|"_")*	Identifier

%%
