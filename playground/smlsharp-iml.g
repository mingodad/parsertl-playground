//From: https://github.com/smlsharp/smlsharp/blob/944e3e5d29b01400dc0b3412122aad4118f3471c/src/compiler/compilePhases/parser/main/iml.grm
/* a grammar for the raw symtax of IML.
	* @copyright (C) 2021 SML# Development Team.
	* @author Atsushi Ohori, Kiyoshi Yamatodani, Liu Bochao
	* @version $Id: iml.grm,v 1.69.6.8 2010/02/10 05:17:29 hiro-en Exp $

	* Ohori: 2007/11/11
	* WARNING: Large part of this file is copied to interface.grm.
	* I indicates those positons that are from iml.grm in interface.grm.
	* iml.grm is the original. If one change something there, he/she
	* must propagate the change here.
	* This is unsatisfactory situation. We will consider a better
	* organization later.

	* Ohori: 2012/10/9
	id, longid are systematically changed to symbol and longsymbol
	having location information.

	* Ohori: 2013/06/29
	Changed id to represent symbols.

	* Ohori: 2015/09/24
	Added SYMBOLICID and ALPHABETICID to restrict
	structure and functor ids to alphabetic.
*/

/*
Replaced right recursion by left recusrion on "topdecs, match".
*/

%token ABSTYPE
%token ALL
%token ALPHABETICID
%token AND
%token ANDALSO
%token ARROW
%token AS
%token ASC
%token ASTERISK
//%token AT
%token ATTRIBUTE
%token BAR
%token BEGIN
//%token BUILTIN
%token BY
%token CASE
%token CHAR
%token COLON
%token COMMA
%token COMMIT
%token CROSS
%token DARROW
%token DATATYPE
%token DEFAULT
%token DELETE
%token DESC
%token DISTINCT
%token DO
%token ELSE
%token END
%token EQ
%token EQTYPE
%token EQTYVAR
%token FREE_EQTYVAR
%token EXCEPTION
%token EXISTS
%token FALSE
%token FETCH
%token FIRST
%token FN
%token FOREACH
%token FROM
%token FUN
%token FUNCTOR
%token GROUP
%token HANDLE
%token HASH
%token HAVING
%token IF
%token IMPORT
%token INCLUDE
%token IN
%token INFIX
%token INFIXR
%token INNER
%token INSERT
%token INT
%token INTERFACE
%token INTLAB
%token INTO
%token IS
%token JOIN
%token JOINOP
%token EXTENDOP
%token UPDATEOP
%token DYNAMIC
%token DYNAMICNULL
%token DYNAMICTOP
%token DYNAMICCASE
//%token DYNAMICVIEW
//%token DYNAMICIS
%token LBRACE
%token LBRACKET
%token LET
%token LIMIT
%token LOCAL
%token LPAREN
%token NATURAL
//%token NEWLINE
%token NEXT
%token NONFIX
%token NOT
%token NULL
%token OF
%token OFFSET
%token ON
%token ONLY
%token OP
%token OPAQUE
%token OPEN
%token OR
%token ORDER
%token ORELSE
%token PERIOD
%token PERIODS
%token POLYREC
%token PREFIXEDLABEL
%token RAISE
%token RBRACE
%token RBRACKET
%token REAL
%token REC
//%token REQUIRE
%token ROLLBACK
%token ROW
%token ROWS
%token RPAREN
%token SELECT
%token SELECTOR
%token SEMICOLON
%token SET
%token SHARING
%token SIG
%token SIGNATURE
%token SIZEOF
%token REIFYTY
//%token SPECIAL
%token SQL
//%token SQLEVAL
//%token SQLEXEC
%token SQLSERVER
%token STRING
%token STRUCT
%token STRUCTURE
%token SYMBOLICID
%token THEN
%token TRUE
%token TYPE
%token TYVAR
%token FREE_TYVAR
%token UNDERBAR
%token UNKNOWN
%token UPDATE
%token USE
%token USE_Q
%token VAL
%token VALUES
%token WHERE
%token WHILE
%token WITH
%token WITHTYPE
%token WORD

%right ARROW
%right AND
%right DARROW
%nonassoc BAR
%left DO
%left HASH
%left ELSE
%left RAISE
%right HANDLE
%left ORELSE
%left ANDALSO
%right AS
%left COLON

%start start

%%

start :
	unit
	| expOrSQL
	;

/****************** constant ***************************/
int :
	INT
	| INTLAB
	;

constant :
	int
	| WORD
	| STRING
	| REAL
	| CHAR
	;
/* end of constant */

/*** raw id ***/

alphabetic_id :
	ALPHABETICID
	| ALL
	| ASC
	| BEGIN
	| BY
	| COMMIT
	| CROSS
	| DEFAULT
	| DELETE
	| DESC
	| DISTINCT
	| EXISTS
	| FALSE
	| FETCH
	| FIRST
	| FROM
	| GROUP
	| HAVING
	| INNER
	| INSERT
	| INTO
	| IS
	| JOIN
	| LIMIT
	| NATURAL
	| NEXT
	| NOT
	| NULL
	| OFFSET
	| ON
	| ONLY
	| OR
	| ORDER
	| ROLLBACK
	| ROW
	| ROWS
	| SELECT
	| SET
	| TRUE
	| UNKNOWN
	| UPDATE
	| VALUES
	;

id_noEQSTAR :
	alphabetic_id
	| SYMBOLICID
	;

id_noEQ :
	id_noEQSTAR
	| ASTERISK
	;

id :
	id_noEQ
	| EQ
	;

id_noSQL :
	ALPHABETICID
	| SYMBOLICID
	| EQ
	| ASTERISK
	;

longid :
	id
	| alphabetic_id PERIOD longid
	;

/*
longtyconid :
	id
	| id PERIOD longtyconid
	;
*/

longid_noSQL :
	id_noSQL
	| alphabetic_id PERIOD longid
	;

tylongid :
	id_noEQSTAR
	| alphabetic_id PERIOD longid
	;

patlongid :
	id_noEQ
	| alphabetic_id PERIOD longid
	;

/*** symbols

	expid :
		longid
		;

	symbol_noEQSTAR :
		id_noEQSTAR
		;

	symbol :
		id
		;

	longsymbol :
		longid
		;

	longtycon :
		longtyconid
		;

	explongsymbol :
		expid
		;

	explongsymbol_noSQL :
		expid_noSQL
		;

	tylongsymbol :
		tylongid
		;

	patlongsymbol :
		patlongid
		;

	symbolseq :
		symbol
		| symbol symbolseq
		;

	longsymbolseq :
		longsymbol
		| longsymbol longsymbolseq
		;
***/

idseq :
	id
	| id idseq
	;

longidseq :
	longid
	| longid longidseq
	;

/*** expressions ***/

atexp_noVAR :
	constant
	| JOINOP LPAREN exp COMMA exp RPAREN
	| EXTENDOP LPAREN exp COMMA exp RPAREN
	| UPDATEOP LPAREN exp COMMA exp RPAREN
	| OP longid
	| SIZEOF LPAREN ty RPAREN
	| LBRACE exprow RBRACE
	| LBRACE RBRACE
	| LPAREN RPAREN
	| SELECTOR
	| HASH label
	| LBRACKET RBRACKET
	| LBRACKET expOrSQL RBRACKET
	| LBRACKET expseq_comma RBRACKET
	| LET decseq_semicolon IN expseq_semicolon END
	| REIFYTY LPAREN ty RPAREN
	| SQL LPAREN sqlparen RPAREN
	| LPAREN expseq_comma RPAREN
	| LPAREN expOrSQL SEMICOLON expseq_semicolon RPAREN
	| LPAREN expOrSQL RPAREN
	| FOREACH id IN exp WHERE exp WITH pat DO exp WHILE exp END
	| FOREACH id IN exp WITH pat DO exp WHILE exp END
	;

atexp :
	atexp_noVAR
	| longid
	;

label :
	id
	| INTLAB
	| STRING
	| PREFIXEDLABEL
	;

/* equal or more than 1 */
exprow :
	label EQ exp
	| exprow COMMA label EQ exp
	;

/* equal or more than 2 exps */
expseq_comma :
	exp COMMA exp
	| expseq_comma COMMA exp
	;

/* equal or more than 1 exps */
expseq_semicolon :
	expOrSQL
	| expseq_semicolon SEMICOLON expOrSQL
	;

appexp :
	atexp
	| appexp atexp
/*
	| appexp HASH atexp
*/
	| appexp HASH LBRACE atexp RBRACE
	| appexp HASH LBRACE exprow RBRACE
	| appexp HASH LBRACE RBRACE
	| appexp HASH LPAREN expseq_comma RPAREN
	;

exp :
	appexp
	| exp COLON ty
	| exp COLON IMPORT ffity
	| IMPORT STRING COLON ffity
	| exp ANDALSO exp
	| exp ORELSE exp
	| exp HANDLE match
	| RAISE exp
	| IF exp THEN exp ELSE exp
	| WHILE exp DO exp
	| CASE exp OF match
	| FN match
	| SQLSERVER COLON ty
	| SQLSERVER appexp COLON ty
	| DYNAMIC exp AS ty
	| DYNAMIC exp OF ty
	//| DYNAMICVIEW exp AS ty
	| DYNAMICNULL AS ty
	| DYNAMICTOP AS ty
	| DYNAMICCASE exp OF dynmatch
	;

expOrSQL :
	exp
	| sql
	;

/*
match :
	mrule
	| match BAR mrule
	;

mrule :
	pat DARROW exp
	;

match :
	mrule
	| mrulebar match
	;

mrule :
	pat DARROW exp
	;

mrulebar :
	pat DARROW exp BAR
	;
*/
/*
It seems that the core ML's "|" has inherent problem, which coincides
with my experience. I have been bothered by the "|" in combination
with case, fn, and handle.
*/

match :
	pat DARROW exp
	| pat DARROW exp BAR match
	;

dynmatch :
	exist_quantifier pat DARROW exp
	| exist_quantifier pat DARROW exp BAR dynmatch
	| pat DARROW exp
	| pat DARROW exp BAR dynmatch
	;

exist_quantifier :
	LBRACE kinded_tyvar RBRACE
	| LBRACE kinded_tyvarseq_comma RBRACE
	;

/* end of expression */

/*************************** sql ********************************/

sql :
	SQL sqlpat DARROW sqlcon
	| SQL sqlpat DARROW PERIODS LPAREN expOrSQL RPAREN
	| SQL sqlpat DARROW LPAREN sqlconseq RPAREN
	| SQL sqlcon
	| SQL sqlkwexp
	| FN pat DARROW sql
	;

sqlopt :
	/*empty*/
	| SQL
	;

sqlcon :
	sqlSelectQuery
	| sqlSelectClause
	| sqlFromClause
	| sqlWhereClause
	| sqlOrderbyClause
	| sqlOffsetClause
	| sqlLimitClause
	| sqlInsertCommand
	| sqlUpdateCommand
	| sqlDeleteCommand
	| BEGIN
	| COMMIT
	| ROLLBACK
	;

sqlconseq :
	sqlcon
	| PERIODS LPAREN expOrSQL RPAREN
	| sqlcon SEMICOLON sqlconseq
	| PERIODS LPAREN expOrSQL RPAREN SEMICOLON sqlconseq
	;

sqlSelectClause :
	SELECT sqlDistinct sqlSelectList
	;

sqlSelectClauseExp :
	SELECT PERIODS LPAREN expOrSQL RPAREN
	| sqlSelectClause
	;

sqlSelectQuery :
	sqlSelectClauseExp sqlFromClauseExp sqlWhereClauseOpt
		sqlGroupbyClauseOpt sqlOrderbyClauseOpt
		sqlLimitOrOffsetClauseOpt
	| SELECT PERIODS LPAREN expOrSQL RPAREN
	;

sqlFromClause :
	FROM sqljoinseq
	;

sqlFromClauseExp :
	FROM PERIODS LPAREN expOrSQL RPAREN
	| sqlFromClause
	;

sqlWhereClause :
	WHERE sqlexp
	;

sqlWhereClauseExp :
	WHERE PERIODS LPAREN expOrSQL RPAREN
	| sqlWhereClause
	;

sqlWhereClauseOpt :
	/*empty*/
	| sqlWhereClauseExp
	;

sqlGroupbyClauseOpt :
	/*empty*/
	| GROUP BY sqlexpseq sqlHavingClauseOpt
	;

sqlHavingClauseOpt :
	/*empty*/
	| HAVING sqlexp
	;

sqlOrderbyClause :
	ORDER BY sqlOrderbyKeyseq
	;

sqlOrderbyClauseOpt :
	/*empty*/
	| ORDER BY PERIODS LPAREN expOrSQL RPAREN
	| sqlOrderbyClause
	;

sqlLimitClause :
	LIMIT sqlexp
	| LIMIT ALL
	| LIMIT sqlexp OFFSET sqlexp
	| LIMIT ALL OFFSET sqlexp
	;

sqlOffsetClause :
	OFFSET sqlatexp sqlRowRows
	| OFFSET sqlatexp sqlRowRows FETCH sqlFirstNext sqlatexp sqlRowRows ONLY
	| OFFSET sqlatexp sqlRowRows FETCH sqlFirstNext sqlRowRows ONLY
	;

sqlLimitOrOffsetClauseOpt :
	/*empty*/
	| LIMIT PERIODS LPAREN expOrSQL RPAREN
	| sqlLimitClause
	| OFFSET PERIODS LPAREN expOrSQL RPAREN
	| sqlOffsetClause
	;

sqlFirstNext :
	FIRST
	| NEXT
	;

sqlRowRows :
	ROW
	| ROWS
	;

sqlDistinct :
	/*empty*/
	| DISTINCT
	| ALL
	;

sqlSelectList :
	sqlSelectItem
	| sqlSelectItem COMMA sqlSelectList
	;

sqlSelectItem :
	sqlexp
	| sqlexp AS label
	;

sqlOrderbyKeyseq :
	sqlOrderbyKey
	| sqlOrderbyKey COMMA sqlOrderbyKeyseq
	;

sqlOrderbyKey :
	sqlexp
	| sqlexp ASC
	| sqlexp DESC
	;

sqljoinseq :
	sqljoin
	| sqljoin COMMA sqljoinseq
	;

sqljoin :
	sqltableAs
	| sqljoin JOIN sqltableAs ON sqlexp
	| sqljoin INNER JOIN sqltableAs ON sqlexp
	| sqljoin CROSS JOIN sqltableAs
	| sqljoin NATURAL JOIN sqltableAs
	;

sqltableAs :
	sqltable AS label
	| sqltable
	;

sqltable :
	sqltableid
	| LPAREN sqljoin RPAREN
	| LPAREN sqlopt sqlSelectQuery RPAREN
	;

/*
sqltableid :
	HASH id PERIOD label
	;
*/
sqltableid :
	SELECTOR PERIOD label
	;

sqlInsertCommand :
	INSERT INTO sqltableid LPAREN labelseq RPAREN sqlInsertValues
	| INSERT INTO sqltableid sqlSelectQuery
	;

labelseq :
	label
	| label COMMA labelseq
	;

sqlInsertValues :
	VALUES sqlvalues
	| VALUES OP longid
	| VALUES id_noSQL
	| sqlSelectQuery
	;

sqlvalues :
	LPAREN sqlexpOrDefaultseq RPAREN
	| LPAREN sqlexpOrDefaultseq RPAREN COMMA sqlvalues
	;

sqlexpOrDefaultseq :
	sqlexpOrDefault
	| sqlexpOrDefault COMMA sqlexpOrDefaultseq
	;

sqlexpOrDefault :
	sqlexp
	| DEFAULT
	;

sqlUpdateCommand :
	UPDATE sqltableid SET sqlsetseq sqlWhereClauseOpt
	;

sqlsetseq :
	label EQ sqlexp
	| label EQ sqlexp COMMA sqlsetseq
	;

sqlDeleteCommand :
	DELETE FROM sqltableid sqlWhereClauseOpt
	;

sqlexpseq :
	sqlexp
	| sqlexp COMMA sqlexpseq
	;

sqltopexpseq :
	sqltopexp
	| sqltopexp COMMA sqltopexpseq
	;

sqltopexp :
	sqlandexp
	| sqltopexp OR sqlandexp
	;

sqlandexp :
	sqlnotexp
	| sqlandexp AND sqlnotexp
	;

sqlnotexp :
	sqlappexp
	| NOT sqlappexp
	;

sqlappexp :
	sqlatexp
	| sqlappexp IS NULL
	| sqlappexp IS NOT NULL
	| sqlappexp IS TRUE
	| sqlappexp IS NOT TRUE
	| sqlappexp IS FALSE
	| sqlappexp IS NOT FALSE
	| sqlappexp IS UNKNOWN
	| sqlappexp IS NOT UNKNOWN
	| sqlappexp sqlatexp
	;

sqlatexp :
	constant
	| NULL
	| TRUE
	| FALSE
	| LPAREN RPAREN
	| OP longid
	| id_noSQL
	| SELECTOR PERIOD label

/*
	| HASH label PERIOD label

*/
	| HASH PERIOD label
	| sqlopt sqlkwexp
	| LPAREN sqltopexp RPAREN
	| LPAREN sqlopt sqlSelectQuery RPAREN
	| LPAREN PERIODS expOrSQL RPAREN
	| LPAREN sqltopexp COMMA sqltopexpseq RPAREN
	;

sqlkwexp :
	EXISTS LPAREN sqlopt sqlSelectQuery RPAREN
	;

sqlexp :
	sqlnotexp
	| sqlexp OR sqlnotexp
	;

sqlparen :
	sqlcon
	| SQL sqlcon
	| sqlcon SEMICOLON sqlconseq
	| PERIODS LPAREN expOrSQL RPAREN SEMICOLON sqlconseq
	| sqltopexp
	;

sqlpat :
	sqlatpat
	| sqlpat COLON ty
	| sqlpat AS pat
	;

sqlatpat :
	atpat_noID_noPAREN
	| longid_noSQL
	;

/*************************** dec ********************************/
/*decs : dec
	| dec decs */
decseq_semicolon :
	/*empty*/
	| SEMICOLON decseq_semicolon
	| dec decseq_semicolon
	| LOCAL decseq_semicolon IN decseq_semicolon END decseq_semicolon
	;

/*
	Ohori: VAL, VAL REC and FUN now take kinded_tyvarseq
	instead of tyvar_seq.
	2007/11/11
*/

/* 160 */

dec :
	VAL valbind
	| VAL kinded_tyvarseq valbind
	| VAL REC valbind
	| VAL REC kinded_tyvarseq valbind

	/* polymorphic recursion */
	| VAL POLYREC pvalbind
	| FUN fvalbind
	| FUN kinded_tyvarseq fvalbind
	| TYPE typbind
	| DATATYPE datbind
	| DATATYPE datbind WITHTYPE typbind
	| DATATYPE tycon EQ DATATYPE longid
	| ABSTYPE datbind WITH decseq_semicolon END
	| ABSTYPE datbind WITHTYPE typbind
	WITH decseq_semicolon END
	| EXCEPTION exbinds

/*
	| LOCAL decseq_semicolon IN decseq_semicolon END

*/
	| OPEN longidseq
	| INFIX int idseq
	| INFIXR int idseq

/* infix/infixr without number is added. 2004.3.21. Ohori */
	| INFIX idseq
	| INFIXR idseq
	| NONFIX idseq
	;
/*
/* deprecated syntax
	| VAL EXTERNAL ffiattropt id EQ appexp COLON old_ffiFunty

*/

/*
	In this version, we ignore kind constraint in type bind.
	type ('a, 'b#{a:'a}) foo = 'b -> 'a
	is interpreted as
	type ('a, 'b) foo = 'b -> 'a
*/
typbind :
	tycon EQ ty
	| tyvarseq tycon EQ ty
	| tycon EQ ty AND typbind
	| tyvarseq tycon EQ ty AND typbind
	;

datbind :
	tycon EQ combind
	| tyvarseq tycon EQ combind
	| tycon EQ combind AND datbind
	| tyvarseq tycon EQ combind AND datbind
	;

combind :
	condec
	| condec BAR combind
	;

condec :
	tycon
	| OP tycon
	| tycon OF ty
	| OP tycon OF ty
	;

exbinds :
	exbind
	| exbind AND exbinds
	;

exbind :
	exndec
	| id EQ longid
	| id EQ OP longid
	| OP id EQ longid
	| OP id EQ OP longid
	;

exndec :
	tycon
	| OP tycon
	| tycon OF ty
	| OP tycon OF ty
	;

/* 200 */

tyvar :
	TYVAR
	| EQTYVAR
	;

free_tyvar :
	FREE_TYVAR
	| FREE_EQTYVAR
	;

tyvarseq :
	tyvar
	| LPAREN tyvar RPAREN
	| LPAREN tyvarseq_comma RPAREN
	;

tyvarseq_comma :
	tyvar COMMA tyvar
	| tyvar COMMA tyvarseq_comma
	;


valbind :
	pat EQ expOrSQL
	| pat EQ expOrSQL AND valbind
	;

pvalbind :
	id COLON poly_ty EQ expOrSQL
	| id COLON poly_ty EQ expOrSQL AND pvalbind
	;

fvalbind :
	frules
	| frules AND fvalbind
	;

frules :
	frule
	| frule BAR frules
	;

frule :
	apppat EQ expOrSQL
	| apppat COLON ty EQ expOrSQL
	;

/***************** pattern ***********************/

atpat_noID_noPAREN :
	UNDERBAR
	| OP patlongid
	| constant
	| LBRACE RBRACE
	| LBRACE fields RBRACE
	| LBRACKET RBRACKET
	| LBRACKET pat RBRACKET
	| LBRACKET patseq_comma RBRACKET
	;

atpat :
	atpat_noID_noPAREN
	| patlongid
	| LPAREN RPAREN
	| LPAREN patseq_comma RPAREN
	| LPAREN pat RPAREN
	;

apppat :
	atpat
	| apppat atpat
	;

pat :
	apppat

	/* Even if apppat has only single pattern, it is encupslated
	* into a PATAPPLY, in order to check invalid use of infix
	* identifier in the elaboration phase. */
	| pat COLON ty
	| pat AS pat
	;

optty :
	COLON ty
	| /*empty*/
	;

fields :
	label EQ pat
	| id optty optaspat
	| PERIODS
	| label EQ pat COMMA fields
	| id optty optaspat COMMA fields
	;

optaspat :
	/*empty*/
	| AS pat
	;

patseq_comma :
	pat COMMA pat
	| patseq_comma COMMA pat
	;

/* end of pattern */

/**************** types *********************/
tycon :
	id_noEQSTAR
	| EQ
	;

tyrow :
	label COLON ty
	| label COLON ty COMMA tyrow
	;

tyrow_flex :
	label COLON ty
	| label COLON ty COMMA tyrow_flex
	| PERIODS
	;

ty0 :
	UNDERBAR
	| tyvar
	| kinded_free_tyvar
	| LBRACE tyrow_flex RBRACE
	| LBRACE RBRACE
	| LPAREN ty RPAREN
	;

ty1 :
	ty0
	| tyseq tylongid
	;

tyseq :
	ty1
	| LPAREN tyseq_comma RPAREN
	| /*empty*/
	;

tyseq_comma :
	ty COMMA ty
	| ty COMMA tyseq_comma
	;

tytuple :
	ty1 ASTERISK tytuple
	| ty1 ASTERISK ty1
	;

ty :
	ty ARROW ty
	| tytuple
	| ty1
	;

/*
	Ohori; poly_ty and the related definitions are added for rank1 type
	specification
	2007/11/11
*/
poly_tyrow :
	label COLON poly_ty
	| label COLON poly_ty COMMA poly_tyrow
	| label COLON poly_ty COMMA tyrow
	| label COLON ty COMMA poly_tyrow
	;

poly_ty1 :
	LBRACE poly_tyrow RBRACE
	| LPAREN poly_ty RPAREN
	| LBRACKET kinded_tyvarseq_without_paren PERIOD ty RBRACKET
	| LBRACKET kinded_tyvarseq_without_paren PERIOD poly_ty RBRACKET
	;

poly_tytuple :
	poly_ty1 ASTERISK poly_tytuple
	| poly_ty1 ASTERISK tytuple
	| poly_ty1 ASTERISK poly_ty1
	| poly_ty1 ASTERISK ty1
	| ty1 ASTERISK poly_tytuple
	| ty1 ASTERISK poly_ty1
	;

poly_ty :
	ty ARROW poly_ty
	| poly_tytuple
	| poly_ty1
	;

kindSeq :
	HASH LBRACE RBRACE
	| HASH LBRACE tyrow RBRACE
	| SELECTOR
	| SELECTOR kindSeq
/*
	| HASH ALPHABETICID
	| HASH ALPHABETICID kindSeq
*/
	;

kinded_tyvar :
	tyvar
	| tyvar kindSeq
	;

kinded_free_tyvar :
	free_tyvar
	| free_tyvar kindSeq
	;

kinded_tyvarseq :
	kinded_tyvar
	| LPAREN kinded_tyvar RPAREN
	| LPAREN kinded_tyvarseq_comma RPAREN
	;

kinded_tyvarseq_comma :
	kinded_tyvar COMMA kinded_tyvar
	| kinded_tyvar COMMA kinded_tyvarseq_comma
	;

kinded_tyvarseq_without_paren :
	kinded_tyvar
	| kinded_tyvar COMMA kinded_tyvarseq_without_paren
	;

/* kinded tyvar end */

/**************** end of types *********************/

/*********** foreign function interface *************/

/* FFI type representation */

ffityrow :
	label COLON ffity
	| label COLON ffity COMMA ffityrow
	;

ffityseq :
	ffity COMMA ffity
	| ffity COMMA ffityseq
	;

ffiVarArgs :
	/*empty*/
	| ffity
	| ffity COMMA ffiVarArgs
	;

ffity_COMMA :
	ffity COMMA
	;

ffityseq_COMMA :
	ffity COMMA ffity COMMA
	| ffity COMMA ffityseq_COMMA
	;

ffiArgs :
	ffiAtty
	| LPAREN ffityseq RPAREN
	| LPAREN ffity_COMMA PERIODS LPAREN ffiVarArgs RPAREN RPAREN
	| LPAREN ffityseq_COMMA PERIODS LPAREN ffiVarArgs RPAREN RPAREN
	;

ffiContyArg :
	/*empty*/
	| ffiAtty
	| LPAREN ffityseq RPAREN
	;

ffiAtty :
	LPAREN ffity RPAREN
	| tyvar
	| ffiContyArg tylongid
	| LBRACE ffityrow RBRACE
	| LBRACE RBRACE
	;

ffitupleseq :
	ffiAtty ASTERISK ffiAtty
	| ffiAtty ASTERISK ffitupleseq
	;

ffiTupleTy :
	ffitupleseq
	;

ffiFunArg :
	LPAREN RPAREN
	| ffiArgs
	| ffiTupleTy
	;

ffiFunRet :
	LPAREN RPAREN
	| ffity
	| LPAREN ffityseq RPAREN
	;

ffiFunty :
	ffiFunArg ARROW ffiFunRet
	| ffiattr ffiFunArg ARROW ffiFunRet
	;

ffiattrseq :
	ALPHABETICID
	| ALPHABETICID COMMA ffiattrseq
	;

ffiattr :
	ATTRIBUTE LPAREN LPAREN ffiattrseq RPAREN RPAREN
	;

ffity :
	ffiAtty
	| ffiFunty
	| ffiTupleTy
	;

/*
/* deperecated syntax
old_ffiContyArg :
	| old_ffiAtty
	| LPAREN old_ffityseq RPAREN
	,

old_ffiAtty :
	LPAREN old_ffity RPAREN
	| old_ffiContyArg tyid
	;

old_ffituple :
	old_ffiAtty ASTERISK old_ffiAtty
	| old_ffiAtty ASTERISK old_ffituple
	;

old_ffityseq :
	old_ffity COMMA old_ffity
	| old_ffity COMMA old_ffityseq
	;

old_ffityArg :
	| old_ffity
	| old_ffityseq
	;

old_ffiFunty :
	LBRACE old_ffityArg RBRACE ARROW old_ffity
	;

old_ffity :
	old_ffiAtty
	| old_ffiFunty
	| old_ffituple
	;
*/

/**************** structure and signature************/

/*----strexp---*/
strexpbasic :
	STRUCT strdecseq_semicolon END
	| longid
	| id LPAREN strexp RPAREN
	| id LPAREN strdecseq_semicolon RPAREN
	| LET strdecseq_semicolon IN strexp END
	;

strexp :
	strexpbasic
	| strexp COLON sigexp
	| strexp OPAQUE sigexp
	;

strexpand :
	strexpbasic AND
	| strexp COLON sigexpand
	| strexp OPAQUE sigexpand
	;

/*-------------*/

strdecseq_semicolon :
	strdec strdecseq_semicolon
	| SEMICOLON strdecseq_semicolon
	| /*empty*/
	;

strdec :
	dec
	| STRUCTURE strbindseq
	| LOCAL strdecseq_semicolon IN strdecseq_semicolon END
	;

/*-----strbind-----*/
strbind :
	alphabetic_id EQ strexp
	| alphabetic_id COLON sigexp EQ strexp
	| alphabetic_id OPAQUE sigexp EQ strexp
	;

strbindand :
	alphabetic_id EQ strexpand
	| alphabetic_id COLON sigexp EQ strexpand
	| alphabetic_id OPAQUE sigexp EQ strexpand
	;

strbindseq :
	strbind
	| strbindand strbindseq
	/*TEST*/
	;

/*---sigexp-----*/
sigexpbasic :
	SIG spec END
	| alphabetic_id
	;

sigexpwhere :
	sigexp WHERE TYPE tyvarseq longid EQ ty
	| sigexp WHERE TYPE longid EQ ty
	| sigexpwhere AND TYPE tyvarseq longid EQ ty
	| sigexpwhere AND TYPE longid EQ ty
	;

sigexp :
	sigexpbasic
	| sigexpwhere
	;

sigexpand :
	sigexpwhere AND
	| sigexpbasic AND
	;

/*---sigexp-----*/

sigbind :
	alphabetic_id EQ sigexp
	| alphabetic_id EQ sigexpand sigbind
	;

/***********************specifications******************************/

longtyconeqrow :
	longid EQ longid
	| longid EQ longtyconeqrow
	;

longideqrow :
	longid EQ longid
	| longid EQ longid EQ longid
	| longid EQ longid EQ longideqrow
	;

spec :
	spec atomicspec
	| spec SHARING TYPE longtyconeqrow
	| spec SHARING longideqrow
	| spec SEMICOLON
	| /*empty*/
	;

atomicspec :
	VAL valdesc
	| TYPE typdesc
	| TYPE typbind
	| EQTYPE typdesc
	| DATATYPE datdesc
	| DATATYPE tycon EQ DATATYPE longid
	| EXCEPTION exdesc
	| STRUCTURE strdesc
	| INCLUDE SIG spec END
	| INCLUDE sigexpwhere
	| INCLUDE sigidseq
	;

sigidseq :
	id
	| id sigidseq
	;

/*
	Ohori: valdesc now take poly_ty
	2007/11/11
*/
valdesc :
	id COLON poly_ty
	| id COLON ty
	| id COLON poly_ty AND valdesc
	| id COLON ty AND valdesc
	;

/* 401 */

typdesc :
	tyvarseq tycon
	| tycon
	| tyvarseq tycon AND typdesc
	| tycon AND typdesc
	;

datdesc :
	tycon EQ condesc
	| tyvarseq tycon EQ condesc
	| tycon EQ condesc AND datdesc
	| tyvarseq tycon EQ condesc AND datdesc
	;

condesc :
	id
	| id OF ty
	| id BAR condesc
	| id OF ty BAR condesc
	;

exdesc :
	id
	| id OF ty
	| id AND exdesc
	| id OF ty AND exdesc
	;

strdesc :
	id COLON sigexp
	| id COLON sigexpand strdesc
	;

funbindseq :
	funbind
	| funbindand funbindseq
	;

funbind :
	id LPAREN id COLON sigexp RPAREN EQ strexp
	| id LPAREN id COLON sigexp RPAREN COLON sigexp EQ strexp
	| id LPAREN id COLON sigexp RPAREN OPAQUE sigexp EQ strexp
	| id LPAREN spec RPAREN EQ strexp
	| id LPAREN spec RPAREN COLON sigexp EQ strexp
	| id LPAREN spec RPAREN OPAQUE sigexp EQ strexp
	;

funbindand :
	id LPAREN id COLON sigexp RPAREN EQ strexpand
	| id LPAREN id COLON sigexp RPAREN COLON sigexp EQ strexpand
	| id LPAREN id COLON sigexp RPAREN OPAQUE sigexp EQ strexpand
	| id LPAREN spec RPAREN EQ strexpand
	| id LPAREN spec RPAREN COLON sigexp EQ strexpand
	| id LPAREN spec RPAREN OPAQUE sigexp EQ strexpand
	;

/*****************************top level declarations**************************/

topdecs :
	topdec
	| topdecs topdec
	;

topdec :
	strdec
	| SIGNATURE sigbind
	| FUNCTOR funbindseq
	;

useFile :
	USE STRING
	| USE_Q STRING
	;

tops :
	topdecs
	| useFile
	| topdecs useFile tops
	| useFile tops
	;

interface :
	/*empty*/
	| INTERFACE STRING
	;

unit :
	interface
	| interface tops
	;

%%

underscore "_"
//alpha [A-Za-z\127-\255]
alpha [A-Za-z]
digit [0-9]
xdigit [0-9a-fA-F]
alnum ({alpha}|{digit}|{underscore})
tyvar ("'"({alnum}({alnum}|"'")*)?)
eqtyvar ("''"({alnum}|"'")*)
id ({alpha}({alnum}|"'")*)
ws ("\012"|[\t\ ])
eol ("\013\010"|"\010"|"\013")
symid ([-!%&$#+/:<=>?@\\~`^|*]+)
int0 (0{digit}*)
int ([1-9]{digit}*)
prefixedlabel {int}"_"({id}|{symid})

num [0-9]+
frac "."{num}
exp [eE](~?){num}
real (~?)(({num}{frac}?{exp})|({num}{frac}{exp}?))

%%

{ws}+ skip()
{eol} skip()
"(*"(?s:.)*?"*)"	skip()

"__attribute__"  ATTRIBUTE
//"_builtin"  BUILTIN
"_foreach"  FOREACH
"_import"  IMPORT
"_interface"  INTERFACE
"_join"  JOINOP
"_extend"  EXTENDOP
"_update"  UPDATEOP
"_dynamic"  DYNAMIC
"_dynamiccase"  DYNAMICCASE
"_dynamicnull"  DYNAMICNULL
"_dynamicvoid"  DYNAMICTOP
"_polyrec"  POLYREC
//"_require"  REQUIRE
"_sizeof"  SIZEOF
"_sql"  SQL
//"_sqleval"  SQLEVAL
//"_sqlexec"  SQLEXEC
"_sqlserver"  SQLSERVER
"_use"  USE_Q
"_sizeof"  SIZEOF
"_reifyTy"  REIFYTY

"abstype"  ABSTYPE
"all"  ALL
"and"  AND
"andalso"  ANDALSO
"as"  AS
"asc"  ASC
"begin"  BEGIN
"by"  BY
"case"  CASE
"commit"  COMMIT
"cross"  CROSS
"datatype"  DATATYPE
"default"  DEFAULT
"delete"  DELETE
"desc"  DESC
"distinct"  DISTINCT
"do"  DO
"else"  ELSE
"end"  END
"eqtype"  EQTYPE
"exception"  EXCEPTION
"exists"  EXISTS
"false"  FALSE
"fetch"  FETCH
"first"  FIRST
"fn"  FN
"from"  FROM
"fun"  FUN
"functor"  FUNCTOR
"group"  GROUP
"handle"  HANDLE
"having"  HAVING
"if"  IF
"in"  IN
"include"  INCLUDE
"infix"  INFIX
"infixr"  INFIXR
"inner"  INNER
"insert"  INSERT
"into"  INTO
"is"  IS
"join"  JOIN
"let"  LET
"limit"  LIMIT
"local"  LOCAL
"natural"  NATURAL
"next"  NEXT
"nonfix"  NONFIX
"not"  NOT
"null"  NULL
"of"  OF
"offset"  OFFSET
"on"  ON
"only"  ONLY
"op"  OP
"open"  OPEN
"or"  OR
"order"  ORDER
"orelse"  ORELSE
"raise"  RAISE
"rec"  REC
"rollback"  ROLLBACK
"row"  ROW
"rows"  ROWS
"select"  SELECT
"set"  SET
"sharing"  SHARING
"sig" SIG
"signature"  SIGNATURE
"struct"  STRUCT
"structure"  STRUCTURE
"then"  THEN
"true"  TRUE
"type"  TYPE
"unknown"  UNKNOWN
"update"  UPDATE
"use"  USE
"val"  VAL
"values"  VALUES
"where"  WHERE
"while"  WHILE
"with"  WITH
"withtype"  WITHTYPE
":>"  OPAQUE
"*"  ASTERISK
"#"  HASH
"("  LPAREN
")"  RPAREN
","  COMMA
"->"  ARROW
"."  PERIOD
"..."  PERIODS
":"  COLON
";"  SEMICOLON
"="  EQ
"=>"  DARROW
"["  LBRACKET
"]"  RBRACKET
"_"  UNDERBAR
"{"  LBRACE
"|"  BAR
"}"  RBRACE
"''_"({alnum}|"'")*  FREE_EQTYVAR
"'_"({alnum}|"'")*  FREE_TYVAR
{eqtyvar}  EQTYVAR
{tyvar}  TYVAR
{id}  ALPHABETICID
{symid}  SYMBOLICID
{prefixedlabel}  PREFIXEDLABEL
"#"({id}) SELECTOR
"#"({int}) SELECTOR
"#"({prefixedlabel}) SELECTOR
"0w"{num} WORD
"~"?"0x"{xdigit}+INT
"0wx"{xdigit}+ WORD
({int0}|~{num}) INT
{int}  INTLAB
{real}  REAL
"#\""(\\.|[^"\n\r\\])\" CHAR
\"(\\.|[^"\n\r\\])*\" STRING

%%
