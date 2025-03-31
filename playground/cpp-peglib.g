//From: https://github.com/yhirose/cpp-peglib/blob/527422aa38ce78c4214b21843e97584bc2db0150/peglib.h#L3365

%token AND
%token BackRef
%token BeginCap
%token BeginCapScope
%token BeginTok
%token CLOSE
%token CUT
%token Class
%token ClassI
%token DOT
%token Identifier
%token Ignore
%token RuleIgnore
%token LABEL
%token LEFTARROW
%token Literal
%token LiteralI
%token NOT
%token NegatedClass
%token NegatedClassI
%token OPEN
%token PIPE
%token PLUS
%token QUESTION
%token SLASH
%token STAR
%token BeginBracket
%token COMMA
%token EndBracket
%token InstructionItemSeparator
%token NoAstOpt
%token Number
%token PrecedenceAssoc
%token IdentDef

%%

Grammar:
	  Definition
	| Grammar Definition
	;

Definition:
	  RuleIgnore_opt IdentDef Parameters LEFTARROW Expression Instruction_opt
	| RuleIgnore_opt IdentDef LEFTARROW Expression Instruction_opt
	;

RuleIgnore_opt :
    %empty
    | RuleIgnore
    ;

Instruction_opt:
	  %empty
	| Instruction
	;

Ignore_opt:
	  %empty
	| Ignore
	;

Expression:
	  Sequence
	| Expression SLASH Sequence
	;

Sequence:
	  %empty
	| Sequence cut_or_prefix
	;

cut_or_prefix:
	  CUT
	| Prefix
	;

Prefix:
	  SuffixWithLabel
	|  and_or_not SuffixWithLabel
	;

and_or_not:
	  AND
	| NOT
	;

SuffixWithLabel:
	  Suffix
	| Suffix LABEL Identifier
	;

Suffix:
	  Primary
	| Primary Loop
	;

Loop:
	  QUESTION
	| STAR
	| PLUS
	| Repetition
	;

Primary:
	  Ignore_opt Identifier Arguments
	| Ignore_opt Identifier
	| OPEN Expression CLOSE
	| BeginTok Expression '>'
	| CapScope
	| BeginCap Expression '>'
	| BackRef
	| DictionaryI
	| LiteralI
	| Dictionary
	| Literal
	| NegatedClassI
	| NegatedClass
	| ClassI
	| Class
	| DOT
	;

Dictionary:
	  Literal PIPE_Literal_oom
	;

PIPE_Literal_oom:
	  PIPE Literal
	| PIPE_Literal_oom PIPE Literal
	;

DictionaryI:
	  LiteralI PIPE_LiteralI_oom
	;

PIPE_LiteralI_oom:
	  PIPE LiteralI
	| PIPE_LiteralI_oom PIPE LiteralI
	;

Repetition:
	  BeginBracket RepetitionRange EndBracket
	;

RepetitionRange:
	  Number COMMA Number
	| Number COMMA
	| Number
	| COMMA Number
	;

Parameters:
	  OPEN Identifier COMMA_Identifier_zom CLOSE
	;

COMMA_Identifier_zom:
	  %empty
	| COMMA_Identifier_zom COMMA Identifier
	;

Arguments:
	  OPEN Expression COMMA_Expression_zom CLOSE
	;

COMMA_Expression_zom:
	  %empty
	| COMMA_Expression_zom COMMA Expression
	;

Instruction:
	  BeginBracket InstructionItem_sep_oom_opt EndBracket
	;

InstructionItem_sep_oom_opt:
	  %empty
	| InstructionItem_sep_oom
	;

InstructionItem_sep_oom:
	  InstructionItem
	| InstructionItem_sep_oom InstructionItemSeparator InstructionItem
	;

InstructionItem:
	  PrecedenceClimbing
	| ErrorMessage
	| NoAstOpt
	;

PrecedenceClimbing:
	  "precedence" PrecedenceInfo_oom
	;

PrecedenceInfo_oom:
	  PrecedenceInfo
	| PrecedenceInfo_oom PrecedenceInfo
	;

PrecedenceInfo:
	  PrecedenceAssoc PrecedenceOpe_oom
	;

PrecedenceOpe_oom:
	  PrecedenceOpe
	| PrecedenceOpe_oom PrecedenceOpe
	;

PrecedenceOpe:
	  Literal
	;

CapScope:
	  BeginCapScope Expression CLOSE
	;

ErrorMessage:
	  "error_message" Literal
	;

%%

%x IDENT_DEF

IGNORE  "~"
IDCONT  [A-Za-z0-9_]
ID  [A-Za-z_%]{IDCONT}*
STR '(\\.|[^'\r\n\\])*'|\"(\\.|[^"\r\n\\])*\"
CLASS_TAIL   (\\.|[^\]\r\n\\])+"]"
CLASS   "["{CLASS_TAIL}
CLASSNEG   "[^"{CLASS_TAIL}

LEFTARROW "<-"|"←"

%%

[ \t\r\n]+  skip()
"#".*   skip()

"&"	AND
"<"	BeginTok
")"	CLOSE
"↑"	CUT
"."	DOT
">"	'>'
{IGNORE}	Ignore
";"	InstructionItemSeparator
"^"|"⇑"	LABEL
{LEFTARROW}	LEFTARROW
"!"	NOT
"("	OPEN
"|" PIPE
"+"	PLUS
"?"	QUESTION
"/"	SLASH
"*"	STAR

"{"	BeginBracket
","	COMMA
"}"	EndBracket
"no_ast_opt"	NoAstOpt
"error_message"	"error_message"
"precedence"	"precedence"
[0-9]+	Number
[LR]	PrecedenceAssoc
"$("	BeginCapScope

{CLASSNEG}	NegatedClass
{CLASSNEG}i	NegatedClassI
{CLASS}	Class
{CLASS}i	ClassI

{STR}	Literal
{STR}i	LiteralI

{ID}\s+{LEFTARROW}<IDENT_DEF>   reject()
<IDENT_DEF>{
    {ID}<INITIAL>	IdentDef
}
{IGNORE}\s*{ID}\s+{LEFTARROW}<IDENT_DEF>   reject()
<IDENT_DEF>{
    {IGNORE}    RuleIgnore
    {ID}<INITIAL>	IdentDef
    \s+ skip()
}

"$"{ID}"<"	BeginCap
"$"{ID}	BackRef
{ID}	Identifier

%%
