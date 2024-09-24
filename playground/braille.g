//From: https://github.com/Genivia/RE-flex/blob/f737e1ea2c352b10841d549cbc7713535bef46ab/examples/braille.l
/* Braille translator, inspired by the re2c example but expanded to be useful.
   To learn more:
   https://en.wikipedia.org/wiki/English_Braille
   New mathematical symbols and new punctuation are not translated.

   Article 1 of the Universal Declaration of Human Rights:

./braille << END
⠠⠁⠇⠇⠀⠓⠥⠍⠁⠝⠀⠆⠬⠎⠀⠜⠑⠀⠃⠕⠗⠝⠀⠋⠗⠑⠑⠀⠯⠀⠑⠟⠥⠁⠇⠀⠔⠀⠙⠊⠛⠝⠰⠽⠀⠯⠀⠐⠗⠎⠲
⠠⠮⠽⠀⠜⠑⠀⠢⠙⠪⠫⠀⠾⠀⠗⠂⠎⠕⠝⠀⠯⠀⠒⠎⠉⠊⠰⠑⠀⠯⠀⠩⠙⠀⠁⠉⠞⠀⠞⠪⠜⠙⠎⠀⠐⠕⠀⠁⠝⠕⠤
⠮⠗⠀⠔⠀⠁⠀⠸⠎⠀⠷⠀⠃⠗⠕⠮⠗⠓⠕⠕⠙⠲
END
All human beings are born free and equal in dignity and rights.
They are endowed with reason and conscience and should act towards one ano-
ther in a spirit of brotherhood.

*/

//%token ILLEGAL_CHARACTER

%token 'a'
%token 'b'
%token 'c'
%token 'd'
%token 'e'
%token 'f'
%token 'g'
%token 'h'
%token 'i'
%token 'j'
%token 'k'
%token 'l'
%token 'm'
%token 'n'
%token 'o'
%token 'p'
%token 'q'
%token 'r'
%token 's'
%token 't'
%token 'u'
%token 'v'
%token 'w'
%token 'x'
%token 'y'
%token 'z'
%token "and"
%token "for"
%token "of"
%token "the"
%token "with"
%token "ch"
%token "gh"
%token "sh"
%token "th"
%token "wh"
%token "ed"
%token "er"
%token "ou"
%token "ow"
%token "en"
%token "in"
%token "st"
%token "ar"
%token "ing"
%token "here"
%token "there"
%token "where"
%token "ever"
%token "ought"
%token "father"
%token "mother"
%token "name"
%token "character"
%token "question"
%token "know"
%token "lord"
%token "one"
%token "day"
%token "some"
%token "part"
%token "time"
%token "right"
%token "through"
%token "under"
%token "work"
%token "young"
%token "these"
%token "those"
%token "upon"
%token "whose"
%token "word"
%token "cannot"
%token "many"
%token "had"
%token "their"
%token "spirit"
%token "world"

%token "but"
%token "can"
%token "do"
%token "every"
%token "from and -self"
%token "go"
%token "have"
%token "just"
%token "knowledge"
%token "like"
%token "more"
%token "not"
%token "people"
%token "quite"
%token "rather"
%token "so"
%token "that"
%token "still"
%token "us"
%token "very"
%token "it"
%token "you"
%token "as"
%token "child"
%token "shall"
%token "this"
%token "which"
%token "out"
%token "will"

%token "be"
%token "con"
%token "dis"
%token "enough"
%token "to"
%token "were"
%token "his"
%token "and was"
%token "com"

%token "about"
%token "above"
%token "according"
%token "across"
%token "after"
%token "afternoon"
%token "afterward"
%token "again"
%token "against"
%token "also"
%token "almost"
%token "already"
%token "altogether"
%token "although"
%token "always"
%token "because"
%token "before"
%token "behind"
%token "below"
%token "beneath"
%token "beside"
%token "between"
%token "beyond"
%token "blind"
%token "Braille"
%token "could"
%token "ceive"
%token "ceiving"
%token "children"
%token "declare"
%token "declaring"
%token "either"
%token "first"
%token "friend"
%token "good"
%token "great"
%token "herself"
%token "him"
%token "himself"
%token "immediate"
%token "little"
%token "letter"
%token "much"
%token "must"
%token "myself"
%token "necessary"
%token "neither"
%token "o'clock"
%token "ourselves"
%token "paid"
%token "perhaps"
%token "quick"
%token "rejoice"
%token "rejoicing"
%token "such"
%token "said"
%token "should"
%token "today"
%token "together"
%token "tomorrow"
%token "tonight"
%token "themselves"
%token "would"
%token "its"
%token "itself"
%token "your"
%token "yourself"
%token "yourselves"

%token "ea"
%token "bb"
%token "cc"
%token "dd"
%token "ound"
%token "ount"
%token "ance"
%token "less"
%token "sion"
%token "ong"
%token "ful"
%token "ment"
%token "ence"
%token "ness"
%token "tion"
%token "ity"
%token "ally"
%token "ation"

%token '0'
%token '1'
%token '2'
%token '3'
%token '4'
%token '5'
%token '6'
%token '7'
%token '8'
%token '9'

%token ','
%token ';'
%token ':'
%token '.'
%token '-'
%token '!'
%token '?'
%token '('
%token '"'
%token '\''

%token ' '
%token '\t'
%token '\n'
%token '\r'

%%

start :  tk | start tk;

tk :
	 'a'
	| 'b'
	| 'c'
	| 'd'
	| 'e'
	| 'f'
	| 'g'
	| 'h'
	| 'i'
	| 'j'
	| 'k'
	| 'l'
	| 'm'
	| 'n'
	| 'o'
	| 'p'
	| 'q'
	| 'r'
	| 's'
	| 't'
	| 'u'
	| 'v'
	| 'w'
	| 'x'
	| 'y'
	| 'z'
	| "and"
	| "for"
	| "of"
	| "the"
	| "with"
	| "ch"
	| "gh"
	| "sh"
	| "th"
	| "wh"
	| "ed"
	| "er"
	| "ou"
	| "ow"
	| "en"
	| "in"
	| "st"
	| "ar"
	| "ing"
	| "here"
	| "there"
	| "where"
	| "ever"
	| "ought"
	| "father"
	| "mother"
	| "name"
	| "character"
	| "question"
	| "know"
	| "lord"
	| "one"
	| "day"
	| "some"
	| "part"
	| "time"
	| "right"
	| "through"
	| "under"
	| "work"
	| "young"
	| "these"
	| "those"
	| "upon"
	| "whose"
	| "word"
	| "cannot"
	| "many"
	| "had"
	| "their"
	| "spirit"
	| "world"
	| "but"
	| "can"
	| "do"
	| "every"
	| "from and -self"
	| "go"
	| "have"
	| "just"
	| "knowledge"
	| "like"
	| "more"
	| "not"
	| "people"
	| "quite"
	| "rather"
	| "so"
	| "that"
	| "still"
	| "us"
	| "very"
	| "it"
	| "you"
	| "as"
	| "child"
	| "shall"
	| "this"
	| "which"
	| "out"
	| "will"
	| "be"
	| "con"
	| "dis"
	| "enough"
	| "to"
	| "were"
	| "his"
	| "and was"
	| "com"
	| "about"
	| "above"
	| "according"
	| "across"
	| "after"
	| "afternoon"
	| "afterward"
	| "again"
	| "against"
	| "also"
	| "almost"
	| "already"
	| "altogether"
	| "although"
	| "always"
	| "because"
	| "before"
	| "behind"
	| "below"
	| "beneath"
	| "beside"
	| "between"
	| "beyond"
	| "blind"
	| "Braille"
	| "could"
	| "ceive"
	| "ceiving"
	| "children"
	| "declare"
	| "declaring"
	| "either"
	| "first"
	| "friend"
	| "good"
	| "great"
	| "herself"
	| "him"
	| "himself"
	| "immediate"
	| "little"
	| "letter"
	| "much"
	| "must"
	| "myself"
	| "necessary"
	| "neither"
	| "o'clock"
	| "ourselves"
	| "paid"
	| "perhaps"
	| "quick"
	| "rejoice"
	| "rejoicing"
	| "such"
	| "said"
	| "should"
	| "today"
	| "together"
	| "tomorrow"
	| "tonight"
	| "themselves"
	| "would"
	| "its"
	| "itself"
	| "your"
	| "yourself"
	| "yourselves"
	| "ea"
	| "bb"
	| "cc"
	| "dd"
	| "ound"
	| "ount"
	| "ance"
	| "less"
	| "sion"
	| "ong"
	| "ful"
	| "ment"
	| "ence"
	| "ness"
	| "tion"
	| "ity"
	| "ally"
	| "ation"
	| '0'
	| '1'
	| '2'
	| '3'
	| '4'
	| '5'
	| '6'
	| '7'
	| '8'
	| '9'
	| ','
	| ';'
	| ':'
	| '.'
	| '-'
	| '!'
	| '?'
	| '('
	| '"'
	| '\''
	| ' '
	| '\t'
	| '\n'
	| '\r'
	;

%%

// exclusive start conditions
%x letters numbers bt

/* lookaheads for contractions to be valid, spacing and punctuation !?("'- */
//la [\u{2800} \t\n\r⠖⠦⠶⠴⠄⠤]
la ("⠀"|[ \t\n\r]|"⠖"|"⠦"|"⠶"|"⠴"|"⠄"|"⠤")

%%

//need to specify all desired states excluding <bt>
<INITIAL,letters,numbers>⠰<INITIAL>

<INITIAL,letters>{
	⠁<letters>	'a'
	⠃<letters>	'b'
	⠉<letters>	'c'
	⠙<letters>	'd'
	⠑<letters>	'e'
	⠋<letters>	'f'
	⠛<letters>	'g'
	⠓<letters>	'h'
	⠊<letters>	'i'
	⠚<letters>	'j'
	⠅<letters>	'k'
	⠇<letters>	'l'
	⠍<letters>	'm'
	⠝<letters>	'n'
	⠕<letters>	'o'
	⠏<letters>	'p'
	⠟<letters>	'q'
	⠗<letters>	'r'
	⠎<letters>	's'
	⠞<letters>	't'
	⠥<letters>	'u'
	⠧<letters>	'v'
	⠺<letters>	'w'
	⠭<letters>	'x'
	⠽<letters>	'y'
	⠵<letters>	'z'
	⠯<letters>	"and"
	⠿<letters>	"for"
	⠷<letters>	"of"
	⠮<letters>	"the"
	⠾<letters>	"with"
	⠡<letters>	"ch"
	⠣<letters>	"gh"
	⠩<letters>	"sh"
	⠹<letters>	"th"
	⠱<letters>	"wh"
	⠫<letters>	"ed"
	⠻<letters>	"er"
	⠳<letters>	"ou"
	⠪<letters>	"ow"
	⠢<letters>	"en"
	⠔<letters>	"in"
	⠌<letters>	"st"
	⠜<letters>	"ar"
	⠬<letters>	"ing"
	/* INITIAL ABBREVIATIONS */
	⠐⠓<letters>	"here"
	⠐⠮<letters>	"there"
	⠐⠱<letters>	"where"
	⠐⠑<letters>	"ever"
	⠐⠳<letters>	"ought"
	⠐⠋<letters>	"father"
	⠐⠍<letters>	"mother"
	⠐⠝<letters>	"name"
	⠐⠡<letters>	"character"
	⠐⠟<letters>	"question"
	⠐⠅<letters>	"know"
	⠐⠇<letters>	"lord"
	⠐⠕<letters>	"one"
	⠐⠙<letters>	"day"
	⠐⠎<letters>	"some"
	⠐⠏<letters>	"part"
	⠐⠞<letters>	"time"
	⠐⠗<letters>	"right"
	⠐⠹<letters>	"through"
	⠐⠥<letters>	"under"
	⠐⠺<letters>	"work"
	⠐⠽<letters>	"young"
	⠘⠮<letters>	"these"
	⠘⠹<letters>	"those"
	⠘⠥<letters>	"upon"
	⠘⠱<letters>	"whose"
	⠘⠺<letters>	"word"
	⠸⠉<letters>	"cannot"
	⠸⠍<letters>	"many"
	⠸⠓<letters>	"had"
	⠸⠮<letters>	"their"
	⠸⠎<letters>	"spirit"
	⠸⠺<letters>	"world"
}


/*<INITIAL>{*/
/* CONTRACTIONS */
⠃{la}<bt> reject()
⠉{la}<bt> reject()
⠙{la}<bt> reject()
⠑{la}<bt> reject()
⠋{la}<bt> reject()
⠛{la}<bt> reject()
⠓{la}<bt> reject()
⠚{la}<bt> reject()
⠅{la}<bt> reject()
⠇{la}<bt> reject()
⠍{la}<bt> reject()
⠝{la}<bt> reject()
⠏{la}<bt> reject()
⠟{la}<bt> reject()
⠗{la}<bt> reject()
⠎{la}<bt> reject()
⠞{la}<bt> reject()
⠌{la}<bt> reject()
⠥{la}<bt> reject()
⠧{la}<bt> reject()
⠭{la}<bt> reject()
⠽{la}<bt> reject()
⠵{la}<bt> reject()
⠡{la}<bt> reject()
⠩{la}<bt> reject()
⠹{la}<bt> reject()
⠱{la}<bt> reject()
⠳{la}<bt> reject()
⠺{la}<bt> reject()
<bt>{
	⠃<INITIAL>	"but"
	⠉<INITIAL>	"can"
	⠙<INITIAL>	"do"
	⠑<INITIAL>	"every"
	⠋<INITIAL>	"from and -self"
	⠛<INITIAL>	"go"
	⠓<INITIAL>	"have"
	⠚<INITIAL>	"just"
	⠅<INITIAL>	"knowledge"
	⠇<INITIAL>	"like"
	⠍<INITIAL>	"more"
	⠝<INITIAL>	"not"
	⠏<INITIAL>	"people"
	⠟<INITIAL>	"quite"
	⠗<INITIAL>	"rather"
	⠎<INITIAL>	"so"
	⠞<INITIAL>	"that"
	⠌<INITIAL>	"still"
	⠥<INITIAL>	"us"
	⠧<INITIAL>	"very"
	⠭<INITIAL>	"it"
	⠽<INITIAL>	"you"
	⠵<INITIAL>	"as"
	⠡<INITIAL>	"child"
	⠩<INITIAL>	"shall"
	⠹<INITIAL>	"this"
	⠱<INITIAL>	"which"
	⠳<INITIAL>	"out"
	⠺<INITIAL>	"will"
}
⠆     	"be"
⠒     	"con"
⠲     	"dis"
⠢{la}<bt> reject()
⠖{la}<bt> reject()
⠶{la}<bt> reject()
⠦{la}<bt> reject()
⠔{la}<bt> reject()
⠴{la}<bt> reject()
<bt>{
	⠢<INITIAL>	"enough"
	⠖<INITIAL>	"to"
	⠶<INITIAL>	"were"
	⠦<INITIAL>	"his"
	⠔<INITIAL>	"in"
	⠴<INITIAL>	"and was"
}
⠤     	"com"
/* LONGER CONTRACTIONS */
⠁⠃{la}<bt> reject()
⠁⠃⠧{la}<bt> reject()
⠁⠉{la}<bt> reject()
⠁⠉⠗{la}<bt> reject()
⠁⠋{la}<bt> reject()
⠁⠋⠝{la}<bt> reject()
⠁⠋⠺{la}<bt> reject()
⠁⠛{la}<bt> reject()
⠁⠛⠌{la}<bt> reject()
⠁⠇{la}<bt> reject()
⠁⠇⠍{la}<bt> reject()
⠁⠇⠗{la}<bt> reject()
⠁⠇⠞{la}<bt> reject()
⠁⠇⠹{la}<bt> reject()
⠁⠇⠺{la}<bt> reject()
⠆⠉{la}<bt> reject()
⠆⠋{la}<bt> reject()
⠆⠓{la}<bt> reject()
⠆⠇{la}<bt> reject()
⠆⠝{la}<bt> reject()
⠆⠎{la}<bt> reject()
⠆⠞{la}<bt> reject()
⠆⠽{la}<bt> reject()
⠃⠇{la}<bt> reject()
⠃⠗⠇{la}<bt> reject()
⠉⠙{la}<bt> reject()
⠉⠧{la}<bt> reject()
⠉⠧⠛{la}<bt> reject()
⠡⠝{la}<bt> reject()
⠙⠉⠇{la}<bt> reject()
⠙⠉⠇⠛{la}<bt> reject()
⠑⠊{la}<bt> reject()
⠋⠌{la}<bt> reject()
⠋⠗{la}<bt> reject()
⠛⠙{la}<bt> reject()
⠛⠗⠞{la}<bt> reject()
⠓⠻⠋{la}<bt> reject()
⠓⠍{la}<bt> reject()
⠓⠍⠋{la}<bt> reject()
⠊⠍⠍{la}<bt> reject()
⠇⠇{la}<bt> reject()
⠇⠗{la}<bt> reject()
⠍⠡{la}<bt> reject()
⠍⠌{la}<bt> reject()
⠍⠽⠋{la}<bt> reject()
⠝⠑⠉{la}<bt> reject()
⠝⠑⠊{la}<bt> reject()
⠕⠄⠉{la}<bt> reject()
⠳⠗⠧⠎{la}<bt> reject()
⠏⠙{la}<bt> reject()
⠏⠻⠓{la}<bt> reject()
⠟⠅{la}<bt> reject()
⠗⠚⠉{la}<bt> reject()
⠗⠚⠉⠛{la}<bt> reject()
⠎⠡{la}<bt> reject()
⠎⠙{la}<bt> reject()
⠩⠙{la}<bt> reject()
⠞⠙{la}<bt> reject()
⠞⠛⠗{la}<bt> reject()
⠞⠍{la}<bt> reject()
⠞⠝{la}<bt> reject()
⠮⠍⠧⠎{la}<bt> reject()
⠺⠙{la}<bt> reject()
⠭⠎{la}<bt> reject()
⠭⠋{la}<bt> reject()
⠽⠗{la}<bt> reject()
⠽⠗⠋{la}<bt> reject()
⠽⠗⠧⠎{la}<bt> reject()
/*}*/
<bt>{
	⠁⠃<INITIAL>	"about"
	⠁⠃⠧<INITIAL>	"above"
	⠁⠉<INITIAL>	"according"
	⠁⠉⠗<INITIAL>	"across"
	⠁⠋<INITIAL>	"after"
	⠁⠋⠝<INITIAL>	"afternoon"
	⠁⠋⠺<INITIAL>	"afterward"
	⠁⠛<INITIAL>	"again"
	⠁⠛⠌<INITIAL>	"against"
	⠁⠇<INITIAL>	"also"
	⠁⠇⠍<INITIAL>	"almost"
	⠁⠇⠗<INITIAL>	"already"
	⠁⠇⠞<INITIAL>	"altogether"
	⠁⠇⠹<INITIAL>	"although"
	⠁⠇⠺<INITIAL>	"always"
	⠆⠉<INITIAL>	"because"
	⠆⠋<INITIAL>	"before"
	⠆⠓<INITIAL>	"behind"
	⠆⠇<INITIAL>	"below"
	⠆⠝<INITIAL>	"beneath"
	⠆⠎<INITIAL>	"beside"
	⠆⠞<INITIAL>	"between"
	⠆⠽<INITIAL>	"beyond"
	⠃⠇<INITIAL>	"blind"
	⠃⠗⠇<INITIAL>	"Braille"
	⠉⠙<INITIAL>	"could"
	⠉⠧<INITIAL>	"ceive"
	⠉⠧⠛<INITIAL>	"ceiving"
	⠡⠝<INITIAL>	"children"
	⠙⠉⠇<INITIAL>	"declare"
	⠙⠉⠇⠛<INITIAL>	"declaring"
	⠑⠊<INITIAL>	"either"
	⠋⠌<INITIAL>	"first"
	⠋⠗<INITIAL>	"friend"
	⠛⠙<INITIAL>	"good"
	⠛⠗⠞<INITIAL>	"great"
	⠓⠻⠋<INITIAL>	"herself"
	⠓⠍<INITIAL>	"him"
	⠓⠍⠋<INITIAL>	"himself"
	⠊⠍⠍<INITIAL>	"immediate"
	⠇⠇<INITIAL>	"little"
	⠇⠗<INITIAL>	"letter"
	⠍⠡<INITIAL>	"much"
	⠍⠌<INITIAL>	"must"
	⠍⠽⠋<INITIAL>	"myself"
	⠝⠑⠉<INITIAL>	"necessary"
	⠝⠑⠊<INITIAL>	"neither"
	⠕⠄⠉<INITIAL>	"o'clock"
	⠳⠗⠧⠎<INITIAL>	"ourselves"
	⠏⠙<INITIAL>	"paid"
	⠏⠻⠓<INITIAL>	"perhaps"
	⠟⠅<INITIAL>	"quick"
	⠗⠚⠉<INITIAL>	"rejoice"
	⠗⠚⠉⠛<INITIAL>	"rejoicing"
	⠎⠡<INITIAL>	"such"
	⠎⠙<INITIAL>	"said"
	⠩⠙<INITIAL>	"should"
	⠞⠙<INITIAL>	"today"
	⠞⠛⠗<INITIAL>	"together"
	⠞⠍<INITIAL>	"tomorrow"
	⠞⠝<INITIAL>	"tonight"
	⠮⠍⠧⠎<INITIAL>	"themselves"
	⠺⠙<INITIAL>	"would"
	⠭⠎<INITIAL>	"its"
	⠭⠋<INITIAL>	"itself"
	⠽⠗<INITIAL>	"your"
	⠽⠗⠋<INITIAL>	"yourself"
	⠽⠗⠧⠎<INITIAL>	"yourselves"
}

/* DIGRAPHS */
<letters>{
	⠂	"ea"
	⠆	"bb"
	⠒	"cc"
	⠲	"dd"
/* FINAL ABBREVIATIONS */
	⠨⠙	"ound"
	⠨⠞	"ount"
	⠨⠑	"ance"
	⠨⠎	"less"
	⠨⠝	"sion"
	⠰⠛	"ong"
	⠰⠇	"ful"
	⠰⠞	"ment"
	⠰⠑	"ence"
	⠰⠎	"ness"
	⠰⠝	"tion"
	⠰⠽	"ity"
	⠠⠽	"ally"
	⠠⠝	"ation"
}

<INITIAL,letters,numbers>⠼<numbers>

<numbers>{
	⠁	'0'
	⠃	'1'
	⠉	'2'
	⠙	'3'
	⠑	'4'
	⠋	'5'
	⠛	'6'
	⠓	'7'
	⠊	'8'
	⠚	'9'
}

/* PUNCTUATION */
<INITIAL,letters,numbers>{
	⠂{la}<>bt> reject()
	⠆{la}<>bt> reject()
	⠒{la}<>bt> reject()
	⠲{la}<>bt> reject()
	⠤{la}<>bt> reject()
}
<bt>{
	⠂<<>	','
	⠆<<>	';'
	⠒<<>	':'
	⠲<<>	'.'
	⠤<<>	'-'
}
<INITIAL,letters,numbers>{
	⠖	'!'
	⠦	'?'
	⠶	'('
	⠴	'"'
	⠄	'\''
/* MODES */
	⠈          skip()     /* accent */
	⠨          skip()     /* emph. */
	⠠          skip()     /* caps = true; */
	/* SPACING */
	//\u{2800}<INITIAL>	' '
	"⠀"<INITIAL>	' '
	/*<*>[ \t\n\r]<INITIAL>       emit(text());*/
	[ ]<INITIAL>	' '
	[\t]<INITIAL>	'\t'
	[\n]<INITIAL>	'\n'
	[\r]<INITIAL>	'\r'
	/* OTHER BRAILLE LIGATURES */
	/*\p{Braille}     emit(text());*/

	//.            ILLEGAL_CHARACTER
}

%%
