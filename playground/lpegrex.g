
%token string repsufix signnum class name num defined keyword pcap
%token name_asttag_opt_arrow

%%

pattern         : exp ;
exp             : grammar | alternative ;

alternative     : seq ('/' seq)* ;
seq             : prefix* ;
prefix          : '&' prefix | '!' prefix | suffix ;
suffix          : primary (
			    (
				repsufix?
				| '^' 	(
					signnum? num  // (exactly n / at (least / most) n repetitions
					|  name // Syntax of relabel module. The pattern p^l is equivalent to p + lpeglabel.T(l).
					)
				| "->" (string | pcap | name | num)  /* capture */
				| "=>" name // match time capture
			    )
			)*
			;

primary         : '(' exp  ')'
		| string
		| keyword
		| class
		| defined
		| "{:" (name ':')? exp ":}"  // (named or anonymous) group capture
		| '=' name           // back reference
		| '@' exp   // for throwing labels errors on failure of expected matches
		| pcap
		| "{~" exp "~}"   // substitution capture
		| "{|" exp "|}"   // table capture
		| '{' exp '}'     // simple capture
		| "~?"            // optional capture
		| "~>" ("foldleft" | "foldright" | "rfoldleft" | "rfoldright" | name ) // fold capture
		| '$' (string | name | num | pcap)
		| '.'
		| name //!(asttag | arrow )
		| '<' name '>'    // old-style non terminals
		| "%{" name '}'   // Syntax of relabel module. Equivalent to lpeglabel.T(l)
		;

grammar         : definition+ ;
definition      : name_asttag_opt_arrow exp ;

%%

spaces	[ \t\n\r]
comments	--[^\n\r]*
S       {spaces}|{comments}
named	[A-Za-z_][A-Za-z0-9_\-]*
asttag	":"{S}*{named}

arrow1	"<-"
/* rule */
arrow2	"<--"
/* for rules that capture AST Nodes */
arrow3	"<=="
/* for rules that capture tables */
arrow4	"<-|"

arrow	{arrow1}|{arrow2}|{arrow3}|{arrow4}


defined	"%"{named}
item	defined|range|.
range	.-[^\]]
/*class	("[^"|"[")item (!']' item)* ']'*/

%%

{S}+	skip()

[+*?]	repsufix
[-+]	signnum

"{}"	pcap             /* position capture */

\[(\\.|[^\]\n\r\\])*\]	class

"/"	'/'
"&"	'&'
"!"	'!'
"^"	'^'
"->"	"->"
"=>"	"=>"
"("	'('
")"	')'
"{:"	"{:"
":}"	":}"
"="	'='
"@"	'@'
"{~"	"{~"
"~}"	"~}"
"{|"	"{|"
"|}"	"|}"
"{"	'{'
"}"	'}'
"~?"	"~?"
"~>"	"~>"
"$"	'$'
"."	'.'
"<"	'<'
">"	'>'
"%{"	"%{"
":"	':'
"foldleft"	"foldleft"
"foldright"	"foldright"
"rfoldleft"	"rfoldleft"
"rfoldright"	"rfoldright"

[0-9]+	num
\"[^\"]*\"|'[^']*'	string
{defined}	defined /* pattern defs[name] or a pre-defined pattern */
"`"[^`]+"`"	keyword  /* tokens/keywords with automatic skipping */
/*{asttag}	asttag*/   /* Capture tagged node rule */

/* Order matter if identifier comes before keywords they are classified as identifier */
{named}{S}*({asttag}{S}*)?{arrow}	name_asttag_opt_arrow
{named}	name

%%
