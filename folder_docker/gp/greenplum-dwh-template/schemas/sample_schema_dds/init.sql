--liquibase formatted sql

--changeset 12345678:set:search_path:sample_schema_dds runAlways:true runOnChange:true
SET search_path to sample_schema_dds, public;
SET ROLE sample_schema_dds_owner;
REVOKE select, update, insert on schemachangelog from presql_etlbot;
REVOKE select, update, insert on schemachangeloglock from presql_etlbot;
REVOKE usage on schema sample_schema_dds from presql_etlbot;

--changeset 12345678:create:default:roles
CREATE ROLE sample_schema_dds_w NOLOGIN ADMIN sample_schema_dds_owner;
CREATE ROLE sample_schema_dds_r NOLOGIN ADMIN sample_schema_dds_owner;
CREATE ROLE sample_schema_dds_x NOLOGIN ADMIN sample_schema_dds_owner;
CREATE ROLE sample_schema_dds_rw NOLOGIN in role sample_schema_dds_r, sample_schema_dds_w ADMIN sample_schema_dds_owner;
CREATE ROLE sample_schema_dds_rwx NOLOGIN in role sample_schema_dds_rw, sample_schema_dds_x ADMIN sample_schema_dds_owner;

--changeset 12345678:grant:sample_schema_dds:defaults runOnChange:true
GRANT USAGE ON SCHEMA sample_schema_dds TO sample_schema_dds_x;
GRANT USAGE ON SCHEMA sample_schema_dds TO sample_schema_dds_w;
ALTER DEFAULT PRIVILEGES IN SCHEMA sample_schema_dds GRANT EXECUTE ON FUNCTIONS TO sample_schema_dds_x;
ALTER DEFAULT PRIVILEGES IN SCHEMA sample_schema_dds GRANT ALL ON SEQUENCES TO sample_schema_dds_w;
ALTER DEFAULT PRIVILEGES IN SCHEMA sample_schema_dds GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON TABLES TO sample_schema_dds_w;