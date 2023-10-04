//From: https://github.com/eranif/codelite/blob/master/CodeLite/pp.y

/*Tokens*/
%token PP_DEFINE
%token PP_IF
%token PP_IFDEF
%token PP_DEFINED
%token PP_UNDEF
%token PP_ELSE
%token PP_ELIF
%token PP_ENDIF
%token PP_POUND
%token PP_IDENTIFIER
%token PP_COMPLEX_REPLACEMENT
%token PP_IFNDEF
%token PP_ZERO
%token PP_CPLUSPLUS
%token PP_INCLUDE
%token PP_AND
%token PP_OR
%token PP_EQUAL
%token PP_NEQUAL
%token PP_INT
%token PP_LOWERTHAN
%token PP_GREATERTHAN
%token '('
%token ')'
%token ','


%start translation_unit

%%

translation_unit :
	/*empty*/
	| translation_unit the_macros_rule
	;

the_macros_rule :
	macros
	;

macros :
	define_simple_macros
	| define_func_like_macros
	| if_cplusplus
	| ifdef_simple_macro
	| if_macros
	| elif_macros
	| end_if
	//| error
	;

end_if :
	PP_ENDIF
	;

if_cplusplus :
	PP_IF PP_CPLUSPLUS
	;

define_simple_macros :
	PP_DEFINE PP_IDENTIFIER PP_COMPLEX_REPLACEMENT
	;

define_func_like_macros :
	PP_DEFINE PP_IDENTIFIER '(' args_list ')' PP_COMPLEX_REPLACEMENT
	;

args_list :
	/*empty*/
	| PP_IDENTIFIER
	| args_list ',' PP_IDENTIFIER
	;

ifdef_simple_macro :
	PP_IFDEF PP_IDENTIFIER
	;

if_macros :
	PP_IF if_condition
	;

elif_macros :
	PP_ELIF if_condition
	;

if_condition :
	generic_condition
	;

generic_condition :
	generic_condition_base
	| generic_condition logical_operator generic_condition_base
	;

generic_condition_base :
	/*empty*/
	| '(' PP_IDENTIFIER ')'
	| PP_IDENTIFIER
	| PP_IDENTIFIER test_operator PP_INT
	| '(' PP_IDENTIFIER test_operator PP_INT ')'
	| PP_DEFINED '(' PP_IDENTIFIER ')'
	;

logical_operator :
	PP_AND
	| PP_OR
	;

test_operator :
	PP_EQUAL
	| PP_NEQUAL
	| PP_LOWERTHAN
	| PP_GREATERTHAN
	;

%%

/**
 * the "incl" state is used for picking up the name
 * of an include file
 */
%x incl
%x c_comment
%x cpp_comment
//%x using_namespace
%x PP

/** #define related states **/
%x define_state
%x define_state_2
%x define_state_signature
%x define_state_definition
%x define_generic_c_comment
%x define_generic_cpp_comment
%x ifdef_state
%x if_state

identifier [a-zA-Z_][0-9a-zA-Z_]*
simple_escape [abfnrtv'"?\\]
octal_escape  [0-7]{1,3}
hex_escape "x"[0-9a-fA-F]+

escape_sequence [\\]({simple_escape}|{octal_escape}|{hex_escape})
c_char [^'\\\n]|{escape_sequence}
s_char [^"\\\n]|{escape_sequence}

ns_name  [a-zA-Z][a-zA-Z:_]*
using_ns "using "[ ]*"namespace"
ns_alias "namespace "{ns_name}[ ]*"="[ ]*{ns_name}[ ]*";"

%%

<INITIAL>"//"<cpp_comment>  skip()

<INITIAL>"/*"<c_comment>    skip()

"L"?[']{c_char}+[']     skip() /* eat a string */
"L"?["]{s_char}*["]     skip() /* eat a string */

<INITIAL>#<PP>

<PP>define<define_state>         PP_DEFINE
<PP>if<if_state>        PP_IF
<PP>0<.>                  PP_ZERO
<PP>__cplusplus<.>   PP_CPLUSPLUS
<PP>ifdef<ifdef_state>      PP_IFDEF
<PP>defined<.>	PP_DEFINED
<PP>ifndef<ifdef_state>	   PP_IFDEF
<PP>undef<.>                   PP_UNDEF
<PP>else<.>                    PP_ELSE
<PP>elif<if_state>            PP_ELIF
<PP>endif<.>                   PP_ENDIF
<PP>include<incl>            PP_INCLUDE
<PP>\n<INITIAL>
<PP>.<.>	skip()

<ifdef_state>__cplusplus<.>    PP_CPLUSPLUS
<ifdef_state>{identifier}<.>   PP_IDENTIFIER
<ifdef_state>"("<.>            '('
<ifdef_state>")"<.>            ')'
<ifdef_state>\n<INITIAL>
<ifdef_state>.<.>	skip()

<if_state>__cplusplus<.>    PP_CPLUSPLUS
<if_state>!defined<.>       PP_DEFINED
<if_state>defined<.>        PP_DEFINED
<if_state>{identifier}<.>   PP_IDENTIFIER
<if_state>"("<.>            '('
<if_state>")"<.>            ')'
<if_state>"&&"<.>           PP_AND
<if_state>"||"<.>           PP_OR
<if_state>"="<.>            PP_EQUAL
<if_state>"!="<.>           PP_NEQUAL
<if_state>">"<.>            PP_GREATERTHAN
<if_state>"<"<.>            PP_LOWERTHAN
<if_state>[0-9]+<.>         PP_INT
<if_state>\n<INITIAL>
<if_state>.<.>	skip()

<define_state>{identifier}<define_state_2>  PP_IDENTIFIER
<define_state>\\[\n\r]{1,2}<.>	/* continue define_state */
<define_state>\n<INITIAL>
<define_state>.<.>

<define_state_2>[ \t]<define_state_definition>
/* whitespaces are NOT allowed between the signature and the macro's name,
 * if we found a whitespace, handle this macro as a simple macro */

<define_state_2>"/*"<define_generic_c_comment>        /*{ return_to_state = define_state_2; BEGIN(define_generic_c_comment);}*/
<define_state_2>"//"<define_generic_cpp_comment>        PP_COMPLEX_REPLACEMENT
<define_state_2>"("<define_state_signature>         '('
<define_state_2>\n<INITIAL>          PP_COMPLEX_REPLACEMENT
<define_state_2>.<define_state_definition>

<define_state_signature>{identifier}<.>	PP_IDENTIFIER
<define_state_signature>,<.>            /*{ RET_VAL(((int)*yytext));                            }*/
<define_state_signature>")"<define_state_definition>          /*{ BEGIN(define_state_definition); _definition.clear(); g_definition.Clear(); RET_VAL(((int)*yytext));}*/
<define_state_signature>.<.>

<define_state_definition>"/*"<define_generic_c_comment>        /*{ return_to_state = define_state_definition; BEGIN(define_generic_c_comment);}*/
<define_state_definition>"//"<define_generic_cpp_comment>        PP_COMPLEX_REPLACEMENT

<define_state_definition>\\\n<.>	skip()
<define_state_definition>\n<INITIAL>          PP_COMPLEX_REPLACEMENT
<define_state_definition>\t<.>          /*{ _definition += " ";}*/
<define_state_definition>\r<.>	skip()
<define_state_definition>.<.>

(?s:.)      skip()

<incl>\n<INITIAL>   skip()
<incl>.<.>

<define_generic_c_comment>"*/"<INITIAL> skip() /* {BEGIN(return_to_state);}*/

<define_generic_c_comment>.<.>	skip()

<define_generic_cpp_comment>\n<INITIAL>
<define_generic_cpp_comment>.<.>	skip()

<cpp_comment>\n<INITIAL>    skip()
<cpp_comment>.<.>	skip() /* do nothing */

<c_comment>"*/"<INITIAL>	skip()

<c_comment>(?s:.)<.>	skip()

","	','

%%
