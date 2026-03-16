CREATE OR REPLACE function fn_grant_on_all_objects(schema_name character varying, rights character varying, role_name character varying)
returns void
    language plpgsql
as $$
declare
    query_text text;
begin

    execute 'GRANT USAGE ON SCHEMA '||schema_name ||' TO ' || role_name;

    IF rights = 'all' then
        --for all objects
        execute 'GRANT ALL ON SCHEMA '||schema_name ||' TO ' || role_name;

        SELECT string_agg('GRANT ALL PRIVILEGES ON "' || table_schema || '"."' || table_name ||  '" TO ' || role_name, ';') INTO query_text
        FROM information_schema.tables
        WHERE table_schema=schema_name
            AND table_type='BASE TABLE';

       	RAISE NOTICE 'Try execute: %', query_text;
        EXECUTE (COALESCE(query_text, ''));

        SELECT string_agg('GRANT ALL PRIVILEGES ON FUNCTION ' || p.proname || '(' || oidvectortypes(p.proargtypes) || ')' || ' TO ' || role_name, ';') INTO query_text
        FROM pg_proc p INNER JOIN pg_namespace ns ON (p.pronamespace = ns.oid)
        WHERE ns.nspname = schema_name;

       	RAISE NOTICE 'Try execute: %', query_text;
        EXECUTE (COALESCE(query_text, ''));

        SELECT string_agg('GRANT ALL PRIVILEGES ON SEQUENCE "' || sequence_schema || '"."' || sequence_name ||  '" TO ' || role_name, ';') INTO query_text
        FROM information_schema.sequences
        WHERE sequence_schema=schema_name;

       	RAISE NOTICE 'Try execute: %', query_text;
        EXECUTE (COALESCE(query_text, ''));

    ELSIF rights = 'r' then

        SELECT string_agg('GRANT SELECT ON "' || table_schema || '"."' || table_name ||  '" TO ' || role_name, ';') INTO query_text
        FROM information_schema.views
        WHERE table_schema=schema_name AND (table_schema, table_name) NOT IN (SELECT schemaname, tablename FROM t_relation_access_map);

       	RAISE NOTICE 'Try execute: %', query_text;
        EXECUTE (COALESCE(query_text, ''));

    ELSIF rights = 'w' then

        SELECT string_agg('GRANT SELECT ON "' || sequence_schema || '"."' || sequence_name ||  '" TO ' || role_name, ';') INTO query_text
        FROM information_schema.sequences
        WHERE sequence_schema=schema_name;

       	RAISE NOTICE 'Try execute: %', query_text;
        EXECUTE (COALESCE(query_text, ''));

        --for all tables
        SELECT string_agg('GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON "' || table_schema || '"."' || table_name ||  '" TO ' || role_name, ';') INTO query_text
        FROM information_schema.tables
        WHERE table_schema=schema_name
            AND table_type='BASE TABLE';

       	RAISE NOTICE 'Try execute: %', query_text;
        EXECUTE (COALESCE(query_text, ''));

    ELSIF rights = 'x' then
        --for all functions
        SELECT string_agg('GRANT EXECUTE ON FUNCTION ' || p.proname || '(' || oidvectortypes(p.proargtypes) || ')' || ' TO ' || role_name, ';') INTO query_text
        FROM pg_proc p INNER JOIN pg_namespace ns ON (p.pronamespace = ns.oid)
        WHERE ns.nspname = schema_name;

       	RAISE NOTICE 'Try execute: %', query_text;
        EXECUTE (COALESCE(query_text, ''));

    ELSE
        RAISE EXCEPTION 'Grant rights %. Not implemented ', rights;
    end if;

end ;
$$;
