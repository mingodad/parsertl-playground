//From: https://github.com/gobo-eiffel/gobo/blob/cff52cc187a38d53318d14cd146aeca316bf664b/library/xml/src/parser/eiffel/xm_eiffel_parser.y
/*
note

	description:

		"XML parsers using a native Eiffel parser"

	implements: "XML 1.0 (Second Edition) - W3C Recommendation 6 October 2000"

	library: "Gobo Eiffel XML Library"
	copyright: "Copyright (c) 2002-2019, Eric Bezault and others"
	license: "MIT License"

class XM_EIFFEL_PARSER

inherit

	XM_EIFFEL_PARSER_SKELETON

create

	make

*/

//-- TODO:
//-- character classes validation: external
//-- pi: should have space after PI_TARGET?
//-- getting error messages from scanner
//-- check no external entity or DTD for standalone docs
//-- xml declaration in external entities
//-- DTD external id lacks base

/*Tokens*/
%token NAME
%token NAME_UTF8
%token NMTOKEN
%token NMTOKEN_UTF8
%token EQ
%token SPACE
%token APOS
%token QUOT
%token CHARDATA
%token CHARDATA_UTF8
%token COMMENT_START
%token COMMENT_END
%token COMMENT_DASHDASH
%token PI_START
%token PI_TARGET
%token PI_TARGET_UTF8
%token PI_END
%token PI_RESERVED
%token XMLDECLARATION_START
%token XMLDECLARATION_END
%token XMLDECLARATION_VERSION
%token XMLDECLARATION_VERSION_10
%token XMLDECLARATION_STANDALONE
%token XMLDECLARATION_STANDALONE_YES
%token XMLDECLARATION_STANDALONE_NO
%token XMLDECLARATION_ENCODING
%token XMLDECLARATION_ENCODING_VALUE
%token CDATA_START
%token CDATA_END
%token DOCTYPE_START
%token DOCTYPE_END
%token DOCTYPE_DECLARATION_START
%token DOCTYPE_DECLARATION_END
%token DOCTYPE_ELEMENT_EMPTY
%token DOCTYPE_ELEMENT_ANY
%token DOCTYPE_ELEMENT
%token DOCTYPE_ATTLIST
%token DOCTYPE_ENTITY
%token DOCTYPE_NOTATION
%token DOCTYPE_GROUP_START
%token DOCTYPE_GROUP_END
%token DOCTYPE_GROUP_OR
%token DOCTYPE_GROUP_SEQ
%token DOCTYPE_GROUP_ZEROONE
%token DOCTYPE_GROUP_ANY
%token DOCTYPE_GROUP_ONEMORE
%token DOCTYPE_PCDATA
%token DOCTYPE_PUBLIC
%token DOCTYPE_SYSTEM
%token DOCTYPE_SYSTEM_UTF8
%token DOCTYPE_REQUIRED
%token DOCTYPE_IMPLIED
%token DOCTYPE_FIXED
%token DOCTYPE_ATT_CDATA
%token DOCTYPE_ATT_ID
%token DOCTYPE_ATT_IDREF
%token DOCTYPE_ATT_IDREFS
%token DOCTYPE_ATT_ENTITY
%token DOCTYPE_ATT_ENTITIES
%token DOCTYPE_ATT_NMTOKEN
%token DOCTYPE_ATT_NMTOKENS
%token DOCTYPE_ATT_NOTATION
%token DOCTYPE_PERCENT
%token DOCTYPE_PEREFERENCE
%token DOCTYPE_PEREFERENCE_UTF8
%token ENTITYVALUE_PEREFERENCE
%token ENTITYVALUE_PEREFERENCE_UTF8
%token DOCTYPE_IGNORE
%token DOCTYPE_INCLUDE
%token DOCTYPE_NDATA
%token DOCTYPE_NAME
%token DOCTYPE_CONDITIONAL_START
%token DOCTYPE_CONDITIONAL_END
//%token DOCTYPE_CONDITIONAL_IGNORE
%token VALUE_START
%token VALUE_END
%token TAG_START
%token TAG_START_END
%token TAG_END_EMPTY
%token TAG_END
%token TAG_NAME_FIRST
%token TAG_NAME_FIRST_UTF8
%token TAG_NAME_ATOM
%token TAG_NAME_ATOM_UTF8
%token TAG_NAME_COLON
%token CONTENT_ENTITY
%token CONTENT_ENTITY_UTF8
%token CONTENT_CONDITIONAL_END
%token ATTRIBUTE_ENTITY
%token ATTRIBUTE_ENTITY_UTF8
%token ATTRIBUTE_LT
//%token ENTITY_INVALID
//%token INPUT_INVALID


%start document

%%

document :
	prolog element misc_maybe
	;

namespace_name :
	tagname_first
	| TAG_NAME_COLON
	| TAG_NAME_COLON namespace_name_second
	| namespace_name TAG_NAME_COLON namespace_name_second
	| namespace_name TAG_NAME_COLON
	;

namespace_name_second :
	tagname_atom
	| tagname_first
	;

char_data :
	CHARDATA
	| CHARDATA_UTF8
	;

tagname_first :
	TAG_NAME_FIRST
	| TAG_NAME_FIRST_UTF8
	;

tagname_atom :
	TAG_NAME_ATOM
	| TAG_NAME_ATOM_UTF8
	;

nm_token :
	doctype_name
	| NMTOKEN
	| NMTOKEN_UTF8
	;

name_token :
	NAME
	| NAME_UTF8
	;

pi_target_token :
	PI_TARGET
	| PI_TARGET_UTF8
	;

doctype_pe_reference :
	DOCTYPE_PEREFERENCE
	| DOCTYPE_PEREFERENCE_UTF8
	;

entityvalue_pe_reference :
	ENTITYVALUE_PEREFERENCE
	| ENTITYVALUE_PEREFERENCE_UTF8
	;

doctype_system_token :
	DOCTYPE_SYSTEM
	| DOCTYPE_SYSTEM_UTF8
	;

doctype_name :
	name_token
	| DOCTYPE_ATT_CDATA
	| DOCTYPE_ATT_ID
	| DOCTYPE_ATT_IDREF
	| DOCTYPE_ATT_IDREFS
	| DOCTYPE_ATT_ENTITY
	| DOCTYPE_ATT_ENTITIES
	| DOCTYPE_ATT_NMTOKEN
	| DOCTYPE_ATT_NMTOKENS
	| DOCTYPE_ATT_NOTATION
	| DOCTYPE_ELEMENT_EMPTY
	| DOCTYPE_ELEMENT_ANY
	| DOCTYPE_IGNORE
	| DOCTYPE_INCLUDE
	| DOCTYPE_NDATA
	;

maybe_space :
	/*empty*/
	| req_space
	;

req_space :
	space_item
	| req_space space_item
	;

space_item :
	SPACE
	| doctype_pe_reference
	;

entity_value :
	VALUE_START VALUE_END
	| VALUE_START entity_value_trail_item VALUE_END
	| VALUE_START entity_value_trail VALUE_END
	;

entity_value_trail :
	entity_value_trail_item entity_value_trail_item
	| entity_value_trail entity_value_trail_item
	;

entity_value_trail_item :
	char_data
	| entity_value_reference
	;

entity_value_reference :
	entityvalue_pe_reference
	;

att_value :
	VALUE_START VALUE_END
	| VALUE_START att_value_trail_item VALUE_END
	| VALUE_START att_value_trail VALUE_END
	;

att_value_trail :
	att_value_trail_item att_value_trail_item
	| att_value_trail att_value_trail_item
	;

att_value_trail_item :
	char_data
	| value_reference
	| ATTRIBUTE_LT
	;

value_reference :
	ATTRIBUTE_ENTITY
	| ATTRIBUTE_ENTITY_UTF8
	;

comment :
	COMMENT_START comment_content COMMENT_END
	| COMMENT_START COMMENT_END
	;

dtd_comment :
	COMMENT_START comment_content COMMENT_END
	| COMMENT_START COMMENT_END
	;

comment_content :
	comment_content_item
	| comment_content_trail
	;

comment_content_trail :
	comment_content_item comment_content_item
	| comment_content_trail comment_content_item
	;

comment_content_item :
	char_data
	| COMMENT_DASHDASH
	;

pi :
	PI_START pi_target_token req_space pi_content PI_END
	| PI_START pi_target_token maybe_space PI_END
	| PI_RESERVED
	;

dtd_pi :
	PI_START pi_target_token req_space pi_content PI_END
	| PI_START pi_target_token maybe_space PI_END
	| PI_RESERVED
	;

pi_content :
	pi_content_first pi_content_item
	| pi_content_first pi_content_trail
	| pi_content_first
	;

pi_content_trail :
	pi_content_item pi_content_item
	| pi_content_trail pi_content_item
	;

pi_content_item :
	char_data
	| pi_target_token
	| SPACE
	;

pi_content_first :
	char_data
	| pi_target_token
	;

cd_sect :
	CDATA_START CDATA_END
	| CDATA_START cdata_body CDATA_END
	;

cdata_body :
	cdata_body_item
	| cdata_body cdata_body_item
	;

cdata_body_item :
	char_data
	;

prolog :
	xml_decl_misc doctype_decl_misc
	;

xml_decl_misc :
	misc_maybe
	| xml_decl
	| xml_decl misc_trail
	;

doctype_decl_misc :
	/*empty*/
	| doctype_decl
	| doctype_decl misc_trail
	;

misc_maybe :
	/*empty*/
	| misc_trail
	;

misc_trail :
	misc
	| misc_trail misc
	;

xml_decl :
	XMLDECLARATION_START version_info xml_decl_opt XMLDECLARATION_END
	//| XMLDECLARATION_START error
	;

xml_decl_opt :
	maybe_space
	| req_space sd_decl maybe_space
	| req_space encoding_decl maybe_space
	| req_space encoding_decl req_space sd_decl maybe_space
	;

space_eq :
	EQ
	| SPACE EQ
	| EQ SPACE
	| SPACE EQ SPACE
	;

version_info :
	XMLDECLARATION_VERSION space_eq APOS XMLDECLARATION_VERSION_10 APOS
	| XMLDECLARATION_VERSION space_eq QUOT XMLDECLARATION_VERSION_10 QUOT
	;

misc :
	comment
	| pi
	| SPACE
	;

doctype_decl :
	doctype_decl_internal
	| doctype_decl_external doctype_decl_dtd
	;

doctype_decl_internal_name :
	doctype_name maybe_space
	;

doctype_decl_internal :
	DOCTYPE_START req_space doctype_decl_internal_name doctype_decl_declaration DOCTYPE_END
	;

doctype_decl_external_name :
	doctype_name req_space external_id maybe_space
	;

doctype_decl_external :
	DOCTYPE_START req_space doctype_decl_external_name doctype_decl_declaration DOCTYPE_END
	;

doctype_decl_dtd :
	DOCTYPE_DECLARATION_START text_decl doctype_decl_dtd_content DOCTYPE_DECLARATION_END
	;

doctype_decl_dtd_content :
	/*empty*/
	| doctype_decl_dtd_items
	;

doctype_decl_dtd_items :
	doctype_decl_dtd_item
	| doctype_decl_dtd_items doctype_decl_dtd_item
	;

doctype_decl_dtd_item :
	markup_decl
	| conditional_sect
	;

doctype_decl_declaration :
	/*empty*/
	| DOCTYPE_DECLARATION_START DOCTYPE_DECLARATION_END maybe_space
	| DOCTYPE_DECLARATION_START doctype_decl_declaration_content DOCTYPE_DECLARATION_END maybe_space
	;

doctype_decl_declaration_content :
	markup_decl
	| doctype_decl_declaration_content markup_decl
	;

markup_decl :
	element_decl
	| attlist_decl
	| entity_decl
	| notation_decl
	| dtd_pi
	| dtd_comment
	| SPACE
	| doctype_pe_reference
	;

sd_decl :
	XMLDECLARATION_STANDALONE space_eq APOS XMLDECLARATION_STANDALONE_YES APOS
	| XMLDECLARATION_STANDALONE space_eq QUOT XMLDECLARATION_STANDALONE_YES QUOT
	| XMLDECLARATION_STANDALONE space_eq APOS XMLDECLARATION_STANDALONE_NO APOS
	| XMLDECLARATION_STANDALONE space_eq QUOT XMLDECLARATION_STANDALONE_NO QUOT
	;

element :
	empty_elem_tag
	| s_tag e_tag
	| s_tag content e_tag
	//| s_tag content error
	//| s_tag error
	;

s_tag :
	TAG_START s_tag_name TAG_END
	| TAG_START s_tag_name req_space s_tag_trail TAG_END
	//| TAG_START error
	;

empty_elem_tag :
	TAG_START s_tag_name TAG_END_EMPTY
	| TAG_START s_tag_name req_space s_tag_trail TAG_END_EMPTY
	;

s_tag_name :
	namespace_name
	;

s_tag_trail :
	attribute
	| s_tag_trail req_space attribute
	;

attribute :
	namespace_name EQ att_value
	//| namespace_name error
	;

e_tag :
	TAG_START_END namespace_name TAG_END
	//| TAG_START_END error
	;

content :
	content_item
	| content content_item
	;

content_item :
	content_text
	| cd_sect
	| element
	| pi
	| comment
	| CONTENT_CONDITIONAL_END
	| entity_in_content
	;

entity_in_content :
	CONTENT_ENTITY
	| CONTENT_ENTITY_UTF8
	| XMLDECLARATION_END
	;

content_text :
	char_data
	| SPACE
	;

element_decl :
	DOCTYPE_ELEMENT req_space doctype_name req_space content_spec DOCTYPE_END
	//| DOCTYPE_ELEMENT error
	;

content_spec :
	DOCTYPE_ELEMENT_EMPTY maybe_space
	| DOCTYPE_ELEMENT_ANY maybe_space
	| mixed maybe_space
	| children
	;

children :
	choice maybe_space
	| choice repetition
	| seq maybe_space
	| seq repetition
	;

cp :
	doctype_name_space
	| doctype_name repetition
	| choice maybe_space
	| choice repetition
	| seq maybe_space
	| seq repetition
	;

repetition :
	DOCTYPE_GROUP_ANY maybe_space
	| DOCTYPE_GROUP_ONEMORE maybe_space
	| DOCTYPE_GROUP_ZEROONE maybe_space
	;

choice :
	group_start cp group_or choice_trail group_end
	;

choice_trail :
	cp
	| choice_trail group_or cp
	;

seq :
	group_start seq_trail group_end
	;

seq_trail :
	cp
	| seq_trail group_seq cp
	;

mixed :
	group_start pc_data group_end
	| group_start pc_data group_end DOCTYPE_GROUP_ANY
	| group_start pc_data group_or mixed_trail group_end DOCTYPE_GROUP_ANY
	;

mixed_trail :
	doctype_name_space
	| mixed_trail group_or doctype_name_space
	;

doctype_name_space :
	DOCTYPE_NAME maybe_space
	;

group_start :
	DOCTYPE_GROUP_START maybe_space
	;

group_or :
	DOCTYPE_GROUP_OR maybe_space
	;

group_seq :
	DOCTYPE_GROUP_SEQ maybe_space
	;

group_end :
	DOCTYPE_GROUP_END
	;

pc_data :
	DOCTYPE_PCDATA maybe_space
	;

attlist_decl :
	DOCTYPE_ATTLIST req_space doctype_name maybe_space DOCTYPE_END
	| DOCTYPE_ATTLIST req_space doctype_name attlist_decl_trail maybe_space DOCTYPE_END
	//| DOCTYPE_ATTLIST error
	;

attlist_decl_trail :
	att_def
	| attlist_decl_trail att_def
	;

att_def :
	req_space doctype_name req_space att_type req_space default_decl
	//| req_space doctype_name error
	;

att_type :
	DOCTYPE_ATT_CDATA
	| att_tokenized_type
	| enumerated_type
	;

att_tokenized_type :
	DOCTYPE_ATT_ID
	| DOCTYPE_ATT_IDREF
	| DOCTYPE_ATT_IDREFS
	| DOCTYPE_ATT_ENTITY
	| DOCTYPE_ATT_ENTITIES
	| DOCTYPE_ATT_NMTOKEN
	| DOCTYPE_ATT_NMTOKENS
	;

enumerated_type :
	notation_type
	| enumeration
	;

notation_type :
	DOCTYPE_ATT_NOTATION req_space group_start notation_type_trail DOCTYPE_GROUP_END
	;

notation_type_trail :
	doctype_name_space
	| notation_type_trail group_or doctype_name_space
	;

enumeration :
	group_start enumeration_trail group_end
	;

enumeration_trail :
	nm_token maybe_space
	| enumeration_trail group_or nm_token maybe_space
	;

default_decl :
	DOCTYPE_REQUIRED
	| DOCTYPE_IMPLIED
	| DOCTYPE_FIXED req_space att_value
	| att_value
	;

conditional_sect :
	include_sect
	| ignore_sect
	//| DOCTYPE_CONDITIONAL_START error
	;

include_sect :
	include_header DOCTYPE_CONDITIONAL_END
	| include_header doctype_decl_dtd_items DOCTYPE_CONDITIONAL_END
	;

include_header :
	DOCTYPE_CONDITIONAL_START maybe_space DOCTYPE_INCLUDE maybe_space DOCTYPE_DECLARATION_START
	;

ignore_sect :
	ignore_header ignore_sect_content DOCTYPE_CONDITIONAL_END
	;

ignore_header :
	DOCTYPE_CONDITIONAL_START maybe_space DOCTYPE_IGNORE maybe_space DOCTYPE_DECLARATION_START
	;

ignore_sect_content :
	/*empty*/
	| ignore_sect_items
	;

ignore_sect_items :
	ignore_sect_item
	| ignore_sect_items ignore_sect_item
	;

ignore_sect_item :
	char_data
	| DOCTYPE_CONDITIONAL_START ignore_sect_content DOCTYPE_CONDITIONAL_END
	;

entity_decl :
	ge_decl
	| pe_decl
	//| DOCTYPE_ENTITY error
	;

ge_decl :
	DOCTYPE_ENTITY req_space doctype_name req_space entity_value maybe_space DOCTYPE_END
	| DOCTYPE_ENTITY req_space doctype_name req_space external_id maybe_space DOCTYPE_END
	| DOCTYPE_ENTITY req_space doctype_name req_space external_id ndata_decl maybe_space DOCTYPE_END
	;

pe_decl :
	DOCTYPE_ENTITY req_space DOCTYPE_PERCENT req_space doctype_name req_space entity_value maybe_space DOCTYPE_END
	| DOCTYPE_ENTITY req_space DOCTYPE_PERCENT req_space doctype_name req_space external_id maybe_space DOCTYPE_END
	;

external_id :
	doctype_system_token
	| DOCTYPE_PUBLIC doctype_system_token
	;

ndata_decl :
	req_space DOCTYPE_NDATA req_space doctype_name
	;

text_decl :
	/*empty*/
	| XMLDECLARATION_START encoding_decl maybe_space XMLDECLARATION_END
	| XMLDECLARATION_START version_info req_space encoding_decl maybe_space XMLDECLARATION_END
	//| XMLDECLARATION_START error
	;

encoding_decl :
	XMLDECLARATION_ENCODING space_eq APOS XMLDECLARATION_ENCODING_VALUE APOS
	| XMLDECLARATION_ENCODING space_eq QUOT XMLDECLARATION_ENCODING_VALUE QUOT
	;

notation_decl :
	DOCTYPE_NOTATION req_space doctype_name req_space external_id maybe_space DOCTYPE_END
	| DOCTYPE_NOTATION req_space doctype_name req_space public_id maybe_space DOCTYPE_END
	//| DOCTYPE_NOTATION error
	;

public_id :
	DOCTYPE_PUBLIC
	;

%%

%x comment_state
%x processinginstruction
%x xmldeclaration
%x cdata
%x tag
%x attribute_value_single
%x attribute_value_double
%x entity_value_single
%x entity_value_double
%x doctype
%x public_system
%x dtd_in
%x dtd_element
%x dtd_attlist
%x dtd_entity
%x dtd_notation
%x dtd_ignore

//-- XML1.0:85 non-conformance: unicode letters
//-- XML1.0:88 non-conformance: unicode digits
//-- XML1.0:89 extender &xb7; + unicode

APOS [']
QUOT ["]
SPACECHAR [\r\n\t ]

NOSPASCIICHAR [\x21-\x7F]
UTF8CHAR (([\xC2-\xDF][\x80-\xBF])|(\xE0[\xA0-\xBF][\x80-\xBF])|([\xE1-\xEF][\x80-\xBF][\x80-\xBF])|(\xF0[\x90-\xBF][\x80-\xBF][\x80-\xBF])|([\xF1-\xF7][\x80-\xBF][\x80-\xBF][\x80-\xBF]))

//-- CHARUTF8 only accepts legal UTF8 sequences.
//--
//-- this include disallowing sequence encoding below the minimum number of
//-- bits, so the data part may not be zero in either the first or
//-- the second byte of the encoding.
//--
//--          zero		  min           max            first trail   trail  min   total
//-- 2 bytes  -			  110 00010 C2  110 11111 DF   10000000 80   6      8     11
//-- 3 bytes  1110 0000 E0  1110 0001 E1  1110 1111 EF   10100000 A0   12     12    16
//-- 4 bytes  11110 000 F0  11110 001 F1  11110 111 F7   10010000 90   18     17    21
//-- trail                  10 000000 80  10 111111 BF
//--
//-- open issue: disable surrogates, max char 10FFFF?


XMLENCODING [a-zA-Z0-9\x2D]+

CONTENTCHARASCII [\x21-\x25\x27-\x3B\x3D-\X5C\x5E-\x7F]
//-- = NOSPASCIICHAR less &<]

PIASCIICHAR [\x21-\x3E\x40-\x7F]
//-- = NOSPASCIICHAR less "?" = \x3F

CDATAASCIICHAR [\t\x20-\x5C\x5E-\x7F]
//-- = SPACECHAR less \r\n, NOSPASCIICHAR less ]

COMMENTASCIICHAR [\x20-\x2C\x2E-\x7F]
//-- = NOSPASCIICHAR less -, " "

ATTRIBUTECHAR [\x21\x23-\x25\x28-\x3B\x3D-\x7F]
//-- = NOSPASCIICHAR less " & ' <

ENTITYCHAR [\x21\x23\x24\x28-\x7F]
//-- = NOSPASCIICHAR less " % & '

NAMECHAR [:A-Za-z0-9._\-]
NAMECHAR_NOCOLON [A-Za-z0-9._\-]

NAMECHAR_FIRST [:A-Za-z_]
NAMECHAR_FIRST_NOCOLON [A-Za-z_]


//-- PUBIDLITERAL class has no ' when starting with '
//-- SYSTEMLITERAL class is CHAR - quote

PUBIDLITERAL ((['][ \r\na-zA-Z0-9\-()+,./:=?;!*#@$_%]*['])|(["][' \r\na-zA-Z0-9\-()+,./:=?;!*#@$_%]*["]))

NOAPOSSYSLITCHAR [\r\n\t\x20-&(-\x7F]
NOQUOTSYSLITCHAR [\r\n\t\x20-!#-\x7F]


%%

xDOCTYPE_NAMEx	DOCTYPE_NAME

//-- Comment

<INITIAL,doctype>{
	"<!--"<>comment_state>	COMMENT_START
}

<comment_state>{
	"-->"<<>	COMMENT_END

	"--"	COMMENT_DASHDASH	//-- conformance error XML1.0:2.5

	({SPACECHAR})+ CHARDATA

	({COMMENTASCIICHAR})+ CHARDATA

	({COMMENTASCIICHAR}|{UTF8CHAR})+ CHARDATA_UTF8

	"-" CHARDATA
}

//-- Processing Instruction and XML Declaration.


<INITIAL,doctype>{

	"<?xml"{SPACECHAR}+<>xmldeclaration> XMLDECLARATION_START

	//-- "<?xml" matched by previous rule when allowed.
	"<?"[Xx][Mm][Ll]({SPACECHAR}+|"?>") PI_RESERVED

	//-- <?xml caught by previous rules.
	"<?"<>processinginstruction> PI_START
}

<xmldeclaration>{
	"?>"<<> XMLDECLARATION_END

	//-- Version declaration.
	"version" XMLDECLARATION_VERSION

	"1.0" XMLDECLARATION_VERSION_10

	//-- Standalone declaration.
	"standalone" XMLDECLARATION_STANDALONE

	"yes" XMLDECLARATION_STANDALONE_YES

	"no" XMLDECLARATION_STANDALONE_NO

	//-- Encoding
	"encoding" XMLDECLARATION_ENCODING

	//-- 'yes' 'no' '1.0' caught by previous rules
	{XMLENCODING} XMLDECLARATION_ENCODING_VALUE

	"=" EQ

	{APOS} APOS

	{QUOT} QUOT

	{SPACECHAR}+ SPACE
}

<processinginstruction>{
	"?>"<<> PI_END

	{NAMECHAR_FIRST}{NAMECHAR}* PI_TARGET

	({NAMECHAR_FIRST}|{UTF8CHAR})({NAMECHAR}|{UTF8CHAR})* PI_TARGET_UTF8

	{SPACECHAR}+ SPACE
	({PIASCIICHAR})+ CHARDATA
	({PIASCIICHAR}|{UTF8CHAR})+ CHARDATA_UTF8
	//-- stand alone "?"
	"?" CHARDATA
}

//-- CDATA section.

"<![CDATA["<>cdata> CDATA_START

<cdata>{
	"]]>"<<> CDATA_END

	//-- End of line handling XML1.0:2.11.
	("\r\n"|"\r"|"\n") CHARDATA
	//-- ASCIICHAR less ]
	({CDATAASCIICHAR})+ CHARDATA
	//-- Big chunks in `last_value'.
	({CDATAASCIICHAR}|{UTF8CHAR})+ CHARDATA_UTF8
	//-- standalone "]"
	"]" CHARDATA
}

"<!DOCTYPE"<>dtd_in> DOCTYPE_START

<dtd_attlist>{
	"#REQUIRED" DOCTYPE_REQUIRED
	"#IMPLIED" DOCTYPE_IMPLIED
	"#FIXED" DOCTYPE_FIXED
	"CDATA" DOCTYPE_ATT_CDATA
	"ID" DOCTYPE_ATT_ID
	"IDREF" DOCTYPE_ATT_IDREF
	"IDREFS" DOCTYPE_ATT_IDREFS
	"ENTITY" DOCTYPE_ATT_ENTITY
	"ENTITIES" DOCTYPE_ATT_ENTITIES
	"NMTOKEN" DOCTYPE_ATT_NMTOKEN
	"NMTOKENS" DOCTYPE_ATT_NMTOKENS
	"NOTATION" DOCTYPE_ATT_NOTATION
	{APOS}<>attribute_value_single> VALUE_START
	{QUOT}<>attribute_value_double> VALUE_START
}

<dtd_in>{
	"["<>doctype> DOCTYPE_DECLARATION_START
}

<doctype>{
	//-- NAME matches: "SYSTEM" "PUBLIC".

	//-- Same, but balances end.
	"["<>doctype> DOCTYPE_DECLARATION_START

	"]"<<> DOCTYPE_DECLARATION_END

	"<!ELEMENT"<>dtd_element> DOCTYPE_ELEMENT
	"<!ATTLIST"<>dtd_attlist> DOCTYPE_ATTLIST
	"<!ENTITY"<>dtd_entity> DOCTYPE_ENTITY
	"<!NOTATION"<>dtd_notation> DOCTYPE_NOTATION

	"IGNORE" DOCTYPE_IGNORE

	"INCLUDE" DOCTYPE_INCLUDE

	"<![" DOCTYPE_CONDITIONAL_START

	"]]>" DOCTYPE_CONDITIONAL_END
}

<dtd_ignore>{
	//-- Self, for exit.
	"<!["<>dtd_ignore> DOCTYPE_CONDITIONAL_START

	"]]>"<<> DOCTYPE_CONDITIONAL_END

	({NOSPASCIICHAR}|{UTF8CHAR}) CHARDATA

	{SPACECHAR} CHARDATA
}

<dtd_element>{
	"#PCDATA" DOCTYPE_PCDATA

	"EMPTY" DOCTYPE_ELEMENT_EMPTY

	"ANY" DOCTYPE_ELEMENT_ANY
}

<dtd_entity>{
	"NDATA" DOCTYPE_NDATA
}

<doctype,dtd_in,dtd_element,dtd_attlist,dtd_entity,dtd_notation>{
	">"<<> DOCTYPE_END

	{NAMECHAR_FIRST}{NAMECHAR}* NAME

	({NAMECHAR_FIRST}|{UTF8CHAR})({NAMECHAR}|{UTF8CHAR})* NAME_UTF8
	{SPACECHAR}+ SPACE
}

<doctype,dtd_in,dtd_entity,dtd_notation>{

	//-- `system_literal_text' does microparsing of last quoted
	//-- value. Inelegant to do microparsing in a scanner, but
	//-- PUBLIC and SYSTEM are not keywords and can also be
	//-- names. The quoted values after PUBLIC and SYSTEM also
	//-- match quoted values which are not literals, but
	//-- they allow a different character set.
	//
	//-- Problem: if declaration merged from processing entity
	//-- (PE cuts on space token boundaries).

	"SYSTEM"{SPACECHAR}+(([']{NOAPOSSYSLITCHAR}*['])|(["]{NOQUOTSYSLITCHAR}*["])) DOCTYPE_SYSTEM

	"SYSTEM"{SPACECHAR}+(([']({NOAPOSSYSLITCHAR}|{UTF8CHAR})*['])|(["]({NOQUOTSYSLITCHAR}|{UTF8CHAR})*["])) DOCTYPE_SYSTEM_UTF8

	"PUBLIC"{SPACECHAR}+{PUBIDLITERAL}<>public_system> DOCTYPE_PUBLIC
}

<public_system>{
	{SPACECHAR}+(([']{NOAPOSSYSLITCHAR}*['])|(["]{NOQUOTSYSLITCHAR}*["]))<<> DOCTYPE_SYSTEM

	{SPACECHAR}+(([']({NOAPOSSYSLITCHAR}|{UTF8CHAR})*['])|(["]({NOQUOTSYSLITCHAR}|{UTF8CHAR})*["]))<<> DOCTYPE_SYSTEM_UTF8

	//-- this covers the case of dtd_notation, which allows a PUBLIC id with or without
	//-- a system part. When there is no system part, DOCTYPE_END is the only valid token.
	//-- If there is a system part, the next token is handled by the regular
	//-- DTD notation.
	{SPACECHAR}*">"<<> DOCTYPE_END

	//-- the global INPUT_INVALID does not catch \n, which is caught
	//-- explicitly under other start conditions.
	//"\n"<<> INPUT_INVALID
}

<dtd_element,dtd_attlist>{
	"|" DOCTYPE_GROUP_OR
	"," DOCTYPE_GROUP_SEQ
	"(" DOCTYPE_GROUP_START
	")" DOCTYPE_GROUP_END
	"?" DOCTYPE_GROUP_ZEROONE
	"*" DOCTYPE_GROUP_ANY
	"+" DOCTYPE_GROUP_ONEMORE

	{NAMECHAR}+ NMTOKEN
	({NAMECHAR}|{UTF8CHAR})+ NMTOKEN_UTF8
}

<dtd_entity>{
	"%" DOCTYPE_PERCENT
	{APOS}<>entity_value_single> VALUE_START
	{QUOT}<>entity_value_double> VALUE_START
}

//-- Also entity/notation?
<doctype,dtd_element,dtd_attlist>{
	"%"{NAMECHAR_FIRST}{NAMECHAR}*";" DOCTYPE_PEREFERENCE

	"%"({NAMECHAR_FIRST}|{UTF8CHAR})({NAMECHAR}|{UTF8CHAR})*";" DOCTYPE_PEREFERENCE_UTF8
	//"%" ENTITY_INVALID
}

<entity_value_single,entity_value_double>{
	"%"{NAMECHAR_FIRST}{NAMECHAR}*";" ENTITYVALUE_PEREFERENCE
	"%"({NAMECHAR_FIRST}|{UTF8CHAR})({NAMECHAR}|{UTF8CHAR})*";" ENTITYVALUE_PEREFERENCE_UTF8
}

<doctype,dtd_element,dtd_attlist,entity_value_single,entity_value_double>{
	//"%" ENTITY_INVALID
}

//-- Elements.

"</"<>tag> TAG_START_END

"<"<>tag> TAG_START

<tag>{
	{SPACECHAR}*"/>"<<> TAG_END_EMPTY

	{SPACECHAR}*">"<<> TAG_END
	//-- Name decomposed for easier parsing of namespaces into:
	//-- (Name - ':') ':' (NmToken - ':') ...
	":" TAG_NAME_COLON
	{NAMECHAR_FIRST_NOCOLON}{NAMECHAR_NOCOLON}* TAG_NAME_FIRST
	({NAMECHAR_FIRST_NOCOLON}|{UTF8CHAR})({NAMECHAR_NOCOLON}|{UTF8CHAR})* TAG_NAME_FIRST_UTF8
	{NAMECHAR_NOCOLON}+ TAG_NAME_ATOM
	({NAMECHAR_NOCOLON}|{UTF8CHAR})+ TAG_NAME_ATOM_UTF8
	{SPACECHAR}+ SPACE
	{SPACECHAR}*"="{SPACECHAR}* EQ

	{APOS}<>attribute_value_single> VALUE_START
	{QUOT}<>attribute_value_double> VALUE_START
}

//-- Entities.

//-- Named entities are not interpreted in an 'entity_value'.

<INITIAL,attribute_value_single,attribute_value_double>{
	"&apos;" CHARDATA
	"&quot;" CHARDATA
	"&lt;" CHARDATA
	"&gt;" CHARDATA
	"&amp;" CHARDATA
}

<INITIAL>{
	"&"{NAMECHAR_FIRST}{NAMECHAR}*";" CONTENT_ENTITY
	"&"({NAMECHAR_FIRST}|{UTF8CHAR})({NAMECHAR}|{UTF8CHAR})*";" CONTENT_ENTITY_UTF8
}

<entity_value_single,entity_value_double>{
	//-- Bypassed
	"&"{NAMECHAR_FIRST}{NAMECHAR}*";" CHARDATA
	//-- Bypassed
	"&"({NAMECHAR_FIRST}|{UTF8CHAR})({NAMECHAR}|{UTF8CHAR})*";" CHARDATA_UTF8

	//-- Double quote and single quote char entities not interpreted
	//-- as char entities XML1.0:4.4.5
	("&#34;"|"&#x22;"|"&#39;"|"&#x27;") CHARDATA
}

<attribute_value_single,attribute_value_double>{
	"&"{NAMECHAR_FIRST}{NAMECHAR}*";" ATTRIBUTE_ENTITY
	"&"({NAMECHAR_FIRST}|{UTF8CHAR})({NAMECHAR}|{UTF8CHAR})*";" ATTRIBUTE_ENTITY_UTF8

	//-- Conformance error.
	"<" ATTRIBUTE_LT
	//-- XML1.0:3.3.3 Attribute value normalization.
	"\r\n" CHARDATA
	//-- XML1.0:3.3.3 Attribute value normalization.
	{SPACECHAR} CHARDATA
	{ATTRIBUTECHAR}+ CHARDATA
	({ATTRIBUTECHAR}|{UTF8CHAR})+ CHARDATA_UTF8
}

<INITIAL,attribute_value_single,attribute_value_double,entity_value_single,entity_value_double>{
	"&#"[0-9]+";" CHARDATA //CHARDATA_UTF8

	"&#x"[0-9a-fA-F]+";" CHARDATA //CHARDATA_UTF8

	//"&" ENTITY_INVALID
}

<entity_value_single,entity_value_double>{
	//-- End of line handling XML1.0:2.11.
	("\r\n"|"\r"|"\n") CHARDATA
	{SPACECHAR}+ CHARDATA
	({ENTITYCHAR})+ CHARDATA
	({ENTITYCHAR}|{UTF8CHAR})+ CHARDATA_UTF8
}

<attribute_value_single,entity_value_single>{
	{APOS}<<> VALUE_END
	{QUOT} CHARDATA
}

<attribute_value_double,entity_value_double>{
	{QUOT}<<> VALUE_END
	{APOS} CHARDATA
}

//-- Content.

//-- XML1.0:14 ]]> not allowed in markup.
"]]>" CONTENT_CONDITIONAL_END

//-- End of line handling XML1.0:2.11.
\r\n SPACE

\r SPACE

\n SPACE

//-- Space not matched by newline normalization.
[ \t]+ SPACE

{CONTENTCHARASCII}+ CHARDATA

({CONTENTCHARASCII}|{UTF8CHAR})+ CHARDATA_UTF8

"]" CHARDATA

//-- Default rule.
//<*>. INPUT_INVALID

%%
