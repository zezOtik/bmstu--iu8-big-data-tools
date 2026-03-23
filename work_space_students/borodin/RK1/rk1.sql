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
    SUM(qty * "cost") AS total_spent_on_item
FROM marketplace.orders_details
GROUP BY order_id, item_id;

-- 4/ Вывести информацию сколько стоил каждый заказ
SELECT 
    order_id, 
    SUM(qty * "cost") AS order_total_cost
FROM marketplace.orders_details
GROUP BY order_id;

-- 5/ Вывести фамилию клиента и его номер заказа
SELECT 
    c.surname, 
    o.order_id
FROM marketplace.clients c
JOIN marketplace.orders o ON c.client_id = o.client_id;

-- 6/ Вывести курьера и его количество заказа
-- Путь: courier -> delivery -> orders
SELECT 
    cour.courier_id,
    cour.name,
    cour.surname,
    COUNT(o.order_id) AS order_count
FROM marketplace.courier cour
JOIN marketplace.delivery d ON cour.courier_id = d.courier_id
JOIN marketplace.orders o ON d.delivery_id = o.delivery_id
GROUP BY cour.courier_id, cour.name, cour.surname;

-- 7/ Вывести магазин и его количество заказа
SELECT 
    s.store_name,
    COUNT(o.order_id) AS order_count
FROM marketplace.stores s
JOIN marketplace.orders o ON s.store_id = o.store_id
GROUP BY s.store_name;

-- 8/ Вывести курьеров и их количество заказа в статусе "Delivered"
SELECT 
    cour.courier_id,
    cour.name,
    cour.surname,
    COUNT(o.order_id) AS delivered_order_count
FROM marketplace.courier cour
JOIN marketplace.delivery d ON cour.courier_id = d.courier_id
JOIN marketplace.orders o ON d.delivery_id = o.delivery_id
WHERE d.delivery_status = 'Delivered'
GROUP BY cour.courier_id, cour.name, cour.surname;

-- 9/ Вывести курьера(courier_id, name, surname), у которого наибольшее количество заказов в статусе "Delivered"
SELECT 
    cour.courier_id,
    cour.name,
    cour.surname,
    COUNT(o.order_id) AS delivered_order_count
FROM marketplace.courier cour
JOIN marketplace.delivery d ON cour.courier_id = d.courier_id
JOIN marketplace.orders o ON d.delivery_id = o.delivery_id
WHERE d.delivery_status = 'Delivered'
GROUP BY cour.courier_id, cour.name, cour.surname
ORDER BY delivered_order_count DESC
LIMIT 1;

-- 10/ Вывести клиента(client_id, surname, name) с наименьшей суммой заказа
-- Подразумевается общая сумма всех заказов клиента (LTV)
SELECT 
    c.client_id,
    c.surname,
    c.name,
    SUM(od.qty * od."cost") AS total_spent
FROM marketplace.clients c
JOIN marketplace.orders o ON c.client_id = o.client_id
JOIN marketplace.orders_details od ON o.order_id = od.order_id
GROUP BY c.client_id, c.surname, c.name
ORDER BY total_spent ASC
LIMIT 1;
