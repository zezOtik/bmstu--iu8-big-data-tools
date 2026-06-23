DESCRIBE TABLE file('import/accidents_all_regions_126_v20260401.parquet', Parquet);


SELECT * FROM file('import/accidents_all_regions_126_v20260401.parquet', Parquet) LIMIT 5;

DROP TABLE IF EXISTS accidents_raw;

CREATE TABLE accidents_raw (
    id                     Nullable(Int64),
    tags                   Nullable(String),
    category               Nullable(String),
    region                 Nullable(String),
    county                 Nullable(String),
    address                Nullable(String),
    longitude              Nullable(Float64),
    latitude               Nullable(Float64),
    nearby                 Nullable(String),
    datetime               Nullable(String),
    light                  Nullable(String),
    weather                Nullable(String),
    road_conditions        Nullable(String),
    participants_count     Nullable(Int64),
    participant_categories Nullable(String),
    severity               Nullable(String),
    dead_count             Nullable(Int64),
    injured_count          Nullable(Int64)
) ENGINE = MergeTree ORDER BY tuple();

DROP TABLE IF EXISTS participants_raw;

CREATE TABLE participants_raw (
    accident_id                 Nullable(Int64),
    vehicle_id                  Nullable(String),
    participant_id              Nullable(String),
    role                        Nullable(String),
    gender                      Nullable(String),
    violations                  Nullable(String),
    health_status               Nullable(String),
    years_of_driving_experience Nullable(Int64)
) ENGINE = MergeTree ORDER BY tuple();

DROP TABLE IF EXISTS vehicles_raw;

CREATE TABLE vehicles_raw (
    accident_id Nullable(Int64),
    vehicle_id  Nullable(String),
    category    Nullable(String),
    brand       Nullable(String),
    model       Nullable(String),
    color       Nullable(String),
    year        Nullable(Int64)
) ENGINE = MergeTree ORDER BY tuple();

--SELECT 'accidents' AS tbl, count() AS rows FROM accidents_raw
--UNION ALL SELECT 'participants', count() FROM participants_raw
--UNION ALL SELECT 'vehicles', count() FROM vehicles_raw;

DROP TABLE IF EXISTS accidents_daily_agg;

CREATE TABLE accidents_daily_agg (
    event_date         Date,
    region             String,
    category           String,
    severity           String,
    accidents_count    UInt64,
    participants_total UInt64,
    dead_total         UInt64,
    injured_total      UInt64
) ENGINE = SummingMergeTree
ORDER BY (event_date, region, category, severity);

INSERT INTO accidents_daily_agg
SELECT
    toDate(parseDateTimeBestEffortOrZero(coalesce(datetime, ''))) AS event_date,
    coalesce(region, '')     AS region,
    coalesce(category, '')   AS category,
    coalesce(severity, '')   AS severity,
    count()                  AS accidents_count,
    sum(coalesce(participants_count, 0)) AS participants_total,
    sum(coalesce(dead_count, 0))         AS dead_total,
    sum(coalesce(injured_count, 0))      AS injured_total
FROM accidents_raw
GROUP BY event_date, region, category, severity;

DROP TABLE IF EXISTS accidents_geo_agg;

CREATE TABLE accidents_geo_agg (
    event_year      UInt16,
    region          String,
    category        String,
    lat_grid        Float64,
    lon_grid        Float64,
    accidents_count UInt64,
    dead_total      UInt64,
    injured_total   UInt64
) ENGINE = SummingMergeTree
ORDER BY (event_year, region, lat_grid, lon_grid, category);

INSERT INTO accidents_geo_agg
SELECT
    toYear(parseDateTimeBestEffortOrZero(coalesce(datetime, ''))) AS event_year,
    coalesce(region, '')   AS region,
    coalesce(category, '') AS category,
    round(latitude,  2)    AS lat_grid,
    round(longitude, 2)    AS lon_grid,
    count()                AS accidents_count,
    sum(coalesce(dead_count, 0))    AS dead_total,
    sum(coalesce(injured_count, 0)) AS injured_total
FROM accidents_raw
WHERE latitude IS NOT NULL AND longitude IS NOT NULL
GROUP BY event_year, region, category, lat_grid, lon_grid;

DROP TABLE IF EXISTS accidents_hourly_agg;

CREATE TABLE accidents_hourly_agg (
    event_hour      UInt8,
    region          String,
    category        String,
    accidents_count UInt64,
    dead_total      UInt64,
    injured_total   UInt64
) ENGINE = SummingMergeTree
ORDER BY (event_hour, region, category);

INSERT INTO accidents_hourly_agg
SELECT
    toHour(parseDateTimeBestEffortOrZero(coalesce(datetime, ''))) AS event_hour,
    coalesce(region, '')   AS region,
    coalesce(category, '') AS category,
    count()                AS accidents_count,
    sum(coalesce(dead_count, 0))    AS dead_total,
    sum(coalesce(injured_count, 0)) AS injured_total
FROM accidents_raw
GROUP BY event_hour, region, category;

SELECT 'daily_agg' AS t, count() AS rows FROM accidents_daily_agg
UNION ALL SELECT 'geo_agg', count() FROM accidents_geo_agg
UNION ALL SELECT 'hourly_agg', count() FROM accidents_hourly_agg;
