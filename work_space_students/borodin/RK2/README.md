# RK2: доходы региональных бюджетов

Вариант 1. Нужно загрузить датасет Tochno `budget_incomes` в ClickHouse и построить сводку: самый доходный регион по всем статьям бюджета на каждый месяц.

Источник: <https://tochno.st/datasets/budget_incomes>. На странице указано: обновление `25.12.2025`, период `2015-2025`, CSV в `UTF-8`, разделитель `;`.

## Файлы

- `prepare_data.py` - потоковая подготовка CSV/ZIP для ClickHouse.
- `rk2_clickhouse.sql` - создание базы, таблицы и витрин.
- `data/raw/` - сюда положить скачанный CSV или ZIP с CSV.
- `data/prepared/` - сюда скрипт сохранит подготовленный CSV.

Большие файлы данных не коммитятся.

## Подготовка данных

Скачать CSV на странице датасета и положить файл в `data/raw/`, например:

```bash
cd work_space_students/borodin/RK2
python3 prepare_data.py \
  --input data/raw/budget_incomes.csv \
  --output data/prepared/budget_incomes_prepared.csv
```

Если сайт скачал архив, можно передать ZIP напрямую:

```bash
python3 prepare_data.py \
  --input data/raw/budget_incomes.zip \
  --output data/prepared/budget_incomes_prepared.csv
```

Скрипт сам определяет ключевые колонки по нормализованным русским/английским названиям. Основная метрика: `Исполнено на первое число следующего месяца (бюджет региона)`. Поддерживаются оба формата: отдельная колонка с этой метрикой или пара `Показатель` + `Значение`. Строки по РФ в целом и федеральным округам отбрасываются, чтобы в рейтинге оставались только регионы.

## Загрузка в ClickHouse

Скопировать подготовленный файл в import-директорию существующего стенда:

```bash
cp data/prepared/budget_incomes_prepared.csv ../../../folder_docker/clickhouse/import/
cd ../../../folder_docker/clickhouse
docker compose up -d
docker exec -i clickhouse-server clickhouse-client --password secret_password < ../../work_space_students/borodin/RK2/rk2_clickhouse.sql
```

Проверочные запросы:

```sql
SELECT count() AS raw_rows, min(period), max(period)
FROM rk2_borodin.budget_incomes_raw;

SELECT *
FROM rk2_borodin.v_top_region_by_month
ORDER BY period
LIMIT 12;

SELECT period, count() AS winners
FROM rk2_borodin.v_top_region_by_month
GROUP BY period
HAVING winners != 1;
```

Последний запрос должен вернуть пустой результат.

## Витрины

- `rk2_borodin.budget_incomes_raw` - подготовленные строки исходного датасета.
- `rk2_borodin.v_region_month_income` - доход региона за месяц.
- `rk2_borodin.v_region_month_income_ranked` - регионы с рангом внутри месяца.
- `rk2_borodin.v_top_region_by_month` - один победитель на каждый месяц.

Логика против двойного счета: если в месяце у региона есть общая статья доходов, используется она. Если общей статьи нет, суммируются только leaf-статьи по коду дохода.

## Superset

Открыть Superset: <http://localhost:8088>, логин/пароль `admin` / `admin`.

Подключение ClickHouse:

```text
clickhousedb://default:secret_password@clickhouse-server:8123/rk2_borodin
```

Рекомендуемые графики:

- `v_top_region_by_month`: line/bar chart, X = `period`, metric = `executed_region_amount`, series = `region_name`.
- `v_region_month_income_ranked`: bar chart top-N регионов за выбранный месяц, фильтр `income_rank <= 10`.
- Фильтры: `year`, `month`, `region_name`.
- Опционально карта: подключить таблицу координат регионов и использовать `v_region_month_income_ranked` как слой значений по региону.
