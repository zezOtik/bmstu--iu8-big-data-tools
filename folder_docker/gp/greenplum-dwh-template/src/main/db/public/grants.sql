--liquibase formatted sql

--changeset 12345678:grant:public_defaults runAlways:true runOnChange:true

SELECT public.fn_grant_on_all_objects('public', 'r', 'public_r');
SELECT public.fn_grant_on_all_objects('public', 'w', 'public_w');
SELECT public.fn_grant_on_all_objects('public', 'x', 'public_x');

--changeset 12345678:grant:role:public_rwx runOnChange:true

GRANT public_rwx TO robots;

--changeset 12345678:grant:schema:privileges runOnChange:true

GRANT ALL ON SCHEMA public TO dba;

--changeset 12345678:grant:select:public

GRANT SELECT ON t_relation_access_map TO public;
