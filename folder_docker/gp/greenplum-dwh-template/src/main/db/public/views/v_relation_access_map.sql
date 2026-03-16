CREATE VIEW v_relation_access_map AS
SELECT
    schemaname,
    tablename,
    ad_group
FROM t_relation_access_map;
