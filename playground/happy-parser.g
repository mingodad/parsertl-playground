//From: https://github.com/haskell/happy/blob/535ce96533fb693a8a4441b0ac17cdb78bddfeec/packages/frontend/src/Happy/Frontend/Parser/Bootstrapped.ly
/*
-----------------------------------------------------------------------------
$Id: Parser.ly,v 1.15 2005/01/26 01:10:42 ross Exp $

The parser.

(c) 1993-2000 Andy Gill, Simon Marlow
-----------------------------------------------------------------------------
*/
/******
Notice that this grammar accepts "literate script" (lines starting with '<').
For non "literate script" you'll need to comment the following LEX rules
as shown bellow:
//^[^>].*	skip()
//^">"[ \t]+ skip()
******/

%token code
%token id
%token int
%token spec_attribute
%token spec_attributetype
%token spec_error
%token spec_errorhandlertype
%token spec_expect
%token spec_imported_identity
%token spec_left
%token spec_lexer
%token spec_monad
%token spec_name
%token spec_nonassoc
%token spec_partial
%token spec_prec
%token spec_right
%token spec_shift
%token spec_token
%token spec_tokentype

%%

parser :
	optCode core_parser optCode
	;

core_parser :
	tokInfos "%%" rules
	;

rules :
	rules rule
	| rule
	;

rule :
	id params "::" code ':' prods
	| id params "::" code id ':' prods
	| id params ':' prods
	;

params :
	'(' comma_ids ')'
	| %empty
	;

comma_ids :
	id
	| comma_ids ',' id
	;

prods :
	prods '|' prod
	| prod
	;

prod :
	terms prec code ';'
	| terms prec code
	;

term :
	id
	| id '(' comma_terms ')'
	;

terms :
      terms_rev
      | %empty
      ;

terms_rev :
	term
	| terms_rev term
	;

comma_terms :
	term
	| comma_terms ',' term
	;

prec :
	spec_prec id
	| spec_shift
	| %empty
	;

tokInfos :
      tokInfos tokInfo
      | tokInfo
      ;

tokInfo :
	spec_tokentype code
	| spec_token tokenSpecs
	| spec_name id optStart
	| spec_partial id optStart
	| spec_imported_identity
	| spec_lexer code code
	| spec_monad code
	| spec_monad code code
	| spec_monad code code code
	| spec_monad code code code code
	| spec_nonassoc ids
	| spec_right ids
	| spec_left ids
	| spec_expect int
	| spec_error code
	| spec_errorhandlertype id
	| spec_attributetype code
	| spec_attribute id code
	;

optStart :
	id
	| %empty
	;

tokenSpecs :
	tokenSpecs tokenSpec
	| tokenSpec
	;

tokenSpec :
	id code
	;

ids :
	ids id
	| %empty
	;

optCode :
	code
	| %empty
	;

%%

%x CODE LCOMMENT

ident	[A-Za-z_][0-9A-Za-z_]*

%%

[ \t\r\n]+	skip()
"--".*  skip()
"{-"<>LCOMMENT>
<LCOMMENT>{
    "{-"<>LCOMMENT>
    "-}"<<> skip()
    .|\n<.>
}

//Forn non "literate script" grammars comment the two rules bellow
^[^>].*	skip()
^">"[ \t]+ skip()

"|"	'|'
","	','
";"	';'
":"	':'
"("	'('
")"	')'

"::"	"::"
"%%"	"%%"
"%attribute"	spec_attribute
"%attributetype"	spec_attributetype
"%error"	spec_error
"%errorhandlertype"	spec_errorhandlertype
"%expect"	spec_expect
"%imported_identity"	spec_imported_identity
"%left"	spec_left
"%lexer"	spec_lexer
"%monad"	spec_monad
"%name"	spec_name
"%nonassoc"	spec_nonassoc
"%partial"	spec_partial
"%prec"	spec_prec
"%right"	spec_right
"%shift"	spec_shift
"%token"	spec_token
"%tokentype"	spec_tokentype

"{"<>CODE>
<CODE> {
    "{"<>CODE>
    "}"<<>  code
    \"(\\.|[^"\r\n\\])+\"<.>
    '(\\.|[^'\r\n\\])+'<.>
    {ident}'<.>
    \n|.<.>
}

{ident}	id
\"(\\.|[^"\r\n\\])+\"	id
'(\\.|[^'\r\n\\])+'	id
[0-9]+	int

%%
