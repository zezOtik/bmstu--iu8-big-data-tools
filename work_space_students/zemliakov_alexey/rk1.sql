-- task 1 Вывести информацию о client_id, name, surname, phone_number
SELECT client_id, name, surname, phone_number FROM marketplace.clients;

-- task 2 Вывести информацию о client_id, name, surname, phone_number, у которых client_id >= 30
SELECT client_id, name, surname, phone_number FROM marketplace.clients WHERE client_id >= 30;

-- task 3 Вывести информацию сколько было потрачено в каждом заказе на один item_id
SELECT order_id, item_id, SUM(cost) FROM marketplace.orders_details GROUP BY order_id, item_id;

-- task 4 Вывести информацию сколько стоил каждый заказ
SELECT order_id, SUM(qty * cost) AS order_total FROM marketplace.orders_details GROUP BY order_id;

-- task 5 Вывести фамилию клиента и его номер заказа
SELECT c.surname, o.order_id FROM marketplace.orders as o JOIN marketplace.clients c on c.client_id = o.client_id;

-- task 6 Вывести курьера и его количество заказа
SELECT c.name, c.surname, COUNT(o.order_id) FROM marketplace.delivery as d
    join marketplace.courier as c on c.courier_id = d.courier_id
    join marketplace.orders as o on d.delivery_id = o.delivery_id
    GROUP BY c.courier_id;

-- task 7 Вывести магазин и его количество заказа
SELECT s.store_name, count(o.order_id) FROM marketplace.stores as s join marketplace.orders o on s.store_id = o.store_id GROUP BY s.store_id;

-- task 8 Вывести курьеров и их количество заказа в статусе "Delivered"
SELECT c.name, c.surname, COUNT(o.order_id) FROM marketplace.courier AS c
    JOIN marketplace.delivery AS d ON c.courier_id = d.courier_id
    JOIN marketplace.orders  AS o ON d.delivery_id = o.delivery_id
WHERE o.order_status = 'DELIVERED'
GROUP BY c.courier_id;

-- task 9 Вывести курьера(courier_id, name, surname), у которого наибольшее количество заказов в статусе "Delivered"
SELECT c.courier_id, c.name, c.surname FROM marketplace.courier as c
    join marketplace.delivery d on c.courier_id = d.courier_id
    join marketplace.orders o on d.delivery_id = o.delivery_id WHERE d.delivery_status='DELIVERED' group by c.courier_id
                                                    ORDER BY COUNT(o.order_id) DESC LIMIT 1;

-- task 10 Вывести клиента(client_id, surname, name) с наименьшей суммой заказа
SELECT c.client_id, c.surname, c.name FROM marketplace.clients as c
    join marketplace.orders as o on o.client_id = c.client_id
    join marketplace.orders_details as o2 on o.order_id = o2.order_id
    GROUP BY o.order_id, c.client_id, c.surname, c.name
ORDER BY SUM(o2.cost) ASC LIMIT 1;


-- EXTRA TASK 1 Создайте таблицу, у которой будет 5 колонок, 1 из которых будет первичным ключом.
CREATE TABLE IF NOT EXISTS book(
                                   book_id      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                                   name           VARCHAR(100) NOT NULL,
                                   author          VARCHAR(100),
                                   created_dttm   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                   updated_dttm   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- EXTRA TASK 2 Создайте вторую таблицу, у которой будет первичный ключ и внешний ключ на ранее созданную таблицу.
CREATE TABLE IF NOT EXISTS booking (
                                        booking_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                                        book_id BIGINT NOT NULL,
                                       start_booking_dttm   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                       end_booking_dttm   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                        CONSTRAINT fk_booking_book FOREIGN KEY (book_id) REFERENCES book(book_id)

);