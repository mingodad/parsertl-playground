// limitations under the License.
//
// %CopyrightEnd%
//

// This is the syntax (metagrammar) of grammar definitions of the yecc
// parser generator.

%token atom float integer reserved_symbol reserved_word string char var "->" ':' dot erlang_code

%fallback atom reserved_symbol

%start input

%%

input : yecc_grammar erlang_code_opt ;

erlang_code_opt :
    %empty
    | erlang_code
    ;

yecc_grammar :
    grammar
    | yecc_grammar grammar
    ;

grammar : declaration  ;
grammar : rule  ;
declaration : symbol symbols dot ;
declaration : symbol strings dot ;
rule : head "->" symbols attached_code dot ;
head : symbol  ;
symbols : symbol  ;
symbols : symbols symbol  ;
strings : string  ;
strings : strings string  ;
attached_code : ':' tokens  ;
attached_code : %empty ;
tokens : token  ;
tokens : tokens token  ;
symbol : var  ;
symbol : atom  ;
symbol : integer  ;
symbol : reserved_word  ;
token : var  ;
token : atom  ;
token : float  ;
token : integer  ;
token : string  ;
token : char  ;
token : reserved_symbol  ;
token : reserved_word  ;
token : "->" ; // Have to be treated in this
token : ':' ;  // manner, because they are also
                                       // special symbols of the metagrammar

%%

var	[A-Z_][0-9a-zA-Z_]*
atom	'[^'\n\r\\]+'|[a-z][A-Za-z0-9_]*
str	\"(\\.|[^"\n\r\\])*\"

%%

[\n\r\t ]+  skip()
"%".*   skip()

":"	':'
"->"	"->"


ABSENT	reserved_word
ALL	reserved_word
ANY	reserved_word
APPLICATION	reserved_word
AUTOMATIC	reserved_word
BEGIN	reserved_word
BIT	reserved_word
BMPString	reserved_word //rstrtype
BOOLEAN	reserved_word
BY	reserved_word
CHARACTER	reserved_word
CHOICE	reserved_word
CLASS	reserved_word
COMPONENT	reserved_word
COMPONENTS	reserved_word
CONSTRAINED	reserved_word
CONTAINING	reserved_word
DEFAULT	reserved_word
DEFINED	reserved_word //% not present in X.680 07/2002
DEFINITIONS	reserved_word
EMBEDDED	reserved_word
ENCODED	reserved_word
END	reserved_word
ENUMERATED	reserved_word
EXCEPT	reserved_word
EXPLICIT	reserved_word
EXPORTS	reserved_word
EXTENSIBILITY	reserved_word
EXTERNAL	reserved_word
FALSE	reserved_word
FROM	reserved_word
GeneralizedTime	reserved_word
GeneralString	reserved_word //rstrtype
GraphicString	reserved_word //rstrtype
IA5String	reserved_word //rstrtype
IDENTIFIER	reserved_word
IMPLICIT	reserved_word
IMPLIED	reserved_word
IMPORTS	reserved_word
INCLUDES	reserved_word
INSTANCE	reserved_word
INTEGER	reserved_word
INTERSECTION	reserved_word
MAX	reserved_word
MIN	reserved_word
MINUS-INFINITY	reserved_word
NULL	reserved_word
NumericString	reserved_word //rstrtype
OBJECT	reserved_word
ObjectDescriptor	reserved_word
OCTET	reserved_word
OF	reserved_word
OPTIONAL	reserved_word
PATTERN	reserved_word
PDV	reserved_word
PLUS-INFINITY	reserved_word
PRESENT	reserved_word
PrintableString	reserved_word //rstrtype
PRIVATE	reserved_word
REAL	reserved_word
RELATIVE-OID	reserved_word
SEQUENCE	reserved_word
SET	reserved_word
SIZE	reserved_word
STRING	reserved_word
SYNTAX	reserved_word
T61String	reserved_word //rstrtype
TAGS	reserved_word
TeletexString	reserved_word //rstrtype
TRUE	reserved_word
UNION	reserved_word
UNIQUE	reserved_word
UNIVERSAL	reserved_word
UniversalString	reserved_word //rstrtype
UTCTime	reserved_word
UTF8String	reserved_word //rstrtype
VideotexString	reserved_word //rstrtype
VisibleString	reserved_word //rstrtype
WITH	reserved_word


reserved_symbol	reserved_symbol
"#"{var} reserved_symbol
"#"{atom} reserved_symbol
"<<>>"  reserved_symbol

"Erlang"[ \t]+"code"[ \t]*"."(?s:.)*  erlang_code

{atom}	atom
[{}\[\],|()?=;+-]	char
"."	dot
[0-9]+"."[0-9]+	float
[0-9]+	integer
{str}	string
{var}	var

%%
