-- добавление колонки
alter table users add column region smallint;

-- удаление колонки
alter table users drop column region;


alter table order_head 
add constraint fk_users_user_id
foreign key (user_id)
references users (id);
