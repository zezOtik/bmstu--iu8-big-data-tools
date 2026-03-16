--liquibase formatted sql

--changeset 12345678:create:role:sample_schema_dds_etlbot

CREATE ROLE "sample_schema_dds_etlbot" login IN ROLE non_ldap_users, robots ADMIN cibot;
COMMENT ON ROLE "sample_schema_dds_etlbot" IS 'sample_schema_dds etl bot';
