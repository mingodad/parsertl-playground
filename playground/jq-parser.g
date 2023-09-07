//From: https://github.com/jqlang/jq/blob/master/src/parser.y

//%s IN_PAREN
//%s IN_BRACKET
//%s IN_BRACE
//%s IN_QQINTERP
%x IN_QQSTRING

/*Tokens*/
%token INVALID_CHARACTER
%token IDENT
%token FIELD
%token BINDING
%token LITERAL
%token FORMAT
%token REC
%token SETMOD
%token EQ
%token NEQ
%token DEFINEDOR
%token AS
%token DEF
%token MODULE
%token IMPORT
%token INCLUDE
%token IF
%token THEN
%token ELSE
%token ELSE_IF
%token REDUCE
%token FOREACH
%token END
%token AND
%token OR
%token TRY
%token CATCH
%token LABEL
%token BREAK
%token LOC
%token SETPIPE
%token SETPLUS
%token SETMINUS
%token SETMULT
%token SETDIV
%token SETDEFINEDOR
%token LESSEQ
%token GREATEREQ
%token ALTERNATION
%token QQSTRING_START
%token QQSTRING_TEXT
%token QQSTRING_INTERP_START
%token QQSTRING_INTERP_END
%token QQSTRING_END
%token FUNCDEF
%token '|'
%token ','
%token '='
%token '<'
%token '>'
%token '+'
%token '-'
%token '*'
%token '/'
%token '%'
%token NONOPT
%token '?'
%token ';'
%token '('
%token ')'
%token ':'
%token '.'
%token '['
%token ']'
%token '{'
%token '}'
%token '$'

%precedence /*1*/ FUNCDEF
%right /*2*/ '|'
%left /*3*/ ','
%right /*4*/ DEFINEDOR
%nonassoc /*5*/ SETMOD SETPIPE SETPLUS SETMINUS SETMULT SETDIV SETDEFINEDOR '='
%left /*6*/ OR
%left /*7*/ AND
%nonassoc /*8*/ EQ NEQ LESSEQ GREATEREQ '<' '>'
%left /*9*/ '+' '-'
%left /*10*/ '*' '/' '%'
%precedence /*11*/ NONOPT
%precedence /*12*/ '?'
%precedence /*13*/ TRY
%precedence /*14*/ CATCH

%start TopLevel

%%

TopLevel :
	Module Imports Exp
	| Module Imports FuncDefs
	;

Module :
	/*empty*/
	| MODULE Exp ';'
	;

Imports :
	/*empty*/
	| Import Imports
	;

FuncDefs :
	/*empty*/
	| FuncDef FuncDefs
	;

Exp :
	FuncDef Exp %prec FUNCDEF /*1P*/
	| Term AS Patterns '|' /*2R*/ Exp
	| REDUCE Term AS Patterns '(' Exp ';' Exp ')'
	| FOREACH Term AS Patterns '(' Exp ';' Exp ';' Exp ')'
	| FOREACH Term AS Patterns '(' Exp ';' Exp ')'
	| IF Exp THEN Exp ElseBody
	//| IF Exp THEN error
	| TRY /*13P*/ Exp CATCH /*14P*/ Exp
	| TRY /*13P*/ Exp
	//| TRY /*13P*/ Exp CATCH /*14P*/ error
	| LABEL BINDING '|' /*2R*/ Exp
	| Exp '?' /*12P*/
	| Exp '=' /*5N*/ Exp
	| Exp OR /*6L*/ Exp
	| Exp AND /*7L*/ Exp
	| Exp DEFINEDOR /*4R*/ Exp
	| Exp SETDEFINEDOR /*5N*/ Exp
	| Exp SETPIPE /*5N*/ Exp
	| Exp '|' /*2R*/ Exp
	| Exp ',' /*3L*/ Exp
	| Exp '+' /*9L*/ Exp
	| Exp SETPLUS /*5N*/ Exp
	| '-' /*9L*/ Exp
	| Exp '-' /*9L*/ Exp
	| Exp SETMINUS /*5N*/ Exp
	| Exp '*' /*10L*/ Exp
	| Exp SETMULT /*5N*/ Exp
	| Exp '/' /*10L*/ Exp
	| Exp '%' /*10L*/ Exp
	| Exp SETDIV /*5N*/ Exp
	| Exp SETMOD /*5N*/ Exp
	| Exp EQ /*8N*/ Exp
	| Exp NEQ /*8N*/ Exp
	| Exp '<' /*8N*/ Exp
	| Exp '>' /*8N*/ Exp
	| Exp LESSEQ /*8N*/ Exp
	| Exp GREATEREQ /*8N*/ Exp
	| Term
	;

Import :
	ImportWhat ';'
	| ImportWhat Exp ';'
	;

ImportWhat :
	IMPORT ImportFrom AS BINDING
	| IMPORT ImportFrom AS IDENT
	| INCLUDE ImportFrom
	;

ImportFrom :
	String
	;

FuncDef :
	DEF IDENT ':' Exp ';'
	| DEF IDENT '(' Params ')' ':' Exp ';'
	;

Params :
	Param
	| Params ';' Param
	;

Param :
	BINDING
	| IDENT
	;

StringStart :
	FORMAT QQSTRING_START
	| QQSTRING_START
	;

String :
	StringStart QQString QQSTRING_END
	;

QQString :
	/*empty*/
	| QQString QQSTRING_TEXT
	| QQString QQSTRING_INTERP_START Exp QQSTRING_INTERP_END
	;

ElseBody :
	ELSE_IF Exp THEN Exp ElseBody
	| ELSE Exp END
	| END
	;

ExpD :
	ExpD '|' /*2R*/ ExpD
	| '-' /*9L*/ ExpD
	| Term
	;

Term :
	'.'
	| REC
	| BREAK BINDING
	//| BREAK error
	| Term FIELD '?' /*12P*/
	| FIELD '?' /*12P*/
	| Term '.' String '?' /*12P*/
	| '.' String '?' /*12P*/
	| Term FIELD %prec NONOPT /*11P*/
	| FIELD %prec NONOPT /*11P*/
	| Term '.' String %prec NONOPT /*11P*/
	| '.' String %prec NONOPT /*11P*/
	//| '.' error
	//| '.' IDENT error
	| Term '[' Exp ']' '?' /*12P*/
	| Term '[' Exp ']' %prec NONOPT /*11P*/
	| Term '.' '[' Exp ']' '?' /*12P*/
	| Term '.' '[' Exp ']' %prec NONOPT /*11P*/
	| Term '[' ']' '?' /*12P*/
	| Term '[' ']' %prec NONOPT /*11P*/
	| Term '.' '[' ']' '?' /*12P*/
	| Term '.' '[' ']' %prec NONOPT /*11P*/
	| Term '[' Exp ':' Exp ']' '?' /*12P*/
	| Term '[' Exp ':' ']' '?' /*12P*/
	| Term '[' ':' Exp ']' '?' /*12P*/
	| Term '[' Exp ':' Exp ']' %prec NONOPT /*11P*/
	| Term '[' Exp ':' ']' %prec NONOPT /*11P*/
	| Term '[' ':' Exp ']' %prec NONOPT /*11P*/
	| LITERAL
	| String
	| FORMAT
	| '(' Exp ')'
	| '[' Exp ']'
	| '[' ']'
	| '{' MkDict '}'
	| '$' '$' '$' BINDING
	| BINDING
	| LOC
	| IDENT
	| IDENT '(' Args ')'
	//| '(' error ')'
	//| '[' error ']'
	//| Term '[' error ']'
	//| '{' error '}'
	;

Args :
	Arg
	| Args ';' Arg
	;

Arg :
	Exp
	;

RepPatterns :
	RepPatterns ALTERNATION Pattern
	| Pattern
	;

Patterns :
	RepPatterns ALTERNATION Pattern
	| Pattern
	;

Pattern :
	BINDING
	| '[' ArrayPats ']'
	| '{' ObjPats '}'
	;

ArrayPats :
	Pattern
	| ArrayPats ',' /*3L*/ Pattern
	;

ObjPats :
	ObjPat
	| ObjPats ',' /*3L*/ ObjPat
	;

ObjPat :
	BINDING
	| BINDING ':' Pattern
	| IDENT ':' Pattern
	| Keyword ':' Pattern
	| String ':' Pattern
	| '(' Exp ')' ':' Pattern
	//| error ':' Pattern
	;

Keyword :
	AS
	| DEF
	| MODULE
	| IMPORT
	| INCLUDE
	| IF
	| THEN
	| ELSE
	| ELSE_IF
	| REDUCE
	| FOREACH
	| END
	| AND /*7L*/
	| OR /*6L*/
	| TRY /*13P*/
	| CATCH /*14P*/
	| LABEL
	| BREAK
	;

MkDict :
	/*empty*/
	| MkDictPair
	| MkDictPair ',' /*3L*/ MkDict
	//| error ',' /*3L*/ MkDict
	;

MkDictPair :
	IDENT ':' ExpD
	| Keyword ':' ExpD
	| String ':' ExpD
	| String
	| BINDING ':' ExpD
	| BINDING
	| IDENT
	| LOC
	| Keyword
	| '(' Exp ')' ':' ExpD
	//| error ':' ExpD
	;

%%

%%

"#"[^\r\n]* skip() /* comments */

"!=" NEQ
"==" EQ
"as" AS
"import" IMPORT
"include" INCLUDE
"module" MODULE
"def" DEF
"if" IF
"then" THEN
"else" ELSE
"elif" ELSE_IF
"and" AND
"or" OR
"end" END
"reduce" REDUCE
"foreach" FOREACH
"//" DEFINEDOR
"try" TRY
"catch" CATCH
"label" LABEL
"break" BREAK
"$__loc__" LOC
"|=" SETPIPE
"+=" SETPLUS
"-=" SETMINUS
"*=" SETMULT
"/=" SETDIV
"%=" SETMOD
"//=" SETDEFINEDOR
"<=" LESSEQ
">=" GREATEREQ
".." REC
"?//" ALTERNATION
/*"."|"?"|"="|";"|","|":"|"|"|"+"|"-"|"*"|"/"|"%"|"\$"|"<"|">" { return yytext[0];}*/

"|"	'|'
","	','
"="	'='
"<"	'<'
">"	'>'
"+"	'+'
"-"	'-'
"*"	'*'
"/"	'/'
"%"	'%'
"?"	'?'
";"	';'
"("	'('
")"	')'
":"	':'
"."	'.'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"$"	'$'

/*
"["|"{"|"(" {
  return enter(yytext[0], YY_START, yyscanner);
}

"]"|"}"|")" {
  return try_exit(yytext[0], YY_START, yyscanner);
}
*/
"@"[a-zA-Z0-9_]+  FORMAT

([0-9]+(\.[0-9]*)?|\.[0-9]+)([eE][+-]?[0-9]+)? LITERAL

"\""<>IN_QQSTRING>  QQSTRING_START

<IN_QQSTRING>{
/*
  "\\(" {
    return enter(QQSTRING_INTERP_START, YY_START, yyscanner);
  }
*/
"\""<<>  QQSTRING_END

(\\[^u(]|\\u[a-zA-Z0-9]{0,4})+  QQSTRING_TEXT

[^\\\"]+  QQSTRING_TEXT

.  INVALID_CHARACTER

}


([a-zA-Z_][a-zA-Z_0-9]*::)*[a-zA-Z_][a-zA-Z_0-9]*  IDENT
\.[a-zA-Z_][a-zA-Z_0-9]*  FIELD
\$([a-zA-Z_][a-zA-Z_0-9]*::)*[a-zA-Z_][a-zA-Z_0-9]*  BINDING

[ \n\r\t]+  skip()

.	INVALID_CHARACTER

%%
