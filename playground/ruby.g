//Warning: Token "'\([^']+\)'" does not have a lexer definiton.

/*Tokens*/
%token END_OF_INPUT
%token keyword_class
%token keyword_module
%token keyword_def
%token keyword_undef
%token keyword_begin
%token keyword_rescue
%token keyword_ensure
%token keyword_end
%token keyword_if
%token keyword_unless
%token keyword_then
%token keyword_elsif
%token keyword_else
%token keyword_case
%token keyword_when
%token keyword_while
%token keyword_until
%token keyword_for
%token keyword_break
%token keyword_next
%token keyword_redo
%token keyword_retry
%token keyword_in
%token keyword_do
%token keyword_do_cond
%token keyword_do_block
%token keyword_do_LAMBDA
%token keyword_return
%token keyword_yield
%token keyword_super
%token keyword_self
%token keyword_nil
%token keyword_true
%token keyword_false
%token keyword_and
%token keyword_or
%token keyword_not
%token modifier_if
%token modifier_unless
%token modifier_while
%token modifier_until
%token modifier_rescue
%token keyword_alias
%token keyword_defined
%token keyword_BEGIN
%token keyword_END
%token keyword__LINE__
%token keyword__FILE__
%token keyword__ENCODING__
%token tIDENTIFIER
%token tFID
%token tGVAR
%token tIVAR
%token tCONSTANT
%token tCVAR
%token tLABEL
%token tINTEGER
%token tFLOAT
%token tRATIONAL
%token tIMAGINARY
%token tCHAR
%token tNTH_REF
%token tBACK_REF
%token tSTRING_CONTENT
%token tREGEXP_END
%token '.'
%token tUPLUS
%token tUMINUS
%token tPOW
%token tCMP
%token tEQ
%token tEQQ
%token tNEQ
%token tGEQ
%token tLEQ
%token tANDOP
%token tOROP
%token tMATCH
%token tNMATCH
%token tDOT2
%token tDOT3
%token tBDOT2
%token tBDOT3
%token tAREF
%token tASET
%token tLSHFT
%token tRSHFT
%token tANDDOT
%token tCOLON2
%token tCOLON3
%token tOP_ASGN
%token tASSOC
%token tLPAREN
%token tLPAREN_ARG
%token tLBRACK
%token tLBRACE
%token tLBRACE_ARG
%token tSTAR
%token tDSTAR
%token tAMPER
%token tLAMBDA
%token tSYMBEG
%token tSTRING_BEG
%token tXSTRING_BEG
%token tREGEXP_BEG
%token tWORDS_BEG
%token tQWORDS_BEG
%token tSYMBOLS_BEG
%token tQSYMBOLS_BEG
%token tSTRING_END
%token tSTRING_DEND
%token tSTRING_DBEG
%token tSTRING_DVAR
%token tLAMBEG
%token tLABEL_END
%token '='
%token '?'
%token ':'
%token '>'
%token '<'
%token '|'
%token '^'
%token '&'
%token '+'
%token '-'
%token '*'
%token '/'
%token '%'
%token tUMINUS_NUM
%token '!'
%token '~'
%token '{'
%token '}'
%token '['
%token ','
%token '`'
%token '('
%token ')'
%token ']'
%token ';'
%token ' '
%token '\n'

%nonassoc /*1*/ tLOWEST
%nonassoc /*2*/ tLBRACE_ARG
%nonassoc /*3*/ keyword_in modifier_if modifier_unless modifier_while modifier_until
%left /*4*/ keyword_and keyword_or
%right /*5*/ keyword_not
%nonassoc /*6*/ keyword_defined
%right /*7*/ tOP_ASGN '='
%left /*8*/ modifier_rescue
%right /*9*/ '?' ':'
%nonassoc /*10*/ tDOT2 tDOT3 tBDOT2 tBDOT3
%left /*11*/ tOROP
%left /*12*/ tANDOP
%nonassoc /*13*/ tCMP tEQ tEQQ tNEQ tMATCH tNMATCH
%left /*14*/ tGEQ tLEQ '>' '<'
%left /*15*/ '|' '^'
%left /*16*/ '&'
%left /*17*/ tLSHFT tRSHFT
%left /*18*/ '+' '-'
%left /*19*/ '*' '/' '%'
%right /*20*/ tUMINUS tUMINUS_NUM
%right /*21*/ tPOW
%right /*22*/ tUPLUS '!' '~'

%start program

%%

program :
	END_OF_INPUT
	| top_compstmt
	;

top_compstmt :
	top_stmts opt_terms
	;

top_stmts :
	none
	| top_stmt
	| top_stmts terms top_stmt
	//| error top_stmt
	;

top_stmt :
	stmt
	| keyword_BEGIN begin_block
	;

begin_block :
	'{' top_compstmt '}'
	;

bodystmt :
	compstmt opt_rescue k_else compstmt opt_ensure
	| compstmt opt_rescue opt_ensure
	;

compstmt :
	stmts opt_terms
	;

stmts :
	none
	| stmt_or_begin
	| stmts terms stmt_or_begin
	//| error stmt
	;

stmt_or_begin :
	stmt
	| keyword_BEGIN begin_block
	;

stmt :
	keyword_alias fitem fitem
	| keyword_alias tGVAR tGVAR
	| keyword_alias tGVAR tBACK_REF
	| keyword_alias tGVAR tNTH_REF
	| keyword_undef undef_list
	| stmt modifier_if /*3N*/ expr_value
	| stmt modifier_unless /*3N*/ expr_value
	| stmt modifier_while /*3N*/ expr_value
	| stmt modifier_until /*3N*/ expr_value
	| stmt modifier_rescue /*8L*/ stmt
	| keyword_END '{' compstmt '}'
	| command_asgn
	| mlhs '=' /*7R*/ command_call
	| lhs '=' /*7R*/ mrhs
	| mlhs '=' /*7R*/ mrhs_arg modifier_rescue /*8L*/ stmt
	| mlhs '=' /*7R*/ mrhs_arg
	| expr
	;

command_asgn :
	lhs '=' /*7R*/ command_rhs
	| var_lhs tOP_ASGN /*7R*/ command_rhs
	| primary_value '[' opt_call_args rbracket tOP_ASGN /*7R*/ command_rhs
	| primary_value call_op tIDENTIFIER tOP_ASGN /*7R*/ command_rhs
	| primary_value call_op tCONSTANT tOP_ASGN /*7R*/ command_rhs
	| primary_value tCOLON2 tCONSTANT tOP_ASGN /*7R*/ command_rhs
	| primary_value tCOLON2 tIDENTIFIER tOP_ASGN /*7R*/ command_rhs
	| backref tOP_ASGN /*7R*/ command_rhs
	;

command_rhs :
	command_call %prec tOP_ASGN /*7R*/
	| command_call modifier_rescue /*8L*/ stmt
	| command_asgn
	;

expr :
	command_call
	| expr keyword_and /*4L*/ expr
	| expr keyword_or /*4L*/ expr
	| keyword_not /*5R*/ opt_nl expr
	| '!' /*22R*/ command_call
	| arg keyword_in /*3N*/ p_expr
	| arg %prec tLBRACE_ARG /*2N*/
	;

expr_value :
	expr
	;

expr_value_do :
	expr_value do
	;

command_call :
	command
	| block_command
	;

block_command :
	block_call
	| block_call call_op2 operation2 command_args
	;

cmd_brace_block :
	tLBRACE_ARG /*2N*/ brace_body '}'
	;

fcall :
	operation
	;

command :
	fcall command_args %prec tLOWEST /*1N*/
	| fcall command_args cmd_brace_block
	| primary_value call_op operation2 command_args %prec tLOWEST /*1N*/
	| primary_value call_op operation2 command_args cmd_brace_block
	| primary_value tCOLON2 operation2 command_args %prec tLOWEST /*1N*/
	| primary_value tCOLON2 operation2 command_args cmd_brace_block
	| keyword_super command_args
	| keyword_yield command_args
	| k_return call_args
	| keyword_break call_args
	| keyword_next call_args
	;

mlhs :
	mlhs_basic
	| tLPAREN mlhs_inner rparen
	;

mlhs_inner :
	mlhs_basic
	| tLPAREN mlhs_inner rparen
	;

mlhs_basic :
	mlhs_head
	| mlhs_head mlhs_item
	| mlhs_head tSTAR mlhs_node
	| mlhs_head tSTAR mlhs_node ',' mlhs_post
	| mlhs_head tSTAR
	| mlhs_head tSTAR ',' mlhs_post
	| tSTAR mlhs_node
	| tSTAR mlhs_node ',' mlhs_post
	| tSTAR
	| tSTAR ',' mlhs_post
	;

mlhs_item :
	mlhs_node
	| tLPAREN mlhs_inner rparen
	;

mlhs_head :
	mlhs_item ','
	| mlhs_head mlhs_item ','
	;

mlhs_post :
	mlhs_item
	| mlhs_post ',' mlhs_item
	;

mlhs_node :
	user_variable
	| keyword_variable
	| primary_value '[' opt_call_args rbracket
	| primary_value call_op tIDENTIFIER
	| primary_value tCOLON2 tIDENTIFIER
	| primary_value call_op tCONSTANT
	| primary_value tCOLON2 tCONSTANT
	| tCOLON3 tCONSTANT
	| backref
	;

lhs :
	user_variable
	| keyword_variable
	| primary_value '[' opt_call_args rbracket
	| primary_value call_op tIDENTIFIER
	| primary_value tCOLON2 tIDENTIFIER
	| primary_value call_op tCONSTANT
	| primary_value tCOLON2 tCONSTANT
	| tCOLON3 tCONSTANT
	| backref
	;

cname :
	tIDENTIFIER
	| tCONSTANT
	;

cpath :
	tCOLON3 cname
	| cname
	| primary_value tCOLON2 cname
	;

fname :
	tIDENTIFIER
	| tCONSTANT
	| tFID
	| op
	| reswords
	;

fitem :
	fname
	| symbol
	;

undef_list :
	fitem
	| undef_list ',' fitem
	;

op :
	'|' /*15L*/
	| '^' /*15L*/
	| '&' /*16L*/
	| tCMP /*13N*/
	| tEQ /*13N*/
	| tEQQ /*13N*/
	| tMATCH /*13N*/
	| tNMATCH /*13N*/
	| '>' /*14L*/
	| tGEQ /*14L*/
	| '<' /*14L*/
	| tLEQ /*14L*/
	| tNEQ /*13N*/
	| tLSHFT /*17L*/
	| tRSHFT /*17L*/
	| '+' /*18L*/
	| '-' /*18L*/
	| '*' /*19L*/
	| tSTAR
	| '/' /*19L*/
	| '%' /*19L*/
	| tPOW /*21R*/
	| tDSTAR
	| '!' /*22R*/
	| '~' /*22R*/
	| tUPLUS /*22R*/
	| tUMINUS /*20R*/
	| tAREF
	| tASET
	| '`'
	;

reswords :
	keyword__LINE__
	| keyword__FILE__
	| keyword__ENCODING__
	| keyword_BEGIN
	| keyword_END
	| keyword_alias
	| keyword_and /*4L*/
	| keyword_begin
	| keyword_break
	| keyword_case
	| keyword_class
	| keyword_def
	| keyword_defined /*6N*/
	| keyword_do
	| keyword_else
	| keyword_elsif
	| keyword_end
	| keyword_ensure
	| keyword_false
	| keyword_for
	| keyword_in /*3N*/
	| keyword_module
	| keyword_next
	| keyword_nil
	| keyword_not /*5R*/
	| keyword_or /*4L*/
	| keyword_redo
	| keyword_rescue
	| keyword_retry
	| keyword_return
	| keyword_self
	| keyword_super
	| keyword_then
	| keyword_true
	| keyword_undef
	| keyword_when
	| keyword_yield
	| keyword_if
	| keyword_unless
	| keyword_while
	| keyword_until
	;

arg :
	lhs '=' /*7R*/ arg_rhs
	| var_lhs tOP_ASGN /*7R*/ arg_rhs
	| primary_value '[' opt_call_args rbracket tOP_ASGN /*7R*/ arg_rhs
	| primary_value call_op tIDENTIFIER tOP_ASGN /*7R*/ arg_rhs
	| primary_value call_op tCONSTANT tOP_ASGN /*7R*/ arg_rhs
	| primary_value tCOLON2 tIDENTIFIER tOP_ASGN /*7R*/ arg_rhs
	| primary_value tCOLON2 tCONSTANT tOP_ASGN /*7R*/ arg_rhs
	| tCOLON3 tCONSTANT tOP_ASGN /*7R*/ arg_rhs
	| backref tOP_ASGN /*7R*/ arg_rhs
	| arg tDOT2 /*10N*/ arg
	| arg tDOT3 /*10N*/ arg
	| arg tDOT2 /*10N*/
	| arg tDOT3 /*10N*/
	| tBDOT2 /*10N*/ arg
	| tBDOT3 /*10N*/ arg
	| arg '+' /*18L*/ arg
	| arg '-' /*18L*/ arg
	| arg '*' /*19L*/ arg
	| arg '/' /*19L*/ arg
	| arg '%' /*19L*/ arg
	| arg tPOW /*21R*/ arg
	| tUMINUS_NUM /*20R*/ simple_numeric tPOW /*21R*/ arg
	| tUPLUS /*22R*/ arg
	| tUMINUS /*20R*/ arg
	| arg '|' /*15L*/ arg
	| arg '^' /*15L*/ arg
	| arg '&' /*16L*/ arg
	| arg tCMP /*13N*/ arg
	| rel_expr %prec tCMP /*13N*/
	| arg tEQ /*13N*/ arg
	| arg tEQQ /*13N*/ arg
	| arg tNEQ /*13N*/ arg
	| arg tMATCH /*13N*/ arg
	| arg tNMATCH /*13N*/ arg
	| '!' /*22R*/ arg
	| '~' /*22R*/ arg
	| arg tLSHFT /*17L*/ arg
	| arg tRSHFT /*17L*/ arg
	| arg tANDOP /*12L*/ arg
	| arg tOROP /*11L*/ arg
	| keyword_defined /*6N*/ opt_nl arg
	| arg '?' /*9R*/ arg opt_nl ':' /*9R*/ arg
	| primary
	;

relop :
	'>' /*14L*/
	| '<' /*14L*/
	| tGEQ /*14L*/
	| tLEQ /*14L*/
	;

rel_expr :
	arg relop arg %prec '>' /*14L*/
	| rel_expr relop arg %prec '>' /*14L*/
	;

arg_value :
	arg
	;

aref_args :
	none
	| args trailer
	| args ',' assocs trailer
	| assocs trailer
	;

arg_rhs :
	arg %prec tOP_ASGN /*7R*/
	| arg modifier_rescue /*8L*/ arg
	;

paren_args :
	'(' opt_call_args rparen
	| '(' args_forward rparen
	;

opt_paren_args :
	none
	| paren_args
	;

opt_call_args :
	none
	| call_args
	| args ','
	| args ',' assocs ','
	| assocs ','
	;

call_args :
	command
	| args opt_block_arg
	| assocs opt_block_arg
	| args ',' assocs opt_block_arg
	| block_arg
	;

command_args :
	call_args
	;

block_arg :
	tAMPER arg_value
	;

opt_block_arg :
	',' block_arg
	| none
	;

args :
	arg_value
	| tSTAR arg_value
	| args ',' arg_value
	| args ',' tSTAR arg_value
	;

mrhs_arg :
	mrhs
	| arg_value
	;

mrhs :
	args ',' arg_value
	| args ',' tSTAR arg_value
	| tSTAR arg_value
	;

primary :
	literal
	| strings
	| xstring
	| regexp
	| words
	| qwords
	| symbols
	| qsymbols
	| var_ref
	| backref
	| tFID
	| k_begin bodystmt k_end
	| tLPAREN_ARG rparen
	| tLPAREN_ARG stmt rparen
	| tLPAREN compstmt ')'
	| primary_value tCOLON2 tCONSTANT
	| tCOLON3 tCONSTANT
	| tLBRACK aref_args ']'
	| tLBRACE assoc_list '}'
	| k_return
	| keyword_yield '(' call_args rparen
	| keyword_yield '(' rparen
	| keyword_yield
	| keyword_defined /*6N*/ opt_nl '(' expr rparen
	| keyword_not /*5R*/ '(' expr rparen
	| keyword_not /*5R*/ '(' rparen
	| fcall brace_block
	| method_call
	| method_call brace_block
	| tLAMBDA lambda
	| k_if expr_value then compstmt if_tail k_end
	| k_unless expr_value then compstmt opt_else k_end
	| k_while expr_value_do compstmt k_end
	| k_until expr_value_do compstmt k_end
	| k_case expr_value opt_terms case_body k_end
	| k_case opt_terms case_body k_end
	| k_case expr_value opt_terms p_case_body k_end
	| k_for for_var keyword_in /*3N*/ expr_value_do compstmt k_end
	| k_class cpath superclass bodystmt k_end
	| k_class tLSHFT /*17L*/ expr term bodystmt k_end
	| k_module cpath bodystmt k_end
	| k_def fname f_arglist bodystmt k_end
	| k_def singleton dot_or_colon fname f_arglist bodystmt k_end
	| keyword_break
	| keyword_next
	| keyword_redo
	| keyword_retry
	;

primary_value :
	primary
	;

k_begin :
	keyword_begin
	;

k_if :
	keyword_if
	;

k_unless :
	keyword_unless
	;

k_while :
	keyword_while
	;

k_until :
	keyword_until
	;

k_case :
	keyword_case
	;

k_for :
	keyword_for
	;

k_class :
	keyword_class
	;

k_module :
	keyword_module
	;

k_def :
	keyword_def
	;

k_do :
	keyword_do
	;

k_do_block :
	keyword_do_block
	;

k_rescue :
	keyword_rescue
	;

k_ensure :
	keyword_ensure
	;

k_when :
	keyword_when
	;

k_else :
	keyword_else
	;

k_elsif :
	keyword_elsif
	;

k_end :
	keyword_end
	;

k_return :
	keyword_return
	;

then :
	term
	| keyword_then
	| term keyword_then
	;

do :
	term
	| keyword_do_cond
	;

if_tail :
	opt_else
	| k_elsif expr_value then compstmt if_tail
	;

opt_else :
	none
	| k_else compstmt
	;

for_var :
	lhs
	| mlhs
	;

f_marg :
	f_norm_arg
	| tLPAREN f_margs rparen
	;

f_marg_list :
	f_marg
	| f_marg_list ',' f_marg
	;

f_margs :
	f_marg_list
	| f_marg_list ',' f_rest_marg
	| f_marg_list ',' f_rest_marg ',' f_marg_list
	| f_rest_marg
	| f_rest_marg ',' f_marg_list
	;

f_rest_marg :
	tSTAR f_norm_arg
	| tSTAR
	;

block_args_tail :
	f_block_kwarg ',' f_kwrest opt_f_block_arg
	| f_block_kwarg opt_f_block_arg
	| f_kwrest opt_f_block_arg
	| f_no_kwarg opt_f_block_arg
	| f_block_arg
	;

opt_block_args_tail :
	',' block_args_tail
	| /*empty*/
	;

block_param :
	f_arg ',' f_block_optarg ',' f_rest_arg opt_block_args_tail
	| f_arg ',' f_block_optarg ',' f_rest_arg ',' f_arg opt_block_args_tail
	| f_arg ',' f_block_optarg opt_block_args_tail
	| f_arg ',' f_block_optarg ',' f_arg opt_block_args_tail
	| f_arg ',' f_rest_arg opt_block_args_tail
	| f_arg ','
	| f_arg ',' f_rest_arg ',' f_arg opt_block_args_tail
	| f_arg opt_block_args_tail
	| f_block_optarg ',' f_rest_arg opt_block_args_tail
	| f_block_optarg ',' f_rest_arg ',' f_arg opt_block_args_tail
	| f_block_optarg opt_block_args_tail
	| f_block_optarg ',' f_arg opt_block_args_tail
	| f_rest_arg opt_block_args_tail
	| f_rest_arg ',' f_arg opt_block_args_tail
	| block_args_tail
	;

opt_block_param :
	none
	| block_param_def
	;

block_param_def :
	'|' /*15L*/ opt_bv_decl '|' /*15L*/
	| '|' /*15L*/ block_param opt_bv_decl '|' /*15L*/
	;

opt_bv_decl :
	opt_nl
	| opt_nl ';' bv_decls opt_nl
	;

bv_decls :
	bvar
	| bv_decls ',' bvar
	;

bvar :
	tIDENTIFIER
	| f_bad_arg
	;

lambda :
	f_larglist lambda_body
	;

f_larglist :
	'(' f_args opt_bv_decl ')'
	| f_args
	;

lambda_body :
	tLAMBEG compstmt '}'
	| keyword_do_LAMBDA bodystmt k_end
	;

do_block :
	k_do_block do_body k_end
	;

block_call :
	command do_block
	| block_call call_op2 operation2 opt_paren_args
	| block_call call_op2 operation2 opt_paren_args brace_block
	| block_call call_op2 operation2 command_args do_block
	;

method_call :
	fcall paren_args
	| primary_value call_op operation2 opt_paren_args
	| primary_value tCOLON2 operation2 paren_args
	| primary_value tCOLON2 operation3
	| primary_value call_op paren_args
	| primary_value tCOLON2 paren_args
	| keyword_super paren_args
	| keyword_super
	| primary_value '[' opt_call_args rbracket
	;

brace_block :
	'{' brace_body '}'
	| k_do do_body k_end
	;

brace_body :
	opt_block_param compstmt
	;

do_body :
	opt_block_param bodystmt
	;

case_args :
	arg_value
	| tSTAR arg_value
	| case_args ',' arg_value
	| case_args ',' tSTAR arg_value
	;

case_body :
	k_when case_args then compstmt cases
	;

cases :
	opt_else
	| case_body
	;

p_case_body :
	keyword_in /*3N*/ p_top_expr then compstmt p_cases
	;

p_cases :
	opt_else
	| p_case_body
	;

p_top_expr :
	p_top_expr_body
	| p_top_expr_body modifier_if /*3N*/ expr_value
	| p_top_expr_body modifier_unless /*3N*/ expr_value
	;

p_top_expr_body :
	p_expr
	| p_expr ','
	| p_expr ',' p_args
	| p_args_tail
	| p_kwargs
	;

p_expr :
	p_as
	;

p_as :
	p_expr tASSOC p_variable
	| p_alt
	;

p_alt :
	p_alt '|' /*15L*/ p_expr_basic
	| p_expr_basic
	;

p_lparen :
	'('
	;

p_lbracket :
	'['
	;

p_expr_basic :
	p_value
	| p_const p_lparen p_args rparen
	| p_const p_lparen p_kwargs rparen
	| p_const '(' rparen
	| p_const p_lbracket p_args rbracket
	| p_const p_lbracket p_kwargs rbracket
	| p_const '[' rbracket
	| tLBRACK p_args rbracket
	| tLBRACK rbracket
	| tLBRACE p_kwargs '}'
	| tLBRACE '}'
	| tLPAREN p_expr rparen
	;

p_args :
	p_expr
	| p_args_head
	| p_args_head p_arg
	| p_args_head tSTAR tIDENTIFIER
	| p_args_head tSTAR tIDENTIFIER ',' p_args_post
	| p_args_head tSTAR
	| p_args_head tSTAR ',' p_args_post
	| p_args_tail
	;

p_args_head :
	p_arg ','
	| p_args_head p_arg ','
	;

p_args_tail :
	tSTAR tIDENTIFIER
	| tSTAR tIDENTIFIER ',' p_args_post
	| tSTAR
	| tSTAR ',' p_args_post
	;

p_args_post :
	p_arg
	| p_args_post ',' p_arg
	;

p_arg :
	p_expr
	;

p_kwargs :
	p_kwarg ',' p_kwrest
	| p_kwarg
	| p_kwrest
	| p_kwarg ',' p_kwnorest
	| p_kwnorest
	;

p_kwarg :
	p_kw
	| p_kwarg ',' p_kw
	;

p_kw :
	p_kw_label p_expr
	| p_kw_label
	;

p_kw_label :
	tLABEL
	| tSTRING_BEG string_contents tLABEL_END
	;

p_kwrest :
	kwrest_mark tIDENTIFIER
	| kwrest_mark
	;

p_kwnorest :
	kwrest_mark keyword_nil
	;

p_value :
	p_primitive
	| p_primitive tDOT2 /*10N*/ p_primitive
	| p_primitive tDOT3 /*10N*/ p_primitive
	| p_primitive tDOT2 /*10N*/
	| p_primitive tDOT3 /*10N*/
	| p_variable
	| p_var_ref
	| p_const
	| tBDOT2 /*10N*/ p_primitive
	| tBDOT3 /*10N*/ p_primitive
	;

p_primitive :
	literal
	| strings
	| xstring
	| regexp
	| words
	| qwords
	| symbols
	| qsymbols
	| keyword_variable
	| tLAMBDA lambda
	;

p_variable :
	tIDENTIFIER
	;

p_var_ref :
	'^' /*15L*/ tIDENTIFIER
	;

p_const :
	tCOLON3 cname
	| p_const tCOLON2 cname
	| tCONSTANT
	;

opt_rescue :
	k_rescue exc_list exc_var then compstmt opt_rescue
	| none
	;

exc_list :
	arg_value
	| mrhs
	| none
	;

exc_var :
	tASSOC lhs
	| none
	;

opt_ensure :
	k_ensure compstmt
	| none
	;

literal :
	numeric
	| symbol
	;

strings :
	string
	;

string :
	tCHAR
	| string1
	| string string1
	;

string1 :
	tSTRING_BEG string_contents tSTRING_END
	;

xstring :
	tXSTRING_BEG xstring_contents tSTRING_END
	;

regexp :
	tREGEXP_BEG regexp_contents tREGEXP_END
	;

words :
	tWORDS_BEG ' ' word_list tSTRING_END
	;

word_list :
	none
	| word_list word ' '
	;

word :
	string_content
	| word string_content
	;

symbols :
	tSYMBOLS_BEG ' ' symbol_list tSTRING_END
	;

symbol_list :
	none
	| symbol_list word ' '
	;

qwords :
	tQWORDS_BEG ' ' qword_list tSTRING_END
	;

qsymbols :
	tQSYMBOLS_BEG ' ' qsym_list tSTRING_END
	;

qword_list :
	none
	| qword_list tSTRING_CONTENT ' '
	;

qsym_list :
	none
	| qsym_list tSTRING_CONTENT ' '
	;

string_contents :
	none
	| string_contents string_content
	;

xstring_contents :
	none
	| xstring_contents string_content
	;

regexp_contents :
	none
	| regexp_contents string_content
	;

string_content :
	tSTRING_CONTENT
	| tSTRING_DVAR string_dvar
	| tSTRING_DBEG compstmt tSTRING_DEND
	;

string_dvar :
	tGVAR
	| tIVAR
	| tCVAR
	| backref
	;

symbol :
	ssym
	| dsym
	;

ssym :
	tSYMBEG sym
	;

sym :
	fname
	| tIVAR
	| tGVAR
	| tCVAR
	;

dsym :
	tSYMBEG string_contents tSTRING_END
	;

numeric :
	simple_numeric
	| tUMINUS_NUM /*20R*/ simple_numeric %prec tLOWEST /*1N*/
	;

simple_numeric :
	tINTEGER
	| tFLOAT
	| tRATIONAL
	| tIMAGINARY
	;

user_variable :
	tIDENTIFIER
	| tIVAR
	| tGVAR
	| tCONSTANT
	| tCVAR
	;

keyword_variable :
	keyword_nil
	| keyword_self
	| keyword_true
	| keyword_false
	| keyword__FILE__
	| keyword__LINE__
	| keyword__ENCODING__
	;

var_ref :
	user_variable
	| keyword_variable
	;

var_lhs :
	user_variable
	| keyword_variable
	;

backref :
	tNTH_REF
	| tBACK_REF
	;

superclass :
	'<' /*14L*/ expr_value term
	| none
	;

f_arglist :
	'(' f_args rparen
	| '(' args_forward rparen
	| f_args term
	;

args_tail :
	f_kwarg ',' f_kwrest opt_f_block_arg
	| f_kwarg opt_f_block_arg
	| f_kwrest opt_f_block_arg
	| f_no_kwarg opt_f_block_arg
	| f_block_arg
	;

opt_args_tail :
	',' args_tail
	| none
	;

f_args :
	f_arg ',' f_optarg ',' f_rest_arg opt_args_tail
	| f_arg ',' f_optarg ',' f_rest_arg ',' f_arg opt_args_tail
	| f_arg ',' f_optarg opt_args_tail
	| f_arg ',' f_optarg ',' f_arg opt_args_tail
	| f_arg ',' f_rest_arg opt_args_tail
	| f_arg ',' f_rest_arg ',' f_arg opt_args_tail
	| f_arg opt_args_tail
	| f_optarg ',' f_rest_arg opt_args_tail
	| f_optarg ',' f_rest_arg ',' f_arg opt_args_tail
	| f_optarg opt_args_tail
	| f_optarg ',' f_arg opt_args_tail
	| f_rest_arg opt_args_tail
	| f_rest_arg ',' f_arg opt_args_tail
	| args_tail
	| /*empty*/
	;

args_forward :
	tBDOT3 /*10N*/
	;

f_bad_arg :
	tCONSTANT
	| tIVAR
	| tGVAR
	| tCVAR
	;

f_norm_arg :
	f_bad_arg
	| tIDENTIFIER
	;

f_arg_asgn :
	f_norm_arg
	;

f_arg_item :
	f_arg_asgn
	| tLPAREN f_margs rparen
	;

f_arg :
	f_arg_item
	| f_arg ',' f_arg_item
	;

f_label :
	tLABEL
	;

f_kw :
	f_label arg_value
	| f_label
	;

f_block_kw :
	f_label primary_value
	| f_label
	;

f_block_kwarg :
	f_block_kw
	| f_block_kwarg ',' f_block_kw
	;

f_kwarg :
	f_kw
	| f_kwarg ',' f_kw
	;

kwrest_mark :
	tPOW /*21R*/
	| tDSTAR
	;

f_no_kwarg :
	kwrest_mark keyword_nil
	;

f_kwrest :
	kwrest_mark tIDENTIFIER
	| kwrest_mark
	;

f_opt :
	f_arg_asgn '=' /*7R*/ arg_value
	;

f_block_opt :
	f_arg_asgn '=' /*7R*/ primary_value
	;

f_block_optarg :
	f_block_opt
	| f_block_optarg ',' f_block_opt
	;

f_optarg :
	f_opt
	| f_optarg ',' f_opt
	;

restarg_mark :
	'*' /*19L*/
	| tSTAR
	;

f_rest_arg :
	restarg_mark tIDENTIFIER
	| restarg_mark
	;

blkarg_mark :
	'&' /*16L*/
	| tAMPER
	;

f_block_arg :
	blkarg_mark tIDENTIFIER
	;

opt_f_block_arg :
	',' f_block_arg
	| none
	;

singleton :
	var_ref
	| '(' expr rparen
	;

assoc_list :
	none
	| assocs trailer
	;

assocs :
	assoc
	| assocs ',' assoc
	;

assoc :
	arg_value tASSOC arg_value
	| tLABEL arg_value
	| tSTRING_BEG string_contents tLABEL_END arg_value
	| tDSTAR arg_value
	;

operation :
	tIDENTIFIER
	| tCONSTANT
	| tFID
	;

operation2 :
	tIDENTIFIER
	| tCONSTANT
	| tFID
	| op
	;

operation3 :
	tIDENTIFIER
	| tFID
	| op
	;

dot_or_colon :
	'.'
	| tCOLON2
	;

call_op :
	'.'
	| tANDDOT
	;

call_op2 :
	call_op
	| tCOLON2
	;

opt_terms :
	/*empty*/
	| terms
	;

opt_nl :
	none
	| '\n'
	;

rparen :
	opt_nl ')'
	;

rbracket :
	opt_nl ']'
	;

trailer :
	none
	| '\n'
	| ','
	;

term :
	';'
	| '\n'
	;

terms :
	term
	| terms ';'
	;

none :
	/*empty*/
	;

%%

%%

/* Regex rules */
// Line Comment

[\t\r]+|#.*|\/\*.{+}[\r\n]*?\*\/ skip()

\.	'.'
=	'=' //Equal/assign
\?	'?'
:	':'
>	'>'
<	'<'
\|	'|'
\^	'^'
&	'&'
\+	'+'
-	'-'
\*	'*'
\/	'/'
%	'%'
!	'!'
~	'~'
\{	'{'
\}	'}'
\[	'['
,	','
`	'`'
\(	'('
\)	')'
\]	']'
;	';'
[ ]	' '
\n	'\n'

tLBRACE_ARG	tLBRACE_ARG
in	keyword_in
modifier_if	modifier_if
modifier_unless	modifier_unless
modifier_while	modifier_while
modifier_until	modifier_until
and	keyword_and
or	keyword_or
not	keyword_not
defined	keyword_defined
tOP_ASGN	tOP_ASGN
modifier_rescue	modifier_rescue
\.\.	tDOT2
\.\.\.	tDOT3
tBDOT2	tBDOT2
tBDOT3	tBDOT3
tOROP	tOROP
tANDOP	tANDOP
tCMP	tCMP
tEQ	tEQ
tEQQ	tEQQ
tNEQ	tNEQ
tMATCH	tMATCH
tNMATCH	tNMATCH
tGEQ	tGEQ
tLEQ	tLEQ
<<	tLSHFT
>>	tRSHFT
tUMINUS	tUMINUS
tUMINUS_NUM	tUMINUS_NUM
tPOW	tPOW
tUPLUS	tUPLUS
END_OF_INPUT	END_OF_INPUT
BEGIN	keyword_BEGIN
alias	keyword_alias
tGVAR	tGVAR
tBACK_REF	tBACK_REF
tNTH_REF	tNTH_REF
undef	keyword_undef
END	keyword_END
tCOLON2	tCOLON2
super	keyword_super
yield	keyword_yield
break	keyword_break
next	keyword_next
tLPAREN	tLPAREN
tSTAR	tSTAR
tCOLON3	tCOLON3
tFID	tFID
tDSTAR	tDSTAR
tAREF	tAREF
tASET	tASET
_LINE__	keyword__LINE__
_FILE__	keyword__FILE__
_ENCODING__	keyword__ENCODING__
begin	keyword_begin
case	keyword_case
class	keyword_class
def	keyword_def
do	keyword_do
else	keyword_else
elsif	keyword_elsif
end	keyword_end
ensure	keyword_ensure
false	keyword_false
for	keyword_for
module	keyword_module
nil	keyword_nil
redo	keyword_redo
rescue	keyword_rescue
retry	keyword_retry
return	keyword_return
self	keyword_self
then	keyword_then
true	keyword_true
when	keyword_when
if	keyword_if
unless	keyword_unless
while	keyword_while
until	keyword_until
tAMPER	tAMPER
tLPAREN_ARG	tLPAREN_ARG
tLBRACK	tLBRACK
tLBRACE	tLBRACE
tLAMBDA	tLAMBDA
do_block	keyword_do_block
do_cond	keyword_do_cond
tLAMBEG	tLAMBEG
do_LAMBDA	keyword_do_LAMBDA
tASSOC	tASSOC
tLABEL	tLABEL
tSTRING_BEG	tSTRING_BEG
tLABEL_END	tLABEL_END
tCHAR	tCHAR
tSTRING_END	tSTRING_END
tXSTRING_BEG	tXSTRING_BEG
tREGEXP_BEG	tREGEXP_BEG
tREGEXP_END	tREGEXP_END
tWORDS_BEG	tWORDS_BEG
tSYMBOLS_BEG	tSYMBOLS_BEG
tQWORDS_BEG	tQWORDS_BEG
tQSYMBOLS_BEG	tQSYMBOLS_BEG
tSTRING_CONTENT	tSTRING_CONTENT
tSTRING_DVAR	tSTRING_DVAR
tSTRING_DBEG	tSTRING_DBEG
tSTRING_DEND	tSTRING_DEND
tIVAR	tIVAR
tCVAR	tCVAR
tSYMBEG	tSYMBEG
tRATIONAL	tRATIONAL
tIMAGINARY	tIMAGINARY
tANDDOT	tANDDOT

tCONSTANT	tCONSTANT
0|[1-9][0-9]*	tINTEGER
(0|[1-9]\d*)[.]\d+([eE][-+]?\d+)?	tFLOAT
/* Order matter if identifier comes before keywords they are classified as identifier */
[_a-zA-Z][_0-9a-zA-Z]*	tIDENTIFIER

%%
