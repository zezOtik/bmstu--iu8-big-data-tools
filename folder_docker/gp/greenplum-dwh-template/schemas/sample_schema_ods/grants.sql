--liquibase formatted sql

--changeset 12345678:grant:sample_schema_ods:defaults runAlways:true runOnChange:true

SELECT public.fn_grant_on_all_objects('sample_schema_ods', 'r', 'sample_schema_ods_r');

--changeset 12345678:grant:sample_schema_ods_rwx runOnChange:true

GRANT sample_schema_ods_rwx TO sample_schema_ods_etlbot;

--changeset 12345678:grant:sample_schema_ods_owner runOnChange:true

GRANT sample_schema_ods_owner TO dba;

--changeset 12345678:grant:sample_schema_ods.liquibase_service_tables runOnChange:true

GRANT SELECT ON schemachangelog, schemachangeloglock TO changelog_reader;

--changeset 12345678:grant:sample_schema_ods_r:to:sample_schema_dds_etlbot runOnChange:true

GRANT sample_schema_ods_r TO sample_schema_dds_etlbot;
