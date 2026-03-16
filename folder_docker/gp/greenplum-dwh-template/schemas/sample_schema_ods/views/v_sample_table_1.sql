CREATE OR REPLACE VIEW v_sample_table_1 AS
SELECT
    nk,
    item_id,
    business_dt,
    valid_from_dttm,
    created_dttm,
    updated_dttm,
    md5_hash,
    is_actual
FROM sample_table_1;
