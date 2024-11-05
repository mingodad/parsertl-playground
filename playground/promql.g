/*Tokens*/
%token EQL
%token BLANK
%token COLON
%token COMMA
//%token COMMENT
%token DURATION
//%token EOF
//%token ERROR
%token IDENTIFIER
%token LEFT_BRACE
%token LEFT_BRACKET
%token LEFT_PAREN
%token OPEN_HIST
%token CLOSE_HIST
%token METRIC_IDENTIFIER
%token NUMBER
%token RIGHT_BRACE
%token RIGHT_BRACKET
%token RIGHT_PAREN
%token SEMICOLON
%token SPACE
%token STRING
%token TIMES
//%token histogramDescStart
%token SUM_DESC
%token COUNT_DESC
%token SCHEMA_DESC
%token OFFSET_DESC
%token NEGATIVE_OFFSET_DESC
%token BUCKETS_DESC
%token NEGATIVE_BUCKETS_DESC
%token ZERO_BUCKET_DESC
%token ZERO_BUCKET_WIDTH_DESC
%token CUSTOM_VALUES_DESC
%token COUNTER_RESET_HINT_DESC
//%token histogramDescEnd
//%token operatorsStart
%token ADD
%token DIV
%token EQLC
%token EQL_REGEX
%token GTE
%token GTR
%token LAND
%token LOR
%token LSS
%token LTE
%token LUNLESS
%token MOD
%token MUL
%token NEQ
%token NEQ_REGEX
%token POW
%token SUB
%token AT
%token ATAN2
//%token operatorsEnd
//%token aggregatorsStart
%token AVG
%token BOTTOMK
%token COUNT
%token COUNT_VALUES
%token GROUP
%token MAX
%token MIN
%token QUANTILE
%token STDDEV
%token STDVAR
%token SUM
%token TOPK
%token LIMITK
%token LIMIT_RATIO
//%token aggregatorsEnd
//%token keywordsStart
%token BOOL
%token BY
%token GROUP_LEFT
%token GROUP_RIGHT
%token IGNORING
%token OFFSET
%token ON
%token WITHOUT
//%token keywordsEnd
//%token preprocessorStart
%token START
%token END
//%token preprocessorEnd
//%token counterResetHintsStart
%token UNKNOWN_COUNTER_RESET
%token COUNTER_RESET
%token NOT_COUNTER_RESET
%token GAUGE_TYPE
//%token counterResetHintsEnd
//%token startSymbolsStart
%token START_METRIC
%token START_SERIES_DESCRIPTION
%token START_EXPRESSION
%token START_METRIC_SELECTOR
//%token startSymbolsEnd

%left /*1*/ LOR
%left /*2*/ LAND LUNLESS
%left /*3*/ EQLC GTE GTR LSS LTE NEQ
%left /*4*/ ADD SUB
%left /*5*/ DIV MOD MUL ATAN2
%right /*6*/ POW
%nonassoc /*7*/ OFFSET
%right /*8*/ LEFT_BRACKET

%start start

%%

//start :
//	START_METRIC metric
//	| START_SERIES_DESCRIPTION series_description
//	| START_EXPRESSION //EOF
//	| START_EXPRESSION expr
//	| START_METRIC_SELECTOR vector_selector
//	| start //EOF
//	//| error
//	;

start :
    cmds
    ;

cmds :
    SEMICOLON
    | cmd
    | cmds SEMICOLON cmd
    ;

cmd :
	| metric
	| series_description
	| expr
	| vector_selector
    ;

expr :
	aggregate_expr
	| binary_expr
	| function_call
	| matrix_selector
	| number_duration_literal
	| offset_expr
	| paren_expr
	| string_literal
	| subquery_expr
	| unary_expr
	| vector_selector
	| step_invariant_expr
	;

aggregate_expr :
	aggregate_op aggregate_modifier function_call_body
	| aggregate_op function_call_body aggregate_modifier
	| aggregate_op function_call_body
	//| aggregate_op error
	;

aggregate_modifier :
	BY grouping_labels
	| WITHOUT grouping_labels
	;

binary_expr :
	expr ADD /*4L*/ bin_modifier expr
	| expr ATAN2 /*5L*/ bin_modifier expr
	| expr DIV /*5L*/ bin_modifier expr
	| expr EQLC /*3L*/ bin_modifier expr
	| expr GTE /*3L*/ bin_modifier expr
	| expr GTR /*3L*/ bin_modifier expr
	| expr LAND /*2L*/ bin_modifier expr
	| expr LOR /*1L*/ bin_modifier expr
	| expr LSS /*3L*/ bin_modifier expr
	| expr LTE /*3L*/ bin_modifier expr
	| expr LUNLESS /*2L*/ bin_modifier expr
	| expr MOD /*5L*/ bin_modifier expr
	| expr MUL /*5L*/ bin_modifier expr
	| expr NEQ /*3L*/ bin_modifier expr
	| expr POW /*6R*/ bin_modifier expr
	| expr SUB /*4L*/ bin_modifier expr
	;

bin_modifier :
	group_modifiers
	;

bool_modifier :
	/*empty*/
	| BOOL
	;

on_or_ignoring :
	bool_modifier IGNORING grouping_labels
	| bool_modifier ON grouping_labels
	;

group_modifiers :
	bool_modifier
	| on_or_ignoring
	| on_or_ignoring GROUP_LEFT maybe_grouping_labels
	| on_or_ignoring GROUP_RIGHT maybe_grouping_labels
	;

grouping_labels :
	LEFT_PAREN grouping_label_list RIGHT_PAREN
	| LEFT_PAREN grouping_label_list COMMA RIGHT_PAREN
	| LEFT_PAREN RIGHT_PAREN
	//| error
	;

grouping_label_list :
	grouping_label_list COMMA grouping_label
	| grouping_label
	//| grouping_label_list error
	;

grouping_label :
	maybe_label
	| STRING
	//| error
	;

function_call :
	IDENTIFIER function_call_body
	;

function_call_body :
	LEFT_PAREN function_call_args RIGHT_PAREN
	| LEFT_PAREN RIGHT_PAREN
	;

function_call_args :
	function_call_args COMMA expr
	| expr
	| function_call_args COMMA
	;

paren_expr :
	LEFT_PAREN expr RIGHT_PAREN
	;

offset_expr :
	expr OFFSET /*7N*/ number_duration_literal
	| expr OFFSET /*7N*/ SUB /*4L*/ number_duration_literal
	//| expr OFFSET /*7N*/ error
	;

step_invariant_expr :
	expr AT signed_or_unsigned_number
	| expr AT at_modifier_preprocessors LEFT_PAREN RIGHT_PAREN
	//| expr AT error
	;

at_modifier_preprocessors :
	START
	| END
	;

matrix_selector :
	expr LEFT_BRACKET /*8R*/ number_duration_literal RIGHT_BRACKET
	;

subquery_expr :
	expr LEFT_BRACKET /*8R*/ number_duration_literal COLON number_duration_literal RIGHT_BRACKET
	| expr LEFT_BRACKET /*8R*/ number_duration_literal COLON RIGHT_BRACKET
	//| expr LEFT_BRACKET /*8R*/ number_duration_literal COLON number_duration_literal error
	//| expr LEFT_BRACKET /*8R*/ number_duration_literal COLON error
	//| expr LEFT_BRACKET /*8R*/ number_duration_literal error
	//| expr LEFT_BRACKET /*8R*/ error
	;

unary_expr :
	unary_op expr %prec MUL /*5L*/
	;

vector_selector :
	metric_identifier label_matchers
	| metric_identifier
	| label_matchers
	;

label_matchers :
	LEFT_BRACE label_match_list RIGHT_BRACE
	| LEFT_BRACE label_match_list COMMA RIGHT_BRACE
	| LEFT_BRACE RIGHT_BRACE
	;

label_match_list :
	label_match_list COMMA label_matcher
	| label_matcher
	//| label_match_list error
	;

label_matcher :
	IDENTIFIER match_op STRING
	| string_identifier match_op STRING
	| string_identifier
	//| string_identifier match_op error
	//| IDENTIFIER match_op error
	//| IDENTIFIER error
	//| error
	;

metric :
	metric_identifier label_set
	| label_set
	;

metric_identifier :
	AVG
	| BOTTOMK
	| BY
	| COUNT
	| COUNT_VALUES
	| GROUP
	| IDENTIFIER
	| LAND /*2L*/
	| LOR /*1L*/
	| LUNLESS /*2L*/
	| MAX
	| METRIC_IDENTIFIER
	| MIN
	| OFFSET /*7N*/
	| QUANTILE
	| STDDEV
	| STDVAR
	| SUM
	| TOPK
	| WITHOUT
	| START
	| END
	| LIMITK
	| LIMIT_RATIO
	;

label_set :
	LEFT_BRACE label_set_list RIGHT_BRACE
	| LEFT_BRACE label_set_list COMMA RIGHT_BRACE
	| LEFT_BRACE RIGHT_BRACE
	| /*empty*/
	;

label_set_list :
	label_set_list COMMA label_set_item
	| label_set_item
	//| label_set_list error
	;

label_set_item :
	IDENTIFIER EQL STRING
	//| IDENTIFIER EQL error
	//| IDENTIFIER error
	//| error
	;

series_description :
	metric series_values
	;

series_values :
	/*empty*/
	| series_values SPACE series_item
	| series_values SPACE
	//| error
	;

series_item :
	BLANK
	| BLANK TIMES uint
	| series_value
	| series_value TIMES uint
	| series_value signed_number TIMES uint
	| histogram_series_value
	| histogram_series_value TIMES uint
	| histogram_series_value ADD /*4L*/ histogram_series_value TIMES uint
	| histogram_series_value SUB /*4L*/ histogram_series_value TIMES uint
	;

series_value :
	IDENTIFIER
	| number
	| signed_number
	;

histogram_series_value :
	OPEN_HIST histogram_desc_map SPACE CLOSE_HIST
	| OPEN_HIST histogram_desc_map CLOSE_HIST
	| OPEN_HIST SPACE CLOSE_HIST
	| OPEN_HIST CLOSE_HIST
	;

histogram_desc_map :
	histogram_desc_map SPACE histogram_desc_item
	| histogram_desc_item
	//| histogram_desc_map error
	;

histogram_desc_item :
	SCHEMA_DESC COLON int
	| SUM_DESC COLON signed_or_unsigned_number
	| COUNT_DESC COLON signed_or_unsigned_number
	| ZERO_BUCKET_DESC COLON signed_or_unsigned_number
	| ZERO_BUCKET_WIDTH_DESC COLON number
	| CUSTOM_VALUES_DESC COLON bucket_set
	| BUCKETS_DESC COLON bucket_set
	| OFFSET_DESC COLON int
	| NEGATIVE_BUCKETS_DESC COLON bucket_set
	| NEGATIVE_OFFSET_DESC COLON int
	| COUNTER_RESET_HINT_DESC COLON counter_reset_hint
	;

bucket_set :
	LEFT_BRACKET /*8R*/ bucket_set_list SPACE RIGHT_BRACKET
	| LEFT_BRACKET /*8R*/ bucket_set_list RIGHT_BRACKET
	;

bucket_set_list :
	bucket_set_list SPACE signed_or_unsigned_number
	| signed_or_unsigned_number
	//| bucket_set_list error
	;

counter_reset_hint :
	UNKNOWN_COUNTER_RESET
	| COUNTER_RESET
	| NOT_COUNTER_RESET
	| GAUGE_TYPE
	;

aggregate_op :
	AVG
	| BOTTOMK
	| COUNT
	| COUNT_VALUES
	| GROUP
	| MAX
	| MIN
	| QUANTILE
	| STDDEV
	| STDVAR
	| SUM
	| TOPK
	| LIMITK
	| LIMIT_RATIO
	;

maybe_label :
	AVG
	| BOOL
	| BOTTOMK
	| BY
	| COUNT
	| COUNT_VALUES
	| GROUP
	| GROUP_LEFT
	| GROUP_RIGHT
	| IDENTIFIER
	| IGNORING
	| LAND /*2L*/
	| LOR /*1L*/
	| LUNLESS /*2L*/
	| MAX
	| METRIC_IDENTIFIER
	| MIN
	| OFFSET /*7N*/
	| ON
	| QUANTILE
	| STDDEV
	| STDVAR
	| SUM
	| TOPK
	| START
	| END
	| ATAN2 /*5L*/
	| LIMITK
	| LIMIT_RATIO
	;

unary_op :
	ADD /*4L*/
	| SUB /*4L*/
	;

match_op :
	EQL
	| NEQ /*3L*/
	| EQL_REGEX
	| NEQ_REGEX
	;

number_duration_literal :
	NUMBER
	| DURATION
	;

number :
	NUMBER
	| DURATION
	;

signed_number :
	ADD /*4L*/ number
	| SUB /*4L*/ number
	;

signed_or_unsigned_number :
	number
	| signed_number
	;

uint :
	NUMBER
	;

int :
	SUB /*4L*/ uint
	| uint
	;

string_literal :
	STRING
	;

string_identifier :
	STRING
	;

maybe_grouping_labels :
	/*empty*/
	| grouping_labels
	;

%%

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

// This is a list of all keywords in PromQL.
// When changing this list, make sure to also change
// the maybe_label grammar rule in the generated parser
// to avoid misinterpretation of labels as keywords.
// Operators.
"and"     LAND
"or"      LOR
"unless"  LUNLESS
"atan2"   ATAN2

// Aggregators.
"sum"           SUM
"avg"           AVG
"count"         COUNT
"min"           MIN
"max"           MAX
"group"         GROUP
"stddev"        STDDEV
"stdvar"        STDVAR
"topk"          TOPK
"bottomk"       BOTTOMK
"count_values"  COUNT_VALUES
"quantile"      QUANTILE
"limitk"        LIMITK
"limit_ratio"   LIMIT_RATIO

// Keywords.
"offset"       OFFSET
"by"           BY
"without"      WITHOUT
"on"           ON
"ignoring"     IGNORING
"group_left"   GROUP_LEFT
"group_right"  GROUP_RIGHT
"bool"         BOOL

// Preprocessors.
"start"  START
"end"    END

//var histogramDesc = map[string]ItemType{
"xsum"                 SUM_DESC
"xcount"               COUNT_DESC
"schema"              SCHEMA_DESC
"xoffset"              OFFSET_DESC
"n_offset"            NEGATIVE_OFFSET_DESC
"buckets"             BUCKETS_DESC
"n_buckets"           NEGATIVE_BUCKETS_DESC
"z_bucket"            ZERO_BUCKET_DESC
"z_bucket_w"          ZERO_BUCKET_WIDTH_DESC
"custom_values"       CUSTOM_VALUES_DESC
"counter_reset_hint"  COUNTER_RESET_HINT_DESC


//var counterResetHints = map[string]ItemType{
"unknown"    UNKNOWN_COUNTER_RESET
"reset"      COUNTER_RESET
"not_reset"  NOT_COUNTER_RESET
"gauge"      GAUGE_TYPE

// ItemTypeStr is the default string representations for common Items. It does not
// imply that those are the only character sequences that can be lexed to such an Item.
//var ItemTypeStr = map[ItemType]string{
"{{"	OPEN_HIST
"}}"	CLOSE_HIST
"("	LEFT_PAREN
")"	RIGHT_PAREN
"{"	LEFT_BRACE
"}"	RIGHT_BRACE
"["	LEFT_BRACKET
"]"	RIGHT_BRACKET
","	COMMA
"="	EQL
":"	COLON
";"	SEMICOLON
"_"	BLANK
"x"	TIMES
"<space>"	SPACE

"-"	SUB
"+"	ADD
"*"	MUL
"%"	MOD
"/"	DIV
"=="	EQLC
"!="	NEQ
"<="	LTE
"<"	LSS
">="	GTE
">"	GTR
"=~"	EQL_REGEX
"!~"	NEQ_REGEX
"^"	POW

// Add keywords to Item type strings.
// Special numbers.
"inf" NUMBER
"nan" NUMBER
"0"[xX][0-9A-Fa-f]+	NUMBER
[0-9]+	NUMBER
[0-9]+"."[0-9]+	NUMBER


"@"	AT

DURATION	DURATION

\"(\\.|[^"\r\n\\])*\"	STRING
'(\\.|[^'\r\n\\])*'	STRING
START_METRIC	START_METRIC
START_SERIES_DESCRIPTION	START_SERIES_DESCRIPTION
METRIC_IDENTIFIER	METRIC_IDENTIFIER
START_EXPRESSION	START_EXPRESSION
START_METRIC_SELECTOR	START_METRIC_SELECTOR

[A-Za-z_][A-Za-z0-9_]*	IDENTIFIER

%%
