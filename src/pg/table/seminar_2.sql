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
