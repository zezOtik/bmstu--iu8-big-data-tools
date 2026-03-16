CREATE OR REPLACE FUNCTION fn_grant_tables_select()
    RETURNS void
    VOLATILE
AS
$$

declare
    var_role_strict_name text;
    var_table_name       text;
    var_schema_name      text;
    var_read_role        text;
    var_query_sql        text;

begin

    --All strict schema usage
    for var_schema_name, var_role_strict_name in
        select distinct schemaname,
                        ad_group
        from t_relation_access_map
        loop
            var_query_sql = 'grant usage on schema ' || var_schema_name || ' to ' || '"' || var_role_strict_name ||
                            '";';
            begin
                execute var_query_sql;
            EXCEPTION
                WHEN others THEN
                    RAISE NOTICE 'Error skip schema, %',var_schema_name;

            END;
            RAISE NOTICE '%', var_query_sql;
        end loop;

    for var_table_name, var_query_sql in
        select distinct tablename,
                        'revoke select on ' || schemaname || '.' || tablename || ' from '
                            || quote_ident(r.rolname) || ';' as stmt
        from t_relation_access_map
                 join information_schema.role_table_grants g
                      on schemaname = table_schema and tablename = table_name and privilege_type = 'SELECT'
                 join pg_roles r on g.grantee = r.rolname and r.rolname = schemaname || '_r'
        loop
            begin
                execute var_query_sql;
            exception
                WHEN others then
                    RAISE NOTICE 'Error skip table, %, %',var_table_name, SQLERRM;
            END;
            RAISE NOTICE '%', var_query_sql;
        end loop;

    --All strict access table select
    for var_table_name, var_query_sql in
        select distinct tablename,
                        'grant select on ' || schemaname || '.' || tablename || ' to ' || '"' ||
                        ad_group || '"' || ';' as stmt
        from t_relation_access_map
                 left join (select table_schema, table_name, grantee
                            from information_schema.role_table_grants
                            where privilege_type = 'SELECT'
                              and exists(select 1
                                         from t_relation_access_map
                                         where schemaname = table_schema
                                           and tablename = table_name
                                           and ad_group = grantee)) rtg
                           on schemaname = table_schema and tablename = table_name and grantee = ad_group
        where grantee is null
        loop
            begin
                execute var_query_sql;
            exception
                WHEN others then
                    RAISE NOTICE 'Error skip table, %, %',var_table_name, SQLERRM;
            END;
            RAISE NOTICE '%', var_query_sql;
        end loop;

end
$$
    LANGUAGE 'plpgsql';
