//From: https://github.com/abique/mimosa/blob/25c551623f5842f2256ed0ce72c7cff2a89f3d6e/mimosa/http/request-parser.y

/*Tokens*/
%token HEAD
%token GET
%token POST
%token PUT
%token DELETE
%token TRACE
%token OPTIONS
%token CONNECT
%token PATCH
%token PROPFIND
%token PROPPATCH
%token MKCOL
%token COPY
%token MOVE
%token LOCK
%token UNLOCK
%token MIMOSA_SYMLINK
%token LOCATION
%token PROTO_MAJOR
%token PROTO_MINOR
%token KEY
%token ATTR
%token KEY_ACCEPT_ENCODING
%token KEY_CONNECTION
%token KEY_COOKIE
%token KEY_CONTENT_RANGE
%token KEY_CONTENT_LENGTH
%token KEY_CONTENT_TYPE
%token KEY_HOST
%token KEY_REFERRER
%token KEY_USER_AGENT
%token KEY_IF_MODIFIED_SINCE
%token KEY_DESTINATION
%token KEY_RANGE
%token VALUE
%token HOST
%token VALUE_CONNECTION
%token PORT
%token VAL64
%token RANGE_UNIT
%token RANGE_START
%token RANGE_END
%token RANGE_LENGTH
%token COMPRESS
%token IDENTITY
%token DEFLATE
%token GZIP
%token SDCH
%token ZSTD
%token BR
%token '='
%token ';'
%token ','
%token '-'


%start request

%%

request :
	method LOCATION PROTO_MAJOR PROTO_MINOR kvs
	;

method :
	HEAD
	| GET
	| POST
	| PUT
	| DELETE
	| TRACE
	| OPTIONS
	| CONNECT
	| PATCH
	| PROPFIND
	| PROPPATCH
	| MKCOL
	| COPY
	| MOVE
	| LOCK
	| UNLOCK
	| MIMOSA_SYMLINK
	;

kvs :
	kvs kv
	| /*empty*/
	;

kv :
	KEY_ACCEPT_ENCODING accept_encodings
	| KEY_CONNECTION VALUE_CONNECTION
	| KEY_COOKIE cookies
	| KEY_CONTENT_LENGTH VAL64
	| KEY_CONTENT_TYPE VALUE
	| KEY_HOST HOST PORT
	| KEY_HOST HOST
	| KEY_REFERRER VALUE
	| KEY_USER_AGENT VALUE
	| KEY_IF_MODIFIED_SINCE VALUE
	| KEY_DESTINATION VALUE
	| KEY_CONTENT_RANGE RANGE_UNIT RANGE_START RANGE_END RANGE_LENGTH
	| KEY_RANGE RANGE_UNIT '=' byte_range_set
	| KEY VALUE
	;

accept_encodings :
	/*empty*/
	| accept_encodings COMPRESS
	| accept_encodings IDENTITY
	| accept_encodings DEFLATE
	| accept_encodings GZIP
	| accept_encodings ZSTD
	| accept_encodings BR
	| accept_encodings SDCH
	;

cookies :
	/*empty*/
	| cookie
	| cookies ';' cookie
	;

cookie :
	ATTR
	| ATTR '='
	| ATTR '=' VALUE
	;

byte_range_set :
	byte_range
	| byte_range_set ',' byte_range
	;

byte_range :
	VAL64 '-' VAL64
	| VAL64 '-'
	| '-' VAL64
	;

%%

%x location
%x protover
%x proto_major
%x proto_minor
%x eol
%x key
%x value
%x value64
%x colon
%x value_accept_encoding
%x value_connection
%x value_cookie_attr
%x value_cookie_eq
%x value_cookie_value
%x value_cookie_str
%x value_cookie_sm
%x port
%x host
%x content_range_unit
%x content_range_start
%x content_range_dash
%x content_range_end
%x content_range_slash
%x content_range_length
%x range_unit
%x range
%x value_no_NL

separtor [\(\)<>@,;:\\"/\[\]\?={} \t]
token    [^\(\)<>@,;:\\"/\[\]\?={} \t\r\n\v]+
spaces   [\t\v ]
cookie_octet [^\r\r\n\v ;",\\]

%%

(?i:HEAD)<location>	HEAD
(?i:GET)<location>	GET
(?i:POST)<location>	POST
(?i:PUT)<location>	PUT
(?i:DELETE)<location>	DELETE
(?i:TRACE)<location>	TRACE
(?i:OPTIONS)<location>	OPTIONS
(?i:CONNECT)<location>	CONNECT
(?i:PATCH)<location>	PATCH
(?i:PROPFIND)<location>	PROPFIND
(?i:PROPPATCH)<location>	PROPPATCH
(?i:MKCOL)<location>	MKCOL
(?i:COPY)<location>	COPY
(?i:MOVE)<location>	MOVE
(?i:LOCK)<location>	LOCK
(?i:UNLOCK)<location>	UNLOCK
(?i:MIMOSA_SYMLINK)<location>	MIMOSA_SYMLINK

<location>[^\t\v\r\n ]+<protover>  LOCATION

<protover>(?i:http)\/<proto_major>
<proto_major>[[:digit:]]+\.<proto_minor>      PROTO_MAJOR
<proto_minor>[[:digit:]]+<eol>        PROTO_MINOR


<key>(?i:Accept-Encoding){spaces}*:<value_accept_encoding>     KEY_ACCEPT_ENCODING
<key>(?i:Connection){spaces}*:<value_connection>          KEY_CONNECTION
<key>(?i:Cookie){spaces}*:<value_cookie_attr>              KEY_COOKIE
<key>(?i:Content-Length){spaces}*:<value64>      KEY_CONTENT_LENGTH
<key>(?i:Content-Range){spaces}*:<content_range_unit>       KEY_CONTENT_RANGE
<key>(?i:Content-Type)<colon>                  KEY_CONTENT_TYPE
<key>(?i:Host){spaces}*:<host>                KEY_HOST
<key>(?i:Referr?er)<colon>                     KEY_REFERRER
<key>(?i:User-Agent)<colon>                    KEY_USER_AGENT
<key>(?i:If-Modified-Since)<colon>             KEY_IF_MODIFIED_SINCE
<key>(?i:Destination)<colon>                   KEY_DESTINATION
<key>(?i:Range){spaces}*:<range_unit>               KEY_RANGE
<key>[-_[:alnum:]]+<colon>                     KEY

<colon>:<value>

<host>{token}                           HOST
<host>:<port>

<port>[0-9]+                            PORT

<value>[^[:space:]].*<value_no_NL>      reject()
<value_no_NL>{
	[^[:space:]].*      VALUE
	\r<value>	reject()
}

<content_range_unit>bytes<content_range_start>          RANGE_UNIT
<content_range_start>[[:digit:]]+<content_range_dash>  RANGE_START
<content_range_dash>-<content_range_end>
<content_range_end>[[:digit:]]+<content_range_slash>    RANGE_END
<content_range_slash>\/<content_range_length>
<content_range_length>[[:digit:]]+ RANGE_LENGTH
<content_range_length>\*           RANGE_LENGTH

<range_unit>bytes<range>                  RANGE_UNIT
<range>=                           '='
<range>\-                          '-'
<range>,                           ','
<range>[[:digit:]]+                VAL64

<value_accept_encoding>(?i:compress) COMPRESS
<value_accept_encoding>(?i:identity) IDENTITY
<value_accept_encoding>(?i:deflate)  DEFLATE
<value_accept_encoding>(?i:gzip)     GZIP
<value_accept_encoding>(?i:sdch)     SDCH
<value_accept_encoding>(?i:zstd)     ZSTD
<value_accept_encoding>(?i:br)       BR
<value_accept_encoding>;|[qQ]|=[01](.[0-9]{1,3})?|,<.>

<value_cookie_attr>{token}<value_cookie_eq>       ATTR
<value_cookie_eq>=<value_cookie_value>              '='
<value_cookie_eq,value_cookie_value,value_cookie_sm>\;<value_cookie_attr> ';'
<value_cookie_value>{cookie_octet}+<value_cookie_sm>  VALUE
<value_cookie_value>\"<value_cookie_str>
<value_cookie_str>[^\\"]+<.>
<value_cookie_str>\\.<.>
<value_cookie_str>\"<value_cookie_sm>            VALUE

<value_connection>,<.>
<value_connection>(?i:TE)<.>
<value_connection>(?i:keep-alive)  VALUE_CONNECTION
<value_connection>(?i:close)       VALUE_CONNECTION

<value64>[0-9]+          VAL64

<*>{spaces}+            skip() /* ignore */
//<*>\r\n\r\n             yyterminate();
<*>\r?\n<key>   //make \r optional to easy test on the playground
//<*>.                    yyterminate();

%%
