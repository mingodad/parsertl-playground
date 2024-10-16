//From: https://github.com/kfl/mosml/blob/13c581aec46eea134e478f2e2b6456278e36ecce/src/compiler/Parser.grm#

/*Tokens*/
%token ABSTYPE
%token AND
%token ANDALSO
%token ARROW
%token AS
%token BAR
%token CASE
%token CHAR
%token COLON
%token COLONGT
%token COMMA
%token DARROW
%token DATATYPE
//%token DLBRACE
%token DO
%token DOTDOTDOT
//%token DRBRACE
%token ELSE
%token END
//%token EOF
%token EQTYPE
%token EQUALS
%token EXCEPTION
%token FN
%token FUN
%token FUNCTOR
%token HANDLE
%token HASH
%token HASHLBRACKET
%token ID
%token IF
%token IN
%token INCLUDE
%token INFIX
%token INFIXR
%token LBRACE
%token LBRACKET
%token LET
%token LOCAL
%token LPAREN
%token NEGINT
%token NONFIX
%token NZDIGIT
%token NZPOSINT2
%token OF
%token OP
%token OPEN
%token ORELSE
%token PRIM_EQTYPE
%token PRIM_REFTYPE
%token PRIM_TYPE
%token PRIM_VAL
%token QUAL_ID
%token QUAL_STAR
%token QUOTEL
%token QUOTEM
%token QUOTER
%token RAISE
%token RBRACE
%token RBRACKET
%token REAL
%token REC
%token RPAREN
%token SEMICOLON
%token SHARING
%token SIG
%token SIGNATURE
%token STAR
%token STRING
%token STRUCT
%token STRUCTURE
%token THEN
%token TYPE
%token TYVAR
%token UNDERBAR
%token VAL
%token WHERE
%token WHILE
%token WITH
%token WITHTYPE
%token WORD
%token YY_PARSE_SigFile
%token YY_PARSE_StructFile
%token YY_PARSE_TopDecFile
//%token YY_PARSE_ToplevelPhrase
%token YY_PARSE_TopSpecFile
%token ZDIGIT
%token ZPOSINT2

%right /*1*/ AND
%nonassoc /*2*/ DARROW
%nonassoc /*3*/ BAR
%nonassoc /*4*/ ELSE
%nonassoc /*5*/ DO
%nonassoc /*6*/ RAISE
%right /*7*/ HANDLE
%right /*8*/ ORELSE
%right /*9*/ ANDALSO
%right /*10*/ AS
%right /*11*/ ARROW
%nonassoc /*12*/ EQUALS ID
%right /*13*/ STAR

//%start ToplevelPhrase

%%

input :
	ToplevelPhrase //YYEOF
	| YY_PARSE_SigFile SigFile //YYEOF
	| YY_PARSE_StructFile StructFile //YYEOF
	| YY_PARSE_TopSpecFile TopSpecFile //YYEOF
	| YY_PARSE_TopDecFile TopDecFile //YYEOF
	;

//YY_PARSE_ToplevelPhrase :
//	ToplevelPhrase //YYEOF
//	;
//
//YY_PARSE_SigFile :
//	SigFile //YYEOF
//	;
//
//YY_PARSE_StructFile :
//	StructFile //YYEOF
//	;
//
//YY_PARSE_TopSpecFile :
//	TopSpecFile //YYEOF
//	;
//
//YY_PARSE_TopDecFile :
//	TopDecFile //YYEOF
//	;

Ident :
	ID /*12N*/
	| STAR /*13R*/
	;

IdentWithLoc :
	Ident
	;

OpIdent :
	Ident
	| OP Ident
	;

EqIdent :
	Ident
	| EQUALS /*12N*/
	;

ModId :
	IdentWithLoc
	;

SigId :
	IdentWithLoc
	;

TypeIdent :
	ID /*12N*/
	;

LongTypeIdent :
	TypeIdent
	| QUAL_ID
	;

LongIdent :
	Ident
	| QUAL_ID
	| QUAL_STAR
	;

LongOpIdent :
	LongIdent
	| OP Ident
	| OP QUAL_ID
	| OP QUAL_STAR
	;

LongOpEqIdent :
	LongOpIdent
	| EQUALS /*12N*/
	| OP EQUALS /*12N*/
	;

TyVar :
	TYVAR
	;

EqIdent_seq1 :
	EqIdent EqIdent_seq1
	| EqIdent
	;

LongModId :
	LongOpIdent
	;

LongModIdInfo_seq1 :
	LongModId LongModIdInfo_seq1
	| LongModId
	;

DIGIT_opt :
	ZDIGIT
	| NZDIGIT
	| /*empty*/
	;

Integer :
	ZPOSINT2
	| NZPOSINT2
	| NEGINT
	| ZDIGIT
	| NZDIGIT
	;

NumLabel :
	NZPOSINT2
	| NZDIGIT
	;

Label :
	Ident
	| NumLabel
	;

Arity :
	ZPOSINT2
	| NZPOSINT2
	| ZDIGIT
	| NZDIGIT
	;

ToplevelPhrase :
	Exp EOPh
	| KWDec_seq1 EOPh
	| EOPh
	;

EOPh :
	SEMICOLON
	//| EOF
	;

SemiEof :
	SEMICOLON SemiEof
	//| EOF
	;

Dec :
	KWDec Dec
	| SEMICOLON Dec
	| /*empty*/
	;

KWDec_seq1 :
	KWDec KWDec_seq1
	| KWDec
	;

TopDecFile :
	KWDec_seq //EOF
	;

StructFile :
	STRUCTURE ModId EQUALS /*12N*/ ModExp SemiEof
	| STRUCTURE ModId COLONGT SigId EQUALS /*12N*/ ModExp SemiEof
	| KWCoreDec_seq //EOF
	;

KWDec_seq :
	KWDec KWDec_seq
	| SEMICOLON KWDec_seq
	| /*empty*/
	;

KWCoreDec_seq :
	KWCoreDec KWCoreDec_seq
	| SEMICOLON KWCoreDec_seq
	| /*empty*/
	;

KWDec :
	KWCoreDec
	| KWModuleDec
	;

KWModuleDec :
	STRUCTURE ModBind_seq1
	| FUNCTOR FunBind_seq1
	| SIGNATURE SigBind_seq1
	;

KWCoreDec :
	VAL ValBind
	| VAL TyVarSeq1 ValBind
	| PRIM_VAL PrimValBind
	| PRIM_VAL TyVarSeq1 PrimValBind
	| FUN FValBind
	| FUN TyVarSeq1 FValBind
	| TYPE TypBind
	| PRIM_TYPE TypDesc
	| PRIM_EQTYPE TypDesc
	| PRIM_REFTYPE TypDesc
	| DATATYPE DatBind_0 WithType_opt
	| DATATYPE DatBind_n WithType_opt
	| DATATYPE TyCon EQUALS /*12N*/ DATATYPE TyConPath
	| ABSTYPE DatBind WithType_opt WITH Dec END
	| EXCEPTION ExBind
	| LOCAL Dec IN Dec END
	| OPEN LongModIdInfo_seq1
	| INFIX DIGIT_opt EqIdent_seq1
	| INFIXR DIGIT_opt EqIdent_seq1
	| NONFIX EqIdent_seq1
	;

ValBind :
	Pat EQUALS /*12N*/ Exp AndValBind_opt
	| REC FnValBind
	;

AndValBind_opt :
	AND /*1R*/ ValBind
	| /*empty*/
	;

PrimValBind :
	OpIdent COLON Ty EQUALS /*12N*/ Arity STRING AndPrimValBind_opt
	;

AndPrimValBind_opt :
	AND /*1R*/ PrimValBind
	| /*empty*/
	;

FnValBind :
	Pat EQUALS /*12N*/ Exp AndFnValBind_opt
	| REC FnValBind
	;

AndFnValBind_opt :
	AND /*1R*/ FnValBind
	| /*empty*/
	;

TypBind :
	TyVarSeq TyCon EQUALS /*12N*/ Ty AndTypBind_opt
	;

AndTypBind_opt :
	AND /*1R*/ TypBind
	| /*empty*/
	;

DatBind :
	TyVarSeq TyCon EQUALS /*12N*/ ConBind AndDatBind_opt
	;

DatBind_0 :
	TyCon EQUALS /*12N*/ ConBind AndDatBind_opt
	;

DatBind_n :
	TyVarSeq1 TyCon EQUALS /*12N*/ ConBind AndDatBind_opt
	;

AndDatBind_opt :
	AND /*1R*/ DatBind
	| /*empty*/
	;

ConBind :
	OpIdent OfTy_opt BarConBind_opt
	;

BarConBind_opt :
	BAR /*3N*/ ConBind
	| /*empty*/
	;

WithType_opt :
	WITHTYPE TypBind
	| /*empty*/
	;

ExBind :
	OpIdent OfTy_opt AndExBind_opt
	| OpIdent EQUALS /*12N*/ LongOpEqIdent AndExBind_opt
	;

AndExBind_opt :
	AND /*1R*/ ExBind
	| /*empty*/
	;

ExDesc :
	OpIdent OfTy_opt AndExDesc_opt
	;

AndExDesc_opt :
	AND /*1R*/ ExDesc
	| /*empty*/
	;

ColonTy_opt :
	COLON Ty
	| /*empty*/
	;

OfTy_opt :
	OF Ty
	| /*empty*/
	;

FValBind :
	FClauseWithLoc AndFValBind_opt
	;

AndFValBind_opt :
	AND /*1R*/ FValBind
	| /*empty*/
	;

FClauseWithLoc :
	FClause
	;

FClause :
	AtPat_seq1 ColonTy_opt EQUALS /*12N*/ Exp BarFClause_opt
	;

BarFClause_opt :
	BAR /*3N*/ FClause
	| /*empty*/
	;

SCon :
	Integer
	| WORD
	| CHAR
	| REAL
	| STRING
	;

VIdPathInfo :
	LongOpEqIdent
	;

AtExp :
	SCon
	| VIdPathInfo
	| LET Dec IN Exp END
	| HASH Label
	| LPAREN Exp RPAREN
	| LPAREN RPAREN
	| LPAREN ExpComma_seq2 RPAREN
	| LPAREN ExpSemicolon_seq2 RPAREN
	| LBRACE ExpRow_opt RBRACE
	| LET Dec IN ExpSemicolon_seq2 END
	| LBRACKET STRUCTURE ModExp AS /*10R*/ SigExp RBRACKET
	| LBRACKET FUNCTOR ModExp AS /*10R*/ SigExp RBRACKET
	| LBRACKET ExpComma_seq0 RBRACKET
	| HASHLBRACKET ExpComma_seq0 RBRACKET
	| QUOTEL QuoteTail
	;

QuoteTail :
	QUOTER
	| QUOTEM ExpQuoteTail
	;

ExpQuoteTail :
	Exp QuoteTail
	;

ExpComma_seq0 :
	ExpComma_seq1
	| /*empty*/
	;

ExpComma_seq1 :
	Exp COMMA ExpComma_seq1
	| Exp
	;

ExpComma_seq2 :
	Exp COMMA ExpComma_seq1
	;

ExpSemicolon_seq2 :
	Exp SEMICOLON ExpSemicolon_seq2
	| Exp SEMICOLON Exp
	;

AtExp_seq1 :
	AtExp AtExp_seq1
	| AtExp
	;

ExpRow_opt :
	ExpRow
	| /*empty*/
	;

ExpRow :
	Label EQUALS /*12N*/ Exp CommaExpRow_opt
	;

CommaExpRow_opt :
	COMMA ExpRow
	| /*empty*/
	;

InfixExp :
	AtExp_seq1
	;

Exp :
	InfixExp
	| Exp COLON Ty
	| Exp ANDALSO /*9R*/ Exp
	| Exp ORELSE /*8R*/ Exp
	| Exp HANDLE /*7R*/ Match
	| RAISE /*6N*/ Exp
	| IF Exp THEN Exp ELSE /*4N*/ Exp
	| WHILE Exp DO /*5N*/ Exp
	| CASE Exp OF MatchWithLoc
	| FN Match
	;

MatchWithLoc :
	Match
	;

Match :
	MRule BAR /*3N*/ Match
	| MRule %prec DARROW /*2N*/
	;

MRule :
	Pat DARROW /*2N*/ Exp
	;

InfixPat :
	AtPat_seq1
	;

Pat :
	InfixPat
	| Pat COLON Ty
	| Pat AS /*10R*/ Pat
	;

AtPat :
	UNDERBAR
	| SCon
	| LongOpIdent
	| LBRACE PatRow_opt RBRACE
	| LPAREN Pat RPAREN
	| LPAREN RPAREN
	| LPAREN PatComma_seq2 RPAREN
	| LBRACKET PatComma_seq0 RBRACKET
	| HASHLBRACKET PatComma_seq0 RBRACKET
	;

PatRow_opt :
	PatRow
	| /*empty*/
	;

PatRow :
	DOTDOTDOT
	| Label EQUALS /*12N*/ Pat CommaPatRow_opt
	| IdentWithLoc ColonTy_opt AsPat_opt CommaPatRow_opt
	;

AsPat_opt :
	AS /*10R*/ Pat
	| /*empty*/
	;

CommaPatRow_opt :
	COMMA PatRow
	| /*empty*/
	;

AtPat_seq1 :
	AtPat AtPat_seq1
	| AtPat
	;

PatComma_seq0 :
	PatComma_seq1
	| /*empty*/
	;

PatComma_seq1 :
	Pat COMMA PatComma_seq1
	| Pat
	;

PatComma_seq2 :
	Pat COMMA PatComma_seq1
	;

TyCon :
	ID /*12N*/
	;

WhereModBind_opt :
	WHERE ModId OptConEqualsModExp
	| /*empty*/
	;

TyConPath :
	LongTypeIdent WhereModBind_opt
	;

Ty :
	TupleTy ARROW /*11R*/ Ty
	| TupleTy
	;

TupleTy :
	Ty_sans_STAR
	| Ty_sans_STAR STAR /*13R*/ TupleTy
	;

Ty_sans_STAR :
	LPAREN TyComma_seq2 RPAREN TyConPath
	| Ty_sans_STAR TyConPath
	| AtomicTy
	;

TyComma_seq2 :
	Ty COMMA TyComma_seq2
	| Ty COMMA Ty
	;

AtomicTy :
	TyConPath
	| TyVar
	| LBRACE TyRow_opt RBRACE
	| LBRACKET SigExp RBRACKET
	| LPAREN Ty RPAREN
	;

TyRow_opt :
	TyRow
	| /*empty*/
	;

TyRow :
	Label COLON Ty CommaTyRow_opt
	;

CommaTyRow_opt :
	COMMA TyRow
	| /*empty*/
	;

TyVarSeq :
	TyVarSeq1
	| /*empty*/
	;

TyVarSeq1 :
	TyVar
	| LPAREN TyVarComma_seq1 RPAREN
	;

TyVarComma_seq1 :
	TyVar COMMA TyVarComma_seq1
	| TyVar
	;

LongTyConEqnTail :
	LongTypeIdent
	| LongTyConEqn
	;

LongTyConEqn :
	LongTypeIdent EQUALS /*12N*/ LongTyConEqnTail
	;

LongModIdEqnTail :
	LongModId
	| LongModIdEqn
	;

LongModIdEqn :
	LongModId EQUALS /*12N*/ LongModIdEqnTail
	;

LongModIdEqnWithLoc :
	LongModIdEqn
	;

Spec :
	Spec KWSpec
	| Spec SHARING TYPE LongTyConEqn
	| Spec SHARING LongModIdEqnWithLoc
	| Spec SEMICOLON
	| /*empty*/
	;

TopSpecFile :
	Spec_seq //EOF
	;

SigFile :
	SIGNATURE SigId EQUALS /*12N*/ SigExp SemiEof
	| CoreSpec_seq //EOF
	;

Spec_seq :
	Spec_seq KWSpec
	| Spec_seq SEMICOLON
	| /*empty*/
	;

CoreSpec_seq :
	CoreSpec_seq KWCoreSpec
	| CoreSpec_seq SEMICOLON
	| /*empty*/
	;

KWSpec :
	KWCoreSpec
	| KWModuleSpec
	;

KWCoreSpec :
	VAL TyVarSeq ValDesc
	| PRIM_VAL PrimValBind
	| PRIM_VAL TyVarSeq1 PrimValBind
	| TYPE TypBind
	| TYPE TypDesc
	| EQTYPE TypDesc
	| PRIM_REFTYPE TypDesc
	| DATATYPE DatBind_0 WithType_opt
	| DATATYPE DatBind_n WithType_opt
	| DATATYPE TyCon EQUALS /*12N*/ DATATYPE TyConPath
	| EXCEPTION ExDesc
	| LOCAL Spec IN Spec END
	| OPEN LongModIdInfo_seq1
	| INFIX DIGIT_opt EqIdent_seq1
	| INFIXR DIGIT_opt EqIdent_seq1
	| NONFIX EqIdent_seq1
	;

SigId_seq2 :
	SigId SigId_seq2
	| SigId SigId
	;

KWModuleSpec :
	STRUCTURE ModDesc_seq1
	| FUNCTOR FunDesc_seq1
	| INCLUDE SigExp
	| INCLUDE SigId_seq2
	| SIGNATURE SigBind_seq1
	;

ValDesc :
	OpIdent COLON Ty AndValDesc_opt
	;

AndValDesc_opt :
	AND /*1R*/ ValDesc
	| /*empty*/
	;

TypDesc :
	TyVarSeq TyCon AndTypDesc_opt
	;

AndTypDesc_opt :
	AND /*1R*/ TypDesc
	| /*empty*/
	;

ModBind_seq1 :
	ModId OptConEqualsModExp AndModBind_opt
	| ModId AS /*10R*/ SigExp EQUALS /*12N*/ Exp AndModBind_opt
	;

AndModBind_opt :
	AND /*1R*/ ModBind_seq1
	| /*empty*/
	;

OptConEqualsModExp :
	EQUALS /*12N*/ ModExp
	| COLON SigExp EQUALS /*12N*/ ModExp
	| COLONGT SigExp EQUALS /*12N*/ ModExp
	;

FunBind_seq1 :
	ModId AS /*10R*/ SigExp EQUALS /*12N*/ Exp AndFunBind_opt
	| ModId OptConEqualsModExp AndFunBind_opt
	| ModId LPAREN ModId COLON SigExp RPAREN FunBindBody AndFunBind_opt
	| ModId LPAREN Spec RPAREN OptConEqualsModExp AndFunBind_opt
	| ModId ModId COLON SigExp FunBindBody AndFunBind_opt
	| ModId SIG Spec END OptConEqualsModExp AndFunBind_opt
	;

AndFunBind_opt :
	AND /*1R*/ FunBind_seq1
	| /*empty*/
	;

SigBind_seq1 :
	SigId EQUALS /*12N*/ SigExp AndSigBind_opt
	;

AndSigBind_opt :
	AND /*1R*/ SigBind_seq1
	| /*empty*/
	;

FunBindBody :
	OptConEqualsModExp
	| LPAREN ModId COLON SigExp RPAREN FunBindBody
	| ModId COLON SigExp FunBindBody
	;

AtModExp :
	STRUCT Dec END
	| LongModId
	| LET Dec IN ModExp END
	| LPAREN ModExp RPAREN
	| LPAREN Dec RPAREN
	;

ModExp :
	AtModExp_seq1
	| ModExp COLONGT SigExp
	| ModExp COLON SigExp
	| FUNCTOR ModId COLON SigExp DARROW /*2N*/ ModExp
	| FUNCTOR LPAREN ModId COLON SigExp RPAREN DARROW /*2N*/ ModExp
	| REC LPAREN ModId COLON SigExp RPAREN ModExp
	;

AtModExp_seq1 :
	AtModExp AtModExp_seq1
	| AtModExp
	;

ModDesc_seq1 :
	ModId COLON SigExp AndModDesc_opt
	;

AndModDesc_opt :
	AND /*1R*/ ModDesc_seq1
	| /*empty*/
	;

FunDescBody :
	COLON SigExp
	| LPAREN ModId COLON SigExp RPAREN FunDescBody
	| ModId COLON SigExp FunDescBody
	;

FunDesc_seq1 :
	ModId FunDescBody AndFunDesc_opt
	;

AndFunDesc_opt :
	AND /*1R*/ FunDesc_seq1
	| /*empty*/
	;

SigExp :
	SIG Spec END
	| SigId
	| SigExp WHERE WhereType
	| FUNCTOR LPAREN ModId COLON SigExp RPAREN ARROW /*11R*/ SigExp
	| FUNCTOR ModId COLON SigExp ARROW /*11R*/ SigExp
	| REC LPAREN ModId COLON SigExp RPAREN SigExp
	;

WhereType :
	TYPE TyVarSeq LongTypeIdent EQUALS /*12N*/ Ty AndWhereType_opt
	;

AndWhereType_opt :
	AND /*1R*/ WhereType
	| /*empty*/
	;

%%

base_id	([A-Za-z][A-Za-z0-9_']*)
id_punct	[!%&$#+\-/:<=>?@\\~\`^|*]
id	({base_id}|{id_punct}+)

%%

"abstype"      ABSTYPE
"and"          AND
"andalso"      ANDALSO
"as"           AS
"case"         CASE
"datatype"     DATATYPE
"do"           DO
"else"         ELSE
"eqtype"       EQTYPE
"end"          END
"exception"    EXCEPTION
"fn"           FN
"fun"          FUN
"functor"      FUNCTOR
"handle"       HANDLE
"if"           IF
"in"           IN
"include"      INCLUDE
"infix"        INFIX
"infixr"       INFIXR
"let"          LET
"local"        LOCAL
"nonfix"       NONFIX
"of"           OF
"op"           OP
"open"         OPEN
"orelse"       ORELSE
"prim_eqtype"  PRIM_EQTYPE
"prim_EQtype"  PRIM_REFTYPE
"prim_type"    PRIM_TYPE
"prim_val"     PRIM_VAL
"raise"        RAISE
"rec"          REC
"sharing"      SHARING
"sig"          SIG
"signature"    SIGNATURE
"struct"       STRUCT
"structure"    STRUCTURE
"then"         THEN
"type"         TYPE
"val"          VAL
"where"        WHERE
"while"        WHILE
"with"         WITH
"withtype"     WITHTYPE
"#"            HASH
"->"           ARROW
"|"            BAR
":>"           COLONGT
":"            COLON
"=>"           DARROW
"="            EQUALS
"*"            STAR

"_"            UNDERBAR
","            COMMA
"..."          DOTDOTDOT
"{"            LBRACE
"}"            RBRACE
"["            LBRACKET
"#["           HASHLBRACKET
"]"            RBRACKET
";"            SEMICOLON
"("            LPAREN
")"            RPAREN
"`"            QUOTEL
QUOTEM	QUOTEM
QUOTER	QUOTER

//DLBRACE	DLBRACE
//DRBRACE	DRBRACE
//EOF	EOF
YY_PARSE_SigFile	YY_PARSE_SigFile
YY_PARSE_StructFile	YY_PARSE_StructFile
YY_PARSE_TopDecFile	YY_PARSE_TopDecFile
YY_PARSE_TopSpecFile	YY_PARSE_TopSpecFile
//YY_PARSE_ToplevelPhrase	YY_PARSE_ToplevelPhrase

/* Order is important bellow here */
[1-9]	NZDIGIT
[1-9][0-9]+	NZPOSINT2
"0"	ZDIGIT
"0"[0-9]+	ZPOSINT2
"~"?[0-9]+("."[0-9]+)?([eE]"~"?[0-9]+)?	REAL
"~"[0-9]+|"~"?"0x"[0-9a-fA-F]+	NEGINT
"0w"[0-9]+|"0wx"[0-9a-fA-F]+	WORD

"#\""(\\.|[^"\r\n\\])\"	CHAR
\"(\\.|[^"\r\n\\])*\"	STRING
"'"[A-Za-z0-9_']+	TYVAR

QUAL_STAR	QUAL_STAR
{id}	ID
({id}".")+({base_id}|{id_punct}+)	QUAL_ID

[ \t\r\n]+	skip()
"(*"(?s:.)*?"*)"	skip()


%%
