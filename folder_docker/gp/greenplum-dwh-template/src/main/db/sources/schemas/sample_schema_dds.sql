--liquibase formatted sql

--changeset 12345678:create:schema:sample_schema_dds

CREATE SCHEMA sample_schema_dds;
GRANT ALL ON SCHEMA sample_schema_dds TO dba;
CREATE ROLE sample_schema_dds_owner CREATEROLE NOLOGIN ADMIN dba;
ALTER SCHEMA sample_schema_dds OWNER TO sample_schema_dds_owner;
