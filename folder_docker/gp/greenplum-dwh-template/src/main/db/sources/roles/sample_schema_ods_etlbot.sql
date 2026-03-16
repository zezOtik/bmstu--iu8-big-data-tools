--liquibase formatted sql

--changeset 12345678:create:role:sample_schema_ods_etlbot

CREATE ROLE "sample_schema_ods_etlbot" login IN ROLE non_ldap_users, robots ADMIN cibot;
COMMENT ON ROLE "sample_schema_ods_etlbot" IS 'sample_schema_ods etl bot';

--changeset 12345678:grant:pxf_select:receipt_repository20_etlbot

GRANT pxf_select TO "sample_schema_ods_etlbot";
