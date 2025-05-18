%token CODE_TILL_CURLY
%token CODE_TILL_PCT_CURLY
%token USERCODE ACTION_CODE
%token NAME
%token STRING
%token RECLASS
%token NL

%%

reflex :
	definitions "%%" rules "%%" user_code
	;

user_code :
    %empty
    | USERCODE
    ;

definitions :
	%empty
	| definitions definition
	;

definition :
    NL
	| is_code
	| is_top_code
	| is_class_code
	| is_init_code
	| is_begin_code
	| is_include
	| is_state
	| is_xstate
	| is_option
	| def_named_pattern
	;

is_code :
	"%{" CODE_TILL_PCT_CURLY
	;

is_top_code :
	"%top{" CODE_TILL_CURLY
	;

is_class_code :
	"%class{" CODE_TILL_CURLY
	;

is_init_code :
	"%init{" CODE_TILL_CURLY
	;

is_begin_code :
	"%begin{" CODE_TILL_CURLY
	;

is_include :
	"%include" STRING
	;

is_state :
	"%state" name_list
	;

is_xstate :
	"%xstate" name_list
	;

name_list :
	NAME
	| name_list NAME
	;

is_option :
	"%option" key_value_list
	;

key_value_list :
    key_value
    | key_value_list key_value
    ;

key_value :
    NAME
    | NAME '=' name_or_string
    | key_value NAME
    | key_value NAME '=' name_or_string
    ;

name_or_string :
	NAME
	| STRING
	;

def_named_pattern :
	NAME pattern
	;

pattern :
    pattern_part repetition
    | pattern pattern_part repetition
    | pattern '|' pattern
    ;

repetition :
    %empty
    | '?'
    | '+'
    | '*'
    ;

pattern_part :
    "\\p{UnicodeIdentifierStart}"
    | "\\p{UnicodeIdentifierPart}"
    | "\\d"
    | "\\s"
    | "\\n"
    | "\\."
    | '.'
    | RECLASS
    | '(' pattern ')'
    | '{' NAME '}'
    ;

rules :
	rule
	| rules rule
	;

rule :
    NL
	| pattern action
	;

action :
    %empty
    | ACTION_CODE
    ;

%%

%x RULES USER_CODE ACTION_CODE
%x CODE_CURLY CODE_PCT_CURLY

%%

"//".*\n?	skip()
"/*"(?s:.)*?"*/"\n?	skip()

^"%begin{"<CODE_CURLY>	"%begin{"
^"%class{"<CODE_CURLY>	"%class{"
^"%init{"<CODE_CURLY>	"%init{"
^"%include"	"%include"
^"%option"	"%option"
^"%state"	"%state"
^"%xstate"	"%xstate"
"="	'='

<RULES>{
    [ \t]+"//".*\n?    skip()
    [ \t]+"{"<>ACTION_CODE>
}

<INITIAL,RULES>{
    [ \t\f\v\r]+  skip()
    "\n"    NL

    "?" '?'
    "+" '+'
    "*" '*'
    "(" '('
    ")" ')'
    "{" '{'
    "}" '}'
    "|" '|'
    "." '.'

    "\\p{UnicodeIdentifierStart}" "\\p{UnicodeIdentifierStart}"
    "\\p{UnicodeIdentifierPart}"    "\\p{UnicodeIdentifierPart}"
    "\\d"    "\\d"
    "\\s"    "\\s"
    "\\n"    "\\n"
    "\\."    "\\."

    \"(\\.|[^"\r\n\\])*\"	STRING
    "["(\\.|[^\]\r\n\\])+"]"  RECLASS

    [A-Za-z_][A-Za-z0-9_-]*	NAME

}

^"%top{"<CODE_CURLY>	"%top{"
<CODE_CURLY>{
	^"}"<INITIAL>	CODE_TILL_CURLY
	.|\n<.>
}

^"%{"<CODE_PCT_CURLY>	"%{"
<CODE_PCT_CURLY>{
	^"%}"<INITIAL>	CODE_TILL_PCT_CURLY
	.|\n<.>
}

^"%%"<RULES>	"%%"

<RULES>{
	^"%%"<USER_CODE>	"%%"
}

<USER_CODE>{
	(.|\n)+	USERCODE
}

<ACTION_CODE>{
    "}"<<>  ACTION_CODE
    "{"<>ACTION_CODE>
    .|\n<.>
}

%%
