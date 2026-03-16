--liquibase formatted sql

--changeset 12345678:create:table:sample_table_2

CREATE TABLE sample_table_2 (
    id BIGINT,
    business_dt DATE,
    metric_column NUMERIC,
    created_dttm TIMESTAMPTZ
)
WITH (appendonly = 'true', compresslevel = '1', orientation = 'column', compresstype = zstd)
--TABLESPACE warm  -- violating T004 - no explicit tablespace specified - added to ignore in dwh-integration-tests.yml
DISTRIBUTED BY (id);
--PARTITION BY RANGE (business_dt) (DEFAULT PARTITION other)  -- violating T006 - no default partition - not ignored, will fail in integration tests
