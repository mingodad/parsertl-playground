//From: https://github.com/AlaSQL/alasql/blob/e4869a1f14e03903901f74cd52fe0dd48bfe8915/src/alasqlparser.jison
/*
//
// alasqlparser.jison
// SQL Parser for AlaSQL
// (c) 2014-2015, Andrey Gershun
//
//
*/

//%token ABSENT /*1*/
//%token ABSOLUTE /*4*/
//%token ACCORDING /*1*/
%token ACTION /*5*/
//%token ADA /*1*/
%token ADD /*4*/
//%token ADMIN /*1*/
%token AFTER /*4*/
%token AGGR /*3*/
%token AGGREGATE /*4*/
%token ALL /*10*/
%token ALTER /*8*/
//%token ALWAYS /*1*/
%token AMPERSAND /*3*/
//%token AMPERSANDAMPERSAND /*1*/
%token AND /*13*/
%token ANTI /*3*/
%token ANY /*4*/
%token APPLY /*6*/
%token ARRAY /*4*/
%token ARRAYLBRA /*2*/
%token ARROW /*3*/
%token AS /*51*/
//%token ASC /*2*/
%token ASSERT /*5*/
//%token ASSERTION /*1*/
//%token ASSIGNMENT /*1*/
%token AT /*20*/
%token ATLBRA /*3*/
%token ATTACH /*6*/
//%token ATTRIBUTE /*1*/
//%token ATTRIBUTES /*1*/
%token AVG /*3*/
%token BAR /*4*/
%token BARBAR /*3*/
%token BEFORE /*4*/
%token BEGIN /*4*/
//%token BERNOULLI /*1*/
%token BETWEEN /*6*/
//%token BLOCKED /*1*/
//%token BOM /*1*/
%token BRALITERAL /*4*/
%token BRAQUESTION /*2*/
//%token BREADTH /*1*/
%token BREAK /*3*/
%token BY /*12*/
%token CALL /*5*/
%token CARET /*4*/
//%token CASCADE /*1*/
%token CASE /*4*/
%token CAST /*4*/
//%token CATALOG /*1*/
//%token CATALOG_NAME /*1*/
//%token CHAIN /*1*/
//%token CHARACTERISTICS /*1*/
//%token CHARACTERS /*1*/
//%token CHARACTER_SET_CATALOG /*1*/
//%token CHARACTER_SET_NAME /*1*/
//%token CHARACTER_SET_SCHEMA /*1*/
%token CHECK /*5*/
%token CLASS /*5*/
//%token CLASS_ORIGIN /*1*/
//%token CLOSE /*3*/
//%token COBOL /*1*/
%token COLLATE /*5*/
//%token COLLATION /*1*/
//%token COLLATION_CATALOG /*1*/
//%token COLLATION_NAME /*1*/
//%token COLLATION_SCHEMA /*1*/
%token COLON /*10*/
%token COLONDASH /*3*/
%token COLUMN /*12*/
//%token COLUMNS /*2*/
//%token COLUMN_NAME /*1*/
%token COMMA /*53*/
//%token COMMAND /*1*/
//%token COMMAND_FUNCTION /*1*/
//%token COMMAND_FUNCTION_CODE /*1*/
%token COMMIT /*3*/
//%token COMMITTED /*1*/
//%token CONDITION_NUMBER /*1*/
//%token CONNECTION /*1*/
//%token CONNECTION_NAME /*1*/
%token CONSTRAINT /*4*/
//%token CONSTRAINTS /*1*/
//%token CONSTRAINT_CATALOG /*1*/
//%token CONSTRAINT_NAME /*1*/
//%token CONSTRAINT_SCHEMA /*1*/
//%token CONSTRUCTOR /*1*/
%token CONTENT /*7*/
%token CONTINUE /*4*/
//%token CONTROL /*1*/
%token CONVERT /*4*/
%token CORRESPONDING /*6*/
%token COUNT /*3*/
%token CREATE /*33*/
%token CROSS /*5*/
%token CUBE /*3*/
%token CURRENT_TIMESTAMP /*4*/
//%token CURSOR /*3*/
//%token CURSOR_NAME /*1*/
//%token DATA /*1*/
%token DATABASE /*20*/
//%token DATABASES /*1*/
%token DATEADD /*4*/
%token DATEDIFF /*4*/
//%token DATETIME_INTERVAL_CODE /*1*/
//%token DATETIME_INTERVAL_PRECISION /*1*/
//%token DB /*1*/
%token DECLARE /*4*/
%token DEFAULT /*9*/
//%token DEFAULTS /*1*/
//%token DEFERRABLE /*1*/
//%token DEFERRED /*1*/
//%token DEFINED /*1*/
//%token DEFINER /*1*/
//%token DEGREE /*1*/
%token DELETE /*11*/
//%token DELETED /*2*/
//%token DEPTH /*1*/
//%token DERIVED /*1*/
//%token DESC /*2*/
//%token DESCRIPTOR /*1*/
%token DETACH /*3*/
//%token DIAGNOSTICS /*1*/
%token DIRECTION /*6*/
//%token DISPATCH /*1*/
%token DISTINCT /*6*/
//%token DOCUMENT /*1*/
%token DOLLAR /*6*/
//%token DOLLARSTRING /*1*/
//%token DOMAIN /*1*/
%token DOT /*11*/
%token DOTDOT /*2*/
//%token DOUBLE /*1*/
%token DOUBLECOLON /*3*/
%token DROP /*11*/
//%token DYNAMIC_FUNCTION /*1*/
//%token DYNAMIC_FUNCTION_CODE /*1*/
%token ECHO /*4*/
%token EDGE /*7*/
%token ELSE /*4*/
//%token EMPTY /*1*/
//%token ENCODING /*1*/
%token END /*5*/
//%token ENFORCED /*1*/
%token ENUM /*4*/
//%token EOF /*3*/
%token EQ /*18*/
%token EQEQ /*3*/
%token EQEQEQ /*3*/
%token ESCAPE /*4*/
%token EXCEPT /*6*/
%token EXCLAMATION /*7*/
//%token EXCLUDE /*1*/
//%token EXCLUDING /*1*/
//%token EXEC /*1*/
//%token EXECUTE /*1*/
%token EXISTS /*5*/
%token EXPLAIN /*4*/
//%token EXPRESSION /*1*/
%token FALSE /*3*/
%token FETCH /*4*/
//%token FILE /*1*/
//%token FINAL /*1*/
%token FIRST /*6*/
//%token FLAG /*1*/
//%token FOLLOWING /*1*/
%token FOR /*6*/
%token FOREIGN /*4*/
//%token FORTRAN /*1*/
//%token FOUND /*1*/
%token FROM /*25*/
//%token FS /*1*/
%token FULL /*3*/
%token FUNCTION /*3*/
%token GE /*4*/
//%token GENERAL /*1*/
//%token GENERATED /*1*/
%token GLOB /*4*/
%token GO /*4*/
//%token GOTO /*1*/
//%token GRANTED /*1*/
%token GRAPH /*4*/
%token GROUP /*3*/
%token GROUPING /*3*/
%token GT /*9*/
%token GTGT /*5*/
%token HAVING /*3*/
//%token HELP /*4*/
//%token HEX /*1*/
//%token HIERARCHY /*1*/
//%token ID /*1*/
%token IDENTITY /*6*/
%token IF /*9*/
//%token IGNORE /*1*/
//%token ILIKE /*2*/
//%token IMMEDIATE /*1*/
//%token IMMEDIATELY /*1*/
//%token IMPLEMENTATION /*1*/
%token IN /*15*/
//%token INCLUDING /*1*/
//%token INCREMENT /*2*/
//%token INDENT /*1*/
%token INDEX /*10*/
%token INDEXED /*3*/
//%token INDEXES /*1*/
//%token INITIALLY /*1*/
%token INNER /*3*/
//%token INPUT /*1*/
%token INSERT /*18*/
%token INSERTED /*3*/
//%token INSTANCE /*1*/
//%token INSTANTIABLE /*1*/
%token INSTEAD /*4*/
//%token INTEGRITY /*1*/
%token INTERSECT /*5*/
%token INTERVAL /*3*/
%token INTO /*12*/
//%token INVALID /*1*/
//%token INVOKER /*1*/
%token IS /*4*/
//%token ISOLATION /*1*/
%token JAVASCRIPT /*4*/
%token JOIN /*13*/
%token KEY /*9*/
//%token KEY_MEMBER /*1*/
//%token KEY_TYPE /*1*/
%token LAST /*6*/
%token LCUR /*4*/
%token LE /*4*/
%token LEFT /*4*/
//%token LENGTH /*1*/
//%token LET /*3*/
//%token LEVEL /*1*/
//%token LIBRARY /*1*/
%token LIKE /*15*/
%token LIMIT /*5*/
//%token LINK /*1*/
%token LITERAL /*12*/
//%token LOCATION /*1*/
//%token LOCATOR /*1*/
%token LPAR /*121*/
%token LT /*5*/
%token LTLT /*4*/
//%token MAP /*1*/
//%token MAPPING /*1*/
%token MATCHED /*11*/
%token MATRIX /*4*/
%token MAX /*9*/
%token MAXNUM /*3*/
//%token MAXVALUE /*1*/
%token MERGE /*3*/
//%token MESSAGE_LENGTH /*1*/
//%token MESSAGE_OCTET_LENGTH /*1*/
//%token MESSAGE_TEXT /*1*/
%token MIN /*7*/
%token MINUS /*5*/
//%token MINVALUE /*1*/
%token MODIFY /*3*/
%token MODULO /*5*/
//%token MORE /*1*/
//%token MUMPS /*1*/
//%token NAME /*1*/
//%token NAMES /*1*/
//%token NAMESPACE /*1*/
%token NATURAL /*3*/
%token NE /*5*/
%token NEEQEQ /*3*/
%token NEEQEQEQ /*3*/
//%token NESTING /*1*/
%token NEW /*4*/
%token NEXT /*5*/
//%token NFC /*1*/
//%token NFD /*1*/
//%token NFKC /*1*/
//%token NFKD /*1*/
//%token NIL /*1*/
%token NO /*4*/
%token NOCASE /*4*/
//%token NORMALIZED /*1*/
%token NOT /*23*/
%token NOT_BETWEEN /*3*/
%token NOT_LIKE /*7*/
%token NSTRING /*3*/
%token NULL /*6*/
//%token NULLABLE /*1*/
%token NULLS /*5*/
%token NUMBER /*18*/
//%token OBJECT /*1*/
//%token OCTETS /*1*/
%token OF /*12*/
%token OFF /*4*/
%token OFFSET /*4*/
%token ON /*14*/
%token ONLY /*4*/
//%token OPEN /*3*/
%token OPTION /*5*/
//%token OPTIONS /*1*/
%token OR /*8*/
%token ORDER /*6*/
//%token ORDERING /*1*/
//%token ORDINALITY /*1*/
//%token OTHERS /*1*/
%token OUTER /*8*/
%token OUTPUT /*5*/
%token OVER /*5*/
//%token OVERRIDING /*1*/
//%token PAD /*1*/
//%token PARAMETER_MODE /*1*/
//%token PARAMETER_NAME /*1*/
//%token PARAMETER_ORDINAL_POSITION /*1*/
//%token PARAMETER_SPECIFIC_CATALOG /*1*/
//%token PARAMETER_SPECIFIC_NAME /*1*/
//%token PARAMETER_SPECIFIC_SCHEMA /*1*/
//%token PART /*1*/
//%token PARTIAL /*1*/
%token PARTITION /*3*/
//%token PASCAL /*1*/
//%token PASSING /*1*/
//%token PASSTHROUGH /*1*/
%token PATH /*4*/
%token PERCENT /*3*/
//%token PERMISSION /*1*/
%token PIVOT /*3*/
//%token PL /*1*/
//%token PLACING /*1*/
%token PLAN /*3*/
//%token PLI /*1*/
%token PLUS /*5*/
//%token PRECEDING /*1*/
//%token PRECISION /*1*/
//%token PRESERVE /*1*/
%token PRIMARY /*4*/
%token PRINT /*4*/
//%token PRIOR /*4*/
//%token PRIVILEGES /*1*/
//%token PUBLIC /*1*/
%token QUERY /*3*/
%token QUESTION /*3*/
%token QUESTIONDASH /*2*/
%token RBRA /*5*/
%token RCUR /*4*/
%token READ /*4*/
%token RECORDSET /*4*/
//%token RECOVERY /*1*/
//%token REDUCE /*3*/
%token REFERENCES /*5*/
%token REGEXP /*4*/
%token REINDEX /*3*/
//%token RELATIVE /*4*/
%token REMOVE /*3*/
%token RENAME /*5*/
%token REPEAT /*3*/
//%token REPEATABLE /*1*/
%token REPLACE /*8*/
%token REQUIRE /*4*/
//%token REQUIRING /*1*/
//%token RESPECT /*1*/
//%token RESTART /*1*/
//%token RESTORE /*5*/
//%token RESTRICT /*1*/
%token RETURN /*4*/
//%token RETURNED_CARDINALITY /*1*/
//%token RETURNED_LENGTH /*1*/
//%token RETURNED_OCTET_LENGTH /*1*/
//%token RETURNED_SQLSTATE /*1*/
//%token RETURNING /*1*/
//%token RETURNS /*1*/
%token RIGHT /*4*/
//%token ROLE /*1*/
%token ROLLBACK /*3*/
%token ROLLUP /*3*/
//%token ROUTINE /*1*/
//%token ROUTINE_CATALOG /*1*/
//%token ROUTINE_NAME /*1*/
//%token ROUTINE_SCHEMA /*1*/
%token ROW /*5*/
%token ROWS /*4*/
//%token ROW_COUNT /*1*/
%token RPAR /*121*/
//%token SCALE /*1*/
//%token SCHEMA /*2*/
//%token SCHEMA_NAME /*1*/
//%token SCOPE_CATALOG /*1*/
//%token SCOPE_NAME /*1*/
//%token SCOPE_SCHEMA /*1*/
%token SEARCH /*5*/
//%token SECTION /*1*/
//%token SECURITY /*1*/
%token SELECT /*25*/
//%token SELECTIVE /*1*/
//%token SELF /*1*/
%token SEMI /*3*/
%token SEMICOLON /*2*/
//%token SEQUENCE /*1*/
//%token SERIALIZABLE /*1*/
//%token SERVER /*1*/
//%token SERVER_NAME /*1*/
//%token SESSION /*1*/
%token SET /*18*/
//%token SETS /*2*/
%token SHARP /*7*/
%token SHOW /*17*/
//%token SIMPLE /*1*/
//%token SIZE /*1*/
%token SLASH /*5*/
%token SOME /*3*/
%token SOURCE /*6*/
//%token SPACE /*1*/
//%token SPECIFIC_NAME /*1*/
//%token SQL /*2*/
//%token STANDALONE /*1*/
%token STAR /*7*/
//%token STATE /*1*/
//%token STATEMENT /*1*/
//%token STORE /*4*/
//%token STRATEGY /*3*/
%token STRING /*19*/
//%token STRIP /*1*/
//%token STRUCTURE /*1*/
//%token STYLE /*1*/
//%token SUBCLASS_ORIGIN /*1*/
%token SUM /*3*/
%token TABLE /*21*/
//%token TABLES /*1*/
//%token TABLE_NAME /*1*/
%token TARGET /*4*/
%token TEMP /*4*/
//%token TEMPORARY /*2*/
//%token TEXT /*1*/
%token TEXTSTRING /*3*/
%token THEN /*11*/
//%token TIES /*1*/
%token TILDA /*4*/
//%token TIMEOUT /*3*/
%token TIMESTAMPDIFF /*3*/
%token TO /*10*/
//%token TODO /*2*/
//%token TOKEN /*1*/
%token TOP /*4*/
//%token TOP_LEVEL_COUNT /*1*/
%token TOTAL /*3*/
//%token TRAN /*1*/
%token TRANSACTION /*8*/
//%token TRANSACTIONS_COMMITTED /*1*/
//%token TRANSACTIONS_ROLLED_BACK /*1*/
//%token TRANSACTION_ACTIVE /*1*/
//%token TRANSFORM /*1*/
//%token TRANSFORMS /*1*/
%token TRIGGER /*6*/
//%token TRIGGER_CATALOG /*1*/
//%token TRIGGER_NAME /*1*/
//%token TRIGGER_SCHEMA /*1*/
%token TRUE /*3*/
%token TRUNCATE /*3*/
//%token TWO /*1*/
//%token TYPE /*1*/
//%token UNBOUNDED /*1*/
//%token UNCOMMITTED /*1*/
//%token UNDER /*1*/
%token UNION /*8*/
%token UNIQUE /*7*/
//%token UNLINK /*1*/
//%token UNNAMED /*1*/
%token UNPIVOT /*3*/
//%token UNTYPED /*1*/
%token UPDATE /*10*/
//%token URI /*1*/
//%token USAGE /*1*/
%token USE /*4*/
//%token USER /*4*/
//%token USER_DEFINED_TYPE_CATALOG /*1*/
//%token USER_DEFINED_TYPE_CODE /*1*/
//%token USER_DEFINED_TYPE_NAME /*1*/
//%token USER_DEFINED_TYPE_SCHEMA /*1*/
%token USING /*4*/
//%token VALID /*1*/
%token VALUE /*9*/
%token VALUES /*7*/
//%token VERSION /*1*/
%token VERTEX /*12*/
%token VIEW /*6*/
%token WHEN /*11*/
%token WHERE /*8*/
%token WHILE /*4*/
//%token WHITESPACE /*1*/
%token WITH /*8*/
//%token WORK /*2*/
//%token WRAPPER /*1*/
//%token WRITE /*1*/
//%token XMLDECLARATION /*1*/
//%token XMLSCHEMA /*1*/
//%token YES /*1*/
//%token ZONE /*1*/

%left COMMA
%left DOUBLECOLON
%left OR
/* %left AND */
%left AND BETWEEN NOT_BETWEEN
/*%left AND*/
%left IN
%left NOT
%left GT GE LT LE EQ NE EQEQ NEEQEQ EQEQEQ NEEQEQEQ
%left IS
%left LIKE NOT_LIKE REGEXP GLOB
%left GTGT LTLT AMPERSAND BAR
%left PLUS MINUS
%left STAR SLASH MODULO
%left CARET
%left DOT ARROW EXCLAMATION
%left TILDA
%left SHARP
%left BARBAR

%start main

%%

Literal :
	LITERAL
	| BRALITERAL
	//| error NonReserved
	;

LiteralWithSpaces :
	LITERAL
	| LiteralWithSpaces LITERAL
	;

main :
	Statements //EOF
	;

Statements :
	Statements (SEMICOLON|GO) AStatement
	| AStatement
	| ExplainStatement
	;

ExplainStatement :
	EXPLAIN AStatement
	| EXPLAIN QUERY PLAN AStatement
	;

AStatement :
	Statement
	;

Statement :
	/*empty*/
	| AlterTable
	| AttachDatabase
	| Call
	| CreateDatabase
	| CreateIndex
	| CreateGraph
	| CreateTable
	| CreateView
	| CreateEdge
	| CreateVertex
	| Declare
	| Delete
	| DetachDatabase
	| DropDatabase
	| DropIndex
	| DropTable
	| DropView
	| If
	| Insert
	| Merge
	| Reindex
	| RenameTable
	| Select
	| ShowCreateTable
	| ShowColumns
	| ShowDatabases
	| ShowIndex
	| ShowTables
	| TruncateTable
	| WithSelect
	| CreateTrigger
	| DropTrigger
	| BeginTransaction
	| CommitTransaction
	| RollbackTransaction
//	| EndTransaction
	| UseDatabase
	| Update
	/*| Help*/
	| JavaScript
	| Source
	| Assert
	| While
	| Continue
	| Break
	| BeginEnd
	| Print
	| Require
	| SetVariable
	| ExpressionStatement
	| AddRule
	| Query
/* PLugins */
	| Echo
/*
	| Store
	| Restore
	| DeclareCursor
	| OpenCursor
	| FetchCursor
	| CloseCursor
	| SavePoint
	| StoreDatabase
	| StoreTable
	| RestoreDatabase
	| RestoreTable
	| While
	| BulkInsert
	| CreateFunction
	| CreateProcedure
	| Loop
	| ForLoop
*/
	| CreateFunction
	| CreateAggregate
	;

/* WITH */

WithSelect :
	WITH WithTablesList Select
	;

WithTablesList :
	WithTablesList COMMA WithTable
	| WithTable
	;

WithTable :
	Literal AS LPAR Select RPAR
	;

/* SELECT */

Select :
	SelectClause RemoveClause? IntoClause FromClause PivotClause? WhereClause GroupClause  OrderClause LimitClause UnionClause
	| SEARCH SearchSelector* IntoClause SearchFrom?
	;

PivotClause :
	PIVOT LPAR Expression FOR Literal PivotClause2? RPAR AsLiteral?
	| UNPIVOT LPAR Literal FOR Literal IN LPAR ColumnsList RPAR RPAR AsLiteral?
	;

PivotClause2 :
	IN LPAR AsList RPAR
	;

AsLiteral :
	AS Literal
	| Literal
	;

AsList :
	AsList COMMA AsPart
	| AsPart
	;

AsPart :
	Expression
	| Expression AS Literal
	;

RemoveClause :
	REMOVE COLUMN? RemoveColumnsList
	;

RemoveColumnsList :
	RemoveColumnsList COMMA RemoveColumn
	| RemoveColumn
	;

RemoveColumn :
	Column
	| LIKE StringValue
	;

ArrowDot :
	ARROW
	| DOT
	;

SearchSelector :
	Literal
	| ORDER BY LPAR OrderExpressionsList RPAR
	| ORDER BY LPAR DIRECTION? RPAR
	| DOTDOT
	| ArrowDot Literal
	| CARET
	| EQ Expression
	| LIKE Expression
	| LPAR SearchSelector+ RPAR
	| WITH LPAR SearchSelector+ RPAR
	| Literal LPAR ExprList? RPAR
	| WHERE LPAR Expression RPAR
	| OF LPAR Expression RPAR
	| CLASS LPAR Literal RPAR
	| NUMBER
	| STRING
	| SLASH
	| VERTEX
	| EDGE
	| EXCLAMATION
	| SHARP Literal
	| MODULO Literal
	| MODULO SLASH
	| GT
	| LT
	| GTGT
	| LTLT
	| DOLLAR
/*	| DELETE LPAR RPAR
*/	| Json
	| AT Literal
	| AS AT Literal
	| SET LPAR SetColumnsList RPAR
	| TO AT Literal
	| VALUE
	| ROW LPAR ExprList RPAR
	| COLON Literal
	| SearchSelector PlusStar
	| NOT LPAR SearchSelector* RPAR
	| IF LPAR SearchSelector* RPAR
	| Aggregator LPAR SearchSelector* RPAR
	| (DISTINCT|UNIQUE) LPAR SearchSelector* RPAR
	| UNION LPAR SearchSelectorList RPAR
	| UNION ALL LPAR SearchSelectorList RPAR
	| ALL LPAR SearchSelector* RPAR
	| ANY LPAR SearchSelector* RPAR
	| INTERSECT LPAR SearchSelectorList RPAR
	| EXCEPT LPAR SearchSelectorList RPAR
	| AND LPAR SearchSelectorList RPAR
	| OR LPAR SearchSelectorList RPAR
	| PATH LPAR SearchSelector RPAR
	| RETURN LPAR ResultColumns RPAR
	| REPEAT LPAR SearchSelector* COMMA ExprList RPAR
	;

SearchSelectorList :
	SearchSelectorList COMMA SearchSelector*
	| SearchSelector*
	;

PlusStar :
	PLUS
	| STAR
	| QUESTION
	;

SearchFrom :
	FROM Expression
	;

/*
SearchLet :
	LET
	;

SearchWhile :
	WHILE Expression
	;

SearchLimit :
	LIMIT Expression
	;

SearchStrategy :
	STRATEGY Literal
	;

SearchTimeout :
	TIMEOUT Expression
	;

*/

SelectClause :
	SelectModifier DISTINCT TopClause ResultColumns
	| SelectModifier UNIQUE TopClause ResultColumns
	| SelectModifier  ALL TopClause ResultColumns
	| SelectModifier TopClause ResultColumns?
	;

SelectModifier :
	SELECT
	| SELECT VALUE
	| SELECT ROW
	| SELECT COLUMN
	| SELECT MATRIX
	| SELECT TEXTSTRING
	| SELECT INDEX
	| SELECT RECORDSET
	;

TopClause :
	TOP NumValue PERCENT?
	| TOP LPAR NumValue RPAR
	| /*empty*/
	;

IntoClause :
	/*empty*/
	| INTO Table
	| INTO FuncValue
	| INTO ParamValue
	| INTO VarValue
	| INTO STRING
	;

FromClause :
	FROM FromTablesList

/*	| FROM FromTable JoinTablesList
*/	| FROM FromTablesList JoinTablesList
/*	| FROM LPAR FromTable JoinTablesList RPAR
*/	| FROM LPAR FromTablesList JoinTablesList RPAR
	| /*empty*/
	;

ApplyClause :
	CROSS APPLY LPAR Select RPAR Literal
	| CROSS APPLY LPAR Select RPAR AS Literal
	| OUTER APPLY LPAR Select RPAR Literal
	| OUTER APPLY LPAR Select RPAR AS Literal
	;

FromTablesList :
	FromTable
	| FromTablesList COMMA FromTable
	;

FromTable :
	LPAR Select RPAR Literal
	| LPAR Select RPAR AS Literal
	| LPAR Select RPAR /* default alias */
	| Json AS? Literal?
	| Table Literal
	| Table AS Literal
	| Table
	| Table NOT INDEXED
	| ParamValue Literal
	| ParamValue AS Literal
	| ParamValue
	| FuncValue
	| FuncValue Literal
	| FuncValue AS Literal
	| INSERTED
	| VarValue
	| VarValue Literal
	| VarValue AS Literal
	| FromString
	| FromString Literal
	| FromString AS Literal
	;

FromString :
	STRING
	;

Table :
	Literal DOT Literal
	| Literal
	;

JoinTablesList :
	JoinTablesList JoinTable
	| JoinTablesList ApplyClause
	| JoinTable
	| ApplyClause
	;

JoinTable :
	JoinMode JoinTableAs OnClause
	;

JoinTableAs :
	Table
	| Table Literal
	| Table AS Literal
	| Json AS? Literal?
	| ParamValue Literal
	| ParamValue AS Literal
	| LPAR Select RPAR Literal
	| LPAR Select RPAR AS Literal
	| FuncValue
	| FuncValue Literal
	| FuncValue AS Literal
	| VarValue
	| VarValue Literal
	| VarValue AS Literal
	;

JoinMode :
	JoinModeMode
	| NATURAL JoinModeMode
	;

JoinModeMode :
	JOIN
	| INNER JOIN
	| LEFT JOIN
	| LEFT OUTER JOIN
	| RIGHT JOIN
	| RIGHT OUTER JOIN
	| OUTER JOIN
	| FULL OUTER JOIN
	| SEMI JOIN
	| ANTI JOIN
	| CROSS JOIN
	;

OnClause :
	ON Expression
	| USING ColumnsList
	| /*empty*/
	;

WhereClause :
	/*empty*/
	| WHERE Expression
	;

GroupClause :
	/*empty*/
	| GROUP BY GroupExpressionsList HavingClause
	;

GroupExpressionsList :
	GroupExpression
	| GroupExpressionsList COMMA GroupExpression
	;

GroupExpression :
	GROUPING SET LPAR GroupExpressionsList RPAR
	| ROLLUP LPAR GroupExpressionsList RPAR
	| CUBE LPAR GroupExpressionsList RPAR
	| Expression
	;


HavingClause :
	/*empty*/
	| HAVING Expression
	;

UnionClause :
	/*empty*/
	| UNION Select
	| UNION ALL Select
	| EXCEPT Select
	| INTERSECT Select
	| UNION CORRESPONDING Select
	| UNION ALL CORRESPONDING Select
	| EXCEPT CORRESPONDING Select
	| INTERSECT CORRESPONDING Select
	;

OrderClause :
	/*empty*/
	| ORDER BY OrderExpressionsList
	;

OrderExpressionsList :
	OrderExpression
	| OrderExpressionsList COMMA OrderExpression
	;

NullsOrder :
	NULLS FIRST
	|  NULLS LAST
	;

OrderExpression :
	Expression
	| Expression DIRECTION
	| Expression DIRECTION NullsOrder
	| Expression COLLATE NOCASE
	| Expression COLLATE NOCASE DIRECTION
	;

LimitClause :
	/*empty*/
	| LIMIT NumValue OffsetClause
	| OFFSET NumValue ROWS? FETCH NEXT? NumValue ROWS? ONLY?
	;

OffsetClause :
	/*empty*/
	| OFFSET NumValue
	;


ResultColumns :
	ResultColumns COMMA ResultColumn
	| ResultColumn
	;

ResultColumn :
	Expression AS Literal
	| Expression Literal
	| Expression AS NUMBER
	| Expression NUMBER
	| Expression AS StringValue
	| Expression StringValue
	| Expression
	;

Star :
	Literal DOT Literal DOT STAR
	| Literal DOT STAR
	| STAR
	;

Column :
	Literal DOT Literal DOT Literal
	| Literal DOT Literal
	| Literal DOT VALUE
	| Literal
	;

Expression :
	AggrValue
	| FuncValue
	| Op
	| Column
	| Star
	| NumValue
	| LogicValue
	| StringValue
	| NullValue
	| ParamValue
	| VarValue
	| ExistsValue
	| CaseValue
	| CastClause
	| VALUE
	| Json
	| ArrayValue
/*	| ATLBRA JsonArray
*/	| NewClause
/*	| AT LPAR Expression RPAR
*/
/*	| AT LPAR Json RPAR
*/	| LPAR Select RPAR
	| LPAR Insert RPAR
	| LPAR (CreateVertex|CreateEdge) RPAR
	| JavaScript
	| CURRENT_TIMESTAMP
/*	| USER
*/	;

JavaScript :
	JAVASCRIPT
	;

CreateFunction :
	CREATE FUNCTION LITERAL AS JAVASCRIPT
	;

CreateAggregate :
	CREATE AGGREGATE LITERAL AS JAVASCRIPT
	;


NewClause :
	NEW Literal
	| NEW FuncValue
	;


CastClause :
	CAST LPAR Expression AS ColumnType RPAR
	| CAST LPAR Expression AS ColumnType COMMA NUMBER RPAR
	| CONVERT LPAR ColumnType COMMA Expression RPAR
	| CONVERT LPAR ColumnType COMMA Expression COMMA NUMBER RPAR
	;

PrimitiveValue :
	NumValue
	| StringValue
	| LogicValue
	| NullValue
	| ParamValue
	| FuncValue
	| CURRENT_TIMESTAMP
/*	| USER
*/	;


AggrValue :
	Aggregator LPAR ExprList RPAR OverClause
	| Aggregator LPAR DISTINCT Expression RPAR OverClause
	| Aggregator LPAR ALL Expression RPAR OverClause
	;

OverClause :
	/*empty*/
	| OVER LPAR OverPartitionClause RPAR
	| OVER LPAR OverOrderByClause RPAR
	| OVER LPAR OverPartitionClause OverOrderByClause RPAR
	;

OverPartitionClause :
	PARTITION BY GroupExpressionsList
	;

OverOrderByClause :
	ORDER BY OrderExpressionsList
	;

Aggregator :
	SUM
	| TOTAL
	| COUNT
	| MIN
	| MAX
	| AVG
	| FIRST
	| LAST
	| AGGR
	| ARRAY
/*	| REDUCE
*/
	;

FuncValue :
	Literal LPAR (DISTINCT|ALL)? ExprList RPAR
	| Literal LPAR RPAR
	| IF LPAR ExprList RPAR
	| REPLACE LPAR ExprList RPAR
	| DATEADD LPAR Literal COMMA Expression COMMA Expression RPAR
	| DATEADD LPAR STRING COMMA Expression COMMA Expression RPAR
	| DATEDIFF LPAR Literal COMMA Expression COMMA Expression RPAR
	| DATEDIFF LPAR STRING COMMA Expression COMMA Expression RPAR
	| TIMESTAMPDIFF LPAR Expression COMMA Expression COMMA Expression RPAR
	| INTERVAL Expression Literal
	;

ExprList :
	Expression
	| ExprList COMMA Expression
	;

NumValue :
	NUMBER
	;

LogicValue :
	TRUE
	| FALSE
	;

StringValue :
	STRING
	| NSTRING
	;

NullValue :
	NULL
	;

VarValue :
	AT Literal
	;

ExistsValue :
	EXISTS LPAR Select RPAR
	;

ArrayValue :
	ARRAYLBRA ExprList RBRA
	;

ParamValue :
	DOLLAR (Literal|NUMBER)
/*	| DOLLAR NUMBER
*/	| COLON Literal
	| QUESTION
	| BRAQUESTION
	;


CaseValue :
	CASE Expression WhensList ElseClause END
	| CASE WhensList ElseClause END
	;

WhensList :
	WhensList When
	| When
	;

When :
	WHEN Expression THEN Expression
	;

ElseClause :
	ELSE Expression
	| /*empty*/
	;

Op :
	Expression REGEXP Expression
	| Expression TILDA Expression
	| Expression GLOB Expression
	| Expression LIKE Expression
	| Expression LIKE Expression ESCAPE Expression
	| Expression NOT_LIKE Expression
	| Expression NOT_LIKE Expression ESCAPE Expression
	| Expression BARBAR Expression
	| Expression PLUS Expression
	| Expression MINUS Expression
	| Expression STAR Expression
	| Expression SLASH Expression
	| Expression MODULO Expression
	| Expression CARET Expression
	| Expression GTGT Expression
	| Expression LTLT Expression
	| Expression AMPERSAND Expression
	| Expression BAR Expression
	| Expression ArrowDot Literal
	| Expression ArrowDot NumValue
	| Expression ArrowDot LPAR Expression RPAR
	| Expression ArrowDot FuncValue
	| Expression EXCLAMATION Literal
	| Expression EXCLAMATION NumValue
	| Expression EXCLAMATION LPAR Expression RPAR
	| Expression EXCLAMATION FuncValue
	| Expression GT Expression
	| Expression GE Expression
	| Expression LT Expression
	| Expression LE Expression
	| Expression EQ Expression
	| Expression EQEQ Expression
	| Expression EQEQEQ Expression
	| Expression NE Expression
	| Expression NEEQEQ Expression
	| Expression NEEQEQEQ Expression
	| Expression CondOp AllSome LPAR Select RPAR
	| Expression CondOp AllSome LPAR ExprList RPAR
	| Expression AND Expression
	| Expression OR Expression
	| NOT Expression
	| MINUS Expression
	| PLUS Expression
	| TILDA Expression
	| SHARP Expression
	| LPAR Expression RPAR
	| Expression IN LPAR Select RPAR
	| Expression NOT IN LPAR Select RPAR
	| Expression IN LPAR ExprList RPAR
	| Expression NOT IN LPAR ExprList RPAR
	| Expression IN LPAR RPAR
	| Expression NOT IN LPAR RPAR
	| Expression IN ColFunc
	| Expression NOT IN ColFunc
	| Expression IN VarValue
	| Expression NOT IN VarValue
	/*
		Hack - it impossimle to parse BETWEEN AND and AND expressions with grammar.
		At least, I do not know how.
	*/
	| Expression BETWEEN Expression
	| Expression NOT_BETWEEN Expression
	| Expression IS Expression
	| Expression NOT NULL
	| Expression DOUBLECOLON ColumnType
	;

ColFunc :
	Column
	| FuncValue
	| AT LPAR Expression RPAR
	;

CondOp :
	GT
	| GE
	| LT
	| LE
	| EQ
	| NE
	;

AllSome :
	ALL
	| SOME
	| ANY
	;

/* PART TWO */

/* UPDATE */

Update :
	UPDATE Table SET SetColumnsList WHERE Expression
	| UPDATE Table SET SetColumnsList
	;

SetColumnsList :
	SetColumn
	| SetColumnsList COMMA SetColumn
	;

SetColumn :
	Column EQ Expression
/* TODO Replace columnid with column */
	| (AT|DOLLAR) Literal EQ Expression
	;

/* DELETE */

Delete :
	DELETE FROM Table WHERE Expression
	| DELETE FROM Table
	;

/* INSERT */

Insert :
	INSERT Into Table Values  ValuesListsList
        | INSERT Into Table ValuesListsList
        | INSERT OR REPLACE Into Table Values  ValuesListsList
        | INSERT OR REPLACE Into Table ValuesListsList
        | REPLACE Into Table Values  ValuesListsList
        | REPLACE Into Table ValuesListsList
        | INSERT Into Table DEFAULT Values
        | INSERT Into Table LPAR ColumnsList RPAR Values  ValuesListsList
        | INSERT Into Table LPAR ColumnsList RPAR ValuesListsList
        | INSERT Into Table Select
        | INSERT OR REPLACE Into Table Select
        | INSERT Into Table LPAR ColumnsList RPAR Select
        ;

Values :
	VALUES
        | VALUE
        ;

Into :
	/*empty*/
	| INTO
	;
/*
TableParamFunc :
	Table
	| ParamValue
	| FuncValue
	;
*/

ValuesListsList :
	LPAR ValuesList RPAR
	| Json
	| ParamValue
	| ValuesListsList COMMA LPAR ValuesList RPAR
	| ValuesListsList COMMA Json
	| ValuesListsList COMMA ParamValue
	;

ValuesList :
	Expression
	| ValuesList COMMA Expression
	;

//Value :
//	NumValue
//	| StringValue
//	| LogicValue
//	| NullValue
//	| DateValue
//	| ParamValue
//	;

ColumnsList :
	Column
	| ColumnsList COMMA Column
	;

/* CREATE TABLE */

CreateTable :
	CREATE TemporaryClause TableClass IfNotExists Table LPAR CreateTableDefClause RPAR CreateTableOptionsClause
	| CREATE TemporaryClause TableClass IfNotExists Table
	;

TableClass :
	TABLE
	| CLASS
	;

CreateTableOptionsClause :
	/*empty*/
	| CreateTableOptions
	;

CreateTableOptions :
	CreateTableOptions CreateTableOption
	| CreateTableOption
	;

/* TODO: Remove this section */
CreateTableOption :
	DEFAULT
	| LITERAL EQ Literal
	| IDENTITY EQ NumValue
	| COLLATE EQ Literal
	;

TemporaryClause :
	/*empty*/
	| TEMP
	;

IfNotExists :
	/*empty*/
	| IF NOT EXISTS
	;

CreateTableDefClause :
	ColumnDefsList COMMA ConstraintsList
	| ColumnDefsList
	| AS Select
	;

ConstraintsList :
	Constraint
	| ConstraintsList COMMA Constraint
	;

Constraint :
	ConstraintName PrimaryKey
	| ConstraintName ForeignKey
	| ConstraintName UniqueKey
	| ConstraintName IndexKey
	| ConstraintName Check
	;

ConstraintName :
	/*empty*/
	| CONSTRAINT Literal
	;

Check :
	CHECK LPAR Expression RPAR
	;

PrimaryKey :
	PRIMARY KEY Literal? LPAR ColsList RPAR
	;

ForeignKey :
	FOREIGN KEY LPAR ColsList RPAR REFERENCES Table ParColsList?
	     OnForeignKeyClause
	;

ParColsList :
	LPAR ColsList RPAR
	;

OnForeignKeyClause :
	/*empty*/
	| OnDeleteClause OnUpdateClause
	;

OnDeleteClause :
	ON DELETE NO ACTION
	;

OnUpdateClause :
	ON UPDATE NO ACTION
	;

UniqueKey :
	UNIQUE KEY? Literal? LPAR ColumnsList RPAR
	;

IndexKey :
	INDEX Literal LPAR ColumnsList RPAR
	| KEY Literal LPAR ColumnsList RPAR
	;

ColsList :
	Literal
	| STRING
	| ColsList COMMA Literal
	| ColsList COMMA STRING
	;

/*
OrderedColsList :
	Literal
	| STRING
	| OrderedColsList COMMA Literal
	| OrderedColsList COMMA STRING
	;
*/
ColumnDefsList :
	ColumnDef
	| ColumnDefsList COMMA ColumnDef
	;

ColumnDef :
	Literal ColumnType ColumnConstraintsClause
//	| Literal ColumnConstraints
	| Literal
	;

/*
ColumnType :
	LITERAL LPAR NumberMax COMMA NUMBER RPAR
	| LITERAL LPAR NumberMax RPAR
	| LITERAL
	| ENUM LPAR ValuesList RPAR
	;
*/
SingularColumnType :
	LiteralWithSpaces LPAR NumberMax COMMA NUMBER RPAR
	| LiteralWithSpaces LPAR NumberMax RPAR
	| LiteralWithSpaces
	| ENUM LPAR ValuesList RPAR
	;

ColumnType :
	SingularColumnType BRALITERAL /* text[] */
	| SingularColumnType
	;


NumberMax :
	NUMBER
	| MAXNUM
	;

ColumnConstraintsClause :
	/*empty*/
	| ColumnConstraintsList
	;


ColumnConstraintsList :
	ColumnConstraintsList ColumnConstraint
	| ColumnConstraint
	;

ParLiteral :
	LPAR Literal RPAR
	;

ColumnConstraint :
	PRIMARY KEY
	| FOREIGN KEY REFERENCES Table ParLiteral?
	| REFERENCES Table ParLiteral?
	| IDENTITY LPAR NumValue COMMA NumValue RPAR
	| IDENTITY
	| DEFAULT PrimitiveValue
	| DEFAULT LPAR Expression RPAR
	| DEFAULT FuncValue
	| NULL
	| NOT NULL
	| Check
	| UNIQUE
	| ON UPDATE PrimitiveValue
	| ON UPDATE LPAR Expression RPAR
	;

/* DROP TABLE */

DropTable :
	DROP (TABLE|CLASS) IfExists TablesList
	;

TablesList :
	TablesList COMMA Table
	| Table
	;


IfExists :
	/*empty*/
	| IF EXISTS
	;

/* ALTER TABLE */

AlterTable :
	ALTER TABLE Table RENAME TO Literal
	| ALTER TABLE Table ADD COLUMN ColumnDef
	| ALTER TABLE Table MODIFY COLUMN ColumnDef
	| ALTER TABLE Table RENAME COLUMN Literal TO Literal
	| ALTER TABLE Table DROP COLUMN Literal
	;

RenameTable :
	RENAME TABLE Table TO Literal
	;

/* DATABASES */

AttachDatabase :
	ATTACH Literal DATABASE Literal
	| ATTACH Literal DATABASE Literal LPAR ExprList RPAR
	| ATTACH Literal DATABASE Literal AS Literal
	| ATTACH Literal DATABASE Literal LPAR ExprList RPAR AS Literal
	;

DetachDatabase :
	DETACH DATABASE Literal
	;

CreateDatabase :
	CREATE DATABASE IfNotExists Literal
	| CREATE Literal DATABASE IfNotExists Literal AsClause
	| CREATE Literal DATABASE IfNotExists Literal LPAR ExprList RPAR AsClause
	| CREATE Literal DATABASE IfNotExists StringValue AsClause

	;

AsClause :
	/*empty*/
	| AS Literal
	;

UseDatabase :
	USE DATABASE Literal
	| USE Literal
	;

DropDatabase :
	DROP DATABASE IfExists Literal
	| DROP Literal DATABASE IfExists Literal
	| DROP Literal DATABASE IfExists StringValue
	;

/* INDEXES */

CreateIndex :
	CREATE INDEX Literal ON Table LPAR OrderExpressionsList RPAR
	| CREATE UNIQUE INDEX Literal ON Table LPAR OrderExpressionsList RPAR
	;

DropIndex :
	DROP INDEX Literal
	;

/* SHOW COMMAND */

ShowDatabases :
	SHOW DATABASE
	| SHOW DATABASE LIKE StringValue
	| SHOW Literal DATABASE
	| SHOW Literal DATABASE LIKE StringValue
	;

ShowTables :
	SHOW TABLE
	| SHOW TABLE LIKE StringValue
	| SHOW TABLE FROM Literal
	| SHOW TABLE FROM Literal LIKE StringValue
	;

ShowColumns :
	SHOW COLUMN FROM Table
	| SHOW COLUMN FROM Table FROM Literal
	;

ShowIndex :
	SHOW INDEX FROM Table
	| SHOW INDEX FROM Table FROM Literal
	;

ShowCreateTable :
	SHOW CREATE TABLE Table
	| SHOW CREATE TABLE Table FROM Literal
	;

CreateView :
	CREATE TemporaryClause VIEW IfNotExists Table LPAR ColumnsList RPAR AS Select SubqueryRestriction?
	| CREATE TemporaryClause VIEW IfNotExists Table AS Select SubqueryRestriction?
	;

SubqueryRestriction :
	WITH READ ONLY
	| WITH CHECK OPTION
	| WITH CHECK OPTION CONSTRAINT Constraint
	;


DropView :
	DROP VIEW IfExists TablesList
	;
/*
DeclareCursor :
	DECLARE Literal CURSOR FOR Select
	;

OpenCursor :
	OPEN Literal
	;

CloseCursor :
	CLOSE Literal
	;

FetchCursor :
	FETCH FetchDirection FROM Literal
	;

FetchDirection :
	NEXT
	| PRIOR
	| FIRST
	| LAST
	| ABSOLUTE NumValue
	| RELATIVE NumValue
	;
*/

/*
Help :
	HELP StringValue
	| HELP
	;
*/

ExpressionStatement :
	EQ Expression
	;

Source :
	SOURCE StringValue
	;

Assert :
	ASSERT Json
	| ASSERT PrimitiveValue
	| ASSERT STRING COMMA Json
	;

Json :
	AT LPAR Expression RPAR
	| AT StringValue
	| AT NumValue
	| AT LogicValue
	| AT ParamValue
	| JsonObject
	| AT JsonObject
	| ATLBRA JsonArray
	;

JsonValue :
	Json
	| JsonPrimitiveValue
	;

JsonPrimitiveValue :
	NumValue
	| StringValue
	| LogicValue
	| Column
	| NullValue
	| ParamValue
	| FuncValue
	| LPAR Expression RPAR
	;


JsonObject :
	LCUR JsonPropertiesList RCUR
	| LCUR JsonPropertiesList COMMA RCUR
	| LCUR RCUR
	;

JsonArray :
	JsonElementsList RBRA
	| JsonElementsList COMMA RBRA
	| RBRA
	;

JsonPropertiesList :
	JsonPropertiesList COMMA JsonProperty
	| JsonProperty
	;

JsonProperty :
	STRING COLON JsonValue
	| NUMBER COLON JsonValue
	| Literal COLON JsonValue
/*	| STRING COLON ParamValue
	| NUMBER COLON ParamValue
	| LITERAL COLON ParamValue
*/	;

JsonElementsList :
	JsonElementsList COMMA JsonValue
	| JsonValue
	;

SetVariable :
	SET Literal EQ OnOff
	| SET Literal OnOff
	| SET Literal EQ Expression
	| SET Literal SetPropsList EQ Expression
	| SET AtDollar Literal EQ Expression
	| SET AtDollar Literal SetPropsList EQ Expression
	;

AtDollar :
	AT
	| DOLLAR
	;

SetPropsList :
	SetPropsList ArrowDot SetProp
	| ArrowDot SetProp
	;

SetProp :
	Literal
	| NUMBER
	| LPAR Expression RPAR
	;

OnOff :
	ON
	| OFF
	;

CommitTransaction :
	COMMIT TRANSACTION
	;

RollbackTransaction :
	ROLLBACK TRANSACTION
	;

BeginTransaction :
	BEGIN TRANSACTION
	;

/*
Store :
	STORE
	| STORE Literal
	;

Restore :
	RESTORE
	| RESTORE Literal
	;
*/

If :
/*	IF Expression AStatement
	|
*/
	IF Expression AStatement ElseStatement
	| IF Expression AStatement
	;

ElseStatement :
	ELSE AStatement
	;

While :
	WHILE Expression AStatement
	;

Continue :
	CONTINUE
	;

Break :
	BREAK
	;

BeginEnd :
	BEGIN Statements END
	;

Print :
	PRINT ExprList
	| PRINT Select
	;

Require :
	REQUIRE StringValuesList
	| REQUIRE PluginsList
	;

/* For test plugin system */

Plugin :
	ECHO
	| Literal
	;

Echo :
	ECHO Expression
	;


StringValuesList :
	StringValuesList COMMA StringValue
	| StringValue
	;

PluginsList :
	PluginsList COMMA Plugin
	| Plugin
	;


Declare :
	DECLARE DeclaresList
	;

DeclaresList :
	DeclareItem
	| DeclaresList COMMA DeclareItem
	;

DeclareItem :
	AT Literal ColumnType
	| AT Literal AS ColumnType
	| AT Literal ColumnType EQ Expression
	| AT Literal AS ColumnType EQ Expression
	;

TruncateTable :
	TRUNCATE TABLE Table
	;

Merge :
	MERGE MergeInto MergeUsing MergeOn MergeMatchedList OutputClause
	;

MergeInto :
	FromTable
	| INTO FromTable
	;

MergeUsing :
	USING FromTable
	;

MergeOn :
	ON Expression
	;

MergeMatchedList :
	MergeMatchedList MergeMatched
	| MergeMatchedList MergeNotMatched
	| MergeMatched
	| MergeNotMatched
	;

MergeMatched :
	WHEN MATCHED THEN MergeMatchedAction
	| WHEN MATCHED AND Expression THEN MergeMatchedAction
	;

MergeMatchedAction :
	DELETE
	| UPDATE SET SetColumnsList
	;

MergeNotMatched :
	WHEN NOT MATCHED THEN MergeNotMatchedAction
	| WHEN NOT MATCHED BY TARGET THEN MergeNotMatchedAction
	| WHEN NOT MATCHED AND Expression THEN MergeNotMatchedAction
	| WHEN NOT MATCHED BY TARGET AND Expression THEN MergeNotMatchedAction
	| WHEN NOT MATCHED BY SOURCE THEN MergeNotMatchedAction
	| WHEN NOT MATCHED BY SOURCE AND Expression THEN MergeMatchedAction
	;

MergeNotMatchedAction :
	INSERT VALUES ValuesListsList
	| INSERT LPAR ColumnsList RPAR VALUES ValuesListsList
	| INSERT DEFAULT VALUES
	| INSERT LPAR ColumnsList RPAR DEFAULT VALUES
	;

OutputClause :
	/*empty*/
	| OUTPUT ResultColumns
	| OUTPUT ResultColumns INTO AtDollar Literal
	| OUTPUT ResultColumns INTO Table
	| OUTPUT ResultColumns INTO Table LPAR ColumnsList RPAR
	;

/*
CreateVertex :
	CREATE VERTEX
	| CREATE VERTEX SET SetColumnsList
	| CREATE VERTEX Literal SET SetColumnsList
	| CREATE VERTEX CONTENT ExprList
	| CREATE VERTEX Literal CONTENT ExprList
	| CREATE VERTEX Literal Select
	| CREATE VERTEX Select
	;
*/
CreateVertex :
	CREATE VERTEX Literal? SharpValue? StringValue? CreateVertexSet
	;

SharpValue :
	SHARP Literal
	;

CreateVertexSet :
	/*empty*/
	| SET SetColumnsList
	| CONTENT ExprList
	| Select
	;

CreateEdge :
	CREATE EDGE StringValue? FROM Expression TO Expression CreateVertexSet
/*	| CREATE EDGE StringValue? FROM Expression TO Expression
*/	;


/*
CreateEdge :
	CREATE EDGE Literal?
	FROM Expression
	TO Expression
	(SET SetColumnsList | CONTENT Expression)?
	;
*/

CreateGraph :
	CREATE GRAPH GraphList
	| CREATE GRAPH FROM Expression
	;

GraphList :
	GraphList COMMA GraphVertexEdge
	| GraphVertexEdge
	;

GraphVertexEdge :
	GraphElement Json? GraphAsClause?
	| GraphElementVar GT GraphElement Json? GraphAsClause? GT GraphElementVar
	| GraphElementVar GT Json GraphAsClause? GT GraphElementVar
	| GraphElementVar GTGT GraphElementVar
	| Literal LPAR GraphList RPAR
	;

GraphElementVar :
	GraphElement
	| GraphVar
	;

GraphVar :
	AtDollar Literal
	;

GraphAsClause :
	AS AtDollar Literal
	;

//GraphAtClause :
//	AtDollar Literal
//	;

//GraphElement2 :
//	Literal? SharpLiteral? STRING? ColonLiteral?
//	;

GraphElement :
	Literal SharpLiteral? STRING? ColonLiteral?
	|  SharpLiteral STRING? ColonLiteral?
	|  STRING ColonLiteral?
	|  ColonLiteral
	;



ColonLiteral :
	COLON Literal
	;

SharpLiteral :
	SHARP Literal
	| SHARP NUMBER
	;

//DeleteVertex :
//	DELETE VERTEX Expression (WHERE Expression)?
//	;

//DeleteEdge :
//	DELETE EDGE Expression (FROM Expression)? (TO Expression)? (WHERE Expression)?
//	;

AddRule :
	Term COLONDASH TermsList
	| COLONDASH TermsList
	;

TermsList :
	TermsList COMMA Term
	| Term
	;

Term :
	Literal
	| Literal LPAR TermsList RPAR
	;

Query :
	QUESTIONDASH FuncValue
	;

Call :
	CALL FuncValue
	;

CreateTrigger :
	CREATE TRIGGER Literal BeforeAfter InsertDeleteUpdate ON Table AS? AStatement
	| CREATE TRIGGER Literal BeforeAfter InsertDeleteUpdate ON Table Literal
	| CREATE TRIGGER Literal ON Table BeforeAfter InsertDeleteUpdate AS? AStatement
	;

BeforeAfter :
	/*empty*/
	| FOR
	| BEFORE
	| AFTER
	| INSTEAD OF
	;

InsertDeleteUpdate :
	INSERT
	| DELETE
	| UPDATE
	;

DropTrigger :
	DROP TRIGGER Literal
	;

Reindex :
	REINDEX Literal
	;

//NonReserved :
//	A
//	| ABSENT
//	| ABSOLUTE
//	| ACCORDING
//	| ACTION
//	| ADA
//	| ADD
//	| ADMIN
//	| AFTER
//	| ALWAYS
//	| ASC
//	| ASSERTION
//	| ASSIGNMENT
//	| ATTRIBUTE
//	| ATTRIBUTES
//	| BASE64
//	| BEFORE
//	| BERNOULLI
//	| BLOCKED
//	| BOM
//	| BREADTH
//	| C
//	| CASCADE
//	| CATALOG
//	| CATALOG_NAME
//	| CHAIN
//	| CHARACTERISTICS
//	| CHARACTERS
//	| CHARACTER_SET_CATALOG
//	| CHARACTER_SET_NAME
//	| CHARACTER_SET_SCHEMA
//	| CLASS_ORIGIN
//	| COBOL
//	| COLLATION
//	| COLLATION_CATALOG
//	| COLLATION_NAME
//	| COLLATION_SCHEMA
//	| COLUMNS
//	| COLUMN_NAME
//	| COMMAND_FUNCTION
//	| COMMAND_FUNCTION_CODE
//	| COMMITTED
//	| CONDITION_NUMBER
//	| CONNECTION
//	| CONNECTION_NAME
//	| CONSTRAINTS
//	| CONSTRAINT_CATALOG
//	| CONSTRAINT_NAME
//	| CONSTRAINT_SCHEMA
//	| CONSTRUCTOR
//	| CONTENT
//	| CONTINUE
//	| CONTROL
//	| CURSOR_NAME
//	| DATA
//	| DATETIME_INTERVAL_CODE
//	| DATETIME_INTERVAL_PRECISION
//	| DB
//	| DEFAULTS
//	| DEFERRABLE
//	| DEFERRED
//	| DEFINED
//	| DEFINER
//	| DEGREE
//	| DEPTH
//	| DERIVED
//	| DESC
//	| DESCRIPTOR
//	| DIAGNOSTICS
//	| DISPATCH
//	| DOCUMENT
//	| DOMAIN
//	| DYNAMIC_FUNCTION
//	| DYNAMIC_FUNCTION_CODE
//	| EMPTY
//	| ENCODING
//	| ENFORCED
//	| EXCLUDE
//	| EXCLUDING
//	| EXPRESSION
//	| FILE
//	| FINAL
//	| FIRST
//	| FLAG
//	| FOLLOWING
//	| FORTRAN
//	| FOUND
//	| FS
//	| G
//	| GENERAL
//	| GENERATED
//	| GO
//	| GOTO
//	| GRANTED
//	| HEX
//	| HIERARCHY
//	| ID
//	| IGNORE
//	| IMMEDIATE
//	| IMMEDIATELY
//	| IMPLEMENTATION
//	| INCLUDING
//	| INCREMENT
//	| INDENT
//	| INITIALLY
//	| INPUT
//	| INSTANCE
//	| INSTANTIABLE
//	| INSTEAD
//	| INTEGRITY
//	| INVOKER
//	| ISOLATION
//	| K
//	| KEY
//	| KEY_MEMBER
//	| KEY_TYPE
//	| LAST
//	| LENGTH
//	| LEVEL
//	| LIBRARY
//	| LIMIT
//	| LINK
//	| LOCATION
//	| LOCATOR
//	| M
//	| MAP
//	| MAPPING
//	| MATCHED
//	| MAXVALUE
//	| MESSAGE_LENGTH
//	| MESSAGE_OCTET_LENGTH
//	| MESSAGE_TEXT
//	| MINVALUE
//	| MORE
//	| MUMPS
//	| NAME
//	| NAMES
//	| NAMESPACE
//	| NESTING
//	| NEXT
//	| NFC
//	| NFD
//	| NFKC
//	| NFKD
//	| NIL
//	| NORMALIZED
//	| NULLABLE
//	| NULLS
//	| NUMBER
//	| OBJECT
//	| OCTETS
//	| OFF
//	| OPTION
//	| OPTIONS
//	| ORDERING
//	| ORDINALITY
//	| OTHERS
//	| OUTPUT
//	| OVERRIDING
//	| P
//	| PAD
//	| PARAMETER_MODE
//	| PARAMETER_NAME
//	| PARAMETER_ORDINAL_POSITION
//	| PARAMETER_SPECIFIC_CATALOG
//	| PARAMETER_SPECIFIC_NAME
//	| PARAMETER_SPECIFIC_SCHEMA
//	| PARTIAL
//	| PASCAL
//	| PASSING
//	| PASSTHROUGH
//	| PATH
//	| PERMISSION
//	| PLACING
//	| PLI
//	| PRECEDING
//	| PRESERVE
//	| PRIOR
//	| PRIVILEGES
//	| PUBLIC
//	| READ
//	| RECOVERY
//	| RELATIVE
//	| REPEATABLE
//	| REQUIRING
//	| RESPECT
//	| RESTART
//	| RESTORE
//	| RESTRICT
//	| RETURNED_CARDINALITY
//	| RETURNED_LENGTH
//	| RETURNED_OCTET_LENGTH
//	| RETURNED_SQLSTATE
//	| RETURNING
//	| ROLE
//	| ROUTINE
//	| ROUTINE_CATALOG
//	| ROUTINE_NAME
//	| ROUTINE_SCHEMA
//	| ROW_COUNT
//	| SCALE
//	| SCHEMA
//	| SCHEMA_NAME
//	| SCOPE_CATALOG
//	| SCOPE_NAME
//	| SCOPE_SCHEMA
//	| SECTION
//	| SECURITY
//	| SELECTIVE
//	| SELF
//	| SEQUENCE
//	| SERIALIZABLE
//	| SERVER
//	| SERVER_NAME
//	| SESSION
//	| SETS
//	| SIMPLE
//	| SIZE
//	| SOURCE
//	| SPACE
//	| SPECIFIC_NAME
//	| STANDALONE
//	| STATE
//	| STATEMENT
//	| STRIP
//	| STRUCTURE
//	| STYLE
//	| SUBCLASS_ORIGIN
//	| T
//	| TABLE_NAME
//	| TEMPORARY
//	| TIES
//	| TOKEN
//	| TOP_LEVEL_COUNT
//	| TRANSACTION
//	| TRANSACTIONS_COMMITTED
//	| TRANSACTIONS_ROLLED_BACK
//	| TRANSACTION_ACTIVE
//	| TRANSFORM
//	| TRANSFORMS
//	| TRIGGER_CATALOG
//	| TRIGGER_NAME
//	| TRIGGER_SCHEMA
//	| TYPE
//	| UNBOUNDED
//	| UNCOMMITTED
//	| UNDER
//	| UNLINK
//	| UNNAMED
//	| UNTYPED
//	| URI
//	| USAGE
//	| USER_DEFINED_TYPE_CATALOG
//	| USER_DEFINED_TYPE_CODE
//	| USER_DEFINED_TYPE_NAME
//	| USER_DEFINED_TYPE_SCHEMA
//	| VALID
//	| VERSION
//	| VIEW
//	| WHITESPACE
//	| WORK
//	| WRAPPER
//	| WRITE
//	| XMLDECLARATION
//	| XMLSCHEMA
//	| YES
//	| ZONE
//	;

%%

%option caseless

%%

/*
\$\$(.+?)\$\$	DOLLARSTRING
*/

\`\`([^\`])+\`\`						JAVASCRIPT
\[\?\]									BRAQUESTION
"@["									ATLBRA
"ARRAY["								ARRAYLBRA
\[([^\]'])*?\]							BRALITERAL
\`([^\`'])*?\`	   						BRALITERAL

N(['](\\.|[^']|\\\')*?['])+             NSTRING
X(['](\\.|[^']|\\\')*?['])+             NSTRING
(['](\\.|[^']|\\\')*?['])+              STRING
(["](\\.|[^"]|\\\")*?["])+              STRING


"--".*			skip()
"/*"(?s:.)*?"*/"	skip()

\s+                                            skip()
"||"											BARBAR
"|"												BAR
/* "&&"											AMPERSANDAMPERSAND */

VALUE\s+OF\s+SEARCH                          	SEARCH
VALUE\s+OF\s+SELECT                          	SELECT
ROW\s+OF\s+SELECT                           	SELECT
COLUMN\s+OF\s+SELECT                          	SELECT
MATRIX\s+OF\s+SELECT                          	SELECT
INDEX\s+OF\s+SELECT                           	SELECT
RECORDSET\s+OF\s+SELECT                       	SELECT
TEXT\s+OF\s+SELECT                           	SELECT

"SELECT"                           				SELECT

//"ABSOLUTE"                                 		ABSOLUTE
"ACTION"                                      	ACTION
"ADD"                                      		ADD
"AFTER"                                      	AFTER
"AGGR"                                     		AGGR
"AGGREGATE"                                     AGGREGATE
"AGGREGATOR"                                    AGGREGATE
"ALL"                                      		ALL
"ALTER"                                    		ALTER
"AND"											AND
"ANTI"											ANTI
"ANY"											ANY
"APPLY"											APPLY
"ARRAY"                                     	ARRAY
"AS"                                      		AS
"ASSERT"                                      	ASSERT
"ASC"                                      		DIRECTION
"ATTACH"                                      	ATTACH
AUTO(_)?INCREMENT                               IDENTITY
"AVG"                                      		AVG

"BEFORE"                                      	BEFORE
"BEGIN"											BEGIN
"BETWEEN"										BETWEEN
"BREAK"											BREAK
NOT\s+BETWEEN									NOT_BETWEEN
NOT\s+LIKE									    NOT_LIKE
"BY"											BY

/* Postgres aliases */
"~~*"											LIKE
"!~~*"											NOT_LIKE
"~~"											LIKE
"!~~"											NOT_LIKE
ILIKE											LIKE
NOT\s+ILIKE										NOT_LIKE

"CALL"											CALL
"CASE"											CASE
"CAST"											CAST
"CHECK"											CHECK
"CLASS"											CLASS
//"CLOSE"											CLOSE
"COLLATE"										COLLATE
COLUMN											COLUMN
COLUMNS 										COLUMN
"COMMIT"										COMMIT
"CONSTRAINT"									CONSTRAINT
"CONTENT"										CONTENT
"CONTINUE"										CONTINUE
"CONVERT"										CONVERT
"CORRESPONDING"									CORRESPONDING
"COUNT"											COUNT
"CREATE"										CREATE
"CROSS"											CROSS
"CUBE"											CUBE
"CURRENT_TIMESTAMP"								CURRENT_TIMESTAMP
//"CURSOR"										CURSOR
DATABASE(S)?									DATABASE
"DATEADD"                                       DATEADD
"DATEDIFF"                                      DATEDIFF
"TIMESTAMPDIFF"                                      TIMESTAMPDIFF
"DECLARE"                                       DECLARE
"DEFAULT"                                       DEFAULT
"DELETE"                                        DELETE
//"DELETED"                                       DELETED
"DESC"                                          DIRECTION
"DETACH"										DETACH
"DISTINCT"                                      DISTINCT
/* DOUBLE\s+PRECISION								LITERAL */
"DROP"											DROP
"ECHO"											ECHO
"EDGE"											EDGE
"END"											END
"ENUM"											ENUM
"ELSE"											ELSE
"ESCAPE"										ESCAPE
"EXCEPT"										EXCEPT
"EXEC"											CALL
"EXECUTE"										CALL
"EXISTS"										EXISTS
"EXPLAIN"                                       EXPLAIN
"FALSE"											FALSE
"FETCH"											FETCH
"FIRST"											FIRST
"FOR"											FOR
"FOREIGN"										FOREIGN
"FROM"                                          FROM
"FULL"											FULL
"FUNCTION"										FUNCTION
"GLOB"                                     		GLOB
"GO"                                      		GO
"GRAPH"                                      	GRAPH
"GROUP"                                      	GROUP
"GROUPING"                                     	GROUPING
"HAVING"                                        HAVING
/*"HELP"											HELP*/
"IF"											IF
"IDENTITY"										IDENTITY
"IS"											IS
"IN"											IN
"INDEX"											INDEX
"INDEXED"										INDEXED
"INNER"                                         INNER
"INSTEAD"                                       INSTEAD
"INSERT"                                        INSERT
"INSERTED"                                      INSERTED
"INTERSECT"                                     INTERSECT
"INTERVAL"                                      INTERVAL
"INTO"                                         	INTO
"JOIN"                                         	JOIN
"KEY"											KEY
"LAST"											LAST
//"LET"											LET
"LEFT"											LEFT
"LIKE"											LIKE
"LIMIT"											LIMIT
"MATCHED"										MATCHED
"MATRIX"										MATRIX

/*"MAX"											MAX*/
/*"MIN"											MIN*/

/*
MAX(\s+)?/'('									MAX
MAX(\s+)?/(','|')')							MAXNUM
MIN(\s+)?/'('									MIN
*/
MAX									MAX
MAXNUM___							MAXNUM
MIN									MIN


"MERGE"											MERGE
"MINUS"											EXCEPT
"MODIFY"										MODIFY
"NATURAL"										NATURAL
"NEXT"											NEXT
"NEW"											NEW
"NOCASE"										NOCASE
"NO"											NO
"NOT"											NOT
"NULL"											NULL
"NULLS"											NULLS
"OFF"											OFF
"ON"											ON
"ONLY"											ONLY
"OF"											OF
"OFFSET"										OFFSET
//"OPEN"											OPEN
"OPTION"										OPTION
"OR"											OR
"ORDER"	                                      	ORDER
"OUTER"											OUTER
"OVER"											OVER
"PATH"                                        	PATH
"PARTITION"										PARTITION
"PERCENT"                                       PERCENT
"PIVOT"                                        	PIVOT
"PLAN"                                        	PLAN
"PRIMARY"										PRIMARY
"PRINT"                                        	PRINT
//"PRIOR"                                        	PRIOR
"QUERY"                                        	QUERY
"READ"		                                    READ
"RECORDSET"                                     RECORDSET
//"REDUCE"                                        REDUCE
"REFERENCES"                                    REFERENCES
"REGEXP"		                                REGEXP
"REINDEX"		                                REINDEX
//"RELATIVE"                                      RELATIVE
"REMOVE"                                        REMOVE
"RENAME"                                        RENAME
"REPEAT"										REPEAT
"REPLACE"										REPLACE
"REQUIRE"                                       REQUIRE
//"RESTORE"                                       RESTORE
"RETURN"                                       	RETURN
"RETURNS"                                       RETURN
"RIGHT"                                        	RIGHT
"ROLLBACK"										ROLLBACK
"ROLLUP"										ROLLUP
"ROW"											ROW
"ROWS"											ROWS
SCHEMA(S)?                                      DATABASE
"SEARCH"                                        SEARCH

"SEMI"                                        	SEMI
SET 	                                       	SET
SETS                                        	SET
"SHOW"                                        	SHOW
"SOME"                                        	SOME
"SOURCE"										SOURCE
//"STRATEGY"										STRATEGY
//"STORE"                                        	STORE
"SUM"											SUM
"TOTAL"											TOTAL
"TABLE"											TABLE
"TABLES"										TABLE
"TARGET"										TARGET
"TEMP"											TEMP
"TEMPORARY"										TEMP
"TEXTSTRING"									TEXTSTRING
"THEN"											THEN
//"TIMEOUT"										TIMEOUT
"TO"											TO
"TOP"											TOP
"TRAN"											TRANSACTION
"TRANSACTION"									TRANSACTION
"TRIGGER"										TRIGGER
"TRUE"						  					TRUE
"TRUNCATE"					  					TRUNCATE
"UNION"                                         UNION
"UNIQUE"                                        UNIQUE
"UNPIVOT"                                       UNPIVOT
"UPDATE"                                        UPDATE
"USE"											USE
/* "USER"										USER */
"USING"                                         USING
"VALUE"                                      	VALUE
"VALUES"                                      	VALUES
"VERTEX"										VERTEX
"VIEW"											VIEW
"WHEN"                                          WHEN
"WHERE"                                         WHERE
"WHILE"                                         WHILE
"WITH"                                          WITH
"WORK"                                          TRANSACTION  /* Is this keyword required? */


(\d*[.])?\d+[eE]\d+								NUMBER
(\d*[.])?\d+									NUMBER

"->"											ARROW
"#"												SHARP
"+"												PLUS
"-" 											MINUS
"*"												STAR
"/"												SLASH
"%"												MODULO
"!==="											NEEQEQEQ
"==="											EQEQEQ
"!=="											NEEQEQ
"=="											EQEQ
">="											GE
"&"												AMPERSAND
"|"												BAR
"<<"											LTLT
">>"											GTGT
">"												GT
"<="											LE
"<>"											NE
"<"												LT
"="												EQ
"!="											NE
"("												LPAR
")"												RPAR
"@"												AT
"{"												LCUR
"}"												RCUR

"]"												RBRA

":-"											COLONDASH
"?-"											QUESTIONDASH
".."											DOTDOT
"."												DOT
","												COMMA
"::"											DOUBLECOLON
":"												COLON
";"												SEMICOLON
"$"												DOLLAR
"?"												QUESTION
"!"												EXCLAMATION
"^"												CARET
"~"												TILDA

OUTPUT	OUTPUT


[0-9]*[a-zA-Z_]+[a-zA-Z_0-9]* 					LITERAL
//<<EOF>>               							EOF
//.												INVALID

%%
