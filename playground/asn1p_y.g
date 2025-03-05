//From: https://github.com/vlm/asn1c/blob/9925dbbda86b436896108439ea3e0a31280a6065/libasn1parser/asn1p_y.y

/*Tokens*/
%token TOK_ABSENT
//%token TOK_ABSTRACT_SYNTAX
%token TOK_ALL
%token TOK_ANY
%token TOK_APPLICATION
%token TOK_AUTOMATIC
%token TOK_BEGIN
%token TOK_BIT
%token TOK_BMPString
%token TOK_BOOLEAN
%token TOK_bstring
%token TOK_BY
%token TOK_capitalreference
%token TOK_CHARACTER
%token TOK_CHOICE
%token TOK_CLASS
%token TOK_COMPONENT
%token TOK_COMPONENTS
%token TOK_CONSTRAINED
%token TOK_CONTAINING
%token TOK_cstring
%token TOK_DEFAULT
%token TOK_DEFINED
%token TOK_DEFINITIONS
%token TOK_DESCENDANTS
%token TOK_EMBEDDED
//%token TOK_ENCODED
%token TOK_ENCODING_CONTROL
%token TOK_END
%token TOK_ENUMERATED
%token TOK_EXCEPT
%token TOK_EXPLICIT
%token TOK_EXPORTS
%token TOK_EXTENSIBILITY
%token TOK_EXTERNAL
%token TOK_ExtValue_BIT_STRING
%token TOK_FALSE
%token TOK_FROM
%token TOK_GeneralizedTime
%token TOK_GeneralString
%token TOK_GraphicString
%token TOK_hstring
%token TOK_IA5String
%token TOK_identifier
%token TOK_IDENTIFIER
%token TOK_IMPLICIT
%token TOK_IMPLIED
%token TOK_IMPORTS
%token TOK_INCLUDES
%token TOK_INSTANCE
%token TOK_INSTRUCTIONS
%token TOK_INTEGER
%token TOK_INTERSECTION
%token TOK_ISO646String
%token TOK_Literal
%token TOK_MAX
%token TOK_MIN
//%token TOK_MINUS_INFINITY
%token TOK_NULL
%token TOK_number
%token TOK_number_negative
%token TOK_NumericString
%token TOK_OBJECT
%token TOK_ObjectDescriptor
%token TOK_OCTET
%token TOK_OF
%token TOK_opaque
%token TOK_OPTIONAL
%token TOK_PATTERN
%token TOK_PDV
//%token TOK_PLUS_INFINITY
%token TOK_PPEQ
%token TOK_PRESENT
%token TOK_PrintableString
%token TOK_PRIVATE
%token TOK_quadruple
%token TOK_REAL
%token TOK_realnumber
%token TOK_RELATIVE_OID
%token TOK_SEQUENCE
%token TOK_SET
%token TOK_SIZE
%token TOK_STRING
%token TOK_SUCCESSORS
%token TOK_SYNTAX
%token TOK_T61String
%token TOK_TAGS
%token TOK_TeletexString
%token TOK_ThreeDots
%token TOK_TRUE
%token TOK_tuple
%token TOK_TwoDots
%token TOK_typefieldreference
//%token TOK_TYPE_IDENTIFIER
%token TOK_typereference
%token TOK_UNION
%token TOK_UNIQUE
%token TOK_UNIVERSAL
%token TOK_UniversalString
%token TOK_UTCTime
%token TOK_UTF8String
%token TOK_valuefieldreference
%token TOK_VBracketLeft
%token TOK_VBracketRight
%token TOK_VideotexString
%token TOK_VisibleString
%token TOK_whitespace
%token TOK_WITH
%token UTF8_BOM

%nonassoc /*1*/ TOK_EXCEPT
%left /*2*/ '^' TOK_INTERSECTION
%left /*3*/ '|' TOK_UNION

%start ParsedGrammar

%%

ParsedGrammar :
	UTF8_BOM ModuleList
	| ModuleList
	;

ModuleList :
	ModuleDefinition
	| ModuleList ModuleDefinition
	;

ModuleDefinition :
	TypeRefName optObjectIdentifier TOK_DEFINITIONS optModuleDefinitionFlags TOK_PPEQ TOK_BEGIN optModuleBody TOK_END
	;

optObjectIdentifier :
	/*empty*/
	| ObjectIdentifier
	;

ObjectIdentifier :
	'{' ObjectIdentifierBody '}'
	| '{' '}'
	;

ObjectIdentifierBody :
	ObjectIdentifierElement
	| ObjectIdentifierBody ObjectIdentifierElement
	;

ObjectIdentifierElement :
	Identifier
	| Identifier '(' TOK_number ')'
	| TOK_number
	;

optModuleDefinitionFlags :
	/*empty*/
	| ModuleDefinitionFlags
	;

ModuleDefinitionFlags :
	ModuleDefinitionFlag
	| ModuleDefinitionFlags ModuleDefinitionFlag
	;

ModuleDefinitionFlag :
	TOK_EXPLICIT TOK_TAGS
	| TOK_IMPLICIT TOK_TAGS
	| TOK_AUTOMATIC TOK_TAGS
	| TOK_EXTENSIBILITY TOK_IMPLIED
	| TOK_capitalreference TOK_INSTRUCTIONS
	;

optModuleBody :
	/*empty*/
	| ModuleBody
	;

ModuleBody :
	optExports optImports AssignmentList
	;

AssignmentList :
	Assignment
	| AssignmentList Assignment
	;

Assignment :
	DataTypeReference
	| ValueAssignment
	| ValueSetTypeAssignment
	| TOK_ENCODING_CONTROL TOK_capitalreference
	| BasicString
	;

optImports :
	/*empty*/
	| ImportsDefinition
	;

ImportsDefinition :
	TOK_IMPORTS optImportsBundleSet ';'
	| TOK_IMPORTS TOK_FROM
	;

optImportsBundleSet :
	/*empty*/
	| ImportsBundleSet
	;

ImportsBundleSet :
	ImportsBundle
	| ImportsBundleSet ImportsBundle
	;

AssignedIdentifier :
	/*empty*/
	| ObjectIdentifier
	;

ImportsBundle :
	ImportsBundleInt ImportSelectionOption
	| ImportsBundleInt
	;

ImportsBundleInt :
	ImportsList TOK_FROM TypeRefName AssignedIdentifier
	;

ImportsList :
	ImportsElement
	| ImportsList ',' ImportsElement
	;

ImportsElement :
	TypeRefName
	| TypeRefName '{' '}'
	| Identifier
	;

ImportSelectionOption :
	TOK_WITH TOK_SUCCESSORS
	| TOK_WITH TOK_DESCENDANTS
	;

optExports :
	/*empty*/
	| ExportsDefinition
	;

ExportsDefinition :
	TOK_EXPORTS ExportsBody ';'
	| TOK_EXPORTS TOK_ALL ';'
	| TOK_EXPORTS ';'
	;

ExportsBody :
	ExportsElement
	| ExportsBody ',' ExportsElement
	;

ExportsElement :
	TypeRefName
	| TypeRefName '{' '}'
	| Identifier
	;

ValueSet :
	'{' ElementSetSpecs '}'
	;

ValueSetTypeAssignment :
	TypeRefName Type TOK_PPEQ ValueSet
	;

DefinedType :
	ComplexTypeReference
	| ComplexTypeReference '{' ActualParameterList '}'
	;

DataTypeReference :
	TypeRefName TOK_PPEQ Type
	| TypeRefName TOK_PPEQ ObjectClass
	| TypeRefName '{' ParameterArgumentList '}' TOK_PPEQ Type
	| TypeRefName '{' ParameterArgumentList '}' TOK_PPEQ ObjectClass
	;

ParameterArgumentList :
	ParameterArgumentName
	| ParameterArgumentList ',' ParameterArgumentName
	;

ParameterArgumentName :
	TypeRefName
	| TypeRefName ':' Identifier
	| TypeRefName ':' TypeRefName
	| BasicTypeId ':' Identifier
	| BasicTypeId ':' TypeRefName
	;

ActualParameterList :
	ActualParameter
	| ActualParameterList ',' ActualParameter
	;

ActualParameter :
	UntaggedType
	| SimpleValue
	| DefinedValue
	| ValueSet
	;

optComponentTypeLists :
	/*empty*/
	| ComponentTypeLists
	;

ComponentTypeLists :
	ComponentType
	| ComponentTypeLists ',' ComponentType
	| ComponentTypeLists ',' TOK_VBracketLeft ComponentTypeLists TOK_VBracketRight
	;

ComponentType :
	Identifier MaybeIndirectTaggedType optMarker
	| MaybeIndirectTaggedType optMarker
	| TOK_COMPONENTS TOK_OF MaybeIndirectTaggedType
	| ExtensionAndException
	;

AlternativeTypeLists :
	AlternativeType
	| AlternativeTypeLists ',' AlternativeType
	| AlternativeTypeLists ',' TOK_VBracketLeft AlternativeTypeLists TOK_VBracketRight
	;

AlternativeType :
	Identifier MaybeIndirectTaggedType
	| ExtensionAndException
	| MaybeIndirectTaggedType
	;

ObjectClass :
	TOK_CLASS '{' FieldSpec '}' optWithSyntax
	;

optUNIQUE :
	/*empty*/
	| TOK_UNIQUE
	;

FieldSpec :
	ClassField
	| FieldSpec ',' ClassField
	;

ClassField :
	TOK_typefieldreference optMarker
	| TOK_valuefieldreference Type optUNIQUE optMarker
	| TOK_valuefieldreference FieldName optMarker
	| TOK_valuefieldreference DefinedObjectClass optMarker
	| TOK_typefieldreference FieldName optMarker
	| TOK_typefieldreference Type optMarker
	| TOK_typefieldreference DefinedObjectClass optMarker
	;

optWithSyntax :
	/*empty*/
	| WithSyntax
	;

WithSyntax :
	TOK_WITH TOK_SYNTAX '{' WithSyntaxList '}'
	;

WithSyntaxList :
	WithSyntaxToken
	| WithSyntaxList WithSyntaxToken
	;

WithSyntaxToken :
	TOK_whitespace
	| TOK_Literal
	| PrimitiveFieldReference
	| '[' WithSyntaxList ']'
	;

ExtensionAndException :
	TOK_ThreeDots
	| TOK_ThreeDots '!' DefinedValue
	| TOK_ThreeDots '!' SignedNumber
	;

Type :
	TaggedType
	;

TaggedType :
	optTag UntaggedType
	;

DefinedUntaggedType :
	DefinedType optManyConstraints
	;

UntaggedType :
	TypeDeclaration optManyConstraints
	;

MaybeIndirectTaggedType :
	optTag MaybeIndirectTypeDeclaration optManyConstraints
	;

NSTD_IndirectMarker :
	/*empty*/
	;

MaybeIndirectTypeDeclaration :
	NSTD_IndirectMarker TypeDeclaration
	;

TypeDeclaration :
	ConcreteTypeDeclaration
	| DefinedType
	;

ConcreteTypeDeclaration :
	BuiltinType
	| TOK_CHOICE '{' AlternativeTypeLists '}'
	| TOK_SEQUENCE '{' optComponentTypeLists '}'
	| TOK_SET '{' optComponentTypeLists '}'
	| TOK_SEQUENCE optSizeOrConstraint TOK_OF optIdentifier optTag MaybeIndirectTypeDeclaration
	| TOK_SET optSizeOrConstraint TOK_OF optIdentifier optTag MaybeIndirectTypeDeclaration
	| TOK_ANY
	| TOK_ANY TOK_DEFINED TOK_BY Identifier
	| TOK_INSTANCE TOK_OF ComplexTypeReference
	;

ComplexTypeReference :
	TOK_typereference
	| TOK_capitalreference
	| TOK_typereference '.' TypeRefName
	| TOK_capitalreference '.' TypeRefName
	| TOK_capitalreference '.' ComplexTypeReferenceAmpList
	;

ComplexTypeReferenceAmpList :
	ComplexTypeReferenceElement
	| ComplexTypeReferenceAmpList '.' ComplexTypeReferenceElement
	;

ComplexTypeReferenceElement :
	PrimitiveFieldReference
	;

PrimitiveFieldReference :
	TOK_typefieldreference
	| TOK_valuefieldreference
	;

FieldName :
	TOK_typefieldreference
	| FieldName '.' TOK_typefieldreference
	| FieldName '.' TOK_valuefieldreference
	;

DefinedObjectClass :
	TOK_capitalreference
	;

ValueAssignment :
	Identifier Type TOK_PPEQ Value
	;

Value :
	SimpleValue
	| DefinedValue
	| '{' Opaque
	;

SimpleValue :
	TOK_NULL
	| TOK_FALSE
	| TOK_TRUE
	| SignedNumber
	| RealValue
	| RestrictedCharacterStringValue
	| BitStringValue
	;

DefinedValue :
	IdentifierAsValue
	| TypeRefName '.' Identifier
	;

RestrictedCharacterStringValue :
	TOK_cstring
	| TOK_tuple
	| TOK_quadruple
	;

Opaque :
	OpaqueFirstToken
	| Opaque TOK_opaque
	;

OpaqueFirstToken :
	TOK_opaque
	| Identifier
	;

BasicTypeId :
	TOK_BOOLEAN
	| TOK_NULL
	| TOK_REAL
	| TOK_OCTET TOK_STRING
	| TOK_OBJECT TOK_IDENTIFIER
	| TOK_RELATIVE_OID
	| TOK_EXTERNAL
	| TOK_EMBEDDED TOK_PDV
	| TOK_CHARACTER TOK_STRING
	| TOK_UTCTime
	| TOK_GeneralizedTime
	| BasicString
	| BasicTypeId_UniverationCompatible
	;

BasicTypeId_UniverationCompatible :
	TOK_INTEGER
	| TOK_ENUMERATED
	| TOK_BIT TOK_STRING
	;

BuiltinType :
	BasicTypeId
	| TOK_INTEGER '{' NamedNumberList '}'
	| TOK_ENUMERATED '{' Enumerations '}'
	| TOK_BIT TOK_STRING '{' NamedBitList '}'
	| TOK_ExtValue_BIT_STRING '{' IdentifierList '}'
	| TOK_ExtValue_BIT_STRING '{' '}'
	;

BasicString :
	TOK_BMPString
	| TOK_GeneralString
	| TOK_GraphicString
	| TOK_IA5String
	| TOK_ISO646String
	| TOK_NumericString
	| TOK_PrintableString
	| TOK_T61String
	| TOK_TeletexString
	| TOK_UniversalString
	| TOK_UTF8String
	| TOK_VideotexString
	| TOK_VisibleString
	| TOK_ObjectDescriptor
	;

UnionMark :
	'|' /*3L*/
	| TOK_UNION /*3L*/
	;

IntersectionMark :
	'^' /*2L*/
	| TOK_INTERSECTION /*2L*/
	;

optConstraint :
	/*empty*/
	| Constraint
	;

optManyConstraints :
	/*empty*/
	| ManyConstraints
	;

optSizeOrConstraint :
	/*empty*/
	| Constraint
	| SizeConstraint
	;

Constraint :
	'(' ConstraintSpec ')'
	;

ManyConstraints :
	Constraint
	| ManyConstraints Constraint
	;

ConstraintSpec :
	SubtypeConstraint
	| GeneralConstraint
	;

SubtypeConstraint :
	ElementSetSpecs
	;

ElementSetSpecs :
	TOK_ThreeDots
	| ElementSetSpec
	| ElementSetSpec ',' TOK_ThreeDots
	| ElementSetSpec ',' TOK_ThreeDots ',' ElementSetSpec
	;

ElementSetSpec :
	Unions
	| TOK_ALL TOK_EXCEPT /*1N*/ Elements
	;

Unions :
	Intersections
	| Unions UnionMark Intersections
	;

Intersections :
	IntersectionElements
	| Intersections IntersectionMark IntersectionElements
	;

IntersectionElements :
	Elements
	| Elements TOK_EXCEPT /*1N*/ Elements
	;

Elements :
	SubtypeElements
	| '(' ElementSetSpec ')'
	;

SubtypeElements :
	SingleValue
	| ContainedSubtype
	| PermittedAlphabet
	| SizeConstraint
	| InnerTypeConstraints
	| PatternConstraint
	| ValueRange
	;

PermittedAlphabet :
	TOK_FROM Constraint
	;

SizeConstraint :
	TOK_SIZE Constraint
	;

PatternConstraint :
	TOK_PATTERN TOK_cstring
	| TOK_PATTERN Identifier
	;

ValueRange :
	LowerEndValue ConstraintRangeSpec UpperEndValue
	;

LowerEndValue :
	SingleValue
	| TOK_MIN
	;

UpperEndValue :
	SingleValue
	| TOK_MAX
	;

SingleValue :
	Value
	;

BitStringValue :
	TOK_bstring
	| TOK_hstring
	;

ContainedSubtype :
	TOK_INCLUDES Type
	| DefinedUntaggedType
	;

InnerTypeConstraints :
	TOK_WITH TOK_COMPONENT SingleTypeConstraint
	| TOK_WITH TOK_COMPONENTS MultipleTypeConstraints
	;

SingleTypeConstraint :
	Constraint
	;

MultipleTypeConstraints :
	FullSpecification
	| PartialSpecification
	;

FullSpecification :
	'{' TypeConstraints '}'
	;

PartialSpecification :
	'{' TOK_ThreeDots ',' TypeConstraints '}'
	;

TypeConstraints :
	NamedConstraint
	| TypeConstraints ',' NamedConstraint
	;

NamedConstraint :
	IdentifierAsValue optConstraint optPresenceConstraint
	;

optPresenceConstraint :
	/*empty*/
	| PresenceConstraint
	;

PresenceConstraint :
	TOK_PRESENT
	| TOK_ABSENT
	| TOK_OPTIONAL
	;

GeneralConstraint :
	UserDefinedConstraint
	| TableConstraint
	| ContentsConstraint
	;

UserDefinedConstraint :
	TOK_CONSTRAINED TOK_BY '{' Opaque
	;

ContentsConstraint :
	TOK_CONTAINING Type
	;

ConstraintRangeSpec :
	TOK_TwoDots
	| TOK_TwoDots '<'
	| '<' TOK_TwoDots
	| '<' TOK_TwoDots '<'
	;

TableConstraint :
	SimpleTableConstraint
	| ComponentRelationConstraint
	;

SimpleTableConstraint :
	'{' TypeRefName '}'
	;

ComponentRelationConstraint :
	SimpleTableConstraint '{' AtNotationList '}'
	;

AtNotationList :
	AtNotationElement
	| AtNotationList ',' AtNotationElement
	;

AtNotationElement :
	'@' ComponentIdList
	| '@' '.' ComponentIdList
	;

ComponentIdList :
	Identifier
	| ComponentIdList '.' Identifier
	;

optMarker :
	/*empty*/
	| Marker
	;

Marker :
	TOK_OPTIONAL
	| TOK_DEFAULT Value
	;

IdentifierList :
	IdentifierElement
	| IdentifierList ',' IdentifierElement
	;

IdentifierElement :
	Identifier
	;

NamedNumberList :
	NamedNumber
	| NamedNumberList ',' NamedNumber
	;

NamedNumber :
	Identifier '(' SignedNumber ')'
	| Identifier '(' DefinedValue ')'
	;

NamedBitList :
	NamedBit
	| NamedBitList ',' NamedBit
	;

NamedBit :
	Identifier '(' TOK_number ')'
	| Identifier '(' DefinedValue ')'
	;

Enumerations :
	UniverationList
	;

UniverationList :
	UniverationElement
	| UniverationList ',' UniverationElement
	;

UniverationElement :
	Identifier
	| Identifier '(' SignedNumber ')'
	| Identifier '(' DefinedValue ')'
	| SignedNumber
	| TOK_ThreeDots
	;

SignedNumber :
	TOK_number
	| TOK_number_negative
	;

RealValue :
	TOK_realnumber
	;

optTag :
	/*empty*/
	| Tag
	;

Tag :
	TagTypeValue TagPlicit
	;

TagTypeValue :
	'[' TagClass TOK_number ']'
	;

TagClass :
	/*empty*/
	| TOK_UNIVERSAL
	| TOK_APPLICATION
	| TOK_PRIVATE
	;

TagPlicit :
	/*empty*/
	| TOK_IMPLICIT
	| TOK_EXPLICIT
	;

TypeRefName :
	TOK_typereference
	| TOK_capitalreference
	;

optIdentifier :
	/*empty*/
	| Identifier
	;

Identifier :
	TOK_identifier
	;

IdentifierAsReference :
	Identifier
	;

IdentifierAsValue :
	IdentifierAsReference
	;

%%

//%x dash_comment
//%x idash_comment
//%x cpp_comment
//%x quoted
//%x opaque
//%x encoding_control
//%x with_syntax
//%x extended_values

/* Newline */
NL	[\r\v\f\n]
/* White-space */
WSP	[\t\r\v\f\n ]

%%

"/*"(?s:.)*?"*/"    skip()
"--".*  skip()

"\xef\xbb\xbf"		UTF8_BOM


'[0-9A-F \t\r\v\f\n]+'H TOK_hstring
		/* " \t\r\n" weren't allowed in ASN.1:1990. */

'[01 \t\r\v\f\n]+'B	TOK_bstring
		/* " \t\r\n" weren't allowed in ASN.1:1990. */

-[1-9][0-9]*	TOK_number_negative

[1-9][0-9]*	TOK_number

"0"	TOK_number

[-+]?[0-9]+[.]?([eE][-+]?)?[0-9]+ TOK_realnumber

"^"	'^'
"<"	'<'
"|"	'|'
","	','
";"	';'
":"	':'
"!"	'!'
"."	'.'
"("	'('
")"	')'
"["	'['
"]"	']'
"{"	'{'
"}"	'}'
"@"	'@'

TOK_cstring	TOK_cstring
TOK_ExtValue_BIT_STRING	TOK_ExtValue_BIT_STRING
TOK_Literal	TOK_Literal
TOK_opaque	TOK_opaque
TOK_whitespace	TOK_whitespace

ABSENT			TOK_ABSENT
ALL			TOK_ALL
ANY			TOK_ANY
				/* Appeared in 1990, removed in 1997 */
APPLICATION		TOK_APPLICATION
AUTOMATIC		TOK_AUTOMATIC
BEGIN			TOK_BEGIN
BIT			TOK_BIT
BMPString		TOK_BMPString
BOOLEAN			TOK_BOOLEAN
BY			TOK_BY
CHARACTER		TOK_CHARACTER
CHOICE			TOK_CHOICE
CLASS			TOK_CLASS
COMPONENT		TOK_COMPONENT
COMPONENTS		TOK_COMPONENTS
CONSTRAINED		TOK_CONSTRAINED
CONTAINING		TOK_CONTAINING
DEFAULT			TOK_DEFAULT
DEFINED			TOK_DEFINED
				/* Appeared in 1990, removed in 1997 */
DEFINITIONS		 TOK_DEFINITIONS
EMBEDDED		 TOK_EMBEDDED
//ENCODED			 TOK_ENCODED
ENCODING-CONTROL	 TOK_ENCODING_CONTROL
END			TOK_END
ENUMERATED		 TOK_ENUMERATED
EXCEPT			 TOK_EXCEPT
EXPLICIT		 TOK_EXPLICIT
EXPORTS			 TOK_EXPORTS
EXTENSIBILITY		 TOK_EXTENSIBILITY
EXTERNAL		 TOK_EXTERNAL
FALSE			 TOK_FALSE
FROM			 TOK_FROM
GeneralizedTime		 TOK_GeneralizedTime
GeneralString		 TOK_GeneralString
GraphicString		 TOK_GraphicString
IA5String		 TOK_IA5String
IDENTIFIER		 TOK_IDENTIFIER
IMPLICIT		 TOK_IMPLICIT
IMPLIED			 TOK_IMPLIED
IMPORTS			 TOK_IMPORTS
INCLUDES		 TOK_INCLUDES
INSTANCE		 TOK_INSTANCE
INSTRUCTIONS		 TOK_INSTRUCTIONS
INTEGER			 TOK_INTEGER
INTERSECTION		 TOK_INTERSECTION
ISO646String		 TOK_ISO646String
MAX			 TOK_MAX
MIN			 TOK_MIN
//MINUS-INFINITY		 TOK_MINUS_INFINITY
NULL			 TOK_NULL
NumericString		 TOK_NumericString
OBJECT			 TOK_OBJECT
ObjectDescriptor	 TOK_ObjectDescriptor
OCTET			 TOK_OCTET
OF			 TOK_OF
OPTIONAL		 TOK_OPTIONAL
PATTERN			 TOK_PATTERN
PDV			 TOK_PDV
//PLUS-INFINITY		 TOK_PLUS_INFINITY
PRESENT			 TOK_PRESENT
PrintableString		 TOK_PrintableString
PRIVATE			 TOK_PRIVATE
REAL			 TOK_REAL
RELATIVE-OID		 TOK_RELATIVE_OID
SEQUENCE		 TOK_SEQUENCE
SET			 TOK_SET
SIZE			 TOK_SIZE
STRING			 TOK_STRING
SYNTAX			 TOK_SYNTAX
T61String		 TOK_T61String
TAGS			 TOK_TAGS
TeletexString		 TOK_TeletexString
TRUE			 TOK_TRUE
UNION			 TOK_UNION
UNIQUE			 TOK_UNIQUE
UNIVERSAL		 TOK_UNIVERSAL
UniversalString		TOK_UniversalString
UTCTime			 TOK_UTCTime
UTF8String		TOK_UTF8String
VideotexString		 TOK_VideotexString
VisibleString		 TOK_VisibleString
WITH			 TOK_WITH
SUCCESSORS		TOK_SUCCESSORS
DESCENDANTS		TOK_DESCENDANTS

&[A-Z][A-Za-z0-9]*([-][A-Za-z0-9]+)*	TOK_typefieldreference
&[a-z][a-zA-Z0-9]*([-][a-zA-Z0-9]+)*	TOK_valuefieldreference

[a-z][a-zA-Z0-9]*([-][a-zA-Z0-9]+)*	TOK_identifier

	/*
	 * objectclassreference
	 */
[A-Z][A-Z0-9]*([-][A-Z0-9]+)*	TOK_capitalreference

	/*
	 * typereference, modulereference
	 * NOTE: TOK_objectclassreference must be combined
	 * with this token to produce true typereference.
	 */
[A-Z][A-Za-z0-9]*([-][A-Za-z0-9]+)*	TOK_typereference

"::="		TOK_PPEQ

"..."		 TOK_ThreeDots
".."		 TOK_TwoDots


{WSP}+	skip() /* Ignore whitespace */


[{][\t\r\v\f\n ]*[0-7][,][\t\r\v\f\n ]*[0-9]+[\t\r\v\f\n ]*[}]	TOK_tuple

[{][\t\r\v\f\n ]*[0-9]+[,][\t\r\v\f\n ]*[0-9]+[,][\t\r\v\f\n ]*[0-9]+[,][\t\r\v\f\n ]*[0-9]+[\t\r\v\f\n ]*[}]	TOK_quadruple

"[["         TOK_VBracketLeft
"]]"         TOK_VBracketRight

%%
