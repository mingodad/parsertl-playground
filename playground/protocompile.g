//From: https://github.com/bufbuild/protocompile/blob/ed4d675274431444f0d4be033ac117b90233098c/parser/proto.y

/*Tokens*/
%token _BOOL
%token _BYTES
%token _DOUBLE
%token _EDITION
%token _ENUM
//%token _ERROR
%token _EXTEND
%token _EXTENSIONS
%token _FALSE
%token _FIXED32
%token _FIXED64
%token _FLOAT
%token _FLOAT_LIT
%token _GROUP
%token _IMPORT
%token _INF
%token _INT32
%token _INT64
%token _INT_LIT
%token _MAP
%token _MAX
%token _MESSAGE
%token _NAME
%token _NAN
%token _ONEOF
%token _OPTION
%token _OPTIONAL
%token _PACKAGE
%token _PUBLIC
%token _REPEATED
%token _REQUIRED
%token _RESERVED
%token _RETURNS
%token _RPC
%token _SERVICE
%token _SFIXED32
%token _SFIXED64
%token _SINT32
%token _SINT64
%token _STREAM
%token _STRING
%token _STRING_LIT
%token _SYNTAX
%token _TO
%token _TRUE
%token _UINT32
%token _UINT64
%token _WEAK


%start file

%%

file :
	syntaxDecl
	| editionDecl
	| fileBody
	| syntaxDecl fileBody
	| editionDecl fileBody
	| /*empty*/
	;

fileBody :
	semicolons fileElements
	;

fileElements :
	fileElements fileElement
	| fileElement
	;

fileElement :
	importDecl
	| packageDecl
	| optionDecl
	| messageDecl
	| enumDecl
	| extensionDecl
	| serviceDecl
	//| error
	;

semicolonList :
	';'
	| semicolonList ';'
	;

semicolons :
	semicolonList
	| /*empty*/
	;

semicolon :
	';'
	| /*empty*/
	;

syntaxDecl :
	_SYNTAX '=' stringLit ';'
	;

editionDecl :
	_EDITION '=' stringLit ';'
	;

importDecl :
	_IMPORT stringLit semicolons
	| _IMPORT _WEAK stringLit semicolons
	| _IMPORT _PUBLIC stringLit semicolons
	;

packageDecl :
	_PACKAGE qualifiedIdentifier semicolons
	;

qualifiedIdentifier :
	identifier
	| qualifiedIdentifier '.' identifier
	;

qualifiedIdentifierDot :
	qualifiedIdentifierFinal
	| qualifiedIdentifierLeading qualifiedIdentifierFinal
	;

qualifiedIdentifierLeading :
	qualifiedIdentifierEntry
	| qualifiedIdentifierLeading qualifiedIdentifierEntry
	;

qualifiedIdentifierFinal :
	identifier
	| qualifiedIdentifierEntry
	;

qualifiedIdentifierEntry :
	identifier '.'
	;

msgElementIdent :
	msgElementName
	| msgElementIdent '.' identifier
	;

extElementIdent :
	extElementName
	| extElementIdent '.' identifier
	;

oneofElementIdent :
	oneofElementName
	| oneofElementIdent '.' identifier
	;

notGroupElementIdent :
	notGroupElementName
	| notGroupElementIdent '.' identifier
	;

mtdElementIdent :
	mtdElementIdentFinal
	| mtdElementIdentLeading mtdElementIdentFinal
	;

mtdElementIdentLeading :
	mtdElementIdentEntry
	| mtdElementIdentLeading mtdElementIdentEntry
	;

mtdElementIdentFinal :
	mtdElementName
	| mtdElementIdentEntry
	;

mtdElementIdentEntry :
	mtdElementName '.'
	;

oneofOptionDecl :
	_OPTION optionName '=' optionValue semicolon
	;

optionDecl :
	_OPTION optionName '=' optionValue semicolons
	;

optionNamePart :
	identifier
	| extensionName
	;

optionNameEntry :
	optionNamePart '.'
	;

optionNameFinal :
	optionNamePart
	| optionNameEntry
	;

optionNameLeading :
	optionNameEntry
	| optionNameLeading optionNameEntry
	;

optionName :
	optionNameFinal
	| optionNameLeading optionNameFinal
	;

extensionName :
	'(' typeName ')'
	;

optionValue :
	scalarValue
	| messageLiteralWithBraces
	;

scalarValue :
	stringLit
	| numLit
	| specialFloatLit
	| identifier
	;

numLit :
	_FLOAT_LIT
	| '-' _FLOAT_LIT
	| _INT_LIT
	| '-' _INT_LIT
	;

specialFloatLit :
	'-' _INF
	| '-' _NAN
	;

stringLit :
	_STRING_LIT
	| stringLit _STRING_LIT
	;

messageLiteralWithBraces :
	'{' messageTextFormat '}'
	| '{' '}'
	;

messageTextFormat :
	messageLiteralFields
	;

messageLiteralFields :
	messageLiteralFieldEntry
	| messageLiteralFieldEntry messageLiteralFields
	;

messageLiteralFieldEntry :
	messageLiteralField
	| messageLiteralField ','
	| messageLiteralField ';'
	//| error ','
	//| error ';'
	//| error
	;

messageLiteralField :
	messageLiteralFieldName ':' fieldValue
	| messageLiteralFieldName messageValue
	//| error ':' fieldValue
	;

messageLiteralFieldName :
	identifier
	| '[' qualifiedIdentifierDot ']'
	| '[' qualifiedIdentifierDot '/' qualifiedIdentifierDot ']'
	//| '[' error ']'
	;

fieldValue :
	fieldScalarValue
	| messageLiteral
	| listLiteral
	;

fieldScalarValue :
	stringLit
	| numLit
	| '-' identifier
	| identifier
	;

messageValue :
	messageLiteral
	| listOfMessagesLiteral
	;

messageLiteral :
	messageLiteralWithBraces
	| '<' messageTextFormat '>'
	| '<' '>'
	;

listLiteral :
	'[' listElements ']'
	| '[' ']'
	//| '[' error ']'
	;

listElements :
	listElement
	| listElements ',' listElement
	;

listElement :
	fieldScalarValue
	| messageLiteral
	;

listOfMessagesLiteral :
	'[' messageLiterals ']'
	| '[' ']'
	//| '[' error ']'
	;

messageLiterals :
	messageLiteral
	| messageLiterals ',' messageLiteral
	;

typeName :
	qualifiedIdentifierDot
	| '.' qualifiedIdentifierDot
	;

msgElementTypeIdent :
	msgElementIdent
	| '.' qualifiedIdentifier
	;

extElementTypeIdent :
	extElementIdent
	| '.' qualifiedIdentifier
	;

oneofElementTypeIdent :
	oneofElementIdent
	| '.' qualifiedIdentifier
	;

notGroupElementTypeIdent :
	notGroupElementIdent
	| '.' qualifiedIdentifier
	;

mtdElementTypeIdent :
	mtdElementIdent
	| '.' qualifiedIdentifierDot
	;

fieldCardinality :
	_REQUIRED
	| _OPTIONAL
	| _REPEATED
	;

compactOptions :
	'[' compactOptionDecls ']'
	| '[' ']'
	;

compactOptionDecls :
	compactOptionFinal
	| compactOptionLeadingDecls compactOptionFinal
	;

compactOptionLeadingDecls :
	compactOptionEntry
	| compactOptionLeadingDecls compactOptionEntry
	;

compactOptionFinal :
	compactOption
	| compactOptionEntry
	;

compactOptionEntry :
	compactOption ','
	;

compactOption :
	optionName '=' optionValue
	| optionName
	;

groupDecl :
	fieldCardinality _GROUP identifier '=' _INT_LIT '{' messageBody '}'
	| fieldCardinality _GROUP identifier '=' _INT_LIT compactOptions '{' messageBody '}'
	;

messageGroupDecl :
	fieldCardinality _GROUP identifier '=' _INT_LIT '{' messageBody '}' semicolons
	| fieldCardinality _GROUP identifier '=' _INT_LIT compactOptions '{' messageBody '}' semicolons
	| fieldCardinality _GROUP identifier '{' messageBody '}' semicolons
	| fieldCardinality _GROUP identifier compactOptions '{' messageBody '}' semicolons
	;

oneofDecl :
	_ONEOF identifier '{' oneofBody '}' semicolons
	;

oneofBody :
	/*empty*/
	| oneofElements
	;

oneofElements :
	oneofElements oneofElement
	| oneofElement
	;

oneofElement :
	oneofOptionDecl
	| oneofFieldDecl
	| oneofGroupDecl
	//| error ';'
	//| error
	;

oneofFieldDecl :
	oneofElementTypeIdent identifier '=' _INT_LIT semicolon
	| oneofElementTypeIdent identifier '=' _INT_LIT compactOptions semicolon
	| oneofElementTypeIdent identifier semicolon
	| oneofElementTypeIdent identifier compactOptions semicolon
	;

oneofGroupDecl :
	_GROUP identifier '=' _INT_LIT '{' messageBody '}'
	| _GROUP identifier '=' _INT_LIT compactOptions '{' messageBody '}'
	| _GROUP identifier '{' messageBody '}'
	| _GROUP identifier compactOptions '{' messageBody '}'
	;

mapFieldDecl :
	mapType identifier '=' _INT_LIT semicolons
	| mapType identifier '=' _INT_LIT compactOptions semicolons
	| mapType identifier semicolons
	| mapType identifier compactOptions semicolons
	;

mapType :
	_MAP '<' mapKeyType ',' typeName '>'
	;

mapKeyType :
	_INT32
	| _INT64
	| _UINT32
	| _UINT64
	| _SINT32
	| _SINT64
	| _FIXED32
	| _FIXED64
	| _SFIXED32
	| _SFIXED64
	| _BOOL
	| _STRING
	;

extensionRangeDecl :
	_EXTENSIONS tagRanges ';' semicolons
	| _EXTENSIONS tagRanges compactOptions semicolons
	;

tagRanges :
	tagRange
	| tagRanges ',' tagRange
	;

tagRange :
	_INT_LIT
	| _INT_LIT _TO _INT_LIT
	| _INT_LIT _TO _MAX
	;

enumValueRanges :
	enumValueRange
	| enumValueRanges ',' enumValueRange
	;

enumValueRange :
	enumValueNumber
	| enumValueNumber _TO enumValueNumber
	| enumValueNumber _TO _MAX
	;

enumValueNumber :
	_INT_LIT
	| '-' _INT_LIT
	;

msgReserved :
	_RESERVED tagRanges ';' semicolons
	| reservedNames
	;

enumReserved :
	_RESERVED enumValueRanges ';' semicolons
	| reservedNames
	;

reservedNames :
	_RESERVED fieldNameStrings semicolons
	| _RESERVED fieldNameIdents semicolons
	;

fieldNameStrings :
	stringLit
	| fieldNameStrings ',' stringLit
	;

fieldNameIdents :
	identifier
	| fieldNameIdents ',' identifier
	;

enumDecl :
	_ENUM identifier '{' enumBody '}' semicolons
	;

enumBody :
	semicolons
	| semicolons enumElements
	;

enumElements :
	enumElements enumElement
	| enumElement
	;

enumElement :
	optionDecl
	| enumValueDecl
	| enumReserved
	//| error
	;

enumValueDecl :
	enumValueName '=' enumValueNumber semicolons
	| enumValueName '=' enumValueNumber compactOptions semicolons
	;

messageDecl :
	_MESSAGE identifier '{' messageBody '}' semicolons
	;

messageBody :
	semicolons
	| semicolons messageElements
	;

messageElements :
	messageElements messageElement
	| messageElement
	;

messageElement :
	messageFieldDecl
	| enumDecl
	| messageDecl
	| extensionDecl
	| extensionRangeDecl
	| messageGroupDecl
	| optionDecl
	| oneofDecl
	| mapFieldDecl
	| msgReserved
	//| error
	;

messageFieldDecl :
	fieldCardinality notGroupElementTypeIdent identifier '=' _INT_LIT semicolons
	| fieldCardinality notGroupElementTypeIdent identifier '=' _INT_LIT compactOptions semicolons
	| msgElementTypeIdent identifier '=' _INT_LIT semicolons
	| msgElementTypeIdent identifier '=' _INT_LIT compactOptions semicolons
	| fieldCardinality notGroupElementTypeIdent identifier semicolons
	| fieldCardinality notGroupElementTypeIdent identifier compactOptions semicolons
	| msgElementTypeIdent identifier semicolons
	| msgElementTypeIdent identifier compactOptions semicolons
	;

extensionDecl :
	_EXTEND typeName '{' extensionBody '}' semicolons
	;

extensionBody :
	/*empty*/
	| extensionElements
	;

extensionElements :
	extensionElements extensionElement
	| extensionElement
	;

extensionElement :
	extensionFieldDecl
	| groupDecl
	//| error ';'
	//| error
	;

extensionFieldDecl :
	fieldCardinality notGroupElementTypeIdent identifier '=' _INT_LIT semicolon
	| fieldCardinality notGroupElementTypeIdent identifier '=' _INT_LIT compactOptions semicolon
	| extElementTypeIdent identifier '=' _INT_LIT semicolon
	| extElementTypeIdent identifier '=' _INT_LIT compactOptions semicolon
	;

serviceDecl :
	_SERVICE identifier '{' serviceBody '}' semicolons
	;

serviceBody :
	semicolons
	| semicolons serviceElements
	;

serviceElements :
	serviceElements serviceElement
	| serviceElement
	;

serviceElement :
	optionDecl
	| methodDecl
	//| error
	;

methodDecl :
	_RPC identifier methodMessageType _RETURNS methodMessageType semicolons
	| _RPC identifier methodMessageType _RETURNS methodMessageType '{' methodBody '}' semicolons
	;

methodMessageType :
	'(' _STREAM typeName ')'
	| '(' mtdElementTypeIdent ')'
	;

methodBody :
	semicolons
	| semicolons methodElements
	;

methodElements :
	methodElements methodElement
	| methodElement
	;

methodElement :
	optionDecl
	//| error
	;

msgElementName :
	_NAME
	| _SYNTAX
	| _EDITION
	| _IMPORT
	| _WEAK
	| _PUBLIC
	| _PACKAGE
	| _TRUE
	| _FALSE
	| _INF
	| _NAN
	| _DOUBLE
	| _FLOAT
	| _INT32
	| _INT64
	| _UINT32
	| _UINT64
	| _SINT32
	| _SINT64
	| _FIXED32
	| _FIXED64
	| _SFIXED32
	| _SFIXED64
	| _BOOL
	| _STRING
	| _BYTES
	| _MAP
	| _TO
	| _MAX
	| _SERVICE
	| _RPC
	| _STREAM
	| _RETURNS
	;

extElementName :
	_NAME
	| _SYNTAX
	| _EDITION
	| _IMPORT
	| _WEAK
	| _PUBLIC
	| _PACKAGE
	| _OPTION
	| _TRUE
	| _FALSE
	| _INF
	| _NAN
	| _DOUBLE
	| _FLOAT
	| _INT32
	| _INT64
	| _UINT32
	| _UINT64
	| _SINT32
	| _SINT64
	| _FIXED32
	| _FIXED64
	| _SFIXED32
	| _SFIXED64
	| _BOOL
	| _STRING
	| _BYTES
	| _ONEOF
	| _MAP
	| _EXTENSIONS
	| _TO
	| _MAX
	| _RESERVED
	| _ENUM
	| _MESSAGE
	| _EXTEND
	| _SERVICE
	| _RPC
	| _STREAM
	| _RETURNS
	;

enumValueName :
	_NAME
	| _SYNTAX
	| _EDITION
	| _IMPORT
	| _WEAK
	| _PUBLIC
	| _PACKAGE
	| _TRUE
	| _FALSE
	| _INF
	| _NAN
	| _REPEATED
	| _OPTIONAL
	| _REQUIRED
	| _DOUBLE
	| _FLOAT
	| _INT32
	| _INT64
	| _UINT32
	| _UINT64
	| _SINT32
	| _SINT64
	| _FIXED32
	| _FIXED64
	| _SFIXED32
	| _SFIXED64
	| _BOOL
	| _STRING
	| _BYTES
	| _GROUP
	| _ONEOF
	| _MAP
	| _EXTENSIONS
	| _TO
	| _MAX
	| _ENUM
	| _MESSAGE
	| _EXTEND
	| _SERVICE
	| _RPC
	| _STREAM
	| _RETURNS
	;

oneofElementName :
	_NAME
	| _SYNTAX
	| _EDITION
	| _IMPORT
	| _WEAK
	| _PUBLIC
	| _PACKAGE
	| _TRUE
	| _FALSE
	| _INF
	| _NAN
	| _DOUBLE
	| _FLOAT
	| _INT32
	| _INT64
	| _UINT32
	| _UINT64
	| _SINT32
	| _SINT64
	| _FIXED32
	| _FIXED64
	| _SFIXED32
	| _SFIXED64
	| _BOOL
	| _STRING
	| _BYTES
	| _ONEOF
	| _MAP
	| _EXTENSIONS
	| _TO
	| _MAX
	| _RESERVED
	| _ENUM
	| _MESSAGE
	| _EXTEND
	| _SERVICE
	| _RPC
	| _STREAM
	| _RETURNS
	;

notGroupElementName :
	_NAME
	| _SYNTAX
	| _EDITION
	| _IMPORT
	| _WEAK
	| _PUBLIC
	| _PACKAGE
	| _OPTION
	| _TRUE
	| _FALSE
	| _INF
	| _NAN
	| _REPEATED
	| _OPTIONAL
	| _REQUIRED
	| _DOUBLE
	| _FLOAT
	| _INT32
	| _INT64
	| _UINT32
	| _UINT64
	| _SINT32
	| _SINT64
	| _FIXED32
	| _FIXED64
	| _SFIXED32
	| _SFIXED64
	| _BOOL
	| _STRING
	| _BYTES
	| _ONEOF
	| _MAP
	| _EXTENSIONS
	| _TO
	| _MAX
	| _RESERVED
	| _ENUM
	| _MESSAGE
	| _EXTEND
	| _SERVICE
	| _RPC
	| _STREAM
	| _RETURNS
	;

mtdElementName :
	_NAME
	| _SYNTAX
	| _EDITION
	| _IMPORT
	| _WEAK
	| _PUBLIC
	| _PACKAGE
	| _OPTION
	| _TRUE
	| _FALSE
	| _INF
	| _NAN
	| _REPEATED
	| _OPTIONAL
	| _REQUIRED
	| _DOUBLE
	| _FLOAT
	| _INT32
	| _INT64
	| _UINT32
	| _UINT64
	| _SINT32
	| _SINT64
	| _FIXED32
	| _FIXED64
	| _SFIXED32
	| _SFIXED64
	| _BOOL
	| _STRING
	| _BYTES
	| _GROUP
	| _ONEOF
	| _MAP
	| _EXTENSIONS
	| _TO
	| _MAX
	| _RESERVED
	| _ENUM
	| _MESSAGE
	| _EXTEND
	| _SERVICE
	| _RPC
	| _RETURNS
	;

identifier :
	_NAME
	| _SYNTAX
	| _EDITION
	| _IMPORT
	| _WEAK
	| _PUBLIC
	| _PACKAGE
	| _OPTION
	| _TRUE
	| _FALSE
	| _INF
	| _NAN
	| _REPEATED
	| _OPTIONAL
	| _REQUIRED
	| _DOUBLE
	| _FLOAT
	| _INT32
	| _INT64
	| _UINT32
	| _UINT64
	| _SINT32
	| _SINT64
	| _FIXED32
	| _FIXED64
	| _SFIXED32
	| _SFIXED64
	| _BOOL
	| _STRING
	| _BYTES
	| _GROUP
	| _ONEOF
	| _MAP
	| _EXTENSIONS
	| _TO
	| _MAX
	| _RESERVED
	| _ENUM
	| _MESSAGE
	| _EXTEND
	| _SERVICE
	| _RPC
	| _STREAM
	| _RETURNS
	;

%%

ID           [_A-Za-z][_A-Za-z0-9]*

DIGIT        [0-9]
BINDIGIT     [0-1]
OCTDIGIT     [0-7]
HEXDIGIT     [0-9A-F]

SIGN         [+-]?
EXPONENT     [Ee]{SIGN}{DIGIT}+

REAL         {DIGIT}+\.{DIGIT}+{EXPONENT}?|{DIGIT}+{EXPONENT}

ROOT         {DIGIT}\#|{DIGIT}{DIGIT}\#

INTEGER      {DIGIT}+|{ROOT}{HEXDIGIT}+|{BINDIGIT}+B|"0"[xX]{HEXDIGIT}+|{DIGIT}{HEXDIGIT}*[Hh]|"%"{BINDIGIT}+

%%

[ \t\r\n]+	skip()
"//".*	skip()

"("	'('
")"	')'
","	','
"-"	'-'
"."	'.'
"/"	'/'
":"	':'
";"	';'
"<"	'<'
"="	'='
">"	'>'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'

"bool"	_BOOL
"bytes"	_BYTES
"double"	_DOUBLE
"edition"	_EDITION
"enum"	_ENUM
"extend"	_EXTEND
"extensions"	_EXTENSIONS
"false"	_FALSE
"fixed32"	_FIXED32
"fixed64"	_FIXED64
"float"	_FLOAT
"group"	_GROUP
"import"	_IMPORT
"inf"	_INF
"int32"	_INT32
"int64"	_INT64
"map"	_MAP
"max"	_MAX
"message"	_MESSAGE
"nan"	_NAN
"oneof"	_ONEOF
"optional"	_OPTIONAL
"option"	_OPTION
"package"	_PACKAGE
"public"	_PUBLIC
"repeated"	_REPEATED
"required"	_REQUIRED
"reserved"	_RESERVED
"returns"	_RETURNS
"rpc"	_RPC
"service"	_SERVICE
"sfixed32"	_SFIXED32
"sfixed64"	_SFIXED64
"sint32"	_SINT32
"sint64"	_SINT64
"stream"	_STREAM
"string"	_STRING
"syntax"	_SYNTAX
"to"	_TO
"true"	_TRUE
"uint32"	_UINT32
"uint64"	_UINT64
"weak"	_WEAK

{REAL}	_FLOAT_LIT
{INTEGER}	_INT_LIT
\"(\\.|[^"\r\n\\])*\"	_STRING_LIT
{ID}	_NAME

%%
