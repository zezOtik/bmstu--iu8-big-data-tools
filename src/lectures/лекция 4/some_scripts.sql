
-- Ручная схема данных
CREATE TABLE rides.trips
(
    VendorID Int32,
    tpep_pickup_datetime DateTime64(6),
    tpep_dropoff_datetime DateTime64(6),
    passenger_count Nullable(Int64),
    trip_distance Nullable(Float64),
    RatecodeID Nullable(Int64),
    store_and_fwd_flag Nullable(String),
    PULocationID Int32,
    DOLocationID Int32,
    payment_type Nullable(Int64),
    fare_amount Nullable(Float64),
    extra Nullable(Float64),
    mta_tax Nullable(Float64),
    tip_amount Nullable(Float64),
    tolls_amount Nullable(Float64),
    improvement_surcharge Nullable(Float64),
    total_amount Nullable(Float64),
    congestion_surcharge Nullable(Float64),
    Airport_fee Nullable(Float64)
)

ENGINE = MergeTree
PARTITION BY toYYYYMM(tpep_pickup_datetime)
ORDER BY (tpep_pickup_datetime, tpep_dropoff_datetime, PULocationID, DOLocationID)
SETTINGS index_granularity = 8192;


SELECT
    name,                  -- Имя части (папки на диске)
    partition,             -- Партиция
    disk,                  -- Диск
    path,                  -- Полный путь к папке части
    rows,                  -- Количество строк
    bytes_on_disk,         -- Размер на диске (сжато)
    data_compressed_bytes, -- Размер сжатых данных
    data_uncompressed_bytes, -- Размер несжатых данных
    marks_bytes,           -- Размер файлов меток (.mrk)
    modification_time,     -- Время последнего изменения
    active,                -- 1 = часть активна (участвует в SELECT), 0 = помечена на слияние/удаление
    level,                 -- Уровень иерархии слияния (0 = свежая, >0 = результат слияния)
    compression_codec      -- Кодек сжатия
FROM system.parts
WHERE table = 'my_table'
  AND active = 1
ORDER BY modification_time DESC;


-- статистика по таблице
SELECT
    table,
    count() as parts_count,           -- Сколько частей
    sum(rows) as total_rows,          -- Всего строк
    formatReadableSize(sum(bytes_on_disk)) as total_size, -- Размер на диске
    formatReadableSize(sum(data_uncompressed_bytes)) as uncompressed_size,
    sum(data_uncompressed_bytes) / sum(bytes_on_disk) as compression_ratio, -- Коэфф. сжатия
    avg(rows) as avg_rows_per_part    -- В среднем строк на часть
FROM system.parts
WHERE table = 'my_table' AND active = 1
GROUP BY table;

-- /var/lib/clickhouse/data/default/my_table/all_1_1_0 путь до part

select * from system.parts;



-- Определим схему данных автоматом и отдадим движку на откуп
CREATE TABLE my_table AS
SELECT *
FROM file('/var/lib/clickhouse/user_files/import/yellow_tripdata_2026-01.parquet', Parquet)
LIMIT 0;


-- Затем вставим данные:
INSERT INTO my_table
SELECT *
FROM file('/var/lib/clickhouse/user_files/import/yellow_tripdata_2026-01.parquet', Parquet);


explain (
        SELECT sum(total_amount), avg(total_amount), count(1)
        FROM my_table
)

-- список частей
SELECT _part
FROM my_table
GROUP BY _part
ORDER BY _part ASC;

-- список частей и уровень слияний
-- 0 не учавствовала в слияние + 1 количество слияний
SELECT
    name,
    level,
    rows
FROM system.parts
WHERE (database = 'default') AND (`table` = 'my_table') AND active
ORDER BY name ASC;

-- Мутации
ALTER TABLE default.my_table UPDATE passenger_count = 1 WHERE 1=1;


--Посмотреть мутацию
select * from system.mutations;

-- Посмотреть движок таблицы
SELECT engine
FROM system.tables
WHERE name = 'my_table';

