//From: https://github.com/couchbase/query/blob/86f890d9081b4a5cd2ac1583b1107cfc9bfdc14d/parser/n1ql/n1ql.y

/*Tokens*/
///%token _ERROR_
%token _INDEX_CONDITION
%token _INDEX_KEY
%token ADVISE
%token ALL
%token ALTER
%token ANALYZE
%token AND
%token ANY
%token ARRAY
%token AS
%token ASC
%token AT
%token BEGIN
%token BETWEEN
///%token BINARY
///%token BOOLEAN
///%token BREAK
///%token BUCKET
%token BUILD
%token BY
///%token CALL
%token CACHE
%token CASE
///%token CAST
///%token CLUSTER
///%token COLLATE
%token COLLECTION
%token COMMIT
%token COMMITTED
///%token CONNECT
///%token CONTINUE
%token _CORRELATED
%token _COVER
%token CREATE
%token CURRENT
%token CYCLE
///%token DATABASE
///%token DATASET
///%token DATASTORE
///%token DECLARE
///%token DECREMENT
%token DEFAULT
%token DELETE
///%token DERIVED
%token DESC
///%token DESCRIBE
%token DISTINCT
///%token DO
%token DROP
%token EACH
%token ELEMENT
%token ELSE
%token END
%token EVERY
%token EXCEPT
%token EXCLUDE
%token EXECUTE
%token EXISTS
%token EXPLAIN
%token FALSE
///%token FETCH
%token FILTER
%token FIRST
%token FLATTEN
%token FLATTEN_KEYS
%token FLUSH
%token FOLLOWING
%token FOR
%token FORCE
%token FROM
%token FTS
%token FUNCTION
%token GOLANG
%token GRANT
%token GROUP
%token GROUPS
%token GSI
%token HASH
%token HAVING
%token IF
%token IGNORE
///%token ILIKE
%token IN
%token INCLUDE
%token INCREMENT
%token INDEX
%token INFER
%token INLINE
%token INNER
%token INSERT
%token INTERSECT
%token INTO
%token IS
%token ISOLATION
%token JAVASCRIPT
%token JOIN
%token KEY
%token KEYS
%token KEYSPACE
%token KNOWN
%token LANGUAGE
%token LAST
%token LATERAL
%token LEFT
%token LET
%token LETTING
%token LEVEL
%token LIKE
%token ESCAPE
%token LIMIT
///%token LSM
///%token MAP
///%token MAPPING
%token MATCHED
///%token MATERIALIZED
%token MAXVALUE
%token MERGE
%token MINUS
%token MISSING
%token MINVALUE
///%token NAMESPACE
%token NAMESPACE_ID
%token NEST
%token NEXT
%token NEXTVAL
%token NL
%token NO
%token NOT
///%token NOT_A_TOKEN
%token NTH_VALUE
%token NULL
%token NULLS
///%token NUMBER
%token OBJECT
%token OFFSET
%token ON
///%token OPTION
%token OPTIONS
%token OR
%token ORDER
%token OTHERS
%token OUTER
%token OVER
///%token PARSE
%token PARTITION
///%token PASSWORD
///%token PATH
///%token POOL
%token PRECEDING
%token PREPARE
%token PREV
%token PREVVAL
%token PRIMARY
///%token PRIVATE
///%token PRIVILEGE
%token PROBE
///%token PROCEDURE
///%token PUBLIC
%token RANGE
%token RAW
%token READ
///%token REALM
%token RECURSIVE
///%token REDUCE
///%token RENAME
%token REPLACE
%token RESPECT
%token RESTART
%token RESTRICT
///%token RETURN
%token RETURNING
%token REVOKE
%token RIGHT
///%token ROLE
%token ROLLBACK
%token ROW
%token ROWS
%token SATISFIES
%token SAVEPOINT
///%token SCHEMA
%token SCOPE
%token SELECT
%token SELF
%token SEMI
%token SET
%token SEQUENCE
///%token SHOW
%token SOME
%token START
%token STATISTICS
///%token STRING
%token SYSTEM
%token THEN
%token TIES
%token TO
%token TRAN
%token TRANSACTION
///%token TRIGGER
%token TRUE
%token TRUNCATE
%token UNBOUNDED
///%token UNDER
%token UNION
///%token UNIQUE
%token UNKNOWN
%token UNNEST
%token UNSET
%token UPDATE
%token UPSERT
%token USE
///%token USER
%token USING
%token VALIDATE
%token VALUE
%token VALUED
%token VALUES
///%token VIA
%token VIEW
%token WHEN
%token WHERE
///%token WHILE
%token WINDOW
%token WITH
%token WITHIN
%token WORK
///%token XOR
%token INT
%token NUM
%token STR
%token IDENT
%token IDENT_ICASE
%token NAMED_PARAM
%token POSITIONAL_PARAM
%token NEXT_PARAM
%token OPTIM_HINTS
%token RANDOM_ELEMENT
%token LPAREN
%token RPAREN
%token LBRACE
%token RBRACE
%token LBRACKET
%token RBRACKET
%token RBRACKET_ICASE
%token COMMA
%token COLON
%token EQ
%token DEQ
%token NE
%token LT
%token GT
%token LE
%token GE
%token CONCAT
%token PLUS
%token STAR
%token DIV
%token MOD
%token POW
///%token UMINUS
%token DOT

%left /*1*/ ORDER
%left /*2*/ EXCEPT INTERSECT UNION
%left /*3*/ FLATTEN INNER JOIN LEFT NEST RIGHT UNNEST
%left /*4*/ OR
%left /*5*/ AND
%right /*6*/ NOT
%nonassoc /*7*/ EQ DEQ NE
%nonassoc /*8*/ LT GT LE GE
%nonassoc /*9*/ LIKE
%nonassoc /*10*/ ESCAPE
%nonassoc /*11*/ BETWEEN
%nonassoc /*12*/ IN WITHIN
%nonassoc /*13*/ EXISTS
%nonassoc /*14*/ IS
%left /*15*/ FROM
%left /*16*/ CONCAT
%left /*17*/ MINUS PLUS
%left /*18*/ STAR DIV MOD POW
%right /*19*/ _INDEX_CONDITION _INDEX_KEY _COVER
%left /*20*/ ALL
%right /*21*/ UMINUS
%left /*22*/ LBRACKET RBRACKET DOT
%left /*23*/ LPAREN RPAREN

%start input

%%

input :
	commands //stmt_body opt_trailer
	| expr_input
	| hints_input
	;

commands :
    stmt_body SEMI
    | commands stmt_body SEMI
    ;

ident_or_default :
	IDENT
	| DEFAULT
	;

opt_trailer :
	/*empty*/
	| opt_trailer SEMI
	;

stmt_body :
	advise
	| explain
	| prepare
	| execute
	| explain_function
	| stmt
	;

stmt :
	select_stmt
	| dml_stmt
	| ddl_stmt
	| infer
	| update_statistics
	| role_stmt
	| function_stmt
	| transaction_stmt
	| sequence_stmt
	;

advise :
	ADVISE opt_index stmt
	;

opt_index :
	/*empty*/
	| INDEX
	;

explain :
	EXPLAIN stmt
	;

explain_function :
	EXPLAIN FUNCTION func_name
	;

prepare :
	PREPARE opt_force opt_name stmt
	;

opt_force :
	/*empty*/
	| FORCE
	;

opt_name :
	/*empty*/
	| ident_or_default from_or_as
	| _invalid_case_insensitive_identifier from_or_as
	| STR from_or_as
	;

_invalid_case_insensitive_identifier :
	IDENT_ICASE
	;

from_or_as :
	FROM /*15L*/
	| AS
	;

execute :
	EXECUTE expr execute_using
	;

execute_using :
	/*empty*/
	| USING construction_expr
	;

infer :
	INFER keyspace_collection simple_keyspace_ref opt_infer_using opt_with_clause
	| INFER keyspace_path opt_as_alias opt_infer_using opt_with_clause
	| INFER expr opt_infer_using opt_with_clause
	;

keyspace_collection :
	KEYSPACE
	| COLLECTION
	;

opt_keyspace_collection :
	/*empty*/
	| keyspace_collection
	;

opt_infer_using :
	/*empty*/
	;

select_stmt :
	fullselect
	;

dml_stmt :
	insert
	| upsert
	| delete
	| update
	| merge
	;

ddl_stmt :
	index_stmt
	| scope_stmt
	| collection_stmt
	;

role_stmt :
	grant_role
	| revoke_role
	;

index_stmt :
	create_index
	| drop_index
	| alter_index
	| build_index
	;

scope_stmt :
	create_scope
	| drop_scope
	;

collection_stmt :
	create_collection
	| drop_collection
	| flush_collection
	;

function_stmt :
	create_function
	| drop_function
	| execute_function
	;

transaction_stmt :
	start_transaction
	| commit_transaction
	| rollback_transaction
	| savepoint
	| set_transaction_isolation
	;

fullselect :
	select_terms opt_order_by
	| select_terms opt_order_by limit opt_offset
	| select_terms opt_order_by offset opt_limit
	| with select_terms opt_order_by
	| with select_terms opt_order_by limit opt_offset
	| with select_terms opt_order_by offset opt_limit
	;

select_terms :
	subselect
	| select_terms setop select_term
	| subquery_expr setop select_term
	;

select_term :
	subselect
	| subquery_expr
	;

subselect :
	from_select
	| select_from
	;

from_select :
	from opt_let opt_where opt_group opt_window_clause SELECT opt_optim_hints projection
	;

select_from :
	SELECT opt_optim_hints projection opt_from opt_let opt_where opt_group opt_window_clause
	;

setop :
	UNION /*2L*/
	| UNION /*2L*/ ALL /*20L*/
	| INTERSECT /*2L*/
	| INTERSECT /*2L*/ ALL /*20L*/
	| EXCEPT /*2L*/
	| EXCEPT /*2L*/ ALL /*20L*/
	;

opt_optim_hints :
	/*empty*/
	| OPTIM_HINTS
	;

hints_input :
	PLUS /*17L*/ optim_hints
	| PLUS /*17L*/ object
	;

optim_hints :
	optim_hint
	| optim_hints optim_hint
	;

optim_hint :
	ident_or_default
	| ident_or_default LPAREN /*23L*/ opt_hint_args RPAREN /*23L*/
	| INDEX LPAREN /*23L*/ opt_hint_args RPAREN /*23L*/
	;

opt_hint_args :
	/*empty*/
	| hint_args
	;

hint_args :
	ident_or_default
	| ident_or_default DIV /*18L*/ BUILD
	| ident_or_default DIV /*18L*/ PROBE
	| hint_args ident_or_default
	;

projection :
	opt_quantifier projects opt_exclude
	| opt_quantifier raw expr opt_as_alias
	;

opt_quantifier :
	/*empty*/
	| ALL /*20L*/
	| DISTINCT
	;

opt_exclude :
	/*empty*/
	| EXCLUDE exprs
	;

raw :
	RAW
	| ELEMENT
	| VALUE
	;

projects :
	project
	| projects COMMA project
	;

project :
	STAR /*18L*/
	| expr DOT /*22L*/ STAR /*18L*/
	| expr opt_as_alias
	;

opt_as_alias :
	/*empty*/
	| as_alias
	;

as_alias :
	alias
	| AS alias
	;

alias :
	ident_or_default
	;

opt_from :
	/*empty*/
	| from
	;

from :
	FROM /*15L*/ from_terms
	;

from_terms :
	from_term
	| from_terms COMMA from_term
	| from_terms COMMA LATERAL from_term
	;

from_term :
	simple_from_term
	| from_term opt_join_type JOIN /*3L*/ simple_from_term on_keys
	| from_term opt_join_type JOIN /*3L*/ LATERAL simple_from_term on_keys
	| from_term opt_join_type JOIN /*3L*/ simple_from_term on_key FOR ident_or_default
	| from_term opt_join_type JOIN /*3L*/ LATERAL simple_from_term on_key FOR ident_or_default
	| from_term opt_join_type NEST /*3L*/ simple_from_term on_keys
	| from_term opt_join_type NEST /*3L*/ LATERAL simple_from_term on_keys
	| from_term opt_join_type NEST /*3L*/ simple_from_term on_key FOR ident_or_default
	| from_term opt_join_type NEST /*3L*/ LATERAL simple_from_term on_key FOR ident_or_default
	| from_term opt_join_type unnest expr opt_as_alias
	| from_term opt_join_type JOIN /*3L*/ simple_from_term ON expr
	| from_term opt_join_type JOIN /*3L*/ LATERAL simple_from_term ON expr
	| from_term opt_join_type NEST /*3L*/ simple_from_term ON expr
	| from_term opt_join_type NEST /*3L*/ LATERAL simple_from_term ON expr
	| simple_from_term RIGHT /*3L*/ opt_outer JOIN /*3L*/ simple_from_term ON expr
	| simple_from_term RIGHT /*3L*/ opt_outer JOIN /*3L*/ LATERAL simple_from_term ON expr
	;

simple_from_term :
	keyspace_term
	| expr opt_as_alias opt_use
	;

unnest :
	UNNEST /*3L*/
	| FLATTEN /*3L*/
	;

keyspace_term :
	keyspace_path opt_as_alias opt_use
	;

keyspace_path :
	namespace_term keyspace_name
	| namespace_term path_part DOT /*22L*/ path_part DOT /*22L*/ keyspace_name
	;

namespace_term :
	namespace_name
	| SYSTEM COLON
	;

namespace_name :
	NAMESPACE_ID COLON
	;

path_part :
	ident_or_default
	;

keyspace_name :
	ident_or_default
	| _invalid_case_insensitive_identifier
	;

opt_use :
	/*empty*/
	| USE use_options
	;

use_options :
	use_keys
	| use_index
	| join_hint
	| use_index join_hint
	| join_hint use_index
	| use_keys join_hint
	| join_hint use_keys
	;

use_keys :
	opt_primary KEYS expr
	| opt_primary KEYS VALIDATE expr
	;

use_index :
	INDEX LPAREN /*23L*/ index_refs RPAREN /*23L*/
	;

join_hint :
	HASH LPAREN /*23L*/ use_hash_option RPAREN /*23L*/
	| NL
	;

opt_primary :
	/*empty*/
	| PRIMARY
	;

index_refs :
	index_ref
	| index_refs COMMA index_ref
	;

index_ref :
	opt_index_name opt_index_using
	;

use_hash_option :
	BUILD
	| PROBE
	;

opt_use_del_upd :
	opt_use
	;

opt_join_type :
	/*empty*/
	| INNER /*3L*/
	| LEFT /*3L*/ opt_outer
	;

opt_outer :
	/*empty*/
	| OUTER
	;

on_keys :
	ON opt_primary KEYS expr
	| ON opt_primary KEYS VALIDATE expr
	;

on_key :
	ON opt_primary KEY expr
	| ON opt_primary KEY VALIDATE expr
	;

opt_let :
	/*empty*/
	| let
	;

let :
	LET bindings
	;

bindings :
	binding
	| bindings COMMA binding
	;

binding :
	alias EQ /*7N*/ expr
	;

with :
	WITH with_list
	| WITH RECURSIVE with_list
	;

with_list :
	with_term
	| with_list COMMA with_term
	;

with_term :
	alias AS paren_expr opt_cycle_clause opt_option_clause
	;

opt_option_clause :
	/*empty*/
	| OPTIONS object
	;

opt_cycle_clause :
	/*empty*/
	| CYCLE exprs RESTRICT
	;

opt_where :
	/*empty*/
	| where
	;

where :
	WHERE expr
	;

opt_group :
	/*empty*/
	| group
	;

group :
	GROUP BY group_terms opt_group_as opt_letting opt_having
	| letting
	;

group_terms :
	group_term
	| group_terms COMMA group_term
	;

group_term :
	expr opt_as_alias
	;

opt_letting :
	/*empty*/
	| letting
	;

letting :
	LETTING bindings
	;

opt_having :
	/*empty*/
	| having
	;

having :
	HAVING expr
	;

opt_group_as :
	/*empty*/
	| GROUP AS ident_or_default
	;

opt_order_by :
	/*empty*/
	| order_by
	;

order_by :
	ORDER /*1L*/ BY sort_terms
	;

sort_terms :
	sort_term
	| sort_terms COMMA sort_term
	;

sort_term :
	expr opt_dir opt_order_nulls
	;

opt_dir :
	/*empty*/
	| dir
	;

dir :
	param_expr
	| ASC
	| DESC
	;

opt_order_nulls :
	/*empty*/
	| NULLS FIRST
	| NULLS LAST
	| NULLS param_expr
	;

first_last :
	FIRST
	| LAST
	;

opt_limit :
	/*empty*/
	| limit
	;

limit :
	LIMIT expr
	;

opt_offset :
	/*empty*/
	| offset
	;

offset :
	OFFSET expr
	;

insert :
	INSERT INTO keyspace_ref opt_values_header values_list opt_returning
	| INSERT INTO keyspace_ref LPAREN /*23L*/ key_val_options_expr_header RPAREN /*23L*/ fullselect opt_returning
	;

simple_keyspace_ref :
	keyspace_name opt_as_alias
	| path_part DOT /*22L*/ path_part opt_as_alias
	| keyspace_path opt_as_alias
	| path_part DOT /*22L*/ path_part DOT /*22L*/ keyspace_name opt_as_alias
	;

keyspace_ref :
	simple_keyspace_ref
	| param_expr opt_as_alias
	;

opt_values_header :
	/*empty*/
	| LPAREN /*23L*/ opt_primary KEY COMMA VALUE RPAREN /*23L*/
	| LPAREN /*23L*/ opt_primary KEY COMMA VALUE COMMA OPTIONS RPAREN /*23L*/
	;

key :
	opt_primary KEY
	;

values_list :
	values
	| values_list COMMA next_values
	;

values :
	VALUES key_val_expr
	| VALUES key_val_options_expr
	;

next_values :
	values
	| key_val_expr
	| key_val_options_expr
	;

key_val_expr :
	LPAREN /*23L*/ expr COMMA expr RPAREN /*23L*/
	;

key_val_options_expr :
	LPAREN /*23L*/ expr COMMA expr COMMA expr RPAREN /*23L*/
	;

opt_returning :
	/*empty*/
	| returning
	;

returning :
	RETURNING returns
	;

returns :
	projects
	| raw expr
	;

key_expr_header :
	key expr
	;

value_expr_header :
	VALUE expr
	;

options_expr_header :
	OPTIONS expr
	;

key_val_options_expr_header :
	key_expr_header
	| key_expr_header COMMA value_expr_header
	| key_expr_header COMMA value_expr_header COMMA options_expr_header
	| key_expr_header COMMA options_expr_header
	;

upsert :
	UPSERT INTO keyspace_ref opt_values_header values_list opt_returning
	| UPSERT INTO keyspace_ref LPAREN /*23L*/ key_val_options_expr_header RPAREN /*23L*/ fullselect opt_returning
	;

delete :
	DELETE opt_optim_hints FROM /*15L*/ keyspace_ref opt_use_del_upd opt_where limit opt_offset opt_returning
	| DELETE opt_optim_hints FROM /*15L*/ keyspace_ref opt_use_del_upd opt_where offset opt_limit opt_returning
	| DELETE opt_optim_hints FROM /*15L*/ keyspace_ref opt_use_del_upd opt_where opt_returning
	;

update :
	UPDATE opt_optim_hints keyspace_ref opt_use_del_upd set unset opt_where opt_limit opt_returning
	| UPDATE opt_optim_hints keyspace_ref opt_use_del_upd set opt_where opt_limit opt_returning
	| UPDATE opt_optim_hints keyspace_ref opt_use_del_upd unset opt_where opt_limit opt_returning
	;

set :
	SET set_terms
	;

set_terms :
	set_term
	| set_terms COMMA set_term
	;

set_term :
	path EQ /*7N*/ expr opt_update_for
	| function_meta_expr DOT /*22L*/ path EQ /*7N*/ expr
	;

function_meta_expr :
	function_name LPAREN /*23L*/ opt_exprs RPAREN /*23L*/
	;

opt_update_for :
	/*empty*/
	| update_for
	;

update_for :
	update_dimensions opt_when END
	;

update_dimensions :
	FOR update_dimension
	| update_dimensions FOR update_dimension
	;

update_dimension :
	update_binding
	| update_dimension COMMA update_binding
	;

update_binding :
	variable IN /*12N*/ expr
	| variable WITHIN /*12N*/ expr
	| variable COLON variable IN /*12N*/ expr
	| variable COLON variable WITHIN /*12N*/ expr
	;

variable :
	ident_or_default
	;

opt_when :
	/*empty*/
	| WHEN expr
	;

unset :
	UNSET unset_terms
	;

unset_terms :
	unset_term
	| unset_terms COMMA unset_term
	;

unset_term :
	path opt_update_for
	;

merge :
	MERGE opt_optim_hints INTO simple_keyspace_ref opt_use_merge USING simple_from_term ON opt_key expr merge_actions opt_limit opt_returning
	;

opt_use_merge :
	opt_use
	;

opt_key :
	/*empty*/
	| key
	;

merge_actions :
	/*empty*/
	| WHEN MATCHED THEN UPDATE merge_update opt_merge_delete_insert
	| WHEN MATCHED THEN DELETE merge_delete opt_merge_insert
	| WHEN NOT /*6R*/ MATCHED THEN INSERT merge_insert
	;

opt_merge_delete_insert :
	/*empty*/
	| WHEN MATCHED THEN DELETE merge_delete opt_merge_insert
	| WHEN NOT /*6R*/ MATCHED THEN INSERT merge_insert
	;

opt_merge_insert :
	/*empty*/
	| WHEN NOT /*6R*/ MATCHED THEN INSERT merge_insert
	;

merge_update :
	set opt_where
	| set unset opt_where
	| unset opt_where
	;

merge_delete :
	opt_where
	;

merge_insert :
	expr opt_where
	| key_val_expr opt_where
	| key_val_options_expr opt_where
	| LPAREN /*23L*/ key_val_options_expr_header RPAREN /*23L*/ opt_where
	;

grant_role :
	GRANT role_list TO user_list
	| GRANT role_list ON keyspace_scope_list TO user_list
	;

role_list :
	role_name
	| role_list COMMA role_name
	;

role_name :
	ident_or_default
	| SELECT
	| INSERT
	| UPDATE
	| DELETE
	;

keyspace_scope_list :
	keyspace_scope
	| keyspace_scope_list COMMA keyspace_scope
	;

keyspace_scope :
	keyspace_name
	| path_part DOT /*22L*/ path_part
	| namespace_name keyspace_name
	| namespace_name path_part DOT /*22L*/ path_part DOT /*22L*/ keyspace_name
	| path_part DOT /*22L*/ path_part DOT /*22L*/ keyspace_name
	| namespace_name path_part DOT /*22L*/ path_part
	;

user_list :
	user
	| user_list COMMA user
	;

user :
	ident_or_default
	| ident_or_default COLON ident_or_default
	;

revoke_role :
	REVOKE role_list FROM /*15L*/ user_list
	| REVOKE role_list ON keyspace_scope_list FROM /*15L*/ user_list
	;

create_scope :
	CREATE SCOPE named_scope_ref opt_if_not_exists
	| CREATE SCOPE IF NOT /*6R*/ EXISTS /*13N*/ named_scope_ref
	;

drop_scope :
	DROP SCOPE named_scope_ref opt_if_exists
	| DROP SCOPE IF EXISTS /*13N*/ named_scope_ref
	;

create_collection :
	CREATE COLLECTION named_keyspace_ref opt_if_not_exists opt_with_clause
	| CREATE COLLECTION IF NOT /*6R*/ EXISTS /*13N*/ named_keyspace_ref opt_with_clause
	;

drop_collection :
	DROP COLLECTION named_keyspace_ref opt_if_exists
	| DROP COLLECTION IF EXISTS /*13N*/ named_keyspace_ref
	;

flush_collection :
	flush_or_truncate COLLECTION named_keyspace_ref
	;

flush_or_truncate :
	FLUSH
	| TRUNCATE
	;

create_index :
	CREATE PRIMARY INDEX opt_if_not_exists ON named_keyspace_ref index_partition opt_index_using opt_with_clause
	| CREATE PRIMARY INDEX index_name opt_if_not_exists ON named_keyspace_ref index_partition opt_index_using opt_with_clause
	| CREATE PRIMARY INDEX IF NOT /*6R*/ EXISTS /*13N*/ index_name ON named_keyspace_ref index_partition opt_index_using opt_with_clause
	| CREATE INDEX index_name opt_if_not_exists ON named_keyspace_ref LPAREN /*23L*/ index_terms RPAREN /*23L*/ index_partition index_where opt_index_using opt_with_clause
	| CREATE INDEX IF NOT /*6R*/ EXISTS /*13N*/ index_name ON named_keyspace_ref LPAREN /*23L*/ index_terms RPAREN /*23L*/ index_partition index_where opt_index_using opt_with_clause
	;

index_name :
	ident_or_default
	;

opt_index_name :
	/*empty*/
	| index_name
	;

opt_if_not_exists :
	/*empty*/
	| IF NOT /*6R*/ EXISTS /*13N*/
	;

named_keyspace_ref :
	simple_named_keyspace_ref
	| namespace_name path_part
	| path_part DOT /*22L*/ path_part DOT /*22L*/ keyspace_name
	| path_part DOT /*22L*/ keyspace_name
	;

simple_named_keyspace_ref :
	keyspace_name
	| namespace_name path_part DOT /*22L*/ path_part DOT /*22L*/ keyspace_name
	;

named_scope_ref :
	namespace_name path_part DOT /*22L*/ path_part
	| path_part DOT /*22L*/ path_part
	| path_part
	;

index_partition :
	/*empty*/
	| PARTITION BY HASH LPAREN /*23L*/ exprs RPAREN /*23L*/
	;

opt_index_using :
	/*empty*/
	| index_using
	;

index_using :
	USING VIEW
	| USING GSI
	| USING FTS
	;

index_terms :
	index_term
	| index_terms COMMA index_term
	;

index_term :
	index_term_expr opt_ikattr
	;

index_term_expr :
	expr
	| all_expr
	;

all_expr :
	all expr
	| all DISTINCT expr
	| DISTINCT expr
	;

all :
	ALL /*20L*/
	| EACH
	;

flatten_keys_expr :
	expr opt_ikattr
	;

flatten_keys_exprs :
	flatten_keys_expr
	| flatten_keys_exprs COMMA flatten_keys_expr
	;

opt_flatten_keys_exprs :
	/*empty*/
	| flatten_keys_exprs
	;

index_where :
	/*empty*/
	| WHERE expr
	;

opt_ikattr :
	/*empty*/
	| ikattr
	| ikattr ikattr
	;

ikattr :
	ASC
	| DESC
	| INCLUDE MISSING
	;

drop_index :
	DROP PRIMARY INDEX opt_if_exists ON named_keyspace_ref opt_index_using
	| DROP PRIMARY INDEX index_name opt_if_exists ON named_keyspace_ref opt_index_using
	| DROP PRIMARY INDEX IF EXISTS /*13N*/ index_name ON named_keyspace_ref opt_index_using
	| DROP INDEX simple_named_keyspace_ref DOT /*22L*/ index_name opt_if_exists opt_index_using
	| DROP INDEX IF EXISTS /*13N*/ simple_named_keyspace_ref DOT /*22L*/ index_name opt_index_using
	| DROP INDEX index_name opt_if_exists ON named_keyspace_ref opt_index_using
	| DROP INDEX IF EXISTS /*13N*/ index_name ON named_keyspace_ref opt_index_using
	;

opt_if_exists :
	/*empty*/
	| IF EXISTS /*13N*/
	;

alter_index :
	ALTER INDEX simple_named_keyspace_ref DOT /*22L*/ index_name opt_index_using with_clause
	| ALTER INDEX index_name ON named_keyspace_ref opt_index_using with_clause
	;

build_index :
	BUILD INDEX ON named_keyspace_ref LPAREN /*23L*/ exprs RPAREN /*23L*/ opt_index_using
	;

create_function :
	CREATE opt_replace FUNCTION opt_if_not_exists func_name LPAREN /*23L*/ parm_list RPAREN /*23L*/ opt_if_not_exists func_body
	;

opt_replace :
	/*empty*/
	| OR /*4L*/ REPLACE
	;

func_name :
	short_func_name
	| long_func_name
	;

short_func_name :
	keyspace_name
	| path_part DOT /*22L*/ path_part
	| path_part DOT /*22L*/ path_part DOT /*22L*/ path_part
	;

long_func_name :
	namespace_term keyspace_name
	| namespace_term path_part DOT /*22L*/ path_part DOT /*22L*/ keyspace_name
	;

parm_list :
	/*empty*/
	| DOT /*22L*/ DOT /*22L*/ DOT /*22L*/
	| parameter_terms
	;

parameter_terms :
	ident_or_default
	| parameter_terms COMMA ident_or_default
	;

func_body :
	LBRACE expr RBRACE
	| LANGUAGE INLINE AS expr
	| LANGUAGE JAVASCRIPT AS STR
	| LANGUAGE JAVASCRIPT AS STR AT STR
	| LANGUAGE GOLANG AS STR AT STR
	;

drop_function :
	DROP FUNCTION func_name opt_if_exists
	| DROP FUNCTION IF EXISTS /*13N*/ func_name
	;

execute_function :
	EXECUTE FUNCTION func_name LPAREN /*23L*/ opt_exprs RPAREN /*23L*/
	;

update_statistics :
	UPDATE STATISTICS opt_for named_keyspace_ref LPAREN /*23L*/ update_stat_terms RPAREN /*23L*/ opt_with_clause
	| UPDATE STATISTICS opt_for named_keyspace_ref DELETE LPAREN /*23L*/ update_stat_terms RPAREN /*23L*/
	| UPDATE STATISTICS opt_for named_keyspace_ref DELETE ALL /*20L*/
	| UPDATE STATISTICS opt_for named_keyspace_ref INDEX LPAREN /*23L*/ exprs RPAREN /*23L*/ opt_index_using opt_with_clause
	| UPDATE STATISTICS opt_for named_keyspace_ref INDEX ALL /*20L*/ opt_index_using opt_with_clause
	| UPDATE STATISTICS FOR INDEX simple_named_keyspace_ref DOT /*22L*/ index_name opt_index_using opt_with_clause
	| UPDATE STATISTICS FOR INDEX index_name ON named_keyspace_ref opt_index_using opt_with_clause
	| ANALYZE opt_keyspace_collection named_keyspace_ref LPAREN /*23L*/ update_stat_terms RPAREN /*23L*/ opt_with_clause
	| ANALYZE opt_keyspace_collection named_keyspace_ref DELETE STATISTICS LPAREN /*23L*/ update_stat_terms RPAREN /*23L*/
	| ANALYZE opt_keyspace_collection named_keyspace_ref DELETE STATISTICS
	| ANALYZE opt_keyspace_collection named_keyspace_ref INDEX LPAREN /*23L*/ exprs RPAREN /*23L*/ opt_index_using opt_with_clause
	| ANALYZE opt_keyspace_collection named_keyspace_ref INDEX ALL /*20L*/ opt_index_using opt_with_clause
	| ANALYZE INDEX simple_named_keyspace_ref DOT /*22L*/ index_name opt_index_using opt_with_clause
	| ANALYZE INDEX index_name ON named_keyspace_ref opt_index_using opt_with_clause
	;

opt_for :
	/*empty*/
	| FOR
	;

update_stat_terms :
	update_stat_term
	| update_stat_terms COMMA update_stat_term
	;

update_stat_term :
	index_term_expr
	;

path :
	ident_or_default
	| path DOT /*22L*/ ident_or_default
	| path DOT /*22L*/ ident_icase
	| path DOT /*22L*/ LBRACKET /*22L*/ expr RBRACKET /*22L*/
	| path DOT /*22L*/ LBRACKET /*22L*/ expr RBRACKET_ICASE
	| path LBRACKET /*22L*/ expr RBRACKET /*22L*/
	;

ident :
	ident_or_default
	;

ident_icase :
	IDENT_ICASE
	;

expr :
	c_expr
	| expr DOT /*22L*/ ident LPAREN /*23L*/ opt_exprs RPAREN /*23L*/
	| expr DOT /*22L*/ ident
	| expr DOT /*22L*/ ident_icase
	| expr DOT /*22L*/ LBRACKET /*22L*/ expr RBRACKET /*22L*/
	| expr DOT /*22L*/ LBRACKET /*22L*/ expr RBRACKET_ICASE
	| expr LBRACKET /*22L*/ RANDOM_ELEMENT RBRACKET /*22L*/
	| expr LBRACKET /*22L*/ expr RBRACKET /*22L*/
	| expr LBRACKET /*22L*/ expr COLON RBRACKET /*22L*/
	| expr LBRACKET /*22L*/ expr COLON expr RBRACKET /*22L*/
	| expr LBRACKET /*22L*/ COLON expr RBRACKET /*22L*/
	| expr LBRACKET /*22L*/ COLON RBRACKET /*22L*/
	| expr LBRACKET /*22L*/ RBRACKET /*22L*/
	| expr LBRACKET /*22L*/ STAR /*18L*/ RBRACKET /*22L*/
	| expr PLUS /*17L*/ expr
	| expr MINUS /*17L*/ expr
	| expr STAR /*18L*/ expr
	| expr DIV /*18L*/ expr
	| expr MOD /*18L*/ expr
	| expr POW /*18L*/ expr
	| expr CONCAT /*16L*/ expr
	| expr AND /*5L*/ expr
	| expr OR /*4L*/ expr
	| NOT /*6R*/ expr
	| expr EQ /*7N*/ expr
	| expr DEQ /*7N*/ expr
	| expr NE /*7N*/ expr
	| expr LT /*8N*/ expr
	| expr GT /*8N*/ expr
	| expr LE /*8N*/ expr
	| expr GE /*8N*/ expr
	| expr BETWEEN /*11N*/ b_expr AND /*5L*/ b_expr
	| expr NOT /*6R*/ BETWEEN /*11N*/ b_expr AND /*5L*/ b_expr
	| expr LIKE /*9N*/ expr ESCAPE /*10N*/ expr
	| expr LIKE /*9N*/ expr
	| expr NOT /*6R*/ LIKE /*9N*/ expr ESCAPE /*10N*/ expr
	| expr NOT /*6R*/ LIKE /*9N*/ expr
	| expr IN /*12N*/ expr
	| expr NOT /*6R*/ IN /*12N*/ expr
	| expr WITHIN /*12N*/ expr
	| expr NOT /*6R*/ WITHIN /*12N*/ expr
	| expr IS /*14N*/ NULL
	| expr IS /*14N*/ NOT /*6R*/ NULL
	| expr IS /*14N*/ MISSING
	| expr IS /*14N*/ NOT /*6R*/ MISSING
	| expr IS /*14N*/ valued
	| expr IS /*14N*/ NOT /*6R*/ UNKNOWN
	| expr IS /*14N*/ NOT /*6R*/ valued
	| expr IS /*14N*/ UNKNOWN
	| expr IS /*14N*/ DISTINCT FROM /*15L*/ expr
	| expr IS /*14N*/ NOT /*6R*/ DISTINCT FROM /*15L*/ expr
	| EXISTS /*13N*/ expr
	;

valued :
	VALUED
	| KNOWN
	;

c_expr :
	literal
	| sequence_expr
	| construction_expr
	| ident_or_default
	| IDENT_ICASE
	| SELF
	| param_expr
	| function_expr
	| MINUS /*17L*/ expr %prec UMINUS /*21R*/
	| case_expr
	| collection_expr
	| paren_expr
	| _COVER /*19R*/ LPAREN /*23L*/ expr RPAREN /*23L*/
	| _INDEX_KEY /*19R*/ LPAREN /*23L*/ expr RPAREN /*23L*/
	| _INDEX_CONDITION /*19R*/ LPAREN /*23L*/ expr RPAREN /*23L*/
	;

b_expr :
	c_expr
	| b_expr DOT /*22L*/ ident_or_default LPAREN /*23L*/ opt_exprs RPAREN /*23L*/
	| b_expr DOT /*22L*/ ident_or_default
	| b_expr DOT /*22L*/ ident_icase
	| b_expr DOT /*22L*/ LBRACKET /*22L*/ expr RBRACKET /*22L*/
	| b_expr DOT /*22L*/ LBRACKET /*22L*/ expr RBRACKET_ICASE
	| b_expr LBRACKET /*22L*/ expr RBRACKET /*22L*/
	| b_expr LBRACKET /*22L*/ expr COLON RBRACKET /*22L*/
	| b_expr LBRACKET /*22L*/ COLON expr RBRACKET /*22L*/
	| b_expr LBRACKET /*22L*/ expr COLON expr RBRACKET /*22L*/
	| b_expr LBRACKET /*22L*/ COLON RBRACKET /*22L*/
	| b_expr LBRACKET /*22L*/ STAR /*18L*/ RBRACKET /*22L*/
	| b_expr PLUS /*17L*/ b_expr
	| b_expr MINUS /*17L*/ b_expr
	| b_expr STAR /*18L*/ b_expr
	| b_expr DIV /*18L*/ b_expr
	| b_expr MOD /*18L*/ b_expr
	| b_expr POW /*18L*/ b_expr
	| b_expr CONCAT /*16L*/ b_expr
	;

literal :
	NULL
	| MISSING
	| FALSE
	| TRUE
	| NUM
	| INT
	| STR
	;

construction_expr :
	object
	| array
	;

object :
	LBRACE opt_members RBRACE
	;

opt_members :
	/*empty*/
	| members
	;

members :
	member
	| members COMMA member
	;

member :
	expr COLON expr
	| expr opt_as_alias
	;

array :
	LBRACKET /*22L*/ opt_exprs RBRACKET /*22L*/
	;

opt_exprs :
	/*empty*/
	| exprs
	;

exprs :
	expr
	| exprs COMMA expr
	;

param_expr :
	NAMED_PARAM
	| POSITIONAL_PARAM
	| NEXT_PARAM
	;

case_expr :
	CASE simple_or_searched_case END
	;

simple_or_searched_case :
	simple_case
	| searched_case
	;

simple_case :
	expr when_thens opt_else
	;

when_thens :
	WHEN expr THEN expr
	| when_thens WHEN expr THEN expr
	;

searched_case :
	when_thens opt_else
	;

opt_else :
	/*empty*/
	| ELSE expr
	;

function_expr :
	FLATTEN_KEYS LPAREN /*23L*/ opt_flatten_keys_exprs RPAREN /*23L*/
	| NTH_VALUE LPAREN /*23L*/ exprs RPAREN /*23L*/ opt_from_first_last opt_nulls_treatment window_function_details
	| function_name LPAREN /*23L*/ opt_exprs RPAREN /*23L*/ opt_filter opt_nulls_treatment opt_window_function
	| function_name LPAREN /*23L*/ agg_quantifier expr RPAREN /*23L*/ opt_filter opt_window_function
	| function_name LPAREN /*23L*/ STAR /*18L*/ RPAREN /*23L*/ opt_filter opt_window_function
	| long_func_name LPAREN /*23L*/ opt_exprs RPAREN /*23L*/
	;

function_name :
	ident
	| REPLACE
	;

collection_expr :
	collection_cond
	| collection_xform
	;

collection_cond :
	ANY coll_bindings satisfies END
	| SOME coll_bindings satisfies END
	| EVERY coll_bindings satisfies END
	| ANY AND /*5L*/ EVERY coll_bindings satisfies END
	| SOME AND /*5L*/ EVERY coll_bindings satisfies END
	;

coll_bindings :
	coll_binding
	| coll_bindings COMMA coll_binding
	;

coll_binding :
	variable IN /*12N*/ expr
	| variable WITHIN /*12N*/ expr
	| variable COLON variable IN /*12N*/ expr
	| variable COLON variable WITHIN /*12N*/ expr
	;

satisfies :
	SATISFIES expr
	;

collection_xform :
	ARRAY expr FOR coll_bindings opt_when END
	| FIRST expr FOR coll_bindings opt_when END
	| OBJECT expr COLON expr FOR coll_bindings opt_when END
	;

paren_expr :
	LPAREN /*23L*/ expr RPAREN /*23L*/
	| LPAREN /*23L*/ all_expr RPAREN /*23L*/
	| subquery_expr
	;

subquery_expr :
	_CORRELATED LPAREN /*23L*/ fullselect RPAREN /*23L*/
	| LPAREN /*23L*/ fullselect RPAREN /*23L*/
	;

expr_input :
	expr
	| all_expr
	;

opt_window_clause :
	/*empty*/
	| WINDOW window_list
	;

window_list :
	window_term
	| window_list COMMA window_term
	;

window_term :
	ident_or_default AS window_specification
	;

window_specification :
	LPAREN /*23L*/ opt_window_name opt_window_partition opt_order_by opt_window_frame RPAREN /*23L*/
	;

opt_window_name :
	/*empty*/
	| ident_or_default
	;

opt_window_partition :
	/*empty*/
	| PARTITION BY exprs
	;

opt_window_frame :
	/*empty*/
	| window_frame_modifier window_frame_extents opt_window_frame_exclusion
	;

window_frame_modifier :
	ROWS
	| RANGE
	| GROUPS
	;

opt_window_frame_exclusion :
	/*empty*/
	| EXCLUDE NO OTHERS
	| EXCLUDE CURRENT ROW
	| EXCLUDE TIES
	| EXCLUDE GROUP
	;

window_frame_extents :
	window_frame_extent
	| BETWEEN /*11N*/ window_frame_extent AND /*5L*/ window_frame_extent
	;

window_frame_extent :
	UNBOUNDED PRECEDING
	| UNBOUNDED FOLLOWING
	| CURRENT ROW
	| expr window_frame_valexpr_modifier
	;

window_frame_valexpr_modifier :
	PRECEDING
	| FOLLOWING
	;

opt_nulls_treatment :
	/*empty*/
	| nulls_treatment
	;

nulls_treatment :
	RESPECT NULLS
	| IGNORE NULLS
	;

opt_from_first_last :
	/*empty*/
	| FROM /*15L*/ first_last
	;

agg_quantifier :
	ALL /*20L*/
	| DISTINCT
	;

opt_filter :
	/*empty*/
	| FILTER LPAREN /*23L*/ where RPAREN /*23L*/
	;

opt_window_function :
	/*empty*/
	| window_function_details
	;

window_function_details :
	OVER ident_or_default
	| OVER window_specification
	;

start_transaction :
	start_or_begin transaction opt_isolation_level
	;

commit_transaction :
	COMMIT opt_transaction
	;

rollback_transaction :
	ROLLBACK opt_transaction opt_savepoint
	;

start_or_begin :
	START
	| BEGIN
	;

opt_transaction :
	/*empty*/
	| transaction
	;

transaction :
	TRAN
	| TRANSACTION
	| WORK
	;

opt_savepoint :
	/*empty*/
	| TO SAVEPOINT savepoint_name
	;

savepoint_name :
	ident_or_default
	;

opt_isolation_level :
	/*empty*/
	| isolation_level
	;

isolation_level :
	ISOLATION LEVEL isolation_val
	;

isolation_val :
	READ COMMITTED
	;

set_transaction_isolation :
	SET TRANSACTION isolation_level
	;

savepoint :
	SAVEPOINT savepoint_name
	;

opt_with_clause :
	/*empty*/
	| with_clause
	;

with_clause :
	WITH expr
	;

opt_namespace_name :
	/*empty*/
	| namespace_name
	;

sequence_object_name :
	ident_or_default
	| _invalid_case_insensitive_identifier
	;

sequence_full_name :
	opt_namespace_name sequence_object_name
	| opt_namespace_name path_part DOT /*22L*/ path_part DOT /*22L*/ sequence_object_name
	| opt_namespace_name path_part DOT /*22L*/ sequence_object_name
	;

sequence_stmt :
	create_sequence
	| drop_sequence
	| alter_sequence
	;

create_sequence :
	CREATE SEQUENCE sequence_name_options seq_create_options
	;

sequence_name_options :
	sequence_name_option
	| sequence_name_options sequence_name_option
	;

sequence_name_option :
	IF NOT /*6R*/ EXISTS /*13N*/
	| sequence_full_name
	;

seq_create_options :
	/*empty*/
	| seq_create_options seq_create_option
	;

seq_create_option :
	sequence_with
	| start_with
	| increment_by
	| maxvalue
	| minvalue
	| cycle
	| cache
	;

drop_sequence :
	DROP SEQUENCE sequence_full_name opt_if_exists
	| DROP SEQUENCE IF EXISTS /*13N*/ sequence_full_name
	;

alter_sequence :
	ALTER SEQUENCE sequence_full_name with_clause
	| ALTER SEQUENCE sequence_full_name seq_alter_options
	;

seq_alter_options :
	seq_alter_option
	| seq_alter_options seq_alter_option
	;

seq_alter_option :
	restart_with
	| increment_by
	| maxvalue
	| minvalue
	| cycle
	| cache
	;

sequence_with :
	WITH expr
	;

start_with :
	START WITH expr
	;

restart_with :
	RESTART opt_with_clause
	;

increment_by :
	INCREMENT BY expr
	;

maxvalue :
	NO MAXVALUE
	| MAXVALUE expr
	;

minvalue :
	NO MINVALUE
	| MINVALUE expr
	;

cycle :
	NO CYCLE
	| CYCLE
	;

cache :
	NO CACHE
	| CACHE expr
	;

sequence_next :
	NEXTVAL FOR ident_or_default
	| NEXT VALUE FOR ident_or_default
	;

sequence_prev :
	PREVVAL FOR ident_or_default
	| PREV VALUE FOR ident_or_default
	;

sequence_expr :
	sequence_next
	| sequence_prev
	;

%%

%%

\"(\\\"|\\[^\"]|[^\"\\])*\"? STR

'(\'\'|\\'|\\[^']|[^'\\])*'? STR


(0|[1-9][0-9]*)\.[0-9]+([eE][+\-]?[0-9]+)? NUM

(0|[1-9][0-9]*)[eE][+\-]?[0-9]+ NUM

    // We differentiate NUM from INT
0|[1-9][0-9]* INT

//[0-9][0-9]*[a-zA-Z_][0-9a-zA-Z_]*		yylex.reportError("invalid number")

\/\*\+[^*]?(([^*\/])|(\*+[^\/])|([^*]\/))*\*+\/ OPTIM_HINTS

"--"\+[^\n\r]*  OPTIM_HINTS

\/\*[^*]?(([^*\/])|(\*+[^\/])|([^*]\/))*\*+\/ skip() /* eat up block comment */

"--".*      skip() /* eat up line comment */

[ \t\n\r\f]+    skip() /* eat up whitespace */

\.                            DOT
\+                            PLUS
-                             MINUS
\*                            STAR
\/                            DIV
%                             MOD
\^                            POW
\=\=                          DEQ
\=                            EQ
\!\=                          NE
\<\>                          NE
\<                            LT
\<\=                          LE
\>                            GT
\>\=                          GE
\|\|                          CONCAT
\(                            LPAREN
\)                            RPAREN
\{                            LBRACE
\}                            RBRACE
\,                            COMMA
\:                            COLON
\[                            LBRACKET
\]                            RBRACKET
\]i                           RBRACKET_ICASE
;                             SEMI
///\!                            NOT_A_TOKEN

[_][iI][nN][dD][eE][xX][_][cC][oO][nN][dD][iI][tT][iI][oO][nN] _INDEX_CONDITION
[_][iI][nN][dD][eE][xX][_][kK][eE][yY]  _INDEX_KEY
[aA][dD][vV][iI][sS][eE] ADVISE
[aA][lL][lL]                  ALL
[aA][lL][tT][eE][rR]          ALTER
[aA][nN][aA][lL][yY][zZ][eE]  ANALYZE
[aA][nN][dD]                  AND
[aA][nN][yY]                  ANY
[aA][rR][rR][aA][yY]          ARRAY
[aA][sS] AS
[aA][sS][cC]                  ASC
[aA][tT]                      AT
[bB][eE][gG][iI][nN]          BEGIN
[bB][eE][tT][wW][eE][eE][nN]  BETWEEN
///[bB][iI][nN][aA][rR][yY]      BINARY
///[bB][oO][oO][lL][eE][aA][nN]  BOOLEAN
///[bB][rR][eE][aA][kK]          BREAK
///[bB][uU][cC][kK][eE][tT]      BUCKET
[bB][uU][iI][lL][dD]          BUILD
[bB][yY]                      BY
///[cC][aA][lL][lL]              CALL
[cC][aA][cC][hH][eE]          CACHE
[cC][aA][sS][eE]              CASE
///[cC][aA][sS][tT]              CAST
///[cC][lL][uU][sS][tT][eE][rR]  CLUSTER
///[cC][oO][lL][lL][aA][tT][eE]  COLLATE
[cC][oO][lL][lL][eE][cC][tT][iI][oO][nN]  COLLECTION
[cC][oO][mM][mM][iI][tT]      COMMIT
[cC][oO][mM][mM][iI][tT][tT][eE][dD]  COMMITTED
///[cC][oO][nN][nN][eE][cC][tT]  CONNECT
///[cC][oO][nN][tT][iI][nN][uU][eE]  CONTINUE
[cC][oO][rR][rR][eE][lL][aA][tT][eE][dD]  _CORRELATED
[cC][oO][vV][eE][rR]          _COVER
[cC][rR][eE][aA][tT][eE]      CREATE
[cC][uU][rR][rR][eE][nN][tT]  CURRENT
[cC][yY][cC][lL][eE]          CYCLE
///[dD][aA][tT][aA][bB][aA][sS][eE]  DATABASE
///[dD][aA][tT][aA][sS][eE][tT]  DATASET
///[dD][aA][tT][aA][sS][tT][oO][rR][eE]  DATASTORE
///[dD][eE][cC][lL][aA][rR][eE]  DECLARE
///[dD][eE][cC][rR][eE][mM][eE][nN][tT]  DECREMENT
[dD][eE][fF][aA][uU][lL][tT]  DEFAULT
[dD][eE][lL][eE][tT][eE]      DELETE
///[dD][eE][rR][iI][vV][eE][dD]  DERIVED
[dD][eE][sS][cC]              DESC
///[dD][eE][sS][cC][rR][iI][bB][eE]  DESCRIBE
[dD][iI][sS][tT][iI][nN][cC][tT]  DISTINCT
///[dD][oO]                      DO
[dD][rR][oO][pP]              DROP
[eE][aA][cC][hH]              EACH
[eE][lL][eE][mM][eE][nN][tT]  ELEMENT
[eE][lL][sS][eE]              ELSE
[eE][nN][dD]                  END
[eE][sS][cC][aA][pP][eE]      ESCAPE
[eE][vV][eE][rR][yY]          EVERY
[eE][xX][cC][eE][pP][tT]      EXCEPT
[eE][xX][cC][lL][uU][dD][eE]  EXCLUDE
[eE][xX][eE][cC][uU][tT][eE]  EXECUTE
[eE][xX][iI][sS][tT][sS]      EXISTS
[eE][xX][pP][lL][aA][iI][nN]   EXPLAIN
[fF][aA][lL][sS][eE]          FALSE
///[fF][eE][tT][cC][hH]          FETCH
[fF][iI][lL][tT][eE][rR]      FILTER
[fF][iI][rR][sS][tT]          FIRST
[fF][lL][aA][tT][tT][eE][nN]  FLATTEN
[fF][lL][aA][tT][tT][eE][nN][_][kK][eE][yY][sS]  FLATTEN_KEYS
[fF][lL][uU][sS][hH]          FLUSH
[fF][oO][lL][lL][oO][wW][iI][nN][gG]  FOLLOWING
[fF][oO][rR]                  FOR
[fF][oO][rR][cC][eE] FORCE
[fF][rR][oO][mM] FROM
[fF][tT][sS]                  FTS
[fF][uU][nN][cC][tT][iI][oO][nN]  FUNCTION
[gG][oO][lL][aA][nN][gG]      GOLANG
[gG][rR][aA][nN][tT]          GRANT
[gG][rR][oO][uU][pP]          GROUP
[gG][rR][oO][uU][pP][sS]      GROUPS
[gG][sS][iI]                  GSI
[hH][aA][sS][hH]              HASH
[hH][aA][vV][iI][nN][gG]      HAVING
[iI][fF]                      IF
[iI][gG][nN][oO][rR][eE]      IGNORE
///[iI][lL][iI][kK][eE]          ILIKE
[iI][nN]                      IN
[iI][nN][cC][lL][uU][dD][eE]  INCLUDE
[iI][nN][cC][rR][eE][mM][eE][nN][tT]  INCREMENT
[iI][nN][dD][eE][xX]          INDEX
[iI][nN][fF][eE][rR]          INFER
[iI][nN][lL][iI][nN][eE]      INLINE
[iI][nN][nN][eE][rR]          INNER
[iI][nN][sS][eE][rR][tT]      INSERT
[iI][nN][tT][eE][rR][sS][eE][cC][tT]  INTERSECT
[iI][nN][tT][oO]              INTO
[iI][sS]                      IS
[iI][sS][oO][lL][aA][tT][iI][oO][nN]  ISOLATION
[jJ][aA][vV][aA][sS][cC][rR][iI][pP][tT]  JAVASCRIPT
[jJ][oO][iI][nN]              JOIN
[kK][eE][yY]                  KEY
[kK][eE][yY][sS]              KEYS
[kK][eE][yY][sS][pP][aA][cC][eE]  KEYSPACE
[kK][nN][oO][wW][nN]          KNOWN
[lL][aA][nN][gG][uU][aA][gG][eE]  LANGUAGE
[lL][aA][sS][tT]              LAST
[lL][aA][tT][eE][rR][aA][lL]  LATERAL
[lL][eE][fF][tT]              LEFT
[lL][eE][tT]                  LET
[lL][eE][tT][tT][iI][nN][gG]  LETTING
[lL][eE][vV][eE][lL]          LEVEL
[lL][iI][kK][eE]              LIKE
[lL][iI][mM][iI][tT]          LIMIT
///[lL][sS][mM]                  LSM
///[mM][aA][pP]                  MAP
///[mM][aA][pP][pP][iI][nN][gG]  MAPPING
[mM][aA][tT][cC][hH][eE][dD]  MATCHED
///[mM][aA][tT][eE][rR][iI][aA][lL][iI][zZ][eE][dD]  MATERIALIZED
[mM][aA][xX][vV][aA][lL][uU][eE]  MAXVALUE
[mM][eE][rR][gG][eE]          MERGE
[mM][iI][nN][vV][aA][lL][uU][eE]  MINVALUE
[mM][iI][sS][sS][iI][nN][gG]  MISSING
///[nN][aA][mM][eE][sS][pP][aA][cC][eE]  NAMESPACE
[nN][eE][sS][tT]              NEST
[nN][eE][xX][tT]              NEXT
[nN][eE][xX][tT][vV][aA][lL]  NEXTVAL
[nN][lL]                      NL
[nN][oO]                      NO
[nN][oO][tT]                  NOT
[nN][tT][hH][_][vV][aA][lL][uU][eE]  NTH_VALUE
[nN][uU][lL][lL]              NULL
[nN][uU][lL][lL][sS]          NULLS
///[nN][uN][mM][bB][eE][rR]      NUMBER
[oO][bB][jJ][eE][cC][tT]      OBJECT
[oO][fF][fF][sS][eE][tT]      OFFSET
[oO][nN]                      ON
///[oO][pP][tT][iI][oO][nN]      OPTION
[oO][pP][tT][iI][oO][nN][sS]  OPTIONS
[oO][rR]                      OR
[oO][rR][dD][eE][rR]          ORDER
[oO][tT][hH][eE][rR][sS]      OTHERS
[oO][uU][tT][eE][rR]          OUTER
[oO][vV][eE][rR]              OVER
///[pP][aA][rR][sS][eE]          PARSE
[pP][aA][rR][tT][iI][tT][iI][oO][nN]  PARTITION
///[pP][aA][sS][sS][wW][oO][rR][dD]  PASSWORD
///[pP][aA][tT][hH]              PATH
///[pP][oO][oO][lL]              POOL
[pP][rR][eE][cC][eE][dD][iI][nN][gG]  PRECEDING
[pP][rR][eE][pP][aA][rR][eE]   PREPARE

[pP][rR][eE][vV]                  PREV
[pP][rR][eE][vV][iI][oO][uU][sS]  PREV
[pP][rR][eE][vV][vV][aA][lL]      PREVVAL

[pP][rR][iI][mM][aA][rR][yY]  PRIMARY
///[pP][rR][iI][vV][aA][tT][eE]  PRIVATE
///[pP][rR][iI][vV][iI][lL][eE][gG][eE]  PRIVILEGE
///[pP][rR][oO][cC][eE][dD][uU][rR][eE]  PROCEDURE
[pP][rR][oO][bB][eE]          PROBE
///[pP][uU][bB][lL][iI][cC]      PUBLIC
[rR][aA][nN][gG][eE]          RANGE
[rR][aA][wW]                  RAW
[rR][eE][aA][dD]              READ
///[rR][eE][aA][lL][mM]          REALM
[rR][eE][cC][uU][rR][sS][iI][vV][eE]  RECURSIVE
///[rR][eE][dD][uU][cC][eE]      REDUCE
///[rR][eE][nN][aA][mM][eE]      RENAME
[rR][eE][pP][lL][aA][cC][eE]  REPLACE
[rR][eE][sS][pP][eE][cC][tT]  RESPECT
[rR][eE][sS][tT][aA][rR][tT]  RESTART
[rR][eE][sS][tT][rR][iI][cC][tT]  RESTRICT
///[rR][eE][tT][uU][rR][nN]      RETURN
[rR][eE][tT][uU][rR][nN][iI][nN][gG]  RETURNING
[rR][eE][vV][oO][kK][eE]      REVOKE
[rR][iI][gG][hH][tT]          RIGHT
///[rR][oO][lL][eE]              ROLE
[rR][oO][lL][lL][bB][aA][cC][kK]  ROLLBACK
[rR][oO][wW]                  ROW
[rR][oO][wW][sS]              ROWS
[sS][aA][tT][iI][sS][fF][iI][eE][sS]  SATISFIES
[sS][aA][vV][eE][pP][oO][iI][nN][tT]  SAVEPOINT
///[sS][cC][hH][eE][mM][aA]      SCHEMA
[sS][cC][oO][pP][eE]          SCOPE
[sS][eE][lL][eE][cC][tT]      SELECT
[sS][eE][lL][fF]              SELF
[sS][eE][qQ][uU][eE][nN][cC][eE]  SEQUENCE
[sS][eE][tT]                  SET
///[sS][hH][oO][wW]              SHOW
[sS][oO][mM][eE]              SOME
[sS][tT][aA][rR][tT]          START
[sS][tT][aA][tT][iI][sS][tT][iI][cC][sS]  STATISTICS
///[sS][tT][rR][iI][nN][gG]      STRING
[sS][yY][sS][tT][eE][mM]      SYSTEM
[tT][hH][eE][nN]              THEN
[tT][iI][eE][sS]              TIES
[tT][oO]                      TO
[tT][rR][aA][nN]              TRAN
[tT][rR][aA][nN][sS][aA][cC][tT][iI][oO][nN]  TRANSACTION
///[tT][rR][iI][gG][gG][eE][rR]  TRIGGER
[tT][rR][uU][eE]              TRUE
[tT][rR][uU][nN][cC][aA][tT][eE]  TRUNCATE
[uU][nN][bB][oO][uU][nN][dD][eE][dD]  UNBOUNDED
///[uU][nN][dD][eE][rR]          UNDER
[uU][nN][iI][oO][nN]          UNION
///[uU][nN][iI][qQ][uU][eE]      UNIQUE
[uU][nN][kK][nN][oO][wW][nN]  UNKNOWN
[uU][nN][nN][eE][sS][tT]      UNNEST
[uU][nN][sS][eE][tT]          UNSET
[uU][pP][dD][aA][tT][eE]      UPDATE
[uU][pP][sS][eE][rR][tT]      UPSERT
[uU][sS][eE]                  USE
///[uU][sS][eE][rR]              USER
[uU][sS][iI][nN][gG]          USING
[vV][aA][lL][iI][dD][aA][tT][eE]  VALIDATE
[vV][aA][lL][uU][eE]          VALUE
[vV][aA][lL][uU][eE][dD]      VALUED
[vV][aA][lL][uU][eE][sS]      VALUES
///[vV][iI][aA]                  VIA
[vV][iI][eE][wW]              VIEW
[wW][hH][eE][nN]              WHEN
[wW][hH][eE][rR][eE]          WHERE
///[wW][hH][iI][lL][eE]          WHILE
[wW][iI][nN][dD][oO][wW]      WINDOW
[wW][iI][tT][hH]              WITH
[wW][iI][tT][hH][iI][nN]      WITHIN
[wW][oO][rR][kK]              WORK
///[xX][oO][rR]                  XOR

NAMESPACE_ID	NAMESPACE_ID
    // Case-insensitive identifier
`((\`\`|\\`)|\\[^`]|[^`\\])*`?i IDENT_ICASE

    // Escaped identifier
`((\`\`|\\`)|\\[^`]|[^`\\])*`? IDENT

[a-zA-Z_][a-zA-Z0-9_]* IDENT

[$|@][a-zA-Z_][a-zA-Z0-9_]* NAMED_PARAM

[$|@][1-9][0-9]* POSITIONAL_PARAM

\?\? RANDOM_ELEMENT

\?	NEXT_PARAM

[\n\r\t ]+ 	skip()


%%
