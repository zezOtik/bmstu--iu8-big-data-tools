-- обновляем информацию по регионам
update users
set region = (random() * 100 + 1)::int