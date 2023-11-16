//From: https://github.com/diku-dk/futhark/blob/4add83b18159ffa57306f2bf70355e5946777b16/src/Language/Futhark/Parser/Parser.y
// | Futhark parser written with Happy.

/*
%name prog Prog
%name futharkType TypeExp
%name expression Exp
%name modExpression ModExp
%name declaration Dec
*/
/*
%token
      if              { L $$ IF }
      then            { L $$ THEN }
      else            { L $$ ELSE }
      let             { L $$ LET }
      def             { L $$ DEF }
      loop            { L $$ LOOP }
      in              { L $$ IN }
      match           { L $$ MATCH }
      case            { L $$ CASE }

      id              { L _ (ID _) }
      "...["          { L _ INDEXING }

      constructor     { L _ (CONSTRUCTOR _) }

      natlit          { L _ (NATLIT _ _) }
      intlit          { L _ (INTLIT _) }
      i8lit           { L _ (I8LIT _) }
      i16lit          { L _ (I16LIT _) }
      i32lit          { L _ (I32LIT _) }
      i64lit          { L _ (I64LIT _) }
      u8lit           { L _ (U8LIT _) }
      u16lit          { L _ (U16LIT _) }
      u32lit          { L _ (U32LIT _) }
      u64lit          { L _ (U64LIT _) }
      floatlit        { L _ (FLOATLIT _) }
      f16lit          { L _ (F16LIT _) }
      f32lit          { L _ (F32LIT _) }
      f64lit          { L _ (F64LIT _) }
      stringlit       { L _ (STRINGLIT _) }
      charlit         { L _ (CHARLIT _) }

      '.'             { L $$ DOT }
      ".."            { L $$ TWO_DOTS }
      "..."           { L $$ THREE_DOTS }
      "..<"           { L $$ TWO_DOTS_LT }
      "..>"           { L $$ TWO_DOTS_GT }
      '='             { L $$ EQU }

      '*'             { L $$ ASTERISK }
      '-'             { L $$ NEGATE }
      '!'             { L $$ BANG }
      '<'             { L $$ LTH }
      '^'             { L $$ HAT }
      '~'             { L $$ TILDE }
      '|'             { L $$ PIPE  }

      "+..."          { L _ (SYMBOL Plus _ _) }
      "-..."          { L _ (SYMBOL Minus _ _) }
      "*..."          { L _ (SYMBOL Times _ _) }
      Divide          { L _ (SYMBOL Divide _ _) }
      "%..."          { L _ (SYMBOL Mod _ _) }
      "//..."         { L _ (SYMBOL Quot _ _) }
      "%%..."         { L _ (SYMBOL Rem _ _) }
      "==..."         { L _ (SYMBOL Equal _ _) }
      "!=..."         { L _ (SYMBOL NotEqual _ _) }
      "<..."          { L _ (SYMBOL Less _ _) }
      ">..."          { L _ (SYMBOL Greater _ _) }
      "<=..."         { L _ (SYMBOL Leq _ _) }
      ">=..."         { L _ (SYMBOL Geq _ _) }
      "**..."         { L _ (SYMBOL Pow _ _) }
      "<<..."         { L _ (SYMBOL ShiftL _ _) }
      ">>..."         { L _ (SYMBOL ShiftR _ _) }
      "|>..."         { L _ (SYMBOL PipeRight _ _) }
      "<|..."         { L _ (SYMBOL PipeLeft _ _) }
      "|..."          { L _ (SYMBOL Bor _ _) }
      "&..."          { L _ (SYMBOL Band _ _) }
      "^..."          { L _ (SYMBOL Xor _ _) }
      "||..."         { L _ (SYMBOL LogOr _ _) }
      "&&..."         { L _ (SYMBOL LogAnd _ _) }
      "!..."          { L _ (SYMBOL Bang _ _) }
      "=..."          { L _ (SYMBOL Equ _ _) }

      '('             { L $$ LPAR }
      ')'             { L $$ RPAR }
      '{'             { L $$ LCURLY }
      '}'             { L $$ RCURLY }
      '['             { L $$ LBRACKET }
      ']'             { L $$ RBRACKET }
      "#["            { L $$ HASH_LBRACKET }
      ','             { L $$ COMMA }
      '_'             { L $$ UNDERSCORE }
      "\\"            { L $$ BACKSLASH }
      '\''            { L $$ APOSTROPHE }
      '\'^'           { L $$ APOSTROPHE_THEN_HAT }
      '\'~'           { L $$ APOSTROPHE_THEN_TILDE }
      '`'             { L $$ BACKTICK }
      entry           { L $$ ENTRY }
      "->"            { L $$ RIGHT_ARROW }
      ':'             { L $$ COLON }
      ":>"            { L $$ COLON_GT }
      '?'             { L $$ QUESTION_MARK  }
      for             { L $$ FOR }
      do              { L $$ DO }
      with            { L $$ WITH }
      assert          { L $$ ASSERT }
      true            { L $$ TRUE }
      false           { L $$ FALSE }
      while           { L $$ WHILE }
      include         { L $$ INCLUDE }
      import          { L $$ IMPORT }
      type            { L $$ TYPE }
      module          { L $$ MODULE }
      val             { L $$ VAL }
      open            { L $$ OPEN }
      local           { L $$ LOCAL }
      doc             { L _  (DOC _) }
      hole            { L $$ HOLE }
*/

%token assert
%token charlit
%token def
%token do
%token doc
%token else
%token entry
%token f16lit
%token f32lit
%token f64lit
%token false
%token floatlit
%token for
%token hole
%token i16lit
%token i32lit
%token i64lit
%token i8lit
%token if
%token import
%token in
%token include
%token intlit
%token let
%token local
%token loop
%token match
%token module
%token natlit
%token open
%token stringlit
%token then
%token true
%token type
%token u16lit
%token u32lit
%token u64lit
%token u8lit
%token val
%token while

%left bottom
%left ifprec letprec caseprec typeprec sumprec
%left ',' case id constructor '(' '{'
%right ':' ":>"
%right "..." TWO_DOTS_LT TWO_DOTS_GT ".."
%left '`'
%right "->"
%left with
%left '='
%left PipeRight
%right PipeLeft
%left LogOr
%left LogAnd
%left Leq Geq Greater '<' Less Equal NotEqual Bang Equ
%left Band Xor '^' Bor '|'
%left ShiftL ShiftR
%left Plus Minus '-'
%left Times '*' Divide Mod Quot Rem
%left Pow
%left juxtprec
%left '[' INDEXING
%left top

%start Prog

%%

// The main parser.

Doc
	: doc
	;

// Four cases to avoid ambiguities.
Prog
	// File begins with a file comment, followed by a Dec with a comment.
	: Doc Doc Dec_ Decs
	// File begins with a file comment, followed by a Dec with no comment.
	| Doc Dec_ Decs
	// File begins with a dec with no comment.
	| Dec_ Decs
	// File is empty.
	| /*EMPTY*/
	;

Dec
	: Dec_
	| Doc Dec_
	;

Decs
	: Decs_
	;

Decs_
	:
	| Decs_ Dec
	;

Dec_
	: Val
	| TypeAbbr
	| SigBind
	| ModBind
	| open ModExp
	| import stringlit
	| local Dec
	| "#[" AttrInfo ']' Dec_
	;

SigExp
	: QualName
	| '{' Specs '}'
	| SigExp with TypeRef
	| '(' SigExp ')'
	| '(' id ':' SigExp ')' "->" SigExp
	| SigExp "->" SigExp
	;

TypeRef
	: QualName TypeParams '=' TypeExpTerm
	;

SigBind
	: module type id '=' SigExp
	;

ModExp
	: ModExp ':' SigExp
	| "\\" ModParam maybeAscription_SimpleSigExp "->" ModExp
	| import stringlit
	| ModExpApply
	| ModExpAtom
	;

ModExpApply
	: ModExpAtom ModExpAtom %prec juxtprec
	| ModExpApply ModExpAtom %prec juxtprec
	;

ModExpAtom
	: '(' ModExp ')'
	| QualName
	| '{' Decs '}'
	;

SimpleSigExp
	: QualName
	| '(' SigExp ')'
	;

ModBind
	: module id ModParams maybeAscription_SigExp '=' ModExp
	;

ModParam
	: '(' id ':' SigExp ')'
	;

ModParams
	: ModParam ModParams
	| /*empty*/
	;

Liftedness
	: /*empty*/
	| '~'
	| '^'
	;

Spec
	: val id TypeParams ':' TypeExp
	| val BindingBinOp TypeParams ':' TypeExp
	| TypeAbbr
	| type Liftedness id TypeParams
	| module id ':' SigExp
	| include SigExp
	| Doc Spec
	| "#[" AttrInfo ']' Spec
	;

Specs
	: Specs_
	;

Specs_
	: Specs_ Spec
	| /*empty*/
	;

SizeBinder
	: '[' id ']'
	| INDEXING id ']'
	;

SizeBinders1
	: SizeBinder SizeBinders1
	| SizeBinder
	;

TypeTypeParam
	: "'" id
	| "'~" id
	| "'^" id
	;

TypeParam
	: '[' id ']'
	| INDEXING id ']'
	| TypeTypeParam
	;

TypeParams
	: TypeParam TypeParams
	| /*empty*/
	;

// Due to an ambiguity between in-place updates ("let x[i] ...") and
// local functions with size parameters, the latter need a special
// nonterminal.
LocalFunTypeParams
	: '[' id ']' TypeParams
	| TypeTypeParam TypeParams
	| /*empty*/
	;

// Note that this production does not include Minus, but does include
// operator sections.
BinOp
	: Plus
	| Minus
	| Times
	| '*'
	| Divide
	| Mod
	| Quot
	| Rem
	| Equal
	| NotEqual
	| Less
	| Leq
	| Greater
	| Geq
	| LogAnd
	| LogOr
	| Pow
	| Xor
	| '^'
	| Band
	| Bor
	| '|'
	| ShiftR
	| ShiftL
	| PipeLeft
	| PipeRight
	| '<'
	| Bang
	| Equ
	| '`' QualName '`'
	;

BindingBinOp
	: BinOp
	| '-'
	| '!'
	;

BindingId
	: id
	| '(' BindingBinOp ')'
	;

Val
	: def BindingId TypeParams FunParams maybeAscription_TypeExp '=' Exp
	| entry BindingId TypeParams FunParams maybeAscription_TypeExp '=' Exp
	| def FunParam BindingBinOp FunParam maybeAscription_TypeExp '=' Exp
	// The next two for backwards compatibility.
	| let BindingId TypeParams FunParams maybeAscription_TypeExp '=' Exp
	| let FunParam BindingBinOp FunParam maybeAscription_TypeExp '=' Exp
	// Some error cases
	| def '(' Pat ',' Pats1 ')' '=' Exp
	| let '(' Pat ',' Pats1 ')' '=' Exp
	;

TypeAbbr
	: type Liftedness id TypeParams '=' TypeExp
	;

TypeExp
	: '(' id ':' TypeExp ')' "->" TypeExp
	| TypeExpTerm "->" TypeExp
	| '?' TypeExpDims '.' TypeExp
	| TypeExpTerm %prec typeprec
	;

TypeExpDims
	: '[' id ']'
	| '[' id ']' TypeExpDims
	| INDEXING id ']'
	| INDEXING id ']' TypeExpDims
	;

TypeExpTerm
	: '*' TypeExpTerm
	| TypeExpApply %prec typeprec
	| SumClauses %prec sumprec
	;

SumClauses
	: SumClauses '|' SumClause %prec sumprec
	| SumClause  %prec sumprec
	;

SumPayload
	: %prec bottom
	| TypeExpAtom SumPayload
	;

SumClause
	: Constr SumPayload
	;

TypeExpApply
	: TypeExpApply TypeArg
	| TypeExpAtom
	;

TypeExpAtom
	: '(' TypeExp ')'
	| '(' ')'
	| '(' TypeExp ',' TupleTypes ')'
	| '{' '}'
	| '{' FieldTypes1 '}'
	| SizeExp TypeExpTerm
	| QualName
	;

Constr
	: constructor
	;

TypeArg
	: SizeExp %prec top
	| TypeExpAtom
	;

FieldType
	: FieldId ':' TypeExp
	;

FieldTypes1
	: FieldType
	| FieldType ',' FieldTypes1
	;

TupleTypes
	: TypeExp
	| TypeExp ',' TupleTypes
	;

SizeExp
	: '[' Exp ']'
	| '['     ']'
	| INDEXING Exp ']'
	| INDEXING     ']'
	;

FunParam :
	ParamPat
	;

FunParams1
	: FunParam
	| FunParam FunParams1
	;

FunParams :
	| FunParam FunParams
	;

QualName
	: id
	| QualName '.' id
	;

// Expressions are divided into several layers.  The first distinction
// (between Exp and Exp2) is to factor out ascription, which we do not
// permit inside array slices (there is an ambiguity with
// array slices).
Exp
	: Exp ':' TypeExp
	| Exp ":>" TypeExp
	| Exp2 %prec ':'
	;

Exp2
	: IfExp
	| LoopExp
	| LetExp %prec letprec
	| MatchExp
	| assert Atom Atom
	| "#[" AttrInfo ']' Exp %prec bottom
	| BinOpExp
	| RangeExp
	| Exp2 ".." Atom
	| Atom ".." Exp2
	| '-' Exp2  %prec juxtprec
	| '!' Exp2 %prec juxtprec
	| Exp2 with '[' DimIndices ']' '=' Exp2
	| Exp2 with INDEXING DimIndices ']' '=' Exp2
	| Exp2 with FieldAccesses_ '=' Exp2
	| "\\" FunParams1 maybeAscription_TypeExpTerm "->" Exp %prec letprec
	| ApplyList
	;

ApplyList
	: Atom ApplyList %prec juxtprec
	| Atom %prec juxtprec
	;

Atom : PrimLit
	| Constr
	| charlit
	| intlit
	| natlit
	| floatlit
	| stringlit
	| hole
	| '(' Exp ')'
	| '(' Exp ',' Exps1 ')'
	| '('      ')'
	| '[' Exps1 ']'
	| '['       ']'
	| id
	| Atom '.' id
	| Atom '.' natlit
	| Atom '.' '(' Exp ')'
	| Atom INDEXING DimIndices ']'
	| '{' Fields '}'
	| SectionExp
	;

NumLit
	: i8lit
	| i16lit
	| i32lit
	| i64lit
	| u8lit
	| u16lit
	| u32lit
	| u64lit
	| f16lit
	| f32lit
	| f64lit
	;

PrimLit
	: true
	| false
	| NumLit
	;

Exps1
	: Exps1_
	;

Exps1_
	: Exps1_ ',' Exp
	| Exp
	;

FieldAccesses
	: '.' FieldId FieldAccesses
	| /*empty*/
	;

FieldAccesses_
	: FieldId FieldAccesses
	;

Field
	: FieldId '=' Exp
	| id
	;

Fields
	: Fields1
	| /*empty*/
	;

Fields1
	: Field ',' Fields1
	| Field
	;

LetExp
	: let SizeBinders1 Pat '=' Exp LetBody
	| let Pat '=' Exp LetBody
	| let id LocalFunTypeParams FunParams1 maybeAscription_TypeExp '=' Exp LetBody
	| let id INDEXING DimIndices ']' '=' Exp LetBody
	;

LetBody
	: in Exp %prec letprec
	| LetExp %prec letprec
	| def
	| type
	| module
	;

BinOpExp
	: Exp2 Plus Exp2
	| Exp2 Minus Exp2
	| Exp2 '-' Exp2
	| Exp2 Times Exp2
	| Exp2 '*' Exp2
	| Exp2 Divide Exp2
	| Exp2 Mod Exp2
	| Exp2 Quot Exp2
	| Exp2 Rem Exp2
	| Exp2 Pow Exp2
	| Exp2 ShiftR Exp2
	| Exp2 ShiftL Exp2
	| Exp2 Band Exp2
	| Exp2 Bor Exp2
	| Exp2 '|' Exp2
	| Exp2 LogAnd Exp2
	| Exp2 LogOr Exp2
	| Exp2 Xor Exp2
	| Exp2 '^' Exp2
	| Exp2 Equal Exp2
	| Exp2 NotEqual Exp2
	| Exp2 Less Exp2
	| Exp2 Leq Exp2
	| Exp2 Greater Exp2
	| Exp2 Geq Exp2
	| Exp2 PipeRight Exp2
	| Exp2 PipeLeft Exp2
	| Exp2 '<' Exp2
	| Exp2 Bang Exp2
	| Exp2 Equ Exp2
	| Exp2 '`' QualName '`' Exp2
	;

SectionExp
	: '(' '-' ')'
	| '(' Exp2 '-' ')'
	| '(' BinOp Exp2 ')'
	| '(' Exp2 BinOp ')'
	| '(' BinOp ')'
	| '(' '.' FieldAccesses_ ')'
	| '(' '.' '[' DimIndices ']' ')'
	;

RangeExp
	: Exp2 "..." Exp2
	| Exp2 TWO_DOTS_LT Exp2
	| Exp2 TWO_DOTS_GT Exp2
	| Exp2 ".." Exp2 "..." Exp2
	| Exp2 ".." Exp2 TWO_DOTS_LT Exp2
	| Exp2 ".." Exp2 TWO_DOTS_GT Exp2
	;

IfExp
	: if Exp then Exp else Exp %prec ifprec
	;

LoopExp
	: loop Pat LoopForm do Exp %prec ifprec
	| loop Pat '=' Exp LoopForm do Exp %prec ifprec
	;

MatchExp
	: match Exp Cases
	;

Cases
	: Case  %prec caseprec
	| Case Cases
	;

Case
	: case Pat "->" Exp
	;

Pat
	: "#[" AttrInfo ']' Pat
	| InnerPat ':' TypeExp
	| InnerPat
	| Constr ConstrFields
	;

// Parameter patterns are slightly restricted; see #2017.
ParamPat
	: id
	| '(' BindingBinOp ')'
	| '_'
	| '(' ')'
	| '(' Pat ')'
	| '(' Pat ',' Pats1 ')'
	| '{' CFieldPats '}'
	| PatLiteralNoNeg
	| Constr
	;

Pats1
	: Pat
	| Pat ',' Pats1
	;

InnerPat
	: id
	| '(' BindingBinOp ')'
	| '_'
	| '(' ')'
	| '(' Pat ')'
	| '(' Pat ',' Pats1 ')'
	| '{' CFieldPats '}'
	| PatLiteral
	| Constr
	;

ConstrFields
	: InnerPat
	| ConstrFields InnerPat
	;

CFieldPat
	: FieldId '=' Pat
	| FieldId ':' TypeExp
	| FieldId
	;

CFieldPats
	: CFieldPats1
	| /*empty*/
	;

CFieldPats1
	: CFieldPat ',' CFieldPats1
	| CFieldPat
	;

PatLiteralNoNeg
	: charlit
	| PrimLit
	| intlit
	| natlit
	| floatlit
	;

PatLiteral
	: PatLiteralNoNeg
	| '-' NumLit %prec bottom
	| '-' intlit %prec bottom
	| '-' natlit %prec bottom
	| '-' floatlit
	;

LoopForm
	: for VarId '<' Exp
	| for Pat in Exp
	| while Exp
	;

DimIndex
	: Exp2
	| Exp2 ':' Exp2
	| Exp2 ':'
	|      ':' Exp2
	|      ':'
	| Exp2 ':' Exp2 ':' Exp2
	|      ':' Exp2 ':' Exp2
	| Exp2 ':'      ':' Exp2
	|      ':'      ':' Exp2
	;

DimIndices
	: /*empty*/
	| DimIndices1
	;

DimIndices1
	: DimIndex
	| DimIndex ',' DimIndices1
	;

VarId
	: id
	;

FieldId
	: id
	| natlit
	;

maybeAscription_SimpleSigExp
	: ':' SimpleSigExp
	| /*empty*/
	;

maybeAscription_SigExp
	: ':' SigExp
	| /*empty*/
	;

maybeAscription_TypeExp
	: ':' TypeExp
	| /*empty*/
	;

maybeAscription_TypeExpTerm
	: ':' TypeExpTerm
	| /*empty*/
	;

AttrAtom
	: id
	| intlit
	| natlit
	;

AttrInfo
	: AttrAtom
	| id '('       ')'
	| id '(' Attrs ')'
	;

Attrs
	: AttrInfo
	| AttrInfo ',' Attrs
	;

%%

//charlit   ($printable#['\\]|\\($printable|[0-9]+))
//stringcharlit   ($printable#[\"\\]|\\($printable|[0-9]+))
hexlit   0[xX][0-9a-fA-F][0-9a-fA-F_]*
declit   [0-9][0-9_]*
binlit   0[bB][01][01_]*
romlit   0[rR][IVXLCDM][IVXLCDM_]*
reallit   (([0-9][0-9_]*("."[0-9][0-9_]*)?))([eE][\+\-]?[0-9]+)?
hexreallit   0[xX][0-9a-fA-F][0-9a-fA-F_]*"."[0-9a-fA-F][0-9a-fA-F_]*([pP][\+\-]?[0-9_]+)

field   [a-zA-Z0-9] [a-zA-Z0-9_]*

constituent   [a-zA-Z0-9_']
identifier   [a-zA-Z]{constituent}*|"_"[a-zA-Z0-9]{constituent}*
qualidentifier   ({identifier}".")+{identifier}

opchar_no_dot   [\+\-\*\/\%\=\!\>\<\|\&\^]
opchar   {opchar_no_dot}|"."
binop   {opchar_no_dot}{opchar}*
qualbinop   ({identifier}".")+{binop}

space   [\ \t\f\v]
doc   "-- |".*(\n{space}*"--".*)*

%%

[\n\r\t ]+	skip()
{doc}	doc
"--".*	skip()

"`"	'`'
"~"	'~'
"_"	'_'
","	','
"?"	'?'
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'

"^"	'^'
"^"{opchar}*	Xor

"<"	'<'
"<<"{opchar}*	ShiftL
"<="{opchar}*	Leq
"<|"{opchar}*	PipeLeft
"<"{opchar}*	Less

"="	'='
"=="{opchar}*	Equal
"="{opchar}*	Equ

">="{opchar}*	Geq
">>"{opchar}*	ShiftR
">"{opchar}*	Greater

"|"	'|'
"|>"{opchar}*	PipeRight
"||"{opchar}*	LogOr
"|"{opchar}*	Bor

"-"	'-'
"->"	"->"
"-"{opchar}*	Minus

":"	':'
":>"	":>"

"!"	'!'
"!="{opchar}*	NotEqual
"!"{opchar}*	Bang

"//"{opchar}*	Quot
"/"{opchar}*	Divide

"..<"	TWO_DOTS_LT
"..>"	TWO_DOTS_GT
"..."	"..."
"...["	INDEXING
".."	".."

"'^"	"'^"
"'~"	"'~"
"'"	"'"

"*"	'*'
"**"{opchar}*	Pow
"*"{opchar}*	Times

"\\"	"\\"

"&&"{opchar}*	LogAnd
"&"{opchar}*	Band

"#["	"#["

"%"{opchar}*	Mod
"%%"{opchar}*	Rem

"+"{opchar}*	Plus

assert	assert
case	case
def	def
do	do
doc	doc
else	else
entry	entry
false	false
for	for
"???"	hole
if	if
import	import
in	in
include	include
let	let
local	local
loop	loop
match	match
module	module
open	open
then	then
true	true
type	type
val	val
while	while
with	with

{declit}	natlit
{binlit}	intlit
{hexlit}	intlit
{romlit}	intlit

{declit}i16	i16lit
{declit}i32	i32lit
{declit}i64	i64lit
{declit}i8	i8lit

{declit}u16	u16lit
{declit}u32	u32lit
{declit}u64	u64lit
{declit}u8	u8lit

//nedd be after intlit
{reallit}|{hexreallit}	floatlit
({reallit}|{hexreallit})f16	f16lit
({reallit}|{hexreallit})f32	f32lit
({reallit}|{hexreallit})f64	f64lit

'(\\.|[^'\n\r\\])'	charlit
\"(\\.|[^"\n\r\\])*\"	stringlit

"#"{identifier}	constructor
{identifier}	id

%%
