//From: https://github.com/hpcc-systems/HPCC-Platform/blob/d0b0b391fde0c00a2f1830e6865c0c28e1d5ce60/ecl/hql/hqlgram.y
//
//    HPCC SYSTEMS software Copyright (C) 2012 HPCC Systems®.
//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
//############################################################################## */

/*Tokens*/
%token ABS
%token ACOS
%token AFTER
%token AGGREGATE
%token ALGORITHM
%token ALIAS
%token ALL
%token ALLNODES
%token AND
%token ANY
%token APPLY
%token _ARRAY_
%token AS
%token ASCII
%token ASIN
%token TOK_ASSERT
%token ASSTRING
%token ATAN
%token ATAN2
%token ATMOST
%token AVE
%token BACKUP
%token BEFORE
%token BEST
%token BETWEEN
%token TOK_BITMAP
%token BIG
%token BLOB
%token BLOOM
%token BNOT
%token BUILD
%token CARDINALITY
%token CASE
%token TOK_CATCH
%token CHECKPOINT
%token CHOOSE
%token CHOOSEN
%token CHOOSENALL
%token CHOOSESETS
%token CLUSTER
%token CLUSTERSIZE
%token COGROUP
%token __COMMON__
%token __COMPOUND__
%token COMBINE
%token COMPRESSED
%token __COMPRESSED__
%token CRITICAL
%token TOK_CONST
%token CORRELATION
%token COS
%token COSH
%token COUNT
%token COUNTER
%token COVARIANCE
%token CPPBODY
%token TOK_CPP
%token CRC
%token CRON
%token CSV
%token DATASET
%token __DEBUG__
%token DEDUP
%token DEFAULT
%token DEFINE
%token DENORMALIZE
%token DEPRECATED
%token DESC
%token DICTIONARY
%token DISTRIBUTE
%token DISTRIBUTED
%token DISTRIBUTION
%token DYNAMIC
%token EBCDIC
%token ECLCRC
%token ELSE
%token ELSEIF
%token EMBED
%token EMBEDDED
%token _EMPTY_
%token ENCODING
%token ENCRYPT
%token ENCRYPTED
%token END
//%token ENDCPP
//%token ENDEMBED
%token ENTH
%token ENUM
%token TOK_ERROR
%token ESCAPE
%token EVALUATE
%token EVENT
%token EVENTEXTRA
%token EVENTNAME
%token EXCEPT
%token EXCLUSIVE
%token EXISTS
%token EXP
%token EXPIRE
%token EXPORT
%token EXTEND
%token FAIL
%token FAILCODE
%token FAILMESSAGE
%token FAILURE
%token TOK_FALSE
%token FEATURE
%token FETCH
%token FEW
%token FILEPOSITION
%token FILTERED
%token FIRST
%token TOK_FIXED
%token FLAT
%token FORMENCODED
%token FORMAT_ATTR
%token FORWARD
%token FROM
%token FROMJSON
%token FROMUNICODE
%token FROMXML
%token FULL
%token FUNCTION
%token GETENV
%token GETSECRET
%token GLOBAL
%token GRAPH
%token GROUP
%token GROUPBY
%token GROUPED
%token __GROUPED__
%token GUARD
%token HASH
%token HASH32
%token HASH64
%token HASHMD5
%token HAVING
%token HEADING
%token HINT
%token HTTPCALL
%token HTTPHEADER
%token IF
%token IFF
%token IFBLOCK
%token TOK_IGNORE
//%token IMPLEMENTS
%token IMPORT
%token INDEPENDENT
%token INLINE
%token TOK_IN
%token INNER
%token INTERFACE
%token INTERNAL
%token INTFORMAT
%token ISNULL
%token ISVALID
%token ITERATE
%token JOIN
%token JOINED
%token JSON_TOKEN
%token KEEP
%token KEYDIFF
%token KEYED
%token KEYPATCH
%token KEYUNICODE
%token LABEL
%token LABELED
%token LAST
%token LEFT
%token LENGTH
%token LIBRARY
%token LIKELY
%token LIMIT
%token LINKCOUNTED
%token LITERAL
%token LITTLE
%token LN
%token LOADXML
%token LOCAL
%token LOCALE
%token LOCALFILEPOSITION
%token TOK_LOG
%token LOGICALFILENAME
%token LOOKUP
%token LOOP
%token LZW
%token MANY
%token MAP
%token MATCHED
%token MATCHLENGTH
%token MATCHPOSITION
%token MATCHROW
%token MATCHTEXT
%token MATCHUNICODE
%token MATCHUTF8
%token MAX
%token MAXCOUNT
%token MAXLENGTH
%token MAXSIZE
%token MERGE
%token MERGE_ATTR
%token MERGEJOIN
%token MIN
%token MODULE
%token MOFN
%token MULTIPLE
%token NAMED
%token NAMEOF
%token NAMESPACE
%token NOBOUNDCHECK
%token NOCASE
%token NOCOMBINE
%token NOCONST
%token NOFOLD
%token NOHOIST
%token NOLOCAL
%token NONEMPTY
%token NOOVERWRITE
%token NORMALIZE
%token NOROOT
%token NOSCAN
%token NOSORT
%token __NOSTREAMING__
%token NOT
%token NOTHOR
%token NOTIFY
%token NOTRIM
%token NOXPATH
%token OF
%token OMITTED
%token ONCE
%token ONFAIL
%token ONLY
%token ONWARNING
%token OPT
%token __OPTION__
%token OR
%token ORDERED
%token OUTER
%token OUTPUT
%token TOK_OUT
%token OVERWRITE
%token __OWNED__
%token PACKED
%token PARALLEL
%token PARSE
%token PARTITION
%token PARTITION_ATTR
%token TOK_PATTERN
%token PENALTY
%token PERSIST
//%token PHYSICALFILENAME
%token PIPE
%token PLANE
%token __PLATFORM__
%token POWER
%token PREFETCH
%token PRELOAD
%token PRIORITY
%token PRIVATE
%token PROBABILITY
%token PROCESS
%token PROJECT
%token PROXYADDRESS
%token PULL
%token PULLED
%token QUANTILE
%token QUEUE
%token QUOTE
%token RANDOM
%token RANGE
%token RANK
%token RANKED
%token REALFORMAT
%token RECORD
%token RECORDOF
%token RECOVERY
%token REFRESH
%token REGEXFIND
%token REGEXFINDSET
%token REGEXREPLACE
%token REGROUP
%token REJECTED
//%token RELATIONSHIP
%token REMOTE
%token REPEAT
%token RESPONSE
%token RESTRICTED
%token RETRY
%token RETURN
%token RIGHT
%token RIGHT_NN
%token ROLLUP
%token ROUND
%token ROUNDUP
%token ROW
%token ROWS
%token ROWSET
%token ROWDIFF
%token RULE
%token SAMPLE
%token SCAN
%token SCORE
%token SECTION
%token SELF
%token SEPARATOR
%token __SEQUENCE__
%token SEQUENTIAL
%token SERVICE
%token SET
%token SHARED
%token SIMPLE_TYPE
%token SIN
%token SINGLE
%token SINH
%token SIZEOF
%token SKEW
%token SKIP
%token SMART
%token SOAPACTION
%token SOAPCALL
%token SORT
%token SORTED
%token SQL
%token SQRT
%token STABLE
%token __STAND_ALONE__
%token STEPPED
%token STORED
%token STREAMED
%token SUBSORT
%token SUCCESS
%token SUM
//%token SWAPPED
%token TABLE
%token TAN
%token TANH
%token __TARGET_PLATFORM__
%token TERMINATOR
%token THEN
%token THISNODE
%token THOR
%token THRESHOLD
%token TIMEOUT
%token TIMELIMIT
%token TOKEN
%token TOJSON
%token TOPN
%token TOUNICODE
%token TOXML
%token TRACE
%token TRANSFER
%token TRANSFORM
%token TRIM
%token TRUNCATE
%token TOK_TRUE
%token TYPE
%token TYPEOF
%token UNICODEORDER
%token UNGROUP
%token UNLIKELY
%token UNORDERED
%token UNSIGNED
%token UNSORTED
%token UNSTABLE
%token UPDATE
%token USE
%token VALIDATE
%token VARIANCE
%token VIRTUAL
%token VOLATILE
%token WAIT
%token TOK_WARNING
%token WHEN
%token WHICH
%token WHITESPACE
%token WIDTH
%token WILD
%token WITHIN
%token WHOLE
%token WORKUNIT
%token XML_TOKEN
%token XMLDECODE
%token XMLDEFAULT
%token XMLENCODE
%token XMLNS
%token XMLPROJECT
%token XMLTEXT
%token XMLUNICODE
%token XPATH
%token FIELD_REF
%token FIELDS_REF
%token ANDAND
%token EQ
%token NE
%token LE
%token LT
%token GE
%token GT
%token ORDER
%token ASSIGN
%token GOESTO
%token DOTDOT
%token DIV
%token SHIFTL
%token SHIFTR
%token DATAROW_ID
%token DATASET_ID
%token DICTIONARY_ID
%token SCOPE_ID
%token VALUE_ID
%token VALUE_ID_REF
%token ACTION_ID
%token UNKNOWN_ID
%token RECORD_ID
%token ALIEN_ID
%token TRANSFORM_ID
%token PATTERN_ID
%token FEATURE_ID
%token EVENT_ID
%token ENUM_ID
%token LIST_DATASET_ID
%token SORTLIST_ID
%token TYPE_ID
%token SET_TYPE_ID
%token PATTERN_TYPE_ID
%token DATASET_TYPE_ID
%token DICTIONARY_TYPE_ID
%token DATAROW_FUNCTION
%token DATASET_FUNCTION
%token DICTIONARY_FUNCTION
%token VALUE_FUNCTION
%token ACTION_FUNCTION
%token PATTERN_FUNCTION
%token RECORD_FUNCTION
%token EVENT_FUNCTION
%token SCOPE_FUNCTION
%token TRANSFORM_FUNCTION
%token LIST_DATASET_FUNCTION
%token VALUE_MACRO
%token DEFINITIONS_MACRO
%token BOOL_CONST
%token INTEGER_CONST
%token STRING_CONST
%token DATA_CONST
%token REAL_CONST
%token UNICODE_CONST
%token TYPE_LPAREN
%token TYPE_RPAREN
%token MACRO
%token COMPLEX_MACRO
%token ENDMACRO
//%token SKIPPED
//%token HASHEND
//%token HASHELIF
//%token HASHBREAK
%token INDEX
%token HASH_CONSTANT
%token HASH_OPTION
%token HASH_WORKUNIT
%token HASH_STORED
%token HASH_LINK
%token HASH_ONWARNING
%token HASH_WEBSERVICE
%token HASH_DOLLAR
//%token INTERNAL_READ_NEXT_TOKEN
//%token YY_LAST_TOKEN
%token '+'
%token '-'
%token '*'
%token '/'
%token '%'
%token '|'
%token '^'
%token '&'
%token '.'
%token '('
%token '['
%token ';'
%token ','
%token '$'
%token ')'
%token ':'
%token ']'
%token '{'
%token '}'
%token '@'
%token '?'

%left /*1*/ LOWEST_PRECEDENCE
%left /*2*/ VALUE_MACRO
%left /*3*/ OR
%left /*4*/ AND
%left /*5*/ reduceAttrib
%left /*6*/ UNICODEORDER ORDER
%left /*7*/ SHIFTL SHIFTR
%left /*8*/ '+' '-'
%left /*9*/ DIV '*' '/' '%'
%left /*10*/ '|' '^'
%left /*11*/ ANDAND '&'
%left /*12*/ NOT
%left /*13*/ '.'
%left /*14*/ '('
%left /*15*/ '['
//%left /*16*/ HIGHEST_PRECEDENCE

%start hqlQuery

%%

hqlQuery :
	ENCRYPTED hqlQueryBody
	| hqlQueryBody
	;

hqlQueryBody :
	definitions
	| query
	| definitions query
	| RETURN goodObject ';'
	| definitions setActiveToExpected RETURN goodObject ';'
	| compoundModule ';'
	| recordDef ';'
	| definitions recordDef ';'
	| /*empty*/
	| GOESTO goodObject ';'
	;

setActiveToExpected :
	/*empty*/
	;

importSection :
	startIMPORT importItem endIMPORT
	//| startIMPORT error endIMPORT
	;

startIMPORT :
	IMPORT
	;

endIMPORT :
	';'
	;

importItem :
	importSelectorList
	| importSelectorList FROM importSelector
	| importSelectorList AS UNKNOWN_ID
	| importSelectorList FROM importSelector AS UNKNOWN_ID
	| '*' /*9L*/ FROM importSelector
	| importSelectorList AS '*' /*9L*/
	;

importSelectorList :
	beginList importItems
	;

importItems :
	importSelector
	| importItems ',' importSelector
	;

importSelector :
	importId
	;

importId :
	UNKNOWN_ID
	| '$'
	| HASH_DOLLAR
	| '^' /*10L*/
	| importId '.' /*13L*/ UNKNOWN_ID
	| importId '.' /*13L*/ '^' /*10L*/
	;

defineType :
	typeDef
	| setType
	| explicitDatasetType
	| explicitDictionaryType
	| ROW
	| transformType
	;

explicitDatasetType :
	explicitDatasetType1
	| GROUPED explicitDatasetType1
	;

explicitDatasetType1 :
	DATASET
	| DATASET '(' /*14L*/ recordDef childDatasetOptions ')'
	| _ARRAY_ explicitDatasetType
	| LINKCOUNTED explicitDatasetType
	| STREAMED explicitDatasetType
	| EMBEDDED explicitDatasetType
	| userTypedefDataset
	;

explicitDictionaryType :
	DICTIONARY
	| DICTIONARY '(' /*14L*/ recordDef ')'
	| LINKCOUNTED explicitDictionaryType
	| userTypedefDictionary
	;

explicitRowType :
	explicitRowType1
	| LINKCOUNTED explicitRowType1
	;

explicitRowType1 :
	ROW
	| ROW '(' /*14L*/ recordDef ')'
	;

transformType :
	TRANSFORM '(' /*14L*/ recordDef ')'
	| TRANSFORM '(' /*14L*/ dataSet ')'
	;

propType :
	simpleType
	| scopeFlag simpleType
	| scopeFlag
	;

paramType :
	typeDef
	| DATASET_ID
	| moduleScopeDot DATASET_ID leaveScope
	| abstractDataset
	| explicitDatasetType
	| explicitDictionaryType
	| explicitRowType
	| abstractModule
	| patternParamType
	| VIRTUAL RECORD
	;

patternParamType :
	TOK_PATTERN
	| RULE
	| TOKEN
	;

object :
	goodObject
	//| badObject
	;

goodObject :
	dataSet
	| dictionary
	| expression
	| dataRow
	| recordDef
	| service
	| action
	| transformDef
	| transform
	| complexType
	| macro
	| embedBody
	| eventObject
	| compoundAttribute
	| abstractModule
	| goodTypeObject optFieldAttrs
	| enumDef
	| enumTypeId
	| setOfDatasets
	| anyFunction
	| fieldSelectedFromRecord
	| __SEQUENCE__
	| DEFINE goodObject
	| INLINE goodObject
	;

goodTypeObject :
	setType
	| simpleType
	| alienTypeInstance
	| userTypedefType
	| RULE TYPE '(' /*14L*/ recordDef ')'
	| explicitDatasetType
	| explicitDictionaryType
	;

//badObject :
//	error
//	;

macro :
	MACRO
	| COMPLEX_MACRO
	;

embedBody :
	CPPBODY
	| embedPrefix CPPBODY
	| embedCppPrefix CPPBODY
	| EMBED '(' /*14L*/ abstractModule ',' expression attribs ')'
	| IMPORT '(' /*14L*/ abstractModule ',' expression attribs ')'
	;

embedPrefix :
	EMBED '(' /*14L*/ abstractModule attribs ')'
	;

embedCppPrefix :
	EMBED '(' /*14L*/ TOK_CPP attribs ')'
	;

compoundAttribute :
	startCompoundAttribute optDefinitions returnAction ';' END
	;

startCompoundAttribute :
	FUNCTION
	;

returnAction :
	RETURN goodObject
	;

compoundModule :
	startCompoundModule moduleBase moduleDefinitions END
	| PROJECT '(' /*14L*/ abstractModule ',' abstractModule scopeProjectOpts ')'
	;

startCompoundModule :
	MODULE
	| INTERFACE
	;

moduleDefinitions :
	/*empty*/
	| moduleDefinitions moduleDefinition
	;

moduleBase :
	'(' /*14L*/ abstractModuleList ')' moduleOptions
	| moduleOptions
	;

moduleOptions :
	%prec LOWEST_PRECEDENCE /*1L*/ /*empty*/
	| moduleOptions ',' moduleOption
	;

moduleOption :
	__NOSTREAMING__
	| INTERFACE
	| VIRTUAL
	| FORWARD
	| LIBRARY '(' /*14L*/ scopeFunction ')'
	;

abstractModuleList :
	abstractModuleItem
	| abstractModuleList ',' abstractModuleItem
	;

abstractModuleItem :
	abstractModule
	;

complexType :
	startTYPE definitions END
	| startTYPE END
	;

startTYPE :
	TYPE
	;

defineid :
	UNKNOWN_ID
	| SCOPE_ID
	| recordDef
	| TRANSFORM_ID
	| TYPE_ID
	| defineType knownOrUnknownId
	| globalScopedDatasetId knownOrUnknownId
	| UNKNOWN_ID UNKNOWN_ID
	;

knownOrUnknownId :
	UNKNOWN_ID
	| knownId
	| knownFunction1
	;

knownId :
	DATAROW_ID
	| DATASET_ID
	| DICTIONARY_ID
	| VALUE_ID
	| ACTION_ID
	| RECORD_ID
	| ALIEN_ID
	| TYPE_ID
	| TRANSFORM_ID
	| FEATURE_ID
	| SCOPE_ID
	| PATTERN_ID
	| LIST_DATASET_ID
	;

knownFunction1 :
	DATAROW_FUNCTION
	| DATASET_FUNCTION
	| DICTIONARY_FUNCTION
	| VALUE_FUNCTION
	| ACTION_FUNCTION
	| PATTERN_FUNCTION
	| EVENT_FUNCTION
	| TRANSFORM_FUNCTION
	| LIST_DATASET_FUNCTION
	;

scopeFlag :
	EXPORT
	| SHARED
	| LOCAL
	| EXPORT VIRTUAL
	| SHARED VIRTUAL
	;

defineidWithOptScope :
	defineid
	| scopeFlag defineid
	;

definePatternIdWithOptScope :
	definePatternId
	| scopeFlag definePatternId
	;

definePatternId :
	TOK_PATTERN knownOrUnknownId
	| RULE knownOrUnknownId
	| RULE '(' /*14L*/ recordDef ')' knownOrUnknownId
	| TOKEN knownOrUnknownId
	| userTypedefPattern knownOrUnknownId
	;

optDefinitions :
	/*empty*/
	| optDefinitions definition
	;

definitions :
	definition
	| definitions definition
	;

attributeDefinition :
	DEFINITIONS_MACRO definition
	| moduleScopeDot DEFINITIONS_MACRO leaveScope definition
	| defineidWithOptScope parmdef ASSIGN object optfailure ';'
	| definePatternIdWithOptScope parmdef featureParameters ASSIGN pattern optfailure ';'
	| defineFeatureIdWithOptScope ';'
	| defineFeatureIdWithOptScope ASSIGN featureDefine ';'
	;

definition :
	simpleDefinition
	| ';'
	;

simpleDefinition :
	attributeDefinition
	| query ';'
	//| error ';'
	| importSection
	| metaCommandWithNoSemicolon simpleDefinition
	;

metaCommandWithNoSemicolon :
	setMetaCommand
	;

moduleDefinition :
	defineidWithOptScope parmdef ';'
	| definition
	;

setMetaCommand :
	HASH_OPTION '(' /*14L*/ expression ',' expression ')'
	| HASH_WORKUNIT '(' /*14L*/ expression ',' expression ')'
	| HASH_STORED '(' /*14L*/ expression ',' hashStoredValue ')'
	| HASH_CONSTANT '(' /*14L*/ expression ',' hashStoredValue ')'
	| HASH_LINK '(' /*14L*/ expression ')'
	| HASH_ONWARNING '(' /*14L*/ expression ',' warningAction ')'
	| HASH_WEBSERVICE '(' /*14L*/ hintList ')'
	;

hashStoredValue :
	expression
	| dataSet
	| dataRow
	;

optfailure :
	':' failclause
	| /*empty*/
	;

failclause :
	failure
	| failclause ',' failure
	;

failure :
	FAILURE '(' /*14L*/ action commaIndependentOptions ')'
	| SUCCESS '(' /*14L*/ action commaIndependentOptions ')'
	| RECOVERY '(' /*14L*/ action ')'
	| RECOVERY '(' /*14L*/ action ',' expression ')'
	| WHEN '(' /*14L*/ event ')'
	| WHEN '(' /*14L*/ event ',' COUNT '(' /*14L*/ expression ')' ')'
	| PRIORITY '(' /*14L*/ expression ')'
	| PERSIST '(' /*14L*/ expression ')'
	| PERSIST '(' /*14L*/ expression ',' persistOpts ')'
	| PERSIST '(' /*14L*/ expression ',' expression optPersistOpts ')'
	| CRITICAL '(' /*14L*/ expression commaIndependentOptions ')'
	| STORED '(' /*14L*/ startStoredAttrs expression ',' fewMany optStoredFieldFormat ')'
	| STORED '(' /*14L*/ startStoredAttrs expression optStoredFieldFormat ')'
	| CHECKPOINT '(' /*14L*/ constExpression ')'
	| GLOBAL
	| GLOBAL '(' /*14L*/ fewMany ')'
	| GLOBAL '(' /*14L*/ expression optFewMany ')'
	| INDEPENDENT
	| INDEPENDENT '(' /*14L*/ independentOptions ')'
	| INDEPENDENT '(' /*14L*/ expression commaIndependentOptions ')'
	| DEFINE '(' /*14L*/ stringConstExpr ')'
	| DEPRECATED
	| DEPRECATED '(' /*14L*/ stringConstExpr ')'
	| SECTION '(' /*14L*/ constExpression sectionArguments ')'
	| ONWARNING '(' /*14L*/ constExpression ',' warningAction ')'
	| LABELED '(' /*14L*/ expression ')'
	| ONCE
	| ONCE '(' /*14L*/ fewMany ')'
	;

warningAction :
	TOK_LOG
	| TOK_IGNORE
	| TOK_WARNING
	| TOK_ERROR
	| FAIL
	;

optPersistOpts :
	/*empty*/
	| ',' persistOpts
	;

persistOpts :
	persistOpt
	| persistOpts ',' persistOpt
	;

persistOpt :
	fewMany
	| expireAttr
	| queueAttr
	| REFRESH '(' /*14L*/ expression ')'
	| SINGLE
	| MULTIPLE
	| MULTIPLE '(' /*14L*/ expression ')'
	| LABEL '(' /*14L*/ constExpression ')'
	;

optStoredFieldFormat :
	/*empty*/
	| ',' FORMAT_ATTR '(' /*14L*/ hintList ')'
	;

globalOpts :
	/*empty*/
	| ',' globalOpts2
	;

globalOpts2 :
	globalOpt
	| globalOpts2 ',' globalOpt
	;

globalOpt :
	FEW
	| MANY
	| OPT
	;

optFewMany :
	/*empty*/
	| ',' FEW
	| ',' MANY
	;

independentOptions :
	independentOption
	| independentOptions ',' independentOption
	;

commaIndependentOptions :
	/*empty*/
	| commaIndependentOptions ',' independentOption
	;

independentOption :
	fewMany
	| LABEL '(' /*14L*/ constExpression ')'
	;

fewMany :
	FEW
	| MANY
	;

optKeyedDistributeAttrs :
	/*empty*/
	| ',' keyedDistributeAttribute optKeyedDistributeAttrs
	;

keyedDistributeAttribute :
	FIRST
	| hintAttribute
	;

optDistributeAttrs :
	/*empty*/
	| ',' distributeAttribute optDistributeAttrs
	;

distributeAttribute :
	PULLED
	| hintAttribute
	| MERGE_ATTR '(' /*14L*/ beginList sortList ')'
	;

transformDef :
	startTransform transformOptions transformations END
	| startTransform transformOptions END
	;

transform :
	TRANSFORM_ID
	| moduleScopeDot TRANSFORM_ID leaveScope
	| transformFunction '(' /*14L*/ actualParameters ')'
	| startInlineTransform transformOptions semiComma transformations ')'
	| TRANSFORM '(' /*14L*/ dataRow ')'
	| startCompoundExpression beginInlineFunctionToken optDefinitions RETURN transform ';' endInlineFunctionToken
	| VALUE_MACRO /*2L*/ transform ENDMACRO
	| moduleScopeDot VALUE_MACRO /*2L*/ leaveScope transform ENDMACRO
	;

startInlineTransform :
	TRANSFORM '(' /*14L*/ recordDef
	;

opt_join_transform_flags :
	',' transform optJoinFlags
	| optJoinFlags
	;

startTransform :
	TRANSFORM
	;

transformOptions :
	/*empty*/
	| transformOptions semiComma transformOption
	;

transformOption :
	SKIP '(' /*14L*/ booleanExpr ')'
	;

transformations :
	transformation
	| transformations semiComma transformation
	| transformations semiComma
	;

transformation :
	transformPrefix transformation1
	;

transformPrefix :
	/*empty*/
	| transformPrefixList
	;

transformPrefixList :
	transformPrefixItem
	| transformPrefixList transformPrefixItem
	| transformPrefixList ';'
	;

transformPrefixItem :
	DEFINITIONS_MACRO
	| moduleScopeDot DEFINITIONS_MACRO leaveScope
	| defineTransformObject
	| conditionalAttributeAssignment ';'
	| importSection
	;

conditionalAttributeAssignment :
	IF expression THEN conditionalAssignments conditionalAssignmentElseClause
	;

conditionalAssignments :
	beginConditionalScope transformPrefix
	;

beginConditionalScope :
	/*empty*/
	;

conditionalAssignmentElseClause :
	END
	| ELSE conditionalAssignments END
	| ELSEIF expression THEN conditionalAssignments conditionalAssignmentElseClause
	;

defineTransformObject :
	beginDefineTransformObject parmdef ASSIGN object optfailure ';'
	;

beginDefineTransformObject :
	defineid
	;

transformation1 :
	transformDst ASSIGN expression
	| transformDst ASSIGN dataRow
	| transformDst ASSIGN dataSet
	| transformDst ASSIGN dictionary
	//| transformDst ASSIGN error ';'
	| assertAction
	;

transformDst :
	transformDstRecord leaveScope
	| transformDstRecord '.' /*13L*/ transformDstField
	;

transformDstRecord :
	startSelf
	| transformDstRecord '.' /*13L*/ transformDstSelect
	| transformDstRecord '.' /*13L*/ transformDstSelect leaveScope '[' /*15L*/ expression ']'
	;

startSelf :
	SELF
	;

transformDstSelect :
	DATAROW_ID
	| RECORD_ID
	| DATASET_ID
	| DICTIONARY_ID
	;

transformDstField :
	VALUE_ID leaveScope
	| VALUE_ID leaveScope '[' /*15L*/ expression ']'
	| startPointerToMember leaveScope VALUE_ID_REF endPointerToMember
	;

dotScope :
	dataSet '.' /*13L*/
	| SELF '.' /*13L*/
	| dataRow '.' /*13L*/
	| enumTypeId '.' /*13L*/
	;

recordScope :
	globalRecordId '.' /*13L*/
	| recordScope DATAROW_ID '.' /*13L*/
	| recordScope DATASET_ID '.' /*13L*/
	;

simpleRecord :
	recordScope DATAROW_ID leaveScope
	| globalRecordId
	;

globalRecordId :
	RECORD_ID
	| moduleScopeDot RECORD_ID leaveScope
	| recordFunction '(' /*14L*/ actualParameters ')'
	;

semiComma :
	';'
	| ','
	;

actionlist :
	action
	| actionlist semiComma action
	;

sequentialActionlist :
	sequentialAction
	| sequentialActionlist semiComma sequentialAction
	;

sequentialAction :
	action
	| expression
	;

action :
	actionStmt
	| setMetaCommand
	;

actionStmt :
	scopedActionId
	| LOADXML '(' /*14L*/ expression ')'
	| LOADXML '(' /*14L*/ expression ',' expression ')'
	| UPDATE '(' /*14L*/ startLeftSeqFilter ',' transform ')' endSelectorSequence
	| BUILD '(' /*14L*/ startTopFilter startDistributeAttrs ',' ',' thorFilenameOrList optBuildFlags ')' endTopFilter
	| BUILD '(' /*14L*/ startTopFilter startDistributeAttrs ',' indexRecordDef ',' thorFilenameOrList optBuildFlags ')' endTopFilter endIndexScope
	| BUILD '(' /*14L*/ startTopFilter startDistributeAttrs ',' indexRecordDef ',' nullRecordDef ',' thorFilenameOrList optBuildFlags ')' endTopFilter endIndexScope
	| BUILD '(' /*14L*/ startTopFilter startDistributeAttrs optBuildFlags ')' endTopFilter
	| OUTPUT '(' /*14L*/ startTopFilter ',' optRecordDef endTopFilter optOutputFlags ')'
	| OUTPUT '(' /*14L*/ startTopFilter ',' optRecordDef endTopFilter ',' pipe optCommonAttrs ')'
	| OUTPUT '(' /*14L*/ startTopFilter optOutputWuFlags ')' endTopFilter
	| OUTPUT '(' /*14L*/ expression optOutputWuFlags ')'
	| OUTPUT '(' /*14L*/ dictionary optOutputWuFlags ')'
	| OUTPUT '(' /*14L*/ dataRow optOutputWuFlags ')'
	| APPLY '(' /*14L*/ startTopFilter ',' applyActions ')' endTopFilter
	| IF '(' /*14L*/ booleanExpr ',' action ',' action ')'
	| IF '(' /*14L*/ booleanExpr ',' action ')'
	| IFF '(' /*14L*/ booleanExpr ',' action ',' action ')'
	| IFF '(' /*14L*/ booleanExpr ',' action ')'
	| MAP '(' /*14L*/ mapActionSpec ',' action ')'
	| MAP '(' /*14L*/ mapActionSpec ')'
	| CASE '(' /*14L*/ expression ',' beginList caseActionSpec ',' action ')'
	| CASE '(' /*14L*/ expression ',' beginList caseActionSpec ')'
	| CASE '(' /*14L*/ expression ',' beginList action ')'
	| WAIT '(' /*14L*/ event ')'
	| WAIT '(' /*14L*/ event ',' IF '(' /*14L*/ booleanExpr ')' ')'
	| NOTIFY '(' /*14L*/ expression ',' expression ')'
	| NOTIFY '(' /*14L*/ expression ',' expression ',' expression ')'
	| NOTIFY '(' /*14L*/ eventObject ')'
	| NOTIFY '(' /*14L*/ eventObject ',' expression ')'
	| NOFOLD '(' /*14L*/ action ')'
	| NOCOMBINE '(' /*14L*/ action ')'
	| NOTHOR '(' /*14L*/ action ')'
	| failAction
	| SEQUENTIAL '(' /*14L*/ beginList sequentialActionlist optSemiComma ')'
	| PARALLEL '(' /*14L*/ beginList sequentialActionlist optSemiComma ')'
	| ORDERED '(' /*14L*/ beginList sequentialActionlist optSemiComma ')'
	| HTTPorSOAPcall '(' /*14L*/ expression ',' expression ',' recordDef ')'
	| HTTPorSOAPcall '(' /*14L*/ expression ',' expression ',' recordDef ',' soapFlags ')'
	| HTTPorSOAPcall '(' /*14L*/ expression ',' expression ',' recordDef ',' transform ')'
	| HTTPorSOAPcall '(' /*14L*/ expression ',' expression ',' recordDef ',' transform ',' soapFlags ')'
	| HTTPorSOAPcall '(' /*14L*/ startTopLeftSeqFilter ',' expression ',' expression ',' recordDef ')' endTopLeftFilter endSelectorSequence
	| HTTPorSOAPcall '(' /*14L*/ startTopLeftSeqFilter ',' expression ',' expression ',' recordDef ',' soapFlags ')' endTopLeftFilter endSelectorSequence
	| HTTPorSOAPcall '(' /*14L*/ startTopLeftSeqFilter ',' expression ',' expression ',' recordDef ',' transform ')' endTopLeftFilter endSelectorSequence
	| HTTPorSOAPcall '(' /*14L*/ startTopLeftSeqFilter ',' expression ',' expression ',' recordDef ',' transform ',' soapFlags ')' endTopLeftFilter endSelectorSequence
	| KEYDIFF '(' /*14L*/ dataSet ',' dataSet ',' expression keyDiffFlags ')'
	| KEYPATCH '(' /*14L*/ dataSet ',' expression ',' expression keyDiffFlags ')'
	| EVALUATE '(' /*14L*/ expression ')'
	| EVALUATE '(' /*14L*/ dataSet ')'
	| EVALUATE '(' /*14L*/ action ')'
	| EVALUATE '(' /*14L*/ abstractModule ')'
	| EVALUATE '(' /*14L*/ abstractModule ',' knownOrUnknownId ')'
	| DISTRIBUTION '(' /*14L*/ startTopFilter beginList optDistributionFlags ignoreDummyList ')' endTopFilter
	| DISTRIBUTION '(' /*14L*/ startTopFilter beginList ',' sortList optDistributionFlags ')' endTopFilter
	| assertAction
	| GLOBAL '(' /*14L*/ action ')'
	| GLOBAL '(' /*14L*/ action ',' expression ')'
	| OUTPUT '(' /*14L*/ abstractModule ')'
	| OUTPUT '(' /*14L*/ abstractModule ',' abstractModule ')'
	| ALLNODES '(' /*14L*/ beginList actionlist ')'
	| '[' /*15L*/ beginList actionlist ']'
	| OUTPUT '(' /*14L*/ action ')'
	;

failAction :
	FAIL '(' /*14L*/ expression ',' expression ')'
	| FAIL '(' /*14L*/ expression ')'
	| FAIL '(' /*14L*/ ')'
	| FAIL
	| startCompoundExpression beginInlineFunctionToken optDefinitions RETURN action ';' endInlineFunctionToken
	| WHEN '(' /*14L*/ action ',' action sideEffectOptions ')'
	;

assertActions :
	assertAction
	| assertActions ',' assertAction
	;

assertAction :
	TOK_ASSERT '(' /*14L*/ expression assertFlags ')'
	| TOK_ASSERT '(' /*14L*/ expression ',' expression assertFlags ')'
	;

assertFlags :
	/*empty*/
	| ',' FAIL
	| ',' TOK_CONST
	;

indexRecordDef :
	recordDef
	;

optBuildFlags :
	/*empty*/
	| ',' buildFlags
	;

buildFlags :
	buildFlag
	| buildFlag ',' buildFlags
	;

buildFlag :
	OVERWRITE
	| NOOVERWRITE
	| BACKUP
	| NAMED '(' /*14L*/ constExpression ')'
	| DATASET '(' /*14L*/ dataSet ')'
	| commonAttribute
	| SORTED
	| dataSet
	| MERGE_ATTR
	| skewAttribute
	| THRESHOLD '(' /*14L*/ expression ')'
	| FEW
	| PERSIST
	| UPDATE
	| expireAttr
	| bloomAttr
	| hashedIndexAttr
	| NOROOT
	| SORT KEYED
	| SORT ALL
	| planeAttr
	| WIDTH '(' /*14L*/ expression ')'
	| SET '(' /*14L*/ expression ',' expression ')'
	| DISTRIBUTED
	| DISTRIBUTED '(' /*14L*/ expression ')'
	| COMPRESSED '(' /*14L*/ compressMode ')'
	| DEDUP
	| FILEPOSITION optConstBoolArg
	| MAXLENGTH
	| MAXLENGTH '(' /*14L*/ constExpression ')'
	| RESTRICTED
	| expression
	;

localAttribute :
	LOCAL
	| NOLOCAL
	;

bloomAttr :
	BLOOM '(' /*14L*/ beginIndexList sortList optBloomFlags ')' endTopFilter
	;

hashedIndexAttr :
	PARTITION_ATTR '(' /*14L*/ beginIndexList sortList ')' endTopFilter
	;

beginIndexList :
	beginList
	;

endIndexScope :
	/*empty*/
	;

optBloomFlags :
	/*empty*/
	| ',' bloomFlag optBloomFlags
	;

bloomFlag :
	LIMIT '(' /*14L*/ expression ')'
	| PROBABILITY '(' /*14L*/ expression ')'
	;

optCommonAttrs :
	/*empty*/
	| ',' commonAttribute optCommonAttrs
	;

commonAttribute :
	localAttribute
	| hintAttribute
	| orderAttribute
	;

optHintAttribute :
	/*empty*/
	| ',' hintAttribute
	;

hintAttribute :
	HINT '(' /*14L*/ hintList ')'
	;

hintList :
	hintItem
	| hintList ',' hintItem
	;

hintItem :
	hintName
	| hintName '(' /*14L*/ beginList hintExprList ')'
	;

hintName :
	UNKNOWN_ID
	| OUTPUT
	;

hintExprList :
	hintExpr
	| hintExprList ',' hintExpr
	;

hintExpr :
	expression
	| expression DOTDOT expression
	| DOTDOT expression
	| expression DOTDOT
	| UNKNOWN_ID
	;

orderAttribute :
	UNORDERED
	| ORDERED
	| ORDERED '(' /*14L*/ expression ')'
	| PARALLEL
	| PARALLEL '(' /*14L*/ expression ')'
	| STABLE
	| STABLE '(' /*14L*/ expression ')'
	| UNSTABLE
	| UNSTABLE '(' /*14L*/ expression ')'
	| ALGORITHM '(' /*14L*/ expression ')'
	;

optAppendAttrs :
	/*empty*/
	| ',' commonAttribute optCommonAttrs
	| ',' pullAttr optCommonAttrs
	;

pullAttr :
	PULL
	;

expireAttr :
	EXPIRE
	| EXPIRE '(' /*14L*/ expression ')'
	;

optDatasetFlags :
	/*empty*/
	| ',' datasetFlags
	;

datasetFlags :
	datasetFlag
	| datasetFlag ',' datasetFlags
	;

datasetFlag :
	DISTRIBUTED
	| commonAttribute
	;

optIndexFlags :
	/*empty*/
	| startDistributeAttrs ',' indexFlags
	;

indexFlags :
	indexFlag
	| indexFlag ',' indexFlags
	;

indexFlag :
	SORTED
	| STEPPED
	| STEPPED '(' /*14L*/ expressionList ')'
	| lookupOption
	| PRELOAD
	| OPT
	| SORT KEYED
	| SORT ALL
	| REMOTE
	| DISTRIBUTED
	| DISTRIBUTED '(' /*14L*/ expression ')'
	| TOK_FIXED
	| COMPRESSED '(' /*14L*/ compressMode ')'
	| DYNAMIC
	| FILEPOSITION optConstBoolArg
	| MAXLENGTH
	| MAXLENGTH '(' /*14L*/ constExpression ')'
	| bloomAttr
	| hashedIndexAttr
	| commonAttribute
	;

compressMode :
	FIRST
	| LZW
	| ROW
	| constExpression
	;

optOutputFlags :
	/*empty*/
	| ',' outputFlags
	;

outputFlags :
	outputFlag
	| outputFlags ',' outputFlag
	;

outputFlag :
	EXTEND
	| CSV
	| CSV '(' /*14L*/ csvOptions ')'
	| COMPRESSED
	| __COMPRESSED__
	| __GROUPED__
	| OVERWRITE
	| NOOVERWRITE
	| BACKUP
	| PERSIST
	| RESTRICTED
	| XML_TOKEN
	| XML_TOKEN '(' /*14L*/ xmlOptions ')'
	| JSON_TOKEN
	| JSON_TOKEN '(' /*14L*/ xmlOptions ')'
	| UPDATE
	| expireAttr
	| ENCRYPT '(' /*14L*/ expression ')'
	| planeAttr
	| WIDTH '(' /*14L*/ expression ')'
	| commonAttribute
	| __OWNED__
	| thorFilenameOrList
	| FIRST '(' /*14L*/ constExpression ')'
	| THOR
	| NAMED '(' /*14L*/ constExpression ')'
	| STORED
	| NOXPATH
	;

HTTPorSOAPcall :
	HTTPCALL
	| SOAPCALL
	;

httpMarkupOptions :
	httpMarkupOption
	| httpMarkupOptions ',' httpMarkupOption
	;

httpMarkupOption :
	NOROOT
	| HEADING '(' /*14L*/ expression optCommaExpression ')'
	;

soapFlags :
	soapFlag
	| soapFlags ',' soapFlag
	;

soapFlag :
	HEADING '(' /*14L*/ expression optCommaExpression ')'
	| SEPARATOR '(' /*14L*/ expression ')'
	| XPATH '(' /*14L*/ expression ')'
	| XPATH '(' /*14L*/ expression ',' hintList ')'
	| GROUP
	| MERGE '(' /*14L*/ expression ')'
	| RETRY '(' /*14L*/ expression ')'
	| TIMEOUT '(' /*14L*/ expression ')'
	| TIMELIMIT '(' /*14L*/ expression ')'
	| onFailAction
	| TOK_LOG
	| TRIM
	| SOAPACTION '(' /*14L*/ expression ')'
	| HTTPHEADER '(' /*14L*/ expression optCommaExpression ')'
	| PROXYADDRESS '(' /*14L*/ expression optCommaExpression ')'
	| LITERAL
	| ENCODING
	| NAMESPACE '(' /*14L*/ expression ')'
	| NAMESPACE '(' /*14L*/ expression ',' expression ')'
	| RESPONSE '(' /*14L*/ NOTRIM ')'
	| commonAttribute
	| TOK_LOG '(' /*14L*/ MIN ')'
	| TOK_LOG '(' /*14L*/ expression ')'
	| TOK_LOG '(' /*14L*/ expression ',' expression ')'
	| XML_TOKEN
	| XML_TOKEN '(' /*14L*/ httpMarkupOptions ')'
	| FORMENCODED
	| FORMENCODED '(' /*14L*/ expression ')'
	| JSON_TOKEN
	| JSON_TOKEN '(' /*14L*/ httpMarkupOptions ')'
	;

onFailAction :
	ONFAIL '(' /*14L*/ SKIP ')'
	| ONFAIL '(' /*14L*/ transform ')'
	;

queueAttr :
	CLUSTER '(' /*14L*/ stringExpressionList ')'
	| QUEUE '(' /*14L*/ stringExpressionList ')'
	;

planeAttr :
	CLUSTER '(' /*14L*/ stringExpressionList ')'
	| PLANE '(' /*14L*/ stringExpressionList ')'
	;

stringExpressionList :
	expression
	| stringExpressionList ',' expression
	;

expressionList :
	expression
	| expressionList ',' expression
	;

optOutputWuFlags :
	/*empty*/
	| ',' outputWuFlags
	;

outputWuFlags :
	outputWuFlag
	| outputWuFlags ',' outputWuFlag
	;

outputWuFlag :
	ALL
	| XMLNS '(' /*14L*/ expression ',' expression ')'
	| FIRST '(' /*14L*/ constExpression ')'
	| THOR
	| NAMED '(' /*14L*/ constExpression ')'
	| STORED
	| EXTEND
	| OVERWRITE
	| NOOVERWRITE
	| UPDATE
	| NOXPATH
	| commonAttribute
	| MAXSIZE '(' /*14L*/ constExpression ')'
	;

fromXmlOptions :
	/*empty*/
	| fromXmlOptions ',' fromXmlOption
	;

fromXmlOption :
	TRIM
	| ONFAIL '(' /*14L*/ transform ')'
	;

applyActions :
	action
	| applyActions ',' applyOption
	;

applyOption :
	BEFORE '(' /*14L*/ beginList actionlist ')'
	| AFTER '(' /*14L*/ beginList actionlist ')'
	| action
	;

keyDiffFlags :
	/*empty*/
	| keyDiffFlags ',' keyDiffFlag
	;

keyDiffFlag :
	OVERWRITE
	| NOOVERWRITE
	| expireAttr
	| commonAttribute
	;

optRecordDef :
	recordDef
	| /*empty*/
	;

optOpt :
	',' OPT
	| /*empty*/
	;

scopedActionId :
	ACTION_ID
	| moduleScopeDot ACTION_ID leaveScope
	| actionFunction '(' /*14L*/ actualParameters ')'
	| VALUE_MACRO /*2L*/ action ENDMACRO
	| moduleScopeDot VALUE_MACRO /*2L*/ leaveScope action ENDMACRO
	;

eventObject :
	EVENT '(' /*14L*/ expression ',' expression ')'
	| CRON '(' /*14L*/ expression ')'
	| EVENT_ID
	| moduleScopeDot EVENT_ID leaveScope
	| eventFunction '(' /*14L*/ actualParameters ')'
	| startCompoundExpression beginInlineFunctionToken optDefinitions RETURN eventObject ';' endInlineFunctionToken
	;

event :
	eventObject
	| expression
	;

parmdef :
	realparmdef
	| /*empty*/
	;

reqparmdef :
	realparmdef
	;

realparmdef :
	'(' /*14L*/ params ')' functionModifiers
	| '(' /*14L*/ ')' functionModifiers
	;

params :
	param
	| params ',' param
	;

param :
	beginList paramDefinition
	| beginList formalQualifiers paramDefinition
	;

formalQualifiers :
	formalQualifier
	| formalQualifiers formalQualifier
	;

formalQualifier :
	TOK_CONST
	| NOCONST
	| TOK_ASSERT TOK_CONST
	| FIELD_REF
	| FIELDS_REF
	| OPT
	| TOK_OUT
	;

paramDefinition :
	setType UNKNOWN_ID defvalue
	| paramType UNKNOWN_ID defvalue
	| UNKNOWN_ID defvalue
	| anyFunction defvalue
	| ANY DATASET UNKNOWN_ID
	| ANY UNKNOWN_ID defvalue
	| paramType UNKNOWN_ID nestedParmdef defFuncValue
	| setType UNKNOWN_ID nestedParmdef defFuncValue
	| anyFunction UNKNOWN_ID defFuncValue
	;

nestedParmdef :
	beginNestedParamDef params ')'
	| beginNestedParamDef ')'
	;

beginNestedParamDef :
	'(' /*14L*/
	;

defvalue :
	EQ goodObject
	| /*empty*/
	;

defFuncValue :
	/*empty*/
	| EQ anyFunction
	;

functionModifiers :
	/*empty*/
	| VOLATILE
	;

service :
	startService funcDefs END
	//| startService error
	;

startService :
	SERVICE attribs
	;

funcDefs :
	funcDef
	| funcDefs funcDef
	;

funcDef :
	funcRetType knownOrUnknownId realparmdef attribs ';'
	| knownOrUnknownId realparmdef attribs ';'
	;

attribs :
	':' attriblist
	| /*empty*/
	;

attriblist :
	attrib
	| attriblist ',' attrib
	;

attrib :
	knownOrUnknownId EQ UNKNOWN_ID
	| knownOrUnknownId EQ expr %prec reduceAttrib /*5L*/
	| knownOrUnknownId
	| knownOrUnknownId '(' /*14L*/ expr ')'
	| knownOrUnknownId '(' /*14L*/ expr ',' expr ')'
	;

funcRetType :
	TOK_CONST propType
	| propType
	| setType
	| explicitDatasetType
	| explicitRowType
	| explicitDictionaryType
	| transformType
	| recordDef
	| userTypedefType
	;

payloadPart :
	GOESTO fieldDefs optSemiComma
	;

recordDef :
	startrecord fieldDefs optSemiComma endrecord
	| startrecord fieldDefs payloadPart endrecord
	| startrecord recordOptions fieldDefs optSemiComma endrecord
	| startrecord recordOptions fieldDefs payloadPart endrecord
	| startrecord recordBase optFieldDefs endrecord
	| startrecord recordBase optFieldDefs payloadPart endrecord
	| startrecord recordBase recordOptions optFieldDefs endrecord
	| startrecord recordBase recordOptions optFieldDefs payloadPart endrecord
	| simpleRecord
	| recordDef AND /*4L*/ recordDef
	| recordDef OR /*3L*/ recordDef
	| recordDef '-' /*8L*/ recordDef
	| recordDef '-' /*8L*/ UNKNOWN_ID
	| recordDef '-' /*8L*/ '[' /*15L*/ UnknownIdList ']'
	| recordDef AND /*4L*/ NOT /*12L*/ recordDef
	| recordDef AND /*4L*/ NOT /*12L*/ UNKNOWN_ID
	| recordDef AND /*4L*/ NOT /*12L*/ '[' /*15L*/ UnknownIdList ']'
	| RECORDOF '(' /*14L*/ goodObject ')'
	| RECORDOF '(' /*14L*/ dataSet ',' recordDef ',' lookupOption optOpt ')'
	| RECORDOF '(' /*14L*/ dataSet ',' lookupOption ')'
	| RECORDOF '(' /*14L*/ constExpression ',' recordDef ',' lookupOption optOpt ')'
	| RECORDOF '(' /*14L*/ constExpression ',' lookupOption ')'
	| VALUE_MACRO /*2L*/ recordDef ENDMACRO
	| moduleScopeDot VALUE_MACRO /*2L*/ leaveScope recordDef ENDMACRO
	| startCompoundExpression beginInlineFunctionToken optDefinitions RETURN recordDef ';' endInlineFunctionToken
	;

dsRecordDef :
	recordDef
	;

dsEnd :
	')'
	;

UnknownIdList :
	UNKNOWN_ID
	| UnknownIdList ',' UNKNOWN_ID
	;

startrecord :
	RECORD
	| '{'
	;

recordBase :
	'(' /*14L*/ recordDef ')'
	;

recordOptions :
	',' recordOption
	| recordOptions ',' recordOption
	;

recordOption :
	LOCALE '(' /*14L*/ STRING_CONST ')'
	| MAXLENGTH '(' /*14L*/ constExpression ')'
	| MAXSIZE '(' /*14L*/ constExpression ')'
	| PACKED
	;

endrecord :
	endOfRecordMarker
	;

endOfRecordMarker :
	END
	| '}'
	;

abstractDataset :
	VIRTUAL DATASET '(' /*14L*/ recordDef ')'
	| VIRTUAL DATASET
	;

optSemiComma :
	semiComma
	| /*empty*/
	;

optFieldDefs :
	/*empty*/
	| fieldDefs
	| fieldDefs ';'
	| fieldDefs ','
	;

fieldDefs :
	fieldDef
	| fieldDefs ';' fieldDef
	| fieldDefs ',' fieldDef
	;

fieldDef :
	expression
	| DATASET '(' /*14L*/ dataSet ')'
	| VALUE_ID_REF
	| fieldSelectedFromRecord
	| UNKNOWN_ID optFieldAttrs ASSIGN expression
	| UNKNOWN_ID optFieldAttrs ASSIGN dataRow
	| typeDef knownOrUnknownId optFieldAttrs optDefaultValue
	| ANY knownOrUnknownId optFieldAttrs optDefaultValue
	| typeDef knownOrUnknownId '[' /*15L*/ expression ']' optFieldAttrs optDefaultValue
	| setType knownOrUnknownId optFieldAttrs optDefaultValue
	| explicitDatasetType knownOrUnknownId optFieldAttrs optDefaultValue
	| UNKNOWN_ID optFieldAttrs ASSIGN dataSet
	| explicitDictionaryType knownOrUnknownId optFieldAttrs optDefaultValue
	| UNKNOWN_ID optFieldAttrs ASSIGN dictionary
	| alienTypeInstance knownOrUnknownId optFieldAttrs optDefaultValue
	| recordDef
	| dictionary
	| dataSet
	| dataRow
	| ifblock
	//| error
	| expandedSortListByReference
	;

optFieldAttrs :
	/*empty*/
	| '{' '}'
	| '{' fieldAttrs '}'
	;

fieldAttrs :
	fieldAttr
	| fieldAttr ',' fieldAttrs
	;

fieldAttr :
	BLOB
	| CARDINALITY '(' /*14L*/ expression ')'
	| CASE '(' /*14L*/ expression ')'
	| MAXCOUNT '(' /*14L*/ expression ')'
	| CHOOSEN '(' /*14L*/ expression ')'
	| MAXLENGTH '(' /*14L*/ expression ')'
	| MAXSIZE '(' /*14L*/ expression ')'
	| NAMED '(' /*14L*/ expression ')'
	| RANGE '(' /*14L*/ rangeExpr ')'
	| VIRTUAL '(' /*14L*/ LOGICALFILENAME ')'
	| VIRTUAL '(' /*14L*/ FILEPOSITION ')'
	| VIRTUAL '(' /*14L*/ LOCALFILEPOSITION ')'
	| VIRTUAL '(' /*14L*/ SIZEOF ')'
	| XPATH '(' /*14L*/ expression ')'
	| XMLDEFAULT '(' /*14L*/ constExpression ')'
	| DEFAULT '(' /*14L*/ goodObject ')'
	| STRING_CONST
	| STRING_CONST '(' /*14L*/ expression ')'
	| LINKCOUNTED
	| EMBEDDED
	| SET '(' /*14L*/ hintList ')'
	| hintAttribute
	;

ifblock :
	beginIfBlock fieldDefs optSemiComma END
	| beginIfBlock optSemiComma END
	;

beginIfBlock :
	IFBLOCK '(' /*14L*/ booleanExpr ')'
	;

qualifiedTypeId :
	ALIEN_ID
	| moduleScopeDot ALIEN_ID leaveScope
	;

enumTypeId :
	ENUM_ID
	| moduleScopeDot ENUM_ID leaveScope
	;

optParams :
	'(' /*14L*/ actualParameters ')'
	| /*empty*/
	;

optDefaultValue :
	defaultValue
	| /*empty*/
	;

defaultValue :
	ASSIGN expression
	| ASSIGN dataRow
	| ASSIGN dataSet
	| ASSIGN dictionary
	| ASSIGN abstractModule
	;

setType :
	SET
	| SET OF ANY
	| SET OF scalarType
	| SET OF explicitDatasetType
	| userTypedefSet
	;

simpleType :
	SIMPLE_TYPE
	| UNSIGNED
	| PACKED simpleType
	| UNSIGNED SIMPLE_TYPE
	| BIG simpleType
	| LITTLE simpleType
	| ASCII SIMPLE_TYPE
	| EBCDIC SIMPLE_TYPE
	| TYPEOF '(' /*14L*/ goodObject ')'
	;

userTypedefType :
	TYPE_ID
	| moduleScopeDot TYPE_ID leaveScope
	;

userTypedefSet :
	SET_TYPE_ID
	| moduleScopeDot SET_TYPE_ID leaveScope
	;

userTypedefPattern :
	PATTERN_TYPE_ID
	| moduleScopeDot PATTERN_TYPE_ID leaveScope
	;

userTypedefDataset :
	DATASET_TYPE_ID
	| moduleScopeDot DATASET_TYPE_ID leaveScope
	;

userTypedefDictionary :
	DICTIONARY_TYPE_ID
	| moduleScopeDot DICTIONARY_TYPE_ID leaveScope
	;

childDatasetOptions :
	/*empty*/
	| childDatasetOptions ',' childDatasetOption
	;

childDatasetOption :
	COUNT '(' /*14L*/ expression ')'
	| SIZEOF '(' /*14L*/ expression ')'
	| LENGTH '(' /*14L*/ expression ')'
	| CHOOSEN '(' /*14L*/ expression ')'
	;

typeDef :
	scalarType
	| recordDef
	;

scalarType :
	simpleType
	| userTypedefType
	| enumTypeId
	;

query :
	expression optfailure
	| dataSet optfailure
	| dictionary optfailure
	| dataRow optfailure
	| action optfailure
	| BUILD '(' /*14L*/ scopeFunction ')'
	;

optCommaExpression :
	/*empty*/
	| ',' expression
	;

optExpression :
	/*empty*/
	| expression
	;

optConstBoolArg :
	/*empty*/
	| '(' /*14L*/ expression ')'
	;

booleanExpr :
	expression
	;

constExpression :
	expression
	;

expression :
	scalarExpression
	| startCompoundExpression beginInlineFunctionToken optDefinitions RETURN expression ';' endInlineFunctionToken
	;

startCompoundExpression :
	'@'
	;

beginInlineFunctionToken :
	FUNCTION
	| '{'
	;

endInlineFunctionToken :
	END
	| '}'
	;

optCondList :
	/*empty*/
	| condList
	;

condList :
	booleanExpr
	| condList ',' booleanExpr
	;

chooseList :
	chooseItem
	| chooseList ',' chooseItem
	;

chooseItem :
	expression
	;

scalarExpression :
	compareExpr
	| NOT /*12L*/ scalarExpression
	| scalarExpression AND /*4L*/ scalarExpression
	| scalarExpression OR /*3L*/ scalarExpression
	| WITHIN dataSet
	;

heterogeneous_expr_list :
	heterogeneous_expr_list_open
	;

heterogeneous_expr_list_open :
	expression
	| heterogeneous_expr_list_open ',' expression
	;

compareExpr :
	expr compareOp expr
	| expr BETWEEN expr AND /*4L*/ expr
	| expr NOT /*12L*/ BETWEEN expr AND /*4L*/ expr
	| expr NOT /*12L*/ TOK_IN expr
	| expr TOK_IN expr
	| expr NOT /*12L*/ TOK_IN dictionary
	| dataRow NOT /*12L*/ TOK_IN dictionary
	| expr TOK_IN dictionary
	| dataRow TOK_IN dictionary
	| dataSet EQ dataSet
	| dataSet NE dataSet
	| dataRow EQ dataRow
	| dataRow NE dataRow
	| expr
	;

compareOp :
	EQ
	| NE
	| LE
	| GE
	| LT
	| GT
	;

expr :
	primexpr
	| expr '+' /*8L*/ expr
	| expr '-' /*8L*/ expr
	| expr ORDER /*6L*/ expr
	| expr '*' /*9L*/ expr
	| expr '/' /*9L*/ expr
	| expr '%' /*9L*/ expr
	| expr DIV /*9L*/ expr
	| expr SHIFTL /*7L*/ expr
	| expr SHIFTR /*7L*/ expr
	| expr '&' /*11L*/ expr
	| expr '|' /*10L*/ expr
	| expr '^' /*10L*/ expr
	;

rangeOrIndices :
	rangeExpr
	;

rangeExpr :
	expression
	| expression DOTDOT expression
	| DOTDOT expression
	| expression DOTDOT
	| expression DOTDOT '*' /*9L*/
	| /*empty*/
	;

primexpr :
	primexpr1
	| '-' /*8L*/ primexpr
	| '+' /*8L*/ primexpr
	| BNOT primexpr
	| '(' /*14L*/ scalarType ')' primexpr
	| '(' /*14L*/ setType ')' primexpr
	| transfer primexpr
	;

primexpr1 :
	atomicValue
	| primexpr1 '[' /*15L*/ rangeOrIndices ']'
	| primexpr1 '[' /*15L*/ NOBOUNDCHECK rangeOrIndices ']'
	| '(' /*14L*/ expression ')'
	| COUNT '(' /*14L*/ startTopFilter aggregateFlags ')' endTopFilter
	| COUNT '(' /*14L*/ GROUP optExtraFilter ')'
	| COUNT '(' /*14L*/ SORTLIST_ID ')'
	| COUNT '(' /*14L*/ dictionary ')'
	| CHOOSE '(' /*14L*/ expression ',' chooseList ')'
	| EXISTS '(' /*14L*/ GROUP optExtraFilter ')'
	| EXISTS '(' /*14L*/ dataSet aggregateFlags ')'
	| EXISTS '(' /*14L*/ dictionary ')'
	| MAP '(' /*14L*/ mapSpec ',' expression ')'
	| CASE '(' /*14L*/ expression ',' beginList caseSpec ',' expression ')'
	| CASE '(' /*14L*/ expression ',' beginList expression ')'
	| IF '(' /*14L*/ booleanExpr ',' expression ',' expression ')'
	| IFF '(' /*14L*/ booleanExpr ',' expression ',' expression ')'
	| EXP '(' /*14L*/ expression ')'
	| HASH '(' /*14L*/ beginList sortList ')'
	| HASH32 '(' /*14L*/ beginList sortList ')'
	| HASH64 '(' /*14L*/ beginList sortList ')'
	| HASHMD5 '(' /*14L*/ beginList sortList ')'
	| CRC '(' /*14L*/ beginList sortList ')'
	| ECLCRC '(' /*14L*/ goodObject ')'
	| ECLCRC '(' /*14L*/ goodObject ',' PARSE ')'
	| LN '(' /*14L*/ expression ')'
	| SIN '(' /*14L*/ expression ')'
	| COS '(' /*14L*/ expression ')'
	| TAN '(' /*14L*/ expression ')'
	| ASIN '(' /*14L*/ expression ')'
	| ACOS '(' /*14L*/ expression ')'
	| ATAN '(' /*14L*/ expression ')'
	| ATAN2 '(' /*14L*/ expression ',' expression ')'
	| SINH '(' /*14L*/ expression ')'
	| COSH '(' /*14L*/ expression ')'
	| TANH '(' /*14L*/ expression ')'
	| GLOBAL '(' /*14L*/ expression globalOpts ')'
	| TOK_LOG '(' /*14L*/ expression ')'
	| POWER '(' /*14L*/ expression ',' expression ')'
	| RANDOM '(' /*14L*/ ')'
	| ROUND '(' /*14L*/ expression ')'
	| ROUND '(' /*14L*/ expression ',' expression ')'
	| ROUNDUP '(' /*14L*/ expression ')'
	| SQRT '(' /*14L*/ expression ')'
	| TRUNCATE '(' /*14L*/ expression ')'
	| LENGTH '(' /*14L*/ expression ')'
	| TRIM '(' /*14L*/ expression optTrimFlags ')'
	| NOFOLD '(' /*14L*/ expression ')'
	| NOCOMBINE '(' /*14L*/ expression ')'
	| NOHOIST '(' /*14L*/ expression ')'
	| NOTHOR '(' /*14L*/ expression ')'
	| ABS '(' /*14L*/ expression ')'
	| INTFORMAT '(' /*14L*/ expression ',' expression ',' expression ')'
	| REALFORMAT '(' /*14L*/ expression ',' expression ',' expression ')'
	| TOXML '(' /*14L*/ dataRow ')'
	| TOJSON '(' /*14L*/ dataRow ')'
	| REGEXFIND '(' /*14L*/ expression ',' expression regexOpt ')'
	| REGEXFIND '(' /*14L*/ expression ',' expression ',' expression regexOpt ')'
	| REGEXFINDSET '(' /*14L*/ expression ',' expression regexOpt ')'
	| REGEXREPLACE '(' /*14L*/ expression ',' expression ',' expression regexOpt ')'
	| ASSTRING '(' /*14L*/ expression ')'
	| TRANSFER '(' /*14L*/ expression ',' scalarType ')'
	| TRANSFER '(' /*14L*/ dataRow ',' scalarType ')'
	| TRANSFER '(' /*14L*/ dataSet ',' scalarType ')'
	| MAX '(' /*14L*/ startTopFilter ',' expression aggregateFlags ')' endTopFilter
	| MAX '(' /*14L*/ GROUP ',' expression ')'
	| MIN '(' /*14L*/ startTopFilter ',' expression aggregateFlags ')' endTopFilter
	| MIN '(' /*14L*/ GROUP ',' expression ')'
	| EVALUATE '(' /*14L*/ evaluateTopFilter ',' expression ')' endTopFilter
	| SUM '(' /*14L*/ startTopFilter ',' expression aggregateFlags ')' endTopFilter
	| SUM '(' /*14L*/ GROUP ',' expression optExtraFilter ')'
	| AVE '(' /*14L*/ startTopFilter ',' expression aggregateFlags ')' endTopFilter
	| AVE '(' /*14L*/ GROUP ',' expression optExtraFilter ')'
	| VARIANCE '(' /*14L*/ startTopFilter ',' expression aggregateFlags ')' endTopFilter
	| VARIANCE '(' /*14L*/ GROUP ',' expression optExtraFilter ')'
	| COVARIANCE '(' /*14L*/ startTopFilter ',' expression ',' expression aggregateFlags ')' endTopFilter
	| COVARIANCE '(' /*14L*/ GROUP ',' expression ',' expression optExtraFilter ')'
	| CORRELATION '(' /*14L*/ startTopFilter ',' expression ',' expression aggregateFlags ')' endTopFilter
	| CORRELATION '(' /*14L*/ GROUP ',' expression ',' expression optExtraFilter ')'
	| WHICH '(' /*14L*/ optCondList ')'
	| REJECTED '(' /*14L*/ optCondList ')'
	| SIZEOF '(' /*14L*/ sizeof_type_target optMaxMin ')'
	| SIZEOF '(' /*14L*/ sizeof_expr_target optMaxMin ')'
	//| SIZEOF '(' /*14L*/ error ')'
	| RANK '(' /*14L*/ expression ',' expression optAscDesc ')'
	| RANKED '(' /*14L*/ expression ',' expression optAscDesc ')'
	| COUNT
	| COUNTER
	| ISNULL '(' /*14L*/ expression ')'
	| ISVALID '(' /*14L*/ expression ')'
	| OMITTED '(' /*14L*/ goodObject ')'
	| FAILCODE
	| FAILCODE '(' /*14L*/ ')'
	| FAILMESSAGE
	| FAILMESSAGE '(' /*14L*/ ')'
	| FAILMESSAGE '(' /*14L*/ expression ')'
	| EVENTNAME
	| EVENTNAME '(' /*14L*/ ')'
	| EVENTEXTRA
	| EVENTEXTRA '(' /*14L*/ ')'
	| EVENTEXTRA '(' /*14L*/ expression ')'
	| TOK_ERROR '(' /*14L*/ expression ',' expression ')'
	| TOK_ERROR '(' /*14L*/ expression ')'
	| TOK_ERROR '(' /*14L*/ ')'
	| FAIL '(' /*14L*/ scalarType ',' expression ',' expression ')'
	| FAIL '(' /*14L*/ scalarType ',' expression ')'
	| FAIL '(' /*14L*/ scalarType ')'
	| SKIP
	| FROMUNICODE '(' /*14L*/ expression ',' expression ')'
	| TOUNICODE '(' /*14L*/ expression ',' expression ')'
	| KEYUNICODE '(' /*14L*/ expression ')'
	| KEYUNICODE '(' /*14L*/ expression ',' expression ')'
	| KEYUNICODE '(' /*14L*/ expression ',' ',' expression ')'
	| KEYUNICODE '(' /*14L*/ expression ',' expression ',' expression ')'
	| MATCHED '(' /*14L*/ patternReference ')'
	| MATCHED '(' /*14L*/ dataRow ')'
	| MATCHED '(' /*14L*/ dataSet ')'
	| MATCHTEXT '(' /*14L*/ patternReference ')'
	| MATCHUNICODE '(' /*14L*/ patternReference ')'
	| MATCHUTF8 '(' /*14L*/ patternReference ')'
	| MATCHLENGTH '(' /*14L*/ patternReference ')'
	| MATCHPOSITION '(' /*14L*/ patternReference ')'
	| MATCHED
	| MATCHTEXT
	| MATCHUNICODE
	| MATCHUTF8
	| MATCHLENGTH
	| MATCHPOSITION
	| MATCHED '(' /*14L*/ ')'
	| MATCHTEXT '(' /*14L*/ ')'
	| MATCHUNICODE '(' /*14L*/ ')'
	| MATCHUTF8 '(' /*14L*/ ')'
	| MATCHLENGTH '(' /*14L*/ ')'
	| MATCHPOSITION '(' /*14L*/ ')'
	| MATCHTEXT '(' /*14L*/ expression ')'
	| MATCHUNICODE '(' /*14L*/ expression ')'
	| MATCHUTF8 '(' /*14L*/ expression ')'
	| MATCHTEXT '(' /*14L*/ dataRow ')'
	| MATCHUNICODE '(' /*14L*/ dataRow ')'
	| MATCHUTF8 '(' /*14L*/ dataRow ')'
	| ROWDIFF '(' /*14L*/ dataRow ',' dataRow optCount ')'
	| WORKUNIT
	| XMLDECODE '(' /*14L*/ expression ')'
	| XMLENCODE '(' /*14L*/ expression xmlEncodeFlags ')'
	| XMLTEXT '(' /*14L*/ expression ')'
	| XMLUNICODE '(' /*14L*/ expression ')'
	| KEYED '(' /*14L*/ expression ')'
	| KEYED '(' /*14L*/ expression ',' OPT optConstBoolArg ')'
	| STEPPED '(' /*14L*/ expression ')'
	| WILD '(' /*14L*/ expression ')'
	| TOK_CATCH '(' /*14L*/ expression ',' expression ')'
	| __COMPOUND__ '(' /*14L*/ action ',' expression ')'
	| WHEN '(' /*14L*/ expression ',' action sideEffectOptions ')'
	| __COMMON__ '(' /*14L*/ expression ')'
	| CLUSTERSIZE
	| CHOOSENALL
	| WORKUNIT '(' /*14L*/ expression ',' simpleType ')'
	| LOCAL '(' /*14L*/ expression ')'
	| NOLOCAL '(' /*14L*/ expression ')'
	| THISNODE '(' /*14L*/ expression ')'
	| COUNT '(' /*14L*/ expressionList ')'
	| EXISTS '(' /*14L*/ expressionList ')'
	| SUM '(' /*14L*/ expressionList ')'
	| MAX '(' /*14L*/ expressionList ')'
	| MIN '(' /*14L*/ expressionList ')'
	| AVE '(' /*14L*/ expressionList ')'
	| NAMEOF '(' /*14L*/ dataSet ')'
	| UNICODEORDER /*6L*/ '(' /*14L*/ expression ',' expression ')'
	| UNICODEORDER /*6L*/ '(' /*14L*/ expression ',' expression ',' expression ')'
	| UNICODEORDER /*6L*/ '(' /*14L*/ expression ',' expression ',' ',' expression ')'
	| UNICODEORDER /*6L*/ '(' /*14L*/ expression ',' expression ',' expression ',' expression ')'
	| LIKELY '(' /*14L*/ booleanExpr ')'
	| LIKELY '(' /*14L*/ booleanExpr ',' expression ')'
	| UNLIKELY '(' /*14L*/ booleanExpr ')'
	| '[' /*15L*/ beginList nonDatasetList ']'
	| '[' /*15L*/ ']'
	| ALL
	| SET '(' /*14L*/ startTopFilter ',' expression ')' endTopFilter
	| GETENV '(' /*14L*/ expression ')'
	| GETENV '(' /*14L*/ expression ',' expression ')'
	| GETSECRET '(' /*14L*/ expression ',' expression ')'
	| __STAND_ALONE__
	| __DEBUG__ '(' /*14L*/ stringConstExpr ')'
	| __DEBUG__ '(' /*14L*/ stringConstExpr ',' simpleType ')'
	| __PLATFORM__
	| __TARGET_PLATFORM__
	;

optCount :
	/*empty*/
	| ',' COUNT
	;

evaluateTopFilter :
	dataRow
	;

alienTypeInstance :
	qualifiedTypeId optParams
	;

sizeof_type_target :
	simpleType
	| setType
	| alienTypeInstance
	;

sizeof_expr_target :
	expression
	| dataSet
	| dataRow
	| enumTypeId
	| recordDef
	| fieldSelectedFromRecord
	;

fieldSelectedFromRecord :
	recordScope VALUE_ID leaveScope
	| recordScope DATASET_ID leaveScope
	| recordScope startPointerToMember leaveScope VALUE_ID_REF endPointerToMember
	;

optMaxMin :
	/*empty*/
	| ',' MAX
	| ',' MIN
	;

beginCounterScope :
	/*empty*/
	;

endCounterScope :
	/*empty*/
	;

optAscDesc :
	/*empty*/
	| ',' DESC
	;

optExtraFilter :
	/*empty*/
	| ',' booleanExpr
	;

regexOpt :
	/*empty*/
	| ',' NOCASE
	;

xmlEncodeFlags :
	/*empty*/
	| ',' ALL
	;

aggregateFlags :
	/*empty*/
	| aggregateFlags ',' aggregateFlag
	;

aggregateFlag :
	KEYED
	| prefetchAttribute
	| hintAttribute
	| orderAttribute
	;

transfer :
	TYPE_LPAREN typeDef TYPE_RPAREN
	;

atomicValue :
	qualifiedFieldName
	| const
	;

moduleScopeDot :
	abstractModule '.' /*13L*/
	| pseudoResolutionScope '.' /*13L*/
	;

pseudoResolutionScope :
	'^' /*10L*/
	| pseudoResolutionScope '^' /*10L*/
	;

abstractModule :
	SCOPE_ID
	| moduleScopeDot SCOPE_ID leaveScope
	| '$'
	| HASH_DOLLAR
	| VALUE_MACRO /*2L*/ abstractModule ENDMACRO
	| moduleScopeDot VALUE_MACRO /*2L*/ leaveScope abstractModule ENDMACRO
	| scopeFunctionWithParameters
	| STORED '(' /*14L*/ abstractModule ')'
	| compoundModule
	| LIBRARY '(' /*14L*/ libraryName ',' scopeFunction ',' actualParameters ')'
	| LIBRARY '(' /*14L*/ libraryName ',' scopeFunctionWithParameters optHintAttribute ')'
	| startCompoundExpression beginInlineFunctionToken optDefinitions RETURN abstractModule ';' endInlineFunctionToken
	| IF '(' /*14L*/ booleanExpr ',' abstractModule ',' abstractModule ')'
	;

scopeFunctionWithParameters :
	scopeFunction '(' /*14L*/ actualParameters ')'
	;

libraryName :
	expression
	| INTERNAL '(' /*14L*/ scopeFunction ')'
	;

leaveScope :
	/*empty*/
	;

scopeProjectOpts :
	/*empty*/
	| scopeProjectOpts ',' scopeProjectOpt
	;

scopeProjectOpt :
	OPT
	| UNKNOWN_ID
	;

qualifiedFieldName :
	dotScope VALUE_ID leaveScope
	| dotScope startPointerToMember leaveScope VALUE_ID_REF endPointerToMember
	| globalValueAttribute
	;

globalValueAttribute :
	VALUE_ID
	| startPointerToMember VALUE_ID_REF endPointerToMember
	| moduleScopeDot VALUE_ID leaveScope
	| VALUE_MACRO /*2L*/ expression ENDMACRO
	| moduleScopeDot VALUE_MACRO /*2L*/ leaveScope expression ENDMACRO
	| valueFunction '(' /*14L*/ actualParameters ')'
	;

dataSetOrRowList :
	dataSetOrRow
	| dataSetOrRowList ',' dataSetOrRow
	;

dataSetOrRow :
	dataSet
	| dataRow
	;

dataRow :
	dataSet '[' /*15L*/ expression ']'
	| dictionary '[' /*15L*/ expressionList ']'
	| dataSet '[' /*15L*/ NOBOUNDCHECK expression ']'
	| dotScope DATAROW_ID leaveScope
	| dotScope RECORD_ID leaveScope
	| moduleScopeDot DATAROW_ID leaveScope
	| datarowFunction '(' /*14L*/ actualParameters ')'
	| simpleDataRow
	| VALUE_MACRO /*2L*/ dataRow ENDMACRO
	| moduleScopeDot VALUE_MACRO /*2L*/ leaveScope dataRow ENDMACRO
	| startCompoundExpression beginInlineFunctionToken optDefinitions RETURN dataRow ';' endInlineFunctionToken
	;

simpleDataRow :
	DATAROW_ID
	| LEFT
	| RIGHT
	| RIGHT_NN
	| IF '(' /*14L*/ booleanExpr ',' dataRow ',' dataRow ')'
	| IF '(' /*14L*/ booleanExpr ',' dataRow ')'
	| IFF '(' /*14L*/ booleanExpr ',' dataRow ',' dataRow ')'
	| IFF '(' /*14L*/ booleanExpr ',' dataRow ')'
	| HTTPorSOAPcall '(' /*14L*/ expression ',' expression ',' expression ',' recordDef ')'
	| HTTPorSOAPcall '(' /*14L*/ expression ',' expression ',' expression ',' recordDef ',' soapFlags ')'
	| HTTPorSOAPcall '(' /*14L*/ expression ',' expression ',' recordDef ',' recordDef ')'
	| HTTPorSOAPcall '(' /*14L*/ expression ',' expression ',' recordDef ',' recordDef ',' soapFlags ')'
	| HTTPorSOAPcall '(' /*14L*/ expression ',' expression ',' recordDef ',' transform ',' recordDef ')'
	| HTTPorSOAPcall '(' /*14L*/ expression ',' expression ',' recordDef ',' transform ',' recordDef ',' soapFlags ')'
	| ROW '(' /*14L*/ inlineDatasetValue ',' recordDef ')'
	| ROW '(' /*14L*/ startLeftSeqRow ',' recordDef ')' endSelectorSequence
	| ROW '(' /*14L*/ startLeftSeqRow ',' transform ')' endSelectorSequence
	| ROW '(' /*14L*/ transform ')'
	| ROW '(' /*14L*/ simpleRecord ')'
	| ROW '(' /*14L*/ dataSet ')'
	| ROW '(' /*14L*/ '[' /*15L*/ ']' ',' simpleRecord ')'
	| PROJECT '(' /*14L*/ startLeftSeqRow ',' transform ')' endSelectorSequence
	| GLOBAL '(' /*14L*/ dataRow globalOpts ')'
	| GLOBAL '(' /*14L*/ dataRow ',' expression globalOpts ')'
	| NOFOLD '(' /*14L*/ dataRow ')'
	| NOCOMBINE '(' /*14L*/ dataRow ')'
	| NOHOIST '(' /*14L*/ dataRow ')'
	| LOCAL '(' /*14L*/ dataRow ')'
	| NOLOCAL '(' /*14L*/ dataRow ')'
	| ALLNODES '(' /*14L*/ beginList dataRow ignoreDummyList ')'
	| THISNODE '(' /*14L*/ dataRow ')'
	| TRANSFER '(' /*14L*/ expression ',' recordDef ')'
	| __COMMON__ '(' /*14L*/ dataRow ')'
	| SKIP '(' /*14L*/ ROW recordDef ')'
	| MATCHROW '(' /*14L*/ patternReference ')'
	| FROMXML '(' /*14L*/ recordDef ',' expression fromXmlOptions ')'
	| FROMJSON '(' /*14L*/ recordDef ',' expression fromXmlOptions ')'
	| WHEN '(' /*14L*/ dataRow ',' action sideEffectOptions ')'
	| MAP '(' /*14L*/ mapDatarowSpec ',' dataRow ')'
	| CASE '(' /*14L*/ expression ',' beginList caseDatarowSpec ',' dataRow ')'
	;

dictionary :
	simpleDictionary
	| dictionary '+' /*8L*/ dictionary
	;

simpleDictionary :
	scopedDictionaryId
	| NOFOLD '(' /*14L*/ dictionary ')'
	| NOCOMBINE '(' /*14L*/ dictionary ')'
	| NOHOIST '(' /*14L*/ dictionary ')'
	| THISNODE '(' /*14L*/ dictionary ')'
	| DICTIONARY '(' /*14L*/ startTopFilter ',' recordDef ')' endTopFilter
	| DICTIONARY '(' /*14L*/ startTopFilter ')' endTopFilter
	| DICTIONARY '(' /*14L*/ '[' /*15L*/ ']' ',' recordDef ')'
	| DICTIONARY '(' /*14L*/ '[' /*15L*/ beginList inlineDatasetValueList ']' ',' recordDef ')'
	| '(' /*14L*/ dictionary ')'
	| IF '(' /*14L*/ booleanExpr ',' dictionary ',' dictionary ')'
	| IF '(' /*14L*/ booleanExpr ',' dictionary ')'
	| IFF '(' /*14L*/ booleanExpr ',' dictionary ',' dictionary ')'
	| IFF '(' /*14L*/ booleanExpr ',' dictionary ')'
	| MAP '(' /*14L*/ mapDictionarySpec ',' dictionary ')'
	| MAP '(' /*14L*/ mapDictionarySpec ')'
	| CASE '(' /*14L*/ expression ',' beginList caseDictionarySpec ',' dictionary ')'
	| CASE '(' /*14L*/ expression ',' beginList caseDictionarySpec ')'
	| CASE '(' /*14L*/ expression ',' beginList dictionary ')'
	| FAIL '(' /*14L*/ dictionary failDatasetParam ')'
	| TOK_ERROR '(' /*14L*/ dictionary failDatasetParam ')'
	| CHOOSE '(' /*14L*/ expression ',' dictionaryList ')'
	;

dictionaryList :
	dictionary
	| dictionary ',' dictionaryList
	;

scopedDictionaryId :
	globalScopedDictionaryId
	| dotScope DICTIONARY_ID leaveScope
	| dictionaryFunction '(' /*14L*/ actualParameters ')'
	;

globalScopedDictionaryId :
	DICTIONARY_ID
	| moduleScopeDot DICTIONARY_ID leaveScope
	;

dataSet :
	simpleDataSet
	| startCompoundExpression beginInlineFunctionToken optDefinitions RETURN dataSet ';' endInlineFunctionToken
	| startSimpleFilter conditions endSimpleFilter
	| dataRow conditions
	| VALUE_MACRO /*2L*/ dataSet ENDMACRO
	| moduleScopeDot VALUE_MACRO /*2L*/ leaveScope dataSet ENDMACRO
	| dataSet '-' /*8L*/ dataSet
	| dataSet '+' /*8L*/ dataSet
	| dataSet '&' /*11L*/ dataSet
	| dataSet ANDAND /*11L*/ dataSet
	| dataSet '+' /*8L*/ dataRow
	| dataSet '&' /*11L*/ dataRow
	| dataSet ANDAND /*11L*/ dataRow
	| dataRow '+' /*8L*/ dataSet
	| dataRow '&' /*11L*/ dataSet
	| dataRow ANDAND /*11L*/ dataSet
	| dataRow '+' /*8L*/ dataRow
	| dataRow '&' /*11L*/ dataRow
	| dataRow ANDAND /*11L*/ dataRow
	| dataSet '[' /*15L*/ expression DOTDOT expression ']'
	| dataSet '[' /*15L*/ DOTDOT expression ']'
	| dataSet '[' /*15L*/ expression DOTDOT ']'
	;

simpleDataSet :
	scopedDatasetId
	| setOfDatasets '[' /*15L*/ expression ']'
	| '(' /*14L*/ '+' /*8L*/ ')' '(' /*14L*/ dataSetOrRowList optAppendAttrs ')'
	| ALIAS '(' /*14L*/ dataSet ')'
	| EBCDIC '(' /*14L*/ startTopFilter ')' endTopFilter
	| ASCII '(' /*14L*/ startTopFilter ')' endTopFilter
	| CHOOSEN '(' /*14L*/ dataSet ',' expression choosenExtra ')'
	| CHOOSESETS '(' /*14L*/ startTopFilter ',' setCountList ')' endTopFilter
	| DEDUP '(' /*14L*/ startTopLeftRightSeqFilter optDedupFlags ')' endTopLeftRightFilter endSelectorSequence
	| DISTRIBUTE '(' /*14L*/ startTopFilter startDistributeAttrs ',' expression optDistributeAttrs ')' endTopFilter
	| DISTRIBUTE '(' /*14L*/ startTopFilter startDistributeAttrs optDistributeAttrs ')' endTopFilter
	| DISTRIBUTE '(' /*14L*/ startTopFilter startDistributeAttrs ',' skewAttribute optDistributeAttrs ')' endTopFilter
	| DISTRIBUTE '(' /*14L*/ startTopFilter startDistributeAttrs ',' PARTITION_ATTR '(' /*14L*/ beginList sortList ')' optDistributeAttrs ')' endTopFilter
	| DISTRIBUTE '(' /*14L*/ startTopFilter startDistributeAttrs ',' startRightDistributeSeqFilter endTopFilter ',' expression optKeyedDistributeAttrs ')' endSelectorSequence
	| DISTRIBUTE '(' /*14L*/ startTopFilter startDistributeAttrs ',' startRightDistributeSeqFilter endTopFilter optKeyedDistributeAttrs ')' endSelectorSequence
	| DISTRIBUTED '(' /*14L*/ startTopFilter ',' expression distributedFlags ')' endTopFilter
	| DISTRIBUTED '(' /*14L*/ startTopFilter ')' endTopFilter
	| PARTITION '(' /*14L*/ startTopFilter ',' startSortOrder beginList sortList ')' endSortOrder endTopFilter
	| JOIN '(' /*14L*/ startLeftDelaySeqFilter ',' startRightFilter ',' expression beginCounterScope opt_join_transform_flags endCounterScope ')' endSelectorSequence
	| MERGEJOIN '(' /*14L*/ startTopLeftRightSeqSetDatasets ',' startLeftRows expression ',' endRowsGroup beginList sortList ')' endTopLeftRightFilter endSelectorSequence
	| JOIN '(' /*14L*/ startTopLeftRightSeqSetDatasets ',' startLeftRows expression ',' transform ',' mergeJoinFlags ')' endRowsGroup endTopLeftRightFilter endSelectorSequence
	| MERGE '(' /*14L*/ startTopLeftRightSeqSetDatasets ',' beginList sortList ')' endTopLeftRightFilter endSelectorSequence
	| PROCESS '(' /*14L*/ startLeftDelaySeqFilter ',' startRightRow ',' beginCounterScope transform ',' transform optCommonAttrs ')' endCounterScope endSelectorSequence
	| ROLLUP '(' /*14L*/ startTopLeftRightSeqFilter ',' expression ',' endTopFilter transform optCommonAttrs ')' endSelectorSequence
	| ROLLUP '(' /*14L*/ startTopLeftRightSeqFilter ',' transform rollupExtra ')' endTopLeftRightFilter endSelectorSequence
	| ROLLUP '(' /*14L*/ startTopLeftRightSeqFilter ',' startLeftRowsGroup ',' transform optCommonAttrs ')' endRowsGroup endTopLeftRightFilter endSelectorSequence
	| COMBINE '(' /*14L*/ startLeftDelaySeqFilter ',' startRightFilter optCommonAttrs ')' endSelectorSequence
	| COMBINE '(' /*14L*/ startLeftDelaySeqFilter ',' startRightFilter ',' transform optCommonAttrs ')' endSelectorSequence
	| COMBINE '(' /*14L*/ startLeftDelaySeqFilter ',' startRightFilter ',' startRightRowsGroup ',' transform optCommonAttrs ')' endRowsGroup endSelectorSequence
	| LOOP '(' /*14L*/ startLeftRowsSeqFilter beginCounterScope ',' expression ',' dataSet endCounterScope loopOptions ')' endRowsGroup endSelectorSequence
	| LOOP '(' /*14L*/ startLeftRowsSeqFilter beginCounterScope ',' expression ',' expression ',' dataSet endCounterScope loopOptions ')' endRowsGroup endSelectorSequence
	| LOOP '(' /*14L*/ startLeftRowsSeqFilter beginCounterScope ',' expression ',' expression ',' expression ',' dataSet endCounterScope loopOptions ')' endRowsGroup endSelectorSequence
	| GRAPH '(' /*14L*/ startLeftRowsSeqFilter beginCounterScope ',' expression ',' dataSet endCounterScope graphOptions ')' endRowsGroup endSelectorSequence
	| GRAPH '(' /*14L*/ startLeftRowsSeqFilter ')' endRowsGroup endSelectorSequence
	| ITERATE '(' /*14L*/ startLeftRightSeqFilter ',' beginCounterScope transform optCommonAttrs ')' endCounterScope endSelectorSequence
	| LIMIT '(' /*14L*/ dataSet ',' expression limitOptions ')'
	| TOK_CATCH '(' /*14L*/ dataSet ',' catchOption optCommonAttrs ')'
	| MERGE '(' /*14L*/ startTopFilter ',' mergeDataSetList ')' endTopFilter
	| COGROUP '(' /*14L*/ startTopFilter ',' cogroupDataSetList ')' endTopFilter
	| NONEMPTY '(' /*14L*/ mergeDataSetList ')'
	| PREFETCH '(' /*14L*/ startLeftSeqFilter endSelectorSequence optPrefetchOptions ')'
	| PROJECT '(' /*14L*/ startLeftSeqFilter ',' beginCounterScope transform endCounterScope projectOptions ')' endSelectorSequence
	| PROJECT '(' /*14L*/ startLeftSeqFilter ',' beginCounterScope recordDef endCounterScope projectOptions ')' endSelectorSequence
	| PULL '(' /*14L*/ startTopFilter ')' endTopFilter
	| TRACE '(' /*14L*/ startTopFilter optTraceFlags ')' endTopFilter
	| DENORMALIZE '(' /*14L*/ startLeftDelaySeqFilter ',' startRightFilter ',' expression ',' beginCounterScope transform endCounterScope optJoinFlags ')' endSelectorSequence
	| DENORMALIZE '(' /*14L*/ startLeftDelaySeqFilter ',' startRightFilter ',' expression ',' beginCounterScope startRightRowsGroup endCounterScope ',' transform optJoinFlags ')' endRowsGroup endSelectorSequence
	| NOFOLD '(' /*14L*/ dataSet ')'
	| NOCOMBINE '(' /*14L*/ dataSet ')'
	| NOHOIST '(' /*14L*/ dataSet ')'
	| NOTHOR '(' /*14L*/ dataSet ')'
	| NORMALIZE '(' /*14L*/ startLeftSeqFilter ',' expression ',' beginCounterScope transform endCounterScope optCommonAttrs ')' endSelectorSequence
	| NORMALIZE '(' /*14L*/ startLeftSeqFilter ',' startRightFilter ',' beginCounterScope transform endCounterScope optCommonAttrs ')' endSelectorSequence
	| GROUP '(' /*14L*/ startTopFilter startGROUP beginList sortList endGROUP
	| GROUPED '(' /*14L*/ startTopFilter startGROUP beginList sortList endGROUP
	| GROUP '(' /*14L*/ startTopFilter ')' endTopFilter
	| GROUP '(' /*14L*/ startTopFilter startGROUP beginList ROW endGROUP ignoreDummyList
	| REGROUP '(' /*14L*/ dataSetList ')'
	| HAVING '(' /*14L*/ startLeftRowsSeqFilter ',' condList optCommonAttrs ')' endRowsGroup endSelectorSequence
	| KEYED '(' /*14L*/ dataSet indexListOpt ')' endTopFilter
	| UNGROUP '(' /*14L*/ startTopFilter ')' endTopFilter
	| TABLE '(' /*14L*/ startTopFilter ',' recordDef beginList optSortList ')' endTopFilter
	| TABLE '(' /*14L*/ startTopFilter ',' transform ')' endTopFilter
	| TABLE '(' /*14L*/ startTopFilter ')' endTopFilter
	| FETCH '(' /*14L*/ startLeftDelaySeqFilter ',' startRightFilter ',' expression ',' transform optCommonAttrs ')' endSelectorSequence
	| FETCH '(' /*14L*/ startLeftDelaySeqFilter ',' startRightFilter ',' expression optCommonAttrs ')' endSelectorSequence
	| INDEX '(' /*14L*/ startTopFilter ',' indexTopRecordAndName optIndexFlags ')' endTopFilter endTopFilter
	| INDEX '(' /*14L*/ indexTopRecordAndName optIndexFlags ')' endTopFilter
	| INDEX '(' /*14L*/ startTopFilter ',' expression optIndexFlags ')' endTopFilter
	| DATASET '(' /*14L*/ thorFilenameOrList ',' beginCounterScope dsRecordDef endCounterScope ',' mode optDsOptions dsEnd
	| DATASET '(' /*14L*/ thorFilenameOrList ',' beginCounterScope simpleType endCounterScope optDsOptions dsEnd
	| DATASET '(' /*14L*/ dataSet ',' thorFilenameOrList ',' mode optDsOptions dsEnd
	| DATASET '(' /*14L*/ '[' /*15L*/ beginList inlineDatasetValueList ']' ',' recordDef optDatasetFlags ')'
	| DATASET '(' /*14L*/ '[' /*15L*/ beginList transformList ']' optDatasetFlags ')'
	| DATASET '(' /*14L*/ thorFilenameOrList ',' beginCounterScope dsRecordDef endCounterScope optDatasetFlags dsEnd
	| DATASET '(' /*14L*/ WORKUNIT '(' /*14L*/ expression ',' expression ')' ',' recordDef ')'
	| DATASET '(' /*14L*/ WORKUNIT '(' /*14L*/ expression ')' ',' recordDef ')'
	| DATASET '(' /*14L*/ thorFilenameOrList ',' beginCounterScope transform endCounterScope optDatasetFlags ')'
	| ENTH '(' /*14L*/ dataSet ',' expression optCommonAttrs ')'
	| ENTH '(' /*14L*/ dataSet ',' expression ',' expression optCommonAttrs ')'
	| ENTH '(' /*14L*/ dataSet ',' expression ',' expression ',' expression optCommonAttrs ')'
	| PIPE '(' /*14L*/ expression ',' recordDef optPipeOptions ')'
	| PIPE '(' /*14L*/ startTopFilter ',' expression optPipeOptions endTopFilter ')'
	| PIPE '(' /*14L*/ startTopFilter ',' expression ',' recordDef optPipeOptions endTopFilter ')'
	| PRELOAD '(' /*14L*/ dataSet optConstExpression ')'
	| SAMPLE '(' /*14L*/ dataSet ',' expression ')'
	| SAMPLE '(' /*14L*/ dataSet ',' expression ',' expression ')'
	| TOPN '(' /*14L*/ startTopFilter ',' expression ',' startSortOrder beginList sortListOptCurleys ')' endSortOrder endTopFilter
	| SORT '(' /*14L*/ startSortOrder startTopFilter ',' beginList sortListOptCurleys ')' endSortOrder endTopFilter
	| SUBSORT '(' /*14L*/ startSortOrder startTopFilter ',' sortListExpr ',' sortListExpr optCommonAttrs ')' endSortOrder endTopFilter
	| SORTED '(' /*14L*/ startSortOrder startTopFilter ',' beginList sortListOptCurleys ')' endSortOrder endTopFilter
	| SORTED '(' /*14L*/ startSortOrder dataSet ')' endSortOrder
	| STEPPED '(' /*14L*/ startTopFilter ',' expressionList optStepFlags ')' endTopFilter
	| '(' /*14L*/ dataSet ')'
	| IF '(' /*14L*/ booleanExpr ',' dataSet ',' dataSet ')'
	| IF '(' /*14L*/ booleanExpr ',' dataSet ')'
	| IFF '(' /*14L*/ booleanExpr ',' dataSet ',' dataSet ')'
	| IFF '(' /*14L*/ booleanExpr ',' dataSet ')'
	| MAP '(' /*14L*/ mapDatasetSpec ',' dataSet ')'
	| MAP '(' /*14L*/ mapDatasetSpec ')'
	| CASE '(' /*14L*/ expression ',' beginList caseDatasetSpec ',' dataSet ')'
	| CASE '(' /*14L*/ expression ',' beginList caseDatasetSpec ')'
	| CASE '(' /*14L*/ expression ',' beginList dataSet ')'
	| CHOOSE '(' /*14L*/ expression ',' mergeDataSetList ')'
	| PARSE '(' /*14L*/ startTopLeftSeqFilter ',' expression ',' startRootPattern ',' recordDef endRootPattern endTopLeftFilter doParseFlags ')' endSelectorSequence
	| PARSE '(' /*14L*/ startTopLeftSeqFilter ',' expression ',' startRootPattern ',' transform endRootPattern endTopLeftFilter doParseFlags ')' endSelectorSequence
	| PARSE '(' /*14L*/ startTopLeftSeqFilter ',' expression ',' transform endTopLeftFilter xmlParseFlags ')' endSelectorSequence
	| PARSE '(' /*14L*/ startTopLeftSeqFilter ',' expression ',' recordDef endTopLeftFilter xmlParseFlags ')' endSelectorSequence
	| FAIL '(' /*14L*/ recordDef failDatasetParam ')'
	| FAIL '(' /*14L*/ dataSet failDatasetParam ')'
	| TOK_ERROR '(' /*14L*/ recordDef failDatasetParam ')'
	| TOK_ERROR '(' /*14L*/ dataSet failDatasetParam ')'
	| SKIP '(' /*14L*/ recordDef ')'
	| HTTPorSOAPcall '(' /*14L*/ expression ',' expression ',' recordDef ',' DATASET '(' /*14L*/ recordDef ')' ')'
	| HTTPorSOAPcall '(' /*14L*/ expression ',' expression ',' recordDef ',' DATASET '(' /*14L*/ recordDef ')' ',' soapFlags ')'
	| HTTPorSOAPcall '(' /*14L*/ expression ',' expression ',' recordDef ',' transform ',' DATASET '(' /*14L*/ recordDef ')' ')'
	| HTTPorSOAPcall '(' /*14L*/ expression ',' expression ',' recordDef ',' transform ',' DATASET '(' /*14L*/ recordDef ')' ',' soapFlags ')'
	| HTTPorSOAPcall '(' /*14L*/ startTopLeftSeqFilter ',' expression ',' expression ',' recordDef ',' DATASET '(' /*14L*/ recordDef ')' ')' endTopLeftFilter endSelectorSequence
	| HTTPorSOAPcall '(' /*14L*/ startTopLeftSeqFilter ',' expression ',' expression ',' recordDef ',' DATASET '(' /*14L*/ recordDef ')' ',' soapFlags ')' endTopLeftFilter endSelectorSequence
	| HTTPorSOAPcall '(' /*14L*/ startTopLeftSeqFilter ',' expression ',' expression ',' recordDef ',' transform ',' DATASET '(' /*14L*/ recordDef ')' ')' endTopLeftFilter endSelectorSequence
	| HTTPorSOAPcall '(' /*14L*/ startTopLeftSeqFilter ',' expression ',' expression ',' recordDef ',' transform ',' DATASET '(' /*14L*/ recordDef ')' ',' soapFlags ')' endTopLeftFilter endSelectorSequence
	| GLOBAL '(' /*14L*/ dataSet globalOpts ')'
	| GLOBAL '(' /*14L*/ dataSet ',' expression globalOpts ')'
	| LOCAL '(' /*14L*/ dataSet ')'
	| NOLOCAL '(' /*14L*/ dataSet ')'
	| ALLNODES '(' /*14L*/ beginList dataSet ignoreDummyList remoteOptions ')'
	| THISNODE '(' /*14L*/ dataSet ')'
	| DATASET '(' /*14L*/ dataRow ')'
	| DATASET '(' /*14L*/ dictionary ')'
	| _EMPTY_ '(' /*14L*/ recordDef ')'
	| __COMPOUND__ '(' /*14L*/ action ',' dataSet ')'
	| __COMMON__ '(' /*14L*/ dataSet ')'
	| TOK_ASSERT '(' /*14L*/ startTopFilter ',' expression assertFlags ')' endTopFilter
	| TOK_ASSERT '(' /*14L*/ startTopFilter ',' expression ',' expression assertFlags ')' endTopFilter
	| TOK_ASSERT '(' /*14L*/ startTopFilter ',' assertActions ')' endTopFilter
	| ROWS '(' /*14L*/ dataRow ')'
	| XMLPROJECT '(' /*14L*/ expression ',' transform optCommonAttrs ')'
	| WHEN '(' /*14L*/ dataSet ',' action sideEffectOptions ')'
	| SUCCESS '(' /*14L*/ dataSet ',' action ')'
	| AGGREGATE '(' /*14L*/ startLeftDelaySeqFilter ',' startRightRowsRecord ',' transform beginList ')' endRowsGroup endSelectorSequence
	| AGGREGATE '(' /*14L*/ startLeftDelaySeqFilter ',' startRightRowsRecord ',' transform beginList ',' sortList ')' endRowsGroup endSelectorSequence
	| AGGREGATE '(' /*14L*/ startLeftDelaySeqFilter ',' startRightRowsRecord ',' transform beginList ',' transform ')' endRowsGroup endSelectorSequence
	| AGGREGATE '(' /*14L*/ startLeftDelaySeqFilter ',' startRightRowsRecord ',' transform beginList ',' transform ',' sortList ')' endRowsGroup endSelectorSequence
	| QUANTILE '(' /*14L*/ startTopLeftSeqFilter ',' expression ',' sortListExpr beginCounterScope ',' transform optQuantileOptions endCounterScope ')' endTopLeftFilter endSelectorSequence
	| QUANTILE '(' /*14L*/ startTopLeftSeqFilter ',' expression ',' sortListExpr beginCounterScope optQuantileOptions endCounterScope ')' endTopLeftFilter endSelectorSequence
	| UNORDERED '(' /*14L*/ startTopFilter ')' endTopFilter
	;

dataSetList :
	dataSet
	| dataSet ',' dataSetList
	;

mergeDataSetList :
	mergeDataSetItem
	| mergeDataSetList ',' mergeDataSetItem
	;

mergeDataSetItem :
	dataSet
	| commonAttribute
	| DEDUP
	| SORTED '(' /*14L*/ startSortOrder heterogeneous_expr_list ')' endSortOrder
	;

cogroupDataSetList :
	cogroupDataSetItem
	| cogroupDataSetList ',' cogroupDataSetItem
	;

cogroupDataSetItem :
	dataSet
	| commonAttribute
	| GROUPBY '(' /*14L*/ beginList sortList ')'
	;

sideEffectOptions :
	/*empty*/
	| ',' BEFORE
	| ',' SUCCESS
	| ',' FAILURE
	| ',' PARALLEL
	;

optQuantileOptions :
	/*empty*/
	| quantileOptions
	;

quantileOptions :
	',' quantileOption
	| quantileOptions ',' quantileOption
	;

quantileOption :
	FIRST
	| LAST
	| SCORE '(' /*14L*/ expression ')'
	| DEDUP
	| RANGE '(' /*14L*/ expression ')'
	| skewAttribute
	| commonAttribute
	;

limitOptions :
	/*empty*/
	| ',' limitOption limitOptions
	;

limitOption :
	KEYED
	| COUNT
	| SKIP
	| ONFAIL '(' /*14L*/ transform ')'
	| failAction
	| commonAttribute
	;

catchOption :
	SKIP
	| ONFAIL '(' /*14L*/ transform ')'
	| failAction
	;

projectOptions :
	/*empty*/
	| projectOptions ',' projectOption
	;

projectOption :
	commonAttribute
	| prefetchAttribute
	| KEYED
	;

prefetchAttribute :
	PREFETCH
	| PREFETCH '(' /*14L*/ prefetchOptions ')'
	;

prefetchOption :
	PARALLEL
	| SEQUENTIAL
	;

prefetchOptions :
	prefetchOption
	| expression
	| expression ',' prefetchOption
	;

optPrefetchOptions :
	',' prefetchOptions
	| /*empty*/
	;

loopOptions :
	/*empty*/
	| loopOptions ',' loopOption
	;

loopOption :
	commonAttribute
	| FEW
	;

graphOptions :
	/*empty*/
	| graphOptions ',' graphOption
	;

graphOption :
	commonAttribute
	;

remoteOptions :
	/*empty*/
	| ',' LIMIT '(' /*14L*/ expression limitOptions ')'
	;

distributedFlags :
	/*empty*/
	| distributedFlags ',' distributedFlag
	;

distributedFlag :
	TOK_ASSERT
	;

optStepFlags :
	/*empty*/
	| ',' stepFlag optStepFlags
	;

stepFlag :
	PRIORITY '(' /*14L*/ expression ')'
	| PREFETCH
	| PREFETCH '(' /*14L*/ expression ')'
	| FILTERED
	| hintAttribute
	| localAttribute
	;

sectionArguments :
	/*empty*/
	| ',' sectionArgument sectionArguments
	;

sectionArgument :
	dataSet
	| GRAPH
	| PRIVATE
	;

enumDef :
	enumBegin enumFirst enumValues ')'
	;

enumBegin :
	ENUM '(' /*14L*/
	;

enumFirst :
	enumValue
	| scalarType
	;

enumValues :
	/*empty*/
	| enumValues ',' enumValue
	;

enumValue :
	UNKNOWN_ID
	| UNKNOWN_ID EQ expression
	| SCOPE_ID
	| SCOPE_ID EQ expression
	;

indexTopRecordAndName :
	optRecordDef ',' thorFilenameOrList
	| optRecordDef ',' transform ',' thorFilenameOrList
	| optRecordDef ',' nullRecordDef ',' thorFilenameOrList
	;

nullRecordDef :
	recordDef
	| startrecord endrecord
	;

failDatasetParam :
	',' beginList expression ignoreDummyList ',' expression
	| ',' beginList expression ignoreDummyList
	| ',' beginList actionlist
	;

mode :
	FLAT
	| CSV
	| CSV '(' /*14L*/ csvOptions ')'
	| SQL
	| THOR
	| THOR '(' /*14L*/ expression ')'
	| XML_TOKEN
	| XML_TOKEN '(' /*14L*/ xmlOptions ')'
	| JSON_TOKEN
	| JSON_TOKEN '(' /*14L*/ xmlOptions ')'
	| pipe
	;

dsOption :
	OPT
	| UNSORTED
	| RANDOM
	| SEQUENTIAL
	| TOK_BITMAP
	| __COMPRESSED__
	| __GROUPED__
	| lookupOption
	| PRELOAD
	| PRELOAD '(' /*14L*/ constExpression ')'
	| ENCRYPT '(' /*14L*/ expression ')'
	| DYNAMIC
	| COUNT '(' /*14L*/ constExpression ')'
	| MAXCOUNT '(' /*14L*/ constExpression ')'
	| AVE '(' /*14L*/ constExpression ')'
	| __OPTION__ '(' /*14L*/ hintList ')'
	| commonAttribute
	;

lookupOption :
	LOOKUP optConstBoolArg
	;

dsOptions :
	dsOption
	| dsOptions ',' dsOption
	;

optDsOptions :
	/*empty*/
	| ',' dsOptions
	;

thorFilenameOrList :
	expression
	| DYNAMIC '(' /*14L*/ expression ')'
	;

indexListOpt :
	/*empty*/
	| indexListOpt ',' dataSet
	;

csvOptions :
	csvOption
	| csvOption ',' csvOptions
	;

csvOption :
	EBCDIC
	| ASCII
	| SIMPLE_TYPE
	| HEADING
	| HEADING '(' /*14L*/ startHeadingAttrs headingOptions ')'
	| MAXLENGTH '(' /*14L*/ constExpression ')'
	| MAXSIZE '(' /*14L*/ constExpression ')'
	| QUOTE '(' /*14L*/ expression ')'
	| SEPARATOR '(' /*14L*/ expression ')'
	| TERMINATOR '(' /*14L*/ expression ')'
	| TERMINATOR '(' /*14L*/ expression ',' QUOTE ')'
	| ESCAPE '(' /*14L*/ expression ')'
	| NOTRIM
	;

headingOptions :
	headingOption
	| headingOptions ',' headingOption
	;

headingOption :
	SINGLE
	| MANY
	| expression
	| FORMAT_ATTR '(' /*14L*/ valueFunction ')'
	;

xmlOptions :
	xmlOption
	| xmlOptions ',' xmlOption
	;

xmlOption :
	MAXLENGTH '(' /*14L*/ constExpression ')'
	| MAXSIZE '(' /*14L*/ constExpression ')'
	| NOROOT
	| HEADING '(' /*14L*/ expression optCommaExpression ')'
	| expression
	| TRIM
	| OPT
	;

optPipeOptions :
	/*empty*/
	| ',' pipeOptions
	;

pipeOptions :
	pipeOption
	| pipeOptions ',' pipeOption
	;

pipeOption :
	REPEAT
	| pipeFormatOption
	| OUTPUT '(' /*14L*/ pipeFormatOption ')'
	| GROUP
	| OPT
	;

pipeFormatOption :
	CSV
	| CSV '(' /*14L*/ csvOptions ')'
	| XML_TOKEN
	| XML_TOKEN '(' /*14L*/ xmlOptions ')'
	| FLAT
	| THOR
	;

setCountList :
	mapSpec
	| mapSpec ',' expression
	| mapSpec ',' choosesetAttr
	| mapSpec ',' expression ',' choosesetAttr
	;

choosesetAttr :
	EXCLUSIVE
	| ENTH
	| LAST
	;

pipe :
	PIPE '(' /*14L*/ expression optPipeOptions ')'
	;

choosenExtra :
	/*empty*/
	| ',' choosenFlags
	| ',' expression
	| ',' expression ',' choosenFlags
	;

choosenFlags :
	choosenFlag
	| choosenFlags ',' choosenFlag
	;

choosenFlag :
	GROUPED
	| commonAttribute
	| FEW
	;

inlineFieldValue2 :
	expression
	| dataSet
	| inlineDatasetValue
	| dataRow
	| '[' /*15L*/ beginList inlineDatasetValueList ']'
	;

inlineFieldValue :
	inlineFieldValue2
	;

inlineFieldValueGoesTo :
	GOESTO
	;

inlineFieldValues :
	inlineFieldValue
	| inlineFieldValues ';' inlineFieldValue
	| inlineFieldValues ',' inlineFieldValue
	;

inlineFieldValuesWithGoesto :
	inlineFieldValues optSemiComma
	| inlineFieldValues inlineFieldValueGoesTo inlineFieldValues optSemiComma
	;

inlineDatasetValue :
	'{' beginList inlineFieldValuesWithGoesto '}'
	;

inlineDatasetValueList :
	inlineDatasetValue
	| simpleRecord
	| inlineDatasetValueList ',' inlineDatasetValue
	| inlineDatasetValueList ',' simpleRecord
	;

transformList :
	transform
	| transformList ',' transform
	;

optJoinFlags :
	/*empty*/
	| ',' JoinFlags
	;

JoinFlags :
	JoinFlag
	| JoinFlags ',' JoinFlag
	;

JoinFlag :
	LEFT OUTER
	| RIGHT OUTER
	| LEFT RIGHT OUTER
	| FULL OUTER
	| LEFT ONLY
	| ONLY LEFT
	| RIGHT ONLY
	| ONLY RIGHT
	| LEFT RIGHT ONLY
	| FULL ONLY
	| INNER
	| HASH
	| KEYED '(' /*14L*/ dataSet ')'
	| KEYED
	| FEW
	| commonAttribute
	| MANY LOOKUP
	| GROUPED
	| MANY
	| LOOKUP
	| SMART
	| NOSORT
	| NOSORT '(' /*14L*/ LEFT ')'
	| NOSORT '(' /*14L*/ RIGHT ')'
	| ATMOST '(' /*14L*/ expression ')'
	| ATMOST '(' /*14L*/ expression ',' expression ')'
	| ATMOST '(' /*14L*/ expression ',' sortListExpr ',' expression ')'
	| ATMOST '(' /*14L*/ sortListExpr ',' expression ')'
	| KEEP '(' /*14L*/ expression ')'
	| PARTITION LEFT
	| PARTITION RIGHT
	| THRESHOLD '(' /*14L*/ expression ')'
	| ALL
	| skewAttribute
	| LIMIT '(' /*14L*/ expression joinLimitOptions ')'
	| onFailAction
	| SEQUENTIAL
	| GROUP '(' /*14L*/ startSortOrder heterogeneous_expr_list ')' endSortOrder
	| STREAMED
	;

joinLimitOptions :
	/*empty*/
	| joinLimitOptions ',' joinLimitOption
	;

joinLimitOption :
	SKIP
	| COUNT
	| failAction
	| transform
	;

mergeJoinFlags :
	mergeJoinFlag
	| mergeJoinFlags ',' mergeJoinFlag
	;

mergeJoinFlag :
	MOFN '(' /*14L*/ expression ')'
	| MOFN '(' /*14L*/ expression ',' expression ')'
	| DEDUP
	| LEFT ONLY
	| LEFT OUTER
	| TOK_ASSERT SORTED
	| SORTED '(' /*14L*/ startSortOrder heterogeneous_expr_list ')' endSortOrder
	| INTERNAL '(' /*14L*/ constExpression ')'
	| PARTITION '(' /*14L*/ heterogeneous_expr_list ')'
	| commonAttribute
	;

skewAttribute :
	SKEW '(' /*14L*/ expression ')'
	| SKEW '(' /*14L*/ optExpression ',' expression ')'
	;

optDistributionFlags :
	/*empty*/
	| ',' DistributionFlags
	;

DistributionFlags :
	DistributionFlag
	| DistributionFlags ',' DistributionFlag
	;

DistributionFlag :
	ATMOST '(' /*14L*/ expression ')'
	| SKEW
	| NAMED '(' /*14L*/ constExpression ')'
	;

optTrimFlags :
	/*empty*/
	| TrimFlags
	;

TrimFlags :
	commaTrimFlag
	| TrimFlags commaTrimFlag
	;

commaTrimFlag :
	',' TrimFlag
	;

TrimFlag :
	LEFT
	| RIGHT
	| ALL
	| WHITESPACE
	;

optSortList :
	/*empty*/
	| ',' sortList
	;

optTraceFlags :
	traceFlags
	| /*empty*/
	;

traceFlags :
	',' traceFlag
	| traceFlags ',' traceFlag
	;

traceFlag :
	KEEP '(' /*14L*/ expression ')'
	| SKIP '(' /*14L*/ expression ')'
	| SAMPLE '(' /*14L*/ expression ')'
	| NAMED '(' /*14L*/ constExpression ')'
	| expression
	;

doParseFlags :
	parseFlags
	;

parseFlags :
	/*empty*/
	| parseFlags ',' parseFlag
	;

parseFlag :
	ALL
	| FIRST
	| WHOLE
	| NOSCAN
	| SCAN
	| SCAN ALL
	| NOCASE
	| CASE
	| SKIP '(' /*14L*/ pattern ')'
	| TERMINATOR '(' /*14L*/ expression ')'
	| ATMOST '(' /*14L*/ constExpression ')'
	| KEEP '(' /*14L*/ constExpression ')'
	| MATCHED '(' /*14L*/ ALL ')'
	| MATCHED '(' /*14L*/ patternOrRuleId ')'
	| MAX
	| MIN
	| USE '(' /*14L*/ globalPatternAttribute ')'
	| BEST
	| MANY BEST
	| MANY MIN
	| MANY MAX
	| NOT /*12L*/ MATCHED
	| NOT /*12L*/ MATCHED ONLY
	| PARSE
	| GROUP
	| MANY
	| MAXLENGTH '(' /*14L*/ constExpression ')'
	| MAXSIZE '(' /*14L*/ constExpression ')'
	| commonAttribute
	;

xmlParseFlags :
	/*empty*/
	| xmlParseFlags ',' xmlParseFlag
	;

xmlParseFlag :
	XML_TOKEN
	| XML_TOKEN '(' /*14L*/ constExpression ')'
	;

startGROUP :
	','
	;

endGROUP :
	')'
	;

startSortOrder :
	/*empty*/
	;

endSortOrder :
	/*empty*/
	;

startTopFilter :
	dataSet
	;

startRightFilter :
	dataSet
	;

startRightRowsRecord :
	recordDef
	;

startLeftRightSeqFilter :
	dataSet
	;

startTopLeftSeqFilter :
	dataSet
	;

startTopLeftRightSeqFilter :
	dataSet
	;

startTopLeftRightSeqSetDatasets :
	setOfDatasets
	;

startPointerToMember :
	LT
	;

endPointerToMember :
	GT
	;

startSimpleFilter :
	simpleDataSet
	;

startLeftSeqRow :
	dataRow
	;

startRightRow :
	dataRow
	;

startLeftRowsSeqFilter :
	dataSet
	;

startLeftSeqFilter :
	dataSet
	;

startLeftDelaySeqFilter :
	dataSet
	;

startRightDistributeSeqFilter :
	dataSet
	;

endSelectorSequence :
	/*empty*/
	;

startLeftRowsGroup :
	GROUP
	;

startLeftRows :
	/*empty*/
	;

startRightRowsGroup :
	GROUP
	;

endRowsGroup :
	/*empty*/
	;

endSimpleFilter :
	/*empty*/
	;

endTopFilter :
	/*empty*/
	;

endTopLeftFilter :
	/*empty*/
	;

endTopLeftRightFilter :
	/*empty*/
	;

scopedDatasetId :
	globalScopedDatasetId
	| dotScope DATASET_ID leaveScope
	| datasetFunction '(' /*14L*/ actualParameters ')'
	;

globalScopedDatasetId :
	DATASET_ID
	| moduleScopeDot DATASET_ID leaveScope
	;

setOfDatasets :
	scopedListDatasetId
	| RANGE '(' /*14L*/ setOfDatasets ',' expression ')'
	| '[' /*15L*/ beginList dataSetList ignoreDummyList ']'
	| ROWSET '(' /*14L*/ dataRow ')'
	| startCompoundExpression beginInlineFunctionToken optDefinitions RETURN setOfDatasets ';' endInlineFunctionToken
	;

scopedListDatasetId :
	LIST_DATASET_ID
	| dotScope LIST_DATASET_ID leaveScope
	| moduleScopeDot LIST_DATASET_ID leaveScope
	| listDatasetFunction '(' /*14L*/ actualParameters ')'
	;

actualParameters :
	actualList
	;

actualList :
	optActualValue
	| actualList ',' optActualValue
	;

optActualValue :
	/*empty*/
	| actualValue
	| namedActual
	;

namedActual :
	UNKNOWN_ID ASSIGN actualValue
	| NAMED UNKNOWN_ID ASSIGN actualValue
	| goodObject ASSIGN actualValue
	;

actualValue :
	expression
	| dataSet optFieldMaps
	| dataRow
	| dictionary
	| TOK_PATTERN pattern
	| TOKEN pattern
	| RULE pattern
	| anyFunction
	| abstractModule
	| setOfDatasets
	| recordDef
	| fieldSelectedFromRecord
	;

anyFunction :
	DATAROW_FUNCTION
	| moduleScopeDot DATAROW_FUNCTION leaveScope
	| DATASET_FUNCTION
	| moduleScopeDot DATASET_FUNCTION leaveScope
	| valueFunction
	| ACTION_FUNCTION
	| moduleScopeDot ACTION_FUNCTION leaveScope
	| PATTERN_FUNCTION
	| moduleScopeDot PATTERN_FUNCTION leaveScope
	| RECORD_FUNCTION
	| moduleScopeDot RECORD_FUNCTION leaveScope
	| EVENT_FUNCTION
	| moduleScopeDot EVENT_FUNCTION leaveScope
	| scopeFunction
	| TRANSFORM_FUNCTION
	| moduleScopeDot TRANSFORM_FUNCTION leaveScope
	;

valueFunction :
	VALUE_FUNCTION
	| moduleScopeDot VALUE_FUNCTION leaveScope
	| startCompoundExpression reqparmdef beginInlineFunctionToken optDefinitions RETURN expression ';' endInlineFunctionToken
	;

actionFunction :
	ACTION_FUNCTION
	| moduleScopeDot ACTION_FUNCTION leaveScope
	| startCompoundExpression reqparmdef beginInlineFunctionToken optDefinitions RETURN action ';' endInlineFunctionToken
	;

datarowFunction :
	DATAROW_FUNCTION
	| moduleScopeDot DATAROW_FUNCTION leaveScope
	| startCompoundExpression reqparmdef beginInlineFunctionToken optDefinitions RETURN dataRow ';' endInlineFunctionToken
	;

datasetFunction :
	DATASET_FUNCTION
	| moduleScopeDot DATASET_FUNCTION leaveScope
	| startCompoundExpression reqparmdef beginInlineFunctionToken optDefinitions RETURN dataSet ';' endInlineFunctionToken
	;

dictionaryFunction :
	DICTIONARY_FUNCTION
	| moduleScopeDot DICTIONARY_FUNCTION leaveScope
	| startCompoundExpression reqparmdef beginInlineFunctionToken optDefinitions RETURN dictionary ';' endInlineFunctionToken
	;

scopeFunction :
	SCOPE_FUNCTION
	| moduleScopeDot SCOPE_FUNCTION leaveScope
	| startCompoundExpression reqparmdef beginInlineFunctionToken optDefinitions RETURN abstractModule ';' endInlineFunctionToken
	;

transformFunction :
	TRANSFORM_FUNCTION
	| moduleScopeDot TRANSFORM_FUNCTION leaveScope
	| startCompoundExpression reqparmdef beginInlineFunctionToken optDefinitions RETURN transform ';' endInlineFunctionToken
	;

recordFunction :
	RECORD_FUNCTION
	| moduleScopeDot RECORD_FUNCTION leaveScope
	| startCompoundExpression reqparmdef beginInlineFunctionToken optDefinitions RETURN recordDef ';' endInlineFunctionToken
	;

listDatasetFunction :
	LIST_DATASET_FUNCTION
	| moduleScopeDot LIST_DATASET_FUNCTION leaveScope
	| startCompoundExpression reqparmdef beginInlineFunctionToken optDefinitions RETURN setOfDatasets ';' endInlineFunctionToken
	;

eventFunction :
	EVENT_FUNCTION
	| moduleScopeDot EVENT_FUNCTION leaveScope
	| startCompoundExpression reqparmdef beginInlineFunctionToken optDefinitions RETURN eventObject ';' endInlineFunctionToken
	;

optFieldMaps :
	'{' beginList fieldMaps '}'
	| /*empty*/
	//| '{' beginList error '}'
	;

fieldMaps :
	fieldMaps1 optSemiComma
	;

fieldMaps1 :
	fieldMap
	| fieldMaps1 semiComma fieldMap
	;

fieldMap :
	UNKNOWN_ID ASSIGN UNKNOWN_ID
	;

sortListOptCurleys :
	sortList
	| '{' sortList '}'
	| '{' sortList '}' ',' sortList
	;

sortList :
	sortItem
	| sortList ',' sortItem
	| sortList ';' sortItem
	;

nonDatasetList :
	nonDatasetExpr
	| nonDatasetList ',' nonDatasetExpr
	| nonDatasetList ';' nonDatasetExpr
	;

nonDatasetExpr :
	expression
	| dataRow
	| '-' /*8L*/ dataRow
	| dictionary
	;

simpleSortItem :
	nonDatasetExpr
	| dataSet
	| expandedSortListByReference
	;

sortItem :
	simpleSortItem
	| FEW
	| MANY
	| MERGE
	| SORTED
	| UNSORTED
	| skewAttribute
	| TOK_ASSERT
	| JOINED '(' /*14L*/ dataSet ')'
	| THRESHOLD '(' /*14L*/ expression ')'
	| WHOLE RECORD
	| RECORD
	| EXCEPT expression
	| EXCEPT dataRow
	| EXCEPT dataSet
	| BEST '(' /*14L*/ heterogeneous_expr_list ')'
	| mergeJoinFlag
	| KEYED
	| GROUPED
	| prefetchAttribute
	;

expandedSortListByReference :
	startPointerToMember SORTLIST_ID endPointerToMember
	| dotScope startPointerToMember leaveScope SORTLIST_ID endPointerToMember
	;

optDedupFlags :
	dedupFlags
	| /*empty*/
	;

dedupFlags :
	',' dedupFlag
	| dedupFlags ',' dedupFlag
	;

dedupFlag :
	KEEP expression
	| commonAttribute
	| expression
	| WHOLE RECORD
	| RECORD
	| EXCEPT expression
	| MANY
	| HASH
	| dataRow
	| dataSet
	| BEST '(' /*14L*/ startSortOrder beginList sortListOptCurleys ')' endSortOrder
	;

rollupExtra :
	rollupFlags
	;

rollupFlags :
	',' rollupFlag
	| rollupFlags ',' rollupFlag
	;

rollupFlag :
	commonAttribute
	| expression
	| WHOLE RECORD
	| RECORD
	| EXCEPT expression
	| dataRow
	| dataSet
	;

conditions :
	'(' /*14L*/ condList optCommonAttrs ')'
	| '(' /*14L*/ ')'
	;

mapSpec :
	mapItem
	| mapSpec ',' mapItem
	;

mapItem :
	booleanExpr GOESTO expression
	;

beginList :
	/*empty*/
	;

sortListExpr :
	beginList '{' sortList '}'
	;

ignoreDummyList :
	/*empty*/
	;

caseSpec :
	caseItem
	| caseSpec ',' caseItem
	;

caseItem :
	expression GOESTO expression
	;

mapDatasetSpec :
	mapDatasetItem
	| mapDatasetSpec ',' mapDatasetItem
	;

mapDatasetItem :
	booleanExpr GOESTO dataSet
	;

mapDictionarySpec :
	mapDictionaryItem
	| mapDictionarySpec ',' mapDictionaryItem
	;

mapDictionaryItem :
	booleanExpr GOESTO dictionary
	;

caseDatasetSpec :
	caseDatasetItem
	| caseDatasetSpec ',' caseDatasetItem
	;

caseDatasetItem :
	expression GOESTO dataSet
	;

caseDictionarySpec :
	caseDictionaryItem
	| caseDictionarySpec ',' caseDictionaryItem
	;

caseDictionaryItem :
	expression GOESTO dictionary
	;

mapDatarowSpec :
	mapDatarowItem
	| mapDatarowSpec ',' mapDatarowItem
	;

mapDatarowItem :
	booleanExpr GOESTO dataRow
	;

caseDatarowSpec :
	caseDatarowItem
	| caseDatarowSpec ',' caseDatarowItem
	;

caseDatarowItem :
	expression GOESTO dataRow
	;

mapActionSpec :
	mapActionItem
	| mapActionSpec ',' mapActionItem
	;

mapActionItem :
	booleanExpr GOESTO action
	;

caseActionSpec :
	caseActionItem
	| caseActionSpec ',' caseActionItem
	;

caseActionItem :
	expression GOESTO action
	;

const :
	stringConstExpr
	| INTEGER_CONST
	| DATA_CONST
	| REAL_CONST
	| UNICODE_CONST
	| TOK_TRUE
	| TOK_FALSE
	| BOOL_CONST
	;

stringConstExpr :
	STRING_CONST
	;

stringOrUnicodeConstExpr :
	stringConstExpr
	| UNICODE_CONST
	;

optConstExpression :
	/*empty*/
	| ',' constExpression
	;

pattern :
	beginList patternOr
	;

optPatternOr :
	patternOr
	| /*empty*/
	;

patternOr :
	patternOrItem
	| optPatternOr '|' /*10L*/ optPatternOrItem
	| optPatternOr OR /*3L*/ optPatternOrItem
	;

optPatternOrItem :
	patternOrItem
	| /*empty*/
	;

patternOrItem :
	beginPatternScope patternOrItemValue
	;

beginPatternScope :
	/*empty*/
	;

startRootPattern :
	globalPatternAttribute
	;

endRootPattern :
	/*empty*/
	;

patternOrItemValue :
	pattern2
	| pattern2 transform
	;

pattern2 :
	pattern2 checkedPattern
	| checkedPattern
	;

optNotAttr :
	/*empty*/
	| NOT /*12L*/
	;

checkedPattern :
	pattern0
	| checkedPattern optNotAttr BEFORE pattern0
	| checkedPattern optNotAttr AFTER pattern0
	| TOK_ASSERT optNotAttr BEFORE pattern0
	| TOK_ASSERT optNotAttr AFTER pattern0
	| checkedPattern optNotAttr TOK_IN pattern0
	| checkedPattern optNotAttr EQ pattern0
	| checkedPattern NE pattern0
	| checkedPattern LENGTH '(' /*14L*/ rangeExpr ')'
	| VALIDATE '(' /*14L*/ pattern ',' booleanExpr ')'
	| VALIDATE '(' /*14L*/ pattern ',' booleanExpr ',' booleanExpr ')'
	;

pattern0 :
	FIRST
	| LAST
	| REPEAT '(' /*14L*/ pattern optMinimal ')'
	| REPEAT '(' /*14L*/ pattern ',' expression optMinimal ')'
	| REPEAT '(' /*14L*/ pattern ',' expression ',' ANY optMinimal ')'
	| REPEAT '(' /*14L*/ pattern ',' expression ',' expression optMinimal ')'
	| OPT '(' /*14L*/ pattern optConstExpression ')'
	| pattern0 '*' /*9L*/
	| pattern0 '+' /*8L*/
	| pattern0 '?'
	| pattern0 '*' /*9L*/ INTEGER_CONST
	| '(' /*14L*/ pattern ')'
	| TOKEN '(' /*14L*/ pattern ')'
	| ANY
	| MIN '(' /*14L*/ pattern ')'
	| '[' /*15L*/ beginList optPatternList ']'
	| TOK_PATTERN '(' /*14L*/ expr ')'
	| stringOrUnicodeConstExpr
	| globalValueAttribute
	| globalFeaturedPatternAttribute
	| SELF
	| USE '(' /*14L*/ stringConstExpr ')'
	| USE '(' /*14L*/ UNKNOWN_ID ')'
	| USE '(' /*14L*/ UNKNOWN_ID '.' /*13L*/ UNKNOWN_ID ')'
	| USE '(' /*14L*/ recordDef ',' stringConstExpr ')'
	| USE '(' /*14L*/ recordDef ',' UNKNOWN_ID ')'
	| USE '(' /*14L*/ recordDef ',' UNKNOWN_ID '.' /*13L*/ UNKNOWN_ID ')'
	| DEFINE '(' /*14L*/ pattern ',' stringConstExpr ')'
	| PENALTY '(' /*14L*/ constExpression ')'
	| GUARD '(' /*14L*/ featureGuards ')'
	| CASE '(' /*14L*/ pattern ')'
	| NOCASE '(' /*14L*/ pattern ')'
	;

globalFeaturedPatternAttribute :
	globalPatternAttribute
	| globalPatternAttribute featureModifiers
	;

globalPatternAttribute :
	patternOrRuleId
	| patternOrRuleFunction '(' /*14L*/ patternParameters ')'
	;

patternParameters :
	beginPatternParameters patternActualList endPatternParameters
	;

beginPatternParameters :
	/*empty*/
	;

endPatternParameters :
	/*empty*/
	;

patternActualList :
	optPatternActualValue
	| patternActualList ',' optPatternActualValue
	;

optPatternActualValue :
	/*empty*/
	| patternParamval
	| namedPatternActual
	;

namedPatternActual :
	UNKNOWN_ID ASSIGN patternParamval
	| NAMED UNKNOWN_ID ASSIGN patternParamval
	;

patternParamval :
	pattern
	| simpleType expression
	;

optMinimal :
	/*empty*/
	| ',' MIN
	;

optPatternList :
	/*empty*/
	| patternList
	;

patternList :
	pattern
	| patternList ',' pattern
	;

patternReference :
	patternSelector
	| patternReference '/' /*9L*/ patternSelector
	;

patternSelector :
	patternOrRuleRef
	| patternOrRuleRef '[' /*15L*/ expression ']'
	;

patternOrRuleRef :
	patternOrRuleId
	| patternOrRuleFunction
	;

patternOrRuleId :
	PATTERN_ID
	| moduleScopeDot PATTERN_ID leaveScope
	;

patternOrRuleFunction :
	PATTERN_FUNCTION
	| moduleScopeDot PATTERN_FUNCTION leaveScope
	;

defineFeatureIdWithOptScope :
	defineFeatureId
	| scopeFlag defineFeatureId
	;

defineFeatureId :
	FEATURE knownOrUnknownId
	;

featureParameters :
	/*empty*/
	| '{' featureIdList '}'
	;

featureIdList :
	featureId
	| featureIdList ',' featureId
	;

featureDefine :
	simpleType
	| featureCompound
	;

featureCompound :
	featureId
	| featureCompound '|' /*10L*/ featureId
	;

featureList :
	featureCompound
	| featureList ',' featureCompound
	;

featureGuards :
	featureGuard
	| featureGuards ',' featureGuard
	;

featureGuard :
	featureId EQ featureCompound
	| featureId TOK_IN '[' /*15L*/ featureList ']'
	| featureCompound
	| featureId EQ constExpression
	| constExpression
	;

featureId :
	FEATURE_ID
	| moduleScopeDot FEATURE_ID leaveScope
	;

featureValue :
	featureCompound
	| constExpression
	;

featureValueList :
	featureValue
	| featureValueList ',' featureValue
	;

featureModifiers :
	'{' featureValueList '}'
	;

startDistributeAttrs :
	/*empty*/
	;

startHeadingAttrs :
	/*empty*/
	;

startStoredAttrs :
	/*empty*/
	;

%%

%option caseless

letter        [a-z_A-Z]
digit         [0-9]
bindigit      [0-1]
hexdigit      [a-fA-F0-9]
alphanum      [a-z_A-Z$_0-9]
alphanumcolon [a-z_A-Z$_0-9:@]
blank         [ \t\r]
slash         [/]
star          [*]
percent       [%]
lcurly        [\{]
rcurly        [\}]
dot           [\.]
hexpairs      ({hexdigit}{hexdigit})+
err_hexpairs  {hexdigit}({hexdigit}{hexdigit})*
xpathchars    [a-z_A-Z$_0-9:/\[\]@=!]
xpathseq      ([^}\r\n])+

%%

[ \n\r\t]+	skip()
"/*"(?s:.)*?"*/"	skip()
"//".*  skip()

ABS                 ABS
ACOS                ACOS
AFTER               AFTER
AGGREGATE           AGGREGATE
ALGORITHM           ALGORITHM
__ALIAS__           ALIAS
ALL                 ALL
ALLNODES            ALLNODES
ANY                 ANY
APPLY               APPLY
_ARRAY_             _ARRAY_
AS                  AS
ASCII               ASCII
ASIN                ASIN
ASSERT              TOK_ASSERT
ASSTRING            ASSTRING
ATAN                ATAN
ATAN2               ATAN2
ATMOST              ATMOST
AVE                 AVE
BACKUP              BACKUP
BEFORE              BEFORE
BEST                BEST
BETWEEN             BETWEEN
BITMAP              TOK_BITMAP
BIG_ENDIAN          BIG
BLOB                BLOB
BLOOM               BLOOM
BNOT                BNOT
BUILD               BUILD
BUILDINDEX          BUILD
"C++"               TOK_CPP
CARDINALITY         CARDINALITY
CASE                CASE
CATCH               TOK_CATCH
CHECKPOINT          CHECKPOINT
CHOOSE              CHOOSE
CHOOSEN             CHOOSEN
CHOOSEN:ALL         CHOOSENALL
CHOOSESETS          CHOOSESETS
CLUSTER             CLUSTER
CLUSTERSIZE         CLUSTERSIZE
COGROUP             COGROUP
COMBINE             COMBINE
__COMMON__          __COMMON__
__COMPOUND__        __COMPOUND__
COMPRESSED          COMPRESSED
__COMPRESSED__      __COMPRESSED__
COS                 COS
COSH                COSH
COUNT               COUNT
COUNTER             COUNTER
CRITICAL            CRITICAL
CRON                CRON
CSV                 CSV
DATASET             DATASET
DEDUP               DEDUP
DEFAULT             DEFAULT
DEFINE              DEFINE
DENORMALIZE         DENORMALIZE
DEPRECATED          DEPRECATED
DESC                DESC
DESCEND             DESC
DICTIONARY          DICTIONARY
DISTRIBUTE          DISTRIBUTE
DISTRIBUTED         DISTRIBUTED
DISTRIBUTION        DISTRIBUTION
DIV                 DIV
DYNAMIC             DYNAMIC
EBCDIC              EBCDIC
ECLCRC              ECLCRC
ELSE                ELSE
ELSIF               ELSEIF
ELSEIF              ELSEIF
EMBED               EMBED
EMBEDDED            EMBEDDED
_EMPTY_             _EMPTY_
ENCODING            ENCODING
ENCRYPT             ENCRYPT
END                 END    // hard reserved to aid resyncing
ENUM                ENUM
ENTH                ENTH
ERROR               TOK_ERROR
EVALUATE            EVALUATE
EVENT               EVENT
EVENTEXTRA          EVENTEXTRA
EVENTNAME           EVENTNAME
EXCEPT              EXCEPT
EXCLUSIVE           EXCLUSIVE
EXISTS              EXISTS
EXP                 EXP
EXPIRE              EXPIRE
EXPORT              EXPORT
EXTEND              EXTEND
FAIL                FAIL
FAILCODE            FAILCODE
FAILMESSAGE         FAILMESSAGE
FAILURE             FAILURE
FEATURE             FEATURE
FETCH               FETCH
FEW                 FEW
FILEPOSITION        FILEPOSITION
FILTERED            FILTERED
FIRST               FIRST
FIXED               TOK_FIXED
FLAT                FLAT
FORMENCODED         FORMENCODED             // Dynamically enabled based on the context
FORMAT              FORMAT_ATTR             // Dynamically enabled based on the context
FORWARD             FORWARD
FROM                FROM
FROMUNICODE         FROMUNICODE
FROMJSON            FROMJSON
FROMXML             FROMXML
FULL                FULL
FUNCTION            FUNCTION
GETENV              GETENV
GETSECRET           GETSECRET
GLOBAL              GLOBAL
GRAPH               GRAPH
GROUP               GROUP
GROUPBY             GROUPBY
GROUPED             GROUPED
GUARD               GUARD
__GROUPED__         __GROUPED__
HAVING              HAVING
HEADING             HEADING
HINT                HINT
HTTPCALL            HTTPCALL
HTTPHEADER          HTTPHEADER
IF                  IF
IFF                 IFF
IFBLOCK             IFBLOCK
IGNORE              TOK_IGNORE
//IMPLEMENTS          IMPLEMENTS
IMPORT              IMPORT
INDEPENDENT         INDEPENDENT
INDEX               INDEX
INLINE              INLINE
INTERNAL            INTERNAL
INTERFACE           INTERFACE
INTFORMAT           INTFORMAT
ISNULL              ISNULL
ISVALID             ISVALID
ITERATE             ITERATE
JOIN                JOIN
JOINED              JOINED
JSON                JSON_TOKEN
KEEP                KEEP
KEYDIFF             KEYDIFF
KEYED               KEYED
KEYPATCH            KEYPATCH
KEYUNICODE          KEYUNICODE
LABELED             LABELED
LABELLED            LABELED
LABEL               LABEL
LAST                LAST
LEFT                LEFT
LENGTH              LENGTH
LIBRARY             LIBRARY
LIKELY              LIKELY
LIMIT               LIMIT
LINKCOUNTED         LINKCOUNTED
_LINKCOUNTED_       LINKCOUNTED
LITERAL             LITERAL
LITTLE_ENDIAN       LITTLE
LN                  LN
LOADXML             LOADXML
LOCAL               LOCAL
LOCALE              LOCALE
LOCALFILEPOSITION   LOCALFILEPOSITION
LOG                 TOK_LOG
LOGICALFILENAME     LOGICALFILENAME
LOOKUP              LOOKUP
LOOP                LOOP
LZW                 LZW
MANY                MANY
MAP                 MAP
MATCHED             MATCHED
MATCHLENGTH         MATCHLENGTH
MATCHPOSITION       MATCHPOSITION
MATCHROW            MATCHROW
MATCHTEXT           MATCHTEXT
MATCHUNICODE        MATCHUNICODE
MATCHUTF8           MATCHUTF8
MAX                 MAX
MAXCOUNT            MAXCOUNT
MAXLENGTH           MAXLENGTH
MAXSIZE             MAXSIZE
MERGE               MERGE                   // May be dynamically converted to MERGE_ATTR
MERGEJOIN           MERGEJOIN
MIN                 MIN
MODULE              MODULE
MOFN                MOFN
MULTIPLE            MULTIPLE
NAMED               NAMED
__NAMEOF__          NAMEOF
NAMESPACE           NAMESPACE
NOBOUNDCHECK        NOBOUNDCHECK
NOCASE              NOCASE
NOCOMBINE           NOCOMBINE
NOCONST             NOCONST
NOFOLD              NOFOLD
NOHOIST             NOHOIST
NOLOCAL             NOLOCAL
NONEMPTY            NONEMPTY
NOOVERWRITE         NOOVERWRITE
NORMALIZE           NORMALIZE
NOROOT              NOROOT
NOSCAN              NOSCAN
NOSORT              NOSORT
__NOSTREAMING__     __NOSTREAMING__
NOTHOR              NOTHOR
NOTIFY              NOTIFY
NOTRIM              NOTRIM
NOXPATH             NOXPATH
OF                  OF
OMITTED             OMITTED
ONCE                ONCE
ONFAIL              ONFAIL
ONLY                ONLY
ONWARNING           ONWARNING
OPT                 OPT
__OPTION__          __OPTION__
ORDERED             ORDERED
OUTER               OUTER
OUTPUT              OUTPUT

OVERWRITE           OVERWRITE
__OWNED__           __OWNED__
PACKED              PACKED
PARALLEL            PARALLEL
PARSE               PARSE
PARTITION           PARTITION               // May be dynamically converted to PARTITION_ATTR
PATTERN             TOK_PATTERN
PENALTY             PENALTY
PERSIST             PERSIST
//PHYSICALFILENAME    PHYSICALFILENAME
PIPE                PIPE
PLANE               PLANE
__PLATFORM__        __PLATFORM__
POWER               POWER
PREFETCH            PREFETCH
PRELOAD             PRELOAD
PRIORITY            PRIORITY
PRIVATE             PRIVATE
PROBABILITY         PROBABILITY
PROCESS             PROCESS
PROJECT             PROJECT
PROXYADDRESS        PROXYADDRESS
PULL                PULL
PULLED              PULLED
QUANTILE            QUANTILE
QUEUE               QUEUE
QUOTE               QUOTE
RANGE               RANGE
RANK                RANK
RANKED              RANKED
REALFORMAT          REALFORMAT
RECORD              RECORD
RECORDOF            RECORDOF
RECOVERY            RECOVERY
REFRESH             REFRESH
REGEXFIND           REGEXFIND
REGEXFINDSET        REGEXFINDSET
REGEXREPLACE        REGEXREPLACE
REGROUP             REGROUP
REJECTED            REJECTED
//RELATIONSHIP        RELATIONSHIP
REMOTE              REMOTE
REPEAT              REPEAT
RESPONSE            RESPONSE
RESTRICTED          RESTRICTED
RETRY               RETRY
RETURN              RETURN
RIGHT               RIGHT
RIGHT{digit}+       RIGHT_NN

ROLLUP              ROLLUP
ROUND               ROUND
ROUNDUP             ROUNDUP
ROW                 ROW
ROWS                ROWS
ROWSET              ROWSET
ROWDIFF             ROWDIFF
RULE                RULE
SAMPLE              SAMPLE
SCAN                SCAN
SCORE               SCORE
SECTION             SECTION
SELF                SELF
SEPARATOR           SEPARATOR
__SEQUENCE__        __SEQUENCE__
SEQUENTIAL          SEQUENTIAL
SERVICE             SERVICE
SET                 SET
"#option" HASH_OPTION
SHARED              SHARED
SIN                 SIN
SINGLE              SINGLE
SINH                SINH
SIZEOF              SIZEOF
SKEW                SKEW
SKIP                SKIP
SMART               SMART
SOAPACTION          SOAPACTION
SOAPCALL            SOAPCALL
SORT                SORT
SORTED              SORTED
SQL                 SQL
SQRT                SQRT
STABLE              STABLE
STEPPED             STEPPED
STORED              STORED
STREAMED            STREAMED
SUBSORT             SUBSORT
SUCCESS             SUCCESS
SUM                 SUM
TABLE               TABLE
TAN                 TAN
TANH                TANH
TERMINATOR          TERMINATOR
ESCAPE              ESCAPE
THEN                THEN
THISNODE            THISNODE
THOR                THOR
THRESHOLD           THRESHOLD
TIMEOUT             TIMEOUT
TIMELIMIT           TIMELIMIT
TOKEN               TOKEN
TOJSON              TOJSON
TOPN                TOPN
TOUNICODE           TOUNICODE
TOXML               TOXML
TRACE               TRACE
TRANSFER            TRANSFER
TRANSFORM           TRANSFORM
TRIM                TRIM
TRUNCATE            TRUNCATE
TYPE                TYPE
TYPEOF              TYPEOF
UNICODEORDER        UNICODEORDER
UNGROUP             UNGROUP
UNLIKELY            UNLIKELY
UNORDERED           UNORDERED
UNSORTED            UNSORTED
UNSTABLE            UNSTABLE
UPDATE              UPDATE
USE                 USE
VALIDATE            VALIDATE
VIRTUAL             VIRTUAL
VOLATILE            VOLATILE
WAIT                WAIT
WARNING             TOK_WARNING
WHEN                WHEN
WHICH               WHICH
WHITESPACE          WHITESPACE
WIDTH               WIDTH
WILD                WILD
WITHIN              WITHIN
WHOLE               WHOLE
WORKUNIT            WORKUNIT
XML                 XML_TOKEN
XMLDECODE           XMLDECODE
XMLDEFAULT          XMLDEFAULT
XMLENCODE           XMLENCODE
XMLNS               XMLNS
XMLPROJECT          XMLPROJECT
XMLTEXT             XMLTEXT
XMLUNICODE          XMLUNICODE
XPATH               XPATH

ACTION_FUNCTION	ACTION_FUNCTION
ACTION_ID	ACTION_ID
ALIEN_ID	ALIEN_ID
AND	AND
"&&"	ANDAND
":="	ASSIGN
COMPLEX_MACRO	COMPLEX_MACRO
CORRELATION	CORRELATION
COVARIANCE	COVARIANCE
CPPBODY	CPPBODY
CRC	CRC
DATAROW_FUNCTION	DATAROW_FUNCTION
DATAROW_ID	DATAROW_ID
DATASET_FUNCTION	DATASET_FUNCTION
DATASET_ID	DATASET_ID
DATASET_TYPE_ID	DATASET_TYPE_ID
__DEBUG__	__DEBUG__
DEFINITIONS_MACRO	DEFINITIONS_MACRO
DICTIONARY_FUNCTION	DICTIONARY_FUNCTION
DICTIONARY_ID	DICTIONARY_ID
DICTIONARY_TYPE_ID	DICTIONARY_TYPE_ID
".."	DOTDOT
ENCRYPTED	ENCRYPTED
ENDMACRO	ENDMACRO
ENUM_ID	ENUM_ID
"="	EQ
EVENT_FUNCTION	EVENT_FUNCTION
EVENT_ID	EVENT_ID
FEATURE_ID	FEATURE_ID
"<?>"	FIELD_REF
"<??>"	FIELDS_REF
">="	GE
"=>"	GOESTO
">"	GT
HASH	HASH
HASH32	HASH32
HASH64	HASH64
"#CONSTANT"	HASH_CONSTANT
"#$"	HASH_DOLLAR
"#LINK"	HASH_LINK
HASHMD5	HASHMD5
"#ONWARNING"	HASH_ONWARNING
"#STORED"	HASH_STORED
"#WEBSERVICE"	HASH_WEBSERVICE
"#WORKUNIT"	HASH_WORKUNIT
INNER	INNER
"<="	LE
LIST_DATASET_FUNCTION	LIST_DATASET_FUNCTION
LIST_DATASET_ID	LIST_DATASET_ID
"<"	LT
MACRO	MACRO
MERGE_ATTR	MERGE_ATTR
"!="|"<>"	NE
"~"	NOT
OR	OR
ORDER	ORDER
PARTITION_ATTR	PARTITION_ATTR
PATTERN_FUNCTION	PATTERN_FUNCTION
PATTERN_ID	PATTERN_ID
PATTERN_TYPE_ID	PATTERN_TYPE_ID
RANDOM	RANDOM
RECORD_FUNCTION	RECORD_FUNCTION
RECORD_ID	RECORD_ID
SCOPE_FUNCTION	SCOPE_FUNCTION
SCOPE_ID	SCOPE_ID
SET_TYPE_ID	SET_TYPE_ID
"<<"	SHIFTL
">>"	SHIFTR
SIMPLE_TYPE	SIMPLE_TYPE
SORTLIST_ID	SORTLIST_ID
__STAND_ALONE__	__STAND_ALONE__
__TARGET_PLATFORM__	__TARGET_PLATFORM__
CONST	TOK_CONST
FALSE	TOK_FALSE
IN	TOK_IN
OUT	TOK_OUT
TRUE	TOK_TRUE
TRANSFORM_FUNCTION	TRANSFORM_FUNCTION
TRANSFORM_ID	TRANSFORM_ID
TYPE_ID	TYPE_ID
"(>"	TYPE_LPAREN
"<)"	TYPE_RPAREN
UNSIGNED	UNSIGNED
VALUE_FUNCTION	VALUE_FUNCTION
VALUE_ID	VALUE_ID
VALUE_ID_REF	VALUE_ID_REF
VALUE_MACRO	VALUE_MACRO
VARIANCE	VARIANCE

"+"	'+'
"-"	'-'
"*"	'*'
"/"	'/'
"%"	'%'
"|"	'|'
"^"	'^'
"&"	'&'
"."	'.'
"("	'('
"["	'['
";"	';'
","	','
"$"	'$'
")"	')'
":"	':'
"]"	']'
"{"	'{'
"}"	'}'
"@"	'@'
"?"	'?'

BOOL_CONST	BOOL_CONST
0x{hexdigit}+U?	INTEGER_CONST
{digit}{hexdigit}*XU?	INTEGER_CONST
0b{bindigit}+U?	INTEGER_CONST
{bindigit}+BU?	INTEGER_CONST
{digit}+U?	INTEGER_CONST

[xX]'{hexpairs}'	DATA_CONST

{digit}+(d|D)	REAL_CONST
{digit}+\.{digit}+((e|E)("+"|"-")?{digit}+)?	REAL_CONST
\.{digit}+((e|E)("+"|"-")?{digit}+)?	REAL_CONST

(d|D|q|Q|u|U|v|V)?'([^'\r\n\\]|\\[^\r\n])*(\\)?'	STRING_CONST
\"([^"\r\n]|\\[\"])*(\")?	STRING_CONST


(u|U)(8)?\'([^'\r\n\\]|\\[^\r\n])*'	UNICODE_CONST

[A-Za-z_][A-Za-z0-9_]*	UNKNOWN_ID


%%
