/* Modified by Vesa Karvonen on 2007-12-18.
 * Create line directives in output.
 */
/* ML-Yacc Parser Generator (c) 1989 Andrew W. Appel, David R. Tarditi */

/* parser for the ML parser generator */


%token ARROW ASTERISK BAR CHANGE COLON
%token COMMA DELIMITER FOR
%token HEADER ID IDDOT
%token PERCENT_HEADER INT KEYWORD LBRACE
%token NAME NODEFAULT NONTERM NOSHIFT OF
%token PERCENT_EOP PERCENT_PURE PERCENT_POS PERCENT_ARG
%token PERCENT_TOKEN_SIG_INFO
%token PREC PREC_TAG PREFER
%token PROG RBRACE SUBST START
%token TERM TYVAR VERBOSE VALUE
//%token UNKNOWN BOGUS_VALUE


%right ARROW
%left  ASTERISK

%%

BEGIN :
	HEADER MPC_DECLS DELIMITER G_RULE_LIST
	;

MPC_DECLS :
	/*empty*/
	| MPC_DECLS MPC_DECL
	;

MPC_DECL :
	TERM CONSTR_LIST
	| NONTERM CONSTR_LIST
	| PREC ID_LIST
	| START ID
	| PERCENT_EOP ID_LIST
	| KEYWORD ID_LIST
	| PREFER ID_LIST
	| CHANGE CHANGE_DECL
	| SUBST SUBST_DECL
	| NOSHIFT ID_LIST
	| PERCENT_HEADER PROG
	| PERCENT_TOKEN_SIG_INFO PROG
	| NAME ID
	| PERCENT_ARG PROG COLON TY
	| VERBOSE
	| NODEFAULT
	| PERCENT_PURE
	| PERCENT_POS TY
	| VALUE ID PROG
	;

CHANGE_DECL :
	CHANGE_DECL BAR CHANGE_DEC
	| CHANGE_DEC
	;

CHANGE_DEC :
	ID_LIST ARROW ID_LIST
	;

SUBST_DECL :
	SUBST_DECL BAR SUBST_DEC
	| SUBST_DEC
	;

SUBST_DEC :
	ID FOR ID
	;

CONSTR_LIST :
	CONSTR_LIST BAR ID OF TY
	| CONSTR_LIST BAR ID
	| ID OF TY
	| ID
	;

G_RULE :
	ID COLON RHS_LIST
	;

G_RULE_LIST :
	G_RULE_LIST G_RULE
	|   G_RULE
	;

ID_LIST :
	ID_LIST ID
	| /*empty*/
	;

RHS_LIST :
	ID_LIST G_RULE_PREC PROG
	| RHS_LIST BAR ID_LIST G_RULE_PREC PROG
	;

TY :
	TYVAR
	| LBRACE RECORD_LIST RBRACE
	| LBRACE RBRACE
	| PROG
	| TY QUAL_ID
	| QUAL_ID
	| TY ASTERISK TY
	| TY ARROW TY
	;

RECORD_LIST :
	RECORD_LIST COMMA LABEL COLON TY
	| LABEL COLON TY
	;

QUAL_ID :
	ID
	| IDDOT QUAL_ID
	;

LABEL :
	ID
	| INT
	;

G_RULE_PREC :
	/*empty*/
	| PREC_TAG ID
	;

%%

%x A CODE F COMMENT STRING EMPTYCOMMENT

ws  [\t\ ]+
eol ("\n"|"\013\n"|"\013")
idchars  [A-Za-z_'0-9]
id [A-Za-z]{idchars}*
tyvar "'"{idchars}*
qualid {id}"."

%%

"(*"<>COMMENT>
<A>"(*"<>EMPTYCOMMENT>
<CODE>"(*"<>COMMENT>
[^(%\013\n]+ skip()
<INITIAL,CODE,COMMENT,F,EMPTYCOMMENT>{eol}<.>

<A> {
"%prec"	PREC_TAG
"%term"	TERM
"%nonterm"	NONTERM
"%eop"	PERCENT_EOP
"%start"	START
"%prefer"	PREFER
"%subst"	SUBST
"%change"	CHANGE
"%keyword"	KEYWORD
"%name"	NAME
"%verbose"	VERBOSE
"%nodefault"	NODEFAULT
"%value"	VALUE
"%noshift"	NOSHIFT
"%header"	PERCENT_HEADER
"%pure"	PERCENT_PURE
"%token_sig_info"	PERCENT_TOKEN_SIG_INFO
"%arg"	PERCENT_ARG
"%pos"	PERCENT_POS
}

(?s:.)*?"%%"<A>	HEADER

<A>{eol}    skip()
<A>{ws}+	skip()
<A>of          OF
<A>for          FOR
<A>"{"          LBRACE
<A>"}"          RBRACE
<A>","          COMMA
<A>"*"          ASTERISK
<A>"->"         ARROW
<A>"%left"     PREC
<A>"%right"     PREC
<A>"%nonassoc"  PREC
<A>{tyvar}     TYVAR
<A>{qualid}     IDDOT
<A>[0-9]+       INT
<A>"%%"         DELIMITER
<A>":"          COLON
<A>"|"          BAR
<A>{id}         ID
<A>"("<>CODE>
//<A>.            UNKNOWN
<CODE>"("<>CODE>
<CODE>")"<<>      PROG
<CODE>"\""<>STRING>
<CODE>[^()"\n\013]+<.>

<COMMENT>[(*)]<.>
<COMMENT>"*)"<<>   skip()
<COMMENT>"(*"<>COMMENT>
<COMMENT>[^*()\n\013]+<.>

<EMPTYCOMMENT>[(*)]<.>
<EMPTYCOMMENT>"*)"<<>
<EMPTYCOMMENT>"(*"<>EMPTYCOMMENT> skip()
<EMPTYCOMMENT>[^*()\n\013]+<.>

<STRING>"\""<<>
<STRING>\\<.>
<STRING>[^"\\\n\013]+<.>
<STRING>\\\"<.>
<STRING>\\{eol}<F>
<STRING>\\[\ \t]<.>

<F>{ws}<.>
<F>\\<<>

%%
