//From: https://github.com/aliceml/aliceml-alice/blob/master/doc/samples/aliceparser/AliceParser.y
/* Author:									*/
/*   Benedikt Grundmann <bgrund@ps.uni-sb.de>					*/
/*										*/
/* Copyright:									*/
/*   Benedikt Grundmann  2005   						*/
/*   Converted from ml-yacc grammar by Andre
/*										*/
/* Last change:									*/
/*   $Date$ by $Author$				*/
/*   $Revision$							*/


	/* Reserved words for the core language */
%token	ABSTYPE AND ANDALSO AS CASE DO DATATYPE ELSE
%token	END EXCEPTION FN FUN HANDLE IF IN INFIX
%token	INFIXR LET LOCAL NONFIX OF OP OPEN ORELSE
%token	RAISE REC THEN TYPE VAL WITH WITHTYPE WHILE
%token	LPAR RPAR LBRACK RBRACK LBRACE RBRACE COMMA COLON
%token	SEMICOLON DOTS UNDERBAR BAR EQUALS DARROW ARROW HASH

	/* Alice core extensions */
%token	DOT HASHBRACK
%token	FINALLY
%token	ASSERT
%token	FILE LINE
%token	EXTTYPE CONSTRUCTOR
%token	NON WITHFUN WITHVAL
%token	LAZY SPAWN

	/* Additional reserved words for the modules language */
%token	EQTYPE FUNCTOR INCLUDE SHARING SIG
%token	SIGNATURE STRUCT STRUCTURE WHERE COLONGREATER

	/* Alice module extensions */
%token	ANY FCT PACK UNPACK

	/* Alice component extensions */
%token	IMPORT FROM

	/* Secret internal keywords */
%token	PRIMITIVE OVERLOAD EQEQTYPE REFTYPE PERVASIVE

	/* Special constants */
%token	ZERO DIGIT NUMERIC
%token	INT WORD
%token	REAL
%token	STRING CHAR

	/* Identifiers */
%token	ALPHA STAR //SYMBOL
%token	TYVAR //ETYVAR

%left	SHARING
%left	SEMICOLON
%right	VAL FUN TYPE EQTYPE DATATYPE ABSTYPE EXTTYPE CONSTRUCTOR EXCEPTION STRUCTURE FUNCTOR SIGNATURE IMPORT PRIMITIVE OVERLOAD EQEQTYPE REFTYPE
%right	LOCAL OPEN INFIX INFIXR NONFIX INCLUDE
%right	AND
%precedence	DARROW		/* L/R is arbitrary */
%precedence	BAR		/* L/R is arbitrary */
%precedence	OF		/* L/R is arbitrary */
%precedence	DO		/* L/R is arbitrary */
%precedence	ELSE		/* L/R is arbitrary */
%precedence	LAZY		/* L/R is arbitrary */
%precedence	SPAWN		/* L/R is arbitrary */
%precedence	RAISE		/* L/R is arbitrary */
%precedence	IN		/* L/R is arbitrary */
%left	HANDLE FINALLY
%right	ORELSE
%right	ANDALSO
%left	WITHVAL
%left	WITHFUN
%right	AS
%precedence	NON		/* L/R is arbitrary */
%left	COLON COLONGREATER
%right	ARROW
%right	WHERE


%start component

%%

 /* Constants */

scon :
	 ZERO
	| DIGIT
	| NUMERIC
	| INT
	| WORD
	| STRING
	| CHAR
	| REAL
	;

d :
	 ZERO
	| DIGIT
	;


 /* Identifiers and labels */

lab :
	 ALPHA
	//| SYMBOL
	| STAR
	| DIGIT
	| NUMERIC
	;

vid :
	 vid_sq
	| EQUALS
 	;

vid_sq :
	 ALPHA
	//| SYMBOL
	| STAR
	;

tycon :
	 ALPHA
	//| SYMBOL
	;

tyvar :
 TYVAR
	;

strid :
 ALPHA
	| PERVASIVE
	;

sigid :
 ALPHA
	;

longvid :
	 longvid_sq
	| EQUALS
 	;

longvid_sq :
	 vid_sq
	| longstrid DOT vid
	;

longtycon :
	 tycon
	| longstrid DOT tycon
	;

longstrid :
	 strid
	| longstrid DOT strid
	;

longsigid :
	 sigid
	| longstrid DOT sigid
	;

OP_opt :
	 OP
	| %empty
	;

LAZY_SPAWN_opt :
	 LAZY
	| SPAWN
	| %empty
	;

 /* rule Core : Expressions */

atexp :
	 scon
	| FILE
	| LINE
	| longvid
	| OP longvid
	| LBRACE exprow_opt RBRACE
	| LBRACE atexp WHERE exprow RBRACE
	| HASH lab
	| LPAR RPAR
	| LPAR exp_COMMA_list2 RPAR
	| LBRACK exp_COMMA_list0 RBRACK
	| HASHBRACK exp_COMMA_list0 RBRACK
	| LPAR exp_SEMICOLON_list2 RPAR
	| LET dec IN exp_SEMICOLON_list1 END
	| LPAR exp RPAR
 	;

exp_COMMA_list0 :
	 exp_COMMA_list1
	| %empty
 	;

exp_COMMA_list1 :
	 exp COMMA exp_COMMA_list1
	| exp
 	;

exp_COMMA_list2 :
	 exp COMMA exp_COMMA_list1
 	;

exp_SEMICOLON_list1 :
	 exp SEMICOLON exp_SEMICOLON_list1
	| exp
 	;

exp_SEMICOLON_list2 :
	 exp SEMICOLON exp_SEMICOLON_list1
	;

exprow :
	 lab EQUALS exp COMMA_exprow_opt
	| vid_sq COLON_ty_opt COMMA_exprow_opt
 	;

COMMA_exprow_opt :
	 COMMA exprow
	| %empty
 	;

exprow_opt :
	 exprow
	| %empty
	;

appexp :
	 atexp
	| appexp atexp
	;

infexp :
	 appexp
	;

exp :
	 infexp
	| exp COLON ty
	| exp ANDALSO exp
	| exp ORELSE exp
	| exp FINALLY exp
	| exp HANDLE match
	| RAISE exp
	| LAZY exp
	| SPAWN exp
	| IF exp THEN exp ELSE exp
	| WHILE exp DO exp
	| CASE exp OF match
	| FN match
	| REC pat DARROW exp
	| PACK atstrexp COLON atsigexp
	| PACK atstrexp COLONGREATER atsigexp
	| ASSERT exp DO exp
	| ASSERT exp OF pat DO exp
	| ASSERT exp
	| ASSERT exp OF pat
	| ASSERT exp RAISE pat
	;

 /* Core: Matches */

match :
	 mrule BAR_match_opt
 	;

BAR_match_opt :
	 BAR match
	| %empty %prec DARROW
	;

mrule :
	 pat DARROW exp
	;


 /* Core: Declarations */

dec :
	 dec1
	| %empty
 	;

dec_sq :
	 dec1_sq
	| dec_sq dec_sq %prec SEMICOLON
 	;

dec1 :
	 dec1_sq
	| SEMICOLON
	| dec1 dec1 %prec SEMICOLON
 	;

dec1_sq :
	 dec1_sq_sq
	| LOCAL dec IN dec END
 	;

dec1_sq_sq :
	 VAL valbind
	| VAL tyvarseq1 valbind
	| FUN fvalbind
	| FUN tyvarseq1 fvalbind
	| TYPE typbind
	| EQTYPE typbind
	| EQEQTYPE typbind
	| DATATYPE datbind0 WITHTYPE_typbind_opt
	| DATATYPE datbind1 WITHTYPE_typbind_opt
	| DATATYPE tycon EQUALS DATATYPE longtycon
	| ABSTYPE datbind WITHTYPE_typbind_opt WITH dec END
	| EXTTYPE extbind
	| CONSTRUCTOR econbind
	| EXCEPTION exbind
	| STRUCTURE strbind
	| SIGNATURE sigbind
	| FUNCTOR funbind
	| OPEN longstrid_list1
	| INFIX d_opt vid_list1
	| INFIXR d_opt vid_list1
	| NONFIX vid_list1
	| OVERLOAD longtyconseq AS tyvar OP_opt vid COLON ty EQUALS longvidseq
	| OVERLOAD tyvar OP_opt vid COLON ty EQUALS longvid
	| PRIMITIVE VAL OP_opt vid COLON ty EQUALS STRING
	| PRIMITIVE FUN OP_opt vid COLON ty EQUALS STRING
	| PRIMITIVE TYPE tyvarseq tycon EQUALS STRING
	| PRIMITIVE EQTYPE tyvarseq tycon EQUALS STRING
	| PRIMITIVE EQEQTYPE tyvarseq tycon EQUALS STRING
	| PRIMITIVE EXTTYPE tyvarseq tycon EQUALS STRING
	| PRIMITIVE REFTYPE tyvar tycon EQUALS OP_opt vid OF tyvar
	| PRIMITIVE CONSTRUCTOR OP_opt vid OF_ty_opt COLON tyvarseq longtycon
	 EQUALS STRING
	| PRIMITIVE EXCEPTION OP_opt vid OF_ty_opt EQUALS STRING
	| PRIMITIVE STRUCTURE strid COLON sigexp EQUALS STRING
	| PRIMITIVE FUNCTOR strid atstrpat_list0 COLON sigexp EQUALS STRING
	| PRIMITIVE SIGNATURE sigid atstrpat_list0 EQUALS STRING
 	;

WITHTYPE_typbind_opt :
	 WITHTYPE typbind
	| %empty
 	;

vid_list1 :
	 vid vid_list1
	| vid
 	;

longstrid_list1 :
	 longstrid longstrid_list1
	| longstrid
 	;

d_opt :
	 d
	| %empty
	;

 /* Core: Bindings */

valbind :
	 pat EQUALS exp AND_valbind_opt
	| REC valbind
 	;

AND_valbind_opt :
	 AND valbind
	| %empty
	;

fvalbind :
	 fmatch AND_fvalbind_opt
	| LAZY fmatch AND_fvalbind_opt
	| SPAWN fmatch AND_fvalbind_opt
 	;

AND_fvalbind_opt :
	 AND fvalbind
	| %empty
	;

fmatch :
	 fmrule BAR_fmatch_opt
 	;

BAR_fmatch_opt :
	 BAR fmatch
	| %empty
	;

fmrule :
	 fpat EQUALS exp
	;

fpat :
	 pat
	;

typbind :
	 tyvarseq tycon AND_typbind_opt
	| tyvarseq tycon EQUALS ty AND_typbind_opt
 	;

AND_typbind_opt :
	 AND typbind
	| %empty
	;

datbind :
	 tyvarseq tycon EQUALS conbind AND_datbind_opt
 	;

datbind0 :
	 tycon EQUALS conbind AND_datbind_opt
 	;

datbind1 :
	 tyvarseq1 tycon EQUALS conbind AND_datbind_opt
 	;

AND_datbind_opt :
	 AND datbind
	| %empty
	;

conbind :
	 OP_opt vid OF_ty_opt BAR_conbind_opt
 	;

BAR_conbind_opt :
	 BAR conbind
	| %empty
 	;

OF_ty_opt :
	 OF ty
	| %empty
	;

extbind :
	 tyvarseq tycon AND_extbind_opt
 	;

AND_extbind_opt :
	 AND extbind
	| %empty
	;

econbind :
	 OP_opt vid OF_ty_opt COLON tyvarseq longtycon AND_econbind_opt
	| OP_opt vid EQUALS OP_opt longvid AND_econbind_opt
 	;

AND_econbind_opt :
	 AND econbind
	| %empty
	;

exbind :
	 OP_opt vid OF_ty_opt AND_exbind_opt
	| OP_opt vid EQUALS OP_opt longvid AND_exbind_opt
 	;

AND_exbind_opt :
	 AND exbind
	| %empty
	;


 /* Core: Patterns */

atpat :
	 UNDERBAR
	| longvid_sq
	| OP longvid
	| scon
	| LBRACE patrow_opt RBRACE
	| LPAR RPAR
	| LPAR pat_COMMA_list2 RPAR
	| LBRACK pat_COMMA_list0 RBRACK
	| HASHBRACK pat_COMMA_list0 RBRACK
	| LPAR pat_BAR_list2 RPAR
	| LPAR pat RPAR
 	;

pat_COMMA_list0 :
	 pat_COMMA_list1
	| %empty
 	;

pat_COMMA_list1 :
	 pat COMMA pat_COMMA_list1
	| pat
 	;

pat_COMMA_list2 :
	 pat COMMA pat_COMMA_list1
 	;

pat_BAR_list2 :
	 pat BAR pat
	| pat BAR pat_BAR_list2
	;

patrow :
	 DOTS
	| lab EQUALS pat COMMA_patrow_opt
	| vid_sq COLON_ty_opt AS_pat_opt COMMA_patrow_opt
 	;

COMMA_patrow_opt :
	 COMMA patrow
	| %empty
 	;

COLON_ty_opt :
	 COLON ty
	| %empty
 	;

AS_pat_opt :
	 AS pat
	| %empty
 	;

patrow_opt :
	 patrow
	| %empty
	;

infpat :
	 atpat
	| infpat atpat
	;

pat :
	 infpat
	| pat COLON ty
	| NON pat
	| pat AS pat
	| pat WHERE atexp
	| pat WITHVAL valbind END
	| pat WITHFUN fvalbind END
	| pat WITHVAL valbind WHERE atexp
	| pat WITHFUN fvalbind WHERE atexp
	;

 /* Core: Types */

ty :
	 tupty
	| tupty ARROW ty
 	;

tupty :
	 ty_STAR_list
 	;

ty_STAR_list :
	 consty STAR ty_STAR_list
	| consty
 	;

consty :
	 atty
	| tyseq longtycon
 	;

atty :
	 UNDERBAR
	| tyvar
	| LBRACE tyrow_opt RBRACE
	| LPAR ty RPAR
	;

tyrow :
	 lab COLON ty COMMA_tyrow_opt
 	;

COMMA_tyrow_opt :
	 COMMA tyrow
	| %empty
 	;

tyrow_opt :
	 tyrow
	| %empty
	;


 /* Core: Sequences */

tyseq :
	 consty
	| %empty
	| LPAR ty_COMMA_list2 RPAR
 	;

ty_COMMA_list2 :
	 ty COMMA ty_COMMA_list2
	| ty COMMA ty
	;

tyvarseq :
	 tyvarseq1
	| %empty
 	;

tyvarseq1 :
	 tyvar
	| LPAR tyvar_COMMA_list1 RPAR
 	;

tyvar_COMMA_list1 :
	 tyvar COMMA tyvar_COMMA_list1
	| tyvar
	;

longtyconseq :
	 longtyconseq1
	| %empty
 	;

longtyconseq1 :
	 longtycon
	| LPAR longtycon_COMMA_list1 RPAR
 	;

longtycon_COMMA_list1 :
	 longtycon COMMA longtycon_COMMA_list1
	| longtycon
	;

longvidseq :
	 longvidseq1
	| %empty
 	;

longvidseq1 :
	 longvid
	| LPAR longvid_COMMA_list1 RPAR
 	;

longvid_COMMA_list1 :
	 longvid COMMA longvid_COMMA_list1
	| longvid
	;

 /* Modules: Structures */

atstrexp :
	 STRUCT dec END
	| longstrid
	| LPAR strexp RPAR
	| LPAR dec RPAR
	| LET dec IN strexp END
	;

appstrexp :
	 atstrexp
	| appstrexp atstrexp
	;

strexp :
	 appstrexp
	| strexp COLON sigexp
	| strexp COLONGREATER sigexp
	| FCT strpat DARROW strexp
	| UNPACK infexp COLON sigexp
	| LAZY strexp
	| SPAWN strexp
	;

atstrpat :
	 LPAR strid COLON sigexp RPAR
	| LPAR UNDERBAR COLON sigexp RPAR
	| LPAR spec RPAR
	;

strpat :
	 atstrpat
	| strid COLON sigexp
	| UNDERBAR COLON sigexp
	;

strpat_sq :
	 atstrpat
	| strid COLON atsigexp
	| UNDERBAR COLON atsigexp
	;

strbind :
	 strid COLON_sigexp_opt EQUALS strexp__AND_strbind_opt
	| strid COLONGREATER sigexp EQUALS strexp__AND_strbind_opt
	| UNDERBAR COLON_sigexp_opt EQUALS strexp__AND_strbind_opt
 	;

AND_strbind_opt :
	 AND strbind
	| %empty
 	;

strexp__AND_strbind_opt :
	 appstrexp AND_strbind_opt
	| strexp COLON sigexp__AND_strbind_opt
	| strexp COLONGREATER sigexp__AND_strbind_opt
	| FCT strpat DARROW strexp__AND_strbind_opt
	| UNPACK infexp COLON sigexp__AND_strbind_opt
	| LAZY strexp__AND_strbind_opt
	| SPAWN strexp__AND_strbind_opt
 	;

sigexp__AND_strbind_opt :
	 sigexp_sq AND_strbind_opt
	| FCT strpat_sq ARROW sigexp__AND_strbind_opt
	| atsigexp ARROW sigexp__AND_strbind_opt
	| sigexp WHERE rea__AND_strbind_opt
 	;

rea__AND_strbind_opt :
	 VAL OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt__AND_strbind_opt
	| FUN OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt__AND_strbind_opt
	| CONSTRUCTOR OP_opt longvid EQUALS OP_opt longvid
						AND_rea_opt__AND_strbind_opt
	| EXCEPTION OP_opt longvid EQUALS OP_opt longvid
						AND_rea_opt__AND_strbind_opt
	| TYPE tyvarseq longtycon EQUALS ty AND_rea_opt__AND_strbind_opt
	| STRUCTURE longstrid COLON_sigexp_opt EQUALS longstrid
						AND_rea_opt__AND_strbind_opt
	| FUNCTOR longstrid COLON_sigexp_opt EQUALS longstrid
						AND_rea_opt__AND_strbind_opt
	| SIGNATURE longsigid atstrpat_list0 EQUALS
					sigexp__AND_rea_opt__AND_strbind_opt
 	;

AND_rea_opt__AND_strbind_opt :
	 AND_strbind_opt
	| AND rea__AND_strbind_opt
 	;

sigexp__AND_rea_opt__AND_strbind_opt :
	 appsigexp AND_rea_opt__AND_strbind_opt
 	;

COLON_sigexp_opt :
	 COLON sigexp
	| %empty
	;


 /* Modules: Signatures */

atsigexp :
	 ANY
	| SIG spec END
	| longsigid
	| LET dec IN sigexp END
	| LPAR sigexp RPAR
	| LPAR spec RPAR
	;

appsigexp :
	 atsigexp
	| appsigexp atstrexp
	;

sigexp :
	 sigexp_sq
	| FCT strpat_sq ARROW sigexp
	| atsigexp ARROW sigexp
	| sigexp WHERE rea
 	;

sigexp_sq :
	 appsigexp
	| sigexp WHERE longstrid EQUALS longstrid
	;

sigbind :
	 sigid atstrpat_list0 EQUALS sigexp__AND_sigbind_opt
 	;

atstrpat_list0 :
	 atstrpat_list1
	| %empty
 	;

AND_sigbind_opt :
	 AND sigbind
	| %empty
 	;

sigexp__AND_sigbind_opt :
	 sigexp_sq AND_sigbind_opt
	| FCT strpat_sq ARROW sigexp__AND_sigbind_opt
	| atsigexp ARROW sigexp__AND_sigbind_opt
	| sigexp WHERE rea__AND_sigbind_opt
 	;

rea__AND_sigbind_opt :
	 VAL OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt__AND_sigbind_opt
	| FUN OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt__AND_sigbind_opt
	| CONSTRUCTOR OP_opt longvid EQUALS OP_opt longvid
						AND_rea_opt__AND_sigbind_opt
	| EXCEPTION OP_opt longvid EQUALS OP_opt longvid
						AND_rea_opt__AND_sigbind_opt
	| TYPE tyvarseq longtycon EQUALS ty AND_rea_opt__AND_sigbind_opt
	| STRUCTURE longstrid COLON_sigexp_opt EQUALS longstrid
						AND_rea_opt__AND_sigbind_opt
	| FUNCTOR longstrid COLON_sigexp_opt EQUALS longstrid
						AND_rea_opt__AND_sigbind_opt
	| SIGNATURE longsigid atstrpat_list0 EQUALS
					sigexp__AND_rea_opt__AND_sigbind_opt
 	;

AND_rea_opt__AND_sigbind_opt :
	 AND_sigbind_opt
	| AND rea__AND_sigbind_opt
 	;

sigexp__AND_rea_opt__AND_sigbind_opt :
	 appsigexp AND_rea_opt__AND_sigbind_opt
	;

rea :
	 VAL OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt
	| FUN OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt
	| CONSTRUCTOR OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt
	| EXCEPTION OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt
	| TYPE tyvarseq longtycon EQUALS ty AND_rea_opt
	| STRUCTURE longstrid COLON_sigexp_opt EQUALS longstrid
 AND_rea_opt
	| FUNCTOR longstrid COLON_sigexp_opt EQUALS longstrid
 AND_rea_opt
	| SIGNATURE longsigid atstrpat_list0 EQUALS sigexp__AND_rea_opt
 	;

AND_rea_opt :
	 AND rea
	| %empty
 	;

sigexp__AND_rea_opt :
	 appsigexp AND_rea_opt
	;

 /* Modules: Functors */

funbind :
	 LAZY_SPAWN_opt strid atstrpat_list1 COLON_sigexp_opt
		EQUALS strexp__AND_funbind_opt

	| LAZY_SPAWN_opt strid atstrpat_list1 COLONGREATER sigexp
		EQUALS strexp__AND_funbind_opt
 	;

atstrpat_list1 :
	 atstrpat
	| atstrpat atstrpat_list1
 	;

AND_funbind_opt :
	 AND funbind
	| %empty
 	;

strexp__AND_funbind_opt :
	 appstrexp AND_funbind_opt
	| strexp COLON sigexp__AND_funbind_opt
	| strexp COLONGREATER sigexp__AND_funbind_opt
	| FCT strpat DARROW strexp__AND_funbind_opt
	| UNPACK infexp COLON sigexp__AND_funbind_opt
	| LAZY strexp__AND_funbind_opt
	| SPAWN strexp__AND_funbind_opt
 	;

sigexp__AND_funbind_opt :
	 sigexp_sq AND_funbind_opt
	| FCT strpat_sq ARROW sigexp__AND_funbind_opt
	| atsigexp ARROW sigexp__AND_funbind_opt
	| sigexp WHERE rea__AND_funbind_opt
 	;

rea__AND_funbind_opt :
	 VAL OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt__AND_funbind_opt
	| FUN OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt__AND_funbind_opt
	| CONSTRUCTOR OP_opt longvid EQUALS OP_opt longvid
						AND_rea_opt__AND_funbind_opt
	| EXCEPTION OP_opt longvid EQUALS OP_opt longvid
						AND_rea_opt__AND_funbind_opt
	| TYPE tyvarseq longtycon EQUALS ty AND_rea_opt__AND_funbind_opt
	| STRUCTURE longstrid COLON_sigexp_opt EQUALS longstrid
						AND_rea_opt__AND_funbind_opt
	| FUNCTOR longstrid COLON_sigexp_opt EQUALS longstrid
						AND_rea_opt__AND_funbind_opt
	| SIGNATURE longsigid atstrpat_list0 EQUALS
					sigexp__AND_rea_opt__AND_funbind_opt
 	;

AND_rea_opt__AND_funbind_opt :
	 AND_funbind_opt
	| AND rea__AND_funbind_opt
 	;

sigexp__AND_rea_opt__AND_funbind_opt :
	 appsigexp AND_rea_opt__AND_funbind_opt
	;

 /* Modules: Specifications */

spec :
	 spec1
	| %empty
 	;

spec1 :
	 spec1_sq
	| SEMICOLON
	| spec1 spec1_sq %prec SEMICOLON
	| spec1 SEMICOLON %prec SEMICOLON
	| SHARING TYPE longtycon_EQUALS_list2
	| spec1 SHARING TYPE longtycon_EQUALS_list2
	| SHARING SIGNATURE longsigid_EQUALS_list2
	| spec1 SHARING SIGNATURE longsigid_EQUALS_list2
	| SHARING longstrid_EQUALS_list2
	| spec1 SHARING longstrid_EQUALS_list2
 	;

spec1_sq :
	 VAL valdesc
	| FUN valdesc
	| TYPE typdesc
	| EQTYPE typdesc
	| EQEQTYPE typdesc
	| DATATYPE datdesc0 WITHTYPE_typdesc_opt
	| DATATYPE datdesc1 WITHTYPE_typdesc_opt
	| DATATYPE tycon EQUALS DATATYPE longtycon
	| EXTTYPE extdesc
	| CONSTRUCTOR econdesc
	| EXCEPTION exdesc
	| STRUCTURE strdesc
	| SIGNATURE sigdesc
	| FUNCTOR fundesc
	| INCLUDE sigexp
	| INFIX d_opt vid_list1
	| INFIXR d_opt vid_list1
	| NONFIX vid_list1
 	;

WITHTYPE_typdesc_opt :
	 WITHTYPE typdesc
	| %empty
 	;

longtycon_EQUALS_list1 :
	 longtycon EQUALS longtycon_EQUALS_list1
	| longtycon
 	;

longtycon_EQUALS_list2 :
	 longtycon EQUALS longtycon_EQUALS_list1
 	;

longsigid_EQUALS_list1 :
	 longsigid EQUALS longsigid_EQUALS_list1
	| longsigid
 	;

longsigid_EQUALS_list2 :
	 longsigid EQUALS longsigid_EQUALS_list1
 	;

longstrid_EQUALS_list1 :
	 longstrid EQUALS longstrid_EQUALS_list1
	| longstrid
 	;

longstrid_EQUALS_list2 :
	 longstrid EQUALS longstrid_EQUALS_list1
	;

 /* Modules: Descriptions */

valdesc :
	 OP_opt vid COLON ty AND_valdesc_opt
	| OP_opt vid EQUALS OP_opt longvid AND_valdesc_opt
 	;

AND_valdesc_opt :
	 AND valdesc
	| %empty
	;

typdesc :
	 tyvarseq tycon AND_typdesc_opt
	| tyvarseq tycon EQUALS ty AND_typdesc_opt
 	;

AND_typdesc_opt :
	 AND typdesc
	| %empty
	;

datdesc :
	 tyvarseq tycon EQUALS condesc AND_datdesc_opt
 	;

datdesc0 :
	 tycon EQUALS condesc AND_datdesc_opt
 	;

datdesc1 :
	 tyvarseq1 tycon EQUALS condesc AND_datdesc_opt
 	;

AND_datdesc_opt :
	 AND datdesc
	| %empty
	;

condesc :
	 OP_opt vid OF_ty_opt BAR_condesc_opt
 	;

BAR_condesc_opt :
	 BAR condesc
	| %empty
	;

extdesc :
	 tyvarseq tycon AND_extdesc_opt
 	;

AND_extdesc_opt :
	 AND extdesc
	| %empty
	;

econdesc :
	 OP_opt vid OF_ty_opt COLON tyvarseq longtycon AND_econdesc_opt
	| OP_opt vid EQUALS OP_opt longvid AND_econdesc_opt
 	;

AND_econdesc_opt :
	 AND econdesc
	| %empty
	;

exdesc :
	 OP_opt vid OF_ty_opt AND_exdesc_opt
	| OP_opt vid EQUALS OP_opt longvid AND_exdesc_opt
 	;

AND_exdesc_opt :
	 AND exdesc
	| %empty
	;

strdesc :
	 strid COLON sigexp__AND_strdesc_opt
	| strid COLON_sigexp_opt EQUALS longstrid AND_strdesc_opt
 	;

AND_strdesc_opt :
	 AND strdesc
	| %empty
 	;

sigexp__AND_strdesc_opt :
	 sigexp_sq AND_strdesc_opt
	| FCT strpat_sq ARROW sigexp__AND_strdesc_opt
	| atsigexp ARROW sigexp__AND_strdesc_opt
	| sigexp WHERE rea__AND_strdesc_opt
 	;

rea__AND_strdesc_opt :
	 VAL OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt__AND_strdesc_opt
	| FUN OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt__AND_strdesc_opt
	| CONSTRUCTOR OP_opt longvid EQUALS OP_opt longvid
						AND_rea_opt__AND_strdesc_opt
	| EXCEPTION OP_opt longvid EQUALS OP_opt longvid
						AND_rea_opt__AND_strdesc_opt
	| TYPE tyvarseq longtycon EQUALS ty AND_rea_opt__AND_strdesc_opt
	| STRUCTURE longstrid COLON_sigexp_opt EQUALS longstrid
						AND_rea_opt__AND_strdesc_opt
	| FUNCTOR longstrid COLON_sigexp_opt EQUALS longstrid
						AND_rea_opt__AND_strdesc_opt
	| SIGNATURE longsigid atstrpat_list0 EQUALS
					sigexp__AND_rea_opt__AND_strdesc_opt
 	;

AND_rea_opt__AND_strdesc_opt :
	 AND_strdesc_opt
	| AND rea__AND_strdesc_opt
 	;

sigexp__AND_rea_opt__AND_strdesc_opt :
	 appsigexp AND_rea_opt__AND_strdesc_opt
	;

sigdesc :
	 sigid atstrpat_list0 AND_sigdesc_opt
	| sigid atstrpat_list0 EQUALS sigexp__AND_sigdesc_opt
 	;

AND_sigdesc_opt :
	 AND sigdesc
	| %empty
 	;

sigexp__AND_sigdesc_opt :
	 sigexp_sq AND_sigdesc_opt
	| FCT strpat_sq ARROW sigexp__AND_sigdesc_opt
	| atsigexp ARROW sigexp__AND_sigdesc_opt
	| sigexp WHERE rea__AND_sigdesc_opt
 	;

rea__AND_sigdesc_opt :
	 VAL OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt__AND_sigdesc_opt
	| FUN OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt__AND_sigdesc_opt
	| CONSTRUCTOR OP_opt longvid EQUALS OP_opt longvid
						AND_rea_opt__AND_sigdesc_opt
	| EXCEPTION OP_opt longvid EQUALS OP_opt longvid
						AND_rea_opt__AND_sigdesc_opt
	| TYPE tyvarseq longtycon EQUALS ty AND_rea_opt__AND_sigdesc_opt
	| STRUCTURE longstrid COLON_sigexp_opt EQUALS longstrid
						AND_rea_opt__AND_sigdesc_opt
	| FUNCTOR longstrid COLON_sigexp_opt EQUALS longstrid
						AND_rea_opt__AND_sigdesc_opt
	| SIGNATURE longsigid atstrpat_list0 EQUALS
					sigexp__AND_rea_opt__AND_sigdesc_opt
 	;

AND_rea_opt__AND_sigdesc_opt :
	 AND_sigdesc_opt
	| AND rea__AND_sigdesc_opt
 	;

sigexp__AND_rea_opt__AND_sigdesc_opt :
	 appsigexp AND_rea_opt__AND_sigdesc_opt
	;

fundesc :
	 strid atstrpat_list0 COLON sigexp__AND_fundesc_opt
 	;

AND_fundesc_opt :
	 AND fundesc
	| %empty
 	;

sigexp__AND_fundesc_opt :
	 sigexp_sq AND_fundesc_opt
	| FCT strpat_sq ARROW sigexp__AND_fundesc_opt
	| atsigexp ARROW sigexp__AND_fundesc_opt
	| sigexp WHERE rea__AND_fundesc_opt
 	;

rea__AND_fundesc_opt :
	 VAL OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt__AND_fundesc_opt
	| FUN OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt__AND_fundesc_opt
	| CONSTRUCTOR OP_opt longvid EQUALS OP_opt longvid
						AND_rea_opt__AND_fundesc_opt
	| EXCEPTION OP_opt longvid EQUALS OP_opt longvid
						AND_rea_opt__AND_fundesc_opt
	| TYPE tyvarseq longtycon EQUALS ty AND_rea_opt__AND_fundesc_opt
	| STRUCTURE longstrid COLON_sigexp_opt EQUALS longstrid
						AND_rea_opt__AND_fundesc_opt
	| FUNCTOR longstrid COLON_sigexp_opt EQUALS longstrid
						AND_rea_opt__AND_fundesc_opt
	| SIGNATURE longsigid atstrpat_list0 EQUALS
					sigexp__AND_rea_opt__AND_fundesc_opt
 	;

AND_rea_opt__AND_fundesc_opt :
	 AND_fundesc_opt
	| AND rea__AND_fundesc_opt
 	;

sigexp__AND_rea_opt__AND_fundesc_opt :
	 appsigexp AND_rea_opt__AND_fundesc_opt
	;

 /* Components: Imports */

imp :
	 imp1
	| %empty
 	;

imp1 :
	 imp1_sq
	| imp1 imp1_sq %prec SEMICOLON
	| SEMICOLON
 	;

imp1_sq :
	 VAL valitem
	| FUN valitem
	| TYPE typitem
	| EQTYPE typitem
	| EQEQTYPE typitem
	| DATATYPE datitem
	| EXTTYPE extitem
	| CONSTRUCTOR econitem
	| EXCEPTION exitem
	| STRUCTURE stritem
	| SIGNATURE sigitem
	| FUNCTOR funitem
	| INFIX d_opt vid_list1
	| INFIXR d_opt vid_list1
	| NONFIX vid_list1
	;

 /* Components: Items */

valitem :
	 OP_opt vid AND_valitem_opt
	| OP_opt vid COLON ty AND_valitem_opt
 	;

AND_valitem_opt :
	 AND valitem
	| %empty
	;

typitem :
	 tycon AND_typitem_opt
	| tyvarseq1 tycon AND_typitem_opt
 	;

AND_typitem_opt :
	 AND typitem
	| %empty
	;

datitem :
	 tycon AND_datitem_opt
	| tycon EQUALS conitem AND_datitem_opt
	| tyvarseq1 tycon EQUALS conitem AND_datitem_opt
 	;

AND_datitem_opt :
	 AND datitem
	| %empty
	;

conitem :
	 OP_opt vid OF_ty_opt BAR_conitem_opt
 	;

BAR_conitem_opt :
	 BAR conitem
	| %empty
	;

extitem :
	 tycon AND_extitem_opt
	| tyvarseq1 tycon AND_extitem_opt
 	;

AND_extitem_opt :
	 AND extitem
	| %empty
	;

econitem :
	 OP_opt vid AND_econitem_opt
	| OP_opt vid OF_ty_opt COLON tyvarseq longtycon AND_econitem_opt
 	;

AND_econitem_opt :
	 AND econitem
	| %empty
	;

exitem :
	 OP_opt vid AND_exitem_opt
	| OP_opt vid OF ty AND_exitem_opt
 	;

AND_exitem_opt :
	 AND exitem
	| %empty
	;

stritem :
	 strid AND_stritem_opt
	| strid COLON sigexp__AND_stritem_opt
 	;

AND_stritem_opt :
	 AND stritem
	| %empty
 	;

sigexp__AND_stritem_opt :
	 sigexp_sq AND_stritem_opt
	| FCT strpat_sq ARROW sigexp__AND_stritem_opt
	| atsigexp ARROW sigexp__AND_stritem_opt
	| sigexp WHERE rea__AND_stritem_opt
 	;

rea__AND_stritem_opt :
	 VAL OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt__AND_stritem_opt
	| FUN OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt__AND_stritem_opt
	| CONSTRUCTOR OP_opt longvid EQUALS OP_opt longvid
						AND_rea_opt__AND_stritem_opt
	| EXCEPTION OP_opt longvid EQUALS OP_opt longvid
						AND_rea_opt__AND_stritem_opt
	| TYPE tyvarseq longtycon EQUALS ty AND_rea_opt__AND_stritem_opt
	| STRUCTURE longstrid COLON_sigexp_opt EQUALS longstrid
						AND_rea_opt__AND_stritem_opt
	| FUNCTOR longstrid COLON_sigexp_opt EQUALS longstrid
						AND_rea_opt__AND_stritem_opt
	| SIGNATURE longsigid atstrpat_list0 EQUALS
					sigexp__AND_rea_opt__AND_stritem_opt
 	;

AND_rea_opt__AND_stritem_opt :
	 AND_stritem_opt
	| AND rea__AND_stritem_opt
 	;

sigexp__AND_rea_opt__AND_stritem_opt :
	 appsigexp AND_rea_opt__AND_stritem_opt
	;

sigitem :
	 sigid AND_sigitem_opt
	| sigid atstrpat_list1 AND_sigitem_opt
 	;

AND_sigitem_opt :
	 AND sigitem
	| %empty
	;

funitem :
	 strid AND_funitem_opt
	| strid atstrpat_list0 COLON sigexp__AND_funitem_opt
 	;

AND_funitem_opt :
	 AND funitem
	| %empty
 	;

sigexp__AND_funitem_opt :
	 sigexp_sq AND_funitem_opt
	| FCT strpat_sq ARROW sigexp__AND_funitem_opt
	| atsigexp ARROW sigexp__AND_funitem_opt
	| sigexp WHERE rea__AND_funitem_opt
 	;

rea__AND_funitem_opt :
	 VAL OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt__AND_funitem_opt
	| FUN OP_opt longvid EQUALS OP_opt longvid
 AND_rea_opt__AND_funitem_opt
	| CONSTRUCTOR OP_opt longvid EQUALS OP_opt longvid
						AND_rea_opt__AND_funitem_opt
	| EXCEPTION OP_opt longvid EQUALS OP_opt longvid
						AND_rea_opt__AND_funitem_opt
	| TYPE tyvarseq longtycon EQUALS ty AND_rea_opt__AND_funitem_opt
	| STRUCTURE longstrid COLON_sigexp_opt EQUALS longstrid
						AND_rea_opt__AND_funitem_opt
	| FUNCTOR longstrid COLON_sigexp_opt EQUALS longstrid
						AND_rea_opt__AND_funitem_opt
	| SIGNATURE longsigid atstrpat_list0 EQUALS
					sigexp__AND_rea_opt__AND_funitem_opt
 	;

AND_rea_opt__AND_funitem_opt :
	 AND_funitem_opt
	| AND rea__AND_funitem_opt
 	;

sigexp__AND_rea_opt__AND_funitem_opt :
	 appsigexp AND_rea_opt__AND_funitem_opt
	;

 /* Components: Announcements */

ann0 :
	 ann1
	| %empty
 	;

ann1 :
	 IMPORT imp FROM STRING
	| IMPORT STRING
	| IMPORT PRIMITIVE imp FROM STRING
	| IMPORT PRIMITIVE STRING
	| ann1 ann1 %prec SEMICOLON
	| SEMICOLON
	;

 /* Components: Programs */

program :
	 dec_sq
	| exp
	| dec_sq SEMICOLON program_opt_sq
	| exp SEMICOLON program_opt_sq
 	;

program_opt :
	 program
	| %empty
 	;

program_opt_sq :
	 program_opt
	| SEMICOLON program_opt_sq
	;

 /* Components: Compilation units */

component :
	 ann0 program_opt
	 ;

%%

/*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 *   With some minor adaptions by Benedikt Grundmann <bgrund@ps.uni-sb.de>
 *   to be able to use it with aliceyacc.  If there are any errors they
 *   are most likely to be mine.
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2004
 *
 * Last change:
 *   $Date$ by $Author$
 *   $Revision$
 */
/*
 * Standard ML lexical analysis
 *
 * Definition, sections 2.1-2.5, 3.1
 *
 * Extensions and modifications:
 *   - more liberal constant prefixes (allow 0xw)
 *   - binary int and word constants (0b010, 0wb010)
 *   - allow underscores in numbers
 *   - longids have been moved to the context-free grammar,
 *     so the LONGID token is substituted by a DOT token
 *   - #[ keyword for vector expressions
 *   - FINALLY keyword
 *   - ASSERT keyword(s)
 *   - EXTTYPE and CONSTRUCTOR keywords for extensible datatypes
 *   - NON keyword added for negated patterns
 *   - WITHVAL and WITHFUN keywords for bindings inside pattern
 *   - LAZY and SPAWN keywords for futures
 *   - FCT keyword for functor expressions and signatures
 *   - ANY keyword for top signature
 *   - PACK and UNPACK keyword for first class structures
 *   - IMPORT and FROM keywords added
 *   - PRIMITIVE, OVERLOAD, EQEQTYPE, REFTYPE, and PERVASIVE keywords added
 *
 * Notes:
 *   Since all lexical classes must be disjoint:
 *   - There is no single class ID, use ALPHA|SYMBOL|STAR|EQUALS.
 *   - There is no class LAB, use ALPHA|SYMBOL|NUMERIC|DIGIT|STAR.
 *   - ID does not contain `=' and `*', those are EQUALS and STAR.
 *   - INT does not contain positive decimal integers without leading 0,
 *     and single DIGIT integers, those are in NUMERIC, DIGIT, and ZERO.
 *   - NUMERIC does not contain single digit numbers, those are in DIGIT.
 *   - DIGIT does not contain 0, that is ZERO.
 *
 *   The parser uses a global variable to recognise nested comments, so it is
 *   not reentrant.
 */

formatting   [ \t\n\v\f\r]+
letter       [A-Za-z]
symbol       [-!%&$#+/:<=>?@\\~`|*^]
digit        [0-9]
bindigit     [0-1]
hexdigit     [0-9a-fA-F]
xdigit       {digit}|"_"
xbindigit    {bindigit}|"_"
xhexdigit    {hexdigit}|"_"
digits       {xdigit}*{digit}{xdigit}*
bindigits    {xbindigit}*{bindigit}{xbindigit}*
hexdigits    {xhexdigit}*{hexdigit}{xhexdigit}*

posdecint    {digit}{xdigit}*
posbinint    "0b"{bindigits}
poshexint    "0x"{hexdigits}
negdecint    "~"{posdecint}
negbinint    "~"{posbinint}
neghexint    "~"{poshexint}
decint       {posdecint}|{negdecint}
binint       {posbinint}|{negbinint}
hexint       {poshexint}|{neghexint}
decword      "0w"{digits}
binword      "0"("wb"|"bw"){bindigits}
hexword      "0"("wx"|"xw"){hexdigits}

int          {decint}|{binint}|{hexint}
word         {decword}|{binword}|{hexword}
exp          [Ee]
real         ({decint}"."{digits}({exp}{decint})?)|({decint}{exp}{decint})

numericlab   [1-9]{digit}*
alphanumid   {letter}({letter}|{digit}|[_'])*
symbolicid   {symbol}+
id           {alphanumid}|{symbolicid}
tyvar        "'"({letter}|{digit}|[_'])*

printable    [^\x00-\x20"\x7f\\]
escape       "\\a"|"\\b"|"\\t"|"\\n"|"\\v"|"\\f"|"\\r"|("\\^"[@-_])|("\\"{digit}{3})|("\\u"{hexdigit}{4})|"\\\""|"\\\\"
gap          ("\\"{formatting}"\\")
stringchar   {printable}|" "|{escape}
string       "\""({stringchar}|{gap})*"\""
char         "#"{string};

%%

{formatting}	skip()

"#"		HASH
"#["		HASHBRACK
"("		LPAR
")"		RPAR
"*"		STAR
","		COMMA
"->"		ARROW
"."		DOT
"..."		DOTS
":"		COLON
":>"		COLONGREATER
";"		SEMICOLON
"="		EQUALS
"=>"		DARROW
"["		LBRACK
"]"		RBRACK
"_"		UNDERBAR
"{"		LBRACE
"|"		BAR
"}"		RBRACE

"__eqeqtype"	EQEQTYPE
"__overload"	OVERLOAD
"__pervasive"	PERVASIVE
"__primitive"	PRIMITIVE
"__reftype"	REFTYPE
"_file_"	FILE
"_line_"	LINE
"abstype"	ABSTYPE
"and"		AND
"andalso"	ANDALSO
"any"		ANY
"as"		AS
"assert"	ASSERT
"assert0"	ASSERT
"assert1"	ASSERT
"assert2"	ASSERT
"assert3"	ASSERT
"assert4"	ASSERT
"assert5"	ASSERT
"assert6"	ASSERT
"assert7"	ASSERT
"assert8"	ASSERT
"assert9"	ASSERT
"case"		CASE
"constructor"	CONSTRUCTOR
"datatype"	DATATYPE
"do"		DO
"else"		ELSE
"end"		END
"eqtype"	EQTYPE
"exception"	EXCEPTION
"exttype"	EXTTYPE
"fct"       	FCT
"finally"	FINALLY
"fn"		FN
"from"		FROM
"fun"		FUN
"functor"	FUNCTOR
"handle"	HANDLE
"if"		IF
"import"	IMPORT
"in"		IN
"include"	INCLUDE
"infix"		INFIX
"infixr"	INFIXR
"lazy"		LAZY
"let"		LET
"local"		LOCAL
"non"		NON
"nonfix"	NONFIX
"of"		OF
"op"		OP
"open"		OPEN
"orelse"	ORELSE
"pack"		PACK
"raise"		RAISE
"rec"		REC
"sharing"	SHARING
"sig"		SIG
"signature"	SIGNATURE
"spawn"		SPAWN
"struct"	STRUCT
"structure"	STRUCTURE
"then"		THEN
"type"		TYPE
"unpack"	UNPACK
"val"		VAL
"where"		WHERE
"while"		WHILE
"with"		WITH
"withfun"	WITHFUN
"withtype"	WITHTYPE
"withval"	WITHVAL

"0"		ZERO
[1-9]		DIGIT
{numericlab}	NUMERIC
{int}		INT
{word}		WORD
{real}		REAL
{string}	STRING
{char}		CHAR

{tyvar}		TYVAR
{id}		ALPHA


"(*"(?s:.)*?"*)" skip()


%%
