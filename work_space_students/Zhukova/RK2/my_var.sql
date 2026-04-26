--Удаляем если есть
DROP TABLE IF EXISTS budget_incomes;
DROP TABLE IF EXISTS budget_top;

--Основная таблица
CREATE TABLE budget_incomes (
    year UInt16,
    month UInt8,
    income_level UInt8,
    income_part String,
    plan Float64,
    adj_plan_consolidated Float64,
    adj_plan_regional Float64,
    adj_plan_growth_rate Nullable(Float64),
    execution_consolidated Float64,
    execution_regional Float64,
    growth_rate_regional Nullable(Float64),
    growth_rate_federal_district Nullable(Float64),
    growth_rate_russia Nullable(Float64),
    object_name String,
    okato UInt32,
    oktmo UInt32,
    object_level String
)
ENGINE = MergeTree
PARTITION BY year
ORDER BY (object_name, income_part, income_level);
-- загрузка данных 
INSERT INTO budget_incomes
SELECT *
FROM file('/var/lib/clickhouse/user_files/import/data_budget_income_145_v20251224.parquet', Parquet);

-- Витрина
CREATE TABLE budget_top
ENGINE = SummingMergeTree --для каждого года, месяца и статьи все числовые колонки (total_income) будут автоматически складываться 
PARTITION BY year
ORDER BY (year, month, income_part)
AS
SELECT
    year,
    month,
    income_part,
    sum(execution_regional) AS total_income
FROM budget_incomes
WHERE income_level != 0
GROUP BY
    year, month, income_part;

-- Проверка
SELECT count() FROM budget_top;