//From: https://piumarta.com/software/peg/peg.1.html

%token SLASH AND NOT QUERY STAR PLUS
%token OPEN CLOSE DOT BEGIN END
%token Identifier Literal Class Identifier_LEFTARROW Action

%%

Grammar:
	  Definition
	| Grammar Definition
	;

Definition:
	  Identifier_LEFTARROW Expression
	;

Expression:
	  Sequence
	| Expression SLASH Sequence
	;

Sequence:
	  %empty
	| Sequence Prefix
	;

Prefix:
	  AND_opt action_or_suffix
	| NOT Suffix
	;

action_or_suffix:
	  Action
	| Suffix
	;

AND_opt:
	  %empty
	| AND
	;

Suffix:
	  Primary repeat_opt
	;

repeat_opt:
	  %empty
	| QUERY
	| STAR
	| PLUS
	;

Primary:
	  Identifier
	| OPEN Expression CLOSE
	| Literal
	| Class
	| DOT
	| BEGIN
	| END
	;

%%

IdentStart      [a-zA-Z_]
IdentCont      {IdentStart}|[0-9]
Identifier	{IdentStart}{IdentCont}*

LEFTARROW      "<-"

CharEscaped	[abefnrtv'"\[\]\\]
CharOctal3	[0-3][0-7][0-7]
CharOctal2	[0-7][0-7]?

Char            \\({CharEscaped}|{CharOctal3}|{CharOctal2}|-)|[^\\]

Range           {Char}(-{Char})?

EndOfLine       "\r\n"|\n|\r
Space           [ \t]|{EndOfLine}
Comment         #[^\n\r]*
Spacing         {Space}|{Comment}

%%

{Spacing}+	skip()

{Identifier}	Identifier
{Identifier}[[:space:]]*{LEFTARROW}	Identifier_LEFTARROW
'(\\.|[^'\n\r\\])*'|\"(\\.|[^\"\n\r\\])*\"	Literal
/*"["( !']' Range )*"]"	Class*/
"["(\\.|[^\]\n\r\\])*"]"	Class
"/"	SLASH
"&"	AND
"!"	NOT
"?"	QUERY
"*"	STAR
"+"	PLUS
"("	OPEN
")"	CLOSE
"."	DOT
"{"(?s:.)*?"}"	Action
"<"	BEGIN
">"	END

%%
