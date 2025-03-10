/*
marketplace.clients
	client_id номер клиента
	name имя
	surname фамилия
	phone_number номер телефона
	created_dttm дата создания строки
	updated_dttm обновление строки

marketplace.courier (
	courier_id номер курьера
	name имя
	surname фамилия
	courier_type тип курьера
	created_dttm дата создания строки
	updated_dttm обновление строки


marketplace.delivery (
	delivery_id номер доставки
	delivery_status статус доставки
	courier_id номер круьера
	created_dttm дата создания строки
	updated_dttm обновление строки
);

marketplace.items (
	item_id номер товара
	item_desc название заказа
	supplier_id номер поставщика
	created_dttm дата создания строки
	updated_dttm обновление строки
);

marketplace.orders (
	order_id номер заказа
	delivery_id номер доставки
	store_id номер магазина
	client_id номер клиента
	created_dttm дата создания строки
	updated_dttm обновление строки
);

marketplace.orders_details (
	order_id номер заказа
	order_line_id номер линии чека
	item_id номер товара
	qty количество штук в чеке
	"cost" стоимость одной штуки
	created_dttm дата создания строки
	updated_dttm обновление строки
);

marketplace.stores (
	store_id номер магазина
	store_name название магазина
	working_hours рабочие часы
	created_dttm дата создания строки
	updated_dttm обновление строки
);

marketplace.suppliers (
	supplier_id номер поставщика
	supplier_name название поставщика
	created_dttm дата создания строки
	updated_dttm обновление строки
);

*/

-- 1/ Вывести информацию о client_id, name, surname, phone_number
-- 2/ Вывести информацию о client_id, name, surname, phone_number, у которых client_id >= 30
-- 3/ Вывести информацию сколько было потрачено в каждом заказе на один item_id
-- 4/ Вывести информацию сколько стоил каждый заказ
-- 5/ Вывести фамилию клиента и его номер заказа
-- 6/ Вывести курьера и его количество заказа
-- 7/ Вывести магазин и его количество заказа
-- 8/ Вывести курьеров и их количество заказа в статусе "Delivered"
-- 9/ Вывести курьера, у которого наибольшее количество заказов в статусе "Delivered"
-- 10/ Вывести клиента с наименьшей суммой заказа