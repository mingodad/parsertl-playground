//From: https://github.com/minoki/LunarML/blob/e8d2a0989a4c01208c7a2cbda323064ee9423f32/src/syntax.grm
/*
 * Copyright (c) 2022 ARATA Mizuki
 * This file is part of LunarML.
 */

%token ABSTYPE
%token AlnumIdent
%token AND
%token ANDALSO
%token ARROW
%token AS
%token AsciiStringConst
%token ASTERISK
%token BAR
%token CASE
%token CharacterConst
%token COLON
%token COLONGT
%token COMMA
%token DARROW
%token DATATYPE
%token DO
%token ELLIPSIS
%token ELSE
%token END
%token END_SPECIAL_COMMENT
%token EQTYPE
%token EQUALITY
%token EQUALS
%token ESIMPORT
%token EXCEPTION
%token FN
%token FROM
%token FUN
%token FUNCTOR
%token HANDLE
%token HASH
%token HASHLBRACK
%token IF
%token IN
%token INCLUDE
%token INFIX
%token InfixIdent
%token INFIXR
%token LBRACE
%token LBRACK
%token LET
%token LOCAL
%token LPAREN
%token NONFIX
%token OF
%token OP
%token OPEN
%token ORELSE
%token OVERLOAD
%token PosInt
%token PRIMCALL
%token PrimeIdent
%token PrimIdent
%token PURE
%token QualifiedAlnumIdent
%token QualifiedInfixIdent
%token QualifiedSymbolicIdent
%token RAISE
%token RBRACE
%token RBRACK
%token RealConst
%token REC
%token RPAREN
%token SEMICOLON
%token SHARING
%token SIG
%token SIGNATURE
%token START_VAL_DESC_COMMENT
%token StringConst
%token STRUCT
%token STRUCTURE
%token SymbolicIdent
%token THEN
%token TYPE
%token UNDERSCORE
%token VAL
%token WHERE
%token WHILE
%token WITH
%token WITHTYPE
%token WordConst
%token ZNIntConst

%right ARROW /* function type expression */

%%

START :
	Program
	;

IntConst :
	PosInt
	| ZNIntConst
	;

SCon :
	IntConst
	| WordConst
	| RealConst
	| StringConst
	| AsciiStringConst
	| CharacterConst
	;

/* type variable */
TyVar :
	PrimeIdent
	;

/* value identifiers */
VId :
	BoundVId
	| EQUALS  /* ? */
	;

/* value identifiers, excluding '=' */
BoundVId :
	AlnumIdent
	| FROM
	| PURE
	| SymbolicIdent
	| ASTERISK
	;

/* structure identifier */
StrId :
	AlnumIdent
	| FROM
	| PURE
	;

/* signature identifier */
SigId :
	AlnumIdent
	| FROM
	| PURE
	;

/* functor identifier */
FunId :
	AlnumIdent
	| FROM
	| PURE
	;

/* record labels */
Lab :
	AlnumIdent
	| FROM
	| PURE
	| SymbolicIdent
	| ASTERISK
	| PosInt  /* numeric labels */
	;

/* type constructors; "*" is not included */
TyCon :
	AlnumIdent
	| FROM
	| PURE
	| SymbolicIdent
	;

/* type constructors; neither "*" nor "from" is included */
TyCon_NoFROM :
	AlnumIdent
	| PURE
	| SymbolicIdent
	;

/* long value identifiers, including '=' */
LongVId :
	VId
	| QualifiedAlnumIdent
	| QualifiedSymbolicIdent
	| PrimIdent
	;

/* long value identifiers, excluding unqualified '=' */
LongBoundVId :
	BoundVId
	| QualifiedAlnumIdent
	| QualifiedSymbolicIdent
	| PrimIdent
	;

/* long type constructors */
LongTyCon :
	TyCon
	| QualifiedAlnumIdent
	| QualifiedSymbolicIdent
	| PrimIdent
	;

/* long type constructors, excluding unqualified 'from' */
LongTyCon_NoFROM :
	TyCon_NoFROM
	| QualifiedAlnumIdent
	| QualifiedSymbolicIdent
	| PrimIdent
	;

/* long structure identifiers */
LongStrId :
	StrId
	| QualifiedAlnumIdent
	;

Opt_OP :
	/* empty */
	| OP
	;

Opt_BAR :
	/* empty */
	| BAR
	;

/* atomic patterns */
AtPat :
	UNDERSCORE  /* wildcard */
	| SCon  /* special constant */
	| OP LongVId  /* value identifier, including 'op =' */
	| LongBoundVId  /* value identifier */
	| LBRACE RBRACE  /* empty record */
	| LBRACE PatRow RBRACE  /* record */
	| LPAREN RPAREN  /* [derived] empty tuple */
	| LPAREN Pat RPAREN  /* parenthesized pattern */
	| LPAREN Pat COMMA Pat PatSeqRest RPAREN  /* [derived] tuple pattern */
	| LBRACK RBRACK  /* [derived] empty list */
	| LBRACK Pat PatSeqRest RBRACK  /* [derived] list pattern */
	| HASHLBRACK RBRACK  /* [extension] vector list */
	| HASHLBRACK ELLIPSIS RBRACK  /* [extension] vector list */
	| HASHLBRACK Pat PatSeqRestEllipsis RBRACK  /* [extension] vector pattern */
	;

/* one or more atomic patterns */
AtPats :
	AtPat
	| AtPat AtPats
	| AtPat InfixIdent AtPats
	| AtPat QualifiedInfixIdent AtPats
	;

TypedPat :
	AtPats
	| TypedPat COLON Ty  /* typed */
	;

/* patterns */
Pat :
	TypedPat
/*
    | OP VId COLON Ty AS Pat (UnfixedSyntax.LayeredPat (OP_VId, SOME Ty, Pat)) (* layered *)
    | OP VId AS Pat (UnfixedSyntax.LayeredPat (OP_VId, NONE, Pat)) (* layered *)
    | BoundVId COLON Ty AS Pat (UnfixedSyntax.LayeredPat (OP_VId, SOME Ty, Pat)) (* layered *)
    | BoundVId AS Pat (UnfixedSyntax.LayeredPat (OP_VId, NONE, Pat)) (* layered *)
*/
	| TypedPat AS Pat  /* layered or [Successor ML] conjunctive (R) */
	;

TypedPatPun :
	BoundVId
	| BoundVId COLON Ty
	;

PatPun :
	TypedPatPun
	| TypedPatPun AS Pat
	;

/* pattern rows */
PatRow :
	ELLIPSIS PatRowRest  /* wildcard */
	| ELLIPSIS EQUALS Pat PatRowRest  /* [Successor ML] ellipses */
	| Lab EQUALS Pat PatRowRest  /* pattern row */
	| PatPun PatRowRest  /* [derived] punning */
	;

PatRowRest :
	COMMA PatRow
	| %empty
	;

PatSeqRest :
	COMMA Pat PatSeqRest
	| %empty
	;

PatSeqRestEllipsis :
	COMMA Pat PatSeqRestEllipsis
	| COMMA ELLIPSIS
	| %empty
	;

AtTy :
	TyVar
	| LBRACE RBRACE  /* record type expression */
	| LBRACE TyRow RBRACE  /* record type expression */
	| LPAREN Ty RPAREN
	;

ConTy :
	AtTy
	| ConTy LongTyCon  /* type construction */
	| LongTyCon  /* type construction */
	| LPAREN Ty COMMA Ty TySeqRest RPAREN LongTyCon  /* type construction */
	;

/* tuple type */
TupTy :
	ConTy
	| ConTy ASTERISK TupTy
	;

/* type expressions */
Ty :
	TupTy
	| TupTy ARROW Ty  /* function type expression (R) */
	;

ConTy_NoFROM :
	AtTy
	| ConTy_NoFROM LongTyCon_NoFROM  /* type construction */
	| LongTyCon_NoFROM  /* type construction */
	| LPAREN Ty COMMA Ty TySeqRest RPAREN LongTyCon_NoFROM  /* type construction */
	;

/* tuple type, excluding unqualified 'from' */
TupTy_NoFROM :
	ConTy_NoFROM
	| ConTy_NoFROM ASTERISK TupTy_NoFROM
	;

/* type expressions, excluding unqualified 'from' */
Ty_NoFROM :
	TupTy_NoFROM
	| TupTy_NoFROM ARROW Ty_NoFROM  /* function type expression (R) */
	;

TySeqRest :
	COMMA Ty TySeqRest  /* */
	|  /* empty */
	;

TyVarSeq :
	TyVar  /* singleton sequence */
	|  /* empty sequence */
	| LPAREN TyVar TyVarSeqRest RPAREN  /* sequence */
	;

TyVarSeqRest :
	COMMA TyVar TyVarSeqRest  /* */
	|  /* empty */
	;

/* type-expression rows */
TyRow :
	Lab COLON Ty COMMA TyRow  /* type-expression row */
	| Lab COLON Ty  /* type-expression row */
	| ELLIPSIS COLON Ty COMMA_TyRow_NoELLIPSIS  /* [Successor ML] ellipses */
	;

COMMA_TyRow_NoELLIPSIS :
	COMMA Lab COLON Ty COMMA_TyRow_NoELLIPSIS  /* type-expression row */
	|  /* type-expression row */
	;

/* atomic expressions */
AtExp :
	SCon  /* special constant */
	| OP LongVId  /* value identifier */
	| LongBoundVId  /* value identifier */
	| EQUALS
	| LBRACE RBRACE  /* empty record */
	| LBRACE ExpRow RBRACE  /* record */
	| LBRACE AtExp WHERE RBRACE  /* [Successor ML] record update */
	| LBRACE AtExp WHERE ExpRow RBRACE  /* [Successor ML] record update */
	| LET Decs IN Exp END  /* local declaration */
	| LPAREN Exp RPAREN  /* parenthesized expression */
	| LPAREN Exp SEMICOLON RPAREN  /* parenthesized expression */
	| LPAREN RPAREN  /* [derived] 0-tuple */
	| LPAREN Exp COMMA Exp ExpCSeqRest RPAREN  /* [derived] tuple: {1=Exp1,...,n=Expn} (n >= 2) */
	| LPAREN Exp SEMICOLON Exp ExpSSeqRest RPAREN  /* [derived] sequential execution */
	| LET Decs IN Exp SEMICOLON Exp ExpSSeqRest END  /* [derived] local declaration */
	| LBRACK RBRACK  /* [derived] list: Exp1 :: ... :: Expn :: nil */
	| LBRACK Exp ExpCSeqRest RBRACK  /* [derived] list: Exp1 :: ... :: Expn :: nil */
	| HASHLBRACK RBRACK  /* [extension] vector expression */
	| HASHLBRACK Exp ExpCSeqRest RBRACK  /* [extension] vector expression */
	| HASH Lab  /* [derived] projection: fn {Lab=VId,...} => VId */
	| PRIMCALL AsciiStringConst LBRACK Ty TySeqRest RBRACK LPAREN RPAREN  /* [extension] _primCall "name" [tyargs] () */
	| PRIMCALL AsciiStringConst LBRACK Ty TySeqRest RBRACK LPAREN Exp ExpCSeqRest RPAREN  /* [extension] _primCall "name" [tyargs] (args) */
	| PRIMCALL AsciiStringConst LPAREN RPAREN  /* [extension] _primCall "name" () */
	| PRIMCALL AsciiStringConst LPAREN Exp ExpCSeqRest RPAREN  /* [extension] _primCall "name" (args) */
	;

/* comma-separated list of expressions */
ExpCSeqRest :
	COMMA Exp ExpCSeqRest
	| %empty
	;

/* semicolon-separated list of expressions */
ExpSSeqRest :
	SEMICOLON Exp ExpSSeqRest
	| SEMICOLON
	| %empty
	;

/* expression rows */
ExpRow :
	Lab EQUALS Exp ExpRowRest
	| ELLIPSIS EQUALS Exp ExpRowRest  /* [Successor ML] ellipses */
	| BoundVId ExpRowRest  /* [Successor ML] record pun */
	;

ExpRowRest :
	COMMA ExpRow
	| %empty
	;

/*
AppExp : AtExp
       | AppExp AtExp
InfExp : AppExp
       | InfExp VId InfExp
	;
*/

AppOrInfExp :
	AtExp AppOrInfExp  /* atomic */
	| AtExp
	| AtExp InfixIdent AppOrInfExp
	| AtExp QualifiedInfixIdent AppOrInfExp
	;

TypedExp :
	AppOrInfExp
	| TypedExp COLON Ty  /* typed (L) */
	;

AndalsoExp :
	TypedExp
	| TypedExp ANDALSO AndalsoExp  /* [derived] conjunction */
	| TypedExp ANDALSO HeadExp  /* [derived] conjunction */
	;

AndalsoExp_NoHead :
	TypedExp
	| TypedExp ANDALSO AndalsoExp_NoHead  /* [derived] conjunction */
	;

AndalsoExp_NoMatch :
	TypedExp
	| TypedExp ANDALSO AndalsoExp_NoMatch  /* [derived] conjunction */
	| TypedExp ANDALSO HeadExp_NoMatch  /* [derived] conjunction */
	;

OrelseExp :
	AndalsoExp
	| AndalsoExp_NoHead ORELSE OrelseExp  /* [derived] disjunction */
	| AndalsoExp_NoHead ORELSE HeadExp  /* [derived] disjunction */
	;

OrelseExp_NoHead :
	AndalsoExp_NoHead
	| AndalsoExp_NoHead ORELSE OrelseExp_NoHead  /* [derived] disjunction */
	;

OrelseExp_NoMatch :
	AndalsoExp_NoMatch
	| AndalsoExp_NoHead ORELSE OrelseExp_NoMatch  /* [derived] disjunction */
	| AndalsoExp_NoHead ORELSE HeadExp_NoMatch  /* [derived] disjunction */
	;

/* expression with a starting token */
HeadExp :
	RAISE Exp  /* raise exception */
	| IF Exp THEN Exp ELSE Exp  /* [derived] conditional */
	| WHILE Exp DO Exp  /* [derived] iteration */
	| CASE Exp OF Opt_BAR MatchClauses  /* [derived] pattern match: (fn MatchClauses)(Exp) */
	| FN Opt_BAR MatchClauses  /* function */
	;

HeadExp_NoMatch :
	RAISE Exp_NoMatch  /* raise exception */
	| IF Exp THEN Exp ELSE Exp_NoMatch
	| WHILE Exp DO Exp_NoMatch  /* [derived] iteration */
	;

/* expression */
Exp :
	OrelseExp
	| OrelseExp_NoHead HANDLE Opt_BAR MatchClauses  /* handle exception */
	| HeadExp
	;

Exp_NoMatch :
	OrelseExp_NoMatch
	| HeadExp_NoMatch
	;

/* matches */
MatchClauses :
	Pat DARROW Exp_NoMatch BAR MatchClauses
	| Pat DARROW Exp
	;

ValDescInComment :
	START_VAL_DESC_COMMENT ValDescInCommentVal ValDescInCommentVals END_SPECIAL_COMMENT ValDescInComment
	| %empty
	;

ValDescInCommentVal :
	VAL ValDesc_Q
	;

ValDescInCommentVals :
	ValDescInCommentVal ValDescInCommentVals
	| %empty
	;

ValDesc_Q :
	VId COLON Ty
	| VId COLON Ty AND ValDesc_Q
	;

/* a declaration, excluding local-in-end */
Dec_NoLocal :
	ValDescInComment VAL ValBind  /* value declaration (non-recursive) */
	| ValDescInComment VAL TyVar ValBind  /* value declaration (non-recursive) */
	| ValDescInComment VAL LPAREN TyVar TyVarSeqRest RPAREN ValBind  /* value declaration (non-recursive) */
	| ValDescInComment VAL REC ValBind  /* value declaration (recursive) */
	| ValDescInComment VAL REC TyVar ValBind  /* [Successor ML-style] value declaration (recursive) */
	| ValDescInComment VAL REC LPAREN TyVar TyVarSeqRest RPAREN ValBind  /* [Successor ML-style] value declaration (recursive) */
	| ValDescInComment VAL TyVar REC ValBind  /* [SML97-style] value declaration (recursive) */
	| ValDescInComment VAL LPAREN TyVar TyVarSeqRest RPAREN REC ValBind  /* [SML97-style] value declaration (recursive) */
	| ValDescInComment FUN FValBind  /* [derived] function declaration */
	| ValDescInComment FUN BAR FValBind  /* [derived] function declaration */
	| ValDescInComment FUN TyVar Opt_BAR FValBind  /* [derived] function declaration */
	| ValDescInComment FUN LPAREN TyVar TyVarSeqRest RPAREN Opt_BAR FValBind  /* [derived] function declaration */
	| TYPE TypBind  /* type declaration */
            /* | DATATYPE DatBind (UnfixedSyntax.DatatypeDec(span(DATATYPEleft, DatBindright), DatBind)) (* datatype declaration *) */
	| DATATYPE TyCon EQUALS Opt_BAR ConBind DatBindRest Withtype  /* datatype declaration */
	| DATATYPE TyVar TyCon EQUALS Opt_BAR ConBind DatBindRest Withtype  /* datatype declaration */
	| DATATYPE LPAREN TyVar TyVarSeqRest RPAREN TyCon EQUALS Opt_BAR ConBind DatBindRest Withtype  /* datatype declaration */
	| DATATYPE TyCon EQUALS DATATYPE LongTyCon  /* datatype replication */
	| ABSTYPE DatBind Withtype WITH Decs END  /* abstype declaration */
	| EXCEPTION ExBind  /* exception declaration */
	| OPEN LongStrIds  /* open declaration */
	| INFIX IntConst VIds  /* infix (L) directive */
	| INFIX VIds  /* infix (L) directive */
	| INFIXR IntConst VIds  /* infix (R) directive */
	| INFIXR VIds  /* infix (R) directive */
	| NONFIX VIds  /* nonfix directive */
	| DO Exp  /* [Successor ML] do declaration */
	| OVERLOAD AsciiStringConst LBRACK LongTyCon RBRACK LBRACE OverloadSpecs RBRACE  /* [extension] _overload "class" [ty] { + = ..., - = ..., ... } */
	| EQUALITY LongTyCon EQUALS Exp  /* [extension] _equality longtycon = exp */
	| EQUALITY TyVar LongTyCon EQUALS Exp  /* [extension] _equality 'tyvar longtycon = exp */
	| EQUALITY LPAREN TyVar TyVarSeqRest RPAREN LongTyCon EQUALS Exp  /* [extension] _equality ('tyvars...) longtycon = exp */
	| ESIMPORT ESImportAttrs AsciiStringConst  /* [extension] _esImport [attr...] "module-name" */
	| ESIMPORT ESImportAttrs VId FROM AsciiStringConst  /* [extension] _esImport [attr...] <vid> from "module-name" */
	| ESIMPORT ESImportAttrs VId COLON Ty_NoFROM FROM AsciiStringConst  /* [extension] _esImport [attr...] <vid> from "module-name" */
	| ESIMPORT ESImportAttrs LBRACE ESImportSpecs RBRACE FROM AsciiStringConst  /* [extension] _esImport [attr...] {spec...} from "module-name" */
	| ESIMPORT ESImportAttrs VId COMMA LBRACE ESImportSpecs RBRACE FROM AsciiStringConst  /* [extension] _esImport [attr...] <vid>, {spec...} from "module-name" */
	| ESIMPORT ESImportAttrs VId COLON Ty_NoFROM COMMA LBRACE ESImportSpecs RBRACE FROM AsciiStringConst  /* [extension] _esImport [attr...] <vid>, {spec...} from "module-name" */
	;

OverloadSpec :
	AlnumIdent EQUALS Exp
	| FROM EQUALS Exp
	| PURE EQUALS Exp
	| SymbolicIdent EQUALS Exp
	| ASTERISK EQUALS Exp
	;

OverloadSpecs :
	OverloadSpec COMMA OverloadSpecs
	| OverloadSpec
	;

ESImportAttrs :
	LBRACK PURE RBRACK
	| %empty
	;

ESImportSpec :
	VId
	| VId AS VId
	| AsciiStringConst AS VId
	| VId COLON Ty
	| VId AS VId COLON Ty
	| AsciiStringConst AS VId COLON Ty
	;

ESImportSpecs :
	%empty
	| ESImportSpec ESImportSpecsRest
	;

ESImportSpecsRest :
	%empty
	| COMMA ESImportSpecs
	;

Dec :
	Dec_NoLocal
	| LOCAL Decs IN Decs END  /* local declaration */
	;

/* declarations */
Decs :
	Dec Decs
	| SEMICOLON Decs  /* sequential declaration */
	|  /* empty declaration */
	;

/* LongStrId[1] ... LongStrId[n] */
LongStrIds :
	LongStrId LongStrIds
	| LongStrId
	;

/* VId[1] ... VId[n] */
VIds :
	VId VIds
	| InfixIdent VIds
	| VId
	| InfixIdent
	;

/* value bindings */
ValBind :
	Pat EQUALS Exp AND ValBind
	| Pat EQUALS Exp
        /* | REC ValBind (UnfixedSyntax.RecValBind (span(RECleft, ValBindright), ValBind)) */
	;

FValBind :
	FMatch
	| FMatch AND FValBind
	;

FMatch :
	FMRule
	| FMRule_NoMatch BAR FMatch
	;

FMRule :
	FPat COLON Ty EQUALS Exp
	| FPat EQUALS Exp
	;

FMRule_NoMatch :
	FPat COLON Ty EQUALS Exp_NoMatch
	| FPat EQUALS Exp_NoMatch
	;

FPat :
	AtPats
/*
       OP BoundVId AtPats
     | BoundVId AtPats
     | AtPat BoundVId AtPat
     | LPAREN AtPat BoundVId AtPat RPAREN
     | LPAREN AtPat BoundVId AtPat RPAREN AtPats
*/
	;

/* type bindings */
TypBind :
	TyVarSeq TyCon EQUALS Ty AND TypBind
	| TyVarSeq TyCon EQUALS Ty
	;

/* datatype bindings */
DatBind :
	TyVarSeq TyCon EQUALS Opt_BAR ConBind DatBindRest
	;

/* datatype bindings */
DatBindRest :
	AND DatBind
	| %empty
	;

Withtype :
	WITHTYPE TypBind
	| %empty
	;

/* constructor bindings */
ConBind :
	Opt_OP BoundVId OF Ty ConBindRest
	| Opt_OP BoundVId ConBindRest
	;

ConBindRest :
	BAR ConBind
	| %empty
	;

/* exception bindings */
ExBind :
	Opt_OP BoundVId OF Ty ExBindRest
	| Opt_OP BoundVId ExBindRest
	| Opt_OP BoundVId EQUALS Opt_OP LongVId ExBindRest
	;

ExBindRest :
	AND ExBind
	| %empty
	;

AtStrExp :
	STRUCT StrDecs END
	| LongStrId
	| FunId LPAREN StrExp RPAREN
	| FunId LPAREN StrDecs RPAREN  /* derived form */
	| LET StrDecs IN StrExp END
	;

StrExp :
	AtStrExp
	| StrExp COLON SigExp  /* transparent constraint */
	| StrExp COLONGT SigExp  /* opaque constraint */
	;

/* equivalent to 'StrExp AND' */
StrExp_AND :
	AtStrExp AND
	| StrExp COLON SigExp_AND  /* transparent constraint */
	| StrExp COLONGT SigExp_AND  /* opaque constraint */
	;

ProperStrDec :
	STRUCTURE StrBind
	| LOCAL StrDecs IN StrDecs END
	;

StrDecs :
	Dec_NoLocal StrDecs
	| ProperStrDec StrDecs
	| SEMICOLON StrDecs
	| %empty
	;

StrBind :
	StrId SigConstraint EQUALS StrExp_AND StrBind
	| StrId SigConstraint EQUALS StrExp
	;

Spec :
	VAL ValDesc
	| TYPE TyVarSeq TyCon TypDescRest
	| TYPE TyVarSeq TyCon EQUALS Ty TypDescEQRest
	| EQTYPE TypDesc
     /* | DATATYPE DatDesc (Syntax.DatDesc(span(DATATYPEleft, DatDescright), DatDesc)) */
	| DATATYPE TyCon EQUALS Opt_BAR ConDesc DatDescRest Withtype
	| DATATYPE TyVar TyCon EQUALS Opt_BAR ConDesc DatDescRest Withtype
	| DATATYPE LPAREN TyVar TyVarSeqRest RPAREN TyCon EQUALS Opt_BAR ConDesc DatDescRest Withtype
	| DATATYPE TyCon EQUALS DATATYPE LongTyCon
	| EXCEPTION ExDesc
	| STRUCTURE StrDesc
	| INCLUDE SigExp_NoSigId
	| INCLUDE SigIds
	;

ValDesc :
	VId COLON Ty
	| VId COLON Ty AND ValDesc
	;

TypDesc :
	TyVarSeq TyCon TypDescRest
	;

TypDescRest :
	AND TyVarSeq TyCon TypDescRest
	| %empty
	;

TypDescEQRest :
	AND TyVarSeq TyCon EQUALS Ty TypDescEQRest
	| %empty
	;

DatDescRest :
	AND TyVarSeq TyCon EQUALS Opt_BAR ConDesc DatDescRest
	| %empty
	;

ConDesc :
	VId ConDescRest
	| VId OF Ty ConDescRest
	;

ConDescRest :
	BAR ConDesc
	| %empty
	;

ExDesc :
	VId ExDescRest
	| VId OF Ty ExDescRest
	;

ExDescRest :
	AND ExDesc
	| %empty
	;

StrDesc :
	StrId COLON SigExp
	| StrId COLON SigExp_AND StrDesc
	;

SigIds :
	SigId SigIds
	| SigId
	;

Specs_NoSharing :
	%empty
	| Spec Specs_NoSharing
	| Spec SEMICOLON Specs_NoSharing
	;

Specs :
	%empty
	| Spec Specs_NoSharing
	| Spec SEMICOLON Specs_NoSharing
	| Specs SHARING TYPE LongTyCon EQUAL_LongTyCons Specs_NoSharing
	| Specs SHARING LongStrId EQUAL_LongStrIds Specs_NoSharing
	;

EQUAL_LongTyCons :
	EQUALS LongTyCon EQUAL_LongTyCons
	| EQUALS LongTyCon
	;

EQUAL_LongStrIds :
	EQUALS LongStrId EQUAL_LongStrIds
	| EQUALS LongStrId
	;

SigExp_NoSigId :
	SIG Specs END
	| SigExp WHERE TYPE TyVarSeq LongTyCon EQUALS Ty TypeRealisationRest
	;

SigExp :
	SigId
	| SigExp_NoSigId
	;

/* equivalent to 'SigExp AND' */
SigExp_AND :
	SIG Specs END AND
	| SigId AND
	| SigExp WHERE TYPE TyVarSeq LongTyCon EQUALS Ty TypeRealisationRest_AND
	;

TypeRealisationRest :
	AND TYPE TyVarSeq LongTyCon EQUALS Ty TypeRealisationRest  /* [removed in Successor ML] */
	| %empty
	;

/* equivalent to 'TypeRealisationRest AND' */
TypeRealisationRest_AND :
	AND TYPE TyVarSeq LongTyCon EQUALS Ty TypeRealisationRest_AND  /* [removed in Successor ML] */
	| AND
	;

SigBinds :
	SigId EQUALS SigExp
	| SigId EQUALS SigExp_AND SigBinds
	;

SigDec :
	SIGNATURE SigBinds
	;

SigConstraint :
	%empty
	| COLON SigExp
	| COLONGT SigExp
	;

FunDec :
	FUNCTOR FunBind
	;

FunBind :
	FunId LPAREN StrId COLON SigExp RPAREN SigConstraint EQUALS StrExp_AND FunBind
	| FunId LPAREN Specs RPAREN SigConstraint EQUALS StrExp_AND FunBind
	| FunId LPAREN StrId COLON SigExp RPAREN SigConstraint EQUALS StrExp
	| FunId LPAREN Specs RPAREN SigConstraint EQUALS StrExp
	;

TopDecs :
	Dec_NoLocal TopDecs  /* strdec */
	| ProperStrDec TopDecs  /* strdec */
	| SigDec TopDecs
	| FunDec TopDecs
	| %empty
	;

Program :
	TopDecs SEMICOLON Program
	| Exp SEMICOLON Program  /* val it = Exp */
	| TopDecs  /* topdecs without semicolon */
	;

%%

ws  \t|"\011"|"\012"|" "
cr  "\013"
nl  "\010"
eol  ({cr}{nl}|{nl}|{cr})

alphanum  [A-Za-z0-9'_]
alphanumId  [A-Za-z]{alphanum}*
sym  "!"|"%"|"&"|"$"|"#"|"+"|"-"|"/"|":"|"<"|"="|">"|"?"|"@"|"\\"|"~"|"`"|"^"|"|"|"*"
symId  {sym}+

tyvarId  "'"{alphanum}*
longSymId  ({alphanumId}".")+{symId}
longAlphanumId  ({alphanumId}".")+{alphanumId}

decDigit  [0-9]
decnum  {decDigit}("_"*{decDigit})*
hexDigit  [0-9a-fA-F]
hexnum  {hexDigit}("_"*{hexDigit})*
binDigit  [0-1]
binnum  {binDigit}("_"*{binDigit})*
frac  "."{decnum}
exp  [eE](~?){decnum}
real  (~?)(({decnum}{frac}?{exp})|({decnum}{frac}{exp}?))

%%

[ \t\r\n]+	skip()
"(*"(?s:.)*?"*)"	skip()

"abstype"	ABSTYPE
"and"	AND
"andalso"	ANDALSO
"->"	ARROW
"as"	AS
"*"	ASTERISK
"|"	BAR
"case"	CASE
":"	COLON
":>"	COLONGT
","	COMMA
"=>"	DARROW
"datatype"	DATATYPE
"do"	DO
"..."	ELLIPSIS
"else"	ELSE
"end" 	END
"eqtype"	EQTYPE
"_equality"	EQUALITY
"="	EQUALS
"_esImport"	ESIMPORT
"exception"	EXCEPTION
"fn" 	FN
"from"	FROM
"fun"	FUN
"functor"	FUNCTOR
"handle"	HANDLE
"#"	HASH
"#["	HASHLBRACK
"if"	IF
"in"	IN
"include"	INCLUDE
"infix"	INFIX
"infixr"	INFIXR
"{"	LBRACE
"["	LBRACK
"let"	LET
"local"	LOCAL
"("	LPAREN
"nonfix"	NONFIX
"of"	OF
"op"	OP
"open"	OPEN
"orelse"	ORELSE
"_overload"	OVERLOAD
"_primCall"	PRIMCALL
"pure"	PURE
"raise"	RAISE
"}"	RBRACE
"]"	RBRACK
"rec"	REC
")"	RPAREN
";"	SEMICOLON
"sharing"	SHARING
"sig"	SIG
"signature"	SIGNATURE
"struct"	STRUCT
"structure"	STRUCTURE
"then"	THEN
"type"	TYPE
"_"	UNDERSCORE
"val"	VAL
"where"	WHERE
"while"	WHILE
"with"	WITH
"withtype"	WITHTYPE

"(*:"	START_VAL_DESC_COMMENT
":*)"	END_SPECIAL_COMMENT

\"(\\.|[^"\r\n\\])*\"	AsciiStringConst
"#\""(\\.|[^"\n\r\\])\"	CharacterConst

PosInt	PosInt

{real}	RealConst
StringConst	StringConst
WordConst	WordConst
"~0x"{hexnum}	ZNIntConst
"~0b"{binnum}	ZNIntConst
{decnum}	ZNIntConst

InfixIdent	InfixIdent

{tyvarId}	PrimeIdent
PrimIdent	PrimIdent

{longAlphanumId}	QualifiedAlnumIdent
QualifiedInfixIdent	QualifiedInfixIdent
{longSymId}	QualifiedSymbolicIdent

{alphanumId}	AlnumIdent
{symId}	SymbolicIdent

%%

