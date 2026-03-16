CREATE OR REPLACE FUNCTION fn_sample_function_2()
RETURNS void
LANGUAGE plpgsql
VOLATILE
AS
$FUNCTION$
BEGIN

    RAISE NOTICE 'This is a sample function';

    -- demonstrating sql static tests errors

    -- violating F010 - using COUNT(DISTINCT ...) - added to ignore in dwh-sql-checks.yml
    CREATE TEMP TABLE tt1 AS
    SELECT
        COUNT(DISTINCT id) AS unique_ids_cnt
    FROM sample_schema_dds.v_sample_table_2
    DISTRIBUTED REPLICATED;

    -- violating F014 - no explicit distribution for temporary table - not ignored, will fail in sql static tests
    CREATE TEMP TABLE tt1 AS
    SELECT
        id
    FROM sample_schema_dds.v_sample_table_2;

END;
$FUNCTION$;
