--liquibase formatted sql

--changeset 12345678:set:search_path:sample_schema_marts runAlways:true runOnChange:true
SET search_path to sample_schema_marts, public;
SET ROLE sample_schema_marts_owner;
REVOKE select, update, insert on schemachangelog from presql_etlbot;
REVOKE select, update, insert on schemachangeloglock from presql_etlbot;
REVOKE usage on schema sample_schema_marts from presql_etlbot;

--changeset 12345678:create:default:roles
CREATE ROLE sample_schema_marts_w NOLOGIN ADMIN sample_schema_marts_owner;
CREATE ROLE sample_schema_marts_r NOLOGIN ADMIN sample_schema_marts_owner;
CREATE ROLE sample_schema_marts_x NOLOGIN ADMIN sample_schema_marts_owner;
CREATE ROLE sample_schema_marts_rw NOLOGIN in role sample_schema_marts_r, sample_schema_marts_w ADMIN sample_schema_marts_owner;
CREATE ROLE sample_schema_marts_rwx NOLOGIN in role sample_schema_marts_rw, sample_schema_marts_x ADMIN sample_schema_marts_owner;

--changeset 12345678:grant:sample_schema_marts:defaults runOnChange:true
GRANT USAGE ON SCHEMA sample_schema_marts TO sample_schema_marts_x;
GRANT USAGE ON SCHEMA sample_schema_marts TO sample_schema_marts_w;
ALTER DEFAULT PRIVILEGES IN SCHEMA sample_schema_marts GRANT EXECUTE ON FUNCTIONS TO sample_schema_marts_x;
ALTER DEFAULT PRIVILEGES IN SCHEMA sample_schema_marts GRANT ALL ON SEQUENCES TO sample_schema_marts_w;
ALTER DEFAULT PRIVILEGES IN SCHEMA sample_schema_marts GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON TABLES TO sample_schema_marts_w;