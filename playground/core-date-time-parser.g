//Fom: https://github.com/momentlib/core/blob/777b9a2b076352f40df520d4a7be88431919a284/parseIt.y

%token INTEGER DTPOSITION DAYOFWEEK MONTHNUM GENERALTIME FROM LASTNEXT BEFOREAFTER HENCEAGO IN THIS NOW INTHE SETDATE
%token WHENTIME TYPENAMES ARTICLEPREP  MILITARYTIME
%token NL

%%


program:
    %empty
	| program date_time NL
	;

date_time:
    %empty
	| date_time expr
	;

expr:
	expr BEFOREAFTER
	| FROM expr
	| SETDATE
	| ARTICLEPREP
	| IN
	| THIS
	| NOW
	| INTEGER   /********  ex. 6 (means the time if only a number)      ******/
	| MONTHNUM           /***** ex. "June"  ******/
	| DAYOFWEEK          /*****  ex.  "Friday"    *****/
	| IN INTEGER
	| IN MILITARYTIME
	| IN INTEGER TYPENAMES  /********  ex. "in 3 days" or "in 5 weeks" or "in 8 hours"     ******/
	| TYPENAMES
	| INTEGER TYPENAMES   /********  ex. "3 days"  mostly used with "before" or "after" as in "3 days before yesterday" ****/
	| INTEGER TYPENAMES HENCEAGO   /******* ex.  "3 days ago" or "5 years hence"    ******/
	| INTEGER generalTimes             /******* ex. "3 mornings"  mainly used with "before" or "after" *****/
	| INTEGER generalTimes HENCEAGO    /**** ex. "3 mornings ago" or "5 afternoons hence" *****/
	| LASTNEXT TYPENAMES                   /********** ex.  "Last Month" or "Next Year"   *******/
	| LASTNEXT DAYOFWEEK                   /********  ex. "last friday"  or "next friday"      ******/
	| LASTNEXT MONTHNUM                  /********  ex. "last May"  or "next May"      ******/
	| INTEGER INTHE generalTimes            /********  ex. " 6 in the morning"      ******/
	| INTEGER THIS generalTimes              /********  ex. " 6 this morning"      ******/
	| INTHE generalTimes                    /********  ex. "in the morning"      ******/
	| whenTime
	| whenTime INTHE generalTimes        /*******   4:30 in the afternoon   *******/
	| generalTimes                                  /****** ex. "morning"       *******/
	| LASTNEXT generalTimes                  /******* ex. "last night"   **********/
	| whenTime LASTNEXT generalTimes       /******  ex. "7:30 last night"   ********/
	| whenTime LASTNEXT DAYOFWEEK         /******  ex. "7:30pm last Tuesday"   ********/
	| whenTime THIS generalTimes                /*********   3:30 this morning       *********/
	| DTPOSITION TYPENAMES expr              /******* ex.  "4th day last week", "3rd month next year"   *******/
	| DTPOSITION DAYOFWEEK expr            /******* ex.  "4th saturday next month", "3rd wed. in November"   *******/
	| specAmountDayOrMonth
	;




specAmountDayOrMonth :
	INTEGER DAYOFWEEK                      /**** ex. "3 Fridays"  used with "before or after" "2 tues after next thurs" ****/
	| INTEGER DAYOFWEEK HENCEAGO               /***** ex. "3 fridays hence"   ****/
	| INTEGER MONTHNUM HENCEAGO                  /***** ex.  "3 Junes ago"    ******/
	| INTEGER MONTHNUM INTEGER                               /****  ex. "3 june 1997"   ******/
	| INTEGER MONTHNUM MILITARYTIME            /****  ex. "3 june 2011"  (had to do another to differentiate between military time and Year)  ******/
	| MONTHNUM INTEGER                                        /****  ex. "june 3"   ******/
	| MONTHNUM MILITARYTIME                                        /****  ex. "june 2008"   ******/
	| MONTHNUM DTPOSITION                                     /****  ex. "june 3rd"   ******/
	| MONTHNUM DTPOSITION INTEGER                             /***** ex. "june 3rd 1997"  *****/
	| MONTHNUM INTEGER INTEGER                                /****  ex. "june 3 1997"   ******/
	| MONTHNUM DTPOSITION MILITARYTIME
	| MONTHNUM INTEGER MILITARYTIME
	;


generalTimes:                                   /****** ex. "morning", "afternoon"  ********/
	GENERALTIME
	;

whenTime :                                                  /****** ex. "3:00" or "3pm" or "1830" ****/
	MILITARYTIME
	| WHENTIME
	;

%%

%option caseless

dateTimeTerms    (sec(ond)?|min(ute)?|hour|hr|day|week|month|year)s?

regularTime     ((0?[1-9])|(1[0|1|2]))((:[0-5][0-9](" "?(a|p)\.?m\.?)?)|(" "?(a|p)\.?m\.?))
militaryTime    (([0-1][0-9])|([2][0-3])):?([0-5][0-9])
specificTimes   noon|midnight
generalTime     (morning|afternoon|evening|night|tonight|tonite)s?



months  (jan(uary|uaries)?|feb(ruary|ruaries)?|mar(ch|ches)?|apr(il)?|may|june?|jul(y|ies)?|aug(ust)?|sep(t)?(ember)?|oct(ober)?|nov(ember)?|dec(ember)?)(s?)\.?
days    sun|mon|tues|wed(nes)?|thurs|fri|sat(ur)?


genericNum    (([0][1-9])|([1][0-2])|([1-9]))
daydate       (([1][3-9])|([2][0-9])|(3[01]))
yeardate      ([12]([0-9]{3}))

setModifier             on



times                   {regularTime}|{militaryTime}
onDay                   (on)" "{days}(day)?



%%

\n  NL

in" "the          INTHE
now               NOW

tomorrow          DAYOFWEEK
yesterday         DAYOFWEEK
today             DAYOFWEEK
from              FROM
last              LASTNEXT
next              LASTNEXT
ago|past          HENCEAGO
hence             HENCEAGO
before            BEFOREAFTER
after             BEFOREAFTER
in                IN
this              THIS



{dateTimeTerms}   TYPENAMES

{generalTime}      GENERALTIME
{specificTimes}   WHENTIME

{regularTime}     WHENTIME

{militaryTime}    MILITARYTIME

{months}          MONTHNUM

{days}(\.|days?)?      DAYOFWEEK

{daydate}"/"{genericNum}"/"{yeardate}    SETDATE                     /***** ex. 23/05/2012  *****/

{genericNum}"/"{daydate}"/"{yeardate}      SETDATE                    /***** ex. 11/23/2011  *****/

{genericNum}"/"{genericNum}"/"{yeardate}    SETDATE                   /***** ex. 11/11/2012  *****/
{daydate}"-"{genericNum}"-"{yeardate}    SETDATE                      /***** ex. 23-05-2012  *****/

{genericNum}"-"{daydate}"-"{yeardate}      SETDATE                    /***** ex. 11-23-2011  *****/

{genericNum}"-"{genericNum}"-"{yeardate}    SETDATE                   /***** ex. 11-11-2012  *****/

{yeardate}"/"{genericNum}"/"({genericNum}|{daydate})    SETDATE                  /***** ex. 2012/11/11  *****/

{yeardate}"-"{genericNum}"-"({genericNum}|{daydate})    SETDATE                  /***** ex. 2012-11-11  *****/

[0-9]+(st|nd|rd|th)  DTPOSITION

[0-9]+      INTEGER

at|@    ARTICLEPREP
the         skip()
[ \t,\r]       skip()       /* skip whitespace */

%%
