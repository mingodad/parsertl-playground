//From: https://github.com/thautwarm/lua-parser-lark/blob/06cf19bc8595a70823fc0f67462ca29dd9e118a0/lua_parser/lua.lark

%token SHARP MOD AMP LPAR RPAR STAR PLUS COMMA MINUS DOT DOT2 ELLIPSE DIV FLOOR_DIV
%token COLON LABEL SEMICOL LT LSHIFT LE ASSIGN EQ GT GE RSHIFT LB RB CARET AND BREAK
%token DO ELSE ELSEIF END FALSE FOR FUNCTION GOTO IF IN LOCAL NIL NOT OR REPEAT RETURN
%token THEN TRUE UNTIL WHILE LBRACE VBAR RBRACE INV INVEQ NAME NESTED_STR NUMERAL STR_LIT //UNKNOWN


%%

start : block ;

nempty_list_of_stat : stat #nempty_list_of_stat_0
                    | nempty_list_of_stat stat #nempty_list_of_stat_1 ;

allow_empty_list_of_stat :  #allow_empty_list_of_stat_0
                         | nempty_list_of_stat #allow_empty_list_of_stat_1 ;

list_of_stat : allow_empty_list_of_stat #list_of_stat_0 ;

opt_retstat : retstat #opt_retstat_0
            |  #opt_retstat_1 ;

block : list_of_stat opt_retstat #block_0 ;

opt_semicol : | SEMICOL ;

retstat : RETURN list_of_exp_sep_by_comma opt_semicol #retstat_0 ;

nempty_list_of_elif : elseif #nempty_list_of_elif_0
                    | nempty_list_of_elif elseif #nempty_list_of_elif_1 ;

allow_empty_o_nempty_list_of_elif_p_ :  #allow_empty_o_nempty_list_of_elif_p__0
                                   | nempty_list_of_elif #allow_empty_o_nempty_list_of_elif_p__1 ;

list_of_elif : allow_empty_o_nempty_list_of_elif_p_ #list_of_elif_0 ;

opt_else : else_block #opt_else_0
         |  #opt_else_1 ;

stat : SEMICOL #stat_0
     | nempty_list_of_exp_sep_by_comma ASSIGN nempty_list_of_exp_sep_by_comma #stat_1
     | exp #stat_2
     | LABEL NAME LABEL #stat_3
     | BREAK #stat_4
     | GOTO NAME #stat_5
     | DO block END #stat_6
     | WHILE exp DO block END #stat_7
     | REPEAT block UNTIL exp #stat_8
     | IF exp THEN block list_of_elif opt_else END #stat_9
     | FOR NAME ASSIGN range DO block END #stat_10
     | FOR nempty_list_of_name_sep_by_comma IN nempty_list_of_exp_sep_by_comma DO block END #stat_11
     | LOCAL FUNCTION funcname LPAR opt_parlist RPAR block END #stat_12
     | LOCAL nempty_list_of_name_sep_by_comma opt_assign_rhs #stat_13 ;

opt_assign_rhs : ASSIGN nempty_list_of_exp_sep_by_comma #opt_assign_rhs_0
               |  #opt_assign_rhs_1 ;

range : exp COMMA exp range_tail #range_0 ;

range_tail : COMMA exp #range_tail_0
           |  #range_tail_1 ;

elseif : ELSEIF exp THEN block #elseif_0 ;

else_block : ELSE block #else_block_0 ;

exp : binexp #exp_0 ;

binexp : binseq #binexp_0 ;

binseq : binseq binop binoperand #binseq_0
       | binoperand #binseq_1 ;

binoperand : unaryexp #binoperand_0 ;

unaryexp : SHARP exponent #unaryexp_0
         | MINUS exponent #unaryexp_1
         | INV exponent #unaryexp_2
         | NOT exponent #unaryexp_3
         | exponent #unaryexp_4 ;

exponent : prefixexp CARET exponent #exponent_0
         | prefixexp #exponent_1 ;

prefixexp : NAME #prefixexp_0
          | LPAR exp RPAR #prefixexp_1
          | prefixexp args #prefixexp_2
          | prefixexp COLON NAME args #prefixexp_3
          | prefixexp LB exp RB #prefixexp_4
          | prefixexp DOT NAME #prefixexp_5
          | atom #prefixexp_6 ;

atom : NIL #atom_0
     | FALSE #atom_1
     | TRUE #atom_2
     | NUMERAL #atom_3
     | STR_LIT #atom_4
     | NESTED_STR #atom_5
     | ELLIPSE #atom_6
     | functiondef #atom_7
     | tableconstructor #atom_8 ;

nempty_list_of_exp_sep_by_comma : exp #nempty_list_of_exp_sep_by_comma_0
                                | nempty_list_of_exp_sep_by_comma COMMA exp #nempty_list_of_exp_sep_by_comma_1 ;

allow_empty_list_of_exp_sep_by_comma :  #allow_empty_list_of_exp_sep_by_comma_0
                                     | nempty_list_of_exp_sep_by_comma #allow_empty_list_of_exp_sep_by_comma_1 ;

list_of_exp_sep_by_comma : allow_empty_list_of_exp_sep_by_comma #list_of_exp_sep_by_comma_0 ;

args : LPAR list_of_exp_sep_by_comma RPAR #args_0
     | tableconstructor #args_1
     | STR_LIT #args_2 ;

opt_funcname : funcname #opt_funcname_0
                  |  #opt_funcname_1 ;

opt_parlist : parlist #opt_parlist_0
                 |  #opt_parlist_1 ;

functiondef : FUNCTION opt_funcname LPAR opt_parlist RPAR block END #functiondef_0 ;

varargs : COMMA ELLIPSE #varargs_0
        |  #varargs_1 ;

nempty_list_of_name_sep_by_comma : NAME #nempty_list_of_name_sep_by_comma_0
                                           | nempty_list_of_name_sep_by_comma COMMA NAME #nempty_list_of_name_sep_by_comma_1;

parlist : ELLIPSE #parlist_0
        | nempty_list_of_name_sep_by_comma varargs #parlist_1 ;

nempty_list_of_field : field #nempty_list_of_field_0
                                     | nempty_list_of_field fieldsep field #nempty_list_of_field_1 ;

opt_fieldsep : | fieldsep ;

tableconstructor : LBRACE nempty_list_of_field opt_fieldsep RBRACE #tableconstructor_0
                 | LBRACE RBRACE #tableconstructor_1 ;

funcname : funcname DOT NAME #funcname_0
         | funcname COLON NAME #funcname_1
         | NAME #funcname_2 ;

field : LB exp RB ASSIGN exp #field_0
      | NAME ASSIGN exp #field_1
      | exp #field_2 ;

fieldsep : COMMA #fieldsep_0
         | SEMICOL #fieldsep_1 ;

binop : (OR
      | AND
      | LT
      | GT
      | LE
      | GE
      | INVEQ
      | EQ
      | VBAR
      | INV
      | AMP
      | LSHIFT
      | RSHIFT
      | DOT2
      | PLUS
      | MINUS
      | STAR
      | DIV
      | FLOOR_DIV
      | MOD) #binop ;

%%

%x LONGCOMMENT LONGSTRING

longbracket                     \[=*\[

%%

[\n\r\t ]+	skip()
"--".*	skip()
"--"{longbracket}<LONGCOMMENT>

<LONGCOMMENT>\]=*\]<INITIAL>	skip()
<LONGCOMMENT>.|\n<.>                          /* ignore long comment */

"&"	AMP
and	AND
"="	ASSIGN
break	BREAK
"^"	CARET
":"	COLON
","	COMMA
"/"	DIV
do	DO
"."	DOT
".."	DOT2
"..."	ELLIPSE
else	ELSE
elseif	ELSEIF
end	END
"=="	EQ
false	FALSE
"//"	FLOOR_DIV
for	FOR
function	FUNCTION
">="	GE
goto	GOTO
">"	GT
if	IF
in	IN
"~"	INV
"~="	INVEQ
"::"	LABEL
"["	LB
"{"	LBRACE
"<="	LE
local	LOCAL
"("	LPAR
"<<"	LSHIFT
"<"	LT
"-"	MINUS
"%"	MOD
nil	NIL
not	NOT
or	OR
"+"	PLUS
"]"	RB
"}"	RBRACE
repeat	REPEAT
return	RETURN
")"	RPAR
">>"	RSHIFT
";"	SEMICOL
"#"	SHARP
"*"	STAR
then	THEN
true	TRUE
until	UNTIL
"|"	VBAR
while	WHILE

{longbracket}<LONGSTRING>
<LONGSTRING>\]=*\]<INITIAL>	STRING
<LONGSTRING>.|\n<.>

0[xX][a-fA-F0-9]+|[0-9]+([Ee][+-]?[0-9]+)?|[0-9]*\.[0-9]+([Ee][+-]?[0-9]+)?	NUMERAL
NESTED_STR	NESTED_STR
'(\\.|[^'\n\r\\])*'	STR_LIT
\"(\\.|[^"\n\r\\])*\"	STR_LIT
[A-Za-z_][A-Za-z0-9_]*	NAME

%%
