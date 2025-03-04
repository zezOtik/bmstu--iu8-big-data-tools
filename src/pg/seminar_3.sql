create schema marketplace;

set search_path to marketplace; 

create table orders (
order_id bigint,
delivery_id bigint,
store_id integer,
client_id bigint,
created_dttm timestamp without time zone,
updated_dttm timestamp without time zone
);

create table stores (
store_id integer,
store_name integer,
working_hours text,
created_dttm timestamp without time zone,
updated_dttm timestamp without time zone
);

create table orders_details (
order_id bigint,
order_line_id integer,
item_id bigint,
qty numeric,
cost numeric,
created_dttm timestamp without time zone,
updated_dttm timestamp without time zone
);

create table items (
item_id bigint,
item_desc text,
supplier_id bigint,
created_dttm timestamp without time zone,
updated_dttm timestamp without time zone
);

create table suppliers(
supplier_id bigint,
supplier_name text,
created_dttm timestamp without time zone,
updated_dttm timestamp without time zone
);


create table delivery (
delivery_id bigint,
delivery_status text,
courier_id bigint,
created_dttm timestamp without time zone,
updated_dttm timestamp without time zone
);


create table clients (
client_id bigint,
name text,
surname text,
phone_number text,
created_dttm timestamp without time zone,
updated_dttm timestamp without time zone
);


create table courier (
courier_id bigint,
name text,
surname text,
courier_type integer,
created_dttm timestamp without time zone,
updated_dttm timestamp without time zone
);



-------------------- вставка

INSERT INTO orders (order_id, delivery_id, store_id, client_id, created_dttm, updated_dttm)
SELECT 
    s AS order_id, -- Уникальный order_id от 1 до 100
    floor(random() * 75 + 1)::bigint AS delivery_id, -- Random delivery_id от 1 до 75
    floor(random() * 5 + 1)::integer AS store_id, -- Random store_id от 1 до 5
    floor(random() * 40 + 1)::bigint AS client_id, -- Random client_id от 1 до 40
    now() AS created_dttm, -- Текущее время
    now() AS updated_dttm -- Текущее время
FROM generate_series(1, 100) AS s;


INSERT INTO stores (store_id, store_name, working_hours, created_dttm, updated_dttm)
SELECT 
    s AS store_id, -- Уникальный store_id от 1 до 5
    floor(random() * 100 + 1)::integer AS store_name, -- Random store_name от 1 до 100
    CASE 
        WHEN s = 1 THEN '08:00 - 22:00'
        WHEN s = 2 THEN '09:00 - 21:00'
        WHEN s = 3 THEN '10:00 - 23:00'
        WHEN s = 4 THEN '07:00 - 20:00'
        WHEN s = 5 THEN '08:30 - 22:30'
    END AS working_hours, -- Разные часы работы для каждого магазина
    now() AS created_dttm, -- Текущее время
    now() AS updated_dttm -- Текущее время
FROM generate_series(1, 5) AS s;



-- Создаем временную таблицу для хранения стоимости (cost) каждого item_id
DROP TABLE IF EXISTS temp_item_cost;
CREATE TEMP TABLE temp_item_cost (
    item_id bigint,
    cost numeric
);

-- Заполняем временные данные для стоимости каждого item_id (случайные значения от 1 до 100)
INSERT INTO temp_item_cost (item_id, cost)
SELECT 
    s AS item_id,
    floor(random() * 99 + 1)::numeric AS cost -- Случайное значение cost от 1 до 100
FROM generate_series(1, 50) AS s;


DROP TABLE IF EXISTS tt_raw_data;
create temp table tt_raw_data as (
select
	ceil(random() * 100)::bigint AS order_id, -- Random order_id от 1 до 100
    ceil(random() * 50)::bigint AS item_id,   -- Random item_id от 1 до 50
    ceil(random() * 10)::numeric AS qty      -- Random qty от 1 до 10
from generate_series(1, 400) AS s
);

insert into orders_details (order_id, order_line_id, item_id, qty, cost, created_dttm, updated_dttm)
select
	td.order_id,
	row_number() OVER (PARTITION BY td.order_id ORDER BY td.item_id) AS order_line_id,
	td.item_id,
	td.qty,
	tic.cost,
	now() AS created_dttm, -- Текущее время
    now() AS updated_dttm  -- Текущее время
from tt_raw_data td
inner join temp_item_cost tic using(item_id)
;

DROP TABLE IF EXISTS tt_raw_data;

INSERT INTO items (item_id, item_desc, supplier_id, created_dttm, updated_dttm)
SELECT 
    s AS item_id, -- Уникальный item_id от 1 до 50
    'Item Description ' || s AS item_desc, -- Простое описание товара с номером
    floor(random() * 20 + 1)::bigint AS supplier_id, -- Random supplier_id от 1 до 20
    now() AS created_dttm, -- Текущее время
    now() AS updated_dttm -- Текущее время
FROM generate_series(1, 50) AS s;


INSERT INTO suppliers (supplier_id, supplier_name, created_dttm, updated_dttm)
SELECT 
    s AS supplier_id, -- Уникальный supplier_id от 1 до 20
    'Supplier ' || s AS supplier_name, -- Название поставщика с номером
    now() AS created_dttm, -- Текущее время
    now() AS updated_dttm -- Текущее время
FROM generate_series(1, 20) AS s;

INSERT INTO delivery (delivery_id, delivery_status, courier_id, created_dttm, updated_dttm)
SELECT 
    s AS delivery_id, -- Уникальный delivery_id от 1 до 75
    CASE 
        WHEN s % 4 = 0 THEN 'Delivered'       -- Каждый четвертый заказ доставлен
        WHEN s % 3 = 0 THEN 'In Transit'      -- Каждый третий заказ в пути
        ELSE 'Pending'                        -- Остальные заказы ожидают доставки
    END AS delivery_status, 
    floor(random() * 20 + 1)::bigint AS courier_id, -- Random courier_id от 1 до 20
    now() AS created_dttm, -- Текущее время
    now() AS updated_dttm -- Текущее время
FROM generate_series(1, 75) AS s;


INSERT INTO clients (client_id, name, surname, phone_number, created_dttm, updated_dttm)
SELECT 
    s AS client_id, -- Уникальный client_id от 1 до 40
    CASE 
        WHEN s % 4 = 0 THEN 'John' 
        WHEN s % 3 = 0 THEN 'Anna'
        WHEN s % 2 = 0 THEN 'Michael'
        ELSE 'David'
    END AS name, -- Пример имен клиентов
    CASE 
        WHEN s % 5 = 0 THEN 'Smith'
        WHEN s % 4 = 0 THEN 'Johnson'
        WHEN s % 3 = 0 THEN 'Williams'
        WHEN s % 2 = 0 THEN 'Brown'
        ELSE 'Taylor'
    END AS surname, -- Пример фамилий клиентов
    '+79' || lpad(floor(random() * 1000000000)::text, 9, '0') AS phone_number, -- Генерация случайного номера телефона
    now() AS created_dttm, -- Текущее время
    now() AS updated_dttm -- Текущее время
FROM generate_series(1, 40) AS s;


INSERT INTO courier (courier_id, name, surname, courier_type, created_dttm, updated_dttm)
SELECT 
    s AS courier_id, -- Уникальный courier_id от 1 до 20
    CASE 
        WHEN s % 4 = 0 THEN 'John'
        WHEN s % 3 = 0 THEN 'Anna'
        WHEN s % 2 = 0 THEN 'Michael'
        ELSE 'David'
    END AS name, -- Пример имен курьеров
    CASE 
        WHEN s % 5 = 0 THEN 'Smith'
        WHEN s % 4 = 0 THEN 'Johnson'
        WHEN s % 3 = 0 THEN 'Williams'
        WHEN s % 2 = 0 THEN 'Brown'
        ELSE 'Taylor'
    END AS surname, -- Пример фамилий курьеров
    CASE 
        WHEN s % 2 = 0 THEN 1 -- Тип курьера 1 (например, велосипедист)
        ELSE 2               -- Тип курьера 2 (например, автомобилист)
    END AS courier_type, -- Тип курьера
    now() AS created_dttm, -- Текущее время
    now() AS updated_dttm -- Текущее время
FROM generate_series(1, 20) AS s;
