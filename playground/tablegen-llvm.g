%token TokInteger TokString TokCode TokIdentifier TokVarName MacroName

%%

TableGenFile :
	(Statement | IncludeDirective | PreprocessorDirective)*
	;

Statement :
	Assert
	| Class
	| Def
	| Defm
	| Defset
	| Defvar
	| Dump
	| Foreach
	| If
	| Let
	| MultiClass
	;

Class :
	"class" ClassID [TemplateArgList] RecordBody
	;

TemplateArgList :
	"<" TemplateArgDecl ("," TemplateArgDecl)* ">"
	;

TemplateArgDecl :
	Type TokIdentifier ["=" Value]
	;

RecordBody :
	ParentClassList Body
	;

ParentClassList :
	[":" ParentClassListNE]
	;

ParentClassListNE :
	ClassRef ("," ClassRef)*
	;

ClassRef :
	(ClassID | MultiClassID) ["<" [ArgValueList] ">"]
	;

ArgValueList :
	PositionalArgValueList [","] NamedArgValueList
	;

PositionalArgValueList :
	[Value {"," Value}*]
	;

NamedArgValueList :
	[NameValue "=" Value {"," NameValue "=" Value}*]
	;

Body :
	";" | "{" BodyItem* "}"
	;

BodyItem :
	(Type | "code") TokIdentifier ["=" Value] ";"
	| "let" TokIdentifier ["{" RangeList "}"] "=" Value ";"
	| "defvar" TokIdentifier "=" Value ";"
	| Assert
	;

Def :
	"def" [NameValue] RecordBody
	;

NameValue :
	Value //(parsed in a special mode)
	;


Let :
	"let" LetList "in" "{" Statement* "}"
	| "let" LetList "in" Statement
	;

LetList :
	LetItem ("," LetItem)*
	;

LetItem :
	TokIdentifier ["<" RangeList ">"] "=" Value
	;

MultiClass :
	"multiclass" TokIdentifier [TemplateArgList]
		ParentClassList
			"{" MultiClassStatement+ "}"
	;

MultiClassID :
	TokIdentifier
	;

MultiClassStatement :
	Assert
	| Def
	| Defm
	| Defvar
	| Foreach
	| If
	| Let
	;

Defm :
	"defm" [NameValue] ParentClassList ";"
	;

Defset :
	"defset" Type TokIdentifier "=" "{" Statement* "}"
	;

Defvar :
	"defvar" TokIdentifier "=" Value ";"
	;

Foreach :
	"foreach" ForeachIterator "in" "{" Statement* "}"
	| "foreach" ForeachIterator "in" Statement
	;

ForeachIterator :
	TokIdentifier "=" ("{" RangeList "}" | RangePiece | Value)
	;

Dump :
	"dump"  TokString ";"
	;

If :
	"if" Value "then" IfBody
	| "if" Value "then" IfBody "else" IfBody
	;

IfBody :
	"{" Statement* "}" | Statement
	;

Assert :
	"assert" condition "," message ";"
	;

condition :
	Value
	;

message :
	Value
	;

Type :
	"bit"
	| "int"
	| "string"
	| "dag"
	| "bits" "<" TokInteger ">"
	| "list" "<" Type ">"
	| ClassID
	;

ClassID :
	TokIdentifier
	;

Value :
	SimpleValue ValueSuffix*
	| Value "#" [Value]
	;

ValueSuffix :
	"{" RangeList "}"
	| "[" SliceElements "]"
	| "." TokIdentifier
	;

RangeList :
	RangePiece ("," RangePiece)*
	;

RangePiece :
	TokInteger
	| TokInteger "..." TokInteger
	| TokInteger "-" TokInteger
	| TokInteger TokInteger
	;

SliceElements :
	(SliceElement ",")* SliceElement ","?
	;

SliceElement :
	Value
	| Value "..." Value
	| Value "-" Value
	| Value TokInteger
	;

SimpleValue :
	TokInteger
	| TokString+
	| TokCode
	| SimpleValue2
	| SimpleValue3
	| SimpleValue4
	| SimpleValue5
	| SimpleValue6
	| SimpleValue7
	| SimpleValue8
	| SimpleValue9
	;

SimpleValue2 :
	"true"
	| "false"
	;

SimpleValue3 :
	"?"
	;

SimpleValue4 :
	"{" [ValueList] "}"
	;

ValueList :
	ValueListNE
	;

ValueListNE :
	Value ("," Value)*
	;

SimpleValue5 :
	"[" ValueList "]" ["<" Type ">"]
	;

SimpleValue6 :
	"(" DagArg [DagArgList] ")"
	;

DagArgList :
	DagArg ("," DagArg)*
	;

DagArg :
	Value [":" TokVarName] | TokVarName
	;

SimpleValue7 :
	TokIdentifier
	;

SimpleValue8 :
	ClassID "<" ArgValueList ">"
	;

SimpleValue9 :
	BangOperator ["<" Type ">"] "(" ValueListNE ")"
	| CondOperator "(" CondClause ("," CondClause)* ")"
	;

CondClause :
	Value ":" Value
	;

CondOperator :
	"!cond"
	;

BangOperator :
	"!add"
	| "!and"
	| "!cast"
	| "!con"
	| "!dag"
	| "!div"
	| "!empty"
	| "!eq"
	| "!exists"
	| "!filter"
	| "!find"
	| "!foldl"
	| "!foreach"
	| "!ge"
	| "!getdagarg"
	| "!getdagname"
	| "!getdagop"
	| "!gt"
	| "!head"
	| "!if"
	| "!interleave"
	| "!isa"
	| "!le"
	| "!listconcat"
	| "!listremove"
	| "!listsplat"
	| "!logtwo"
	| "!lt"
	| "!mul"
	| "!ne"
	| "!not"
	| "!or"
	| "!range"
	| "!repr"
	| "!setdagarg"
	| "!setdagname"
	| "!setdagop"
	| "!shl"
	| "!size"
	| "!sra"
	| "!srl"
	| "!strconcat"
	| "!sub"
	| "!subst"
	| "!substr"
	| "!tail"
	| "!tolower"
	| "!toupper"
	| "!xor"
	;

IncludeDirective :
	"include" TokString
	;

PreprocessorDirective :
	"#define"
	| "#ifdef"
	| "#ifndef"
	;

%%

DecimalInteger  [+-]?[0-9]+
HexInteger     "0x"[0-9a-fA-F]+
BinInteger     "0b"[01]+
TokInteger     {DecimalInteger}|{HexInteger}|{BinInteger}

ualpha        [a-zA-Z_]
TokIdentifier  [0-9]*{ualpha}({ualpha}|[0-9])*
TokVarName    "$"{ualpha}({ualpha}|[0-9])*
MacroName      {ualpha}({ualpha}|[0-9])*


%%

[\n\r\t ]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

/*Keywords*/
"assert"	"assert"
"bit"	"bit"
"bits"	"bits"
"class"	"class"
"code"	"code"
"dag"	"dag"
"def"	"def"
"defm"	"defm"
"defset"	"defset"
"defvar"	"defvar"
"dump"	"dump"
"else"	"else"
"false"	"false"
//"field"   "field" //deprecated
"foreach"	"foreach"
"if"	"if"
"include"	"include"
"in"	"in"
"int"	"int"
"let"	"let"
"list"	"list"
"multiclass"	"multiclass"
"string"	"string"
"then"	"then"
"true"	"true"

"<"	"<"
"="	"="
">"	">"
"-"	"-"
","	","
";"	";"
":"	":"
"?"	"?"
"..."	"..."
"."	"."
"("	"("
")"	")"
"["	"["
"]"	"]"
"{"	"{"
"}"	"}"
"#"	"#"
"!add"	"!add"
"!and"	"!and"
"!cast"	"!cast"
"!con"	"!con"
"!cond"	"!cond"
"!dag"	"!dag"
"#define"	"#define"
"!div"	"!div"
"!empty"	"!empty"
"!eq"	"!eq"
"!exists"	"!exists"
"!filter"	"!filter"
"!find"	"!find"
"!foldl"	"!foldl"
"!foreach"	"!foreach"
"!ge"	"!ge"
"!getdagarg"	"!getdagarg"
"!getdagname"	"!getdagname"
"!getdagop"	"!getdagop"
"!gt"	"!gt"
"!head"	"!head"
"!if"	"!if"
"#ifdef"	"#ifdef"
"#ifndef"	"#ifndef"
"!interleave"	"!interleave"
"!isa"	"!isa"
"!le"	"!le"
"!listconcat"	"!listconcat"
"!listremove"	"!listremove"
"!listsplat"	"!listsplat"
"!logtwo"	"!logtwo"
"!lt"	"!lt"
"!mul"	"!mul"
"!ne"	"!ne"
"!not"	"!not"
"!or"	"!or"
"!range"	"!range"
"!repr"	"!repr"
"!setdagarg"	"!setdagarg"
"!setdagname"	"!setdagname"
"!setdagop"	"!setdagop"
"!shl"	"!shl"
"!size"	"!size"
"!sra"	"!sra"
"!srl"	"!srl"
"!strconcat"	"!strconcat"
"!sub"	"!sub"
"!subst"	"!subst"
"!substr"	"!substr"
"!tail"	"!tail"
"!tolower"	"!tolower"
"!toupper"	"!toupper"
"!xor"	"!xor"

{TokInteger}	TokInteger
\"(\\.|[^"\n\r\\])*\"	TokString
"[{"(?s:.)*?"}]"	TokCode

{TokIdentifier}	TokIdentifier
{TokVarName}	TokVarName
//{MacroName}	MacroName

/*
LineBegin              ::=  beginning of line
LineEnd                ::=  newline | return | EOF
WhiteSpace             ::=  space | tab
CComment               ::=  "/ *" ... "* /"
BCPLComment            ::=  "//" ... LineEnd
WhiteSpaceOrCComment   ::=  WhiteSpace | CComment
WhiteSpaceOrAnyComment ::=  WhiteSpace | CComment | BCPLComment
MacroName              ::=  ualpha (ualpha | "0"..."9")*
PreDefine              ::=  LineBegin (WhiteSpaceOrCComment)*
                            "#define" (WhiteSpace)+ MacroName
                            (WhiteSpaceOrAnyComment)* LineEnd
PreIfdef               ::=  LineBegin (WhiteSpaceOrCComment)*
                            ("#ifdef" | "#ifndef") (WhiteSpace)+ MacroName
                            (WhiteSpaceOrAnyComment)* LineEnd
PreElse                ::=  LineBegin (WhiteSpaceOrCComment)*
                            "#else" (WhiteSpaceOrAnyComment)* LineEnd
PreEndif               ::=  LineBegin (WhiteSpaceOrCComment)*
                            "#endif" (WhiteSpaceOrAnyComment)* LineEnd
*/

%%
