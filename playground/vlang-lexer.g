//From: https://github.com/vlang/v/blob/d970a8fce22c62bd99468f679c19b9cd2c5481b2/vlib/v/token/token.v

%token amp
%token and
%token and_assign
%token arrow
%token assign
%token at
%token bit_not
%token boolean_and_assign
%token boolean_or_assign
%token chartoken
%token colon
%token comma
%token dec
%token decl_assign
%token div
%token div_assign
%token dollar
%token dot
%token dotdot
%token ellipsis
%token eq
%token ge
%token gt
%token hash
%token inc
%token key_as
%token key_asm
%token key_assert
%token key_atomic
%token key_break
%token key_const
%token key_continue
%token key_defer
%token key_dump
%token key_else
%token key_enum
%token key_false
%token key_fn
%token key_for
%token key_global
%token key_go
%token key_goto
%token key_if
%token key_ilike
%token key_implements
%token key_import
%token key_in
%token key_interface
%token key_is
%token key_isreftype
%token key_like
%token key_likely
%token key_lock
%token key_match
%token key_module
%token key_mut
%token key_nil
%token key_none
%token key_offsetof
%token key_orelse
%token key_pub
%token key_return
%token key_rlock
%token key_select
%token key_shared
%token key_sizeof
%token key_spawn
%token key_static
%token key_struct
%token key_true
%token key_type
%token key_typeof
%token key_union
%token key_unlikely
%token key_unsafe
%token key_volatile
%token lcbr
%token le
%token left_shift
%token left_shift_assign
%token logical_or
%token lpar
%token lsbr
%token lt
%token minus
%token minus_assign
%token mod
%token mod_assign
%token mul
%token mult_assign
%token name
%token ne
%token nilsbr
%token not
%token not_in
%token not_is
%token number
%token or_assign
%token pipe
%token plus
%token plus_assign
%token question
%token rcbr
%token right_shift
%token right_shift_assign
%token rpar
%token rsbr
%token semicolon
%token str_inter
%token string
%token unsigned_right_shift
%token unsigned_right_shift_assign
%token xor
%token xor_assign

%%

input :
	%empty
	| tokens
	;

tokens :
	token
	| tokens token
	;

token :
	amp
	| and
	| and_assign
	| arrow
	| assign
	| at
	| bit_not
	| boolean_and_assign
	| boolean_or_assign
	| chartoken
	| colon
	| comma
	| dec
	| decl_assign
	| div
	| div_assign
	| dollar
	| dot
	| dotdot
	| ellipsis
	| eq
	| ge
	| gt
	| hash
	| inc
	| key_as
	| key_asm
	| key_assert
	| key_atomic
	| key_break
	| key_const
	| key_continue
	| key_defer
	| key_dump
	| key_else
	| key_enum
	| key_false
	| key_fn
	| key_for
	| key_global
	| key_go
	| key_goto
	| key_if
	| key_ilike
	| key_implements
	| key_import
	| key_in
	| key_interface
	| key_is
	| key_isreftype
	| key_like
	| key_likely
	| key_lock
	| key_match
	| key_module
	| key_mut
	| key_nil
	| key_none
	| key_offsetof
	| key_orelse
	| key_pub
	| key_return
	| key_rlock
	| key_select
	| key_shared
	| key_sizeof
	| key_spawn
	| key_static
	| key_struct
	| key_true
	| key_type
	| key_typeof
	| key_union
	| key_unlikely
	| key_unsafe
	| key_volatile
	| lcbr
	| le
	| left_shift
	| left_shift_assign
	| logical_or
	| lpar
	| lsbr
	| lt
	| minus
	| minus_assign
	| mod
	| mod_assign
	| mul
	| mult_assign
	| name
	| ne
	| nilsbr
	| not
	| not_in
	| not_is
	| number
	| or_assign
	| pipe
	| plus
	| plus_assign
	| question
	| rcbr
	| right_shift
	| right_shift_assign
	| rpar
	| rsbr
	| semicolon
	| str_inter
	| string
	| unsigned_right_shift
	| unsigned_right_shift_assign
	| xor
	| xor_assign
	;
%%

%x SQSTR DQSTR STR_INTER BLOCK_COMMENT

%%

[ \t\r\n]+	skip()
"//".*	skip()

"/*"<>BLOCK_COMMENT>
<BLOCK_COMMENT>{
    "/*"<>>
    "*/"<<> skip()
    .|\n<.>
}

"+"	plus
"-"	minus
"*"	mul
"/"	div
"%"	mod
"^"	xor
"|"	pipe
"++"	inc
"--"	dec
"&&"	and
"||"	logical_or
"!"	not
"~"	bit_not
"?"	question
","	comma
";"	semicolon
":"	colon
"<-"	arrow
"&"	amp
"#"	hash
"$"	dollar
"@"	at
str_dollar
"<<"	left_shift
">>"	right_shift
">>>"	unsigned_right_shift
"!in"	not_in
"!is"	not_is
"="	assign
":="	decl_assign
"+="	plus_assign
"-="	minus_assign
"/="	div_assign
"*="	mult_assign
"^="	xor_assign
"%="	mod_assign
"|="	or_assign
"&="	and_assign
"<<="	right_shift_assign
">>="	left_shift_assign
">>>="	unsigned_right_shift_assign
"&&="	boolean_and_assign
"||="	boolean_or_assign
"{"	lcbr
"}"	rcbr
"("	lpar
")"	rpar
"["	lsbr
"#["	nilsbr
"]"	rsbr
"=="	eq
"!="	ne
">"	gt
"<"	lt
">="	ge
"<="	le
"."	dot
".."	dotdot
"..."	ellipsis

"as"	key_as
"asm"	key_asm
"assert"	key_assert
"atomic"	key_atomic
"break"	key_break
"const"	key_const
"continue"	key_continue
"defer"	key_defer
"else"	key_else
"enum"	key_enum
"false"	key_false
"for"	key_for
"fn"	key_fn
"global"	key_global
"go"	key_go
"goto"	key_goto
"if"	key_if
"import"	key_import
"in"	key_in
"interface"	key_interface
"is"	key_is
"match"	key_match
"module"	key_module
"mut"	key_mut
"nil"	key_nil
"shared"	key_shared
"lock"	key_lock
"rlock"	key_rlock
"none"	key_none
"return"	key_return
"select"	key_select
"like"	key_like
"ilike"	key_ilike
"sizeof"	key_sizeof
"isreftype"	key_isreftype
"likely"	key_likely
"unlikely"	key_unlikely
"offsetof"	key_offsetof
"struct"	key_struct
"true"	key_true
"type"	key_type
"typeof"	key_typeof
"dump"	key_dump
"orelse"	key_orelse
"union"	key_union
"pub"	key_pub
"static"	key_static
"volatile"	key_volatile
"unsafe"	key_unsafe
"spawn"	key_spawn
"implements"	key_implements

[0-9]+("."[0-9]+)?	number     // 123
//'(\\.|[^'\r\n\\])*'	string     // 'foo'
str_inter	str_inter  // 'name=$user.name'
"`"(\\.|[^`\r\n\\])+"`"	chartoken  // `A` - rune

'<SQSTR>
<SQSTR>{
    "${"<>STR_INTER>
    "'"<INITIAL>    string
    \\\n|\\.|[^'\\]<.>
}

\"<DQSTR>
<DQSTR>{
    "${"<>STR_INTER>
    \"<INITIAL>    string
    \\\n|\\.|[^"\\]<.>
}

<STR_INTER>{
    "}"<<>
    .|\n<.>
}

r(\"[^"]+\"|'[^'']*')   string

[A-Za-z_][A-Za-z0.9_]*	name       // user


%%
