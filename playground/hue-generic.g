//From: https://github.com/cloudera/hue/blob/b82b3880b0049e17de84c8b533a6923e124581eb/desktop/core/src/desktop/js/parse/sql/generic/jison/sql_main.jison
// Licensed to Cloudera, Inc. under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  Cloudera, Inc. licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//#file	syntax_header.jison

%token ARRAY MAP STRUCT BETWEEN_AND
%token BACKTICKEDIDENTIFIER SINGLEQUOTEDVALUE DOUBLEQUOTEDVALUE

%token ALL
%token ALTER
%token ANALYTIC
%token AND
%token ARITHMETIC_OPERATOR
%token AS
%token ASC
%token AVG
%token BETWEEN
%token BIGINT
%token BOOLEAN
%token BY
%token CASCADE
%token CASE
%token CAST
%token CHAR
%token COMMENT
%token COMPARISON_OPERATOR
%token COUNT
%token CREATE
%token CROSS
%token CURRENT
%token DATABASE
%token DECIMAL
%token DESC
%token DISTINCT
%token DOUBLE
%token DROP
%token ELSE
%token END
%token EXISTS
%token FALSE
%token FLOAT
%token FOLLOWING
%token FROM
%token FULL
%token GROUP
%token HAVING
%token IF
%token IN
%token INNER
%token INSERT
%token INT
%token INTO
%token IS
%token JOIN
%token LEFT
%token LIKE
%token LIMIT
%token MAX
%token MIN
%token NOT
%token NULL
%token ON
%token OPTION
%token OR
%token ORDER
%token OUTER
%token OVER
%token PARTITION
%token PRECEDING
%token PURGE
%token RANGE
%token REGEXP
%token REGULAR_IDENTIFIER
%token RIGHT
%token RLIKE
%token ROLE
%token ROW
%token ROWS
%token SCHEMA
%token SELECT
%token SEMI
%token SET
//%token SHOW
%token SMALLINT
%token STDDEV_POP
%token STDDEV_SAMP
%token STRING
%token SUM
%token TABLE
%token THEN
%token TIMESTAMP
%token TINYINT
//%token TO
%token TRUE
%token TRUNCATE
%token UNBOUNDED
%token UNION
%token UNSIGNED_INTEGER
%token UNSIGNED_INTEGER_E
%token UPDATE
%token USE
//%token VALUE
%token VALUES
%token VARCHAR
%token VARIABLE_REFERENCE
%token VARIANCE
%token VAR_POP
%token VAR_SAMP
%token VIEW
%token WHEN
%token WHERE
%token WITH

%left AND OR
%left BETWEEN
%left NOT '!' '~'
%left '=' '<' '>' COMPARISON_OPERATOR
%left '-' '*' '+' ARITHMETIC_OPERATOR

%left ';' ','
%nonassoc IN IS LIKE RLIKE REGEXP EXISTS NEGATION

%start SqlSyntax

%%


//#file	alter/alter_common.jison



///DataDefinition_EDIT
///	: ALTER CURSOR
///	;


//#file	alter/alter_table.jison



DataDefinition
	: AlterTable
	;

///DataDefinition_EDIT
///	: AlterTable_EDIT
///	;

AlterTable
	: AlterTableLeftSide PartitionSpec
	;

///AlterTable_EDIT
///	: AlterTableLeftSide_EDIT
///	| AlterTableLeftSide_EDIT PartitionSpec
///	| AlterTableLeftSide CURSOR
///	| AlterTableLeftSide PartitionSpec CURSOR
///	;

AlterTableLeftSide
	: ALTER TABLE SchemaQualifiedTableIdentifier
	;

///AlterTableLeftSide_EDIT
///	: ALTER TABLE SchemaQualifiedTableIdentifier_EDIT
///	| ALTER TABLE CURSOR
///	;


//#file	alter/alter_view.jison



DataDefinition
	: AlterView
	;

///DataDefinition_EDIT
///	: AlterView_EDIT
///	;

AlterView
	: AlterViewLeftSide AS QuerySpecification
	;

///AlterView_EDIT
///	: AlterViewLeftSide_EDIT
///	| AlterViewLeftSide CURSOR
///	| AlterViewLeftSide SET CURSOR
///	| AlterViewLeftSide AS CURSOR
///	| AlterViewLeftSide AS QuerySpecification_EDIT
///	;


AlterViewLeftSide
	: ALTER VIEW SchemaQualifiedTableIdentifier
	;

///AlterViewLeftSide_EDIT
///	: ALTER VIEW SchemaQualifiedTableIdentifier_EDIT
///	| ALTER VIEW CURSOR
///	;


//#file	create/create_common.jison



///DataDefinition_EDIT
///	: CREATE CURSOR
///	;

OptionalComment
	: /*empty*/
	| Comment
	;

Comment
	: COMMENT QuotedValue
	;

///OptionalComment_INVALID
///	: Comment_INVALID
///	;

///Comment_INVALID
///	: COMMENT SINGLE_QUOTE
///	| COMMENT DOUBLE_QUOTE
///	| COMMENT SINGLE_QUOTE VALUE
///	| COMMENT DOUBLE_QUOTE VALUE
///	;


//#file	create/create_database.jison



DataDefinition
	: DatabaseDefinition
	;

///DataDefinition_EDIT
///	: DatabaseDefinition_EDIT
///	;

DatabaseDefinition
	: CREATE DatabaseOrSchema OptionalIfNotExists
	| CREATE DatabaseOrSchema OptionalIfNotExists RegularIdentifier DatabaseDefinitionOptionals
	;

///DatabaseDefinition_EDIT
///	: CREATE DatabaseOrSchema OptionalIfNotExists CURSOR
///	| CREATE DatabaseOrSchema OptionalIfNotExists_EDIT
///	| CREATE DatabaseOrSchema OptionalIfNotExists CURSOR RegularIdentifier
///	| CREATE DatabaseOrSchema OptionalIfNotExists_EDIT RegularIdentifier
///	| CREATE DatabaseOrSchema OptionalIfNotExists RegularIdentifier DatabaseDefinitionOptionals CURSOR
///	;

DatabaseDefinitionOptionals
	: OptionalComment
	;

///DatabaseDefinitionOptionals_EDIT
///	: OptionalComment_INVALID
///	;


//#file	create/create_role.jison



DataDefinition
	: RoleDefinition
	;

RoleDefinition
	: CREATE ROLE RegularIdentifier
	;


//#file	create/create_table.jison



DataDefinition
	: TableDefinition
	;

///DataDefinition_EDIT
///	: TableDefinition_EDIT
///	;

TableDefinition
	: CREATE TABLE OptionalIfNotExists TableDefinitionRightPart
	;

///TableDefinition_EDIT
///	: CREATE TABLE OptionalIfNotExists TableDefinitionRightPart_EDIT
///	| CREATE TABLE OptionalIfNotExists CURSOR
///	| CREATE TABLE OptionalIfNotExists_EDIT
///	;

TableDefinitionRightPart
	: TableIdentifierAndOptionalColumnSpecification OptionalPartitionedBy OptionalAsSelectStatement
	;

///TableDefinitionRightPart_EDIT
///	: TableIdentifierAndOptionalColumnSpecification_EDIT OptionalPartitionedBy OptionalAsSelectStatement
///	| TableIdentifierAndOptionalColumnSpecification PartitionedBy_EDIT OptionalAsSelectStatement
///	| TableIdentifierAndOptionalColumnSpecification OptionalPartitionedBy OptionalAsSelectStatement_EDIT
///	| TableIdentifierAndOptionalColumnSpecification OptionalPartitionedBy CURSOR
///	;

TableIdentifierAndOptionalColumnSpecification
	: SchemaQualifiedIdentifier OptionalColumnSpecificationsOrLike
	;

///TableIdentifierAndOptionalColumnSpecification_EDIT
///	: SchemaQualifiedIdentifier OptionalColumnSpecificationsOrLike_EDIT
///	| SchemaQualifiedIdentifier_EDIT OptionalColumnSpecificationsOrLike
///	;

OptionalColumnSpecificationsOrLike
	: /*empty*/
	| ParenthesizedColumnSpecificationList
	| LIKE SchemaQualifiedTableIdentifier
	;

///OptionalColumnSpecificationsOrLike_EDIT
///	: ParenthesizedColumnSpecificationList_EDIT
///	| LIKE CURSOR
///	| LIKE SchemaQualifiedTableIdentifier_EDIT
///	;

ParenthesizedColumnSpecificationList
	: '(' ColumnSpecificationList ')'
	;

///ParenthesizedColumnSpecificationList_EDIT
///	: '(' ColumnSpecificationList_EDIT RightParenthesisOrError
///	;

ColumnSpecificationList
	: ColumnSpecification
	| ColumnSpecificationList ',' ColumnSpecification
	;

///ColumnSpecificationList_EDIT
///	: ColumnSpecification_EDIT
///	| ColumnSpecification_EDIT ',' ColumnSpecificationList
///	| ColumnSpecificationList ',' ColumnSpecification_EDIT
///	| ColumnSpecificationList ',' ColumnSpecification_EDIT ',' ColumnSpecificationList
///	| ColumnSpecification CURSOR
///	| ColumnSpecification CURSOR ',' ColumnSpecificationList
///	| ColumnSpecificationList ',' ColumnSpecification CURSOR
///	| ColumnSpecificationList ',' ColumnSpecification CURSOR ',' ColumnSpecificationList
///	;

ColumnSpecification
	: ColumnIdentifier ColumnDataType OptionalColumnOptions
	;

///ColumnSpecification_EDIT
///	: ColumnIdentifier CURSOR OptionalColumnOptions
///	| ColumnIdentifier ColumnDataType_EDIT OptionalColumnOptions
///	| ColumnIdentifier ColumnDataType ColumnOptions_EDIT
///	;

OptionalColumnOptions
	:
	| ColumnOptions
	;

ColumnOptions
	: ColumnOption
	| ColumnOptions ColumnOption
	;

///ColumnOptions_EDIT
///	: ColumnOption_EDIT
///	| ColumnOption_EDIT ColumnOptions
///	| ColumnOptions ColumnOption_EDIT
///	| ColumnOptions ColumnOption_EDIT ColumnOptions
///	;

ColumnOption
	: NOT NULL
	| NULL
	| Comment
	;

///ColumnOption_EDIT
///	: NOT CURSOR
///	;

ColumnDataType
	: PrimitiveType
	| ArrayType
	| MapType
	| StructType
	| ArrayType_INVALID
	| MapType_INVALID
	| StructType_INVALID
	;

///ColumnDataType_EDIT
///	: ArrayType_EDIT
///	| MapType_EDIT
///	| StructType_EDIT
///	;

ArrayType
	: ARRAY '<' ColumnDataType '>'
	;

ArrayType_INVALID
	: ARRAY '<' '>'
	;

///ArrayType_EDIT
///	: ARRAY '<' AnyCursor GreaterThanOrError
///	| ARRAY '<' ColumnDataType_EDIT GreaterThanOrError
///	;

MapType
	: MAP '<' PrimitiveType ',' ColumnDataType '>'
	;

MapType_INVALID
	: MAP '<' '>'
	;

///MapType_EDIT
///	: MAP '<' PrimitiveType ',' ColumnDataType_EDIT GreaterThanOrError
///	| MAP '<' AnyCursor GreaterThanOrError
///	| MAP '<' PrimitiveType ',' AnyCursor GreaterThanOrError
///	| MAP '<' ',' AnyCursor GreaterThanOrError
///	;

StructType
	: STRUCT '<' StructDefinitionList '>'
	;

StructType_INVALID
	: STRUCT '<' '>'
	;

///StructType_EDIT
///	: STRUCT '<' StructDefinitionList_EDIT GreaterThanOrError
///	;

StructDefinitionList
	: StructDefinition
	| StructDefinitionList ',' StructDefinition
	;

///StructDefinitionList_EDIT
///	: StructDefinition_EDIT
///	| StructDefinition_EDIT Commas
///	| StructDefinition_EDIT Commas StructDefinitionList
///	| StructDefinitionList ',' StructDefinition_EDIT
///	| StructDefinitionList ',' StructDefinition_EDIT Commas StructDefinitionList
///	;

StructDefinition
	: RegularOrBacktickedIdentifier ':' ColumnDataType OptionalComment
	;

///StructDefinition_EDIT
///	: Commas RegularOrBacktickedIdentifier ':' ColumnDataType CURSOR
///	| Commas RegularOrBacktickedIdentifier ':' AnyCursor
///	| Commas RegularOrBacktickedIdentifier ':' ColumnDataType_EDIT
///	| RegularOrBacktickedIdentifier ':' ColumnDataType CURSOR
///	| RegularOrBacktickedIdentifier ':' AnyCursor
///	| RegularOrBacktickedIdentifier ':' ColumnDataType_EDIT
///	;

///ColumnDataTypeList
///	: ColumnDataType
///	| ColumnDataTypeList ',' ColumnDataType
///	;

///ColumnDataTypeList_EDIT
///	: ColumnDataTypeListInner_EDIT
///	| ColumnDataTypeListInner_EDIT Commas
///	| ColumnDataTypeList ',' ColumnDataTypeListInner_EDIT
///	| ColumnDataTypeListInner_EDIT Commas ColumnDataTypeList
///	| ColumnDataTypeList ',' ColumnDataTypeListInner_EDIT Commas ColumnDataTypeList
///	;

///ColumnDataTypeListInner_EDIT
///	: Commas AnyCursor
///	| Commas ColumnDataType_EDIT
///	| AnyCursor
///	| ColumnDataType_EDIT
///	;

///GreaterThanOrError
///	: '>'
///	| error
///	;

OptionalPartitionedBy
	: /*empty*/
	| PartitionedBy
	;

PartitionedBy
	: PARTITION BY RangeClause
	;

///PartitionedBy_EDIT
///	: PARTITION CURSOR
///	| PARTITION BY CURSOR
///	| PARTITION BY RangeClause_EDIT
///	;

RangeClause
	: RANGE ParenthesizedColumnList ParenthesizedPartitionValuesList
	;

///RangeClause_EDIT
///	: RANGE CURSOR
///	| RANGE ParenthesizedColumnList_EDIT
///	| RANGE ParenthesizedColumnList CURSOR
///	| RANGE ParenthesizedColumnList ParenthesizedPartitionValuesList_EDIT
///	| RANGE ParenthesizedColumnList_EDIT ParenthesizedPartitionValuesList
///	;

ParenthesizedPartitionValuesList
	: '(' PartitionValueList ')'
	;

///ParenthesizedPartitionValuesList_EDIT
///	: '(' CURSOR RightParenthesisOrError
///	|'(' PartitionValueList_EDIT RightParenthesisOrError
///	;

PartitionValueList
	: PartitionValue
	| PartitionValueList ',' PartitionValue
	;

///PartitionValueList_EDIT
///	: PartitionValue_EDIT
///	| PartitionValueList ',' CURSOR
///	| PartitionValueList ',' CURSOR ',' PartitionValueList
///	| PartitionValueList ',' PartitionValue_EDIT
///	| PartitionValueList ',' PartitionValue_EDIT ',' PartitionValueList
///	;

PartitionValue
	: PARTITION ValueExpression LessThanOrEqualTo VALUES LessThanOrEqualTo ValueExpression
	| PARTITION VALUES LessThanOrEqualTo ValueExpression
	| PARTITION ValueExpression LessThanOrEqualTo VALUES
	;

///PartitionValue_EDIT
///	: PARTITION CURSOR
///	| PARTITION ValueExpression_EDIT
///	| PARTITION ValueExpression CURSOR
///	| PARTITION ValueExpression LessThanOrEqualTo CURSOR
///	| PARTITION ValueExpression_EDIT LessThanOrEqualTo VALUES
///	| PARTITION ValueExpression LessThanOrEqualTo VALUES CURSOR
///	| PARTITION ValueExpression LessThanOrEqualTo VALUES LessThanOrEqualTo CURSOR
///	| PARTITION ValueExpression LessThanOrEqualTo VALUES LessThanOrEqualTo ValueExpression_EDIT
///	| PARTITION VALUES CURSOR
///	| PARTITION VALUES LessThanOrEqualTo CURSOR
///	| PARTITION VALUES LessThanOrEqualTo ValueExpression_EDIT
///	;

LessThanOrEqualTo
	: '<'
	| COMPARISON_OPERATOR // This is fine for autocompletion
	;

OptionalAsSelectStatement
	: /*empty*/
	| AS CommitLocations QuerySpecification
	;

///OptionalAsSelectStatement_EDIT
///	: AS CommitLocations CURSOR
///	| AS CommitLocations QuerySpecification_EDIT
///	;

CommitLocations
	: /* empty */
	;


//#file	create/create_view.jison



DataDefinition
	: ViewDefinition
	;

///DataDefinition_EDIT
///	: ViewDefinition_EDIT
///	;

ViewDefinition
	: CREATE VIEW OptionalIfNotExists SchemaQualifiedIdentifier OptionalParenthesizedViewColumnList OptionalComment AS QuerySpecification
	;

///ViewDefinition_EDIT
///	: CREATE VIEW OptionalIfNotExists CURSOR
///	| CREATE VIEW OptionalIfNotExists CURSOR SchemaQualifiedIdentifier OptionalParenthesizedViewColumnList OptionalComment AS QuerySpecification
///	| CREATE VIEW OptionalIfNotExists_EDIT
///	| CREATE VIEW OptionalIfNotExists SchemaQualifiedIdentifier ParenthesizedViewColumnList_EDIT OptionalComment
///	| CREATE VIEW OptionalIfNotExists SchemaQualifiedIdentifier OptionalParenthesizedViewColumnList OptionalComment CURSOR
///	| CREATE VIEW OptionalIfNotExists SchemaQualifiedIdentifier OptionalParenthesizedViewColumnList OptionalComment AS CURSOR
///	| CREATE VIEW OptionalIfNotExists SchemaQualifiedIdentifier OptionalParenthesizedViewColumnList OptionalComment AS QuerySpecification_EDIT
///	| CREATE VIEW OptionalIfNotExists SchemaQualifiedIdentifier_EDIT OptionalParenthesizedViewColumnList OptionalComment AS QuerySpecification
///	;

OptionalParenthesizedViewColumnList
	: /*empty*/
	| ParenthesizedViewColumnList
	;

ParenthesizedViewColumnList
	: '(' ViewColumnList ')'
	;

///ParenthesizedViewColumnList_EDIT
///	: '(' ViewColumnList_EDIT RightParenthesisOrError
///	;

ViewColumnList
	: ColumnReference OptionalComment
	| ViewColumnList ',' ColumnReference OptionalComment
	;

///ViewColumnList_EDIT
///	: ColumnReference OptionalComment CURSOR
///	| ColumnReference OptionalComment CURSOR ',' ViewColumnList
///	| ViewColumnList ',' ColumnReference OptionalComment CURSOR
///	| ViewColumnList ',' ColumnReference OptionalComment CURSOR ',' ViewColumnList
///	;


//#file	drop/drop_common.jison



///DataDefinition_EDIT
///	: DROP CURSOR
///	;


//#file	drop/drop_database.jison



DataDefinition
	: DropDatabaseStatement
	;

///DataDefinition_EDIT
///	: DropDatabaseStatement_EDIT
///	;

DropDatabaseStatement
	: DROP DatabaseOrSchema OptionalIfExists RegularOrBacktickedIdentifier OptionalCascade
	;

///DropDatabaseStatement_EDIT
///	: DROP DatabaseOrSchema OptionalIfExists
///	| DROP DatabaseOrSchema OptionalIfExists_EDIT
///	| DROP DatabaseOrSchema OptionalIfExists CURSOR
///	| DROP DatabaseOrSchema OptionalIfExists RegularOrBacktickedIdentifier CURSOR
///	| DROP DatabaseOrSchema OptionalIfExists_EDIT RegularOrBacktickedIdentifier OptionalCascade
///	| DROP DatabaseOrSchema OptionalIfExists CURSOR RegularOrBacktickedIdentifier OptionalCascade
///	;


//#file	drop/drop_role.jison



DataDefinition
	: DropRoleStatement
	;

DropRoleStatement
	: DROP ROLE RegularIdentifier
	;


//#file	drop/drop_table.jison



DataDefinition
	: DropTableStatement
	;

///DataDefinition_EDIT
///	: DropTableStatement_EDIT
///	;

DropTableStatement
	: DROP TABLE OptionalIfExists SchemaQualifiedTableIdentifier OptionalPurge
	;

///DropTableStatement_EDIT
///	: DROP TABLE OptionalIfExists_EDIT
///	| DROP TABLE OptionalIfExists CURSOR
///	| DROP TABLE OptionalIfExists SchemaQualifiedTableIdentifier_EDIT OptionalPurge
///	| DROP TABLE OptionalIfExists_EDIT SchemaQualifiedTableIdentifier OptionalPurge
///	| DROP TABLE OptionalIfExists SchemaQualifiedTableIdentifier OptionalPurge CURSOR
///	;

OptionalPurge
	: /*empty*/
	| PURGE
	;


//#file	drop/drop_view.jison



DataDefinition
	: DropViewStatement
	;

///DataDefinition_EDIT
///	: DropViewStatement_EDIT
///	;

DropViewStatement
	: DROP VIEW OptionalIfExists SchemaQualifiedTableIdentifier
	;

///DropViewStatement_EDIT
///	: DROP VIEW OptionalIfExists CURSOR
///	| DROP VIEW OptionalIfExists CURSOR SchemaQualifiedTableIdentifier
///	| DROP VIEW OptionalIfExists_EDIT
///	| DROP VIEW OptionalIfExists_EDIT SchemaQualifiedTableIdentifier
///	| DROP VIEW OptionalIfExists SchemaQualifiedTableIdentifier_EDIT
///	;


//#file	insert/insert.jison



DataManipulation
	: InsertStatement
	;

InsertStatement
	: InsertValuesStatement
	;

///DataManipulation_EDIT
///	: InsertValuesStatement_EDIT
///	;

InsertValuesStatement
	: INSERT INTO OptionalTable SchemaQualifiedTableIdentifier VALUES InsertValuesList
	;

///InsertValuesStatement_EDIT
///	: INSERT CURSOR
///	| INSERT INTO OptionalTable CURSOR
///	| INSERT INTO OptionalTable SchemaQualifiedTableIdentifier_EDIT
///	| INSERT INTO OptionalTable SchemaQualifiedTableIdentifier CURSOR
///	| INSERT INTO OptionalTable SchemaQualifiedTableIdentifier_EDIT VALUES InsertValuesList
///	;

InsertValuesList
	: ParenthesizedRowValuesList
	| InsertValuesList ',' ParenthesizedRowValuesList
	;

ParenthesizedRowValuesList
	: '(' InValueList ')'
	;

OptionalTable
	: /*empty*/
	| TABLE
	;


//#file	select/cte_select_statement.jison



QuerySpecification
	: CommonTableExpression SelectStatement OptionalUnions
	| CommonTableExpression '(' QuerySpecification ')' OptionalUnions
	;

///QuerySpecification_EDIT
///	: CommonTableExpression '(' QuerySpecification_EDIT ')'
///	| CommonTableExpression SelectStatement_EDIT OptionalUnions
///	| CommonTableExpression SelectStatement OptionalUnions_EDIT
///	| CommonTableExpression_EDIT
///	| CommonTableExpression_EDIT '(' QuerySpecification ')'
///	| CommonTableExpression_EDIT SelectStatement OptionalUnions
///	;

CommonTableExpression
	: WITH WithQueries
	;

///CommonTableExpression_EDIT
///	: WITH WithQueries_EDIT
///	;

WithQueries
	: WithQuery
	| WithQueries ',' WithQuery
	;

///WithQueries_EDIT
///	: WithQuery_EDIT
///	| WithQueries ',' WithQuery_EDIT
///	| WithQuery_EDIT ',' WithQueries
///	| WithQueries ',' WithQuery_EDIT ',' WithQueries
///	;

WithQuery
	: RegularOrBacktickedIdentifier AS '(' TableSubQueryInner ')'
	;

///WithQuery_EDIT
///	: RegularOrBacktickedIdentifier CURSOR
///	| RegularOrBacktickedIdentifier AS '(' AnyCursor RightParenthesisOrError
///	| RegularOrBacktickedIdentifier AS '(' TableSubQueryInner_EDIT RightParenthesisOrError
///	;


//#file	select/from_clause.jison



FromClause
	: FROM TableReferenceList
	;

///FromClause_EDIT
///	: FROM CURSOR
///	| FROM TableReferenceList_EDIT
///	;

TableReferenceList
	: TableReference
	| TableReferenceList ',' TableReference
	;

///TableReferenceList_EDIT
///	: TableReference_EDIT
///	| TableReference_EDIT ',' TableReference
///	| TableReferenceList ',' TableReference_EDIT
///	| TableReferenceList ',' TableReference_EDIT ',' TableReferenceList
///	| TableReferenceList ',' AnyCursor
///	;


//#file	select/group_by_clause.jison



OptionalGroupByClause
	: /*empty*/
	| GroupByClause
	;

GroupByClause
	: GROUP BY GroupByColumnList
	;

///GroupByClause_EDIT
///	: GROUP BY GroupByColumnList_EDIT
///	| GROUP BY CURSOR
///	| GROUP CURSOR
///	;

///ColumnGroupingSets
///	: /*empty*/
///	| ColumnReference
///	| ColumnGroupingSets ',' ColumnGroupingSets
///	| '(' ColumnGroupingSets ')'
///	;

///ColumnGroupingSets_EDIT
///	: ColumnGroupingSet_EDIT
///	| ColumnGroupingSet_EDIT ',' ColumnGroupingSets
///	| ColumnGroupingSets ',' ColumnGroupingSet_EDIT
///	| ColumnGroupingSets ',' ColumnGroupingSet_EDIT ',' ColumnGroupingSets
///	| '(' ColumnGroupingSets_EDIT RightParenthesisOrError
///	;

///ColumnGroupingSet_EDIT
///	: AnyCursor
///	| ColumnReference_EDIT
///	;

GroupByColumnList
	: ValueExpression
	| GroupByColumnList ',' ValueExpression
	;

///GroupByColumnList_EDIT
///	: ValueExpression_EDIT
///	| CURSOR ValueExpression
///	| CURSOR ',' GroupByColumnList
///	| ValueExpression_EDIT ',' GroupByColumnList
///	| GroupByColumnList ',' GroupByColumnListPartTwo_EDIT
///	| GroupByColumnList ',' GroupByColumnListPartTwo_EDIT ','
///	| GroupByColumnList ',' GroupByColumnListPartTwo_EDIT ',' GroupByColumnList
///	;

///GroupByColumnListPartTwo_EDIT
///	: ValueExpression_EDIT
///	| AnyCursor ValueExpression
///	| AnyCursor
///	;


//#file	select/having_clause.jison



OptionalHavingClause
	: /*empty*/
	| HavingClause
	;

HavingClause
	: HAVING ValueExpression
	;

///HavingClause_EDIT
///	: HAVING CURSOR
///	| HAVING ValueExpression_EDIT
///	;


//#file	select/joins.jison



///OptionalJoins
///	: /*empty*/
///	| Joins
///	| Joins_INVALID
///	;

Joins
	: JoinType TablePrimary OptionalJoinCondition
	| Joins JoinType TablePrimary OptionalJoinCondition
	;

///Joins_INVALID
///	: JoinType
///	| JoinType Joins
///	;

///Join_EDIT
///	: JoinType_EDIT TablePrimary OptionalJoinCondition
///	| JoinType_EDIT
///	| JoinType TablePrimary_EDIT OptionalJoinCondition
///	| JoinType TablePrimary JoinCondition_EDIT
///	| JoinType CURSOR OptionalJoinCondition
///	;

///Joins_EDIT
///	: Join_EDIT
///	| Join_EDIT Joins
///	| Joins Join_EDIT
///	| Joins Join_EDIT Joins
///	;

JoinType
	: CROSS JOIN
	| FULL JOIN
	| FULL OUTER JOIN
	| INNER JOIN
	| JOIN
	| LEFT INNER JOIN
	| LEFT JOIN
	| LEFT OUTER JOIN
	| LEFT SEMI JOIN
	| OUTER JOIN
	| RIGHT INNER JOIN
	| RIGHT JOIN
	| RIGHT OUTER JOIN
	| RIGHT SEMI JOIN
	| SEMI JOIN
	;

///JoinType_EDIT
///	: CROSS CURSOR
///	| FULL CURSOR JOIN
///	| FULL OUTER CURSOR
///	| INNER CURSOR
///	| LEFT CURSOR JOIN
///	| LEFT INNER CURSOR
///	| LEFT OUTER CURSOR
///	| LEFT SEMI CURSOR
///	| OUTER CURSOR
///	| RIGHT CURSOR JOIN
///	| RIGHT INNER CURSOR
///	| RIGHT OUTER CURSOR
///	| RIGHT SEMI CURSOR
///	| SEMI CURSOR
///	;

OptionalJoinCondition
	:
	| ON ValueExpression
	;

///UsingColList
///	: RegularOrBacktickedIdentifier
///	| UsingColList ',' RegularOrBacktickedIdentifier
///	;

///JoinCondition_EDIT
///	: ON ValueExpression_EDIT
///	| ON CURSOR
///	;


//#file	select/limit_clause.jison



OptionalLimitClause
	: /*empty*/
	| LimitClause
	;

LimitClause
	: LIMIT UnsignedNumericLiteral
	| LIMIT UnsignedNumericLiteral ',' UnsignedNumericLiteral
	| LIMIT VARIABLE_REFERENCE
	| LIMIT VARIABLE_REFERENCE ',' VARIABLE_REFERENCE
	;

///LimitClause_EDIT
///	: LIMIT CURSOR
///	;


//#file	select/order_by_clause.jison



OptionalOrderByClause
	: /*empty*/
	| OrderByClause
	;

OrderByClause
	: ORDER BY OrderByColumnList
	;

///OrderByClause_EDIT
///	: ORDER BY OrderByColumnList_EDIT
///	| ORDER CURSOR
///	;

OrderByColumnList
	: OrderByIdentifier
	| OrderByColumnList ',' OrderByIdentifier
	;

///OrderByColumnList_EDIT
///	: OrderByIdentifier_EDIT
///	| CURSOR OrderByIdentifier
///	| OrderByColumnList ',' OrderByIdentifier_EDIT
///	| OrderByColumnList ',' OrderByIdentifier_EDIT ','
///	| OrderByColumnList ',' OrderByIdentifier_EDIT ',' OrderByColumnList
///	;

OrderByIdentifier
	: ValueExpression OptionalAscOrDesc
	;

///OrderByIdentifier_EDIT
///	: ValueExpression_EDIT OptionalAscOrDesc
///	| AnyCursor OptionalAscOrDesc
///	;

OptionalAscOrDesc
	:
	| ASC
	| DESC
	;


//#file	select/select.jison



QuerySpecification
	: SelectStatement OptionalUnions
	;

///QuerySpecification_EDIT
///	: SelectStatement_EDIT OptionalUnions
///	| SelectStatement OptionalUnions_EDIT
///	;

SelectStatement
	: SELECT OptionalAllOrDistinct SelectList
	| SELECT OptionalAllOrDistinct SelectList TableExpression
	;

///SelectStatement_EDIT
///	: SELECT OptionalAllOrDistinct SelectList_EDIT
///	| SELECT OptionalAllOrDistinct CURSOR
///	| SELECT OptionalAllOrDistinct SelectList TableExpression_EDIT
///	| SELECT OptionalAllOrDistinct SelectList_EDIT TableExpression
///	| SELECT OptionalAllOrDistinct CURSOR TableExpression
///	| SELECT OptionalAllOrDistinct SelectList CURSOR TableExpression
///	| SELECT OptionalAllOrDistinct SelectList CURSOR ',' TableExpression
///	| SELECT OptionalAllOrDistinct SelectList CURSOR
///	;

OptionalAllOrDistinct
	: /*empty*/
	| ALL
	| DISTINCT
	;

TableExpression
	: FromClause OptionalSelectConditions
	;

///TableExpression_EDIT
///	: FromClause_EDIT OptionalSelectConditions
///	| FromClause CURSOR OptionalSelectConditions OptionalJoins
///	| FromClause OptionalSelectConditions_EDIT OptionalJoins
///	;

SelectList
	: SelectSpecification
	| SelectList ',' SelectSpecification
	;

///SelectList_EDIT
///	: SelectSpecification_EDIT
///	| CURSOR SelectList
///	| CURSOR ',' SelectList
///	| SelectSpecification_EDIT ',' SelectList
///	| SelectList CURSOR SelectList
///	| SelectList CURSOR ',' SelectList
///	| SelectList ',' AnyCursor
///	| SelectList ',' SelectSpecification_EDIT
///	| SelectList ',' AnyCursor SelectList
///	| SelectList ',' AnyCursor ','
///	| SelectList ',' SelectSpecification_EDIT ','
///	| SelectList ',' AnyCursor ',' SelectList
///	| SelectList ',' SelectSpecification_EDIT ',' SelectList
///	;

SelectSpecification
	: ValueExpression OptionalCorrelationName
	| '*'
	;

///SelectSpecification_EDIT
///	: ValueExpression_EDIT OptionalCorrelationName
///	| AnyCursor AS RegularOrBacktickedIdentifier
///	| ValueExpression OptionalCorrelationName_EDIT
///	;


//#file	select/select_conditions.jison



OptionalSelectConditions
	: OptionalWhereClause OptionalGroupByClause OptionalHavingClause OptionalOrderByClause OptionalLimitClause
	;

///OptionalSelectConditions_EDIT
///	: WhereClause_EDIT OptionalGroupByClause OptionalHavingClause OptionalOrderByClause OptionalLimitClause
///	| OptionalWhereClause GroupByClause_EDIT OptionalHavingClause OptionalOrderByClause OptionalLimitClause
///	| OptionalWhereClause OptionalGroupByClause HavingClause_EDIT OptionalOrderByClause OptionalLimitClause
///	| OptionalWhereClause OptionalGroupByClause OptionalHavingClause OrderByClause_EDIT OptionalLimitClause
///	| OptionalWhereClause OptionalGroupByClause OptionalHavingClause OptionalOrderByClause LimitClause_EDIT
///	;

///OptionalSelectConditions_EDIT
///	: WhereClause CURSOR OptionalGroupByClause OptionalHavingClause OptionalOrderByClause OptionalLimitClause
///	| OptionalWhereClause GroupByClause CURSOR OptionalHavingClause OptionalOrderByClause OptionalLimitClause
///	| OptionalWhereClause OptionalGroupByClause HavingClause CURSOR OptionalOrderByClause OptionalLimitClause
///	| OptionalWhereClause OptionalGroupByClause OptionalHavingClause OrderByClause CURSOR OptionalLimitClause
///	| OptionalWhereClause OptionalGroupByClause OptionalHavingClause OptionalOrderByClause LimitClause CURSOR
///	;


//#file	select/union_clause.jison



OptionalUnions
	: /*empty*/
	| Unions
	;

///OptionalUnions_EDIT
///	: Unions_EDIT
///	;

Unions
	: UnionClause
	| Unions UnionClause
	;

///Unions_EDIT
///	: UnionClause_EDIT
///	| Unions UnionClause_EDIT
///	| UnionClause_EDIT Unions
///	| Unions UnionClause_EDIT Unions
///	;

UnionClause
	: UNION NewStatement OptionalAllOrDistinct SelectStatement
	;

///UnionClause_EDIT
///	: UNION NewStatement CURSOR
///	| UNION NewStatement CURSOR SelectStatement
///	| UNION NewStatement OptionalAllOrDistinct SelectStatement_EDIT
///	;


//#file	select/where_clause.jison



OptionalWhereClause
	: /*empty*/
	| WhereClause
	;

WhereClause
	: WHERE SearchCondition
	;

///WhereClause_EDIT
///	: WHERE SearchCondition_EDIT
///	| WHERE CURSOR
///	;

SearchCondition
	: ValueExpression
	;

///SearchCondition_EDIT
///	: ValueExpression_EDIT
///	;


//#file	set/set_common.jison



///DataDefinition_EDIT
///	: SET CURSOR
///	;


//#file	set/set_all.jison



DataDefinition
	: SET ALL
	;


//#file	set/set_option.jison



DataDefinition
	: SET SetOption '=' SetValue
	;

SetOption
	: RegularIdentifier
	| SetOption '.' RegularIdentifier
	;

SetValue
	: RegularIdentifier
	| SignedInteger
	| SignedInteger RegularIdentifier
	| QuotedValue
	| TRUE
	| FALSE
	| NULL
	;


//#file	truncate/truncate_table.jison



DataDefinition
	: TruncateTableStatement
	;

///DataDefinition_EDIT
///	: TruncateTableStatement_EDIT
///	;

TruncateTableStatement
	: TRUNCATE TABLE OptionalIfExists SchemaQualifiedTableIdentifier
	;

///TruncateTableStatement_EDIT
///	: TRUNCATE CURSOR
///	| TRUNCATE TABLE OptionalIfExists CURSOR
///	| TRUNCATE TABLE OptionalIfExists_EDIT
///	| TRUNCATE TABLE OptionalIfExists SchemaQualifiedTableIdentifier_EDIT
///	| TRUNCATE TABLE OptionalIfExists SchemaQualifiedTableIdentifier CURSOR
///	| TRUNCATE TABLE OptionalIfExists CURSOR SchemaQualifiedTableIdentifier
///	| TRUNCATE TABLE OptionalIfExists_EDIT SchemaQualifiedTableIdentifier OptionalPartitionSpec
///	;


//#file	udf/aggregate/aggregate_common.jison



UserDefinedFunction
	: AggregateFunction OptionalOverClause
	;

///UserDefinedFunction_EDIT
///	: AggregateFunction_EDIT
///	| AggregateFunction OptionalOverClause_EDIT
///	;

AggregateFunction
	: OtherAggregateFunction
	;

///AggregateFunction_EDIT
///	: OtherAggregateFunction_EDIT
///	;

OtherAggregateFunction
	: OtherAggregateFunction_Type '(' OptionalAllOrDistinct ')'
	| OtherAggregateFunction_Type '(' OptionalAllOrDistinct UdfArgumentList ')'
	;

///OtherAggregateFunction_EDIT
///	: OtherAggregateFunction_Type '(' OptionalAllOrDistinct AnyCursor RightParenthesisOrError
///	| OtherAggregateFunction_Type '(' OptionalAllOrDistinct UdfArgumentList CURSOR RightParenthesisOrError
///	| OtherAggregateFunction_Type '(' OptionalAllOrDistinct UdfArgumentList_EDIT RightParenthesisOrError
///	;


//#file	udf/aggregate/avg.jison



OtherAggregateFunction_Type
	: AVG
	;


//#file	udf/aggregate/count.jison



AggregateFunction
	: CountFunction
	;

///AggregateFunction_EDIT
///	: CountFunction_EDIT
///	;

CountFunction
	: COUNT '(' '*' ')'
	| COUNT '(' ')'
	| COUNT '(' OptionalAllOrDistinct UdfArgumentList ')'
	;

///CountFunction_EDIT
///	: COUNT '(' OptionalAllOrDistinct AnyCursor RightParenthesisOrError
///	| COUNT '(' OptionalAllOrDistinct UdfArgumentList CURSOR RightParenthesisOrError
///	| COUNT '(' OptionalAllOrDistinct UdfArgumentList_EDIT RightParenthesisOrError
///	;


//#file	udf/aggregate/max.jison



OtherAggregateFunction_Type
	: MAX
	;


//#file	udf/aggregate/min.jison



OtherAggregateFunction_Type
	: MIN
	;


//#file	udf/aggregate/stddev_pop.jison



OtherAggregateFunction_Type
	: STDDEV_POP
	;


//#file	udf/aggregate/stddev_samp.jison



OtherAggregateFunction_Type
	: STDDEV_SAMP
	;


//#file	udf/aggregate/sum.jison



AggregateFunction
	: SumFunction
	;

///AggregateFunction_EDIT
///	: SumFunction_EDIT
///	;

SumFunction
	: SUM '(' OptionalAllOrDistinct ValueExpression ')'
	| SUM '(' ')'
	;

///SumFunction_EDIT
///	: SUM '(' OptionalAllOrDistinct AnyCursor RightParenthesisOrError
///	| SUM '(' OptionalAllOrDistinct ValueExpression CURSOR RightParenthesisOrError
///	| SUM '(' OptionalAllOrDistinct ValueExpression_EDIT RightParenthesisOrError
///	;


//#file	udf/aggregate/var_pop.jison



OtherAggregateFunction_Type
	: VAR_POP
	;


//#file	udf/aggregate/var_samp.jison



OtherAggregateFunction_Type
	: VAR_SAMP
	;


//#file	udf/aggregate/variance.jison



OtherAggregateFunction_Type
	: VARIANCE
	;


//#file	udf/analytic/analytic.jison



UserDefinedFunction
	: AnalyticFunction OverClause
	;

///UserDefinedFunction_EDIT
///	: AnalyticFunction_EDIT
///	| AnalyticFunction_EDIT OverClause
///	| AnalyticFunction CURSOR
///	| AnalyticFunction OverClause_EDIT
///	;

AnalyticFunction
	: ANALYTIC '(' ')'
	| ANALYTIC '(' UdfArgumentList ')'
	;

///AnalyticFunction_EDIT
///	: ANALYTIC '(' AnyCursor RightParenthesisOrError
///	| ANALYTIC '(' UdfArgumentList CURSOR RightParenthesisOrError
///	| ANALYTIC '(' UdfArgumentList_EDIT RightParenthesisOrError
///	;


//#file	udf/function/array.jison



ArbitraryFunctionName
	: ARRAY
	;


//#file	udf/function/cast.jison



UserDefinedFunction
	: CastFunction
	;

///UserDefinedFunction_EDIT
///	: CastFunction_EDIT
///	;

CastFunction
	: CAST '(' ValueExpression AS PrimitiveType ')'
	| CAST '(' ')'
	;

///CastFunction_EDIT
///	: CAST '(' AnyCursor AS PrimitiveType RightParenthesisOrError
///	| CAST '(' AnyCursor AS RightParenthesisOrError
///	| CAST '(' AnyCursor RightParenthesisOrError
///	| CAST '(' ValueExpression_EDIT AS PrimitiveType RightParenthesisOrError
///	| CAST '(' ValueExpression_EDIT AS RightParenthesisOrError
///	| CAST '(' ValueExpression_EDIT RightParenthesisOrError
///	| CAST '(' ValueExpression CURSOR PrimitiveType RightParenthesisOrError
///	| CAST '(' ValueExpression CURSOR RightParenthesisOrError
///	| CAST '(' ValueExpression AS CURSOR RightParenthesisOrError
///	| CAST '(' AS CURSOR RightParenthesisOrError
///	;


//#file	udf/function/if.jison



ArbitraryFunctionName
	: IF
	;


//#file	udf/function/map.jison



ArbitraryFunctionName
	: MAP
	;


//#file	udf/function/truncate.jison



ArbitraryFunctionName
	: TRUNCATE
	;


//#file	udf/udf_common.jison



NonParenthesizedValueExpressionPrimary
	: ColumnOrArbitraryFunctionRef ArbitraryFunctionRightPart
	| ArbitraryFunctionName ArbitraryFunctionRightPart
	| UserDefinedFunction
	;

///NonParenthesizedValueExpressionPrimary_EDIT
///	: ColumnOrArbitraryFunctionRef ArbitraryFunctionRightPart_EDIT
///	| ArbitraryFunctionName ArbitraryFunctionRightPart_EDIT
///	| UserDefinedFunction_EDIT
///	;

///ArbitraryFunction
///	: RegularIdentifier ArbitraryFunctionRightPart
///	| ArbitraryFunctionName ArbitraryFunctionRightPart
///	;

///ArbitraryFunction_EDIT
///	: RegularIdentifier ArbitraryFunctionRightPart_EDIT
///	| ArbitraryFunctionName ArbitraryFunctionRightPart_EDIT
///	;

ArbitraryFunctionRightPart
	: '(' ')'
	| '(' UdfArgumentList ')'
	;

///ArbitraryFunctionRightPart_EDIT
///	: '(' AnyCursor RightParenthesisOrError
///	| '(' UdfArgumentList CURSOR RightParenthesisOrError
///	| '(' UdfArgumentList_EDIT RightParenthesisOrError
///	;

UdfArgumentList
	: ValueExpression
	| UdfArgumentList ',' ValueExpression
	;

///UdfArgumentList_EDIT
///	: ValueExpression_EDIT
///	| UdfArgumentList ',' ValueExpression_EDIT
///	| ValueExpression_EDIT ',' UdfArgumentList
///	| UdfArgumentList ',' ValueExpression_EDIT ',' UdfArgumentList
///	| UdfArgumentList ',' AnyCursor
///	| UdfArgumentList ',' AnyCursor ',' UdfArgumentList
///	| UdfArgumentList CURSOR ',' UdfArgumentList
///	| AnyCursor ',' UdfArgumentList
///	| AnyCursor ','
///	| ',' AnyCursor
///	| ',' AnyCursor ',' UdfArgumentList
///	;

OptionalOverClause
	: /*empty*/
	| OverClause
	;

///OptionalOverClause_EDIT
///	: OverClause_EDIT
///	;

OverClause
	: OVER RegularOrBacktickedIdentifier
	| OVER WindowExpression
	;

///OverClause_EDIT
///	: OVER WindowExpression_EDIT
///	;


//#file	update/update_table.jison



DataManipulation
	: UpdateStatement
	;

///DataManipulation_EDIT
///	: UpdateStatement_EDIT
///	;

UpdateStatement
	: UPDATE TargetTable SET SetClauseList OptionalFromJoinedTable OptionalWhereClause
	;

///UpdateStatement_EDIT
///	: UPDATE TargetTable_EDIT SET SetClauseList OptionalFromJoinedTable OptionalWhereClause
///	| UPDATE TargetTable SET SetClauseList_EDIT OptionalFromJoinedTable OptionalWhereClause
///	| UPDATE TargetTable SET SetClauseList FromJoinedTable_EDIT OptionalWhereClause
///	| UPDATE TargetTable SET SetClauseList OptionalFromJoinedTable WhereClause_EDIT
///	| UPDATE TargetTable SET SetClauseList OptionalFromJoinedTable OptionalWhereClause CURSOR
///	| UPDATE TargetTable CURSOR
///	| UPDATE TargetTable_EDIT
///	| UPDATE TargetTable
///	| UPDATE CURSOR
///	;

TargetTable
	: TableName
	;

///TargetTable_EDIT
///	: TableName_EDIT
///	;

TableName
	: LocalOrSchemaQualifiedName
	;

///TableName_EDIT
///	: LocalOrSchemaQualifiedName_EDIT
///	;

SetClauseList
	: SetClause
	| SetClauseList ',' SetClause
	;

///SetClauseList_EDIT
///	: SetClause_EDIT
///	| SetClauseList ',' SetClause_EDIT
///	| SetClause_EDIT ',' SetClauseList
///	| SetClauseList ',' SetClause_EDIT ',' SetClauseList
///	;

SetClause
	: SetTarget '=' UpdateSource
	;

///SetClause_EDIT
///	: SetTarget '=' UpdateSource_EDIT
///	| SetTarget CURSOR
///	| CURSOR
///	;

SetTarget
	: ColumnReference
	;

UpdateSource
	: ValueExpression
	;

///UpdateSource_EDIT
///	: ValueExpression_EDIT
///	;

OptionalFromJoinedTable
	: /*empty*/
	| FROM TableReference
	;

///FromJoinedTable_EDIT
///	: FROM CURSOR
///	| FROM TableReference_EDIT
///	;


//#file	use/use.jison



DataDefinition
	: UseStatement
	;

///DataDefinition_EDIT
///	: UseStatement_EDIT
///	;

UseStatement
	: USE RegularIdentifier
	;

///UseStatement_EDIT
///	: USE CURSOR
///	| USE RegularIdentifier CURSOR
///	;


//#file	sql_main.jison



SqlSyntax
	: NewStatement SqlStatements //EOF
	;

///SqlAutocomplete
///	: NewStatement SqlStatements //EOF
///	| NewStatement SqlStatements_EDIT //EOF
///	;

NewStatement
	: /* empty */
	;

SqlStatements
	: /*empty*/
	| SqlStatement
	| SqlStatements ';' NewStatement SqlStatements
	;

///SqlStatements_EDIT
///	: SqlStatement_EDIT
///	| SqlStatement_EDIT ';' NewStatement SqlStatements
///	| SqlStatements ';' NewStatement SqlStatement_EDIT
///	| SqlStatements ';' NewStatement SqlStatement_EDIT ';' NewStatement SqlStatements
///	;

SqlStatement
	: DataDefinition
	| DataManipulation
	| QuerySpecification
	;

///SqlStatement_EDIT
///	: AnyCursor
///	| CommonTableExpression CURSOR
///	| DataDefinition_EDIT
///	| DataManipulation_EDIT
///	| QuerySpecification_EDIT
///	| SetSpecification_EDIT
///	;

NonReservedKeyword
	: ROLE
	| OPTION
	| STRUCT
	;

RegularIdentifier
	: REGULAR_IDENTIFIER
	| VARIABLE_REFERENCE
	| NonReservedKeyword
	;

// This is a work-around for error handling when a statement starts with some token that the parser can understand but
// it's not a valid statement (see ErrorStatement). It contains everything except valid starting tokens (SELECT, USE etc.)
///NonStartingToken
///	: '!'
///	| '('
///	| ')'
///	| '*'
///	| ','
///	| '-'
///	| '+'
///	| '.'
///	| '<'
///	| '='
///	| '>'
///	| '['
///	| ']'
///	| '~'
///	| ALL
///	| ANALYTIC
///	| AND
///	| ARITHMETIC_OPERATOR
///	| ARRAY
///	| AS
///	| ASC
///	| AVG
///	| BACKTICK
///	| BETWEEN
///	| BIGINT
///	| BOOLEAN
///	| BY
///	| CASE
///	| CAST
///	| CHAR
///	| COMPARISON_OPERATOR
///	| COUNT
///	| CROSS
///	| CURRENT
///	| DATABASE
///	| DECIMAL
///	| DISTINCT
///	| DOUBLE
///	| DOUBLE_QUOTE
///	| ELSE
///	| END
///	| EXISTS
///	| FALSE
///	| FLOAT
///	| FOLLOWING
///	| FROM
///	| FULL
///	| GROUP
///	| HAVING
///	| HDFS_START_QUOTE
///	| IF
///	| IN
///	| INNER
///	| INT
///	| INTO
///	| IS
///	| JOIN
///	| LEFT
///	| LIKE
///	| LIMIT
///	| MAP
///	| MAX
///	| MIN
///	| NOT
///	| NULL
///	| ON
///	| OPTION
///	| OR
///	| ORDER
///	| OUTER
///	| OVER
///	| PARTITION
///	| PRECEDING
///	| PURGE
///	| RANGE
///	| REGEXP
///	| REGULAR_IDENTIFIER
///	| RIGHT
///	| RLIKE
///	| ROLE
///	| ROW
///	| ROWS
///	| SCHEMA
///	| SEMI
///	| SET
///	| SINGLE_QUOTE
///	| SMALLINT
///	| STDDEV_POP
///	| STDDEV_SAMP
///	| STRING
///	| STRUCT
///	| SUM
///	| TABLE
///	| THEN
///	| TIMESTAMP
///	| TINYINT
///	| TRUE
///	| UNION
///	| UNSIGNED_INTEGER
///	| UNSIGNED_INTEGER_E
///	| VALUES
///	| VAR_POP
///	| VAR_SAMP
///	| VARCHAR
///	| VARIABLE_REFERENCE
///	| VARIANCE
///	| WHEN
///	| WHERE
///	;

// ===================================== Commonly used constructs =====================================

///Commas
///	: ','
///	| Commas ','
///	;

///AnyCursor
///	: CURSOR
///	| PARTIAL_CURSOR
///	;

///FromOrIn
///	: FROM
///	| IN
///	;

DatabaseOrSchema
	: DATABASE
	| SCHEMA
	;

SingleQuotedValue
	: SINGLEQUOTEDVALUE
	//SINGLE_QUOTE VALUE SINGLE_QUOTE
	//| SINGLE_QUOTE SINGLE_QUOTE
	;

///SingleQuotedValue_EDIT
///	: SINGLE_QUOTE PARTIAL_VALUE
///	;

DoubleQuotedValue
	: DOUBLEQUOTEDVALUE
	//DOUBLE_QUOTE VALUE DOUBLE_QUOTE
	//| DOUBLE_QUOTE DOUBLE_QUOTE
	;

///DoubleQuotedValue_EDIT
///	: DOUBLE_QUOTE PARTIAL_VALUE
///	;

QuotedValue
	: SingleQuotedValue
	| DoubleQuotedValue
	;

///QuotedValue_EDIT
///	: SingleQuotedValue_EDIT
///	| DoubleQuotedValue_EDIT
///	;

///OptionalFromOrInDatabase
///	: /*empty*/
///	| FromOrInDatabases
///	;

///FromOrInDatabases
///	: FromOrIn DatabaseIdentifier
///	;

///FromOrInDatabase_EDIT
///	: FromOrIn DatabaseIdentifier_EDIT
///	;

OptionalCascade
	: /*empty*/
	| CASCADE
	;

OptionalIfExists
	: /*empty*/
	| IF EXISTS
	;

///IfExists_EDIT
///	: OptionalIfExists_EDIT
///	;

///OptionalIfExists_EDIT
///	: IF CURSOR
///	;

OptionalIfNotExists
	: /*empty*/
	| IF NOT EXISTS
	;

///IfNotExists_EDIT
///	: OptionalIfNotExists_EDIT
///	;

///OptionalIfNotExists_EDIT
///	: IF CURSOR
///	| IF NOT CURSOR
///	;

///OptionalInDatabase
///	: /*empty*/
///	| IN DatabaseIdentifier
///	| IN DatabaseIdentifier_EDIT
///	;

///OptionalPartitionSpec
///	: /*empty*/
///	| PartitionSpec
///	;

///OptionalPartitionSpec_EDIT
///	: PartitionSpec_EDIT
///	;

PartitionSpec
	: PARTITION '(' PartitionSpecList ')'
	;

///PartitionSpec_EDIT
///	: PARTITION '(' PartitionSpecList_EDIT RightParenthesisOrError
///	;

///RangePartitionSpec
///	: UnsignedValueSpecification RangePartitionComparisonOperator VALUES RangePartitionComparisonOperator UnsignedValueSpecification
///	;

///RangePartitionSpec_EDIT
///	: UnsignedValueSpecification CURSOR
///	| UnsignedValueSpecification RangePartitionComparisonOperator CURSOR
///	| UnsignedValueSpecification RangePartitionComparisonOperator VALUES CURSOR
///	| UnsignedValueSpecification CURSOR VALUES RangePartitionComparisonOperator UnsignedValueSpecification
///	| UnsignedValueSpecification RangePartitionComparisonOperator CURSOR RangePartitionComparisonOperator UnsignedValueSpecification
///	| UnsignedValueSpecification RangePartitionComparisonOperator VALUES CURSOR UnsignedValueSpecification
///	;

///RangePartitionComparisonOperator
///	: COMPARISON_OPERATOR
///	| '='
///	| '<'
///	| '>'
///	;

///ConfigurationName
///	: RegularIdentifier
///	| CURSOR
///	;

///PartialBacktickedOrAnyCursor
///	: AnyCursor
///	| PartialBacktickedIdentifier
///	;

///PartialBacktickedOrCursor
///	: CURSOR
///	| PartialBacktickedIdentifier
///	;

///PartialBacktickedOrPartialCursor
///	: PARTIAL_CURSOR
///	| PartialBacktickedIdentifier
///	;

///PartialBacktickedIdentifier
///	: BACKTICK PARTIAL_VALUE
///	;

///RightParenthesisOrError
///	: ')'
///	| error
///	;

///OptionalParenthesizedColumnList
///	: /*empty*/
///	| ParenthesizedColumnList
///	;

///OptionalParenthesizedColumnList_EDIT
///	: ParenthesizedColumnList_EDIT
///	;

ParenthesizedColumnList
	: '(' ColumnList ')'
	;

///ParenthesizedColumnList_EDIT
///	: '(' ColumnList_EDIT RightParenthesisOrError
///	| '(' AnyCursor RightParenthesisOrError
///	;

ColumnList
	: ColumnIdentifier
	| ColumnList ',' ColumnIdentifier
	;

///ColumnList_EDIT
///	: ColumnList ',' AnyCursor
///	| ColumnList ',' AnyCursor ',' ColumnList
///	;

///ParenthesizedSimpleValueList
///	: '(' SimpleValueList ')'
///	;

///SimpleValueList
///	: UnsignedValueSpecification
///	| SimpleValueList ',' UnsignedValueSpecification
///	;

SchemaQualifiedTableIdentifier
	: RegularOrBacktickedIdentifier
	| RegularOrBacktickedIdentifier '.' RegularOrBacktickedIdentifier
	;

///SchemaQualifiedTableIdentifier_EDIT
///	: PartialBacktickedIdentifier
///	| PartialBacktickedIdentifier '.' RegularOrBacktickedIdentifier
///	| RegularOrBacktickedIdentifier '.' PartialBacktickedOrPartialCursor
///	;

SchemaQualifiedIdentifier
	: RegularOrBacktickedIdentifier
	| RegularOrBacktickedIdentifier '.' RegularOrBacktickedIdentifier
	;

///SchemaQualifiedIdentifier_EDIT
///	: PartialBacktickedIdentifier
///	| PartialBacktickedIdentifier '.' RegularOrBacktickedIdentifier
///	| RegularOrBacktickedIdentifier '.' PartialBacktickedOrPartialCursor
///	;

///DatabaseIdentifier
///	: RegularOrBacktickedIdentifier
///	;

///DatabaseIdentifier_EDIT
///	: PartialBacktickedOrCursor
///	;

PartitionSpecList
	: PartitionExpression
	| PartitionSpecList ',' PartitionExpression
	;

///PartitionSpecList_EDIT
///	: PartitionExpression_EDIT
///	| PartitionSpecList ',' PartitionExpression_EDIT
///	| PartitionExpression_EDIT ',' PartitionSpecList
///	| PartitionSpecList ',' PartitionExpression_EDIT ',' PartitionSpecList
///	;

PartitionExpression
	: ColumnIdentifier '=' ValueExpression
	;

///PartitionExpression_EDIT
///	: ColumnIdentifier '=' ValueExpression_EDIT
///	| ColumnIdentifier '=' AnyCursor
///	| PartialBacktickedIdentifier '=' ValueExpression
///	| AnyCursor
///	;

RegularOrBacktickedIdentifier
	: RegularIdentifier
	| BACKTICKEDIDENTIFIER
	//| BACKTICK VALUE BACKTICK
	//| BACKTICK BACKTICK
	;

// TODO: Same as SchemaQualifiedTableIdentifier?
RegularOrBackTickedSchemaQualifiedName
	: RegularOrBacktickedIdentifier
	| RegularOrBacktickedIdentifier '.' RegularOrBacktickedIdentifier
	;

///RegularOrBackTickedSchemaQualifiedName_EDIT
///	: PartialBacktickedIdentifier
///	| RegularOrBacktickedIdentifier '.' PartialBacktickedOrPartialCursor
///	;


LocalOrSchemaQualifiedName
	: RegularOrBackTickedSchemaQualifiedName
	| RegularOrBackTickedSchemaQualifiedName RegularOrBacktickedIdentifier
	;

///LocalOrSchemaQualifiedName_EDIT
///	: RegularOrBackTickedSchemaQualifiedName_EDIT
///	| RegularOrBackTickedSchemaQualifiedName_EDIT RegularOrBacktickedIdentifier
///	;

ColumnReference
	: BasicIdentifierChain
	| BasicIdentifierChain '.' '*'
	;

///ColumnReference_EDIT
///	: BasicIdentifierChain_EDIT
///	;

BasicIdentifierChain
	: ColumnIdentifier
	| BasicIdentifierChain '.' ColumnIdentifier
	;

// TODO: Merge with DerivedColumnChain_EDIT ( issue is starting with PartialBacktickedOrPartialCursor)
///BasicIdentifierChain_EDIT
///	: BasicIdentifierChain '.' PartialBacktickedOrPartialCursor
///	| BasicIdentifierChain '.' PartialBacktickedOrPartialCursor '.' BasicIdentifierChain
///	;

///DerivedColumnChain
///	: ColumnIdentifier
///	| DerivedColumnChain '.' ColumnIdentifier
///	;

///DerivedColumnChain_EDIT
///	: PartialBacktickedIdentifierOrPartialCursor
///	| DerivedColumnChain '.' PartialBacktickedIdentifierOrPartialCursor
///	| DerivedColumnChain '.' PartialBacktickedIdentifierOrPartialCursor '.' DerivedColumnChain
///	| PartialBacktickedIdentifierOrPartialCursor '.' DerivedColumnChain
///	;

ColumnIdentifier
	: RegularOrBacktickedIdentifier
	;

///PartialBacktickedIdentifierOrPartialCursor
///	: PartialBacktickedIdentifier
///	| PARTIAL_CURSOR
///	;

PrimitiveType
	: BIGINT
	| BOOLEAN
	| CHAR OptionalTypeLength
	| DECIMAL OptionalTypePrecision
	| DOUBLE
	| FLOAT
	| INT
	| SMALLINT
	| STRING
	| TIMESTAMP
	| TINYINT
	| VARCHAR OptionalTypeLength
	;

OptionalTypeLength
	: /*empty*/
	| '(' UNSIGNED_INTEGER ')'
	;

OptionalTypePrecision
	: /*empty*/
	| '(' UNSIGNED_INTEGER ')'
	| '(' UNSIGNED_INTEGER ',' UNSIGNED_INTEGER ')'
	;

ValueExpression
	: NonParenthesizedValueExpressionPrimary
	;

///ValueExpression_EDIT
///	: NonParenthesizedValueExpressionPrimary_EDIT
///	;

///ValueExpression_EDIT
///	: ValueExpression NOT CURSOR
///	;

ValueExpressionList
	: ValueExpression
	| ValueExpressionList ',' ValueExpression
	;

///ValueExpressionList_EDIT
///	: ValueExpression_EDIT
///	| ValueExpressionList ',' ValueExpression_EDIT
///	| ValueExpression_EDIT ',' ValueExpressionList
///	| ValueExpressionList ',' ValueExpression_EDIT ',' ValueExpressionList
///	| ValueExpressionList ',' AnyCursor
///	| ValueExpressionList ',' AnyCursor ',' ValueExpressionList
///	| ValueExpressionList CURSOR ',' ValueExpressionList
///	| AnyCursor ',' ValueExpressionList
///	| AnyCursor ','
///	| ',' AnyCursor
///	| ',' AnyCursor ',' ValueExpressionList
///	;

InValueList
	: NonParenthesizedValueExpressionPrimary
	| InValueList ',' NonParenthesizedValueExpressionPrimary
	;

NonParenthesizedValueExpressionPrimary
	: UnsignedValueSpecification
	| ColumnOrArbitraryFunctionRef
	| NULL
	;

///NonParenthesizedValueExpressionPrimary_EDIT
///	: UnsignedValueSpecification_EDIT
///	| ColumnOrArbitraryFunctionRef_EDIT
///	;

ColumnOrArbitraryFunctionRef
	: BasicIdentifierChain
	| BasicIdentifierChain '.' '*'
	;

///ColumnOrArbitraryFunctionRef_EDIT
///	: BasicIdentifierChain_EDIT
///	;

SignedInteger
	: UnsignedNumericLiteral
	| '-' UnsignedNumericLiteral
	| '+' UnsignedNumericLiteral
	;

UnsignedValueSpecification
	: UnsignedLiteral
	;

///UnsignedValueSpecification_EDIT
///	: UnsignedLiteral_EDIT
///	;

UnsignedLiteral
	: UnsignedNumericLiteral
	| GeneralLiteral
	;

///UnsignedLiteral_EDIT
///	: GeneralLiteral_EDIT
///	;

UnsignedNumericLiteral
	: ExactNumericLiteral
	| ApproximateNumericLiteral
	;

ExactNumericLiteral
	: UNSIGNED_INTEGER
	| UNSIGNED_INTEGER '.'
	| UNSIGNED_INTEGER '.' UNSIGNED_INTEGER
	| '.' UNSIGNED_INTEGER
	;

ApproximateNumericLiteral
	: UNSIGNED_INTEGER_E UNSIGNED_INTEGER
	| '.' UNSIGNED_INTEGER_E UNSIGNED_INTEGER
	| UNSIGNED_INTEGER '.' UNSIGNED_INTEGER_E UNSIGNED_INTEGER
	;

GeneralLiteral
	: SingleQuotedValue
	| DoubleQuotedValue
	| TruthValue
	;

///GeneralLiteral_EDIT
///	: SingleQuotedValue_EDIT
///	| DoubleQuotedValue_EDIT
///	;

TruthValue
	: TRUE
	| FALSE
	;

OptionalNot
	: /*empty*/
	| NOT
	;

TableReference
	: TablePrimaryOrJoinedTable
	;

///TableReference_EDIT
///	: TablePrimaryOrJoinedTable_EDIT
///	;

TablePrimaryOrJoinedTable
	: TablePrimary
	| JoinedTable
	;

///TablePrimaryOrJoinedTable_EDIT
///	: TablePrimary_EDIT
///	| JoinedTable_EDIT
///	;

JoinedTable
	: TablePrimary Joins
	;

///JoinedTable_EDIT
///	: TablePrimary Joins_EDIT
///	| TablePrimary_EDIT Joins
///	;

TablePrimary
	: TableOrQueryName OptionalCorrelationName
	| DerivedTable OptionalCorrelationName
	;

///TablePrimary_EDIT
///	: TableOrQueryName_EDIT OptionalCorrelationName
///	| DerivedTable_EDIT OptionalCorrelationName
///	| DerivedTable OptionalCorrelationName_EDIT
///	;

TableOrQueryName
	: SchemaQualifiedTableIdentifier
	;

///TableOrQueryName_EDIT
///	: SchemaQualifiedTableIdentifier_EDIT
///	;

DerivedTable
	: TableSubQuery
	;

///DerivedTable_EDIT
///	: TableSubQuery_EDIT
///	;

///OptionalOnColumn
///	: /*empty*/
///	| ON ValueExpression
///	;

///OptionalOnColumn_EDIT
///	: ON CURSOR
///	| ON ValueExpression_EDIT
///	;

PushQueryState
	: /*empty*/
	;

///PopQueryState
///	: /*empty*/
///	;

TableSubQuery
	: '(' TableSubQueryInner ')'
	| '(' DerivedTable OptionalCorrelationName ')'
	;

///TableSubQuery_EDIT
///	: '(' TableSubQueryInner_EDIT RightParenthesisOrError
///	| '(' AnyCursor RightParenthesisOrError
///	;

TableSubQueryInner
	: PushQueryState SubQuery
	;

///TableSubQueryInner_EDIT
///	: PushQueryState SubQuery_EDIT PopQueryState
///	;

SubQuery
	: QueryExpression
	;

///SubQuery_EDIT
///	: QueryExpression_EDIT
///	;

QueryExpression
	: QueryExpressionBody
	;

///QueryExpression_EDIT
///	: QueryExpressionBody_EDIT
///	;

QueryExpressionBody
	: NonJoinQueryExpression
	;

///QueryExpressionBody_EDIT
///	: NonJoinQueryExpression_EDIT
///	;

NonJoinQueryExpression
	: NonJoinQueryTerm
	;

///NonJoinQueryExpression_EDIT
///	: NonJoinQueryTerm_EDIT
///	;

NonJoinQueryTerm
	: NonJoinQueryPrimary
	;

///NonJoinQueryTerm_EDIT
///	: NonJoinQueryPrimary_EDIT
///	;

NonJoinQueryPrimary
	: SimpleTable
	;

///NonJoinQueryPrimary_EDIT
///	: SimpleTable_EDIT
///	;

SimpleTable
	: QuerySpecification
	;

///SimpleTable_EDIT
///	: QuerySpecification_EDIT
///	;

OptionalCorrelationName
	: /*empty*/
	| RegularOrBacktickedIdentifier
	| QuotedValue
	| AS RegularOrBacktickedIdentifier
	| AS QuotedValue
	;

///OptionalCorrelationName_EDIT
///	: PartialBacktickedIdentifier
///	| QuotedValue_EDIT
///	| AS PartialBacktickedIdentifier
///	| AS QuotedValue_EDIT
///	| AS CURSOR
///	;

WindowExpression
	: '(' OptionalPartitionBy OptionalOrderByAndWindow ')'
	;

///WindowExpression_EDIT
///	: '(' PartitionBy_EDIT OptionalOrderByAndWindow RightParenthesisOrError
///	| '(' OptionalPartitionBy OptionalOrderByAndWindow_EDIT RightParenthesisOrError
///	| '(' AnyCursor OptionalPartitionBy OptionalOrderByAndWindow RightParenthesisOrError
///	| '(' PARTITION BY ValueExpressionList CURSOR OptionalOrderByAndWindow RightParenthesisOrError
///	;

OptionalPartitionBy
	: /*empty*/
	| PartitionBy
	;

PartitionBy
	: PARTITION BY ValueExpressionList
	;

///PartitionBy_EDIT
///	: PARTITION CURSOR
///	| PARTITION BY CURSOR
///	| PARTITION BY ValueExpressionList_EDIT
///	;

OptionalOrderByAndWindow
	: /*empty*/
	| OrderByClause OptionalWindowSpec
	;

///OptionalOrderByAndWindow_EDIT
///	: OrderByClause_EDIT
///	| OrderByClause CURSOR OptionalWindowSpec
///	| OrderByClause WindowSpec_EDIT
///	;

OptionalWindowSpec
	: /*empty*/
	| WindowSpec
	;

WindowSpec
	: RowsOrRange BETWEEN PopLexerState OptionalCurrentOrPreceding OptionalAndFollowing
	| RowsOrRange UNBOUNDED PopLexerState OptionalCurrentOrPreceding OptionalAndFollowing
	;

///WindowSpec_EDIT
///	: RowsOrRange CURSOR
///	| RowsOrRange BETWEEN PopLexerState OptionalCurrentOrPreceding OptionalAndFollowing CURSOR
///	| RowsOrRange BETWEEN PopLexerState OptionalCurrentOrPreceding_EDIT OptionalAndFollowing
///	| RowsOrRange BETWEEN PopLexerState OptionalCurrentOrPreceding OptionalAndFollowing_EDIT
///	| RowsOrRange UNBOUNDED PopLexerState OptionalCurrentOrPreceding CURSOR
///	| RowsOrRange UNBOUNDED PopLexerState OptionalCurrentOrPreceding_EDIT
///	;

PopLexerState
	: /*empty*/
	;

///PushHdfsLexerState
///	: /*empty*/
///	;

///HdfsPath
///	: HDFS_START_QUOTE HDFS_PATH HDFS_END_QUOTE
///	;

///HdfsPath_EDIT
///	: HDFS_START_QUOTE HDFS_PATH PARTIAL_CURSOR HDFS_PATH HDFS_END_QUOTE
///	| HDFS_START_QUOTE HDFS_PATH PARTIAL_CURSOR HDFS_END_QUOTE
///	| HDFS_START_QUOTE HDFS_PATH PARTIAL_CURSOR
///	| HDFS_START_QUOTE PARTIAL_CURSOR HDFS_END_QUOTE
///	| HDFS_START_QUOTE PARTIAL_CURSOR
///	;

RowsOrRange
	: ROWS
	| RANGE
	;

OptionalCurrentOrPreceding
	: /*empty*/
	| IntegerOrUnbounded PRECEDING
	| CURRENT ROW
	;

///OptionalCurrentOrPreceding_EDIT
///	: IntegerOrUnbounded CURSOR
///	| CURRENT CURSOR
///	;

OptionalAndFollowing
	: /*empty*/
	| AND CURRENT ROW
	| AND IntegerOrUnbounded FOLLOWING
	;

///OptionalAndFollowing_EDIT
///	: AND CURSOR
///	| AND CURRENT CURSOR
///	| AND IntegerOrUnbounded CURSOR
///	;

IntegerOrUnbounded
	: UNSIGNED_INTEGER
	| UNBOUNDED
	;


//#file	sql_valueExpression.jison



ValueExpression
	: NOT ValueExpression
	| '!' ValueExpression
	| '~' ValueExpression
	| '-' ValueExpression %prec NEGATION
	| ValueExpression IS OptionalNot NULL
	| ValueExpression IS OptionalNot TRUE
	| ValueExpression IS OptionalNot FALSE
	| ValueExpression IS OptionalNot DISTINCT FROM ValueExpression
	;

///ValueExpression_EDIT
///	: NOT ValueExpression_EDIT
///	| NOT CURSOR
///	| '!' ValueExpression_EDIT
///	| '!' AnyCursor
///	| '~' ValueExpression_EDIT
///	| '~' PARTIAL_CURSOR
///	| '-' ValueExpression_EDIT %prec NEGATION
///	| '-' PARTIAL_CURSOR %prec NEGATION
///	| ValueExpression IS CURSOR
///	| ValueExpression IS NOT CURSOR
///	| ValueExpression IS OptionalNot DISTINCT CURSOR
///	| ValueExpression IS CURSOR NULL
///	| ValueExpression IS CURSOR FALSE
///	| ValueExpression IS CURSOR TRUE
///	| ValueExpression IS OptionalNot DISTINCT FROM PartialBacktickedOrAnyCursor
///	| ValueExpression IS OptionalNot DISTINCT FROM ValueExpression_EDIT
///	;

// ------------------  EXISTS and parenthesized ------------------
ValueExpression
	: EXISTS TableSubQuery
	| '(' ValueExpression ')'
	;

///ValueExpression_EDIT
///	: EXISTS TableSubQuery_EDIT
///	| '(' ValueExpression_EDIT RightParenthesisOrError
///	| '(' CURSOR RightParenthesisOrError
///	;

// ------------------  COMPARISON ------------------

ValueExpression
	: ValueExpression '=' ValueExpression
	| ValueExpression '<' ValueExpression
	| ValueExpression '>' ValueExpression
	| ValueExpression COMPARISON_OPERATOR ValueExpression
	;

///ValueExpression_EDIT
///	: CURSOR '=' ValueExpression
///	| CURSOR '<' ValueExpression
///	| CURSOR '>' ValueExpression
///	| CURSOR COMPARISON_OPERATOR ValueExpression
///	| ValueExpression_EDIT '=' ValueExpression
///	| ValueExpression_EDIT '<' ValueExpression
///	| ValueExpression_EDIT '>' ValueExpression
///	| ValueExpression_EDIT COMPARISON_OPERATOR ValueExpression
///	| ValueExpression '=' PartialBacktickedOrAnyCursor
///	| ValueExpression '<' PartialBacktickedOrAnyCursor
///	| ValueExpression '>' PartialBacktickedOrAnyCursor
///	| ValueExpression COMPARISON_OPERATOR PartialBacktickedOrAnyCursor
///	| ValueExpression '=' ValueExpression_EDIT
///	| ValueExpression '<' ValueExpression_EDIT
///	| ValueExpression '>' ValueExpression_EDIT
///	| ValueExpression COMPARISON_OPERATOR ValueExpression_EDIT
///	;


// ------------------  IN ------------------

ValueExpression
	: ValueExpression NOT IN '(' TableSubQueryInner ')'
	| ValueExpression NOT IN '(' ValueExpressionList ')'
	| ValueExpression IN '(' TableSubQueryInner ')'
	| ValueExpression IN '(' ValueExpressionList ')'
	;

///ValueExpression_EDIT
///	: ValueExpression NOT IN ValueExpressionInSecondPart_EDIT
///	| ValueExpression IN ValueExpressionInSecondPart_EDIT
///	| ValueExpression_EDIT NOT IN '(' ValueExpressionList RightParenthesisOrError
///	| ValueExpression_EDIT NOT IN '(' TableSubQueryInner RightParenthesisOrError
///	| ValueExpression_EDIT IN '(' ValueExpressionList RightParenthesisOrError
///	| ValueExpression_EDIT IN '(' TableSubQueryInner RightParenthesisOrError
///	;

///ValueExpressionInSecondPart_EDIT
///	: '(' TableSubQueryInner_EDIT RightParenthesisOrError
///	| '(' ValueExpressionList_EDIT RightParenthesisOrError
///	| '(' AnyCursor RightParenthesisOrError
///	;

// ------------------  BETWEEN ------------------

ValueExpression
	: ValueExpression NOT BETWEEN ValueExpression BETWEEN_AND ValueExpression
	| ValueExpression BETWEEN ValueExpression BETWEEN_AND ValueExpression
	;

///ValueExpression_EDIT
///	: ValueExpression_EDIT NOT BETWEEN ValueExpression BETWEEN_AND ValueExpression
///	| ValueExpression NOT BETWEEN ValueExpression_EDIT BETWEEN_AND ValueExpression
///	| ValueExpression NOT BETWEEN ValueExpression BETWEEN_AND ValueExpression_EDIT
///	| ValueExpression NOT BETWEEN ValueExpression BETWEEN_AND CURSOR
///	| ValueExpression NOT BETWEEN ValueExpression CURSOR
///	| ValueExpression NOT BETWEEN CURSOR
///	| ValueExpression_EDIT BETWEEN ValueExpression BETWEEN_AND ValueExpression
///	| ValueExpression BETWEEN ValueExpression_EDIT BETWEEN_AND ValueExpression
///	| ValueExpression BETWEEN ValueExpression BETWEEN_AND ValueExpression_EDIT
///	| ValueExpression BETWEEN ValueExpression BETWEEN_AND CURSOR
///	| ValueExpression BETWEEN ValueExpression CURSOR
///	| ValueExpression BETWEEN CURSOR
///	;

// ------------------  BOOLEAN ------------------

ValueExpression
	: ValueExpression OR ValueExpression
	| ValueExpression AND ValueExpression
	;

///ValueExpression_EDIT
///	: CURSOR OR ValueExpression
///	| ValueExpression_EDIT OR ValueExpression
///	| ValueExpression OR PartialBacktickedOrAnyCursor
///	| ValueExpression OR ValueExpression_EDIT
///	| CURSOR AND ValueExpression
///	| ValueExpression_EDIT AND ValueExpression
///	| ValueExpression AND PartialBacktickedOrAnyCursor
///	| ValueExpression AND ValueExpression_EDIT
///	;

// ------------------  ARITHMETIC ------------------

ValueExpression
	: ValueExpression '-' ValueExpression
	| ValueExpression '+' ValueExpression
	| ValueExpression '*' ValueExpression
	| ValueExpression ARITHMETIC_OPERATOR ValueExpression
	;

///ValueExpression_EDIT
///	: CURSOR '*' ValueExpression
///	| CURSOR ARITHMETIC_OPERATOR ValueExpression
///	| ValueExpression_EDIT '-' ValueExpression
///	| ValueExpression_EDIT '+' ValueExpression
///	| ValueExpression_EDIT '*' ValueExpression
///	| ValueExpression_EDIT ARITHMETIC_OPERATOR ValueExpression
///	| ValueExpression '-' PartialBacktickedOrAnyCursor
///	| ValueExpression '+' PartialBacktickedOrAnyCursor
///	| ValueExpression '*' PartialBacktickedOrAnyCursor
///	| ValueExpression ARITHMETIC_OPERATOR PartialBacktickedOrAnyCursor
///	| ValueExpression '-' ValueExpression_EDIT
///	| ValueExpression '+' ValueExpression_EDIT
///	| ValueExpression '*' ValueExpression_EDIT
///	| ValueExpression ARITHMETIC_OPERATOR ValueExpression_EDIT
///	;

// ------------------  LIKE, RLIKE and REGEXP ------------------

ValueExpression
	: ValueExpression LikeRightPart
	| ValueExpression NOT LikeRightPart
	;

LikeRightPart
	: LIKE ValueExpression
	| RLIKE ValueExpression
	| REGEXP ValueExpression
	;

///LikeRightPart_EDIT
///	: LIKE ValueExpression_EDIT
///	| RLIKE ValueExpression_EDIT
///	| REGEXP ValueExpression_EDIT
///	| LIKE PartialBacktickedOrCursor
///	| RLIKE PartialBacktickedOrCursor
///	| REGEXP PartialBacktickedOrCursor
///	;

///ValueExpression_EDIT
///	: ValueExpression_EDIT LikeRightPart
///	| ValueExpression_EDIT NOT LikeRightPart
///	| ValueExpression LikeRightPart_EDIT
///	| ValueExpression NOT LikeRightPart_EDIT
///	| CURSOR LikeRightPart
///	| CURSOR NOT LikeRightPart
///	;

// ------------------  CASE, WHEN, THEN ------------------

ValueExpression
	: CASE CaseRightPart
	| CASE ValueExpression CaseRightPart
	;

///ValueExpression_EDIT
///	: CASE CaseRightPart_EDIT
///	| CASE CURSOR EndOrError
///	| CASE ValueExpression CaseRightPart_EDIT
///	| CASE ValueExpression CURSOR EndOrError
///	| CASE ValueExpression_EDIT CaseRightPart
///	| CASE ValueExpression_EDIT EndOrError
///	| CASE CURSOR CaseRightPart
///	;

CaseRightPart
	: CaseWhenThenList END
	| CaseWhenThenList ELSE ValueExpression END
	;

///CaseRightPart_EDIT
///	: CaseWhenThenList_EDIT EndOrError
///	| CaseWhenThenList ELSE ValueExpression CURSOR
///	| CaseWhenThenList_EDIT ELSE ValueExpression EndOrError
///	| CaseWhenThenList_EDIT ELSE EndOrError
///	| CaseWhenThenList CURSOR ValueExpression EndOrError
///	| CaseWhenThenList CURSOR EndOrError
///	| CaseWhenThenList ELSE ValueExpression_EDIT EndOrError
///	| CaseWhenThenList ELSE CURSOR EndOrError
///	| ELSE CURSOR EndOrError
///	| CURSOR ELSE ValueExpression EndOrError
///	| CURSOR ELSE EndOrError
///	;

///EndOrError
///	: END
///	| error
///	;

CaseWhenThenList
	: CaseWhenThenListPartTwo
	| CaseWhenThenList CaseWhenThenListPartTwo
	;

///CaseWhenThenList_EDIT
///	: CaseWhenThenListPartTwo_EDIT
///	| CaseWhenThenList CaseWhenThenListPartTwo_EDIT
///	| CaseWhenThenList CaseWhenThenListPartTwo_EDIT CaseWhenThenList
///	| CaseWhenThenList CURSOR CaseWhenThenList
///	| CaseWhenThenListPartTwo_EDIT CaseWhenThenList
///	;

CaseWhenThenListPartTwo
	: WHEN ValueExpression THEN ValueExpression
	;

///CaseWhenThenListPartTwo_EDIT
///	: WHEN ValueExpression_EDIT
///	| WHEN ValueExpression_EDIT THEN
///	| WHEN ValueExpression_EDIT THEN ValueExpression
///	| WHEN ValueExpression THEN ValueExpression_EDIT
///	| WHEN THEN ValueExpression_EDIT
///	| CURSOR ValueExpression THEN
///	| CURSOR ValueExpression THEN ValueExpression
///	| CURSOR THEN
///	| CURSOR THEN ValueExpression
///	| WHEN CURSOR
///	| WHEN CURSOR ValueExpression
///	| WHEN CURSOR THEN
///	| WHEN CURSOR THEN ValueExpression
///	| WHEN ValueExpression CURSOR
///	| WHEN ValueExpression CURSOR ValueExpression
///	| WHEN ValueExpression THEN CURSOR
///	| WHEN ValueExpression THEN CURSOR ValueExpression
///	| WHEN THEN CURSOR ValueExpression
///	| WHEN THEN CURSOR
///	;


//#file	syntax_footer.jison



%%

%option caseless

%%

\s+                                         skip()
"--".*                                     skip()
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]        skip()

//\u2020                                    CURSOR
//\u2021                                    PARTIAL_CURSOR

//<between>AND                             BETWEEN_AND

// Reserved Keywords
ALL                                       ALL
ALTER                                    ALTER
AND                                       AND
AS                                        AS
ASC                                       ASC
BETWEEN                                  BETWEEN
BIGINT                                    BIGINT
BOOLEAN                                   BOOLEAN
BY                                        BY
CASCADE                                   CASCADE
CASE                                      CASE
CHAR                                      CHAR
COMMENT                                   COMMENT
CREATE                                   CREATE
CROSS                                     CROSS
CURRENT                                   CURRENT
DATABASE                                  DATABASE
DECIMAL                                   DECIMAL
DESC                                      DESC
DISTINCT                                  DISTINCT
DIV                                       ARITHMETIC_OPERATOR
DOUBLE                                    DOUBLE
DROP                                     DROP
ELSE                                      ELSE
END                                       END
EXISTS                                   EXISTS
FALSE                                     FALSE
FLOAT                                     FLOAT
FOLLOWING                                 FOLLOWING
FROM                                     FROM
FULL                                      FULL
GROUP                                     GROUP
HAVING                                    HAVING
IF                                        IF
IN                                        IN
INNER                                     INNER
INSERT                                    INSERT
INT                                       INT
INTO                                      INTO
IS                                        IS
JOIN                                      JOIN
LEFT                                      LEFT
LIKE                                      LIKE
LIMIT                                     LIMIT
NOT                                       NOT
NULL                                      NULL
ON                                        ON
OPTION                                    OPTION
OR                                        OR
ORDER                                     ORDER
OUTER                                     OUTER
PARTITION                                 PARTITION
PRECEDING                                 PRECEDING
PURGE                                     PURGE
RANGE                                     RANGE
REGEXP                                    REGEXP
RIGHT                                     RIGHT
RLIKE                                     RLIKE
ROW                                       ROW
ROLE                                      ROLE
ROWS                                      ROWS
SCHEMA                                    SCHEMA
SELECT                                   SELECT
SEMI                                      SEMI
SET                                      SET
//SHOW                                     SHOW
SMALLINT                                  SMALLINT
STRING                                    STRING
TABLE                                     TABLE
THEN                                      THEN
TIMESTAMP                                 TIMESTAMP
TINYINT                                   TINYINT
//TO                                        TO
TRUE                                      TRUE
TRUNCATE                                 TRUNCATE
UNBOUNDED                                 UNBOUNDED
UNION                                     UNION
UPDATE                                   UPDATE
USE                                      USE
VALUES                                    VALUES
VARCHAR                                   VARCHAR
VIEW                                      VIEW
WHEN                                      WHEN
WHERE                                     WHERE
WITH                                     WITH

// Non-reserved Keywords
OVER                                      OVER
ROLE                                      ROLE
ARRAY	ARRAY
MAP	MAP
STRUCT	STRUCT
BETWEEN_AND	BETWEEN_AND

// --- UDFs ---
AVG\s*\(                                   AVG
CAST\s*\(                                  CAST
COUNT\s*\(                                 COUNT
MAX\s*\(                                   MAX
MIN\s*\(                                   MIN
STDDEV_POP\s*\(                            STDDEV_POP
STDDEV_SAMP\s*\(                           STDDEV_SAMP
SUM\s*\(                                   SUM
VAR_POP\s*\(                               VAR_POP
VAR_SAMP\s*\(                              VAR_SAMP
VARIANCE\s*\(                              VARIANCE

// Analytical functions
CUME_DIST\s*\(                             ANALYTIC
DENSE_RANK\s*\(                            ANALYTIC
FIRST_VALUE\s*\(                           ANALYTIC
LAG\s*\(                                   ANALYTIC
LAST_VALUE\s*\(                            ANALYTIC
LEAD\s*\(                                  ANALYTIC
RANK\s*\(                                  ANALYTIC
ROW_NUMBER\s*\(                            ANALYTIC

[0-9]+                                      UNSIGNED_INTEGER
[0-9]+(?:[YSL]|BD)?                         UNSIGNED_INTEGER
[0-9]+E                                     UNSIGNED_INTEGER_E
[A-Za-z0-9_]+                               REGULAR_IDENTIFIER

//<hdfs>'\u2020'                             { parser.yy.cursorFound = true; return 'CURSOR
//<hdfs>'\u2021'                             { parser.yy.cursorFound = true; return 'PARTIAL_CURSOR
//<hdfs>\s+['"]                               HDFS_START_QUOTE
//<hdfs>[^'"\u2020\u2021]+                   { parser.addFileLocation(yylloc, yytext); return 'HDFS_PATH
//<hdfs>['"]                                 { this.popState(); return 'HDFS_END_QUOTE
//<hdfs><<EOF>>                               EOF

"&&"                                        AND
"||"                                        OR

"="                                         '='
"<"                                         '<'
">"                                         '>'
"!="                                        COMPARISON_OPERATOR
"<="                                        COMPARISON_OPERATOR
">="                                        COMPARISON_OPERATOR
"<>"                                        COMPARISON_OPERATOR
"<=>"                                       COMPARISON_OPERATOR

"-"                                        '-'
"*"                                         '*'
"+"                                         '+'
"/"                                         ARITHMETIC_OPERATOR
"%"                                         ARITHMETIC_OPERATOR
"|"                                         ARITHMETIC_OPERATOR
"^"                                         ARITHMETIC_OPERATOR
"&"                                         ARITHMETIC_OPERATOR

","                                         ','
"."                                         '.'
":"                                         ':'
";"                                         ';'
"~"                                        '~'
"!"                                         '!'

"("                                         '('
")"                                         ')'
//"["                                         '['
//"]"                                         ']'

\$\{[^}]*\}                                 VARIABLE_REFERENCE

\`(\\.|[^`\n\r\\])*\`                                         BACKTICKEDIDENTIFIER
'(\\.|[^'\n\r\\])*\'                                         SINGLEQUOTEDVALUE
\"(\\.|[^"\n\r\\])*\"                                         DOUBLEQUOTEDVALUE

//<<EOF>>                                     EOF

//.                                          { /* To prevent console logging of unknown chars */ }

%%
