--liquibase formatted sql

--changeset 12345678:grant:sample_schema_dds:defaults runAlways:true runOnChange:true

SELECT public.fn_grant_on_all_objects('sample_schema_dds', 'r', 'sample_schema_dds_r');

--changeset 12345678:grant:sample_schema_dds_rwx runOnChange:true

GRANT sample_schema_dds_rwx TO sample_schema_dds_etlbot;

--changeset 12345678:grant:sample_schema_dds_owner runOnChange:true

GRANT sample_schema_dds_owner TO dba;

--changeset 12345678:grant:sample_schema_dds.liquibase_service_tables runOnChange:true

GRANT SELECT ON schemachangelog, schemachangeloglock TO changelog_reader;

--changeset 12345678:grant:sample_schema_dds_r:to:sample_schema_marts_etlbot runOnChange:true

GRANT sample_schema_dds_r TO sample_schema_marts_etlbot;
