// http://code.google.com/p/bsn-goldparser/wiki/JsonGrammar

%x END

%x OBJECT
%x NAME
%x COLON
%x OB_VALUE
%x OB_COMMA

%x ARRAY
%x ARR_COMMA
%x ARR_VALUE

%token eOpenOb eCloseOb eOpenArr eCloseArr
%token eName eString eNumber eBoolean eNull

%%

%%

/*STRING	["]([ -\x10ffff]{-}["\\]|\\(["\\/bfnrt]|u[0-9a-fA-F]{4}))*["]*/
/*STRING	\"(\\.|[^\"\n\r\\])*\"*/
STRING	["]([ -\xff]{-}["\\]|\\(["\\/bfnrt]|u[0-9a-fA-F]{4}))*["]
NUMBER	-?(0|[1-9]\d*)([.]\d+)?([eE][-+]?\d+)?
BOOL	true|false
NULL	null

%%

<INITIAL>[{]<>OBJECT:END>	eOpenOb
<INITIAL>[[]<>ARRAY:END>	eOpenArr

<OBJECT,OB_COMMA>[}]<<>	eCloseOb
<OBJECT,NAME>{STRING}<COLON>	eName
<COLON>:<OB_VALUE>	skip()

<OB_VALUE>{STRING}<OB_COMMA>	eString
<OB_VALUE>{NUMBER}<OB_COMMA>	eNumber
<OB_VALUE>{BOOL}<OB_COMMA>	eBoolean
<OB_VALUE>{NULL}<OB_COMMA>	eNull
<OB_VALUE>[{]<>OBJECT:OB_COMMA>	eOpenOb
<OB_VALUE>[[]<>ARRAY:OB_COMMA>	eOpenArr

<OB_COMMA>,<NAME>	skip()

<ARRAY,ARR_COMMA>\]<<>	eCloseArr
<ARRAY,ARR_VALUE>{STRING}<ARR_COMMA>	eString
<ARRAY,ARR_VALUE>{NUMBER}<ARR_COMMA>	eNumber
<ARRAY,ARR_VALUE>{BOOL}<ARR_COMMA>	eBoolean
<ARRAY,ARR_VALUE>{NULL}<ARR_COMMA>	eNull
<ARRAY,ARR_VALUE>[{]<>OBJECT:ARR_COMMA>	eOpenOb
<ARRAY,ARR_VALUE>[[]<>ARRAY:ARR_COMMA>	eOpenArr

<ARR_COMMA>,<ARR_VALUE>	skip()

<*>[ \t\r\n]+<.>	skip()

%%
