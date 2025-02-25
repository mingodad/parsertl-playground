//From: https://github.com/jzimmerman/langcc/blob/6601d082cfa402cd02a5f2852da3a2603dfe8791/grammars/meta.lang

%token int_lit str_lit id

%%

Lang :
	decls stanzas
	;

decls :
	%empty
	| decls Decl
	;

Decl :
	Include
	| IncludePost
	;

Include :
	"#include" str_lit
	;

IncludePost :
	"#include_post" str_lit
	;

stanzas :
	%empty
	| stanzas Stanza
	;

Stanza :
	"tokens" '{' TokenDecl_list '}'
	| "lexer" '{' LexerDecl_list '}'
	| "parser"  '{' ParserDecl_zom '}'
	| "test" '{' TestCase_list '}'
	| "compile_test" '{' CompileTestCase_list '}'
	;

TokenDecl_list :
	TokenDecl ';'
	| TokenDecl_list TokenDecl ';'
	;

TokenDecl :
	IdBase "<-" ParseExpr
	| IdBase "<=" ParseExpr
	;

LexerDecl_list :
	/*empty*/
	| LexerDecl_list LexerDecl
	;

LexerDecl :
	"main" '{' IdBase '}'
	| "mode" IdBase ws_sig_opt '{' LexerModeCase '}'
	;

ws_sig_opt :
    %empty
    | "ws_sig" WsSigSpec_opt
    ;

WsSigSpec_opt :
    %empty
    | '(' str_lit_oom ')'
    | '(' str_lit ';' str_lit_oom ')'
    ;

str_lit_oom :
    str_lit
    | str_lit_oom ',' str_lit
    ;

LexerModeCase :
	ParseExpr "=>" '{' LexerInstr_list '}'
	| LexerModeCase ParseExpr "=>" '{' LexerInstr_list '}'
	;

LexerInstr_list :
	LexerInstr ';'
	| LexerInstr_list LexerInstr ';'
	;

LexerInstr :
	"emit"
	| "emit" ParseExpr
	| "pass"
	| "push" IdBase
	| "pop"
	| "pop_extract"
	| "pop_emit" ParseExpr
	| "match_history" '{' LexerModeCase_zom '}'
	;

LexerModeCase_zom :
	/*empty*/
	| LexerModeCase_zom LexerModeCase
	;

ParserDecl_zom :
	/*empty*/
	| ParserDecl_zom ParserDecl
	;

ParserDecl :
	"main" '{' IdBase_oom '}'
	| "prop" '{' ParserProp_list '}'
	| "prec" '{' PrecItem_list '}'
	| "attr" '{' AttrClause_list '}'
	| Id "<-" ParseExpr ';'
	| Id '[' L_AttrReq_opt ']' "<-" ParseExpr ';'
	| Id "<=" ParseExpr ';'
	| Id '[' L_AttrReq_opt ']' "<=" ParseExpr ';'
	;

ParserProp_list :
	ParserProp ';'
	| ParserProp_list ParserProp ';'
	;

PrecItem_list :
	PrecItem ';'
	| PrecItem_list PrecItem ';'
	;

AttrClause_list :
	AttrClause ';'
	| AttrClause_list AttrClause ';'
	;

IdBase_oom :
	IdBase
	| IdBase_oom ',' IdBase
	;

TestCase_list :
	TestCase ';'
	| TestCase_list TestCase ';'
	;

CompileTestCase_list :
	CompileTestCase ';'
	| CompileTestCase_list CompileTestCase ';'
	;

ParserProp :
	"name_strict" #NameStrict
	| "allow_unreach" #AllowUnreach
	| "ast_extra_data" '(' str_lit ')' #ASTExtraData
	| "LR" '(' int_lit ')' #LRSpec
	| "Err" #Err
	;

PrecItem :
	//ids:#L[Id::+_] assoc:(_ PrecAssoc)?
	L_Id_sp PrecAssoc_opt
	;

L_Id_sp :
	Id
	| L_Id_sp Id
	;

PrecAssoc_opt :
	%empty
	| PrecAssoc
	;

PrecAssoc :
	"assoc_left" #Left
	| "assoc_right" #Right
	| "prefix" #Prefix
	| "postfix" #Postfix
	;

AttrClause :
	AttrClauseExpr #Expr
	//| '{' items:#B[AttrClause::`;`::] '}' #Block
	| '{' L_AttrClause_opt '}' #Block
	| '{' L_AttrClause ';' '}' #Block
	//| "match" '{' cases:#B[AttrMatchCase::`,`::] '}' #Match
	| "match" '{' L_AttrMatchCase_opt '}' #Match
	| "match" '{' L_AttrMatchCase ',' '}' #Match
	;

L_AttrClause_opt :
	%empty
	| L_AttrClause
	;

L_AttrClause :
	AttrClause
	| L_AttrClause ';' AttrClause
	;

L_AttrMatchCase_opt :
	%empty
	| L_AttrMatchCase
	;

L_AttrMatchCase :
	AttrMatchCase
	| L_AttrMatchCase ',' AttrMatchCase
	;

AttrMatchCase :
	AttrMatchCasePattern "=>" AttrClause
	;

AttrMatchCasePattern :
	//items:#L[Id::+_`|`_] #Alt
	L_Id_alt #Alt
	| '_' #Wildcard
	;

L_Id_alt :
	Id
	| L_Id_alt wildcard_opt '|' wildcard_opt Id
	;

AttrClauseExpr :
	"lhs" '[' IdBase ']' #LhsGeq
	| AttrClauseExprRhsLoc '[' IdBase ']' #RhsGeq
	| "lhs" '[' IdBase ']' "->" AttrClauseExprRhsLoc '[' IdBase ']' #Implies
	;

AttrClauseExprRhsLoc:
	"rhs" #All
	| "rhs_begin" #Begin
	| "rhs_mid" #Mid
	| "rhs_end" #End
	;

TestCase :
	//str_lit sym_:(_ "<-"  IdBase)? print_exempt:(_ "<<>>")?
	str_lit
	| str_lit "<-"  IdBase
	| str_lit "<<>>"
	| str_lit "<-"  IdBase "<<>>"
	;

CompileTestCase :
	"LR" '(' int_lit ')'
	| '!' "LR" '(' int_lit ')'
	;

ParseExpr :
    ParseExpr_base
    | ParseExpr '|' ParseExpr_base #Alt
    | ParseExpr '-' ParseExpr_base #Minus
    | ParseExpr ParseExpr_base #Concat
    ;

ParseExpr_base :
	id
	| "eof"
	| "false"
	| "eps"
	| "indent"
	| "dedent"
	| "newline"
	| "unicode_any"
	| "ascii_base_any"
	/////| ParseExpr '|' ParseExpr #Alt
	//| "#Alt" '[' e:ParseExpr[pr=*] ']' #AltExplicit
	| "#Alt" '[' ParseExpr ']' #AltExplicit
	/////| ParseExpr '-' ParseExpr #Minus
	//| ParseExpr.Concat <- xs:#L[ParseExpr::++_];
	/////| ParseExpr ParseExpr
	| ParseExpr_base '?' #Optional
	| ParseExpr_base '*' #Rep
	| ParseExpr_base '+' #RepNonzero
	| ParseExpr_base '^' int_lit #RepCount
	| str_lit ".." str_lit #CharRange
	| str_lit #StrLit
	| '_' #Underscore
	| '@' '(' str_lit ')' #Pass
	//| '(' ParseExpr[pr=*] ')' #Paren
	| '(' ParseExpr ')' #Paren
	| IdBase ':' ParseExpr_base #Name
	//| ParseExprListType '[' ParseExpr[pr=*] ParseExprListNum ParseExpr[pr=*] (NONE:eps | OPTIONAL:`:?` | SOME:`::`) ']' #List
	| ParseExprListType '[' ParseExpr ParseExprListNum ParseExpr TrailingSepOpt ']' #List
	| '~' ParseExpr_base #Unfold
	//| ParseExpr '[' attrs:#L[AttrReq::`,`_] ']' #AttrReq
	| ParseExpr_base '[' L_AttrReq_opt ']' #AttrReq
	;


TrailingSepOpt :
    %empty
    | ":?"
    | "::"
    ;

wildcard_opt :
    %empty
    | '_'
    ;

L_AttrReq_opt :
	%empty
	| L_AttrReq
	;

L_AttrReq :
	AttrReq
	| L_AttrReq ',' AttrReq
	;

AttrReq :
	IdBase #Base
    | "pr" '=' '*' #PrecStar
	;

ParseExprListType :
	"#L" #List
	| "#B" #Block
	| "#B2" #Block2
	| "#T" #Top
	| "#T2" #Top2
	;

ParseExprListNum :
	"::" #Ge0
	| "::+" #Ge1
	| "::++" #Ge2
	;

Id :
    IdBase
    | Id '.' IdBase
    ;

IdBase :
	id
	;

%%

letter_gen  [A-Za-z_]
digit  [0-9]
ws_inline  [\r\t ]

id  {letter_gen}({letter_gen}|{digit})* //- (kw | `_`)

//str_lit  `\`` ((unicode_any - (`\\` | `\``)) | esc)* `\``
str_lit  \`(\\.|[^`\\])*\`
int_lit  "0"|[1-9]{digit}*
esc  "\\"[nrft`xu\\]

//top  {id}|{kw}|{op}|{str_lit}|{int_lit}

%%

{ws_inline}+	skip()
\n	skip()
"//".*	skip()

"^"	'^'
"~"	'~'
"<<>>"	"<<>>"
"<="	"<="
"<-"	"<-"
"="	'='
"=>"	"=>"
"|"	'|'
"_"	'_'
"-"	'-'
"->"	"->"
","	','
";"	';'
":"	':'
"::"	"::"
"::+"	"::+"
"::++"	"::++"
":?"	":?"
"!"	'!'
"?"	'?'
"."	'.'
".."	".."
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"@"	'@'
"*"	'*'
"+"	'+'
"#Alt"	"#Alt"
"#B"	"#B"
"#B2"	"#B2"
"#L"	"#L"
"#T"	"#T"
"#T2"	"#T2"

"allow_unreach"	"allow_unreach"
"ascii_base_any"	"ascii_base_any"
"assoc_left"	"assoc_left"
"assoc_right"	"assoc_right"
"ast_extra_data"	"ast_extra_data"
"attr"	"attr"
"compile_test"	"compile_test"
"dedent"	"dedent"
"emit"	"emit"
"eof"	"eof"
"eps"	"eps"
"Err"	"Err"
"false"	"false"
"#include"	"#include"
"#include_post"	"#include_post"
"indent"	"indent"
"lexer"	"lexer"
"lhs"	"lhs"
"LR"	"LR"
"main"	"main"
"match"	"match"
"match_history"	"match_history"
//"memo"	"memo"
"mode"	"mode"
"name_strict"	"name_strict"
"newline"	"newline"
"parser"	"parser"
"pass"	"pass"
"pop"	"pop"
"pop_emit"	"pop_emit"
"pop_extract"	"pop_extract"
"postfix"	"postfix"
"pr"	"pr"
"prec"	"prec"
"prefix"	"prefix"
"prop"	"prop"
"push"	"push"
"rhs"	"rhs"
"rhs_begin"	"rhs_begin"
"rhs_end"	"rhs_end"
"rhs_mid"	"rhs_mid"
"test"	"test"
"tokens"	"tokens"
"unicode_any"	"unicode_any"
"ws_sig"	"ws_sig"

{int_lit}	int_lit
{str_lit}	str_lit
{id}	id

%%
