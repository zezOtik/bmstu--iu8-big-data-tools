CREATE OR REPLACE FUNCTION fn_sample_function_1()
RETURNS void
LANGUAGE plpgsql
VOLATILE
AS
$FUNCTION$
BEGIN

    RAISE NOTICE 'This is a sample function';

END;
$FUNCTION$;
