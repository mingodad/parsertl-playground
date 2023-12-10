
/*--- DFA Lexical Grammar Syntax. ---*/

/*--- Terminal Symbols. ------*/

//%token T_ERROR
%token T_ALPHA
%token T_LEXICAL
%token T_IGNORE
%token T_ESCAPE
%token T_LITERAL
%token T_INTEGER
//%token T_EOF

//%token T_ARROW
//%token T_LEFTP
//%token T_RIGHTP
//%token T_PLUS
//%token T_STAR
//%token T_QUEST
//%token T_DOTS
//%token T_BAR
//%token T_DASH
//%token T_SEMI
%token NL

%%
/*--- Nonterminal Symbols. ---*/

Goal :
	Grammar //<eof>
	;

Grammar :
	TokenProd_zom Definition_oom
	;

Definition_oom :
	Definition
	| Definition_oom Definition
	;

Definition :
	NonterminalDef
	| SetDef
	| EscapeDef
	;

/*--- Token Definitions ---*/

TokenProd_zom :
	%empty
	| TokenProd_zom TokenProd
	;

TokenProd :
	Token ReturnValue
	;

Token :
	T_LEXICAL	   					        //=> ADD_TOKEN  (1)
	| T_LITERAL  					   	    //=> ADD_TOKEN2 (1)
	;

ReturnValue :
	T_INTEGER                               //=> ADD_TERMNO (1)
	| T_ALPHA                               //=> ADD_DEFCON (1)
	;

/*--- Nonterminal Definitions ---*/

NonterminalDef :
	HeadSymbol ArrowProd_oom
	;

HeadSymbol :
	T_ALPHA								    //=> ADD_HEAD(1)
	| T_LEXICAL							    //=> ADD_HEADLEX(1)
	| T_IGNORE							    //=> ADD_HEADIGNORE(1)
	;

ArrowProd_oom :
	ArrowProd
	| ArrowProd_oom ArrowProd
	;

ArrowProd :
	Arrow TailExprList NL
	;

Arrow :
	"->"                                    //=> ADD_PROD()
	;

TailExprList :
	TailExpr
	| TailExprList TailExpr
	;

TailExpr :
	TailSymbol
	| TailSymbol '+'						//=> PUSH_PLUS()
	| TailSymbol '*'						//=> PUSH_ASTER()
	| TailSymbol '?'						//=> PUSH_QUEST()
	| GroupStart List GroupEnd
	;

List :
	TailExpr
	| List TailExpr
	| List Or TailExpr
	;

Or :
	'|'                                     //=> PUSH_OR()
	;

GroupStart :
	'('                                     //=> PUSH_GBEG()
	;

GroupEnd :
	')'                                     //=> PUSH_GEND()
	| ')' '+'								//=> PUSH_GPLUS()
	| ')' '*'								//=> PUSH_GASTER()
	| ')' '?'								//=> PUSH_GQUEST()
	;

TailSymbol :
	T_ALPHA									//=> PUSH_TAIL (1)
	| T_ESCAPE								//=> PUSH_TAIL (1)
	| T_LEXICAL                             //=> PUSH_TAIL (1)
	| T_LITERAL								//=> PUSH_TAIL (1)
	| T_INTEGER								//=> PUSH_TAIL (1)
	;

/*--- Set Definitions ---*/

SetDef :
	AlphaSymbol Equals SetExpr Semi_zom		//=> DEF_SET()
	;

Semi_zom :
	%empty
	| ';'
	;

AlphaSymbol :
	T_ALPHA								    //=> ADD_HEADSET(1)
	;

Equals :
	'='                                     //=> ADD_PROD()
	;

SetExpr :
	Range                                   //=> FIRST_RANGE(1)
	| FCharacter '|' Range					//=> ADD_RANGE(3)
	| FCharacter '|' Character				//=> ADD_CHAR(3)
	| FCharacter '|' SetItem				//=> ADD_SET(3)
	| FCharacter '-' Range					//=> SUB_RANGE(3)
	| FCharacter '-' Character				//=> SUB_CHAR(3)
	| FCharacter '-' SetItem				//=> SUB_SET(3)
	| FSetItem   '|' Range					//=> ADD_RANGE(3)
	| FSetItem   '|' Character				//=> ADD_CHAR(3)
	| FSetItem   '|' SetItem				//=> ADD_SET(3)
	| FSetItem   '-' Range					//=> SUB_RANGE(3)
	| FSetItem   '-' Character				//=> SUB_CHAR(3)
	| FSetItem   '-' SetItem				//=> SUB_SET(3)
	| SetExpr    '|' Range					//=> ADD_RANGE(3)
	| SetExpr    '|' Character				//=> ADD_CHAR(3)
	| SetExpr    '|' SetItem				//=> ADD_SET(3)
	| SetExpr    '-' Range					//=> SUB_RANGE(3)
	| SetExpr    '-' Character				//=> SUB_CHAR(3)
	| SetExpr    '-' SetItem				//=> SUB_SET(3)
	;

Range :
	RangeStart ".." RangeEnd
	;

RangeEnd :
	Character								//=> RANGE_END(1)
	;

RangeStart :
	Character                               //=> RANGE_START(1)
	;

FCharacter :
	Character								//=> FIRST_CHAR(1)
	;

FSetItem :
	SetItem									//=> FIRST_SET(1)
	;

Character :
	T_LITERAL
	| T_INTEGER
	;

SetItem :
	T_ALPHA
	| T_ESCAPE
	;

/*--- Escape Definitions ---*/

EscapeDef :
	EscapeSymbol Equals Number Semi_zom
	;

EscapeSymbol :
	T_ESCAPE							    //=> ADD_HEADSET(1)
	;

Number :
	T_INTEGER								//=> FIRST_CHAR(1)
	;

/*--- End of Grammar. ---*/

%%

%x expr_list

alpha	[A-Za-z_][A-Za-z0-9_]*

%%

[\n\r\t ]+	skip()
<INITIAL,expr_list> {
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

/*
"->"	T_ARROW
"("	T_LEFTP
")"	T_RIGHTP
"+"	T_PLUS
"*"	T_STAR
"?"	T_QUEST
".."	T_DOTS
"|"	T_BAR
"-"	T_DASH
";"	T_SEMI
*/

"->"<expr_list>	"->"
"+"	'+'
"*"	'*'
"?"	'?'
"|"	'|'
"("	'('
")"	')'
";"	';'
"="	'='
"-"	'-'
".."	".."

"{"{alpha}"}"	T_IGNORE
"\\"{alpha}	T_ESCAPE

//	T_ERROR			<error>        => error ();
{alpha}	T_ALPHA
"<"{alpha}">"	T_LEXICAL
'([^\n\r])+?'	T_LITERAL
[0-9]+	T_INTEGER
//	T_EOF				<eof>				;

}

<expr_list> {
    [\r\t ]+	skip()
    \n<INITIAL> NL
}

%%
