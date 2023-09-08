SELECT a,b,c from mytable;

----

CREATE SCHEMA TESTLIBPQ2;
SET search_path = TESTLIBPQ2;
CREATE TABLE TBL1 (i int4);
CREATE TABLE TBL2 (i int4);
CREATE RULE r1 AS ON INSERT TO TBL1 DO
  (INSERT INTO TBL2 VALUES (new.i); NOTIFY TBL2);


---

-- database: presto;  groups: tpch; tables: lineitem,part
SELECT sum(l_extendedprice * (1 - l_discount)) AS revenue
FROM lineitem,
     part
WHERE (
            p_partkey = l_partkey
        AND p_brand = 'Brand#12'
        AND p_container IN ('SM CASE', 'SM BOX', 'SM PACK', 'SM PKG')
        AND l_quantity >= 1 AND l_quantity <= 1 + 10
        AND p_size BETWEEN 1 AND 5
        AND l_shipmode IN ('AIR', 'AIR REG')
        AND l_shipinstruct = 'DELIVER IN PERSON'
    )
   OR (
            p_partkey = l_partkey
        AND p_brand = 'Brand#23'
        AND p_container IN ('MED BAG', 'MED BOX', 'MED PKG', 'MED PACK')
        AND l_quantity >= 10 AND l_quantity <= 10 + 10
        AND p_size BETWEEN 1 AND 10
        AND l_shipmode IN ('AIR', 'AIR REG')
        AND l_shipinstruct = 'DELIVER IN PERSON'
    )
   OR (
            p_partkey = l_partkey
        AND p_brand = 'Brand#34'
        AND p_container IN ('LG CASE', 'LG BOX', 'LG PACK', 'LG PKG')
        AND l_quantity >= 20 AND l_quantity <= 20 + 10
        AND p_size BETWEEN 1 AND 15
        AND l_shipmode IN ('AIR', 'AIR REG')
        AND l_shipinstruct = 'DELIVER IN PERSON'
    );

----