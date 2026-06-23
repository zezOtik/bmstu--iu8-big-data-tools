CREATE DATABASE IF NOT EXISTS rk;

-- ============================================================
-- Удаляем старые представления и таблицы, чтобы повторный запуск
-- не создавал дубли и не ломался из-за старой схемы.
-- ============================================================

DROP TABLE IF EXISTS rk.v_region_income_map;
DROP TABLE IF EXISTS rk.v_top_region_by_month_long;
DROP TABLE IF EXISTS rk.v_region_income_long;
DROP TABLE IF EXISTS rk.v_top_region_by_month;

DROP TABLE IF EXISTS rk.region_month_totals;
DROP TABLE IF EXISTS rk.budget_incomes_raw;

-- ============================================================
-- 1. Сырая таблица с данными из Parquet
-- ============================================================

CREATE TABLE rk.budget_incomes_raw
(
    year UInt16,
    month UInt8,

    period Date MATERIALIZED toDate(
        concat(
            toString(year),
            '-',
            leftPad(toString(month), 2, '0'),
            '-01'
        )
    ),

    income_level UInt8,
    income_part LowCardinality(String),

    plan Nullable(Float64),
    adj_plan_consolidated Nullable(Float64),
    adj_plan_regional Nullable(Float64),
    adj_plan_growth_rate Nullable(Float64),

    execution_consolidated Nullable(Float64),
    execution_regional Nullable(Float64),

    growth_rate_regional Nullable(Float64),
    growth_rate_federal_district Nullable(Float64),
    growth_rate_russia Nullable(Float64),

    object_name LowCardinality(String),
    okato String,
    oktmo String,
    object_level LowCardinality(String)
)
ENGINE = MergeTree
PARTITION BY year
ORDER BY (object_level, year, month, object_name, income_level, income_part);

-- ============================================================
-- 2. Загрузка данных из Parquet
-- Файл должен лежать в ./import/budget_incomes.parquet
-- ============================================================

INSERT INTO rk.budget_incomes_raw
(
    year,
    month,
    income_level,
    income_part,
    plan,
    adj_plan_consolidated,
    adj_plan_regional,
    adj_plan_growth_rate,
    execution_consolidated,
    execution_regional,
    growth_rate_regional,
    growth_rate_federal_district,
    growth_rate_russia,
    object_name,
    okato,
    oktmo,
    object_level
)
SELECT
    year,
    month,
    income_level,
    income_part,
    plan,
    adj_plan_consolidated,
    adj_plan_regional,
    adj_plan_growth_rate,
    execution_consolidated,
    execution_regional,
    growth_rate_regional,
    growth_rate_federal_district,
    growth_rate_russia,
    object_name,
    okato,
    oktmo,
    object_level
FROM file('import/data_budget_income_145_v20251224.parquet', 'Parquet');

-- ============================================================
-- 3. Проверочные запросы
-- Эти SELECT просто выведут информацию в консоль при запуске.
-- По ним можно проверить, что данные реально загрузились.
-- ============================================================

SELECT
    'RAW_ROWS_COUNT' AS check_name,
    count() AS value
FROM rk.budget_incomes_raw;

SELECT
    object_level,
    count() AS rows_count
FROM rk.budget_incomes_raw
GROUP BY object_level
ORDER BY rows_count DESC;

SELECT
    income_level,
    income_part,
    count() AS rows_count
FROM rk.budget_incomes_raw
WHERE income_level = 0
GROUP BY
    income_level,
    income_part
ORDER BY rows_count DESC;

-- ============================================================
-- 4. Агрегированная таблица по регионам и месяцам
-- income_level = 0 означает общий доход по всем статьям бюджета.
--
-- Важно:
-- НЕ суммируем все income_part, иначе будет двойной счет,
-- потому что категории доходов имеют иерархию.
-- ============================================================

CREATE TABLE rk.region_month_totals
(
    period Date,
    year UInt16,
    month UInt8,

    object_name LowCardinality(String),
    okato String,
    oktmo String,

    plan Float64,
    adj_plan_regional Float64,
    adj_plan_consolidated Float64,

    execution_regional Float64,
    execution_consolidated Float64
)
ENGINE = SummingMergeTree
PARTITION BY year
ORDER BY (period, object_name);

-- ============================================================
-- 5. Заполнение агрегированной таблицы
--
-- Фильтр по object_level сделан мягко:
-- исключаем страну и федеральные округа,
-- чтобы оставить регионы.
-- ============================================================

INSERT INTO rk.region_month_totals
SELECT
    period,
    year,
    month,
    object_name,
    okato,
    oktmo,

    sum(coalesce(plan, 0)) AS plan,
    sum(coalesce(adj_plan_regional, 0)) AS adj_plan_regional,
    sum(coalesce(adj_plan_consolidated, 0)) AS adj_plan_consolidated,

    sum(coalesce(execution_regional, 0)) AS execution_regional,
    sum(coalesce(execution_consolidated, 0)) AS execution_consolidated
FROM rk.budget_incomes_raw
WHERE income_level = 0
  AND lowerUTF8(object_level) NOT IN
  (
      'страна',
      'country',
      'федеральный округ',
      'federal district',
      'federal_district'
  )
GROUP BY
    period,
    year,
    month,
    object_name,
    okato,
    oktmo;

-- ============================================================
-- 6. Проверка агрегированной таблицы
-- ============================================================

SELECT
    'REGION_MONTH_TOTALS_ROWS_COUNT' AS check_name,
    count() AS value
FROM rk.region_month_totals;

SELECT
    period,
    object_name,
    execution_regional,
    execution_consolidated
FROM rk.region_month_totals
ORDER BY period, execution_regional DESC
LIMIT 20;

-- ============================================================
-- 7. Главная витрина:
-- самый доходный регион по каждому месяцу
-- по региональному бюджету.
-- ============================================================

CREATE VIEW rk.v_top_region_by_month AS
SELECT
    period,
    toYear(period) AS year,
    toMonth(period) AS month,

    argMax(object_name, execution_regional) AS top_region,

    max(execution_regional) AS max_income_thousand_rub,
    round(max(execution_regional) / 1000000, 2) AS max_income_billion_rub
FROM rk.region_month_totals
GROUP BY period;

-- ============================================================
-- 8. Витрина в long-формате:
-- regional / consolidated.
--
-- Она нужна для Superset, чтобы можно было сделать фильтр
-- по типу бюджета.
-- ============================================================

CREATE VIEW rk.v_region_income_long AS
SELECT
    period,
    year,
    month,

    object_name,
    okato,
    oktmo,

    'regional' AS budget_type,

    execution_regional AS income_thousand_rub,
    round(execution_regional / 1000000, 2) AS income_billion_rub
FROM rk.region_month_totals

UNION ALL

SELECT
    period,
    year,
    month,

    object_name,
    okato,
    oktmo,

    'consolidated' AS budget_type,

    execution_consolidated AS income_thousand_rub,
    round(execution_consolidated / 1000000, 2) AS income_billion_rub
FROM rk.region_month_totals;

-- ============================================================
-- 9. Главная витрина для Superset:
-- самый доходный регион по каждому месяцу
-- с учетом типа бюджета.
-- ============================================================

CREATE VIEW rk.v_top_region_by_month_long AS
SELECT
    period,
    year,
    month,
    budget_type,

    argMax(object_name, income_thousand_rub) AS top_region,

    max(income_thousand_rub) AS max_income_thousand_rub,
    round(max(income_thousand_rub) / 1000000, 2) AS max_income_billion_rub
FROM rk.v_region_income_long
GROUP BY
    period,
    year,
    month,
    budget_type;

-- ============================================================
-- 10. Таблица координат регионов для карты
--
-- Сама таблица пустая. Координаты можно добавить отдельно.
-- Для обычного РК это не обязательно, но для плюса к карме пригодится.
-- ============================================================

CREATE TABLE IF NOT EXISTS rk.region_coords
(
    object_name String,
    lat Float64,
    lon Float64
)
ENGINE = MergeTree
ORDER BY object_name;

-- ============================================================
-- 11. Витрина для карты
-- Работает только если заполнить rk.region_coords.
-- ============================================================

CREATE VIEW rk.v_region_income_map AS
SELECT
    i.period,
    i.year,
    i.month,

    i.object_name,
    i.budget_type,

    i.income_thousand_rub,
    i.income_billion_rub,

    c.lat,
    c.lon
FROM rk.v_region_income_long AS i
INNER JOIN rk.region_coords AS c
    ON i.object_name = c.object_name;

-- ============================================================
-- 12. Финальные проверки
-- ============================================================

SELECT
    period,
    top_region,
    max_income_billion_rub
FROM rk.v_top_region_by_month
ORDER BY period
LIMIT 20;

SELECT
    period,
    budget_type,
    top_region,
    max_income_billion_rub
FROM rk.v_top_region_by_month_long
ORDER BY period, budget_type
LIMIT 40;