//From: https://github.com/miguelzf/multidelphi/blob/ce124df197d3780d354695ada7b077501a28bbc6/etc/delphi-cparser-linux/delphi.y

/*Tokens*/
%token KW_LIBRARY
%token KW_UNIT
%token KW_PROGRAM
//%token KW_PACKAGE
//%token KW_REQUIRES
//%token KW_CONTAINS
%token KW_USES
%token KW_EXPORTS
//%token KW_PLATFORM
//%token KW_DEPRECATED
%token KW_INTERF
%token KW_IMPL
%token KW_FINALIZ
%token KW_INIT
%token KW_OBJECT
%token KW_RECORD
%token KW_CLASS
%token KW_FUNCTION
%token KW_PROCEDURE
%token KW_PROPERTY
%token KW_OF
%token KW_OUT
%token KW_PACKED
%token KW_INHERITED
%token KW_PROTECTED
%token KW_PUBLIC
%token KW_PUBLISHED
%token KW_PRIVATE
%token KW_CONST
%token KW_VAR
%token KW_THRVAR
%token KW_TYPE
%token KW_CONSTRUCTOR
%token KW_DESTRUCTOR
%token KW_ASM
%token KW_BEGIN
%token KW_END
%token KW_WITH
%token KW_DO
%token KW_FOR
%token KW_TO
%token KW_DOWNTO
%token KW_REPEAT
%token KW_UNTIL
%token KW_WHILE
%token KW_IF
%token KW_THEN
%token KW_ELSE
%token KW_CASE
%token KW_GOTO
%token KW_LABEL
%token KW_RAISE
%token KW_AT
%token KW_TRY
%token KW_EXCEPT
%token KW_FINALLY
%token KW_ON
%token KW_ABSOLUTE
%token KW_ABSTRACT
%token KW_ASSEMBLER
%token KW_DYNAMIC
%token KW_EXPORT
%token KW_EXTERNAL
%token KW_FORWARD
%token KW_INLINE
%token KW_OVERRIDE
%token KW_OVERLOAD
%token KW_REINTRODUCE
%token KW_VIRTUAL
%token KW_VARARGS
%token KW_PASCAL
%token KW_SAFECALL
%token KW_STDCALL
%token KW_CDECL
%token KW_REGISTER
%token KW_NAME
//%token KW_READ
//%token KW_WRITE
%token KW_INDEX
//%token KW_STORED
//%token KW_DEFAULT
//%token KW_NODEFAULT
//%token KW_IMPLEMENTS
%token TYPE_INT64
%token TYPE_INT
%token TYPE_LONGINT
%token TYPE_LONGWORD
%token TYPE_SMALLINT
%token TYPE_SHORTINT
%token TYPE_WORD
%token TYPE_BYTE
%token TYPE_CARDINAL
%token TYPE_UINT64
%token TYPE_CHAR
%token TYPE_PCHAR
%token TYPE_WIDECHAR
%token TYPE_WIDESTR
%token TYPE_STR
//%token TYPE_RSCSTR
%token TYPE_SHORTSTR
%token TYPE_FLOAT
%token TYPE_REAL48
%token TYPE_DOUBLE
%token TYPE_EXTENDED
%token TYPE_BOOL
%token TYPE_COMP
//%token TYPE_CURRENCY
%token TYPE_OLEVAR
%token TYPE_VAR
%token TYPE_ARRAY
%token TYPE_CURR
%token TYPE_FILE
%token TYPE_PTR
%token TYPE_SET
%token ASM_OP
%token CONST_INT
%token CONST_REAL
%token CONST_CHAR
%token CONST_STR
%token IDENTIFIER
%token CONST_NIL
%token CONST_BOOL
%token KW_RANGE
%token COMMA
%token COLON
%token SEMICOL
%token KW_ASSIGN
%token KW_EQ
%token KW_GT
%token KW_LT
%token KW_LE
%token KW_GE
%token KW_DIFF
%token KW_IN
%token KW_IS
%token KW_SUM
%token KW_SUB
%token KW_OR
%token KW_XOR
%token KW_MUL
%token KW_DIV
%token KW_QUOT
%token KW_MOD
%token KW_SHL
%token KW_SHR
%token KW_AS
%token KW_AND
%token KW_DEREF
%token KW_DOT
%token KW_NOT
%token KW_ADDR
%token LBRAC
%token RBRAC
%token LPAREN
%token RPAREN

%nonassoc /*1*/ LOWESTPREC EXPR_SINGLE
%right /*2*/ KW_THEN
%right /*3*/ KW_ELSE
%nonassoc /*4*/ KW_RANGE COMMA COLON SEMICOL KW_ASSIGN
%left /*5*/ KW_EQ KW_GT KW_LT KW_LE KW_GE KW_DIFF KW_IN KW_IS
%left /*6*/ KW_SUM KW_SUB KW_OR KW_XOR
%left /*7*/ KW_MUL KW_DIV KW_QUOT KW_MOD KW_SHL KW_SHR KW_AS KW_AND
%left /*8*/ KW_DEREF KW_DOT
%left /*9*/ UNARY KW_NOT KW_ADDR
%nonassoc /*10*/ LBRAC RBRAC LPAREN RPAREN
%nonassoc /*11*/ MAXPREC

%start goal

%%

goal :
	file KW_DOT /*8L*/
	;

file :
	program
	| package
	| library
	| unit
	;

program :
	KW_PROGRAM id SEMICOL /*4N*/ usesclauseopt main_block
	| usesclauseopt main_block
	;

library :
	KW_LIBRARY id SEMICOL /*4N*/ usesclauseopt main_block
	;

unit :
	KW_UNIT id SEMICOL /*4N*/ interfsec implementsec initsec
	;

package :
	id id SEMICOL /*4N*/ requiresclause containsclause KW_END
	;

requiresclause :
	id idlist SEMICOL /*4N*/
	;

containsclause :
	id idlist SEMICOL /*4N*/
	;

usesclauseopt :
	/*empty*/
	| KW_USES useidlist SEMICOL /*4N*/
	;

useidlist :
	useid
	| useidlist COMMA /*4N*/ useid
	;

useid :
	id
	| id KW_IN /*5L*/ string_const
	;

implementsec :
	KW_IMPL usesclauseopt maindecllist
	| KW_IMPL usesclauseopt
	;

interfsec :
	KW_INTERF usesclauseopt interfdecllist
	;

interfdecllist :
	/*empty*/
	| interfdecllist interfdecl
	;

initsec :
	KW_INIT stmtlist KW_END
	| KW_FINALIZ stmtlist KW_END
	| KW_INIT stmtlist KW_FINALIZ stmtlist KW_END
	| block
	| KW_END
	;

main_block :
	maindecllist block
	| block
	;

maindecllist :
	maindeclsec
	| maindecllist maindeclsec
	;

declseclist :
	funcdeclsec
	| declseclist funcdeclsec
	;

interfdecl :
	basicdeclsec
	| staticclassopt procproto
	| thrvarsec
	;

maindeclsec :
	basicdeclsec
	| thrvarsec
	| exportsec
	| staticclassopt procdeclnondef
	| staticclassopt procdefinition
	| labeldeclsec
	;

funcdeclsec :
	basicdeclsec
	| labeldeclsec
	| procdefinition
	| procdeclnondef
	;

basicdeclsec :
	constsec
	| typesec
	| varsec
	;

typesec :
	KW_TYPE typedecl
	| typesec typedecl
	;

labeldeclsec :
	KW_LABEL labelidlist SEMICOL /*4N*/
	;

labelidlist :
	labelid
	| labelidlist COMMA /*4N*/ labelid
	;

labelid :
	CONST_INT
	| id
	;

exportsec :
	KW_EXPORTS exportsitemlist
	;

exportsitemlist :
	exportsitem
	| exportsitemlist COMMA /*4N*/ exportsitem
	;

exportsitem :
	id
	| id KW_NAME string_const
	| id KW_INDEX expr
	;

procdeclnondef :
	procdefproto func_nondef_list funcdir_strict_opt
	;

procdefinition :
	procdefproto proc_define SEMICOL /*4N*/
	;

procdefproto :
	procbasickind qualid formalparams funcretopt SEMICOL /*4N*/ funcdir_strict_opt
	;

procproto :
	procbasickind qualid formalparams funcretopt SEMICOL /*4N*/ funcdirectopt
	;

funcretopt :
	/*empty*/
	| COLON /*4N*/ funcrettype
	;

staticclassopt :
	/*empty*/
	| KW_CLASS
	;

procbasickind :
	KW_FUNCTION
	| KW_PROCEDURE
	| KW_CONSTRUCTOR
	| KW_DESTRUCTOR
	;

proceduretype :
	KW_PROCEDURE formalparams ofobjectopt
	| KW_FUNCTION formalparams COLON /*4N*/ funcrettype ofobjectopt
	;

ofobjectopt :
	/*empty*/
	| KW_OF KW_OBJECT
	;

proc_define :
	func_block
	| assemblerstmt
	;

func_block :
	declseclist block
	| block
	;

formalparams :
	/*empty*/
	| LPAREN /*10N*/ RPAREN /*10N*/
	| LPAREN /*10N*/ formalparamslist RPAREN /*10N*/
	;

formalparamslist :
	formalparm
	| formalparamslist SEMICOL /*4N*/ formalparm
	;

formalparm :
	paramqualif idlist paramtypeopt
	| idlist paramtypespec paraminitopt
	| KW_CONST idlist paramtypeopt paraminitopt
	;

paramqualif :
	KW_VAR
	| KW_OUT
	;

paramtypeopt :
	/*empty*/
	| paramtypespec
	;

paramtypespec :
	COLON /*4N*/ funcparamtype
	;

paraminitopt :
	/*empty*/
	| KW_EQ /*5L*/ expr
	;

funcdirectopt :
	/*empty*/
	| funcdirective_list SEMICOL /*4N*/
	;

funcdirectopt_nonterm :
	/*empty*/
	| funcdirective_list
	;

funcdir_strict_opt :
	/*empty*/
	| funcdir_strict_list
	;

funcdirective_list :
	funcdirective
	| funcdirective_list SEMICOL /*4N*/ funcdirective
	;

funcdir_strict_list :
	funcdir_strict SEMICOL /*4N*/
	| funcdir_strict_list funcdir_strict SEMICOL /*4N*/
	;

func_nondef_list :
	funcdir_nondef SEMICOL /*4N*/
	| func_nondef_list funcdir_nondef SEMICOL /*4N*/
	;

funcdirective :
	funcdir_strict
	| funcdir_nondef
	;

funcdir_strict :
	funcqualif
	| funccallconv
	;

funcdir_nondef :
	KW_EXTERNAL string_const externarg
	| KW_EXTERNAL qualid externarg
	| KW_EXTERNAL
	| KW_FORWARD
	;

externarg :
	/*empty*/
	| id string_const
	| id qualid
	;

funcqualif :
	KW_ABSOLUTE
	| KW_ABSTRACT
	| KW_ASSEMBLER
	| KW_DYNAMIC
	| KW_EXPORT
	| KW_INLINE
	| KW_OVERRIDE
	| KW_OVERLOAD
	| KW_REINTRODUCE
	| KW_VIRTUAL
	| KW_VARARGS
	;

funccallconv :
	KW_PASCAL
	| KW_SAFECALL
	| KW_STDCALL
	| KW_CDECL
	| KW_REGISTER
	;

block :
	KW_BEGIN stmtlist KW_END
	;

stmtlist :
	stmt SEMICOL /*4N*/ stmtlist
	| stmt
	;

stmt :
	nonlbl_stmt
	| labelid COLON /*4N*/ nonlbl_stmt
	;

nonlbl_stmt :
	/*empty*/
	| inheritstmts
	| goto_stmt
	| block
	| ifstmt
	| casestmt
	| repeatstmt
	| whilestmt
	| forstmt
	| with_stmt
	| tryexceptstmt
	| tryfinallystmt
	| raisestmt
	| assemblerstmt
	;

inheritstmts :
	KW_INHERITED
	| KW_INHERITED assign
	| KW_INHERITED proccall
	| proccall
	| assign
	;

assign :
	lvalue KW_ASSIGN /*4N*/ expr
	| lvalue KW_ASSIGN /*4N*/ KW_INHERITED expr
	;

goto_stmt :
	KW_GOTO labelid
	;

ifstmt :
	KW_IF expr KW_THEN /*2R*/ nonlbl_stmt KW_ELSE /*3R*/ nonlbl_stmt
	| KW_IF expr KW_THEN /*2R*/ nonlbl_stmt
	;

casestmt :
	KW_CASE expr KW_OF caseselectorlist else_case KW_END
	;

else_case :
	/*empty*/
	| KW_ELSE /*3R*/ nonlbl_stmt
	| KW_ELSE /*3R*/ nonlbl_stmt SEMICOL /*4N*/
	;

caseselectorlist :
	caseselector
	| caseselectorlist SEMICOL /*4N*/ caseselector
	;

caseselector :
	/*empty*/
	| caselabellist COLON /*4N*/ nonlbl_stmt
	;

caselabellist :
	caselabel
	| caselabellist COMMA /*4N*/ caselabel
	;

caselabel :
	expr
	| expr KW_RANGE /*4N*/ expr
	;

repeatstmt :
	KW_REPEAT stmtlist KW_UNTIL expr
	;

whilestmt :
	KW_WHILE expr KW_DO nonlbl_stmt
	;

forstmt :
	KW_FOR id KW_ASSIGN /*4N*/ expr KW_TO expr KW_DO nonlbl_stmt
	| KW_FOR id KW_ASSIGN /*4N*/ expr KW_DOWNTO expr KW_DO nonlbl_stmt
	;

with_stmt :
	KW_WITH exprlist KW_DO nonlbl_stmt
	;

tryexceptstmt :
	KW_TRY stmtlist KW_EXCEPT exceptionblock KW_END
	;

exceptionblock :
	onlist KW_ELSE /*3R*/ stmtlist
	| onlist
	| stmtlist
	;

onlist :
	ondef
	| onlist ondef
	;

ondef :
	KW_ON id COLON /*4N*/ id KW_DO nonlbl_stmt SEMICOL /*4N*/
	| KW_ON id KW_DO nonlbl_stmt SEMICOL /*4N*/
	;

tryfinallystmt :
	KW_TRY stmtlist KW_FINALLY stmtlist KW_END
	;

raisestmt :
	KW_RAISE
	| KW_RAISE lvalue
	| KW_RAISE KW_AT expr
	| KW_RAISE lvalue KW_AT expr
	;

assemblerstmt :
	KW_ASM asmcode KW_END
	;

asmcode :
	ASM_OP
	| asmcode ASM_OP
	;

varsec :
	KW_VAR vardecllist
	;

thrvarsec :
	KW_THRVAR vardecllist
	;

vardecllist :
	vardecl
	| vardecllist vardecl
	;

vardecl :
	idlist COLON /*4N*/ vartype vardeclopt SEMICOL /*4N*/
	| idlist COLON /*4N*/ proceduretype SEMICOL /*4N*/ funcdirectopt
	| idlist COLON /*4N*/ proceduretype SEMICOL /*4N*/ funcdirectopt_nonterm KW_EQ /*5L*/ CONST_NIL SEMICOL /*4N*/
	;

vardeclopt :
	/*empty*/
	| KW_ABSOLUTE id
	| KW_EQ /*5L*/ constexpr
	;

proccall :
	id
	| lvalue KW_DOT /*8L*/ id
	| lvalue LPAREN /*10N*/ exprlistopt RPAREN /*10N*/
	| lvalue LPAREN /*10N*/ casttype RPAREN /*10N*/
	;

lvalue :
	proccall
	| expr KW_DEREF /*8L*/
	| lvalue LBRAC /*10N*/ exprlist RBRAC /*10N*/
	| string_const LBRAC /*10N*/ exprlist RBRAC /*10N*/
	| casttype LPAREN /*10N*/ exprlistopt RPAREN /*10N*/
	;

expr :
	literal
	| lvalue
	| setconstructor
	| KW_ADDR /*9L*/ expr
	| KW_NOT /*9L*/ expr
	| sign expr %prec UNARY /*9L*/
	| LPAREN /*10N*/ expr RPAREN /*10N*/
	| expr relop expr %prec KW_EQ /*5L*/
	| expr addop expr %prec KW_SUB /*6L*/
	| expr mulop expr %prec KW_MUL /*7L*/
	;

sign :
	KW_SUB /*6L*/
	| KW_SUM /*6L*/
	;

mulop :
	KW_MUL /*7L*/
	| KW_DIV /*7L*/
	| KW_QUOT /*7L*/
	| KW_MOD /*7L*/
	| KW_SHR /*7L*/
	| KW_SHL /*7L*/
	| KW_AND /*7L*/
	;

addop :
	KW_SUB /*6L*/
	| KW_SUM /*6L*/
	| KW_OR /*6L*/
	| KW_XOR /*6L*/
	;

relop :
	KW_EQ /*5L*/
	| KW_DIFF /*5L*/
	| KW_LT /*5L*/
	| KW_LE /*5L*/
	| KW_GT /*5L*/
	| KW_GE /*5L*/
	| KW_IN /*5L*/
	| KW_IS /*5L*/
	| KW_AS /*7L*/
	;

literal :
	CONST_INT
	| CONST_BOOL
	| CONST_REAL
	| CONST_NIL
	| string_const
	;

discrete :
	CONST_INT
	| CONST_CHAR
	| CONST_BOOL
	;

string_const :
	CONST_STR
	| CONST_CHAR
	| string_const CONST_STR
	| string_const CONST_CHAR
	;

id :
	IDENTIFIER
	| KW_NAME
	| KW_INDEX
	;

idlist :
	id
	| idlist COMMA /*4N*/ id
	;

qualid :
	id
	| qualid KW_DOT /*8L*/ id
	;

exprlist :
	expr
	| exprlist COMMA /*4N*/ expr
	;

exprlistopt :
	/*empty*/
	| exprlist
	;

rangetype :
	sign rangestart KW_RANGE /*4N*/ expr
	| rangestart KW_RANGE /*4N*/ expr
	;

rangestart :
	discrete
	| qualid
	| id LPAREN /*10N*/ casttype RPAREN /*10N*/
	| id LPAREN /*10N*/ literal RPAREN /*10N*/
	;

enumtype :
	LPAREN /*10N*/ enumtypeellist RPAREN /*10N*/
	;

enumtypeellist :
	enumtypeel
	| enumtypeellist COMMA /*4N*/ enumtypeel
	;

enumtypeel :
	id
	| id KW_EQ /*5L*/ expr
	;

setconstructor :
	LBRAC /*10N*/ RBRAC /*10N*/
	| LBRAC /*10N*/ setlist RBRAC /*10N*/
	;

setlist :
	setelem
	| setlist COMMA /*4N*/ setelem
	;

setelem :
	expr
	| expr KW_RANGE /*4N*/ expr
	;

constsec :
	KW_CONST constdecl
	| constsec constdecl
	;

constdecl :
	id KW_EQ /*5L*/ constexpr SEMICOL /*4N*/
	| id COLON /*4N*/ vartype KW_EQ /*5L*/ constexpr SEMICOL /*4N*/
	;

constexpr :
	expr
	| arrayconst
	| recordconst
	;

arrayconst :
	LPAREN /*10N*/ constexpr COMMA /*4N*/ constexprlist RPAREN /*10N*/
	;

constexprlist :
	constexpr
	| constexprlist COMMA /*4N*/ constexpr
	;

recordconst :
	LPAREN /*10N*/ fieldconstlist RPAREN /*10N*/
	| LPAREN /*10N*/ fieldconstlist SEMICOL /*4N*/ RPAREN /*10N*/
	;

fieldconstlist :
	fieldconst
	| fieldconstlist SEMICOL /*4N*/ fieldconst
	;

fieldconst :
	id COLON /*4N*/ constexpr
	;

classtype :
	class_keyword heritage class_struct_opt KW_END
	| class_keyword heritage
	;

class_keyword :
	KW_CLASS
	| KW_OBJECT
	| KW_RECORD
	;

heritage :
	/*empty*/
	| LPAREN /*10N*/ idlist RPAREN /*10N*/
	;

class_struct_opt :
	fieldlist complist scopeseclist
	;

scopeseclist :
	/*empty*/
	| scopeseclist scopesec
	;

scopesec :
	scope_decl fieldlist complist
	;

scope_decl :
	KW_PUBLISHED
	| KW_PUBLIC
	| KW_PROTECTED
	| KW_PRIVATE
	;

fieldlist :
	/*empty*/
	| fieldlist objfield
	;

complist :
	/*empty*/
	| complist class_comp
	;

objfield :
	idlist COLON /*4N*/ type SEMICOL /*4N*/
	;

class_comp :
	staticclassopt procproto
	| property
	;

interftype :
	KW_INTERF heritage classmethodlistopt classproplistopt KW_END
	;

classmethodlistopt :
	methodlist
	| /*empty*/
	;

methodlist :
	procproto
	| methodlist procproto
	;

classproplistopt :
	classproplist
	| /*empty*/
	;

classproplist :
	property
	| classproplist property
	;

property :
	KW_PROPERTY id SEMICOL /*4N*/
	| KW_PROPERTY id propinterfopt COLON /*4N*/ funcrettype indexspecopt propspecifiers SEMICOL /*4N*/ defaultdiropt
	;

defaultdiropt :
	/*empty*/
	| id SEMICOL /*4N*/
	;

propinterfopt :
	/*empty*/
	| LBRAC /*10N*/ idlisttypeidlist RBRAC /*10N*/
	;

idlisttypeidlist :
	idlisttypeid
	| idlisttypeidlist SEMICOL /*4N*/ idlisttypeid
	;

idlisttypeid :
	idlist COLON /*4N*/ funcparamtype
	| KW_CONST idlist COLON /*4N*/ funcparamtype
	;

indexspecopt :
	/*empty*/
	| KW_INDEX expr
	;

propspecifiers :
	/*empty*/
	| id id
	| id id id id
	| id id id id id id
	| id id id id id id id id
	| id id id id id id id id id id
	;

typedecl :
	id KW_EQ /*5L*/ typeopt vartype SEMICOL /*4N*/
	| id KW_EQ /*5L*/ typeopt proceduretype SEMICOL /*4N*/ funcdirectopt
	;

typeopt :
	/*empty*/
	| KW_TYPE
	;

type :
	vartype
	| proceduretype
	;

vartype :
	simpletype
	| enumtype
	| rangetype
	| varianttype
	| refpointertype
	| classreftype
	| KW_PACKED packedtype
	| packedtype
	;

packedtype :
	structype
	| restrictedtype
	;

classreftype :
	KW_CLASS KW_OF scalartype
	;

simpletype :
	scalartype
	| realtype
	| stringtype
	| TYPE_PTR
	;

ordinaltype :
	enumtype
	| rangetype
	| scalartype
	;

scalartype :
	inttype
	| chartype
	| qualid
	;

realtype :
	TYPE_REAL48
	| TYPE_FLOAT
	| TYPE_DOUBLE
	| TYPE_EXTENDED
	| TYPE_CURR
	| TYPE_COMP
	;

inttype :
	TYPE_BYTE
	| TYPE_BOOL
	| TYPE_INT
	| TYPE_SHORTINT
	| TYPE_SMALLINT
	| TYPE_LONGINT
	| TYPE_INT64
	| TYPE_UINT64
	| TYPE_WORD
	| TYPE_LONGWORD
	| TYPE_CARDINAL
	;

chartype :
	TYPE_CHAR
	| TYPE_WIDECHAR
	;

stringtype :
	TYPE_STR
	| TYPE_PCHAR
	| TYPE_STR LBRAC /*10N*/ expr RBRAC /*10N*/
	| TYPE_SHORTSTR
	| TYPE_WIDESTR
	;

varianttype :
	TYPE_VAR
	| TYPE_OLEVAR
	;

structype :
	arraytype
	| settype
	| filetype
	;

restrictedtype :
	classtype
	| interftype
	;

arraysizelist :
	rangetype
	| arraysizelist COMMA /*4N*/ rangetype
	;

arraytype :
	TYPE_ARRAY LBRAC /*10N*/ arraytypedef RBRAC /*10N*/ KW_OF type
	| TYPE_ARRAY KW_OF type
	;

arraytypedef :
	arraysizelist
	| inttype
	| chartype
	| qualid
	;

settype :
	TYPE_SET KW_OF ordinaltype
	;

filetype :
	TYPE_FILE KW_OF type
	| TYPE_FILE
	;

refpointertype :
	KW_DEREF /*8L*/ type
	;

funcparamtype :
	simpletype
	| TYPE_ARRAY KW_OF simpletype
	;

funcrettype :
	simpletype
	;

casttype :
	inttype
	| chartype
	| realtype
	| stringtype
	| TYPE_PTR
	;

%%

%option caseless

%x XCOMMENT1 XCOMMENT2 ASMCODESEC ASMCODESEC_BT

%%

	/* file type */
library		KW_LIBRARY
unit		KW_UNIT
program		KW_PROGRAM

	/* dependencies */
uses		KW_USES
exports		KW_EXPORTS

	/* units keywords */
interface	KW_INTERF
implementation	KW_IMPL
finalization	KW_FINALIZ
initialization	KW_INIT

	/* objects */
object		KW_OBJECT
record		KW_RECORD
class		KW_CLASS
packed		KW_PACKED		// packed struct
of			KW_OF			// decl of types

	/* functions */
function	KW_FUNCTION
procedure	KW_PROCEDURE
property	KW_PROPERTY
inherited	KW_INHERITED	// call of base construcotr/methods

	/* section headers */
const		KW_CONST
var			KW_VAR
out			KW_OUT			// modifier of func params
threadvar	KW_THRVAR
type		KW_TYPE
constructor	KW_CONSTRUCTOR
destructor	KW_DESTRUCTOR

	/* blocks */
begin		KW_BEGIN
end			KW_END
with		KW_WITH		// with x do ..
do			KW_DO

	/* control flow: loops */
for			KW_FOR
to			KW_TO
downto		KW_DOWNTO
repeat		KW_REPEAT
until		KW_UNTIL
while		KW_WHILE

	/* control flow: others */
if			KW_IF
then		KW_THEN
else		KW_ELSE
case		KW_CASE		/* switch */
goto		KW_GOTO
label		KW_LABEL

	/* control flow: exceptions */
raise		KW_RAISE
at			KW_AT	// ex: raise excpt at address
try			KW_TRY
except		KW_EXCEPT
finally		KW_FINALLY
on			KW_ON


	/*****************************************************************
	 * Directives:
	 * Should be treated as identifiers instead of reserved keywords
	 *****************************************************************
	 */
index		KW_INDEX
name		KW_NAME

	/*	properties keywords
	default		KW_DEFAULT
	implements	KW_IMPLEMENTS
	nodefault	KW_NODEFAULT
	read		KW_READ
	stored		KW_STORED
	write		KW_WRITE
	*/

	/* scope qualifiers */
protected	KW_PROTECTED
public		KW_PUBLIC
published	KW_PUBLISHED
private		KW_PRIVATE

	/* function call types */
cdecl		KW_CDECL
pascal		KW_PASCAL
mwpascal		KW_PASCAL
register	KW_REGISTER
safecall	KW_SAFECALL
stdcall		KW_STDCALL

	/* function qualifiers */
absolute	KW_ABSOLUTE
abstract	KW_ABSTRACT
assembler	KW_ASSEMBLER
dynamic		KW_DYNAMIC
export		KW_EXPORT
external	KW_EXTERNAL
forward		KW_FORWARD
inline		KW_INLINE
override	KW_OVERRIDE
overload	KW_OVERLOAD
reintroduce	KW_REINTRODUCE
virtual		KW_VIRTUAL
varargs		KW_VARARGS

	/* file warnings */
//platform	KW_PLATFORM
//deprecated	KW_DEPRECATED

	/* packages
	package		KW_PACKAGE
	requires	KW_REQUIRES
	contains	KW_CONTAINS
	*/

	/* Embarcadero Delphi directives - ignored
	delayed experimental final
	helper operator reference
	sealed static strict unsafe
	*/

	/*		// windows/forms/COM specific - ignored

	winapi		KW_WINAPI
	message		KW_MESSAGE
	dispinterface	KW_DISPINTERF
	dispid		KW_DISPID
	automated	KW_AUTOMATED	// visibilidade
		// properties modifiers for dispinterface
	writeonly	KW_WRITEONLY
	readonly	KW_READONLY
		// DOS deprecated
	far			KW_FAR
	near		KW_NEAR
	resident	KW_RESIDENT
	*/


\{\$[^}]+\}	skip()	/* ignore compiler funcdirectives */


	/* types: integers */
byte		TYPE_BYTE
shortint	TYPE_SHORTINT
word		TYPE_WORD
smallint	TYPE_SMALLINT
cardinal	TYPE_CARDINAL
integer		TYPE_INT
longword	TYPE_LONGWORD
longint		TYPE_LONGINT
int64		TYPE_INT64
uint64		TYPE_UINT64

	/* types: floats */
single		TYPE_FLOAT
real48		TYPE_REAL48
extended	TYPE_EXTENDED
double		TYPE_DOUBLE
real		TYPE_DOUBLE

	/* types: chars */
char		TYPE_CHAR
pchar		TYPE_PCHAR
ansichar	TYPE_PCHAR
widechar	TYPE_WIDECHAR
string		TYPE_STR
shortstring	TYPE_SHORTSTR
widestring	TYPE_WIDESTR
ansistring	TYPE_STR
//resourcestring	TYPE_RSCSTR

	/* types others */
boolean		TYPE_BOOL
olevariant	TYPE_OLEVAR
variant		TYPE_VAR
comp		TYPE_COMP
currency	TYPE_CURR
array		TYPE_ARRAY
pointer		TYPE_PTR
file		TYPE_FILE
set			TYPE_SET


	/* ASM x86 */

asm<ASMCODESEC>	KW_ASM

<ASMCODESEC>[ \t\r]+	skip()
<ASMCODESEC>end;<ASMCODESEC_BT>
<ASMCODESEC>\n			skip()
<ASMCODESEC>.			ASM_OP	// ASM unknown char

// HACK!!! temporary. must change
<ASMCODESEC_BT> {
	end	KW_END
	.<INITIAL>	reject()
}



	/* literals: numeric */
[0-9]+			CONST_INT
\$[0-9a-z]+		CONST_INT		// convert hex=>int here
nil				CONST_NIL
[0-9]+\.[0-9]+	CONST_REAL
[0-9]+e[+-]?[0-9]+	CONST_REAL
[0-9]+\.[0-9]+e[+-]?[0-9]+	CONST_REAL

	/* literals: alpha */
\'.\'			CONST_CHAR
\#[0-9]+		CONST_CHAR
\#\$[0-9a-f]+	CONST_CHAR
''				CONST_STR
'(''|[^'])*'			CONST_STR

true			CONST_BOOL
false			CONST_BOOL


	/* separators */
":"			COLON
","			COMMA
";"			SEMICOL
"["			LBRAC
"("			LPAREN
"]"			RBRAC
")"			RPAREN


	/* expr: general */
":="		KW_ASSIGN
".."		KW_RANGE
as			KW_AS	// cast

	/* expr: unary pointer access */
"."			KW_DOT
"@"			KW_ADDR
"^"			KW_DEREF

	/* expr: numeric operators */
"-"			KW_SUB
"+"			KW_SUM
"/"			KW_DIV
"*"			KW_MUL
div			KW_QUOT
mod			KW_MOD

	/* expr: logical operators */
and			KW_AND
or			KW_OR
xor			KW_XOR
shl			KW_SHL
shr			KW_SHR
not			KW_NOT

	/* expr: comparison operators */
"<"			KW_LT
">"			KW_GT
">="		KW_GE
"<="		KW_LE
"="			KW_EQ
"<>"		KW_DIFF
"is"		KW_IS	// type comp
"in"		KW_IN	// is in set


[_a-z][_a-z0-9]*	IDENTIFIER


"//".*		skip()	// single line comment

				/* multi-line comments */
\{<XCOMMENT1>
<XCOMMENT1>\}<INITIAL>	skip()
<XCOMMENT1>.	skip()
<XCOMMENT1>\n	skip()

\(\*<XCOMMENT2>
<XCOMMENT2>\*\)<INITIAL>	skip()
<XCOMMENT2>.	skip()
<XCOMMENT2>\n	skip()



[ \r\t]+        skip()       /* ignore whitespace */

\n				skip()

//.               sprintf(buf, "Unknown character: %c, ascii %d", yytext[0], yytext[0])

%%
