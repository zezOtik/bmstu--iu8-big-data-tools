--liquibase formatted sql

--changeset 12345678:set:search_path:sample_schema_ods runAlways:true runOnChange:true
SET search_path to sample_schema_ods, public;
SET ROLE sample_schema_ods_owner;
REVOKE select, update, insert on schemachangelog from presql_etlbot;
REVOKE select, update, insert on schemachangeloglock from presql_etlbot;
REVOKE usage on schema sample_schema_ods from presql_etlbot;

--changeset 12345678:create:default:roles
CREATE ROLE sample_schema_ods_w NOLOGIN ADMIN sample_schema_ods_owner;
CREATE ROLE sample_schema_ods_r NOLOGIN ADMIN sample_schema_ods_owner;
CREATE ROLE sample_schema_ods_x NOLOGIN ADMIN sample_schema_ods_owner;
CREATE ROLE sample_schema_ods_rw NOLOGIN in role sample_schema_ods_r, sample_schema_ods_w ADMIN sample_schema_ods_owner;
CREATE ROLE sample_schema_ods_rwx NOLOGIN in role sample_schema_ods_rw, sample_schema_ods_x ADMIN sample_schema_ods_owner;

--changeset 12345678:grant:sample_schema_ods:defaults runOnChange:true
GRANT USAGE ON SCHEMA sample_schema_ods TO sample_schema_ods_x;
GRANT USAGE ON SCHEMA sample_schema_ods TO sample_schema_ods_w;
ALTER DEFAULT PRIVILEGES IN SCHEMA sample_schema_ods GRANT EXECUTE ON FUNCTIONS TO sample_schema_ods_x;
ALTER DEFAULT PRIVILEGES IN SCHEMA sample_schema_ods GRANT ALL ON SEQUENCES TO sample_schema_ods_w;
ALTER DEFAULT PRIVILEGES IN SCHEMA sample_schema_ods GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON TABLES TO sample_schema_ods_w;