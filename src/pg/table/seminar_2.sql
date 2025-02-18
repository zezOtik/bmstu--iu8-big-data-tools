CREATE TABLE src_store.order_details (
	order_details_id int8 NOT NULL,
	sku_id int8 NULL,
	order_id int8 NULL,
	created_date timestamp NOT NULL,
	updated_date timestamp NOT NULL,
	deleted_date timestamp NULL,
	CONSTRAINT order_details_pkey PRIMARY KEY (order_details_id),
	CONSTRAINT order_details_order_id_fkey FOREIGN KEY (order_id) REFERENCES src_store.order_head(order_id)
);


CREATE TABLE src_store.sku_desc (
	sku_id int8 NOT NULL,
	sku_desc text NULL,
	created_date timestamp NOT NULL,
	updated_date timestamp NOT NULL,
	deleted_date timestamp NULL,
	CONSTRAINT sku_desc_pkey PRIMARY KEY (sku_id)
);


CREATE TABLE src_store.store (
	store_id int8 NOT NULL,
	store_name text NULL,
	working_hours interval NULL,
	opened_date timestamp NOT NULL,
	closed_date timestamp NULL,
	CONSTRAINT store_pkey PRIMARY KEY (store_id)
);


CREATE TABLE src_store.users (
	id int8 NOT NULL,
	"name" text NULL,
	surname text NULL,
	phone_number text NULL,
	address text NULL,
	created_dttm timestamp NULL,
	updated_dttm timestamp NULL,
	region int2 NULL,
	CONSTRAINT users_pkey PRIMARY KEY (id)
);

CREATE TABLE src_store.order_head (
	order_id int8 NOT NULL,
	order_desc text NULL,
	user_id int8 NULL,
	store_id int8 NULL,
	store_name text NULL,
	created_date timestamp NOT NULL,
	updated_date timestamp NOT NULL,
	deleted_date timestamp NULL,
	sku_id int8 NULL,
	CONSTRAINT order_head_pkey PRIMARY KEY (order_id),
	CONSTRAINT fk_sku_id FOREIGN KEY (sku_id) REFERENCES src_store.sku_desc(sku_id),
	CONSTRAINT fk_store_id FOREIGN KEY (store_id) REFERENCES src_store.store(store_id),
	CONSTRAINT order_head_user_id_fkey FOREIGN KEY (user_id) REFERENCES src_store.users(id)
);




INSERT INTO src_store.users (id, "name", surname, phone_number, address, created_dttm, updated_dttm, region)
VALUES
(1, 'Иван', 'Иванов', '+79001234567', 'Москва, ул. Пушкина, д. 10', NOW(), NOW(), 1),
(2, 'Петр', 'Петров', '+79012345678', 'Санкт-Петербург, ул. Ленина, д. 5', NOW(), NOW(), 2),
(3, 'Анна', 'Сидорова', '+79023456789', 'Новосибирск, ул. Кирова, д. 25', NOW(), NOW(), 3),
(4, 'Ольга', 'Кузнецова', '+79034567890', 'Екатеринбург, ул. Мира, д. 15', NOW(), NOW(), 4),
(5, 'Дмитрий', 'Васильев', '+79045678901', 'Казань, ул. Баумана, д. 8', NOW(), NOW(), 5);






INSERT INTO src_store.store (store_id, store_name, working_hours, opened_date, closed_date)
VALUES
(1, 'Магазин №1', INTERVAL '12 hours', '2020-01-15 08:00:00', NULL),
(2, 'Магазин №2', INTERVAL '10 hours', '2020-03-20 09:00:00', NULL),
(3, 'Магазин №3', INTERVAL '8 hours', '2020-05-10 10:00:00', '2022-12-31 22:00:00'),
(4, 'Магазин №4', INTERVAL '14 hours', '2021-01-01 07:00:00', NULL),
(5, 'Магазин №5', INTERVAL '16 hours', '2021-06-15 06:00:00', NULL),
(6, 'Магазин №6', INTERVAL '12 hours', '2022-02-20 08:00:00', '2023-01-15 20:00:00'),
(7, 'Магазин №7', INTERVAL '10 hours', '2022-04-10 09:00:00', NULL),
(8, 'Магазин №8', INTERVAL '8 hours', '2022-08-25 10:00:00', NULL),
(9, 'Магазин №9', INTERVAL '14 hours', '2023-01-01 07:00:00', NULL),
(10, 'Магазин №10', INTERVAL '16 hours', '2023-03-15 06:00:00', '2023-10-31 22:00:00');





INSERT INTO src_store.sku_desc (sku_id, sku_desc, created_date, updated_date, deleted_date)
VALUES
(1, 'Описание товара №1', '2023-01-15 10:00:00', '2023-09-01 14:00:00', NULL),
(2, 'Описание товара №2', '2023-02-20 11:00:00', '2023-09-02 15:00:00', NULL),
(3, 'Описание товара №3', '2023-03-10 12:00:00', '2023-09-03 16:00:00', '2023-10-01 18:00:00'),
(4, 'Описание товара №4', '2023-04-05 13:00:00', '2023-09-04 17:00:00', NULL),
(5, 'Описание товара №5', '2023-05-15 14:00:00', '2023-09-05 18:00:00', NULL),
(6, 'Описание товара №6', '2023-06-20 15:00:00', '2023-09-06 19:00:00', '2023-10-15 20:00:00'),
(7, 'Описание товара №7', '2023-07-10 16:00:00', '2023-09-07 20:00:00', NULL),
(8, 'Описание товара №8', '2023-08-05 17:00:00', '2023-09-08 21:00:00', NULL),
(9, 'Описание товара №9', '2023-09-15 18:00:00', '2023-09-09 22:00:00', '2023-11-01 23:00:00'),
(10, 'Описание товара №10', '2023-10-20 19:00:00', '2023-09-10 23:00:00', NULL);

