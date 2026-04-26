CREATE DATABASE IF NOT EXISTS rk_db;

CREATE TABLE IF NOT EXISTS rk_db.all_regions AS
SELECT *
FROM file('/var/lib/clickhouse/user_files/import/accidents_all_regions_126_v20260401.parquet', 'Parquet');

CREATE TABLE rk_db.regions_summary_agg
(
    region String,
    accidents_count UInt64,          -- Количество ДТП
    total_participants UInt64,       -- Суммарное число участников
    total_dead UInt64,               -- Суммарное число погибших
    total_injured UInt64             -- Суммарное число пострадавших
)
ENGINE = SummingMergeTree()
ORDER BY region;

DROP TABLE IF EXISTS rk_db.regions_summary_agg;

CREATE TABLE rk_db.regions_summary_agg
(
    region String,
    accidents_count UInt64,
    total_participants UInt64,
    total_dead UInt64,
    total_injured UInt64,
    avg_latitude Float64,
    avg_longitude Float64
)
ENGINE = SummingMergeTree()
ORDER BY region;

INSERT INTO rk_db.regions_summary_agg
SELECT
    region,
    count() AS accidents_count,
    sum(participants_count) AS total_participants,
    sum(dead_count) AS total_dead,
    sum(injured_count) AS total_injured,
    avg(latitude) AS avg_latitude,
    avg(longitude) AS avg_longitude
FROM rk_db.all_regions
GROUP BY region;

SELECT * FROM rk_db.regions_summary_agg ORDER BY total_dead DESC LIMIT 10;