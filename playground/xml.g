%token name value
%token ILLEGAL_CHARACTER

%left '<' '>'
%left name

%%

document: prolog element ;
prolog: '<\?xml' attributes '\?>' | ;
elements: elements element | element | %prec '<' ;
element: '<' name attributes '/>' | '<' name attributes '>' elements '</' name '>' ;
attributes: attributes attribute | attribute | %prec name ;
attribute: name '=' value ;

%%

whitespace	[ \t\r\n]+

%%

{whitespace}	skip()

[A-Za-z_:][A-Za-z0-9_:\.-]*	name
\"(\\.|[^\"\n\r\\])*\"|'(\\.|[^'\n\r\\])*'	value

\<	'<'
>	'>'
"<\?xml"	'<\?xml'
"\?>"	'\?>'
"/>"	'/>'
"</"	'</'
=	'='

.	ILLEGAL_CHARACTER

%%
