-- 1/ Вывести информацию о client_id, name, surname, phone_number
SELECT
    client_id,
    name,
    surname,
    phone_number
FROM marketplace.clients;

-- 2/ Вывести информацию о client_id, name, surname, phone_number, у которых client_id >= 30
SELECT
    client_id,
    name,
    surname,
    phone_number
FROM marketplace.clients
WHERE client_id >= 30;

-- 3/ Вывести информацию сколько было потрачено в каждом заказе на один item_id
SELECT
    order_id,
    item_id,
    SUM(cost * qty) as total_spent
FROM marketplace.orders_details
GROUP BY order_id, item_id
ORDER BY order_id, item_id;

-- 4/ Вывести информацию сколько стоил каждый заказ
SELECT
    order_id,
    SUM(qty * cost) AS order_total
FROM marketplace.orders_details
GROUP BY order_id
ORDER BY order_id;

-- 5/ Вывести фамилию клиента и его номер заказа
SELECT
    c.surname,
    o.order_id
FROM marketplace.clients c
INNER JOIN marketplace.orders o ON c.client_id = o.client_id
ORDER BY c.client_id, o.order_id;

-- 6/ Вывести курьера и его количество заказа
SELECT
    cr.courier_id,
    cr.name,
    cr.surname,
    COUNT(o.order_id) AS order_count
FROM marketplace.courier cr
LEFT JOIN marketplace.delivery d ON cr.courier_id = d.courier_id
LEFT JOIN marketplace.orders o ON d.delivery_id = o.delivery_id
GROUP BY cr.courier_id, cr.name, cr.surname
ORDER BY order_count DESC;

-- 7/ Вывести магазин и его количество заказа
SELECT
    s.store_id,
    s.store_name,
    COUNT(o.order_id) AS order_count
FROM marketplace.stores s
LEFT JOIN marketplace.orders o ON s.store_id = o.store_id
GROUP BY s.store_id, s.store_name
ORDER BY order_count DESC;

-- 8/ Вывести курьеров и их количество заказа в статусе "Delivered"
SELECT
    cr.courier_id,
    cr.name,
    cr.surname,
    COUNT(o.order_id) AS delivered_count
FROM marketplace.courier cr
INNER JOIN marketplace.delivery d ON cr.courier_id = d.courier_id
INNER JOIN marketplace.orders o ON d.delivery_id = o.delivery_id
WHERE d.delivery_status = 'DELIVERED'
GROUP BY cr.courier_id, cr.name, cr.surname
ORDER BY delivered_count DESC;

-- 9/ Вывести курьера(courier_id, name, surname), у которого наибольшее количество заказов в статусе "Delivered"
SELECT
    cr.courier_id,
    cr.name,
    cr.surname,
    COUNT(o.order_id) AS delivered_count
FROM marketplace.courier cr
INNER JOIN marketplace.delivery d ON cr.courier_id = d.courier_id
INNER JOIN marketplace.orders o ON d.delivery_id = o.delivery_id
WHERE d.delivery_status = 'DELIVERED'
GROUP BY cr.courier_id, cr.name, cr.surname
ORDER BY delivered_count DESC
LIMIT 1;

-- 10/ Вывести клиента(client_id, surname, name) с наименьшей суммой заказа
SELECT
    c.client_id,
    c.surname,
    c.name,
    SUM(od.qty * od.cost) AS total_spent
FROM marketplace.clients c
INNER JOIN marketplace.orders o ON c.client_id = o.client_id
INNER JOIN marketplace.orders_details od ON o.order_id = od.order_id
GROUP BY c.client_id, c.surname, c.name
ORDER BY total_spent ASC
LIMIT 1;

-- 1/ Создайте таблицу, у которой будет 5 колонок, 1 из которых будет первичным ключом
CREATE TABLE IF NOT EXISTS marketplace.example_table (
    example_id     BIGSERIAL PRIMARY KEY,
    first_name     VARCHAR(100) NOT NULL,
    last_name      VARCHAR(100) NOT NULL,
    email          VARCHAR(255),
    created_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2/ Создайте вторую таблицу, у которой будет первичный ключ и внешний ключ на ранее созданную таблицу
CREATE TABLE IF NOT EXISTS marketplace.example_details (
    detail_id      BIGSERIAL PRIMARY KEY,
    example_id     BIGINT NOT NULL,
    description    TEXT,
    value          NUMERIC(10, 2),
    created_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_example_details FOREIGN KEY (example_id) 
        REFERENCES marketplace.example_table(example_id)
        ON DELETE CASCADE
);