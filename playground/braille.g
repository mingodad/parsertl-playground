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

%token ILLEGAL_CHARACTER

%token "a"
%token "b"
%token "c"
%token "d"
%token "e"
%token "f"
%token "g"
%token "h"
%token "i"
%token "j"
%token "k"
%token "l"
%token "m"
%token "n"
%token "o"
%token "p"
%token "q"
%token "r"
%token "s"
%token "t"
%token "u"
%token "v"
%token "w"
%token "x"
%token "y"
%token "z"
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

%token "0"
%token "1"
%token "2"
%token "3"
%token "4"
%token "5"
%token "6"
%token "7"
%token "8"
%token "9"

%token ","
%token ";"
%token ":"
%token "."
%token "-"
%token "!"
%token "?"
%token "("
%token "\""
%token "'"

%token " "
%token "\t"
%token "\n"
%token "\r"

%%

start :  ;

%%

// exclusive start conditions
%x letters numbers

/* lookaheads for contractions to be valid, spacing and punctuation !?("'- */
la [\u{2800} \t\n\r⠖⠦⠶⠴⠄⠤]

%%

<*>⠰<INITIAL>

<INITIAL,letters>⠁<letters>	"a"
<INITIAL,letters>⠃<letters>	"b"
<INITIAL,letters>⠉<letters>	"c"
<INITIAL,letters>⠙<letters>	"d"
<INITIAL,letters>⠑<letters>	"e"
<INITIAL,letters>⠋<letters>	"f"
<INITIAL,letters>⠛<letters>	"g"
<INITIAL,letters>⠓<letters>	"h"
<INITIAL,letters>⠊<letters>	"i"
<INITIAL,letters>⠚<letters>	"j"
<INITIAL,letters>⠅<letters>	"k"
<INITIAL,letters>⠇<letters>	"l"
<INITIAL,letters>⠍<letters>	"m"
<INITIAL,letters>⠝<letters>	"n"
<INITIAL,letters>⠕<letters>	"o"
<INITIAL,letters>⠏<letters>	"p"
<INITIAL,letters>⠟<letters>	"q"
<INITIAL,letters>⠗<letters>	"r"
<INITIAL,letters>⠎<letters>	"s"
<INITIAL,letters>⠞<letters>	"t"
<INITIAL,letters>⠥<letters>	"u"
<INITIAL,letters>⠧<letters>	"v"
<INITIAL,letters>⠺<letters>	"w"
<INITIAL,letters>⠭<letters>	"x"
<INITIAL,letters>⠽<letters>	"y"
<INITIAL,letters>⠵<letters>	"z"
<INITIAL,letters>⠯<letters>	"and"
<INITIAL,letters>⠿<letters>	"for"
<INITIAL,letters>⠷<letters>	"of"
<INITIAL,letters>⠮<letters>	"the"
<INITIAL,letters>⠾<letters>	"with"
<INITIAL,letters>⠡<letters>	"ch"
<INITIAL,letters>⠣<letters>	"gh"
<INITIAL,letters>⠩<letters>	"sh"
<INITIAL,letters>⠹<letters>	"th"
<INITIAL,letters>⠱<letters>	"wh"
<INITIAL,letters>⠫<letters>	"ed"
<INITIAL,letters>⠻<letters>	"er"
<INITIAL,letters>⠳<letters>	"ou"
<INITIAL,letters>⠪<letters>	"ow"
<INITIAL,letters>⠢<letters>	"en"
<INITIAL,letters>⠔<letters>	"in"
<INITIAL,letters>⠌<letters>	"st"
<INITIAL,letters>⠜<letters>	"ar"
<INITIAL,letters>⠬<letters>	"ing"
/* INITIAL ABBREVIATIONS */
<INITIAL,letters>⠐⠓<letters>	"here"
<INITIAL,letters>⠐⠮<letters>	"there"
<INITIAL,letters>⠐⠱<letters>	"where"
<INITIAL,letters>⠐⠑<letters>	"ever"
<INITIAL,letters>⠐⠳<letters>	"ought"
<INITIAL,letters>⠐⠋<letters>	"father"
<INITIAL,letters>⠐⠍<letters>	"mother"
<INITIAL,letters>⠐⠝<letters>	"name"
<INITIAL,letters>⠐⠡<letters>	"character"
<INITIAL,letters>⠐⠟<letters>	"question"
<INITIAL,letters>⠐⠅<letters>	"know"
<INITIAL,letters>⠐⠇<letters>	"lord"
<INITIAL,letters>⠐⠕<letters>	"one"
<INITIAL,letters>⠐⠙<letters>	"day"
<INITIAL,letters>⠐⠎<letters>	"some"
<INITIAL,letters>⠐⠏<letters>	"part"
<INITIAL,letters>⠐⠞<letters>	"time"
<INITIAL,letters>⠐⠗<letters>	"right"
<INITIAL,letters>⠐⠹<letters>	"through"
<INITIAL,letters>⠐⠥<letters>	"under"
<INITIAL,letters>⠐⠺<letters>	"work"
<INITIAL,letters>⠐⠽<letters>	"young"
<INITIAL,letters>⠘⠮<letters>	"these"
<INITIAL,letters>⠘⠹<letters>	"those"
<INITIAL,letters>⠘⠥<letters>	"upon"
<INITIAL,letters>⠘⠱<letters>	"whose"
<INITIAL,letters>⠘⠺<letters>	"word"
<INITIAL,letters>⠸⠉<letters>	"cannot"
<INITIAL,letters>⠸⠍<letters>	"many"
<INITIAL,letters>⠸⠓<letters>	"had"
<INITIAL,letters>⠸⠮<letters>	"their"
<INITIAL,letters>⠸⠎<letters>	"spirit"
<INITIAL,letters>⠸⠺<letters>	"world"


/*<INITIAL>{*/
/* CONTRACTIONS */
⠃/{la}	"but"
⠉/{la}	"can"
⠙/{la}	"do"
⠑/{la}	"every"
⠋/{la}	"from and -self"
⠛/{la}	"go"
⠓/{la}	"have"
⠚/{la}	"just"
⠅/{la}	"knowledge"
⠇/{la}	"like"
⠍/{la}	"more"
⠝/{la}	"not"
⠏/{la}	"people"
⠟/{la}	"quite"
⠗/{la}	"rather"
⠎/{la}	"so"
⠞/{la}	"that"
⠌/{la}	"still"
⠥/{la}	"us"
⠧/{la}	"very"
⠭/{la}	"it"
⠽/{la}	"you"
⠵/{la}	"as"
⠡/{la}	"child"
⠩/{la}	"shall"
⠹/{la}	"this"
⠱/{la}	"which"
⠳/{la}	"out"
⠺/{la}	"will"
⠆     	"be"
⠒     	"con"
⠲     	"dis"
⠢/{la}	"enough"
⠖/{la}	"to"
⠶/{la}	"were"
⠦/{la}	"his"
⠔/{la}	"in"
⠴/{la}	"and was"
⠤     	"com"
/* LONGER CONTRACTIONS */
⠁⠃/{la}	"about"
⠁⠃⠧/{la}	"above"
⠁⠉/{la}	"according"
⠁⠉⠗/{la}	"across"
⠁⠋/{la}	"after"
⠁⠋⠝/{la}	"afternoon"
⠁⠋⠺/{la}	"afterward"
⠁⠛/{la}	"again"
⠁⠛⠌/{la}	"against"
⠁⠇/{la}	"also"
⠁⠇⠍/{la}	"almost"
⠁⠇⠗/{la}	"already"
⠁⠇⠞/{la}	"altogether"
⠁⠇⠹/{la}	"although"
⠁⠇⠺/{la}	"always"
⠆⠉/{la}	"because"
⠆⠋/{la}	"before"
⠆⠓/{la}	"behind"
⠆⠇/{la}	"below"
⠆⠝/{la}	"beneath"
⠆⠎/{la}	"beside"
⠆⠞/{la}	"between"
⠆⠽/{la}	"beyond"
⠃⠇/{la}	"blind"
⠃⠗⠇/{la}	"Braille"
⠉⠙/{la}	"could"
⠉⠧/{la}	"ceive"
⠉⠧⠛/{la}	"ceiving"
⠡⠝/{la}	"children"
⠙⠉⠇/{la}	"declare"
⠙⠉⠇⠛/{la}	"declaring"
⠑⠊/{la}	"either"
⠋⠌/{la}	"first"
⠋⠗/{la}	"friend"
⠛⠙/{la}	"good"
⠛⠗⠞/{la}	"great"
⠓⠻⠋/{la}	"herself"
⠓⠍/{la}	"him"
⠓⠍⠋/{la}	"himself"
⠊⠍⠍/{la}	"immediate"
⠇⠇/{la}	"little"
⠇⠗/{la}	"letter"
⠍⠡/{la}	"much"
⠍⠌/{la}	"must"
⠍⠽⠋/{la}	"myself"
⠝⠑⠉/{la}	"necessary"
⠝⠑⠊/{la}	"neither"
⠕⠄⠉/{la}	"o'clock"
⠳⠗⠧⠎/{la}	"ourselves"
⠏⠙/{la}	"paid"
⠏⠻⠓/{la}	"perhaps"
⠟⠅/{la}	"quick"
⠗⠚⠉/{la}	"rejoice"
⠗⠚⠉⠛/{la}	"rejoicing"
⠎⠡/{la}	"such"
⠎⠙/{la}	"said"
⠩⠙/{la}	"should"
⠞⠙/{la}	"today"
⠞⠛⠗/{la}	"together"
⠞⠍/{la}	"tomorrow"
⠞⠝/{la}	"tonight"
⠮⠍⠧⠎/{la}	"themselves"
⠺⠙/{la}	"would"
⠭⠎/{la}	"its"
⠭⠋/{la}	"itself"
⠽⠗/{la}	"your"
⠽⠗⠋/{la}	"yourself"
⠽⠗⠧⠎/{la}	"yourselves"
/*}*/

/* DIGRAPHS */
<letters>⠂<.>	"ea"
<letters>⠆<.>	"bb"
<letters>⠒<.>	"cc"
<letters>⠲<.>	"dd"
/* FINAL ABBREVIATIONS */
<letters>⠨⠙<.>	"ound"
<letters>⠨⠞<.>	"ount"
<letters>⠨⠑<.>	"ance"
<letters>⠨⠎<.>	"less"
<letters>⠨⠝<.>	"sion"
<letters>⠰⠛<.>	"ong"
<letters>⠰⠇<.>	"ful"
<letters>⠰⠞<.>	"ment"
<letters>⠰⠑<.>	"ence"
<letters>⠰⠎<.>	"ness"
<letters>⠰⠝<.>	"tion"
<letters>⠰⠽<.>	"ity"
<letters>⠠⠽<.>	"ally"
<letters>⠠⠝<.>	"ation"

<*>⠼<numbers>

<numbers>⠁<.>	"0"
<numbers>⠃<.>	"1"
<numbers>⠉<.>	"2"
<numbers>⠙<.>	"3"
<numbers>⠑<.>	"4"
<numbers>⠋<.>	"5"
<numbers>⠛<.>	"6"
<numbers>⠓<.>	"7"
<numbers>⠊<.>	"8"
<numbers>⠚<.>	"9"

/* PUNCTUATION */
<*>⠂/{la}<.>	","
<*>⠆/{la}<.>	";"
<*>⠒/{la}<.>	":"
<*>⠲/{la}<.>	"."
<*>⠤/{la}<.>	"-"
<*>⠖<.>	"!"
<*>⠦<.>	"?"
<*>⠶<.>	"("
<*>⠴<.>	"\""
<*>⠄<.>	"'"
/* MODES */
<*>⠈<.>          skip()     /* accent */
<*>⠨<.>          skip()     /* emph. */
<*>⠠<.>          skip()     /* caps = true; */
/* SPACING */
<*>\u{2800}<INITIAL>	" "
/*<*>[ \t\n\r]<INITIAL>       emit(text());*/
<*>[ ]<INITIAL>	" "
<*>[\t]<INITIAL>	"\t"
<*>[\n]<INITIAL>	"\n"
<*>[\r]<INITIAL>	"\r"
/* OTHER BRAILLE LIGATURES */
/*<*>\p{Braille}<.>     emit(text());*/

<*>.<.>            ILLEGAL_CHARACTER

%%
