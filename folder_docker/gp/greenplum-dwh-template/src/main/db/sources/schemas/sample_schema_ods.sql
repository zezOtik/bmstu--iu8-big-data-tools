--liquibase formatted sql

--changeset 12345678:create:schema:sample_schema_ods

CREATE SCHEMA sample_schema_ods;
GRANT ALL ON SCHEMA sample_schema_ods TO dba;
CREATE ROLE sample_schema_ods_owner CREATEROLE NOLOGIN ADMIN dba;
ALTER SCHEMA sample_schema_ods OWNER TO sample_schema_ods_owner;
COMMENT ON SCHEMA sample_schema_ods IS 'DP2.0';
