--liquibase formatted sql

--changeset 12345678:grant:sample_schema_marts:defaults runAlways:true runOnChange:true

SELECT public.fn_grant_on_all_objects('sample_schema_marts', 'r', 'sample_schema_marts_r');

--changeset 12345678:grant:sample_schema_marts_rwx runOnChange:true

GRANT sample_schema_marts_rwx TO sample_schema_marts_etlbot;

--changeset 12345678:grant:sample_schema_marts_owner runOnChange:true

GRANT sample_schema_marts_owner TO dba;

--changeset 12345678:grant:sample_schema_marts.liquibase_service_tables runOnChange:true

GRANT SELECT ON schemachangelog, schemachangeloglock TO changelog_reader;
