CREATE OR REPLACE function fn_postsql()
    returns void
    language plpgsql
as
$$

begin
    perform public.fn_grant_tables_select();
end
$$;
