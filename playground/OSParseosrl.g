//From: https://github.com/coin-or/OS/blob/c31c2f0a23cd530926d55ad47ba0aabfc9a78e80/OS/src/OSParsers/OSParseosrl.y
/** @file OSParseosrl.y.1
 *
 * @author  Horand Gassmann, Jun Ma, Kipp Martin
 *
 * \remarks
 * Copyright (C) 2005-2015, Horand Gassmann, Jun Ma, Kipp Martin,
 * Northwestern University and the University of Chicago.
 * All Rights Reserved.
 * This software is licensed under the Eclipse Public License.
 * Please see the accompanying LICENSE file in root directory for terms.
 *
 * In order to allow easier maintenance of the parsers,
 * the files OSParseosrl.y and OSParseosrl.y are stored in several pieces
 * that are combined in the makefile.
 * This is the first part of the file OSParseosrl.y. It contains the
 * preamble and tokens that are unique to the OSrL parser.
 * Tokens pertaining to the auxiliary OSgL and OSnL parsers are appended.
 * These are in files OSParseosgl.y.tokens and OSParseosnl.y.tokens.
 * Then follow the syntax rules involving only OSrL constructs (OSParseosrl.y.2).
 * After that we put the syntax rules for elements from the OSgL schema,
 * maintained in the file OSParseosgl.y.syntax, and then the OSnL syntax
 * in OSParseosnl.y.syntax. The postamble in OSParseosrl.y.3 is appended at the end.
 * This process could be repeated for as many other auxiliary schemas as needed.
 *
 * Note: Make changes in this file rather than OSParseosrl.y or OSParserosrl.tab.cpp,
 *       as the latter files are recreated by the build system and are thus to be
 *       considered fragile.
 */

/*Tokens*/
%token ABSEND
%token ABSSTART
%token ACTUALSTARTTIMEEND
%token ACTUALSTARTTIMESTART
%token ALLDIFFEND
%token ALLDIFFSTART
%token ATEQUALITYEND
%token ATEQUALITYSTART
%token ATLOWEREND
%token ATLOWERSTART
%token ATTRIBUTETEXT
%token ATUPPEREND
%token ATUPPERSTART
%token AVAILABLECPUNUMBEREND
%token AVAILABLECPUNUMBERSTART
%token AVAILABLECPUSPEEDEND
%token AVAILABLECPUSPEEDSTART
%token AVAILABLEDISKSPACEEND
%token AVAILABLEDISKSPACESTART
%token AVAILABLEMEMORYEND
%token AVAILABLEMEMORYSTART
%token BASE64END
%token BASE64START
%token BASEMATRIXEND
%token BASEMATRIXENDCOLATT
%token BASEMATRIXENDROWATT
%token BASEMATRIXIDXATT
%token BASEMATRIXSTART
%token BASEMATRIXSTARTCOLATT
%token BASEMATRIXSTARTROWATT
%token BASETRANSPOSEATT
%token BASICEND
%token BASICSTART
%token BASISSTATUSEND
%token BASISSTATUSSTART
%token BLOCKCOLIDXATT
%token BLOCKEND
%token BLOCKROWIDXATT
%token BLOCKSEND
%token BLOCKSSTART
%token BLOCKSTART
//%token BOOLEAN
%token CATEGORYATT
%token COEFATT
%token COLOFFSETEND
%token COLOFFSETSTART
%token COMPLEXCONJUGATEEND
%token COMPLEXCONJUGATESTART
%token COMPLEXELEMENTSEND
%token COMPLEXELEMENTSSTART
%token COMPLEXMINUSEND
%token COMPLEXMINUSSTART
%token COMPLEXNEGATEEND
%token COMPLEXNEGATESTART
%token COMPLEXNUMBEREND
%token COMPLEXNUMBERSTART
%token COMPLEXPLUSEND
%token COMPLEXPLUSSTART
%token COMPLEXSQUAREEND
%token COMPLEXSQUARESTART
%token COMPLEXSUMEND
%token COMPLEXSUMSTART
%token COMPLEXTIMESEND
%token COMPLEXTIMESSTART
%token COMPLEXVALUEDEXPRESSIONSSEND
%token COMPLEXVALUEDEXPRESSIONSSTART
%token CONEND
%token CONREFERENCEELEMENTSEND
%token CONREFERENCEELEMENTSSTART
%token CONSTANTATT
%token CONSTANTELEMENTSEND
%token CONSTANTELEMENTSSTART
%token CONSTART
%token CONSTRAINTSEND
%token CONSTRAINTSSTART
%token CONTYPEATT
%token COSEND
%token COSSTART
%token CREATECOMPLEXEND
%token CREATECOMPLEXSTART
%token CURRENTJOBCOUNTEND
%token CURRENTJOBCOUNTSTART
%token CURRENTSTATEEND
%token CURRENTSTATESTART
%token DESCRIPTIONATT
%token DIVIDEEND
%token DIVIDESTART
%token DOUBLE
%token DUALVALUESEND
%token DUALVALUESSTART
//%token DUMMY
%token EEND
//%token ELEMENTSEND
//%token ELEMENTSSTART
%token ELEMENTTEXT
%token ELEND
%token ELSTART
%token EMPTYBASETRANSPOSEATT
%token EMPTYCATEGORYATT
%token EMPTYCONTYPEATT
%token EMPTYDESCRIPTIONATT
%token EMPTYENUMTYPEATT
//%token EMPTYIDATT
//%token EMPTYINCLUDEDIAGONALATT
//%token EMPTYMATRIXCONTYPEATT
//%token EMPTYMATRIXOBJTYPEATT
//%token EMPTYMATRIXTYPEATT
%token EMPTYMATRIXVARTYPEATT
%token EMPTYNAMEATT
%token EMPTYOBJTYPEATT
%token EMPTYROWMAJORATT
%token EMPTYSHAPEATT
%token EMPTYSOLVERATT
%token EMPTYSYMMETRYATT
//%token EMPTYTARGETOBJECTIVENAMEATT
//%token EMPTYTRANSPOSEATT
%token EMPTYTYPEATT
%token EMPTYUNITATT
%token EMPTYVALUEATT
%token EMPTYVALUETYPEATT
%token EMPTYVARTYPEATT
//%token EMPTYWEIGHTEDOBJECTIVESATT
%token ENDOFELEMENT
%token ENDTIMEEND
%token ENDTIMESTART
%token ENUMERATIONEND
%token ENUMERATIONSTART
%token ENUMTYPEATT
%token ERFEND
%token ERFSTART
%token ESTART
%token EXPEND
//%token EXPREND
//%token EXPRSTART
%token EXPSTART
%token FILECREATOREMPTY
%token FILECREATOREND
%token FILECREATORSTART
%token FILECREATORSTARTANDEND
%token FILEDESCRIPTIONEMPTY
%token FILEDESCRIPTIONEND
%token FILEDESCRIPTIONSTART
%token FILEDESCRIPTIONSTARTANDEND
%token FILELICENCEEMPTY
%token FILELICENCEEND
%token FILELICENCESTART
%token FILELICENCESTARTANDEND
%token FILENAMEEMPTY
%token FILENAMEEND
%token FILENAMESTART
%token FILENAMESTARTANDEND
%token FILESOURCEEMPTY
%token FILESOURCEEND
%token FILESOURCESTART
%token FILESOURCESTARTANDEND
%token GENERALEND
%token GENERALSTART
%token GENERALSTATUSEND
%token GENERALSTATUSSTART
//%token GENERALSUBSTATUSEND
//%token GENERALSUBSTATUSSTART
%token GREATERTHAN
%token HEADEREND
%token HEADERSTART
%token IDATT
%token IDENTITYMATRIXEND
%token IDENTITYMATRIXSTART
%token IDXATT
//%token IDXEND
//%token IDXSTART
%token IFEND
%token IFSTART
%token IMATT
%token INCLUDEDIAGONALATT
%token INCRATT
%token INDEXEND
//%token INDEXESEND
//%token INDEXESSTART
%token INDEXSTART
%token INSTANCENAMEEND
%token INSTANCENAMESTART
%token INTEGER
%token ISFREEEND
%token ISFREESTART
%token ITEMEMPTY
%token ITEMEND
%token ITEMSTART
%token ITEMSTARTANDEND
%token ITEMTEXT
%token JOBEND
%token JOBIDEND
%token JOBIDSTART
%token JOBSTART
%token LINEARELEMENTSEND
%token LINEARELEMENTSSTART
%token LNEND
%token LNSTART
//%token MATRICESEND
//%token MATRICESSTART
%token MATRIXCONEND
//%token MATRIXCONIDXATT
%token MATRIXCONSTART
//%token MATRIXCONSTRAINTSEND
//%token MATRIXCONSTRAINTSSTART
//%token MATRIXCONTYPEATT
%token MATRIXDETERMINANTEND
%token MATRIXDETERMINANTSTART
%token MATRIXDIAGONALEND
%token MATRIXDIAGONALSTART
%token MATRIXDOTTIMESEND
%token MATRIXDOTTIMESSTART
//%token MATRIXEND
//%token MATRIXEXPRESSIONSEND
//%token MATRIXEXPRESSIONSSTART
%token MATRIXINVERSEEND
%token MATRIXINVERSESTART
%token MATRIXLOWERTRIANGLEEND
%token MATRIXLOWERTRIANGLESTART
%token MATRIXMERGEEND
%token MATRIXMERGESTART
%token MATRIXMINUSEND
%token MATRIXMINUSSTART
%token MATRIXNEGATEEND
%token MATRIXNEGATESTART
//%token MATRIXOBJECTIVESEND
//%token MATRIXOBJECTIVESSTART
%token MATRIXOBJEND
//%token MATRIXOBJIDXATT
%token MATRIXOBJSTART
//%token MATRIXOBJTYPEATT
%token MATRIXPLUSEND
%token MATRIXPLUSSTART
%token MATRIXPRODUCTEND
%token MATRIXPRODUCTSTART
%token MATRIXPROGRAMMINGEND
%token MATRIXPROGRAMMINGSTART
%token MATRIXREFERENCEEND
%token MATRIXREFERENCESTART
%token MATRIXSCALARTIMESEND
%token MATRIXSCALARTIMESSTART
//%token MATRIXSTART
%token MATRIXSUBMATRIXATEND
%token MATRIXSUBMATRIXATSTART
%token MATRIXSUMEND
%token MATRIXSUMSTART
//%token MATRIXTERMEND
//%token MATRIXTERMSTART
%token MATRIXTIMESEND
%token MATRIXTIMESSTART
%token MATRIXTOSCALAREND
%token MATRIXTOSCALARSTART
%token MATRIXTRACEEND
%token MATRIXTRACESTART
%token MATRIXTRANSPOSEEND
%token MATRIXTRANSPOSESTART
//%token MATRIXTYPEATT
%token MATRIXUPPERTRIANGLEEND
%token MATRIXUPPERTRIANGLESTART
%token MATRIXVAREND
%token MATRIXVARIABLESEND
%token MATRIXVARIABLESSTART
%token MATRIXVARIDXATT
%token MATRIXVARSTART
%token MATRIXVARTYPEATT
%token MAXEND
%token MAXSTART
%token MESSAGEEND
%token MESSAGESTART
%token MINEND
%token MINSTART
%token MINUSEND
%token MINUSSTART
%token MULTATT
%token NAMEATT
%token NEGATEEND
%token NEGATESTART
//%token NLEND
//%token NLSTART
//%token NONLINEAREXPRESSIONSEND
//%token NONLINEAREXPRESSIONSSTART
//%token NONZEROSEND
//%token NONZEROSSTART
%token NUMBEREND
%token NUMBEROFBLOCKSATT
%token NUMBEROFCOLUMNSATT
%token NUMBEROFCONATT
//%token NUMBEROFCONIDXATT
%token NUMBEROFCONSTRAINTSATT
%token NUMBEROFELATT
%token NUMBEROFENUMERATIONSATT
//%token NUMBEROFEXPR
%token NUMBEROFITEMSATT
//%token NUMBEROFMATRICESATT
//%token NUMBEROFMATRIXCONATT
//%token NUMBEROFMATRIXOBJATT
//%token NUMBEROFMATRIXTERMSATT
%token NUMBEROFMATRIXVARATT
//%token NUMBEROFNONLINEAREXPRESSIONS
%token NUMBEROFOBJATT
%token NUMBEROFOBJECTIVESATT
//%token NUMBEROFOBJIDXATT
%token NUMBEROFOTHERCONSTRAINTRESULTSATT
//%token NUMBEROFOTHERMATRIXCONSTRAINTRESULTSATT
//%token NUMBEROFOTHERMATRIXOBJECTIVERESULTSATT
%token NUMBEROFOTHERMATRIXPROGRAMMINGRESULTSATT
%token NUMBEROFOTHERMATRIXVARIABLERESULTSATT
%token NUMBEROFOTHEROBJECTIVERESULTSATT
%token NUMBEROFOTHERRESULTSATT
%token NUMBEROFOTHERSOLUTIONRESULTSATT
%token NUMBEROFOTHERVARIABLERESULTSATT
%token NUMBEROFROWSATT
%token NUMBEROFSOLUTIONSATT
%token NUMBEROFSOLVEROUTPUTSATT
%token NUMBEROFSUBSTATUSESATT
%token NUMBEROFTIMESATT
%token NUMBEROFVALUESATT
%token NUMBEROFVARATT
%token NUMBEROFVARIABLESATT
%token NUMBEROFVARIDXATT
%token NUMBERSTART
%token OBJECTIVESEND
%token OBJECTIVESSTART
%token OBJEND
%token OBJREFERENCEELEMENTSEND
%token OBJREFERENCEELEMENTSSTART
%token OBJSTART
%token OBJTYPEATT
%token OPTIMIZATIONEND
//%token OPTIMIZATIONSOLUTIONSTATUSEND
//%token OPTIMIZATIONSOLUTIONSTATUSSTART
//%token OPTIMIZATIONSOLUTIONSUBSTATUSEND
//%token OPTIMIZATIONSOLUTIONSUBSTATUSSTART
%token OPTIMIZATIONSTART
%token OSRLATTRIBUTETEXT
%token OSRLEND
%token OSRLSTART
%token OSRLSTARTEMPTY
%token OTHEREND
//%token OTHERMATRIXCONSTRAINTRESULTEND
//%token OTHERMATRIXCONSTRAINTRESULTSTART
//%token OTHERMATRIXOBJECTIVERESULTEND
//%token OTHERMATRIXOBJECTIVERESULTSTART
//%token OTHERMATRIXPROGRAMMINGRESULTEND
%token OTHERMATRIXPROGRAMMINGRESULTSTART
//%token OTHERMATRIXVARIABLERESULTEND
//%token OTHERMATRIXVARIABLERESULTSTART
%token OTHERRESULTSEND
%token OTHERRESULTSSTART
%token OTHERSOLUTIONRESULTEND
%token OTHERSOLUTIONRESULTSEND
%token OTHERSOLUTIONRESULTSSTART
%token OTHERSOLUTIONRESULTSTART
%token OTHERSOLVEROUTPUTEND
%token OTHERSOLVEROUTPUTSTART
%token OTHERSTART
%token PIEND
%token PISTART
%token PLUSEND
%token PLUSSTART
%token POWEREND
%token POWERSTART
%token PRODUCTEND
%token PRODUCTSTART
%token QUOTE
%token REALVALUEDEXPRESSIONSSEND
%token REALVALUEDEXPRESSIONSSTART
%token REATT
%token ROWMAJORATT
%token ROWOFFSETEND
%token ROWOFFSETSTART
%token SCALARIMAGINARYPARTATT
%token SCALARMULTIPLIERATT
%token SCHEDULEDSTARTTIMEEND
%token SCHEDULEDSTARTTIMESTART
%token SERVICEEND
%token SERVICENAMEEND
%token SERVICENAMESTART
%token SERVICESTART
%token SERVICEURIEND
%token SERVICEURISTART
%token SERVICEUTILIZATIONEND
%token SERVICEUTILIZATIONSTART
%token SHAPEATT
%token SINEND
%token SINSTART
%token SIZEOFATT
%token SOLUTIONEND
%token SOLUTIONSTART
%token SOLVERATT
%token SOLVERINVOKEDEND
%token SOLVERINVOKEDSTART
%token SOLVEROUTPUTEND
%token SOLVEROUTPUTSTART
%token SQRTEND
%token SQRTSTART
%token SQUAREEND
%token SQUARESTART
%token STARTVECTOREND
%token STARTVECTORSTART
%token STATUSEND
%token STATUSSTART
%token STRINGVALUEDELEMENTSEND
%token STRINGVALUEDELEMENTSSTART
%token SUBMITTIMEEND
%token SUBMITTIMESTART
%token SUBSTATUSEND
%token SUBSTATUSSTART
%token SUMEND
%token SUMSTART
%token SUPERBASICEND
%token SUPERBASICSTART
%token SYMMETRYATT
%token SYSTEMEND
%token SYSTEMINFORMATIONEND
%token SYSTEMINFORMATIONSTART
%token SYSTEMSTART
%token TARGETMATRIXFIRSTCOLATT
%token TARGETMATRIXFIRSTROWATT
%token TARGETOBJECTIVEIDXATT
%token TARGETOBJECTIVENAMEATT
%token TIMEEND
%token TIMESEND
%token TIMESERVICESTARTEDEND
%token TIMESERVICESTARTEDSTART
%token TIMESSTART
%token TIMESTAMPEND
%token TIMESTAMPSTART
%token TIMESTART
%token TIMINGINFORMATIONEND
%token TIMINGINFORMATIONSTART
%token TOTALJOBSSOFAREND
%token TOTALJOBSSOFARSTART
%token TRANSFORMATIONEND
%token TRANSFORMATIONSTART
%token TRANSPOSEATT
//%token TWOQUOTES
%token TYPEATT
%token UNITATT
%token UNKNOWNEND
%token UNKNOWNSTART
%token USEDCPUNUMBEREND
%token USEDCPUNUMBERSTART
%token USEDCPUSPEEDEND
%token USEDCPUSPEEDSTART
%token USEDDISKSPACEEND
%token USEDDISKSPACESTART
%token USEDMEMORYEND
%token USEDMEMORYSTART
%token VALUEATT
%token VALUEEND
%token VALUESEND
%token VALUESSTART
%token VALUESSTRINGEND
%token VALUESSTRINGSTART
%token VALUESTART
%token VALUETYPEATT
%token VAREND
%token VARIABLEEND
%token VARIABLESEND
%token VARIABLESSTART
%token VARIABLESTART
%token VARIDXEND
%token VARIDXSTART
%token VARREFERENCEELEMENTSEND
%token VARREFERENCEELEMENTSSTART
%token VARSTART
%token VARTYPEATT
%token WEIGHTEDOBJECTIVESATT


%start osrldoc

%%

osrldoc :
	osrlStartEmpty osrlBody osrlEnd
	| osrlStart osrlAttributes osrlContent
	;

osrlStartEmpty :
	OSRLSTARTEMPTY
	;

osrlStart :
	OSRLSTART
	;

osrlAttributes :
	/*empty*/
	| OSRLATTRIBUTETEXT
	;

osrlContent :
	osrlEmpty
	| osrlLaden
	;

osrlEmpty :
	ENDOFELEMENT
	;

osrlLaden :
	GREATERTHAN osrlBody osrlEnd
	;

osrlEnd :
	osrlEnding
	;

osrlEnding :
	OSRLEND
	| /*empty*/
	;

osrlBody :
	headerElement generalElement systemElement serviceElement jobElement optimizationElement
	;

headerElement :
	/*empty*/
	| osglFileHeader
	;

generalElement :
	/*empty*/
	| generalElementStart generalElementContent
	;

generalElementStart :
	GENERALSTART
	;

generalElementContent :
	generalElementEmpty
	| generalElementLaden
	;

generalElementEmpty :
	GREATERTHAN GENERALEND
	| ENDOFELEMENT
	;

generalElementLaden :
	GREATERTHAN generalElementBody GENERALEND
	;

generalElementBody :
	generalElementList
	;

generalElementList :
	generalChild
	| generalElementList generalChild
	;

generalChild :
	generalStatus
	| generalMessage
	| serviceURI
	| serviceName
	| instanceName
	| jobID
	| solverInvoked
	| timeStamp
	| otherGeneralResults
	;

generalStatus :
	generalStatusStart generalStatusAttributes generalStatusContent
	;

generalStatusStart :
	GENERALSTATUSSTART
	;

generalStatusAttributes :
	generalStatusAttList
	;

generalStatusAttList :
	generalStatusATT
	| generalStatusAttList generalStatusATT
	;

generalStatusATT :
	osglTypeATT
	| osglDescriptionATT
	| numberOfSubstatusesAttribute
	;

generalStatusContent :
	generalStatusEmpty
	| generalStatusLaden
	;

generalStatusEmpty :
	GREATERTHAN GENERALSTATUSEND
	| ENDOFELEMENT
	;

generalStatusLaden :
	GREATERTHAN generalStatusBody GENERALSTATUSEND
	;

generalStatusBody :
	generalSubstatusArray
	;

generalSubstatusArray :
	generalSubstatus
	| generalSubstatusArray generalSubstatus
	;

generalSubstatus :
	generalSubstatusStart generalSubstatusAttributes generalSubstatusEnd
	;

generalSubstatusStart :
	SUBSTATUSSTART
	;

generalSubstatusAttributes :
	generalSubstatusAttList
	;

generalSubstatusAttList :
	/*empty*/
	| generalSubstatusAttList generalSubstatusATT
	;

generalSubstatusATT :
	osglNameATT
	| osglDescriptionATT
	;

generalSubstatusEnd :
	GREATERTHAN SUBSTATUSEND
	| ENDOFELEMENT
	;

generalMessage :
	generalMessageStart generalMessageContent
	;

generalMessageStart :
	MESSAGESTART
	;

generalMessageContent :
	generalMessageEmpty
	| generalMessageLaden
	;

generalMessageEmpty :
	GREATERTHAN MESSAGEEND
	| ENDOFELEMENT
	;

generalMessageLaden :
	GREATERTHAN generalMessageBody MESSAGEEND
	;

generalMessageBody :
	ELEMENTTEXT
	;

serviceURI :
	serviceURIStart serviceURIContent
	;

serviceURIStart :
	SERVICEURISTART
	;

serviceURIContent :
	serviceURIEmpty
	| serviceURILaden
	;

serviceURIEmpty :
	GREATERTHAN SERVICEURIEND
	| ENDOFELEMENT
	;

serviceURILaden :
	GREATERTHAN serviceURIBody SERVICEURIEND
	;

serviceURIBody :
	ELEMENTTEXT
	;

serviceName :
	serviceNameStart serviceNameContent
	;

serviceNameStart :
	SERVICENAMESTART
	;

serviceNameContent :
	serviceNameEmpty
	| serviceNameLaden
	;

serviceNameEmpty :
	GREATERTHAN SERVICENAMEEND
	| ENDOFELEMENT
	;

serviceNameLaden :
	GREATERTHAN serviceNameBody SERVICENAMEEND
	;

serviceNameBody :
	ELEMENTTEXT
	;

instanceName :
	instanceNameStart instanceNameContent
	;

instanceNameStart :
	INSTANCENAMESTART
	;

instanceNameContent :
	instanceNameEmpty
	| instanceNameLaden
	;

instanceNameEmpty :
	GREATERTHAN INSTANCENAMEEND
	| ENDOFELEMENT
	;

instanceNameLaden :
	GREATERTHAN instanceNameBody INSTANCENAMEEND
	;

instanceNameBody :
	ELEMENTTEXT
	;

jobID :
	jobIDStart jobIDContent
	;

jobIDStart :
	JOBIDSTART
	;

jobIDContent :
	jobIDEmpty
	| jobIDLaden
	;

jobIDEmpty :
	GREATERTHAN JOBIDEND
	| ENDOFELEMENT
	;

jobIDLaden :
	GREATERTHAN jobIDBody JOBIDEND
	;

jobIDBody :
	ELEMENTTEXT
	;

solverInvoked :
	solverInvokedStart solverInvokedContent
	;

solverInvokedStart :
	SOLVERINVOKEDSTART
	;

solverInvokedContent :
	solverInvokedEmpty
	| solverInvokedLaden
	;

solverInvokedEmpty :
	GREATERTHAN SOLVERINVOKEDEND
	| ENDOFELEMENT
	;

solverInvokedLaden :
	GREATERTHAN solverInvokedBody SOLVERINVOKEDEND
	;

solverInvokedBody :
	ELEMENTTEXT
	;

timeStamp :
	timeStampStart timeStampContent
	;

timeStampStart :
	TIMESTAMPSTART
	;

timeStampContent :
	timeStampEmpty
	| timeStampLaden
	;

timeStampEmpty :
	GREATERTHAN TIMESTAMPEND
	| ENDOFELEMENT
	;

timeStampLaden :
	GREATERTHAN timeStampBody TIMESTAMPEND
	;

timeStampBody :
	ELEMENTTEXT
	;

otherGeneralResults :
	otherGeneralResultsStart otherGeneralResultsAttributes otherGeneralResultsContent
	;

otherGeneralResultsStart :
	OTHERRESULTSSTART
	;

otherGeneralResultsAttributes :
	numberOfOtherResultsAttribute
	;

otherGeneralResultsContent :
	otherGeneralResultsEmpty
	| otherGeneralResultsLaden
	;

otherGeneralResultsEmpty :
	GREATERTHAN OTHERRESULTSEND
	| ENDOFELEMENT
	;

otherGeneralResultsLaden :
	GREATERTHAN otherGeneralResultsBody OTHERRESULTSEND
	;

otherGeneralResultsBody :
	otherGeneralResultArray
	;

otherGeneralResultArray :
	otherGeneralResult
	| otherGeneralResultArray otherGeneralResult
	;

otherGeneralResult :
	otherGeneralResultStart otherGeneralResultAttributes otherGeneralResultEnd
	;

otherGeneralResultStart :
	OTHERSTART
	;

otherGeneralResultAttributes :
	otherGeneralResultAttList
	;

otherGeneralResultAttList :
	/*empty*/
	| otherGeneralResultAttList otherGeneralResultAtt
	;

otherGeneralResultAtt :
	osglNameATT
	| osglValueATT
	| osglDescriptionATT
	;

otherGeneralResultEnd :
	GREATERTHAN OTHEREND
	| ENDOFELEMENT
	;

systemElement :
	/*empty*/
	| systemElementStart systemElementContent
	;

systemElementStart :
	SYSTEMSTART
	;

systemElementContent :
	systemElementEmpty
	| systemElementLaden
	;

systemElementEmpty :
	GREATERTHAN SYSTEMEND
	| ENDOFELEMENT
	;

systemElementLaden :
	GREATERTHAN systemElementBody SYSTEMEND
	;

systemElementBody :
	systemElementList
	;

systemElementList :
	systemChild
	| systemElementList systemChild
	;

systemChild :
	systemInformation
	| availableDiskSpace
	| availableMemory
	| availableCPUSpeed
	| availableCPUNumber
	| otherSystemResults
	;

systemInformation :
	systemInformationStart systemInformationContent
	;

systemInformationStart :
	SYSTEMINFORMATIONSTART
	;

systemInformationContent :
	systemInformationEmpty
	| systemInformationLaden
	;

systemInformationEmpty :
	GREATERTHAN SYSTEMINFORMATIONEND
	| ENDOFELEMENT
	;

systemInformationLaden :
	GREATERTHAN systemInformationBody SYSTEMINFORMATIONEND
	;

systemInformationBody :
	ELEMENTTEXT
	;

availableDiskSpace :
	availableDiskSpaceStart availableDiskSpaceAttributes availableDiskSpaceContent
	;

availableDiskSpaceStart :
	AVAILABLEDISKSPACESTART
	;

availableDiskSpaceAttributes :
	availableDiskSpaceAttList
	;

availableDiskSpaceAttList :
	/*empty*/
	| availableDiskSpaceAttList availableDiskSpaceAtt
	;

availableDiskSpaceAtt :
	osglUnitATT
	| osglDescriptionATT
	;

availableDiskSpaceContent :
	GREATERTHAN availableDiskSpaceValue AVAILABLEDISKSPACEEND
	;

availableDiskSpaceValue :
	aNumber
	;

availableMemory :
	availableMemoryStart availableMemoryAttributes availableMemoryContent
	;

availableMemoryStart :
	AVAILABLEMEMORYSTART
	;

availableMemoryAttributes :
	availableMemoryAttList
	;

availableMemoryAttList :
	/*empty*/
	| availableMemoryAttList availableMemoryAtt
	;

availableMemoryAtt :
	osglUnitATT
	| osglDescriptionATT
	;

availableMemoryContent :
	GREATERTHAN availableMemoryValue AVAILABLEMEMORYEND
	;

availableMemoryValue :
	aNumber
	;

availableCPUSpeed :
	availableCPUSpeedStart availableCPUSpeedAttributes availableCPUSpeedContent
	;

availableCPUSpeedStart :
	AVAILABLECPUSPEEDSTART
	;

availableCPUSpeedAttributes :
	availableCPUSpeedAttList
	;

availableCPUSpeedAttList :
	/*empty*/
	| availableCPUSpeedAttList availableCPUSpeedAtt
	;

availableCPUSpeedAtt :
	osglUnitATT
	| osglDescriptionATT
	;

availableCPUSpeedContent :
	GREATERTHAN availableCPUSpeedValue AVAILABLECPUSPEEDEND
	;

availableCPUSpeedValue :
	aNumber
	;

availableCPUNumber :
	availableCPUNumberStart availableCPUNumberAttributes availableCPUNumberContent
	;

availableCPUNumberStart :
	AVAILABLECPUNUMBERSTART
	;

availableCPUNumberAttributes :
	/*empty*/
	| osglDescriptionATT
	;

availableCPUNumberContent :
	GREATERTHAN availableCPUNumberValue AVAILABLECPUNUMBEREND
	;

availableCPUNumberValue :
	INTEGER
	;

otherSystemResults :
	otherSystemResultsStart otherSystemResultsAttributes otherSystemResultsContent
	;

otherSystemResultsStart :
	OTHERRESULTSSTART
	;

otherSystemResultsAttributes :
	numberOfOtherResultsAttribute
	;

otherSystemResultsContent :
	otherSystemResultsEmpty
	| otherSystemResultsLaden
	;

otherSystemResultsEmpty :
	GREATERTHAN OTHERRESULTSEND
	| ENDOFELEMENT
	;

otherSystemResultsLaden :
	GREATERTHAN otherSystemResultsBody OTHERRESULTSEND
	;

otherSystemResultsBody :
	otherSystemResultArray
	;

otherSystemResultArray :
	otherSystemResult
	| otherSystemResultArray otherSystemResult
	;

otherSystemResult :
	otherSystemResultStart otherSystemResultAttributes otherSystemResultEnd
	;

otherSystemResultStart :
	OTHERSTART
	;

otherSystemResultAttributes :
	otherSystemResultAttList
	;

otherSystemResultAttList :
	/*empty*/
	| otherSystemResultAttList otherSystemResultAtt
	;

otherSystemResultAtt :
	osglNameATT
	| osglValueATT
	| osglDescriptionATT
	;

otherSystemResultEnd :
	GREATERTHAN OTHEREND
	| ENDOFELEMENT
	;

serviceElement :
	/*empty*/
	| serviceElementStart serviceElementContent
	;

serviceElementStart :
	SERVICESTART
	;

serviceElementContent :
	serviceElementEmpty
	| serviceElementLaden
	;

serviceElementEmpty :
	GREATERTHAN SERVICEEND
	| ENDOFELEMENT
	;

serviceElementLaden :
	GREATERTHAN serviceElementBody SERVICEEND
	;

serviceElementBody :
	serviceElementList
	;

serviceElementList :
	serviceChild
	| serviceElementList serviceChild
	;

serviceChild :
	currentState
	| currentJobCount
	| totalJobsSoFar
	| timeServiceStarted
	| serviceUtilization
	| otherServiceResults
	;

currentState :
	currentStateStart currentStateContent
	;

currentStateStart :
	CURRENTSTATESTART
	;

currentStateContent :
	currentStateEmpty
	| currentStateLaden
	;

currentStateEmpty :
	GREATERTHAN CURRENTSTATEEND
	| ENDOFELEMENT
	;

currentStateLaden :
	GREATERTHAN currentStateBody CURRENTSTATEEND
	;

currentStateBody :
	ELEMENTTEXT
	;

currentJobCount :
	currentJobCountStart currentJobCountContent
	;

currentJobCountStart :
	CURRENTJOBCOUNTSTART
	;

currentJobCountContent :
	currentJobCountEmpty
	| currentJobCountLaden
	;

currentJobCountEmpty :
	GREATERTHAN CURRENTJOBCOUNTEND
	| ENDOFELEMENT
	;

currentJobCountLaden :
	GREATERTHAN currentJobCountBody CURRENTJOBCOUNTEND
	;

currentJobCountBody :
	INTEGER
	;

totalJobsSoFar :
	totalJobsSoFarStart totalJobsSoFarContent
	;

totalJobsSoFarStart :
	TOTALJOBSSOFARSTART
	;

totalJobsSoFarContent :
	totalJobsSoFarEmpty
	| totalJobsSoFarLaden
	;

totalJobsSoFarEmpty :
	GREATERTHAN TOTALJOBSSOFAREND
	| ENDOFELEMENT
	;

totalJobsSoFarLaden :
	GREATERTHAN totalJobsSoFarBody TOTALJOBSSOFAREND
	;

totalJobsSoFarBody :
	INTEGER
	;

timeServiceStarted :
	timeServiceStartedStart timeServiceStartedContent
	;

timeServiceStartedStart :
	TIMESERVICESTARTEDSTART
	;

timeServiceStartedContent :
	timeServiceStartedEmpty
	| timeServiceStartedLaden
	;

timeServiceStartedEmpty :
	GREATERTHAN TIMESERVICESTARTEDEND
	| ENDOFELEMENT
	;

timeServiceStartedLaden :
	GREATERTHAN timeServiceStartedBody TIMESERVICESTARTEDEND
	;

timeServiceStartedBody :
	ELEMENTTEXT
	;

serviceUtilization :
	serviceUtilizationStart serviceUtilizationContent
	;

serviceUtilizationStart :
	SERVICEUTILIZATIONSTART
	;

serviceUtilizationContent :
	serviceUtilizationEmpty
	| serviceUtilizationLaden
	;

serviceUtilizationEmpty :
	GREATERTHAN SERVICEUTILIZATIONEND
	| ENDOFELEMENT
	;

serviceUtilizationLaden :
	GREATERTHAN serviceUtilizationBody SERVICEUTILIZATIONEND
	;

serviceUtilizationBody :
	aNumber
	;

otherServiceResults :
	otherServiceResultsStart otherServiceResultsAttributes otherServiceResultsContent
	;

otherServiceResultsStart :
	OTHERRESULTSSTART
	;

otherServiceResultsAttributes :
	numberOfOtherResultsAttribute
	;

otherServiceResultsContent :
	otherServiceResultsEmpty
	| otherServiceResultsLaden
	;

otherServiceResultsEmpty :
	GREATERTHAN OTHERRESULTSEND
	| ENDOFELEMENT
	;

otherServiceResultsLaden :
	GREATERTHAN otherServiceResultsBody OTHERRESULTSEND
	;

otherServiceResultsBody :
	otherServiceResultArray
	;

otherServiceResultArray :
	otherServiceResult
	| otherServiceResultArray otherServiceResult
	;

otherServiceResult :
	otherServiceResultStart otherServiceResultAttributes otherServiceResultEnd
	;

otherServiceResultStart :
	OTHERSTART
	;

otherServiceResultAttributes :
	otherServiceResultAttList
	;

otherServiceResultAttList :
	/*empty*/
	| otherServiceResultAttList otherServiceResultAtt
	;

otherServiceResultAtt :
	osglNameATT
	| osglValueATT
	| osglDescriptionATT
	;

otherServiceResultEnd :
	GREATERTHAN OTHEREND
	| ENDOFELEMENT
	;

jobElement :
	/*empty*/
	| jobElementStart jobElementContent
	;

jobElementStart :
	JOBSTART
	;

jobElementContent :
	jobElementEmpty
	| jobElementLaden
	;

jobElementEmpty :
	GREATERTHAN JOBEND
	| ENDOFELEMENT
	;

jobElementLaden :
	GREATERTHAN jobElementBody JOBEND
	;

jobElementBody :
	jobElementList
	;

jobElementList :
	jobChild
	| jobElementList jobChild
	;

jobChild :
	jobStatus
	| submitTime
	| scheduledStartTime
	| actualStartTime
	| endTime
	| timingInformation
	| usedDiskSpace
	| usedMemory
	| usedCPUSpeed
	| usedCPUNumber
	| otherJobResults
	;

jobStatus :
	jobStatusStart jobStatusContent
	;

jobStatusStart :
	STATUSSTART
	;

jobStatusContent :
	jobStatusEmpty
	| jobStatusLaden
	;

jobStatusEmpty :
	GREATERTHAN STATUSEND
	| ENDOFELEMENT
	;

jobStatusLaden :
	GREATERTHAN jobStatusBody STATUSEND
	;

jobStatusBody :
	ELEMENTTEXT
	;

submitTime :
	submitTimeStart submitTimeContent
	;

submitTimeStart :
	SUBMITTIMESTART
	;

submitTimeContent :
	submitTimeEmpty
	| submitTimeLaden
	;

submitTimeEmpty :
	GREATERTHAN SUBMITTIMEEND
	| ENDOFELEMENT
	;

submitTimeLaden :
	GREATERTHAN submitTimeBody SUBMITTIMEEND
	;

submitTimeBody :
	ELEMENTTEXT
	;

scheduledStartTime :
	scheduledStartTimeStart scheduledStartTimeContent
	;

scheduledStartTimeStart :
	SCHEDULEDSTARTTIMESTART
	;

scheduledStartTimeContent :
	scheduledStartTimeEmpty
	| scheduledStartTimeLaden
	;

scheduledStartTimeEmpty :
	GREATERTHAN SCHEDULEDSTARTTIMEEND
	| ENDOFELEMENT
	;

scheduledStartTimeLaden :
	GREATERTHAN scheduledStartTimeBody SCHEDULEDSTARTTIMEEND
	;

scheduledStartTimeBody :
	ELEMENTTEXT
	;

actualStartTime :
	actualStartTimeStart actualStartTimeContent
	;

actualStartTimeStart :
	ACTUALSTARTTIMESTART
	;

actualStartTimeContent :
	actualStartTimeEmpty
	| actualStartTimeLaden
	;

actualStartTimeEmpty :
	GREATERTHAN ACTUALSTARTTIMEEND
	| ENDOFELEMENT
	;

actualStartTimeLaden :
	GREATERTHAN actualStartTimeBody ACTUALSTARTTIMEEND
	;

actualStartTimeBody :
	ELEMENTTEXT
	;

endTime :
	endTimeStart endTimeContent
	;

endTimeStart :
	ENDTIMESTART
	;

endTimeContent :
	endTimeEmpty
	| endTimeLaden
	;

endTimeEmpty :
	GREATERTHAN ENDTIMEEND
	| ENDOFELEMENT
	;

endTimeLaden :
	GREATERTHAN endTimeBody ENDTIMEEND
	;

endTimeBody :
	ELEMENTTEXT
	;

timingInformation :
	timingInformationStart timingInformationAttributes timingInformationContent
	;

timingInformationStart :
	TIMINGINFORMATIONSTART
	;

timingInformationAttributes :
	numberOfTimesAttribute
	;

timingInformationContent :
	timingInformationEmpty
	| timingInformationLaden
	;

timingInformationEmpty :
	GREATERTHAN TIMINGINFORMATIONEND
	| ENDOFELEMENT
	;

timingInformationLaden :
	GREATERTHAN timingInformationBody TIMINGINFORMATIONEND
	;

timingInformationBody :
	timeArray
	;

timeArray :
	time
	| timeArray time
	;

time :
	timeStart timeAttributes timeContent
	;

timeStart :
	TIMESTART
	;

timeAttributes :
	/*empty*/
	| timeAttributes timeAtt
	;

timeAtt :
	osglUnitATT
	| osglTypeATT
	| osglCategoryATT
	| osglDescriptionATT
	;

timeContent :
	timeEmpty
	| timeLaden
	;

timeEmpty :
	GREATERTHAN TIMEEND
	| ENDOFELEMENT
	;

timeLaden :
	GREATERTHAN timeBody TIMEEND
	;

timeBody :
	timeValue
	;

timeValue :
	DOUBLE
	| INTEGER
	;

usedDiskSpace :
	usedDiskSpaceStart usedDiskSpaceAttributes usedDiskSpaceContent
	;

usedDiskSpaceStart :
	USEDDISKSPACESTART
	;

usedDiskSpaceAttributes :
	usedDiskSpaceAttList
	;

usedDiskSpaceAttList :
	/*empty*/
	| usedDiskSpaceAttList usedDiskSpaceAtt
	;

usedDiskSpaceAtt :
	osglUnitATT
	| osglDescriptionATT
	;

usedDiskSpaceContent :
	GREATERTHAN usedDiskSpaceValue USEDDISKSPACEEND
	;

usedDiskSpaceValue :
	aNumber
	;

usedMemory :
	usedMemoryStart usedMemoryAttributes usedMemoryContent
	;

usedMemoryStart :
	USEDMEMORYSTART
	;

usedMemoryAttributes :
	usedMemoryAttList
	;

usedMemoryAttList :
	/*empty*/
	| usedMemoryAttList usedMemoryAtt
	;

usedMemoryAtt :
	osglUnitATT
	| osglDescriptionATT
	;

usedMemoryContent :
	GREATERTHAN usedMemoryValue USEDMEMORYEND
	;

usedMemoryValue :
	aNumber
	;

usedCPUSpeed :
	usedCPUSpeedStart usedCPUSpeedAttributes usedCPUSpeedContent
	;

usedCPUSpeedStart :
	USEDCPUSPEEDSTART
	;

usedCPUSpeedAttributes :
	usedCPUSpeedAttList
	;

usedCPUSpeedAttList :
	/*empty*/
	| usedCPUSpeedAttList usedCPUSpeedAtt
	;

usedCPUSpeedAtt :
	osglUnitATT
	| osglDescriptionATT
	;

usedCPUSpeedContent :
	GREATERTHAN usedCPUSpeedValue USEDCPUSPEEDEND
	;

usedCPUSpeedValue :
	aNumber
	;

usedCPUNumber :
	usedCPUNumberStart usedCPUNumberAttributes usedCPUNumberContent
	;

usedCPUNumberStart :
	USEDCPUNUMBERSTART
	;

usedCPUNumberAttributes :
	/*empty*/
	| osglDescriptionATT
	;

usedCPUNumberContent :
	GREATERTHAN usedCPUNumberValue USEDCPUNUMBEREND
	;

usedCPUNumberValue :
	INTEGER
	;

otherJobResults :
	otherJobResultsStart otherJobResultsAttributes otherJobResultsContent
	;

otherJobResultsStart :
	OTHERRESULTSSTART
	;

otherJobResultsAttributes :
	numberOfOtherResultsAttribute
	;

otherJobResultsContent :
	otherJobResultsEmpty
	| otherJobResultsLaden
	;

otherJobResultsEmpty :
	GREATERTHAN OTHERRESULTSEND
	| ENDOFELEMENT
	;

otherJobResultsLaden :
	GREATERTHAN otherJobResultsBody OTHERRESULTSEND
	;

otherJobResultsBody :
	otherJobResultArray
	;

otherJobResultArray :
	otherJobResult
	| otherJobResultArray otherJobResult
	;

otherJobResult :
	otherJobResultStart otherJobResultAttributes otherJobResultEnd
	;

otherJobResultStart :
	OTHERSTART
	;

otherJobResultAttributes :
	otherJobResultAttList
	;

otherJobResultAttList :
	/*empty*/
	| otherJobResultAttList otherJobResultAtt
	;

otherJobResultAtt :
	osglNameATT
	| osglValueATT
	| osglDescriptionATT
	;

otherJobResultEnd :
	GREATERTHAN OTHEREND
	| ENDOFELEMENT
	;

optimizationElement :
	/*empty*/
	| optimizationStart optimizationAttributes optimizationContent
	;

optimizationStart :
	OPTIMIZATIONSTART
	;

optimizationAttributes :
	optimizationAttList
	;

optimizationAttList :
	/*empty*/
	| optimizationAttList optimizationATT
	;

optimizationATT :
	numberOfSolutionsAttribute
	| osglNumberOfVariablesATT
	| osglNumberOfConstraintsATT
	| osglNumberOfObjectivesATT
	;

optimizationContent :
	optimizationEmpty
	| optimizationLaden
	;

optimizationEmpty :
	GREATERTHAN OPTIMIZATIONEND
	| ENDOFELEMENT
	;

optimizationLaden :
	GREATERTHAN optimizationBody OPTIMIZATIONEND
	;

optimizationBody :
	solutionArray otherSolverOutput
	;

solutionArray :
	solution
	| solutionArray solution
	;

solution :
	solutionStart solutionAttributes solutionContent
	;

solutionStart :
	SOLUTIONSTART
	;

solutionAttributes :
	solutionAttList
	;

solutionAttList :
	/*empty*/
	| solutionAttList solutionATT
	;

solutionATT :
	targetObjectiveIdxATT
	| targetObjectiveNameATT
	| weightedObjectivesATT
	;

targetObjectiveIdxATT :
	TARGETOBJECTIVEIDXATT quote INTEGER quote
	;

targetObjectiveNameATT :
	TARGETOBJECTIVENAMEATT ATTRIBUTETEXT quote
	;

weightedObjectivesATT :
	WEIGHTEDOBJECTIVESATT ATTRIBUTETEXT quote
	;

solutionContent :
	GREATERTHAN solutionStatus solutionMessage variables objectives constraints matrixProgramming otherSolutionResults SOLUTIONEND
	;

solutionStatus :
	solutionStatusStart solutionStatusAttributes solutionStatusContent
	;

solutionStatusStart :
	STATUSSTART
	;

solutionStatusAttributes :
	solutionStatusAttList
	;

solutionStatusAttList :
	solutionStatusATT
	| solutionStatusAttList solutionStatusATT
	;

solutionStatusATT :
	osglTypeATT
	| osglDescriptionATT
	| numberOfSubstatusesAttribute
	;

solutionStatusContent :
	solutionStatusEmpty
	| solutionStatusLaden
	;

solutionStatusEmpty :
	GREATERTHAN STATUSEND
	| ENDOFELEMENT
	;

solutionStatusLaden :
	GREATERTHAN solutionStatusBody STATUSEND
	;

solutionStatusBody :
	solutionSubstatusArray
	;

solutionSubstatusArray :
	solutionSubstatus
	| solutionSubstatusArray solutionSubstatus
	;

solutionSubstatus :
	solutionSubstatusStart solutionSubstatusAttributes solutionSubstatusEnd
	;

solutionSubstatusStart :
	SUBSTATUSSTART
	;

solutionSubstatusAttributes :
	solutionSubstatusAttList
	;

solutionSubstatusAttList :
	/*empty*/
	| solutionSubstatusAttList solutionSubstatusATT
	;

solutionSubstatusATT :
	osglTypeATT
	| osglDescriptionATT
	;

solutionSubstatusEnd :
	GREATERTHAN SUBSTATUSEND
	| ENDOFELEMENT
	;

solutionMessage :
	/*empty*/
	| solutionMessageStart solutionMessageContent
	;

solutionMessageStart :
	MESSAGESTART
	;

solutionMessageContent :
	solutionMessageEmpty
	| solutionMessageLaden
	;

solutionMessageEmpty :
	GREATERTHAN MESSAGEEND
	| ENDOFELEMENT
	;

solutionMessageLaden :
	GREATERTHAN solutionMessageBody MESSAGEEND
	;

solutionMessageBody :
	ELEMENTTEXT
	;

variables :
	/*empty*/
	| variablesStart numberOfOtherVariableResults variablesContent
	;

variablesStart :
	VARIABLESSTART
	;

numberOfOtherVariableResults :
	/*empty*/
	| numberOfOtherVariableResultsAttribute
	;

variablesContent :
	variablesEmpty
	| variablesLaden
	;

variablesEmpty :
	ENDOFELEMENT
	;

variablesLaden :
	GREATERTHAN variablesBody VARIABLESEND
	;

variablesBody :
	variableValues variableValuesString variableBasisStatus otherVariableResultsArray
	;

variableValues :
	/*empty*/
	| variableValuesStart numberOfVarATT variableValuesContent
	;

variableValuesStart :
	VALUESSTART
	;

numberOfVarATT :
	osglNumberOfVarATT
	;

variableValuesContent :
	variableValuesEmpty
	| variableValuesLaden
	;

variableValuesEmpty :
	GREATERTHAN VALUESEND
	| ENDOFELEMENT
	;

variableValuesLaden :
	GREATERTHAN variableValuesBody VALUESEND
	;

variableValuesBody :
	varValueArray
	;

varValueArray :
	varValue
	| varValueArray varValue
	;

varValue :
	varValueStart varValueAttList varValueContent
	;

varValueStart :
	VARSTART
	;

varValueAttList :
	/*empty*/
	| varValueAttList varValueAtt
	;

varValueAtt :
	osglIdxATT
	| osglNameATT
	;

varValueContent :
	GREATERTHAN aNumber VAREND
	;

variableValuesString :
	/*empty*/
	| variableValuesStringStart numberOfVarStringATT variableValuesStringContent
	;

variableValuesStringStart :
	VALUESSTRINGSTART
	;

numberOfVarStringATT :
	osglNumberOfVarATT
	;

variableValuesStringContent :
	variableValuesStringEmpty
	| variableValuesStringLaden
	;

variableValuesStringEmpty :
	GREATERTHAN VALUESSTRINGEND
	| ENDOFELEMENT
	;

variableValuesStringLaden :
	GREATERTHAN variableValuesStringBody VALUESSTRINGEND
	;

variableValuesStringBody :
	varValueStringArray
	;

varValueStringArray :
	varValueString
	| varValueStringArray varValueString
	;

varValueString :
	varValueStringStart varValueStringAttList varValueStringContent
	;

varValueStringStart :
	VARSTART
	;

varValueStringAttList :
	/*empty*/
	| varValueStringAttList varValueStringAtt
	;

varValueStringAtt :
	osglIdxATT
	| osglNameATT
	;

varValueStringContent :
	varValueStringEmpty
	| varValueStringLaden
	;

varValueStringEmpty :
	GREATERTHAN VAREND
	| ENDOFELEMENT
	;

varValueStringLaden :
	GREATERTHAN varValueStringBody VAREND
	;

varValueStringBody :
	ELEMENTTEXT
	;

variableBasisStatus :
	/*empty*/
	| variableBasisStatusStart variableBasisStatusContent
	;

variableBasisStatusStart :
	BASISSTATUSSTART
	;

variableBasisStatusContent :
	variableBasisStatusEmpty
	| variableBasisStatusLaden
	;

variableBasisStatusEmpty :
	ENDOFELEMENT
	;

variableBasisStatusLaden :
	GREATERTHAN variableBasisStatusBody BASISSTATUSEND
	;

variableBasisStatusBody :
	variablesBasic variablesAtLower variablesAtUpper variablesAtEquality variablesIsFree variablesSuperbasic variablesUnknown
	;

variablesBasic :
	/*empty*/
	| osglBasisStatusBasic
	;

variablesAtLower :
	/*empty*/
	| osglBasisStatusAtLower
	;

variablesAtUpper :
	/*empty*/
	| osglBasisStatusAtUpper
	;

variablesAtEquality :
	/*empty*/
	| osglBasisStatusAtEquality
	;

variablesIsFree :
	/*empty*/
	| osglBasisStatusIsFree
	;

variablesSuperbasic :
	/*empty*/
	| osglBasisStatusSuperbasic
	;

variablesUnknown :
	/*empty*/
	| osglBasisStatusUnknown
	;

otherVariableResultsArray :
	/*empty*/
	| otherVariableResultsArray otherVariableResult
	;

otherVariableResult :
	otherVariableResultStart otherVariableResultAttributes otherVariableResultContent
	;

otherVariableResultStart :
	OTHERSTART
	;

otherVariableResultAttributes :
	otherVariableResultAttList
	;

otherVariableResultAttList :
	/*empty*/
	| otherVariableResultAttList otherVariableResultATT
	;

otherVariableResultATT :
	osglNumberOfVarATT
	| osglNumberOfEnumerationsATT
	| osglValueATT
	| osglSolverATT
	| osglNameATT
	| osglTypeATT
	| osglVarTypeATT
	| osglEnumTypeATT
	| osglDescriptionATT
	;

otherVariableResultContent :
	otherVariableResultEmpty
	| otherVariableResultLaden
	;

otherVariableResultEmpty :
	GREATERTHAN OTHEREND
	| ENDOFELEMENT
	;

otherVariableResultLaden :
	GREATERTHAN otherVariableResultBody OTHEREND
	;

otherVariableResultBody :
	otherVarList
	| otherVarEnumerationList
	;

otherVarList :
	otherVar
	| otherVarList otherVar
	;

otherVar :
	otherVarStart otherVarAttList otherVarContent
	;

otherVarStart :
	VARSTART
	;

otherVarAttList :
	/*empty*/
	| otherVarAttList otherVarAtt
	;

otherVarAtt :
	osglIdxATT
	| osglNameATT
	;

otherVarContent :
	otherVarEmpty
	| otherVarLaden
	;

otherVarEmpty :
	GREATERTHAN VAREND
	| ENDOFELEMENT
	;

otherVarLaden :
	GREATERTHAN otherVarBody VAREND
	;

otherVarBody :
	ElementValue
	;

otherVarEnumerationList :
	otherVarEnumeration
	| otherVarEnumerationList otherVarEnumeration
	;

otherVarEnumeration :
	otherVarEnumerationStart otherVarEnumerationAttributes otherVarEnumerationContent
	;

otherVarEnumerationStart :
	ENUMERATIONSTART
	;

otherVarEnumerationAttributes :
	otherVarEnumerationAttList
	;

otherVarEnumerationAttList :
	/*empty*/
	| otherVarEnumerationAttList otherVarEnumerationATT
	;

otherVarEnumerationATT :
	osglNumberOfElATT
	| osglValueATT
	| osglDescriptionATT
	;

otherVarEnumerationContent :
	otherVarEnumerationEmpty
	| otherVarEnumerationLaden
	;

otherVarEnumerationEmpty :
	ENDOFELEMENT
	;

otherVarEnumerationLaden :
	GREATERTHAN otherVarEnumerationBody ENUMERATIONEND
	;

otherVarEnumerationBody :
	osglIntArrayData
	;

objectives :
	/*empty*/
	| objectivesStart numberOfOtherObjectiveResults objectivesContent
	;

objectivesStart :
	OBJECTIVESSTART
	;

numberOfOtherObjectiveResults :
	/*empty*/
	| numberOfOtherObjectiveResultsAttribute
	;

objectivesContent :
	objectivesEmpty
	| objectivesLaden
	;

objectivesEmpty :
	ENDOFELEMENT
	;

objectivesLaden :
	GREATERTHAN objectivesBody OBJECTIVESEND
	;

objectivesBody :
	objectiveValues objectiveBasisStatus otherObjectiveResultsArray
	;

objectiveValues :
	/*empty*/
	| objectiveValuesStart numberOfObjATT objectiveValuesContent
	;

objectiveValuesStart :
	VALUESSTART
	;

numberOfObjATT :
	osglNumberOfObjATT
	;

objectiveValuesContent :
	objectiveValuesEmpty
	| objectiveValuesLaden
	;

objectiveValuesEmpty :
	GREATERTHAN VALUESEND
	| ENDOFELEMENT
	;

objectiveValuesLaden :
	GREATERTHAN objectiveValuesBody VALUESEND
	;

objectiveValuesBody :
	objValueArray
	;

objValueArray :
	objValue
	| objValueArray objValue
	;

objValue :
	objValueStart objValueAttList objValueContent
	;

objValueStart :
	OBJSTART
	;

objValueAttList :
	/*empty*/
	| objValueAttList objValueAtt
	;

objValueAtt :
	osglIdxATT
	| osglNameATT
	;

objValueContent :
	GREATERTHAN aNumber OBJEND
	;

objectiveBasisStatus :
	/*empty*/
	| objectiveBasisStatusStart objectiveBasisStatusContent
	;

objectiveBasisStatusStart :
	BASISSTATUSSTART
	;

objectiveBasisStatusContent :
	objectiveBasisStatusEmpty
	| objectiveBasisStatusLaden
	;

objectiveBasisStatusEmpty :
	ENDOFELEMENT
	;

objectiveBasisStatusLaden :
	GREATERTHAN objectiveBasisStatusBody BASISSTATUSEND
	;

objectiveBasisStatusBody :
	objectivesBasic objectivesAtLower objectivesAtUpper objectivesAtEquality objectivesIsFree objectivesSuperbasic objectivesUnknown
	;

objectivesBasic :
	/*empty*/
	| osglBasisStatusBasic
	;

objectivesAtLower :
	/*empty*/
	| osglBasisStatusAtLower
	;

objectivesAtUpper :
	/*empty*/
	| osglBasisStatusAtUpper
	;

objectivesAtEquality :
	/*empty*/
	| osglBasisStatusAtEquality
	;

objectivesIsFree :
	/*empty*/
	| osglBasisStatusIsFree
	;

objectivesSuperbasic :
	/*empty*/
	| osglBasisStatusSuperbasic
	;

objectivesUnknown :
	/*empty*/
	| osglBasisStatusUnknown
	;

otherObjectiveResultsArray :
	/*empty*/
	| otherObjectiveResultsArray otherObjectiveResult
	;

otherObjectiveResult :
	otherObjectiveResultStart otherObjectiveResultAttributes otherObjectiveResultContent
	;

otherObjectiveResultStart :
	OTHERSTART
	;

otherObjectiveResultAttributes :
	otherObjectiveResultAttList
	;

otherObjectiveResultAttList :
	/*empty*/
	| otherObjectiveResultAttList otherObjectiveResultATT
	;

otherObjectiveResultATT :
	osglNumberOfObjATT
	| osglNumberOfEnumerationsATT
	| osglValueATT
	| osglSolverATT
	| osglNameATT
	| osglTypeATT
	| osglObjTypeATT
	| osglEnumTypeATT
	| osglDescriptionATT
	;

otherObjectiveResultContent :
	otherObjectiveResultEmpty
	| otherObjectiveResultLaden
	;

otherObjectiveResultEmpty :
	GREATERTHAN OTHEREND
	| ENDOFELEMENT
	;

otherObjectiveResultLaden :
	GREATERTHAN otherObjectiveResultBody OTHEREND
	;

otherObjectiveResultBody :
	otherObjList
	| otherObjEnumerationList
	;

otherObjList :
	otherObj
	| otherObjList otherObj
	;

otherObj :
	otherObjStart otherObjAttList otherObjContent
	;

otherObjStart :
	OBJSTART
	;

otherObjAttList :
	/*empty*/
	| otherObjAttList otherObjAtt
	;

otherObjAtt :
	osglIdxATT
	| osglNameATT
	;

otherObjContent :
	otherObjEmpty
	| otherObjLaden
	;

otherObjEmpty :
	GREATERTHAN OBJEND
	| ENDOFELEMENT
	;

otherObjLaden :
	GREATERTHAN otherObjBody OBJEND
	;

otherObjBody :
	ElementValue
	;

otherObjEnumerationList :
	otherObjEnumeration
	| otherObjEnumerationList otherObjEnumeration
	;

otherObjEnumeration :
	otherObjEnumerationStart otherObjEnumerationAttributes otherObjEnumerationContent
	;

otherObjEnumerationStart :
	ENUMERATIONSTART
	;

otherObjEnumerationAttributes :
	otherObjEnumerationAttList
	;

otherObjEnumerationAttList :
	/*empty*/
	| otherObjEnumerationAttList otherObjEnumerationATT
	;

otherObjEnumerationATT :
	osglNumberOfElATT
	| osglValueATT
	| osglDescriptionATT
	;

otherObjEnumerationContent :
	otherObjEnumerationEmpty
	| otherObjEnumerationLaden
	;

otherObjEnumerationEmpty :
	ENDOFELEMENT
	;

otherObjEnumerationLaden :
	GREATERTHAN otherObjEnumerationBody ENUMERATIONEND
	;

otherObjEnumerationBody :
	osglIntArrayData
	;

constraints :
	/*empty*/
	| constraintsStart numberOfOtherConstraintResults constraintsContent
	;

constraintsStart :
	CONSTRAINTSSTART
	;

numberOfOtherConstraintResults :
	/*empty*/
	| numberOfOtherConstraintResultsAttribute
	;

constraintsContent :
	constraintsEmpty
	| constraintsLaden
	;

constraintsEmpty :
	ENDOFELEMENT
	;

constraintsLaden :
	GREATERTHAN constraintsBody CONSTRAINTSEND
	;

constraintsBody :
	dualValues slackBasisStatus otherConstraintResultsArray
	;

dualValues :
	/*empty*/
	| dualValuesStart numberOfConAttribute dualValuesContent
	;

dualValuesStart :
	DUALVALUESSTART
	;

numberOfConAttribute :
	osglNumberOfConATT
	;

dualValuesContent :
	dualValuesEmpty
	| dualValuesLaden
	;

dualValuesEmpty :
	GREATERTHAN DUALVALUESEND
	| ENDOFELEMENT
	;

dualValuesLaden :
	GREATERTHAN dualValuesBody DUALVALUESEND
	;

dualValuesBody :
	dualValueArray
	;

dualValueArray :
	dualValue
	| dualValueArray dualValue
	;

dualValue :
	dualValueStart dualValueAttList dualValueContent
	;

dualValueStart :
	CONSTART
	;

dualValueAttList :
	/*empty*/
	| dualValueAttList dualValueAtt
	;

dualValueAtt :
	osglIdxATT
	| osglNameATT
	;

dualValueContent :
	GREATERTHAN aNumber CONEND
	;

slackBasisStatus :
	/*empty*/
	| slackBasisStatusStart slackBasisStatusContent
	;

slackBasisStatusStart :
	BASISSTATUSSTART
	;

slackBasisStatusContent :
	slackBasisStatusEmpty
	| slackBasisStatusLaden
	;

slackBasisStatusEmpty :
	ENDOFELEMENT
	;

slackBasisStatusLaden :
	GREATERTHAN slackBasisStatusBody BASISSTATUSEND
	;

slackBasisStatusBody :
	slacksBasic slacksAtLower slacksAtUpper slacksAtEquality slacksIsFree slacksSuperbasic slacksUnknown
	;

slacksBasic :
	/*empty*/
	| osglBasisStatusBasic
	;

slacksAtLower :
	/*empty*/
	| osglBasisStatusAtLower
	;

slacksAtUpper :
	/*empty*/
	| osglBasisStatusAtUpper
	;

slacksAtEquality :
	/*empty*/
	| osglBasisStatusAtEquality
	;

slacksIsFree :
	/*empty*/
	| osglBasisStatusIsFree
	;

slacksSuperbasic :
	/*empty*/
	| osglBasisStatusSuperbasic
	;

slacksUnknown :
	/*empty*/
	| osglBasisStatusUnknown
	;

otherConstraintResultsArray :
	/*empty*/
	| otherConstraintResultsArray otherConstraintResult
	;

otherConstraintResult :
	otherConstraintResultStart otherConstraintResultAttributes otherConstraintResultContent
	;

otherConstraintResultStart :
	OTHERSTART
	;

otherConstraintResultAttributes :
	otherConstraintResultAttList
	;

otherConstraintResultAttList :
	/*empty*/
	| otherConstraintResultAttList otherConstraintResultATT
	;

otherConstraintResultATT :
	osglNumberOfConATT
	| osglNumberOfEnumerationsATT
	| osglValueATT
	| osglSolverATT
	| osglNameATT
	| osglTypeATT
	| osglConTypeATT
	| osglEnumTypeATT
	| osglDescriptionATT
	;

otherConstraintResultContent :
	otherConstraintResultEmpty
	| otherConstraintResultLaden
	;

otherConstraintResultEmpty :
	GREATERTHAN OTHEREND
	| ENDOFELEMENT
	;

otherConstraintResultLaden :
	GREATERTHAN otherConstraintResultBody OTHEREND
	;

otherConstraintResultBody :
	otherConList
	| otherConEnumerationList
	;

otherConList :
	otherCon
	| otherConList otherCon
	;

otherCon :
	otherConStart otherConAttList otherConContent
	;

otherConStart :
	CONSTART
	;

otherConAttList :
	/*empty*/
	| otherConAttList otherConAtt
	;

otherConAtt :
	osglIdxATT
	| osglNameATT
	;

otherConContent :
	otherConEmpty
	| otherConLaden
	;

otherConEmpty :
	GREATERTHAN CONEND
	| ENDOFELEMENT
	;

otherConLaden :
	GREATERTHAN otherConBody CONEND
	;

otherConBody :
	ElementValue
	;

otherConEnumerationList :
	otherConEnumeration
	| otherConEnumerationList otherConEnumeration
	;

otherConEnumeration :
	otherConEnumerationStart otherConEnumerationAttributes otherConEnumerationContent
	;

otherConEnumerationStart :
	ENUMERATIONSTART
	;

otherConEnumerationAttributes :
	otherConEnumerationAttList
	;

otherConEnumerationAttList :
	/*empty*/
	| otherConEnumerationAttList otherConEnumerationATT
	;

otherConEnumerationATT :
	osglNumberOfElATT
	| osglValueATT
	| osglDescriptionATT
	;

otherConEnumerationContent :
	otherConEnumerationEmpty
	| otherConEnumerationLaden
	;

otherConEnumerationEmpty :
	ENDOFELEMENT
	;

otherConEnumerationLaden :
	GREATERTHAN otherConEnumerationBody ENUMERATIONEND
	;

otherConEnumerationBody :
	osglIntArrayData
	;

matrixProgramming :
	/*empty*/
	| matrixProgrammingStart matrixProgrammingAttributes matrixProgrammingContent
	;

matrixProgrammingStart :
	MATRIXPROGRAMMINGSTART
	;

matrixProgrammingAttributes :
	/*empty*/
	| numberOfOtherMatrixProgrammingResultsATT
	;

matrixProgrammingContent :
	matrixProgrammingEmpty
	| matrixProgrammingLaden
	;

matrixProgrammingEmpty :
	ENDOFELEMENT
	;

matrixProgrammingLaden :
	GREATERTHAN matrixVariables otherMatrixProgrammingResults MATRIXPROGRAMMINGEND
	;

matrixVariables :
	/*empty*/
	| matrixVariablesStart matrixVariablesAttributes matrixVariablesContent
	;

matrixVariablesStart :
	MATRIXVARIABLESSTART
	;

matrixVariablesAttributes :
	numberOfOtherMatrixVariableResultsATT
	;

matrixVariablesContent :
	matrixVariablesEmpty
	| matrixVariablesLaden
	;

matrixVariablesEmpty :
	ENDOFELEMENT
	;

matrixVariablesLaden :
	GREATERTHAN matrixVariableValues otherMatrixVariableResults matrixVariablesEnd
	;

matrixVariablesEnd :
	MATRIXVARIABLESEND
	;

matrixVariableValues :
	/*empty*/
	| matrixVariableValuesStart matrixVariableValuesAttributes matrixVariableValuesContent
	;

matrixVariableValuesStart :
	VALUESSTART
	;

matrixVariableValuesAttributes :
	osglNumberOfMatrixVarATT
	;

matrixVariableValuesContent :
	matrixVariableValuesEmpty
	| matrixVariableValuesLaden
	;

matrixVariableValuesEmpty :
	ENDOFELEMENT
	;

matrixVariableValuesLaden :
	GREATERTHAN matrixVarList matrixVariableValuesEnd
	;

matrixVariableValuesEnd :
	VALUESEND
	;

matrixVarList :
	/*empty*/
	| matrixVarList osglMatrixWithMatrixVarIdx
	;

otherMatrixVariableResults :
	/*empty*/
	| otherMatrixVariableResults otherMatrixVariableResult
	;

otherMatrixVariableResult :
	otherMatrixVariableResultStart otherMatrixVariableResultAttributes otherMatrixVariableResultContent
	;

otherMatrixVariableResultStart :
	OTHERSTART
	;

otherMatrixVariableResultAttributes :
	otherMatrixVariableResultAttList
	;

otherMatrixVariableResultAttList :
	/*empty*/
	| otherMatrixVariableResultAttList otherMatrixVariableResultATT
	;

otherMatrixVariableResultATT :
	osglNumberOfMatrixVarATT
	| osglNumberOfEnumerationsATT
	| osglValueATT
	| osglSolverATT
	| osglNameATT
	| osglTypeATT
	| osglMatrixVarTypeATT
	| osglEnumTypeATT
	| osglDescriptionATT
	;

otherMatrixVariableResultContent :
	otherMatrixVariableResultEmpty
	| otherMatrixVariableResultLaden
	;

otherMatrixVariableResultEmpty :
	GREATERTHAN OTHEREND
	| ENDOFELEMENT
	;

otherMatrixVariableResultLaden :
	GREATERTHAN otherMatrixVariableResultBody OTHEREND
	;

otherMatrixVariableResultBody :
	otherMatrixVarEnumerationList
	| otherMatrixVarList
	;

otherMatrixVarList :
	osglMatrixWithMatrixVarIdx
	| otherMatrixVarList osglMatrixWithMatrixVarIdx
	;

otherMatrixVarEnumerationList :
	otherMatrixVarEnumeration
	| otherMatrixVarEnumerationList otherMatrixVarEnumeration
	;

otherMatrixVarEnumeration :
	otherMatrixVarEnumerationStart otherMatrixVarEnumerationAttributes otherMatrixVarEnumerationContent
	;

otherMatrixVarEnumerationStart :
	ENUMERATIONSTART
	;

otherMatrixVarEnumerationAttributes :
	otherMatrixVarEnumerationAttList
	;

otherMatrixVarEnumerationAttList :
	/*empty*/
	| otherMatrixVarEnumerationAttList otherMatrixVarEnumerationATT
	;

otherMatrixVarEnumerationATT :
	osglNumberOfElATT
	| osglValueATT
	| osglDescriptionATT
	;

otherMatrixVarEnumerationContent :
	otherMatrixVarEnumerationEmpty
	| otherMatrixVarEnumerationLaden
	;

otherMatrixVarEnumerationEmpty :
	ENDOFELEMENT
	;

otherMatrixVarEnumerationLaden :
	GREATERTHAN otherMatrixVarEnumerationBody ENUMERATIONEND
	;

otherMatrixVarEnumerationBody :
	osglIntArrayData
	;

otherMatrixProgrammingResults :
	/*empty*/
	| otherMatrixProgrammingResults otherMatrixProgrammingResult
	;

otherMatrixProgrammingResult :
	OTHERMATRIXPROGRAMMINGRESULTSTART
	;

otherSolutionResults :
	/*empty*/
	| otherSolutionResultsStart numberOfOtherSolutionResults otherSolutionResultsContent
	;

otherSolutionResultsStart :
	OTHERSOLUTIONRESULTSSTART
	;

numberOfOtherSolutionResults :
	numberOfOtherSolutionResultsAttribute
	;

otherSolutionResultsContent :
	otherSolutionResultsEmpty
	| otherSolutionResultsLaden
	;

otherSolutionResultsEmpty :
	GREATERTHAN OTHERSOLUTIONRESULTSEND
	| ENDOFELEMENT
	;

otherSolutionResultsLaden :
	GREATERTHAN otherSolutionResultsBody OTHERSOLUTIONRESULTSEND
	;

otherSolutionResultsBody :
	otherSolutionResultArray
	;

otherSolutionResultArray :
	otherSolutionResult
	| otherSolutionResultArray otherSolutionResult
	;

otherSolutionResult :
	otherSolutionResultStart otherSolutionResultAttributes otherSolutionResultContent
	;

otherSolutionResultStart :
	OTHERSOLUTIONRESULTSTART
	;

otherSolutionResultAttributes :
	otherSolutionResultAttList
	;

otherSolutionResultAttList :
	/*empty*/
	| otherSolutionResultAttList otherSolutionResultAtt
	;

otherSolutionResultAtt :
	osglNameATT
	| osglValueATT
	| osglCategoryATT
	| osglDescriptionATT
	| osglNumberOfItemsATT
	;

otherSolutionResultContent :
	otherSolutionResultEmpty
	| otherSolutionResultLaden
	;

otherSolutionResultEmpty :
	GREATERTHAN OTHERSOLUTIONRESULTEND
	| ENDOFELEMENT
	;

otherSolutionResultLaden :
	GREATERTHAN otherSolutionResultBody OTHERSOLUTIONRESULTEND
	;

otherSolutionResultBody :
	otherSolutionResultItemArray
	;

otherSolutionResultItemArray :
	otherSolutionResultItem
	| otherSolutionResultItemArray otherSolutionResultItem
	;

otherSolutionResultItem :
	otherSolutionResultItemContent
	;

otherSolutionResultItemContent :
	otherSolutionResultItemEmpty
	| otherSolutionResultItemLaden
	;

otherSolutionResultItemEmpty :
	ITEMSTARTANDEND
	| ITEMEMPTY
	;

otherSolutionResultItemLaden :
	ITEMSTART otherSolutionResultItemBody ITEMEND
	;

otherSolutionResultItemBody :
	ITEMTEXT
	;

otherSolverOutput :
	/*empty*/
	| otherSolverOutputStart numberOfSolverOutputsATT otherSolverOutputContent
	;

otherSolverOutputStart :
	OTHERSOLVEROUTPUTSTART
	;

numberOfSolverOutputsATT :
	numberOfSolverOutputsAttribute
	;

otherSolverOutputContent :
	otherSolverOutputEmpty
	| otherSolverOutputLaden
	;

otherSolverOutputEmpty :
	GREATERTHAN OTHERSOLVEROUTPUTEND
	| ENDOFELEMENT
	;

otherSolverOutputLaden :
	GREATERTHAN otherSolverOutputBody OTHERSOLVEROUTPUTEND
	;

otherSolverOutputBody :
	solverOutputArray
	;

solverOutputArray :
	solverOutput
	| solverOutputArray solverOutput
	;

solverOutput :
	solverOutputStart solverOutputAttributes solverOutputContent
	;

solverOutputStart :
	SOLVEROUTPUTSTART
	;

solverOutputAttributes :
	solverOutputAttList
	;

solverOutputAttList :
	/*empty*/
	| solverOutputAttList solverOutputAtt
	;

solverOutputAtt :
	osglNameATT
	| osglCategoryATT
	| osglDescriptionATT
	| osglNumberOfItemsATT
	;

solverOutputContent :
	solverOutputEmpty
	| solverOutputLaden
	;

solverOutputEmpty :
	GREATERTHAN SOLVEROUTPUTEND
	| ENDOFELEMENT
	;

solverOutputLaden :
	GREATERTHAN solverOutputBody SOLVEROUTPUTEND
	;

solverOutputBody :
	solverOutputItemArray
	;

solverOutputItemArray :
	solverOutputItem
	| solverOutputItemArray solverOutputItem
	;

solverOutputItem :
	solverOutputItemContent
	;

solverOutputItemContent :
	solverOutputItemEmpty
	| solverOutputItemLaden
	;

solverOutputItemEmpty :
	ITEMSTARTANDEND
	| ITEMEMPTY
	;

solverOutputItemLaden :
	ITEMSTART solverOutputItemBody ITEMEND
	;

solverOutputItemBody :
	ITEMTEXT
	;

numberOfOtherConstraintResultsAttribute :
	NUMBEROFOTHERCONSTRAINTRESULTSATT quote INTEGER quote
	;

numberOfOtherMatrixProgrammingResultsATT :
	NUMBEROFOTHERMATRIXPROGRAMMINGRESULTSATT quote INTEGER quote
	;

numberOfOtherMatrixVariableResultsATT :
	NUMBEROFOTHERMATRIXVARIABLERESULTSATT quote INTEGER quote
	;

numberOfOtherObjectiveResultsAttribute :
	NUMBEROFOTHEROBJECTIVERESULTSATT quote INTEGER quote
	;

numberOfOtherResultsAttribute :
	NUMBEROFOTHERRESULTSATT quote INTEGER quote
	;

numberOfOtherSolutionResultsAttribute :
	NUMBEROFOTHERSOLUTIONRESULTSATT quote INTEGER quote
	;

numberOfOtherVariableResultsAttribute :
	NUMBEROFOTHERVARIABLERESULTSATT quote INTEGER quote
	;

numberOfSolutionsAttribute :
	NUMBEROFSOLUTIONSATT quote INTEGER quote
	;

numberOfSolverOutputsAttribute :
	NUMBEROFSOLVEROUTPUTSATT quote INTEGER quote
	;

numberOfSubstatusesAttribute :
	NUMBEROFSUBSTATUSESATT quote INTEGER quote
	;

numberOfTimesAttribute :
	NUMBEROFTIMESATT quote INTEGER quote
	;

//numberOfVarAttribute :
//	NUMBEROFVARATT quote INTEGER quote
//	;

//numberOfVariablesAttribute :
//	NUMBEROFVARIABLESATT quote INTEGER quote
//	;

aNumber :
	INTEGER
	| DOUBLE
	;

ElementValue :
	ELEMENTTEXT
	| INTEGER
	| DOUBLE
	;

quote :
	xmlWhiteSpace QUOTE
	;

xmlWhiteSpace :
	/*empty*/
	| xmlWhiteSpace xmlWhiteSpaceChar
	;

xmlWhiteSpaceChar :
	' '
	| '\t'
	| '\r'
	| '\n'
	;

osglFileHeader :
	headerElementStart headerElementContent
	;

headerElementStart :
	HEADERSTART
	;

headerElementContent :
	headerElementEmpty
	| headerElementLaden
	;

headerElementEmpty :
	ENDOFELEMENT
	;

headerElementLaden :
	GREATERTHAN headerElementBody HEADEREND
	;

headerElementBody :
	headerElementList
	;

headerElementList :
	/*empty*/
	| headerElementList headerChild
	;

headerChild :
	fileName
	| fileSource
	| fileDescription
	| fileCreator
	| fileLicence
	;

fileName :
	fileNameContent
	;

fileNameContent :
	fileNameEmpty
	| fileNameLaden
	;

fileNameEmpty :
	FILENAMESTARTANDEND
	| FILENAMEEMPTY
	;

fileNameLaden :
	FILENAMESTART ITEMTEXT FILENAMEEND
	;

fileSource :
	fileSourceContent
	;

fileSourceContent :
	fileSourceEmpty
	| fileSourceLaden
	;

fileSourceEmpty :
	FILESOURCESTARTANDEND
	| FILESOURCEEMPTY
	;

fileSourceLaden :
	FILESOURCESTART ITEMTEXT FILESOURCEEND
	;

fileDescription :
	fileDescriptionContent
	;

fileDescriptionContent :
	fileDescriptionEmpty
	| fileDescriptionLaden
	;

fileDescriptionEmpty :
	FILEDESCRIPTIONSTARTANDEND
	| FILEDESCRIPTIONEMPTY
	;

fileDescriptionLaden :
	FILEDESCRIPTIONSTART ITEMTEXT FILEDESCRIPTIONEND
	;

fileCreator :
	fileCreatorContent
	;

fileCreatorContent :
	fileCreatorEmpty
	| fileCreatorLaden
	;

fileCreatorEmpty :
	FILECREATORSTARTANDEND
	| FILECREATOREMPTY
	;

fileCreatorLaden :
	FILECREATORSTART ITEMTEXT FILECREATOREND
	;

fileLicence :
	fileLicenceContent
	;

fileLicenceContent :
	fileLicenceEmpty
	| fileLicenceLaden
	;

fileLicenceEmpty :
	FILELICENCESTARTANDEND
	| FILELICENCEEMPTY
	;

fileLicenceLaden :
	FILELICENCESTART ITEMTEXT FILELICENCEEND
	;

osglNonNegativeIntArrayData :
	osglIntArrayData
	;

osglIntArrayData :
	osglIntVectorElArray
	| osglIntVectorBase64
	;

osglIntVectorElArray :
	/*empty*/
	| osglIntVectorElArray osglIntVectorEl
	;

osglIntVectorEl :
	osglIntVectorElStart osglIntVectorElAttributes osglIntVectorElContent
	;

osglIntVectorElStart :
	ELSTART
	;

osglIntVectorElAttributes :
	osglIntVectorElAttList
	;

osglIntVectorElAttList :
	/*empty*/
	| osglIntVectorElAttList osglIntVectorElAtt
	;

osglIntVectorElAtt :
	osglMultATT
	| osglIncrATT
	;

osglIntVectorElContent :
	GREATERTHAN INTEGER ELEND
	;

osglIntVectorBase64 :
	BASE64START osglBase64SizeATT osglIntVectorBase64Content
	;

osglIntVectorBase64Content :
	osglIntVectorBase64Empty
	| osglIntVectorBase64Laden
	;

osglIntVectorBase64Empty :
	GREATERTHAN BASE64END
	| ENDOFELEMENT
	;

osglIntVectorBase64Laden :
	GREATERTHAN ELEMENTTEXT BASE64END
	;

osglDblArrayData :
	osglDblVectorElArray
	| osglDblVectorBase64
	;

osglDblVectorElArray :
	/*empty*/
	| osglDblVectorElArray osglDblVectorEl
	;

osglDblVectorEl :
	osglDblVectorElStart osglDblVectorElAttributes osglDblVectorElContent
	;

osglDblVectorElStart :
	ELSTART
	;

osglDblVectorElAttributes :
	/*empty*/
	| osglMultATT
	;

osglDblVectorElContent :
	GREATERTHAN aNumber ELEND
	;

osglDblVectorBase64 :
	BASE64START osglBase64SizeATT osglDblVectorBase64Content
	;

osglDblVectorBase64Content :
	osglDblVectorBase64Empty
	| osglDblVectorBase64Laden
	;

osglDblVectorBase64Empty :
	GREATERTHAN BASE64END
	| ENDOFELEMENT
	;

osglDblVectorBase64Laden :
	GREATERTHAN ELEMENTTEXT BASE64END
	;

osglStrArrayData :
	osglStrVectorElArray
	;

osglStrVectorElArray :
	/*empty*/
	| osglStrVectorElArray osglStrVectorEl
	;

osglStrVectorEl :
	osglStrVectorElStart osglStrVectorElAttributes osglStrVectorElContent
	;

osglStrVectorElStart :
	ELSTART
	;

osglStrVectorElAttributes :
	/*empty*/
	| osglMultATT
	;

osglStrVectorElContent :
	GREATERTHAN ELEMENTTEXT ELEND
	;

//osglSparseVector :
//	osglSparseVectorNumberOfElATT GREATERTHAN osglSparseVectorIndexes osglSparseVectorValues
//	;

//osglSparseVectorNumberOfElATT :
//	osglNumberOfElATT
//	;

//osglSparseVectorIndexes :
//	INDEXESSTART GREATERTHAN osglIntVectorElArray INDEXESEND
//	;

//osglSparseVectorValues :
//	VALUESSTART GREATERTHAN osglDblVectorElArray VALUESEND
//	;

//osglSparseIntVector :
//	osglSparseIntVectorNumberOfElATT GREATERTHAN osglSparseIntVectorIndexes osglSparseIntVectorValues
//	;

//osglSparseIntVectorNumberOfElATT :
//	osglNumberOfElATT
//	;

//osglSparseIntVectorIndexes :
//	INDEXESSTART GREATERTHAN osglIntVectorElArray INDEXESEND
//	;

//osglSparseIntVectorValues :
//	VALUESSTART GREATERTHAN osglIntVectorElArray VALUESEND
//	;

//osglOtherOptionOrResultEnumerationList :
//	osglOtherOptionOrResultEnumeration
//	| osglOtherOptionOrResultEnumerationList osglOtherOptionOrResultEnumeration
//	;

//osglOtherOptionOrResultEnumeration :
//	osglOtherOptionOrResultEnumerationStart osglOtherOptionOrResultEnumerationAttributes osglOtherOptionOrResultEnumerationContent
//	;

//osglOtherOptionOrResultEnumerationStart :
//	ENUMERATIONSTART
//	;

//osglOtherOptionOrResultEnumerationAttributes :
//	osglOtherOptionOrResultEnumerationAttList
//	;

//osglOtherOptionOrResultEnumerationAttList :
//	/*empty*/
//	| osglOtherOptionOrResultEnumerationAttList osglOtherOptionOrResultEnumerationATT
//	;

//osglOtherOptionOrResultEnumerationATT :
//	osglNumberOfElATT
//	| osglValueATT
//	| osglDescriptionATT
//	;

//osglOtherOptionOrResultEnumerationContent :
//	osglOtherOptionOrResultEnumerationEmpty
//	| osglOtherOptionOrResultEnumerationLaden
//	;

//osglOtherOptionOrResultEnumerationEmpty :
//	ENDOFELEMENT
//	;

//osglOtherOptionOrResultEnumerationLaden :
//	GREATERTHAN osglOtherOptionOrResultEnumerationBody ENUMERATIONEND
//	;

//osglOtherOptionOrResultEnumerationBody :
//	osglIntArrayData
//	;

osglBasisStatusBasic :
	osglBasicStart osglBasisNumberOfElAttribute osglBasicContent
	;

osglBasicStart :
	BASICSTART
	;

osglBasicContent :
	osglBasicEmpty
	| osglBasicLaden
	;

osglBasicEmpty :
	ENDOFELEMENT
	;

osglBasicLaden :
	GREATERTHAN osglBasicBody BASICEND
	;

osglBasicBody :
	osglIntArrayData
	;

osglBasisStatusAtLower :
	osglAtLowerStart osglBasisNumberOfElAttribute osglAtLowerContent
	;

osglAtLowerStart :
	ATLOWERSTART
	;

osglAtLowerContent :
	osglAtLowerEmpty
	| osglAtLowerLaden
	;

osglAtLowerEmpty :
	ENDOFELEMENT
	;

osglAtLowerLaden :
	GREATERTHAN osglAtLowerBody ATLOWEREND
	;

osglAtLowerBody :
	osglIntArrayData
	;

osglBasisStatusAtUpper :
	osglAtUpperStart osglBasisNumberOfElAttribute osglAtUpperContent
	;

osglAtUpperStart :
	ATUPPERSTART
	;

osglAtUpperContent :
	osglAtUpperEmpty
	| osglAtUpperLaden
	;

osglAtUpperEmpty :
	ENDOFELEMENT
	;

osglAtUpperLaden :
	GREATERTHAN osglAtUpperBody ATUPPEREND
	;

osglAtUpperBody :
	osglIntArrayData
	;

osglBasisStatusAtEquality :
	osglAtEqualityStart osglBasisNumberOfElAttribute osglAtEqualityContent
	;

osglAtEqualityStart :
	ATEQUALITYSTART
	;

osglAtEqualityContent :
	osglAtEqualityEmpty
	| osglAtEqualityLaden
	;

osglAtEqualityEmpty :
	ENDOFELEMENT
	;

osglAtEqualityLaden :
	GREATERTHAN osglAtEqualityBody ATEQUALITYEND
	;

osglAtEqualityBody :
	osglIntArrayData
	;

osglBasisStatusIsFree :
	osglIsFreeStart osglBasisNumberOfElAttribute osglIsFreeContent
	;

osglIsFreeStart :
	ISFREESTART
	;

osglIsFreeContent :
	osglIsFreeEmpty
	| osglIsFreeLaden
	;

osglIsFreeEmpty :
	ENDOFELEMENT
	;

osglIsFreeLaden :
	GREATERTHAN osglIsFreeBody ISFREEEND
	;

osglIsFreeBody :
	osglIntArrayData
	;

osglBasisStatusSuperbasic :
	osglSuperbasicStart osglBasisNumberOfElAttribute osglSuperbasicContent
	;

osglSuperbasicStart :
	SUPERBASICSTART
	;

osglSuperbasicContent :
	osglSuperbasicEmpty
	| osglSuperbasicLaden
	;

osglSuperbasicEmpty :
	ENDOFELEMENT
	;

osglSuperbasicLaden :
	GREATERTHAN osglSuperbasicBody SUPERBASICEND
	;

osglSuperbasicBody :
	osglIntArrayData
	;

osglBasisStatusUnknown :
	osglUnknownStart osglBasisNumberOfElAttribute osglUnknownContent
	;

osglUnknownStart :
	UNKNOWNSTART
	;

osglUnknownContent :
	osglUnknownEmpty
	| osglUnknownLaden
	;

osglUnknownEmpty :
	ENDOFELEMENT
	;

osglUnknownLaden :
	GREATERTHAN osglUnknownBody UNKNOWNEND
	;

osglUnknownBody :
	osglIntArrayData
	;

osglBasisNumberOfElAttribute :
	osglNumberOfElATT
	;

//osglOtherMatrixVariableOptionOrResultAttributes :
//	osglOtherMatrixVariableOptionOrResultAttList
//	;

//osglOtherMatrixVariableOptionOrResultAttList :
//	osglOtherMatrixVariableOptionOrResultATT
//	| osglOtherMatrixVariableOptionOrResultAttList osglOtherMatrixVariableOptionOrResultATT
//	;

//osglOtherMatrixVariableOptionOrResultATT :
//	osglNameATT
//	| osglDescriptionATT
//	| osglValueATT
//	| osglTypeATT
//	| osglSolverATT
//	| osglCategoryATT
//	| osglNumberOfEnumerationsATT
//	| osglEnumTypeATT
//	| osglNumberOfMatrixVarATT
//	;

//osglOtherMatrixVariableOptionOrResultBody :
//	osglOtherMatrixVariableOptionOrResultMatrixVarArray
//	| osglOtherMatrixVariableOptionOrResultEnumerationArray
//	;

//osglOtherMatrixVariableOptionOrResultMatrixVarArray :
//	osglOtherMatrixVariableOptionOrResultMatrixVar
//	| osglOtherMatrixVariableOptionOrResultMatrixVarArray osglOtherMatrixVariableOptionOrResultMatrixVar
//	;

//osglOtherMatrixVariableOptionOrResultMatrixVar :
//	osglMatrixWithMatrixVarIdx
//	;

//osglOtherMatrixVariableOptionOrResultEnumerationArray :
//	osglOtherMatrixVariableOptionOrResultEnumeration
//	| osglOtherMatrixVariableOptionOrResultEnumerationArray osglOtherMatrixVariableOptionOrResultEnumeration
//	;

//osglOtherMatrixVariableOptionOrResultEnumeration :
//	osglOtherOptionOrResultEnumeration
//	;

//osglSolverOptionOrResultAttributes :
//	osglSolverOptionOrResultAttList
//	;

//osglSolverOptionOrResultAttList :
//	osglSolverOptionOrResultATT
//	| osglSolverOptionOrResultAttList osglSolverOptionOrResultATT
//	;

//osglSolverOptionOrResultATT :
//	osglNameATT
//	| osglDescriptionATT
//	| osglValueATT
//	| osglTypeATT
//	| osglSolverATT
//	| osglCategoryATT
//	| osglNumberOfMatricesATT
//	| osglNumberOfItemsATT
//	;

//osglSolverOptionOrResultBody :
//	osglSolverOptionOrResultMatrixArray
//	| osglSolverOptionOrResultItemArray
//	;

//osglSolverOptionOrResultMatrixArray :
//	osglSolverOptionOrResultMatrix
//	| osglSolverOptionOrResultMatrixArray osglSolverOptionOrResultMatrix
//	;

//osglSolverOptionOrResultMatrix :
//	osglMatrix
//	;

//osglSolverOptionOrResultItemArray :
//	osglSolverOptionOrResultItem
//	| osglSolverOptionOrResultItemArray osglSolverOptionOrResultItem
//	;

//osglSolverOptionOrResultItem :
//	osglSolverOptionOrResultItemContent
//	;

//osglSolverOptionOrResultItemContent :
//	osglSolverOptionOrResultItemEmpty
//	| osglSolverOptionOrResultItemLaden
//	;

//osglSolverOptionOrResultItemEmpty :
//	ITEMSTARTANDEND
//	| ITEMEMPTY
//	;

//osglSolverOptionOrResultItemLaden :
//	ITEMSTART osglSolverOptionOrResultItemBody ITEMEND
//	;

//osglSolverOptionOrResultItemBody :
//	ITEMTEXT
//	;

//osglMatrix :
//	matrixStart matrixAttributes matrixContent
//	;

osglMatrixWithMatrixVarIdx :
	matrixVarStart matrixWithMatrixVarIdxAttributes matrixVarContent
	;

//osglMatrixWithMatrixObjIdx :
//	matrixObjStart matrixWithMatrixObjIdxAttributes matrixObjContent
//	;

//osglMatrixWithMatrixConIdx :
//	matrixConStart matrixWithMatrixConIdxAttributes matrixConContent
//	;

//matrixStart :
//	MATRIXSTART
//	;

//matrixAttributes :
//	matrixAttributeList
//	;

//matrixAttributeList :
//	/*empty*/
//	| matrixAttributeList matrixAttribute
//	;

//matrixAttribute :
//	osglSymmetryATT
//	| osglNumberOfRowsATT
//	| osglNumberOfColumnsATT
//	| osglNameATT
//	| osglTypeATT
//	;

matrixVarStart :
	MATRIXVARSTART
	;

matrixWithMatrixVarIdxAttributes :
	matrixWithMatrixVarIdxATTList
	;

matrixWithMatrixVarIdxATTList :
	/*empty*/
	| matrixWithMatrixVarIdxATTList matrixWithMatrixVarIdxATT
	;

matrixWithMatrixVarIdxATT :
	osglSymmetryATT
	| osglNumberOfRowsATT
	| osglNumberOfColumnsATT
	| osglNameATT
	| osglTypeATT
	| osglMatrixVarIdxATT
	;

//matrixObjStart :
//	MATRIXOBJSTART
//	;

//matrixWithMatrixObjIdxAttributes :
//	matrixWithMatrixObjIdxATTList
//	;

//matrixWithMatrixObjIdxATTList :
//	/*empty*/
//	| matrixWithMatrixObjIdxATTList matrixWithMatrixObjIdxATT
//	;

//matrixWithMatrixObjIdxATT :
//	osglSymmetryATT
//	| osglNumberOfRowsATT
//	| osglNumberOfColumnsATT
//	| osglNameATT
//	| osglTypeATT
//	| osglMatrixObjIdxATT
//	;

//matrixConStart :
//	MATRIXCONSTART
//	;

//matrixWithMatrixConIdxAttributes :
//	matrixWithMatrixConIdxATTList
//	;

//matrixWithMatrixConIdxATTList :
//	/*empty*/
//	| matrixWithMatrixConIdxATTList matrixWithMatrixConIdxATT
//	;

//matrixWithMatrixConIdxATT :
//	osglSymmetryATT
//	| osglNumberOfRowsATT
//	| osglNumberOfColumnsATT
//	| osglNameATT
//	| osglTypeATT
//	| osglMatrixConIdxATT
//	;

//matrixContent :
//	matrixEmpty
//	| matrixLaden
//	;

//matrixEmpty :
//	ENDOFELEMENT
//	;

//matrixLaden :
//	GREATERTHAN matrixOrBlockBody MATRIXEND
//	;

matrixVarContent :
	matrixVarEmpty
	| matrixVarLaden
	;

matrixVarEmpty :
	ENDOFELEMENT
	;

matrixVarLaden :
	GREATERTHAN matrixOrBlockBody MATRIXVAREND
	;

//matrixObjContent :
//	matrixObjEmpty
//	| matrixObjLaden
//	;

//matrixObjEmpty :
//	ENDOFELEMENT
//	;

//matrixObjLaden :
//	GREATERTHAN matrixOrBlockBody MATRIXOBJEND
//	;

//matrixConContent :
//	matrixConEmpty
//	| matrixConLaden
//	;

//matrixConEmpty :
//	ENDOFELEMENT
//	;

//matrixConLaden :
//	GREATERTHAN matrixOrBlockBody MATRIXCONEND
//	;

matrixOrBlockBody :
	baseMatrix matrixConstructorList
	;

baseMatrix :
	/*empty*/
	| baseMatrixStart baseMatrixAttributes baseMatrixEnd
	;

baseMatrixStart :
	BASEMATRIXSTART
	;

baseMatrixAttributes :
	baseMatrixAttList
	;

baseMatrixAttList :
	/*empty*/
	| baseMatrixAttList baseMatrixAtt
	;

baseMatrixAtt :
	osglBaseMatrixIdxATT
	| osglTargetMatrixFirstRowATT
	| osglTargetMatrixFirstColATT
	| osglBaseMatrixStartRowATT
	| osglBaseMatrixStartColATT
	| osglBaseMatrixEndRowATT
	| osglBaseMatrixEndColATT
	| osglBaseTransposeATT
	| osglScalarMultiplierATT
	| osglScalarImaginaryPartATT
	;

baseMatrixEnd :
	GREATERTHAN BASEMATRIXEND
	| ENDOFELEMENT
	;

matrixConstructorList :
	/*empty*/
	| matrixConstructorList matrixConstructor
	;

matrixConstructor :
	constantElements
	| complexElements
	| stringValuedElements
	| varReferenceElements
	| objReferenceElements
	| conReferenceElements
	| linearElements
	| realValuedExpressions
	| complexValuedExpressions
	| matrixTransformation
	| matrixBlocks
	;

constantElements :
	constantElementsStart constantElementsAttributes GREATERTHAN constantElementsContent
	;

constantElementsStart :
	CONSTANTELEMENTSSTART
	;

constantElementsAttributes :
	constantElementsAttList
	;

constantElementsAttList :
	/*empty*/
	| constantElementsAttList constantElementsAtt
	;

constantElementsAtt :
	osglNumberOfValuesATT
	| osglRowMajorATT
	;

constantElementsContent :
	matrixElementsStartVector constantElementsNonzeros CONSTANTELEMENTSEND
	;

constantElementsNonzeros :
	/*empty*/
	| matrixElementsIndexVector constantElementsValues
	;

matrixElementsStartVector :
	matrixElementsStartVectorStart matrixElementsStartVectorContent
	;

matrixElementsStartVectorStart :
	STARTVECTORSTART
	;

matrixElementsStartVectorContent :
	matrixElementsStartVectorEmpty
	| matrixElementsStartVectorLaden
	;

matrixElementsStartVectorEmpty :
	ENDOFELEMENT
	;

matrixElementsStartVectorLaden :
	GREATERTHAN matrixElementsStartVectorBody STARTVECTOREND
	;

matrixElementsStartVectorBody :
	osglNonNegativeIntArrayData
	;

matrixElementsIndexVector :
	/*empty*/
	| matrixElementsIndexStart matrixElementsIndexContent
	;

matrixElementsIndexStart :
	INDEXSTART
	;

matrixElementsIndexContent :
	matrixElementsIndexEmpty
	| matrixElementsIndexLaden
	;

matrixElementsIndexEmpty :
	ENDOFELEMENT
	;

matrixElementsIndexLaden :
	GREATERTHAN matrixElementsIndexBody INDEXEND
	;

matrixElementsIndexBody :
	osglNonNegativeIntArrayData
	;

constantElementsValues :
	constantElementsValueStart constantElementsValueContent
	;

constantElementsValueStart :
	VALUESTART
	;

constantElementsValueContent :
	constantElementsValueEmpty
	| constantElementsValueLaden
	;

constantElementsValueEmpty :
	ENDOFELEMENT
	;

constantElementsValueLaden :
	GREATERTHAN constantElementsValueBody VALUEEND
	;

constantElementsValueBody :
	osglDblArrayData
	;

varReferenceElements :
	varReferenceElementsStart varReferenceElementsAttributes GREATERTHAN varReferenceElementsContent
	;

varReferenceElementsStart :
	VARREFERENCEELEMENTSSTART
	;

varReferenceElementsAttributes :
	varReferenceElementsAttList
	;

varReferenceElementsAttList :
	/*empty*/
	| varReferenceElementsAttList varReferenceElementsAtt
	;

varReferenceElementsAtt :
	osglNumberOfValuesATT
	| osglRowMajorATT
	;

varReferenceElementsContent :
	matrixElementsStartVector varReferenceElementsNonzeros VARREFERENCEELEMENTSEND
	;

varReferenceElementsNonzeros :
	matrixElementsIndexVector varReferenceElementsValues
	;

varReferenceElementsValues :
	/*empty*/
	| varReferenceElementsValuesStart varReferenceElementsValuesContent
	;

varReferenceElementsValuesStart :
	VALUESTART
	;

varReferenceElementsValuesContent :
	varReferenceElementsValuesEmpty
	| varReferenceElementsValuesLaden
	;

varReferenceElementsValuesEmpty :
	ENDOFELEMENT
	;

varReferenceElementsValuesLaden :
	GREATERTHAN varReferenceElementsValuesBody VALUEEND
	;

varReferenceElementsValuesBody :
	osglNonNegativeIntArrayData
	;

linearElements :
	linearElementsStart linearElementsAttributes GREATERTHAN linearElementsContent
	;

linearElementsStart :
	LINEARELEMENTSSTART
	;

linearElementsAttributes :
	linearElementsAttList
	;

linearElementsAttList :
	/*empty*/
	| linearElementsAttList linearElementsAtt
	;

linearElementsAtt :
	osglNumberOfValuesATT
	| osglRowMajorATT
	;

linearElementsContent :
	matrixElementsStartVector linearElementsNonzeros LINEARELEMENTSEND
	;

linearElementsNonzeros :
	matrixElementsIndexVector linearElementsValues
	;

linearElementsValues :
	/*empty*/
	| linearElementsValuesStart linearElementsValuesContent
	;

linearElementsValuesStart :
	VALUESTART
	;

linearElementsValuesContent :
	linearElementsValuesEmpty
	| linearElementsValuesLaden
	;

linearElementsValuesEmpty :
	ENDOFELEMENT
	;

linearElementsValuesLaden :
	GREATERTHAN linearElementsValuesBody VALUEEND
	;

linearElementsValuesBody :
	linearElementsValuesElList
	;

linearElementsValuesElList :
	/*empty*/
	| linearElementsValuesElList linearElementsValuesEl
	;

linearElementsValuesEl :
	linearElementsValuesElStart linearElementsValuesElAttributes linearElementsValuesElContent
	;

linearElementsValuesElStart :
	ELSTART
	;

linearElementsValuesElAttributes :
	linearElementsValuesElAttList
	;

linearElementsValuesElAttList :
	/*empty*/
	| linearElementsValuesElAttList linearElementsValuesElAtt
	;

linearElementsValuesElAtt :
	osglNumberOfVarIdxATT
	| osglConstantATT
	;

linearElementsValuesElContent :
	linearElementsValuesElEmpty
	| linearElementsValuesElLaden
	;

linearElementsValuesElEmpty :
	ENDOFELEMENT
	;

linearElementsValuesElLaden :
	GREATERTHAN linearElementsValuesVarIdxList ELEND
	;

linearElementsValuesVarIdxList :
	/*empty*/
	| linearElementsValuesVarIdxList linearElementsValuesVarIdx
	;

linearElementsValuesVarIdx :
	linearElementsValuesVarIdxStart linearElementsValuesVarIdxCoefATT linearElementsValuesVarIdxContent
	;

linearElementsValuesVarIdxStart :
	VARIDXSTART
	;

linearElementsValuesVarIdxCoefATT :
	/*empty*/
	| osglCoefATT
	;

linearElementsValuesVarIdxContent :
	GREATERTHAN INTEGER VARIDXEND
	;

realValuedExpressions :
	realValuedExpressionsStart realValuedExpressionsAttributes GREATERTHAN realValuedExpressionsContent
	;

realValuedExpressionsStart :
	REALVALUEDEXPRESSIONSSTART
	;

realValuedExpressionsAttributes :
	realValuedExpressionsAttList
	;

realValuedExpressionsAttList :
	/*empty*/
	| realValuedExpressionsAttList realValuedExpressionsAtt
	;

realValuedExpressionsAtt :
	osglNumberOfValuesATT
	| osglRowMajorATT
	;

realValuedExpressionsContent :
	matrixElementsStartVector realValuedExpressionsNonzeros REALVALUEDEXPRESSIONSSEND
	;

realValuedExpressionsNonzeros :
	matrixElementsIndexVector realValuedExpressionsValues
	;

realValuedExpressionsValues :
	/*empty*/
	| realValuedExpressionsValuesStart realValuedExpressionsValuesContent
	;

realValuedExpressionsValuesStart :
	VALUESTART
	;

realValuedExpressionsValuesContent :
	realValuedExpressionsValuesEmpty
	| realValuedExpressionsValuesLaden
	;

realValuedExpressionsValuesEmpty :
	ENDOFELEMENT
	;

realValuedExpressionsValuesLaden :
	GREATERTHAN realValuedExpressionsElList VALUEEND
	;

realValuedExpressionsElList :
	/*empty*/
	| realValuedExpressionsElList realValuedExpressionsEl
	;

realValuedExpressionsEl :
	realValuedExpressionsElStart realValuedExpressionsElContent
	;

realValuedExpressionsElStart :
	ELSTART
	;

realValuedExpressionsElContent :
	realValuedExpressionsElEmpty
	| realValuedExpressionsElLaden
	;

realValuedExpressionsElEmpty :
	ENDOFELEMENT
	;

realValuedExpressionsElLaden :
	GREATERTHAN nlnode ELEND
	;

complexValuedExpressions :
	complexValuedExpressionsStart complexValuedExpressionsAttributes GREATERTHAN complexValuedExpressionsContent
	;

complexValuedExpressionsStart :
	COMPLEXVALUEDEXPRESSIONSSTART
	;

complexValuedExpressionsAttributes :
	complexValuedExpressionsAttList
	;

complexValuedExpressionsAttList :
	/*empty*/
	| complexValuedExpressionsAttList complexValuedExpressionsAtt
	;

complexValuedExpressionsAtt :
	osglNumberOfValuesATT
	| osglRowMajorATT
	;

complexValuedExpressionsContent :
	matrixElementsStartVector complexValuedExpressionsNonzeros COMPLEXVALUEDEXPRESSIONSSEND
	;

complexValuedExpressionsNonzeros :
	matrixElementsIndexVector complexValuedExpressionsValues
	;

complexValuedExpressionsValues :
	/*empty*/
	| complexValuedExpressionsValuesStart complexValuedExpressionsValuesContent
	;

complexValuedExpressionsValuesStart :
	VALUESTART
	;

complexValuedExpressionsValuesContent :
	complexValuedExpressionsValuesEmpty
	| complexValuedExpressionsValuesLaden
	;

complexValuedExpressionsValuesEmpty :
	ENDOFELEMENT
	;

complexValuedExpressionsValuesLaden :
	GREATERTHAN complexValuedExpressionsElList VALUEEND
	;

complexValuedExpressionsElList :
	/*empty*/
	| complexValuedExpressionsElList complexValuedExpressionsEl
	;

complexValuedExpressionsEl :
	complexValuedExpressionsElStart complexValuedExpressionsElContent
	;

complexValuedExpressionsElStart :
	ELSTART
	;

complexValuedExpressionsElContent :
	complexValuedExpressionsElEmpty
	| complexValuedExpressionsElLaden
	;

complexValuedExpressionsElEmpty :
	ENDOFELEMENT
	;

complexValuedExpressionsElLaden :
	GREATERTHAN OSnLCNode ELEND
	;

objReferenceElements :
	objReferenceElementsStart objReferenceElementsAttributes GREATERTHAN objReferenceElementsContent
	;

objReferenceElementsStart :
	OBJREFERENCEELEMENTSSTART
	;

objReferenceElementsAttributes :
	objReferenceElementsAttList
	;

objReferenceElementsAttList :
	/*empty*/
	| objReferenceElementsAttList objReferenceElementsAtt
	;

objReferenceElementsAtt :
	osglNumberOfValuesATT
	| osglRowMajorATT
	;

objReferenceElementsContent :
	matrixElementsStartVector objReferenceElementsNonzeros OBJREFERENCEELEMENTSEND
	;

objReferenceElementsNonzeros :
	matrixElementsIndexVector objReferenceElementsValues
	;

objReferenceElementsValues :
	/*empty*/
	| objReferenceElementsValuesStart objReferenceElementsValuesContent
	;

objReferenceElementsValuesStart :
	VALUESTART
	;

objReferenceElementsValuesContent :
	objReferenceElementsValuesEmpty
	| objReferenceElementsValuesLaden
	;

objReferenceElementsValuesEmpty :
	ENDOFELEMENT
	;

objReferenceElementsValuesLaden :
	GREATERTHAN objReferenceElementsValuesBody VALUEEND
	;

objReferenceElementsValuesBody :
	osglIntArrayData
	;

conReferenceElements :
	conReferenceElementsStart conReferenceElementsAttributes GREATERTHAN conReferenceElementsContent
	;

conReferenceElementsStart :
	CONREFERENCEELEMENTSSTART
	;

conReferenceElementsAttributes :
	conReferenceElementsAttList
	;

conReferenceElementsAttList :
	/*empty*/
	| conReferenceElementsAttList conReferenceElementsAtt
	;

conReferenceElementsAtt :
	osglNumberOfValuesATT
	| osglRowMajorATT
	;

conReferenceElementsContent :
	matrixElementsStartVector conReferenceElementsNonzeros CONREFERENCEELEMENTSEND
	;

conReferenceElementsNonzeros :
	matrixElementsIndexVector conReferenceElementsValues
	;

conReferenceElementsValues :
	/*empty*/
	| conReferenceElementsValuesStart conReferenceElementsValuesContent
	;

conReferenceElementsValuesStart :
	VALUESTART
	;

conReferenceElementsValuesContent :
	conReferenceElementsValuesEmpty
	| conReferenceElementsValuesLaden
	;

conReferenceElementsValuesEmpty :
	ENDOFELEMENT
	;

conReferenceElementsValuesLaden :
	GREATERTHAN conReferenceElementsElList VALUEEND
	;

conReferenceElementsElList :
	/*empty*/
	| conReferenceElementsElList conReferenceElementsEl
	;

conReferenceElementsEl :
	conReferenceElementsElStart conReferenceElementsElAttributeList conReferenceElementsElContent
	;

conReferenceElementsElStart :
	ELSTART
	;

conReferenceElementsElAttributeList :
	/*empty*/
	| conReferenceElementsElAttributeList conReferenceElementsElAttribute
	;

conReferenceElementsElAttribute :
	osglValueTypeATT
	| osglMultATT
	| osglIncrATT
	;

conReferenceElementsElContent :
	GREATERTHAN INTEGER ELEND
	;

complexElements :
	complexElementsStart complexElementsAttributes GREATERTHAN complexElementsContent
	;

complexElementsStart :
	COMPLEXELEMENTSSTART
	;

complexElementsAttributes :
	complexElementsAttList
	;

complexElementsAttList :
	/*empty*/
	| complexElementsAttList complexElementsAtt
	;

complexElementsAtt :
	osglNumberOfValuesATT
	| osglRowMajorATT
	;

complexElementsContent :
	matrixElementsStartVector complexElementsNonzeros COMPLEXELEMENTSEND
	;

complexElementsNonzeros :
	matrixElementsIndexVector complexElementsValues
	;

complexElementsValues :
	/*empty*/
	| complexElementsValuesStart complexElementsValuesContent
	;

complexElementsValuesStart :
	VALUESTART
	;

complexElementsValuesContent :
	complexElementsValuesEmpty
	| complexElementsValuesLaden
	;

complexElementsValuesEmpty :
	ENDOFELEMENT
	;

complexElementsValuesLaden :
	GREATERTHAN complexElementsElList VALUEEND
	;

complexElementsElList :
	/*empty*/
	| complexElementsElList complexElementsEl
	;

complexElementsEl :
	complexElementsElStart complexElementsElAttributeList complexElementsElEnd
	;

complexElementsElStart :
	ELSTART
	;

complexElementsElAttributeList :
	/*empty*/
	| complexElementsElAttributeList complexElementsElAttribute
	;

complexElementsElAttribute :
	osglRealPartATT
	| osglImagPartATT
	| osglMultATT
	;

complexElementsElEnd :
	GREATERTHAN ELEND
	| ENDOFELEMENT
	;

stringValuedElements :
	stringValuedElementsStart stringValuedElementsAttributes GREATERTHAN stringValuedElementsContent
	;

stringValuedElementsStart :
	STRINGVALUEDELEMENTSSTART
	;

stringValuedElementsAttributes :
	stringValuedElementsAttList
	;

stringValuedElementsAttList :
	/*empty*/
	| stringValuedElementsAttList stringValuedElementsAtt
	;

stringValuedElementsAtt :
	osglNumberOfValuesATT
	| osglRowMajorATT
	;

stringValuedElementsContent :
	matrixElementsStartVector stringValuedElementsNonzeros STRINGVALUEDELEMENTSEND
	;

stringValuedElementsNonzeros :
	matrixElementsIndexVector stringValuedElementsValues
	;

stringValuedElementsValues :
	/*empty*/
	| stringValuedElementsValueStart stringValuedElementsValueContent
	;

stringValuedElementsValueStart :
	VALUESTART
	;

stringValuedElementsValueContent :
	stringValuedElementsValueEmpty
	| stringValuedElementsValueLaden
	;

stringValuedElementsValueEmpty :
	ENDOFELEMENT
	;

stringValuedElementsValueLaden :
	GREATERTHAN stringValuedElementsValueBody VALUEEND
	;

stringValuedElementsValueBody :
	osglStrArrayData
	;

matrixTransformation :
	matrixTransformationStart matrixTransformationShapeATT GREATERTHAN OSnLMNode matrixTransformationEnd
	;

matrixTransformationStart :
	TRANSFORMATIONSTART
	;

matrixTransformationShapeATT :
	/*empty*/
	| osglShapeATT
	;

matrixTransformationEnd :
	TRANSFORMATIONEND
	;

matrixBlocks :
	matrixBlocksStart matrixBlocksAttributes matrixBlocksContent
	;

matrixBlocksStart :
	BLOCKSSTART
	;

matrixBlocksAttributes :
	osglNumberOfBlocksATT
	;

matrixBlocksContent :
	GREATERTHAN colOffsets rowOffsets blockList matrixBlocksEnd
	;

matrixBlocksEnd :
	BLOCKSEND
	;

colOffsets :
	colOffsetStart colOffsetNumberOfElAttribute colOffsetContent
	;

colOffsetStart :
	COLOFFSETSTART
	;

colOffsetNumberOfElAttribute :
	osglNumberOfElATT
	;

colOffsetContent :
	colOffsetEmpty
	| colOffsetLaden
	;

colOffsetEmpty :
	ENDOFELEMENT
	;

colOffsetLaden :
	GREATERTHAN colOffsetBody COLOFFSETEND
	;

colOffsetBody :
	osglIntArrayData
	;

rowOffsets :
	rowOffsetStart rowOffsetNumberOfElAttribute rowOffsetContent
	;

rowOffsetStart :
	ROWOFFSETSTART
	;

rowOffsetNumberOfElAttribute :
	osglNumberOfElATT
	;

rowOffsetContent :
	rowOffsetEmpty
	| rowOffsetLaden
	;

rowOffsetEmpty :
	ENDOFELEMENT
	;

rowOffsetLaden :
	GREATERTHAN rowOffsetBody ROWOFFSETEND
	;

rowOffsetBody :
	osglIntArrayData
	;

blockList :
	/*empty*/
	| blockList matrixBlock
	;

matrixBlock :
	matrixBlockStart matrixBlockAttributes matrixBlockContent
	;

matrixBlockStart :
	BLOCKSTART
	;

matrixBlockAttributes :
	matrixBlockAttList
	;

matrixBlockAttList :
	/*empty*/
	| matrixBlockAttList matrixBlockAtt
	;

matrixBlockAtt :
	osglBlockRowIdxATT
	| osglBlockColIdxATT
	| osglSymmetryATT
	| osglTypeATT
	;

matrixBlockContent :
	blockEmpty
	| blockLaden
	;

blockEmpty :
	ENDOFELEMENT
	;

blockLaden :
	GREATERTHAN matrixOrBlockBody BLOCKEND
	;

osglNumberOfBlocksATT :
	NUMBEROFBLOCKSATT QUOTE INTEGER QUOTE
	;

osglNumberOfColumnsATT :
	NUMBEROFCOLUMNSATT QUOTE INTEGER QUOTE
	;

osglNumberOfConATT :
	NUMBEROFCONATT QUOTE INTEGER QUOTE
	;

//osglNumberOfConIdxATT :
//	NUMBEROFCONIDXATT QUOTE INTEGER QUOTE
//	;

osglNumberOfConstraintsATT :
	NUMBEROFCONSTRAINTSATT QUOTE INTEGER QUOTE
	;

osglNumberOfElATT :
	NUMBEROFELATT QUOTE INTEGER QUOTE
	;

osglNumberOfEnumerationsATT :
	NUMBEROFENUMERATIONSATT QUOTE INTEGER QUOTE
	;

osglNumberOfItemsATT :
	NUMBEROFITEMSATT QUOTE INTEGER QUOTE
	;

//osglNumberOfMatricesATT :
//	NUMBEROFMATRICESATT QUOTE INTEGER QUOTE
//	;

//osglNumberOfMatrixConATT :
//	NUMBEROFMATRIXCONATT QUOTE INTEGER QUOTE
//	;

//osglNumberOfMatrixObjATT :
//	NUMBEROFMATRIXOBJATT QUOTE INTEGER QUOTE
//	;

osglNumberOfMatrixVarATT :
	NUMBEROFMATRIXVARATT QUOTE INTEGER QUOTE
	;

osglNumberOfObjATT :
	NUMBEROFOBJATT QUOTE INTEGER QUOTE
	;

//osglNumberOfObjIdxATT :
//	NUMBEROFOBJIDXATT QUOTE INTEGER QUOTE
//	;

osglNumberOfObjectivesATT :
	NUMBEROFOBJECTIVESATT QUOTE INTEGER QUOTE
	;

osglNumberOfRowsATT :
	NUMBEROFROWSATT QUOTE INTEGER QUOTE
	;

osglNumberOfValuesATT :
	NUMBEROFVALUESATT QUOTE INTEGER QUOTE
	;

osglNumberOfVarATT :
	NUMBEROFVARATT QUOTE INTEGER QUOTE
	;

osglNumberOfVarIdxATT :
	NUMBEROFVARIDXATT QUOTE INTEGER QUOTE
	;

osglNumberOfVariablesATT :
	NUMBEROFVARIABLESATT QUOTE INTEGER QUOTE
	;

osglBase64SizeATT :
	SIZEOFATT QUOTE INTEGER QUOTE
	;

osglBaseMatrixIdxATT :
	BASEMATRIXIDXATT QUOTE INTEGER QUOTE
	;

osglBaseMatrixStartRowATT :
	BASEMATRIXSTARTROWATT QUOTE INTEGER QUOTE
	;

osglBaseMatrixStartColATT :
	BASEMATRIXSTARTCOLATT QUOTE INTEGER QUOTE
	;

osglBaseMatrixEndRowATT :
	BASEMATRIXENDROWATT QUOTE INTEGER QUOTE
	;

osglBaseMatrixEndColATT :
	BASEMATRIXENDCOLATT QUOTE INTEGER QUOTE
	;

osglBlockRowIdxATT :
	BLOCKROWIDXATT QUOTE INTEGER QUOTE
	;

osglBlockColIdxATT :
	BLOCKCOLIDXATT QUOTE INTEGER QUOTE
	;

osglIdxATT :
	IDXATT QUOTE INTEGER QUOTE
	;

osglIncrATT :
	INCRATT QUOTE INTEGER QUOTE
	;

//osglMatrixConIdxATT :
//	MATRIXCONIDXATT quote INTEGER quote
//	;

//osglMatrixObjIdxATT :
//	MATRIXOBJIDXATT quote INTEGER quote
//	;

osglMatrixVarIdxATT :
	MATRIXVARIDXATT quote INTEGER quote
	;

osglMultATT :
	MULTATT QUOTE INTEGER QUOTE
	;

osglTargetMatrixFirstRowATT :
	TARGETMATRIXFIRSTROWATT QUOTE INTEGER QUOTE
	;

osglTargetMatrixFirstColATT :
	TARGETMATRIXFIRSTCOLATT QUOTE INTEGER QUOTE
	;

osglCoefATT :
	COEFATT QUOTE aNumber QUOTE
	;

osglConstantATT :
	CONSTANTATT QUOTE aNumber QUOTE
	;

osglImagPartATT :
	IMATT QUOTE aNumber QUOTE
	;

osglRealPartATT :
	REATT QUOTE aNumber QUOTE
	;

osglScalarMultiplierATT :
	SCALARMULTIPLIERATT QUOTE aNumber QUOTE
	;

osglScalarImaginaryPartATT :
	SCALARIMAGINARYPARTATT QUOTE aNumber QUOTE
	;

osglBaseTransposeATT :
	baseTransposeAttEmpty
	| baseTransposeAttContent
	;

baseTransposeAttEmpty :
	EMPTYBASETRANSPOSEATT
	;

baseTransposeAttContent :
	BASETRANSPOSEATT ATTRIBUTETEXT quote
	;

osglCategoryATT :
	categoryAttEmpty
	| categoryAttContent
	;

categoryAttEmpty :
	EMPTYCATEGORYATT
	;

categoryAttContent :
	CATEGORYATT ATTRIBUTETEXT QUOTE
	;

osglConTypeATT :
	conTypeAttEmpty
	| conTypeAttContent
	;

conTypeAttEmpty :
	EMPTYCONTYPEATT
	;

conTypeAttContent :
	CONTYPEATT ATTRIBUTETEXT QUOTE
	;

osglDescriptionATT :
	descriptionAttEmpty
	| descriptionAttContent
	;

descriptionAttEmpty :
	EMPTYDESCRIPTIONATT
	;

descriptionAttContent :
	DESCRIPTIONATT ATTRIBUTETEXT QUOTE
	;

osglEnumTypeATT :
	enumTypeAttEmpty
	| enumTypeAttContent
	;

enumTypeAttEmpty :
	EMPTYENUMTYPEATT
	;

enumTypeAttContent :
	ENUMTYPEATT ATTRIBUTETEXT QUOTE
	;

//osglMatrixConTypeATT :
//	matrixConTypeAttEmpty
//	| matrixConTypeAttContent
//	;

//matrixConTypeAttEmpty :
//	EMPTYMATRIXCONTYPEATT
//	;

//matrixConTypeAttContent :
//	MATRIXCONTYPEATT ATTRIBUTETEXT QUOTE
//	;

//osglMatrixObjTypeATT :
//	matrixObjTypeAttEmpty
//	| matrixObjTypeAttContent
//	;

//matrixObjTypeAttEmpty :
//	EMPTYMATRIXOBJTYPEATT
//	;

//matrixObjTypeAttContent :
//	MATRIXOBJTYPEATT ATTRIBUTETEXT QUOTE
//	;

//osglMatrixTypeATT :
//	matrixTypeAttEmpty
//	| matrixTypeAttContent
//	;

//matrixTypeAttEmpty :
//	EMPTYMATRIXTYPEATT
//	;

//matrixTypeAttContent :
//	MATRIXTYPEATT ATTRIBUTETEXT QUOTE
//	;

osglMatrixVarTypeATT :
	matrixVarTypeAttEmpty
	| matrixVarTypeAttContent
	;

matrixVarTypeAttEmpty :
	EMPTYMATRIXVARTYPEATT
	;

matrixVarTypeAttContent :
	MATRIXVARTYPEATT ATTRIBUTETEXT QUOTE
	;

osglNameATT :
	nameAttEmpty
	| nameAttContent
	;

nameAttEmpty :
	EMPTYNAMEATT
	;

nameAttContent :
	NAMEATT ATTRIBUTETEXT QUOTE
	;

osglObjTypeATT :
	objTypeAttEmpty
	| objTypeAttContent
	;

objTypeAttEmpty :
	EMPTYOBJTYPEATT
	;

objTypeAttContent :
	OBJTYPEATT ATTRIBUTETEXT QUOTE
	;

osglRowMajorATT :
	rowMajorAttEmpty
	| rowMajorAttContent
	;

rowMajorAttEmpty :
	EMPTYROWMAJORATT
	;

rowMajorAttContent :
	ROWMAJORATT ATTRIBUTETEXT QUOTE
	;

osglShapeATT :
	shapeAttEmpty
	| shape
	;

shapeAttEmpty :
	EMPTYSHAPEATT
	;

shape :
	SHAPEATT ATTRIBUTETEXT QUOTE
	;

osglSolverATT :
	solverAttEmpty
	| solverAttContent
	;

solverAttEmpty :
	EMPTYSOLVERATT
	;

solverAttContent :
	SOLVERATT ATTRIBUTETEXT QUOTE
	;

osglSymmetryATT :
	symmetryAttEmpty
	| symmetryAttContent
	;

symmetryAttEmpty :
	EMPTYSYMMETRYATT
	;

symmetryAttContent :
	SYMMETRYATT ATTRIBUTETEXT QUOTE
	;

osglTypeATT :
	typeAttEmpty
	| typeAttContent
	;

typeAttEmpty :
	EMPTYTYPEATT
	;

typeAttContent :
	TYPEATT ATTRIBUTETEXT QUOTE
	;

osglUnitATT :
	unitAttEmpty
	| unitAttContent
	;

unitAttEmpty :
	EMPTYUNITATT
	;

unitAttContent :
	UNITATT ATTRIBUTETEXT QUOTE
	;

osglValueATT :
	valueAttEmpty
	| valueAttContent
	;

//osglValuestringATT :
//	valueAttEmpty
//	| valueAttContent
//	;

valueAttEmpty :
	EMPTYVALUEATT
	;

valueAttContent :
	VALUEATT ATTRIBUTETEXT QUOTE
	;

osglValueTypeATT :
	valueTypeAttEmpty
	| valueTypeAttContent
	;

valueTypeAttEmpty :
	EMPTYVALUETYPEATT
	;

valueTypeAttContent :
	VALUETYPEATT ATTRIBUTETEXT QUOTE
	;

osglVarTypeATT :
	varTypeAttEmpty
	| varTypeAttContent
	;

varTypeAttEmpty :
	EMPTYVARTYPEATT
	;

varTypeAttContent :
	VARTYPEATT ATTRIBUTETEXT QUOTE
	;

//nonlinearExpressions :
//	/*empty*/
//	| nonlinearExpressionsStart nlnumberatt nlnodes NONLINEAREXPRESSIONSEND
//	;

//nonlinearExpressionsStart :
//	NONLINEAREXPRESSIONSSTART
//	;

//nlnumberatt :
//	NUMBEROFNONLINEAREXPRESSIONS QUOTE INTEGER QUOTE GREATERTHAN
//	;

//nlnodes :
//	/*empty*/
//	| nlnodes realValuedExpressionTree
//	;

//realValuedExpressionTree :
//	nlstart nlAttributes GREATERTHAN nlnode NLEND
//	;

//nlstart :
//	NLSTART
//	;

//nlAttributes :
//	nlAttributeList
//	;

//nlAttributeList :
//	/*empty*/
//	| nlAttributeList nlAttribute
//	;

//nlAttribute :
//	osglIdxATT
//	| osglShapeATT
//	;

nlnode :
	number
	| variable
	| times
	| plus
	| sum
	| minus
	| negate
	| divide
	| power
	| product
	| ln
	| sqrt
	| square
	| sin
	| cos
	| exp
	| if
	| abs
	| erf
	| max
	| min
	| E
	| PI
	| allDiff
	| matrixDeterminant
	| matrixTrace
	| matrixToScalar
	;

E :
	ESTART eend
	;

eend :
	ENDOFELEMENT
	| GREATERTHAN EEND
	;

PI :
	PISTART piend
	;

piend :
	ENDOFELEMENT
	| GREATERTHAN PIEND
	;

times :
	TIMESSTART nlnode nlnode TIMESEND
	;

plus :
	PLUSSTART nlnode nlnode PLUSEND
	;

minus :
	MINUSSTART nlnode nlnode MINUSEND
	;

negate :
	NEGATESTART nlnode NEGATEEND
	;

divide :
	DIVIDESTART nlnode nlnode DIVIDEEND
	;

power :
	POWERSTART nlnode nlnode POWEREND
	;

ln :
	LNSTART nlnode LNEND
	;

sqrt :
	SQRTSTART nlnode SQRTEND
	;

square :
	SQUARESTART nlnode SQUAREEND
	;

cos :
	COSSTART nlnode COSEND
	;

sin :
	SINSTART nlnode SINEND
	;

exp :
	EXPSTART nlnode EXPEND
	;

abs :
	absStart nlnode absEnd
	;

absStart :
	ABSSTART
	;

absEnd :
	ABSEND
	;

erf :
	ERFSTART nlnode ERFEND
	;

if :
	IFSTART nlnode nlnode nlnode IFEND
	;

matrixDeterminant :
	MATRIXDETERMINANTSTART OSnLMNode MATRIXDETERMINANTEND
	;

matrixTrace :
	MATRIXTRACESTART OSnLMNode MATRIXTRACEEND
	;

matrixToScalar :
	MATRIXTOSCALARSTART OSnLMNode MATRIXTOSCALAREND
	;

number :
	numberStart numberAttributeList numberEnd
	;

numberStart :
	NUMBERSTART
	;

numberEnd :
	ENDOFELEMENT
	| GREATERTHAN NUMBEREND
	;

numberAttributeList :
	/*empty*/
	| numberAttributeList numberAttribute
	;

numberAttribute :
	osglTypeATT
	| osglValueATT
	| numberidATT
	;

numberidATT :
	IDATT ATTRIBUTETEXT QUOTE
	;

//numbervalueATT :
//	VALUEATT QUOTE aNumber QUOTE
//	;

variable :
	VARIABLESTART anotherVariableATT variableend
	;

variableend :
	ENDOFELEMENT
	| GREATERTHAN VARIABLEEND
	| GREATERTHAN nlnode VARIABLEEND
	;

anotherVariableATT :
	/*empty*/
	| anotherVariableATT variableATT
	;

variableATT :
	variablecoefATT
	| variableidxATT
	;

variablecoefATT :
	COEFATT QUOTE aNumber QUOTE
	;

variableidxATT :
	IDXATT QUOTE INTEGER QUOTE
	;

sum :
	SUMSTART anothersumnlnode SUMEND
	;

anothersumnlnode :
	/*empty*/
	| anothersumnlnode nlnode
	;

allDiff :
	ALLDIFFSTART anotherallDiffnlnode ALLDIFFEND
	;

anotherallDiffnlnode :
	/*empty*/
	| anotherallDiffnlnode nlnode
	;

max :
	MAXSTART anothermaxnlnode MAXEND
	;

anothermaxnlnode :
	/*empty*/
	| anothermaxnlnode nlnode
	;

min :
	MINSTART anotherminnlnode MINEND
	;

anotherminnlnode :
	/*empty*/
	| anotherminnlnode nlnode
	;

product :
	PRODUCTSTART anotherproductnlnode PRODUCTEND
	;

anotherproductnlnode :
	/*empty*/
	| anotherproductnlnode nlnode
	;

OSnLMNode :
	matrixReference
	| matrixVarReference
	| matrixObjReference
	| matrixConReference
	| matrixDiagonal
	| matrixDotTimes
	| matrixInverse
	| matrixLowerTriangle
	| matrixUpperTriangle
	| matrixMerge
	| matrixMinus
	| matrixNegate
	| matrixPlus
	| matrixSum
	| matrixTimes
	| matrixProduct
	| matrixScalarTimes
	| matrixSubMatrixAt
	| matrixTranspose
	| identityMatrix
	;

matrixReference :
	matrixReferenceStart matrixRefAttributeList matrixReferenceEnd
	;

matrixReferenceStart :
	MATRIXREFERENCESTART
	;

matrixRefAttributeList :
	/*empty*/
	| matrixRefAttributeList matrixRefAttribute
	;

matrixRefAttribute :
	matrixIdxATT
	| matrixTransposeATT
	;

matrixReferenceEnd :
	ENDOFELEMENT
	| GREATERTHAN MATRIXREFERENCEEND
	;

matrixIdxATT :
	IDXATT QUOTE INTEGER QUOTE
	;

matrixTransposeATT :
	TRANSPOSEATT ATTRIBUTETEXT QUOTE
	;

matrixVarReference :
	matrixVarReferenceStart matrixVarIdxATT matrixVarReferenceEnd
	;

matrixVarReferenceStart :
	MATRIXVARSTART
	;

matrixVarReferenceEnd :
	ENDOFELEMENT
	| GREATERTHAN MATRIXVAREND
	;

matrixVarIdxATT :
	IDXATT QUOTE INTEGER QUOTE
	;

matrixObjReference :
	matrixObjReferenceStart matrixObjIdxATT matrixObjReferenceEnd
	;

matrixObjReferenceStart :
	MATRIXOBJSTART
	;

matrixObjReferenceEnd :
	ENDOFELEMENT
	| GREATERTHAN MATRIXOBJEND
	;

matrixObjIdxATT :
	IDXATT QUOTE INTEGER QUOTE
	;

matrixConReference :
	matrixConReferenceStart matrixConIdxATT matrixConReferenceEnd
	;

matrixConReferenceStart :
	MATRIXCONSTART
	;

matrixConReferenceEnd :
	ENDOFELEMENT
	| GREATERTHAN MATRIXCONEND
	;

matrixConIdxATT :
	IDXATT QUOTE INTEGER QUOTE
	;

matrixDiagonal :
	matrixDiagonalStart matrixDiagonalContent
	;

matrixDiagonalStart :
	MATRIXDIAGONALSTART
	;

matrixDiagonalContent :
	OSnLMNode MATRIXDIAGONALEND
	;

matrixDotTimes :
	matrixDotTimesStart matrixDotTimesContent
	;

matrixDotTimesStart :
	MATRIXDOTTIMESSTART
	;

matrixDotTimesContent :
	OSnLMNode OSnLMNode MATRIXDOTTIMESEND
	;

identityMatrix :
	identityMatrixStart identityMatrixContent
	;

identityMatrixStart :
	IDENTITYMATRIXSTART
	;

identityMatrixContent :
	nlnode IDENTITYMATRIXEND
	;

matrixInverse :
	matrixInverseStart matrixInverseContent
	;

matrixInverseStart :
	MATRIXINVERSESTART
	;

matrixInverseContent :
	OSnLMNode MATRIXINVERSEEND
	;

matrixLowerTriangle :
	matrixLowerTriangleStart matrixLowerTriangleAttribute GREATERTHAN matrixLowerTriangleContent
	;

matrixLowerTriangleStart :
	MATRIXLOWERTRIANGLESTART
	;

matrixLowerTriangleAttribute :
	/*empty*/
	| includeDiagonalATT
	;

matrixLowerTriangleContent :
	OSnLMNode MATRIXLOWERTRIANGLEEND
	;

matrixUpperTriangle :
	matrixUpperTriangleStart matrixUpperTriangleAttribute GREATERTHAN matrixUpperTriangleContent
	;

matrixUpperTriangleStart :
	MATRIXUPPERTRIANGLESTART
	;

matrixUpperTriangleAttribute :
	/*empty*/
	| includeDiagonalATT
	;

matrixUpperTriangleContent :
	OSnLMNode MATRIXUPPERTRIANGLEEND
	;

includeDiagonalATT :
	INCLUDEDIAGONALATT ATTRIBUTETEXT QUOTE
	;

matrixMerge :
	matrixMergeStart matrixMergeEnd
	;

matrixMergeStart :
	MATRIXMERGESTART
	;

matrixMergeEnd :
	ENDOFELEMENT
	| GREATERTHAN MATRIXMERGEEND
	;

matrixMinus :
	matrixMinusStart matrixMinusContent
	;

matrixMinusStart :
	MATRIXMINUSSTART
	;

matrixMinusContent :
	OSnLMNode OSnLMNode MATRIXMINUSEND
	;

matrixNegate :
	matrixNegateStart matrixNegateContent
	;

matrixNegateStart :
	MATRIXNEGATESTART
	;

matrixNegateContent :
	OSnLMNode MATRIXNEGATEEND
	;

matrixPlus :
	matrixPlusStart matrixPlusContent
	;

matrixPlusStart :
	MATRIXPLUSSTART
	;

matrixPlusContent :
	OSnLMNode OSnLMNode MATRIXPLUSEND
	;

matrixSum :
	MATRIXSUMSTART anothermatrixsumnode MATRIXSUMEND
	;

anothermatrixsumnode :
	/*empty*/
	| anothermatrixsumnode OSnLMNode
	;

matrixTimes :
	matrixTimesStart matrixTimesContent
	;

matrixTimesStart :
	MATRIXTIMESSTART
	;

matrixTimesContent :
	OSnLMNode OSnLMNode MATRIXTIMESEND
	;

matrixProduct :
	MATRIXPRODUCTSTART anothermatrixproductnode MATRIXPRODUCTEND
	;

anothermatrixproductnode :
	/*empty*/
	| anothermatrixproductnode OSnLMNode
	;

matrixScalarTimes :
	matrixScalarTimesStart matrixScalarTimesContent
	;

matrixScalarTimesStart :
	MATRIXSCALARTIMESSTART
	;

matrixScalarTimesContent :
	OSnLMNode scalarNode MATRIXSCALARTIMESEND
	;

matrixSubMatrixAt :
	matrixSubMatrixAtStart matrixSubMatrixAtContent
	;

matrixSubMatrixAtStart :
	MATRIXSUBMATRIXATSTART
	;

matrixSubMatrixAtContent :
	nlnode nlnode nlnode nlnode OSnLMNode MATRIXSUBMATRIXATEND
	;

matrixTranspose :
	matrixTransposeStart matrixTransposeContent
	;

matrixTransposeStart :
	MATRIXTRANSPOSESTART
	;

matrixTransposeContent :
	OSnLMNode MATRIXTRANSPOSEEND
	;

//matrixExpressions :
//	/*empty*/
//	| matrixExpressionsStart matrixExpressionsAtt matrixExpressionsContent
//	;

//matrixExpressionsStart :
//	MATRIXEXPRESSIONSSTART
//	;

//matrixExpressionsAtt :
//	numberOfExprATT
//	;

//numberOfExprATT :
//	NUMBEROFEXPR QUOTE INTEGER QUOTE
//	;

//matrixExpressionsContent :
//	matrixExpressionsEmpty
//	| matrixExpressionsLaden
//	;

//matrixExpressionsEmpty :
//	ENDOFELEMENT
//	;

//matrixExpressionsLaden :
//	GREATERTHAN matrixExprList MATRIXEXPRESSIONSEND
//	;

//matrixExprList :
//	/*empty*/
//	| matrixExprList matrixExpr
//	;

//matrixExpr :
//	matrixExprStart matrixExprAttributes GREATERTHAN OSnLMNode EXPREND
//	;

//matrixExprStart :
//	EXPRSTART
//	;

//matrixExprAttributes :
//	matrixExprAttributeList
//	;

//matrixExprAttributeList :
//	/*empty*/
//	| matrixExprAttributeList exprAttribute
//	;

//exprAttribute :
//	osglIdxATT
//	| osglShapeATT
//	;

scalarNode :
	nlnode
	| OSnLCNode
	;

OSnLCNode :
	complexNumber
	| createComplex
	| complexPlus
	| complexSum
	| complexMinus
	| complexNegate
	| complexConjugate
	| complexTimes
	| complexSquare
	;

complexNumber :
	complexNumberStart complexNumberAttributes complexNumberEnd
	;

complexNumberStart :
	COMPLEXNUMBERSTART
	;

complexNumberEnd :
	ENDOFELEMENT
	| GREATERTHAN COMPLEXNUMBEREND
	;

complexNumberAttributes :
	complexNumberAttList
	;

complexNumberAttList :
	/*empty*/
	| complexNumberAttList complexNumberAtt
	;

complexNumberAtt :
	osglRealPartATT
	| osglImagPartATT
	;

createComplex :
	createComplexStart GREATERTHAN createComplexContent
	;

createComplexStart :
	CREATECOMPLEXSTART
	;

createComplexContent :
	nlnode nlnode CREATECOMPLEXEND
	;

complexPlus :
	complexPlusStart GREATERTHAN complexPlusContent
	;

complexPlusStart :
	COMPLEXPLUSSTART
	;

complexPlusContent :
	scalarNode scalarNode COMPLEXPLUSEND
	;

complexSum :
	COMPLEXSUMSTART GREATERTHAN anothercsumnode COMPLEXSUMEND
	;

anothercsumnode :
	/*empty*/
	| anothercsumnode scalarNode
	;

complexMinus :
	complexMinusStart GREATERTHAN complexMinusContent
	;

complexMinusStart :
	COMPLEXMINUSSTART
	;

complexMinusContent :
	scalarNode scalarNode COMPLEXMINUSEND
	;

complexNegate :
	complexNegateStart GREATERTHAN complexNegateContent
	;

complexNegateStart :
	COMPLEXNEGATESTART
	;

complexNegateContent :
	scalarNode COMPLEXNEGATEEND
	;

complexConjugate :
	complexConjugateStart GREATERTHAN complexConjugateContent
	;

complexConjugateStart :
	COMPLEXCONJUGATESTART
	;

complexConjugateContent :
	scalarNode COMPLEXCONJUGATEEND
	;

complexTimes :
	complexTimesStart GREATERTHAN complexTimesContent
	;

complexTimesStart :
	COMPLEXTIMESSTART
	;

complexTimesContent :
	scalarNode scalarNode COMPLEXTIMESEND
	;

complexSquare :
	complexSquareStart GREATERTHAN complexSquareContent
	;

complexSquareStart :
	COMPLEXSQUARESTART
	;

complexSquareContent :
	scalarNode COMPLEXSQUAREEND
	;

%%

%x osrlattributetext
%x doublequoteattributetext
%x singlequoteattributetext
//%x startelement
//%x elementtext
%x itemtext
%x comment
%x xmldeclaration

xmlwhitespace ([ \t\n\r])
equality ([ \t\n\r])*=([ \t\n\r])*
quote [\"|\']
twoquotes (\"\"|\'\')
greater_than (>)
aninteger ([ \t\n\r]*-?[0-9]+[ \t\n\r]*)
/* Distinguishing signed and unsigned integers requires careful ordering of patterns
    anxmluint ([ \t\n\r]*[0-9]+[ \t\n\r]*)
    anxmlint ([ \t\n\r]*-?[0-9]+[ \t\n\r]*)
*/
adouble ([ \t\n\r]*(-?(([0-9]+|[0-9]*\.[0-9]*)([eE][-+]?[0-9]+)?|INF)|NaN)[ \t\n\r]*)
aboolean (true|false|1|0)

%%

" "	' '
"\n"	'\n'
"\r"	'\r'
"\t"	'\t'

//{xmlwhitespace}+	skip()

 /* General patterns matched in more than one element */

{quote} QUOTE
//{twoquotes} TWOQUOTES
({xmlwhitespace}*{greater_than}) GREATERTHAN
{aninteger} INTEGER
 /* {anxmlint} UNSIGNEDINT */

{adouble} DOUBLE

//{aboolean} BOOLEAN

({xmlwhitespace}*\/>) ENDOFELEMENT

 /* Patterns for attributes returning strings (that are potentially empty)*/

//({xmlwhitespace}+targetObjectiveName{equality}{twoquotes}) EMPTYTARGETOBJECTIVENAMEATT
({xmlwhitespace}+targetObjectiveName{equality}\")<doublequoteattributetext> TARGETOBJECTIVENAMEATT
({xmlwhitespace}+targetObjectiveName{equality}\')<singlequoteattributetext> TARGETOBJECTIVENAMEATT

//({xmlwhitespace}+weightedObjectives{equality}{twoquotes}) EMPTYWEIGHTEDOBJECTIVESATT
({xmlwhitespace}+weightedObjectives{equality}\")<doublequoteattributetext> WEIGHTEDOBJECTIVESATT
({xmlwhitespace}+weightedObjectives{equality}\')<singlequoteattributetext> WEIGHTEDOBJECTIVESATT

 /* Patterns for attributes returning numeric values*/

({xmlwhitespace}+numberOfOtherConstraintResults{equality}) NUMBEROFOTHERCONSTRAINTRESULTSATT
({xmlwhitespace}+numberOfOtherMatrixProgrammingResults{equality}) NUMBEROFOTHERMATRIXPROGRAMMINGRESULTSATT
//({xmlwhitespace}+numberOfOtherMatrixConstraintResults{equality}) NUMBEROFOTHERMATRIXCONSTRAINTRESULTSATT
//({xmlwhitespace}+numberOfOtherMatrixObjectiveResults{equality}) NUMBEROFOTHERMATRIXOBJECTIVERESULTSATT
({xmlwhitespace}+numberOfOtherMatrixVariableResults{equality}) NUMBEROFOTHERMATRIXVARIABLERESULTSATT
({xmlwhitespace}+numberOfOtherObjectiveResults{equality}) NUMBEROFOTHEROBJECTIVERESULTSATT
({xmlwhitespace}+numberOfOtherResults{equality}) NUMBEROFOTHERRESULTSATT
({xmlwhitespace}+numberOfOtherSolutionResults{equality}) NUMBEROFOTHERSOLUTIONRESULTSATT
({xmlwhitespace}+numberOfOtherVariableResults{equality}) NUMBEROFOTHERVARIABLERESULTSATT
({xmlwhitespace}+numberOfSolutions{equality}) NUMBEROFSOLUTIONSATT
({xmlwhitespace}+numberOfSolverOutputs{equality}) NUMBEROFSOLVEROUTPUTSATT
({xmlwhitespace}+numberOfSubstatuses{equality}) NUMBEROFSUBSTATUSESATT
({xmlwhitespace}+numberOfTimes{equality}) NUMBEROFTIMESATT

({xmlwhitespace}+targetObjectiveIdx{equality}) TARGETOBJECTIVEIDXATT

 /* Generic patterns matched in more than one element */

{xmlwhitespace}*\<status STATUSSTART
{xmlwhitespace}*\<\/status{xmlwhitespace}*\>{xmlwhitespace}* STATUSEND
{xmlwhitespace}*\<substatus SUBSTATUSSTART
{xmlwhitespace}*\<\/substatus{xmlwhitespace}*\>{xmlwhitespace}* SUBSTATUSEND

 /* Patterns for top level elements */

{xmlwhitespace}*\<osrl{xmlwhitespace}*\> OSRLSTARTEMPTY
{xmlwhitespace}*\<osrl{xmlwhitespace}+<osrlattributetext> OSRLSTART
{xmlwhitespace}*\<\/osrl{xmlwhitespace}*\>{xmlwhitespace}* OSRLEND
{xmlwhitespace}*\<resultHeader HEADERSTART
{xmlwhitespace}*\<\/resultHeader{xmlwhitespace}*\>{xmlwhitespace}* HEADEREND
{xmlwhitespace}*\<message MESSAGESTART
{xmlwhitespace}*\<\/message{xmlwhitespace}*\>{xmlwhitespace}* MESSAGEEND

 /* Patterns for the <general> element */

{xmlwhitespace}*\<generalStatus GENERALSTATUSSTART
{xmlwhitespace}*\<\/generalStatus{xmlwhitespace}*\>{xmlwhitespace}* GENERALSTATUSEND
{xmlwhitespace}*\<solverInvoked SOLVERINVOKEDSTART
{xmlwhitespace}*\<\/solverInvoked{xmlwhitespace}*\>{xmlwhitespace}* SOLVERINVOKEDEND
{xmlwhitespace}*\<timeStamp TIMESTAMPSTART
{xmlwhitespace}*\<\/timeStamp{xmlwhitespace}*\>{xmlwhitespace}* TIMESTAMPEND

 /* Patterns for the <system> element */

{xmlwhitespace}*\<systemInformation SYSTEMINFORMATIONSTART
{xmlwhitespace}*\<\/systemInformation{xmlwhitespace}*\>{xmlwhitespace}* SYSTEMINFORMATIONEND
{xmlwhitespace}*\<availableDiskSpace AVAILABLEDISKSPACESTART
{xmlwhitespace}*\<\/availableDiskSpace{xmlwhitespace}*\>{xmlwhitespace}* AVAILABLEDISKSPACEEND
{xmlwhitespace}*\<availableMemory AVAILABLEMEMORYSTART
{xmlwhitespace}*\<\/availableMemory{xmlwhitespace}*\>{xmlwhitespace}* AVAILABLEMEMORYEND
{xmlwhitespace}*\<availableCPUSpeed AVAILABLECPUSPEEDSTART
{xmlwhitespace}*\<\/availableCPUSpeed{xmlwhitespace}*\>{xmlwhitespace}* AVAILABLECPUSPEEDEND
{xmlwhitespace}*\<availableCPUNumber AVAILABLECPUNUMBERSTART
{xmlwhitespace}*\<\/availableCPUNumber{xmlwhitespace}*\>{xmlwhitespace}* AVAILABLECPUNUMBEREND

 /* Patterns for the <service> element */

{xmlwhitespace}*\<currentState CURRENTSTATESTART
{xmlwhitespace}*\<\/currentState{xmlwhitespace}*\>{xmlwhitespace}* CURRENTSTATEEND
{xmlwhitespace}*\<currentJobCount CURRENTJOBCOUNTSTART
{xmlwhitespace}*\<\/currentJobCount{xmlwhitespace}*\>{xmlwhitespace}* CURRENTJOBCOUNTEND
{xmlwhitespace}*\<totalJobsSoFar TOTALJOBSSOFARSTART
{xmlwhitespace}*\<\/totalJobsSoFar{xmlwhitespace}*\>{xmlwhitespace}* TOTALJOBSSOFAREND
{xmlwhitespace}*\<timeServiceStarted TIMESERVICESTARTEDSTART
{xmlwhitespace}*\<\/timeServiceStarted{xmlwhitespace}*\>{xmlwhitespace}* TIMESERVICESTARTEDEND
{xmlwhitespace}*\<serviceUtilization SERVICEUTILIZATIONSTART
{xmlwhitespace}*\<\/serviceUtilization{xmlwhitespace}*\>{xmlwhitespace}* SERVICEUTILIZATIONEND

 /* Patterns for the <job> element */

{xmlwhitespace}*\<submitTime SUBMITTIMESTART
{xmlwhitespace}*\<\/submitTime{xmlwhitespace}*\>{xmlwhitespace}* SUBMITTIMEEND
{xmlwhitespace}*\<scheduledStartTime SCHEDULEDSTARTTIMESTART
{xmlwhitespace}*\<\/scheduledStartTime{xmlwhitespace}*\>{xmlwhitespace}* SCHEDULEDSTARTTIMEEND
{xmlwhitespace}*\<actualStartTime ACTUALSTARTTIMESTART
{xmlwhitespace}*\<\/actualStartTime{xmlwhitespace}*\>{xmlwhitespace}* ACTUALSTARTTIMEEND
{xmlwhitespace}*\<endTime ENDTIMESTART
{xmlwhitespace}*\<\/endTime{xmlwhitespace}*\>{xmlwhitespace}* ENDTIMEEND
{xmlwhitespace}*\<time TIMESTART
{xmlwhitespace}*\<\/time{xmlwhitespace}*\>{xmlwhitespace}* TIMEEND
{xmlwhitespace}*\<timingInformation TIMINGINFORMATIONSTART
{xmlwhitespace}*\<\/timingInformation{xmlwhitespace}*\>{xmlwhitespace}* TIMINGINFORMATIONEND
{xmlwhitespace}*\<usedDiskSpace USEDDISKSPACESTART
{xmlwhitespace}*\<\/usedDiskSpace{xmlwhitespace}*\>{xmlwhitespace}* USEDDISKSPACEEND
{xmlwhitespace}*\<usedMemory USEDMEMORYSTART
{xmlwhitespace}*\<\/usedMemory{xmlwhitespace}*\>{xmlwhitespace}* USEDMEMORYEND
{xmlwhitespace}*\<usedCPUSpeed USEDCPUSPEEDSTART
{xmlwhitespace}*\<\/usedCPUSpeed{xmlwhitespace}*\>{xmlwhitespace}* USEDCPUSPEEDEND
{xmlwhitespace}*\<usedCPUNumber USEDCPUNUMBERSTART
{xmlwhitespace}*\<\/usedCPUNumber{xmlwhitespace}*\>{xmlwhitespace}* USEDCPUNUMBEREND

 /* General patterns for the <optimization> element */

{xmlwhitespace}*\<solution SOLUTIONSTART
{xmlwhitespace}*\<\/solution{xmlwhitespace}*\>{xmlwhitespace}* SOLUTIONEND
{xmlwhitespace}*\<values VALUESSTART
{xmlwhitespace}*\<\/values{xmlwhitespace}*\>{xmlwhitespace}* VALUESEND
{xmlwhitespace}*\<basisStatus BASISSTATUSSTART
{xmlwhitespace}*\<\/basisStatus{xmlwhitespace}*\>{xmlwhitespace}* BASISSTATUSEND
//{xmlwhitespace}*\<idx IDXSTART
//{xmlwhitespace}*\<\/idx{xmlwhitespace}*\>{xmlwhitespace}* IDXEND

 /* Patterns for the <variables> element */

{xmlwhitespace}*\<valuesString VALUESSTRINGSTART
{xmlwhitespace}*\<\/valuesString{xmlwhitespace}*\>{xmlwhitespace}* VALUESSTRINGEND

 /* Patterns for the <constraints> element */
{xmlwhitespace}*\<dualValues DUALVALUESSTART
{xmlwhitespace}*\<\/dualValues{xmlwhitespace}*\>{xmlwhitespace}* DUALVALUESEND

 /* Patterns for <matrixProgramming> */

//{xmlwhitespace}*\<otherMatrixVariableResult OTHERMATRIXVARIABLERESULTSTART
//{xmlwhitespace}*\<\/otherMatrixVariableResult{xmlwhitespace}*\>{xmlwhitespace}* OTHERMATRIXVARIABLERESULTEND
{xmlwhitespace}*\<otherMatrixProgrammingResult OTHERMATRIXPROGRAMMINGRESULTSTART
//{xmlwhitespace}*\<\/otherMatrixProgrammingResult{xmlwhitespace}*\>{xmlwhitespace}* OTHERMATRIXPROGRAMMINGRESULTEND

 /* Other patterns */

{xmlwhitespace}*\<otherResults OTHERRESULTSSTART
{xmlwhitespace}*\<\/otherResults{xmlwhitespace}*\>{xmlwhitespace}* OTHERRESULTSEND
{xmlwhitespace}*\<otherSolutionResult OTHERSOLUTIONRESULTSTART
{xmlwhitespace}*\<\/otherSolutionResult{xmlwhitespace}*\>{xmlwhitespace}* OTHERSOLUTIONRESULTEND
{xmlwhitespace}*\<otherSolutionResults OTHERSOLUTIONRESULTSSTART
{xmlwhitespace}*\<\/otherSolutionResults{xmlwhitespace}*\>{xmlwhitespace}* OTHERSOLUTIONRESULTSEND
{xmlwhitespace}*\<otherSolverOutput OTHERSOLVEROUTPUTSTART
{xmlwhitespace}*\<\/otherSolverOutput{xmlwhitespace}*\>{xmlwhitespace}* OTHERSOLVEROUTPUTEND
{xmlwhitespace}*\<solverOutput SOLVEROUTPUTSTART
{xmlwhitespace}*\<\/solverOutput{xmlwhitespace}*\>{xmlwhitespace}* SOLVEROUTPUTEND

 /* include file OSParseosgl.l.patterns --- patterns for OSgL schema elements */

{xmlwhitespace}*\<base64BinaryData BASE64START
{xmlwhitespace}*\<\/base64BinaryData{xmlwhitespace}*\>{xmlwhitespace}* BASE64END
{xmlwhitespace}*\<el ELSTART
{xmlwhitespace}*\<\/el{xmlwhitespace}*\>{xmlwhitespace}* ELEND

 /* The <item> element and the children of the file header element are treated specially
    because they may legitimately contain special characters */

{xmlwhitespace}*\<item{xmlwhitespace}*\>{xmlwhitespace}*\<\/item{xmlwhitespace}*\>{xmlwhitespace}* ITEMEMPTY
{xmlwhitespace}*\<item{xmlwhitespace}*\>{xmlwhitespace}*<itemtext> ITEMSTART
{xmlwhitespace}*\<\/item{xmlwhitespace}*>{xmlwhitespace}* ITEMEND
{xmlwhitespace}*\<item{xmlwhitespace}*\/>{xmlwhitespace}* ITEMSTARTANDEND

{xmlwhitespace}*\<name{xmlwhitespace}*\>{xmlwhitespace}*\<\/name{xmlwhitespace}*\>{xmlwhitespace}* FILENAMEEMPTY
{xmlwhitespace}*\<name{xmlwhitespace}*\>{xmlwhitespace}*<itemtext> FILENAMESTART
{xmlwhitespace}*\<\/name{xmlwhitespace}*>{xmlwhitespace}* FILENAMEEND
{xmlwhitespace}*\<name{xmlwhitespace}*\/>{xmlwhitespace}* FILENAMESTARTANDEND

{xmlwhitespace}*\<source{xmlwhitespace}*\>{xmlwhitespace}*\<\/source{xmlwhitespace}*\>{xmlwhitespace}* FILESOURCEEMPTY
{xmlwhitespace}*\<source{xmlwhitespace}*\>{xmlwhitespace}*<itemtext> FILESOURCESTART
{xmlwhitespace}*\<\/source{xmlwhitespace}*>{xmlwhitespace}* FILESOURCEEND
{xmlwhitespace}*\<source{xmlwhitespace}*\/>{xmlwhitespace}* FILESOURCESTARTANDEND

{xmlwhitespace}*\<description{xmlwhitespace}*\>{xmlwhitespace}*\<\/description{xmlwhitespace}*\>{xmlwhitespace}* FILEDESCRIPTIONEMPTY
{xmlwhitespace}*\<description{xmlwhitespace}*\>{xmlwhitespace}*<itemtext> FILEDESCRIPTIONSTART
{xmlwhitespace}*\<\/description{xmlwhitespace}*>{xmlwhitespace}* FILEDESCRIPTIONEND
{xmlwhitespace}*\<description{xmlwhitespace}*\/>{xmlwhitespace}* FILEDESCRIPTIONSTARTANDEND

{xmlwhitespace}*\<fileCreator{xmlwhitespace}*\>{xmlwhitespace}*\<\/fileCreator{xmlwhitespace}*\>{xmlwhitespace}* FILECREATOREMPTY
{xmlwhitespace}*\<fileCreator{xmlwhitespace}*\>{xmlwhitespace}*<itemtext> FILECREATORSTART
{xmlwhitespace}*\<\/fileCreator{xmlwhitespace}*>{xmlwhitespace}* FILECREATOREND
{xmlwhitespace}*\<fileCreator{xmlwhitespace}*\/>{xmlwhitespace}* FILECREATORSTARTANDEND

{xmlwhitespace}*\<licence{xmlwhitespace}*\>{xmlwhitespace}*\<\/licence{xmlwhitespace}*\>{xmlwhitespace}* FILELICENCEEMPTY
{xmlwhitespace}*\<licence{xmlwhitespace}*\>{xmlwhitespace}*<itemtext> FILELICENCESTART
{xmlwhitespace}*\<\/licence{xmlwhitespace}*>{xmlwhitespace}* FILELICENCEEND
{xmlwhitespace}*\<licence{xmlwhitespace}*\/>{xmlwhitespace}* FILELICENCESTARTANDEND

 /* Patterns for attributes returning strings (that are potentially empty)*/

({xmlwhitespace}+baseTranspose{equality}\"\") EMPTYBASETRANSPOSEATT
({xmlwhitespace}+baseTranspose{equality}\'\') EMPTYBASETRANSPOSEATT
({xmlwhitespace}+baseTranspose{equality}\")<doublequoteattributetext> BASETRANSPOSEATT
({xmlwhitespace}+baseTranspose{equality}\')<singlequoteattributetext> BASETRANSPOSEATT

({xmlwhitespace}+category{equality}\"\") EMPTYCATEGORYATT
({xmlwhitespace}+category{equality}\'\') EMPTYCATEGORYATT
({xmlwhitespace}+category{equality}\")<doublequoteattributetext> CATEGORYATT
({xmlwhitespace}+category{equality}\')<singlequoteattributetext> CATEGORYATT

({xmlwhitespace}+conType{equality}\"\") EMPTYCONTYPEATT
({xmlwhitespace}+conType{equality}\'\') EMPTYCONTYPEATT
({xmlwhitespace}+conType{equality}\")<doublequoteattributetext> CONTYPEATT
({xmlwhitespace}+conType{equality}\')<singlequoteattributetext> CONTYPEATT

({xmlwhitespace}+description{equality}\"\") EMPTYDESCRIPTIONATT
({xmlwhitespace}+description{equality}\'\') EMPTYDESCRIPTIONATT
({xmlwhitespace}+description{equality}\")<doublequoteattributetext> DESCRIPTIONATT
({xmlwhitespace}+description{equality}\')<singlequoteattributetext> DESCRIPTIONATT

({xmlwhitespace}+enumType{equality}\"\") EMPTYENUMTYPEATT
({xmlwhitespace}+enumType{equality}\'\') EMPTYENUMTYPEATT
({xmlwhitespace}+enumType{equality}\")<doublequoteattributetext> ENUMTYPEATT
({xmlwhitespace}+enumType{equality}\')<singlequoteattributetext> ENUMTYPEATT

//({xmlwhitespace}+matrixConType{equality}\"\") EMPTYMATRIXCONTYPEATT
//({xmlwhitespace}+matrixConType{equality}\'\') EMPTYMATRIXCONTYPEATT
//({xmlwhitespace}+matrixConType{equality}\")<doublequoteattributetext> MATRIXCONTYPEATT
//({xmlwhitespace}+matrixConType{equality}\')<singlequoteattributetext> MATRIXCONTYPEATT

//({xmlwhitespace}+matrixObjType{equality}\"\") EMPTYMATRIXOBJTYPEATT
//({xmlwhitespace}+matrixObjType{equality}\'\') EMPTYMATRIXOBJTYPEATT
//({xmlwhitespace}+matrixObjType{equality}\")<doublequoteattributetext> MATRIXOBJTYPEATT
//({xmlwhitespace}+matrixObjType{equality}\')<singlequoteattributetext> MATRIXOBJTYPEATT

//({xmlwhitespace}+matrixType{equality}\"\") EMPTYMATRIXTYPEATT
//({xmlwhitespace}+matrixType{equality}\'\') EMPTYMATRIXTYPEATT
//({xmlwhitespace}+matrixType{equality}\")<doublequoteattributetext> MATRIXTYPEATT
//({xmlwhitespace}+matrixType{equality}\')<singlequoteattributetext> MATRIXTYPEATT

({xmlwhitespace}+matrixVarType{equality}\"\") EMPTYMATRIXVARTYPEATT
({xmlwhitespace}+matrixVarType{equality}\'\') EMPTYMATRIXVARTYPEATT
({xmlwhitespace}+matrixVarType{equality}\")<doublequoteattributetext> MATRIXVARTYPEATT
({xmlwhitespace}+matrixVarType{equality}\')<singlequoteattributetext> MATRIXVARTYPEATT

({xmlwhitespace}+name{equality}\"\") EMPTYNAMEATT
({xmlwhitespace}+name{equality}\'\') EMPTYNAMEATT
({xmlwhitespace}+name{equality}\")<doublequoteattributetext> NAMEATT
({xmlwhitespace}+name{equality}\')<singlequoteattributetext> NAMEATT

({xmlwhitespace}+objType{equality}\"\") EMPTYOBJTYPEATT
({xmlwhitespace}+objType{equality}\'\') EMPTYOBJTYPEATT
({xmlwhitespace}+objType{equality}\")<doublequoteattributetext> OBJTYPEATT
({xmlwhitespace}+objType{equality}\')<singlequoteattributetext> OBJTYPEATT

({xmlwhitespace}+rowMajor{equality}\"\") EMPTYROWMAJORATT
({xmlwhitespace}+rowMajor{equality}\'\') EMPTYROWMAJORATT
({xmlwhitespace}+rowMajor{equality}\")<doublequoteattributetext> ROWMAJORATT
({xmlwhitespace}+rowMajor{equality}\')<singlequoteattributetext> ROWMAJORATT

({xmlwhitespace}+shape{equality}\"\") EMPTYSHAPEATT
({xmlwhitespace}+shape{equality}\'\') EMPTYSHAPEATT
({xmlwhitespace}+shape{equality}\")<doublequoteattributetext> SHAPEATT
({xmlwhitespace}+shape{equality}\')<singlequoteattributetext> SHAPEATT

({xmlwhitespace}+solver{equality}\"\") EMPTYSOLVERATT
({xmlwhitespace}+solver{equality}\'\') EMPTYSOLVERATT
({xmlwhitespace}+solver{equality}\")<doublequoteattributetext> SOLVERATT
({xmlwhitespace}+solver{equality}\')<singlequoteattributetext> SOLVERATT

({xmlwhitespace}+symmetry{equality}\"\") EMPTYSYMMETRYATT
({xmlwhitespace}+symmetry{equality}\'\') EMPTYSYMMETRYATT
({xmlwhitespace}+symmetry{equality}\")<doublequoteattributetext> SYMMETRYATT
({xmlwhitespace}+symmetry{equality}\')<singlequoteattributetext> SYMMETRYATT

({xmlwhitespace}+type{equality}\"\") EMPTYTYPEATT
({xmlwhitespace}+type{equality}\'\') EMPTYTYPEATT
({xmlwhitespace}+type{equality}\")<doublequoteattributetext> TYPEATT
({xmlwhitespace}+type{equality}\')<singlequoteattributetext> TYPEATT

({xmlwhitespace}+unit{equality}\"\") EMPTYUNITATT
({xmlwhitespace}+unit{equality}\'\') EMPTYUNITATT
({xmlwhitespace}+unit{equality}\")<doublequoteattributetext> UNITATT
({xmlwhitespace}+unit{equality}\')<singlequoteattributetext> UNITATT

({xmlwhitespace}+value{equality}\"\") EMPTYVALUEATT
({xmlwhitespace}+value{equality}\'\') EMPTYVALUEATT
({xmlwhitespace}+value{equality}\")<doublequoteattributetext> VALUEATT
({xmlwhitespace}+value{equality}\')<singlequoteattributetext> VALUEATT

({xmlwhitespace}+varType{equality}\"\") EMPTYVARTYPEATT
({xmlwhitespace}+varType{equality}\'\') EMPTYVARTYPEATT
({xmlwhitespace}+varType{equality}\")<doublequoteattributetext> VARTYPEATT
({xmlwhitespace}+varType{equality}\')<singlequoteattributetext> VARTYPEATT

({xmlwhitespace}+valueType{equality}\"\") EMPTYVALUETYPEATT
({xmlwhitespace}+valueType{equality}\'\') EMPTYVALUETYPEATT
({xmlwhitespace}+valueType{equality}\")<doublequoteattributetext> VALUETYPEATT
({xmlwhitespace}+valueType{equality}\')<singlequoteattributetext> VALUETYPEATT

 /* Patterns for attributes returning numeric values*/

({xmlwhitespace}+numberOfBlocks{equality}) NUMBEROFBLOCKSATT
({xmlwhitespace}+numberOfColumns{equality}) NUMBEROFCOLUMNSATT
({xmlwhitespace}+numberOfCon{equality}) NUMBEROFCONATT
({xmlwhitespace}+numberOfConstraints{equality}) NUMBEROFCONSTRAINTSATT
({xmlwhitespace}+numberOfEl{equality}) NUMBEROFELATT
({xmlwhitespace}+numberOfEnumerations{equality}) NUMBEROFENUMERATIONSATT
({xmlwhitespace}+numberOfItems{equality}) NUMBEROFITEMSATT
//({xmlwhitespace}+numberOfMatrices{equality}) NUMBEROFMATRICESATT
//({xmlwhitespace}+numberOfMatrixCon{equality}) NUMBEROFMATRIXCONATT
//({xmlwhitespace}+numberOfMatrixObj{equality}) NUMBEROFMATRIXOBJATT
({xmlwhitespace}+numberOfMatrixVar{equality}) NUMBEROFMATRIXVARATT
({xmlwhitespace}+numberOfObj{equality}) NUMBEROFOBJATT
({xmlwhitespace}+numberOfObjectives{equality}) NUMBEROFOBJECTIVESATT
({xmlwhitespace}+numberOfRows{equality}) NUMBEROFROWSATT
({xmlwhitespace}+numberOfValues{equality}) NUMBEROFVALUESATT
({xmlwhitespace}+numberOfVar{equality}) NUMBEROFVARATT
({xmlwhitespace}+numberOfVariables{equality}) NUMBEROFVARIABLESATT
({xmlwhitespace}+numberOfVarIdx{equality}) NUMBEROFVARIDXATT

({xmlwhitespace}+baseMatrixIdx{equality}) BASEMATRIXIDXATT
({xmlwhitespace}+targetMatrixFirstRow{equality}) TARGETMATRIXFIRSTROWATT
({xmlwhitespace}+targetMatrixFirstCol{equality}) TARGETMATRIXFIRSTCOLATT
({xmlwhitespace}+baseMatrixStartRow{equality}) BASEMATRIXSTARTROWATT
({xmlwhitespace}+baseMatrixStartCol{equality}) BASEMATRIXSTARTCOLATT
({xmlwhitespace}+baseMatrixEndRow{equality}) BASEMATRIXENDROWATT
({xmlwhitespace}+baseMatrixEndCol{equality}) BASEMATRIXENDCOLATT
({xmlwhitespace}+scalarMultiplier{equality}) SCALARMULTIPLIERATT
({xmlwhitespace}+scalarImaginaryPart{equality}) SCALARIMAGINARYPARTATT
({xmlwhitespace}+blockRowIdx{equality}) BLOCKROWIDXATT
({xmlwhitespace}+blockColIdx{equality}) BLOCKCOLIDXATT
({xmlwhitespace}+constant{equality}) CONSTANTATT
({xmlwhitespace}+Re{equality}) REATT
({xmlwhitespace}+Im{equality}) IMATT

({xmlwhitespace}+matrixVarIdx{equality}) MATRIXVARIDXATT
//({xmlwhitespace}+matrixObjIdx{equality}) MATRIXOBJIDXATT
//({xmlwhitespace}+matrixConIdx{equality}) MATRIXCONIDXATT

({xmlwhitespace}+idx{equality})  IDXATT
({xmlwhitespace}+incr{equality}) INCRATT
({xmlwhitespace}+mult{equality}) MULTATT
({xmlwhitespace}+coef{equality}) COEFATT
({xmlwhitespace}+sizeOf{equality}) SIZEOFATT

 /* Patterns for the <matrices> element */

//{xmlwhitespace}*\<matrices MATRICESSTART
//{xmlwhitespace}*\<\/matrices{xmlwhitespace}*\>{xmlwhitespace}* MATRICESEND
//{xmlwhitespace}*\<matrix MATRIXSTART
//{xmlwhitespace}*\<\/matrix{xmlwhitespace}*\>{xmlwhitespace}* MATRIXEND
{xmlwhitespace}*\<baseMatrix BASEMATRIXSTART
{xmlwhitespace}*\<\/baseMatrix{xmlwhitespace}*\>{xmlwhitespace}* BASEMATRIXEND
{xmlwhitespace}*\<blocks BLOCKSSTART
{xmlwhitespace}*\<\/blocks{xmlwhitespace}*\>{xmlwhitespace}* BLOCKSEND
{xmlwhitespace}*\<block BLOCKSTART
{xmlwhitespace}*\<\/block{xmlwhitespace}*\>{xmlwhitespace}* BLOCKEND
//{xmlwhitespace}*\<elements ELEMENTSSTART
//{xmlwhitespace}*\<\/elements{xmlwhitespace}*\>{xmlwhitespace}* ELEMENTSEND
{xmlwhitespace}*\<constantElements CONSTANTELEMENTSSTART
{xmlwhitespace}*\<\/constantElements{xmlwhitespace}*\>{xmlwhitespace}* CONSTANTELEMENTSEND
{xmlwhitespace}*\<complexElements COMPLEXELEMENTSSTART
{xmlwhitespace}*\<\/complexElements{xmlwhitespace}*\>{xmlwhitespace}* COMPLEXELEMENTSEND
{xmlwhitespace}*\<varReferenceElements VARREFERENCEELEMENTSSTART
{xmlwhitespace}*\<\/varReferenceElements{xmlwhitespace}*\>{xmlwhitespace}* VARREFERENCEELEMENTSEND
{xmlwhitespace}*\<objReferenceElements OBJREFERENCEELEMENTSSTART
{xmlwhitespace}*\<\/objReferenceElements{xmlwhitespace}*\>{xmlwhitespace}* OBJREFERENCEELEMENTSEND
{xmlwhitespace}*\<conReferenceElements CONREFERENCEELEMENTSSTART
{xmlwhitespace}*\<\/conReferenceElements{xmlwhitespace}*\>{xmlwhitespace}* CONREFERENCEELEMENTSEND
{xmlwhitespace}*\<linearElements LINEARELEMENTSSTART
{xmlwhitespace}*\<\/linearElements{xmlwhitespace}*\>{xmlwhitespace}* LINEARELEMENTSEND
{xmlwhitespace}*\<realValuedExpressions REALVALUEDEXPRESSIONSSTART
{xmlwhitespace}*\<\/realValuedExpressions{xmlwhitespace}*\>{xmlwhitespace}* REALVALUEDEXPRESSIONSSEND
{xmlwhitespace}*\<complexValuedExpressions COMPLEXVALUEDEXPRESSIONSSTART
{xmlwhitespace}*\<\/complexValuedExpressions{xmlwhitespace}*\>{xmlwhitespace}* COMPLEXVALUEDEXPRESSIONSSEND
{xmlwhitespace}*\<stringValuedElements STRINGVALUEDELEMENTSSTART
{xmlwhitespace}*\<\/stringValuedElements{xmlwhitespace}*\>{xmlwhitespace}* STRINGVALUEDELEMENTSEND

{xmlwhitespace}*\<start STARTVECTORSTART
{xmlwhitespace}*\<\/start{xmlwhitespace}*\>{xmlwhitespace}* STARTVECTOREND
{xmlwhitespace}*\<index INDEXSTART
{xmlwhitespace}*\<\/index{xmlwhitespace}*\>{xmlwhitespace}* INDEXEND
{xmlwhitespace}*\<value VALUESTART
{xmlwhitespace}*\<\/value{xmlwhitespace}*\>{xmlwhitespace}* VALUEEND
//{xmlwhitespace}*\<nonzeros NONZEROSSTART
//{xmlwhitespace}*\<\/nonzeros{xmlwhitespace}*\>{xmlwhitespace}* NONZEROSEND
//{xmlwhitespace}*\<indexes INDEXESSTART
//{xmlwhitespace}*\<\/indexes{xmlwhitespace}*\>{xmlwhitespace}* INDEXESEND
{xmlwhitespace}*\<values VALUESSTART
{xmlwhitespace}*\<\/values{xmlwhitespace}*\>{xmlwhitespace}* VALUESEND
{xmlwhitespace}*\<colOffset COLOFFSETSTART
{xmlwhitespace}*\<\/colOffset{xmlwhitespace}*\>{xmlwhitespace}* COLOFFSETEND
{xmlwhitespace}*\<rowOffset ROWOFFSETSTART
{xmlwhitespace}*\<\/rowOffset{xmlwhitespace}*\>{xmlwhitespace}* ROWOFFSETEND
{xmlwhitespace}*\<varIdx VARIDXSTART
{xmlwhitespace}*\<\/varIdx{xmlwhitespace}*\>{xmlwhitespace}* VARIDXEND
{xmlwhitespace}*\<transformation TRANSFORMATIONSTART
{xmlwhitespace}*\<\/transformation{xmlwhitespace}*\>{xmlwhitespace}* TRANSFORMATIONEND


 /* Patterns for <matrixProgramming> element */

{xmlwhitespace}*\<matrixProgramming MATRIXPROGRAMMINGSTART
{xmlwhitespace}*\<\/matrixProgramming{xmlwhitespace}*\>{xmlwhitespace}* MATRIXPROGRAMMINGEND
{xmlwhitespace}*\<matrixVariables MATRIXVARIABLESSTART
{xmlwhitespace}*\<\/matrixVariables{xmlwhitespace}*\>{xmlwhitespace}* MATRIXVARIABLESEND
{xmlwhitespace}*\<matrixVar MATRIXVARSTART
{xmlwhitespace}*\<\/matrixVar{xmlwhitespace}*\>{xmlwhitespace}* MATRIXVAREND
//{xmlwhitespace}*\<matrixObjectives MATRIXOBJECTIVESSTART
//{xmlwhitespace}*\<\/matrixObjectives{xmlwhitespace}*\>{xmlwhitespace}* MATRIXOBJECTIVESEND
{xmlwhitespace}*\<matrixObj MATRIXOBJSTART
{xmlwhitespace}*\<\/matrixObj{xmlwhitespace}*\>{xmlwhitespace}* MATRIXOBJEND
//{xmlwhitespace}*\<matrixConstraints MATRIXCONSTRAINTSSTART
//{xmlwhitespace}*\<\/matrixConstraints{xmlwhitespace}*\>{xmlwhitespace}* MATRIXCONSTRAINTSEND
{xmlwhitespace}*\<matrixCon MATRIXCONSTART
{xmlwhitespace}*\<\/matrixCon{xmlwhitespace}*\>{xmlwhitespace}* MATRIXCONEND

 /* Other patterns shared among all three major schemas */

{xmlwhitespace}*\<con CONSTART
{xmlwhitespace}*\<\/con{xmlwhitespace}*\>{xmlwhitespace}* CONEND
{xmlwhitespace}*\<constraints CONSTRAINTSSTART
{xmlwhitespace}*\<\/constraints{xmlwhitespace}*\>{xmlwhitespace}* CONSTRAINTSEND
{xmlwhitespace}*\<obj OBJSTART
{xmlwhitespace}*\<\/obj{xmlwhitespace}*\>{xmlwhitespace}* OBJEND
{xmlwhitespace}*\<objectives OBJECTIVESSTART
{xmlwhitespace}*\<\/objectives{xmlwhitespace}*\>{xmlwhitespace}*  OBJECTIVESEND
{xmlwhitespace}*\<var VARSTART
{xmlwhitespace}*\<\/var{xmlwhitespace}*\>{xmlwhitespace}* VAREND
{xmlwhitespace}*\<variables VARIABLESSTART
{xmlwhitespace}*\<\/variables{xmlwhitespace}*\>{xmlwhitespace}* VARIABLESEND


 /* The remaining patterns are shared between OSoL and OSrL.
    Since they have similar structure, the patterns are grouped by schema elements */

 /* Patterns for major headings in OSoL and OSrL */

{xmlwhitespace}*\<general GENERALSTART
{xmlwhitespace}*\<\/general{xmlwhitespace}*\>{xmlwhitespace}* GENERALEND

{xmlwhitespace}*\<system SYSTEMSTART
{xmlwhitespace}*\<\/system{xmlwhitespace}*\>{xmlwhitespace}* SYSTEMEND

{xmlwhitespace}*\<service SERVICESTART
{xmlwhitespace}*\<\/service{xmlwhitespace}*\>{xmlwhitespace}* SERVICEEND

{xmlwhitespace}*\<job JOBSTART
{xmlwhitespace}*\<\/job{xmlwhitespace}*\>{xmlwhitespace}* JOBEND

{xmlwhitespace}*\<optimization OPTIMIZATIONSTART
{xmlwhitespace}*\<\/optimization{xmlwhitespace}*\>{xmlwhitespace}* OPTIMIZATIONEND

 /* Patterns for representing a basis in LP */

{xmlwhitespace}*\<atEquality ATEQUALITYSTART
{xmlwhitespace}*\<\/atEquality{xmlwhitespace}*\>{xmlwhitespace}* ATEQUALITYEND
{xmlwhitespace}*\<atLower ATLOWERSTART
{xmlwhitespace}*\<\/atLower{xmlwhitespace}*\>{xmlwhitespace}* ATLOWEREND
{xmlwhitespace}*\<atUpper ATUPPERSTART
{xmlwhitespace}*\<\/atUpper{xmlwhitespace}*\>{xmlwhitespace}* ATUPPEREND
{xmlwhitespace}*\<basic BASICSTART
{xmlwhitespace}*\<\/basic{xmlwhitespace}*\>{xmlwhitespace}* BASICEND
{xmlwhitespace}*\<isFree ISFREESTART
{xmlwhitespace}*\<\/isFree{xmlwhitespace}*\>{xmlwhitespace}* ISFREEEND
{xmlwhitespace}*\<superbasic SUPERBASICSTART
{xmlwhitespace}*\<\/superbasic{xmlwhitespace}*\>{xmlwhitespace}* SUPERBASICEND
{xmlwhitespace}*\<unknown UNKNOWNSTART
{xmlwhitespace}*\<\/unknown{xmlwhitespace}*\>{xmlwhitespace}* UNKNOWNEND

 /* Patterns for the <general> element */

{xmlwhitespace}*\<serviceURI SERVICEURISTART
{xmlwhitespace}*\<\/serviceURI{xmlwhitespace}*\>{xmlwhitespace}* SERVICEURIEND
{xmlwhitespace}*\<serviceName SERVICENAMESTART
{xmlwhitespace}*\<\/serviceName{xmlwhitespace}*\>{xmlwhitespace}* SERVICENAMEEND
{xmlwhitespace}*\<instanceName INSTANCENAMESTART
{xmlwhitespace}*\<\/instanceName{xmlwhitespace}*\>{xmlwhitespace}* INSTANCENAMEEND
{xmlwhitespace}*\<jobID JOBIDSTART
{xmlwhitespace}*\<\/jobID{xmlwhitespace}*\>{xmlwhitespace}* JOBIDEND

 /* Other patterns */

{xmlwhitespace}*\<enumeration ENUMERATIONSTART
{xmlwhitespace}*\<\/enumeration{xmlwhitespace}*\>{xmlwhitespace}* ENUMERATIONEND
{xmlwhitespace}*\<other OTHERSTART
{xmlwhitespace}*\<\/other{xmlwhitespace}*\>{xmlwhitespace}* OTHEREND

 /* include file OSParseosnl.l.patterns --- patterns for OSnL schema elements */

 /* patterns for <nonlinearExpressions> */

//{xmlwhitespace}*\<nonlinearExpressions NONLINEAREXPRESSIONSSTART
//{xmlwhitespace}*\<\/nonlinearExpressions{xmlwhitespace}*\>{xmlwhitespace}* NONLINEAREXPRESSIONSEND
//({xmlwhitespace}+numberOfNonlinearExpressions{equality}) NUMBEROFNONLINEAREXPRESSIONS
//{xmlwhitespace}*\<nl NLSTART
//{xmlwhitespace}*\<\/nl{xmlwhitespace}*\>{xmlwhitespace}* NLEND

{xmlwhitespace}*\<times{xmlwhitespace}*\>{xmlwhitespace}* TIMESSTART
{xmlwhitespace}*\<\/times{xmlwhitespace}*\>{xmlwhitespace}* TIMESEND
{xmlwhitespace}*\<divide{xmlwhitespace}*\>{xmlwhitespace}* DIVIDESTART
{xmlwhitespace}*\<\/divide{xmlwhitespace}*\>{xmlwhitespace}* DIVIDEEND
{xmlwhitespace}*\<plus{xmlwhitespace}*\>{xmlwhitespace}* PLUSSTART
{xmlwhitespace}*\<\/plus{xmlwhitespace}*\>{xmlwhitespace}* PLUSEND
{xmlwhitespace}*\<minus{xmlwhitespace}*\>{xmlwhitespace}* MINUSSTART
{xmlwhitespace}*\<\/minus{xmlwhitespace}*\>{xmlwhitespace}* MINUSEND
{xmlwhitespace}*\<negate{xmlwhitespace}*\>{xmlwhitespace}* NEGATESTART
{xmlwhitespace}*\<\/negate{xmlwhitespace}*\>{xmlwhitespace}* NEGATEEND
{xmlwhitespace}*\<power{xmlwhitespace}*\>{xmlwhitespace}* POWERSTART
{xmlwhitespace}*\<\/power{xmlwhitespace}*\>{xmlwhitespace}* POWEREND
{xmlwhitespace}*\<ln{xmlwhitespace}*\>{xmlwhitespace}* LNSTART
{xmlwhitespace}*\<\/ln{xmlwhitespace}*\>{xmlwhitespace}* LNEND
{xmlwhitespace}*\<squareRoot{xmlwhitespace}*\>{xmlwhitespace}* SQRTSTART
{xmlwhitespace}*\<\/squareRoot{xmlwhitespace}*\>{xmlwhitespace}* SQRTEND
{xmlwhitespace}*\<sqrt{xmlwhitespace}*\>{xmlwhitespace}* SQRTSTART
{xmlwhitespace}*\<\/sqrt{xmlwhitespace}*\>{xmlwhitespace}* SQRTEND
{xmlwhitespace}*\<square{xmlwhitespace}*\>{xmlwhitespace}* SQUARESTART
{xmlwhitespace}*\<\/square{xmlwhitespace}*\>{xmlwhitespace}* SQUAREEND
{xmlwhitespace}*\<sin{xmlwhitespace}*\>{xmlwhitespace}* SINSTART
{xmlwhitespace}*\<\/sin{xmlwhitespace}*\>{xmlwhitespace}* SINEND
{xmlwhitespace}*\<cos{xmlwhitespace}*\>{xmlwhitespace}* COSSTART
{xmlwhitespace}*\<\/cos{xmlwhitespace}*\>{xmlwhitespace}* COSEND
{xmlwhitespace}*\<exp{xmlwhitespace}*\>{xmlwhitespace}* EXPSTART
{xmlwhitespace}*\<\/exp{xmlwhitespace}*\>{xmlwhitespace}* EXPEND
{xmlwhitespace}*\<abs{xmlwhitespace}*\>{xmlwhitespace}* ABSSTART
{xmlwhitespace}*\<\/abs{xmlwhitespace}*\>{xmlwhitespace}* ABSEND
{xmlwhitespace}*\<erf{xmlwhitespace}*\>{xmlwhitespace}* ERFSTART
{xmlwhitespace}*\<\/erf{xmlwhitespace}*\>{xmlwhitespace}* ERFEND
{xmlwhitespace}*\<if{xmlwhitespace}*\>{xmlwhitespace}* IFSTART
{xmlwhitespace}*\<\/if{xmlwhitespace}*\>{xmlwhitespace}* IFEND
{xmlwhitespace}*\<max{xmlwhitespace}*\>{xmlwhitespace}* MAXSTART
{xmlwhitespace}*\<\/max{xmlwhitespace}*\>{xmlwhitespace}* MAXEND
{xmlwhitespace}*\<min{xmlwhitespace}*\>{xmlwhitespace}* MINSTART
{xmlwhitespace}*\<\/min{xmlwhitespace}*\>{xmlwhitespace}* MINEND
{xmlwhitespace}*\<sum{xmlwhitespace}*\>{xmlwhitespace}* SUMSTART
{xmlwhitespace}*\<\/sum{xmlwhitespace}*\>{xmlwhitespace}* SUMEND
{xmlwhitespace}*\<allDiff{xmlwhitespace}*\>{xmlwhitespace}* ALLDIFFSTART
{xmlwhitespace}*\<\/allDiff{xmlwhitespace}*\>{xmlwhitespace}* ALLDIFFEND
{xmlwhitespace}*\<product{xmlwhitespace}*\>{xmlwhitespace}* PRODUCTSTART
{xmlwhitespace}*\<\/product{xmlwhitespace}*\>{xmlwhitespace}* PRODUCTEND
{xmlwhitespace}*\<number NUMBERSTART
{xmlwhitespace}*\<\/number{xmlwhitespace}*\>{xmlwhitespace}* NUMBEREND
{xmlwhitespace}*\<E ESTART
{xmlwhitespace}*\<\/E{xmlwhitespace}*\>{xmlwhitespace}* EEND
{xmlwhitespace}*\<PI PISTART
{xmlwhitespace}*\<\/PI{xmlwhitespace}*\>{xmlwhitespace}* PIEND
{xmlwhitespace}*\<variable VARIABLESTART
{xmlwhitespace}*\<\/variable{xmlwhitespace}*\>{xmlwhitespace}* VARIABLEEND

 /* patterns for <matrixExpressions> */

//{xmlwhitespace}*\<matrixExpressions MATRIXEXPRESSIONSSTART
//{xmlwhitespace}*\<\/matrixExpressions{xmlwhitespace}*\>{xmlwhitespace}* MATRIXEXPRESSIONSEND
//({xmlwhitespace}+numberOfExpr{equality}) NUMBEROFEXPR
//{xmlwhitespace}*\<expr EXPRSTART
//{xmlwhitespace}*\<\/expr{xmlwhitespace}*\>{xmlwhitespace}* EXPREND

{xmlwhitespace}*\<matrixDeterminant{xmlwhitespace}*\>{xmlwhitespace}* MATRIXDETERMINANTSTART
{xmlwhitespace}*\<\/matrixDeterminant{xmlwhitespace}*\>{xmlwhitespace}* MATRIXDETERMINANTEND
{xmlwhitespace}*\<matrixTrace{xmlwhitespace}*\>{xmlwhitespace}* MATRIXTRACESTART
{xmlwhitespace}*\<\/matrixTrace{xmlwhitespace}*\>{xmlwhitespace}* MATRIXTRACEEND
{xmlwhitespace}*\<matrixToScalar{xmlwhitespace}*\>{xmlwhitespace}* MATRIXTOSCALARSTART
{xmlwhitespace}*\<\/matrixToScalar{xmlwhitespace}*\>{xmlwhitespace}* MATRIXTOSCALAREND

 /* patterns for <matrixTerms> in <matrixConstraints> and <matrixObjectives>*/

//({xmlwhitespace}+numberOfMatrixTerms{equality}) NUMBEROFMATRIXTERMSATT
//{xmlwhitespace}*\<matrixTerm MATRIXTERMSTART
//{xmlwhitespace}*\<\/matrixTerm{xmlwhitespace}*\>{xmlwhitespace}* MATRIXTERMEND

{xmlwhitespace}*\<matrixReference MATRIXREFERENCESTART
{xmlwhitespace}*\<\/matrixReference{xmlwhitespace}*\>{xmlwhitespace}* MATRIXREFERENCEEND
{xmlwhitespace}*\<matrixDiagonal{xmlwhitespace}*\>{xmlwhitespace}* MATRIXDIAGONALSTART
{xmlwhitespace}*\<\/matrixDiagonal{xmlwhitespace}*\>{xmlwhitespace}* MATRIXDIAGONALEND
{xmlwhitespace}*\<matrixDotTimes{xmlwhitespace}*\>{xmlwhitespace}* MATRIXDOTTIMESSTART
{xmlwhitespace}*\<\/matrixDotTimes{xmlwhitespace}*\>{xmlwhitespace}* MATRIXDOTTIMESEND
{xmlwhitespace}*\<matrixInverse{xmlwhitespace}*\>{xmlwhitespace}* MATRIXINVERSESTART
{xmlwhitespace}*\<\/matrixInverse{xmlwhitespace}*\>{xmlwhitespace}* MATRIXINVERSEEND
{xmlwhitespace}*\<matrixLowerTriangle MATRIXLOWERTRIANGLESTART
{xmlwhitespace}*\<\/matrixLowerTriangle{xmlwhitespace}*\>{xmlwhitespace}* MATRIXLOWERTRIANGLEEND
{xmlwhitespace}*\<matrixUpperTriangle MATRIXUPPERTRIANGLESTART
{xmlwhitespace}*\<\/matrixUpperTriangle{xmlwhitespace}*\>{xmlwhitespace}* MATRIXUPPERTRIANGLEEND
{xmlwhitespace}*\<matrixMerge MATRIXMERGESTART
{xmlwhitespace}*\<\/matrixMerge{xmlwhitespace}*\>{xmlwhitespace}* MATRIXMERGEEND
{xmlwhitespace}*\<matrixMinus{xmlwhitespace}*\>{xmlwhitespace}* MATRIXMINUSSTART
{xmlwhitespace}*\<\/matrixMinus{xmlwhitespace}*\>{xmlwhitespace}* MATRIXMINUSEND
{xmlwhitespace}*\<matrixNegate{xmlwhitespace}*\>{xmlwhitespace}* MATRIXNEGATESTART
{xmlwhitespace}*\<\/matrixNegate{xmlwhitespace}*\>{xmlwhitespace}* MATRIXNEGATEEND
{xmlwhitespace}*\<matrixPlus{xmlwhitespace}*\>{xmlwhitespace}* MATRIXPLUSSTART
{xmlwhitespace}*\<\/matrixPlus{xmlwhitespace}*\>{xmlwhitespace}* MATRIXPLUSEND
{xmlwhitespace}*\<matrixSum{xmlwhitespace}*\>{xmlwhitespace}* MATRIXSUMSTART
{xmlwhitespace}*\<\/matrixSum{xmlwhitespace}*\>{xmlwhitespace}* MATRIXSUMEND
{xmlwhitespace}*\<matrixTimes{xmlwhitespace}*\>{xmlwhitespace}* MATRIXTIMESSTART
{xmlwhitespace}*\<\/matrixTimes{xmlwhitespace}*\>{xmlwhitespace}* MATRIXTIMESEND
{xmlwhitespace}*\<matrixProduct{xmlwhitespace}*\>{xmlwhitespace}* MATRIXPRODUCTSTART
{xmlwhitespace}*\<\/matrixProduct{xmlwhitespace}*\>{xmlwhitespace}* MATRIXPRODUCTEND
{xmlwhitespace}*\<matrixScalarTimes{xmlwhitespace}*\>{xmlwhitespace}* MATRIXSCALARTIMESSTART
{xmlwhitespace}*\<\/matrixScalarTimes{xmlwhitespace}*\>{xmlwhitespace}* MATRIXSCALARTIMESEND
{xmlwhitespace}*\<matrixSubmatrixAt{xmlwhitespace}*\>{xmlwhitespace}* MATRIXSUBMATRIXATSTART
{xmlwhitespace}*\<\/matrixSubmatrixAt{xmlwhitespace}*\>{xmlwhitespace}* MATRIXSUBMATRIXATEND
{xmlwhitespace}*\<matrixTranspose{xmlwhitespace}*\>{xmlwhitespace}* MATRIXTRANSPOSESTART
{xmlwhitespace}*\<\/matrixTranspose{xmlwhitespace}*\>{xmlwhitespace}* MATRIXTRANSPOSEEND
{xmlwhitespace}*\<identityMatrix{xmlwhitespace}*\>{xmlwhitespace}* IDENTITYMATRIXSTART
{xmlwhitespace}*\<\/identityMatrix{xmlwhitespace}*\>{xmlwhitespace}* IDENTITYMATRIXEND

 /* patterns for complex expressions and functions */

{xmlwhitespace}*\<complexNumber COMPLEXNUMBERSTART
{xmlwhitespace}*\<\/complexNumber{xmlwhitespace}*\>{xmlwhitespace}* COMPLEXNUMBEREND
{xmlwhitespace}*\<createComplex CREATECOMPLEXSTART
{xmlwhitespace}*\<\/createComplex{xmlwhitespace}*\>{xmlwhitespace}* CREATECOMPLEXEND
{xmlwhitespace}*\<complexPlus COMPLEXPLUSSTART
{xmlwhitespace}*\<\/complexPlus{xmlwhitespace}*\>{xmlwhitespace}* COMPLEXPLUSEND
{xmlwhitespace}*\<complexSum COMPLEXSUMSTART
{xmlwhitespace}*\<\/complexSum{xmlwhitespace}*\>{xmlwhitespace}* COMPLEXSUMEND
{xmlwhitespace}*\<complexMinus COMPLEXMINUSSTART
{xmlwhitespace}*\<\/complexMinus{xmlwhitespace}*\>{xmlwhitespace}* COMPLEXMINUSEND
{xmlwhitespace}*\<complexNegate COMPLEXNEGATESTART
{xmlwhitespace}*\<\/complexNegate{xmlwhitespace}*\>{xmlwhitespace}* COMPLEXNEGATEEND
{xmlwhitespace}*\<complexConjugate COMPLEXCONJUGATESTART
{xmlwhitespace}*\<\/complexConjugate{xmlwhitespace}*\>{xmlwhitespace}* COMPLEXCONJUGATEEND
{xmlwhitespace}*\<complexTimes COMPLEXTIMESSTART
{xmlwhitespace}*\<\/complexTimes{xmlwhitespace}*\>{xmlwhitespace}* COMPLEXTIMESEND
{xmlwhitespace}*\<complexSquare COMPLEXSQUARESTART
{xmlwhitespace}*\<\/complexSquare{xmlwhitespace}*\>{xmlwhitespace}* COMPLEXSQUAREEND


 /* attributes returning strings (that are potentially empty)*/

//({xmlwhitespace}+id{equality}\"\") EMPTYIDATT
//({xmlwhitespace}+id{equality}\'\') EMPTYIDATT
({xmlwhitespace}+id{equality}\")<doublequoteattributetext> IDATT
({xmlwhitespace}+id{equality}\')<singlequoteattributetext> IDATT

//({xmlwhitespace}+includeDiagonal{equality}\"\") EMPTYINCLUDEDIAGONALATT
//({xmlwhitespace}+includeDiagonal{equality}\'\') EMPTYINCLUDEDIAGONALATT
({xmlwhitespace}+includeDiagonal{equality}\")<doublequoteattributetext> INCLUDEDIAGONALATT
({xmlwhitespace}+includeDiagonal{equality}\')<singlequoteattributetext> INCLUDEDIAGONALATT

//({xmlwhitespace}+transpose{equality}\"\") EMPTYTRANSPOSEATT
//({xmlwhitespace}+transpose{equality}\'\') EMPTYTRANSPOSEATT
({xmlwhitespace}+transpose{equality}\")<doublequoteattributetext> TRANSPOSEATT
({xmlwhitespace}+transpose{equality}\')<singlequoteattributetext> TRANSPOSEATT

 /* last section of OSParseosrl.l */

 /* environments and comments */

[a-zA-Z0-9.:_*#$@(), \n\t\r\/\\\-\+\=\&\%]+ ELEMENTTEXT
<itemtext>[^\<]+<INITIAL> ITEMTEXT

"<!--"<comment>
<comment>.|\n<.>
<comment>"-->"<INITIAL>	skip()

"<?"<xmldeclaration>
<xmldeclaration>.|\n<.>
<xmldeclaration>"?>"<INITIAL>	skip()


<doublequoteattributetext>[^\"]+<INITIAL> ATTRIBUTETEXT
<singlequoteattributetext>[^\']+<INITIAL> ATTRIBUTETEXT
<osrlattributetext>([^>])+<INITIAL>OSRLATTRIBUTETEXT

%%
