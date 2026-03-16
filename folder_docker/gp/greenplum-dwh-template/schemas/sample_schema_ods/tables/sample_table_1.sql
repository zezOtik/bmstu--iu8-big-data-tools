--liquibase formatted sql

--changeset 12345678:create:table:sample_table_1

CREATE TABLE sample_table_1 (
    nk character varying(4096),
    item_id integer,
    business_dt date,
    valid_from_dttm timestamp with time zone,
    created_dttm timestamp without time zone DEFAULT ('now'::text)::timestamp without time zone,
    updated_dttm timestamp without time zone DEFAULT ('now'::text)::timestamp without time zone,
    md5_hash character varying(4096),
    is_actual character(1)
)
WITH (appendonly = 'true', compresslevel = '1', orientation = 'column', compresstype = zstd)
--TABLESPACE warm  -- violating T004 - no explicit tablespace specified - added to ignore in dwh-integration-tests.yml
DISTRIBUTED RANDOMLY;
-- violating T006 - no default partition - added to ignore in dwh-integration-tests.yml
