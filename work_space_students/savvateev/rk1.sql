-- task 1 Вывести информацию о client_id, name, surname, phone_number
SELECT client_id, name, surname, phone_number
FROM marketplace.clients;

-- task 2 Вывести информацию о client_id, name, surname, phone_number, у которых client_id >= 30
SELECT client_id, name, surname, phone_number
FROM marketplace.clients
WHERE client_id >= 30;

-- task 3 Вывести информацию сколько было потрачено в каждом заказе на один item_id
SELECT order_id, item_id, SUM(cost)
FROM marketplace.orders_details
GROUP BY order_id, item_id;

-- task 4 Вывести информацию сколько стоил каждый заказ
SELECT order_id, SUM(qty * cost) AS order_total
FROM marketplace.orders_details
GROUP BY order_id;

-- task 5 Вывести фамилию клиента и его номер заказа
SELECT c.surname, o.order_id
FROM marketplace.orders AS o
JOIN marketplace.clients c ON c.client_id = o.client_id;

-- task 6 Вывести курьера и его количество заказа
SELECT c.name, c.surname, COUNT(o.order_id) FROM marketplace.delivery AS d
    JOIN marketplace.courier AS c ON c.courier_id = d.courier_id
    JOIN marketplace.orders AS o ON d.delivery_id = o.delivery_id
GROUP BY c.courier_id;

-- task 7 Вывести магазин и его количество заказа
SELECT s.store_name, COUNT(o.order_id)
FROM marketplace.stores AS s
JOIN marketplace.orders o ON s.store_id = o.store_id
GROUP BY s.store_id;

-- task 8 Вывести курьеров и их количество заказа в статусе "Delivered"
SELECT c.name, c.surname, COUNT(o.order_id) FROM marketplace.courier AS c
    JOIN marketplace.delivery AS d ON c.courier_id = d.courier_id
    JOIN marketplace.orders AS o ON d.delivery_id = o.delivery_id
WHERE o.order_status = 'DELIVERED'
GROUP BY c.courier_id;

-- task 9 Вывести курьера(courier_id, name, surname), у которого наибольшее количество заказов в статусе "Delivered"
SELECT *
FROM (
    SELECT c.courier_id, c.name, c.surname, RANK() OVER (ORDER BY COUNT(o.order_id) DESC) AS rnk
    FROM marketplace.courier AS c
    JOIN marketplace.delivery AS d ON c.courier_id = d.courier_id
    JOIN marketplace.orders AS o ON d.delivery_id = o.delivery_id
    WHERE o.order_status = 'DELIVERED'
    GROUP BY c.courier_id
) ranked
WHERE rnk = 1;

-- task 10 Вывести клиента(client_id, surname, name) с наименьшей суммой заказа
SELECT client_id, surname, name
  FROM (
      SELECT c.client_id, c.surname, c.name,
             SUM(o2.cost) OVER (PARTITION BY c.client_id) AS total_spent,
             RANK() OVER (ORDER BY SUM(o2.cost) ASC) AS rnk
      FROM marketplace.clients c
      JOIN marketplace.orders o ON c.client_id = o.client_id
      JOIN marketplace.orders_details o2 ON o.order_id = o2.order_id
  ) ranked
  WHERE rnk = 1;


-- EXTRA TASK 1 Создайте таблицу, у которой будет 5 колонок, 1 из которых будет первичным ключом.
CREATE TABLE IF NOT EXISTS node (
    node_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    description TEXT CONSTRAINT node_description_length CHECK (LEN(description) < 256) NOT NULL,
    type TEXT NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- EXTRA TASK 2 Создайте вторую таблицу, у которой будет первичный ключ и внешний ключ на ранее созданную таблицу.
CREATE TABLE IF NOT EXISTS edge (
    edge_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    node_from BIGINT REFERENCES node(node_id),
    node_to BIGINT REFERENCES node(node_id),
    description TEXT CONSTRAINT edge_description_length CHECK (LEN(description) < 256)
);