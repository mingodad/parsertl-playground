//From: https://github.com/GaloisInc/cryptol/raw/85d35cc494787dcccc572594570cef53863da8fd/src/Cryptol/Parser.y

%token CHARLIT
%token DOC
%token FRAC
%token IDENT
%token NUM
%token OP
%token QIDENT
%token QOP
%token SELECTOR
%token STRLIT

%right "->"
%right '#'

%start program

%%

//top_module :
//	mbDoc "module" module_def
//	| "v{" vmod_body "v}"
//	| mbDoc "interface" "module" modName "where" "v{" sig_body "v}"
//        ;

module_def :
	modName "where" "v{" vmod_body "v}"
	| modName '=' impName "where" "v{" vmod_body "v}"
	| modName '=' impName '{' modInstParams '}'
	;

modInstParams :
	modInstParam
	| namedModInstParams
	;

namedModInstParams :
	namedModInstParam
	| namedModInstParams ',' namedModInstParam
	;

namedModInstParam :
	ident '=' modInstParam
	;

modInstParam :
	impName
	| "interface" ident
	| '_'
	;

vmod_body :
	vtop_decls
	| /*empty*/
	;

//  inverted
imports1 :
	imports1 "v;" import
	| imports1 ';'  import
	| import
	;

import :
	mbDoc "import" impName optInst mbAs mbImportSpec optImportWhere
	| mbDoc "import" impNameBT mbAs mbImportSpec
	;

optImportWhere :
	"where" whereClause
	| /*empty*/
	;

optInst :
	'{' modInstParams '}'
	| /*empty*/
	;

impName :
	"submodule" qname
	| modName
	;

impNameBT :
	"submodule" '`' qname
	| '`' modName
	;

mbAs :
	"as" modName
	| /*empty*/
	;

mbImportSpec :
	mbHiding '(' name_list ')'
	| /*empty*/
	;

name_list :
	name_list ',' var
	| var
	| /*empty*/
	;

mbHiding :
	"hiding"
	| /*empty*/
	;

program :
	top_decls
	| /*empty*/
	;

//program_layout :
//	"v{" vtop_decls "v}"
//	| "v{""v}"
//	;

top_decls :
	top_decl ';'
	| top_decls top_decl ';'
	;

vtop_decls :
	vtop_decl
	| vtop_decls "v;" vtop_decl
	| vtop_decls ';'  vtop_decl
	;

vtop_decl :
	decl
	| doc decl
	| "include" STRLIT
	| mbDoc "property" name iapats '=' expr
	| mbDoc "property" name       '=' expr
	| mbDoc newtype
	| mbDoc enum
	| prim_bind
	| foreign_bind
	| private_decls
	| mbDoc "interface" "constraint" type
	| parameter_decls
	| mbDoc "submodule" module_def
	| mbDoc sig_def
	| mod_param_decl
	| import
	;

sig_def :
	"interface" "submodule" name "where" "v{" sig_body "v}"
	;

sig_body :
	par_decls
	| imports1 "v;" par_decls
	| imports1 ';'  par_decls
	;

mod_param_decl :
	mbDoc "import" "interface" impName mbAs
	;

top_decl :
	decl
	| "include" STRLIT
	| prim_bind
	;

private_decls :
	"private" "v{" vtop_decls "v}"
	| doc "private" "v{" vtop_decls "v}"
        ;

prim_bind :
	mbDoc "primitive" name  ':' schema
	| mbDoc "primitive" '(' op ')' ':' schema
	| mbDoc "primitive" "type" schema ':' kind
	;

foreign_bind :
	mbDoc "foreign" name ':' schema
	;

parameter_decls :
	"parameter" "v{" par_decls "v}"
	;

//  Reversed
par_decls :
	par_decl
	| par_decls ';'  par_decl
	| par_decls "v;" par_decl
	;

par_decl :
	mbDoc        name ':' schema
	| mbDoc "type" name ':' kind
	| mbDoc typeOrPropSyn
	| mbDoc topTypeConstraint
	;

doc :
	DOC
	;

mbDoc :
	doc
	| /*empty*/
	;

decl :
	vars_comma ':' schema
	| ipat '=' expr
	| '(' op ')' '=' expr
	| var iapats_indices propguards_cases
	| var propguards_cases
	| var iapats_indices '=' expr
	| iapat pat_op iapat '=' expr
	| typeOrPropSyn
	| "infixl" NUM ops
	| "infixr" NUM ops
	| "infix"  NUM ops
	//| error
	;

//let_decls :
//	let_decl
//	| let_decl ';'
//	| let_decl ';' let_decls
//	;

//let_decl :
//	"let" ipat '=' expr
//	| "let" var iapats_indices '=' expr
//	| "let" '(' op ')' '=' expr
//	| "let" iapat pat_op iapat '=' expr
//	| "let" vars_comma ':' schema
//	| typeOrPropSyn
//	| "infixl" NUM ops
//	| "infixr" NUM ops
//	| "infix"  NUM ops
//	;

typeOrPropSyn :
	"type" "constraint" type '=' type
	| "type"              type '=' type
	;

topTypeConstraint :
	"type" "constraint" type
	;

propguards_cases :
	propguards_cases propguards_case
	| propguards_case
	;

propguards_case :
	'|' propguards_quals "=>" expr
	;

propguards_quals :
	type
	;

newtype :
	"newtype" type '=' newtype_body
	;

newtype_body :
	'{' '}'
	| '{' field_types '}'
	;

enum :
	"enum" type '=' enum_body
	;

enum_body :
	enum_con
	| '|' enum_con
	| enum_body '|' enum_con
	;

enum_con :
	app_type
	| doc  app_type
	;

vars_comma :
	var
	| vars_comma ',' var
	;

var :
	name
	| '(' op ')'
	;

decls :
	decl ';'
	| decls decl ';'
	;

vdecls :
	decl
	| vdecls "v;" decl
	| vdecls ';'  decl
	;

//decls_layout :
//	"v{" vdecls "v}"
//	| "v{" "v}"
//	;

//repl :
//	expr
//	| let_decls
//	| /*empty*/
//	;

// ------------------------------------------------------------------------------
//  Operators

qop :
	op
	| QOP
	;

op :
	pat_op
	| '#'
	| '@'
	;

pat_op :
	other_op
	// special cases for operators that are re-used elsewhere
	| '*'
	| '+'
	| '-'
	| '~'
	| "^^"
	| '<'
	| '>'
	;

other_op :
	OP
	;

ops :
	op
	| ops ',' op
	;

// ------------------------------------------------------------------------------
//  Expressions


expr :
	exprNoWhere
	| expr "where" whereClause
	//  | An expression without a `where` clause
	;

exprNoWhere :
	simpleExpr qop longRHS
	| longRHS
	| typedExpr
	;

whereClause :
	'{' '}'
	| '{' decls '}'
	| "v{" "v}"
	| "v{" vdecls "v}"
	;

//  An expression with a type annotation
typedExpr :
	simpleExpr ':' type
	;

//  A possibly infix expression (no where, no long application, no type annot)
simpleExpr :
	simpleExpr qop simpleRHS
	| simpleRHS
	;

//  An expression without an obvious end marker
longExpr :
	"if" ifBranches "else" exprNoWhere
	| "\\" iapats "->" exprNoWhere
	| "case" expr "of" "v{" vcaseBranches "v}"
	| "case" expr "of" '{' caseBranches '}'
	;

ifBranches :
	ifBranch
	| ifBranches '|' ifBranch
	;

ifBranch :
	expr "then" expr
	;

vcaseBranches :
	caseBranch
	| vcaseBranches "v;" caseBranch
	;

caseBranches :
	caseBranch
	| caseBranches ';' caseBranch
	;

caseBranch :
	cpat "->" expr
	;

simpleRHS :
	'-' simpleApp
	| '~' simpleApp
	| simpleApp
	;

longRHS :
	'-' longApp
	| '~' longApp
	| longApp
	;

//  Prefix application expression, ends with an atom.
simpleApp :
	aexprs
	;

//  Prefix application expression, may end with a long expression
longApp :
	simpleApp longExpr
	| longExpr
	| simpleApp
	;

aexprs :
	aexpr
	| aexprs aexpr
	;

//  Expression atom (needs no parens)
aexpr :
	no_sel_aexpr
	| sel_expr
	;

no_sel_aexpr :
	qname
	| NUM
	| FRAC
	| STRLIT
	| CHARLIT
	| '_'
	| '(' expr ')'
	| '(' tuple_exprs ')'
	| '(' ')'
	| '{' '}'
	| '{' rec_expr '}'
	| '[' ']'
	| '[' list_expr  ']'
	| '`' tick_ty
	| '(' qop ')'
	| "<|"            "|>"
	| "<|" poly_terms "|>"
	;

sel_expr :
	no_sel_aexpr selector
	| sel_expr     selector
	;

selector :
	SELECTOR
	;

poly_terms :
	poly_term
	| poly_terms '+' poly_term
	;

poly_term :
	NUM
	| 'x'
	| 'x' "^^" NUM
	;

tuple_exprs :
	expr ',' expr
	| tuple_exprs ',' expr
	;

rec_expr :
	aexpr '|' field_exprs
	| '_'   '|' field_exprs
	| field_exprs
	;

field_exprs :
	field_expr
	| field_exprs ',' field_expr
	;

field_expr :
	field_path opt_iapats_indices field_how expr
	;

field_path :
	aexpr
	;

field_how :
	'='
	| "->"
	;

list_expr :
	expr '|' list_alts
	| expr
	| tuple_exprs
	| expr          ".." expr
	| expr ',' expr ".." expr
	| expr ".." '<' expr
	| expr "..<"    expr
	| expr ".." expr "by" expr
	| expr ".." '<' expr "by" expr
	| expr "..<" expr "by" expr
	| expr ".." expr "down" "by" expr
	| expr ".." '>' expr "down" "by" expr
	| expr "..>" expr "down" "by" expr
	| expr "..."
	| expr ',' expr "..."
	;

list_alts :
	matches
	| list_alts '|' matches
	;

matches :
	match
	| matches ',' match
	;

match :
	itpat "<-" expr
	;

// ------------------------------------------------------------------------------
//  Generic patterns

pat :
	cpat ':' type
	| cpat
	;

cpat :
	cpat '#' cpat
	| qname apats
	| apat
	;

apats :
	apat
	| apats apat
	;

apat :
	qname
	| '_'
	| '(' ')'
	| '(' pat ')'
	| '(' tuple_pats ')'
	| '[' ']'
	| '[' pat ']'
	| '[' tuple_pats ']'
	| '{' '}'
	| '{' field_pats '}'
	;

tuple_pats :
	pat ',' pat
	| tuple_pats ',' pat
	;

field_pat :
	ident '=' pat
	;

field_pats :
	field_pat
	| field_pats ',' field_pat
	;

//  Irrefutable patterns
itpat :
	ipat ':' type
	| ipat
	;

ipat :
	ipat '#' ipat
	| iapat
	;

iapat :
	apat
	;

iapats :
	iapat
	| iapats iapat
	;

indices :
	'@' indices1
	| /*empty*/
	;

indices1 :
	iapat
	| indices1 '@' apat
	;

iapats_indices :
	iapats indices
	| '@' indices1
	;

opt_iapats_indices :
	/*empty*/
	| iapats_indices
	;

// ------------------------------------------------------------------------------
schema :
	type
	| schema_vars type
	| schema_quals type
	| schema_vars schema_quals type
	;

schema_vars :
	'{' '}'
	| '{' schema_params '}'
	;

schema_quals :
	schema_quals schema_qual
	| schema_qual
	;

schema_qual :
	type "=>"
	;

kind :
	'#'
	| '*'
	| "Prop"
	| kind "->" kind
	;

schema_param :
	ident
	| ident ':' kind
	;

schema_params :
	schema_param
	| schema_params ',' schema_param
	;

type :
	infix_type "->" type
	| infix_type
	;

infix_type :
	infix_type op app_type
	| app_type
	;

app_type :
	dimensions atype
	| qname atypes
	| atype
	;

atype :
	qname
	| '(' qop ')'
	| NUM
	| CHARLIT
	| '[' type ']'
	| '(' ktype ')'
	| '(' ')'
	| '(' tuple_types ')'
	| '{' '}'
	| '{' field_types '}'
	| '_'
	;

ktype :
	type ':' kind
	| type
	;

atypes :
	atype
	| atypes atype
	;

dimensions :
	'[' type ']'
	| dimensions '[' type ']'
	;

tuple_types :
	type ',' type
	| tuple_types ',' type
	;

field_type :
	ident ':' type
	;

field_types :
	field_type
	| field_types ',' field_type
	;

ident :
	IDENT
	| 'x'
	| "private"
	| "as"
	| "hiding"
	;

name :
	ident
	;

smodName :
	ident
	| QIDENT
	;

modName :
	smodName
	| "module" smodName
	;

qname :
	name
	| QIDENT
	;

//help_name :
//	qname
//	| qop
//	| '(' qop ')'
//	;

/* The types that can come after a back-tick: either a type demotion,
or an explicit type application. */
tick_ty :
	qname
	| NUM
	| '(' type ')'
	| '{' '}'
	| '{' field_ty_vals '}'
	| '{' type '}'
	| '{' tuple_types '}'
	;

//  This for explicit type applications (e.g., f `)
field_ty_val :
	ident '=' type
	;

field_ty_vals :
	field_ty_val
	| field_ty_vals ',' field_ty_val
	;

%%

OP	[!#$%&*+\-./:<=>?@\\^|~]
ID	[A-Za-z_][A-Za-z0-9_]*
QUAL	({ID}"::")+

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/***"(?s:.)*?"*/"	DOC
"/*"(?s:.)*?"*/"	skip()

"#"	'#'
"("	'('
")"	')'
"*"	'*'
"+"	'+'
","	','
"-"	'-'
"->"	"->"
".."	".."
"..."	"..."
"..<"	"..<"
"..>"	"..>"
":"	':'
";"	';'
"<"	'<'
"<-"	"<-"
"<|"	"<|"
"="	'='
"=>"	"=>"
">"	'>'
"@"	'@'
"Prop"	"Prop"
"["	'['
"\\"	"\\"
"]"	']'
"^^"	"^^"
"_"	'_'
"`"	'`'
"as"	"as"
"by"	"by"
"case"	"case"
"constraint"	"constraint"
"down"	"down"
"else"	"else"
"enum"	"enum"
"foreign"	"foreign"
"hiding"	"hiding"
"if"	"if"
"import"	"import"
"include"	"include"
"infix"	"infix"
"infixl"	"infixl"
"infixr"	"infixr"
"interface"	"interface"
"module"	"module"
"newtype"	"newtype"
"of"	"of"
"parameter"	"parameter"
"primitive"	"primitive"
"private"	"private"
"property"	"property"
"submodule"	"submodule"
"then"	"then"
"type"	"type"
"v;"	"v;"
"v{"	"v{"
"v}"	"v}"
"where"	"where"
"x"	'x'
"{"	'{'
"|"	'|'
"|>"	"|>"
"}"	'}'
"~"	'~'

'(\\.|[^'\r\n\\])'	CHARLIT
[0-9]+"."[0-9]+	FRAC
[0-9]+	NUM
"0"[xX][0-9a-fA-F]+	NUM
{OP}+	OP
{QUAL}{OP}	QOP
\"(\\.|[^"\r\n\\])*\"	STRLIT

{QUAL}{ID}	QIDENT
"."{ID}	SELECTOR
{ID}	IDENT

%%
