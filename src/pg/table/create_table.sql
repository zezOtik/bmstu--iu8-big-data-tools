-- создание таблицы
CREATE TABLE users
(
    id bigint,
    name text,
    surname text,
    phone_number text,
    address text,
    created_dttm timestamp,
    updated_dttm timestamp
);




CREATE TABLE src_store.order_details (
order_details_id bigint PRIMARY key,
sku_id bigint,
order_id bigint REFERENCES src_store.order_head (order_id),
created_date timestamp not null,
updated_date timestamp not null,
deleted_date timestamp null
);
