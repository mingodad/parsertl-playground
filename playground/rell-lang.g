//From: https://bitbucket.org/chromawallet/rell-jetbrains/src/main/src/main/kotlin/net/postchain/rellide/jetbrains/language/Rell.bnf

%token BIG_INTEGER
%token BYTES
%token BaseExprTailNotNull
%token DECIMAL
%token DollarExpr
%token ID
%token NUMBER
%token NullLiteralExpr
%token STRING
%token tkASSIGN
%token tkAT
%token tkArrow
%token tkBREAK
%token tkCARET
%token tkCOLON
%token tkCOMMA
%token tkCONTINUE
%token tkCREATE
%token tkDELETE
%token tkDOT
%token tkENUM
%token tkElse
%token tkFOR
%token tkFUNCTION
%token tkGT
%token tkGUARD
%token tkIF
%token tkIMPORT
%token tkIN
%token tkINCLUDE
%token tkLBRACK
%token tkLCURL
%token tkLPAR
%token tkLT
%token tkLimit
%token tkMODULE
%token tkMUL
%token tkMUTABLE
%token tkNAMESPACE
%token tkOBJECT
%token tkOPERATION
%token tkOffset
%token tkPLUS
%token tkQUERY
%token tkQUESTION
%token tkRBRACK
%token tkRCURL
%token tkRETURN
%token tkRPAR
%token tkSEMI
%token tkSTRUCT
%token tkUPDATE
%token tkVAL
%token tkVIRTUAL
%token tkWHEN
%token tkWHILE

%%

RootParser:
	  Modifiers AnyDef	#AnnotatedDef
	  | Modifiers tkMODULE tkSEMI #ModuleHeader
	  | RootParser Modifiers AnyDef
	;

AnnotatedDef_zom:
	  %empty
	| AnnotatedDef_zom Modifiers AnyDef //AnnotatedDef
	;

Modifiers:
	  %empty
	| Modifiers Modifier
	;

Modifier:
	  KeywordModifier
	| Annotation
	;

KeywordModifier:
	  "abstract"
	| "override"
	;

Annotation:
	  tkAT Name AnnotationArgs_opt
	;

AnnotationArgs_opt:
	  %empty
	| AnnotationArgs
	;

Name:
	  ID
	;

AnnotationArgs:
	  tkLPAR AnnotationArg_oom_tkCOMMA_opt_opt tkRPAR
	;

AnnotationArg_oom_tkCOMMA_opt_opt:
	  %empty
	| AnnotationArg_oom tkCOMMA_opt
	;

tkCOMMA_opt:
	  %empty
	| tkCOMMA
	;

AnnotationArg_oom:
	  AnnotationArg
	| AnnotationArg_oom tkCOMMA AnnotationArg
	;

AnnotationArg:
	  AnnotationArgValue
	| QName #AnnotationArgName
	;

AnnotationArgValue:
	  LiteralExpr
	;

LiteralExpr:
	  BigIntExpr
	| IntExpr
	| DecimalExpr
	| StringExpr
	| BytesExpr
	| "false"
	| "true"
	| NullLiteralExpr
	;

IntExpr:
	  NUMBER
	;

BigIntExpr:
	  BIG_INTEGER
	;

DecimalExpr:
	  DECIMAL
	;

StringExpr:
	  STRING
	;

BytesExpr:
	  BYTES
	;

QualifiedName:
	  Name tkDOT_Name
	| QualifiedName tkDOT_Name
	;

AnyDef:
	  EntityDef
	| ObjectDef
	| StructDef
	| EnumDef
	| FunctionDef
	| NamespaceDef
	| ImportDef
	| OpDef
	| QueryDef
	| IncludeDef
	| ConstantDef
	;

EntityDef:
	  EntityKeyword Name EntityAnnotations_opt EntityBody_opt
	;

EntityBody_opt:
	  %empty
	| EntityBody
	;

EntityAnnotations_opt:
	  %empty
	| EntityAnnotations
	;

EntityKeyword:
	  "entity"
	| "class"
	;

EntityAnnotations:
	  tkLPAR Name_oom tkCOMMA_opt tkRPAR
	;

Name_oom:
	  Name
	| Name_oom tkCOMMA Name
	;

EntityBody:
	  EntityBodyFull
	| tkSEMI #EntityBodyShort
	;

EntityBodyFull:
	  tkLCURL RelClause_zom tkRCURL
	;

RelClause_zom:
	  %empty
	| RelClause_zom RelClause
	;

RelClause:
	  AttributeClause
	| KeyIndexClause
	;

AttributeClause:
	  AttributeDefinition
	;

AttributeDefinition:
	  BaseAttributeDefinition tkSEMI
	;

BaseAttributeDefinition:
	  tkMUTABLE_opt AttrHeader tkASSIGN_ExpressionRef_opt
	;

tkASSIGN_ExpressionRef_opt:
	  %empty
	| tkASSIGN ExpressionRef
	;

tkMUTABLE_opt:
	  %empty
	| tkMUTABLE
	;

AttrHeader:
	  NameTypeAttrHeader
	| AnonAttrHeader
	;

NameTypeAttrHeader:
	  Name tkCOLON Type
	;

Type:
	  ComplexNullableType
	| FunctionType
	| BasicType
	;

ComplexNullableType:
	  tkLPAR TypeRef tkRPAR tkQUESTION
	;

TypeRef:
	  Type
	;

FunctionType:
	  tkLPAR TypeRef_zom tkRPAR tkArrow TypeRef
	;

TypeRef_zom:
	  %empty
	| TypeRef_zom tkCOMMA TypeRef
	;

BasicType:
	  PrimaryType tkQUESTION_zom
	;

tkQUESTION_zom:
	  %empty
	| tkQUESTION_zom tkQUESTION
	;

PrimaryType:
	  GenericType
	| Name
	//| QualifiedName #NameType
	| TupleType
	| VirtualType
	| MirrorStructType
	;

GenericType:
	  QName tkLT TypeRef TypeRef_zom tkCOMMA_opt tkGT
	;

TupleType:
	  tkLPAR TupleTypeField_oom tkCOMMA_opt tkRPAR
	;

TupleTypeField_oom:
	  TupleTypeField
	| TupleTypeField_oom tkCOMMA TupleTypeField
	;

TupleTypeField:
	  TypeRef
	|  Name tkCOLON TypeRef
	;

VirtualType:
	  tkVIRTUAL tkLT TypeRef tkGT
	;

MirrorStructType:
	  tkSTRUCT tkLT tkMUTABLE_opt TypeRef tkGT
	;

AnonAttrHeader:
	  QName tkQUESTION_opt
	;

tkQUESTION_opt:
	  %empty
	| tkQUESTION
	;

ExpressionRef:
	  Expression
	;

Expression:
	  UnaryExpr BinaryExprOperand_zom
	;

BinaryExprOperand_zom:
	  %empty
	| BinaryExprOperand_zom BinaryExprOperand
	;

UnaryExpr:
	  UnaryPrefixOperator_opt OperandExpr
	;

UnaryPrefixOperator_opt:
    %empty
	| tkPLUS
	| '-'
	| "not"
	| IncrementOperator
	;

IncrementOperator:
	  "++"
	| "--"
	;

OperandExpr:
	  BaseExpr
	| IfExpr
	| WhenExpr
	;

BaseExpr:
	  BaseExprHead BaseExprTail_zom
	;

BaseExprTail_zom:
	  %empty
	| BaseExprTail_zom BaseExprTail
	;

BaseExprHead:
	  GenericTypeExpr
	| AtExpr
	| QName #NameExpr
	| DollarExpr
	//| tkDOT_Name #AttrExpr
	| BigIntExpr
	| IntExpr
	| DecimalExpr
	| StringExpr
	| BytesExpr
	| "false"
	| "true"
	| NullLiteralExpr
	| TupleExpr
	| CreateExpr
	| ListLiteralExpr
	| EmptyMapLiteralExpr
	| NonEmptyMapLiteralExpr
	| MirrorStructExpr
	| VirtualTypeExpr
	;

GenericTypeExpr:
	  GenericType BaseExprTail_kind
	;

BaseExprTail_kind:
	  tkDOT_Name #BaseExprTailMember
	| BaseExprTailCall
	;

tkDOT_Name:
	tkDOT Name
	;

BaseExprTailCall:
	  tkLPAR CallArg_oom_tkCOMMA_opt_opt tkRPAR #CallArgs
	;

CallArg_oom_tkCOMMA_opt_opt:
	  %empty
	| CallArg_oom tkCOMMA_opt
	;

CallArg_oom:
	  CallArg
	| CallArg_oom tkCOMMA CallArg
	;

CallArg:
	 CallArgValue
	//| Name tkASSIGN CallArgValue
	;

CallArgValue:
	  tkMUL
	| ExpressionRef
	;

AtExpr:
	  AtExprFrom BaseExprTailAt
	;

AtExprFrom:
	  tkLPAR AtExprFromItem_oom tkCOMMA_opt tkRPAR
	;

AtExprFromItem_oom:
	  AtExprFromItem
	| AtExprFromItem_oom tkCOMMA AtExprFromItem
	;

AtExprFromItem:
	  ExpressionRef
	| Name tkCOLON ExpressionRef
	| Annotation_oom ExpressionRef
	| Annotation_oom Name tkCOLON ExpressionRef
	;

Annotation_oom:
	  Annotation
	| Annotation_oom Annotation
	;

AtExprWhere:
	  tkLCURL ExpressionRef_oom_tkCOMMA_opt_opt tkRCURL
	;

ExpressionRef_oom_tkCOMMA_opt_opt:
	  %empty
	| ExpressionRef_oom tkCOMMA_opt
	;

ExpressionRef_oom:
	  ExpressionRef
	| ExpressionRef_oom tkCOMMA ExpressionRef
	;

AtExprWhat:
	  AtExprWhatSimple
	| AtExprWhatComplex
	;

AtExprWhatSimple:
	  tkDOT_Name
	| AtExprWhatSimple tkDOT_Name
	;

AtExprWhatComplex:
	  tkLPAR AtExprWhatComplexItem AtExprWhatComplexItem_zom tkCOMMA_opt tkRPAR
	;

AtExprWhatComplexItem_zom:
	  %empty
	| AtExprWhatComplexItem_zom tkCOMMA AtExprWhatComplexItem
	;

AtExprWhatComplexItem:
	  AtExprFromItem
	| AtExprWhatName ExpressionRef
	| Annotation_oom AtExprWhatName ExpressionRef
	;

TupleExpr:
	  tkLPAR TupleExprField TupleExprField_oom tkCOMMA_opt tkRPAR
	;

TupleExprField_oom:
	  TupleExprField
	| TupleExprField_oom tkCOMMA TupleExprField
	;

TupleExprField:
	  ExpressionRef
	|  Name tkASSIGN ExpressionRef
	;

CreateExpr:
	  tkCREATE QName CreateExprArgs
	;

CreateExprArgs:
	  tkLPAR CreateExprArg_oom_tkCOMMA_opt_opt tkRPAR
	;

CreateExprArg_oom_tkCOMMA_opt_opt:
	  %empty
	| CreateExprArg_oom tkCOMMA_opt
	;

CreateExprArg_oom:
	  CreateExprArg
	| CreateExprArg_oom tkCOMMA CreateExprArg
	;

CreateExprArg:
	  CallArgValue
	//|  Name tkASSIGN CallArgValue
	|  tkDOT Name tkASSIGN CallArgValue
	;

ListLiteralExpr:
	  tkLBRACK ExpressionRef_oom_tkCOMMA_opt_opt tkRBRACK
	;

EmptyMapLiteralExpr:
	  tkLBRACK tkCOLON tkRBRACK
	;

NonEmptyMapLiteralExpr:
	  tkLBRACK MapLiteralExprEntry_oom tkCOMMA_opt tkRBRACK
	;

MapLiteralExprEntry_oom:
	  MapLiteralExprEntry
	| MapLiteralExprEntry_oom tkCOMMA MapLiteralExprEntry
	;

MapLiteralExprEntry:
	  ExpressionRef tkCOLON ExpressionRef
	;

MirrorStructExpr:
	  tkSTRUCT tkLT tkMUTABLE_opt TypeRef tkGT
	;

VirtualTypeExpr:
	  VirtualType
	;

BaseExprTail:
	  tkDOT_Name #BaseExprTailMember
	| BaseExprTailSubscript
	| BaseExprTailNotNull
	| BaseExprTailSafeMember
	| BaseExprTailUnaryPostfixOp
	| BaseExprTailCall
	| BaseExprTailAt
	;

BaseExprTailSubscript:
	  tkLBRACK ExpressionRef tkRBRACK
	;

BaseExprTailSafeMember:
	  "?." Name
	;

BaseExprTailUnaryPostfixOp:
	  UnaryPostfixOperator
	;

UnaryPostfixOperator:
	  IncrementOperator
	| "??"
	;

BaseExprTailAt:
	  AtExprAt AtExprWhere AtExprWhat_opt AtExprModifiers_opt
	;

AtExprModifiers_opt:
	  %empty
	| AtExprModifiers
	;

AtExprWhat_opt:
	  %empty
	| AtExprWhat
	;

AtExprAt:
	  tkAT tkQUESTION
	| tkAT tkMUL
	| tkAT tkPLUS
	| tkAT
	;

AtExprWhatName:
	  Name tkASSIGN
	;

AtExprModifiers:
	  tkLimit ExpressionRef AtExprOffset_opt
	| tkOffset ExpressionRef AtExprLimit_opt
	;

AtExprLimit_opt:
	  %empty
	| AtExprLimit
	;

AtExprOffset_opt:
	  %empty
	| AtExprOffset
	;

AtExprOffset:
	  tkOffset ExpressionRef
	;

AtExprLimit:
	  tkLimit ExpressionRef
	;

IfExpr:
	  tkIF tkLPAR ExpressionRef tkRPAR ExpressionRef tkElse ExpressionRef
	;

WhenExpr:
	  tkWHEN WhenExprTest_opt tkLCURL WhenExprCases tkRCURL
	;

WhenExprTest_opt:
	  %empty
	| tkLPAR ExpressionRef tkRPAR
	;

WhenExprCases:
	  WhenExprCase_oom tkSEMI_zom
	;

tkSEMI_zom:
	  %empty
	| tkSEMI_zom tkSEMI
	;

WhenExprCase_oom:
	  WhenExprCase
	| WhenExprCase_oom tkSEMI_oom WhenExprCase
	;

tkSEMI_oom:
	  tkSEMI
	| tkSEMI_oom tkSEMI
	;

WhenExprCase:
	  WhenCondition tkArrow ExpressionRef
	;

WhenCondition:
	  WhenConditionExpr
	| WhenConditionElse
	;

WhenConditionElse:
	  tkElse
	;

WhenConditionExpr:
	  ExpressionRef_oom tkCOMMA_opt
	;

BinaryExprOperand:
	  BinaryOperator UnaryExpr
	;

BinaryOperator:
	  "=="
	| "!="
	| "<="
	| ">="
	| tkLT
	| tkGT
	| "==="
	| "!=="
	| tkPLUS
	| '-'
	| tkMUL
	| '/'
	| '%'
	| "and"
	| "or"
	| tkIN
	| "not" tkIN
	| "?:"
	;

KeyIndexClause:
	  KeyIndexKind BaseAttributeDefinition_oom /*tkCOMMA_opt*/ tkSEMI
	;

BaseAttributeDefinition_oom:
	  BaseAttributeDefinition
	| BaseAttributeDefinition_oom tkCOMMA BaseAttributeDefinition
	;

KeyIndexKind:
	  "key"
	| "index"
	;

ObjectDef:
	  tkOBJECT Name tkLCURL AttributeClause_zom tkRCURL
	;

AttributeClause_zom:
	  %empty
	| AttributeClause_zom AttributeClause
	;

StructDef:
	  StructKeyword Name tkLCURL AttributeClause_zom tkRCURL
	;

StructKeyword:
	  tkSTRUCT
	| "record"
	;

EnumDef:
	  tkENUM Name tkLCURL EnumValue_oom_tkCOMMA_opt_opt tkRCURL
	;

EnumValue_oom_tkCOMMA_opt_opt:
	  %empty
	| EnumValue_oom tkCOMMA_opt
	;

EnumValue_oom:
	  Name #EnumValue
	| EnumValue_oom tkCOMMA Name #EnumValue
	;

FunctionDef:
	  tkFUNCTION QName_opt FormalParameters tkCOLON_Type_opt FunctionBody
	;

tkCOLON_Type_opt:
	  %empty
	| tkCOLON Type
	;

QName_opt:
	  %empty
	| QName
	;

QName:
	Name
	| QualifiedName
	;

FormalParameters:
	  tkLPAR FormalParameter_oom_tkCOMMA_opt_opt tkRPAR
	;

FormalParameter_oom_tkCOMMA_opt_opt:
	  %empty
	| FormalParameter_oom tkCOMMA_opt
	;

FormalParameter_oom:
	  FormalParameter
	| FormalParameter_oom  tkCOMMA FormalParameter
	;

FormalParameter:
	  AttrHeader tkASSIGN_Expression_opt
	;

tkASSIGN_Expression_opt:
	  %empty
	| tkASSIGN Expression
	;

FunctionBody:
	  FunctionBodyShort
	| FunctionBodyFull
	| tkSEMI #FunctionBodyNone
	;

FunctionBodyShort:
	  tkASSIGN Expression tkSEMI
	;

FunctionBodyFull:
	  BlockStmt
	;

BlockStmt:
	  tkLCURL StatementRef_zom tkRCURL
	;

StatementRef_zom:
	  %empty
	| StatementRef_zom StatementRef
	;

StatementRef:
	  Statement
	;

Statement:
	  tkSEMI #EmptyStmt
	| VarStmt
	| AssignStmt
	| ReturnStmt
	| BlockStmt
	| IfStmt
	| WhenStmt
	| WhileStmt
	| ForStmt
	| BreakStmt
	| ContinueStmt
	| UpdateStmt
	| DeleteStmt
	| IncrementStmt
	| CallStmt
	| CreateStmt
	| GuardStmt
	;

VarStmt:
	  VarVal VarDeclarator tkASSIGN_Expression_opt tkSEMI
	;

VarVal:
	  tkVAL
	| "var"
	;

VarDeclarator:
	  SimpleVarDeclarator
	| TupleVarDeclarator
	;

SimpleVarDeclarator:
	  AttrHeader
	;

TupleVarDeclarator:
	  tkLPAR VarDeclarator VarDeclarator_oom tkCOMMA_opt tkRPAR
	;

VarDeclarator_oom:
	  VarDeclarator
	| VarDeclarator_oom tkCOMMA VarDeclarator
	;

AssignStmt:
	  BaseExpr AssignOp Expression tkSEMI
	;

AssignOp:
	  tkASSIGN
	| "+="
	| "-="
	| "*="
	| "/="
	| "%="
	;

ReturnStmt:
	  tkRETURN Expression_opt tkSEMI
	;

Expression_opt:
	  %empty
	| Expression
	;

IfStmt:
	  tkIF tkLPAR Expression tkRPAR StatementRef tkElse_StatementRef_opt
	;

tkElse_StatementRef_opt:
	  %empty
	|  tkElse StatementRef
	;

WhenStmt:
	  tkWHEN WhenExprTest_opt tkLCURL WhenStmtCase_zom tkRCURL
	;

WhenStmtCase_zom:
	  %empty
	| WhenStmtCase_zom WhenStmtCase
	;

WhenStmtCase:
	  WhenCondition tkArrow StatementRef tkSEMI_zom
	;

WhileStmt:
	  tkWHILE tkLPAR Expression tkRPAR StatementRef
	;

ForStmt:
	  tkFOR tkLPAR VarDeclarator tkIN Expression tkRPAR StatementRef
	;

BreakStmt:
	  tkBREAK tkSEMI
	;

ContinueStmt:
	  tkCONTINUE tkSEMI
	;

UpdateStmt:
	  tkUPDATE UpdateTarget UpdateWhat tkSEMI
	;

UpdateTarget:
	  UpdateTargetAt
	| UpdateTargetExpr
	;

UpdateTargetAt:
	  UpdateFrom AtExprAt AtExprWhere
	;

UpdateFrom:
	  QName #UpdateFromSingle
	| UpdateFromMulti
	;

UpdateFromMulti:
	  tkLPAR UpdateFromItem_oom tkCOMMA_opt tkRPAR
	;

UpdateFromItem_oom:
	  UpdateFromItem
	| UpdateFromItem_oom tkCOMMA UpdateFromItem
	;

UpdateFromItem:
	QualifiedName
	;

UpdateTargetExpr:
	  BaseExprNoCallNoAt
	;

BaseExprNoCallNoAt:
	  BaseExprHead BaseExprTailNoCallNoAt_zom
	;

BaseExprTailNoCallNoAt_zom:
	  %empty
	| BaseExprTailNoCallNoAt_zom BaseExprTailNoCallNoAt
	;

BaseExprTailNoCallNoAt:
	  tkDOT_Name #BaseExprTailMember
	| BaseExprTailSubscript
	| BaseExprTailNotNull
	| BaseExprTailSafeMember
	| BaseExprTailUnaryPostfixOp
	;

UpdateWhat:
	  tkLPAR UpdateWhatExpr_oom tkCOMMA_opt tkRPAR
	;

UpdateWhatExpr_oom:
	  UpdateWhatExpr
	| UpdateWhatExpr_oom tkCOMMA UpdateWhatExpr
	;

UpdateWhatExpr:
	  UpdateWhatNameOp_opt Expression
	;

UpdateWhatNameOp_opt:
	  %empty
	| Name AssignOp
	| tkDOT Name AssignOp
	;

DeleteStmt:
	  tkDELETE UpdateTarget tkSEMI
	;

IncrementStmt:
	  IncrementOperator BaseExpr tkSEMI
	;

CallStmt:
	  BaseExpr tkSEMI
	;

CreateStmt:
	  CreateExpr tkSEMI
	;

GuardStmt:
	  tkGUARD BlockStmt
	;

NamespaceDef:
	  tkNAMESPACE QName_opt tkLCURL AnnotatedDef_zom tkRCURL
	;

ImportDef:
	  tkIMPORT Name_tkCOLON_opt ImportModule ImportTarget_opt tkSEMI
	;

ImportTarget_opt:
	  %empty
	| ImportTarget
	;

Name_tkCOLON_opt:
	  %empty
	| Name tkCOLON
	;

ImportModule:
	  QualifiedName #AbsoluteImportModule
	| RelativeImportModule
	| UpImportModule
	;

RelativeImportModule:
	  tkDOT QName_opt
	;

UpImportModule:
	  tkCARET_oom
	| tkCARET_oom tkDOT QName
	;

tkCARET_oom:
	  tkCARET
	| tkCARET_oom tkCARET
	;

ImportTarget:
	  tkDOT ImportTarget_kind
	;

ImportTarget_kind:
	  ImportTargetExact
	| ImportTargetWildcard
	;

ImportTargetWildcard:
	  tkMUL
	;

ImportTargetExact:
	  tkLCURL ImportTargetExactItem_oom tkCOMMA_opt tkRCURL
	;

ImportTargetExactItem_oom:
	  ImportTargetExactItem
	| ImportTargetExactItem_oom tkCOMMA ImportTargetExactItem
	;

ImportTargetExactItem:
	  QualifiedName ImportAll_opt
	;

ImportAll_opt:
	  %empty
	| tkDOT tkMUL
	;

OpDef:
	  tkOPERATION Name FormalParameters BlockStmt
	;

QueryDef:
	  tkQUERY Name FormalParameters tkCOLON_Type_opt QueryBody
	;

QueryBody:
	  FunctionBodyShort
	| FunctionBodyFull
	;

IncludeDef:
	  tkINCLUDE STRING tkSEMI
	;

ConstantDef:
	  tkVAL Name tkCOLON_TypeRef_opt tkASSIGN ExpressionRef tkSEMI
	;

tkCOLON_TypeRef_opt:
	  %empty
	| tkCOLON TypeRef
	;

%%

DECNUM	[0-9]+
HEXDIG	[0-9A-Fa-f]
HEXDIGNUM "0x"{HEXDIG}+
COEF    [eE][-+]?[0-9]+
DECIMAL	{DECNUM}{COEF}|({DECNUM}\.[0-9]*|\.[0-9]+){COEF}?


COMMON_INT	{HEXDIGNUM}|{DECNUM}
BIG_INTEGER	{COMMON_INT}"L"
NUMBER	{COMMON_INT}

BYTE_HEX	[_0-9a-fA-F]
BYTES "x"(('({BYTE_HEX}{BYTE_HEX})*')|(\"({BYTE_HEX}{BYTE_HEX})*\"))

%%

[ \t\r\n]+	skip()
"//".*	skip()
"/*"(?s:.)*?"*/"	skip()

"<="	"<="
"==="	"==="
"=="	"=="
">="	">="
"-="	"-="
"--"	"--"
"-"	'-'
"!=="	"!=="
"!="	"!="
"?:"	"?:"
"??"	"??"
"?."	"?."
"/="	"/="
"/"	'/'
"*="	"*="
"%="	"%="
"%"	'%'
"+="	"+="
"++"	"++"
"abstract"	"abstract"
"and"	"and"
"!!"	BaseExprTailNotNull
"break"	tkBREAK
"class"	"class"
"continue"	tkCONTINUE
"create"	tkCREATE
"delete"	tkDELETE
"$"	DollarExpr
"else"	tkElse
"entity"	"entity"
"enum"	tkENUM
"false"	"false"
"for"	tkFOR
"function"	tkFUNCTION
"guard"	tkGUARD
"if"	tkIF
"import"	tkIMPORT
"include"	tkINCLUDE
"index"	"index"
"in"	tkIN
"key"	"key"
"limit"	tkLimit
"module"	tkMODULE
"mutable"	tkMUTABLE
"namespace"	tkNAMESPACE
"not"	"not"
"null"	NullLiteralExpr
"object"	tkOBJECT
"offset"	tkOffset
"operation"	tkOPERATION
"or"	"or"
"override"	"override"
"query"	tkQUERY
"record"	"record"
"return"	tkRETURN
"struct"	tkSTRUCT
"->"	tkArrow
"="	tkASSIGN
"@"	tkAT
"^"	tkCARET
":"	tkCOLON
","	tkCOMMA
"."	tkDOT
">"	tkGT
"["	tkLBRACK
"{"	tkLCURL
"("	tkLPAR
"<"	tkLT
"*"	tkMUL
"+"	tkPLUS
"?"	tkQUESTION
"]"	tkRBRACK
"}"	tkRCURL
")"	tkRPAR
";"	tkSEMI
"true"	"true"
"update"	tkUPDATE
"val"	tkVAL
"var"	"var"
"virtual"	tkVIRTUAL
"when"	tkWHEN
"while"	tkWHILE

{BIG_INTEGER}	BIG_INTEGER
{BYTES}	BYTES
{DECIMAL}	DECIMAL
{NUMBER}	NUMBER

\"(\\.|[^"\r\n\\])*\"	STRING
'(\\.|[^'\r\n\\])*'	STRING

[a-zA-Z_][a-zA-Z_0-9]*	ID

%%
