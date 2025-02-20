//From: https://github.com/patrickfrey/mewa/blob/c1758c03aa88ebf454ae1672b2ad93ef32a6e4d2/doc/grammar.md?plain=1

%token name number string empty params scope step

%%

mewa :
	config_decl_oom lexer_decl_oom production_decl_oom
	;

config_decl_oom :
	config_decl
	| config_decl_oom config_decl
	;

config_decl :
	"%LANGUAGE" name ';'
	| "%TYPESYSTEM" string ';'
	| "%CMDLINE" string ';'
	| "%COMMENT" /*open*/ string ';'
	| "%COMMENT" /*open*/ string /*close*/ string ';'
	| "%IGNORE" /*pattern*/ string ';'
	| "%BAD" name ';'
	| "%INDENTL" /*open*/ name /*close*/ name /*nl*/ name /*tabsize*/ number ';'
	;

lexer_decl_oom :
	lexer_decl
	| lexer_decl_oom lexer_decl
	;

lexer_decl :
	name ':' /*pattern*/ string ';'
	| name ':' /*pattern*/ string /*select*/ number ';'
	;

production_decl_oom :
	production_decl
	| production_decl_oom production_decl
	;

production_decl :
	name '=' itemlist ';'
	| name '/' priority '=' itemlist ';'
	;

priority :
	'L' number
	| 'R' number
	;

itemlist :
	rhs_list
	| itemlist '|' rhs_list
	;

rhs_list :
	rhs_item_oom
	| rhs_item_oom '(' step ')'
	| rhs_item_oom '(' luafunction ')'
	| rhs_item_oom '(' step luafunction ')'
	| rhs_item_oom '(' scope luafunction ')'
	;

rhs_item_oom :
	rhs_item
	| rhs_item_oom rhs_item
	;

rhs_item :
	name
	| string
	| empty
    ;

luafunction :
	name
	| name number
	| name string
	| name params
	;

%%

%x PARAMS PRIORITY

string  \"(\\.|[^"\r\n\\])+\"|'(\\.|[^'\r\n\\])+'
number  [0-9]+
name    [A-Za-z_][A-Za-z0-9_]*


%%

<*>[ \t\r\n]+	skip()
//("#"|"//")"@"{name}.* Attributes
"#".*	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"    skip()

"%"[ \t]*"BAD"	"%BAD"
"%"[ \t]*"CMDLINE"	"%CMDLINE"
"%"[ \t]*"COMMENT"	"%COMMENT"
"%"[ \t]*"IGNORE"	"%IGNORE"
"%"[ \t]*"INDENTL"	"%INDENTL"
"%"[ \t]*"LANGUAGE"	"%LANGUAGE"
"%"[ \t]*"TYPESYSTEM"	"%TYPESYSTEM"
"("	'('
")"	')'
":"	':'
";"	';'
"="	'='
"|" '|'
">>"	step
"{}"	scope
"ε" empty
"%empty" empty

"/"<PRIORITY>	'/'
<PRIORITY>{
    "L"<.>	'L'
    "R"<.>	'R'
    {number}<INITIAL> number
}
"{"<PARAMS>
<PARAMS>{
    "}"<INITIAL>  params
    {string}<.>
    {name}<.>
    ","<.>
    "="<.>
}

{string}	string
{number}	number
{name}	name

%%
