//From: https://github.com/github/codeql/blob/7006d007022bda7a10eef375a49d75a20c5e9048/docs/codeql/ql-language-reference/ql-language-specification.rst?plain=1

%token qldoc
%token int
%token lowerId
%token float
%token string
%token upperId
%token atLowerId

%nonassoc "implies"
%left "or"
%left "and"
%left '=' "!=" '<' '>' "<=" ">="
%left "not"
%left "instanceof"
%left "in"
%left '+' '-'
%left '*' '/' '%'
%precedence UNARY

%%

ql :
	qldoc moduleBody
	| moduleBody
	| qldoc signature
	;

qldoc_annotations :
	%empty
	| qldoc
	| annotation_oom
	| qldoc annotation_oom
	;

annotation_oom :
	annotation
	| annotation_oom annotation
	;

//annotations :
//	%empty
//	| annotations annotation
//	;

module :
	qldoc_annotations "module" modulename parameters_opt implements_opt '{' moduleBody '}'
	;

parameters_opt :
	%empty
	| parameters
	;

parameters :
	'<' signatureExprParName_list '>'
	;

signatureExprParName_list :
	signatureExpr parameterName
	| signatureExprParName_list ',' signatureExpr parameterName
	;

implements_opt :
	%empty
	| implements
	;

implements :
	"implements" moduleSignatureExpr_list
	;

moduleSignatureExpr_list :
	moduleSignatureExpr
	| moduleSignatureExpr_list ',' moduleSignatureExpr
	;

moduleBody :
	%empty
	| moduleBody moduleDecl
	;

moduleDecl :
    import
    | predicate
    | class
    | module
    | alias
    | select
    ;

import :
	qldoc_annotations "import" importModuleExpr as_modulename_opt
	;

as_modulename_opt :
	%empty
	| "as" modulename
	;

qualId :
	simpleId
	| qualId '.' simpleId
	;

importModuleExpr :
	qualId
	| importModuleExpr "::" modulename arguments_opt
	;

arguments :
	'<' argument_list '>'
	;

argument_list :
	argument
	| argument_list ',' argument
	;

argument :
	moduleExpr
	| type
	| predicateRefInt
	;

predicateRefInt :
	predicateRef '/' int
	;

signature :
	predicateSignature
	| typeSignature
	| moduleSignature
	;

predicateSignature :
	qldoc_annotations "signature" head ';'
	;

typeSignature :
	qldoc_annotations "signature" "class" classname extends_types_opt typeSignature_decl_def
	;

typeSignature_decl_def :
	';'
	| '{' signaturePredicate_zom '}'
	;

moduleSignature :
	annotation "signature" "module" moduleSignatureName parameters_opt '{' moduleSignatureBody '}'
	;

moduleSignatureBody :
	%empty
	| moduleSignatureBody moduleSignature_decl
	;

moduleSignature_decl :
	signaturePredicate
	| defaultPredicate
	| signatureType
	;

signaturePredicate_zom:
	%empty
	| signaturePredicate
	;

signaturePredicate :
	qldoc_annotations head ';'
	;

defaultPredicate :
	qldoc_annotations "default" head '{' formula '}'
	;

signatureType :
	qldoc_annotations "class" classname extends_types_opt '{' signaturePredicate_zom '}'
	;

extends_types_opt :
	%empty
	| "extends" type_list
	;

type_list :
	type
	| type_list ',' type
	;

select :
	from_var_opt where_formula_opt "select" as_exprs order_by_opt
	;

from_var_opt :
	%empty
	| "from" var_decls_oom
	;

where_formula_opt :
	%empty
	| "where" formula
	;

order_by_opt :
	%empty
	| "order" "by" orderbys
	;

as_exprs :
	as_expr
	| as_exprs ',' as_expr
	;

as_expr :
	expr
	| expr "as" lowerId
	;

orderbys :
	orderby
	| orderbys ',' orderby
	;

orderby :
	lowerId
	| lowerId "asc"
	| lowerId "desc"
	;

predicate :
	qldoc_annotations head optbody
	;

annotation :
	simpleAnnotation
	| argsAnnotation
	;

simpleAnnotation :
	"abstract"
	| "cached"
	| "external"
	| "extensible"
	| "final"
	| "transient"
	| "library"
	| "private"
	| "deprecated"
	| "override"
	| "additional"
	| "query"
	;

argsAnnotation :
	"pragma" '[' pragma_types ']'
	| "language" '[' "monotonicAggregates" ']'
	| "bindingset" '[' variable_zoo ']'
	;

variable_zoo :
	%empty
	| variable_zom
	;

variable_zom :
	variable
	| variable_zom ',' variable
	;

pragma_types :
	"inline"
	| "inline_late"
	| "noinline"
	| "nomagic"
	| "noopt"
	| "assume_small_delta"
	;

head :
	"predicate" predicateName '(' var_decls ')'
	| type predicateName '(' var_decls ')'
	;

optbody :
	';'
	| '{' formula '}'
	| '=' literalId '(' predicateRef_int_list_opt ')' '(' exprs_opt ')'
	;

predicateRef_int_list_opt :
	%empty
	| predicateRef_int_list
	;

predicateRef_int_list :
	predicateRefInt
	| predicateRef_int_list ',' predicateRefInt
	;

class :
	qldoc_annotations "class" classname extends_types_opt instanceof_types_opt '{' member_zom '}'
	;

instanceof_types_opt :
	%empty
	| "instanceof" type_list
	;

member_zom :
	%empty
	| member_zom member
	;

member :
	character
	| predicate
	| field
	;

character :
	qldoc_annotations classname '(' ')' '{' formula '}'
	;

field :
	qldoc_annotations var_decl ';'
	;

moduleExpr :
	modulename arguments_opt
	| moduleExpr "::" modulename arguments_opt
	;

moduleSignatureExpr :
	 moduleSignatureName arguments_opt
	| moduleExpr "::" moduleSignatureName arguments_opt
	;

arguments_opt :
	%empty
	| arguments
	;

signatureExpr :
	 simpleId ';'
	|  simpleId '/' int ';'
	|  simpleId arguments ';'
	| moduleExpr "::" simpleId ';'
	| moduleExpr "::" simpleId '/' int ';'
	| moduleExpr "::" simpleId arguments ';'
	;

type :
	 classname
	| moduleExpr "::" classname
	| dbasetype
	| "boolean"
	| "date"
	| "float"
	| "int"
	| "string"
	;

exprs :
	expr
	| exprs ',' expr
	;

alias :
	qldoc_annotations "predicate" literalId '=' predicateRefInt ';'
	| qldoc_annotations "class" classname '=' type ';'
	| qldoc_annotations "module" modulename '=' moduleExpr ';'
	;

var_decls :
	%empty
	| var_decls_oom
	;

var_decls_oom :
	var_decl
	| var_decls_oom ',' var_decl
	;

var_decl :
	type lowerId
	;

formula :
	fparen
	| disjunction
	| conjunction
	| implies
	| ifthen
	| negated
	| quantified
	| comparison
	| instanceof
	| inrange
	| call
	;

fparen :
	'(' formula ')'
	;

disjunction :
	formula "or" formula
	;

conjunction :
	formula "and" formula
	;

implies :
	formula "implies" formula
	;

ifthen :
	"if" formula "then" formula "else" formula
	;

negated :
	"not" formula
	;

quantified :
	"exists" '(' expr ')'
	| "exists" quantified_args
	| "forall" quantified_args
	| "forex" quantified_args
	;

quantified_args :
	'(' var_decls ')'
	| '(' var_decls '|' formula ')'
	| '(' var_decls '|' formula '|' formula ')'
	;

comparison :
	expr compop expr
	;

compop :
	'='
	| "!="
	| '<'
	| '>'
	| "<="
	| ">="
	;

instanceof :
	expr "instanceof" type
	;

inrange :
	expr "in" range
	| expr "in" setliteral
	;

call :
	predicateRef callargs
	| primary '.' predicateName callargs
	;

closure :
	'*'
	| '+'
	;

expr :
	dontcare
	| unop
	| binop
	| cast
	| primary
	;

primary :
	eparen
	| literal
	| variable
	| super_expr
	| postfix_cast
	| call //callwithresults
	| aggregation
	| expression_pragma
	| any
	| range
	| setliteral
	;

eparen :
	'(' expr ')'
	;

dontcare :
	'_'
	;

literal :
	"false"
	| "true"
	| int
	| float
	| string
	;

unop :
	'+' expr %prec UNARY
	| '-' expr %prec UNARY
	;

binop :
	expr '+' expr
	| expr '-' expr
	| expr '*' expr
	| expr '/' expr
	| expr '%' expr
	;

variable :
	varname
	| "this"
	| "result"
	;

super_expr :
	"super"
	| type '.' "super"
	;

cast :
	'(' type ')' expr
	;

postfix_cast :
	primary '.' '(' type ')'
	;

aggregation :
	aggid index_expr_opt '(' var_decls ')'
	| aggid index_expr_opt '(' var_decls '|' formula ')'
	| aggid index_expr_opt '(' var_decls '|' formula '|' as_exprs order_by_aggorderbys_opt ')'
	| aggid index_expr_opt '(' as_exprs order_by_aggorderbys_opt ')'
	| "unique" '(' var_decls ')'
	| "unique" '(' var_decls '|' formula ')'
	| "unique" '(' var_decls '|' formula '|' as_exprs ')'
	;

order_by_aggorderbys_opt :
	%empty
	| "order" "by" aggorderbys
	;

index_expr_opt :
	%empty
	| '[' expr ']'
	;

expression_pragma :
	"pragma" '[' expression_pragma_type ']' '(' expr ')'
	;

expression_pragma_type :
	"only_bind_out"
	| "only_bind_into"
	;

aggid :
	"avg"
	| "concat"
	| "count"
	| "max"
	| "min"
	| "rank"
	| "strictconcat"
	| "strictcount"
	| "strictsum"
	| "sum"
	;

aggorderbys :
	aggorderby
	| aggorderbys ',' aggorderby
	;

aggorderby :
	expr
	| expr "asc"
	| expr "desc"
	;

any :
	"any" var_decls_fe
	;

var_decls_fe :
	'(' var_decls ')'
	| '(' var_decls '|' formula ')'
	| '(' var_decls '|' expr ')'
	;

callargs :
	'(' exprs_opt ')'
	| closure '(' exprs_opt ')'
	;

exprs_opt :
	%empty
	| exprs
	;

range :
	'[' expr ".." expr ']'
	;

setliteral :
	'[' exprs ']'
	| '[' exprs ',' ']'
	;

simpleId :
	lowerId
	| upperId
	;

modulename :
	simpleId
	;

moduleSignatureName :
	upperId
	;

classname :
	upperId
	;

dbasetype :
	atLowerId
	;

predicateRef :
	literalId
	| moduleExpr "::" literalId
	;

predicateName :
	lowerId
	;

parameterName :
	simpleId
	;

varname :
	lowerId
	;

literalId :
	lowerId
	| atLowerId
	| "any"
	| "none"
	;

%%

%%

[\n\r\t ]+	skip()
"//".*	skip()

"/**"(?s:.)*?"*/"	qldoc

"/*"(?s:.)*?"*/"	skip()


"<="	"<="
"<"	'<'
"="	'='
">="	">="
">"	'>'
"|"	'|'
"_"	'_'
"-"	'-'
","	','
";"	';'
"::"	"::"
"!="	"!="
"/"	'/'
".."	".."
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"*"	'*'
"%"	'%'
"+"	'+'
"abstract"	"abstract"
"additional"	"additional"
"and"	"and"
"any"	"any"
"as"	"as"
"asc"	"asc"
"assume_small_delta"	"assume_small_delta"
"avg"	"avg"
"bindingset"	"bindingset"
"boolean"	"boolean"
"by"	"by"
"cached"	"cached"
"class"	"class"
"concat"	"concat"
"count"	"count"
"date"	"date"
"default"	"default"
"deprecated"	"deprecated"
"desc"	"desc"
"else"	"else"
"exists"	"exists"
"extends"	"extends"
"extensible"	"extensible"
"external"	"external"
"false"	"false"
"final"	"final"
"float"	"float"
"forall"	"forall"
"forex"	"forex"
"from"	"from"
"if"	"if"
"implements"	"implements"
"implies"	"implies"
"import"	"import"
"in"	"in"
"inline"	"inline"
"inline_late"	"inline_late"
"instanceof"	"instanceof"
"int"	"int"
"language"	"language"
"library"	"library"
"max"	"max"
"min"	"min"
"module"	"module"
"monotonicAggregates"	"monotonicAggregates"
"noinline"	"noinline"
"nomagic"	"nomagic"
"none"	"none"
"noopt"	"noopt"
"not"	"not"
"only_bind_into"	"only_bind_into"
"only_bind_out"	"only_bind_out"
"or"	"or"
"order"	"order"
"override"	"override"
"pragma"	"pragma"
"predicate"	"predicate"
"private"	"private"
"query"	"query"
"rank"	"rank"
"result"	"result"
"select"	"select"
"signature"	"signature"
"strictconcat"	"strictconcat"
"strictcount"	"strictcount"
"strictsum"	"strictsum"
"string"	"string"
"sum"	"sum"
"super"	"super"
"then"	"then"
"this"	"this"
"transient"	"transient"
"true"	"true"
"unique"	"unique"
"where"	"where"

\"(\\.|[^"\n\r\\])*\"	string
[0-9]+	int
[0-9]+"."[0-9]+	float

[a-z_][A-Za-z0-9_]*	lowerId
[A-Z_][A-Za-z0-9_]*	upperId
"@"[a-z_][A-Za-z0-9_]*	atLowerId

%%
