--liquibase formatted sql

--changeset 12345678:create:schema:sample_schema_marts

CREATE SCHEMA sample_schema_marts;
GRANT ALL ON SCHEMA sample_schema_marts TO dba;
CREATE ROLE sample_schema_marts_owner CREATEROLE NOLOGIN ADMIN dba;
ALTER SCHEMA sample_schema_marts OWNER TO sample_schema_marts_owner;
