--liquibase formatted sql

--changeset 12345678:create:table:sample_table_3

CREATE TABLE sample_table_3 (
    id BIGINT,
    business_dt DATE,
    metric_column NUMERIC,
    created_dttm TIMESTAMPTZ
)
WITH (appendonly = 'true', compresslevel = '1', orientation = 'column', compresstype = zstd)
--TABLESPACE warm
DISTRIBUTED BY (id)
PARTITION BY RANGE (business_dt) (DEFAULT PARTITION other);
